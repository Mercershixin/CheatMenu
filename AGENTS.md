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

**只做用户明确要求的那一件事**；改完 → 钉版本号 → `push_now.py --fast` → 结束。
（动了 `README.md` 或 `事件库/` 才额外跑 `push_docs.py`。）

---

## 1. ⛔ 绝对不要做（用户已多次强调，踩过就被训）

1. **不要自作主张跑「仿真 / 模拟检测循环 / 多轮深度验证」。**
   `verify_all.py`、`local_sync.py --full`、`sim/run_full.py`、`sim/run_smoke.py`、
   `check.py`、`check_globals.py`、`luau-compile`、`luau-analyze` —— 这些**全都算"测试循环"**，
   **只在用户明确说「跑一下 / 验证一下 / 测试一下 / 发版」时才跑**。
   > 用户原话：**"我让你做你才做，没让你做我不做。"**

   ★ 2026-09-20 补充：**发版流程里的仿真门禁是固定步骤**（见 §4；`publish.py` 不加 `--fast` 就会跑它，
   用户称「仿真循环检测也是必须的」）。这条规则约束的是**"别自己加戏跑额外验证"**，不是"发版时跳过门禁"。
   仿真台本身已修成全绿（见 §6.1），**用户明确要求不要绕过它**。

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
3. python .workbuddy/build/push_now.py --fast --patch
      · 修 bug 加 --patch；新功能不加（不加就是"次+1"）
      · 退出码 1 ≠ 失败；看日志里有没有 "!! API 推送失败"
4. 若第 3 步 API 失败 → python .workbuddy/build/push_api.py   （兜底通道）
5. python .workbuddy/build/local_sync.py --no-sim-target      （同步执行器本地版）
6. 回读核对： version.txt == CHANGELOG.md 顶部
7. 动了 README.md / 事件库/ → 再跑 python .workbuddy/build/push_docs.py
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

### 6.1 仿真台（`.workbuddy/sim/`）—— 2026-09-20 已修成全绿

- 入口：`<lua53 的 python> .workbuddy/sim/run_full.py CheatMenu-6.9.1.lua` → 结果写 `.workbuddy/sim/full_result.txt`
  （**注意：仿真的 stdout 被 `run_full.py` 捕获进 `full_result.txt`，不要在终端 grep 仿真输出**）
- 运行时真相：**lupa 2.8 + Lua 5.5**（不是 Luau！所以 Luau 合法的写法在仿真里可能报错，反之亦然）
- 当前基线：**246 通过 / 0 失败 / 被 pcall 吞掉的错误 0 条**（`publish.py` 不加 `--fast` 现在能一次过）
- 已修的关键缺口（**别再改回去**）：
  - `string.format` shim —— Luau 的 `%d` 会截断浮点，Lua 5.5 会抛 `number has no integer representation`；这一个缺口曾经造出 1400+ 条假错误
  - `_G.__restoreMe()` —— "点遍所有按钮"会点到「☠ 强制自杀(抹除)」，那个按钮**真的会 `hum:Destroy()`**；真机由引擎重生，仿真台必须等价补上，否则之后所有依赖 `GC()` 的用例静默失效
  - `__SUPPRESS`/精确豁免 —— 只豁免「HttpGet 未登记 URL」这一种**预期内**失败；**不要**开整段豁免窗口（会把用例真正依赖的错误也吞掉）
  - 中性键名 —— 启动锁/更新提示是 `SYS.GK.boot` / `SYS.GK.note`（**不是** `CheatBootDone`）；战斗循环绑定名是 `SYS.N.Combat`（**不是** `CheatMenuCombat`）
  - 执行器桩 —— `newcclosure` / `cloneref` / `setreadonly` / `fireproximityprompt` / `fireclickdetector` / `getconnections` / `getnilinstances` / `checkcaller` / `getreg` / `getgc` / `MarketplaceService`
  - 设计联动白名单 `PAIRED` —— 8 组（`ESP_Pick`→三类物件、`GodMode`→NoDeath/NoKnock、`Prot_HideGui`→两个防护、`Lantern`/`NoFog`/`NoAggro`、`ESPNameTag`→`ESPWeapon`、`CB_SilentNoTurn`→`CB_SilentAim`）
- 仿真台**测不到**的东西（别拿它当"实机通过"）：真实物理/碰撞、真实复制与延迟、服务端权威、DataStore、
  动画、**真实 UI 渲染**（`SIM_NO_WIDGETS=true`，仿真台只注册回调、不建 WindUI 元素）、真实执行器差异
