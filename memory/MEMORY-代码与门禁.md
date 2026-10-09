# 代码级 bug 模式 与 工具链（细节）

## ⛔⛔ 绝不用 `sed -i` / 文本流工具改 `.bat` / `.ps1` / `.cmd`（2026-10-07 实锤，害用户打不开服务）
- 事故：`sed -i 's/--threads-http 2 .../... 8 .../' 翻译模型开关.bat`（GBK 文件）⇒
  **整份 270 个 CRLF 全被换成 LF** ⇒ cmd.exe 解析错乱 ⇒ **用户双击 bat 打不开、模型起不来**。
- 铁律：改 Windows 脚本一律 **Python 以 `bytes` 读 → 字节级替换 → `bytes` 写**，并**断言 CRLF 数量不变**；
  需要写中文时用 `encoding="gbk"`，且**不要**用 `newline=""` 之外的换行转换（直接操作 bytes 最稳）。
- 改完必须验：`CRLF 数 > 0`、`含 NUL == 0`、`GBK 可解码`；再**实跑一次只读分支**（如
  `cmd //c "xxx.bat" status`）确认 exit=0、标签跳转正常。
- 同类坑：`.bat` 里中文注释乱码 ≠ 文件坏（cmd 用 GBK 显示正常）；**判断坏没坏只看行尾与 NUL**。

## ★★★ 访问实例上"不存在的属性"会抛错；被 pcall 吞掉 = 功能静默失效（2026-10-07 实锤）
- 事故：翻译模块 4 处写 `obj.TextVisible`，但 **Roblox `TextLabel` 没有 `TextVisible` 属性** ⇒ 访问即 error
  ⇒ `pcall(Trans.GuiEl, obj)` 静默吞掉 ⇒ 每个文本控件一进函数就中断 ⇒ **翻译永远 0 条**（日志仅一行
  `TextVisible is not a valid member of TextLabel ...`；"登记 0 个控件"被误判成"界面本来没英文"）。
- 判据：**Roblox 属性不存在不是返回 nil，是 error**。凡不确定该属性是否存在，一律
  `local ok, v = pcall(function() return obj.X end)` 包一层（可做 `Trans.TV` 这类统一小助手；nil 视为"不阻止"）。
- 推广：热路径被 pcall 包住时，这类错会被吞 ⇒ **pcall 内首次出错必须能看见**（至少打一条日志）。

- ★★ **路径坑：Python 不认 Git Bash 的 `/tmp`**（会解析成 `C:\tmp`，静默什么都不干）——
  要临时目录一律用 `tempfile.gettempdir()`（本机 = `C:\Users\Administrator\AppData\Local\Temp`）。
  同理**任何"用 shell 角度看绝对路径"的参数**，交给原生 Windows 程序前先用 `cygpath -w` 换成 Windows 路径。
- ★ **缓存清理白名单**（用户要求"清理你占用的缓存"时按此执行）：
  ① 我下载的公开脚本/探测产物；② `codebuddy-marketplace-install-*`（插件安装残留，常上百 MB）；
  ③ `workbuddy-product-spill-*` / `workbuddy-conversation-product-*` 等**今天之前**的空临时目录；
  ④ **今天之前**的陈旧 `*.tmp`；⑤ 项目 `build/_*.py|_*.lua|_*.log` 一次性补丁；⑥ 源码备份只留最近 5 个。
  ⛔ **不碰**：`Real.dll` / `Roblox/` / `RealLottie-*`（执行器在用）、用户自己的截图、当天的 `.tmp`、
  `dist/*.dist.lua`（历史产物）、发版工具链（gate/push_api/_manual_release/deadfix）。
  保护措施：**删除前逐项 15 分钟 mtime 门槛**（太新=可能被占用就跳过），删完报每类释放量。

## 门禁能查到的

编译（`luau-compile`）· 顶层真局部数（≤200）· 源根"先用后声明"（**只查局部变量**）· F/AC/Trans"只用未定义" ·
消毒残留 · 文本自检（`end` 配平 + UTF-8）· 与产物逐字符一致 · **未定义全局**（`luau-analyze` + 白名单，白名单要配全执行器 API）。

## ★★★ 门禁查不到、但真会炸的（一定要人工/专项审计）

1. **元方法钩子重入**：钩子里调 `Raycast`/`FindFirstChild`/`GetPlayers` ⇒ 再进钩子 ⇒ **爆栈闪退**。
   铁律：**先判 `getnamecallmethod()` 再干活**；钩子内只做纯计算，否则加 `F._busy` 守卫。
2. **循环自停只 `return`、不调自己的 Disable**（实测 24 处）⇒ 循环停了但世界上的痕迹还在 ⇒
   "关闭了还生效"。统一 `if not T.X then XDisable() return end`。
3. **资源不对称**：`Enable` 里 `:Connect`/`Instance.new`/`BindToRenderStep`/`MetaInstall` 了，`Disable` 必须对应释放；
   **常驻连接还要置 nil**（否则重开被 `if F._xConn then return end` 早退 ⇒"只能生效一次"）。
4. **`F.X = function` 形式"执行到那一行才存在"**：在 `buildMenu` 里调用定义在文件更下方的
   `F.CfgSyncUI` ⇒ 那时是 nil ⇒ **被 pcall 静默吞掉** ⇒ 功能"没反应"但日志无错。
   ⚠ **门禁的"先用后声明"只查局部变量，查不到这种 F 字段。**
5. **删 `local` 声明没连"使用"一起删** ⇒ local 变**隐式全局**（写进 `_G`）。
6. **缩进是给"下一个读代码的人/模型"看的**：列 0 却在函数内部 ⇒ **两份独立审计都读错**。
8. **删功能要扫"全部调用方"**（只改一处 ⇒ "删了还装"）。
9. **改速度/位移类属性时，没打算改的分量必须保留**（只写你要的轴；否则重力/跳跃一起被改）。
10. **"断开/恢复某连接"的补丁，先证明该连接真的有创建方**：清单写"FlyDestroy 断跳跃连接"，
    但 `F._flyJumpConn` **原本无人创建** ⇒ 写出来的是**永远为 nil 的空代码**（"看起来修了其实没修"）。

## ★ 性能与健壮性（2026-10-01 批 B/C 固化）

- ★★★ **`GetDescendants()` 本身就是阻塞点** ⇒ 大范围遍历一律用 **`F.walk(root, cap, budget)`**；角色内保持原样。
  ⛔ **让出必须写 `pcall(task.wait)`**（被每帧回调调用时直接 `task.wait()` 会报 cannot yield）。
- ★★ **长文本先截断**；**`gsub` 的 `from` 要转义元字符、替换走函数式**（替换串里的 `%` 会被当捕获引用）。
- ★★ **`getgc` 全量遍历一律分片 + 上限**（统一 `F.gcTick(i)`）；**日志轮转是"删最旧"不是"跑满就丢"**。
- ★ **高频副作用要节流**（`Trans.Save` ≥5s / RemoteSpy 每 50 条一条）；**每帧写位移用真实 dt**；
  **UI 回填以 GUI 状态优先、`opt.Type` 缺失时按 `opt.Value` 兜底**。

## 文案与字符串（踩坑）

- ★★★ **中文文案里禁用 ASCII 双引号**（2026-10-01 实测）：`F.Out("[分析] …没有"数值型阈值"可读…")`
  ⇒ ASCII `"` **直接把 Lua 字符串截断** ⇒ 编译报 `Expected ')' ... got Unicode character`。
  **只准用「」**（或 `\"` 转义）。
- ★★★ **"扫不到"要区分两种情况**：①「真没这类东西」= 可以下结论；②「我没按这种维度扫」= 不能下结论。
  实测教训：我们的扫描只按**数字常量**找反作弊 ⇒ 就下了"客户端看不到"的结论，
  而公开作品证明这类游戏有**名字型/连接型**客户端检测（`ObbyAntiTPClient`）⇒ 已加 `F.ScanClientChecks()`
  （按脚本名 + `getconnections(RS.Heartbeat)` 里 `debug.info` 的来源）。
## 注释清理

源码**现在 0 注释**（用户明令）；将来若又冒出来：**保留规则、改写叙述，别整行删**，并确保 `end` 配平不变。

## 审计工具（都在 `.workbuddy/build/`）

| 工具 | 查什么 |
|---|---|
| `gate.py` | 上面那 8 项（发版门禁） |
| `audit_crash.py` | 钩子重入 / 无让出循环 / 每帧重活 / 事件内 `task.wait` / `while true` |
| `audit_lifecycle.py` | Enable↔Disable 对称 / 连接与实例泄漏 / 开关闭不闭环 / 连接字段置 nil |
| `audit_features.py` | 控件清单 / 彻底死 / 重复写同一标志 / 单节控件数 |
| `deadscan.py` | **死代码取证**：逐候选列出**每一处命中**并标注"定义/引用"（只看计数会漏判） |
| `_del_dead.py` | **按块删死代码**：用"块关键词配平"定位函数边界，干跑先打印每块起止行 |
| `residualscan.py` | **零引用定义取证**：F 字段 / 局部函数 / 顶层 local（**含无初值的 `local A, B`**） |
| `deadfix.py` | ★ **传递闭包删除**：迭代到不动点，`--write` 直接落盘（**验证与写盘同源**）；`ALLNS=1` 才扫 `AC.*` 等命名空间 |
| `verify_cloud.py` | 多源逐字节（**内部已先重建产物**） |

★ **删死代码的三条硬教训（2026-10-01 实测，本轮 26 块/271 行）**：
1. ★★ **块配平函数的返回条件不能写 `d==0 and i>start`** —— 那样**单行 `function f() ... end` 会被判成跨 2 行**，
   多删掉后面一行。正确写法：`d == 0` 就返回（含起始行本身）。
2. ★★ **重复锚点必须逐条列全**：`F._spyOld = nil` 原文出现 **2 次**，清单只列 1 次 ⇒ `find_line` 只删第一处，
   第二处残留（靠"删后逐个符号复验为 0"才抓到）。
3. ★★ **复验要防子串误判**：`AimConn` 删完仍剩 1 处，其实是 `F._antiAimConn`（另一个符号）。
4. ★★★ **删功能之后必须再做一次"传递闭包"复扫**（2026-10-01 实测，10.10.8 一轮清出 55 个符号 / 248 行）：
   删掉 `A` 会让**只被 `A` 调用的 `B`**、**只被 `A` 写的 `F.x`** 一起变死 ⇒ **单轮扫描查不到**。
   典型：删 `espCreate` 后里面的 **`espInit()` 成了悬空调用**（正是门禁 [8] 报的那个未定义全局）。
5. ★★★ **引用计数要按符号的访问形式来数**：通用词边界正则（`NAME` 前不能是 `.` 或词字符）会
   **漏掉 `F.AutoFire` 这类"带命名空间"的调用** ⇒ 一次假报 18 个残留。
   正确做法：**命名空间符号只数 `NS.NAME`，局部符号才数裸名**。
6. ★★ **恒真早退之后还有不可达代码**：`T.X` 全文无写入点 ⇒ 恒 `nil` ⇒ `if not (T.X and …) then <干活> return end`
   **恒真** ⇒ 早退后面那一段**永远到不了**（`smoothTP` 的插值路径就是这样白留了）。**别只删 `if`。**
⇒ **删完必须：① 门禁 `end` 配平等式仍成立 ② 顶层真局部减少数 == 计划删的顶层 local 数 ③ 逐符号 grep 复验 = 0
　 ④ 传递闭包复扫为空集。**

★ **审计误报类别**（别去追假问题）：有界循环不是死循环（看预算/条件是否每轮变）· 纯标志开关（`T.X = v`）不是"关不掉" ·
`= {}` 清理不是"未置 nil" · 注释里提到名字不算残留 · **内联守卫赋值**（`if 条件 then F.x = v end`）会被"只用未定义"正则漏认 ·
钩子体要**按括号配对取**（"N 行窗口"会算进旁边函数）。

## ★★★ 外部报告类输入：一律逐条核实再动手

用户转来的"AI 排查报告 / bug 清单"**不是事实，是待验证的假设**（四次实测命中率：2/6 · 10/14 · 3/6 · 8/14）。
⇒ **逐条对真源码核实 → 分档（成立 / 已修 / 判断有误 / 违反规矩 / 与红线冲突 / 改法自相矛盾）→ 只做真的 → 结论写进维护文档**。
- ★★★ **清单里的"数字/事实"必须自己数一遍**：说"每次建表"其实早被 guard；说"某字段没有写入点"其实写在**另一个功能**里。**照抄会改坏已经对的东西**。
- ★★★ **改法可能自相矛盾**或**要求换核心设计** ⇒ **不照做、也不私自另做**：要么**停下报告**，要么**用同设计内的等价修法达成它的验收标准**。
- ★ **"加注释 / 加日志"类要求先对项目规矩**（本仓库源码注释数 = 0，是用户明令）。
- ★★ **同一字段被两个功能共用 = 迟早互相砸** ⇒ **连接类字段必须带功能前缀**，**Disable 只清自己那一组**。

## ★★ "定义了就必须有人调用"（审计盲区）

`audit_features.py` 只查**彻底死**，**查不到"内部 `local function` 定义了却在同一作用域里没人调"**
（实测：Skeleton 的 `bindSkelPl` 全文只出现 1 次 = 定义 ⇒ 对已在场的玩家根本不画）。
⇒ **应加审计**：每个 `local function NAME(` 统计同作用域调用次数，为 0 就报。高发点：事件回调里的 helper、`for` 前的 per-player 绑定函数。

## ★★★ 常用命令速查

```
python .workbuddy/build/preflight.py [源码名]                  # ★ 秒级体检(4.5s) —— 发版前唯一必跑
python .workbuddy/build/_verify_effect.py [源码名]             # ★ 效果链验证(1s): 79 控件是否真的接到引擎
python .workbuddy/build/_audit_events.py [源码名]              # ★ 抽每控件的真实事件/钩子/改属性
python .workbuddy/build/_corpus_events.py                      # 本地 103 份语料的事件/钩子统计对比
python .workbuddy/build/_audit_defaults.py [源码名]            # ★ 界面 Default vs 后端实际默认（防"界面骗人"）
python .workbuddy/build/_audit_pairs.py [源码名]               # ★ 启停对称 + 关闭链【传递闭包】+ 状态键双向
python .workbuddy/build/_audit_sideeffect.py [源码名]          # ★ 跨功能副作用（关 A 却动了 B）
python .workbuddy/build/_audit_impl.py [源码名]                # ★ 幂等/每帧重活/还原完整性/线程收敛
python .workbuddy/build/_corpus_tech.py                        # 语料"实现手法"统计（不只事件）
python .workbuddy/build/_audit_tiers.py [源码名]               # ★ 档位覆盖面矩阵 + 上含下（T1⊆T2⊆T3）
python .workbuddy/build/_remote_check.py                       # 用 Contents API 分块读远端并逐字节比对
python .workbuddy/build/gate.py [源码名]                       # 8 项全量(含 luau-analyze) —— 4分半, 非必要不跑
python .workbuddy/build/_manual_release.py --patch --push     # 构建 + 推送
```

## ★★★ 界面 Default **必须等于**后端实际默认（2026-10-06 v16.9.25 抓到 7 处"界面骗人"）

- 根因：**「配置存档」v16.9.19 删除后，界面 `Default` 不再回填到 `C.`/`T.`**，控件回调只在用户动手时执行
  ⇒ 凡"界面 Default ≠ 后端读取兜底"的控件都开始骗人（用户看到 A、程序用 B）。
- 典型症状：某开关界面显示"开"，但功能不生效；或界面显示"关"，实际在做。
- **判据（写死）**：
  - `T.X ~= false` / `T.X == false` → 后端默认 **true**
  - `if T.X` / `if not T.X` / `T.X == true` / `T.X ~= true` → 后端默认 **false**
  - `tonumber(C.X) or N` / `C.X or "S"` → 后端默认 N / "S"
  - 与控件 `Default` 不等 ⇒ 缺陷。**修法二选一：改后端兜底常量，或在加载期顶层初始化 `T.X = 界面默认`。**
- 每版必跑 `python .workbuddy/build/_audit_defaults.py <源码>`，**必须 0 处不一致**。
- ⛔ 写这个审计工具的两个坑（我都踩过）：
  ① **本仓回调体不缩进** ⇒ 靠"行首有没有空格"判"是否在函数体内"必误判（会把函数内的 `T.X=false` 当加载期初始化）。
     必须**用块配平求函数范围**（关键字集 `function|if|do|repeat|end|until`）。
  ② 控件/字符串兜底的扫描要用**原文**，不能用手写掩码后的文本（掩码会把 `"…"` 抹成空格，正则就匹配不到字符串）。
    只有布尔读取的扫描才该用掩码文本。

## ★★★ 全页复查的 8 道门（发版前按需跑；用户要求"强制复查不许跳过"时全跑）

| 门 | 查什么 | 工具 |
|---|---|---|
| G1 | 编译 | `luau-compile --binary` |
| G2 | 孤儿 / nil 洞 / 未定义 / 配平 / 只读未写 | `preflight.py` |
| G3 | 每控件是否真接到引擎 | `_verify_effect.py` |
| G4 | 界面 Default == 后端实际默认 | `_audit_defaults.py` |
| G5 | 启停对称 + **关闭链传递闭包** + 状态键双向 | `_audit_pairs.py` |
| G6 | **跨功能副作用**（关 A 却动了 B） | `_audit_sideeffect.py` |
| G7 | 幂等 / 每帧重活 / 还原完整性 / 线程收敛 | `_audit_impl.py` |
| G8 | 事件 + 钩子清单 | `_audit_events.py` |

### 判读要点（都是本轮踩出来的）
- ⛔ **判"急停漏项"必须用传递闭包**，不能只看直接引用：`F.GuardOnDisable → F.GuardSet(false,…)` 这种
  二级调用才是真覆盖（直接引用会误报 4 个"漏项"）。
- ⛔ `_audit_pairs.py` 里 `M` 是**字符串**，按行处理必须先 `split("\n")`（否则 spans 恒空、闭包失效）。
- ⛔ `_audit_impl.py` 的"while 无 yield"用非贪婪正则截窗口会**误报**（护蛋循环的 `task.wait` 在 139 行之后）
  ⇒ 这类告警**必须回原文看完整块**再判。
- ✅ **纯 Lua 闭包钩子可被 `debug.getinfo(orig).what == "Lua"` 认出**（公开 remote-spy 探测就这么干）
  ⇒ 所有 `hookfunction` 的替换函数一律 `newcclosure` 包（保留不可用时的降级）。

## ★★ 跨功能副作用：**关 A 不许动 B**（2026-10-06 v16.9.26 抓到真缺陷）

- 实例：`Trans.Disable()`（翻译总开关）里有一行 `pcall(F.ChatIMEBoxDisable)`，而
  **「中文聊天框」是独立开关**（`F.ChatSend` 用 `TextChatService` 发原始文本、完全不经过翻译服务）
  ⇒ 关翻译把聊天框也拆了，`T.ChatIMEBox` 仍 true、开关仍显示"开" ⇒ **界面骗人 + 功能被意外关掉**。
  **修法**：把那个调用删掉；并给 `F.ChatIMEBoxDisable` 补 `T.ChatIMEBox = false` 防状态漂移；
  卸载链里的调用**保留**（卸载本就该清）。
- **判据**：任何 `F.XDisable` 内部调用 `F.YEnable/Disable` 时，先问"Y 和 X 是同一功能族吗？"
  **不是 ⇒ 缺陷**（除非 X 是 Y 的合并总开关，或该联动已在标题/日志写明）。

## ★★ 三个 Luau/Lua 硬语法坑（2026-10-06 v16.9.28 编译门禁抓到）

1. ⛔ **`...` 不能出现在嵌套函数里**：`local ok, x = pcall(function() local t = {...} end)` 直接**编译报错**
   ⇒ 变长参数必须在**外层函数**先捕获（`local n = select("#", ...) local args = { ... }`）再让闭包使用。
2. ⛔ **不要依赖 `table.pack`**（少数执行器没实现）⇒ 用 `select("#", ...)` + `{ ... }`，
   并**手动补 `args.n = n`** —— 否则 `table.unpack(args, 1, args.n)` 拿不到尾部的 nil 参数。
3. ⛔ **namecall / `__index` 钩子体本身没有 pcall 保护**：钩子里调用的任何 helper 一旦抛错，
   会**直接传给游戏的调用方**（表现为游戏功能随机报错）⇒ 钩子内调用的 helper 一律**整体 pcall**、
   异常时返回"最保守的那个值"（例如返回 nil = 退回原本的丢弃/原样行为）。

## ★★ 关键路径上的开关失败**不许静默**：用 `F.Try` 不用裸 `pcall`（2026-10-06 v16.9.31）

- `F.Try(name, fn)` 的实现就是 `local ok, err = pcall(fn, ...)` + **失败打一行日志**
  （`[×] XX 调用失败(已跳过, 其余功能不受影响): 原因`）。
- 全文 95 处 `pcall(F.XxxEnable/Disable)` 会把失败**静默吞掉** ⇒ 这正是"**开关拨了没反应、日志里还查不到原因**"的根因。
- **判据**：**档位 / 防护 / 急停 / 绕过 / 一键全关**这些"一漏就是残留"的路径，一律用 `F.Try`；
  而 `pcall(function() g:Destroy() end)`、`pcall(c:Disconnect)` 这类**尽力而为**的包**保持裸 pcall**
  （失败属预期，逐个打日志＝噪音）。
- v16.9.31 已转换 19 处：`GuardSet`(2) · `ProtectApply`(2) · `BypassTierApply`(2) · `CarryGuardDisable`(1) ·
  `AllInOneDisableAll`(5) · `ACWriteTierApply`(7)。**HookFuse 故意不改**（每次换档都跑，失败日志会变噪声）。

## ★★ 求函数体范围时，关键字集**必须含 `if/do/repeat/until`**（2026-10-06 v16.9.31 踩到）

只数 `function`/`end` 会让任何 `if` 块的 `end` 把深度**提前归零** ⇒ 取值范围被截断
（本轮 `F.ProtectTierApply` 被截成 5 行，实际 ~60 行）。
⇒ 正确关键字集：`function|if|do|repeat|end|until`（`_audit_deep.py` 等工具已用对的）。

## ★★ 新角度审查清单（v16.9.31 全量跑过一遍，13 项全干净，工具 `_audit_deep.py`）

| 检查 | 结果 |
|---|---|
| ① 同一函数被定义两次（静默覆盖=死代码） | 0 |
| ② 隐式全局（拼写错建全局） | 0（**判据必须加掩码+括号深度**，否则表构造字段/多行续行会大面积误报） |
| ③ `local function` 定义前被引用 | 0（报出的 8 处全是**跨作用域同名局部函数**） |
| ④ `math.clamp` 参数倒置 | 0 |
| ⑤ 异常/不可见字节（NUL/零宽/BOM/NBSP/全角空格） | 0（ZWJ × 2 是 `🧟‍♂️`/`🏴‍☠️` emoji，**必须保留**） |
| ⑦ 常驻循环体内 `GetService` | 0 |
| ⑧ 过短 `task.wait`（<0.05s 忙等） | 1 处，**有超时上限的轮询**（Gym 识别，≤36 次）⇒ 合理 |
| ⑩ 循环内 `F.Out` 无 限频守卫（日志爆） | 0 |
| ⑬ 功能开关失败可诊断性 | **真问题 ⇒ 已修 19 处**（见上） |

⚠ 别把「88% 的 pcall 结果被丢弃」当缺陷 —— 抽样全是"尽力而为"包（销毁已销毁对象、断开已断开的连接），
逐个记日志只会淹没有效信息。

## ★★ 常驻循环必须带"标志关了自动退出"的自守卫（2026-10-06 v16.9.29）

**判据**：每个 `RS.Heartbeat/RenderStepped/Stepped:Connect(...)` 的**回调体开头**应有
`if not T.X then pcall(F.XDisable) return end` —— **不能只靠外部 Disable 断开**。

**为什么**：只靠外部断开是**单点依赖**。任何一条新路径（新档位/新按钮/新回滚）忘了调 Disable，
循环就会残留，后果按功能不同可能是**灾难级**：
- 反甩循环残留 ⇒ 每帧把水平速度清零 ⇒ **人走不动**
- 穿墙循环残留 ⇒ `CanCollide` 一直 false ⇒ **掉地图**
- 锁血循环残留 ⇒ `MaxHealth` 一直 1e6（异常特征）

v16.9.29 补的 5 处：`AntiFling.fix` / `LockHealth.apply` / `AntiRagdoll.apply` / `NoClip.noclip` / `HUD 循环`。
（其余 28 个循环本来就有守卫。）工具：`_audit_loops.py`（33 个循环一览）。

⚠ 工具局限：`RS.X:Connect(具名函数)` 这种写法，守卫在具名函数体内 ⇒ 工具会误报；
**必须回原文看具名函数的体**。

## ★ 其它两个一次性检查（都可复用）

- **滑块数值边界**：每个 `AddSlider` 的 `Default` 必须在 `[Min, Max]` 内且 `Min < Max`。
  v16.9.29 实测 9 个滑块 **0 异常**。
- **已删能力是否被误加回**：对"用户点名删除过"的能力名做 `grep -c` 必须为 **0**。
  v16.9.29 实测 6 项（ESP方框/追踪线/骨骼/Chams、身份FFlag/栈伪装、配置存档）**全部保持 0** ✅。

## ★★★ 元表钩子：**只许走统一分层系统**，禁止裸赋值 `mt[slot]`（2026-10-06 v16.9.24 修掉的真缺陷）

- 本仓有 `F.MetaInstall / F.MetaUninstall`（**`hookmetamethod` 装、保持函数身份**、按槽分层记账
  `F.MetaLayers[slot][id]`；`MetaUninstall` 会重接链表）。
- ⛔ **禁止**再写 `mt.__namecall = f` 这种裸赋值：
  ① 它**绕过分层表** ⇒ 卸它时会把同槽上别人装的层一起摘掉，而 `F.MetaLayers` 仍 `alive=true`
  ⇒ **反封禁静默失效**（`F.KickGuardPathsDisable` 就是这么干的，且在急停/卸载关闭链里）；
  ② 它**改变 `mt[slot]` 的身份** ⇒ 命中游戏方常见探测
  `if mt.__namecall ~= originalNamecall then flag("__namecall changed")`。
- 分层 id 命名：功能前缀 + 槽位（例 `CMKickNC / CMKickIX / CMKickNIX`）。
- 新增钩子时**先探测全局再使用**：`if type(checkcaller)=="function" and pcall(checkcaller) then ccFn = checkcaller end`
  —— 裸调 `checkcaller()` 在缺该全局的执行器上会让钩子**每次调用都报错**。
- **蜜罐对抗自检**（游戏会往 remote 塞 `setmetatable({}, {__index=function() flag() end, __tostring=...})`）：
  钩子第一行必须能对**不匹配的对象零副作用地原样返回**（`typeof(t) ~= "Instance"` / 不遍历参数）⇒ 才不会被钓。
- ⛔ **改代码别用"按行号多步替换"**：先删行再改行会**索引错位**（v16.9.24 我因此把 `KG.blockSet = {}` 覆盖掉，
  会让钩子里 `blockSet[self]` 索引 nil）。正确做法：**用切片重建整个列表**（`L[:a] + block + L[a:b] + L[b:]`），
  改完用 `difflib` 对整段做逐行 diff 复核。

### `preflight.py`（2026-10-06 新增，**4.5 秒 vs gate 4 分 25 秒**）
一次读盘 + 一次掩码，跑 8 项：编译 / 顶层真局部 / 零引用闭包 / 关闭链 nil 洞 / `F.`·`AC.` 只用未定义 /
`end` 配平 / 界面计数 / `T`·`C` 只读未写。**零告警才算 PASS**。
- ⛔ **必须 `cwd=ROOT` + 传裸文件名**调用 luau：中文路径会让 `luau-compile` 打不开（`Error opening …`）。
- ⛔ 判"写"用 **`T.X` 紧后一个非空字符是 `=` 或 `,`** —— 用"行长第一个 `=` 切左右"会漏掉
  **一行多条赋值**（`T.FullBright = v T.NightVision = v T.NoFog = v`）⇒ 把 `NightVision/NoFog` 误报成只读。
- **两个豁免表**（避免每次人工重判同一批假报）：`KNOWN_OPT_OK`（10 个"读未写但有 `or 默认值`"的可选 C 键）·
  **动态访问豁免**（文件里存在 `T[k]` ⇒ 该名字出现在任意字符串字面量里就跳过）。
- ⛔ `.` 只扫 `F.`/`AC.`：`KG.`/`Trans.` 是状态/配置袋，`KG.blocked10 or 0` 这种"读未写"不是缺陷。

- ★★ **执行器脚本必须有"单实例守卫"**（用户重复跑 loader 会留下多份实例 ⇒ 功能叠加/双倍循环）：
  `getgenv().CM_Instance = { version, unload, gui, handles }`；**加载最早期**（Fluent 之前）先
  `F.KillPreviousInstance()`（取旧句柄 → 调它的 `unload()` → 销毁残留 GUI/`CM_Window` 等）；
  `UnloadAll` 里**只在句柄还是自己时**注销，否则热加载（先 UnloadAll 再 chunk）会自己打自己。
  旧版无句柄时日志要**明说**"只能靠重进游戏彻底清干净"，别装作清干净了。
- ★★★ **Fluent 的开关在"创建时"就会用 Default 值触发一次 Callback**
  （`Elements/Toggle.lua` 构造尾部 `Toggle:SetValue(Toggle.Value)` → `SafeCallback(Callback, Value)`）：
  ① 凡"Default = true"且 Callback 有副作用（改游戏状态/刷日志）的开关，**加载瞬间就会执行一次** ——
     危险（历史"一加载被 267 踢"的来源之一）；要么默认 false，要么加 `_cfgSyncing` 静默标志。
  ② 默认 true 的开关要让日志"只在实际切换时才说"：`local changed = (T.x ~= nil) and (T.x ~= v)`。
- ★★ **清理旧实例要"认人"**：本脚本每个版本都写 `getgenv().CM_Window` ⇒ 用它判断"有旧版残留"，
  但**不要去扫 CoreGui 里所有 Fluent 窗口**（会误删第三方脚本的界面）。
- ★★★ **"卸载/关闭不干净"的排查方法论**（2026-10-01 用一次就抓到真因）：
  ① **差异分析**：抓全文件所有 `function (F|AC)\.\w*(Disable|Restore|Destroy|Uninstall*|Stop*)` 定义，
     与"清理函数体里实际调用到的"取差集 ⇒ 直接列出"有卸载接口却没被调用"的功能
     （实测抓到：`F.AimSet`〔自瞄 BindToRenderStep，最容易被察觉〕、`KillAuraDisable`、
     `BodyHLDisable`、`HideDisable`、`FullBright/NightVision/NoFog Disable`、`InfiniteJumpDisable`、`KickRejoinDisable`）。
  ② **可观测性**：`F.Out` 攒够 300 行才落盘 ⇒ 卸载只产生 1 行 ⇒ **永远写不进日志** ⇒
     "点了没反应"无法追查。清理流程结束必须 `F.LogFlush("卸载")` **立刻落盘** + 报"执行 N 项/失败 M 项" + **事后复核**。
- ★★ **`ipairs` 遇 `nil` 会静默截断**：`{a, b, nil, d}` 只会跑到 `b`，后面清理全不执行且**不报错**。
  清理清单一律 `for i = 1, #list do local fn = list[i] if type(fn)=="function" then pcall(fn) end end`。

## 静态审计：哪些检查真正有效（2026-10-04 实测）

- ✅ 有效且零假报：`luau-analyze` 的 **`FunctionUnused`**（抓出我上轮造成的 `OnRemote` 孤儿）、**`BuiltinGlobalWrite`**（`gcinfo` 伪装是有意的）、**`LocalUnused`**、
  `luau-compile`、`gate.py` 八项、词法体检（中文/不可见字符/换行/链式比较/非法十六进制/重复定义/`return` 后不可达）。
- ⚠ **假报重灾区（判据必须收窄）**：
  `if not T.X then return` 的"自停不自灭火"扫描 —— 用 ±8 行当上下文会跨到相邻函数；必须**块级配对**（Connect 回调体 / while 体），
  且要问"该回调是否持续改写世界状态"（一次性动作 + 守卫的不是问题）。
  连接"没存变量"要排除**已存进表**（`T[#T+1] = x:Connect`）与**有幂等守卫**（`F._wpHooked[i]==inst then return`）的写法。
- ★★ **mask 函数三铁律**：注释与字符串都要写**等长空格**（只 `i+=1` 跳过 = 长度对齐但内容仍在）；
  查"中文在代码区"必须用**去字符串**视图；数括号/关键词用**第三视图**（去字符串）。
- ★ 判断"开关拨了没效果"：**先查读取点有没有 `or 默认值`** —— 本项目 24 个"只读不写"的 C 键全有兜底 ⇒ 不是 bug（历史删控件时做对了）。

## 接口查找的坑（2026-10-04，14.0.28）★ 改 remote 查找前必看

- ★★★ **`findRemote` 曾自相矛盾**：先用 `"rev_"..name` 去 `FindFirstChild`（**找对了带前缀的**），
  再交给 `ok2` 校验，而 `ok2` 写的是 `o.Name == name`（**精确相等**）⇒ `rev_S_Interact ≠ S_Interact` ⇒ 返回 nil。
  ⇒ **症状是"功能静默全废"**（售卖 0 / 收钱 0 / 收起 0），日志只说"没找到 X 的 Remote"。
  ⇒ 修法：拆 `typOk`（只校验类型）与 `ok2`（精确）；加"带前缀直取 + 递归搜索（大小写 + rev_/ref_ 四种变体）"。
  ★ **教训：凡"先取后校验"，两边的判据必须一致** —— 一边放宽（取）一边收紧（校验）＝ 永久失败且无报错。
- ★ 不同游戏的 remote 前缀不同（该游戏全是 `rev_` / `ref_`）⇒ **查找必须容错**：精确 → 带前缀 → 大小写 → 递归。

## ★★★ `ipairs({ ... })` 里的 nil 会静默截断其后全部元素（2026-10-04 实锤，14.0.76）

- 事故：`F.AutoSaveDisable` **全项目无定义**（只有遗留标志 `T.AutoSave` / `F.PANIC_KEEP.AutoSave`），
  却被写进两个"关闭链"数组：`F.PanicKeyDisableAll`（急停）与 `UnloadAll`。
- Lua `ipairs` **遇第一个 nil 即停** ⇒ 其后 **19 个 Disable 从未被调用**
  （含 `SpeedRestore / FlySet / FlyDestroy / BypassDisable / MetaHookUninstall / SilentAimDisable / LockFieldsUninstall` …）
  ⇒ **"一键全关"后加速·飞行·绕过仍开着**，而日志照样打印"已执行 N 项"。**无任何报错**，最阴的一类。
- ⛔ **铁律**：往 `ipairs({ ... })`（或任何按序数组）里加成员前，**先确认每个成员都已定义**；
  只要有一个 nil，后面全废。可用 `gate.py` 的「F/AC 成员只用未定义」项自查（但它退出码是 0，不拦发版 —— **要自己看输出**）。
- ⚠ `gate.py` 的 `use-before-decl` 是**误报**：不认「表函数参数」(`function T.f(a,b,out)`) 与「多名字声明」(`local a,b,c = ...`)。
  ★ 2026-10-05 复核：修复前后命中**都是 131 处** ⇒ 它既**漏报**（见下条 `local function`）又**大量误报**，只能当提示、不能当判据。

## ★★★ `local function` 定义在调用点之后 ⇒ 引用落到 nil 全局（2026-10-05 实锤，发 v16.7.1）

- 事故：`F.GodModeSet`(L5609) 里 `pcall(LockHealthEnable)` / `pcall(NoDeathEnable)` / `pcall(LockHealthDisable)` / `pcall(NoDeathDisable)`，
  而这 4 个是定义在 **L7038.. 的 `local function`** ⇒ Lua 词法作用域只看**文本位置** ⇒ 在 L5617 处它们解析为 **`_ENV` 上的全局 = nil**
  ⇒ `pcall(nil)` **不报错、直接返回 false** ⇒ 「上帝模式」声称开了锁血+不死，实际**两个子功能从未建立连接**，日志还照打"已开"。
  ★ 同文件里 `GodEnable/GodDisable`(L3634/3646) 定义更早 ⇒ 那两个是好的 —— **同一个函数里好一半坏一半**，最难看出来。
- ⛔ **铁律**：**表成员（`F.X = function()`）是运行时解析，函数体写完再定义也行；但 `local function` 是编译期解析，写在后面就是 nil。**
  即：**别把 `local function` 当"反正最后都会定义"用** —— 它只在定义点之后可见。
- ✅ **自查手段**（比 gate 有效）：`luau-analyze` 的 `Unknown global 'X'`，扣掉 gate 白名单 ⇒ **白名单外的就是真缺陷**。
  ⚠ 它在本机**要跑 10 分钟**，而 `gate.py` [8] 给的超时是 **300s** ⇒ **门禁 [8] 永远超时跳过，并因为 `out=""` 反而打印"白名单外 0 个 OK"= 假通过**。
  要真查就得单独跑、把输出落盘再筛。
- 修法（不改作用域、最小改动）：在调用点**之前**加一行顶层前向声明 `local A, B, C, D`，把定义处 `local function X()` 改成 `X = function()`。
  顶层"真局部"计数净增 0（声明 +N、`local function` −N），不触发 Luau 200 上限。
- ★ 同轮另修 3 个同源缺陷（都是"裸全局恒 nil ⇒ 分支恒假/静默失败"）：
  `type(Window)`（`Window` 是更晚的 local ⇒ 兜底死代码，改用创建时登记的 `F.Window`）·
  `VirtualInputManager` + `virtuaimgr`（前者的正确写法是 `game:GetService("VirtualInputManager")`，执行器**不提供**裸全局；后者根本不存在）·
  `restorefunction` 缺 `type()` 守卫（同文件另一处是有守卫的 —— **同 API 两处写法不一致时，宽松的那处就是 bug**）。

## ★★★ 状态表「读写配对」审计法（2026-10-05 抓出真 bug，v16.7.2）

**适用**：任何"开关拨了没反应 / 状态显示不对"的问题；比逐行读代码快得多。

- 做法：把 `T.X`（或 `C.X`）的**每一次出现**分类为**写**还是**读**，取 **`读集 − 写集`**（只读未写）与 **`写集 − 读集`**（只写未读）。
- ⛔ **判据只能用一条，另两条都踩过坑**：
  ① 用 `(?!\s*=)` 前瞻判断"不是写" ⇒ **正则回溯**把名字截掉末字符（`AntiFlash`→`AntiFla`），结果全废；
  ② 用"行内第一个 `=` 切左右" ⇒ 漏掉 `Callback = function(v) T.X = v end`（`=` 在 `T.X` **之前**）⇒ 大面积误报。
  ⇒ **正解**：只看 `T.X` **紧后面**那几个字符是否 `=`（且非 `==`）——用切片取值，不要用前瞻。
- ⛔ **多值赋值 `A, B, C = x, y, z` 的左侧 `T.B`/`T.C` 会被漏判**（后面是逗号）⇒ **每条命中都必须回原文确认**。
- ★ **降噪启发式（最有用的一条）**：只读未写的键 `K`，若存在**近似写入键**（`K+"On"` / `K+"Set"`）
  ⇒ 基本就是**键名写错**。v16.7.2 抓到的唯一真 bug 正是：快捷键面板 `get` 写 `T.Fly`/`T.Speed`，
  而全项目状态键是 `T.FlyOn`/`T.SpeedOn` ⇒ 面板上"飞行/加速"**永远显示为关**。
- ★ **判定"孤儿 vs 真缺陷"的决定性一问**：**该功能在 UI 里有没有开关**？
  没有入口的只读未写键（本轮 7 个：`Regen`/`AntiKnockdown`/`CarryGuard`/`FovCircle`/`NoDrop`/`ACBypass`/`SpeedMask`，
  连 `Enable` 函数都无人调用）⇒ **历史删控件留下的孤儿代码**，用户碰不到，**不是 bug**，别当新发现去"修"。
- ★ **不是 bug 的两条**：**死形参**（`F.GuardSet` 的 `lock`/`dodge` 调用点全传 `false`、体内无动作）·
  **可选参数**（`F.walk(root,cap,budget)` 体内有 `or 默认值`；`full3d` 那种"当布尔用"的也算正常）。
- ★★★ **孤儿的第 2/3 种形态**（2026-10-05 透视检查实锤 —— **别只查"开关有没有入口"**）：
  ② **列表/下拉框的「刷新函数」是孤儿** ⇒ 列表**永不更新**：`F.LivePlayersEnable`
     （监听 `PlayerAdded/Removing` → `RefreshPlayerDropdowns`）**全项目无人调用** ⇒ 目标玩家下拉框
     **只在脚本加载瞬间填一次**（`Values = F.PlayerNames()`），之后进服的人**永远选不到**（传送/针对玩家直接受影响）。
     判据：`grep` 全部 `Refresh*/Update*/Sync*` 定义，**只有定义没有调用**且 UI 初始值是**一次性快照** ⇒ 就是它。
  ③ **同一用途存在「新旧两套实现」**（前缀不同）：金色 `Ix`（有开关）vs 橙色 `IA`（**无入口**，只被
     `F.BodyHLEnable/Disable` 偷偷带起）⇒ 同时开会**在同一物体上叠两个 Highlight**（颜色打架 + 开销翻倍）。
     判据：搜同义词的两组前缀（`Ix/IA`、`Npc/NPC`、`HL/Mark`…），各自数 **UI 入口数**，**入口 0 的那套 = 隐藏副作用**。
- ⛔ **跨服务器看人：Roblox 架构上不可能**（别向用户承诺）：客户端只有 `Players:GetPlayers()`（= 当前服）；
  公开 API 只能拿"其他服的人数"，拿不到人是谁/在哪。能做的只是"**换服/换游戏一样通用**"。

## ★★★ 启停配对审计法（2026-10-05，抓出"关不干净"，v16.8.0）

**适用**：用户说"确保每个功能开启后关闭能恢复" / "关不掉、有残留"。
工具：`.workbuddy/build/_audit_en_di2.py`、`_audit_en_di3.py`（逐对比较 `XEnable` 与 `XDisable`）。

- 做法：对每一对，Enable 里提取 **改了哪些"实例.属性"** / **装了哪些钩子**，
  再看 Disable 有没有对应收尾（同属性赋值 / 卸钩 / 断连 / 销毁）。
- ⛔ **三个必须避开的坑（全部踩过，代价是整轮结论作废）**：
  ① **块配平只能用门禁那条公式**：开 = `if`+`do`+`function`+`repeat`，闭 = `end`+`until`。
     把 `for`/`while` 也算成开（它们**自带一个 `do`**）⇒ 每个循环残留 +1 ⇒ 块范围一路吃到文件尾
     （实测 42 行的函数被算成 6775 行），命中数从 7 涨到 30、全是噪音。
  ② **必须用「去注释 + 去字符串」视图配平**：否则 `F.Out("...end...")` 这类字符串里的关键词会破坏配平。
     提取（找 `hookfunction`、找属性赋值）也要用这个视图，避免日志文案里的词被当成代码。
  ③ **判"有没有收尾"不能只认 `Disconnect/Destroy/restorefunction`** —— 本仓还有三种合法收尾写法，
     漏认就满屏假报：**保存表还原**（`F._xBak[obj].CanTouch = bak`）、**反钩式还原**（`hookfunction(target, orig)`）、
     **`:Enable()` 接回**（把游戏的连接 `Disable` 掉、关闭时 `Enable` 回来，如血量隔离/陷阱守卫）。
- ★ **判定"要不要还原"的语义问句**：这个写入是**持续状态**还是**瞬时纠正**？
  持续状态（透明度、DisplayDistanceType、CanTouch、Fog/Brightness、速度上限）⇒ **必须还原**；
  瞬时纠正（每帧写 `AssemblyLinearVelocity`/`CFrame`/`hum.Jump`）⇒ 关掉后由物理/游戏接管，**不用还原**。
  ⛔ 反例：`SpeedFree` 只把被压低的 `WalkSpeed` 抬回 16，**"不还原"正是它的语义** —— 别当 bug 改。
- ★ **实测结论（v16.8.0 那一轮的净值）**：66 对里真正缺还原的只有 **1 个**（`Invisible` 的 `DisplayDistanceType`，
  关掉后名字/血条对别人永久不可见直到重生）。其余全是 ③ 类假报 ⇒ **这套扫描的价值在"收窄"，不在"命中多"**。
- ★★ **接回"有实现但没开关"的功能时，先查三件事**（本仓 v16.8.0 接回 4 个，全部零风险）：
  ① `Enable/Disable` 是否**都已存在**且能自停（回调里有 `if not T.X then XDisable() return end`）；
  ② **关闭链数组里是否已包含它的 Disable**（本仓 4 个全都在）⇒ 急停/卸载自动覆盖，不用另加；
  ③ UI 回调**照抄本仓既有写法**：`T.X = v` → `if F._cfgSyncing then return end` → `pcall(Enable/Disable)`。
  ⇒ 三条都满足时，接回只是"加一个开关"，不动任何逻辑 —— 这是最安全的"加功能"形态。
- ★ `local function` 在 UI 区可见性：UI 代码在 L14xxx，`local function` 定义在 L7057 ⇒ **在后 ⇒ 可见，无需前向声明**；
  反之（引用在定义之前）才是上一轮那种 nil 全局缺陷。

## ★★★ 下拉/配置项的「UI 文案 ↔ 代码判断字面量」必须成对（2026-10-05，v16.8.1 实锤）

- 事故：自瞄「瞄准点」下拉的选项文字为了好懂改成了 `头(爆头用 · 可能被墙挡住)` / `躯干(稳 · 几乎不会被挡)`，
  而代码仍是 `if wantPart == "头" then` ⇒ **精确相等永假** ⇒ **选「头」「躯干」从来没生效过**（一直按默认部位打）。
  ⇒ **这是"缺能生效"里最隐蔽的一类：界面正常、下拉能选、日志不报错，就是没用。**
- ⛔ **铁律**：**凡"从下拉/输入取值再分支判断"，一律用 `t:find(关键词, 1, true) ~= nil`，禁用 `==` 全字面量比较。**
  理由：本仓的 UI 文案常带括号解释、还会随时润色 ⇒ 用 `==` 等于把**文案**当**协议**，改一次文案就静默坏一次。
- ★★ **对应的审计必须跟一层局部变量**（这条用三轮才迭代对，务必记住）：
  只扫 `C.<Id> == "字面量"` ⇒ **全假阴性**（0 命中）；真码是
  `local wantPart = tostring(C.AimPart or "")` 之后再用 `wantPart` 比较。
  ⇒ 正确写法：先找 `local VAR = ...C.<Id>...`，再在后续约 60 行内找 `VAR == "..."` / `VAR:find("...")`，逐条比对该下拉的 `Values`。
  （脚本：`_audit_dropdown_indirect.py`）
- ★ 同类干净的判据（顺手一起扫，都不花时间）：
  - **控件 Id vs 回调写的 C 键**：不同名 ⇒ 多半是配置存错键（本仓 C 键既是存档又是读取点）。
  - **开关 Id vs 回调写的 T 键**：不同名 ⇒ 只有"合成开关"是正常的（一个开关写多个 T 键）。
  - **滑块 Min/Max vs 代码 clamp**：`math.max/min` 的常规用法（取大/取小/夹范围）不是缺陷，别误报。
- ★ **"合并类"需求的正确做法**：用户说"不需要拆开"时，**往已有的合成开关里加成员**（T 键 + 启停分支 + 标题/描述），
  并**删掉新加的那个独立开关**；不要保留两个入口（会互相打架、也会让急停链重复调用）。
  ★ 选合并对象看**是否共用同一套底层函数**：`CarryGuard` 与「护蛋」同用 `F.EggLock`/`EggGuardTick` ⇒ 就该并进「防护(合成)」。

## ★★★ 删代码的三条硬规矩（2026-10-05 v16.8.4，两次把源码改坏才总结出来）

1. **`cut_between(起点, 终点)` 删的是「起点行 ~ 终点行的上一行」**。
   ⛔ **别拿块自己的 `end` 当终点** —— 那次就把它删了，导致整个函数缺 `end`。
   ⇒ 终点一律取**块之后的第一行**（下一个函数/下一个顶层赋值），或者用 `cut_replace(start, stop, "end")` 显式补回闭合。
2. **删"表达式里的最后一段"要连它前面的 `..` 一起处理**。
   只删 `" · 上行采集 " .. #F._capLog .. " 条")` 会留下 `... ..` 后面直接跟 `)` ⇒ `Expected identifier, got ')'`。
   ⇒ 正确的旧串要**含上一行末尾的 `..`**：`#snap.scripthashes ..\r\n" · 上行采集 " .. ...` → 换成 `#snap.scripthashes)`。
3. **每改一次就 `luau-compile`，并用 `build/backup/` 回滚重做**（不修破文件）。
   本仓 `pre-*` 备份习惯救了两次；**"先备份→改→立刻编译"三步不能省**。
4. ★★★ **删一个 `T.键` / UI 开关之前，先 `grep` 它有没有被「另一条渲染路径」共用**
   （2026-10-05 v16.9.1 实锤）：本仓 **对象 ESP（NPC/道具/陷阱/载具/掉落）与玩家 ESP 共用
   `T.EspBox`/`T.EspName`/`T.EspDist`**（`F.EspMakeObj` 建 `rec.box`/`rec.name`，绘制处用同一批 T 键判断）
   ⇒ 删 `T.EspBox` 会让**对象框恒不显示、对象 ESP 直接废掉**。
   ⇒ 正解不是删判断，而是**把对象那边改成无条件绘制**；并且 `F.EspHideRec` / `F.EspClear` 里
   **保留 `rec.box` 的隐藏/销毁行**（玩家 rec 无 box ⇒ 那句 `pcall` 必失败但被吞掉，无害；对象 rec 靠它收尾）。
   ⚠ 判据：**别只看这个键出现在哪个 UI 段落**，要 grep **全部读取点**，确认有没有第二处渲染逻辑也在读它。
5. ⛔ **`rep(old, new)` 里 old 与 new 的行尾必须"同样带或同样不带"**（2026-10-05 v16.9.4 实锤）：
   我漏写一个 `+ C` 在 new 结尾、而 old 带了 `+ C` ⇒ **换行被吃掉、两行粘成一行**，产生
   `endF.IxAdd = function(o, col)` ⇒ 编译报 `Expected 'end' (to close 'function' at line N), got 'endF'`。
   ⇒ **症状识别：报错里出现 `got 'xxxYyy'` 这种"两个 token 粘在一起"的串，就是被吃了换行**。
   ⇒ 查法：`grep -nE 'end[A-Za-z_]'` 找粘连点；**改完必须立刻编译**（本次靠 `build/backup/` 回滚重做）。

- ★ **删一处要顺手做传递闭包复扫**：删掉 `F.CMX_TierSync` 的尾巴后，`F.CMX_TierLevel`/`F.CMX_TierMap`/`F.CMX_TierOwn`
  的唯一使用者就没了 ⇒ 变成新孤儿，必须一起删（本次连删 4 处）。查法：对刚删掉的标识符 `grep` 全项目，看只剩"定义"没有"使用"。
- ★ **判"某块是不是死代码"的高效信号：函数体第 2 行就 `do return end`** ⇒ 其后全是不可达（本次 49 行）。
- ★★ **统一复查脚本 `_sweep_all.py`**（一轮跑完 11 类）：T 键读写配对 / 疑似键名写错 / 下拉字面量(直接+间接) /
  控件 Id↔C 键 / 关闭链 nil 洞 / F.X 重复定义 / F.Once 撞车 / F.LogRate 撞车 / 拼接 nil / Enum 项 / 常驻循环守卫。
  ⛔ **它自己的两个判据坑**（都踩过，会让结果全假报）：
  ① 收集"已声明的 local"**必须含多名字声明** `local A, B, C, D`（本仓前向声明就这么写），否则把好代码报成 nil 洞；
  ② 从 `X = RS.Heartbeat:Connect(...)` 取连接变量要用 `= .*:Connect` 匹配，别去上一行找 `X =`（常常找不到 ⇒ 报成"无断开"）。

## ★★★ 「关了界面，世界还留着痕迹」——循环自停审计（2026-10-05，v16.8.5 抓 5 处真 bug）

- **判据**（脚本 `_audit_selfstop.py`）：在每帧回调里的 `if not T.X then <rest> return end`，若 rest 里
  **没有 Disable/Destroy/Restore** ⇒ 大概率是"只停循环、不还原世界状态"。
- ★ **本仓 14 处命中，逐条回原文后只有 5 处是真问题** —— 这条审计**必须人工复核，不能照着改**：
  - 真问题：`GodMode`（无敌态全留 + **TakeDamage 钩子不卸**）· `NoPull`（**`__newindex` 元表钩子一直挂着**，
    跨脚本生效、重载也救不回）· `AllyMark`（队友头顶 BillboardGui 名字牌留着）· `SpeedFree`/`AutoPick`（连接空转）。
  - **假报三型（必须先排除，否则会改坏正确代码）**：
    ① 那根本不是循环，是**按需调用的函数**（`F.SpeedApply`/`F.CarryRescan`）——判据"前 8 行有 Connect"会误命中；
    ② 循环体里**本来就调了 Setter**（`F.IASet(false)`/`F.IxHLSet(false)`…）；
    ③ **同功能有两个循环，兄弟循环负责收尾**（`BodyHL`：墙检测循环只 `return`，但补建循环 `_hlLoop` 会调 `F.BodyHLDisable()`；
       `NpcHL` 同理 `_npcLoop` 调 `F.NpcHLSet(false)`）⇒ 已覆盖，不用动。
- **修法**：`if not T.X then <自己那个 Disable>() return end` —— **"关"必须是显式动作**。
  ⚠ 从自己的回调里调自己的 Disable（内部会 `Disconnect` 自己这条连接）在 Roblox 里是安全的。
- ⛔ **别用"全功能总 Disable"当自停**：`F.BodyHLDisable` 顺带会关 NpcHL / IASet 的显示 ——
  只关 BodyHL 却调它会误伤别的功能。**自停要调"只属于自己的那一个 Disable"。**

## ⛔ `luau-analyze` 的**行号不能信**（2026-10-05 实测）

- 它报 `CheatMenu-16.8.3.lua(14035,34): math.floor expects ... given a nil`，而**那一行根本没有 `math`**
  （该文件里 `math.floor` 在 2468/7226/8049/8546…）。同一份输出里 `FunctionUnused` 的行号**却是准的**。
- ⇒ **当作"类型/未定义提示"用，位置一律自己回原文 grep**。别照它的行号去改代码。
- 值得采信的**类别**：`Unknown global`（扣白名单 ⇒ 真缺陷）· **`GlobalUsedAsLocal`（= "local 声明晚于使用 ⇒ 静默写成全局"，真 bug；本仓 0）** ·
  `FunctionUnused`（本仓抓到 `Fire`/`FireAny` 两个死函数）· `DuplicateLocal`/`UnknownSymbol`/`UnreachableCode`/`DeprecatedApi` 全 0。
- 它点名的 `expects a number/string, given nil`，**手工复核后 0 个真崩点**：要么有 `type(x)~="string"` 守卫、
  要么包在 `pcall` 里。⇒ 别按它去加一堆无谓判空。

## ★★★ 「看穿墙（X-ray）」的正确实现（2026-10-05 v16.9.0，`F.XRaySet`）

- 原理：把**除玩家角色外**的所有 `BasePart` 在本机渲染层设 `LocalTransparencyModifier = 1` ⇒ 墙/建筑不可见 ⇒ 看到墙后。
- ★ **用 `LocalTransparencyModifier`，不要改 `Transparency`**：前者是**本地渲染叠加层**，
  **不需要记录原值**、关掉 `= 0` 即完全恢复，也不会毁掉玻璃/水**原本就有的**透明度；
  后者是真实数据，必须逐个记原值才能还原（本项目"改盘类任务"要求给还原路径）。
- ⚠ **两个必做**：
  ① **排除玩家角色**（`FindFirstAncestorOfClass("Model")` + `Players:GetPlayerFromCharacter`）——
     否则角色自己也被隐形，而且 **Roblox 默认相机脚本每帧会重置角色部件的该属性**（排除了就不冲突）；
  ② **地形 `Terrain` 不受该属性影响** —— 别向用户承诺"连地形也看穿"。
- 结构：开启时 `GetDescendants()` 全量一次 + `DescendantAdded` 增量 + 心跳(3s) 清理失效引用；
  关闭时遍历已记录集合 `= 0`。`GetChildren()` 拿到的是 GUI/Highlight 等非 BasePart ⇒ 它们**不受影响**（ESP 照常可见）。

## ★★★ 孤儿代码「彻底清除」五步法（2026-10-06，v16.9.18，源码 −2,155 行）

工具：`.workbuddy/build/_orphan_full.py`（扫描）· `_orphan_purge.py`（P1 界面/P1b 死半边/P2 闭包）·
`_orphan_purge3.py` / `_orphan_purge4.py`（死值/死状态/死分支）· `_orphan_closure.py`（独立闭包）· `_graph_reach.py`（调用图，仅供参考）。

1. **零引用闭包**：`F.X = function` / `local function X` / `function X` 除自己外零引用 ⇒ 死；**迭代到不动点**（删 A 会让只被 A 调的 B 变死）。
2. ★★★ **"死功能半边"**：`F.XEnable` 零引用 ⇒ 功能永远开不了 ⇒ `F.XDisable` 也是死的 —— 但它**被关闭链引用**、单纯零引用扫不出来。
   ⇒ 成对删，并**必须从 `ipairs{...}` / `steps{...}` 清单里逐个摘名**（留 nil ⇒ 其后 Disable 全不执行）。
3. ⛔ **`local` 值别进闭包**：同名不同作用域被合并成超大区间 ⇒ 结论全废（实测 `L.from` 被算成 3,126 行）。
   闭包**只做"文件级函数 + `F.*` 字段"**；`local` 值改用"全文件只出现一次"判据单独扫。
4. **死值/死状态**：`F.X = <值>` 全文件只出现 1 次 ⇒ 死；多值赋值 `A,B = x,y` 里的死成员**两侧一起摘**。
5. **回归闸**：删完回扫 T/C 键，看**"只读未写/只写未读"是否新增**；新增项要回原文确认"写入方是否本来就在被删函数里"
   （v16.9.18 新增 3 个：`T.CMX_HookHard`/`C.FlyDrive`/`C.SpeedDrive` —— 写入方本就在零引用函数里 ⇒ 行为零变化）。

**验收（缺一不可）**：编译 0 错 · 孤儿复扫=∅ · 门禁[4] 未定义成员=0 · 关闭链 nil 洞=0 · 门禁[6] 配平 · 门禁[8] 白名单外=0 · 等价性通过 · raw 一致。
★ **删完顺手查"指向已删功能的过期文案"**（v16.9.18 抓到「点一键藏匿」×2、「建议开钩子加固」、「并自动导出」）。

## ★★★ 状态键的**动态访问**：`T.*` 的"只写未读"**不能当死码删**（2026-10-06 v16.9.19 差点误删）

- `F.PANIC_KEEP = { CharPersist=true, AutoSave=true, GuiProtect=true, AutoAFK=true, ... }` 配
  `for k in pairs(F.PANIC_KEEP) do keep[k] = T[k] end` ⇒ **用字符串 key 动态读 `T.AutoSave` / `T.CharPersist` / …**。
- ⇒ 静态"只写未读"扫描（只看字面 `T.X`）**看不见这种读点** ⇒ 按它删 flag 会**直接破坏急停逻辑**。
- ★★ **判据**：看到 `T.X` / `C.X` 只写未读，**先 grep `T[` / `C[`**；只要存在 `T[k]` 这类动态访问，
  且 key 来自某个白名单表 ⇒ **保留，不许删**。同理 `F[k]` / `AC[k]`。
- ★★★ **第二条动态读通道：`F.CfgSyncUI` 用控件 id 当 key 读 `T[name]` / `C[name]`**（2026-10-06 v16.9.22 实锤，
  我因此在 v16.9.21 造了个真回归）：
  ```
  for name, opt in pairs(Fluent.Options) do ... local want = (ty=="Toggle") and T[name] or C[name] ...
  ```
  `CfgSyncUI` 被 `PanicKeyDisableAll`（L7631）、`ProtectTierApply` 等调用 ⇒ 它把 T/C 回填进界面。
  ⇒ **凡 `T.X` / `C.X` 的 `X` 与某个 `AddToggle("X"` / `AddSlider("X"` … 的 id 同名 ⇒ 一律视为"被动态读"，绝不许当死标志删。**
  症状（删错后）：点「一键全关」时那些开关**界面仍显示"开"、功能已关**。
  ✅ 已落进 `_verify_effect.py` 的 `is_read()`；同时把 `T.GuardAll/T.Mute/T.TPMouse/T.LockLog` 写回。
  ⛔ 真正可删的只有：**既无字面读、又存在 `T[X]` 动态访问、且 X 与任何控件 id 都不同名**（如 `T.FOV`/`T.Zoom`/`T.HitLock`/`T.TrapDodge`）。

## ★★ 效果链验证器 `_verify_effect.py`（2026-10-06 v16.9.22 新增）

- 回答"这个开关点下去到底改了什么"：控件 → 回调 → 调用的函数（**必须抓 `pcall(F.X)` 传引用写法**、
  文件级 `local function`、`Trans.X` 方法表）→ 调用图传递闭包 → 是否触达真实引擎状态
  （改属性 / 挂钩子 / 连事件 / 建对象 / 调服务 / 改文本）；只写标记的控件再查标记有无读方。
- ⛔ 我写它时踩的两个**工具自身**bug（别再犯）：
  1. **掩码器必须同时处理单引号和双引号** —— 源码 L1223 `gsub('[\\/:*?"<>|]', "_")` 里的 `"` 会让
     只认双引号的状态机翻转且不复位 ⇒ **该行之后整段被吞**。（`preflight.py` 的 `mask_short` 是对的。）
  2. **块配平只把 `do` 当开块**，别把 `for` / `while` 也算进去 —— `for ... do ... end` 是**两个开关键字对一个 `end`**，
     算了就永远配不平，函数体被误判成 1 行。

## ★★ 官方分析器 `LocalUnused` = 抓"半接完功能"的好判据（2026-10-06 v16.9.19 实锤）

- 本轮唯一真 bug 就是它抓的：护蛋自动捡起写 `local best, bestD = nil, 8`（8 = 最远距离），
  但**挑选时没用 `bestD`**，实际是"取遍历到的第一个名字匹配" ⇒ 锁到远处/别人的东西。
- ⇒ 见到 `LocalUnused` 里**语义像"上限/最佳值/索引"的名字**（`best*` / `max*` / `min*` / `idx` / `cnt`），
  **别当噪声**：很可能是"原本打算用它挑最优，写完忘了"。
- ⇒ 纯 `local i` + `for i = 1, #t` 那种是**故意**的（少建一个 per-loop 局部），跳过。

## ★ 改 UI 文案前先确认"没有代码读它"（2026-10-06 v16.9.19）

- 删 `Description` / 改 `Title` 是安全的 **当且仅当**：全项目 `grep '\.Title'` 无命中（Fluent 只用它显示），
  且**下拉的 `Values` 一个字都不能动**（代码靠 `:find("头"/"躯干"/"正面")` 之类判断 ⇒ 改了就静默坏）。
- ⚠ 但有例外：`line:find("防护档位", 1, true)` 这类**日志关键行匹配** —— 它匹配的是 `F.Out("[防护档位] …")`
  里的**日志 tag**，不是 Title ⇒ 改 Title **不影响**，但**不许改日志 tag**。

## ★★ `F._x = task.spawn(function() ... while F._x do ... end end)` 有时序竞态（2026-10-08）

- **赋值发生在 `task.spawn` 之后** —— 若某执行器的 `task.spawn` 是**同步立即执行**，循环首轮读 `F._x` 得到的是旧值，
  **整个循环体一次都不跑**（表现：功能"开了没反应"，且没有任何报错）。
- ★★ 正解：**先置标记，再 spawn** ⇒ `F._x = true` → `task.spawn(function() while F._x do … end F._x = nil end)`。
- 判据：任何"用自身标记控制自己循环"的写法，都要检查标记**在 spawn 之前**是否已可见。
- 本轮是靠**离线验证的 mock**（同步 spawn）抓出来的 —— 真实 Roblox 的 `task.spawn` 是异步的，
  所以**这个坑只在 mock/其他执行器暴露**；写测试时 mock 成同步执行反而更有价值。

## ★ 改「生成器脚本」之后必须核对生成物结构（2026-10-08 踩坑）

- 现象：用 Edit 改 `mouseguard.py` 时误删一行 `F.XXXBoot = function()` ⇒
  `task.wait(1.2)` 与 `pcall(...)` 变成**顶层代码**，脚本加载时**阻塞 1.2 秒**；而断言**全部通过**（它只查新字符串的存在性）。
- ★★ 铁律：生成器改完，**除了看断言，还要 grep 生成物的关键行号/缩进**（本次靠 `grep -n "F.XXXBoot = function\|task.wait(1.2)"` 发现
  `task.wait` 落在函数定义之后、却与 `function` 行号相邻不符，才确认结构错了）。
- 同理：任何"删一行/插一行"的 Edit，都要想清楚**它是否兼作某个块的边界**。

## ★ 改"被自愈逻辑守护的常量"必须连自愈判断一起改（2026-10-08）

- 实例：`F.FullBrightEnable` 把 `Lighting.Brightness` 设成 `3.5`，而 `F.LightReassert` 里写死
  `if L.Brightness ~= 3.5 then pcall(F.FullBrightEnable) end` 做自愈（每 2 秒 + 属性变化时）。
- ⇒ 只改 `3.5 → 2` 而不改自愈判断 ⇒ **每 2 秒被改回 3.5**，等于没改。
- ★ 规矩：看到"X = 某常量"就要 `grep` 这个常量在**自愈/守护/校验**里有没有被比较 —— 一起改。

## ★ 写 mock 时必须与真实 API 的"返回值个数"对齐（2026-10-08）

- 实例：本项目 `GC()` 真实返回 **(char, humanoid, root) 共 3 个**，调用方写
  `local okg, _, _, root = pcall(GC)`（`pcall` 后第 3 个即 root）。
  我在测试里把 mock 写成返回 4 个 ⇒ `root` 取到 nil ⇒ 误判"功能恒返回 0"，白查一轮。
- ★ 另外：断言时**不能用"新建的等价对象"当 table key**（`t[mk(1,"npc1")]` 永远为 nil），必须用**同一对象**。

## ★★★ 补强/重构类需求：第一步必须 `grep` 自家实现（2026-10-08）

- 背景：用户说"看看别人怎么做，学习补强一下"，我按参考脚本准备加两项（事件驱动回血、倒地自动起身）——
  **结果两项我方源码里都早就有了**（`HealthChanged:Connect` @7819/7866、`AntiKnockdown` @3128-3145）。
- ⇒ 若没查就写，会得到**两套互相干扰的逻辑**（重复监听、双份属性写入、行为抖动）。
- ★★ **规矩**：任何"补强 / 优化 / 学习别人做法"的需求，动手前先按 **能力名 + 同义词 + 底层 API 名**
  （如 `HealthChanged`、`ChangeState`、`GetStateEnabled`）全项目 grep，把结论分成三态：
  **① 已有且有入口 / ② 已有但没入口（孤儿）/ ③ 真没有** —— 只对 ③ 动手，② 视情况接回，① 直接跳过。
- 本轮的**正确产出**因此变成"发现并修掉一个既有 bug"（LockHealth 与 GodMode 每 0.25s 互抢血量控制权），
  而不是"新增两个冗余功能"。

## ★★★ 扩大搜索范围 = 必须同时加"规模上限"（2026-10-08 实锤事故）

- 事故：给「高亮透视」加「**向上找 4 层父级**」以便找到深层物件 ⇒ 某个小 part 的**祖先**是**巨型区域模型**
  （名字含 `trap`/`item`，或含 `ProximityPrompt`）⇒ 被整体高亮 ⇒ **整块地图染色、全屏变红**。
- ⇒ **铁律**：任何"向上找父级 / 空间查询（`GetPartBoundsInRadius` 等）/ 递归祖先 / 扩散匹配"的改动，
  都必须**同时加规模上限**（`BasePart` 用 `Size.Magnitude`、`Model` 用 `GetExtentsSize().Magnitude`，
  取不到或 NaN 时**放行**而不是拦截）。
- 自问句：**"这个被捞出来的东西，会不会是 1000 格大的？"** 会 → 跳过。
- 附带：范围类改动**一定要加"跳过了多少个"的日志**，否则用户只看到现象、看不到原因（本轮靠它自证）。

## ★ 用户报障时的归因不可全信：要同时看"他还开着什么"（2026-10-08）

- 用户说"开了上帝模式、反复开关就这样了"，实际日志显示同屏还开着
  **高亮透视(300 格内 116 个) + 身体高亮 + 敌我识别** —— 真凶是后者（我上一版引入的回归）。
- ⇒ 排障顺序：① 读**用户机器上的真实日志**（别猜）→ ② 列出"那一刻**所有**开着的东西"
  → ③ 再回到他点名的功能（**点名功能常只是"他刚动过的东西"，不等于肇事者**）。

## ★★★ `Disable()` 是单向的：`Enable()` **不会补跑回调**（2026-10-08 v16.10.91 实锤）

**事故形态**：`血量隔离` 用 `getconnections` 把**游戏自己的** `humanoid.HealthChanged` /
`GetPropertyChangedSignal("Health")` 监听 `Disable()` 掉（目的是"游戏看不到我们改血"）。
结果：游戏那边由 `HealthChanged` 驱动的**受伤红边覆盖层**，在"红屏正显示时被禁用"之后就**停在红色上**；
`Enable()` 回来也**不会立刻补跑**，只等下一次事件 —— 而血量已被我们顶成满值 ⇒ 不再有事件 ⇒ **红边永久卡住**。
用户原话「反复开关上帝模式就这样了」。

**规矩**：
1. 任何"禁用别人的事件连接"的功能，必须回答：**它当时正在驱动什么可见状态？解冻由谁负责？**
2. 关闭时要么**人为制造一次事件**唤醒它（本例 `F.DmgFxThaw()`：`MaxHealth` 抖 ±0.01 触发 `HealthChanged`，
   **不降血**、不触发受伤），要么**根本不装这条禁用**。
3. 排查时先确认"这红/这框是不是我们画的" —— 用 `grep 'Instance.new("'` 对全量实例类型做统计，
   **我们根本没创建过任何 ColorCorrection / ImageLabel 覆盖层** ⇒ 那它一定是游戏画的。

**配套（同批落地）**：`F.DmgFx*` 受伤覆盖层抑制（名字关键词 + "面积≥视口60% 且 正在显示 且 偏红" 的几何兜底），
跟随 `GodMode/LockHealth/NoDeath` 自动开关、不新增按钮；`F.DmgFxStop` 已进 `GodModeSet(false)` 与 `UnloadAll` 链。
**抑制别人的 UI 四条硬要求**：① 先记原值；② 只碰"正在显示且符合特征"的；③ 绝不碰自家 GUI（复用 `F.CM_OWNED`）；
④ 把"改了几个/跳过了哪些"打进日志。

⚠ **测试环境坑**：`luau.exe`（本机 `C:/Users/Administrator/.workbuddy/binaries/luau/`）**没有 `io` 库**
（`io.open` 直接 `attempt to index nil`）⇒ 真源码切片做离线测试时**必须把切片内联进测试文件**，不能用 `io.open` 载入。

## ★★★ 掩码器必须识别 `[[ ]]` 长字符串（2026-10-09 实测，一次制造 29 条假报；**当天已修**）
`preflight.py::mask_short` / `_sweep_all.py::strip_all` 只处理 `"` `'` `--` `--[[`，
**漏了 `[[ … ]]` 长字符串**。本仓 `Trans.SYS_BASE = [[ … ]]`（内部含 `"`，2026-10-09 在 **L11498**）⇒ 掩码从那里脱同步，
**其后约 5600 行代码被当成"字符串内"整片抹掉**，于是：
- `preflight [4] 关闭链 nil 洞` 14 条 + `[5] F/AC/Trans 只用未定义` 15 条 ⇒ **逐个 grep 全部有定义 = 100% 假报**
  （如 `F.TranslateDisable@13323`、`F.CMX_DisableAll@13569`）；
- `_sweep_all [5] 关闭链数组 nil 洞` 同样假报 2 条。
- ✅ **2026-10-09 已修**：两个脚本都补了 `--[=*[` 与 `[=*[` 分支；修完 `preflight [4]/[5]` 与 `_sweep_all [5]` **全变 OK**。
  ⚠ `gate.py::_strip` **本来就支持**长括号（用 `LONG_OPEN` 正则 + `_blank`），**不受影响 —— 别再"顺手"改它**。
- 另：`gate [3] 先用后声明` 115 条与掩码无关，是本仓**无缩进**风格导致 `^local` 命中函数体内局部 ⇒ 假报，该判据需配块计数器。

⇒ **两条硬规矩（永久有效）**：
1. 掩码器必须同时去：普通串 / **`[[`/`[==[` 长串** / 行注释 / `--[[` 块注释。四态缺一即会脱同步。
2. 下结论前**先做"视图自检"**：挑一行你确定有内容的行，打印掩码后的样子；**整行空白就是脱同步的信号**。
   （本次就是靠 `L13258` 掩码后全空、而它明明是 `function F.TranslateDisable() ... end` 才定位到的。）

## ★★★ 快照型功能的通用 bug 模式：多份快照记同一属性 ⇒ 关闭时互相"装回去"（2026-10-09）
判据（可机械化）：抓所有 `F.xxx = { Prop = ... }` 快照表 → 按 Prop 分组 → **同一属性被 ≥2 张快照表记录**就是候选。
本仓实测唯一样本是光照三件套（`F.savedLight` / `F.savedNV` / `F.savedFog`）：
开时按 `全亮→夜视→无雾` 依次录"当前值"，关时**同样顺序**执行 ⇒ 全亮先还原原始值，紧接着夜视/无雾把
**开时录到的、已被全亮污染的快照**写回去 ⇒ 关掉后屏幕仍是全亮+无雾（luau 仿真实测 FAIL）。
⇒ **规矩**：凡"多个功能改同一个共享资源（Lighting / 相机 / 角色属性）"，必须**共用一份"原始值"快照**（只录第一次），
关闭时一律写原始值；或者**每个功能只回收自己改过的字段**（夜视不改雾，就不许写 FogEnd）。
⇒ 顺带：`publish.py` 会重写 `F.VERSION`（L217），所以 `gate [7]` 等价性"源码 v16.9.87 vs 产物 v17.0.1"**属设计、不是缺陷**。
