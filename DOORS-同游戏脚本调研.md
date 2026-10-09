# DOORS 同游戏脚本调研

> 目的：查清「DOORS 这个游戏的公开脚本都在做什么、能不能读到实现」。
> 本轮**没有改动任何脚本代码**。

---

## 一、游戏确认（硬证据）

| 项 | 值 |
|---|---|
| 游戏 | **DOORS**（Roblox 开门恐怖游戏） |
| universeId | `2440500124` |
| 你当前所在 place | `6839171747`（Roblox 客户端日志里的 join 记录对得上） |
| 佐证 | 从 GitHub 拉到的脚本源码里全是 DOORS 的界面路径：`MainUI` / `ItemShop` / `ItemShop_Vitamins` |

> 另外提醒：你还有个常玩地点 `111543903102439`，那是 **24 HOURS**，图标完全不同，别和 DOORS 混。
> （排查过程中曾被日志里的 `PaperPlane` 工具名带偏，误以为是 PAPER PLANES —— 那是误判，已更正。）

---

## 二、同游戏脚本的现状 —— 有个坏消息

ScriptBlox 上搜 `DOORS` 共 **46 页**（约 920 条），但：

- **DOORS 专属脚本只有 6 个**，其余全是 Flow Hub / Snowy Hub / MOLYN HUB 这类**全游戏通用 hub**。
- **主流的那几个全部做了混淆**：
  - `DOORS SCRIPT XENO OPTIMIZED`（19921 浏览）真身是 **152 KB 的 wearedevs 混淆**代码；
  - `FEROX` 更是 **577 KB 混淆**；
  - `Twinkhook` 直接被 Cloudflare 挡住。
  - **这些读不到写法。**

`ScriptBlox` 的 raw 端点支持按 `placeId` 查该游戏的脚本（`/api/script/search?placeId=...`），
是"找同游戏脚本"最省事的入口。

---

## 三、但有两个小脚本没混淆，正好覆盖两项

**① 回血 / 复活** —— `REVIVE SCRIPT (HOTEL-ONLY)` 全文就 5 行：

```lua
local Revive = game:GetService("ReplicatedStorage"):WaitForChild("Bricks"):WaitForChild("Revive")
Revive:FireServer()
```

**顺带挖到一个重要的东西**：**DOORS 的远程都在 `ReplicatedStorage.Bricks` 这个文件夹里**，而且命名有规律。
这条线索比脚本本身值钱 —— 有了它，后续功能就不用瞎猜远程名。

**② 刷东西** —— `Gubby Tool` 走的是另一条路：**不猜远程，直接改商店**

```lua
local NewItemOk = PlayerGui.MainUI.ItemShop.Items.ItemShop_Vitamins:Clone()
NewItemOk.Name = "ItemShop_Gubby"
NewItemOk.Price.Text = "0"     -- 价格置 0，让游戏自己把它当商品卖给你
```

---

## 四、你列的那批功能，对照结果

| 你要的 | 别人的做法 | 我们（CheatMenu） |
|---|---|---|
| 加速 | 写 `Humanoid.WalkSpeed` | **已有**（+ 压住游戏写回，它们不做）|
| 飞行 | `BodyVelocity` / 每帧改 `CFrame` | **已有** |
| 无敌 · 锁血 · 不受伤 | 写 `Health` + 断伤害连接 + 钩 `TakeDamage` | **已有**（`F.GodTopUp` + 生命守卫，且带状态还原）|
| 回血 | 循环顶满 `Health` | **已有** |
| **刷东西** | **发远程** 或 **商店 `Price = 0`** | 我们走的是「丢弃→捡回」，**路子不一样** |

**结论**：DOORS 脚本的技术含量**不比我们高**。它们的优势是"不做反检测、不做状态还原、不做开关门禁"，
所以代码短、上手快；代价是更容易被游戏发现、也更容易留残留。我们反而更复杂更稳。

---

## 五、下一步（需要你在 DOORS 里点一下）

我们脚本里有个 **「系统页 → 全扫描」** 功能，它会把游戏里的远程和界面结构列进日志。
**在 DOORS 里点一次**，就能把 `ReplicatedStorage.Bricks` 底下的远程全挖出来 ——
有了那张表，「复活 / 刷东西」这类功能就不用猜远程名和参数了，可以照着接。
