# translate/ —— 翻译相关文件专用目录

> 脚本本体仍是根目录的 `CheatMenu.lua`。

## 目录结构

```
translate/
├── README.md                  ← 本文件
└── AI-TRANSLATE-NOTES.md      ← 翻译模块维护手册（服务事实 / 致命 bug 模式 / 症状→病因排查表）
```

## 缓存（纯本地 · 不走网络）

翻译缓存在**执行器 workspace 本地**，一个游戏一个文件：`CheatMenu_Cache_<PlaceId>.txt`。

1. 开翻译时先读 workspace 里**全部** `CheatMenu_Cache_*.txt`，合并进内存
   ⇒ 跨游戏互相命中（别的游戏翻过的词直接复用）。
2. 本服新翻的句子只写回**本服那个文件**，不污染别人的。
3. 数字模板单独存 `CheatMenu_NumTpl.txt`（全局单文件，天然跨服）。

**没有云端、不上传、不下载、不需要 Token。**
