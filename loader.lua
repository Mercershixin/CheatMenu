-- CheatMenu 加载器 · 就是这一小段需要粘贴/保存到执行器里, 主脚本走网络不受长度限制
local URLS = {
	"https://ghfast.top/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
	"https://ghproxy.net/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
	"https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
	"https://gh-proxy.com/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
	"https://ghpxy.hwinzniej.top/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
	"https://cdn.jsdelivr.net/gh/Mercershixin/CheatMenu@main/CheatMenu.lua",
	"https://fastly.jsdelivr.net/gh/Mercershixin/CheatMenu@main/CheatMenu.lua",
	"https://gcore.jsdelivr.net/gh/Mercershixin/CheatMenu@main/CheatMenu.lua",
	"https://raw.githack.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
	"https://raw.gitmirror.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
}
-- ★ 防缓存与源顺序(2026-09-20 云端实测后更正):
--   raw 系(raw.githubusercontent.com 及其透传代理)原生缓存只有约 5 分钟, 推送后稍等即刷新;
--   jsDelivr 对【分支 @main】是文件级长缓存, 实测【加了下面的 ?t= 也穿不动】——
--   同一时刻 version.txt 已是新版、CheatMenu.lua 却还停在旧版(就是"更新不了/还是旧版"的来源)。
--   所以 URLS 的排序是: raw 系在前(新鲜), jsDelivr 三节点压到兜底(命中时可能静默给旧版)。
--   下面这个时间戳参数对 raw 系有穿透效果, 对 jsDelivr 无效但无害, 保留。
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
