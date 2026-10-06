-- 多脚本加载器 · 一次加载多个 lua 脚本（每个脚本多源回退 + 失败隔离）
-- 用法：把要加载的脚本填进下面的 SCRIPTS 列表，保存到执行器里执行即可。
-- 每个脚本 = { name = "名字", urls = { "主源", "备用源1", "备用源2", ... } }
-- 一个脚本挂了不会影响其他脚本，最后会汇总「成功 X / 失败 Y」。
local SCRIPTS = {
	{ name = "CheatMenu", urls = {
		"https://ghfast.top/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
		"https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
		"https://cdn.jsdelivr.net/gh/Mercershixin/CheatMenu@main/CheatMenu.lua",
	} },
	-- ▼ 在下面加「其他人的脚本」，格式照抄上面（name 随便起，urls 填脚本直链）：
	-- { name = "某某脚本", urls = {
	-- 	"https://raw.githubusercontent.com/作者/仓库/main/脚本.lua",
	-- } },
}

local TS = "?t=" .. tostring(type(os) == "table" and os.time and os.time() or 0)

local function fetchOne(script)
	local last = "?"
	for i, u in ipairs(script.urls) do
		local ok, body = pcall(game.HttpGet, game, u .. TS)
		if ok and type(body) == "string" and #body > 50 then
			local head = body:sub(1, 9)
			if head ~= "<!DOCTYPE" and not body:find("404: Not Found", 1, true) and not body:find("Not Found", 1, true) then
				return body, u
			end
			last = "返回的不是脚本(404/HTML)"
		else
			last = tostring(body)
		end
	end
	return nil, last
end

local okN, failN = 0, 0
for _, s in ipairs(SCRIPTS) do
	local name = s.name or "未命名"
	local src, used = fetchOne(s)
	if not src then
		warn(("[多脚本] [%s] 所有源都失败: %s"):format(name, tostring(used)))
		failN = failN + 1
	else
		local chunk, perr = (loadstring or load)(src, "@" .. name)
		if not chunk then
			warn(("[多脚本] [%s] 编译失败: %s"):format(name, tostring(perr)))
			failN = failN + 1
		else
			local ok, err = pcall(chunk)
			if ok then
				print(("[多脚本] [%s] 加载成功 (%d 字节 <- %s)"):format(name, #src, used))
				okN = okN + 1
			else
				warn(("[多脚本] [%s] 运行报错: %s"):format(name, tostring(err)))
				failN = failN + 1
			end
		end
	end
end
print(("[多脚本] 加载完成: 成功 %d / 失败 %d"):format(okN, failN))
