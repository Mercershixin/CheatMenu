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

- **聊天翻译用事件，不要用赋值回调**：
  - ✓ `TextChannel.MessageReceived:Connect(...)` / `Player.Chatted:Connect(...)` —— 事件，一定连得上；
  - ✗ `TextChatService.OnIncomingMessage = function() end` —— 赋值回调，实测报"没有标准聊天服务"。
- **原生聊天消息显示后不可修改** ⇒ 想让"第一次看到就是中文"，只能**自建翻译面板**
  （公开脚本 `sim_trans.lua` 就是这么做的：消息先写"[翻译中...]"，翻完更新那一行）。
- **发送兜底三条路**（按顺序试）：`TextChannel:SendAsync` → `Chat:Chat(LP, msg, "All")` →
  `DefaultChatSystemChatEvents.SayMessageRequest`。
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
