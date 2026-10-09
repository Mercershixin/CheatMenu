# 战斗 与 移动（细节）

## 自瞄

- ★★★ **附属项必须先有总开关**（2026-10-01 用户报"没锁到人/没自动开火"查实）：
  `T.Aim360` / `T.AutoFire` / `T.AimFireOnly` **只作用于 `F.AimSet` 的渲染循环**，而那个循环**只有 `T.AimOn` 才建**
  ⇒ 只点这几个附属项**一点反应都没有**（用户就是这么踩的）。修法：勾任一副属项时用
  `F.EnsureAimOn()` **顺手把「自瞄」打开**（同步 UI + 打日志）。★ 这是"用户点开关触发的联动"，
  **不违反"加载不许自动开功能"的红线**。凡"总开关 + 附属项"结构的功能，都要照这个办。
- ★★ **`T.*` 布尔不落盘**（红线：读档不恢复布尔）⇒ **每次重载都得重点一遍**；所以"我明明点过"的错觉很常见
  ⇒ 诊断工具要把开关状态**逐条打出来**，别让用户猜。
- ★★★ **`VirtualUser:CaptureController()` 必须配对 `ReleaseController()`**：挂机防踢里原先只抢不还
  ⇒ 玩家一 Idled 鼠标控制权就被拿走 ⇒ **菜单点不动 / 点击到不了游戏 / 看着像"开火没反应"**。
  同类事故还会出现在自动开火的 VirtualUser 兜底里。**凡 CaptureController 一律紧跟 ReleaseController(pcall)**。
- ★★ **开火三路只留一份**：`F.FireOnce()`（`mouse1click()` → `VirtualUser` 屏幕中心 → `tool:Activate()`，
  返回实际走通的那条）。AutoFire 只留"开关 + 间隔"，KillAura 直接复用 —— 原先两处各写一遍且 KillAura 缺兜底。
- ★★★ **战斗"没反应"先跑 `F.CombatCheck()`（战斗页第一项）**：逐玩家报 ✓/✗ 与原因
  （无角色/已死/黑名单/同队/太远/圈外/被哪个部件挡住）+ 汇总最主要原因 + 开火链（含**试发一次**）；
  结果同时进日志 ⇒ 用户把日志发来就能定位。**别盲改自瞄算法** —— 本次四处问题里两处是环境问题。
- **两个开关语义相反，标题必须写全**：「开火才锁」= 按住左键才锁；「锁上就开火」= 锁定后自动开火。
  开后者时前者**自动让位**（否则互相打架）。
- **自动开火三重回退**（统一在 `F.FireOnce()` 里）：① `mouse1click()` → ② `VirtualUser` 点**屏幕中心**
  （⛔ `(0,0)` 在 3D 视野外 ⇒ 等于没点；且**用完必须 `ReleaseController()`**，否则鼠标被抢）→ ③ `tool:Activate()`。
- ★★★ **相机类功能必须用** `RS:BindToRenderStep("CM_Aim", Enum.RenderPriority.Camera.Value + 1, fn)`
  —— 默认相机脚本**每帧重算并覆盖 `cam.CFrame`**（用 RenderStepped 写 CFrame = 无效，
  这就是"自瞄没效果"的根因）；关闭时 `UnbindFromRenderStep`。
- **「目标选择」**：⛔ 只在 `LP.Team ~= nil` 时才比阵营 —— 无阵营游戏里 `TeamColor` 全白，比它**恒真** ⇒ 把人全当队友。
- **「360° 锁敌」**：关 = 只锁屏幕内（背后的人直接被丢）；开 = 按**世界距离**选最近（此时「自瞄范围」单位=格）。
- 筛选顺序：**先判便宜的**（黑名单/队友/血量）→ `WorldToScreenPoint` → **最后才射线墙检**。
- ★★★ **相机锁定类功能的头号杀手：目标离相机太近** ⇒ `CFrame.lookAt(camPos, partPos)` 方向向量≈0
  ⇒ **视角原地打转**（2026-10-05 实锤）。必须在**两处**都设最小距离：
  ① 选目标时（贴脸的模型 / 玩家副本直接不进候选表）；② 转相机前（`(part.Position - cam.CFrame.Position).Magnitude > 2.5` 才转）。
- ★★★ **把"非玩家"目标并进自瞄时，候选把关要严防四类**：自己的角色与其后代 · `CurrentCamera` 的后代 ·
  **与任意玩家同名的模型（游戏给玩家做的副本/Holder）** · 没有头也没有 PrimaryPart 的模型。
  判据见 `F.CombatNpcOk`。**还要数量封顶**（按与本地角色距离取最近 N 个，现为 12）——
  否则每帧上百次射线会拖垮帧率，表现同样是"视角发飘/乱转"。
- ★ **「瞄准点」要传候选表**（`{"Head"}` / `{"UpperTorso","Torso"}`），别传单个名字：R6 角色没有 UpperTorso。
  并在战斗 HUD 上显示**实际锁定的部位名**，用户一眼就能验证"锁的是头还是身体"。
- ★ `F.CombatVisible` 必须**恒返回 BasePart**：早期版本在"关墙检"时返回 `Vector3`，下游 `part.Position` 直接爆。
- ★ 自瞄的**目标来源**：`F.CombatAliveBody(ch)` 吃 **Model**（不是 Player）⇒ 玩家角色与 NPC 走同一条判定，
  候选表 = `Players:GetPlayers()` 的角色 + `F.CombatNpcRefresh()` 缓存的 NPC（1.5 秒刷新）。

- ★★★ **甩飞（fling）的正确做法（2026-10-05 调研公开项目后的结论）**：
  **不是去改别人的角色**（那要先拿到对方的网络所有权，多数游戏锁死 ⇒ 无效），
  而是**把自己的角色变成高速旋转体撞过去** —— **自己角色的所有权一定在自己手里**，
  物理状态由服务端复制给所有人，碰撞即可把别人甩飞（Grokipedia 的 fling 机制说明 + devforum 最佳答案一致）。
  公开脚本的两个关键细节：① `HRP:PivotTo(HRP:GetPivot() + Vector3.yAxis)` **先抬离地面**，否则"粘在地上"怎么给速度都没反应；
  ② 同时设 `AssemblyLinearVelocity`（数百~数千）与 `AssemblyAngularVelocity`（数千~百万，自转才是甩飞的主动力）。
  BaseAdmin 版：`Humanoid.Sit = true` + `HRP:SetNetworkOwner()` + `AssemblyLinearVelocity += Vector3.new(200,200,0)` + 1 秒后 `SetNetworkOwnershipAuto`。
  ⇒ 本仓实现为**自动择优**：抢到所有权 → 直接推飞；抢不到 → 旋转撞击。**必须如实告知用户走的是哪条、以及本服限制。**

## 加速

- **只让水平更快**：地面交给 `WalkSpeed`；空中按"相机相对输入方向"补水平速度，
  **必须保留角色自身的 Y**（`Vector3.new(v.X, cur.Y, v.Z)`）—— 覆盖整个向量会把重力一起改掉 ⇒ 人会"停住/滑翔/爬升"。
- **松手即停**：无输入时把**水平**速度清零（保留 Y）。旧版"只在有输入时才写" ⇒ 松手后保持上一帧速度继续飘（就是那个惯性）。
- 方向**一律投影到水平面**（`Vector3.new(v.X, 0, v.Z)`，含 `MoveDirection`）—— `LookVector` 带 Y，
  直接加会让人往上/下走。**加速没有任何垂直能力**。
- **「加速」绝不许碰用户速度**（2026-10-01 用户报障「加载后我原本高速变低速 ⇒ 不要改我的速度」，10.10.9 修）：
  ① ★★★ **只有用户自己把加速打开时才允许写 `WalkSpeed`**；关功能 / 卸载 / 热加载 / F1 Panic **一律不许写**；
  ② ★★★ 关闭时**只还原"打开加速那一瞬间的值"**（`F._preSpeed`，开时抓取）—— **没记录就一个字节都不写**；
  ③ ★★★ **禁止硬编码基准**：`F._baseWalk = 16` 这种默认值会把用户的高速度按回人类默认，而且会**让
  `RecordOriginals()` 里"用真原值填基准"那句永远不执行**（条件永远为假）—— 默认值必须留给"压根没记录到"的情况；
  ④ ★★ **不许对"能被当作基准的速度"设隐性上限**（`if bw <= 32 then 才记录` = "我本来很快但脚本不认"）；
  ⑤ ★★ **清理表里写 `pcall(F.SpeedSet)` 是坑**：不带参数 = `SpeedSet(nil)` = 关功能 ⇒ 会走到"回写基准"分支 ——
  清理项要为"只还原"单独提供函数（`F.SpeedRestore`）。
- **参照：** `WalkSpeed` 直写是 928 个公开脚本里 **71 个**的做法；飞行用 `PlatformStand` + `BodyVelocity`（76 个）。
  ★ **学公认做法只学结构（一个开关 + 一个值），能力不能一起降级。**
- **控件收敛（2026-10-01 用户点名"又 6 个按钮"）⇒ 加速只剩 3 个**：`SpeedOn` / `SpeedValue` /
  **`SpeedExtra` 下拉（7 选项，选完自动复位）**；`SpeedRamp` / `SpeedAttrCap` / `CarryGuard` / `CarrySpeed`
  四个标志改由 `F.SpeedExtraApply` 一次性设置。**合并必须 grep 验证底层标志仍有人写**。
- ★★★ **"搬运"判定必须窄**：这游戏**长期手里拿着球棒(Tool)** ⇒ 只要"有 Tool 就算搬运"会**每次都命中**
  ⇒ 加速被反复压下去（实测日志 0.8~3.1 秒一轮、连 5 轮）。正确判据：**挂着 `Model` 全算；
  Tool 只认"像搬运物"的名字**（`F.CARRY_KEYS`：egg/brainrot/cash/carry/crate/loot/pet/item/drop/box/bag），
  并且**日志要报出"检测到的是什么"**（不然没法调关键词）。
- ★★ **日志别打"中间量"**：搬运保护那条原先打 `sp`（**正在缓升中的值**）⇒ 用户看到"压到 1094 格/秒"，
  真上限（CarrySpeed）根本没显示 ⇒ **要打就打最终生效的那个值**。

- ★★ **防护四项合成一个下拉**（2026-10-01，用户要求"放在一个里面"）：`GuardMode` 5 档预设
  （关 / 稳身 / 稳身+受击 / 推荐[+陷阱拦截+防拉回] / 全部[+锁满血+陷阱弹开]），
  由 `F.GuardSet(steady,hit,lock,trap,dodge,atp)` 一次设好 6 个底层标志并调用对应 Enable/Disable
  —— **合并不许丢能力**：6 个标志全部仍可达。★ 注意"加速防拉回"档会销毁游戏的客户端检测脚本，
  **关掉后要重进游戏才完全恢复**（已在日志里写明）。

## 受击保护（2026-10-01 定稿，参考同款游戏的公开作品）

- ★★★ **别断 `RE/RigSync/Refresh`**（2026-10-01 实测事故）：它**不只是击退通道，还是角色状态/rig 同步通道**
  —— 断了之后游戏没法把"搬运中 → 已存放"切回来 ⇒ **卡在"拿起逃跑"状态**。
  ★ 公开的 `stealaeggnoknockback.lua` **就是无脑断它** ⇒ **照抄公开作品 ≠ 照抄它的代价**（他们不在乎状态卡住）。
  ⇒ 我们的**受击保护默认走"状态法"**（禁 Ragdoll/FallingDown/Physics + `RunningNoPhysics` + 修 `Motor6D`，**不碰远程**）；
  "断连接"降级为「全部」档的**猛档**，并在档位名/日志里写明代价。
- ★★ **连接用 `Disable()/Enable()`，绝不用公开作品那种硬 `Disconnect()`**：硬断接不回来；
  `Disable` 可以在关闭/热加载时 `Enable` 还原 —— 这次就是靠它一键恢复的。

- ★★★ **"被打飞"是分工的**：服务端判定命中 ⇒ 通知客户端 ⇒ **你自己的客户端**执行击退/rig 同步。
  ⇒ 客户端能拦的只有"自己这边的执行"；**完全免疫/不掉血做不到**。断了处理连接后**血照样掉，但不会被击飞**。
- ★★★ **做法**：`for _,c in ipairs(getconnections(re.OnClientEvent)) do c:Disable() end`
  （★ 用 **Disable 不用 Disconnect** ⇒ 可以 `Enable()` 还原，守"关闭必须还原"的规矩）；
  关键词 `rigsync/knockback/knock/ragdoll/combatservice/useitem/stun/tumble/pushed/fling/blown/launch`
  —— 同款游戏里那条叫 `Packages.Networking["RE/RigSync/Refresh"]`。
- ★★ 配套：禁 `Ragdoll/FallingDown/Physics` 状态 + 倒地就 `ChangeState(RunningNoPhysics)`
  + **`Motor6D.Enabled = true`**（ragdoll 会把关节弄断）+ 关掉多余 `Constraint`；可选 `Health = MaxHealth`。
- ⛔ **不要禁 `Dead` 状态**（公开作品禁了）：会把角色卡在半死状态。

- ★★ **动画加速的公开做法**（2026-10-01 查证）：公开脚本几乎**没人做**动画加速（`AdjustSpeed` 全 0）；
  唯一专门的是 `Fractware/TimeScaleFramework`（★2，`src/AnimationTracker.client.lua`）：
  `Animator:GetPlayingAnimationTracks() → track:AdjustSpeed(1/TimeScale)` + 挂 `Animator.AnimationPlayed`
  （新动画一播就套速）+ `track.DidLoop`（循环后再套）—— 因为动画重播会**重置速度**。
  我们的实现 = 每 0.3s 轮询套速（`AdjustSpeed(sp/16, 1..8)`），等价但更简单；若日后要"宠物/生物动画"也快进，
  用它的"白名单 tag + AnimationPlayed"那套按 Animator 扩。⚠ 这只覆盖**角色动画**；过场/Tween 另说。
- ★ `p6`(PHUCMAX) 用 `GetPlayingAnimationTracks()` 的 **AnimationId/名字**识别"跑步机动画"（id `10921259953`/名含 treadmill）
  ⇒ 判断"在跑步机上"的一种办法（我们用的是名字+平台速度三重判定）。

## 飞行

- `PlatformStand = true` + 约束（**有 `AlignPosition` 就用，否则回退 `BodyVelocity`/`BodyGyro`**，**自动挑、不给选项**）。
  WASD 移动 + 空格升 / Ctrl 降；**松手即停**（无输入显式清零速度）；关闭时销毁约束 + `PlatformStand = false`。

## 位移类功能的通用事实

- ★★★ **"每 N 秒自动操作一次"的兜底必须先问它会不会被玩法当成违规动作**（2026-10-01 实测）：
  挂机防踢里那条 `if 速度<1 then hum.Jump = true end` **每 5 秒跳一次** ⇒ **在跑步机上必被甩下来**
  （因为"被平台带着走"时你自己的速度恰好≈0，条件恒真）。修法：加**真挂机判据**
  （`MoveDirection.Magnitude > 0.05` 就清零计时并返回；连续 90 秒无输入且速度≈0 才跳）。
- ★★★ **"反甩"绝不许动角色的碰撞属性**（2026-10-01 用户报"开防护后跑步机/锻炼/加速道具全废"）：
  旧实现把角色每个部件设 `CanCollide/CanTouch/CanQuery = false` ⇒ **踩不上跑步机**（穿模）、
  **所有 `Touched` 交互/道具失效**、射线查不到你。★ 而那个开关的标题还写着"不影响交互" —— **标题与实现相反**。
  正解：**只清异常速度**（`AssemblyLinearVelocity` 超阈值就清水平 + 清角速度），
  阈值写成 `max(8000, 用户速度×2.5, 飞行速度×2.5)` ⇒ **永不低于用户自己设的速度**（不给隐性上限）。
  ⛔ 而且这种"改属性"的损坏**会留在部件上**：备份表随重载一起没了 ⇒ 必须提供 **`F.FixCharCollision()`**
  （恢复角色部件的 碰撞/触碰/可查询 = true，排除 `Accoutrement` 内部），在**载入 + 换角色 + 开防护**三处都跑。
- 先查 `workspace.AuthorityMode`：为 `Server` 时位移由服务端权威裁决 ⇒ 客户端实现**命中率会明显下降**，
  要**诚实告知**而不是装有效。
- **用户可调量的上限只能来自滑块**，脚本不许偷偷夹一层（`math.min(target,300)` 被用户抓过）。
- **飞行期间必须暂停无限跳**：`PlatformStand=true` 时无限跳的连接仍**每帧写 `hum.Jump=true`**，
  与飞行约束互相打架（表现为上升一顿一顿 / 位移被顶掉）。`F.FlySet` 开启时暂停并记 `F._flyJumpConn`，
  `F.FlyDestroy` 里**按 `T.InfiniteJump` 当前值**决定是否恢复 —— 用户飞行期间自己关了它，落地就不该被重开。
- ★★★ **瞬间交互（偷蛋/开箱/机关）的正确做法**（2026-10-01 调研 `ltseverydayyou/uuuuuuu:functionFixer.lua`）：
  快照 `Enabled/HoldDuration/RequiresLineOfSight/MaxActivationDistance/Exclusivity` → 改 `HoldDuration=0`、
  `RequiresLineOfSight=false`（进阶：`MaxActivationDistance=1e9`、`Exclusivity=AlwaysShow`）→ 用完**逐个还原**。
  触发靠 `pp:InputHoldBegin()`+`RenderStepped:Wait()`+`pp:InputHoldEnd()`；**远处 prompt 客户端不展示**，
  公开实现用"相机前假 prompt 转发 Triggered"(proxy) 解决 —— 风险高，我们没上。
  ★ 诚实边界：**距离由服务端裁决**（服务端那份 prompt 我们改不到）。
- ★★ **穿墙根因 = 物理步 240Hz × 高速度**（5000 ⇒ 每物理步 20.8 格 ≫ 墙厚 1 格，无 CCD）。
  修法：每帧 `want = speed*dt` 用射线量 `allow`，`scale = allow/want` 压本帧速度（**开阔地不限速**）。
  ⛔ 别用"每帧 PivotTo 分步"补速度：会和服务端复制打架，且 5000 格/秒 = 500 格/0.1s ≫
  哨兵 `MaxTeleportDistance=45`，等于自找拉回。
- ★★ **飞行速度失真**：`AlignPosition` 靠 `Responsiveness` 弹簧追赶 ⇒ 有滞后，5000 达不到。
  修法：`ap.RigidityEnabled = true`（刚性，直接定位）。
- ★★ **滑块上限 ≠ 真实速度**：原先 `Max=5000` 而标题写"上不封顶"（假）。11.0.24 起上限 = 20000 且标题诚实。
  新增 `F.SpeedProbe` 探针：日志 `[速度自检·加速/飞行] 设定 X → 实测 Y (Z%)`，达标/中间/偏低三档结论。
- ★ **T 键传送到鼠标：距离不设人为上限**（2026-10-01 用户要求"能无限 不要有限"）：
  射线 `F.TP_MOUSE_REACH = 1e6`（打多远传多远）；射线上没实体（指天/流式未生成）→ 沿视线送 `F.TP_MOUSE_AIR=4000`，
  **不能真送"无限"**（指天没有落点，送出去就是掉虚空）。日志报"实际距离 + 到位"，≥500 格提示"服务端可能判传送拉回"。

## 自瞄"打开就自动关闭"的真凶（2026-10-04 修，14.0.8）

- **不是**自瞄自己的问题：手机浮钮「菜单/长按急停」(`CMTouchToggle`，仅 TouchEnabled) 长按 1.9 秒会调 `F.PanicKeyDisableAll()`
  ⇒ 它把**所有** `T[k]` 布尔清零 + `opt:Set(false)` ⇒ 自瞄/自动开火全被关掉，看着就像"自瞄自己关了"。
  ★ 修法：长按回调里**再确认"此刻指针/手指确实还按着"**(`UIS:GetTouchesPressed()` / `IsMouseButtonPressed`)，短按绝不误触发；
  并在 `PanicKeyDisableAll` 里打日志列出"本次关掉了哪些功能" ⇒ 用户发日志就能一眼判定。
- 自瞄自身也做了三条加固：`pcall` 包住每帧逻辑（不再一错到底）+ **心跳看门狗**（心跳停了自动 `BindToRenderStep` 重绑，
  失败退 `RenderStepped`）+ `F.EnsureAimOn()`（勾「自动开火/转视角」顺手开总开关，防止"只点附属项没反应"）。

## 血量类要分「本地看起来」与「真的」（2026-10-04 · 14.0.13）

- ★★★ **能做的只有两件事**：① **读取伪装**（`__index` 拦 `humanoid.Health/MaxHealth` 返回满血）② **断开游戏自己的血量监听**（`HealthChanged` / `GetPropertyChangedSignal("Health"/"MaxHealth")`）。
  两者合起来 = **「本地看起来不掉血」**；⛔ **不等于真不死** —— 血量是服务端权威，服务端照样判你死并重生。**要如实告知**，别装有效（判据 `workspace.AuthorityMode=Server`）。
- ⛔ **不禁 `Died`**（禁了会卡半死状态，记忆里已有此坑）；只禁 `HealthChanged` 系列。
- ★★★ **`__index` wrapper 里绝不能读同一个 key**（如 `hum.MaxHealth`）—— 外部调用链里再读会**再进 wrapper** ⇒ 无限递归 ⇒ 爆栈闪退。⇒ 一律**只读缓存变量**（在我们的线程里刷新，`checkcaller()=true` 天然安全）。
- 断连接要**自己记录、逐条还原**；⛔ 别复用 `AC.ReenableDisabledConns`（全局的，会放开别的功能禁的连接）。

## ★★★ v16.9.25 战斗页整理：**界面 Default 必须等于后端实际默认**（2026-10-06）

> 根因：**「配置存档」在 v16.9.19 删除后，界面 Default 不再回填到 `C.`/`T.`**
> ⇒ 控件回调只在"用户动手"时执行 ⇒ 凡"界面 Default ≠ 后端兜底"的控件全都开始骗人。

### 抓到并修掉的（战斗页 3 + 视觉页 4）
| 控件 | 界面 | 实际（原） | 修法 |
|---|---|---|---|
| **锁定方式** | 转身锁人（不碰视角） | **转视角**（方向相反） | 加载期 `T.AimTurnCamera, T.AimTurnBody = false, true` |
| 锁定距离 | 200 | `or 300` | 兜底改 200 |
| 正面圈大小 | 400 | 判定 `or 300`、FOV 圈 `or 200`（**后端自己还不一致**） | 四处统一 400 |
| ESP 名字/距离/血条 | 开 | `if T.X` ⇒ nil=关 | 加载期初始化 `true` |
| 敌我识别 | 关（统一蓝） | `~= false` ⇒ nil=开（绿/红） | 加载期初始化 `false` |

★ 新增工具 `_audit_defaults.py`：**逐控件核对界面 Default vs 后端实际**（识别加载期顶层初始化；
用块配平判"是否在函数体内" —— 本仓回调体**不缩进**，靠缩进判断必误判）。改前文件可复现 6 处不一致。
判据写死：`T.X ~= false`/`== false` → 默认 true；`if T.X`/`== true` → 默认 false。

### 战斗页优化（行为等价，非新功能）
1. **候选早退**：`F.CombatPick` 里先比 `score` 再打射线（赢不了的候选不射线）⇒ 满员时每帧射线数大幅降。
2. **战斗 HUD 节流 10Hz + 文本未变不写**（原每帧写 `TextLabel.Text`，144Hz 下 144 次/秒）。
3. **自瞄平滑帧率无关**：`a = 1 - (1-base)^(dt*60)` ⇒ **60fps 下与原来逐帧等价**，高刷不再更快。
   （公开样本 12 份全是裸 `Lerp` 不乘 dt ⇒ 帧率相关；我们比它们正确。）

### 公开 aimbot 对比结论（本仓 `_mined_files` 12 份样本，逐份读过）
- 循环：11/12 家用 `RenderStepped`（会被相机脚本覆盖）；**我们用 `BindToRenderStep(Camera+1)` 正确**。
- **没有一家做墙检过滤 / NPC 并入候选 / 近目标最小距离保护** ⇒ 我们选人质量与相机安全性明显更强。
- 开火：公开脚本一般挑 1 条通道；**我们一次走 5 条**（VIM→tool→VirtualUser→屏幕按钮→mouse1click），
  每秒最多 ~41 次动作 ⇒ **待用户定夺是否收敛**（收敛会牺牲执行器兼容兜底）。

### 仍待用户定夺
① 开火通道是否收敛 ② 「开火间隔 ±20% 抖动」是否加回（用户以前认可过方向，当前是恒定间隔）
③ 「被踢/掉线自动回同服」的掉线兜底（只监听 `PlayerRemoving`，掉线时常常不触发）。

## ★★★ NPC/生物识别：**靠结构，不靠名字**；且不能只看空间查询（2026-10-08 v16.10.96）

- **只靠名字必漏**：恐怖/剧情类游戏的实体叫 `Rush/Ambush/Seek/Screech/Figure/Halt/Eyes/Dupe/Creak/Monument`，
  一个通用词都不含 —— 但它们**有 `Humanoid`**。⇒ 识别顺序：直接 `Humanoid` → 直接 `AnimationController`
  → **直接子 Model 里的 Humanoid/AnimationController（≤24 个）** → `deep` 时递归兜底 → 最后才名字表。
- ⛔ 名字表**别加短词**：`rat` 撞 `Generate`、`mage` 撞 `damage`、`pawn` 撞 `spawn`、`guard` 撞 `guardrail`
  ⇒ 会把场景模型误判成 NPC。（本项目已剔除这些。）
- ⛔ **`GetPartBoundsInRadius` 会跳过 `CanQuery = false` 的部件** ⇒ 隐形/装饰实体扫不到。
  ⇒ 凡是"按距离找目标"的功能，都要配一条**独立的补扫**（本项目 `F.NpcSweep`：workspace 广度优先，
  只下钻 Model/Folder，层深 ≤3，节点上限 1500）。
- 补扫的**已知边界**：超过 3 层的深度扫不到（实测过 5 层不行）⇒ 只靠半径路径覆盖。改动这里要同步改注释与测试。
- 缓存：同一模型会被一个模型里几十个部件反复问到 ⇒ 加 per-scan 缓存；**只缓存 `true`，浅查的 `false` 不缓存**
  （否则浅查先否掉，后面的深查永远拿不到真值）。
- 体积上限要**按类别豁免**：带 `Humanoid` 的模型不可能是整块地图 ⇒ `kind == "npc"` 时跳过"超大对象"过滤，
  否则大 Boss/大生物会被误杀。

## ★★★ "真锁血/真无敌"的真相：客户端改血量挡不住服务端裁决（2026-10-08，比对 Abysall 后定论）
（参考源：用户提供的 `Abysall Continued` 8256 行 DOORS 专用脚本 = `C:/Users/Administrator/Desktop/1.txt`）

**它没有把血量改成天文数字**。它的"不怕服务器"= 四招，全部**在服务端判定之前/之后**做手脚：
1. **不让服务器打中**：`hookmetamethod(game,"__namecall",...)` 改写**出站**参数 ——
   `MotorReplication.FireServer` 的坐标参数直接改成 `-650`（位置上报造假，实体 AI 打不到你）；
   `Crouch.FireServer` 强制 `Args[1]=true, Args[2]=true`。
2. **拦掉失败/受伤上报**：`ClutchHeartbeat` / `HideMonster` 的 `FireServer` 直接 `return`（≈我方的「拦受伤上报」）。
3. **死了就用游戏自己的复活通道复活**：`LocalPlayer:GetAttributeChangedSignal("Alive")` → 循环 `Revive:FireServer()`（它叫 Infinite Revives）。
4. **游戏专用绕过 + 关掉画面特效**（十几个 Bypass* / `DisableHideVignette` / `DisableJumpscare*`）。
⇒ **判据：凡是我方"锁血/无敌"的实现，都要先问"这是客户端裁决还是服务端裁决"。**
服务端裁决时，唯一可行的是 **避免被命中** 或 **用游戏自己的复活通道**；硬补血只是把尸体补满。

**我方落地**：`F.GodTopUp(hum, allowZero)`（`Health=0` 也能救回）+ `F.HpFixNote` 统计补血频率，
≥12 次/6 秒 ⇒ 日志明确写出"本游戏是服务端裁决"（让用户不必猜）。
⛔ 另：`GodTopUp` 原来在 `Health <= 0` 时直接 return ⇒ **游戏把血量置 0 就等于锁血失效**（已修）。

## ⛔ 不许「搬动角色身上的部件」当无敌（2026-10-09 v17.0.42 删除）
曾有一层**判定盒搬移**：在角色里找名字含 `collision/hitbox/hurtbox/detectbox/trapbox` 的 BasePart，
**每帧**把它们设到 `root.Position + Vector3.new(0,200,0)`。实测症状 = **一开上帝模式玩家就被 tp 走**。
机理：这类判定盒在多数游戏里**焊在角色骨架/root 上** ⇒ 搬它 = 整个装配体被拽上去；
下一帧 root 已经在上方 ⇒ 再 +200 ⇒ **正反馈，每帧 200 格上飞**（掉落后就"出现在地图另一头"）。
⇒ 本仓定论：**无敌只写 Health（`F.GodTopUp`），绝不动角色的任何部件、任何位置。**
⇒ 通用判据：要搬动/改写某个 BasePart 之前，先问"它和角色是不是同一个物理装配体（`AssemblyRootPart`）"，
  是 ⇒ 搬它等于搬玩家，一律不许。**"没加装配体门禁就每帧写 CFrame"= 定时炸弹。**
⇒ 已彻底删除（`GodBoxLiftSet`/`GOD_BOX_KEYS`/`_godBoxes`/`_godBoxConn`），并在 `_gen_god_sim.py`
  加了**源码级断言**（残留即 FAIL；旧源码跑它必须失败 = A/B 反向验证）。

## ★ "锚点 / 基准"类状态：先判定，再更新（2026-10-09 v17.0.43）
第二处"会把玩家 tp 走"的原因：「防护·反回拉」`F.NoPullEnable`（**独立功能，不在上帝模式路径上**）。
它原来把锚点 `F._npPos = p` 写在"这一帧是不是异常跳变"的判定**之前**，而拉回带 0.05 秒节流 ⇒
节流窗口内再次跳变时锚点不回滚 ⇒ **锚点被污染成那个异常位置** ⇒ 玩家最终停在"被挪走的地方"
（= 用户口中的"tp 到地图另一头"）；而日志还在写"已拉回原位" —— **假报成功**。
历史日志铁证它会动手：`[防护·反回拉] 位置被外部挪动 1400 格(正常一帧最多 71) ⇒ 已拉回原位`。
⇒ 已修：异常帧**不写锚点**（保持原锚点持续拉回）；日志区分「已拉回原位」/「待拉回(节流中, 锚点保持不变)」。
回归 `_gen_nopull_sim.py`（14 用例，含 A/B：旧源码必须在 T4"锚点被污染"上失败）。
⇒ 通用规矩：① **基准/锚点只在确认是"正常样本"时才更新**，异常样本绝不写进基准；
  ② **只有真的执行了动作才写"已完成"**，被节流/失败要如实写"待处理"。

## ★★★ 高亮透视：只认「交互证据 + 生物」，地图建筑一律不标（2026-10-09 v16.10.98）

用户为"地图被染色"提过**三次**。真正的三条结构原因（不是"关键词表不够短"）：

1. ⛔ **绝不对 Model 做整模型递归**：`FindFirstChildWhichIsA("ProximityPrompt", true)` 会扫整棵子树
   ⇒ 一栋楼里有一个门有提示 ⇒ **整栋楼被高亮**。正确判据只有两条：自己就是提示 / **直接子**是提示；
   Model 还要 `≤12 个子` 且先过"结构门禁"。
2. ⛔ **祖先上溯必须限深**（现在 `IX_HOPS = 2`），且上溯到的 Model 要过同一套门禁
   （`IX_MAXSZ` 只挡"超大"，30~60 格的房间照样会漏 ⇒ 必须再加"子节点数 > 40"这一维）。
3. ⛔ **名字匹配必须带边界**：裸子串会把 `DoorFrame/Doorway/Gateway/Keyboard/DamageZone` 全部命中。
   采用 **`F.KeyHit` 只判"后边界"**：关键词后面紧跟字母即不算（前缀＝物件的一部分）；
   复合名（`BigDoor_1/WoodenGate/Room_Door`）仍命中（尾巴＝物件本身）。
   ★ 加边界后**必须回扫常用复合名**补成整词：`killbrick/hurtbrick/damagebrick/spikeball/lasergrid`、
   `keycard/cashbag/coinbag`、`vendingmachine/shopkeeper/questgiver`（本轮 `Killbrick` 就被误杀过一次）。
4. ✅ **布景/建筑词门禁 `F.HLBlocked(low)`**：名字含
   `room/wall/floor/ceiling/roof/frame/doorway/hallway/corridor/house/building/block/platform/
   stairway/ramp/beam/pillar/column/carpet/rug/curtain/painting/portrait/poster/banner/fence/railing/
   window/tile/vent/duct/terrain/decor/background/structure/facade/gatehouse/level/map/chunk/module/part_`
   ⇒ **不做名字猜测**（NPC 与"真提示"两条路不受影响，照常高亮）。
5. ✅ **`DescendantAdded` 与 `IxFullSweep` 必须用同一套兜底**：提示挂在大模型上时用
   `F.IxTgtPart` 退回模型内第一个 BasePart；退化仍不合格就放弃（**绝不染色大模型**）。
   ⚠ 漏掉这两处 = 地图流式加载时仍会持续冒出染色。
6. 计数与日志：`F.IX_STRUCT_N`（每轮扫描重置）打进日志 `跳过地图建筑/布景 N 个` —— 用户可直接自证。

**测试脚手架坑**：切片起止**用标记串不要用行号**（插入代码后老行号全错位）；
切片漏掉被调函数 ⇒ `pcall` **静默吞掉** ⇒ 表现为"扫到 0 个且无报错"
⇒ **扫描返回 0 时先怀疑"某个被调函数是 nil"**；测 `IxScan` 前必须 `T.IxHL = true`（`IxAdd` 会提前 return）。
