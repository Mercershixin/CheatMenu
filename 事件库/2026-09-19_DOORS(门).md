# DOORS（`门 (游戏)`）—— Remote / 信号清单（2026-09-19 抓包）

> 游戏：`门 (游戏)` = Roblox **DOORS**
> PlaceId **6839171747** · GameId 2440500124 · CreatorId 3049798
> JobId `34260832-7249-410b-9660-e1e84ee0eada`
> 抓包时间：2026-09-19 21:47:51（执行器「🔍 综合扫描」，正在跑局内）
> 原始清单：`2026-09-19_DOORS(门)_原始抓包.txt`（362 条）
> 已接进主脚本：**6.10.1**（`SYS.RemoteAlias` / `SYS.RemoteKeywords` / 死亡订阅多容器查找 / 门透视「假门=红」）

## 规模

| 类型 | 数量 |
|---|---|
| RemoteEvent | **172** |
| RemoteFunction | **19** |
| BindableEvent | 116 |
| BindableFunction | 5 |
| ProximityPrompt | 50 |

## ★★ 第一句话：所有玩法 remote 都在 `ReplicatedStorage.RemotesFolder`

**不叫 `Remote`，叫 `RemotesFolder`，而且事件全部【平铺】在里面**
（没有 `GameService` / `EntityService` / `Any` 那种分层）。

→ 这就是 6.10.1 之前控制台一直刷这条的原因：

```
[CheatMenu] 80 秒内没等到 ReplicatedStorage.Remote -> 死亡事件没订上(会退化回 Humanoid 判断)
```

→ 已修：死亡订阅现在按 **容器候选 + 平铺名字 + 关键词兜底** 三级找（见 CHANGELOG 6.10.1）。

---

## 🚪 门 / 假门（实例层，不是 remote —— 这才是"假门"的答案）

### 门长这样（局内 `Workspace.CurrentRooms.<间号>`）

```
Workspace.CurrentRooms.33.Door.Func_Open          (BindableEvent)
Workspace.CurrentRooms.33.Door.Func_Close         (BindableEvent)
Workspace.CurrentRooms.33.Door.Func_Lock          (BindableEvent)
Workspace.CurrentRooms.33.Door.Func_ForceOpen     (BindableEvent)
Workspace.CurrentRooms.33.Door.ClientOpen         (RemoteEvent)
Workspace.CurrentRooms.33.Door.ManualOpenPrompt   (ProximityPrompt)
Workspace.CurrentRooms.33.Lock.Event              (BindableEvent)
Workspace.CurrentRooms.33.Lock.UnlockPrompt       (ProximityPrompt)
```

- **正常门** = 名叫 **`Door`** 的模型；也有直接叫 **`DoorNormal`** 的
  （`CurrentRooms.37/38/39.DoorNormal.ManualOpenPrompt`）
- ★★ **假门 = `DoorFake`** —— 实测出现在
  `Workspace.CurrentRooms.39.SideroomDupe.DoorFake.*`
  （`SideroomDupe` = 那种"**复制出来的侧房**"；另有 `Misc/FloorReplicated...PortraitDupePrompt` 同类命名）
- 交互通道：`HitDoor`（撞门）、`Interaction_Door`（按 E 交互）、`Door.ClientOpen`
- 开门相关道具提示：`PadlockHint`

→ 判据落地：名字或 3 层祖先名含 `fake / dupe / false / 假门 / 伪装` → **门透视标红**（6.10.1）。

---

## 关键 Remote（按功能分类）

### 💀 死亡 / 重生
`PlayerDied` · `DeathHint` · `DeathTickDelay` · `Ragdoll` · `PlayAgain` · `Lobby` · `BattleRequeue`
· `ContinueOrSave`(RF) · `HostStartMatch`

### ✨ 复活（这游戏复活是玩法核心）
`Revive` · `ReviveFriend` · `CheckRevive`(RF) · `ObtainGiftedRevive`(RF) · `ReviveRift.RevivePrompt`(Prompt)
· `ReplicaDataModule.RevivesUpdated`

### 🎒 道具 / 背包 / 装备
`Inventory` · `RequestInventory`(RF) · `RequestItemInfo`(RF) · `Equip` · `DropItem`
· `UsePowerup` · `UseEnemyModule` · `UseEventModule` · `Item_MeleeReplication` · `Item_MiscReplication`
· `GetCleanTool`(RF) · `ReplicaDataModule.ItemsUpdated` / `ItemsEquippedUpdated` / `KnobsUpdated`

### 🚪 躲藏（藏衣柜/床躲怪）
`HidePickup` · `GetOutOfHiding` · `HidePrompts`(BindableEvent) · 角色属性 `Hiding`

### 💰 商店 / 氪金 / 存档数据
`PreRunShop` · `RequestShop`(RF) · `PurchaseShopItem`(RF) · `InventoryShopFunc`(RF) · `GiftProduct`(RF)
· `GotGift` · `ProductPurchased` · `ShopCode` · `GetCurrency` · `GetUGC`(RF) · `CheckRank`(RF)
· `SaveHandler`(RF) · `DeleteSave` · `ReplicaRemoteEvents.Replica_*`（数据复制框架一族）

### 🛗 电梯 / 楼层（每局流程）
`ElevatorStart` · `ElevatorJoin` · `ElevatorExit` · `ElevatorFinished` · `ElevatorMatchFound`
· `ElevatorMaxWarning` · `CreateElevator` · `CreateSavedElevator` · `LotusElevatorStarted` · `UpdateFloor`

### ➲ 传送 / 换服
`Teleport` · `TeleportFailed` · `ServerTeleported` · `SwitchServers` · `IsNotPrivateServer`(RF)
· **`SkipToRoomNumber`（BindableFunction —— 本地直接调，跳房间）**

### 🎮 小游戏 / 事件
`EngageMinigame` · `EndChaosMinigame` · `MinigameControl` · `UpdateMinecartNodes` · `MinecartResult`
· `ShadeResult` · `SurgeRemote` · `MonumentEvent.ReliableEvent` · `ChaosTalkToServer`

### 💬 聊天 / 播报
`Caption` · `CaptionWithChat` · `SystemMessage` · `CaptionClient`(BindableEvent) · `PointsNotification`
· `Promo` · `CandyAnnounce` · `Remind` · `AchievementDisplay` / `AchievementProgress` / `AchievementUnlock`

### 🎥 视角 / 画面（很多是本地 Bindable，触发只影响自己）
`CamShake` · `CamShakeRelative` · `CamLock` · `CamLockHead` · `Vignette` · `EndLighting` · `FigureLight`
· `FlashSpecify` · `LightningStrike` · `ClientLightningStrike` · `Cutscene` · `CutsceneFollowup` · `ReplicateTween`

### 🧑 PlayerGui / MainUI 里的本地 BindableEvent（第一人称武器那套）
`Event_AutoFire` · `Event_FireWeapon` · `Event_RepositionViewmodel` · `Event_Sprinting` · `Event_Unease`
· `Event_Unequip` · `ToggleInventory` · `StopHeartbeat` · `Topbar...Gold`

---

## ★ 权威数据：Player / Character Attribute（服务端写、客户端可读）

**Player**：`AFK` · `Alive` · `CurrentRoom` · `DataLoaded` · `GlitchLevel` · `ReadyForFreddy` · `RVM`
· `LVY` · `LookVector` · `UsedRift`

**Character**：`Alive` · `Crouching` · `DoorsOpened` · `Hiding` · `InventoryCap` · `Oxygen`
· `SpeedBoost` · `Stunned` · `SubdoorsOpened` · `Underwater` · `_HIDATALL`

**玩家脚本（可 hook）**：`PlayerScripts.main` · `Options` · `DoorHandleOptimizer` · `HidingManager`
· `NonGameModuleHandler` · `GameModuleHandler` · `Firedamp` · `Camera`

→ 判活读 `Alive`、判躲藏读 `Hiding`、判在哪一间读 `CurrentRoom` —— 比猜 Humanoid 靠谱。
→ 探怪模块叫 `Firedamp`（客户端模块，名字可疑，值得单独看）。

---

## ⛔ 别碰的东西

1. **`DroneStickyNoteMyNameIsExploiterAndIThinkICanCheatWithThis`**
   —— 名字就直接写着"我叫 exploiter，我觉得我能用这个作弊"。**这是开发者摆的蜜罐/嘲讽**，
   服务端大概率在盯着它被谁触发。**绝对不要 fire**。
2. `AdminPanelRunCommand` · `SendErrorLog` · `ServerLog` —— 管理/日志通道，纯服务端用途。
3. `conch_networking.*`（`create_user` / `invoke_server_command` / `log` / `register_command` /
   `update_user_roles` …）—— 第三方网络/权限框架，动它等于自报家门。
4. `ReplicaRemoteEvents.Replica_*` —— 数据复制框架。**只读监听可以，写它就是在改服务端数据**。

---

## 可做功能映射（结论）

| 功能 | 能不能 | 依据 |
|---|---|---|
| 透视玩家 / 判活判躲藏 | ✅ 能，而且很准 | 角色 `Alive` / `Hiding` / Player `CurrentRoom` |
| **门 / 假门 透视** | ✅ 能（6.10.1 起假门标红） | `Door` / `DoorNormal` / **`DoorFake`** |
| 死亡/复活信号订阅 | ✅ 能（6.10.1 修好） | `PlayerDied` / `Revive` / `ReviveFriend` |
| 跳房间 | ✅ 能 | `SkipToRoomNumber`（BindableFunction，本地直接调） |
| 本地画面效果（震屏/晕影/闪电/字幕） | ✅ 能（只影响自己） | `CamShake*` / `Vignette` / `LightningStrike` / `Caption` |
| 读背包 / 读商店 | ✅ 能（只读） | `RequestInventory`(RF) · `RequestShop`(RF) |
| 0 元买道具 / 白嫖复活 | ❌ 不行 | `PurchaseShopItem` / `GiftProduct` 都是 RF，服务端查余额 |
| 刷物品 / 改金币 | ❌ 不行 | `Replica_*` 写的是服务端数据，客户端写无效 |
| 让怪物不刷 / 关掉跳脸 | ❌ 不行 | `Screech` / `Jumpscare` / `HideMonster` 由服务端驱动 |

---

## 归档说明

- 归档时间：2026-09-19 21:5x
- 归档动作：执行器 workspace（`%LOCALAPPDATA%\Real\workspace\`）里的 `Remotes_门 (游戏)_6839171747_20260919_2147.txt`
  （文件名中文在资源管理器里显示成乱码，内容本身是正常 UTF-8，26.5 KB / 362 条）
- 主脚本已按这份清单补全 → **6.10.1**（见仓库 `CHANGELOG.md`）
