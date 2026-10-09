# IY（Infinite Yield）命令对照与可用清单

> 基准：Infinite Yield 官方源码 `source`（**429 个静态命令**）。
> 对照对象：CheatMenu v17.0.49（**132 个控件**）。
> 结论一句话：**IY 的多数命令是真有效的**，但"有效"分四种性质，其中只有前两种能无条件照搬。

---

## 一、"真有效吗"—— 按实现路径分四类

| 性质 | 实现方式（源码实证） | 有效性 | 例 |
|---|---|---|---|
| **① 纯客户端属性** | 直接写你自己客户端的属性 | **任何游戏都生效** | `speed`→`Humanoid.WalkSpeed=x`；`fov`→`Camera.FieldOfView=x`；`fullbright`→`Lighting.Brightness=2`；`mousesensitivity`→`UserInputService.MouseDeltaSensitivity=x` |
| **② 本地模拟** | 本地造实例/改本地状态 | 生效，**但只你这边看到** | `float`→本地造平台零件；`spin`→`BodyAngularVelocity`；`invisible`→克隆角色挪走；`god`→克隆 Humanoid 顶替 |
| **③ 发远程** | `:FireServer()` 交给服务器 | **视游戏**，被校验则无效/被踢 | 部分刷钱、刷物 |
| **④ 需执行器** | `hookmetamethod`/`getconnections` | **视执行器能力** | `antiafk`（`getconnections(Idled)`）、`clientantikick`（元方法钩子） |

**要点**：①② 是"真有效"且可照搬；③④ 不是 IY 能保证的，取决于游戏与执行器。
**几个"看着强其实取巧"的**：`god`（IY 版是克隆 Humanoid 顶替，服务器权威的游戏照样判死）、`invisible`（本地挪走自己，别人多数仍看得见）。我们的 `GodTopUp`（只写 Health + 用游戏自己的 MaxHealth）反而更稳。

---

## 二、与我们的对照（三张表）

### 2.1 我们**已有等价物**（IY 命令 → 我们的控件）

| IY 命令 | 我们的控件 |
|---|---|
| speed / loopspeed | 加速 |
| fly / cframefly | 飞行 |
| god / infhealth | 上帝模式 / 锁血 / 自动回血 |
| noclip / togglenoclip | 穿墙 / 无碰撞 |
| infjump | 无限跳 |
| gravity | 重力调节 |
| maxslopeangle | 最大坡度 |
| anchor / freeze | 锚定自己 |
| hitbox / hitboxes | 命中盒扩大 |
| antivoid | 防掉出地图 |
| fullbright / loopfullbright | 夜视 |
| fov | 视角增强 |
| esp / espteam / chams | ESP 透视 / 高亮透视 / 队友标记 |
| xray / loopxray | 穿墙透视 |
| hideguis / showguis | 隐藏游戏界面 |
| setfpscap | 帧率上限 |
| serverinfo / jobid | 服务器信息 |
| waypoint / goto / tpposition | 传送 / 收藏点位 |
| antiafk | 挂机防踢 |
| autoclick | 连点器 |
| volume | 静音 |
| fling / loopfling | 把他甩飞 / 循环甩飞 / 甩飞所有人 |
| remotespy / console / explorer（调试） | 全扫描 |
| btools？（部分）| 复制手持道具 / 拿道具 |

### 2.2 我们**没有、且值得考虑**（按优先级）

| 优先级 | IY 命令 | 实现（源码实证） | 风险 |
|---|---|---|---|
| **S · 强推** | `reach` 攻击距离 | 拉长 `Tool.Handle.Size` + `GripPos=0` | 低（本地） |
| **S · 强推** | `mousesensitivity` 鼠标灵敏度 | `UserInputService.MouseDeltaSensitivity = x` | 低 |
| **S · 强推** | `firstp` / `thirdp` 第一/三人称 | 切 `CameraMode` / 相机偏移 | 低 |
| **A · 可选** | `freecam` 自由视角 | 解绑相机，本地漫游 | 低（要写对还原） |
| **A · 可选** | `float` 漂浮平台 | 本地造一个悬空平台零件 | 低 |
| **A · 可选** | `spin` 自转 | `BodyAngularVelocity` | 低 |
| **A · 可选** | `guiscale` 界面缩放 | 改容器 `Scale` | 低（与我们的菜单要隔离）|
| **A · 可选** | `sitwalk` 坐着走 | 保持 Sit 状态还能移动 | 低 |
| **A · 可选** | `norender` 停渲染 | 冻结渲染（极端省资源）| 中（画面全黑）|
| **A · 可选** | `noprompts` 关购买弹窗 | `COREGUI.PurchasePromptApp.Enabled=false` | 低 |
| **B · 看需求** | 动画类 `reanimate`/`dance`/`emote`/`animation` | 播放/替换动画 | 低（观感）|
| **B · 看需求** | 外观类 `naked`/`noface`/`nolimbs`/`noarms` | 隐藏身体部件 | 低（观感）|
| **B · 看需求** | `grabtools`/`dupetools` 抓/复制道具 | 装备 workspace 里的 BackpackItem | 中（dup 易崩/被检）|

### 2.3 **不建议抄**（高风险或恶意，与"补强功能"无关）

| 类别 | 命令 | 原因 |
|---|---|---|
| 聊天骚扰 | `spam` / `pmspam` / `whisper` | 会被举报封号 |
| 建造破坏 | `btools` / `f3x` | 改游戏世界，易被封 |
| 远程代码 | `addplugin` / `reloadplugin` | 加载远端代码，安全风险 |
| 反踢 | `clientantikick` / `clientantiteleport` | 依赖元方法钩子，易崩 |
| 整蛊 | `trip` / `scare` / `jerk` / `spasm` | 无实用价值 |
| 冷门信息 | `age` / `joindate` / `phonebook` | 我们已够用 |

---

## 三、可否做成"IY 命令页"

可行。两种形态：

- **A. 独立"IY 命令页"**：把 2.2 表里选中项集中成新页（像 IY 一样一条一条列）。优点：集中、一眼看全；缺点：与我们现有页有重叠。
- **B. 并入现有页**：只挑 S 级（reach / 鼠标灵敏度 / 第一三人称）放进「移动·物理视角」与「系统」页。优点：不增加页面、不重复；缺点：分散。

> 本轮**未改任何脚本代码**（新功能须先经确认）。
> 数据源：IY `source`（429 命令）· `CheatMenu-17.0.49.lua`（132 控件）。
