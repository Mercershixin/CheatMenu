# 2026-09-17 · MM2 类游戏（第一次抓包）

- **时间**：2026-09-17 23:58
- **总量**：RemoteEvent 119 + RemoteFunction 0 | BindableEvent 2 + BindableFunction 9 | ProximityPrompt 26 + ClickDetector 4
- **来源**：`SYS.DumpRemotes()` 全方位扫描（1.txt）
- **战斗框架**：Madwork（`MadworkCombat_*`）

## 一、战斗 / 伤害 / 死亡

| 事件 | 路径 | 说明 |
|------|------|------|
| `MadworkCombat_CombatEvent` | `ReplicatedStorage.Shared.Remote.RemoteEvents` | 战斗事件（命中/伤害/击杀都走这条） |
| `MadworkCombat_CombatUpdate` | 同上 | 战斗状态更新 |
| `DamageDenyInform` | 同上 | 伤害被拒（无敌/护盾）提示 |
| `DeathEffects_ClearAll` / `DeathEffects_ClearPersisting` | 同上 | 死亡特效清理 |

> ⚠️ **没有独立的 `Killed`/`Died` Remote**。死亡判定走 `MadworkCombat_CombatEvent`，需要解析参数才知道是不是击杀。

## 二、装备 / 武器

| 事件 | 说明 |
|------|------|
| `Equip` / `EquipProgress` | 装备武器（+进度） |
| `Unequip` / `UnequipProgress` | 卸下武器（+进度） |
| `RequestGear` | 请求装备 |
| `SetAbilityHotkey` | 设置技能快捷键 |
| `UseMurdererAbility` | 使用杀手技能 |
| `KnifePowerTeleportEffect` | 刀传送特效 |

> **换弹无信号**：换弹是纯客户端动画，没有 Remote。

## 三、物品 / 背包 / 复制

| 事件 | 说明 |
|------|------|
| `Replica_ReplicaArrayInsert/Remove/Set` | Replica 框架：数组增删改 |
| `Replica_ReplicaCreate/Destroy/SetParent/SetValue/SetValues/Write/Signal/RequestData` | Replica 框架：数据复制全套 |
| `InventoryViewResponse` / `RequestInventoryView` | 背包查看请求/响应 |
| `RequestItems` | 请求物品 |
| `CraftItems` / `CraftEvent` / `CraftAnnounce` | 合成 |
| `SplitStack` / `Stack` / `Unstack` / `StackOperationSuccess` | 物品堆叠/拆分 |

## 四、交易

| 事件 | 说明 |
|------|------|
| `RequestTrade` | 发起交易 |
| `UpdateTradeHighlights` | 更新交易高亮 |

## 五、商城 / 购买

| 事件 | 说明 |
|------|------|
| `RequestBuy` / `BoxBuy` | 购买 |
| `BuyEventItem` / `BuyGamepass` / `BuyProduct` | 买事件物品/通行证/产品 |
| `ItemBuyEvent` | 物品购买事件 |
| `ProductPurchased` / `GamepassPurchased` | 购买成功回调 |
| `Refunds` | 退款 |
| `FriendBoxBuy` | 好友盒子购买 |
| `PurchasePromptEnded` | 购买提示结束 |

## 六、社交 / 好友

| 事件 | 说明 |
|------|------|
| `PostieSent` / `PostieReceived` | 内置聊天（收发） |
| `UpdateFriendship` | 更新好友关系 |
| `FriendRewardReceived` / `FriendRewardReceivedBox` / `FriendTokensReceived` | 好友奖励 |
| `FriendUIOpened` / `FriendOnAutoWindowShow` / `RequestFriendReward` | 好友 UI |

## 七、角色 / 移动 / 传送

| 事件 | 说明 |
|------|------|
| `CharacterReset` | 重置角色 |
| `CharacterService_ApplyForceToCharacter` | 给角色施加力 |
| `CharacterService_CharacterGrounded` | 角色落地 |
| `CharacterService_CharacterWaterStateChange` | 角色入水状态 |
| `CharacterService_DestroyCharacter` | 销毁角色 |
| `CharacterService_LookAngle` | 角色朝向 |
| `CharacterService_TeleportCharacter` | 传送角色 |
| `TeleportToGameMode` / `TeleportToJobId` / `TeleportToServer` | 传送（模式/JobId/服务器） |

## 八、表情 / 动画

| 事件 | 说明 |
|------|------|
| `RequestEmote` / `GlobalEmote` / `HighlightEmote` / `StopEmote` | 表情 |
| `HighlightMobileButtons` | 高亮移动端按钮 |
| `UpdateMobileButtons` | 更新移动端按钮 |

## 九、拾取 / 掉落 / 事件玩法

| 事件 | 说明 |
|------|------|
| `OrbAnnounce` / `OrbPickupApproved` / `OrbPickupRequest` / `OrbWipe` | 球（Orb）拾取 |
| `RatCatch` | 抓老鼠 |
| `RouletteAnnounce` / `RouletteClaimConfirm` / `RouletteEvent` | 轮盘 |
| `BouncyBalls` | 弹球 |
| `AMOGUS` | Among Us 玩法 |
| `EventItemAnnounce` / `EventRefundConfirm` | 活动物品 |
| `PetMineAction` | 宠物挖矿 |
| `PickGameTeam` | 选队伍 |
| `StartingNow` / `PreSpawnDarken` / `PreloadComplete` | 开局流程 |
| `MilestoneRewardReceived` / `RequestMilestoneReward` | 里程碑奖励 |
| `DailyRewardReceived` / `RequestDailyReward` | 每日奖励 |
| `SocialRewardsCheck` / `SocialRewardsClaim` / `SocialRewardsClaimSuccess` / `SocialRewardsError` / `SocialRewardsScreenOpened` | 社交奖励 |
| `PollResponse` / `PollBooth` | 投票 |

## 十、系统 / 工具

| 事件 | 说明 |
|------|------|
| `GameAnalyticsError` / `GameAnalyticsRemoteConfigs` | 分析/配置 |
| `LatencyService_Ping` / `LatencyService_SendServerTime` | 延迟检测 |
| `SendCommand` / `CommandText` / `CommandOutput` / `CommandItemsReceived` | 命令系统 |
| `GetServerData` | 获取服务器数据 |
| `SetSetting` | 设置 |
| `SetLastSeenUpdateId` | 最后可见更新 |
| `ServerWindowOpened` | 服务器窗口 |
| `UserStreamService_UserStream` | 用户流 |
| `OnPlayerReadyEvent`（BindableEvent） | 玩家就绪 |

## 关键结论（供以后做功能参考）

1. **击杀/死亡** → `MadworkCombat_CombatEvent`，不是独立 Killed。
2. **换弹** → 无信号，纯客户端动画。
3. **物品背包** → `Replica_*` 框架，别人背包不会复制到本地。
4. **购买** → `RequestBuy` + 一堆 `Buy*` / `*Purchased` 回调。
5. **拾取** → `OrbPickupRequest`（主动请求）+ `OrbPickupApproved`（批准）。
