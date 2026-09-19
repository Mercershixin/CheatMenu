# 游戏 Remote 事件知识库

> 抓包服务器里游戏的 Remote 清单，按功能分类沉淀。以后要做新功能（自动捡东西、自动购买、自动换弹、跳过动画……）时，先来这里查有没有对应的 Remote 信号。

## 目录（★ 按游戏分组 —— 三份清单分属【两个不同游戏】，别混用）

| 文件 | 属于哪个游戏 | 内容 | 规模 |
|------|------------|------|------|
| `2026-09-17_MM2类游戏.md` | **MM2 类**（Madwork 战斗框架：`MadworkCombat_*`） | 按功能分类的清单 | RemoteEvent 119 + BindableEvent 2 + BindableFunction 9 + ProximityPrompt 26 + ClickDetector 4 |
| `2026-09-17_MM2类游戏_原始抓包.txt` | 同上 | `SYS.DumpRemotes()` 原始输出 | 同上一份 |
| `2026-09-18_完整Remote清单+战斗诊断.txt` | ⚠️ **不是 MM2**（特征：`Season`/`Rebirth`/`Trade`/`Cash`/`Skin`/`Room`/`Claim`，疑似模拟经营类）；**文件末尾还混了战斗诊断日志** | 全量 dump | 447 个 Remote 相关名 |

## ⚠️ 已知缺口（2026-09-19 分析）

1. **当前在玩的 MachineParty 没有专项清单。**
   它的权威数据不在 Remote 里，而在 Player 的 `MP*` Attribute（`MPGhost`/`MPScrap`/`MPTier`/`MPWalkSpeed`…）
   —— 这条见仓库 README 的「这个游戏的关键事实」一节。**下次抓包务必单独存一份 `YYYY-MM-DD_MachineParty.md`。**
2. `2026-09-18` 那份**文件名没写游戏名**，且**内容里混了诊断日志**，检索时会干扰。
3. 事件库里 **461 个事件名中有 417 个从没被主脚本用到** —— 下面「未覆盖索引」列出可做功能的机会。

## 未覆盖索引（有事件、但还没有对应功能）

| 功能域 | 未覆盖数 | 代表事件（可直接做功能） |
|--------|---------|------------------------|
| 🛒 购买 / 商城 / 奖励 | **69** | `BuyProduct`、`BuyGamepass`、`ClaimReward`、`ClaimWeeklyCase`、`ClaimPremiumReward`、`ClaimRebirthReward`、`ClaimSeasonWeapon`、`ClaimStall`、`ClaimTradeTokenReward`、`BoxBuy`、`BuyEventItem`、`CollectrionClaim` |
| 📦 拾取 / 收集 / 物品 | **58** | `DropCoin`、`LootEventCapture`、`LootEventSettled`、`CraftItems`、`CommandItemsReceived`、`CollectionDataUpdate`、`CollectorsPodium`、`InventoryQueryService` |
| 🎮 玩法 / 游戏流程 | **24** | `RoundStart`、`RoundEnd`、`RoundResult`、`GameStart`、`GameEnd`、`GameMode`、`PickGameTeam`、`GamepassPurchased` |
| 🔄 重生 / 传送 / 角色 | **18** | `CharacterReset`、`CharacterService_TeleportCharacter`、`CharacterService_ApplyForceToCharacter`、`CharacterService_DestroyCharacter`、`SpawnArea`、`TeleportToGameMode` |
| 💀 战斗 / 伤害 / 死亡 | 8 | `DamageDenyInform`、`DeathEffects_ClearAll`、`DeathEffects_ClearPersisting`、`TouchDamage`、`CashGunFire` |
| 💬 聊天 / 社交 / 公告 | 若干 | `CenterHintMessage`、`CancelNotice`、`CashTradeNotice`、`EventItemAnnounce` |
| 🛡 管理 / 系统 | 若干 | `CharacterService_*` 系列、`CmdrClient` |

> 复现这份分析：`python .workbuddy/build/_event_gap.py`（提取事件名 → 剔除开关 key/Roblox 类名 → 与主脚本正文比对）。

## 怎么用

每个游戏服务器抓一份清单，单独存一个 `YYYY-MM-DD_游戏名.md`（**游戏名一定要写**），里面按功能分类。做新功能时先 grep 关键词。

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
- **社交**：`PostieSent` / `PostieReceived`（内置聊天）。

---

## 🔄 持续抓包流程（新增游戏时怎么做）

> **目标**：新游戏抓包后，**不改一行代码**就让已支持的功能（回血/复活/重生/购买/领取/拾取…）自动认它。

### 1. 抓包（★ 6.9.0 起自动带游戏名）
在游戏里执行 `SYS.DumpRemotes()`，它会：
- 输出头部自动带上 **游戏名 / PlaceId / GameId / CreatorId / JobId / 抓包时间**
  （游戏名走 `MarketplaceService:GetProductInfo(PlaceId)`；拿不到就退化成 `Place<PlaceId>`，**PlaceId 一定有**）
- **自动落盘**到执行器工作目录，文件名形如：
  `Remotes_<游戏名>_<PlaceId>_20260919_1445.txt`
  （Windows 非法字符自动替换成 `_`，中文保留；执行器不能写文件时会提示手动复制）

> 所以**不用再手动命名了** —— `2026-09-18_完整Remote清单+战斗诊断.txt` 那种"没游戏名"的情况不会再发生。
> 从工作目录把该文件拷进 `事件库/` 时，按 `YYYY-MM-DD_游戏名.md` 重命名即可（文件头里已经有准确游戏名）。

单独查游戏标识：`SYS.GameInfoLine()` → `游戏: xxx | PlaceId: ... | GameId: ... | CreatorId: ... | JobId: ...`

### 2. 入库
按功能域分类整理，格式照 `2026-09-17_MM2类游戏.md`（每个域一张表）。

### 3. 让功能自动认它（关键机制）
代码里有一张**跨游戏别名表** `SYS.RemoteAlias` + 一张**关键词表** `SYS.RemoteKeywords`。
查找走 `SYS.FindEvent(kind)`：**先按别名精确找，找不到就按关键词扫整个 Remote 树**。

| 功能类 | 别名表已覆盖的常见命名 |
|--------|----------------------|
| `heal` | `EntityService.Heal` / `Heal` / `RequestHeal` / `HealSelf` / `Regen` / `RestoreHealth` / `HealPlayer` |
| `revive` | `GameService.Revive` / `Revive` / `RequestRevive` / `ReviveSelf` / `Resurrect` |
| `respawn` | `GameService.Respawn` / `Respawn` / `RequestRespawn` / `CharacterReset` / `Reset` |
| `buy` | `BuyProduct` / `Buy` / `Purchase` / `BuyGamepass` / `BoxBuy` / `RequestBuy` |
| `claim` | `ClaimReward` / `Claim` / `ClaimDaily` / `ClaimBonus` / `ClaimWeeklyCase` / `ClaimPremiumReward` |
| `pickup` | `Pickup` / `Collect` / `Loot` / `DropCoin` / `Grab` |
| `sell` | `Sell` / `SellItem` / `RequestSell` |
| `trade` | `Trade` / `RequestTrade` / `CashTrade` |
| `chat` | `Chat` / `SendMessage` / `PostieSent` |
| `round` | `RoundStart` / `RoundEnd` / `GameStart` / `GameEnd` |
| `teleport` | `Teleport` / `RequestTeleport` / `JoinServer` / `CharacterService_TeleportCharacter` |
| `kick` | `Kick` / `KickPlayer` / `Ban` |

**命名落在表里 → 功能自动生效**；不在表里 → 往 `SYS.RemoteAlias` / `SYS.RemoteKeywords` 各加一行就好。

### 4. 现场探测（不改代码就能查）
抓包时顺手在控制台跑这几行，直接知道新游戏支持哪些功能：

```lua
SYS.ProbeEvent("heal")      -- -> 🔎 heal -> 命中 EntityService.Heal (alias)
SYS.ProbeEvent("revive")    -- -> 🔎 revive -> 命中 GameService.Revive (alias)
SYS.ProbeEvent("respawn")
SYS.ProbeEvent("buy")
SYS.ProbeEvent("claim")
SYS.ProbeEvent("pickup")
```

输出两种形态：`命中 <名字> (alias|fuzzy)` 或 `本游戏没有`。

### 5. 菜单里的对应入口
「玩家」页有一组通用按钮，已接入这套查找：
- **作用对象**：自己 / 选中的人（下拉）
- 🩹 回血 · ✨ 复活 · ♻ 重生 · ⚡ 自动三连（三个都试一遍）
- 🔎 探测本游戏有哪些（回血/复活/重生）
