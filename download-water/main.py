import logging
import os
import secrets
import threading
import time
import uuid
from datetime import datetime
from pathlib import Path

from flask import Flask, jsonify, request, send_file

import water_download

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s: %(message)s",
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

VERIFY_TOKEN = os.getenv("VERIFY_TOKEN", "1777542103")
SAVE_ROOT = Path(os.getenv("SAVE_ROOT", "save_images")).resolve()

SITES = [
    ("ysq", "http://xxfb.mwr.cn/sq_zdysq.html", "重点雨水情"),
    ("dj", "http://xxfb.mwr.cn/sq_djdh.html", "大江大河"),
    ("xsq", "http://xxfb.mwr.cn/sq_dxsk.html", "大型水库"),
]
SITE_MAP = {key: (url, name) for key, url, name in SITES}

# 单站最大尝试次数与重试间隔（秒）：空表/超时类瞬时故障退避后重发，
# 生产服务器响应慢，退避默认 60 秒起步给站点恢复时间
MAX_ATTEMPTS = int(os.getenv("CRAWL_MAX_ATTEMPTS", "3"))
RETRY_BACKOFF = int(os.getenv("CRAWL_RETRY_BACKOFF", "60"))

_tasks = {}
_tasks_lock = threading.Lock()
_crawl_lock = threading.Lock()


def _prune_tasks():
    """只保留最近 50 个任务，避免内存无限增长（调用方需持有 _tasks_lock）。"""
    if len(_tasks) <= 50:
        return
    finished = sorted(
        (t for t in _tasks.values() if t["status"] in ("done", "failed")),
        key=lambda t: t["created_at"],
    )
    for t in finished[:len(_tasks) - 50]:
        _tasks.pop(t["id"], None)


def _token_ok(data):
    token = str((data or {}).get("token", ""))
    return secrets.compare_digest(token, VERIFY_TOKEN)


@app.route('/download', methods=['POST'])
def download():
    data = request.get_json(silent=True)
    if not _token_ok(data):
        return jsonify({"error": "token无效"}), 401
    path = data.get("path")
    if not path:
        return jsonify({"error": "缺少path参数"}), 400

    # 只允许下载 save_images 目录内的文件，堵住任意文件读取
    target = Path(path).resolve()
    if not target.is_relative_to(SAVE_ROOT):
        return jsonify({"error": "路径不允许"}), 403
    if not target.is_file():
        return jsonify({"error": "文件不存在"}), 404

    mimetype = (
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        if target.suffix == '.xlsx' else 'application/octet-stream'
    )
    return send_file(
        target,
        as_attachment=True,
        download_name=target.name,
        mimetype=mimetype,
    )


def _crawl_site_once(key):
    """爬取单站并校验结果，返回 (result, error_dict)。

    校验：DOM 行数 > 0 且 Excel 文件落盘；不满足则视为可重试失败。
    """
    url, name = SITE_MAP[key]
    try:
        result = water_download.capture_with_full_page_method(url, "hdtable", name)
        rows = result.get("rows", 0)
        if not rows or not Path(result["excel"]).is_file():
            raise water_download.CrawlError(
                f"结果校验失败: rows={rows}, excel存在={Path(result['excel']).is_file()}",
                "invalid_result", True,
            )
        return result, None
    except water_download.CrawlError as e:
        logger.error("站点爬取失败: %s code=%s retryable=%s", name, e.code, e.retryable)
        return None, {"code": e.code, "message": str(e), "retryable": e.retryable}
    except Exception as e:
        logger.exception("站点爬取异常: %s", name)
        return None, {"code": "internal_error",
                      "message": f"{type(e).__name__}: {e}", "retryable": False}


def _crawl_site_with_retry(key, task):
    """带重试的单站爬取：可重试错误退避后重发，不可重试或次数用尽则放弃。"""
    url, name = SITE_MAP[key]
    for attempt in range(1, MAX_ATTEMPTS + 1):
        task["attempts"] = attempt
        logger.info("开始爬取站点 %s 第 %d/%d 次", name, attempt, MAX_ATTEMPTS)
        result, error = _crawl_site_once(key)
        if result is not None:
            task["error"] = None
            return result
        task["error"] = error
        if not error["retryable"]:
            logger.error("站点 %s 失败不可重试，放弃: %s", name, error["code"])
            break
        if attempt < MAX_ATTEMPTS:
            backoff = RETRY_BACKOFF * attempt
            logger.warning("站点 %s 第 %d 次失败(%s)，%d 秒后重试",
                           name, attempt, error["code"], backoff)
            time.sleep(backoff)
    return None


def _run_site(task_id):
    """单站任务：同一时刻只允许一个爬取在跑，其余排队。"""
    with _crawl_lock:
        task = _tasks[task_id]
        key = task["site"]
        task["status"] = "running"
        task["started_at"] = datetime.now().isoformat(timespec="seconds")
        logger.info("开始爬取 task=%s site=%s", task_id, key)
        result = _crawl_site_with_retry(key, task)
        if result is not None:
            task["results"][key] = result
            task["status"] = "done"
        else:
            task["status"] = "failed"
        task["finished_at"] = datetime.now().isoformat(timespec="seconds")
        logger.info("爬取结束 task=%s site=%s status=%s attempts=%s",
                    task_id, key, task["status"], task["attempts"])


def _run_crawl(task_id):
    with _crawl_lock:
        task = _tasks[task_id]
        task["status"] = "running"
        task["started_at"] = datetime.now().isoformat(timespec="seconds")
        logger.info("开始爬取 task=%s", task_id)
        # 三个站点独立捕获异常并重试，一个失败不影响其余
        for key, url, name in SITES:
            result = _crawl_site_with_retry(key, task)
            if result is not None:
                task["results"][key] = result
            else:
                err = task.get("error") or {}
                task["errors"][key] = f"{err.get('code', 'unknown')}: {err.get('message', '')}"
                task["error_details"][key] = err
        task["status"] = "done"
        task["finished_at"] = datetime.now().isoformat(timespec="seconds")
        logger.info("爬取完成 task=%s 成功=%s 失败=%s",
                    task_id, list(task["results"]), list(task["errors"]))


@app.route('/crawl/site', methods=['POST'])
def crawl_site():
    """单站分发：按 site 键（ysq/dj/xsq）提交独立任务，失败可单独重发。"""
    data = request.get_json(silent=True)
    if not _token_ok(data):
        return jsonify({"error": "token无效"}), 401
    key = (data or {}).get("site")
    if key not in SITE_MAP:
        return jsonify({"error": f"未知站点: {key}", "sites": list(SITE_MAP)}), 400

    with _tasks_lock:
        # 同站点已有未完成任务时直接复用，避免重复爬取
        for task in _tasks.values():
            if task.get("site") == key and task["status"] in ("pending", "running"):
                return jsonify({
                    "task_id": task["id"],
                    "status": task["status"],
                    "message": "该站点已有爬取任务进行中",
                }), 202
        task_id = uuid.uuid4().hex
        _tasks[task_id] = {
            "id": task_id,
            "site": key,
            "status": "pending",
            "attempts": 0,
            "results": {},
            "errors": {},
            "error": None,
            "created_at": datetime.now().isoformat(timespec="seconds"),
        }
        _prune_tasks()
    threading.Thread(target=_run_site, args=(task_id,), daemon=True).start()
    return jsonify({"task_id": task_id, "site": key, "status": "pending"}), 202


@app.route('/crawl/water', methods=['POST'])
def crawl_water():
    data = request.get_json(silent=True)
    if not _token_ok(data):
        return jsonify({"error": "token无效"}), 401

    with _tasks_lock:
        # 已有任务在跑时直接复用，避免并发爬取打爆内存
        for task in _tasks.values():
            if task["status"] in ("pending", "running"):
                return jsonify({
                    "task_id": task["id"],
                    "status": task["status"],
                    "message": "已有爬取任务进行中",
                }), 202
        task_id = uuid.uuid4().hex
        _tasks[task_id] = {
            "id": task_id,
            "status": "pending",
            "results": {},
            "errors": {},
            "error_details": {},
            "created_at": datetime.now().isoformat(timespec="seconds"),
        }
        _prune_tasks()
    threading.Thread(target=_run_crawl, args=(task_id,), daemon=True).start()
    return jsonify({"task_id": task_id, "status": "pending"}), 202


@app.route('/crawl/status', methods=['POST'])
def crawl_status():
    data = request.get_json(silent=True)
    if not _token_ok(data):
        return jsonify({"error": "token无效"}), 401
    task = _tasks.get(data.get("task_id"))
    if task is None:
        return jsonify({"error": "任务不存在"}), 404
    return jsonify(task)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=18883, debug=False, use_reloader=False)