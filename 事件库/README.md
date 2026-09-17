# 游戏 Remote 事件知识库

> 抓包服务器里游戏的 Remote 清单，按功能分类沉淀。以后要做新功能（自动捡东西、自动购买、自动换弹、跳过动画……）时，先来这里查有没有对应的 Remote 信号。

## 目录结构

- `README.md` —— 本说明 + 分类索引
- `2026-09-17_MM2类游戏.md` —— 第一次抓包（119 个 RemoteEvent + 2 BindableEvent + 9 BindableFunction + 26 ProximityPrompt + 4 ClickDetector）

## 怎么用

每个游戏服务器抓一份清单，单独存一个 `YYYY-MM-DD_游戏名.md`，里面按功能分类。做新功能时先 grep 关键词。

## 分类索引（通用套路）

Roblox 游戏的事件命名有套路，跨游戏也大体一致：

| 功能 | 常见命名关键词 |
|------|--------------|
| 战斗/伤害 | `Combat`、`Damage`、`Hit`、`Killed`、`Death`、`Die` |
| 装备/武器 | `Equip`、`Unequip`、`Gear`、`Tool`、`Weapon` |
| 物品/背包 | `Inventory`、`Item`、`Stack`、`Replica`（复制框架） |
| 交易 | `Trade` |
| 商城/购买 | `Buy`、`Purchase`、`Product`、`Gamepass`、`Refund` |
| 社交/好友 | `Friend`、`Postie`、`Social`、`Reward` |
| 角色/移动 | `Character`、`Teleport`、`Respawn`、`Spawn` |
| 表情/动画 | `Emote`、`Animate`、`Highlight` |
| 拾取/掉落 | `Pickup`、`Collect`、`Orb`、`Loot`、`Drop` |

## 已知信号（第一次抓包已沉淀）

见 `2026-09-17_MM2类游戏.md`。关键结论：

- **死亡/击杀**：`MadworkCombat_CombatEvent` / `MadworkCombat_CombatUpdate`（这个游戏用 Madwork 战斗框架，战斗状态走这两条，不是独立的 Killed/Died）。
- **装备切换**：`Equip` / `EquipProgress` / `Unequip` / `UnequipProgress` / `RequestGear`。
- **物品数据**：`Replica_*`（Replica 数据复制框架，物品/属性变更走这一族）+ `InventoryViewResponse` / `RequestInventoryView` / `RequestItems`。
- **商城**：`RequestBuy` / `BuyProduct` / `BuyGamepass` / `BoxBuy` / `ProductPurchased` / `Refunds`。
- **社交**：`PostieSent` / `PostieReceived`（内置聊天）+ `UpdateFriendship` / `FriendRewardReceived`。

> ⚠️ 这个游戏**没有独立的"换弹/reload"Remote** —— 换弹是纯客户端动画，没有网络信号。要做"别人换弹检测"只能客户端观察武器状态（手上有没有 Tool），不可靠。
