# Kick a Lucky Block（踢幸运方块）· 事件 / Remote 清单

> 抓取日期：**2026-09-20**
> 游戏：**Kick a Lucky Block** · **PlaceId `89469502395769`**
> 来源：用户提供的 PuckAFK Hub 客户端脚本（本地 `1.txt`，Release **v4.6.4**）。
> ★ 本文所有 remote 名与形态都是**从源码里逐条抽出来**的（不是猜的），
>   抽取方式见本仓 `.workbuddy/build/` 里的生成脚本；共 37 个 remote。

---

## ⛔ 一、网络层结构（**最关键的一条**）

这个游戏**没有**把 remote 平铺在 `ReplicatedStorage` 下，而是走一个**统一网络包**：

```
ReplicatedStorage
└── Shared
    └── Packages
        └── Network          ← ★ 所有 remote 都是它的【直接子级】
            ├── rev_<名字>    ← RemoteEvent   （服务端→客户端 / 客户端→服务端）
            └── ref_<名字>    ← RemoteFunction（客户端 InvokeServer）
```

⇒ **找 remote 的正确姿势**：
```lua
local net = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
    :WaitForChild("Packages"):WaitForChild("Network")
local ev = net:FindFirstChild("rev_KickEventEnded")     -- RemoteEvent
local rf = net:FindFirstChild("ref_B_Sell")             -- RemoteFunction
```

⚠ 别在 `ReplicatedStorage` 顶层直接搜 `KickEventEnded` —— **搜不到**（有条带前缀的包一层）。
⚠ `rev_` / `ref_` 是包生成的**前缀命名**，所以"按名字模糊搜"时要带上前缀，或者遍历该容器再剥前缀。

---

## 二、Remote 清单（37 个）

| remote 名 | 形态 | 方向 | 用途 / 参数 |
|---|---|---|---|
| `AnimData` | rev_ | 收 | 服务端下发 已拥有风格表(owned) + 当前风格(equipped) |
| `B_Collect` | rev_ | 发 | 收集踢击奖励（无参） |
| `B_Sell` | **ref_** / rev_ | 发调用 | ★ 卖掉**手持**脑红。**优先 RemoteFunction(ref_)**，另有 RemoteEvent(rev_) 兜底 |
| `B_Upgrade` | rev_ | 发 | 升级脑红（本脚本用它做「自动升级」） |
| `BattlePassAttemptBonusClaim` | **ref_** | 调用 | 领取战令额外奖励 |
| `BattlePassAttemptClaim` | **ref_** | 调用 | 领取战令奖励 |
| `BattlePassDataSend` | rev_ | 收 | 服务端下发战令状态表 |
| `CheckFree` | rev_ | 收发 | 服务端问「免费物品领了吗」；客户端回发 ClaimFree |
| `ClaimFree` | rev_ | 发 | 客户端请求领取免费商店物品（无参） |
| `Collected` | rev_ | 收 | 服务端下发已收集载荷(payload) |
| `GroupClaim` | rev_ | 发 | 领取群组 / 收藏礼包 |
| `KickData` | rev_ | 收 | 服务端下发踢击 等级(level) / 精通(mastery)；两个 number |
| `KickEventEnded` | rev_ | 收 | ★ 服务端通知本轮结束(success 布尔)；客户端据此复位 |
| `LB_OpenRequest` | rev_ | 发 | 请求开幸运方块 |
| `MailClaim` | rev_ | 发 | 领取邮箱奖励 |
| `Offline_Claim` | rev_ | 发 | 领取离线收益 |
| `RebirthRequest` | rev_ | 发 | 请求重生 |
| `RebirthUpdate` | rev_ | 收 | 服务端下发 重生等级(number) |
| `RequestSpin` | rev_ | 发 | 请求转盘 |
| `SPEED_UPDATE` | rev_ | 收 | 服务端下发 移速等级(number) |
| `SPEED_UPGRADE` | rev_ | 发 | 升级移速 |
| `S_Interact` | rev_ | 发 | 场景交互（按钮 / 机关） |
| `Shop_Buy` | rev_ | 发 | 商店购买 |
| `SpinWheel` | rev_ | 收 | 服务端通知转盘开始（客户端自行置忙约 5.25s） |
| `StyleToggle` | rev_ | 发 | 切换踢击风格 |
| `TaviMishkal` | rev_ | 收发 | ★ 训练加成弹窗（参数=倍数）；客户端回发**同名** remote 即领取 |
| `UpdateSpins` | rev_ | 收 | 服务端下发 剩余转盘次数(number) |
| `WeightEquip` | rev_ | 发 | 装备配重 |
| `Weight_Update` | rev_ | 收 | 服务端下发 已装备配重(equipped) + 已拥有表(owned) |
| `b2s_Craft` | rev_ | 发 | Back-To-School 合成（学校活动） |
| `bs_updateClient` | rev_ | 收 | 服务端下发 已增加的基础槽位数(number) |
| `bs_upgrade` | rev_ | 发 | 升级基地槽位 |
| `kickPhase2` | rev_ | 收 | ★ 服务端下发本轮奖励(rewards)，同时代表 RUN 阶段开始 |
| `lb_open` | rev_ | 发 | 幸运方块开箱（真正开） |
| `mathUPD` | rev_ | 收发 | 服务端下发数学墙表(key=id→答案)；客户端按 id 逐个提交 |
| `mightyChest` | rev_ | 收发 | 服务端要求本客户端生成钥匙（参数=距离）；客户端回发**同名** remote 领取 |
| `scoreUpdate` | rev_ | 收 | 服务端下发学校分数(number) |

> 统计：**RemoteEvent（`rev_`）35 个 · RemoteFunction（`ref_`）3 个**。
> 「方向」列：**收**=客户端 `OnClientEvent` 监听 · **发**=客户端 `:FireServer()` · **调用**=客户端 `:InvokeServer()`。

### 2.1 三条最容易踩坑的

1. **`TaviMishkal`（训练加成）** —— 服务端先发一个**倍数**给客户端弹窗，客户端再 `FireServer("TaviMishkal")` 领取。
   所以它**既是收也是发**，而且是**同一个名字**。
2. **`B_Sell`（卖手持脑红）** —— 客户端代码里**优先当 RemoteFunction 用**（`ref_B_Sell`），
   找不到才退化成 RemoteEvent（`rev_B_Sell`）。⇒ 想调它必须**两种形态都试**。
3. **`CheckFree` / `ClaimFree` 是两条** —— `CheckFree` 是服务端来问"免费物品领了吗"，
   客户端**不能**拿它去领；领要用 `ClaimFree`。混用会白跑。

---

## 三、权威 Attribute / 结构路径

| 位置 | 名字 | 说明 |
|---|---|---|
| `LocalPlayer` | `TutorialStep` | 新手教程进度（number） |
| `LocalPlayer` | `RoundDebounce` | ★ **踢击冷却**：为真时不要发起踢击 |
| `LocalPlayer` | `KickDebounced` | ★ 同上（另一条冷却标志） |
| `PlayerGui.HUD.Run` | `Visible` | ★ RUN 阶段标志（服务端把奖励抛出来时可见） |
| `PlayerGui.HUD.KickButton` | 存在即可用 | 能看到它说明当前站位允许踢 |
| `PlayerGui.HUD.BottomLeft.CoinsFrame.InsideFrame.CoinLabel` | `.Text` | 金币余额（压缩数字，如 `1.25m`） |
| `PlayerGui.HUD.BottomLeft.KickLevel.TextLabel` | `.Text` | 踢击等级 |
| `PlayerGui.HUD.BottomLeft.KickMastery.InsideFrame.CoinLabel` | `.Text` | 踢击精通 |
| `PlayerGui.Frames.SpeedUpgrades.ScrollingFrame["+1 Speed"].NameLabel` | `.Text` | 移速等级（**值 − 13**） |
| `PlayerGui.Frames.Rebirth.RebirthLevel` | `.Text` | 重生等级 |
| `workspace.Areas.KickReady` | BasePart | ★ 踢击就位触发区（**大范围板**，别当点目标传送） |
| `workspace.Zones.CollectZone` | BasePart | 收集区 |
| `workspace.Entities.<玩家名>` | Model | ★ 跑完之后**抛出来的奖励模型**（子 Model 的名字=奖励名） |
| `workspace.NPCs.<...>` | Model | 商人 **Timmy**（卖脑红的那位） |

★ 数字都是**压缩格式**（`1.25m` / `3.4b` / `1e15`），解析要处理后缀：
`k m b t qa qi sx sp oc no dc`（大小写都能出）。

---

## 四、客户端控制器（走 GC 扫描就能拿到，不需要 require 游戏模块）

| 控制器 | 识别用方法（用方法签名认，**不要**依赖临时状态字段） |
|---|---|
| `KickMinigameUI` | `Start` · `End` · `Cancel` · `FocusOnPerfect` · `Reset`（+ `InMinigame` / `Scale`） |
| `GameHandler` | `Kick` · `UnblockKick` · `BlockKick` · `ResetKick` · `StartGame`（+ `InGame` / `Status`） |

★ 踢击的正确调用顺序（**照游戏自己的 OnInMinigame 走**）：
```
KickMinigameUI:Start()                        -- 开小游戏（会自动 Anchor 角色）
KickMinigameUI:End(<实际 Scale>)              -- 用小游戏【真实的】Scale，别伪造 1.0
GameHandler:Kick(<同一个 Scale>)              -- 结算
```
⚠ 伪造 `Scale=1.0` 服务端会验；要用 `KickMinigameUI.Scale` 的**实时值**。

---

## 五、游戏内置数据表（做功能要用的常量）

### 5.1 稀有度区间（按**踢出距离**判定，不是随机）

| 稀有度 | 距离下限 |
|---|---|
| Common | 0 |
| Rare | 131 |
| Epic | 301 |
| Legendary | 541 |
| Mythic | 816 |
| Godly | 1136 |
| Secret | 1483 |
| Rainbow | 1862 |
| Hacked | 2297 |
| Demon | 2777 |
| Celestial | 3230 |
| Eternal | 3907 |
| Eternal+ | 4926 |
| Abyssal | 6000 |
| Abyssal+ | 7073 |

⇒ **稀有度只看距离**：想要某个稀有度，踢到"该区间刚过一点"就行，不需要踢满。

### 5.2 功率 → 距离（`KICK_MAX_DISTANCE = 8000`）

```lua
-- power <= 80000000      : exp = 0.215
-- power <= 3831966715    : exp = (80000000/power)^0.03 * 0.215
-- 否则                    : exp = (3831966715/power)^(-0.007059) * 0.19143815835186814
-- distance = 60 * power^exp      （最后 clamp 到 0..8000）
```

### 5.3 CPS（收益）公式 —— ★ 这条**经过核实**

```lua
当前CPS = 基础CPS × 词缀倍数 × 1.25^(等级-1)      -- 等级 clamp 1..75
升级花费 = 基础CPS × 词缀倍数 × 1.5^(等级-1)      -- 同上
```
来源标注为游戏内 `EntitiesData.GetMultiplierPerLevel` / `GetCostForUpgrade` 的**原样实现**。
⇒ **参考：CheatMenu 的「等级乘数」默认 1.25 与此一致，不需要改。**

**词缀倍数（24 项）**：Golden 1.5 / Diamond 2 / Plasma 4 / Molten 6 / Radioactive 8 /
Shadow 12 / Electrified 16 / Rainbow 40 / Astral 50 / Infinity 75 / Void 12 / Virus 14 /
Wet 16 / Alien 22 / Bacon 30 / Enchanted 12 / Phantom 35 / Volcanic 35 / Heavenly 36 /
Carnival 37 / Block Cup 38 / Undead 35 / Jungle 40 / Frozen 40

### 5.4 两类脑红要分清

| 类型 | 数据形态 | 能不能升级 | 排序 |
|---|---|---|---|
| **CPS 类** | `CPS=<数字>` · `Upgradeable=true` | ✅ | 按当前 CPS |
| **Best-% 类** | `Best=<数字>` · `Upgradeable=false` | ❌ | **排在所有 CPS 类之上**（tier 2 vs tier 1） |

★ **Best 类共 41 个**（W / Dragon Cannelloni / Golden Block Cuppy / Tricerabob / Brain Mogger …），
它们的名字里**不一定**有 "exclusive" 或 "%" —— **靠名字关键词是认不出来的**，
要按名单（本仓 CheatMenu 已内置这份名单，见 `SYS.ExclusiveKeepSet`）。

### 5.5 其它常量（表格形式，按需查）

- **配重 16 档**（`Name` / `PPS` / `Cost`）—— ★ 这 16 个名字也是**识别"举铁道具"的第二判据**：

  | 配重 | PPS | 价格 |
  |---|---|---|
  | Wooden Stick | 2 | 0 |
  | Bone Barbell | 5 | 7,500 |
  | Stone Block | 10 | 75,000 |
  | Copper Plate | 50 | 500,000 |
  | Iron Plate | 150 | 7,250,000 |
  | Ice Barbell | 400 | 250,000,000 |
  | Donut Barbell | 1,000 | 5,000,000,000 |
  | Golden Barbell | 2,500 | 85,000,000,000 |
  | Heaven Plate | 6,250 | 1,200,000,000,000 |
  | Mega Golden Barbell | 15,000 | 18,000,000,000,000 |
  | Neon Pulse | 50,000 | 500,000,000,000,000 |
  | Giant Gold Star Barbell | 100,000 | 1e16 |
  | Emerald Barbell | 400,000 | 1e18 |
  | Planet Barbell | 2,000,000 | 5e20 |
  | Big Jupiter | 5,000,000 | 1e23 |
  | Black Hole Barbell | 30,000,000 | 5e25 |

- **踢击风格 14 种**：`Default×1.00` … `Tornado×1.70`，各有 `PerfectLength`（完美判定长度）。
- **基础槽位升级 20 档**：5e6 → 5e13。
- **战令经验**：免费轨 1-15 级 500→7500；额外轨 1-5 级 8250→11250。
- **学校合成 3 个配方**：`Cucumbro Nerdino`(1250) · `Professor Penneroni`(2500) · `Brain Mogger`(7500)。

### 5.6 ★★ 健身房（LiftMachine）—— 做「自动举铁 / 健身房事件」必须知道的

| 事实 | 值 |
|---|---|
| 机器怎么找 | **`CollectionService:GetTagged("LiftMachine")`**（★ 标签名确认无误），再过滤 `IsDescendantOf(workspace)` |
| 举铁道具怎么认 | `tool:HasTag("SquatTool")` **或** 名字命中上面那 16 档配重名（**两个判据都要试**） |
| 「我被机器认可了吗」 | `LocalPlayer:GetAttribute("liftMachine")` → **> 1 才算进入**（1 = 还没进去） |
| 机器自身属性 | `Multiplier`（当前倍率）· `Squats`（已做次数）· `Goal`（目标次数） |
| 倍率读法 | `tonumber(LP:GetAttribute("liftMachine")) or 1` |

**★★ 传送进机器的正确顺序**（照来源客户端代码，顺序错了就会静默失败）：

```
1. unequipAndUnanchor()      ← ★★ 必须先做: 卸掉工具 + root.Anchored=false + 速度清零
2. 读 root（此时才不会被 Anchored 挡住）
3. root.CFrame = CFrame.new(目标点) * (root.CFrame - root.CFrame.Position)   -- 只换位置、保留朝向
4. 速度清零 → task.wait(0.16)
5. 装备举铁道具（先 UnequipTools 再 EquipTool, 重试 3 次）
6. 等 liftMachine 属性 > 1（0.9s；**循环结束后要再查一次**，属性可能在边界那一刻才翻）
7. 每个落点失败后【也要再 unequipAndUnanchor 一次】再试下一个 ——
   否则第一次失败留下的锚定状态会让后续所有落点一起失败
```

⚠ **反面教材（我们原来就是这么写的，所以健身房 TP 不生效）**：
把守卫写成 `if root.Anchored then return false end` ——
**角色被 Anchor 住（飞行 / 藏地下隐身 / 被游戏锚定）时直接放弃，而且没有任何日志**。
正确做法是**先反锚定再传送**，而不是拿 Anchored 当作"放弃条件"。

⚠ **站位落点要挑对**：机器里 `StandingPlatforms` / `Hitboxes` 才是"站的地方"，
模型本体（`PrimaryPart`）往往不是。落点选择次序：`StandingPlatforms` → `Hitboxes` → 名字含
`standing/platform/pad/hitbox/zone/squat` 的部件 → 名字含 `lift` 的部件。
**别把"大范围触发板"当点目标**（会传进板子中心而不是站台）。

---

## 六、与 CheatMenu 的对应关系（交叉核对结论）

| CheatMenu 里的东西 | 来源 | 核对结果 |
|---|---|---|
| `[09]` 的 `CPS` 表（127 项） | 来源 `BrainrotData` 的 CPS 项 | **0 漏 / 0 多 / 0 值不一致** ✅ 抄得完全正确 |
| `[09]` 的 `MutBuff`（24 项） | 来源 `MutationBuffs` | **逐项一致** ✅ |
| `GetBrainrotCPS` 的 `1.25^(lv-1)` | 来源标注为游戏官方公式 | ✅ 一致（**不用改**） |
| `SYS.RFunction("B_Sell")` | 来源 `SellHeldBrainrot` | ⚠ 形态对（ref_ 优先），但**来源还有 rev_ 兜底**，CheatMenu v8.3.0 已补上 |
| `SYS.REvent("TaviMishkal")`（自动训练加成） | 来源 `connectRemote("TaviMishkal")` | ✅ 名字与形态都对（是 `rev_`） |
| 独家物品保护 | 来源是**数据驱动**（`Upgradeable=false` 名单） | ⚠ CheatMenu 原来是**关键词猜**，v8.3.0 已补上权威名单 |

⚠ **两边的"最佳判定"要注意**：来源用 `Best` 值排序、CheatMenu 用 `CPS` 表 + nil 兜底 ——
**CheatMenu 对 Best 类物品返回 CPS=nil，因此不会卖它们**（偏安全），但也**不会**把它们算进"最佳摆放"。

---

## 七、注意事项

- 本条目**只记录"游戏给了什么"**，不代表这些 remote 都能随便调；
  服务端权威的东西（余额 / 物品 / 重生 / 战令）客户端改不动，只能"发请求看服务端给不给面子"。
- `TaviMishkal` · `mightyChest` · `mathUPD` 这三条属于**活动/弹窗类**：
  服务端要你**先被通知**、再回发，**主动盲调一般无效**（还可能被记）。
- 换游戏 / 游戏改版后**必须重新抓包**：`rev_`/`ref_` 前缀与名字都可能变。
