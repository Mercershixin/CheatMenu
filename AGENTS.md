# AGENTS.md —— ⛔ 任何 AI / 智能体在本仓库动手前【必须】先读这份

> **这是强制规范（用户 2026-09-19 定稿）。**
> 不管你是什么模型、哪个账号、用哪个智能体框架：**改这个仓库的任何文件之前，先读完这一份。**
> 会自动加载本文件的工具（Codex / Cursor / Claude Code / Copilot / Windsurf / Cline / 各类 CLI Agent）直接就看到了；
> 没自动加载的，先 `cat AGENTS.md`。
>
> 同一份内容也放在这些位置（都指向这里）：
> `CLAUDE.md` · `.github/copilot-instructions.md` · `.cursor/rules/cheatmenu.mdc` ·
> 以及源码 `CheatMenu-*.lua` 的**文件头注释**。

---

## 0. 一句话版本

**只做用户明确要求的那一件事**；改完 → 钉版本号 → `push_now.py --fast` → 结束。
（动了 `README.md` 或 `事件库/` 才额外跑 `push_docs.py`。）

---

## 1. ⛔ 绝对不要做（用户已多次强调，踩过就被训）

1. **不要自作主张跑「仿真 / 模拟检测循环 / 多轮深度验证」。**
   `verify_all.py`、`local_sync.py --full`、`sim/run_full.py`、`sim/run_smoke.py`、
   `check.py`、`check_globals.py`、`luau-compile`、`luau-analyze` —— 这些**全都算"测试循环"**，
   **只在用户明确说「跑一下 / 验证一下 / 测试一下 / 发版」时才跑**。
   > 用户原话：**"我让你做你才做，没让你做我不做。"**

2. **UI 上标「不推荐 / 会被拉回 / 有风险」是给用户看的提示，不是让你改行为。**
   用户要的是「**标出来，我自己决定用不用**」——**不要**因此删选项、改默认值、加限制。

3. **不擅自新增功能、不动用户没让你动的地方。** 只做用户明确要求的那一件事。

4. **不要为了"验证我没改坏"去跑门禁。** 改完直接交付，或问用户要不要验。

5. 同一条请求**换个说法再问，答案要一致** —— 不因提问角度变化而放宽或收紧。

---

## 2. 🎨 透视 / 高亮配色规范（用户口径，别再自己加颜色）

| 对象 | 颜色 |
|---|---|
| **所有高亮** | **边框高亮**：填充近乎透明（0.88 / 隔墙 0.93），只留描边轮廓 |
| **普通物件 + 普通门** | **统一亮青** `(0,200,255)`，描边 `(0,170,230)` |
| **危险**（陷阱 / 伤害机关 / 切割 / **假门**） | **红色** `(255,30,30)`，描边 `(255,0,0)` **+ ☠ 骷髅头** |
| 人物 | 队友 **绿** / 敌人 **红** / 幽灵态 **紫** |
| 怪物 · NPC | **橙** |

- 「普通物件」= 可交互的**全部分类**：箱子·收纳 / 拾取物 / 道具·补给 / 躲藏点 / 书籍·纸张·线索 /
  梯子 / 按钮·机关 / 传送 / 座位 / 商店 / 检查点 —— 外加「文字线索」（部件挂 `SurfaceGui` 且有字）、
  掉落物透视、小游戏区域。**分类名只当命中判据与自诊断标签，不再各自配色。**
- ☠ 只给**危险**挂，普通门不挂。
- **三个透视（掉落物 / 可交互 / 门·陷阱·假门）已合并成一个开关**「🔍 物件透视」——别再拆开。

---

## 3. 🗂 目录与文件（别搞混）

- **本地工作区 `Hy-MT2翻译模型/`**（唯一手改入口）：
  - `CheatMenu-6.9.1.lua` = **源码**（带注释，手改只改这里）
  - `.workbuddy/build/*.py` = 构建 / 推送 / 同步脚本
  - `.workbuddy/memory/` = 项目记忆与每日日志（**不进仓库**）
  - `事件库/` = 抓包清单（**要进仓库**）
- **仓库 = 发行产物**：`CheatMenu.lua`（minify）/ `version.txt` / `loader.lua` / `CHANGELOG.md` 四件套，
  外加 `README.md`、`AGENTS.md`、`事件库/`。
- **推送不是 `git push`** —— 走 GitHub Contents API（`push_now.py` / `push_api.py`；文档走 `push_docs.py`）。
  所以本地 git 落后远程属**常态**，别用 git log 判断"有没有推上去"。
- 事件库：抓包清单按 `事件库/YYYY-MM-DD_游戏名.md` 归档，**游戏名一定要写**。

---

## 4. 🚀 发版流程（固定，别自己发挥）

```
1. 改源码                    CheatMenu-6.9.1.lua
2. 顶层写 CHANGELOG 条目      dist/repo/CHANGELOG.md   ← 版本号要和 version.txt 对齐
3. python .workbuddy/build/push_now.py --fast --patch
      · 修 bug 加 --patch；新功能不加（不加就是"次+1"）
      · 退出码 1 ≠ 失败；看日志里有没有 "!! API 推送失败"
4. 若第 3 步 API 失败 → python .workbuddy/build/push_api.py   （兜底通道）
5. python .workbuddy/build/local_sync.py --no-sim-target      （同步执行器本地版）
6. 回读核对： version.txt == CHANGELOG.md 顶部
7. 动了 README.md / 事件库/ → 再跑 python .workbuddy/build/push_docs.py
```

---

## 5. 🧭 能力边界（别写"做不到"的承诺，也别瞎吹）

- **服务端权威**的东西（余额 / 物品数量 / 购买 / 复活 / 藏身状态 / 怪的判定 / 踢人）客户端改不动 ——
  只能做「本地提示」或「发请求」，能不能成看服务端。
- **高亮 / 透视 / 本地画面效果**是纯客户端视觉，安全，随便做。
- **别碰反作弊蜜罐 remote**（例：DOORS 的 `DroneStickyNoteMyNameIsExploiterAndIThinkICanCheatWithThis`）、
  管理通道（`AdminPanelRunCommand` / `SendErrorLog` / `ServerLog`）、第三方权限框架（`conch_networking.*`）、
  数据复制框架的**写**通道（`Replica_*`）。
- 判据优先级永远是：**真名 > 结构 > 形状猜**。名字对不上就找用户要真名，别瞎猜。

---

## 6. 📌 当前项目状态速查

- 仓库：`Mercershixin/CheatMenu`（分支 `main`）· 版本见 `version.txt`
- 主攻游戏随用户变（今天可能是 **MachineParty（机器派对）** 或 **DOORS（门）**）
- 事件库清单在 `事件库/`（每个游戏一份，含权威 Attribute / Remote 分类 / 可做功能映射）
- 详细历史看 `CHANGELOG.md`（很长，搜关键词就行）
