# 发布与分发（细节）

## ★★★ 铁律：每次更新必走完整发行链（用户 2026-10-06 22:24 点名，2026-10-06 曾因此翻车）

用户原话：「你没规矩我的需求吗 就是**每次更新都进行版本号更新 然后推送，本地更新和git云端更新**」。

- **任何功能更新（不管谁做的、在哪做的），完成定义 = ① 版本号递增（`build/VERSION` + `F.VERSION` + 文件名）
  ② 本地源码同步（根目录 `CheatMenu-<版本>.lua`）③ git 云端推送（`push_api.py`）**。三步缺一不可。
- ⛔ **绝不允许绕过本地构建链直接推远端**：2026-10-06 22:10 曾有一份"外部会话"直接把带注释源码推到远端，
  导致：版本号没 bump、本地落后远端 1 版（下次本地构建会把远端新功能**覆盖回退**）、产物带 72 行注释。
  ⇒ 发现"本地没有、远端有"的新代码时，必须按规范补办：拉回 → 剥注释 → bump 版本号 → 本地同步 → 重推。
- 版本号递增惯例：本项目实际一直是 **patch 位 +1**（16.9.18→…→16.9.31→16.9.32），
  发版统一走 `--patch`（不是 version.py 默认的 minor+1）。

## 仓库与产物

- 仓库 `Mercershixin/CheatMenu`（分支 main）。本地完整源码 `CheatMenu-<版本>.lua`，
  **文件名跟版本走**，定位走 `.workbuddy/build/srcpath.py`（唯一真源，别硬编码）。
- 当前：源码 **`CheatMenu-11.0.0.lua`**（**已无任何注释**）；产物 **223,769 B** /
  sha1 `40b690c0796d`；**顶层真局部 92**（硬上限 200）。★ 版本号已抽成源码里的 `F.VERSION` 常量
  （发版脚本按字面量替换 ⇒ 现在"版本字面量替换"只剩 **1 处**）。
- ★ **进版规则**（`_manual_release.py`）：`--patch` 末位 +1；不加参数 = 中位 +1，且**中位 >10 就进位到整版**
  （2026-10-01 实测：10.10.9 → **11.0.0**）。⇒ 升整版前只需确认**全文没有写死的 `v10`**：
  HotReload 自检用的是 `v%d+%.`（当年 FIX-1 修过）⇒ v11 不会让"热加载"被拒。
- ★ `push_api.py` 推送前有 `sanity()`：**空 / 全 NUL / 含 NUL 一律拒推**（防把损坏产物发给用户）。
- ⚠ `push_api.py` 推 240KB 级 body 时偶发 **HTTP 400 malformed**（重试即成功）；
  它在 `dist/repo/` 里比对，**门禁的 equivalence 项看的是旧路径产物 ⇒ 常报失败，属假警报**；
  真正的等价性以 `build_dist.py` 自己那句"等价性: 通过(空白归一化后逐字符一致)"为准。
- 推送**固定 4 文件**：`CheatMenu.lua` / `version.txt` / `loader.lua` / **`AI-MAINTAINER-NOTES.md`**
  （最后一份是"给 AI 看的维护文档"，2026-10-01 起随发版一起推）。
  ⚠ 更正：以前记的"`事件库/` + `push_docs.py`"**已不存在**（本地与远端都没有那个目录/脚本）。
- ⛔ **仓库路径含非 ASCII 会推不上去**（`'ascii' codec can't encode`，2026-10-01 实测）
  ⇒ 文档用 ASCII 文件名（`AI-MAINTAINER-NOTES.md`）；`push_api.py` 已加 `enc_path()` 逐段 URL 编码。

## 链路与命令

- ★★★ **"删掉 XX"这类要求的完成定义 = 已发版 + 已推送**（2026-10-01 挨骂换来的）：
  本地改完、复验 0 残留**都不算完成** —— 用户游戏里跑的是**已发布的那一版**，他会直接说"你没删/你耳朵聋吗"。
  ⇒ **删完立刻 bump + push**，再谈别的。

```
build_dist.py          源码 → dist/repo 产物
gate.py                8 项门禁（编译 / 顶层局部 / 先用后声明 / 未定义成员 / 消毒残留 /
                       文本自检(end 配平+UTF-8) / 与产物逐字符一致 / 未定义全局白名单）
_manual_release.py --push [--patch]   发版（含 API 回读校验）
jsDelivr purge         刷缓存
verify_cloud.py        多源逐字节验证
```
**门禁不过不许发**。发布脚本会给源码留 `pre-*` 备份到 `.workbuddy/build/backup/`。

- ★★★ **热加载必须"先下载后卸载"**（2026-10-01 修）：旧实现 `UnloadAll()` 在前 ⇒ **下载失败实例就没了**。
  正确顺序：**问各源 version.txt 取最高版 → 已是最新就直接返回(不下载不卸载) → 下载(优先最新源,
  并要求内容版本 ≥ 远端最高版, 避免 CDN 旧缓存) → 自检 + 编译通过 → 才 UnloadAll → 执行新实例**；
  任何一步失败都**保持现有实例不动**。入口两个：`热加载(智能)` / `强制重载`。
- ★★ **仓库只保留最新**：`Mercershixin/CheatMenu` 固定 **4 个文件**
  （`CheatMenu.lua` / `version.txt` / `loader.lua` / `AI-MAINTAINER-NOTES.md`）—— **历史不进仓库**。
  **历代版本归档在** `D:\666\AI工作区\备份\CheatMenu历代版本\`（`源码\` + `发行产物\` + `说明.txt`）。

## ★★★ 用户 2026-10-04 明确要求：**推送后不要回读核对**

原话：「**不用核对发送的 只要推送成功就 有问题或者失败 我才会让你核对 不然太慢了**」。

- ⇒ **默认流程 = 构建 → `--push` → 结束**。**不要另发 API 查询、也不要发 raw 查询**去核对版本号
  （2026-10-04 16:50 用户第二次点名：「**你为什么还要在确认发布推送状态**」——连一次快速 raw 查询都算违规）。
- ⇒ **只有**这两种情况才去核对：① `push_api.py` 报失败/重试耗尽/`回读失败`；
  ② 用户说"没更新/还是旧的"。**由失败或用户报告触发，而不是每轮例行**。
- ⚠ 保留的能力不变（`.workbuddy/publish.token` + `api.github.com` 的 blob sha 对比），只是**不再例行做**。

## ★★★ 镜像清单**只留两条**（2026-10-09 用户要求"一个最快最稳 + 一个官方"，实测后定稿）

用户原话：「镜像能不能去掉 不需要那么多 只需要一个最稳定最快的就行了和一个官方的」。
**本机实测**（同一份 CheatMenu.lua 600KB，sha1 比对；同一台机器就是用户跑执行器的机器）：

| 源 | 拉 600KB | 速度 | 内容 |
|---|---|---|---|
| **官方 raw.githubusercontent.com** | 0.50s | 1180 KB/s | ✓ 逐字节一致 ← **选了** |
| **gh-proxy.com**（代理） | 0.97s | 607 KB/s | ✓ 逐字节一致 ← **选了** |
| ghpxy.hwinzniej.top | 1.51s | 390 KB/s | ✓ |
| ghfast.top | 2.17s | 271 KB/s | ✓ |
| ghproxy.net | version.txt 延迟 **10.1s** | 极慢 | ✓ |
| fastly.jsdelivr | 0.45s 但 **540KB / sha 不同** | — | ✗ **静默喂旧版** |
| cdn.jsdelivr | 返回 **16.10.75** | — | ✗ 旧 |
| raw.githack / raw.gitmirror | **连不上** | — | ✗ |

⇒ 定稿：**官方 raw 在前**（本机最快 + 权威 + 不会喂旧版），**gh-proxy.com 在后**（raw 被墙时才轮到）。
⛔ **永远不要把 jsDelivr 加回来**（`@main` 文件级长缓存，`?t=` 实测无效）。

**Fluent UI 库的源**（`FLUENT_SOURCES`）只剩 2 条代理：`gh-proxy.com`(0.95s) + `ghfast.top`(2.36s)。
★ 实测 `github.com/...releases/latest/download/main.lua` **连不上**（ConnectionReset，但 `api.github.com` 能取到该 release）、
`raw.githubusercontent.com/dawid-scripts/Fluent/main/main.lua` 与 jsdelivr 的路径**都是 404**
⇒ **Fluent 没有可用的"官方直连"**，只能靠代理 + 本地缓存文件（`CheatMenu_Fluent.lua` 等）兜底。

落地位置（三处必须同步，改一处会偏心）：`publish.py::raw_urls()`（生成 loader + 打印的源清单）、
源码 `F.REMOTE_URLS`（脚本内自更新用）、源码 `FLUENT_SOURCES`；`verify_cloud.py::SOURCES` 也已同步。
产物核对：`loader.lua` 从 2539 → **1909 字节**（URL 从 10 条降到 2 条）。

## CDN 与"到底发出去了没有"

- **推送不是 git push**（走 GitHub Contents API）⇒ 本地 git 常落后远程，属常态。
- **jsDelivr 对 `@main` 是文件级长缓存，会静默发旧文件**（`?t=` 时间戳无效）；
  **各边缘上线时机互不相同**（同一刻 cdn 可能已追平、fastly/gcore 还是旧版）。
- ⇒ **判断发出去了没有**：以 **raw 系（ghfast/ghproxy/gh-proxy/ghpxy 透传）+ cdn + GitHub API** 为准。
- ★★ **purge.jsdelivr 会被限流**：连续刷多次后返回 `status:"finished"` 但 **`throttled: true`**，
  此时**刷新不生效**（2026-10-01 实测：cdn 一直停在上一版，raw 系 4/4 已是新版）。
  ⇒ 判据不变：**raw 系里有 IDENTICAL 就说明云端确实是新版**，cdn 边缘等限流解除或自然过期。
  **别因为 cdn 没跟上就重复 purge**（越刷越被限流）。
- ★★★ **`dist/repo/` 里的产物可能是过期的**，别拿它跟云端逐字节比 —— 会得到
  "**大小一样、字节不同**"的**假警报**（2026-10-01 实测，差点误判"没推上去"）。
  **权威裁定只有两个**：① `api.github.com/repos/<r>/contents/<f>?ref=main` 的 **git blob sha1**；
  ② 与"**从源码重新构建**"的产物比（重跑 `build_dist.py`）。两者一致才算数。
  `verify_cloud.py` 已改为**比对前先重建**。
- 连通性：`api.github.com` 直连可用；`github.com` 的 git 直连被重置 ⇒ git 操作走镜像
  `https://ghfast.top/https://github.com/...`。

## 废弃代码归档库（2026-10-04 起）

- 仓库 **`Mercershixin/CheatMenu-Deprecated`（private）**：专门放"从主脚本移除"的孤儿函数/死标志/废弃实现，**只留档、不参与构建发布**。
- ★ 规则：**移除代码先归档到它，再从主脚本删** —— 主脚本保持干净，能力不丢（要复活就从对应日期段落整段取回）。
- ★ 建仓库的坑：GitHub **MCP 连接器只有 contents 权限**（`POST /user/repos` 会 403 `Resource not accessible by integration`）⇒ 改用 `.workbuddy/publish.token` 直接调 API 成功。
- ⛔ 主仓库 `Mercershixin/CheatMenu` **仍然固定 4 个发布文件**（历史不进主仓库）—— 归档库是独立的第二个仓库，不违反这条。

## 废弃归档库已实战验证（2026-10-04）

- ★ 用户当天先要求删「自助诊断」、后又要求恢复 ⇒ **从 `CheatMenu-Deprecated` 整段取回 `F.GameCheck`（27 行）即完成恢复**。
  ⇒ 这就是"**移除前先归档**"规则的价值：**删除 = 移走，不是销毁**。用户改主意时代价接近零。

## ★★★ 发版两条铁律（2026-10-07 亲踩，16.10.44）

1. **源文件必须放在 `build/VERSION` 指向的那个名字上，不能新建文件**。
   `srcpath.src()` 优先级 = `CheatMenu-<build/VERSION>.lua` > 唯一候选 > 报错（**不取最新/最大**）。
   ⇒ 新建 `CheatMenu-16.10.44.lua` 后跑 push，它**照旧读了 `16.10.43.lua`，把旧内容推了上去**
   （输出"源码 528319 字节"对不上 531022 就是征兆）。
   ✅ 正确姿势：**把新内容 `cp` 覆盖到 `build/VERSION` 那个文件**，再跑 push；push 末尾会自动调
   `sync_src_name.py` 改名（幂等，失败不阻断推送）。
2. **修 bug 必须带 `--patch`**：`python .workbuddy/build/push_now.py --patch`（等价 `CM_VER_KIND=patch`）。
   不带时按**功能版**升号（次+1），16.10.43 → 次 11 → 命中"**次>10 进主**" ⇒ 直接跳 **17.0.0**。
   回退：文件改回旧名 + `build/VERSION` 写回旧号 + `build/VERSION.sha` 写个不匹配值（强制升号），再 `--patch` 重跑。
## ★★★ `--no-build` 只推"已构建好的产物"——改过源码后用它 = 推旧版（2026-10-09 v17.0.1 实锤）

**事故**：修好连点器联动后我用 `push_now.py --no-build` 推送 ⇒ 它直接推 `dist/repo/CheatMenu.lua`
这个**上一次构建的产物**（606919 字节，改之前），而且**版本号没变**（仍 17.0.0）
⇒ 游戏端热更新比对「远端 = 当前 = 17.0.0 ⇒ 无需重载」⇒ **用户完全收不到这次修复**（用户会以为"没修"）。

**规矩**：
- ✅ **改了源码 ⇒ 必须 `push_now.py --patch`**（重新构建：压缩 / 等价性 / 编译门禁 / 进位版本号）。
  版本号必须变，游戏端才认得出"有更新"。
- ✅ `--no-build` 只用于**只改了文档/只补同步**（例如只更新 `AI-MAINTAINER-NOTES.md`、
  `MEMORY-*` 之类不参与源码产物的文件）。
- ✅ 自查方式：推送后看 `dist/repo/CheatMenu.lua` 的**字节数/时间戳**是否与本次源码一致；
  `--no-build` 下如果字节数与上次相同，就说明**没重建**。
- ⚠ raw 回读会因 CDN 缓存短暂显示旧长度，属正常；**不要把它当成"推送失败"**。

## ★★★ 「补丁写进源码」≠「已交付」（2026-10-09 v17.0.40 实锤）
18:29 已把「取点模式」写进 `CheatMenu-17.0.39.lua`，但（大概率被本机 worker 启动超时打断）**没构建、没推送、没写记忆**。
用户之后 4 次会话跑的都是 18:16 的旧产物 ⇒ **修复从未到达用户手里**，他报"还是有 bug"，我却以为早就修好了。
**30 秒判定法（怀疑"我改了但没生效"时先做这个）**：
```bash
md5sum "$LOCALAPPDATA/Real/workspace/CheatMenu_main.lua" dist/repo/CheatMenu.lua   # 一致 ⇒ 用户跑的就是最后一次构建
ls -t .workbuddy/build/_pushlog*.txt | head -1                                      # 最后推送时间 vs 源码 mtime
```
⇒ 规矩：**改过源码的那一轮，必须以"pushlog 更新 + raw 校验通过"收尾**；被打断后重开会话，先做上面的比对再谈新需求。
⇒ 记忆里也不许写"已修好"——**只写"已交付/未交付"**（未交付的写清可能原因，便于下次接着做）。
★ 另一个口径：`_pushlog*.txt` 是**唯一的交付凭证**，`AI-MAINTAINER-NOTES.md` / 记忆只是说明。
