# translate/ —— 翻译相关文件专用目录

> 2026-10-07 起，**所有翻译有关的文件都放这里**，不再散落在仓库根目录，
> 避免和主脚本 / 主文档混在一起。脚本本体仍是根目录的 `CheatMenu.lua`。

## 目录结构

```
translate/
├── README.md                  ← 本文件
├── AI-TRANSLATE-NOTES.md      ← 翻译模块的维护手册（服务事实 / 致命 bug 模式 / 症状→病因排查表）
├── sync-cache.py              ← 电脑端「把翻译缓存上传到云端」脚本（见下）
└── cache/                     ← 云端翻译缓存，一个游戏一个文件
    └── CheatMenu_Cache_<游戏名>.txt
```

## 云端缓存怎么工作

游戏内（`CheatMenu.lua` 的翻译模块）：

1. **本地优先**：开翻译时先读执行器 workspace 里**全部** `CheatMenu_Cache_*.txt`，
   合并进内存 ⇒ 跨游戏也能互相命中（别人翻过的词直接复用）。
2. **云端兜底**：本地缓存为 0 条、**或本地模型没起来**时，自动 `game.HttpGet` 拉
   `translate/cache/<游戏名>.txt`（raw → ghfast.top → ghproxy.net 三通道），
   拉到就写进本服文件 ⇒ **不连模型也能直接出中文**。
3. **写只写本服**：每个词记「归属文件」，保存时只写当前游戏那个文件 ⇒ **绝不串文件**。

## 上传缓存（在电脑上做，不要在游戏里做）

> ⛔ 游戏内上传必须把 GitHub Token 放进执行器环境 ⇒ 能写仓库的密钥会暴露给所有脚本。
> 缓存文件本来就落在电脑的真实目录里，用电脑端同步最安全。

双击 `同步翻译缓存到云端.bat`（与 `sync-cache.py` 同一目录），它会：

1. 找到执行器 workspace 目录（默认 `%LOCALAPPDATA%\Real\workspace`，可手动传路径）；
2. 扫出全部 `CheatMenu_Cache_*.txt`；
3. 逐个 PUT 到本仓库 `translate/cache/`（中文名走 UTF-8 百分号编码）。

Token 只从本机项目目录 `.workbuddy/publish.token` 读取，**永远不进仓库**。

## 文件名规则

- 文件：`CheatMenu_Cache_<游戏名>.txt`，游戏名取 `MarketplaceService:GetProductInfo(PlaceId).Name`，
  **保留中文**，只清 Windows 非法字符 `\ / : * ? " < > |`；拿不到名字则回退 `Place<PlaceId>`。
- 云端路径同名，URL 编码后形如
  `translate/cache/CheatMenu_Cache_%E8%BF%90%E6%B0%94%E6%96%B9%E5%9D%97.txt`。
