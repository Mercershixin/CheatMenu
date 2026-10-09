# 反作弊事实 与 扫描设计（细节）

## 防守方事实

- **阈值**：速度 >100 studs/s · **瞬移 >50（每 0.1s 累计）** · remote >30/秒 · **滞空 >2s** ·
  `DetectionThreshold=5`（累计 5 次才处置）。
- **Adonis 订阅日志输出**，命中 **79 词执行器函数名黑名单**直接 kill ⇒
  任何新打印文案先想"这词在名单里吗"；原生 `print` 全项目只许 1 处
  （**消毒表 `F.SANITIZE` 绝不能删** —— 删了等于对着黑名单报名字）。
- **Sentinel 按实例名扫** `exploit/inject/cheat/hack/dex/bypass/crack/scriptware`；
  脚本名判定要**词元边界匹配**（裸 "kick" 会误伤 `KickTraining`）。
- **穿墙**要 `SetStateEnabled(StrafingNoPhysics, false)` 掐掉判定依据；`Speed` 检测器读 `GetRealPhysicsFPS()`。
- **"被拉回"第一位原因 = 网络所有权不在你这边**：`HRP:GetNetworkOwner()` 为 nil ⇒ 服务端持有 ⇒
  参数调多大都必然回弹。先 `SetNetworkOwner(LP)` **再回读验证**；抢不到 = 该游戏位移类**不可行**。
  有的游戏每 0.4s 抢回 ⇒ `F.SrvHoldEnable`（长连接，Panic/Unload 必须断）。
- 量化只能用"**自己驱动**"的探针 `F.SrvProbe`；⛔ 用"我做多少 vs 真实位移"比对时，
  **用户不动会得到"0 次拉回"的假安全结论**。诊断入口 `F.SrvOneClick()`/`F.SrvReport()`（★ 在「系统」页）。

## ★★★ 「东西拿到手又消失」类问题的定因（2026-10-01 用户实战日志实证）

- 看用户日志的最快路径：`%LocalAppData%\<执行器>\workspace\CheatMenu_log_game_<名>_<PlaceId>.txt`
  （Real 执行器 = `%LocalAppData%\Real\workspace\`），旁边还有 `CheatMenu_Config_v1.json`（存档）。
- 该局（Steal a Brainrot 一系）实证：**搬运/偷取判决在服务端**，客户端只有两条线：
  `ClientCharacter: IntegrityHeartbeat` 上报 + `IntegrityViolation` 收判决，另有 `Guards: SpeedHitWarning/SpeedHitOffer` 管"移动太快"。
- ★★★ **通用推论**：客户端能中和的**只有客户端自己的函数** ⇒ 这类"服务端判决"问题，"补强客户端绕过"
  （按名中和 / 拦 remote / 伪造遥测 / 断连接）**一律无效**。铁证：客户端 12001 个函数「命中 0 个带数字的可疑函数」= 没阈值可中和。
- ★★ **有效方向只有两条**：① **让移动看起来合法**（限速 + 缓升 + 别"瞬移交付" ⇒ 11.0.1 的
  `CarryGuard`/`SpeedRamp`/搬运中禁传送）；② **走游戏自己的合法通道**（`Treadmills: SpeedGain` /
  `SetSpeedRemote` / `CustomSpeedEvent`）—— 先决条件是**先用采集看客户端自己怎么发**，⛔ 之前绝不主动发未知 remote。
- ★ `WalkSpeed` **会复制到服务端** ⇒ 写 5000 等于在属性层自报家门；`SpeedAttrCap` 就是这条的旋钮
  （诚实代价：地面速度跟着降，因为地面本来就靠 WalkSpeed 驱动）。

## ★★★ 这个游戏类型（"偷"类）家族事实（2026-10-01 挖全，代码搜索实测）

- **同类游戏**：Steal a Brainrot · **Steal An Egg**（`games/107778070777162`）· Break and Steal an Egg ·
  Steal a Fish · Steal a Fossil · Steal a Wild。
- ★★★ **同族共用同一套网络结构**：`ReplicatedStorage.Packages.Networking` + `RE/RigSync/Refresh`
  ⇒ **"按关键词找远程"的做法天生跨游戏**（不用为每个游戏硬编码）。
- ★★★ **检测是分层的**：Brainrot 那局**服务端**（客户端 0 阈值）；**Steal an Egg 有客户端防加速脚本
  `ObbyAntiTPClient`** ⇒ **客户端那部分可以中和**。⛔ 别再一概而论"客户端改不了"。
- ★★★ **中和客户端检测脚本三步**（照抄 `monthonsova/Steal-An-Egg/EggESP/automation/SpeedBypass.lua`）：
  ① 按名清理 LocalScript（`Disabled=true` + `Destroy`）；
  ② ★**光删脚本没用**（其自述：*"its Heartbeat connection keeps running"*）⇒
     `getconnections(RS.Heartbeat)` 里按 `debug.info(fn,"n"/"s")` 认出它 → `connection:Disable()`；
  ③ `getgc(true)` 里挑 名字∈`{check,lagback,punish,kill}` 且来源命中关键词的函数 → `hookfunction(fn, →nil)`；
  ④ 挂 `PlayerScripts.DescendantAdded` 在游戏重新注入时再清。
- ★ 我们的实现：`F.SpeedAntiTP*`（移动页「加速防拉回」，**独立开关、默认关、可还原**）——
  按用户红线，"改游戏"的手段一律**不进主开关**。

- ★★★ **扫描必须排除"我们自己"**（2026-10-01 实测）：自动分析把热加载进来的自己（`@CheatMenu_hot`）
  当成了可疑函数（`F.SCAN_KW` 含 `cheat`，而我们的 chunk 名就含 CheatMenu）⇒ 输出全是垃圾。
  ⇒ `F.IsOursSrc(low)` / `F.IsOurs(f)`（源码名含 cheatmenu/fluent）在**关键词统计/家族/阈值/候选**四处跳过自己。
- ★★ **扫描上限要够**：`F.walk(RStorage, 4000)` 对大于 4000 个实例的游戏会**漏扫**（日志"达到上限 4000"）⇒ 已提到 12000。
- ★★★ **关键词表不能扩到"玩家自己的动作通道"**：换皮游戏的通道名是 `stealEgg` / `swingBat` / `eggClaimed`
  —— 断它们等于**让你偷不了蛋/挥不了棒**。命中 0 说明没误伤，是对的。

## 扫描设计口径

- **扫描只读**（硬约束）；三个补强点：① 根要全（`getloadedmodules` + **`getnilinstances`** +
  **`getinstances`** + PlayerScripts/PlayerGui/ReplicatedFirst/CoreGui/RS/Workspace）；
  ② **按 source 聚合**去重 + `getscripthash` 指纹 + 关键词**命中出处**；
  ③ 监听要**对每个信号取 `getconnections`**（连接数 + 处理函数来源）并单独扫**全局信号**
  （Players/UIS.InputBegan/Heartbeat/Idled/CharacterAdded）—— 反作弊的客户端监听在这里现形。
- **性能**：范围遍历必须**分批让出 + 硬上限**（`task.wait()` 只让出调度、不限总量）；`getconnections` 一个信号只取一次；
  取名字前**先做便宜的 `IsA`**。
- **能力表要全**（含 `getinstances`/`decompile`/`getreg`）—— 缺了用户看不到"为什么没结果"。
- ★★★ **全自动优先**（用户："我不想输入，我想扫描出来让你来做"）：
  `F.AutoKeywords()`（从可疑函数的字符串常量里**自动挑关键词**）→ `F.AutoProbe()`（自动找函数 + 提数字 +
  **给结论与建议值**）→ `F.ApplySafeCaps()`（按结果把速度压到 `阈值×0.9`，**用户点了才改、并明确报告改了什么**）。
- ★★ **「扫描补强」节两次收敛：9 → 5（2026-10-01 上半场）→ 2（下半场，用户又点名"一大堆"）**：
  现在是 **`AdvScan` 一个下拉当菜单**（关闭 / ★一键分析[阈值+找函数+家族] / 反查持有者 / 把速度压到安全值 /
  按形状找函数 / 按常量字符串找函数 / 家族聚类）+ `AdvArg`（**可留空 = 走全自动**）两个控件。
  ⛔ 那两个**必填**输入框（`ShapeBox`/`ConstBox`）就是要用户手打参数的元凶 ⇒ 一律改成可留空。
  **合并不许丢能力**：合并后必须逐个 grep 确认原函数仍被调用（本轮 6/6 全部仍被调用）。
  ★ **下拉当菜单/当按钮用必须复位**（否则第二次选同一个值**不会触发回调**＝按了没反应）。

## 元方法分层栈：细节与两个真 bug（2026-10-01 实测）

- ★★ **非栈顶卸载必须"接链"**：`F.MetaLayers[slot]` 是 `id → rec`，每次 Install 都新叠一层 wrapper
  （`box.orig` = 装之前那一层）。**卸载不在栈顶的那层**时，`mt[slot] ~= 自己的 wrapper` ⇒
  旧实现只 `return true`（留一层**死 wrapper** 在链上，功能透明但**不还原到原始**）。
  ⇒ 修法（8 行，不动分层设计）：在 bucket 里找 `box.orig == 自己 wrapper` 的上一层，**把它的 `box.orig` 接到自己的 `box.orig`**
  ⇒ **全部卸载后 `mt[slot]` 确实回到原始函数**。
  ⛔ 清单曾建议改成"每 slot 单层 + ids 集合" = **换核心设计**（各 factory 的链式语义会失去约定）⇒ 维护文档 §12.2 记明"停下报告"。
- ★★ **`_neutFns` 前缀写错**：表定义在 `AC._neutFns`，而 `UnloadAll` 清的是 `F._neutFns`（另一个从未用过的表）
  ⇒ **卸载后 AC 上的引用还在**。凡"清某表"都要**核对表挂在谁身上**。
- ★★ **`AC.markHooked(fn)` 登记的是被 `hookfunction` 原地改行为的那个对象** —— **这是对的**；
  清单曾判它"标错对象"，属**假报**（删了反而让隐身层把我们的 wrapper 当外来函数）。
- ★★ **动态玩家下拉漏了就整条功能失效**：`FlingTarget` 没有 `AddDropdown`（且三个 toggle 也不存在）
  ⇒ `Fluent.Options.FlingTarget` 恒 nil ⇒ 冻结/隐藏/拉过来**开了也没用**。
  ⇒ 新增"选目标"类功能时，**下拉 + `F.PLAYER_DROPDOWNS` 注册 + UI 入口**三件必须一起做。
- ★ **自己造的连接要自己收**：`_skelPlConns`/`_chamsPlConns`/`_hlObjs` 都缺 `PlayerRemoving`
  ⇒ 玩家离开后条目永久堆积。**凡 per-player 的表，Enable 里加 PlayerAdded 就要同时加 PlayerRemoving**。

## 从公开源码学到的（2026-09-20 抓的最新的）

- **按"常量字符串"找 AC 函数**（比按名字强）：AC 函数名可混淆，但**它要打印的文案写死在常量里** ⇒
  `filtergc("function", {Constants={...}, IgnoreExecutor=true}, true)`（无 filtergc 时退回 getgc 全扫 + 比常量）。
  见 `F.ScanByConstants()`。
- **按形状找函数**：`(upvalue 数量, 常量数量)` 当指纹，不靠名字（`F.FindByShape`）—— 公开样本
  `stealaeggspeedbypass.lua` 的做法。
- **阈值提取**（`F.ScanThresholds`）：把可疑函数 `debug.getconstants` 里的**数字**挑出来并按关键词贴标签
  （速度/位移/滞空/采样窗口/累计次数/处置阈值）—— **绕过加速飞行的关键不是知道 AC 在哪，是知道它的阈值**。
- **别的可行手法（归档但未接线）**：不返回假而是 `task.wait(9e10)` **把判定挂死**；
  **元数据回放**（hook 游戏的 `debug.info` 返回原始元数据）—— ⛔ 后者要全局 hook，属用户要求删掉的伪装那一类，刻意不做。
- **执行器 API 多别名解析**（手机执行器命名差异大）：`debug.getconstants or getconstants or getconsts` /
  `debug.getupvalues or getupvalues or getupvals` / `debug.getinfo or debug.info` / `getgc or get_gc_objects`。
  学公开源码要**挑新的**（旧语料已归档删除）；语料在 `.workbuddy/research/{corpus,fresh}/`。

## 档位与元表层的两个致命坑（2026-10-04 实测，14.0.12）

- ★★★ **`F.MetaInstall` 的 slot 必须归一化**：调用点习惯写 `"game.__index"`，但内部是 `mt[slot]` + `hookmetamethod(target, slot, …)`，
  传 `"game.__index"` ⇒ `mt[...]` 恒 nil ⇒ **静默 return nil，层永远装不上**（`ACIndexMask`/`CMXSpoof` 就这么废了很久）。
  ⇒ 用 `MetaSlotOf`（取最后一段）在 `MetaInstall/MetaUninstall/MetaActive` 三处统一处理。★ 这类"静默装不上"没有任何报错，只能靠对账发现。
- ★★ **「设标志 ≠ 启用」**：档位里写 `T.GuiProtect = true` 没用 —— 全项目没人读那个标志（`F.GuiProtectionEnable` 才是真入口）。
  ★ 判据：标志要么有人在循环里读、要么有配套 Enable 被调；**两者都无 = 完全无效**。
- ★ 查档位完整性时：**档位是累积结构（`lvl>=2`/`lvl>=3`）就顺带验证了包含关系**；是否"高档覆盖全部"要用「能力 × 档位」矩阵对账（`_audit_anticheat.py`）。

## 档位三档的真实内容（2026-10-04 定稿，14.0.14）

- ①轻 = 反甩 + 权限守卫 + 护界面 + 角色持续 + `CMXSpoof`（**__index 只读钩子**，含 gcinfo 伪装配套）。
- ②中 = ① + `AC.InstallNamecallHook`（**拦上报必依赖它**）+ 反封禁 4 层（拦上报 / 断日志 / 按名中和+ / 哈希冻结）。
  ★ 教训：**"拦上报"这类能力依赖某个钩子时，档位必须自己把它装上**，否则是空承诺（原来②档就没装）。
- ③重 = ② 的上层 + `ACWriteTier ③`（namecall+index+setmetatable+断可疑连接+新脚本/新远程监视+深度中和）+ `BypassTier ④` ⇒ `F.CMX_TierSync(4)` 开 **全部 14 层**（`F.CMX_TierMap`）。
- ★ **`F.CMX_TierOwn` 机制**：`TierSync` 只关"档位自己带起来的"层，用户手动开的不会被档位关掉 —— 改档位时别破坏这个。
- ★ 查"哪些层是死能力"：要跟一层**间接引用**（`CMXSpoofEnable` 里会 `pcall(F.CMX_GcinfoMaskEnable)`、`AutoScrubEnable` 里会调 `ArgScrubEnable`）⇒ 只看"谁直接调用"会误报。

## 「拦受伤上报」的判据与档位分层（2026-10-04 · 14.0.15）

- ★★ 用户问「服务端权威的话受伤/死亡要不要客户端上报？拦上报行不行」⇒ **分两种情况**：① 客户端算伤害再 `FireServer` 上报 ⇒ **拦下有效**（服务端真不知道）② 服务端算伤害 ⇒ 客户端只收通知 ⇒ **拦不到**。
  ⇒ 实现 `AC.HP_KEYS`（damage/hurt/death/ragdoll/knockback…）+ namecall 钩子 `T.HpBlock` 分支，**日志列出实际拦到的 remote** ⇒ 拦不到就是服务端算的。⛔ 关键词别放太宽的 `hit`（会误伤正常交互）。
- ★★ **档位必须自己装依赖的钩子**：②档"拦上报"依赖 `__namecall`，但原来只有③档装 ⇒ 空承诺。同理新加的"拦受伤上报"开关会自己 `AC.InstallNamecallHook()`。
- ★★ **②档原来根本没调 `F.CMX_TierSync`** ⇒ 表里 lv>=2 的绕过层从来不会因②档而开。分层映射表（`F.CMX_TierMap` + `F.CMX_TierSync`）**要确认每一档都真的调了它**。
- 档位分层定稿：①=只读 `__index` 钩 + 反甩/护界面/权限守卫；②=+namecall 拦上报+拦受伤+反封禁4层+温和绕过层（时钟/调试名/Instance）；③=+硬钩子/require/getgc 中和/哈希冻结/身份/FFlag ⇒ **14 层全开**。

## 钩子归属表（2026-10-04 定稿，14.0.16）—— 改钩子前先看这张表

- **心跳写值类（不装钩子）**：锁血 `Heartbeat` / 无敌 `Stepped` / 回血 `Heartbeat` / 不死 `Heartbeat` ⇒ 与档位、与任何钩子**完全无关**。
- **`__index` 层**：`CMXSpoof`（读伪装：位置/速度，不含血量）、`ACIndexMask`（速度三属性 + 血量读数 + 隐藏全名）、`CMHealthLock`（血量隔离）、`CMSilent`（静默瞄准）。
- **`__namecall` 层**：`AC` 层内含两个**互不相干的分支** —— `T.RemoteBlock`（拦反作弊上报）/ `T.HpBlock`（拦受伤上报）；`CMXView`（视图过滤）。
- **`setmetatable` 层**：`T.ACBypass`。
- ★★ **分层铁律**：① **一个 wrapper 内按 key 分别判标志**（别用"任一标志为真就伪装全部属性"——`ACIndexMask` 原来就是这么越界的）；
  ② **卸载前先问"还有谁需要这层"**（`T.HpBlock or T.RemoteBlock` 任一为真就不卸）；
  ③ **档位只收回自己开的**（`F._tierHpOwn` 模式），用户的独立开关绝不碰。

## ★★★ 服务端权威类玩法：客户端只能改自己（2026-10-04，14.0.80 实锤）

- 现象：开加速/飞行（523 格/秒）**拿到蛋 → 回安全区 → 蛋消失**。
- 证据：`[反拉回] 位置被回滚 1248 次`、`[屏蔽] 已挡下服务端对我角色的写入 ×1897`；
  游戏有 `GameShared.EggPickupRules` / `EggBoundary` 模块 + `EggSecured` 远程。
- ⇒ **拿蛋是服务端裁决**：客户端只"预测"了拾取；服务端按位置/速度/边界校验判非法 ⇒ 回滚位置 ⇒
  拾取**从未在服务端成立** ⇒ 客户端那颗蛋被收回 = "消失"。
- ⛔ **拦服务端的回滚/纠正消息没用**（只是本地不同步，且更像作弊）。
  ✅ **有效三步**：① 拿蛋期间把速度压到合法范围（一般 16~50）、关飞行；② 别在 `secured` 前离开判定边界；
  ③ **拿蛋期间不要屏蔽服务端的位置纠正**（让它改回去反而更快一致）。
- ★ 泛化：**服务端权威的判定（伤害/击杀/拾取/占领）客户端改不了**（同 14.0.13 血量结论）。
  写"拦截型"功能前先问：**这条消息是"请求"还是"裁决结果"？** 裁决结果拦了只会骗自己。

## ★★★ 档位体系（v16.9.27 重整，2026-10-06）

**三层结构**：用户只看到 `ACMaster`（① 轻 / ② 中 / ③ 重）；
内部 `ACWriteTier`（元表钩+监视+断连接+深度中和）与 `BypassTier`（防护+速度守卫+伪装+防拉回）由它触发。

### ⛔⛔ 铁律 1：`F.HookFuse`（熔断）**只能在整个档位流程的最开头调一次**
- `F.HookFuse` 会**卸掉所有钩子**（含 `MetaLayers` 全部、namecall/index/setmetatable、反封禁4层、深度中和…），
  中途有 `task.wait(0.35)`（会 yield），**`_fusing` 直到函数末尾才清**。
- v16.9.27 前的真缺陷：`F.BypassTierApply` 内部**又调了一次** ⇒ 档位③ 触发第二次熔断，
  把刚装好的「属性读伪装 / 元表钩 / 新脚本新远程监视 / 反封禁4层」**全卸掉且不重建**
  ⇒ **最高档比中档弱**，而文案写着"元表钩全装+拦上报"。
  同一条路还让 **`F.BypassAutoRaise`（开飞行/加速自动升档）每次都熔断一次**。
- ⇒ 凡是"纯标志+启停"的切换器（子项都有幂等守卫）**一律不许熔断**。

### ⛔⛔ 铁律 2：熔断会卸掉**用户自己开的**层 ⇒ 之后必须按标志恢复
- `HookFuse` 第 1 步 `MetaUninstall` 全部 `MetaLayers`（含手动开的血量隔离 `CMHealthLock`）。
- ⇒ 档位流程结束后要检查 `if T.HealthIsolate and not F.MetaActive("game.__index","CMHealthLock") then 重装`。
  否则用户手动开的功能会被"静默卸掉但开关仍显示开"。

### ⛔ 铁律 3：档位文案**不许吹不存在的能力**
- 内部档位字符串曾写 "自产登记+栈伪装+身份+FFlag"，而这些能力 **v16.9.18 就被删了（grep=0）**。
- 档位解析靠字符串里的 **①②③④ 标记** ⇒ 改文案必须保留标记；且**低档文案里不许出现更高档的标记**
  （否则 `lvl` 判定会被抬高）。

### 覆盖矩阵工具：`_audit_tiers.py`
逐能力算"在哪个档位会被打开"（含传递闭包）+ 检查 `T1 ⊆ T2 ⊆ T3`。
⛔ **再跑它报「护蛋/搬运/防减速/稳身/受击/陷阱/防拉回 开不到」时属误报，不要"补回档位"** —— 见下面 2026-10-09 的归属定稿。

### 当前档位内容（2026-10-09 v17.0.31 定稿）
| 档 | 内容 |
|---|---|
| ① 轻 | 反甩 + 护界面 + 权限守卫 + 角色持续 + 属性读伪装(含 gcinfo) |
| ② 中 | ① + namecall 元表钩 + 反封禁4层(拦上报/断日志/按名中和+/哈希冻结) + 锁字段 + 防暂停 + **服务端下发预警** + **游戏专用绕过**（v17.0.26 起由档②③自动代开，带 `_tierGbypOwn` 所有权标记） |
| ③ 重 | ② + 元表钩全装(__index/setmetatable) + 新脚本新远程监视 + 断可疑连接 + 深度中和 + **假上报** ⇒ 最激进 |

★★★ **「完整防护」不归任何档位**（2026-10-09 用户定，修法 A）：
「完整防护」= 稳身·反攻击(受击)·反陷阱·防拉回·防减速(速度自由)·反回拉·护蛋·搬运 **共 8 项**，
它们**唯一的入口是移动页「防护」开关**（控件 id `GuardAll`，一个开关管全 8 项，回调里设
`T.SteadyOn/HitGuard/TrapWarn/SpeedAntiTP/MyEgg/CarryGuard` + `F.ProtectApply()` + SpeedFree/NoPull 的 Enable）。
- **档位③ 曾经只代开其中 3 项**（MyEgg/CarryGuard/SpeedFree）却写 `T.GuardAll = true` ⇒ 移动页那个开关被显示成"开"，
  实际 4 项没跑（"看着开了、功能不全"）；档位文案还写着"完整防护(稳身/受击/陷阱/防减速/护蛋/搬运)" ⇒ 文案≠实现。
- v17.0.31 已删掉档位③ 里那几行 + `_tierGuardOwn` 收回逻辑 + 文案里的"完整防护(…)"。
- ★ 注意 `T.GuardAll` 只被**动态读**（它是控件 id，`CfgSyncUI` 按 `T[控件名]` 同步界面），静态 `T.GuardAll` 只有 1 处写 ⇒ 属正常，别当幽灵状态删。
- 回归测试 `.workbuddy/build/_gen_tierdecouple_sim.py`（真 luau 18 项）锁死：③档/关档都不得再碰这 8 个标志。
- ★ 通用规律：**一个概念只能有一个所有者**；真要两个入口，必须调**同一个** Apply 函数，不许各写一半。

## ★★★ 出站 vs 下行：反作弊必须**两侧都看**（v16.9.30）

- 我们原有反作弊**全在出站侧**（拦我们发出去的 / 把它改成正常值）。
  `OnClientEvent` 的 4 处用法**全是 `getconnections(re.OnClientEvent)` 取连接去 Disable** —— **从不监听**
  ⇒ **完全不知道服务端什么时候在判你**。语料 33 份会监听下行，我们是 0。
- v16.9.30 补：`F.CMX_InboundWatchSet(on)` —— 只给**名字命中 `F.CMX_BAN_KEYS`** 的 remote 挂**只读**监听，
  收到下发只做「计数 + 限频 4 秒日志」：`[服务端预警] 服务端下发了「X」(N 个参数)`。
  **绝不改调用**（不像拦截那样 `return nil`）⇒ 不可能因此被判异常。
- 生命周期：档位**②/③** 自动开；①/关 自动断；**熔断**里也复位（`HookFuse` 的 steps 里加了 `F.CMX_InboundWatchSet(false)`）。
- 设计要点：**不做全库监听**（几百条连接），只挂"危险命名"的那几个；`ReplicatedStorage.DescendantAdded` 补挂新增的。

## ★★ 事件审计的一个大坑：**语料高覆盖的事件可能不是游戏能力**（v16.9.30）

- `Activated` 语料 **113 份**（最高），但实测 **84 次是 `DropDownButton.Activated`**，其余是
  `Close`/`Continue`/`Toggle`/`OpenButton` —— **公开脚本自带 UI 框架的内部接线**，不是我们缺。
- 同理 `MouseButton1Down`(58) / `MouseEnter`(22) / `MouseLeave`(23) / `Button1Down`(6) 全是 UI 元素。
  ⇒ **判"缺事件"之前必须 grep 出挂载行（接收者是谁）**，只看计数会误判。
- 其它"疑似缺失但实为等价"的：`Changed`(45) → 我们用 `GetPropertyChangedSignal`；
  `Destroying`(17)/`AncestryChanged`(10)/`CharacterRemoving`(11) → 我们用显式 Disconnect + 关闭链；
  `Touched`(11) → 我们走 `CanTouch=false`（根本不触发）；`CurrentCamera` 属性信号 → 我们每帧现取。
- 游戏专属事件（不适用）：`EntityAdded/Removed`、`entityAddedEvent/entityRemovedEvent`、`LocalAdded`。
- **仍未做**：`Chatted`(15)、`PostSimulation`(5)、`OnTeleport`(6)、`Completed`(13)/`Stopped`(7)、`KeyDown`(=按键绑定)。

## 方法级横向对比的**固定结论**（2026-10-06 v16.9.29 全量复核，75 种手法 × 103 份语料）

工具：`_corpus_gap.py`。**"我们是否有"那列必须 grep 复核**（正则过宽/过窄都会误判）。

- **等效已有（不算缺口）**：`TweenService` 平滑传送(47.6%) → 我们自研逐帧 lerp 且**能中途打断**；
  `Drawing` API(20.4%) → 我们用 BillboardGui+Highlight+GUI 圆环；玩家列表面板 → 我们用下拉选人。
- **用户点名删除过、绝不许加回**（grep 必须保持 0）：ESP 骨骼(22.3%)/追踪线(14.6%)/方框(9.7%)/Chams(7.8%)、
  身份FFlag伪装(11.7%)、配置存档(8.7%)、栈伪装(11.7%)。
- **我们领先公开脚本**（语料 0% 或极低）：**假上报**、**反暂停**、**熔断+残留体检+复检**、
  反 RemoteSpy 蜜罐自检、哈希冻结、脚本自动更新（热加载+远端自检）、本地 LLM 翻译三层。
- **真缺（未删、语料≥5%，需用户点头才做）**：按键绑定(9.7%)、TriggerBot(12.6%)、自动换弹(12.6%)、
  自动种植/农场循环(14.6%)、无后坐力(8.7%)、自动购买升级(8.7%)、水印(3.9%)。

## ★★★ 假上报（v16.9.28 新增，只在档位③）

**动机**：原来 4 个拦截点命中就 `return nil`（**丢弃**）⇒ 服务端会发现"该上报的突然不上报了"，
**这本身就是一个异常信号**。改成"改值后真发出去"更接近"一切正常"。

**实现**：`F.CMX_FakeArgs(...)` 把参数净化后，调用 `box.orig(...)` **真发**：
- `number` 且 `|v| > 120` 或 `NaN` → **改成 16**（正常速度量级）
- 字符串 / 对象 / 布尔 / nil → **原样**（不动枚举与结构，避免服务端解析错乱）

**覆盖 4 个拦截点**：① `AC` namecall 的 `T.RemoteBlock` ② `AC` namecall 的 `T.HpBlock`
③ `KickGuard` 的 `F.BLOCK_REMOTE_KEYS` ④ `KickGuard` 的 `SpeedGuard` 关键词
（Integrity/Correction/Violation/anticheat/honeypot）。

**⛔ 三条安全铁律**：
1. **namecall 钩子体没有 pcall 保护** ⇒ 钩子里调的任何 helper 出错都会**直接抛给游戏调用方**
   ⇒ helper 必须**整体 pcall**，异常一律返回 nil（退回"丢弃"）。
2. **不要依赖 `table.pack`**（少数执行器没有）⇒ 用 `select("#", ...)` + `{ ... }`，并补 `args.n = n`
   （否则 `table.unpack(args, 1, args.n)` 拿不到尾部 nil 参数）。
3. ⛔ **`...` 不能出现在嵌套函数里**（Luau 直接编译报错）⇒ 变长参数必须在**外层函数**捕获后再闭包使用。

**开关**：`T.CMX_FakeReport`，只在档位③ 置 true；`ProtectTierApply` 顶部统一复位；
`HookFuse` 卸载清单里也复位（熔断后无残留）；急停遍历 `T` 全清自然覆盖。

## ★★★ 隐身的**作用域**（v16.9.28 修）

`Humanoid` 三个显示属性，**作用域全在自己身上**（写在自己的 humanoid 上）：

| 属性 | 含义 | 处置 |
|---|---|---|
| `DisplayDistanceType` | 整套"名字/血条是否显示"的模式（Viewer/Subject/None） | ❌ **已删除写入**（最激进、最像透明特征、最容易在游戏自定义名牌系统里引发连锁副作用） |
| `NameDisplayDistance` | 本角色名字显示距离 | ✅ 设 0（`Viewer` 下距离 0 = 看不到，效果等价） |
| `HealthDisplayDistance` | 本角色血条显示距离 | ✅ 设 0 |

**用户反馈"隐身会隐藏别人名字"的核查结论**：**代码里没有任何一处**在隐身时改其他玩家的属性
（`DisplayDistanceType/NameDisplayDistance` 的写入只在 LocalPlayer 的 humanoid；ESP 名字用**自建 BillboardGui**，
不引用 Transparency/Invisible）。最可能的原因是**重载脚本后「ESP 总开关」回到默认关**
（配置存档已按用户要求删除，开关不再记忆）⇒ 已在隐身日志里加了这句提示。

**隐身补强**：透明度遍历扩到 `Texture`；并关掉自己身上会暴露位置的特效
（`BillboardGui`/`Highlight`/`SelectionBox`/`ParticleEmitter`/`Trail`/`Beam`，存原 `Enabled` 逐项还原）；
`CharacterAdded` 与 `DescendantAdded` 两条路径都覆盖。
## ★★★ 出站改写三件套：拦上报 / 位置伪造 / 游戏专用绕过（2026-10-09 v16.10.99）

三者**共用同一个 `__namecall` 钩子**（`AC.InstallNamecallHook`），都只处理
`FireServer / InvokeServer` 且 `not checkcaller()` 的**出站**调用。要新增一条出站逻辑，就加一个分支，
**不要再装第二个 `__namecall` 钩子**（多层叠加是本项目历史上掉帧的主因）；同时把标志加进
`AC.UninstallNamecallHook` 的守卫（`if T.HpBlock or T.RemoteBlock or T.SpoofPos or T.GameBypass then return false end`），
否则关不掉钩子。

1. **拦上报**（已有 `T.RemoteBlock` / `T.HpBlock`）：命中关键词 ⇒ **丢弃**（`return nil`）或改成"正常值"再发。
2. **位置上报伪造**（新 `T.SpoofPos`）：命中位置类远程 ⇒ **改写 Vector3/CFrame 参数**为假位置后**照常发出**（不丢弃）。
   - 判据：`F.POS_KEYS` 名字命中 + 参数里**确实有坐标类型**（没有就不改，返回 nil）。
   - 假位置 = 开启时的坐标 + 「抬高」滑块；提供「重设伪造点」按钮。
   - ⚠ 风险已写进日志与文档：**只改客户端上报的坐标**；服务端权威移动的游戏可能把你拉回原地。
3. **游戏专用绕过**（新 `T.GameBypass`）：**只拦「检测 / 上报类」远程**，
   ⛔ **不碰 kill/hit/damage 类**（那是"拦受伤上报"的职责，混在一起会打坏自己的攻击/交互判定）；
   先过 `F.GBYP_SAFE` 白名单（interact/door/open/pick/use/quest/... /respawn/checkpoint）⇒ 命中白名单直接放行。
   - "游戏专用"的实现方式 = **现场扫描**（`F.GameBypassScan`：`F.walk` 扫 ReplicatedStorage + workspace，
     按名字挑出 RemoteEvent/RemoteFunction）⇒ 每个游戏扫到的都是它自己的目标，不写死任何游戏名。
   - 目标名会打进日志（最多列 12 个），用户可核；另有「扫描本服绕过目标」按钮单独查看。

**放进档位（用户明确要求）**：`F.ProtectTierApply` 在 **②/③** 自动 `F.GameBypassSet(true)`，
用 `F._tierGbypOwn` 标记"这次是档位开的"；档位调回「关」时**只收回档位自己开的那次**，
用户手动开的保持不动（与本项目既有的 `_tierHpOwn` / `_tierGuardOwn` 约定一致）。

## ★★ 「位置上报伪造」的真实语义 + 已并入档位 ②/③（2026-10-09 v17.0.6）

- **它既不是加速也不是免攻击**（用户问过）：只拦**名字命中位置类关键词**的 `FireServer/InvokeServer`
  （`F.POS_KEYS`：motorreplication/position/posupdate/setpos/cframe/moveupdate…），
  把参数里的 `Vector3/CFrame` 换成"开启那一刻的自身位置"。⛔ 不碰 WalkSpeed，⛔ 不碰 Health/伤害判定。
- **能否生效取决于游戏是否信客户端上报**：服务端权威移动的游戏 ⇒ 会被**拉回/抽搐/变卡**（日志已写明"那就调到①"）。
- 用户决定：**删掉三个独立控件**（开关 / 抬高滑块 / 重设伪造点），改为档位 **②/③ 自动带上**（抬高固定 0）。
- 归属：`F._tierSpoofOwn`；★ **收回条件是 `lvl < 2`**（不是 `lvl == 0`）—— ① 的文案是"只读不改"，
  降到①必须把钩子收掉。★ 这条比 `_tierHpOwn/_tierGbypOwn` 的写法更正确（那两个只在"关"收，
  是本仓**已知**的"降档收不干净"老缺陷，见审计报告，等用户点头再统一修）。
- ★ 配套：删掉「重设伪造点」按钮后，原来"进游戏后补点"的手动步骤没了 ⇒ 必须在
  `F.PosSpoofArgs` 里 `_spoofP == nil` 时**懒补一次**，否则"还没角色就开档位"会让整项静默无效。
  ⛔ 这段跑在 `__namecall` 热路径上，**只许补一次**，不许写重试循环。

## ★★★ 藏"隐藏状态"：**"写"和"读"两条路都要堵**（2026-10-09 v17.0.24 实锤）
飞行/加速天然暴露两处：`Humanoid.PlatformStand == true`、`RootPart.AssemblyLinearVelocity` 远超常速。
原实现只在 `__newindex`（写方向）锁字段，**`__index`（读方向）没伪装** ⇒ 反作弊一读就露馅。
⇒ 定稿（`T.Spoof` 为闸门，即防护档位②以上）：
- `__index`：`PlatformStand` → 恒 `false`；`AssemblyLinearVelocity` 水平 >24 时伪装成 16（垂直限 50）；
- `__namecall`：`Humanoid:GetState()` 的 `Physics`/`PlatformStanding` → `Running`（**必须判 `not checkcaller()`**）。
★ **通用判据**：任何"隐藏状态 / 伪装"需求，先列出它的**全部读取入口**（属性读 / 方法调用 / 事件 / 序列化），逐一堵；
  只堵写方向 = 没堵住。同理适用于位置伪装、血量伪装、无敌标志。

## ★★★ 高亮透视 = **只认「交互证据」与「生物」两类**（2026-10-09 v17.0.41 定版）

- **目标集合只有两个**：`ix`（真交互证据：自身/子级/子级 Model 带 `ProximityPrompt`|`ClickDetector`）与 `npc`（生物）。
  ⛔ **不许再靠物件名字猜**物品/陷阱/掉落/载具（那 4 张词表已删，`F.KeyHit` 已删，分类下拉 6→2）。
- ★★★ **地图被整片染色的两个真凶**（都实测复现）：
  1. `F.IsNPC` 曾用 `FindFirstChildWhichIsA("Humanoid", true)` **递归整棵子树** + `HLKind` 对 Model 传 `deep=true`
     ⇒ 地图 Model 里只要任何角落有 Humanoid/AnimationController，**整块地图**被判成生物。
     ⇒ 已**删除递归**，只认"自身/直接子级"。
  2. 名字分支裸匹配 + 词表混入地图高频词（`npc/enemy/boss/hunter/walker/bird/animal/knight/mannequin/sentry/...`）
     ⇒ `BossArena`/`EnemyBase`/`NPCBoard` 全中。⇒ 词表只留强生物词 + **加布景反门禁**（`F.NPC_BLOCK2`）与**尺寸门禁** `F.NpcBig`（>60 = 地图结构）。
- ★★ **匹配方式定论：用「包含匹配」，不要边界匹配**。实测 `BossArena` 的 `arena`、`EnemySpawner` 的 `spawn`、
  `ZombieKing` 的 `zombie` 在左右边界规则下**全部漏检**（地图排除失效 / 复合名怪漏标）。
  正确组合 = **包含匹配 + 强词表 + 布景反门禁**。⛔ 别再"顺手加边界"。
- 回归：`_gen_hlonly_sim.py`（29 用例，地图不标/真生物认得/复合名不漏/分类开关有效）——改这块**必须**先跑它。

## ⛔ 高亮透视的性能真凶：**不准用几何查询"附近扫一遍"**（2026-10-09 v17.0.44）
「范围模式」原来每次刷新都调 `workspace:GetPartBoundsInRadius(center, 300, params)` —— 一次拿回**最多 3000 个零件**，
再对**每一个**做 Lua 层 `HLKind` 判定；且触发条件是「移动 ≥12 格立刻重扫」（**无最短时间下限**）⇒ 跑动时每 0.4~0.75 秒一轮 ⇒ 极卡。
「全图模式」走 `F.IxFullSweep`（按 `ClassName` 浅过滤，判定次数少两个数量级）⇒ 不卡。
⇒ **判据：卡的不是高亮数量**（日志里全图标 616 个也照样不卡），而是**每轮对 3000 个零件的 Lua 判定**。
⇒ 定论：**候选对象先"建一次缓存"，之后只遍历缓存**。落地 `F.IxCandBuild` / `F.IxCandAdd`：
  缓存只收 `ProximityPrompt` / `ClickDetector` / 生物 `Model`（量级几十项）；`F.IxFullSweep(center, offer, maxDist)`
  两种模式共用，范围模式传 `F.IxRange()` 做距离过滤；新增物件由 `DescendantAdded` 增量补入；每 30 秒重建兜底。
⛔ 两条顺带修的**假数据/漏标**：① `IxFullSweep` 的返回值（交互点+NPC 总数）曾被当作"NPC 数"，日志出现
  `全图 616 个(其中 NPC/生物 624 个)`（NPC 数 > 总数）；② 即时补标的距离判断无条件用 `F.IxRange()`，
  导致**全图模式下新增的远处物件被漏标**。⇒ 凡"编号/计数"类日志，先自检 `子集 ≤ 全集`。
- 回归：`_gen_ixcand_sim.py`（15 用例，含源码级断言"几何查询必须消失"；A/B 旧源码必须失败）。

## ⛔ Roblox **属性名大小写敏感** ⇒ "功能开着却不动作"的隐藏杀手（2026-10-09 v17.0.44）
`tm:GetAttribute("durability")` **读不到** `Durability`。无限道具原来按全小写词表逐个精确查找 ⇒
用户工具明明有 `Durability=10`，却报"未找到次数属性" ⇒ 循环里 `num == nil` ⇒ 只 warn 一次后**静默不动作**
（用户表述 = "无限道具没生效"）。
⇒ 定论：凡"按名字找属性"，**先 `GetAttributes()` 拉全表、小写化后比对**（按词表顺序保优先级），
  保留原精确查找兜底；**返回时必须回传真实属性名**（`Durability`），因为后续 `GetAttribute` 要用它。
⇒ 同类风险同样适用于 `FindFirstChildByName` 类按名查找（大小写、下划线/空格差异）。
- 回归：`_gen_infitem_sim.py`（25 用例，含"首字母大写""全大写""无关数值属性不得误用""多命中按词表优先级"）。
