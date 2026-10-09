# Roblox 多游戏功能实现参考

> 目标：把「飞行 / 加速 / 无敌 / 锁血 / 回血 / 不受击 / 刷东西」这几类功能，从**多个游戏、多个公开脚本**里各找几种真实写法，供对照学习。
>
> 来源：GitHub 上**未混淆**的公开脚本（GitHub 源码基本不做混淆，能直接读；ScriptBlox / Rscripts 上主流的多是混淆壳，读不到）。
>
> 覆盖游戏类型：Murder Mystery 2、Lumber Tycoon 2、Jailbreak、Prison Life、FieldTripZ、Build A Boat For Treasure、Smash & Grab Simulator、Speed Run Simulator、Unicorn Tycoon、Feed The Noob、Steal an Egg、DOORS，以及大量「通用 hub」。

---

## 一、来源清单

| 仓库 / 文件 | 覆盖游戏 | 有参考价值的点 |
|---|---|---|
| `retpirato/Roblox-Scripts` · `Topkek.lua`（162KB） | 通用（FE 全能） | God / Semigod、Fast / Superslow、Take Tools / BTools、GetObjects |
| `retpirato/Roblox-Scripts` · `MM2.lua` | Murder Mystery 2 | 经典 `BodyGyro + BodyVelocity` 飞行 |
| `retpirato/Roblox-Scripts` · `FDTGui.lua`（109KB） | 通用 | 工具箱 |
| `dannythehacker/Hyperlib` · `Scripts/Autoadd/*.lua` | FieldTripZ、Build A Boat… | **远程回血当无敌**、刷道具、WalkSpeed 输入框 |
| `adrzz201108-hue/LyanMenuRoblox` · `Aimbot_Pronto_Final.lua`（164KB） | 通用（多游戏） | **HealthChanged 锁血**、BodyVelocity 飞行、**远程名模式表**刷武器、克隆 Tool |
| `BeefReal/VisualWave-V1` · `modules/Combat.lua` | 通用模块 | 最干净的 Fly / InfiniteJump 模块（可停、返回清理函数） |
| `speedstarkawaii/nyx` · `libs/misc.lua` | 工具库 | `GetObjects` / `getconnections` / `sethiddenproperty` 封装 |
| `Chocapikk/PersonalRobloxScripts` | Speed Run Sim / Unicorn Tycoon / Feed The Noob 等 | 单游戏脚本的 InfiniteJump 写法 |
| `JustBxnt/steal-an-egg-optimizm` | Steal an Egg | 免伤 = 替换 `Humanoid.TakeDamage` |

---

## 二、逐功能对照（含原文片段）

### 1. 飞行 · Fly

**主流写法 = `BodyGyro`（定姿态）+ `BodyVelocity`（给速度），挂在 HumanoidRootPart / Torso 上，并置 `PlatformStand = true`。**

`BeefReal/VisualWave-V1` 的模块版最干净：

```lua
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.P = 9e4
bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
bodyGyro.CFrame = root.CFrame
bodyGyro.Parent = root

local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
bodyVelocity.Parent = root

-- 每帧：速度 = 相机方向 * 速度；姿态 = 相机朝向
bodyVelocity.Velocity = getVelocity()
bodyGyro.CFrame = workspace.CurrentCamera.CFrame
```

`LyanMenuRoblox` 用 `math.huge` 代替 `9e9`，并**在起飞/落地时切 `PlatformStand`**：

```lua
if Configs.Fly and hrp and hum then
    if not flyingState then
        flyingState = true
        hum.PlatformStand = true                     -- ★ 关键：不然动画/物理会和 BodyVelocity 打架
        flyVel  = Instance.new("BodyVelocity", hrp)
        flyVel.MaxForce  = Vector3.new(math.huge, math.huge, math.huge)
        flyGyro = Instance.new("BodyGyro", hrp)
        flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyGyro.P = 10000
    end
    -- 方向：电脑用 UIS:IsKeyDown(W/A/S/D/Space/Ctrl)，手机用 hum.MoveDirection
    flyVel.Velocity = moveDir * Configs.FlySpeed
    flyGyro.CFrame = Camera.CFrame
elseif flyingState then
    flyingState = false
    hum.PlatformStand = false
    flyVel:Destroy() ; flyGyro:Destroy()
end
```

**三条要点**（各家都遵守）：
1. **`PlatformStand = true` 是必需项** —— 否则角色自带物理/动画会和 BodyVelocity 互相拉扯，出现抖动或飞不动。
2. 停止时**销毁两个实例 + 还原 `PlatformStand`**，否则人物落地后姿态歪。
3. 移动端要额外读 `hum.MoveDirection`（`LyanMenuRoblox` 做了）；PC 端读键盘。

**我们的现状**：已有（`BodyVelocity`/`AlignPosition`）。差异：我们多了「压住游戏写回」这一层，它们完全不防。

---

### 2. 加速 · Speed

**最裸的写法 —— 直接写一次 `WalkSpeed`，没有任何防护。**

`Hyperlib`（FieldTripZ）就是一个输入框：

```lua
local TextBox1 = Section2:CreateTextBox("WalkSpeed", "Only numbers", true, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```

`Topkek`：`Fast` = `Humanoid.WalkSpeed = 50`；`Superslow` = `Humanoid.WalkSpeed = 1`。

**我们的现状**：已有，而且我们**多了"压住游戏把速度改回去"** —— 别人完全不做这层。

---

### 3. 无敌 · God

分「本地改属性」和「调游戏远程」两派：

**A. 本地改血量上限（`Topkek`）**

```lua
-- God
v.Character.Humanoid.MaxHealth = math.huge
v.Character.Humanoid.Health    = math.huge
-- Semigod（半无敌，避免异常值被服务器发现）
v.Character.Humanoid.MaxHealth = 9e9
v.Character.Humanoid.Health    = 9e9
```

**B. 调游戏自己的回血接口（`Hyperlib` FieldTripZ）** —— 最"干净"的一种，不碰本地血量：

```lua
game:GetService("ReplicatedStorage").NetworkEvents.RemoteFunction:InvokeServer(
    "HEAL_PLAYER", game:GetService("Players").LocalPlayer, 9e9
)
```

> 思路：**让游戏自己把你血量设满**，位置/状态/UI 全由游戏维护，比自己改属性更不容易出问题。

**我们的现状**：已有（`GodTopUp` 只写 `Health`、目标用游戏自己的 `MaxHealth`）。**我们不做 `math.huge` / `9e9` 这种自造上限**（这条是我们比它们稳的地方，别退化）。

---

### 4. 锁血 / 回血（掉血就补满）

`LyanMenuRoblox` 是**事件驱动**的教科书写法：

```lua
table.insert(antiResetConns, hum.HealthChanged:Connect(function(hp)
    if Configs.GodMode and hp < hum.MaxHealth then
        hum.Health = hum.MaxHealth        -- 掉一点就补满
    end
end))

-- ★ 每次换角色都要重挂（新 Humanoid 是新对象）
Player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    hookAntiReset(char)
end)
```

**两个可抄的点**：
- **用 `HealthChanged` 事件驱动**，而不是每帧轮询（省性能）。
- **`CharacterAdded` 后重挂** —— 角色重生/换角色后旧连接失效，必须重新挂钩。

**我们的现状**：已有，且已在 v17.0.47 改成 `HealthChanged` 事件驱动 + 低频兜底。

---

### 5. 不受击（免伤）

**最直接的一种 —— 替换 `Humanoid.TakeDamage`**（`JustBxnt/steal-an-egg-optimizm`）：

```lua
local oldTakeDamage = humanoid.TakeDamage
humanoid.TakeDamage = function(self, damage)
    return            -- 全部伤害吞掉
end
```

> ⚠ **如实说明**：`Humanoid:TakeDamage` 是 Roblox 的实例方法，**直接给它赋值在普通环境里是无效的**（属性不可写）。这类写法要生效，得配合执行器的元方法钩子（`hookmetamethod` / namecall 钩子 / `newcclosure`）。**不能照抄成直接赋值**。
>
> 我们 CheatMenu 走 `__namecall` 钩子拦 `TakeDamage` ＋断伤害连接 —— **这条路更正经**。

---

### 6. 无限跳 · Infinite Jump（顺带）

各家写法几乎一模一样（`VisualWave` / `Hyperlib` / `Chocapikk` / `seaddas`）：

```lua
UserInputService.JumpRequest:Connect(function()
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
```

---

### 7. 刷东西 · Spawn Item（四种路子）

#### 路子 A ── 克隆游戏里已有的道具（`LyanMenuRoblox`，只本地可见）

```lua
local weaponRemotePatterns = {
    "givetool","givegun","giveweapon","giveitem","getweapon","getgun","gettool",
    "equipweapon","equipgun","equiptool","spawnweapon","spawngun","spawntool",
    "buygun","buyweapon","buytool","requestweapon","requesttool","requestgun",
    "weaponrequest","toolrequest","loadweapon","loadgun","loadtool","addtool","additem","grant"
}
local function isWeaponRemote(name)
    local lo = string.lower(name)
    for _, pat in ipairs(weaponRemotePatterns) do
        if string.find(lo, pat, 1, true) then return true end
    end
    return false
end
```

```lua
-- 「PUXAR ARMAS (LOCAL)」：从 ReplicatedStorage 里找所有 Tool，克隆进背包
for _, obj in pairs(ReplicatedStorage:GetDescendants()) do copyTool(obj) end
if count == 0 then
    for _, obj in pairs(workspace:GetDescendants()) do copyTool(obj) end
end
```

> 特点：**不猜远程、直接复制现成道具**。缺点：只**本地可见**，服务器不认。

#### 路子 B ── 按名字猜远程（上面那张模式表）

扫 `ReplicatedStorage` 里的 Remote，名字命中 `givetool/spawntool/...` 就调用。**这是"一份代码覆盖多游戏"的通用做法**。

#### 路子 C ── 资产拉取（`Topkek`）

```lua
local tool = game:GetObjects("rbxassetid://<ID>")[1]
tool.Parent = game.Players.LocalPlayer.Backpack
```

老式建造工具（`Topkek` 的 `BTools`）—— **最古老的"刷东西"**：

```lua
local a = Instance.new("HopperBin")
a.BinType = "GameTool"   -- 复制 / 删除任何东西（还可 "Clone" / "Hammer"）
a.Parent = p.Backpack
```

#### 路子 D ── 直接拿别人的道具（`Topkek` 的 `Take Tools`）

```lua
for _, t in pairs(p.Backpack:GetChildren()) do
    t.Parent = game:GetService'Players'.LocalPlayer.Backpack
end
```

> 需要服务器允许（否则只是本地搬运）。

---

## 三、和我们（CheatMenu）的总体对照

| 功能 | 别人的主流做法 | 我们 | 谁更稳 |
|---|---|---|---|
| 飞行 | BodyGyro+BodyVelocity | 已有 | 打平（我们多防写回） |
| 加速 | 裸写 WalkSpeed | 已有 | **我们更稳**（压写回） |
| 无敌 | `math.huge` / 调远程回血 | 已有（只写 Health） | **我们更稳**（不自造上限） |
| 锁血/回血 | `HealthChanged` 事件驱动 | 已有（v17.0.47 已改事件驱动） | 打平 |
| 不受击 | 替换 `TakeDamage`（需钩子） | 已有（`__namecall` 钩子） | **我们更正经** |
| 刷东西 | ①克隆 Tool ②远程名模式表 ③资产拉取 ④拿别人道具 | 已有（扫本地克隆 + DOORS 三条） | — |

**一句话**：这些脚本的**技术水平不比我们高**（它们普遍不做反检测、不做状态还原、不做开关门禁），值钱的是**"多游戏通用"的两条刷道具路子**。
