# [没有机器人，自由对战模式] —— Remote / 信号清单（2026-09-19 抓包）

> 游戏：`[没有机器人，自由对战模式]`
> PlaceId **119661268047775** · GameId 9534705677 · CreatorId 241962998
> 抓包时间：2026-09-19 20:04 / 20:35（两次，执行器「综合扫描」→ A 通信层）
> 原始清单在执行器工作目录：`Remotes_[没有机器人，自由对战模式]__119661268047775_20260919_2035.txt`

## 规模

| 类型 | 数量 |
|---|---|
| RemoteEvent | 289 |
| RemoteFunction | 149 |
| BindableEvent | 29 |
| BindableFunction | 6 |
| ProximityPrompt | 23 |
| ClickDetector | 1 |
| 脚本 / 模块 | 3634 / 4700（getrunningscripts 709） |

---

## ★ 最重要：游戏自己的判定数据（不是 remote，是实例/属性）

### 1) 敌我名单容器 —— 最权威
```
Workspace.Highlight.Enemy.HighlightHolder.<玩家名>
```
**谁在里面谁就是敌人**。混战里 `@Team` 所有人取值一样（区分不出敌我），这个容器才是准的。
→ 主脚本 `CB.GameSaysEnemy()` 读它，已接进 `isEnemyEx()`（6.9.22）。

### 2) Player Attribute（每人都有一份，服务端写入、客户端可读）
```
Health / MaxHealth / BeDamage / Death / Killed / MaxKillStreak / FFAPoint
InAir / Jump / JumpHeight / HipHeight / Level
GameRoom / LoadOutTimeout / LootEventCanParticipate / LootEventPending*
Device / AllowQueryInv / AllowTeam / AllowTrade / CardSurface
```
→ 判活/判死读 `@Health`；换弹受控读 `@combatPaused`(此游戏未出现，回退 Tool 判据)；房间号读 `@GameRoom`。

### 3) 场景物件路径
```
Workspace.Room.<roomId>.Replicated.<武器名>.Root.PickupPrompt     -- 地面武器（可拾取）
ReplicatedStorage.Config.GachaConfig / WeaponConfig / KillEffectConfig / StallSkinConfig
ReplicatedStorage.Assets.Temp.WorldModel.Lobby.付费箱子.<档>.<箱名>.ProximityPrompt
```

---

## 关键 Remote（按能否做功能分类）

### ✅ 领取类（免费，服务端给每人一份）—— 最实用
`Rewards.Days7Claim` `Rewards.Days4RecurClaim` `Rewards.NewBieClaim` `Rewards.OnlineRewardClaim` `Rewards.TryGroupReward`
`BattlepassService.Claim` `BattlepassService.ClaimPremiumReward` `BattlepassService.ClaimRebirthReward` `ClaimRebirth3Reward` `BattlepassService.Rebirth`
`MinipassService.Claim` `MinipassService.ClaimPremiumReward` `MinipassService.ClaimRebirthReward` `MinipassService.Rebirth`
`MailboxService.Claim` `QuestService.ClaimReward` `Challenge.Claim` `RankedService.ClaimReward`
`Any.ClaimWeeklyCase` `Any.ClaimSeasonWeapon` `Any.ClaimTradeTokenReward` `Any.ClaimLimitedBundleReward`
`Any.CollectrionClaim` `Any.CodeInviteClaim` `Any.RebackRewardInvok` `Any.RebackReward` `Any.TimeReward`

### ✅ 抽奖 / 抽卡
`Spin.Spin`(转盘) · `GachaService.Gacha` · `GachaService.InvokeServer` · `RaffleService.Join` · `Any.Raffle` · `Any.SecretLuck` · `Any.GachaResult`

### ✅ 商店 / 购买（要钱，服务端校验余额）
`ShopService.Purchase` `ShopService.Gift` `Shop.Purchase` `Any.Purchase`
`RandomShopService.Purchase` `RandomShopService.Refresh` `RandomShopService.Gift`
`CustomShopService.Purchase` `CustomShopService.Select` `Beginner.OpenShop`

### ✅ 卖出 / 市场（换钱）
`WeaponService.Sell` · `PlayerMarketService.Purchase/AddListing/SetPrice/RemoveListing/LoadListed/Query/SetLock/SetSkin/SetStallName` · `AuctionService.Bid` · `Any.AuctionAdd`

### ✅ 交易
`Trade.Request/Ready/Select/SetConfirm/Toggle/Cancel/RequestNotice/ReadyNotice/CashTradeNotice` · `TradeLobby.CashGun.Fire/Pickup/Drop/Reload` · `TradeLobby.Teleport/ClaimStall/Rejoin/SetSign`

### ✅ 战斗 / 武器
`CombatService.Action`(RF) `CombatService.ActionEvent` `CombatService.SetWeapon` `CombatService.SwitchSlot` `CombatService.Ammo`
`EntityService.BeDamaged` `EntityService.Heal` `EntityService.Died` `EntityService.WalkSpeed` `EntityService.Jump` `EntityService.SetState` `EntityService.SetInAir` `EntityService.PitchYaw`
`WeaponService.SetSkin/SetWrap/SetFavorite/ReName/ResetName/Unlock` · `WeaponPickup`

### ✅ 物品 / 装备
`ItemService.TryUse`(RF) · `BackpackService.TryEquip`(RF) `BackpackService.TryUnequip`(RF) `SetBackpack`
`EquipmentService.SetEquip`(RF) · `CharmService.Equip`(RF) `CharmService.UnEquip`(RF) · `EmoteService.Equip/Play/Stop/CleanEquipped`

### ✅ 传送（服务端认可）
`Any.Teleport` `Any.Teleporter` `Any.PlaceTeleport` `Any.ServerTeleport` `Any.ClientTeleported`
`ReplicateService.Teleport` · `EntityService.Teleported` · `TradeLobby.Teleport` · `PlaceTeleport`

### ✅ 队伍
`TeamService.Invite`(RF) `TeamService.Accept`(RF) `TeamService.Kick`(RF) `TeamService.Leave`(RF) `TeamService.*Notify`
`GameService.SelectRole` `GameService.SelectRoleRequest` `GameService.SelectedRole` `GameMode.TDM.*`(抢旗/占点)

### ✅ 换服 / 匹配
`ServerListService.Join`(RF) `ServerListService.JoinAny`(RF) `ServerListService.Cancel`(RF) `ServerListService.UpdateData`
`MatchmakingService.Match`(RF) `MatchmakingService.Cancel`(RF) · `Any.ServerRestart`

### ⚠ 位置 / 心跳 —— 「回退」的来源，重点标记
```
ReplicatedStorage.ClientReplicateCFrame     (客户端上报自己的 CFrame -> 服务端比对)
ReplicatedStorage.ServerReplicateCFrame     (服务端下发)
Remote.Any.Heartbeat                        (RemoteFunction, 定期核对面)
```
→ 飞行/加速被拉回**最可能走这对**；主脚本「防回退」hook 的就是 `ClientReplicateCFrame.FireServer`（随飞行/加速自动开关）。

### ⚠ 踢人 / 离开 / 自杀
`Any.Suicide`(RE) · `GameService.Leave` `GameService.Join` `GameService.JoinLater` `GameService.Respawn` `GameService.Revive`
`GameStarterService.Join/Leave/BypassConfirm/BypassCancel`
→ 客户端踢人主通道仍是 `Player:Kick`（主脚本用 `hookfunction(LP.Kick)` 拦）。

### 其它（管理员 / 命令 / 调试）
`Any.Admin`(RF) · `Any.GetUserInfo`(RF) · `Any.PlayerStats`(RF) · `Any.Code`/`Any.CodeQuery`(RF 兑换码)
`CmdrClient.CmdrEvent`/`CmdrFunction`（**Adonis/Cmdr 管理员框架** —— 说明这游戏装了 Cmdr 管理后台）
`__DEBUG` · `ByteNetReliable`/`ByteNetQuery`/`Shared.BetterReplication.*`（网络框架）
`Replica*`（Replica 复制框架）

---

## 可做功能映射（结论）

| 功能 | 这个游戏能不能做 | 依据 |
|---|---|---|
| 一键全领 / 自动领取 | ✅ 能 | 上面一整排 `*Claim*` |
| 免费抽奖 / 转盘 | ✅ 能 | `Spin.Spin` `GachaService.Gacha` `RaffleService.Join` |
| 商店购买 / 0 元扫货 | ⚠ 要钱的不行 | `*Purchase` 服务端查余额 |
| 卖武器 / 挂市场换钱 | ✅ 能 | `WeaponService.Sell` `PlayerMarketService.*` |
| 自动装备 / 用道具 | ✅ 能 | `TryEquip` `TryUse` |
| 传送（服务端认可） | ✅ 能 | `Any.Teleport` 系列 |
| 队伍操作 | ✅ 能 | `TeamService.*` |
| 换服 | ✅ 能 | `ServerListService.Join/JoinAny` |
| 飞行/加速不被回退 | ⚠ 部分 | 靠 hook `ClientReplicateCFrame` 上报限速 |
| 透视 / 敌我 | ✅ 很准 | `Highlight.Enemy.HighlightHolder` 容器 + `@Health` 属性 |
| 白嫖付费 / 改余额 | ❌ 不行 | 服务端权威 |

## 已知限制 / 注意

- 名字是**中文**的实例（`付费箱子`、`功能区`）说明可用中文关键词匹配。
- `CmdrClient` 存在 → 服务端有 Cmdr 管理台，**管理员能用命令操作你**；本地只能拦客户端动作。
- 这份清单里 289+149 个 remote **绝大多数是"通知/数据同步"**（`*UpdateData`/`*Notice`），
  真正"能让服务端做事"的是上面那批**动词类**（Claim/Purchase/Join/Teleport/Try*）。

---

## ★ 2026-09-21 综合扫描复核（**完整 73 个 remote + 命中链路结论**）

> 来源：本脚本跑「综合扫描」的落盘文件
> `CheatMenu	9661268047775_srv\scan_119661268047775_20260921_005753.txt`。
> ★★ **与另一个服的区别先说清**：本服**没有 `rev_`/`ref_` 前缀、也没有 Packages 包** ——
> 它是**扁平结构**：`ReplicatedStorage.Remote.<服务名>.<名字>`。
> （另一个服「踢一个幸运方块」是 `ReplicatedStorage.Shared.Packages.Network.rev_*/ref_*`。）
> ⇒ 抓包/写脚本时**两套找法不能混用**。

### CombatService（11 个）

| 名字 | 说明 |
|---|---|
| `Action` | 动作 |
| `ActionEvent` | ★ **客户端→服务端 的动作事件**（开火/命中大概率走这里） |
| `Ammo` | ★ 弹药（读它就知道还剩几发 / 该不该换弹） |
| `Confirm` | 确认（对时/对齐用） |
| `PrivateMessage` | 私聊 |
| `SetData` | 下发/同步战斗数据 |
| `SetSimpleWeapon` | 换武器（简化版） |
| `SetSimpleWeapons` | 换武器（简化版·多把） |
| `SetWeapon` | ★ 换武器（主武器） |
| `UnreliableActionEvent` | ★ 同上但走 Unreliable（高频、低延迟） |
| `WeaponMessage` | 武器相关消息 |

### EntityService（9 个）

| 名字 | 说明 |
|---|---|
| `BeDamagedUnreliable` | ★★ **你/他人被打中的反馈通道** —— 监听它就能做「命中确认」 |
| `DamageImmunity` | ★★ **权威的「免伤/免疫」状态** |
| `DamageShield` | ★★ **权威的「无敌盾/减伤」状态** —— 比按属性猜准得多 |
| `FlagsTimeUnreliable` | 状态时间（护盾/免伤剩余？） |
| `HealUnreliable` | 治疗反馈 |
| `Jump` | 跳跃 |
| `KnockbackUnreliable` | 击退反馈 |
| `Spawned` | 实体（玩家/怪）出现 |
| `Teleported` | 实体被传送（位置权威来源） |

### Any（27 个）

| 名字 | 说明 |
|---|---|
| `AFK` | 挂机状态 |
| `AirJump` | 空中跳 |
| `Character` | 角色相关 |
| `ClientTeleported` | 客户端传送通知 |
| `CodeInviteClaim` | 邀请码领取 |
| `CollectionDataUpdate` | 收集数据更新 |
| `CollectrionClaim` | 领取收集奖励 |
| `DropCoin` | 掉金币 |
| `GachaResult` | ★ 抽卡结果 |
| `InstanceMessage_Unreliable` | 实例高频消息 |
| `JumpPad` | 跳板 |
| `LootEventCapture` | ★ 抢夺/战利品事件（**抓取**） |
| `LootEventSettled` | 抢夺结算 |
| `PlaceTeleport` | 换场景传送 |
| `PlaySound` | 播放音效 |
| `Purchased` | 购买完成 |
| `RebackReward` | 回归奖励 |
| `ServerTeleport` | 服务端传送 |
| `SpawnEffect` | 生成特效 |
| `Suicide` | 自杀 |
| `Teleport` | 传送 |
| `Teleporter` | 传送器 |
| `TimeReward` | 时长奖励 |
| `TouchDamage` | ★ 触碰伤害 |
| `WeaponDemo` | 武器试用 |
| `WeaponMessage` | 武器相关消息 |
| `WeaponPreivewPause` | 武器预览暂停 |

### GameService（4 个）

| 名字 | 说明 |
|---|---|
| `GameMode.FFA.FFA_CaptureFlag.DropFlag` | ★ 夺旗（FFA/TDM 抢旗模式） |
| `GameMode.TDM.TDM_CaptureFlag.DropFlag` | ★ 夺旗（FFA/TDM 抢旗模式） |
| `RoomManager.Room.VoteMap` | 投票选地图 |
| `WeaponPickup` | ★ 捡枪 |

### ItemService（2 个）

| 名字 | 说明 |
|---|---|
| `TryUse` |  |
| `UpdateData` |  |

### BackpackService（2 个）

| 名字 | 说明 |
|---|---|
| `SetBackpack` |  |
| `UpdateData` |  |

### RandomShopService（3 个）

| 名字 | 说明 |
|---|---|
| `Gift` |  |
| `Purchase` |  |
| `Refresh` |  |

### Trade（7 个）

| 名字 | 说明 |
|---|---|
| `CancelNotice` |  |
| `CashTradeNotice` |  |
| `Close` |  |
| `ReadyNotice` |  |
| `RequestNotice` |  |
| `SelectNotice` |  |
| `Start` |  |

### BannerService（1 个）

| 名字 | 说明 |
|---|---|
| `Equip` |  |

### Beginner（1 个）

| 名字 | 说明 |
|---|---|
| `OpenShop` |  |

### InstanceDataService（1 个）

| 名字 | 说明 |
|---|---|
| `Request` |  |

### PlayerMarketTradeHistoryService（1 个）

| 名字 | 说明 |
|---|---|
| `Updated` |  |

### Rewards（2 个）

| 名字 | 说明 |
|---|---|
| `NewBieDay7Opend` |  |
| `NewBieDay7WeaponSelected` |  |

### TradeLobby（1 个）

| 名字 | 说明 |
|---|---|
| `CashGun.Drop` |  |

### (顶层)（1 个）

| 名字 | 说明 |
|---|---|
| `EntityService` |  |


### ★★ 战斗（命中判定）链路 —— 本条的**真正价值**

结合同一台机器上那份十层扫描的 B 层（GC 函数表）实锤，本服的命中是**客户端算、再报给服务端**：

| 层 | 证据 |
|---|---|
| 客户端模块名 | `AsyncRaycast`（6 个函数）· **`AutoHitScan`** · `ClientWeapon` · `CommonShootableComponent`（`CanShoot` / `CanShootNow` / `BroadcastShooted` / `EmitFire` / `ClearFire`）· `FireComponent` · `ClientAimableComponent`（`Aim` / `ClearLocalAim`） |
| 服务端通道 | `CombatService.ActionEvent` / `UnreliableActionEvent`（客户端上报动作）· `EntityService.BeDamagedUnreliable` / `TouchDamage`（服务端结算） |

**⇒ 三个「能直接改善打不中」的权威通道（全是纯监听，零副作用）**

| 通道 | 能干什么 | 治哪个毛病 |
|---|---|---|
| `EntityService.BeDamagedUnreliable` | **命中确认**：打中了才收得到 → 收不到就是没中 → 可以立刻补一枪 / 换目标 | 「打不中/没反馈」 |
| `EntityService.DamageShield` / `DamageImmunity` | **权威的无敌盾 / 免伤状态**（现在是靠 `hasShield()` 猜属性） | 「打了没伤害」「该跳过盾的没跳」 |
| `CombatService.Ammo` | **真实弹药数** → 空仓时别瞎按、该换弹就换 | 「看着在开枪其实没子弹」 |

⚠ 反过来，**`CombatService.ActionEvent` / `UnreliableActionEvent` 是"客户端上报"的** ——
理论上可以直接发假命中，但**参数不明 + 服务端可能校验 + 会被记**，**没有实机验证前不要动**。

### ⚠ 其它值得注意

- `GameService.GameMode.FFA.FFA_CaptureFlag.DropFlag` 与 `GameMode.TDM.TDM_CaptureFlag.DropFlag`
  ⇒ 本服**有 FFA 与 TDM 两种模式**；TDM 模式说明**存在队伍** → 敌我透视在 TDM 下可用队伍属性判，
  而在 FFA 下必须靠 `Workspace.Highlight.Enemy.HighlightHolder`（见上一节的权威容器）。
- `Trade`（7 个）+ `PlayerMarketTradeHistoryService` + `TradeLobby.CashGun.Drop` ⇒ **玩家间交易**是完整玩法，
  `rev_MerchantTrade` 那种名字更像**玩家/NPC 交易**，不是"流浪商人"。
- `ItemService.TryUse` / `BackpackService.SetBackpack` / `UpdateData` ⇒ 背包与使用物品的正规入口。
