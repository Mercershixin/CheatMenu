# AGENTS.md —— ⛔ 任何 AI / 智能体在本仓库动手前【必须】先读这份

> **这是强制规范（用户 2026-09-19 定稿）。**
> 不管你是什么模型、哪个账号、用哪个智能体框架：**改这个仓库的任何文件之前，先读完这一份。**
> 会自动加载本文件的工具（Codex / Cursor / Claude Code / Copilot / Windsurf / Cline / 各类 CLI Agent）直接就看到了；
> 没自动加载的，先 `cat AGENTS.md`。
>
> 同一份内容也放在这些位置（都指向这里）：
> `CLAUDE.md` · `.github/copilot-instructions.md` · `.cursor/rules/cheatmenu.mdc` ·
> 以及源码 `CheatMenu-*.lua` 的**文件头注释**。

---

## 0. 一句话版本

**只做用户明确要求的那一件事**；改完 → 钉版本号 → `push_now.py` → 结束。
（动了 `README.md`、`AGENTS.md`、`事件库/` 等文档才额外跑 `push_docs.py`。）

### 0.1 ⛔⛔ 测试只允许三种手段（用户 2026-09-20 定稿 · 最高优先级）

| # | 手段 | 本项目里的对应物 |
|---|---|---|
| ① | **静态分析** | `luau-compile`（编译门禁）· `luau-analyze` / `check_globals.py`（词法作用域）· `verify_all.py` 的接线/体检 · `build_dist.py` 的**等价性**比对 |
| ② | **单元测试** | 加载器探针 `run_probe_loader.py` / `run_probe_localloader.py` · `_equiv371.py` 三方 sha1 复核 |
| ③ | **云端执行（OCALE）** | 真正的运行时验证：把产物放进**真实执行器 / 云端**跑，看真实报错与真实表现 |

⛔ **整脚本仿真测试已【彻底禁用】—— 不要运行、不要修复、不要扩展。**

- 点名禁跑：`sim/run_full.py` · `sim/full_sim.lua` · `sim/run_smoke.py` · `sim/smoke_load.lua` · `sim/run_probe_v69.py`
- 原因：它是 `lupa 2.8 + Lua 5.5` 的 **mock 桩环境**，既不是 Luau 也不是 Roblox；
  真实物理/复制/服务端权威/执行器 API/UI 渲染一项都没覆盖，却**反复把"仿真台自身的坑"算成脚本 bug**，
  每次都要做改前对照实验才能定性 —— 成本远高于收益，且**永远替代不了实机**。
- `.workbuddy/sim/` 已**只读封存**，完整说明见 `.workbuddy/sim/DISABLED.md`。
- 工具链已同步改造：`publish.py` / `local_sync.py` 里的仿真段已删除（`--fast` / `--full` 只剩兼容意义）；
  `verify_all.py` 原 3.5/4/5/6b 四步已跳过并打印 `[SKIP]`，**静态部分照跑**。
- ⛔ **不要再造第四个 mock 环境来当门禁。** 用户的运行时验证只认③。

---

## 1. ⛔ 绝对不要做（用户已多次强调，踩过就被训）

1. **不要自作主张跑「测试循环 / 多轮深度验证」。**
   `verify_all.py`、`local_sync.py --full`、`check.py`、`check_globals.py`、`luau-compile`、`luau-analyze`、
   加载器探针 —— 这些**全都算"测试循环"**，
   **只在用户明确说「跑一下 / 验证一下 / 测试一下 / 发版」时才跑**。
   > 用户原话：**"我让你做你才做，没让你做我不做。"**

   ★ 2026-09-20 更正（**本节旧版说"发版必须跑仿真门禁"，那条已作废**）：整脚本仿真**已彻底禁用**（见 §0.1）。
   现在的发版门禁 = 等价性 + `luau-compile` + 加载器探针，`publish.py` / `push_now.py` **不带 `--fast` 也能过**。
   ⛔ 不要"顺手跑一次仿真"，也不要"修一下仿真台让门禁变绿"。

2. **UI 上标「不推荐 / 会被拉回 / 有风险」是给用户看的提示，不是让你改行为。**
   用户要的是「**标出来，我自己决定用不用**」——**不要**因此删选项、改默认值、加限制。

3. **不擅自新增功能、不动用户没让你动的地方。** 只做用户明确要求的那一件事。

4. **不要为了"验证我没改坏"去跑门禁。** 改完直接交付，或问用户要不要验。

5. 同一条请求**换个说法再问，答案要一致** —— 不因提问角度变化而放宽或收紧。

---

## 1.5 ⛔ 已删除功能 / 禁止回加清单（**最重要的一节**）

> 用户 2026-09-20 原话：**「让后面接替的智能体不要再拿老版本的东西给我重新加回来了（除非我提起的）」**
>
> 下面这些**用户明确要求删过**。**不要**因为"事件库里还写着""公开脚本里还有""看着挺有用"就加回来。
> 只有**用户本人重新提起**才能加。加回来 = 违反本节 = 返工。

### A. 已整块删除（配置键 + 后端函数 + 循环全删，`-253 行`）

| 功能 | 曾经的键 / 函数 |
|---|---|
| 反陷阱预警 | `TrapWatch` / `SYS.SetTrapWatch`（⚠  `SYS.ProbeTrapWatch` **例外，保留**——它被「综合扫描 → 陷阱/状态/锁定信号」用着） |
| 自动连用 | `AutoUse` / `SYS.SetAutoUse` / `SYS.AutoUseTick` |
| 自动领取 | `AutoClaim` / `SYS.SetAutoClaim` / `SYS.AutoClaimTick` |
| 自动收集 | `AutoPickup` / `SYS.SetAutoPickup` / `SYS.AutoPickupTick` |
| 死亡自动重生 | `AutoRespawn` / `SYS.SetAutoRespawn` / `SYS.AutoRespawnTick` |
| 自动商店 | `AutoShop` / `SYS.SetAutoShop` / `SYS.AutoShopTick` |
| 自动选队伍/角色 | `AutoTeam` / `SYS.SetAutoTeam` / `SYS.AutoTeamTick` |
| 自动表情 | `AutoEmote` / `SYS.SetAutoEmote` |
| 落脚点指示 | `SYS.SetFootstep` / `FSMark`（后端也已删除，不只是藏了入口） |

> `SYS.REMOVED_FEATURES` 黑名单**必须留着** —— 删掉配置键之后它反而更重要：挡住老存档把这些键复活。

### B. 界面入口已删、后端可能还在（**禁止恢复入口**）

| 功能 | 键 / 备注 |
|---|---|
| 人物方框 | 方框 / `SelectionBox` / `BoxHandleAdornment` 形态 —— 用户要的是**人物高亮**，v72 整块删 |
| 隐身 | v82 删（只能本地生效，别人仍看得到） |
| 锁定保持（粘性瞄准） | 用户早前明确删过；现在由优先链决定 |
| 命中率 / 漏打模式 | v6.9.17 删（`CB_MissMode` 等残键还在，`SYS.Combat` 主循环仍读它 —— **删残键要先动战斗主循环，风险另评**） |
| 快照瞄准 | v77 删（`CB_SnapFire` 残键同上） |
| 静默瞄准 | v74 起 `CB_Silent` 恒 false，原 ~210 行 hook 已永不执行（`CB_SilentAim` / `CB_SilentNoTurn` 残键同上） |
| 视场 pov / FOV 圈 / 距离标签 / 目标高亮 | v72 整组删 |
| 「进阶: 观察某个函数」 | v5.4.0 整段删（实现留在原处但无入口） |
| 手动的「立即保存 / 立即加载」 | v57 删（保存/读回**仍然是自动的**，只是没有手动按钮） |
| 物品栏来源诊断 | 2026-09-17 删 |
| 「整蛊」页 | 已删 —— **页面总数是 10 页，不是 11 页** |

### C. ⚠️ 用户 2026-09-20 明确说「还需要」的（**别再删**）

- **穿墙（NoClip）** —— 它的界面入口在 v6.9.6 被删过一轮，**v7.4.0 按用户要求加回来了**（移动页 `Noclip` 开关 + `SYS.SetNoclip`）。用户原话：「**穿墙的功能我还是需要的**」。后端 `SYS.SetNoclip` / `SYS.ApplyNoclip` / 卸载里的调用**都不要删**。
- **防甩飞 `AntiFling`**（v7.5.0 新增）—— 用户要求"整合补强加强功能"。它是纯本地速度清零（>80 格/秒），
  已纳入「🛡 一键开启全部防护」。**不要**因为"看着多余"删掉它；`SYS._flingN` 是它的计数，也别删。

### D. 已经按用户要求【合并过】的形态（**不要拆开**）

用户 2026-09-20 原话：「把这个能合并的 合并了。不建议的不合」。

- 「玩家透视 `ESP`」+「生物透视 `ESP_NPC`」→ 合并成 **「👁 活物透视」三态**（关闭 / 仅玩家 / 全部活物）
- 「玩家名字 `ESPNameTag`」+「头顶武器标记 `ESPWeapon`」→ 合并成 **「🪧 头顶标签」**（一个开关同时驱动两个池）
- 「小游戏区域透视 `ESP_Mini`」→ 并入 **「🔍 物件透视」总闸** + 分类表第 12 类「小游戏区域」
- 8 处功能各自的全量扫描 → **`SYS.Index()` 统一扫描索引器**（一次扫描 + 0.4s 缓存）
- 重复判据表 → **`SYS.Kw*` 共享常量**（`MiniArea` / `KwHazard` / `KwGate` / `KwTrap` / `KwCut` / `KwMpExtra` / `KwHidePick` / `KwHidePrompt` / `KwClue` / `KwClueText`）
- 4 处互锁判断 → **`SYS.ESPAnyOn()` / `SYS.ESPMaybeClear()`**

★ 刻意**没有**合并的两处（别"顺手"合并）：**藏身点判据分两份**（透视宽松 / 自动藏身严格，合了会跑去翻抽屉）；
**自动躲避不能用 `SYS.KwGate`**（多出的 `exit/stairs/teleport/fake` 会让它去躲出口）。

### E. 参数表的两张表别搞混

- `SYS.T_` = **开关布尔**（UI.Switch / UI.Cycle 驱动）
- `SYS.C_` = **参数值**（UI.Slider 驱动）
- 新增参数时先看代码读的是哪张表（**这个坑踩过**：`TracerMaxDist/TracerMaxN` 一开始加进了 `T_`，而代码读 `C_`）

### F. ⛔ 已删除的**代码路径**（不是功能，是"死路"，别再加回来）

- **`Humanoid.Target`**（原「无仇恨」第 ① 条通道）—— 官方 API 里 **Humanoid 没有 `Target` 属性**
  （只有 `Vector3` 的 `TargetPoint`），裸读必抛 `Target is not a valid member of Humanoid`。
  v7.5.1 已整条删除（包 `pcall` 也不行 —— 那只是把异常变成"每个怪每 0.5s 一次"）。
  无仇恨**只走 Attribute 通道**（`Target|Enemy|Aggro|TargetPlayer|TargetEntity|Hostile`）。
  仿真台有**结构性断言**盯着源码文本：出现 `h.Target` 立刻判红。

---

## 2. 🎨 透视 / 高亮配色规范（用户口径，别再自己加颜色）

| 对象 | 颜色 |
|---|---|
| **所有高亮** | **边框高亮**：填充近乎透明（0.88 / 隔墙 0.93），只留描边轮廓 |
| **普通物件 + 普通门** | **统一亮青** `(0,200,255)`，描边 `(0,170,230)` |
| **危险**（陷阱 / 伤害机关 / 切割 / **假门**） | **红色** `(255,30,30)`，描边 `(255,0,0)` **+ ☠ 骷髅头** |
| 人物 | 队友 **绿** / 敌人 **红** / 幽灵态 **紫** |
| 怪物 · NPC | **橙** |

- 「普通物件」= 可交互的**全部分类**：箱子·收纳 / 拾取物 / 道具·补给 / 躲藏点 / 书籍·纸张·线索 /
  梯子 / 按钮·机关 / 传送 / 座位 / 商店 / 检查点 —— 外加「文字线索」（部件挂 `SurfaceGui` 且有字）、
  掉落物透视、小游戏区域。**分类名只当命中判据与自诊断标签，不再各自配色。**
- ☠ 只给**危险**挂，普通门不挂。
- **三个透视（掉落物 / 可交互 / 门·陷阱·假门）已合并成一个开关**「🔍 物件透视」——别再拆开。

---

## 3. 🗂 目录与文件（别搞混）

- **本地工作区 `Hy-MT2翻译模型/`**（唯一手改入口）：
  - `CheatMenu-6.9.1.lua` = **源码**（带注释，手改只改这里）
  - `.workbuddy/build/*.py` = 构建 / 推送 / 同步脚本
  - `.workbuddy/memory/` = 项目记忆与每日日志（**不进仓库**）
  - `事件库/` = 抓包清单（**要进仓库**）
- **仓库 = 发行产物**：`CheatMenu.lua`（minify）/ `version.txt` / `loader.lua` / `CHANGELOG.md` 四件套，
  外加 `README.md`、`AGENTS.md`、`事件库/`。
- **推送不是 `git push`** —— 走 GitHub Contents API（`push_now.py` / `push_api.py`；文档走 `push_docs.py`）。
  所以本地 git 落后远程属**常态**，别用 git log 判断"有没有推上去"。
- 事件库：抓包清单按 `事件库/YYYY-MM-DD_游戏名.md` 归档，**游戏名一定要写**。

---

## 4. 🚀 发版流程（固定，别自己发挥）

```
1. 改源码                    CheatMenu-6.9.1.lua
2. 顶层写 CHANGELOG 条目      dist/repo/CHANGELOG.md   ← 版本号要和 version.txt 对齐
3. python .workbuddy/build/push_now.py --patch
      · 修 bug 加 --patch；新功能不加（不加就是"次+1"）
      · 退出码 1 ≠ 失败；看日志里有没有 "!! API 推送失败"
      · ★ 2026-09-20: 不带 --fast 也是一样的(整脚本仿真已彻底禁用, 见 §0.1)
4. 若第 3 步 API 失败 → python .workbuddy/build/push_api.py   （兜底通道）
5. python .workbuddy/build/local_sync.py                      （同步执行器本地版）
6. 回读核对： version.txt == CHANGELOG.md 顶部
7. 动了 README.md / AGENTS.md / CLAUDE.md / .github/ / .cursor/ / 事件库/ → python .workbuddy/build/push_docs.py
```

---

## 5. 🧭 能力边界（别写"做不到"的承诺，也别瞎吹）

- **服务端权威**的东西（余额 / 物品数量 / 购买 / 复活 / 藏身状态 / 怪的判定 / 踢人）客户端改不动 ——
  只能做「本地提示」或「发请求」，能不能成看服务端。
- **高亮 / 透视 / 本地画面效果**是纯客户端视觉，安全，随便做。
- **别碰反作弊蜜罐 remote**（例：DOORS 的 `DroneStickyNoteMyNameIsExploiterAndIThinkICanCheatWithThis`）、
  管理通道（`AdminPanelRunCommand` / `SendErrorLog` / `ServerLog`）、第三方权限框架（`conch_networking.*`）、
  数据复制框架的**写**通道（`Replica_*`）。
- 判据优先级永远是：**真名 > 结构 > 形状猜**。名字对不上就找用户要真名，别瞎猜。

---

## 6. 📌 当前项目状态速查

- 仓库：`Mercershixin/CheatMenu`（分支 `main`）· 版本见 `version.txt`
- 主攻游戏随用户变（今天可能是 **MachineParty（机器派对）** 或 **DOORS（门）**）
- 事件库清单在 `事件库/`（每个游戏一份，含权威 Attribute / Remote 分类 / 可做功能映射）
- 详细历史看 `CHANGELOG.md`（很长，搜关键词就行）

### 6.1 仿真台（`.workbuddy/sim/`）—— ⛔ 2026-09-20 起【彻底禁用 · 只读封存】

> **用户 2026-09-20 原话：「彻底禁用仿真测试 …… 现在的测试只能静态分析 单元测试 云端执行（OCALE）」**
>
> **不要运行、不要修复、不要扩展。** 只允许的三种验证手段见 **§0.1**。
> 完整禁用说明（为什么禁 / 谁被点名 / 工具链改了什么）见 `.workbuddy/sim/DISABLED.md`。
> 下面这些是**历史记录**，留着是为了「别踩同一个坑」，**不是**让你复活它。

- 历史入口（**已禁跑**）：`run_full.py` → `full_result.txt`；`run_smoke.py`；`run_probe_v69.py`
- 运行时真相：**lupa 2.8 + Lua 5.5**（不是 Luau！所以 Luau 合法的写法在仿真里可能报错，反之亦然）
- 最后一次跑通的基线（**历史值，不再是任何门禁**）：253 通过 / 0 失败 / 0 条吞错误
- 踩过的坑（**新写测试时别重复**）：
  - `stepAll(dtMax)` **只把虚拟时钟推进到"窗口内确实有事件"的时间点**；队列稀疏时时钟原地不动，
    于是 `task.wait(0.5)` 那种协程**永远等不到唤醒**。要"按真实时间推进"得用 `advanceTime`。
    教训：**别自己写 mock 时钟** —— 这正是仿真台反复误报的根源之一。
  - 桩对未知键一律"能读能写"，于是脚本里"猜某字段存在"的写法**永远不报错**（假通过）。
    → 教训：**先去官方 API 文档确认字段存不存在**，别靠推理、更别靠 mock 验证。
  - 断言"某计数器涨了"时**必须记窗口起点再比差值**（`>0` 会吃到旧值）。
  - `string.format` 的 `%d` 在 Luau 截断浮点、在 Lua 5.5 抛 `number has no integer representation`。
  - 精确豁免只该针对**预期的**那一类失败，别开"整段豁免窗口"（会把真正依赖的错误一起吞掉）。
- 仿真台**天然测不到**的东西（所以它替代不了实机）：真实物理/碰撞、真实复制与延迟、服务端权威、DataStore、
  动画、**真实 UI 渲染**、真实执行器差异。
