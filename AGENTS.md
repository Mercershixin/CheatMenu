# AGENTS.md — CheatMenu 唯一规范

> **本文件是唯一权威。** `CLAUDE.md` / `.github/copilot-instructions.md` / `.cursor/rules/cheatmenu.mdc`
> 只是**指向本文件的薄壳**（各自 1 行，不重复内容）。源码文件头有一段等价短版。
> ⛔ **本文件只描述"当前应该怎样"，不写历史版本沿革。** 想知道"以前怎样"去 `git log`。
> 旧的事件库/源码快照/存档文档**已于 2026-09-24 V2 重置时全部删除** —— 不要再去找它们。
> 仓库：`Mercershixin/CheatMenu`（公开 · main）。本地工作区 = `C:\Users\Administrator\Desktop\Hy-MT2翻译模型`。

---

## 0. 这是什么 / 怎么跑

- Roblox **执行器 Lua 菜单**，单文件。仓库里那份（`CheatMenu.lua`）是**发行产物**：构建时**去注释 + 压缩**。
- **手改入口 = 本地 `CheatMenu-<版本>.lua`**（文件名跟版本号走；发版时 `push_now.py` 自动改名）。
  ★ 定位源码一律走 `.workbuddy/build/srcpath.py`（唯一真源），**不要把源码名硬编码进任何脚本/文档**。
- 加载方式：把 `loader.lua` 整段粘进执行器；主脚本走网络加载（多源兜底）。
- 推送**不是 git push**，走 **GitHub Contents API**（token 在 `.workbuddy/publish.token`）。

---

## 1. ⛔ 铁律（违反即失败）

1. **只做用户明确要求的那一件事**。不擅自新增功能、不改用户没让动的地方。
   同一条请求换个说法再问，**答案要一致**。
2. **不擅自跑测试**。用户没说「跑一下 / 验证一下 / 测试 / 发版」就**绝对不许跑**
   （`run_*` / `verify_*` / `check*.py` / `luau-compile` / `luau-analyze` 全算测试）。
   用户原话：**「我让你做你才做，没让你做我不做。」**
   ★ 例外：**发版流程本身**要跑 `push_now.py`（那是交付步骤，不算额外验证循环）。
   ★ 唯一允许的三种验证手段：① 静态分析（`luau-compile` / `check_globals.py` / 等价性比对）
   ② 单元测试（加载器探针 / `_ballistic_unit.py` 这种"抽真代码 + 真解释器"）
   ③ 真云端分发链路（`cloud_verify.py`：真网络 / 真 CDN / 真字节）。
   ⛔ **整脚本仿真 / mock 环境 / "循环检测" 一律禁跑、禁修、禁扩展**（那是 mock，不是 Luau/Roblox）。
3. ⛔⛔ **接口红线**：**单点 `hookfunction` 可以**（明确目标就 hook 哪个）。
   **挂 `hookmetamethod(game,"__namecall")` 或 `"__index"` 做关键词搜索【绝对不行】** ——
   那是所有实例方法调用的总入口，实测就是"卡顿掉帧"的病根。
   **不主动改元表、不加 `setreadonly`。**
4. **UI 上标"不推荐 / 有风险"是给用户看的提示，不是让你改行为** —— 不删选项、不改默认、不加限制。
5. ⛔ **已删除的功能不要"顺手加回来"**（清单见 §3）。只有用户本人重新提起才能加。
6. ★★ **「任务单维修模式」**：用户给「硬约束 + 逐条 定位字符串/根因/期望修法/不要动 + 交付格式」的**维修单**时 →
   ① 只改清单项 · ② **禁止跑任何验证** · ③ 禁止回加已删功能 · ④ **接口签名不动** ·
   ⑤ 回复只写「定位关键字 + 一句话改动」+ 未改项原因（不贴 diff / 不贴全文 / 不提建议）。
   ⚠ 清单某条定位字符串**找不到** ⇒ 不猜改，**列出来并跳过**。
   ⚠ 此模式**覆盖**「改完自动推送」。⚠ **功能实现单**不走"只回一句话"，但仍受 ②③④ 约束。
7. ★★ **外部 AI 给的「审查清单」：先逐条读源码裁决，再改**。
   ⇒ 先出三类裁决表：**✅真（改） / ❌不成立（不改，给证据） / ⏭属新增功能（先报清单）**；**只改 ✅ 那类**。
   常见假条目：说「X 未定义」其实有定义 · 把环形缓冲说成"被覆盖 bug" · 把已有时间兜底说成"节流错位" ·
   把有意双保险说成"冗余" · 把历史溯源标记说成"版本号不一致" · 把**共享 C 函数**说成"逐个 hook 即可"。

---

## 2. 架构（V2 · 八层）

相关性靠**模块边界**维系，不靠行号。改一处只应在**同层**内连动。

| 层 | 职责 | 关键符号 |
|---|---|---|
| **[0] 内核** | pcall 包装、连接/线程登记、循环挂载、hook 登记、通知、原始值快照 | `SYS.P` `SYS.T` `SYS.TT` `SYS.SetLoop` `SYS.SpawnLoop` `SYS.SafeHook` `SYS.SafeUnhook` `SYS.UnhookAllSafe` `SYS.Notify` `SYS.Orig` `SYS.N` `SYS.GK` `SYS.GV` |
| **[1] 配置** | 开关/数值默认值、存档读写、已删功能守卫 | `SYS.T_`（开关）· `SYS.C_`（数值）· `SYS.SaveConfig` `SYS.LoadConfig` `SYS.REMOVED_FEATURES` |
| **[2] 通信** | Remote 定位与收发、别名表、风险判定 | `SYS.REvent` `SYS.REventU` `SYS.RFunction` `SYS.Fire` `SYS.OnRemote` `SYS.FindEvent` `SYS.RemoteAlias` `SYS.RemoteRisk` `SYS.EventWatch` |
| **[3] 检测面** | 上行拦截、位置上报伪装、隐身、反指纹、自检 | `SYS.ACBlock` `SYS.AntiRevert` `SYS.Stealth` `SYS.Prot` `SYS.AC`（D1~D14） |
| **[4] 移动** | **唯一**移动核心 + 各移动功能 | `SYS._Move` `SYS.FlyTick` `SYS.SpeedTick` `SYS.CleanFly` `SYS.CleanSpeed` `SYS.SetNoclip` `SYS.SetInfiniteJump` `SYS.TPTo`(分步链) `SYS.SetPathKey` |
| **[5] 视觉** | 透视/高亮、射线、准星、自由视角、光照、HUD | `SYS.NewVis` `espFill` `SYS.Gun` `SYS.RayHook` `SYS.HitMark*` `SYS.SetFreeCam` `SYS.HUD_Info` |
| **[6] 战斗** | 瞄准/开火、弹道、死亡登记 | `SYS.Combat`(`CB`) `SYS.FP` `SYS.DeadOnTime` `SYS.SpiderSense` |
| **[7] 玩法** | 各游戏专用模块 + 通用玩法（挂机/交易/翻译） | `SYS.DRHp` `SYS.DRCombat` `Trans` `SYS.Dodge` … |
| **[8] 界面** | UI 框架 + 页面 | `UI.Pages` `UI.Switch` `UI.Slider` `UI.Cycle` `UI.Btn` `UI.Tip` `EnsurePage` |

**硬规则**
- ④ **[4] 层只有 `SYS._Move` 能创建/销毁角色上的约束实例**（`Attachment` / `LinearVelocity` /
  `AlignOrientation` / `BodyVelocity` / `BodyGyro`）。其它任何地方都不许自己 `Instance.new` 这些。
- ⑧ **[8] 层任何开关只允许调 `setter`**，不许直接改状态；且必须走下面 §4 的"四点"。
- ⛔ **不要再用"全局粘性状态"**（如已删的 `SYS._FlyDegraded`：一旦为真就再也回不去，且看不出为什么）。
  降级必须**局部 + 一次性 + 有提示**。

---

## 3. 已删功能 / 禁止回加（34 项，由 `SYS.REMOVED_FEATURES` 承载）

| 类别 | 键名 |
|---|---|
| 陷阱 / 自动使用 | `TrapWatch` `AutoUse` |
| 脚步 / 自动类 | `FootstepESP` `AutoClaim` `AutoPickup` `AutoRespawn` `AutoShop` `AutoTeam` `AutoEmote` |
| 翻译旧实现 | `TransSili` |
| 锁值 | `LockSpeed` `LockJump` `LockGravity` |
| 路径点显示 | `WPShow` `WPKey` |
| 特效 / 性能 | `FX_Enable` `AutoLowPing` |
| 战斗旧项 | `CB_MissMode` |
| 玩家控制旧项 | `PC_Freeze` `PG_Spin` `PG_SpinHit` `PG_FlyHit` `PG_WalkHit` `PG_HideHit` `PG_OrbitTool` `PG_BlackHole` `PG_KillNear` |
| 防护旧项 | `Prot_AntiAC` `Prot_AntiTP` `Prot_HideGui` `Prot_SpeedCap` |
| 自动按键 | `Key_Auto` |
| 自动重生（⚠ ≠ 自动复活） | `AutoRebirth` `RebirthCheck` |

**用户明确说"还需要"的，别再删**：`NoClip`（穿墙）· `AntiFling`（防甩飞）· 无限跳 · Ctrl+数字路径点。

---

## 4. 开关接线「四点」（缺一即"开了没反应"）

1. `SYS.T_`（布尔开关）或 `SYS.C_`（数值）**默认值**
2. **模块本体**（setter + 真正的 tick / hook）
3. `UI.Switch` / `UI.Slider` / `UI.Cycle` **注册**（第 3 个参数就是键名）
4. **`UnloadAll` 里还原**（有 hook / 实例 / 监听的必须还原）

⚠ **默认开 + 页面懒构建** ⇒ 光靠 `UI.Switch` 不会在启动时生效，要在启动器 `task.wait(1.5)` 段
（`SwitchOnChange` 循环之前）**显式补一次**。
⚠ **`UI.Slider(parent,label,min,max,step,get,set,fmt)` 的 `get()` 返回值必须落在 `[min,max]` 内** ——
不一致时 Lua 的 `0` 为真（`0 or min` 得 0）会让进度条算到负数，并可能在用户拖动时被**静默夹到边界值**。

---

## 5. ⛔⛔ 硬不变量（都是真踩过的坑，改之前先看这里）

### 5.1 移动 / 过检测 **必须是两个模块**
| | 管什么 | 单位 | 开关 |
|---|---|---|---|
| **移动**（飞行 / 加速） | **本地动多快** | 格/秒（`C_.FlyAbs` / `C_.SpeedAbs`，0 = 用倍率） | 移动页 |
| **过检测**（防回退） | **上报给服务端多快** | 格/秒（`C_.RevertCap`） | `T_.AntiRevert`（**默认关**） |

两者天生互相拉扯：上报上限低于实际速度 ⇒ 服务端把你往回拽（看着像"定在原地"）。
**⛔ 任何"速度上限 / 阈值"都不能写死常量**（`AntiFling` 的 80、防回退的 `maxStep` 都栽过）。
**⛔ "倍率"必须写明基准是什么**（老实现的 `SpeedMult` 乘的是写死的 16，游戏本身跑得快时"6 倍"反而更慢）。

### 5.2 hook 卫生
- ★★ **Roblox 里所有 RemoteEvent 的 `FireServer` 是同一个 C 函数**（实例方法取自共享类表）
  ⇒ **"逐 remote 各 hook 一次"做不到**（会被去重成一次、且只捕获第一个实例）。
  **正确做法：只 hook 共享的那一个，调用时按 `self.Name` 判断。** RF 同理走 `InvokeServer`。
- ★★ **任何"替换游戏自身函数"（`hookfunction`）的模块，必须同时挂进 `UnloadAll`（或 `FuseClean`）。**
- ★ **卸载顺序也是逻辑**：若 B 的还原值是"包在 A 外面的 wrapper"，B 必须在 A 之前还原，
  否则会把已摘掉的 A **重新装回去**。卸载中（`SYS.Unloaded`）不要做"再 hook 一次"的还原。
- ⛔ **不要"静默失败"**：任何"拒绝 / 丢弃上行"的路径必须留可见痕迹（Notify / 计数 / 进自检），否则宁可放行。
- ★ **统计 / 指纹类功能必须两头都验**：生产端有没有写、消费端有没有读（只写消费端 = 功能是死的但看着正常）。

### 5.3 界面即检测面
- ⛔⛔ **GUI 容器固定挂 `PlayerGui`，别改**：`gethui` / `CoreGui` 会让菜单**偏 58px / 跑角落**
  （用户实测定案「位置正确 > 反检测收益」）。UI 反检测只做「名字 + 文字 + Archivable + 属性面」。
- 反作弊会遍历 `PlayerGui` 读 `.Text`。名字能中性化，**文字不能** ⇒ 只能「关闭时脱敏」降低暴露窗口。

### 5.4 准星护栏（`SYS.Gun`）
`AIM_T` **只准放真·时长**；⛔ 那几个 fov / alpha / lerp / sensitivity 键**永不加回**；
名字带 `crosshair/reticle/scope/sight` 的数值**不建槽**（`NEVER_NUM`）——
**三处必须齐**（定义 / 派发链首分支 / hook 候选），少一处 = 空转。

### 5.5 游戏事实（会反复用到）
- **Dead Rails（亡命铁轨）**：玩家伤害 = **服务端算**（220 个 remote 里与血量相关的只有
  `bandage.Use` / `snake_oil.Use` / `RevivePlayer`，**无客户端上行通道**）⇒
  **补血 ✅ · 锁血 ⚠️ · 真无敌 ⛔**。唯一可能真有效 = **防击倒**（`ClientPlayerFlopHandler` 在客户端）。
  敌人带 `EntityName` Attribute、住 `Workspace.RuntimeEntities` / `NightEnemies`；
  **`EntityName=Horse` / `War` 是坐骑，绝不标红**。
- **服务端权威 / 自带移动系统的服**（例：偷鱼 PlaceId 99183404085821，`move` 类通道 = 无）：
  客户端写 `WalkSpeed` / `LinearVelocity` / `BodyVelocity` 都可能**无效**。
  诊断顺序 = 先看**角色网络所有权**（`root:GetNetworkOwner()`：空 / 服务端 ⇒ 本地推不动），
  再看"速度好看但人被拽回 ⇒ 服务端位置校验，客户端无解"。**用「🧪 移动自检」按钮，不要猜。**

### 5.6 配色规范（别自己加颜色）
- 所有高亮 = **边框高亮**（填充近乎透明 0.88 / 隔墙 0.93，只留描边）
- 普通物件 + 普通门 = 亮青 `(0,200,255)` / 描边 `(0,170,230)`
- 危险（陷阱 / 伤害机关 / 切割 / 假门）= 红 `(255,30,30)` / `(255,0,0)` + ☠
- 人物 = 队友绿 / 敌人红 / 幽灵紫；怪物·NPC = 橙
- 「掉落物 / 可交互 / 门·陷阱·假门」三个透视**已合并成一个开关「🔍 物件透视」，别再拆开**

---

## 6. 发版流程（固定）

1. 改源码 → 2. `dist/repo/CHANGELOG.md` **顶部**写条目（版本号与 `version.txt` 对齐）
→ 3. `python .workbuddy/build/push_now.py --fast`（修 bug 加 `--patch`）→ 4. `local_sync.py`
→ 5. `push_docs.py`（文档 / 事件库 / 快照，**用硬编码 FILES 清单**）→ 6. 回读核对。

- **固定 4 文件**：`CheatMenu.lua` / `version.txt` / `loader.lua` / `CHANGELOG.md`。
- **升号**：默认「次+1」= **中间位 +1、补丁归零**（`11.5.1 → 11.6.0`）；minor 到 10 进位主号（`11.10.x → 12.0.0`）。
  **写 CHANGELOG 前先看 `.workbuddy/build/VERSION`。**
- ⚠ `push_now.py` **先**跑 `sync_src_name.py` 改名 ⇒ 它报的 `[sync_src_name] build/VERSION = X` 就是本次真实发版号。
- ⚠ **`push_now.py` / `push_docs.py` 退出码 1 ≠ 失败** ⇒ 以 **API 回读 / raw 逐字节比对**为准。
- ⚠⚠ **`push_docs.py` 的 FILES 是硬编码清单**：新建文档没加进去会被**静默跳过**（远端 404，脚本不报错）。
  ⇒ 新建任何 `事件库/*.md` 后必须加进 FILES，并用 **GitHub API `/contents/<path>`** 核验
  （raw 有 CDN 缓存会误判）。
- ⚠ **同一文件的多处 `Edit` 必须串行**（并行会互相覆盖、静默丢改动）；
  ★ **`Edit` 的 `old_string` 只圈一行标题时，`new_string` 必须把那行原样补回**，否则**标题被吃掉**。
- ⛔⛔ **Lua 中文字符串里绝不能用 ASCII `"`**（会截断字符串 = 语法错误）⇒ 正文一律用 `「」`；
  **改完必过 `luau-compile`**。
- ★ **下载源新鲜优先**：raw 系排前，jsDelivr 压兜底（`@main` 文件级长缓存，会静默发旧版）。
- ⚠ `api.github.com` / `raw.*` **间歇不通**（10061 / 10054 / 10060）—— 抖不是坏，重跑即通。
  ⚠ CDN 复读可能**滞后**（实测 `ghproxy` 落后一个版本）⇒ **双源都要读，且以 API 为权威**。
- ★ 回读核验**别用 `curl -o /tmp/x`**（本机 Git Bash 写盘 exit 23 / HTTP 200 但 0 字节）
  ⇒ 一律 **`curl -s URL | sha1sum`**。
- 本地 git 同步（**git 根 = `dist/repo/`**）：`git ... fetch <镜像URL> main` → `reset --hard FETCH_HEAD`。
  ⛔ **别用 `git push`**（会把规范文件回退成旧版）。

### 6.1 大改动怎么落地（比一条条手工 Edit 安全）
- 本会话**没有 `MultiEdit` 工具** ⇒ 大改动一律走 **Python 锚点补丁脚本**：
  每个锚点**校验唯一命中**，命中数 ≠ 1 就**整体不写文件**（原子）；
  大段整块替换用 **`rep_between(起锚点, 止锚点, 新文本)`**（只定位两端字节，不逐行复刻）。
- ⛔ **把大段 Lua 文本写进 Python 时一律用 `r'''...'''`** ——
  普通三引号里 `\n` 会被 Python 解释成真换行 ⇒ 截断 Lua 字符串 ⇒ `Malformed string`。
- ★ 改完**立刻** `luau-compile`（exit 0 才算过）。

---

## 7. 诚实边界（做不到的，别承诺）

- **服务端结算的东西客户端拦不到**：真无敌、锁血（血条回弹）、服务端位置校验拉回、真踢 / 封。
- **服务端权威 / 自带移动系统的服**：客户端驱动力可能完全无效（见 §5.5）。
- 反作弊**逐帧遍历 GUI / 比较函数身份**：隐身只能"少暴露自己"，不能隐形。
- ⛔ **不做**：给游戏内部表灌元表 · 任何服务端伪造 · `__namecall` / `__index` 关键词搜索。

---

## 8. 目录约定

```
CheatMenu-<版本>.lua     手改源（本地）
dist/repo/               仓库工作树根（= git 根）
  AGENTS.md              本文件（唯一规范）
  README.md              项目介绍 / 用法
  CHANGELOG.md           逐版变更（顶部 = 最新）
  CheatMenu.lua          发行产物（构建生成，勿手改）
  version.txt / loader.lua
  事件库/                扫描结论与游戏要点（按游戏分文件）
  源码快照/              只保留**当前版本**那一份
.workbuddy/build/        工具链（push_now / push_docs / local_sync / verify_all / srcpath …）
.workbuddy/memory/       助手记忆：MEMORY.md 索引 + MEMORY2/3/4 分卷 + 按天日志
```
