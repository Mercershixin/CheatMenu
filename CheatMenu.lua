print(('[CheatMenu] build 2026-10-01 00:41 sha 121900d5 bytes 239986'):format('2026-10-01 00:41','121900d5',239986))
local F = {}
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
if s:find(from, 1, true) then s = s:gsub(from, F.SANITIZE[i][2]) end
end
return s
end
F._logBuf = F._logBuf or {}
F.LOG_BUF_MAX = F.LOG_BUF_MAX or 300
function F.Out(...)
local n = select("#", ...)
local parts = {}
for i = 1, n do parts[i] = F.Sanitize(select(i, ...)) end
local line = table.concat(parts, " ")
print(line)
F._logBuf[#F._logBuf + 1] = line
if F.LogFlush and not F._logFlushing and #F._logBuf >= F.LOG_BUF_MAX then
pcall(F.LogFlush, "自动")
end
end
F.Out("[CheatMenu] ===== 加载开始 · v10.3.0 =====")
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
"https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://ghproxy.net/https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://cdn.jsdelivr.net/gh/dawid-scripts/Fluent@master/main.lua",
}
for _, url in ipairs(FLUENT_SOURCES) do
local ok, body = pcall(function() return game:HttpGet(url) end)
if ok and type(body) == "string" and #body > 5000 then
local ok2, chunk = pcall(loadstring, body)
if ok2 and chunk then
local ok3, loaded = pcall(chunk)
if ok3 and loaded then Fluent = loaded F.Out("[CheatMenu] Fluent 加载成功") break end
end
end
end
if not Fluent then
pcall(function()
F.Out("[CheatMenu] ✗ Fluent UI 加载失败 —— 多半是网络取不到镜像(GitHub/ghfast/jsDelivr)。")
F.Out("[CheatMenu]   处理: 换能联网的执行器重试; 或先把 CheatMenu.lua 下载到本地用文件加载。")
end)
return
end
local AC = {}
AC.BlockedRemotes = {}
AC.BlockedCount = 0
AC._idxMaskOn = false
AC._idxMaskOld = nil
AC._stblOld = nil
AC._scriptWatchConn = nil
AC._desyncOn = false
AC._desyncLoc = CFrame.new()
AC._desyncHook = nil
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
function AC.ThresholdReport()
F.Out("════ 强反作弊阈值对齐自查 ════")
local ac = AC.DetectStrongAC(false)
F.Out("  本服指纹: " .. (ac and ("检测到 " .. ac) or "未检测到已知强反作弊(不等于没有, 服务端实现客户端看不见)"))
for i = 1, #AC.KNOWN_LIMITS do
local L = AC.KNOWN_LIMITS[i]
F.Out(string.format("  [%s] %s = %s %s  ->  我方: %s", L.src, L.key, tostring(L.val), L.unit, L.ours))
end
F.Out("  提示: 服务端判定的阈值只能从公开实现反推; 上述数字全部取自公开源码, 不是猜的。")
return ac
end
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
if i % 300 == 0 then task.wait() end
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
F._metaSeq = 0
function F.MetaInstall(slot, target, id, wrapperFactory)
if not (hookmetamethod and newcclosure and getrawmetatable) then return nil end
if type(slot) ~= "string" or type(id) ~= "string" or target == nil then return nil end
local bucket = F.MetaLayers[slot]
if not bucket then bucket = {} F.MetaLayers[slot] = bucket end
if bucket[id] then F.MetaUninstall(slot, id) end
local mt = getrawmetatable(target)
if type(mt) ~= "table" or type(mt[slot]) ~= "function" then return nil end
local box = { alive = true, orig = nil, id = id, slot = slot }
local raw = wrapperFactory(box)
if type(raw) ~= "function" then return nil end
F._metaSeq = F._metaSeq + 1
local rec = { id = id, slot = slot, target = target, box = box, raw = raw, seq = F._metaSeq, alive = true }
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
return true
end
function F.MetaActive(slot, id)
local b = F.MetaLayers[slot]
return (b and b[id] and b[id].alive) and true or false
end
function F.MetaReport()
local out = {}
for slot, bucket in pairs(F.MetaLayers) do
local ids = {}
for id in pairs(bucket) do ids[#ids + 1] = id end
if #ids > 0 then out[#out + 1] = slot .. " -> " .. table.concat(ids, ",") end
end
if #out == 0 then return "元方法槽位: 空" end
return "元方法槽位: " .. table.concat(out, " | ")
end
function AC.InstallNamecallHook()
if AC._nc then return true end
local got = F.MetaInstall("__namecall", game, "AC", function(box)
return function(self, ...)
local method = getnamecallmethod and getnamecallmethod() or ""
if method == "Kick" and rawequal(self, LP) and T.NamecallHook then
F.Out("[CheatMenu] 拦下 Kick: " .. tostring(select(1, ...)))
return nil
end
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
AC.BlockedCount = AC.BlockedCount + 1
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
AC.BlockedCount = 0
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
function AC.RemoveAnimationHandler()
local removed, seen = 0, 0
local roots = F.filterList(LP.Character, LP:FindFirstChild("PlayerScripts"),
LP:FindFirstChild("PlayerGui"), RStorage, workspace)
for _, root in ipairs(roots) do
local ok = pcall(function()
for _, d in ipairs(root:GetDescendants()) do
seen = seen + 1
if seen % 300 == 0 then task.wait() end
if seen > 30000 then break end
if d.Name == "AnimationHandler" and (d:IsA("LocalScript") or d:IsA("ModuleScript")) then
pcall(function() d:Destroy() end)
removed = removed + 1
end
end
end)
if not ok then end
if seen > 30000 then break end
end
if removed > 0 then F.Out("[CheatMenu] 已删除 " .. removed .. " 个 AnimationHandler") end
return removed
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
if T.Speed then v = (C._baseWalk or 16) * 2 end
elseif k == "JumpPower" then
if T.InfiniteJump or T.Speed then v = 50 end
elseif k == "JumpHeight" then
if T.InfiniteJump then v = 7.5 end
end
end
end
if k == "Parent" and (T.ACBypass or T.PropertyLock) then
local isForce = false
pcall(function()
isForce = t:IsA("BodyVelocity") or t:IsA("BodyGyro") or t:IsA("BodyForce")
or t:IsA("BodyThrust") or t:IsA("BodyAngularVelocity")
end)
if isForce and v ~= nil then AC._forceInst = (AC._forceInst or 0) + 1 end
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
if k == "WalkSpeed" then return C._baseWalk or 16 end
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
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
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
for _, v in ipairs(workspace:GetDescendants()) do
nScan = nScan + 1
if nScan % 400 == 0 then task.wait() end
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
function F.GuardedGetGC(pass, force)
local now = os.clock()
if not force and (now - (F._lastGetGC or 0) < 2) then return {} end
F._lastGetGC = now
if type(getgc) ~= "function" then return {} end
local ok, r = pcall(getgc, pass)
return (ok and type(r) == "table") and r or {}
end
F.GC_SPOOF_KEYS = { "info", "getinfo", "getupvalue", "getupvalues", "getconstants", "getprotos" }
F._scavenging = false
F._debugHookOn = false
F._stealthRestore = {}
F._stealthHooked = setmetatable({}, { __mode = "k" })
function F.getGameEnv()
if type(getrenv) ~= "function" then return nil end
local ok, env = pcall(getrenv)
return (ok and type(env) == "table") and env or nil
end
F.filterList = function(...)
local out = {}
for i = 1, select("#", ...) do
local v = select(i, ...)
if v ~= nil then out[#out + 1] = v end
end
return out
end
function F.isProtectedFn(f)
return type(f) == "function" and (AC._ownFns[f] == true or AC._hookedFns[f] == true)
end
function F.stealthHook(obj, wrapperFactory)
if type(obj) ~= "function" then return nil end
if F._stealthHooked[obj] then return nil end
if not (hookfunction and newcclosure) then return nil end
local box = { orig = nil }
local wrapper = wrapperFactory(box)
if T.CloneHook and type(clonefunction) == "function" then
local okc, cloned = pcall(clonefunction, wrapper)
if okc and type(cloned) == "function" then wrapper = cloned end
end
local ok, res = pcall(function() return hookfunction(obj, newcclosure(wrapper)) end)
if ok and type(res) == "function" then
box.orig = res
F._stealthHooked[obj] = true
F._stealthRestore[#F._stealthRestore + 1] = { obj = obj, orig = res }
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
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
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
function AC.FnDesc(f)
if type(f) ~= "function" then return "(不是函数)" end
local keep = F._scavenging
F._scavenging = true
local oki, info = pcall(debug.getinfo, f, "nS")
F._scavenging = keep
if not oki or not info then return "(元数据不可读)" end
return string.format("%s @ %s:%s", tostring(info.name or "?"), tostring(info.source or "?"), tostring(info.linedefined or "?"))
end
AC.NEUTRALIZE_NAMES = {
"GetPlayerBanned", "IsPlayerBanned", "BanPlayer", "PunishPlayer", "ReportPlayer",
"SuspendPlayer", "FlagPlayer", "AntiCheatDetected", "ACDetected", "OnDetected",
"Detected", "detected", "FlagPlayerForCheating",
}
function AC.NeutralizeByName(extra)
local hit, found = 0, 0
local function kill(nm)
local _, list = AC.FindFn(nm, true)
if type(list) ~= "table" then return 0, 0 end
local k, seenN = 0, 0
for i = 1, #list do
local fn = list[i]
if type(fn) == "function" then
seenN = seenN + 1
if not AC._hookedFns[fn] then
local got = F.stealthHook(fn, function(box)
return function() return nil end
end)
if got then AC.markHooked(fn) k = k + 1 end
end
end
end
if k > 0 then
F.Out(string.format("[CheatMenu] 按名中和: %s x%d (首个: %s)", nm, k, AC.FnDesc(list[1])))
end
return k, seenN
end
for i = 1, #AC.NEUTRALIZE_NAMES do
local k, s = kill(AC.NEUTRALIZE_NAMES[i])
hit = hit + k found = found + s
end
if type(extra) == "table" then
for i = 1, #extra do
if type(extra[i]) == "string" and extra[i] ~= "" then
local k, s = kill(extra[i])
hit = hit + k found = found + s
end
end
end
F.Out(string.format("[CheatMenu] 按名中和完成: 命中 %d 个具名函数, 已中和 %d 个", found, hit))
return hit, found
end
function AC.ScaleSignalHandler(sig, factor)
if not sig or type(getconnections) ~= "function" or type(factor) ~= "number" then return 0 end
local ok, conns = pcall(getconnections, sig)
if not (ok and type(conns) == "table") then return 0 end
local n = 0
for i = 1, #conns do
local c = conns[i]
local fn = nil
pcall(function() fn = c.Function end)
if type(fn) == "function" and not AC.isOwnConn(fn) and not AC._hookedFns[fn] then
local got = F.stealthHook(fn, function(box)
return function(...)
local args = { ... }
local touched = false
for j = 1, #args do
if typeof(args[j]) == "Vector3" then
args[j] = args[j] * factor
touched = true
end
end
if not touched then return box.orig(...) end
return box.orig(table.unpack(args))
end
end)
if got then AC.markHooked(fn) n = n + 1 end
end
end
return n
end
AC.KNOCK_KEYS = { "knockback", "knock", "velocity", "impulse", "push", "launch", "ragdoll" }
function AC.ScaleKnockback(factor)
local total, sigs = 0, 0
local keepScav = F._scavenging
F._scavenging = true
pcall(function()
local rs = AC.svc("ReplicatedStorage") or RStorage
for _, d in ipairs(rs:GetDescendants()) do
if AC.isRemoteLike(d) then
local n = d.Name:lower()
for i = 1, #AC.KNOCK_KEYS do
if n:find(AC.KNOCK_KEYS[i], 1, true) then
sigs = sigs + 1
total = total + AC.ScaleSignalHandler(d.OnClientEvent, factor)
break
end
end
end
end
end)
F._scavenging = keepScav
F.Out(string.format("[CheatMenu] 击退/速度缩放 x%s: 命中 %d 个信号, 改写 %d 个回调", tostring(factor), sigs, total))
return total
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
F.SCAN_ATTR_ROOTS = { workspace, LP, RStorage }
function F.ScanAttributes(keyword, roots, limit)
local kw = type(keyword) == "string" and keyword:lower() or ""
local maxN = tonumber(limit) or 4000
local hits, seen, scanned = {}, 0, 0
local list = roots or F.SCAN_ATTR_ROOTS
local keepScav = F._scavenging
F._scavenging = true
for i = 1, #list do
local root = list[i]
if root then
pcall(function()
local bag = { root }
for _, d in ipairs(root:GetDescendants()) do
bag[#bag + 1] = d
end
for j = 1, #bag do
scanned = scanned + 1
if scanned > maxN then break end
if scanned % 500 == 0 then task.wait() end
local obj = bag[j]
local okA, attrs = pcall(function() return obj:GetAttributes() end)
if okA and type(attrs) == "table" then
for k, v in pairs(attrs) do
seen = seen + 1
if kw == "" or tostring(k):lower():find(kw, 1, true) then
local sv = tostring(v)
if #sv > 40 then sv = sv:sub(1, 40) .. "…" end
local okN, full = pcall(function() return obj:GetFullName() end)
local path = (okN and type(full) == "string") and full or tostring(obj)
hits[#hits + 1] = { path = path, key = tostring(k), value = sv }
end
end
end
end
end)
end
end
F._scavenging = keepScav
F.Out(string.format("[属性扫描] 扫过 %d 个实例, 共 %d 条属性, 命中 %d 条%s",
scanned, seen, #hits, kw ~= "" and (" (关键词 " .. kw .. ")") or ""))
local shown = 0
for i = 1, #hits do
if shown >= 80 then F.Out("  … 其余省略, 共 " .. #hits .. " 条") break end
local h = hits[i]
F.Out(string.format("  · %s  [%s = %s]", h.path, h.key, h.value))
shown = shown + 1
end
return hits, scanned, seen
end
function AC.StripMetatable(keyName)
if type(keyName) ~= "string" or keyName == "" then return 0 end
local n = 0
local keepScav = F._scavenging
F._scavenging = true
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
local isMine = false
if type(obj) == "table" then
local okm, mine = pcall(function()
for _, v in pairs(obj) do
if type(v) == "function" and AC._ownFns[v] then return true end
end
return false
end)
isMine = (okm and mine) or false
end
if type(obj) == "table" and not isMine then
local ok, v = pcall(rawget, obj, keyName)
if ok and v ~= nil then
local ok2 = pcall(function()
local mt = getmetatable(obj)
if mt then setmetatable(obj, {}) end
end)
if ok2 then n = n + 1 end
end
end
end
F._scavenging = keepScav
F.Out(string.format("[CheatMenu] 元表剥离: 含键 %q 的表 %d 个", keyName, n))
return n
end
function AC.PokeUpvalue(fnName, idx, value)
local f = AC.FindFn(fnName)
if type(f) ~= "function" or type(idx) ~= "number" then return false end
local ok = pcall(function()
local okset = (type(setupvalue) == "function")
if okset then setupvalue(f, idx, value) else debug.setupvalue(f, idx, value) end
end)
F.Out(string.format("[CheatMenu] 原地改 upvalue: %s[%s] = %s -> %s", tostring(fnName), tostring(idx), tostring(value), ok and "成功" or "失败"))
return ok
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
{ "getrenv", "拿游戏侧环境副本 —— 隐身第 2/3 层靠它" },
{ "cloneref", "安全取服务引用" },
{ "getthreadidentity", "线程身份伪装" },
{ "setupvalue", "原地改 upvalue(零 hook 指纹)" },
{ "fireproximityprompt", "直接触发交互" },
{ "sethiddenproperty", "写隐藏属性" },
{ "request", "HTTP 请求" },
{ "Drawing", "Drawing API(骨骼线/角框高性能绘制)" },
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
function F.capSummary()
local res = F._caps or select(1, F.ProbeCapabilities(false))
local n, t = 0, 0
for _, v in pairs(res) do t = t + 1 if v then n = n + 1 end end
return n, t
end
F.AC_INVISIBLE = {
"服务器脚本源码(ServerScriptService / ServerStorage 不下发到客户端)",
"服务端判定逻辑与阈值(在服务端跑, 客户端不可见)",
"Roblox 自带反作弊 Hyperion(原生二进制, 非 Lua)",
"服务端玩家的真实位置/速度(只得到复制后的结果)",
}
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
for _, d in ipairs(RStorage:GetDescendants()) do add(d, "RS") end
if type(getnilinstances) == "function" then
for _, inst in ipairs(getnilinstances()) do add(inst, "nil") end
end
for _, v in pairs(seen) do snap.remotes[#snap.remotes + 1] = v end
table.sort(snap.remotes, function(a, b) return a.n < b.n end)
end)
pcall(function()
if type(getgc) ~= "function" then return end
local seen, n = {}, 0
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
n = n + 1
if n > 6000 then break end
if type(obj) == "function" and (not islclosure or islclosure(obj)) then
local oki, info = pcall(debug.getinfo, obj, "nS")
local nm = (oki and info and info.name) or ""
local src = (oki and info and info.source) or ""
local hit = AC.isSuspicious(nm) or AC.isSuspicious(src)
if not hit then
local okc, consts = pcall(debug.getconstants, obj)
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
for _, d in ipairs(r:GetDescendants()) do bag[#bag + 1] = d end
for j = 1, #bag do
nAttr = nAttr + 1
if nAttr % 400 == 0 then task.wait() end
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
function F.SnapshotFile() return "CheatMenu_ACSnapshot.json" end
function F.SnapshotSave()
local snap = F.SnapshotCollect()
local ok = pcall(function() writefile(F.SnapshotFile(), HS:JSONEncode(snap)) end)
if ok then
F.Out(string.format("[快照] 已保存: remote %d · 反作弊碎片 %d · 属性名 %d · 脚本指纹 %d",
#snap.remotes, #snap.acfns, #snap.attrs, #snap.scripthashes))
else
F.Out("[快照] ⚠ 写文件失败(执行器可能不支持 writefile), 快照只保留在内存里")
F._snapMem = snap
end
return snap
end
function F.SnapshotLoad()
local snap
pcall(function()
if readfile and isfile and isfile(F.SnapshotFile()) then
snap = HS:JSONDecode(readfile(F.SnapshotFile()))
end
end)
return snap or F._snapMem
end
function F.SnapshotDiff()
local old = F.SnapshotLoad()
if type(old) ~= "table" then
F.Out("[对比] 没有旧快照 —— 先点一次「保存扫描快照」, 之后游戏更新再点这个")
return nil
end
local new = F.SnapshotCollect()
local d = { remoteNew = {}, remoteGone = {}, remoteChanged = {}, acNew = {}, acGone = {},
attrNew = {}, attrGone = {}, hashChanged = {}, capsLost = {} }
local function idx(list, key)
local m = {}
if type(list) == "table" then for i = 1, #list do m[list[i][key]] = list[i] end end
return m
end
local om, nm = idx(old.remotes, "n"), idx(new.remotes, "n")
for k, v in pairs(nm) do
if not om[k] then d.remoteNew[#d.remoteNew + 1] = v
elseif tostring(om[k].c) ~= tostring(v.c) or tostring(om[k].s) ~= tostring(v.s) then
d.remoteChanged[#d.remoteChanged + 1] = { n = k, old = om[k].c .. "/可疑" .. tostring(om[k].s), new = v.c .. "/可疑" .. tostring(v.s) }
end
end
for k, v in pairs(om) do if not nm[k] then d.remoteGone[#d.remoteGone + 1] = v end end
local okk, nkk = {}, {}
if type(old.acfns) == "table" then for i = 1, #old.acfns do okk[old.acfns[i].f .. "@" .. old.acfns[i].s] = true end end
if type(new.acfns) == "table" then for i = 1, #new.acfns do nkk[new.acfns[i].f .. "@" .. new.acfns[i].s] = true end end
for k in pairs(nkk) do if not okk[k] then d.acNew[#d.acNew + 1] = k end end
for k in pairs(okk) do if not nkk[k] then d.acGone[#d.acGone + 1] = k end end
local oa, na = idx(old.attrs, "k"), idx(new.attrs, "k")
for k in pairs(na) do if not oa[k] then d.attrNew[#d.attrNew + 1] = k end end
for k in pairs(oa) do if not na[k] then d.attrGone[#d.attrGone + 1] = k end end
local oh, nh = {}, {}
if type(old.scripthashes) == "table" then for i = 1, #old.scripthashes do oh[old.scripthashes[i].p] = tostring(old.scripthashes[i].h) end end
if type(new.scripthashes) == "table" then for i = 1, #new.scripthashes do
local p, h = new.scripthashes[i].p, tostring(new.scripthashes[i].h)
nh[p] = h
if oh[p] and oh[p] ~= h then d.hashChanged[#d.hashChanged + 1] = { p = p, old = oh[p], new = h } end
end end
if type(old.caps) == "table" and type(new.caps) == "table" then
for k, v in pairs(old.caps) do if v and not new.caps[k] then d.capsLost[#d.capsLost + 1] = k end end
end
d.oldT, d.newT = old.t, new.t
F.Out("═══ 快照对比(客户端可见面) ═══")
F.Out(string.format("  新 remote %d · 少 remote %d · remote 变了 %d",
#d.remoteNew, #d.remoteGone, #d.remoteChanged))
for i = 1, math.min(#d.remoteNew, 25) do F.Out("    + remote: " .. d.remoteNew[i].n .. " [" .. d.remoteNew[i].c .. "] 来源 " .. d.remoteNew[i].src) end
for i = 1, math.min(#d.remoteChanged, 25) do F.Out("    ~ remote: " .. d.remoteChanged[i].n .. "  " .. d.remoteChanged[i].old .. " -> " .. d.remoteChanged[i].new) end
for i = 1, math.min(#d.remoteGone, 15) do F.Out("    - remote: " .. d.remoteGone[i].n) end
F.Out(string.format("  反作弊碎片: 新增 %d · 消失 %d", #d.acNew, #d.acGone))
for i = 1, math.min(#d.acNew, 20) do F.Out("    + " .. d.acNew[i]) end
F.Out(string.format("  属性名: 新增 %d · 消失 %d", #d.attrNew, #d.attrGone))
for i = 1, math.min(#d.attrNew, 20) do F.Out("    + 属性: " .. d.attrNew[i]) end
if #d.hashChanged > 0 then
F.Out(string.format("  ★ 客户端脚本被改过 %d 个(这是最直接的「更新了哪个客户端脚本」证据)", #d.hashChanged))
for i = 1, math.min(#d.hashChanged, 15) do F.Out("    ~ " .. d.hashChanged[i].p) end
else
F.Out("  客户端脚本指纹: 无变化(或执行器不支持 getscripthash)")
end
if #d.capsLost > 0 then F.Out("  ⚠ 执行器能力丢失: " .. table.concat(d.capsLost, ", ")) end
F.Out("  ⚠ 服务端侧变化**看不见**: " .. F.AC_INVISIBLE[1])
F._lastDiff = d
return d
end
function F.ACSurfaceReport()
local snap = F.SnapshotCollect()
local sus, down = 0, 0
for i = 1, #snap.remotes do
if snap.remotes[i].s == 1 then sus = sus + 1 end
if snap.remotes[i].down == 1 then down = down + 1 end
end
F.Out("══════════ 反作弊面测绘 ══════════")
F.Out(string.format("【能看到 · 客户端可见面】"))
F.Out(string.format("  1) Remote 面: 共 %d 个(可下行 %d), 其中名字可疑 %d 个", #snap.remotes, down, sus))
for i = 1, math.min(#snap.remotes, 30) do
local r = snap.remotes[i]
F.Out(string.format("     %s [%s]%s 来源 %s", r.n, r.c, r.s == 1 and " ⚠可疑" or "", r.src))
end
F.Out(string.format("  2) 客户端侧反作弊碎片: %d 个函数(名字/source/常量命中关键词)", #snap.acfns))
for i = 1, math.min(#snap.acfns, 30) do F.Out("     " .. snap.acfns[i].f .. " @ " .. snap.acfns[i].s) end
F.Out(string.format("  3) 服务端写下来的属性名: %d 种(服务端权威数据的可见副本)", #snap.attrs))
F.Out(string.format("  4) 客户端脚本指纹: %d 个(执行器%s getscripthash)",
#snap.scripthashes, #snap.scripthashes > 0 and "支持" or "不支持"))
F.Out(string.format("  5) 位移权威: AuthorityMode = %s", tostring(snap.authority or "(无此字段)")))
F.Out("【看不见 · 原理上不可见(与本脚本无关)】")
for i = 1, #F.AC_INVISIBLE do F.Out("  ✗ " .. F.AC_INVISIBLE[i]) end
F.Out("⇒ 结论: 扫描给的是「客户端可见面 + 更新差异」, **不是**服务器判定逻辑。")
F.Out("  想看服务端怎么判, 唯一办法是它自己泄漏出来: 客户端上报脚本 + 它发的 remote 参数 + 服务端回写的值。")
return snap
end
F._capOn = false
F._capLog = {}
F._capOld = nil
F.CAP_MAX = 240
function F.CaptureEnable()
if F._capOn then return true end
if not (hookmetamethod and newcclosure and getnamecallmethod) then return false end
F._capLog = {}
local got = F.MetaInstall("__namecall", game, "Capture", function(box)
return function(self, ...)
if F._capOn and not checkcaller() and typeof(self) == "Instance" then
local m = getnamecallmethod()
if m == "FireServer" or m == "InvokeServer" then
F._capN = (F._capN or 0) + 1
if F._capN % 10 == 0 then
F.Out("[采集] 已记录 " .. F._capN .. " 条上行 remote, 最近: " .. tostring(self.Name) .. ":" .. tostring(m))
end
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
for _, d in ipairs(r:GetDescendants()) do bag[#bag + 1] = d end
for j = 1, #bag do
nA = nA + 1
if nA % 400 == 0 then task.wait() end
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
F._logBuf = {}
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
function F.LogWhere()
local dir, exec = nil, nil
pcall(function() local gw = AC.cap("getworkspace") if type(gw) == "function" then dir = gw() end end)
pcall(function() if type(getexecutorname) == "function" then exec = getexecutorname() end end)
local path
if dir then
path = tostring(dir):gsub("[\\/]+$", "") .. "\\" .. F.LogBaseName() .. ".txt"
else
path = "(执行器工作目录)\\" .. F.LogBaseName() .. ".txt"
end
F.Out("[日志] 执行器: " .. tostring(exec or "未知"))
F.Out("[日志] 文件路径: " .. path)
F.Out("[日志] 命名: " .. F.LogBaseName() .. ".txt (游戏名 + PlaceId, 不同游戏不冲突; 超 1.5MB 自动轮转 _2/_3)")
return path, exec
end
function F.LogFlush(tag)
if #F._logBuf == 0 then return nil end
if F._logFlushing then return nil end
F._logFlushing = true
local body = table.concat(F._logBuf, "\n") .. "\n"
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
for idx = 1, 20 do
local name = (idx == 1) and (base .. ".txt") or string.format("%s_%d.txt", base, idx)
local existed, size = false, 0
pcall(function()
if isfile and isfile(name) then
existed = true
local old = readfile(name)
size = #old
end
end)
if (not existed) or (size + #body <= F.LOG_MAX) then
local ok = pcall(function()
local old = ""
local oks = pcall(function()
if isfile and isfile(name) then old = readfile(name) end
end)
if not oks then old = "" end
writefile(name, old .. body)
end)
if ok then
okWrite = true
usedName = name
F.Out(string.format("[日志] %s 已写入 %s (%d 字节, 本次追加 %d 字符)", tostring(tag or ""), name, size + #body, #body))
end
break
end
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
for _, inst in ipairs(getnilinstances()) do
if typeof(inst) == "Instance" then AC.hookOneRemote(inst) end
end
end
for _, d in ipairs(RStorage:GetDescendants()) do
if AC.isRemoteLike(d) then AC.hookOneRemote(d) end
end
if type(getgc) ~= "function" then return end
local seen = 0
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
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
local okc, consts = pcall(debug.getconstants, obj)
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
blocked = AC.BlockedCount
end)
F._unifiedRunning = false
F._scavenging = keepScav
F.Out(string.format("[CheatMenu] 统一扫描 · 拦 remote=%d 中和=%d 清日志=%d 伪造遥测=%d", blocked, hooked, cleared, spoofed))
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
pcall(function() for _, d in ipairs(RStorage:GetDescendants()) do addRemote(d, "RS") end end)
pcall(function()
local cloned = AC.svc("ReplicatedStorage")
if cloned and cloned ~= RStorage then
for _, d in ipairs(cloned:GetDescendants()) do addRemote(d, "RS-clone") end
end
end)
if type(getnilinstances) == "function" then
pcall(function() for _, inst in ipairs(getnilinstances()) do addRemote(inst, "nil") end end)
end
if type(getgc) == "function" then
pcall(function()
local seen = 0
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
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
for _, inst in ipairs(getnilinstances()) do
if typeof(inst) == "Instance" and AC.isSuspicious(inst.Name) then
F.Out("[模块扫描] ⚠ 隐藏实例(nil parent): " .. tostring(inst.ClassName) .. " · " .. tostring(inst.Name))
end
end
end
if type(getgc) ~= "function" then return end
local seen = 0
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
seen = seen + 1
if seen > 8000 then break end
if seen % 500 == 0 then task.wait() end
if type(obj) == "function" and (not islclosure or islclosure(obj)) then
local oki, info = pcall(debug.getinfo, obj, "nS")
if oki and info then
local nm = info.name or ""
local src = info.source or ""
local hit = AC.isSuspicious(nm) or AC.isSuspicious(src)
if not hit then
local okc, consts = pcall(debug.getconstants, obj)
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
for i = 1, #arr do n = n + 1 note(arr[i], "游离实例", "getinstances") end
end
end
local roots = {
{ LP:FindFirstChild("PlayerScripts"), "PlayerScripts" },
{ LP:FindFirstChild("PlayerGui"), "PlayerGui" },
{ game:GetService("ReplicatedFirst"), "ReplicatedFirst" },
{ RStorage, "ReplicatedStorage" },
}
pcall(function() roots[#roots + 1] = { game:GetService("CoreGui"), "CoreGui" } end)
local CAP = 40000
for i = 1, #roots do
local r, nm = roots[i][1], roots[i][2]
if r and n < CAP then
local ok, kids = pcall(function() return r:GetDescendants() end)
if ok and kids then
local cnt = 0
for j = 1, #kids do
cnt = cnt + 1
if cnt % 300 == 0 then task.wait() end
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
local ok, kids = pcall(function() return r:GetDescendants() end)
if ok and kids then
for j = 1, #kids do
if j % 400 == 0 then task.wait() end
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
F.THRESH_HINTS = {
{ keys = { "speed", "velocity", "walkspeed", "stud" }, label = "速度阈值(studs/s)" },
{ keys = { "teleport", "tp", "distance", "delta", "move" }, label = "位移/瞬移阈值(studs)" },
{ keys = { "fly", "air", "jump", "hang", "float" },     label = "滞空/飞行阈值(s)" },
{ keys = { "rate", "per", "window", "interval", "tick" }, label = "采样窗口/频率(s)" },
{ keys = { "count", "strike", "hit", "times", "limit" },  label = "累计次数上限" },
{ keys = { "kick", "ban", "punish", "flag" },            label = "处置阈值" },
}
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
function F.ScanThresholds()
if type(getgc) ~= "function" or type(debug.getconstants) ~= "function" then
F.Out("[阈值] ⚠ 本执行器缺 getgc / debug.getconstants —— 无法提取阈值(不是没扫到)")
return
end
local keep = F._scavenging
F._scavenging = true
F.Out("[阈值] ===== 从可疑函数里提取数字阈值 =====")
local seen, found, scanned = 0, 0, 0
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
scanned = scanned + 1
if scanned > 12000 then break end
if scanned % 300 == 0 then task.wait() end
if type(obj) == "function" and (not islclosure or islclosure(obj)) then
local oki, info = pcall(debug.getinfo, obj, "nS")
local nm = (oki and info and info.name) or ""
local srcv = (oki and info and info.source) or ""
local low = (nm .. " " .. srcv):lower()
local relevant = false
for _, h in ipairs(F.THRESH_HINTS) do
for _, k in ipairs(h.keys) do
if low:find(k, 1, true) then relevant = true break end
end
if relevant then break end
end
if relevant and not seen[nm .. srcv] then
seen[nm .. srcv] = true
local fp = F.FnFingerprint(obj)
if #fp.nums > 0 or #fp.strs > 0 then
found = found + 1
if found <= 60 then
F.Out(string.format("[阈值] %s @ %s · 形状(upvalue %d / 常量 %d)",
(nm ~= "" and nm or "(匿名)"), srcv, fp.nups, fp.nconsts))
local nums = {}
for i = 1, #fp.nums do nums[i] = tostring(fp.nums[i]) end
if #nums > 0 then F.Out("[阈值]   数字: " .. table.concat(nums, ", ")) end
local joined = table.concat(fp.strs, " "):lower() .. " " .. low
for _, h in ipairs(F.THRESH_HINTS) do
local hit = false
for _, k in ipairs(h.keys) do
if joined:find(k, 1, true) then hit = true break end
end
if hit then
local picked = {}
for i = 1, #fp.nums do
if #picked < 6 then picked[#picked + 1] = tostring(fp.nums[i]) end
end
F.Out("[阈值]   → 疑似" .. h.label .. ": " .. table.concat(picked, ", "))
end
end
if #fp.strs > 0 then
F.Out("[阈值]   字符串常量: " .. table.concat(fp.strs, " | "):sub(1, 180))
end
end
end
end
end
end
F.Out(string.format("[阈值] 共分析 %d 个函数, 命中 %d 个带数字的可疑函数", scanned, found))
F.Out("[阈值] 用法: 把上面的数字当**上限参考**, 把「加速/飞行速度」压到它下面(如 100 ⇒ 90)")
F._scavenging = keep
return found
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
used = "filtergc"
for i = 1, #got do
if type(got[i]) == "function" then report(got[i]) end
end
end
end
if n == 0 and type(dbgGetGC) == "function" then
local seen, scanned = 0, 0
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
scanned = scanned + 1
if scanned > 12000 then break end
if scanned % 300 == 0 then task.wait() end
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
function F.AutoKeywords()
local cnt, order = {}, {}
local scanned = 0
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
scanned = scanned + 1
if scanned > 12000 then break end
if scanned % 300 == 0 then task.wait() end
if type(obj) == "function" and (not islclosure or islclosure(obj)) then
local okc, consts = pcall(dbgGetConstants, obj)
if okc and type(consts) == "table" then
local oki, info = pcall(dbgGetInfo, obj, "nS")
local nm = (oki and info and info.name) or ""
local sv = (oki and info and info.source) or ""
local low = (nm .. " " .. sv):lower()
local sus = false
for i = 1, #F.SCAN_KW do
if low:find(F.SCAN_KW[i], 1, true) then sus = true break end
end
if sus then
for i = 1, #consts do
local v = consts[i]
if type(v) == "string" and #v >= 4 and #v <= 60
and not v:find("\n", 1, true) and not v:find("\t", 1, true)
and v:find("%a") ~= nil and not v:find("rbxasset", 1, true)
and not v:find("://", 1, true) then
if not cnt[v] then order[#order + 1] = v end
cnt[v] = (cnt[v] or 0) + 1
end
end
end
end
end
end
table.sort(order, function(a, b) return (cnt[a] or 0) > (cnt[b] or 0) end)
local out = {}
for i = 1, #order do
if #out >= 10 then break end
out[#out + 1] = { s = order[i], n = cnt[order[i]] }
end
return out
end
function F.AutoProbe()
if type(dbgGetGC) ~= "function" or type(dbgGetConstants) ~= "function" then
F.Out("[自动分析] ⚠ 本执行器缺 getgc / debug.getconstants —— 无法自动分析(不是没扫到)")
return
end
local keep = F._scavenging
F._scavenging = true
F.Out("[自动分析] ══════ 全自动分析开始（你不用输入任何东西）══════")
local kws = F.AutoKeywords()
if #kws == 0 then
F.Out("[自动分析] 没找到可用的关键词 —— 可能本服反作弊在服务端(客户端看不到)，这是正常结论")
F._scavenging = keep
return
end
local names = {}
for i = 1, #kws do names[i] = kws[i].s end
F.Out("[自动分析] ① 自动挑出关键词 " .. tostring(#kws) .. " 条：")
for i = 1, #kws do
if i > 6 then break end
F.Out(string.format("[自动分析]     「%s」 ×%d", tostring(kws[i].s):sub(1, 40), kws[i].n))
end
local want = {}
for i = 1, #names do if i <= 8 then want[#want + 1] = names[i] end end
local hits = {}
local function consider(f)
if #hits >= 30 then return end
local fp = F.FnFingerprint(f)
if #fp.nums > 0 or #fp.strs > 0 then hits[#hits + 1] = { f = f, fp = fp } end
end
if type(filtergc) == "function" then
for i = 1, #want do
local ok, got = pcall(filtergc, "function", { Constants = { want[i] }, IgnoreExecutor = true }, true)
if ok and type(got) == "table" then
for j = 1, #got do
if type(got[j]) == "function" then consider(got[j]) end
end
end
if #hits >= 30 then break end
end
end
if #hits == 0 then
local scanned = 0
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
scanned = scanned + 1
if scanned > 12000 then break end
if scanned % 300 == 0 then task.wait() end
if type(obj) == "function" and (not islclosure or islclosure(obj)) then
local okc, consts = pcall(dbgGetConstants, obj)
if okc and type(consts) == "table" then
local blob = {}
for k = 1, #consts do
if type(consts[k]) == "string" then blob[#blob + 1] = consts[k] end
end
local s = table.concat(blob, "\n")
for i = 1, #want do
if s:find(want[i], 1, true) then consider(obj) break end
end
end
end
end
end
F.Out("[自动分析] ② 命中函数 " .. tostring(#hits) .. " 个")
local tagged = {}
for i = 1, #hits do
local fp = hits[i].fp
local joined = table.concat(fp.strs, " "):lower()
local oki, info = pcall(dbgGetInfo, hits[i].f, "nS")
local nm = (oki and info and info.name) or "(匿名)"
local sv = (oki and info and info.source) or "?"
joined = joined .. " " .. nm:lower() .. " " .. sv:lower()
if i <= 12 then
local nums = {}
for k = 1, #fp.nums do if k <= 10 then nums[#nums + 1] = tostring(fp.nums[k]) end end
F.Out(string.format("[自动分析]     %s @ %s", nm, sv))
if #nums > 0 then F.Out("[自动分析]       数字: " .. table.concat(nums, ", ")) end
end
for j = 1, #F.THRESH_HINTS do
local h = F.THRESH_HINTS[j]
local hit = false
for k = 1, #h.keys do
if joined:find(h.keys[k], 1, true) then hit = true break end
end
if hit then
for k = 1, #fp.nums do
local v = fp.nums[k]
if type(v) == "number" and v > 1 and v < 1e6 then
tagged[#tagged + 1] = { label = h.label, v = v, src = sv }
end
end
end
end
end
local best = nil
for i = 1, #tagged do
if tagged[i].label:find("速度", 1, true) then
if best == nil or tagged[i].v < best then best = tagged[i].v end
end
end
F._autoTh = tagged
F._autoSpeedCap = best
F.Out("[自动分析] ③ 共提取到 " .. tostring(#tagged) .. " 个疑似阈值数字")
if best then
local safe = math.floor(best * 0.9)
F.Out(string.format("[自动分析] ④ ★ 结论：疑似速度上限 = %d studs/s ⇒ 建议把速度压到 %d 以内",
best, safe))
F.Out("[自动分析]    想按建议改，点「按结果把速度压到安全值」即可（这一步要你自己点）")
else
F.Out("[自动分析] ④ 没提取到明确的「速度阈值」—— 可能判定在服务端，或函数被混淆得更彻底")
end
F.Out("[自动分析] ══════ 分析结束 ══════")
F._scavenging = keep
return #tagged
end
function F.ApplySafeCaps()
local best = F._autoSpeedCap
if type(best) ~= "number" then
F.Out("[安全值] 还没跑过「一键自动分析」—— 先点那个按钮")
return
end
local safe = math.max(16, math.floor(best * 0.9))
local changed = {}
if type(C.SpeedValue) == "number" and C.SpeedValue > safe then
C.SpeedValue = safe
changed[#changed + 1] = "加速 " .. tostring(safe)
pcall(function()
local o = Fluent and Fluent.Options and Fluent.Options.SpeedValue
if o and o.Set then o:Set(safe) end
end)
end
if type(C.FlyValue) == "number" and C.FlyValue > safe then
C.FlyValue = safe
changed[#changed + 1] = "飞行 " .. tostring(safe)
pcall(function()
local o = Fluent and Fluent.Options and Fluent.Options.FlyValue
if o and o.Set then o:Set(safe) end
end)
end
if #changed == 0 then
F.Out(string.format("[安全值] 你的速度已经在安全线(%d)以内，无需改动", safe))
else
F.Out(string.format("[安全值] 已把 %s 压到 %d（= 疑似阈值 %d × 0.9）",
table.concat(changed, " / "), safe, best))
F.Out("[安全值] 这是**你点的**修改；想恢复自己拖滑块即可")
end
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
for _, obj in ipairs(F.GuardedGetGC(true, true)) do
scanned = scanned + 1
if scanned > 12000 then break end
if scanned % 300 == 0 then task.wait() end
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
function F.TraceHolders(target)
if target == nil then F.Out("[反查] 用法: 需要一个 remote/表对象"); return end
if type(getgc) ~= "function" then F.Out("[反查] ⚠ 缺 getgc"); return end
local keep = F._scavenging
F._scavenging = true
F.Out("[反查] ===== 谁在 upvalue 里持有它 =====")
local n, scanned = 0, 0
for _, f in ipairs(F.GuardedGetGC(true, true)) do
scanned = scanned + 1
if scanned > 12000 then break end
if scanned % 300 == 0 then task.wait() end
if type(f) == "function" and (not islclosure or islclosure(f)) then
for i = 1, 24 do
local ok, un, v = pcall(debug.getupvalue, f, i)
if not ok or un == nil then break end
if v == target then
n = n + 1
if n <= 30 then
local oki, info = pcall(debug.getinfo, f, "nS")
F.Out(string.format("[反查]   upvalue #%d 名=%s · 函数 %s @ %s", i, tostring(un),
(oki and info and info.name ~= "" and info.name) or "(匿名)",
(oki and info and info.source) or "?"))
end
break
end
end
end
end
F.Out(string.format("[反查] 共 %d 个闭包持有它（已扫 %d 个函数）", n, scanned))
F._scavenging = keep
return n
end
function F.ScanFamilies()
if type(getgc) ~= "function" then F.Out("[家族] ⚠ 缺 getgc"); return end
local keep = F._scavenging
F._scavenging = true
local fam = {}
local scanned = 0
for _, f in ipairs(F.GuardedGetGC(true, true)) do
scanned = scanned + 1
if scanned > 12000 then break end
if scanned % 300 == 0 then task.wait() end
if type(f) == "function" and (not islclosure or islclosure(f)) then
local oki, info = pcall(debug.getinfo, f, "nS")
if oki and info then
local nm = info.name or ""
local sv = info.source or "?"
local low = (nm .. " " .. sv):lower()
local sus = false
for i = 1, #F.SCAN_KW do
if low:find(F.SCAN_KW[i], 1, true) then sus = true break end
end
if sus then
local prefix = nm:match("^([%a_]+)") or "(匿名)"
local key = sv .. "|" .. prefix
fam[key] = fam[key] or { n = 0, src = sv, prefix = prefix }
fam[key].n = fam[key].n + 1
end
end
end
end
F.Out("[家族] ===== 可疑函数家族（同一 source + 同名前缀）=====")
local list = {}
for _, v in pairs(fam) do list[#list + 1] = v end
table.sort(list, function(a, b) return a.n > b.n end)
for i = 1, #list do
if i > 30 then break end
F.Out(string.format("[家族]   %-28s ×%-4d @ %s", tostring(list[i].prefix), list[i].n, tostring(list[i].src)))
end
F.Out(string.format("[家族] 共 %d 个家族（已扫 %d 个函数）—— 一次中和整个家族, 命中率比单个高",
#list, scanned))
F._scavenging = keep
return #list
end
function AC.ScanAndBlock()
local keepScav = F._scavenging
F._scavenging = true
local n = 0
pcall(function()
if type(getnilinstances) == "function" then
for _, inst in ipairs(getnilinstances()) do
if typeof(inst) == "Instance" then
if AC.isRemoteLike(inst) then
AC.hookOneRemote(inst)
n = n + 1
end
end
end
end
end)
pcall(F.UnifiedACPass)
F._scavenging = keepScav
F.Out("[CheatMenu] 扫描并拦截: 隐藏远程 " .. n .. " 个, 已拦截 remote 共 " .. AC.BlockedCount .. " 个")
return AC.BlockedCount
end
F._afkConn = nil
F._afkConn2 = nil
function F.AntiAFKEnable()
if F._afkConn then return end
F._afkConn = LP.Idled:Connect(function()
if not T.AntiAFK then return end
if VirtualUser then
pcall(function() VirtualUser:CaptureController() end)
pcall(function() VirtualUser:ClickButton2(Vector2.new(0, 0)) end)
end
end)
F._afkConn2 = RS.Heartbeat:Connect(function()
if not T.AntiAFK then F.AntiAFKDisable() return end
if (os.clock() - (F._afkAt or 0)) < 5 then return end
F._afkAt = os.clock()
pcall(function() LP:SetAttribute("Heartbeat", math.floor(os.clock() * 1000)) end)
local _, hum, root = GC()
if hum and root and root.AssemblyLinearVelocity.Magnitude < 1 then hum.Jump = true end
end)
end
function F.AntiAFKDisable()
if F._afkConn then F._afkConn:Disconnect() F._afkConn = nil end
if F._afkConn2 then F._afkConn2:Disconnect() F._afkConn2 = nil end
end
F._flingConns = {}
function F.AntiFlingEnable()
if T.AntiFling and #F._flingConns > 0 then return end
T.AntiFling = true
F._flingBackup = F._flingBackup or {}
local function disable(part)
if part:IsA("BasePart") then
if F._flingBackup[part] == nil then
F._flingBackup[part] = {
CanCollide = part.CanCollide, CanTouch = part.CanTouch, CanQuery = part.CanQuery,
}
end
part.CanCollide = false
part.CanTouch = false
part.CanQuery = false
end
end
local function hookChar(char)
if not char then return end
for _, p in ipairs(char:GetDescendants()) do disable(p) end
table.insert(F._flingConns, char.DescendantAdded:Connect(disable))
end
hookChar(LP.Character)
table.insert(F._flingConns, LP.CharacterAdded:Connect(hookChar))
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
local KG = { hooked = false, target = nil, rjConn = nil }
function F.KickGuardEnable()
if KG.hooked then return true end
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
function F.GetDistanceColor(dist)
if dist <= 50 then return Color3.fromRGB(255, 105, 180) end
if dist <= 750 then return Color3.fromRGB(255, 60, 60) end
if dist <= 1875 then return Color3.fromRGB(255, 255, 60) end
return Color3.fromRGB(60, 255, 60)
end
function F.PlayerNames()
local n = {}
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP then n[#n + 1] = pl.Name end
end
table.sort(n)
if #n == 0 then n[1] = "(无人)" end
return n
end
F.PLAYER_DROPDOWNS = { "TPTarget", "PriorityTarget", "BlacklistTarget" }
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
F._aimCache, F._aimCacheAt = nil, 0
local function predictPos(part)
if not T.AimPrediction then return part.Position end
local vel = part.AssemblyLinearVelocity
local dist = (workspace.CurrentCamera.CFrame.Position - part.Position).Magnitude
local travel = dist / math.max(1, C.AimBulletSpeed or 500)
return part.Position + vel * travel
end
function F.SafeRaycast(origin, direction, params)
if not (origin and direction) then return nil end
local ok, result = pcall(function() return workspace:Raycast(origin, direction, params) end)
if ok then return result end
local ok2, result2 = pcall(function()
local p = RaycastParams.new()
p.FilterType = Enum.RaycastFilterType.Exclude
p.FilterDescendantsInstances = F.filterList(LP.Character)
return workspace:Raycast(origin, direction, p)
end)
return ok2 and result2 or nil
end
F.AimConn = nil
F.SilentAimConn = nil
local SilentAimGhostHook = nil
F._saMouseOn = false
F._saMouseOld = nil
F.SilentAimChance = 100
F.SilentAimTeamCheck = true
F.SilentAimWallCheck = true
F.SilentAimHitPart = "HumanoidRootPart"
F._saUnifiedHooked = false
F._saUnifiedOld = nil
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
function F.AutoFire(tgt)
if not (T.AutoFire and tgt) then return end
local now = os.clock()
if now - (F._fireAt or 0) < (tonumber(C.AutoFireGap) or 0.1) then return end
F._fireAt = now
local done = false
if type(mouse1click) == "function" then
pcall(function() mouse1click() done = true end)
end
if not done then
pcall(function()
local vu = game:GetService("VirtualUser")
local cam = workspace.CurrentCamera
local vp = cam and cam.ViewportSize or Vector2.new(400, 400)
vu:CaptureController()
vu:ClickButton1(Vector2.new(vp.X / 2, vp.Y / 2))
done = true
end)
end
if not done then
pcall(function()
local ch = LP.Character
local tool = ch and ch:FindFirstChildOfClass("Tool")
if tool then tool:Activate() done = true end
end)
end
end
function F.AimSet(on)
T.AimOn = on and true or false
if F._aimConn then pcall(function() RS:UnbindFromRenderStep("CM_Aim") end) F._aimConn = nil end
if not T.AimOn then return end
F._aimConn = true
RS:BindToRenderStep("CM_Aim", Enum.RenderPriority.Camera.Value + 1, function()
if not T.AimOn then F.AimSet(false) return end
local firing = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
if not firing and UIS.TouchEnabled and F._touchDown then firing = true end
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
function F.AimUnbind()
pcall(function() RS:UnbindFromRenderStep("CM_Aim") end)
F._aimConn = nil
end
local SingleAimConn = nil
local FaceLockConn = nil
function F.FlingTarget()
local name = Fluent.Options.FlingTarget and Fluent.Options.FlingTarget.Value
local target = name and Players:FindFirstChild(name)
if not (target and target.Character) then return end
local hrp = target.Character:FindFirstChild("HumanoidRootPart")
local _, _, r = GC()
if not (hrp and r) then return end
for _ = 1, 12 do
r.CFrame = hrp.CFrame * CFrame.new(0, 0, -1)
r.AssemblyLinearVelocity = Vector3.new(0, 200, 0)
task.wait()
end
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
local InvConn, InvAddedConn, InvBackup, InvDisplayBackup
local function InvApply(ch, on)
if not ch then return end
InvBackup = InvBackup or {}
for _, d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") then
if on then InvBackup[d] = d.Transparency d.Transparency = 1 d.CastShadow = false
else d.Transparency = InvBackup[d] or ((d.Name == "HumanoidRootPart") and 1 or 0) d.CastShadow = true end
elseif d:IsA("Decal") or d:IsA("Texture") then
if on then InvBackup[d] = d.Transparency d.Transparency = 1 else d.Transparency = InvBackup[d] or 0 end
elseif d:IsA("Accessory") then
local h = d:FindFirstChild("Handle")
if h and h:IsA("BasePart") then
if on then InvBackup[h] = h.Transparency h.Transparency = 1 h.CastShadow = false
else h.Transparency = InvBackup[h] or 0 h.CastShadow = true end
end
elseif d:IsA("ParticleEmitter") or d:IsA("Trail") then d.Enabled = not on
elseif d:IsA("BillboardGui") or d:IsA("Highlight") then d.Enabled = not on end
end
end
local function InvisibleDisable()
if InvConn then InvConn:Disconnect() InvConn = nil end
if InvAddedConn then InvAddedConn:Disconnect() InvAddedConn = nil end
local ch, hum = GC()
InvApply(ch, false)
InvBackup = nil
if hum and InvDisplayBackup ~= nil then
pcall(function() hum.DisplayDistanceType = InvDisplayBackup end)
InvDisplayBackup = nil
end
end
local function InvisibleEnable()
if InvConn then return end
local ch, hum = GC()
if not ch then return end
if hum then
InvDisplayBackup = hum.DisplayDistanceType
pcall(function() hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
end
InvApply(ch, true)
InvAddedConn = ch.DescendantAdded:Connect(function(d)
pcall(function()
if d:IsA("BasePart") then d.Transparency = 1 d.CastShadow = false
elseif d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 1
elseif d:IsA("Accessory") then
local h = d:FindFirstChild("Handle")
if h and h:IsA("BasePart") then h.Transparency = 1 h.CastShadow = false end
elseif d:IsA("BillboardGui") or d:IsA("Highlight") then d.Enabled = false
elseif d:IsA("ParticleEmitter") or d:IsA("Trail") then d.Enabled = false end
end)
end)
InvConn = RS.RenderStepped:Connect(function()
if not T.Invisible then InvisibleDisable() return end
local c = LP.Character
if not c then return end
InvApply(c, true)
local h = c:FindFirstChildOfClass("Humanoid")
if h and h.DisplayDistanceType ~= Enum.HumanoidDisplayDistanceType.None then
pcall(function() h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
end
end)
end
local ESPGui, ESPObjs = nil, {}
local ESPConn = nil
local ESPHue = 0
local function espInit()
if ESPGui and ESPGui.Parent then return end
ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "PlayerTags"
ESPGui.ResetOnSpawn = false
ESPGui.IgnoreGuiInset = true
ESPGui.Parent = gethui and gethui() or CoreGui
end
local function espRemove(pl)
local o = ESPObjs[pl]
if o then for _, inst in pairs(o) do pcall(function() inst:Destroy() end) end ESPObjs[pl] = nil end
end
local function espCreate(pl)
if pl == LP or ESPObjs[pl] then return end
espInit()
local o = {}
local function edge(parent)
local e = Instance.new("Frame")
e.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
e.BorderSizePixel = 0
e.Parent = parent
return e
end
o.box = Instance.new("Frame")
o.box.BackgroundTransparency = 1
o.box.BorderSizePixel = 0
o.box.Parent = ESPGui
o.top = edge(o.box) o.bottom = edge(o.box) o.left = edge(o.box) o.right = edge(o.box)
local function corner()
local c = Instance.new("Frame")
c.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
c.BorderSizePixel = 0
c.Visible = false
c.Parent = ESPGui
return c
end
o.corner1, o.corner2 = corner(), corner()
o.corner3, o.corner4 = corner(), corner()
o.corner5, o.corner6 = corner(), corner()
o.corner7, o.corner8 = corner(), corner()
o.name = Instance.new("TextLabel")
o.name.BackgroundTransparency = 1
o.name.TextColor3 = Color3.fromRGB(255, 255, 255)
o.name.TextSize = 13
o.name.Font = Enum.Font.GothamBold
o.name.TextStrokeTransparency = 0.5
o.name.Parent = ESPGui
o.dist = Instance.new("TextLabel")
o.dist.BackgroundTransparency = 1
o.dist.TextColor3 = Color3.fromRGB(210, 210, 210)
o.dist.TextSize = 12
o.dist.Font = Enum.Font.Gotham
o.dist.TextStrokeTransparency = 0.5
o.dist.Parent = ESPGui
o.hp = Instance.new("Frame")
o.hp.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
o.hp.BorderSizePixel = 0
o.hp.Parent = ESPGui
o.tracer = Instance.new("Frame")
o.tracer.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
o.tracer.BorderSizePixel = 0
o.tracer.Parent = ESPGui
ESPObjs[pl] = o
end
local function espUpdate()
local _now = os.clock()
if _now - (F._espAt or 0) < 0.033 then return end
F._espAt = _now
if T.ESPRainbow then ESPHue = (ESPHue + 0.008) % 1 end
local cam = workspace.CurrentCamera
if not cam then return end
local vp = cam.ViewportSize
for pl, o in pairs(ESPObjs) do
local ch = pl.Character
local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hrp and hum and hum.Health > 0 then
local pos, onScreen = cam:WorldToScreenPoint(hrp.Position)
if onScreen then
local dist = (cam.CFrame.Position - hrp.Position).Magnitude
local col = T.ESPRainbow and Color3.fromHSV(ESPHue, 1, 1) or F.GetDistanceColor(dist)
if T.ESPTeamColor and pl.Team == LP.Team then col = Color3.fromRGB(90, 220, 120) end
local h = math.clamp(600 / math.max(1, dist), 20, 320)
local w = h * 0.6
local x, y = pos.X - w / 2, pos.Y - h / 2
local style = C.ESPBoxStyle or "边框"
local boxOn = T.ESPBox ~= false
o.box.Visible = boxOn and (style ~= "角框")
o.box.Position = UDim2.fromOffset(x, y)
o.box.Size = UDim2.fromOffset(w, h)
o.top.Position = UDim2.fromOffset(0, 0) o.top.Size = UDim2.new(1, 0, 0, 1) o.top.BackgroundColor3 = col
o.bottom.Position = UDim2.new(0, 0, 1, -1) o.bottom.Size = UDim2.new(1, 0, 0, 1) o.bottom.BackgroundColor3 = col
o.left.Position = UDim2.fromOffset(0, 0) o.left.Size = UDim2.new(0, 1, 1, 0) o.left.BackgroundColor3 = col
o.right.Position = UDim2.new(1, -1, 0, 0) o.right.Size = UDim2.new(0, 1, 1, 0) o.right.BackgroundColor3 = col
local cl, ct = 12, 2
if boxOn and style ~= "边框" then
local cx = { x, x, x + w - cl, x + w - ct, x, x, x + w - cl, x + w - ct }
local cy = { y, y, y, y, y + h - ct, y + h - cl, y + h - ct, y + h - cl }
local cw = { cl, ct, cl, ct, cl, ct, cl, ct }
local chh = { ct, cl, ct, cl, ct, cl, ct, cl }
for i = 1, 8 do
local c = o["corner" .. i]
c.Visible = true
c.Position = UDim2.fromOffset(cx[i], cy[i])
c.Size = UDim2.fromOffset(cw[i], chh[i])
c.BackgroundColor3 = col
end
else
for i = 1, 8 do o["corner" .. i].Visible = false end
end
o.name.Visible = T.ESPName ~= false
o.name.Position = UDim2.fromOffset(x, y - 16)
o.name.Size = UDim2.fromOffset(w, 16)
o.name.Text = pl.Name
o.name.TextColor3 = col
o.dist.Visible = T.ESPDist ~= false
o.dist.Position = UDim2.fromOffset(x, y + h)
o.dist.Size = UDim2.fromOffset(w, 14)
o.dist.Text = ("[%.0f]"):format(dist)
o.hp.Visible = T.ESPHealth ~= false
local hpRatio = math.clamp(hum.Health / math.max(1, hum.MaxHealth), 0, 1)
o.hp.Position = UDim2.fromOffset(x - 6, y)
o.hp.Size = UDim2.new(0, 3, hpRatio, 0)
o.hp.BackgroundColor3 = Color3.fromHSV(hpRatio * 0.33, 1, 1)
o.tracer.Visible = T.ESPTracer ~= false
local dx, dy = pos.X - vp.X / 2, pos.Y - vp.Y
local len = math.sqrt(dx * dx + dy * dy)
o.tracer.Position = UDim2.fromOffset(vp.X / 2, vp.Y)
o.tracer.Size = UDim2.fromOffset(len, 1)
o.tracer.Rotation = math.deg(math.atan2(dy, dx))
o.tracer.BackgroundColor3 = col
else
o.box.Visible = false o.name.Visible = false o.dist.Visible = false o.hp.Visible = false o.tracer.Visible = false
for i = 1, 8 do o["corner" .. i].Visible = false end
end
else
o.box.Visible = false o.name.Visible = false o.dist.Visible = false o.hp.Visible = false o.tracer.Visible = false
for i = 1, 8 do o["corner" .. i].Visible = false end
end
end
end
local ESPAddedConn, ESPRemovedConn = nil, nil
local function ESPEnable()
espInit()
for _, pl in ipairs(Players:GetPlayers()) do espCreate(pl) end
if ESPAddedConn then ESPAddedConn:Disconnect() end
if ESPRemovedConn then ESPRemovedConn:Disconnect() end
F._espPlConns = F._espPlConns or {}
ESPAddedConn = Players.PlayerAdded:Connect(function(pl)
if F._espPlConns[pl] then return end
F._espPlConns[pl] = pl.CharacterAdded:Connect(function() task.wait(0.3) espCreate(pl) end)
end)
for _, pl in ipairs(Players:GetPlayers()) do
if not F._espPlConns[pl] then
F._espPlConns[pl] = pl.CharacterAdded:Connect(function() task.wait(0.3) espCreate(pl) end)
end
end
ESPRemovedConn = Players.PlayerRemoving:Connect(function(pl)
if F._espPlConns[pl] then pcall(function() F._espPlConns[pl]:Disconnect() end) F._espPlConns[pl] = nil end
espRemove(pl)
end)
if not ESPConn then ESPConn = RS.RenderStepped:Connect(espUpdate) end
end
local function ESPDisable()
if F._espPlConns then
for pl, c in pairs(F._espPlConns) do pcall(function() c:Disconnect() end) end
F._espPlConns = {}
end
if ESPConn then ESPConn:Disconnect() ESPConn = nil end
if ESPAddedConn then ESPAddedConn:Disconnect() ESPAddedConn = nil end
if ESPRemovedConn then ESPRemovedConn:Disconnect() ESPRemovedConn = nil end
for pl in pairs(ESPObjs) do espRemove(pl) end
ESPObjs = {}
end
F._skeletonLines = {}
F._skeletonDrawings = nil
F._skeletonConn = nil
local SKELETON = {
{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},
{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
}
function F.SkeletonEnable()
if #F._skeletonLines > 0 or F._skeletonDrawings then return end
local Dw = AC.cap("Drawing")
if type(Dw) == "table" and type(Dw.new) == "function" then
local okAll = pcall(function()
local list = {}
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then
for _, pair in ipairs(SKELETON) do
local line = Dw.new("Line")
line.Thickness = 1.5
line.Color = Color3.fromRGB(0, 255, 150)
line.Visible = false
list[#list + 1] = { drawing = line, pl = pl, a = pair[1], b = pair[2] }
end
end
end
F._skeletonDrawings = list
end)
if okAll and F._skeletonDrawings then
F._skeletonConn = RS.RenderStepped:Connect(function()
if not T.ESPSkeleton then F.SkeletonDisable() return end
local cam = workspace.CurrentCamera
if not cam then return end
local list = F._skeletonDrawings
for i = 1, #list do
local item = list[i]
local d = item.drawing
local ch = item.pl.Character
local a = ch and ch:FindFirstChild(item.a, true)
local b = ch and ch:FindFirstChild(item.b, true)
if a and b then
local pa, oa = cam:WorldToViewportPoint(a.Position)
local pb, ob = cam:WorldToViewportPoint(b.Position)
if oa and ob then
d.From = Vector2.new(pa.X, pa.Y)
d.To = Vector2.new(pb.X, pb.Y)
d.Visible = true
else
d.Visible = false
end
else
d.Visible = false
end
end
end)
if F._skelQConn then pcall(function() F._skelQConn:Disconnect() end) end
F._skelQConn = Players.PlayerAdded:Connect(function()
if not T.ESPSkeleton then return end
task.wait(0.8)
F.SkeletonDisable()
if T.ESPSkeleton then F.SkeletonEnable() end
end)
F.Out("[CheatMenu] 骨骼线: 使用 Drawing API (" .. #F._skeletonDrawings .. " 条)")
return
end
if F._skeletonDrawings then
for _, item in ipairs(F._skeletonDrawings) do pcall(function() item.drawing:Remove() end) end
F._skeletonDrawings = nil
end
end
local sg = Instance.new("ScreenGui")
sg.Name = "BoneLines"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = gethui and gethui() or CoreGui
F._skeletonGui = sg
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then
for _, pair in ipairs(SKELETON) do
local line = Instance.new("Frame")
line.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
line.BorderSizePixel = 0
line.AnchorPoint = Vector2.new(0.5, 0.5)
line.Parent = sg
F._skeletonLines[#F._skeletonLines + 1] = { line = line, pl = pl, a = pair[1], b = pair[2] }
end
end
end
F._skeletonConn = RS.RenderStepped:Connect(function()
if not T.ESPSkeleton then F.SkeletonDisable() return end
local cam = workspace.CurrentCamera
for _, item in ipairs(F._skeletonLines) do
local ch = item.pl.Character
local a = ch and ch:FindFirstChild(item.a, true)
local b = ch and ch:FindFirstChild(item.b, true)
if a and b then
local pa, oa = cam:WorldToViewportPoint(a.Position)
local pb, ob = cam:WorldToViewportPoint(b.Position)
if oa and ob then
item.line.Visible = true
local dx, dy = pb.X - pa.X, pb.Y - pa.Y
local len = math.sqrt(dx * dx + dy * dy)
item.line.Position = UDim2.fromOffset((pa.X + pb.X) / 2, (pa.Y + pb.Y) / 2)
item.line.Size = UDim2.fromOffset(len, 1.5)
item.line.Rotation = math.deg(math.atan2(dy, dx))
else
item.line.Visible = false
end
else
item.line.Visible = false
end
end
end)
end
function F.SkeletonDisable()
if F._skelQConn then pcall(function() F._skelQConn:Disconnect() end) F._skelQConn = nil end
if F._skeletonConn then F._skeletonConn:Disconnect() F._skeletonConn = nil end
if F._skeletonDrawings then
for _, item in ipairs(F._skeletonDrawings) do pcall(function() item.drawing:Remove() end) end
F._skeletonDrawings = nil
end
for _, item in ipairs(F._skeletonLines) do pcall(function() item.line:Destroy() end) end
F._skeletonLines = {}
if F._skeletonGui then F._skeletonGui:Destroy() F._skeletonGui = nil end
end
F._arrowBbs = {}
F._arrowConn = nil
function F.ArrowEnable()
if #F._arrowBbs > 0 then return end
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then
local bb = Instance.new("BillboardGui")
bb.Name = "FacingMark"
bb.Size = UDim2.fromOffset(40, 40)
bb.StudsOffset = Vector3.new(0, 3.5, 0)
bb.AlwaysOnTop = true
bb.Parent = pl.Character
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.fromScale(1, 1)
lbl.BackgroundTransparency = 1
lbl.Text = "◆"
lbl.TextSize = 36
lbl.TextColor3 = Color3.fromRGB(255, 255, 80)
lbl.TextStrokeTransparency = 0.5
lbl.Parent = bb
F._arrowBbs[#F._arrowBbs + 1] = { bb = bb, lbl = lbl, pl = pl }
end
end
if F._arrowQConn then pcall(function() F._arrowQConn:Disconnect() end) end
F._arrowQConn = Players.PlayerAdded:Connect(function(pl)
if not T.ESPArrow then return end
task.wait(0.8)
if not T.ESPArrow then return end
local existing = false
for _, e in ipairs(F._arrowBbs) do if e.pl == pl then existing = true break end end
if existing or pl == LP or not pl.Character then return end
local bb = Instance.new("BillboardGui")
bb.Name = "FacingMark"
bb.Size = UDim2.fromOffset(40, 40)
bb.StudsOffset = Vector3.new(0, 3.5, 0)
bb.AlwaysOnTop = true
bb.Parent = pl.Character
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.fromScale(1, 1)
lbl.BackgroundTransparency = 1
lbl.Text = "◆"
lbl.TextSize = 36
lbl.TextColor3 = Color3.fromRGB(255, 255, 80)
lbl.TextStrokeTransparency = 0.5
lbl.Parent = bb
F._arrowBbs[#F._arrowBbs + 1] = { bb = bb, lbl = lbl, pl = pl }
end)
F._arrowConn = RS.RenderStepped:Connect(function()
if not T.ESPArrow then F.ArrowDisable() return end
local cam = workspace.CurrentCamera
if not cam then return end
local camPos = cam.CFrame.Position
for _, entry in ipairs(F._arrowBbs) do
local ch = entry.pl.Character
local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
if hrp and (hrp.Position - camPos).Magnitude > 1 then
local look = hrp.CFrame.LookVector
local toCam = (camPos - hrp.Position).Unit
local dot = look:Dot(toCam)
if dot < -0.5 then
entry.lbl.Text = "▲"
entry.lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
elseif dot > 0.5 then
entry.lbl.Text = "▼"
entry.lbl.TextColor3 = Color3.fromRGB(80, 255, 80)
else
entry.lbl.Text = "◆"
entry.lbl.TextColor3 = Color3.fromRGB(255, 255, 80)
end
end
end
end)
end
function F.ArrowDisable()
if F._arrowQConn then pcall(function() F._arrowQConn:Disconnect() end) F._arrowQConn = nil end
if F._arrowConn then F._arrowConn:Disconnect() F._arrowConn = nil end
for _, entry in ipairs(F._arrowBbs) do
local bb = entry.bb or entry
pcall(function() bb:Destroy() end)
end
F._arrowBbs = {}
end
F._trapHls = {}
function F.TrapsESPEnable()
if #F._trapHls > 0 then return end
for _, v in ipairs(workspace:GetDescendants()) do
local isPart = v:IsA("BasePart")
local n = isPart and v.Name:lower() or ""
if isPart and (n:find("trap") or n:find("mine") or n:find("spike") or n:find("sentry")) then
local hl = Instance.new("Highlight")
hl.FillColor = Color3.fromRGB(255, 60, 60)
hl.FillTransparency = 0.3
hl.OutlineColor = Color3.fromRGB(255, 0, 0)
hl.Parent = v
F._trapHls[#F._trapHls + 1] = hl
end
end
local function markOne(v)
pcall(function()
if not T.TrapsESP or not v:IsA("BasePart") then return end
local n2 = v.Name:lower()
if not (n2:find("trap") or n2:find("mine") or n2:find("spike") or n2:find("sentry")) then return end
for _, e in ipairs(F._trapHls) do if e.Parent == v then return end end
local hl = Instance.new("Highlight")
hl.FillColor = Color3.fromRGB(255, 60, 60)
hl.FillTransparency = 0.3
hl.OutlineColor = Color3.fromRGB(255, 0, 0)
hl.Parent = v
F._trapHls[#F._trapHls + 1] = hl
end)
end
F._trapConn = workspace.DescendantAdded:Connect(markOne)
end
function F.TrapsESPDisable()
if F._trapConn then pcall(function() F._trapConn:Disconnect() end) F._trapConn = nil end
for _, hl in ipairs(F._trapHls) do pcall(function() hl:Destroy() end) end
F._trapHls = {}
end
F._chamsLoop = nil
F._chamsBackup = nil
F._chamsAddedConn = nil
function F.ChamsEnable()
if F._chamsLoop then return end
F._chamsBackup = F._chamsBackup or {}
local function apply(pl)
local ch = pl.Character
if not ch then return end
for _, d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") then
if not F._chamsBackup[d] then F._chamsBackup[d] = { Material = d.Material, Color = d.Color } end
pcall(function()
d.Material = Enum.Material.Neon
d.Color = (pl == LP) and Color3.fromRGB(0, 255, 80) or Color3.fromRGB(255, 40, 40)
end)
end
end
end
local function applyAll() for _, pl in ipairs(Players:GetPlayers()) do apply(pl) end end
applyAll()
if F._chamsAddedConn then F._chamsAddedConn:Disconnect() end
F._chamsPlConns = F._chamsPlConns or {}
F._chamsAddedConn = Players.PlayerAdded:Connect(function(pl)
if F._chamsPlConns[pl] then return end
F._chamsPlConns[pl] = pl.CharacterAdded:Connect(function() task.wait(0.3) apply(pl) end)
end)
for _, pl in ipairs(Players:GetPlayers()) do
if not F._chamsPlConns[pl] then
F._chamsPlConns[pl] = pl.CharacterAdded:Connect(function() task.wait(0.3) apply(pl) end)
end
end
F._chamsLoop = task.spawn(function()
while T.Chams do task.wait(1) applyAll() end
F._chamsLoop = nil
end)
end
function F.ChamsDisable()
if F._chamsAddedConn then F._chamsAddedConn:Disconnect() F._chamsAddedConn = nil end
if F._chamsPlConns then
for pl, c in pairs(F._chamsPlConns) do pcall(function() c:Disconnect() end) end
F._chamsPlConns = {}
end
if F._chamsBackup then
for part, bak in pairs(F._chamsBackup) do
pcall(function() part.Material = bak.Material part.Color = bak.Color end)
end
end
F._chamsBackup = nil
end
local BulletHls = {}
local BulletConn = nil
local function BulletTracerDisable()
if BulletConn then BulletConn:Disconnect() BulletConn = nil end
for _, hl in ipairs(BulletHls) do pcall(function() hl:Destroy() end) end
BulletHls = {}
end
local function BulletTracerEnable()
if BulletConn then return end
local function tag(part)
if not (part:IsA("BasePart") and T.BulletTracer) then return end
local n = part.Name:lower()
if n:match("bullet") or n:match("projectile") or n:match("shot") or n:match("rocket") or n:match("bolt") then
local hl = Instance.new("Highlight")
hl.FillColor = Color3.fromRGB(255, 255, 0)
hl.FillTransparency = 0.5
hl.OutlineColor = Color3.fromRGB(255, 120, 0)
hl.Parent = part
BulletHls[#BulletHls + 1] = hl
end
end
BulletConn = workspace.DescendantAdded:Connect(tag)
for _, part in ipairs(workspace:GetDescendants()) do tag(part) end
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
if T.AimPriorityNearest then
pick = targets[1]
else
F._killAuraIdx = ((F._killAuraIdx or 0) % #targets) + 1
pick = targets[F._killAuraIdx]
end
if not pick then return end
local cam = workspace.CurrentCamera
if cam then cam.CFrame = CFrame.lookAt(cam.CFrame.Position, pick.hrp.Position) end
if type(mouse1click) == "function" then
pcall(mouse1click)
elseif cam then
pcall(function()
local vim = game:GetService("VirtualInputManager")
local vp = cam.ViewportSize
vim:SendMouseButtonEvent(vp.X / 2, vp.Y / 2, 0, true, game, 1)
vim:SendMouseButtonEvent(vp.X / 2, vp.Y / 2, 0, false, game, 1)
end)
end
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
if root.AssemblyLinearVelocity.Magnitude > 200 then
root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
end
end)
end
function F.AntiKnockdownDisable()
if F._antiKnockConn then F._antiKnockConn:Disconnect() F._antiKnockConn = nil end
end
F._antiAimConn = nil
F.HitboxBackup = {}
F.HB_PARTS = { "HumanoidRootPart", "Head", "UpperTorso", "LowerTorso", "Torso" }
function F.HitboxExpandEnable()
if F._hbProg then return end
F._hbProg = task.spawn(function()
for step = 1, 4 do
if not T.HitboxExpand then break end
local k = step / 4
local target = tonumber(C.HitboxSize) or 10
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then
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
end
task.wait(0.15)
end
F._hbProg = nil
end)
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
F._hbProg = nil
if F._hbAddedConn then pcall(function() F._hbAddedConn:Disconnect() end) F._hbAddedConn = nil end
for pl, c in pairs(F._hbPlConns or {}) do pcall(function() c:Disconnect() end) end
F._hbPlConns = {}
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
for _, p in ipairs(parts) do pcall(function() p:SetNetworkOwner(LP) end) end
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
function F.SrvHoldEnable()
if F._srv.holdConn then return end
F._srv.holdConn = RS.Heartbeat:Connect(function()
if not T.SrvHoldOwn then F.SrvHoldDisable() return end
local now = os.clock()
if now - (F._srv.ownAt or 0) < 0.4 then return end
F._srv.ownAt = now
local _, _, root = GC()
if root then pcall(function() root:SetNetworkOwner(LP) end) end
end)
end
function F.SrvHoldDisable()
if F._srv.holdConn then F._srv.holdConn:Disconnect() F._srv.holdConn = nil end
end
function F.SrvSnapWatch(sec, onDone)
sec = tonumber(sec) or 5
F._srv.snap, F._srv.snapMax, F._srv.bad = 0, 0, 0
F._srv.lastPos = nil
local t0 = os.clock()
local conn
conn = RS.Heartbeat:Connect(function()
local _, _, root = GC()
if not root then return end
local now = os.clock()
local p = root.Position
local want = tonumber(F._srv.expectMove) or 0
if F._srv.lastPos then
local d = p - F._srv.lastPos
local moved = d.Magnitude
F._srv.snapMax = math.max(F._srv.snapMax, moved)
if want > 0.2 and moved > want * 2.5 then
F._srv.snap = F._srv.snap + 1
elseif want > 0.2 and F._srv.dir and d:Dot(F._srv.dir) < -0.5 and moved > 1.5 then
F._srv.snap = F._srv.snap + 1
end
end
F._srv.lastPos = p
if now - t0 >= sec then
conn:Disconnect()
local per = F._srv.snap / sec
F.Out(string.format("[Srv] 拉回探测 %.0fs: 反向/超量位移 %d 次 (单次最大 %.1f studs), 约 %.1f 次/秒",
sec, F._srv.snap, F._srv.snapMax, per))
if onDone then pcall(onDone, F._srv.snap, per) end
end
end)
end
function F.SrvProbe(step, sec)
local _, _, root = GC()
if not root then return nil end
step = tonumber(step) or 1.5
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
L[#L + 1] = "② 已夺取所有权: 回读=本地 ✓ (仍被拉回就打开「持续保持所有权」)"
else
L[#L + 1] = "② ⛔ 抢不回所有权 ⇒ **该游戏位移类功能不可行**(服务端持有, 不是参数问题)"
end
else
L[#L + 1] = "② 所有权本来就在本地 ✓"
end
local step = tonumber(C.SpeedCFrameStep) or 4
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
function F.SrvReport()
task.spawn(function()
local o = F.SrvOwnInfo()
local step = tonumber(C.SpeedCFrameStep) or 4
F.Out("──────── 位移权威诊断 ────────")
F.Out("① AuthorityMode   : " .. tostring(F._authorityMode or "(无此字段)"))
F.Out("② 物理帧率         : " .. string.format("%.0f", F.SrvFPS()))
F.Out("③ 网络所有权(HRP)  : " .. tostring(o.ownerName))
F.Out("④ 角色 Anchored    : " .. tostring(o.anchored) .. "   状态: " .. tostring(o.humState))
F.Out("⑤ 限速             : **无** —— 本脚本已删除全部限速/限效果逻辑")
F.Out("⑥ 当前参数         : 目标速度 " .. tostring(C.SpeedTarget or 60) ..
" studs/s · 单帧位移 " .. string.format("%.2f", step))
F.Out("⑦ 结论             : " .. (o.serverOwned
and "服务端持有所有权 ⇒ 客户端位移会被覆盖, 属**机制性不可行**; 先点「夺取网络所有权」再谈参数"
or "所有权在本地 ⇒ 位移可行; 仍被拉回说明服务端在校验速度/瞬移(要不要降速由你决定)"))
local pr = F.SrvProbe(tonumber(C.SpeedCFrameStep) or 4, 2)
F.Out("⑧ 位移探针(2s)     : " .. (pr and string.format("意图 %.0f studs / 实走 %.0f ⇒ 通过率 %.0f%%",
pr.intended, pr.actual, pr.ratio * 100) or "无角色") .. "   (需 >=90% 才算没被拉回)")
F.Out("──────────────────────────────")
end)
end
F._baseWalk = 16
F._spdConn, F._flyConn = nil, nil
F._flyBv, F._flyBg, F._flyAp, F._flyAo, F._flyAtt = nil, nil, nil, nil, nil
function F.SpeedApply()
local _, hum = GC()
if not hum then return end
local v = T.SpeedOn and (tonumber(C.SpeedValue) or 60) or F._baseWalk
pcall(function() hum.WalkSpeed = v end)
end
function F.SpeedSet(on)
T.SpeedOn = on and true or false
if F._spdConn then F._spdConn:Disconnect() F._spdConn = nil end
if T.SpeedOn then
local _, hum = GC()
if hum then
local bw = tonumber(hum.WalkSpeed) or 16
if F._orig and F._orig.walk then F._baseWalk = F._orig.walk
elseif bw > 0 and bw <= 32 then F._baseWalk = bw end
end
F.SpeedApply()
F._spdConn = RS.RenderStepped:Connect(function()
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
if h.FloorMaterial == Enum.Material.Air then
local v = dir.Unit * sp
pcall(function() r.AssemblyLinearVelocity = Vector3.new(v.X, cur.Y, v.Z) end)
end
elseif math.abs(cur.X) > 0.5 or math.abs(cur.Z) > 0.5 then
pcall(function() r.AssemblyLinearVelocity = Vector3.new(0, cur.Y, 0) end)
end
local now = os.clock()
if now - (F._spdAt or 0) > 0.2 then
F._spdAt = now
if math.abs((h.WalkSpeed or 0) - sp) > 0.5 then pcall(function() h.WalkSpeed = sp end) end
end
end)
else
F.SpeedApply()
end
end
function F.FlyDestroy()
if F._flyConn then F._flyConn:Disconnect() F._flyConn = nil end
for _, k in ipairs({ "_flyBv", "_flyBg", "_flyAp", "_flyAo", "_flyAtt" }) do
if F[k] then pcall(function() F[k]:Destroy() end) F[k] = nil end
end
local _, hum = GC()
if hum then pcall(function() hum.PlatformStand = false end) end
end
function F.FlySet(on)
T.FlyOn = on and true or false
F.FlyDestroy()
if not T.FlyOn then return end
local _, hum, root = GC()
if not (hum and root) then return end
pcall(function() hum.PlatformStand = true end)
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
pcall(function()
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
bv.Velocity = Vector3.zero
bv.Parent = root
local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
bg.P = 1e4
bg.Parent = root
F._flyBv, F._flyBg = bv, bg
end)
end
F._flyConn = RS.RenderStepped:Connect(function()
if not T.FlyOn then F.FlyDestroy() return end
local _, h, r = GC()
if not (h and r) then return end
if not h.PlatformStand then pcall(function() h.PlatformStand = true end) end
local c = workspace.CurrentCamera
if not c then return end
local dir = Vector3.zero
if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + c.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - c.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - c.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + c.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
local vel = dir.Magnitude > 0 and (dir.Unit * (tonumber(C.FlyValue) or 60)) or Vector3.zero
if F._flyAp then
F._flyAp.Position = r.Position + vel * 0.05
F._flyAo.CFrame = c.CFrame
if vel.Magnitude < 0.01 then pcall(function() r.AssemblyLinearVelocity = Vector3.zero end) end
elseif F._flyBv then
F._flyBv.Velocity = vel
F._flyBg.CFrame = c.CFrame
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
F.SpinConn = nil
F.AirWalkConn = nil
F.NoClipConn = nil
F.NoClipParts = {}
function F.NoClipDisable()
pcall(function()
local ch = LP.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hum then hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true) end
end)
if F.NoClipConn then F.NoClipConn:Disconnect() F.NoClipConn = nil end
for part in pairs(F.NoClipParts) do
if typeof(part) == "Instance" and part:IsA("BasePart") and part.Parent then part.CanCollide = true end
end
F.NoClipParts = {}
end
function F.NoClipEnable()
if F.NoClipConn then return end
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
if r and F.HideBaseY then r.CFrame = CFrame.new(r.Position.X, F.HideBaseY + 2, r.Position.Z) end
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
local function smoothTP(targetCF, useSmooth)
local _, _, root = GC()
if not root or not targetCF then return end
if not (T.TPSmooth and useSmooth ~= false) then
pcall(function() root:PivotTo(targetCF) end)
breakVelocity()
return
end
local start = root.CFrame
local dist = (start.Position - targetCF.Position).Magnitude
local need = math.ceil(dist * 8 / 45)
local seg = math.max(3, tonumber(C.TPSmoothSeg) or 8, need)
seg = math.min(seg, 600)
local stepWait = 0.012
if dist > 2000 then stepWait = 0.008 end
for i = 1, seg do
local t = i / seg
local eased = (t < 0.5) and (2 * t * t) or (1 - ((-2 * t + 2) ^ 2) / 2)
root.CFrame = start:Lerp(targetCF, eased)
task.wait(stepWait)
end
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
F._clickTPConn = nil
function F.ClickTPEnable()
if F._clickTPConn then return end
F._clickTPConn = UIS.InputBegan:Connect(function(input, gpe)
if gpe or not T.ClickTP then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
local cam = workspace.CurrentCamera
local _, _, root = GC()
if not (cam and root) then return end
local ray = cam:ViewportPointToRay(input.Position.X, input.Position.Y)
local params = RaycastParams.new()
params.FilterDescendantsInstances = F.filterList(LP.Character)
params.FilterType = Enum.RaycastFilterType.Exclude
local hit = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
if hit then smoothTP(CFrame.new(hit.Position + Vector3.new(0, 3, 0))) end
end
end)
end
function F.ClickTPDisable()
if F._clickTPConn then F._clickTPConn:Disconnect() F._clickTPConn = nil end
end
F._voidConn = nil
F._safeCFs = {}
F.VOID_BUF = 10
function F.AntiVoidEnable()
if F._voidConn then return end
F._safeCFs = {}
F._voidConn = RS.Heartbeat:Connect(function()
if not T.AntiVoid then F.AntiVoidDisable() return end
local _, _, root = GC()
if not root then return end
local threshold = tonumber(C.VoidY) or -50
if root.Position.Y > threshold then
local buf = F._safeCFs
buf[#buf + 1] = root.CFrame
while #buf > F.VOID_BUF do table.remove(buf, 1) end
elseif #F._safeCFs > 0 then
local safe = F._safeCFs[#F._safeCFs]
pcall(function()
root.CFrame = safe
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
F._safeCFs = {}
end
end)
end
function F.AntiVoidDisable()
if F._voidConn then F._voidConn:Disconnect() F._voidConn = nil end
F._safeCFs = {}
end
F._dupeThread = nil
function F.DupeAttemptEnable()
if F._dupeThread then return end
F._dupeThread = task.spawn(function()
while T.DupeAttempt do
local ch, hum, root = GC()
if ch and hum and root then
local pos = root.CFrame
F.DropAllTools()
task.wait(0.25)
pcall(function() ch.Head:Destroy() end)
task.wait(6)
local _, _, r = GC()
if r then pcall(function() r.CFrame = pos end) end
end
task.wait(0.3)
end
F._dupeThread = nil
end)
end
function F.DupeAttemptDisable()
T.DupeAttempt = false
F._dupeThread = nil
end
F.ClickerConn = nil
function F.ClickerDisable() if F.ClickerConn then F.ClickerConn:Disconnect() F.ClickerConn = nil end end
function F.ClickerEnable()
if F.ClickerConn then return end
F.ClickerConn = RS.Stepped:Connect(function()
if not T.Clicker then F.ClickerDisable() return end
if type(mouse1click) == "function" then mouse1click()
elseif type(mouse1press) == "function" then mouse1press() task.wait(0.01) mouse1release() end
end)
end
local XrayHls = {}
local function XrayDisable()
for _, hl in ipairs(XrayHls) do pcall(function() hl:Destroy() end) end
XrayHls = {}
end
local function XrayEnable()
local ch = LP.Character
local made = 0
for _, obj in ipairs(workspace:GetDescendants()) do
if made >= 200 then break end
if made > 0 and made % 200 == 0 then task.wait() end
if obj:IsA("BasePart") and ch and not obj:IsDescendantOf(ch) then
made = made + 1
local hl = Instance.new("Highlight")
hl.FillTransparency = 1
hl.OutlineColor = Color3.fromRGB(255, 255, 255)
hl.OutlineTransparency = 0.4
hl.Parent = obj
XrayHls[#XrayHls + 1] = hl
end
end
end
local SelfGlowHl = nil
local function SelfGlowDisable() if SelfGlowHl then SelfGlowHl:Destroy() SelfGlowHl = nil end end
local function SelfGlowEnable()
local ch = LP.Character
if not ch then return end
if SelfGlowHl then SelfGlowHl:Destroy() end
SelfGlowHl = Instance.new("Highlight")
SelfGlowHl.FillColor = Color3.fromRGB(255, 200, 80)
SelfGlowHl.FillTransparency = 1
SelfGlowHl.OutlineColor = Color3.fromRGB(255, 255, 255)
SelfGlowHl.Parent = ch
end
local mutedVolumes = nil
local function MuteEnable()
mutedVolumes = {}
for _, s in ipairs(workspace:GetDescendants()) do
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
local function AntilagDisable()
local L = game:GetService("Lighting")
if not savedLag then return end
L.GlobalShadows = savedLag.GlobalShadows L.FogEnd = savedLag.FogEnd L.FogStart = savedLag.FogStart
L.Brightness = savedLag.Brightness L.ClockTime = savedLag.ClockTime L.Ambient = savedLag.Ambient
savedLag = nil
end
local function AntilagEnable()
local L = game:GetService("Lighting")
if not savedLag then
savedLag = { GlobalShadows = L.GlobalShadows, FogEnd = L.FogEnd, FogStart = L.FogStart, Brightness = L.Brightness, ClockTime = L.ClockTime, Ambient = L.Ambient }
end
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
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("BasePart") then pcall(function() v.CastShadow = false end) end
end
end
local function Rejoin()
pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end)
end
local ServerHop = Rejoin
local ToolGlowHl = nil
local function ToolGlowDisable() if ToolGlowHl then ToolGlowHl:Destroy() ToolGlowHl = nil end end
local function ToolGlowEnable()
local ch = LP.Character
if not ch then return end
local tool = ch:FindFirstChildOfClass("Tool")
if not tool then return end
if ToolGlowHl then ToolGlowHl:Destroy() end
ToolGlowHl = Instance.new("Highlight")
ToolGlowHl.FillColor = Color3.fromRGB(150, 200, 255)
ToolGlowHl.FillTransparency = 1
ToolGlowHl.OutlineColor = Color3.fromRGB(255, 255, 255)
ToolGlowHl.Parent = tool
end
local AutoInteractConn = nil
local InstantPromptConn = nil
local function AutoInteractDisable() if AutoInteractConn then AutoInteractConn:Disconnect() AutoInteractConn = nil end end
local function AutoInteractEnable()
if AutoInteractConn then return end
AutoInteractConn = RS.Stepped:Connect(function()
if not T.AutoInteract then AutoInteractDisable() return end
if os.clock() - (F._thr2335 or 0) < 1 then return end
F._thr2335 = os.clock()
local _, _, r = GC()
if not r then return end
local okp, parts = pcall(function() return workspace:GetPartBoundsInRadius(r.Position, 24) end)
if not (okp and type(parts) == "table") then return end
local seen = {}
for i = 1, #parts do
local part = parts[i]
if part then
local p = part:FindFirstChildWhichIsA("ProximityPrompt")
if (not p) and part.Parent then p = part.Parent:FindFirstChildWhichIsA("ProximityPrompt") end
if p and p.Enabled and not seen[p] then
seen[p] = true
if type(fireproximityprompt) == "function" then pcall(fireproximityprompt, p) end
end
local cd = part:FindFirstChildWhichIsA("ClickDetector")
if (not cd) and part.Parent then cd = part.Parent:FindFirstChildWhichIsA("ClickDetector") end
if cd and not seen[cd] then
seen[cd] = true
if type(fireclickdetector) == "function" then pcall(fireclickdetector, cd) end
end
end
end
end)
end
local HitboxList = {}
local function addHitbox(pl)
if pl == LP or not T.Hitbox then return end
local ch = pl.Character
if not ch then return end
local hrp = ch:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local box = Instance.new("Part")
box.Size = Vector3.new(6, 6, 6)
box.Transparency = 1
box.CanCollide = true
box.CanQuery = true
box.Anchored = true
box.Name = "HitZone"
box.Parent = ch
local conn = RS.RenderStepped:Connect(function()
if box.Parent and hrp.Parent then box.CFrame = hrp.CFrame end
end)
table.insert(HitboxList, { box = box, conn = conn })
end
local function HitboxEnable()
for _, pl in ipairs(Players:GetPlayers()) do addHitbox(pl) end
F._hbPlConns = F._hbPlConns or {}
if not F._hbAddedConn then
F._hbAddedConn = Players.PlayerAdded:Connect(function(pl)
if F._hbPlConns[pl] then return end
F._hbPlConns[pl] = pl.CharacterAdded:Connect(function() addHitbox(pl) end)
end)
end
for _, pl in ipairs(Players:GetPlayers()) do
if not F._hbPlConns[pl] then
F._hbPlConns[pl] = pl.CharacterAdded:Connect(function() addHitbox(pl) end)
end
end
end
local function HitboxDisable()
for _, e in ipairs(HitboxList) do
pcall(function() e.conn:Disconnect() end)
pcall(function() e.box:Destroy() end)
end
HitboxList = {}
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
local StealthGodConn = nil
local function StealthGodDisable() if StealthGodConn then StealthGodConn:Disconnect() StealthGodConn = nil end end
local function StealthGodEnable()
if StealthGodConn then return end
local _, hum0 = GC()
if hum0 then pcall(function() if hum0.MaxHealth > 1e6 then hum0.MaxHealth = 100 end end) end
StealthGodConn = RS.Heartbeat:Connect(function()
if not T.StealthGod then StealthGodDisable() return end
if os.clock() - (F._thr4439 or 0) < 0.05 then return end
F._thr4439 = os.clock()
local _, hum = GC()
if hum and hum.Health > 0 then hum.Health = hum.MaxHealth end
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
F._antiSitConn = nil
function F.AntiSitEnable()
if F._antiSitConn then return end
F._antiSitConn = RS.Heartbeat:Connect(function()
if not T.AntiSit then F.AntiSitDisable() return end
if os.clock() - (F._antiSitAt or 0) < 0.12 then return end
F._antiSitAt = os.clock()
local _, hum = GC()
if hum and hum.Sit then
pcall(function() hum.Sit = false hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
end
end)
end
function F.AntiSitDisable()
if F._antiSitConn then F._antiSitConn:Disconnect() F._antiSitConn = nil end
end
F._antiAnchorConn = nil
function F.AntiAnchorEnable()
if F._antiAnchorConn then return end
F._antiAnchorConn = RS.Heartbeat:Connect(function()
if not T.AntiAnchor then F.AntiAnchorDisable() return end
if os.clock() - (F._antiAnchorAt or 0) < 0.15 then return end
F._antiAnchorAt = os.clock()
local _, _, root = GC()
if root and root.Anchored then pcall(function() root.Anchored = false end) end
end)
end
function F.AntiAnchorDisable()
if F._antiAnchorConn then F._antiAnchorConn:Disconnect() F._antiAnchorConn = nil end
end
function F.OnCharacter()
if T.CharPersist == false then return end
task.wait(0.2)
F.RecordOriginals()
if T.FlyOn then pcall(function() F.FlySet(true) end) end
if T.SpeedOn then pcall(function() F.SpeedSet(true) end) end
if T.NoClip then pcall(F.NoClipEnable) end
if T.God then pcall(GodEnable) end
if T.StealthGod then pcall(StealthGodEnable) end
if T.LockHealth then pcall(LockHealthEnable) end
if T.Invisible then pcall(InvisibleEnable) end
if T.AntiRagdoll then pcall(F.AntiRagdollEnable) end
if T.InfiniteJump then pcall(F.InfiniteJumpEnable) end
if T.AntiSit then pcall(F.AntiSitEnable) end
if T.AntiAnchor then pcall(F.AntiAnchorEnable) end
if T.Translate then pcall(F.TranslateEnable) end
if T.ESP then pcall(ESPEnable) end
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
for i = 1, #parents do
local parent = parents[i]
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
pcall(function() if T.ESP then ESPEnable() end end)
pcall(function() if T.ESPSkeleton then F.SkeletonEnable() end end)
pcall(function() if T.ESPArrow then F.ArrowEnable() end end)
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
local sg = Instance.new("ScreenGui")
sg.Name = "StatOverlay"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = CoreGui
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
local sg = Instance.new("ScreenGui")
sg.Name = "CrosshairDot"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = CoreGui
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
if F._menuOpen then return true end
local ok, v = pcall(function() return Fluent and Fluent.GUI and Fluent.GUI.Enabled end)
if ok and v == false then return false end
return F._menuOpen
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
end
function F.SyncMoveUI()
pcall(function()
if not (Fluent and Fluent.Options) then return end
local want = T.Fly and "飞行(CFrame)" or (T.FlyPhys and "物理飞行(更平滑)" or "关闭")
local op = Fluent.Options.FlyMode
if op and op.Value ~= want then op:Set(want) end
local so = Fluent.Options.SpeedOn
if so and type(T.Speed) == "boolean" and so.Value ~= T.Speed then so:Set(T.Speed) end
end)
end
function F.HotReload()
local keep, n = {}, 0
for k, v in pairs(T) do
if type(v) == "boolean" and v then keep[k] = true n = n + 1 end
end
pcall(function() if getgenv then getgenv().CM_RELOAD_KEEP = keep end end)
F.Out("[热加载] 已记下 " .. tostring(n) .. " 个开着的功能, 开始取最新版…")
if Fluent and Fluent.Notify then
Fluent:Notify({ Title = "热加载", Content = "正在下载最新版并重启…", Duration = 6 })
end
task.spawn(function()
pcall(function() F.UnloadAll() end)
task.wait(0.6)
local urls = {
"https://ghfast.top/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
"https://ghproxy.net/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
"https://gh-proxy.com/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
"https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
"https://cdn.jsdelivr.net/gh/Mercershixin/CheatMenu@main/CheatMenu.lua",
}
local body = nil
for i = 1, #urls do
local u = urls[i] .. "?cb=" .. tostring(os.time())
local ok, r = pcall(function() return game:HttpGet(u) end)
if ok and type(r) == "string" and #r > 20000 then body = r break end
end
if not body then
F.Out("[热加载] ⚠ 所有源都取不到 —— 旧实例已卸载, 请重新执行一次 loader")
return
end
local fnc = loadstring or load
local chunk, err = fnc(body, "@CheatMenu_hot")
if not chunk then
F.Out("[热加载] ⚠ 新版本编译失败: " .. tostring(err))
return
end
pcall(function() if writefile then writefile("CheatMenu_main.lua", body) end end)
F.Out("[热加载] 已取到 " .. tostring(#body) .. " 字节, 正在执行新实例…")
pcall(chunk)
end)
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
function F.WaypointLabels()
F._waypoints = F._waypoints or {}
local out = {}
for i = 1, 5 do
local cf = F._waypoints[tostring(i)]
if cf then out[i] = string.format("%d: %.0f,%.0f,%.0f", i, cf.Position.X, cf.Position.Y, cf.Position.Z)
else out[i] = i .. ": (空)" end
end
return out
end
local function wpSlot(v) return tostring(v or "1"):match("^(%d+)") or "1" end
function F.RefreshWaypointUI()
pcall(function()
local op = Fluent and Fluent.Options and Fluent.Options.WPSlot
if op and op.SetValues then op:SetValues(F.WaypointLabels()) end
end)
end
function F.SaveWaypoint(slot)
local _, _, root = GC()
if not root then return end
F._waypoints = F._waypoints or {}
F._waypoints[wpSlot(slot)] = root.CFrame
F.RefreshWaypointUI()
end
function F.TpWaypoint(slot)
F._waypoints = F._waypoints or {}
local cf = F._waypoints[wpSlot(slot)]
if not cf then return end
smoothTP(cf)
end
F._flashConn = nil
F._lastDeathCF = nil
function F.FlashbackEnable()
if F._flashConn then return end
F._diedConns = {}
local function hook(h)
local hum = h and h:FindFirstChildOfClass("Humanoid")
if hum then
local conn = hum.Died:Connect(function()
local _, _, r = GC()
if r then F._lastDeathCF = r.CFrame end
end)
F._diedConns[#F._diedConns + 1] = conn
if #F._diedConns > 12 then
local old = table.remove(F._diedConns, 1)
pcall(function() old:Disconnect() end)
end
end
end
hook(LP.Character)
F._flashConn = LP.CharacterAdded:Connect(function(h) task.wait(0.3) hook(h) end)
end
function F.FlashbackDisable()
if F._flashConn then F._flashConn:Disconnect() F._flashConn = nil end
if F._diedConns then
for _, c in ipairs(F._diedConns) do pcall(function() c:Disconnect() end) end
F._diedConns = nil
end
end
function F.FlashbackGo()
if F._lastDeathCF then smoothTP(F._lastDeathCF) end
end
function F.Thrust(dist)
local _, _, root = GC()
if not root then return end
local cam = workspace.CurrentCamera
local dir = cam and cam.CFrame.LookVector or root.CFrame.LookVector
smoothTP(root.CFrame + dir * (tonumber(dist) or 50))
end
F._swimConn = nil
function F.SwimEnable()
if F._swimConn then return end
F._swimConn = RS.Heartbeat:Connect(function()
if not T.Swim then F.SwimDisable() return end
local _, hum = GC()
if hum then
pcall(function()
if hum:GetState() ~= Enum.HumanoidStateType.Swimming then
hum:ChangeState(Enum.HumanoidStateType.Swimming)
end
end)
end
end)
end
function F.SwimDisable()
if F._swimConn then F._swimConn:Disconnect() F._swimConn = nil end
local _, hum = GC()
if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end) end
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
function F.RemoveAccessories()
for _, pl in ipairs(Players:GetPlayers()) do
local ch = pl.Character
if ch then
for _, o in ipairs(ch:GetChildren()) do
if o:IsA("Accessory") or o:IsA("Hat") then pcall(function() o:Destroy() end) end
end
end
end
end
F._binds = {}
F._keybindConn = nil
function F.BindKey(keyName, action) F._binds[keyName] = action end
function F.KeybindEnable()
if F._keybindConn then return end
F._keybindConn = UIS.InputBegan:Connect(function(input, processed)
if processed then return end
local action = F._binds and F._binds[input.KeyCode.Name]
if not action then return end
if action == "飞行" then
local nv = not (T.FlyOn == true)
F.FlySet(nv)
F.SyncMoveUI()
elseif action == "自动攻击" then
T.KillAura = not T.KillAura
if T.KillAura then F.KillAuraEnable() else F.KillAuraDisable() end
elseif action == "穿墙" then
T.NoClip = not T.NoClip
if T.NoClip then F.NoClipEnable() else F.NoClipDisable() end
elseif action == "ESP 透视" then
T.ESP = not T.ESP
if T.ESP then ESPEnable() else ESPDisable() end
elseif action == "隐身" then
T.Invisible = not T.Invisible
if T.Invisible then InvisibleEnable() else InvisibleDisable() end
end
end)
end
function F.KeybindDisable()
if F._keybindConn then F._keybindConn:Disconnect() F._keybindConn = nil end
end
F._panicConn = nil
F.PANIC_KEEP = { StealthMode = true, CharPersist = true, AutoSave = true, GuiProtect = true, PanicKey = true }
function F.PanicKeyDisableAll()
local keep = {}
for k in pairs(F.PANIC_KEEP) do keep[k] = T[k] end
for k in pairs(T) do
if type(T[k]) == "boolean" then T[k] = false end
end
for k, v in pairs(keep) do T[k] = v end
pcall(F.SrvHoldDisable)
for _, fn in ipairs({ ESPDisable, InvisibleDisable, GodDisable, HitboxDisable, FOVDisable, ZoomDisable, AntilagDisable, XrayDisable, MuteDisable, SelfGlowDisable, BulletTracerDisable, AutoInteractDisable, LockHealthDisable, RegenDisable, StealthGodDisable, NoDeathDisable }) do pcall(fn) end
for _, fn in ipairs({ F.HudDisable, F.CrosshairDisable, F.FovCircleDisable, F.FreecamDisable, F.FreezePlayerDisable, F.HidePlayerDisable, F.KillAuraDisable, F.AntiRagdollDisable, F.AntiKnockdownDisable, F.AntiSitDisable, F.AntiAnchorDisable, F.HitboxExpandDisable, F.AntiVoidDisable, F.SkeletonDisable, F.ArrowDisable, F.TrapsESPDisable, F.ChamsDisable, F.NoClipDisable, F.HideDisable, F.InfiniteJumpDisable, F.ClickerDisable, F.FullBrightDisable, F.NightVisionDisable, F.NoFogDisable, F.ItemMagnetDisable, F.TranslateDisable, F.ChatTranslateDisable, F.BubbleTranslateDisable }) do pcall(fn) end
for _, fn in ipairs({ AC.UninstallNamecallHook, AC.UninstallIndexMask, AC.UnblockRemotes, AC.UninstallAntiTP, AC.UninstallPropertyLock, AC.UninstallSetmetatableHook, AC.WatchNewScriptsDisable, AC.WatchNewRemotesDisable, AC.AntiPauseDisable, AC.TrapDisable.Disable, F.CaptureDisable }) do pcall(fn) end
pcall(function()
local _, hum = GC()
if hum then
local o = F._orig or {}
hum.WalkSpeed = o.walk or C._baseWalk or 16
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
if ty == "Toggle" and type(opt.Set) == "function" then pcall(function() opt:Set(false) end) end
end
end
end)
if Fluent and Fluent.Notify then
Fluent:Notify({ Title = "Panic", Content = "已关闭所有功能并恢复原始状态 (F1)", Duration = 3 })
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
if not F._orig.maxHealth and mh and mh == mh and mh < 1e6 then F._orig.maxHealth = mh end
end
if not F._orig.maxZoom then F._orig.maxZoom = LP.CameraMaxZoomDistance end
if not F._orig.minZoom then F._orig.minZoom = LP.CameraMinZoomDistance end
local cam = workspace.CurrentCamera
if cam and not F._orig.fov then F._orig.fov = cam.FieldOfView end
if not F._baseWalk and F._orig.walk then F._baseWalk = F._orig.walk end
end
function F.PanicKeyEnable()
if F._panicConn then return end
F._panicConn = UIS.InputBegan:Connect(function(input, processed)
if processed then return end
if input.KeyCode ~= Enum.KeyCode.F1 then return end
F.PanicKeyDisableAll()
end)
end
function F.PanicKeyDisable()
if F._panicConn then F._panicConn:Disconnect() F._panicConn = nil end
end
function F.DropAllTools()
local bp = LP:FindFirstChild("Backpack")
local ch = LP.Character
local n = 0
local parents = {}
if bp then parents[#parents + 1] = bp end
if ch then parents[#parents + 1] = ch end
for _, parent in ipairs(parents) do
if parent then
for _, t in ipairs(parent:GetChildren()) do
if t:IsA("Tool") then
pcall(function() t.Parent = workspace end)
n = n + 1
end
end
end
end
return n
end
local TOOL_PRESETS = {
["Linked Sword"] = 125013769, ["Darkheart"] = 16895215, ["Illumina"] = 16641274,
["Venomshank"] = 131896478, ["Ice Dagger"] = 124138310, ["Windforce"] = 77443704,
["Gravity Coil"] = 16688968, ["Speed Coil"] = 99119158, ["Fusion Coil"] = 28457223,
["Grappling Hook"] = 30393548, ["Rocket Launcher"] = 32356064, ["Hyperlaser"] = 130113146,
["Magic Carpet"] = 225921000, ["Golden Boombox"] = 14275812,
}
function F.SpawnToolById(assetId, count)
if not assetId then return false end
local id = tostring(assetId):match("%d+")
if not id then return false end
count = math.max(1, math.min(50, tonumber(count) or 1))
local bp = LP:FindFirstChild("Backpack") or LP
local n = 0
for _ = 1, count do
local objs
local ok = pcall(function() objs = game:GetObjects("rbxassetid://" .. id) end)
if not ok or not objs then
ok = pcall(function()
local inst = game:GetService("InsertService"):LoadAsset(tonumber(id))
objs = inst and inst:GetChildren() or nil
end)
end
if ok and objs then
for _, o in ipairs(objs) do
if o:IsA("Tool") or o:IsA("HopperBin") then pcall(function() o.Parent = bp end) n = n + 1
elseif o:IsA("Model") or o:IsA("BasePart") then pcall(function() o.Parent = workspace end) n = n + 1 end
end
end
end
return n > 0
end
function F.ScanGameItems()
local names, protos, seen = {}, {}, {}
for _, root in ipairs({ workspace, RStorage }) do
pcall(function()
local seenN = 0
for _, d in ipairs(root:GetDescendants()) do
seenN = seenN + 1
if seenN % 400 == 0 then task.wait() end
if seenN > 20000 then break end
if (d:IsA("Tool") or d:IsA("Model")) and d:FindFirstChildWhichIsA("BasePart", true) then
local nm = tostring(d.Name)
if nm ~= "" and not seen[nm] then
seen[nm] = true
names[#names + 1] = nm
protos[nm] = d
end
end
end
end)
end
F._gameItemProtos = protos
table.sort(names)
return names
end
function F.SpawnGameItem(name, count)
local protos = F._gameItemProtos or {}
local proto = protos[name]
if not proto then return 0 end
count = math.max(1, math.min(50, tonumber(count) or 1))
local bp = LP:FindFirstChild("Backpack") or LP
local n = 0
for _ = 1, count do
local ok, clone = pcall(function() return proto:Clone() end)
if ok and clone then
if clone:IsA("Tool") then pcall(function() clone.Parent = bp end)
else pcall(function() clone.Parent = workspace end) end
n = n + 1
end
end
return n
end
F._magnetConn = nil
F.MAGNET_TAGS = { "Brainrot", "Item", "Collectible", "Loot", "Pickup", "Cash", "Money" }
function F.ItemMagnetEnable()
if F._magnetConn then return end
if not F._magnetAddedConn then
F._magnetAddedConn = workspace.DescendantAdded:Connect(function(v)
if not T.ItemMagnet then return end
local okKind, isItem = pcall(function() return v:IsA("Tool") or v:IsA("Model") end)
if okKind and isItem then F._magnetListAt = 0 end
end)
end
F._magnetConn = RS.Heartbeat:Connect(function()
if not T.ItemMagnet then F.ItemMagnetDisable() return end
local now = os.clock()
if now - (F._magnetAt or 0) < 0.1 then return end
F._magnetAt = now
local _, _, root = GC()
if not root then return end
local radius = tonumber(C.MagnetRadius) or 60
local kw = tostring(C.MagnetKeyword or ""):lower()
local rp = root.Position
local goal = root.CFrame + Vector3.new(0, 2, 0)
local toMove = {}
if not (F._magnetList and (now - (F._magnetListAt or 0)) < 0.5) then
local scanList, nodes = {}, 0
local queue = { workspace }
local qi = 1
while qi <= #queue and nodes < 4000 do
local node = queue[qi]; qi = qi + 1
for _, ch2 in ipairs(node:GetChildren()) do
nodes = nodes + 1
scanList[#scanList + 1] = ch2
local okKind, isBranch = pcall(function()
return ch2:IsA("Folder") or ch2:IsA("Model")
end)
if nodes < 4000 and okKind and isBranch then
queue[#queue + 1] = ch2
end
end
end
F._magnetList, F._magnetListAt = scanList, now
end
local scanList = F._magnetList or {}
for _, obj in ipairs(scanList) do
local isModel = false
local isTool = false
pcall(function() isModel = obj:IsA("Model") end)
pcall(function() isTool = obj:IsA("Tool") end)
if isModel or isTool then
local match = (kw == "") or tostring(obj.Name):lower():find(kw, 1, true)
if not match then
pcall(function()
for i = 1, #F.MAGNET_TAGS do
if obj:HasTag(F.MAGNET_TAGS[i]) then match = true break end
end
end)
end
if match then
local pos = nil
if isModel then
local okp, piv = pcall(function() return obj:GetPivot() end)
pos = okp and piv.Position or nil
else
local okp, p = pcall(function() return obj.Position end)
pos = okp and p or nil
end
if pos and (pos - rp).Magnitude <= radius then
toMove[#toMove + 1] = obj
end
end
end
end
for i = 1, #toMove do
local obj = toMove[i]
pcall(function()
if obj:IsA("Model") then
obj:PivotTo(goal)
else
obj.CFrame = goal
end
end)
end
end)
end
function F.ItemMagnetDisable()
if F._magnetConn then F._magnetConn:Disconnect() F._magnetConn = nil end
if F._magnetAddedConn then pcall(function() F._magnetAddedConn:Disconnect() end) F._magnetAddedConn = nil end
F._magnetList, F._magnetListAt = nil, 0
end
F._spyHooked = nil
F._spyOld = nil
F._remoteDownConns = nil
function F.RemoteSpyEnable()
if F._spyHooked then return end
local mt = getrawmetatable(game)
if not mt then return end
local prev = mt.__namecall
if type(prev) ~= "function" then return end
if not (hookmetamethod and newcclosure and getnamecallmethod) then return end
local got = F.MetaInstall("__namecall", game, "RemoteSpy", function(box)
return function(self, ...)
local method = type(getnamecallmethod) == "function" and getnamecallmethod() or ""
if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
if not checkcaller() then
F.Out(string.format("[流量] %s:%s", tostring(self.Name), method))
end
end
return box.orig(self, ...)
end
end)
if not got then return end
F._spyHooked = true
F._spyLayer = got
F._remoteDownConns = {}
pcall(function()
for _, d in ipairs(RStorage:GetDescendants()) do
if AC.isRemoteLike(d) then
local conn = d.OnClientEvent:Connect(function(...)
if T.RemoteSpy then F.Out(string.format("[下行] %s", d.Name)) end
end)
F._remoteDownConns[#F._remoteDownConns + 1] = conn
end
end
end)
end
function F.RemoteSpyDisable()
if not F._spyHooked then return end
F.MetaUninstall("__namecall", "RemoteSpy")
if F._remoteDownConns then
for _, c in ipairs(F._remoteDownConns) do pcall(function() c:Disconnect() end) end
F._remoteDownConns = nil
end
F._spyHooked = nil
F._spyOld = nil
end
function F.CallRemote(remoteName, argsStr)
if not remoteName or remoteName == "" then return end
local rem = findRemote(remoteName, "RemoteEvent") or findRemote(remoteName, "RemoteFunction")
if not rem then return end
local args = {}
if argsStr and argsStr ~= "" then
for a in tostring(argsStr):gmatch("[^,]+") do
local t = a:match("^%s*(.-)%s*$")
if t ~= "" then args[#args + 1] = tonumber(t) or t end
end
end
pcall(function()
local cls = AC.isRemoteLike(rem)
if cls == "RemoteFunction" then rem:InvokeServer(table.unpack(args))
elseif cls then rem:FireServer(table.unpack(args)) end
end)
end
F._saveThread = nil
function F.AutoSaveEnable()
if F._saveThread then return end
T.AutoSave = true
F._saveThread = task.spawn(function()
while T.AutoSave do
task.wait(25)
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
function F.DiagConnections()
F.Out("[CheatMenu] === 连接诊断 ===")
if type(getconnections) == "function" then
for name, ev in pairs({ ["RenderStepped"] = RS.RenderStepped, ["Heartbeat"] = RS.Heartbeat, ["Stepped"] = RS.Stepped }) do
local ok, conns = pcall(getconnections, ev)
F.Out(string.format("  %s: %d", name, (ok and type(conns) == "table") and #conns or 0))
end
end
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
local ok, list = pcall(function() return root:GetDescendants() end)
if ok and type(list) == "table" then
for _, obj in ipairs(list) do
if obj:IsA("GuiButton") and obj.Visible then
local hit = false
if obj:IsA("TextButton") and multiplierFromText(obj.Text) then hit = true end
if not hit then
for _, child in ipairs(obj:GetDescendants()) do
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
local CPS = { ["Noobini Pizzanini"]=2,["Tralalero Tralala"]=17500,["Bombardiro Crocodilo"]=3100,["Lucky Fella"]=5000000 }
local MutBuff = { Golden=1.5, Diamond=2, Rainbow=40, Astral=50, Infinity=75 }
local function isEntityTool(t)
if not t or not t:IsA("Tool") then return false end
local ok, ht = pcall(function() return t:HasTag("EntityTool") end)
return ok and ht
end
local function getBrainrotCPS(tool)
local base = CPS[tool.Name]
if not base then
local a = tool:GetAttribute("CPS") or tool:GetAttribute("BaseCPS")
if typeof(a) == "number" then base = a else return nil end
end
local lv = math.clamp(math.floor(tonumber(tool:GetAttribute("Level")) or 1), 1, 75)
local mut = tostring(tool:GetAttribute("Mutation") or "")
return base * (MutBuff[mut] or 1) * ((C.SellLvMul or 1.25) ^ (lv - 1))
end
local SellThread = nil
local function sellLowCPSTools()
if SellThread then return end
SellThread = task.spawn(function()
local total = 0
for _ = 1, 200 do
if not T.AutoSell then break end
local picks = {}
local function scan(list)
if not list then return end
for _, t in ipairs(list:GetChildren()) do
if t:IsA("Tool") and isEntityTool(t) then
local cps = getBrainrotCPS(t)
local th = tonumber(C.SellMinCPS) or 100000
if cps and cps < th then picks[#picks + 1] = { Tool = t, CPS = cps } end
end
end
end
scan(LP.Character)
scan(LP:FindFirstChild("Backpack"))
table.sort(picks, function(a, b) return a.CPS < b.CPS end)
if #picks == 0 then break end
local rf = RFunction("B_Sell")
for _, e in ipairs(picks) do
if not T.AutoSell then break end
local tool = e.Tool
if tool and tool.Parent and rf then
pcall(function() rf:InvokeServer() end)
total = total + 1
end
end
break
end
SellThread = nil
if total > 0 then T.AutoSell = false end
end)
end
local WithdrawThread = nil
local function withdrawAllBrainrots()
if WithdrawThread then return end
WithdrawThread = task.spawn(function()
local _, hum = GC()
if not hum then WithdrawThread = nil return end
local placed = 0
for slot = 1, 30 do
local bp = LP:FindFirstChild("Backpack")
local tool
if bp then
for _, t in ipairs(bp:GetChildren()) do
if isEntityTool(t) then tool = t break end
end
end
if not tool then break end
pcall(function() hum:EquipTool(tool) end)
task.wait(0.2)
if tool.Parent == LP.Character then
Fire("S_Interact", slot)
placed = placed + 1
task.wait(0.15)
end
end
WithdrawThread = nil
end)
end
local CollectThread = nil
local function collectAllCash()
if CollectThread then return end
CollectThread = task.spawn(function()
for i = 1, 30 do
if not T.Collect then break end
Fire("B_Collect", i)
task.wait(0.03)
end
CollectThread = nil
end)
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
for _, obj in ipairs(root:GetDescendants()) do Trans.GuiEl(obj) end
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
function F.SendChat(text)
if not text or text == "" then return false end
local tcs = game:GetService("TextChatService")
if tcs and tcs.TextChannels then
local channel = tcs.TextChannels:FindFirstChild("RBXGeneral")
if channel and channel.SendAsync then pcall(function() channel:SendAsync(text) end) return true end
end
local chatEvents = RStorage:FindFirstChild("DefaultChatSystemChatEvents")
if chatEvents then
local say = chatEvents:FindFirstChild("SayMessageRequest")
if say then pcall(function() say:FireServer(text, "All") end) return true end
end
return false
end
function F.ChatTranslateEnable()
if F._chatTransHooked then return end
local tcs = game:GetService("TextChatService")
if not tcs then F.Out("[翻译] 本游戏没有 TextChatService, 聊天翻译不可用") return end
F._oldOnIncoming = tcs.OnIncomingMessage
local ok = pcall(function()
tcs.OnIncomingMessage = function(message)
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
end)
if ok then F._chatTransHooked = true F.Out("[翻译] 公屏聊天翻译已开启") end
end
function F.ChatTranslateDisable()
if not F._chatTransHooked then return end
pcall(function()
local tcs = game:GetService("TextChatService")
if tcs then tcs.OnIncomingMessage = F._oldOnIncoming end
end)
F._chatTransHooked = false
end
function F.BubbleTranslateEnable()
if F._bubbleTransHooked then return end
local tcs = game:GetService("TextChatService")
if not tcs then return end
F._oldOnBubble = tcs.OnBubbleAdded
local ok = pcall(function()
tcs.OnBubbleAdded = function(message, adornee)
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
end)
if ok then F._bubbleTransHooked = true F.Out("[翻译] 气泡翻译已开启") end
end
function F.BubbleTranslateDisable()
if not F._bubbleTransHooked then return end
pcall(function()
local tcs = game:GetService("TextChatService")
if tcs then tcs.OnBubbleAdded = F._oldOnBubble end
end)
F._bubbleTransHooked = false
end
function F.TranslateText(s) return Trans.Translate(s, true) end
function F.TranslateDisable() Trans.Disable() end
function F.TranslateEnable() return Trans.Enable() end
local function UnloadAll()
for k in pairs(T) do T[k] = false end
local disables = {
F.KickGuardDisable, F.AntiFlingDisable, F.AntiRagdollDisable, F.AntiKnockdownDisable,
F.FreecamDisable, F.FreezePlayerDisable,
F.HidePlayerDisable, F.HudDisable, F.CrosshairDisable, F.FovCircleDisable,
F.PanicKeyDisable, F.DupeAttemptDisable, F.ItemMagnetDisable, F.ChamsDisable,
F.BringPlayerDisable, F.KeybindDisable, F.LockCamDisable, F.SwimDisable,
F.FlashbackDisable, F.RemoteSpyDisable,
F.AntiSitDisable, F.AntiAnchorDisable,
F.CharPersistDisable, F.LivePlayersDisable, F.AutoSaveDisable,
F.TrapsESPDisable, F.SkeletonDisable, F.ArrowDisable,
F.ClickTPDisable, F.AntiVoidDisable, F.AntiAFKDisable,
AC.WatchNewRemotesDisable, AC.WatchNewScriptsDisable, AC.TrapDisable.Disable,
AC.UnblockRemotes, AC.UninstallAntiTP, AC.AntiPauseDisable, AC.UninstallIndexMask,
AC.UninstallPropertyLock, AC.UninstallSetmetatableHook, AC.UninstallNamecallHook,
F.GuiProtectionDisable, F.HitboxExpandDisable, F.AntiVoidDisable,
F.CaptureDisable, F.TranslateDisable, F.ChatTranslateDisable, F.BubbleTranslateDisable,
F.NoClipDisable, ESPDisable, AutoInteractDisable, F.SrvHoldDisable,
F.SpeedSet, F.FlySet,
MuteDisable, FOVDisable, ZoomDisable,
}
for _, fn in ipairs(disables) do pcall(fn) end
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
pcall(F.Conn.ClearAll)
F.Out("[CheatMenu] 已干净卸载")
end
local function RestoreFeatures()
if T.CharPersist ~= false then T.CharPersist = true end
if T.AutoSave ~= false then F.AutoSaveEnable() end
pcall(F.PanicKeyEnable)
T.PanicKey = true
F.LivePlayersEnable()
end
LoadConfig()
local _touch = (UIS.TouchEnabled == true)
local _vw, _vh = 500, 540
pcall(function()
local cam = workspace.CurrentCamera
if cam and cam.ViewportSize.X > 0 then
_vw, _vh = cam.ViewportSize.X, cam.ViewportSize.Y
end
end)
local _w, _h = 500, 540
if _touch then
_w = math.clamp(math.floor(_vw * 0.96), 240, 520)
_h = math.clamp(math.floor(_vh * 0.86), 240, 600)
end
local Window = Fluent:CreateWindow({
Title = "CheatMenu",
SubTitle = "v10.3.0",
TabWidth = _touch and 66 or 100,
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
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = host
local btn = Instance.new("TextButton")
btn.Size = UDim2.fromOffset(58, 58)
btn.Position = UDim2.new(0, 10, 0.36, 0)
btn.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
btn.BackgroundTransparency = 0.2
btn.Text = "菜单"
btn.TextColor3 = Color3.fromRGB(240, 240, 240)
btn.TextSize = 17
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
end
end)
btn.InputChanged:Connect(function(i)
if dragInput and i == dragInput then
btn.Position = UDim2.new(0, bx + (i.Position.X - sx), 0, by + (i.Position.Y - sy))
end
end)
btn.InputEnded:Connect(function(i)
if i == dragInput then dragInput = nil end
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
Tabs.Combat:AddSection("自瞄")
Tabs.Combat:AddToggle("AimOn", { Title = "自瞄(每帧把镜头转向视野内最近的目标)", Default = false, Callback = function(v) F.AimSet(v) end })
Tabs.Combat:AddSlider("AimFOV", { Title = "自瞄范围(屏幕像素)", Min = 50, Max = 800, Default = 200, Rounding = 0, Callback = function(v) C.AimFOV = v end })
Tabs.Combat:AddSlider("AimSmooth", { Title = "平滑度(越大越慢)", Min = 1, Max = 20, Default = 5, Rounding = 0, Callback = function(v) C.AimSmooth = v end })
Tabs.Combat:AddToggle("AimFireOnly", { Title = "开火才锁(按住左键才生效)", Default = false, Callback = function(v) T.AimFireOnly = v end })
Tabs.Combat:AddToggle("AutoFire", { Title = "★ 锁上就开火(自动开火)", Default = false, Callback = function(v) T.AutoFire = v end })
Tabs.Combat:AddSlider("AutoFireGap", { Title = "开火间隔(秒)", Min = 0.02, Max = 1, Default = 0.1, Rounding = 2, Callback = function(v) C.AutoFireGap = v end })
Tabs.Combat:AddToggle("Aim360", { Title = "360°锁敌(背后也能锁 · 范围改按格算)", Default = false, Callback = function(v)
T.Aim360 = v
F.Out("[自瞄] 360° = " .. (v and "开(不看朝向, 按世界距离; 「自瞄范围」此模式下单位=格)" or "关(只锁屏幕内 FOV 圈里)"))
end })
Tabs.Combat:AddDropdown("AimTarget", { Title = "目标选择", Values = {
"所有人(无阵营时自动)",
"仅敌对阵营(有阵营时)",
}, Default = "所有人(无阵营时自动)", Callback = function(v)
C.AimTarget = v
T.AimTeamCheck = (v == "仅敌对阵营(有阵营时)")
F.Out("[自瞄] 目标 = " .. tostring(v) .. (LP.Team and " (本服有阵营)" or " (本服无阵营 ⇒ 按所有人)"))
end })
Tabs.Combat:AddToggle("AimWallCheck", { Title = "墙壁检查", Default = true, Callback = function(v) T.AimWallCheck = v end })
Tabs.Combat:AddToggle("FovCircle", { Title = "FOV 圈", Default = false, Callback = function(v) T.FovCircle = v if v then F.FovCircleEnable() else F.FovCircleDisable() end end })
Tabs.Combat:AddSection("目标管理")
Tabs.Combat:AddDropdown("PriorityTarget", { Title = "优先目标玩家", Values = F.PlayerNames(), Default = nil, Callback = function(v) if v and v ~= "(无人)" then F.AddPriorityTarget(v) end end })
Tabs.Combat:AddDropdown("BlacklistTarget", { Title = "黑名单玩家", Values = F.PlayerNames(), Default = nil, Callback = function(v) if v and v ~= "(无人)" then F.AddBlacklist(v) end end })
Tabs.Combat:AddButton({ Title = "清除优先级/黑名单", Callback = function() C.PriorityTargets = {} C.Blacklist = {} end })
Tabs.Combat:AddSection("生存 / 防御")
Tabs.Combat:AddDropdown("GodMode", { Title = "生命保护", Values = { "关闭", "无敌(MaxHealth=∞)", "隐蔽无敌(锁满血)" },
Default = "关闭", Callback = function(v)
C.GodMode = v
T.God = (v == "无敌(MaxHealth=∞)")
T.StealthGod = (v == "隐蔽无敌(锁满血)")
T.LockHealth, T.NoDeath, T.Regen = false, false, false
GodDisable() StealthGodDisable() LockHealthDisable() NoDeathDisable() RegenDisable()
if T.God then GodEnable() elseif T.StealthGod then StealthGodEnable() end
end })
Tabs.Combat:AddToggle("AntiRagdoll", { Title = "防击倒(反布娃娃+防被撞飞)", Default = false, Callback = function(v)
C.AntiRagdollMode = v and "全部开启" or "关闭"
T.AntiRagdoll, T.AntiKnockdown = v, v
F.AntiRagdollDisable() F.AntiKnockdownDisable()
if v then F.AntiRagdollEnable() F.AntiKnockdownEnable() end
end })Tabs.Combat:AddToggle("HitboxExpand", { Title = "Hitbox 扩展", Default = false, Callback = function(v) T.HitboxExpand = v if v then F.HitboxExpandEnable() else F.HitboxExpandDisable() end end })
Tabs.Combat:AddSection("自动攻击")
Tabs.Combat:AddToggle("KillAura", { Title = "自动攻击(范围内敌人)", Default = false, Callback = function(v) T.KillAura = v if v then F.KillAuraEnable() else F.KillAuraDisable() end end })
Tabs.Combat:AddSlider("KillAuraRange", { Title = "自动攻击范围", Min = 5, Max = 100, Default = 20, Rounding = 0, Callback = function(v) C.KillAuraRange = v end })
Tabs.Combat:AddSlider("KillAuraSpeed", { Title = "自动攻击攻速(次/秒)", Min = 1, Max = 25, Default = 10, Rounding = 0, Callback = function(v) C.KillAuraSpeed = v end })
Tabs.Move:AddSection("飞行")
Tabs.Move:AddToggle("FlyOn", { Title = "飞行(WASD 移动 · 空格升/Ctrl降 · 松手即停)", Default = false, Callback = function(v) F.FlySet(v) end })
Tabs.Move:AddSlider("FlyValue", { Title = "飞行速度(格/秒 · 上不封顶)", Min = 10, Max = 5000, Default = 60, Rounding = 0, Callback = function(v) C.FlyValue = v end })
Tabs.Move:AddSection("加速")
Tabs.Move:AddToggle("SpeedOn", { Title = "加速(水平全向 · 松手即停 · 不含上下)", Default = false, Callback = function(v) F.SpeedSet(v) end })
Tabs.Move:AddSlider("SpeedValue", { Title = "速度(格/秒 · 人类默认 16 · 上不封顶)", Min = 16, Max = 5000, Default = 60, Rounding = 0, Callback = function(v) C.SpeedValue = v if T.SpeedOn then F.SpeedApply() end end })
Tabs.Move:AddSection("其他移动")
Tabs.Move:AddToggle("NoClip", { Title = "穿墙", Default = false, Callback = function(v) T.NoClip = v if v then F.NoClipEnable() else F.NoClipDisable() end end })
Tabs.Move:AddToggle("Hide", { Title = "藏地下", Default = false, Callback = function(v) T.Hide = v if v then F.HideEnable() else F.HideDisable() end end })
Tabs.Move:AddSlider("HideDepth", { Title = "藏地下深度(studs)", Min = 1, Max = 50, Default = 8, Rounding = 0, Callback = function(v) C.HideDepth = v end })
end
do
Tabs.Visual:AddSection("身体高亮 / 敌我识别")
Tabs.Visual:AddToggle("BodyHL", { Title = "身体高亮(替代 ESP, 只描边不糊本体)", Default = false, Callback = function(v)
T.BodyHL = v
if v then F.BodyHLEnable() else F.BodyHLDisable() end
end })
Tabs.Visual:AddToggle("TeamColorHL", { Title = "敌我识别(队友绿 / 敌人红)", Default = true, Callback = function(v)
T.TeamColorHL = v
F.BodyHLRefresh()
end })
Tabs.World:AddSection("画面增强")
Tabs.World:AddToggle("VisionBoost", { Title = "视觉增强(全亮+夜视+去雾)", Default = false, Callback = function(v)
T.FullBright = v T.NightVision = v T.NoFog = v
if v then F.FullBrightEnable() F.NightVisionEnable() F.NoFogEnable()
else F.FullBrightDisable() F.NightVisionDisable() F.NoFogDisable() end
end })
Tabs.World:AddToggle("ViewBoost", { Title = "视角增强(FOV+无限缩放)", Default = false, Callback = function(v)
T.FOV = v T.Zoom = v
if v then FOVEnable() ZoomEnable() else FOVDisable() ZoomDisable() end
end })
Tabs.World:AddSlider("FOV", { Title = "视野 FOV", Min = 70, Max = 120, Default = 100, Rounding = 0, Callback = function(v) C.FOV = v if T.FOV then FOVEnable() end end })
Tabs.World:AddSlider("Zoom", { Title = "缩放距离", Min = 128, Max = 1000, Default = 400, Rounding = 0, Callback = function(v) C.Zoom = v if T.Zoom then ZoomEnable() end end })
Tabs.World:AddToggle("Mute", { Title = "静音", Default = false, Callback = function(v) T.Mute = v if v then MuteEnable() else MuteDisable() end end })
Tabs.World:AddToggle("Antilag", { Title = "降画质", Default = false, Callback = function(v) T.Antilag = v if v then AntilagEnable() else AntilagDisable() end end })
Tabs.World:AddSection("相机 / 准星")
Tabs.World:AddToggle("Freecam", { Title = "自由视角 Freecam", Default = false, Callback = function(v) T.Freecam = v if v then F.FreecamEnable() else F.FreecamDisable() end end })
Tabs.World:AddToggle("Hud", { Title = "FPS/Ping HUD", Default = false, Callback = function(v) T.Hud = v if v then F.HudEnable() else F.HudDisable() end end })
Tabs.World:AddToggle("Crosshair", { Title = "准星", Default = false, Callback = function(v) T.Crosshair = v if v then F.CrosshairEnable() else F.CrosshairDisable() end end })
Tabs.World:AddToggle("LockCam", { Title = "锁相机", Default = false, Callback = function(v) T.LockCam = v if v then F.LockCamEnable() else F.LockCamDisable() end end })
end
do
Tabs.TP:AddSection("传送")
Tabs.TP:AddDropdown("TPTarget", { Title = "目标玩家", Values = F.PlayerNames(), Default = nil })
Tabs.TP:AddButton({ Title = "传送到目标", Callback = function()
local name = Fluent.Options.TPTarget and Fluent.Options.TPTarget.Value
if name then TeleportToPlayer(Players:FindFirstChild(name)) end
end })
Tabs.AFK:AddSection("自动化")
Tabs.AFK:AddToggle("KickProtect", { Title = "挂机防踢(反挂机+拦截Kick+抢传)", Default = true, Callback = function(v)
T.KickProtect = v T.AntiAFK = v T.KickGuard = v T.KickRejoin = v
if v then F.AntiAFKEnable() F.KickGuardEnable() F.KickRejoinEnable()
else F.KickGuardDisable() F.AntiAFKDisable() pcall(F.KickRejoinDisable) end
end })
Tabs.AFK:AddToggle("AutoTrain", { Title = "踢击训练", Default = false, Callback = function(v) T.AutoTrain = v if v then F.AutoTrainEnable() end end })
Tabs.AFK:AddToggle("AutoBonus", { Title = "领取踢击距离", Default = false, Callback = function(v) T.AutoBonus = v if v then F.AutoBonusEnable() end end })
Tabs.AFK:AddSlider("AutoTrainSec", { Title = "训练循环间隔(秒)", Min = 1, Max = 30, Default = 5, Rounding = 1, Callback = function(v) C.AutoTrainSec = v end })
Tabs.AFK:AddToggle("AutoGym", { Title = "自动锻炼(健身房)", Default = false, Callback = function(v) T.AutoGym = v if v then F.AutoGymEnable() end end })
Tabs.Trans:AddSection("本地翻译服务")
Tabs.Trans:AddToggle("Translate", { Title = "翻译总开关(UI 文字 + 互动文字)", Default = false, Callback = function(v)
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
if v then F.ChatTranslateEnable() else F.ChatTranslateDisable() end
end })
Tabs.Trans:AddToggle("BubbleTranslate", { Title = "气泡聊天翻译(官方钩子)", Default = false, Callback = function(v)
T.BubbleTranslate = v
if v then F.BubbleTranslateEnable() else F.BubbleTranslateDisable() end
end })
Tabs.AC:AddSection("反作弊")
Tabs.AC:AddToggle("ACMaster", { Title = "防护(不改写游戏: 反甩 + 护界面 + 权限守卫)", Default = false, Callback = function(v)
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
Content = "已开启(不改写游戏, 不影响交互): 反甩 + 界面保护 + 权限守卫 · 环境 " .. tostring(acName or "未识别"),
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
pcall(F.AutoProbe)
pcall(F.LogFlush, "统一扫描")
Fluent:Notify({
Title = "扫描完成",
Content = "拦 remote " .. tostring(n) .. " 个 · 执行器能力 " .. tostring(capOk) .. "/" .. tostring(capTotal) .. " —— 明细见控制台 F9",
Duration = 8,
})
end)
end })
Tabs.AC:AddSection("扫描补强(阈值 / 形状 / 反查 / 家族)")
Tabs.AC:AddButton({ Title = "★ 提取数字阈值(速度/位移/滞空 的观感上限)", Callback = function()
task.spawn(function() pcall(F.ScanThresholds) pcall(F.LogFlush, "阈值扫描") end)
end })
Tabs.AC:AddButton({ Title = "按形状找函数(upvalue数, 常量数)", Callback = function()
local box = Fluent and Fluent.Options and Fluent.Options.ShapeBox
local txt = box and tostring(box.Value or "") or ""
local a, b = txt:match("^(%d+)[,%s]+(%d+)$")
task.spawn(function()
if a and b then
pcall(function() F.FindByShape(tonumber(a), tonumber(b)) end)
else
F.Out("[形状] 请在上面的输入框按 `upvalue数,常量数` 格式填写, 例如 `19,15`")
end
pcall(F.LogFlush, "形状搜索")
end)
end })
Tabs.AC:AddInput("ShapeBox", { Title = "形状(如 19,15)", Default = "", Placeholder = "upvalue数,常量数", Callback = function() end })
Tabs.AC:AddButton({ Title = "反查持有者(用最近一次扫描到的可疑 remote)", Callback = function()
task.spawn(function()
pcall(function()
local t = F._lastSusRemote
if t == nil then F.Out("[反查] 还没有可疑 remote —— 先点一次「一键扫描」") return end
F.TraceHolders(t)
end)
pcall(F.LogFlush, "反查")
end)
end })
Tabs.AC:AddButton({ Title = "家族聚类(同一 source 的可疑函数群)", Callback = function()
task.spawn(function() pcall(F.ScanFamilies) pcall(F.LogFlush, "家族聚类") end)
end })
Tabs.AC:AddButton({ Title = "★ 一键自动分析(不用你输入, 自动挑词→找函数→报阈值)", Callback = function()
task.spawn(function() pcall(F.AutoProbe) pcall(F.LogFlush, "自动分析") end)
end })
Tabs.AC:AddButton({ Title = "按分析结果把速度压到安全值(会告诉你改了什么)", Callback = function()
task.spawn(function() pcall(F.ApplySafeCaps) pcall(F.LogFlush, "安全值") end)
end })
Tabs.AC:AddInput("ConstBox", { Title = "（可选）手动指定关键词, 逗号分隔", Default = "",
Placeholder = "留空即可, 上面的自动分析不用填", Callback = function() end })
Tabs.AC:AddButton({ Title = "★ 按常量字符串找函数(不靠名字, 学自 Adonis 绕过)", Callback = function()
task.spawn(function()
pcall(function()
local box = Fluent and Fluent.Options and Fluent.Options.ConstBox
local txt = box and tostring(box.Value or "") or ""
local list = {}
for w in txt:gmatch("[^,，]+") do
local t = w:gsub("^%s+", ""):gsub("%s+$", "")
if #t > 0 then list[#list + 1] = t end
end
if #list == 0 then
F.Out("[按常量] 请先在上面的输入框按 `关键词1, 关键词2` 填（默认全都要命中）")
else
F.ScanByConstants(list, "all")
end
end)
pcall(F.LogFlush, "按常量找函数")
end)
end })
Tabs.AC:AddSection("采集与导出")
Tabs.AC:AddToggle("CaptureOn", { Title = "采集 remote 上行(边玩边记, 导出看结果)", Default = false, Callback = function(v)
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
Tabs.Move:AddButton({ Title = "★ 反拉回诊断(一键: 所有权→夺取→探针→必要时压速)", Callback = function() F.SrvOneClick() end })
Tabs.Setting:AddButton({ Title = "保存配置", Callback = function() SaveConfig() Fluent:Notify({ Title = "配置", Content = "已保存", Duration = 2 }) end })
Tabs.Setting:AddButton({ Title = "★ 热加载(下载最新版 + 保留已开功能)", Callback = function() F.HotReload() end })
F.UnloadAll = UnloadAll
Tabs.Setting:AddButton({ Title = "卸载脚本", Callback = function() UnloadAll() end })
T.CharPersist = true
T.AutoSave = true
F.CharPersistEnable()
F.RecordOriginals()
Fluent:Notify({ Title = "CheatMenu", Content = "已加载 v10.3.0 · 所有功能默认关闭(需要哪个自己开)", Duration = 8 })
RestoreFeatures()
pcall(function()
local ex = "?"
pcall(function() ex = tostring(select(2, pcall(identifyexecutor))) end)
F.Out(string.format("[环境] 执行器=%s · 平台=%s · loadstring=%s · writefile=%s · gethui=%s · 触屏=%s",
ex, (UIS.TouchEnabled and "触屏(手机/平板)" or "键鼠(PC)"),
type(loadstring), type(writefile), type(gethui), tostring(UIS.TouchEnabled)))
end)
F.Out("[CheatMenu] ✅ 加载完成 v10.3.0")
end
function F.CloseDropdowns()
if not (Fluent and Fluent.Options) then return end
for _, opt in pairs(Fluent.Options) do
if type(opt) == "table" then
pcall(function() if opt.Open then opt:Close() end end)
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
local ok, desc = pcall(function() return Fluent.GUI:GetDescendants() end)
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
Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
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
buildMenu()
function F.CfgSyncUI()
local op = Fluent and Fluent.Options
if type(op) ~= "table" then return 0 end
local n = 0
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
return n
end
task.spawn(function()
pcall(function()
for i = 2, 5 do
local k = "F" .. i
local act = C["Bind" .. k]
if type(act) == "string" then F.BindKey(k, act) end
end
if C.FlyDisguise == nil then
C.FlyDisguise = "关闭"
T.SrvHoldOwn = false
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
