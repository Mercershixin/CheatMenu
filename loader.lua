-- CheatMenu 加载器 · 就是这一小段需要粘贴/保存到执行器里, 主脚本走网络不受长度限制
local URLS = {
	"https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
	"https://cdn.jsdelivr.net/gh/Mercershixin/CheatMenu@main/CheatMenu.lua",
	"https://fastly.jsdelivr.net/gh/Mercershixin/CheatMenu@main/CheatMenu.lua",
	"https://gcore.jsdelivr.net/gh/Mercershixin/CheatMenu@main/CheatMenu.lua",
	"https://raw.githack.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
	"https://raw.gitmirror.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
	"https://ghproxy.net/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
	"https://ghfast.top/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
}
-- ★ v5.2.1 防缓存: raw / jsDelivr 对【分支 @main】都有 CDN 缓存(raw≈5分钟, jsDelivr≈12小时),
--   不处理的话重跑加载器拿到的还是【旧文件】-> 用户看到的现象就是"更新不了 / 还是旧版"。
--   加一个【运行时时间戳】查询参数: CDN 会把 query 算进缓存键 -> 每次请求都是新内容。
--   (raw / jsDelivr / ghproxy / ghfast 都忽略未知 query, 不影响下载。)
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
