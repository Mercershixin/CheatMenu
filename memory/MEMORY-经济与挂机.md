# 经济 与 挂机（细节）

## 收起脑红 / 收钱 / CPS 卖出（2026-10-01 学自用户给的 `123.txt`）

### ★★★ 安全规则（最重要，别再犯）

1. **"会自动卖掉东西"的功能必须有"不要动这些"的保护名单**，且**三重判定**：
   ① 名单（`EXCLUSIVE_SET` 41 个限定名）② 名字关键词（exclusive/独家/限定/vip/%/x2/x5/幸运…）
   ③ 属性（`Exclusive`/`IsExclusive`/`Limited`/`IsLimited`/`Percent`/`Multiplier`）。
   —— 单靠一种挡不住改名或新词缀。**旧版完全没有保护，门槛设低就会卖限定。**
2. **卖/放必须"确认结果"**：装备 → 确认 `tool.Parent == ch` → `B_Sell` → **确认 `tool.Parent` 消失**才算成功。
   ⛔ 旧版"发一次 `InvokeServer` 就 total+1"，连发 200 次，卖没卖成根本不知道。
3. **批量操作要齐备**：防重入（线程字段）· 冷却 · **连续 2 轮无进展就停** · **卖完自动关开关** ·
   **记原位、结束后回到原位**。
4. **给用户的输入框要能解析常见写法**（`80m` / `500K` / 数字）并在认不出时**明确报错**，不许静默失败。
   ⚠ 旧版 `SellMinCPSTools` 是 `local function` 且**没有任何 UI 入口** ⇒ 能力等于不存在。

### CPS 估算模型

- `CPS = base × MutBuff[词缀] × SellLvMul^(lv-1)`；`lv = clamp(floor(Level 属性), 1, 75)`；
  词缀取不到按 `×1`；`SellLvMul` 取 `C.SellLvMul`（默认 **1.25**）。
- `base` 优先查**内置表**（140+ 条，从 `123.txt` 括号配对提取），其次读物品属性 `CPS`/`BaseCPS`；
  两者都没有 ⇒ **算不出 ⇒ 不卖**（绝不按 0 处理）。
- `F.FmtNum`（K/M/B/T）+ `F.ParseCPS`（k/m/b/t/q 后缀）。
- 实体工具判定 = `Tool:HasTag("EntityTool")`（不要按名字猜）。
- 卖家 NPC = `workspace.NPCs` 里 Name 或 `GetAttribute("Name")` == `"Timmy"`；
  找不到才退回硬编码 `SELLER_CF`（`134.125, 0.125, 83.866`）。卖前走到他身边 4 stud、**卖完回原位**。

### 落地形态（都经 `F.*` 暴露，整块在 `do...end` 里）

| API | 作用 |
|---|---|
| `F.WithdrawAll(30)` | 一键收起脑红：每槽前 `UnequipTools` → `EquipTool` → `Fire("S_Interact", i)`，背包空了就停 |
| `F.CollectAll(30)` | 一键收钱：`Fire("B_Collect", i)` |
| `F.PreviewSell()` | **只读**预览：会卖几个 / 限定保留几个 / 算不出几个（不动背包） |
| `F.SellLowCPS(force)` | 按门槛卖：装备→确认→卖→确认消失；卖完自动关开关 |
| `F.ParseCPS` / `F.FmtNum` | 门槛解析 / 数字格式化 |

- UI 在「挂机」页小节「**脑红 / 现金**」：一键收起 · 一键收钱 · 预览(只读) · 门槛 · 等级乘数 · 按 CPS 卖出。
- ★ 门槛：`C.SellMinCPSTxt`（字符串，供界面回填）+ `C.SellMinCPS`（数字，供逻辑）——
  分开存是因为 `CfgSyncUI` 类型不符就不回填，否则面板又会和实际不一致。

## ★★★ 游戏真实公式与 HUD 路径（2026-10-01 学自 PuckAFK Hub v4.6.4，源码内有 `Exact` 标注）

- **升级花费** = `base_CPS × 词缀乘数 × 1.5^(lv-1)`（出处 `EntitiesData.GetCostForUpgrade`）
- **当前 CPS** = `base × 词缀乘数 × 1.25^(lv-1)` ← **与我们原有模型一致，交叉验证通过**
- **ROI** = `(当前CPS × 0.25) / 花费` ⇒ 可直接排序"先升哪个"；`回本秒数 = 花费 / 每秒增益`

| 值 | HUD 路径（相对 `PlayerGui`） |
|---|---|
| 金币 | `HUD.BottomLeft.CoinsFrame.InsideFrame.CoinLabel` |
| 踢力 | `HUD.BottomLeft.KickLevel.TextLabel` |
| 精通 | `HUD.BottomLeft.KickMastery.InsideFrame.CoinLabel` |
| 速度等级 | `Frames.SpeedUpgrades.ScrollingFrame["+1 Speed"].NameLabel`（值 −13 取整） |
| 重生等级 | `Frames.Rebirth.RebirthLevel` |
| 教程步 | `LocalPlayer:GetAttribute("TutorialStep")` |

- ★ **紧凑数字解析要覆盖全后缀**：`$`、逗号、`1.5e3` 科学计数、`K/M/B/T/QA/QI/SX/SP/NO/DC`
  （`F.ParseNum`；原来只认 `k/m/b/t/q` 不够）。

## ★★ 学别人的 hub：只取"事实"，不抄"编排"

- 只有**标了出处 / 能交叉验证**的（上面两条公式、HUD 路径）才敢直接用；
  它的**自动化编排**（走位、时序、连招）依赖大量没验证过的世界细节 ⇒ **照抄必出死代码**。
- ★ **新功能一律"用户主动触发"**（按钮 / 选完复位的下拉），不新增"加载即跑"的东西。
- ★ **只读类入口尽量合并**（3 个只读查看 → 1 个 3 合 1 下拉），别让页面控件数一路涨。
- ★★ **"卖光"没有再写一套卖逻辑**：给 `threshold()` 加 `F._sellThOverride`（返回 `math.huge`）后
  直接调 `F.SellLowCPS(true)` ⇒ 装备→确认→卖→确认消失→回原位 全部复用；结束与出错两条路径都清标志。
  **能复用流水线就别复制一份。**
- 未采用（留档，都动游戏状态、需先静态确认 remote）：`placeBestBrainrot`（基地最优摆放）·
  `upgradeBrainrotsBatch`（自动升级）· `performKick/pressNormalKickInput/sendKeyCode`（真实输入踢击）·
  `tryRebirth/buySpeedOnce`（自动买速度/重生）。**触发方式不确定就先不做**，免得"有开关其实不动"。

## ★ 2026-10-07 扫描：活动 / 技能树 的入口线索（**只评估，未实现**）

用户要「自动升级技能树 + 枫叶活动出现就去做、没出现就挂机训练+领健身房、枫叶优先」。
先按铁律搜了一遍**已有**：挂机页**已有** `AutoTrain`（自动锻炼）/`AutoBonus`（领锻炼奖励）/
`AutoGym`（传送健身房）/`AFKKickGuard` ⇒ **健身房与训练那半边不用做**。
**真没有**：活动自动化、技能树自动升级、优先级调度。

扫描（`89469502395769` = 踢一个幸运方块）里挖到的线索：
- **活动入口 = ProximityPrompt**：`物体=Rate_01 · 动作="Spawn now!" · 说明="Fall Event"` ⇒ 枫叶/秋季活动
  的触发点**可以**用现成的 `fireproximityprompt` 打。配套数据表：`Shared.Data.Events.FallQuestsData` /
  `FallGoalsData`；另有 `Events.MutationPortals` / `Events.LuckRings` / `Weathers.SpecialEvents.Pinata`。
- **升级候选 remote**（`*ServiceClient` / UI 来源）：`rev_TU_upd`(TimedUpgradesServiceClient)、
  `rev_bs_updateClient`(BaseUpgradesServiceClient)、`rev_TaviMishkal`(KickUpgradesUI)。
  UI：`PlayerGui.KickUpgrades`、`Frames.SpeedUpgrades`（`+1/+4/+9 Speed` 按钮）、
  `Frames.VolcanoUpgrades`（`Buy` + `TokensFrame` 货币 = Tokens，`Info=+25% Rock Spawns`）。
- ⛔ **仍缺一口气**：升级 **remote 的 payload**（哪一项 / 花什么货币 / 次数）与"活动算不算参与"的判据，
  扫描文件里都没有 ⇒ 凭名字硬写 = 又一个"有开关其实不动"。**必须先抓一次真实操作**（手动点一次升级 +
  手动进一次活动）才能落地。
- ⚠ 记忆里另有一条：旧的 `Fire("TaviMishkal")` 曾被判定为**不存在/无效的 remote**；
  但本次扫描确实列出了 `rev_TaviMishkal`（来源 `KickUpgradesUI`）⇒ **两者冲突，需现场确认**，不要直接采信任一方。

## ★ 2026-10-07 第二次扫描（04:02）：枫叶(Fall)活动 + 技能树 的 remote 全表

用户又扫了一次（`89469502395769`），`[抓包]` 段把 remote 全列出来了，机制已基本清晰：

**枫叶/秋季 Fall 活动**（核心 = 吸枫叶 vacuum + 任务/目标领取 + Fall 技能树）：
- `rev_fallVacuumStarted` / `rev_fallVacuumEnded`（吸尘器起止，服务端广播或客户端触发待定）
- `rev_FallUpdate`（`FallService`）· `rev_FallUpgrade`（`FallUpgradesUI` / `Shared.Data.Events.FallUpgradesData`）
- `rev_FallQuestsClaim`（`FallQuestsUI` / `FallQuestsData`）· `rev_FallGoalsClaim`（`FallGoalsUI` / `FallGoalsData`）
- `rev_fallGroups`
- **活动入口 ProximityPrompt**：`Rate_01 · 动作="Spawn now!" · 说明="Fall Event"`（开始）；
  `Rate_01 · 动作="Upgrades" · 说明="Fall Tree"`（**Fall 技能树**）。

**其他活动 remote**：`rev_MutationPortalEvent`·`rev_luckCircles`·`rev_PiniataHit/Exploded`·`rev_mightyChest`·
`rev_candyEat`·`rev_IceBossShockwave`·`rev_FreezePlayer`·`rev_bossStartUpd/EndUpd/DataUpd`（boss 类）·
`rev_MCH_Type`/`rev_mchPrompt`。

**技能树/升级 remote**：`rev_SPEED_UPGRADE`（速度，UI `SpeedUpgrades` 有 `+1 Speed/+4 Speed/+9 Speed` 三档，
`Run Speed: 161`）· `rev_FallUpgrade`（Fall 树）。

**货币/领取**：`rev_TokensUpdate`·`rev_Shop_Buy`·`rev_Offline_Claim`·`rev_ClaimFree`·`rev_GroupClaim*`·
`rev_MailClaim*`·`rev_QuestUpdate/QuestProgress`·`rev_myMarket_*`。

- ★ **仍缺最后一块**：以上全部是 remote **名字**，**FireServer 的 payload 一个都没有**（吸叶子传什么、
  领任务传哪个 id、升级传哪档/花什么货币、活动"出现/下次"的判据）。凭名字硬写 = "有开关不动"。
- ✅ **项目已有 hook `remote.FireServer` 的现成机制**（`hookfunction(remote.FireServer, orig)`，见反作弊/陷阱模块）
  ⇒ 可做**只读参数抓包探针**：hook 上述 remote 的 `FireServer`，把每次调用参数打到 F9。
  用户手动做一遍（吸叶子/领一次/升一次级）参数就齐，再据此落地自动化。
- 待用户点「活动信息」只读按钮（输出"下次活动+倒计时"的 HUD/表结构），倒计时源 = `HUD.UpdateTimer.TimerLabel`。

## ★ 天气/活动调度架构（2026-10-07 第三次探测 + remote 分析，决定"能否提前预测未来活动"）

- 探测确认：`WeatherController` **没有任何 Attribute、也没有 ValueBase 子项** ⇒ 当前天气状态**不暴露为属性**。
- **remote 实锤是"服务端广播当前天气"**：
  `rev_WeatherUpdate` / `rev_AddedWeather` / `rev_RemovedWeather`（来源 `WeatherService_Client`）。
  ⇒ 客户端只收"当前加了/删了哪个天气"，**未来排班很可能在服务端**。
- 结构：`WeatherController.Weathers/` 下分三类：
  - **Events**（天气，4 个轮换）：Jungle / Frozen / Candy / **Fall（枫叶）**；
  - **SpecialEvents**（13 个，随时插入）：Pinata、MightyChest、MultiplierReactor、MutationPortal、
    LuckCircles、LiftMachine、Concert、LuckMachine、Super Gym、Fire…；
  - **Mutations**（~6 个）：Wet、Bacon、Phantom、Enchanted、Disco、Carnival；
  - 另有 `Weathers.BlockCup.Block Cup`。
- **结论（要如实告诉用户）**：
  - ✅ 能做「**当前活动 + 距下次轮换倒计时**」：监听 `rev_AddedWeather/RemovedWeather` + 读 `HUD.UpdateTimer`（1 小时一轮）。
  - ⚠️「**未来几小时具体是哪个活动**」：**取决于调度是否客户端可见**。唯一确认办法 = 只读反编译
    `WeatherService_Client` / `WeatherController` 模块源码，看有没有本地排班表/固定循环。
    若有 → 能做"未来 N 小时排班"；若纯服务端 → 只能做"当前 + 倒计时"，未来具体活动做不了（游戏不告诉客户端）。
  - 该判断尚未做，等用户点头后加"读天气模块源码"的只读步骤。

## 未采用（来自 `123.txt`，留档）

`SC` 调度器 / `BUS` 信号总线 / `NET` remote 图谱（Scan/Atlas/Track/Rebind/Health） / `HK` hook 登记表 ——
**架构级**重构，收益与风险不成比例（现有的**元方法分层栈 + `getconnections` 扫描**已覆盖 hook 与连接管理）。
要做就按 `single-entry-kernel-swap-refactor` 单独开一轮，**别边加功能边换内核**。

## 「踢一个幸运方块」的锻炼/领奖不是我们原来那套（2026-10-04 修，14.0.8）

- ★ **锻炼真机制**：`PlayerGui.KickUpgrades` 里名为 `Bonus`/`PopBonus` 的 ImageButton，**Visible 就点它**；
  前置是"手里拿配重 Tool"（**Tool 且没有 `Rarity` 属性**；brainrot 一定有 Rarity）⇒ 用 `hum:EquipTool` + `Tool:Activate()`。
  ⛔ 旧实现找 `CollectionService` 的 `LiftMachine` 标签 + `liftMachine` 属性（别的游戏的写法）⇒ **tp 到了也不涨**，就是这个原因。
- ★ **领奖** = 点同一个 `Bonus` + `rev_B_Collect`(1..12 槽) + 对自己 `workspace.Plots`(Owner==自己) 的 `Buttons` 子物体
  `firetouchinterest(hrp, slot, 0/1)`。⛔ 旧的 `Fire("TaviMishkal")` 是**不存在的假 remote**（grep.app + 公开 repo 0 命中）⇒ 静默无效。

## ★★★ 挂机四模块：实现来自参考脚本，职责严格分开（2026-10-05 v16.9.16）

用户命令「自动锻炼只能是锻炼，不要 tp 到健身房；自动领取不是领取什么东西，至少领健身 ×2/多倍」⇒

| 开关 | 行为（严格边界） |
|---|---|
| 挂机防踢 | PuckAFK `loader-free.lua` 的 `enableAntiAFK`：`Idled` → `CaptureController` + `ClickButton2((0,0))` + 角落 `Button2Down/Up`；触屏跳过；**无任何元表钩** |
| 自动锻炼 | **只在原地**：把已有配重拿上手 + 反复 `Tool:Activate()`。**不移动、不传送、不领奖** |
| 自动领取 | **只领锻炼/健身的多倍奖励** = `F.GymClickBonusPopups`（×2/×5/×10 文本，兜底按钮名 `Bonus`/`PopBonus`）。邮箱/离线/群组/转盘/战斗通行证**整条已删** |
| 自动传送健身房 | **唯一会移动的开关**：`Gym.enterGymMachine` + `Gym.moveToLiftMachinePart`，`TravelMode="Teleport (Safe)"` |

- ★ 判据：`grep -c "Gym.enterGymMachine"` 应为 **2**（1 定义 + 1 调用，只在自动传送健身房）。
- ◆ 未搬：`buyOrEquipBestWeight`（会**花钱买配重**）⇒ 只把已有配重拿上手。
- ⛔「一注入就被踢」元凶：文件**末尾** `T.AntiAFK, T.KickGuard = true, true` + `KickGuardEnable`（加载即装 Kick 元表钩，与 UI 默认值矛盾）—— 已删。

## ★★★ 卖/收钱整簇已于 v16.9.18 **彻底删除**（2026-10-06，用户点名）

- 用户原话：「那些孤儿功能是我要删除的」⇒ 删掉的不只是界面入口，**实现一起删**：
  `F.CollectAll` `F.PreviewSell` `F.SellLowCPS` `F.SellAll` `F.SellScanStats` `F.SlotOfTool` `F.ParseCPS` `F.TpToMyPlot`
  `F.ReadBase` `F.UpgradeAdvice` `F.HudNum` `L.fmtNum` + 全部 helper（`isEntityTool/isExclusiveTool/baseCPSOf/lvMul/
  toolLevel/cpsOf/describe/threshold/collectLists/findSeller/moveToSeller/sellHeld`）+ 常量表（`CPS`140 条 / `MutBuff` /
  `EXCLUSIVE_SET` / `EX_WORDS` / `SELLER_NAME` / `SELLER_CF`）+ `L.REvent` / `L.RFunction` / `L.findRemote`。
- **本页上面第 3~42 行那套"CPS 卖出 / 保护名单 / 卖家 NPC"的设计只作历史留档**，代码已不在，别当现状引用。
- **仅保留 `F.WithdrawAll`（★ 收起脑红）** —— 它非孤儿（有界面入口）。
- 判据回顾：`grep -c "F.Xxx" == 1`（只有定义）= 孤儿；**但"被点名删过"的孤儿不许接回**（这正是 v16.9.17 翻车原因）。
