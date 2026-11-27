"""服务接口测试脚本。

用法:
    py -3.12 test_service.py security   # 安全/接口用例（秒级）
    py -3.12 test_service.py crawl      # 完整爬取流程（分钟级，需先启动 main.py）
    py -3.12 test_service.py site ysq   # 单站分发爬取（分钟级，站点键 ysq/dj/xsq）
"""
import json
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

BASE = "http://127.0.0.1:18883"
TOKEN = "1777542103"


def call(path, data=None, method="POST"):
    body = json.dumps(data).encode() if data is not None else None
    req = urllib.request.Request(
        BASE + path, data=body, method=method,
        headers={"Content-Type": "application/json"},
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return resp.status, resp.read()
    except urllib.error.HTTPError as e:
        return e.code, e.read()


def check(name, cond, detail=""):
    print(("PASS" if cond else "FAIL"), name, detail)
    if not cond:
        raise SystemExit(1)


def security():
    s, _ = call("/download", method="GET")
    check("GET /download -> 405", s == 405, s)
    s, b = call("/download", {"token": "wrong", "path": "x"})
    check("错误token -> 401", s == 401, s)
    s, b = call("/download", None)
    check("空body -> 401", s == 401, s)
    s, b = call("/download", {"token": TOKEN})
    check("缺少path -> 400", s == 400, s)
    s, b = call("/download", {"token": TOKEN, "path": "main.py"})
    check("目录外文件 -> 403", s == 403, s)
    s, b = call("/download", {"token": TOKEN, "path": "save_images/../main.py"})
    check("路径穿越 -> 403", s == 403, s)
    s, b = call("/download", {"token": TOKEN, "path": "C:/Windows/win.ini"})
    check("绝对路径越界 -> 403", s == 403, s)
    files = list(Path("save_images").rglob("*.xlsx"))
    check("存在历史样例文件", len(files) > 0)
    s, b = call("/download", {"token": TOKEN, "path": str(files[0])})
    check("合法文件下载 -> 200", s == 200 and len(b) > 0, (s, len(b)))
    s, b = call("/download", {"token": TOKEN, "path": "save_images/not_exist.xlsx"})
    check("不存在文件 -> 404", s == 404, s)
    s, b = call("/crawl/water", {"token": "wrong"})
    check("爬取错误token -> 401", s == 401, s)
    s, b = call("/crawl/site", {"token": "wrong", "site": "ysq"})
    check("单站错误token -> 401", s == 401, s)
    s, b = call("/crawl/site", {"token": TOKEN, "site": "nope"})
    check("未知站点 -> 400", s == 400, s)
    s, b = call("/crawl/status", {"token": TOKEN, "task_id": "nope"})
    check("未知任务 -> 404", s == 404, s)
    print("== 安全测试全部通过 ==")


def crawl():
    s, b = call("/crawl/water", {"token": TOKEN})
    check("提交爬取 -> 202", s == 202, (s, b))
    task_id = json.loads(b)["task_id"]
    s, b = call("/crawl/water", {"token": TOKEN})
    check("重复提交复用任务", json.loads(b)["task_id"] == task_id, b)

    start = time.time()
    while True:
        time.sleep(10)
        s, b = call("/crawl/status", {"token": TOKEN, "task_id": task_id})
        task = json.loads(b)
        print(f"[{int(time.time() - start)}s] status={task['status']} "
              f"results={list(task['results'])} errors={task['errors']}", flush=True)
        if task["status"] == "done":
            break
        if time.time() - start > 1500:
            raise SystemExit("FAIL 爬取超时")

    check("三站点全部成功", len(task["results"]) == 3 and not task["errors"], task["errors"])

    import openpyxl
    for key, r in task["results"].items():
        p = Path(r["excel"])
        check(f"{key} excel存在", p.is_file(), str(p))
        wb = openpyxl.load_workbook(p, read_only=True)
        rows = list(wb.active.iter_rows(values_only=True))
        wb.close()
        check(f"{key} 行数>0", len(rows) > 0, len(rows))
        # 截图重叠 bug 表现为相邻行重复；站点源数据本身允许重复行（如双树寺水库）
        keys = [tuple(str(v) for v in row[:-1]) for row in rows]
        adj_dup = sum(1 for a, b in zip(keys, keys[1:]) if a == b)
        check(f"{key} 无相邻重复行", adj_dup == 0, adj_dup)
        check(f"{key} 合并长图存在", Path(r["image"]).is_file())
        print(f"  {key}: {len(rows)} 行, 首行: {rows[0][:6]}")
    print("== 爬取测试全部通过 ==")


def site(key="ysq"):
    s, b = call("/crawl/site", {"token": TOKEN, "site": key})
    check("提交单站爬取 -> 202", s == 202, (s, b))
    task_id = json.loads(b)["task_id"]
    s, b = call("/crawl/site", {"token": TOKEN, "site": key})
    check("同站重复提交复用任务", json.loads(b)["task_id"] == task_id, b)

    start = time.time()
    while True:
        time.sleep(10)
        s, b = call("/crawl/status", {"token": TOKEN, "task_id": task_id})
        task = json.loads(b)
        print(f"[{int(time.time() - start)}s] status={task['status']} "
              f"attempts={task.get('attempts')} error={task.get('error')}", flush=True)
        if task["status"] in ("done", "failed"):
            break
        if time.time() - start > 1500:
            raise SystemExit("FAIL 爬取超时")

    check(f"{key} 爬取成功", task["status"] == "done", task.get("error"))
    r = task["results"][key]
    check(f"{key} 行数>0", r.get("rows", 0) > 0, r.get("rows"))

    import openpyxl
    p = Path(r["excel"])
    check(f"{key} excel存在", p.is_file(), str(p))
    wb = openpyxl.load_workbook(p, read_only=True)
    rows = list(wb.active.iter_rows(values_only=True))
    wb.close()
    check(f"{key} 行数>0", len(rows) > 0, len(rows))
    check(f"{key} 合并长图存在", Path(r["image"]).is_file())
    print(f"  {key}: {len(rows)} 行, 首行: {rows[0][:6]}")
    print("== 单站爬取测试全部通过 ==")


if __name__ == "__main__":
    if sys.argv[1] == "site":
        site(sys.argv[2] if len(sys.argv) > 2 else "ysq")
    else:
        {"security": security, "crawl": crawl}[sys.argv[1]]()