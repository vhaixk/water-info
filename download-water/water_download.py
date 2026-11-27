import io
import logging
import os
import re
import threading
import time

import numpy as np
import openpyxl
from PIL import Image
from selenium import webdriver
from selenium.common.exceptions import TimeoutException, WebDriverException
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

logger = logging.getLogger(__name__)


class CrawlError(Exception):
    """带错误码与可重试标记的爬取失败，供分发层决定重发还是放弃。

    retryable=True：空表/超时/浏览器网络类瞬时故障，重试可能恢复；
    retryable=False：代码/数据类内部错误，重试无意义。
    """

    def __init__(self, message, code, retryable):
        super().__init__(message)
        self.code = code
        self.retryable = retryable


# 截图窗口高度（CSS 像素）。站点只解密渲染进入视口的行，
# 故按行索引分区滚动截图，每屏裁取视口内完整行
WINDOW_HEIGHT = int(os.getenv("WINDOW_HEIGHT", "909"))
# 截图分辨率倍率：2x 让小字更清晰，显著提升 OCR 准确率
CAPTURE_SCALE = int(os.getenv("CAPTURE_SCALE", "2"))
# 表格加载稳定等待窗口（秒）：生产服务器响应可能较慢，默认放宽到 120 秒
TABLE_STABLE_TIMEOUT = int(os.getenv("TABLE_STABLE_TIMEOUT", "120"))

# OCR 识别引擎：懒加载单例，推理非线程安全，用锁保护。
# 逐格识别只用 rec（不做检测/表格结构），列对齐由 DOM 几何保证
_engine_lock = threading.Lock()
_rec_engine = None


def _get_rec_engine():
    """按 OCR_DEVICE（cpu/cuda/dml）初始化 rec-only 引擎，默认 server 模型。"""
    global _rec_engine
    with _engine_lock:
        if _rec_engine is None:
            from rapidocr import RapidOCR
            from rapidocr.utils.typings import ModelType, OCRVersion

            device = os.getenv("OCR_DEVICE", "cpu").lower()
            params = {
                "Global.use_det": False,
                "Global.use_cls": False,
                "Rec.model_type": ModelType(os.getenv("OCR_REC_MODEL", "mobile")),
                "Rec.ocr_version": OCRVersion(os.getenv("OCR_REC_VERSION", "PP-OCRv5")),
            }
            if device == "cuda":
                params["EngineConfig.onnxruntime.use_cuda"] = True
                params["EngineConfig.onnxruntime.cuda_ep_cfg.device_id"] = int(
                    os.getenv("OCR_GPU_ID", "0")
                )
            elif device == "dml":
                params["EngineConfig.onnxruntime.use_dml"] = True
            logger.info("初始化 OCR 识别引擎, device=%s, rec=%s/%s",
                        device, params["Rec.ocr_version"].value, params["Rec.model_type"].value)
            _rec_engine = RapidOCR(params=params)
    return _rec_engine


chrome_options = Options()
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
chrome_options.add_argument('--headless=new')
chrome_options.add_argument(f'--force-device-scale-factor={CAPTURE_SCALE}')
# 站点仅支持 HTTP：新版 Chrome 自动 HTTPS 升级会导致加载被拦（ERR_BLOCKED_BY_CLIENT）
chrome_options.add_argument(
    '--disable-features=HttpsUpgrades,HttpsFirstBalancedMode,HttpsFirstModeV2,HttpsFirstModeIncognito'
)
# 统计脚本可能挂住 load 事件：DOMContentLoaded 即返回，数据加载由条件等待负责
chrome_options.page_load_strategy = 'eager'

# 移除表格及父元素的高度限制和滚动条，让表格完整展开到文档流中
_REMOVE_LIMITS_SCRIPT = """
    var table = document.getElementById(arguments[0]);
    var element = table;
    while (element) {
        element.style.maxHeight = 'none';
        element.style.height = 'auto';
        element.style.overflow = 'visible';
        element = element.parentElement;
        if (element === document.body) break;
    }
    table.style.maxHeight = 'none';
    table.style.height = 'auto';
    table.style.overflow = 'visible';
"""

# 条件等待：字体就绪 + 表格高度连续 10 次（约 1 秒）不变才认为加载完成。
# 轮询次数由 TABLE_STABLE_TIMEOUT 换算（每轮约 116ms），慢页面等够、快页面不白等
_WAIT_STABLE_SCRIPT = """
    var id = arguments[0];
    var maxLoops = arguments[1];
    var done = arguments[arguments.length - 1];
    var t = document.getElementById(id);
    if (!t) { done({ error: 'notfound', width: 0, height: 0 }); return; }
    function sleep(ms){ return new Promise(r=>setTimeout(r, ms)); }
    function raf(){ return new Promise(r=>requestAnimationFrame(()=>r())); }
    (async function(){
        try { if (document.fonts && document.fonts.ready) await document.fonts.ready; } catch(e){}
        let last = -1, stable = 0;
        for (let i = 0; i < maxLoops; i++){
            await raf();
            await sleep(100);
            let h = t.scrollHeight, w = t.scrollWidth;
            if (h === last && h > 0) stable++; else { stable = 0; last = h; }
            if (stable >= 10) { done({ width: w, height: h }); return; }
        }
        done({ width: t.scrollWidth, height: t.scrollHeight });
    })();
"""

# 视口内尚未解密渲染的行数（站点用 opacity 0.02 + 占位文标记未渲染行）
_PENDING_ROWS_SCRIPT = """
    var t = document.getElementById(arguments[0]);
    var rows = t.querySelectorAll('tr');
    var vh = document.documentElement.clientHeight;
    var pending = 0;
    for (var i = 0; i < rows.length; i++) {
        var r = rows[i].getBoundingClientRect();
        if (r.bottom > 0 && r.top < vh) {
            var c = rows[i].querySelector('td, th');
            if (c && parseFloat(getComputedStyle(c).opacity) < 0.5) pending++;
        }
    }
    return pending;
"""

# 行分区截图几何 + 单元格几何：站点行渲染后高度会收缩，文档坐标随滚动漂移，
# 故按行索引分区：从 next_row 的实时 rect 顶裁到视口内最后一个完整行底；
# 同时返回每行 td/th 的实时 rect 与 colspan/rowspan，供逐格裁剪 OCR
_ROW_BAND_SCRIPT = """
    var t = document.getElementById(arguments[0]);
    var rows = t.querySelectorAll('tr');
    var vh = document.documentElement.clientHeight;
    var start = arguments[1];
    if (start >= rows.length) return {done: true, nrows: rows.length};
    var y0 = rows[start].getBoundingClientRect().top;
    var end = start;
    for (var i = start; i < rows.length; i++) {
        var r = rows[i].getBoundingClientRect();
        if (r.bottom <= vh + 1) end = i; else break;
    }
    var bands = [];
    for (var i = start; i <= end; i++) {
        var cs = rows[i].querySelectorAll('td, th');
        var cells = [];
        for (var j = 0; j < cs.length; j++) {
            var cr = cs[j].getBoundingClientRect();
            cells.push({x0: cr.left, y0: cr.top, x1: cr.right, y1: cr.bottom,
                        cs: parseInt(cs[j].getAttribute('colspan') || '1', 10),
                        rs: parseInt(cs[j].getAttribute('rowspan') || '1', 10)});
        }
        bands.push(cells);
    }
    var tr = t.getBoundingClientRect();
    return {done: false, nrows: rows.length, start: start, end: end,
            y0: y0, y1: rows[end].getBoundingClientRect().bottom,
            left: tr.left, width: tr.width, bands: bands};
"""


def _wait_rows_rendered(driver, table_id, timeout=8.0):
    """等待当前视口内的行全部解密渲染，替代固定 sleep。"""
    deadline = time.time() + timeout
    pending = -1
    while time.time() < deadline:
        pending = driver.execute_script(_PENDING_ROWS_SCRIPT, table_id)
        if pending == 0:
            # 等两帧确保合成器完成绘制，避免截到未paint的块
            driver.execute_script(
                "return new Promise(r=>requestAnimationFrame(()=>requestAnimationFrame(()=>r())));"
            )
            return
        time.sleep(0.2)
    logger.warning("视口内仍有 %s 行未渲染，继续截图", pending)


def _recognize_cells(full_img, geo, dpr):
    """按 DOM 单元格几何从整屏截图裁小图，批量 rec-only 识别。

    返回 {(band内行号, 单元格序号): 文本}；空白格跳过识别。
    """
    from rapidocr.ch_ppocr_rec.typings import TextRecInput

    crops = []
    index = []
    for bi, cells in enumerate(geo['bands']):
        for ci, c in enumerate(cells):
            # 内缩 1px 去掉单元格边框线
            box = (int((c['x0'] + 1) * dpr), int((c['y0'] + 1) * dpr),
                   int((c['x1'] - 1) * dpr), int((c['y1'] - 1) * dpr))
            if box[2] <= box[0] or box[3] <= box[1]:
                continue
            crop = full_img.crop(box)
            gray = np.asarray(crop.convert('L'))
            ys, xs = np.where(gray < 128)
            if len(ys) == 0:
                continue  # 空白格
            # rec 面向紧裁文本行设计：按墨迹 bbox 二次紧裁去掉单元格白边，
            # 否则白边会导致低置信度误识
            pad = 3
            tight = crop.crop((
                max(0, int(xs.min()) - pad), max(0, int(ys.min()) - pad),
                min(gray.shape[1], int(xs.max()) + pad + 1),
                min(gray.shape[0], int(ys.max()) + pad + 1),
            ))
            crops.append(np.asarray(tight.convert('RGB')))
            index.append((bi, ci))

    texts = {}
    if crops:
        engine = _get_rec_engine()
        batch = int(os.getenv("OCR_BATCH_SIZE", "32"))
        txts = []
        for s in range(0, len(crops), batch):
            res = engine.text_rec(TextRecInput(img=crops[s:s + batch]))
            txts.extend(res.txts or [])
        for key, t in zip(index, txts):
            texts[key] = (t or '').strip()
    return texts


def _grid_to_excel(grid, row_source, nrows, ncols, output_excel_path):
    """把 (行,列)->文本 网格写为 Excel，附截图溯源列；数值归一化。"""
    wb = openpyxl.Workbook()
    wb.remove(wb.active)
    ws = wb.create_sheet(time.strftime("%Y%m%d%H", time.localtime()))
    num_re = re.compile(r'^-?\d+(?:\.\d+)?$')
    # 站点缺失占位符 -- 常被识为 - / 二- 等变体，统一归一为 None
    dash_re = re.compile(r'^[-—–二\s]+$')
    for r in range(nrows):
        row = []
        for c in range(ncols):
            v = grid.get((r, c))
            if v is None or v == '' or dash_re.match(v):
                row.append(None)
            elif num_re.match(v):
                row.append(float(v))
            else:
                row.append(v)
        row.append(row_source.get(r))
        ws.append(row)
    # 保存失败直接上抛，避免调用方拿到不存在的文件路径
    wb.save(output_excel_path)
    logger.info("Excel 已保存: %s (%d 行 x %d 列)", output_excel_path, nrows, ncols)


def capture_with_full_page_method(url, table_id="hdtable", f_name='default'):
    driver = webdriver.Chrome(options=chrome_options)
    driver.set_page_load_timeout(int(os.getenv("PAGE_LOAD_TIMEOUT", "180")))
    driver.set_script_timeout(180)

    folder_path = f'save_images/{time.strftime("%Y-%m-%d", time.localtime())}/{time.strftime("%H", time.localtime())}/'
    os.makedirs(folder_path, exist_ok=True)
    try:
        logger.info("正在访问: %s", url)
        driver.get(url)

        # 等待表格出现（慢页面放宽到 90 秒）
        WebDriverWait(driver, 90).until(
            EC.presence_of_element_located((By.ID, table_id))
        )
        driver.execute_script(_REMOVE_LIMITS_SCRIPT, table_id)

        logger.info("等待表格加载稳定...")
        dimensions = driver.execute_async_script(
            _WAIT_STABLE_SCRIPT, table_id, max(60, TABLE_STABLE_TIMEOUT * 1000 // 116)
        )
        if dimensions.get('error'):
            raise CrawlError(f"表格不存在: {table_id}", "table_not_found", True)
        logger.info("表格尺寸: %sx%s", dimensions['width'], dimensions['height'])
        # 站点数据接口慢/失败时表格骨架存在但高度为 0、无数据行，
        # 属瞬时故障，直接判定失败交由上层重试，不再空跑截图流程
        if dimensions['height'] <= 0:
            raise CrawlError(f"表格高度为0，站点数据未渲染: {table_id}", "empty_table", True)

        driver.set_window_size(1920, WINDOW_HEIGHT)
        # headless 实际视口高度可能与设定值不同，以运行时测量为准
        viewport_h = driver.execute_script("return document.documentElement.clientHeight;")
        dpr = driver.execute_script("return window.devicePixelRatio || 1;")

        # 按行索引分区滚动截图 + 逐格 OCR：列对齐由 DOM 保证，
        # 免疫站点行渲染后高度收缩带来的坐标漂移与表格结构模型误判
        images = []
        grid = {}
        occupied = set()
        row_source = {}
        ncols = 0
        next_row = 0
        while True:
            # 把首个未截行滚到视口顶（实时位置，免疫布局漂移）
            target = driver.execute_script(
                """
                var t = document.getElementById(arguments[0]);
                var rows = t.querySelectorAll('tr');
                if (arguments[1] >= rows.length) return null;
                return rows[arguments[1]].getBoundingClientRect().top + window.scrollY;
                """,
                table_id, next_row,
            )
            if target is None:
                break
            driver.execute_script(
                "window.scrollTo({top: arguments[0], behavior: 'instant'});", target
            )
            _wait_rows_rendered(driver, table_id)
            geo = driver.execute_script(_ROW_BAND_SCRIPT, table_id, next_row)
            if geo['done']:
                break
            full_img = Image.open(io.BytesIO(driver.get_screenshot_as_png()))
            box = (int(geo['left'] * dpr), int(max(0, geo['y0']) * dpr),
                   int((geo['left'] + geo['width']) * dpr),
                   int(min(geo['y1'], viewport_h) * dpr))
            image = full_img.crop(box)
            image_filename = f"{folder_path}{f_name}-{int(target)}.png"
            image.save(image_filename)
            images.append(image)

            texts = _recognize_cells(full_img, geo, dpr)
            for bi, cells in enumerate(geo['bands']):
                r = geo['start'] + bi
                c = 0
                for ci, cell in enumerate(cells):
                    while (r, c) in occupied:
                        c += 1
                    for dr in range(cell['rs']):
                        for dc in range(cell['cs']):
                            occupied.add((r + dr, c + dc))
                    grid[(r, c)] = texts.get((bi, ci))
                    c += cell['cs']
                ncols = max(ncols, c)
                row_source[r] = image_filename
            logger.info("截图已识别: %s (行 %d-%d)", image_filename, geo['start'], geo['end'])
            next_row = geo['end'] + 1

        merged_path = folder_path + f'{f_name}.png'
        excel_path = folder_path + f'{f_name}.xlsx'
        dom_rows = driver.execute_script(
            "return document.getElementById(arguments[0]).querySelectorAll('tr').length;",
            table_id,
        )
        logger.info("截图完成: %d 屏, DOM 总行数 %s", len(images), dom_rows)
        if not images or not dom_rows:
            raise CrawlError(f"截图结果为空: {len(images)} 屏 / {dom_rows} 行", "empty_table", True)
        vertical_merge(images, merged_path)
        _grid_to_excel(grid, row_source, dom_rows, ncols, excel_path)
        return {'excel': excel_path, 'image': merged_path, 'rows': dom_rows}
    except Exception as e:
        logger.exception("爬取失败: %s", url)
        try:
            driver.save_screenshot(f"{folder_path}{f_name}-error_screenshot.png")
        except Exception:
            pass
        # 统一包装为分类异常：超时/浏览器网络类可重试，其余视为内部错误
        if isinstance(e, CrawlError):
            raise
        if isinstance(e, TimeoutException):
            raise CrawlError(f"页面加载超时: {url}", "page_timeout", True) from e
        if isinstance(e, WebDriverException):
            raise CrawlError(f"浏览器/网络错误: {e}", "browser_error", True) from e
        raise CrawlError(f"{type(e).__name__}: {e}", "internal_error", False) from e
    finally:
        driver.quit()


def vertical_merge(images, output_path):
    if not images:
        raise ValueError("没有可合并的截图")
    total_height = sum(img.height for img in images)
    max_width = max(img.width for img in images)
    new_image = Image.new('RGB', (max_width, total_height))
    y_offset = 0
    for img in images:
        new_image.paste(img, (0, y_offset))
        y_offset += img.height
    new_image.save(output_path)
    logger.info("垂直合并完成: %s", output_path)