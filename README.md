# CheatMenu

Roblox 执行器用的菜单脚本（单文件 Lua）。仓库里的 `CheatMenu.lua` 是**发行产物**（构建时去注释 + 压缩）。

## 用法

把 `loader.lua` 整段粘进执行器执行即可（主脚本走网络加载，多源兜底）。
或直接用托管源：

```lua
loadstring(game:HttpGet("https://ghfast.top/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua"))()
```

## 改代码之前

⛔ **先读 [`AGENTS.md`](AGENTS.md) —— 那是本仓库唯一规范。**
（`CLAUDE.md` / `.github/` / `.cursor/` 只是指向它的薄壳，内容不重复。）

## 目录

| 路径 | 说明 |
|---|---|
| `AGENTS.md` | **唯一规范**（铁律 / 八层架构 / 硬不变量 / 发版流程） |
| `CheatMenu.lua` | 发行产物（构建生成，勿手改） |
| `loader.lua` | 加载器（粘进执行器） |
| `version.txt` | 当前版本号 |
| `CHANGELOG.md` | 逐版变更（顶部 = 最新） |
| `事件库/` | 扫描结论与各游戏要点 |
| `源码快照/` | 只保留当前版本那一份带注释源码 |

## 发版

`python .workbuddy/build/push_now.py --fast [--patch]` → `local_sync.py` → `push_docs.py`
→ 核对 `version.txt` == `CHANGELOG.md` 顶部 == 远端实际文件。
（推送走 GitHub Contents API，**不是 git push**。）
