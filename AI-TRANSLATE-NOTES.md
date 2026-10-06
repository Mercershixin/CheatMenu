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
- 只翻 **TextLabel / TextButton / TextBox** 的可见文本；**不要**扫 workspace 的 3D 文字
  （BUY/ROLL 之类的 ProximityPrompt、ToolTip、Dialog/Hint/Message —— 用户点名砍掉，且是刷模型的主力）。
- 诊断行会打印：`扫了 N 个容器(...) ⇒ 可见文本 X · 中文 Y · 英文待翻 Z [样本]`。

## 五、缓存（保存到本地 + 加载复用）

- 文件 3 个，都在执行器 workspace：`CheatMenu_TransCache.json` / `.bak` / `.tmp`。
- 写：**原子写**（先备份旧文件 → 写 .tmp → renamefile）→ 失败退化直接写；`Flush` 每 10s 节流一次。
- 读：`Trans.Load()` 开翻译时自动读主文件，坏则读 `.bak`，实现"下次开启直接复用、不重翻"。
- 数字模板复用：`You have 5 coins` 翻过后，`You have 12 coins` 直接套改数字（数字个数必须相等才建模板）。
- 所有文件 API 都先 `type(readfile)=="function"` 探测 + `pcall`，不支持的执行器只降级为内存缓存。

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

