print(('[CheatMenu] build 2026-09-29 01:48 sha f3c99d4a bytes 216126'):format('2026-09-29 01:48','f3c99d4a',216126))
local F = {}
print("[CheatMenu] ===== 加载开始 · v6.10.0 =====")
local Players  = game:GetService("Players")
local RS       = game:GetService("RunService")
local UIS      = game:GetService("UserInputService")
local HS       = game:GetService("HttpService")
local CS       = game:GetService("CollectionService")
local RStorage = game:GetService("ReplicatedStorage")
local WS       = game:GetService("Workspace")
local LP = Players.LocalPlayer
local PG = LP:FindFirstChild("PlayerGui")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")
local hookfunction  = hookfunction or hookfunc or replaceclosure
local newcclosure   = newcclosure
local hookmetamethod = hookmetamethod
local getgc         = getgc or getGC
local islclosure    = islclosure
local checkcaller   = checkcaller or function() return false end
local getnamecallmethod = getnamecallmethod
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
local function ok2(o) return (o and o:IsA(cls) and o.Name == name) and o or nil end
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
if type(d.T) == "table" then for k, v in pairs(d.T) do T[k] = v end end
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
if ok3 and loaded then Fluent = loaded print("[CheatMenu] Fluent 加载成功") break end
end
end
end
if not Fluent then error("[CheatMenu] Fluent UI 加载失败") end
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
function AC.InstallNamecallHook()
if not hookmetamethod or not newcclosure then return false end
if AC._nc then return true end
local old
old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
local method = getnamecallmethod and getnamecallmethod() or ""
if method == "Kick" and self == LP and T.NamecallHook then
print("[CheatMenu] 拦下 Kick: " .. tostring(select(1, ...)))
return nil
end
if (method == "FireServer" or method == "InvokeServer") and T.RemoteBlock and not checkcaller() then
local name = tostring(self and self.Name or ""):lower()
for _, kw in ipairs(AC.SUS_KEYS) do
if name:find(kw, 1, true) then return nil end
end
end
return old(self, ...)
end))
if type(old) ~= "function" then return false end
AC._nc = true
AC._ncOrig = old
return true
end
function AC.UninstallNamecallHook()
if not (AC._nc and hookmetamethod and AC._ncOrig) then return false end
local ok = pcall(function() hookmetamethod(game, "__namecall", AC._ncOrig) end)
AC._nc = false
AC._ncOrig = nil
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
print("[CheatMenu] 拦截弱表 setmetatable: __mode=" .. mode .. " (累计 " .. AC._weakSeen .. ")")
end
end
end
return AC._stblOld(tbl, mt)
end))
end)
if ok and type(res) == "function" then
AC._stblOld = res
print("[CheatMenu] setmetatable Hook 已安装")
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
if removed > 0 then print("[CheatMenu] 已删除 " .. removed .. " 个 AnimationHandler") end
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
print("[CheatMenu] 拦截可疑脚本: " .. d:GetFullName() .. (strong and " (强特征·延迟销毁)" or " (词元特征·仅禁用)"))
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
if T.Speed then v = (C._baseWalk or 16) * (C.SpeedMul or 2) end
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
if AC._idxMaskOn then AC.UninstallIndexMask() end
if not (hookmetamethod and newcclosure) then return false end
local ok, res = pcall(function()
return hookmetamethod(game, "__index", newcclosure(function(t, k)
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
return AC._idxMaskOld(t, k)
end))
end)
if ok and type(res) == "function" then
AC._idxMaskOld = res
AC._idxMaskOn = true
return true
end
return false
end
AC.InstallIndexHook = function() return AC.InstallIndexMask() end
function AC.UninstallIndexMask()
if AC._idxMaskOn and hookmetamethod and AC._idxMaskOld then
pcall(function() hookmetamethod(game, "__index", AC._idxMaskOld) end)
end
AC._idxMaskOn = false
AC._idxMaskOld = nil
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
print(string.format("[CheatMenu] 连接清理: 扫描 %d 条, 禁用 %d 条", out.scanned, out.disabled))
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
print("[CheatMenu] 防暂停: 当前容器里没有 RobloxGui, 本项跳过(不影响其它功能)")
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
F._stealthOn = false
F._stealthRestore = {}
F._stealthHooked = setmetatable({}, { __mode = "k" })
F._stealthLayers = {}
F.StealthAggressive = true
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
function F.StealthDebugLayer()
if F._debugHookOn then return 0, true end
local installed = 0
for i = 1, #F.GC_SPOOF_KEYS do
local key = F.GC_SPOOF_KEYS[i]
if type(debug[key]) == "function" then
local got = F.stealthHook(debug[key], function(box)
return function(f, t, ...)
if not F._scavenging and not checkcaller() and type(f) == "function" then
local luaFn = (not islclosure) or islclosure(f)
local aggressive = (key == "info") and F.StealthAggressive and luaFn
if F.isProtectedFn(f) or aggressive then
if t == "s" then return "[C]" end
if t == "l" then return 0 end
if t == "f" then return f end
if key == "getconstants" or key == "getprotos" then return {} end
if type(t) == "string" and #t > 1 then
local packed = table.pack(box.orig(f, t, ...))
local first = packed[1]
if type(first) == "table" then
if first.source ~= nil then first.source = "[C]" end
if first.linedefined ~= nil then first.linedefined = 0 end
if first.currentline ~= nil then first.currentline = 0 end
if first.what ~= nil then first.what = "C" end
return first
end
for i = 1, packed.n do
local v = packed[i]
if type(v) == "string" and (v:sub(1, 1) == "@" or v:sub(1, 1) == "=") then
packed[i] = "[C]"
end
end
return table.unpack(packed, 1, packed.n)
end
if key == "info" then return box.orig(f, t, ...) end
return nil
end
end
return box.orig(f, t, ...)
end
end)
if got then installed = installed + 1 end
end
end
F._debugHookOn = installed > 0
return installed, F._debugHookOn
end
function F.StealthGameDebugLayer()
local env = F.getGameEnv()
local dbg = env and env.debug
if type(dbg) ~= "table" or type(dbg.info) ~= "function" then return false, false end
if dbg.info == debug.info or dbg.info == debug.getinfo then return false, true end
local got = F.stealthHook(dbg.info, function(box)
return function(f, t, ...)
if not F._scavenging and not checkcaller() and type(f) == "function" then
local luaFn = (not islclosure) or islclosure(f)
if F.isProtectedFn(f) or (F.StealthAggressive and luaFn) then
if t == "s" then return "[C]" end
if t == "l" then return 0 end
if t == "f" then return f end
if type(t) == "string" and #t > 1 then
local r = box.orig(f, t, ...)
if type(r) == "table" then
if r.source ~= nil then r.source = "[C]" end
if r.linedefined ~= nil then r.linedefined = 0 end
if r.currentline ~= nil then r.currentline = 0 end
if r.what ~= nil then r.what = "C" end
end
return r
end
end
end
return box.orig(f, t, ...)
end
end)
return got ~= nil, false
end
function F.StealthGameGetfenvLayer()
local env = F.getGameEnv()
if type(env) ~= "table" or type(env.getfenv) ~= "function" then return false, false end
if env.getfenv == getfenv then return false, true end
local got = F.stealthHook(env.getfenv, function(box)
return function(l, ...)
if not F._scavenging and not checkcaller() and type(l) == "number" and l >= 1 and l <= 10 then
return box.orig(10)
end
return box.orig(l, ...)
end
end)
return got ~= nil, false
end
function F.StealthIdentityLayer()
local installed = 0
local names = { "getthreadidentity", "getidentity" }
local holders = {}
local env = F.getGameEnv()
if env then holders[#holders + 1] = env end
if type(getgenv) == "function" then
local ok, g = pcall(getgenv)
if ok and type(g) == "table" and g ~= env then holders[#holders + 1] = g end
end
holders[#holders + 1] = _G
for i = 1, #names do
local nm = names[i]
for j = 1, #holders do
local h = holders[j]
if type(h) == "table" and type(h[nm]) == "function" then
local got = F.stealthHook(h[nm], function(box)
return function(...)
if not F._scavenging and not checkcaller() then return 2 end
return box.orig(...)
end
end)
if got then installed = installed + 1 end
end
end
end
return installed > 0
end
function F.StealthTracebackLayer()
local targets = { debug.traceback }
local env = F.getGameEnv()
if env and env.debug and type(env.debug.traceback) == "function"
and env.debug.traceback ~= debug.traceback then
targets[#targets + 1] = env.debug.traceback
end
local installed = 0
for i = 1, #targets do
local got = F.stealthHook(targets[i], function(box)
return function(...)
local r = box.orig(...)
if not F._scavenging and type(r) == "string" then
local mine = AC._mySrc
local out = {}
for line in (r .. "\n"):gmatch("([^\n]*)\n") do
local hit = false
if mine and mine ~= "" and line:find(mine, 1, true) then hit = true end
if line:find("CheatMenu", 1, true) then hit = true end
if not hit then out[#out + 1] = line end
end
return table.concat(out, "\n")
end
return r
end
end)
if got then installed = installed + 1 end
end
return installed > 0
end
function F.StealthEnable()
local marked = F.markOwnClosures()
local nA, okA = F.StealthDebugLayer()
local okB, sameB = F.StealthGameDebugLayer()
local okC, sameC = F.StealthGameGetfenvLayer()
local okD = F.StealthIdentityLayer()
local okE = F.StealthTracebackLayer()
local cnt = (okA and 1 or 0) + (okB and 1 or 0) + (okC and 1 or 0) + (okD and 1 or 0) + (okE and 1 or 0)
F._stealthOn = cnt > 0
F._stealthLayers = {
debug = okA and 1 or 0, gameDebug = okB and 1 or 0, gameGetfenv = okC and 1 or 0,
identity = okD and 1 or 0, traceback = okE and 1 or 0,
}
print(string.format("[CheatMenu] 隐身 %d/5 层 (debug=%s 游戏debug=%s 游戏getfenv=%s 身份=%s 回溯=%s) · 登记闭包 %d 个",
cnt, tostring(okA), tostring(okB), tostring(okC), tostring(okD), tostring(okE), marked))
if sameB then print("[CheatMenu]   (注: getrenv().debug.info 与全局是同一对象, 已由第 1 层覆盖)") end
if sameC then print("[CheatMenu]   (注: getrenv().getfenv 与全局是同一对象, 无需重复盖)") end
return F._stealthOn, marked
end
function F.StealthDisable()
if hookfunction and F._stealthRestore then
for i = #F._stealthRestore, 1, -1 do
local rec = F._stealthRestore[i]
pcall(function() hookfunction(rec.obj, rec.orig) end)
end
end
F._stealthRestore = {}
F._stealthHooked = setmetatable({}, { __mode = "k" })
F._debugHookOn = false
F._stealthOn = false
print("[CheatMenu] 隐身影身层已卸载")
end
function F.SpoofGCMetadata()
local ok, marked = F.StealthEnable()
return ok, marked
end
function F.UnspoofGCMetadata()
F.StealthDisable()
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
F._scavenging = false
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
print(string.format("[CheatMenu] 击退/速度缩放 x%s: 命中 %d 个信号, 改写 %d 个回调", tostring(factor), sigs, total))
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
print(string.format("[CheatMenu] 元表剥离: 含键 %q 的表 %d 个", keyName, n))
return n
end
function AC.PokeUpvalue(fnName, idx, value)
local f = AC.FindFn(fnName)
if type(f) ~= "function" or type(idx) ~= "number" then return false end
local ok = pcall(function()
local okset = (type(setupvalue) == "function")
if okset then setupvalue(f, idx, value) else debug.setupvalue(f, idx, value) end
end)
print(string.format("[CheatMenu] 原地改 upvalue: %s[%s] = %s -> %s", tostring(fnName), tostring(idx), tostring(value), ok and "成功" or "失败"))
return ok
end
F.CAP_LIST = {
{ "getgc", "扫描 GC 对象 —— 整个扫描模块的地基" },
{ "filtergc", "按名一步定位函数(反作弊中和强烈依赖)" },
{ "getconnections", "断反作弊监听 / 改写游戏自己的回调" },
{ "getnilinstances", "扫隐藏实例(反作弊藏 remote 的常用手法)" },
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
F._capOn = true
F._capLog = {}
local old
local ok = pcall(function()
old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
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
end
end
end
return old(self, ...)
end))
end)
if not (ok and type(old) == "function") then
F._capOn = false
return false
end
F._capOld = old
AC.markHooked(old)
F.Out("[采集] 已开始记录 remote 上行调用(上限 " .. F.CAP_MAX .. " 条)")
F.Out("[采集] 现在**正常玩一会儿**(建议 5-10 分钟: 卖东西/买东西/踢方块/被检测的操作都做一遍)")
F.Out("[采集] 玩完点「一键全量导出」, 内容会复制到剪贴板, 直接粘给我即可")
return true
end
function F.CaptureDisable()
F._capOn = false
if F._capOld and hookmetamethod then
pcall(function() hookmetamethod(game, "__namecall", F._capOld) end)
end
F._capOld = nil
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
for _, d in ipairs(r:GetDescendants()) do bag[#bag + 1] = d end
for j = 1, #bag do
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
if type(sc) == "function" then sc(text) copied = true end
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
F._logBaseName = string.format("CheatMenu_日志_%s_%s", gname, pid)
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
print("[日志] 执行器: " .. tostring(exec or "未知"))
print("[日志] 文件路径: " .. path)
print("[日志] 命名: " .. F.LogBaseName() .. ".txt (游戏名 + PlaceId, 不同游戏不冲突; 超 1.5MB 自动轮转 _2/_3)")
return path, exec
end
function F.Out(...)
print(...)
local n = select("#", ...)
local parts = {}
for i = 1, n do parts[i] = tostring(select(i, ...)) end
F._logBuf[#F._logBuf + 1] = table.concat(parts, " ")
if #F._logBuf >= F.LOG_BUF_MAX then pcall(F.LogFlush, "自动") end
end
function F.LogFlush(tag)
if #F._logBuf == 0 then return nil end
local body = table.concat(F._logBuf, "\n") .. "\n"
F._logBuf = {}
local base = F.LogBaseName()
local okWrite = false
local usedName = nil
local hasRW = false
pcall(function() hasRW = (type(writefile) == "function" and type(readfile) == "function") end)
if not hasRW then
print("[日志] ⚠ 执行器不支持 readfile/writefile, 内容只留在 F9 控制台(点「一键全量导出」可复制)")
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
print(string.format("[日志] %s 已写入 %s (%d 字节, 本次追加 %d 字符)", tostring(tag or ""), name, size + #body, #body))
end
break
end
end
if not okWrite then print("[日志] ⚠ 写入失败(可能磁盘只读或路径不允许)") end
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
pcall(F.SpoofGCMetadata)
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
if not T.AntiAFK then return end
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
print("[CheatMenu] 本地拦截 Kick: " .. tostring(msg))
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
F.PLAYER_DROPDOWNS = { "TPTarget", "FlingTarget", "PriorityTarget", "BlacklistTarget" }
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
function F.getAimTarget()
local now = os.clock()
if F._aimCache and (now - F._aimCacheAt) < 0.03 and F._aimCache.Parent then return F._aimCache end
local cam = workspace.CurrentCamera
local fovRadius = C.AimFOV or 200
local best, bestDist = nil, math.huge
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP then
local ch = pl.Character
local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hrp and hrp.Parent and hum and hum.Health > 0 then
if C.Blacklist[pl.Name] then continue end
local skip = false
if T.AimTeamCheck and pl.Team == LP.Team then skip = true end
if not skip and T.AimWallCheck then
local origin = cam.CFrame.Position
local dir = hrp.Position - origin
local params = RaycastParams.new()
params.FilterDescendantsInstances = F.filterList(LP.Character, pl.Character)
params.FilterType = Enum.RaycastFilterType.Exclude
if F.SafeRaycast(origin, dir, params) then skip = true end
end
if not skip then
local screenPos, onScreen = cam:WorldToScreenPoint(hrp.Position)
if onScreen then
local dist = (Vector2.new(screenPos.X, screenPos.Y) - cam.ViewportSize / 2).Magnitude
if dist < bestDist and dist < fovRadius then
bestDist = dist
best = hrp
end
end
end
end
end
end
F._aimCache, F._aimCacheAt = best, now
return best
end
F.AimConn = nil
local function AimDisable() if F.AimConn then F.AimConn:Disconnect() F.AimConn = nil end end
local function AimEnable()
AimDisable()
F.AimConn = RS.RenderStepped:Connect(function()
if not T.Aim then return end
if T.TriggerBot and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
local target = F.getAimTarget()
if not target then return end
local cam = workspace.CurrentCamera
local smooth = math.max(1, C.AimSmooth or 5)
cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position, predictPos(target)), 1 / smooth)
end)
end
F.SilentAimConn = nil
local function SilentAimDisable() if F.SilentAimConn then F.SilentAimConn:Disconnect() F.SilentAimConn = nil end end
local function SilentAimEnable()
if F.SilentAimConn then return end
F.SilentAimConn = RS.RenderStepped:Connect(function()
if not T.SilentAim then return end
if T.TriggerBot and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
local target = F.getAimTarget()
if not target then return end
workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, predictPos(target))
end)
end
local SilentAimGhostHook = nil
local function SilentAimGhostDisable()
if SilentAimGhostHook and hookmetamethod then
pcall(function() hookmetamethod(game, "__namecall", SilentAimGhostHook) end)
end
SilentAimGhostHook = nil
end
local function SilentAimGhostEnable()
if SilentAimGhostHook then return end
if not (hookmetamethod and newcclosure and getnamecallmethod) then return end
local function fakeRayResult(targetPart, origin)
local tp = targetPart.Position
local d = tp - origin
local dist = d.Magnitude
local normal = (dist > 0.001) and -d.Unit or Vector3.new(0, 1, 0)
return {
Instance = targetPart,
Position = tp,
Normal = normal,
Distance = dist,
Material = targetPart.Material or Enum.Material.Plastic,
}
end
local old
local ok, res = pcall(function()
return hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
local method = getnamecallmethod()
if T.SilentAimGhost and not checkcaller() then
if method == "Raycast" and self == workspace then
local args = { ... }
local origin, direction = args[1], args[2]
if typeof(origin) == "Vector3" and typeof(direction) == "Vector3" then
local target = F.getAimTarget()
if target then
local hit = old(self, table.unpack(args))
if not hit or hit.Instance ~= target then
return fakeRayResult(target, origin)
end
return hit
end
end
return old(self, ...)
elseif method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList"
or method == "FindPartOnRayWithWhitelist" then
local args = { ... }
local ray = args[1]
if typeof(ray) == "Ray" then
local target = F.getAimTarget()
if target then
local hitPart, hitPos = old(self, table.unpack(args))
if not hitPart or hitPart ~= target then
local goal = predictPos(target)
local n = ray.Origin - goal
local mg = n.Magnitude
return target, goal, ((mg > 0.001) and n.Unit or Vector3.new(0, 1, 0)),
target.Material or Enum.Material.Plastic
end
return hitPart, hitPos
end
end
end
end
return old(self, ...)
end))
end)
if ok and type(res) == "function" then
old = res
SilentAimGhostHook = AC.markOwn(res)
end
end
F._saMouseOn = false
F._saMouseOld = nil
function F.SilentAimMouseEnable()
if F._saMouseOn then return end
if not (hookmetamethod and newcclosure) then return end
local mouse = LP:GetMouse()
if not mouse then return end
local ok, res = pcall(function()
return hookmetamethod(mouse, "__index", newcclosure(function(self, k)
if T.SilentAimMouse and not checkcaller() then
if k == "Hit" or k == "Target" or k == "UnitRay" then
local target = F.getAimTarget()
if target then
local pos = predictPos(target) or target.Position
if k == "Hit" then return CFrame.new(pos) end
if k == "Target" then return target end
if k == "UnitRay" then
local cam = workspace.CurrentCamera
local origin = cam and cam.CFrame.Position or pos
return Ray.new(origin, (pos - origin).Unit)
end
end
end
end
return F._saMouseOld(self, k)
end))
end)
if ok and type(res) == "function" then
F._saMouseOld = res
F._saMouseOn = true
end
end
function F.SilentAimMouseDisable()
if F._saMouseOn and hookmetamethod and F._saMouseOld then
pcall(function()
local mouse = LP:GetMouse()
hookmetamethod(mouse, "__index", F._saMouseOld)
end)
end
F._saMouseOn = false
F._saMouseOld = nil
end
F.SilentAimChance = 100
F.SilentAimTeamCheck = true
F.SilentAimWallCheck = true
F.SilentAimHitPart = "HumanoidRootPart"
F._saUnifiedHooked = false
F._saUnifiedOld = nil
local function getClosestForUnified()
local now = os.clock()
if F._sauCache and (now - (F._sauCacheAt or 0)) < 0.03 and F._sauCache.Parent then return F._sauCache end
local best, bestDist
local cam = workspace.CurrentCamera
for _, pl in ipairs(Players:GetPlayers()) do
if pl == LP then continue end
if F.SilentAimTeamCheck and pl.Team == LP.Team then continue end
local ch = pl.Character
if not ch then continue end
local hum = ch:FindFirstChildOfClass("Humanoid")
if not hum or hum.Health <= 0 then continue end
local part = ch:FindFirstChild(F.SilentAimHitPart)
if not part then continue end
if F.SilentAimWallCheck then
local ok, parts = pcall(function()
return cam:GetPartsObscuringTarget({part.Position}, {LP.Character, ch})
end)
if ok and parts and #parts > 0 then continue end
end
local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
if not onScreen then continue end
local dist = (Vector2.new(screenPos.X, screenPos.Y) - cam.ViewportSize / 2).Magnitude
if dist <= (C.AimFOV or 200) and (not bestDist or dist < bestDist) then
best = part bestDist = dist
end
end
F._sauCache, F._sauCacheAt = best, now
return best
end
function F.SilentAimUnifiedEnable()
if F._saUnifiedHooked then return end
if not (hookmetamethod and newcclosure) then return end
local saOrig
local okSa = pcall(function()
saOrig = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
local method = getnamecallmethod()
if math.random(0, 100) > F.SilentAimChance then return F._saUnifiedOld(self, ...) end
local target = getClosestForUnified()
if not target then return F._saUnifiedOld(self, ...) end
local args = { ... }
if method == "Raycast" and self == workspace then
local origin, direction = args[1], args[2]
if typeof(origin) ~= "Vector3" or typeof(direction) ~= "Vector3" then
return F._saUnifiedOld(self, table.unpack(args))
end
local goal = predictPos(target)
args[2] = (goal - origin).Unit * direction.Magnitude
local real = F._saUnifiedOld(self, table.unpack(args))
local d = goal - origin
return {
Instance = target,
Position = goal,
Normal = (d.Magnitude > 0.001) and -d.Unit or Vector3.new(0, 1, 0),
Distance = d.Magnitude,
Material = (real and real.Material) or target.Material or Enum.Material.Plastic,
}
elseif method == "FindPartOnRay" or method == "FindPartOnRayWithWhitelist" or method == "FindPartOnRayWithIgnoreList" then
local ray = args[1]
local origin = (typeof(ray) == "Ray") and ray.Origin or nil
if not origin then return F._saUnifiedOld(self, table.unpack(args)) end
local goal = predictPos(target)
args[1] = Ray.new(origin, (goal - origin).Unit * 1000)
local hitPart, hitPos = F._saUnifiedOld(self, table.unpack(args))
if not hitPart or hitPart ~= target then
local n = origin - goal
return target, goal, ((n.Magnitude > 0.001) and n.Unit or Vector3.new(0, 1, 0)),
target.Material or Enum.Material.Plastic
end
return hitPart, hitPos
end
if saOrig then return saOrig(self, ...) end
end))
end)
if not (okSa and type(saOrig) == "function") then return end
F._saUnifiedOld = saOrig
F._saUnifiedHooked = true
print("[CheatMenu] 统一静默自瞄已开启")
end
function F.SilentAimUnifiedDisable()
if F._saUnifiedHooked and hookmetamethod and F._saUnifiedOld then
pcall(function() hookmetamethod(game, "__namecall", F._saUnifiedOld) end)
end
F._saUnifiedHooked = false
F._saUnifiedOld = nil
end
local SingleAimConn = nil
local function SingleAimDisable() if SingleAimConn then SingleAimConn:Disconnect() SingleAimConn = nil end end
local function SingleAimEnable()
if SingleAimConn then return end
SingleAimConn = RS.RenderStepped:Connect(function()
if not T.SingleAim then return end
local name = Fluent.Options.TPTarget and Fluent.Options.TPTarget.Value
local target = name and Players:FindFirstChild(name)
if not (target and target.Character) then return end
local hrp = target.Character:FindFirstChild("HumanoidRootPart")
if hrp then workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, hrp.Position) end
end)
end
local FaceLockConn = nil
local function FaceLockDisable() if FaceLockConn then FaceLockConn:Disconnect() FaceLockConn = nil end end
local function FaceLockEnable()
if FaceLockConn then return end
FaceLockConn = RS.RenderStepped:Connect(function()
if not T.FaceLock then return end
local name = Fluent.Options.TPTarget and Fluent.Options.TPTarget.Value
local target = name and Players:FindFirstChild(name)
local _, _, r = GC()
if not (target and target.Character and r) then return end
local hrp = target.Character:FindFirstChild("HumanoidRootPart")
if hrp then r.CFrame = CFrame.lookAt(r.Position, Vector3.new(hrp.Position.X, r.Position.Y, hrp.Position.Z)) end
end)
end
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
if not T.Invisible then return end
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
ESPGui.Name = "CheatMenu_ESP"
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
print("[CheatMenu] 骨骼线: 使用 Drawing API (" .. #F._skeletonDrawings .. " 条)")
return
end
if F._skeletonDrawings then
for _, item in ipairs(F._skeletonDrawings) do pcall(function() item.drawing:Remove() end) end
F._skeletonDrawings = nil
end
end
local sg = Instance.new("ScreenGui")
sg.Name = "CheatMenu_Skeleton"
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
bb.Name = "CheatArrow"
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
local n = v.Name:lower()
if v:IsA("BasePart") and (n:find("trap") or n:find("mine") or n:find("spike") or n:find("sentry")) then
local hl = Instance.new("Highlight")
hl.FillColor = Color3.fromRGB(255, 60, 60)
hl.FillTransparency = 0.3
hl.OutlineColor = Color3.fromRGB(255, 0, 0)
hl.Parent = v
F._trapHls[#F._trapHls + 1] = hl
end
end
end
function F.TrapsESPDisable()
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
if not T.KillAura then return end
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
if not T.AntiKnockdown then return end
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
function F.AntiAimEnable()
if F._antiAimConn then return end
F._antiAimConn = RS.RenderStepped:Connect(function()
if not T.AntiAim then return end
local _, _, root = GC()
if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(C.AntiAimSpeed or 30), 0) end
end)
end
function F.AntiAimDisable()
if F._antiAimConn then F._antiAimConn:Disconnect() F._antiAimConn = nil end
end
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
print("[CheatMenu] ⚠ AuthorityMode=Server: 位移/速度由服务端权威裁决, 飞行/加速命中率会明显下降")
end
return mode, srv
end
function F.Jitter(base)
local j = tonumber(C.MoveJitter) or 20
if j <= 0 then return base end
return base * (1 - j / 100 + math.random() * (2 * j / 100))
end
function F.FlyHeightCap(root, baseY)
local maxH = tonumber(C.FlyMaxHeight) or 400
if maxH <= 0 or not baseY then return false end
if root.Position.Y - baseY > maxH then
local cf = root.CFrame
root.CFrame = CFrame.new(Vector3.new(cf.Position.X, baseY + maxH, cf.Position.Z)) * (cf - cf.Position)
return true
end
return false
end
local FlyConn = nil
local function FlyDisable()
if FlyConn then FlyConn:Disconnect() FlyConn = nil end
local _, hum = GC()
if hum then hum.PlatformStand = false end
F._flyBaseY = nil
end
local function FlyEnable()
local _, hum, root = GC()
if not (hum and root) then return end
FlyDisable()
pcall(F.AuthorityGuard, true)
hum.PlatformStand = true
F._flyBaseY = root.Position.Y
FlyConn = RS.RenderStepped:Connect(function(dt)
if not T.Fly then FlyDisable() return end
local _, h, r = GC()
if not (h and r) then return end
local cam = workspace.CurrentCamera
local dir = Vector3.zero
if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
local moved = false
if dir.Magnitude > 0 then
local sp = math.min(C.FlySpeed or 50, 1000) * math.min(dt, 0.1)
sp = F.Jitter(sp)
r.CFrame = r.CFrame + (dir.Unit * sp)
moved = true
end
F.FlyHeightCap(r, F._flyBaseY)
if T.FlyVelSpoof ~= false then
local cap = math.min(math.min(C.FlySpeed or 50, 1000), 60)
local want = moved and (dir.Unit * cap) or Vector3.zero
r.AssemblyLinearVelocity = r.AssemblyLinearVelocity:Lerp(want, 0.5)
else
r.AssemblyLinearVelocity = Vector3.zero
end
r.AssemblyAngularVelocity = Vector3.zero
end)
end
local FlyBv, FlyBg, FlyBvConn = nil, nil, nil
function F.FlyPhysDisable()
if FlyBvConn then FlyBvConn:Disconnect() FlyBvConn = nil end
if FlyBv then pcall(function() FlyBv:Destroy() end) FlyBv = nil end
if FlyBg then pcall(function() FlyBg:Destroy() end) FlyBg = nil end
local _, hum = GC()
if hum then pcall(function() hum.PlatformStand = false end) end
end
function F.FlyPhysEnable()
local _, hum, root = GC()
if not (hum and root) then return end
F.FlyPhysDisable()
pcall(F.AuthorityGuard, true)
hum.PlatformStand = true
F._flyBaseY = root.Position.Y
FlyBv = Instance.new("BodyVelocity")
FlyBv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
FlyBv.Velocity = Vector3.zero
FlyBv.Parent = root
FlyBg = Instance.new("BodyGyro")
FlyBg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
FlyBg.P = 1e4
FlyBg.Parent = root
if FlyBvConn then FlyBvConn:Disconnect() end
FlyBvConn = RS.RenderStepped:Connect(function()
if not T.FlyPhys then F.FlyPhysDisable() return end
local _, _, r = GC()
if not r or not FlyBv then return end
local cam = workspace.CurrentCamera
local dir = Vector3.zero
if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
local spd = F.Jitter(C.FlySpeed or 50)
local targetVel = dir.Unit * spd * (dir.Magnitude > 0 and 1 or 0)
FlyBv.Velocity = FlyBv.Velocity:Lerp(targetVel, 0.35)
FlyBg.CFrame = cam.CFrame
F.FlyHeightCap(r, F._flyBaseY)
end)
end
local SpeedConn, SpeedConn2, baseWalk
local function SpeedDisable()
if SpeedConn then SpeedConn:Disconnect() SpeedConn = nil end
if SpeedConn2 then SpeedConn2:Disconnect() SpeedConn2 = nil end
local _, hum = GC()
if hum and baseWalk then hum.WalkSpeed = baseWalk end
baseWalk = nil
end
local function SpeedEnable()
if SpeedConn then return end
local function apply(dt, doOffset)
if not T.Speed then return end
local _, hum, root = GC()
if hum then
if not baseWalk then baseWalk = hum.WalkSpeed or 16 end
C._baseWalk = baseWalk
local target = baseWalk * (C.SpeedMul or 2)
local WALK_CAP = 200
local walk = math.min(target, WALK_CAP)
local cur = hum.WalkSpeed
if math.abs(cur - walk) > 2 then
pcall(function() hum.WalkSpeed = cur + (cur < walk and 2 or -2) end)
else
pcall(function() hum.WalkSpeed = walk end)
end
if doOffset and root and target > WALK_CAP and hum.MoveDirection.Magnitude > 0.1 then
local extra = (target - WALK_CAP) * math.min(dt or 1/60, 0.1)
pcall(function() root.CFrame = root.CFrame + hum.MoveDirection * extra end)
end
end
end
apply(nil, false)
SpeedConn = RS.Stepped:Connect(function(t, dt) apply(dt, true) end)
SpeedConn2 = RS.RenderStepped:Connect(function(dt) apply(dt, false) end)
end
function F.SpeedCFrameEnable()
if F._speedCConn then return end
F._speedCLeft = 0
pcall(F.AuthorityGuard, true)
F._speedCConn = RS.RenderStepped:Connect(function(dt)
if not T.SpeedCFrame then F._speedCLeft = 0 return end
local _, hum, root = GC()
if not (hum and root) then return end
dt = math.min(dt, 0.1)
local mult = math.max(1, tonumber(C.SpeedCFrameMul) or 2)
local md = hum.MoveDirection
if md.Magnitude < 0.01 then F._speedCLeft = 0 return end
if T.SpeedCFrameGroundOnly ~= false and hum.FloorMaterial == Enum.Material.Air then
F._speedCLeft = 0
return
end
local maxPerFrame = math.clamp(tonumber(C.SpeedCFrameStep) or 4, 0.5, 16)
maxPerFrame = math.max(0.5, F.Jitter(maxPerFrame))
local want = 16 * mult * dt + (F._speedCLeft or 0)
local move = math.min(want, maxPerFrame)
F._speedCLeft = want - move
if move <= 0 then return end
local subs = math.max(1, math.ceil(move / 2))
local per = move / subs
local cf = root.CFrame
for _ = 1, subs do cf = cf + md.Unit * per end
root.CFrame = cf
end)
end
function F.SpeedCFrameDisable()
if F._speedCConn then F._speedCConn:Disconnect() F._speedCConn = nil end
F._speedCLeft = 0
end
function F.DesyncSpeedEnable()
if AC._desyncOn then return end
AC._desyncOn = true
pcall(F.AuthorityGuard, true)
AC._desyncLoc = CFrame.new()
AC._desyncOffset = Vector3.new(
tonumber(C.DesyncSide) or 0,
-(tonumber(C.DesyncOffset) or 5),
0)
AC._desyncConn = RS.Heartbeat:Connect(function()
if not AC._desyncOn or not T.DesyncSpeed then return end
AC._desyncOffset = Vector3.new(
tonumber(C.DesyncSide) or 0,
-(tonumber(C.DesyncOffset) or 5),
0)
local ch = LP.Character
local root = ch and ch:FindFirstChild("HumanoidRootPart")
if not root then return end
AC._desyncLoc = root.CFrame
local fakePos = AC._desyncLoc.Position + AC._desyncOffset
root.CFrame = CFrame.new(fakePos, fakePos + AC._desyncLoc.LookVector)
pcall(function()
RS:UnbindFromRenderStep("CMDesyncRevert")
end)
pcall(function()
RS:BindToRenderStep("CMDesyncRevert", Enum.RenderPriority.Camera.Value + 1, function()
RS:UnbindFromRenderStep("CMDesyncRevert")
if root.Parent then pcall(function() root.CFrame = AC._desyncLoc end) end
end)
end)
end)
local old
old = hookmetamethod(game, "__index", newcclosure(function(self, key)
if AC._desyncOn and T.DesyncSpeed and not checkcaller() and key == "CFrame" then
local ch = LP.Character
local root = ch and ch:FindFirstChild("HumanoidRootPart")
if root and self == root then return AC._desyncLoc end
end
return old(self, key)
end))
AC._desyncHookOld = old
AC._desyncHook = true
end
function F.DesyncSpeedDisable()
AC._desyncOn = false
if AC._desyncConn then pcall(function() AC._desyncConn:Disconnect() end) AC._desyncConn = nil end
pcall(function() RS:UnbindFromRenderStep("CMDesyncRevert") end)
if AC._desyncHook and AC._desyncHookOld and hookmetamethod then
pcall(function() hookmetamethod(game, "__index", AC._desyncHookOld) end)
end
AC._desyncHook = nil
AC._desyncHookOld = nil
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
function F.SpinDisable() if F.SpinConn then F.SpinConn:Disconnect() F.SpinConn = nil end end
function F.SpinEnable()
if F.SpinConn then return end
F.SpinConn = RS.RenderStepped:Connect(function()
if not T.Spin then return end
local _, _, r = GC()
if r then r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(C.SpinSpeed or 10), 0) end
end)
end
F.AirWalkConn = nil
function F.AirWalkDisable() if F.AirWalkConn then F.AirWalkConn:Disconnect() F.AirWalkConn = nil end end
function F.AirWalkEnable()
if F.AirWalkConn then return end
F.AirWalkConn = RS.RenderStepped:Connect(function(dt)
if not T.AirWalk then return end
local _, hum, r = GC()
if not (hum and r) then return end
if hum.FloorMaterial ~= Enum.Material.Air then return end
local cam = workspace.CurrentCamera
local dir = Vector3.zero
if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
if dir.Magnitude > 0 then r.CFrame = r.CFrame + dir.Unit * (C.AirWalkSpeed or 30) * math.min(dt, 0.1) end
end)
end
F.NoClipConn = nil
F.NoClipParts = {}
function F.NoClipDisable()
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
if not T.Hide then return end
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
local seg = math.max(3, tonumber(C.TPSmoothSeg) or 8)
for i = 1, seg do
local t = i / seg
local eased = (t < 0.5) and (2 * t * t) or (1 - ((-2 * t + 2) ^ 2) / 2)
root.CFrame = start:Lerp(targetCF, eased)
task.wait(0.012)
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
if not T.AntiVoid then return end
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
F._flyStealthThread = nil
function F.FlyStealthEnable()
if F._flyStealthThread then return end
T.FlyStealth = true
if (C.FlySpeed or 50) > 80 then C.FlySpeed = 80 end
F._flyStealthThread = task.spawn(function()
while T.FlyStealth do
if T.Fly or T.FlyPhys then
local _, _, root = GC()
if root then
pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, -25, 0) end)
task.wait(0.12)
pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
end
end
task.wait(1)
end
F._flyStealthThread = nil
end)
end
function F.FlyStealthDisable()
T.FlyStealth = false
F._flyStealthThread = nil
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
if not T.Clicker then return end
if type(mouse1click) == "function" then mouse1click()
elseif type(mouse1press) == "function" then mouse1press() task.wait(0.01) mouse1release() end
end)
end
local FlyCarConn = nil
local function FlyCarDisable() if FlyCarConn then FlyCarConn:Disconnect() FlyCarConn = nil end end
local function FlyCarEnable()
if FlyCarConn then return end
FlyCarConn = RS.RenderStepped:Connect(function(dt)
if not T.FlyCar then return end
local _, _, root = GC()
if not root then return end
local seat = root.Parent
if not (seat and (seat:IsA("VehicleSeat") or seat:IsA("Seat"))) then
if os.clock() - (F._flyCarSeekAt or 0) > 0.5 then
F._flyCarSeekAt = os.clock()
seat = nil
for _, s in ipairs(workspace:GetDescendants()) do
if (s:IsA("VehicleSeat") or s:IsA("Seat")) and s.Occupant == LP.Character then seat = s break end
end
F._flyCarSeat = seat
else seat = F._flyCarSeat end
else F._flyCarSeat = seat end
if not seat then return end
local car = seat.Parent
local body = car and (car:IsA("Model") and car.PrimaryPart or (car:IsA("BasePart") and car))
if not body then return end
local cam = workspace.CurrentCamera
local dir = Vector3.zero
if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
if dir.Magnitude > 0 then body.CFrame = body.CFrame + dir.Unit * (C.FlyCarSpeed or 50) * math.min(dt, 0.1) end
end)
end
local XrayHls = {}
local function XrayDisable()
for _, hl in ipairs(XrayHls) do pcall(function() hl:Destroy() end) end
XrayHls = {}
end
local function XrayEnable()
local ch = LP.Character
for _, obj in ipairs(workspace:GetDescendants()) do
if obj:IsA("BasePart") and ch and not obj:IsDescendantOf(ch) then
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
SelfGlowHl.FillTransparency = 0.3
SelfGlowHl.OutlineColor = Color3.fromRGB(255, 255, 255)
SelfGlowHl.Parent = ch
end
local function MuteEnable()
for _, s in ipairs(workspace:GetDescendants()) do
if s:IsA("Sound") then s.Volume = 0 end
end
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
local function ServerHop()
pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end)
end
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
ToolGlowHl.FillTransparency = 0.4
ToolGlowHl.OutlineColor = Color3.fromRGB(255, 255, 255)
ToolGlowHl.Parent = tool
end
local AutoInteractConn = nil
local InstantPromptConn = nil
local function AutoInteractDisable() if AutoInteractConn then AutoInteractConn:Disconnect() AutoInteractConn = nil end end
local function AutoInteractEnable()
if AutoInteractConn then return end
AutoInteractConn = RS.Stepped:Connect(function()
if not T.AutoInteract then return end
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
end
end
end)
end
local function InstantPromptEnable()
local function maxOut(p)
if not (p and p:IsA("ProximityPrompt")) then return end
p.HoldDuration = 0
pcall(function() p.MaxActivationDistance = math.huge end)
pcall(function() p.RequiresLineOfSight = false end)
pcall(function() p.Cooldown = 0 end)
end
for _, p in ipairs(workspace:GetDescendants()) do maxOut(p) end
if not InstantPromptConn then
InstantPromptConn = workspace.DescendantAdded:Connect(function(d) maxOut(d) end)
end
end
local function BadgeBypassEnable()
if not hookfunction then return end
pcall(function()
local bs = game:GetService("BadgeService")
hookfunction(bs.UserHasBadgeAsync, function() return true end)
hookfunction(bs.UserOwnsBadgeAsync, function() return true end)
end)
pcall(function()
local gs = game:GetService("GroupService")
hookfunction(gs.IsInGroup, function() return true end)
end)
end
local function MetaBypassEnable()
if not (getgc and islclosure) then return end
local function wipeMeta(v) if type(v) == "userdata" then pcall(function() setmetatable(v, nil) end) end end
local function findAndWipe(kw)
for _, v in ipairs(F.GuardedGetGC(true, true)) do
if type(v) == "function" and islclosure(v) then
local ok, info = pcall(debug.getinfo, v, "n")
if ok and info and info.name and info.name:lower():find(kw, 1, true) then
for i = 1, 20 do
local n, uv = debug.getupvalue(v, i)
if not n then break end
wipeMeta(uv)
if type(uv) == "table" then for _, sub in pairs(uv) do wipeMeta(sub) end end
end
end
end
end
end
for _, kw in ipairs({ "anti", "detect", "ban", "cheat", "flag" }) do findAndWipe(kw) end
end
local function ChatBypassEnable()
if not hookfunction then return end
local tcs = game:GetService("TextChatService")
if not (tcs and tcs.TextChannels) then return end
for _, channel in ipairs(tcs.TextChannels:GetChildren()) do
if channel:IsA("TextChannel") and channel.SendAsync then
local sendFn = channel.SendAsync
local origSend
pcall(function()
origSend = hookfunction(sendFn, function(self, text, ...)
if T.ChatBypass and type(text) == "string" then
text = text:gsub("(.)", "%1\226\128\139")
end
if origSend then return origSend(self, text, ...) end
end)
end)
if type(origSend) == "function" then AC.markHooked(sendFn) end
end
end
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
box.Name = "CheatHitbox"
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
local function FOVDisable() workspace.CurrentCamera.FieldOfView = 70 end
local function ZoomEnable()
LP.CameraMaxZoomDistance = C.Zoom or 400
LP.CameraMinZoomDistance = 0.5
end
local function ZoomDisable()
LP.CameraMaxZoomDistance = 128
LP.CameraMinZoomDistance = 0.5
end
local LockHealthConn = nil
local function LockHealthDisable() if LockHealthConn then LockHealthConn:Disconnect() LockHealthConn = nil end end
local function LockHealthEnable()
if LockHealthConn then return end
LockHealthConn = RS.Heartbeat:Connect(function()
if not T.LockHealth then return end
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
if not T.Regen then return end
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
if not T.StealthGod then return end
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
if not T.NoDeath then return end
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
if not T.AntiSit then return end
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
if not T.AntiAnchor then return end
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
if not T.CharPersist then return end
task.wait(0.2)
if T.Speed then pcall(SpeedEnable) end
if T.SpeedBypass then pcall(F.SpeedBypassEnable) end
if T.SpeedCFrame then pcall(F.SpeedCFrameEnable) end
if T.Fly then pcall(FlyEnable) end
if T.FlyPhys then pcall(F.FlyPhysEnable) end
if T.NoClip then pcall(F.NoClipEnable) end
if T.God then pcall(GodEnable) end
if T.StealthGod then pcall(StealthGodEnable) end
if T.LockHealth then pcall(LockHealthEnable) end
if T.Invisible then pcall(InvisibleEnable) end
if T.AntiRagdoll then pcall(F.AntiRagdollEnable) end
if T.InfiniteJump then pcall(F.InfiniteJumpEnable) end
if T.AntiSit then pcall(F.AntiSitEnable) end
if T.AntiAnchor then pcall(F.AntiAnchorEnable) end
if T.ESP then pcall(ESPEnable) end
end
function F.CharPersistEnable() T.CharPersist = true end
function F.CharPersistDisable() T.CharPersist = false end
function F.SpeedBypassEnable()
AC.InstallPropertyLock()
AC.InstallIndexMask()
T.SpeedMask = true
T.Speed = true
SpeedEnable()
end
function F.SpeedBypassDisable()
T.Speed = false
T.SpeedMask = false
SpeedDisable()
pcall(AC.UninstallIndexMask)
end
function F.ProtectGui()
local targets = {}
pcall(function() if Fluent and Fluent.GUI then table.insert(targets, Fluent.GUI) end end)
pcall(function()
for _, g in ipairs(CoreGui:GetChildren()) do
if g.Name:find("CheatMenu") or g.Name:find("Fluent") then table.insert(targets, g) end
end
end)
for _, sg in ipairs(targets) do
pcall(function() if syn and syn.protect_gui then syn.protect_gui(sg) end end)
pcall(function() if protect_gui then protect_gui(sg) end end)
end
end
F._guiProtConn = nil
F._guiProtQueue = false
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
if not (n:find("CheatMenu") or n:find("Fluent")) then return end
if F._guiProtQueue then return end
F._guiProtQueue = true
task.delay(0.5, function()
F._guiProtQueue = false
print("[CheatMenu] 检测到 GUI 被移除(" .. n .. "), 正在重建...")
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
sg.Name = "CheatMenu_HUD"
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
sg.Name = "CheatMenu_Cross"
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
local sg = Instance.new("ScreenGui")
sg.Name = "CheatMenu_FOV"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.Parent = CoreGui
local circle = Instance.new("Frame")
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.Position = UDim2.fromScale(0.5, 0.5)
circle.BackgroundTransparency = 1
circle.BorderSizePixel = 0
circle.Size = UDim2.fromOffset(400, 400)
circle.Parent = sg
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = circle
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 255, 120)
stroke.Thickness = 1
stroke.Transparency = 0.35
stroke.Parent = circle
F._fovGui = sg
F._fovConn = RS.RenderStepped:Connect(function()
local fov = C.AimFOV or 200
circle.Size = UDim2.fromOffset(fov * 2, fov * 2)
end)
end
function F.FovCircleDisable()
if F._fovConn then F._fovConn:Disconnect() F._fovConn = nil end
if F._fovGui then F._fovGui:Destroy() F._fovGui = nil end
end
F._freecamConn = nil
function F.FreecamEnable()
if F._freecamConn then return end
local cam = workspace.CurrentCamera
if not cam then return end
F._freecamSaved = { Type = cam.CameraType, Subject = cam.CameraSubject }
local cf = cam.CFrame
local yaw = math.atan2(-cf.LookVector.X, -cf.LookVector.Z)
local pitch = math.asin(math.clamp(cf.LookVector.Y, -1, 1))
cam.CameraType = Enum.CameraType.Scriptable
pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.LockCenter end)
F._freecamConn = RS.RenderStepped:Connect(function(dt)
if not T.Freecam then F.FreecamDisable() return end
local c = workspace.CurrentCamera
if not c then return end
if c.CameraType ~= Enum.CameraType.Scriptable then c.CameraType = Enum.CameraType.Scriptable end
if UIS.MouseBehavior ~= Enum.MouseBehavior.LockCenter then pcall(function() UIS.MouseBehavior = Enum.MouseBehavior.LockCenter end) end
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
if not T.FreezePlayer then return end
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
if not F._hidePlConns then F._hidePlConns = {} end
if not F._hidePlConns[pl] then
F._hidePlConns[pl] = pl.CharacterAdded:Connect(function(nch)
task.wait(0.3)
if not F._hiddenPlayers[pl] then return end
for _, d in ipairs(nch:GetDescendants()) do
if d:IsA("BasePart") then d.LocalTransparencyModifier = 1 end
end
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
if not T.BringPlayer then return end
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
local function hook(h)
local hum = h and h:FindFirstChildOfClass("Humanoid")
if hum then
hum.Died:Connect(function()
local _, _, r = GC()
if r then F._lastDeathCF = r.CFrame end
end)
end
end
hook(LP.Character)
F._flashConn = LP.CharacterAdded:Connect(function(h) task.wait(0.3) hook(h) end)
end
function F.FlashbackDisable()
if F._flashConn then F._flashConn:Disconnect() F._flashConn = nil end
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
if not T.Swim then return end
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
if not T.LockCam then return end
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
T.Fly = not T.Fly
if T.Fly then FlyEnable() else FlyDisable() end
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
for k in pairs(T) do T[k] = false end
for k, v in pairs(keep) do T[k] = v end
for _, fn in ipairs({ FlyDisable, SpeedDisable, ESPDisable, AimDisable, SilentAimDisable, SilentAimGhostDisable, InvisibleDisable, GodDisable, SingleAimDisable, FaceLockDisable, HitboxDisable, FOVDisable, ZoomDisable, AntilagDisable, FlyCarDisable, XrayDisable, SelfGlowDisable, BulletTracerDisable, AutoInteractDisable, LockHealthDisable, RegenDisable, StealthGodDisable, NoDeathDisable }) do pcall(fn) end
for _, fn in ipairs({ F.FlyPhysDisable, F.SpeedCFrameDisable, F.HudDisable, F.CrosshairDisable, F.FovCircleDisable, F.FreecamDisable, F.FreezePlayerDisable, F.HidePlayerDisable, F.KillAuraDisable, F.AntiRagdollDisable, F.AntiKnockdownDisable, F.SilentAimMouseDisable, F.SilentAimUnifiedDisable, F.AntiSitDisable, F.AntiAnchorDisable, F.AntiAimDisable, F.DesyncSpeedDisable, F.HitboxExpandDisable, F.AntiVoidDisable, F.SkeletonDisable, F.ArrowDisable, F.TrapsESPDisable, F.ChamsDisable, F.NoClipDisable, F.HideDisable, F.InfiniteJumpDisable, F.SpinDisable, F.AirWalkDisable, F.ClickerDisable, F.FullBrightDisable, F.NightVisionDisable, F.NoFogDisable, F.ItemMagnetDisable }) do pcall(fn) end
for _, fn in ipairs({ AC.UninstallNamecallHook, AC.UninstallIndexMask, AC.UnblockRemotes, AC.UninstallAntiTP, AC.UninstallPropertyLock, AC.UninstallSetmetatableHook, AC.WatchNewScriptsDisable, AC.WatchNewRemotesDisable, AC.AntiPauseDisable, AC.TrapDisable.Disable, F.CaptureDisable }) do pcall(fn) end
pcall(function()
local _, hum = GC()
if hum then
hum.WalkSpeed = C._baseWalk or 16
hum.JumpPower = 50
pcall(function() hum.UseJumpPower = true end)
pcall(function() hum.JumpHeight = 7.5 end)
local mh = hum.MaxHealth
if type(mh) ~= "number" or mh > 1000 or mh ~= mh then
hum.MaxHealth = 100
end
hum.Health = math.min(hum.Health, hum.MaxHealth)
hum.PlatformStand = false
pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
end
local cam = workspace.CurrentCamera
if cam then cam.FieldOfView = 70 end
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
print("[CheatMenu] Panic: 全部功能已关闭, 属性/外观/连接已恢复")
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
F._magnetConn = RS.Heartbeat:Connect(function()
if not T.ItemMagnet then return end
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
if nodes < 4000 and (ch2:IsA("Folder") or ch2:IsA("Model")) then
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
local origSpy
local okSpy = pcall(function()
origSpy = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
local method = type(getnamecallmethod) == "function" and getnamecallmethod() or ""
if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
if not checkcaller() then
print(string.format("[流量] %s:%s", tostring(self.Name), method))
end
end
if origSpy then return origSpy(self, ...) end
end))
end)
if not (okSpy and type(origSpy) == "function") then return end
F._spyOld = prev
F._spyOrig = origSpy
F._spyHooked = true
AC.markHooked(prev)
F._remoteDownConns = {}
pcall(function()
for _, d in ipairs(RStorage:GetDescendants()) do
if AC.isRemoteLike(d) then
local conn = d.OnClientEvent:Connect(function(...)
if T.RemoteSpy then print(string.format("[下行] %s", d.Name)) end
end)
F._remoteDownConns[#F._remoteDownConns + 1] = conn
end
end
end)
end
function F.RemoteSpyDisable()
if not F._spyHooked then return end
pcall(function()
if hookmetamethod and F._spyOrig then hookmetamethod(game, "__namecall", F._spyOrig) end
end)
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
print("[CheatMenu] === 连接诊断 ===")
if type(getconnections) == "function" then
for name, ev in pairs({ ["RenderStepped"] = RS.RenderStepped, ["Heartbeat"] = RS.Heartbeat, ["Stepped"] = RS.Stepped }) do
local ok, conns = pcall(getconnections, ev)
print(string.format("  %s: %d", name, (ok and type(conns) == "table") and #conns or 0))
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
function Trans.Translate(text, force) return nil end
local function UnloadAll()
for k in pairs(T) do T[k] = false end
local disables = {
F.KickGuardDisable, F.AntiFlingDisable, F.AntiRagdollDisable, F.AntiKnockdownDisable,
F.SpeedCFrameDisable, F.FlyStealthDisable, F.FreecamDisable, F.FreezePlayerDisable,
F.HidePlayerDisable, F.HudDisable, F.CrosshairDisable, F.FovCircleDisable,
F.PanicKeyDisable, F.DupeAttemptDisable, F.ItemMagnetDisable, F.ChamsDisable,
F.BringPlayerDisable, F.KeybindDisable, F.LockCamDisable, F.SwimDisable,
F.FlashbackDisable, F.RemoteSpyDisable, F.SilentAimMouseDisable,
F.SilentAimUnifiedDisable, F.AntiSitDisable, F.AntiAnchorDisable,
F.CharPersistDisable, F.LivePlayersDisable, F.AutoSaveDisable, F.AntiAimDisable,
F.DesyncSpeedDisable, F.TrapsESPDisable, F.SkeletonDisable, F.ArrowDisable,
F.ClickTPDisable, F.AntiVoidDisable, F.AntiAFKDisable,
AC.WatchNewRemotesDisable, AC.WatchNewScriptsDisable, AC.TrapDisable.Disable,
AC.UnblockRemotes, AC.UninstallAntiTP, AC.AntiPauseDisable, AC.UninstallIndexMask,
AC.UninstallPropertyLock, AC.UninstallSetmetatableHook, AC.UninstallNamecallHook,
F.UnspoofGCMetadata,
F.StealthDisable, F.GuiProtectionDisable, F.HitboxExpandDisable, F.AntiVoidDisable,
F.CaptureDisable,
F.NoClipDisable, ESPDisable, AutoInteractDisable,
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
print("[CheatMenu] 已干净卸载")
end
local function RestoreFeatures()
if T.KickProtect or T.AntiAFK then F.AntiAFKEnable() F.KickGuardEnable() F.KickRejoinEnable() end
if T.AutoBonus then F.AutoBonusEnable() end
if T.AutoGym then F.AutoGymEnable() end
if T.AutoTrain then F.AutoTrainEnable() end
if T.NamecallHook then AC.InstallNamecallHook() end
if T.RemoteBlock then AC.InstallNamecallHook() end
if T.AntiFling then F.AntiFlingEnable() end
if T.UniversalAC then AC.InstallPropertyLock() end
if T.PropertyLock then AC.InstallPropertyLock() end
if T.ACIndexHook or T.SpeedMask then AC.InstallIndexMask() end
if T.ACBypass then pcall(AC.InstallSetmetatableHook) pcall(F.SpoofGCMetadata) end
if T.StealthMode then pcall(F.StealthEnable) end
if T.GuiProtect then pcall(F.GuiProtectionEnable) end
if T.AntiTP then AC.InstallAntiTP() end
if T.AntiPause then AC.AntiPauseEnable() end
if T.NoClip then F.NoClipEnable() end
if T.Antilag then AntilagEnable() end
if T.Speed then pcall(SpeedEnable) end
if T.SpeedBypass then F.SpeedBypassEnable() end
if T.SpeedCFrame then F.SpeedCFrameEnable() end
if T.DesyncSpeed then F.DesyncSpeedEnable() end
if T.Fly then pcall(FlyEnable) end
if T.FlyPhys then pcall(F.FlyPhysEnable) end
if T.God then pcall(GodEnable) end
if T.StealthGod then pcall(StealthGodEnable) end
if T.ESP then pcall(ESPEnable) end
if T.Invisible then pcall(InvisibleEnable) end
if T.AntiSit then pcall(F.AntiSitEnable) end
if T.AntiAnchor then pcall(F.AntiAnchorEnable) end
if T.AntiAim then pcall(F.AntiAimEnable) end
if T.CharPersist ~= false then T.CharPersist = true end
if T.AutoSave ~= false then F.AutoSaveEnable() end
F.LivePlayersEnable()
end
LoadConfig()
local Window = Fluent:CreateWindow({
Title = "CheatMenu",
SubTitle = "v6.10.0",
TabWidth = 100,
Size = UDim2.fromOffset(500, 540),
Acrylic = false,
Theme = "Aqua",
MinimizeKey = Enum.KeyCode.G,
})
if getgenv then getgenv().CM_Window = Window end
pcall(function() Fluent:ToggleTransparency(true) end)
local function buildMenu()
local Tabs = {
Combat  = Window:AddTab({ Title = "战斗", Icon = "crosshair" }),
Move    = Window:AddTab({ Title = "移动", Icon = "move" }),
World   = Window:AddTab({ Title = "视觉", Icon = "globe" }),
TP      = Window:AddTab({ Title = "传送", Icon = "map-pin" }),
AFK     = Window:AddTab({ Title = "挂机", Icon = "home" }),
AC      = Window:AddTab({ Title = "反作弊", Icon = "shield" }),
Setting = Window:AddTab({ Title = "设置", Icon = "settings" }),
}
do
Tabs.Combat:AddSection("战斗")
Tabs.Combat:AddDropdown("AimMode", { Title = "自瞄模式(6合1)", Values = {
"关闭", "自瞄(镜头锁定)", "静默自瞄(硬锁)",
"静默自瞄·无痕(观战看不出)", "静默自瞄·鼠标(镜头不动)",
"统一静默自瞄(多方法·推荐)",
}, Default = "关闭", Callback = function(v)
T.Aim = (v == "自瞄(镜头锁定)")
T.SilentAim = (v == "静默自瞄(硬锁)")
T.SilentAimGhost = (v == "静默自瞄·无痕(观战看不出)")
T.SilentAimMouse = (v == "静默自瞄·鼠标(镜头不动)")
T.SilentAimUnified = (v == "统一静默自瞄(多方法·推荐)")
AimDisable() SilentAimDisable() SilentAimGhostDisable()
pcall(F.SilentAimMouseDisable) pcall(F.SilentAimUnifiedDisable)
if T.Aim then AimEnable()
elseif T.SilentAim then SilentAimEnable()
elseif T.SilentAimGhost then SilentAimGhostEnable()
elseif T.SilentAimMouse then F.SilentAimMouseEnable()
elseif T.SilentAimUnified then F.SilentAimUnifiedEnable() end
end })
Tabs.Combat:AddSlider("SilentAimChance", { Title = "静默自瞄命中率(%)", Min = 0, Max = 100, Default = 100, Rounding = 0, Callback = function(v) F.SilentAimChance = v end })
Tabs.Combat:AddToggle("TriggerBot", { Title = "开火才锁", Default = false, Callback = function(v) T.TriggerBot = v end })
Tabs.Combat:AddToggle("AimPrediction", { Title = "弹道预测", Default = false, Callback = function(v) T.AimPrediction = v end })
Tabs.Combat:AddSlider("AimFOV", { Title = "自瞄范围", Min = 50, Max = 500, Default = 200, Rounding = 0, Callback = function(v) C.AimFOV = v end })
Tabs.Combat:AddToggle("FovCircle", { Title = "FOV 圈", Default = false, Callback = function(v) T.FovCircle = v if v then F.FovCircleEnable() else F.FovCircleDisable() end end })
Tabs.Combat:AddSlider("AimSmooth", { Title = "平滑度(越大越慢)", Min = 1, Max = 20, Default = 5, Rounding = 0, Callback = function(v) C.AimSmooth = v end })
Tabs.Combat:AddToggle("AimTeamCheck", { Title = "忽略队友", Default = true, Callback = function(v) T.AimTeamCheck = v F.SilentAimTeamCheck = v end })
Tabs.Combat:AddToggle("AimWallCheck", { Title = "墙壁检查", Default = true, Callback = function(v) T.AimWallCheck = v F.SilentAimWallCheck = v end })
Tabs.Combat:AddDropdown("PriorityTarget", { Title = "优先目标玩家", Values = F.PlayerNames(), Default = nil, Callback = function(v) if v and v ~= "(无人)" then F.AddPriorityTarget(v) end end })
Tabs.Combat:AddDropdown("BlacklistTarget", { Title = "黑名单玩家", Values = F.PlayerNames(), Default = nil, Callback = function(v) if v and v ~= "(无人)" then F.AddBlacklist(v) end end })
Tabs.Combat:AddButton({ Title = "清除优先级/黑名单", Callback = function() C.PriorityTargets = {} C.Blacklist = {} end })
Tabs.Combat:AddDropdown("AimExtra", { Title = "自瞄附加(2合1)", Values = { "无", "指定玩家(用传送目标)", "面锁(面向目标)" }, Default = "无", Callback = function(v)
T.SingleAim = (v == "指定玩家(用传送目标)")
T.FaceLock = (v == "面锁(面向目标)")
SingleAimDisable() FaceLockDisable()
if T.SingleAim then SingleAimEnable()
elseif T.FaceLock then FaceLockEnable() end
end })
Tabs.Combat:AddSection("生命保护")
Tabs.Combat:AddDropdown("GodMode", { Title = "生命保护(4合1)", Values = {
"关闭", "无敌(MaxHealth=∞)", "隐蔽无敌(锁满血)",
"锁血(指定值)", "防死亡+回血",
}, Default = "关闭", Callback = function(v)
T.God = (v == "无敌(MaxHealth=∞)")
T.StealthGod = (v == "隐蔽无敌(锁满血)")
T.LockHealth = (v == "锁血(指定值)")
T.NoDeath = (v == "防死亡+回血")
T.Regen = (v == "防死亡+回血")
GodDisable() StealthGodDisable() LockHealthDisable() NoDeathDisable() RegenDisable()
if T.God then GodEnable()
elseif T.StealthGod then StealthGodEnable()
elseif T.LockHealth then LockHealthEnable()
elseif T.NoDeath then NoDeathEnable() RegenEnable() end
end })
Tabs.Combat:AddSlider("LockHealthValue", { Title = "锁血值", Min = 1, Max = 1000, Default = 100, Rounding = 0, Callback = function(v) C.LockHealthValue = v end })
Tabs.Combat:AddSlider("RegenRate", { Title = "回血速度(每0.2秒)", Min = 1, Max = 100, Default = 10, Rounding = 0, Callback = function(v) C.RegenRate = v end })
Tabs.Combat:AddToggle("Invisible", { Title = "隐身", Default = false, Callback = function(v) T.Invisible = v if v then InvisibleEnable() else InvisibleDisable() end end })
Tabs.Combat:AddToggle("Hitbox", { Title = "碰撞箱(透明)", Default = false, Callback = function(v) T.Hitbox = v if v then HitboxEnable() else HitboxDisable() end end })
Tabs.Combat:AddDropdown("FlingTarget", { Title = "目标玩家(甩飞/冻结/拉取)", Values = F.PlayerNames(), Default = nil })
Tabs.Combat:AddButton({ Title = "甩飞选中玩家", Callback = function() F.FlingTarget() end })
Tabs.Combat:AddToggle("FreezePlayer", { Title = "冻结选中玩家(本地)", Default = false, Callback = function(v) T.FreezePlayer = v if v then F.FreezePlayerEnable() else F.FreezePlayerDisable() end end })
Tabs.Combat:AddToggle("HidePlayer", { Title = "本地隐藏选中玩家", Default = false, Callback = function(v) T.HidePlayer = v if v then F.HidePlayerEnable() else F.HidePlayerDisable() end end })
Tabs.Combat:AddToggle("BringPlayer", { Title = "拉选中玩家过来(本地)", Default = false, Callback = function(v) T.BringPlayer = v if v then F.BringPlayerEnable() else F.BringPlayerDisable() end end })
Tabs.Combat:AddDropdown("AntiRagdollMode", { Title = "防击倒(2合1)", Values = { "关闭", "反布娃娃", "防被撞飞", "全部开启" }, Default = "关闭", Callback = function(v)
T.AntiRagdoll = (v == "反布娃娃" or v == "全部开启")
T.AntiKnockdown = (v == "防被撞飞" or v == "全部开启")
F.AntiRagdollDisable() F.AntiKnockdownDisable()
if T.AntiRagdoll then F.AntiRagdollEnable() end
if T.AntiKnockdown then F.AntiKnockdownEnable() end
end })
Tabs.Combat:AddToggle("HitboxExpand", { Title = "Hitbox 扩展", Default = false, Callback = function(v) T.HitboxExpand = v if v then F.HitboxExpandEnable() else F.HitboxExpandDisable() end end })
Tabs.Combat:AddSlider("HitboxSize", { Title = "命中框大小", Min = 2, Max = 30, Default = 10, Rounding = 0, Callback = function(v) C.HitboxSize = v end })
Tabs.Combat:AddToggle("KillAura", { Title = "自动攻击(范围内敌人)", Default = false, Callback = function(v) T.KillAura = v if v then F.KillAuraEnable() else F.KillAuraDisable() end end })
Tabs.Combat:AddSlider("KillAuraRange", { Title = "自动攻击范围", Min = 5, Max = 100, Default = 20, Rounding = 0, Callback = function(v) C.KillAuraRange = v end })
Tabs.Combat:AddSlider("KillAuraSpeed", { Title = "自动攻击攻速(次/秒)", Min = 1, Max = 30, Default = 10, Rounding = 0, Callback = function(v) C.KillAuraSpeed = v end })
Tabs.Combat:AddToggle("AimPriorityNearest", { Title = "只打最近的目标", Default = false, Callback = function(v) T.AimPriorityNearest = v end })
Tabs.Combat:AddToggle("AntiAim", { Title = "Anti-Aim 反瞄准(旋转)", Default = false, Callback = function(v) T.AntiAim = v if v then F.AntiAimEnable() else F.AntiAimDisable() end end })
Tabs.Combat:AddSlider("AntiAimSpeed", { Title = "Anti-Aim 旋转速度", Min = 5, Max = 180, Default = 30, Rounding = 0, Callback = function(v) C.AntiAimSpeed = v end })
Tabs.Combat:AddSection("ESP 透视")
Tabs.Combat:AddToggle("ESP", { Title = "ESP 总开关", Default = false, Callback = function(v) T.ESP = v if v then ESPEnable() else ESPDisable() end end })
Tabs.Combat:AddDropdown("ESPStyle", { Title = "ESP 附加(11合1)", Values = {
"完整(框+名称+距离+血条)", "简洁(仅方框)", "带追踪线", "彩虹全开",
"骨骼线", "方向箭头", "Chams 材质透视", "子弹追踪",
"陷阱透视", "Xray 透视", "自发光",
}, Default = "完整(框+名称+距离+血条)", Callback = function(v)
T.ESPBox, T.ESPName, T.ESPDist, T.ESPHealth, T.ESPTracer, T.ESPRainbow = false, false, false, false, false, false
T.ESPSkeleton = false T.ESPArrow = false
T.Chams = false T.BulletTracer = false T.TrapsESP = false T.Xray = false T.SelfGlow = false
pcall(F.SkeletonDisable) pcall(F.ArrowDisable) pcall(F.ChamsDisable)
pcall(BulletTracerDisable) pcall(F.TrapsESPDisable)
pcall(XrayDisable) pcall(SelfGlowDisable)
if v == "完整(框+名称+距离+血条)" then
T.ESPBox, T.ESPName, T.ESPDist, T.ESPHealth = true, true, true, true
elseif v == "简洁(仅方框)" then T.ESPBox = true
elseif v == "带追踪线" then T.ESPBox, T.ESPName, T.ESPDist, T.ESPHealth, T.ESPTracer = true, true, true, true, true
elseif v == "彩虹全开" then T.ESPBox, T.ESPName, T.ESPDist, T.ESPHealth, T.ESPTracer, T.ESPRainbow = true, true, true, true, true, true
elseif v == "骨骼线" then T.ESPSkeleton = true F.SkeletonEnable()
elseif v == "方向箭头" then T.ESPArrow = true F.ArrowEnable()
elseif v == "Chams 材质透视" then T.Chams = true F.ChamsEnable()
elseif v == "子弹追踪" then T.BulletTracer = true BulletTracerEnable()
elseif v == "陷阱透视" then T.TrapsESP = true F.TrapsESPEnable()
elseif v == "Xray 透视" then T.Xray = true XrayEnable()
elseif v == "自发光" then T.SelfGlow = true SelfGlowEnable() end
end })
Tabs.Combat:AddDropdown("ESPBoxStyle", { Title = "ESP 方框样式", Values = { "边框", "角框", "两者" }, Default = "边框", Callback = function(v) C.ESPBoxStyle = v end })
Tabs.Combat:AddToggle("ESPTeamColor", { Title = "敌我识别(队伍变色)", Default = false, Callback = function(v) T.ESPTeamColor = v end })
end
do
Tabs.Move:AddSection("移动")
Tabs.Move:AddParagraph({ Title = "飞行按键: WASD 移动, 空格上升, 左Ctrl 下降", Content = "" })
Tabs.Move:AddDropdown("FlyMode", { Title = "飞行模式", Values = { "关闭", "飞行(CFrame)", "物理飞行(更平滑)" }, Default = "关闭", Callback = function(v)
T.Fly = (v == "飞行(CFrame)")
T.FlyPhys = (v == "物理飞行(更平滑)")
FlyDisable() F.FlyPhysDisable()
if T.Fly then FlyEnable()
elseif T.FlyPhys then F.FlyPhysEnable() end
end })
Tabs.Move:AddSlider("FlySpeed", { Title = "飞行速度", Min = 10, Max = 1000, Default = 50, Rounding = 0, Callback = function(v) C.FlySpeed = v end })
Tabs.Move:AddSlider("FlyMaxHeight", { Title = "飞行高度上限(0=不限)", Min = 0, Max = 2000, Default = 400, Rounding = 0, Callback = function(v) C.FlyMaxHeight = v end })
Tabs.Move:AddToggle("FlyVelSpoof", { Title = "飞行速度伪装(复制的是人力量级)", Default = true, Callback = function(v) T.FlyVelSpoof = v end })
Tabs.Move:AddSlider("MoveJitter", { Title = "位移抖动幅度(%, 0=关)", Min = 0, Max = 40, Default = 20, Rounding = 0, Callback = function(v) C.MoveJitter = v end })
Tabs.Move:AddButton({ Title = "服务端权威检查(AuthorityMode)", Callback = function()
local mode, srv = F.AuthorityGuard(false)
local txt = (mode == nil) and "本游戏没有 AuthorityMode 字段, 位移走客户端权威(可放心用)"
or (srv and ("AuthorityMode=" .. tostring(mode) .. " → 位移由服务端裁决, 飞行/加速会被引擎拒绝或回弹")
or ("AuthorityMode=" .. tostring(mode) .. " → 客户端权威, 位移类功能可用"))
if Fluent and Fluent.Notify then Fluent:Notify({ Title = "服务端权威", Content = txt, Duration = 8 }) end
print("[CheatMenu] " .. txt)
end })
Tabs.Move:AddToggle("FlyStealth", { Title = "飞行抗检测(限速+假落地)", Default = false, Callback = function(v) T.FlyStealth = v if v then F.FlyStealthEnable() else F.FlyStealthDisable() end end })
Tabs.Move:AddDropdown("SpeedMode", { Title = "加速模式(5合1)", Values = {
"关闭", "普通加速", "全绕过(属性锁+伪装回读)", "CFrame位移(最隐蔽)", "Desync(服务端看虚假位置)",
}, Default = "关闭", Callback = function(v)
T.Speed = (v == "普通加速")
T.SpeedBypass = (v == "全绕过(属性锁+伪装回读)")
T.SpeedCFrame = (v == "CFrame位移(最隐蔽)")
T.DesyncSpeed = (v == "Desync(服务端看虚假位置)")
SpeedDisable() AC.UninstallIndexMask() T.SpeedMask = false
F.SpeedCFrameDisable() pcall(F.DesyncSpeedDisable)
if T.Speed then SpeedEnable()
elseif T.SpeedBypass then F.SpeedBypassEnable()
elseif T.SpeedCFrame then F.SpeedCFrameEnable()
elseif T.DesyncSpeed then F.DesyncSpeedEnable() end
end })
Tabs.Move:AddSlider("SpeedMul", { Title = "加速倍数(×)", Min = 1, Max = 50, Default = 2, Rounding = 0, Callback = function(v) C.SpeedMul = v end })
Tabs.Move:AddSlider("SpeedCFrameMul", { Title = "位移加速倍数", Min = 1, Max = 20, Default = 2, Rounding = 0, Callback = function(v) C.SpeedCFrameMul = v end })
Tabs.Move:AddSlider("SpeedCFrameStep", { Title = "单帧位移上限(越小越隐蔽)", Min = 1, Max = 16, Default = 4, Rounding = 0, Callback = function(v) C.SpeedCFrameStep = v end })
Tabs.Move:AddToggle("SpeedCFrameGroundOnly", { Title = "只在地面提速(空中不提)", Default = true, Callback = function(v) T.SpeedCFrameGroundOnly = v end })
Tabs.Move:AddSlider("DesyncOffset", { Title = "Desync 下移偏移", Min = 1, Max = 20, Default = 5, Rounding = 0, Callback = function(v) C.DesyncOffset = v end })
Tabs.Move:AddSlider("DesyncSide", { Title = "Desync 侧向偏移", Min = 0, Max = 20, Default = 0, Rounding = 0, Callback = function(v) C.DesyncSide = v end })
Tabs.Move:AddToggle("InfiniteJump", { Title = "无限跳", Default = false, Callback = function(v) T.InfiniteJump = v if v then F.InfiniteJumpEnable() else F.InfiniteJumpDisable() end end })
Tabs.Move:AddToggle("Spin", { Title = "自转", Default = false, Callback = function(v) T.Spin = v if v then F.SpinEnable() else F.SpinDisable() end end })
Tabs.Move:AddSlider("SpinSpeed", { Title = "自转速度", Min = 1, Max = 60, Default = 10, Rounding = 0, Callback = function(v) C.SpinSpeed = v end })
Tabs.Move:AddToggle("AirWalk", { Title = "踏空", Default = false, Callback = function(v) T.AirWalk = v if v then F.AirWalkEnable() else F.AirWalkDisable() end end })
Tabs.Move:AddSlider("AirWalkSpeed", { Title = "踏空速度", Min = 10, Max = 200, Default = 30, Rounding = 0, Callback = function(v) C.AirWalkSpeed = v end })
Tabs.Move:AddToggle("NoClip", { Title = "穿墙", Default = false, Callback = function(v) T.NoClip = v if v then F.NoClipEnable() else F.NoClipDisable() end end })
Tabs.Move:AddToggle("Hide", { Title = "藏地下", Default = false, Callback = function(v) T.Hide = v if v then F.HideEnable() else F.HideDisable() end end })
Tabs.Move:AddSlider("HideDepth", { Title = "藏地下深度", Min = 1, Max = 30, Default = 5, Rounding = 0, Callback = function(v) C.HideDepth = v end })
Tabs.Move:AddToggle("FlyCar", { Title = "飞车", Default = false, Callback = function(v) T.FlyCar = v if v then FlyCarEnable() else FlyCarDisable() end end })
Tabs.Move:AddSlider("FlyCarSpeed", { Title = "飞车速度", Min = 10, Max = 300, Default = 50, Rounding = 0, Callback = function(v) C.FlyCarSpeed = v end })
Tabs.Move:AddToggle("Swim", { Title = "空中游泳", Default = false, Callback = function(v) T.Swim = v if v then F.SwimEnable() else F.SwimDisable() end end })
Tabs.Move:AddToggle("AntiSit", { Title = "防坐下", Default = false, Callback = function(v) T.AntiSit = v if v then F.AntiSitEnable() else F.AntiSitDisable() end end })
Tabs.Move:AddToggle("AntiAnchor", { Title = "防锚定", Default = false, Callback = function(v) T.AntiAnchor = v if v then F.AntiAnchorEnable() else F.AntiAnchorDisable() end end })
Tabs.Move:AddToggle("CharPersist", { Title = "重生自动恢复", Default = true, Callback = function(v) T.CharPersist = v if v then F.CharPersistEnable() else F.CharPersistDisable() end end })
Tabs.Move:AddInput("ThrustDist", { Title = "前冲距离(studs)", Default = "50", Callback = function(v) C.ThrustDist = v end })
Tabs.Move:AddButton({ Title = "前冲(朝相机方向)", Callback = function() F.Thrust(C.ThrustDist or 50) end })
end
do
Tabs.World:AddSection("视觉增强")
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
Tabs.World:AddToggle("Mute", { Title = "静音", Default = false, Callback = function(v) T.Mute = v if v then MuteEnable() end end })
Tabs.World:AddToggle("Antilag", { Title = "降画质", Default = false, Callback = function(v) T.Antilag = v if v then AntilagEnable() else AntilagDisable() end end })
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
Tabs.TP:AddSection("位置管理")
Tabs.TP:AddDropdown("WPSlot", { Title = "位置槽位(1-5)", Values = F.WaypointLabels(), Default = "1: (空)", Callback = function(v) C.WPSlot = v end })
Tabs.TP:AddButton({ Title = "保存当前位置", Callback = function() F.SaveWaypoint(C.WPSlot) end })
Tabs.TP:AddButton({ Title = "传送到该位置", Callback = function() F.TpWaypoint(C.WPSlot) end })
Tabs.TP:AddButton({ Title = "刷新位置列表", Callback = function() F.RefreshWaypointUI() end })
Tabs.TP:AddToggle("Flashback", { Title = "记录死亡点", Default = false, Callback = function(v) T.Flashback = v if v then F.FlashbackEnable() else F.FlashbackDisable() end end })
Tabs.TP:AddButton({ Title = "传回死亡点", Callback = function() F.FlashbackGo() end })
Tabs.TP:AddToggle("TPSmooth", { Title = "平滑传送", Default = false, Callback = function(v) T.TPSmooth = v end })
Tabs.TP:AddSlider("TPSmoothSeg", { Title = "分段数", Min = 3, Max = 20, Default = 8, Rounding = 0, Callback = function(v) C.TPSmoothSeg = v end })
Tabs.TP:AddToggle("ClickTP", { Title = "点击传送", Default = false, Callback = function(v) T.ClickTP = v if v then F.ClickTPEnable() else F.ClickTPDisable() end end })
Tabs.TP:AddInput("TPCoords", { Title = "坐标传送(X,Y,Z)", Default = "", Placeholder = "如 100,50,200" })
Tabs.TP:AddButton({ Title = "传送到坐标", Callback = function()
local s = Fluent.Options.TPCoords and Fluent.Options.TPCoords.Value
if not s or s == "" then return end
local x, y, z = s:match("([^,]+),([^,]+),([^,]+)")
if x then
local _, _, root = GC()
if root then smoothTP(CFrame.new(tonumber(x), tonumber(y), tonumber(z))) end
end
end })
Tabs.TP:AddToggle("AntiVoid", { Title = "防掉虚空", Default = false, Callback = function(v) T.AntiVoid = v if v then F.AntiVoidEnable() else F.AntiVoidDisable() end end })
Tabs.TP:AddSlider("VoidY", { Title = "虚空高度阈值", Min = -200, Max = 0, Default = -50, Rounding = 0, Callback = function(v) C.VoidY = v end })
end
do
Tabs.AFK:AddSection("自动化")
Tabs.AFK:AddToggle("KickProtect", { Title = "挂机防踢(反挂机+拦截Kick+抢传)", Default = true, Callback = function(v)
T.KickProtect = v T.AntiAFK = v T.KickGuard = v T.KickRejoin = v
if v then F.AntiAFKEnable() F.KickGuardEnable() F.KickRejoinEnable()
else F.KickGuardDisable() F.AntiAFKDisable() end
end })
Tabs.AFK:AddToggle("AutoTrain", { Title = "踢击训练", Default = false, Callback = function(v) T.AutoTrain = v if v then F.AutoTrainEnable() end end })
Tabs.AFK:AddToggle("AutoBonus", { Title = "领取踢击距离", Default = false, Callback = function(v) T.AutoBonus = v if v then F.AutoBonusEnable() end end })
Tabs.AFK:AddSlider("AutoTrainSec", { Title = "训练循环间隔(秒)", Min = 1, Max = 30, Default = 5, Rounding = 1, Callback = function(v) C.AutoTrainSec = v end })
Tabs.AFK:AddToggle("AutoGym", { Title = "自动锻炼(健身房)", Default = false, Callback = function(v) T.AutoGym = v if v then F.AutoGymEnable() end end })
Tabs.AFK:AddSection("基地操作")
Tabs.AFK:AddToggle("AutoSell", { Title = "卖 CPS 脑红(按门槛)", Default = false, Callback = function(v) T.AutoSell = v if v then sellLowCPSTools() end end })
Tabs.AFK:AddInput("SellMinCPS", { Title = "售卖门槛(1M/500K/数字)", Default = "100K", Callback = function(v)
local n = tonumber(v) or (v:match("^(%d+%.?%d*)[Kk]$") and tonumber(v:match("^(%d+%.?%d*)[Kk]$")) * 1000) or (v:match("^(%d+%.?%d*)[Mm]$") and tonumber(v:match("^(%d+%.?%d*)[Mm]$")) * 1000000)
if n and n > 0 then C.SellMinCPS = n end
end })
Tabs.AFK:AddButton({ Title = "一键收起脑红", Callback = function() withdrawAllBrainrots() end })
Tabs.AFK:AddButton({ Title = "一键收钱", Callback = function() T.Collect = true collectAllCash() end })
Tabs.AFK:AddSection("物品")
Tabs.AFK:AddButton({ Title = "丢出所有工具", Callback = function() F.DropAllTools() end })
Tabs.AFK:AddToggle("DupeAttempt", { Title = "刷物品尝试(依赖游戏bug)", Default = false, Callback = function(v) T.DupeAttempt = v if v then F.DupeAttemptEnable() else F.DupeAttemptDisable() end end })
Tabs.AFK:AddDropdown("ToolPreset", { Title = "经典工具", Values = (function() local n = {} for k in pairs(TOOL_PRESETS) do n[#n+1] = k end table.sort(n) return n end)(), Default = "Linked Sword", Callback = function(v) C.ToolPreset = v end })
Tabs.AFK:AddInput("ToolAssetId", { Title = "自定义 asset ID", Default = "", Callback = function(v) C.ToolAssetId = v end })
Tabs.AFK:AddSlider("SpawnCount", { Title = "生成数量", Min = 1, Max = 50, Default = 1, Rounding = 0, Callback = function(v) C.SpawnCount = v end })
Tabs.AFK:AddButton({ Title = "生成物品(经典工具/asset ID)", Callback = function()
if C.ToolAssetId and C.ToolAssetId ~= "" then
F.SpawnToolById(C.ToolAssetId, C.SpawnCount or 1)
elseif C.ToolPreset then
F.SpawnToolById(TOOL_PRESETS[C.ToolPreset], C.SpawnCount or 1)
end
end })
Tabs.AFK:AddToggle("ItemMagnet", { Title = "物品吸附", Default = false, Callback = function(v) T.ItemMagnet = v if v then F.ItemMagnetEnable() else F.ItemMagnetDisable() end end })
Tabs.AFK:AddInput("MagnetKeyword", { Title = "吸附关键词(留空=全部)", Default = "", Callback = function(v) C.MagnetKeyword = v end })
Tabs.AFK:AddSlider("MagnetRadius", { Title = "吸附半径", Min = 10, Max = 300, Default = 60, Rounding = 0, Callback = function(v) C.MagnetRadius = v end })
Tabs.AFK:AddToggle("RemoteSpy", { Title = "Remote 流量监听", Default = false, Callback = function(v) T.RemoteSpy = v if v then F.RemoteSpyEnable() else F.RemoteSpyDisable() end end })
Tabs.AFK:AddInput("RemoteName", { Title = "Remote 名", Default = "", Callback = function(v) C.RemoteName = v end })
Tabs.AFK:AddInput("RemoteArgs", { Title = "Remote 参数(逗号分隔)", Default = "", Callback = function(v) C.RemoteArgs = v end })
Tabs.AFK:AddButton({ Title = "调用该 Remote", Callback = function() F.CallRemote(C.RemoteName, C.RemoteArgs) end })
end
do
Tabs.AC:AddSection("反作弊")
Tabs.AC:AddToggle("ACMaster", { Title = "反作弊主开关(全绕过+防护)", Default = false, Callback = function(v)
if v then
T.ACBypass = true T.NamecallHook = true T.RemoteBlock = true
T.AntiFling = true T.UniversalAC = true T.PropertyLock = true
T.SpeedMask = true T.ACIndexHook = true
T.StealthMode = true T.GuiProtect = true
AC.InstallNamecallHook() AC.InstallPropertyLock() AC.InstallIndexMask()
pcall(AC.InstallSetmetatableHook)
pcall(AC.WatchNewScriptsEnable)
F.AntiFlingEnable()
T.CharPersist = true
task.spawn(function()
local stealth = select(1, F.StealthEnable())
local blocked = F.UnifiedACPass()
local killed = AC.DisableACConnections(true)
local neutral = AC.NeutralizeByName(nil)
AC.WatchNewRemotesEnable()
F.ProtectGui()
pcall(F.GuiProtectionEnable)
pcall(F.AuthorityGuard, true)
Fluent:Notify({
Title = "反作弊",
Content = "已开启全部绕过 · 隐身 " .. (stealth and "开" or "关") ..
" · 拦 remote " .. tostring(blocked) .. " · 断连接 " .. tostring(killed) ..
" · 中和函数 " .. tostring(neutral),
Duration = 8,
})
end)
else
T.ACBypass = false T.NamecallHook = false T.RemoteBlock = false
T.AntiFling = false T.UniversalAC = false T.PropertyLock = false
T.SpeedMask = false T.ACIndexHook = false T.GuiProtect = false T.StealthMode = false
F.AntiFlingDisable() AC.UnblockRemotes()
pcall(AC.WatchNewScriptsDisable)
AC.WatchNewRemotesDisable()
AC.UninstallSetmetatableHook()
pcall(F.GuiProtectionDisable)
pcall(F.StealthDisable)
end
end })
Tabs.AC:AddButton({ Title = "统一扫描(一次 getgc 全做完)", Callback = function()
task.spawn(function()
local _, capOk, capTotal = F.ProbeCapabilities(false)
local n = F.UnifiedACPass()
pcall(F.ScanRemotes)
pcall(F.ScanGameModules)
pcall(F.LogFlush, "统一扫描")
Fluent:Notify({
Title = "扫描完成",
Content = "拦 remote " .. tostring(n) .. " 个 · 执行器能力 " .. tostring(capOk) .. "/" .. tostring(capTotal) .. " —— 明细见控制台 F9",
Duration = 8,
})
end)
end })
Tabs.AC:AddButton({ Title = "抓包+模块扫描", Callback = function()
task.spawn(function()
pcall(F.ScanRemotes)
pcall(F.ScanGameModules)
Fluent:Notify({ Title = "扫描完成", Content = "见控制台 F9", Duration = 6 })
end)
end })
Tabs.AC:AddButton({ Title = "扫描并自动拦截(隐藏 remote)", Callback = function()
task.spawn(function()
local n = AC.ScanAndBlock()
Fluent:Notify({ Title = "扫描完成", Content = "已拦截 remote 共 " .. tostring(n) .. " 个", Duration = 6 })
end)
end })
Tabs.AC:AddButton({ Title = "清理反作弊连接(getconnections)", Callback = function()
task.spawn(function()
local d, s = AC.DisableACConnections(true)
Fluent:Notify({ Title = "反作弊", Content = "扫描 " .. tostring(s) .. " 条, 已禁用 " .. tostring(d) .. " 条", Duration = 6 })
end)
end })
Tabs.AC:AddButton({ Title = "能力探测(哪些扫描能用 / 为什么没结果)", Callback = function()
task.spawn(function()
local _, okN, total = F.ProbeCapabilities(true)
pcall(F.LogFlush, "能力探测")
Fluent:Notify({
Title = "能力探测",
Content = "执行器可用 " .. tostring(okN) .. "/" .. tostring(total) .. " 项 —— 明细见控制台 F9",
Duration = 8,
})
end)
end })
Tabs.AC:AddButton({ Title = "属性扫描(游戏状态 / 反作弊标记)", Callback = function()
task.spawn(function()
local hits, scanned = F.ScanAttributes(C.AttrKeyword or "")
pcall(F.LogFlush, "属性扫描")
Fluent:Notify({
Title = "属性扫描",
Content = "扫过 " .. tostring(scanned) .. " 个实例, 命中 " .. tostring(#hits) .. " 条属性 —— 明细见控制台 F9",
Duration = 8,
})
end)
end })
Tabs.AC:AddInput("AttrKeyword", { Title = "属性名关键词(留空=全列)", Default = "", Placeholder = "如 Owner, Cash, IsHunter, Health", Callback = function(v) C.AttrKeyword = v end })
Tabs.AC:AddSection("全量采集与导出")
Tabs.AC:AddButton({ Title = "开始采集 remote 调用(玩 5-10 分钟)", Callback = function()
local ok = F.CaptureEnable()
Fluent:Notify({
Title = "采集",
Content = ok and "已开始记录上行 remote 参数 —— 正常玩一会儿, 再点「一键全量导出」" or "开启失败(执行器不支持 hookmetamethod)",
Duration = 8,
})
end })
Tabs.AC:AddButton({ Title = "停止采集", Callback = function()
local n = F.CaptureDisable()
Fluent:Notify({ Title = "采集", Content = "已停止, 共记录 " .. tostring(n) .. " 条", Duration = 5 })
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
Tabs.AC:AddButton({ Title = "保存扫描快照(更新前先存一次)", Callback = function()
task.spawn(function()
local s = F.SnapshotSave()
Fluent:Notify({
Title = "快照",
Content = "remote " .. tostring(#s.remotes) .. " · 反作弊碎片 " .. tostring(#s.acfns) ..
" · 属性 " .. tostring(#s.attrs) .. " 种 · 脚本指纹 " .. tostring(#s.scripthashes),
Duration = 8,
})
end)
end })
Tabs.AC:AddButton({ Title = "与快照对比(游戏更新后用)", Callback = function()
task.spawn(function()
local d = F.SnapshotDiff()
if not d then
Fluent:Notify({ Title = "对比", Content = "还没有旧快照 —— 更新前先点一次「保存扫描快照」", Duration = 8 })
return
end
Fluent:Notify({
Title = "更新对比",
Content = "新 remote " .. tostring(#d.remoteNew) .. " · 变了 " .. tostring(#d.remoteChanged) ..
" · 反作弊碎片新增 " .. tostring(#d.acNew) .. " · 属性新增 " .. tostring(#d.attrNew) ..
" · 脚本被改 " .. tostring(#d.hashChanged) .. " —— 明细见 F9",
Duration = 12,
})
end)
end })
Tabs.AC:AddButton({ Title = "导出日志到本地文件(按游戏名分文件)", Callback = function()
task.spawn(function()
local name, n = F.LogFlush("手动")
F.LogWhere()
Fluent:Notify({
Title = "日志",
Content = name and ("已追加 " .. tostring(n) .. " 字符 -> " .. name) or "本次没有待写内容(先跑一次扫描)",
Duration = 10,
})
end)
end })
Tabs.AC:AddButton({ Title = "查看日志文件路径", Callback = function()
task.spawn(function()
F.LogWhere()
Fluent:Notify({ Title = "日志路径", Content = "路径已打印到 F9 控制台", Duration = 8 })
end)
end })
Tabs.AC:AddButton({ Title = "清空日志缓冲(不删文件)", Callback = function()
F._logBuf = {}
Fluent:Notify({ Title = "日志", Content = "内存缓冲已清空(磁盘文件保留)", Duration = 5 })
end })
Tabs.AC:AddButton({ Title = "反作弊面测绘(能看见什么/看不见什么)", Callback = function()
task.spawn(function()
local snap = F.ACSurfaceReport()
pcall(F.LogFlush, "反作弊面测绘")
Fluent:Notify({
Title = "反作弊面",
Content = "可见: remote " .. tostring(#snap.remotes) .. " · 客户端碎片 " .. tostring(#snap.acfns) ..
" · 属性 " .. tostring(#snap.attrs) .. " 种。服务端判定逻辑不可见(原理限制, 详见 F9)",
Duration = 12,
})
end)
end })
Tabs.AC:AddButton({ Title = "删除 AnimationHandler(绕过部分反作弊)", Callback = function()
task.spawn(function()
local n = AC.RemoveAnimationHandler()
Fluent:Notify({ Title = "反作弊", Content = "已删除 " .. n .. " 个 AnimationHandler", Duration = 4 })
end)
end })
Tabs.AC:AddToggle("ACIndexHook", { Title = "多层拦截(__index 属性读伪装)", Default = false, Callback = function(v)
T.ACIndexHook = v T.SpeedMask = v
if v then AC.InstallIndexMask() else AC.UninstallIndexMask() end
end })
Tabs.AC:AddToggle("PropertyLock", { Title = "属性锁(__newindex 强制锁定)", Default = false, Callback = function(v)
T.PropertyLock = v
if v then AC.InstallPropertyLock() else AC.UninstallPropertyLock() end
end })
Tabs.AC:AddToggle("AntiTP", { Title = "防传送", Default = false, Callback = function(v) T.AntiTP = v if v then AC.InstallAntiTP() else AC.UninstallAntiTP() end end })
Tabs.AC:AddToggle("AntiPause", { Title = "防游戏暂停", Default = false, Callback = function(v) T.AntiPause = v if v then AC.AntiPauseEnable() else AC.AntiPauseDisable() end end })
Tabs.AC:AddToggle("TrapDisable", { Title = "陷阱不触发", Default = false, Callback = function(v) T.TrapDisable = v if v then AC.TrapDisable.Enable() else AC.TrapDisable.Disable() end end })
Tabs.AC:AddToggle("GuiProtect", { Title = "界面自我保护(被销毁自动重建)", Default = false, Callback = function(v)
T.GuiProtect = v
if v then pcall(F.GuiProtectionEnable) else pcall(F.GuiProtectionDisable) end
end })
Tabs.AC:AddSection("隐身 / 反检测")
Tabs.AC:AddToggle("StealthMode", { Title = "隐身(5 层: debug/游戏debug/getfenv/身份/回溯)", Default = false, Callback = function(v)
T.StealthMode = v
if v then
task.spawn(function() pcall(F.StealthEnable) end)
else
pcall(F.StealthDisable)
end
end })
Tabs.AC:AddToggle("StealthAggressive", { Title = "激进隐身(把所有 Lua 闭包都伪装成 C 函数)", Default = true, Callback = function(v)
F.StealthAggressive = v
end })
Tabs.AC:AddButton({ Title = "按名中和反作弊函数(filtergc 定位)", Callback = function()
task.spawn(function()
local extra = {}
local s = C.NeutralizeExtra
if type(s) == "string" and s ~= "" then
for part in s:gmatch("[^,，%s]+") do extra[#extra + 1] = part end
end
local hit, found = AC.NeutralizeByName(extra)
Fluent:Notify({ Title = "按名中和", Content = "命中 " .. tostring(found) .. " 个具名函数, 已中和 " .. tostring(hit) .. " 个", Duration = 6 })
end)
end })
Tabs.AC:AddInput("NeutralizeExtra", { Title = "额外中和的函数名(逗号分隔)", Default = "", Placeholder = "如 GetPlayerBanned,Detected", Callback = function(v) C.NeutralizeExtra = v end })
Tabs.AC:AddButton({ Title = "元表剥离(让身份判定失效)", Callback = function()
task.spawn(function()
local key = tostring(C.StripKey or "applyImpulse")
local n = AC.StripMetatable(key)
Fluent:Notify({ Title = "元表剥离", Content = "含键 " .. key .. " 的表: " .. tostring(n) .. " 个已剥离", Duration = 6 })
end)
end })
Tabs.AC:AddInput("StripKey", { Title = "剥离用的表键名", Default = "applyImpulse", Callback = function(v) C.StripKey = v end })
Tabs.AC:AddButton({ Title = "缩放击退 / 速度(改游戏自己的回调)", Callback = function()
task.spawn(function()
local f = (tonumber(C.KnockScale) or 0) / 100
local n = AC.ScaleKnockback(f)
Fluent:Notify({ Title = "击退缩放", Content = "已改写 " .. tostring(n) .. " 个回调 (倍率 " .. tostring(f) .. ")", Duration = 6 })
end)
end })
Tabs.AC:AddSlider("KnockScale", { Title = "击退/速度保留比例(%)", Min = 0, Max = 100, Default = 0, Rounding = 0, Callback = function(v) C.KnockScale = v end })
end
do
Tabs.Setting:AddSection("设置")
Tabs.Setting:AddDropdown("Theme", { Title = "界面主题", Values = { "Aqua(青绿)", "Dark(深灰)", "Darker(更暗)", "Light(亮色)", "Amethyst(紫)", "Rose(玫瑰)" }, Default = "Aqua(青绿)", Callback = function(v)
local map = { ["Aqua(青绿)"]="Aqua", ["Dark(深灰)"]="Dark", ["Darker(更暗)"]="Darker", ["Light(亮色)"]="Light", ["Amethyst(紫)"]="Amethyst", ["Rose(玫瑰)"]="Rose" }
pcall(function() Fluent:SetTheme(map[v] or "Aqua") end)
end })
Tabs.Setting:AddToggle("Clicker", { Title = "自动连点器", Default = false, Callback = function(v) T.Clicker = v if v then F.ClickerEnable() else F.ClickerDisable() end end })
Tabs.Setting:AddToggle("ToolGlow", { Title = "道具美化(手持发光)", Default = false, Callback = function(v) T.ToolGlow = v if v then ToolGlowEnable() else ToolGlowDisable() end end })
Tabs.Setting:AddToggle("PanicKey", { Title = "Panic Key(F1 一键关闭所有功能)", Default = false, Callback = function(v) T.PanicKey = v if v then F.PanicKeyEnable() else F.PanicKeyDisable() end end })
Tabs.Setting:AddToggle("AutoSave", { Title = "配置自动保存(每25秒)", Default = true, Callback = function(v) T.AutoSave = v if v then F.AutoSaveEnable() else F.AutoSaveDisable() end end })
Tabs.Setting:AddButton({ Title = "刷新玩家列表", Callback = function() F.RefreshPlayerDropdowns() end })
Tabs.Setting:AddSection("按键绑定")
Tabs.Setting:AddToggle("Keybind", { Title = "按键绑定(启用)", Default = false, Callback = function(v) T.Keybind = v if v then F.KeybindEnable() else F.KeybindDisable() end end })
Tabs.Setting:AddDropdown("BindF2", { Title = "F2 键绑定", Values = { "无", "飞行", "自动攻击", "穿墙", "ESP 透视", "隐身" }, Default = "无", Callback = function(v) F.BindKey("F2", v) end })
Tabs.Setting:AddDropdown("BindF3", { Title = "F3 键绑定", Values = { "无", "飞行", "自动攻击", "穿墙", "ESP 透视", "隐身" }, Default = "无", Callback = function(v) F.BindKey("F3", v) end })
Tabs.Setting:AddDropdown("BindF4", { Title = "F4 键绑定", Values = { "无", "飞行", "自动攻击", "穿墙", "ESP 透视", "隐身" }, Default = "无", Callback = function(v) F.BindKey("F4", v) end })
Tabs.Setting:AddDropdown("BindF5", { Title = "F5 键绑定", Values = { "无", "飞行", "自动攻击", "穿墙", "ESP 透视", "隐身" }, Default = "无", Callback = function(v) F.BindKey("F5", v) end })
Tabs.Setting:AddSection("系统")
Tabs.Setting:AddButton({ Title = "换服(实为重进当前服, Roblox 无公开服务器列表 API)", Callback = function() ServerHop() end })
Tabs.Setting:AddButton({ Title = "重新加入", Callback = function() Rejoin() end })
Tabs.Setting:AddButton({ Title = "保存配置", Callback = function() SaveConfig() Fluent:Notify({ Title = "配置", Content = "已保存", Duration = 2 }) end })
Tabs.Setting:AddButton({ Title = "卸载脚本", Callback = function() UnloadAll() end })
Tabs.Setting:AddButton({ Title = "连接诊断", Callback = function() F.DiagConnections() end })
T.KickProtect = true
T.AntiAFK = true
T.KickGuard = true
T.KickRejoin = true
T.CharPersist = true
T.AutoSave = true
F.AntiAFKEnable()
F.KickGuardEnable()
F.KickRejoinEnable()
F.CharPersistEnable()
F.AutoSaveEnable()
F.LivePlayersEnable()
Fluent:Notify({ Title = "CheatMenu", Content = "已加载 v6.10.0 · 全功能整合完成", Duration = 5 })
RestoreFeatures()
print("[CheatMenu] ✅ 加载完成 v6.10.0")
end
local function polishToggleVisuals()
if not (Fluent and Fluent.GUI) then return end
local ok, desc = pcall(function() return Fluent.GUI:GetDescendants() end)
if not ok or not desc then return end
for _, obj in ipairs(desc) do
if obj:IsA("ImageLabel") and tostring(obj.Image or ""):find("12266946128", 1, true) then
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
sg.Name = "CheatMenu_Toggle"
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
