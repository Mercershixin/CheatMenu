-- CheatMenu 加载器 · 就是这一小段需要粘贴/保存到执行器里, 主脚本走网络不受长度限制
local URLS = {
	"https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
	"https://gh-proxy.com/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
}
-- ★ 源顺序(2026-10-09 实测后精简为两条):
--   1) 官方 raw.githubusercontent.com —— 本机实测最快(601530 字节 0.50s), 且权威、不会喂旧版;
--   2) gh-proxy.com —— 最快的非官方代理(0.97s), 官方被墙/超时才轮到它。
--   ⛔ jsDelivr 三节点已删: 对【分支 @main】是文件级长缓存, 实测返回的是【旧版本脚本】
--      (同一时刻 version.txt 已是新版、CheatMenu.lua 却还是旧版 ⇒ 就是"更新不了/还是旧版"的来源),
--      下面这个 ?t= 时间戳对它【实测无效】。
--   ⛔ ghfast.top / ghproxy.net / ghpxy / raw.githack / raw.gitmirror 一并删掉(慢或已死)。
local TS = "?t=" .. tostring(os.time())
local function fetch()
	local last = "?"
	for i, u in ipairs(URLS) do
		local ok, body = pcall(game.HttpGet, game, u .. TS)
		if ok and type(body) == "string" and #body > 5000 then
			if body:sub(1, 9) ~= "<!DOCTYPE" and not body:find("404: Not Found", 1, true) then
				return body, u
			end
			last = "返回的不是脚本(可能是 404 页面)"
		else
			last = tostring(body)
		end
		warn(("[CheatMenu] 源 %d 不可用: %s"):format(i, tostring(last):sub(1, 120)))
	end
	return nil, last
end

local src, used = fetch()
if not src then
	error("[CheatMenu] 所有下载源都失败, 最后错误: " .. tostring(used), 0)
end
print(("[CheatMenu] 下载完成 %d 字节 <- %s"):format(#src, used))

local chunk, perr = (loadstring or load)(src, "@CheatMenu_remote")
if not chunk then
	error("[CheatMenu] 远端脚本编译失败: " .. tostring(perr), 0)
end
return chunk()
