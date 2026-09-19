# MachineParty（机器派对）—— Remote / 信号清单（2026-09-19 抓包）

> 游戏：`[UPD2] 机器派对 💥`
> PlaceId **127775478639865** · GameId 10635348596 · CreatorId 35175010
> JobId `9e31ae6a-4c66-4577-a25d-fde9c0e0bd4e`
> 抓包时间：2026-09-19 21:13:59（执行器「🔍 综合扫描」）
> ⚠ **抓包地点 = 大厅**（`Workspace.Lobby.MPStation_*`，本机 `MPRoomCell=1`）→ 小游戏里的物件不在这次快照里。
> 原始清单：`2026-09-19_MachineParty_原始抓包.txt`（执行器自动落盘 `Remotes_[UPD2]_机器派对_💥__127775478639865_20260919_2113.txt`）

## 规模（★ 对比对战服那份：这个游戏几乎没有 Remote）

| 类型 | 数量 |
|---|---|
| RemoteEvent | **3** |
| RemoteFunction | **2** |
| BindableEvent | 6 |
| BindableFunction | 50 |
| ProximityPrompt | 7 |
| ClickDetector | 186 |
| 函数 / 表（GC 扫描） | 7253 / 4439 |
| 脚本 / 模块 | 184（`getrunningscripts` 75）/ 已加载模块 72 |
| 实例 | Workspace 子对象 20001+ · 角色模型 60 · **Highlight 88** |

---

## ★★★ 最重要的结论：这游戏只有 5 条真网络通道

```
ReplicatedStorage.MachineParty.Event                        (RemoteEvent)  ← 唯一总通道
ReplicatedStorage.MP_Customization.Remotes.SaveLoadout      (RemoteEvent)
Workspace.duck hunt.Sniper.Shoot                            (RemoteEvent)  ← 小游戏里的枪
ReplicatedStorage.MP_Customization.Remotes.FetchAccessory   (RemoteFunction)
ReplicatedStorage.MP_Customization.Remotes.GetLoadout       (RemoteFunction)
```

**含义（会改变以后的做法）：**

1. 玩法动作**全部挤在 `MachineParty.Event` 一条上**（省带宽的常见做法），靠**参数**区分动作。
   → 要做任何"客户端触发服务端"的功能，**第一步必须是 hook `MachineParty.Event` 看参数结构**
   （菜单里的「④ 按名字包一层」就是干这个的，只记录不改返回值）。
2. `SYS.RemoteAlias` / `SYS.RemoteKeywords` 那套**跨游戏查找表在这个游戏里没用** ——
   这里没有独立的 `Heal` / `Revive` / `Claim` / `Purchase` 名字可匹配。
   「🔎 探测本游戏有哪些」在这游戏大概率全是"本游戏没有"，那不是坏了，是真没有。
3. 事件库别的清单（MM2 类的 277 个、对战服的 438 个）**对这个游戏完全没有参考价值**，别混用。

---

## 本地专有信号（`Bindable*` = 只在本地传播，触发**不经过服务端**）

| 信号 | 能干什么 |
|---|---|
| `ReplicatedStorage.MachineParty.Signals.OpenStore` | 本地直接弹出商店界面（不扣钱、服务端不知道） |
| `ReplicatedStorage.MP_Customization.Signals.OpenCustomization` | 本地打开外观自定义面板 |
| `ReplicatedStorage.MP_Customization.Signals.CloseCustomization` | 本地关闭自定义面板 |
| `ReplicatedStorage.MP_Customization.Signals.ReapplyLoadout` | 本地重新套用外观/装备（刷新表现） |
| `ReplicatedStorage.MachineParty.Signals.EmotesChanged` | 表情列表变更通知 |
| `CoreGui.RobloxGui.SendNotificationInfo` | 本地推一条 Roblox 通知 |
| `*.Animate.PlayEmote` ×50 | 每个 rig / 皮肤一个**本地播表情**入口 |

→ 这批**零风险**（纯客户端 UI / 表现层），但**不含任何资源、奖励、货币**。
→ `PlayEmote` 有 50 个（`Workspace.skins.*`、`Workspace.<玩家名>.Animate`），想播表情找任意一个都行。

---

## 交互点（全在大厅，没有任何战斗交互）

ProximityPrompt 7 + ClickDetector 186，其中 **180 个是 `MPBuy_LimitedDrop`**
—— 限量箱/展示台把同一个探测器**挂在每个部件上**，一个台子就是几十条（`MannequinYou` 的每条肢体一个）。

| 区域 | 路径 | 作用 |
|---|---|---|
| 车站 | `Lobby.MPStation_Customize.Board.MPStation_Customize` | 外观自定义 |
| 车站 | `Lobby.MPStation_Settings.Board.MPStation_Settings` | 设置 |
| 车站 | `Lobby.MPStation_Support.Board.MPStation_Support` | 支持/赞助 |
| 商店 | `Lobby.ShopWorker.Torso.MPStation_Shop` | 商店（NPC 身上的 prompt） |
| 购买台 | `MPPadHost_LimitedDrop.MPBuy_LimitedDropPad` / `MPPadHost_Vault100.MPBuy_LimitedDropPad` | 限量箱购买 |
| 活动 | `Lobby.MPStation_Event.{Board,Body,Glow,Metal,Plinth}.MPEvent_Join` | **加入活动** |
| 群组 | `probs.Leaderboard_Group.Screen.JoinGroupPrompt` | 加入社群 |
| 展示台 | `Lobby.MPStation_LimitedDrop.*` / `Lobby.MPStation_Vault100.*`（`.MPBuy_LimitedDrop`） | 限量外观展示 + 购买 |

### ★ 全场唯一的"门"（两条，结构完全一样）

```
Workspace.Firearm Factory.Model.Power Box.Door.Handle.ClickDetector
Workspace.Lobby.Model.Power Box.Door.Handle.ClickDetector
```

结构 = `<区域>.Model.Power Box.Door.Handle` + `ClickDetector`
→ **门 = 名叫 `Door` 的 Model；本体是它里面的 `Handle` 部件；靠 ClickDetector 点击打开。**
→ 6.9.32 门透视的判据（名字含 `door` + 祖先 3 层 + 结构）**已经覆盖这个形态**。

---

## ★ 数据层：`MP*` Attribute —— 这才是这个游戏的权威数据

### 本机玩家 `kiana812i`（23 个）

| Attribute | 值 | 说明 |
|---|---|---|
| `MPGhost` | **true** | ⚠ 见下方结论 1 |
| `MPInMenu` | false | 是否在菜单里 |
| `MPScrap` | 3293 | 废料（= leaderstats.Salvage） |
| `MPTier` / `MPRankTier` | SPECIMEN | 段位 |
| `MPRating` | 992 | 评分 |
| `MPRoomCell` | **1** | **房间/格子号**（= 大厅） |
| `MPPlate` | STANDARD | 牌面 |
| `MPSet` | false | |
| `MPSeason` | 24321 | 赛季（时间戳样式） |
| `MPSeasonWins` / `MPStreak` | 0 / 0 | |
| `MPRole` | （空） | 对局角色；别人是 `armed` |
| `MPWalkSpeed` / `MPJumpPower` | 0 / 0 | 在大厅 |
| `MPJumpEnabled` | false | |
| `MPHipHeight` | 2 | |
| `MPMusicVolume` / `MPSfxVolume` | 1 / 1 | |
| `MPPoseAnim` | `rbxassetid://104071024667789` | 摆姿势动画 |
| `MPPoseIdleAnim` | （空） | |
| `MPDeadSignalHud` | `12,64,336,132,true` | 死亡信号 HUD 的位置/开关（打包成字符串） |

### 别人（服务端写入，客户端可读）

| 玩家 | 关键 Attribute |
|---|---|
| `folia1220`（18 个） | `MPRole=armed` · `MPScrap=1438` · `MPRating=1041` · `MPWalkSpeed=12` · `MPStreak=1` · `MPWins=1` · `MPSeasonWins=1` |
| `ysf14514`（17 个） | `MPRating=1028` · `MPScrap=1019` · `MPWalkSpeed=12` · `MPWins=0` |

### 角色 Model / leaderstats

```
角色 Model:  MPNormalized = true · MPSkin = ISSUE
leaderstats: Wins = 0 · Salvage = 3293
```

### ★★ 两条硬结论

1. **`MPGhost` 不是"隐身标志"。**
   本机玩家**在大厅就是 `MPGhost = true`**，而另外两个人（`folia1220` / `ysf14514`）**身上根本没有这个属性**。
   → 6.9.31 那套「拿玩家属性名字像 Ghost 就判他隐形」**对别的玩家不成立**；
   真正还能用的只有第 ③ 条**结构判据（角色整体透明）**。别再把 MPGhost 当隐身信号。
2. **血量 / 坐标都不在 Attribute 里。**
   Player 上**没有** `Health` / `MaxHealth` / 位置字段 → 血量只能读角色 `Humanoid`，位置只能读角色 CFrame（老代码本来就这么做的，无需改）。

---

## 代码层：可 hook 的游戏函数（归属明确的）

| 函数 | 归属脚本 | 用途 |
|---|---|---|
| `aimRifle` / `fire` | **MachinePartyDuckHunt** | 打靶小游戏：瞄准 / 开火 |
| `aimFromMouse` / `aimFromStick` / `drawAim` | **MachinePartyRightOfWay** | 抢道小游戏：瞄准 / 画准星 |
| `aimFromMouse` / `aimFromStick` / `faceAim` | **MachinePartyBlindout** | 摸黑小游戏：瞄准 / 转身 |
| `AimHead` / `KillNear` / `PoseKill` / `KillBodyOffset` | **SpiderRig** | 蜘蛛 rig 的索敌+击杀逻辑（唯一带 `kill` 的实质逻辑） |
| `Claim` | **PadBuy** | 购买台领取 |
| `_fireCustomInputs` | **ControlModule** | 输入分发 |

### ⚠⚠ 三个必须知道的坑

1. **"52 个可疑函数"里混着我们自己的脚本函数。**
   名单里的 `HitGate` 就是 **6.9.29 刚删掉的命中率闸门**（我们自己的）→ 说明 GC 扫描会把**执行器注入的脚本**一起扫进来，
   「归属脚本」列显示 `-` 就是拿不到归属。
   所以 `AutoClaimTick` / `SetAutoClaim` / `SetAutoHitMinigame` / `ClaimAllDaily` / `ClaimEverything` /
   `AutoHitScan` / `AutoHitTick` / `SpinHit` / `WalkHit` / `HideHit` / `FlyHit` / `SetNoDeath` / `fireTick` / `aimTick`
   这些名字**不能直接当成游戏函数**，要用「④ 按名字包一层」或实际调用一次验证再说。
2. `Net.Fire` / `FireLocal` / `FireUnreliable` 是 **Roblox 引擎网络层**，不是游戏的，**别 hook**。
3. hook 的前提是**函数在客户端存在**（脚本层能拿到）；只服务端跑的逻辑，客户端 GC 里看不到。

---

## 脚本层：小游戏命名实证（抓小游戏的钥匙）

**已加载脚本（本次只列了前 40 / 184，不是全集）**

```
MachinePartyDuckHunt            MachinePartyRightOfWay(+Prototype)   MachinePartyBlindout
MachinePartyMinefieldScenery    MachinePartyDeadSignal               MachinePartyDeadOnTime
MachinePartyPadFocus            MachinePartyCamera                   MachinePartyActions
MachinePartySupport             MachinePartyStationSigns             MachinePartyLimitedStand
MachinePartyWorldUI             MachinePartyCharacterSounds          MachinePartyLocomotion
MachinePartyMusic               MachinePartyAmbience
```

**已加载模块**

```
ReplicatedStorage.MachineParty.Config / Rank / QuestCatalog / BumperMadness
ReplicatedStorage.MachineParty.UI.SeeThrough / RosterIcon / PadBuy
```

★ `MachineParty.UI.SeeThrough` —— **游戏自己有一个叫"透视"的 UI 模块**。
值得单独研究（可能是官方的透墙/高亮效果）；这也解释了 `Workspace` 里那 **88 个 Highlight 不一定全是我们的**。

★ `getrunningscripts` 给了 **75 个正在运行的脚本**（比 `getscripts` 准，含动态加载）→
以后想自动发现"当前在跑哪个小游戏"，读它比猜名字靠谱。

---

## 环境层（能力边界 —— 这次有实证）

- `identity = 8`；`getgenv()` 275 键 / `getrenv()` 2 键 / `getreg()` 9774 键
- **没有 `getconnections`、没有 `getnilinstances`**（扫描器自己写了"这台执行器没有"）
  → **无法枚举 Touched / Heartbeat 连接**
  → **"碰到这个门会不会掉血"在客户端就是看不出来**（服务端结算）。
    之前说的这条边界，这次是实证 —— 门/陷阱透视只能"按名字+形状给提示，会有误报"。
- 设备：触屏 = false，键盘 / 鼠标 = true

---

## 可做功能映射（结论）

| 功能 | 能不能 | 依据 |
|---|---|---|
| 本地开商店 / 开自定义面板 / 重套外观 | ✅ 能（零风险，纯本地） | `MachineParty.Signals.OpenStore`、`MP_Customization.Signals.*` |
| 本地播任意表情 | ✅ 能 | 50 个 `*.Animate.PlayEmote`（BindableFunction） |
| 小游戏里开枪 / 精准瞄准 | ✅ 能 | `MachinePartyDuckHunt.fire`、`duck hunt.Sniper.Shoot` |
| 透视玩家 (ESP) | ✅ 能（这游戏最实用的一类） | 角色 Humanoid + 结构判据（血量不在 Attribute 里） |
| 透视门 / 陷阱 / 假门 | ⚠ 只覆盖"名字+形状" | 见上"唯一的门"；小游戏里的假门**需要在小游戏里再抓一次** |
| 穿门预警（碰了会不会死） | ❌ 做不到 | 没有 `getconnections`，Touched 逻辑看不见 |
| 0 元买限量箱 / 改 Salvage（3293） | ❌ 不行 | 5 条 remote 里**没有购买通道**；购买走 ClickDetector → 服务端校验 |
| 一键领每日 / 全领 | ❓ 待验证 | 名字像的 `ClaimAllDaily` / `ClaimEverything` 归属不明（疑似自家函数） |
| 用 `SYS.RemoteAlias` 自动认这个游戏 | ❌ 无效 | 没有独立命名的 `Heal`/`Claim`/`Purchase` remote |

---

## 🚪 门 / 假门 / 安全门 专项（这次抓包能回答到哪）

**这次抓包在大厅做的**，全场唯一的门就是上面那两条 `Power Box.Door.Handle`。
**安全门 / 假门只在小游戏里出现** → 所以**这份 dump 回答不了"假门叫什么"**。

已知（可用的）门形态：`<区域>.Model.Power Box.Door.Handle` + `ClickDetector`
—— 门是 **名叫 `Door` 的 Model**，本体是里面的 **`Handle` 部件**。
6.9.32 的判据（名字含 `door` + 祖先 3 层 + 竖直薄板兜底）已经覆盖这种结构。

**下一步（必须在小游戏里做，二选一）：**

① 开「🚪 门/陷阱/假门 透视」，看控制台这行，把 `N` 和名字样本发我：
```
[ESP] 门/陷阱/假门透视: 找到 N 个候选。名字样本: ...
```

② 或者直接在小游戏里跑这段（打印 300 格内所有部件名，按距离排序）：
```lua
local c=workspace.CurrentCamera.CFrame.Position local t={}
for _,o in ipairs(workspace:GetDescendants()) do
  if o:IsA("BasePart") then local d=(o.Position-c).Magnitude
    if d<300 then t[#t+1]=string.format("%4.0f  %s  [%s]",d,o.Name,o.ClassName) end end end
table.sort(t) print(table.concat(t,"\n")) print("共 "..#t.." 个")
```
拿到真名我就能按名字精准加判据（形状兜底只是"猜"，名字才是"准"）。

---

## 归档说明

- 归档时间：2026-09-19 21:30 左右
- 归档动作：从执行器 workspace（`%LOCALAPPDATA%\Real\workspace\`）把自动落盘的原始清单拷进 `事件库/`
  （执行器写的文件名是 UTF-8 名字被按 GBK 显示成乱码，内容本身是正常 UTF-8）
- ★ **这个游戏下次抓包请在小游戏里做**（或至少补一次小游戏内的快照），才能覆盖陷阱/门/小游戏物件。
