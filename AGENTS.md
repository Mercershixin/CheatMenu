# AGENTS.md —— ⛔ 任何 AI / 智能体在本仓库动手前【必须】先读这份

> **这是强制规范。** 不管你是什么模型、哪个账号、用哪个智能体框架：**改这个仓库的任何文件之前，先读完这一份。**
> 会自动加载本文件的工具（Codex / Cursor / Claude Code / Copilot / Windsurf / Cline / 各类 CLI Agent）直接就看到了；
> 没自动加载的，先 `cat AGENTS.md`。
>
> 同一份内容也在这些位置 —— **改这份就必须同步那几处**，否则下个智能体读到的是旧规矩：
> `CLAUDE.md` · `.github/copilot-instructions.md` · `.cursor/rules/cheatmenu.mdc` ·
> `dist/repo/README.md` 的「开发约定」节 · 源码 `CheatMenu-<版本>.lua` 的**文件头注释块**。
>
> ★ **本版按 8.x 现状整篇重写（2026-09-20）。**
> 旧版里到处是「××旧规则已作废」「只在用户明确要求时才做 —— 这个口子已作废」这类**考古叙述**。
> 已全部删除：那种残留的害处是**后来者会把已经作废的那半句当成"还能援引的口子"**，正是它制造新问题。
> 现在这版只写**当前有效**的规则。§8 的指标全部实测、§9 给了复核脚本 —— **不信就跑一遍**。

---

## 0. 一句话版本

**只做用户明确要求的那一件事**；改完 → 钉版本号 → `push_now.py` → `local_sync.py` → 结束。
（动了 `README.md` / `AGENTS.md` / `CLAUDE.md` / `.github/` / `.cursor/` / `事件库/`，才额外跑 `push_docs.py`。）

---

## 0.1 ⛔⛔ 验证只允许三种手段

> **这是唯一有效的版本。没有例外，也没有「用户要求就能跑」的口子。**

| # | 手段 | 本项目里的对应物 |
|---|---|---|
| ① | **静态分析** | `luau-compile`（编译门禁）· `luau-analyze` / `check_globals.py`（词法作用域）· `verify_all.py` 的接线体检 · `build_dist.py` 的**等价性**比对 |
| ② | **单元测试** | 加载器探针 `run_probe_loader.py` / `run_probe_localloader.py` · 三方 sha1 复核 · **`_ballistic_unit.py`**（从发行源码里**原样抽出真代码** + 真 `luau.exe` 跑 —— 这是"①/②"类的样板做法） |
| ③ | **真云端分发链路验证** | `cloud_verify.py`：真网络 / 真 CDN / 真字节，验**云端实际发给用户的字节**是否与本地发行产物**逐字节一致**、能否编译。**不需要真机，也不需要在执行器里跑 Lua 功能。** |

### ⛔ 一并禁用的东西（**没有例外**）
- **整脚本仿真 / 任何 mock 环境**：`sim/run_full.py` · `sim/full_sim.lua` · `sim/run_smoke.py` ·
  `sim/smoke_load.lua` · `sim/run_probe_v69.py` —— **不运行、不修复、不扩展**。`.workbuddy/sim/` 只读封存。
  **原因**：它是 `lupa + Lua 5.5` 的桩环境，**既不是 Luau 也不是 Roblox**；
  真实物理/碰撞/复制/服务端权威/执行器 API/UI 渲染**一项都没覆盖**，
  却反复把"仿真台自己的坑"算成脚本 bug，每次都要做改前对照实验才能定性 —— 成本远高于收益，且**永远替代不了实机**。
- **循环检测**（= 「模拟 → 修复 → 再模拟 → 再修复」那种多轮深度验证）：同样**彻底禁用**。
- **不要再造第四个 mock 环境来当门禁。** 用户要真的验证，就走 **③**。
- **不要为了"确认我没改坏"顺手跑一遍门禁。** 改完直接交付，或问用户要不要验。
  > 用户原话：**"我让你做你才做，没让你做我不做。"**

> **唯一例外**：**用户本轮明确说了**「跑一下 / 验证一下 / 测试一下 / 发版」。
> 此时按 §5.2 走发版流程。
> （发版本身要跑 `push_now.py` —— 那是**交付步骤**，不是"额外的验证循环"，不受本节限制。）

---

## 1. ⛔ 绝对不要做

1. **不跑任何被禁的测试手段**（见 §0.1）—— 这是被训过最多的一条。
2. **UI 上标「不推荐 / 会被拉回 / 有风险」是给用户看的提示，不是让你改行为。**
   用户要的是「**标出来，我自己决定用不用**」—— 不要因此删选项、改默认值、加限制。
3. **不擅自新增功能、不动用户没让你动的地方。** 只做用户明确要求的那一件事。
4. **同一条请求换个说法再问，答案要一致** —— 不因提问角度变化而放宽或收紧。
5. **⛔ 不挂 `__namecall` / `__index` 总入口做关键词搜索**（详见 §4）。
6. **不靠推理猜引擎字段存不存在** —— 先查官方 API 文档（踩过：`Humanoid.Target` 根本不存在，见 §2-F）。

---

## 2. ⛔ 已删除功能 / 禁止回加清单（**最重要的一节**）

> 用户原话：**「让后面接替的智能体不要再拿老版本的东西给我重新加回来了（除非我提起的）」**
>
> 下面这些**用户明确要求删过**。**不要**因为"事件库里还写着""公开脚本里还有""看着挺有用"就加回来。
> 只有**用户本人重新提起**才能加。加回来 = 违反本节 = 返工。

### A. 已整块删除（配置键 + 后端函数 + 循环全删）

| 功能 | 曾经的键 / 函数 |
|---|---|
| 反陷阱预警 | `TrapWatch` / `SYS.SetTrapWatch`（⚠ `SYS.ProbeTrapWatch` **例外保留** —— 它被「综合扫描 → 陷阱/状态/锁定信号」用着） |
| 自动连用 | `AutoUse` / `SYS.AutoUseTick` |
| 自动领取 | `AutoClaim` / `SYS.AutoClaimTick` |
| 自动收集 | `AutoPickup` / `SYS.AutoPickupTick` |
| 死亡自动重生 | `AutoRespawn` / `SYS.AutoRespawnTick` |
| 自动商店 | `AutoShop` / `SYS.AutoShopTick` |
| 自动选队伍 / 角色 | `AutoTeam` / `SYS.AutoTeamTick` |
| 自动表情 | `AutoEmote` |
| 落脚点指示 | `SYS.SetFootstep` / `FSMark`（后端也已删除，不只是藏了入口） |
| **重生点记账**（原地重生 / 设置当前位置为重生点 / 恢复默认重生点） | `SYS.SpawnRec` / `SYS.SetSpawnHere` / `SYS.ClearSpawnHere` / `SYS.RespawnHere` + `SYS.SetLoop("SpawnHere",…)` + `SYS.FuseClean` 里的调用 + 「☠ 自杀 / 重生点」里那 3 个按钮。用户 2026-09-21 原话：**「原地重生 出生地设置 恢复默认重生 删除吧 没用」** —— 重生位置由服务端决定时，本地写 `RespawnLocation` 根本无效。⚠ **不要**与 `SYS.GetSpawnRec` / `SYS.SetSpawnRec`（传送系记"默认出生点"的另一套）搞混，**那两个是保留的**。 |
| **翻译云端后端**（硅基流动） | `TransSili` 配置键 + `SILI_URL` / `SILI_KEY` / `SILI_MODEL` / `SILI_MAXTOK` / `SILI_MAXCONC` + `backend()` 的云端分支 + 翻译页「🔀 翻译后端」下拉；**一律不要加回来** —— 用户 2026-09-21 实测「api 翻译也慢」后定稿**只走本机 llama.cpp**（同一条文本云端 hot 0.32s / cold 1.38s，本地 hot 0.05s；云端还被免费档限流卡在并发 4）。⚠ 别拿"能吃云端就不用开本机模型"当理由恢复它。 |
| **数值锁定**（锁移速 / 锁跳跃 / 锁世界重力） | 键 `LockSpeed` / `LockJump` / `LockGravity` + `C_.Gravity` + `SYS.SetLocks` / `SYS.LockTick` / `SYS.T_.LockTick` 循环 + 移动页「数值锁定」分区。⚠ 移动页现在只有 飞行/移动加速/穿墙/免伤/跳跃。**注意**：世界重力的还原走的是 `SYS.Orig.Gravity`（在 `UnloadAll` 里），与这块无关，别连坐删。 |
| **滤镜控制器**（色盲滤镜 / 后处理饱和度） | 键 `FX_Enable` / `C_.FX_Sat` / `C_.FX_Bri` / `C_.FX_Con` / `C_.FX_CB` + 整个 `SYS.FX`（`FX.Apply` / `FX.HidePost` / `FX.RestoreAll` / `FX.Modes`） + `SYS.FuseClean` 里的调用。滤镜页早在 6.7 融合期就没入口，`FX.Apply` **全文件 0 调用**。⚠ `SYS.N.FX`（中性名池成员）**保留**：它只是名字池，不代表功能回来了。 |
| **多路径点列表**（路径点增删 / 标记 / 直达） | 键 `WPShow` / `WPKey` + `WP.Add` / `Remove` / `Mark` / `Unmark` / `UnmarkAll` / `RefreshMarks` / `Goto` / `Stop` + `WP.List` / `WP.Marks` + Ctrl+数字 里的「路径点优先」分支 + 卸载时的标记改名。⚠ **保留** `WP.TweenTo` / `WP.WalkTo` —— 玩家控制的「缓动到他 / 寻路走到他」还在用；⚠ 也别把 **`PathKey`（Ctrl+数字 直达已保存位置）** 当同类删掉（见 §2 C）。 |
| **自动跳低延迟服务器** | 键 `AutoLowPing` + `SYS.HopLowPing` / `SYS.AutoHopCheck`（6.9.19 CHANGELOG 原话点名它是"删 UI 后残留"）。⚠ 传送页的 **「🔄 重进服务器 (Rejoin)」** 与 `SYS.JoinServer` **是另一套，保留**。 |
| **手动选服**（列出服务器自己挑） | `SYS.FetchServers` —— 只读列表面板，界面入口早已不存在。与上面那条同一次清理。 |
| **整蛊工具**（甩飞 / 旋转 / 黑洞 / 就近击杀…） | 8 个开关键 `PG_Spin` / `PG_SpinHit` / `PG_FlyHit` / `PG_WalkHit` / `PG_HideHit` / `PG_OrbitTool` / `PG_BlackHole` / `PG_KillNear` + 参数键 `PG_SpinSpeed` / `PG_OrbitRange` / `PG_OrbitSpeed` / `PG_OrbitMode` / `PG_BH_*` / `PG_KillDist` / `PG_Target` + **整个 `SYS.Prank`**（`local PG={} SYS.Prank=PG` 与 `PG.*` 全部函数）+ 卸载里的 `PG.StopAll` / `PG.OrbitTool`。整蛊页 6.9.6 就删了（全是"只改本地副本，对方看不到、服务端不认"）。 |
| **邻居冻结 / 眨眼**（玩家控制里的两条残留） | `PC_Freeze` 键 + `PC.Freeze()`（整蛊工具，同族）+ `PC.Blink()`（全文件 **0 调用**）+ `SYS.FuseClean` 里的 `P(PC.Freeze,false)`。⚠ **保留**「跟随 / 环绕」那五态（`PC_LoopTP` / `PC_OnHead` / `PC_Orbit` / `PC_Stare` / `PC_Follow`）—— 它们由互斥下拉 `PC.ApplyFollowMode` 驱动，是活的。 |
| **命中率 / 漏打闸门**（瞄准补强） | 键 `CB_MissMode` + `C_.CB_HitRate` / `C_.CB_MissRate` + `SYS.AimEx`（`HitGate` / `MissGate`）。**两个闸门函数从来没有调用方** ⇒ 危害不是"会打偏"，而是【老存档能把 `CB_MissMode=true` 复活成一个没有界面的假开关】。 |

★ **`SYS.REMOVED_FEATURES` 黑名单必须留着** —— 删掉配置键之后它反而更重要：挡住老存档把这些键复活。
（9.9.0 核验：上表这些键在当前源码里**只出现在 `REMOVED_FEATURES` 黑名单中**，后端确实没有了。
复跑 `.workbuddy/build/_audit_members.py` 的 B 项 = `REMOVED_FEATURES` 的键在正文里无残留，应为 0。）

### B. 界面入口已删、后端残键仍在（**禁止恢复入口**）

| 功能 | 残键 / 备注 |
|---|---|
| 人物方框 | 方框 / `SelectionBox` / `BoxHandleAdornment` 形态 —— 用户要的是**人物高亮** |
| 隐身 | 只能本地生效（别人仍看得到），已删 |
| 锁定保持（粘性瞄准） | 已删；现在由**优先链**决定目标 |
| 快照瞄准 | `CB_SnapFire` 等残键仍在 |
| 静默瞄准（老的整块 hook） | `CB_Silent` 恒 `false`；`CB_SilentAim` / `CB_SilentNoTurn` 是**活的**（真·静默走 §A33 射线改写，UI 在战斗页） |
| 视场 pov / FOV 圈 / 距离标签 / 目标高亮 | 整组已删 |
| 「进阶: 观察某个函数」 | 界面入口已删（实现留在 `SYS.Lab` 里但无入口 —— 不占界面、也不会被误触） |
| 手动的「立即保存 / 立即加载」 | 已删（**保存 / 读回仍然是自动的**，只是没有手动按钮） |
| 物品栏来源诊断 | 已删（`[08.4]` 只剩 4 行墓碑注释 —— 那是**刻意的标注**，不是垃圾） |

> ⚠ **残键的处置口径：不要顺手删。** 战斗主循环仍在读它们（`CB_Silent` / `CB_SnapFire` / `CB_360` / …），
> 删键要先改主循环，**风险另评**。
>
> ★★ **例外（2026-09-21，v9.9.0）**：全功能体检（`_audit_switch_wiring.py` + `功能体检-9.8.1-20260921.md`）
> 把 `SYS.T_` 的 101 个开关逐个与界面区块对账后，**已经确认"零界面入口 + 零活调用方"的那一批残键
> 连同它们的后端一起删干净了**（清单见 §A 末 9 行）。也就是说：
> `CB_MissMode` / `WPShow` / `WPKey` / `FX_Enable` / `AutoLowPing` / `PC_Freeze` / `Lock*` / `PG_*`
> **现在是【已删】，不要再当"还在的残键"处理**；但 `CB_Silent` / `CB_SnapFire` 这些**主循环在读的**
> 仍然按上面的口径**不许顺手删**。

### C. ⚠️ 用户明确说「还需要」的（**别再删**）

- **穿墙（NoClip）** —— 界面入口删过一轮，**已按用户要求加回来**（移动页 `Noclip` 开关 + `SYS.SetNoclip`）。
  用户原话：「**穿墙的功能我还是需要的**」。`SYS.SetNoclip` / `SYS.ApplyNoclip` / 卸载里的调用**都不要删**。
- **防甩飞 `AntiFling`** —— 纯本地速度清零（> 80 格/秒），已纳入「🛡 一键开启全部防护」。
  **不要**因为"看着多余"删掉它；`SYS._flingN` 是它的计数，也别删。
- 同理别当"没用的小功能"清掉的：**`InfiniteJump`（无限跳）**、**`PathKey`（Ctrl+数字 路径点直达）**。

### D. 已按用户要求【合并过】的形态（**不要拆开**）

> 用户原话：「把这个能合并的 合并了。不建议的不合」。

- 「玩家透视」+「生物透视 `ESP_NPC`」→ **「👁 活物透视」三态**（关闭 / 仅玩家 / 全部活物）
- 「玩家名字 `ESPNameTag`」+「头顶武器标记 `ESPWeapon`」→ **「🪧 头顶标签」**（一个开关同时驱动两个池）
- 「小游戏区域透视 `ESP_Mini`」→ 并入 **「🔍 物件透视」总闸** + 分类表第 12 类「小游戏区域」
- 「掉落物 / 可交互 / 门·陷阱·假门」三个透视 → **「🔍 物件透视」一个总闸**
  （绑 `ESP_Pick`，onChange 里同步 `SYS.T_.ESPItem` / `SYS.T_.ESP_Door`）
- 8 处功能各自的全量扫描 → **`SYS.Index()` 统一扫描索引器**（一次扫描 + 0.4s TTL 缓存）
- 同一套判据被抄成多份 → **`SYS.Kw*` 共享常量**
  （`MiniArea` / `KwHazard` / `KwGate` / `KwTrap` / `KwCut` / `KwMpExtra` / `KwHidePick` / `KwHidePrompt` / `KwClue` / `KwClueText`）
- 4 处几乎相同的互锁判断 → **`SYS.ESPAnyOn()` / `SYS.ESPMaybeClear()`**

★ **刻意没有合并的两处**（别"顺手"合并）：
- **藏身点判据分两份**：`KwHidePick`（透视，宽松）/ `KwHidePrompt`（自动藏身，严格）——
  合并的后果：要么自动藏身跑去翻抽屉，要么该亮的藏身点不亮。
- **自动躲避不能用 `SYS.KwGate`** —— 多出的 `exit / stairs / teleport / fake` 会让它去**躲出口**，那是行为事故不是功能。

### E. `SYS.T_` / `SYS.C_` 两张表别搞混

- `SYS.T_` = **开关布尔**（`UI.Switch` / `UI.Cycle` 驱动）
- `SYS.C_` = **参数值**（`UI.Slider` 驱动）
- 新增参数时先看代码读的是哪张表（**这个坑踩过**：`TracerMaxDist` / `TracerMaxN` 一开始加进了 `T_`，而代码读 `C_`）

### F. 已删除的**代码路径**（不是功能，是"死路"）

- **`Humanoid.Target`**（原「无仇恨」第 ① 条通道）—— 官方 API 里 **Humanoid 没有 `Target` 属性**
  （只有 `Vector3` 的 `TargetPoint`），裸读必抛 `Target is not a valid member of Humanoid`。
  已整条删除（**包 `pcall` 也不行** —— 那只是把异常变成"每个怪每 0.5s 一次"）。
  无仇恨**只走 Attribute 通道**（`Target|Enemy|Aggro|TargetPlayer|TargetEntity|Hostile`）。
  ⛔ 不许加回来。判据：**猜字段存在之前先去官方 API 文档确认它存不存在**，别靠推理、更别靠 mock 验证。

---

## 3. 🎨 透视 / 高亮配色规范（用户口径，别再自己加颜色）

| 对象 | 颜色 |
|---|---|
| **所有高亮** | **边框高亮**：填充近乎透明（`0.88` / 隔墙 `0.93`），只留描边轮廓 |
| **普通物件 + 普通门** | **统一亮青** `(0,200,255)`，描边 `(0,170,230)` |
| **危险**（陷阱 / 伤害机关 / 切割 / **假门**） | **红色** `(255,30,30)`，描边 `(255,0,0)` **+ ☠ 骷髅头** |
| 人物 | 队友 **绿** / 敌人 **红** / 幽灵态 **紫** |
| 怪物 · NPC | **橙** |

- 「普通物件」= 可交互的**全部分类**（箱子·收纳 / 拾取物 / 道具·补给 / 躲藏点 / 书籍·纸张·线索 /
  梯子 / 按钮·机关 / 传送 / 座位 / 商店 / 检查点）—— 外加「文字线索」（部件挂 `SurfaceGui` 且有字）、
  掉落物透视、小游戏区域。**分类名只当命中判据与自诊断标签，不再各自配色。**
- ☠ **只给危险挂**，普通门不挂。
- 这条规范的历史版本写在 `dist/repo/CHANGELOG.md` 的历史条目里 ——
  **用户说"我的提示 / 规范"时，先去 CHANGELOG 搜关键词**。

---

## 4. 🔌 执行器接口红线（**单点可以，总入口不行**）

| | |
|---|---|
| ✅ **允许** | **单点 `hookfunction`** —— 明确目标是哪个函数就 hook 哪个（例：`game.Shutdown`、`Players.BanAsync`）。**平时零开销**。 |
| ✅ **优先** | **只读侦察** —— `getconnections` / `GetChildren` / `ClassName` / `GetFullName` / `GetAttributes` / llama.cpp 的 `/props`。 |
| ⛔ **禁止** | `hookmetamethod(game,"__namecall")` **或** `hookmetamethod(game,"__index")` 做**关键词搜索** —— 那是**所有实例方法调用的总入口**，实测就是"开了过检测**极度卡顿掉帧**"的病根。 |
| ⛔ **禁止** | 为了同一个目的再挂一条 `__index` 总入口。 |
| ⛔ **禁止** | 把 `UIS.InputChanged` 写在控件构造函数里 —— 必须**共享**（全局一条 + `SYS._SlActive` 指针分发）。42 个调用点 = 42 条回调 = **手机卡**。 |

- 「反踢 / 反检测」的正解是 **不 hook 总入口、只挪进执行器隐藏容器**（见 `[12C]` 反作弊靶场与 `Prot` 模块）。
- 「一键全扫描」的 DEX 层 / Remote 层也是照这条做的：全靠 `GetChildren` / `ClassName` / `GetFullName` /
  `getconnections`（只读枚举）。**不挂 `__namecall` 去抓 `FireServer`。**

---

## 5. 🗂 目录 / 文件 / 发版

### 5.1 目录（别搞混）

- **本地工作区 `Hy-MT2翻译模型/`**（唯一手改入口）：
  - `CheatMenu-<版本>.lua` = **源码**（带注释；**文件名跟版本号走** —— 发版时 `push_now.py` 自动改名为
    `CheatMenu-<版本>.lua`，人不用管；手改只改这里）。
    ★ 定位源码**一律走 `.workbuddy/build/srcpath.py`**，任何脚本都不许硬编码这个名字。
  - `.workbuddy/build/*.py` = 构建 / 推送 / 同步 / 审计脚本
  - `.workbuddy/memory/` = 项目记忆与每日日志（**不进仓库**）
  - `事件库/` = 抓包清单（**要进仓库**）
- **仓库 = 发行产物**：`CheatMenu.lua`（minify）/ `version.txt` / `loader.lua` / `CHANGELOG.md` **四件套**，
  外加 `README.md`、`AGENTS.md`、`事件库/`。
- ★★ **报告与源码备份不进项目本体，进仓库**（用户 2026-09-20 定）：
  - `文档存档/` = 开发过程中的报告（功能总览 / 功能体检 / 各批次审计 / 翻译模块 / 云端验证 …）
  - `源码快照/CheatMenu-<版本>.lua` = **当前版带注释源码**（`push_docs.py` 推）
  - `源码快照/历史备份/` = **旧版本源码快照**（`.bak-*` / `.keep-*`）
  - 本地暂存在**项目外**：`C:\Users\Administrator\Desktop\CheatMenu-归档暂存\`
    （`报告存档/`、`源码快照/`、`backups/source/`）—— **项目根目录只留源码/规范/`dist/`/`事件库/`/两个 bat**。
  - 推送脚本：`push_docs.py`（源码快照）+ `push_archive.py`（文档存档 + 历史备份，走 Contents API）。
    ⛔ **别用 `git push` 推这些** —— `dist/repo` 的本地 git 落后于远端（远端更新是走 API 的），
    一律 `git push` 会把 `AGENTS.md` / `CLAUDE.md` 等**回退成旧版**。
- **推送不是 `git push`** —— 走 GitHub Contents API（`push_now.py` / `push_api.py`；文档走 `push_docs.py`）。
  所以**本地 git 落后远程属常态**，别用 `git log` 判断"有没有推上去"。
- 事件库按 `事件库/YYYY-MM-DD_游戏名.md` 归档，**游戏名一定要写**。
- 加载方式：把 `loader.lua` 整段粘进执行器执行，主脚本走网络加载（绕开输入框长度限制），内置多个源兜底。

### 5.2 发版流程（固定，别自己发挥）

```
1. 改源码                     CheatMenu-<版本>.lua（名字自动跟版本，别手改文件名）
2. 顶层写 CHANGELOG 条目       dist/repo/CHANGELOG.md   ← 版本号要和 version.txt 对齐
3. python .workbuddy/build/push_now.py --patch
     · 修 bug 加 --patch；新功能不加（不加就是"次+1"）
     · 退出码 1 ≠ 失败；看日志里有没有 "!! API 推送失败"
     · 不带 --fast 也一样（整脚本仿真已彻底禁用，见 §0.1）
4. 第 3 步 API 失败 → python .workbuddy/build/push_api.py   （兜底通道）
5. python .workbuddy/build/local_sync.py                      （同步执行器本地版）
6. 回读核对： version.txt == CHANGELOG.md 顶部 == 远端实际文件
7. 动了文档 / 事件库 → python .workbuddy/build/push_docs.py
```

★ **版本号规则**（`version.py`）：默认「次+1」；**次到 10 之后下一版进位到主号** ——
所以 `6.10.9` 次+1 = **`7.0.0`**（**不是 6.11.0**！）。
**写 CHANGELOG 之前先跑一次构建、或先看 `.workbuddy/build/VERSION`，别靠猜**（7.0.0 那次就猜错成 6.11.0，被迫重推）。

### 5.3 连通性（本机实测；会抖，别当常量）

- `api.github.com` **直连可用**；`github.com` 的 **git 直连被重置** → git 走镜像
  `https://ghfast.top/https://github.com/Mercershixin/CheatMenu.git`（`ghproxy.net` / `gh-proxy.com` 同样可用）。
- ★★ **下载源顺序 = 新鲜优先，别再改回去**：raw 系
  （`ghfast.top` → `ghproxy.net` → `raw` → `gh-proxy.com` → `ghpxy.hwinzniej.top`，原生缓存约 5 分钟即刷新）排前面；
  **jsDelivr 三节点压到兜底** —— 它对分支 `@main` 是**文件级长缓存**，实测会**静默发旧版**
  （同一时刻它的 `version.txt` 已是新版、`CheatMenu.lua` 却还是几小时前的旧版），
  且 **`?t=` 时间戳对它无效** → **只能靠排序救，不能靠参数救**。
  唯一真源 = `publish.py: raw_urls()`（加载器与脚本内嵌候选都从它出）。
- ⚠ **`{{CM_URL}}` / `{{CM_VERURL}}` / `{{CM_REPO}}` 必须填 `canonical_raw()` 的 raw 规范地址** ——
  源码用 `^https://raw%.githubusercontent%.com/` **锚定**解析用户/仓库/分支；
  填代理地址进去会**匹配失败 → 自更新静默退化成单源直连**（代理一挂再无兜底）。
  **不要再把 `urls[0]` 塞给这三个占位符。**
- ⚠ **`push_now.py` 日志里的 `!! API 推送失败(退出码 1)` 几乎每次都是假失败** ——
  最终以 **API 回读逐字节比对** 为准。
- ★★ **大 body 的 PUT 会被间歇掐断（2026-09-21 实测定性，别再当成"令牌/权限坏了"）**：
  同一份 509KB 体连打四次 —— 6.7KB→`201`、66KB→`409`（=**已送达**）、266KB→**连接被掐**、
  679KB→`409`。⇒ **按 body 大小触发 + 纯概率**；小文件（`version.txt` 6B / `loader.lua` 2.5KB）
  几乎总成功，纯粹因为它们小。`push_api.py` / `push_docs.py` 已内置对策（**不需要人肉重跑**）：
  ① 传输级重试 + 退避（只重试连接被关 / `IncompleteRead` / `WinError 10054`；`HTTPError` 不重试）；
  ② 显式 `Content-Length` + `Connection: close`；
  ③ `409/422` 时**重新 GET 远端 sha**再试（被掐断那次其实可能已落盘 → 拿旧 sha 必 `422`）；
  ④ 用 **git blob sha1**（`sha1("blob <len>\0"+bytes)`，**不是裸文件 sha1**）判"内容未变"跳过，
  免得每次推文档都产生一堆空提交。**新写推送脚本时必须照抄这四条。**

---

## 6. ⌨️ 输入层约定（踩过，别改错方向）

1. **菜单键**必须能在输入框聚焦时照常工作 —— 用 `UIS:GetFocusedTextBox()` 判，**不要**用 `gp` 挡。
2. **其余功能键**必须尊重 `gameProcessedEvent` —— 写法：
   `UIS.InputBegan:Connect(function(input,gp) ... if gp then return end ... end)`。
3. ★★ **两处「故意不判 gp」不是缺陷，别当 bug 修**（源码注释里写了理由）：
   - **移动检测**：注释原话「**不理会 gp，玩家按了就是按了**」——
     因为部分执行器 `IsKeyDown` 拿不到真实按键状态，双路径（`InputBegan/InputEnded` 记账 + `IsKeyDown` 兜底）是**刻意的**。
   - **菜单拖动**：按在我们自己的标题栏上时 `gp` **正好是 `true`**，判了反而**永远拖不动** →
     所以改用「点是否落在标题栏矩形内」判定。
4. ⚠ **已知待修**：热键 **V**（切换指定目标）目前**没有**判 `gp` →
   在自家菜单文本框或游戏聊天里打 `v` 会**悄悄切走指定目标**。见 §9.2 待办 ①。

---

## 7. 🧭 能力边界（别写"做不到"的承诺，也别瞎吹）

- **服务端权威**的东西（余额 / 物品数量 / 购买 / 复活 / 藏身状态 / 怪的判定 / 踢人）客户端改不动 ——
  只能做「本地提示」或「发请求」，能不能成看服务端。
- **高亮 / 透视 / 本地画面效果**是纯客户端视觉，安全，随便做。
- **别碰反作弊蜜罐 remote**（例：DOORS 的 `DroneStickyNoteMyNameIsExploiterAndIThinkICanCheatWithThis`）、
  管理通道（`AdminPanelRunCommand` / `SendErrorLog` / `ServerLog`）、第三方权限框架（`conch_networking.*`）、
  数据复制框架的**写**通道（`Replica_*`）。
- 判据优先级永远是：**真名 > 结构 > 形状猜**。名字对不上就找用户要真名，别瞎猜。

---

## 8. 📌 当前项目状态与结构现状（**8.x 实测 · 可复核**）

> ★ 本节所有数字都是**实测值**，复核方式见 §9.1。
> ★★ **定位代码一律用「名字 / 分节标题」grep，不要把行号抄进新文档** ——
> 行号每次改源码都会漂移，抄行号正是旧版残留制造新问题的原因之一。

- 仓库 `Mercershixin/CheatMenu`（分支 `main`）· 版本以 `version.txt` 为准
- 主攻游戏随用户变（今天可能是 **MachineParty（机器派对）** 或 **DOORS（门）**）；事件库在 `事件库/`
- 详细历史看 `dist/repo/CHANGELOG.md`（很长，**搜关键词**就行）

### 8.1 模块地图（按分节标题 `[xx]` grep 定位）

> ★ **行数口径（9.9.0 重新实测, 可复现）**：某分节 banner 行 → **下一个** banner 行的前一行。
> 复现命令（一行）：
> `python -c "import io,re;L=io.open('CheatMenu-9.9.0.lua',encoding='utf-8',newline='').readlines();h=[i+1 for i in range(len(L)) if re.match(r'^-- \[[0-9A-Za-z.]+\]',L[i])];print([(L[h[k]-1].rstrip(),h[k+1]-h[k] if k+1<len(h) else len(L)-h[k]+1) for k in range(len(h))])"`
> （⚠ 行数随每次改动漂移 —— **定位代码请用分节标题 grep, 别抄行号**。）

| 分节 | 行数 | 说明 |
|---|---|---|
| `[00]` 全局状态 | 202 | `SYS` 表 + 全部开关/参数初值 |
| `[00B]` 反指纹 | 45 | 中性名表 + GENV 键别名 |
| `[01]` 服务 + 工具 | 56 | `T` / `TT` / `P` / `DS` 等 |
| `[02]` 配置持久化 | 301 | `SYS.C_` / `SYS.T_`、`SaveConfig`、`SaveRemotes` + **`SaveDump`** + **`REMOVED_FEATURES` 黑名单** |
| `[03]` 角色 / 相机 / 控制 | 147 | |
| `[04]` 远程事件 | 467 | `RemoteAlias` / `FindEvent` / `ProbeEvent` |
| `[05]` 移动模块 | 648 | 飞行 / 跳跃 / **Ctrl+数字路径点直达**（手动选服、数值锁定、自动跳服已于 9.9.0 删除） |
| `[06]` 上帝 / 全亮 / 玩家穿透 | 1634 | （`GetPingMs` / `SetLowLatency` 两个孤儿已随跳服功能于 9.9.0 删除） |
| `[07]` 帧率优化 | 290 | 含纹理 / 画质降级 |
| `[08]` 防踢 / ESP / 自由视角 | 1679 | **`SYS.Index()` 统一扫描索引器** + `SYS.Kw*` 共享判据表 |
| `[08.5]` 子弹射线 | 143 | 纯本地可视化 |
| `[09]` 基地操作 | 596 | 收脑红 / 收金币 / 低 CPS 售卖 |
| `[10]` HUD / 训练 / 重生 / 健身房 | 572 | |
| `[11]` 传送 | 134 | |
| `[11.5]` **战斗模块** | 2038 | 含 `@@BALLISTIC_BEGIN/END` 弹道段（**禁改**）+ **§A33 `__namecall` 射线改写（真·静默, v9.9.0 修准头）** |
| `[12]` **翻译模块 v120.2** | 2038 | 11 层重写；**只走本机 llama.cpp**（云端后端已删，见 §2 A）。**读代码前先看模块头的分层说明** |
| `[13]` UI 工具 | 458 | 玻璃拟态 + 霓虹渐变（**外观红线区**） |
| `[13.5]` 游戏内通知 | 41 | 自实现通知条，不依赖任何 UI 库 |
| `[12B]` ChronixHub 融合 | 1329 | 逻辑层，全部可逆，只写本客户端（滤镜/多路径点/整蛊 9.9.0 已删） |
| `[12C]` 反作弊对抗靶场 | 329 | `SYS.AC` |
| `[14]` UI 页面 | 894 | **外观红线区** |
| `[14.6]` 实验室 | 1561 | 执行器高级 API 实验区 + **综合扫描（十层）** |
| `[14.9]` 新增页面 | 114 | 只剩「玩家(动手类)」页（整蛊工具 9.9.0 连后端已删） |
| `[15]` 创建菜单 | 1018 | **外观红线区**：硬编码 `W,H=830,664`，上千控件全按**绝对偏移**画 |
| `[16.1]` 翻译忽略名单 | 356 | ★**用户维护的数据**，不是逻辑 —— **别当代码重构** |

### 8.2 结构指标（**9.9.0 实测**）

- **main chunk 的「每函数 200 个 local」名额：77 / 200**（其中 `local function` 41 个，主要来自**未隔离**的 `[11.5]`）
  - ★ Lua/Luau 的 local 上限是**每函数 200 个同时活跃的**；`do..end` 块结束时局部**会释放**。
    所以 **大模块用 `do..end` 包起来**就不吃 chunk 名额（`[12]` 翻译模块就是这么重写的）。
  - ⛔ **别再用"数行首无缩进的 `local`"来估算** —— 会严重高估（那样数出来是 202，实际 77）。
    用 `_audit_chunklocals.py`（逐 token 扫描；**自检：收尾块深度必须恰为 0**）。
    ⚠ 它跑得慢（>2 分钟），用**后台 + 长超时**；`_audit_modules.py` 里那份 A 段是它的简化版，
    块深度自检不为 0 时那 22/200 不可信 —— **以本工具的输出为准**。
- **61 个 `SYS._*` 共享态表 / 209 处引用** —— 模块私有状态被摊在全局命名空间里。
  - ★ 已逐条核对：**真 nil-crash 缺陷 0**（全部有 `and` / `or {}` / `if x then` 兜底）。
  - 但这是**结构性隐患**（历史上 `[08]` 门透视"从来没亮过"就是这类作用域坑：
    局部侧表声明在节流 `if` 块内、却在块外的创建循环里读 → `nil[p]` 抛错 → 被 `P()` 静默吞掉 → 整段失能）→ 见 §9.2 待办 ②。
- **未包 `do..end` 的裸块**：`[00B]` `[11.5]` `[12C]` `[13]` `[14]` `[14.9]` `[15]` `[16.1]`
- **配置键对账**：`SYS.C_` 声明 **63** 键 / 代码引用 **68** 键，
  「**写了 + 调了 `QueueSave()` + 没声明**」= **0 个**（7.8.3 修完 `CB_ScanMs` 后没再退化）。
  - ★ 判别「真 bug」与「设计如此」的**唯一判据**：**写值处有没有调 `QueueSave()`**。
  - 5 个界面写了但**没调** `QueueSave` 的键（`LightMode` / `TimeScale` / `WL_Sel` / `CB_Priority` / `GameNameCache`）
    是**会话内临时值，不是 bug** —— ⛔ **别去"修"它们**（不做这步区分，会把 5 个正常键一起改坏）。
  - 机制：`SYS.SaveConfig()` 是 `for k,v in pairs(SYS.C_) do` —— **只遍历声明表**；
    `SYS.LoadConfig` 回填又要求 `SYS.C_[k]~=nil` → **没进声明表的键 = 改了存不住**。
- **函数定义 623 个**（同一份审计里参与归一化 sha1 比对的 479 个）· **函数级重复：0 组** —— 无复制粘贴屎山。
- **定义了但零引用的函数：46 个**（`_audit_features2.py` 的 E 段；历代功能的半成品桩）。
  ⚠ CHANGELOG **6.9.11** 已记过一笔"这批我先没动" ⇒ **不是回归，但也没清**。
  它们**不属于**"界面已删、后端还在"那一类，删之前要逐个确认不是留给后续接线的 → **要清单独开一次**。
- **射线 API（实测出现次数，`grep -o … | wc -l`）**：
  `FindPartOnRay(` ×6 · `FindPartOnRayWithIgnoreList` ×1 · `FindPartOnRayWithWhitelist` ×2 · `WS:Raycast(` ×3。
  → 新老混用；迁移是**等价性敏感**的（返回形态 / 忽略语义 / `IgnoreWater` / `CollisionGroup` 默认值都不同），
  **必须逐站点核对，禁止批量替换**。见 §9.2 待办 ④。
  ⚠ 数这类"出现次数"**不能用 `grep -c`**（那数的是命中**行数**）。
- 未使用的引擎原生能力（可选补强）：`Camera:GetPartsObscuringTarget`（一次性遮挡判定，可替代手写射线 + 自建缓存）、
  `GetPartBoundsInRadius` / `GetPartBoundsInBox`（原生空间查询）。

### 8.3 已合并/统一的（别拆）+ 明确别动的地方

- 见 §2-D。
- **`[08]` 的 ESP 扫描架构本身是对的**（`SYS.Index()` 把 8 个消费者的全量扫描合并成一次 + 0.4s TTL，
  且注释写明了"为什么不接掉落物透视 / 自动躲避"）→ **别动**。
- **`[13]` / `[14]` / `[15]` 是外观红线区** —— 用户明确要求「**电脑端逐像素一致**」。
  包 `do..end` 本身不改外观，但**任何顺手"整理"都可能改到绝对偏移** → 只包壳、不碰布局。
- `[16.1]` 翻译忽略名单 = **数据**；`[14.6]` 实验室 = **试验田**（重写成"规范结构"等于抹掉它的用途）。

### 8.4 综合扫描（十层，一个按钮）

`UI.Pages["功能"]` 的 **🔍 综合扫描** → `SYS.Lab.FullScan()`，十层一次点完、全部打到控制台：
**A** 通信 / **B** 代码 / **C** 脚本 / **D** 实例 / **E** 数据 / **F** 连接 / **G** 环境 / **H** 反查 /
**I DEX**（全图实例浏览器：类名 TOP30 + 关键类全路径 + 属性快照）/
**J Remote**（每条通道能不能用：收向监听几条 + 谁在收 + 命中哪个功能类别 + 34 个类别通道对账）。

- ★ **I / J 共用一次 `scanWholeGame()` 全图遍历** —— 这就是"融合成一个功能"的落点，**别再拆成两个按钮**。
- ★ **十层全部进【一个】 txt**（`SYS.SaveDump` 在扫描期间只登记、不单独落盘；内容靠 `line()/head()`
  的缓冲在结尾由 `SYS.DumpScanAll` 一次写出）。`DEX_*.txt` / `Remote_*.txt` 那套**早已废弃**。
- ⛔ **落盘缓冲的别名陷阱（2026-09-21 真 bug，用户报"综合扫描失效了，就扫描几个东西"）**：
  模块级 `local DumpBuf = SYS.ScanBuf` 在**加载时**就绑定了那张表。若在 `FullScan` 里写
  `SYS.ScanBuf = {}`（**换新表**），写入落到了新表、而结尾 `SYS.DumpScanAll(DumpBuf)` 仍拿旧表
  ⇒ 落盘文件只剩文件头、`-- 共 0 行`；控制台又只显示前 60 行 ⇒ 看起来"只扫到几个东西"。
  **正确做法：`table.clear(SYS.ScanBuf)`（清空同一张表），永远不要在这里重新赋一张新表。**
  教训：**任何"持有一张表作缓冲"的地方，清空必须用 `table.clear`，不能用 `= {}`。**

#### 8.4.1 落盘口径（**用户 2026-09-21 定稿：一个文件、一个位置、一条不少**）

用户原话：**「你位置都错了 而且还少了 都说了全部扫 完完整整的放一个文件 CheatMenu 里面」**。
三条硬要求，改这块前先读：

| # | 要求 | 落点 |
|---|---|---|
| ① | **位置** | `workspace\CheatMenu\`（执行器工作目录下）——**不许再套服务器子文件夹**。首选候选就在 `SYS.ResolveScanDir()` 的 `cands[1]`，必须是 `"CheatMenu"` |
| ② | **就一个文件** | `scan_<PlaceId>.txt`（文件名带 PlaceId 天然按游戏分开，所以不需要分层目录）。**不许**再出现 `remotes_*.txt` / `server_name.txt`；`.prev.txt` 只在**内容真的不同**时才生成 |
| ③ | **完整** | 十层**全部**进那一个 txt。**每一个**输出点都必须走缓冲 —— 这是最容易漏的地方 |

- ⛔ **别再用裸 `print` 输出扫描内容。** B/C 两层和 A 层的 200+ 条 remote 清单曾经都是裸 `print`，
  结果控制台有、落盘文件里**整层缺失**（用户看到"还少了"）。
  统一出口是 **`SYS.ScanEmit(s)`**（控制台 + 落盘二合一；不在扫描里时等价于 `print`）。
  连 `SYS.DumpRemotes()`（在文件早段，3611 行附近）也走它 —— `SYS.ScanEmit` 是**调用时**解析的，
  定义在后面（Lab 段）完全没问题。
- ⛔ **`SYS.SaveRemotes` / `SYS.SaveDump` 都必须有 `if SYS.ScanOutFile then return SYS.ScanOutFile end` 闸门** ——
  综合扫描里**只登记、不另写文件**。少了这个闸门，一次扫描就会在目录里多出一个文件。
- ★ **门禁**：`_scan_out_unit.py`（`verify_all.py` 的 6.7/7）把上面这些钉死了 ——
  静态不变量（别名/裸 print/首选目录/不许写 server_name/两个闸门）
  + 运行时【原样抽出】真的 `SYS.DumpScanAll` 用真 `luau.exe` 验"只出一个文件 / 内容相同不留 prev"。
  **改扫描输出后这一步必须绿**。

---

## 9. 🛠 只读审计工具 + 待办候选

### 9.1 三个只读审计脚本（`.workbuddy/build/`，随时可重跑复核）

| 脚本 | 干什么 |
|---|---|
| `_audit_modules.py` | 模块体量 / `do..end` 隔离 / chunk local 名额 / 重复函数 / `SYS._*` 清单 |
| `_audit_chunklocals.py` | **逐 token 精确**算 chunk 层 local 名额（正确处理 `elseif...then` 与 `for...do`；**收尾深度必须为 0**） |
| `_audit_sysunderscore2.py` | `SYS._*` 的 **nil-crash 风险分级**（只挑"读取处会因 nil 抛错"的形态） |

★ **审计坑（自己的脚本也会骗人）**：
- **多重赋值** `SYS._A,SYS._B,SYS._C="x","y","z"` 的**中间项**会被"只抓行尾 `名字=`"的正则**漏掉**
  → 曾把 `SYS._FlyVel` 误报成"无赋值却被下标写"。**审计脚本的误报必须写进结论**，否则会把后来者带偏
  （⚠ 假警最大的危害不是噪音，是**引导人去改本来正确的代码**）。
- 区分「真缺陷」与「**故意不拦**」要看**多数派**：全文件同类处理里，多数拦、少数不拦 → 少数才是缺陷。
  （同型判据见 §6.3：那是"故意不判"，不是 bug。）

### 9.2 待办候选（**批次5 评估结论 · 按 收益÷风险 排序**）

| 序 | 候选 | 风险 | 要点 |
|---|---|---|---|
| ① | **输入层统一** + 修 §6.4 的「热键 V 缺 gp」 | 低 | 3 条全局 `InputBegan` → 1 条；把"是否判 gp"做成**每消费者自声明**、过滤集中在**一处** —— 这样 §6.3 那两处例外不会被误改 |
| ② | **状态层归位**：61 个 `SYS._*` → `ESP._npcList` 等模块表 | 低 | 全是**内部状态、无对外契约** → 不涉及"对外成员必须 100% 保留"的约束；从结构上消灭作用域坑 |
| ③ | **`[11.5]` 战斗模块分层** + 裸块隔离 | 中 | 7 层（数据 / 工具 / 目标 / **弹道(禁改)** / 动作 / 驱动 / 诊断）；**弹道段改必跑 `_ballistic_unit.py`** |
| ④ | **弃用 API 迁移**（`FindPartOnRay(` ×6 + `FindPartOnRayWithIgnoreList` ×1） | 中 | 逐站点等价核对，**禁批量替换** |

（完整评估报告：`补强批次5-模块重写可行性与公开仓库增强-8.0.0.html`）

---

## 10. 📎 参考

- 详细历史：`dist/repo/CHANGELOG.md`（很长，**搜关键词**就行）
- 补强批次报告：`补强批次1…5-*.html`（去公开仓库找思路的那几批）
- 事件库：`事件库/YYYY-MM-DD_游戏名.md`（同型约定见各游戏那节的「绝对不要碰」）
