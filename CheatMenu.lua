print(('[CheatMenu] build 2026-10-04 14:47 sha 092c8694 bytes 454391'):format('2026-10-04 14:47','092c8694',454391))
local F = {}
F.VERSION = "v14.0.69"
F._flyDisabledInfJump = nil
F._flyJumpReqConn = nil
F._flyJumpAt = 0
F._menuHoldAt = nil
F._menuHoldMoved = false
F.LIMITS = {
SCAN_GC_CAP = 30000, SCAN_ANALYZE_CAP = 12000, SCAN_YIELD_EVERY = 300,
SCAN_SCRIPT_CAP = 40000, SCAN_DESC_EVERY = 400, CAPTURE_MAX = 240,
PROBE_STEP = 4, PROBE_SEC = 2,
}
F.REMOTE_URLS = {
"https://ghfast.top/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
"https://ghproxy.net/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
"https://gh-proxy.com/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
"https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
"https://cdn.jsdelivr.net/gh/Mercershixin/CheatMenu@main/CheatMenu.lua",
}
F.SANITIZE = {
{"cloneref", "cref"},
{"secure_call", "secure-call"},
{"run_secure_function", "run-secure-function"},
{"create_secure_function", "create-secure-function"},
{"getscriptclosure", "script-closure"}, {"getcallingscript", "calling-script"},
{"getscripthash", "script-hash"}, {"getnilinstances", "nil-inst"},
{"getloadedmodules", "loaded-mod"}, {"getconnections", "conn-list"},
{"getnamecallmethod", "nc-method-get"}, {"setnamecallmethod", "nc-method-set"},
{"getrawmetatable", "raw-mt-get"}, {"setrawmetatable", "raw-mt-set"},
{"hookmetamethod", "mt-hook"}, {"hookfunction", "fn-hook"}, {"newcclosure", "c-closure"},
{"getconstants", "const-list"}, {"getconstant", "const-get"}, {"setconstant", "const-set"},
{"getupvalues", "upval-list"}, {"getupvalue", "upval-get"}, {"setupvalue", "upval-set"},
{"getprotos", "proto-list"}, {"getproto", "proto-get"}, {"setproto", "proto-set"},
{"setclipboard", "clip-set"}, {"write_clipboard", "clip-write"}, {"toclipboard", "clip-copy"},
{"fireproximityprompt", "fire-prompt"}, {"firetouchinterest", "fire-touch"},
{"firesignal", "fire-signal"}, {"sethiddenproperty", "hidden-set"},
{"gethiddenproperty", "hidden-get"}, {"setscriptable", "scriptable-set"},
{"setsimulationradius", "simradius-set"}, {"getsimulationradius", "simradius-get"},
{"getcustomasset", "asset-get"}, {"getsynasset", "asset-get-syn"},
{"protect_gui", "gui-guard"}, {"unprotect_gui", "gui-unguard"},
{"identifyexecutor", "exec-id"}, {"queue_on_teleport", "qot"}, {"saveinstance", "inst-save"},
{"getspecialinfo", "special-info"}, {"setthreadcontext", "thread-ctx"},
{"getregistry", "registry-get"}, {"getstack", "stack-get"}, {"setstack", "stack-set"},
{"checkcaller", "caller-chk"}, {"islclosure", "lclosure-chk"},
{"setreadonly", "ro-flag-set"}, {"isreadonly", "ro-flag-chk"},
{"rconsoleprint", "rcon"}, {"rconsoleinfo", "rcon"}, {"rconsolewarn", "rcon"},
{"rconsoleerr", "rcon"}, {"rconsoleclear", "rcon"}, {"rconsolename", "rcon"},
{"rconsoleinput", "rcon"},
{"appendfile", "file-append"}, {"delfolder", "folder-del"}, {"makefolder", "folder-new"},
{"listfiles", "file-list"}, {"delfile", "file-del"}, {"readfile", "file-read"},
{"writefile", "file-write"}, {"isfile", "file-chk"}, {"loadfile", "file-load"},
{"gethui", "ui-hidden"}, {"getgenv", "genv-get"}, {"getrenv", "renv-get"},
{"getsenv", "senv-get"}, {"getmenv", "menv-get"}, {"gettenv", "tenv-get"},
{"HttpGet", "http-get"}, {"hooksignal", "signal-hook"}, {"replicatesignal", "signal-rep"},
{"cache_replace", "cache-rep"}, {"cache_invalidate", "cache-inv"},
}
function F.Sanitize(s)
s = tostring(s)
for i = 1, #F.SANITIZE do
local from = F.SANITIZE[i][1]
if s:find(from, 1, true) then
local pat = from:gsub("(%W)", "%%%1")
local to = F.SANITIZE[i][2]
s = s:gsub(pat, function() return to end)
end
end
return s
end
F._logBuf = F._logBuf or {}
F.LOG_BUF_MAX = F.LOG_BUF_MAX or 300
function F.Out(...)
local n = select("#", ...)
local parts = {}
for i = 1, n do
local s = F.Sanitize(select(i, ...))
if #s > 300 then s = s:sub(1, 300) .. "…(" .. #s .. "字)" end
parts[i] = s
end
local line = table.concat(parts, " ")
print(line)
F._logBuf[#F._logBuf + 1] = line
if F.LogFlush and not F._logFlushing and #F._logBuf >= F.LOG_BUF_MAX then
pcall(F.LogFlush, "自动")
end
end
function F.Try(name, fn, ...)
local ok, err = pcall(fn, ...)
if not ok then
pcall(F.Out, "[×] " .. tostring(name) .. " 调用失败(已跳过, 其余功能不受影响): " .. tostring(err))
end
return ok
end
F.Out("[CheatMenu] ===== 加载开始 · " .. F.VERSION .. " =====")
F.INSTANCE_KEY = "CM_Instance"
function F.KillPreviousInstance()
pcall(function()
if F.NukeAllGUIs then
local k = F.NukeAllGUIs(false)
if k > 0 then F.Out("[清理] 加载前已清掉 " .. tostring(k) .. " 个上次残留的界面") end
end
end)
local g = getgenv and getgenv()
if type(g) ~= "table" then return end
local prev = g[F.INSTANCE_KEY]
local hadHandle = (type(prev) == "table")
local ver, okUn = "?", false
if hadHandle then
g[F.INSTANCE_KEY] = nil
ver = tostring(prev.version or "?")
if type(prev.unload) == "function" then okUn = pcall(prev.unload) end
if type(prev.gui) == "table" then pcall(function() prev.gui:Destroy() end) end
if type(prev.handles) == "table" then
for _, h in ipairs(prev.handles) do
if typeof(h) == "Instance" and h.Parent then pcall(function() h:Destroy() end) end
end
end
end
local legacy = false
local w = g.CM_Window
if w ~= nil then
legacy = true
if type(w) == "table" and type(w.Destroy) == "function" then
pcall(function() w:Destroy() end)
elseif typeof(w) == "Instance" then
pcall(function() w:Destroy() end)
end
end
local sg = g.CM_ToggleSG
if sg ~= nil then
legacy = true
if typeof(sg) == "Instance" then pcall(function() sg:Destroy() end) end
end
g.CM_Window, g.CM_ToggleSG, g.CM_TogglePolish = nil, nil, nil
if hadHandle then
F.Out("[重复加载] 检测到上一份脚本(v" .. ver .. ") ⇒ 已"
.. (okUn and "干净卸载它" or "尽力清理(旧版没有卸载接口)") .. "，本次只保留一份")
if not okUn then
F.Out("[重复加载] 旧实例的循环可能还挂在引擎上(旧版没有卸载接口) ⇒ 想彻底干净就「重进一次游戏」")
end
elseif legacy then
F.Out("[重复加载] 检测到旧版实例留下的菜单 ⇒ 已清掉它; 但旧版没有卸载接口, 它的循环可能还在跑 ⇒ 建议「重进一次游戏」拿干净环境")
end
end
pcall(F.KillPreviousInstance)
local Players  = game:GetService("Players")
local RS       = game:GetService("RunService")
local UIS      = game:GetService("UserInputService")
local HS       = game:GetService("HttpService")
local CS       = game:GetService("CollectionService")
local RStorage = game:GetService("ReplicatedStorage")
local WS       = game:GetService("Workspace")
local LP = Players.LocalPlayer
F._touchDown = false
pcall(function()
UIS.TouchStarted:Connect(function() F._touchDown = true end)
UIS.TouchEnded:Connect(function() F._touchDown = false end)
end)
local PG = LP and LP:FindFirstChild("PlayerGui")
local CoreGui = nil
pcall(function() if gethui then CoreGui = gethui() end end)
if not CoreGui then pcall(function() CoreGui = game:GetService("CoreGui") end) end
local hookfunction  = hookfunction or hookfunc or replaceclosure
local newcclosure   = newcclosure
local hookmetamethod = hookmetamethod
local getgc         = getgc or getGC
local islclosure    = islclosure
local checkcaller   = checkcaller or function() return false end
local getnamecallmethod = getnamecallmethod
local dbgGetConstants = (debug and (debug.getconstants or debug.getconsts)) or getconstants or getconsts
local dbgGetUpvalues  = (debug and (debug.getupvalues or debug.getupvals)) or getupvalues or getupvals
local dbgGetInfo      = (debug and (debug.getinfo or debug.info)) or getinfo
local dbgGetGC        = getgc or get_gc_objects or getGC
local T = {}
local C = {}
local _gcCh, _gcHum, _gcRoot
local function GC()
if _gcCh and _gcCh.Parent and _gcHum and _gcHum.Parent and _gcRoot and _gcRoot.Parent then
return _gcCh, _gcHum, _gcRoot
end
local ok, ch, hum, root = pcall(function()
local c = LP.Character
local h = c and c:FindFirstChildOfClass("Humanoid")
local r = (h and c:FindFirstChild("HumanoidRootPart")) or (c and c:FindFirstChild("HumanoidRootPart"))
return c, h, r
end)
if not ok then return _gcCh, _gcHum, _gcRoot end
_gcCh, _gcHum, _gcRoot = ch, hum, root
return ch, hum, root
end
local function GCInvalidate() _gcCh, _gcHum, _gcRoot = nil, nil, nil end
pcall(function()
LP.CharacterAdded:Connect(function(ch)
GCInvalidate()
task.defer(function()
local hum = ch:FindFirstChildOfClass("Humanoid") or ch:WaitForChild("Humanoid", 3)
local root = ch:FindFirstChild("HumanoidRootPart") or ch:WaitForChild("HumanoidRootPart", 3)
_gcCh, _gcHum, _gcRoot = ch, hum, root
pcall(function() if F.OnCharacter then F.OnCharacter(ch) end end)
end)
end)
end)
local RRemoteCache = {}
local function findRemote(name, cls)
local ck = cls .. "\1" .. name
if RRemoteCache[ck] then return RRemoteCache[ck] end
local function typOk(o)
if not o then return nil end
if o:IsA(cls) then return o end
local okU, isU = pcall(function() return o:IsA("UnreliableRemoteEvent") end)
if cls == "RemoteEvent" and okU and isU then return o end
return nil
end
local function ok2(o)
if not (o and o.Name == name) then return nil end
return typOk(o)
end
pcall(function()
local n = RStorage
local segs = { "Shared", "Packages", "Network" }
for i = 1, #segs do
n = n and n:FindFirstChild(segs[i])
if not n then break end
end
if n then
local pre = (cls == "RemoteEvent") and "rev_" or "ref_"
local cands = { name, pre .. name, tostring(name):gsub("%.", "_") }
for i = 1, #cands do
local r0 = typOk(n:FindFirstChild(cands[i]))
if r0 then RRemoteCache[ck] = r0 end
end
end
end)
if RRemoteCache[ck] then return RRemoteCache[ck] end
local sh = RStorage:FindFirstChild("Shared")
local pk = sh and sh:FindFirstChild("Packages")
local net = pk and pk:FindFirstChild("Network")
if net then
local pre = (cls == "RemoteEvent") and "rev_" or "ref_"
local r = ok2(net:FindFirstChild(pre .. name)) or ok2(net:FindFirstChild(pre .. tostring(name):gsub("%.", "_")))
if r then RRemoteCache[ck] = r return r end
end
local pre2 = (cls == "RemoteEvent") and "rev_" or "ref_"
pcall(function()
local cands = { pre2 .. name, pre2 .. tostring(name):gsub("%.", "_"), name }
for i = 1, #cands do
local c = RStorage:FindFirstChild(cands[i], true)
if not c then
local sh2 = RStorage:FindFirstChild("Shared")
local pk2 = sh2 and sh2:FindFirstChild("Packages")
local net2 = pk2 and pk2:FindFirstChild("Network")
if net2 then c = net2:FindFirstChild(cands[i], true) end
end
local r2 = typOk(c)
if r2 then RRemoteCache[ck] = r2 end
end
end)
if RRemoteCache[ck] then return RRemoteCache[ck] end
local leaf = tostring(name):match("([^%.]+)$") or name
local pre3 = (cls == "RemoteEvent") and "rev_" or "ref_"
local lower = tostring(name):lower()
local q, qh, qt = { RStorage }, 1, 1
local budget = 20000
while qh <= qt and budget > 0 do
local node = q[qh] qh = qh + 1 budget = budget - 1
local ok, kids = pcall(function() return node:GetChildren() end)
if ok and type(kids) == "table" then
for i = 1, #kids do
local c = kids[i]
local cn = c.Name
local match = (cn == name) or (cn == leaf) or (cn == pre3 .. name)
if not match then
local cl = cn:lower()
match = (cl == lower) or (cl == pre3 .. lower) or (cl == "rev_" .. lower) or (cl == "ref_" .. lower)
end
if match then
local rr = typOk(c)
if rr then RRemoteCache[ck] = rr return rr end
end
if c:IsA("Folder") or c:IsA("Configuration") then qt = qt + 1 q[qt] = c end
end
end
end
return nil
end
local function REvent(n) return findRemote(n, "RemoteEvent") end
local function RFunction(n) return findRemote(n, "RemoteFunction") end
local function Fire(n, ...)
local r = REvent(n)
if not r then return false end
pcall(function(...) r:FireServer(...) end, ...)
return true
end
local function FireAny(names, ...)
for i = 1, #names do
local r = REvent(names[i])
if r then
pcall(function(...) r:FireServer(...) end, ...)
return names[i]
end
end
return false
end
F.PLACE_KEYS = { "S_Interact", "B_Interact", "S_Place", "B_Place", "B_PutEgg", "S_PutEgg",
"PlaceEgg", "PlaceBrainrot", "PlaceItem", "Deploy", "SetPlot", "S_Put", "B_Put", "Interact" }
F.COLLECT_KEYS = { "B_Collect", "S_Collect", "Collect", "S_Interact", "B_CollectCash", "CollectCash" }
local SaveFile = "CheatMenu_Config_v1.json"
local Fluent = nil
local FLUENT_SOURCES = {
"https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua",
"https://ghfast.top/https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://gh-proxy.com/https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://ghpxy.hwinzniej.top/https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://ghproxy.net/https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://cdn.jsdelivr.net/gh/dawid-scripts/Fluent@master/main.lua",
"https://fastly.jsdelivr.net/gh/dawid-scripts/Fluent@master/main.lua",
"https://gcore.jsdelivr.net/gh/dawid-scripts/Fluent@master/main.lua",
}
local FLUENT_LOCAL = { "CheatMenu_Fluent.lua", "Fluent.lua", "fluent.lua" }
local function fluentLooksLua(body)
if type(body) ~= "string" or #body < 5000 then return false end
local head = string.lower(string.sub(body, 1, 400))
if string.find(head, "<!doctype", 1, true) or string.find(head, "<html", 1, true) then return false end
if string.find(body, "return", 1, true) == nil then return false end
return true
end
local function fluentTry(body, how)
local ok2, chunk = pcall(loadstring or load, body)
if not ok2 or not chunk then return false end
local ok3, loaded = pcall(chunk)
if ok3 and loaded then
Fluent = loaded
F.Out("[CheatMenu] Fluent 加载成功 ← " .. tostring(how))
return true
end
return false
end
if type(readfile) == "function" and type(isfile) == "function" then
for _, fn in ipairs(FLUENT_LOCAL) do
local okE, exists = pcall(isfile, fn)
local okR, body = false, nil
if okE and exists then okR, body = pcall(readfile, fn) end
if okR and fluentLooksLua(body) and fluentTry(body, "本地文件 " .. fn) then break end
end
end
if not Fluent then
for _, url in ipairs(FLUENT_SOURCES) do
local ok, body = pcall(function() return game:HttpGet(url) end)
if ok and fluentLooksLua(body) and fluentTry(body, string.sub(url, 1, 48)) then break end
end
end
if not Fluent then
local why = (type(loadstring) ~= "function" and type(load) ~= "function")
and "本执行器既没有 loadstring 也没有 load" or "镜像/网络全部取不到"
local msg = "CheatMenu 未启动: Fluent UI 取不到(" .. why .. ")"
pcall(function() warn(msg) end)
pcall(function()
game:GetService("StarterGui"):SetCore("SendNotification", {
Title = "CheatMenu 未启动",
Text = msg .. "。可换网络重试, 或把 Fluent 的 main.lua 存成 CheatMenu_Fluent.lua 放到执行器目录(会优先本地加载)。",
Duration = 25,
})
end)
pcall(function()
F.Out("[CheatMenu] ✗ " .. msg)
F.Out("[CheatMenu]   ① 换能联网的执行器/网络重试")
F.Out("[CheatMenu]   ② 或把 Fluent 的 main.lua 存成 CheatMenu_Fluent.lua 放进执行器目录(脚本会优先读本地)")
F.Out("[CheatMenu]   ③ 若控制台显示 loadstring 为 nil, 换一个带 loadstring/load 的执行器")
end)
return
end
local AC = {}
AC.BlockedRemotes = {}
AC.HookedCount = 0
AC._idxMaskOn = false
AC._stblOld = nil
AC._scriptWatchConn = nil
AC.BLOCK_KEYS = {
"iac", "anticheat", "anti-cheat", "antiexploit", "anti-exploit",
"detected", "detection", "cheatdetector", "cheat-detector", "antihack", "anti-hack",
"watchdog", "sentinel", "x-15", "x-16", "speedcheck", "flycheck", "clientcheck",
"positioncheck", "position-check", "velocitycheck", "velocity-check",
"movementcheck", "noclipcheck", "godcheck", "integrity", "checksum",
"reportabuse", "adminabuse", "punishplayer", "banplayer", "flagplayer",
}
AC.HP_KEYS = {
"applydamage", "dealdamage", "takedamage", "sethp", "sethealth", "sethpvalue",
"damage", "hurt", "injured", "wound",
"death", "died", "die", "dead", "killed", "killme", "respawnrequest",
"ragdoll", "knockback", "stunned",
}
AC.SUS_KEYS = {
"iac", "anticheat", "anti-cheat", "antiexploit", "anti-exploit", "detect",
"ban", "kick", "flag", "report", "exploit", "cheat", "x-15", "x-16",
"verify", "suspend", "watchdog", "sentinel", "moderation", "moderator",
"guard", "spy", "speedcheck", "flycheck", "clientcheck",
"reportabuse", "antihack", "anti-hack", "cheatdetector", "cheat-detector",
"teleport", "tpcheck", "positioncheck", "position-check", "velocitycheck",
"velocity-check", "healthcheck", "jumpcheck", "toolcheck", "adminabuse",
"ac_", "banned", "punish", "penalty", "violation", "infraction",
"handshake", "integrity", "heartbeatcheck", "pingcheck", "clientflag",
"secure", "validator", "checksum", "authcheck", "servercheck",
"movementcheck", "noclipcheck", "godcheck", "silentaim", "aimbot",
}
AC.SUS_SET = {}
for i = 1, #AC.SUS_KEYS do AC.SUS_SET[AC.SUS_KEYS[i]] = true end
function AC.isSuspicious(name)
name = tostring(name):lower()
if AC.SUS_SET[name] then return true end
for i = 1, #AC.SUS_KEYS do
if name:find(AC.SUS_KEYS[i], 1, true) then return true end
end
return false
end
AC.KNOWN_LIMITS = {
{ src = "Sentinel", key = "MaxTeleportDistance", val = 50,  unit = "studs / 0.1s 窗口", ours = "smoothTP 每 0.1s <45" },
{ src = "Sentinel", key = "MaxPlayerSpeed",      val = 100, unit = "studs/s",          ours = "CFrame 加速每 0.1s<=4 => 40/s" },
{ src = "Sentinel", key = "MaxRemoteCallsPerSecond", val = 30, unit = "次/秒",          ours = "自动攻击上限 25/s" },
{ src = "Sentinel", key = "FlyDetectionTime",    val = 2,   unit = "秒(滞空)",          ours = "飞行高度上限 + 假落地" },
{ src = "Sentinel", key = "DetectionThreshold",  val = 5,   unit = "次(累计才处置)",     ours = "尽量不产生任何一次" },
{ src = "Adonis",   key = "Speed(GetRealPhysicsFPS)", val = 0, unit = "物理帧率超阈值即 kill", ours = "不动 WalkSpeed 上限, 优先 CFrame" },
{ src = "Adonis",   key = "HumanoidState==StrafingNoPhysics", val = 0, unit = "立即 kill(NoClipping)", ours = "穿墙时禁用该状态" },
{ src = "Adonis",   key = "LogBlacklist", val = 0, unit = "命中即 kill",      ours = "F.Sanitize 全量消毒(含日志词黑名单)" },
{ src = "Sentinel", key = "按实例名扫 {exploit,inject,cheat,...}", val = 0, unit = "建实例即标记", ours = "实例名已去特征化" },
}
AC._strongAC = nil
function AC.DetectStrongAC(verbose)
if AC._strongAC ~= nil then return AC._strongAC end
local found = nil
local keepScav = F._scavenging
F._scavenging = true
pcall(function()
if type(getnilinstances) ~= "function" then return end
local arr = getnilinstances()
for i = 1, #arr do
if i > F.LIMITS.SCAN_GC_CAP then break end
if i % F.LIMITS.SCAN_YIELD_EVERY == 0 then task.wait() end
local inst = arr[i]
if typeof(inst) == "Instance" then
local n = inst.Name
if #n >= 6 and n:gsub("%s", "") == "ModuleScript" and n:find(string.char(10), 1, true) then
found = "Adonis"; break
end
end
end
end)
if not found then
pcall(function()
local marks = { "Adonis", "Adonis_Loader", "Adonis_Server" }
for i = 1, #marks do
local m = marks[i]
if RStorage:FindFirstChild(m) or (LP and LP:FindFirstChild(m)) then found = "Adonis" break end
end
end)
end
if not found then
pcall(function()
local generic = { "Kronos", "Sentinel", "Falcon", "CheckMe", "AntiCheat" }
for i = 1, #generic do
if RStorage:FindFirstChild(generic[i], true) then found = generic[i] break end
end
end)
end
F._scavenging = keepScav
AC._strongAC = found or false
if verbose then
F.Out("[强反作弊识别] " .. (found and ("检测到: " .. found .. " —— 已自动开启静默消毒输出") or "未检测到已知强反作弊指纹"))
end
return found
end
AC._quiet = false
function AC.SetQuiet(on)
AC._quiet = on and true or false
end
function AC.IsStrongAC()
local a = AC.DetectStrongAC(false)
return a ~= false and a ~= nil
end
F.MetaLayers = {}
F.MetaTargets = {}
local function MetaSlotOf(s)
local k = tostring(s or ""):match("([^%.]+)$")
return k or tostring(s or "")
end
function F.MetaInstall(slot, target, id, wrapperFactory)
if not (hookmetamethod and newcclosure and getrawmetatable) then return nil end
if type(slot) ~= "string" or type(id) ~= "string" or target == nil then return nil end
slot = MetaSlotOf(slot)
if F.MetaTargets[slot] == nil then
F.MetaTargets[slot] = target
elseif F.MetaTargets[slot] ~= target then
return nil
end
local bucket = F.MetaLayers[slot]
if not bucket then bucket = {} F.MetaLayers[slot] = bucket end
if bucket[id] then F.MetaUninstall(slot, id) end
local mt = getrawmetatable(target)
if type(mt) ~= "table" or type(mt[slot]) ~= "function" then return nil end
local box = { alive = true, orig = nil, id = id, slot = slot }
local raw = wrapperFactory(box)
if type(raw) ~= "function" then return nil end
local rec = { id = id, slot = slot, target = target, box = box, raw = raw, alive = true }
local mk = newcclosure
if T.CMX_HookHard and type(AC) == "table" and type(AC.cap) == "function" then
local okN, nl = pcall(AC.cap, "newlclosure")
if okN and type(nl) == "function" then mk = nl end
end
local wrapped
local okW = pcall(function()
wrapped = mk(function(self, ...)
if not rec.alive then return box.orig(self, ...) end
return raw(self, ...)
end)
end)
if not (okW and type(wrapped) == "function") then return nil end
local origFn
local okH = pcall(function() origFn = hookmetamethod(target, slot, wrapped) end)
if not (okH and type(origFn) == "function") then return nil end
box.orig = origFn
rec.wrapper = wrapped
if F.CMX_MarkOwn then pcall(F.CMX_MarkOwn, wrapped) end
bucket[id] = rec
return wrapped
end
function F.MetaUninstall(slot, id)
slot = MetaSlotOf(slot)
local bucket = F.MetaLayers[slot]
if not bucket then return false end
local rec = bucket[id]
if not rec or not rec.alive then return false end
rec.alive = false
rec.box.alive = false
bucket[id] = nil
local mt = getrawmetatable(rec.target)
if type(mt) == "table" and mt[slot] == rec.wrapper then
local ok = pcall(function() hookmetamethod(rec.target, slot, rec.box.orig) end)
pcall(F.CMX_RestoreRO)
return ok
end
for _, other in pairs(bucket) do
if other.alive and other.box and other.box.orig == rec.wrapper then
other.box.orig = rec.box.orig
end
end
return true
end
function F.MetaActive(slot, id)
slot = MetaSlotOf(slot)
local b = F.MetaLayers[slot]
return (b and b[id] and b[id].alive) and true or false
end
F._LOCK_KEYS = {
WalkSpeed = true, JumpPower = true, JumpHeight = true, PlatformStand = true,
CanCollide = true, Health = true, MaxHealth = true,
}
F.LockFieldsInstall = function()
if F.MetaActive("__newindex", "CMLockFields") then return true end
local got = F.MetaInstall("__newindex", game, "CMLockFields", function(box)
return function(t, k, v)
if checkcaller() then return box.orig(t, k, v) end
if not F._LOCK_KEYS[k] then return box.orig(t, k, v) end
if typeof(t) ~= "Instance" then return box.orig(t, k, v) end
local ch, hum = GC()
if ch and hum and t == hum then
if k == "WalkSpeed" and T.SpeedOn then
v = tonumber(C.SpeedValue) or v
elseif k == "JumpPower" and (T.InfiniteJump or T.SpeedOn) then
v = 50
elseif k == "JumpHeight" and T.InfiniteJump then
v = 7.5
elseif k == "PlatformStand" and T.FlyOn then
v = true
elseif k == "MaxHealth" and T.God then
v = 1e9
elseif k == "Health" then
if T.God then v = 1e9
elseif T.LockHealth then v = tonumber(C.LockHealthValue) or 100
elseif T.NoDeath and tonumber(v) and tonumber(v) <= 0 then v = 1 end
end
elseif k == "CanCollide" and T.NoClip and ch then
local mine = false
pcall(function() mine = t:IsDescendantOf(ch) end)
if mine then v = false end
end
return box.orig(t, k, v)
end
end)
if got and not F._lockLogged then
F._lockLogged = true
F.Out("[属性锁定] 已装 __newindex 层: 游戏想改你的 速度/跳跃/飞行/血量/碰撞 时会被按你开着的功能改写回去")
end
return got ~= nil
end
F.LockFieldsUninstall = function()
F._lockLogged = nil
return F.MetaUninstall("__newindex", "CMLockFields")
end
function AC.InstallNamecallHook()
if AC._nc then return true end
local got = F.MetaInstall("__namecall", game, "AC", function(box)
return function(self, ...)
local method = getnamecallmethod and getnamecallmethod() or ""
if (method == "FireServer" or method == "InvokeServer") and T.RemoteBlock and not checkcaller() then
local name = tostring(self and self.Name or ""):lower()
for _, kw in ipairs(AC.BLOCK_KEYS) do
local hit = false
if type(F.CMX_KeyIsolate) == "function" then hit = F.CMX_KeyIsolate(name, kw)
else hit = name:find(kw, 1, true) ~= nil end
if hit then
AC._remoteBlocked = (AC._remoteBlocked or 0) + 1
AC._remoteMute = AC._remoteMute or {}
local mk2 = tostring(name)
AC._remoteMute[mk2] = (AC._remoteMute[mk2] or 0) + 1
if AC._remoteMute[mk2] >= 3 then
AC._muteLogged = AC._muteLogged or {}
if not AC._muteLogged[mk2] then
AC._muteLogged[mk2] = true
local m3 = "[拦 remote·熔断] " .. mk2 .. " 已反复上报 3 次 ⇒ 直接挂起它的调用(不再占网络/不再卡顿)"
if type(task) == "table" and task.defer then task.defer(function() pcall(F.Out, m3) end)
else pcall(F.Out, m3) end
end
return task.wait(9e9)
end
local now = os.clock()
if now - (AC._remoteLogAt or 0) > 3 then
AC._remoteLogAt = now
local msg = "[拦 remote] " .. tostring(name) .. " ← 关键词 " .. tostring(kw)
.. " (累计 " .. tostring(AC._remoteBlocked) .. " 次; 游戏功能异常就说明这个词误伤了)"
if type(task) == "table" and task.defer then task.defer(function() pcall(F.Out, msg) end)
else pcall(F.Out, msg) end
end
return nil
end
end
end
if (method == "FireServer" or method == "InvokeServer") and T.HpBlock and not checkcaller() then
local hname = tostring(self and self.Name or ""):lower()
for _, kw in ipairs(AC.HP_KEYS) do
local hit = false
if type(F.CMX_KeyIsolate) == "function" then hit = F.CMX_KeyIsolate(hname, kw)
else hit = hname:find(kw, 1, true) ~= nil end
if hit then
AC._hpBlocked = (AC._hpBlocked or 0) + 1
local now2 = os.clock()
if now2 - (AC._hpLogAt or 0) > 3 then
AC._hpLogAt = now2
local m2 = "[拦受伤上报] " .. tostring(hname) .. " ← 关键词 " .. tostring(kw)
.. " (累计 " .. tostring(AC._hpBlocked) .. " 次) ⇒ 服务端收不到这条, 它就不知道你受伤/死了"
if type(task) == "table" and task.defer then task.defer(function() pcall(F.Out, m2) end)
else pcall(F.Out, m2) end
end
return nil
end
end
end
return box.orig(self, ...)
end
end)
AC._nc = got ~= nil
AC._ncLayer = got
return AC._nc
end
function AC.UninstallNamecallHook()
if not AC._nc then return false end
if T.HpBlock or T.RemoteBlock then return false end
local ok = F.MetaUninstall("__namecall", "AC")
AC._nc = false
AC._ncLayer = nil
return ok
end
F.HpBlockSet = function(on)
T.HpBlock = on and true or false
if T.HpBlock then
pcall(AC.InstallNamecallHook)
F.Out("[拦受伤上报] 已开: 客户端发出的「受伤/死亡」类 remote 会被本地拦下 ⇒ 服务端收不到这条")
F.Out("[拦受伤上报] 生效条件: 游戏必须是「客户端算伤害再上报」; 若是服务端算伤害, 拦了也没用(服务端早就知道了)。日志会列出实际拦到了什么, 游戏变卡就说明误伤, 关掉即恢复")
else
F.Out("[拦受伤上报] 已关(已不再拦, 未卸载公共钩子)")
end
end
AC.REMOTE_CLASSES = { "RemoteEvent", "UnreliableRemoteEvent", "RemoteFunction" }
function AC.isRemoteLike(inst)
if not (inst and typeof(inst) == "Instance") then return nil end
for i = 1, #AC.REMOTE_CLASSES do
local cls = AC.REMOTE_CLASSES[i]
local ok, hit = pcall(function() return inst:IsA(cls) end)
if ok and hit then return cls end
end
return nil
end
function AC.hookOneRemote(remote)
if not (remote and typeof(remote) == "Instance") then return end
local cls = AC.isRemoteLike(remote)
if not cls then return end
local isE = (cls ~= "RemoteFunction")
if AC.BlockedRemotes[remote] then return end
if not AC.isSuspicious(remote.Name) then return end
if not hookfunction then return end
local orig
local fn = isE and remote.FireServer or remote.InvokeServer
local wrapper = function(self, ...)
if (T.RemoteBlock or T.ACBypass) and not checkcaller() then return nil end
if orig then return orig(self, ...) end
end
local ok, res = pcall(function()
if newcclosure then return hookfunction(fn, newcclosure(wrapper)) else return hookfunction(fn, wrapper) end
end)
if ok and type(res) == "function" then
orig = res
AC.BlockedRemotes[remote] = res
AC.HookedCount = AC.HookedCount + 1
AC.markHooked(fn)
end
end
function AC.UnblockRemotes()
if hookfunction then
for remote, orig in pairs(AC.BlockedRemotes) do
pcall(function() hookfunction(remote.FireServer, orig) end)
end
end
AC.BlockedRemotes = {}
AC.HookedCount = 0
end
AC._weakTables = setmetatable({}, { __mode = "k" })
AC._weakSeen = 0
function AC.InstallSetmetatableHook()
if AC._stblOld then return true end
if not (hookfunction and newcclosure) then return false end
local ok, res = pcall(function()
return hookfunction(setmetatable, newcclosure(function(tbl, mt)
if type(mt) == "table" then
local mode = rawget(mt, "__mode")
if type(mode) == "string" and (mode:find("k", 1, true) or mode:find("v", 1, true)) then
AC._weakSeen = AC._weakSeen + 1
if type(tbl) == "table" then pcall(rawset, AC._weakTables, tbl, true) end
if T.ACBypass then
F.Out("[CheatMenu] 拦截弱表 setmetatable: __mode=" .. mode .. " (累计 " .. AC._weakSeen .. ")")
end
end
end
return AC._stblOld(tbl, mt)
end))
end)
if ok and type(res) == "function" then
AC._stblOld = res
F.Out("[CheatMenu] setmetatable Hook 已安装")
return true
end
return false
end
function AC.UninstallSetmetatableHook()
if AC._stblOld and hookfunction then
pcall(function() hookfunction(setmetatable, AC._stblOld) end)
end
AC._stblOld = nil
end
AC.KILL_SUB = {
"anticheat", "anti-cheat", "anti_cheat", "antiexploit", "anti-exploit", "antihack", "anti-hack",
"antikick", "antibot", "anti-bot", "watchdog", "sentinel", "banwave", "cheatdetect", "cheat-detector",
"reportabuse", "integrity", "handshake", "checksum", "violation", "infraction", "punisher",
}
AC.KILL_TOK = {
"ac", "ban", "flag", "guard", "detect", "detection", "validate", "security",
"moderation", "report", "sentry", "auth", "verify", "suspend",
}
AC.KILL_SEP = { "_", "-", " ", "." }
function AC.killHit(name)
local n = tostring(name or ""):lower()
if n == "" then return false, false end
for i = 1, #AC.KILL_SUB do
if n:find(AC.KILL_SUB[i], 1, true) then return true, true end
end
for i = 1, #AC.KILL_TOK do
local kw = AC.KILL_TOK[i]
if n == kw then return true, false end
if n:sub(1, #kw) == kw and not n:sub(#kw + 1, #kw + 1):match("%a") then return true, false end
for j = 1, #AC.KILL_SEP do
local d = AC.KILL_SEP[j]
local pos = n:find(d .. kw, 1, true)
if pos then
local after = pos + #d + #kw
if not n:sub(after, after):match("%a") then return true, false end
end
end
end
return false, false
end
function AC.killScript(d, strong)
pcall(function() d.Disabled = true end)
if type(getconnections) == "function" then
pcall(function()
local sigs = { d.Changed, d.AncestryChanged, d.Destroying }
for i = 1, #sigs do
if sigs[i] then
local ok, conns = pcall(getconnections, sigs[i])
if ok and type(conns) == "table" then
for _, c in ipairs(conns) do pcall(function() c:Disable() end) end
end
end
end
end)
end
if strong then
task.delay(2, function()
pcall(function() if d and d.Parent then d:Destroy() end end)
end)
end
end
function AC.WatchNewScriptsEnable()
if AC._scriptWatchConn then return end
AC._scriptWatchConn = game.DescendantAdded:Connect(function(d)
if not (d:IsA("LocalScript") or d:IsA("ModuleScript")) then return end
local hit, strong = AC.killHit(d.Name)
if hit then
F.Out("[CheatMenu] 拦截可疑脚本: " .. d:GetFullName() .. (strong and " (强特征·延迟销毁)" or " (词元特征·仅禁用)"))
AC.killScript(d, strong)
end
end)
end
function AC.WatchNewScriptsDisable()
if AC._scriptWatchConn then AC._scriptWatchConn:Disconnect() AC._scriptWatchConn = nil end
end
AC._watchConn = nil
function AC.WatchNewRemotesEnable()
if AC._watchConn then return end
AC._watchConn = RStorage.DescendantAdded:Connect(function(d)
if AC.isRemoteLike(d) and AC.isSuspicious(d.Name) then
AC.hookOneRemote(d)
end
end)
end
function AC.WatchNewRemotesDisable()
if AC._watchConn then AC._watchConn:Disconnect() AC._watchConn = nil end
end
AC._ownFns = setmetatable({}, { __mode = "k" })
AC._mySrc = nil
pcall(function()
local i = debug and debug.getinfo and debug.getinfo(1, "s")
AC._mySrc = i and i.source or nil
end)
AC._HIDE_FAKE = function() return "[Hidden]" end
AC.markOwn = function(fn)
if type(fn) == "function" then AC._ownFns[fn] = true end
return fn
end
AC._hookedFns = setmetatable({}, { __mode = "k" })
AC.markHooked = function(fn)
if type(fn) == "function" then AC._hookedFns[fn] = true end
return fn
end
AC.srcOf = function(fn)
if type(fn) ~= "function" then return nil end
local keep = F._scavenging
F._scavenging = true
local ok, info = pcall(debug.getinfo, fn, "s")
F._scavenging = keep
return (ok and info and info.source) or nil
end
AC.selfSrc = function()
if AC._mySrc == nil or AC._mySrc == "" then
AC._mySrc = AC.srcOf(F.UnifiedACPass) or AC.srcOf(AC.selfSrc)
end
return AC._mySrc
end
AC.isOwnConn = function(fn)
if type(fn) ~= "function" then return false end
if AC._ownFns[fn] then return true end
local mine = AC.selfSrc()
if not mine or mine == "" then return false end
return AC.srcOf(fn) == mine
end
AC.isOwnChar = function(inst)
if typeof(inst) ~= "Instance" then return false end
local ch, hum = GC()
if inst == ch or inst == hum then return true end
local ok, under = pcall(function() return ch ~= nil and inst:IsDescendantOf(ch) end)
return ok and under or false
end
function AC.InstallIndexMask()
if AC._idxMaskOn and F.MetaActive("game.__index", "ACIndexMask") then return true end
local got = F.MetaInstall("game.__index", game, "ACIndexMask", function(box)
return function(t, k)
if checkcaller() or typeof(t) ~= "Instance" then return box.orig(t, k) end
if k == "WalkSpeed" or k == "JumpPower" or k == "JumpHeight" then
if not (T.SpeedMask or T.ACBypass or T.Spoof) then return box.orig(t, k) end
local _, hum = GC()
if hum and t == hum then
if k == "WalkSpeed" then return F.CMX_LegitWalk() end
if k == "JumpPower" then return 50 end
if k == "JumpHeight" then return 7.5 end
end
return box.orig(t, k)
end
if k == "MaxHealth" or k == "Health" then
if not (T.Spoof or T.ACBypass) then return box.orig(t, k) end
local _, hum = GC()
if hum and t == hum then
local v = (k == "MaxHealth") and hum.MaxHealth or hum.Health
if type(v) == "number" and v > 100 then return 100 end
end
return box.orig(t, k)
end
if k == "GetFullName" and AC.isOwnChar(t) then return AC._HIDE_FAKE end
return box.orig(t, k)
end
end)
AC._idxMaskOn = got ~= nil
AC._idxMaskLayer = got
return AC._idxMaskOn
end
AC.InstallIndexHook = function() return AC.InstallIndexMask() end
function AC.UninstallIndexMask()
if AC._idxMaskOn then
F.MetaUninstall("game.__index", "ACIndexMask")
end
AC._idxMaskOn = false
AC._idxMaskLayer = nil
end
AC._connDisabled = 0
AC._disabledConns = {}
AC._forceConnSignals = true
function AC.disableSignalConns(sig, force, out)
if not sig or type(getconnections) ~= "function" then return out end
local ok, conns = pcall(getconnections, sig)
if not (ok and type(conns) == "table") then return out end
for _, c in ipairs(conns) do
out.scanned = out.scanned + 1
local fn = nil
pcall(function() fn = c.Function end)
if fn == nil then pcall(function() fn = c.__function end) end
if not AC.isOwnConn(fn) then
local info = nil
if fn then pcall(function() info = debug.getinfo(fn, "s") end) end
local src = (info and info.source) or ""
local nm = (info and info.name) or ""
local cnm = ""
pcall(function() cnm = tostring(c.Name or "") end)
local sus = AC.isSuspicious(src) or AC.isSuspicious(nm) or AC.isSuspicious(cnm)
if sus or (force and AC._forceConnSignals) then
local okd = pcall(function() c:Disable() end)
if okd then
out.disabled = out.disabled + 1
AC._disabledConns[#AC._disabledConns + 1] = c
out.logged = (out.logged or 0) + 1
if out.logged <= 12 then
F.Out("[连接清理] 已禁用: " .. tostring(cnm ~= "" and cnm or "(无名)")
.. " ← " .. tostring(nm ~= "" and nm or "?")
.. " @ " .. tostring(src ~= "" and src:sub(1, 90) or "?"))
end
end
end
end
end
return out
end
function AC.DisableACConnections(force)
local out = { scanned = 0, disabled = 0 }
if type(getconnections) ~= "function" then return 0, 0 end
local keepScav = F._scavenging
F._scavenging = true
pcall(F.markOwnClosures)
local ch, hum, root = GC()
local hardSigs, stateSigs, softSigs = {}, {}, {}
local function add(list, sig) if sig then list[#list + 1] = sig end end
if hum then
pcall(function() add(hardSigs, hum:GetPropertyChangedSignal("WalkSpeed")) end)
pcall(function() add(hardSigs, hum:GetPropertyChangedSignal("JumpPower")) end)
pcall(function() add(hardSigs, hum:GetPropertyChangedSignal("JumpHeight")) end)
pcall(function() add(stateSigs, hum:GetPropertyChangedSignal("Health")) end)
pcall(function() add(stateSigs, hum:GetPropertyChangedSignal("MaxHealth")) end)
pcall(function() add(stateSigs, hum.Changed) end)
pcall(function() add(stateSigs, hum.StateChanged) end)
end
if root then
pcall(function() add(hardSigs, root:GetPropertyChangedSignal("CFrame")) end)
pcall(function() add(hardSigs, root:GetPropertyChangedSignal("Position")) end)
end
if ch then pcall(function() add(softSigs, ch.ChildAdded) end) end
if LP then pcall(function() add(softSigs, LP.CharacterAdded) end) end
local keepForce = AC._forceConnSignals
AC._forceConnSignals = true
for i = 1, #hardSigs do AC.disableSignalConns(hardSigs[i], force ~= false, out) end
AC._forceConnSignals = false
for i = 1, #stateSigs do AC.disableSignalConns(stateSigs[i], false, out) end
for i = 1, #softSigs do AC.disableSignalConns(softSigs[i], false, out) end
if not force then
for _gi, obj in ipairs(F.GuardedGetGC(true, true)) do
if not F.gcTick(_gi) then break end
if typeof(obj) == "RBXScriptSignal" then AC.disableSignalConns(obj, false, out) end
end
end
AC._forceConnSignals = keepForce
F._scavenging = keepScav
AC._connDisabled = AC._connDisabled + out.disabled
F.Out(string.format("[CheatMenu] 连接清理: 扫描 %d 条, 禁用 %d 条(每一条都打了日志; 想全部还原就点「一键全关」或「卸载脚本」)",
out.scanned, out.disabled))
return out.disabled, out.scanned
end
function AC.ReenableDisabledConns()
local n = 0
local list = AC._disabledConns or {}
for i = 1, #list do
local c = list[i]
if c and pcall(function() if c.Enable then c:Enable() end end) then n = n + 1 end
end
AC._disabledConns = {}
if n > 0 then F.Out("[连接清理] 已还原 " .. tostring(n) .. " 条之前被我们禁用的游戏连接") end
return n
end
AC._antiTPOld = nil
function AC.InstallAntiTP()
if AC._antiTPOld then return true end
if not hookfunction then return false end
local ts = game:GetService("TeleportService")
local old
local wrapper = function(self, placeId, player, ...)
if not checkcaller() and not (T.KickRejoin and placeId == game.PlaceId) then
return nil
end
return old(self, placeId, player, ...)
end
local ok, res = pcall(function()
if newcclosure then return hookfunction(ts.Teleport, newcclosure(wrapper)) else return hookfunction(ts.Teleport, wrapper) end
end)
if ok and type(res) == "function" then
old = res
AC._antiTPOld = res
return true
end
return false
end
function AC.UninstallAntiTP()
if AC._antiTPOld and hookfunction then
pcall(function() hookfunction(game:GetService("TeleportService").Teleport, AC._antiTPOld) end)
end
AC._antiTPOld = nil
end
AC._noPauseConn = nil
function AC.AntiPauseEnable()
if AC._noPauseConn then return end
local rg = nil
pcall(function()
rg = CoreGui and (CoreGui.RobloxGui or CoreGui:FindFirstChild("RobloxGui"))
end)
if not rg then
F.Out("[CheatMenu] 防暂停: 当前容器里没有 RobloxGui, 本项跳过(不影响其它功能)")
return
end
AC._noPauseConn = rg.ChildAdded:Connect(function(obj)
if obj.Name == "CoreScripts/NetworkPause" then pcall(function() obj:Destroy() end) end
end)
end
function AC.AntiPauseDisable()
if AC._noPauseConn then AC._noPauseConn:Disconnect() AC._noPauseConn = nil end
end
AC.TrapDisable = { data = {}, conn = nil }
function AC.TrapDisable.isName(s)
local n = tostring(s):lower()
return n:find("trap") or n:find("mine") or n:find("spike") or n:find("sentry")
end
function AC.TrapDisable.part(p)
if not (p:IsA("BasePart") and p.Parent) then return end
if AC.TrapDisable.data[p] ~= nil then return end
AC.TrapDisable.data[p] = p.CanTouch
p.CanTouch = false
end
function AC.TrapDisable.scan()
pcall(AC.TrapDisable.Compact)
local n, nScan = 0, 0
for _, v in ipairs(F.walk(workspace)) do
nScan = nScan + 1
if nScan > 20000 then break end
if v:IsA("BasePart") and AC.TrapDisable.isName(v.Name) then AC.TrapDisable.part(v) n = n + 1 end
end
return n
end
function AC.TrapDisable.Enable()
if AC.TrapDisable.conn then return end
AC.TrapDisable.scan()
AC.TrapDisable.conn = workspace.DescendantAdded:Connect(function(v)
if v:IsA("BasePart") and AC.TrapDisable.isName(v.Name) then AC.TrapDisable.part(v) end
end)
end
function AC.TrapDisable.Compact()
local n = 0
for p in pairs(AC.TrapDisable.data) do
if not (typeof(p) == "Instance" and p.Parent) then AC.TrapDisable.data[p] = nil n = n + 1 end
end
return n
end
function AC.TrapDisable.Disable()
if AC.TrapDisable.conn then AC.TrapDisable.conn:Disconnect() AC.TrapDisable.conn = nil end
for p, orig in pairs(AC.TrapDisable.data) do
if p and p.Parent then pcall(function() p.CanTouch = orig end) end
end
AC.TrapDisable.data = {}
end
function F.gcTick(i)
local L = F.LIMITS
if i > L.SCAN_GC_CAP then return false end
if i % L.SCAN_YIELD_EVERY == 0 then task.wait() end
return true
end
function F.walk(root, cap, budget)
if root == nil then return {} end
local out, queue, qi, n = {}, { root }, 1, 0
cap = tonumber(cap) or 40000
local every = tonumber(budget) or 300
while qi <= #queue and n < cap do
local node = queue[qi]
qi = qi + 1
local ok, kids = pcall(function() return node:GetChildren() end)
if ok and type(kids) == "table" then
for i = 1, #kids do
n = n + 1
out[#out + 1] = kids[i]
queue[#queue + 1] = kids[i]
if n % every == 0 then pcall(task.wait) end
if n >= cap then break end
end
end
end
if n >= cap then pcall(function() F.Out("[遍历] 达到上限 " .. tostring(cap) .. " 个, 结果可能不完整") end) end
return out
end
function F.GuardedGetGC(pass, force)
local now = os.clock()
if not force and (now - (F._lastGetGC or 0) < 2) then return {} end
F._lastGetGC = now
if type(getgc) ~= "function" then return {} end
local ok, r = pcall(getgc, pass)
return (ok and type(r) == "table") and r or {}
end
F._scavenging = false
F._stealthHooked = setmetatable({}, { __mode = "k" })
function F.stealthHook(obj, wrapperFactory)
if type(obj) ~= "function" then return nil end
if F._stealthHooked[obj] then return nil end
if not (hookfunction and newcclosure) then return nil end
local box = { orig = nil }
local wrapper = wrapperFactory(box)
local ok, res = pcall(function() return hookfunction(obj, newcclosure(wrapper)) end)
if ok and type(res) == "function" then
box.orig = res
F._stealthHooked[obj] = true
return res
end
return nil
end
function F.markOwnClosures()
if type(getgc) ~= "function" then return 0 end
local mine = AC.selfSrc()
if not (mine and mine ~= "") then return 0 end
local keep = F._scavenging
F._scavenging = true
local n, seen = 0, 0
for _gi, obj in ipairs(F.GuardedGetGC(true, true)) do
if not F.gcTick(_gi) then break end
seen = seen + 1
if seen > 30000 then break end
if type(obj) == "function" and (not islclosure or islclosure(obj)) then
local ok, info = pcall(debug.getinfo, obj, "s")
if ok and info and info.source == mine then
AC._ownFns[obj] = true
n = n + 1
end
end
end
F._scavenging = keep
return n
end
function AC.FindFn(name, wantAll)
if type(name) ~= "string" or name == "" then return nil end
local out = {}
if type(filtergc) == "function" then
local ok, r = pcall(filtergc, "function", { Name = name }, true)
if ok and type(r) == "table" then
for i = 1, #r do out[#out + 1] = r[i] end
elseif ok and type(r) == "function" then
out[1] = r
end
end
if #out == 0 and type(getgc) == "function" then
local keepScav = F._scavenging
F._scavenging = true
for _, f in ipairs(F.GuardedGetGC(true, true)) do
if type(f) == "function" and (not islclosure or islclosure(f)) then
local oki, info = pcall(debug.getinfo, f, "n")
if oki and info and info.name == name then out[#out + 1] = f end
end
end
F._scavenging = keepScav
end
if #out == 0 then return nil, nil end
if wantAll then return out[1], out end
return out[1], out
end
AC.cap = function(name)
if type(name) ~= "string" or name == "" then return nil end
local tries = {
function()
if type(getgenv) ~= "function" then return nil end
local ok, g = pcall(getgenv)
return (ok and type(g) == "table") and g[name] or nil
end,
function()
if type(getfenv) ~= "function" then return nil end
local ok, e = pcall(getfenv)
return (ok and type(e) == "table") and e[name] or nil
end,
function() return rawget(_G, name) end,
}
for i = 1, #tries do
local ok, v = pcall(tries[i])
if ok and v ~= nil then return v end
end
return nil
end
AC.cloneref = function(obj)
local cr = AC.cap("cloneref")
if type(cr) == "function" then
local ok, r = pcall(cr, obj)
if ok and r ~= nil then return r end
end
return obj
end
AC.svc = function(name)
return AC.cloneref(game:GetService(name))
end
AC.AC_TABLE_KEYS = {
"Detected", "RLocked", "detected", "Detect", "AntiCheat", "ACDetected", "Flag", "Punish",
}
AC.NeutralizeTable = function(t, cap)
if type(t) ~= "table" then return 0 end
if AC._neutTables[t] then return 0 end
AC._neutTables[t] = true
local n, lim = 0, tonumber(cap) or 64
for k, v in pairs(t) do
if n >= lim then break end
if type(v) == "function" and not AC._hookedFns[v] then
local got = F.stealthHook(v, function(box) return function() return nil end end)
if got then
AC.markHooked(v)
AC._neutFns[#AC._neutFns + 1] = { key = tostring(k), fn = v }
n = n + 1
end
end
end
return n
end
AC._neutTables = setmetatable({}, { __mode = "k" })
AC._neutFns = {}
function AC.isACTable(t)
if type(t) ~= "table" then return nil end
for i = 1, #AC.AC_TABLE_KEYS do
local k = AC.AC_TABLE_KEYS[i]
local ok, v = pcall(rawget, t, k)
if ok and v ~= nil then return k end
end
return nil
end
F.CAP_LIST = {
{ "getgc", "扫描 GC 对象 —— 整个扫描模块的地基" },
{ "filtergc", "按名一步定位函数(反作弊中和强烈依赖)" },
{ "getconnections", "断反作弊监听 / 改写游戏自己的回调" },
{ "getnilinstances", "扫隐藏实例(反作弊藏 remote 的常用手法)" },
{ "getinstances", "扫**完全不在 DataModel 里**的游离实例(比 nil 更隐蔽)" },
{ "decompile", "反编译脚本源码(读可疑脚本用)" },
{ "getreg", "读注册表(找被隐藏的模块)" },
{ "getloadedmodules", "列出已加载模块" },
{ "hookfunction", "hook 具名函数 / 中和反作弊检测函数" },
{ "hookmetamethod", "拦 __namecall / __index / __newindex" },
{ "newcclosure", "把我们的 hook 伪装成 C 闭包" },
{ "getnamecallmethod", "缺它就拦不到 Kick / FireServer" },
{ "getrawmetatable", "直接读写元表" },
{ "setreadonly", "解锁只读表" },
{ "islclosure", "区分 Lua 闭包与 C 函数" },
{ "checkcaller", "区分「游戏调用」与「自己调用」" },
{ "getrenv", "拿游戏侧环境副本(读游戏里的表/函数)" },
{ "cloneref", "安全取服务引用" },
{ "getthreadidentity", "线程身份伪装" },
{ "setupvalue", "原地改 upvalue(零 hook 指纹)" },
{ "fireproximityprompt", "直接触发交互" },
{ "sethiddenproperty", "写隐藏属性" },
{ "request", "HTTP 请求" },
{ "Drawing", "Drawing API(高性能 2D 绘制)" },
}
function F.capProbe(name)
if type(name) ~= "string" then return false end
if name:find(".", 1, true) then
local a, b = name:match("^([%w_]+)%.([%w_]+)$")
if not a then return false end
local holder = AC.cap(a)
return type(holder) == "table" and type(holder[b]) == "function"
end
local v = AC.cap(name)
if name == "request" and v == nil then
local syn = AC.cap("syn")
if type(syn) == "table" then v = syn.request end
end
return v ~= nil
end
function F.ProbeCapabilities(verbose)
local res, okN, miss = {}, 0, {}
local extra = { "debug.getinfo", "debug.getconstants", "debug.getupvalues" }
for i = 1, #extra do
local has = F.capProbe(extra[i])
res[extra[i]] = has
if has then okN = okN + 1 else miss[#miss + 1] = extra[i] end
end
for i = 1, #F.CAP_LIST do
local name = F.CAP_LIST[i][1]
local has = F.capProbe(name)
res[name] = has
if has then okN = okN + 1 else miss[#miss + 1] = name end
end
F._caps = res
local total = #F.CAP_LIST + #extra
if verbose ~= false then
F.Out(string.format("[能力探测] 可用 %d/%d", okN, total))
for i = 1, #F.CAP_LIST do
local name, desc = F.CAP_LIST[i][1], F.CAP_LIST[i][2]
F.Out(string.format("  %s %-20s %s", res[name] and "✓" or "✗", name, desc))
end
F.Out(string.format("  %s %-20s %s", res["debug.getinfo"] and "✓" or "✗", "debug.getinfo", "读闭包元数据"))
F.Out(string.format("  %s %-20s %s", res["debug.getconstants"] and "✓" or "✗", "debug.getconstants", "读闭包常量(关键词定位)"))
F.Out(string.format("  %s %-20s %s", res["debug.getupvalues"] and "✓" or "✗", "debug.getupvalues", "读闭包 upvalue"))
if #miss > 0 then
F.Out("[能力探测] ⚠ 缺失: " .. table.concat(miss, ", ") .. " —— 相关功能会自动降级, 不是「没扫到」")
end
end
return res, okN, total
end
F.AC_INVISIBLE = {
"服务器脚本源码(ServerScriptService / ServerStorage 不下发到客户端)",
"服务端判定逻辑与阈值(在服务端跑, 客户端不可见)",
"Roblox 自带反作弊 Hyperion(原生二进制, 非 Lua)",
"服务端玩家的真实位置/速度(只得到复制后的结果)",
}
function F.EnvSelfCheck()
task.spawn(function()
local caps = {
{ n = "loadstring", f = function() return type(loadstring) == "function" end, need = "热加载 / 按文本加载" },
{ n = "load", f = function() return type(load) == "function" end, need = "loadstring 的兜底(二选一即可)" },
{ n = "readfile/writefile", f = function() return type(readfile) == "function" and type(writefile) == "function" end, need = "配置存档 / 翻译缓存 / 日志落盘" },
{ n = "gethui", f = function() return type(gethui) == "function" end, need = "界面挂到隐蔽容器(缺了退 CoreGui, 不影响显示)" },
{ n = "hookmetamethod", f = function() return type(hookmetamethod) == "function" end, need = "反作弊拦截 / remote 采集 / 属性读回伪装" },
{ n = "newcclosure", f = function() return type(newcclosure) == "function" end, need = "同上(钩子要包成 C 闭包)" },
{ n = "getrawmetatable", f = function() return type(getrawmetatable) == "function" end, need = "同上" },
{ n = "getgc", f = function() return type(getgc) == "function" end, need = "GC 扫描 / 自动分析" },
{ n = "getconnections", f = function() return type(getconnections) == "function" end, need = "连接清理 / 监听扫描" },
{ n = "getnamecallmethod", f = function() return type(getnamecallmethod) == "function" end, need = "namecall 钩子判方法" },
{ n = "debug.getinfo", f = function() return debug ~= nil and type(debug.getinfo) == "function" end, need = "来源比对 / 自身识别" },
{ n = "debug.getconstants", f = function() return debug ~= nil and type(debug.getconstants) == "function" end, need = "按常量找函数 / 阈值提取" },
{ n = "filtergc", f = function() return type(filtergc) == "function" end, need = "按名/按常量定位(可选, 缺了自动走全扫)" },
}
local okN, miss = 0, {}
for _, c in ipairs(caps) do
local ok = false
pcall(function() ok = (c.f() == true) end)
if ok then okN = okN + 1 else miss[#miss + 1] = c end
end
local plat = UIS.TouchEnabled and "触屏(手机/平板)" or "键鼠(PC)"
local vp = "?"
pcall(function()
local c = workspace.CurrentCamera
if c then vp = c.ViewportSize.X .. "x" .. c.ViewportSize.Y end
end)
local host, gui = "?", "未创建"
pcall(function() host = tostring(gethui and gethui() or game:GetService("CoreGui")) end)
pcall(function() if Fluent and Fluent.GUI and Fluent.GUI.Parent then gui = "已创建" end end)
F.Out(string.format("[自检] 执行器能力 %d/%d · 平台=%s · 视口=%s · 菜单=%s · 宿主=%s",
okN, #caps, plat, vp, gui, host))
for _, c in ipairs(miss) do
F.Out("[自检]   ✗ 缺 " .. c.n .. " ⇒ 受影响: " .. c.need)
end
local names = {}
for i = 1, #miss do names[i] = miss[i].n end
local verdict = (#miss == 0)
and "环境完好 —— 若仍看不到界面, 按 G 呼出 / 点屏幕上那个小按钮"
or ("缺 " .. #miss .. " 项: " .. table.concat(names, ", ") .. " —— 只有依赖它们的子功能无效, 其余照常")
F.Out("[自检] 结论: " .. verdict)
if Fluent and Fluent.Notify then
Fluent:Notify({
Title = "环境自检",
Content = string.format("能力 %d/%d · %s · 菜单:%s", okN, #caps, plat, gui) .. "\n" .. verdict,
Duration = 16,
})
end
pcall(F.LogFlush, "环境自检")
end)
end
function F.SnapshotCollect()
local snap = { t = os.time(), remotes = {}, acfns = {}, hidden = {}, attrs = {}, scripthashes = {},
caps = {}, authority = nil }
local keepScav = F._scavenging
F._scavenging = true
pcall(function() snap.authority = tostring(workspace.AuthorityMode) end)
pcall(function()
local seen = {}
local function add(obj, src)
local cls = AC.isRemoteLike(obj)
if not cls then return end
local nm = tostring(obj.Name)
local key = cls .. "\0" .. nm
if seen[key] then seen[key].src = seen[key].src .. "," .. src return end
seen[key] = { n = nm, c = cls, src = src, s = AC.isSuspicious(nm) and 1 or 0,
down = (obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent")) and 1 or 0 }
end
for _, d in ipairs(F.walk(RStorage)) do add(d, "RS") end
if type(getnilinstances) == "function" then
for _gi, inst in ipairs(getnilinstances()) do if not F.gcTick(_gi) then break end add(inst, "nil") end
end
for _, v in pairs(seen) do snap.remotes[#snap.remotes + 1] = v end
table.sort(snap.remotes, function(a, b) return a.n < b.n end)
end)
pcall(function()
if type(getgc) ~= "function" then return end
local seen, n = {}, 0
for _gi, obj in ipairs(F.GuardedGetGC(true, true)) do
if not F.gcTick(_gi) then break end
n = n + 1
if n > 60000 then break end
if type(obj) == "function" and (not islclosure or islclosure(obj)) then
local oki, info = pcall(debug.getinfo, obj, "nS")
local nm = (oki and info and info.name) or ""
local src = (oki and info and info.source) or ""
local hit = AC.isSuspicious(nm) or AC.isSuspicious(src)
if not hit then
local okc, consts = pcall(dbgGetConstants, obj)
if okc and type(consts) == "table" then
for i = 1, #consts do
if type(consts[i]) == "string" and AC.isSuspicious(consts[i]) then hit = true break end
end
end
end
if hit then
local k = tostring(nm) .. "@" .. tostring(src)
if not seen[k] then
seen[k] = true
snap.acfns[#snap.acfns + 1] = { f = tostring(nm), s = tostring(src) }
end
end
end
end
table.sort(snap.acfns, function(a, b) return a.f < b.f end)
end)
pcall(function()
local cnt = {}
local roots = { workspace, LP, RStorage }
for i = 1, #roots do
local r = roots[i]
if r then
local bag = { r }
local nAttr = 0
for _, d in ipairs(F.walk(r)) do bag[#bag + 1] = d end
for j = 1, #bag do
nAttr = nAttr + 1
if nAttr > 12000 then break end
local okA, attrs = pcall(function() return bag[j]:GetAttributes() end)
if okA and type(attrs) == "table" then
for k in pairs(attrs) do cnt[tostring(k)] = (cnt[tostring(k)] or 0) + 1 end
end
end
end
end
for k, v in pairs(cnt) do snap.attrs[#snap.attrs + 1] = { k = k, n = v } end
table.sort(snap.attrs, function(a, b) return a.k < b.k end)
end)
pcall(function()
local hasher = AC.cap("getscripthash")
if type(hasher) ~= "function" then return end
if type(getloadedmodules) ~= "function" then return end
local ok, mods = pcall(getloadedmodules)
if not ok or type(mods) ~= "table" then return end
for i = 1, #mods do
local m = mods[i]
if typeof(m) == "Instance" then
local okH, h = pcall(hasher, m)
if okH and h ~= nil then
snap.scripthashes[#snap.scripthashes + 1] = { p = m:GetFullName(), h = tostring(h) }
end
end
end
end)
F._scavenging = keepScav
snap.caps = F._caps or select(1, F.ProbeCapabilities(false))
return snap
end
F._capOn = false
F._capLog = {}
F.CAP_MAX = F.LIMITS.CAPTURE_MAX
function F.CaptureEnable()
if F._capOn then return true end
if not (hookmetamethod and newcclosure and getnamecallmethod) then return false end
F._capLog = {}
local got = F.MetaInstall("__namecall", game, "Capture", function(box)
return function(self, ...)
if F._capOn and not checkcaller() and typeof(self) == "Instance" then
local m = getnamecallmethod()
if m == "FireServer" or m == "InvokeServer" then
if #F._capLog < F.CAP_MAX then
local args = { ... }
local parts = {}
local top = math.min(#args, 6)
for i = 1, top do
local v = args[i]
local t = typeof(v)
if t == "Instance" then
parts[i] = v.ClassName .. ":" .. tostring(v.Name)
elseif t == "Vector3" then
parts[i] = string.format("V3(%.1f,%.1f,%.1f)", v.X, v.Y, v.Z)
elseif t == "string" then
parts[i] = (#v > 60) and (v:sub(1, 60) .. "...") or v
elseif t == "table" then
parts[i] = "{n=" .. tostring(#v) .. "}"
elseif t == "CFrame" then
parts[i] = string.format("CF(%.1f,%.1f,%.1f)", v.X, v.Y, v.Z)
else
parts[i] = tostring(v)
end
end
F._capLog[#F._capLog + 1] = {
n = tostring(self.Name), c = tostring(self.ClassName),
m = m, a = table.concat(parts, ", "),
}
if #F._capLog % 10 == 0 then
F.Out("[采集] 已记录 " .. #F._capLog .. " 条上行 remote, 最近: " .. tostring(self.Name) .. ":" .. tostring(m))
end
end
end
end
return box.orig(self, ...)
end
end)
if not got then
F._capOn = false
return false
end
F._capOn = true
F._capLayer = got
F.Out("[采集] 已开始记录 remote 上行调用(上限 " .. F.CAP_MAX .. " 条)")
F.Out("[采集] 现在**正常玩一会儿**(建议 5-10 分钟: 卖东西/买东西/踢方块/被检测的操作都做一遍)")
F.Out("[采集] 玩完点「复制扫描结果」, 内容会复制到剪贴板, 直接粘给我即可")
return true
end
function F.CaptureDisable()
if not F._capOn then return 0 end
F.MetaUninstall("__namecall", "Capture")
F._capOn = false
F._capLayer = nil
F.Out("[采集] 已停止, 本次记录 " .. #F._capLog .. " 条")
return #F._capLog
end
function F.DumpAll()
local snap = F.SnapshotCollect()
local lines = {}
local function w(s) lines[#lines + 1] = s end
w("===== CheatMenu 客户端反作弊面全量导出 =====")
w(string.format("时间: %s   版本字面量: 见 SubTitle", os.date("%Y-%m-%d %H:%M:%S")))
local okP, pid = pcall(function() return game.PlaceId end)
w("PlaceId: " .. tostring(okP and pid or "?"))
local okJ, jid = pcall(function() return game.JobId end)
w("JobId: " .. tostring(okJ and jid or "?"))
w("AuthorityMode: " .. tostring(snap.authority or "(无此字段)"))
local cok, ctot = 0, 0
for _, v in pairs(snap.caps or {}) do ctot = ctot + 1 if v then cok = cok + 1 end end
w("执行器能力: " .. cok .. "/" .. ctot)
local missCaps = {}
for k, v in pairs(snap.caps or {}) do if not v then missCaps[#missCaps + 1] = k end end
if #missCaps > 0 then w("  缺失: " .. table.concat(missCaps, ", ")) end
w("")
w("--- [1] 远程面(名称 | 类别 | 名字可疑 | 可下行 | 来源) ---")
w("共 " .. #snap.remotes .. " 个")
for i = 1, #snap.remotes do
local r = snap.remotes[i]
w(string.format("  %s | %s | %s | %s | %s", r.n, r.c,
r.s == 1 and "可疑" or "-", r.down == 1 and "是" or "否", r.src))
end
w("")
w("--- [2] 客户端侧反作弊函数碎片(函数名 @ 来源) ---")
w("共 " .. #snap.acfns .. " 个")
for i = 1, #snap.acfns do w("  " .. snap.acfns[i].f .. " @ " .. snap.acfns[i].s) end
w("")
w("--- [3] 属性(名称 | 出现次数 | 样例值) ---")
local attrSamples = {}
pcall(function()
local roots = { workspace, LP, RStorage }
local seen = {}
for i = 1, #roots do
local r = roots[i]
if r then
local bag = { r }
local nA = 0
for _, d in ipairs(F.walk(r)) do bag[#bag + 1] = d end
for j = 1, #bag do
nA = nA + 1
if nA > 12000 then break end
local okA, attrs = pcall(function() return bag[j]:GetAttributes() end)
if okA and type(attrs) == "table" then
for k, v in pairs(attrs) do
local key = tostring(k)
if not attrSamples[key] then
local sv = tostring(v)
if #sv > 40 then sv = sv:sub(1, 40) .. "..." end
attrSamples[key] = sv
end
end
end
end
end
end
end)
w("共 " .. #snap.attrs .. " 种")
for i = 1, #snap.attrs do
local a = snap.attrs[i]
w(string.format("  %s | x%d | %s", a.k, a.n, tostring(attrSamples[a.k] or "-")))
end
w("")
w("--- [4] 客户端脚本指纹(getscripthash) ---")
w("共 " .. #snap.scripthashes .. " 个")
for i = 1, #snap.scripthashes do
local h = snap.scripthashes[i]
w("  " .. tostring(h.h) .. "  " .. tostring(h.p))
end
w("")
w("--- [5] remote 上行采集(客户端实际发出去的参数 = 服务端的输入面) ---")
w("共 " .. #F._capLog .. " 条")
for i = 1, #F._capLog do
local c = F._capLog[i]
w(string.format("  %s [%s] %s(%s)", c.n, c.c, c.m, c.a))
end
w("")
w("--- [6] 不可见边界(原理上拿不到, 与本脚本无关) ---")
for i = 1, #F.AC_INVISIBLE do w("  " .. F.AC_INVISIBLE[i]) end
w("")
w("===== 导出结束 =====")
local text = table.concat(lines, "\n")
local wrote = false
pcall(function() writefile("CheatMenu_Capture.txt", text) wrote = true end)
local copied = false
pcall(function()
local sc = AC.cap("setclipboard")
if type(sc) == "function" then sc(text) copied = true return end
if syn and syn.clipboard and type(syn.clipboard.set) == "function" then
syn.clipboard.set(text) copied = true return
end
if type(toclipboard) == "function" then toclipboard(text) copied = true return end
if type(write_clipboard) == "function" then write_clipboard(text) copied = true end
end)
F.Out("══════ 全量导出 ══════")
F.Out("  长度 " .. #text .. " 字符 · 写文件 " .. (wrote and "成功(CheatMenu_Capture.txt)" or "失败") ..
" · 复制剪贴板 " .. (copied and "成功(直接粘给我)" or "失败(手动从 F9 复制)"))
F.Out("  内容: 远程 " .. #snap.remotes .. " · 反作弊碎片 " .. #snap.acfns ..
" · 属性 " .. #snap.attrs .. " 种 · 脚本指纹 " .. #snap.scripthashes ..
" · 上行采集 " .. #F._capLog .. " 条")
F.Out("  ⚠ 服务端判定逻辑不在其中(原理上不可见), 但上面的[5]是服务端判定的**输入面**。")
if not copied then
F.Out("────── 以下为可复制正文 ──────")
F.Out(text)
F.Out("────── 正文结束 ──────")
end
F._dumpText = text
return text
end
F.LOG_MAX = 1500000
F.LOG_BUF_MAX = 300
F._logBuf = F._logBuf or {}
function F.LogBaseName()
if F._logBaseName then return F._logBaseName end
local gname = "Unknown"
pcall(function()
local ok, n = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
if ok and type(n) == "string" and n ~= "" then gname = n end
end)
if gname == "Unknown" then
pcall(function() if game.PlaceId then gname = "Place" .. tostring(game.PlaceId) end end)
end
gname = tostring(gname):gsub('[\\/:*?"<>|]', "_"):gsub("%s+", "_")
if #gname > 40 then gname = gname:sub(1, 40) end
local pid = "?"
pcall(function() pid = tostring(game.PlaceId) end)
gname = tostring(gname):gsub("[^%w_%-]", "_"):gsub("_+", "_")
if not gname:match("[%w]") then gname = "game" end
if #gname > 24 then gname = gname:sub(1, 24) end
pcall(function()
if type(isfolder) == "function" and type(makefolder) == "function" then
if not isfolder("CheatMenu_Logs") then makefolder("CheatMenu_Logs") end
end
end)
F._logBaseName = string.format("CheatMenu_Logs/CheatMenu_log_%s_%s", gname, pid)
return F._logBaseName
end
function F.LogFlush(tag)
if #F._logBuf == 0 then return nil end
if F._logFlushing then return nil end
F._logFlushing = true
local ts = os.date("%Y-%m-%d %H:%M:%S")
local body = "[" .. ts .. "] " .. table.concat(F._logBuf, "\n") .. "\n"
local pending = F._logBuf
F._logBuf = {}
local base = F.LogBaseName()
local okWrite = false
local usedName = nil
local hasRW = false
pcall(function() hasRW = (type(writefile) == "function" and type(readfile) == "function") end)
if not hasRW then
F.Out("[日志] ⚠ 执行器不支持 readfile/writefile, 内容只留在 F9 控制台(点「复制扫描结果」可复制)")
F._logFlushing = false
return nil
end
local targetIdx = nil
for idx = 1, 20 do
local nm = (idx == 1) and (base .. ".txt") or string.format("%s_%d.txt", base, idx)
local sz = nil
pcall(function() if isfile and isfile(nm) then sz = #readfile(nm) end end)
if sz == nil or sz + #body <= F.LOG_MAX then
targetIdx = idx
break
end
end
if not targetIdx then
if delfile then pcall(delfile, base .. ".txt") end
targetIdx = 1
end
local name = (targetIdx == 1) and (base .. ".txt") or string.format("%s_%d.txt", base, targetIdx)
local existed, size = false, 0
pcall(function()
if isfile and isfile(name) then
existed = true
size = #readfile(name)
end
end)
local ok = pcall(function()
local old = ""
if existed and size + #body <= F.LOG_MAX then
local oks = pcall(function() old = readfile(name) end)
if not oks then old = "" end
end
writefile(name, old .. body)
end)
if ok then
okWrite = true
usedName = name
F.Out(string.format("[日志] %s 已写入 %s (%d 字节, 本次追加 %d 字符)", tostring(tag or ""), name, size + #body, #body))
end
if not okWrite then
F._logBuf = pending
F.Out("[日志] ⚠ 写入失败(可能磁盘只读或路径不允许), 内容已留在缓冲, 可稍后重试")
end
F._logFlushing = false
return usedName, #body
end
function F.LogDump(text, tag)
if type(text) == "string" and #text > 0 then
F._logBuf[#F._logBuf + 1] = text
end
return F.LogFlush(tag)
end
function F.UnifiedACPass()
if F._unifiedRunning then return 0 end
F._unifiedRunning = true
local keepScav = F._scavenging
F._scavenging = true
local blocked, hooked, cleared, spoofed = 0, 0, 0, 0
local keysAC = { "anticheat", "anti-cheat", "detected", "exploit", "cheat", "ban", "iac", "reportabuse", "flag" }
local keysLog = { "threat", "violation", "flag", "warn", "detect", "suspect", "ban", "kick", "log", "strike", "offense", "infraction" }
local keysTel = { "telemetry", "report", "upload", "ping", "heartbeat" }
pcall(function()
if type(getnilinstances) == "function" then
for _gi, inst in ipairs(getnilinstances()) do if not F.gcTick(_gi) then break end
if typeof(inst) == "Instance" then AC.hookOneRemote(inst) end
end
end
for _, d in ipairs(F.walk(RStorage)) do
if AC.isRemoteLike(d) then AC.hookOneRemote(d) end
end
if type(getgc) ~= "function" then return end
local seen = 0
for _gi, obj in ipairs(F.GuardedGetGC(true, true)) do
if not F.gcTick(_gi) then break end
seen = seen + 1
if seen > 8000 then break end
if seen % 250 == 0 then task.wait() end
if typeof(obj) == "Instance" then
AC.hookOneRemote(obj)
elseif typeof(obj) == "table" then
local marker = AC.isACTable(obj)
if marker and hookfunction then
local got = AC.NeutralizeTable(obj)
if got > 0 then
hooked = hooked + got
F.Out(string.format("[CheatMenu] 检测表中和(指纹 %s): %d 个成员函数", marker, got))
end
end
local killfunc = rawget(obj, "Kill")
if killfunc and type(killfunc) == "function" and rawget(obj, "Variables") and rawget(obj, "Process") then
local got2 = F.stealthHook(killfunc, function(box) return function() end end)
if got2 then AC.markHooked(killfunc) hooked = hooked + 1 end
end
local hitLog = false
local n = rawget(obj, "Name") or rawget(obj, "name")
if type(n) == "string" then
for i = 1, #keysLog do
if n:lower():find(keysLog[i], 1, true) then hitLog = true break end
end
end
if hitLog then
for k, v in pairs(obj) do
if type(v) == "number" then pcall(rawset, obj, k, 0) end
if type(v) == "table" then pcall(table.clear, v) end
end
cleared = cleared + 1
end
elseif type(obj) == "function" and islclosure and islclosure(obj) then
local already = false
pcall(function() if isfunctionhooked and isfunctionhooked(obj) then already = true end end)
if not already and hookfunction then
local okc, consts = pcall(dbgGetConstants, obj)
if okc and consts then
local hitAC, hitTel = false, false
for _, c in ipairs(consts) do
if type(c) == "string" then
local cl = c:lower()
for i = 1, #keysAC do
if cl:find(keysAC[i], 1, true) then hitAC = true break end
end
if not hitAC then
for i = 1, #keysTel do
if cl:find(keysTel[i], 1, true) then hitTel = true break end
end
end
end
if hitAC or hitTel then break end
end
if hitAC then
local got = F.stealthHook(obj, function(box) return function() return nil end end)
if got then AC.markHooked(obj) hooked = hooked + 1 end
elseif hitTel then
local got = F.stealthHook(obj, function(box) return function(...) return true end end)
if got then AC.markHooked(obj) spoofed = spoofed + 1 end
end
end
end
end
end
blocked = AC.HookedCount
end)
F._unifiedRunning = false
F._scavenging = keepScav
F.Out(string.format("[CheatMenu] 统一扫描 · Hook层数=%d 中和=%d 清日志=%d 伪造遥测=%d", blocked, hooked, cleared, spoofed))
return blocked
end
function F.ScanRemotes()
local keepScav = F._scavenging
F._scavenging = true
local found, order = {}, {}
local function addRemote(obj, src)
if typeof(obj) ~= "Instance" then return end
local cls = AC.isRemoteLike(obj)
if not cls then return end
local name = tostring(obj.Name)
local key = cls .. "\0" .. name
if not found[key] then
found[key] = { name = name, class = cls, srcs = {}, suspicious = AC.isSuspicious(name) }
order[#order + 1] = key
end
found[key].srcs[src] = true
end
pcall(function() for _, d in ipairs(F.walk(RStorage)) do addRemote(d, "RS") end end)
pcall(function()
local cloned = AC.svc("ReplicatedStorage")
if cloned and cloned ~= RStorage then
for _, d in ipairs(F.walk(cloned)) do addRemote(d, "RS-clone") end
end
end)
if type(getnilinstances) == "function" then
pcall(function()
local arr = getnilinstances()
for i = 1, #arr do
if i % F.LIMITS.SCAN_YIELD_EVERY == 0 then task.wait() end
if i > F.LIMITS.SCAN_GC_CAP then break end
addRemote(arr[i], "nil")
end
end)
end
if type(getgc) == "function" then
pcall(function()
local seen = 0
for _gi, obj in ipairs(F.GuardedGetGC(true, true)) do
if not F.gcTick(_gi) then break end
seen = seen + 1
if seen > 8000 then break end
if seen % 200 == 0 then task.wait() end
if typeof(obj) == "Instance" then addRemote(obj, "gc")
elseif type(obj) == "function" and islclosure and islclosure(obj) then
for i = 1, 40 do
local ok2, uname, v = pcall(debug.getupvalue, obj, i)
if not ok2 or not uname then break end
addRemote(v, "gc-up")
end
end
end
end)
end
local total, susCount = 0, 0
F.Out("[抓包] ===== 深度抓包结果 =====")
for _, key in ipairs(order) do
local it = found[key]
total = total + 1
if it.suspicious then susCount = susCount + 1 end
F.Out(string.format("[抓包] %s [%s] %s", it.suspicious and "可疑" or " 普通", it.class, it.name))
end
F.Out(string.format("[抓包] 共 %d 个远程，可疑 %d 个", total, susCount))
F._scavenging = keepScav
return susCount
end
function F.ScanGameModules()
local keepScav = F._scavenging
F._scavenging = true
local modCount = 0
F.Out("[模块扫描] ===== 已加载模块 =====")
if type(getloadedmodules) == "function" then
local ok, mods = pcall(getloadedmodules)
if ok and type(mods) == "table" then
for _, m in ipairs(mods) do
if typeof(m) == "Instance" and m:IsA("ModuleScript") then
modCount = modCount + 1
F.Out("[模块扫描] " .. m:GetFullName())
end
end
end
end
local acFunc = 0
pcall(function()
if type(getnilinstances) == "function" then
for _gi, inst in ipairs(getnilinstances()) do if not F.gcTick(_gi) then break end
if typeof(inst) == "Instance" and AC.isSuspicious(inst.Name) then
F.Out("[模块扫描] ⚠ 隐藏实例(nil parent): " .. tostring(inst.ClassName) .. " · " .. tostring(inst.Name))
end
end
end
if type(getgc) ~= "function" then return end
local seen = 0
for _gi, obj in ipairs(F.GuardedGetGC(true, true)) do
if not F.gcTick(_gi) then break end
seen = seen + 1
if seen > 8000 then break end
if seen % 500 == 0 then task.wait() end
if type(obj) == "function" and (not islclosure or islclosure(obj)) then
local oki, info = pcall(debug.getinfo, obj, "nS")
if oki and info then
local nm = info.name or ""
local src = info.source or ""
local mine = F.IsOursSrc(tostring(src):lower()) or F.IsOursSrc(tostring(nm):lower())
local hit = (not mine) and (AC.isSuspicious(nm) or AC.isSuspicious(src))
if not hit then
local okc, consts = pcall(dbgGetConstants, obj)
if okc and type(consts) == "table" then
for i = 1, #consts do
local c = consts[i]
if type(c) == "string" and AC.isSuspicious(c) then hit = true break end
end
end
end
if hit then
acFunc = acFunc + 1
F.Out("[模块扫描] ⚠ 疑似反作弊函数: " .. (nm ~= "" and nm or "(匿名)") .. " @ " .. src)
end
end
end
end
end)
F.Out("[模块扫描] 共 " .. modCount .. " 个 ModuleScript, 疑似反作弊函数 " .. acFunc .. " 个")
F._scavenging = keepScav
return modCount, acFunc
end
F.srcKey = function(fn)
local ok, info = pcall(debug.getinfo, fn, "s")
if ok and info and info.source and info.source ~= "" then return info.source end
return "(未知来源)"
end
F.SCAN_KW = { "anticheat", "anti-cheat", "detected", "exploit", "cheat", "reportabuse", "flag",
"violation", "threat", "suspect", "punish", "strike", "offense", "infraction",
"no-clip", "noclip", "speedhack", "teleport" }
function F.ScanScripts()
local keep = F._scavenging
F._scavenging = true
local byKey, list = {}, {}
local seenInst, seenPath = {}, {}
local n = 0
local function note(inst, tag, where)
if typeof(inst) ~= "Instance" or seenInst[inst] then return end
if not (inst:IsA("ModuleScript") or inst:IsA("LocalScript") or inst:IsA("Script")) then return end
seenInst[inst] = true
local fullName = nil
pcall(function() fullName = inst:GetFullName() end)
if fullName and not seenPath[fullName] then seenPath[fullName] = true n = n + 1 end
local src, hash = "", "?"
pcall(function() src = tostring(inst.Source or "") end)
if type(getscripthash) == "function" then pcall(function() hash = tostring(getscripthash(inst)):sub(1, 12) end) end
local key = (#src > 20) and src:sub(1, 300) or tostring(inst:GetFullName())
local rec = byKey[key]
if not rec then
rec = { src = src, hash = hash, tag = tag, where = where, names = {}, hits = {}, sus = false }
byKey[key] = rec
list[#list + 1] = rec
end
rec.names[#rec.names + 1] = tostring(inst:GetFullName())
local low = src:lower()
for i = 1, #F.SCAN_KW do
if low:find(F.SCAN_KW[i], 1, true) then
rec.sus = true
if #rec.hits < 4 then rec.hits[#rec.hits + 1] = F.SCAN_KW[i] end
end
end
end
F.Out("[脚本扫描] ===== 客户端可见的脚本 / 模块（按源码去重）=====")
if type(getloadedmodules) == "function" then
local ok, mods = pcall(getloadedmodules)
if ok and type(mods) == "table" then
for i = 1, #mods do note(mods[i], "已加载模块", "getloadedmodules") end
end
end
if type(getnilinstances) == "function" then
local ok, arr = pcall(getnilinstances)
if ok and type(arr) == "table" then
for i = 1, #arr do note(arr[i], "隐藏(Parent=nil)", "getnilinstances") end
end
end
if type(getinstances) == "function" then
local ok, arr = pcall(getinstances)
if ok and type(arr) == "table" then
for i = 1, #arr do
if i % F.LIMITS.SCAN_YIELD_EVERY == 0 then task.wait() end
if i > F.LIMITS.SCAN_SCRIPT_CAP then break end
note(arr[i], "游离实例", "getinstances")
end
end
end
local roots = {
{ LP:FindFirstChild("PlayerScripts"), "PlayerScripts" },
{ LP:FindFirstChild("PlayerGui"), "PlayerGui" },
{ game:GetService("ReplicatedFirst"), "ReplicatedFirst" },
{ RStorage, "ReplicatedStorage" },
}
pcall(function() roots[#roots + 1] = { game:GetService("CoreGui"), "CoreGui" } end)
local CAP = F.LIMITS.SCAN_SCRIPT_CAP
for i = 1, #roots do
local r, nm = roots[i][1], roots[i][2]
if n >= CAP then break end
if r then
local ok, kids = pcall(function() return F.walk(r) end)
if ok and kids then
for j = 1, #kids do
note(kids[j], nm, nm)
if n >= CAP then break end
end
end
end
end
if n >= CAP then F.Out("[脚本扫描] ⚠ 达到 " .. tostring(CAP) .. " 个实例上限，提前结束（结果仍按可疑度排序）") end
table.sort(list, function(a, b)
if a.sus ~= b.sus then return a.sus end
return #a.names > #b.names
end)
local susN = 0
for i = 1, #list do
local r = list[i]
if r.sus then susN = susN + 1 end
if r.sus or i <= 40 then
local first = r.src:match("^[^\n]*") or ""
F.Out(string.format("[脚本扫描] %s %s · 实例 %d 个 · hash %s · 出处 %s",
r.sus and "⚠可疑" or "  普通", r.tag, #r.names, r.hash, r.where))
F.Out("[脚本扫描]     名字: " .. table.concat(r.names, ", "):sub(1, 160))
if first ~= "" then F.Out("[脚本扫描]     首行: " .. first:sub(1, 140)) end
if r.sus then F.Out("[脚本扫描]     命中词: " .. table.concat(r.hits, ", ")) end
end
end
F.Out(string.format("[脚本扫描] 共 %d 个脚本实例 → 去重后 %d 份源码, 可疑 %d 份", n, #list, susN))
pcall(function()
local cg = game:GetService("CoreGui")
local kids = cg:GetChildren()
F.Out("[脚本扫描] ===== CoreGui 顶层 (" .. #kids .. ") =====")
for i = 1, #kids do
local k = kids[i]
F.Out("[脚本扫描]   " .. tostring(k.ClassName) .. " · " .. tostring(k.Name))
end
end)
F._scavenging = keep
return #list, susN
end
function F.ScanConnections()
local keep = F._scavenging
F._scavenging = true
local function connInfo(sig, label, pre)
if not label then return end
local conns = pre
if type(conns) ~= "table" then
if type(getconnections) ~= "function" or not sig then return end
local ok, got = pcall(getconnections, sig)
if not ok or type(got) ~= "table" then return end
conns = got
end
if #conns == 0 then return end
local srcs = {}
for i = 1, #conns do
local f = nil
pcall(function() f = conns[i].Function end)
if f then
local s = F.srcKey(f)
srcs[s] = (srcs[s] or 0) + 1
else
srcs["(读不到处理函数)"] = (srcs["(读不到处理函数)"] or 0) + 1
end
end
local parts = {}
for k, v in pairs(srcs) do parts[#parts + 1] = k .. " ×" .. v end
F.Out(string.format("[监听扫描] %-28s 连接 %d 条 · 来源: %s", label, #conns, table.concat(parts, " | "):sub(1, 220)))
end
F.Out("[监听扫描] ===== 远程 / 事件实例（含连接数）=====")
local seen = {}
local function scanRemote(obj, where)
if typeof(obj) ~= "Instance" then return end
local cls = AC.isRemoteLike(obj)
if not cls and (obj:IsA("BindableEvent") or obj:IsA("BindableFunction")) then cls = obj.ClassName end
if not cls then return end
local k = tostring(obj)
if seen[k] then return end
seen[k] = true
local sig = obj
if obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent") then sig = obj.OnClientEvent
elseif obj:IsA("RemoteFunction") then sig = obj.OnClientInvoke
elseif obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then sig = obj.Event end
local ok, conns = pcall(getconnections, sig)
local cnt = (ok and type(conns) == "table") and #conns or -1
local tag = AC.isSuspicious(obj.Name) and "可疑" or "普通"
F.Out(string.format("[监听扫描] %s [%s] %s · %s · 连接 %s", tag, cls, tostring(obj.Name), where,
cnt < 0 and "读不到(无 getconnections)" or tostring(cnt)))
if cnt > 0 then connInfo(sig, "   └ " .. tostring(obj.Name), conns) end
end
local roots = {
{ RStorage, "ReplicatedStorage" },
{ game:GetService("ReplicatedFirst"), "ReplicatedFirst" },
{ workspace, "Workspace" },
}
pcall(function() roots[#roots + 1] = { game:GetService("CoreGui"), "CoreGui" } end)
pcall(function() roots[#roots + 1] = { LP:FindFirstChild("PlayerGui"), "PlayerGui" } end)
for i = 1, #roots do
local r, nm = roots[i][1], roots[i][2]
if r then
local ok, kids = pcall(function() return F.walk(r) end)
if ok and kids then
for j = 1, #kids do
scanRemote(kids[j], nm)
end
end
end
end
if type(getnilinstances) == "function" then
local ok, arr = pcall(getnilinstances)
if ok and type(arr) == "table" then
for i = 1, #arr do scanRemote(arr[i], "Parent=nil") end
end
end
F.Out("[监听扫描] ===== 全局信号上挂了谁（反作弊的监听在这里现形）=====")
local sigs = {
{ Players.PlayerAdded, "Players.PlayerAdded" },
{ Players.PlayerRemoving, "Players.PlayerRemoving" },
{ UIS.InputBegan, "UIS.InputBegan" },
{ UIS.InputChanged, "UIS.InputChanged" },
{ RS.Heartbeat, "RunService.Heartbeat" },
{ RS.RenderStepped, "RunService.RenderStepped" },
{ RS.Stepped, "RunService.Stepped" },
{ LP.Idled, "LocalPlayer.Idled" },
{ LP.CharacterAdded, "LocalPlayer.CharacterAdded" },
}
for i = 1, #sigs do connInfo(sigs[i][1], sigs[i][2]) end
pcall(function() connInfo(workspace.DescendantAdded, "Workspace.DescendantAdded") end)
F._scavenging = keep
end
function F.FnFingerprint(f)
local out = { nums = {}, strs = {}, nups = 0, nconsts = 0 }
if type(f) ~= "function" then return out end
if islclosure and not islclosure(f) then return out end
pcall(function()
local ok, c = pcall(dbgGetConstants, f)
if ok and type(c) == "table" then
out.nconsts = #c
for i = 1, #c do
local v = c[i]
if type(v) == "number" then
if #out.nums < 24 then out.nums[#out.nums + 1] = v end
elseif type(v) == "string" then
if #v >= 3 and #out.strs < 24 then out.strs[#out.strs + 1] = v end
end
end
end
local ok2, u = pcall(dbgGetUpvalues, f)
if ok2 and type(u) == "table" then out.nups = #u end
end)
return out
end
function F.ScanByConstants(list, mode)
if type(list) ~= "table" or #list == 0 then
F.Out("[按常量] 用法: 需要一组字符串（逗号分隔），例如 ` - On Xbox, - On mobile`")
return 0
end
local keep = F._scavenging
F._scavenging = true
F.Out("[按常量] ===== 按常量字符串找函数 · 关键词 " .. table.concat(list, " | ") .. " =====")
local hits, n = {}, 0
local function report(f)
n = n + 1
if n > 40 then return end
local oki, info = nil, nil
if type(dbgGetInfo) == "function" then oki, info = pcall(dbgGetInfo, f, "nS") end
local nm = (oki and info and info.name) or "(匿名)"
local sv = (oki and info and info.source) or "?"
F.Out(string.format("[按常量]   %s @ %s", nm, sv))
local fp = F.FnFingerprint(f)
if #fp.nums > 0 then
local nums = {}
for i = 1, #fp.nums do nums[i] = tostring(fp.nums[i]) end
F.Out("[按常量]      数字: " .. table.concat(nums, ", ")
.. "  形状(upvalue " .. fp.nups .. " / 常量 " .. fp.nconsts .. ")")
end
if #fp.strs > 0 then F.Out("[按常量]      字符串: " .. table.concat(fp.strs, " | "):sub(1, 160)) end
hits[#hits + 1] = f
end
local used = "getgc 回退"
if type(filtergc) == "function" then
local ok, got = pcall(filtergc, "function", { Constants = list, IgnoreExecutor = true }, true)
if ok and type(got) == "table" then
local n0 = n
for i = 1, #got do
if type(got[i]) == "function" then report(got[i]) end
end
if n > n0 then used = "filtergc" end
end
end
if n == 0 and type(dbgGetGC) == "function" then
local seen, scanned = 0, 0
for _gi, obj in ipairs(F.GuardedGetGC(true, true)) do
if not F.gcTick(_gi) then break end
scanned = scanned + 1
if scanned > F.LIMITS.SCAN_ANALYZE_CAP then break end
if scanned % F.LIMITS.SCAN_YIELD_EVERY == 0 then task.wait() end
if type(obj) == "function" and (not islclosure or islclosure(obj)) then
local okc, consts = pcall(dbgGetConstants, obj)
if okc and type(consts) == "table" then
local joined = {}
for i = 1, #consts do
if type(consts[i]) == "string" then joined[#joined + 1] = consts[i] end
end
local blob = table.concat(joined, "\n")
local all = (mode ~= "any")
local hit = all
for i = 1, #list do
local foundOne = blob:find(list[i], 1, true) ~= nil
if all then
if not foundOne then hit = false break end
else
if foundOne then hit = true break end
end
end
if hit then
seen = seen + 1
if seen > 40 then break end
report(obj)
end
end
end
end
end
F.Out(string.format("[按常量] 命中 %d 个（通道: %s）", n, used))
if n > 0 then
F.Out("[按常量] 把上面每个函数「数字」当**上限参考**：加速/飞行速度压到它下面即可")
end
F._scavenging = keep
return n
end
function F.IsOursSrc(low)
if type(low) ~= "string" then return false end
return (low:find("cheatmenu", 1, true) ~= nil) or (low:find("fluent", 1, true) ~= nil)
end
function F.FindByShape(nups, nconsts)
if type(getgc) ~= "function" then
F.Out("[形状] ⚠ 本执行器缺 getgc —— 无法按形状搜索")
return
end
local keep = F._scavenging
F._scavenging = true
F.Out(string.format("[形状] ===== 形状搜索: upvalue=%s 常量=%s =====", tostring(nups), tostring(nconsts)))
local n, scanned = 0, 0
for _gi, obj in ipairs(F.GuardedGetGC(true, true)) do
if not F.gcTick(_gi) then break end
scanned = scanned + 1
if scanned > F.LIMITS.SCAN_ANALYZE_CAP then break end
if scanned % F.LIMITS.SCAN_YIELD_EVERY == 0 then task.wait() end
if type(obj) == "function" and (not islclosure or islclosure(obj)) then
local fp = F.FnFingerprint(obj)
if fp.nups == nups and fp.nconsts == nconsts then
n = n + 1
if n <= 40 then
local oki, info = pcall(debug.getinfo, obj, "nS")
F.Out(string.format("[形状]   #%d %s @ %s", n,
(oki and info and info.name ~= "" and info.name) or "(匿名)",
(oki and info and info.source) or "?"))
local nums = {}
for i = 1, #fp.nums do nums[i] = tostring(fp.nums[i]) end
if #nums > 0 then F.Out("[形状]      数字: " .. table.concat(nums, ", ")) end
end
end
end
end
F.Out(string.format("[形状] 命中 %d 个（已扫 %d 个函数）", n, scanned))
F._scavenging = keep
return n
end
F._afkConn = nil
F._afkConn2 = nil
F._afkDisabledConns = {}
F.AntiAFKKillIdleConns = function()
local n = 0
pcall(function()
if type(getconnections) ~= "function" then return end
for _, c in ipairs(getconnections(LP.Idled) or {}) do
local fn = nil
pcall(function() fn = c.Function end)
if fn == nil then pcall(function() fn = c.__function end) end
local nm, srcPath = "", ""
if type(fn) == "function" and type(debug) == "table" and type(debug.getinfo) == "function" then
pcall(function()
local info = debug.getinfo(fn, "Sln")
nm = tostring(info and info.name or ""):lower()
srcPath = tostring(info and info.source or ""):lower()
end)
end
local bag = nm .. " " .. srcPath
if bag:find("afk") or bag:find("idle") or bag:find("timeout") or bag:find("anticheat")
or bag:find("detect") or bag:find("anti") or bag:find("guard") or bag:find("kick")
or bag:find("boot") then
pcall(function() c:Disable() end)
F._afkDisabledConns[#F._afkDisabledConns + 1] = c
n = n + 1
end
end
end)
F._afkKilled = (F._afkKilled or 0) + n
return n
end
function F.AntiAFKEnable()
if F._afkConn then return end
T.AntiAFK = true
F._afkKilled = 0
F._afkFixes = 0
pcall(F.MetaHookEnsure)
local killed = F.AntiAFKKillIdleConns()
F._afkConn = LP.Idled:Connect(function()
if not T.AntiAFK then return end
F._afkIdleHits = (F._afkIdleHits or 0) + 1
end)
pcall(F.AntiAFKInputLoop)
F._afkConn2 = RS.Heartbeat:Connect(function()
if not T.AntiAFK then F.AntiAFKDisable() return end
local now = os.clock()
if now - (F._afkAt or 0) < 5 then return end
F._afkAt = now
if now - (F._afkHbAt or 0) > 15 then
F._afkHbAt = now
pcall(function() LP:SetAttribute("Heartbeat", math.floor(os.clock() * 1000)) end)
end
local hits = F._afkIdleHits or 0
if hits ~= (F._afkIdleLogged or 0) then
F._afkIdleLogged = hits
F.Out("[防挂机] 游戏判你挂机过 " .. tostring(hits) .. " 次 ⇒ 已按时间监听处理(不动你的人物)")
end
end)
F.Out("[防挂机] 已开(完全不动你的人物): 掐掉 " .. tostring(killed) .. " 条挂机检测连接"
.. " + 每 15 秒写一次心跳属性 + 监听 Idled 只记录")
end
function F.AntiAFKDisable()
T.AntiAFK = false
F._afkInput = nil
if F._afkDisabledConns then
for _, c in ipairs(F._afkDisabledConns) do pcall(function() c:Enable() end) end
F._afkDisabledConns = {}
end
if F._afkConn then pcall(function() F._afkConn:Disconnect() end) F._afkConn = nil end
if F._afkConn2 then pcall(function() F._afkConn2:Disconnect() end) F._afkConn2 = nil end
end
F._flingConns = {}
function F.AntiFlingEnable()
if T.AntiFling and #F._flingConns > 0 then return end
T.AntiFling = true
local function fix()
local _, _, root = GC()
if not root then return end
local lim = math.max(8000, (tonumber(C.SpeedValue) or 0) * 2.5, (tonumber(C.FlyValue) or 0) * 2.5)
local v = root.AssemblyLinearVelocity
local av = root.AssemblyAngularVelocity
if v.Magnitude > lim then
pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, math.min(v.Y, 50), 0) end)
F._flingAt2 = os.clock()
F._flingHits = (F._flingHits or 0) + 1
if os.clock() - (F._flingLogAt or 0) > 2 then
F._flingLogAt = os.clock()
F.Out(string.format("[反甩] 异常速度 %.0f 格/秒 ⇒ 已清零(累计 %d 次) · 只清速度, 不动任何碰撞属性",
v.Magnitude, F._flingHits))
end
end
if av.Magnitude > 200 then
pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
end
end
fix()
table.insert(F._flingConns, RS.Heartbeat:Connect(fix))
table.insert(F._flingConns, LP.CharacterAdded:Connect(function() task.wait(0.3) fix() end))
end
F.BODY_PARTS = {
["HumanoidRootPart"] = true, ["Head"] = true, ["Torso"] = true,
["UpperTorso"] = true, ["LowerTorso"] = true,
["Left Arm"] = true, ["Right Arm"] = true, ["Left Leg"] = true, ["Right Leg"] = true,
["LeftUpperArm"] = true, ["LeftLowerArm"] = true, ["LeftHand"] = true,
["RightUpperArm"] = true, ["RightLowerArm"] = true, ["RightHand"] = true,
["LeftUpperLeg"] = true, ["LeftLowerLeg"] = true, ["LeftFoot"] = true,
["RightUpperLeg"] = true, ["RightLowerLeg"] = true, ["RightFoot"] = true,
}
function F.FixCharCollision()
local ch = GC()
if not ch then F.Out("[修复] 现在没有角色, 稍后再点"); return 0 end
local n = 0
pcall(function()
for _, p in ipairs(ch:GetDescendants()) do
if p:IsA("BasePart") and F.BODY_PARTS[p.Name] == true then
if p.CanCollide == false or p.CanTouch == false or p.CanQuery == false then
p.CanCollide, p.CanTouch, p.CanQuery = true, true, true
n = n + 1
end
end
end
end)
F.Out("[修复] 已把 " .. tostring(n) .. " 个身体部位的 碰撞/触碰/可查询 恢复默认(true) —— 只动标准身体部件, 不碰挂件/工具/游戏加的部件")
return n
end
function F.AntiFlingDisable()
T.AntiFling = false
for _, c in ipairs(F._flingConns) do pcall(function() c:Disconnect() end) end
F._flingConns = {}
if F._flingBackup then
for part, bak in pairs(F._flingBackup) do
if typeof(part) == "Instance" and part.Parent then
pcall(function()
part.CanCollide = bak.CanCollide
part.CanTouch = bak.CanTouch
part.CanQuery = bak.CanQuery
end)
end
end
F._flingBackup = nil
end
end
local KG = { hooked = false, target = nil, rjConn = nil, blocked = 0 }
F.MetaHookUninstall = function() pcall(F.KickGuardPathsDisable) end
function F.DeepNeuterEnable()
T.DeepNeuter = true
pcall(F.MetaHookEnsure)
local n = 0
pcall(function() n = F.AntiCheatGCSweep() end)
F.Out("[深度中和] 已开: getgc 扫到并中和 " .. tostring(n) .. " 个检测/踢人函数"
.. " —— 这层最容易招反作弊, 用完记得关")
end
function F.DeepNeuterDisable()
T.DeepNeuter = false
local n = 0
pcall(function() n = F.AntiCheatGCRestore() end)
F.Out("[深度中和] 已关(还原 " .. tostring(n) .. " 个被改过的函数)")
end
function F.MetaHookEnsure()
if KG.mtHooked then return end
F.Try("KickGuardPathsEnable", F.KickGuardPathsEnable)
end
F._gcSweepSaved = {}
F.AntiCheatGCSweep = function()
local n, seen = 0, 0
pcall(function()
if type(getgc) ~= "function" then return end
for _, v in pairs(getgc(true)) do
seen = seen + 1
if seen > 60000 then break end
if typeof(v) == "table" then
local function neuter(key, repl)
local f = nil
pcall(function() f = rawget(v, key) end)
if type(f) == "function" then
if not F._gcSweepSaved[v] then F._gcSweepSaved[v] = {} end
if F._gcSweepSaved[v][key] == nil then F._gcSweepSaved[v][key] = f end
pcall(function() v[key] = repl end)
n = n + 1
end
end
neuter("kick", function() return task.wait(9e9) end)
neuter("randomDelayKick", function() return task.wait(9e9) end)
neuter("lagback", function() return end)
neuter("punish", function() return end)
local hasD, hasK = nil, nil
pcall(function()
hasD = rawget(v, "Detected")
hasK = rawget(v, "Kill")
end)
if type(hasD) == "function" and type(hasK) == "function" then
neuter("Detected", function() return false end)
neuter("Kill", function() return end)
end
local bmv = nil
pcall(function() bmv = rawget(v, "getIsBodyMoverCreatedByGame") end)
if type(bmv) == "function" then
if not F._gcSweepSaved[v] then F._gcSweepSaved[v] = {} end
if F._gcSweepSaved[v]["getIsBodyMoverCreatedByGame"] == nil then
F._gcSweepSaved[v]["getIsBodyMoverCreatedByGame"] = bmv
end
pcall(function() v.getIsBodyMoverCreatedByGame = function() return true end end)
n = n + 1
end
end
end
end)
if n > 0 then
F.Out("[防踢] getgc 扫到并中和 " .. tostring(n) .. " 个检测/踢人函数"
.. " (含「这个物理约束是游戏自己加的」这类判定)")
end
return n
end
F.AntiCheatGCRestore = function()
local n = 0
for t, kv in pairs(F._gcSweepSaved or {}) do
if type(t) == "table" then
for k, f in pairs(kv) do
pcall(function() t[k] = f end)
n = n + 1
end
end
end
F._gcSweepSaved = {}
return n
end
function F.KickGuardPathsEnable()
if KG.mtHooked then return end
KG.kick = true
local ok = pcall(function()
if type(getrawmetatable) ~= "function" then return end
local mt = getrawmetatable(game)
if type(mt) ~= "table" then return end
pcall(function() if setreadonly then setreadonly(mt, false) end end)
F._roUnlocked = true
local oldNC, oldIX, oldNIX = mt.__namecall, mt.__index, mt.__newindex
if type(oldNC) ~= "function" then return end
local function wrap(fn)
if type(newcclosure) == "function" then return newcclosure(fn) end
return fn
end
mt.__namecall = wrap(function(self, ...)
local m = nil
pcall(function() m = getnamecallmethod() end)
if KG.kick and m == "Kick" and self == LP then
KG.blocked = (KG.blocked or 0) + 1
return nil
end
if (T.SpeedGuard or T.SteadyOn or T.HitGuard) and m == "ChangeState" and KG.blockSet[self] then
local st = select(1, ...)
if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
KG.blocked8 = (KG.blocked8 or 0) + 1
return nil
end
if st == Enum.HumanoidStateType.Physics then
KG.blocked7 = (KG.blocked7 or 0) + 1
return nil
end
end
if (m == "FireServer" or m == "InvokeServer") and T.NoDrop then
local isInst1 = false
pcall(function() isInst1 = (typeof(self) == "Instance") end)
if isInst1 then
local nm1 = ""
pcall(function() nm1 = self.Name end)
if type(nm1) == "string" and nm1 ~= "" then
local low1 = string.lower(nm1)
local allow1 = false
for _, ak in ipairs(F.ALLOW_REMOTE_KEYS) do
if string.find(low1, ak, 1, true) then allow1 = true break end
end
if not allow1 then
for _, kk in ipairs(F.DROP_KEYS) do
if string.find(low1, kk, 1, true) then
KG.blocked10 = (KG.blocked10 or 0) + 1
return nil
end
end
end
end
end
end
if (m == "FireServer" or m == "InvokeServer") and (T.TrapWarn or T.GuardOn) then
local isInst0 = false
pcall(function() isInst0 = (typeof(self) == "Instance") end)
if isInst0 then
local nm0 = ""
pcall(function() nm0 = self.Name end)
if type(nm0) == "string" and nm0 ~= "" then
local low0 = string.lower(nm0)
local allow = false
for _, ak in ipairs(F.ALLOW_REMOTE_KEYS) do
if string.find(low0, ak, 1, true) then allow = true break end
end
if not allow then
for _, kk in ipairs(F.BLOCK_REMOTE_KEYS) do
if string.find(low0, kk, 1, true) then
KG.blocked9 = (KG.blocked9 or 0) + 1
return nil
end
end
end
end
end
end
if (m == "FireServer" or m == "InvokeServer") and (T.AntiAFK or T.SpeedGuard) then
local isInst = false
pcall(function() isInst = (typeof(self) == "Instance") end)
if isInst then
local nm = ""
pcall(function() nm = self.Name end)
if type(nm) == "string" and nm ~= "" then
if T.AntiAFK and string.find(nm, "Afk", 1, true) then
KG.blocked6 = (KG.blocked6 or 0) + 1
return nil
end
if T.SpeedGuard and (string.find(nm, "Integrity", 1, true)
or string.find(nm, "Correction", 1, true)
or string.find(nm, "Violation", 1, true)
or string.find(nm, "anticheat", 1, true)
or string.find(nm, "honeypot", 1, true)) then
KG.blocked6 = (KG.blocked6 or 0) + 1
return nil
end
end
end
end
return oldNC(self, ...)
end)
if type(oldIX) == "function" then
mt.__index = wrap(function(self, key)
local exec = false
pcall(function() exec = (type(checkcaller) == "function") and checkcaller() end)
if exec then return oldIX(self, key) end
if KG.kick and self == LP and key == "Kick" then
KG.blocked = (KG.blocked or 0) + 1
return function() end
end
if KG.spoof and KG.spoofHum and self == KG.spoofHum then
if key == "WalkSpeed" and KG.spoofWalk then
KG.spoofHits = (KG.spoofHits or 0) + 1
return KG.spoofWalk
end
if key == "JumpPower" and KG.spoofJump then
KG.spoofHits = (KG.spoofHits or 0) + 1
return KG.spoofJump
end
end
return oldIX(self, key)
end)
end
if type(oldNIX) == "function" then
mt.__newindex = wrap(function(self, key, v)
local exec2 = false
pcall(function() exec2 = (type(checkcaller) == "function") and checkcaller() end)
if exec2 then return oldNIX(self, key, v) end
if KG.kick and self == LP and key == "Kick" then
KG.blocked = (KG.blocked or 0) + 1
return nil
end
if T.SpeedGuard and KG.intent and self == KG.root
and (key == "CFrame" or key == "Position") then
local np = nil
pcall(function()
if typeof(v) == "CFrame" then np = v.Position
elseif typeof(v) == "Vector3" then np = v end
end)
if np then
local ip = KG.intent
local dNew = (Vector3.new(np.X, 0, np.Z) - Vector3.new(ip.X, 0, ip.Z)).Magnitude
if dNew > (KG.dev or 0) + 12 then
KG.blocked5 = (KG.blocked5 or 0) + 1
return nil
end
end
end
if T.Invisible and key == "Transparency" and v == 0 then
KG.blocked4 = (KG.blocked4 or 0) + 1
return nil
end
if T.InstantInteract and key == "HoldDuration" and type(v) == "number" and v > 0 then
KG.blocked4 = (KG.blocked4 or 0) + 1
return nil
end
if T.InstantInteract and key == "RequiresLineOfSight" and v == true then
KG.blocked4 = (KG.blocked4 or 0) + 1
return nil
end
if KG.blockSet[self] and T.SpeedGuard then
if key == "Anchored" and v == true then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
if key == "PlatformStand" and v == true then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
if (key == "WalkSpeed" or key == "JumpPower" or key == "JumpHeight")
and type(v) == "number" and v <= 0.01 then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
if key == "AutoRotate" and v == false then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
if key == "PlatformStand" and v == false and T.FlyOn then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
if key == "Health" and type(v) == "number" then
local hv = nil
pcall(function() hv = rawget(self, "Health") end)
if type(hv) == "number" and v < hv then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
end
end
return oldNIX(self, key, v)
end)
end
KG.mt, KG.oldNC, KG.oldIX, KG.oldNIX = mt, oldNC, oldIX, oldNIX
KG.mtHooked = true
pcall(function()
if type(debug) ~= "table" or type(debug.getinfo) ~= "function" then return end
if KG.oldGetInfo then return end
local oldGI = debug.getinfo
KG.oldGetInfo = oldGI
local function wrapped(fn, ...)
local info = oldGI(fn, ...)
if type(info) == "table" and info.source then
local src = tostring(info.source)
if src:find("CheatMenu_hot", 1, true) or src:find("CM_", 1, true) then
info.source = "=nil"
info.short_src = "nil"
end
end
return info
end
if type(newcclosure) == "function" then debug.getinfo = newcclosure(wrapped) else debug.getinfo = wrapped end
end)
end)
if not ok or not KG.mtHooked then KG.mtHooked = nil return end
KG.blockSet = {}
KG.logConn = RS.Heartbeat:Connect(function()
local n = KG.blocked or 0
if n ~= (KG.lastReport or 0) then
KG.lastReport = n
F.Out("[CheatMenu] 拦截 Kick 调用 ×" .. tostring(n) .. " (三条路径: :Kick() / .Kick 取值 / .Kick 赋值)")
end
local n2 = KG.blocked3 or 0
if n2 ~= (KG.lastReport3 or 0) then
KG.lastReport3 = n2
F.Out("[屏蔽] 已挡下服务端对我角色的写入 ×" .. tostring(n2)
.. " (钉住/清血/打断飞行/禁走/禁跳/禁转向)")
end
local ch = LP.Character
if ch then
local now = os.clock()
if now - (KG.setAt or 0) > 0.5 then
KG.setAt = now
local s = {}
local hum = nil
pcall(function()
for _, o in ipairs(ch:GetDescendants()) do
if o:IsA("BasePart") or o:IsA("Humanoid") then s[o] = true end
if o:IsA("Humanoid") then hum = o end
end
end)
KG.blockSet = s
if T.Spoof then
KG.spoofHum = hum
local bw = tonumber(F._preSpeed) or tonumber(F._spoofWalkBase)
if not bw and hum then
pcall(function() bw = tonumber(hum.WalkSpeed) end)
F._spoofWalkBase = bw
end
KG.spoofWalk = bw
if not F._spoofJumpBase and hum then
local jp = nil
pcall(function() jp = tonumber(hum.JumpPower) end)
F._spoofJumpBase = jp
end
KG.spoofJump = F._spoofJumpBase
else
KG.spoofHum, KG.spoofWalk, KG.spoofJump = nil, nil, nil
end
end
end
if T.SpeedGuard then
local _, _, r3 = GC()
if r3 then
KG.root = r3
local ip = F._intent
KG.intent = ip
if ip then
KG.dev = (Vector3.new(r3.Position.X, 0, r3.Position.Z) - Vector3.new(ip.X, 0, ip.Z)).Magnitude
end
end
else
KG.root, KG.intent, KG.dev = nil, nil, nil
end
local n5 = KG.blocked5 or 0
if n5 ~= (KG.lastBlock5 or 0) then
KG.lastBlock5 = n5
F.Out("[屏蔽] 已挡下服务端把我拉回去 ×" .. tostring(n5) .. " (它想把你写回原地, 被拦下)")
end
local n10 = KG.blocked10 or 0
if n10 ~= (KG.lastBlock10 or 0) then
KG.lastBlock10 = n10
F.Out("[防掉蛋] 已拦下'掉蛋/放下'上报 ×" .. tostring(n10)
.. " (被夹/被抓后游戏想让你的蛋掉出去, 被挡掉 ⇒ 蛋还在你手上)")
end
local n9 = KG.blocked9 or 0
if n9 ~= (KG.lastBlock9 or 0) then
KG.lastBlock9 = n9
F.Out("[拦触发] 已拦下 陷阱/守卫/抓捕 的触发上报 ×" .. tostring(n9)
.. " (游戏想上报'我被夹/被抓了', 被挡掉 ⇒ 服务端收不到就不会处理你)")
end
local n8 = KG.blocked8 or 0
if n8 ~= (KG.lastBlock8 or 0) then
KG.lastBlock8 = n8
F.Out("[屏蔽] 已挡下把你打晕/打成布娃娃 ×" .. tostring(n8) .. " (被球棒打晕会掉蛋, 这层就是防这个)")
end
local n7 = KG.blocked7 or 0
if n7 ~= (KG.lastBlock7 or 0) then
KG.lastBlock7 = n7
F.Out("[屏蔽] 已挡下把你切成物理道具 ×" .. tostring(n7) .. " (ChangeState(Physics) 是反作弊'冻结你'的常用手法)")
end
local n6 = KG.blocked6 or 0
if n6 ~= (KG.lastBlock6 or 0) then
KG.lastBlock6 = n6
F.Out("[反检测] 已拦下客户端上报 ×" .. tostring(n6)
.. " (完整性Integrity/拉回前奏Correction/违规Violation/反作弊anticheat/蜜罐honeypot/挂机Afk —— 服务端收不到这些就少一条判你的依据)")
end
local n4 = KG.blocked4 or 0
if n4 ~= (KG.lastBlock4 or 0) then
KG.lastBlock4 = n4
F.Out("[屏蔽] 已挡下服务端把我改回去 ×" .. tostring(n4) .. " (把隐身改回可见 / 把瞬发交互改回长按)")
end
local n3 = KG.spoofHits or 0
if n3 ~= (KG.lastSpoof or 0) then
KG.lastSpoof = n3
F.Out("[伪装] 已对游戏侧伪装速度读数 ×" .. tostring(n3) .. " (游戏读到的是原值, 不是加速值)")
end
end)
end
function F.KickGuardPathsDisable()
KG.kick = false
if T.Spoof or T.SpeedGuard then return end
if KG.logConn then pcall(function() KG.logConn:Disconnect() end) KG.logConn = nil end
if KG.mtHooked and KG.mt then
pcall(function()
if KG.oldNC then KG.mt.__namecall = KG.oldNC end
if KG.oldIX then KG.mt.__index = KG.oldIX end
if KG.oldNIX then KG.mt.__newindex = KG.oldNIX end
end)
end
KG.mtHooked, KG.mt, KG.oldNC, KG.oldIX, KG.oldNIX = nil, nil, nil, nil, nil
KG.lastReport = nil
pcall(F.CMX_RestoreRO)
end
function F.KickGuardEnable()
if KG.hooked then return true end
F.Out("[防踢] 正在装「Kick 三路径拦截」(会改写全局元表) —— 个别反作弊会因这层 hook 直接踢你; 平时建议关着, 挂机前再开")
F.Try("KickGuardPathsEnable", F.KickGuardPathsEnable)
local kf = LP.Kick
if type(kf) ~= "function" or not hookfunction then return false end
local orig
local wrapper = function(self, msg)
if self == LP and (type(msg) == "string" or type(msg) == "number") then
F.Out("[CheatMenu] 本地拦截 Kick: " .. tostring(msg))
return nil
end
if orig then return orig(self, msg) end
end
local ok, result = pcall(function()
if newcclosure then return hookfunction(kf, newcclosure(wrapper)) else return hookfunction(kf, wrapper) end
end)
if not ok or type(result) ~= "function" then return false end
orig = result
KG.target = kf
KG.orig = result
KG.hooked = true
if not F._kgHeal then
F._kgHeal = task.spawn(function()
while T.KickProtect or T.KickGuard do
task.wait(6)
if not (T.KickProtect or T.KickGuard) then break end
if not KG.kick or not KG.mtHooked then
F.Out("[防踢] 检测到拦截层被摘掉 ⇒ 正在重装")
F.Try("KickGuardPathsEnable", F.KickGuardPathsEnable)
F._kgHealFix = (F._kgHealFix or 0) + 1
end
end
F._kgHeal = nil
end)
end
return true
end
function F.KickGuardDisable()
pcall(F.AntiCheatGCRestore)
pcall(F.KickGuardPathsDisable)
if KG.hooked and hookfunction and KG.target and KG.orig then
pcall(function() hookfunction(KG.target, KG.orig) end)
end
KG.hooked = false
KG.orig = nil
end
function F.KickRejoinDisable()
if KG.rjConn then pcall(function() KG.rjConn:Disconnect() end) KG.rjConn = nil end
T.KickRejoin = false
end
function F.KickRejoinEnable()
if KG.rjConn then return true end
KG.rjConn = Players.PlayerRemoving:Connect(function(p)
if p ~= LP then return end
if not T.KickRejoin then return end
pcall(function()
local ts = game:GetService("TeleportService")
if game.PlaceId and game.JobId and game.JobId ~= "" then
ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
end
end)
end)
return true
end
C.PriorityTargets = {}
function F.PlayerNames()
local n = {}
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP then n[#n + 1] = pl.Name end
end
table.sort(n)
if #n == 0 then n[1] = "(无人)" end
return n
end
F.PLAYER_DROPDOWNS = { "TPTarget", "PriorityTarget", "FlingTarget" }
function F.RefreshPlayerDropdowns()
local names = F.PlayerNames()
pcall(function()
local op = Fluent and Fluent.Options
if not op then return end
for _, key in ipairs(F.PLAYER_DROPDOWNS) do
local opt = op[key]
if opt and opt.SetValues then opt:SetValues(names) end
end
end)
end
F._livePlAdded = nil
F._livePlRemoved = nil
function F.LivePlayersEnable()
if F._livePlAdded then return end
F._livePlAdded = Players.PlayerAdded:Connect(function() task.wait(0.15) F.RefreshPlayerDropdowns() end)
F._livePlRemoved = Players.PlayerRemoving:Connect(function() task.wait(0.05) F.RefreshPlayerDropdowns() end)
end
function F.LivePlayersDisable()
if F._livePlAdded then F._livePlAdded:Disconnect() F._livePlAdded = nil end
if F._livePlRemoved then F._livePlRemoved:Disconnect() F._livePlRemoved = nil end
end
F._aimConn = nil
F._fireAt = 0
function F.FireOnce()
local did = {}
local cam = workspace.CurrentCamera
local vp = cam and cam.ViewportSize or Vector2.new(400, 400)
pcall(function()
local vim = game:GetService("VirtualInputManager")
vim:SendMouseButtonEvent(true, vp.X / 2, vp.Y / 2, 0, true, game, 0)
vim:SendMouseButtonEvent(false, vp.X / 2, vp.Y / 2, 0, true, game, 0)
did[#did + 1] = "VIM"
end)
pcall(function()
local ch = LP.Character
local tool = ch and ch:FindFirstChildOfClass("Tool")
if tool then tool:Activate() did[#did + 1] = "tool" end
end)
pcall(function()
local vu = game:GetService("VirtualUser")
vu:CaptureController()
vu:ClickButton1(Vector2.new(vp.X / 2, vp.Y / 2))
pcall(function() vu:ReleaseController() end)
did[#did + 1] = "VirtualUser"
end)
pcall(function()
local b = F._fireBtn
if not (b and b.Parent and b.Visible) then
b = nil
local gui = LP:FindFirstChild("PlayerGui")
if gui then
local keys = { "attack", "fire", "hit", "shoot", "swing", "slash", "kick", "punch" }
for _, d in ipairs(gui:GetDescendants()) do
if d:IsA("TextButton") or d:IsA("ImageButton") then
local nm = tostring(d.Name):lower()
for _, k in ipairs(keys) do
if nm:find(k, 1, true) then b = d break end
end
end
if b then break end
end
end
F._fireBtn = b
end
if b then
if type(firesignal) == "function" then
pcall(firesignal, b.MouseButton1Click)
did[#did + 1] = "屏幕按钮"
elseif type(getconnections) == "function" then
for _, c in ipairs(getconnections(b.MouseButton1Click)) do
pcall(function() c:Fire() end)
did[#did + 1] = "屏幕按钮"
end
end
end
end)
pcall(function()
if type(mouse1click) == "function" then
if pcall(mouse1click) then did[#did + 1] = "mouse1click" end
end
end)
F._lastFireVia = table.concat(did, "+")
return F._lastFireVia
end
F.COMBAT_PARTS = { "Head", "UpperTorso", "LowerTorso", "Torso", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg" }
F.COMBAT_LOS_PARTS = { "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart" }
F.CombatNewRay = function(ignore)
local p = RaycastParams.new()
pcall(function() p.FilterType = Enum.RaycastFilterType.Exclude end)
if p.FilterType ~= Enum.RaycastFilterType.Exclude then pcall(function() p.FilterType = Enum.RaycastFilterType.Blacklist end) end
p.FilterDescendantsInstances = ignore or {}
return p
end
F.CombatAlive = function(pl)
if typeof(pl) ~= "Instance" then return nil end
local ch = pl.Character
if not ch or not ch.Parent then return nil end
local hum = ch:FindFirstChildOfClass("Humanoid")
if not hum or hum.Health <= 0 then return nil end
if T.CombatSkipInvincible ~= false then
if ch:FindFirstChildOfClass("ForceField") then return nil, "无敌" end
if hum.Health > hum.MaxHealth + 0.01 then return nil, "无敌" end
if hum:GetAttribute("Invincible") == true then return nil, "无敌" end
end
local root = ch.PrimaryPart
if not root then
for _, n in ipairs(F.COMBAT_PARTS) do local p = ch:FindFirstChild(n) if p then root = p break end end
end
if not root then return nil, "没模型" end
return ch, hum, root
end
F.CombatVisible = function(ch, fromPos)
if T.CombatWallCheck == false then
local r = ch.PrimaryPart
return r and r.Position or nil
end
local ignore = {}
if LP.Character then ignore[#ignore + 1] = LP.Character end
pcall(function() ignore[#ignore + 1] = workspace.CurrentCamera end)
local params = F.CombatNewRay(ignore)
local best, bestD = nil, math.huge
for _, n in ipairs(F.COMBAT_LOS_PARTS) do
local part = ch:FindFirstChild(n)
if part and part:IsA("BasePart") then
local hit = workspace:Raycast(fromPos, part.Position - fromPos, params)
if (not hit) or hit.Instance:IsDescendantOf(ch) then
local d = (part.Position - fromPos).Magnitude
if d < bestD then best, bestD = part, d end
end
end
end
return best
end
F.CombatPick = function()
local _, hum0, root0 = GC()
if not root0 then return nil, nil, "没有角色" end
local cam = workspace.CurrentCamera
local from = cam and cam.CFrame.Position or root0.Position
local range = tonumber(C.CombatRange) or 300
local fovpx = tonumber(C.CombatFOV) or 300
local pov = (tostring(C.CombatMode or ""):find("正面", 1, true) ~= nil)
local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
local cur = F._combatNow
local best, bestPart, bestScore, blocked, why = nil, nil, math.huge, 0, "没有敌人"
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP then
local ch, h, root = F.CombatAlive(pl)
if ch then
local dist = (root.Position - root0.Position).Magnitude
if dist <= range then
local score = nil
if pov and cam then
local sp, os = cam:WorldToViewportPoint(root.Position)
local dx, dy = sp.X - vp.X / 2, sp.Y - vp.Y / 2
local off = math.sqrt(dx * dx + dy * dy)
if os and off <= fovpx then score = off end
if not score then why = "不在正面圈里" end
else
score = dist
end
if score then
if pl == cur then score = score - 1e6 end
local part = F.CombatVisible(ch, from)
if part then
if score < bestScore then best, bestPart, bestScore = ch, part, score end
else
blocked = blocked + 1
why = "被墙挡住"
end
end
else
why = "超出锁定距离"
end
end
end
end
F._combatNow, F._combatBlocked, F._combatWhy = best, blocked, why
if best then return best, bestPart end
return nil, nil, why
end
F.CombatHudSet = function(text)
if not F._combatHud then return end
pcall(function() F._combatHud.Text = text end)
end
F.CombatHudShow = function()
if F._combatHud then return end
pcall(function()
local gui = Instance.new("ScreenGui")
gui.Name = "CM_CombatHud"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
pcall(function() gui:SetAttribute("CMOwned", true) end)
gui.Parent = gethui and gethui() or game:GetService("CoreGui")
local t = Instance.new("TextLabel")
t.Size = UDim2.fromOffset(420, 30)
t.Position = UDim2.new(0.5, -210, 0, 60)
t.BackgroundTransparency = 0.45
t.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
t.TextColor3 = Color3.fromRGB(255, 255, 255)
t.TextSize = 16
t.Font = Enum.Font.GothamBold
t.Text = "锁定: 搜索中…"
t.Parent = gui
F._combatHud, F._combatHudGui = t, gui
end)
end
F.CombatHudHide = function()
if F._combatHudGui then pcall(function() F._combatHudGui:Destroy() end) end
F._combatHud, F._combatHudGui = nil, nil
end
F._aimHeart, F._aimErr, F._aimLastHeart = 0, 0, 0
F._AIM_STEP = "CM_Combat"
F.CombatTickSafe = function()
F._aimHeart = (F._aimHeart or 0) + 1
local ok, err = pcall(F.CombatTick)
if not ok then
F._aimErr = (F._aimErr or 0) + 1
if F._aimErr <= 3 or F._aimErr % 120 == 0 then
F.Out("[战斗] 自瞄每帧逻辑报错(第 " .. tostring(F._aimErr) .. " 次): " .. tostring(err))
end
end
end
function F.AimBindStep()
if F._aimBind then pcall(function() RS:UnbindFromRenderStep(F._AIM_STEP) end) F._aimBind = nil end
if F._aimConn then pcall(function() F._aimConn:Disconnect() end) F._aimConn = nil end
local ok = pcall(function()
RS:BindToRenderStep(F._AIM_STEP, Enum.RenderPriority.Camera.Value + 1, function() F.CombatTickSafe() end)
end)
if ok then F._aimBind = true return end
F.Out("[战斗] 自瞄主绑定失败 ⇒ 改用 RenderStepped 兜底")
F._aimConn = RS.RenderStepped:Connect(function() F.CombatTickSafe() end)
end
function F.AimWatch()
if F._aimWatch then return end
F._aimWatch = true
F._aimWatchId = (F._aimWatchId or 0) + 1
local myId = F._aimWatchId
task.spawn(function()
while F._aimWatch and F._aimWatchId == myId do
task.wait(2)
if T.AimOn then
if (F._aimHeart or 0) == (F._aimLastHeart or -1) then
F.Out("[战斗] 自瞄心跳停了 ⇒ 自动重新绑定(避免看起来像自己关掉)")
F.AimBindStep()
F._aimLastHeart = F._aimHeart
end
F._aimLastHeart = F._aimHeart
end
end
end)
end
F._typing = false
pcall(function()
UIS.TextBoxFocused:Connect(function() F._typing = true end)
UIS.TextBoxFocusReleased:Connect(function() F._typing = false end)
end)
F.CombatTick = function()
if not T.AimOn then return end
if F._typing or (F.MenuOpen and F.MenuOpen()) then
if F._aimFacing then
F._aimFacing = nil
pcall(function() local _, h0 = GC() if h0 then h0.AutoRotate = true end end)
end
F._combatNow = nil
F._silentPart = nil
return
end
local _, hum, root = GC()
if not (hum and root) then return end
local ch, part = F.CombatPick()
if not (ch and part) then
F._silentPart = nil
if F._aimFacing then
F._aimFacing = nil
pcall(function() hum.AutoRotate = true end)
end
F.CombatHudSet("锁定: 无目标 (" .. tostring(F._combatWhy or "搜索中") .. ")")
return
end
local pl = nil
pcall(function() pl = Players:GetPlayerFromCharacter(ch) end)
if T.SilentAim then
F._silentPart = part
if F._silentCh ~= ch then
F._silentCh = ch
local okd, humT = pcall(function() return ch:FindFirstChildOfClass("Humanoid") end)
if okd and humT then
pcall(function()
if F._silentDied then F._silentDied:Disconnect() F._silentDied = nil end
F._silentDied = humT.Died:Connect(function()
F._silentPart, F._silentCh, F._combatNow = nil, nil, nil
end)
end)
end
end
else
F._silentPart = nil
end
local dist = (part.Position - root.Position).Magnitude
local hpTxt = ""
if T.HealthShow or T.HealthIsolate then
pcall(function()
local hT = ch:FindFirstChildOfClass("Humanoid")
if hT then hpTxt = string.format(" · 血 %.0f/%.0f", hT.Health, hT.MaxHealth) end
end)
end
F.CombatHudSet("锁定: " .. tostring(pl and pl.Name or ch.Name) .. string.format(" · %.0f 格", dist)
.. hpTxt .. (T.AutoFire and " · 自动开火中" or ""))
local dir = part.Position - root.Position
if T.AimTurnBody == true then
local flat = Vector3.new(dir.X, 0, dir.Z)
if flat.Magnitude > 0.05 then
F._aimFacing = true
pcall(function() hum.AutoRotate = false end)
pcall(function() root.CFrame = CFrame.lookAt(root.Position, root.Position + flat.Unit) end)
end
end
if T.AimTurnCamera ~= false then
local cam = workspace.CurrentCamera
if cam then pcall(function() cam.CFrame = CFrame.lookAt(cam.CFrame.Position, part.Position) end) end
end
if T.AutoFire then
local now = os.clock()
if now - (F._fireAt or 0) >= (tonumber(C.AutoFireGap) or 0.12) then
F._fireAt = now
pcall(F.FireOnce)
end
end
end
function F.AimSet(on, why)
T.AimOn = on and true or false
if F._aimBind then pcall(function() RS:UnbindFromRenderStep(F._AIM_STEP) end) F._aimBind = nil end
if F._aimConn then pcall(function() F._aimConn:Disconnect() end) F._aimConn = nil end
if not T.AimOn then
pcall(function()
local _, hum = GC()
if hum and F._aimFacing then hum.AutoRotate = true end
end)
F._aimFacing, F._combatNow = nil, nil
F._silentPart, F._silentCh = nil, nil
if not T.HealthShow then F.CombatHudHide() end
F._aimWatch = false
F._aimWatchId = (F._aimWatchId or 0) + 1
F.Out("[战斗] 自瞄已关闭" .. (why and (" (" .. tostring(why) .. ")") or ""))
return
end
F._aimHeart, F._aimErr, F._aimLastHeart = 0, 0, 0
F.CombatHudShow()
F.AimBindStep()
F.AimWatch()
F.Out("[战斗] 自瞄已开启 · 每帧逻辑已绑定" .. (why and (" (" .. tostring(why) .. ")") or ""))
end
F.EnsureAimOn = function(why)
if T.AimOn then return end
pcall(function()
local op = Fluent and Fluent.Options and Fluent.Options.AimOn
if op and op.Set then op:Set(true) end
end)
if not T.AimOn then F.AimSet(true, why or "附属项联动") end
end
F._silentOn, F._silentPart = false, nil
F.SilentAimSet = function(on)
T.SilentAim = on and true or false
F._silentPart = nil
if not T.SilentAim then
F._silentOn = false
pcall(function() F.MetaUninstall("game.__index", "CMSilent") end)
F.Out("[静默瞄准] 已关(改写层已卸下)")
return
end
local got = F.MetaInstall("game.__index", game, "CMSilent", function(box)
return function(t, k)
if not checkcaller() and F._silentOn and (k == "Hit" or k == "Target") then
local p = F._silentPart
if p and p.Parent then
local okM, isMouse = pcall(function() return t:IsA("Mouse") end)
if okM and isMouse then
if k == "Target" then return p end
local okP, pos = pcall(function() return p.Position end)
if okP and pos then return CFrame.new(pos) end
end
end
end
return box.orig(t, k)
end
end)
if got then
F._silentOn = true
F.Out("[静默瞄准] 已开: 改写 mouse.Hit / mouse.Target 指向锁定目标(不动你的视角)")
F.Out("[静默瞄准] 边界: 只在游戏用「鼠标命中」判定时有效; 若游戏用视线射线/服务端校验则可能无效 —— 这是原理限制, 不是开关没开")
F.EnsureAimOn("静默瞄准")
else
F.Out("[静默瞄准] ⚠ 本执行器装不上 __index 改写层 ⇒ 该功能不可用(其它功能不受影响)")
T.SilentAim = false
end
end
F.SilentAimDisable = function()
T.SilentAim = false
F._silentOn = false
F._silentPart = nil
if F._silentDied then pcall(function() F._silentDied:Disconnect() end) F._silentDied = nil end
F._silentCh = nil
pcall(function() F.MetaUninstall("game.__index", "CMSilent") end)
F.Out("[静默瞄准] 已关闭")
end
F._hpShowOn = false
F.HealthShowSet = function(on)
T.HealthShow = on and true or false
if not T.HealthShow then
F._hpShowOn = false
if not T.AimOn then F.CombatHudHide() end
F.Out("[血量显示] 已关")
return
end
F.CombatHudShow()
if not F._hpShowOn then
F._hpShowOn = true
task.spawn(function()
while F._hpShowOn and T.HealthShow do
pcall(function()
if not T.AimOn then
local _, hum = GC()
if hum then
F.CombatHudSet(string.format("血量: 我 %.0f/%.0f", hum.Health, hum.MaxHealth))
else
F.CombatHudSet("血量: (角色没加载)")
end
end
end)
task.wait(0.25)
end
F._hpShowOn = false
end)
end
F.Out("[血量显示] 已开(用屏幕上方那条 HUD; 自瞄开着时显示的是锁定目标的血量)")
end
F._hpIsoOn, F._hpIsoConns = false, {}
F._hpIsoKill = function(sig)
if not (sig and type(getconnections) == "function") then return 0 end
local ok, conns = pcall(getconnections, sig)
if not (ok and type(conns) == "table") then return 0 end
local n = 0
for _, c in ipairs(conns) do
local fn = nil
pcall(function() fn = c.Function end)
if fn == nil then pcall(function() fn = c.__function end) end
local own = false
pcall(function() own = AC.isOwnConn(fn) end)
if not own then
if pcall(function() c:Disable() end) then
F._hpIsoConns[#F._hpIsoConns + 1] = c
n = n + 1
end
end
end
return n
end
F.HealthIsolateApply = function()
local mx, n = 100, 0
pcall(function()
local _, hum = GC()
if hum then
pcall(function()
local v = hum.MaxHealth
if type(v) == "number" and v == v and v > 0 and v < 1e6 then mx = v end
end)
n = n + F._hpIsoKill(hum.HealthChanged)
n = n + F._hpIsoKill(hum:GetPropertyChangedSignal("Health"))
n = n + F._hpIsoKill(hum:GetPropertyChangedSignal("MaxHealth"))
end
end)
F._myMaxHP = mx
return n
end
F.HealthIsolateSet = function(on)
T.HealthIsolate = on and true or false
if not T.HealthIsolate then
F._hpIsoOn = false
for i = 1, #F._hpIsoConns do pcall(function() F._hpIsoConns[i]:Enable() end) end
F._hpIsoConns = {}
pcall(function() F.MetaUninstall("game.__index", "CMHealthLock") end)
F.Out("[血量隔离] 已关: 读伪装已卸下, 之前断开的血量监听已全部接回")
return
end
local got = F.MetaInstall("game.__index", game, "CMHealthLock", function(box)
return function(t, k)
if not checkcaller() and F._hpIsoOn and (k == "Health" or k == "MaxHealth") then
local _, hum = GC()
if hum and t == hum then
local mx = F._myMaxHP
if type(mx) == "number" and mx == mx and mx > 0 and mx < 1e6 then return mx end
return 100
end
end
return box.orig(t, k)
end
end)
if not got then
F.Out("[血量隔离] ⚠ 本执行器装不上读伪装层 ⇒ 该功能不可用(其它功能不受影响)")
T.HealthIsolate = false
return
end
F._hpIsoOn = true
local n = F.HealthIsolateApply()
local mode = select(1, F.AuthorityGuard(false))
F.Out("[血量隔离] 已开: 外部读 humanoid.Health 只会读到满血; 已断开 " .. tostring(n) .. " 条游戏的血量变化监听")
if tostring(mode or ""):lower():find("server", 1, true) then
F.Out("[血量隔离] ⚠ 本游戏 AuthorityMode=Server(血量服务端裁决) ⇒ 这是「本地看起来不掉血」, 服务端仍可能判你死亡并重生 —— 不是开关没生效")
else
F.Out("[血量隔离] 本游戏血量不是服务端权威 ⇒ 本地不掉血大概率能成立")
end
end
F.HealthIsolateDisable = function()
T.HealthIsolate = false
F._hpIsoOn = false
for i = 1, #F._hpIsoConns do pcall(function() F._hpIsoConns[i]:Enable() end) end
F._hpIsoConns = {}
pcall(function() F.MetaUninstall("game.__index", "CMHealthLock") end)
F.Out("[血量隔离] 已关闭")
end
F.CombatReport = function()
local ch = F._combatNow
local name = "(无)"
if ch and ch.Parent then
pcall(function() name = (Players:GetPlayerFromCharacter(ch) or {}).Name or ch.Name end)
if name == nil then name = ch.Name end
end
F.Out("[战斗] 当前锁定 = " .. tostring(name) .. " · 原因/状态 = " .. tostring(F._combatWhy or "-")
.. " · 被墙挡住 " .. tostring(F._combatBlocked or 0) .. " 个")
F.Out("[战斗] 模式=" .. tostring(C.CombatMode or "?") .. " · 距离=" .. tostring(C.CombatRange or 300)
.. " · 圈=" .. tostring(C.CombatFOV or 300) .. " · 不打隔墙=" .. tostring(T.CombatWallCheck ~= false)
.. " · 不打无敌=" .. tostring(T.CombatSkipInvincible ~= false) .. " · 自动开火=" .. tostring(T.AutoFire == true))
end
local GodConn = nil
local function GodDisable()
if GodConn then GodConn:Disconnect() GodConn = nil end
pcall(function()
local _, hum = GC()
if hum then
local o = F._orig or {}
local mh = hum.MaxHealth
if type(mh) ~= "number" or mh > 1000 or mh ~= mh then hum.MaxHealth = o.maxHealth or 100 end
hum.Health = math.min(hum.Health, hum.MaxHealth)
end
end)
end
local function GodEnable()
if GodConn then return end
local function apply()
local _, hum = GC()
if hum then hum.MaxHealth = 1e6 hum.Health = 1e6 end
end
apply()
GodConn = RS.Stepped:Connect(apply)
end
F.KillAuraConn = nil
function F.KillAuraEnable()
T.KillAura = false
F.Out("[自动攻击] 已移除 —— 战斗页只保留 FPS 自瞄 + 自动开火(锁定后自动扳机)")
end
function F.KillAuraDisable()
T.KillAura = false
if F.KillAuraConn then pcall(function() F.KillAuraConn:Disconnect() end) F.KillAuraConn = nil end
end
F._antiRagdollConn = nil
F._antiKnockConn = nil
function F.AntiRagdollEnable()
if F._antiRagdollConn then return end
local function apply()
local ch, hum = GC()
if not hum then return end
pcall(function()
hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
local rc = ch and ch:FindFirstChild("RagdollClient")
if rc then rc.Enabled = false end
end)
end
apply()
F._antiRagdollConn = RS.Stepped:Connect(apply)
end
function F.AntiRagdollDisable()
if F._antiRagdollConn then F._antiRagdollConn:Disconnect() F._antiRagdollConn = nil end
local ch, hum = GC()
if hum then pcall(function()
hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
end) end
if ch then
local rc = ch:FindFirstChild("RagdollClient")
if rc then pcall(function() rc.Enabled = true end) end
end
end
function F.AntiKnockdownEnable()
if F._antiKnockConn then return end
F._antiKnockConn = RS.Heartbeat:Connect(function()
if not T.AntiKnockdown then F.AntiKnockdownDisable() return end
local _, hum, root = GC()
if not (hum and root) then return end
if hum.Health <= 0 then return end
if T.FlyOn then return end
local fixed = false
if hum.PlatformStand then
pcall(function() hum.PlatformStand = false end)
fixed = true
end
local st = hum:GetState()
if st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.PlatformStanding then
pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
fixed = true
end
if fixed then
F._antiKnockFix = (F._antiKnockFix or 0) + 1
local now = os.clock()
if now - (F._antiKnockLog or 0) > 5 then
F._antiKnockLog = now
F.Out("[防击倒] 已顶掉 " .. tostring(F._antiKnockFix) .. " 次被强行按倒/击倒")
end
end
end)
end
function F.AntiKnockdownDisable()
if F._antiKnockConn then F._antiKnockConn:Disconnect() F._antiKnockConn = nil end
end
function F.PeekScript(inst)
local code = nil
pcall(function() if type(decompile) == "function" then code = decompile(inst) end end)
if type(code) ~= "string" or #code < 16 then
pcall(function() if type(getscriptbytecode) == "function" then code = getscriptbytecode(inst) end end)
end
if type(code) ~= "string" or #code < 8 then return 0, "读不到(执行器不支持 decompile/getscriptbytecode)" end
local isSrc = false
pcall(function() if type(decompile) == "function" then isSrc = true end end)
local low = code:lower()
local hits = 0
for _, k in ipairs(F.ANTITP_KEYS) do
local pos = 1
while hits < 3 do
local i = low:find(k, pos, true)
if not i then break end
hits = hits + 1
local seg = code:sub(math.max(1, i - 60), math.min(#code, i + 60))
seg = tostring(seg):gsub("[%z-W-­]", "?")
F.Out("      ↳ …" .. seg .. "…")
pos = i + #k
end
if hits >= 3 then break end
end
return hits, isSrc and "源码" or "字节码"
end
function F.ScanClientChecks(verbose)
local scripts, conns, foundScripts = {}, {}, {}
pcall(function()
local roots = { LP:FindFirstChild("PlayerScripts"), LP:FindFirstChild("PlayerGui"), LP.Character }
for _, r in ipairs(roots) do
if r then
for _, d in ipairs(r:GetDescendants()) do
if d:IsA("LocalScript") or d:IsA("Script") or d:IsA("ModuleScript") then
local nm = tostring(d.Name):lower()
for _, k in ipairs(F.ANTITP_KEYS) do
if nm:find(k, 1, true) then
scripts[#scripts + 1] = d:GetFullName()
foundScripts[#foundScripts + 1] = d
break
end
end
end
end
end
end
end)
pcall(function()
if type(getconnections) ~= "function" then return end
for _, c in ipairs(getconnections(RS.Heartbeat)) do
local fn = c.Function
pcall(function()
if not fn then return end
local okN, nm = pcall(debug.info, fn, "n")
local okS, sc = pcall(debug.info, fn, "s")
local bag = (tostring(okN and nm or "") .. " " .. tostring(okS and sc or "")):lower()
for _, k in ipairs(F.ANTITP_KEYS) do
if bag:find(k, 1, true) then
conns[#conns + 1] = tostring(okN and nm or "(匿名)") .. " @ " .. tostring(sc or "?")
break
end
end
end)
end
end)
if verbose then
F.Out(string.format("[客户端检测] 按名字扫到脚本 %d 个 · Heartbeat 上可疑连接 %d 条(共 %d 条连接)",
#scripts, #conns, (function() local n = 0 pcall(function() n = #getconnections(RS.Heartbeat) end) return n end)()))
for i = 1, math.min(#scripts, 6) do F.Out("   · 脚本: " .. scripts[i]) end
if #foundScripts > 0 then
F.Out("   —— 试着读它的代码(只读, 不执行) ——")
for i = 1, math.min(#foundScripts, 3) do
F.Out("   ▸ " .. tostring(foundScripts[i].Name))
local n, how = F.PeekScript(foundScripts[i])
if n == 0 then
F.Out("      (读不到内容: " .. tostring(how) .. ")")
else
F.Out("      (命中 " .. tostring(n) .. " 处 · 来源: " .. tostring(how) .. ")")
end
end
end
pcall(function()
local pk = RStorage:FindFirstChild("Packages")
local nw = pk and pk:FindFirstChild("Networking")
local known = nw and nw:FindFirstChild("RE/RigSync/Refresh")
F.Out("   同族已知路径 RE/RigSync/Refresh: " .. (known and "存在(公开作品就是断这一条)" or "不存在(这个游戏结构不同)"))
end)
for i = 1, math.min(#conns, 6) do F.Out("   · 连接: " .. conns[i]) end
if #scripts == 0 and #conns == 0 then
F.Out("   ★ 结论: 客户端侧没有「防加速/拉回」检测 ⇒ 加速可以直接用(只注意服务端的速度阈值)")
elseif #scripts == 0 then
F.Out("   ★ 结论: 没有检测脚本, 但 Heartbeat 上有 " .. tostring(#conns)
.. " 条可疑连接 ⇒ 谨慎加速, 被拉回就开「加速防拉回」档")
else
F.Out("   ★ 结论: 客户端有防加速检测(脚本 " .. tostring(#scripts) .. " 个) ⇒ 先开「加速防拉回」档再加速")
end
end
return #scripts, #conns
end
function F.GuardSet(steady, hit, lock, trap, dodge, atp, strong, bypass)
if steady or hit then
F.Try("CharEventsEnable", F.CharEventsEnable)
pcall(F.MetaHookEnsure)
else
pcall(F.CharEventsDisable)
end
T.SteadyOn, T.HitGuard, T.HitLock = steady, hit, lock
T.TrapWarn, T.TrapDodge, T.SpeedAntiTP = trap, false, atp
T.HitStrong = strong and true or false
T.BypassDetect = bypass and true or false
if bypass then pcall(F.BypassEnable) else pcall(F.BypassDisable) end
pcall(steady and F.SteadyEnable or F.SteadyDisable)
if hit then pcall(function() F.HitGuardEnable(strong) end) else pcall(F.HitGuardDisable) end
pcall(trap and F.TrapGuardEnable or F.TrapGuardDisable)
pcall(atp and F.SpeedAntiTPEnable or F.SpeedAntiTPDisable)
F.Out(string.format("[防护] 稳身=%s · 受击保护=%s%s · 锁满血=%s · 陷阱=%s · 防拉回=%s · 绕过拉回=%s",
steady and "开" or "关", hit and "开" or "关", strong and "(猛档:断连接)" or "(状态法)",
lock and "开" or "关",
trap and "拦截(只做不触发)" or "关", atp and "开" or "关", bypass and "开" or "关"))
end
F.FLOOR_KEYS = { "treadmill", "tread", "belt", "conveyor", "walk", "mill", "runner", "speedpad" }
F._floorLast = {}
F._floorCacheT, F._floorCacheV = 0, false
F.OnMovingFloorC = function()
local now = os.clock()
if now - (F._floorCacheT or 0) < 0.5 then return F._floorCacheV end
F._floorCacheT = now
local v = false
pcall(function() v = F.OnMovingFloorC() end)
F._floorCacheV = v and true or false
return F._floorCacheV
end
function F.OnMovingFloorC()
local _, _, root = GC()
if not root then return false end
local hit = false
pcall(function()
local op = OverlapParams.new()
op.FilterType = Enum.RaycastFilterType.Exclude
if LP.Character then op.FilterDescendantsInstances = { LP.Character } end
local probe = root.Position - Vector3.new(0, 3, 0)
local seen = {}
for _, pf in ipairs(workspace:GetPartBoundsInRadius(probe, 7, op)) do
seen[pf] = true
local nm = tostring(pf.Name):lower()
for _, k in ipairs(F.FLOOR_KEYS) do
if nm:find(k, 1, true) then hit = true break end
end
if not hit then
local av = 0
pcall(function() av = pf.AssemblyLinearVelocity.Magnitude end)
if av > 0.5 then hit = true end
end
if not hit and F._floorLast[pf] then
local d = (pf.Position - F._floorLast[pf]).Magnitude
if d > 0.02 then hit = true end
end
F._floorLast[pf] = pf.Position
end
for obj in pairs(F._floorLast) do
if not seen[obj] then F._floorLast[obj] = nil end
end
end)
return hit
end
F.ANTITP_KEYS = { "obbyantitp", "antitp", "antilagback", "lagback",
"speedcheck", "speedguard", "anticheat", "antiexploit", "antifly",
"runtime_", "honeypot", "integrityviolation", "monitor" }
F.ANTITP_FNS = { check = true, lagback = true, punish = true, kill = true, report = true, flag = true }
F._atpState = nil
function F.SpeedAntiTPDisable()
if F._atpDisabled then
local back = 0
for _, d in ipairs(F._atpDisabled) do
if typeof(d) == "Instance" and d.Parent then
pcall(function() d.Disabled = false end)
back = back + 1
end
end
F._atpDisabled = nil
if back > 0 then F.Out("[防拉回] 已把 " .. tostring(back) .. " 个被禁用的游戏脚本恢复回来") end
end
local st = F._atpState
F._atpState = nil
if not st then return end
for fn, orig in pairs(st.hooked or {}) do
pcall(function() hookfunction(fn, orig) end)
end
for _, c in ipairs(st.conns or {}) do
pcall(function() if c.Enable then c:Enable() end end)
end
if st.attrConn then pcall(function() st.attrConn:Disconnect() end) end
if st.addConn then pcall(function() st.addConn:Disconnect() end) end
F.Out("[防拉回] 已还原：解锁 " .. tostring(#(st.conns or {})) .. " 条连接")
end
function F.SpeedAntiTPKillScripts()
local n = 0
pcall(function()
local roots = { LP:FindFirstChild("PlayerScripts"), LP.Character, game:GetService("ReplicatedFirst") }
for _, r in ipairs(roots) do
if r then
for _, d in ipairs(r:GetDescendants()) do
if d:IsA("LocalScript") then
local nm = tostring(d.Name):lower()
for _, k in ipairs(F.ANTITP_KEYS) do
if nm:find(k, 1, true) then
local okd = pcall(function() d.Disabled = true end)
if okd then
F._atpDisabled = F._atpDisabled or {}
F._atpDisabled[#F._atpDisabled + 1] = d
n = n + 1
end
break
end
end
end
end
end
end
end)
return n
end
function F.SpeedAntiTPEnable()
if F._atpState then return end
local st = { hooked = {}, conns = {} }
F._atpState = st
local dead = F.SpeedAntiTPKillScripts()
local conns = 0
pcall(function()
if type(getconnections) ~= "function" then return end
for _, c in ipairs(getconnections(RS.Heartbeat)) do
local fn = c.Function
local hit = false
pcall(function()
if fn then
local okN, nm = pcall(debug.info, fn, "n")
local okS, sc = pcall(debug.info, fn, "s")
local bag = tostring(okN and nm or "") .. " " .. tostring(okS and sc or "")
bag = bag:lower()
for _, k in ipairs(F.ANTITP_KEYS) do
if bag:find(k, 1, true) then hit = true break end
end
end
end)
if hit then
pcall(function() c:Disable() end)
st.conns[#st.conns + 1] = c
conns = conns + 1
end
end
end)
local neutered = 0
pcall(function()
if type(getgc) ~= "function" or type(hookfunction) ~= "function" then return end
for _, fn in ipairs(getgc(true)) do
if type(fn) == "function" and not st.hooked[fn] then
local okN, nm = pcall(debug.info, fn, "n")
if okN and type(nm) == "string" and F.ANTITP_FNS[nm:lower()] then
local okS, sc = pcall(debug.info, fn, "s")
local bag = tostring(okS and sc or ""):lower()
for _, k in ipairs(F.ANTITP_KEYS) do
if bag:find(k, 1, true) then
local ok, orig = pcall(function() return hookfunction(fn, function() return nil end) end)
if ok and type(orig) == "function" then
st.hooked[fn] = orig
neutered = neutered + 1
end
break
end
end
end
end
end
end)
pcall(function()
st.addConn = LP.PlayerScripts.DescendantAdded:Connect(function(inst)
if not F._atpState then return end
pcall(function()
local nm = tostring(inst.Name):lower()
for _, k in ipairs(F.ANTITP_KEYS) do
if nm:find(k, 1, true) then if os.clock() - (F._atpAddAt or 0) > 2 then F._atpAddAt = os.clock() task.defer(F.SpeedAntiTPKillScripts) end break end
end
end)
end)
end)
F.Out(string.format("[防拉回] 已清理 %d 个客户端检测脚本 · 禁用 %d 条检测连接 · 中和 %d 个检测函数(公开作品同款做法)",
dead, conns, neutered))
end
F.HIT_KEYS = { "rigsync", "knockback", "knock", "ragdoll", "combatservice", "useitem",
"stun", "tumble", "pushed", "fling", "blown", "launch",
"damage", "hit", "attack", "punch", "slap", "strike", "melee", "shoot", "bullet",
"projectile", "shove", "impulse", "explode", "blast", "yeet", "swing", "slash",
"hitplayer", "hurt", "takedamage", "dealdamage", "applyforce" }
F.HIT_STATES = { "Ragdoll", "FallingDown", "Physics" }
F._hitConn = nil
function F.HitGuardScan(verbose)
local found = {}
pcall(function()
local pk = RStorage:FindFirstChild("Packages")
local nw = pk and pk:FindFirstChild("Networking")
local known = nw and nw:FindFirstChild("RE/RigSync/Refresh")
if known then found[#found + 1] = known end
end)
pcall(function()
for _, d in ipairs(F.walk(RStorage, 12000)) do
local cn = tostring(d.ClassName)
if cn == "RemoteEvent" or cn == "UnreliableRemoteEvent" then
local nm = tostring(d.Name):lower()
for _, k in ipairs(F.HIT_KEYS) do
if nm:find(k, 1, true) then found[#found + 1] = d break end
end
end
end
end)
if verbose then
local names = {}
for i = 1, math.min(#found, 8) do names[i] = found[i].Name end
F.Out("[受击] 命中 " .. tostring(#found) .. " 个疑似「击退/受击」远程: " .. table.concat(names, " · ")
.. (#found > 8 and " …" or ""))
end
return found
end
function F.HitGuardDisable()
if F._hitConn then F._hitConn:Disconnect() F._hitConn = nil end
if F._hitRemotes then
for _, re in ipairs(F._hitRemotes) do
pcall(function()
for _, c in ipairs(getconnections(re.OnClientEvent)) do
pcall(function() if c.Enable then c:Enable() end end)
end
end)
end
end
F._hitRemotes = nil
local _, hum = GC()
if hum then
for _, k in ipairs(F.HIT_STATES) do
pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType[k], true) end)
end
end
end
function F.HitGuardEnable(strong)
if F._hitConn then return end
F._hitRemotes = {}
local n = 0
if strong then
for _, re in ipairs(F.HitGuardScan(true)) do
pcall(function()
for _, c in ipairs(getconnections(re.OnClientEvent)) do
pcall(function() if c.Disable then c:Disable() n = n + 1 end end)
end
end)
F._hitRemotes[#F._hitRemotes + 1] = re
end
F.Out("[受击] 【猛档】已禁用 " .. tostring(n) .. " 条「被打时游戏自己的处理」")
F.Out("[受击] ⚠ 这些通道往往同时承担角色状态同步 ⇒ 可能出现「搬完了还停在拿起状态」。"
.. "真遇到就把防护档位调回「稳身 + 受击保护」并重进一次游戏")
else
F.Out("[受击] 已开启(状态法): 不打断任何远程 —— 只在本地不让你倒地/被击飞, 不会再卡住搬运状态")
end
F._hitConn = RS.Heartbeat:Connect(function()
if not T.HitGuard then F.HitGuardDisable() return end
local _, hum, root = GC()
if not (hum and root) then return end
for _, k in ipairs(F.HIT_STATES) do
pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType[k], false) end)
end
local st = nil
pcall(function() st = hum:GetState() end)
if F.OnMovingFloorC() and st ~= Enum.HumanoidStateType.Ragdoll
and st ~= Enum.HumanoidStateType.FallingDown and st ~= Enum.HumanoidStateType.Physics then
return
end
if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
or st == Enum.HumanoidStateType.Physics then
pcall(function() hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics) end)
local ch = LP.Character
if ch then
pcall(function()
for _, v in ipairs(ch:GetDescendants()) do
if v:IsA("Motor6D") and not v.Enabled then v.Enabled = true
elseif v:IsA("Constraint") and v.Enabled and v.Name ~= "RootJoint" then v.Enabled = false end
end
end)
end
end
end)
end
F.DROP_KEYS = { "dropheld", "droppet", "dropheldegg", "dropitem", "dropcarry", "releaseheld",
"dropbrainrot" }
F.BLOCK_REMOTE_KEYS = {
"trap", "snare", "cage", "stun", "mousetrap", "beartrap", "ratstrap",
"caught", "arrested", "handcuff", "jailed", "wanted", "guardcatch", "guardhit", "securityhit",
}
F.ALLOW_REMOTE_KEYS = {
"request", "sync", "get", "steal", "place", "equip", "interact", "prompt", "purchase",
"buy", "sell", "trade", "open", "claim", "collect", "use", "fire", "trigger", "update",
"fetch", "query", "send", "notify", "progress", "tutorial", "lobby", "teleport", "spawn",
}
F.TRAP_TAGS = { "PlayerTrap", "Trap", "PlayerTraps", "GuardTrap", "TrapPart", "BearTrap", "ActiveTrap" }
F.TrapKillTouch = function(part)
if not part or typeof(part) ~= "Instance" then return false end
F._trapTouchKilled = F._trapTouchKilled or {}
if F._trapTouchKilled[part] then return false end
local ti = nil
pcall(function() ti = part:FindFirstChild("TouchInterest", true) end)
if not ti then
pcall(function() ti = part:FindFirstChildWhichIsA("TouchTransmitter", true) end)
end
if not ti then return false end
local ok = pcall(function() ti:Destroy() end)
if ok then
F._trapTouchKilled[part] = true
F._trapTouchCount = (F._trapTouchCount or 0) + 1
local now = os.clock()
if now - (F._trapTouchLog or 0) > 3 then
F._trapTouchLog = now
F.Out("[反陷阱] 已解除 " .. tostring(F._trapTouchCount) .. " 个陷阱的触碰(销毁 TouchInterest)"
.. " ⇒ 这个陷阱踩上去不会再触发(公开作品同款做法)")
end
return true
end
return false
end
F.TrapFromTags = function()
local out = {}
pcall(function()
local CS = game:GetService("CollectionService")
for _, tg in ipairs(F.TRAP_TAGS) do
for _, inst in ipairs(CS:GetTagged(tg)) do
if inst and inst.Parent then out[#out + 1] = inst end
for _, d in ipairs(inst:GetDescendants()) do
if d:IsA("BasePart") then out[#out + 1] = d end
end
end
end
end)
return out
end
F.TrapTagWatch = function(on)
if on then
if F._trapTagWatch then return end
F._trapTagWatch = {}
pcall(function()
local CS = game:GetService("CollectionService")
for _, tg in ipairs(F.TRAP_TAGS) do
F._trapTagWatch[#F._trapTagWatch + 1] = CS:GetInstanceAddedSignal(tg):Connect(function(inst)
if not T.TrapWarn then return end
task.defer(function()
pcall(function() F.TrapKillTouch(inst) end)
pcall(function()
for _, d in ipairs(inst:GetDescendants()) do
if d:IsA("BasePart") then F.TrapKillTouch(d) end
end
end)
end)
end)
end
end)
elseif F._trapTagWatch then
for _, c in ipairs(F._trapTagWatch) do pcall(function() c:Disconnect() end) end
F._trapTagWatch = nil
end
end
F.TRAP_KEYS = { "trap", "bear", "spike", "snare", "landmine", "mine", "banana", "cage", "jail",
"net", "hook", "poison", "lava", "saw", "trapdoor", "shock", "taser", "tnt",
"mousetrap", "rats", "stun", "web", "tangle", "glue", "pitfall", "spring", "clamp", "vise",
"hazard", "damage", "killbrick", "killzone", "deadly", "deathzone", "void", "abyss",
"flame", "burn", "acid", "electric", "laser", "blade", "crusher", "press", "pendulum",
"dart", "arrow", "bomb", "explosive", "grenade", "freeze", "ice", "sticky", "quicksand",
"vine", "rope", "chain", "prison", "cell", "trapzone", "deathplane", "instakill" }
F._trapConn = nil
function F.TrapGuardDisable()
pcall(F.TrapTagWatch, false)
if F._trapConnOff then
local back = 0
for _, list in pairs(F._trapConnOff) do
for _, c in ipairs(list) do
pcall(function() if c.Enable then c:Enable() end end)
back = back + 1
end
end
F._trapConnOff = {}
if back > 0 then F.Out("[反陷阱] 已恢复 " .. tostring(back) .. " 条陷阱的触碰回调") end
end
if F._trapConn then F._trapConn:Disconnect() F._trapConn = nil end
if F._trapBak then
for obj, bak in pairs(F._trapBak) do
pcall(function() if obj and obj.Parent then obj.CanTouch = bak.touch end end)
end
F._trapBak = nil
end
end
function F.TrapGuardEnable()
if F._trapConn then return end
F._trapAt = 0
F._trapBak = F._trapBak or {}
F._trapConnOff = F._trapConnOff or {}
pcall(F.TrapTagWatch, true)
F._trapConn = RS.Heartbeat:Connect(function()
if not T.TrapWarn then F.TrapGuardDisable() return end
local now = os.clock()
if now - (F._trapAt or 0) < 0.7 then return end
F._trapAt = now
local _, _, root = GC()
if not root then return end
local hits = 0
pcall(function()
local op = OverlapParams.new()
op.FilterType = Enum.RaycastFilterType.Exclude
if LP.Character then op.FilterDescendantsInstances = { LP.Character } end
for _, pt in ipairs(workspace:GetPartBoundsInRadius(root.Position, 22, op)) do
local nm = tostring(pt.Name):lower()
local isTrap = false
for _, k in ipairs(F.TRAP_KEYS) do
if nm:find(k, 1, true) then isTrap = true break end
end
if isTrap then
hits = hits + 1
if pt.CanTouch then
pcall(function()
F._trapBak[pt] = { touch = pt.CanTouch }
pt.CanTouch = false
end)
end
pcall(function() F.TrapKillTouch(pt) end)
if not F._trapConnOff[pt] then
F._trapConnOff[pt] = {}
pcall(function()
if type(getconnections) ~= "function" then return end
for _, c in ipairs(getconnections(pt.Touched) or {}) do
pcall(function() if c.Disable then c:Disable() end end)
F._trapConnOff[pt][#F._trapConnOff[pt] + 1] = c
end
end)
end
end
end
end)
if hits > 0 and not F._trapOnLog then
F._trapOnLog = true
F.Out("[反陷阱] 已开(只做『不触发』, 和反攻击一样不挪你): "
.. "① 销毁陷阱的 TouchInterest(踩上去不触发的真正解法) ② 按 tag(PlayerTrap 等)识别新陷阱 "
.. "③ 拦陷阱触发上报 ④ 断陷阱自身的 Touched 回调 —— 不动你的位置、不关你身体的「可触碰」")
end
pcall(function()
for _, tgPart in ipairs(F.TrapFromTags()) do
if tgPart:IsA("BasePart") then F.TrapKillTouch(tgPart) end
end
end)
if hits > 0 and now - (F._trapLogAt or 0) > 5 then
F._trapLogAt = now
F._trapHits = (F._trapHits or 0) + hits
F.Out("[陷阱] 附近 " .. tostring(hits) .. " 个陷阱已处理(陷阱自身+你的身体双重拦截) · 累计 " .. tostring(F._trapHits))
end
end)
end
F._steadyConn = nil
local STEADY_STATES = { "Ragdoll", "FallingDown" }
function F.SteadyStates(on)
local _, hum = GC()
if not hum then return end
for _, k in ipairs(STEADY_STATES) do
pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType[k], on and true or false) end)
end
end
function F.SteadyDisable()
if F._steadyConn then F._steadyConn:Disconnect() F._steadyConn = nil end
pcall(function() F.SteadyStates(true) end)
end
function F.SteadyEnable()
if F._steadyConn then return end
F._steadyHits = 0
pcall(function() F.SteadyStates(false) end)
F._steadyConn = RS.Heartbeat:Connect(function()
if not T.SteadyOn then F.SteadyDisable() return end
local _, hum, root = GC()
if not (hum and root) then return end
if not hum.PlatformStand then
if (F._steadySetFor ~= hum) or (os.clock() - (F._steadySetAt or 0) > 5) then
F._steadySetFor, F._steadySetAt = hum, os.clock()
pcall(function() F.SteadyStates(false) end)
end
end
if F.OnMovingFloorC() then
if not F._steadyFloorLog then
F._steadyFloorLog = true
if not F._floorLoggedNow then F._floorLoggedNow = true F.Out("[稳身] 检测到跑步机/移动平台 ⇒ 本项暂时让路(免得把你甩下来)") end
end
return
end
F._steadyFloorLog = nil F._floorLoggedNow = nil
local st = nil
pcall(function() st = hum:GetState() end)
if st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Ragdoll then
pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
F._steadyHits = (F._steadyHits or 0) + 1
end
local v = root.AssemblyLinearVelocity
local okSt = (st == Enum.HumanoidStateType.Jumping or st == Enum.HumanoidStateType.Freefall
or st == Enum.HumanoidStateType.Climbing or hum.PlatformStand)
if v.Y > 90 and not okSt then
pcall(function() root.AssemblyLinearVelocity = Vector3.new(v.X, 40, v.Z) end)
end
end)
end
F.HitboxBackup = {}
F._authorityServer = nil
F._authorityMode = nil
function F.AuthorityGuard(verbose)
local mode = nil
pcall(function() mode = workspace.AuthorityMode end)
if mode == nil then pcall(function() mode = workspace:GetAttribute("AuthorityMode") end) end
local srv = false
if mode ~= nil then
local s = tostring(mode):lower()
srv = (s:find("server", 1, true) ~= nil)
end
F._authorityServer = srv
F._authorityMode = mode
if srv and verbose then
F.Out("[CheatMenu] ⚠ AuthorityMode=Server: 位移/速度由服务端权威裁决, 飞行/加速命中率会明显下降")
end
return mode, srv
end
F._srv = {
own = nil, ownAt = 0, holdConn = nil, takeOK = false,
snap = 0, snapMax = 0, bad = 0, expectMove = 0, dir = nil,
lastPos = nil, landAt = 0,
}
function F.SrvFPS()
local f = 60
pcall(function() f = workspace:GetRealPhysicsFPS() end)
return math.clamp(tonumber(f) or 60, 30, 240)
end
function F.SrvOwnInfo()
local _, hum, root = GC()
local o = { hasRoot = root ~= nil, owner = nil, ownerName = "(无角色)", serverOwned = nil }
if not root then return o end
pcall(function() o.owner = root:GetNetworkOwner() end)
o.ownerName = o.owner and o.owner.Name or "nil(服务端持有)"
o.serverOwned = (o.owner == nil)
o.anchored = root.Anchored
o.humState = "(未知)"
pcall(function() o.humState = tostring(hum:GetState()) end)
F._srv.own = o
return o
end
function F.SrvOwnTake(verbose)
local ch, _, root = GC()
if not (ch and root) then return false end
local parts = { root }
pcall(function()
for _, p in ipairs(ch:GetDescendants()) do
if p:IsA("BasePart") then parts[#parts + 1] = p end
end
end)
for _, p in ipairs(parts) do
pcall(function() p:SetNetworkOwner(LP) end)
pcall(function()
if type(sethiddenproperty) == "function" then
sethiddenproperty(p, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
end
end)
end
F._srv.ownAt = os.clock()
local got = false
pcall(function() local _, _, r2 = GC() if r2 then got = (r2:GetNetworkOwner() == LP) end end)
F._srv.takeOK = got
if verbose then
F.Out("[Srv] 夺取网络所有权: 部件 " .. tostring(#parts) .. " 个, 回读 = " ..
(got and "本地(成功)" or "仍非本地 / 读不到(该游戏可能持续抢回)"))
end
return got
end
function F.SrvProbe(step, sec)
local _, _, root = GC()
if not root then return nil end
step = tonumber(step) or (F.LIMITS and F.LIMITS.PROBE_STEP) or 4
sec = tonumber(sec) or 2
local cam = workspace.CurrentCamera
local dir = cam and cam.CFrame.LookVector or Vector3.new(1, 0, 0)
dir = Vector3.new(dir.X, 0, dir.Z)
if dir.Magnitude < 0.01 then dir = Vector3.new(1, 0, 0) end
dir = dir.Unit
local startPos = root.Position
local intended, n, t0 = 0, 0, os.clock()
while os.clock() - t0 < sec do
local _, _, r = GC()
if not r then break end
r.CFrame = r.CFrame + dir * step
intended = intended + step
n = n + 1
RS.Heartbeat:Wait()
end
local _, _, r2 = GC()
if not r2 then return nil end
local actual = (r2.Position - startPos):Dot(dir)
local ratio = (intended > 0) and (actual / intended) or 0
return { step = step, sec = sec, frames = n, intended = intended,
actual = actual, ratio = ratio, fps = n / math.max(sec, 0.001) }
end
function F.SrvOneClick()
task.spawn(function()
local o = F.SrvOwnInfo()
local L = {}
L[#L + 1] = string.format("物理帧率 %.0f · 本脚本不做任何限速(上限就是你在滑块上写的数)", F.SrvFPS())
L[#L + 1] = "① 网络所有权(HRP) = " .. tostring(o.ownerName)
if o.serverOwned then
if F.SrvOwnTake(true) then
L[#L + 1] = "② 已夺取所有权: 回读=本地 ✓"
else
L[#L + 1] = "② ⛔ 抢不回所有权 ⇒ **该游戏位移类功能不可行**(服务端持有, 不是参数问题)"
end
else
L[#L + 1] = "② 所有权本来就在本地 ✓"
end
F.Out("[诊断] ⚠ 探针会向服务端发送约 120 次强位移 —— AuthorityMode=Server 时可能被记录/踢")
local step = F.LIMITS.PROBE_STEP
local r = F.SrvProbe(step, 2)
if not r then
L[#L + 1] = "③ 探针: 没有角色, 无法测"
else
L[#L + 1] = string.format("③ 探针(单帧 %.2f): 意图 %.0f / 实走 %.0f ⇒ 通过率 %.0f%%",
r.step, r.intended, r.actual, r.ratio * 100)
if r.ratio < 0.9 then
L[#L + 1] = "④ 通过率不足 ⇒ 位移正被服务端搬回。★ 本脚本不再自动降速, 降不降由你决定"
else
L[#L + 1] = "④ 当前档位被服务端接受"
end
end
F.Out("──── 反拉回诊断 ────")
for _, s in ipairs(L) do F.Out("  " .. s) end
F.Out("────────────────────")
if Fluent and Fluent.Notify then
Fluent:Notify({ Title = "反拉回诊断", Content = table.concat(L, "\n"), Duration = 15 })
end
end)
end
F._baseWalk = nil
F._preSpeed = nil
F._spdConn, F._flyConn = nil, nil
F._flyBv, F._flyBg, F._flyAp, F._flyAo, F._flyAtt = nil, nil, nil, nil, nil
F._probe, F._probeAt = {}, 0
function F.SpeedProbe(r, tag, sp, dt, full3d)
if not r or not sp then return end
local now = os.clock()
local flat = full3d and r.Position or Vector3.new(r.Position.X, 0, r.Position.Z)
local p = F._probe[tag]
if not p then F._probe[tag] = { t = now, pos = flat, sp = sp } return end
local span = now - p.t
if span < 0.6 then return end
local set = tonumber(p.sp) or sp
local actual = (flat - p.pos).Magnitude / span
local stale = span > 1.5
F._probe[tag] = { t = now, pos = flat, sp = sp }
if stale then return end
local ratio = (set > 1) and (actual / set) or 1
F._probeRep = F._probeRep or {}
local rep = F._probeRep[tag]
if ratio >= 0.85 then
if rep and rep.sp == set and rep.ok then return end
F._probeRep[tag] = { sp = set, ok = true }
else
if rep and rep.sp == set and (not rep.ok) and (now - (rep.t or 0)) < 20 then return end
F._probeRep[tag] = { sp = set, ok = false, t = now }
end
local verdict
if ratio >= 0.85 then
verdict = " · 达标(设定值就是真实速度)"
elseif ratio >= 0.5 then
verdict = " · 中间(多半是撞墙/贴障碍/地形摩擦, 到开阔地再看一次)"
else
verdict = " · 偏低(引擎物理或服务端在压速度, 不是脚本虚标)"
end
F.Out(string.format("[速度自检·%s] 设定 %.0f 格/秒 → 实测 %.0f 格/秒 (%.0f%%)%s",
tostring(tag), set, actual, ratio * 100, verdict))
end
F._invSav, F._invConn = nil, nil
function F.InvisibleEnable()
pcall(function()
local _, hum = GC()
if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
end)
if F._invSav then return end
local ch = LP.Character
if not ch then F.Out("[隐身] 现在没有角色, 等进游戏再开") return end
F._invSav = {}
local n = 0
pcall(function()
for _, o in ipairs(ch:GetDescendants()) do
if o:IsA("BasePart") or o:IsA("Decal") then
F._invSav[o] = o.Transparency
o.Transparency = 1
n = n + 1
end
end
end)
F._invConns = {}
local function apply(ch2)
task.wait(0.3)
if not F._invSav then return end
pcall(function()
for _, o in ipairs(ch2:GetDescendants()) do
if o:IsA("BasePart") or o:IsA("Decal") then
if F._invSav[o] == nil then F._invSav[o] = o.Transparency end
o.Transparency = 1
end
end
end)
end
pcall(function() F._invConns[1] = LP.CharacterAdded:Connect(apply) end)
pcall(function()
F._invConns[2] = ch.DescendantAdded:Connect(function(o)
if not F._invSav then return end
if o:IsA("BasePart") or o:IsA("Decal") then
F._invSav[o] = o.Transparency
pcall(function() o.Transparency = 1 end)
end
end)
end)
pcall(function()
local hum = ch:FindFirstChildOfClass("Humanoid")
if hum then
F._invSavDist = hum.NameDisplayDistance
F._invSavHealthDist = hum.HealthDisplayDistance
hum.NameDisplayDistance = 0
hum.HealthDisplayDistance = 0
end
end)
F._invConn = RS.Heartbeat:Connect(function()
if not T.Invisible then pcall(F.InvisibleDisable) return end
local _, _, root = GC()
if root and root.Transparency ~= 1 then pcall(function() root.Transparency = 1 end) end
end)
F.Out("[隐身] 已开: " .. tostring(n) .. " 个部件 Transparency=1(会复制给所有人) + 名字/血条距离=0"
.. " —— 服务端若有「透明检测」会把你拉回, 那不是脚本的问题")
end
function F.InvisibleDisable()
if F._invConns then
for _, c in ipairs(F._invConns) do pcall(function() c:Disconnect() end) end
F._invConns = nil
end
if F._invConn then pcall(function() F._invConn:Disconnect() end) F._invConn = nil end
if F._invSav then
for o, t in pairs(F._invSav) do
if typeof(o) == "Instance" and o.Parent then pcall(function() o.Transparency = t end) end
end
end
F._invSav = nil
pcall(function()
local ch = LP.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hum then
if F._invSavDist then hum.NameDisplayDistance = F._invSavDist end
if F._invSavHealthDist then hum.HealthDisplayDistance = F._invSavHealthDist end
end
end)
F._invSavDist, F._invSavHealthDist = nil, nil
F.Out("[隐身] 已关, 透明度已还原")
end
function F.CarryFind()
local ch = LP.Character
if not ch then return {} end
local out = {}
for _, host in ipairs(ch:GetDescendants()) do
if host:IsA("BasePart") then
for _, w in ipairs(host:GetChildren()) do
local okW = (w:IsA("WeldConstraint") or w:IsA("Weld") or w:IsA("Motor6D"))
if okW then
local other = nil
pcall(function()
if w.Part0 == host then other = w.Part1 elseif w.Part1 == host then other = w.Part0 end
end)
if other and other.Parent and not other:IsDescendantOf(ch) then
out[#out + 1] = { host = host, other = other, name = w.Name, cls = w.ClassName }
end
end
end
end
end
return out
end
function F.CarryGuardTick()
local ch = LP.Character
if not ch or type(F._carry) ~= "table" then return end
for _, rec in ipairs(F._carry) do
local host, other = rec.host, rec.other
if host and host.Parent and other and other.Parent then
local alive = false
for _, w in ipairs(host:GetChildren()) do
if w.Name == rec.name and (w:IsA("WeldConstraint") or w:IsA("Weld") or w:IsA("Motor6D")) then alive = true break end
end
if not alive then
local nw = nil
pcall(function()
nw = Instance.new(rec.cls)
if rec.cls == "WeldConstraint" then
nw.Part0, nw.Part1 = host, other
else
nw.Part0, nw.Part1 = host, other
nw.C0, nw.C1 = CFrame.new(), CFrame.new()
end
nw.Name = rec.name
nw.Parent = host
end)
if nw then
F._carryBack = (F._carryBack or 0) + 1
if os.clock() - (F._carryLogAt or 0) > 3 then
F._carryLogAt = os.clock()
F.Out("[搬守卫] 固定它的焊点被拆掉了 ⇒ 已按原样重新焊回 " .. tostring(F._carryBack) .. " 次(名字: " .. tostring(rec.name) .. ")")
end
end
end
end
end
end
F.SuicideNow = function()
local ch, hum, root = GC()
if not (hum and ch) then
F.Out("[自杀] 没有角色, 现在不能重置")
return
end
local bag = 0
pcall(function()
for _, c in ipairs(ch:GetChildren()) do
if c:IsA("Tool") then bag = bag + 1 end
end
end)
local done = false
pcall(function()
for _, nm in ipairs({ "Reset", "ResetCharacter", "Respawn", "ResetPlayer" }) do
local rf = ch:FindFirstChild(nm)
if rf then
if rf:IsA("RemoteEvent") then
rf:FireServer()
done = true
elseif rf:IsA("RemoteFunction") then
pcall(function() rf:InvokeServer() end)
done = true
end
if done then break end
end
end
end)
if done then
F.Out("[自杀] 已用游戏自己的重置通道重生" .. (bag > 0 and (" ⚠ 手上还有 " .. tostring(bag) .. " 个东西, 会掉") or ""))
else
pcall(function() hum.Health = 0 end)
F.Out("[自杀] 已把血量归零重生" .. (bag > 0 and (" ⚠ 手上还有 " .. tostring(bag) .. " 个东西, 会掉") or ""))
end
pcall(function()
Fluent:Notify({ Title = "自杀/重置", Content = bag > 0
and ("已重生 ⚠ 手上的 " .. tostring(bag) .. " 个东西会掉") or "已重生", Duration = 4 })
end)
F._walkTgt = nil
F._egg, F._eggPart, F._carry = nil, nil, nil
end
F.EggLock = function()
local ch = LP.Character
if not ch then F._egg, F._eggPart = nil, nil return end
local toolEgg = nil
pcall(function()
for _, c in ipairs(ch:GetChildren()) do
if c:IsA("Tool") then
local it = nil
pcall(function() it = c:GetAttribute("ItemType") end)
local nm = tostring(c.Name):lower()
if (type(it) == "string" and (it:lower():find("egg") or it:lower():find("asset")))
or nm:find("egg") or nm:find("brainrot") then
toolEgg = c
end
end
end
end)
if toolEgg then
local part = toolEgg:FindFirstChildWhichIsA("BasePart")
F._egg, F._eggPart, F._eggHand, F._eggBack = toolEgg, (part or toolEgg), F._eggHand, 0
F.Out("[蛋守卫] 锁定: 手里的工具 " .. tostring(toolEgg.Name)
.. " (Tool + ItemType 识别, 同族脚本同款做法)")
return
end
local carried = F.CarryFind()
if #carried > 0 then
local rec = carried[1]
F._egg, F._eggPart, F._eggHand, F._eggBack = rec.other, rec.other, rec.host, 0
F.Out("[蛋守卫] 锁定: " .. tostring(rec.other.Name) .. " (来自焊点 " .. tostring(rec.name)
.. " 的另一端) —— 这才是「手上的东西」的可靠识别")
return
end
local hand = ch:FindFirstChild("RightHand") or ch:FindFirstChild("LeftHand")
or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")
or ch:FindFirstChild("HumanoidRootPart")
F._eggHand = hand
local hp = hand and hand.Position
if not hp then F._egg, F._eggPart = nil, nil return end
local best, bot, bd, seen = nil, nil, 13, 0
for _, o in ipairs(workspace:GetDescendants()) do
seen = seen + 1
if seen > 6000 then break end
if (o:IsA("Model") or o:IsA("BasePart")) and not o:IsDescendantOf(ch)
and not Players:GetPlayerFromCharacter(o) then
local q = o:IsA("Model") and (o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")) or o
if q and q.Parent then
local d = (q.Position - hp).Magnitude
if d < bd then bd, best, bot = d, o, q end
end
end
end
F._egg, F._eggPart, F._eggBack = best, bot, 0
F.Out("[蛋守卫] 没找到焊点, 退化为按距离找: " .. (best and (best.Name .. " (" .. string.format("%.1f", bd) .. " 格)")
or "还是没找到(站近点, 或者这个游戏不是焊接式搬运)"))
end
function F.EggGuardTick()
local ch = LP.Character
if not ch then return end
local hand = F._eggHand
if not (hand and hand.Parent) then
hand = ch:FindFirstChild("RightHand") or ch:FindFirstChild("LeftHand")
or ch:FindFirstChild("Torso") or ch:FindFirstChild("HumanoidRootPart")
F._eggHand = hand
end
local obj, q = F._egg, F._eggPart
if not (obj and obj.Parent and q and q.Parent and hand) then
if not F._eggGone then
F._eggGone = true
F.Out("[蛋守卫] 手上那个物体已经不在场内(被服务端收走/销毁) ⇒ 守卫暂停")
end
return
end
local d = (q.Position - hand.Position).Magnitude
if d > 8 then
local dest = hand.Position + Vector3.new(0, 1.2, 0)
pcall(function() q.CFrame = q.CFrame - q.CFrame.Position + dest end)
F._eggBack = (F._eggBack or 0) + 1
if os.clock() - (F._eggLogAt or 0) > 3 then
F._eggLogAt = os.clock()
F.Out(string.format("[蛋守卫] 它离手 %.0f 格 ⇒ 已拉回手上 %d 次(客户端保持在手; 服务端认不认是另一回事)",
d, F._eggBack))
end
end
end
F._pinConn, F._pinAp, F._pinAtt = nil, nil, nil
function F.PinDisable()
if F._pinConn then pcall(function() F._pinConn:Disconnect() end) F._pinConn = nil end
for _, k in ipairs({ "_pinAp", "_pinAtt" }) do
if F[k] then pcall(function() F[k]:Destroy() end) F[k] = nil end
end
end
F.PinPulse = function(dest, secs)
if not dest then return end
if F._pinPulseConn then pcall(function() F._pinPulseConn:Disconnect() end) F._pinPulseConn = nil end
local endT = os.clock() + (secs or 0.3)
F._pinPulseConn = RS.Heartbeat:Connect(function()
if os.clock() > endT then
if F._pinPulseConn then pcall(function() F._pinPulseConn:Disconnect() end) F._pinPulseConn = nil end
return
end
local _, _, r = GC()
if not r then return end
local cur = r.Position
local d = Vector3.new(dest.X - cur.X, 0, dest.Z - cur.Z)
if d.Magnitude > 0.5 then
pcall(function()
r.CFrame = CFrame.new(cur + d * 0.5) * (r.CFrame - cur)
end)
end
end)
end
F.DropIntent = function()
F._intent = nil
if KG then KG.intent, KG.dev = nil, nil end
end
F.bypassConn = nil
function F.BypassEnable()
if F.bypassConn then return end
F.Out("[反拉回] 提示: 需要「清检测脚本/断检测连接/中和检测函数」那种猛招的话, 防护里单独开「防拉回档」(那层动作最招反作弊)")
local got = false
pcall(function() got = F.SrvOwnTake(false) end)
F._bypassOwnAt = os.clock()
F.bypassConn = RS.Heartbeat:Connect(function()
if not T.BypassDetect then F.BypassDisable() return end
local now = os.clock()
if now - (F._bypassOwnAt or 0) > 1.2 then
F._bypassOwnAt = now
if T.SpeedOn or T.FlyOn then
local owner = nil
pcall(function()
local _, _, r3 = GC()
if r3 then owner = r3:GetNetworkOwner() end
end)
if owner ~= LP then
F._bypassOwnOK = pcall(F.SrvOwnTake, false)
end
end
end
end)
F.Out("[绕过] 网络所有权回读: " .. (got and "本地(拿到)" or "仍非本地 ⇒ 这游戏持续抢回, 靠「被拉回就续跑」硬顶"))
F.Out("[绕过] 已开启: 所有权**只在被夺走时**才抢(平时零干预) + 被拉回才顶回")
end
function F.BypassDisable()
if F.bypassConn then pcall(function() F.bypassConn:Disconnect() end) F.bypassConn = nil end
if F.DropIntent then pcall(F.DropIntent) end
F._bypassOwnAt = nil
if F._bypassAtp then
F._bypassAtp = nil
pcall(F.SpeedAntiTPDisable)
end
F.Out("[绕过] 已关闭(所有权交回引擎管理, 速度不再用位移补足)")
end
function F.DriveConnect(fn)
if RS.PreSimulation then
local ok, c = pcall(function() return RS.PreSimulation:Connect(function(dt) fn(dt) end) end)
if ok and c then return c end
end
return RS.Stepped:Connect(function(_, dt) fn(dt) end)
end
function F.SpeedApply()
if not T.SpeedOn then return end
if T.FlyOn then return end
local _, hum = GC()
if not hum then return end
if tostring(C.SpeedDrive or ""):find("意图", 1, true) then return end
pcall(function() hum.WalkSpeed = tonumber(C.SpeedValue) or 60 end)
end
function F.SpeedRestore()
local back = tonumber(F._preSpeed) or tonumber(F._orig and F._orig.walk)
F._preSpeed = nil
if not back or back <= 0 or back < 1 then return false end
local _, hum = GC()
if not hum then return false end
local cur = tonumber(hum.WalkSpeed) or 0
if cur > back then back = cur end
F._maxWalk = math.max(F._maxWalk or 0, back, cur)
back = math.max(back, F._maxWalk)
pcall(function() hum.WalkSpeed = back end)
if F._spdHold then F._spdHold = false end
F._spdHold = true
task.spawn(function()
local t0 = os.clock()
while F._spdHold and (os.clock() - t0) < 1.5 do
if T.SpeedOn then break end
local _, h2 = GC()
if h2 then pcall(function() h2.WalkSpeed = back end) end
task.wait(0.05)
end
F._spdHold = nil
end)
F.Out(string.format("[加速] 已还原你开加速之前的 WalkSpeed = %.1f (并在 1.5 秒内压住游戏写回的低值)", back))
return true
end
function F.SpeedSet(on)
if on then pcall(F.BypassAutoRaise, "你开了加速") end
local want = on and true or false
if F._spdConn then F._spdConn:Disconnect() F._spdConn = nil end
T.SpeedOn = want
if not want then
F.SpeedRestore()
return
end
local _, hum = GC()
if hum then
local cur = tonumber(hum.WalkSpeed)
if cur and cur > 0 and not F._preSpeed then F._preSpeed = cur end
pcall(function() F._maxWalk = math.max(F._maxWalk or 0, tonumber(hum.WalkSpeed) or 0, cur or 0) end)
end
F.SpeedApply()
F._spdConn = F.DriveConnect(function(deltaTime)
if not T.SpeedOn then F.SpeedSet(false) return end
if T.FlyOn then return end
local _, h, r = GC()
if not (h and r) then return end
local sp = tonumber(C.SpeedValue) or 60
local cam = workspace.CurrentCamera
local dir = Vector3.zero
if cam then
local look, right = cam.CFrame.LookVector, cam.CFrame.RightVector
local hl = Vector3.new(look.X, 0, look.Z)
local hr = Vector3.new(right.X, 0, right.Z)
if hl.Magnitude > 0.001 then hl = hl.Unit end
if hr.Magnitude > 0.001 then hr = hr.Unit end
if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + hl end
if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - hl end
if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - hr end
if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + hr end
end
if dir.Magnitude < 0.01 then
local md = h.MoveDirection
dir = Vector3.new(md.X, 0, md.Z)
end
local cur = r.AssemblyLinearVelocity
if dir.Magnitude > 0.01 then
local u = Vector3.new(dir.X, 0, dir.Z)
if u.Magnitude > 0.001 then u = u.Unit else u = Vector3.zero end
local dt = tonumber(deltaTime) or (1 / 60)
if dt < 0.001 then dt = 1 / 60 end
if dt > 0.1 then dt = 0.1 end
local v = u * sp
if tostring(C.SpeedDrive or ""):find("意图", 1, true) then
local base = math.max(1, tonumber(h.WalkSpeed) or 16)
pcall(function() h:Move(u * math.clamp(sp / base, 1, 12)) end)
else
pcall(function() r.AssemblyLinearVelocity = Vector3.new(v.X, cur.Y, v.Z) end)
end
pcall(function()
if r.AssemblyAngularVelocity.Magnitude > 15 then
r.AssemblyAngularVelocity = Vector3.zero
F._flipFix = (F._flipFix or 0) + 1
end
end)
if T.BypassDetect then
local want = sp * dt
local intent = F._intent
if intent then
local cur2 = r.Position
local dxz = Vector3.new(cur2.X - intent.X, 0, cur2.Z - intent.Z)
local dev = dxz.Magnitude
local thr = math.max(6, want * 2)
local rolled = (dev > thr) or (dev > want * 0.5 and dxz.Unit:Dot(u) < -0.3)
if rolled then
local dest = Vector3.new(intent.X, cur2.Y, intent.Z)
pcall(function() r.CFrame = CFrame.new(dest) * (r.CFrame - r.CFrame.Position) end)
pcall(function() F.PinPulse(dest, 0.3) end)
F._tpBack = (F._tpBack or 0) + 1
local t0 = os.clock()
if t0 - (F._tpBackAt or 0) > 3 then
F._tpBackAt = t0
F.Out(string.format("[反拉回] 位置被回滚 %d 次 ⇒ 每次都已立即续跑回原定位置(不倒退)", F._tpBack))
end
intent = dest
end
end
F._intent = (intent or r.Position) + u * want
else
F._intent = nil
F._tpBack = 0
end
F.SpeedProbe(r, "加速", sp, dt)
elseif math.abs(cur.X) > 0.5 or math.abs(cur.Z) > 0.5 then
if tostring(C.SpeedDrive or ""):find("意图", 1, true) then
pcall(function() h:Move(Vector3.zero) end)
else
pcall(function() r.AssemblyLinearVelocity = Vector3.new(0, cur.Y, 0) end)
end
end
if dir.Magnitude <= 0.01 then F._intent = nil end
if T.BypassDetect then
if math.abs((h.WalkSpeed or 0) - (F._preSpeed or h.WalkSpeed or 16)) > 0.5 then
pcall(function() h.WalkSpeed = F._preSpeed or h.WalkSpeed end)
end
elseif tostring(C.SpeedDrive or ""):find("意图", 1, true) then
if math.abs((h.WalkSpeed or 16) - (F._preSpeed or h.WalkSpeed or 16)) > 0.5 then
pcall(function() h.WalkSpeed = F._preSpeed or h.WalkSpeed end)
end
elseif math.abs((h.WalkSpeed or 0) - sp) > 0.5 then
pcall(function() h.WalkSpeed = sp end)
end
local now = os.clock()
if now - (F._animAt or 0) > 0.3 then
F._animAt = now
pcall(function()
local anim = h:FindFirstChildOfClass("Animator")
if anim then
local k = math.clamp(sp / 16, 1, 8)
for _, t in ipairs(anim:GetPlayingAnimationTracks()) do
pcall(function() t:AdjustSpeed(k) end)
end
end
end)
end
end)
end
function F.FlyDestroy()
if F._flyConn then F._flyConn:Disconnect() F._flyConn = nil end
if (not T.FlyOn) and F._flyRebuild then
pcall(function() F._flyRebuild:Disconnect() end)
F._flyRebuild = nil
end
for _, k in ipairs({ "_flyBv", "_flyBg", "_flyAp", "_flyAo", "_flyAtt", "_flyBvAtt" }) do
if F[k] then pcall(function() F[k]:Destroy() end) F[k] = nil end
end
if F._flyCollOff then
for bp, orig in pairs(F._flyCollOff) do
if typeof(bp) == "Instance" and bp.Parent then
pcall(function() bp.CanCollide = orig end)
end
end
F._flyCollOff = nil
end
local _, hum = GC()
if hum then pcall(function() hum.PlatformStand = false end) end
if F._flyJumpReqConn then
pcall(function() F._flyJumpReqConn:Disconnect() end)
F._flyJumpReqConn = nil
end
if F._flyDisabledInfJump then
F._flyDisabledInfJump = nil
if T.InfiniteJump then pcall(F.InfiniteJumpEnable) end
end
end
function F.FlySet(on)
if on then pcall(F.BypassAutoRaise, "你开了飞行") end
T.FlyOn = on and true or false
F.FlyDestroy()
if not T.FlyOn then return end
if T.InfiniteJump and F.JumpConn then
pcall(F.InfiniteJumpDisable)
F._flyDisabledInfJump = true
end
local _, hum, root = GC()
if not (hum and root) then return end
F.Out("[飞行] 已开: 速度驱动(前后左右/上下都按「飞行速度」滑块) + 姿态稳定(始终直立, 不会翻滚)")
pcall(function() hum.PlatformStand = true end)
if F._flyJumpReqConn then F._flyJumpReqConn:Disconnect() end
F._flyJumpReqConn = UIS.JumpRequest:Connect(function()
if T.FlyOn then F._flyJumpAt = os.clock() end
end)
local useAlign = tostring(C.FlyDrive or ""):find("位置约束", 1, true) ~= nil
local okDrive = pcall(function()
local att2 = Instance.new("Attachment")
att2.Name = "CMFlyAtt"
att2.Parent = root
F._flyBvAtt, F._flyAtt = att2, att2
local ao = Instance.new("AlignOrientation")
ao.Name = "CMFlyAo"
ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
ao.Attachment0 = att2
ao.MaxTorque = 1e9
ao.Responsiveness = 120
pcall(function() ao.RigidityEnabled = true end)
ao.Parent = root
F._flyAo = ao
if useAlign then
local ap = Instance.new("AlignPosition")
ap.Name = "CMFlyAp"
ap.Attachment0 = att2
ap.Mode = Enum.PositionAlignmentMode.OneAttachment
ap.Position = root.Position
ap.Responsiveness = 30
ap.MaxForce = 1e9
pcall(function() ap.ApplyAtCenterOfMass = false end)
ap.Parent = root
F._flyAp = ap
else
local bv = Instance.new("LinearVelocity")
bv.Name = "CMFlyBv"
bv.Attachment0 = att2
bv.MaxForce = 1e9
bv.VectorVelocity = Vector3.zero
bv.Parent = root
F._flyBv = bv
end
end)
if not F._flyRebuild then
pcall(function()
F._flyRebuild = LP.CharacterAdded:Connect(function()
task.wait(0.6)
if not T.FlyOn then return end
F.Out("[飞行] 检测到重生 ⇒ 已自动重装约束实例")
pcall(function() F.FlySet(true) end)
end)
end)
end
if not okDrive then
pcall(function()
local att3 = Instance.new("Attachment")
att3.Name = "CMFlyAttOld"
att3.Parent = root
local bv2 = Instance.new("BodyVelocity")
bv2.Name = "CMFlyBv"
bv2.MaxForce = Vector3.new(1e9, 1e9, 1e9)
bv2.Velocity = Vector3.zero
bv2.Parent = root
F._flyBvAtt, F._flyBv = att3, bv2
local bg = Instance.new("BodyGyro")
bg.Name = "CMFlyBg"
bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
bg.D = 50
bg.P = 3000
bg.Parent = root
F._flyBg = bg
end)
end
F._flyConn = F.DriveConnect(function(dt)
if not T.FlyOn then F.FlyDestroy() return end
local _, h, r = GC()
if not (h and r) then return end
if not h.PlatformStand then pcall(function() h.PlatformStand = true end) end
if not F._flyCollOff then
F._flyCollOff = {}
pcall(function()
for _, bp in ipairs(h:GetDescendants()) do
if bp:IsA("BasePart") then
F._flyCollOff[bp] = bp.CanCollide
bp.CanCollide = false
end
end
end)
end
local c = workspace.CurrentCamera
if not c then return end
local dir = Vector3.zero
if UIS.KeyboardEnabled then
if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + c.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - c.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - c.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + c.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
end
local md = h.MoveDirection
if md.Magnitude > 0.01 and UIS.TouchEnabled then
local hLook = Vector3.new(c.CFrame.LookVector.X, 0, c.CFrame.LookVector.Z)
local hRight = Vector3.new(c.CFrame.RightVector.X, 0, c.CFrame.RightVector.Z)
if hLook.Magnitude > 0.001 then hLook = hLook.Unit end
if hRight.Magnitude > 0.001 then hRight = hRight.Unit end
local fwd = md:Dot(hLook)
local side = md:Dot(hRight)
dir = dir + c.CFrame.LookVector * fwd + c.CFrame.RightVector * side
end
if UIS.TouchEnabled and (os.clock() - (F._flyJumpAt or 0) < 0.15) then
dir = dir + Vector3.new(0, 1, 0)
end
local fsp = tonumber(C.FlyValue) or 60
local vel = dir.Magnitude > 0 and (dir.Unit * fsp) or Vector3.zero
if F._flyAp then
local fstep = math.clamp(tonumber(dt) or 0, 0, 0.1)
pcall(function() F._flyAp.Position = r.Position + vel * fstep end)
elseif F._flyBv then
if F._flyBv:IsA("LinearVelocity") then
pcall(function() F._flyBv.VectorVelocity = vel end)
else
pcall(function() F._flyBv.Velocity = vel end)
end
end
pcall(function()
local look = c.CFrame.LookVector
local flat = Vector3.new(look.X, 0, look.Z)
if flat.Magnitude < 0.02 then flat = Vector3.new(0, 0, -1) end
local want = CFrame.lookAt(r.Position, r.Position + flat.Unit)
if F._flyAo then
F._flyAo.CFrame = want
elseif F._flyBg then
F._flyBg.CFrame = want
end
end)
if vel.Magnitude < 0.01 then
pcall(function()
if F._flyAp then F._flyAp.Position = r.Position else r.AssemblyLinearVelocity = Vector3.zero end
r.AssemblyAngularVelocity = Vector3.zero
end)
else
local step = math.clamp(tonumber(dt) or 0, 0, 0.1)
F.SpeedProbe(r, "飞行", fsp, step, true)
end
end)
end
F.JumpConn = nil
function F.InfiniteJumpDisable() if F.JumpConn then F.JumpConn:Disconnect() F.JumpConn = nil end end
function F.InfiniteJumpEnable()
if F.JumpConn then return end
F.JumpConn = UIS.JumpRequest:Connect(function()
if not T.InfiniteJump then return end
local _, hum = GC()
if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
end
F.NoClipConn = nil
F.NoClipParts = {}
function F.NoClipDisable()
pcall(function()
local ch = LP.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hum then
local orig = F.NoClipStateOrig
if orig == nil then orig = true end
hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, orig)
end
end)
if F.NoClipConn then F.NoClipConn:Disconnect() F.NoClipConn = nil end
for part in pairs(F.NoClipParts) do
if typeof(part) == "Instance" and part:IsA("BasePart") and part.Parent then part.CanCollide = true end
end
F.NoClipParts = {}
F.NoClipStateOrig = nil
end
function F.NoClipEnable()
if F.NoClipConn then return end
pcall(function()
local ch = LP.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hum and F.NoClipStateOrig == nil then
F.NoClipStateOrig = hum:GetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics)
end
end)
local function noclip()
local ch = LP.Character
if not ch then return end
local hum = ch:FindFirstChildOfClass("Humanoid")
if hum then pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false) end) end
for _, part in ipairs(ch:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
F.NoClipParts[part] = true
end
end
end
noclip()
F.NoClipConn = RS.Stepped:Connect(noclip)
end
F.HideConn, F.HideBaseY = nil, nil
function F.HideDisable()
if F.HideConn then F.HideConn:Disconnect() F.HideConn = nil end
if F._hideCharConn then pcall(function() F._hideCharConn:Disconnect() end) F._hideCharConn = nil end
pcall(function()
local _, _, r = GC()
if r and F.HideBaseY then r.CFrame = CFrame.new(r.Position.X, F.HideBaseY, r.Position.Z) end
end)
end
function F.HideEnable()
if F.HideConn then return end
local _, _, root = GC()
if root then F.HideBaseY = root.Position.Y end
if not F._hideCharConn then
pcall(function()
F._hideCharConn = LP.CharacterAdded:Connect(function()
task.wait(0.8)
if not T.Hide then return end
local _, _, r = GC()
if r then F.HideBaseY = r.Position.Y end
F.Out("[藏地下] 检测到重生 ⇒ 已按新位置重置基准高度")
end)
end)
end
F.HideConn = RS.RenderStepped:Connect(function()
if not T.Hide then F.HideDisable() return end
local _, _, r = GC()
if not r then return end
local depth = math.min(math.max(C.HideDepth or 5, 1), 30)
r.CFrame = CFrame.new(r.Position.X, F.HideBaseY - depth, r.Position.Z)
local cam = workspace.CurrentCamera
if cam then
local cp = cam.CFrame.Position
if cp.Y < F.HideBaseY - 0.5 then
cam.CFrame = CFrame.new(cp.X, F.HideBaseY, cp.Z) * (cam.CFrame - cam.CFrame.Position)
end
end
end)
end
F.savedLight = nil
F.LightReassert = function()
if not (T.FullBright or T.NightVision or T.NoFog) then return end
local L = game:GetService("Lighting")
if not L then return end
if T.FullBright then
if L.Brightness ~= 2 or L.ClockTime ~= 14 or L.FogEnd ~= 100000 then pcall(F.FullBrightEnable) end
end
if T.NightVision then
if L.Brightness ~= 1.5 or L.ClockTime ~= 0 then pcall(F.NightVisionEnable) end
end
if T.NoFog then
if L.FogEnd ~= 100000 or L.FogStart ~= 100000 then pcall(F.NoFogEnable) end
end
end
F.LightWatchEnable = function()
if F._lightConn then return end
F._lightConn = true
pcall(function()
local L = game:GetService("Lighting")
local props = { "Brightness", "ClockTime", "Ambient", "OutdoorAmbient", "FogEnd", "FogStart", "GlobalShadows" }
F._lightConns = {}
for i = 1, #props do
local c = L:GetPropertyChangedSignal(props[i]):Connect(function()
pcall(F.LightReassert)
end)
F._lightConns[#F._lightConns + 1] = c
end
end)
F._lightLoop = task.spawn(function()
while T.FullBright or T.NightVision or T.NoFog do
task.wait(2)
pcall(F.LightReassert)
end
F._lightLoop = nil
end)
F.Out("[视觉增强] 已挂复写监听: 游戏把光照改回去会自动重设")
end
F.LightWatchDisable = function()
if F._lightConns then
for i = 1, #F._lightConns do pcall(function() F._lightConns[i]:Disconnect() end) end
end
F._lightConns, F._lightConn = nil, nil
F._lightLoop = nil
end
function F.FullBrightEnable()
local L = game:GetService("Lighting")
if not F.savedLight then
F.savedLight = { Brightness = L.Brightness, ClockTime = L.ClockTime, FogEnd = L.FogEnd, GlobalShadows = L.GlobalShadows, Ambient = L.Ambient, OutdoorAmbient = L.OutdoorAmbient }
end
L.Brightness = 2 L.ClockTime = 14 L.FogEnd = 100000 L.GlobalShadows = false
L.Ambient = Color3.fromRGB(255, 255, 255) L.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end
function F.FullBrightDisable()
local L = game:GetService("Lighting")
if not F.savedLight then return end
L.Brightness = F.savedLight.Brightness L.ClockTime = F.savedLight.ClockTime L.FogEnd = F.savedLight.FogEnd
L.GlobalShadows = F.savedLight.GlobalShadows L.Ambient = F.savedLight.Ambient L.OutdoorAmbient = F.savedLight.OutdoorAmbient
end
F.savedNV = nil
function F.NightVisionEnable()
local L = game:GetService("Lighting")
if not F.savedNV then F.savedNV = { Brightness = L.Brightness, ClockTime = L.ClockTime, Ambient = L.Ambient } end
L.Brightness = 1.5 L.ClockTime = 0 L.Ambient = Color3.fromRGB(90, 255, 90)
end
function F.NightVisionDisable()
local L = game:GetService("Lighting")
if not F.savedNV then return end
L.Brightness = F.savedNV.Brightness L.ClockTime = F.savedNV.ClockTime L.Ambient = F.savedNV.Ambient
end
F.savedFog = nil
function F.NoFogEnable()
local L = game:GetService("Lighting")
if not F.savedFog then F.savedFog = { FogEnd = L.FogEnd, FogStart = L.FogStart } end
L.FogEnd = 100000 L.FogStart = 100000
end
function F.NoFogDisable()
local L = game:GetService("Lighting")
if not F.savedFog then return end
L.FogEnd = F.savedFog.FogEnd L.FogStart = F.savedFog.FogStart
end
local function breakVelocity()
local _, _, root = GC()
if root then
pcall(function() root.AssemblyLinearVelocity = Vector3.zero root.AssemblyAngularVelocity = Vector3.zero end)
end
end
F.TakeAllOwnership = function()
local _, _, root = GC()
local ch = LP.Character
if not ch then return 0 end
local n = 0
local function take(p)
pcall(function()
if p.CanSetNetworkOwnership and not p:CanSetNetworkOwnership() then return end
p:SetNetworkOwner(LP)
n = n + 1
end)
end
if root then take(root) end
pcall(function()
for _, d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") then take(d) end
end
end)
return n
end
F.HardTP = function(cf)
if not cf then return false end
local _, hum, root = GC()
if not root then return false end
if F.DropIntent then pcall(F.DropIntent) end
local own = 0
pcall(function() own = F.TakeAllOwnership() end)
local wasStand = nil
pcall(function()
if hum then
wasStand = hum.PlatformStand
hum.PlatformStand = true
end
end)
pcall(function()
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
local from = root.Position
local dist = (cf.Position - from).Magnitude
local rot = cf - cf.Position
if tostring(C.TPStep or ""):find("补间", 1, true) then
local dur = math.clamp(tonumber(C.TweenDur) or 0.8, 0.1, 5)
local ts = game:GetService("TweenService")
local okT = pcall(function()
local tw = ts:Create(root, TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CFrame = cf })
F._tpTween = tw
tw:Play()
tw.Completed:Wait()
end)
F._tpTween = nil
if okT then
pcall(function()
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
if wasStand ~= nil then pcall(function() hum.PlatformStand = wasStand end) end
F._tpOwnInfo = own
F.Out(string.format("[传送] 补间到位 · %.1fs · %.0f 格(没抢所有权, 被拉回就换回分步瞬移)", dur, dist))
return (root.Position - cf.Position).Magnitude < 20
end
F.Out("[传送] 补间失败 ⇒ 自动退回分步瞬移")
end
local steps = 1
if dist > 300 then
steps = math.clamp(math.ceil(dist / 400), 2, 12)
end
for i = 1, steps do
local t = i / steps
local p = from:Lerp(cf.Position, t)
pcall(function() root.CFrame = CFrame.new(p) * rot end)
pcall(function() F.TakeAllOwnership() end)
if i < steps then
pcall(function() RS.Heartbeat:Wait() end)
end
end
pcall(function() root.CFrame = cf end)
pcall(function()
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
local t0 = os.clock()
while os.clock() - t0 < 0.25 do
pcall(function() F.TakeAllOwnership() end)
pcall(function() if (root.Position - cf.Position).Magnitude > 8 then root.CFrame = cf end end)
pcall(function() RS.Heartbeat:Wait() end)
end
if wasStand ~= nil then
pcall(function() hum.PlatformStand = wasStand end)
end
F._tpOwnInfo = own
return (root.Position - cf.Position).Magnitude < 20
end
local function smoothTP(targetCF)
if F.HardTP then
F.HardTP(targetCF)
else
local _, _, root = GC()
if root and targetCF then pcall(function() root:PivotTo(targetCF) end) end
end
breakVelocity()
end
local function TeleportToPlayer(target)
local _, _, root = GC()
if not root or not target then return end
local tchar = target.Character
if not tchar then return end
local troot = tchar:FindFirstChild("HumanoidRootPart")
if not troot then return end
smoothTP(troot.CFrame + Vector3.new(0, 3, 0))
end
F.WAYPOINT_MAX = 40
function F.WaypointList()
if type(C.Waypoints) ~= "table" then C.Waypoints = {} end
return C.Waypoints
end
function F.WaypointFind(name)
if type(name) ~= "string" then return nil end
for _, it in ipairs(F.WaypointList()) do
if type(it) == "table" and tostring(it.name) == name then return it end
end
return nil
end
F.WP_SLOTS = 5
function F.WaypointRefreshUI()
pcall(function()
local lbl = { "①", "②", "③", "④", "⑤" }
local lst = F.WaypointList()
for i = 1, F.WP_SLOTS do
local b = F._wpb and F._wpb[i]
local it = lst[i]
local txt
if type(it) == "table" then
txt = string.format("%s %s · (%.0f, %.0f) · 点=传 / 右键=删", lbl[i], tostring(it.name),
tonumber(it.x) or 0, tonumber(it.z) or 0)
else
txt = string.format("%s 空位 · 点=存 / 右键=删", lbl[i])
end
if b and b.SetTitle then pcall(function() b:SetTitle(txt) end) end
if b then pcall(F.WpSlotHook, i, b) end
end
end)
end
function F.WpClick(i)
local it = F.WaypointList()[i]
if type(it) == "table" then
F.WaypointGoto(tostring(it.name))
else
F.WaypointSave(nil)
F.WaypointRefreshUI()
end
end
function F.WaypointSave(name)
local _, _, root = GC()
if not root then
F.Out("[点位] ⚠ 现在没有角色(没进游戏 / 正在重生), 这次没法保存")
return false
end
local list = F.WaypointList()
if #list >= F.WAYPOINT_MAX then
F.Out("[点位] 已经存了 " .. tostring(F.WAYPOINT_MAX) .. " 个 —— 先在下面删掉几个再存")
return false
end
local nm = name
if nm == nil then
local used, i = {}, 1
for _, it in ipairs(list) do
if type(it) == "table" then used[tostring(it.name)] = true end
end
while used["点位" .. i] do i = i + 1 end
nm = "点位" .. i
end
if F.WaypointFind(nm) then
F.Out("[点位] 名字「" .. nm .. "」已经用过了 —— 换个名字, 或者先把旧的删掉")
return false
end
local p = root.Position
local lv = root.CFrame.LookVector
list[#list + 1] = {
name = nm,
x = tonumber(string.format("%.2f", p.X)),
y = tonumber(string.format("%.2f", p.Y)),
z = tonumber(string.format("%.2f", p.Z)),
yaw = tonumber(string.format("%.4f", math.atan2(-lv.X, -lv.Z))),
}
F.WaypointRefreshUI()
do end
F.Out(string.format("[点位] 已保存「%s」 → (%.0f, %.0f, %.0f)", nm, p.X, p.Y, p.Z))
pcall(function() Fluent:Notify({ Title = "点位", Content = "已保存「" .. nm .. "」", Duration = 4 }) end)
return true
end
function F.WpDeleteSlot(i)
local it = F.WaypointList()[i]
if type(it) ~= "table" then
F.Out("[点位] 第 " .. tostring(i) .. " 个是空位, 没有可删的")
return false
end
local nm = tostring(it.name)
F.WaypointDel(nm)
F.WaypointRefreshUI()
F.Out("[点位] 已删除「" .. nm .. "」")
return true
end
function F.WpSlotHook(i, b)
if not b then return end
local inst = nil
pcall(function() inst = b.Button end)
if not inst then
pcall(function()
local f = b.Frame
if typeof(f) == "Instance" and f:IsA("GuiButton") then inst = f end
end)
end
if not inst then
pcall(function()
local f = b.Frame
if typeof(f) == "Instance" then inst = f:FindFirstChildWhichIsA("GuiButton", true) end
end)
end
if not inst then pcall(function() inst = b.Container and b.Container:FindFirstChildWhichIsA("GuiButton", true) end) end
if not inst or not inst.InputBegan then
F.Out("[点位] 第 " .. tostring(i) .. " 个点位按钮没拿到底层控件, 右键删除不可用(点=存/传 仍可用)")
return
end
F._wpHooked = F._wpHooked or {}
if F._wpHooked[i] == inst then return end
F._wpHooked[i] = inst
local holdAt, lastDel = nil, 0
local function del()
local now = os.clock()
if now - lastDel < 0.4 then return end
lastDel = now
F.WpDeleteSlot(i)
end
local ok = pcall(function()
if inst.MouseButton2Click then inst.MouseButton2Click:Connect(function() del() end) end
inst.InputBegan:Connect(function(input)
if not input then return end
if input.UserInputType == Enum.UserInputType.MouseButton2 then
del()
elseif input.UserInputType == Enum.UserInputType.Touch then
holdAt = os.clock()
end
end)
inst.InputEnded:Connect(function(input)
if input and input.UserInputType == Enum.UserInputType.Touch and holdAt then
if os.clock() - holdAt > 0.6 then del() end
holdAt = nil
end
end)
end)
if ok and not F._wpHookLogged then
F._wpHookLogged = true
F.Out("[点位] 右键删除已挂钩(右键=删 / 手机长按0.6秒=删)")
end
end
function F.WpLastName()
local l = F.WaypointList()
local it = l[#l]
if type(it) == "table" and it.name ~= nil then return tostring(it.name) end
return nil
end
function F.WpClear()
local n = #F.WaypointList()
C.Waypoints = {}
F.WaypointRefreshUI()
do end
F.Out("[点位] 已清空 " .. tostring(n) .. " 个点位")
return n
end
function F.WaypointGoto(name)
local it = F.WaypointFind(name)
if not it then
F.Out("[点位] 没选中点位 —— 先在下面保存一个, 再在下拉里选它")
return false
end
local _, hum, root = GC()
if not root then
F.Out("[点位] ⚠ 现在没有角色, 传送取消")
return false
end
local pos = Vector3.new(tonumber(it.x) or 0, tonumber(it.y) or 0, tonumber(it.z) or 0)
local from = root.Position
F.Out("[点位] 开始传送(自行抢所有权, 不需要开加速/飞行)")
local dist = (pos - from).Magnitude
local ok = F.HardTP(CFrame.new(pos) * CFrame.Angles(0, tonumber(it.yaw) or 0, 0))
if not ok then
task.wait(0.05)
ok = F.HardTP(CFrame.new(pos) * CFrame.Angles(0, tonumber(it.yaw) or 0, 0))
if not ok then
task.wait(0.08)
ok = F.HardTP(CFrame.new(pos) * CFrame.Angles(0, tonumber(it.yaw) or 0, 0))
end
end
local now2 = nil
pcall(function() local _, _, r2 = GC() if r2 then now2 = (r2.Position - pos).Magnitude end end)
F.Out(string.format("[点位] 传送到「%s」 · 距离 %.0f 格 · %s · %s · 已抢所有权 %d 个部件(不依赖加速/飞行)",
tostring(it.name), dist,
ok and "已到位" or ("没到位(还差 " .. string.format("%.0f", now2 or -1) .. " 格)"),
dist > 300 and ("分步传送(" .. tostring(math.clamp(math.ceil(dist / 400), 2, 12)) .. " 步)") or "一次到位",
tonumber(F._tpOwnInfo) or 0))
if not ok then
F.Out("[点位] ⚠ 传送被服务端拒绝(这游戏的位移由服务端裁决) —— 换个近一点的点, 或把速度调低再试")
end
return ok
end
function F.WaypointDel(name)
if type(name) ~= "string" then
F.Out("[点位] 下拉里还没选中点位, 没删任何东西")
return false
end
local list, n = F.WaypointList(), 0
for i = #list, 1, -1 do
local it = list[i]
if type(it) == "table" and tostring(it.name) == name then table.remove(list, i) n = n + 1 end
end
F.WaypointRefreshUI()
if n > 0 then
do end
F.Out("[点位] 已删除「" .. name .. "」")
else
F.Out("[点位] 没找到「" .. name .. "」, 没删任何东西")
end
return n > 0
end
F.TP_MOUSE_REACH = 1e6
F.TP_MOUSE_AIR = 4000
F.TP_MOUSE_FAR = 500
function F.MouseWorldPos()
local cam = workspace.CurrentCamera
if not cam then return nil, "nocam" end
local px, py
pcall(function()
local m = LP:GetMouse()
px, py = m.X, m.Y
end)
if not px then
pcall(function()
local loc = UIS:GetMouseLocation()
px, py = loc.X, loc.Y
end)
end
if not px then return nil, "nomouse" end
local ray = nil
local okRay = pcall(function() ray = cam:ScreenPointToRay(px, py) end)
if (not okRay or not ray) then
local okL, r2 = pcall(function() return cam:ViewportPointToRay(px, py) end)
if okL then ray = r2 end
end
if not ray then return nil, "noray" end
local params = RaycastParams.new()
if not pcall(function() params.FilterType = Enum.RaycastFilterType.Exclude end) then
pcall(function() params.FilterType = Enum.RaycastFilterType.Blacklist end)
end
local _, _, root = GC()
if root and root.Parent then
pcall(function() params.FilterDescendantsInstances = { root.Parent } end)
end
local hit = nil
pcall(function() hit = workspace:Raycast(ray.Origin, ray.Direction * F.TP_MOUSE_REACH, params) end)
if hit and hit.Position then
return hit.Position, "hit", (hit.Position - ray.Origin).Magnitude
end
return ray.Origin + ray.Direction * F.TP_MOUSE_AIR, "air", F.TP_MOUSE_AIR
end
function F.TPMouse()
local pos, kind, dist = F.MouseWorldPos()
if not pos then
F.Out("[T键传送] 拿不到鼠标指向的位置(" .. tostring(kind) .. ") 本次没动")
return false
end
if kind == "air" then
F.Out("[T键传送] 射线一路没打到任何实体(指着天空, 或这游戏开了流式加载、远处还没生成) => 沿视线方向送 "
.. tostring(F.TP_MOUSE_AIR) .. " 格")
end
local _, hum, root = GC()
if not root then
F.Out("[T键传送] 现在没有角色(没进游戏 / 正在重生) 本次没动")
return false
end
pcall(F.SrvOwnTake, false)
local dest = pos + Vector3.new(0, 3, 0)
smoothTP(CFrame.new(dest))
if hum then pcall(function() hum.PlatformStand = false end) end
local ok = false
pcall(function()
local _, _, r2 = GC()
if r2 then ok = (r2.Position - dest).Magnitude < 8 end
end)
local far = (tonumber(dist) or 0) >= F.TP_MOUSE_FAR
F.Out(string.format("[T键传送] %s · %.0f 格 -> (%.0f, %.0f, %.0f) 到位: %s",
(kind == "air") and ("鼠标方向上没有实体, 沿视线送 " .. tostring(F.TP_MOUSE_AIR) .. " 格") or "鼠标指向点",
tonumber(dist) or 0, dest.X, dest.Y, dest.Z, ok and "是" or "否"))
if far then
F.Out("[T键传送] 提示: 这次距离 " .. string.format("%.0f", tonumber(dist) or 0)
.. " 格, 属于「跨半张地图」级别 ⇒ 服务端大概率判为传送而把你拉回(游戏规则, 不是脚本没生效);"
.. " 想稳一点就把鼠标指近些的地面/建筑, 或先开「加速防拉回」档")
end
if not ok then
local _, srv = F.AuthorityGuard(false)
F.Out(srv and "[T键传送] 这个游戏 AuthorityMode=Server(位移由服务端裁决), 传不到是游戏规则, 不是脚本没生效"
or "[T键传送] 没到位: 多半被拉回 / 角色被冻住, 再按一次 T")
end
return ok
end
F.II_SAVED, F.II_CONN, F.II_SHOWN, F.II_COUNT = nil, nil, nil, 0
function F.InstantInteractApply(pp)
if not F.II_SAVED then return end
if typeof(pp) ~= "Instance" or not pp:IsA("ProximityPrompt") then return end
if F.II_SAVED[pp] then return end
local lvl = tostring(C.IILevel or "①")
local snap = { E = pp.Enabled, H = pp.HoldDuration, R = pp.RequiresLineOfSight, M = pp.MaxActivationDistance }
F.II_SAVED[pp] = snap
pcall(function() pp.HoldDuration = 0 end)
if lvl ~= "①" then
pcall(function() pp.RequiresLineOfSight = false end)
pcall(function() pp.MaxActivationDistance = 1000000 end)
end
F.II_COUNT = F.II_COUNT + 1
end
function F.InstantInteractScan()
local n, seen = 0, {}
pcall(function()
for _, d in ipairs(workspace:GetDescendants()) do
if d:IsA("ProximityPrompt") then seen[#seen + 1] = d n = n + 1 end
end
end)
for _, d in ipairs(seen) do pcall(F.InstantInteractApply, d) end
return n
end
F.OUR_GUI_NAMES = { "CM_", "CMTouchToggle", "StatOverlay", "CrosshairDot", "MenuButton", "CheatMenu" }
F.NukeAllGUIs = function(keepFluent)
local n = 0
local roots = {}
pcall(function() if type(gethui) == "function" then roots[#roots + 1] = gethui() end end)
pcall(function() roots[#roots + 1] = LP:FindFirstChild("PlayerGui") end)
pcall(function() roots[#roots + 1] = game:GetService("CoreGui") end)
for _, r in ipairs(roots) do
if r then
for _, d in ipairs(r:GetChildren()) do
local nm = tostring(d.Name)
local ours = false
pcall(function() if d:GetAttribute("CMOwned") then ours = true end end)
for _, k in ipairs(F.OUR_GUI_NAMES) do
if string.find(nm, k, 1, true) then ours = true break end
end
if nm == "Fluent" and not keepFluent then ours = true end
if ours then
pcall(function() d:Destroy() end)
n = n + 1
end
end
end
end
return n
end
F.BypassAutoRaise = function(why)
pcall(function()
local t = tostring(T.BypassTier or "")
if string.find(t, "②", 1, true) or string.find(t, "③", 1, true) or string.find(t, "④", 1, true) then return end
T.BypassTier = "② + 防护/反拉回/伪装(稳身·受击·陷阱·抢所有权·钉位·读原值)"
F.Out("[绕过防护] " .. tostring(why) .. " ⇒ 自动把档位升到 ②(反拉回+伪装), 免得被服务端拉回/换位置")
pcall(F.BypassTierApply, T.BypassTier)
end)
end
F.BypassTierApply = function(v)
pcall(F.HookFuse, true)
v = tostring(v or "")
local wants = {
afk = string.find(v, "防挂机", 1, true) ~= nil,
guard = string.find(v, "②", 1, true) ~= nil or string.find(v, "③", 1, true) ~= nil
or string.find(v, "④", 1, true) ~= nil,
kick = string.find(v, "③", 1, true) ~= nil or string.find(v, "④", 1, true) ~= nil,
deep = string.find(v, "④", 1, true) ~= nil,
}
if not wants.guard then
T.GuardOn, T.SpeedGuard, T.Spoof = false, false, false
pcall(function() F.GuardSet(false, false, false, false, false, false) end)
pcall(F.SpeedGuardDisable)
pcall(F.SpoofDisable)
else
T.GuardOn = true
pcall(function() F.GuardSet(true, true, false, true, true, false) end)
T.SpeedGuard = true
F.Try("SpeedGuardEnable", F.SpeedGuardEnable)
T.Spoof = true
F.Try("SpoofEnable", F.SpoofEnable)
end
if not wants.deep then
T.DeepNeuter, T.AntiTPOn = false, false
pcall(F.DeepNeuterDisable)
pcall(F.SpeedAntiTPDisable)
else
T.DeepNeuter, T.AntiTPOn = true, true
F.Try("SpeedAntiTPEnable", F.SpeedAntiTPEnable)
F.Try("DeepNeuterEnable", F.DeepNeuterEnable)
end
pcall(F.CMX_TierSync, F.CMX_TierLevel(v))
pcall(F.CfgSyncUI)
F.Out("[绕过防护] 档位 = " .. v)
end
function F.SpeedGuardEnable()
T.SpeedGuard = true
T.BypassDetect = true
F.Try("BypassEnable", F.BypassEnable)
pcall(F.MetaHookEnsure)
F.Out("[反拉回] 已开(平时零干预, 被拉回才出手): 所有权被夺才抢 + 被回滚就用 0.3 秒脉冲顶回")
end
function F.SpeedGuardDisable()
if F._pinPulseConn then pcall(function() F._pinPulseConn:Disconnect() end) F._pinPulseConn = nil end
T.SpeedGuard = false
T.BypassDetect = false
pcall(F.PinDisable)
pcall(F.BypassDisable)
F.Out("[反拉回] 已关")
end
F._pinConn, F._pinned = nil, nil
F.CarryPinFind = function()
local ch, _, root = GC()
if not (ch and root) then return nil end
local KEYS = { "egg", "brainrot", "cash", "carry", "crate", "loot", "pet", "drop", "box", "bag", "item", "蛋", "脑红" }
local best, bestD = nil, 14
pcall(function()
local n = 0
for _, d in ipairs(workspace:GetDescendants()) do
n = n + 1
if n > 4000 then break end
if d:IsA("Model") or d:IsA("BasePart") then
local nm = tostring(d.Name):lower()
local hit = false
for _, k in ipairs(KEYS) do if nm:find(k, 1, true) then hit = true break end end
if hit then
local part = nil
if d:IsA("Model") then part = d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart") else part = d end
if part then
local dd = (part.Position - root.Position).Magnitude
if dd < bestD then best, bestD = part, dd end
end
end
end
end
end)
local hand = ch:FindFirstChild("RightHand") or ch:FindFirstChild("LeftHand")
or ch:FindFirstChild("Right Arm") or ch:FindFirstChild("Left Arm") or root
if not best then return nil end
return best, hand
end
F.MyEggSet = function(on)
T.MyEgg = on and true or false
if F._eggLoop then F._eggLoop = false end
if not on then
F._myEgg = nil
F.Out("[护蛋] 已关")
return
end
F.Out("[护蛋] 已开: 只盯你自己拿起的那一个 —— 它掉地/被夺就立刻瞬间偷回手里(不会去抢别人的)。每 0.05 秒检查一次, 掉了立刻重拿/重新装备")
if F._eggUnEq then pcall(function() F._eggUnEq:Disconnect() end) F._eggUnEq = nil end
pcall(function()
local ch = GC()
if ch then
local function hookTool(tool)
pcall(function()
F._eggUnEq2 = tool.Unequipped:Connect(function()
if not T.MyEgg then return end
task.wait()
local ch2, hum2 = GC()
pcall(function() if ch2 and hum2 and tool.Parent then hum2:EquipTool(tool) end end)
F.Out("[护蛋] 蛋被卸下 ⇒ 已立刻重新装上(不等下一拍)")
end)
end)
end
local cur = ch:FindFirstChildOfClass("Tool")
if cur then hookTool(cur) end
F._eggCharConn = ch.ChildAdded:Connect(function(c)
if c:IsA("Tool") then hookTool(c) end
end)
end
end)
F._eggLoop = true
task.spawn(function()
while T.MyEgg and F._eggLoop do
local ch, _, root = GC()
if ch and root then
if not (F._myEgg and F._myEgg.Parent) then
local KEYS = { "egg", "brainrot", "cash", "carry", "crate", "loot", "box", "bag", "item", "蛋", "脑红" }
local best, bestD = nil, 8
pcall(function()
for _, d in ipairs(ch:GetDescendants()) do
if d:IsA("Model") or d:IsA("BasePart") or d:IsA("Tool") then
if d:IsA("Model") or d:IsA("Tool") or d:IsA("BasePart") then
local nm = tostring(d.Name):lower()
for _, k in ipairs(KEYS) do
if nm:find(k, 1, true) then best = d break end
end
end
end
if best then break end
end
if not best then
local op = OverlapParams.new()
op.FilterType = Enum.RaycastFilterType.Exclude
op.FilterDescendantsInstances = { ch }
for _, part in ipairs(workspace:GetPartBoundsInRadius(root.Position, 8, op)) do
local nm = tostring(part.Name):lower()
for _, k in ipairs(KEYS) do
if nm:find(k, 1, true) then best, bestD = part, 0 break end
end
if best then break end
end
end
end)
if best then
F._myEgg = best
F.Out("[护蛋] 已锁定你手上的「" .. tostring(best.Name) .. "」")
end
end
do
local ch2, hum2 = GC()
if ch2 and hum2 then
local equipped = ch2:FindFirstChildOfClass("Tool")
if not equipped then
local bp = LP:FindFirstChildOfClass("Backpack")
local want = F._myEgg
local pickTool = nil
pcall(function()
if want and want:IsA("Tool") and want.Parent == bp then pickTool = want end
end)
if not pickTool then
pcall(function()
for _, t in ipairs(bp:GetChildren()) do
if t:IsA("Tool") then
local nm = tostring(t.Name):lower()
if nm:find("egg", 1, true) or nm:find("brainrot", 1, true) or nm:find("蛋", 1, true) then pickTool = t break end
end
end
end)
end
if pickTool then
pcall(function() hum2:EquipTool(pickTool) end)
F._myEgg = pickTool
if os.clock() - (F._eggEquipAt or 0) > 3 then
F._eggEquipAt = os.clock()
F.Out("[护蛋] 蛋被卸下了 ⇒ 已立刻重新装备「" .. tostring(pickTool.Name) .. "」")
end
end
end
end
end
local egg = F._myEgg
if egg and egg.Parent then
local inHand = false
pcall(function() inHand = (egg.Parent == ch) or egg:IsDescendantOf(ch) end)
if not inHand then
local part = egg:IsA("Model") and (egg.PrimaryPart or egg:FindFirstChildWhichIsA("BasePart")) or (egg:IsA("BasePart") and egg) or nil
pcall(function()
if part then
local op = OverlapParams.new()
op.FilterType = Enum.RaycastFilterType.Exclude
op.FilterDescendantsInstances = { ch }
local pp = part:FindFirstChildOfClass("ProximityPrompt")
or (part.Parent and part.Parent:FindFirstChildOfClass("ProximityPrompt"))
if not pp then
for _, q in ipairs(workspace:GetPartBoundsInRadius(part.Position, 6, op)) do
pp = q:FindFirstChildOfClass("ProximityPrompt")
if pp then break end
end
end
if pp and pp.Enabled then
pp.HoldDuration = 0
pp.RequiresLineOfSight = false
pp.MaxActivationDistance = 1000000
pp:InputHoldBegin()
task.wait()
pp:InputHoldEnd()
F._eggHits = (F._eggHits or 0) + 1
if os.clock() - (F._eggLogAt or 0) > 3 then
F._eggLogAt = os.clock()
F.Out("[护蛋] 掉了一次 ⇒ 已瞬间偷回(累计 " .. tostring(F._eggHits) .. " 次)")
end
end
end
end)
end
end
end
task.wait(0.05)
end
F._eggLoop = nil
end)
end
F.CarryPinSet = function(on)
T.CarryPin = on and true or false
if F._pinLoop then F._pinLoop = false end
if not on then
if F._pinned then pcall(function() if F._pinned.Weld then F._pinned.Weld:Destroy() end end) end
F._pinned = nil
F.Out("[蛋守卫] 已关")
return
end
F.Out("[蛋守卫] 已开(低开销版): 扫到一次就钉住, 之后只跟随, 不再满地图扫")
F._pinLoop = true
task.spawn(function()
while T.CarryPin and F._pinLoop do
local ch, _, root = GC()
if ch and root then
local ok = false
if F._pinned and F._pinned.Part and F._pinned.Part.Parent then
local hand = ch:FindFirstChild("RightHand") or ch:FindFirstChild("LeftHand") or root
pcall(function() if not F._pinned.Part.Anchored then F._pinned.Part.CFrame = hand.CFrame end end)
ok = true
end
if not ok then
if F._pinned then pcall(function() if F._pinned.Weld then F._pinned.Weld:Destroy() end end) F._pinned = nil end
local part, hand = F.CarryPinFind()
if part and hand then
local okW, w = pcall(function()
local w2 = Instance.new("WeldConstraint")
w2.Name = "CM_CarryPin"
w2.Part0, w2.Part1 = hand, part
w2.Parent = part
return w2
end)
F._pinned = { Part = part, Weld = (okW and w) or nil }
F.Out("[蛋守卫] 已把「" .. tostring(part.Parent and part.Parent.Name or part.Name) .. "」钉在手上")
end
end
end
task.wait(0.1)
end
F._pinLoop = nil
end)
end
F.CarryGuardEnable = function()
if F._cgConn then return end
F.EggLock()
F._carry = F.CarryFind()
F.Try("CarryWatchEnable", F.CarryWatchEnable)
F._cgConn = RS.Heartbeat:Connect(function()
if not T.CarryGuard then F.CarryGuardDisable() return end
F.EggGuardTick()
F.CarryGuardTick()
end)
F.Out("[搬运守卫] 已开(焊点被拆就重焊 + 离手就拉回); 先站到蛋旁边再开")
end
F.CarryRescan = function(why)
if not T.CarryGuard then return end
pcall(F.EggLock)
pcall(function() F._carry = F.CarryFind() end)
F.Out("[搬运守卫] " .. tostring(why) .. " ⇒ 已重新锁定手上的东西")
end
F.CarryWatchEnable = function()
if F._carryWatch then return end
F._carryWatch = {}
pcall(function()
F._carryWatch[#F._carryWatch + 1] = LP.CharacterAdded:Connect(function()
task.wait(0.8)
F.CarryRescan("角色重生")
end)
end)
local function watchChar(ch)
if not ch then return end
pcall(function()
F._carryWatch[#F._carryWatch + 1] = ch.ChildAdded:Connect(function(o)
if not T.CarryGuard then return end
if o:IsA("Tool") then
task.wait(0.2)
F.CarryRescan("你装备了 " .. tostring(o.Name))
end
end)
end)
pcall(function()
F._carryWatch[#F._carryWatch + 1] = ch.ChildRemoved:Connect(function(o)
if not T.CarryGuard then return end
if o:IsA("Tool") then
F.Out("[搬运守卫] " .. tostring(o.Name) .. " 离手了(放下/被收走)")
end
end)
end)
end
watchChar(LP.Character)
pcall(function()
F._carryWatch[#F._carryWatch + 1] = LP.CharacterAdded:Connect(function(ch)
task.wait(0.8)
watchChar(ch)
end)
end)
end
F.CarryWatchDisable = function()
if F._carryWatch then
for _, c in ipairs(F._carryWatch) do pcall(function() c:Disconnect() end) end
F._carryWatch = nil
end
end
function F.CarryGuardDisable()
pcall(F.CarryWatchDisable)
if F._cgConn then pcall(function() F._cgConn:Disconnect() end) F._cgConn = nil end
F._egg, F._eggPart, F._eggHand = nil, nil, nil
F._eggGone, F._eggBack, F._carry, F._carryBack = nil, 0, nil, 0
F.Out("[搬运守卫] 已关")
end
F.CharEventsEnable = function()
if F._charEv then return end
F._charEv = {}
local function hook(ch)
if not ch then return end
local hum = ch:FindFirstChildOfClass("Humanoid")
if not hum then return end
pcall(function()
F._charEv[#F._charEv + 1] = hum.Died:Connect(function()
F._walkTgt = nil
F._egg, F._eggPart, F._carry = nil, nil, nil
F.Out("[角色] 你死了 ⇒ 已清掉走路目标与搬运锁定(重进后可再开)")
end)
end)
pcall(function()
F._charEv[#F._charEv + 1] = hum.StateChanged:Connect(function(_, new)
if new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.Ragdoll
or new == Enum.HumanoidStateType.PlatformStanding then
F._lastBadState = tostring(new)
end
end)
end)
pcall(function()
F._charEv[#F._charEv + 1] = hum.HealthChanged:Connect(function(hp)
local max = hum.MaxHealth
if max and max > 1 and hp > 0 and hp < max * 0.35 then
F._lastHurtAt = os.clock()
end
end)
end)
end
hook(LP.Character)
pcall(function()
F._charEv[#F._charEv + 1] = LP.CharacterAdded:Connect(function(ch)
task.wait(0.6)
hook(ch)
end)
end)
end
F.CharEventsDisable = function()
if F._charEv then
for _, c in ipairs(F._charEv) do pcall(function() c:Disconnect() end) end
F._charEv = nil
end
end
function F.GuardOnDisable()
pcall(function() F.GuardSet(false, false, false, false, false, false) end)
end
function F.AllInOneDisableAll()
pcall(F.SpeedGuardDisable)
pcall(F.CarryGuardDisable)
pcall(F.GuardOnDisable)
pcall(F.SpoofDisable)
end
function F.SpoofEnable()
if F._spoofConn then return end
T.Spoof = true
F._spoofWalkBase = tonumber(F._preSpeed) or nil
F._spoofJumpBase = nil
pcall(F.MetaHookEnsure)
F._spoofConn = RS.Heartbeat:Connect(function()
if not T.Spoof then F.SpoofDisable() return end
end)
local rw = false
pcall(function()
if type(gethiddenproperty) ~= "function" or type(sethiddenproperty) ~= "function" then return end
local _, hum = GC()
if not hum then return end
local cur = nil
pcall(function() cur = gethiddenproperty(hum, "ReplicateWalkSpeed") end)
if cur == nil then return end
pcall(function() sethiddenproperty(hum, "ReplicateWalkSpeed", false) end)
rw = true
end)
local cleaned = 0
pcall(function()
local marks = { "syn", "KRNL_LOADED", "EXECUTOR_NAME", "is_sirhurt_closure",
"synapsed", "sirhurt", "krnl", "fluxus", "delta", "wave", "elysian" }
for _, n in ipairs(marks) do
pcall(function()
local g = getgenv and getgenv()
if type(g) == "table" and g[n] ~= nil then g[n] = nil cleaned = cleaned + 1 end
end)
pcall(function()
local g2 = (type(getgenv) == "function") and getgenv() or nil
if type(g2) == "table" and g2[n] ~= nil then g2[n] = nil cleaned = cleaned + 1 end
end)
end
end)
if cleaned > 0 then
F.Out("[伪装] 已清掉 " .. tostring(cleaned) .. " 个执行器环境标记(反作弊常靠这些认执行器)")
end
F.Out("[伪装] 已开: 游戏侧读你的 WalkSpeed/JumpPower 拿到的是原值(执行器自己的代码读到真值)"
.. (rw and " · 另已试装 ReplicateWalkSpeed=false(不再把改过的速度复制给服务端)" or ""))
end
function F.SpoofDisable()
T.Spoof = false
if F._spoofConn then pcall(function() F._spoofConn:Disconnect() end) F._spoofConn = nil end
F._spoofWalkBase, F._spoofJumpBase = nil, nil
end
function F.InstantInteractEnable()
if F.II_SAVED then return end
F.II_SAVED, F.II_COUNT = setmetatable({}, { __mode = "k" }), 0
local n = F.InstantInteractScan()
pcall(function()
F.II_CONN = workspace.DescendantAdded:Connect(function(d)
if T.InstantInteract then pcall(F.InstantInteractApply, d) end
end)
end)
pcall(function()
F.II_SHOWN = game:GetService("ProximityPromptService").PromptShown:Connect(function(pp)
if T.InstantInteract then pcall(F.InstantInteractApply, pp) end
end)
end)
F.Try("InteractWatchEnable", F.InteractWatchEnable)
pcall(F.InstantInteractHeal)
pcall(F.InstantInteractAutoLoop)
F.Out("[瞬间交互] 已开启(长按→点一下就成 · 不要求看得见) — 本次处理 " .. tostring(n)
.. " 个交互点, 新出现的也自动生效; 关闭时逐个还原原值")
end
F.InteractWatchEnable = function()
if F._ppConn then return end
pcall(function()
local PPS = game:GetService("ProximityPromptService")
F._ppConn = PPS.PromptTriggered:Connect(function(prompt, plr)
if plr ~= LP then return end
F._promptHits = (F._promptHits or 0) + 1
local now = os.clock()
if now - (F._ppLogAt or 0) > 3 then
F._ppLogAt = now
local hn = ""
pcall(function() hn = tostring(prompt and prompt.Parent and prompt.Parent.Name or "?") end)
F.Out("[交互] 已达成交互 " .. tostring(F._promptHits) .. " 次(最近: " .. hn .. ")")
end
end)
end)
end
F.InteractWatchDisable = function()
if F._ppConn then pcall(function() F._ppConn:Disconnect() end) F._ppConn = nil end
end
F.InstantInteractHeal = function()
if F._iiHeal then return end
F._iiHeal = task.spawn(function()
while T.InstantInteract do
task.wait(30)
if not T.InstantInteract then break end
pcall(function()
local _, n2 = F.InstantInteractScan()
F._iiHealHits = (F._iiHealHits or 0) + 1
if (n2 or 0) > 0 and os.clock() - (F._iiHealLog or 0) > 30 then
F._iiHealLog = os.clock()
F.Out("[瞬间交互] 自愈: 又处理了 " .. tostring(n2) .. " 个交互点(第 " .. tostring(F._iiHealHits) .. " 次复查)")
end
end)
end
F._iiHeal = nil
end)
end
function F.InstantInteractDisable()
F._iiHeal = nil
F._iiAuto = nil
pcall(function() if F.InteractWatchDisable then F.InteractWatchDisable() end end)
if F.II_CONN then pcall(function() F.II_CONN:Disconnect() end) F.II_CONN = nil end
if F.II_SHOWN then pcall(function() F.II_SHOWN:Disconnect() end) F.II_SHOWN = nil end
local n = 0
if type(F.II_SAVED) == "table" then
for pp, snap in pairs(F.II_SAVED) do
if typeof(pp) == "Instance" and pp.Parent then
pcall(function() pp.HoldDuration = snap.H end)
pcall(function() pp.RequiresLineOfSight = snap.R end)
pcall(function() if snap.M then pp.MaxActivationDistance = snap.M end end)
pcall(function() pp.Enabled = snap.E end)
n = n + 1
end
end
end
F.II_SAVED, F.II_COUNT = nil, 0
F.Out("[瞬间交互] 已关闭 — 已还原 " .. tostring(n) .. " 个交互点的原值")
end
local mutedVolumes = nil
local function MuteEnable()
if mutedVolumes then return end
mutedVolumes = {}
for _, s in ipairs(F.walk(workspace)) do
if s:IsA("Sound") then
mutedVolumes[s] = s.Volume
pcall(function() s.Volume = 0 end)
end
end
end
local function MuteDisable()
if not mutedVolumes then return end
for s, v in pairs(mutedVolumes) do
pcall(function() if typeof(s) == "Instance" and s.Parent then s.Volume = v end end)
end
mutedVolumes = nil
end
local savedLag = nil
local LAG_FX = { "BlurEffect", "SunRaysEffect", "ColorCorrectionEffect", "BloomEffect", "DepthOfFieldEffect", "Atmosphere" }
local function AntilagDisable()
local L = game:GetService("Lighting")
if not savedLag then return end
pcall(function()
L.GlobalShadows = savedLag.GlobalShadows L.FogEnd = savedLag.FogEnd L.FogStart = savedLag.FogStart
L.Brightness = savedLag.Brightness L.ClockTime = savedLag.ClockTime L.Ambient = savedLag.Ambient
end)
pcall(function() settings().Rendering.QualityLevel = savedLag.quality end)
for _, e in ipairs(savedLag.fx) do pcall(function() if e and e.Parent then e.Enabled = true end end) end
for _, rec in ipairs(savedLag.pe) do
if rec.obj and rec.obj.Parent then pcall(function() rec.obj.Lifetime = rec.life end) end
end
if F._lagAddConn then F._lagAddConn:Disconnect() F._lagAddConn = nil end
F._lagAnimOn = false
savedLag = nil
end
local function AntilagEnable()
local L = game:GetService("Lighting")
if not savedLag then
savedLag = { GlobalShadows = L.GlobalShadows, FogEnd = L.FogEnd, FogStart = L.FogStart,
Brightness = L.Brightness, ClockTime = L.ClockTime, Ambient = L.Ambient, fx = {}, pe = {} }
pcall(function() savedLag.quality = settings().Rendering.QualityLevel end)
end
pcall(function() settings().Rendering.QualityLevel = 1 end)
local Terrain = workspace:FindFirstChildWhichIsA("Terrain")
if Terrain then
pcall(function()
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 1
end)
end
L.GlobalShadows = false L.FogEnd = 9e9 L.FogStart = 9e9 L.Brightness = 1
local nfx, npe = 0, 0
for _, d in ipairs(F.walk(workspace)) do
local cn = tostring(d.ClassName)
if cn == "ParticleEmitter" or cn == "Trail" then
local life = nil
pcall(function() life = d.Lifetime end)
if life ~= nil and tostring(life) ~= "0 0" then
savedLag.pe[#savedLag.pe + 1] = { obj = d, life = life }
pcall(function() d.Lifetime = NumberRange.new(0) end)
npe = npe + 1
end
elseif cn == "Smoke" or cn == "Fire" or cn == "Sparkles" then
pcall(function() d.Enabled = false end)
end
end
for _, d in ipairs(F.walk(L)) do
local cn = tostring(d.ClassName)
for _, k in ipairs(LAG_FX) do
if cn == k then
if d.Enabled then savedLag.fx[#savedLag.fx + 1] = d end
pcall(function() d.Enabled = false end)
nfx = nfx + 1
break
end
end
end
for _, v in ipairs(F.walk(workspace)) do
if v:IsA("BasePart") then pcall(function() v.CastShadow = false end) end
end
if not F._lagAddConn then
F._lagAddConn = workspace.DescendantAdded:Connect(function(child)
if not T.Antilag then return end
pcall(function()
if child:IsA("ParticleEmitter") or child:IsA("Trail") then
child.Lifetime = NumberRange.new(0)
elseif child:IsA("Smoke") or child:IsA("Fire") or child:IsA("Sparkles") then
child.Enabled = false
end
end)
end)
end
if not F._lagAnimOn then
F._lagAnimOn = true
task.spawn(function()
while F._lagAnimOn and T.Antilag do
task.wait(5)
local n = 0
pcall(function()
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then
local an = pl.Character:FindFirstChildOfClass("Animator")
if an then
pcall(function()
for _, t in ipairs(an:GetPlayingAnimationTracks()) do
pcall(function() t:Stop(0) end)
n = n + 1
end
end)
end
end
end
end)
if n > 0 then F._lagAnimN = (F._lagAnimN or 0) + n end
end
end)
end
F.Out(string.format("[降画质] 渲染质量档=%d · 关光效 %d 个(Bloom/阳光/景深/氛围) · 灭粒子特效 %d 个 · 关阴影 · 之后新出的特效也自动灭",
1, nfx, npe))
end
local function FOVEnable() workspace.CurrentCamera.FieldOfView = C.FOV or 100 end
local function FOVDisable()
local c = workspace.CurrentCamera
if c then c.FieldOfView = (F._orig and F._orig.fov) or 70 end
end
local function ZoomEnable()
LP.CameraMaxZoomDistance = C.Zoom or 400
LP.CameraMinZoomDistance = 0.5
end
local function ZoomDisable()
local o = F._orig or {}
LP.CameraMaxZoomDistance = o.maxZoom or 128
LP.CameraMinZoomDistance = o.minZoom or 0.5
end
local LockHealthConn = nil
local function LockHealthDisable() if LockHealthConn then LockHealthConn:Disconnect() LockHealthConn = nil end end
local function LockHealthEnable()
if LockHealthConn then return end
LockHealthConn = RS.Heartbeat:Connect(function()
if not T.LockHealth then LockHealthDisable() return end
if os.clock() - (F._thr4402 or 0) < 0.05 then return end
F._thr4402 = os.clock()
local _, hum = GC()
if hum and hum.Health > 0 then
local target = C.LockHealthValue or 100
if hum.Health ~= target then hum.Health = target end
end
end)
end
local RegenConn = nil
local function RegenDisable() if RegenConn then RegenConn:Disconnect() RegenConn = nil end end
local function RegenEnable()
if RegenConn then return end
RegenConn = RS.Heartbeat:Connect(function()
if not T.Regen then RegenDisable() return end
if os.clock() - (F._thr4420 or 0) < 0.2 then return end
F._thr4420 = os.clock()
local _, hum = GC()
if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
hum.Health = math.min(hum.MaxHealth, hum.Health + (C.RegenRate or 10))
end
end)
end
local NoDeathConn = nil
local function NoDeathDisable() if NoDeathConn then NoDeathConn:Disconnect() NoDeathConn = nil end end
local function NoDeathEnable()
if NoDeathConn then return end
NoDeathConn = RS.Heartbeat:Connect(function()
if not T.NoDeath then NoDeathDisable() return end
if os.clock() - (F._thr4456 or 0) < 0.1 then return end
F._thr4456 = os.clock()
local _, hum = GC()
if hum and hum.Health <= 0 then pcall(function() hum.Health = hum.MaxHealth end) end
end)
end
function F.OnCharacter()
if T.CharPersist == false then return end
task.wait(0.2)
F.RecordOriginals()
pcall(function()
local _, _, hb = GC()
if hb then F.HideBaseY = hb.Position.Y end
end)
if T.FlyOn then pcall(function() F.FlySet(true) end) end
if T.SpeedOn then pcall(function() F.SpeedSet(true) end) end
if T.NoClip then pcall(F.NoClipEnable) end
if T.God then pcall(GodEnable) end
if T.LockHealth then pcall(LockHealthEnable) end
if T.AntiRagdoll then pcall(F.AntiRagdollEnable) end
if T.InfiniteJump then pcall(F.InfiniteJumpEnable) end
if T.Translate then pcall(F.TranslateEnable) end
if T.KillAura then pcall(F.KillAuraEnable) end
if T.BodyHL then pcall(F.BodyHLEnable) end
if T.HealthIsolate then pcall(F.HealthIsolateApply) end
end
function F.CharPersistEnable() T.CharPersist = true end
function F.CharPersistDisable() T.CharPersist = false end
function F.ProtectGui()
local targets = {}
pcall(function() if Fluent and Fluent.GUI then table.insert(targets, Fluent.GUI) end end)
pcall(function()
for _, g in ipairs(CoreGui:GetChildren()) do
if F.isOwnGuiName(g.Name, g) then table.insert(targets, g) end
end
end)
for _, sg in ipairs(targets) do
pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
pcall(function() if protect_gui then protect_gui(sg) end end)
end
end
F._guiProtConn = nil
F._guiProtQueue = false
F.OWN_GUI_NAMES = {
PlayerTags = true, BoneLines = true, FacingMark = true, HitZone = true,
StatOverlay = true, CrosshairDot = true, ReticleRing = true, MenuButton = true,
}
function F.isOwnGuiName(name, inst)
if type(name) ~= "string" then return false end
if F.OWN_GUI_NAMES[name] then return true end
if inst ~= nil and Fluent and Fluent.GUI and inst == Fluent.GUI then return true end
return false
end
function F.GuiName(inst)
local n = ""
pcall(function() n = tostring(inst.Name or "") end)
return n
end
function F.GuiProtectionEnable()
if F._guiProtConn then return end
local parents = {}
pcall(function() if CoreGui then parents[#parents + 1] = CoreGui end end)
pcall(function() if gethui then local h = gethui() if h and h ~= CoreGui then parents[#parents + 1] = h end end end)
pcall(function() local pg2 = LP:FindFirstChild("PlayerGui") if pg2 then parents[#parents + 1] = pg2 end end)
local uniq, seen = {}, {}
for i = 1, #parents do
local p = parents[i]
if p and not seen[p] then seen[p] = true uniq[#uniq + 1] = p end
end
for i = 1, #uniq do
local parent = uniq[i]
local ok = pcall(function()
local c = parent.DescendantRemoving:Connect(function(obj)
local n = F.GuiName(obj)
if not F.isOwnGuiName(n, obj) then return end
if F._guiProtQueue then return end
F._guiProtQueue = true
task.delay(0.5, function()
F._guiProtQueue = false
F.Out("[CheatMenu] 检测到 GUI 被移除(" .. n .. "), 正在重建...")
pcall(F.ProtectGui)
task.spawn(function()
pcall(function() if T.Hud then F.HudEnable() end end)
pcall(function() if T.Crosshair then F.CrosshairEnable() end end)
pcall(function() if T.FovCircle then F.FovCircleEnable() end end)
if Fluent and Fluent.Notify then
Fluent:Notify({ Title = "GUI 保护", Content = "界面被销毁, 已尝试恢复", Duration = 4 })
end
end)
end)
end)
F._guiProtConns = F._guiProtConns or {}
F._guiProtConns[#F._guiProtConns + 1] = c
end)
if ok then F._guiProtConn = true end
end
end
function F.GuiProtectionDisable()
if F._guiProtConns then
for i = 1, #F._guiProtConns do pcall(function() F._guiProtConns[i]:Disconnect() end) end
end
F._guiProtConns = nil
F._guiProtConn = nil
end
F._hudGui, F._hudConn = nil, nil
function F.HudEnable()
if F._hudGui then return end
local host = nil
pcall(function() host = gethui and gethui() end)
if not host then pcall(function() host = CoreGui end) end
if not host then pcall(function() host = game:GetService("CoreGui") end) end
if not host then F.Out("[HUD] 找不到可挂载的 GUI 容器") return end
local sg = Instance.new("ScreenGui")
sg.Name = "StatOverlay"
pcall(function() sg:SetAttribute("CMOwned", true) end)
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = host
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(0, 230, 0, 20)
lbl.Position = UDim2.new(1, -240, 1, -28)
lbl.BackgroundTransparency = 1
lbl.TextColor3 = Color3.fromRGB(0, 255, 120)
lbl.TextStrokeTransparency = 0.4
lbl.TextSize = 14
lbl.Font = Enum.Font.Code
lbl.TextXAlignment = Enum.TextXAlignment.Right
lbl.Text = "FPS -- | Ping -- ms"
lbl.Parent = sg
F._hudGui = sg
local frames, lastT = 0, os.clock()
F._hudConn = RS.RenderStepped:Connect(function()
frames = frames + 1
local now = os.clock()
if now - lastT >= 1 then
local fps = frames
frames = 0
lastT = now
local ping, mem = 0, 0
pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
pcall(function() mem = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb()) end)
lbl.Text = string.format("FPS %d | Ping %d ms | %d MB", fps, ping, mem)
end
end)
end
function F.HudDisable()
if F._hudConn then F._hudConn:Disconnect() F._hudConn = nil end
if F._hudGui then F._hudGui:Destroy() F._hudGui = nil end
end
F._crossGui = nil
function F.CrosshairEnable()
if F._crossGui then return end
local host = nil
pcall(function() host = gethui and gethui() end)
if not host then pcall(function() host = CoreGui end) end
if not host then pcall(function() host = game:GetService("CoreGui") end) end
if not host then F.Out("[准星] 找不到可挂载的 GUI 容器") return end
local sg = Instance.new("ScreenGui")
sg.Name = "CrosshairDot"
pcall(function() sg:SetAttribute("CMOwned", true) end)
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = host
local function bar(w, h)
local f = Instance.new("Frame")
f.Size = UDim2.fromOffset(w, h)
f.Position = UDim2.new(0.5, -w / 2, 0.5, -h / 2)
f.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
f.BorderSizePixel = 0
f.Parent = sg
end
bar(2, 14) bar(14, 2)
F._crossGui = sg
end
function F.CrosshairDisable()
if F._crossGui then F._crossGui:Destroy() F._crossGui = nil end
end
F._fovGui, F._fovConn = nil, nil
function F.FovCircleEnable()
if F._fovGui then return end
local host = nil
pcall(function() host = gethui and gethui() end)
if not host then pcall(function() host = CoreGui end) end
if not host then pcall(function() host = game:GetService("CoreGui") end) end
if not host then F.Out("[准星] 找不到可挂载的 GUI 容器"); return end
local ok = pcall(function()
local sg = Instance.new("ScreenGui")
sg.Name = "CM_FovRing"
pcall(function() sg:SetAttribute("CMOwned", true) end)
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 999
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = host
local circle = Instance.new("Frame")
circle.Name = "Ring"
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.Position = UDim2.fromScale(0.5, 0.5)
circle.BackgroundTransparency = 1
circle.BorderSizePixel = 0
circle.Size = UDim2.fromOffset((tonumber(C.AimFOV) or 200) * 2, (tonumber(C.AimFOV) or 200) * 2)
circle.Parent = sg
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = circle
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 255, 120)
stroke.Thickness = 2
stroke.Transparency = 0.1
stroke.Parent = circle
F._fovGui = sg
F._fovRing = circle
end)
if not ok or not F._fovGui then
F.Out("[准星] 创建失败(执行器不允许挂 GUI)")
F._fovGui = nil
return
end
local lastFov = -1
F._fovConn = RS.RenderStepped:Connect(function()
if not T.FovCircle then F.FovCircleDisable() return end
local fov = tonumber(C.AimFOV) or 200
if fov == lastFov then return end
lastFov = fov
pcall(function() F._fovRing.Size = UDim2.fromOffset(fov * 2, fov * 2) end)
end)
F.Out("[准星] FOV 圈已开(直径 " .. tostring((tonumber(C.AimFOV) or 200) * 2) .. " px)")
end
function F.FovCircleDisable()
if F._fovConn then F._fovConn:Disconnect() F._fovConn = nil end
if F._fovGui then pcall(function() F._fovGui:Destroy() end) F._fovGui = nil end
F._fovRing = nil
end
F._menuOpen = false
function F.MenuOpen()
local ok, v = pcall(function() return Fluent and Fluent.GUI and Fluent.GUI.Enabled end)
if ok and v ~= nil then return v and true or false end
return F._menuOpen and true or false
end
pcall(function()
UIS.InputBegan:Connect(function(input, processed)
if processed then return end
if input.KeyCode ~= Enum.KeyCode.G then return end
F._menuOpen = not F._menuOpen
if F._menuOpen then
pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.Default end)
else
pcall(F.CloseDropdowns)
end
end)
end)
pcall(function()
UIS.InputBegan:Connect(function(input, processed)
if processed then return end
if not F._tpMouseOn then return end
if input.KeyCode ~= Enum.KeyCode.T then return end
F.TPMouse()
end)
end)
F._hlObjs, F._hlAdded, F._hlLoop = {}, nil, nil
F.CMX_HLMode = function() return tostring(C.BodyHLMode or "①") end
F.CMX_HLTeamColor = function(pl)
local same = false
pcall(function() same = (pl.Team ~= nil and pl.Team == LP.Team) end)
if T.TeamColorHL == false then return Color3.fromRGB(0, 200, 255) end
return same and Color3.fromRGB(0, 255, 80) or Color3.fromRGB(255, 60, 60)
end
F.CMX_HLWarnColor = function()
local c = C.CMX_HLWallColor
if typeof(c) == "Color3" then return c end
return Color3.fromRGB(255, 190, 0)
end
F.CMX_HLDistColor = function(pl)
local _, _, root = GC()
local d = 0
pcall(function()
local h = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
if h and root then d = (h.Position - root.Position).Magnitude end
end)
local k = math.clamp(d / 300, 0, 1)
return Color3.fromRGB(255, 60, 60):Lerp(Color3.fromRGB(70, 140, 255), k), d
end
F.CMX_HLApply = function(pl, rec)
if not rec or not rec.top then return end
local team = F.CMX_HLTeamColor(pl)
pcall(function()
rec.top.FillColor = team
rec.top.OutlineColor = team
rec.top.FillTransparency = 0.45
rec.top.OutlineTransparency = 0
rec.top.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end)
F.CMX_HLSimple = true
if rec.occ then
pcall(function() rec.occ:Destroy() end)
rec.occ = nil
end
end
function F.BodyHLAdd(pl)
if not T.BodyHL or pl == LP then return end
local ch = pl.Character
if not ch then return end
local rec = F._hlObjs[pl]
if type(rec) == "table" and rec.top and rec.top.Parent == ch then
if rec.occ then pcall(function() rec.occ:Destroy() end) rec.occ = nil end
return
end
if rec then
if type(rec) == "table" then
if rec.top then pcall(function() rec.top:Destroy() end) end
if rec.occ then pcall(function() rec.occ:Destroy() end) end
else
pcall(function() rec:Destroy() end)
end
end
local top = Instance.new("Highlight")
top.Name = "BodyMark"
top.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
top.FillTransparency = 0.45
top.OutlineTransparency = 0
top.Parent = ch
F._hlObjs[pl] = { top = top, occ = nil, ch = ch }
F.CMX_HLApply(pl, F._hlObjs[pl])
end
function F.BodyHLRefresh()
for pl, rec in pairs(F._hlObjs) do
if type(rec) == "table" and rec.top then
pcall(F.CMX_HLApply, pl, rec)
elseif typeof(rec) == "Instance" then
local same = false
pcall(function() same = (pl.Team ~= nil and pl.Team == LP.Team) end)
local c = Color3.fromRGB(0, 200, 255)
if T.TeamColorHL ~= false then c = same and Color3.fromRGB(0, 255, 80) or Color3.fromRGB(255, 60, 60) end
pcall(function() rec.OutlineColor = c rec.FillColor = c end)
end
end
end
function F.BodyHLEnable()
for _, pl in ipairs(Players:GetPlayers()) do F.BodyHLAdd(pl) end
F.BodyHLRefresh()
if not F._hlRConn then
F._hlRConn = Players.PlayerRemoving:Connect(function(pl)
local rec = F._hlObjs[pl]
if rec then
if type(rec) == "table" then
if rec.top then pcall(function() rec.top:Destroy() end) end
if rec.occ then pcall(function() rec.occ:Destroy() end) end
else
pcall(function() rec:Destroy() end)
end
F._hlObjs[pl] = nil
end
end)
end
if not F._hlAdded then
F._hlAdded = Players.PlayerAdded:Connect(function(pl)
pl.CharacterAdded:Connect(function() task.wait(0.4) F.BodyHLAdd(pl) F.BodyHLRefresh() end)
end)
end
if not F._hlLoop then
F._hlLoop = RS.Heartbeat:Connect(function()
if not T.BodyHL then F.BodyHLDisable() return end
local now = os.clock()
local gap = 2
if F.CMX_HLMode():find("④", 1, true) then gap = 0.25 end
if now - (F._hlAt or 0) < gap then return end
F._hlAt = now
for _, pl in ipairs(Players:GetPlayers()) do F.BodyHLAdd(pl) end
F.BodyHLRefresh()
end)
end
end
function F.BodyHLDisable()
if F._hlAdded then F._hlAdded:Disconnect() F._hlAdded = nil end
if F._hlLoop then F._hlLoop:Disconnect() F._hlLoop = nil end
for _, rec in pairs(F._hlObjs) do
if type(rec) == "table" then
if rec.top then pcall(function() rec.top:Destroy() end) end
if rec.occ then pcall(function() rec.occ:Destroy() end) end
else
pcall(function() rec:Destroy() end)
end
end
F._hlObjs = {}
if F._hlRConn then F._hlRConn:Disconnect() F._hlRConn = nil end
end
function F.SyncMoveUI()
pcall(function()
if not (Fluent and Fluent.Options) then return end
local fop = Fluent.Options.FlyOn
if fop and type(T.FlyOn) == "boolean" and fop.Value ~= T.FlyOn then
pcall(function() fop:Set(T.FlyOn) end)
end
local sop = Fluent.Options.SpeedOn
if sop and type(T.SpeedOn) == "boolean" and sop.Value ~= T.SpeedOn then
pcall(function() sop:Set(T.SpeedOn) end)
end
end)
end
function F.SrcName(u)
local s = tostring(u)
local host = s:match("^https?://([^/]+)") or s
if s:find("raw.githubusercontent", 1, true) then host = host .. "(原生raw)" end
if s:find("jsdelivr", 1, true) then host = host .. "(缓存久)" end
return host
end
function F.VerNum(v)
local a, b, c = tostring(v):match("^(%d+)%.(%d+)%.(%d+)$")
if not a then return 0 end
return tonumber(a) * 1000000 + tonumber(b) * 1000 + tonumber(c)
end
function F.GetRemoteVersion(u)
local base = tostring(u):gsub("[^/]*$", "")
local ok, r = pcall(function() return game:HttpGet(base .. "version.txt?cb=" .. tostring(os.time())) end)
if ok and type(r) == "string" then
r = tostring(r):gsub("%s+$", "")
if r:match("^%d+%.%d+%.%d+$") then return r end
end
return nil
end
function F.HotReload(force)
local myv = tostring(F.VERSION or ""):gsub("^v", "")
local urls = F.REMOTE_URLS
if type(urls) ~= "table" or #urls == 0 then
F.Out("[热加载] ⚠ 没有可用的下载源")
return false
end
F.Out("[热加载] 正在问各源的最新版本号…(当前 v" .. myv .. ")")
local best, bestv = nil, nil
local seen = {}
for i = 1, #urls do
local rv = F.GetRemoteVersion(urls[i])
seen[#seen + 1] = F.SrcName(urls[i]) .. "=" .. tostring(rv or "取不到")
if rv and (not bestv or F.VerNum(rv) > F.VerNum(bestv)) then
best, bestv = urls[i], rv
end
end
F.Out("[热加载] 各源版本: " .. table.concat(seen, " · "))
if not bestv then
F.Out("[热加载] ⚠ 所有源都读不到版本号(网络/CDN 抖动) —— 本次不重载, 现有实例照常用, 过会儿再点")
pcall(function() Fluent:Notify({ Title = "热加载", Content = "读不到远端版本, 已放弃重载(现有实例照常用)", Duration = 6 }) end)
return false
end
if (not force) and F.VerNum(bestv) <= F.VerNum(myv) then
F.Out("[热加载] 已是最新 v" .. myv .. " (远端最高 " .. bestv .. ") ⇒ 无需重载")
pcall(function() Fluent:Notify({ Title = "热加载", Content = "你已经是最新 " .. myv .. " —— 没有重载", Duration = 5 }) end)
return false
end
F.Out("[热加载] 远端最新 " .. bestv .. " > 当前 " .. myv .. ", 开始下载(优先最新那个源)…")
pcall(function() Fluent:Notify({ Title = "热加载", Content = "正在取 " .. bestv .. " …", Duration = 6 }) end)
local keep, n = {}, 0
for k, v in pairs(T) do
if type(v) == "boolean" and v then keep[k] = true n = n + 1 end
end
task.spawn(function()
local order = { best }
for i = 1, #urls do
if urls[i] ~= best then order[#order + 1] = urls[i] end
end
local body, gotv, fallback = nil, nil, nil
for i = 1, #order do
if body then break end
local u = order[i] .. "?cb=" .. tostring(os.time())
local ok, r = pcall(function() return game:HttpGet(u) end)
if ok and type(r) == "string" and #r > 100000 then
local v = string.match(r, "F%.VERSION%s*=%s*" .. string.char(34) .. "v([%d%.]+)")
if v and F.VerNum(v) >= F.VerNum(bestv) then
body, gotv = r, v
elseif v and F.VerNum(v) > F.VerNum(myv) and not fallback then
fallback, gotv = r, v
end
end
end
if not body then
if fallback and force then
body = fallback
F.Out("[热加载] (强制模式)没有源给到 " .. bestv .. ", 用能拿到的最高版 v" .. tostring(gotv) .. " 顶上")
elseif fallback then
F.Out("[热加载] ⚠ 各源里最新只给到 v" .. tostring(gotv) .. ", 还没到 " .. bestv
.. " —— CDN 还在缓存旧版, 已放弃重载(现有实例没动)")
F.Out("[热加载]    过几分钟再点一次即可; 真想先用 v" .. tostring(gotv) .. " 就点「强制重载」")
pcall(function() Fluent:Notify({ Title = "热加载", Content = "源只给到 v" .. tostring(gotv)
.. "(最新是 " .. bestv .. "), 已放弃; 过几分钟再点", Duration = 8 }) end)
return
else
F.Out("[热加载] ⚠ 所有源都没给出比当前更新的版本 —— 已放弃, 现有实例没动")
pcall(function() Fluent:Notify({ Title = "热加载", Content = "源还在缓存旧版, 已放弃(现有实例照常用)", Duration = 8 }) end)
return
end
end
local bad = nil
if #body < 100000 then
bad = "长度不足"
elseif not (body:find("F.VERSION", 1, true) and body:find("F.REMOTE_URLS", 1, true)
and body:find("F.UnifiedACPass", 1, true) and body:find("CheatMenu", 1, true)) then
bad = "缺少关键标识"
else
local head = string.lower(body:sub(1, 512))
if head:find("<!doctype", 1, true) or head:find("<html", 1, true) then
bad = "拿到的是网页不是脚本"
elseif not body:find("F%.VERSION%s*=%s*" .. string.char(34) .. "v%d+%.") then
bad = "版本行格式不对"
end
end
if bad then
F.Out("[热加载] ⚠ 远程内容未通过自检(" .. bad .. ") —— 没有执行任何远程代码, 现有实例没动")
return
end
local fnc = loadstring or load
local chunk, err = fnc(body, "@CheatMenu_hot")
if not chunk then
F.Out("[热加载] ⚠ 新版本编译失败: " .. tostring(err) .. " —— 现有实例没动")
return
end
pcall(function() if writefile then writefile("CheatMenu_main.lua", body) end end)
F.Out("[热加载] 已取到 v" .. tostring(gotv) .. " (" .. tostring(#body) .. " 字节) 并通过自检 ⇒ 现在才卸载旧实例并重启")
pcall(function() if getgenv then getgenv().CM_RELOAD_KEEP = keep end end)
pcall(function() F.Out("[热加载] 已记下 " .. tostring(n) .. " 个开着的功能") end)
pcall(function() F.UnloadAll() end)
task.wait(0.6)
pcall(chunk)
end)
return true
end
F._freecamConn = nil
function F.FreecamEnable()
if F._freecamConn then return end
local cam = workspace.CurrentCamera
if not cam then return end
local saveSubj = cam.CameraSubject
pcall(function()
local _, myHum = GC()
if myHum and saveSubj and saveSubj ~= myHum and typeof(saveSubj) == "Instance" and saveSubj:IsA("Humanoid") then
local owner = nil
pcall(function() owner = Players:GetPlayerFromCharacter(saveSubj.Parent) end)
if owner and owner ~= LP then saveSubj = myHum end
end
end)
F._freecamSaved = { Type = cam.CameraType, Subject = saveSubj }
local cf = cam.CFrame
pcall(function()
local _, hum = GC()
if hum then F._freecamWalk = hum.WalkSpeed hum.WalkSpeed = 0 end
end)
local yaw = math.atan2(-cf.LookVector.X, -cf.LookVector.Z)
local pitch = math.asin(math.clamp(cf.LookVector.Y, -1, 1))
cam.CameraType = Enum.CameraType.Scriptable
if (not F.MenuOpen()) and (not UIS.TouchEnabled) then pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.LockCenter end) end
F._freecamConn = RS.RenderStepped:Connect(function(dt)
if not T.Freecam then F.FreecamDisable() return end
local c = workspace.CurrentCamera
if not c then return end
if c.CameraType ~= Enum.CameraType.Scriptable then c.CameraType = Enum.CameraType.Scriptable end
local locked = (UIS.MouseBehavior == Enum.MouseBehavior.LockCenter)
if not locked then F._mouseFreeAt = os.clock() end
if F.MenuOpen() or UIS.TouchEnabled or (os.clock() - (F._mouseFreeAt or 0) < 0.8) then
pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.Default end)
elseif not locked then
pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.LockCenter end)
end
local delta = UIS:GetMouseDelta()
yaw = yaw - delta.X * 0.003
pitch = math.clamp(pitch - delta.Y * 0.003, -1.45, 1.45)
local rot = CFrame.fromEulerAnglesYXZ(pitch, yaw, 0)
local dir = Vector3.zero
if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + rot.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - rot.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - rot.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + rot.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.E) then dir = dir + Vector3.new(0, 1, 0) end
if UIS:IsKeyDown(Enum.KeyCode.Q) then dir = dir - Vector3.new(0, 1, 0) end
local sp = C.FreecamSpeed or 50
if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then sp = sp * 3 end
local pos = c.CFrame.Position
if dir.Magnitude > 0 then pos = pos + dir.Unit * sp * math.min(dt, 0.1) end
c.CFrame = CFrame.new(pos) * rot
end)
end
function F.FreecamDisable()
if F._freecamConn then F._freecamConn:Disconnect() F._freecamConn = nil end
pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.Default end)
pcall(function()
local _, hum = GC()
if hum and F._freecamWalk then hum.WalkSpeed = F._freecamWalk end
end)
F._freecamWalk = nil
local cam = workspace.CurrentCamera
if cam and F._freecamSaved then
cam.CameraType = F._freecamSaved.Type or Enum.CameraType.Custom
cam.CameraSubject = F._freecamSaved.Subject
F._freecamSaved = nil
end
end
F._hiddenPlayers = nil
function F.HidePlayerEnable()
F._hiddenPlayers = F._hiddenPlayers or {}
local name = Fluent.Options.FlingTarget and Fluent.Options.FlingTarget.Value
local pl = name and Players:FindFirstChild(name)
local ch = pl and pl.Character
if not (pl and ch) then return end
F._hiddenPlayers[pl] = true
for _, d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") then d.LocalTransparencyModifier = 1 end
end
local hum0 = ch:FindFirstChildOfClass("Humanoid")
if hum0 then pcall(function() hum0.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end) end
if not F._hidePlConns then F._hidePlConns = {} end
if not F._hidePlConns[pl] then
F._hidePlConns[pl] = pl.CharacterAdded:Connect(function(nch)
task.wait(0.3)
if not F._hiddenPlayers[pl] then return end
for _, d in ipairs(nch:GetDescendants()) do
if d:IsA("BasePart") then d.LocalTransparencyModifier = 1 end
end
local h2 = nch:FindFirstChildOfClass("Humanoid")
if h2 then pcall(function() h2.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end) end
end)
end
end
function F.HidePlayerDisable()
if F._hiddenPlayers then
for pl in pairs(F._hiddenPlayers) do
local ch = pl.Character
if ch then
for _, d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") then d.LocalTransparencyModifier = 0 end
end
end
end
end
F._hiddenPlayers = {}
if F._hidePlConns then
for pl, c in pairs(F._hidePlConns) do pcall(function() c:Disconnect() end) end
F._hidePlConns = {}
end
end
F._lockCamConn = nil
function F.LockCamEnable()
if F._lockCamConn then return end
local cam = workspace.CurrentCamera
F._lockCamCF = cam and cam.CFrame or CFrame.new()
F._lockCamConn = RS.RenderStepped:Connect(function()
if not T.LockCam then F.LockCamDisable() return end
local c = workspace.CurrentCamera
if c then pcall(function() c.CFrame = F._lockCamCF end) end
end)
end
function F.LockCamDisable()
if F._lockCamConn then F._lockCamConn:Disconnect() F._lockCamConn = nil end
end
F.PANIC_KEEP = { CharPersist = true, AutoSave = true, GuiProtect = true,
AntiAFK = true, KickGuard = true, GuardOn = true, HitGuard = true, SteadyOn = true,
TrapWarn = true, SpeedGuard = true }
function F.PanicKeyDisableAll()
local keep = {}
for k in pairs(F.PANIC_KEEP) do keep[k] = T[k] end
local wasOn = {}
for k, v in pairs(T) do
if v == true and not F.PANIC_KEEP[k] then wasOn[#wasOn + 1] = tostring(k) end
end
for k in pairs(T) do
if type(T[k]) == "boolean" then T[k] = false end
end
for k, v in pairs(keep) do T[k] = v end
F._tpMouseOn = false
for _, fn in ipairs({ GodDisable, FOVDisable, ZoomDisable, AntilagDisable, MuteDisable, LockHealthDisable, RegenDisable, NoDeathDisable, F.InvisibleDisable, F.CarryGuardDisable, F.GuardOnDisable, F.KickGuardPathsDisable }) do pcall(fn) end
for _, fn in ipairs({ F.HudDisable, F.CrosshairDisable, F.FovCircleDisable, F.FreecamDisable, F.HidePlayerDisable, F.KillAuraDisable, F.AntiRagdollDisable, F.AntiKnockdownDisable, F.NoClipDisable, F.HideDisable, F.InfiniteJumpDisable, F.FullBrightDisable, F.NightVisionDisable, F.NoFogDisable, F.TranslateDisable, F.ChatTranslateDisable, F.BubbleTranslateDisable, F.LockCamDisable }) do pcall(fn) end
for _, fn in ipairs({ F.AimSet, F.KickRejoinDisable, F.BodyHLDisable, F.CharPersistDisable, F.LivePlayersDisable, F.AutoSaveDisable, F.GuiProtectionDisable, F.SpeedAntiTPDisable, F.SpeedRestore, F.FlySet, F.FlyDestroy, F.BypassDisable, F.AllInOneDisableAll, F.PinDisable, F.SpoofDisable, F.MetaHookUninstall, F.AntiCheatGCRestore, F.DeepNeuterDisable, F.AutoTrainDisable, F.AutoBonusDisable, F.AutoGymDisable, F.SilentAimDisable, F.HealthShowSet, F.HealthIsolateDisable, F.LockFieldsUninstall }) do pcall(fn) end
for _, fn in ipairs({ AC.UninstallNamecallHook, AC.UninstallIndexMask, AC.UnblockRemotes, AC.ReenableDisabledConns, AC.UninstallAntiTP, AC.UninstallSetmetatableHook, AC.WatchNewScriptsDisable, AC.WatchNewRemotesDisable, AC.AntiPauseDisable, AC.TrapDisable.Disable, F.CaptureDisable, F.InstantInteractDisable, F.CMX_DisableAll, F.LightWatchDisable }) do pcall(fn) end
pcall(function()
local _, hum = GC()
if hum then
local o = F._orig or {}
local bw = tonumber(F._preSpeed)
F._preSpeed = nil
if bw and bw > 0 then hum.WalkSpeed = bw end
if o.jumpPower then hum.JumpPower = o.jumpPower end
if o.jumpHeight then pcall(function() hum.JumpHeight = o.jumpHeight end) end
local mh = hum.MaxHealth
if type(mh) ~= "number" or mh > 1000 or mh ~= mh then
hum.MaxHealth = o.maxHealth or 100
end
hum.Health = math.min(hum.Health, hum.MaxHealth)
hum.PlatformStand = false
pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
end
local cam = workspace.CurrentCamera
if cam then cam.FieldOfView = (F._orig and F._orig.fov) or 70 end
end)
pcall(function()
local ch = LP.Character
if not ch then return end
for _, d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") then
pcall(function() d.LocalTransparencyModifier = 0 end)
elseif d:IsA("Decal") or d:IsA("Texture") then
pcall(function() d.Transparency = 0 end)
elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Highlight") then
pcall(function() d.Enabled = true end)
elseif d:IsA("BillboardGui") or d:IsA("SurfaceGui") then
pcall(function() d.Enabled = true end)
end
end
local h = ch:FindFirstChildOfClass("Humanoid")
if h then
pcall(function() h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end)
end
end)
pcall(function()
if not (Fluent and Fluent.Options) then return end
for name, opt in pairs(Fluent.Options) do
if not F.PANIC_KEEP[name] and opt and opt.Value == true then
local ty = nil
pcall(function() ty = opt.Type end)
if type(ty) ~= "string" then
if type(opt.Value) == "boolean" then ty = "Toggle" end
end
if (ty == "Toggle" or ty == "toggle") and type(opt.Set) == "function" then
pcall(function() opt:Set(false) end)
end
end
end
end)
if #wasOn > 0 then
F.Out("[急停] 本次关掉的功能: " .. table.concat(wasOn, ", "))
end
F.Out("[急停] 已保留(防护类不关): 角色持续 · 自动存档 · 护界面 · 挂机防踢 · 受击/稳身/陷阱防护 · 速度守卫")
pcall(F.CfgSyncUI)
if Fluent and Fluent.Notify then
Fluent:Notify({ Title = "Panic", Content = "已关闭所有功能并恢复原始状态", Duration = 3 })
end
F.Out("[CheatMenu] Panic: 全部功能已关闭, 属性/外观/连接已恢复")
end
function F.RecordOriginals()
local _, hum = GC()
F._orig = F._orig or {}
if hum then
local w = tonumber(hum.WalkSpeed)
if not F._orig.walk and w and w > 0 then F._orig.walk = w end
if not F._orig.jumpPower and hum.JumpPower then F._orig.jumpPower = hum.JumpPower end
if not F._orig.jumpHeight and hum.JumpHeight then F._orig.jumpHeight = hum.JumpHeight end
local mh = tonumber(hum.MaxHealth)
if not F._orig.maxHealth and mh and mh == mh and mh ~= math.huge then F._orig.maxHealth = mh end
end
if not F._orig.maxZoom then F._orig.maxZoom = LP.CameraMaxZoomDistance end
if not F._orig.minZoom then F._orig.minZoom = LP.CameraMinZoomDistance end
local cam = workspace.CurrentCamera
if cam and not F._orig.fov then F._orig.fov = cam.FieldOfView end
if not F._baseWalk and F._orig.walk then F._baseWalk = F._orig.walk end
end
function F.RejoinNow()
local jid = tostring(game.JobId or "")
if jid == "" then
F.Out("[重进] 拿不到当前服务器 ID(JobId 为空: 多半在 Studio / 非公共服) 本次没执行")
return false
end
local ts = game:GetService("TeleportService")
pcall(function()
if F._tpFailConn then pcall(function() F._tpFailConn:Disconnect() end) end
F._tpFailConn = ts.TeleportInitFailed:Connect(function(plr, code, msg)
if plr ~= LP then return end
F.Out("[重进] 传送失败: " .. tostring(code) .. " · " .. tostring(msg) .. " ⇒ 手动从 Roblox 菜单重进吧")
end)
task.delay(20, function()
if F._tpFailConn then pcall(function() F._tpFailConn:Disconnect() end) F._tpFailConn = nil end
end)
end)
F.Out("[重进] 正在回到当前服务器(" .. tostring(game.PlaceId) .. " · " .. jid:sub(1, 12) .. ")")
local ok = pcall(function() ts:TeleportToPlaceInstance(game.PlaceId, jid, LP) end)
if ok then
pcall(function() Fluent:Notify({ Title = "重新进入", Content = "正在回到当前服务器…", Duration = 3 }) end)
return true
end
F.Out("[重进] 回本服失败(执行器可能禁了) 改为重进游戏(会换服务器)")
local ok2 = pcall(function() ts:Teleport(game.PlaceId, LP) end)
if ok2 then
pcall(function() Fluent:Notify({ Title = "重新进入", Content = "已改为重进游戏(可能换服)", Duration = 3 }) end)
else
F.Out("[重进] 两种方式都被挡 请手动从 Roblox 菜单重进")
end
return ok2
end
F._saveThread = nil
F.Conn = { list = {} }
function F.Conn.ClearAll()
for _, c in pairs(F.Conn.list) do pcall(function() c:Disconnect() end) end
F.Conn.list = {}
end
local GYM_WEIGHT_NAMES = {
["Wooden Stick"]=true,["Bone Barbell"]=true,["Stone Block"]=true,["Copper Plate"]=true,
["Iron Plate"]=true,["Ice Barbell"]=true,["Donut Barbell"]=true,["Golden Barbell"]=true,
["Heaven Plate"]=true,["Mega Golden Barbell"]=true,["Neon Pulse"]=true,
["Giant Gold Star Barbell"]=true,["Emerald Barbell"]=true,["Planet Barbell"]=true,
["Big Jupiter"]=true,["Black Hole Barbell"]=true,
}
local function equipSquatTool()
local _, hum = GC()
if not hum then return end
local bp = LP:FindFirstChild("Backpack")
for _, ct in ipairs({ bp, LP.Character }) do
if ct then
for _, t in ipairs(ct:GetChildren()) do
if t:IsA("Tool") then
local ok, ht = pcall(function() return t:HasTag("SquatTool") end)
if ok and ht then pcall(function() hum:EquipTool(t) end) return t end
end
end
end
end
for _, ct in ipairs({ bp, LP.Character }) do
if ct then
for _, t in ipairs(ct:GetChildren()) do
if t:IsA("Tool") and GYM_WEIGHT_NAMES[t.Name] then
pcall(function() hum:EquipTool(t) end)
return t
end
end
end
end
end
local function kickUpgradesGui()
local g = PG
pcall(function() g = LP:FindFirstChild("PlayerGui") or g end)
return g and g:FindFirstChild("KickUpgrades") or nil
end
local function isBrainrotTool(t)
local ok, r = pcall(function() return t:GetAttribute("Rarity") end)
if ok and r ~= nil then return true end
ok, r = pcall(function() return t:FindFirstChild("Rarity") end)
return (ok and r ~= nil) and true or false
end
local function weightTool()
local ch = LP.Character
local bp = LP:FindFirstChild("Backpack")
local containers = { ch, bp }
for _, ct in ipairs(containers) do
if ct then
for _, t in ipairs(ct:GetChildren()) do
if t:IsA("Tool") then
local ok, ht = pcall(function() return t:HasTag("SquatTool") end)
if ok and ht then return t end
end
end
end
end
for _, ct in ipairs(containers) do
if ct then
for _, t in ipairs(ct:GetChildren()) do
if t:IsA("Tool") and GYM_WEIGHT_NAMES[t.Name] and not isBrainrotTool(t) then return t end
end
end
end
for _, ct in ipairs(containers) do
if ct then
for _, t in ipairs(ct:GetChildren()) do
if t:IsA("Tool") and not isBrainrotTool(t) then return t end
end
end
end
end
local function guiClick(b)
if not (b and b:IsA("GuiButton")) then return false end
local did = false
if type(getconnections) == "function" then
for _, sig in ipairs({ b.InputBegan, b.MouseButton1Down, b.MouseButton1Up, b.MouseButton1Click, b.Activated }) do
if sig then
pcall(function()
for _, c in ipairs(getconnections(sig) or {}) do
pcall(function() c:Fire({ UserInputType = Enum.UserInputType.MouseButton1, UserInputState = Enum.UserInputState.Begin }) end)
pcall(function() c:Fire() end)
end
end)
end
end
end
if firesignal then
pcall(function() firesignal(b.MouseButton1Click) did = true end)
pcall(function() firesignal(b.Activated) did = true end)
end
pcall(function()
local cam = workspace.CurrentCamera
local vp = (cam and cam.ViewportSize) or Vector2.new(800, 600)
local ap, as = b.AbsolutePosition, b.AbsoluteSize
local x = math.clamp(ap.X + as.X * 0.5, 2, math.max(3, vp.X - 2))
local y = math.clamp(ap.Y + as.Y * 0.5, 2, math.max(3, vp.Y - 2))
local vim = game:GetService("VirtualInputManager")
vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
did = true
end)
return did
end
local function clickBonusButtons(anyButton)
local kupg = kickUpgradesGui()
if not kupg then return 0, false end
local n, sawBonus = 0, false
for _, b in ipairs(kupg:GetChildren()) do
if b:IsA("GuiButton") then
local okv, vis = pcall(function() return b.Visible end)
if okv and vis then
local isBonus = (b.Name == "Bonus" or b.Name == "PopBonus")
if isBonus then sawBonus = true end
if (isBonus or anyButton) and guiClick(b) then n = n + 1 end
end
end
end
return n, sawBonus
end
local function trainTickOnce()
local ch, hum = GC()
if not (ch and hum) then return end
local w = weightTool()
if w then
if w.Parent ~= ch then pcall(function() hum:EquipTool(w) end) end
pcall(function() w:Activate() end)
end
clickBonusButtons(false)
end
local GymThread = nil
local function liveMachines()
local r = {}
local ok, t = pcall(CS.GetTagged, CS, "LiftMachine")
if ok and type(t) == "table" then
for _, m in ipairs(t) do
if m and m.Parent and m:IsDescendantOf(WS) then r[#r + 1] = m end
end
end
return r
end
local function AutoGymLiftMachineLegacy()
if GymThread then return end
GymThread = task.spawn(function()
while T.AutoGym do
local machines = liveMachines()
local _, _, root = GC()
if #machines > 0 and root then
local best, bestDist = nil, math.huge
for _, m in ipairs(machines) do
local pos
if m:IsA("Model") then
local ok, pivot = pcall(m.GetPivot, m)
if ok then pos = pivot.Position end
elseif m:IsA("BasePart") then pos = m.Position end
if pos then
local d = (root.Position - pos).Magnitude
if d < bestDist then bestDist = d best = m end
end
end
if best then
local lv = math.max(1, tonumber(LP:GetAttribute("liftMachine")) or 1)
if lv <= 1 then
local pos
if best:IsA("Model") then
local ok, pivot = pcall(best.GetPivot, best)
if ok then pos = pivot.Position end
elseif best:IsA("BasePart") then pos = best.Position end
if pos then
local target = pos + Vector3.new(0, 3, 0)
if (root.Position - target).Magnitude > 2.5 then
if os.clock() - (F._gymNote or 0) > 8 then
F._gymNote = os.clock()
F.Out("[健身房] 检测到机器在 " .. string.format("%.0f", (root.Position - target).Magnitude) .. " 格外 —— 已不再自动把你吸上机器, 你自己站上去(站着+手持配重就会算锻炼)")
end
end
pcall(function() equipSquatTool() end)
local _, hum2 = GC()
for _i = 1, 5 do
if not T.AutoGym then break end
if hum2 then pcall(function() hum2:Move(Vector3.zero, false) end) end
pcall(function()
local vim = game:GetService("VirtualInputManager")
vim:SendKeyEvent(true, Enum.KeyCode.W, false, game)
task.wait(0.15)
vim:SendKeyEvent(false, Enum.KeyCode.W, false, game)
end)
task.wait(0.15)
end
local lv2 = tonumber(LP:GetAttribute("liftMachine")) or 0
if lv2 ~= (F._gymLv or -1) then
F._gymLv = lv2
F.Out("[健身房] 已站上机器 · liftMachine=" .. tostring(lv2)
.. (lv2 > 0 and " (在涨 ⇒ 效果吃上了)" or " (还是 0 ⇒ 游戏没判定你在锻炼, 把这条发我)"))
end
end
else equipSquatTool() end
end
end
task.wait(1)
end
GymThread = nil
end)
end
local TrainThread = nil
function F.AutoTrainEnable()
if TrainThread then return end
F.Out("[训练] 已启动: 自动手持配重并 Activate (锻炼加成请同时开「自动锻炼(健身房)」)")
TrainThread = task.spawn(function()
while T.AutoTrain do
pcall(trainTickOnce)
task.wait(math.max(0.3, tonumber(C.AutoTrainSec) or 1))
end
TrainThread = nil
end)
end
function F.AutoTrainDisable()
T.AutoTrain = false
TrainThread = nil
F.Out("[训练] 已停止")
end
local GymThread2 = nil
F.GymRetrigger = function()
local _, hum, root = GC()
if not root then return end
pcall(function()
local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
if tool then tool:Activate() end
end)
pcall(function() mouse1click() end)
pcall(function()
local vim = game:GetService("VirtualInputManager")
vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
task.wait(0.05)
vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end)
F.Out("[健身房] 已重新开始锻炼(激活手上配重 + 触发一次动作)")
end
F.FindCurrencyPart = function(i)
local want = tostring(i)
local best = nil
pcall(function()
for _, d in ipairs(workspace:GetDescendants()) do
if d:IsA("BasePart") then
local nm = tostring(d.Name):lower()
if nm:find(want, 1, true) or tostring(d:GetAttribute("slot")) == want then
for _, k in ipairs({ "cash", "coin", "money", "currency", "drop", "loot", "pickup", "collect", "现金", "钱" }) do
if nm:find(k, 1, true) then best = d break end
end
end
if best then break end
end
end
end)
return best
end
F.FindMyBase = function()
local uid, nm = tostring(LP.UserId), tostring(LP.Name)
local cached = F._myBase
if cached and cached.Parent then return cached end
local cand = nil
pcall(function()
for _, d in ipairs(workspace:GetDescendants()) do
if d:IsA("Model") or d:IsA("Folder") then
local mine = false
pcall(function()
local own = d:GetAttribute("Owner") or d:GetAttribute("owner") or d:GetAttribute("UserId") or d:GetAttribute("userId") or d:GetAttribute("Placer")
if own ~= nil and tostring(own) == uid then mine = true end
end)
if not mine then
local n2 = tostring(d.Name)
if n2 == nm or n2:find(uid, 1, true) or n2:find(nm, 1, true) then mine = true end
end
if mine then cand = d break end
end
end
end)
F._myBase = cand
if cand then F.Out("[收集] 我的基地/家 = " .. tostring(cand:GetFullName())) end
return cand
end
F.CollectTP_OLD = function(maxSlot)
task.spawn(function()
local _, _, root = GC()
if not root then F.Out("[收集] 没有角色, 稍后再点") return end
local n = 0
for i = 1, (maxSlot or 30) do
if not root.Parent then break end
local part = F.FindCurrencyPart(i)
if part then
pcall(function() root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0)) end)
pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
task.wait(0.25)
end
pcall(F.CollectAll, i)
n = n + 1
task.wait(0.12)
end
F.Out("[收集] 已按槽位 1~" .. tostring(maxSlot or 30) .. " 逐个 TP 过去再收集(共 " .. tostring(n) .. " 次)")
end)
end
function F.AutoGymEnable()
if GymThread2 or GymThread then return end
pcall(function()
if kickUpgradesGui() then
F.Out("[健身房] 已启动: 手持配重 + 自动点击 KickUpgrades 的 Bonus/PopBonus 锻炼弹窗")
GymThread2 = task.spawn(function()
local noGui = 0
while T.AutoGym do
pcall(trainTickOnce)
if kickUpgradesGui() then noGui = 0 else noGui = noGui + 1 end
if noGui >= 40 then
F.Out("[健身房] 找不到 KickUpgrades ⇒ 退回旧的举铁机(LiftMachine)逻辑")
break
end
pcall(F.GymRetrigger)
task.wait(tonumber(C.AutoGymRate) or 0.12)
end
GymThread2 = nil
if T.AutoGym then pcall(AutoGymLiftMachineLegacy) end
end)
else
F.Out("[健身房] 本游戏没有 KickUpgrades 锻炼界面 ⇒ 走旧的举铁机(LiftMachine)逻辑")
AutoGymLiftMachineLegacy()
end
end)
end
function F.AutoGymDisable()
T.AutoGym = false
GymThread2 = nil
F.Out("[健身房] 已停止")
end
local function multiplierFromText(v)
local compact = tostring(v or ""):upper():gsub("%s+", ""):gsub("×", "X")
if compact == "X2" or compact == "2X" then return 2
elseif compact == "X5" or compact == "5X" then return 5
elseif compact == "X10" or compact == "10X" then return 10 end
end
local function scanMultiplierButtons()
local roots = { PG, CoreGui }
if gethui then pcall(function() table.insert(roots, gethui()) end) end
local n = 0
for _, root in ipairs(roots) do
if root then
local ok, list = pcall(function() return F.walk(root, 20000) end)
if ok and type(list) == "table" then
for _, obj in ipairs(list) do
if obj:IsA("TextButton") then
local okv, vis = pcall(function() return obj.Visible end)
if okv and vis then
local hit = multiplierFromText(obj.Text) and true or false
if not hit then
for _, child in ipairs(F.walk(obj, 60)) do
if (child:IsA("TextLabel") or child:IsA("TextButton")) and multiplierFromText(child.Text) then
hit = true break
end
end
end
if hit and guiClick(obj) then n = n + 1 end
end
end
end
end
end
end
return n
end
local function collectCashOnce()
local r = REvent("rev_B_Collect")
if r then
for i = 1, 12 do
if not T.AutoBonus then break end
pcall(function() r:FireServer(i) end)
end
end
pcall(function()
local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
local plots = WS:FindFirstChild("Plots")
if not (hrp and plots and firetouchinterest) then return end
for _, plot in ipairs(plots:GetChildren()) do
local owner = nil
pcall(function() owner = plot:GetAttribute("Owner") end)
local btns = plot:FindFirstChild("Buttons")
if owner == LP.Name and btns then
for _, slot in ipairs(btns:GetChildren()) do
pcall(function() firetouchinterest(hrp, slot, 0) end)
pcall(function() firetouchinterest(hrp, slot, 1) end)
end
end
end
end)
end
local BonusThread = nil
function F.AutoBonusEnable()
if BonusThread and T.AutoBonus then return end
F.Out("[领奖] 已启动: 点 KickUpgrades 的 Bonus/PopBonus 奖励 + 收现金 rev_B_Collect + 触碰地盘收钱按钮")
BonusThread = task.spawn(function()
local logAt, total = 0, 0
while T.AutoBonus do
pcall(function()
local n, saw = clickBonusButtons(false)
if not saw then n = n + scanMultiplierButtons() end
collectCashOnce()
if n > 0 then
total = total + n
if os.clock() - logAt > 20 then
logAt = os.clock()
F.Out("[领奖] 已点掉 " .. tostring(total) .. " 个奖励按钮")
end
end
end)
task.wait(math.max(0.1, tonumber(C.AutoBonusRate) or 0.5))
end
BonusThread = nil
end)
end
function F.AutoBonusDisable()
T.AutoBonus = false
BonusThread = nil
F.Out("[领奖] 已停止")
end
do
local CPS = {
["Noobini Pizzanini"]=2,["Lirili Larila"]=3,["Tim Cheese"]=3,["Talpa Di Fero"]=4,
["Svinina Bombardino"]=5,["Pipi Kiwi"]=6,["Fruli Frula"]=7,["Trippi Troppi"]=7,
["Gangster Footera"]=15,["Bobrito Bandito"]=17,["Boneca Ambalabu"]=17,
["Ta Ta Ta Ta Sahur"]=18,["Ballerina Cappuccina"]=19,["Cappuccino Assassino"]=22,
["Brr Brr Patapim"]=22,["Cacto Hipopotamo"]=26,["Garamararam"]=40,
["Madung"]=44,["Waterdino"]=50,["Pesto Mortioni"]=52,["Pannaburro"]=62,
["Orcalero"]=64,["Mangolini Parrocini"]=64,["John Pork"]=72,
["Gattatino Nyanino"]=76,["Chimpanzini Bananini"]=100,["Plan Red"]=130,
["Plan Blue"]=140,["Capi Taco"]=150,["Trulimero Trulicina"]=160,
["Bambini Crostini"]=160,["Elefantucci Bananucci"]=170,
["Bananita Dolphinita"]=235,["Salamino Pinguino"]=280,
["Penguino Cocosino"]=450,["67"]=500,["Burbaloni Luliloli"]=550,
["Chef Crabracadabra"]=600,["Capybara Eggplant"]=650,["Bangello"]=725,
["Elefanto Frigo"]=775,["Rinooccio Verdini"]=880,["Glorbo Fruttodrillo"]=950,
["Udin Din Din Dun"]=1850,["Pandaccini Bananini"]=2000,
["Octopusini Bluberini"]=2150,["Strawberelli Flamingelli"]=2300,
["Sigma Boy"]=2450,["Frigo Camelo"]=2600,["Orangutini Ananasini"]=2700,
["Rhino Toasterino"]=2950,["Bombardiro Crocodilo"]=3100,
["Bombini Gusini"]=4750,["Castlino Fortini"]=5000,["Tuff Toucan"]=5300,
["Fryuro"]=5850,["Burguro"]=6250,["Guest666"]=7000,
["Zibra Zubra Zibralini"]=7750,["Cavallo Virtuso"]=10000,
["Gorillo Watermelondrillo"]=12000,["Cocofanto Elefanto"]=14000,
["Bambu Sahur"]=12500,["W or L"]=15000,["Girafa Celeste"]=16500,
["Tralalero Tralala"]=17500,["Tralalerita Tralala"]=18000,
["Peant Jarro"]=19500,["Dipperi Chiperini"]=20000,["Rexosaurus"]=22500,
["1x1x1x1"]=25000,["Matteo"]=30000,["Espresso Signora"]=36500,
["Alessio"]=27500,["Tripi Tropi Tropa Tripa"]=28000,["SWAG SODA"]=29000,
["Stoppo Luminino"]=30000,["Torrtuginni Dragonfrutini"]=32000,
["Tictac Sahur"]=38000,["Los Primos Blue"]=44500,["Cactus Pingu"]=55000,
["La Vacca Saturno Saturnita"]=70000,["Agarrini La Palini"]=90000,
["Bottellini"]=75000,["Karkerkar Kurkur"]=120000,["Blackhole Goat"]=125000,
["Cappuccino Clownino"]=135000,["Compactoroni Diskaloni"]=135000,
["Nuclearo Dinossauro"]=190000,["Los Nooo My Hotspotsitos"]=200000,
["Chillin Chilli"]=220000,["Crazylone Pizaione"]=225000,["Corn Sahur"]=225000,
["Meowl"]=275000,["Strawberry Elephant"]=420000,
["Dragonfrutina Dolphinita"]=475000,["Guerriro Digitale"]=490000,
["Chicleteira Bicicleteira"]=500000,["Pot Hotspot"]=525000,
["Krupuk Pagi Pagi"]=540000,["Beluga Beluga"]=575000,["Tralaledon"]=625000,
["Anpali Babel"]=750000,["Los Primos"]=800000,["Ketchuru Matsuru"]=800000,
["Mastodontico Telepiedone"]=850000,["Espresso Shockantoni"]=1000000,
["Ketupat Kepat"]=1250000,["Professora 67"]=1400000,["Astro Tim"]=1500000,
["Dumbelloni"]=1750000,["Baba Yaga"]=2000000,["Don Tiramisotto"]=2250000,
["Kicky"]=2500000,["Smelloni Papayoni"]=2750000,["Barbelloni Gymrattoni"]=3000000,
["Dribbloni Spaghetti"]=7500000,["Coinator Baconator"]=6500000,
["Lucky Fella"]=5000000,["Pulcino Pistoletti"]=10000000,
["Divinello Starblock"]=8750000,["Cordraculo"]=10000000,
["Harpini Goosini"]=11250000,["OctoDJ"]=15000000,["Tubafante"]=12500000,
["Turtinella Melodica"]=16500000,["Cucumbro Nerdino"]=2500000,
}
local MutBuff = {Golden=1.5,Diamond=2,Plasma=4,Molten=6,Radioactive=8,
Shadow=12,Electrified=16,Rainbow=40,Astral=50,Infinity=75,
Void=12,Virus=14,Wet=16,Alien=22,Bacon=30,Enchanted=12,
Phantom=35,Volcanic=35,Heavenly=36,Carnival=37,
["Block Cup"]=38,Undead=35,Jungle=40,Frozen=40}
local EXCLUSIVE_SET = {["W"]=true,["Dragon Cannelloni"]=true,["Spaghetti Tualetti"]=true,["Esok Sekolah"]=true,["Job Job Job Sahur"]=true,["Yess My Examen"]=true,["Lucky Kick"]=true,["Hippocopter"]=true,["Auto Grizzlioni"]=true,["Los Bombardinos"]=true,["Rocky"]=true,["Hat Tricky"]=true,["GOAT"]=true,["Bronze Block Medali"]=true,["Golden Block Cuppy"]=true,["Silver Block Cuppy"]=true,["Bronze Block Cuppy"]=true,["Golden Block Medali"]=true,["Silver Block Medali"]=true,["Stadoini"]=true,["Cone Cone Cone Sahur"]=true,["Ballberto"]=true,["Soccerdino"]=true,["Netini Goalini"]=true,["Orangutango Supremo"]=true,["Croakumber"]=true,["Lampuccio Raccoonelli"]=true,["Tuki Tuki Taco"]=true,["Professor Tigrellini"]=true,["Patagotitan"]=true,["Frigorex"]=true,["Velacoraptor"]=true,["Bicletairussaurus"]=true,["Jet Jet Raptoret"]=true,["Tricerabob"]=true,["Teacherrina"]=true,["Locko Blocko"]=true,["Scuolabus Giraffini"]=true,["Donutello"]=true,["Professor Penneroni"]=true,["Brain Mogger"]=true}
local EX_WORDS = { "exclusive", "独家", "专属", "limited", "限定", "vip", "percent", "百分比", "幸运", "lucky", "%", "x2", "x5", "x10", "x20", "x50" }
local SELLER_NAME = "Timmy"
local SELLER_CF = CFrame.new(134.125, 0.125, 83.866) * CFrame.Angles(0, -1.5707963267948966, 0)
local SellThread, WithdrawThread, CollectThread = nil, nil, nil
local function isEntityTool(t)
if not t or not t:IsA("Tool") then return false end
local ok, ht = pcall(function() return t:HasTag("EntityTool") end)
return ok and ht
end
local function isExclusiveTool(t)
if not t then return false end
if EXCLUSIVE_SET[t.Name] then return true end
local n = string.lower(t.Name)
for i = 1, #EX_WORDS do
if string.find(n, EX_WORDS[i], 1, true) then return true end
end
if t:GetAttribute("Exclusive") or t:GetAttribute("IsExclusive")
or t:GetAttribute("Limited") or t:GetAttribute("IsLimited")
or t:GetAttribute("Percent") or t:GetAttribute("Multiplier") then
return true
end
return false
end
local function baseCPSOf(tool)
if not tool then return nil end
local base = CPS[tool.Name]
if base then return base, "内置表" end
local a = tool:GetAttribute("CPS") or tool:GetAttribute("BaseCPS")
if typeof(a) == "number" then return a, "物品属性" end
return nil
end
local function lvMul()
local lm = tonumber(C.SellLvMul) or 1.25
if lm <= 0 then lm = 1.25 end
return lm
end
local function toolLevel(tool)
return math.clamp(math.floor(tonumber(tool:GetAttribute("Level")) or 1), 1, 75)
end
local function cpsOf(tool)
if not tool then return nil end
local v = nil
for _, k in ipairs({ "CPS", "Cps", "cps", "Value", "Income", "Money", "PerSecond", "Earnings", "price", "Price" }) do
local okA, a = pcall(function() return tool:GetAttribute(k) end)
if okA and type(a) == "number" and a > 0 then return a end
pcall(function()
local c = tool:FindFirstChild(k)
if c and (c:IsA("NumberValue") or c:IsA("IntValue") or c:IsA("StringValue")) then
local n = tonumber(tostring(c.Value))
if not n then n = tonumber((tostring(c.Value):lower():gsub("k", "e3"):gsub("m", "e6"):gsub("b", "e9"):gsub("[^%d%.e]", ""))) end
if n and n > 0 then v = n end
end
end)
if v then return v end
end
local texts = {}
pcall(function()
for _, d in ipairs(tool:GetDescendants()) do
if d:IsA("TextLabel") or d:IsA("TextButton") then
local s = nil
pcall(function() s = d.Text end)
if type(s) == "string" and s ~= "" then texts[#texts + 1] = s end
end
end
end)
texts[#texts + 1] = tostring(tool.Name)
local SUF = { k = 1e3, m = 1e6, b = 1e9, t = 1e12, q = 1e15 }
for _, s in ipairs(texts) do
local low = string.lower(tostring(s))
for num, suf in string.gmatch(low, "(%d+%.?%d*)([kmbtq])") do
local mul = SUF[suf]
if mul then return tonumber(num) * mul end
end
end
for _, s in ipairs(texts) do
local num = tostring(s):match("([%d][%d,]*%.?%d*)")
if num then
local n = tonumber((num:gsub(",", "")))
if n and n > 0 then return n end
end
end
return nil
end
local function describe(tool)
if not tool then return "?" end
local base, src = baseCPSOf(tool)
if not base then return "(不在内置表且无 CPS 属性 ⇒ 不卖)" end
local mut = tostring(tool:GetAttribute("Mutation") or "")
return string.format("基础%.0f(%s)·等级%d·词缀%s×%.2f·乘数%.2f^%d", base, src, toolLevel(tool),
(mut == "" and "无" or mut), (MutBuff[mut] or 1), lvMul(), toolLevel(tool) - 1)
end
local function fmtNum(v)
v = tonumber(v) or 0
if v >= 1e12 then return string.format("%.2fT", v / 1e12) end
if v >= 1e9 then return string.format("%.2fB", v / 1e9) end
if v >= 1e6 then return string.format("%.2fM", v / 1e6) end
if v >= 1e3 then return string.format("%.1fK", v / 1e3) end
return tostring(math.floor(v))
end
F.FmtNum = fmtNum
F.SlotOfTool = function(t)
local ok, sl = pcall(function() return t:GetAttribute("slot") or t:GetAttribute("Slot") or t:GetAttribute("Index") end)
if ok and sl ~= nil then return tonumber(sl) end
local n = tonumber(tostring(t.Name):match("(%d+)"))
return n
end
F.SellScanStats = function()
local raw = nil
pcall(function()
local o = Fluent and Fluent.Options and Fluent.Options.SellMinCPS
if o and o.Value ~= nil and tostring(o.Value) ~= "" then raw = o.Value end
end)
if raw == nil then raw = C.SellMinCPSTxt end
local n = F.ParseCPS(raw)
if not n then return nil, "门槛没看懂(例: 80m / 500k / 1.5b / 2q)" end
C.SellMinCPS = n
local seen, hits, total, ex, where = {}, 0, 0, 0, {}
local function add(c, tag)
if c and not seen[c] then seen[c] = true
local cnt = 0
pcall(function()
for _, t in ipairs(c:GetChildren()) do
if t:IsA("Tool") and isEntityTool(t) then
if isExclusiveTool(t) then ex = ex + 1
else
local cps = cpsOf(t)
if cps then total = total + 1 cnt = cnt + 1 if cps <= n then hits = hits + 1 end end
end
end
end
end)
where[#where + 1] = tag .. "=" .. tostring(cnt)
end
end
add(LP:FindFirstChildOfClass("Backpack"), "背包")
add(LP.Character, "身上")
pcall(function() add(LP.Character and LP.Character:FindFirstChildOfClass("Backpack"), "背包2") end)
return { n = n, hits = hits, total = total, ex = ex, where = table.concat(where, " ") }, nil
end
function F.ParseCPS(s)
if type(s) == "number" then return s end
if type(s) ~= "string" then return nil end
local t = string.lower(s):gsub("%s", "")
if t == "" then return nil end
local num, suf = t:match("^(%d+%.?%d*)([kmbtq]?)$")
local n = tonumber(num)
if not n then return nil end
local m = 1
if suf == "k" then m = 1e3
elseif suf == "m" then m = 1e6
elseif suf == "b" then m = 1e9
elseif suf == "t" then m = 1e12
elseif suf == "q" then m = 1e15 end
return n * m
end
local function threshold()
if F._sellThOverride then return math.huge end
return tonumber(C.SellMinCPS) or 100000
end
local function collectLists()
local picks, all = {}, {}
local function scan(list)
if not list then return end
for _, t in ipairs(list:GetChildren()) do
if t:IsA("Tool") and isEntityTool(t) then
local c = cpsOf(t)
local ex = isExclusiveTool(t)
all[#all + 1] = { Tool = t, Name = t.Name, CPS = c or 0, Ex = ex, Known = c ~= nil }
if c and not ex then picks[#picks + 1] = { Tool = t, Name = t.Name, CPS = c } end
end
end
end
scan(LP.Character)
scan(LP:FindFirstChild("Backpack"))
table.sort(all, function(a, b) return a.CPS < b.CPS end)
table.sort(picks, function(a, b) return a.CPS < b.CPS end)
return picks, all
end
local function findSeller()
local npcs = workspace:FindFirstChild("NPCs")
if not npcs then return nil end
for _, o in ipairs(npcs:GetChildren()) do
if o:IsA("Model") and (o.Name == SELLER_NAME or o:GetAttribute("Name") == SELLER_NAME) then return o end
end
for _, o in ipairs(npcs:GetDescendants()) do
if o:IsA("Model") and (o.Name == SELLER_NAME or o:GetAttribute("Name") == SELLER_NAME) then return o end
end
return nil
end
local function moveToSeller()
local _, _, root = GC()
if not root then return false end
local seller = findSeller()
local part = seller and (seller:FindFirstChild("HumanoidRootPart") or seller.PrimaryPart
or seller:FindFirstChildWhichIsA("BasePart", true))
if part then
local target = part.Position
local away = Vector3.new(root.Position.X - target.X, 0, root.Position.Z - target.Z)
if away.Magnitude < 0.1 then away = Vector3.new(1, 0, 0) end
local stand = Vector3.new(target.X, root.Position.Y, target.Z) + away.Unit * 4
pcall(function()
root.CFrame = CFrame.new(stand, Vector3.new(target.X, stand.Y, target.Z))
root.AssemblyLinearVelocity = Vector3.zero
end)
else
local rel = root.CFrame - root.CFrame.Position
pcall(function()
root.CFrame = SELLER_CF * rel
root.AssemblyLinearVelocity = Vector3.zero
end)
end
task.wait(0.2)
return true
end
local function sellHeld()
local rf = RFunction("B_Sell")
if rf then
local ok, res = pcall(function() return rf:InvokeServer() end)
if ok then
if not F._sellOkLogged then
F._sellOkLogged = true
F.Out("[售卖] 已命中接口 " .. tostring(rf:GetFullName()) .. " · InvokeServer 调用成功")
end
return true
end
F.Out("[售卖] 找到接口 " .. tostring(rf:GetFullName()) .. " 但调用报错 ⇒ 可能被服务端拒绝")
end
local re = REvent("B_Sell")
if re then
if pcall(function() re:FireServer() end) then return true end
end
if not F._sellMissLogged then
F._sellMissLogged = true
F.Out("[售卖] ⚠ 找不到 B_Sell 接口 —— 应在 ReplicatedStorage.Shared.Packages.Network 下(rev_/ref_ 前缀)")
F.Out("[售卖] 实测可用的取出办法: RStorage.Shared.Packages.Network.ref_B_Sell (RemoteFunction)")
end
return false
end
function F.PreviewSell()
task.spawn(function()
local th = threshold()
local _, all = collectLists()
local nSell, nKeep, nUnknown = 0, 0, 0
for _, e in ipairs(all) do
if not e.Known then nUnknown = nUnknown + 1
elseif e.Ex then nKeep = nKeep + 1
elseif e.CPS < th then nSell = nSell + 1 end
end
F.Out(string.format("[统计] 门槛 %s ⇒ 符合门槛、可卖 %d 个(实体脑红共 %d 个; 限定保留 %d, 算不出 %d)",
fmtNum(th), nSell, #all, nKeep, nUnknown))
end)
end
function F.SellLowCPS(force)
if SellThread then F.Out("[售卖] 已在进行中") return end
SellThread = task.spawn(function()
local ok, err = pcall(function()
local ch, hum, root = GC()
if not (hum and root) then F.Out("[售卖] 无角色") return end
local returnCF = root.CFrame
local th = threshold()
local thTxt = F._sellThOverride and "全部(除限定)" or fmtNum(th)
F.Out(string.format("[售卖] 开始 · 门槛 %s · 先走到%s身边", thTxt, SELLER_NAME))
moveToSeller()
task.wait(0.3)
local total, rounds, noProgress = 0, 0, 0
while rounds < 60 do
if not (force or T.AutoSell) then break end
rounds = rounds + 1
local picks = collectLists()
if #picks == 0 then
if rounds == 1 then F.Out(string.format("[售卖] 没有低于 %s 的脑红", thTxt)) end
break
end
F.Out(string.format("[售卖] 第 %d 轮 · 待卖 %d 个", rounds, #picks))
local sold = 0
for i = 1, #picks do
if not (force or T.AutoSell) then break end
local e = picks[i]
local tool = e.Tool
if tool and tool.Parent then
pcall(function() hum:UnequipTools() end)
task.wait(0.08)
pcall(function() hum:EquipTool(tool) end)
task.wait(0.2)
if tool.Parent == ch then
F.Out(string.format("[售卖]   %s CPS≈%s · %s", tool.Name, fmtNum(e.CPS), describe(tool)))
local okf = sellHeld()
task.wait(0.3)
if okf and not tool.Parent then
sold = sold + 1
total = total + 1
end
end
task.wait(0.05)
end
end
if sold == 0 then
noProgress = noProgress + 1
F.Out(string.format("[售卖] 第 %d 轮无进展 (%d/2)", rounds, noProgress))
if noProgress >= 2 then break end
task.wait(0.5)
else
noProgress = 0
end
local seller = findSeller()
local _, _, r = GC()
local part = seller and (seller:FindFirstChild("HumanoidRootPart") or seller.PrimaryPart)
if r and part and (r.Position - part.Position).Magnitude > 20 then
moveToSeller()
task.wait(0.25)
end
end
pcall(function() hum:UnequipTools() end)
F.Out(string.format("[售卖] 完成 · 共卖 %d 个 · 走了 %d 轮", total, rounds))
if total > 0 and T.AutoSell then
F._sellFinish = true
T.AutoSell = false
local op = Fluent and Fluent.Options and Fluent.Options.AutoSell
if op and op.Value then pcall(function() op:Set(false) end) end
F._sellFinish = nil
F.Out("[售卖] 本轮已卖完 ⇒ 自动关闭「按 CPS 卖出」(要再卖请重新打开)")
end
local _, _, r2 = GC()
if r2 then
pcall(function()
r2.CFrame = returnCF
r2.AssemblyLinearVelocity = Vector3.zero
end)
end
end)
SellThread = nil
F._sellThOverride = nil
if not ok then F.Out("[售卖] 出错: " .. tostring(err)) end
end)
end
function F.WithdrawAll(maxSlot)
maxSlot = tonumber(maxSlot) or 30
task.spawn(function()
local node = game:GetService("ReplicatedStorage")
for _, seg in ipairs({ "Shared", "Packages", "Network", "rev_S_Interact" }) do
local ok, child = pcall(function() return node:WaitForChild(seg, 5) end)
if not (ok and child) then
F.Out("[收起脑红] 路径断了: ReplicatedStorage.Shared.Packages.Network.rev_S_Interact (" .. tostring(seg) .. " 找不到)")
return
end
node = child
end
local n = 0
for i = 1, maxSlot do
if pcall(function() node:FireServer(i) end) then n = n + 1 end
task.wait(0.08)
end
F.Out("[收起脑红] 已逐个槽位 1~" .. tostring(maxSlot) .. " 发送 rev_S_Interact(共 " .. tostring(n) .. " 次)")
pcall(function() Fluent:Notify({ Title = "收起脑红", Content = "已按 1~" .. tostring(maxSlot) .. " 逐个槽位发送(" .. tostring(n) .. " 次)", Duration = 10 }) end)
end)
end
F.TpToMyPlot = function()
local _, _, root = GC()
if not root then F.Out("[收钱] 无角色, 无法过去") return false end
local target, where = nil, nil
pcall(function()
local me = tostring(LP.Name)
local dn = tostring(LP.DisplayName or "")
for _, d in ipairs(workspace:GetDescendants()) do
if (d:IsA("Model") or d:IsA("BasePart")) and d ~= LP.Character then
local s = tostring(d.Name)
if s == me or (dn ~= "" and s == dn) or s:find(me, 1, true) then
local pt = d:IsA("Model") and (d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart", true)) or d
if pt then target = pt.Position where = s break end
end
end
end
end)
if not target then
pcall(function()
for _, d in ipairs(workspace:GetDescendants()) do
if d:IsA("BasePart") and d.Name == "PlotOwner" then
target = d.Position where = "PlotOwner" break
end
end
end)
end
if not target then
F.Out("[收钱] ⚠ 找不到你的地盘(名字里没有你的名字, 也没发现 PlotOwner 部件) ⇒ 请手动走过去再点")
return false
end
pcall(function()
root.CFrame = CFrame.new(target + Vector3.new(0, 4, 0))
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
F.Out("[收钱] 已传送到你的地盘附近(" .. tostring(where) .. ")")
return true
end
function F.CollectAll(maxSlot)
maxSlot = tonumber(maxSlot) or 30
task.spawn(function()
local node = game:GetService("ReplicatedStorage")
for _, seg in ipairs({ "Shared", "Packages", "Network", "rev_B_Collect" }) do
local ok, child = pcall(function() return node:WaitForChild(seg, 5) end)
if not (ok and child) then
F.Out("[收集货币] 路径断了: ReplicatedStorage.Shared.Packages.Network.rev_B_Collect (" .. tostring(seg) .. " 找不到)")
return
end
node = child
end
local n = 0
for i = 1, maxSlot do
if pcall(function() node:FireServer(i) end) then n = n + 1 end
task.wait(0.08)
end
F.Out("[收集货币] 已逐个槽位 1~" .. tostring(maxSlot) .. " 发送 rev_B_Collect(共 " .. tostring(n) .. " 次)")
pcall(function() Fluent:Notify({ Title = "收集货币", Content = "已按 1~" .. tostring(maxSlot) .. " 逐个槽位发送(" .. tostring(n) .. " 次)", Duration = 10 }) end)
end)
end
local SUFFIX = { k = 1e3, m = 1e6, b = 1e9, t = 1e12, q = 1e15, qa = 1e15, qi = 1e18, sx = 1e21, sp = 1e24, no = 1e30, dc = 1e33 }
function F.ParseNum(v)
if typeof(v) == "number" then return v end
if type(v) ~= "string" then return nil end
local t = v:gsub(",", ""):gsub("%$", ""):gsub("%s", "")
if t == "" then return nil end
local sci = t:match("[-+]?[%d%.]+[eE][-+]?%d+")
if sci then return tonumber(sci) end
local n, suf = t:match("([-+]?[%d%.]+)([%a]*)")
local base = tonumber(n)
if not base then return nil end
if suf and suf ~= "" then
local m = SUFFIX[string.lower(suf)]
if m then return base * m end
end
return base
end
function F.HudNum(...)
local cur = LP:FindFirstChild("PlayerGui")
for i = 1, select("#", ...) do
if not cur then return nil, "路径断了" end
cur = cur:FindFirstChild(select(i, ...))
end
if not cur then return nil, "没这个元素" end
local s = nil
pcall(function()
if cur:IsA("TextLabel") or cur:IsA("TextButton") then s = cur.Text end
end)
if s == nil then return nil, "不是文本控件" end
local num = F.ParseNum(s)
if not num then return nil, "内容=" .. tostring(s) .. " 认不出数字" end
return num, tostring(s)
end
function F.ScanHUD()
task.spawn(function()
local pg = LP:FindFirstChild("PlayerGui")
if not pg then F.Out("[HUD扫描] 没有 PlayerGui") return end
F.Out("──────── HUD 数字控件扫描(只读) ────────")
local found = {}
local function scan(root, path)
for _, ch in ipairs(root:GetChildren()) do
local p = path .. "." .. ch.Name
if ch:IsA("TextLabel") or ch:IsA("TextButton") then
local txt = ch.Text or ""
local num = F.ParseNum(txt)
if num then found[#found + 1] = { path = p, text = txt } end
end
if #p < 80 and #found < 200 then scan(ch, p) end
end
end
local roots = { { pg:FindFirstChild("HUD"), "HUD" }, { pg:FindFirstChild("Frames"), "Frames" } }
for i = 1, #roots do
if roots[i][1] then scan(roots[i][1], roots[i][2]) end
end
if #found == 0 then
F.Out("  没扫到数字控件 —— 确认已在正确场景(基地内)")
else
for i = 1, math.min(#found, 60) do
F.Out(string.format("  %-58s = %s", found[i].path, found[i].text))
end
F.Out(string.format("  共 %d 个数字控件", #found))
end
F.Out("────────────────────────────────────")
pcall(F.LogFlush, "HUD扫描")
if Fluent and Fluent.Notify then
Fluent:Notify({ Title = "HUD 扫描", Content = "找到 " .. #found .. " 个数字控件, 明细见控制台 F9", Duration = 10 })
end
end)
end
function F.ReadBase()
task.spawn(function()
F.Out("──────── 基地数据(只读) ────────")
local rows = {
{ "金币", { "HUD", "BottomLeft", "CoinsFrame", "InsideFrame", "CoinLabel" } },
{ "踢力", { "HUD", "BottomLeft", "KickLevel", "TextLabel" } },
{ "精通", { "HUD", "BottomLeft", "KickMastery", "InsideFrame", "CoinLabel" } },
{ "重生等级", { "Frames", "Rebirth", "RebirthLevel" } },
}
for i = 1, #rows do
local v, note = F.HudNum(table.unpack(rows[i][2]))
F.Out(string.format("  %-8s %s", rows[i][1],
v and (fmtNum(v) .. "   (" .. tostring(note) .. ")") or ("读不到 —— " .. tostring(note))))
end
local sp, note = F.HudNum("Frames", "SpeedUpgrades", "ScrollingFrame", "+1 Speed", "NameLabel")
if sp then
F.Out(string.format("  %-8s %d   (原始 %s)", "速度等级", math.max(0, math.floor(sp - 13 + 0.5)), tostring(note)))
else
F.Out("  " .. string.format("%-8s", "速度等级") .. "读不到 —— " .. tostring(note) .. "(需先打开速度升级面板)")
end
local step = LP:GetAttribute("TutorialStep")
F.Out("  " .. string.format("%-8s", "教程步") .. (step == nil and "(无此属性)" or tostring(step)))
local _, all = collectLists()
F.Out("  " .. string.format("%-8s", "实体工具") .. #all .. " 个(手持+背包)")
F.Out("───────────────────────────────")
if Fluent and Fluent.Notify then
Fluent:Notify({ Title = "基地数据", Content = "已读取, 明细见控制台 F9(只读, 没改动任何东西)", Duration = 10 })
end
pcall(F.LogFlush, "基地数据")
end)
end
function F.UpgradeAdvice()
task.spawn(function()
local out = {}
local function consider(tool, where)
local base = baseCPSOf(tool)
if not base then return end
local lv = toolLevel(tool)
if lv >= 75 then return end
local mut = tostring(tool:GetAttribute("Mutation") or "")
local mm = MutBuff[mut]
local unknown = false
if not mm and mut ~= "" then
unknown = true
mm = 1
elseif not mm then
mm = 1
end
local cps = base * mm * (lvMul() ^ (lv - 1))
local cost = math.floor(base * mm * (1.5 ^ (lv - 1)))
if cost <= 0 then return end
local gain = cps * 0.25
out[#out + 1] = { Name = tool.Name, Where = where, Lv = lv, CPS = cps, Cost = cost,
Gain = gain, ROI = gain / cost, Unknown = unknown }
end
local ch = LP.Character
local bp = LP:FindFirstChild("Backpack")
if ch then
for _, t in ipairs(ch:GetChildren()) do
if t:IsA("Tool") and isEntityTool(t) then consider(t, "手持") end
end
end
if bp then
for _, t in ipairs(bp:GetChildren()) do
if t:IsA("Tool") and isEntityTool(t) then consider(t, "背包") end
end
end
table.sort(out, function(a, b)
if a.Unknown ~= b.Unknown then return not a.Unknown end
return a.ROI > b.ROI
end)
F.Out(string.format("──────── 升级性价比(可升级 %d 个) ────────", #out))
for i = 1, math.min(#out, 10) do
local e = out[i]
local mark = e.Unknown and " ⚠词缀未知" or ""
F.Out(string.format("  %d) %s [%s] Lv%d · CPS≈%s · 一级花 %s 换 +%s · 性价比 %.5f%s",
i, e.Name, e.Where, e.Lv, fmtNum(e.CPS), fmtNum(e.Cost), fmtNum(e.Gain), e.ROI, mark))
end
local best = out[1]
if best then
local secs = (best.Gain > 0) and (best.Cost / best.Gain) or 0
F.Out(string.format("  结论: 优先升「%s」—— 花 %s, 每秒多 %s, 约 %.0f 秒回本",
best.Name, fmtNum(best.Cost), fmtNum(best.Gain), secs))
else
F.Out("  没有可升级对象(不在已知表里 或 都满级 75)")
end
F.Out("────────────────────────────────────")
if Fluent and Fluent.Notify then
Fluent:Notify({ Title = "升级性价比", Content = best and ("建议优先升「" .. best.Name .. "」(性价比 " .. string.format("%.5f", best.ROI) .. ")") or "没有可升级对象", Duration = 12 })
end
pcall(F.LogFlush, "升级性价比")
end)
end
function F.SellAll()
if SellThread then F.Out("[卖光] 正在售卖中, 稍后再试") return end
F._sellThOverride = true
F.Out("[卖光] 会把背包里能算出 CPS 的、非限定脑红全部卖掉")
task.delay(300, function()
if F._sellThOverride then
F._sellThOverride = nil
F.Out("[卖光] 兜底超时: 已清掉临时门槛覆盖")
end
end)
F.SellLowCPS(true)
end
end
local Trans = {}
Trans.HOST = "http://127.0.0.1:8080"
Trans.KEY = "rk_4a56fc43faa5edb9f7a0cafd4ad3e91f"
Trans.MODEL = "hymt2-7b"
Trans.FILE = "CheatMenu_TransCache.json"
Trans.Cache = {}
Trans.Queue = {}
Trans.Active = 0
Trans.Max = 8
Trans.Loop = nil
Trans._lastAt = 0
Trans.SYS_PROMPT = [[Translate the following game UI text into Chinese.
Output ONLY the translation: no explanation, no quotes, no extra words.
Preserve the original line breaks and number of lines.
Keep numbers, emoji, URLs and player names unchanged.
Translate game terms CONSISTENTLY:
Brainrot->脑红, Timmy->蒂米, Slot->槽位, Plot->基地, Mutation->词缀, Level->等级,
Collect->收取, Withdraw->收起, Sell->售卖, Claim->领取, Gym->健身房, Lift Machine->举铁机,
Squat->举铁, Train->训练, Bonus->加成,
Coins->金币, Gold->金币, Cash->金币, Gems->宝石, XP->经验, HP->生命, MP->法力,
Loot->战利品, Kill->击杀, Death->死亡, Respawn->复活, Round->回合, Match->对局,
Objective->目标, Score->得分, Streak->连杀, Loadout->配装, Inventory->背包, Shop->商店,
Trade->交易, Quest->任务, Reward->奖励, Rank->段位, Damage->伤害, Shield->护盾,
Ammo->弹药, Reload->换弹, Headshot->爆头, Victory->胜利, Defeat->失败.
Keep CPS as "CPS".
Currency symbols ($, €, ¥) must ALWAYS be kept EXACTLY as-is.
The word Robux is kept as-is too.
If the text is already Chinese or contains CJK, output it unchanged.]]
Trans.QUICK = {
["play"] = "开始", ["settings"] = "设置", ["shop"] = "商店", ["buy"] = "购买", ["sell"] = "售卖",
["sell all"] = "全部售卖", ["claim"] = "领取", ["collect"] = "收取", ["level"] = "等级",
["reward"] = "奖励", ["rewards"] = "奖励", ["free"] = "免费", ["coins"] = "金币", ["cash"] = "金币",
["gold"] = "金币", ["gems"] = "宝石", ["yes"] = "是", ["no"] = "否", ["ok"] = "确定", ["confirm"] = "确认",
["cancel"] = "取消", ["close"] = "关闭", ["back"] = "返回", ["next"] = "下一步", ["continue"] = "继续",
["start"] = "开始", ["upgrade"] = "升级", ["rebirth"] = "重生", ["spin"] = "转盘", ["skip"] = "跳过",
["inventory"] = "背包", ["trade"] = "交易", ["quest"] = "任务", ["rank"] = "段位", ["damage"] = "伤害",
["health"] = "生命", ["open"] = "开启", ["max"] = "最大", ["unlock"] = "解锁", ["locked"] = "已锁定",
["owned"] = "已拥有", ["equipped"] = "已装备", ["win"] = "胜利", ["lose"] = "失败", ["ready"] = "准备",
["equip"] = "装备", ["use"] = "使用", ["slots"] = "槽位", ["plot"] = "基地", ["gems shop"] = "宝石商店",
["op"] = "强力", ["afk"] = "挂机", ["dps"] = "输出", ["pvp"] = "对战", ["pve"] = "刷怪",
}
Trans.LANGS = {
zh = "Chinese", en = "English", ja = "Japanese", ko = "Korean",
th = "Thai", ru = "Russian", ar = "Arabic", id = "Indonesian",
}
function Trans.Prompt(code)
if not code or code == "zh" then return Trans.SYS_PROMPT end
local lang = Trans.LANGS[code] or "Chinese"
return "Translate the following game UI text into " .. lang
.. ". Output ONLY the translation: no explanation, no quotes, no extra words."
.. " Keep numbers, emoji, URLs and player names unchanged."
end
Trans.LoadOne = function(file)
if type(readfile) ~= "function" or type(isfile) ~= "function" then return nil end
local ex = false
pcall(function() ex = isfile(file) end)
if not ex then return nil end
local raw, d = nil, nil
pcall(function() raw = readfile(file) end)
if type(raw) ~= "string" or raw == "" then return nil end
pcall(function() d = HS:JSONDecode(raw) end)
if type(d) ~= "table" then return nil end
return d
end
function Trans.Load()
Trans.Order = Trans.Order or {}
local d, fromBak = Trans.LoadOne(Trans.FILE), false
if d == nil then
d = Trans.LoadOne(Trans.BAK)
fromBak = d ~= nil
if fromBak then
F.Out("[翻译] ⚠ 缓存主文件损坏/读不出 ⇒ 已从备份 .bak 恢复(可能少了最近几条)")
else
local ex = false
pcall(function() ex = (type(isfile)=="function") and isfile(Trans.FILE) end)
if ex then F.Out("[翻译] ⚠ 缓存文件损坏且没有可用备份 ⇒ 本次从空缓存开始") end
return
end
end
local n = 0
local cache, order = nil, nil
if type(d.c) == "table" then cache, order = d.c, d.o else cache = d end
for k, v in pairs(cache) do
if type(k) == "string" and type(v) == "string" then Trans.Cache[k] = v n = n + 1 end
end
Trans._ordSeen = {}
if type(order) == "table" then
for i = 1, #order do
local k = order[i]
if type(k) == "string" and Trans.Cache[k] and not Trans._ordSeen[k] then
Trans._ordSeen[k] = true
Trans.Order[#Trans.Order + 1] = k
end
end
end
for k in pairs(Trans.Cache) do
if not Trans._ordSeen[k] then Trans._ordSeen[k] = true Trans.Order[#Trans.Order + 1] = k end
end
Trans._cnt = n
Trans._dirty = false
F.Out("[翻译] 已加载本地缓存 " .. n .. " 条" .. (fromBak and " (来自备份)" or ""))
end
Trans.BAK = "CheatMenu_TransCache.json.bak"
Trans.TMP = "CheatMenu_TransCache.json.tmp"
Trans.SaveAtomic = function(payload)
if type(writefile) ~= "function" then return false end
local had = false
if type(isfile) == "function" and type(readfile) == "function" then
pcall(function() had = isfile(Trans.FILE) end)
end
if type(renamefile) == "function" then
if had then pcall(function() writefile(Trans.BAK, readfile(Trans.FILE)) end) end
local ok = pcall(function() writefile(Trans.TMP, payload) end)
if not ok then return false end
local ok2 = pcall(function() renamefile(Trans.TMP, Trans.FILE) end)
if ok2 then return true end
pcall(function() writefile(Trans.FILE, payload) end)
return true
end
if had then pcall(function() writefile(Trans.BAK, readfile(Trans.FILE)) end) end
pcall(function() writefile(Trans.FILE, payload) end)
return true
end
function Trans.Flush()
Trans._dirtyOld = nil
Trans._savedAt = os.clock()
local body = nil
pcall(function()
body = HS:JSONEncode({ v = 2, c = Trans.Cache, o = Trans.Order or {} })
end)
if not body then Trans._dirty = true return false end
local ok, r = pcall(Trans.SaveAtomic, body)
local done = ok and (r ~= false)
Trans._dirty = not done
return done
end
function Trans.Save()
Trans._dirty = true
local now = os.clock()
local last = Trans._savedAt or 0
if now - last < 5 then
Trans._dirtyOld = Trans._dirtyOld or now
if now - Trans._dirtyOld < 25 then return end
end
Trans.Flush()
end
Trans.HeartbeatOn = function()
if Trans._hbOn then return end
Trans._hbOn = true
task.spawn(function()
while Trans._hbOn do
task.wait(10)
if not Trans._hbOn then break end
if Trans._dirty and Trans._dirtyOld and (os.clock() - Trans._dirtyOld) >= 8 then
pcall(Trans.Flush)
end
end
end)
end
Trans.HeartbeatOff = function() Trans._hbOn = false end
function Trans.Req()
return (type(syn) == "table" and syn.request) or AC.cap("request")
or (type(http) == "table" and http.request) or AC.cap("http_request")
end
function Trans.Request(text)
local rf = Trans.Req()
if type(rf) ~= "function" then
F.Out("[翻译] ❌ 执行器没有 request 函数, 本地服务用不了(只能用 HttpService, 而它到不了 localhost)")
return nil
end
local body = HS:JSONEncode({
model = Trans.MODEL,
messages = {
{ role = "system", content = Trans.Prompt(C.TransLang) },
{ role = "user", content = text },
},
temperature = 0.1, top_p = 0.6, max_tokens = 128, stream = false,
})
local ok, res = pcall(function()
return rf({
Url = Trans.HOST .. "/v1/chat/completions",
Method = "POST",
Headers = { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. Trans.KEY },
Body = body,
})
end)
if not ok or type(res) ~= "table" or (res.StatusCode or 0) ~= 200 then
return nil, "HTTP " .. tostring(res and res.StatusCode or "fail")
end
local ok2, d = pcall(HS.JSONDecode, res.Body)
if not ok2 or type(d) ~= "table" or not d.choices or not d.choices[1] then return nil, "bad json" end
local msg = d.choices[1].message
return msg and msg.content, nil
end
Trans.RT = { O1 = "\226\159\166", C1 = "\226\159\167" }
Trans.RT.HasTags = function(s)
return type(s) == "string" and s:find("<%a[^<>]*>") ~= nil or (type(s) == "string" and s:find("</%a") ~= nil)
end
Trans.RT.Strip = function(s)
if type(s) ~= "string" then return s end
return (s:gsub("<[^<>]->", ""))
end
Trans.RT.Tokenize = function(s)
local tags = {}
local core = s:gsub("<[^<>]->", function(t)
tags[#tags + 1] = t
return Trans.RT.O1 .. #tags .. Trans.RT.C1
end)
return core, tags
end
Trans.RT.Restore = function(s, tags)
if type(s) ~= "string" or not tags or #tags == 0 then return s end
local o, c = Trans.RT.O1, Trans.RT.C1
local function put(i)
local t = tags[tonumber(i)]
return t or ""
end
s = s:gsub(o .. "%s*(%d+)%s*" .. c, put)
s = s:gsub("[%[%(]%s*(%d+)%s*[%]%)]", put)
return s
end
Trans.RT.CleanResidue = function(s)
if type(s) ~= "string" then return s end
local o, c = Trans.RT.O1, Trans.RT.C1
local go, gc = Trans.GL.O1, Trans.GL.C1
s = s:gsub(o .. "%s*%d+%s*" .. c, "")
s = s:gsub(go .. "%s*%d+%s*" .. gc, "")
s = s:gsub(o, ""):gsub(c, "")
s = s:gsub(go, ""):gsub(gc, "")
s = (s:gsub("[%[%(]%s*%d+%s*[%]%)]", ""))
return s
end
Trans.RT.RestoreChecked = function(translated, tags)
if type(translated) ~= "string" then return nil end
if not tags or #tags == 0 then return translated end
local out = Trans.RT.Restore(translated, tags)
local miss = 0
for i = 1, #tags do
if not out:find(tags[i], 1, true) then miss = miss + 1 end
end
if miss > 0 then
F.Out("[翻译·富文本] 标签校验不过(缺 " .. tostring(miss) .. "/" .. tostring(#tags)
.. " 个) ⇒ 放弃本次译文, 界面保留原文(绝不写坏富文本)")
return nil
end
return Trans.RT.CleanResidue(out)
end
Trans.RT.Count = function(s)
local n = 0
if type(s) == "string" then for _ in s:gmatch("<[^<>]->") do n = n + 1 end end
return n
end
Trans.RT.Audit = function()
local broken, tagged, richOff = 0, 0, 0
pcall(function()
for _, g in ipairs(game:GetService("CoreGui"):GetDescendants()) do
if (g:IsA("TextLabel") or g:IsA("TextButton")) and type(g.Text) == "string" then
if Trans.RT.HasTags(g.Text) then
tagged = tagged + 1
if g.RichText ~= true then richOff = richOff + 1 end
local o, c = Trans.RT.Count(g.Text:gsub("<[^<>]->", "")), 0
if c > o then broken = broken + 1 end
end
end
end
end)
F.Out("[翻译·富文本] 带标签的文本控件 " .. tostring(tagged) .. " 个, 其中 RichText 没开 " .. tostring(richOff)
.. " 个(这些标签会当纯文本显示), 标签不配对 " .. tostring(broken) .. " 个")
return tagged
end
Trans.GL = {}
Trans.GL.PRESET = {
["brainrot"] = "脑红", ["rebirth"] = "重生", ["pet"] = "宠物", ["pets"] = "宠物",
["egg"] = "蛋", ["eggs"] = "蛋", ["cash"] = "现金", ["coins"] = "金币", ["coin"] = "金币",
["gems"] = "宝石", ["gem"] = "宝石", ["plot"] = "基地", ["podium"] = "展台",
["steal"] = "偷取", ["team"] = "队伍", ["round"] = "回合", ["shop"] = "商店",
["inventory"] = "背包", ["upgrade"] = "升级", ["quest"] = "任务", ["reward"] = "奖励",
["damage"] = "伤害", ["health"] = "生命值", ["server"] = "服务器",
["leaderboard"] = "排行榜", ["trading"] = "交易", ["trade"] = "交易",
["purchase"] = "购买", ["equip"] = "装备", ["unlock"] = "解锁", ["locked"] = "已锁定",
["owned"] = "已拥有", ["equipped"] = "已装备", ["sell"] = "出售", ["buy"] = "购买",
}
Trans.GL.KEEP = {}
Trans.GL.O1 = "\226\159\170"
Trans.GL.C1 = "\226\159\171"
Trans.GL.Ena = function()
if C.TransUseGL == false then return false end
return true
end
Trans.GL.CIPat = function(term)
local parts = {}
for i = 1, #term do
local ch = term:sub(i, i)
if ch:match("%a") then
parts[#parts + 1] = "[" .. ch:lower() .. ch:upper() .. "]"
else
parts[#parts + 1] = ch:gsub("(%W)", "%%%1")
end
end
return table.concat(parts)
end
Trans.GL.Sorted = function()
local out = {}
for k in pairs(Trans.GL.PRESET) do out[#out + 1] = k end
for k in pairs(Trans.GL.KEEP) do out[#out + 1] = k end
table.sort(out, function(a, b) return #a > #b end)
return out
end
Trans.GL.Apply = function(text)
if not Trans.GL.Ena() then return text, nil end
local hits = {}
local out = text
local terms = Trans.GL.Sorted()
for i = 1, #terms do
local t = terms[i]
if t ~= "" and out:lower():find(t, 1, true) then
local want = Trans.GL.KEEP[t] or Trans.GL.PRESET[t]
if want then
local pat = "()(%f[%a]" .. Trans.GL.CIPat(t) .. "%f[%A])"
out = out:gsub(pat, function()
hits[#hits + 1] = want
return Trans.GL.O1 .. #hits .. Trans.GL.C1
end)
end
end
end
if #hits == 0 then return out, nil end
return out, hits
end
Trans.GL.Restore = function(s, hits)
if type(s) ~= "string" or not hits or #hits == 0 then return s end
local o, c = Trans.GL.O1, Trans.GL.C1
local function put(i)
local w = hits[tonumber(i)]
return w or ""
end
s = s:gsub(o .. "%s*(%d+)%s*" .. c, put)
s = s:gsub("[%[%(]%s*(%d+)%s*[%]%)]", put)
return s
end
Trans.GL.Add = function(term, want)
term = tostring(term or ""):gsub("^%s+", ""):gsub("%s+$", "")
if term == "" then return false end
local k = term:lower()
if want == nil or want == "" then
Trans.GL.KEEP[k] = term
else
Trans.GL.KEEP[k] = nil
Trans.GL.PRESET[k] = want
end
Trans.QUICK[k] = nil
Trans.Cache = {}
if Trans.ShouldCacheClear then Trans.ShouldCacheClear() end
task.spawn(function() pcall(Trans.RetranslateAll) end)
F.Out("[翻译·词条] 已加: " .. term .. " -> " .. tostring(Trans.GL.KEEP[k] or Trans.GL.PRESET[k]))
return true
end
Trans.GL.Del = function(term)
local k = tostring(term or ""):lower()
local hadP, hadK = Trans.GL.PRESET[k] ~= nil, Trans.GL.KEEP[k] ~= nil
Trans.GL.PRESET[k], Trans.GL.KEEP[k] = nil, nil
Trans.Cache = {}
if Trans.ShouldCacheClear then Trans.ShouldCacheClear() end
task.spawn(function() pcall(Trans.RetranslateAll) end)
F.Out("[翻译·词条] 已删: " .. tostring(term) .. (hadP or hadK and "" or " (本来就没有)"))
return hadP or hadK
end
Trans.GL.Count = function()
local n = 0
for _ in pairs(Trans.GL.PRESET) do n = n + 1 end
for _ in pairs(Trans.GL.KEEP) do n = n + 1 end
return n
end
Trans.GL.AddAuto = function()
local n = 0
local name = nil
pcall(function()
if F.CMX_GameName then name = (F.CMX_GameName()) end
end)
if type(name) == "string" and #name >= 3 then
if Trans.GL.Add(name, nil) then n = n + 1 end
end
local per = nil
pcall(function()
if F.CMX_GameDetectKeys then per = (F.CMX_GameDetectKeys()) end
end)
if type(per) == "table" then
for i = 1, #per do
local w = per[i]
if type(w) == "string" and #w >= 5 and not w:find(" ") then
if Trans.GL.Add(w, nil) then n = n + 1 end
end
end
end
F.Out("[翻译·词条] 自动加入 " .. tostring(n) .. " 条(游戏名 + 本游戏检测命名) —— 这些词保持原文不翻译"
.. " · 当前词条共 " .. tostring(Trans.GL.Count()) .. " 条")
return n
end
Trans.KNOWN = function(w)
if type(w) ~= "string" or w == "" then return false end
local k = w:lower()
if Trans.QUICK and Trans.QUICK[k] ~= nil then return true end
if Trans.GL then
if Trans.GL.PRESET and Trans.GL.PRESET[k] ~= nil then return true end
if Trans.GL.KEEP and Trans.GL.KEEP[k] ~= nil then return true end
end
return false
end
Trans.ShouldV2 = function(s)
local n = #s
if n < 2 or n > 300 then return false, "长度" end
if not s:find("[A-Za-z]") then return false, "无字母" end
if (C.TransLang or "zh") == "zh" and s:find("[\228-\233]") then return false, "已是中文" end
if s:match("^https?://") or s:match("rbxassetid") or s:match("rbxthumb")
or s:match("rbxgameasset") or s:match("^rbx") then return false, "资源" end
if s:find("www%.%w+") or s:match("%.com") or s:match("%.net") or s:match("%.org")
or s:match("%.io") or s:match("%.gg") or s:match("%w@%w+%.%w") then return false, "网址" end
if s:match("^[/\\#]") then return false, "路径" end
if s:find("€", 1, true) or s:find("¥", 1, true) then return false, "货币符" end
if #s <= 12 and s:match("%%[%a%%]") then return false, "格式占位符" end
if not s:find("%s") then
local core = s:gsub("^[%p%s]+", ""):gsub("[%p%s]+$", "")
if core == "" then return false, "空" end
if Trans.KNOWN(core) then return true end
if core:find("_") then return false, "标识符(下划线)" end
if core:match("^[%d%.]+$") then return false, "纯数字" end
if core:match("^v%d") then return false, "版本号" end
local letters = select(1, core:gsub("[^A-Za-z]", ""))
local digits = select(1, core:gsub("[^%d]", ""))
local nlet, ndig = #letters, #digits
if ndig > 0 and #core <= 16 then return false, "含数字的短串" end
if core:match("^[IVXLCM]+$") and #core <= 7 then return false, "罗马数字" end
if core:match("^%u+$") and #core <= 4 then return false, "大写缩写" end
if nlet >= 3 and not core:find("[aeiouAEIOU]") then return false, "无元音乱码" end
end
return true
end
Trans._sCache = {}
Trans._sN = 0
Trans.SHOULD_CACHE_MAX = 4000
Trans.ShouldCacheClear = function()
Trans._sCache = {}
Trans._sN = 0
end
function Trans.Should(s)
if type(s) ~= "string" then return false end
local hit = Trans._sCache[s]
if hit ~= nil then return hit end
local ok = Trans.ShouldV2(s:gsub("^%s+", ""):gsub("%s+$", "")) and true or false
if Trans._sN < Trans.SHOULD_CACHE_MAX then
Trans._sCache[s] = ok
Trans._sN = Trans._sN + 1
else
Trans.ShouldCacheClear()
Trans._sCache[s] = ok
Trans._sN = 1
end
return ok
end
function Trans.Translate(text, force)
if (not T.Translate and not force) or type(text) ~= "string" or text == "" then return nil end
text = text:gsub("^%s+", ""):gsub("%s+$", "")
if text == "" then return nil end
if not force and not Trans.Should(Trans.RT.HasTags(text) and Trans.RT.Strip(text) or text) then return nil end
local rtTags, rtMode = nil, tostring(C.TransRTMode or "\226\145\160")
if Trans.RT.HasTags(text) then
if rtMode:find("\226\145\161", 1, true) then
text = Trans.RT.Strip(text)
elseif rtMode:find("\226\145\162", 1, true) then
local core
core, rtTags = Trans.RT.Tokenize(text)
text = core
end
end
local glHits = nil
local glossed
glossed, glHits = Trans.GL.Apply(text)
text = glossed
if not force and not Trans.Should(text) then return nil end
if Trans.Cache[text] then
local hit0 = Trans.Cache[text]
local f0 = Trans.GL.Restore(hit0, glHits)
if rtTags and #rtTags > 0 then
local c0 = Trans.RT.RestoreChecked(f0, rtTags)
if c0 ~= nil then return c0 end
else
return Trans.RT.CleanResidue(f0)
end
end
local quick = Trans.QUICK[text:lower()]
if quick then Trans.Cache[text] = quick return quick end
if force then Trans._lastAt = 0 end
local now = os.clock()
if not force and (now - (Trans._lastAt or 0)) < (C.TransInterval or 0.15) then return nil end
Trans._lastAt = now
local r = Trans.Request(text)
if r and r ~= "" and r ~= text then
r = r:gsub("^%s*(翻译|译文|中文|汉化)%s*[:：]%s*", "")
r = r:gsub("^%s+", ""):gsub("%s+$", "")
if Trans.Cache[text] == nil then
Trans.Order = Trans.Order or {}
Trans.Order[#Trans.Order + 1] = text
Trans._cnt = (Trans._cnt or 0) + 1
end
Trans.Cache[text] = r
Trans.CACHE_MAX = Trans.CACHE_MAX or 5000
if Trans._cnt > Trans.CACHE_MAX * 1.1 then
local real = 0
for _ in pairs(Trans.Cache) do real = real + 1 end
Trans._cnt = real
if real > Trans.CACHE_MAX then
local target = math.floor(Trans.CACHE_MAX / 4)
local removed = 0
local ord = Trans.Order or {}
for i = 1, #ord do
local k = ord[i]
if Trans.Cache[k] ~= nil then
Trans.Cache[k] = nil
removed = removed + 1
if removed >= target then break end
end
end
local keep = {}
for k in pairs(Trans.Cache) do keep[#keep + 1] = k end
Trans.Order = keep
Trans._cnt = #keep
F.Out("[翻译] 缓存超过 " .. Trans.CACHE_MAX .. " 条, 已按最早顺序清理 " .. removed .. " 条")
end
end
Trans.Save()
local fin = Trans.GL.Restore(r, glHits)
if rtTags and #rtTags > 0 then
local checked = Trans.RT.RestoreChecked(fin, rtTags)
if checked == nil then return nil end
return checked
end
return Trans.RT.CleanResidue(fin)
end
return nil
end
Trans.Drain = function()
while Trans.Active < Trans.Max and #Trans.Queue > 0 do
local item = table.remove(Trans.Queue, 1)
Trans.Active = Trans.Active + 1
task.spawn(function()
local ok, tr = pcall(Trans.Translate, item.text, true)
if ok and tr and tr ~= item.text then pcall(item.apply, tr) end
Trans.Active = Trans.Active - 1
if Trans.Active < Trans.Max and #Trans.Queue > 0 then Trans.Drain() end
end)
end
end
function Trans.Async(text, applyFn)
if not T.Translate then return end
local hit = Trans.Cache[text] or Trans.QUICK[text:lower()]
if hit then pcall(applyFn, hit) return end
if #Trans.Queue > 200 then return end
Trans.Queue[#Trans.Queue + 1] = { text = text, apply = applyFn }
Trans.Drain()
end
function Trans.Prewarm()
task.spawn(function()
local ok, r = pcall(Trans.Translate, "warmup", true)
if ok and r then Trans.Cache["warmup"] = r end
F.Out("[翻译] 服务预热完成(system prompt 的 KV 缓存已就绪)")
end)
end
Trans.IsOurs = function(obj)
local p, steps = obj, 0
while p and steps < 16 do
if p:IsA("ScreenGui") then
local ok, v = pcall(function() return p:GetAttribute("CMOwned") end)
if ok and v == true then return true end
end
p = p.Parent
steps = steps + 1
end
return false
end
Trans.IsOfficial = function(obj)
local cg = nil
pcall(function() cg = game:GetService("CoreGui") end)
if not cg then return false end
local p, steps = obj, 0
while p and steps < 16 do
p = p.Parent
steps = steps + 1
if p == cg then return true end
end
return false
end
Trans._skip = { ours = 0, official = 0, invisible = 0 }
Trans.SkipEl = function(obj)
if obj.TextVisible == false then
Trans._skip.invisible = Trans._skip.invisible + 1
return "TextVisible=false"
end
local tt = obj.TextTransparency
if type(tt) == "number" and tt >= 0.95 then
Trans._skip.invisible = Trans._skip.invisible + 1
return "文字不可见"
end
if Trans.IsOurs(obj) then
Trans._skip.ours = Trans._skip.ours + 1
return "我们自己的界面"
end
if not C.TransOfficial and Trans.IsOfficial(obj) then
Trans._skip.official = Trans._skip.official + 1
return "Roblox 官方界面"
end
return nil
end
Trans.Reg = setmetatable({}, { __mode = "k" })
Trans.RegCount = function()
local n = 0
for o in pairs(Trans.Reg) do if typeof(o) == "Instance" and o.Parent then n = n + 1 end end
return n
end
Trans.GuiElNoReg = function(obj)
if not obj or obj.Visible == false then return end
if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
if Trans.SkipEl(obj) then return end
local txt = obj.Text
if type(txt) == "string" and Trans.RT.HasTags(txt) and obj.RichText ~= true then
txt = Trans.RT.Strip(txt)
end
if txt and Trans.Should(txt) then
Trans.Async(txt, function(tr)
if obj.Parent and obj.Visible ~= false then
local r = Trans.Reg[obj]
if r then r.last = tr end
obj.Text = tr
end
end)
end
end
Trans.RetranslateAll = function()
local items = {}
for obj, r in pairs(Trans.Reg) do
if typeof(obj) == "Instance" and obj.Parent and type(r.raw) == "string" then
items[#items + 1] = { o = obj, raw = r.raw }
else
Trans.Reg[obj] = nil
end
end
if #items == 0 then
F.Out("[翻译] 还没有登记过任何界面控件(先让它扫一遍界面)")
return 0
end
for i = 1, #items do
local it = items[i]
pcall(function() it.o.Text = it.raw end)
pcall(Trans.GuiElNoReg, it.o)
end
F.Out("[翻译] 已把 " .. tostring(#items) .. " 个控件还原成原文并重新翻译(切语言/改词条后用这个)")
return #items
end
function Trans.GuiEl(obj)
if not obj then return end
if obj.Visible == false then return end
if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
if Trans.SkipEl(obj) then return end
do
local txt = obj.Text
if type(txt) == "string" and Trans.RT.HasTags(txt) and obj.RichText ~= true then
txt = Trans.RT.Strip(txt)
end
if txt and Trans.Should(txt) then
local r = Trans.Reg[obj]
if r == nil then
Trans.Reg[obj] = { raw = txt, last = nil }
elseif r.last ~= nil and txt ~= r.last then
r.raw = txt
end
Trans.Async(txt, function(tr)
if obj.Parent and obj.Visible ~= false then
local rec = Trans.Reg[obj]
if rec then rec.last = tr end
obj.Text = tr
end
end)
end
end
end
function Trans.Scan()
local pg = LP:FindFirstChild("PlayerGui")
Trans._skip = { ours = 0, official = 0, invisible = 0 }
local roots = { pg }
if C.TransOfficial then roots[#roots + 1] = CoreGui end
for _, root in ipairs(roots) do
if root then
for _, obj in ipairs(F.walk(root)) do Trans.GuiEl(obj) end
end
end
for _, obj in ipairs(workspace:GetChildren()) do
if obj:IsA("ProximityPrompt") and obj.ActionText and obj.ActionText ~= "" then
Trans.Async(obj.ActionText, function(tr) if obj.Parent then obj.ActionText = tr end end)
end
end
end
function Trans.Health()
local rf = Trans.Req()
if type(rf) ~= "function" then return false, "执行器没有 request" end
local ok, res = pcall(function() return rf({ Url = Trans.HOST .. "/health", Method = "GET" }) end)
if not ok or type(res) ~= "table" then return false, "请求失败" end
if (res.StatusCode or 0) ~= 200 then return false, "HTTP " .. tostring(res.StatusCode) end
return true, tostring(res.Body or ""):sub(1, 120)
end
Trans.RestoreAll = function()
if type(Trans.Reg) ~= "table" then return 0 end
local n = 0
for obj, r in pairs(Trans.Reg) do
if typeof(obj) == "Instance" and obj.Parent and type(r.raw) == "string" then
pcall(function()
if obj.Text ~= r.raw then obj.Text = r.raw end
end)
n = n + 1
end
end
Trans.Reg = setmetatable({}, { __mode = "k" })
if n > 0 then F.Out("[翻译] 已关 · 界面还原成原文 " .. n .. " 个控件") end
return n
end
function Trans.Disable()
T.Translate = false
pcall(Trans.WatchOff)
pcall(F.ChatIMEBoxDisable)
Trans.HeartbeatOff()
if Trans.Loop then Trans.Loop = nil end
if T.ChatTranslate then F.ChatTranslateDisable() end
if T.BubbleTranslate then F.BubbleTranslateDisable() end
pcall(Trans.RestoreAll)
pcall(Trans.Flush)
end
function Trans.Enable()
T.Translate = true
Trans.Load()
local ok, body = Trans.Health()
if not ok then
F.Out("[翻译] ⚠ 本地翻译服务没起来(" .. tostring(body) .. ") ⇒ 双击打开「翻译模型开关.bat」把服务起起来再开翻译")
end
if Trans.Loop then Trans.HeartbeatOn() return true end
pcall(Trans.GL.AddAuto)
C.TransOfficial = false
Trans.Prewarm()
Trans.Scan()
Trans.WatchOn()
pcall(F.ChatIMEBoxEnable)
Trans.HeartbeatOn()
Trans.Loop = task.spawn(function()
while T.Translate do
task.wait(15)
if not T.Translate then break end
Trans.Scan()
end
Trans.Loop = nil
end)
F.Out("[翻译] 已开: 新出现的文字会立刻翻译, 文字变化即时跟上; 每 15 秒兜底全扫一次(原来每秒全扫, 现在省很多)")
return true
end
Trans.WatchOn = function()
if Trans._watch then return end
Trans._watch, Trans._sig = {}, {}
local function one(d)
if not T.Translate or not d then return end
pcall(function() Trans.GuiEl(d) end)
if (d:IsA("TextLabel") or d:IsA("TextButton"))
and not Trans._sig[d] then
Trans._sig[d] = true
pcall(function()
Trans._watch[#Trans._watch + 1] = d:GetPropertyChangedSignal("Text"):Connect(function()
if T.Translate then pcall(function() Trans.GuiEl(d) end) end
end)
end)
end
end
local function watch(root)
if not root then return end
pcall(function()
Trans._watch[#Trans._watch + 1] = root.DescendantAdded:Connect(function(d)
task.defer(function() one(d) end)
end)
end)
end
pcall(function() watch(LP:FindFirstChild("PlayerGui")) end)
pcall(function() watch(game:GetService("CoreGui")) end)
pcall(function() if gethui then watch(gethui()) end end)
end
Trans.WatchOff = function()
if Trans._watch then
for _, c in ipairs(Trans._watch) do pcall(function() c:Disconnect() end) end
end
Trans._watch, Trans._sig = nil, nil
end
function F.ChatTranslateEnable()
if F._chatTransHooked then return end
local tcs = game:GetService("TextChatService")
if not tcs then F.Out("[翻译] 本游戏没有 TextChatService, 聊天翻译不可用") return end
local prevIn = tcs.OnIncomingMessage
if not (type(prevIn) == "function" and prevIn._cmOwner == "CM") then F._oldOnIncoming = prevIn end
local hookedIn
local ok = pcall(function()
hookedIn = function(message)
local props = nil
if F._oldOnIncoming then
local ok2, p = pcall(F._oldOnIncoming, message)
if ok2 then props = p end
end
if T.ChatTranslate and message and message.Text then
local src = message.TextSource
if not src or src.Name ~= LP.Name then
local tr = Trans.Translate(message.Text, true)
if tr and tr ~= "" and tr ~= message.Text then
props = props or Instance.new("TextChatMessageProperties")
props.Text = message.Text .. "\n【" .. tr .. "】"
end
end
end
return props
end
hookedIn._cmOwner = "CM"
tcs.OnIncomingMessage = hookedIn
end)
if ok then F._chatTransHooked = true F.Out("[翻译] 公屏聊天翻译已开启") end
end
function F.ChatTranslateDisable()
if not F._chatTransHooked then return end
pcall(function()
local tcs = game:GetService("TextChatService")
if tcs and tcs.OnIncomingMessage and tcs.OnIncomingMessage._cmOwner == "CM" then
tcs.OnIncomingMessage = F._oldOnIncoming
end
end)
F._chatTransHooked = false
end
function F.BubbleTranslateEnable()
if F._bubbleTransHooked then return end
local tcs = game:GetService("TextChatService")
if not tcs then return end
local prevBb = tcs.OnBubbleAdded
if not (type(prevBb) == "function" and prevBb._cmOwner == "CM") then F._oldOnBubble = prevBb end
local hookedBb
local ok = pcall(function()
hookedBb = function(message, adornee)
local props = nil
if F._oldOnBubble then
local ok2, p = pcall(F._oldOnBubble, message, adornee)
if ok2 then props = p end
end
if T.BubbleTranslate and message and message.Text then
local src = message.TextSource
if not src or src.Name ~= LP.Name then
local tr = Trans.Translate(message.Text, true)
if tr and tr ~= "" and tr ~= message.Text then
props = props or Instance.new("BubbleChatMessageProperties")
props.Text = tr
end
end
end
return props
end
hookedBb._cmOwner = "CM"
tcs.OnBubbleAdded = hookedBb
end)
if ok then F._bubbleTransHooked = true F.Out("[翻译] 气泡翻译已开启") end
end
function F.BubbleTranslateDisable()
if not F._bubbleTransHooked then return end
pcall(function()
local tcs = game:GetService("TextChatService")
if tcs and tcs.OnBubbleAdded and tcs.OnBubbleAdded._cmOwner == "CM" then
tcs.OnBubbleAdded = F._oldOnBubble
end
end)
F._bubbleTransHooked = false
end
F.ChatIMEBoxEnable = function()
if F._chatIMEBox then return end
pcall(function()
local sg = Instance.new("ScreenGui")
sg.Name = "CM_ChatIMEBox"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = (gethui and pcall(gethui) and gethui()) or game:GetService("CoreGui")
local box = Instance.new("TextBox")
box.Name = "CM_ChatInput"
box.Size = UDim2.new(0.5, 0, 0, 32)
box.Position = UDim2.new(0.25, 0, 0.9, 0)
box.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
box.BackgroundTransparency = 0.35
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.PlaceholderText = "[CM] 中文聊天框：打中文回车发送，不翻倍"
box.ClearTextOnFocus = false
box.TextEditable = true
box.Font = Enum.Font.Code
box.TextSize = 16
box.Parent = sg
F._chatIMEBox = sg
local function send()
local txt = box.Text
if not txt or txt == "" then return end
box.Text = ""
F.ChatSend(txt)
end
box.FocusLost:Connect(function(enterPressed)
if enterPressed then send() end
end)
box.InputBegan:Connect(function(input, processed)
if processed then return end
if input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
send()
end
end)
F.Out("[IME聊天] 已开：左下角框打中文 → 回车发送（不再翻倍）")
end)
end
F.ChatIMEBoxDisable = function()
pcall(function() if F._chatIMEBox and F._chatIMEBox.Parent then F._chatIMEBox:Destroy() end end)
F._chatIMEBox = nil
end
F.ChatSend = function(msg)
pcall(function()
local tcs = game:GetService("TextChatService")
local ch = tcs and tcs:FindFirstChild("TextChannels")
and (tcs.TextChannels:FindFirstChild("RBXGeneral") or tcs.TextChannels:FindFirstChild("SayChannel"))
if ch and ch:IsA("TextChannel") then ch:SendAsync(msg) return end
local chat = game:GetService("Chat")
if chat and chat.Chat then chat:Chat(game.Players.LocalPlayer, msg, "All") return end
F.Out("[IME聊天] 发送失败：本游戏聊天接口不可用")
end)
end
function F.TranslateDisable() Trans.Disable() end
function F.TranslateEnable() return Trans.Enable() end
local function UnloadAll()
for k in pairs(T) do T[k] = false end
local disables = {
F.KickGuardDisable, F.AntiFlingDisable, F.AntiRagdollDisable, F.AntiKnockdownDisable,
F.FreecamDisable,
F.HidePlayerDisable, F.HudDisable, F.CrosshairDisable, F.FovCircleDisable,
F.LockCamDisable,
F.CharPersistDisable, F.LivePlayersDisable, F.AutoSaveDisable,
F.AntiAFKDisable, F.KickGuardPathsDisable,
AC.WatchNewRemotesDisable, AC.WatchNewScriptsDisable, AC.TrapDisable.Disable,
AC.UnblockRemotes, AC.ReenableDisabledConns, AC.UninstallAntiTP, AC.AntiPauseDisable, AC.UninstallIndexMask,
AC.UninstallSetmetatableHook, AC.UninstallNamecallHook,
F.GuiProtectionDisable,
F.CaptureDisable, F.TranslateDisable, F.ChatTranslateDisable, F.BubbleTranslateDisable,
F.NoClipDisable,
F.SpeedRestore, F.FlySet, F.FlyDestroy, F.InstantInteractDisable, F.BypassDisable, F.AllInOneDisableAll, F.PinDisable,
F.SpoofDisable, F.CarryGuardDisable, F.GuardOnDisable, F.DeepNeuterDisable, F.SpeedAntiTPDisable,
F.AimSet, F.KillAuraDisable, F.BodyHLDisable, F.HideDisable,
F.AutoTrainDisable, F.AutoBonusDisable, F.AutoGymDisable, F.SilentAimDisable, F.HealthShowSet, F.HealthIsolateDisable, F.LockFieldsUninstall,
F.FullBrightDisable, F.NightVisionDisable, F.NoFogDisable,
F.InfiniteJumpDisable, F.KickRejoinDisable, F.LockCamDisable,
F.SteadyDisable, F.TrapGuardDisable, F.HitGuardDisable, F.SpeedAntiTPDisable,
function()
AC._neutFns = {}
F._dumpText = nil
F._capLog = {}
F._autoTh = nil
F._cfgSyncing = false
F._tpMouseOn = false
pcall(function()
local g = getgenv and getgenv()
if type(g) == "table" and F._inst and g[F.INSTANCE_KEY] == F._inst then
g[F.INSTANCE_KEY] = nil
end
end)
if F._touchToggle then pcall(function() F._touchToggle:Destroy() end) F._touchToggle = nil end
end,
MuteDisable, FOVDisable, ZoomDisable,
F.InvisibleDisable, AntilagDisable, GodDisable, RegenDisable, NoDeathDisable, LockHealthDisable,
F.AntiCheatGCRestore, F.CMX_DisableAll, F.LightWatchDisable, F.MetaHookUninstall,
}
local okN, badN = 0, 0
for i = 1, #disables do
local fn = disables[i]
if type(fn) == "function" then
if pcall(fn) then okN = okN + 1 else badN = badN + 1 end
end
end
F.Out("[卸载] 已执行 " .. tostring(okN) .. " 项关闭操作"
.. (badN > 0 and (" · ⚠ 有 " .. tostring(badN) .. " 项报错(功能可能残留, 把日志发给维护者)") or " · 全部无报错"))
pcall(function() if KG and KG.rjConn then KG.rjConn:Disconnect() KG.rjConn = nil end end)
pcall(function()
if AC._stblOld and hookfunction then hookfunction(setmetatable, AC._stblOld) end
AC._stblOld = nil
end)
pcall(function()
if getgenv and getgenv().CM_Window and getgenv().CM_Window.Destroy then
getgenv().CM_Window:Destroy()
getgenv().CM_Window = nil
end
end)
pcall(function() if Fluent and Fluent.GUI then Fluent.GUI:Destroy() end end)
pcall(function()
if getgenv and getgenv().CM_ToggleSG then
pcall(function() getgenv().CM_ToggleSG:Destroy() end)
getgenv().CM_ToggleSG = nil
end
end)
pcall(function()
if getgenv then getgenv().CM_TogglePolish = nil end
end)
local killed = 0
pcall(function() killed = F.NukeAllGUIs(true) end)
if killed > 0 then F.Out("[卸载] 兜底清掉 " .. tostring(killed) .. " 个残留浮窗") end
pcall(F.Conn.ClearAll)
F.MetaLayers = {}
F.MetaTargets = {}
F.Out("[CheatMenu] 已干净卸载")
pcall(function() F.LogFlush("卸载") end)
task.delay(0.8, function()
local alive = {}
if F._aimConn then alive[#alive + 1] = "自瞄" end
if F._spdConn then alive[#alive + 1] = "加速" end
if F._flyConn then alive[#alive + 1] = "飞行" end
if F.KillAuraConn then alive[#alive + 1] = "自动攻击" end
if F.II_CONN or F.II_SHOWN then alive[#alive + 1] = "瞬间交互钩子" end
if F._touchToggle and F._touchToggle.Parent then alive[#alive + 1] = "菜单悬浮按钮" end
if #alive == 0 then
F.Out("[卸载] 复核通过: 界面已清, 没有任何残留循环(自瞄/加速/飞行/自动攻击/交互钩子 全停)")
else
F.Out("[卸载] ⚠ 复核发现还在跑的: " .. table.concat(alive, " / ")
.. " ⇒ 再点一次「卸载脚本」; 仍在的话请「重进一次游戏」并把这两行日志发给维护者")
for _, fn in ipairs({ F.AimSet, F.KillAuraDisable, F.SpeedRestore, F.FlySet, F.InstantInteractDisable }) do
if type(fn) == "function" then pcall(fn) end
end
end
pcall(function() F.LogFlush("卸载复核") end)
end)
end
local function RestoreFeatures()
if T.CharPersist == nil then T.CharPersist = false end
if T.AutoSave == nil then T.AutoSave = false end
if T.Aim360 == nil then T.Aim360 = true end
end
pcall(function()
local sid = tostring(game.PlaceId) .. "/" .. tostring(game.JobId)
if C.WpServer ~= sid then
local had = type(C.Waypoints) == "table" and #C.Waypoints or 0
if had > 0 then
C.Waypoints = {}
F.Out("[点位] 换服 / 重进游戏 ⇒ 已自动清空上次的 " .. tostring(had) .. " 个收藏点位")
end
C.WpServer = sid
do end
end
end)
local _touch = (UIS.TouchEnabled == true)
local _vw, _vh = 500, 540
pcall(function()
local cam = workspace.CurrentCamera
if cam and cam.ViewportSize.X > 0 then
_vw, _vh = cam.ViewportSize.X, cam.ViewportSize.Y
end
end)
local _w = math.clamp(math.floor(_vw * 0.96), 240, _touch and 520 or 500)
local _h = math.clamp(math.floor(_vh * 0.88), 240, _touch and 600 or 540)
local Window = Fluent:CreateWindow({
Title = "CheatMenu",
SubTitle = F.VERSION,
TabWidth = _touch and math.clamp(math.floor(_w / 8), 50, 66) or 100,
Size = UDim2.fromOffset(_w, _h),
Acrylic = false,
Theme = "Aqua",
MinimizeKey = Enum.KeyCode.G,
})
if getgenv then getgenv().CM_Window = Window end
pcall(function()
local g = Fluent and Fluent.GUI
if not g then return end
local function rel()
if not g.Enabled then return end
pcall(function()
if UIS.MouseBehavior ~= Enum.MouseBehavior.Default then
UIS.MouseBehavior = Enum.MouseBehavior.Default
end
end)
end
pcall(function() g:GetPropertyChangedSignal("Enabled"):Connect(rel) end)
end)
pcall(function()
if not _touch then return end
local host = nil
pcall(function() host = gethui and gethui() end)
if not host then pcall(function() host = game:GetService("CoreGui") end) end
if not host then return end
local sg = Instance.new("ScreenGui")
sg.Name = "CMTouchToggle"
pcall(function() sg:SetAttribute("CMOwned", true) end)
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = host
local btn = Instance.new("TextButton")
btn.Size = UDim2.fromOffset(58, 58)
btn.Position = UDim2.new(0, 10, 0.36, 0)
btn.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
btn.BackgroundTransparency = 0.2
btn.Text = "菜单\n长按急停"
btn.TextColor3 = Color3.fromRGB(240, 240, 240)
btn.TextSize = 13
btn.Parent = sg
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, 12)
c.Parent = btn
local dragInput, sx, sy, bx, by = nil, 0, 0, 0, 0
btn.InputBegan:Connect(function(i)
if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
dragInput = i
sx, sy = i.Position.X, i.Position.Y
bx, by = btn.Position.X.Offset, btn.Position.Y.Offset
F._menuHoldAt = os.clock()
F._menuHoldMoved = false
local holdType = i.UserInputType
task.delay(2.0, function()
if not (F._menuHoldAt and not F._menuHoldMoved) then return end
if (os.clock() - F._menuHoldAt) < 1.9 then return end
local okProbe, stillDown = pcall(function()
if holdType == Enum.UserInputType.Touch then
local t = UIS:GetTouchesPressed()
return ((type(t) == "table") and (#t > 0)) or false
end
return UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) == true
end)
if okProbe and not stillDown then F._menuHoldAt = nil return end
F._menuHoldAt = nil
F.Out("[急停] 浮钮被持续按住 1.9 秒 ⇒ 触发一键全关")
pcall(F.PanicKeyDisableAll)
end)
end
end)
btn.InputChanged:Connect(function(i)
if dragInput and i == dragInput then
local dx = i.Position.X - sx
local dy = i.Position.Y - sy
if math.abs(dx) > 10 or math.abs(dy) > 10 then F._menuHoldMoved = true end
btn.Position = UDim2.new(0, bx + dx, 0, by + dy)
end
end)
btn.InputEnded:Connect(function(i)
if i == dragInput then dragInput = nil end
F._menuHoldAt = nil
end)
btn.MouseButton1Click:Connect(function()
local wasOpen = F.MenuOpen()
F._menuOpen = not wasOpen
local ok = pcall(function()
local w = getgenv and getgenv().CM_Window
if w and type(w.Toggle) == "function" then w:Toggle() return true end
if w and w.Enabled ~= nil then w.Enabled = not w.Enabled return true end
if Fluent and Fluent.GUI then Fluent.GUI.Enabled = not Fluent.GUI.Enabled return true end
return false
end)
if not ok then F.Out("[移动端] 菜单开关失败(该 Fluent 版本接口不同) —— 可长按拖走这个按钮") end
if wasOpen then pcall(F.CloseDropdowns) end
end)
F._touchToggle = sg
F.Out("[移动端] 已加常驻「菜单」按钮(可拖动)")
end)
pcall(function() Fluent:ToggleTransparency(true) end)
local function buildMenu()
function F.CMX_G(n)
if type(n) ~= "string" then return nil end
local ok, v = pcall(AC.cap, n)
if ok then return v end
return nil
end
F.CMX_DisableAll = function()
for _, fn in ipairs({
F.CMX_IdentityMaskDisable, F.CMX_FFlagRestore, F.CMX_SpoofIndexDisable,
F.CMX_ViewFilterDisable, F.CMX_HumanizeDisable, F.CMX_InstNewDisable,
F.CMX_DebugMaskDisable, F.CMX_RequireBlockDisable, F.CMX_ClockMaskDisable,
F.CMX_BlockReportDisable, F.CMX_CutLogDisable,
F.CMX_NeuterPlusDisable, F.CMX_HashFreezeDisable,
}) do pcall(fn) end
T.CMX_SpoofPos = false
F.CMX_SpoofOn, F.CMX_ViewOn, F.CMX_InstNewOn = false, false, false
task.delay(1, function() pcall(F.CMX_RestoreRO, true) end)
end
F.CMX_NetOwnerReport = function()
local _, _, root = GC()
if not root then
F.Out("[补强·所有权诊断] 没角色")
return
end
F.Out("[补强·所有权诊断] 本机角色 HumanoidRootPart:")
pcall(function()
local o = root:GetNetworkOwner()
F.Out("   GetNetworkOwner = " .. (o and (o.Name .. "(" .. tostring(o.UserId) .. ")") or "nil(服务器持有或不可读)"))
end)
pcall(function() F.Out("   IsGrounded = " .. tostring(root:IsGrounded())) end)
local cam = workspace.CurrentCamera
if cam then
pcall(function()
local o2 = cam:GetNetworkOwner()
F.Out("   Camera.GetNetworkOwner = " .. (o2 and o2.Name or "nil"))
end)
end
local cnt = 0
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP then
local ch = pl.Character
local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
if hrp then
local o = nil
pcall(function() o = hrp:GetNetworkOwner() end)
F.Out("   " .. pl.Name .. " 的角色所有权 = " .. (o and o.Name or "nil(非本机)"))
cnt = cnt + 1
end
if cnt >= 6 then break end
end
end
end
F.CMX_BBReport = function()
local _, _, root = GC()
if not root then
F.Out("[补强·包围盒] 没角色")
return
end
pcall(function()
local cf, sz = root.CFrame, root.Size
F.Out("[补强·包围盒] HumanoidRootPart Size=" .. tostring(sz))
F.Out("   世界包围盒 中心=" .. tostring(cf.Position) .. " 半径≈" .. string.format("%.2f", sz.Magnitude * 0.5))
end)
local ch = LP.Character
if ch then
pcall(function()
local cf, sz = ch:GetBoundingBox()
F.Out("   角色 Model 包围盒 尺寸=" .. tostring(sz) .. " (精确含所有部件)")
end)
pcall(function()
local sz2 = ch:GetExtentsSize()
F.Out("   角色 GetExtentsSize=" .. tostring(sz2) .. " (轴对齐外接盒)")
end)
local names = {}
pcall(function()
for _, d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") and d.CanCollide then names[#names + 1] = d.Name end
end
end)
F.Out("   可碰撞部件 " .. tostring(#names) .. " 个: " .. table.concat(names, ", "):sub(1, 200))
end
local _, _, r2 = GC()
if r2 then
pcall(function()
local parts = WS:GetPartBoundsInRadius(r2.Position, 12, OverlapParams.new())
F.Out("   半径12格内部件 " .. tostring(#parts) .. " 个 (可评估命中盒是否够大)")
end)
end
end
F.CMX_SafeHook = function(f, wrapper, wantLua)
if type(f) ~= "function" or type(wrapper) ~= "function" then return nil end
if type(hookfunction) ~= "function" then return nil end
local box = wrapper
local newl = F.CMX_G("newlclosure")
local newc = F.CMX_G("newcclosure")
local prefLua = wantLua
if prefLua == nil then
prefLua = false
pcall(function()
if type(islclosure) == "function" then prefLua = islclosure(f) and true or false end
end)
end
local made = false
if prefLua and type(newl) == "function" then
local okL, w = pcall(newl, wrapper)
if okL and type(w) == "function" then box = w made = true end
end
if not made and type(newc) == "function" then
local okC, w = pcall(newc, wrapper)
if okC and type(w) == "function" then box = w made = true end
end
if not made and type(newl) == "function" then
local okL2, w2 = pcall(newl, wrapper)
if okL2 and type(w2) == "function" then box = w2 made = true end
end
local orig = nil
if F.CMX_MarkOwn then pcall(F.CMX_MarkOwn, box) end
local ok = pcall(function() orig = hookfunction(f, box) end)
if not ok or type(orig) ~= "function" then return nil end
return orig
end
F.CMX_FindClosure = function(nups, nconsts)
if type(getgc) ~= "function" then return nil, 0 end
local found, seen = nil, 0
pcall(function()
for _, f in next, getgc() do
seen = seen + 1
if seen > 60000 then break end
if type(f) == "function" and (not islclosure or islclosure(f)) then
local ops, ocs = nil, nil
if dbgGetUpvalues then pcall(function() ops = dbgGetUpvalues(f) end) end
if dbgGetConstants then pcall(function() ocs = dbgGetConstants(f) end) end
if type(ops) ~= "table" and type(debug) == "table" and type(debug.getupvalue) == "function" then
ops = {}
for i = 1, 64 do
local nm, v = debug.getupvalue(f, i)
if nm == nil then break end
ops[i] = v
end
end
if type(ocs) ~= "table" and type(debug) == "table" and type(debug.getconstant) == "function" then
ocs = {}
for i = 1, 512 do
local v = debug.getconstant(f, i)
if v == nil then break end
ocs[i] = v
end
end
if ops and ocs and #ops == nups and #ocs == nconsts then
found = f
break
end
end
end
end)
return found, seen
end
F.CMX_FindClosureFast = function(nups, nconsts)
local fg = F.CMX_G("filtergc")
if type(fg) == "function" then
local shapes = {
{ { UpvalueCount = nups, ConstantCount = nconsts }, true },
{ { Upvalues = nups, Constants = nconsts }, true },
{ { UpvalueCount = nups }, true },
}
for i = 1, #shapes do
local ok, r = pcall(fg, "function", shapes[i][1], shapes[i][2])
if ok and type(r) == "table" then
for k = 1, #r do
local cand = r[k]
if type(cand) == "function" then
local fp = nil
pcall(function() fp = F.FnFingerprint(cand) end)
if fp and fp.nups == nups and fp.nconsts == nconsts then
return cand, -1, true
end
end
end
elseif ok and type(r) == "function" then
local fp = nil
pcall(function() fp = F.FnFingerprint(r) end)
if fp and fp.nups == nups and fp.nconsts == nconsts then
return r, -1, true
end
end
end
end
local f, seen = F.CMX_FindClosure(nups, nconsts)
return f, seen, false
end
F.CMX_ConstList = function(txt)
local a, b = F.CMX_ScrubParse(txt)
local f, seen, fast = F.CMX_FindClosureFast(a, b)
if not f then
F.Out("[绕过·常量] 形状(" .. tostring(a) .. "," .. tostring(b) .. ") 无命中(扫了 " .. tostring(seen) .. " 个)")
return false
end
F.Out("[绕过·常量] 形状(" .. tostring(a) .. "," .. tostring(b) .. ") 命中"
.. (fast and " · filtergc 加速" or (" · 全扫 " .. tostring(seen) .. " 个")))
local consts = nil
if dbgGetConstants then pcall(function() consts = dbgGetConstants(f) end) end
if type(consts) ~= "table" and type(debug) == "table" and type(debug.getconstant) == "function" then
consts = {}
for i = 1, 512 do
local v = debug.getconstant(f, i)
if v == nil then break end
consts[i] = v
end
end
consts = consts or {}
local shown = 0
for i = 1, #consts do
local v = consts[i]
local t = type(v)
if t == "string" or t == "number" then
shown = shown + 1
if shown <= 60 then
F.Out(string.format("[绕过·常量]   [%d] %s = %s", i, t, tostring(v):sub(1, 90)))
end
end
end
F.Out("[绕过·常量] 共 " .. tostring(#consts) .. " 个常量, 其中可打印的 " .. tostring(shown) .. " 个")
return true
end
F.CMX_HookLedger = function()
F.Out("[绕过·台账] ===== 本脚本当前已安装的钩子/拦截层 =====")
local n, listed = 0, 0
pcall(function()
for slot, bucket in pairs(F.MetaLayers or {}) do
for id, rec in pairs(bucket) do
if rec and rec.alive then
n = n + 1
if listed < 20 then
listed = listed + 1
local tn = "?"
pcall(function()
local t = rec.target
if t == game then tn = "game"
elseif typeof(t) == "Instance" then tn = tostring(t.Name)
else tn = tostring(t) end
end)
F.Out(string.format("[绕过·台账]   #%d 元方法 %s · 层「%s」· 目标 %s", n, tostring(slot), tostring(id), tn))
end
end
end
end
end)
local hooked = 0
pcall(function()
for _ in pairs(AC._hookedFns or {}) do hooked = hooked + 1 end
end)
local guarded = 0
pcall(function()
for _ in pairs(F._stealthHooked or {}) do guarded = guarded + 1 end
end)
F.Out("[绕过·台账]   元方法拦截层 " .. tostring(n) .. " 个 · 被我们钩过的函数 " .. tostring(hooked) .. " 个"
.. " · 隐身钩 " .. tostring(guarded) .. " 个")
if F.CMX_ScrubOn then
F.Out("[绕过·台账]   ★ 参数清洗钩子: 开 · 已清洗 " .. tostring(F.CMX_ScrubHits or 0) .. " 次 · 自愈重装 "
.. tostring(F.CMX_ScrubHealFix or 0) .. " 次")
end
if KG.hooked then
F.Out("[绕过·台账]   ★ 防踢 Kick 钩子: 开 · 拦截 " .. tostring(KG.blocked or 0) .. " 次 · 自愈重装 "
.. tostring(F._kgHealFix or 0) .. " 次")
end
if F._lightConn then F.Out("[绕过·台账]   ★ 光照复写监听: 开") end
F.Out("[绕过·台账]   要全卸: 系统页「一键全关」/ 设置页「卸载脚本」")
end
F.CMX_Own = setmetatable({}, { __mode = "k" })
F.CMX_SpoofParts = setmetatable({}, { __mode = "k" })
F.CMX_HiddenCount = 0
F.CMX_Jitter = function(base, pct)
local b = tonumber(base) or 0.5
local p = tonumber(pct) or 0.3
return b * (1 - p + math.random() * p * 2)
end
F.CMX_MarkOwn = function(o)
if typeof(o) == "Instance" then
F.CMX_Own[o] = true
F.CMX_HiddenCount = F.CMX_HiddenCount + 1
end
return o
end
F.CMX_IsHidden = function(o)
if typeof(o) ~= "Instance" then return false end
if F.CMX_Own[o] then return true end
local nm = nil
pcall(function() nm = o.Name end)
if type(nm) == "string" then
if nm:find("CMFly", 1, true) or nm:find("CMX_", 1, true) then
F.CMX_Own[o] = true
F.CMX_HiddenCount = F.CMX_HiddenCount + 1
return true
end
end
return false
end
F.CMX_IsOwnPart = function(t)
if F.CMX_SpoofParts[t] then return true end
if F.CMX_SpoofMiss[t] == F.CMX_SpoofGen then return false end
local ok, ours = pcall(function()
local ch = LP.Character
return ch ~= nil and (t == ch or t:IsDescendantOf(ch))
end)
if ok and ours then
F.CMX_SpoofParts[t] = true
return true
end
F.CMX_SpoofMiss[t] = F.CMX_SpoofGen
return false
end
F.CMX_LegitWalk = function()
local w = tonumber(F._orig and F._orig.walk) or tonumber(F._preSpeed)
if not w or w <= 0 or w > 40 then w = 16 end
return w
end
F.CMX_IsCaller = function()
if type(checkcaller) ~= "function" then return true end
local ok, r = pcall(checkcaller)
if not ok then return true end
return r and true or false
end
F.CMX_SpoofLast = setmetatable({}, { __mode = "k" })
F.CMX_SpoofMiss = setmetatable({}, { __mode = "k" })
F.CMX_SpoofGen = 1
F.CMX_SpoofKey = {
AssemblyLinearVelocity = true, Velocity = true,
AssemblyAngularVelocity = true, RotVelocity = true,
Position = true, CFrame = true,
}
F.CMX_SmoothPos = function(t, real)
local now = os.clock()
local st = F.CMX_SpoofLast[t]
if not st then
F.CMX_SpoofLast[t] = { p = real, t = now }
return real
end
local dt = now - st.t
if dt < 0 then dt = 0 end
if dt > 0.5 then dt = 0.5 end
st.t = now
local maxStep = F.CMX_LegitWalk() * dt + 0.6
local d = real - st.p
local m = d.Magnitude
if m > maxStep then
st.p = st.p + d.Unit * maxStep
else
st.p = real
end
return st.p
end
F.CMX_GcinfoMaskEnable = function()
if F._gcMaskOn then return end
if type(gcinfo) ~= "function" then return end
local orig = gcinfo
F._gcMaskOrig = orig
F._gcMaskByAssign = nil
local base = nil
pcall(function() base = orig() end)
local ok = false
pcall(function()
local box
if type(newcclosure) == "function" then
box = newcclosure(function()
if not F._gcMaskOn then return orig() end
if F.CMX_IsCaller() then return orig() end
return base
end)
else
box = function()
if not F._gcMaskOn then return orig() end
if F.CMX_IsCaller() then return orig() end
return base
end
end
if type(hookfunction) == "function" then
hookfunction(gcinfo, box)
else
gcinfo = box
F._gcMaskByAssign = true
end
ok = true
end)
F._gcMaskOn = ok and true or false
if F._gcMaskOn then
F.Out("[伪装·gcinfo] 已开: 反作弊用 gcinfo 量增量只会拿到恒定值(增量 0) ⇒ 查不出我们的钩子")
end
end
F.CMX_GcinfoMaskDisable = function()
pcall(function()
if F._gcMaskOrig then
if F._gcMaskByAssign then
gcinfo = F._gcMaskOrig
elseif type(hookfunction) == "function" then
hookfunction(gcinfo, F._gcMaskOrig)
end
end
end)
F._gcMaskOrig = nil
F._gcMaskByAssign = nil
F._gcMaskOn = false
F.Out("[伪装·gcinfo] 已关: gcinfo 已还原")
end
F.CMX_SpoofIndexEnable = function()
if F.CMX_SpoofOn then return false end
F.Try("CMX_GcinfoMaskEnable", F.CMX_GcinfoMaskEnable)
F.CMX_SpoofUseCount = 0
F.CMX_SpoofGen = F.CMX_SpoofGen or 1
F.CMX_SpoofParts = setmetatable({}, { __mode = "k" })
F.CMX_SpoofMiss  = setmetatable({}, { __mode = "k" })
F.CMX_SpoofLast  = setmetatable({}, { __mode = "k" })
local got = F.MetaInstall("game.__index", game, "CMXSpoof", function(box)
return function(t, k)
if not F.CMX_SpoofOn then return box.orig(t, k) end
if not F.CMX_SpoofKey[k] then return box.orig(t, k) end
if F.CMX_IsCaller() then return box.orig(t, k) end
if typeof(t) ~= "Instance" then return box.orig(t, k) end
if not F.CMX_IsOwnPart(t) then return box.orig(t, k) end
if (k == "Position" or k == "CFrame") and not T.CMX_SpoofPos then return box.orig(t, k) end
if k == "AssemblyLinearVelocity" or k == "Velocity" then
local v = box.orig(t, k)
if typeof(v) == "Vector3" then
local sp = F.CMX_LegitWalk()
local h = Vector3.new(v.X, 0, v.Z)
if h.Magnitude > sp and h.Magnitude > 0.001 then
h = h.Unit * sp
end
F.CMX_SpoofUseCount = (F.CMX_SpoofUseCount or 0) + 1
return Vector3.new(h.X, v.Y, h.Z)
end
elseif k == "AssemblyAngularVelocity" or k == "RotVelocity" then
local v = box.orig(t, k)
if typeof(v) == "Vector3" and v.Magnitude > 0.5 then
F.CMX_SpoofUseCount = (F.CMX_SpoofUseCount or 0) + 1
return Vector3.zero
end
elseif k == "Position" then
local v = box.orig(t, k)
if typeof(v) == "Vector3" then
F.CMX_SpoofUseCount = (F.CMX_SpoofUseCount or 0) + 1
return F.CMX_SmoothPos(t, v)
end
elseif k == "CFrame" then
local cf = box.orig(t, k)
if typeof(cf) == "CFrame" then
F.CMX_SpoofUseCount = (F.CMX_SpoofUseCount or 0) + 1
return CFrame.new(F.CMX_SmoothPos(t, cf.Position)) * (cf - cf.Position)
end
end
return box.orig(t, k)
end
end)
if not got then
T.CMX_SpoofIndex = false
F.Out("[绕过·属性伪装] 装不上 __index 钩子(执行器不支持) ⇒ 该层不可用")
return false
end
F.CMX_SpoofOn = true
pcall(function()
F._spoofCharConn = LP.CharacterAdded:Connect(function()
F.CMX_SpoofGen = (F.CMX_SpoofGen or 1) + 1
F.CMX_SpoofParts = setmetatable({}, { __mode = "k" })
F.CMX_SpoofMiss = setmetatable({}, { __mode = "k" })
F.CMX_SpoofLast = setmetatable({}, { __mode = "k" })
end)
end)
F.Out("[绕过·属性伪装] 已开: 别人读你角色的 速度/角速度/位置/CFrame 会拿到「按合法速度平滑后」的值"
.. " · 我们自己(含加速/飞行/传送)读到的仍是真值(checkcaller 分流)")
return true
end
F.CMX_SpoofIndexDisable = function()
pcall(F.CMX_GcinfoMaskDisable)
if not F.CMX_SpoofOn then return end
F.CMX_SpoofOn = false
pcall(function() F.MetaUninstall("game.__index", "CMXSpoof") end)
if F._spoofCharConn then pcall(function() F._spoofCharConn:Disconnect() end) F._spoofCharConn = nil end
F.CMX_SpoofParts = setmetatable({}, { __mode = "k" })
F.CMX_SpoofMiss  = setmetatable({}, { __mode = "k" })
F.CMX_SpoofLast  = setmetatable({}, { __mode = "k" })
F.Out("[绕过·属性伪装] 已关 · 本次共伪装 " .. tostring(F.CMX_SpoofUseCount or 0) .. " 次属性读取")
end
F.CMX_ViewFilterEnable = function()
if F.CMX_ViewOn then return false end
local got = F.MetaInstall("__namecall", game, "CMXView", function(box)
return function(self, ...)
local m = getnamecallmethod and getnamecallmethod() or ""
if (m == "GetChildren" or m == "GetDescendants" or m == "FindFirstChild"
or m == "FindFirstChildOfClass" or m == "FindFirstChildWhichIsA")
and not F.CMX_IsCaller() then
local res = box.orig(self, ...)
if m == "GetChildren" or m == "GetDescendants" then
if type(res) == "table" then
local out, n = {}, 0
for i = 1, #res do
if not F.CMX_IsHidden(res[i]) then
n = n + 1
out[n] = res[i]
end
end
F.CMX_ViewUseCount = (F.CMX_ViewUseCount or 0) + 1
return out
end
return res
end
if F.CMX_IsHidden(res) then return nil end
return res
end
return box.orig(self, ...)
end
end)
if not got then
T.CMX_ViewFilter = false
F.Out("[绕过·视图过滤] 装不上 __namecall 钩子 ⇒ 该层不可用")
return false
end
F.CMX_ViewOn = true
F.CMX_ViewUseCount = 0
pcall(function()
F.CMX_MarkOwn(F._flyAtt)
F.CMX_MarkOwn(F._flyAo)
F.CMX_MarkOwn(F._flyAp)
F.CMX_MarkOwn(F._flyBv)
F.CMX_MarkOwn(F._flyBg)
end)
F.Out("[绕过·视图过滤] 已开: 反作弊遍历你的角色时, 看不见我们挂上去的东西(飞行约束/附件/方框)"
.. " · 我们自己的遍历不受影响")
return true
end
F.CMX_ViewFilterDisable = function()
if not F.CMX_ViewOn then return end
F.CMX_ViewOn = false
pcall(function() F.MetaUninstall("__namecall", "CMXView") end)
F.Out("[绕过·视图过滤] 已关 · 本次过滤 " .. tostring(F.CMX_ViewUseCount or 0) .. " 次遍历")
end
F.CMX_HumanizeEnable = function()
F.CMX_HumanizeOn = true
F.Out("[绕过·去机械化] 已开: 自动点击/自动交互/挂机注入的间隔改成随机抖动(0.7~1.3 倍), 不再是死板等间隔")
return true
end
F.CMX_HumanizeDisable = function()
if not F.CMX_HumanizeOn then return end
F.CMX_HumanizeOn = false
F.Out("[绕过·去机械化] 已关: 恢复固定间隔")
end
F.CMX_FakeSrc = "@game/PlayerScripts/PlayerModule/ControlModule"
F.CMX_IsOursFn = function(f)
if type(f) ~= "function" then return false end
return F.CMX_Own[f] == true
end
F.CMX_InstNewEnable = function()
if F.CMX_InstNewOn then return false end
if type(Instance) ~= "table" or type(Instance.new) ~= "function" then return false end
local orig
orig = F.CMX_SafeHook(Instance.new, function(cls, parent, ...)
local o = orig(cls, parent, ...)
if F.CMX_InstNewOn and F.CMX_MarkFromOurs and F.CMX_IsCaller() then
pcall(F.CMX_MarkOwn, o)
end
return o
end)
if not orig then
T.CMX_InstNew = false
F.Out("[绕过·自产登记] 钩不上 Instance.new ⇒ 该层不可用")
return false
end
F.CMX_InstNewOrig = orig
F.CMX_InstNewOn = true
F.CMX_MarkFromOurs = true
F.Out("[绕过·自产登记] 已开: 此后**我们**创建的任何实例自动登记为「自己人」"
.. " ⇒ 视图过滤不用再靠名字, 游戏/反作弊的遍历一律看不见(游戏自己 created 的不受影响)")
return true
end
F.CMX_InstNewDisable = function()
if not F.CMX_InstNewOn then return end
F.CMX_InstNewOn = false
F.CMX_MarkFromOurs = false
if F.CMX_InstNewOrig then
pcall(function() hookfunction(Instance.new, F.CMX_InstNewOrig) end)
end
F.CMX_InstNewOrig = nil
F.Out("[绕过·自产登记] 已关(已还原 Instance.new)")
end
F.CMX_DebugMaskEnable = function()
if F.CMX_DebugMaskOn then return false end
local d = debug
if type(d) ~= "table" then return false end
local target = d.info or d.getinfo
if type(target) ~= "function" then return false end
local orig
orig = F.CMX_SafeHook(target, function(a, b, ...)
local r = orig(a, b, ...)
if not F.CMX_DebugMaskOn then return r end
if F.CMX_IsCaller() then return r end
if type(r) == "table" then
local src = r.source
if type(src) == "string" and (src:find("CheatMenu", 1, true)
or src:find("PlayerScripts/", 1, true) == nil and src:sub(1, 1) == "=") then
pcall(function()
r.source = F.CMX_FakeSrc
r.short_src = "ControlModule"
r.what = "Lua"
end)
F.CMX_DebugMaskCount = (F.CMX_DebugMaskCount or 0) + 1
elseif F.CMX_IsOursFn(a) then
pcall(function()
r.source = F.CMX_FakeSrc
r.short_src = "ControlModule"
r.what = "Lua"
end)
F.CMX_DebugMaskCount = (F.CMX_DebugMaskCount or 0) + 1
end
end
return r
end)
if not orig then
T.CMX_DebugMask = false
F.Out("[绕过·栈取证伪装] 钩不上 debug.info ⇒ 该层不可用")
return false
end
F.CMX_DebugMaskOrig = orig
F.CMX_DebugMaskTarget = target
F.CMX_DebugMaskOn = true
F.CMX_DebugMaskCount = 0
F.Out("[绕过·栈取证伪装] 已开: 反作弊用 debug.info/getinfo 做栈取证时, 我们的代码会显示成 "
.. F.CMX_FakeSrc .. " · 我们自己查栈拿到的仍是真信息")
return true
end
F.CMX_DebugMaskDisable = function()
if not F.CMX_DebugMaskOn then return end
F.CMX_DebugMaskOn = false
if F.CMX_DebugMaskTarget and F.CMX_DebugMaskOrig then
pcall(function() hookfunction(F.CMX_DebugMaskTarget, F.CMX_DebugMaskOrig) end)
end
F.CMX_DebugMaskTarget, F.CMX_DebugMaskOrig = nil, nil
F.Out("[绕过·栈取证伪装] 已关 · 本次伪装 " .. tostring(F.CMX_DebugMaskCount or 0) .. " 次查询")
end
F.CMX_RequireBlockEnable = function()
if F.CMX_RequireOn then return false end
if type(require) ~= "function" then return false end
F.CMX_RequireKeys = F.CMX_RequireKeys or {
"anticheat", "anti-cheat", "antiexploit", "anti-exploit", "antihack", "anti-hack",
"cheatdetector", "detection", "detector", "integrity", "checksum", "watchdog",
"sentinel", "serverguard", "clientguard", "banmodule", "kickmodule",
}
local orig
orig = F.CMX_SafeHook(require, function(mod, ...)
if F.CMX_RequireOn and not F.CMX_IsCaller() then
local nm = nil
pcall(function() nm = tostring(mod) end)
if type(nm) == "string" then
local low = nm:lower()
for i = 1, #F.CMX_RequireKeys do
if low:find(F.CMX_RequireKeys[i], 1, true) then
F.CMX_ReqBlocked = (F.CMX_ReqBlocked or 0) + 1
local now = os.clock()
if now - (F.CMX_ReqLogAt or 0) > 3 then
F.CMX_ReqLogAt = now
F.Out("[绕过·模块拦截] 已拦下可疑模块加载: " .. nm:sub(1, 70)
.. " (累计 " .. tostring(F.CMX_ReqBlocked) .. " 次)")
end
return setmetatable({}, { __index = function() return function() end end })
end
end
end
end
return orig(mod, ...)
end)
if not orig then
T.CMX_RequireBlock = false
F.Out("[绕过·模块拦截] 钩不上 require ⇒ 该层不可用")
return false
end
F.CMX_RequireOrig = orig
F.CMX_RequireOn = true
F.CMX_ReqBlocked = 0
F.Out("[绕过·模块拦截] 已开: 名字里带 anticheat/detector/integrity/checksum 之类的模块会被拦下并返回空模块"
.. " · 我们自己的 require 不受影响")
return true
end
F.CMX_RequireBlockDisable = function()
if not F.CMX_RequireOn then return end
F.CMX_RequireOn = false
if F.CMX_RequireOrig then pcall(function() hookfunction(require, F.CMX_RequireOrig) end) end
F.CMX_RequireOrig = nil
F.Out("[绕过·模块拦截] 已关(已还原 require) · 本次拦下 " .. tostring(F.CMX_ReqBlocked or 0) .. " 个")
end
F.CMX_ClockMaskEnable = function()
if F.CMX_ClockOn then return false end
local q = tonumber(C.CMX_ClockStep) or 0.1
F.CMX_ClockStepVal = q
if type(os) ~= "table" or type(os.clock) ~= "function" then return false end
local orig
orig = F.CMX_SafeHook(os.clock, function(...)
local v = orig(...)
if not F.CMX_ClockOn then return v end
if F.CMX_IsCaller() then return v end
if type(v) ~= "number" then return v end
F.CMX_ClockMaskCount = (F.CMX_ClockMaskCount or 0) + 1
return math.floor(v / F.CMX_ClockStepVal) * F.CMX_ClockStepVal
end)
if not orig then
T.CMX_ClockMask = false
F.Out("[绕过·时钟粗化] 钩不上 os.clock ⇒ 该层不可用")
return false
end
F.CMX_ClockOrig = orig
F.CMX_ClockOn = true
F.CMX_ClockMaskCount = 0
F.Out("[绕过·时钟粗化] 已开: 别人用 os.clock 量时间只能拿到 " .. tostring(q)
.. " 秒的整数倍(量不出我们 10ms 级的动作节奏) · 我们自己量时间仍是精确的")
return true
end
F.CMX_ClockMaskDisable = function()
if not F.CMX_ClockOn then return end
F.CMX_ClockOn = false
if F.CMX_ClockOrig then pcall(function() hookfunction(os.clock, F.CMX_ClockOrig) end) end
F.CMX_ClockOrig = nil
F.Out("[绕过·时钟粗化] 已关 · 本次粗化 " .. tostring(F.CMX_ClockMaskCount or 0) .. " 次取时")
end
F.CMX_AimLead = function(part, cam)
local pos = part.Position
local v = nil
pcall(function() v = part.AssemblyLinearVelocity end)
if typeof(v) ~= "Vector3" then pcall(function() v = part.Velocity end) end
if typeof(v) ~= "Vector3" or v.Magnitude < 0.5 then return pos end
local speed = tonumber(C.CMX_ProjSpeed) or 300
if speed <= 1 then return pos end
local origin = cam.CFrame.Position
local t = (pos - origin).Magnitude / speed
for _ = 1, 3 do
t = ((pos + v * t) - origin).Magnitude / speed
end
if t > 1.5 then t = 1.5 end
local lead = pos + v * t
if C.CMX_ProjDrop then
local g = 196.2
pcall(function() g = workspace.Gravity end)
lead = lead + Vector3.new(0, 0.5 * g * t * t, 0)
end
F.CMX_LeadT = t
return lead
end
F.CMX_TierLevel = function(v)
local t = tostring(v or "")
if t:find("④", 1, true) then return 4 end
if t:find("③", 1, true) then return 3 end
if t:find("②", 1, true) then return 2 end
return 1
end
F.CMX_TierMap = {
CMX_AutoScrub = { F.CMX_AutoScrubEnable, F.CMX_AutoScrubDisable },
CMX_SpoofIndex = { F.CMX_SpoofIndexEnable, F.CMX_SpoofIndexDisable },
CMX_ViewFilter = { F.CMX_ViewFilterEnable, F.CMX_ViewFilterDisable },
CMX_HookHard = { F.CMX_HookHardApply, F.CMX_HookHardRestore },
CMX_RequireBlock = { F.CMX_RequireBlockEnable, F.CMX_RequireBlockDisable },
CMX_ClockMask = { F.CMX_ClockMaskEnable, F.CMX_ClockMaskDisable },
CMX_InstNew = { F.CMX_InstNewEnable, F.CMX_InstNewDisable },
CMX_DebugMask = { F.CMX_DebugMaskEnable, F.CMX_DebugMaskDisable },
CMX_IdentityMask = { F.CMX_IdentityMaskEnable, F.CMX_IdentityMaskDisable },
CMX_FFlagPack = { F.CMX_FFlagApplyPack, F.CMX_FFlagRestore },
CMX_BlockReport = { F.CMX_BlockReportEnable, F.CMX_BlockReportDisable },
CMX_CutLog = { F.CMX_CutLogEnable, F.CMX_CutLogDisable },
CMX_NeuterPlus = { F.CMX_NeuterPlusEnable, F.CMX_NeuterPlusDisable },
CMX_HashFreeze = { F.CMX_HashFreezeEnable, F.CMX_HashFreezeDisable },
}
F.CMX_TierOwn = F.CMX_TierOwn or {}
F.CMX_TierSync = function(level)
F.Out("[档位·绕过层] 已停用联动(时钟粗化/视图过滤/调试名伪装/属性伪装这些每帧加一层, 单局实测 75 万次取时+15 万次遍历 ⇒ 只降性能不办事)。要哪一层请单独手动开")
do return end
local map = F.CMX_TierMap
if type(map) ~= "table" then return end
if T.CMX_TierLink == false then
F.Out("[档位·绕过层] 你关掉了「档位联动绕过层」⇒ 档位只管原有的防护, 绕过层保持你的手动设置")
return
end
local lv = tonumber(level) or 1
local want = {}
if lv >= 2 then
want.CMX_AutoScrub, want.CMX_SpoofIndex, want.CMX_ViewFilter = true, true, true
end
if lv >= 2 then
want.CMX_BlockReport = true
want.CMX_ClockMask, want.CMX_DebugMask, want.CMX_InstNew = true, true, true
end
if lv >= 3 then
want.CMX_HookHard, want.CMX_RequireBlock = true, true
want.CMX_CutLog, want.CMX_NeuterPlus, want.CMX_HashFreeze = true, true, true
end
if lv >= 4 then
want.CMX_InstNew, want.CMX_DebugMask = true, true
want.CMX_IdentityMask, want.CMX_FFlagPack = true, true
end
local on, off = 0, 0
for key, pair in pairs(map) do
if want[key] then
if not T[key] then
T[key] = true
F.CMX_TierOwn[key] = true
pcall(pair[1])
on = on + 1
end
else
if F.CMX_TierOwn[key] and T[key] then
T[key] = false
F.CMX_TierOwn[key] = nil
pcall(pair[2])
off = off + 1
end
end
end
if on > 0 or off > 0 then
F.Out("[档位·绕过层] 档位 " .. tostring(lv) .. " ⇒ 绕过层 开 " .. tostring(on)
.. " 层 / 关 " .. tostring(off) .. " 层(只动档位带起来的那些, 你手动开的不受影响)")
end
end
F.CMX_PLACEMAP_RAW = "107778070777162=Steal An Egg|124216119978534=[⌛] Ride A Pet|109983668079237=[🥚] Steal a Brainrot|121864768012064=[👾UPD] Fish It! 🐟|113290951185459=[⚙️UPD 6] Anime Dice|16732694052=Fisch 🐟 [RACING]|114326934417838=Break and Steal an Egg|77108422251420=[SKINS 🐮] Search For The Needl|15532962292=Sol's RNG [ Summer Event 🏖️]|6961824067=Fling Things and People|104320321984431=Paint to Get Rich 🎨|123720558354386=Build the Pyramid!|8737899170=⛏️ [MINE] Pet Simulator 99! 🌌|71704434889758=(BETA) Drive A Kukirin!|3351674303=Driving Empire [2X CASH]|1537690962=Bee Swarm Simulator|76841016201110=💭Dream Car Collection [LUCK EV|105011592530400=Build and Kill Zombies|111543903102439=+1 Stone Skipping|79480724066456=[🛥️Boats🛥️] Southern Mudding 🚜|122245938604556=[🔮UPDATE!] +1 Tongue Escape 😛|87740422849523=Steal A Car|78490532994307=Build An Ant Empire|537413528=Build A Boat For Treasure|80242821185181=+1 Wings For Eggs|89469502395769=[🍭] Kick a Lucky Block|126884695634066=[🐿️] Grow a Garden 🌶️|98610101874791=+1 Strength for Eggs|122278212262864=Race for Eggs|98800969324557=[⛏️] Storage Hunters: Open Wor|109928390521457=Anime Breaker [🛠️CRAFT]|120475074479690=[😇] Steal From The Rich!|107164765081465=[BOSS] Steal A Verity!|132767904294856=[⚽] Blue Lock Farm|137228775845999=Ghost Driver [ALPHA]|102072869879193=[GUILDS] Anime Astral Simulato|119048529960596=[🛵] Restaurant Tycoon 3|114697347887839=🐒 +1 Speed Monkey Escape|4639625707=War Tycoon|13822889=🌳 Lumber Tycoon 2|76943966208523=Clone to Steal Eggs|7305309231=Taxi Boss 🚖|103429966174263=+1 Paint Keyboard Adventure|82081400078378=Steal ASMR!|138686218420016=[🗻] Mine Antarctica|74629631798007=[🎣UPD!] Pets Universe! 🐾|131346454575416=[💥] Mini War|128784467030899=[UPD☢️] Merge a Nuke!|88047783411976=Open Sea For Animals!|70906625936847=Gym Star Simulator 🏋️|95409544559668=Military Army Tycoon|77843161404023=Run a Restaurant!|92648272637932=[W3] +1 Mog Evolution|99679692310083=Steal Animal Egg|121831322352666=Dig For Eggs|4924922222=Brookhaven 🏡RP|920587237=[24H🎃] Adopt Me!|15101393044=Dress To Impress ⭐|13967668166=LifeTogether 🏠 RP|8481844229=Berry Avenue 🏠 RP|5233782396=✨ Creatures of Sonaria 📜 Survi|74395953411817=Dreamville 🏡 RP [Multiple Kids|122485613019196=Dubai 🏡 RP [Multiple Kids! 👶]|185655149=[🍂] Welcome to Bloxburg|7711635737=Emergency Hamburg|136020512003847=San Diego Roleplay|5289509545=Gacha Online ✨ RP|12985361032=Metro Life 🏡 City RP|97577741629233=⭐Catalog Avatar Runway|735030788=Royale🎃High|2534724415=[🗺️] Emergency Response: Liber|16625391970=NewSmith 🏡 RP|6989310863=Wild Horse Islands|8704997000=[🧪] Maple Hospital 🍂|3663340706=Warrior Cats: Ultimate Edition|891852901=Greenville RP (⭐AUDI + SHELBY |1365404657=Feather Family 🎃 [Burrowing Ow|192800=🍕Work at a Pizza Place|135717153770519=Toilet World Roleplay 2|15768329004=IT GIRL 🏝️|6698800091=[MOBILE!📱]Prior Extinction - D|96796259580891=Kingdom World|18753889337=Main Street 🏡RP|106568491289620=[将] Shogun's Reign|18214855317=Savannah Life|12716055617=Emergency Emden|17192092512=Deermont 🏡RP|71599043035739=SCP MORPH|3457390032=Club Roblox RP 💗 [👶 NEEDS]|8369888266=Redcliff City 🏡RP|6737970321=Livetopia 🏡 RP|5712833750=Animal Simulator|6377740507=[Stickers] Miraculous™ RP: Lad|5593925613=Countryball World 🌎|135571353544108=Love Letter: Roleplay ( YANWEE|104841616983113=San Aurie|13473615074=Boxywood 🏠🌴 RP|11862502039=Seaside RP🏡🌴 City RP|112333343527957=Highschool Experience RP|15182389440=[ 🍂 🏍️ 🎣 BikeLife ] Northline |71174733280934=Palmhaven City Life RP🏡|16962279458=☀️ KOYA DANCE STUDIO|18537079992=Армия Роблокса РП|5041144419=SCP: Roleplay|75178747054941=LCS: EQuest|79886695267825=Steal The Show! 🎤⭐|3631820248=[🎉6th Anniversary!] Stevos Gem|81223687051453=PRISON RP|373513488=FNAF RP - TPRR [🐻FB3 EVENT📺]|118447215156914=Prism Runway Show💎|102917792916356=Apocalyptic Titans Roleplay|142823291=Murder Mystery 2|79546208627805=99 Nights in the Forest 🔦|18687417158=[✨BONUS] Forsaken|93978595733734=[CURE] Violence District|78515283254292=Animal Hospital (Anomaly) 🧪|9872472334=Evade|4623386862=Piggy [SEASON 9 - FRIGHT NIGHT|893973440=Flee the Facility|116802325837172=7 Days Cat-Sitting|70411440483149=100 Days At Sea|124061247871628=Animal Daycare (Anomaly)|2768379856=3008 [2.75]|113481077323469=Scream And Run|70923197964305=⚔️ Killer's Arena|115668616082195=WHO FARTED?|85967844112283=Last Stop [Beta]|117713779364528=Lethal Ape Experience|78453398695059=THRESHOLD [HORROR] [UPD 1.5]|92122513197996=⛏️Dig to Escape|189707=Natural Disaster Survival|82591391194183=MM2 of The Locust|97793725257596=MMZ👽|90148635862803=[UPD] 🧟 Survive the Apocalypse|139020444733179=Survive Deep in the Woods|82457571485380=Zombie Rush Survival 🧟‍♂️|96168869671905=💎 ROB IT|6205205961=Escape Running Head|121165298854655=[CREATURE] DON'T LET HIM IN|14608970270=(ANNIVERSARY) Outcome Memories|15318113891=Lethal Ape|140553375004913=this underrated game (flamingo|137826330724902=Scary Shawarma Kiosk: the ANOM|129626004396080=just a sniper game|127877871885165=he ate them. [HORROR]|114204398207377=[FACTIONS] Survive Zombie Aren|18666738837=Death Order: Simon Says|128263975853774=🛠️Build and Survive|12931609417=Color or Die 🎨|127380660530951=Survive Overnight in a Mega St|87468080405188=[UPDATE] Home Alone: Anomalies|18199615050=[UPD] Demonology🕯️|7336302630=Project Delta|135889880932940=Survive 7 Days In Desert 🌵|120951586797306=🙈 Killer or Innocent|100227226022278=Survive The Swarm[2x loot]|6382584061=Build to Survive 🛠️|98894876188248=Cheating During Testing [BETA]|116070952245255=[💪] Build Base to Survive VERI|123393202531499=Build and Hide to Survive VERI|4580204640=🔪Survive the Killer!|74716719697996=[⏰SOON]🚪Survive Verity in Area|109423220190564=[UPDATE] Backrooms Company|82531308645115=Plunder [UPD]|124338404742585=Keep the Door Locked🔒|5118969548=Spider|108645230905176=Mrbeast Island Escape|119004860768199=[UPD]BreakDoor|2753915549=Blox Fruits|16205713724=Slayers 2|1730877806=[🍬HALLOWEEN PT 1] Grand Piece |13379208636=Attack on Titan Revolution|2809202155=[CDR & DD] Your Bizarre Advent|77649408247578=[2X LUCK] Dungeon Quest Reborn|111097829542198=[🦋] Legacy Piece|128451689942376=[🎞️ PROJECTION] Jujutsu: Zero|4520749081=King Legacy|117533937949084=Iron Soul: Dungeon|104761395312874=[🐲Goku & Castorice🟣] Lineage P|114574503491412=Anime Zero [RELEASE] 🎉|4616652839=Shindo Life [250]|90860390610142=Clover Legends|106484206883664=⚔️ Dungeon Lootr|4111023553=Deepwoken|80734098185936=An Average Campaign [Alpha v0.|18172550962=[CLASSES] Pixel Blade|8075399143=[✨Ashura Update] Ninja Time|9096881148=Peroxide [Update!]|93934100402512=Clover Time [BETA RELEASE]|71315343=[PARASITE 🌀] Dragon Ball Rage|125503525638054=The Veil|5571328985=[🐢] Bloodlines|2727067538=World // Zero ⚔️ Anime RPG|120704669141193=[V13] Blox Loot|140409475718339=[YUTA!] Anime Apocalypse|10260193230=[UPDATE 4] Meme Sea|10450270085=[⚖️JUDGEMAN] Jujutsu Infinite|5130598377=A Universal Time|119091355492870=[UPDATE 1.75]Rock Fruit|6918802270=Haze Seas|11729688377=Booga Booga [QUESTS! 📜]|10912405603=[3 YEARS!] Clover Retribution|15014439457=Demon Blade|3177438863=[🎃EVENT] Dragon Blox|122003435349029=The Portal [MMORPG]|10595058975=[Withered Grove 🧿] Arcane Line|3016661674=Rogue Lineage|14067600077=TYPE://SOUL|6728870912=World of Stands|5116869569=🌴 Doodle World! [BEACH EVENT]|139150436440482=[⚔️COMBAT] Ninja: Legacy [RP]|914010731=Ro-Ghoul [ALPHA]|116276659864007=Project Mirror Labyrinth|6938803436=[⭐2X] Anime Dimensions Simulat|6298464951=Roblox Is Unbreakable|102829972707814=civilization survival game|132044122002338=[Update 11 🔥] Chaos Fruits|118582391303761=UNTITLED RPG GAME|114581778828030=Soul RPG|100283815455755=Vagrant Survival [0.9]|15167153398=✨Someday City 2.0 ✨|5870869755=HEROES: Infinite 2|18923620224=[🗼 UPDATE 5.0] Anime Warriors |1087852616=CATASTROPHIA ☢️ Survive ☢️|134931730875913=[BETA] Crazy Odyssey: A New Jo|4622037906=Sans Fight Simulator|17625359962=RIVALS|112731528776884=KNIFE DUELS|90568084448279=[FPS] One Tap|122446657157717=[🔥NEW SNIPER] Sniper Arena|13687899540=Cold War [VIETNAM]|120851538706364=Murder Duels|114234929420007=BloxStrike|84556640895285=Deagle Arena|12334109280=Guts & Blackpowder|113506071094099=[🌴] SHARP|10165583746=Examination|93091759101123=FPS🔥AirDrop Arena [S5]🔥|72920620366355=[SEASON 3] Operation One|79393329652220=[🧤] Defusal|130404059693601=Strike: Warfare|3678761576=[🗣️CALLOUT🗣️] ENTRENCHED 🥀|120189115846709=TTK Testing [CUSTOMIZATION]|129253568870286=Bonk & Block [5v5]|102871156420149=The Lost Front|109397169461300=SNIPER DUELS|21532277=Notoriety: A PAYDAY® Experienc|118367369949006=Ground War|13955927965=Blood Zone 🎃|90184287580174=(SEASON 2) KILLSTREAK|286090429=Arsenal|136801880565837=[FPS] Flick|18259975825=Grave/Digger|13429790955=📚 Murderers vs Sheriffs 2|123873483242204=Anime Finals|3891618314=⚓ Harbor Havoc|119214646022567=Top sniper [5.0]|5286116071=Hunting Season [BETA]|15694891095=[CLANS] Combat Arena|94590879393563=Weird Gun Game [UPDATE!]|301549746=Counter Blox|130490210702949=Blood Debt Gun System|99342262733194=[SUMMER] Randomizer: Redux|14313259147=FORTLINE|104856666707760=Killstreak Battle Royale|3214114884=[💰2x] Flag Wars!|99001115434148=Fluxo PVP [MATCHMAKING]|94987506187454=[🤝 TRADING] REDLINER|115286378269814=Protect The House From Monster|13438553315=Decaying Winter|4991214437=town|13794093709=SCORCHED EARTH 🔊|106605940421527=BetterEH|443406476=Project Lazarus: 💀 ZOMBIES 💀|14518422161=Gunfight Arena|2778230703=Reminiscence Zombies|112757576021097=Defuse Division|111267397030523=CQB Hell [NEW MODES]|328028363=Typical Colors 2|71607575632633=[🎃] Zone Defense RNG|131558436575033=[REALISTIC] SevenM Hood Testin|9391468976=[SKY ASSASSIN] Jujutsu Shenani|10449761463=The Strongest Battlegrounds|135856908115931=[🌌DUELS] Murderers VS Sheriffs|13772394625=Blade Ball|104715542330896=BlockSpin 🔪 [WEATHER]|6872265039=BedWars [🎣RERELEASE🪤]|101770480176177=[X2 XP] Command An Army|1458767429=ABA|120700541929930=Knife VS Gun DUELS|127403135954624=[ Halloween ] Kaiju Alpha|118418618261207=RUNAWAYS [beta]|108567435288296=Anime Ability Arena|72105128013629=Kidnap And Jail|6403373529=[UPDATE🏴‍☠️] Slap Battles👏|110175021189594=Ability Arena 💥|94217045453265=Dueling Grounds ⚔️|606849621=Jailbreak|13621938427=[DEIMOS👹] untitled boxing game|128119795963270=Murder Mystery DUELS"
F.CMX_PlaceMap = nil
F.CMX_GameName = function()
local pid = tostring(game.PlaceId or "")
if not F.CMX_PlaceMap then
F.CMX_PlaceMap = {}
for seg in string.gmatch(F.CMX_PLACEMAP_RAW or "", "([^|]+)") do
local k, v = seg:match("^(%d+)=(.*)$")
if k then F.CMX_PlaceMap[k] = v end
end
end
return F.CMX_PlaceMap[pid], pid
end
F.CMX_GameLabel = function()
local nm, pid = F.CMX_GameName()
if nm then return nm .. "  (PlaceId " .. pid .. ")" end
return "未知游戏  (PlaceId " .. pid .. " / GameId " .. tostring(game.GameId or "?") .. ")"
end
F.CMX_ProfileGet = function()
local _, pid = F.CMX_GameName()
if not pid or pid == "" then return nil end
C.CMX_GameProfiles = C.CMX_GameProfiles or {}
return C.CMX_GameProfiles[pid]
end
F.CMX_ProfilePut = function(field, value)
local _, pid = F.CMX_GameName()
if not pid or pid == "" or value == nil then return end
C.CMX_GameProfiles = C.CMX_GameProfiles or {}
local p = C.CMX_GameProfiles[pid]
if not p then p = {} C.CMX_GameProfiles[pid] = p end
p[field] = value
end
F.CMX_ProfileApply = function()
F.Out("[游戏档案] 当前游戏: " .. F.CMX_GameLabel())
local p = F.CMX_ProfileGet()
if not p then
F.Out("[游戏档案] 这个游戏还没档案 ⇒ 你在本局调好的 档位/飞行通道/加速通道/传送方式 会被记住, 下次可用「套用本游戏上次的设置」按钮一键套回")
return
end
local n = 0
if p.tier and T.BypassTier ~= p.tier then
T.BypassTier = p.tier
pcall(F.BypassTierApply, p.tier)
n = n + 1
end
if p.fly and C.FlyDrive ~= p.fly then
C.FlyDrive = p.fly
n = n + 1
if T.FlyOn then pcall(function() F.FlySet(true) end) end
end
if p.speed and C.SpeedDrive ~= p.speed then
C.SpeedDrive = p.speed
n = n + 1
if T.SpeedOn then pcall(function() F.SpeedSet(true) end) end
end
if p.tpstep and C.TPStep ~= p.tpstep then C.TPStep = p.tpstep n = n + 1 end
if p.flydrive_pos ~= nil and T.CMX_SpoofPos ~= p.flydrive_pos then T.CMX_SpoofPos = p.flydrive_pos n = n + 1 end
if n > 0 then F.Out("[游戏档案] 已套用本游戏专属设置 " .. tostring(n) .. " 项(档位/通道)") end
end
F.CMX_ScanDetectors = function()
F.Out("[扫描·检测器] ===== 名字像检测器的对象 / 脚本 =====")
local keys = {}
pcall(function()
local all = F.CMX_AllDetectKeys and F.CMX_AllDetectKeys()
if type(all) == "table" then keys = all end
end)
if #keys == 0 then
keys = { "detector", "anticheat", "anti-cheat", "antiexploit", "anti-exploit", "antihack",
"integrity", "checksum", "watchdog", "sentinel", "clientcheck", "positioncheck",
"speedcheck", "flycheck", "bancheck", "flagged", "moderation", "exploitlog" }
end
local n = 0
local function sweep(root, label)
if not root then return end
local cnt = 0
pcall(function()
for _, d in ipairs(root:GetDescendants()) do
cnt = cnt + 1
if cnt > 8000 then break end
local nm = nil
pcall(function() nm = d.Name end)
if type(nm) == "string" then
local low = nm:lower()
for i = 1, #keys do
if low:find(keys[i], 1, true) then
n = n + 1
if n <= 30 then
F.Out(string.format("[扫描·检测器]   %-14s %-16s %s", label, tostring(d.ClassName), nm))
end
break
end
end
end
end
end)
end
sweep(workspace, "workspace")
pcall(function() sweep(LP:FindFirstChild("PlayerScripts"), "PlayerScripts") end)
pcall(function() sweep(game:GetService("ReplicatedStorage"), "ReplicatedStorage") end)
pcall(function() sweep(game:GetService("ReplicatedFirst"), "ReplicatedFirst") end)
F.Out("[扫描·检测器] 共命中 " .. tostring(n) .. " 个(名字像检测器的对象)")
return n
end
F.CMX_RestoreRO = function(force)
if not F._roUnlocked then return false end
if not force then
for _, bucket in pairs(F.MetaLayers or {}) do
for _, rec in pairs(bucket) do
if rec and rec.alive then return false end
end
end
if KG and (KG.mtHooked or KG.hooked) then return false end
if F.CMX_SpoofOn or F.CMX_ViewOn or F.CMX_InstNewOn then return false end
end
local done = false
pcall(function()
local mt = getrawmetatable and getrawmetatable(game)
if type(mt) == "table" and type(setreadonly) == "function" then
setreadonly(mt, true)
if type(isreadonly) == "function" and isreadonly(mt) then
done = true
F._roUnlocked = false
end
end
end)
if done then
F.Out("[绕过·元表] 已把 game 元表恢复只读 —— 反作弊用 isreadonly 检查时看不出我们解锁过")
end
return done
end
F.CMX_BAN_KEYS = {
"antikick", "anti-kick", "kick", "ban", "banplayer", "report", "reportban",
"hash", "hashcheck", "exploit", "iy", "submit", "flag", "flagged",
"logdetect", "logban", "punish", "detect", "detectionreport", "moderation",
}
F.CMX_KeyIsolate = function(low, key)
local s, e = low:find(key, 1, true)
if not s then return false end
if #key > 4 then return true end
local b = (s > 1) and low:sub(s - 1, s - 1) or ""
local a = low:sub(e + 1, e + 1)
local function alpha(ch) return ch ~= "" and ch:match("%a") ~= nil end
return not (alpha(b) or alpha(a))
end
F.CMX_ReportKeyHit = function(name)
if type(name) ~= "string" then return nil end
local low = name:lower()
local L = AC.BLOCK_KEYS
if type(L) == "table" then
for i = 1, #L do if F.CMX_KeyIsolate(low, L[i]) then return L[i] end end
end
L = F.CMX_BAN_KEYS
for i = 1, #L do if F.CMX_KeyIsolate(low, L[i]) then return L[i] end end
return nil
end
F.CMX_ScanReportRemotes = function(quiet)
local out, n = {}, 0
local RS2 = game:GetService("ReplicatedStorage")
pcall(function()
for _, d in ipairs(RS2:GetDescendants()) do
n = n + 1
if n > 8000 then break end
local cls = nil
pcall(function() cls = d.ClassName end)
if cls == "RemoteEvent" or cls == "UnreliableRemoteEvent" or cls == "RemoteFunction" then
local hit = F.CMX_ReportKeyHit(d.Name)
if hit then out[#out + 1] = { inst = d, key = hit } end
end
end
end)
if not quiet then
F.Out("[反封禁·上报] ReplicatedStorage 里命中黑名单的远程: " .. tostring(#out) .. " 个")
for i = 1, math.min(#out, 20) do
F.Out("[反封禁·上报]   " .. tostring(out[i].inst.ClassName) .. "  " .. tostring(out[i].inst.Name)
.. "  ← 关键词 " .. out[i].key)
end
end
return out
end
F.CMX_BlockReportEnable = function()
if F.CMX_BanKeysMerged then return true end
F.CMX_BanKeysMerged = true
local all, per = nil, nil
pcall(function() all, per = F.CMX_AllDetectKeys() end)
local extra = {}
if type(all) == "table" then for i = 1, #all do extra[#extra + 1] = all[i] end end
if type(per) == "table" and #per > 0 then
F.Out("[反封禁·上报] 本游戏检测档案命中 " .. tostring(#per) .. " 个命名, 已并入拦截名单:")
for i = 1, math.min(#per, 12) do F.Out("[反封禁·上报]   · " .. tostring(per[i])) end
end
local banAdded = {}
for i = 1, #extra do
local dup = false
for j = 1, #F.CMX_BAN_KEYS do if F.CMX_BAN_KEYS[j] == extra[i] then dup = true break end end
if not dup then
F.CMX_BAN_KEYS[#F.CMX_BAN_KEYS + 1] = extra[i]
banAdded[#banAdded + 1] = extra[i]
end
end
F.CMX_BanKeysAdded = banAdded
local found = F.CMX_ScanReportRemotes(false)
if type(AC.BLOCK_KEYS) == "table" then
local ex = {}
for _, k in ipairs(AC.BLOCK_KEYS) do ex[k] = true end
local add = 0
for i = 1, #F.CMX_BAN_KEYS do
if not ex[F.CMX_BAN_KEYS[i]] then
AC.BLOCK_KEYS[#AC.BLOCK_KEYS + 1] = F.CMX_BAN_KEYS[i]
add = add + 1
end
end
if add > 0 then F.Out("[反封禁·上报] 黑名单已扩充 " .. tostring(add) .. " 个关键词") end
end
pcall(F.MetaHookEnsure)
pcall(AC.InstallNamecallHook)
T.RemoteBlock = true
F.Out("[反封禁·上报] 已开: 反作弊想 FireServer 上报时, 只要远程名字命中黑名单就会被拦下"
.. " · 名字里带 antikick/kick/ban/report/hash/flag/punish/detect 的一律进不去服务器")
return true
end
F.CMX_BlockReportDisable = function()
if not F.CMX_BanKeysMerged then return end
F.CMX_BanKeysMerged = false
if type(F.CMX_BanKeysAdded) == "table" then
for i = 1, #F.CMX_BanKeysAdded do
local k = F.CMX_BanKeysAdded[i]
if type(F.CMX_BAN_KEYS) == "table" then
for j = #F.CMX_BAN_KEYS, 1, -1 do
if F.CMX_BAN_KEYS[j] == k then table.remove(F.CMX_BAN_KEYS, j) break end
end
end
end
if type(AC.BLOCK_KEYS) == "table" then
local added = {}
for _, k in ipairs(F.CMX_BanKeysAdded) do added[k] = true end
for i = #AC.BLOCK_KEYS, 1, -1 do
if added[AC.BLOCK_KEYS[i]] then table.remove(AC.BLOCK_KEYS, i) end
end
end
F.CMX_BanKeysAdded = nil
end
F.Out("[反封禁·上报] 已关(黑名单还原)")
end
F.CMX_CutLogEnable = function()
if F.CMX_CutLogOn then return false end
if type(getconnections) ~= "function" then
T.CMX_CutLog = false
F.Out("[反封禁·断日志] 本执行器没有 getconnections ⇒ 该层不可用")
return false
end
local sigs = {}
pcall(function() sigs[#sigs + 1] = { "ScriptContext.Error", game:GetService("ScriptContext").Error } end)
pcall(function() sigs[#sigs + 1] = { "LogService.MessageOut", game:GetService("LogService").MessageOut } end)
local n, kept = 0, 0
F.CMX_CutLogSaved = {}
for i = 1, #sigs do
pcall(function()
for _, c in ipairs(getconnections(sigs[i][2])) do
local fn = nil
pcall(function() fn = c.Function end)
if fn == nil then pcall(function() fn = c.__function end) end
local mine = false
pcall(function() mine = (F.CMX_Own[fn] == true) end)
if mine then
kept = kept + 1
else
local was = nil
pcall(function() was = c.Enabled end)
F.CMX_CutLogSaved[#F.CMX_CutLogSaved + 1] = { c = c, was = was, n = sigs[i][1] }
pcall(function() c:Disable() end)
n = n + 1
end
end
end)
end
F.CMX_CutLogOn = true
F.Out("[反封禁·断日志] 已断 " .. tostring(n) .. " 条错误/日志通道(保留我们自己的 " .. tostring(kept)
.. " 条) —— 反作弊靠 ScriptContext.Error 抓我们脚本的报错再上报, 这条直接掐掉")
return true
end
F.CMX_CutLogDisable = function()
if not F.CMX_CutLogOn then return end
F.CMX_CutLogOn = false
local n = 0
for i = 1, #(F.CMX_CutLogSaved or {}) do
local rec = F.CMX_CutLogSaved[i]
if rec.was ~= false then
pcall(function() rec.c:Enable() end)
n = n + 1
end
end
F.CMX_CutLogSaved = nil
F.Out("[反封禁·断日志] 已还原 " .. tostring(n) .. " 条通道")
end
F.CMX_NeuterPlusEnable = function()
if F.CMX_NPOn then return false end
if type(getgc) ~= "function" then
T.CMX_NeuterPlus = false
F.Out("[反封禁·按名中和+] 本执行器没有 getgc ⇒ 该层不可用")
return false
end
local NAMES = {
"ban", "banPlayer", "report", "reportPlayer", "flag", "flagPlayer", "submit", "submitReport",
"onDetect", "onFlag", "onBan", "logDetection", "logBan", "recordFlag",
"antiKick", "antikick", "kickPlayer", "punishPlayer", "detectPlayer", "sendBan", "sendReport",
}
pcall(function()
local all = F.CMX_AllDetectKeys and F.CMX_AllDetectKeys()
if type(all) == "table" then
for i = 1, #all do
local w = all[i]
if type(w) == "string" and #w >= 5 then NAMES[#NAMES + 1] = w end
end
end
end)
F.CMX_NPSaved = {}
local n, seen = 0, 0
pcall(function()
for _, v in pairs(getgc(true)) do
seen = seen + 1
if seen > 60000 then break end
if type(v) == "table" then
for i = 1, #NAMES do
local f = nil
pcall(function() f = rawget(v, NAMES[i]) end)
if type(f) == "function" then
F.CMX_NPSaved[#F.CMX_NPSaved + 1] = { t = v, k = NAMES[i], f = f }
pcall(function() v[NAMES[i]] = function() return end end)
n = n + 1
end
end
end
end
end)
F.CMX_NPOn = true
F.Out("[反封禁·按名中和+] 已扫 " .. tostring(seen) .. " 个表, 中和 " .. tostring(n)
.. " 个封禁/举报/标记类函数(ban/report/flag/onDetect/antiKick…) · 关闭时逐个还原")
return n > 0
end
F.CMX_NeuterPlusDisable = function()
if not F.CMX_NPOn then return end
F.CMX_NPOn = false
local n = 0
for i = 1, #(F.CMX_NPSaved or {}) do
local rec = F.CMX_NPSaved[i]
if rec and rec.t then
pcall(function() rec.t[rec.k] = rec.f end)
n = n + 1
end
end
F.CMX_NPSaved = nil
F.Out("[反封禁·按名中和+] 已还原 " .. tostring(n) .. " 个函数")
end
F.CMX_HashFreezeEnable = function()
if F.CMX_HashOn then return false end
if type(getgc) ~= "function" or type(hookfunction) ~= "function" then
T.CMX_HashFreeze = false
F.Out("[反封禁·哈希冻结] 需要 getgc + hookfunction ⇒ 该层不可用")
return false
end
F.CMX_HashSaved = {}
F.CMX_HashCache = {}
local props = 0
pcall(function()
for _, f in pairs(getgc(true)) do
props = props + 1
if props > 60000 then break end
if type(f) == "function" then
local okL, isl = pcall(function() return islclosure(f) end)
if okL and isl then
local src, nm = "", ""
pcall(function()
local si = debug.info(f, "sln")
src = tostring(si and si.source or "")
nm = tostring(si and si.name or "")
end)
local low = (src .. " " .. nm):lower()
if low:find("hash", 1, true) or low:find("digest", 1, true) or low:find("checksum", 1, true) then
F.CMX_HashSaved[#F.CMX_HashSaved + 1] = f
end
end
end
end
end)
local n = 0
for i = 1, #F.CMX_HashSaved do
local f = F.CMX_HashSaved[i]
local key = tostring(f)
local o
o = F.CMX_SafeHook(f, function(...)
if F.CMX_HashOn and F.CMX_HashCache[key] ~= nil then return F.CMX_HashCache[key] end
if type(o) ~= "function" then return nil end
local r = o(...)
if F.CMX_HashOn and type(r) == "string" and (#r == 32 or #r == 40 or #r == 64)
and r:match("^%x+$") then
F.CMX_HashCache[key] = r
F.CMX_HashFreezeHits = (F.CMX_HashFreezeHits or 0) + 1
end
return r
end)
if o then n = n + 1 end
end
F.CMX_HashOn = true
F.CMX_HashFreezeHits = 0
F.Out("[反封禁·哈希冻结] 找到 " .. tostring(#F.CMX_HashSaved) .. " 个名字像哈希的闭包;"
.. " 第一次算出的 32/40/64 位 hex 会被记住, 之后恒定返回同一个值 ⇒ 服务器看到客户端指纹一直没变")
return #F.CMX_HashSaved > 0
end
F.CMX_HashFreezeDisable = function()
if not F.CMX_HashOn then return end
F.CMX_HashOn = false
F.CMX_HashCache = {}
F.Out("[反封禁·哈希冻结] 已关 · 本次冻结命中 " .. tostring(F.CMX_HashFreezeHits or 0) .. " 次")
end
F.CMX_GAMEDETECT_RAW = "2753915549=blacklist,BlacklistTime,purgeBlacklist,HealthCheck,BlacklistedQuestIds,BANEXPLOIT,NOEXPLOIT,PositionChecker|6516141723=AnticheatDisabled,Exploits_Remove,ArchivesChairAC_LagbackConns,DistanceBlacklist,ArchivesChairAC_LagbackDisabled,Anti-Cheat Bypass,DisableAnticheat,Exploits_Audio,lagback,ArchivesChairAC_SetLagbackBlocked,ESPBlacklist,LagbackFixer|89469502395769=LAGBACK|94217045453265=reportedOrigin|292439477=RageBot_WallPenetrationDetection,Extras_HopOnVotekick,PenetrationDetection,startvotekick,undetected,Votekick,Wall Penetration Detection,Hop On Votekick|5130598377=hasReported,TeleportCheck|16279732176=hasReported,TeleportCheck"
F.CMX_GENKEYS = {
strong = { "anticheat", "anti-cheat", "antiexploit", "anti-exploit", "antihack", "anti-hack", "cheatdetect", "exploitdetect", "injected", "injection", "detected", "detection", "detector", "moderation", "honeypot", "canary", "integrity", "checksum", "watchdog", "sentinel", "guardian", "banplayer", "banhammer", "banned", "banlog", "punish", "blacklist", "votekick", "antikick", "anti-kick", "kickplayer", "flagplayer", "flagged", "flaglog", "reportplayer", "reportlog", "reported", "hashcheck", "clienthash", "fingerprint", "tokencheck", "purgeblacklist", "blacklisttime", "anticheatdisabled", "lagbackconns" },
move = { "speedcheck", "flycheck", "velocitycheck", "positioncheck", "movementcheck", "noclipcheck", "walkcheck", "teleportcheck", "distancecheck", "gravitycheck", "jumpcheck", "godcheck", "lagback", "rollback", "damper", "speeddetect", "flydetect", "antigravity", "nospeed", "nofly", "antiteleport", "anticlip" },
}
F.CMX_GameDetectMap = nil
F.CMX_GameDetectKeys = function()
local _, pid = F.CMX_GameName()
if not pid or pid == "" then return nil end
if not F.CMX_GameDetectMap then
F.CMX_GameDetectMap = {}
for seg in string.gmatch(F.CMX_GAMEDETECT_RAW or "", "([^|]+)") do
local k, v = seg:match("^(%d+)=(.*)$")
if k then
local list = {}
for w in string.gmatch(v, "([^,]+)") do
w = w:gsub("^%s+", ""):gsub("%s+$", "")
if w ~= "" then list[#list + 1] = w end
end
F.CMX_GameDetectMap[k] = list
end
end
end
return F.CMX_GameDetectMap[pid], pid
end
F.CMX_AllDetectKeys = function()
local out, seen = {}, {}
local function push(t)
if type(t) ~= "table" then return end
for i = 1, #t do
local w = t[i]
if type(w) == "string" and not seen[w] then
seen[w] = true
out[#out + 1] = w
end
end
end
push(F.CMX_GENKEYS and F.CMX_GENKEYS.strong)
push(F.CMX_GENKEYS and F.CMX_GENKEYS.move)
local per = F.CMX_GameDetectKeys()
push(per)
return out, per
end
F.CMX_ShowGameDetect = function()
F.Out("[检测档案] 当前游戏: " .. F.CMX_GameLabel())
local per, pid = F.CMX_GameDetectKeys()
if per and #per > 0 then
F.Out("[检测档案] 本游戏已知的检测命名(从公开脚本里挖出来的, " .. tostring(#per) .. " 个):")
for i = 1, #per do F.Out("[检测档案]   · " .. tostring(per[i])) end
else
F.Out("[检测档案] 这个游戏没有预置档案(公开脚本里没挖到它的检测命名)")
end
F.Out("[检测档案] 通用词库: 强命中 " .. tostring(#(F.CMX_GENKEYS and F.CMX_GENKEYS.strong or {}))
.. " 个 + 移动/加速/飞行专用 " .. tostring(#(F.CMX_GENKEYS and F.CMX_GENKEYS.move or {})) .. " 个")
end
F.CMX_BanAllApply = function(on)
local items = {
{ "CMX_BlockReport", F.CMX_BlockReportEnable, F.CMX_BlockReportDisable, "拦上报/封禁远程" },
{ "CMX_CutLog", F.CMX_CutLogEnable, F.CMX_CutLogDisable, "断错误/日志通道" },
{ "CMX_NeuterPlus", F.CMX_NeuterPlusEnable, F.CMX_NeuterPlusDisable, "按名中和+" },
{ "CMX_HashFreeze", F.CMX_HashFreezeEnable, F.CMX_HashFreezeDisable, "哈希冻结" },
}
local n = 0
for i = 1, #items do
local it = items[i]
T[it[1]] = on and true or false
if on then
if pcall(it[2]) then n = n + 1 end
else
pcall(it[3])
end
end
F.Out("[反封禁·全家桶] " .. (on and ("已开 " .. tostring(n) .. "/4 层: 拦上报 · 断日志 · 按名中和+ · 哈希冻结")
or "已关(四层全部还原)"))
return n
end
F.CMX_ScrubShapes = { { 19, 15, 2 }, { 19, 14, 2 }, { 12, 8, 2 }, { 8, 5, 2 }, { 7, 3, 2 } }
F.CMX_Remember = function(key, on)
if type(C.CMX_BypassOn) ~= "table" then C.CMX_BypassOn = {} end
local list = C.CMX_BypassOn
for i = #list, 1, -1 do
if tostring(list[i]) == tostring(key) then table.remove(list, i) end
end
if on then list[#list + 1] = tostring(key) end
end
F.CMX_AutoScrubEnable = function()
if F.CMX_AutoScrubOn then return false end
local good = nil
for i = 1, #F.CMX_ScrubShapes do
local sh = F.CMX_ScrubShapes[i]
local f = F.CMX_FindClosureFast(sh[1], sh[2])
if f then
local t = nil
pcall(function() t = debug.getupvalue(f, sh[3]) end)
if type(t) == "function" then good = { sh[1], sh[2], sh[3] } break end
end
end
if not good then
F.Out("[绕过·自动清洗] 常见形状全试完都没命中(执行器 getgc 受限?) ⇒ 改用「参数清洗钩子」手填形状")
return false
end
F.CMX_ShapeOverride = tostring(good[1]) .. "," .. tostring(good[2]) .. "," .. tostring(good[3])
F.CMX_AutoScrubOn = true
local ok = F.CMX_ArgScrubEnable()
if not ok then
F.CMX_AutoScrubOn = false
return false
end
F.Out("[绕过·自动清洗] 已开: 形状 " .. tostring(good[1]) .. "," .. tostring(good[2]) .. "," .. tostring(good[3])
.. " 的第 " .. tostring(good[3]) .. " 个 upvalue 已挂钩")
return true
end
F.CMX_AutoScrubDisable = function()
if not F.CMX_AutoScrubOn then return end
F.CMX_AutoScrubOn = false
pcall(F.CMX_ArgScrubDisable)
F.Out("[绕过·自动清洗] 已关")
end
F.CMX_HookHardApply = function()
local nl = F.CMX_G("newlclosure")
if type(nl) ~= "function" then
T.CMX_HookHard = false
F.Out("[绕过·钩子加固] 本执行器没有 newlclosure ⇒ 加固不可用, 其余绕过照常")
return false
end
T.CMX_HookHard = true
local n = 0
for slot, bucket in pairs(F.MetaLayers or {}) do
for id, rec in pairs(bucket) do
if rec and rec.alive and type(rec.raw) == "function" and rec.box then
local ok, w = pcall(nl, function(self, ...)
if not rec.alive then return rec.box.orig(self, ...) end
return rec.raw(self, ...)
end)
if ok and type(w) == "function" then
local ok2 = pcall(function() hookmetamethod(rec.target, slot, w) end)
if ok2 then rec.wrapper = w n = n + 1 end
end
end
end
end
F.Out("[绕过·钩子加固] 已把 " .. tostring(n) .. " 层元方法钩子重建成 LClosure 形态"
.. " —— 反作弊用 islclosure 自检钩子时会看到「这是个普通 Lua 函数」; 之后新装的钩子也走这条")
return true
end
F.CMX_HookHardRestore = function()
if not T.CMX_HookHard then return end
T.CMX_HookHard = false
local nc = F.CMX_G("newcclosure")
if type(nc) ~= "function" then return end
local n = 0
for slot, bucket in pairs(F.MetaLayers or {}) do
for id, rec in pairs(bucket) do
if rec and rec.alive and type(rec.raw) == "function" and rec.box then
local ok, w = pcall(nc, function(self, ...)
if not rec.alive then return rec.box.orig(self, ...) end
return rec.raw(self, ...)
end)
if ok and type(w) == "function" then
local ok2 = pcall(function() hookmetamethod(rec.target, slot, w) end)
if ok2 then rec.wrapper = w n = n + 1 end
end
end
end
end
F.Out("[绕过·钩子加固] 已还原 " .. tostring(n) .. " 层为新 C 闭包形态")
end
F.CMX_IdentityMaskEnable = function()
if F.CMX_IdentityOn then return false end
local g = F.CMX_G("getthreadidentity") or F.CMX_G("getidentity")
if type(g) == "function" then
pcall(function() F.CMX_IdentitySaved = g() end)
end
local before = F.CMX_IdentitySaved
local ok = F.CMX_SetIdentity(8)
if not ok then return false end
F.CMX_IdentityOn = true
F.Out("[绕过·身份] 已伪装: 线程身份 " .. tostring(before or "?") .. " → 8")
return true
end
F.CMX_IdentityMaskDisable = function()
if not F.CMX_IdentityOn then return end
F.CMX_IdentityOn = false
local want = tonumber(F.CMX_IdentitySaved) or 2
pcall(function() F.CMX_SetIdentity(want) end)
F.CMX_IdentitySaved = nil
F.Out("[绕过·身份] 已还原线程身份")
end
F.CMX_FFlagPreset = {
{ "FFlagDebugDisableTelemetryV2", "true" },
{ "DFIntTaskSchedulerTargetFps", "240" },
}
F.CMX_FFlagApplyPack = function()
local sf = F.CMX_G("setfflag")
if type(sf) ~= "function" then
T.CMX_FFlagPack = false
F.Out("[绕过·FFlag] 本执行器没有 setfflag ⇒ 该层不可用")
return false
end
if F.CMX_FFlagOn then return false end
local gf = F.CMX_G("getfflag")
if type(gf) ~= "function" then
T.CMX_FFlagPack = false
F.CMX_FFlagOn = false
F.Out("[绕过·FFlag] 本执行器没有 getfflag ⇒ 为避免写了没法还原, 已跳过 FFlag 写入")
return false
end
F.CMX_FFlagSaved = {}
local n = 0
for i = 1, #F.CMX_FFlagPreset do
local k, v = F.CMX_FFlagPreset[i][1], F.CMX_FFlagPreset[i][2]
if type(gf) == "function" then
local ok, old = pcall(gf, k)
if ok then F.CMX_FFlagSaved[k] = old end
end
local num = tonumber(v)
local ok2 = pcall(sf, k, num ~= nil and num or v)
if ok2 then n = n + 1 end
end
F.CMX_FFlagOn = true
F.Out("[绕过·FFlag] 已写入预设 " .. tostring(n) .. "/" .. tostring(#F.CMX_FFlagPreset)
.. " 条(遥测关闭 + 帧率上限) · 想加自己的一条用下面「写自定义 FFlag」")
return n > 0
end
F.CMX_FFlagRestore = function()
if not F.CMX_FFlagOn then return end
F.CMX_FFlagOn = false
local sf = F.CMX_G("setfflag")
if type(sf) == "function" and type(F.CMX_FFlagSaved) == "table" then
for k, v in pairs(F.CMX_FFlagSaved) do
if v ~= nil then pcall(sf, k, v) end
end
end
F.CMX_FFlagSaved = nil
F.Out("[绕过·FFlag] 已尽力还原(取不到旧值的项无法还原, 重进游戏即可复位)")
end
F.CMX_AntiDetectAudit = function()
F.Out("[反检测] ===== 自检: 我们会在哪些地方被看见 =====")
local hooked, lc, cc = 0, 0, 0
pcall(function()
for fn in pairs(AC._hookedFns or {}) do
hooked = hooked + 1
if type(fn) == "function" and type(islclosure) == "function" then
if islclosure(fn) then lc = lc + 1 else cc = cc + 1 end
end
end
end)
F.Out(string.format("[反检测] ① 我们钩过的函数 %d 个 · 其中 LClosure %d / C 闭包 %d", hooked, lc, cc))
if cc > 0 and not T.CMX_HookHard then
F.Out("[反检测]    ⚠ C 闭包形态会被「islclosure 自检」认出来 ⇒ 建议开「钩子加固(newlclosure)」")
end
local layers = 0
pcall(function()
for _ in pairs(F.MetaLayers or {}) do layers = layers + 1 end
end)
F.Out("[反检测] ② 已装的元方法拦截层 " .. tostring(layers) .. " 个(每个都是一次 hookmetamethod)")
local inCore, inHui = 0, 0
pcall(function()
local hui = gethui and gethui()
local core = game:GetService("CoreGui")
for _, d in ipairs(core:GetChildren()) do
local ours = false
pcall(function() if d:GetAttribute("CMOwned") then ours = true end end)
for _, k in ipairs(F.OUR_GUI_NAMES) do
if string.find(tostring(d.Name), k, 1, true) then ours = true break end
end
if ours then
if hui and d.Parent == hui then inHui = inHui + 1 else inCore = inCore + 1 end
end
end
end)
F.Out("[反检测] ③ 我们的界面: 在隐藏容器里 " .. tostring(inHui) .. " 个 · 直接挂在 CoreGui 明文可见 " .. tostring(inCore) .. " 个")
if inCore > 0 then F.Out("[反检测]    ⚠ 明文挂在 CoreGui 的界面, 游戏用 CoreGui:GetChildren() 就能看到 ⇒ 点下面「一键藏匿」") end
local mtRO = "?"
pcall(function()
local mt = getrawmetatable(game)
if mt and type(isreadonly) == "function" then mtRO = tostring(isreadonly(mt)) end
end)
F.Out("[反检测] ④ game 元表只读状态 = " .. mtRO .. "(false 表示我们为了挂钩把它解锁了)")
if F.CMX_ScrubOn or F.CMX_AutoScrubOn then
F.Out("[反检测] ⑤ 参数清洗钩子: 开 · 已清洗 " .. tostring(F.CMX_ScrubHits or 0) .. " 次")
end
F.Out("[反检测] 结论: 上面带 ⚠ 的项就是当前暴露面, 点「一键藏匿」能自动处理 ①③④")
end
F.CMX_AntiDetectHide = function()
F.Out("[反检测] 正在藏匿…")
pcall(F.CMX_AntiDetectAudit)
if not T.CMX_HookHard and type(F.CMX_G("newlclosure")) == "function" then
F.Try("CMX_HookHardApply", F.CMX_HookHardApply)
end
local moved = 0
pcall(function()
local hui = gethui and gethui()
if not hui then return end
local roots = { game:GetService("CoreGui") }
pcall(function() roots[#roots + 1] = LP:FindFirstChild("PlayerGui") end)
for _, r in ipairs(roots) do
if r then
for _, d in ipairs(r:GetChildren()) do
local ours = false
pcall(function() if d:GetAttribute("CMOwned") then ours = true end end)
for _, k in ipairs(F.OUR_GUI_NAMES) do
if string.find(tostring(d.Name), k, 1, true) then ours = true break end
end
if ours and d.Parent ~= hui then
pcall(function() d.Parent = hui moved = moved + 1 end)
end
end
end
end
end)
local protected = 0
local pg = F.CMX_G("protect_gui") or F.CMX_G("protectgui")
if type(pg) == "function" then
pcall(function()
local hui = gethui and gethui()
if not hui then return end
for _, d in ipairs(hui:GetChildren()) do
if pcall(pg, d) then protected = protected + 1 end
end
end)
end
local roFixed = false
if type(F.MetaLayers) == "table" then
local alive = false
pcall(function()
for _, bucket in pairs(F.MetaLayers) do
for _, rec in pairs(bucket) do
if rec and rec.alive then alive = true end
end
end
end)
if not alive then
pcall(function()
local mt = getrawmetatable(game)
if mt and type(setreadonly) == "function" then setreadonly(mt, true) roFixed = true end
end)
end
end
F.Out("[反检测] 已藏匿: 界面挪进隐藏容器 " .. tostring(moved) .. " 个 · 加保护 " .. tostring(protected)
.. " 个 · game 元表恢复只读 " .. (roFixed and "是" or "否(还有活着的钩子层, 不能恢复)"))
end
F.ACWriteTierApply = function(v)
v = tostring(v or "")
local on = v:find("②", 1, true) ~= nil or v:find("③", 1, true) ~= nil
local deep = v:find("③", 1, true) ~= nil
F.Out("[防护·改写档] = " .. v)
if on then
pcall(F.MetaHookEnsure)
pcall(AC.InstallNamecallHook)
pcall(AC.InstallIndexMask)
pcall(AC.InstallSetmetatableHook)
pcall(function() AC.DisableACConnections(true) end)
pcall(function() AC.WatchNewScriptsEnable() end)
pcall(function() AC.WatchNewRemotesEnable() end)
F.Out("[防护·改写档] 已注入: 元表钩(__namecall/__index/setmetatable) + 拦 remote + 断了可疑监听 + 新脚本/新远程监视")
else
pcall(AC.UninstallNamecallHook)
pcall(AC.UninstallIndexMask)
pcall(AC.UninstallSetmetatableHook)
pcall(function() AC.WatchNewScriptsDisable() end)
pcall(function() AC.WatchNewRemotesDisable() end)
F.Out("[防护·改写档] 已还原: 元表钩已卸, 不再改写游戏")
end
if deep then
F.Try("DeepNeuterEnable", F.DeepNeuterEnable)
else
pcall(F.DeepNeuterDisable)
end
end
F.CMX_ShapeOverride = nil
F.CMX_ShapeDefault = "19,15,2"
F.CMX_ScrubParse = function(txt)
if txt == nil then txt = F.CMX_ShapeOverride end
if txt == nil then txt = F.CMX_ShapeDefault end
local txt2 = tostring(txt or "")
local a, b, c = txt2:match("^%s*(%d+)%s*[,%s]%s*(%d+)%s*[,%s]%s*(%d+)%s*$")
if not a then
a, b = txt2:match("^%s*(%d+)%s*[,%s]%s*(%d+)%s*$")
c = 2
end
if a and b then return tonumber(a), tonumber(b), tonumber(c) or 2 end
return 19, 15, 2
end
F.CMX_ScanCapabilities = function()
F.Out("[扫描·1/6 能力] ===== 执行器能力清单 =====")
pcall(F.CMX_CapReport)
end
F.CMX_ScanHookLedger = function()
F.Out("[扫描·2/6 钩子] ===== 本脚本已装的钩子 / 拦截层 =====")
pcall(F.CMX_HookLedger)
end
F.CMX_ScanExposure = function()
F.Out("[扫描·3/6 曝光面] ===== 我们会在哪里被看见 =====")
pcall(F.CMX_AntiDetectAudit)
end
F.CMX_ScanStack = function()
F.Out("[扫描·4/6 调用栈] ===== 当前调用栈 =====")
pcall(F.CMX_StackDump)
end
F.CMX_ScanHidden = function()
F.Out("[扫描·5/6 空实例] ===== Parent=nil 的对象(反作弊藏匿点) =====")
pcall(F.CMX_NilInstReport)
end
F.CMX_ScanShapes = function()
F.Out("[扫描·6/6 函数族] ===== 按常见形状自动找函数 + 逐条列常量 =====")
for i = 1, #F.CMX_ScrubShapes do
local sh = F.CMX_ScrubShapes[i]
local txt = tostring(sh[1]) .. "," .. tostring(sh[2]) .. "," .. tostring(sh[3])
F.CMX_ShapeOverride = txt
pcall(F.CMX_FnInfo, txt)
pcall(F.CMX_ConstList, txt)
end
F.CMX_ShapeOverride = nil
end
F.CMX_ScanBypassSurface = function()
pcall(F.CMX_ScanCapabilities)
pcall(F.CMX_ScanHookLedger)
pcall(F.CMX_ScanExposure)
pcall(F.CMX_ScanStack)
pcall(F.CMX_ScanHidden)
pcall(F.CMX_ScanDetectors)
end
F.CMX_ScanACFamily = function()
pcall(F.CMX_ScanShapes)
end
F.CMX_ScanListeners = function()
F.Out("[扫描·监听] ===== 谁在监听你的角色 / 相机 / 玩家 =====")
if type(getconnections) ~= "function" then
F.Out("[扫描·监听] 本执行器没有 getconnections, 跳过")
return
end
local _, hum, root = GC()
local cam = workspace.CurrentCamera
local sigs = {}
local function add(n, s) if s then sigs[#sigs + 1] = { n, s } end end
add("LocalPlayer.Idled", LP.Idled)
add("LocalPlayer.CharacterAdded", LP.CharacterAdded)
add("TeleportService.TeleportInitFailed", game:GetService("TeleportService").TeleportInitFailed)
add("RunService.Heartbeat", RS.Heartbeat)
add("RunService.Stepped", RS.Stepped)
add("RunService.RenderStepped", RS.RenderStepped)
add("Players.PlayerAdded", Players.PlayerAdded)
if hum then
add("Humanoid.Died", hum.Died)
add("Humanoid.StateChanged", hum.StateChanged)
end
if root then
add("RootPart.Touched", root.Touched)
pcall(function()
for _, p in ipairs({ "CFrame", "Position", "Velocity", "AssemblyLinearVelocity" }) do
add("RootPart." .. p .. "Changed", root:GetPropertyChangedSignal(p))
end
end)
end
if cam then add("Camera.CFrameChanged", cam:GetPropertyChangedSignal("CFrame")) end
local total, susp = 0, 0
for i = 1, #sigs do
local ok, conns = pcall(getconnections, sigs[i][2])
if ok and type(conns) == "table" then
total = total + #conns
F.Out(string.format("[扫描·监听]   %-34s %d 条连接", sigs[i][1], #conns))
for j = 1, #conns do
local c = conns[j]
local fn, src, nm = nil, "", ""
pcall(function() fn = c.Function end)
if fn == nil then pcall(function() fn = c.__function end) end
if fn then
pcall(function()
local si = debug.getinfo(fn, "sln")
src = tostring(si and si.source or "")
nm = tostring(si and si.name or "")
end)
end
local low = (src .. " " .. nm):lower()
local bad = low:find("anti", 1, true) or low:find("detect", 1, true)
or low:find("cheat", 1, true) or low:find("ban", 1, true)
or low:find("kick", 1, true) or low:find("report", 1, true)
if bad then
susp = susp + 1
if susp <= 20 then
F.Out("[扫描·监听]     ⚠ 可疑: " .. sigs[i][1] .. " ← " .. nm .. " @ " .. src:sub(-70))
end
end
end
end
end
F.Out("[扫描·监听] 共 " .. tostring(total) .. " 条连接 · 可疑 " .. tostring(susp) .. " 条")
end
F.ScanPlayers = function()
local _, _, root = GC()
local n, list = 0, {}
pcall(function()
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then
n = n + 1
local hum = pl.Character:FindFirstChildOfClass("Humanoid")
local r = pl.Character:FindFirstChild("HumanoidRootPart")
local dist = (root and r) and (r.Position - root.Position).Magnitude or -1
local hp = (hum and hum.Health) or -1
local mx = (hum and hum.MaxHealth) or -1
local tool, team = nil, nil
pcall(function() local t = pl.Character:FindFirstChildOfClass("Tool") if t then tool = t.Name end end)
pcall(function() if pl.Team then team = pl.Team.Name end end)
list[#list + 1] = string.format("%s · %.0f 格 · 血 %.0f/%.0f%s%s", pl.Name, dist, hp, mx,
tool and (" · 手持 " .. tool) or "", team and (" · 队 " .. team) or "")
end
end
end)
table.sort(list)
F.Out("[扫描·玩家] 同服其它玩家 " .. tostring(n) .. " 人:")
for i = 1, #list do F.Out("   · " .. list[i]) end
end
F.ScanInventory = function()
local bag, list = 0, {}
pcall(function()
local ch = LP.Character
if ch then
local t = ch:FindFirstChildOfClass("Tool")
if t then table.insert(list, 1, "手持: " .. t.Name) end
end
local bp = LP:FindFirstChildOfClass("Backpack")
if bp then
local count = {}
for _, t in ipairs(bp:GetChildren()) do
if t:IsA("Tool") then
bag = bag + 1
count[t.Name] = (count[t.Name] or 0) + 1
end
end
local arr = {}
for nm, c in pairs(count) do arr[#arr + 1] = { nm = nm, c = c } end
table.sort(arr, function(a, b)
if a.c ~= b.c then return a.c > b.c end
return a.nm < b.nm
end)
for i = 1, #arr do
list[#list + 1] = string.format("背包: %s ×%d", arr[i].nm, arr[i].c)
end
end
end)
F.Out("[扫描·物品] 手持/背包(共 " .. tostring(bag) .. " 件, 按种类聚合):")
for i = 1, #list do F.Out("   · " .. list[i]) end
end
F.ScanMapPoints = function()
local KEYS = { "spawn", "portal", "teleport", "gate", "door", "zone", "area", "region",
"base", "plot", "owner", "shop", "store", "buyer", "bank", "chest", "vault", "dealer",
"market", "tunnel", "ladder", "elevator", "exit", "entrance", "sell", "island",
"plotowner", "kick", "conveyor", "machine", "claw", "rebirth", "upgrade" }
local seen, list, n = {}, {}, 0
local _, _, root = GC()
pcall(function()
for _, d in ipairs(workspace:GetDescendants()) do
n = n + 1
if n > 90000 then break end
if d:IsA("BasePart") then
local nm = string.lower(d.Name)
for _, k in ipairs(KEYS) do
if string.find(nm, k, 1, true) then
local key = d.Name .. "|" .. d.ClassName
if not seen[key] then
seen[key] = true
if #list < 4000 then
local dist = root and string.format(" %.0f格", (d.Position - root.Position).Magnitude) or ""
list[#list + 1] = d.Name .. " (" .. d.ClassName .. ")" .. dist
end
end
break
end
end
end
end
end)
table.sort(list)
F.Out("[扫描·地标] 传送点/区域/商店/基地/机器 等(去重 " .. tostring(#list) .. " 类):")
for i = 1, #list do F.Out("   · " .. list[i]) end
end
F.ScanGuiState = function()
local list = {}
local NOISE = { surface = true, frames = true, effects = true, container = true, holder = true }
local function noisy(nm)
local s = string.lower(nm)
for k in pairs(NOISE) do if string.find(s, k, 1, true) then return true end end
return false
end
local function hasContent(gui)
local ok, r = pcall(function()
for _, d in ipairs(gui:GetDescendants()) do
if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
local t = d.Text
if type(t) == "string" and #t > 0 then return true end
end
end
return false
end)
return ok and r
end
local function walk(root, tag)
pcall(function()
for _, d in ipairs(root:GetChildren()) do
if d:IsA("ScreenGui") and d.Enabled and not noisy(d.Name) and hasContent(d) then
list[#list + 1] = tag .. ": " .. d.Name
end
if d:IsA("GuiObject") then walk(d, tag) end
end
end)
end
pcall(function() walk(LP:FindFirstChild("PlayerGui"), "PlayerGui") end)
pcall(function() walk(CoreGui, "CoreGui") end)
table.sort(list)
F.Out("[扫描·界面] 有实际内容的可见界面(" .. tostring(#list) .. " 个 · 已排除容器与我们的菜单):")
for i = 1, #list do F.Out("   · " .. list[i]) end
if #list == 0 then F.Out("   (没有额外界面)") end
end
F.ScanNetStats = function()
local ping = nil
pcall(function() ping = LP:GetNetworkPing() end)
local ok, sPing = pcall(function()
local S = game:GetService("Stats")
return S.Network.ServerStatsItem["Data Ping"]:GetValue()
end)
local fps = nil
pcall(function() fps = workspace:GetRealPhysicsFPS() end)
local had = false
if ping then
F.Out(string.format("[扫描·网络] 延迟 %.0f ms(GetNetworkPing)%s", (tonumber(ping) or 0) * 1000,
fps and string.format(" · 物理帧率 %.0f FPS", fps) or ""))
had = true
elseif ok and sPing then
F.Out(string.format("[扫描·网络] 延迟 %.0f ms(Stats)%s", tonumber(sPing) or 0,
fps and string.format(" · 物理帧率 %.0f FPS", fps) or ""))
had = true
end
if not had then
if fps then
F.Out(string.format("[扫描·网络] 本执行器取不到延迟 ⇒ 只拿到物理帧率 %.0f FPS(不影响其它扫描)", fps))
else
F.Out("[扫描·网络] 本执行器/本游戏取不到网络统计(不影响其它扫描)")
end
end
end
F.ScanNearbyInteract = function()
local _, _, root = GC()
if not root then F.Out("[扫描·交互点] 角色没加载") return end
local n, near = 0, {}
pcall(function()
for _, d in ipairs(workspace:GetDescendants()) do
n = n + 1
if n > 60000 then break end
if d:IsA("ClickDetector") or d:IsA("ProximityPrompt") then
local p = d.Parent
if p and p:IsA("BasePart") then
local dist = (p.Position - root.Position).Magnitude
if dist <= 200 then
near[#near + 1] = string.format("%s (%s) · %.0f 格", d.Name, d.ClassName, dist)
end
end
end
end
end)
table.sort(near)
F.Out("[扫描·交互点] 200 格内共 " .. tostring(#near) .. " 个(纯只读, 不会自动点任何东西)")
for i = 1, #near do F.Out("   · " .. near[i]) end
end
F.RemoteList = function()
local rs = game:GetService("ReplicatedStorage")
local KEYS = { "egg", "drop", "carry", "unequip", "equip", "ragdoll", "fling", "knock", "stun", "kick", "treadmill", "guard", "speed" }
F.Out("[扫描·远程] ===== 所有 FireClient 的处理函数(谁在听服务端说话) =====")
local n, sus = 0, 0
pcall(function()
for _, d in ipairs(rs:GetDescendants()) do
local cls = d.ClassName
if cls == "RemoteEvent" or cls == "UnreliableRemoteEvent" or cls == "RemoteFunction" then
local conns = nil
pcall(function() conns = getconnections(d.OnClientEvent) end)
if conns and #conns > 0 then
n = n + 1
local nm = tostring(d.Name)
local low = nm:lower()
local hit = false
for _, k in ipairs(KEYS) do if low:find(k, 1, true) then hit = true break end end
if hit then sus = sus + 1 end
local src = "?"
pcall(function()
local f = conns[1].Function
if f then local i = debug.getinfo(f, "s") src = tostring(i and i.source or "?") end
end)
F.Out(string.format("[扫描·远程] %s · %d 条连接 · 来源 %s%s", nm, #conns, tostring(src):sub(1, 80), hit and "  <<< 像掉蛋/收回/速度/守卫" or ""))
end
end
end
end)
F.Out("[扫描·远程] 共 " .. tostring(n) .. " 个有客户端处理的远程 · 名字可疑(掉蛋/收回/速度/守卫类) " .. tostring(sus) .. " 个")
end
F.CMX_ScanAll = function()
pcall(F.RemoteList)
F.Out("[扫描] ===== 一键全扫描 开始 =====")
pcall(F.ScanNearbyInteract)
task.wait()
pcall(F.ScanPlayers)
task.wait()
pcall(F.ScanInventory)
task.wait()
pcall(F.ScanMapPoints)
task.wait()
pcall(F.ScanGuiState)
task.wait()
pcall(F.ScanNetStats)
task.wait()
pcall(F.ScanHUD)
task.wait()
pcall(F.CMX_ScanBypassSurface)
task.wait()
pcall(F.CMX_ScanACFamily)
task.wait()
pcall(F.CMX_ScanListeners)
task.wait()
pcall(F.ScanScripts)
task.wait()
pcall(F.ScanGameModules)
task.wait()
pcall(F.ScanRemotes)
task.wait()
pcall(F.ScanConnections)
task.wait()
pcall(F.ScanClientChecks, true)
pcall(function()
local found = F.CMX_ScanReportRemotes(true) or {}
if #found > 0 then
local keys = {}
for i = 1, #found do keys[#keys + 1] = tostring(found[i].inst.Name) end
F.Out("[扫描] 扫到 " .. tostring(#found) .. " 个像上报/封禁的远程: "
.. table.concat(keys, ", "):sub(1, 160))
F.Out("[扫描] 要拦它们请手动开「★ 反封禁全家桶」(扫描只负责列出来, 不会自动动手)")
else
F.Out("[扫描] 没扫到名字像上报/封禁的远程")
end
end)
pcall(F.LogFlush, "一键全扫描")
F.Out("[扫描] ===== 一键全扫描 结束 · 点「复制扫描结果」交给我  =====")
end
F.CMX_ScanExport = function()
local lines = F._logBuf or {}
local txt = table.concat(lines, "\n")
local ok = false
pcall(function()
local sc = F.CMX_G("setclipboard") or F.CMX_G("toclipboard") or F.CMX_G("write_clipboard")
if type(sc) == "function" then sc(txt) ok = true end
end)
F.Out("[扫描·导出] 日志 " .. tostring(#lines) .. " 行 / " .. tostring(#txt) .. " 字"
.. (ok and " · 已复制到剪贴板, 直接粘给我就行" or " · 复制失败(执行器没剪贴板)"))
end
F.CMX_ArgScrubEnable = function()
if F.CMX_ScrubOn then return false end
local nups, nconsts, upidx = F.CMX_ScrubParse()
local f, seen = F.CMX_FindClosure(nups, nconsts)
if not f then
F.Out("[绕过·参数清洗] 形状(" .. tostring(nups) .. "," .. tostring(nconsts)
.. ") 没找到闭包(已扫 " .. tostring(seen or 0) .. " 个) —— 换个形状或提高扫描上限")
return false
end
local target = nil
pcall(function() target = debug.getupvalue(f, upidx) end)
if type(target) ~= "function" then
F.Out("[绕过·参数清洗] 该闭包第 " .. tostring(upidx) .. " 个 upvalue 不是函数 —— 换 upindex(常见 2)")
return false
end
local orig = nil
local hits = 0
local wrap = function(a1, a2, ...)
if typeof(a2) == "table" then
pcall(setmetatable, a2, {})
hits = hits + 1
F.CMX_ScrubHits = hits
end
if type(orig) ~= "function" then return nil end
return orig(a1, a2, ...)
end
local o = F.CMX_SafeHook(target, wrap)
if not o then
F.Out("[绕过·参数清洗] hookfunction 失败(该函数被保护 / 执行器不支持)")
return false
end
orig = o
F.CMX_ScrubOrig = o
F.CMX_ScrubHook = target
F.CMX_ScrubOn = true
F.CMX_ScrubHits = 0
F.CMX_ScrubShape = { nups, nconsts, upidx }
local sig = ""
pcall(function()
local si = debug.getinfo(target, "s")
sig = tostring(si and si.source or "?") .. "#" .. tostring(si and si.linedefined or -1)
end)
F.CMX_ScrubSig = sig
if not F.CMX_ScrubHeal then
local holder = { thread = nil, done = false }
holder.thread = task.spawn(function()
while F.CMX_ScrubOn do
task.wait(8)
if not F.CMX_ScrubOn then break end
local cur = ""
pcall(function()
local si = debug.getinfo(F.CMX_ScrubHook, "s")
cur = tostring(si and si.source or "?") .. "#" .. tostring(si and si.linedefined or -1)
end)
if cur ~= F.CMX_ScrubSig then
F.Out("[绕过·参数清洗] 目标函数被重建 ⇒ 正在重新定位并重装钩子")
local sp = F.CMX_ScrubShape
pcall(F.CMX_ArgScrubDisable)
if sp then
F.CMX_ShapeOverride = tostring(sp[1]) .. "," .. tostring(sp[2]) .. "," .. tostring(sp[3])
F.Try("CMX_ArgScrubEnable", F.CMX_ArgScrubEnable)
end
F.CMX_ScrubHealFix = (F.CMX_ScrubHealFix or 0) + 1
end
end
holder.done = true
if F.CMX_ScrubHeal == holder.thread then F.CMX_ScrubHeal = nil end
end)
if holder.done then F.CMX_ScrubHeal = nil else F.CMX_ScrubHeal = holder.thread end
end
F.Out("[绕过·参数清洗] 已开: 形状(" .. tostring(nups) .. "," .. tostring(nconsts)
.. ") 的第 " .. tostring(upidx) .. " 个 upvalue 已挂钩 · 参数表元表会被抹成空表(反指纹检测)")
return true
end
F.CMX_ArgScrubDisable = function()
if not F.CMX_ScrubOn then return end
F.CMX_ScrubOn = false
pcall(function()
if F.CMX_ScrubHook and F.CMX_ScrubOrig then hookfunction(F.CMX_ScrubHook, F.CMX_ScrubOrig) end
end)
F.CMX_ScrubHook, F.CMX_ScrubOrig = nil, nil
F.Out("[绕过·参数清洗] 已关 · 本次共清洗 " .. tostring(F.CMX_ScrubHits or 0) .. " 次参数表")
end
F.CMX_StackDump = function()
F.Out("[绕过·栈] ===== 当前调用栈(从内往外) =====")
local i, n = 1, 0
while n < 25 do
local info = nil
pcall(function() info = debug.getinfo(i, "sln") end)
if not info then break end
n = n + 1
local src = tostring(info.source or "?")
if #src > 70 then src = "..." .. src:sub(-67) end
F.Out(string.format("[绕过·栈]   #%d %-22s %s : %s", i, tostring(info.name or "(匿名)"),
tostring(info.what or "?"), src))
i = i + 1
end
F.Out("[绕过·栈] 共 " .. tostring(n) .. " 层 (想知道「谁在调用这个函数」就这么看)")
end
F.CMX_NilInstReport = function()
local f = F.CMX_G("getnilinstances")
if type(f) ~= "function" then
F.Out("[绕过·空实例] 本执行器没有 getnilinstances —— 换 getinstances 也试一下")
f = F.CMX_G("getinstances")
end
if type(f) ~= "function" then
F.Out("[绕过·空实例] 该执行器不支持, 跳过")
return false
end
local list = nil
pcall(function() list = f() end)
if type(list) ~= "table" then
F.Out("[绕过·空实例] 取不到结果")
return false
end
F.Out("[绕过·空实例] 共 " .. tostring(#list) .. " 个 Parent=nil 的实例(反作弊最爱藏这儿)")
local byClass = {}
local mine = 0
for i = 1, #list do
local o = list[i]
local cn = "?"
pcall(function() cn = tostring(o.ClassName) end)
byClass[cn] = (byClass[cn] or 0) + 1
pcall(function()
if o:GetAttribute("CMOwned") then mine = mine + 1 end
end)
end
local arr = {}
for k, v in pairs(byClass) do arr[#arr + 1] = { k, v } end
table.sort(arr, function(a, b) return a[2] > b[2] end)
for i = 1, math.min(#arr, 25) do
F.Out(string.format("[绕过·空实例]   %-30s %d", tostring(arr[i][1]), arr[i][2]))
end
F.Out("[绕过·空实例] 本脚本自己的 " .. tostring(mine) .. " 个(可忽略)")
end
F.CMX_CapReport = function()
local list = {
"newlclosure", "newcclosure", "islclosure", "clonefunction", "replaceclosure",
"hookfunction", "hookmetamethod", "getrawmetatable", "setreadonly", "isreadonly",
"getconnections", "firesignal", "hooksignal", "checkcaller", "cloneref",
"sethiddenproperty", "gethiddenproperty", "setthreadidentity", "getthreadidentity",
"setfflag", "getfflag", "getcallbackvalue", "filtergc", "compareinstances",
"decompile", "getscriptbytecode", "getscriptsource", "getloadedmodules", "getnilinstances",
"queue_on_teleport", "protect_gui", "gethui", "getcustomasset", "mousemoverel",
"mouse1press", "keypress", "fireclickdetector", "firetouchinterest", "fireproximityprompt",
"setclipboard", "identifyexecutor",
}
local ok, miss = 0, {}
F.Out("[绕过·能力] ===== 执行器能力总览 =====")
for i = 1, #list do
local v = F.CMX_G(list[i])
if v ~= nil then
ok = ok + 1
F.Out(string.format("[绕过·能力]   ✓ %-22s %s", list[i], type(v)))
else
miss[#miss + 1] = list[i]
end
end
F.Out("[绕过·能力] 可用 " .. tostring(ok) .. "/" .. tostring(#list))
if #miss > 0 then F.Out("[绕过·能力] ✗ 缺失: " .. table.concat(miss, ", ")) end
pcall(function()
F.Out("[绕过·能力]   当前线程身份 = " .. tostring(getthreadidentity and getthreadidentity() or "?"))
end)
end
F.CMX_SetIdentity = function(n)
local f = F.CMX_G("setthreadidentity") or F.CMX_G("setidentity")
if type(f) ~= "function" then
F.Out("[绕过·身份] 本执行器没有 setthreadidentity/setidentity —— 无法改线程身份")
return false
end
local want = tonumber(n) or 8
local ok = pcall(f, want)
local now = "?"
pcall(function()
local g = F.CMX_G("getthreadidentity") or F.CMX_G("getidentity")
if type(g) == "function" then now = tostring(g()) end
end)
F.Out("[绕过·身份] " .. (ok and ("已设为 " .. tostring(want)) or "设置被拒") .. " · 当前读回 = " .. now)
return ok
end
F.CMX_FnInfo = function(txt)
local a, b, c = F.CMX_ScrubParse(txt)
local f, seen = F.CMX_FindClosure(a, b)
if not f then
F.Out("[绕过·定位] 形状(" .. tostring(a) .. "," .. tostring(b) .. ") 无命中(扫了 " .. tostring(seen or 0) .. " 个)")
return false
end
F.Out("[绕过·定位] 形状(" .. tostring(a) .. "," .. tostring(b) .. ") 命中 · 开始逐层展开 upvalue:")
local n = 0
pcall(function()
local ops = nil
if dbgGetUpvalues then pcall(function() ops = dbgGetUpvalues(f) end) end
if type(ops) ~= "table" and type(debug) == "table" and type(debug.getupvalue) == "function" then
ops = {}
for i = 1, 64 do
local nm, v = debug.getupvalue(f, i)
if nm == nil then break end
ops[i] = v
end
end
if type(ops) == "table" then
for i = 1, #ops do
local v = ops[i]
n = n + 1
if n > 20 then break end
local kind = typeof(v)
local extra = ""
if type(v) == "string" then extra = " = " .. v:sub(1, 60) end
if type(v) == "number" then extra = " = " .. tostring(v) end
F.Out(string.format("[绕过·定位]   upvalue[%d] %s%s", i, kind, extra))
end
end
end)
local t = nil
pcall(function() t = debug.getupvalue(f, c or 2) end)
if type(t) == "function" then
F.Out("[绕过·定位] upvalue[" .. tostring(c or 2) .. "] 是函数 ⇒ 可直接用「参数清洗钩子」(upindex=" .. tostring(c or 2) .. ")")
end
return true
end
F.InstantInteractAutoLoop = function()
if F._iiAuto then return end
F._iiAuto = task.spawn(function()
while T.InstantInteract do
local igap = 4
if F.CMX_HumanizeOn then igap = F.CMX_Jitter(4, 1.5) end
task.wait(igap)
if not T.InstantInteract then break end
if not (F.II_SAVED and next(F.II_SAVED)) then
task.wait(10)
elseif tostring(C.IILevel or "①"):find("③", 1, true) then
local _, _, root = GC()
if root then
pcall(function()
local n = 0
for _, d in ipairs(workspace:GetDescendants()) do
n = n + 1
if n > 800 then break end
if d:IsA("ProximityPrompt") and d.Enabled and d.Parent and d.Parent:IsA("BasePart") then
if (d.Parent.Position - root.Position).Magnitude <= 60 then
pcall(function()
d.HoldDuration = 0
d.MaxActivationDistance = 1000000
d.InputHoldBegin:Fire()
end)
end
end
end
end)
end
end
end
F._iiAuto = nil
end)
end
F.AntiAFKInputLoop = function()
if F._afkInput then return end
F._afkInput = task.spawn(function()
while T.AntiAFK do
local mode = tostring(C.AFKMode or "")
if mode:find("鼠标抖动", 1, true) then
local mm = F.CMX_G("mousemoverel")
if type(mm) == "function" then
pcall(mm, 40, 0)
task.wait(0.05)
pcall(mm, -40, 0)
else
local vu = F.CMX_G("VirtualUser")
if vu then
pcall(function()
vu:CaptureController()
vu:MoveMouse(Vector2.new(60, 60))
end)
end
end
end
if mode:find("按键注入", 1, true) then
local kp, kr = F.CMX_G("keypress"), F.CMX_G("keyrelease")
if type(kp) == "function" and type(kr) == "function" then
pcall(kp, 0x20)
task.wait(0.06)
pcall(kr, 0x20)
else
local vim = nil
pcall(function() vim = game:GetService("VirtualInputManager") end)
if vim then
pcall(function()
vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
task.wait(0.06)
vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end)
end
end
end
local agap = 30
if F.CMX_HumanizeOn then agap = F.CMX_Jitter(30, 0.4) end
task.wait(agap)
end
F._afkInput = nil
end)
end
local Tabs = {
Combat  = Window:AddTab({ Title = "战斗", Icon = "crosshair" }),
Visual  = Window:AddTab({ Title = "视觉", Icon = "globe" }),
Move    = Window:AddTab({ Title = "移动", Icon = "move" }),
AFK     = Window:AddTab({ Title = "挂机", Icon = "home" }),
Trans   = Window:AddTab({ Title = "翻译", Icon = "languages" }),
System  = Window:AddTab({ Title = "系统", Icon = "settings" }),
}
Tabs.World   = Tabs.Visual
Tabs.TP      = Tabs.Move
Tabs.AC      = Tabs.System
Tabs.Setting = Tabs.System
do
Tabs.Combat:AddSection("自瞄")
Tabs.Combat:AddToggle("AimOn", { Title = "★ 自瞄(总开关)", Description = "开: 自动挑一个敌人锁住, 屏幕上会显示「锁定: 名字 · 距离」让你看得见效果。本开关不落盘, 每次重载要重点一次", Default = false, Callback = function(v) if F._cfgSyncing then return end F.AimSet(v, "手动") end })
Tabs.Combat:AddDropdown("CombatMode", { Title = "锁定模式", Description = "两种就是你说的那两种: 正面圈内锁 = 只锁屏幕正面那个圈里的(面对谁锁谁); 漏就锁 = 360°全身, 只要他身上有任何一个部位打得着(哪怕只露一条胳膊/一条腿)就锁", Values = {
"漏就锁(360°全身 · 只要打得到就锁)",
"正面圈内锁(只锁屏幕正面圈里的)",
}, Default = "漏就锁(360°全身 · 只要打得到就锁)", Callback = function(v)
C.CombatMode = tostring(v)
if F._cfgSyncing then return end
F.Out("[战斗] 锁定模式 = " .. tostring(v))
end })
Tabs.Combat:AddToggle("SilentAim", { Title = "静默瞄准(不动你视角也能命中)", Description = "改写 mouse.Hit / mouse.Target 指向锁定目标。只在游戏用「鼠标命中」判定时有效; 游戏若用视线射线或服务端校验则可能无效(原理限制)", Default = false, Callback = function(v)
if F._cfgSyncing then return end
F.SilentAimSet(v)
end })
Tabs.Combat:AddSlider("CombatRange", { Title = "锁定距离(格)", Min = 5, Max = 1000, Default = 200, Rounding = 0, Callback = function(v) C.CombatRange = v end })
Tabs.Combat:AddSlider("CombatFOV", { Title = "正面圈大小(像素 · 只有正面圈内锁用)", Min = 50, Max = 1200, Default = 400, Rounding = 0, Callback = function(v) C.CombatFOV = v end })
Tabs.Combat:AddToggle("CombatWallCheck", { Title = "不打隔墙(默认开)", Description = "从相机到目标打射线, 中间被墙/建筑挡住就不锁(所以不会隔着墙打)", Default = true, Callback = function(v)
T.CombatWallCheck = v
if F._cfgSyncing then return end
F.Out("[战斗] 不打隔墙 = " .. (v and "开" or "关"))
end })
Tabs.Combat:AddToggle("CombatSkipInvincible", { Title = "不打无敌/出生保护的人(默认开)", Description = "目标身上有 ForceField(出生保护)、血量超过上限、或带 Invincible 属性的一律跳过", Default = true, Callback = function(v)
T.CombatSkipInvincible = v
if F._cfgSyncing then return end
F.Out("[战斗] 不打无敌/出生保护 = " .. (v and "开" or "关"))
end })
Tabs.Combat:AddToggle("AutoFire", { Title = "★ 自动开火(FPS 自动扳机: 锁到人就自动按下开火)", Description = "勾它时会顺手把上面的「自瞄」也打开(否则它单独开没有任何作用)", Default = true, Callback = function(v)
T.AutoFire = v
if F._cfgSyncing then return end
F.Out("[战斗] 自动开火 = " .. (v and "开" or "关"))
if v then F.EnsureAimOn("开自动开火") end
end })
Tabs.Combat:AddSlider("AutoFireGap", { Title = "开火间隔(秒)", Min = 0.05, Max = 1, Default = 0.12, Rounding = 2, Callback = function(v) C.AutoFireGap = v end })
Tabs.Combat:AddDropdown("AimLockMode", { Title = "锁定方式", Values = {
"转身锁人(只转人物朝向 · 不碰你视角)",
"转视角(把相机也转过去 · 枪战用)",
}, Default = "转身锁人(只转人物朝向 · 不碰你视角)", Callback = function(v)
local cam = tostring(v):find("转视角", 1, true) ~= nil
T.AimTurnCamera, T.AimTurnBody = cam, (not cam)
if F._cfgSyncing then return end
F.Out("[战斗] 锁定方式 = " .. tostring(v))
end })
Tabs.Combat:AddSection("生存")
Tabs.Combat:AddToggle("AntiRagdoll", { Title = "防击倒(反布娃娃+防被撞飞)", Default = false, Callback = function(v)
C.AntiRagdollMode = v and "全部开启" or "关闭"
T.AntiRagdoll, T.AntiKnockdown = v, v
if F._cfgSyncing then return end
F.AntiRagdollDisable() F.AntiKnockdownDisable()
if v then F.AntiRagdollEnable() F.AntiKnockdownEnable() end
end })
Tabs.Combat:AddToggle("God", { Title = "无敌(血量拉到无穷 · 服务端若校验血量会拉回)", Default = false, Callback = function(v)
T.God = v
if F._cfgSyncing then return end
if v then pcall(GodEnable) else pcall(GodDisable) end
F.Out("[无敌] " .. (v and "已开(血量拉到无穷; 服务端若校验会拉回)" or "已关"))
end })
Tabs.Combat:AddToggle("LockHealth", { Title = "锁血(血量恒定)", Default = false, Callback = function(v)
T.LockHealth = v
if F._cfgSyncing then return end
if v then pcall(LockHealthEnable) else pcall(LockHealthDisable) end
F.Out("[锁血] " .. (v and "已开(血量恒定)" or "已关"))
end })
Tabs.Combat:AddToggle("Regen", { Title = "回血", Default = false, Callback = function(v)
T.Regen = v
if F._cfgSyncing then return end
if v then pcall(RegenEnable) else pcall(RegenDisable) end
F.Out("[回血] " .. (v and "已开" or "已关"))
end })
Tabs.Combat:AddToggle("NoDeath", { Title = "不死(血量归零自动回满)", Default = false, Callback = function(v)
T.NoDeath = v
if F._cfgSyncing then return end
if v then pcall(NoDeathEnable) else pcall(NoDeathDisable) end
F.Out("[不死] " .. (v and "已开(归零自动回满)" or "已关"))
end })
Tabs.Combat:AddToggle("HealthShow", { Title = "血量显示(自己 + 锁定目标)", Description = "用屏幕上那条 HUD 显示血量: 没开自瞄时显示你自己的, 开了自瞄就显示锁定目标的", Default = false, Callback = function(v)
if F._cfgSyncing then return end
F.HealthShowSet(v)
end })
Tabs.Move:AddSection("飞行")
Tabs.Move:AddToggle("FlyOn", { Title = "飞行(WASD 移动 · 空格升/Ctrl降 · 松手即停)", Default = false, Callback = function(v) F.FlySet(v) end })
Tabs.Move:AddSlider("FlyValue", { Title = "飞行速度(格/秒)", Min = 10, Max = 5000, Default = 60, Rounding = 0, Callback = function(v) C.FlyValue = v end })
Tabs.Move:AddSection("加速")
Tabs.Move:AddToggle("SpeedOn", { Title = "加速(水平全向 · 松手即停 · 不含上下)", Default = false, Callback = function(v) F.SpeedSet(v) end })
Tabs.Move:AddSlider("SpeedValue", { Title = "加速速度(格/秒)", Min = 16, Max = 5000, Default = 60, Rounding = 0, Callback = function(v) C.SpeedValue = v if T.SpeedOn then F.SpeedApply() end end })
Tabs.Move:AddSection("★ 防护(稳身 / 反攻击 / 反陷阱)")
Tabs.Move:AddToggle("GuardAll", { Title = "防护(稳身 + 反攻击 + 反陷阱 + 反拉回 + 护蛋 · 合成一个)", Description = "稳身=不被击倒/甩飞 · 反攻击=被打不倒地不被击飞 · 反陷阱=踩上去不触发 · 反拉回=清检测脚本/断检测连接 · 护蛋=只抢回你自己那个蛋(焊在手上 + 被卸下立刻装回)", Default = false, Callback = function(v)
T.SteadyOn, T.HitGuard, T.TrapWarn = v, v, v
T.SpeedAntiTP, T.MyEgg = v, v
if F._cfgSyncing then return end
pcall(F.ProtectApply)
if v then
pcall(F.SpeedAntiTPEnable)
pcall(F.MyEggSet, true)
else
pcall(F.SpeedAntiTPDisable)
pcall(F.MyEggSet, false)
end
F.Out("[防护] 稳身/反攻击/反陷阱/反拉回/护蛋 = " .. (v and "开" or "关"))
end })
F.ProtectApply = function()
local steady, hit = T.SteadyOn == true, T.HitGuard == true
if steady or hit then
F.Try("CharEventsEnable", F.CharEventsEnable)
pcall(F.MetaHookEnsure)
else
pcall(F.CharEventsDisable)
end
if steady then pcall(F.SteadyEnable) else pcall(F.SteadyDisable) end
if hit then pcall(function() F.HitGuardEnable(T.HitStrong) end) else pcall(F.HitGuardDisable) end
if T.TrapWarn then pcall(F.TrapGuardEnable) else pcall(F.TrapGuardDisable) end
if T.SpeedAntiTP then pcall(F.SpeedAntiTPEnable) else pcall(F.SpeedAntiTPDisable) end
F.Out(string.format("[防护] 稳身=%s · 反攻击(受击保护)=%s · 反陷阱=%s · 防拉回=%s",
steady and "开" or "关",
hit and ("开" .. (T.HitStrong and "(猛档)" or "(状态法)")) or "关",
T.TrapWarn and "开" or "关", T.SpeedAntiTP and "开" or "关"))
end
Tabs.Move:AddToggle("InstantInteract", { Title = "★ 瞬间偷蛋 / 瞬间交互(点一下就瞬间完成 · 不用长按 E)", Description = "开: 游戏里所有要按住一会儿的交互(偷蛋/开箱/机关)一律变「点一下就瞬间完成」, 不用长按。不加远距离、不自动偷, 就是老实把长按改成瞬间", Default = false, Callback = function(v)
local changed = (T.InstantInteract ~= nil) and (T.InstantInteract ~= v)
T.InstantInteract = v
if F._cfgSyncing or not changed then return end
if v then F.InstantInteractEnable() else F.InstantInteractDisable() end
end })
Tabs.Move:AddToggle("Invisible", { Title = "隐身(对所有人看不见 · 真隐身)", Description = "把自己角色的所有部件 Transparency 设为 1 —— 客户端持有自己角色的网络所有权, 这个改动会复制给其他玩家; 顺带关掉名字/血条显示。服务端若有透明检测会拉回", Default = false, Callback = function(v)
T.Invisible = v
if F._cfgSyncing then return end
if v then F.InvisibleEnable() else F.InvisibleDisable() end
end })
Tabs.Move:AddSection("位移(无限跳 / 穿墙 / 藏地下)")
Tabs.Setting:AddButton({ Title = "自杀 / 重置角色(卡住、被夹住时用)", Callback = function() pcall(F.SuicideNow) end })
Tabs.Move:AddToggle("InfiniteJump", { Title = "无限跳(空中也能跳)", Default = false, Callback = function(v)
local changed = (T.InfiniteJump ~= nil) and (T.InfiniteJump ~= v)
T.InfiniteJump = v
if F._cfgSyncing or not changed then return end
if v then F.InfiniteJumpEnable() else F.InfiniteJumpDisable() end
F.Out("[无限跳] " .. (v and "已开" or "已关"))
end })
Tabs.Move:AddToggle("NoClip", { Title = "穿墙", Default = false, Callback = function(v)
T.NoClip = v
if F._cfgSyncing then return end
if v then F.NoClipEnable() else F.NoClipDisable() end
F.Out("[穿墙] " .. (v and "已开" or "已关"))
end })
Tabs.Move:AddToggle("Hide", { Title = "藏地下", Default = false, Callback = function(v)
T.Hide = v
if F._cfgSyncing then return end
if v then F.HideEnable() else F.HideDisable() end
end })
end
do
Tabs.Visual:AddSection("身体高亮 / 敌我识别")
Tabs.Visual:AddToggle("BodyHL", { Title = "身体高亮透视(隔墙也能看到别人 · 半透明色块 + 外框)", Description = "用的是通用做法: 一个 Highlight, 填充半透明 + 描边 + 始终显示在最上层 ⇒ 隔着墙也看得见。队友绿、敌人红(配合下面的敌我识别)", Default = false, Callback = function(v)
T.BodyHL = v
if F._cfgSyncing then return end
if v then F.BodyHLEnable() else F.BodyHLDisable() end
F.Out("[高亮] 身体高亮 = " .. (v and "开(隔墙可见 · 队友绿/敌人红看下面的敌我识别)" or "关"))
end })
Tabs.Visual:AddToggle("TeamColorHL", { Title = "敌我识别(队友绿 / 敌人红)", Default = false, Callback = function(v)
T.TeamColorHL = v
if F._cfgSyncing then return end
if T.BodyHL then F.BodyHLRefresh() end
F.Out("[高亮] 敌我识别 = " .. (v and "开(队友绿 / 敌人红)" or "关(统一蓝色)"))
end })
Tabs.World:AddSection("画面增强")
Tabs.World:AddToggle("VisionBoost", { Title = "视觉增强(全亮+夜视+去雾)", Default = false, Callback = function(v)
T.FullBright = v T.NightVision = v T.NoFog = v
if F._cfgSyncing then return end
if v then F.FullBrightEnable() F.NightVisionEnable() F.NoFogEnable() pcall(F.LightWatchEnable)
else F.FullBrightDisable() F.NightVisionDisable() F.NoFogDisable() pcall(F.LightWatchDisable) end
end })
Tabs.World:AddToggle("ViewBoost", { Title = "视角增强(FOV+无限缩放)", Default = false, Callback = function(v)
T.FOV = v T.Zoom = v
if F._cfgSyncing then return end
if v then FOVEnable() ZoomEnable() else FOVDisable() ZoomDisable() end
F.Out("[视角] 视角增强 = " .. (v and "开(FOV+无限缩放)" or "关"))
end })
Tabs.World:AddToggle("Mute", { Title = "静音", Default = false, Callback = function(v)
T.Mute = v
if F._cfgSyncing then return end
if v then MuteEnable() else MuteDisable() end
F.Out("[静音] " .. (v and "已开" or "已关"))
end })
Tabs.World:AddToggle("Antilag", { Title = "降画质", Default = false, Callback = function(v)
T.Antilag = v
if F._cfgSyncing then return end
if v then AntilagEnable() else AntilagDisable() end
F.Out("[降画质] " .. (v and "已开" or "已关"))
end })
Tabs.World:AddSection("相机 / 准星")
Tabs.World:AddToggle("Hud", { Title = "FPS/Ping HUD", Default = false, Callback = function(v)
T.Hud = v
if F._cfgSyncing then return end
if v then F.HudEnable() else F.HudDisable() end
end })
Tabs.World:AddToggle("Crosshair", { Title = "准星", Default = false, Callback = function(v)
T.Crosshair = v
if F._cfgSyncing then return end
if v then F.CrosshairEnable() else F.CrosshairDisable() end
end })
end
do
Tabs.World:AddSection("相机(自由视角 / 锁相机 · 会接管相机, 一般别开)")
Tabs.World:AddToggle("Freecam", { Title = "自由视角 Freecam(手机不可用)", Default = false, Callback = function(v)
if F._cfgSyncing then return end
if v and UIS.TouchEnabled then
T.Freecam = false
pcall(function()
if Fluent and Fluent.Notify then
Fluent:Notify({ Title = "Freecam", Content = "手机端不支持(需要鼠标/键盘), 已自动关闭", Duration = 5 })
end
end)
return
end
T.Freecam = v
if v then F.FreecamEnable() else F.FreecamDisable() end
end })
Tabs.World:AddToggle("LockCam", { Title = "锁相机", Default = false, Callback = function(v)
T.LockCam = v
if F._cfgSyncing then return end
if v then F.LockCamEnable() else F.LockCamDisable() end
F.Out("[锁相机] " .. (v and "已开(相机锁在当前朝向)" or "已关"))
end })
Tabs.TP:AddSection("传送")
Tabs.TP:AddDropdown("TPStep", { Title = "传送步进方式(鼠标传送 / 收藏点位 全部适用)", Values = {
"分步瞬移(现状 · 每步抢网络所有权, 最稳)",
"补间步进(TweenService 平滑过渡 · 不抢所有权, 长距离更容易被拉回)",
}, Default = "分步瞬移(现状 · 每步抢网络所有权, 最稳)", Callback = function(v)
C.TPStep = v
if F._cfgSyncing then return end
pcall(F.CMX_ProfilePut, "tpstep", v)
end })
Tabs.TP:AddDropdown("TPTarget", { Title = "目标玩家", Values = F.PlayerNames(), Default = nil })
Tabs.TP:AddButton({ Title = "传送到目标", Callback = function()
local name = Fluent.Options.TPTarget and Fluent.Options.TPTarget.Value
if name then TeleportToPlayer(Players:FindFirstChild(name)) end
end })
Tabs.TP:AddToggle("TPMouse", { Title = "T 键传送到鼠标位置", Description = "开: 游戏里按 T 直接瞬移到鼠标指的地方(指着天空就送到正前方) / 关: T 键无效", Default = false, Callback = function(v)
T.TPMouse = v
if F._cfgSyncing then return end
F._tpMouseOn = v and true or false
F.Out(v and "[T键传送] 已开启, 游戏里按 T 传送到鼠标位置(再点一次可关)"
or "[T键传送] 已关闭, T 键不再传送")
end })
Tabs.TP:AddSection("收藏点位(点=存/传 · 右键(手机长按)=删)")
F._wpb = {}
for i = 1, F.WP_SLOTS do
F._wpb[i] = Tabs.TP:AddButton({ Title = "点位" .. tostring(i) .. " · 空位(点=存 / 右键=删)", Callback = function()
F.WpClick(i)
end })
F.WpSlotHook(i, F._wpb[i])
end
Tabs.TP:AddButton({ Title = "删除最近保存的点位", Callback = function()
F.WaypointDel(F.WpLastName())
F.WaypointRefreshUI()
end })
Tabs.TP:AddButton({ Title = "清空所有点位", Callback = function() F.WpClear() end })
F.WaypointRefreshUI()
task.delay(2, function()
for i = 1, F.WP_SLOTS do pcall(F.WpSlotHook, i, F._wpb and F._wpb[i]) end
end)
Tabs.AFK:AddSection("★ 挂机防踢")
Tabs.AFK:AddToggle("AFKKickGuard", { Title = "挂机防踢(防挂机 + 防踢 合成一个开关)", Description = "① 防挂机: 不写人物任何属性, 只掐掉游戏挂在 Idled 上的检测连接 + 定期写心跳属性; ② 防踢: 钩住 Kick 的三条路径(Kick 方法 / .Kick 取值 / .Kick 赋值), 反作弊或服务端踢你时本地拦下", Default = true, Callback = function(v)
T.AntiAFK, T.KickGuard = v, v
if F._cfgSyncing then return end
if v then
F.Try("AntiAFKEnable", F.AntiAFKEnable)
F.Try("KickGuardEnable", F.KickGuardEnable)
else
pcall(F.AntiAFKDisable)
pcall(F.KickGuardDisable)
end
end })
Tabs.AFK:AddSection("自动化")
Tabs.AFK:AddToggle("AutoTrain", { Title = "踢击训练(自动手持配重)", Description = "自动装备一件配重(brainrot 以外的 Tool)并按一次 Activate; 想真正涨力量请同时开下面的「自动锻炼(健身房)」", Default = false, Callback = function(v)
T.AutoTrain = v
if F._cfgSyncing then return end
if v then F.AutoTrainEnable() else F.AutoTrainDisable() end
end })
Tabs.AFK:AddToggle("AutoBonus", { Title = "领取踢击奖励(自动点 Bonus / 收现金)", Description = "① 点 PlayerGui.KickUpgrades 里 Visible 的 Bonus/PopBonus 按钮(就是那个 ×2 奖励) ② 发 rev_B_Collect 收现金 ③ 触碰自己地盘(Plots)上的收钱按钮", Default = false, Callback = function(v)
T.AutoBonus = v
if F._cfgSyncing then return end
if v then F.AutoBonusEnable() else F.AutoBonusDisable() end
end })
Tabs.AFK:AddToggle("AutoGym", { Title = "自动锻炼(健身房)", Description = "这游戏的锻炼 = 手持配重 + 反复点 KickUpgrades 的 Bonus 弹窗(不是站在跑步机上)。开它只会在找得到该界面时工作; 找不到会自己退回旧的举铁机逻辑", Default = false, Callback = function(v)
T.AutoGym = v
if F._cfgSyncing then return end
if v then F.AutoGymEnable() else F.AutoGymDisable() end
end })
Tabs.AFK:AddSection("收起脑红")
Tabs.AFK:AddButton({ Title = "⑤ ★ 收起脑红(全部 1~30 槽 · 一次全收)", Description = "把放出的脑红全部收回背包(1~30 槽全扫)", Callback = function() pcall(F.WithdrawAll, 30) end })
Tabs.Trans:AddSection("本地翻译服务")
Tabs.Trans:AddToggle("Translate", { Title = "翻译总开关(UI 文字 + 互动文字)", Default = false, Callback = function(v)
if F._cfgSyncing then return end
if v then
F.TranslateEnable()
else
F.TranslateDisable()
end
end })
Tabs.Trans:AddDropdown("TransScope", { Title = "翻译范围", Values = { "只翻译界面", "界面 + 公屏聊天", "界面 + 公屏 + 气泡(全部)" }, Default = "只翻译界面", Callback = function(v)
local s = tostring(v)
local chat = s:find("公屏", 1, true) ~= nil
local bub = s:find("气泡", 1, true) ~= nil
T.ChatTranslate, T.BubbleTranslate = chat, bub
if F._cfgSyncing then return end
if chat then pcall(F.ChatTranslateEnable) else pcall(F.ChatTranslateDisable) end
if bub then pcall(F.BubbleTranslateEnable) else pcall(F.BubbleTranslateDisable) end
F.Out("[翻译] 范围 = " .. s)
end })
Tabs.Trans:AddDropdown("TransLang", { Title = "目标语言", Values = { "zh", "en", "ja", "ko", "th", "ru", "ar", "id" },
Default = "zh", Callback = function(v)
C.TransLang = v
if Trans.ShouldCacheClear then Trans.ShouldCacheClear() end
Trans.Cache = {}
if F._cfgSyncing then return end
F.Out("[翻译] 目标语言已切到 " .. tostring(v) .. " ⇒ 正在把界面全部重译一遍")
task.spawn(function() pcall(Trans.RetranslateAll) end)
end })
Tabs.Trans:AddSection("聊天 / 气泡")
Tabs.AC:AddSection("防护 / 反封禁 / 绕过")
F.ProtectTierApply = function(v)
pcall(F.HookFuse, true)
v = tostring(v or "")
local lvl = 0
if v:find("①", 1, true) then lvl = 1 end
if v:find("②", 1, true) then lvl = 2 end
if v:find("③", 1, true) then lvl = 3 end
pcall(F.AntiFlingDisable)
pcall(F.GuiProtectionDisable)
pcall(function() T.CMX_AntiBanAll = false F.CMX_BanAllApply(false) end)
pcall(function() T.BypassTier = "关(什么都不开)" F.BypassTierApply(T.BypassTier) end)
pcall(function() T.ACWriteTier = "① 不改游戏(现状: 反甩 + 护界面 + 权限守卫)" F.ACWriteTierApply(T.ACWriteTier) end)
if lvl == 0 then
T.AntiFling = false T.GuiProtect = false
pcall(F.GuiProtectionDisable)
T.CMX_SpoofIndex = false
pcall(F.CMX_SpoofIndexDisable)
if F._tierHpOwn then
F._tierHpOwn = nil
T.HpBlock = false
F.Out("[防护档位] 已收回档位自己开的「拦受伤上报」")
end
pcall(F.LockFieldsUninstall)
pcall(F.MetaHookUninstall)
pcall(F.CfgSyncUI)
F.Out("[防护档位] 已关 —— 档位自己装的钩子已卸; 你手动开的(血量隔离/静默瞄准/锁血/无敌等)保持不动")
pcall(function() Fluent:Notify({ Title = "防护档位", Content = "已全部关闭", Duration = 4 }) end)
return
end
T.AntiFling = true T.GuiProtect = true T.CharPersist = true
F.Try("AntiFlingEnable", F.AntiFlingEnable)
pcall(F.AuthorityGuard, true)
F.Try("GuiProtectionEnable", F.GuiProtectionEnable)
F.Try("CharPersistEnable", F.CharPersistEnable)
T.CMX_SpoofIndex = true
F.Try("CMX_SpoofIndexEnable", F.CMX_SpoofIndexEnable)
if lvl >= 2 then
T.CMX_AntiBanAll = true
pcall(AC.InstallNamecallHook)
pcall(F.CMX_BanAllApply, true)
if not T.HpBlock then F._tierHpOwn = true end
T.HpBlock = true
pcall(F.HpBlockSet, true)
pcall(F.CMX_TierSync, 2)
F.Try("LockFieldsInstall", F.LockFieldsInstall)
end
if lvl >= 3 then
T.ACWriteTier = "③ + 深度中和(按名中和检测函数 · 最激进)"
pcall(F.ACWriteTierApply, T.ACWriteTier)
T.BypassTier = "④ 全部 + 防拉回档 + 深度中和 ｜ 绕过层: 再+自产登记+栈伪装+身份+FFlag(最激进)"
pcall(F.BypassTierApply, T.BypassTier)
F.Try("LockFieldsInstall", F.LockFieldsInstall)
end
pcall(F.CfgSyncUI)
F.Out("[防护档位] = " .. v)
pcall(function() Fluent:Notify({ Title = "防护档位", Content = v, Duration = 6 }) end)
end
Tabs.AC:AddDropdown("ACMaster", { Title = "★ 防护档位(按需选 · 越轻越稳)", Values = {
"关(什么都不开)",
"① 轻 · 反甩+护界面+权限守卫+属性读伪装(只装 __index 只读钩)",
"② 中 · +namecall 拦上报+拦受伤上报+反封禁4层+温和绕过层(时钟/调试名/Instance)",
"③ 重 · +硬钩子/require拦截/getgc中和+哈希冻结+身份伪装+FFlag ⇒ 14层全开(最激进)",
}, Default = "关(什么都不开)", Callback = function(v)
T.ACMaster = v
if F._cfgSyncing then return end
pcall(F.ProtectTierApply, v)
end })
Tabs.AC:AddToggle("HpBlock", { Title = "血量隔离 + 拦受伤/死亡上报(合成一个)", Description = "拦掉客户端发给服务端的受伤/死亡上报, 同时隔离伪装自己的血量读数 —— 一个开关两件事", Default = false, Callback = function(v) T.HpBlock = v T.HealthIsolate = v if F._cfgSyncing then return end pcall(F.HealthIsolateSet, v) pcall(F.HpBlockSet, v) end })
Tabs.AC:AddSection("扫描 / 收集(一键扫全部 · 结果直接给我)")
Tabs.AC:AddButton({ Title = "★ 一键全扫描(不用选 · 全部扫一遍并自动导出)", Callback = function()
task.spawn(function()
pcall(F.CMX_ScanAll)
Fluent:Notify({ Title = "全扫描完成", Content = "结果已写入日志文件, 直接发给我就行", Duration = 8 })
end)
end })
F.RemoteAudit = function(restore)
local rs = game:GetService("ReplicatedStorage")
local KEYS = { "drop", "carry", "egg", "unequip", "equip", "ragdoll", "fling", "knock", "stun", "kick" }
F._auditOff = F._auditOff or {}
local n, hit = 0, 0
if restore then
for _, c in ipairs(F._auditOff) do pcall(function() c:Enable() end) end
F._auditOff = {}
F.Out("[远程体检] 已还原之前关掉的全部远程回调")
return
end
F.Out("[远程体检] ===== 所有 FireClient 的处理函数 =====")
pcall(function()
for _, d in ipairs(rs:GetDescendants()) do
local cls = d.ClassName
if cls == "RemoteEvent" or cls == "UnreliableRemoteEvent" or cls == "RemoteFunction" then
local conns = nil
pcall(function() conns = getconnections(d.OnClientEvent) end)
if conns and #conns > 0 then
n = n + 1
local nm = tostring(d.Name)
local low = nm:lower()
local sus = false
for _, k in ipairs(KEYS) do if low:find(k, 1, true) then sus = true break end end
local src = "?"
pcall(function()
local f = conns[1].Function
if f then local i = debug.getinfo(f, "s") src = tostring(i and i.source or "?") end
end)
F.Out(string.format("[远程体检] %s · %d 条连接 · 来源 %s%s", nm, #conns, tostring(src):sub(1, 70), sus and "  <<< 名字像掉蛋/收回" or ""))
if sus then
hit = hit + 1
for _, c in ipairs(conns) do
pcall(function() c:Disable() end)
F._auditOff[#F._auditOff + 1] = c
end
end
end
end
end
end)
F.Out("[远程体检] 共 " .. tostring(n) .. " 个有客户端处理的远程 · 关掉像掉蛋/收回的 " .. tostring(hit) .. " 个(可再点一次还原)")
pcall(function() Fluent:Notify({ Title = "远程体检", Content = "检查 " .. tostring(n) .. " 个 · 关掉可疑 " .. tostring(hit) .. " 个", Duration = 10 }) end)
end
F.HookResidue = function()
local layers, ids = 0, {}
pcall(function()
for slot, bucket in pairs(F.MetaLayers or {}) do
for id, rec in pairs(bucket) do
if rec and rec.alive then layers = layers + 1 ids[#ids + 1] = tostring(slot) .. ":" .. tostring(id) end
end
end
end)
local hooked = 0
pcall(function() for _ in pairs(AC._hookedFns or {}) do hooked = hooked + 1 end end)
local ro = "?"
pcall(function()
local mt = getrawmetatable and getrawmetatable(game)
if mt and type(isreadonly) == "function" then ro = tostring(isreadonly(mt)) end
end)
local conns = #(AC._disabledConns or {})
return { layers = layers, ids = ids, hooked = hooked, readonly = ro, conns = conns }
end
F.HookFuse = function(quiet)
if not quiet then F.Out("【熔断】① 开始卸掉所有钩子") end
local steps = {
function() for slot, bucket in pairs(F.MetaLayers or {}) do for id in pairs(bucket) do pcall(F.MetaUninstall, slot, id) end end end,
function() pcall(F.KickGuardPathsDisable) end,
function() pcall(AC.UninstallNamecallHook) end,
function() pcall(AC.UninstallIndexMask) end,
function() pcall(AC.UninstallSetmetatableHook) end,
function() pcall(AC.UninstallPropertyLock) end,
function() pcall(AC.UninstallAntiTP) end,
function() pcall(AC.WatchNewScriptsDisable) end,
function() pcall(AC.WatchNewRemotesDisable) end,
function() pcall(AC.AntiPauseDisable) end,
function() pcall(F.CMX_HookHardRestore) end,
function() pcall(F.CMX_ViewFilterDisable) end,
function() pcall(F.CMX_InstNewDisable) end,
function() pcall(F.CMX_RequireBlockDisable) end,
function() pcall(F.CMX_ClockMaskDisable) end,
function() pcall(F.CMX_DebugMaskDisable) end,
function() pcall(F.CMX_SpoofIndexDisable) end,
function() pcall(F.CMX_NeuterPlusDisable) end,
function() pcall(F.CMX_HashFreezeDisable) end,
function() pcall(F.CMX_BlockReportDisable) end,
function() pcall(F.CMX_CutLogDisable) end,
function() pcall(F.DeepNeuterDisable) end,
function() pcall(F.AntiCheatGCRestore) end,
function() pcall(F.CMX_BanAllApply, false) end,
function() pcall(AC.ReenableDisabledConns) end,
function() pcall(AC.UnblockRemotes) end,
}
for _ = 1, #steps do pcall(steps[_]) end
task.wait(0.35)
if not quiet then F.Out("【熔断】② 残留体检") end
local r = F.HookResidue()
F.Out(string.format("【熔断】残留: 元表层 %d 个%s · 被 hookfunction 的函数 %d 个 · game 元表 readonly=%s · 被禁连接 %d 条",
r.layers, (#r.ids > 0 and ("(" .. table.concat(r.ids, ",") .. ")") or ""), r.hooked, tostring(r.readonly), r.conns))
if r.layers > 0 or r.hooked > 0 or r.conns > 0 then
if not quiet then F.Out("【熔断】③ 还有残留 ⇒ 再清一遍") end
for _ = 1, #steps do pcall(steps[_]) end
task.wait(0.35)
local r2 = F.HookResidue()
F.Out(string.format("【熔断】复检: 元表层 %d · 钩函数 %d · 连接 %d · readonly=%s",
r2.layers, r2.hooked, r2.conns, tostring(r2.readonly)))
if r2.layers == 0 and r2.hooked == 0 and r2.conns == 0 then
F.Out("【熔断】✅ 已清干净 —— 现在脚本等于「没装任何钩子」, 游戏不会再被我们改写")
else
F.Out("【熔断】⚠ 仍有残留(执行器可能不允许还原某些钩子) ⇒ 建议重进一次游戏")
end
else
F.Out("【熔断】✅ 本来就没有残留 —— 已清干净")
end
pcall(function() Fluent:Notify({ Title = "熔断完成", Content = "钩子已卸 + 残留已体检(结果在日志)", Duration = 10 }) end)
end
Tabs.Setting:AddSection("系统")
Tabs.Setting:AddButton({ Title = "★ 远程体检(列出所有 FireClient 处理 + 关掉像掉蛋的)", Description = "第一次点=体检并关掉名字像 drop/carry/egg/unequip/ragdoll/fling/kick 的远程回调; 再点一次=全部还原", Callback = function() pcall(F.RemoteAudit, F._auditOff and #F._auditOff > 0) end })
F.UnloadAll = UnloadAll
Tabs.Setting:AddButton({ Title = "★ 热加载(有新版本才重载 · 已经是最新就不动)", Callback = function() F.HotReload(false) end })
Tabs.Setting:AddButton({ Title = "★ 强制重载(即使已是最新也重下一遍 · 热加载没反应就点这个)", Callback = function() F.HotReload(true) end })
Tabs.Setting:AddButton({ Title = "重新进入服务器(回同一个服务器)", Callback = function() F.RejoinNow() end })
Tabs.Setting:AddButton({ Title = "一键全关(关掉所有功能并还原)", Callback = function() pcall(F.PanicKeyDisableAll) end })
Tabs.Setting:AddButton({ Title = "卸载脚本", Callback = function()
pcall(function() Fluent:Notify({ Title = "卸载", Content = "正在卸载…界面会消失; 日志里会有 [卸载] 复核结果", Duration = 2 }) end)
task.defer(function()
pcall(F.UnloadAll)
pcall(function() F.LogFlush("卸载") end)
end)
end })
F.RecordOriginals()
task.spawn(function() pcall(F.LogBaseName) end)
pcall(function()
local _plat = UIS.TouchEnabled and "触屏(手机/平板)" or "键鼠(PC)"
local _ls = (type(loadstring) == "function" or type(load) == "function") and "有" or "无"
local _wf = (type(writefile) == "function") and "有" or "无"
local _hi = (type(hookmetamethod) == "function" and type(newcclosure) == "function"
and type(getrawmetatable) == "function") and "有" or "无"
local _gc = (type(getgc) == "function") and "有" or "无"
local _tip = " · 功能默认关(要哪个自己点)"
if _hi == "无" or _gc == "无" then
_tip = " · ⚠ 本执行器缺 " .. (_hi == "无" and "hook三件套" or "")
.. (_hi == "无" and _gc == "无" and " 与 " or "")
.. (_gc == "无" and "getgc" or "") .. " ⇒ 依赖它们的少数功能会无效(其余照常)"
end
Fluent:Notify({
Title = "CheatMenu 已加载",
Content = "已加载 " .. F.VERSION .. " · " .. _plat .. " · 钩子:" .. _hi .. " · 读脚本:" .. _ls
.. " · 存档:" .. _wf .. _tip,
Duration = 14,
})
F.Out("[环境] " .. _plat .. " · 钩子:" .. _hi .. " · getgc:" .. _gc .. " · loadstring:" .. _ls
.. " · writefile:" .. _wf .. " —— 标“无”的项只影响依赖它的子功能, 不会让整个脚本失效")
end)
RestoreFeatures()
F.Out("[加载] 没有任何功能会被自动开启 —— 要用什么点什么")
pcall(function()
local ex = "?"
pcall(function() ex = tostring(select(2, pcall(identifyexecutor))) end)
F.Out(string.format("[环境] 执行器=%s · 平台=%s · loadstring=%s · writefile=%s · gethui=%s · 触屏=%s",
ex, (UIS.TouchEnabled and "触屏(手机/平板)" or "键鼠(PC)"),
type(loadstring), type(writefile), type(gethui), tostring(UIS.TouchEnabled)))
end)
pcall(function()
task.spawn(function()
local mine = tostring(F.VERSION or ""):gsub("^v", "")
local urls = F.REMOTE_URLS
local best = nil
if type(urls) == "table" then
for i = 1, math.min(#urls, 3) do
local v = F.GetRemoteVersion(urls[i])
if v and (not best or F.VerNum(v) > F.VerNum(best)) then best = v end
end
end
if not best then return end
if F.VerNum(best) > F.VerNum(mine) then
F.Out("[版本] ⚠ 这次加载的是 v" .. mine .. ", 远端最新是 v" .. best
.. " ⇒ 你跑的是旧副本(执行器缓存/旧脚本), 新版修复不会生效")
pcall(function() Fluent:Notify({ Title = "⚠ 你加载的是旧版本", Content = "本地 v" .. mine
.. " · 远端 v" .. best .. " —— 请点「★ 强制重载」或重新跑网络加载器", Duration = 20 }) end)
else
F.Out("[版本] 已是最新: v" .. mine .. " (远端 v" .. best .. ")")
end
end)
end)
F.Out("[CheatMenu] ✅ 加载完成 " .. F.VERSION)
end
function F.CloseDropdowns()
if not (Fluent and Fluent.Options) then return end
for _, opt in pairs(Fluent.Options) do
if type(opt) == "table" and opt.Open then
pcall(function() opt:Close() end)
if opt.Open then
pcall(function() if opt.DropdownFrame then opt.DropdownFrame.Visible = false end end)
pcall(function() if opt.DropdownList then opt.DropdownList.Visible = false end end)
end
end
end
end
local _polishCache, _polishAt = nil, 0
local function polishToggleVisuals()
if not (Fluent and Fluent.GUI) then return end
local now = os.clock()
local need = (_polishCache == nil) or (now - _polishAt > 10)
if not need then
for i = 1, #_polishCache do
if not _polishCache[i].Parent then need = true break end
end
end
if need then
local ok, desc = pcall(function() return F.walk(Fluent.GUI) end)
if not ok or not desc then return end
_polishCache = {}
for i = 1, #desc do
local obj = desc[i]
if obj:IsA("ImageLabel") and tostring(obj.Image or ""):find("12266946128", 1, true) then
_polishCache[#_polishCache + 1] = obj
end
end
_polishAt = now
end
for _, obj in ipairs(_polishCache) do
if obj.Parent then
local isOn = obj.Position.X.Offset >= 15
if isOn then
obj.ImageColor3 = Color3.fromRGB(255, 255, 255)
obj.ImageTransparency = 0
else
obj.ImageColor3 = Color3.fromRGB(150, 150, 150)
obj.ImageTransparency = 0.45
end
end
end
end
local function startTogglePolish()
if getgenv and getgenv().CM_TogglePolish then return end
if getgenv then getgenv().CM_TogglePolish = true end
task.spawn(function()
while true do
polishToggleVisuals()
task.wait(0.3)
end
end)
end
local function addToggleButton(Window)
local sg = Instance.new("ScreenGui")
if getgenv then getgenv().CM_ToggleSG = sg end
sg.Name = "MenuButton"
pcall(function() sg:SetAttribute("CMOwned", true) end)
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = gethui and gethui() or game:GetService("CoreGui")
local btn = Instance.new("TextButton")
btn.Size = UDim2.fromOffset(46, 46)
btn.Position = UDim2.new(1, -56, 0.5, -23)
btn.Text = "☰"
btn.TextSize = 22
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
btn.BackgroundTransparency = 0.25
btn.BorderSizePixel = 0
btn.AutoButtonColor = false
btn.Parent = sg
local uc = Instance.new("UICorner")
uc.CornerRadius = UDim.new(1, 0)
uc.Parent = btn
local dragging, dragStart, btnStart = false, nil, nil
btn.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
btnStart = btn.Position
end
end)
UIS.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
btn.Position = UDim2.new(btnStart.X.Scale, btnStart.X.Offset + delta.X, btnStart.Y.Scale, btnStart.Y.Offset + delta.Y)
end
end)
UIS.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = false
end
end)
btn.MouseButton1Click:Connect(function()
local w = Window or (getgenv and getgenv().CM_Window)
local gui = w and w.escmenu
if gui then gui.Visible = not gui.Visible
elseif w and w.Minimize then w:Minimize() end
end)
end
addToggleButton(Window)
startTogglePolish()
end
pcall(function()
if F.NukeAllGUIs then
local k = F.NukeAllGUIs(false)
if k > 0 then F.Out("[清理] 建界面前已清掉 " .. tostring(k) .. " 个残留界面") end
end
end)
F._cfgSyncing = true
local okBuild, buildErr = pcall(buildMenu)
F._cfgSyncing = false
if not okBuild then
F.Out("[UI] ⚠ 菜单构建中断 ⇒ 断点之后的控件全都没建出来! 原因: " .. tostring(buildErr))
F.Out("[UI] 把上面这一行发出来, 就能立刻定位是哪个控件把菜单带塌的")
end
task.defer(function() F._cfgSyncing = false end)
task.spawn(function()
local wasOpen = F.MenuOpen()
while true do
task.wait(0.25)
local now = F.MenuOpen()
if wasOpen and not now then pcall(F.CloseDropdowns) end
wasOpen = now
end
end)
F.CFG_NOSYNC = { AimOn = true, LockCam = true, Freecam = true, TPMouse = true }
function F.CfgSyncUI()
local op = Fluent and Fluent.Options
if type(op) ~= "table" then return 0 end
local n = 0
F._cfgSyncing = true
pcall(function()
for name, opt in pairs(op) do
if type(name) == "string" and type(opt) == "table" and type(opt.Set) == "function" then
local dyn = F.CFG_NOSYNC[name] == true
for _, k in ipairs(F.PLAYER_DROPDOWNS) do
if k == name then dyn = true break end
end
if not dyn then
local cur = opt.Value
local ty = opt.Type
if type(ty) ~= "string" then
if type(cur) == "boolean" then ty = "Toggle"
elseif type(cur) == "number" then ty = "Slider"
elseif type(cur) == "table" then ty = "Dropdown"
elseif type(cur) == "string" then ty = "Input" end
end
local want
if ty == "Toggle" then
want = T[name]
else
want = C[name]
if want == nil then want = T[name] end
end
if want ~= nil and type(want) == type(cur) and want ~= cur then
local ok = true
if ty == "Dropdown" then
ok = false
pcall(function()
for _, x in pairs(opt.Values or {}) do
if x == want then ok = true break end
end
end)
if not ok then
pcall(function()
for x in pairs(opt.Values or {}) do
if x == want then ok = true break end
end
end)
end
end
if ok and pcall(function() opt:Set(want) end) then n = n + 1 end
end
end
end
end
end)
F._cfgSyncing = false
return n
end
task.spawn(function()
pcall(function()
if C.FlyDisguise == nil then
C.FlyDisguise = "关闭"
end
local n = F.CfgSyncUI()
pcall(F.SyncMoveUI)
if n and n > 0 then F.Out("[CheatMenu] 已按存档同步 " .. n .. " 个控件的界面状态") end
pcall(function()
local keep = getgenv and getgenv().CM_RELOAD_KEEP
if type(keep) ~= "table" then return end
getgenv().CM_RELOAD_KEEP = nil
local c = 0
for k, v in pairs(keep) do
if v == true then T[k] = true c = c + 1 end
end
local n2 = F.CfgSyncUI()
F.Out("[热加载] 已恢复上次开着的 " .. tostring(c) .. " 个开关 (" .. tostring(n2) .. " 个控件)")
end)
end)
end)
T.AntiAFK, T.KickGuard = true, true
F.Try("AntiAFKEnable", F.AntiAFKEnable)
F.Try("KickGuardEnable", F.KickGuardEnable)
F.Out("[挂机防踢] 默认已开(防挂机 + 防踢)")
