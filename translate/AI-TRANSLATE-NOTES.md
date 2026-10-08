# 翻译模块（本地 llama.cpp）— 真实有效的经验

> 本文件是所有"翻译为什么不工作"的排查总纲。**动翻译代码前先读这里**，
> 不要靠猜、不要靠静态审查下结论 —— 下面的每条都是**实测踩出来的**。

## 一、服务事实（2026-10-07 实测）

| 项 | 值 | 说明 |
|---|---|---|
| 地址 | `http://127.0.0.1:8080` | **不是** 8000（8000 无任何服务） |
| 接口 | `POST /v1/chat/completions` | OpenAI 兼容；**没有** `/translate` `/translate/batch` |
| 模型名 | `hymt2-7b` | 实际 gguf 在 `D:\666\models\hymt2-7b\Hy-MT2-7B-Q4_K_M.gguf` |
| Key | `rk_4a56fc43faa5edb9f7a0cafd4ad3e91f` | 请求头 `Authorization: Bearer <key>` |
| 体检 | `GET /health` → `{"status":"ok"}` | 不走模型，用来区分"服务没起"和"翻译不准" |
| 启动 | 双击「翻译模型开关.bat」 | 7B 模型要十几秒~半分钟才加载完；**加载期请求会失败** |

实测有效：`Settings`→`设置`、`BE THE TOP GIGA CUBE CLICKER`→`成为最顶尖的巨型方块点击器`。
批量也有效：一次 6 条 JSON 数组进、同长同序数组出，`%d`/`{n}` 占位符原样保留。

## 二、★★★ 致命 bug 模式（照抄会 100% 失败）

### 1. `pcall(HS.JSONEncode, X)` —— 丢 self，必崩

```lua
-- ✗ 错误：丢 self ⇒ 抛异常 ⇒ 被 pcall 吞掉 ⇒ 表现为"文本含无法编码的字符"
local ok, body = pcall(HS.JSONEncode, data)
-- ✓ 正确：显式冒号调用（Roblox 官方写法）
local ok, body = pcall(function() return HS:JSONEncode(data) end)
```

**实证**：2026-10-07 抓到。当时 `Trans.Chat`/`Trans.RequestBatch` 里 6 处全是错写法，
表现是 **619 次请求 100% 失败、已翻 0 条**、日志刷 `⚠ 本地模型没响应(文本含无法编码的字符)`。
而服务端完全正常（curl 直连秒回译文）。`/health` 能通（不经过 JSONEncode）⇒ 更坐实是编码环节。
**教训**：`JSONEncode`/`JSONDecode` 是 **HttpService 的实例方法**，必须 `HS:JSONEncode(x)`；
传给 `pcall` 时务必用闭包包起来，别把方法当普通函数传。

### 2. `TextVisible` 不是 TextLabel 的属性

```lua
-- ✗ 崩：TextVisible is not a valid member of TextLabel
if obj.TextVisible == false then ... end
-- ✓ 安全探测
local ok, v = pcall(function() return obj.TextVisible end)
```
**实证**：2026-10-06 抓到，`扫描界面时出错` ⇒ 每扫到第一个 TextLabel 就中断 ⇒ 永远"登记 0 个"。
判断可见性只用 `obj.Visible ~= false`（属性不存在时读出来是 nil，不等于 false）。

### 3. 并发计数器泄漏 ⇒ 队列永久冻结

```lua
Trans.Active = Trans.Active + 1
task.spawn(function()
  ... 翻译（中途抛错就终止）...
  Trans.Active = Trans.Active - 1   -- ✗ 抛错时永远执行不到
end)
```
**症状**："待翻 272 条 · 已翻 0 条"，队列冻住一动不动。
**修法**：① 任务整体 `pcall`；② **计数器归还放在 pcall 外面**；③ 加看门狗（卡满 3 轮强制重置）。

### 4. `pcall(Trans.SaveAtomic, body)` 的返回值误判

### 5. **父子两层标签**（2026-10-07 实锤：左下角 HUD 重叠的真因）
- 事故：`HUD.BottomLeft.TotalLuck.TotalLuckLabel` 和它的**子标签** `TotalLuckLabel.Label`
  是游戏的"拆层画法"（一层 `<font transparency="1">140%</font>` 透明占位、另一层显示文字）。
  我把**两层都翻**且结果不一致（"运气值" vs "运气"）⇒ **两层文字叠印 = 界面重叠**。
- 修法（16.9.75）：`GuiEl` 对 TextLabel **整组跳过**——它有 TextLabel 子孙、或它的父级是 TextLabel ⇒ 不翻。
  这类花式拆层 HUD 一碰就坏，保持原样。
- 举一反三：看到"同一个位置两层文字"先怀疑父子标签，别两层都改。

### 6. **模板复用只挂在单条路径**（批量绕过 ⇒ 数值类文本反复打模型）
- 事故：数字模板查 trillion 只在 `Translate(lang=nil)` 里；`Async`→批量路径**完全绕过** ⇒
  "Run back to collect 57 leaves!" 每秒变数字 ⇒ 永远 cache miss ⇒ 反复发模型（用户截图实锤）。
- 修法（16.9.75）：抽 `Trans.Lookup(text)`（缓存 + 模板），**Async 在入队前就查**，命中直接回调。
- ★ 模板必须**类型感知**：槽位分 数字(n)/玩家名(p)，**建模板要求"槽位个数 + 类型序列"两侧一致**。
  否则中文语序调换（"5 coins for Marco"→"给 Marco 的 5 个金币"）会按位置填错 ⇒ 宁可不复用。
  实现：`TplBuild`（单遍扫描，返回 模板/值/类型序列），键 = `"\2"..类型序列.."\3"..模板`。
  回归测试：`D:\666\AI工作区\_tpl_fix_test.py`（从源码提取真实函数，11/11）。

`pcall` 的 `ok` 只表示"没抛异常"，不代表函数返回了 true。
```lua
local ok, r = pcall(Trans.SaveAtomic, body)
local done = ok and (r ~= false)   -- ✓ 必须看返回值
```

## 三、★ Roblox 官方 / 公开脚本的既有经验

- ★★★ **最终口径（用户 2026-10-07 三次确认）**：
  - **界面 / 聊天译文**：一律**游戏内原地替换**。界面改控件 `Text`；
    聊天用 `TextChatService.OnIncomingMessage` / `OnBubbleAdded` 返回
    `Instance.new("TextChatMessageProperties")`（官方"替换显示"机制）。
  - **唯一需要"面板"的**：**"翻译发出"的输入框**（用户原话「需要面板的 是以前版本的**翻译我的话**」）
    ⇒ 一个**只有 TextBox** 的小条：`F.ChatInputBuild` / `F.ChatInputShow`，ScreenGui 名 `CM_ChatInput`，
    打中文 → 回车 → `F.ChatSendTranslated` 翻成目标语言发出。**这不是译文列表**。
  - ⛔ 聊天**译文列表**面板（`Trans.Panel*`）**已彻底删除，不要再加回来**。
  - ⚠⚠ **我在这一轮来回错了两次**（删面板 → 被说"用之前版本的" → 恢复面板 → 又被说
    "你怎么又把翻译面板干出来了"）。**结论以本节为准**；收到"用之前版本"这类话时，
    先确认指的是 **UI 还是机制**、是**译文列表还是输入框**，别再猜。
- **`OnIncomingMessage` 是官方"替换显示"机制**：同步回调（渲染关键路径，不能发 HTTP）
  ⇒ 只能"命中缓存才替换"；未命中先显示原文 + 异步入队，**下一条相同消息**才变中文。
  本项目的聊天**同时**靠界面扫描兜底（聊天 UI 若暴露为控件，会被 `Scan` 直接改写）。
- `TextChannel.MessageReceived` / `Player.Chatted` 可用于**入队翻译**（预热缓存）。
- ⛔ **白名单会挡住聊天**：`Trans.OFFICIAL` 里的 `chat` / `chatwindow` / `robloxgui`
  会让聊天 UI 被跳过 ⇒ `F.IsOfficialUI` 必须**先判"祖先名含 chat ⇒ 放行"**（返回 false），
  Scan 里还要单独把 `RobloxGui` 下名字含 chat 的子节点加进扫描根。
- Roblox 的 `JSONEncode` 遇到无效 UTF-8 字节是**容忍**的（不会报错），所以"编码失败"几乎都是调用方式问题。
- 客户端只能翻**客户端看得到**的文字；服务端算好下发的翻不了。

## 四、扫描范围（16.9.56 起）

根容器 3 个：`PlayerGui` + `gethui()`（执行器/其他脚本界面）+ **`CoreGui` 的非官方部分**。
- ⛔ 不要再写"祖先里有 CoreGui 就整个跳过"—— 游戏常把界面挂在 CoreGui。
- ✅ 用**官方界面白名单**（`RobloxGui`/`PlayerList`/`TopbarApp`/`Chat`… 40+ 个）精确跳过。
- 只翻 **TextLabel / TextBox** 的可见文本（**TextButton 不翻** —— 用户 2026-10-07 要求"UI 按钮不需要翻译"）；**不要**扫 workspace 的 3D 文字
  （BUY/ROLL 之类的 ProximityPrompt、ToolTip、Dialog/Hint/Message —— 用户点名砍掉，且是刷模型的主力）。
- 诊断行会打印：`扫了 N 个容器(...) ⇒ 可见文本 X · 中文 Y · 英文待翻 Z [样本]`。

## 五、缓存（多文件 · 按游戏分 · 本地优先 + 云端兜底）

★ 2026-10-07 重构（用户要求"不同服务器各生成一个中文名文件 / 互相能读 / 但不要串文件"）。

- **文件命名**：`CheatMenu_Cache_<游戏名>.txt`，`<游戏名>` 取
  `MarketplaceService:GetProductInfo(PlaceId).Name`（**保留中文**，只清 Windows 非法字符 `\ / : * ? " < > |`）；
  拿不到名字则退化为 `Place<PlaceId>`。写盘失败会自动退到纯 ASCII 名
  `CheatMenu_Cache_Place<PlaceId>.txt`（`Trans.AsciiFile`）。
- **读 = 多文件**：`Load()` 用 `listfiles(".")` 扫出全部 `CheatMenu_Cache_*.txt` **全部读进内存合并**
  ⇒ 别的游戏翻过的词也能直接命中（"每个都能互相读取"）。另兼容旧单文件
  `CheatMenu_TransCache.txt` / `.json` 做一次性迁移。
- **写 = 只写本服**：`Trans.OWNER[key]` 记录每个键**来自哪个文件**；`Flush()` 只把
  `OWNER == 当前服文件` 的键写进本服文件 ⇒ **绝不把别的游戏的词写进来（不串文件）**。
  当前服没有键且文件不存在时**不创建空文件**。
- **清空分流**：`ClearCurrent`（只删本服文件 + 内存里本服的键）· `ClearAll`（删全部缓存文件）。
- ★ **仓库里所有翻译相关文件统一在 `translate/` 子目录**（2026-10-07 用户要求，避免和根目录其它文件搞混）：
  `translate/README.md` · `translate/AI-TRANSLATE-NOTES.md` · `translate/sync-cache.py` ·
  `translate/cache/<游戏名>.txt`。脚本本体仍是根目录 `CheatMenu.lua`。
- **云端兜底（读）**：`CloudPull` 走 `game.HttpGet` 拉
  `<raw>/translate/cache/<UrlEncoded 游戏名>.txt`（raw → ghfast.top → ghproxy.net 三通道），
  **本地缓存为 0 或本地模型没起来时自动触发**；拉到即写进本服文件。
  ⚠ 同时**保留旧 `cache/` 路径兜底**（`Trans.CLOUD_DIR_OLD`），老缓存文件不会失效。
- **云端上传（写）**：⛔ **不在游戏内做**（要在脚本/工作目录放 GitHub Token ⇒ 密钥暴露给所有执行器脚本）。
  改走**电脑端脚本** `translate/sync-cache.py`（项目内；★ 2026-10-09 更正：原路径 `D:\666\AI工作区\` 整个目录已不存在，该文件已从仓库恢复回项目内）：
  读本机 workspace 的 `CheatMenu_Cache_*.txt` → PUT 到仓库 `translate/cache/`。
  - Token 来源：`项目/.workbuddy/publish.token`（本机，不进仓库）。
  - 该脚本已加入 `push_api.py` 的 FILES（推为 `translate/sync-cache.py`），随发版上仓库做异地备份。
  - ★ 2026-10-07 起**游戏内也能上传/下载**（用户不想去别处点）：Token 放执行器 workspace 根目录
    `CheatMenu_Token.txt`（不进公开脚本）；`TransAutoCloud` 开关默认开，`Flush` 后
    `AutoCloudMaybe` 自动传（180s 节流 + 条数不变不重推）。电脑端 bat 留作备份。
  - 游戏内也留了「上传本服缓存到云端」按钮，但**只有** workspace 根目录存在
    `CheatMenu_Token.txt` 才生效（默认不创建该文件）。
- 数字/名字**模板复用**：`You have 5 coins` 翻过后，`You have 12 coins` 直接套改数字（数字个数必须相等才建模板）。
  （模板键是 `"\2"..tpl`，也带 `OWNER`，随本服文件一起保存。）
- 所有文件 API 都先 `type(readfile)=="function"` 探测 + `pcall`，不支持的执行器只降级为内存缓存。
- **验证方式**：`D:\666\AI工作区\_cache_sim.py`（从源码提取真实函数 + 模拟文件系统）跑 20 项断言，
  覆盖"跨游戏读取 / 只写本服 / 不串文件 / 清空分流 / 旧单文件兼容"。

## 六、排查手册（症状 → 病因）

| 症状 | 先查 |
|---|---|
| 已翻 0 条、日志"文本含无法编码的字符" | **JSONEncode 丢 self**（§2.1） |
| 登记 0 个控件 / "扫描界面时出错" | `TextVisible` 崩溃（§2.2） |
| 待翻 N 条但永远 0 已翻、队列不动 | 并发计数泄漏（§2.3） |
| "本地模型没响应"但 `/health` 正常 | 编码环节坏了，不是服务坏了 |
| 模型 task 号狂涨 | 有每秒变动的文本在反复入队（倒计时/金币数）⇒ 时间格式过滤 + 冷却 |
| 缓存没变大 / "已保存 N 次"是假的 | `Flush` 的 done 误判（§2.4） |

## 七、过滤规则（哪些**不**该翻）

核心判据：**必须含 2 个连续字母（`%a%a`）** 才翻。这一条同时干掉了"纯数值/货币/单位/符号"。
- **富文本标签先剥离再判断**：`<font color="#FF0000">` 这种纯标签串里含字母，若不剥离会被误判成"要翻"。
- 自动跳过：`$1,234` `€5.99` `¥50` `1.5K` `2M` `3.2B` `100%` `+5` `-10` `1/10`、emoji/星号、
  已是中文、玩家名、时间格式 `3:58`、URL/rbxasset、含 `_` 的标识符、`v1` 版本号、超长(>300)。
- ✅ 仍会翻：`100 Coins`（→100 金币）/ `Level 5` / `<b>Hello</b>` / `PASS` / `XP` / `HP`。
- ⛔ **不要**再加大写缩写过滤（`AFK`/`XP`/`HP` 原本被跳，用户明确要求放宽："外文英文一律翻译"）。
- 术语表 `Trans.SYS_ZH` 固定译法（Coins→金币 / Train→训练 / Slot→槽位…），保证同一词永远同一译法。
- 改完必须跑**回归测试**：从源码提取 `ShouldV2` 函数体 → 生成 Lua 用例脚本 → `luau.exe` 跑，
  验证"该跳过的全跳过 + 该翻的全翻"。**别靠手抄，要从源码提取**（避免抄错）。
- **数字 + 短单位**跳过（用户点名 `k` `m` `b` `q` `S` `sp` 这类货币单位）：
  - 数字在前：`^%s*[%d][%d%.,%s]*%a%a?%a?%.?%s*$`（`100k` `5m` `1b` `10q` `50S` `5sp` `100ms` `5min` `10km`）
  - **字母在前**：`^%s*%a%a?%a?%.?%s*[%d][%d%.,%s]*$`（`Lv5` `HP100` `No.5`）
  - 中文货币词（`元` `钱` `金币`）本身就是中文 ⇒ 自动跳过。
  ⚠ 单独的 `HP`/`XP` **仍会翻**（用户要求放宽）。

### ★★★ 中英混合：只翻外文，中文原样保留（2026-10-07）
- **实测证据**：模型对混合文本处理**很糟** —— `Join the game 加入游戏` → `加入游戏`（**英文被吞**）；
  `Hello 你好 World` → `您好 你好 World`（World 漏翻）。⇒ **绝对不能整句丢给模型**。
- 做法：`Trans.Pre` 把**中文片段**转成占位符 `⟦n⟧`（与富文本标签共用同一套 `ctx.tags`），
  只把外文发出去；`Post` 再把 `⟦n⟧` 还原成中文。
  实测 `Hello 你好 World` → 发送 `Hello ⟦1⟧ World` → 还原 `您好 你好 世界` ✅
- ⛔⛔ **Lua pattern 的致命坑**：`([\228-\233][\128-\191][\128-\191])+` **根本不工作**！
  Lua 的 `+` `*` `?` **只能作用于单个字符类，不能作用于捕获组** ⇒ 匹配 **0 次且不报错**（静默失效，
  极易误判成"逻辑没错"）。⇒ 正确做法：**逐字节 while 循环**扫描并合并连续中文块（见 `Trans.Pre`）。
- 判据：`s:find("[\228-\233]")` = 含中文（UTF-8 首字节 E4–E9）；
  **含中文 且 含连续字母（`%a%a`）⇒ 才翻**（纯中文直接跳过）。

### ★ 完整"不翻译"清单（2026-10-07 从真实缓存抓错后整理）
| 类别 | 例子 | 判据 |
|---|---|---|
| 纯中文 | `你好世界` `踢击力` | 含中文 且 无连续字母 |
| 纯数字/符号/emoji | `12345` `50%` `+5` `•` `→` `💰` | 无 2 个连续字母 |
| 货币/单位（数字+短字母）| `100k` `5m` `1b` `10q` `50S` `5sp` `100ms` `5min` | 两条正则（数字在前 / 字母在前）|
| 中文货币词 | `5元` `10钱` `金币` | 中文规则 |
| **技术缩写（整句只剩它们）** | `HUD` `FPS` `FPS/延迟HUD界面` | **KEEPWORD + "去缩写后无连续字母"** |
| **图标/资源名**（全小写连字符）| `three-dots-horizontal` `icon-arrow-left` | `^%a[%a0-9]*%-[%a0-9%-]*$` 且不含大写 |
| 纯富文本标签 | `<font color="#FF0000">` | 剥离标签后无字母 |
| 玩家名 | 当前服玩家名 | `Trans.PN` |
| 时间格式 | `3:58` `1:00:00` | `%d%s*:%s*%d` |
| URL / 资源引用 | `https://…` `rbxassetid://…` | 前缀匹配 |
| 下划线标识符 | `some_thing` | 无空格 且 含 `_` |
| 版本号 / 超长 | `v1.2` / >300 字符 | — |

### 需要翻译
`Settings` · `HELP WIN 40 SERVER EVENTS` · `100 Coins`(→100 金币) · `Level 5` ·
`<b>Hello</b>` · `Hello 你好 World`(→只翻英文) · `HUD Settings`(→`HUD 设置`)

### 三层保护（不翻但原样保留）
1. 富文本标签 → `⟦n⟧`；2. **技术缩写（`Trans.KEEPWORD`）→ `⟦n⟧`**；3. 中文片段 → `⟦n⟧`。
`Post` 统一还原；**若模型没保留占位符 ⇒ 放弃本次翻译**（保留原文，不产出残句）。
另有 `ctx.noText`：保护后已无连续字母 ⇒ 整句不翻（如 `FPS/延迟HUD界面`）。

### 数字+单位 与 玩家名 保护（2026-10-07，16.9.76）
- ★ `Pre` 里把 **`10M / 1.5K / 1.1T / 275S / 5sp / 10min` 这类"数字+字母"token 整体占位**，
  模型碰不到 ⇒ **M 永远是 M**（之前 `+10M Kick` 被翻成 `+1000万踢击加成`）。
  正则：`%f[%d]%d+%.?%d*%a%a?%a?%f[%A]`（要求字母紧跟数字、≤3 个字母、后沿必须断）。
- ★ **同服玩家名也进 `Pre` 占位**（原来只在模板里保护）⇒ 聊天里的玩家 ID 不会被改写。
- ★★ **游戏自汉化控件永不碰**：控件文本**出现过中文** ⇒ `Trans._selfCN[obj]=true`，
  `GuiEl` 与文本监听器都跳过。**起因**：游戏先设英文再本地化（HUD 显示自带"踢球力量"），
  我们抢在本地化之前翻了英文变体并覆盖了它 ⇒ 用户看到"级踢击力量"这种二次翻译。
- ★★ **聊天频道区分**（用户要求：翻本地、不翻世界/全城）：`Trans.IsWorldChat(msg)`
  = 频道名含 world/global/cross/世界/全服/全区 · 消息前缀 `[世界]` 类 · **发话者不在本服 Players 列表（跨服）**
  ⇒ 三种判据任一命中整条跳过。

### ★ 真实抓错案例（2026-10-07，从 `CheatMenu_TransCache.txt` 里发现）
| 原文 | 错译 | 原因 | 修法 |
|---|---|---|---|
| `FPS/延迟HUD界面` | `FPS/延迟界面元素界面` | HUD 被当英文翻 | KEEPWORD 保护 + noText |
| `three-dots-horizontal` | `三个横点` | 图标名被翻 | 资源名规则 |
| `Tab` | `制表键` | 语境错（应"标签页"）| 术语表 `Tab->标签页` |

### 术语表扩充（`SYS_ZH`，2026-10-07）
新增 `Tab->标签页, Menu->菜单, Back->返回, Join->加入, Start->开始, Cancel->取消, Upgrade->升级…`
以及 `Keep these technical abbreviations as-is: CPS HUD FPS GUI UI ESP DPS XP HP MP FOV AFK NPC Ping.`
（SYS_ZH 802 → 1081 字符，每请求多约 100 token；8 并发仍远低于 8192 上下文。）

### ★ 等级 / 附魔 / 词缀 / 玩家名 不翻译（2026-10-07，16.9.84）
- 用户反馈：游戏里的「红名（玩家名）、等级（Level/Lvl/Mastery/Tier）、附魔（Enchanted/Mutation 及词缀标签）」被翻了，不需要翻。
- 实现三件套：
  1. `Trans.NOTRANSLATE` 黑名单（小写键）：`level/lvl/lv/max/mastery/tier` + 全部词缀标签
     （`enchanted/mutation/molten/frozen/electrified/wet/phantom/divine/heavenly/godly/mythic/
     legendary/epic/rare/common/rarity/undead/demon/shadow/astral/eternal/infinity/plasma/
     radioactive/void/cosmic/celestial`）。
     `ShouldV2` 里「把黑名单词替换成空格后，若再无连续字母（`%a%a`）→ 不翻」——
     这样 `Level 12` / `Lvl 75 MAX` / `17500 MASTERY` / `S TIER` 被拦，但 `Level Up Now`（升级）仍翻。
  2. `Trans.TRANSLATE_WORDS` 白名单（小写键）：单个「首字母大写、其余小写」的词，
     若**不在**白名单 → 视为专有名词（玩家名/宠物名）不翻。
     白名单 = 常见按钮/属性/对话词（`collect/close/sell/claim/settings/hello/welcome/…`）。
  3. 删术语表 `SYS_ZH` 里的 `Mutation->词缀`、`Level->等级`；监听器里缓存命中前补 `Should` 检查
     （防旧缓存里的错译如 `Matteo→马特奥` 再生效）。
- ⚠ 主动取舍：白名单没覆盖到的单个大写词会被「少翻」（冷门词），这是为「不把玩家名翻错」主动接受的代价。
- 回归测试从源码提取 `ShouldV2` + 三个表，56 用例全过（`luau.exe` 实跑）。

### ★ 词库扩充 + 游戏自汉化保护（2026-10-07，16.9.85）
- 用户要求：「给词库学习下，哪些不建议翻译/二次翻译/过度翻译/游戏自带中文/服务器已翻译，这些不用翻」。
- **词库扩充**（从云端缓存 `translate/cache/` 808 条里，把「单个首字母大写词」逐一分类，47 个既不在黑白名单的词全部补齐）：
  - 黑名单 `NOTRANSLATE` 补 22 词：词缀/类型标签 `abyssal/alien/golden/diamond/rainbow/virus/legend`
    + 游戏编造专有名词 `ballberto/bangello/burguro/cordraculo/croakumber/dumbelloni/fryuro/
    garamararam/kerbaros/moggatron/orcalero/rockokoko/stadoini/tralaledon/triregnus`。
  - 白名单 `TRANSLATE_WORDS` 补 23 词（该翻的普通词，避免被名字规则误拦）：
    `brainrots/claimed/confirmation/exclusive/odds/perfect/rebirth/regular/sign/toggle/upgrades/
    bacon/candy/carnival/farmer/kicky/woody/rocky/meowl/omega/patagotitan/rexosaurus/soccerdino`。
- **游戏自汉化保护（16.9.85 加 → 16.9.86 回退）**：
  - ⛔ **`_selfCN` 机制已回退**：16.9.85 用 `_writing` 3 秒窗口区分「我们翻的中文」vs「游戏翻的中文」，
    但 `Scan` 周期是 **6 秒** ⇒ 我们自己翻成中文的控件，6 秒后 `_writing` 过期，被误标 `_selfCN`
    ⇒ `GuiEl` 开头 `if _selfCN[obj] then return` 把**全部控件拦死** ⇒ 翻译整体停摆（用户反馈「又不翻译了」）。
    已删 `_selfCN`/`_writing`，恢复「读到中文就跳过」的简单逻辑。
  - ⚠ **教训**：任何「控件文本含中文 ⇒ 标记不碰」的机制，必须能区分「中文是我们写的译文」还是「游戏/服务器写的」，
    否则会把自己翻过的控件全标死。用「时间窗口」不可靠（窗口 vs 扫描周期错配就会误标）。
  - 保留 `Trans.WriteText(obj, prop, val, expect)` 的 `expect` 校验（写回前确认文本没被游戏改过才覆盖），
    这个本身安全、不导致停摆。
- 回归：`ShouldV2` 88 用例全过 + 编译门禁通过。

## 八、备份 / 回滚纪律（本轮的血泪）

- ⛔ **备份必须在"动手前"做**。本轮两次把 `pre-xxx` 备份做成了"改**后**快照"（名不副实），
  回滚时找不到正确基准 ⇒ 只能从 GitHub 取回。
- ✅ **从 GitHub 取回历史版本**（本仓的唯一可靠回滚手段）：
  1. `GET /repos/Mercershixin/CheatMenu/commits?per_page=30` 找 message 含目标**字节数**的那条；
  2. `https://raw.githubusercontent.com/Mercershixin/CheatMenu/<commit_sha>/CheatMenu.lua` 取回；
  3. 首行是 `print('...build...')` banner，**去掉首行即源码**（本仓源码零注释，产物≈源码）。
  ⚠ `git/blobs/<sha>` API 要 **40 位完整 sha**，缩写（12 位）会 422 报错。
- 本仓**不是 git 仓库**（无 `.git`），同步全靠 `push_api.py` 走 API。

## 九、开关语义 & 模板学习（用户 2026-10-07 要求）

### 开关：**开 = 翻译，关 = 还原原文**
- `Trans.Reg[obj]` 记录每个被改过的控件的**原始文本**，按字段存：
  `Trans.Reg[obj] = { Text = 原文, PlaceholderText = 原文, at = 时间 }`（写入用 `Trans.RegField`）。
- 关闭时 `Trans.Disable` 调 `Trans.RestoreAll()`：逐控件对比，与原文不同就写回，再清空 `Trans.Reg`
  ⇒ 日志 `[翻译] 已关 · 已把 N 处文字还原成原文 · 缓存已保存`。
- ⚠ 还原是**字段级**的：TextBox 的 `Text` 与 `PlaceholderText` 分别记录、分别还原。
- ⚠ 副作用：游戏自己改过的文本（倒计时等）也会被还原成旧原文 —— 游戏通常会立刻重写，可接受。

### 模板学习：从"只有数字不同"扩到"数字 + 已知玩家名"
- `Trans.TplKey(s)` → 把 **数字** 与 **玩家名（`Trans.PN` 里的名字）** 统一替换成占位符 `\1`，
  返回"模板串 + 槽位数"；`Trans.TplSlots(s)` 按**同一顺序**收集槽位值。
- 建模板：`n1 == n2` 且 `#tpl >= 6` ⇒ 存 `Trans.Cache["\2" .. tpl] = tplTr`。
- 命中：模板一致 ⇒ 用槽位值按序填回，**不请求模型**。
- 实测：`Ciao stole 5 coins`→`Ciao 偷了 5 金币` 建模板后，
  `Marco stole 12 coins` → **`Marco 偷了 12 金币`**（名字和数字都不同，依然复用 ✅）；
  名字不在玩家表则不命中（安全回退完整翻译）。
- ⚠ 顺序必须**先替换玩家名、再替换数字**（玩家名可能含数字，如 `Ciao123`）。

### 自动保存
- `Trans.SaveTick` 每 **30 秒**检查一次（`task.wait(30)`），`Trans._dirty` 为真且翻译开着就 `Flush` 落盘。
- **关键时机强制保存**：关闭翻译（`Trans.Disable`）、清空缓存前。
- 文件：本服 `CheatMenu_Cache_<游戏名>.txt`（见 §五；读取时是**全部** `CheatMenu_Cache_*.txt`）。
- ✅ **完全相同的文本 = 缓存直接命中**，不重问模型；`Trans.KEEP` 里的词整句跳过。

## 十、并发调度与稳定性（2026-10-07）

### 服务事实
→ 见本文件「★ 硬件与"性能天花板"」小节（当前档 `-c 12288 -np 12`，脚本 `Trans.MAX = 12`）。
- ⚠ 实测中服务**崩过一次**（llama-server 进程消失、显存回落 444MB）⇒ 之后所有请求失败、队列堆积。
  ⇒ **排查任何翻译问题前，先 `curl http://127.0.0.1:8080/health` 确认服务活着。**
- 单条短词延迟实测 **0.05~0.19s**（`--cache-reuse` 命中 system prompt 前缀缓存）。
  **瓶颈从来不是模型速度，而是并发雪崩 + 服务崩溃。**

### ★★★ 看门狗雪崩（务必别重犯）
- 旧写法：`if Active >= MAX and 队列非空 then Active = 0; Drain() end`。
- **后果**：清零时**老任务还在跑**，Drain 又启动一批 ⇒ 实际并发翻倍 ⇒ 服务过载变慢 ⇒
  更快触发看门狗 ⇒ **恶性循环**（日志里 `⚠ 队列卡住` 反复刷就是这个）。
- **正确写法**：先看"**最近是否有任务完成**"，只有 **25 秒无任何进展**才重置：
  `local idle = os.clock() - (Trans._lastDone or os.clock())`，`idle > 25` 才重置；
  并在任务完成处记 `Trans._lastDone = os.clock()`。

### 失败冷却（防队列被灌满）
- `Trans.MarkFail(text)`：失败的文本 **25 秒内不再入队**（`Trans._fail[text] = os.clock() + 25`），
  `Trans.Async` 开头检查。⇒ 服务挂掉时不会反复重试把队列灌爆。

### 可见优先（用户要求"优先翻打开的界面"）
- `Scan` 分两轮：**可见控件先 `GuiEl`（先入队）**，隐藏的收进 `hidden` 表之后再处理。
- 队列是 FIFO，可见的自然先被翻译。

### ★ 硬件与"性能天花板"（2026-10-07 实测/调研）
- **GPU RTX 3070 8GB**（Ampere, compute 8.6）· **CPU Ryzen 7 5700X 8C16T** · **RAM 32GB** · llama.cpp `b10927`。
- ★★ **模型已经是最优，不要换**：现用 `hymt2-7b` = **腾讯 Hunyuan-MT-7B**，
  **WMT2025 31 个语向拿下 30 项第一**，XCOMET **0.8585** > Gemini-2.5-Pro(0.8250) > Claude-Sonnet-4(0.8120)，
  胜过 Tower-Plus-9B / Seed-X-PPO-7B，比谷歌翻译高 15~65%。**开源翻译模型的 SOTA。**
  - 可选升级：`Hunyuan-MT-Chimera-7B`（弱到强融合，FLORES-200 +2.3%），但推理时生成多候选 ⇒ **更慢**，未采用。
  - ⛔ **FP8 版不要用**：官方推荐 FP8 提速 30%，但 **RTX 3070(Ampere) 无原生 FP8**（需 Ada/Hopper）。
- ★★ **显存基准（bat 注释里的原作者实测）**：`-c 8192 -np 8 -b 4096 -ub 1024 -ngl 99`
  ⇒ **实占 6156MiB**（模型 4.6G + KV ~1.5G），**留 2036MiB 给 Roblox**；
  8 并发 **0.374 秒/条 · 187 tok/s**。
- ★ **2026-10-07 极限档**（当前值）：`-c 12288 -np 12 --cache-type-k q4_0 --cache-type-v q4_0
  --threads-http 8`，脚本 `Trans.MAX = 12`。
  原理：**V cache 从 q8_0 降到 q4_0**（省一半 V 显存）→ 省下的额度换成
  **上下文 +50%（8192→12288）** 和 **并发 +50%（8→12）**，显存基本持平（≈6.1GB）。
  ⚠ 换档后**必须重启服务**；首次启动用 `nvidia-smi` 复核实际占用。
- **未启用的可用参数**：`--kv-unified`（统一/池化 KV 缓存，可能再省显存）；
  `-t/-tb` 官方建议 GPU 模式下 4~8（线程过多反而变慢，**不要盲目调大**）。

