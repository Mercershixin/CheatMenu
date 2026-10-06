# -*- coding: utf-8 -*-
"""
把 Roblox 执行器 workspace 里的「翻译缓存分文件」上传到 GitHub 仓库。

为什么走电脑端而不是游戏内：
    游戏内上传要在脚本里/工作目录放 GitHub Token，等于把密钥暴露给所有执行器脚本。
    缓存文件本来就落在你电脑的真实目录里，用电脑端脚本同步最安全（Token 只在本机项目目录）。

用法：
    python 同步翻译缓存到云端.py                 # 自动找 workspace 目录
    python 同步翻译缓存到云端.py <workspace目录>  # 手动指定
"""
import base64
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request

REPO = "Mercershixin/CheatMenu"
BRANCH = "main"
API = "https://api.github.com/repos/%s/contents/" % REPO
RAW_BASE = "https://raw.githubusercontent.com/%s/%s/" % (REPO, BRANCH)

TOKEN_FILE = r"c:\Users\Administrator\Desktop\Hy-MT2翻译模型\.workbuddy\publish.token"

CANDIDATE_WS = [
    os.path.join(os.environ.get("LOCALAPPDATA", ""), "Real", "workspace"),
    os.path.join(os.environ.get("LOCALAPPDATA", ""), "Wave", "workspace"),
    os.path.join(os.environ.get("LOCALAPPDATA", ""), "Solara", "workspace"),
    os.path.join(os.environ.get("LOCALAPPDATA", ""), "Delta", "workspace"),
]

PREFIX = "CheatMenu_Cache_"


def read_token():
    for p in (TOKEN_FILE, os.path.join(os.getcwd(), "publish.token")):
        if os.path.isfile(p):
            with open(p, "r", encoding="utf-8") as f:
                t = f.read().strip()
            if t:
                return t
    return None


def find_workspace(argv):
    if len(argv) > 1 and os.path.isdir(argv[1]):
        return argv[1]
    for d in CANDIDATE_WS:
        if d and os.path.isdir(d):
            return d
    return None


def find_cache_files(ws):
    out = []
    for name in os.listdir(ws):
        full = os.path.join(ws, name)
        if name.startswith(PREFIX) and name.endswith(".txt") and os.path.isfile(full):
            out.append((name, full))
    out.sort()
    return out


def req(url, token, method="GET", data=None):
    headers = {
        "Authorization": "token " + token,
        "User-Agent": "CheatMenu-CacheSync",
        "Accept": "application/vnd.github+json",
    }
    body = None
    if data is not None:
        body = json.dumps(data).encode("utf-8")
        headers["Content-Type"] = "application/json"
    r = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(r, timeout=60) as resp:
            return resp.status, resp.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode("utf-8", "replace")
    except Exception as e:
        return 0, str(e)


def push_one(name, path, token):
    with open(path, "rb") as f:
        raw = f.read()
    if not raw:
        return "跳过(空文件)", None
    remote_path = "translate/cache/" + urllib.parse.quote(name, safe="")
    api_url = API + remote_path
    sha = None
    code, body = req(api_url + "?ref=" + BRANCH, token)
    if code == 200:
        try:
            sha = json.loads(body).get("sha")
        except Exception:
            sha = None
    payload = {
        "message": "cache: %s (%d bytes)" % (name, len(raw)),
        "content": base64.b64encode(raw).decode("ascii"),
        "branch": BRANCH,
    }
    if sha:
        payload["sha"] = sha
    code, body = req(api_url, token, method="PUT", data=payload)
    if code in (200, 201):
        return "已上传", "%s  (%d 字节)" % (remote_path, len(raw))
    return "失败 HTTP %d" % code, body[:200]


def main():
    ws = find_workspace(sys.argv)
    if not ws:
        print("[×] 找不到执行器 workspace 目录，请手动指定：")
        print("    python 同步翻译缓存到云端.py D:\\路径\\workspace")
        return 1
    print("[目录] " + ws)

    token = read_token()
    if not token:
        print("[×] 找不到 Token 文件：" + TOKEN_FILE)
        return 1
    print("[Token] 已读取 (%s...)" % token[:8])

    files = find_cache_files(ws)
    if not files:
        print("[!] 没有发现 %s*.txt 缓存文件（先在游戏里开一次翻译并保存）" % PREFIX)
        return 1

    ok = 0
    for name, full in files:
        status, extra = push_one(name, full, token)
        mark = "✓" if status == "已上传" else "✗"
        print("%s %-44s %s %s" % (mark, name, status, extra or ""))
        if status == "已上传":
            ok += 1
    print("")
    print("完成：%d/%d 个文件已上传到 %s/translate/cache/ (分支 %s)" % (ok, len(files), REPO, BRANCH))
    print("游戏里下次进同款游戏时，本地没缓存会自动从云端拉取。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
