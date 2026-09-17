# CheatMenu —— Roblox 执行器 Lua 脚本

> 给智能体/协作者的接手说明：**看这一份 + CHANGELOG 就能接手，不用重复问。**

## 这是什么

一个跑在 Roblox 执行器里的多功能 Lua 脚本（约 8k 行），面向 **MM2 类（Mad Murderer 类）游戏**。功能覆盖：战斗辅助（索敌/自动瞄准/自动开火）、移动（飞行/加速/穿墙）、视觉（玩家透视/名字/武器标记）、传送、藏身、翻译等。

- **仓库**：`Mercershixin/CheatMenu`，分支 `main`
- **当前版本**：见 `version.txt`

## 文件结构（仓库里）

| 文件 | 作用 |
|------|------|
| `CheatMenu.lua` | **主脚本**（发行版，已 minify 去注释/缩进） |
| `loader.lua` | 加载器，粘进执行器跑，走网络加载主脚本（内置 8 个源兜底） |
| `version.txt` | 版本号 |
| `CHANGELOG.md` | 更新记录（**发行前先在顶部加本版说明**） |
| `事件库/` | 游戏 Remote 事件抓包清单，做新功能先来这里查信号 |

> ⚠️ 本地工作区里还有个 `CheatMenu_v68.lua`（**完整源码，带注释**，约 8k 行）。仓库里的 `CheatMenu.lua` 是它 minify 后的发行产物。**改代码要改本地源码，不是直接改仓库产物。**

## 加载方式

把 `loader.lua` 整段粘进执行器执行即可。国内直连 `raw.githubusercontent.com` 常不通，加载器按顺序试 8 个源（`ghfast.top` / `ghproxy.net` 等），取第一个成功的。

## 这个游戏的关键事实（做功能前必读）

从 `事件库/` 抓包 + 诊断确认，**这个游戏的权威数据大多在 Player 的 Attribute 里，不在标准 Humanoid/Team**：

| 判据 | 位置 |
|------|------|
| 血量/状态 | `@Health` / `@MaxHealth` / `@State`（`Sprint`/`Slide`/`Stand`/`Dead`） |
| 护盾 | `@Shield` / `@TempShield` |
| 队伍 | `@Team`（`Team1`/`Team3` 字符串；标准 `Player.Team` 是 **nil**） |
| 换弹/受控 | `@combatPaused`（`true` = 换弹/无法攻击） |

- 战斗框架是 **Madwork**（`MadworkCombat_*`），击杀信号走 `GameService.Killed`（不是 Madwork 那条，Madwork 那条是命中/伤害）。
- **没有独立的"换弹"Remote** —— 换弹是纯客户端动画，检测只能用 `@combatPaused` 近似。

## 开发约定（⚠️ 接手必读，否则会踩坑）

1. **版本号三段式** `主.次.补丁`：新功能 → 次+1 补丁归零；修 bug/清理 → 只加补丁。推送脚本按源码 sha 自动定版本。
2. **改完必跑门禁**：`python .workbuddy/build/verify_all.py`（7 步：luau-compile / check.py 回归锁 / 仿真 / 探针 / dist 一致性 / 词法作用域）。
3. **改文件姿势**：用 `find`+切片+`assert` 唯一命中，**禁止 `re.sub(...,re.S)` 带 `.*`**（会吞行）。
4. **连接必须经 `T()` 登记进 `SYS.Conns`**；"只挂一次"标记用弱表，别用实例属性（跨代次残留）。
5. **边界（不做）**：不实现任何反作弊对抗、不对其他玩家生效的功能（定身/击杀/传送别人等）。

## 构建 / 推送（本地流程，仓库里看不到脚本）

- 构建产物在本地 `dist/repo/`，通过 GitHub Contents API 推（脚本 `.workbuddy/build/push_now.py`）。
- 源码 → minify → 等价性校验 → 编译门禁 → 推 4 文件 → 回读逐字节验证。

## 事件库

`事件库/` 目录沉淀每次抓包的 Remote 清单，按功能分类。做"自动捡东西/自动购买/自动换弹/跳过动画"这类新功能前，先 grep 关键词查有没有对应信号。详见 `事件库/README.md`。
