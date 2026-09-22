# Dead Rails（亡命铁轨）· 新功能候选

> 来源：`C:\Users\Administrator\AppData\Local\Real\workspace\CheatMenu\scan_70876832253163.txt`
> 扫描时间 **2026-09-22 23:27**，综合扫描十一层，10509 条目。
> 游戏身份：**Dead Rails** | PlaceId `70876832253163` | GameId `7018190066` | CreatorId `11867394`
> ★ **这是事件库里目前唯一没有记录的游戏** —— 之前只有 MM2 / DOORS / MachineParty / FFA / KickALuckyBlock。

---

## 〇 · 一句话结论

Dead Rails 是**合作生存 + 火车推进 + 随机城镇搜刮**那一类。对作弊菜单来说它**肥得很**：
有**明确的、可只读的状态树**（金库密码 / 路线 / 矿石 / 弹药 / 耐力），
也有**一整套命名清晰的战斗脚本**（`WeaponController` / `CrosshairHud` / `DamageIndicator` …）。

⚠ 同时它**有服务端校验脚本**（见 §三），**不能乱 FireServer**。

---

## 一 · 世界结构（实锤路径，不是猜的）

| 顶层容器 | 数量 | 里面是什么 |
|---|---|---|
| `Workspace.RailSegments` | 322 | **铁轨段** —— 每段有 `NextTrack`(ObjectValue) 串成链 ⇒ **整条路线** |
| `Workspace.Baseplates` | 13 | 地形底板，各带 `Biome` 属性（下方） |
| `Workspace.Towns` | 58 | 城镇 `town_1..3`，含 **`Buildings.Bank.Vault.Door.Combo`** |
| `Workspace.SafeZones` | 66 | `safezone_1..3`，含 `Buildings.{Doctor,GeneralStore,Gunsmith}` + `RunObjectiveBoard` |
| `Workspace.RuntimeEntities` | 93 | **活的敌人**（`Model_*` + `EntityName` 属性） |
| `Workspace.NightEnemies` | 8 | 夜间敌人（Vampire / Runner 等） |
| `Workspace.Model_Horse` / `Model_WarHorse` | 91 / 5 | **马**（玩家的坐骑，`EntityName=Horse` / `War`） |
| `Workspace.Ore` | 22 | 矿脉 `CoalOre` / `GoldOre` / `SilverOre`，各带 `Health`(IntValue=40) |
| `Workspace.TravellingMerchant` | 36 | 行商 |
| `Workspace.Sterling` | 28 | **一个特殊地点**：`Mineshaft.TorchPuzzle` / `Note.BankCombo` / `Journal` / `Town.Church.OfferingTable.SacrificeSquare` |
| `Workspace.SuspiciousLevers` | 10 | **`HiddenLever1..5`**（ClickDetector）—— 明摆着的彩蛋机关 |
| `Workspace.TeslaLab` | 5 | 发电机 `Generator.BasePart.PowerPrompt` |
| `Workspace.BoxingGym` | 3 | 拳击馆，里面也有 `Gameplay.Vault.Door.Combo` |
| `Workspace.StillwaterPrison` | 1 | 监狱 |
| `Workspace.RandomBuildings` | 25 | 随机建筑（含 `GeneralStoreDestroyed.StandaloneZombiePart`） |

**生物群系（`Baseplates.*.Biome`）**：`WerewolfWoods` · `NormalDesert` · `BloodDesert` · `AcidDesert`

---

## 二 · 新功能候选（按可行性 / 风险分级）

### 🟢 A 类 · 纯只读情报（最稳，不动游戏任何状态）

#### A1 · 银行金库密码聚合 ★★★ 最推荐
**证据**：金库是 5 位数拼出来的 ——
- `ReplicatedStorage.Assets.ObjectModels.Misc.BankComboPieces.bank_combo_1..5`（`.Mesh.SurfaceGui`）
- `...Misc.bank_combo_note.BankCombo.SurfaceGui`
- `Workspace.Sterling.Note.BankCombo.SurfaceGui`、`Workspace.Sterling.Map.BankCombo.SurfaceGui`
- 报纸/电报：`Decoration.newspaper_yeat_concert/…telegraph`、`telegraph_halloween` 都挂 `BankCombo.SurfaceGui`
- 锁本体：`Workspace.Towns.town_N.Buildings.Bank.Vault.Door.Combo`（`BoxingGym.Gameplay.Vault.Door.Combo` 同构）

**做法**：全图搜 `*BankCombo*` 的 `SurfaceGui` → 读里面 TextLabel 文本 → 拼成密码，HUD 常显。
**只读**：不点、不 Fire、不改。

#### A2 · 前方路线 / 生物群系预告 ★★★
**证据**：`Workspace.RailSegments.RailSegment.NextTrack` 是 ObjectValue 链（322 条）；`Baseplates.*.Biome`。
**做法**：从**当前车厢所在的段**出发沿 `NextTrack` 往下走 N 段，把沿途 `Biome` 与城镇/金库列出来 ⇒「下面 3 站：BloodDesert → 有银行」。
**只读**：纯走属性链。

#### A3 · 弹药 / 耐力 / 金钱 状态 HUD ★★★
**证据**（角色 Model 上的 Attribute，实锤）：
`ArrowAmmo` `BallistaAmmo` `CannonAmmo` `FireworkAmmo` `HeavyAmmo` `KeroseneAmmo` `LightAmmo`
`LightningAmmo` `MediumAmmo` `RayBeamAmmo` `ShotAmmo` `TeslaAmmo` · `CurrentStamina`(100) ·
`IsExhausted` · `isSprinting` · `InCombat` · `BloodColor`；`leaderstats.Money`（=39）。
**做法**：独立小面板照抄现有「🛰 战况面板」的写法（`SYS.Info`），2.5 次/秒，全只读。

#### A4 · 火车仪表读数 ★★
**证据**：`TrainModels.*.RequiredComponents.Controls.{Fuel,Spedometer,DistanceDial,TimeDial,Sign}`（SurfaceGui）；
脚本 `playerTrainVelocity`(8 个函数)。
**做法**：读仪表 SurfaceGui 文本 + 速度。

#### A5 · 目标 / 任务是啥 ★★
**证据**：脚本 `RunObjectiveSelection`(30) `ObjectivesHud`(10) `LocatorHint`(22)；
实例 `SafeZones.safezone_1..3.RunObjectiveBoard.Attachment.RunObjectivesInteractPrompt`。
**做法**：把当前 run 的目标文本捞出来显示（需再定位一次具体存放处）。

---

### 🟡 B 类 · 高亮 / 透视（复用现有 ESP 框架，低风险）

#### B1 · 矿石透视（金/银/煤）★★★
**证据**：`Workspace.Ore.{CoalOre,GoldOre,SilverOre}`，每个带 `Health` IntValue(40)。
**做法**：直接挂进现有 `ESP_Pick` 的类别表，三种矿三种颜色。

#### B2 · 金库 / 保险柜 / 门 透视 ★★
**证据**：`Towns.*.Buildings.Bank.Vault.Door`、`BoxingGym.Gameplay.Vault`、`TrainModels.*.Controls.Lever`。

#### B3 · 机关 / 彩蛋拉杆 透视 ★★
**证据**：`Workspace.SuspiciousLevers.HiddenLever1..5`（ClickDetector）、`TeslaLab.Generator.BasePart.PowerPrompt`、
`Sterling.Mineshaft.TorchPuzzle`（`MoveWall`）。
**做法**：归到现有「危险/机关」类。

#### B4 · 商人 / 商店 透视 ★★
**证据**：`Workspace.TravellingMerchant`(36)、`SafeZones.*.Buildings.{Doctor,GeneralStore,Gunsmith}`、
`StartingZone.Buildings.{GeneralStore,Gunsmith,Doctor}`（各有 `Shop_*.Checkout.Register.Box.ClickDetector`）。

#### B5 · ★★ 敌方敌对判定补强（**不是新功能，是修现有 ESP 认不出来**）
**问题**：现有 ESP 的敌对判定靠**关键词**（monster / enemy / seek / rush / ambush / figure / halt / screech / eyes / dupe / snare / spider）。
而 Dead Rails 的敌人叫 **`Model_Runner` / `Model_Acolyte` / `Model_RifleSoldier` / `Model_Vampire` / `Model_Walker` …** ——
**一个关键词都不命中** ⇒ 这游戏里现有的「生物透视」大概率把敌人当**中立橙**（甚至不亮）。
**证据（实锤）**：每个敌人模型带 **`EntityName` Attribute**：
`Acolyte`(10) `Banker`(5) `BoxerZombie`(1) `CovenantKnight`(1) **`Horse`(23)** `RifleSoldier`(6)
`Runner`(44) `Summoner`(4) `TurretSoldier`(16) `Vampire`(7) `Walker`(3) **`War`(1)** `Werewolf`(1)
外加容器归属：`Workspace.RuntimeEntities` / `Workspace.NightEnemies`。
**做法**：敌对判据补两条 —— ① 在 `RuntimeEntities`/`NightEnemies` 下 **且** ② `EntityName` 不在白名单
（`Horse` / `War` = 坐骑，**绝不能标红**）。
**顺手**：`Configuration.Damage`(NumberValue=15) 可以显示出来（敌人伤害）。

---

### 🟠 C 类 · 功能 / 自动化（有交互，风险更高，**要你点头**）

#### C1 · 命中标记 / 伤害数字 ★★
**证据**：`RemoteEvent.Hitmarker`、脚本 `DamageIndicator`(105 函数) `DamageIndicatorHandler`(4)
`DamageDealtSignal`(2) `DamageAttribution`(2)。

#### C2 · 开镜增强 / 借用游戏自带 AimAssist ★★
**证据**：`RemoteEvent.RequestADS`、脚本 `ZoomController`(7) `fovSpringLayer`(13)
**以及游戏自带瞄准辅助**：`aimAssist`(2) `AimAssistMode`(2) `aimAssistADSBoost`(2)
`ControllerAimAssistHandler`(4) `setAimAssistResources`(1)。
⚠ **这游戏自己就有 CrosshairHud(35) / CrosshairManager(17) / crosshairTargetingSystem(4)** ——
改准星相关的东西**必须绕开**，别再出「开镜准星没了」那种事（参考 10.5.1/10.5.2 护栏）。

#### C3 · 快速复活 / 群体复活 ★
**证据**：`Remotes.RevivePlayer`、`RevivePromptHandler`(6)、`clientMassReviveSystem`(9)。
⚠ 属 FireServer，**可能被校验**。

#### C4 · 冲刺 / 观战 / 技能 ★
**证据**：`Remotes.RequestSprint` + `SprintController`(14)；
`SpectateTarget/SpectateCycle/SpectateStop` + `SpectateController`(13)；
`ActivateMasteryAbility` / `MasteryAbilityInput` + `masteryAbilityHandler`(14)；
还有一堆能力系统 `clientDeadEyeSystem` `clientUmbralShroudSystem` `clientHealSummonsSystem` `clientChargeSystem` …

#### C5 · 马匹相关 ★
**证据**：`Model_Horse` / `Model_WarHorse` + `horseMomentumModel`(4) `HorseMomentumIndicator`(11)。

---

### ⛔ D 类 · 别碰的（服务端校验 / 指纹）

| 东西 | 证据 |
|---|---|
| `traffic_check` 的 `_whitelist` | 脚本 `traffic_check`(6 个函数)，`_whitelist` 在名字可疑清单里 |
| 武器校验 | `validateWeapon` / `validateWeaponAsync`（在 `WeaponController` 里） |
| 角色校验 | `validateLivingCharacter` / `validateEntity` / `validateInstance` |
| 指纹 | `ErrorFingerprint`(9 个函数) |
| 死亡遥测 | `DeathFlowTelemetry`(14) |
| 客户端信息上报 | `RemoteEvent.ReportClientInfo` / `RemoteEvent.Telemetry` / `RemoteEvent.Log` |

⇒ **这些是服务端说了算的**：本地改数值/包不会生效，反而可能被标记。**只读它们，不改。**

---

## 三 · 战斗/武器脚本全清单（★ 39 个，hook 之前先看这里）

```
★ DamageIndicator(105)  ★ WeaponController(105)  ★ CrosshairHud(35)  ★ BaseGunViewmodel(32)
★ replicatedProjectileClientHandlers(19)  ★ CrosshairManager(17)  ★ SummonWeaponController(14)
★ ClientWeaponHandler(12)  ★ raycastReplicatedProjectile(8)  ★ KrampusAim(6)
★ BaseLegacyGunViewmodel(5)  ★ clientProjectileInit(5)  ★ ControllerAimAssistHandler(4)
★ DamageIndicatorHandler(4)  ★ bulletImpact(4)  ★ crosshairTargetingSystem(4)  ★ AmmoDisplay(3)
★ AimAssistMode(2)  ★ DamageAttribution(2)  ★ DamageDealtSignal(2)  ★ ReplicatedProjectileHitRegistry(2)
★ aimAssist(2)  ★ aimAssistADSBoost(2)  ★ grenadeBounce(2)  ★ inflictDamage(2)  ★ AmmoPanel(1)
★ BulletCast(1)  ★ bulletTrail(1)  ★ getAimRay(1)  ★ getPlayerGuns(1)  ★ highlightRayGun(1)
★ isAnyGunReloading(1)  ★ moveReplicatedProjectile(1)  ★ projectileImpactBounce(1)
★ projectileVisualOffset(1)  ★ setAimAssistResources(1)  ★ updateBallistaBoltsAmmoLabel(1)
★ validateWeapon(1)  ★ validateWeaponAsync(1)
```

**实名函数（可 hook 候选）**：
`WeaponController` 里 —— `BeginThrowWeapon` `CancelThrowWeapon` `FireBullet` `ReleaseThrowWeapon`
`ThrowWeapon` `_fireSingleBullet` `_initializeWeapon` `_listenForWeapons`；
`replicatedProjectileClientHandlers` 里 —— `raycastReplicatedProjectile` `clientProjectileInit` `bulletImpact`；
另有 `getAimRay`（取瞄准射线）、`inflictDamage`、`isAnyGunReloading`。

---

## 四 · 建议优先级（我的排序）

1. **B5 敌方判定补强** —— 最小改动、收益最大（不加它，Dead Rails 的透视基本是废的）
2. **A1 金库密码** + **A3 弹药/金钱 HUD** —— 纯只读、玩法收益直接
3. **A2 前方路线/群系预告** —— 很有特色，只读
4. **B1 矿石透视** —— 顺手，复用 ESP_Pick
5. 其余按用户点名再上

---

## 五 · 诚实边界

- 扫描是**在大厅/某一局里**扫的 ⇒ 金库密码的具体存放**时机**（开局就在，还是拿到纸片才生成）没验；A1 的最终判据可能要用真机 F9 输出再收一次。
- `getconnections` 本机没有 ⇒ 「谁在监听这条 remote」**测不出来**，上面 C 类的可行性打问号的部分就在这。
- 所有 A/B 类都是**只读**；C 类一旦 FireServer 就是**跟服务端打交道**，先看 §三 D 类再决定。

---

## 六 · 本次已实施（**v10.8.0** · 2026-09-22）

用户点名范围 = **战斗增强 + 透视补类 + 敌我判定补强**（下方 ✅ 项）；**只读情报包（A1 金库密码 / A3 弹药 HUD / A2 路线预告）用户未选 ⇒ 未做**。

| 项 | 状态 | 落地形态 |
|---|---|---|
| **B5 敌方判定补强** | ✅ 已做 | `SYS.DRHostileRoots={"RuntimeEntities","NightEnemies"}` + `SYS.DRHostileMount={Horse,War}`；`isHostile` 里 `drHostile(m)` 先判（`EntityName` 白名单 + 容器归属）。**不动**原关键词逻辑。 |
| **B1 矿石透视** | ✅ 已做 | `SYS.PickKinds` 新增「矿石/矿脉」类（青 `0,200,255`，`coalore/goldore/silverore/…`）—— ⚠ **排在「拾取物」之前**，否则 `GoldOre` 被 gold 关键词先吃掉。 |
| **B3 机关透视补词** | ✅ 已做（并类） | 「按钮/机关」类补 `altar`/`shrine`/`sacrifice`/`totem`（`Sterling.Town.Church.OfferingTable.SacrificeSquare` 献祭台）。 |
| **C1 命中标记** | ✅ 已做（只监听） | `SYS.DRCombat` · 开关 `DeadRails_HitMark`（`SYS.SetDRHit`）：听 `...RemoteEvent.Hitmarker` 的 `OnClientEvent` → 准星 ✕ + 底部计数。**零 hook**。 |
| **C2 开镜增强** | ⚠ 仅"探针" | 开关 `DeadRails_AimProbe`（`SYS.SetDRAim`）：瞄准层**只有模块名没函数名** ⇒ **只把调用次数打到 F9**，`return orig(...)` 原样转发、**绝不改行为**。真增强留待拿到 F9 输出后的下一版。 |
| A1 / A2 / A3 / A4 / A5 | ⬜ 未做 | 用户本轮未选（只读情报包）。**已留档，随时可上**。 |
| B2 / B4 / C3 / C4 / C5 | ⬜ 未做 | 未选。 |

**接线四点（已核）**：`SYS.T_` 默认（`DeadRails_HitMark`/`DeadRails_AimProbe` 均 `false`）· 模块本体 `[08D] SYS.DRCombat` ·
战斗页尾部 `UI.Section("🔫 Dead Rails 战斗增强")` 两个 `UI.Switch` · `SYS.UnloadAll` 补 `SYS.DRCombat.UnloadAll()`。
★ `_audit_switch_wiring.py` 复核：新增 2 个开关**均在「有界面入口」**（84/95）。

**发版**：`10.8.0`（新功能 ⇒ 次+1）· 编译门禁 0 错误 · 等价性通过 · 加载器探针 6/0 ·
发行版 `CheatMenu.lua` 570962 B · 源码 `CheatMenu-10.8.0.lua`（20141 行）。

---

## 七 · v10.9.0 追加：锁血 / 补血 / 防击倒（2026-09-23 · 起因「还有无敌锁血能做到吗 恢复血」）

用户多选 **锁血+补血+一键回满血** 与 **防击倒/防布娃娃**（**只读血量面板 未选**）。

### ★★ 取证结论（这决定"无敌"能到什么程度）
| 问题 | 结论 | 证据 |
|---|---|---|
| 玩家血量存在哪 | `Humanoid.Health` | 玩家角色 **Model 的 23 个 Attribute 里没有 Health**（只有 `ArrowAmmo`/`CurrentStamina=100`/`InCombat`…） |
| 伤害谁算的 | **服务端** | **220 个 remote 里与玩家血量相关的只有 3 条**：`Assets.Tools.Medical.bandage.Use` · `...snake_oil.Use` · `Remotes.RevivePlayer` ⇒ **无「我掉血了」的客户端上行通道** |
| 真无敌可能吗 | **⛔ 不能** | `Replica`(服务端→客户端状态复制) + `jecs`(ECS) + `validateLivingCharacter` + `traffic_check` + `DeathFlowTelemetry` + 服务端 Attribute **`HasDied`** |
| 唯一可能真有效 | **防击倒** | `ClientPlayerFlopHandler`(3 函数) **跑在客户端** |

⇒ **补血 ✅ · 锁血 ⚠️（血条回弹，服务端判死仍死）· 真无敌 ⛔**。

### 落地（`[08E] SYS.DRHp`，入口在「功能」页「上帝模式」上方）
- 🔒 锁血+补血 `DeadRails_LockHp`（`SYS.SetDRLockHp`）：`HealthChanged` **同帧**写回 `MaxHealth`（**无 `v>0` 前置**）+ Heartbeat 兜底 + 禁 `Dead` + `BreakJointsOnDeath=false` + 重生自动重绑。
- 🧍 防击倒/防布娃娃 `DeadRails_NoFlop`（`SYS.SetDRNoFlop`）：禁 `FallingDown`/`Ragdoll`，每帧纠 `FallingDown`/`Ragdoll`/`Physics`→`Running`，解 `PlatformStand`/`Sit`。
- 💚 立即回满血（`UI.Btn` → `SYS.DRHp.Refill`）。
- 卸载：`SYS.UnloadAll` 补 `SYS.DRHp.UnloadAll()`（断连接 + 还原 3 个状态 + `BreakJointsOnDeath=true`）。
- 全纯客户端，零 hook、不 FireServer。`luau-compile` 通过；开关接线对账 97 个 / 86 有入口（新增 2 个均已在入口）。

---

## 八 · v10.10.0 之后：**「防攻击」专题**（2026-09-23 · 起因「防攻击呢 敌对npc生物之类的 不会攻击我 伤害打不到我」）

用户问的是**"敌对生物不攻击我 / 伤害打不到我"** —— 这**不是** §七 的"回血"，是**更高一档**的需求。已单独立档：

➡ **`事件库/2026-09-23_防攻击(敌人不攻击我_伤害打不到我)_可行性与候选.md`**

**结论一句话**：**⛔ "打不到我"做不到**（服务端算伤害 + 客户端**没有血量面** —— 全图 `Health` 只有 `Ore.*`，
玩家 23 个 Attribute 里没有 Health + 无上行通道 ⇒ 三条占满）。
能做的是 **"看得见 / 躲得开 / 扛得住"**：近身预警、敌人伤害值显示、受伤感知、受击即补（都是只读或本地）。
★ **唯一还留着的口子** = `ClientHitRegistration` / `HitRegistration` / `replicatedProjectileClientHandlers`
（**需先只读探针 + 真机验证**，探针写法同 `DeadRails_AimProbe`）。
★ 公开项目（15+ 个 Dead Rails hub）**全混淆、无一可读**，且它们自己的功能表就写着 **`God Mode (Limited Versions)`**。


