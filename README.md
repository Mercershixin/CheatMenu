# CheatMenu —— Roblox 执行器 Lua 脚本

> 给智能体/协作者的接手说明：**看这一份 + CHANGELOG 就能接手，不用重复问。**

> ⛔ **强制规范还有独立的「AI 自动加载」文件**（换账号 / 换智能体也会自动读到）：
> **`AGENTS.md`**（正文）· `CLAUDE.md` · `.github/copilot-instructions.md` · `.cursor/rules/cheatmenu.mdc` ·
> 以及源码 `CheatMenu-*.lua` 的**文件头注释**。

> ## ⛔ 先读这条（换账号 / 换智能体接手必看，用户已强调多次）
>
> **0. ⛔⛔ 测试手段只有三种（用户 2026-09-20 定稿 · 最高优先级）：
> ① 静态分析 ② 单元测试 ③ 云端执行（OCALE）。**
> **「整脚本仿真」与「循环检测」（= 模拟检测循环 / 多轮深度验证）均已【彻底禁用】，没有任何例外。**
> - 禁跑点名：`sim/run_full.py` · `sim/full_sim.lua` · `sim/run_smoke.py` · `sim/smoke_load.lua` · `sim/run_probe_v69.py`。
> - **「循环检测」=「模拟 → 修复 → 再模拟 → 再修复」那种反复跑的检测循环。**
>   旧版本这里写"只在用户明确要求时才做"—— **已作废，不许再援引**。
>   用户原话：**「也包括循环检测 也禁用，只能用我说3个测试的 那个」**。
> - 为什么禁：它是 `lupa 2.8 + Lua 5.5` 的 mock，既不是 Luau 也不是 Roblox，
>   真实物理/复制/服务端权威/执行器 API/UI 一项都没覆盖，却反复把"仿真台自己的坑"算成脚本 bug。
> - 详见 **`AGENTS.md` §0.1** 与 `.workbuddy/sim/DISABLED.md`。
> - ⛔ 不要再造第四个 mock 环境来当门禁；要真机验证就交给用户在**真实执行器 / 云端**跑。
>
> **1. 不要自作主张跑「测试循环」。**
> `verify_all.py`、`local_sync.py --full`、`check.py`、`check_globals.py`、`luau-compile`、`luau-analyze`、
> 加载器探针 —— **只在用户明确说"跑一下 / 验证一下 / 测试一下 / 发版"时才跑**。
> （用户原话：**"我让你做你才做，没让你做你不用做。"**）
>
> **2. UI 上标注「不推荐 / 会被拉回 / 有风险」是给用户看的提示，不是让你改行为。**
> 用户要的是"**标出来，我自己决定用不用**"。**不要**因此删除选项、改默认值、加限制。
>
> **3. 同理：不擅自新增功能、不动用户没让你动的地方。** 只做用户明确要求的那一件事。
>
> **4. 发版默认命令 = `python .workbuddy/build/push_now.py --patch`（修 bug）/ 不带 `--patch`（新功能）。**
> - ★ 2026-09-20 起 **不带 `--fast` 也是一样的** —— 整脚本仿真已彻底禁用，`--fast` 只剩兼容意义。
> - 改完 = **钉版本号 → `push_now.py`**（动了 README/AGENTS/CLAUDE/.github/.cursor/事件库 再跑 `push_docs.py`），就结束。
> - 若日志出现 `!! API 推送失败` → 兜底跑 `python .workbuddy/build/push_api.py`。


## 这是什么

一个跑在 Roblox 执行器里的多功能 Lua 脚本（**13220 行**），当前主攻 **MachineParty**（权威数据全在 Player 的 `MP*` / `@*` Attribute 那套）。功能覆盖：战斗辅助（索敌/自动瞄准/自动开火）、移动（飞行/加速/穿墙）、视觉（玩家透视/名字/武器标记）、传送、藏身、翻译等。

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

> ⚠️ 本地工作区里是**完整源码，带注释**（**文件名跟版本号走**：`CheatMenu-<版本>.lua`，如 `CheatMenu-6.9.1.lua`，
> 升版用 `.workbuddy/build/rename_version.py` 一键改名）。仓库里的 `CheatMenu.lua` 是它 minify 后的发行产物。
> **改代码要改本地源码，不是直接改仓库产物。**

## 加载方式

把 `loader.lua` 整段粘进执行器执行即可。国内直连 `raw.githubusercontent.com` 常不通，加载器按顺序试 8 个源（`ghfast.top` / `ghproxy.net` 等），取第一个成功的。

## 这个游戏的关键事实（做功能前必读）

从诊断实锤确认（`CheatMenu-6.9.1.lua:4531`），**权威数据大多在 Player 的 Attribute 里，不在标准 Humanoid/Team**：

| 判据 | 位置 | 关键点 |
|------|------|------|
| 血量 | `@Health` / `@MaxHealth` | `Humanoid.Health` **不可信** —— 满血活人会被误判已死 → 索敌全空 |
| 状态 | `@State` = `Sprint`/`Slide`/`Stand`/`Dead` | 比 `Humanoid:GetState()` 准（权威状态） |
| 护盾 | `@Shield` / `@TempShield` | 0 = 无盾 |
| 换弹/受控 | `@combatPaused` | `true` = 换弹 / 受控 / 无法攻击 |
| 队伍 | **多信号按序试**：`Team` → `MPTeam` → `MPTeamId` → `team` → `MPFaction` → `MPSide`，最后回退 `Player.Team.Name` | 标准 `Player.Team` 恒为 **nil**；这些可能**全为 nil** → 透视颜色恒定，属已知现象（`CheatMenu-6.9.1.lua:2413`） |
| **幽灵/隐身态** | `MPGhost == true` | **MachineParty 特有**；本机玩家实测 `MPGhost=true` + `MPWalkSpeed=0` → 透视里单独标**紫色**（`CheatMenu-6.9.1.lua:2426`） |

- ⚠️ **`MadworkCombat_*` 那套战斗框架在当前游戏里没有**（源码 0 处引用）—— 那是 `事件库/` 里**另一个游戏**的清单，
  别照着写机判。
- ⚠️ `EntityService.Heal` / `GameService.Revive` / `GameService.Respawn` **只有索引到才生效**；
  换图 / 改版后可能 `FindFirstChild` 不到 → 按钮提示"没找到"（**优雅降级，不是崩**）。**换游戏前先重新抓包。**
- **没有独立的"换弹"Remote** —— 换弹是纯客户端动画，检测只能用 `@combatPaused` 近似。

## 开发约定（⚠️ 接手必读，否则会踩坑）

1. **版本号三段式** `主.次.补丁`：新功能 → 次+1 补丁归零；修 bug/清理 → 只加补丁。推送脚本按源码 sha 自动定版本。
   ⚠️ **脚本默认是按「功能版」次+1** —— **修 bug 必须显式加 `--patch`**
   （`python .workbuddy/build/push_now.py --patch`，或 `local_sync.py --patch`，或环境变量 `CM_VER_KIND=patch`）。
   不加 `--patch` 就会把一次 bug 修复发成功能版（例：本该 4.8.1 却发成 4.9.0）。
   **发完记得核对 `version.txt` 与 CHANGELOG 顶部的版本号一致。**
2. **门禁内容**：`python .workbuddy/build/verify_all.py`（**仅在用户明确要求时才跑**；现已是**静态系**，
   分母 7 但仿真系四步已打印 `[SKIP]`）：
   **1/7** 官方 Luau 编译器 · **2/7** `check.py` 静态接线 + 回归锁 · **3/7** `diag_inject` 注入前体检（编码/BOM/危险 API）·
   **6/7** 构建发布版 + 等价性 + 编译门禁 · **7/7** `check_globals` 词法作用域。
   ★ 原 **3.5/7 加载阶段有界冒烟 · 4/7 整脚本桩仿真 · 5/7 v69 规则探针** 属**仿真系，已按用户要求彻底禁用**，
   现在只打印 `[SKIP]`（见 `AGENTS.md` §0.1）。
3. **改文件姿势**：用 `find`+切片+`assert` 唯一命中，**禁止 `re.sub(...,re.S)` 带 `.*`**（会吞行）。
4. **连接必须经 `T()` 登记进 `SYS.Conns`**；"只挂一次"标记用弱表，别用实例属性（跨代次残留）。
5. **★ 不要自作主张跑「仿真 / 模拟检测循环 / 多轮深度验证」（= 循环检测）** ——
   「模拟 → 修复 → 再模拟 → 再修复」的反复循环**已彻底禁用，没有例外**（**不是**"用户要求就能跑"）。
   ★ 2026-09-20 更正：旧版这里写"只在用户明确要求时才做"—— **已作废**。
   本项目只认 **① 静态分析 ② 单元测试 ③ 云端执行（OCALE）** 三种手段。
   *换账号 / 换智能体接手时，这条同样适用 —— 别每个号都来一遍。*
6. **UI 上标注「不推荐 / 会被拉回」是给用户看的提示，不是让你改行为** ——
   用户要的是"**标出来我自己决定用不用**"，不是让你把那个选项删掉、改默认值或加限制。
   同理：**不擅自新增功能、不擅自改默认值**，只做用户明确要的那件事。


## 🔄 本地与远程同步 / 🩺 一键诊断 / 发版（★ 接手必读）

### 1. 同步本地仓库与远程（先做这个，再动代码）
```bash
cd dist/repo            # ★ 仓库在这里，不在工作区根目录
G="git -c http.proxy= -c https.proxy= -c core.autocrlf=false"   # 清掉本机死代理
$G fetch origin main    # ★ 必须先 fetch
$G reset --hard FETCH_HEAD
```
- **绝对不要 `git reset --hard origin/main`** —— 沙箱写不进 `refs/remotes/origin/*`，用 `FETCH_HEAD`。
- **`fetch` 失败时千万别接着 `reset`**（会把工作区退回旧版，踩过）。
- 同步后确认：`version.txt` 与 `CHANGELOG.md` 顶部版本号**一致**。
- 仓库里只放 4 个发行文件 + `README.md` + `事件库/`；**源码（带注释）只在本地**，文件名跟版本号走
  （`CheatMenu-<版本>.lua`，升版用 `.workbuddy/build/rename_version.py` 改名）。

### 2. 遇到"UI 位置 / 拖动 / 显示不对"——先要诊断，不要猜
在控制台执行 **`SYS.DiagUI()`**（v5.4.2 起界面按钮已按用户要求删除，函数保留）。它会一键把全部事实扫出来：
控制台 + 写 `CheatMenu_Diag.txt`（能写文件时）。内容含：
视口 · GuiInset · `ScreenGui`（父级 / 尺寸 / `ScreenInsets` / `IgnoreGuiInset`）· 菜单**实际位置与尺寸** ·
**居中校验（期望 vs 实际）** · 锚点 · `UIScale`（含挂在谁身上）· 拖动把手（类 / `Active` / 尺寸）·
**★ 标题栏命中测试**（`PlayerGui:GetGuiObjectsAtPosition` 取标题栏正中的**最上层对象**）。

**规矩**：
- 让用户点这个按钮、把输出发过来 —— **不要让用户自己观察、记录、截图**。
- **别加"自动纠正位置"的逻辑**。加过一次（`MenuPlacementCheck`），判据有误差 → 它主动把菜单挪走
  → **越修越歪**（用户日志 `545,150` → `130,-182`），最后整块删掉。**宁可只提供"用户主动点一下"的入口。**
- **不要让功能依赖"某个控件能不能收到输入"**（会被 z 序 / `Active` / 遮挡 / 执行器差异搞掉）——
  拖动的正确做法是 **`UserInputService.InputBegan` 全局监听 + 自己算矩形命中**（见 `CheatMenu` 里的 `inRect`）。
- 桩环境里给属性/方法**先判存在再调**；用 `pcall` 硬吞会变成"被 pcall 吞掉的错误"，**门禁会拒绝发行**。

### 3. 发版（一条链走完，别拆）
```bash
python .workbuddy/build/verify_all.py            # 门禁(7 步)；改完必跑一次
python .workbuddy/build/local_sync.py --full     # 建本地版 + 装执行器脚本
python .workbuddy/build/push_now.py              # 推 4 文件(CheatMenu/version/loader/CHANGELOG)
python .workbuddy/build/push_docs.py             # ★ 推 README.md 与 事件库/(不在上面那 4 个里！)
```
- **修 bug 要加 `--patch`**（默认是"功能版"次+1，不加会把 bug 修复发成功能版）。
- **想固定版本号**：把目标号写进 `.workbuddy/build/VERSION`，并把**当前源码 sha1** 写进 `VERSION.sha`
  —— 这样 `version_for()` 认为"源码没变"直接返回该号。⚠️ **源码一改就要重新钉一次。**
- **加载器由 `publish.py` 生成**（`LOADER_TMPL`），**不要手改 `dist/repo/loader.lua`**（会被覆盖）。
- **下载源全部带防缓存参数 `?t=<时间戳>`**（raw / jsDelivr 对分支有 CDN 缓存，不防就是"更新不了"）。
  因此**任何按 URL 精确匹配的桩/探针，比对前都要先去掉查询串**（`gsub("%?.*$","")`）。

---

## 构建 / 推送（本地流程，仓库里看不到脚本）

- 构建产物在本地 `dist/repo/`，通过 GitHub Contents API 推（脚本 `.workbuddy/build/push_now.py`）。
- 源码 → minify → 等价性校验 → 编译门禁 → 推 4 文件 → 回读逐字节验证。

## 事件库

`事件库/` 目录沉淀每次抓包的 Remote 清单，按功能分类。做"自动捡东西/自动购买/自动换弹/跳过动画"这类新功能前，先 grep 关键词查有没有对应信号。详见 `事件库/README.md`。
