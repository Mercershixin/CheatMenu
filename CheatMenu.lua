print(('[CheatMenu] build 2026-10-02 19:05 sha de897e55 bytes 317790'):format('2026-10-02 19:05','de897e55',317790))
local F = {}
F.VERSION = "v11.6.1"
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
local ch = LP.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
local root = (hum and ch:FindFirstChild("HumanoidRootPart")) or (ch and ch:FindFirstChild("HumanoidRootPart"))
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
local function ok2(o)
if not (o and o.Name == name) then return nil end
if o:IsA(cls) then return o end
local okU, isU = pcall(function() return o:IsA("UnreliableRemoteEvent") end)
if cls == "RemoteEvent" and okU and isU then return o end
return nil
end
local sh = RStorage:FindFirstChild("Shared")
local pk = sh and sh:FindFirstChild("Packages")
local net = pk and pk:FindFirstChild("Network")
if net then
local pre = (cls == "RemoteEvent") and "rev_" or "ref_"
local r = ok2(net:FindFirstChild(pre .. name)) or ok2(net:FindFirstChild(pre .. tostring(name):gsub("%.", "_")))
if r then RRemoteCache[ck] = r return r end
end
local leaf = tostring(name):match("([^%.]+)$") or name
local q, qh, qt = { RStorage }, 1, 1
local budget = 6000
while qh <= qt and budget > 0 do
local node = q[qh] qh = qh + 1 budget = budget - 1
local ok, kids = pcall(function() return node:GetChildren() end)
if ok and type(kids) == "table" then
for i = 1, #kids do
local c = kids[i]
if c.Name == name or c.Name == leaf then
local rr = ok2(c)
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
local function OnRemote(n, cb)
local r = REvent(n)
if r then pcall(function() r.OnClientEvent:Connect(function(...) pcall(cb, ...) end) end) end
end
local SaveFile = "CheatMenu_Config_v1.json"
local function SaveConfig()
pcall(function() if writefile then writefile(SaveFile, HS:JSONEncode({ T = T, C = C })) end end)
end
local function LoadConfig()
pcall(function()
if not readfile or not isfile or not isfile(SaveFile) then return end
local d = HS:JSONDecode(readfile(SaveFile))
if type(d) == "table" then
if type(d.T) == "table" then
for k, v in pairs(d.T) do
if type(v) ~= "boolean" then T[k] = v end
end
end
if type(d.C) == "table" then for k, v in pairs(d.C) do C[k] = v end end
end
end)
end
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
function F.MetaInstall(slot, target, id, wrapperFactory)
if not (hookmetamethod and newcclosure and getrawmetatable) then return nil end
if type(slot) ~= "string" or type(id) ~= "string" or target == nil then return nil end
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
local wrapped
local okW = pcall(function()
wrapped = newcclosure(function(self, ...)
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
bucket[id] = rec
return wrapped
end
function F.MetaUninstall(slot, id)
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
local b = F.MetaLayers[slot]
return (b and b[id] and b[id].alive) and true or false
end
function AC.InstallNamecallHook()
if AC._nc then return true end
local got = F.MetaInstall("__namecall", game, "AC", function(box)
return function(self, ...)
local method = getnamecallmethod and getnamecallmethod() or ""
if (method == "FireServer" or method == "InvokeServer") and T.RemoteBlock and not checkcaller() then
local name = tostring(self and self.Name or ""):lower()
for _, kw in ipairs(AC.BLOCK_KEYS) do
if name:find(kw, 1, true) then return nil end
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
local ok = F.MetaUninstall("__namecall", "AC")
AC._nc = false
AC._ncLayer = nil
return ok
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
AC._propLockOn = false
AC._propLockOld = nil
function AC.InstallPropertyLock()
if AC._propLockOn then return true end
if not (hookmetamethod and newcclosure) then return false end
local ok, res = pcall(function()
return hookmetamethod(game, "__newindex", newcclosure(function(t, k, v)
if (T.ACBypass or T.PropertyLock) and not checkcaller() then
if typeof(t) == "Instance" then
local isHum = false
pcall(function() isHum = t:IsA("Humanoid") end)
if isHum and (k == "WalkSpeed" or k == "JumpPower" or k == "JumpHeight") then
local _, hum = GC()
if hum and t == hum then
if k == "WalkSpeed" then
if T.SpeedOn then v = (F._baseWalk or 16) * 2 end
elseif k == "JumpPower" then
if T.InfiniteJump or T.SpeedOn then v = 50 end
elseif k == "JumpHeight" then
if T.InfiniteJump then v = 7.5 end
end
end
end
end
end
return AC._propLockOld(t, k, v)
end))
end)
if ok and type(res) == "function" then
AC._propLockOld = res
AC._propLockOn = true
return true
end
return false
end
function AC.UninstallPropertyLock()
if AC._propLockOn and hookmetamethod and AC._propLockOld then
pcall(function() hookmetamethod(game, "__newindex", AC._propLockOld) end)
end
AC._propLockOn = false
AC._propLockOld = nil
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
if (T.SpeedMask or T.ACBypass or T.PropertyLock) and not checkcaller() and typeof(t) == "Instance" then
local _, hum = GC()
if hum and t == hum then
if k == "WalkSpeed" then return F._baseWalk or 16 end
if k == "JumpPower" then return 50 end
if k == "JumpHeight" then return 7.5 end
if k == "MaxHealth" or k == "Health" then
local v = (k == "MaxHealth") and hum.MaxHealth or hum.Health
if type(v) == "number" and v > 100 then return 100 end
end
end
if k == "GetFullName" and AC.isOwnChar(t) then return AC._HIDE_FAKE end
end
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
pcall(function() c:Disable() end)
out.disabled = out.disabled + 1
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
local hardSigs, softSigs = {}, {}
local function add(list, sig) if sig then list[#list + 1] = sig end end
if hum then
pcall(function() add(hardSigs, hum:GetPropertyChangedSignal("WalkSpeed")) end)
pcall(function() add(hardSigs, hum:GetPropertyChangedSignal("JumpPower")) end)
pcall(function() add(hardSigs, hum:GetPropertyChangedSignal("JumpHeight")) end)
pcall(function() add(hardSigs, hum:GetPropertyChangedSignal("Health")) end)
pcall(function() add(hardSigs, hum:GetPropertyChangedSignal("MaxHealth")) end)
pcall(function() add(hardSigs, hum.Changed) end)
pcall(function() add(hardSigs, hum.StateChanged) end)
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
F.Out(string.format("[CheatMenu] 连接清理: 扫描 %d 条, 禁用 %d 条", out.scanned, out.disabled))
return out.disabled, out.scanned
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
if n > 6000 then break end
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
F.Out("[采集] 玩完点「一键全量导出」, 内容会复制到剪贴板, 直接粘给我即可")
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
F._logBaseName = string.format("CheatMenu_log_%s_%s", gname, pid)
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
F.Out("[日志] ⚠ 执行器不支持 readfile/writefile, 内容只留在 F9 控制台(点「一键全量导出」可复制)")
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
local seenInst = {}
local function note(inst, tag, where)
if typeof(inst) ~= "Instance" or seenInst[inst] then return end
if not (inst:IsA("ModuleScript") or inst:IsA("LocalScript") or inst:IsA("Script")) then return end
seenInst[inst] = true
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
local n = 0
if type(getloadedmodules) == "function" then
local ok, mods = pcall(getloadedmodules)
if ok and type(mods) == "table" then
for i = 1, #mods do n = n + 1 note(mods[i], "已加载模块", "getloadedmodules") end
end
end
if type(getnilinstances) == "function" then
local ok, arr = pcall(getnilinstances)
if ok and type(arr) == "table" then
for i = 1, #arr do n = n + 1 note(arr[i], "隐藏(Parent=nil)", "getnilinstances") end
end
end
if type(getinstances) == "function" then
local ok, arr = pcall(getinstances)
if ok and type(arr) == "table" then
for i = 1, #arr do
if i % F.LIMITS.SCAN_YIELD_EVERY == 0 then task.wait() end
if i > F.LIMITS.SCAN_SCRIPT_CAP then break end
n = n + 1
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
n = n + 1
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
function F.IsOurs(f)
if type(f) ~= "function" then return false end
local ok, s = pcall(dbgGetInfo, f, "s")
return ok and F.IsOursSrc(tostring(s or ""):lower())
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
local nm = ""
pcall(function()
local sc = c.script
if sc then nm = tostring(sc.Name):lower() end
end)
if nm:find("afk") or nm:find("idle") or nm:find("timeout") or nm:find("anticheat")
or nm:find("detect") or nm:find("anti") or nm:find("guard") or nm:find("kick")
or nm:find("boot") then
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
pcall(F.KickGuardPathsEnable)
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
if T.SpeedGuard and m == "ChangeState" and KG.blockSet[self] then
local st = select(1, ...)
if st == Enum.HumanoidStateType.Physics then
KG.blocked7 = (KG.blocked7 or 0) + 1
return nil
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
end
function F.KickGuardEnable()
if KG.hooked then return true end
F.Out("[防踢] 正在装「Kick 三路径拦截」(会改写全局元表) —— 个别反作弊会因这层 hook 直接踢你; 平时建议关着, 挂机前再开")
pcall(F.KickGuardPathsEnable)
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
C.Blacklist = {}
function F.AddPriorityTarget(name) C.PriorityTargets[name] = true end
function F.AddBlacklist(name) C.Blacklist[name] = true end
function F.PlayerNames()
local n = {}
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP then n[#n + 1] = pl.Name end
end
table.sort(n)
if #n == 0 then n[1] = "(无人)" end
return n
end
F.PLAYER_DROPDOWNS = { "TPTarget", "PriorityTarget", "BlacklistTarget", "FlingTarget" }
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
function F.AimPick()
local cam = workspace.CurrentCamera
if not cam then return nil end
local vp = cam.ViewportSize
local cx, cy = vp.X / 2, vp.Y / 2
local fov = tonumber(C.AimFOV) or 200
local function inTbl(t, nm)
if type(t) ~= "table" then return false end
for k, v in pairs(t) do
if v == nm or k == nm then return true end
end
return false
end
local rp = RaycastParams.new()
rp.FilterType = Enum.RaycastFilterType.Exclude
local ex = {}
if LP.Character then ex[#ex + 1] = LP.Character end
local best, bestScore = nil, nil
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and not inTbl(C.Blacklist, pl.Name) then
local ch = pl.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
if hrp and hum and hum.Health > 0 then
local skip = false
if T.AimTeamCheck and LP.Team ~= nil then
pcall(function()
if pl.Team ~= nil and pl.Team == LP.Team then skip = true end
if not skip and pl.TeamColor ~= nil and pl.TeamColor == LP.TeamColor then skip = true end
end)
end
if not skip then
local score = nil
if T.Aim360 then
local d3 = (cam.CFrame.Position - hrp.Position).Magnitude
if d3 <= fov then score = d3 end
else
local sp, onScreen = cam:WorldToScreenPoint(hrp.Position)
if onScreen then
local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(cx, cy)).Magnitude
if d <= fov then score = d end
end
end
if score then
do
if T.AimWallCheck then
ex[#ex + 1] = ch
rp.FilterDescendantsInstances = ex
local hit = workspace:Raycast(cam.CFrame.Position, (hrp.Position - cam.CFrame.Position), rp)
ex[#ex] = nil
if hit and hit.Instance then skip = true end
end
if not skip then
score = score - (inTbl(C.PriorityTargets, pl.Name) and 1e6 or 0)
if not bestScore or score < bestScore then best, bestScore = hrp, score end
end
end
end
end
end
end
end
return best
end
F._fireAt = 0
function F.FireOnce()
if type(mouse1click) == "function" then
if pcall(mouse1click) then return "mouse1click()" end
end
local viaVu = nil
pcall(function()
local vu = game:GetService("VirtualUser")
local cam = workspace.CurrentCamera
local vp = cam and cam.ViewportSize or Vector2.new(400, 400)
vu:CaptureController()
vu:ClickButton1(Vector2.new(vp.X / 2, vp.Y / 2))
pcall(function() vu:ReleaseController() end)
viaVu = "VirtualUser(屏幕中心)"
end)
if viaVu then return viaVu end
local viaTool = nil
pcall(function()
local ch = LP.Character
local tool = ch and ch:FindFirstChildOfClass("Tool")
if tool then tool:Activate() viaTool = "tool:Activate()" end
end)
if viaTool then return viaTool end
local viaBtn = nil
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
viaBtn = "屏幕按钮:" .. tostring(b.Name)
elseif type(getconnections) == "function" then
for _, c in ipairs(getconnections(b.MouseButton1Click)) do
pcall(function() c:Fire() end)
viaBtn = "屏幕按钮:" .. tostring(b.Name)
end
end
end
end)
return viaBtn
end
function F.AutoFire(tgt)
if not (T.AutoFire and tgt) then return end
local now = os.clock()
if now - (F._fireAt or 0) < (tonumber(C.AutoFireGap) or 0.1) then return end
F._fireAt = now
F.FireOnce()
end
function F.EnsureAimOn()
if T.AimOn then return end
T.AimOn = true
pcall(function() F.AimSet(true) end)
pcall(function()
local o = Fluent and Fluent.Options and Fluent.Options.AimOn
if o and o.Set and o.Value ~= true then o:Set(true) end
end)
F.Out("[自瞄] 已顺手把「自瞄」一起打开 —— 它才是总开关；只勾 360°/自动开火 是没有任何效果的")
end
function F.CombatCheck()
local cam = workspace.CurrentCamera
if not cam then F.Out("[战斗体检] 还没有相机(角色没加载完), 稍后再点"); return end
local vp = cam.ViewportSize
local cx, cy = vp.X / 2, vp.Y / 2
local fov = tonumber(C.AimFOV) or 200
F.Out("════════ 战斗体检 ════════")
local teamTxt = "关"
if T.AimTeamCheck then
teamTxt = "开(我的队伍=" .. tostring(LP.Team and LP.Team.Name or "无") .. ")"
end
F.Out("范围模式: " .. (T.Aim360 and "360°(按世界距离)" or "屏幕圈(按像素)")
.. " · 范围值 " .. tostring(math.floor(fov)) .. (T.Aim360 and " 格" or " px")
.. " · 墙壁检查=" .. (T.AimWallCheck and "开" or "关")
.. " · 同队过滤=" .. teamTxt)
F.Out(string.format("开关状态: 自瞄=%s · 自动开火=%s · 开火才锁=%s · 开火间隔=%.2fs · 平滑=%d",
T.AimOn and "★开" or "✗关(这个不开, 下面全都不会动)", T.AutoFire and "开" or "关",
T.AimFireOnly and "开" or "关", tonumber(C.AutoFireGap) or 0.1, tonumber(C.AimSmooth) or 5))
if not T.AimOn then
F.Out("⇒ 结论: 「自瞄」是关的 —— 360°/自动开火/FOV圈 都只是它的附属项, 先打开「自瞄」。")
end
local rp = RaycastParams.new()
rp.FilterType = Enum.RaycastFilterType.Exclude
local ex = {}
if LP.Character then ex[#ex + 1] = LP.Character end
local total, lockable, reasons = 0, 0, {}
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP then
total = total + 1
local why = nil
local ch = pl.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
local dist = hrp and (cam.CFrame.Position - hrp.Position).Magnitude or nil
if not ch then
why = "没有角色(还没加载/正在重生)"
elseif not hrp then
why = "没有 HumanoidRootPart"
elseif not hum then
why = "没有 Humanoid"
elseif hum.Health <= 0 then
why = "已死(血 " .. tostring(math.floor(hum.Health)) .. ")"
else
local bl = false
if type(C.Blacklist) == "table" then
for k, v in pairs(C.Blacklist) do
if v == pl.Name or k == pl.Name then bl = true end
end
end
if bl then
why = "在你的黑名单里"
elseif T.AimTeamCheck and LP.Team ~= nil then
local same = false
pcall(function()
if pl.Team ~= nil and pl.Team == LP.Team then same = true end
if not same and pl.TeamColor ~= nil and pl.TeamColor == LP.TeamColor then same = true end
end)
if same then why = "同队(" .. tostring(pl.Team and pl.Team.Name or tostring(pl.TeamColor)) .. ") ⇒ 被同队过滤" end
end
if not why then
if T.Aim360 then
if dist and dist > fov then why = string.format("太远 %.0f 格 > %d 格", dist, math.floor(fov)) end
else
local sp, onScreen = cam:WorldToScreenPoint(hrp.Position)
if not onScreen then
why = "不在屏幕里(在背后/视野外) ⇒ 开「360°锁敌」"
else
local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(cx, cy)).Magnitude
if d > fov then why = string.format("在 FOV 圈外(%.0f px > %d px)", d, math.floor(fov)) end
end
end
end
if not why and T.AimWallCheck then
ex[#ex + 1] = ch
rp.FilterDescendantsInstances = ex
local hint = workspace:Raycast(cam.CFrame.Position, (hrp.Position - cam.CFrame.Position), rp)
ex[#ex] = nil
if hint and hint.Instance then why = "被挡住: " .. hint.Instance:GetFullName() end
end
end
if why then
reasons[#reasons + 1] = why
F.Out("  ✗ " .. pl.Name .. " · " .. why)
else
lockable = lockable + 1
F.Out(string.format("  ✓ %s · 可锁 · %s", pl.Name,
dist and string.format("%.0f 格", dist) or "?"))
end
end
end
F.Out(string.format("── 本局除我 %d 人 · 可锁 %d 人 ──", total, lockable))
if total > 0 and lockable == 0 then
local cnt, top, tv = {}, nil, 0
for _, r in ipairs(reasons) do cnt[r] = (cnt[r] or 0) + 1 end
for k, v in pairs(cnt) do if v > tv then top, tv = k, v end end
F.Out(string.format("⇒ 一个都锁不到。最主要原因: %s (占 %d/%d) —— 按上面每行的说明处理即可", tostring(top), tv, total))
end
F.Out("── 开火链 ──")
F.Out("  mouse1click: " .. (type(mouse1click) == "function" and "有(优先用它)" or "没有 ⇒ 用 VirtualUser 兜底"))
local hasVu = false
pcall(function() hasVu = (game:GetService("VirtualUser") ~= nil) end)
F.Out("  VirtualUser: " .. (hasVu and "有" or "没有"))
local tool = nil
pcall(function()
local ch = LP.Character
if ch then tool = ch:FindFirstChildOfClass("Tool") end
end)
F.Out("  当前装备: " .. (tool and ("有 · " .. tool.Name) or "(空手) —— 近战/枪械必须拿着武器才会开火") )
local via = F.FireOnce()
F.Out("  试发一次: " .. (via and ("成功 · 走的是 " .. via) or "三条路都没成功(该执行器三条都不支持)") .. " · 没听到枪声/挥砍就说明游戏侧没收到这次输入")
F.Out("══════════════════════")
end
function F.AimSet(on)
T.AimOn = on and true or false
if F._aimConn then pcall(function() RS:UnbindFromRenderStep("CM_Aim") end) F._aimConn = nil end
if not T.AimOn then return end
F._aimConn = true
RS:BindToRenderStep("CM_Aim", Enum.RenderPriority.Camera.Value + 1, function()
if not T.AimOn then F.AimSet(false) return end
local firing = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
if not firing and UIS.TouchEnabled and F._touchDown then
local _, hum = GC()
local md = hum and hum.MoveDirection
if md and md.Magnitude > 0.1 then firing = false else firing = true end
end
if T.AimFireOnly and not T.AutoFire and not firing then return end
local _, hum = GC()
if not hum then return end
local cam = workspace.CurrentCamera
local tgt = F.AimPick()
if not (cam and tgt) then return end
local want = CFrame.lookAt(cam.CFrame.Position, tgt.Position)
cam.CFrame = cam.CFrame:Lerp(want, 1 / math.max(1, tonumber(C.AimSmooth) or 5))
F.AutoFire(tgt)
end)
end
local GodConn = nil
local function GodDisable() if GodConn then GodConn:Disconnect() GodConn = nil end end
local function GodEnable()
if GodConn then return end
local function apply()
local _, hum = GC()
if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
end
apply()
GodConn = RS.Stepped:Connect(apply)
end
F.KillAuraConn = nil
F.lastAttack = 0
function F.KillAuraEnable()
if F.KillAuraConn then return end
F.KillAuraConn = RS.Heartbeat:Connect(function()
if not T.KillAura then F.KillAuraDisable() return end
local _, _, root = GC()
if not root then return end
local range = C.KillAuraRange or 20
local rp = root.Position
local targets = {}
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then
local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
local hum = pl.Character:FindFirstChildOfClass("Humanoid")
if hrp and hum and hum.Health > 0 then
local d = (rp - hrp.Position).Magnitude
if d <= range and not (T.AimTeamCheck and pl.Team == LP.Team) then
targets[#targets + 1] = { pl = pl, hrp = hrp, dist = d }
end
end
end
end
if #targets == 0 then return end
local aps = tonumber(C.KillAuraSpeed) or 10
local delay = math.clamp(1 / math.max(0.5, aps), 0.03, 1)
local now = os.clock()
if now - (F.lastAttack or 0) < delay then return end
F.lastAttack = now
table.sort(targets, function(a, b) return a.dist < b.dist end)
local pick
F._killAuraIdx = ((F._killAuraIdx or 0) % #targets) + 1
pick = targets[F._killAuraIdx]
if not pick then return end
local cam = workspace.CurrentCamera
if cam then cam.CFrame = CFrame.lookAt(cam.CFrame.Position, pick.hrp.Position) end
pcall(function() F.FireOnce() end)
end)
end
function F.KillAuraDisable()
if F.KillAuraConn then F.KillAuraConn:Disconnect() F.KillAuraConn = nil end
F.lastAttack = 0
F._killAuraIdx = 0
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
local lim = math.max(200,
(T.SpeedOn and (tonumber(C.SpeedValue) or 0) or 0) * 1.5,
(T.FlyOn and (tonumber(C.FlyValue) or 0) or 0) * 1.5)
if root.AssemblyLinearVelocity.Magnitude > lim then
pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0) end)
pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
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
T.SteadyOn, T.HitGuard, T.HitLock = steady, hit, lock
T.TrapWarn, T.TrapDodge, T.SpeedAntiTP = trap, dodge, atp
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
trap and (dodge and "拦截+弹开" or "拦截") or "关", atp and "开" or "关", bypass and "开" or "关"))
end
F.FLOOR_KEYS = { "treadmill", "tread", "belt", "conveyor", "walk", "mill", "runner", "speedpad" }
F._floorLast = {}
function F.OnMovingFloor()
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
if nm:find(k, 1, true) then task.defer(F.SpeedAntiTPKillScripts) break end
end
end)
end)
end)
F.Out(string.format("[防拉回] 已清理 %d 个客户端检测脚本 · 禁用 %d 条检测连接 · 中和 %d 个检测函数(公开作品同款做法)",
dead, conns, neutered))
end
F.HIT_KEYS = { "rigsync", "knockback", "knock", "ragdoll", "combatservice", "useitem",
"stun", "tumble", "pushed", "fling", "blown", "launch" }
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
if F.OnMovingFloor() and st ~= Enum.HumanoidStateType.Ragdoll
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
if T.HitLock then pcall(function() hum.Health = hum.MaxHealth end) end
end)
end
F.TRAP_KEYS = { "trap", "bear", "spike", "snare", "landmine", "mine", "banana", "cage", "jail",
"net", "hook", "poison", "lava", "saw", "trapdoor", "shock", "taser", "tnt" }
F._trapConn = nil
function F.TrapGuardDisable()
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
F._trapConn = RS.Heartbeat:Connect(function()
if not T.TrapWarn then F.TrapGuardDisable() return end
local now = os.clock()
if now - (F._trapAt or 0) < 0.4 then return end
F._trapAt = now
local _, _, root = GC()
if not root then return end
local hits = 0
pcall(function()
local op = OverlapParams.new()
op.FilterType = Enum.RaycastFilterType.Exclude
if LP.Character then op.FilterDescendantsInstances = { LP.Character } end
for _, pt in ipairs(workspace:GetPartBoundsInRadius(root.Position, 45, op)) do
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
if T.TrapDodge and now - (F._trapDodgeAt or 0) > 0.8 then
F._trapDodgeAt = now
pcall(function()
local dir = root.Position - pt.Position
dir = Vector3.new(dir.X, 0, dir.Z)
if dir.Magnitude > 0.1 then
local vv = root.AssemblyLinearVelocity
local push = dir.Unit * 60
root.AssemblyLinearVelocity = Vector3.new(push.X, math.max(vv.Y, 30), push.Z)
end
end)
end
end
end
end)
if hits > 0 and now - (F._trapLogAt or 0) > 5 then
F._trapLogAt = now
F._trapHits = (F._trapHits or 0) + hits
F.Out("[陷阱] 已让附近 " .. tostring(hits) .. " 个陷阱失效(只关陷阱自己的 CanTouch, 不动你的角色) · 累计 " .. tostring(F._trapHits))
end
end)
end
F._steadyConn = nil
local STEADY_STATES = { "Ragdoll", "FallingDown", "PlatformStanding" }
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
if not hum.PlatformStand then pcall(function() F.SteadyStates(false) end) end
if F.OnMovingFloor() then
if not F._steadyFloorLog then
F._steadyFloorLog = true
F.Out("[稳身] 检测到跑步机/移动平台 ⇒ 本项暂时让路(免得把你甩下来)")
end
return
end
F._steadyFloorLog = nil
local st = nil
pcall(function() st = hum:GetState() end)
if st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Ragdoll then
pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
F._steadyHits = (F._steadyHits or 0) + 1
end
local v = root.AssemblyLinearVelocity
local lim = math.max(200, (T.SpeedOn and (tonumber(C.SpeedValue) or 0) or 0) * 1.5,
(T.FlyOn and (tonumber(C.FlyValue) or 0) or 0) * 1.5)
if v.Magnitude > lim then
pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, math.min(v.Y, 50), 0) end)
pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
F._steadyHits = (F._steadyHits or 0) + 1
if os.clock() - (F._steadyLogAt or 0) > 3 then
F._steadyLogAt = os.clock()
F.Out(string.format("[稳身] 挡下异常速度 %.0f 格/秒(上限 %.0f) · 累计 %d 次",
v.Magnitude, lim, F._steadyHits or 0))
end
end
local okSt = (st == Enum.HumanoidStateType.Jumping or st == Enum.HumanoidStateType.Freefall
or st == Enum.HumanoidStateType.Climbing or hum.PlatformStand)
if v.Y > 90 and not okSt then
pcall(function() root.AssemblyLinearVelocity = Vector3.new(v.X, 40, v.Z) end)
end
end)
end
F.HitboxBackup = {}
F.HB_PARTS = { "HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "Torso" }
function F.HitboxApplyOne(pl, k)
if not pl or pl == LP or not pl.Character then return end
local target = tonumber(C.HitboxSize) or 10
for pi = 1, #F.HB_PARTS do
local part = pl.Character:FindFirstChild(F.HB_PARTS[pi])
if part then
local bak = F.HitboxBackup[part]
if not bak then
bak = {
Size = part.Size,
Transparency = part.Transparency,
CanCollide = part.CanCollide,
Massless = part.Massless,
}
F.HitboxBackup[part] = bak
end
local nx = bak.Size.X + (math.max(bak.Size.X, target) - bak.Size.X) * k
local ny = bak.Size.Y + (math.max(bak.Size.Y, target) - bak.Size.Y) * k
local nz = bak.Size.Z + (math.max(bak.Size.Z, target) - bak.Size.Z) * k
pcall(function()
part.Size = Vector3.new(nx, ny, nz)
part.Transparency = 1
part.CanCollide = false
part.Massless = true
end)
end
end
end
function F.HitboxExpandEnable()
F._hbGen = (F._hbGen or 0) + 1
local myGen = F._hbGen
F._hbProg = task.spawn(function()
for step = 1, 4 do
if not T.HitboxExpand or myGen ~= F._hbGen then break end
local k = step / 4
for _, pl in ipairs(Players:GetPlayers()) do
F.HitboxApplyOne(pl, k)
end
task.wait(0.15)
end
if myGen == F._hbGen then F._hbProg = nil end
end)
F._hbExPlConns = F._hbExPlConns or {}
local function bindHb(pl)
if pl == LP or F._hbExPlConns[pl] then return end
F._hbExPlConns[pl] = pl.CharacterAdded:Connect(function()
task.wait(0.4)
if not T.HitboxExpand then return end
F.HitboxApplyOne(pl, 1)
end)
end
if not F._hbExAddedConn then
F._hbExAddedConn = Players.PlayerAdded:Connect(function(pl)
bindHb(pl)
task.wait(0.4)
if T.HitboxExpand then F.HitboxApplyOne(pl, 1) end
end)
end
for _, pl in ipairs(Players:GetPlayers()) do bindHb(pl) end
end
function F.HitboxExpandDisable()
for part, bak in pairs(F.HitboxBackup) do
if typeof(part) == "Instance" and part.Parent then
pcall(function()
part.Size = bak.Size
part.Transparency = bak.Transparency
part.CanCollide = bak.CanCollide
part.Massless = bak.Massless
end)
end
end
F.HitboxBackup = {}
F._hbGen = (F._hbGen or 0) + 1
F._hbProg = nil
if F._hbExAddedConn then pcall(function() F._hbExAddedConn:Disconnect() end) F._hbExAddedConn = nil end
for pl, c in pairs(F._hbExPlConns or {}) do pcall(function() c:Disconnect() end) end
F._hbExPlConns = {}
end
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
if not T.Invisible then return end
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
local function eggTP(cf)
local _, _, r = GC()
if not r or not cf then return end
if F.DropIntent then pcall(F.DropIntent) end
pcall(function() r:PivotTo(cf) end)
pcall(function()
r.AssemblyLinearVelocity = Vector3.zero
r.AssemblyAngularVelocity = Vector3.zero
end)
end
F.EGG_BAD = { "pen", "gate", "door", "wall", "floor", "spawn", "sign", "billboard",
"part", "frame", "button", "light", "lamp", "tree", "grass", "rock", "road", "path",
"touplate", "trigger", "zone", "barrier", "fence", "stair", "plat", "tounpdate", "toupdate" }
F.EGG_KEY = { "egg", "brainrot", "pet", "animal", "creature", "mythic", "secret",
"god", "divine", "legendary", "dragon", "unicorn", "crate", "chest" }
F.EGG_TIER = { common = 1, uncommon = 1, rare = 2, epic = 3, legendary = 4, mythic = 5, secret = 5, god = 6, divine = 6 }
F._eggs, F._eggPick = {}, 0
F._eggIdx = nil
F.EggAssetIndex = function()
if F._eggIdx ~= nil then return F._eggIdx end
local idx = nil
local function tryMod(m)
local ok, t = pcall(require, m)
if not ok or type(t) ~= "table" then return nil end
local dir = t.Directory or (type(t.Assets) == "table" and t.Assets.Directory) or nil
if type(dir) ~= "table" then return nil end
local out, n = {}, 0
for k, v in pairs(dir) do
if type(v) == "table" then
local rar = v.Rarity
out[tostring(k):gsub("^%s+", ""):gsub("%s+$", "")] = {
tier = (type(rar) == "table" and tonumber(rar.RarityNumber)) or 0,
drop = tonumber(v.DropWeight) or 1e9,
display = (type(v.Egg) == "table" and v.Egg.DisplayName) or tostring(k),
}
n = n + 1
end
end
return (n > 0) and out or nil
end
pcall(function()
local RStorage = game:GetService("ReplicatedStorage")
local roots = { RStorage, RStorage:FindFirstChild("Shared"), RStorage:FindFirstChild("Source"),
RStorage:FindFirstChild("Assets"), RStorage:FindFirstChild("Configs") }
for _, root in ipairs(roots) do
if root then
for _, m in ipairs(root:GetDescendants()) do
if m:IsA("ModuleScript") and (m.Name == "Assets" or m.Name == "EggData"
or m.Name == "Directory" or m.Name == "Configs") then
idx = tryMod(m)
if idx then break end
end
end
end
if idx then break end
end
end)
F._eggIdx = idx or false
if idx then F.Out("[偷蛋] 已读到游戏自己的资产表(按稀有度等级排序, 比体积猜测准)") end
return F._eggIdx or nil
end
F.EGG_BOX = { "areaeggslots", "eggslot", "eggs", "areaegg", "wildegg", "eggspawn",
"nest", "spawner", "displayegg", "eggstand", "eggdisplay", "podium" }
F.EGG_SKIPBOX = { "petarea", "pets", "hatched", "hatch", "incubator", "inventory",
"storage", "backpack", "uiprovider" }
F.EggContainers = function()
local out, seen = {}, 0
pcall(function()
for _, o in ipairs(workspace:GetChildren()) do
seen = seen + 1
if seen > 400 then break end
local nm = string.lower(tostring(o.Name))
local skip = false
for _, s in ipairs(F.EGG_SKIPBOX) do
if string.find(nm, s, 1, true) then skip = true break end
end
if not skip then
for _, k in ipairs(F.EGG_BOX) do
if string.find(nm, k, 1, true) then
out[#out + 1] = o
break
end
end
end
end
end)
return out
end
F.EggOwnerOf = function(o)
local mine, other, where = false, false, nil
pcall(function()
local q = o.Parent
for _ = 1, 6 do
if not q or q == workspace then break end
local nm = string.lower(tostring(q.Name))
if string.find(nm, "plot", 1, true) or string.find(nm, "base", 1, true)
or string.find(nm, "pen", 1, true) or string.find(nm, "stand", 1, true) then
where = tostring(q.Name)
local owner = nil
for _, key in ipairs({ "Owner", "OwnerName", "Player", "PlayerName" }) do
local vv = q:FindFirstChild(key)
if vv and vv:IsA("ValueBase") then owner = tostring(vv.Value) end
end
if not owner then
for _, a in ipairs(q:GetAttributes()) do
if string.find(string.lower(tostring(a)), "owner", 1, true) then
owner = tostring(q:GetAttribute(a))
end
end
end
if owner then
if owner == LP.Name then mine = true else other = true end
end
break
end
q = q.Parent
end
end)
return mine, other, where
end
F.EGG_NAME_SKIP = { "mesh", "egg", "part", "root", "hitbox", "handle", "shadow", "ring",
"beam", "glow", "core", "shell", "plane", "planea", "deco", "vfx", "sfx" }
F.EggPetName = function(o)
local best = nil
local function consider(v)
if type(v) ~= "string" or v == "" then return end
local l = string.lower(v)
if string.match(l, "^%d+$") then return end
for _, s in ipairs(F.EGG_NAME_SKIP) do
if l == s then return end
end
if #v >= 4 and #v <= 40 and (not best or #v > #best) then best = v end
end
pcall(function()
for _, d in ipairs(o:GetDescendants()) do
if d:IsA("StringValue") then
local nl = string.lower(d.Name)
if string.find(nl, "name", 1, true) or string.find(nl, "display", 1, true)
or string.find(nl, "pet", 1, true) or string.find(nl, "asset", 1, true)
or string.find(nl, "category", 1, true) then
consider(tostring(d.Value))
end
elseif d:IsA("Model") then
consider(d.Name)
end
local ok, attrs = pcall(function() return d:GetAttributes() end)
if ok and type(attrs) == "table" then
for k, v in pairs(attrs) do
local kl = string.lower(tostring(k))
if string.find(kl, "name", 1, true) or string.find(kl, "display", 1, true)
or string.find(kl, "pet", 1, true) or string.find(kl, "category", 1, true)
or string.find(kl, "asset", 1, true) then
consider(tostring(v))
end
end
end
end
end)
return best
end
F.EggTextBlob = function(inst)
local t = { tostring(inst.Name) }
pcall(function()
local q = inst.Parent
for _ = 1, 3 do
if not q or q == workspace then break end
t[#t + 1] = tostring(q.Name)
q = q.Parent
end
end)
pcall(function()
for _, d in ipairs(inst:GetDescendants()) do
if d:IsA("BasePart") then t[#t + 1] = tostring(d.Name) end
local ok, attrs = pcall(function() return d:GetAttributes() end)
if ok and type(attrs) == "table" then
for k, v in pairs(attrs) do t[#t + 1] = tostring(k) .. "=" .. tostring(v) end
end
end
end)
return string.lower(table.concat(t, " | "))
end
F.EGG_MUT = { "spirit bloom", "rainbow", "golden", "bloom", "silver", "shiny" }
F.EggIdxLookup = function(name)
local idx = F._eggIdx
if type(idx) ~= "table" then return nil end
local k = string.lower(tostring(name or ""))
k = string.gsub(k, "^%s+", "")
if k == "" then return nil end
if idx[k] then return idx[k], "精确" end
for _, mu in ipairs(F.EGG_MUT) do
local stripped = string.gsub(k, mu, "")
stripped = string.gsub(stripped, "^%s+", "")
stripped = string.gsub(stripped, "%s+$", "")
if stripped ~= "" and idx[stripped] then return idx[stripped], "去变体" end
end
if #k >= 4 then
for key, v in pairs(idx) do
if #key >= 4 and string.find(k, key, 1, true) then return v, "包含" end
end
end
return nil
end
F.EggWeight = function(o)
local w, src2 = nil, nil
pcall(function()
local blob = F.EggTextBlob(o)
local nn = string.match(blob, "([%d%.%,]+)%s*kg")
if nn then
local v = tonumber(string.gsub(nn, ",", ""))
if v and v > 0 then w, src2 = v, "文本kg" end
end
end)
pcall(function()
if w then return end
for _, a in ipairs(o:GetAttributes()) do
local al = string.lower(tostring(a))
if string.find(al, "weight", 1, true) or string.find(al, "mass", 1, true)
or string.find(al, "kg", 1, true) then
local v = tonumber(o:GetAttribute(a))
if v and v > 0 then w, src2 = v, "属性" .. tostring(a) end
end
end
end)
if not w then
pcall(function()
for _, c in ipairs(o:GetDescendants()) do
if c:IsA("NumberValue") or c:IsA("IntValue") or c:IsA("StringValue") then
local cl = string.lower(c.Name)
if string.find(cl, "weight", 1, true) or string.find(cl, "mass", 1, true)
or string.find(cl, "kg", 1, true) then
local v = tonumber(c.Value)
if v and v > 0 then w, src2 = v, "数值" .. tostring(c.Name) end
end
end
end
end)
end
if not w then
local num = string.match(o.Name, "(%d+%.?%d*)%s*[kK][gG]")
if num then w, src2 = tonumber(num), "名字" end
end
return w, src2
end
function F.EggScanMap()
local ch = LP.Character
local root = ch and ch:FindFirstChild("HumanoidRootPart")
local rp = root and root.Position
F._eggs = {}
local flt = tostring(C.EggFilter or "全部")
local minTier, onlyKg = 0, false
if string.find(flt, "稀有度 ≥", 1, true) then
minTier = tonumber(string.match(flt, "≥%s*(%d+)")) or 0
end
if string.find(flt, "只要有重量", 1, true) then onlyKg = true end
local seen = 0
local roots = F.EggContainers()
local scanList = nil
if #roots > 0 then
scanList = {}
local cnt = 0
for _, r in ipairs(roots) do
for _, d in ipairs(r:GetDescendants()) do
cnt = cnt + 1
if cnt > 20000 then break end
scanList[#scanList + 1] = d
end
end
F.Out("[偷蛋] 找到游戏自己的蛋容器 " .. tostring(#roots) .. " 个(只扫这些, 不再全图乱扫)")
end
local iterList = scanList or workspace:GetDescendants()
for _, o in ipairs(iterList) do
seen = seen + 1
if seen > 9000 then break end
if o:IsA("Model") and not o:IsDescendantOf(ch) and not Players:GetPlayerFromCharacter(o) then
local low = string.lower(o.Name)
local isEggObj = nil
pcall(function()
local ac = o:GetAttribute("AssetCategory")
if type(ac) ~= "string" or ac == "" then ac = o:GetAttribute("Category") end
if type(ac) == "string" and ac ~= "" then isEggObj = ac end
end)
local hit, byCat2 = false, nil
local wkg, wsrc = nil, nil
if isEggObj then
local ent, how = F.EggIdxLookup(isEggObj)
if ent then hit, byCat2 = true, how end
end
if not hit then
local blob = nil
pcall(function() blob = F.EggTextBlob(o) end)
blob = blob or low
local bad = false
for _, b in ipairs(F.EGG_BAD) do
if string.find(low, b, 1, true) then bad = true break end
end
if not bad then
for _, w in ipairs(F.EGG_KEY) do
if string.find(blob, w, 1, true) then hit = true break end
end
end
if hit then
local ent, how = F.EggIdxLookup(o.Name)
if ent then byCat2 = how end
end
if not hit then
pcall(function() wkg, wsrc = F.EggWeight(o) end)
if wkg then hit = true end
end
end
local region = nil
if hit then
pcall(function()
local anc = o.Parent
for _ = 1, 4 do
if not anc or anc == workspace then break end
local al = string.lower(anc.Name)
if string.find(al, "stand", 1, true) or string.find(al, "plot", 1, true)
or string.find(al, "podium", 1, true) or string.find(al, "base", 1, true)
or string.find(al, "egg", 1, true) then
region = tostring(anc.Name)
break
end
anc = anc.Parent
end
end)
if not wkg then pcall(function() wkg, wsrc = F.EggWeight(o) end) end
if not region then
pcall(function()
local pb = o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")
local pp = pb and pb.Position
if pp then
region = string.format("%s%s(%d格)",
pp.Z < 0 and "北" or "南", pp.X < 0 and "西" or "东",
math.floor((pp - (rp or pp)).Magnitude))
end
end)
end
local prim = o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")
if prim then
local vol, val, tier = 0, nil, 0
pcall(function()
local _, sz = o:GetBoundingBox()
vol = sz.X * sz.Y * sz.Z
end)
pcall(function()
for _, a in ipairs(o:GetAttributes()) do
local al = tostring(a):lower()
if al:find("value") or al:find("worth") or al:find("price")
or al:find("cost") or al:find("weight") or al:find("mass") then
local v = tonumber(o:GetAttribute(a))
if v then val = v end
end
end
end)
for w, t in pairs(F.EGG_TIER) do
if low:find(w, 1, true) and t > tier then tier = t end
end
local dist = rp and (prim.Position - rp).Magnitude or 0
local petName = nil
pcall(function() petName = F.EggPetName(o) end)
if petName and not byCat2 then
local ent, how = F.EggIdxLookup(petName)
if ent then
byCat2 = how
if ent.tier and ent.tier > 0 then tier = math.max(tier, ent.tier) end
if ent.drop then gDrop = ent.drop end
end
end
local held = string.find(low, "remote", 1, true) or string.find(low, "carried", 1, true)
or string.find(low, "held", 1, true)
local mine, other, where = F.EggOwnerOf(o)
if mine and not other then
hit = false
end
local inPet = false
pcall(function()
local q = o.Parent
for _ = 1, 6 do
if not q or q == workspace then break end
local nm = string.lower(tostring(q.Name))
if string.find(nm, "petarea", 1, true) or string.find(nm, "hatch", 1, true)
or string.find(nm, "incubator", 1, true) or string.find(nm, "inventory", 1, true) then
inPet = true break
end
q = q.Parent
end
end)
if inPet and not hit then hit = false end
if hit then
if minTier > 0 and (tonumber(tier) or 0) < minTier then hit = false end
if onlyKg and not (wkg and wkg > 0) then hit = false end
end
local idx = F._eggIdx
local gTier, gDrop, gName = nil, nil, nil
if type(idx) == "table" then
local hit2 = idx[o.Name] or idx[low]
if not hit2 then
for k, v in pairs(idx) do
local kl = tostring(k):lower()
if kl ~= "" and (low == kl or low:find(kl, 1, true)) then hit2 = v break end
end
end
if hit2 then gTier, gDrop, gName = hit2.tier, hit2.drop, hit2.display end
end
local score
if wkg and wkg > 0 then
score = 1e12 + wkg * 1000
elseif gTier then
score = gTier * 1e7 - (gDrop or 1e9)
else
score = (val or 0) * 1000 + vol + tier * 5000
end
F._eggs[#F._eggs + 1] = { obj = o, part = prim, name = o.Name, vol = vol, val = val,
tier = gTier or tier, dist = dist, drop = gDrop, kg = wkg, kgSrc = wsrc,
petName = petName, heldByOther = held,
region = region, byCat = byCat2, ownMine = mine, ownOther = other,
ownWhere = where, inPet = inPet, score = score }
end
end
end
end
table.sort(F._eggs, function(a, b) return a.score > b.score end)
return #F._eggs
end
F.EGG_SORT_NAME = {
kg = "重量(kg)", val = "价值", tier = "稀有度等级", vol = "体积", dist = "距离最近", region = "区域",
}
F.EggSortNow = function()
local mode = tostring(C.EggSort or "最重(kg)")
local list = F._eggs or {}
local function keyOf(kind, e)
if kind == "kg" then return e.kg and e.kg > 0 and e.kg or -1 end
if kind == "val" then return e.val or -1 end
if kind == "tier" then return e.tier or -1 end
if kind == "vol" then return e.vol or 0 end
if kind == "dist" then return -(e.dist or 1e9) end
if kind == "region" then return tostring(e.region or "zzz") end
return 0
end
local order
if string.find(mode, "贵", 1, true) then
order = { "val", "tier", "kg", "vol" }
elseif string.find(mode, "稀有", 1, true) then
order = { "tier", "val", "kg", "vol" }
elseif string.find(mode, "距离", 1, true) then
order = { "dist", "kg", "vol" }
elseif string.find(mode, "区域", 1, true) then
order = { "region", "kg", "val", "vol" }
else
order = { "kg", "val", "tier", "vol" }
end
local used = order[1]
for _, k in ipairs(order) do
local seen, distinct = {}, 0
for _, e in ipairs(list) do
local v = tostring(keyOf(k, e))
if not seen[v] then
seen[v] = true
distinct = distinct + 1
end
end
if distinct > 1 then used = k break end
end
local tie = order[#order]
table.sort(list, function(a, b)
local ka, kb = keyOf(used, a), keyOf(used, b)
if ka == kb then
ka, kb = keyOf(tie, a), keyOf(tie, b)
if ka == kb then return tostring(a.name) < tostring(b.name) end
end
return ka > kb
end)
F._eggSortUsed = used
return used
end
function F.EggLabels()
local out = {}
for i, e in ipairs(F._eggs) do
local parts = {}
parts[#parts + 1] = e.kg and e.kg > 0 and string.format("%.1f kg", e.kg) or "kg?"
if e.tier and e.tier > 0 then parts[#parts + 1] = "等级" .. tostring(e.tier) end
if e.val then parts[#parts + 1] = "值" .. tostring(math.floor(e.val)) end
if e.drop and not e.val then parts[#parts + 1] = "掉重" .. tostring(math.floor(e.drop)) end
if e.petName then parts[#parts + 1] = tostring(e.petName) end
if e.heldByOther then parts[#parts + 1] = "别人拿着" end
if e.ownOther then parts[#parts + 1] = "别人的" end
if e.ownMine then parts[#parts + 1] = "我的" end
if e.ownWhere then parts[#parts + 1] = tostring(e.ownWhere) end
local rg = (string.find(tostring(C.EggSort or ""), "区域", 1, true) and e.region)
and ("@" .. tostring(e.region) .. " ") or ""
out[i] = string.format("#%d %s%s (%s · %.0f格)", i, rg, e.name,
table.concat(parts, " · "), e.dist)
end
if #out == 0 then out[1] = "(还没扫到)" end
return out
end
function F.EggScanAndFill()
pcall(F.EggAssetIndex)
local n = F.EggScanMap()
local used = nil
pcall(function() used = F.EggSortNow() end)
local labels = F.EggLabels()
local okRef = pcall(function()
local op = Fluent and Fluent.Options and Fluent.Options.EggPick
if op and op.Refresh then op:Refresh(labels) return true end
if op and op.SetValues then op:SetValues(labels) return true end
return false
end)
local withKg, byCat = 0, 0
for _, e in ipairs(F._eggs) do
if e.kg and e.kg > 0 then withKg = withKg + 1 end
if e.byCat then byCat = byCat + 1 end
end
local usedName = (used and F.EGG_SORT_NAME[used]) or "原始顺序"
F.Out("[偷蛋] 扫到 " .. tostring(n) .. " 个(资产表确认 " .. tostring(byCat) .. " 个 · 读到 kg " .. tostring(withKg)
.. " 个) · 排序方式=" .. tostring(C.EggSort or "最重(kg)") .. " ⇒ 实际按「" .. usedName .. "」从高到低"
.. (okRef and "(下拉已刷新)" or "(下拉没刷新就重开一次菜单)"))
for i = 1, math.min(n, 6) do F.Out("   " .. labels[i]) end
pcall(F.LogFlush, "偷蛋扫描")
return n
end
function F.EggGo(extraY)
local e = F._eggs[F._eggPick or 0]
if not e then
F.Out("[偷蛋] 先点「扫描」, 再在下拉里选一个目标")
return nil
end
local _, _, root = GC()
if not root then return nil end
F._walkTgt = nil
if F.DropIntent then pcall(F.DropIntent) end
pcall(F.SrvOwnTake, false)
eggTP(e.part.CFrame + Vector3.new(0, extraY or 3, 0))
return e
end
F.EggWalkTo = function()
local e = F._eggs[F._eggPick or 0]
if not e then
F.Out("[偷蛋] 先点「扫描」, 再在下拉里选一个目标")
return
end
local _, hum, root = GC()
if not (hum and root) then return end
F._walkTgt = e
F._walkUntil = os.clock() + 40
F.Out("[偷蛋] 走路去拿: " .. tostring(e.name) .. " (不传送, 不容易被位置差检测抓)")
if F._walkConn then return end
F._walkConn = RS.Heartbeat:Connect(function()
if not F._walkTgt or not T.EggWalk then
if F._walkConn then pcall(function() F._walkConn:Disconnect() end) F._walkConn = nil end
return
end
local _, h2, r2 = GC()
if not (h2 and r2) then return end
local tgt = F._walkTgt
if not (tgt and tgt.part and tgt.part.Parent) then
F._walkTgt = nil
return
end
local d = (r2.Position - tgt.part.Position).Magnitude
if d < 7 then
pcall(function() F.WalkTapPrompt(tgt.part.Position, 14) end)
F.Out("[偷蛋] 已走到 " .. tostring(tgt.name) .. " 身边并触发交互")
F._walkTgt = nil
return
end
if os.clock() > (F._walkUntil or 0) then
F.Out("[偷蛋] 走路超时(可能被挡住), 改用传送吧")
F._walkTgt = nil
return
end
if (os.clock() - (F._walkStep or 0)) > 0.25 then
F._walkStep = os.clock()
pcall(function() h2:MoveTo(tgt.part.Position) end)
end
end)
end
F.WalkTapPrompt = function(pos, radius)
local fired = false
pcall(function()
for _, d in ipairs(workspace:GetDescendants()) do
if d:IsA("ProximityPrompt") and d.Enabled then
local host = d.Parent
local hp = host and host:IsA("BasePart") and host.Position
if hp and (hp - pos).Magnitude < (radius or 12) then
if not fired then
fired = true
pcall(function()
d.HoldDuration = 0
d.RequiresLineOfSight = false
d:InputHoldBegin()
end)
task.wait(0.1)
pcall(function() d:InputHoldEnd() end)
end
end
end
end
end)
end
function F.EggRemoteSteal()
local e = F.EggGo(3)
if not e then return end
local safe = C.SafePoint
task.wait(0.28)
local fired, n = false, 0
pcall(function()
for _, d in ipairs(workspace:GetDescendants()) do
if d:IsA("ProximityPrompt") and d.Enabled then
local host = d.Parent
local hp = host and host:IsA("BasePart") and host.Position
if hp and (hp - e.part.Position).Magnitude < 14 then
n = n + 1
if not fired then
fired = true
pcall(function()
d.HoldDuration = 0
d.RequiresLineOfSight = false
d:InputHoldBegin()
end)
task.wait(0.1)
pcall(function() d:InputHoldEnd() end)
end
end
end
end
end)
task.wait(0.2)
if safe then
eggTP(CFrame.new(Vector3.new(safe.x, safe.y, safe.z)))
F.Out("[偷蛋] 已触发 " .. tostring(n) .. " 个交互候选 ⇒ 已传送回安全点")
else
F.Out("[偷蛋] 已触发 " .. tostring(n) .. " 个交互候选 (没设安全点, 所以留在原地)")
end
end
F.GUARD_WORDS = { "guard", "npc", "security", "police", "watcher", "officer", "sentry" }
F.GuardScan = function()
local best, bd = nil, 1e9
local _, _, root = GC()
if not root then return nil end
local rp = root.Position
local seen = 0
pcall(function()
for _, o in ipairs(workspace:GetChildren()) do
local nm = string.lower(tostring(o.Name))
local matchSelf = false
for _, w in ipairs(F.GUARD_WORDS) do
if string.find(nm, w, 1, true) then matchSelf = true break end
end
local cands = nil
if matchSelf then
cands = { o }
else
cands = o:GetChildren()
end
for _, o2 in ipairs(cands) do
seen = seen + 1
if seen > 4000 then break end
local nm2 = string.lower(tostring(o2.Name))
for _, w in ipairs(F.GUARD_WORDS) do
if string.find(nm2, w, 1, true) then
local p = o2.PrimaryPart
or (o2:IsA("Model") and o2:FindFirstChildWhichIsA("BasePart")) or nil
if p then
local d = (p.Position - rp).Magnitude
if d < bd then bd, best = d, p end
end
break
end
end
end
end
end)
if best then return best, bd end
return nil
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
function F.PinEnable()
if F._pinConn then return end
local _, _, root = GC()
if not root then return end
local ok = pcall(function()
local att = Instance.new("Attachment")
att.Name = "CMPin"
att.Parent = root
local ap = Instance.new("AlignPosition")
ap.Mode = Enum.PositionAlignmentMode.OneAttachment
ap.Attachment0 = att
ap.MaxForce = 1e9
ap.Responsiveness = 200
pcall(function() ap.RigidityEnabled = true end)
ap.Position = root.Position
ap.Parent = root
F._pinAtt, F._pinAp = att, ap
end)
if not ok or not F._pinAp then F.PinDisable() return end
F._pinConn = RS.Stepped:Connect(function()
if not (T.SpeedGuard and T.SpeedOn) then F.PinDisable() return end
local _, _, r2 = GC()
if not (r2 and F._pinAp) then return end
local intent = F._intent
if intent then pcall(function() F._pinAp.Position = intent end) end
end)
F.Out("[钉位] 已接管位移(刚性约束), 服务端回滚也会被拉回原定位置")
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
F.SafeSpotPush = function()
local _, hum, root = GC()
if not (hum and root) then return end
local ok = false
pcall(function()
local params = RaycastParams.new()
if not pcall(function() params.FilterType = Enum.RaycastFilterType.Exclude end) then
pcall(function() params.FilterType = Enum.RaycastFilterType.Blacklist end)
end
if LP.Character then params.FilterDescendantsInstances = { LP.Character } end
local hip = tonumber(hum.HipHeight) or 2
if hip ~= hip or hip < 0 then hip = 2 end
local half = root.Size.Y / 2
local down = math.max(hip + half + 0.4, 2)
local hit = workspace:Raycast(root.Position, Vector3.new(0, -down, 0), params)
ok = hit ~= nil
end)
if ok then
local p = root.Position
F._safeSpot = { x = p.X, y = p.Y + 3, z = p.Z, at = os.clock() }
end
return ok
end
F.bypassConn = RS.Heartbeat:Connect(function()
if not T.BypassDetect then F.BypassDisable() return end
local now = os.clock()
if now - (F._safeAt or 0) > 0.5 then
F._safeAt = now
pcall(F.SafeSpotPush)
end
local _, _, rt = GC()
if rt and F._safeSpot then
local far = (Vector3.new(rt.Position.X, 0, rt.Position.Z)
- Vector3.new(F._safeSpot.x, 0, F._safeSpot.z)).Magnitude
local fell = rt.Position.Y < -120
local prev = F._safePrevPos
F._safePrevPos = rt.Position
local jumped = prev and (rt.Position - prev).Magnitude > 300
local idle = (not T.SpeedOn) and (not T.FlyOn)
if fell or (jumped and idle) then
local dest = CFrame.new(Vector3.new(F._safeSpot.x, F._safeSpot.y, F._safeSpot.z))
pcall(function() rt:PivotTo(dest) end)
pcall(function()
rt.AssemblyLinearVelocity = Vector3.zero
rt.AssemblyAngularVelocity = Vector3.zero
end)
F.DropIntent()
F._safeBack = (F._safeBack or 0) + 1
if now - (F._safeLogAt or 0) > 3 then
F._safeLogAt = now
F.Out("[安全点] " .. (fell and "掉出地图" or "静止时被瞬间挪走 " .. string.format("%.0f", far) .. " 格")
.. " ⇒ 已回到最近的安全地面点 (第 " .. tostring(F._safeBack) .. " 次)")
end
end
end
if now - (F._bypassOwnAt or 0) > 0.5 then
F._bypassOwnAt = now
if T.SpeedOn or T.FlyOn then
F._bypassOwnOK = pcall(F.SrvOwnTake, false)
end
end
end)
F.Out("[绕过] 网络所有权回读: " .. (got and "本地(拿到)" or "仍非本地 ⇒ 这游戏持续抢回, 靠「被拉回就续跑」硬顶"))
F.Out("[绕过] 已开启: 抢角色所有权(每0.5s) + 加速位移补足 + 客户端检测清理"
.. (F._bypassAtp and "(连带开了防拉回档)" or ""))
end
function F.BypassDisable()
if F.bypassConn then pcall(function() F.bypassConn:Disconnect() end) F.bypassConn = nil end
F._safeSpot, F._safeBack, F._safePrevPos = nil, 0, nil
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
local _, hum = GC()
if not hum then return end
pcall(function() hum.WalkSpeed = tonumber(C.SpeedValue) or 60 end)
end
function F.SpeedRestore()
local back = tonumber(F._preSpeed) or tonumber(F._orig and F._orig.walk)
F._preSpeed = nil
if not back or back <= 0 then return false end
local _, hum = GC()
if not hum then return false end
if math.abs((tonumber(hum.WalkSpeed) or back) - back) < 0.01 then return true end
pcall(function() hum.WalkSpeed = back end)
F.Out(string.format("[加速] 已还原你开加速之前的 WalkSpeed = %.1f", back))
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
end
F.SpeedApply()
F._spdConn = F.DriveConnect(function(deltaTime)
if not T.SpeedOn then F.SpeedSet(false) return end
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
pcall(function() r.AssemblyLinearVelocity = Vector3.new(v.X, cur.Y, v.Z) end)
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
pcall(function() r.AssemblyLinearVelocity = Vector3.new(0, cur.Y, 0) end)
end
if dir.Magnitude <= 0.01 then F._intent = nil end
if T.BypassDetect then
if math.abs((h.WalkSpeed or 0) - (F._preSpeed or h.WalkSpeed or 16)) > 0.5 then
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
pcall(function() hum.PlatformStand = true end)
if F._flyJumpReqConn then F._flyJumpReqConn:Disconnect() end
F._flyJumpReqConn = UIS.JumpRequest:Connect(function()
if T.FlyOn then F._flyJumpAt = os.clock() end
end)
local okAlign = pcall(function()
local att = Instance.new("Attachment")
att.Name = "RootTilt"
att.Parent = root
local ap = Instance.new("AlignPosition")
ap.Attachment0 = att
ap.Mode = Enum.PositionAlignmentMode.OneAttachment
ap.MaxForce = 1e9
ap.Responsiveness = 40
ap.Position = root.Position
pcall(function() ap.RigidityEnabled = true end)
ap.Parent = root
local ao = Instance.new("AlignOrientation")
ao.Attachment0 = att
ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
ao.MaxTorque = 1e9
ao.Responsiveness = 40
ao.CFrame = root.CFrame
ao.Parent = root
F._flyAtt, F._flyAp, F._flyAo = att, ap, ao
end)
if not okAlign then
for _, k in ipairs({ "_flyAtt", "_flyAp", "_flyAo" }) do
local obj = F[k]
if obj then pcall(function() obj:Destroy() end) F[k] = nil end
end
pcall(function()
local att2 = Instance.new("Attachment")
att2.Name = "CMFlyAtt"
att2.Parent = root
local bv = Instance.new("LinearVelocity")
bv.Attachment0 = att2
bv.MaxForce = 1e9
bv.VectorVelocity = Vector3.zero
bv.Parent = root
F._flyBvAtt = att2
local bg = Instance.new("AlignOrientation")
bg.Mode = Enum.OrientationAlignmentMode.OneAttachment
bg.Attachment0 = att2
bg.MaxTorque = 1e9
bg.Responsiveness = 60
bg.RigidityEnabled = true
bg.Parent = root
F._flyBv, F._flyBg = bv, bg
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
local step = math.clamp(tonumber(dt) or 0, 0, 0.1)
F._flyAp.Position = r.Position + vel * step
F._flyAo.CFrame = c.CFrame
if vel.Magnitude < 0.01 then pcall(function() r.AssemblyLinearVelocity = Vector3.zero end) end
if vel.Magnitude > 0.01 then F.SpeedProbe(r, "飞行", fsp, step, true) end
elseif F._flyBv then
pcall(function() F._flyBv.VectorVelocity = vel end)
pcall(function() F._flyBg.CFrame = c.CFrame end)
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
pcall(function()
local _, _, r = GC()
if r and F.HideBaseY then r.CFrame = CFrame.new(r.Position.X, F.HideBaseY, r.Position.Z) end
end)
end
function F.HideEnable()
if F.HideConn then return end
local _, _, root = GC()
if root then F.HideBaseY = root.Position.Y end
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
local function smoothTP(targetCF)
local _, _, root = GC()
if not root or not targetCF then return end
if F.DropIntent then pcall(F.DropIntent) end
pcall(function() root:PivotTo(targetCF) end)
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
pcall(SaveConfig)
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
pcall(SaveConfig)
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
local _, srv = F.AuthorityGuard(false)
pcall(F.SrvOwnTake, false)
local pos = Vector3.new(tonumber(it.x) or 0, tonumber(it.y) or 0, tonumber(it.z) or 0)
smoothTP(CFrame.new(pos) * CFrame.Angles(0, tonumber(it.yaw) or 0, 0))
if hum then pcall(function() hum.PlatformStand = false end) end
local ok = false
pcall(function()
local _, _, r2 = GC()
if r2 then ok = (r2.Position - pos).Magnitude < 6 end
end)
F.Out(string.format("[点位] 传送到「%s」 (%.0f, %.0f, %.0f) · 到位检查: %s",
tostring(it.name), pos.X, pos.Y, pos.Z, ok and "已到位" or "没到位"))
if not ok then
F.Out(srv and "[点位] ⚠ 这个游戏 AuthorityMode=Server(位移由服务端裁决) ⇒ 传送到不了是游戏规则, 不是脚本没生效"
or "[点位] ⚠ 没到位: 多半被游戏拉回或角色被冻住 —— 再点一次, 或先关掉「冻结/锁位」类功能")
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
pcall(SaveConfig)
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
local snap = { E = pp.Enabled, H = pp.HoldDuration, R = pp.RequiresLineOfSight }
F.II_SAVED[pp] = snap
pcall(function() pp.HoldDuration = 0 end)
pcall(function() pp.RequiresLineOfSight = false end)
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
pcall(function()
local op = Fluent and Fluent.Options and Fluent.Options.BypassTier
if op and op.Set then op:Set(T.BypassTier) end
end)
end)
end
F.BypassTierApply = function(v)
v = tostring(v or "")
local wants = {
afk = string.find(v, "防挂机", 1, true) ~= nil,
guard = string.find(v, "②", 1, true) ~= nil or string.find(v, "③", 1, true) ~= nil
or string.find(v, "④", 1, true) ~= nil,
kick = string.find(v, "③", 1, true) ~= nil or string.find(v, "④", 1, true) ~= nil,
deep = string.find(v, "④", 1, true) ~= nil,
}
if not wants.afk then
T.AntiAFK = false
pcall(F.AntiAFKDisable)
else
T.AntiAFK = true
pcall(F.AntiAFKEnable)
end
if not wants.guard then
T.GuardOn, T.SpeedGuard, T.Spoof = false, false, false
pcall(function() F.GuardSet(false, false, false, false, false, false) end)
pcall(F.SpeedGuardDisable)
pcall(F.SpoofDisable)
else
T.GuardOn = true
pcall(function() F.GuardSet(true, true, false, true, true, true) end)
T.SpeedGuard = true
pcall(F.SpeedGuardEnable)
T.Spoof = true
pcall(F.SpoofEnable)
end
if not wants.kick then
T.KickProtect, T.KickGuard, T.KickRejoin = false, false, false
pcall(F.KickGuardDisable)
pcall(F.KickRejoinDisable)
else
T.KickProtect, T.KickGuard, T.KickRejoin = true, true, true
pcall(F.KickGuardEnable)
pcall(F.KickRejoinEnable)
end
if not wants.deep then
T.DeepNeuter, T.AntiTPOn = false, false
pcall(F.DeepNeuterDisable)
pcall(F.SpeedAntiTPDisable)
else
T.DeepNeuter, T.AntiTPOn = true, true
pcall(F.SpeedAntiTPEnable)
pcall(F.DeepNeuterEnable)
end
F.Out("[绕过防护] 档位 = " .. v)
end
F.PresetSpeedFlight = function()
local on = {}
local function setOpt(name, v)
pcall(function()
local op = Fluent and Fluent.Options and Fluent.Options[name]
if op and op.Set then op:Set(v) else on[#on + 1] = name end
end)
end
setOpt("GuardTier", "最强: 推荐 + 反拉回 + 伪装(抢所有权/钉位/续跑/读原值)")
setOpt("AntiAFK", true)
F.Out("[一键配置] 速度/飞行·不拉回 已就绪: 反拉回(抢所有权+钉位+续跑+挡服务端写入) + 伪装(读原值+不复制速度+清痕迹) + 防挂机(掐检测连接)")
F.Out("[一键配置] 现在打开「加速」或「飞行」并调速度即可; 若还被踢, 再单独开「防踢」; 只在被针对时才动「深度反作弊中和」")
end
function F.SpeedGuardEnable()
T.SpeedGuard = true
T.BypassDetect = true
pcall(F.BypassEnable)
pcall(F.PinEnable)
pcall(F.MetaHookEnsure)
F.Out("[反拉回] 已开: 抢所有权(0.15s) + 钉位 + 被拉回就续跑 + 挡服务端钉住/清血/打断飞行")
end
function F.SpeedGuardDisable()
T.SpeedGuard = false
T.BypassDetect = false
pcall(F.PinDisable)
pcall(F.BypassDisable)
F.Out("[反拉回] 已关")
end
F.GuardAvoidEnable = function()
if F._gvConn then return end
T.GuardAvoid = true
F._gvConn = RS.Heartbeat:Connect(function()
if not T.GuardAvoid then
if F._gvConn then pcall(function() F._gvConn:Disconnect() end) F._gvConn = nil end
return
end
local now = os.clock()
if now - (F._gvAt or 0) < 0.7 then return end
F._gvAt = now
local g, d = F.GuardScan()
if not (g and d) then return end
if d < 25 then
local _, _, root = GC()
if not root then return end
local away = (root.Position - g.Position)
if away.Magnitude < 0.5 then away = Vector3.new(1, 0, 0) end
away = away.Unit * 35
local dest = root.Position + away + Vector3.new(0, 3, 0)
pcall(function() root:PivotTo(CFrame.new(dest)) end)
if F.DropIntent then pcall(F.DropIntent) end
pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
if now - (F._gvLog or 0) > 4 then
F._gvLog = now
F.Out(string.format("[守卫规避] 守卫离你只有 %.0f 格 ⇒ 已往反方向撤 35 格", d))
end
end
end)
F.Out("[守卫规避] 已开: 名字含 guard/npc/security/police/watcher 的靠太近(25格)就把你撤开")
end
F.GuardAvoidDisable = function()
T.GuardAvoid = false
if F._gvConn then pcall(function() F._gvConn:Disconnect() end) F._gvConn = nil end
end
F.CarryGuardEnable = function()
if F._cgConn then return end
F.EggLock()
F._carry = F.CarryFind()
F._cgConn = RS.Heartbeat:Connect(function()
if not T.CarryGuard then F.CarryGuardDisable() return end
F.EggGuardTick()
F.CarryGuardTick()
end)
F.Out("[搬运守卫] 已开(焊点被拆就重焊 + 离手就拉回); 先站到蛋旁边再开")
end
function F.CarryGuardDisable()
if F._cgConn then pcall(function() F._cgConn:Disconnect() end) F._cgConn = nil end
F._egg, F._eggPart, F._eggHand = nil, nil, nil
F._eggGone, F._eggBack, F._carry, F._carryBack = nil, 0, nil, 0
F.Out("[搬运守卫] 已关")
end
function F.GuardOnEnable()
pcall(function() F.GuardSet(true, true, false, true, true, true) end)
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
F.II_SAVED, F.II_COUNT = {}, 0
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
F.Out("[瞬间交互] 已开启(长按→点一下就成 · 不要求看得见) — 本次处理 " .. tostring(n)
.. " 个交互点, 新出现的也自动生效; 关闭时逐个还原原值")
end
function F.InstantInteractDisable()
if F.II_CONN then pcall(function() F.II_CONN:Disconnect() end) F.II_CONN = nil end
if F.II_SHOWN then pcall(function() F.II_SHOWN:Disconnect() end) F.II_SHOWN = nil end
local n = 0
if type(F.II_SAVED) == "table" then
for pp, snap in pairs(F.II_SAVED) do
if typeof(pp) == "Instance" and pp.Parent then
pcall(function() pp.HoldDuration = snap.H end)
pcall(function() pp.RequiresLineOfSight = snap.R end)
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
if T.HitboxExpand then pcall(F.HitboxExpandEnable) end
if T.KillAura then pcall(F.KillAuraEnable) end
if T.BodyHL then pcall(F.BodyHLEnable) end
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
function F.BodyHLAdd(pl)
if not T.BodyHL or pl == LP then return end
local ch = pl.Character
if not ch then return end
if F._hlObjs[pl] and F._hlObjs[pl].Parent == ch then return end
if F._hlObjs[pl] then pcall(function() F._hlObjs[pl]:Destroy() end) end
local hl = Instance.new("Highlight")
hl.Name = "BodyMark"
hl.FillTransparency = 1
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
hl.Parent = ch
F._hlObjs[pl] = hl
end
function F.BodyHLRefresh()
for pl, hl in pairs(F._hlObjs) do
local same = false
pcall(function() same = (pl.Team ~= nil and pl.Team == LP.Team) end)
local c = Color3.fromRGB(0, 200, 255)
if T.TeamColorHL ~= false then c = same and Color3.fromRGB(0, 255, 80) or Color3.fromRGB(255, 60, 60) end
pcall(function() hl.OutlineColor = c hl.FillColor = c end)
end
end
function F.BodyHLEnable()
for _, pl in ipairs(Players:GetPlayers()) do F.BodyHLAdd(pl) end
F.BodyHLRefresh()
if not F._hlRConn then
F._hlRConn = Players.PlayerRemoving:Connect(function(pl)
if F._hlObjs[pl] then
pcall(function() F._hlObjs[pl]:Destroy() end)
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
if now - (F._hlAt or 0) < 2 then return end
F._hlAt = now
for _, pl in ipairs(Players:GetPlayers()) do F.BodyHLAdd(pl) end
F.BodyHLRefresh()
end)
end
end
function F.BodyHLDisable()
if F._hlAdded then F._hlAdded:Disconnect() F._hlAdded = nil end
if F._hlLoop then F._hlLoop:Disconnect() F._hlLoop = nil end
for _, hl in pairs(F._hlObjs) do pcall(function() hl:Destroy() end) end
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
F._freecamSaved = { Type = cam.CameraType, Subject = cam.CameraSubject }
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
F._freezeConn = nil
function F.FreezePlayerEnable()
if F._freezeConn then return end
F._freezeConn = RS.Heartbeat:Connect(function()
if not T.FreezePlayer then F.FreezePlayerDisable() return end
local name = Fluent.Options.FlingTarget and Fluent.Options.FlingTarget.Value
local pl = name and Players:FindFirstChild(name)
local ch = pl and pl.Character
local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
if hrp then
if F._freezeWho ~= name then
F._freezeWho = name
F._freezeCF = nil
end
F._freezeCF = F._freezeCF or hrp.CFrame
pcall(function() hrp.CFrame = F._freezeCF hrp.AssemblyLinearVelocity = Vector3.zero end)
end
end)
end
function F.FreezePlayerDisable()
if F._freezeConn then F._freezeConn:Disconnect() F._freezeConn = nil end
F._freezeCF = nil
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
F._bringConn = nil
function F.BringPlayerEnable()
if F._bringConn then return end
F._bringConn = RS.Heartbeat:Connect(function()
if not T.BringPlayer then F.BringPlayerDisable() return end
local _, _, root = GC()
if not root then return end
local name = Fluent.Options.FlingTarget and Fluent.Options.FlingTarget.Value
local pl = name and Players:FindFirstChild(name)
local hrp = pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
if hrp then pcall(function() hrp.CFrame = root.CFrame * CFrame.new(0, 0, -3) end) end
end)
end
function F.BringPlayerDisable()
if F._bringConn then F._bringConn:Disconnect() F._bringConn = nil end
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
F.PANIC_KEEP = { CharPersist = true, AutoSave = true, GuiProtect = true }
function F.PanicKeyDisableAll()
local keep = {}
for k in pairs(F.PANIC_KEEP) do keep[k] = T[k] end
for k in pairs(T) do
if type(T[k]) == "boolean" then T[k] = false end
end
for k, v in pairs(keep) do T[k] = v end
F._tpMouseOn = false
for _, fn in ipairs({ GodDisable, FOVDisable, ZoomDisable, AntilagDisable, MuteDisable, LockHealthDisable, RegenDisable, NoDeathDisable }) do pcall(fn) end
for _, fn in ipairs({ F.HudDisable, F.CrosshairDisable, F.FovCircleDisable, F.FreecamDisable, F.FreezePlayerDisable, F.HidePlayerDisable, F.KillAuraDisable, F.AntiRagdollDisable, F.AntiKnockdownDisable, F.HitboxExpandDisable,  F.NoClipDisable, F.HideDisable, F.InfiniteJumpDisable, F.FullBrightDisable, F.NightVisionDisable, F.NoFogDisable, F.TranslateDisable, F.ChatTranslateDisable, F.BubbleTranslateDisable, F.LockCamDisable, F.BringPlayerDisable }) do pcall(fn) end
for _, fn in ipairs({ F.AimSet, F.KickGuardDisable, F.AntiFlingDisable, F.AntiAFKDisable, F.KickRejoinDisable, F.BodyHLDisable, F.CharPersistDisable, F.LivePlayersDisable, F.AutoSaveDisable, F.GuiProtectionDisable, F.HitGuardDisable, F.SteadyDisable, F.TrapGuardDisable, F.SpeedAntiTPDisable, F.SpeedRestore, F.FlySet, F.FlyDestroy, F.BypassDisable, F.AllInOneDisableAll, F.PinDisable, F.SpoofDisable, F.MetaHookUninstall, F.AntiCheatGCRestore, F.DeepNeuterDisable }) do pcall(fn) end
for _, fn in ipairs({ AC.UninstallNamecallHook, AC.UninstallIndexMask, AC.UnblockRemotes, AC.UninstallAntiTP, AC.UninstallPropertyLock, AC.UninstallSetmetatableHook, AC.WatchNewScriptsDisable, AC.WatchNewRemotesDisable, AC.AntiPauseDisable, AC.TrapDisable.Disable, F.CaptureDisable, F.InstantInteractDisable }) do pcall(fn) end
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
function F.AutoSaveEnable()
if F._saveThread then return end
T.AutoSave = true
F._saveThread = task.spawn(function()
while T.AutoSave do
task.wait(5)
if T.AutoSave then pcall(SaveConfig) end
end
F._saveThread = nil
end)
end
function F.AutoSaveDisable()
T.AutoSave = false
F._saveThread = nil
end
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
function F.AutoGymEnable()
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
root.CFrame = CFrame.new(target)
root.AssemblyLinearVelocity = Vector3.zero
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
TrainThread = task.spawn(function()
while T.AutoTrain do
equipSquatTool()
task.wait(math.max(0.5, C.AutoTrainSec or 5))
end
TrainThread = nil
end)
end
local function multiplierFromText(v)
local compact = tostring(v or ""):upper():gsub("%s+", ""):gsub("×", "X")
if compact == "X2" or compact == "2X" then return 2
elseif compact == "X5" or compact == "5X" then return 5
elseif compact == "X10" or compact == "10X" then return 10 end
end
local function clickBtn(b)
if not b or not b:IsA("GuiButton") or not b.Visible then return false end
if firesignal then return pcall(firesignal, b.Activated) end
return false
end
local function AutoBonusScan()
local roots = { PG, CoreGui }
if gethui then table.insert(roots, gethui()) end
for _, root in ipairs(roots) do
if root then
local ok, list = pcall(function() return F.walk(root) end)
if ok and type(list) == "table" then
for _, obj in ipairs(list) do
if obj:IsA("GuiButton") and obj.Visible then
local hit = false
if obj:IsA("TextButton") and multiplierFromText(obj.Text) then hit = true end
if not hit then
for _, child in ipairs(F.walk(obj, 50)) do
if (child:IsA("TextLabel") or child:IsA("TextButton")) and multiplierFromText(child.Text) then
hit = true break
end
end
end
if hit then
clickBtn(obj)
task.delay(0.01, function() if T.AutoBonus then Fire("TaviMishkal") end end)
end
end
end
end
end
end
end
local BonusThread = nil
function F.AutoBonusEnable()
if BonusThread and T.AutoBonus then return end
if not F._bonusRemoteHooked then
F._bonusRemoteHooked = true
OnRemote("TaviMishkal", function()
if T.AutoBonus then
task.spawn(function() task.wait(0.03) AutoBonusScan() Fire("TaviMishkal") end)
end
end)
end
BonusThread = task.spawn(function()
while T.AutoBonus do AutoBonusScan() task.wait(1) end
end)
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
local base = baseCPSOf(tool)
if not base then return nil end
local mut = tostring(tool:GetAttribute("Mutation") or "")
return base * (MutBuff[mut] or 1) * (lvMul() ^ (toolLevel(tool) - 1))
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
local ok = pcall(function() return rf:InvokeServer() end)
if ok then return true end
end
local re = REvent("B_Sell")
if re then
if pcall(function() re:FireServer() end) then return true end
end
F.Out("[售卖] 没找到 B_Sell 的 RemoteFunction / RemoteEvent")
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
F.Out(string.format("[预览] 手持+背包实体工具 %d 个 · 门槛 %s", #all, fmtNum(th)))
F.Out(string.format("[预览] 会卖 %d · 限定/独家保留 %d · 无法估算(不卖) %d", nSell, nKeep, nUnknown))
local shown = 0
for _, e in ipairs(all) do
if shown >= 15 then break end
local tag = "保留(限定)"
if not e.Known then tag = "不卖(算不出)"
elseif not e.Ex and e.CPS < th then tag = "会卖" end
F.Out(string.format("[预览]  %-10s %-24s CPS≈%-9s %s", tag, e.Name, fmtNum(e.CPS), describe(e.Tool)))
shown = shown + 1
end
if #all == 0 then F.Out("[预览] 没找到实体工具(脑红)") end
pcall(F.LogFlush, "售卖预览")
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
if WithdrawThread then F.Out("[收起] 已在进行中") return end
WithdrawThread = task.spawn(function()
local ok, err = pcall(function()
local ch, hum = GC()
if not (ch and hum) then F.Out("[收起] 无角色") return end
maxSlot = math.clamp(math.floor(tonumber(maxSlot) or 30), 1, 30)
pcall(function() hum:UnequipTools() end)
task.wait(0.1)
local done, failed = 0, 0
for i = 1, maxSlot do
local bp = LP:FindFirstChild("Backpack")
local tool
if bp then
for _, t in ipairs(bp:GetChildren()) do
if isEntityTool(t) then tool = t break end
end
end
if not tool then
F.Out(string.format("[收起] 背包已空(放到第 %d 槽)", i))
break
end
pcall(function() hum:UnequipTools() end)
task.wait(0.08)
pcall(function() hum:EquipTool(tool) end)
task.wait(0.2)
if tool.Parent == ch then
if Fire("S_Interact", i) then done = done + 1 else failed = failed + 1 end
else
failed = failed + 1
end
task.wait(0.15)
if i % 5 == 0 then F.Out(string.format("[收起] %d/%d", i, maxSlot)) end
end
pcall(function() hum:UnequipTools() end)
F.Out(string.format("[收起] 完成 · 成功 %d · 失败 %d", done, failed))
pcall(F.LogFlush, "收起脑红")
end)
WithdrawThread = nil
if not ok then F.Out("[收起] 出错: " .. tostring(err)) end
end)
end
function F.CollectAll(maxSlot)
if CollectThread then return end
CollectThread = task.spawn(function()
local ok, err = pcall(function()
maxSlot = math.clamp(math.floor(tonumber(maxSlot) or 30), 1, 30)
local n = 0
for i = 1, maxSlot do
if Fire("B_Collect", i) then n = n + 1 end
task.wait(0.06)
end
F.Out(string.format("[收钱] 完成 · 触发 %d 个槽位", n))
pcall(F.LogFlush, "收钱")
end)
CollectThread = nil
if not ok then F.Out("[收钱] 出错: " .. tostring(err)) end
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
function Trans.Load()
pcall(function()
if not (type(readfile) == "function" and isfile and isfile(Trans.FILE)) then return end
local d = HS:JSONDecode(readfile(Trans.FILE))
if type(d) == "table" then
local n = 0
for k, v in pairs(d) do Trans.Cache[k] = v n = n + 1 end
F.Out("[翻译] 已加载本地缓存 " .. n .. " 条")
end
end)
end
function Trans.Save()
local now = os.clock()
local last = Trans._savedAt or 0
if now - last < 5 then
Trans._dirtyOld = Trans._dirtyOld or now
if now - Trans._dirtyOld < 25 then return end
end
Trans._dirtyOld = nil
Trans._savedAt = now
pcall(function()
if type(writefile) ~= "function" then return end
writefile(Trans.FILE, HS:JSONEncode(Trans.Cache))
end)
end
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
function Trans.Should(s)
if type(s) ~= "string" then return false end
s = s:gsub("^%s+", ""):gsub("%s+$", "")
if #s < 2 or #s > 300 then return false end
if not s:find("[%a\128-\255]") then return false end
if s:match("^[%d%.,%%%+%-%s/():;!?*#&@'\"|\\~`%[%]{}<>=]+$") then return false end
if s:match("^https?://") or s:find("www%.%w+") or s:find("%.com") or s:find("%.net") or s:find("%.org") then return false end
if s:match("^/") then return false end
if s:find("€", 1, true) or s:find("¥", 1, true) then return false end
local hasCJK = s:find("[\228-\233]") ~= nil
if (C.TransLang or "zh") == "zh" and hasCJK then return false end
return true
end
function Trans.Translate(text, force)
if (not T.Translate and not force) or type(text) ~= "string" or text == "" then return nil end
text = text:gsub("^%s+", ""):gsub("%s+$", "")
if text == "" then return nil end
if not force and not Trans.Should(text) then return nil end
if Trans.Cache[text] then return Trans.Cache[text] end
local quick = Trans.QUICK[text:lower()]
if quick then Trans.Cache[text] = quick return quick end
local now = os.clock()
if not force and (now - (Trans._lastAt or 0)) < (C.TransInterval or 0.15) then return nil end
Trans._lastAt = now
local r = Trans.Request(text)
if r and r ~= "" and r ~= text then
r = r:gsub("^%s*(翻译|译文|中文|汉化)%s*[:：]%s*", "")
Trans.Cache[text] = r
Trans.CACHE_MAX = Trans.CACHE_MAX or 5000
local cnt = 0
for _ in pairs(Trans.Cache) do cnt = cnt + 1 end
if cnt > Trans.CACHE_MAX then
local target = math.floor(Trans.CACHE_MAX / 4)
local removed = 0
for k in pairs(Trans.Cache) do
Trans.Cache[k] = nil
removed = removed + 1
if removed >= target then break end
end
F.Out("[翻译] 缓存超过 " .. Trans.CACHE_MAX .. " 条, 已清理 " .. removed .. " 条")
end
Trans.Save()
return r
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
function Trans.GuiEl(obj)
if not obj then return end
if obj.Visible == false then return end
if obj:IsA("TextLabel") or obj:IsA("TextButton") then
local txt = obj.Text
if txt and Trans.Should(txt) then
Trans.Async(txt, function(tr)
if obj.Parent and obj.Visible ~= false then obj.Text = tr end
end)
end
end
end
function Trans.Scan()
local pg = LP:FindFirstChild("PlayerGui")
local roots = { pg, CoreGui }
if gethui then table.insert(roots, gethui()) end
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
function Trans.Disable()
T.Translate = false
if Trans.Loop then Trans.Loop = nil end
if T.ChatTranslate then F.ChatTranslateDisable() end
if T.BubbleTranslate then F.BubbleTranslateDisable() end
pcall(Trans.Save)
end
function Trans.Enable()
T.Translate = true
Trans.Load()
local ok, body = Trans.Health()
if not ok then
F.Out("[翻译] ⚠ 本地翻译服务没起来(" .. tostring(body) .. ") —— 先双击「翻译模型开关.bat」, 或点本页的「启动指引」")
end
if Trans.Loop then return true end
Trans.Prewarm()
Trans.Scan()
Trans.Loop = task.spawn(function()
while T.Translate do
task.wait(1)
Trans.Scan()
end
Trans.Loop = nil
end)
return true
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
function F.TranslateDisable() Trans.Disable() end
function F.TranslateEnable() return Trans.Enable() end
local function UnloadAll()
for k in pairs(T) do T[k] = false end
local disables = {
F.KickGuardDisable, F.AntiFlingDisable, F.AntiRagdollDisable, F.AntiKnockdownDisable,
F.FreecamDisable, F.FreezePlayerDisable,
F.HidePlayerDisable, F.HudDisable, F.CrosshairDisable, F.FovCircleDisable,
F.BringPlayerDisable, F.LockCamDisable,
F.CharPersistDisable, F.LivePlayersDisable, F.AutoSaveDisable,
F.AntiAFKDisable, F.KickGuardPathsDisable,
AC.WatchNewRemotesDisable, AC.WatchNewScriptsDisable, AC.TrapDisable.Disable,
AC.UnblockRemotes, AC.UninstallAntiTP, AC.AntiPauseDisable, AC.UninstallIndexMask,
AC.UninstallPropertyLock, AC.UninstallSetmetatableHook, AC.UninstallNamecallHook,
F.GuiProtectionDisable, F.HitboxExpandDisable,
F.CaptureDisable, F.TranslateDisable, F.ChatTranslateDisable, F.BubbleTranslateDisable,
F.NoClipDisable,
F.SpeedRestore, F.FlySet, F.FlyDestroy, F.InstantInteractDisable, F.BypassDisable, F.AllInOneDisableAll, F.PinDisable,
F.SpoofDisable, F.CarryGuardDisable, F.GuardOnDisable, F.DeepNeuterDisable, F.SpeedAntiTPDisable,
F.AimSet, F.KillAuraDisable, F.BodyHLDisable, F.HideDisable,
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
function F.RestoreSavedFeatures()
if not T then return end
F.Out("[恢复] 按存档恢复你上次主动开启的功能(没开过的不会自动开)")
local n = 0
local function go(v, fn, ...)
if not v then return end
if pcall(fn, ...) then n = n + 1 end
end
go(T.FlyOn, F.FlySet, true)
go(T.SpeedOn, F.SpeedSet, true)
go(T.NoClip, F.NoClipEnable)
go(T.Hide, F.HideEnable)
go(T.God, GodEnable)
go(T.LockHealth, LockHealthEnable)
go(T.Regen, RegenEnable)
go(T.NoDeath, NoDeathEnable)
go(T.AntiRagdoll, F.AntiRagdollEnable)
go(T.AntiKnockdown, F.AntiKnockdownEnable)
go(T.InfiniteJump, F.InfiniteJumpEnable)
go(T.Translate, F.TranslateEnable)
go(T.ChatTranslate, F.ChatTranslateEnable)
go(T.BubbleTranslate, F.BubbleTranslateEnable)
go(T.HitboxExpand, F.HitboxExpandEnable)
go(T.KillAura, F.KillAuraEnable)
go(T.BodyHL, F.BodyHLEnable)
go(T.AimOn, F.AimSet, true)
go(T.FovCircle, F.FovCircleEnable)
go(T.Hud, F.HudEnable)
go(T.Crosshair, F.CrosshairEnable)
go(T.LockCam, F.LockCamEnable)
go(T.Freecam and not UIS.TouchEnabled, F.FreecamEnable)
go(T.BringPlayer, F.BringPlayerEnable)
go(T.FreezePlayer, F.FreezePlayerEnable)
go(T.KickProtect or T.KickGuard, F.KickGuardEnable)
go(T.KickProtect or T.AntiAFK, F.AntiAFKEnable)
go(T.KickProtect or T.KickRejoin, F.KickRejoinEnable)
go(T.AutoTrain, F.AutoTrainEnable)
go(T.AutoBonus, F.AutoBonusEnable)
go(T.AutoGym, F.AutoGymEnable)
go(T.AutoSell, F.SellLowCPS)
local synced = F.CfgSyncUI()
F.Out("[恢复] 已恢复 " .. n .. " 项" .. ((tonumber(synced) or 0) > 0 and (", 已同步 " .. synced .. " 个控件显示") or ""))
pcall(F.LogFlush, "恢复存档功能")
end
local function RestoreFeatures()
if T.CharPersist == nil then T.CharPersist = false end
if T.AutoSave == nil then T.AutoSave = false end
if T.BypassTier == nil then T.BypassTier = "① 默认: 防挂机(不动人物 · 不装钩子)" end
task.defer(function()
task.wait(1.5)
pcall(F.BypassTierApply, T.BypassTier)
end)
end
LoadConfig()
pcall(function()
local sid = tostring(game.PlaceId) .. "/" .. tostring(game.JobId)
if C.WpServer ~= sid then
local had = type(C.Waypoints) == "table" and #C.Waypoints or 0
if had > 0 then
C.Waypoints = {}
F.Out("[点位] 换服 / 重进游戏 ⇒ 已自动清空上次的 " .. tostring(had) .. " 个收藏点位")
end
C.WpServer = sid
pcall(SaveConfig)
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
task.delay(2.0, function()
if F._menuHoldAt and not F._menuHoldMoved
and (os.clock() - F._menuHoldAt) >= 1.9 then
F._menuHoldAt = nil
pcall(F.PanicKeyDisableAll)
end
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
Tabs.Combat:AddButton({ Title = "★ 自瞄/开火体检(没锁到人 / 没开火 ⇒ 点这个, 原因逐条列出来)", Callback = function() F.CombatCheck() end })
Tabs.Combat:AddSection("自瞄")
Tabs.Combat:AddToggle("AimOn", { Title = "★ 自瞄(总开关 · 每帧把镜头转向最近目标)", Default = false, Callback = function(v) F.AimSet(v) end })
Tabs.Combat:AddSlider("AimFOV", { Title = "自瞄范围(屏幕像素)", Min = 50, Max = 800, Default = 200, Rounding = 0, Callback = function(v) C.AimFOV = v end })
Tabs.Combat:AddSlider("AimSmooth", { Title = "平滑度(越大越慢)", Min = 1, Max = 20, Default = 5, Rounding = 0, Callback = function(v) C.AimSmooth = v end })
Tabs.Combat:AddToggle("AimFireOnly", { Title = "开火才锁(按住左键才生效)", Default = false, Callback = function(v) T.AimFireOnly = v if v then F.EnsureAimOn() end end })
Tabs.Combat:AddToggle("AutoFire", { Title = "★ 锁上就开火(自动开火 · 会自动带上「自瞄」)", Default = false, Callback = function(v) T.AutoFire = v if v then F.EnsureAimOn() end end })
Tabs.Combat:AddSlider("AutoFireGap", { Title = "开火间隔(秒)", Min = 0.02, Max = 1, Default = 0.1, Rounding = 2, Callback = function(v) C.AutoFireGap = v end })
Tabs.Combat:AddToggle("Aim360", { Title = "360°锁敌(背后也能锁 · 范围改按格算)", Default = false, Callback = function(v)
T.Aim360 = v
if v then F.EnsureAimOn() end
F.Out("[自瞄] 360° = " .. (v and "开(不看朝向, 按世界距离; 「自瞄范围」此模式下单位=格)" or "关(只锁屏幕内 FOV 圈里)"))
end })
Tabs.Combat:AddDropdown("AimTarget", { Title = "目标选择(乱斗/无阵营 ⇒ 选「所有人」)", Values = {
"所有人(无阵营时自动)",
"仅敌对阵营(有阵营时)",
}, Default = "所有人(无阵营时自动)", Callback = function(v)
C.AimTarget = v
T.AimTeamCheck = (v == "仅敌对阵营(有阵营时)")
F.Out("[自瞄] 目标 = " .. tostring(v) .. (LP.Team and " (本服有阵营)" or " (本服无阵营 ⇒ 按所有人)"))
end })
Tabs.Combat:AddToggle("AimWallCheck", { Title = "墙壁检查", Default = false, Callback = function(v) T.AimWallCheck = v end })
Tabs.Combat:AddToggle("FovCircle", { Title = "FOV 圈", Default = false, Callback = function(v)
T.FovCircle = v
if F._cfgSyncing then return end
if v then F.FovCircleEnable() else F.FovCircleDisable() end
end })
Tabs.Combat:AddSection("目标管理")
Tabs.Combat:AddDropdown("PriorityTarget", { Title = "优先目标玩家", Values = F.PlayerNames(), Default = nil, Callback = function(v) if v and v ~= "(无人)" then F.AddPriorityTarget(v) end end })
Tabs.Combat:AddDropdown("BlacklistTarget", { Title = "黑名单玩家", Values = F.PlayerNames(), Default = nil, Callback = function(v) if v and v ~= "(无人)" then F.AddBlacklist(v) end end })
Tabs.Combat:AddDropdown("FlingTarget", { Title = "目标玩家(冻结/隐藏/拉过来共用)", Values = F.PlayerNames(), Default = nil })
Tabs.Combat:AddToggle("FreezePlayer", { Title = "冻结目标(不能移动)", Default = false, Callback = function(v)
T.FreezePlayer = v
if F._cfgSyncing then return end
if v then F.FreezePlayerEnable() else F.FreezePlayerDisable() end
end })
Tabs.Combat:AddToggle("HidePlayer", { Title = "隐藏目标(只本地)", Default = false, Callback = function(v)
T.HidePlayer = v
if F._cfgSyncing then return end
if v then F.HidePlayerEnable() else F.HidePlayerDisable() end
end })
Tabs.Combat:AddToggle("BringPlayer", { Title = "把目标拉过来", Default = false, Callback = function(v)
T.BringPlayer = v
if F._cfgSyncing then return end
if v then F.BringPlayerEnable() else F.BringPlayerDisable() end
end })
Tabs.Combat:AddButton({ Title = "清除优先级/黑名单", Callback = function() C.PriorityTargets = {} C.Blacklist = {} end })
Tabs.Combat:AddSection("生存 / 防御")
Tabs.Combat:AddToggle("AntiRagdoll", { Title = "防击倒(反布娃娃+防被撞飞)", Default = false, Callback = function(v)
C.AntiRagdollMode = v and "全部开启" or "关闭"
T.AntiRagdoll, T.AntiKnockdown = v, v
if F._cfgSyncing then return end
F.AntiRagdollDisable() F.AntiKnockdownDisable()
if v then F.AntiRagdollEnable() F.AntiKnockdownEnable() end
end })Tabs.Combat:AddToggle("HitboxExpand", { Title = "Hitbox 扩展", Default = false, Callback = function(v)
T.HitboxExpand = v
if F._cfgSyncing then return end
if v then F.HitboxExpandEnable() else F.HitboxExpandDisable() end
end })
Tabs.Combat:AddSection("自动攻击")
Tabs.Combat:AddToggle("KillAura", { Title = "自动攻击(范围内敌人)", Default = false, Callback = function(v)
T.KillAura = v
if F._cfgSyncing then return end
if v then F.KillAuraEnable() else F.KillAuraDisable() end
end })
Tabs.Combat:AddSlider("KillAuraRange", { Title = "自动攻击范围", Min = 5, Max = 100, Default = 20, Rounding = 0, Callback = function(v) C.KillAuraRange = v end })
Tabs.Combat:AddSlider("KillAuraSpeed", { Title = "自动攻击攻速(次/秒)", Min = 1, Max = 25, Default = 10, Rounding = 0, Callback = function(v) C.KillAuraSpeed = v end })
Tabs.Move:AddSection("飞行")
Tabs.Move:AddToggle("FlyOn", { Title = "飞行(WASD 移动 · 空格升/Ctrl降 · 松手即停)", Default = false, Callback = function(v) F.FlySet(v) end })
Tabs.Move:AddSlider("FlyValue", { Title = "飞行速度(格/秒 · 最高 5000)", Min = 10, Max = 5000, Default = 60, Rounding = 0, Callback = function(v) C.FlyValue = v end })
Tabs.Move:AddSection("加速")
Tabs.Move:AddToggle("SpeedOn", { Title = "加速(水平全向 · 松手即停 · 不含上下)", Default = false, Callback = function(v) F.SpeedSet(v) end })
Tabs.Move:AddSlider("SpeedValue", { Title = "速度(格/秒 · 人类默认 16 · 最高 5000)", Min = 16, Max = 5000, Default = 60, Rounding = 0, Callback = function(v) C.SpeedValue = v if T.SpeedOn then F.SpeedApply() end end })
Tabs.Move:AddDropdown("BypassTier", { Title = "★ 绕过 / 防护 档位(加速/飞行不被拉回就靠它)", Values = {
"关(什么都不开)",
"① 默认: 防挂机(不动人物 · 不装钩子)",
"② + 防护/反拉回/伪装(稳身·受击·陷阱·抢所有权·钉位·读原值)",
"③ + 防踢(拦 Kick · 抢重进 · 会装元表钩子)",
"④ 全部: + 防拉回档 + 深度中和(最激进 · 慎用)",
}, Default = "① 默认: 防挂机(不动人物 · 不装钩子)", Callback = function(v)
local changed = (T.BypassTier ~= nil) and (T.BypassTier ~= v)
T.BypassTier = v
if F._cfgSyncing or not changed then return end
pcall(F.BypassTierApply, v)
end })
Tabs.Move:AddToggle("CarryGuard", { Title = "搬运守卫(蛋不掉手: 焊点重焊 + 离手拉回)", Description = "盯住「把你手上的东西焊在你身上」的那个焊点; 被拆掉就按原样焊回, 东西离手就拉回手上。开之前先站到蛋旁边", Default = false, Callback = function(v)
local changed = (T.CarryGuard ~= nil) and (T.CarryGuard ~= v)
T.CarryGuard = v
if F._cfgSyncing or not changed then return end
if v then F.CarryGuardEnable() else F.CarryGuardDisable() end
end })
Tabs.TP:AddToggle("InstantInteract", { Title = "瞬间交互(长按 → 点一下就成 · 免视线)", Description = "偷蛋、开箱、机关这类要按住一会儿的交互一律变「点一下就完成」", Default = false, Callback = function(v)
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
Tabs.Move:AddSection("其他移动")
Tabs.Move:AddToggle("InfiniteJump", { Title = "无限跳(空中也能跳)", Default = false, Callback = function(v)
local changed = (T.InfiniteJump ~= nil) and (T.InfiniteJump ~= v)
T.InfiniteJump = v
if F._cfgSyncing or not changed then return end
if v then F.InfiniteJumpEnable() else F.InfiniteJumpDisable() end
end })
Tabs.Move:AddToggle("NoClip", { Title = "穿墙", Default = false, Callback = function(v)
T.NoClip = v
if F._cfgSyncing then return end
if v then F.NoClipEnable() else F.NoClipDisable() end
end })
Tabs.Move:AddToggle("Hide", { Title = "藏地下", Default = false, Callback = function(v)
T.Hide = v
if F._cfgSyncing then return end
if v then F.HideEnable() else F.HideDisable() end
end })
Tabs.Move:AddSlider("HideDepth", { Title = "藏地下深度(studs)", Min = 1, Max = 50, Default = 8, Rounding = 0, Callback = function(v) C.HideDepth = v end })
end
do
Tabs.Visual:AddSection("身体高亮 / 敌我识别")
Tabs.Visual:AddToggle("BodyHL", { Title = "身体高亮(只描边不糊本体)", Default = false, Callback = function(v)
T.BodyHL = v
if F._cfgSyncing then return end
if v then F.BodyHLEnable() else F.BodyHLDisable() end
end })
Tabs.Visual:AddToggle("TeamColorHL", { Title = "敌我识别(队友绿 / 敌人红)", Default = false, Callback = function(v)
local changed = (T.TeamColorHL ~= nil) and (T.TeamColorHL ~= v)
T.TeamColorHL = v
F.BodyHLRefresh()
end })
Tabs.World:AddSection("画面增强")
Tabs.World:AddToggle("VisionBoost", { Title = "视觉增强(全亮+夜视+去雾)", Default = false, Callback = function(v)
T.FullBright = v T.NightVision = v T.NoFog = v
if F._cfgSyncing then return end
if v then F.FullBrightEnable() F.NightVisionEnable() F.NoFogEnable()
else F.FullBrightDisable() F.NightVisionDisable() F.NoFogDisable() end
end })
Tabs.World:AddToggle("ViewBoost", { Title = "视角增强(FOV+无限缩放)", Default = false, Callback = function(v)
T.FOV = v T.Zoom = v
if F._cfgSyncing then return end
if v then FOVEnable() ZoomEnable() else FOVDisable() ZoomDisable() end
end })
Tabs.World:AddSlider("FOV", { Title = "视野 FOV", Min = 70, Max = 120, Default = 100, Rounding = 0, Callback = function(v)
C.FOV = v
if F._cfgSyncing then return end
if T.FOV then FOVEnable() end
end })
Tabs.World:AddSlider("Zoom", { Title = "缩放距离(POV · 拖了立刻生效)", Min = 128, Max = 3000, Default = 400, Rounding = 0, Callback = function(v)
C.Zoom = v
pcall(function()
LP.CameraMaxZoomDistance = v
LP.CameraMinZoomDistance = 0.5
end)
end })
Tabs.World:AddToggle("Mute", { Title = "静音", Default = false, Callback = function(v)
T.Mute = v
if F._cfgSyncing then return end
if v then MuteEnable() else MuteDisable() end
end })
Tabs.World:AddToggle("Antilag", { Title = "降画质", Default = false, Callback = function(v)
T.Antilag = v
if F._cfgSyncing then return end
if v then AntilagEnable() else AntilagDisable() end
end })
Tabs.World:AddSection("相机 / 准星")
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
Tabs.World:AddToggle("LockCam", { Title = "锁相机", Default = false, Callback = function(v)
T.LockCam = v
if F._cfgSyncing then return end
if v then F.LockCamEnable() else F.LockCamDisable() end
end })
end
do
Tabs.TP:AddSection("传送")
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
Tabs.TP:AddSection("偷蛋(扫描 → 排序 → 自选 → 远程拿)")
Tabs.TP:AddButton({ Title = "① 扫描地图上的蛋(按最重/最贵排序)", Callback = function() F.EggScanAndFill() end })
Tabs.TP:AddDropdown("EggFilter", { Title = "② 筛选(只要这些)", Values = {
"全部", "稀有度 ≥ 3", "稀有度 ≥ 5", "只要有重量",
}, Default = "全部", Callback = function(v)
C.EggFilter = v
F.Out("[偷蛋] 筛选 = " .. tostring(v) .. " (下次扫描生效)")
end })
Tabs.TP:AddDropdown("EggSort", { Title = "③ 排序方式(扫完按这个排)", Values = {
"最重(kg)", "最贵(价值)", "稀有度", "距离最近", "按区域(展台)", "自己看",
}, Default = "最重(kg)", Callback = function(v)
C.EggSort = v
if F._eggs and #F._eggs > 0 then
pcall(F.EggSortNow)
pcall(function()
local labels = F.EggLabels()
local op = Fluent and Fluent.Options and Fluent.Options.EggPick
if op and op.Refresh then op:Refresh(labels) end
end)
local u2 = F._eggSortUsed
F.Out("[偷蛋] 已按「" .. tostring(v) .. "」重排"
.. (u2 and (" (实际用「" .. tostring(F.EGG_SORT_NAME[u2] or u2) .. "」)") or ""))
end
end })
Tabs.TP:AddDropdown("EggPick", { Title = "③ 目标蛋(按上面排序, 自己挑)", Values = { "(先点①扫描)" }, Default = nil, Callback = function(v)
local i = tonumber(tostring(v):match("^#(%d+)"))
F._eggPick = i or 0
end })
Tabs.TP:AddButton({ Title = "⑦ 走过去拿(不传送 · 不容易被位置差检测抓)", Callback = function() T.EggWalk = true pcall(F.EggWalkTo) end })
Tabs.TP:AddToggle("GuardAvoid", { Title = "守卫规避(靠太近自动撤开)", Default = false, Callback = function(v)
local changed = (T.GuardAvoid ~= nil) and (T.GuardAvoid ~= v)
T.GuardAvoid = v
if F._cfgSyncing or not changed then return end
if v then pcall(F.GuardAvoidEnable) else pcall(F.GuardAvoidDisable) end
end })
Tabs.TP:AddButton({ Title = "④ 传送到选中的蛋", Callback = function()
local e = F.EggGo(3)
if e then F.Out("[偷蛋] 已传送到 #" .. tostring(F._eggPick) .. " " .. e.name) end
end })
Tabs.TP:AddButton({ Title = "⑤ 设安全点(远程拿的回程点)", Callback = function()
local _, _, root = GC()
if not root then F.Out("[偷蛋] 现在没角色") return end
local p = root.Position
C.SafePoint = { x = p.X, y = p.Y, z = p.Z }
pcall(SaveConfig)
F.Out(string.format("[偷蛋] 安全点已记下: (%.0f, %.0f, %.0f)", p.X, p.Y, p.Z))
end })
Tabs.TP:AddButton({ Title = "⑥ 远程拿: 传过去 → 触发交互 → 回安全点", Callback = function() F.EggRemoteSteal() end })
Tabs.TP:AddSection("交互(偷蛋/开箱/机关)")
Tabs.AFK:AddSection("自动化")
Tabs.AFK:AddToggle("AutoTrain", { Title = "踢击训练", Default = false, Callback = function(v)
T.AutoTrain = v
if F._cfgSyncing then return end
if v then F.AutoTrainEnable() end
end })
Tabs.AFK:AddToggle("AutoBonus", { Title = "领取踢击距离", Default = false, Callback = function(v)
T.AutoBonus = v
if F._cfgSyncing then return end
if v then F.AutoBonusEnable() end
end })
Tabs.AFK:AddSlider("AutoTrainSec", { Title = "训练循环间隔(秒)", Min = 1, Max = 30, Default = 5, Rounding = 1, Callback = function(v) C.AutoTrainSec = v end })
Tabs.AFK:AddToggle("AutoGym", { Title = "自动锻炼(健身房)", Default = false, Callback = function(v)
T.AutoGym = v
if F._cfgSyncing then return end
if v then F.AutoGymEnable() end
end })
Tabs.AFK:AddSection("脑红 / 现金")
Tabs.AFK:AddButton({ Title = "★ 一键收起脑红(全部槽位, 最多 30)", Callback = function() F.WithdrawAll(30) end })
Tabs.AFK:AddButton({ Title = "一键收钱(全部槽位)", Callback = function() F.CollectAll(30) end })
Tabs.AFK:AddDropdown("BaseView", { Title = "只读查看(选完自动复位, 不改动任何东西)", Values = {
"关闭", "会卖哪些(除限定)", "基地数据(金币/踢力/精通/速度/重生)", "升级性价比(先升哪个最划算)",
}, Default = "关闭", Callback = function(v)
if v == "关闭" then return end
task.spawn(function()
if v == "会卖哪些(除限定)" then
pcall(F.PreviewSell)
elseif v == "基地数据(金币/踢力/精通/速度/重生)" then
pcall(F.ReadBase)
else
pcall(F.UpgradeAdvice)
end
task.defer(function()
local op = Fluent and Fluent.Options and Fluent.Options.BaseView
if op and op.Value ~= "关闭" then pcall(function() op:Set("关闭") end) end
end)
end)
end })
Tabs.AFK:AddButton({ Title = "卖光(除限定/独家: 一次卖完可算出的脑红)", Callback = function() F.SellAll() end })
Tabs.AFK:AddInput("SellMinCPSTxt", { Title = "卖出门槛(可写 80m / 500K / 数字)", Default = "100K",
Placeholder = "低于它就卖掉", Callback = function(v)
local n = F.ParseCPS(v)
if n then
C.SellMinCPS = n
C.SellMinCPSTxt = v
F.Out("[售卖] 门槛已设为 " .. F.FmtNum(n))
elseif v ~= "" then
Fluent:Notify({ Title = "门槛格式", Content = "认不出「" .. tostring(v) .. "」—— 请写 500K / 1.5m / 100000", Duration = 6 })
end
end })
Tabs.AFK:AddSlider("SellLvMul", { Title = "等级乘数(估算 CPS 用, 1.25 = 每级 ×1.25)", Min = 1, Max = 2, Default = 1.25, Rounding = 2,
Callback = function(v) C.SellLvMul = v end })
Tabs.AFK:AddToggle("AutoSell", { Title = "按 CPS 卖出(走到蒂米身边卖 · 卖完自动关)", Default = false, Callback = function(v)
T.AutoSell = v
if F._cfgSyncing then return end
if v then pcall(F.SellLowCPS) elseif not F._sellFinish then F.Out("[售卖] 已停止(当前这一轮会跑完)") end
end })
Tabs.Trans:AddSection("本地翻译服务")
Tabs.Trans:AddToggle("Translate", { Title = "翻译总开关(UI 文字 + 互动文字)", Default = false, Callback = function(v)
if F._cfgSyncing then return end
if v then
F.TranslateEnable()
else
F.TranslateDisable()
end
end })
Tabs.Trans:AddDropdown("TransLang", { Title = "目标语言", Values = { "zh", "en", "ja", "ko", "th", "ru", "ar", "id" },
Default = "zh", Callback = function(v) C.TransLang = v end })
Tabs.Trans:AddSection("聊天 / 气泡")
Tabs.Trans:AddToggle("ChatTranslate", { Title = "公屏聊天翻译(官方钩子)", Default = false, Callback = function(v)
T.ChatTranslate = v
if F._cfgSyncing then return end
if v then F.ChatTranslateEnable() else F.ChatTranslateDisable() end
end })
Tabs.Trans:AddToggle("BubbleTranslate", { Title = "气泡聊天翻译(官方钩子)", Default = false, Callback = function(v)
T.BubbleTranslate = v
if F._cfgSyncing then return end
if v then F.BubbleTranslateEnable() else F.BubbleTranslateDisable() end
end })
Tabs.AC:AddSection("反作弊")
Tabs.AC:AddToggle("ACMaster", { Title = "防护(反甩[只清异常速度] + 护界面 + 权限守卫 · 不动你的碰撞/交互)", Default = false, Callback = function(v)
if F._cfgSyncing then
T.AntiFling = v T.GuiProtect = v T.CharPersist = true
return
end
if v then
T.AntiFling = true T.GuiProtect = true T.CharPersist = true
F.AntiFlingEnable()
task.spawn(function()
local acName = AC.DetectStrongAC(true)
if acName then AC.SetQuiet(true) end
F.ProtectGui()
pcall(F.GuiProtectionEnable)
pcall(F.AuthorityGuard, true)
Fluent:Notify({
Title = "防护",
Content = "已开启: 反甩(只清异常速度) + 界面保护 + 权限守卫 · 环境 " .. tostring(acName or "未识别")
.. " · 已确保不动你的碰撞/触碰(跑步机与道具照常可用)",
Duration = 8,
})
end)
else
T.AntiFling = false T.GuiProtect = false
pcall(F.AntiFlingDisable)
pcall(F.GuiProtectionDisable)
Fluent:Notify({ Title = "防护", Content = "已关闭", Duration = 3 })
end
end })
Tabs.AC:AddButton({ Title = "一键扫描(能力+脚本+远程+监听+连接清理)", Callback = function()
task.spawn(function()
local _, capOk, capTotal = F.ProbeCapabilities(false)
local n = F.UnifiedACPass()
pcall(F.ScanRemotes)
pcall(F.ScanGameModules)
pcall(F.ScanScripts)
pcall(F.ScanConnections)
pcall(F.LogFlush, "统一扫描")
Fluent:Notify({
Title = "扫描完成",
Content = "Hook 层数 " .. tostring(n) .. " · 执行器能力 " .. tostring(capOk) .. "/" .. tostring(capTotal) .. " —— 明细见控制台 F9",
Duration = 8,
})
end)
end })
Tabs.AC:AddSection("扫描补强(一个下拉全搞定 · 选完自动复位)")
Tabs.AC:AddDropdown("AdvScan", { Title = "选一项执行(选完自动复位)", Values = {
"关闭", "按形状找函数(高级参数填 19,15)",
"按常量字符串找函数(高级参数填 词1,词2)", "客户端检测扫描(脚本名 + 连接来源)",
}, Default = "关闭", Callback = function(v)
if v == "关闭" then return end
local box = Fluent and Fluent.Options and Fluent.Options.AdvArg
local txt = box and tostring(box.Value or "") or ""
task.spawn(function()
pcall(function()
if v:find("按形状", 1, true) then
local a, b = txt:match("^(%d+)[,%s]+(%d+)$")
if a and b then
F.FindByShape(tonumber(a), tonumber(b))
else
F.Out("[形状] 高级参数为空或格式不对 —— 形状就是 (upvalue 个数, 常量个数), 例如 19,15")
end
elseif v:find("按常量字符串", 1, true) then
local list = {}
for w in txt:gmatch("[^,，]+") do
local t = w:gsub("^%s+", ""):gsub("%s+$", "")
if #t > 0 then list[#list + 1] = t end
end
if #list > 0 then
F.ScanByConstants(list, "all")
else
F.Out("[按常量] 高级参数为空 —— 填你从脚本/日志里看到的原文, 例如 anti-cheat,speed")
end
elseif v:find("客户端检测", 1, true) then
pcall(F.ScanClientChecks, true)
end
end)
pcall(F.LogFlush, "扫描补强")
task.defer(function()
local op = Fluent and Fluent.Options and Fluent.Options.AdvScan
if op and op.Value ~= "关闭" then pcall(function() op:Set("关闭") end) end
end)
end)
end })
Tabs.AC:AddInput("AdvArg", { Title = "高级参数(可留空 = 走全自动): 形状写 19,15 · 关键词写 词1,词2", Default = "",
Placeholder = "留空 = 走全自动", Callback = function() end })
Tabs.AC:AddSection("采集与导出")
Tabs.AC:AddToggle("CaptureOn", { Title = "采集 remote 上行(边玩边记, 导出看结果)", Default = false, Callback = function(v)
if F._cfgSyncing then return end
if v then
local ok = F.CaptureEnable()
Fluent:Notify({ Title = "采集", Content = ok and "已开始记录上行 remote 参数 —— 玩一会儿后点「一键全量导出」" or "开启失败(执行器不支持 hookmetamethod)", Duration = 8 })
else
Fluent:Notify({ Title = "采集", Content = "已停止, 共记录 " .. tostring(F.CaptureDisable()) .. " 条", Duration = 5 })
end
end })
Tabs.AC:AddButton({ Title = "一键全量导出(内容复制到剪贴板)", Callback = function()
task.spawn(function()
local txt = F.DumpAll()
pcall(F.LogDump, txt, "全量导出")
Fluent:Notify({
Title = "全量导出",
Content = "已生成 " .. tostring(#txt) .. " 字符; 已尝试复制到剪贴板, 直接粘贴即可。含服务端判定输入面(上行 remote 参数)",
Duration = 10,
})
end)
end })
Tabs.Setting:AddSection("系统")
Tabs.Setting:AddToggle("Session", { Title = "会话保持(自动存档 + 角色持续 + 实时玩家列表)", Description = "把原来三个点不到的功能合成一个: 定时自动存配置 / 角色重生后保持设置 / 实时刷新玩家列表", Default = false, Callback = function(v)
local changed = (T.Session ~= nil) and (T.Session ~= v)
T.Session = v
if F._cfgSyncing or not changed then return end
if v then
T.AutoSave, T.CharPersist = true, true
pcall(F.AutoSaveEnable)
pcall(F.LivePlayersEnable)
F.Out("[会话保持] 已开: 自动存档 + 角色持续 + 实时玩家列表")
else
T.AutoSave, T.CharPersist = false, false
pcall(F.AutoSaveDisable)
pcall(F.LivePlayersDisable)
pcall(F.CharPersistDisable)
F.Out("[会话保持] 已关")
end
end })
Tabs.Setting:AddButton({ Title = "保存配置", Callback = function() SaveConfig() Fluent:Notify({ Title = "配置", Content = "已保存", Duration = 2 }) end })
Tabs.Setting:AddDropdown("FixTool", { Title = "★ 诊断与修复(选一项执行 · 选完自动复位)", Values = {
"环境自检(手机/平板没效果先跑这个)",
"修复角色碰撞(踩不上跑步机 / 道具没反应)",
"扫描 HUD 数字控件(读不到数值时)",
"恢复上次开启的功能",
"反拉回诊断(所有权→夺取→探针, 会用异常位移)",
"强制重载(即使已是最新也重下一遍)",
}, Default = nil, Callback = function(v)
if F._cfgSyncing or type(v) ~= "string" then return end
if string.find(v, "环境自检", 1, true) then
pcall(F.EnvSelfCheck)
elseif string.find(v, "修复角色", 1, true) then
pcall(F.FixCharCollision)
elseif string.find(v, "扫描 HUD", 1, true) then
pcall(F.ScanHUD)
elseif string.find(v, "恢复上次", 1, true) then
pcall(F.RestoreSavedFeatures)
elseif string.find(v, "反拉回诊断", 1, true) then
pcall(F.SrvOneClick)
elseif string.find(v, "强制重载", 1, true) then
pcall(F.HotReload, true)
end
end })
Tabs.Setting:AddButton({ Title = "★ 热加载(已是最新就不动 · 保留已开功能; 要强制重下用上面的诊断下拉)", Callback = function() F.HotReload(false) end })
Tabs.Setting:AddButton({ Title = "重新进入服务器(回同一个服务器)", Callback = function() F.RejoinNow() end })
Tabs.Setting:AddButton({ Title = "一键全关(关掉所有功能并还原)", Callback = function() pcall(F.PanicKeyDisableAll) end })
F.UnloadAll = UnloadAll
pcall(function()
local g = getgenv and getgenv()
if type(g) ~= "table" then return end
F._inst = {
version = F.VERSION,
unload = function() pcall(UnloadAll) end,
gui = (Fluent and Fluent.GUI) or nil,
handles = {},
}
g[F.INSTANCE_KEY] = F._inst
end)
Tabs.Setting:AddButton({ Title = "卸载脚本", Callback = function()
pcall(function() Fluent:Notify({ Title = "卸载", Content = "正在卸载…界面会消失; 日志里会有 [卸载] 复核结果", Duration = 2 }) end)
task.defer(function()
pcall(UnloadAll)
pcall(function() F.LogFlush("卸载") end)
end)
end })
T.CharPersist = true
T.AutoSave = true
F.CharPersistEnable()
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
pcall(function()
local ex = "?"
pcall(function() ex = tostring(select(2, pcall(identifyexecutor))) end)
F.Out(string.format("[环境] 执行器=%s · 平台=%s · loadstring=%s · writefile=%s · gethui=%s · 触屏=%s",
ex, (UIS.TouchEnabled and "触屏(手机/平板)" or "键鼠(PC)"),
type(loadstring), type(writefile), type(gethui), tostring(UIS.TouchEnabled)))
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
local okBuild = pcall(buildMenu)
F._cfgSyncing = false
if not okBuild then F.Out("[CheatMenu] 菜单构建期出错(已兜住)") end
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
function F.CfgSyncUI()
local op = Fluent and Fluent.Options
if type(op) ~= "table" then return 0 end
local n = 0
F._cfgSyncing = true
pcall(function()
for name, opt in pairs(op) do
if type(name) == "string" and type(opt) == "table" and type(opt.Set) == "function" then
local dyn = false
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
