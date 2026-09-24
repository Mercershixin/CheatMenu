# 2026-09-24 · 偷鱼（Steal a Fish）· PlaceId 99183404085821 —— 移动限制诊断

> 起因：用户「为什么飞行 飞不动 加速没效果」+ 附该服的综合扫描件（4669 条，A~L 十二层全在）。
> 结论：**不是脚本 bug（除了一处我的 UI 锅），主要是这游戏的架构不给跑。** 依据全部来自扫描件原文。

## 一、硬证据（都可在扫描件里复核）

| # | 证据 | 扫描件位置 | 含义 |
|---|---|---|---|
| 1 | **`move ❌ 无  候选8个 试过: EntityService.WalkSpeed/…/E…`** | 第 3160 行 | 这服**没有任何"移动类"上行通道** |
| 2 | `ClientReplicateCFrame` / `ServerReplicateCFrame` **命中 0 次** | 全文 | 没有 Roblox 标准角色位置复制通道 |
| 3 | `AntiCheatMovementGraceUntil = 1790237453.1389499`（是**每个 Player 上的 Attribute**，别人身上也有） | 第 405 / 428 行 | **游戏有服务端移动反作弊**，且带"宽限窗口"概念 ⇒ 高速移动会被校验 |
| 4 | `StarterPlayer.PlayerModule.ServerAuthority.ServerAuthorityClient` / `ServerAuthorityServer` | 第 3484 / 3485 / 3777 行 | Roblox **服务端权威**模块在位（是否启用需游戏内确认） |
| 5 | 全部 remote = 56 RE + 22 RF，**清一色玩法**（EggSystem / FishSystem / FuseSystem / SellSystem / Leaderboard / Cmdr …） | A 层清单 | 没有任何一条能用来"推动角色" |

## 二、由此推出的结论（为什么飞不动 / 没加速）

1. **本地驱动被吃**：这类游戏常有两种情况 ——
   ① **服务端权威**（服务端模拟角色，客户端写 `LinearVelocity`/`BodyVelocity`/`WalkSpeed` 无效或被覆盖）；
   ② **游戏自己每帧改写移动**（偷鱼有整套游泳/水池系统：`SwimLimbLines` / `TreadPoolSwimGain` / `WaterSoundVolumes` /
   `TouchJump` / `MultiSpeedClient` / `SpeedBoostClient` / `ChaserSpeedPop`）⇒ 我们的速度**每帧被改回去**。
2. **上报类功能在这里无对象**：没有移动通道 ⇒ 「防回退（过检测）」在这服**没东西可 hook**（它会直接"没挂上"，这是正常的）。
3. **服务端位置校验**：`AntiCheatMovementGraceUntil` 说明服务端在跟踪移动 ⇒ 就算本地能推，也可能被**拉回**。

## 三、脚本侧唯一真 bug（我引入的，已修）
绝对速度滑块 **`min=16` 但 `get()` 返回 `0`** —— Lua 里 `0 or min` **得 0**（0 是真值）⇒ 进度条算到负数、显示 0；
而 `UI.Slider` 的 `proc()` 只在**点击/拖动**时写值，`set(math.clamp(snapped,min,max))` ⇒
**一碰那个滑块就会被夹到 16 —— 正好等于走速** ⇒ 「飞行=走速、加速无效果」，两个症状完全吻合。
★ 修（11.5.1）：`min` 改 **0**、标签写「0=自动用下面的倍率」，并给 `tonumber()` 兜底。

## 四、11.5.1 同时加的两件"自救"能力
- **推不动自动兜底**：按着方向 0.6 秒 × 2 次检查「实际位移 ≈ 0」⇒
  飞行自动改用 **CFrame 逐帧直推**、加速自动改用 **WalkSpeed 直写**（都只在本会话生效，并 Notify 说明）。
- **🧪 移动自检按钮**（移动页）：一眼看出「目标速度 / 驱动实例挂没挂上 / **角色网络所有权** / 实际速度 /
  Humanoid.WalkSpeed 与状态 / 是否已触发兜底」。

## 五、这服的诚实上限
- 若自检显示 **网络所有权 = 服务端** ⇒ 本地怎么改都推不动，**客户端无解**。
- 若驱动挂上、速度也上去了但人**被拽回原地** ⇒ **服务端位置校验**，同样无解（这服就是不给跑）。
- 能指望的只有：**本地观感类**（透视/高亮/ESP）、**玩法类动作**（如果有对应 remote）、以及
  **不依赖物理驱动**的本地表现（如 CFrame 直推的短暂效果）。
