# 平台 与 界面（细节）

## 手机 / 平板

- ⛔ **触屏没有键盘 ⇒ 呼出键（G）按不了 ⇒ 菜单打不开** ⇒ 必须自带**常驻可拖小按钮**，
  点击时**三级回退**开关：`Window:Toggle()` → `Window.Enabled` 取反 → `Fluent.GUI.Enabled` 取反（宿主 `gethui()`→`CoreGui`）。
- ⛔ **窗口尺寸不能写死**：`UDim2.fromOffset(500,540)` 在手机竖屏（视口常仅 ~390 宽）上**比屏幕还大** ⇒
  看起来就是"打不开"。⇒ 触屏按视口折算（宽 `clamp(vw*0.96,240,520)`、高 `clamp(vh*0.86,240,600)`、`TabWidth` 100→66）。
- ★ **触屏上 `IsMouseButtonPressed(MouseButton1)` 恒为 false** ⇒ 「开火才锁」在手机端永久失效；
  要用 `TouchStarted/TouchEnded` 自记按住状态（`F._touchDown`）。
- ★ **触屏拖动用 `InputObject` 的同一性跟踪**（`i == dragInput`）—— 只按 `UserInputType` 判断的话，
  第二根手指一动按钮就跳。
- ★ **执行器容错**：`loadstring or load`；`gethui` 可能不存在 ⇒ pcall + 退 `CoreGui`；`writefile` 可能缺失（只影响存档）。
- 加载时打一行**环境自检**（执行器/平台/loadstring/writefile/gethui/触屏）⇒ 用户一眼看出缺哪个 API（缺了就自动降级）。
- ★★★ **"整脚本 `return`"的失败路径必须让用户看得见**：手机看不到 F9 ⇒ 等于静默失败。
  凡有提前 `return` 的分支都要配**可见通知**：`warn` + `StarterGui:SetCore("SendNotification")`。
- ★★★ **远端依赖（UI 库）要有"本地文件优先"兜底**：`CheatMenu_Fluent.lua` / `Fluent.lua` / `fluent.lua`
  （`readfile`+`isfile`）先试 ⇒ 直接绕开国内网络；镜像 9 个（含 gh-proxy.com / ghpxy / fastly / gcore）；
  并且**拒 HTML 错误页**（`<!doctype` / `<html` / 正文无 `return` 一律跳过）。
- ★★ **同类兜底要全局一致**：`loadstring or load` 在 HotReload 有、**Fluent 路径却漏了**
  ⇒ 同一类写法**改一处要 grep 全项目其他处**（本轮就是靠这条抓到 Fluent 那条致命路径）。
- ★ **窗口尺寸一律"视口驱动"**，不要只在 `TouchEnabled` 为真时才折算：
  `clamp(vw*0.96, 240, _touch and 520 or 500)`（平板误判为键鼠时也不会超出屏幕）。
- ★ **加载弹窗必须写"钩子能力"**（`hook三件套`/`getgc`）：手机看不到 F9，缺了就只在弹窗里说清
  "只有依赖它们的子功能无效，其余照常"。
- ★ **`F.EnvSelfCheck()`**（「系统」页「★ 环境自检」）：13 项能力逐条判 + **每项缺了影响什么** +
  平台/视口/菜单是否已创建/界面宿主 + 一句结论（F9 与弹窗双写）。手机"没效果"先点它。
- ★★ **触屏类功能必须能被触屏驱动**（2026-10-01 实测"手机飞行不可用"的根因）：
  飞行原先**方向只看 `IsKeyDown(WASD)`**、**升降只看 `Space/Ctrl`** ⇒ 触屏一个都触发不了。
  正确做法：① 方向改读 **`Humanoid.MoveDirection`**（摇杆）投影到相机水平面
  （`fwd = md:Dot(hLook)` / `side = md:Dot(hRight)`）；② 上升用 **`UIS.JumpRequest`** 记时间戳，
  在 0.15s 窗口内当"上升"（**项目内置无限跳本来就用这个事件**，风格一致）；
  ③ 键盘那套用 `if UIS.KeyboardEnabled then ... end` 包起来，别在触屏上白跑。
  ⚠ 判断依据是"**输入源**"（`KeyboardEnabled`/`TouchEnabled`），不是 `_touch` 这个"是否按手机 UI 布局"的开关。
- ★★ **触屏没有 F1 ⇒ 必须有触屏版急停**：常驻小按钮**长按 2 秒**触发 `F.PanicKeyDisableAll`
  （拖动超过 10 像素就算"移动过"、取消长按，避免拖按钮时误触发）。按钮文案改成两行"菜单/长按急停"。

## ★★ 上游依赖与"成熟项目"调研（2026-10-01 用 GitHub API 实测，**别信搜索页的更新时间**）

| 项目 | ★ | 最后推送 | 结论 |
|---|---|---|---|
| **`dawid-scripts/Fluent`（我们在用）** | 122 | **2024-05-09** | ⚠ **已停更 2 年 5 个月**（能用，但不再修 bug） |
| `ActualMasterOogway/Fluent-Renewed` | 39 | 2025-04-21 | 也停更 ⇒ **不是好替代** |
| `Obsidian` 151 / `WindUI` 368 / `Starlight` 82 / `Myriad` 49 | | 2026-08~09 | 都活跃 |

- ⇒ **不急着换 UI 库**：换库 = **重写整个 UI 层**（~70 控件/20 小节），属**独立大工程**，不该夹在修 bug 里做。
- ★★ **上游变动风险已兜底**：**本地文件优先**（`CheatMenu_Fluent.lua`/`Fluent.lua`/`fluent.lua`）
  ⇒ 就算上游删库/被改，用户放一份本地文件即可。
- ★★ **可采纳项（待拍板）**：**执行器能力标准 sUNC / Myriad** ⇒ 我们的 `F.EnvSelfCheck` 应对标它的清单。

- ★★ **"按服务器/局"隔离的存档**：需要"换服/退出就清"的数据（收藏点位等），记
  `PlaceId .. "/" .. JobId`，加载时与上次不同就清 —— **同局热加载(同 JobId)不清**，保住刚存的东西。
- ★★ **给 Fluent 按钮挂右键/长按**：底层实例要**逐级探测**（`b.Button` → `Frame:FindFirstChildWhichIsA("TextButton")`
  → `Container:…`，全部 pcall）—— 发布包字段名不可靠；`InputBegan` 判 `MouseButton2`(右键) + `Touch` 计时(长按)。

## UI 设计口径（用户是小白）

- ★★★ **不让用户为了"用起来"而输入任何东西**：需要的参数（阈值/关键词/目标）由脚本**自动推出来**；
  输入框只作**可选项**。**一个按钮能做完的，就别摆两个控件。**
- ★★ 输出先给**结论 + 建议值**，再给细节；别把原始数据一股脑倒出来让他自己判断。

## Fluent / 鼠标 / UI

- ★★★ **不许依赖"没验证过的 Fluent 内部字段/方法"**（2026-10-01 实查发布包）：
  把 release 的 `main.lua` 下下来 grep —— **公开 API 名被压缩掉了**（`AddToggle`/`AddButton`/`AddDropdown` **0 命中**），
  但 **GUI 侧实例名仍在**（`DropdownFrame` / `DropdownList` / `DropdownOption` / `SetTitle` 等 30+ 命中）；
  且**本项目旧代码用的 `escmenu` 字段在这一版里根本不存在**（0 命中）。
  ⇒ 想用"给按钮动态改标题"这类接口前，**先在发布包里 grep 到它**，否则一律给兜底/换方案。
- ★★★ **菜单开合用"观测法"，别钩内部事件**：`task.spawn` 每 0.25s 轮询 `F.MenuOpen()`，
  在**开→关**那一刻执行收尾（`F.CloseDropdowns()`）—— 覆盖 Esc / X / G 键 / 触屏按钮 / 最小化**所有**路径，
  不依赖任何 Fluent 字段。**这正是"关菜单后下拉悬在屏幕上"的根治办法。**
- ★★ `F.CloseDropdowns()` 要两级：① `if opt.Open then opt:Close() end`；② 若仍为真，
  直接隐藏 `opt.DropdownFrame` / `opt.DropdownList`（实例名压缩后仍在 ⇒ 可靠兜底）。
- ★★ **会锁鼠标的功能（Freecam/LockCam）必须让开菜单**：`UIS.MouseBehavior = LockCenter` 若每帧抢回，
  会覆盖掉 Fluent 打开菜单时设的 `Default` ⇒ **指针被锁死 ⇒ 点不到控件 ⇒ 关不掉菜单**。
  **三层让开**：① `F.MenuOpen()`（呼出键监听）② `UIS.TouchEnabled` ③ ★**观测法**——
  只要鼠标当前**不是** LockCenter（= 有人放开了，只可能是菜单/游戏），就当"菜单可能开着"，
  **让开 0.8s 不抢回**（专治"用非 G 的方式开菜单时守卫不知道"）。
- ★ **菜单关闭时要收起张开的选项列**（Fluent 下拉在窗口隐藏后会悬在屏幕上）⇒ `F.CloseDropdowns()`
  挂在"开→关"跳变上（**呼出键与触屏按钮两条路径都要挂**）。
- ★ **F1 紧急关闭无条件启用**（它是紧急出口，不受"不自动开启"约束）。
- ★ `isOwnGuiName` 要按**对象**比对（`inst == Fluent.GUI`），⛔ 别按"名字里含 Fluent" ——
  那会把**别人的** Fluent 界面当成自家的去保护/重建。
- ★★ **动态下拉别乱进 `F.PLAYER_DROPDOWNS`**（2026-10-01 新增「收藏点位」时踩到）：
  那个名单看着像"给 `CfgSyncUI` 跳过用"，其实 **`F.RefreshPlayerDropdowns()` 也复用同一名单** ——
  每隔有人进/出服就拿**玩家名**去 `SetValues` ⇒ 把自家动态列表（点位名等）冲掉。
  **判据**：`CfgSyncUI` 对非 Toggle 控件取 `want = C[name] or T[name]`，只要该控件**没有** C/T 写入点，
  它自然被跳过，**根本不需要进名单**。
- ★ ★★ **"收藏点位"类功能的数据放 `C.<字段>`** ⇒ 自动搭上现成落盘链路（`SaveConfig` 写 `{T,C}` + AutoSave 线程），
  **不要为它另开一个存档文件**；改完立刻 `RefreshUI()`（`opt:SetValues`）+ `SaveConfig()` 并**把坐标打进日志**。
- ★ UI 审计口径：控件数 · 彻底死 · 重复写同一标志 · 单节控件数；
  **保留 `Table.insert` 目标只认 `F.OWN_GUI_NAMES` 与自己的 Fluent GUI**。
- 已知的"半死"控件（标志不被读、但功能层直接执行，属正常）：`VisionBoost` / `Mute` / `Antilag`。

## 手机浮钮「长按急停」是隐形地雷（2026-10-04）

- `CMTouchToggle` 浮钮（左边缘 36% 高、58×58，仅触摸设备）**长按 1.9 秒 = 一键全关**。
  用户反复"我明明开着的功能怎么又关了" ⇒ **先怀疑它**（日志里现在会打「[急停] 本次关掉的功能: …」）。

## 逐页对账的判据要收窄（2026-10-04）

- 查"开关拨了有没有效果/有没有还原"：配对名要**先剥 `Enable$` 再拼 `Disable`**；链里的名字**带 `F.` 前缀**、候选名要统一前缀再比，否则一次报 30+ 条假警。
- ★ 日志不只在 callback 里 —— 也在被调函数体里（`Trans.Enable`）。判定要顺着调用链找一层。
- ⛔ 核代码**不要用 `sed -n 'A,Bp;C,Dp'` 多段拼接**看：会把后一段的代码误当成前一段的（本轮据此误判过一次真 bug）。

## 急停（一键全关）的保留名单（2026-10-04，14.0.31）★ 改急停前必看

- ★★★ **防护类功能不该被急停关掉**：`F.PANIC_KEEP` 现在 = `CharPersist / AutoSave / GuiProtect / AntiAFK / KickGuard / GuardOn / HitGuard / SteadyOn / TrapWarn / SpeedGuard`。
- ★★ **"保留标志"必须同时"从调用清单里移除对应 Disable"** —— 只加 `PANIC_KEEP` 而清单里还留着 `F.AntiAFKDisable` ⇒ 标志是 true、实际被关停 ⇒ **表里不一**（本轮就踩了这个，验证时才发现）。
- ★ 急停末尾要 **`pcall(F.CfgSyncUI)`**，让 UI 勾选状态与真实状态一致（否则用户以为"被关了/被开了"）。
- ⚠ 注意区分 **急停链** 与 **卸载链（`UnloadAll`）**：卸载链**应该**全关（含防护类），别把两者的清单混在一起改。

## ★★★ 菜单「整页消失」的根因与根治（2026-10-05 v16.9.2）

- ★★★ **`Tabs` 是别名表，不是每页一个真 tab**：`Tabs.World=Tabs.Visual` · `Tabs.TP=Tabs.Move` ·
  `Tabs.AC=Tabs.Setting=Tabs.System` ⇒ **源码里 `Tabs.X:` 的行序才是真实构建顺序**；
  判断"用户说哪页没了"必须按行序推，别按页名想。
- ★★★ **`buildMenu` 整段只包一个 `pcall`** ⇒ **任何一处控件抛错，其后所有控件都不建**。
  按行序：Visual/World 区一崩 ⇒ 传送→挂机→翻译→AC→系统 **全部消失**（≠ 按用户看到的页序）。
- ★★ **Fluent 是运行时从 GitHub 拉 `releases/latest`**（+9 个镜像 + 本地文件优先）⇒ **上游一改 API 就可能炸**；
  换执行器（忍者/Real）取到的版本/完整性不同 ⇒ 表现不同。**绝不能假设某个 `Add*` 一定存在**。
- ✅ **根治：给 `Tabs` 加安全代理 `_safeTab`** —— 每个 tab 包一层，7 个 `Add*` 方法都走 `pcall(fn, t, ...)`，
  失败只跳过该项，并打 `[UI] * 页名 / 方法 -> 建不出来: 原因`。实现三条：
  ① **先收集 keys 再包装**（别在 `pairs(Tabs)` 里直接改值）；② **显式传原对象当 self**（`pcall(fn, t, ...)`），
  否则 Fluent 内部拿到的 self 是代理表；③ `setmetatable(p,{__index=function(_,k) return t[k] end})` 保留其他方法。
  ⚠ 前提：先确认 `Tabs.X` **只被 Add\* 方法使用**（本项目确实如此）才可安全代理。

## ★★★ 「降画质 / Antilag」的完整覆盖清单（2026-10-05 v16.9.3 定稿）

做这类"降画质/提帧"功能，**必须覆盖以下几类**，且**每一类都要记录原值、关闭时还原**：

| 类别 | 具体做法 |
|---|---|
| 渲染档 | `settings().Rendering.QualityLevel = 1` |
| 网格细节 | `settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level00` |
| 全局光照 | `Lighting.GlobalShadows=false` · `EnvironmentDiffuseScale=0` · `EnvironmentSpecularScale=0` · `ShadowSoftness=0` |
| 雾/亮度 | `FogEnd/FogStart = 9e9` · `Brightness=1` |
| **后处理特效** | `Lighting` 下的 `BlurEffect / SunRaysEffect / ColorCorrectionEffect / BloomEffect / DepthOfFieldEffect / Atmosphere` → `Enabled=false` |
| 粒子类 | `ParticleEmitter`/`Trail` → `Lifetime = NumberRange.new(0)`；`Smoke`/`Fire`/`Sparkles` → `Enabled=false` |
| **光束** | `Beam.Enabled=false` |
| **灯光** | `PointLight`/`SpotLight`/`SurfaceLight` → `Enabled=false`（灯光计算很吃性能） |
| **云** | `Clouds.Enabled=false` |
| 阴影 | 所有 `BasePart.CastShadow=false` |
| 水面 | `Terrain.WaterWaveSize/WaveSpeed/Reflectance=0` · `WaterTransparency=1` |
| 增量 | `workspace.DescendantAdded` 里对新出的特效/灯/光束/云同样处理（否则新刷出来的又回来） |

- ⛔ **省一次遍历**：别写成"处理粒子遍历一遍 `F.walk(workspace)`、关阴影又遍历一遍"——
  **合并成一次遍历按 `ClassName` 分发**（v16.9.3 就是修掉这个重复）。
- ⚠ 关掉"整个 `Lighting` 的天空盒 `Sky`"会让画面变黑，**别做**；`Atmosphere` 可以关。

## ★★ Roblox 脚本「加载太慢」的成因与最有效的一招（2026-10-05）

- 本仓加载慢的**主因是 Fluent UI 要联网拉**（130KB，还要在 8~9 个镜像间依次重试）。
- ★★★ **最有效的一招 = 拉取成功后写本地缓存**：`writefile("CheatMenu_Fluent.lua", body)`，
  配合已有的"**本地文件优先**"逻辑 ⇒ **第二次加载完全免网络、秒开**。
  日志里给一句"已缓存，下次秒开"让用户知道生效。
- 次招：**镜像源前置**（国内加速镜像排在官方 GitHub 前面），减少首次的超时等待。
- 诊断：在关键阶段插 `os.clock()` 差值日志（`Fluent 取源耗时` / `菜单构建耗时`）——**让"慢在哪"可见**，
  否则只能靠猜。

## ★★★ 用户真实环境与脚本日志位置（2026-10-05 从真实日志挖出）

- ★★★ **脚本自己的日志写在执行器工作区**：
  `%LOCALAPPDATA%\Real\workspace\CheatMenu_Logs\CheatMenu_log_game_<PlaceId>.txt`
  （含每次加载的全过程 + `[UI] *` 构建失败行 + 扫描结果）⇒ **用户说"扫描新的 txt"就是这些**。
- ★★★ **执行器 = Real（PC / 键鼠）**；用户账号名 `kiana812i`。
- ⛔⛔ **Real 的执行器 Fluent 里没有 `AddColorPicker`** ⇒ 实测报
  `[UI] * World / AddColorPicker -> 建不出来: attempt to call a nil value`。
  **这就是"视觉/世界页之后 挂机·翻译·系统 全没了"的元凶**（构建是一整段、一崩全崩）。
  ✅ 已加"取色器降级"（`_safeTab` 里失败自动改用「预设颜色下拉」）。
- ★ **加载耗时实测**：`Fluent 取源 2.17 秒` + `菜单构建 0.41 秒` ⇒ 加载慢的大头是 Fluent 联网。
  （本地缓存已在这次生效：日志有"已把 Fluent 缓存到本地 => 下次加载免网络、秒开"）
- ★ **游戏会删我们的悬浮按钮**：日志出现 `[CheatMenu] 检测到 GUI 被移除(MenuButton), 正在重建...` ⇒ 已有自重建逻辑。
- ★ **该游戏自带敌我结构**：`Workspace.Highlight.Enemy.HighlightHolder.<玩家名>.<部位>`
  ⇒ **判断敌我应优先读它**（`F.RefreshGameEnemyNames`），而不是只看 `Player.Team`（本游戏 Team 不可靠）。
- ★ 全扫描时日志有 `[遍历] 达到上限 40000 个, 结果可能不完整` ⇒ 是有意的限流。

## ★★★ 触屏设备：绝不注入鼠标（2026-10-05 实锤）

- ★★★ **在触屏（手机/平板）上，任何"模拟鼠标"的注入都会变成真实触摸** ⇒ 用户看到的就是**屏幕被一直乱点**。
  本项目踩过的注入点（全部已加 `UIS.TouchEnabled` 闸门）：
  `VirtualInputManager:SendMouseButtonEvent` / `SendMouseMoveEvent`、`VirtualUser:ClickButton1`、
  `mouse1click`、`mousemoverel`。
  ⛔ 尤其危险的是**自动开火**（每 0.12 秒点一次屏幕）——而它**默认是开的**，所以触屏用户一进游戏就在被乱点。
  ⇒ 触屏上自动开火只留 `tool:Activate()` 与屏幕按钮 `firesignal`（这两条不点屏幕）。
- ⛔ **【已作废 2026-10-09 v17.0.37】"触屏就隐藏鼠标指针"是错的**：原结论是"触屏上 `MouseIconEnabled`
  应保持 false、加载时主动置 false"。实测：**触屏笔记本**（`TouchEnabled==true` 但鼠标正常）会被误伤，
  而且"隐藏"与"恢复"共用 `TouchEnabled` 判据 ⇒ **只藏不放，用户指针永久消失**（用户报"我鼠标怎么不显示出来了"）。
  ⇒ 现行规矩：**任何情况下都不许主动把指针藏起来**（源码里已无 `MouseIconEnabled = false`，回归断言锁死）。
- ★ **挂机防踢用 PuckAFK 的做法**（见 `MEMORY-战斗与移动.md` / 当日日志）：`Idled` → `VirtualUser:CaptureController()`
  + `ClickButton2(Vector2.new(0,0))`（**右键 + 屏幕角落**）。**触屏跳过**（同样会乱点），
  触屏只保留"掐游戏自己的挂机检测连接 + 写心跳属性"。
- ⛔ **【已作废 2026-10-09 v17.0.38】不许再用 `UIS.TouchEnabled` 判"这台机器有没有鼠标"**。
  正确判据：**`UIS.MouseEnabled` / `UIS.KeyboardEnabled`（有没有鼠标/键盘），`TouchEnabled` 只作最后兜底**
  （已封装 `F.HasMouse()`，全文"要不要处理鼠标"的地方都用它）。
  `TouchEnabled` 只表示"设备支持触摸"，触屏笔记本上为 true ⇒ 会把整类设备误判成手机，
  一次打掉**指针可见性 / 鼠标锁定 / 输入空点 / 界面布局**四处（v17.0.37+38 三个 bug 同一个病根）。
  ⇒ 判输入方式要看 **`MouseEnabled` / `KeyboardEnabled` / `TouchEnabled` 三个一组**。
- ★ 处理触屏输入时的正确姿势（PuckUI）：`InputBegan/InputChanged` 里把
  `Enum.UserInputType.Touch` 与 `MouseButton1`/`MouseMovement` 并列判断；
  取坐标 **Touch 用 `input.Position`、鼠标才用 `UIS:GetMouseLocation()`**；拖拽要记住 `activeTouch` 只跟随同一根手指。

## ★★ 界面文案规矩（2026-10-06 v16.9.17 全量整理后）

- ★★ **统一写法**：`Title` = 「是什么 + 最关键的限定」；`Description` = 「怎么用 / 具体数值与默认值 / 与其他开关的联动 / 边界与失效条件」。
  例：自瞄描述里要写「开它时会顺手把自动开火打开」；飞行要写「会临时关掉无限跳」；速度档位要写清切档后滑块量程。
- ★★ **文案必须跟实现走**（项目已踩坑：档位③的「14 层全开」是假的、上帝模式标题列了实现里没有的项）。
  改完必须**回读实现**再定稿，禁止凭印象写。
- ★★ **抽控件文案的坑**：不能用「起始行 + N 行窗口」去抓 `Title/Description`，会串到下一个控件；
  必须**从 `Add*(` 起做括号配对**取出完整实参表再抓字段。
- ★★ **每个控件都要有 Description**：没有描述的控件等于让用户猜。
- ★★ **孤儿接回判据**：`grep -c "F.Xxx"` 只有 1（就是定义处）⇒ 该功能在界面上点不到，要么接回要么删；
  **不要**只留一堆没人调用的 `F.*`（本项目 2026-10-06 抓到 3 个：CollectAll / PreviewSell / SellLowCPS）。

## ★ 第一人称/锁定视角下"鼠标不出来"（2026-10-08 v16.10.85 → v16.10.86）

- 症状：**第一人称或 Shift-Lock 锁视角时打开菜单，鼠标图标不出现、菜单点不动**。
- ✗ **错解（v16.10.85，实测无效）**：只在菜单可见性变化时、或每 0.05 秒把 `UIS.MouseBehavior` 设回 `Default`。
  第一人称下 **Roblox 引擎是「每帧」把它改回 `LockCenter`**，低频设置等于没设。
- ★★ **正解（两层一起上，v16.10.86 起；v16.10.90 修好）**：
  1. **每帧强制**：用 **`RS:BindToRenderStep("CM_MenuMouse", Enum.RenderPriority.Camera.Value + 1, fn)`**
     —— **优先级必须排在相机(200)之后**，否则会被游戏的相机脚本按帧覆盖（`RenderStepped` 顺序无保证，
     实测会失效）；关菜单 `UnbindFromRenderStep`。
  2. **釜底抽薪**：把 **`LP.CameraMode`** 由 `LockFirstPerson` 改 **`Classic`**（记录原值，关闭还原）。
- ⛔⛔ **血泪坑**：`CameraMode` 是 **`Player`** 的属性，**`workspace.CurrentCamera` 上没有它**。
  写成 `camera.CameraMode` 会**被 pcall 静默吞掉**、**完全没有效果**（日志还照打"已接管"，最难查）。
  正确写法在**自家源码**里就有：`F.ZoomEnable` 的 `LP.CameraMode = Enum.CameraMode.Classic`。
- ⇒ **通用规律 1**：对"引擎每帧强制的属性"，低频轮询没用 —— 要么**排在引擎之后执行（BindToRenderStep 高优先级）**，
  要么**改变那个状态本身**（此处切 CameraMode）。
- ⇒ **通用规律 2**：**改引擎 API/属性前先 grep 自家代码**有没有现成正确范式。
- ⇒ **通用规律 3**：**`pcall` 会把"属性不存在/拼错"静默吞掉** ⇒ 关键写入首次成功时**要打一行读回值的自证日志**，
  否则会出现"日志说成功、行为没变"的假象。
## ★★★ 连点器：**最终回退到 16.10.82 = "第二个版本"**（2026-10-09 v17.0.12 定稿）

用户三步走：「是定位位置 连点的」→「彻底删除不要保留…回退老版本」→「**回退到刚出这个功能的第二个版本**」。
连点器版本谱系（本地快照实测）：16.10.79 = **1 控件**（`连点器(左键连点 · 约 20 次/秒)` 单开关）→
**16.10.80（clicker2）= 3 控件：连点器 / 间隔 / 快捷键 ← 用户要的** → 16.10.83 加内部 `ClickerPoint` →
16.10.99 = **8 控件**（+点击范围 / 锁定点击点 / 锁定当前位置 / 锁定点 X / 锁定点 Y）。
⚠️ 我连错三次：v17.0.7 整体重写 / v17.0.10 只抄交互+留"加固" / v17.0.11 退回 16.10.99（**那不是第二版**）——全被否。
✅ v17.0.12：实现（332→116 行）+ UI（32→8 行）+ `PANIC_KEEP`（去 `ClickerLock`）+ 配置默认值 全部对齐 16.10.82，
   逐字节取自 `backup/pre-ckpos-16.10.82.lua`（其连点器分两块：`OverOwnGui/MouseClickOnce/Gap/KeyCode` 与 `Enable/Disable/Toggle/Hotkey`）。
⛔ **`CheatMenu-17.0.1~17.0.11` 的连点器（点击框 / 锁定点 / 坐标点击）都不是用户要的**。
★ 口径：先**查清"用户说的那个版本"到底是哪一版**（翻 `backup/` 快照 + 版本谱系），再照抄原文；别拿"我刚改过的上一版"顶替。

## ★★★ 找"更早版本"的正确路子（2026-10-09 实战，省掉 10 倍时间）

1. **先翻本地快照** `.workbuddy/build/backup/*.lua`（几十份 `pre-<功能>-<版本>.lua`）——
   `grep -l 'AddButton({ Title = ".*锁定' *.lua` 一次就定位到「16.10.99 是最后一版带该按钮的」。
   ⇒ **比查 GitHub 快一个数量级，且没有限额**。
2. 需要仓库历史时：`GET /repos/{o}/{r}/contents/CheatMenu.lua?ref=<sha>` 拿原文；
   ★ **GitHub API 未鉴权只有 60 次/小时** —— 我扫 300 个 commit 找版本号直接被 403 限流一小时。
   绕开办法：**代理直拉指定 commit 的裸文件**（不占 API 额度）：
   `https://gh-proxy.com/https://raw.githubusercontent.com/<owner>/<repo>/<sha>/<file>` ✓
3. ⚠ 版本号有"时间差"：commit 的 `version.txt` 可能比 `CheatMenu.lua` 的 `F.VERSION` 旧一位（--no-build 事故遗留）
   ⇒ 认版本要以**文件内 `F.VERSION`**为准，别只看 `version.txt`。

## ★★★ 自绘指示图元（框/准星/HUD）三条铁律（2026-10-09 v17.0.7 连点器重写后定稿）

用户报「框一直在抖、偏移位置、到处跑」——**三个铁律**，破一条就会出现这类"看起来像玄学"的症状：

1. ★★★ **只许由事件更新，绝不许在循环里更新**。
   旧实现把"画框"放在点击循环里每帧调（`MarkSync`），位置取不到就重新取点
   ⇒ 退化成"每帧按当前鼠标重画"＝抖＋漂＋到处跑。
   ⇒ 正解：`Render()` 只在 **开关/拖动/改参数** 这些事件里调；**框模式下禁止读鼠标**（`GetMouseLocation` 调用数应为 0）。
2. ★★★ **夹取与校验必须共用一个边界函数**。旧实现夹取用 `half = area/2` 却只夹到 `floor(half)`，
   而校验要求 `>= half` ⇒ **奇数边长**（121 ⇒ half=60.5）永远夹不到合法值 ⇒ 每帧重新取点。
   ⇒ 正解：边界只写一次（`F.ClickerHalf() = math.ceil(area/2)`），夹取与校验都调它。
   ★ 这是"读和写共用同一口径"的**升级版**：光有规矩不够，**必须只有一个实现**（否则迟早分叉）。
3. ★★★ **点击目标与图元必须来自同一个函数**。旧实现"画框"和"取点"各走一条链
   ⇒ 出现"框画在菜单上、点在鼠标处"这种不一致。正解：`Ensure()` 被两者共用，`Render()` 与 `Point()` 都从它取值。

**配套两条经验**：
- 执行器老 API `mouse1click / mouse1press / mouse1release` **不接受坐标**（点的是当前鼠标位置）⇒
  **按坐标点击（VIRTUALINPUTMANAGER:SendMouseButtonEvent）不可用时，框模式宁可一次都不点**，绝不许退回老 API（会点在鼠标处，可能正是菜单）。
- 建/用自建 ScreenGui 前，把 **gethui() / CoreGui / PlayerGui** 三处的同名旧 GUI 全销毁 ——
  历史注入残留会与新实例的图元**同时存在**，表现为双影/抖。

## ★★★ 定位类功能：失败路径绝不能"什么都不显示"（2026-10-09 v17.0.3 实锤）

**症状**：用户点「显示点击框」——**什么都没出来，也没有任何提示**。
**根因**：v17.0.2 把 seed 改成"只认鼠标在游戏画面的历史"，刚注入时历史为空 ⇒ 拿不到位置就不画框，
而 v17.0.1 的旧 seed 是**直接读当前鼠标**、永远成功 ⇒ 无论对错都至少画一个框。
⇒ **规矩**：`Seed` 必须**兜底到当前鼠标**（最后手段），失败路径必须是"先画出来让用户拖"，不是"静默什么都不做"。

**同批发现的两个"看不见"（都属通用坑）**：
1. **自建叠加层 `DisplayOrder` 必须够高**：本仓其它叠加层用 999，点击框只有 50，而 Fluent 菜单同样挂在
   `gethui()/CoreGui` 下 ⇒ 一旦与菜单重叠就是**完全隐形**（用户会以为"没画出来"）。定位/指示类框一律给到 `2147483647`。
2. **`F.Out` 是日志列表，不是弹窗** ⇒ 关键失败必须补 `Fluent:Notify`，否则用户什么都看不到。
   ★ 判断一件事"用户能不能感知"，要问的是"它出现在屏幕上哪里"，不是"日志里有没有写"。

**附带一条容易误判的事实**：`F.ClickerOverOwnGui` 用 `PlayerGui:GetGuiObjectsAtPosition`，
而 Fluent 的 GUI 挂在 `gethui()/CoreGui` ⇒ **它本来就看不见自家菜单**。
所以"防止误点菜单"不能依赖自家 GUI 判定，只能靠**状态闸**（本例：没搬过位置就不点击，拖一次即解除）。

## ★★★ 连点器「锁定点击点」必须排除自家 GUI（2026-10-09 v16.10.99 实锤）

**症状**：点「锁定当前位置」直接把点锁在**菜单自己身上** ⇒ 之后点击循环又被 `F.ClickerOverOwnGui` 判为
"点在自己菜单上"而**全部跳过** ⇒ 表现为"锁了但什么都不点"。

**根因**：`us:GetMouseLocation()` 取的是**全局鼠标位置**，而**点按钮的那一刻鼠标必然在菜单上**。

**正解（三级取值，不新增交互步骤；v17.0.2 已落地为 `F.ClickerMouseWatch`）**：
1. **事件驱动**记录"鼠标最后一次停在**游戏画面**（`F.ClickerOverOwnGui` 为假）时的位置"；
   用 `UIS.InputChanged` 的 MouseMovement + **50ms** 节流（事件优先、轮询兜底的项目风格）。
   - ★ **生命周期跟"会话"走，不跟"开关"走**：加载时启动、卸载时停，中途**不随开关连断**。
     （v17.0.2 教训：规划时接成"关框就断、开框再接"⇒ 中途停掉后种子位置也没了，用户又得走"移动鼠标→再开关一次"两步。）
2. 取坐标一律用 **`us:GetMouseLocation()` 空间**（与点击框 GUI 的 `IgnoreGuiInset=true` 偏移、`SendMouseButtonEvent` 同一套）；
   ⛔ **不许混用 `InputObject.Position`**（视口空间，差一个顶栏高度 = 画出来的框和实际点击差 36px）。
3. 补种时依次取值（v17.0.3 定稿）：**存档里的合法值 → 记录的游戏内位置 → 当前鼠标（兜底，必须画出来让用户拖）**；
   兜底到鼠标时置 `F._ckNeedDrag = true`（**没搬过就不点击**，一次性提示），拖动即解除。
4. ⛔ **关连点器/关点击框时不要清空记录点** —— 那份历史正是下次"一步到位补种"要用的。

⇒ **通用判据**：任何"取当前鼠标位置"的功能，都要先问一句"**用户按这个按钮时鼠标在哪**" ——
如果那个位置就是按钮本身，就必须有"上一次有效位置"的兜底。
## ★★★ 「开关开了但功能失效」的根因范式：**状态被多处耦合 + 其中一个只在本次会话有效**（2026-10-09 v17.0.1）

**实锤案例**：连点器点击框（v17.0.1）。判定要同时满足 `T.ClickerBox`(开关) + `T.ClickerLock` + `F._ckBoxPlaced`(运行时标志)，
而 `_ckBoxPlaced` 只有 `ClickerDragTo` 会置位 ⇒ 只要
① 存档恢复把 `T.ClickerBox=true` 写进去但回调被 `_cfgSyncing` 拦掉、
② 恢复顺序里 `Clicker` 先于 `ClickerBox`、
③ 任何一次 `ClickerBoxSet(false)` 清掉标志，
⇒ 就会出现「框明明开着/有过，一开连点器中心就掉回鼠标」这种**看起来像玄学**的失效。

**正解（三招）**：
1. **单一事实来源**：判定只认一个开关（`T.ClickerBox`）；**运行时标志不参与判定**（只作信息）。
   ★ v17.0.2 收尾：把 **`T.ClickerLock` 整条删掉**（全仓只写不读的幽灵状态）+ 清掉 `F.PANIC_KEEP` 里的对应项
   —— "一个概念多处状态"的病根必须连根拔，留着只写不读的字段等于给下一个维护者埋雷。
2. **派生而非记忆**：目标位置从「持久化配置 + 校验」推导（`F.ClickerBoxPos` 只认"存值不小于半边长"，
   于是默认存档 `(1,1)` 天然被当成"未定位"），不可用就**自动补种**（`F.ClickerSeed` 落到记录的游戏内位置并写回配置），
   **永不"拿不到就放弃"**；**停止类函数（`Disable`）不许带补种副作用**（改用纯读的 `ClickerBoxPos`，免得"停止"反而锁定一个位置）。
3. **纯读避开递归**：新增 `F.ClickerRawMouse()` 供"补种"使用 ——
   不能让 `Locked → Seed → Center → Locked` 成环（`ClickerCenter` 会调 `ClickerLocked`）。
4. 交互即开关：**拖动框 = 打开"显示点击框"**，并同步界面控件（用 `F._ckBoxSyncing` 守卫防回调回环）。
5. ★ 口径唯一：`ClickerBoxPos` / `ClickerDragTo` **共用同一个 `F.ClickerClamp`**；不许"读"和"写"各用一套边界判据
   （v17.0.1 前是"读要求 ≥20 + 只判右下超界 / 写走 clamp" ⇒ 同一个框能算出两个中心）。

⇒ **通用判据**：任何"开关打开后功能却不生效"的 bug，先问三句：
**这个开关有几个副本状态？哪个副本只在运行时存在（重启/重载就没了）？有没有一条路径只更新了其中一个？**
再加一句：**"读"和"写"用的是同一套口径吗？**

## ★★★ 「假成功」：写入的值可能是脏的（2026-10-09 v17.0.25 实锤）
连点器按 F7"保存成功"（右下角弹已保存），但开连点器又弹"还没保存位置"。
根因：`UIS:GetMouseLocation()` 在某些执行器返回 `(0,0)`，保存函数**没校验**就写进配置（弹"已保存"），
而读取函数有 `>0` 校验 ⇒ 读出 0 判为"没保存"。**两个提示都"对"，但它们是两个不同的值。**
⇒ 定稿：**取鼠标位置必须三路兜底**（`GetMouseLocation` → `LP:GetMouse()` → `InputChanged` 记录的最近位置），
  每路都校验有效性；全失败要**明确报错且不写脏值**。
★ **通用判据**：任何"保存/读取一个值"的功能，**读入口必须多路兜底 + 校验有效性**；
  "写了但值是 0/空" 与 "没写" 在用户看来截然不同，但代码里常被混为一谈。
  （对照：本项目既有规矩"定位类功能失败绝不能什么都不显示"——本条是它的**对偶**：失败也不能假报成功。）

## ★★★ 热键"按了完全没反应"= `gameProcessedEvent` 吃掉了（2026-10-09 v17.0.40 实锤）
**症状**：按 F7 存坐标**毫无反应**（连日志都没有）。与"存下来的值不对"是**两个不同的 bug**——先问症状，别猜。
**根因**：钩子首句 `if gp or not input then return end`（`gp = gameProcessedEvent`）。会消费按键的场景至少三种：
① **脚本自己的菜单用了全屏 Modal 覆盖层**（菜单开着时吃掉一切输入）② 聊天框/TextBox 有焦点 ③ 游戏自己绑了这些键。
**规则**：**功能键（F1~F12）一律豁免 gp** ⇒ `if gp and not F.ClickerFnKey(k) then return end`；
字母键/D 键等照旧尊重 gp（免得抢了聊天输入）。

## ★★★ 取"鼠标位置"的硬约束：锁定态下指针根本不存在（2026-10-09 v17.0.40 定稿）
- 游戏锁鼠标时（`MouseBehavior ~= Default`）`GetMouseLocation()` 返回**不动的死值**（日志实锤：连按 F7 十几次全是同一个数，
  且都在菜单窗口所在区域 ⇒ 存的是"关菜单那刻被锁住的位置"）。
- **只写一次 `MouseBehavior = Default` 再 `task.wait(0.05)` 不够**：游戏每帧锁回中心（菜单必须 `BindToRenderStep`
  "每帧解除锁定"才可用 = 铁证）⇒ 取点/取坐标窗口内必须**逐帧顶住**（绑 `RenderPriority.Last`）。
- **全屏取点层必须是 `ScreenGui` → `TextButton` 两层**，`TextButton` 直接 `Parent = gethui()` 不渲染、收不到点击。
  配方：`ResetOnSpawn=false` + `IgnoreGuiInset=true` + `DisplayOrder` 拉高 + `ZIndexBehavior=Sibling` + `Modal=true`。
- **收尾三件套**：销毁层 + `UnbindFromRenderStep` + 还原 `MouseBehavior`（进入前的值）且**强制指针可见**；
  并把清理函数加进卸载/热加载收尾列表（否则热加载后留下死层 + 永久锁不住鼠标）。
- **坐标空间（一次说清，别再纠结 36px）**：`UIS:GetMouseLocation()` 与输入事件 `input.Position` **同为屏幕坐标（含顶栏）**；
  `VirtualInputManager:SendMouseButtonEvent(x,y)` 取的也是屏幕坐标（官方新 API 文档明写 "screen-space position"）
  ⇒ 存下来的值直接回灌即可，**不需要 ±36 补偿**。
