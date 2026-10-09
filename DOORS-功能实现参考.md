# DOORS 功能实现参考

> 目的：从 GitHub 上**未混淆**的同游戏源码里，找出这几类功能的原始写法：
> 加速 / 飞行 / 无敌 / 锁血 / 回血 / 刷东西 / 不受击。
>
> **本项目已接入的部分见文末第五节。**

---

## 一、DOORS 的完整远程表（最有价值的东西）

所有远程都在 `ReplicatedStorage.Bricks` 下，命名有规律：

| 远程 | 用途 | 调用 |
|---|---|---|
| `Bricks.Revive` | **复活** | `:FireServer()` |
| `Bricks.ClutchHeartbeat` | **保命心跳**（游戏自己的免死机制） | `firesignal(...OnClientEvent)` |
| `Bricks.Caption` | 屏幕字幕 | `firesignal(..., "文本")` |
| `Bricks.DeathHint` | 死亡提示 | `firesignal(..., {...}, "Blue")` |
| `Bricks.UseEventModule` | 房间事件（灯闪） | `firesignal(..., "flickerLights", roomId, 1)` |
| `Bricks.ShadeResult` / `Bricks.Screech` | 躲避结算 / 实体 | `:FireServer()` / `:FireClient()` |

> 这张表是通过 GitHub 代码搜索 `"ReplicatedStorage.Bricks"` 交叉印证得到的（命中 93 个未混淆仓库）。

---

## 二、你要的功能，别人怎么写

### ① 回血 / 复活（5 行全文）

```lua
local Revive = game:GetService("ReplicatedStorage"):WaitForChild("Bricks"):WaitForChild("Revive")
Revive:FireServer()
```

→ **让游戏自己把你复活**，比硬写 `Health` 可靠（位置/状态/UI 全交给游戏）。

### ② 无敌 / 不受伤 —— 这条思路最新鲜

```lua
while true do
  coroutine.wrap(function()
    firesignal(game.ReplicatedStorage.Bricks.ClutchHeartbeat.OnClientEvent)
  end)()
  task.wait(15)     -- 每 15 秒敲一次
end
```

→ 定期假触发 DOORS **自己的"最后关头保命"信号**，等于持续告诉游戏"我刚躲过一劫"。
**不跟游戏对着干，而是借用它的机制。**

### ③ 刷东西 —— 最干净的一种

```lua
local tool = game:GetObjects("rbxassetid://11590476113")[1]   -- 直接拉游戏原本的道具模型
tool.Name = "Crucifix"
tool.Parent = game.Players.LocalPlayer.Backpack               -- 塞进背包
```

→ **不用远程、不用猜参数**，道具本身就是 Roblox 公开资产。
（另一条路是克隆商店条目再把 `Price.Text` 改成 `"0"`。）

### ④ 加速

就是裸写 `Humanoid.WalkSpeed`（XG-HUB 原文），没有压游戏写回那层。

### ⑤ 飞行

可读源码里没出现（都在混淆脚本里），和我们一样是 `BodyVelocity` / 改 `CFrame`。

### ⑥ 体力

`stamina.lua` 是**自己在 `PlayerGui` 画一个体力条**，绕开游戏机制。

---

## 三、资料来源（可复现）

- `ScriptBlox`：按 `placeId` 检索同游戏脚本（`/api/script/search?placeId=6839171747`）
- `GitHub` 代码搜索：`"ReplicatedStorage.Bricks"` → 命中大量未混淆仓库（`retpirato/Roblox-Scripts`、
  `XG-HUB-CN/XG-HUB`、`Triet2804Dev/ScriptRoblox`、`ZepsyyCodesLUA/Utilities`、`DoorsScripterGuy/Doors-Script` 等）
- ⛔ **别在 ScriptBlox/Rscripts 上找实现** —— 主流都是混淆壳，读不到。

---

## 四、对照结论

DOORS 脚本的技术水平**不比我们高** —— 加速那点它们甚至比我们糙（我们多了"压住游戏写回"）。
但它们有两点值得学：

1. **`ClutchHeartbeat`（保命）和 `Revive`（复活）都是让游戏自己去做事**，比我们硬改状态更不容易出问题；
2. **`GetObjects(rbxassetid)` 刷道具**比"丢弃→捡回"直接得多。

---

## 五、我们用了哪些 / 还差哪些

### 已接入（v17.0.45 起，位于「生存页 → DOORS 专属」分节）

| 控件 | 做什么 |
|---|---|
| **保命心跳**（开关 + 间隔滑块） | 周期触发 `Bricks.ClutchHeartbeat`，借用游戏自己的免死机制；⛔ 非 DOORS 游戏里拒绝开启并弹回开关 |
| **原地复活**（按钮） | 发 `Bricks.Revive`，让游戏走自己的复活流程 |
| **复制手持道具**（按钮） | 克隆当前手持道具进背包 |
| **拿道具**（按钮，ID 可留空） | 留空 ⇒ **自动扫描本游戏已有 `Tool` 并克隆进背包**（不需要知道资产 ID） |

### 差距（已补齐）

原先列出的「差三条」——保命心跳 / 复活 / `GetObjects` 刷道具/克隆现成道具 —— **都已在 v17.0.45~46 接上**，
其中「刷道具」在 v17.0.46 进一步改成**全自动扫描本地已有道具**（手填资产 ID 这条路本身不成立：
运行中的客户端推不出道具的购买资产 ID，本地扫到的 `rbxassetid://` 几乎全是网格/贴图）。
