print(('[CheatMenu] build 2026-10-09 02:49 sha dd419f23 bytes 585775'):format('2026-10-09 02:49','dd419f23',585775))
local F = {}
F.VERSION = "v17.0.13"
F._flyDisabledInfJump = nil
F._flyJumpReqConn = nil
F._flyJumpAt = 0
F._menuHoldAt = nil
F._menuHoldMoved = false
F.LIMITS = {
SCAN_GC_CAP = 300000, SCAN_ANALYZE_CAP = 120000, SCAN_YIELD_EVERY = 300,
SCAN_SCRIPT_CAP = 400000, SCAN_DESC_EVERY = 400,
PROBE_STEP = 4, PROBE_SEC = 2,
}
F.REMOTE_URLS = {
"https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
"https://gh-proxy.com/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua",
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
F.LOG_BUF_MAX = F.LOG_BUF_MAX or 3000
function F.Out(...)
local n = select("#", ...)
local parts = {}
for i = 1, n do
local s = F.Sanitize(select(i, ...))
if #s > 300 then s = s:sub(1, 300) .. "…(" .. #s .. "字)" end
parts[i] = s
end
local line = table.concat(parts, " ")
local now = os.clock()
if line == F._outLast then
F._outRep = (F._outRep or 0) + 1
if now - (F._outRepAt or 0) < 3 then return end
F._outRepAt = now
if F._outRep > 1 then line = line .. "  ×" .. tostring(F._outRep) .. " 次(同一条重复已自动折叠)" end
F._outRep = 0
else
if (F._outRep or 0) > 1 and F._outLast then
line = F._outLast .. "  ×" .. tostring(F._outRep) .. " 次(同一条重复已自动折叠)\n" .. line
end
F._outRep = 0
F._outLast = line
end
print(line)
F._logBuf[#F._logBuf + 1] = line
if #F._logBuf > 60000 then
local keep = {}
for i = #F._logBuf - 39999, #F._logBuf do keep[#keep + 1] = F._logBuf[i] end
F._logBuf = keep
end
if F.LogFlush and not F._logFlushing and #F._logBuf >= F.LOG_BUF_MAX and (now - (F._logFlushAt or 0) >= 2) then
pcall(F.LogFlush, "自动")
end
local crit = (line:find("防护档位", 1, true) or line:find("防护·改写档", 1, true)
or line:find("【熔断】", 1, true) or line:find("深度中和", 1, true)
or line:find("热加载", 1, true) or line:find("已干净卸载", 1, true)
or line:find("切档", 1, true) or line:find("[卸载]", 1, true))
if crit and F.LogFlush and not F._logFlushing and (now - (F._logFlushAt or 0) >= 0.8) then
pcall(F.LogFlush, "关键")
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
g.CM_Window, g.CM_ToggleSG, g.CM_TogglePolish, g.CM_MenuWatch = nil, nil, nil, nil
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
if not LP then
local _lpT0 = os.clock()
repeat task.wait(0.2) until (Players.LocalPlayer and game:IsLoaded()) or os.clock() - _lpT0 > 60
LP = Players.LocalPlayer
task.wait(0.5)
end
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
local Fluent = nil
local FLUENT_SOURCES = {
"https://gh-proxy.com/https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua",
"https://ghfast.top/https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua",
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
pcall(function()
if type(Fluent) ~= "table" then return end
local orig = Fluent.SafeCallback
if type(orig) ~= "function" then return end
Fluent.SafeCallback = function(self, cb, ...)
if type(cb) ~= "function" then return end
local ok, err = pcall(cb, ...)
if ok then return end
local msg = tostring(err)
F.Out("[界面] ⚠ 控件回调报错(该功能可能没生效): " .. msg)
pcall(function()
Fluent:Notify({ Title = "界面", Content = "控件回调报错", SubContent = msg, Duration = 8 })
end)
end
if type(Fluent.Notify) == "function" then
local nf = Fluent.Notify
Fluent.Notify = function(self, arg)
if type(arg) == "table" then
if arg.Title == "Interface" then arg.Title = "界面" end
if arg.Content == "Callback error" then arg.Content = "控件回调报错" end
if type(arg.Content) == "string" and string.find(arg.Content, "to toggle the inteface", 1, true) then
arg.Content = "按 %s 可以收起/展开界面"
end
end
return nf(self, arg)
end
end
end)
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
local _ft0 = os.clock()
for _, url in ipairs(FLUENT_SOURCES) do
local ok, body = pcall(function() return game:HttpGet(url) end)
if ok and fluentLooksLua(body) and fluentTry(body, string.sub(url, 1, 48)) then
if type(writefile) == "function" then
pcall(writefile, "CheatMenu_Fluent.lua", body)
F.Out("[CheatMenu] 已把 Fluent 缓存到本地 => 下次加载免网络、秒开")
end
break
end
end
F.Out(string.format("[CheatMenu] Fluent 取源耗时 %.2f 秒", os.clock() - _ft0))
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
F.MetaSlot = {}
F.MetaRebuild = function(slot)
local st = F.MetaSlot[slot]
if not st then return end
local fn = function(self, ...) return st.native(self, ...) end
for i = 1, #st.order do
st.order[i].box.orig = fn
fn = st.order[i].raw
end
st.top = fn
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
local st = F.MetaSlot[slot]
if not st then
local mt = getrawmetatable(target)
if type(mt) ~= "table" or type(mt[slot]) ~= "function" then return nil end
local origFn = nil
local dis = nil
local okW = pcall(function()
dis = newcclosure(function(self, ...)
local cur = F.MetaSlot[slot]
if not cur or not cur.top then return origFn(self, ...) end
return cur.top(self, ...)
end)
end)
if not (okW and type(dis) == "function") then return nil end
local got
local okH = pcall(function() got = hookmetamethod(target, slot, dis) end)
if not (okH and type(got) == "function") then return nil end
origFn = got
st = { target = target, slot = slot, order = {}, byId = {}, native = got, dispatcher = dis, top = nil }
F.MetaSlot[slot] = st
if F.CMX_MarkOwn then pcall(F.CMX_MarkOwn, dis) end
end
local box = { alive = true, orig = nil, id = id, slot = slot }
local raw = wrapperFactory(box)
if type(raw) ~= "function" then
if #st.order == 0 then
pcall(function() hookmetamethod(st.target, slot, st.native) end)
F.MetaSlot[slot] = nil
F.MetaLayers[slot] = nil
F.MetaTargets[slot] = nil
end
return nil
end
local rec = { id = id, slot = slot, target = target, box = box, raw = raw, alive = true }
bucket[id] = rec
st.byId[id] = rec
st.order[#st.order + 1] = rec
F.MetaRebuild(slot)
return st.dispatcher
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
local st = F.MetaSlot[slot]
if not st then return true end
if st.byId then st.byId[id] = nil end
for i = #st.order, 1, -1 do
if st.order[i] == rec then table.remove(st.order, i) break end
end
if #st.order == 0 then
pcall(function() hookmetamethod(st.target, slot, st.native) end)
pcall(F.CMX_RestoreRO)
F.MetaSlot[slot] = nil
F.MetaLayers[slot] = nil
F.MetaTargets[slot] = nil
return true
end
F.MetaRebuild(slot)
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
F.Once = function(key, sec)
F._once = F._once or {}
local now = os.clock()
local t = F._once[key]
if t and (now - t) < (sec or 1.5) then
F.Out("[防连点] 「" .. tostring(key) .. "」正在执行或刚点过 ⇒ 已忽略这次重复点击")
return false
end
F._once[key] = now
return true
end
F.OptSet = function(o, v)
if type(o) ~= "table" then return false end
if type(o.SetValue) == "function" then return (pcall(function() o:SetValue(v) end)) end
if type(o.Set) == "function" then return (pcall(function() o:Set(v) end)) end
return false
end
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
elseif (k == "Health" or k == "MaxHealth") and (T.God or T.LockHealth) and type(v) == "number" then
local mx = nil
pcall(function() mx = rawget(t, "MaxHealth") end)
if type(mx) == "number" and mx == mx and mx > 0 and v < mx then v = mx end
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
F.CMX_FakeArgs = function(...)
if not T.CMX_FakeReport then return nil end
local n = select("#", ...)
local args = { ... }
local ok, changed = pcall(function()
local c = 0
for i = 1, n do
local v = args[i]
if type(v) == "number" and (v ~= v or math.abs(v) > 120) then args[i] = 16 c = c + 1 end
end
return c
end)
if not ok then return nil end
args.n = n
return args, changed
end
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
local fp, fc = F.CMX_FakeArgs(...)
if fp then
AC._fakeSent = (AC._fakeSent or 0) + 1
if os.clock() - (AC._fakeAt or 0) > 5 then
AC._fakeAt = os.clock()
local mf = "[假上报] " .. tostring(name) .. " 不丢弃 ⇒ 已把 " .. tostring(fc)
.. " 个异常数值改回正常范围后发出(服务端看到的是'一切正常')"
if type(task) == "table" and task.defer then task.defer(function() pcall(F.Out, mf) end) else pcall(F.Out, mf) end
end
return box.orig(self, table.unpack(fp, 1, fp.n))
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
.. " (累计 " .. tostring(AC._hpBlocked) .. " 次) ⇒ 拦到就改值发出/没开假上报就丢弃"
if type(task) == "table" and task.defer then task.defer(function() pcall(F.Out, m2) end)
else pcall(F.Out, m2) end
end
local fph = F.CMX_FakeArgs(...)
if fph then
AC._fakeSent = (AC._fakeSent or 0) + 1
return box.orig(self, table.unpack(fph, 1, fph.n))
end
return nil
end
end
end
if (method == "FireServer" or method == "InvokeServer") and not checkcaller() and (T.GameBypass == true or T.SpoofPos == true) then
local oname = tostring(self and self.Name or "")
if T.GameBypass == true then
local gkw = F.GameBypassNameHit(oname)
if gkw ~= nil then
F.GameBypassNote(oname, gkw)
return nil
end
end
if T.SpoofPos == true then
local pkw = F.PosSpoofNameHit(oname)
if pkw ~= nil then
local sp, sc = F.PosSpoofArgs(...)
if sp then
F.PosSpoofNote(oname, pkw, sc)
return box.orig(self, table.unpack(sp, 1, sp.n))
end
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
if T.HpBlock or T.RemoteBlock or T.SpoofPos or T.GameBypass then return false end
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
F.POS_KEYS = { "motorreplication","motor_replication","position","posupdate","pos_update","updatepos","setpos","reportpos","reportposition","location","transform","cframe","moveupdate","move_update","charpos","char_pos","playerpos","player_pos","syncpos","syncposition","updatemove" }
F.PosSpoofNameHit = function(name)
local n = string.lower(tostring(name or ""))
local i
for i = 1, #F.POS_KEYS do
if string.find(n, F.POS_KEYS[i], 1, true) then return F.POS_KEYS[i] end
end
return nil
end
F.PosSpoofArm = function()
local ok, _, _, root = pcall(GC)
local px, py, pz = nil, nil, nil
if ok and root then
pcall(function() px, py, pz = root.Position.X, root.Position.Y, root.Position.Z end)
end
if type(px) ~= "number" or type(py) ~= "number" or type(pz) ~= "number" then return false end
F._spoofP = { X = px, Y = py, Z = pz }
return true
end
F.PosSpoofArgs = function(...)
if T.SpoofPos ~= true then return nil end
local f = F._spoofP
if f == nil then
if not F.PosSpoofArm() then return nil end
f = F._spoofP
if f == nil then return nil end
end
local n = select("#", ...)
local args = { ... }
local c, i = 0, 0
for i = 1, n do
local v = args[i]
local tp = type(v)
if tp == "Vector3" then
local nv = nil
pcall(function() nv = Vector3.new(f.X, f.Y, f.Z) end)
if nv ~= nil then args[i] = nv c = c + 1 end
elseif tp == "CFrame" then
local nv = nil
pcall(function() nv = CFrame.new(f.X, f.Y, f.Z) end)
if nv ~= nil then args[i] = nv c = c + 1 end
end
end
if c == 0 then return nil end
args.n = n
return args, c
end
F.PosSpoofNote = function(name, kw, cnt)
AC._posSpoofed = (AC._posSpoofed or 0) + 1
local now = os.clock()
if now - (AC._posSpoofLogAt or 0) < 5 then return end
AC._posSpoofLogAt = now
local msg = "[位置上报伪造] " .. tostring(name) .. " ← 关键词 " .. tostring(kw)
.. " ⇒ 已把 " .. tostring(cnt) .. " 个坐标参数改成假位置(累计 " .. tostring(AC._posSpoofed) .. " 次)"
if type(task) == "table" and task.defer then task.defer(function() pcall(F.Out, msg) end) else pcall(F.Out, msg) end
end
F.SpoofPosSet = function(on)
T.SpoofPos = on and true or false
if T.SpoofPos then
local armed = F.PosSpoofArm()
pcall(AC.InstallNamecallHook)
if armed then
F.Out("[位置上报伪造] 已开: 对外上报的坐标冻结在当前这格 " .. string.format("%.0f, %.0f, %.0f", F._spoofP.X, F._spoofP.Y, F._spoofP.Z))
else
F.Out("[位置上报伪造] 已开, 但现在没有角色(没进游戏/重生中) ⇒ 进游戏后自动补取(第一次上报位置时就取点)")
end
F.Out("[位置上报伪造] 原理: 只改「你发出去的坐标」⇒ 服务端/别人看到的位置停在这一格。若游戏是服务端权威移动 ⇒ 可能被拉回、抽搐, 遇到就把档位调到① (本项随②/③自动开关)")
else
F.Out("[位置上报伪造] 已关(不再改坐标; 公共钩子留给其它功能用)")
end
end
F.GBYP_KEYS = { "anticheat","anti_cheat","anti-cheat","acflag","ac_flag","flag","report","detect","violation","suspect","exploit","cheat","telemetry","analytic","integrity","verify","audit","evidence","punish","moderate","strike","screenshot","alert","warn" }
F.GBYP_SAFE = { "interact","door","open","pick","use","quest","shop","chat","buy","sell","trade","invite","join","leave","vote","emote","music","sound","camera","menu","equip","inventory","grab","dropitem","respawn","checkpoint" }
F.GameBypassNameHit = function(name)
local n = string.lower(tostring(name or ""))
local i
for i = 1, #F.GBYP_SAFE do
if string.find(n, F.GBYP_SAFE[i], 1, true) then return nil end
end
for i = 1, #F.GBYP_KEYS do
if string.find(n, F.GBYP_KEYS[i], 1, true) then return F.GBYP_KEYS[i] end
end
return nil
end
F.GameBypassScan = function()
F._gbypList = {}
local roots, i, j = {}, 0, 0
pcall(function() local rs = game:GetService("ReplicatedStorage") if rs then roots[#roots + 1] = rs end end)
pcall(function() if workspace then roots[#roots + 1] = workspace end end)
local seen = {}
for i = 1, #roots do
local objs = F.walk(roots[i], 4000, 300)
for j = 1, #objs do
local o = objs[j]
local cls = nil
pcall(function() cls = o.ClassName end)
if cls == "RemoteEvent" or cls == "UnreliableRemoteEvent" or cls == "RemoteFunction" then
if seen[o] == nil and F.GameBypassNameHit(o.Name) ~= nil then
seen[o] = true
F._gbypList[#F._gbypList + 1] = o
end
end
end
end
return #F._gbypList
end
F.GameBypassNote = function(name, kw)
AC._gbypBlocked = (AC._gbypBlocked or 0) + 1
local now = os.clock()
if now - (AC._gbypLogAt or 0) < 4 then return end
AC._gbypLogAt = now
local msg = "[游戏专用绕过] 已拦下 " .. tostring(name) .. " ← 关键词 " .. tostring(kw)
.. " (累计 " .. tostring(AC._gbypBlocked) .. " 次; 游戏功能异常就说明这个词误伤了, 关掉即恢复)"
if type(task) == "table" and task.defer then task.defer(function() pcall(F.Out, msg) end) else pcall(F.Out, msg) end
end
F.GameBypassSet = function(on)
T.GameBypass = on and true or false
if T.GameBypass then
local n = 0
pcall(function() n = F.GameBypassScan() end)
pcall(AC.InstallNamecallHook)
F.Out("[游戏专用绕过] 已开: 只拦「检测 / 上报类」远程, 命中 " .. tostring(n) .. " 个")
local names, k = {}, 0
for k = 1, #(F._gbypList or {}) do
if #names >= 12 then break end
names[#names + 1] = tostring(F._gbypList[k].Name)
end
if #names > 0 then
F.Out("[游戏专用绕过] 本次目标: " .. table.concat(names, " / "))
else
F.Out("[游戏专用绕过] 本服没扫到「检测/上报类」远程 ⇒ 这次等于空转(不拦任何东西)")
end
else
F.Out("[游戏专用绕过] 已关(不再拦; 公共钩子留给其它功能用)")
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
if T.RemoteBlock and not checkcaller() then return nil end
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
pcall(function()
if not (d:IsA("LocalScript") or d:IsA("ModuleScript")) then return end
local hit, strong = AC.killHit(d.Name)
if hit then
F.Out("[CheatMenu] 拦截可疑脚本: " .. d:GetFullName() .. (strong and " (强特征·延迟销毁)" or " (词元特征·仅禁用)"))
AC.killScript(d, strong)
end
end)
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
if not T.Spoof then return box.orig(t, k) end
local _, hum = GC()
if hum and t == hum then
if k == "WalkSpeed" then return F.CMX_LegitWalk() end
if k == "JumpPower" then return 50 end
if k == "JumpHeight" then return 7.5 end
end
return box.orig(t, k)
end
if k == "MaxHealth" or k == "Health" then
if not T.Spoof then return box.orig(t, k) end
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
local probeSigs = {}
if RS then
pcall(function() add(probeSigs, RS.Heartbeat) end)
pcall(function() add(probeSigs, RS.Stepped) end)
pcall(function() add(probeSigs, RS.RenderStepped) end)
pcall(function() add(probeSigs, RS.PreRender) end)
pcall(function() add(probeSigs, RS.PreSimulation) end)
pcall(function() add(probeSigs, RS.PostSimulation) end)
end
if LP then pcall(function() add(probeSigs, LP.Idled) end) end
local keepForce = AC._forceConnSignals
AC._forceConnSignals = true
for i = 1, #hardSigs do AC.disableSignalConns(hardSigs[i], force ~= false, out) end
AC._forceConnSignals = false
for i = 1, #stateSigs do AC.disableSignalConns(stateSigs[i], false, out) end
for i = 1, #softSigs do AC.disableSignalConns(softSigs[i], false, out) end
for i = 1, #probeSigs do AC.disableSignalConns(probeSigs[i], false, out) end
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
if not checkcaller() then
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
F.LOG_MAX = 1500000
F.LOG_BUF_MAX = 3000
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
F._logFlushAt = os.clock()
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
function F.IsOursSrc(low)
if type(low) ~= "string" then return false end
return (low:find("cheatmenu", 1, true) ~= nil) or (low:find("fluent", 1, true) ~= nil)
end
F._afkConn = nil
F.ANTI_AFK_KEY = "__CMX_UNIVERSAL_ANTI_AFK"
F._afkEnv = function()
local ge = _G
pcall(function()
if type(getgenv) == "function" then
local e = getgenv()
if type(e) == "table" then ge = e end
end
end)
return ge
end
F.AntiAFKHit = function()
local vu = nil
pcall(function() vu = VirtualUser end)
if type(vu) ~= "table" then pcall(function() vu = game:GetService("VirtualUser") end) end
if type(vu) ~= "table" then return false end
pcall(function() vu:CaptureController() end)
pcall(function() vu:ClickButton2(Vector2.new(0, 0)) end)
pcall(function()
local cam = workspace.CurrentCamera
local cf = (cam and cam.CFrame) or CFrame.new()
vu:Button2Down(Vector2.new(0, 0), cf)
task.wait(0.05)
vu:Button2Up(Vector2.new(0, 0), cf)
end)
return true
end
F.AntiAFKEnable = function()
local ge = F._afkEnv()
local oldState = ge[F.ANTI_AFK_KEY]
if type(oldState) == "table" and oldState.Connection then
pcall(function() oldState.Connection:Disconnect() end)
end
if not LP then return end
local connection = LP.Idled:Connect(function()
if not T.AntiAFK then return end
if UIS.TouchEnabled then return end
pcall(function()
if F.AntiAFKHit() then
F._afkFixed = (F._afkFixed or 0) + 1
if F.LogRate("afk_idle", 6) then
F.Out("[挂机防踢] 游戏判你挂机 ⇒ 已在屏幕角落做一次「空点」把计时清零(照搬 PuckAFK 通用做法)")
end
end
end)
end)
ge[F.ANTI_AFK_KEY] = { Connection = connection, Enabled = true }
F._afkConn = connection
F.Out("[挂机防踢] 已开: 通用防挂机(照搬 PuckAFK) —— 只在游戏判你挂机时于屏幕角落「空点」一次; 不改角色属性、不装任何元表钩子(所以不会因为 hook 被踢)")
end
F.AntiAFKDisable = function()
local ge = F._afkEnv()
local state = ge[F.ANTI_AFK_KEY]
if type(state) == "table" and state.Connection then
pcall(function() state.Connection:Disconnect() end)
end
pcall(function() ge[F.ANTI_AFK_KEY] = nil end)
if F._afkConn then pcall(function() F._afkConn:Disconnect() end) F._afkConn = nil end
F.Out("[挂机防踢] 已关")
end
F._flingConns = {}
function F.AntiFlingEnable()
if T.AntiFling and #F._flingConns > 0 then return end
T.AntiFling = true
local function fix()
if not T.AntiFling then pcall(F.AntiFlingDisable) return end
local _, _, root = GC()
if not root then return end
local lim = math.max(8000, (tonumber(C.SpeedValue) or 0) * 2.5, (tonumber(C.FlyValue) or 0) * 2.5)
local v = root.AssemblyLinearVelocity
local av = root.AssemblyAngularVelocity
if v.Magnitude > lim then
pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, math.min(v.Y, 50), 0) end)
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
local function attachVel()
local _, _, r = GC()
if not r then return end
if F._flingVelConn then pcall(function() F._flingVelConn:Disconnect() end) F._flingVelConn = nil end
pcall(function() F._flingVelConn = r:GetPropertyChangedSignal("AssemblyLinearVelocity"):Connect(fix) end)
if not F._flingVelConn then
pcall(function() F._flingVelConn = r:GetPropertyChangedSignal("Velocity"):Connect(fix) end)
end
end
table.insert(F._flingConns, RS.Heartbeat:Connect(fix))
attachVel()
table.insert(F._flingConns, LP.CharacterAdded:Connect(function() task.wait(0.3) fix() attachVel() end))
end
function F.AntiFlingDisable()
T.AntiFling = false
if F._flingVelConn then pcall(function() F._flingVelConn:Disconnect() end) F._flingVelConn = nil end
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
local KG = { hooked = false, target = nil, blocked = 0 }
F.MetaHookUninstall = function() pcall(F.KickGuardPathsDisable) end
function F.DeepNeuterEnable()
T.DeepNeuter = true
pcall(F.MetaHookEnsure)
local n = 0
pcall(function() n = F.AntiCheatGCSweep() end)
if n and n > 0 then
F.Out("[深度中和] 已开: getgc 扫到并中和 " .. tostring(n) .. " 个检测/踢人函数 —— 这层最容易招反作弊, 用完记得关")
else
F.Out("[深度中和] 已开(大扫描已放到后台, 不再卡主线程; 扫完日志会报结果) —— 这层最容易招反作弊, 用完记得关")
end
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
F._isyieldable = function()
if type(coroutine) ~= "table" or type(coroutine.isyieldable) ~= "function" then return false end
local ok, r = pcall(coroutine.isyieldable)
return (ok and r) and true or false
end
F._logAt = {}
F.LogRate = function(key, secs)
local now = os.clock()
if now - (F._logAt[key] or 0) < (secs or 3) then return false end
F._logAt[key] = now
return true
end
F.RunChunked = function(work, tag)
if F._isyieldable() then return work() end
task.spawn(function()
local ok, err = pcall(work)
if not ok then pcall(F.Out, "[" .. tostring(tag or "后台扫描") .. "] 后台执行出错(已跳过): " .. tostring(err)) end
end)
return nil
end
F._gcSweepSaved = {}
F._gcKickStall = function() return task.wait(9e9) end
F._gcNoop = function() return end
F._gcFalse = function() return false end
F._gcTrue = function() return true end
F.GCSweepKeys = {
{ "kick", F._gcKickStall }, { "randomDelayKick", F._gcKickStall },
{ "lagback", F._gcNoop }, { "punish", F._gcNoop },
}
F.EnsureGcSweepKeys = function()
F.GCSweepKeys[1][2] = F._gcKickStall
F.GCSweepKeys[2][2] = F._gcKickStall
F.GCSweepKeys[3][2] = F._gcNoop
F.GCSweepKeys[4][2] = F._gcNoop
return F.GCSweepKeys
end
F.AntiCheatGCSweep = function()
if type(getgc) ~= "function" then return 0 end
local work = function()
local n, seen = 0, 0
local saved = F._gcSweepSaved
local KEYS = F.EnsureGcSweepKeys()
pcall(function()
for _, v in pairs(getgc(true)) do
seen = seen + 1
if seen > 60000 then break end
if not T.DeepNeuter then break end
if seen % 2000 == 0 and F._isyieldable() then task.wait() end
if seen % 2000 == 0 and not T.DeepNeuter then break end
if typeof(v) == "table" then
for i = 1, #KEYS do
local key, repl = KEYS[i][1], KEYS[i][2]
local f = rawget(v, key)
if type(f) == "function" then
local s = saved[v]
if not s then s = {} saved[v] = s end
if s[key] == nil then s[key] = f end
rawset(v, key, repl)
n = n + 1
end
end
local hasD = rawget(v, "Detected")
local hasK = rawget(v, "Kill")
if type(hasD) == "function" and type(hasK) == "function" then
local s = saved[v]
if not s then s = {} saved[v] = s end
if s.Detected == nil then s.Detected = hasD end
if s.Kill == nil then s.Kill = hasK end
rawset(v, "Detected", F._gcFalse)
rawset(v, "Kill", F._gcNoop)
n = n + 2
end
local bmv = rawget(v, "getIsBodyMoverCreatedByGame")
if type(bmv) == "function" then
local s = saved[v]
if not s then s = {} saved[v] = s end
if s.getIsBodyMoverCreatedByGame == nil then s.getIsBodyMoverCreatedByGame = bmv end
rawset(v, "getIsBodyMoverCreatedByGame", F._gcTrue)
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
return F.RunChunked(work, "防踢中和") or 0
end
F.AntiCheatGCRestore = function()
local n = 0
for t, kv in pairs(F._gcSweepSaved or {}) do
if type(t) == "table" then
for k, f in pairs(kv) do
pcall(rawset, t, k, f)
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
local ccFn = nil
pcall(function()
if type(checkcaller) == "function" and pcall(checkcaller) then ccFn = checkcaller end
end)
local gnFn = nil
pcall(function()
if type(getnamecallmethod) == "function" and pcall(getnamecallmethod) then gnFn = getnamecallmethod end
end)
pcall(function() if type(getrawmetatable) == "function" and setreadonly then setreadonly(getrawmetatable(game), false) end end)
F._roUnlocked = true
local nNC = F.MetaInstall("__namecall", game, "CMKickNC", function(box)
return function(self, ...)
local m = gnFn and gnFn() or ""
if m ~= "Kick" and m ~= "ChangeState" and m ~= "FireServer" and m ~= "InvokeServer" then return box.orig(self, ...) end
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
local fp9 = F.CMX_FakeArgs(...)
if fp9 then KG.blocked9fake = (KG.blocked9fake or 0) + 1 return box.orig(self, table.unpack(fp9, 1, fp9.n)) end
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
local fp6 = F.CMX_FakeArgs(...)
if fp6 then return box.orig(self, table.unpack(fp6, 1, fp6.n)) end
return nil
end
end
end
end
return box.orig(self, ...)
end
end)
local nIX = F.MetaInstall("__index", game, "CMKickIX", function(box)
return function(self, key)
if ccFn and ccFn() then return box.orig(self, key) end
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
return box.orig(self, key)
end
end)
local nNIX = F.MetaInstall("__newindex", game, "CMKickNIX", function(box)
return function(self, key, v)
if ccFn and ccFn() then return box.orig(self, key, v) end
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
if KG.blockSet[self] then
local antiPin = (T.TrapWarn or T.HitGuard)
if antiPin and key == "Anchored" and v == true then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
if antiPin and key == "PlatformStand" and v == true then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
if T.SpeedGuard and (key == "WalkSpeed" or key == "JumpPower" or key == "JumpHeight")
and type(v) == "number" and v <= 0.01 then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
if T.SpeedGuard and key == "AutoRotate" and v == false then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
if key == "PlatformStand" and v == false and T.FlyOn then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
if (T.God or T.LockHealth) and key == "Health" and type(v) == "number" then
local hv = nil
pcall(function() hv = rawget(self, "Health") end)
if type(hv) == "number" and v < hv then
KG.blocked3 = (KG.blocked3 or 0) + 1
return nil
end
end
end
return box.orig(self, key, v)
end
end)
KG.mtHooked = (nNC ~= nil) or (nIX ~= nil) or (nNIX ~= nil)
F._kgHealFix = 0
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
if not KG.mtHooked then return end
KG.blockSet = {}
KG.logConn = RS.Heartbeat:Connect(function()
local gt = os.clock()
if gt - (KG._logGate or 0) < 0.25 then return end
KG._logGate = gt
local n = KG.blocked or 0
if n ~= (KG.lastReport or 0) and F.LogRate("lastReport") then
KG.lastReport = n
F.Out("[CheatMenu] 拦截 Kick 调用 ×" .. tostring(n) .. " (三条路径: :Kick() / .Kick 取值 / .Kick 赋值)")
end
local n2 = KG.blocked3 or 0
if n2 ~= (KG.lastReport3 or 0) and F.LogRate("lastReport3") then
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
if n5 ~= (KG.lastBlock5 or 0) and F.LogRate("lastBlock5") then
KG.lastBlock5 = n5
F.Out("[屏蔽] 已挡下服务端把我拉回去 ×" .. tostring(n5) .. " (它想把你写回原地, 被拦下)")
end
local n10 = KG.blocked10 or 0
if n10 ~= (KG.lastBlock10 or 0) and F.LogRate("lastBlock10") then
KG.lastBlock10 = n10
F.Out("[防掉蛋] 已拦下'掉蛋/放下'上报 ×" .. tostring(n10)
.. " (被夹/被抓后游戏想让你的蛋掉出去, 被挡掉 ⇒ 蛋还在你手上)")
end
local n9 = KG.blocked9 or 0
if n9 ~= (KG.lastBlock9 or 0) and F.LogRate("lastBlock9") then
KG.lastBlock9 = n9
F.Out("[拦触发] 已拦下 陷阱/守卫/抓捕 的触发上报 ×" .. tostring(n9)
.. " (游戏想上报'我被夹/被抓了', 被挡掉 ⇒ 服务端收不到就不会处理你)")
end
local n8 = KG.blocked8 or 0
if n8 ~= (KG.lastBlock8 or 0) and F.LogRate("lastBlock8") then
KG.lastBlock8 = n8
F.Out("[屏蔽] 已挡下把你打晕/打成布娃娃 ×" .. tostring(n8) .. " (被球棒打晕会掉蛋, 这层就是防这个)")
end
local n7 = KG.blocked7 or 0
if n7 ~= (KG.lastBlock7 or 0) and F.LogRate("lastBlock7") then
KG.lastBlock7 = n7
F.Out("[屏蔽] 已挡下把你切成物理道具 ×" .. tostring(n7) .. " (ChangeState(Physics) 是反作弊'冻结你'的常用手法)")
end
local n6 = KG.blocked6 or 0
if n6 ~= (KG.lastBlock6 or 0) and F.LogRate("lastBlock6") then
KG.lastBlock6 = n6
F.Out("[反检测] 已拦下客户端上报 ×" .. tostring(n6)
.. " (完整性Integrity/拉回前奏Correction/违规Violation/反作弊anticheat/蜜罐honeypot/挂机Afk —— 服务端收不到这些就少一条判你的依据)")
end
local n4 = KG.blocked4 or 0
if n4 ~= (KG.lastBlock4 or 0) and F.LogRate("lastBlock4") then
KG.lastBlock4 = n4
F.Out("[屏蔽] 已挡下服务端把我改回去 ×" .. tostring(n4) .. " (把隐身改回可见 / 把瞬发交互改回长按)")
end
local n3 = KG.spoofHits or 0
if n3 ~= (KG.lastSpoof or 0) and F.LogRate("lastSpoof") then
KG.lastSpoof = n3
F.Out("[伪装] 已对游戏侧伪装速度读数 ×" .. tostring(n3) .. " (游戏读到的是原值, 不是加速值)")
end
end)
end
function F.KickGuardPathsDisable()
KG.kick = false
if T.Spoof or T.SpeedGuard then return end
if KG.logConn then pcall(function() KG.logConn:Disconnect() end) KG.logConn = nil end
if KG.mtHooked then
pcall(function() F.MetaUninstall("__namecall", "CMKickNC") end)
pcall(function() F.MetaUninstall("__index", "CMKickIX") end)
pcall(function() F.MetaUninstall("__newindex", "CMKickNIX") end)
end
KG.mtHooked, KG.mt = nil, nil
KG.lastReport = nil
pcall(F.CMX_RestoreRO)
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
local touch = UIS.TouchEnabled == true
local cam = workspace.CurrentCamera
local vp = cam and cam.ViewportSize or Vector2.new(400, 400)
if not touch then
pcall(function()
local vim = game:GetService("VirtualInputManager")
vim:SendMouseButtonEvent(vp.X / 2, vp.Y / 2, 0, true, game, 1)
vim:SendMouseButtonEvent(vp.X / 2, vp.Y / 2, 0, false, game, 1)
did[#did + 1] = "VIM"
end)
end
pcall(function()
local ch = LP.Character
local tool = ch and ch:FindFirstChildOfClass("Tool")
if tool then tool:Activate() did[#did + 1] = "tool" end
end)
if not touch then
pcall(function()
local vu = game:GetService("VirtualUser")
vu:CaptureController()
vu:ClickButton1(Vector2.new(vp.X / 2, vp.Y / 2))
pcall(function() vu:ReleaseController() end)
did[#did + 1] = "VirtualUser"
end)
end
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
if not touch then
pcall(function()
if type(mouse1click) == "function" then
if pcall(mouse1click) then did[#did + 1] = "mouse1click" end
end
end)
end
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
F.CombatAliveBody = function(ch)
if typeof(ch) ~= "Instance" then return nil end
if not ch.Parent then return nil end
local hum = ch:FindFirstChildOfClass("Humanoid")
if not hum then return nil end
local hp0 = tonumber(hum.Health) or 0
if hp0 <= 0.05 then return nil end
local hst = nil
pcall(function() hst = hum:GetState() end)
if hst == Enum.HumanoidStateType.Dead then return nil end
local isPChar = false
pcall(function() isPChar = Players:GetPlayerFromCharacter(ch) ~= nil end)
if T.CombatSkipInvincible ~= false and isPChar then
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
F.CombatVisible = function(ch, fromPos, prefer)
local ignore = {}
if LP.Character then ignore[#ignore + 1] = LP.Character end
pcall(function() ignore[#ignore + 1] = workspace.CurrentCamera end)
local oka, allp = pcall(function() return Players:GetPlayers() end)
if oka and allp then
local oi
for oi = 1, #allp do
if allp[oi].Character then ignore[#ignore + 1] = allp[oi].Character end
end
end
if T.CombatWallCheck == false then
if prefer then
for pi = 1, #prefer do
local pp = ch:FindFirstChild(prefer[pi])
if pp and pp:IsA("BasePart") then return pp end
end
end
for _, n in ipairs(F.COMBAT_LOS_PARTS) do
local p = ch:FindFirstChild(n)
if p and p:IsA("BasePart") then return p end
end
return nil
end
local params = F.CombatNewRay(ignore)
if prefer then
for pi = 1, #prefer do
local pp = ch:FindFirstChild(prefer[pi])
if pp and pp:IsA("BasePart") then
local h0 = workspace:Raycast(fromPos, pp.Position - fromPos, params)
if (not h0) or h0.Instance:IsDescendantOf(ch) then return pp end
end
end
end
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
F.CombatNpcOk = function(o)
if o == nil or o == LP.Character then return false end
local bad = false
pcall(function()
if o:IsDescendantOf(LP.Character) then bad = true end
local cm0 = workspace.CurrentCamera
if cm0 and o:IsDescendantOf(cm0) then bad = true end
end)
if bad then return false end
if not F.IsNPC(o) then return false end
local hum = nil
pcall(function() hum = o:FindFirstChildOfClass("Humanoid") end)
if not hum then return false end
local nm = tostring(o.Name)
local okp, allp = pcall(function() return Players:GetPlayers() end)
if okp and allp then
local i
for i = 1, #allp do
local pl = allp[i]
if nm == pl.Name then return false end
local c = pl.Character
if c and nm == c.Name then return false end
end
end
local pos = nil
local hd = o:FindFirstChild("Head")
if hd and hd:IsA("BasePart") then pos = hd.Position end
if not pos then
local rpx = o.PrimaryPart
if rpx and rpx:IsA("BasePart") then pos = rpx.Position end
end
if pos then
local ref0 = nil
pcall(function() local r0 = LP.Character and LP.Character.PrimaryPart if r0 then ref0 = r0.Position end end)
if ref0 and (pos - ref0).Magnitude < 2 then return false end
end
return true
end
F._candBuf = F._candBuf or {}
F._combatNpcs = F._combatNpcs or {}
F._combatNpcAt = 0
F.CombatNpcRefresh = function()
local now = os.clock()
if #F._combatNpcs > 0 and (now - (F._combatNpcAt or 0)) < 2.5 then return F._combatNpcs end
F._combatNpcAt = now
local out = F._combatNpcs
local n = 0
pcall(function()
local list = workspace:GetChildren()
local i, j
for i = 1, #list do
local o = list[i]
if n < 80 and F.CombatNpcOk(o) then n = n + 1 out[n] = o end
end
local subs = {}
for i = 1, #list do
local o = list[i]
local okf = pcall(function() return o:IsA("Folder") or o:IsA("Model") end)
if okf and o ~= LP.Character then
local okk, kids = pcall(function() return o:GetChildren() end)
if okk and kids then
for j = 1, #kids do subs[#subs + 1] = kids[j] end
end
end
end
for i = 1, #subs do
local o = subs[i]
if n < 80 and F.CombatNpcOk(o) then n = n + 1 out[n] = o end
local okk2, kids2 = pcall(function() return o:GetChildren() end)
if okk2 and kids2 then
for j = 1, #kids2 do
local k = kids2[j]
if n < 80 and F.CombatNpcOk(k) then n = n + 1 out[n] = k end
end
end
end
end)
local ref = nil
pcall(function() local r0 = LP.Character and LP.Character.PrimaryPart if r0 then ref = r0.Position end end)
if ref and n > 16 then
local a
for a = 1, 16 do
local pick, pd = a, math.huge
local b
for b = a, n do
local rp0 = out[b].PrimaryPart
local okr, pp0 = pcall(function() return rp0 and rp0.Position or nil end)
local d0 = (okr and pp0) and (pp0 - ref).Magnitude or math.huge
if d0 < pd then pick, pd = b, d0 end
end
if pick ~= a then local sw = out[a] out[a] = out[pick] out[pick] = sw end
end
n = 16
end
local i = #out
while i > n do out[i] = nil i = i - 1 end
return out
end
F.CombatPick = function()
local _, hum0, root0 = GC()
if not root0 then return nil, nil, "没有角色" end
local cam = workspace.CurrentCamera
local from = cam and cam.CFrame.Position or root0.Position
local range = tonumber(C.CombatRange) or 200
local fovpx = tonumber(C.CombatFOV) or 400
local pov = (tostring(C.CombatMode or ""):find("正面", 1, true) ~= nil)
local prio = tostring(C.CombatPriority or "")
local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
local cur = F._combatNow
local myTeam = nil
if T.CombatTeamCheck then pcall(function() myTeam = LP.Team end) end
local best, bestPart, bestScore, blocked, why = nil, nil, math.huge, 0, "没有敌人"
local prefer = nil
local wantPart = tostring(C.AimPart or "")
if wantPart ~= "" then
if wantPart:find("头", 1, true) ~= nil then prefer = { "Head" }
elseif wantPart:find("躯干", 1, true) ~= nil then prefer = { "UpperTorso", "Torso" } end
end
local buf = F._candBuf
local n = 0
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then n = n + 1 buf[n] = pl.Character end
end
local nl = F.CombatNpcRefresh()
local i
for i = 1, #nl do n = n + 1 buf[n] = nl[i] end
local ci
for ci = 1, n do
local ch = buf[ci]
local okc, h, root = F.CombatAliveBody(ch)
if okc then
local skip = false
if T.CombatTeamCheck and myTeam ~= nil then
pcall(function()
local pl = Players:GetPlayerFromCharacter(ch)
if pl and pl.Team == myTeam then skip = true end
end)
end
if not skip then
local dist = (root.Position - root0.Position).Magnitude
if dist <= range then
local score, off, onScreen = nil, nil, false
if cam then
local sp, os = cam:WorldToViewportPoint(root.Position)
local dx, dy = sp.X - vp.X / 2, sp.Y - vp.Y / 2
off = math.sqrt(dx * dx + dy * dy)
onScreen = os and true or false
end
if pov then
if onScreen and off and off <= fovpx then
if prio:find("血量最低", 1, true) then score = (h and h.Health) or 0
elseif prio:find("血量最高", 1, true) then score = -((h and h.Health) or 0)
elseif prio:find("距离最近", 1, true) then score = dist
else score = off end
end
if not score then why = "不在正面圈里" end
else
if prio:find("血量最低", 1, true) then score = (h and h.Health) or 0
elseif prio:find("血量最高", 1, true) then score = -((h and h.Health) or 0)
elseif prio:find("准心最近", 1, true) and onScreen then score = off
else score = dist end
end
if score then
if ch == cur then score = score - 1e6 end
if score < bestScore then
local part = F.CombatVisible(ch, from, prefer)
if part then best, bestPart, bestScore = ch, part, score
else
blocked = blocked + 1
why = "被墙挡住"
end
end
end
else
why = "超出锁定距离"
end
end
end
end
local bi = n
while bi > 0 do buf[bi] = nil bi = bi - 1 end
F._combatNow, F._combatWhy = best, why
if best then return best, bestPart end
return nil, nil, why
end
F.CombatHudSet = function(text)
if not F._combatHud then return end
if text == F._combatHudText then return end
local now = os.clock()
if now - (F._combatHudAt or 0) < 0.1 then return end
F._combatHudAt, F._combatHudText = now, text
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
F._combatHudText, F._combatHudAt = nil, 0
end
T.AimTurnCamera, T.AimTurnBody = false, true
T.EspName, T.EspDist, T.EspHp, T.TeamColorHL = true, true, true, false
F._aimHeart, F._aimErr, F._aimLastHeart = 0, 0, 0
F._AIM_STEP = "CM_Combat"
F.CombatTickSafe = function()
if not T.AimOn then return end
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
RS:BindToRenderStep(F._AIM_STEP, Enum.RenderPriority.Camera.Value + 1, function(dt) F._aimDt = dt F.CombatTickSafe() end)
end)
if ok then F._aimBind = true return end
F.Out("[战斗] 自瞄主绑定失败 ⇒ 改用 RenderStepped 兜底")
F._aimConn = RS.RenderStepped:Connect(function(dt) F._aimDt = dt F.CombatTickSafe() end)
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
return
end
local _, hum, root = GC()
if not (hum and root) then return end
local ch, part = F.CombatPick()
if not (ch and part) then
if F._aimFacing then
F._aimFacing = nil
pcall(function() hum.AutoRotate = true end)
end
F.CombatHudSet("锁定: 无目标 (" .. tostring(F._combatWhy or "搜索中") .. ")")
return
end
local pl = nil
pcall(function() pl = Players:GetPlayerFromCharacter(ch) end)
local dist = (part.Position - root.Position).Magnitude
local thp = "?"
pcall(function()
local th = ch:FindFirstChildOfClass("Humanoid")
if th then thp = string.format("%d/%d", math.floor(th.Health), math.floor(th.MaxHealth)) end
end)
F.CombatHudSet("锁定: " .. tostring(pl and pl.Name or ch.Name) .. string.format(" · %.0f 格", dist)
.. " · 锁" .. tostring(part.Name) .. " · HP " .. thp
.. (T.AutoFire and " · 自动开火中" or ""))
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
if cam and (part.Position - cam.CFrame.Position).Magnitude > 2.5 then
local sm = tonumber(C.AimSmooth) or 0
if sm > 0 then
local goal = CFrame.lookAt(cam.CFrame.Position, part.Position)
pcall(function()
local base = math.clamp(1 / math.max(sm, 1), 0.05, 1)
local st = math.clamp((F._aimDt or 0.0166667) * 60, 0.02, 8)
local a = 1 - (1 - base) ^ st
cam.CFrame = cam.CFrame:Lerp(goal, a)
end)
else
pcall(function() cam.CFrame = CFrame.lookAt(cam.CFrame.Position, part.Position) end)
end
end
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
F.CombatHudHide()
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
F.OptSet(op, true)
end)
if not T.AimOn then F.AimSet(true, why or "附属项联动") end
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
local GodConn = nil
local function GodDisable()
if GodConn then GodConn:Disconnect() GodConn = nil end
local done = {}
pcall(function()
local _, hum = GC()
if hum then
local o = (F._godOrig and F._godOrig.hum == hum) and F._godOrig or nil
local mh = hum.MaxHealth
local want = (o and o.maxHealth) or (F._orig and F._orig.maxHealth) or 100
local need = false
if type(mh) ~= "number" or mh > 1000 or mh ~= mh then need = true end
if o and type(o.maxHealth) == "number" and mh ~= o.maxHealth then need = true end
if need then
pcall(function() hum.MaxHealth = want end)
done[#done + 1] = "MaxHealth=" .. tostring(want)
end
pcall(function() hum.Health = math.min(hum.Health, hum.MaxHealth) end)
if o then
if o.requiresNeck ~= nil then
pcall(function() hum.RequiresNeck = o.requiresNeck end)
done[#done + 1] = "RequiresNeck=" .. tostring(o.requiresNeck)
end
if o.breakJoints ~= nil then
pcall(function() hum.BreakJointsOnDeath = o.breakJoints end)
done[#done + 1] = "BreakJointsOnDeath=" .. tostring(o.breakJoints)
end
if o.deadState ~= nil then
pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, o.deadState) end)
done[#done + 1] = "Dead状态=" .. tostring(o.deadState)
end
end
end
end)
local cn = 0
pcall(function() cn = F.GodRestoreDied() end)
if cn > 0 then done[#done + 1] = "恢复死亡事件 " .. tostring(cn) .. " 条" end
F._godOrig = nil
if #done > 0 then F.Out("[上帝模式] 还原: " .. table.concat(done, " · ")) end
end
local function GodEnable()
if GodConn then return end
local arLastG = 0
local function apply()
if not T.LockHealth then pcall(LockHealthDisable) return end
local now = os.clock()
if now - arLastG < 0.1 then return end
arLastG = now
local _, hum = GC()
if F.GodTopUp(hum, true) then F.HpFixNote(1) end
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
local arLast, arLastHum = 0, nil
local function apply(force)
if not T.AntiRagdoll then pcall(F.AntiRagdollDisable) return end
local ch, hum = GC()
if not hum then return end
if F._arOrig == nil or F._arOrig.hum ~= hum then
local o = { hum = hum }
pcall(function() o.ragdoll = hum:GetStateEnabled(Enum.HumanoidStateType.Ragdoll) end)
pcall(function() o.falling = hum:GetStateEnabled(Enum.HumanoidStateType.FallingDown) end)
pcall(function() o.physics = hum:GetStateEnabled(Enum.HumanoidStateType.Physics) end)
pcall(function() o.platform = hum:GetStateEnabled(Enum.HumanoidStateType.PlatformStanding) end)
pcall(function()
local rc = ch and ch:FindFirstChild("RagdollClient")
if rc then o.rc = rc.Enabled end
end)
F._arOrig = o
end
if not force then
local now = os.clock()
if hum == arLastHum and now - arLast < 0.25 then return end
arLast, arLastHum = now, hum
end
pcall(function()
hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
local rc = ch and ch:FindFirstChild("RagdollClient")
if rc then rc.Enabled = false end
end)
end
apply(true)
F._antiRagdollConn = RS.Stepped:Connect(function() apply(false) end)
end
function F.AntiRagdollDisable()
if F._antiRagdollConn then F._antiRagdollConn:Disconnect() F._antiRagdollConn = nil end
local ch, hum = GC()
local o = (F._arOrig and F._arOrig.hum == hum) and F._arOrig or nil
if hum then pcall(function()
hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, (o and o.ragdoll) ~= false)
hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, (o and o.falling) ~= false)
hum:SetStateEnabled(Enum.HumanoidStateType.Physics, (o and o.physics) ~= false)
hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, (o and o.platform) ~= false)
end) end
if ch then
local rc = ch:FindFirstChild("RagdollClient")
if rc then
local v = true
if o ~= nil and o.rc ~= nil then v = o.rc end
pcall(function() rc.Enabled = v end)
end
F._arOrig = nil
end
end
function F.AntiKnockdownEnable()
if F._antiKnockConn then return end
local function fixNow()
pcall(function()
if not T.AntiKnockdown then return end
local _, hum = GC()
if not hum or hum.Health <= 0 then return end
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
local function attach()
local _, hum = GC()
if not hum then return end
if F._akState then pcall(function() F._akState:Disconnect() end) F._akState = nil end
if F._akPS then pcall(function() F._akPS:Disconnect() end) F._akPS = nil end
pcall(function() F._akState = hum.StateChanged:Connect(function() fixNow() end) end)
pcall(function() F._akPS = hum:GetPropertyChangedSignal("PlatformStand"):Connect(fixNow) end)
end
F._akAttach = attach
attach()
F._antiKnockConn = RS.Heartbeat:Connect(function()
if not T.AntiKnockdown then F.AntiKnockdownDisable() return end
if os.clock() - (F._akAt or 0) < 1 then return end
F._akAt = os.clock()
if F._akAttach then pcall(F._akAttach) end
fixNow()
end)
end
function F.AntiKnockdownDisable()
if F._antiKnockConn then F._antiKnockConn:Disconnect() F._antiKnockConn = nil end
if F._akState then pcall(function() F._akState:Disconnect() end) F._akState = nil end
if F._akPS then pcall(function() F._akPS:Disconnect() end) F._akPS = nil end
F._akAttach = nil
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
F._risk = (#scripts > 0) and 2 or ((#conns > 0) and 1 or 0)
F._riskScripts, F._riskConns = #scripts, #conns
if verbose then
F.Out(string.format("[客户端检测] 按名字扫到脚本 %d 个 · Heartbeat 上可疑连接 %d 条(共 %d 条连接)",
#scripts, #conns, (function() local n = 0 pcall(function() n = #getconnections(RS.Heartbeat) end) return n end)()))
for i = 1, #scripts do F.Out("   · 脚本: " .. scripts[i]) end
if #foundScripts > 0 then
F.Out("   —— 试着读它的代码(只读, 不执行) ——")
for i = 1, #foundScripts do
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
for i = 1, #conns do F.Out("   · 连接: " .. conns[i]) end
if #scripts == 0 and #conns == 0 then
F.Out("   ★ 结论: 客户端侧没有「防加速/拉回」检测 ⇒ 加速可以直接用(只注意服务端的速度阈值)")
elseif #scripts == 0 then
F.Out("   ★ 结论: 没有检测脚本, 但 Heartbeat 上有 " .. tostring(#conns)
.. " 条可疑连接 ⇒ 谨慎加速, 被拉回就开「加速防拉回」档")
else
F.Out("   ★ 结论: 客户端有防加速检测(脚本 " .. tostring(#scripts) .. " 个) ⇒ 先开「加速防拉回」档再加速")
end
F.Out("   ⇒ 档位联动: " .. (((#scripts == 0) and (#conns == 0))
and "本服无检测 ⇒ 开加速/飞行时不自动升档(省性能), 被拉回再手动开「防护档位」"
or ("开加速/飞行时会自动升到 ② 反拉回+伪装(检测脚本 "
.. tostring(#scripts) .. " 个 · 可疑连接 " .. tostring(#conns) .. " 条)")))
end
return #scripts, #conns
end
function F.GuardSet(steady, hit, trap, atp, strong, bypass)
if steady or hit then
F.Try("CharEventsEnable", F.CharEventsEnable)
F.Try("MetaHookEnsure", F.MetaHookEnsure)
else
F.Try("CharEventsDisable", F.CharEventsDisable)
end
T.SteadyOn, T.HitGuard = steady, hit
T.TrapWarn, T.SpeedAntiTP = trap, atp
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
F.FLOOR_KEYS = { "treadmill", "tread", "belt", "conveyor", "speedpad" }
F._floorLast = {}
F._floorCacheT, F._floorCacheV = 0, false
F.OnMovingFloorRaw = function()
local _, _, root = GC()
if not root then return false end
local hit = false
pcall(function()
local op = OverlapParams.new()
op.FilterType = Enum.RaycastFilterType.Exclude
if LP.Character then op.FilterDescendantsInstances = { LP.Character } end
local probe = root.Position - Vector3.new(0, 3, 0)
local seen = {}
for _, pf in ipairs(workspace:GetPartBoundsInRadius(probe, 6, op)) do
seen[pf] = true
local nm = tostring(pf.Name):lower()
for _, k in ipairs(F.FLOOR_KEYS) do
if nm:find(k, 1, true) then hit = true break end
end
if not hit then
local floorLike = false
pcall(function()
local sz = pf.Size
local top = pf.Position.Y + sz.Y / 2
local feet = root.Position.Y - 2
floorLike = (math.max(sz.X, sz.Z) >= 6) and (sz.Y <= 4) and (math.abs(top - feet) <= 5)
end)
if floorLike then
local av = 0
pcall(function() av = pf.AssemblyLinearVelocity.Magnitude end)
if av > 3 then hit = true end
if not hit and F._floorLast[pf] then
local d = (pf.Position - F._floorLast[pf]).Magnitude
if d > 0.25 then hit = true end
end
end
end
F._floorLast[pf] = pf.Position
end
for obj in pairs(F._floorLast) do
if not seen[obj] then F._floorLast[obj] = nil end
end
end)
return hit
end
F.OnMovingFloorC = function()
local now = os.clock()
if now - (F._floorCacheT or 0) < 0.5 then return F._floorCacheV end
F._floorCacheT = now
local v = false
pcall(function() v = F.OnMovingFloorRaw() end)
F._floorCacheV = v and true or false
return F._floorCacheV
end
F.ANTITP_KEYS = { "obbyantitp", "antitp", "antilagback", "lagback",
"speedcheck", "speedguard", "anticheat", "antiexploit", "antifly",
"runtime_", "honeypot", "integrityviolation", "monitor",
"detection", "detector", "stepdetect", "afkdetect", "cheatwarn", "cheatalert",
"sentinel", "watchdog", "suspicious" }
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
local nk = function(...) return nil end
if type(newcclosure) == "function" then
local okW, w = pcall(newcclosure, nk)
if okW and type(w) == "function" then nk = w end
end
local ok, orig = pcall(function() return hookfunction(fn, nk) end)
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
for i = 1, #found do names[i] = found[i].Name end
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
F.TrapTagged = function(part)
local ok, r = pcall(function()
local CS = game:GetService("CollectionService")
local node, depth = part, 0
while node and depth < 3 do
for _, tg in ipairs(F.TRAP_TAGS) do
if CS:HasTag(node, tg) then return true end
end
node = node.Parent
depth = depth + 1
end
return false
end)
return (ok and r) and true or false
end
F.TrapNameHit = function(part)
local node, depth = part, 0
while node and depth < 4 do
local nm = tostring(node.Name):lower()
for _, k in ipairs(F.TRAP_KEYS) do
if nm:find(k, 1, true) then return true end
end
node = node.Parent
depth = depth + 1
end
return false
end
F.TRAP_ALLOW_KEYS = { "safe", "coin", "cash", "money", "collect", "pickup", "loot", "item", "egg",
"drop", "reward", "gift", "checkpoint", "checkp", "portal", "teleport", "button", "door", "shop",
"chest", "hatch", "spawn", "buff", "boost", "star", "gem", "token", "badge", "quest", "npc", "sign",
"prompt", "base", "plot", "sell", "treadmill", "seat", "vehicle", "car", "boat", "flag" }
F.TrapAllowed = function(part)
local node, depth = part, 0
while node and depth < 4 do
local nm = tostring(node.Name):lower()
for _, k in ipairs(F.TRAP_ALLOW_KEYS) do
if nm:find(k, 1, true) then return true end
end
node = node.Parent
depth = depth + 1
end
return false
end
F.TrapUniversal = function()
return true
end
F.TrapIsMine = function(part)
local ok, r = pcall(function()
local ch = LP.Character
return ch ~= nil and (part == ch or part:IsDescendantOf(ch))
end)
return (ok and r) and true or false
end
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
local full = "?"
pcall(function() full = tostring(part:GetFullName()):sub(1, 90) end)
F.Out("[反陷阱] 已解除 " .. tostring(F._trapTouchCount) .. " 个物件的触碰(销毁 TouchInterest) · 最近: " .. full
.. " ⇒ 这些踩上去不会再触发")
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
if F._trapPromptConn then pcall(function() F._trapPromptConn:Disconnect() end) F._trapPromptConn = nil end
if F._trapAddConn then pcall(function() F._trapAddConn:Disconnect() end) F._trapAddConn = nil end
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
F.TrapAutoRemoveEnable = function()
T.TrapAutoRemove = true
if F._trapAutoConn then return end
local ok, PPS = pcall(function() return game:GetService("ProximityPromptService") end)
if not (ok and PPS) then F.Out("[反陷阱·自动拆] 拿不到 ProximityPromptService ⇒ 本执行器/本游戏不支持") return end
F._trapAutoN = 0
F._trapAutoConn = PPS.PromptShown:Connect(function(pp)
if not T.TrapAutoRemove then return end
pcall(function()
if not (pp and pp.Parent) then return end
local anc = pp:FindFirstAncestorWhichIsA("BasePart") or pp:FindFirstAncestorWhichIsA("Model")
local an = string.lower(tostring(anc and anc.Name or ""))
local pn = string.lower(tostring(pp.Name) .. " " .. tostring(pp.ActionText or "") .. " " .. tostring(pp.ObjectText or ""))
local named = an:find("trap", 1, true) or (anc and (F.TrapTagged(anc) or F.TrapNameHit(anc)))
local removeLike = pn:find("unplace", 1, true) or pn:find("remove", 1, true) or pn:find("disarm", 1, true)
or pn:find("defuse", 1, true) or pn:find("拆除", 1, true) or pn:find("卸", 1, true)
if not (named and removeLike) then return end
pp.HoldDuration = 0
pp.RequiresLineOfSight = false
pp.MaxActivationDistance = 1000000
if type(fireproximityprompt) == "function" then pcall(fireproximityprompt, pp) end
F._trapAutoN = (F._trapAutoN or 0) + 1
if os.clock() - (F._trapAutoLog or 0) > 3 then
F._trapAutoLog = os.clock()
F.Out("[反陷阱·自动拆] 已拆掉附近陷阱 " .. tostring(F._trapAutoN) .. " 个 · 最近: " .. tostring(anc and anc.Name or pp.Name))
end
end)
end)
F.Out("[反陷阱·自动拆] 已开: 靠近你的陷阱若带「拆除」提示(Unplace/Remove)会被自动点掉")
end
F.TrapAutoRemoveDisable = function()
T.TrapAutoRemove = false
if F._trapAutoConn then pcall(function() F._trapAutoConn:Disconnect() end) F._trapAutoConn = nil end
F.Out("[反陷阱·自动拆] 已关(恢复为「只不触发」)")
end
function F.TrapGuardEnable()
if F._trapConn then return end
F._trapAt = 0
F._trapOnAt = os.clock()
F._trapNdDone = nil
F._trapBak = F._trapBak or {}
F._trapConnOff = F._trapConnOff or {}
pcall(F.TrapTagWatch, true)
if not F._trapAddConn then
pcall(function()
F._trapAddConn = workspace.DescendantAdded:Connect(function(d)
if not T.TrapWarn then return end
local part = nil
if d:IsA("TouchTransmitter") then
part = d.Parent
if not part or not part:IsA("BasePart") then return end
elseif d:IsA("BasePart") then
part = d
else
return
end
if F.TrapIsMine(part) then return end
if F.TrapUniversal() then
if F.TrapAllowed(part) then return end
if not d:IsA("TouchTransmitter") then
local ti = part:FindFirstChild("TouchInterest")
if not ti then ti = part:FindFirstChildWhichIsA("TouchTransmitter") end
if not ti then return end
end
else
if not (F.TrapNameHit(part) or F.TrapTagged(part)) then return end
end
task.defer(function()
pcall(function() F.TrapKillTouch(part) end)
if part.CanTouch then
F._trapBak = F._trapBak or {}
F._trapBak[part] = { touch = part.CanTouch }
pcall(function() part.CanTouch = false end)
end
end)
end)
end)
end
F._trapConn = RS.Heartbeat:Connect(function()
if not T.TrapWarn then F.TrapGuardDisable() return end
local now = os.clock()
if now - (F._trapAt or 0) < 1.5 then return end
F._trapAt = now
local _, _, root = GC()
if not root then return end
local hits = 0
pcall(function()
local op = OverlapParams.new()
op.FilterType = Enum.RaycastFilterType.Exclude
if LP.Character then op.FilterDescendantsInstances = { LP.Character } end
for _, pt in ipairs(workspace:GetPartBoundsInRadius(root.Position, 22, op)) do
local isTrap
if F.TrapUniversal() then
local ti = pt:FindFirstChild("TouchInterest")
if not ti then ti = pt:FindFirstChildWhichIsA("TouchTransmitter") end
isTrap = (ti ~= nil) and (not F.TrapAllowed(pt)) and (not F.TrapIsMine(pt))
else
isTrap = (F.TrapNameHit(pt) or F.TrapTagged(pt))
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
if hits == 0 and not F._trapNdDone and (now - (F._trapOnAt or now)) > 20 then
F._trapNdDone = true
local names = {}
pcall(function()
local op2 = OverlapParams.new()
op2.FilterType = Enum.RaycastFilterType.Exclude
if LP.Character then op2.FilterDescendantsInstances = { LP.Character } end
for _, pt in ipairs(workspace:GetPartBoundsInRadius(root.Position, 22, op2)) do
local low = tostring(pt.Name):lower()
local interesting = pt:FindFirstChild("TouchInterest") ~= nil or pt:FindFirstChildWhichIsA("TouchTransmitter") ~= nil
if interesting or low:find("trap") or low:find("hitbox") or low:find("trigger") or low:find("zone") then
names[#names + 1] = pt.Name
end
if #names >= 14 then break end
end
end)
F.Out("[反陷阱·诊断] 开了 20 秒一个都没匹配到 ⇒ 附近这些'带触碰/Trigger/Zone'的部件名: "
.. (#names > 0 and table.concat(names, ", ") or "(没找到)") .. " —— 把这行发我, 我按真实名字补关键词")
end
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
pcall(function()
if F._trapPromptConn then return end
local PPS = game:GetService("ProximityPromptService")
F._trapPromptConn = PPS.PromptShown:Connect(function(pp)
if not T.TrapWarn then return end
pcall(function()
if not (pp and pp.Parent) then return end
local anc = pp:FindFirstAncestorWhichIsA("BasePart") or pp:FindFirstAncestorWhichIsA("Model") or pp.Parent
if not anc then return end
local named = F.TrapTagged(anc) or F.TrapNameHit(anc)
if not named then return end
if anc:IsA("BasePart") then
if not F.TrapIsMine(anc) then pcall(function() F.TrapKillTouch(anc) end) end
else
for _, d in ipairs(anc:GetDescendants()) do
if d:IsA("BasePart") and not F.TrapIsMine(d) then pcall(function() F.TrapKillTouch(d) end) end
end
end
F._trapPromptN = (F._trapPromptN or 0) + 1
if os.clock() - (F._trapPromptLog or 0) > 5 then
F._trapPromptLog = os.clock()
F.Out("[反陷阱] 即时处理了 " .. tostring(F._trapPromptN) .. " 个刚出现的陷阱提示(不等轮询) · 最近: " .. tostring(anc.Name))
end
end)
end)
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
F._baseWalk = nil
F._preSpeed = nil
F._spdConn, F._flyConn = nil, nil
F._flyBv, F._flyBg, F._flyAp, F._flyAo, F._flyAtt = nil, nil, nil, nil, nil
F._probe = {}
function F.SpeedProbe(r, tag, sp, dt, full3d)
if not r or not sp then return end
if tag ~= "飞行" then
local _, humP = GC()
if humP and humP.MoveDirection.Magnitude < 0.1 then return end
end
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
F._probePeak = F._probePeak or {}
local pk = string.format("%.0f", set)
if not F._probePeak[pk] or actual > F._probePeak[pk] then F._probePeak[pk] = actual end
if now - (F._probeSumAt or 0) > 15 then
F._probeSumAt = now
local ks = {}
for k in pairs(F._probePeak) do
local n2 = tonumber(k)
if n2 then ks[#ks + 1] = n2 end
end
table.sort(ks)
if #ks > 0 then
local parts = {}
for i = 1, #ks do
local kk = string.format("%.0f", ks[i])
parts[#parts + 1] = kk .. "→" .. string.format("%.0f", F._probePeak[kk])
end
F.Out("[速度上限体检] 各设定值实测峰值(格/秒): " .. table.concat(parts, " · ")
.. " —— 峰值明显低于设定的那几个值 = 已经超出本服容许, 挑峰值达标的那档用")
end
end
end
F._invSav, F._invConn = nil, nil
function F.InvisibleEnable()
if F._invSav then return end
local ch = LP.Character
if not ch then F.Out("[隐身] 现在没有角色, 等进游戏再开") return end
F._invSav = {}
F._invSavFx = {}
local n = 0
pcall(function()
for _, o in ipairs(ch:GetDescendants()) do
if o:IsA("BasePart") or o:IsA("Decal") or o:IsA("Texture") then
F._invSav[o] = o.Transparency
o.Transparency = 1
n = n + 1
elseif o:IsA("BillboardGui") or o:IsA("Highlight") or o:IsA("SelectionBox")
or o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then
F._invSavFx[o] = o.Enabled
o.Enabled = false
end
end
end)
F._invConns = {}
F._invMeta = function(ch2)
pcall(function()
local hum = ch2:FindFirstChildOfClass("Humanoid")
if not hum then return end
if F._invSavDistType == nil then F._invSavDistType = hum.DisplayDistanceType end
pcall(function() hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
local anim = hum:FindFirstChildOfClass("Animator") or hum
if not F._invAnimObj then
F._invAnimObj = Instance.new("Animation")
F._invAnimObj.AnimationId = "rbxassetid://282574440"
end
if F._invTrack then pcall(function() F._invTrack:Stop() F._invTrack:Destroy() end) F._invTrack = nil end
F._invTrack = anim:LoadAnimation(F._invAnimObj)
F._invTrack.Priority = Enum.AnimationPriority.Action
F._invTrack.Looped = true
F._invTrack:Play()
F._invTrack:AdjustSpeed(0)
F._invTrack.TimePosition = 0.3
end)
end
local function apply(ch2)
task.wait(0.3)
if not F._invSav then return end
pcall(function() F._invMeta(ch2) end)
pcall(function()
for _, o in ipairs(ch2:GetDescendants()) do
if o:IsA("BasePart") or o:IsA("Decal") or o:IsA("Texture") then
if F._invSav[o] == nil then F._invSav[o] = o.Transparency end
o.Transparency = 1
elseif o:IsA("BillboardGui") or o:IsA("Highlight") or o:IsA("SelectionBox")
or o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then
if F._invSavFx[o] == nil then F._invSavFx[o] = o.Enabled end
o.Enabled = false
end
end
end)
end
pcall(function() F._invConns[1] = LP.CharacterAdded:Connect(apply) end)
pcall(function()
F._invConns[2] = ch.DescendantAdded:Connect(function(o)
if not F._invSav then return end
if o:IsA("BasePart") or o:IsA("Decal") or o:IsA("Texture") then
F._invSav[o] = o.Transparency
pcall(function() o.Transparency = 1 end)
elseif o:IsA("BillboardGui") or o:IsA("Highlight") or o:IsA("SelectionBox")
or o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then
if F._invSavFx and F._invSavFx[o] == nil then F._invSavFx[o] = o.Enabled end
pcall(function() o.Enabled = false end)
end
end)
end)
pcall(function() F._invMeta(ch) end)
F._invConn = RS.Heartbeat:Connect(function()
if not T.Invisible then pcall(F.InvisibleDisable) return end
local _, _, root = GC()
if root and root.Transparency ~= 1 then pcall(function() root.Transparency = 1 end) end
pcall(function()
if F._invTrack then
if not F._invTrack.IsPlaying then F._invTrack:Play() end
F._invTrack:AdjustSpeed(0)
F._invTrack.TimePosition = 0.3
end
end)
end)
F.Out("[隐身] 已开: " .. tostring(n) .. " 个部件 Transparency=1(会复制给所有人)"
.. " + 只隐藏你自己的名字板(DisplayDistanceType=None, 不再去改「名字显示距离」——那会连别人的名字一起隐掉)"
.. " + 附加「动画隐身」: 冻结 rbxassetid://282574440 在 0.3s, 让模型视觉上消失"
.. " —— 全部只作用于你自己的角色; 服务端若有透明检测会把你拉回, 那不是脚本的问题")
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
if F._invSavFx then
for o, en in pairs(F._invSavFx) do
if typeof(o) == "Instance" and o.Parent then pcall(function() o.Enabled = en end) end
end
end
F._invSavFx = nil
pcall(function()
if F._invTrack then F._invTrack:Stop() F._invTrack:Destroy() end
end)
F._invTrack = nil
pcall(function()
local ch = LP.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hum and F._invSavDistType ~= nil then
pcall(function() hum.DisplayDistanceType = F._invSavDistType end)
end
end)
F._invSavDist, F._invSavHealthDist, F._invSavDistType = nil, nil, nil
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
F._pinConn = nil
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
T.VehicleBoost = false
pcall(F.VehicleBoostDisable)
F.SpeedRestore()
return
end
T.VehicleBoost = true
pcall(F.VehicleBoostEnable)
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
local clearPath = true
pcall(function()
local dv = dest - cur2
local dl = dv.Magnitude
if dl > 1.5 then
local rp = RaycastParams.new()
local okE = pcall(function() rp.FilterType = Enum.RaycastFilterType.Exclude end)
if not okE then pcall(function() rp.FilterType = Enum.RaycastFilterType.Blacklist end) end
local flt = { r }
if h.Parent then flt[#flt + 1] = h.Parent end
rp.FilterDescendantsInstances = flt
pcall(function() rp.RespectCanCollide = true end)
if workspace:Raycast(cur2, dv, rp) then clearPath = false end
end
end)
if clearPath then
pcall(function() r.CFrame = CFrame.new(dest) * (r.CFrame - r.CFrame.Position) end)
pcall(function() F.PinPulse(dest, 0.3) end)
intent = dest
else
intent = cur2
F._tpWall = (F._tpWall or 0) + 1
if os.clock() - (F._tpWallAt or 0) > 5 then
F._tpWallAt = os.clock()
F.Out("[反拉回] 检测到被回滚, 但顶回的那一跳会穿过墙 ⇒ 本次已放弃(不再穿墙)")
end
end
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
F.HeliDestroy = function()
if F._heliConn then pcall(function() F._heliConn:Disconnect() end) F._heliConn = nil end
if F._heliRebuild then pcall(function() F._heliRebuild:Disconnect() end) F._heliRebuild = nil end
local _, hum, root = GC()
for _, nm in ipairs({ "CMHeliAo", "CMHeliBg", "CMHeliBv", "CMHeliAtt", "CMHeliAttOld" }) do
local o = nil
if root then pcall(function() o = root:FindFirstChild(nm) end) end
if o then pcall(function() o:Destroy() end) end
end
if F._heliJoint and F._heliC0 and F._heliKind == "own" then
pcall(function() F._heliJoint.C0 = F._heliC0 end)
end
if F._heliKind == "made" and F._heliJoint then
pcall(function() F._heliJoint:Destroy() end)
end
if F._heliWC then
pcall(function()
if F._heliWCE == nil then
F._heliWC.Enabled = true
else
F._heliWC.Enabled = (F._heliWCE == true)
end
end)
end
if F._heliCollOff then
if T.FlyOn and type(F._flyCollOff) == "table" then
for bp, v in pairs(F._heliCollOff) do if v == true then F._flyCollOff[bp] = v end end
else
for bp, v in pairs(F._heliCollOff) do
if bp and bp.Parent then pcall(function() bp.CanCollide = v end) end
end
end
F._heliCollOff = nil
end
F._heliAo, F._heliBg, F._heliBv, F._heliAtt = nil, nil, nil, nil
F._heliAng, F._heliBaseY, F._heliYaw = nil, nil, nil
F._heliPX, F._heliPY, F._heliPZ = nil, nil, nil
F._heliH = nil
F._heliC0r, F._heliC0v, F._heliC1inv = nil, nil, nil
F._heliP0, F._heliPiv = nil, nil
F._heliJoint, F._heliC0, F._heliUseRoot, F._heliMode = nil, nil, nil, nil
F._heliKind, F._heliWC, F._heliWCE = nil, nil, nil
if hum then
pcall(function() hum.PlatformStand = (F._heliWasPS == true) end)
pcall(function() hum.AutoRotate = (F._heliWasAR ~= false) end)
end
F._heliWasPS, F._heliWasAR = nil, nil
end
F.HeliAxis = function()
local m = tostring(C.HeliAxis or "")
if m:find("长轴", 1, true) then return 2 end
if m:find("横轴", 1, true) then return 3 end
return 1
end
F.HeliPivot = function()
local m = tostring(C.HeliPivot or "")
if m:find("头部", 1, true) then return 2 end
return 1
end
F.HeliMode = function()
local m = tostring(C.HeliMode or "")
if m:find("不飞行转", 1, true) then return 1 end
if m:find("飞行转", 1, true) then return 2 end
return 1
end
F.HeliSet = function(on)
if on then pcall(F.BypassAutoRaise, "你开了旋转角色") end
T.HeliOn = on and true or false
F.HeliDestroy()
if not T.HeliOn then return end
local ch, hum, root = GC()
if not (hum and root) then
F.Out("[旋转] 开不了: 还没拿到角色(重生中?) ⇒ 稍后重开")
return
end
F._heliWasPS = hum.PlatformStand
F._heliWasAR = hum.AutoRotate
local mode = F.HeliMode()
F._heliMode = mode
local joint, wc, other = nil, nil, nil
local kinds = {}
pcall(function()
local bD, bS, bO, bK = nil, -1e9, nil, nil
for _, d in ipairs(ch:GetDescendants()) do
local cn = d.ClassName
local isJoint = d:IsA("JointInstance")
local isConn = (not isJoint) and (d:IsA("WeldConstraint") or d:IsA("Constraint"))
if isJoint or isConn then
kinds[cn] = (kinds[cn] or 0) + 1
local o = nil
if isJoint then
if d.Part0 == root then o = d.Part1 end
else
local p0, p1 = nil, nil
if d:IsA("WeldConstraint") then
p0, p1 = d.Part0, d.Part1
else
local a0, a1 = nil, nil
pcall(function() a0 = d.Attachment0 end)
pcall(function() a1 = d.Attachment1 end)
if a0 then p0 = a0.Parent end
if a1 then p1 = a1.Parent end
end
if p0 == root then o = p1 elseif p1 == root then o = p0 end
end
if o ~= nil and o ~= root and o:IsA("BasePart") then
local sc = 0
local on = string.lower(o.Name)
if on:find("torso", 1, true) or on:find("hip", 1, true) or on:find("spine", 1, true)
or on:find("chest", 1, true) or on:find("upper", 1, true) or on:find("lower", 1, true)
or on:find("root", 1, true) or on:find("humanoid", 1, true) then sc = sc + 50 end
pcall(function() sc = sc - (root.Position - o.Position).Magnitude * 0.5 end)
if isJoint then
sc = sc + 2
local jn = string.lower(d.Name)
if jn:find("root", 1, true) then sc = sc + 5 end
if d:IsA("Motor6D") then sc = sc + 1 end
end
if sc > bS then bD, bS, bO, bK = d, sc, o, (isJoint and "own" or "made") end
end
end
end
if bD then
if bK == "own" then joint = bD else wc, other = bD, bO end
end
end)
if joint then
F._heliJoint = joint
F._heliKind = "own"
elseif wc and other then
pcall(function()
local m = Instance.new("Motor6D")
m.Name = "CMHeliJoint"
m.Part0 = root
m.Part1 = other
m.C0 = CFrame.new()
m.C1 = root.CFrame:Inverse() * other.CFrame
m.Parent = root
F._heliJoint = m
F._heliKind = "made"
F._heliWC = wc
F._heliWCE = wc.Enabled
wc.Enabled = false
end)
end
if F._heliJoint then
pcall(function()
F._heliC0 = F._heliJoint.C0
F._heliC0r = F._heliJoint.C0 - F._heliJoint.C0.Position
F._heliC0v = F._heliJoint.C0.Position
local c1v = Vector3.zero
pcall(function() c1v = F._heliJoint.C1:Inverse().Position end)
if type(c1v.Magnitude) == "number" and c1v.Magnitude <= 5 then
F._heliC1inv = c1v
else
F._heliC1inv = Vector3.zero
end
end)
F._heliUseRoot = false
else
F._heliUseRoot = true
end
do
local p0, piv = nil, nil
pcall(function()
if F._heliC0v and F._heliC0r and F._heliC1inv then
p0 = F._heliC0v + (F._heliC0r * F._heliC1inv)
end
end)
if F.HeliPivot() == 2 then
pcall(function()
local hd = ch:FindFirstChild("Head")
if hd and hd:IsA("BasePart") then piv = root.CFrame:Inverse() * hd.CFrame.Position end
end)
end
F._heliP0 = p0
F._heliPiv = piv or p0
end
do
local kids, n = {}, 0
pcall(function()
for _, k in ipairs(root:GetChildren()) do
n = n + 1
if n <= 16 then kids[#kids + 1] = k.Name .. ":" .. k.ClassName end
end
end)
local ks = {}
pcall(function()
for kk, vv in pairs(kinds) do ks[#ks + 1] = kk .. "=" .. tostring(vv) end
end)
F.Out("[旋转] 骨架: root=" .. root.ClassName .. " 子级" .. tostring(n) .. "[" .. table.concat(kids, ", ") .. "]")
F.Out("[旋转] 连接件统计: " .. ((#ks > 0) and table.concat(ks, ", ") or "一个都没有")
.. " ⇒ " .. (F._heliJoint and ((F._heliJoint.Name .. "(" .. F._heliJoint.ClassName .. ")")
.. (F._heliKind == "made"
and (" · 自建接管 连到 " .. tostring(other and other.Name) .. " · 已停用 " .. tostring(wc and wc.Name))
or (" · 直接改它 连到 " .. tostring(F._heliJoint.Part1 and F._heliJoint.Part1.Name))))
or "无连接件可用"))
end
if mode == 2 and F._heliCollOff == nil then
F._heliCollOff = {}
pcall(function()
for _, bp in ipairs(ch:GetDescendants()) do
if bp:IsA("BasePart") then
F._heliCollOff[bp] = bp.CanCollide
bp.CanCollide = false
end
end
end)
end
local p0 = root.Position
F._heliAng, F._heliBaseY = 0, p0.Y
F._heliPX, F._heliPY, F._heliPZ = p0.X, p0.Y, p0.Z
F._heliH = tonumber(C.HeliHeight) or 0
if F._heliH ~= F._heliH then F._heliH = 0 end
local y0 = 0
pcall(function() local _, yy = root.CFrame:ToEulerAnglesYXZ() y0 = yy end)
F._heliYaw = math.deg(tonumber(y0) or 0)
if F._heliYaw ~= F._heliYaw then F._heliYaw = 0 end
if mode == 1 then
F.Out("[旋转] 已开 · 不飞行转: 模型原地自转, 视角/走路/跳跃完全不受影响")
else
F.Out("[旋转] 已开 · 飞行转: 轴=" .. tostring(C.HeliAxis or "竖直轴") .. " · 支点=" .. tostring(C.HeliPivot or "身体中心") .. " · 不自动升降(原地悬停)" .. (T.FlyOn and " · 移动交给「飞行」" or " · WASD 平移 · 空格升 / 左Ctrl 降")
.. " · 已暂时关闭身体碰撞(不再撞地面/墙 ⇒ 不抖不卡)")
end
F._heliConn = F.DriveConnect(function(dt)
if not T.HeliOn then return end
local _, h, r = GC()
if not (h and r) then return end
local spin = tonumber(C.HeliSpin) or 720
if spin < 0 then spin = 0 end
F._heliAng = ((F._heliAng or 0) + spin * dt) % 360
local tilt = 0
if F._heliMode == 2 then
tilt = math.rad(math.clamp(tonumber(C.HeliTilt) or 90, 0, 90))
end
local axis = F.HeliAxis()
local R
if axis == 2 then
R = CFrame.Angles(tilt, 0, 0) * CFrame.Angles(0, math.rad(F._heliAng), 0)
elseif axis == 3 then
R = CFrame.Angles(math.rad(F._heliAng), 0, 0)
else
R = CFrame.Angles(0, math.rad(F._heliAng), 0) * CFrame.Angles(tilt, 0, 0)
end
if F._heliJoint and F._heliC0r and F._heliP0 then
local Rc0 = F._heliC0r * R
local piv = F._heliPiv or F._heliP0
local off = piv + (Rc0 * (F._heliP0 - piv)) - (Rc0 * F._heliC1inv)
pcall(function() F._heliJoint.C0 = CFrame.new(off) * Rc0 end)
else
pcall(function() h.AutoRotate = false end)
if F._heliMode ~= 2 then
pcall(function() r.CFrame = CFrame.new(r.Position) * R end)
end
end
if F._heliMode ~= 2 then return end
if T.FlyOn then return end
if h.PlatformStand ~= true then pcall(function() h.PlatformStand = true end) end
local mv = Vector3.zero
local cam = workspace.CurrentCamera
if cam then
local look, right = cam.CFrame.LookVector, cam.CFrame.RightVector
if UIS:IsKeyDown(Enum.KeyCode.W) then mv = mv + look end
if UIS:IsKeyDown(Enum.KeyCode.S) then mv = mv - look end
if UIS:IsKeyDown(Enum.KeyCode.A) then mv = mv - right end
if UIS:IsKeyDown(Enum.KeyCode.D) then mv = mv + right end
mv = Vector3.new(mv.X, 0, mv.Z)
if mv.Magnitude > 0.01 then mv = mv.Unit * (tonumber(C.FlyValue) or 60) end
end
local cur = r.Position
local px = (F._heliPX or cur.X) + mv.X * dt
local pz = (F._heliPZ or cur.Z) + mv.Z * dt
local vv = 18
if UIS:IsKeyDown(Enum.KeyCode.Space) then F._heliH = (F._heliH or 0) + vv * dt end
if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then F._heliH = (F._heliH or 0) - vv * dt end
local hh = F._heliH or 0
if hh > 300 then hh = 300 elseif hh < -200 then hh = -200 end
F._heliH = hh
local tY = (F._heliBaseY or cur.Y) + hh
local cy = F._heliPY or cur.Y
local ny = cy + (tY - cy) * math.clamp(dt * 8, 0, 1)
if math.abs(tY - ny) < 0.02 then ny = tY end
F._heliPX, F._heliPY, F._heliPZ = px, ny, pz
pcall(function() r.AssemblyLinearVelocity = Vector3.zero end)
pcall(function() r.AssemblyAngularVelocity = Vector3.zero end)
local base = CFrame.new(px, ny, pz) * CFrame.Angles(0, math.rad(F._heliYaw or 0), 0)
pcall(function() r.CFrame = F._heliUseRoot and (base * R) or base end)
end)
if not F._heliRebuild then
pcall(function()
F._heliRebuild = LP.CharacterAdded:Connect(function()
task.wait(0.6)
if not T.HeliOn then return end
F.Out("[旋转] 检测到重生 ⇒ 已自动重装")
pcall(function() F.HeliSet(true) end)
end)
end)
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
local ncLast = 0
local function noclip()
if not T.NoClip then pcall(F.NoClipDisable) return end
local ch = LP.Character
if not ch then return end
local now = os.clock()
if now - ncLast < 0.3 then return end
ncLast = now
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
F.HideConn, F._hideHip, F._hideCharConn = nil, nil, nil
function F.HideDisable()
if F.HideConn then F.HideConn:Disconnect() F.HideConn = nil end
if F._hideCharConn then pcall(function() F._hideCharConn:Disconnect() end) F._hideCharConn = nil end
pcall(function()
local _, hum = GC()
if hum and F._hideHip ~= nil then hum.HipHeight = F._hideHip end
end)
F._hideHip = nil
end
function F.HideEnable()
if F.HideConn then return end
local _, hum0, root0 = GC()
if not (hum0 and root0) then F.Out("[藏地下] 现在没有角色, 等进游戏再开") return end
local function hideDepth()
local d = math.abs(math.min(math.max(tonumber(C.HideDepth) or 5, -60), 60))
if d < 3 then d = 3 end
return d
end
local function apply()
local _, hum = GC()
if not hum then return end
if F._hideHip == nil then F._hideHip = hum.HipHeight end
pcall(function() hum.HipHeight = -hideDepth() end)
end
apply()
if not F._hideCharConn then
pcall(function()
F._hideCharConn = LP.CharacterAdded:Connect(function()
task.wait(0.8)
if not T.Hide then return end
F._hideHip = nil
apply()
F.Out("[藏地下] 检测到重生 ⇒ 已按新角色重新下沉")
end)
end)
end
F.HideConn = RS.Heartbeat:Connect(function()
if not T.Hide then F.HideDisable() return end
if os.clock() - (F._hideAt or 0) < 0.1 then return end
F._hideAt = os.clock()
apply()
end)
F.Out("[藏地下] 已开: 模型整体下沉 " .. tostring(hideDepth())
.. " 格 —— 你的 HumanoidRootPart 还在原位, 所以移动/跳跃/交互完全正常; 别人看到的是你沉在地下的模型(不靠改透明度, 透明度检测抓不到)")
end
F.savedLight = nil
F._godLoop, F._godAt = nil, 0
F.GodKillDied = function(hum)
if not hum then return 0 end
local n = 0
if F._godConns == nil then F._godConns = {} end
if type(getconnections) == "function" then
pcall(function()
local conns = getconnections(hum.Died)
if type(conns) == "table" then
local i
for i = 1, #conns do
local c = conns[i]
if c ~= nil and F._godConns[c] == nil then
F._godConns[c] = true
n = n + 1
if type(c.Disable) == "function" then
pcall(function() c:Disable() end)
else
pcall(function() c:Disconnect() end)
F._godConnHard = (F._godConnHard or 0) + 1
end
end
end
end
end)
end
if n > 0 and not F._godDiedLogged then
F._godDiedLogged = true
F.Out("[上帝模式] 已临时屏蔽 " .. tostring(n) .. " 条死亡事件(用「禁用」不用「断开」⇒ 关掉时能原样恢复)")
end
return n
end
F.GodRestoreDied = function()
if type(F._godConns) ~= "table" then return 0 end
local n = 0
for c in pairs(F._godConns) do
pcall(function()
if type(c.Enable) == "function" then
c:Enable()
n = n + 1
end
end)
end
local hard = tonumber(F._godConnHard) or 0
if hard > 0 then
F.Out("[上帝模式] ⚠ 有 " .. tostring(hard) .. " 条死亡事件是被「断开」的(你的执行器不支持禁用/启用) ⇒ 这几条只能等重生或重载脚本才回来")
end
F._godConns, F._godConnHard, F._godDiedLogged = {}, nil, nil
return n
end
F.GodSnap = function(hum)
if not hum then return end
if F._godOrig and F._godOrig.hum == hum then return end
local o = { hum = hum }
pcall(function() o.maxHealth = hum.MaxHealth end)
pcall(function() o.requiresNeck = hum.RequiresNeck end)
pcall(function() o.breakJoints = hum.BreakJointsOnDeath end)
pcall(function() o.deadState = hum:GetStateEnabled(Enum.HumanoidStateType.Dead) end)
F._godOrig = o
F._godConns = {}
F._godConnHard = nil
end
F.GodTickLoop = function()
if F._godLoop then return end
F._godLoop = RS.Heartbeat:Connect(function()
if not T.GodMode then
pcall(F.GodModeSet, false)
return
end
local now = os.clock()
if now - (F._godAt or 0) < 0.25 then return end
F._godAt = now
local _, hum = GC()
if not hum then return end
pcall(function() F.GodSnap(hum) end)
if F.GodTopUp(hum, true) then F.HpFixNote(1) end
pcall(function()
if type(hookfunction) == "function" and not F._godTDHook then
local orig = hum.TakeDamage
if type(orig) == "function" then
F._godTDOrig = orig
local nk = function(...) return nil end
if type(newcclosure) == "function" then
local okW, w = pcall(newcclosure, nk)
if okW and type(w) == "function" then nk = w end
end
hookfunction(orig, nk)
F._godTDNew = nk
F._godTDHook = true
end
end
end)
end)
end
F.GodTopUp = function(hum, allowZero)
if not hum then return false end
local mx = hum.MaxHealth
if type(mx) ~= "number" or mx ~= mx or mx <= 0 then return false end
local hp = hum.Health
if type(hp) ~= "number" or hp ~= hp then return false end
if hp >= mx then return false end
if hp <= 0 and allowZero ~= true then return false end
pcall(function() hum.Health = mx end)
return true
end
F.HpFixNote = function(n)
if n < 1 then return end
F._hpFixN = (F._hpFixN or 0) + n
local now = os.clock()
if now - (F._hpFixLog or 0) < 6 then return end
F._hpFixLog = now
local total = F._hpFixN
F._hpFixN = 0
if total >= 12 then
F.Out("[锁血] ⚠ 最近 6 秒内血量被外部压低 " .. tostring(total) .. " 次 ⇒ 本游戏是「服务端裁决」："
.. "服务端说了算, 客户端只能反复补血。想真正不死, 需要「被命中前避免」或「死了立刻用游戏自己的复活通道复活」(见维护文档)")
elseif total > 0 then
F.Out("[锁血] 最近 6 秒补血 " .. tostring(total) .. " 次")
end
end
F.DMG_KEYS = { "hurt","damage","dmg","blood","bleed","injur","wound","vignette","lowhp","low_hp","lowhealth","low_health","redflash","red_flash","screenfx","screeneffect","screen_effect","healthwarn","health_warn","got_hit","getting_hit" }
F.SCR_KEYS = { "jumpscare","jump_scare","scare","strobe","screenflash","screen_flash","flashfx","flash_fx","flashoverlay","flasheffect","whiteout","white_out","blackout","black_out","redout","red_out","fade","static","glitch","noise","scanline","scan_line","distortion","chromatic","aberration","vhs","filmgrain","film_grain","grain","screeneffect","screenfx","screen_effect","fullscreen","overlay","blur" }
F._dmgFx, F._dmgAt = {}, 0
F.DmgFxOn = function() return (T.GodMode or T.LockHealth or T.NoScreenFx == true) and true or false end
F.DmgFxKind = function(o)
local k = nil
pcall(function()
if o:IsA("Frame") then k = "frame"
elseif o:IsA("ImageLabel") or o:IsA("ImageButton") then k = "image"
elseif o:IsA("TextLabel") or o:IsA("TextButton") then k = "text"
end
end)
return k
end
F.DmgFxNamed = function(o)
local nm = nil
pcall(function() nm = string.lower(tostring(o.Name)) end)
if nm == nil then return false end
local i
for i = 1, #F.DMG_KEYS do if string.find(nm, F.DMG_KEYS[i], 1, true) then return true end end
if T.NoScreenFx == true then
for i = 1, #F.SCR_KEYS do if string.find(nm, F.SCR_KEYS[i], 1, true) then return true end end
end
return false
end
F.DmgFxBigRed = function(o, k)
local vp = nil
pcall(function() local c = workspace.CurrentCamera if c then vp = c.ViewportSize end end)
if vp == nil or vp.X <= 0 or vp.Y <= 0 then return false end
local sz = nil
pcall(function() sz = o.AbsoluteSize end)
if sz == nil or sz.X <= 0 or sz.Y <= 0 then return false end
if (sz.X * sz.Y) < (vp.X * vp.Y) * 0.6 then return false end
local tr, cc = 1, nil
if k == "frame" or k == "text" then
pcall(function() tr = o.BackgroundTransparency cc = o.BackgroundColor3 end)
else
pcall(function() tr = o.ImageTransparency cc = o.ImageColor3 end)
end
if type(tr) ~= "number" or tr > 0.9 then return false end
if cc == nil then return true end
return (cc.R >= 0.7 and cc.G <= 0.55 and cc.B <= 0.55)
end
F.DmgFxScan = function()
if not F.DmgFxOn() then return 0 end
local roots = {}
pcall(function() if LP then local pg = LP:FindFirstChildOfClass("PlayerGui") if pg then roots[#roots + 1] = pg end end end)
pcall(function() if type(gethui) == "function" then local h = gethui() if h and h ~= roots[1] then roots[#roots + 1] = h end end end)
local n, ri, i = 0, 0, 0
for ri = 1, #roots do
local objs = F.walk(roots[ri], 6000, 600)
for i = 1, #objs do
local o = objs[i]
local k = F.DmgFxKind(o)
if k ~= nil and F._dmgFx[o] == nil and (F.DmgFxNamed(o) or F.DmgFxBigRed(o, k)) and not F.CM_OWNED(o) then
local rec = nil
pcall(function()
if k == "image" then
rec = { o = o, p = "ImageTransparency", v = o.ImageTransparency }
else
rec = { o = o, p = "BackgroundTransparency", v = o.BackgroundTransparency }
end
end)
if rec ~= nil then
F._dmgFx[o] = rec
pcall(function() o[rec.p] = 1 end)
n = n + 1
end
end
end
end
return n
end
F.DmgFxRestore = function(keepRed)
local n, kept = 0, 0
for o, rec in pairs(F._dmgFx) do
if rec ~= nil and rec.o ~= nil then
local cur = nil
pcall(function() cur = rec.o[rec.p] end)
if cur ~= nil and cur >= 0.999 then
local base = tonumber(rec.v) or 1
if keepRed and base < 0.9 then
kept = kept + 1
else
pcall(function() rec.o[rec.p] = base end)
n = n + 1
end
end
end
F._dmgFx[o] = nil
end
return n, kept
end
F.DmgFxThaw = function()
pcall(function()
local _, hum = GC()
if not hum then return end
local mx = hum.MaxHealth
if type(mx) ~= "number" or mx ~= mx or mx <= 0 or mx > 1e5 then return end
hum.MaxHealth = mx + 0.01
hum.MaxHealth = mx
end)
end
F.DmgFxStop = function()
if F._dmgLoop then pcall(function() F._dmgLoop:Disconnect() end) F._dmgLoop = nil end
local n = F.DmgFxRestore(false)
if n > 0 then F.Out("[受伤红屏] 已停: 还原 " .. tostring(n) .. " 个覆盖层") end
end
F.ScrFxSet = function(on)
T.NoScreenFx = on and true or false
if T.NoScreenFx then
F.Out("[关屏幕特效] 已开: 隐藏画面上的惊吓/闪屏/黑屏/噪点/扭曲类覆盖层(只动覆盖层的透明度, 不改灯光、不动伽马、不改游戏状态)")
pcall(F.DmgFxLoop)
else
if F.DmgFxOn() then
F.Out("[关屏幕特效] 已关(上帝模式/锁血还在 ⇒ 受伤红屏抑制继续生效)")
else
if F._dmgLoop then pcall(function() F._dmgLoop:Disconnect() end) F._dmgLoop = nil end
local n = F.DmgFxRestore(false)
F.Out("[关屏幕特效] 已关: 还原 " .. tostring(n) .. " 个覆盖层")
end
end
end
F.DmgFxLoop = function()
if F._dmgLoop then return end
F._dmgLoop = RS.Heartbeat:Connect(function()
if not F.DmgFxOn() then
if next(F._dmgFx) ~= nil then
local n, kept = F.DmgFxRestore(true)
if n > 0 or kept > 0 then
F.Out("[受伤红屏] 已关: 还原 " .. tostring(n) .. " 个 · 保留隐藏 " .. tostring(kept) .. " 个受伤层(防红边残留)")
end
end
pcall(F.DmgFxThaw)
if F._dmgLoop then pcall(function() F._dmgLoop:Disconnect() end) F._dmgLoop = nil end
return
end
local now = os.clock()
if now - (F._dmgAt or 0) < 0.5 then return end
F._dmgAt = now
local n = F.DmgFxScan()
if n > 0 then
local tag = "受伤红屏"
if T.NoScreenFx == true and not (T.GodMode or T.LockHealth) then tag = "关屏幕特效" end
F.Out("[" .. tag .. "] 已屏蔽 " .. tostring(n) .. " 个覆盖层(只压透明度, 关掉即还原)")
end
end)
end
local LockHealthEnable, LockHealthDisable
F.GodModeSet = function(on)
T.GodMode = on and true or false
T.God = T.GodMode
T.LockHealth = T.GodMode or (T.LockHealthSolo == true)
T.AntiRagdoll = T.GodMode
if T.GodMode then
pcall(function() local _, hh = GC() F.GodSnap(hh) end)
pcall(LockHealthEnable)
pcall(F.AntiRagdollEnable)
F.GodTickLoop()
pcall(F.DmgFxLoop)
pcall(function()
local _, hum = GC()
if F.GodTopUp(hum, true) then F.HpFixNote(1) end
if hum then
F.Out("[上帝模式] 已开: 血量锁在「游戏默认上限」MaxHealth="
.. tostring(math.floor(tonumber(hum.MaxHealth) or 0))
.. " ⇒ 不改 MaxHealth、不禁用任何游戏状态(死亡/生成/重生流程都交给游戏自己)")
end
end)
else
pcall(GodDisable)
pcall(F.AntiRagdollDisable)
pcall(F.DmgFxStop)
if F._godLoop then pcall(function() F._godLoop:Disconnect() end) F._godLoop = nil end
pcall(function()
if F._godTDHook and F._godTDOrig then
local okR = false
if type(restorefunction) == "function" then
okR = pcall(restorefunction, F._godTDOrig)
end
if not okR and F._godTDNew ~= nil and type(hookfunction) == "function" then
pcall(function() hookfunction(F._godTDNew, F._godTDOrig) end)
end
end
end)
F._godTDHook, F._godTDOrig, F._godTDNew = nil, nil, nil
if not T.LockHealthSolo then pcall(LockHealthDisable) end
F.Out("[上帝模式] 已关")
end
end
F.GodRefill = function()
local _, hum = GC()
if hum then
pcall(function() hum.Health = hum.MaxHealth end)
F.Out("[生命] 已回满血")
else
F.Out("[生命] 没有角色(还没加载/已死亡)")
end
end
F.LightReassert = function()
if not (T.FullBright or T.NightVision or T.NoFog) then return end
local L = game:GetService("Lighting")
if not L then return end
if T.FullBright then
if L.Brightness ~= 2 or L.FogEnd ~= 100000 or L.FogStart ~= 100000 then pcall(F.FullBrightEnable) end
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
F.Out("[夜视] 已挂复写监听: 游戏把光照改回去会自动重设")
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
F.savedLight = { Brightness = L.Brightness, ClockTime = L.ClockTime, FogEnd = L.FogEnd, FogStart = L.FogStart, GlobalShadows = L.GlobalShadows, Ambient = L.Ambient, OutdoorAmbient = L.OutdoorAmbient, ExposureCompensation = L.ExposureCompensation }
end
L.Brightness = 2 L.ClockTime = 14 L.FogEnd = 100000 L.FogStart = 100000 L.GlobalShadows = false
L.Ambient = Color3.fromRGB(120, 120, 120) L.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
end
function F.FullBrightDisable()
local L = game:GetService("Lighting")
if not F.savedLight then return end
L.Brightness = F.savedLight.Brightness L.ClockTime = F.savedLight.ClockTime L.FogEnd = F.savedLight.FogEnd
L.FogStart = F.savedLight.FogStart or L.FogEnd
L.GlobalShadows = F.savedLight.GlobalShadows L.Ambient = F.savedLight.Ambient L.OutdoorAmbient = F.savedLight.OutdoorAmbient
end
F.savedNV = nil
function F.NightVisionEnable()
local L = game:GetService("Lighting")
if not F.savedNV then F.savedNV = { Brightness = L.Brightness, Ambient = L.Ambient, OutdoorAmbient = L.OutdoorAmbient } end
L.Brightness = math.max(tonumber(L.Brightness) or 0, 1.8)
L.Ambient = Color3.fromRGB(110, 110, 110)
L.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
end
function F.NightVisionDisable()
local L = game:GetService("Lighting")
if not F.savedNV then return end
L.Brightness = F.savedNV.Brightness L.Ambient = F.savedNV.Ambient
if F.savedNV.OutdoorAmbient then L.OutdoorAmbient = F.savedNV.OutdoorAmbient end
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
F._tpAt = os.clock()
pcall(function() root.CFrame = cf end)
F._tpOwnInfo = own
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
F._tpAt = os.clock()
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
local _, hum, root = GC()
if not root or not target then return end
local function say(m) F.Out("[传送] " .. m) end
local tname = tostring(target.Name)
say("开始 → 「" .. tname .. "」")
local tchar = nil
pcall(function() tchar = target.Character end)
if not (tchar and tchar.Parent) then
local t0 = os.clock()
repeat
task.wait(0.1)
pcall(function() tchar = target.Character end)
until (tchar and tchar.Parent) or (os.clock() - t0 > 3)
end
if not (tchar and tchar.Parent) then
say("❌ 拿不到「" .. tname .. "」的角色(等 3 秒仍为空) ⇒ 他大概在你这个「世界/区块」之外, 客户端根本没加载他的模型")
return
end
local troot = tchar:FindFirstChild("HumanoidRootPart") or tchar.PrimaryPart
if not troot then
local t0 = os.clock()
repeat
task.wait(0.1)
troot = tchar:FindFirstChild("HumanoidRootPart") or tchar.PrimaryPart
until troot or (os.clock() - t0 > 2)
end
if not troot then
say("❌ 拿不到「" .. tname .. "」的 HumanoidRootPart ⇒ 他的模型只加载了一部分(串流中), 取不到坐标")
return
end
local tp = troot.Position
local dist = (tp - root.Position).Magnitude
say(string.format("目标坐标已拿到 · 距离 %.0f 格 ⇒ 开始瞬移", dist))
pcall(function() root:SetNetworkOwner(LP) end)
pcall(function() root:SetNetworkOwnershipAuto(false) end)
local from = root.Position
local delta = tp - from
local STEP = 300
local steps = math.max(1, math.ceil(dist / STEP))
if steps > 60 then steps = 60 end
for i = 1, steps do
if not (root and root.Parent) then break end
local p = from + delta * (i / steps)
pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
pcall(function() root.CFrame = CFrame.new(p + Vector3.new(0, 2, 0)) end)
task.wait()
end
local t0 = os.clock()
local tries, dEnd = 0, dist
while os.clock() - t0 < 1.5 do
if not (root and root.Parent) then break end
tries = tries + 1
pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
pcall(function() root.CFrame = CFrame.new(tp + Vector3.new(0, 3, 0)) end)
task.wait()
pcall(function() dEnd = (root.Position - tp).Magnitude end)
if dEnd < 8 then break end
end
pcall(function() root:SetNetworkOwnershipAuto(true) end)
if dEnd < 8 then
say(string.format("✅ 已到「%s」身旁 (当时距离 %.0f 格 · 分 %d 段 · 顶 %d 次 · 耗 %.2fs)",
tname, dist, steps, tries, os.clock() - t0))
else
say(string.format("❌ 没到位(仍差 %.0f 格) · 已分 %d 段走 + 连顶 %d 次全被拉回 ⇒ 本服位移由服务端裁决(游戏的世界/区域系统会把你拉回), 不是脚本的距离限制",
dEnd, steps, tries))
end
end
F.WORLD_LIST = {
{ id = "World1", en = "WORLD 1", cn = "主世界" },
{ id = "World2", en = "PIRATE WORLD", cn = "海盗世界" },
{ id = "World3", en = "SPACE WORLD", cn = "太空世界" },
{ id = "World4", en = "CHOCOLATE FACTORY", cn = "巧克力工厂" },
{ id = "World5", en = "DRAGON VOLCANO", cn = "龙火火山" },
}
F.WorldLabels = function()
local t = {}
for i = 1, #F.WORLD_LIST do
local w = F.WORLD_LIST[i]
t[i] = w.id .. " · " .. w.en .. "(" .. w.cn .. ")"
end
return t
end
F.WorldDesc = function(id)
for i = 1, #F.WORLD_LIST do
local w = F.WORLD_LIST[i]
if w.id == id then return w.en .. "(" .. w.cn .. ")" end
end
return tostring(id)
end
F.WorldById = function(v)
if type(v) ~= "string" then return nil end
for i = 1, #F.WORLD_LIST do
local w = F.WORLD_LIST[i]
if v == w.id then return w.id end
end
local low = string.lower(v)
for i = 1, #F.WORLD_LIST do
local w = F.WORLD_LIST[i]
if string.find(low, string.lower(w.id), 1, true) then return w.id end
end
return nil
end
F.WorldAttr = function()
if F._wAttr ~= nil then return F._wAttr or nil end
local nm = nil
pcall(function()
local at = LP:GetAttributes()
if type(at) ~= "table" then return end
for k, v in pairs(at) do
if type(k) == "string" and type(v) == "string" and string.find(v, "^World%d+$") then nm = k break end
end
end)
if not nm then
local ok, v = pcall(function() return LP:GetAttribute("SkippingWorld") end)
if ok and type(v) == "string" and v ~= "" then nm = "SkippingWorld" end
end
F._wAttr = nm or false
return nm
end
F.MyWorld = function()
local nm = F.WorldAttr()
if not nm then return nil end
local v = nil
pcall(function() v = LP:GetAttribute(nm) end)
if type(v) == "string" and v ~= "" then return v end
return nil
end
F.WorldBox = function()
if F._wBox ~= nil then return F._wBox or nil end
local c = nil
pcall(function() c = workspace:FindFirstChild("SkippingWorlds") end)
if not c then
pcall(function()
for _, d in ipairs(workspace:GetChildren()) do
local nm = string.lower(d.Name)
if string.find(nm, "skippingworld", 1, true) or nm == "worlds" then c = d break end
end
end)
end
F._wBox = c or false
return c
end
F.WorldModel = function(id)
local c = F.WorldBox()
if not c or type(id) ~= "string" then return nil end
local m = nil
pcall(function() m = c:FindFirstChild(id) end)
return m
end
F.WorldSpot = function(m)
if not m then return nil end
local p = nil
pcall(function()
local wp = m:FindFirstChild("WorldPortal") or m:FindFirstChild("Portal")
if wp then
local oz = wp:FindFirstChild("OpenZone", true) or wp:FindFirstChild("PortalSurface", true) or wp:FindFirstChildWhichIsA("BasePart", true)
if oz and oz:IsA("BasePart") then p = oz.Position end
end
end)
if not p then pcall(function() if m.PrimaryPart then p = m.PrimaryPart.Position end end) end
if not p then pcall(function() local b = m:FindFirstChildWhichIsA("BasePart", true) if b then p = b.Position end end) end
return p
end
F.BlinkTo = function(spot, label)
local _, _, root = GC()
if not (root and spot) then return false end
local from = root.Position
local dist = (spot - from).Magnitude
pcall(function() root:SetNetworkOwnershipAuto(false) end)
local delta = spot - from
local STEP = 300
local steps = math.max(1, math.ceil(dist / STEP))
if steps > 60 then steps = 60 end
for i = 1, steps do
if not (root and root.Parent) then break end
local p = from + delta * (i / steps)
pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
pcall(function() root.CFrame = CFrame.new(p + Vector3.new(0, 3, 0)) end)
task.wait()
end
local t0 = os.clock()
local tries, dEnd = 0, dist
while os.clock() - t0 < 1.5 do
if not (root and root.Parent) then break end
tries = tries + 1
pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
pcall(function() root.CFrame = CFrame.new(spot + Vector3.new(0, 3, 0)) end)
task.wait()
pcall(function() dEnd = (root.Position - spot).Magnitude end)
if dEnd < 10 then break end
end
pcall(function() root:SetNetworkOwnershipAuto(true) end)
F.Out(string.format("[世界] %s · 原距 %.0f格 · 分 %d 段 · 顶 %d 次 ⇒ %s",
tostring(label), dist, steps, tries, (dEnd < 10) and "到位" or string.format("差 %.0f格(被拉回)", dEnd)))
return dEnd < 10
end
F.WorldDiag = function()
local _, _, root = GC()
local my = F.MyWorld()
F.Out("[世界] 我在: " .. (my and (my .. " = " .. F.WorldDesc(my)) or "(没读到属性 ⇒ 可能不是这个机制)"))
F.Out("[世界] 世界属性名: " .. tostring(F.WorldAttr() or "(没找到)"))
local c = F.WorldBox()
if not c then
F.Out("[世界] ❌ 没找到 workspace.SkippingWorlds ⇒ 这游戏可能不是「同 place 多区域」结构")
return
end
local full = "?"
pcall(function() full = c:GetFullName() end)
local kids = {}
pcall(function() kids = c:GetChildren() end)
F.Out("[世界] " .. full .. " 下有 " .. tostring(#kids) .. " 个模型:")
for i = 1, #kids do
local m = kids[i]
local p = F.WorldSpot(m)
local extra = ""
if p and root then
extra = string.format(" @ (%.0f,%.0f,%.0f) 距离 %.0f格", p.X, p.Y, p.Z, (p - root.Position).Magnitude)
end
F.Out("   · " .. m.Name .. " (" .. m.ClassName .. ")" .. extra)
end
end
F.WorldGoto = function(pick)
local id = F.WorldById(pick)
if not id then F.Out("[世界] 先在上面「目标世界」里选一个") return end
local _, _, root = GC()
if not root then F.Out("[世界] 没角色, 先进游戏") return end
local my = F.MyWorld()
F.Out("[世界] 现在 " .. tostring(my or "?") .. " ⇒ 目标 " .. id .. " (" .. F.WorldDesc(id) .. ")")
if C.WorldAttrSync == true then
local nm = F.WorldAttr()
local okA = false
if nm then pcall(function() LP:SetAttribute(nm, id) okA = true end) end
F.Out("[世界] 本地属性 " .. tostring(nm or "?") .. " 改成 " .. id .. (okA and " ✓(仅本地, 服务端不认)" or " ✗(改不了)"))
task.wait(0.4)
end
local m = F.WorldModel(id)
if not m then
F.Out("[世界] ⚠ " .. id .. " 的场景没加载 ⇒ 飞不过去。可点「用录到的命令换世界」, 或先在游戏里正常去一次")
return
end
local spot = F.WorldSpot(m)
if not spot then F.Out("[世界] ⚠ 模型「" .. m.Name .. "」里取不到可用坐标") return end
F.Out("[世界] 目标模型 " .. m.Name .. " 已找到 ⇒ 开始飞")
F.BlinkTo(spot, "去 " .. id)
end
F.WorldRemote = function()
local re = nil
pcall(function()
local rs = game:GetService("ReplicatedStorage")
local sn = rs:FindFirstChild("SkippingNetwork")
if sn then
local r = sn:FindFirstChild("Request")
if r and r:IsA("RemoteEvent") then re = r end
end
if not re then
for _, d in ipairs(rs:GetDescendants()) do
if d:IsA("RemoteEvent") and d.Name == "Request" then re = d break end
end
end
end)
return re
end
F.WorldCmd = function(pick)
local id = F.WorldById(pick)
if not id then F.Out("[世界] 先在上面「目标世界」里选一个") return end
local re = F.WorldRemote()
if not re then F.Out("[世界] ❌ 找不到 SkippingNetwork.Request 远程对象") return end
local full = "?"
pcall(function() full = re:GetFullName() end)
F.Out("[世界] 远程 = " .. full)
local guesses = { "EnterWorld", "TravelWorld", "SetWorld", "JoinWorld" }
F.Out("[世界] 盲试 " .. tostring(#guesses) .. " 个常见命令名 × 2 种载荷(服务端不认会被忽略)")
for i = 1, #guesses do
local c = guesses[i]
pcall(function() re:FireServer(c, id) end)
pcall(function() re:FireServer(c, { WorldId = id }) end)
F.Out("[世界]   已试 " .. c)
task.wait(0.15)
end
F.Out("[世界] 已发完 · 5 秒后看你在的世界/位置有没有变")
end
F.CM_OWNED = function(o)
local p, n = o, 0
while p and n < 14 do
local own = false
pcall(function() own = (p:GetAttribute("CMOwned") == true) end)
if own then return true end
local nm = nil
pcall(function() nm = string.lower(tostring(p.Name)) end)
if nm and (string.find(nm, "cheatmenu", 1, true) or string.find(nm, "fluent", 1, true) or string.find(nm, "cmtouch", 1, true)) then
return true
end
local up = nil
pcall(function() up = p.Parent end)
if up == nil then break end
p = up
n = n + 1
end
return false
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
F.Out(string.format("[点位] 传送到「%s」 · 距离 %.0f 格 · %s · 已抢所有权 %d 个部件(不依赖加速/飞行)",
tostring(it.name), dist,
ok and "已到位" or ("没到位(还差 " .. string.format("%.0f", now2 or -1) .. " 格)"),
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
if F._risk == nil then task.spawn(function() pcall(F.ScanClientChecks, false) end) end
local risk = tonumber(F._risk)
if risk == 0 then
F.Out("[绕过防护] " .. tostring(why) .. " ⇒ 本服客户端没扫到防加速/拉回检测(脚本 0 · 可疑连接 0)"
.. " ⇒ 不自动升档(保持现状, 省性能)。若真被拉回, 手动把「防护档位」开到 ②")
return
end
local rs, rc = tonumber(F._riskScripts) or 0, tonumber(F._riskConns) or 0
if risk == nil then
T.BypassTier = "② + 防护/反拉回/伪装(稳身·受击·陷阱·抢所有权·钉位·读原值)"
F.Out("[绕过防护] " .. tostring(why) .. " ⇒ 本服还没扫过检测 ⇒ 按保守值自动升到 ②(反拉回+伪装)")
else
T.BypassTier = "② + 防护/反拉回/伪装(稳身·受击·陷阱·抢所有权·钉位·读原值)"
F.Out("[绕过防护] " .. tostring(why) .. " ⇒ 本服检测: 脚本 " .. tostring(rs) .. " 个 · 可疑连接 "
.. tostring(rc) .. " 条 ⇒ 自动升到 ② 反拉回+伪装, 免得被服务端拉回/换位置")
end
pcall(F.BypassTierApply, T.BypassTier)
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
if not wants.guard then
T.GuardOn, T.SpeedGuard, T.Spoof = false, false, false
pcall(function() F.GuardSet(false, false, false, false) end)
F.Try("SpeedGuardDisable", F.SpeedGuardDisable)
F.Try("SpoofDisable", F.SpoofDisable)
else
T.GuardOn = false
pcall(function() F.GuardSet(true, true, false, false) end)
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
F._pinConn = nil
F.MyEggSet = function(on)
T.MyEgg = on and true or false
if F._eggLoop then F._eggLoop = false end
if not on then
F._myEgg = nil
if F._eggDropConns then
for _, c in ipairs(F._eggDropConns) do pcall(function() c:Disconnect() end) end
F._eggDropConns = nil
F.Out("[护蛋] 已关(掉落广播监听已断开)")
else
F.Out("[护蛋] 已关")
end
return
end
F.Out("[护蛋] 已开: 只盯你自己拿起的那一个 —— 它掉地/被夺就立刻瞬间偷回手里(不会去抢别人的)。每 0.05 秒检查一次, 掉了立刻重拿/重新装备")
if F._eggUnEq then pcall(function() F._eggUnEq:Disconnect() end) F._eggUnEq = nil end
if F._eggCharConn then pcall(function() F._eggCharConn:Disconnect() end) F._eggCharConn = nil end
if F._eggUnEqList then
for _, c in ipairs(F._eggUnEqList) do pcall(function() c:Disconnect() end) end
end
F._eggUnEqList = {}
F._eggHookedTools = {}
F._eggUnEqHits = 0
F._eggUnEqWin = os.clock()
F._eggUnEqAt = 0
F._eggBreakUntil = 0
F._eggPollAt = 0
F._eggTries = 0
F._eggTryWin = os.clock()
pcall(function()
local ch = GC()
if ch then
local function hookTool(tool)
if F._eggHookedTools[tool] then return end
F._eggHookedTools[tool] = true
pcall(function()
local c = tool.Unequipped:Connect(function()
if not T.MyEgg then return end
local now = os.clock()
if now - (F._eggUnEqWin or 0) > 5 then F._eggUnEqWin = now F._eggUnEqHits = 0 end
F._eggUnEqHits = (F._eggUnEqHits or 0) + 1
if F._eggUnEqHits > 10 then
F._eggBreakUntil = now + 6
F._eggUnEqHits = 0
F._eggUnEqWin = now
if now - (F._eggBreakLog or 0) > 6 then
F._eggBreakLog = now
F.Out("[护蛋] 服务器在反复卸下你的蛋(5秒内超10次) ⇒ 已自动停手 6 秒, 不再死循环抢装(之前就是这里把你卡死的)")
end
return
end
if now < (F._eggBreakUntil or 0) then return end
if now - (F._eggUnEqAt or 0) < 0.5 then return end
F._eggUnEqAt = now
task.spawn(function()
task.wait(0.1)
local ch2, hum2 = GC()
pcall(function() if ch2 and hum2 and tool.Parent == LP:FindFirstChildOfClass("Backpack") then hum2:EquipTool(tool) end end)
end)
end)
table.insert(F._eggUnEqList, c)
end)
end
local cur = ch:FindFirstChildOfClass("Tool")
if cur then hookTool(cur) end
F._eggCharConn = ch.ChildAdded:Connect(function(c)
if c:IsA("Tool") then hookTool(c) end
end)
end
end)
if F._eggDropConns then
for _, c in ipairs(F._eggDropConns) do pcall(function() c:Disconnect() end) end
end
F._eggDropConns = {}
F._eggForce = false
pcall(function()
local rs = game:GetService("ReplicatedStorage")
local n = 0
for _, d in ipairs(rs:GetDescendants()) do
if n >= 12 then break end
if d:IsA("RemoteEvent") then
local nm = string.lower(tostring(d.Name))
local hit = nm:find("dropped", 1, true) or nm:find("owner", 1, true) or nm:find("carry", 1, true)
if hit then
n = n + 1
local ok, c = pcall(function()
return d.OnClientEvent:Connect(function()
if not T.MyEgg then return end
F._eggForce = true
end)
end)
if ok and c then F._eggDropConns[#F._eggDropConns + 1] = c end
end
end
end
if n > 0 then F.Out("[护蛋] 已挂 " .. tostring(n) .. " 条「蛋掉落/归属变更」广播 ⇒ 服务端一提示就立刻找回(不等轮询)") end
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
local nm = tostring(d.Name):lower()
local hit = false
for _, k in ipairs(KEYS) do
if nm:find(k, 1, true) then hit = true break end
end
if hit then
local pp = d:IsA("Model") and (d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart")) or (d:IsA("BasePart") and d) or nil
local dd = pp and (pp.Position - root.Position).Magnitude or 0
if dd <= bestD then best, bestD = d, dd end
end
end
end
if not best then
local op = OverlapParams.new()
op.FilterType = Enum.RaycastFilterType.Exclude
op.FilterDescendantsInstances = { ch }
for _, part in ipairs(workspace:GetPartBoundsInRadius(root.Position, 8, op)) do
local nm = tostring(part.Name):lower()
local hit = false
for _, k in ipairs(KEYS) do
if nm:find(k, 1, true) then hit = true break end
end
if hit then
local dd = (part.Position - root.Position).Magnitude
if dd <= bestD then best, bestD = part, dd end
end
end
end
end)
if best then
F._myEgg = best
pcall(function()
if F._eggParentConn then pcall(function() F._eggParentConn:Disconnect() end) end
F._eggParentConn = best:GetPropertyChangedSignal("Parent"):Connect(function()
F._eggForce = true
end)
end)
F.Out("[护蛋] 已锁定你手上的「" .. tostring(best.Name) .. "」(挂了「离手事件」⇒ 一被卸下立刻找回, 不等轮询)")
pcall(function()
local bp = best:IsA("Model") and (best.PrimaryPart or best:FindFirstChildWhichIsA("BasePart")) or (best:IsA("BasePart") and best) or nil
if bp then
local can = false
pcall(function() can = bp:CanSetNetworkOwnership() end)
if can then
pcall(function() bp:SetNetworkOwner(LP) end)
F.Out("[护蛋] 已抢到蛋的网络所有权(服务端改不动它的位置/归属了)")
end
end
end)
end
end
do
local ch2, hum2 = GC()
if ch2 and hum2 then
local equipped = ch2:FindFirstChildOfClass("Tool")
local now = os.clock()
if not equipped and now >= (F._eggBreakUntil or 0) and now - (F._eggPollAt or 0) >= 0.25 then
F._eggPollAt = now
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
if now - (F._eggTryWin or 0) > 5 then F._eggTryWin = now F._eggTries = 0 end
F._eggTries = (F._eggTries or 0) + 1
if F._eggTries > 10 then
F._eggBreakUntil = now + 6
F._eggTries = 0
F._eggTryWin = now
if now - (F._eggBreakLog2 or 0) > 6 then
F._eggBreakLog2 = now
F.Out("[护蛋] 装回去马上又被卸下(5秒内超10次) ⇒ 已自动停手 6 秒, 不再死循环(避免卡死)")
end
else
pcall(function() hum2:EquipTool(pickTool) end)
F._myEgg = pickTool
if now - (F._eggEquipAt or 0) > 3 then
F._eggEquipAt = now
F.Out("[护蛋] 蛋被卸下了 ⇒ 已立刻重新装备「" .. tostring(pickTool.Name) .. "」")
end
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
local function partOf(o)
local r = nil
pcall(function()
if o then
r = o:IsA("Model") and (o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")) or (o:IsA("BasePart") and o) or nil
end
end)
return r
end
local function promptOf(from, radius)
local pp = nil
pcall(function()
if not from then return end
pp = from:FindFirstChildOfClass("ProximityPrompt")
if not pp and from.Parent then pp = from.Parent:FindFirstChildOfClass("ProximityPrompt") end
if not pp and from.IsDescendantOf and from:IsDescendantOf(workspace) then
local op = OverlapParams.new()
op.FilterType = Enum.RaycastFilterType.Exclude
op.FilterDescendantsInstances = { ch }
local hit = workspace:GetPartBoundsInRadius(from.Position, radius or 220, op)
for _, q in ipairs(hit) do
pp = q:FindFirstChildOfClass("ProximityPrompt")
if not pp and q.Parent then pp = q.Parent:FindFirstChildOfClass("ProximityPrompt") end
if pp then break end
end
end
end)
return pp
end
local function firePrompt(pp)
if not (pp and pp.Parent) then return false end
pcall(function()
pp.HoldDuration = 0
pp.RequiresLineOfSight = false
pp.MaxActivationDistance = 1000000
end)
if type(fireproximityprompt) == "function" then
local ok = pcall(fireproximityprompt, pp)
if ok then return true end
end
local done = false
pcall(function()
pp:InputHoldBegin()
done = true
end)
if done then
task.wait()
pcall(function() pp:InputHoldEnd() end)
end
return done
end
local pp = promptOf(partOf(egg), 220)
if not pp then
pcall(function()
local best, bd, rt = nil, 1e9, nil
pcall(function() local _, _, r = GC() if r then rt = r end end)
if rt then
for _, d in ipairs(workspace:GetDescendants()) do
if d:IsA("Model") or d:IsA("BasePart") or d:IsA("Tool") then
local nm = string.lower(tostring(d.Name))
if nm:find("egg", 1, true) or nm:find("carry", 1, true) then
local bp = partOf(d)
if bp then
local dd = (bp.Position - rt.Position).Magnitude
if dd < bd then best, bd = bp, dd end
end
end
end
end
end
if best then
pp = promptOf(best, 220)
F._eggFoundFar = bd
end
end)
end
if pp and pp.Enabled ~= false then
if firePrompt(pp) then
F._eggHits = (F._eggHits or 0) + 1
if os.clock() - (F._eggStealLogAt or 0) > 3 then
F._eggStealLogAt = os.clock()
F.Out("[护蛋] 掉了一次 ⇒ 已瞬间偷回(累计 " .. tostring(F._eggHits) .. " 次)")
end
elseif os.clock() - (F._eggMissLogAt or 0) > 8 then
F._eggMissLogAt = os.clock()
F.Out("[护蛋] ⚠ 蛋离手, 找到触发点但点不动 ⇒ 游戏可能要求「手持/面向」; 把日志这段发我")
end
elseif os.clock() - (F._eggMissLogAt or 0) > 8 then
F._eggMissLogAt = os.clock()
pcall(function() Fluent:Notify({ Title = "护蛋", Content = "蛋离手了, 但 220 格内和全图都没找到可触发的拿取点", Duration = 6 }) end)
F.Out("[护蛋] ⚠ 蛋离手但 220 格内 + 全图同类都没找到拿取点 ⇒ 该游戏的拿取不走 ProximityPrompt; 建议开「瞬间偷蛋 / 瞬间交互」")
end
end
end
end
local fast = F._eggForce
F._eggForce = false
task.wait(F._myEgg and 0.05 or (fast and 0.05 or 0.25))
end
F._eggLoop = nil
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
F.Try("CarryWatchDisable", F.CarryWatchDisable)
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
end
end)
end)
pcall(function()
F._charEv[#F._charEv + 1] = hum.HealthChanged:Connect(function(hp)
local max = hum.MaxHealth
if max and max > 1 and hp > 0 and hp < max * 0.35 then
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
pcall(function() F.GuardSet(false, false, false, false) end)
end
F.SpeedFreeEnable = function()
if F._sfConn then return end
T.SpeedFree = true
F._sfHits, F._sfAt = 0, 0
F._sfConn = RS.Heartbeat:Connect(function()
if not T.SpeedFree then pcall(F.SpeedFreeDisable) return end
local now = os.clock()
if now - (F._sfAt or 0) < 0.2 then return end
F._sfAt = now
local _, hum = GC()
if not hum then return end
local holding = false
pcall(function()
local ch = LP.Character
holding = (ch ~= nil) and (ch:FindFirstChildOfClass("Tool") ~= nil)
end)
if not holding then return end
if hum.WalkSpeed < 16 then
pcall(function() hum.WalkSpeed = 16 end)
F._sfHits = (F._sfHits or 0) + 1
if now - (F._sfLog or 0) > 5 then
F._sfLog = now
F.Out("[防护·速度] 游戏想在你拿着东西时把你压慢 ⇒ 已挡回(保持 16 正常速度) · 累计 " .. tostring(F._sfHits) .. " 次")
end
end
end)
F.Out("[防护·速度] 已开: 你拿着东西时, 游戏把速度压到 16 以下会被自动挡回 ⇒ 搬东西不会被减速, 服务端看到的仍是正常速度(所以判定不受影响)")
end
F.SpeedFreeDisable = function()
T.SpeedFree = false
if F._sfConn then pcall(function() F._sfConn:Disconnect() end) F._sfConn = nil end
end
F.PosSrcProbeOn = function()
if F.MetaActive("__newindex", "CMPosSrc") then return end
F._posLuaWrites, F._posLuaWho = 0, "?"
pcall(function()
F.MetaInstall("__newindex", game, "CMPosSrc", function(box)
return function(t, k, v)
if checkcaller() then return box.orig(t, k, v) end
if k == "CFrame" or k == "Position" then
local _, _, r = GC()
if r and t == r then
F._posLuaWrites = (F._posLuaWrites or 0) + 1
pcall(function()
if type(debug) == "table" and type(debug.info) == "function" then
local src = debug.info(2, "s")
if src then F._posLuaWho = tostring(src):sub(1, 90) end
end
end)
end
end
return box.orig(t, k, v)
end
end)
end)
task.delay(30, function()
pcall(function() F.MetaUninstall("__newindex", "CMPosSrc") end)
F.Out("[防护·位置来源] 体检 30 秒结束(钩子已自动卸掉, 不再占性能) ⇒ Lua 写入 " .. tostring(F._posLuaWrites or 0)
.. " 次 · 最近来源: " .. tostring(F._posLuaWho or "?")
.. ((F._posLuaWrites or 0) == 0 and " ⇒ 位置不是游戏脚本改的(是引擎复制), 客户端拦不到" or " ⇒ 有脚本在写位置, 可以拦"))
end)
end
F.PosSrcProbeOff = function()
pcall(function() F.MetaUninstall("__newindex", "CMPosSrc") end)
end
F.NoPullEnable = function()
if F._npConn then return end
T.NoPull = true
pcall(F.PosSrcProbeOn)
F._npAt, F._npPos, F._npHits, F._npBack, F._npLog = 0, nil, 0, 0, 0
F._npConn = RS.RenderStepped:Connect(function()
if not T.NoPull then pcall(F.NoPullDisable) return end
local now = os.clock()
if (T.SpeedOn or T.FlyOn or T.Hide) and now - (F._npAt or 0) > 0.1 then
F._npAt = now
local okN, noN = 0, 0
pcall(function()
local ch = LP.Character
local r0 = ch and ch:FindFirstChild("HumanoidRootPart")
if not r0 then return end
local can = true
pcall(function() if r0.CanSetNetworkOwnership then can = r0:CanSetNetworkOwnership() end end)
if can then
local okS = pcall(function() r0:SetNetworkOwner(LP) end)
if okS then okN = okN + 1 else noN = noN + 1 end
else
noN = noN + 1
end
end)
F._npOwn = (F._npOwn or 0) + okN
F._npOwnFail = (F._npOwnFail or 0) + noN
if now - (F._npOwnLog or 0) > 5 then
F._npOwnLog = now
F.Out("[防护·反回拉] 所有权: 抢到 " .. tostring(F._npOwn or 0) .. " 次 · 被拒 " .. tostring(F._npOwnFail or 0) .. " 次"
.. " · 位置被挪 " .. tostring(F._npHits or 0) .. " 次(其中 Lua 写入 " .. tostring(F._posLuaWrites or 0) .. " 次)"
.. ((F._npOwnFail or 0) > 0 and " ⇒ 被拒说明服务端锁了所有权, 那种情况下只能靠下面的『续跑』兜着" or ""))
end
end
local _, _, r = GC()
if not r then return end
local p = r.Position
if now - (F._tpAt or 0) < 0.3 then F._npPos = p return end
local last = F._npPos
F._npPos = p
if not last then return end
local d = (p - last).Magnitude
local spd = 0
if T.FlyOn then spd = tonumber(C.FlyValue) or 0 end
if T.SpeedOn then spd = math.max(spd, tonumber(C.SpeedValue) or 0) end
local thr = spd / 45 + 60
if d > thr then
F._npHits = (F._npHits or 0) + 1
if now - (F._npLog or 0) > 3 then
F._npLog = now
F.Out("[防护·反回拉] 位置被外部挪动 " .. string.format("%.0f", d) .. " 格(正常一帧最多 " .. string.format("%.0f", thr) .. ") ⇒ 已拉回原位 · 累计 " .. tostring(F._npHits) .. " 次")
end
if (F._npBack or 0) <= now then
F._npBack = now + 0.05
pcall(function() r.CFrame = CFrame.new(last) end)
F._npPos = last
end
end
end)
F.Out("[防护·反回拉] 已开: ① 加速/飞行期间持续把角色的网络所有权保持在你这边(只抢所有权, 不动速度) ② 被服务端拉回时自动拉回原位(判据随你的速度自适应, 不会误伤正常移动)")
end
F.NoPullDisable = function()
T.NoPull = false
if F._npConn then pcall(function() F._npConn:Disconnect() end) F._npConn = nil end
pcall(F.PosSrcProbeOff)
end
function F.AllInOneDisableAll()
F.Try("SpeedGuardDisable", F.SpeedGuardDisable)
F.Try("CarryGuardDisable", F.CarryGuardDisable)
F.Try("GuardOnDisable", F.GuardOnDisable)
F.Try("SpeedFreeDisable", F.SpeedFreeDisable)
F.Try("SpoofDisable", F.SpoofDisable)
end
function F.SpoofEnable()
if F._spoofOn then return end
T.Spoof = true
F._spoofOn = true
F._spoofWalkBase = tonumber(F._preSpeed) or nil
F._spoofJumpBase = nil
pcall(F.MetaHookEnsure)
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
F._spoofOn = nil
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
F.GuardPlus = F.GuardPlus or {}
F.GuardPlus.VERSION = "1.0"
F.GuardPlus.on = false
F.GuardPlus.opts = {
poll = 0.05,
hitReload = true,
hitWindow = 0.6,
breakHits = 10,
breakWin = 5,
breakCool = 6,
}
function F.GuardPlus.Char()
return GC()
end
function F.GuardPlus.FindInBag(name)
local ch = F.GuardPlus.Char()
if not ch then return nil end
local bag = LP:FindFirstChildOfClass("Backpack")
if not bag then return nil end
local t = bag:FindFirstChild(name)
if t and t:IsA("Tool") then return t end
return nil
end
function F.GuardPlus.Equip(name)
pcall(function()
local ch, hum = F.GuardPlus.Char()
if not (ch and hum) then return end
local t = F.GuardPlus.FindInBag(name)
if not t then return end
hum:EquipTool(t)
end)
end
function F.GuardPlus.HeldName()
local ch = F.GuardPlus.Char()
if not ch then return nil end
local t = ch:FindFirstChildOfClass("Tool")
return t and t.Name or nil
end
function F.GuardPlus.Tick()
if not F.GuardPlus.on then return end
local o = F.GuardPlus.opts
local now = os.clock()
if now - (F.GuardPlus._gpAt or 0) < o.poll then return end
F.GuardPlus._gpAt = now
local ch, hum = F.GuardPlus.Char()
if not (ch and hum) then
F.GuardPlus._gpHeldName, F.GuardPlus._gpLastHp = nil, nil
return
end
local hp = hum.Health
if F.GuardPlus._gpLastHp and hp < F.GuardPlus._gpLastHp - 0.01 then
F.GuardPlus._gpHitAt = now
end
F.GuardPlus._gpLastHp = hp
local name = F.GuardPlus.HeldName()
if name then
F.GuardPlus._gpHeldName = name
return
end
local prev = F.GuardPlus._gpHeldName
if not prev then return end
if now < (F.GuardPlus._gpBreakUntil or 0) then return end
if now - (F.GuardPlus._gpWin or 0) > o.breakWin then
F.GuardPlus._gpWin = now
F.GuardPlus._gpHits = 0
end
F.GuardPlus._gpHits = (F.GuardPlus._gpHits or 0) + 1
if F.GuardPlus._gpHits > o.breakHits then
F.GuardPlus._gpBreakUntil = now + o.breakCool
F.GuardPlus._gpHits = 0
F.Out("[守卫增强] 服务端在反复卸下你的物品(" .. tostring(o.breakWin) .. "秒内超 "
.. tostring(o.breakHits) .. " 次) ⇒ 已自动停手 " .. tostring(o.breakCool) .. " 秒, 避免死循环抢装")
return
end
local why = "被卸下"
if o.hitReload and (now - (F.GuardPlus._gpHitAt or 0)) <= o.hitWindow then
why = "受击瞬间"
end
task.spawn(function()
task.wait(0.05)
F.GuardPlus.Equip(prev)
end)
F.GuardPlus._gpReloads = (F.GuardPlus._gpReloads or 0) + 1
if now - (F.GuardPlus._gpLogAt or 0) > 3 then
F.GuardPlus._gpLogAt = now
F.Out("[守卫增强] 「" .. tostring(prev) .. "」" .. why .. " ⇒ 已自动重装(累计 "
.. tostring(F.GuardPlus._gpReloads) .. " 次)")
end
end
function F.GuardPlus.Set(on, opts)
on = on and true or false
if type(opts) == "table" then
for k, v in pairs(opts) do
if F.GuardPlus.opts[k] ~= nil and type(v) == type(F.GuardPlus.opts[k]) then
F.GuardPlus.opts[k] = v
end
end
end
if on == F.GuardPlus.on then
F.Out("[守卫增强] 已经是" .. (on and "开启" or "关闭") .. "状态")
return on
end
if on then
F.GuardPlus._gpWin = os.clock()
F.GuardPlus._gpHits = 0
F.GuardPlus._gpReloads = 0
F.GuardPlus._gpBreakUntil = 0
F.GuardPlus._gpHeldName = F.GuardPlus.HeldName()
F.GuardPlus._gpLastHp = nil
local _, hum = F.GuardPlus.Char()
if hum then pcall(function() F.GuardPlus._gpLastHp = hum.Health end) end
if F.GuardPlus._gpConn then pcall(function() F.GuardPlus._gpConn:Disconnect() end) end
F.GuardPlus._gpConn = RS.Heartbeat:Connect(function() pcall(F.GuardPlus.Tick) end)
F.GuardPlus.on = true
F.Out("[守卫增强] 已开: 全背包物品守护 —— 手持物被卸下/被打掉会自动重装"
.. (F.GuardPlus.opts.hitReload and "(含受击瞬间)" or "")
.. " · 每 " .. tostring(F.GuardPlus.opts.poll) .. " 秒检查一次")
else
if F.GuardPlus._gpConn then pcall(function() F.GuardPlus._gpConn:Disconnect() end) F.GuardPlus._gpConn = nil end
F.GuardPlus._gpHeldName, F.GuardPlus._gpLastHp = nil, nil
F.GuardPlus.on = false
F.Out("[守卫增强] 已关")
end
return F.GuardPlus.on
end
function F.GuardPlus.Status()
return {
on = F.GuardPlus.on,
reloads = F.GuardPlus._gpReloads or 0,
conn = F.GuardPlus._gpConn ~= nil,
held = F.GuardPlus._gpHeldName,
}
end
pcall(function()
if type(getgenv) == "function" then
local g = getgenv()
if type(g) == "table" then g.GuardPlus = F.GuardPlus end
end
end)
F.Out("[守卫增强] 模块就绪 v" .. tostring(F.GuardPlus.VERSION) .. " · 控制台 GuardPlus.Set(true) 开启")
F.StealOps = F.StealOps or {}
F.StealOps.VERSION = "1.0"
function F.StealOps.DumpToolRemotes(toolName)
local out = { remotes = {}, strings = {}, tool = nil }
local ch = GC()
if not ch then
F.Out("[操作集] 没有角色，无法读取背包")
return out
end
local bag = LP:FindFirstChildOfClass("Backpack")
if not bag then
F.Out("[操作集] 找不到 Backpack")
return out
end
local tool = bag:FindFirstChild(toolName)
if not tool then
pcall(function() tool = ch:FindFirstChild(toolName) end)
end
if not (tool and tool:IsA("Tool")) then
F.Out("[操作集] 背包/手上都没有工具「" .. tostring(toolName) .. "」")
return out
end
out.tool = tool
local okScan, errScan = pcall(function()
for _, d in ipairs(tool:GetDescendants()) do
if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") or d:IsA("UnreliableRemoteEvent") then
local p = nil
pcall(function() p = d:GetFullName() end)
if not p then pcall(function() p = tool.Name .. "." .. d.Name end) end
out.remotes[#out.remotes + 1] = { obj = d, path = p or d.Name, cls = d.ClassName }
end
end
end)
if not okScan then
F.Out("[操作集] 扫描远程对象时出错(已捕获): " .. tostring(errScan))
end
pcall(function()
for _, d in ipairs(tool:GetDescendants()) do
if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then
local code = nil
pcall(function() if type(decompile) == "function" then code = decompile(d) end end)
if type(code) ~= "string" then
pcall(function() if type(getscriptbytecode) == "function" then code = getscriptbytecode(d) end end)
end
if type(code) == "string" then
for w in code:gmatch("[\"']([%w_%-%.:]+)[\"']") do
if #w >= 3 and #w <= 64 then out.strings[w] = true end
end
end
end
end
end)
F.Out("[操作集] 工具「" .. toolName .. "」内远程对象 " .. tostring(#out.remotes)
.. " 个；脚本字符串常量 " .. tostring((function() local n = 0 for _ in pairs(out.strings) do n = n + 1 end return n end)()) .. " 条")
for i = 1, math.min(#out.remotes, 8) do
F.Out("[操作集]   远程 " .. i .. ": " .. out.remotes[i].cls .. " " .. out.remotes[i].path)
end
return out
end
function F.StealOps.FireToolRemote(toolName, remoteName, ...)
local d = F.StealOps.DumpToolRemotes(toolName)
if #d.remotes == 0 then return false end
local target = nil
for _, r in ipairs(d.remotes) do
if r.obj.Name == remoteName then target = r.obj break end
end
if not target then
F.Out("[操作集] 工具「" .. toolName .. "」里没有名为「" .. tostring(remoteName) .. "」的远程对象")
return false
end
local args = { ... }
local ok, err = pcall(function()
local unpackFn = table.unpack or unpack
if target:IsA("RemoteFunction") then
target:InvokeServer(unpackFn(args))
else
target:FireServer(unpackFn(args))
end
end)
if not ok then
F.Out("[操作集] 调用出错(已捕获): " .. tostring(err))
end
F.Out("[操作集] " .. (ok and "已调用" or "调用失败") .. " " .. tostring(remoteName)
.. " (参数 " .. tostring(#args) .. " 个)")
return ok
end
F.StealOps.desync = { on = false, hits = 0, burstUntil = 0 }
F.StealOps.desyncOpts = {
burst = 0.18,
amp = 1.4,
rate = 2,
enabled = false,
}
function F.StealOps.DesyncTick()
local o = F.StealOps.desyncOpts
if not (F.StealOps.desync.on and o.enabled) then return end
local now = os.clock()
local _, hum, root = GC()
if not (hum and root) then return end
local hp = hum.Health
if F.StealOps._dsLastHp and hp < F.StealOps._dsLastHp - 0.01 then
if now - (F.StealOps._dsLastBurst or 0) >= (1 / math.max(1, o.rate)) then
F.StealOps._dsLastBurst = now
F.StealOps.desync.burstUntil = now + o.burst
F.StealOps.desync.hits = F.StealOps.desync.hits + 1
end
end
F.StealOps._dsLastHp = hp
if now < (F.StealOps.desync.burstUntil or 0) then
local base = F.StealOps._dsBase
if not base then
F.StealOps._dsBase = root.CFrame
base = F.StealOps._dsBase
else
local jitter = (math.random() - 0.5) * o.amp
pcall(function()
root.CFrame = base + Vector3.new(jitter, 0, (math.random() - 0.5) * o.amp)
end)
end
else
F.StealOps._dsBase = nil
end
end
function F.StealOps.DesyncSet(on, opts)
on = on and true or false
if type(opts) == "table" then
for k, v in pairs(opts) do
if F.StealOps.desyncOpts[k] ~= nil and type(v) == type(F.StealOps.desyncOpts[k]) then
F.StealOps.desyncOpts[k] = v
end
end
end
if on == F.StealOps.desync.on then
F.Out("[操作集] 反命中脉冲已经是" .. (on and "开启" or "关闭") .. "状态")
return on
end
if on then
F.StealOps._dsLastHp = nil
F.StealOps._dsBase = nil
F.StealOps.desync.hits = 0
if F.StealOps._dsConn then pcall(function() F.StealOps._dsConn:Disconnect() end) end
F.StealOps._dsConn = RS.Heartbeat:Connect(function() pcall(F.StealOps.DesyncTick) end)
F.StealOps.desyncOpts.enabled = true
F.StealOps.desync.on = true
F.Out("[操作集] 反命中脉冲已开(受击瞬间才抖, 非持续 desync): 幅度 " .. tostring(F.StealOps.desyncOpts.amp)
.. " 格 · 每次 " .. tostring(F.StealOps.desyncOpts.burst) .. " 秒 · 每秒最多 "
.. tostring(F.StealOps.desyncOpts.rate) .. " 次")
F.Out("[操作集] ⚠ 这会改动发往服务端的位置数据, 风险高于普通防护档 —— 随时可 DesyncSet(false) 关掉")
else
if F.StealOps._dsConn then pcall(function() F.StealOps._dsConn:Disconnect() end) F.StealOps._dsConn = nil end
F.StealOps._dsBase = nil
F.StealOps._dsLastHp = nil
F.StealOps.desyncOpts.enabled = false
F.StealOps.desync.on = false
F.Out("[操作集] 反命中脉冲已关")
end
return F.StealOps.desync.on
end
F.StealOps.base = { on = false, saved = {}, restored = 0 }
F.StealOps.baseOpts = {
radius = 60,
tol = 6,
maxRestore = 60,
poll = 0.12,
}
function F.StealOps.BaseLockMark()
local _, _, root = GC()
if not root then
F.Out("[操作集] 没有角色，无法记录基地")
return 0
end
local o = F.StealOps.baseOpts
local center = root.Position
local n = 0
F.StealOps.base.saved = {}
F.StealOps.base.center = center
pcall(function()
local okWalk, list = pcall(function() return F.walk(workspace, 3000) end)
if not okWalk or type(list) ~= "table" then list = workspace:GetChildren() end
for _, d in ipairs(list) do
if n > 400 then break end
if (d:IsA("Model") or d:IsA("BasePart")) and d.Parent then
local pos = nil
if d:IsA("BasePart") then pos = d.Position
elseif d.PrimaryPart then pos = d.PrimaryPart.Position end
if pos and (pos - center).Magnitude <= o.radius then
local r = d:IsA("BasePart") and d or d.PrimaryPart
if r and not r.Anchored then
n = n + 1
F.StealOps.base.saved[#F.StealOps.base.saved + 1] = {
obj = d, root = r, pos = pos, name = d.Name,
}
end
end
end
end
end)
F.Out("[操作集] 基地锁定: 已记录 " .. tostring(n) .. " 个可搬动物品(半径 "
.. tostring(o.radius) .. " 格)")
return n
end
function F.StealOps.BaseLockTick()
local o = F.StealOps.baseOpts
if not F.StealOps.base.on then return end
local now = os.clock()
if now - (F.StealOps._blAt or 0) < o.poll then return end
F.StealOps._blAt = now
if F.StealOps.base.restored >= o.maxRestore then
if not F.StealOps._blHitMax then
F.StealOps._blHitMax = true
F.Out("[操作集] 基地锁定: 已达单次上限 " .. tostring(o.maxRestore) .. " 次, 停止拉回(防死循环)")
end
return
end
for _, rec in ipairs(F.StealOps.base.saved) do
if rec.obj and rec.obj.Parent and rec.root and rec.root.Parent then
local cur = nil
pcall(function() cur = rec.root.Position end)
if cur and (cur - rec.pos).Magnitude > o.tol then
pcall(function()
rec.root.CFrame = rec.root.CFrame - cur + rec.pos
end)
F.StealOps.base.restored = F.StealOps.base.restored + 1
if now - (F.StealOps._blLogAt or 0) > 3 then
F.StealOps._blLogAt = now
F.Out("[操作集] 基地锁定: 「" .. tostring(rec.name) .. "」被移走 "
.. string.format("%.0f", (cur - rec.pos).Magnitude) .. " 格 ⇒ 已拉回原位(第 "
.. tostring(F.StealOps.base.restored) .. " 次)")
end
end
end
end
end
function F.StealOps.BaseLockSet(on, opts)
on = on and true or false
if type(opts) == "table" then
for k, v in pairs(opts) do
if F.StealOps.baseOpts[k] ~= nil and type(v) == type(F.StealOps.baseOpts[k]) then
F.StealOps.baseOpts[k] = v
end
end
end
if on == F.StealOps.base.on then
F.Out("[操作集] 基地锁定已经是" .. (on and "开启" or "关闭") .. "状态")
return on
end
if on then
local n = F.StealOps.BaseLockMark()
if n == 0 then
F.Out("[操作集] 附近没有可搬动物品, 基地锁定未开启(先站到你的基地中间再开)")
return false
end
F.StealOps.base.restored = 0
F.StealOps._blHitMax = false
if F.StealOps._blConn then pcall(function() F.StealOps._blConn:Disconnect() end) end
F.StealOps._blConn = RS.Heartbeat:Connect(function() pcall(F.StealOps.BaseLockTick) end)
F.StealOps.base.on = true
F.Out("[操作集] 基地锁定已开: 距记录点 " .. tostring(F.StealOps.baseOpts.radius)
.. " 格内的物品被移走就拉回原位 · 单次上限 " .. tostring(F.StealOps.baseOpts.maxRestore) .. " 次")
else
if F.StealOps._blConn then pcall(function() F.StealOps._blConn:Disconnect() end) F.StealOps._blConn = nil end
F.StealOps.base.on = false
F.StealOps.base.saved = {}
F.Out("[操作集] 基地锁定已关")
end
return F.StealOps.base.on
end
function F.StealOps.Status()
return {
dump_ready = type(decompile) == "function" or type(getscriptbytecode) == "function",
desync = F.StealOps.desync.on,
desync_hits = F.StealOps.desync.hits,
base_lock = F.StealOps.base.on,
base_marked = #F.StealOps.base.saved,
base_restored = F.StealOps.base.restored,
}
end
function F.StealOps.DisableAll()
pcall(function() F.StealOps.DesyncSet(false) end)
pcall(function() F.StealOps.BaseLockSet(false) end)
F.Out("[操作集] 已全部关闭")
end
pcall(function()
if type(getgenv) == "function" then
local g = getgenv()
if type(g) == "table" then g.StealOps = F.StealOps end
end
end)
F.Out("[操作集] 模块就绪 v" .. tostring(F.StealOps.VERSION)
.. " · StealOps.DumpToolRemotes(工具名) / StealOps.DesyncSet(true) / StealOps.BaseLockSet(true)")
local function AntilagDisable()
local L = game:GetService("Lighting")
if not savedLag then return end
pcall(function()
L.GlobalShadows = savedLag.GlobalShadows L.FogEnd = savedLag.FogEnd L.FogStart = savedLag.FogStart
L.Brightness = savedLag.Brightness L.ClockTime = savedLag.ClockTime L.Ambient = savedLag.Ambient
end)
pcall(function() settings().Rendering.QualityLevel = savedLag.quality end)
pcall(function() if savedLag.mesh then settings().Rendering.MeshPartDetailLevel = savedLag.mesh end end)
pcall(function() if savedLag.lit then L.EnvironmentDiffuseScale = savedLag.lit.Diffuse L.EnvironmentSpecularScale = savedLag.lit.Specular L.ShadowSoftness = savedLag.lit.Soft end end)
if savedLag.lights then for _, e in ipairs(savedLag.lights) do pcall(function() if e and e.Parent then e.Enabled = true end end) end end
if savedLag.beams then for _, e in ipairs(savedLag.beams) do pcall(function() if e and e.Parent then e.Enabled = true end end) end end
if savedLag.clouds then for _, e in ipairs(savedLag.clouds) do pcall(function() if e and e.Parent then e.Enabled = true end end) end end
pcall(function()
local Terr = workspace:FindFirstChildWhichIsA("Terrain")
if Terr and savedLag.terr then
Terr.WaterWaveSize = savedLag.terr.WaveSize
Terr.WaterWaveSpeed = savedLag.terr.WaveSpeed
Terr.WaterReflectance = savedLag.terr.Reflectance
Terr.WaterTransparency = savedLag.terr.Transparency
end
end)
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
Brightness = L.Brightness, ClockTime = L.ClockTime, Ambient = L.Ambient, fx = {}, pe = {},
lights = {}, beams = {}, clouds = {} }
pcall(function() savedLag.lit = { Diffuse = L.EnvironmentDiffuseScale, Specular = L.EnvironmentSpecularScale, Soft = L.ShadowSoftness } end)
pcall(function() savedLag.mesh = settings().Rendering.MeshPartDetailLevel end)
pcall(function() savedLag.quality = settings().Rendering.QualityLevel end)
end
pcall(function() settings().Rendering.QualityLevel = 1 end)
local Terrain = workspace:FindFirstChildWhichIsA("Terrain")
if Terrain then
pcall(function()
savedLag.terr = { WaveSize = Terrain.WaterWaveSize, WaveSpeed = Terrain.WaterWaveSpeed, Reflectance = Terrain.WaterReflectance, Transparency = Terrain.WaterTransparency }
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 1
end)
end
L.GlobalShadows = false L.FogEnd = 9e9 L.FogStart = 9e9 L.Brightness = 1
pcall(function()
L.EnvironmentDiffuseScale = 0
L.EnvironmentSpecularScale = 0
L.ShadowSoftness = 0
end)
pcall(function() settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level00 end)
local nfx, npe, nli, nbm = 0, 0, 0, 0
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
elseif cn == "Beam" then
pcall(function() if d.Enabled then savedLag.beams[#savedLag.beams + 1] = d end d.Enabled = false end)
nbm = nbm + 1
elseif cn == "PointLight" or cn == "SpotLight" or cn == "SurfaceLight" then
pcall(function() if d.Enabled then savedLag.lights[#savedLag.lights + 1] = d end d.Enabled = false end)
nli = nli + 1
elseif cn == "Clouds" then
pcall(function() if d.Enabled then savedLag.clouds[#savedLag.clouds + 1] = d end d.Enabled = false end)
elseif d:IsA("BasePart") then
pcall(function() d.CastShadow = false end)
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
if not F._lagAddConn then
F._lagAddConn = workspace.DescendantAdded:Connect(function(child)
if not T.Antilag then return end
pcall(function()
if child:IsA("ParticleEmitter") or child:IsA("Trail") then
child.Lifetime = NumberRange.new(0)
elseif child:IsA("Smoke") or child:IsA("Fire") or child:IsA("Sparkles") then
child.Enabled = false
elseif child:IsA("Beam") or child:IsA("PointLight") or child:IsA("SpotLight") or child:IsA("SurfaceLight") or child:IsA("Clouds") then
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
F.Out(string.format("[降画质] 渲染档=%d · 光效 %d · 粒子 %d · 灯光 %d · 光束 %d · 全场景关阴影 · 网格最低档 · 新特效自动灭",
1, nfx, npe, nli, nbm))
end
local function FOVEnable() workspace.CurrentCamera.FieldOfView = C.FOV or 100 end
local function FOVDisable()
local c = workspace.CurrentCamera
if c then c.FieldOfView = (F._orig and F._orig.fov) or 70 end
end
local function ZoomEnable()
pcall(function()
local cm = LP.CameraMode
F._origCamMode = cm
LP.CameraMode = Enum.CameraMode.Classic
end)
LP.CameraMaxZoomDistance = 2000000
LP.CameraMinZoomDistance = 0.1
pcall(function() game:GetService("StarterPlayer").CameraMaxZoomDistance = 2000000 end)
pcall(function() workspace.CurrentCamera.CameraSubject = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") or workspace.CurrentCamera.CameraSubject end)
end
local function ZoomDisable()
local o = F._orig or {}
LP.CameraMaxZoomDistance = o.maxZoom or 128
LP.CameraMinZoomDistance = o.minZoom or 0.5
if F._origCamMode then
pcall(function() LP.CameraMode = F._origCamMode end)
F._origCamMode = nil
end
end
local LockHealthConn = nil
LockHealthDisable = function()
if LockHealthConn then LockHealthConn:Disconnect() LockHealthConn = nil end
if F._lhSig then pcall(function() F._lhSig:Disconnect() end) F._lhSig = nil end
F._lhAttach = nil
end
LockHealthEnable = function()
if LockHealthConn then return end
local function lockNow()
pcall(function()
if not T.LockHealth then return end
local _, hum = GC()
if not hum then return end
if F.GodTopUp(hum, true) then F.HpFixNote(1) end
end)
end
local function attach()
local _, hum = GC()
if not hum then return end
if F._lhSig then pcall(function() F._lhSig:Disconnect() end) F._lhSig = nil end
pcall(function() F._lhSig = hum.HealthChanged:Connect(lockNow) end)
end
F._lhAttach = attach
attach()
LockHealthConn = RS.Heartbeat:Connect(function()
if not T.LockHealth then LockHealthDisable() return end
if os.clock() - (F._thr4402 or 0) < 1 then return end
F._thr4402 = os.clock()
if F._lhAttach then pcall(F._lhAttach) end
lockNow()
end)
end
local RegenConn = nil
local function RegenDisable() if RegenConn then RegenConn:Disconnect() RegenConn = nil end end
local function RegenEnable()
if RegenConn then return end
RegenConn = RS.Heartbeat:Connect(function()
pcall(function()
if not T.Regen then RegenDisable() return end
if os.clock() - (F._thr4420 or 0) < 0.2 then return end
F._thr4420 = os.clock()
local _, hum = GC()
if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
hum.Health = math.min(hum.MaxHealth, hum.Health + (C.RegenRate or 10))
end
end)
end)
end
F.LockHealthSoloSet = function(on)
T.LockHealthSolo = on and true or false
T.LockHealth = T.LockHealthSolo or (T.GodMode == true)
if T.LockHealth then
pcall(LockHealthEnable)
F.Out("[锁血] 已开: 血量始终维持在「游戏默认上限」(MaxHealth) · 不改任何游戏状态、不屏蔽伤害")
else
pcall(LockHealthDisable)
F.Out("[锁血] 已关")
end
end
function F.OnCharacter()
if T.CharPersist == false then return end
task.wait(0.2)
pcall(F.RecordOriginals)
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
if not T.Hud then pcall(F.HudDisable) return end
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
local col = Color3.fromRGB(0, 255, 120)
pcall(function()
local cc = C.CrosshairColor
if typeof(cc) == "Color3" then col = cc end
end)
local scale = tonumber(C.CrosshairSize) or 14
local style = tostring(C.CrosshairStyle or "十字(默认)")
local function bar(w, h, ox, oy)
local f = Instance.new("Frame")
f.Size = UDim2.fromOffset(w, h)
f.Position = UDim2.new(0.5, -w / 2 + (ox or 0), 0.5, -h / 2 + (oy or 0))
f.BackgroundColor3 = col
f.BorderSizePixel = 0
f.Parent = sg
end
if style == "点(小圆点)" then
bar(4, 4)
elseif style == "圆(空心圈)" then
local ring = Instance.new("Frame")
ring.Size = UDim2.fromOffset(scale, scale)
ring.Position = UDim2.new(0.5, -scale / 2, 0.5, -scale / 2)
ring.BackgroundTransparency = 1
ring.BorderSizePixel = 1
ring.BorderColor3 = col
pcall(function()
local ui = Instance.new("UICorner")
ui.CornerRadius = UDim.new(1, 0)
ui.Parent = ring
end)
ring.Parent = sg
else
bar(2, scale, 0, 0) bar(scale, 2, 0, 0)
end
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
circle.Size = UDim2.fromOffset((tonumber(C.CombatFOV) or 400) * 2, (tonumber(C.CombatFOV) or 400) * 2)
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
local fov = tonumber(C.CombatFOV) or 400
if fov == lastFov then return end
lastFov = fov
pcall(function() F._fovRing.Size = UDim2.fromOffset(fov * 2, fov * 2) end)
end)
F.Out("[准星] FOV 圈已开(直径 " .. tostring((tonumber(C.CombatFOV) or 400) * 2) .. " px)")
end
function F.FovCircleDisable()
if F._fovConn then F._fovConn:Disconnect() F._fovConn = nil end
if F._fovGui then pcall(function() F._fovGui:Destroy() end) F._fovGui = nil end
F._fovRing = nil
end
F._menuOpen = false
F.MenuWin = function()
local w = getgenv and getgenv().CM_Window
if not w and type(F.Window) == "table" then w = F.Window end
return w
end
function F.MenuOpen()
local w = F.MenuWin()
if w then
local ok, vis = pcall(function() return w.Root and w.Root.Visible end)
if ok and vis ~= nil then return vis and true or false end
local ok2, mz = pcall(function() return w.Minimized end)
if ok2 and mz ~= nil then return (not mz) and true or false end
end
return F._menuOpen and true or false
end
pcall(function()
local w = F.MenuWin()
local root = w and w.Root
if root then
local was = root.Visible
root:GetPropertyChangedSignal("Visible"):Connect(function()
local now = root.Visible
F._menuOpen = now and true or false
pcall(F.ModalOverlaySet, now)
if was and not now then pcall(F.CloseDropdowns) end
was = now
end)
pcall(F.ModalOverlaySet, root.Visible)
end
end)
F._modalOverlay, F._savedMouseIcon = nil, nil
F._mmg, F._mmgConn, F._mmgCam = nil, nil, nil
F.MenuMouseForce = function()
pcall(function()
if UIS.TouchEnabled then return end
if LP then
if F._mmgCam == nil then pcall(function() F._mmgCam = LP.CameraMode end) end
if LP.CameraMode ~= Enum.CameraMode.Classic then
pcall(function() LP.CameraMode = Enum.CameraMode.Classic end)
end
end
if UIS.MouseBehavior ~= Enum.MouseBehavior.Default then UIS.MouseBehavior = Enum.MouseBehavior.Default end
if UIS.MouseIconEnabled ~= true then
if F._savedMouseIcon == nil then F._savedMouseIcon = UIS.MouseIconEnabled end
UIS.MouseIconEnabled = true
end
end)
end
F.MenuMouseRelease = function()
if F._mmgConn then
pcall(function() RS:UnbindFromRenderStep("CM_MenuMouse") end)
pcall(function() F._mmgConn:Disconnect() end)
F._mmgConn = nil
end
if F._mmgCam ~= nil then
pcall(function() if LP then LP.CameraMode = F._mmgCam end end)
end
F._mmgCam = nil
if F._savedMouseIcon ~= nil then
pcall(function() UIS.MouseIconEnabled = F._savedMouseIcon end)
F._savedMouseIcon = nil
end
end
F.MenuMouseGuardStop = function()
F._mmg = nil
pcall(F.MenuMouseRelease)
end
F.MenuMouseGuard = function()
if F._mmg then return end
F._mmg = true
task.spawn(function()
local last = nil
while F._mmg do
local w = nil
pcall(function() w = F.MenuWin() end)
local open = false
if w then pcall(function() open = F.MenuOpen() end) end
if open then
pcall(F.MenuMouseForce)
if not F._mmgConn then
local okB = pcall(function()
RS:BindToRenderStep("CM_MenuMouse", Enum.RenderPriority.Camera.Value + 1, F.MenuMouseForce)
end)
if okB then
F._mmgConn = true
else
pcall(function() F._mmgConn = RS.RenderStepped:Connect(F.MenuMouseForce) end)
end
end
if last ~= true then
F.Out("[菜单] 已接管鼠标: 每帧解除锁定 + 临时切第三人称 ⇒ 第一人称/锁定视角下也能用菜单(关掉菜单自动还原)")
end
elseif last == true then
pcall(F.MenuMouseRelease)
end
last = open
task.wait(open and 0.6 or 0.3)
end
pcall(F.MenuMouseRelease)
F._mmg = nil
end)
end
F.MenuMouseGuardBoot = function()
task.wait(1.2)
pcall(F.MenuMouseGuard)
end
pcall(function() task.spawn(F.MenuMouseGuardBoot) end)
F.ModalOverlaySet = function(on)
local sg = nil
pcall(function() sg = Fluent and Fluent.GUI end)
if not sg then return end
if on then
if not F._modalOverlay or not F._modalOverlay.Parent then
local f = Instance.new("TextButton")
f.Name = "CMModalOverlay"
f.Size = UDim2.fromScale(1, 1)
f.Position = UDim2.fromScale(0, 0)
f.BackgroundTransparency = 1
f.Text = ""
f.TextTransparency = 1
f.AutoButtonColor = false
f.Modal = true
f.ZIndex = 0
pcall(function() f:SetAttribute("CMOwned", true) end)
f.Parent = sg
F._modalOverlay = f
end
pcall(function() F._modalOverlay.Visible = true end)
pcall(function() if not UIS.TouchEnabled then F._savedMouseIcon = UIS.MouseIconEnabled UIS.MouseIconEnabled = true end end)
else
if F._modalOverlay then pcall(function() F._modalOverlay.Visible = false end) end
if F._savedMouseIcon ~= nil then
pcall(function() UIS.MouseIconEnabled = F._savedMouseIcon end)
F._savedMouseIcon = nil
end
end
end
F._hlObjs, F._hlAdded, F._hlLoop = {}, nil, nil
F.CMX_HLMode = function() return tostring(C.BodyHLMode or "①") end
F.ROLE_KILLER = { "knife","dagger","murder","assassin","刀","杀手" }
F.ROLE_SHERIFF = { "gun","pistol","revolver","sheriff","枪","警长" }
F.ROLE_ATTRS = { "Role","role","RoleName","rolename","Alignment","alignment","Job","job","Class","class","TeamName","teamname" }
F.ROLE_NAME = { killer = "杀手", sheriff = "警长" }
F.ROLE_COLOR = { killer = Color3.fromRGB(255, 45, 45), sheriff = Color3.fromRGB(255, 210, 0), none = Color3.fromRGB(0, 220, 255) }
F.RoleMatch = function(v)
if type(v) ~= "string" or v == "" then return nil end
local t = string.lower(v)
local i
for i = 1, #F.ROLE_KILLER do if string.find(t, string.lower(F.ROLE_KILLER[i]), 1, true) then return "killer" end end
for i = 1, #F.ROLE_SHERIFF do if string.find(t, string.lower(F.ROLE_SHERIFF[i]), 1, true) then return "sheriff" end end
return nil
end
F._roleCache = {}
F.RoleOf = function(pl)
if not pl then return nil, nil end
local now = os.clock()
local c = F._roleCache[pl]
if c and (now - c.t) < 1.5 then return c.r, c.w end
local r, w = nil, nil
if pl.Parent then
for i = 1, #F.ROLE_ATTRS do
local k = F.ROLE_ATTRS[i]
local ok, v = pcall(pl.GetAttribute, pl, k)
if ok and v ~= nil then
r = F.RoleMatch(tostring(v))
if r then w = "属性 " .. k .. "=" .. tostring(v) break end
end
end
if not r then
local tr, tn = nil, nil
pcall(function() if pl.Team then tn = pl.Team.Name tr = F.RoleMatch(tn) end end)
if tr then r = tr w = "队伍 " .. tostring(tn) end
end
if not r then
local ch = pl.Character
if ch then
local kids = ch:GetChildren()
for i = 1, #kids do
local d = kids[i]
local isTool = false
pcall(function() isTool = d:IsA("Tool") end)
if isTool then
local rr = F.RoleMatch(d.Name)
if rr then r = rr w = "手持 " .. d.Name break end
end
end
end
end
end
F._roleCache[pl] = { t = now, r = r, w = w }
return r, w
end
F.RolePretty = function(pl)
local r = F.RoleOf(pl)
if r == "killer" then return F.ROLE_NAME.killer, F.ROLE_COLOR.killer, r end
if r == "sheriff" then return F.ROLE_NAME.sheriff, F.ROLE_COLOR.sheriff, r end
return "平民", F.ROLE_COLOR.none, nil
end
F.NPC_KEYS = { "npc","dummy","zombie","monster","enemy","mob","boss","creature","skeleton","ghost","puppet","mannequin","sentry","soldier","bandit","golem","slime","wolf","bear","spider","crab","worm","bird","animal","walker","stalker","hunter","wraith","demon","devil","reaper","clown","mummy","vampire","werewolf","titan","brute","grunt","minion","troop","hostile","attacker","raider","ninja","knight","archer","troll","ogre","goblin" }
F.NPC_COLOR = Color3.fromRGB(170, 110, 55)
F.IsNPC = function(o, deep)
if o == nil then return false end
local cache = F._npcCache
if cache ~= nil and cache[o] == true then return true end
local isM, isP = false, false
pcall(function() isM = o:IsA("Model") end)
if not isM then pcall(function() isP = o:IsA("BasePart") end) end
local res = false
if isM or isP then
local mine = false
pcall(function() mine = (o == LP.Character) end)
if not mine then
local isPl = false
pcall(function() isPl = Players:GetPlayerFromCharacter(o) ~= nil end)
if not isPl then
local hum = nil
pcall(function() hum = o:FindFirstChildOfClass("Humanoid") end)
if hum ~= nil then
res = true
else
local ac = nil
pcall(function() ac = o:FindFirstChildOfClass("AnimationController") end)
if ac ~= nil then
res = true
elseif isM then
local kids = nil
pcall(function() kids = o:GetChildren() end)
if type(kids) == "table" then
local i
for i = 1, #kids do
if i > 24 then break end
local c = kids[i]
local isSub = false
pcall(function() isSub = c:IsA("Model") end)
if isSub then
local sh = nil
pcall(function() sh = c:FindFirstChildOfClass("Humanoid") or c:FindFirstChildOfClass("AnimationController") end)
if sh ~= nil then
res = true
break
end
end
end
end
if not res and deep == true then
local dh = false
pcall(function() dh = o:FindFirstChildWhichIsA("Humanoid", true) ~= nil end)
if dh then
res = true
else
local da = false
pcall(function() da = o:FindFirstChildWhichIsA("AnimationController", true) ~= nil end)
if da then res = true end
end
end
end
end
if not res then
local low = string.lower(tostring(o.Name))
local i
for i = 1, #F.NPC_KEYS do
if string.find(low, F.NPC_KEYS[i], 1, true) then
res = true
break
end
end
end
end
end
end
if cache ~= nil and (res == true or deep == true) then cache[o] = res end
return res
end
F.NpcSweep = function(center, doOffer)
if type(doOffer) ~= "function" then return 0 end
local q, qi, n, found = { { workspace, 0 } }, 1, 0, 0
while qi <= #q and n < 1500 do
local item = q[qi]
qi = qi + 1
local node = item[1]
local dep = tonumber(item[2]) or 0
n = n + 1
local descend = (dep < 3)
if node ~= workspace and node ~= nil then
local skip = false
pcall(function() skip = (node == LP.Character) end)
if not skip then
pcall(function() if Players:GetPlayerFromCharacter(node) ~= nil then skip = true end end)
end
if skip then
descend = false
elseif F.IsNPC(node) then
descend = false
local pos = nil
pcall(function() pos = node:GetPivot().Position end)
if pos == nil then pcall(function() local pp = node.PrimaryPart if pp ~= nil then pos = pp.Position end end) end
if pos ~= nil and (pos - center).Magnitude <= F.IxRange() then
doOffer(node, F.NPC_COLOR, pos, "npc")
found = found + 1
end
end
end
if descend then
local kids = nil
pcall(function() kids = node:GetChildren() end)
if type(kids) == "table" then
local i
for i = 1, #kids do
local k = kids[i]
local ok2 = false
pcall(function() ok2 = k:IsA("Model") or k:IsA("Folder") end)
if ok2 then q[#q + 1] = { k, dep + 1 } end
end
end
end
end
return found
end
F.NpcScan = function()
local n = 0
local list = {}
pcall(function() list = workspace:GetChildren() end)
local i
for i = 1, #list do
if F.IsNPC(list[i]) then n = n + 1 end
end
local subs = {}
pcall(function()
for i = 1, #list do
local o = list[i]
local okf = pcall(function() return o:IsA("Folder") or o:IsA("Model") end)
if okf and o ~= LP.Character then
local isM = false
pcall(function() isM = o:IsA("Model") end)
if not isM then
local okk, kids = pcall(function() return o:GetChildren() end)
if okk and kids then
for j = 1, #kids do subs[#subs + 1] = kids[j] end
end
end
end
end
end)
for i = 1, #subs do
if F.IsNPC(subs[i]) then n = n + 1 end
end
return n
end
F._ixObjs, F._ixLoop, F._ixAdded, F._ixAt = {}, nil, nil, 0
F._ixPos, F._ixLog = nil, 0
F.IX_MAX = 240
F.IX_MAXSZ = 90
F.IX_MOVE = 12
F.IX_HOPS = 2
F.IxTooBig = function(o)
local sz = 0
pcall(function() if o:IsA("BasePart") then sz = o.Size.Magnitude end end)
if sz == 0 then pcall(function() sz = o:GetExtentsSize().Magnitude end) end
if sz == 0 or sz ~= sz then return false end
return sz > F.IX_MAXSZ
end
F.IxRange = function()
local v = tonumber(C.IxRange)
if not v or v < 30 then v = 300 end
if v > 5000 then v = 5000 end
return v
end
F.IxGap = function()
local v = tonumber(C.IxGap)
if not v or v < 0.5 then v = 2 end
if v > 10 then v = 10 end
return v
end
F.IxParams = function()
if F._ixParams ~= nil then return F._ixParams end
local p = nil
pcall(function()
p = OverlapParams.new()
p.FilterType = Enum.RaycastFilterType.Exclude or Enum.RaycastFilterType.Blacklist
p.FilterDescendantsInstances = { LP.Character }
p.MaxParts = 3000
end)
F._ixParams = p
return p
end
F.IX_COLOR = Color3.fromRGB(255, 215, 0)
F.HL_COLORS = {
npc = F.NPC_COLOR,
ix = F.IX_COLOR,
trap = Color3.fromRGB(255, 60, 60),
item = Color3.fromRGB(80, 255, 160),
drop = Color3.fromRGB(255, 240, 120),
veh = Color3.fromRGB(0, 235, 255),
}
F.IX_STRUCT_N = 0
F.KeyHit = function(low, kw)
local i = 1
while true do
local s = string.find(low, kw, i, true)
if not s then return false end
local e = s + #kw - 1
if e >= #low then return true end
if string.match(string.sub(low, e + 1, e + 1), "%a") == nil then return true end
i = s + 1
end
end
F.HL_BLOCK_KEYS = { "room","wall","floor","ceiling","roof","frame","doorway","hallway","corridor","house","building","block","platform","stairway","stairs","ramp","beam","pillar","column","carpet","rug","curtain","painting","portrait","poster","banner","fence","railing","window","tile","vent","duct","terrain","decor","background","structure","facade","gatehouse","level","map","chunk","module","part_" }
F.HLBlocked = function(low)
local i
for i = 1, #F.HL_BLOCK_KEYS do
if string.find(low, F.HL_BLOCK_KEYS[i], 1, true) then return true end
end
return false
end
F.IxStruct = function(o)
if o == nil then return false end
local isM = false
pcall(function() isM = o:IsA("Model") end)
if not isM then return false end
local n = 0
pcall(function() n = #o:GetDescendants() end)
if n > 40 then return true end
local sz = 0
pcall(function() sz = o:GetExtentsSize().Magnitude end)
if sz == 0 or sz ~= sz then return false end
return sz > F.IX_MAXSZ
end
F.IxTgtPart = function(o)
if o == nil then return nil end
local isP = false
pcall(function() isP = o:IsA("BasePart") end)
if isP then return o end
local mp = nil
pcall(function() mp = o:FindFirstChildWhichIsA("BasePart") end)
if mp ~= nil then return mp end
return o
end
F.HL_TRAP_KEYS = { "trap","spike","hazard","lava","poison","damage","kill","bomb","mine","saw","blade","trapdoor","spiketrap","killbrick","hurtbrick","damagebrick","spikeball","lasergrid" }
F.HL_ITEM_KEYS = { "item","pickup","coin","gem","token","loot","chest","crate","box","orb","egg","fruit","candy","key","badge","keycard","cashbag","coinbag" }
F.HL_DROP_KEYS = { "weapon","gun","sword","cash","money","reward" }
F.HL_USE_KEYS = { "door","gate","lever","switch","button","portal","teleport","shop","store","vending","elevator","valve","terminal","keypad","quest","interact","prompt","vendor","register","vendingmachine","shopkeeper","questgiver" }
F.HLKind = function(o)
if o == nil or o == LP.Character then return nil end
local isM, isB, isT = false, false, false
pcall(function()
isM = o:IsA("Model")
isB = o:IsA("BasePart")
isT = o:IsA("Tool")
end)
if isM or isB or isT then
local okn, isNpc = pcall(F.IsNPC, o, isM)
if okn and isNpc then return "npc", F.HL_COLORS.npc end
local oki, isIx = pcall(F.IxIsTarget, o)
if oki and isIx then return "ix", F.HL_COLORS.ix end
if isM or isB then
local isVeh = false
pcall(function() isVeh = o:IsA("VehicleSeat") or o:IsA("Seat") or o:FindFirstChildOfClass("VehicleSeat") ~= nil or o:FindFirstChildOfClass("Seat") ~= nil end)
if isVeh then return "veh", F.HL_COLORS.veh end
end
if isT then return "drop", F.HL_COLORS.drop end
if isM and F.IxStruct(o) then
F.IX_STRUCT_N = F.IX_STRUCT_N + 1
return nil
end
local low = string.lower(tostring(o.Name))
if F.HLBlocked(low) then
F.IX_STRUCT_N = F.IX_STRUCT_N + 1
return nil
end
local i
for i = 1, #F.HL_TRAP_KEYS do
if F.KeyHit(low, F.HL_TRAP_KEYS[i]) then return "trap", F.HL_COLORS.trap end
end
for i = 1, #F.HL_ITEM_KEYS do
if F.KeyHit(low, F.HL_ITEM_KEYS[i]) then return "item", F.HL_COLORS.item end
end
for i = 1, #F.HL_USE_KEYS do
if F.KeyHit(low, F.HL_USE_KEYS[i]) then return "ix", F.HL_COLORS.ix end
end
for i = 1, #F.HL_DROP_KEYS do
if F.KeyHit(low, F.HL_DROP_KEYS[i]) then return "drop", F.HL_COLORS.drop end
end
return nil
end
local okX = false
pcall(function() okX = o:IsA("ProximityPrompt") or o:IsA("ClickDetector") end)
if okX then return "ix", F.HL_COLORS.ix end
return nil
end
F.IxAdd = function(o, col)
if not T.IxHL then return end
if o == nil then return end
local rec0 = F._ixObjs[o]
if rec0 then
local alive = false
if rec0.h ~= nil then pcall(function() alive = (rec0.h.Parent ~= nil) end) end
if alive then
if col and rec0.h then pcall(function() rec0.h.FillColor = col rec0.h.OutlineColor = col end) end
return
end
if rec0.h then pcall(function() rec0.h:Destroy() end) end
F._ixObjs[o] = nil
end
local h = Instance.new("Highlight")
h.Name = "CMHLMark"
h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
h.FillColor = col or F.HL_COLORS.ix
h.OutlineColor = col or F.HL_COLORS.ix
h.FillTransparency = 0.6
h.OutlineTransparency = 0
h.Parent = o
pcall(function() h:SetAttribute("CMOwned", true) end)
F._ixObjs[o] = { h = h }
end
F.IxIsTarget = function(o)
if o == nil then return false end
if o == LP.Character then return false end
local ok2, isAny = pcall(function() return o:IsA("ProximityPrompt") or o:IsA("ClickDetector") end)
if ok2 and isAny then return true end
local ok, has = pcall(function() return o:FindFirstChildOfClass("ProximityPrompt") ~= nil or o:FindFirstChildOfClass("ClickDetector") ~= nil end)
if ok and has then return true end
local isModel = false
pcall(function() isModel = o:IsA("Model") end)
if not isModel then return false end
if F.IxStruct(o) then return false end
local kids = nil
pcall(function() kids = o:GetChildren() end)
if type(kids) ~= "table" or #kids > 12 then return false end
local i
for i = 1, #kids do
local c = kids[i]
local ok3, hit = pcall(function() return c:FindFirstChildOfClass("ProximityPrompt") ~= nil or c:FindFirstChildOfClass("ClickDetector") ~= nil end)
if ok3 and hit then return true end
end
return false
end
F.IxDropDead = function()
local gone = 0
for o, rec in pairs(F._ixObjs) do
local dead = false
if rec == nil or rec.h == nil then
dead = true
else
pcall(function() dead = (rec.h.Parent == nil) end)
end
if dead then
if rec and rec.h then pcall(function() rec.h:Destroy() end) end
F._ixObjs[o] = nil
gone = gone + 1
end
end
return gone
end
F.IxCenter = function()
local okg, _, _, root = pcall(GC)
if okg and root then return root.Position, root end
local cam = workspace.CurrentCamera
if cam ~= nil then
local p = nil
pcall(function() p = cam.CFrame.Position end)
if p ~= nil then return p, nil end
end
return nil, nil
end
F.IxScopeFull = function()
return tostring(C.IxScope or "") == "全图"
end
F.IxFullSweep = function(center, doOffer)
if type(doOffer) ~= "function" then return 0 end
local all = nil
pcall(function() all = workspace:GetDescendants() end)
if type(all) ~= "table" then return 0 end
local n, i = 0, 0
for i = 1, #all do
local o = all[i]
if o ~= nil and typeof(o) == "Instance" then
local cls = o.ClassName
if cls == "ProximityPrompt" or cls == "ClickDetector" then
local tgt = nil
pcall(function() tgt = o.Parent end)
if tgt ~= nil and tgt ~= LP.Character and F.IxStruct(tgt) then
local alt = F.IxTgtPart(tgt)
if alt ~= nil and alt ~= tgt and not F.IxStruct(alt) then tgt = alt else tgt = nil end
end
if tgt ~= nil and tgt ~= LP.Character then
local pos = nil
pcall(function() pos = tgt.Position end)
if pos == nil then pcall(function() pos = tgt:GetPivot().Position end) end
if pos ~= nil then
doOffer(tgt, F.HL_COLORS.ix, pos, "ix")
n = n + 1
end
end
elseif cls == "Model" and o ~= LP.Character then
if F.IsNPC(o) then
local pos = nil
pcall(function() pos = o:GetPivot().Position end)
if pos == nil then pcall(function() local pp = o.PrimaryPart if pp ~= nil then pos = pp.Position end end) end
if pos ~= nil then
doOffer(o, F.NPC_COLOR, pos, "npc")
n = n + 1
end
end
end
end
end
return n
end
F.IxScan = function()
local center = F.IxCenter()
if center == nil then
return 0, F.IxDropDead(), 0
end
local best, order, skipped, npcN = {}, {}, 0, 0
F._npcCache = {}
F.IX_STRUCT_N = 0
local function offer(o, col, pos, kind)
if o == nil or o == LP.Character then return end
if kind ~= "npc" and F.IxTooBig(o) then skipped = skipped + 1 return end
local d = 0
if pos then d = (pos - center).Magnitude end
local cur = best[o]
if cur == nil then
best[o] = { col = col, d = d }
order[#order + 1] = o
elseif d < cur.d then
cur.d = d
cur.col = col
end
end
if F.IxScopeFull() then
pcall(function() npcN = F.IxFullSweep(center, offer) end)
else
local parts = nil
pcall(function() parts = workspace:GetPartBoundsInRadius(center, F.IxRange(), F.IxParams()) end)
if type(parts) ~= "table" then parts = {} end
for i = 1, #parts do
local pt = parts[i]
local k, c = F.HLKind(pt)
if k then
offer(pt, c, pt.Position, k)
else
local up = pt
for hop = 1, F.IX_HOPS do
local pp = nil
pcall(function() pp = up.Parent end)
if pp == nil or pp == workspace then break end
up = pp
local skipUp = false
pcall(function() skipUp = up:IsA("Folder") or up:IsA("Terrain") end)
if not skipUp then
local k2, c2 = F.HLKind(up)
if k2 then offer(up, c2, pt.Position, k2) break end
end
end
end
end
pcall(function() npcN = npcN + F.NpcSweep(center, offer) end)
end
table.sort(order, function(a, b) return best[a].d < best[b].d end)
local keep = {}
for i = 1, #order do
if i > F.IX_MAX then break end
local o = order[i]
keep[o] = true
F.IxAdd(o, best[o].col)
end
local gone = F.IxDropDead()
for o, rec in pairs(F._ixObjs) do
if keep[o] == nil then
if rec and rec.h then pcall(function() rec.h:Destroy() end) end
F._ixObjs[o] = nil
gone = gone + 1
end
end
return #order, gone, skipped, npcN
end
F.IxClear = function()
for _, rec in pairs(F._ixObjs) do
if rec and rec.h then pcall(function() rec.h:Destroy() end) end
end
F._ixObjs = {}
pcall(function()
local left = workspace:GetDescendants()
local i
for i = 1, #left do
local d = left[i]
if d ~= nil and d.Name == "CMHLMark" then pcall(function() d:Destroy() end) end
end
end)
end
F.IxHLSet = function(on)
T.IxHL = on and true or false
if F._ixLoop then pcall(function() F._ixLoop:Disconnect() end) F._ixLoop = nil end
if F._ixAdded then pcall(function() F._ixAdded:Disconnect() end) F._ixAdded = nil end
if not T.IxHL then
F.IxClear()
F.Out("[高亮透视] 已关")
return
end
local n, _, _, npcN = F.IxScan()
F.Out("[高亮透视] 已开 · 模式=" .. (F.IxScopeFull() and "全图(不限距离)" or ("以你为中心 " .. tostring(F.IxRange()) .. " 格内")) .. " · 标出 " .. tostring(n) .. " 个(其中 NPC/生物 " .. tostring(npcN or 0) .. " 个) · 上限 " .. tostring(F.IX_MAX) .. " 个")
F.Out("[高亮透视] 死亡/观战时会自动改用相机位置继续扫, 不会因为自己没角色就全灭")
F.Out("[高亮透视] 刷新节奏: 每移动 " .. tostring(F.IX_MOVE) .. " 格 或 每 " .. tostring(F.IxGap())
.. " 秒重扫一次(间隔可在下面调) · 中途新出现的物件由事件即时补标")
F.Out("[高亮透视] 颜色: NPC棕 / 交互金 / 陷阱红 / 道具绿 / 掉落黄 / 载具青 · 走出范围·被删除·超出上限的都会立刻取消高亮(不残留)")
F.Out("[高亮透视] 只高亮「真正可交互的物件 + 生物」: 地图建筑/房间/墙体/布景模型一律跳过(不改色调、不动伽马)")
pcall(function()
F._ixAdded = workspace.DescendantAdded:Connect(function(o)
if not T.IxHL then return end
task.wait(0.3)
if not T.IxHL then return end
local kk, cc = F.HLKind(o)
if not kk then return end
local target = o
pcall(function()
if o:IsA("ProximityPrompt") or o:IsA("ClickDetector") then target = o.Parent end
end)
if target == nil then return end
if F.IxStruct(target) then
local alt = F.IxTgtPart(target)
if alt ~= nil and alt ~= target and not F.IxStruct(alt) then target = alt else return end
end
local okg, _, _, root = pcall(GC)
if not okg or not root then return end
local pos = nil
pcall(function() pos = target.Position end)
if pos == nil then pcall(function() pos = target:GetPivot().Position end) end
if pos == nil then return end
if (pos - root.Position).Magnitude > F.IxRange() then return end
if F.IxTooBig(target) then return end
if F._ixObjs[target] ~= nil then return end
F.IxAdd(target, cc)
end)
end)
F._ixLoop = RS.Heartbeat:Connect(function()
if not T.IxHL then F.IxHLSet(false) return end
local center, liveRoot = F.IxCenter()
local now = os.clock()
if center == nil then
if now - (F._ixCleanAt or 0) > 1 then
F._ixCleanAt = now
F.IxDropDead()
end
return
end
local root = { Position = center }
local pos = root.Position
local moved = 999
if F._ixPos then moved = (pos - F._ixPos).Magnitude end
local needMove, gap = F.IX_MOVE, F.IxGap()
if F.IxScopeFull() then
needMove = 40
gap = gap * 4
end
if moved < needMove and (now - (F._ixAt or 0)) < gap then return end
F._ixAt, F._ixPos = now, pos
local n, gone, sk, npcN = F.IxScan()
if now - F._ixLog > 8 then
F._ixLog = now
F.Out("[高亮透视] " .. (F.IxScopeFull() and "全图" or (tostring(F.IxRange()) .. " 格内")) .. " " .. tostring(n) .. " 个(NPC/生物 " .. tostring(npcN or 0) .. ") · 本轮取消 " .. tostring(gone) .. " 个"
.. (tonumber(sk) and tonumber(sk) > 0 and (" · 跳过超大对象 " .. tostring(sk) .. " 个") or "")
.. (tonumber(F.IX_STRUCT_N) and tonumber(F.IX_STRUCT_N) > 0 and (" · 跳过地图建筑/布景 " .. tostring(F.IX_STRUCT_N) .. " 个") or ""))
end
end)
end
F.ESP_HEALTH_COLOR = Color3.fromRGB(0, 255, 80)
F.ESP_LOWHP_COLOR = Color3.fromRGB(255, 60, 60)
F._espGui, F._espLoop, F._espItems, F._espAt = nil, nil, {}, 0
F.EspEnsure = function()
if F._espGui and F._espGui.Parent then return F._espGui end
local host = nil
pcall(function() host = gethui and gethui() end)
if not host then pcall(function() host = CoreGui end) end
if not host then pcall(function() host = game:GetService("CoreGui") end) end
if not host then return nil end
local sg = Instance.new("ScreenGui")
sg.Name = "CMEsp"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 999
pcall(function() sg:SetAttribute("CMOwned", true) end)
sg.Parent = host
F._espGui = sg
return sg
end
F.EspMake = function(pl)
local sg = F.EspEnsure()
if not sg then return nil end
local function mk(cls, props)
local o = Instance.new(cls)
for k, v in pairs(props) do pcall(function() o[k] = v end) end
o.Parent = sg
return o
end
local rec = {}
rec.hpBg = mk("Frame", { Name = "hpBg", BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.35, BorderSizePixel = 0, Visible = false })
rec.hpFg = Instance.new("Frame")
rec.hpFg.Name = "hpFg"
rec.hpFg.BackgroundColor3 = F.ESP_HEALTH_COLOR
rec.hpFg.BorderSizePixel = 0
rec.hpFg.Size = UDim2.fromScale(1, 1)
rec.hpFg.Parent = rec.hpBg
rec.name = mk("TextLabel", { Name = "nm", BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(255, 255, 255), TextStrokeTransparency = 0.25, TextXAlignment = Enum.TextXAlignment.Center, Visible = false })
rec.dist = mk("TextLabel", { Name = "ds", BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 13, TextColor3 = Color3.fromRGB(230, 230, 230), TextStrokeTransparency = 0.25, TextXAlignment = Enum.TextXAlignment.Center, Visible = false })
F._espItems[pl] = rec
return rec
end
F.EspHideRec = function(rec)
if not rec then return end
pcall(function() rec.box.Visible = false end)
pcall(function() rec.hpBg.Visible = false end)
pcall(function() rec.name.Visible = false end)
pcall(function() rec.dist.Visible = false end)
end
F.EspClear = function()
for _, rec in pairs(F._espItems) do
if rec then
pcall(function() if rec.box then rec.box:Destroy() end end)
pcall(function() if rec.hpBg then rec.hpBg:Destroy() end end)
pcall(function() if rec.name then rec.name:Destroy() end end)
pcall(function() if rec.dist then rec.dist:Destroy() end end)
end
end
F._espItems = {}
end
F._xrayObjs = {}
F._xrayAdded, F._xrayLoop, F._xrayAt = nil, nil, 0
F.XRayApply = function(o)
if not T.XRay then return end
if o == nil or F._xrayObjs[o] then return end
local okP, isP = pcall(function() return o:IsA("BasePart") end)
if not okP or not isP then return end
local isChar = false
pcall(function()
local m = o:FindFirstAncestorOfClass("Model")
isChar = (m ~= nil and Players:GetPlayerFromCharacter(m) ~= nil)
end)
if isChar then return end
if LP.Character ~= nil then
local okd, isMine = pcall(function() return o:IsDescendantOf(LP.Character) end)
if okd and isMine then return end
end
F._xrayObjs[o] = true
pcall(function() o.LocalTransparencyModifier = 1 end)
end
F.XRayScan = function()
local list = {}
pcall(function() list = workspace:GetDescendants() end)
local i
for i = 1, #list do
if F._xrayObjs[list[i]] == nil then F.XRayApply(list[i]) end
end
local n = 0
for _ in pairs(F._xrayObjs) do n = n + 1 end
return n
end
F.XRayClear = function()
local n = 0
for o in pairs(F._xrayObjs) do
pcall(function() o.LocalTransparencyModifier = 0 end)
n = n + 1
end
F._xrayObjs = {}
return n
end
F.XRaySet = function(on)
T.XRay = on and true or false
if F._xrayAdded then pcall(function() F._xrayAdded:Disconnect() end) F._xrayAdded = nil end
if F._xrayLoop then pcall(function() F._xrayLoop:Disconnect() end) F._xrayLoop = nil end
if not T.XRay then
local n = F.XRayClear()
F.Out("[穿墙透视] 已关 · 墙壁已恢复(" .. tostring(n) .. " 个物件)")
return
end
local n = F.XRayScan()
F.Out("[穿墙透视] 已开 · 已透明化 " .. tostring(n) .. " 个物件(玩家角色保持可见)")
pcall(function()
F._xrayAdded = workspace.DescendantAdded:Connect(function(o)
pcall(function()
if not T.XRay then return end
task.wait(0.2)
F.XRayApply(o)
end)
end)
end)
F._xrayLoop = RS.Heartbeat:Connect(function()
if not T.XRay then F.XRaySet(false) return end
local now = os.clock()
if now - (F._xrayAt or 0) < 3 then return end
F._xrayAt = now
for o in pairs(F._xrayObjs) do
if not o.Parent then F._xrayObjs[o] = nil end
end
local list = {}
pcall(function() list = workspace:GetChildren() end)
local i
for i = 1, #list do F.XRayApply(list[i]) end
end)
end
F.AllyTagRefresh = function()
if not T.AllyMark then return end
local host = nil
pcall(function() host = gethui and gethui() end)
if not host then pcall(function() host = CoreGui end) end
local myTeam = nil
pcall(function() myTeam = LP.Team end)
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP then
local g = F._allyTags[pl]
local isAlly = false
pcall(function() isAlly = (myTeam ~= nil and pl.Team == myTeam) end)
local ch = pl.Character
local head = ch and ch:FindFirstChild("Head")
if isAlly and head and host then
if not g then
g = Instance.new("BillboardGui")
g.Name = "CMAllyTag"
g.AlwaysOnTop = true
g.Size = UDim2.fromOffset(120, 20)
g.StudsOffsetWorldSpace = Vector3.new(0, 2.8, 0)
g.MaxDistance = 500
local lb = Instance.new("TextLabel")
lb.Name = "T"
lb.Size = UDim2.fromScale(1, 1)
lb.BackgroundTransparency = 1
lb.TextScaled = true
lb.Font = Enum.Font.GothamBold
lb.TextColor3 = Color3.fromRGB(0, 255, 80)
lb.TextStrokeTransparency = 0.3
lb.Text = "[队友] " .. pl.Name
lb.Parent = g
g.Adornee = head
pcall(function() g:SetAttribute("CMOwned", true) end)
g.Parent = host
F._allyTags[pl] = g
else
pcall(function() g.Adornee = head g.Enabled = true end)
end
else
if g then pcall(function() g.Enabled = false end) end
end
end
end
end
F.AllyMarkClear = function()
for _, g in pairs(F._allyTags) do pcall(function() g:Destroy() end) end
F._allyTags = {}
end
F.AllyMarkSet = function(on)
T.AllyMark = on and true or false
if F._allyRefresh then pcall(function() F._allyRefresh:Disconnect() end) F._allyRefresh = nil end
if not T.AllyMark then
F.AllyMarkClear()
F.Out("[队友标记] 已关")
return
end
F._allyRefresh = RS.Heartbeat:Connect(function()
if not T.AllyMark then pcall(F.AllyMarkSet, false) return end
local now = os.clock()
if now - (F._allyAt or 0) < 0.5 then return end
F._allyAt = now
pcall(F.AllyTagRefresh)
end)
F.Out("[队友标记] 已开(队友头顶显示绿色 [队友] 名字)")
end
F._vehLoop, F._vehAt = nil, 0
F.VehicleBoostDisable = function()
if F._vehLoop then pcall(function() F._vehLoop:Disconnect() end) F._vehLoop = nil end
F._vehRef, F._vehParts, F._vehScanAt = nil, nil, 0
F.Out("[载具加速] 已关")
end
F.VehicleBoostEnable = function()
if F._vehLoop then return end
F._vehAt = 0
F._vehLoop = RS.Heartbeat:Connect(function()
if not T.VehicleBoost then F.VehicleBoostDisable() return end
local now = os.clock()
if now - (F._vehAt or 0) < 0.05 then return end
F._vehAt = now
local _, hum, root = GC()
if not (hum and root) then return end
local seat = nil
pcall(function() seat = hum.SeatPart end)
if seat == nil then return end
local veh = nil
pcall(function() veh = seat.Parent or seat end)
if veh == nil then return end
local speed = tonumber(C.SpeedValue) or tonumber(C.VehicleSpeed) or 60
local dir = nil
local vel = root.AssemblyLinearVelocity
local hv = Vector3.new(vel.X, 0, vel.Z)
if hv.Magnitude > 1 then
dir = hv.Unit
else
pcall(function() dir = root.CFrame.LookVector end)
end
if dir == nil then return end
local n = 0
if F._vehRef ~= veh or (now - (F._vehScanAt or 0) > 2) then
F._vehRef = veh
F._vehScanAt = now
local parts = {}
pcall(function()
for _, p in ipairs(veh:GetDescendants()) do
if p:IsA("BasePart") then parts[#parts + 1] = p end
end
end)
F._vehParts = parts
end
pcall(function()
local parts = F._vehParts
if not parts then return end
for i = 1, #parts do
local p = parts[i]
if p and p.Parent then
local v = p.AssemblyLinearVelocity
p.AssemblyLinearVelocity = Vector3.new(dir.X * speed, v.Y, dir.Z * speed)
n = n + 1
end
end
end)
end)
F.Out("[加速] 坐上载具会自动给载具推力 " .. tostring(tonumber(C.SpeedValue) or 60) .. " 格/秒(与加速同一个速度值)")
end
F.EspDraw = F.EspDraw or {}
F.EspDraw.VERSION = "1.0"
F.EspDraw.on = false
F.EspDraw.items = {}
F.EspDraw.opts = {
box = true, name = true, dist = true, tracer = true,
thick = 1, colorSelf = false,
}
function F.EspDraw.Available()
return type(Drawing) == "table" and type(Drawing.new) == "function"
end
function F.EspDraw.Obj(kind)
if not F.EspDraw.Available() then return nil end
local ok, o = pcall(function() return Drawing.new(kind) end)
if ok and o then return o end
return nil
end
function F.EspDraw.Make(pl)
local rec = {}
rec.box = F.EspDraw.Obj("Square")
rec.name = F.EspDraw.Obj("Text")
rec.dist = F.EspDraw.Obj("Text")
rec.tracer = F.EspDraw.Obj("Line")
pcall(function()
if rec.box then rec.box.Thickness = F.EspDraw.opts.thick rec.box.Filled = false rec.box.Visible = false end
if rec.name then rec.name.Center = true rec.name.Outline = true rec.name.Size = 14 rec.name.Visible = false end
if rec.dist then rec.dist.Center = true rec.dist.Outline = true rec.dist.Size = 13 rec.dist.Visible = false end
if rec.tracer then rec.tracer.Thickness = F.EspDraw.opts.thick rec.tracer.Visible = false end
end)
F.EspDraw.items[pl] = rec
return rec
end
function F.EspDraw.Release(rec)
if not rec then return end
for _, k in ipairs({ "box", "name", "dist", "tracer" }) do
if rec[k] then pcall(function() rec[k]:Remove() end) rec[k] = nil end
end
end
function F.EspDraw.Hide(rec)
if not rec then return end
pcall(function()
if rec.box then rec.box.Visible = false end
if rec.name then rec.name.Visible = false end
if rec.dist then rec.dist.Visible = false end
if rec.tracer then rec.tracer.Visible = false end
end)
end
function F.EspDraw.Tick()
if not (F.EspDraw.on and F.EspDraw.Available()) then return end
local cam = workspace.CurrentCamera
if not cam then return end
local vp = cam.ViewportSize
local vw, vh = vp.X, vp.Y
local list = Players:GetPlayers()
local o = F.EspDraw.opts
local myRoot = nil
pcall(function() local _, _, r = GC() myRoot = r end)
for i = 1, #list do
local pl = list[i]
local draw = (pl ~= LP) or o.colorSelf
if draw then
local rec = F.EspDraw.items[pl]
if rec == nil then rec = F.EspDraw.Make(pl) end
local ch = pl.Character
local head, hrp, hum = nil, nil, nil
if ch then
head = ch:FindFirstChild("Head")
hrp = ch:FindFirstChild("HumanoidRootPart")
hum = ch:FindFirstChildOfClass("Humanoid")
if not hrp then pcall(function() hrp = ch.PrimaryPart or ch:FindFirstChildWhichIsA("BasePart") end) end
if not hum then pcall(function() hum = ch:FindFirstChildWhichIsA("Humanoid") end) end
end
local shown = false
if rec and head and hrp and hum and hum.Health > 0 then
local topW = head.Position + Vector3.new(0, 0.55, 0)
local botW = hrp.Position - Vector3.new(0, 3, 0)
local t, tOn = cam:WorldToViewportPoint(topW)
local b, bOn = cam:WorldToViewportPoint(botW)
if tOn and bOn then
local h = math.abs(b.Y - t.Y)
if h >= 6 and h < 4000 then
shown = true
local w = h * 0.55
local x = t.X - w / 2
local y = t.Y
local col = Color3.fromRGB(255, 255, 255)
pcall(function() col = F.CMX_HLTeamColor(pl) end)
local dist = 0
if myRoot then pcall(function() dist = (myRoot.Position - hrp.Position).Magnitude end) end
if o.box and rec.box then
rec.box.Visible = true
rec.box.Position = Vector2.new(x, y)
rec.box.Size = Vector2.new(w, h)
rec.box.Color = col
end
if o.name and rec.name then
rec.name.Visible = true
rec.name.Position = Vector2.new(t.X, y - 16)
rec.name.Text = pl.Name
rec.name.Color = col
end
if o.dist and rec.dist then
rec.dist.Visible = true
rec.dist.Position = Vector2.new(t.X, y + h + 2)
rec.dist.Text = string.format("%.0f 格", dist)
rec.dist.Color = col
end
if o.tracer and rec.tracer then
rec.tracer.Visible = true
rec.tracer.From = Vector2.new(vw / 2, vh)
rec.tracer.To = Vector2.new(t.X, y + h)
rec.tracer.Color = col
end
end
end
end
if not shown then F.EspDraw.Hide(rec) end
end
end
for pl, rec in pairs(F.EspDraw.items) do
local still = false
for i = 1, #list do
if list[i] == pl then still = true break end
end
if not still then
F.EspDraw.Release(rec)
F.EspDraw.items[pl] = nil
end
end
end
function F.EspDraw.Set(on, opts)
on = on and true or false
if type(opts) == "table" then
for k, v in pairs(opts) do
if F.EspDraw.opts[k] ~= nil and type(v) == type(F.EspDraw.opts[k]) then
F.EspDraw.opts[k] = v
end
end
end
if on == F.EspDraw.on then
F.Out("[Drawing ESP] 已经是" .. (on and "开启" or "关闭") .. "状态")
return on
end
if on then
if not F.EspDraw.Available() then
F.Out("[Drawing ESP] ⚠ 当前执行器没有 Drawing API ⇒ 未开启。改用现有 ESP(Highlight/Billboard) 即可。")
return false
end
if F.EspDraw._conn then pcall(function() F.EspDraw._conn:Disconnect() end) end
F.EspDraw._conn = RS.RenderStepped:Connect(function() pcall(F.EspDraw.Tick) end)
F.EspDraw.on = true
F.Out("[Drawing ESP] 已开(不创建任何实例): 方框/名字/距离/连线 · 随时 EspDraw.Set(false) 关掉")
else
if F.EspDraw._conn then pcall(function() F.EspDraw._conn:Disconnect() end) F.EspDraw._conn = nil end
for pl, rec in pairs(F.EspDraw.items) do F.EspDraw.Release(rec) end
F.EspDraw.items = {}
F.EspDraw.on = false
pcall(function() if type(cleardrawcache) == "function" then cleardrawcache() end end)
F.Out("[Drawing ESP] 已关(所有绘制对象已释放 + 已清空 Drawing 缓存, 不留残影)")
end
return F.EspDraw.on
end
function F.EspDraw.Status()
local n = 0
for _ in pairs(F.EspDraw.items) do n = n + 1 end
return { available = F.EspDraw.Available(), on = F.EspDraw.on, tracked = n,
conn = F.EspDraw._conn ~= nil }
end
pcall(function()
if type(getgenv) == "function" then
local g = getgenv()
if type(g) == "table" then g.EspDraw = F.EspDraw end
end
end)
F.Out("[Drawing ESP] 模块就绪 v" .. tostring(F.EspDraw.VERSION)
.. " · Drawing " .. (F.EspDraw.Available() and "可用" or "不可用") .. " · EspDraw.Set(true) 开启")
F.EspTick = function()
local cam = workspace.CurrentCamera
if not cam then return end
local vp = cam.ViewportSize
local vw, vh = vp.X, vp.Y
local myRoot = nil
local okg, _, _, r0 = pcall(GC)
if okg then myRoot = r0 end
local list = Players:GetPlayers()
for i = 1, #list do
local pl = list[i]
if pl ~= LP then
local rec = F._espItems[pl]
if rec == nil then rec = F.EspMake(pl) end
local ch = pl.Character
local head, hrp, hum = nil, nil, nil
if ch then
head = ch:FindFirstChild("Head")
hrp = ch:FindFirstChild("HumanoidRootPart")
hum = ch:FindFirstChildOfClass("Humanoid")
if not hrp then pcall(function() hrp = ch.PrimaryPart or ch:FindFirstChildWhichIsA("BasePart") end) end
if not head then head = hrp end
if not hum then pcall(function() hum = ch:FindFirstChildWhichIsA("Humanoid") end) end
end
if rec and head and hrp and hum and hum.Health > 0 then
local topW = head.Position + Vector3.new(0, 0.55, 0)
local botW = hrp.Position - Vector3.new(0, 3, 0)
local t, tOn = cam:WorldToViewportPoint(topW)
local b, bOn = cam:WorldToViewportPoint(botW)
if tOn and bOn then
local h = math.abs(b.Y - t.Y)
if h >= 6 and h < 4000 then
local w = h * 0.55
local x = t.X - w / 2
local y = t.Y
local col = Color3.fromRGB(255, 255, 255)
pcall(function() col = F.CMX_HLTeamColor(pl) end)
if T.EspName then
rec.name.Visible = true
rec.name.Text = pl.Name
rec.name.TextColor3 = col
rec.name.Position = UDim2.fromOffset(math.floor(x - 30), math.floor(y - 20))
rec.name.Size = UDim2.fromOffset(math.floor(w + 60), 16)
else
rec.name.Visible = false
end
local dist = 0
if myRoot then dist = (hrp.Position - myRoot.Position).Magnitude end
if T.EspDist then
rec.dist.Visible = true
rec.dist.Text = string.format("%.0f 格", dist)
rec.dist.TextColor3 = col
rec.dist.Position = UDim2.fromOffset(math.floor(x - 30), math.floor(y + h + 2))
rec.dist.Size = UDim2.fromOffset(math.floor(w + 60), 14)
else
rec.dist.Visible = false
end
if T.EspHp then
local frac = 0
pcall(function() if hum.MaxHealth > 0 then frac = math.clamp(hum.Health / hum.MaxHealth, 0, 1) end end)
rec.hpBg.Visible = true
rec.hpBg.Position = UDim2.fromOffset(math.floor(x - 7), math.floor(y))
rec.hpBg.Size = UDim2.fromOffset(4, math.floor(h))
rec.hpFg.Size = UDim2.fromScale(1, frac)
rec.hpFg.Position = UDim2.fromScale(0, 1 - frac)
rec.hpFg.BackgroundColor3 = (frac > 0.35) and F.ESP_HEALTH_COLOR or F.ESP_LOWHP_COLOR
else
rec.hpBg.Visible = false
end
else
F.EspHideRec(rec)
end
else
F.EspHideRec(rec)
end
else
F.EspHideRec(rec)
end
end
end
end
F.EspSet = function(on)
T.EspOn = on and true or false
if F._espLoop then pcall(function() F._espLoop:Disconnect() end) F._espLoop = nil end
if not T.EspOn then
F.EspClear()
if F._espGui then pcall(function() F._espGui:Destroy() end) F._espGui = nil end
F.Out("[ESP] 已关")
return
end
F.EspEnsure()
F.Out("[ESP] 已开")
F._espLoop = RS.RenderStepped:Connect(function()
if not T.EspOn then F.EspSet(false) return end
local now = os.clock()
if now - (F._espAt or 0) < 0.033 then return end
F._espAt = now
pcall(F.EspTick)
end)
end
F._roleTags, F._roleTagConn = {}, nil
F.RoleTagRefresh = function()
local host = nil
pcall(function() host = gethui and gethui() end)
if not host then pcall(function() host = CoreGui end) end
for _, pl in ipairs(Players:GetPlayers()) do
if pl == LP then continue end
local ch = pl.Character
local head = ch and ch:FindFirstChild("Head")
local g = F._roleTags[pl]
if not head then
if g then pcall(function() g:Destroy() end) F._roleTags[pl] = nil end
continue
end
local name, col, key = F.RolePretty(pl)
if not g then
if not host then continue end
g = Instance.new("BillboardGui")
g.Name = "CMRoleTag"
g.AlwaysOnTop = true
g.Size = UDim2.fromOffset(130, 22)
g.StudsOffsetWorldSpace = Vector3.new(0, 2.6, 0)
g.MaxDistance = 400
local lb = Instance.new("TextLabel")
lb.Name = "T"
lb.Size = UDim2.fromScale(1, 1)
lb.BackgroundTransparency = 1
lb.TextScaled = true
lb.Font = Enum.Font.GothamBold
lb.TextStrokeTransparency = 0.3
lb.Text = "-"
lb.Parent = g
g.Adornee = head
g.Parent = host
pcall(function() g:SetAttribute("CMOwned", true) end)
F._roleTags[pl] = g
end
local lb = g and g:FindFirstChild("T")
if lb then
lb.Text = (key == "killer" and "[杀手] " or key == "sheriff" and "[警长] " or "") .. name
lb.TextColor3 = col
end
end
for plObj, g in pairs(F._roleTags) do
if not plObj.Parent then pcall(function() g:Destroy() end) F._roleTags[plObj] = nil end
end
end
F.RoleTagSet = function(on)
T.RoleTag = on and true or false
if F._roleTagConn then pcall(function() F._roleTagConn:Disconnect() end) F._roleTagConn = nil end
if not T.RoleTag then
for _, g in pairs(F._roleTags) do pcall(function() g:Destroy() end) end
F._roleTags = {}
F.Out("[角色识别] 头顶标记已关")
return
end
F.Out("[角色识别] 头顶标记已开(杀手/警长会标在头上)")
F._roleTagConn = RS.RenderStepped:Connect(function()
if not T.RoleTag then F.RoleTagSet(false) return end
local now = os.clock()
if now - (F._roleTagAt or 0) < 0.4 then return end
F._roleTagAt = now
F.RoleTagRefresh()
end)
end
F.ScanRoles = function()
local n, k, sh = 0, {}, {}
pcall(function()
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP then
n = n + 1
local _, _, key = F.RolePretty(pl)
local why = select(2, F.RoleOf(pl))
if key == "killer" then k[#k + 1] = pl.Name .. (why and (" (" .. why .. ")") or "")
elseif key == "sheriff" then sh[#sh + 1] = pl.Name .. (why and (" (" .. why .. ")") or "") end
end
end
end)
F.Out("[角色识别] 扫了 " .. tostring(n) .. " 人, 识别结果:")
for i = 1, #k do F.Out("   [杀手] " .. k[i]) end
for i = 1, #sh do F.Out("   [警长] " .. sh[i]) end
if #k == 0 and #sh == 0 then F.Out("   (没识别出杀手/警长 — 可能本局没分发, 或者该游戏不向客户端暴露角色)") end
end
F.GameEnemyNames = {}
F.RefreshGameEnemyNames = function()
local out = {}
pcall(function()
local hl = workspace:FindFirstChild("Highlight")
if not hl then return end
local en = hl:FindFirstChild("Enemy")
if not en then return end
local names = {}
local pls = Players:GetPlayers()
local i
for i = 1, #pls do names[pls[i].Name] = true end
local ds = en:GetDescendants()
for i = 1, #ds do
if names[ds[i].Name] then out[ds[i].Name] = true end
end
end)
F.GameEnemyNames = out
end
F.CMX_HLTeamColor = function(pl)
if T.TeamColorHL == false then return F.ROLE_COLOR.none end
local now2 = os.clock()
if now2 - (F._enemyScanAt or 0) > 2 then
F._enemyScanAt = now2
pcall(F.RefreshGameEnemyNames)
end
if F.GameEnemyNames and F.GameEnemyNames[pl.Name] then return Color3.fromRGB(255, 60, 60) end
if T.TeamColorHL == false then return F.ROLE_COLOR.none end
local mine, theirs = nil, nil
pcall(function() mine = LP.Team end)
pcall(function() theirs = pl.Team end)
if mine == nil or theirs == nil then return F.ROLE_COLOR.none end
if theirs == mine then return Color3.fromRGB(0, 255, 80) end
return Color3.fromRGB(255, 60, 60)
end
F._hlRP = nil
F._hlEx = {}
F.CMX_HLOccluded = function(pl, cam, myCh)
local ch = pl.Character
if not ch then return false end
local tgt = ch:FindFirstChild("HumanoidRootPart")
if not tgt then tgt = ch:FindFirstChild("Head") end
if not (tgt and cam) then return false end
local origin = cam.CFrame.Position
local dir = tgt.Position - origin
local d = dir.Magnitude
if d < 0.5 or d > 600 then return false end
if not F._hlRP then
local rp = RaycastParams.new()
rp.FilterType = Enum.RaycastFilterType.Exclude
rp.IgnoreWater = true
F._hlRP = rp
end
local ex = F._hlEx
local ei
for ei = #ex, 1, -1 do ex[ei] = nil end
ex[1] = ch
ex[2] = cam
ex[3] = myCh
local okb, allb = pcall(function() return Players:GetPlayers() end)
if okb and allb then
local bi, bc
for bi = 1, #allb do
bc = allb[bi].Character
if bc ~= nil and bc ~= ch then ex[#ex + 1] = bc end
end
end
F._hlRP.FilterDescendantsInstances = ex
local ok, hit = pcall(workspace.Raycast, workspace, origin, dir, F._hlRP)
if ok and hit then return true end
return false
end
F.CMX_HLApply = function(pl, rec)
if not rec or not rec.top then return end
local team = F.CMX_HLTeamColor(pl)
local wall = rec.wall
if wall == nil then
local cam = workspace.CurrentCamera
wall = F.CMX_HLOccluded(pl, cam, LP.Character)
rec.wall = wall
end
local fill = wall and 1 or 0.45
pcall(function()
rec.top.FillColor = team
rec.top.OutlineColor = team
rec.top.FillTransparency = fill
rec.top.OutlineTransparency = 0
rec.top.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end)
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
top.FillTransparency = 0.6
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
if pl.Character then task.defer(function() F.BodyHLAdd(pl) F.BodyHLRefresh() end) end
pl.CharacterAdded:Connect(function() task.wait(0.4) F.BodyHLAdd(pl) F.BodyHLRefresh() end)
end)
end
if not F._hlWallLoop then
F._hlWallLoop = RS.Heartbeat:Connect(function()
if not T.BodyHL then return end
local now = os.clock()
if now - (F._hlWallAt or 0) < 0.2 then return end
F._hlWallAt = now
local cam = workspace.CurrentCamera
if not cam then return end
local myCh = LP.Character
for pl, rec in pairs(F._hlObjs) do
if type(rec) == "table" and rec.top and rec.top.Parent then
local wall = F.CMX_HLOccluded(pl, cam, myCh)
if rec.wall ~= wall then
rec.wall = wall
pcall(function() rec.top.FillTransparency = wall and 1 or 0.45 end)
end
end
end
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
if F._hlWallLoop then F._hlWallLoop:Disconnect() F._hlWallLoop = nil end
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
F.OptSet(fop, T.FlyOn)
end
local sop = Fluent.Options.SpeedOn
if sop and type(T.SpeedOn) == "boolean" and sop.Value ~= T.SpeedOn then
F.OptSet(sop, T.SpeedOn)
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
if type(v) == "boolean" and v and k ~= "TransModel" then keep[k] = true n = n + 1 end
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
F.SrcVerOf = function(s)
if type(s) ~= "string" then return nil end
local i = s:find("F.VERSION", 1, true)
if not i then return nil end
return s:sub(i, i + 48):match("v(%d+%.%d+%.%d+)")
end
F.CacheVer = function()
local v = nil
pcall(function()
if type(readfile) ~= "function" or type(isfile) ~= "function" or not isfile("CheatMenu_main.lua") then return end
local s = readfile("CheatMenu_main.lua")
if type(s) == "string" and #s > 100000 then v = F.SrcVerOf(s) end
end)
return v
end
F.CacheSync = function()
task.spawn(function()
task.wait(8)
local cur = tostring(F.VERSION or ""):gsub("^v", "")
local cv = F.CacheVer()
if not cv then return end
if F.VerNum(cv) >= F.VerNum(cur) then return end
local got, gv = nil, nil
local urls = F.REMOTE_URLS
for i = 1, #urls do
if got then break end
local ok, body = pcall(function() return game:HttpGet(urls[i] .. "?t=" .. tostring(os.time())) end)
if ok and type(body) == "string" and #body > 100000 and body:sub(1, 9) ~= "<!DOCTYPE" and not body:find("404: Not Found", 1, true) then
local v = F.SrcVerOf(body)
if v and F.VerNum(v) >= F.VerNum(cur) then got, gv = body, v end
end
end
if got then
F.CacheWrite(got)
F.Out("[缓存] 重进用的主脚本缓存是旧版 v" .. cv .. " ⇒ 已刷新为 v" .. tostring(gv))
else
pcall(function() if type(delfile) == "function" then delfile("CheatMenu_main.lua") end end)
F.Out("[缓存] 缓存 v" .. cv .. " 陈旧、这次又拉不到新版 ⇒ 已删除(免得重进时加载旧版)")
end
end)
end
F.CacheWrite = function(body)
if type(writefile) ~= "function" or type(body) ~= "string" or #body < 100000 then return false end
return (pcall(writefile, "CheatMenu_main.lua", body))
end
F.ReloadFresh = function()
if F._reloading then return false end
F._reloading = true
local keep, n = {}, 0
for k, v in pairs(T) do
if type(v) == "boolean" and v and k ~= "TransModel" then keep[k] = true n = n + 1 end
end
local src, sv = nil, nil
pcall(function()
if type(readfile) == "function" and type(isfile) == "function" and isfile("CheatMenu_main.lua") then
local s = readfile("CheatMenu_main.lua")
if type(s) == "string" and #s > 100000 then src = s end
end
end)
if src then sv = F.SrcVerOf(src) end
local cur = tostring(F.VERSION or ""):gsub("^v", "")
if not src or F.VerNum(sv or "0") < F.VerNum(cur) then
F._reloading = false
F.Out("[重载] 本地缓存" .. (src and ("是旧版 v" .. tostring(sv)) or "不存在") .. " ⇒ 改走联网拉最新版")
return F.HotReload(true)
end
local chunk = (loadstring or load)(src, "@CheatMenu_local")
if not chunk then
F._reloading = false
F.Out("[重载] 本地缓存编译失败 ⇒ 改走联网拉最新版")
return F.HotReload(true)
end
pcall(function() if getgenv then getgenv().CM_RELOAD_KEEP = keep end end)
F.Out("[重载] 用本地缓存 v" .. tostring(sv) .. " 重新注入(已记下 " .. tostring(n) .. " 个开着的功能)")
pcall(F.UnloadAll)
task.wait(0.6)
pcall(chunk)
return true
end
F.PANIC_KEEP = { CharPersist = true, AutoSave = true, GuiProtect = true,
AntiAFK = true, GuardOn = true, HitGuard = true, SteadyOn = true,
TrapWarn = true, SpeedGuard = true, LockHealthSolo = true,
NoScreenFx = true }
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
for _, fn in ipairs({ GodDisable, FOVDisable, ZoomDisable, AntilagDisable, MuteDisable, LockHealthDisable, RegenDisable, F.InvisibleDisable, F.CarryGuardDisable, F.GuardOnDisable, F.SpeedFreeDisable, F.NoPullDisable, F.KickGuardPathsDisable }) do pcall(fn) end
for _, fn in ipairs({ F.HudDisable, F.CrosshairDisable, F.FovCircleDisable, F.FlingStop, F.FlingLoopStop, F.ClickTPDisable, F.BulletTrackDisable, F.WallClimbDisable, F.NoRecoilDisable, F.PierceDisable, F.TrapAutoRemoveDisable, F.KillAuraDisable, F.GodModeSet, F.AntiKnockdownDisable, F.NoClipDisable, F.HideDisable, F.InfiniteJumpDisable, F.FullBrightDisable, F.NightVisionDisable, F.NoFogDisable, F.TranslateDisable }) do pcall(fn) end
for _, fn in ipairs({ F.AimSet, F.RoleTagSet, F.IxHLSet, F.EspSet, F.XRaySet, F.AllyMarkSet, F.VehicleBoostDisable, F.BodyHLDisable, F.CharPersistDisable, F.LivePlayersDisable, F.GuiProtectionDisable, F.SpeedAntiTPDisable, F.SpeedRestore, F.FlySet, F.FlyDestroy, F.HeliSet, F.HeliDestroy, F.BypassDisable, F.AllInOneDisableAll, F.PinDisable, F.SpoofDisable, F.MetaHookUninstall, F.AntiCheatGCRestore, F.DeepNeuterDisable, F.AutoTrainDisable, F.AutoBonusDisable, F.AutoGymDisable, F.HealthIsolateDisable, F.LockFieldsUninstall }) do pcall(fn) end
for _, fn in ipairs({ AC.UninstallNamecallHook, AC.UninstallIndexMask, AC.UnblockRemotes, AC.ReenableDisabledConns, AC.UninstallAntiTP, AC.UninstallSetmetatableHook, AC.WatchNewScriptsDisable, AC.WatchNewRemotesDisable, AC.AntiPauseDisable, AC.TrapDisable.Disable, F.InstantInteractDisable, F.CMX_DisableAll, F.LightWatchDisable }) do pcall(fn) end
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
F.OptSet(opt, false)
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
Fluent:Notify({ Title = "一键全关", Content = "已关闭所有功能并恢复原始状态", Duration = 3 })
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
local plr = LP or Players.LocalPlayer
if plr then
if not F._orig.maxZoom then F._orig.maxZoom = plr.CameraMaxZoomDistance end
if not F._orig.minZoom then F._orig.minZoom = plr.CameraMinZoomDistance end
end
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
F._tpTries = 0
F._tpFailConn = ts.TeleportInitFailed:Connect(function(plr, code, msg)
if plr ~= LP then return end
F._tpTries = (F._tpTries or 0) + 1
if F._tpTries > 3 then
F.Out("[重进] 传送连续失败 " .. tostring(F._tpTries) .. " 次(" .. tostring(code) .. " " .. tostring(msg)
.. ") ⇒ 传送这条路走不通, 自动改为脚本内重新注入")
if F._tpFailConn then pcall(function() F._tpFailConn:Disconnect() end) F._tpFailConn = nil end
pcall(F.ReloadFresh)
return
end
F.Out("[重进] 传送失败(第 " .. tostring(F._tpTries) .. " 次): " .. tostring(code) .. " · " .. tostring(msg) .. " ⇒ 3 秒后自动重试")
local job0 = tostring(game.JobId or "")
task.delay(3, function()
pcall(function()
if job0 ~= "" then ts:TeleportToPlaceInstance(game.PlaceId, job0, LP) else ts:Teleport(game.PlaceId, LP) end
end)
end)
end)
task.delay(30, function()
if F._tpFailConn then pcall(function() F._tpFailConn:Disconnect() end) F._tpFailConn = nil end
end)
end)
F.Out("[重进] 正在回到当前服务器(" .. tostring(game.PlaceId) .. " · " .. jid:sub(1, 12) .. ")")
local ok = pcall(function() ts:TeleportToPlaceInstance(game.PlaceId, jid, LP) end)
if ok then
task.delay(12, function()
if (F._tpTries or 0) > 0 then return end
if tostring(game.JobId or "") ~= jid then return end
if LP == nil or LP.Parent ~= Players then return end
F.Out("[重进] ⚠ 传了 12 秒人还在原服(传到自己所在服务器常被服务器忽略) ⇒ 自动改为脚本内重新注入")
pcall(function() if F._tpFailConn then F._tpFailConn:Disconnect() F._tpFailConn = nil end end)
pcall(F.ReloadFresh)
end)
pcall(function() Fluent:Notify({ Title = "重新进入", Content = "正在回到当前服务器…", Duration = 3 }) end)
return true
end
F.Out("[重进] 回本服失败(执行器可能禁了) 改为重进游戏(会换服务器)")
local ok2 = pcall(function() ts:Teleport(game.PlaceId, LP) end)
if ok2 then
pcall(function() Fluent:Notify({ Title = "重新进入", Content = "已改为重进游戏(可能换服)", Duration = 3 }) end)
else
F.Out("[重进] 传送两种方式都被挡 ⇒ 自动改为脚本内重新注入")
pcall(F.ReloadFresh)
end
return ok2
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
local function gymChar() return LP.Character end
local function gymHum() local ch = gymChar() return ch and ch:FindFirstChildOfClass("Humanoid") or nil end
local function gymRoot() local ch = gymChar() return ch and (ch.PrimaryPart or ch:FindFirstChild("HumanoidRootPart")) or nil end
local function gymAlive() local h = gymHum() return h ~= nil and h.Health > 0 and gymRoot() ~= nil end
local function gymWaitAlive(timeout)
local deadline = os.clock() + (timeout or 10)
while os.clock() < deadline do
if gymAlive() then return true end
task.wait(0.1)
end
return gymAlive()
end
local function gymHasTag(instance, tag)
if not instance then return false end
local ok, result = pcall(function() return instance:HasTag(tag) end)
return ok and result == true
end
local function gymUnequipUnanchor()
pcall(function()
local hum = gymHum()
if hum then hum:UnequipTools() end
local root = gymRoot()
if root then
root.Anchored = false
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end
end)
end
local function gymWalkTo(position, timeout, radius)
if typeof(position) ~= "Vector3" or not gymWaitAlive(5) then return false end
local hum = gymHum()
if not hum then return false end
gymUnequipUnanchor()
radius = tonumber(radius) or 5
local deadline = os.clock() + (timeout or 12)
while os.clock() < deadline do
local root = gymRoot()
if not root then return false end
if (root.Position - position).Magnitude <= radius then return true end
pcall(function() hum:MoveTo(position) end)
task.wait(0.1)
end
local root = gymRoot()
return root ~= nil and (root.Position - position).Magnitude <= radius
end
local function gymEquippedWeightTool()
local ch = gymChar()
if ch then
for _, tool in ipairs(ch:GetChildren()) do
if tool:IsA("Tool") and (gymHasTag(tool, "SquatTool") or GYM_WEIGHT_NAMES[tool.Name] ~= nil) then return tool end
end
end
local fallback
for _, container in ipairs({ LP:FindFirstChild("Backpack"), ch }) do
if container then
for _, tool in ipairs(container:GetChildren()) do
if tool:IsA("Tool") and (gymHasTag(tool, "SquatTool") or GYM_WEIGHT_NAMES[tool.Name] ~= nil) then
fallback = fallback or tool
end
end
end
end
return fallback
end
local Gym = {}
Gym.Event = { Active = false, LastSeenAt = 0, Machine = nil, MachineName = nil, LastVerifiedPart = nil, LastVerifiedMachine = nil }
Gym.TravelMode = "Teleport (Safe)"
Gym.currentLiftMachineMultiplier = function()
return math.max(1, tonumber(LP:GetAttribute("liftMachine")) or 1)
end
Gym.currentGymSpeedMultiplier = function()
return math.max(1, tonumber(LP:GetAttribute("gym_speed")) or 1)
end
Gym.currentGymPowerMultiplier = function()
return math.max(1, tonumber(LP:GetAttribute("gym_power")) or 1)
end
Gym.liveLiftMachines = function()
local result = {}
local ok, tagged = pcall(CS.GetTagged, CS, "LiftMachine")
if not ok or type(tagged) ~= "table" then return result end
for _, machine in ipairs(tagged) do
if machine and machine.Parent and machine:IsDescendantOf(WS) then result[#result + 1] = machine end
end
return result
end
Gym.nearestLiftMachine = function()
local machines = Gym.liveLiftMachines()
if #machines == 0 then return nil end
local root = gymRoot()
local best, bestDistance
for _, machine in ipairs(machines) do
local position
if machine:IsA("BasePart") then
position = machine.Position
elseif machine:IsA("Model") then
local ok, pivot = pcall(machine.GetPivot, machine)
if ok then position = pivot.Position end
end
if not position then
local part = machine:FindFirstChildWhichIsA("BasePart", true)
if part then position = part.Position end
end
local distance = root and position and (root.Position - position).Magnitude or 0
if not bestDistance or distance < bestDistance then
bestDistance = distance
best = machine
end
end
return best
end
Gym.gymTimeActive = function(force)
local machine = Gym.nearestLiftMachine()
if machine then
Gym.Event.Active = true
Gym.Event.LastSeenAt = os.clock()
Gym.Event.MachineName = machine.Name
Gym.Event.Machine = machine
return true, nil, machine
end
local grace = 1.50
local active = Gym.Event.Active and (os.clock() - (Gym.Event.LastSeenAt or 0) <= grace)
if not active then Gym.Event.Active = false end
return active, nil, nil
end
Gym.isDescendantOfNamedFolder = function(object, folderName)
local node = object and object.Parent
while node do
if node.Name == folderName then return true end
node = node.Parent
end
return false
end
Gym.liftMachinePartScore = function(part)
if not part or not part:IsA("BasePart") then return -math.huge end
local name = tostring(part.Name or ""):lower()
local score = 0
if Gym.isDescendantOfNamedFolder(part, "StandingPlatforms") then score = score + 1200 end
if Gym.isDescendantOfNamedFolder(part, "Hitboxes") then score = score + 1100 end
if name:find("standing", 1, true) or name:find("platform", 1, true) or name:find("pad", 1, true) then score = score + 500 end
if name:find("hitbox", 1, true) or name:find("zone", 1, true) then score = score + 450 end
if name:find("lift", 1, true) or name:find("squat", 1, true) then score = score + 250 end
if part.Transparency >= 0.95 and not part.CanCollide then score = score + 80 end
if part.Size.X >= 3 and part.Size.Z >= 3 then score = score + 60 end
return score
end
Gym.liftMachineCandidateParts = function(machine)
local candidates = {}
local seen = {}
local function add(part)
if part and part:IsA("BasePart") and part.Parent and not seen[part] then
seen[part] = true
candidates[#candidates + 1] = { Part = part, Score = Gym.liftMachinePartScore(part) }
end
end
if not machine then return candidates end
if machine:IsA("BasePart") then
add(machine)
elseif machine:IsA("Model") then
add(machine.PrimaryPart)
end
local standing = machine:FindFirstChild("StandingPlatforms", true)
if standing then
for _, child in ipairs(standing:GetDescendants()) do add(child) end
for _, child in ipairs(standing:GetChildren()) do add(child) end
end
local hitboxes = machine:FindFirstChild("Hitboxes", true)
if hitboxes then
for _, child in ipairs(hitboxes:GetDescendants()) do add(child) end
for _, child in ipairs(hitboxes:GetChildren()) do add(child) end
end
for _, descendant in ipairs(machine:GetDescendants()) do
if descendant:IsA("BasePart") then
local score = Gym.liftMachinePartScore(descendant)
if score >= 200 then add(descendant) end
end
end
if #candidates == 0 then
add(machine:FindFirstChildWhichIsA("BasePart", true))
end
table.sort(candidates, function(a, b) return a.Score > b.Score end)
return candidates
end
Gym.gymTargetPosition = function(part)
local root = gymRoot()
local hum = gymHum()
if not part or not root or not hum then return nil end
local lowName = tostring(part.Name or ""):lower()
local isHitbox = Gym.isDescendantOfNamedFolder(part, "Hitboxes")
or lowName:find("hitbox", 1, true)
or lowName:find("zone", 1, true)
if isHitbox then return part.Position end
local rootHalf = math.max(1, root.Size.Y * 0.5)
local yOffset = part.Size.Y * 0.5 + math.max(1.5, hum.HipHeight or 2) + rootHalf
return part.CFrame:PointToWorldSpace(Vector3.new(0, yOffset, 0))
end
Gym.moveToLiftMachinePart = function(part)
if not part or not part.Parent or not gymWaitAlive(3) then return false end
local root = gymRoot()
if not root or root.Anchored then return false end
local target = Gym.gymTargetPosition(part)
if not target then return false end
gymUnequipUnanchor()
local mode = tostring(Gym.TravelMode or "Teleport (Safe)")
if mode == "Manual" then
return Vector3.new(root.Position.X - target.X, 0, root.Position.Z - target.Z).Magnitude <= 7
end
if mode == "Teleport (Safe)" then
pcall(function()
local rotationOnly = root.CFrame - root.CFrame.Position
root.CFrame = CFrame.new(target) * rotationOnly
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
task.wait(0.16)
root = gymRoot()
return root ~= nil and (root.Position - target).Magnitude <= 8
end
return gymWalkTo(target, 12, 5)
end
Gym.ensureGymTrainingTool = function()
local tool = gymEquippedWeightTool()
local ch = gymChar()
if tool and ch and tool.Parent == ch and gymHasTag(tool, "SquatTool") then return tool end
tool = gymEquippedWeightTool()
if not tool then return nil end
if ch and tool.Parent ~= ch then
local hum = gymHum()
if hum then pcall(function() hum:EquipTool(tool) end) end
task.wait(0.08)
tool = gymEquippedWeightTool()
end
return tool
end
Gym.waitForLiftMachineRecognition = function(timeout)
local deadline = os.clock() + (timeout or 0.9)
while os.clock() < deadline do
if Gym.currentLiftMachineMultiplier() > 1 then return true end
F.GymClickBonusPopups(false)
task.wait(0.025)
end
return Gym.currentLiftMachineMultiplier() > 1
end
Gym.gymMachineProgress = function(machine)
if not machine or not machine.Parent then return 1, 0, 0 end
local multiplier = tonumber(machine:GetAttribute("Multiplier")) or Gym.currentLiftMachineMultiplier() or 1
local squats = tonumber(machine:GetAttribute("Squats")) or 0
local goal = tonumber(machine:GetAttribute("Goal")) or 0
return multiplier, squats, goal
end
Gym.gymMachineNeedsReenter = function()
local machine = Gym.Event.Machine
if not machine or not machine.Parent or not machine:IsDescendantOf(WS) then return true end
if Gym.currentLiftMachineMultiplier() <= 1 then return true end
local tool = gymEquippedWeightTool()
local ch = gymChar()
if not tool or not ch or tool.Parent ~= ch or not gymHasTag(tool, "SquatTool") then return true end
return false
end
Gym.enterGymMachine = function(forceRescan)
local machine = forceRescan and Gym.nearestLiftMachine() or Gym.Event.Machine
if not machine or not machine.Parent or not machine:IsDescendantOf(WS) then
machine = Gym.nearestLiftMachine()
end
if not machine then return false end
Gym.Event.Machine = machine
Gym.Event.MachineName = machine.Name
if Gym.currentLiftMachineMultiplier() > 1 then
Gym.ensureGymTrainingTool()
return true
end
local candidates = Gym.liftMachineCandidateParts(machine)
local lastPart = Gym.Event.LastVerifiedPart
if Gym.Event.LastVerifiedMachine == machine and lastPart and lastPart.Parent then
table.insert(candidates, 1, { Part = lastPart, Score = math.huge })
end
local maximum = math.min(#candidates, 10)
for index = 1, maximum do
local part = candidates[index].Part
if Gym.moveToLiftMachinePart(part) then
local tool = Gym.ensureGymTrainingTool()
if tool and Gym.waitForLiftMachineRecognition(0.90) then
Gym.Event.LastVerifiedMachine = machine
Gym.Event.LastVerifiedPart = part
return true
end
end
gymUnequipUnanchor()
task.wait(0.05)
end
return Gym.currentLiftMachineMultiplier() > 1
end
local _bonusBtnAt = setmetatable({}, { __mode = "k" })
F.GymGuiVisible = function(object)
if not object or not object:IsA("GuiObject") or not object.Visible then return false end
local parent = object.Parent
while parent do
if parent:IsA("GuiObject") and not parent.Visible then return false end
if parent:IsA("ScreenGui") and not parent.Enabled then return false end
parent = parent.Parent
end
return true
end
local function gymMultFromText(value)
local compact = tostring(value or ""):upper():gsub("%s+", ""):gsub("×", "X")
if compact == "X2" or compact == "2X" then return 2
elseif compact == "X5" or compact == "5X" then return 5
elseif compact == "X10" or compact == "10X" then return 10 end
return nil
end
local function gymMultForButton(button)
if not button or not button:IsA("GuiButton") then return nil end
if button:IsA("TextButton") then
local direct = gymMultFromText(button.Text)
if direct then return direct end
end
local ok, descendants = pcall(button.GetDescendants, button)
if ok and type(descendants) == "table" then
for _, child in ipairs(descendants) do
if child:IsA("TextLabel") or child:IsA("TextButton") then
local m = gymMultFromText(child.Text)
if m then return m end
end
end
end
local parent = button.Parent
if parent and parent:IsA("GuiObject") then
local children = parent:GetChildren()
local pn = tostring(parent.Name or ""):lower()
local bn = tostring(button.Name or ""):lower()
local likely = pn:find("bonus", 1, true) or pn:find("tavi", 1, true) or pn:find("mish", 1, true) or pn:find("mult", 1, true)
or bn:find("bonus", 1, true) or bn:find("tavi", 1, true) or bn:find("mish", 1, true)
if likely or #children <= 12 then
for _, child in ipairs(children) do
if child:IsA("TextLabel") or child:IsA("TextButton") then
local m = gymMultFromText(child.Text)
if m then return m end
end
end
end
end
return nil
end
F.GymClickButton = function(button)
if not button or not button:IsA("GuiButton") then return false end
if type(getconnections) == "function" and type(firesignal) == "function" then
local order = { "Activated", "MouseButton1Click" }
for i = 1, #order do
local sig = nil
pcall(function() sig = button[order[i]] end)
if sig then
local cnt = 0
pcall(function()
local cs = getconnections(sig)
if type(cs) == "table" then cnt = #cs end
end)
if cnt > 0 then
if pcall(function() firesignal(sig) end) then return true end
end
end
end
local dn, up = nil, nil
pcall(function() dn = button.MouseButton1Down up = button.MouseButton1Up end)
local cdn = 0
pcall(function()
local cs = getconnections(dn)
if type(cs) == "table" then cdn = #cs end
end)
if cdn > 0 and dn then
pcall(function() firesignal(dn) end)
if up then pcall(function() firesignal(up) end) end
return true
end
end
if not button.Visible or button.AbsoluteSize.X <= 1 or button.AbsoluteSize.Y <= 1 then return false end
local used = false
if type(firesignal) == "function" then
pcall(function() firesignal(button.Activated) end)
pcall(function() firesignal(button.MouseButton1Click) end)
used = true
end
if not used and type(getconnections) == "function" then
pcall(function()
for _, sig in ipairs({ button.Activated, button.MouseButton1Click }) do
if sig then
for _, c in ipairs(getconnections(sig) or {}) do pcall(function() c:Fire() end) end
end
end
end)
used = true
end
return used
end
F.GymClickBonusPopups = function(force)
local now = os.clock()
if not force and now - (F._gymBonusAt or 0) < 0.025 then return 0 end
F._gymBonusAt = now
if not gymEquippedWeightTool() then return 0 end
if not PG then return 0 end
local clicked = 0
local ok, descendants = pcall(PG.GetDescendants, PG)
if not ok or type(descendants) ~= "table" then return 0 end
for _, object in ipairs(descendants) do
if object:IsA("GuiButton") and F.GymGuiVisible(object) then
local multiplier = gymMultForButton(object)
if multiplier == nil then
local nm = tostring(object.Name or "")
if nm == "Bonus" or nm == "PopBonus" then multiplier = 0 end
end
if multiplier then
local last = _bonusBtnAt[object] or 0
if now - last >= 0.20 then
_bonusBtnAt[object] = now
if F.GymClickButton(object) then
clicked = clicked + 1
F._gymBonusClicks = (F._gymBonusClicks or 0) + 1
task.delay(0.01, function() pcall(function() F.FireSrv("TaviMishkal") end) end)
end
end
end
end
end
if clicked > 0 and F.LogRate("gym_bonus", 8) then
F.Out("[锻炼] 已点掉 " .. tostring(clicked) .. " 个 ×2/×5 锻炼弹窗(累计 " .. tostring(F._gymBonusClicks or 0) .. ")")
end
return clicked
end
F.NetRoot = function()
local r = nil
pcall(function()
local rss = game:GetService("ReplicatedStorage")
local sh = rss:FindFirstChild("Shared")
local pk = sh and sh:FindFirstChild("Packages")
r = pk and pk:FindFirstChild("Network")
end)
return r
end
F.RemoteByName = function(name)
local root = F.NetRoot()
if not root then return nil end
local r = nil
pcall(function() r = root:FindFirstChild("rev_" .. tostring(name)) end)
if r and r:IsA("RemoteEvent") then return r end
return nil
end
F.FireSrv = function(name, ...)
local remote = F.RemoteByName(name)
if not remote then return false end
local args = table.pack(...)
return (pcall(function() remote:FireServer(table.unpack(args, 1, args.n)) end))
end
local TrainThread = nil
function F.AutoTrainEnable()
if TrainThread then return end
F.Out("[自动锻炼] 已启动: 手持配重 + 反复触发锻炼动作 —— 只在原地练, 不移动、不传送、不领奖(要自动领 ×2/×5 奖励请开「自动领取」)")
TrainThread = task.spawn(function()
local logAt = 0
while T.AutoTrain do
pcall(function()
local tool = gymEquippedWeightTool()
local hum = gymHum()
local ch = gymChar()
if tool then
if ch and hum and tool.Parent ~= ch then pcall(function() hum:EquipTool(tool) end) end
pcall(function() tool:Activate() end)
F._trainActions = (F._trainActions or 0) + 1
end
if os.clock() - logAt > 15 then
logAt = os.clock()
if tool then
F.Out("[自动锻炼] 正在练 · 手持 " .. tostring(tool.Name) .. " · 已触发 " .. tostring(F._trainActions or 0) .. " 次")
else
F.Out("[自动锻炼] 背包里没找到配重(带 SquatTool 标签或配重名) ⇒ 先自己拿/买一个配重")
end
end
end)
task.wait(0.3)
end
TrainThread = nil
end)
end
function F.AutoTrainDisable()
T.AutoTrain = false
TrainThread = nil
F.Out("[自动锻炼] 已停止")
end
local GymThread = nil
function F.AutoGymEnable()
if GymThread then return end
Gym.TravelMode = "Teleport (Safe)"
F.Out("[自动传送健身房] 已启动(照搬参考脚本): 自动传送到最近的 LIFT 举铁机并站上去, 站到游戏认可为止")
GymThread = task.spawn(function()
while T.AutoGym do
pcall(function()
local active, _, machine = Gym.gymTimeActive(true)
if not active then
if not F._gymWaitLogged then
F._gymWaitLogged = true
F.Out("[自动传送健身房] 场上暂无健身房事件 ⇒ 静默等待中(事件一出现就过去, 期间不再刷提示)")
end
else
if F._gymWaitLogged then
F._gymWaitLogged = false
F.Out("[自动传送健身房] 健身房事件出现了 ⇒ 过去站机器")
end
if machine then Gym.Event.Machine = machine end
if Gym.gymMachineNeedsReenter() then
gymUnequipUnanchor()
Gym.enterGymMachine(true)
else
Gym.ensureGymTrainingTool()
end
F.GymClickBonusPopups(false)
if os.clock() - (F._gymLogAt or 0) > 10 then
F._gymLogAt = os.clock()
local m, squats, goal = Gym.gymMachineProgress(Gym.Event.Machine)
F.Out(string.format("[自动传送健身房] %s · 进度 x%.0f %.0f/%.0f · 机器 x%.1f",
tostring(Gym.Event.MachineName or "?"), m, squats, goal, Gym.currentLiftMachineMultiplier()))
end
end
end)
task.wait(0.25)
end
GymThread = nil
end)
end
function F.AutoGymDisable()
T.AutoGym = false
GymThread = nil
F._gymWaitLogged = nil
F.Out("[自动传送健身房] 已停止")
end
local BonusThread = nil
function F.AutoBonusEnable()
if BonusThread and T.AutoBonus then return end
F.Out("[自动领取] 已启动: 只领锻炼/健身弹出的多倍奖励(×2 / ×5 / ×10), 不领其他任何东西")
BonusThread = task.spawn(function()
local logAt = 0
while T.AutoBonus do
pcall(function()
local n = F.GymClickBonusPopups(false)
if n > 0 and os.clock() - logAt > 10 then
logAt = os.clock()
F.Out("[自动领取] 已领多倍锻炼奖励, 累计 " .. tostring(F._gymBonusClicks or 0) .. " 次")
end
end)
task.wait(0.35)
end
BonusThread = nil
end)
end
function F.AutoBonusDisable()
T.AutoBonus = false
BonusThread = nil
F.Out("[自动领取] 已停止")
end
do
F.RevResolve = function(leaf)
local node = RStorage
for _, seg in ipairs({ "Shared", "Packages", "Network", leaf }) do
local ok, child = pcall(function() return node:WaitForChild(seg, 5) end)
if not (ok and child) then return nil, seg end
node = child
end
return node
end
F.RevCached = function(key, leaf, tag)
local c = F[key]
if typeof(c) == "Instance" and c.Parent then return c end
local n, miss = F.RevResolve(leaf)
if not n then
F.Out("[" .. tostring(tag or "远程") .. "] 路径断了: ReplicatedStorage.Shared.Packages.Network." .. leaf .. " (" .. tostring(miss) .. " 找不到)")
return nil
end
F[key] = n
return n
end
F.Blast = function(node, maxSlot, perFrame)
maxSlot = tonumber(maxSlot) or 30
perFrame = tonumber(perFrame) or maxSlot
if perFrame < 1 then perFrame = 1 end
local n, fails = 0, 0
for i = 1, maxSlot do
if pcall(function() node:FireServer(i) end) then n = n + 1 else fails = fails + 1 end
if i % perFrame == 0 then task.wait() end
end
return n, fails
end
function F.WithdrawAll(maxSlot)
maxSlot = tonumber(maxSlot) or 30
task.spawn(function()
local node = F.RevCached("_revS", "rev_S_Interact", "收起脑红")
if not node then return end
local t0 = os.clock()
local n = F.Blast(node, maxSlot)
local cost = os.clock() - t0
F.Out("[收起脑红] 已一次全发槽位 1~" .. tostring(maxSlot) .. " 的 rev_S_Interact(成功 " .. tostring(n) .. " 次 · 耗时 "
.. string.format("%.3f", cost) .. " 秒 · 不等帧, 已到物理极限)")
pcall(function() Fluent:Notify({ Title = "收起脑红", Content = "已一次全发 1~" .. tostring(maxSlot) .. "(" .. tostring(n) .. " 次 · " .. string.format("%.3f", cost) .. " 秒)", Duration = 10 }) end)
end)
end
function F.CollectAllFindPlot()
local cands = { "Plots", "Plot", "Bases", "Base", "PlotsClient", "PlotsFolder", "PlayerPlots" }
for _, cn in ipairs(cands) do
local c = workspace:FindFirstChild(cn)
if c then
for _, p in ipairs(c:GetChildren()) do
local owner = nil
pcall(function() owner = p:GetAttribute("Owner") end)
if owner == nil then
local ov = nil
pcall(function() ov = p:FindFirstChild("Owner") end)
if ov and ov:IsA("ValueBase") then owner = ov.Value end
end
if owner == LP or (type(owner) == "string" and owner == LP.Name) or tostring(owner) == LP.Name then
return p, cn
end
end
end
end
return nil
end
function F.CollectAllSlots(plot)
local out = {}
local pod = nil
pcall(function() pod = plot:FindFirstChild("AnimalPodiums", true) end)
if pod then
for _, p in ipairs(pod:GetChildren()) do out[#out + 1] = p end
end
if #out == 0 then
for _, d in ipairs(plot:GetDescendants()) do
local num = tonumber(tostring(d.Name):match("^Slot[%s_%-]*(%d+)$"))
if num and num >= 1 and num <= 60 then out[num] = d end
end
end
return out
end
function F.CollectAllSlotPos(s)
local pos = nil
pcall(function()
if s:IsA("BasePart") then pos = s.Position
elseif s:IsA("Model") then
local pp = s.PrimaryPart or s:FindFirstChildWhichIsA("BasePart", true)
if pp then pos = pp.Position end
if not pos then pos = s:GetPivot().Position end
end
end)
return pos
end
function F.CollectAll(maxSlot)
maxSlot = tonumber(maxSlot) or 30
task.spawn(function()
local node = F.RevCached("_revB", "rev_B_Collect", "收集货币")
if not node then return end
local _, hum, root = GC()
if not root then F.Out("[收集货币] 没角色(没进游戏/重生中), 本次没动") return end
local origin = root.CFrame
local plot, cname = F.CollectAllFindPlot()
if not plot then
F.Out("[收集货币] ⚠ 找不到你的基地(试过 Plots/Plot/Bases/Base.., Owner 属性都非你) ⇒ 降级为原地直接发 remote")
local t0b = os.clock()
local nb = F.Blast(node, maxSlot)
F.Out("[收集货币] 已原地发送 " .. tostring(nb) .. " 次(未 TP · 耗时 " .. string.format("%.2f", os.clock() - t0b) .. " 秒)")
return
end
local slots = F.CollectAllSlots(plot)
F.Out("[收集货币] 基地「" .. tostring(plot.Name) .. "」(" .. tostring(cname) .. ") · 槽位 " .. tostring(#slots) .. " 个 ⇒ 流水线 TP 收(每帧 1 槽)")
local t0 = os.clock()
local n, tp, prev = 0, 0, nil
local GAP = 0.06
for i = 1, maxSlot do
if prev then
if pcall(function() node:FireServer(prev) end) then n = n + 1 end
end
local s = slots[i]
if s then
local pos = F.CollectAllSlotPos(s)
if pos then
tp = tp + 1
pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
pcall(function() root.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0)) end)
end
end
prev = i
task.wait(GAP)
end
if prev then
if pcall(function() node:FireServer(prev) end) then n = n + 1 end
end
pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
pcall(function() root.CFrame = origin end)
F.Out("[收集货币] ✅ TP " .. tostring(tp) .. " 个槽位 · 发送 " .. tostring(n) .. " 次 · 已回到原地 · 耗时 "
.. string.format("%.2f", os.clock() - t0) .. " 秒(每槽停留 " .. string.format("%.2f", GAP) .. " 秒, 等服务器确认新位置再领)")
pcall(function() Fluent:Notify({ Title = "收集货币", Content = "已 TP 逐个槽位收完(" .. tostring(n) .. " 次)并回到原地", Duration = 8 }) end)
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
if #p < 80 then scan(ch, p) end
end
end
local roots = { { pg:FindFirstChild("HUD"), "HUD" }, { pg:FindFirstChild("Frames"), "Frames" } }
for i = 1, #roots do
if roots[i][1] then scan(roots[i][1], roots[i][2]) end
end
if #found == 0 then
F.Out("  没扫到数字控件 —— 确认已在正确场景(基地内)")
else
for i = 1, #found do
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
end
local Trans = {}
Trans.HOST = "http://127.0.0.1:8080"
Trans.KEY = "rk_4a56fc43faa5edb9f7a0cafd4ad3e91f"
Trans.MODEL = "hymt2-7b"
Trans.FILE = "CheatMenu_TransCache.txt"
Trans.CACHE_PREFIX = "CheatMenu_Cache_"
Trans.OWNER = {}
Trans.IsMobile = false
pcall(function()
local plat = UIS:GetPlatform()
Trans.IsMobile = (plat == Enum.Platform.Android or plat == Enum.Platform.IOS)
end)
if not Trans.IsMobile and UIS.TouchEnabled and not UIS.KeyboardEnabled then Trans.IsMobile = true end
Trans.LANGS = {
zh = "Chinese", en = "English", ja = "Japanese", ko = "Korean",
th = "Thai", ru = "Russian", ar = "Arabic", id = "Indonesian",
}
Trans.BATCH = 6
Trans.MAX = 8
Trans.CACHE_MAX = 5000
Trans.SCAN_EVERY = 10
Trans.GLOSS_FILE = "CheatMenu_Glossary.txt"
F.GlossParse = function(txt)
local tbl, n = {}, 0
for line in tostring(txt or ""):gmatch("[^\r\n]+") do
local seg = line
local h = seg:find("#", 1, true)
if h then seg = seg:sub(1, h - 1) end
for pair in seg:gmatch("[^,]+") do
local a, b = pair:match("^%s*(.-)%s*->%s*(.-)%s*$")
if a and b and a ~= "" and b ~= "" then
tbl[a] = b
n = n + 1
end
end
end
return tbl, n
end
F.GlossLoad = function(force)
if Trans.GLOSS_TBL and not force then return Trans.GLOSS_TBL end
local txt = nil
if type(readfile) == "function" then
local ex = false
pcall(function()
if type(isfile) == "function" then ex = isfile(Trans.GLOSS_FILE) == true else ex = true end
end)
if ex then pcall(function() txt = readfile(Trans.GLOSS_FILE) end) end
end
if type(txt) ~= "string" or #txt < 20 then
txt = table.concat(Trans.GLOSSARY, "\n")
pcall(function()
if type(writefile) == "function" then
writefile(Trans.GLOSS_FILE, "# CheatMenu 术语表(本地固定译法, 直接当缓存用 —— 不占模型上下文)\n"
.. "# 格式: 英文->中文   多条用逗号分隔   # 开头是注释\n" .. txt .. "\n")
end
end)
F.Out("[术语表] 已生成 " .. Trans.GLOSS_FILE .. " (可自行编辑追加, 重载脚本生效)")
end
local t, n = F.GlossParse(txt)
Trans.GLOSS_TBL, Trans.GLOSS_N = t, n
return t
end
F.GlossApplyCache = function()
local t = Trans.GLOSS_TBL or F.GlossLoad()
local merged = {}
local bl = F.GlossParse(table.concat(Trans.GLOSSARY, "\n"))
for k, v in pairs(bl) do merged[k] = v end
for k, v in pairs(t) do merged[k] = v end
Trans.GLOSS_MERGED = merged
local add, tot = 0, 0
for en, zh in pairs(merged) do
tot = tot + 1
if Trans.Cache[en] ~= zh then Trans.Cache[en] = zh add = add + 1 end
local lc = en:lower()
if lc ~= en and Trans.Cache[lc] ~= zh then Trans.Cache[lc] = zh add = add + 1 end
local uc = en:upper()
if uc ~= en and uc ~= lc and Trans.Cache[uc] ~= zh then Trans.Cache[uc] = zh add = add + 1 end
end
return add, tot
end
F.GlossPromptFor = function(text, maxN)
local t = Trans.GLOSS_MERGED or Trans.GLOSS_TBL
if type(t) ~= "table" then return "", 0 end
if Trans._noGloss then return "", 0 end
local low = tostring(text or ""):lower()
if low == "" then return "", 0 end
local cand = {}
for en, zh in pairs(t) do
local e = en:lower()
if low:find(e, 1, true) then
local multi = en:find(" ", 1, true) ~= nil
if multi or #en >= 8 then
cand[#cand + 1] = { en = en, zh = zh, multi = multi }
end
end
end
if #cand == 0 then return "", 0 end
table.sort(cand, function(a, b)
if a.multi ~= b.multi then return a.multi end
if #a.en ~= #b.en then return #a.en > #b.en end
return a.en < b.en
end)
local picked = {}
for i = 1, #cand do
local c = cand[i]
local covered = false
for k = 1, #picked do
if picked[k].en:lower():find(c.en:lower(), 1, true) then covered = true break end
end
if not covered then
picked[#picked + 1] = c
if #picked >= (maxN or 6) then break end
end
end
if #picked == 0 then return "", 0 end
local out = {}
for i = 1, #picked do out[i] = picked[i].en .. "->" .. picked[i].zh end
return "\nTranslate game terms CONSISTENTLY (these exact phrases only):\n" .. table.concat(out, ", "), #picked
end
Trans.SYS_BASE = [[Translate the following game UI text into Simplified Chinese.
Translate LITERALLY and FAITHFULLY: keep the original meaning and wording as close as possible.
Do NOT paraphrase, rewrite, embellish, localize, or "improve" the wording. Never invent context.
Do NOT add, drop, reorder, summarize or explain anything. Keep the same length and structure as the source.
Judge words by the game's context (a game about blocks: "Block" = 方块, not 格挡).
Output ONLY the translation: no explanation, no quotes, no extra words.
Preserve the original line breaks and number of lines.
Keep numbers, emoji, URLs, player names and item / pet / mutation / skill names unchanged.
If the text is already Chinese, return it unchanged.
Keep these technical abbreviations as-is: CPS HUD FPS GUI UI ESP DPS XP HP MP FOV AFK NPC Ping.]]
Trans.GLOSS_HEAD = "\nTranslate game terms CONSISTENTLY:\n"
Trans.GLOSSARY = {
"Brainrot->脑红, Timmy->蒂米, Slot->槽位, Plot->基地,",
"Collect->收取, Withdraw->收起, Sell->售卖, Claim->领取, Gym->健身房, Lift Machine->举铁机,",
"Squat->举铁, Train->训练, Bonus->加成,",
"Coins->金币, Gold->金币, Cash->金币, Gems->宝石, XP->经验, HP->生命, MP->法力,",
"Loot->战利品, Kill->击杀, Death->死亡, Respawn->复活, Round->回合, Match->对局,",
"Objective->目标, Score->得分, Streak->连杀, Loadout->配装, Inventory->背包, Shop->商店,",
"Trade->交易, Quest->任务, Reward->奖励, Rank->段位, Damage->伤害, Shield->护盾,",
"Ammo->弹药, Reload->换弹, Headshot->爆头, Victory->胜利, Defeat->失败,",
"Kick Power->踢球力量, Kick->踢, Kickback->踢飞,",
"Tab->标签页, Menu->菜单, Home->主页, Back->返回, Next->下一步, Skip->跳过,",
"Join->加入, Leave->离开, Start->开始, Continue->继续, Confirm->确认, Cancel->取消,",
"Save->保存, Reset->重置, Equip->装备, Unequip->卸下, Upgrade->升级, Unlock->解锁.",
"Progress->进度, Completed->已完成, New->新, Coming Soon->即将推出, Locked->已锁定, Unlocked->已解锁,",
"Owned->已拥有, Purchased->已购买, Sold->已售出, Attack->攻击, Defense->防御, Speed->速度, Power->力量,",
"Odds->概率, Luck->幸运, Rebirth->重生, Exclusive->专属, Regular->普通, Event->活动, Pass->通行证,",
"Daily->每日, Weekly->每周, Seasonal->赛季, Season->赛季, Tasks->任务, In Progress->进行中.",
"Teleport->传送, Spawn->出生点, Leaderboard->排行榜, Season Pass->赛季通行证, Bundle->礼包, Offer->优惠,",
"Daily Reward->每日奖励, Login->登录, Sign Up->注册, Level Up->升级, Max Level->满级, Rank Up->段位提升,",
"Tier->阶位, Mutation->变异, Enchant->附魔, Craft->合成, Forge->锻造, Refine->精炼, Enhance->强化, Awaken->觉醒,",
"Pet->宠物, Egg->蛋, Hatch->孵化, Mount->坐骑, Skin->皮肤, Crate->宝箱, Chest->宝箱, Spin->抽奖, Wheel->转盘,",
"Key->钥匙, Token->代币, Ticket->门票, Voucher->兑换券, Mission->任务, Challenge->挑战, Milestone->里程碑,",
"Achievement->成就, Badge->徽章, Streak->连胜, Combo->连击, Critical->暴击, Dodge->闪避, Block Damage->格挡, Lucky Block->幸运方块, Friend Boost->好友加成, Friends Boost->好友加成, Heal->治疗,",
"Buff->增益, Debuff->减益, Cooldown->冷却, Energy->能量, Stamina->体力, Team->队伍, Squad->小队, Guild->公会,",
"Friend->好友, Party->组队, Gift->礼物, Mail->邮件, Notification->通知, Options->选项, Graphics->画质, Audio->音效,",
"Controls->操作, Quit->退出, Exit->退出, Resume->继续, Retry->重试, Loading->加载中, Please Wait->请稍候, Connecting->连接中.",
"Health->生命值, Armor->护甲, Weapon->武器, Melee->近战, Ranged->远程,",
"Gun->枪, Pistol->手枪, Rifle->步枪, Shotgun->霰弹枪, Sniper->狙击枪,",
"Bow->弓, Arrow->箭, Sword->剑, Axe->斧头, Dagger->匕首,",
"Wand->法杖, Clip->弹匣, Fire Rate->射速, Recoil->后坐力, Spread->散布,",
"Accuracy->精准度, Crit->暴击, Kill Streak->连杀, Assist->助攻, Revive->救起队友,",
"Knockdown->击倒, Stun->眩晕, Poison->中毒, Burn->灼烧, Freeze->冰冻,",
"Slow->减速, Immunity->免疫, Invincible->无敌, Arena->竞技场, Duel->决斗,",
"Boss->首领, Minion->小怪, Elite->精英, Wave->波次, Draw->平局,",
"Class->职业, Perk->特长, Ability->技能, Ultimate->终极技能, Mana->法力,",
"Parry->招架, Counter->反击, Hitbox->判定框, Respawn Time->复活时间, Lifesteal->吸血,",
"Thorns->反伤,",
"Currency->货币, Credit->信用点, Point->积分, Cost->花费, Discount->折扣,",
"Pack->礼包, Deal->优惠, Sale->特卖, Limited Time->限时, Restock->补货,",
"In Stock->有货, Out of Stock->缺货, Purchase->购买, Refund->退款, Balance->余额,",
"Earn->赚取, Spend->花费, Free Gift->免费礼物, Daily Shop->每日商店, Bundle Price->礼包价格,",
"Config->配置, Keybind->快捷键, Hotkey->热键, Toggle->开关, Slider->滑块,",
"Dropdown->下拉菜单, Default->默认, Apply->应用, Previous->上一个, Page->页面,",
"Search->搜索, Filter->筛选, Sort->排序, Refresh->刷新, Language->语言,",
"Fullscreen->全屏, Mute->静音, Volume->音量, Brightness->亮度, Quality->画质,",
"Zoom->缩放, Copy->复制, Paste->粘贴, Clear->清空, Send->发送,",
"Prestige->声望, Ascend->飞升, Trophy->奖杯, Medal->奖章, Title->称号,",
"Complete->完成, Battle Pass->战斗通行证, Progress Bar->进度条, Requirement->要求, Goal->目标,",
"Milestone Reward->里程碑奖励, Claim All->一键领取,",
"Clan->氏族, Invite->邀请, Ban->封禁, Report->举报, Add Friend->加好友,",
"Chat->聊天, Message->消息, Trade Request->交易请求, Gift Send->赠送,",
"Build->建造, Place->放置, Rotate->旋转, Undo->撤销, Redo->重做,",
"Resource->资源, Wood->木头, Stone->石头, Iron->铁, Diamond->钻石,",
"Ore->矿石, Mine->挖矿, Recipe->配方, Smelt->冶炼, Fuel->燃料,",
"Storage->仓库, Capacity->容量, Repair->修理, Destroy->摧毁, Plot Owner->基地主人,",
"Vehicle->载具, Car->汽车, Bike->摩托车, Boat->船, Plane->飞机,",
"Helicopter->直升机, Drive->驾驶, Ride->乘坐, Boost->加速, Nitro->氮气,",
"Brake->刹车, Garage->车库, Customize->自定义, Paint->涂装,",
"Pet Inventory->宠物背包, Fusion->融合, Evolve->进化, Rarity->稀有度, Common->普通,",
"Uncommon->少见, Rare->稀有, Epic->史诗, Legendary->传说, Mythical->神话,",
"Secret->秘密, Exotic->异域, Duplicate->重复, Collection->图鉴, Index->图鉴,",
"Error->错误, Failed->失败, Success->成功, Warning->警告, Available Now->现已可用,",
"Sold Out->售罄, Not Enough->数量不足, Too Far->距离太远, Cooldown Active->冷却中, Expired->已过期,",
"Code->兑换码, Redeem->兑换, Redeem Code->兑换码, Lucky->幸运, Jackpot->头奖,",
"Prize->奖品, Rare Drop->稀有掉落, Drop Rate->掉落率, Daily Login->每日登录, Reward Wheel->奖励转盘,",
"No->否, Yes->是, Store->商店, Fuse->融合, Fusing->融合中, Brainrots->脑红, Fused->已融合,",
"Play->开始游戏, Continue Playing->继续游戏, Claimed->已领取, Equipped->已装备, Unequipped->已卸下,",
"Players In Server->服务器人数, Favorites->收藏, Favorite The Game->收藏该游戏, Like The Game->喜欢该游戏,",
"Watch 1 ad->看1条广告, OFFER->优惠, BUNDLE->礼包, SKIP ALL->全部跳过, ONE TIME PURCHASE->一次性购买,",
"BEST VALUE->最划算, BEST DEAL->最优惠, BEST SELLER->最热销, LIMITED TIME->限时, LIMITED STYLES->限定外观,",
}
Trans.SlotCtx = function()
if Trans._slotCtx then return Trans._slotCtx end
Trans._slotCtx = 1024
pcall(function()
local rf = Trans.Req()
if type(rf) ~= "function" then return end
local res = rf({ Url = Trans.HOST .. "/props", Method = "GET", Headers = { ["Authorization"] = "Bearer " .. Trans.KEY } })
if type(res) ~= "table" or tonumber(res.StatusCode or 0) ~= 200 then return end
local d = HS:JSONDecode(res.Body)
local g = (type(d) == "table") and d.default_generation_settings or nil
local n = g and tonumber(g.n_ctx)
if n and n > 0 then
Trans._slotCtx = n
Trans._slotTotal = (type(d) == "table") and tonumber(d.total_slots) or nil
end
end)
return Trans._slotCtx
end
Trans.CHARS_PER_TOK = 1.5
Trans.OutNeed = function(batchN, ctx)
local n = math.max(1, tonumber(batchN) or 1)
local need = 48 + n * 44
local cap = math.floor((tonumber(ctx) or 1024) * 0.45)
if need > cap then need = cap end
if need < 96 then need = 96 end
return need
end
Trans.SysBudget = function(batchN)
local ctx = Trans.SlotCtx()
local need = Trans.OutNeed(batchN or Trans.BATCH, ctx)
local tok = ctx - need - 48
if tok < 200 then tok = 200 end
return math.floor(tok * Trans.CHARS_PER_TOK)
end
Trans.OutTokens = function(promptChars, batchN)
local ctx = Trans.SlotCtx()
local est = math.floor((tonumber(promptChars) or 0) / Trans.CHARS_PER_TOK) + 24
local out = ctx - est - 12
if out < 48 then out = 48 end
local cap = math.max(96, Trans.OutNeed(batchN or 1, ctx))
if out > cap then out = cap end
return out
end
Trans.Prompt = function(code, batchN, needText)
if code and code ~= "zh" then
local lang = Trans.LANGS[code] or "Chinese"
return "Translate the following text into " .. lang
.. ". Translate literally and faithfully; do NOT paraphrase or rewrite."
.. " Output ONLY the translation: no explanation, no quotes, no extra words."
.. " Keep numbers, emoji, URLs and player names unchanged."
end
if Trans._noGloss then
Trans._glossN = 0
return Trans.SYS_BASE
end
local budget = Trans.SysBudget(batchN)
local extra, hitN = "", 0
if type(F.GlossPromptFor) == "function" then
extra, hitN = F.GlossPromptFor(needText, 6)
end
if extra ~= "" and (#Trans.SYS_BASE + #extra) <= budget then
Trans._glossN, Trans._glossBudget = hitN, budget
return Trans.SYS_BASE .. extra
end
Trans._glossN, Trans._glossBudget = 0, budget
return Trans.SYS_BASE
end
Trans.Cache = {}
Trans.Order = {}
Trans._cnt = 0
Trans._saveCount = 0
Trans._savedAt = 0
Trans.Queue = {}
Trans.Active = 0
Trans.Loop = nil
Trans._reqN = 0
Trans._localFails = 0
Trans._dirty = false
Trans._scanRound = 0
Trans._diagOnce = nil
Trans._ready = false
Trans.Reg = setmetatable({}, { __mode = "k" })
Trans.Hooked = setmetatable({}, { __mode = "k" })
Trans.KEEP = {}
Trans.KEEPWORD = {
HUD = true, FPS = true, GUI = true, UI = true, ESP = true, DPS = true,
AFK = true, NPC = true, PvP = true, PvE = true, PVP = true, PVE = true,
FOV = true, TPS = true, RGB = true, PNG = true, JPG = true, URL = true,
API = true, SDK = true, GPU = true, CPU = true, RAM = true, FPS = true,
Ping = true, ping = true, PING = true, Lv = true, LV = true, Exp = true,
CPS = true, KPS = true, MPS = true, DPI = true, OBS = true, VR = true,
}
Trans.NOTRANSLATE = {
level = true, lvl = true, lv = true, levels = true, max = true,
mastery = true, tier = true, tiers = true,
enchanted = true, mutation = true, mutations = true,
molten = true, frozen = true, electrified = true, wet = true,
phantom = true, divine = true, heavenly = true, godly = true,
mythic = true, legendary = true, epic = true, rare = true, common = true,
rarity = true, undead = true, demon = true, shadow = true, astral = true,
eternal = true, infinity = true, plasma = true, radioactive = true,
void = true, cosmic = true, celestial = true,
abyssal = true, alien = true, golden = true, diamond = true, rainbow = true,
virus = true, legend = true,
ballberto = true, bangello = true, burguro = true, cordraculo = true,
croakumber = true, dumbelloni = true, fryuro = true, garamararam = true,
kerbaros = true, moggatron = true, orcalero = true, rockokoko = true,
stadoini = true, tralaledon = true, triregnus = true,
hacked = true, hack = true, hacker = true, hackers = true,
glitched = true, corrupted = true, infected = true,
og = true,
luck = true, power = true, speed = true, weight = true, multiplier = true,
boost = true, buff = true, debuff = true, duration = true, cooldown = true,
crit = true, critical = true, odds = true, chance = true, damage = true,
regen = true, regeneration = true, stamina = true, agility = true,
strength = true, defense = true, defence = true, accuracy = true,
capacity = true, slot = true, slots = true, income = true, earnings = true,
}
Trans.OFFICIAL = {
robloxgui = true, corescripts = true, playerlist = true, chat = true, chatwindow = true,
experiencechat = true, appchat = true, topbarapp = true, robloxpromptgui = true,
foundationoverlay = true, screenshotscarousel = true, capturemanager = true,
captureoverlay = true, momentscreationflow = true, robloxnetworkpausenotification = true,
toastnotification = true, teleporteffectgui = true, adguiinteractivitycontrols = true,
immersivebrandedads = true, rewardedvideoadplayer = true, gameinvite = true,
bulkpurchaseapp = true, inexperiencetransferapp = true, cancelsubscriptionapp = true,
commercepurchaseapp = true, systemscrim = true, universalsharesheetscreenguiroot = true,
inexperiencedetailspromptapp = true, inexperienceinterventionapp = true,
purchasepromptapp = true, publishassetprompt = true, avatareditorpromptsapp = true,
socialcontexttoast = true, ingamefullscreentitlebarscreen = true,
headsetdisconnecteddialog = true, shortcutbar = true, emotesmenu = true,
authmenu = true, permissions = true, notificationbanner = true,
foundationcursorcontainer = true, onrootedlistener = true, stylesheet = true,
}
Trans._sCache = {}
Trans._sN = 0
Trans.Req = function()
return (type(syn) == "table" and syn.request) or AC.cap("request")
or (type(http) == "table" and http.request) or AC.cap("http_request")
end
Trans.Utf8Clean = function(s)
if type(s) ~= "string" then return s end
local out, i, n = {}, 1, #s
while i <= n do
local b = s:byte(i)
if b < 0x80 then
if b == 9 or b == 10 or b >= 32 then out[#out + 1] = string.char(b) end
i = i + 1
elseif b >= 0xC2 and b <= 0xDF then
local b2 = s:byte(i + 1)
if b2 and b2 >= 0x80 and b2 <= 0xBF then out[#out + 1] = s:sub(i, i + 1) i = i + 2 else i = i + 1 end
elseif b >= 0xE0 and b <= 0xEF then
local b2, b3 = s:byte(i + 1), s:byte(i + 2)
if b2 and b3 and b2 >= 0x80 and b2 <= 0xBF and b3 >= 0x80 and b3 <= 0xBF then
out[#out + 1] = s:sub(i, i + 2) i = i + 3
else i = i + 1 end
elseif b >= 0xF0 and b <= 0xF4 then
local b2, b3, b4 = s:byte(i + 1), s:byte(i + 2), s:byte(i + 3)
if b2 and b3 and b4 and b2 >= 0x80 and b2 <= 0xBF and b3 >= 0x80 and b3 <= 0xBF and b4 >= 0x80 and b4 <= 0xBF then
out[#out + 1] = s:sub(i, i + 3) i = i + 4
else i = i + 1 end
else
i = i + 1
end
end
return table.concat(out)
end
Trans.Chat = function(messages, maxTokens)
local rf = Trans.Req()
if type(rf) ~= "function" then return nil, "本执行器没有 request 函数" end
local function build(msgs)
return {
model = Trans.MODEL,
messages = msgs,
temperature = 0.1, top_p = 0.6,
max_tokens = maxTokens or 256, stream = false,
}
end
local okB, body = pcall(function() return HS:JSONEncode(build(messages)) end)
if not okB then
local clean = {}
for i = 1, #messages do
clean[i] = { role = messages[i].role, content = Trans.Utf8Clean(messages[i].content) }
end
okB, body = pcall(function() return HS:JSONEncode(build(clean)) end)
if not okB then return nil, "文本含无法编码的字符" end
end
local ok, res = pcall(function()
return rf({
Url = Trans.HOST .. "/v1/chat/completions",
Method = "POST",
Headers = { ["Content-Type"] = "application/json", ["Authorization"] = "Bearer " .. Trans.KEY },
Body = body,
})
end)
if not ok then return nil, "HTTP 请求异常" end
if type(res) ~= "table" then return nil, "HTTP 无返回" end
local code = tonumber(res.StatusCode or res.Status or 0)
if code ~= 200 then
local em = nil
pcall(function()
local e = HS:JSONDecode(res.Body)
if type(e) == "table" and type(e.error) == "table" then em = e.error.message end
end)
local why = "HTTP " .. tostring(code) .. (em and (" | " .. tostring(em):sub(1, 160)) or "")
if os.clock() - (Trans._errLogAt or 0) > 5 then
Trans._errLogAt = os.clock()
F.Out("[翻译] ⚠ 服务端拒绝请求: " .. why)
end
return nil, why
end
local ok2, d = pcall(function() return HS:JSONDecode(res.Body) end)
if not ok2 or type(d) ~= "table" or not d.choices or not d.choices[1] then return nil, "返回解析失败" end
local msg = d.choices[1].message
local content = msg and msg.content
if type(content) ~= "string" or content == "" then return nil, "模型返回空" end
return content, nil
end
Trans.RequestOne = function(text, lang)
Trans._reqN = Trans._reqN + 1
local lastErr
for attempt = 1, 2 do
local c, err = Trans.Chat({
{ role = "system", content = Trans.Prompt(lang, 1, text) },
{ role = "user", content = text },
}, Trans.OutTokens(#Trans.Prompt(lang, 1, text) + #text, 1))
if c then Trans._localFails = 0 return c, nil end
lastErr = err
if attempt == 1 then task.wait(0.25) end
end
Trans._localFails = Trans._localFails + 1
if Trans._localFails <= 3 then
F.Out("[翻译] ⚠ 本地模型没响应(" .. tostring(lastErr) .. ") ⇒ 先用缓存汉化, 模型恢复后自动继续")
end
return nil, lastErr
end
Trans.RequestBatch = function(list, lang)
Trans._reqN = Trans._reqN + 1
local okP, payload = pcall(function() return HS:JSONEncode(list) end)
if not okP then
local clean = {}
for i = 1, #list do clean[i] = Trans.Utf8Clean(list[i]) end
okP, payload = pcall(function() return HS:JSONEncode(clean) end)
if not okP then return nil end
end
local function buildSys()
return Trans.Prompt(lang, #list, table.concat(list, " "))
.. "\nThe user sends a JSON array of strings. Translate every element."
.. "\nOutput ONLY a JSON array with the SAME length and SAME order. No explanation, no code fence."
end
local sys = buildSys()
local c, cerr = Trans.Chat({
{ role = "system", content = sys },
{ role = "user", content = payload },
}, Trans.OutTokens(#sys + #payload, #list))
if (not c) and type(cerr) == "string" and not Trans._noGloss
and (cerr:find("exceed", 1, true) or cerr:find("context size", 1, true)) then
Trans._noGloss = true
Trans._slotCtx = nil
sys = buildSys()
c, cerr = Trans.Chat({
{ role = "system", content = sys },
{ role = "user", content = payload },
}, Trans.OutTokens(#sys + #payload, #list))
F.Out("[翻译] 提示词超出每槽上下文 ⇒ 本会话已自动停用术语表并重试(翻译不受影响)")
end
if not c then Trans._localFails = Trans._localFails + 1 return nil end
c = c:gsub("^%s*```[%w]*%s*", ""):gsub("%s*```%s*$", "")
local a = c:find("%[", 1, true)
local b = c:match(".*()%]")
if not a or not b or b <= a then return nil end
local ok3, arr = pcall(function() return HS:JSONDecode(c:sub(a, b)) end)
if not ok3 or type(arr) ~= "table" or #arr ~= #list then return nil end
Trans._localFails = 0
return arr
end
Trans.Health = function()
local rf = Trans.Req()
if type(rf) ~= "function" then return false end
local ok, res = pcall(function() return rf({ Url = Trans.HOST .. "/health", Method = "GET" }) end)
return ok and type(res) == "table" and tonumber(res.StatusCode or 0) == 200
end
Trans.SafeName = function(s)
local x = tostring(s or "")
x = x:gsub('[\\/:*?"<>|]', "_")
x = x:gsub("%c", "")
x = x:gsub("%s+", "_")
x = x:gsub("^_+", ""):gsub("_+$", "")
if #x > 40 then x = x:sub(1, 40) end
return x
end
Trans.GameKey = function()
if Trans._gk then return Trans._gk, Trans._gp end
local pid = "0"
pcall(function() pid = tostring(game.PlaceId or 0) end)
local nm = nil
pcall(function()
local ok, n = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
if ok and type(n) == "string" and n ~= "" then nm = n end
end)
Trans._gname = nm
local key = "Place" .. pid
Trans._gk, Trans._gp = key, pid
return key, pid
end
Trans.CurFile = function()
if Trans._curFile then return Trans._curFile end
Trans._curFile = Trans.CACHE_PREFIX .. Trans.GameKey() .. ".txt"
return Trans._curFile
end
Trans.AsciiFile = function()
local _, pid = Trans.GameKey()
return Trans.CACHE_PREFIX .. "Place" .. tostring(pid) .. ".txt"
end
Trans.CacheFiles = function()
local out = {}
if type(listfiles) ~= "function" then return out end
local ok, list = pcall(listfiles, ".")
if not ok or type(list) ~= "table" then return out end
for i = 1, #list do
local p = tostring(list[i])
local nm = p:match("([^/\\]+)$") or p
if nm:sub(1, #Trans.CACHE_PREFIX) == Trans.CACHE_PREFIX and nm:sub(-4) == ".txt" then
out[#out + 1] = nm
end
end
return out
end
Trans.LoadInto = function(file)
if type(readfile) ~= "function" then return 0 end
local ex = false
if type(isfile) == "function" then pcall(function() ex = isfile(file) end) end
if not ex then return 0 end
local raw = nil
pcall(function() raw = readfile(file) end)
if type(raw) ~= "string" or raw == "" then return 0 end
local d = nil
pcall(function() d = HS:JSONDecode(raw) end)
if type(d) ~= "table" then return 0 end
local cache = (type(d.c) == "table") and d.c or d
local n = 0
for k, v in pairs(cache) do
if type(k) == "string" and type(v) == "string" and Trans.Cache[k] == nil then
Trans.Cache[k] = v
Trans.OWNER[k] = file
n = n + 1
end
end
return n
end
Trans.Count = function()
local n = 0
for _ in pairs(Trans.Cache) do n = n + 1 end
return n
end
Trans.OwnedCount = function()
local now = os.clock()
local c = Trans._ocN
if c ~= nil and Trans._ocAt and (now - Trans._ocAt) < 2 then return c end
local file = Trans.CurFile()
local n = 0
for k in pairs(Trans.Cache) do
if Trans.OWNER[k] == file then n = n + 1 end
end
Trans._ocN, Trans._ocAt = n, now
return n
end
Trans.ClearCurrent = function()
local file = Trans.CurFile()
local gone = 0
for k in pairs(Trans.Cache) do
if Trans.OWNER[k] == file then
Trans.Cache[k] = nil
Trans.OWNER[k] = nil
gone = gone + 1
end
end
Trans._cnt = Trans.Count()
Trans.Order = {}
for k in pairs(Trans.Cache) do Trans.Order[#Trans.Order + 1] = k end
Trans._lastSavedN = nil
if type(delfile) == "function" then
pcall(function() if type(isfile) == "function" and isfile(file) then delfile(file) end end)
pcall(function() if type(isfile) == "function" and isfile(Trans.AsciiFile()) then delfile(Trans.AsciiFile()) end end)
end
local still = false
if type(isfile) == "function" then pcall(function() still = isfile(file) == true end) end
if still and type(writefile) == "function" then
pcall(function() writefile(file, '{"v":3,"c":{}}') end)
end
Trans.ShouldCacheClear()
Trans._fail = {}
if type(Trans.Reg) == "table" then
for _o, r in pairs(Trans.Reg) do if type(r) == "table" then r.at = 0 end end
end
Trans._dirty = false
local owned = Trans.OwnedCount()
F.Out("[翻译] 已清空当前服缓存 " .. gone .. " 条(" .. file .. ") ⇒ 本服缓存现剩 " .. owned
.. " 条 · 另有 " .. tostring(Trans.Count() - owned) .. " 条是内建术语表/官方译法(不占本服文件) ⇒ 本服文字会重新翻一遍")
return gone
end
Trans.ClearAll = function()
local n = Trans.Count()
Trans.Cache, Trans.OWNER, Trans.Order = {}, {}, {}
Trans._cnt = 0
Trans._lastSavedN = nil
Trans._dirty = false
Trans._fail = {}
Trans.NumTpl = {}
Trans.ShouldCacheClear()
local del, wipe, left = 0, 0, 0
local list = Trans.CacheFiles()
list[#list + 1] = Trans.FILE
list[#list + 1] = "CheatMenu_TransCache.json"
list[#list + 1] = "CheatMenu_TransCache.json.bak"
list[#list + 1] = "CheatMenu_NumTpl.txt"
list[#list + 1] = Trans.AsciiFile()
for i = 1, #list do
local f = list[i]
if type(f) == "string" and f ~= "" then
if type(delfile) == "function" then pcall(delfile, f) end
local ex = false
if type(isfile) == "function" then pcall(function() ex = isfile(f) == true end) end
if ex then
if type(writefile) == "function" then
if pcall(writefile, f, '{"v":3,"c":{}}') then wipe = wipe + 1 del = del + 1 else left = left + 1 end
else
left = left + 1
end
else
del = del + 1
end
end
end
if type(Trans.Reg) == "table" then
for _o, r in pairs(Trans.Reg) do if type(r) == "table" then r.at = 0 end end
end
F.Out("[翻译] 已清空全部缓存 " .. n .. " 条 · 已清文件 " .. del .. " 个(其中 " .. wipe .. " 个改为空文件" .. (left > 0 and (" · " .. left .. " 个没删掉") or "") .. ")")
return n
end
Trans.RestoreStale = function()
local back = {}
for k, v in pairs(Trans.Cache) do
if type(k) == "string" and type(v) == "string" and #v > 0 and #k <= 24
and not k:find("%s") and not Trans.Should(k) and not Trans.OFFICIAL_SRC[k] then
back[v] = k
end
end
if next(back) == nil then return 0 end
local LPl = game:GetService("Players").LocalPlayer
local roots = {}
pcall(function() if LPl then roots[#roots + 1] = LPl:FindFirstChild("PlayerGui") end end)
pcall(function() if gethui then roots[#roots + 1] = gethui() end end)
local n = 0
for i = 1, #roots do
if roots[i] then
local ok, ds = pcall(function() return roots[i]:GetDescendants() end)
if ok and type(ds) == "table" then
for j = 1, #ds do
local o = ds[j]
if typeof(o) == "Instance" then
local c = o.ClassName
if c == "TextLabel" or c == "TextButton" or c == "TextBox" then
local t = nil
pcall(function() t = o.Text end)
local src = (type(t) == "string") and back[t] or nil
if src then
if pcall(function() o.Text = src end) then n = n + 1 end
end
end
end
end
end
end
end
if n > 0 then
F.Out("[翻译] 已把 " .. tostring(n) .. " 处按当前规则不该翻的文字还原成原文(如 经典版→OG 这类)")
end
return n
end
Trans.PurgeTpl = function()
local tdrop = 0
for t in pairs(Trans.NumTpl) do
if type(t) == "string" then
local probe = t:gsub("\1", "0")
if not Trans.Should(probe) then
Trans.NumTpl[t] = nil
tdrop = tdrop + 1
end
end
end
if tdrop > 0 then
Trans._numTplDirty = true
F.Out("[翻译] 数字模板自检: 已淘汰 " .. tostring(tdrop) .. " 条不该翻的旧模板(属性/词缀/OG 这类)")
end
return tdrop
end
Trans.PurgeStale = function()
local drop = 0
for k in pairs(Trans.Cache) do
if type(k) == "string" and not Trans.Should(k) then
Trans.Cache[k] = nil
drop = drop + 1
end
end
if drop > 0 then
Trans._dirty = true
Trans.ShouldCacheClear()
F.Out("[翻译] 缓存自检: 已淘汰 " .. tostring(drop) .. " 条按当前规则不该翻的旧条目(不用手动清空缓存)")
end
return drop
end
function Trans.Load()
local total, files = 0, 0
local list = Trans.CacheFiles()
for i = 1, #list do
local n = Trans.LoadInto(list[i])
if n > 0 then total = total + n files = files + 1 end
end
local n1 = Trans.LoadInto(Trans.FILE)
if n1 > 0 then total = total + n1 files = files + 1 end
local n2 = Trans.LoadInto("CheatMenu_TransCache.json")
if n2 > 0 then total = total + n2 files = files + 1 end
pcall(Trans.RestoreStale)
pcall(Trans.PurgeStale)
Trans._cnt = Trans.Count()
Trans._dirty = false
if total > 0 then
F.Out("[翻译] 已加载本地缓存 " .. total .. " 条(来自 " .. files .. " 个文件) ⇒ 这些句子不再重翻")
else
F.Out("[翻译] 本地暂无缓存文件 ⇒ 翻过的句子会边玩边积累")
end
return total
end
Trans.SaveAtomic = function(payload, file)
if type(writefile) ~= "function" then return false end
if type(payload) ~= "string" or payload == "" then return false end
local f = file or Trans.CurFile()
local ok, err = pcall(function() writefile(f, payload) end)
if ok then return true, f end
local alt = Trans.AsciiFile()
if f ~= alt then
local ok2, err2 = pcall(function() writefile(alt, payload) end)
if ok2 then return true, alt end
Trans._lastErr = tostring(err2)
end
Trans._lastErr = tostring(err)
return false
end
Trans.Flush = function()
if type(writefile) ~= "function" then
Trans._dirty = false
Trans._lastErr = "本执行器不支持写文件"
return false
end
local file = Trans.CurFile()
local pack, n = {}, 0
for k, v in pairs(Trans.Cache) do
if Trans.OWNER[k] == file then pack[k] = v n = n + 1 end
end
if n == 0 then
local ex = false
if type(isfile) == "function" then pcall(function() ex = isfile(file) end) end
if not ex then
Trans._dirty = false
return true
end
end
local gk, pid = Trans.GameKey()
local body = nil
local okE = pcall(function() body = HS:JSONEncode({ v = 3, game = gk, place = pid, c = pack }) end)
if not okE or not body then
Trans._lastErr = "缓存序列化失败"
return false
end
local ok, r = pcall(Trans.SaveAtomic, body, file)
local done = ok and (r == true)
Trans._dirty = not done
if done then
Trans._savedAt = os.clock()
Trans._saveCount = (Trans._saveCount or 0) + 1
Trans._lastErr = nil
if Trans._lastSavedN ~= n then
Trans._lastSavedN = n
F.Out("[翻译] 缓存已保存到 " .. file .. " (" .. n .. " 条本服缓存)")
end
else
Trans._lastErr = tostring(r)
end
return done
end
Trans.Save = function() Trans._dirty = true end
Trans.NumTplSave = function()
if type(writefile) ~= "function" then return end
local ok, r = pcall(function()
local pack = {}
for k, v in pairs(Trans.NumTpl) do pack[k] = v end
return writefile("CheatMenu_NumTpl.txt", HS:JSONEncode(pack))
end)
if not ok then Trans._numTplSaveErr = tostring(r) end
end
Trans.NumTplLoad = function()
if type(readfile) ~= "function" then return end
local raw = nil
pcall(function() if type(isfile) ~= "function" or isfile("CheatMenu_NumTpl.txt") then raw = readfile("CheatMenu_NumTpl.txt") end end)
if type(raw) ~= "string" or raw == "" then return end
local d = nil
pcall(function() d = HS:JSONDecode(raw) end)
if type(d) ~= "table" then return end
local n = 0
for k, v in pairs(d) do
if type(k) == "string" and type(v) == "string" and Trans.NumTpl[k] == nil then
Trans.NumTpl[k] = v
n = n + 1
end
end
if n > 0 then F.Out("[翻译] 数字模板已从磁盘补载 " .. tostring(n) .. " 条") end
end
Trans.SaveTick = function()
while true do
task.wait(30)
if Trans._dirty and T.Translate then pcall(Trans.Flush) end
if Trans._numTplDirty then
Trans._numTplDirty = false
pcall(Trans.NumTplSave)
end
if Trans._fail then
for k, t in pairs(Trans._fail) do
if os.clock() > t then Trans._fail[k] = nil end
end
end
end
end
Trans.PN = {}
Trans.RefreshPN = function()
local t, n = {}, 0
pcall(function()
local list = game:GetService("Players"):GetPlayers()
n = #list
for i = 1, n do
local pl = list[i]
local nm = pl.Name
if type(nm) == "string" and #nm >= 3 then t[nm] = true t[string.lower(nm)] = true end
local dn = pl.DisplayName
if type(dn) == "string" and #dn >= 3 then t[dn] = true t[string.lower(dn)] = true end
end
end)
if Trans._pnN ~= n then
Trans._pnN = n
Trans.ShouldCacheClear()
end
Trans.PN = t
end
Trans.ShouldCacheClear = function()
Trans._sCache = {}
Trans._sN = 0
end
Trans.Should = function(s)
if type(s) ~= "string" then return false end
local hit = Trans._sCache[s]
if hit ~= nil then return hit end
local ok = Trans.ShouldV2(s:gsub("^%s+", ""):gsub("%s+$", "")) and true or false
if Trans._sN < 4000 then
Trans._sCache[s] = ok
Trans._sN = Trans._sN + 1
else
Trans._sCache = { [s] = ok }
Trans._sN = 1
end
return ok
end
Trans.ShouldV2 = function(s)
local n = #s
if n < 2 or n > 300 then return false end
if Trans.PN and Trans.PN[s] then return false end
if s:find("<%a") or s:find("</%a") then
local st = s:gsub("<[^<>]->", " ")
if not st:match("%a%a") then return false end
s = st
end
if s:find("[\228-\233]") and not s:match("%a%a") then return false end
if not s:match("%a%a") then return false end
if Trans.KEEPWORD and s:find("%u") then
local st = s:gsub("%f[%a][A-Za-z][A-Za-z0-9]*%f[%A]", function(w)
if Trans.KEEPWORD[w] then return " " end
return w
end)
if not st:match("%a%a") then return false end
end
local nt = s:gsub("%a+", function(w)
if Trans.NOTRANSLATE[string.lower(w)] then return " " end
return w
end)
if not nt:match("%a%a") then return false end
if s:match("^%s*[%d][%d%.,%s]*%a%a?%a?%.?%s*$") then return false end
if s:match("^%s*%a%a?%a?%.?%s*[%d][%d%.,%s]*$") then return false end
if s:match("^%a[%a0-9]*%-[%a0-9%-]*$") and not s:find("%u") then return false end
if s:match("%d%s*:%s*%d") then return false end
if s:match("^https?://") or s:find("rbxasset", 1, true) or s:find("rbxthumb", 1, true) then return false end
if s:find("www%.%w+") or s:match("%.com") or s:match("%.net") or s:match("%.org") then return false end
if s:find(":", 1, true) and s:find("//", 1, true) then return false end
if s:match("^[%d%p%s]+$") then return false end
if not s:find("%s") then
local core = s:gsub("^[%p%s]+", ""):gsub("[%p%s]+$", "")
if core == "" then return false end
if core:find("_") then return false end
if core:match("^[%d%.]+$") then return false end
if core:match("^v%d") then return false end
end
return true
end
Trans.KeepAdd = function(w)
if type(w) == "string" and #w >= 3 then Trans.KEEP[w] = true end
end
Trans.Pre = function(text)
local ctx = { raw = text, tags = nil }
local s = text
local parts = {}
if s:find("<%a[^<>]->") or s:find("</%a") then
s = s:gsub("<[^<>]->", function(t)
parts[#parts + 1] = t
return "\226\159\166" .. tostring(#parts) .. "\226\159\167"
end)
end
if s:find("%u") then
s = s:gsub("%f[%a]([A-Za-z][A-Za-z0-9]*)%f[%A]", function(w)
if Trans.KEEPWORD and Trans.KEEPWORD[w] then
parts[#parts + 1] = w
return "\226\159\166" .. tostring(#parts) .. "\226\159\167"
end
return w
end)
end
if s:find("[\228-\233]") and #parts <= 6 then
local out, i, n = {}, 1, #s
while i <= n do
local b = s:byte(i)
if b and b >= 228 and b <= 233 then
local from = i
while i <= n do
local b2 = s:byte(i)
if b2 and b2 >= 228 and b2 <= 233 then i = i + 3 else break end
end
parts[#parts + 1] = s:sub(from, i - 1)
out[#out + 1] = "\226\159\166" .. tostring(#parts) .. "\226\159\167"
else
out[#out + 1] = s:sub(i, i)
i = i + 1
end
end
s = table.concat(out)
end
if Trans.PN and next(Trans.PN) then
s = s:gsub("%f[%a_][%a_][%w_]*", function(w)
if Trans.PN[w] or Trans.PN[string.lower(w)] then
parts[#parts + 1] = w
return "\226\159\166" .. tostring(#parts) .. "\226\159\167"
end
return w
end)
end
s = s:gsub("%f[%d]%d+%.?%d*%a%a?%a?%f[%A]", function(t)
parts[#parts + 1] = t
return "\226\159\166" .. tostring(#parts) .. "\226\159\167"
end)
if #parts > 0 then ctx.tags = parts end
ctx.send = s
if not s:match("%a%a") then ctx.noText = true end
return ctx
end
Trans.Post = function(tr, ctx)
if type(tr) ~= "string" then return nil end
local out = tr
if out:find("\226\159\166") then
out = out:gsub("\226\159\166%s*(%d+)%s*\226\159\167", function(i)
local t = ctx.tags and ctx.tags[tonumber(i)]
return t or ""
end)
if ctx.tags then
for i = 1, #ctx.tags do
if not out:find(ctx.tags[i], 1, true) then return nil end
end
end
end
out = out:gsub("^%s+", ""):gsub("%s+$", "")
if out == "" then return nil end
return out
end
Trans.CachePut = function(text, tr)
local fresh = Trans.Cache[text] == nil
Trans.Cache[text] = tr
Trans.OWNER[text] = Trans.CurFile()
if fresh then
Trans._cnt = Trans._cnt + 1
Trans.Order[#Trans.Order + 1] = text
if Trans._cnt > Trans.CACHE_MAX then
local drop = math.floor(Trans.CACHE_MAX * 0.5)
local gone = 0
for i = 1, #Trans.Order do
local k = Trans.Order[i]
if k and Trans.Cache[k] ~= nil and Trans.OWNER[k] == Trans.CurFile() then
Trans.Cache[k] = nil
Trans.OWNER[k] = nil
gone = gone + 1
if gone >= drop then break end
end
end
local keep, seen = {}, {}
for i = 1, #Trans.Order do
local k = Trans.Order[i]
if k and Trans.Cache[k] ~= nil and not seen[k] then
seen[k] = true
keep[#keep + 1] = k
end
end
Trans.Order = keep
Trans._cnt = #keep
end
end
local tplS, vals, kinds = Trans.TplBuild(text)
if Trans.TplOK(vals, kinds, tplS) then
local tplTr2, valsTr2, kindsTr2 = Trans.TplBuild(tr)
if Trans.TplSame(vals, kinds, valsTr2, kindsTr2) then
if Trans.NumTpl[tplS] ~= tplTr2 then
Trans.NumTpl[tplS] = tplTr2
Trans._numTplDirty = true
end
end
end
Trans.Save()
end
Trans.TplBuild = function(s)
local vals, kinds = {}, {}
local pnOn = Trans.PN and next(Trans.PN) ~= nil
local out, i, n = {}, 1, #s
while i <= n do
local c = s:sub(i, i)
if c:match("%d") then
local j = i
while j <= n do
local cj = s:sub(j, j)
if cj:match("%d") then
j = j + 1
elseif (cj == "." or cj == ",") and s:sub(j + 1, j + 1):match("%d") then
j = j + 1
else
break
end
end
vals[#vals + 1] = s:sub(i, j - 1)
kinds[#kinds + 1] = "n"
out[#out + 1] = "\1"
i = j
elseif pnOn and (c:match("%a") or c:match("_")) then
local j = i + 1
while j <= n and s:sub(j, j):match("%w") do j = j + 1 end
local w = s:sub(i, j - 1)
if Trans.PN[w] or Trans.PN[string.lower(w)] then
vals[#vals + 1] = w
kinds[#kinds + 1] = "p"
out[#out + 1] = "\1"
else
out[#out + 1] = w
end
i = j
else
out[#out + 1] = c
i = i + 1
end
end
return table.concat(out), vals, kinds
end
Trans.TplOK = function(vals, kinds, tpl)
if type(tpl) ~= "string" or #tpl < 8 then return false end
if type(vals) ~= "table" or type(kinds) ~= "table" then return false end
local n = #vals
if n < 1 or n > 3 then return false end
for i = 1, n do
if kinds[i] ~= "n" then return false end
end
return true
end
Trans.TplSame = function(v1, k1, v2, k2)
if type(v1) ~= "table" or type(v2) ~= "table" then return false end
if #v1 ~= #v2 or #v1 < 1 then return false end
for i = 1, #v1 do
if k1[i] ~= "n" or k2[i] ~= "n" then return false end
if tostring(v1[i]) ~= tostring(v2[i]) then return false end
end
return true
end
Trans.TplFill = function(trTpl, vals)
local out = trTpl
for i = 1, #vals do
out = out:gsub("\1", (tostring(vals[i]):gsub("%%", "%%%%")), 1)
end
return out
end
Trans.TplFromCache = function()
local n = 0
for k, v in pairs(Trans.Cache) do
if type(k) == "string" and type(v) == "string" then
local tplS, vals, kinds = Trans.TplBuild(k)
if Trans.TplOK(vals, kinds, tplS) then
local tplTr, v2, k2 = Trans.TplBuild(v)
if Trans.TplSame(vals, kinds, v2, k2) then
if Trans.NumTpl[tplS] ~= tplTr then
Trans.NumTpl[tplS] = tplTr
n = n + 1
end
end
end
end
end
if n > 0 then Trans._numTplDirty = true end
return n
end
Trans.Translate = function(text, force, lang)
if type(text) ~= "string" then return nil end
text = text:gsub("^%s+", ""):gsub("%s+$", "")
if text == "" then return nil end
if Trans.KEEP[text] then return nil end
if not lang then return Trans.Lookup(text) end
local ctx = Trans.Pre(text)
if ctx.noText then return nil end
local c = Trans.RequestOne(ctx.send, lang)
if not c then return nil end
local out = Trans.Post(c, ctx)
if out and out ~= text then return out end
return nil
end
Trans.Drain = function()
local cap = Trans.MAX
while Trans.Active < cap and #Trans.Queue > 0 do
if Trans._urgent then
if os.clock() - (Trans._urgentAt or 0) > 10 then
Trans._urgent = false
else
break
end
end
local groups, order, rest = {}, {}, {}
for i = 1, #Trans.Queue do
local it = Trans.Queue[i]
local g = groups[it.text]
if g then
local al = it.applies or {}
for a = 1, #al do g.applies[#g.applies + 1] = al[a] end
elseif #order < Trans.BATCH then
g = { text = it.text, applies = it.applies or {} }
groups[it.text] = g
order[#order + 1] = it.text
else
rest[#rest + 1] = it
end
end
Trans.Queue = rest
if #order == 0 then break end
local items = {}
for i = 1, #order do items[i] = groups[order[i]] end
Trans.Active = Trans.Active + 1
task.spawn(function()
local okAll, errAll = pcall(function()
local ok = false
if #items > 1 then
local ctxs, sends = {}, {}
for i = 1, #items do
local c = Trans.Pre(items[i].text)
ctxs[i] = c
sends[i] = c.send
end
local arr = Trans.RequestBatch(sends, "zh")
if arr then
ok = true
Trans._batchOk = (Trans._batchOk or 0) + 1
for i = 1, #items do
local it = items[i]
local tr = Trans.Post(arr[i], ctxs[i])
if tr and tr ~= it.text then
Trans.CachePut(it.text, tr)
for j = 1, #it.applies do pcall(it.applies[j], tr) end
end
end
else
Trans._batchFail = (Trans._batchFail or 0) + 1
end
end
if not ok then
for i = 1, #items do
local it = items[i]
local tr = Trans.Translate(it.text, true, "zh")
if tr then
Trans.CachePut(it.text, tr)
for j = 1, #it.applies do pcall(it.applies[j], tr) end
else
Trans.MarkFail(it.text)
end
end
end
end)
if not okAll then
Trans._drainErr = (Trans._drainErr or 0) + 1
if Trans._drainErr <= 3 then
F.Out("[翻译] ⚠ 翻译任务出错(已自动恢复): " .. tostring(errAll))
end
end
Trans._lastDone = os.clock()
for i = 1, #items do Trans._qEntry[items[i].text] = nil end
Trans.Active = Trans.Active - 1
if Trans.Active < 0 then Trans.Active = 0 end
if Trans.Active < Trans.MAX and #Trans.Queue > 0 then Trans.Drain() end
end)
end
end
Trans.MarkFail = function(text)
if type(text) ~= "string" then return end
Trans._fail = Trans._fail or {}
Trans._fail[text] = os.clock() + 25
end
Trans.Lookup = function(text)
local hit = Trans.Cache[text]
if type(hit) == "string" then return hit end
local low = text:lower()
if low ~= text then
local h2 = Trans.Cache[low]
if type(h2) == "string" then return h2 end
end
local up = text:upper()
if up ~= text and up ~= low then
local h3 = Trans.Cache[up]
if type(h3) == "string" then return h3 end
end
local trim = text:gsub("^[%s%p]+", ""):gsub("[%s%p]+$", "")
if trim ~= text and #trim >= 2 then
local h4 = Trans.Cache[trim]
if type(h4) == "string" then return h4 end
local h5 = Trans.Cache[trim:lower()]
if type(h5) == "string" then return h5 end
end
return Trans.NumTplHit(text)
end
Trans.NumTplHit = function(text)
if not text or #text > 200 then return nil end
if not text:find("%d", 1) then return nil end
local tpl, vals, kinds = Trans.TplBuild(text)
if not Trans.TplOK(vals, kinds, tpl) then return nil end
local trTpl = Trans.NumTpl[tpl]
if type(trTpl) ~= "string" or trTpl == "" then return nil end
local filled = Trans.TplFill(trTpl, vals)
if filled == "" or filled == text then return nil end
return filled
end
Trans.NumTpl = {}
Trans._qEntry = {}
Trans.Async = function(text, applyFn, urgent)
if not T.Translate then return end
if type(text) ~= "string" or text == "" then return end
if Trans.KEEP[text] then return end
if not Trans.Should(text) then return end
if Trans.Pre(text).noText then return end
local hit = Trans.Lookup(text)
if hit then
pcall(applyFn, hit)
return
end
if not Trans._ready then return end
if Trans.IsMobile then return end
local ft = Trans._fail and Trans._fail[text]
if ft and os.clock() < ft then return end
if #Trans.Queue > 2000 then return end
local entry = Trans._qEntry[text]
if entry then
local al = entry.applies or {}
al[#al + 1] = applyFn
entry.applies = al
else
entry = { text = text, applies = { applyFn } }
Trans._qEntry[text] = entry
if urgent then table.insert(Trans.Queue, 1, entry)
else Trans.Queue[#Trans.Queue + 1] = entry end
end
Trans.Drain()
end
function F.IsOfficialUI(obj)
local p = obj
for _ = 1, 20 do
p = p and p.Parent
if not p then return false end
local nm = p.Name
if type(nm) == "string" then
local ln = string.lower(nm)
if ln:find("chat") then return true end
if Trans.OFFICIAL[ln] then return true end
end
end
return false
end
function F.IsOurGui(obj)
local p = obj
for _ = 1, 14 do
p = p and p.Parent
if not p then return false end
local ok, v = pcall(function() return p:GetAttribute("CMOwned") end)
if ok and v == true then return true end
end
return false
end
Trans.InIndexPanel = function(obj)
local p = obj
for _ = 1, 20 do
p = p and p.Parent
if not p then return false end
local nm = p.Name
if type(nm) == "string" then
local ln = string.lower(nm)
if ln:find("index", 1, true) or ln:find("collection", 1, true)
or ln:find("codex", 1, true) or nm:find("图鉴", 1, true) then
return true
end
end
end
return false
end
Trans.TextVisible = function(obj)
local ok, v = pcall(function() return obj.TextVisible end)
if ok then return v end
return nil
end
Trans.WriteText = function(obj, prop, val, expect)
if expect ~= nil then
local cur = nil
pcall(function() cur = obj[prop] end)
if cur ~= expect then return end
end
pcall(function() Trans._lastWrote[obj] = val end)
pcall(function() obj[prop] = val end)
end
Trans._selfCN = setmetatable({}, { __mode = "k" })
Trans._lastWrote = setmetatable({}, { __mode = "k" })
Trans._selfCNPath = {}
Trans._pathCache = setmetatable({}, { __mode = "k" })
Trans._vHookN = 0
Trans._vHook = setmetatable({}, { __mode = "k" })
Trans.HookVisible = function(obj)
if Trans._vHook[obj] then return end
if Trans._vHookN >= 600 then return end
Trans._vHook[obj] = true
Trans._vHookN = Trans._vHookN + 1
pcall(function()
obj:GetPropertyChangedSignal("Visible"):Connect(function()
if T.Translate and obj.Visible ~= false then pcall(Trans.GuiEl, obj, true) end
end)
end)
end
Trans.PathOf = function(o)
local c = Trans._pathCache[o]
if c ~= nil then return c end
local p = ""
pcall(function() p = tostring(o:GetFullName()) end)
if #p > 160 then p = p:sub(-160) end
Trans._pathCache[o] = p
return p
end
Trans._locTr = nil
Trans._locTried = false
Trans._locMap = {}
Trans._locN = 0
Trans.LocInit = function()
if Trans._locTried then return end
Trans._locTried = true
pcall(function()
local LPl = game:GetService("Players").LocalPlayer
if not LPl then return end
local LS = game:GetService("LocalizationService")
local ok, tr = pcall(function() return LS:GetTranslatorForPlayerAsync(LPl) end)
if ok and tr then Trans._locTr = tr end
end)
pcall(Trans.PrefetchOfficial)
end
Trans.StripTags = function(s)
if type(s) ~= "string" then return "" end
return (s:gsub("<[^<>]->", ""))
end
Trans.OfficialCN = function(obj)
local src = nil
pcall(function() src = obj.Text end)
if type(src) ~= "string" or #src == 0 then return nil end
if not Trans.Should(src) then return nil end
local plain = Trans.StripTags(src)
local ours = (Trans._lastWrote[obj] == src)
local ct = nil
if pcall(function() ct = obj.ContentText end) and type(ct) == "string" and #ct > 0 then
if (not ours) and ct ~= src and ct ~= plain and ct:find("[\228-\233]") then return ct end
end
if not Trans._locTr then return nil end
local hit = Trans._locMap[src]
if hit == nil then
local res = nil
local ok, a, b = pcall(function() return Trans._locTr:Translate(obj, src) end)
if ok and type(a) == "string" and a ~= src and a ~= plain and b ~= false and a:find("[\228-\233]") then
res = a
elseif plain ~= src and #plain > 0 then
local ok2, a2, b2 = pcall(function() return Trans._locTr:Translate(obj, plain) end)
if ok2 and type(a2) == "string" and a2 ~= plain and b2 ~= false and a2:find("[\228-\233]") then res = a2 end
end
hit = res or false
if Trans._locN < 6000 then
Trans._locMap[src] = hit
Trans._locN = Trans._locN + 1
else
Trans._locMap = { [src] = hit }
Trans._locN = 1
end
end
if hit then return hit end
return nil
end
Trans.RevertOfficial = function(obj)
local rr = Trans.Reg[obj]
if type(rr) ~= "table" then return end
if type(rr.Text) == "string" then
local cur = nil
pcall(function() cur = obj.Text end)
if cur ~= rr.Text then pcall(function() obj.Text = rr.Text end) end
end
if type(rr.PlaceholderText) == "string" then
local curP = nil
pcall(function() curP = obj.PlaceholderText end)
if curP ~= rr.PlaceholderText then pcall(function() obj.PlaceholderText = rr.PlaceholderText end) end
end
end
Trans.SkipOfficial = function(obj, official)
Trans._offCN = (Trans._offCN or 0) + 1
if not Trans._offCNLogged and Trans._offCN >= 5 then
Trans._offCNLogged = true
F.Out("[翻译] 已识别游戏自带官方中文(" .. tostring(Trans._offCN) .. " 条) ⇒ 一律沿用官方译法并写入缓存, 不再送模型")
end
local src = nil
pcall(function() src = obj.Text end)
if type(src) == "string" and #src > 0 and type(official) == "string" and #official > 0 then
Trans.OFFICIAL_SRC[src] = true
if Trans.Cache[src] ~= official then
Trans.CachePut(src, official)
Trans._dirty = true
end
end
Trans._selfCN[obj] = true
local p = Trans.PathOf(obj)
if p ~= "" then Trans._selfCNPath[p] = true end
Trans.RevertOfficial(obj)
end
Trans._prefetched = false
Trans.OFFICIAL_SRC = {}
Trans.PrefetchOfficial = function()
if Trans._prefetched then return end
Trans._prefetched = true
local LPl = game:GetService("Players").LocalPlayer
local roots = {}
pcall(function() if LPl then roots[#roots + 1] = LPl:FindFirstChild("PlayerGui") end end)
pcall(function() if gethui then roots[#roots + 1] = gethui() end end)
local n = 0
for i = 1, #roots do
if roots[i] then
local ok, ds = pcall(function() return roots[i]:GetDescendants() end)
if ok and type(ds) == "table" then
for j = 1, #ds do
local o = ds[j]
if typeof(o) == "Instance" then
local c = o.ClassName
if c == "TextLabel" or c == "TextButton" or c == "TextBox" then
local off = Trans.OfficialCN(o)
if off then
Trans.SkipOfficial(o, off)
n = n + 1
end
end
end
end
end
end
end
if n > 0 then
Trans._dirty = true
F.Out("[翻译] 官方译文预读完成: 已收录 " .. tostring(n) .. " 条游戏自带中文 ⇒ 以后遇到同类文字直接用官方译法, 不会二次翻译")
end
end
Trans.MarkSelfCN = function(obj, txt)
if type(txt) ~= "string" then return end
if not txt:find("[\228-\233]") or txt:find("%a%a") then return end
if Trans._lastWrote[obj] == txt then return end
Trans._selfCN[obj] = true
local p = Trans.PathOf(obj)
if p ~= "" then Trans._selfCNPath[p] = true end
end
Trans.GuiEl = function(obj, urgent)
if not obj or not obj.Parent then return end
local cls = obj.ClassName
if cls ~= "TextLabel" and cls ~= "TextButton" and cls ~= "TextBox" then return end
do
local par = obj.Parent
if typeof(par) == "Instance" then
local pc = par.ClassName
if pc == "TextLabel" or pc == "TextButton" or pc == "TextBox" then return end
end
end
if obj.Visible == false then return end
if Trans.TextVisible(obj) == false then return end
local tt = obj.TextTransparency
if type(tt) == "number" and tt >= 0.95 then return end
if F.IsOurGui(obj) then return end
if F.IsOfficialUI(obj) then return end
if Trans.InIndexPanel(obj) then
Trans._indexSkip = (Trans._indexSkip or 0) + 1
if not Trans._indexLogged and Trans._indexSkip >= 5 then
Trans._indexLogged = true
F.Out("[翻译] 已识别图鉴/索引类面板 ⇒ 里面的内容全部不翻(已跳过 " .. tostring(Trans._indexSkip) .. " 条)")
end
return
end
local offCN = Trans.OfficialCN(obj)
if offCN then
Trans.SkipOfficial(obj, offCN)
return
end
if Trans._selfCNPath[Trans.PathOf(obj)] then
Trans._selfCN[obj] = true
return
end
if cls == "TextBox" then
if Trans._selfCN[obj] then return end
local editable = true
pcall(function() editable = obj.TextEditable end)
local ph = nil
pcall(function() ph = obj.PlaceholderText end)
if type(ph) == "string" and Trans.Should(ph) then
Trans.RegField(obj, "PlaceholderText", ph)
Trans.Async(ph, function(tr) if obj.Parent then Trans.WriteText(obj, "PlaceholderText", tr, ph) end end, urgent)
end
if editable == false then
local body = nil
pcall(function() body = obj.Text end)
if type(body) == "string" and Trans.Should(body) then
Trans.RegField(obj, "Text", body)
Trans.Async(body, function(tr) if obj.Parent then Trans.WriteText(obj, "Text", tr, body) end end, urgent)
end
end
return
end
local txt = nil
pcall(function() txt = obj.Text end)
if type(txt) ~= "string" or txt == "" then return end
if txt:find("[\228-\233]") and not txt:find("%a%a") then
Trans.MarkSelfCN(obj, txt)
return
end
if Trans._selfCN[obj] then return end
if not Trans.Should(txt) then return end
if not Trans.Hooked[obj] then
Trans.Hooked[obj] = true
pcall(function()
obj:GetPropertyChangedSignal("Text"):Connect(function()
if not T.Translate then return end
local now = nil
pcall(function() now = obj.Text end)
if type(now) ~= "string" or now == "" then return end
Trans.MarkSelfCN(obj, now)
if now:find("[\228-\233]") and not now:find("%a%a") then
return
end
if Trans._selfCN[obj] then return end
local offCN = Trans.OfficialCN(obj)
if offCN then
Trans.SkipOfficial(obj, offCN)
return
end
local cv = Trans.Lookup(now)
if Trans.Should(now) and cv then
Trans.WriteText(obj, "Text", cv, now)
return
end
pcall(Trans.GuiEl, obj, true)
end)
end)
end
Trans.RegField(obj, "Text", txt)
Trans.Async(txt, function(tr)
if obj.Parent and obj.Visible ~= false then Trans.WriteText(obj, "Text", tr, txt) end
end, urgent)
end
Trans.RegCount = function()
local n = 0
for o in pairs(Trans.Reg) do if typeof(o) == "Instance" and o.Parent then n = n + 1 end end
return n
end
Trans.RegField = function(obj, field, raw)
local r = Trans.Reg[obj]
if not r then
r = { at = os.clock() }
Trans.Reg[obj] = r
end
if type(raw) == "string" and r[field] == nil then r[field] = raw end
r.at = os.clock()
end
Trans.RestoreAll = function()
local n = 0
for obj, r in pairs(Trans.Reg) do
if typeof(obj) == "Instance" and obj.Parent and type(r) == "table" then
pcall(function()
local rawT = r.Text
if type(rawT) == "string" then
local cur = nil
pcall(function() cur = obj.Text end)
if cur ~= rawT then obj.Text = rawT n = n + 1 end
end
local rawP = r.PlaceholderText
if type(rawP) == "string" then
local curP = nil
pcall(function() curP = obj.PlaceholderText end)
if curP ~= rawP then obj.PlaceholderText = rawP n = n + 1 end
end
end)
end
end
Trans.Reg = {}
return n
end
Trans._wGui = setmetatable({}, { __mode = "k" })
Trans._wGuiConn = nil
Trans.WorldGuiAdd = function(d)
if typeof(d) ~= "Instance" then return end
local c = d.ClassName
if c == "BillboardGui" or c == "SurfaceGui" then Trans._wGui[d] = true end
end
Trans.WorldGuiOn = function()
if Trans._wGuiConn then return end
local n = 0
pcall(function()
for _, d in ipairs(workspace:GetDescendants()) do
local c = d.ClassName
if c == "BillboardGui" or c == "SurfaceGui" then
Trans._wGui[d] = true
n = n + 1
end
end
end)
pcall(function() Trans._wGuiConn = workspace.DescendantAdded:Connect(Trans.WorldGuiAdd) end)
F.Out("[翻译] 已收录 " .. tostring(n) .. " 个世界告示牌(BillboardGui/SurfaceGui) ⇒ 地图上的牌子文字也会翻")
end
Trans._preSeen = {}
Trans._preSeenN = 0
Trans.PreAdd = function(text)
if not Trans._ready then return false end
if (Trans._preBudget or 0) <= 0 then return false end
if type(text) ~= "string" or text == "" then return false end
if Trans._preSeen[text] then return false end
if Trans._preSeenN >= 6000 then Trans._preSeen = {} Trans._preSeenN = 0 end
Trans._preSeen[text] = true
Trans._preSeenN = Trans._preSeenN + 1
if #Trans.Queue > 120 then return false end
if Trans.Lookup(text) then return false end
if not Trans.Should(text) then return false end
Trans.Async(text, function() end)
Trans._preBudget = Trans._preBudget - 1
Trans._preN = (Trans._preN or 0) + 1
if not Trans._preLogged and Trans._preN >= 20 then
Trans._preLogged = true
F.Out("[翻译] 已开始预翻屏幕外的文字(限速 12 条/轮, 不会把显卡吃满) ⇒ 它们一出现就直接是中文")
end
return true
end
Trans.Scan = function()
local _scNow = os.clock()
if Trans._scanAt and (_scNow - Trans._scanAt) < 5 then return end
Trans._scanAt = _scNow
Trans._preBudget = 12
local LPl = game:GetService("Players").LocalPlayer
pcall(Trans.RefreshPN)
local roots, rootNames = {}, {}
local function addRoot(r, tag)
if not r then return end
for i = 1, #roots do if roots[i] == r then return end end
roots[#roots + 1] = r
rootNames[#rootNames + 1] = tag
end
addRoot(LPl and LPl:FindFirstChild("PlayerGui"), "PlayerGui")
pcall(function() if gethui then addRoot(gethui(), "gethui") end end)
if #roots == 0 then return end
local list = {}
for i = 1, #roots do
local okD, d = pcall(function() return roots[i]:GetDescendants() end)
if okD and type(d) == "table" then
for j = 1, #d do list[#list + 1] = d[j] end
end
end
pcall(function()
if type(Trans._wGui) ~= "table" then return end
local wn = 0
for g in pairs(Trans._wGui) do
if not g.Parent then Trans._wGui[g] = nil
elseif g.Enabled ~= false and wn < 400 then
local ok2, ds = pcall(function() return g:GetDescendants() end)
if ok2 and type(ds) == "table" then
for k = 1, #ds do
local c2 = ds[k]
if typeof(c2) == "Instance" then
local cc = c2.ClassName
if cc == "TextLabel" or cc == "TextButton" then
list[#list + 1] = c2
wn = wn + 1
if wn >= 400 then break end
end
end
end
end
end
end
end)
local txtN, visN, cnN, enN = 0, 0, 0, 0
local uniqN = 0
local seenEn = {}
local samples = {}
for i = 1, #list do
if i % 200 == 0 then task.wait() end
local o = list[i]
if typeof(o) == "Instance" then
local c = o.ClassName
if c == "TextLabel" or c == "TextButton" or c == "TextBox" then
txtN = txtN + 1
if o.Visible ~= false and Trans.TextVisible(o) ~= false then
visN = visN + 1
local t = nil
pcall(function() t = o.Text end)
if type(t) == "string" and t ~= "" then
if t:find("[\228-\233]") then
cnN = cnN + 1
Trans.MarkSelfCN(o, t)
elseif Trans.Should(t) then
if not Trans.Lookup(t) then
enN = enN + 1
if not seenEn[t] then seenEn[t] = true uniqN = uniqN + 1 end
if #samples < 3 then samples[#samples + 1] = t:sub(1, 16) end
end
end
end
end
pcall(Trans.GuiEl, o)
Trans.HookVisible(o)
else
local th = nil
pcall(function() th = o.Text end)
if type(th) == "string" and th ~= "" and not th:find("[\228-\233]") then Trans.PreAdd(th) end
Trans.HookVisible(o)
end
end
end
if not Trans._diagOnce then
Trans._diagOnce = true
local s = (#samples > 0) and ("[" .. table.concat(samples, "|") .. "]") or "(没有可翻的英文)"
F.Out("[翻译·诊断] 扫了 " .. #roots .. " 个容器(" .. table.concat(rootNames, ",") .. ") ⇒ 可见文本 "
.. visN .. " 个 · 中文 " .. cnN .. " · 英文待翻 " .. enN .. " " .. s)
if enN > 0 and T.TransModel ~= true then
F.Out("[翻译] ⚠ 有 " .. tostring(enN) .. " 条新词缓存里没有, 现在没在翻(当前=只用缓存) ⇒ 到翻译页打开「连本地模型实时翻译新词」即可翻译")
end
if Fluent and Fluent.Notify then
if enN > 0 then
Fluent:Notify({ Title = "翻译", Content = "扫描到 " .. enN .. " 个英文待翻，正在翻译… 样本 " .. s, Duration = 8 })
else
Fluent:Notify({ Title = "翻译", Content = "没扫到英文(可见 " .. visN .. " · 中文 " .. cnN .. ") ⇒ 界面可能已是中文", Duration = 8 })
end
end
end
Trans._diagText = " 可见" .. visN .. "/中文" .. cnN .. "/待翻" .. enN .. "(去重" .. uniqN .. ")"
Trans._scanRound = Trans._scanRound + 1
if Trans._scanRound % 10 == 1 then
local now = os.clock()
local dt = now - (Trans._rateAt or now)
local dc = (Trans._cnt or 0) - (Trans._rateCnt or 0)
local rate = (dt > 0.5) and string.format("%.1f", dc / dt) or "-"
Trans._rateAt = now
Trans._rateCnt = Trans._cnt or 0
F.Out("[翻译] 扫描: 可见 " .. visN .. " · 中文 " .. cnN .. " · 英文待翻 " .. enN .. "(去重 " .. uniqN
.. ") · 队列 " .. tostring(#Trans.Queue) .. " · 缓存 " .. tostring(Trans.Count()) .. " 条 · 速率 " .. rate
.. "条/s · 批 " .. tostring(Trans._batchOk or 0) .. "/" .. tostring(Trans._batchFail or 0))
end
if Trans.Active >= Trans.MAX and #Trans.Queue > 0 then
local idle = os.clock() - (Trans._lastDone or os.clock())
if idle > 25 then
Trans._stuck = (Trans._stuck or 0) + 1
if Trans._stuck >= 2 then
Trans._stuck = 0
Trans.Active = 0
Trans._drainErr = 0
F.Out("[翻译] ⚠ 队列 25 秒无进展(模型疑似卡住) ⇒ 已重置并发计数, 会自动继续")
Trans.Drain()
end
end
else
Trans._stuck = 0
end
end
Trans.Stats = function()
if Trans.IsMobile then
F.Out("[翻译] 📱 本地缓存模式(手机/平板) · 已汉化 " .. tostring(Trans._cnt or 0)
.. " 条 · 已保存 " .. tostring(Trans._saveCount or 0) .. " 次")
elseif T.TransModel ~= true then
F.Out("[翻译] 📄 纯缓存汉化模式 · 已汉化 " .. tostring(Trans._cnt or 0)
.. " 条 · 已保存 " .. tostring(Trans._saveCount or 0) .. " 次(不连模型、不发请求)")
else
F.Out("[翻译] 待翻译 " .. tostring(#Trans.Queue) .. " 条 · 已翻译 " .. tostring(Trans._cnt or 0)
.. " 条 · 已保存 " .. tostring(Trans._saveCount or 0) .. " 次")
end
end
Trans.WatchOn = function()
local LPl = game:GetService("Players").LocalPlayer
local pg = LPl and LPl:FindFirstChild("PlayerGui")
if not pg then return end
pcall(function()
Trans._watchConn = pg.DescendantAdded:Connect(function(d)
task.defer(function() if T.Translate then pcall(Trans.GuiEl, d, true) end end)
end)
end)
end
Trans.WatchOff = function()
if Trans._watchConn then pcall(function() Trans._watchConn:Disconnect() end) Trans._watchConn = nil end
end
Trans.ApplyMode = function(quiet)
if not T.Translate then return end
if Trans.IsMobile then
Trans._ready = false
return
end
if T.TransModel == true then
Trans._ready = Trans.Health()
if Trans._ready then
if not quiet then F.Out("[翻译] ✅ 已连本地模型 ⇒ 缓存命中秒出 + 新词实时翻译") end
pcall(Trans.Scan)
else
if not quiet then F.Out("[翻译] 📄 模型还没连 ⇒ 先用缓存汉化, 模型一起来自动接着翻新词") end
end
Trans.StartReadyWatcher()
else
Trans._ready = false
if not quiet then F.Out("[翻译] 📄 纯缓存汉化: 只用已翻译好的缓存, 不连模型、不发请求") end
end
end
Trans.StartReadyWatcher = function()
if Trans._readyTask or Trans.IsMobile then return end
Trans._readyTask = task.spawn(function()
while T.Translate and T.TransModel == true do
task.wait(10)
if not (T.Translate and T.TransModel == true) then break end
if Trans._ready then
if not Trans.Health() then
Trans._ready = false
F.Out("[翻译] ⚠ 模型掉线 ⇒ 先用缓存汉化, 模型回来会自动继续翻")
end
else
if Trans.Health() then
Trans._ready = true
F.Out("[翻译] ✅ 本地模型已就绪 ⇒ 继续翻译")
pcall(Trans.Scan)
end
end
end
Trans._readyTask = nil
end)
end
function Trans.Enable()
pcall(function() Trans.WorldGuiOn() end)
pcall(function()
F.GlossLoad(true)
local _added, _tot = F.GlossApplyCache()
local _ctx = Trans.SlotCtx()
F.Out("[术语表] 已加载 " .. tostring(Trans.GLOSS_N or 0) .. " 条(来自 " .. Trans.GLOSS_FILE
.. ") + 内置修正表 ⇒ 合并 " .. tostring(_tot or 0) .. " 条固定译法 · 本次自动覆盖旧缓存 " .. tostring(_added)
.. " 条(规则/译法有更新也走这里 ⇒ 不用手动清空缓存)")
local _p = Trans.Prompt("zh", Trans.BATCH, "Settings Progress")
F.Out("[翻译] 参数: 每槽上下文 " .. tostring(_ctx) .. " token · 输出预留 " .. tostring(Trans.OutNeed(Trans.BATCH, _ctx))
.. " token · 提示词 " .. tostring(#Trans.SYS_BASE) .. " 字符(术语表不进提示词, 只在文本里命中时才贴几条)")
end)
T.Translate = true
Trans.Load()
pcall(Trans.NumTplLoad)
pcall(Trans.PurgeTpl)
local _ntc = 0
pcall(function() _ntc = Trans.TplFromCache() end)
if _ntc > 0 then
F.Out("[翻译] 数字模板: 已从缓存句子补建 " .. tostring(_ntc) .. " 条 ⇒ 同一句话换个数字也能瞬间出中文")
end
local name = nil
pcall(function() if F.CMX_GameName then name = F.CMX_GameName() end end)
Trans.KeepAdd(name)
pcall(function()
local op = Fluent and Fluent.Options and Fluent.Options.TransModel
if op and op.Value ~= nil then T.TransModel = (op.Value == true) end
end)
if Trans.IsMobile then
Trans._ready = false
F.Out("[翻译] 📱 手机/平板: 本地缓存模式 ⇒ 只用本机已缓存的译文汉化(不连本地模型、不走网络)")
else
Trans.ApplyMode(false)
end
pcall(Trans.Scan)
Trans.WatchOn()
task.spawn(Trans.LocInit)
if not Trans.Loop then
Trans.Loop = task.spawn(function()
while T.Translate do
task.wait(Trans.SCAN_EVERY)
if not T.Translate then break end
if T.TransModel == true and not Trans._ready and not Trans._readyTask and not Trans.IsMobile then pcall(Trans.ApplyMode, true) end
pcall(Trans.Scan)
if Trans._ready and not Trans._urgent and Trans.Active < Trans.MAX and #Trans.Queue > 0 then pcall(Trans.Drain) end
end
Trans.Loop = nil
end)
end
if not Trans._tickOn then
Trans._tickOn = true
task.spawn(Trans.SaveTick)
end
task.delay(2, function()
if T.Translate and T.TransModel == true and not Trans._ready and not Trans._readyTask and not Trans.IsMobile then
if not Trans.Health() then
F.Out("[翻译] ⚠ 开着「连本地模型」但连不上 " .. tostring(Trans.HOST) .. " ⇒ 先用缓存; 模型起来会自动接上")
else
pcall(Trans.ApplyMode, false)
end
end
end)
return true
end
function Trans.Disable()
T.Translate = false
Trans._ready = false
Trans.WatchOff()
Trans.Loop = nil
pcall(Trans.Flush)
local n = 0
pcall(function() n = Trans.RestoreAll() end)
F.Out("[翻译] 已关 · 已把 " .. tostring(n) .. " 处文字还原成原文 · 缓存已保存")
end
function F.TranslateDisable() Trans.Disable() end
function F.TranslateEnable()
local ok, r = pcall(Trans.Enable)
if not ok then F.Out("[翻译] 启动出错: " .. tostring(r)) return nil end
return r
end
local function UnloadAll()
pcall(function() if type(cleardrawcache) == "function" then cleardrawcache() end end)
for k in pairs(T) do T[k] = false end
local disables = {
F.AntiFlingDisable, F.AntiRagdollDisable, F.AntiKnockdownDisable,
F.FlingStop, F.FlingLoopStop, F.ClickTPDisable, F.BulletTrackDisable, F.WallClimbDisable, F.NoRecoilDisable, F.PierceDisable, F.TrapAutoRemoveDisable, F.HudDisable, F.CrosshairDisable, F.FovCircleDisable,
F.CharPersistDisable, F.LivePlayersDisable,
F.AntiAFKDisable, F.KickGuardPathsDisable,
AC.WatchNewRemotesDisable, AC.WatchNewScriptsDisable, AC.TrapDisable.Disable,
AC.UnblockRemotes, AC.ReenableDisabledConns, AC.UninstallAntiTP, AC.AntiPauseDisable, AC.UninstallIndexMask,
AC.UninstallSetmetatableHook, AC.UninstallNamecallHook,
F.GuiProtectionDisable,
F.TranslateDisable,
F.NoClipDisable,
F.SpeedRestore, F.FlySet, F.FlyDestroy, F.InstantInteractDisable, F.BypassDisable, F.AllInOneDisableAll, F.PinDisable,
F.SpoofDisable, F.CarryGuardDisable, F.GuardOnDisable, F.SpeedFreeDisable, F.NoPullDisable, F.DeepNeuterDisable, F.SpeedAntiTPDisable,
F.AimSet, F.RoleTagSet, F.IxHLSet, F.EspSet, F.XRaySet, F.KillAuraDisable, F.BodyHLDisable, F.HideDisable,
F.AutoTrainDisable, F.AutoBonusDisable, F.AutoGymDisable, F.HealthIsolateDisable, F.LockFieldsUninstall,
F.FullBrightDisable, F.NightVisionDisable, F.NoFogDisable,
F.InfiniteJumpDisable, F.SteadyDisable, F.TrapGuardDisable, F.HitGuardDisable, F.SpeedAntiTPDisable,
F.MenuMouseGuardStop,
F.DmgFxStop,
function()
AC._neutFns = {}
F._cfgSyncing = false
pcall(function()
local g = getgenv and getgenv()
if type(g) == "table" and F._inst and g[F.INSTANCE_KEY] == F._inst then
g[F.INSTANCE_KEY] = nil
end
end)
if F._touchToggle then pcall(function() F._touchToggle:Destroy() end) F._touchToggle = nil end
end,
MuteDisable, FOVDisable, ZoomDisable,
F.InvisibleDisable, AntilagDisable, GodDisable, RegenDisable, LockHealthDisable,
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
if getgenv then getgenv().CM_MenuWatch = nil end
end)
local killed = 0
pcall(function() killed = F.NukeAllGUIs(true) end)
if killed > 0 then F.Out("[卸载] 兜底清掉 " .. tostring(killed) .. " 个残留浮窗") end
pcall(F.Conn.ClearAll)
F.MetaLayers = {}
F.MetaTargets = {}
F.MetaSlot = {}
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
local _minSide = math.min(_vw, _vh)
local _phone = (_vw < 760) or (_vh < 500) or (_touch and _minSide <= 720)
local _w = math.clamp(math.floor(_vw * 0.96), 240, _phone and 520 or 500)
local _h = math.clamp(math.floor(_vh * 0.88), 240, _phone and 600 or 540)
local Window = Fluent:CreateWindow({
Title = "CheatMenu",
SubTitle = F.VERSION,
TabWidth = _phone and math.clamp(math.floor(_w / 8), 50, 66) or 100,
Size = UDim2.fromOffset(_w, _h),
Acrylic = false,
Theme = "Aqua",
MinimizeKey = Enum.KeyCode.G,
})
F.Window = Window
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
local vps = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)
local bw, bh = btn.AbsoluteSize.X, btn.AbsoluteSize.Y
local nx = math.clamp(bx + dx, 2, math.max(2, vps.X - bw - 2))
local ny = math.clamp(by + dy, 2, math.max(2, vps.Y - bh - 2))
btn.Position = UDim2.new(0, nx, 0, ny)
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
F.CMX_SpoofIndexDisable,
F.CMX_BlockReportDisable, F.CMX_CutLogDisable,
F.CMX_NeuterPlusDisable, F.CMX_HashFreezeDisable,
}) do pcall(fn) end
T.CMX_SpoofPos = false
F.CMX_SpoofOn, F.CMX_ViewOn, F.CMX_InstNewOn = false, false, false
task.delay(1, function() pcall(F.CMX_RestoreRO, true) end)
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
F.CMX_MarkOwn = function(o)
if typeof(o) == "Instance" then
F.CMX_Own[o] = true
F.CMX_HiddenCount = F.CMX_HiddenCount + 1
end
return o
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
F._ccProbe = nil
do
if type(checkcaller) == "function" then
local okC = pcall(checkcaller)
if okC then F._ccProbe = checkcaller end
end
end
F.CMX_IsCaller = function()
if not F._ccProbe then return true end
local ok, r = pcall(F._ccProbe)
if not ok then return true end
return r and true or false
end
F.CMX_SpoofLast = setmetatable({}, { __mode = "k" })
F.CMX_SpoofMiss = setmetatable({}, { __mode = "k" })
F.CMX_SpoofGen = 1
F.CMX_SpoofKey = {
Velocity = true, AssemblyLinearVelocity = true,
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
if k == "Position" or k == "CFrame" or k == "AssemblyAngularVelocity" or k == "RotVelocity" then
return box.orig(t, k)
end
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
"verify", "validate", "integrity", "tamper", "suspicion", "violation",
"anticheat", "accheck", "securitycheck", "audit", "inspect", "monitor",
"sentry", "watcher", "tripwire", "honeypot", "canary", "fingerprint",
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
for i = 1, #out do
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
for i = 1, #per do F.Out("[反封禁·上报]   · " .. tostring(per[i])) end
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
"detect", "detection", "verify", "validate", "audit", "inspect", "monitor",
"tripwire", "honeypot", "canary", "integrity", "tamper", "fingerprint", "signature",
"antiCheat", "anticheat", "acCheck", "securityCheck", "suspicion", "suspicious",
"violation", "offense", "strike", "enforce", "moderation", "moderator",
"hookDetect", "metaCheck", "memoryCheck", "gcCheck", "speedCheck", "flyCheck",
"watcher", "sentry", "guardAI", "reportDetect", "flagPlayerInternal", "banAsync",
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
F.CMX_NPOn = true
local work = function()
local n, seen = 0, 0
local saved = F.CMX_NPSaved
local noop = F._gcNoop or function() return end
pcall(function()
for _, v in pairs(getgc(true)) do
seen = seen + 1
if seen > 60000 then break end
if not F.CMX_NPOn then break end
if seen % 1500 == 0 and F._isyieldable() then task.wait() end
if seen % 1500 == 0 and not F.CMX_NPOn then break end
if type(v) == "table" then
for i = 1, #NAMES do
local f = rawget(v, NAMES[i])
if type(f) == "function" then
saved[#saved + 1] = { t = v, k = NAMES[i], f = f }
rawset(v, NAMES[i], noop)
n = n + 1
end
end
end
end
end)
F.Out("[反封禁·按名中和+] 已扫 " .. tostring(seen) .. " 个表, 中和 " .. tostring(n)
.. " 个封禁/举报/标记类函数(ban/report/flag/onDetect/antiKick…) · 关闭时逐个还原")
return n > 0
end
local r = F.RunChunked(work, "按名中和+")
return (r == nil) or (r == true)
end
F.CMX_NeuterPlusDisable = function()
if not F.CMX_NPOn then return end
F.CMX_NPOn = false
local n = 0
for i = 1, #(F.CMX_NPSaved or {}) do
local rec = F.CMX_NPSaved[i]
if rec and rec.t then
pcall(rawset, rec.t, rec.k, rec.f)
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
F.CMX_HashOn = true
F.CMX_HashFreezeHits = 0
F._islcFn = (type(islclosure) == "function") and islclosure or nil
F._dbgInfo = (type(debug) == "table" and type(debug.info) == "function") and debug.info or nil
local work = function()
local props = 0
local savedH = F.CMX_HashSaved
local islcFn, dbgInfo = F._islcFn, F._dbgInfo
pcall(function()
for _, f in pairs(getgc(true)) do
props = props + 1
if props > 60000 then break end
if not F.CMX_HashOn then break end
if props % 1500 == 0 and F._isyieldable() then task.wait() end
if props % 1500 == 0 and not F.CMX_HashOn then break end
if type(f) == "function" then
local isl = false
if islcFn then
local okL, r = pcall(islcFn, f)
if okL then isl = r and true or false end
end
if isl then
local src, nm = "", ""
if dbgInfo then
local okI, s2, _l2, n2 = pcall(dbgInfo, f, "sln")
if okI then src = tostring(s2 or "") nm = tostring(n2 or "") end
end
local low = (src .. " " .. nm):lower()
if low:find("hash", 1, true) or low:find("digest", 1, true) or low:find("checksum", 1, true) then
savedH[#savedH + 1] = f
end
end
end
end
end)
if not F.CMX_HashOn then return false end
local n = 0
for i = 1, #F.CMX_HashSaved do
if not F.CMX_HashOn then break end
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
F.Out("[反封禁·哈希冻结] 找到 " .. tostring(#F.CMX_HashSaved) .. " 个名字像哈希的闭包;"
.. " 第一次算出的 32/40/64 位 hex 会被记住, 之后恒定返回同一个值 ⇒ 服务器看到客户端指纹一直没变")
return #F.CMX_HashSaved > 0
end
local r = F.RunChunked(work, "哈希冻结")
return (r == nil) or (r == true)
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
F.CMX_InboundWatchSet = function(on)
T.CMX_InboundWatch = on and true or false
if not on then
if F._inbConns then for _, c in ipairs(F._inbConns) do pcall(function() c:Disconnect() end) end end
if F._inbAdded then pcall(function() F._inbAdded:Disconnect() end) F._inbAdded = nil end
F._inbConns, F._inbSeen = {}, {}
F.Out("[服务端预警] 已停(不再监听服务端下发)")
return
end
if F._inbConns and #F._inbConns > 0 then return end
F._inbConns, F._inbSeen = F._inbConns or {}, F._inbSeen or {}
local function isDanger(nm)
local low = tostring(nm):lower()
for _, k in ipairs(F.CMX_BAN_KEYS) do if low:find(k, 1, true) then return k end end
return nil
end
local function watch(re)
if not re or F._inbSeen[re] then return end
if not (re:IsA("RemoteEvent") or re:IsA("UnreliableRemoteEvent")) then return end
if not isDanger(re.Name) then return end
F._inbSeen[re] = true
local ok, c = pcall(function()
return re.OnClientEvent:Connect(function(...)
if not T.CMX_InboundWatch then return end
F.CMX_InboundHits = (F.CMX_InboundHits or 0) + 1
if os.clock() - (F._inbLogAt or 0) > 4 then
F._inbLogAt = os.clock()
F.Out("[服务端预警] 服务端下发了「" .. tostring(re.Name) .. "」(" .. tostring(select("#", ...))
.. " 个参数) —— 这是它在判你/通知你的下行通道(累计 " .. tostring(F.CMX_InboundHits) .. " 次)")
end
end)
end)
if ok and c then F._inbConns[#F._inbConns + 1] = c end
end
pcall(function()
local rs2 = game:GetService("ReplicatedStorage")
for _, d in ipairs(F.walk(rs2)) do watch(d) end
end)
if F._inbAdded then pcall(function() F._inbAdded:Disconnect() end) end
F._inbAdded = nil
pcall(function()
F._inbAdded = game:GetService("ReplicatedStorage").DescendantAdded:Connect(function(d)
if not T.CMX_InboundWatch then return end
watch(d)
end)
end)
F.Out("[服务端预警] 已开: 已挂 " .. tostring(#F._inbConns) .. " 个「危险命名」remote 的下发监听(只记录, 不改行为)")
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
if cc > 0 then
F.Out("[反检测]    ⚠ C 闭包形态会被「islclosure 自检」认出来(本版没有可开的新 C 闭包化开关, 仅提示)")
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
if inCore > 0 then F.Out("[反检测]    ⚠ 明文挂在 CoreGui 的界面, 游戏用 CoreGui:GetChildren() 就能看到 ⇒ 建议关掉「界面保护」外的多余挂载") end
local mtRO = "?"
pcall(function()
local mt = getrawmetatable(game)
if mt and type(isreadonly) == "function" then mtRO = tostring(isreadonly(mt)) end
end)
F.Out("[反检测] ④ game 元表只读状态 = " .. mtRO .. "(false 表示我们为了挂钩把它解锁了)")
F.Out("[反检测] 结论: 上面带 ⚠ 的项就是当前暴露面(可关的项见系统页「反作弊」区)")
end
F.ACWriteTierApply = function(v)
v = tostring(v or "")
local on = v:find("②", 1, true) ~= nil or v:find("③", 1, true) ~= nil
local deep = v:find("③", 1, true) ~= nil
F.Out("[防护·改写档] = " .. v)
if on then
F.Try("MetaHookEnsure", F.MetaHookEnsure)
F.Try("InstallNamecallHook", AC.InstallNamecallHook)
F.Try("InstallIndexMask", AC.InstallIndexMask)
F.Try("InstallSetmetatableHook", AC.InstallSetmetatableHook)
pcall(function() AC.DisableACConnections(true) end)
pcall(function() AC.WatchNewScriptsEnable() end)
pcall(function() AC.WatchNewRemotesEnable() end)
F.Out("[防护·改写档] 已注入: 元表钩(__namecall/__index/setmetatable) + 拦 remote + 断了可疑监听 + 新脚本/新远程监视")
else
F.Try("UninstallNamecallHook", AC.UninstallNamecallHook)
F.Try("UninstallIndexMask", AC.UninstallIndexMask)
F.Try("UninstallSetmetatableHook", AC.UninstallSetmetatableHook)
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
if n > 400000 then break end
if d:IsA("BasePart") then
local nm = string.lower(d.Name)
for _, k in ipairs(KEYS) do
if string.find(nm, k, 1, true) then
local key = d.Name .. "|" .. d.ClassName
if not seen[key] then
seen[key] = true
if #list < 50000 then
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
if n > 400000 then break end
if d:IsA("ClickDetector") or d:IsA("ProximityPrompt") then
local p = d.Parent
if p and p:IsA("BasePart") then
local dist = (p.Position - root.Position).Magnitude
if dist <= 5000 then
local extra = " · 物体=" .. tostring(p.Name)
if d:IsA("ProximityPrompt") then
local at, ot = "", ""
pcall(function() at = tostring(d.ActionText or "") end)
pcall(function() ot = tostring(d.ObjectText or "") end)
local bag = (tostring(p.Name) .. " " .. at .. " " .. ot):lower()
local hit = bag:find("trophy", 1, true) or bag:find("claim", 1, true) or bag:find("reward", 1, true) or bag:find("奖", 1, true) or bag:find("领", 1, true) or bag:find("milestone", 1, true)
extra = extra .. string.format(" · 动作=%s · 说明=%s", at, ot)
if hit then extra = extra .. " · [按住式交互点]" end
end
near[#near + 1] = string.format("%s (%s) · %.0f 格%s", d.Name, d.ClassName, dist, extra)
end
end
end
end
end)
table.sort(near)
F.Out("[扫描·交互点] 5000 格内共 " .. tostring(#near) .. " 个(纯只读, 不会自动点任何东西)")
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
F.ScanGameAPI = function()
F.Out("[扫描·游戏接口] ===== 反编译游戏自己的「蛋/认领/放置/任务 + 世界/交易世界/换服 + 投掷/概率」脚本(含 ReplicatedStorage 的 Controllers/Shared), 摘出它怎么调远程/调传送(只读) =====")
local KEY = { "egg", "claim", "place", "steal", "drop", "quest", "mission", "task", "rebirth",
"world", "trade", "shuffle", "rejoin", "serverhop", "matchmake", "lobby", "serverlist",
"worldswitch", "switchworld", "newserver", "joinserver",
"throw", "train", "odds", "chance", "rarity", "luck", "pool", "launch", "strength" }
local n, shown = 0, 0
pcall(function()
local roots = {}
local pg = LP:FindFirstChild("PlayerGui")
local ps = LP:FindFirstChild("PlayerScripts")
if pg then roots[#roots + 1] = pg end
if ps then roots[#roots + 1] = ps end
pcall(function()
local rs = game:GetService("ReplicatedStorage")
for _, nm in ipairs({ "Controllers", "Shared", "DataModules", "Modules", "Services", "ServerScriptService" }) do
local m = rs:FindFirstChild(nm)
if m then roots[#roots + 1] = m end
end
end)
for ri = 1, #roots do
local seen = 0
for _, d in ipairs(roots[ri]:GetDescendants()) do
seen = seen + 1
if seen % 400 == 0 then task.wait() end
local cls = d.ClassName
if cls == "LocalScript" or cls == "ModuleScript" or cls == "Script" then
local full = ""
pcall(function() full = d:GetFullName() end)
local low = (tostring(d.Name) .. " " .. full):lower()
local hit = false
for i = 1, #KEY do if low:find(KEY[i], 1, true) then hit = true break end end
if hit then
local code = nil
pcall(function() if type(decompile) == "function" then code = decompile(d) end end)
if type(code) ~= "string" or #code < 16 then pcall(function() if type(getscriptbytecode) == "function" then code = getscriptbytecode(d) end end) end
if type(code) == "string" and #code >= 8 then
n = n + 1
local KW = { "InvokeServer", "FireServer", ":fire(", ":Fire(", ":invoke(", ":Invoke(",
"ClaimArea", "claim", "Net.", "Remo", "placeEgg", "PlaceEgg", "getClaimArea",
"TeleportService", "Teleport", "ServerInstanceId", "JobId", "ReserveServer", "reserveServer",
"shuffle", "Shuffle", "World", "world",
"throw", "Throw", "Odds", "odds", "Chance", "chance", "Rarity", "rarity", "Luck", "luck",
"math.random", "Random", "Weight", "weight", "Pool", "pool", "Power", "power" }
local lines = {}
for line in tostring(code):gmatch("[^\n]+") do
local keep = false
for i = 1, #KW do if line:find(KW[i], 1, true) then keep = true break end end
if keep and #lines < 500 then
lines[#lines + 1] = tostring(line):gsub("^%s+", ""):sub(1, 170)
end
end
if #lines > 0 then
F.Out("[扫描·游戏接口] ▸ " .. full:sub(1, 110))
for i = 1, #lines do F.Out("      " .. lines[i]) shown = shown + 1 end
end
end
end
end
end
end
end)
F.Out("[扫描·游戏接口] 命中 " .. tostring(n) .. " 个脚本 · 摘出 " .. tostring(shown) .. " 行调用")
pcall(function()
local PRI = { "eggplacement", "placement", "eggcontroller", "areaegg", "claimcontroller", "eggnet" }
local roots = {}
local pg = LP:FindFirstChild("PlayerGui")
local ps = LP:FindFirstChild("PlayerScripts")
if pg then roots[#roots + 1] = pg end
if ps then roots[#roots + 1] = ps end
pcall(function()
local rs = game:GetService("ReplicatedStorage")
for _, nm in ipairs({ "Controllers", "Shared" }) do
local m = rs:FindFirstChild(nm)
if m then roots[#roots + 1] = m end
end
end)
local dumped = 0
F.Out("[扫描·游戏接口] ---- 优先整段摘录(名字像 蛋/放置/认领 的脚本) ----")
for ri = 1, #roots do
if dumped >= 40 then break end
local seen = 0
for _, d in ipairs(roots[ri]:GetDescendants()) do
if dumped >= 40 then break end
seen = seen + 1
if seen % 300 == 0 then task.wait() end
local cls = d.ClassName
if (cls == "ModuleScript" or cls == "LocalScript" or cls == "Script") then
local low = tostring(d.Name):lower()
local pri = false
for i = 1, #PRI do if low:find(PRI[i], 1, true) then pri = true break end end
if pri then
local code = nil
pcall(function() if type(decompile) == "function" then code = decompile(d) end end)
if type(code) ~= "string" or #code < 16 then pcall(function() if type(getscriptbytecode) == "function" then code = getscriptbytecode(d) end end) end
if type(code) == "string" and #code >= 8 then
dumped = dumped + 1
F.Out("[扫描·游戏接口·整段] ▸ " .. tostring(d:GetFullName()):sub(1, 110))
local ln = 0
for line in tostring(code):gmatch("[^\n]+") do
ln = ln + 1
if ln > 800 then F.Out("      ...(只摘前 110 行)"); break end
F.Out("      L" .. tostring(ln) .. ": " .. tostring(line):gsub("^%s+", ""):sub(1, 160))
end
end
end
end
end
end
F.Out("[扫描·游戏接口·整段] 共整段摘出 " .. tostring(dumped) .. " 个脚本")
end)
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
task.wait()
pcall(F.ScanGameAPI)
task.wait()
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
pcall(F.ScanRoles)
task.wait()
pcall(function()
local n = F.NpcScan()
F.Out("[扫描·NPC] 场上识别到 " .. tostring(n) .. " 个 NPC/傀儡")
end)
pcall(function()
local n = F.IxScan()
F.Out("[扫描·交互] 场上识别到 " .. tostring(n) .. " 个可交互物")
end)
pcall(F.LogFlush, "一键全扫描")
F.Out("[扫描] ===== 一键全扫描 结束 · 点「复制扫描结果」交给我  =====")
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
for i = 1, #arr do
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
F.GetTargetPlayer = function()
local nm = nil
pcall(function()
if Fluent and Fluent.Options and Fluent.Options.TPTarget then nm = Fluent.Options.TPTarget.Value end
end)
if not nm then return nil, "先在「传送」页的『目标玩家』下拉里选一个人" end
local pl = Players:FindFirstChild(tostring(nm))
if not pl then return nil, "找不到玩家「" .. tostring(nm) .. "」(可能已离开)" end
if not pl.Character or not pl.Character.Parent then return nil, "「" .. pl.Name .. "」现在没有角色(在复活/已死)" end
return pl, nil
end
F.GrabOwner = function(part)
if not part then return false, "目标没有部件" end
local can = true
pcall(function() if part.CanSetNetworkOwnership then can = part:CanSetNetworkOwnership() end end)
if not can then return false, "服务端锁了所有权 ⇒ 本服不支持直接动别人" end
local ok = pcall(function() part:SetNetworkOwner(LP) end)
if not ok then return false, "抢所有权被拒(执行器或服务端不允许)" end
return true, nil
end
F._clickTPConn = nil
function F.ClickTPEnable()
if F._clickTPConn then return end
local ok, mouse = pcall(function() return LP:GetMouse() end)
if not ok or not mouse then
F.Out("[点击传送] 本环境拿不到鼠标对象 ⇒ 无法开启(桌面端才有鼠标)")
return
end
F._clickTPConn = mouse.Button1Down:Connect(function()
if not T.ClickTP then return end
if F._typing then return end
if F.MenuOpen and F.MenuOpen() then return end
if not mouse.Target then return end
local _, hum, root = GC()
if not (root and hum and hum.Health > 0) then return end
local hit = mouse.Hit
if not hit then return end
pcall(function()
root.AssemblyLinearVelocity = Vector3.zero
root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 4, 0))
end)
end)
F.Out("[点击传送] 已开: 鼠标左键点到哪就传到哪(点到 UI / 天空不会传)")
end
function F.ClickTPDisable()
if F._clickTPConn then pcall(function() F._clickTPConn:Disconnect() end) F._clickTPConn = nil end
end
F._flingLoopOn = false
F.FlingLoopStart = function()
if F._flingLoopOn then return end
F._flingLoopOn = true
task.spawn(function()
while F._flingLoopOn and T.LoopFling do
local pl = F.GetTargetPlayer()
if pl then pcall(F.FlingPlayer, pl) end
task.wait(tonumber(C.FlingInterval) or 1.5)
end
F._flingLoopOn = false
end)
F.Out("[循环甩飞] 已开: 每 " .. tostring(tonumber(C.FlingInterval) or 1.5) .. " 秒对当前目标甩一次")
end
F.FlingLoopStop = function()
F._flingLoopOn = false
pcall(F.FlingStop)
F.Out("[循环甩飞] 已关")
end
F._flingAllBusy = false
F.FlingAll = function()
if F._flingAllBusy then F.Out("[甩飞所有人] 上一轮还没跑完, 稍等") return end
F._flingAllBusy = true
task.spawn(function()
local n, list = 0, Players:GetPlayers()
for _, pl in ipairs(list) do
if pl ~= LP and pl.Character then
n = n + 1
pcall(F.FlingPlayer, pl)
task.wait(tonumber(C.FlingInterval) or 1.5)
end
end
F._flingAllBusy = false
F.Out("[甩飞所有人] 已对 " .. tostring(n) .. " 个玩家逐个甩飞")
end)
end
F._btParts = setmetatable({}, { __mode = "k" })
F._btConn, F._btAdded = nil, nil
F.BulletTrackIsBullet = function(name)
local n = tostring(name):lower()
if n == "" then return false end
local kws = { "bullet", "projectile", "pellet", "rocket", "arrow", "bolt", "shell", "tracer", "子弹", "弹道" }
for i = 1, #kws do
if n:find(kws[i], 1, true) then return true end
end
return false
end
F.BulletTrackTarget = function()
local ch = F._combatNow
if ch and ch.Parent then
local r = ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart
if r then return r end
end
local op = Fluent and Fluent.Options and Fluent.Options.TPTarget
local name = op and op.Value
if name then
local ok, pl = pcall(function() return Players:FindFirstChild(tostring(name)) end)
if ok and pl and pl.Character then
local r = pl.Character:FindFirstChild("HumanoidRootPart") or pl.Character.PrimaryPart
if r then return r end
end
end
return nil
end
F.BulletTrackEnable = function()
if F._btAdded then return end
F.Out("[子弹追踪] 已开: 正在寻找投射物系统…")
task.spawn(function()
local hit = false
pcall(function()
local mods = {}
for _, d in ipairs(RStorage:GetDescendants()) do
if d:IsA("ModuleScript") then
local n = d.Name:lower()
if n:find("projectile", 1, true) or n:find("bullet", 1, true) or n:find("weapon", 1, true) or n:find("gun", 1, true) then
mods[#mods + 1] = d
end
end
end
local wrap = newcclosure or function(f) return f end
for _, m in ipairs(mods) do
local r = nil
pcall(function() r = require(m) end)
if type(r) == "table" and type(r.SimulateProjectile) == "function" and not r.__cmBtHooked then
local orig = r.SimulateProjectile
r.SimulateProjectile = wrap(function(...)
local args = { ... }
local dirs, origin = args[5], args[6]
if T.BulletTrack and type(dirs) == "table" and origin then
local tgt = F.BulletTrackTarget()
if tgt then
local wp = origin.WorldPosition or origin
if typeof(wp) == "Vector3" then
local u = (tgt.Position - wp).Unit
for i = 1, #dirs do dirs[i] = u end
end
end
end
return orig(...)
end)
r.__cmBtHooked = true
hit = true
F.Out("[子弹追踪] ✅ 已 hook 投射物系统: " .. m:GetFullName() .. " ⇒ 射出的子弹会自动拐向目标")
break
end
end
end)
if not hit then
F.Out("[子弹追踪] 未找到投射物模块 ⇒ 已切到「飞行部件追踪」(对新增的子弹类部件逐帧改向)")
end
end)
F._btAdded = workspace.DescendantAdded:Connect(function(d)
if not T.BulletTrack then return end
if typeof(d) ~= "Instance" then return end
local ok, isPart = pcall(function() return d:IsA("BasePart") end)
if ok and isPart and not F._btParts[d] and F.BulletTrackIsBullet(d.Name) then
F._btParts[d] = true
end
end)
F._btConn = RS.Heartbeat:Connect(function()
if not T.BulletTrack then return end
local tgt = F.BulletTrackTarget()
local tp = tgt and tgt.Position
for p in pairs(F._btParts) do
if not p.Parent then
F._btParts[p] = nil
elseif tp then
pcall(function()
local d = tp - p.Position
if d.Magnitude > 1 then
local sp = p.AssemblyLinearVelocity.Magnitude
if sp < 1 then sp = 250 end
p.AssemblyLinearVelocity = d.Unit * sp
end
end)
end
end
end)
end
F.BulletTrackDisable = function()
if F._btAdded then pcall(function() F._btAdded:Disconnect() end) F._btAdded = nil end
if F._btConn then pcall(function() F._btConn:Disconnect() end) F._btConn = nil end
end
F._aiList = setmetatable({}, { __mode = "k" })
F._aiAdded, F._autoIxConn = nil, nil
F._wallClimbConn = nil
F.WallClimbEnable = function()
if F._wallClimbConn then return end
F._wallClimbConn = RS.Heartbeat:Connect(function()
if not T.WallClimb then F.WallClimbDisable() return end
local ch, hum, root = GC()
if not (ch and hum and root and hum.Health > 0) then return end
pcall(function()
local rp = RaycastParams.new()
pcall(function() rp.FilterType = Enum.RaycastFilterType.Exclude end)
rp.FilterDescendantsInstances = { ch }
local hit = workspace:Raycast(root.Position, root.CFrame.LookVector * 3, rp)
if hit and math.abs(hit.Normal.Y) < 0.5 then
hum:ChangeState(Enum.HumanoidStateType.Freefall)
local v = root.AssemblyLinearVelocity
root.AssemblyLinearVelocity = Vector3.new(v.X, tonumber(C.WallClimbSpeed) or 50, v.Z)
end
end)
end)
F.Out("[爬墙] 已开: 面朝竖直墙面时自动向上爬(速度 " .. tostring(tonumber(C.WallClimbSpeed) or 50) .. ")")
end
F.WallClimbDisable = function()
if F._wallClimbConn then pcall(function() F._wallClimbConn:Disconnect() end) F._wallClimbConn = nil end
end
F.SpawnTP = function()
local _, hum, root = GC()
if not (root and hum and hum.Health > 0) then F.Out("[出生点] 现在没有角色(没进游戏/正在重生)") return end
local sp = nil
pcall(function() sp = workspace:FindFirstChildOfClass("SpawnLocation") end)
if not sp then
pcall(function()
for _, d in ipairs(workspace:GetDescendants()) do
if d:IsA("SpawnLocation") then sp = d break end
end
end)
end
if not sp then
F.Out("[出生点] 这个世界里没有 SpawnLocation(有些游戏用脚本临时生成) ⇒ 传不了")
return
end
local ok = pcall(function()
root.AssemblyLinearVelocity = Vector3.zero
root.CFrame = CFrame.new(sp.Position + Vector3.new(0, 4, 0))
end)
F.Out(ok and ("[出生点] 已传送到出生点 (" .. sp:GetFullName() .. ")") or "[出生点] 传送失败(被冻住/被拉回)")
end
F._nrSaved = {}
F.NoRecoilEnable = function()
if type(getgc) ~= "function" or type(rawset) ~= "function" then
F.Out("[无后坐力] 本执行器缺 getgc/rawset ⇒ 无法开启")
return
end
local kws = { "recoil", "viewkick", "camshake", "shake", "spread", "bloom", "sway", "kickback", "crosshairkick" }
local n = 0
pcall(function()
for _, t in pairs(getgc(true)) do
if type(t) == "table" then
for k, f in pairs(t) do
if type(k) == "string" and type(f) == "function" then
local lk = k:lower()
local hit = false
for i = 1, #kws do
if lk:find(kws[i], 1, true) then hit = true break end
end
if hit then
F._nrSaved[t] = F._nrSaved[t] or {}
if not F._nrSaved[t][k] then
F._nrSaved[t][k] = f
pcall(function() rawset(t, k, function() end) end)
n = n + 1
end
end
end
end
end
end
end)
if n == 0 then
F.Out("[无后坐力] 没扫到后坐力函数(可能这游戏没有, 或先开一枪再开本功能)")
else
F.Out("[无后坐力] 已开: 已把 " .. tostring(n) .. " 个后坐力/镜头抖动函数置空")
end
end
F.NoRecoilDisable = function()
local n = 0
pcall(function()
for t, kv in pairs(F._nrSaved) do
for k, f in pairs(kv) do
pcall(function() rawset(t, k, f) end)
n = n + 1
end
end
end)
F._nrSaved = {}
F.Out("[无后坐力] 已关: 已还原 " .. tostring(n) .. " 个函数")
end
F._pierceOrig, F._pierceHooked = nil, false
F.PierceTarget = function()
local ch = F._combatNow
if ch and ch.Parent then return ch end
return nil
end
F.PierceEnable = function()
if F._pierceHooked then return end
if type(hookfunction) ~= "function" then
F.Out("[穿透弹] 本执行器没有 hookfunction ⇒ 无法开启")
return
end
local WR = workspace
if type(WR.Raycast) ~= "function" then
F.Out("[穿透弹] 拿不到 workspace.Raycast ⇒ 无法开启")
return
end
local wrap = newcclosure or function(f) return f end
local orig
local hookFn = wrap(function(self, origin, direction, params)
if T.Pierce then
local tgt = F.PierceTarget()
if tgt then
local np = nil
pcall(function()
np = RaycastParams.new()
pcall(function() np.FilterType = Enum.RaycastFilterType.Include end)
pcall(function() np.FilterType = Enum.RaycastFilterType.Whitelist end)
np.FilterDescendantsInstances = { tgt }
np.IgnoreWater = true
end)
if np then return orig(self, origin, direction, np) end
end
end
return orig(self, origin, direction, params)
end)
local ok, ret = pcall(function() return hookfunction(WR.Raycast, hookFn) end)
if not ok then
F.Out("[穿透弹] hook 失败: " .. tostring(ret))
return
end
orig = ret
F._pierceOrig = ret
F._pierceHooked = true
F.Out("[穿透弹] 已开: 射线只命中锁定目标 ⇒ 打穿墙和其他人(需先用自瞄锁定目标)")
end
F.PierceDisable = function()
if not F._pierceHooked then return end
pcall(function()
if type(hookfunction) == "function" and F._pierceOrig then
hookfunction(workspace.Raycast, F._pierceOrig)
end
end)
F._pierceOrig, F._pierceHooked = nil, false
F.Out("[穿透弹] 已关: 射线已还原")
end
F.FlingStop = function()
F._flingHit = false
if F._flingConn then pcall(function() F._flingConn:Disconnect() end) F._flingConn = nil end
pcall(function()
local _, _, r = GC()
if r and r.Parent then r.AssemblyAngularVelocity = Vector3.zero end
end)
end
F.FlingPlayer = function(targetPlayer)
pcall(F.FlingStop)
local pl, err
if targetPlayer then pl = targetPlayer else pl, err = F.GetTargetPlayer() end
if not pl then F.Out("[甩飞] " .. tostring(err)) return end
local tp = pl.Character
if not tp then F.Out("[甩飞] 目标当前没有角色") return end
local tRoot = tp:FindFirstChild("HumanoidRootPart") or tp.PrimaryPart
if not tRoot then F.Out("[甩飞] 目标没有 HumanoidRootPart") return end
local tHum = tp:FindFirstChildOfClass("Humanoid")
local _, _, myRoot0 = GC()
local homeCF = nil
if myRoot0 and myRoot0.Parent then
local okp, cf = pcall(function() return myRoot0:GetPivot() end)
if okp and cf then homeCF = cf end
end
local function goHome()
if not homeCF then return end
local _, _, r = GC()
if r and r.Parent then
pcall(function()
r.AssemblyLinearVelocity = Vector3.zero
r.AssemblyAngularVelocity = Vector3.zero
r:PivotTo(homeCF)
end)
end
end
local ok, why = F.GrabOwner(tRoot)
F.Out("[甩飞] 目标「" .. pl.Name .. "」· 抢所有权: " .. (ok and "成功" or ("失败 ⇒ " .. tostring(why))))
if ok then
F.Out("[甩飞] 用「直接推飞」: 先把他抬离地面, 再给极大的线性速度+自转")
task.spawn(function()
local i
for i = 1, 10 do
if not (tRoot and tRoot.Parent) then break end
pcall(function()
if tHum and tHum.Parent then tHum.PlatformStand = true end
tRoot:PivotTo(tRoot:GetPivot() + Vector3.new(0, 1, 0))
tRoot.AssemblyLinearVelocity = Vector3.new(math.random(-400, 400), 700, math.random(-400, 400))
tRoot.AssemblyAngularVelocity = Vector3.new(math.random(-2000, 2000), math.random(-2000, 2000), math.random(-2000, 2000))
end)
task.wait(0.05)
end
task.wait(0.6)
pcall(function() if tHum and tHum.Parent then tHum.PlatformStand = false end end)
goHome()
F.Out("[甩飞] 结束")
end)
else
F.Out("[甩飞] 抢不到他的所有权 ⇒ 改用「每帧绕圈贴脸撞击」: 每帧换个角度瞬移到他身上 + 极大速度, 靠服务器物理把他甩出去")
F._flingHit = true
task.spawn(function()
local _, _, myRoot = GC()
if not (myRoot and myRoot.Parent) then goHome() F.Out("[甩飞] 没有自己的角色, 本次没动") return end
local myChar = myRoot.Parent
local saved = {}
if myChar then
for _, p in ipairs(myChar:GetDescendants()) do
if p:IsA("BasePart") then
saved[p] = p.CanCollide
pcall(function() p.CanCollide = false end)
end
end
end
local done = false
local function wrapOut(msg)
if done then return end
done = true
if F._flingConn then pcall(function() F._flingConn:Disconnect() end) F._flingConn = nil end
if myChar then
for p, v in pairs(saved) do
if p.Parent then pcall(function() p.CanCollide = v end) end
end
end
goHome()
F.Out("[甩飞] " .. msg)
end
local t0 = os.clock()
local spin = 0
F._flingConn = RS.Heartbeat:Connect(function()
if done then return end
if not F._flingHit then wrapOut("已手动停止 · 自身已复位 · 已回到原地") return end
if os.clock() - t0 > 1.0 then wrapOut("结束(贴脸撞击 1 秒 · 自身已复位 · 已回到原地)") return end
local r = myRoot
if not (r and r.Parent) then wrapOut("自己没角色了 · 已回到原地") return end
local tr = tRoot
if not (tr and tr.Parent) then wrapOut("目标没了 · 已回到原地") return end
spin = spin + 1
local ang = CFrame.Angles(0, math.rad(spin * 18), 0)
pcall(function()
r.CFrame = tr.CFrame * ang
r.AssemblyLinearVelocity = Vector3.new(1e5, 1e5, 1e5)
r.AssemblyAngularVelocity = Vector3.new(1e5, 1e5, 1e5)
end)
end)
end)
end
end
local Tabs = {
Combat  = Window:AddTab({ Title = "战斗", Icon = "crosshair" }),
Surv    = Window:AddTab({ Title = "生存", Icon = "shield" }),
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
F._uiFails = 0
local _tabAPI = { "AddSection", "AddToggle", "AddSlider", "AddButton", "AddDropdown", "AddInput", "AddColorPicker" }
local function _safeTab(t, tag)
local p = {}
local k, nm
for k = 1, #_tabAPI do
nm = _tabAPI[k]
p[nm] = (function(fn, label)
return function(_, ...)
local ok, res = pcall(fn, t, ...)
if not ok then
if label == "AddColorPicker" then
local p1, p2 = ...
local opts = p2 or {}
local ok2 = false
pcall(function()
local PRESET = {
["绿"] = Color3.fromRGB(0, 255, 120),
["红"] = Color3.fromRGB(255, 60, 60),
["黄"] = Color3.fromRGB(255, 220, 60),
["青"] = Color3.fromRGB(0, 235, 255),
["蓝"] = Color3.fromRGB(70, 140, 255),
["白"] = Color3.fromRGB(255, 255, 255),
["紫"] = Color3.fromRGB(190, 120, 255),
["橙"] = Color3.fromRGB(255, 150, 40),
}
t:AddDropdown(p1, {
Title = tostring(opts.Title or "颜色") .. " [预设 · 本执行器无取色器]",
Values = { "绿", "红", "黄", "青", "蓝", "白", "紫", "橙" },
Default = "绿",
Callback = function(v)
local c = PRESET[tostring(v)]
if c ~= nil and type(opts.Callback) == "function" then pcall(opts.Callback, c) end
end,
})
ok2 = true
end)
if ok2 then
pcall(function() F.Out("[UI] * " .. tag .. " / AddColorPicker 本执行器不支持 -> 已自动降级为「预设颜色下拉」") end)
return nil
end
end
F._uiFails = F._uiFails + 1
pcall(function() F.Out("[UI] * " .. tag .. " / " .. label .. " -> 建不出来(已跳过这一项, 其余照常): " .. tostring(res)) end)
return nil
end
return res
end
end)(t[nm], nm)
end
return setmetatable(p, { __index = function(_, kk) return t[kk] end })
end
do
local _keys = {}
local _k, _v
for _k, _ in pairs(Tabs) do _keys[#_keys + 1] = _k end
for _k = 1, #_keys do
_v = Tabs[_keys[_k]]
Tabs[_keys[_k]] = _safeTab(_v, _keys[_k])
end
end
do
Tabs.Combat:AddSection("自瞄")
Tabs.Combat:AddToggle("AimOn", { Title = "自瞄", Default = false, Callback = function(v)
if F._cfgSyncing then return end
F.AimSet(v, "手动")
if v then
pcall(function()
local op = Fluent and Fluent.Options and Fluent.Options.AutoFire
if op and op.Value ~= true then F.OptSet(op, true) end
end)
end
end })
Tabs.Combat:AddDropdown("CombatMode", { Title = "锁定模式", Values = {
"漏就锁(360°全身 · 只要打得到就锁)",
"正面圈内锁(只锁屏幕正面圈里的)",
}, Default = "漏就锁(360°全身 · 只要打得到就锁)", Callback = function(v)
C.CombatMode = tostring(v)
if F._cfgSyncing then return end
F.Out("[战斗] 锁定模式 = " .. tostring(v))
end })
Tabs.Combat:AddSlider("AimSmooth", { Title = "自瞄平滑", Min = 0, Max = 20, Default = 0, Rounding = 0, Callback = function(v)
C.AimSmooth = v
end })
Tabs.Combat:AddDropdown("AimPart", { Title = "瞄准点", Values = {
"最近部位(推荐 · 打得到哪就打哪)",
"头(爆头用 · 可能被墙挡住)",
"躯干(稳 · 几乎不会被挡)",
}, Default = "最近部位(推荐 · 打得到哪就打哪)", Callback = function(v)
C.AimPart = tostring(v)
if F._cfgSyncing then return end
F.Out("[战斗] 瞄准点 = " .. tostring(v))
end })
Tabs.Combat:AddSlider("CombatRange", { Title = "锁定距离", Min = 5, Max = 1000, Default = 200, Rounding = 0, Callback = function(v) C.CombatRange = v end })
Tabs.Combat:AddSlider("CombatFOV", { Title = "正面圈大小", Min = 50, Max = 1200, Default = 400, Rounding = 0, Callback = function(v) C.CombatFOV = v end })
Tabs.Combat:AddToggle("FovCircle", { Title = "自瞄 FOV 圈", Default = false, Callback = function(v)
T.FovCircle = v
if F._cfgSyncing then return end
if v then pcall(F.FovCircleEnable) else pcall(F.FovCircleDisable) end
end })
Tabs.Combat:AddToggle("CombatWallCheck", { Title = "不打隔墙", Default = true, Callback = function(v)
T.CombatWallCheck = v
if F._cfgSyncing then return end
F.Out("[战斗] 不打隔墙 = " .. (v and "开" or "关"))
end })
Tabs.Combat:AddToggle("CombatSkipInvincible", { Title = "不打无敌/出生保护的人", Default = true, Callback = function(v)
T.CombatSkipInvincible = v
if F._cfgSyncing then return end
F.Out("[战斗] 不打无敌/出生保护 = " .. (v and "开" or "关"))
end })
Tabs.Combat:AddDropdown("CombatPriority", { Title = "目标优先级", Values = {
"自动(跟随锁定模式 · 推荐)",
"距离最近",
"准心最近",
"血量最低",
"血量最高",
}, Default = "自动(跟随锁定模式 · 推荐)", Callback = function(v)
C.CombatPriority = tostring(v)
if F._cfgSyncing then return end
F.Out("[战斗] 目标优先级 = " .. tostring(v))
end })
Tabs.Combat:AddToggle("CombatTeamCheck", { Title = "不打队友", Default = false, Callback = function(v)
T.CombatTeamCheck = v
if F._cfgSyncing then return end
F.Out("[战斗] 不打队友 = " .. (v and "开(队伍相同的人不会锁)" or "关"))
end })
Tabs.Combat:AddToggle("AutoFire", { Title = "自动开火", Default = false, Callback = function(v)
T.AutoFire = v
if F._cfgSyncing then return end
F.Out("[战斗] 自动开火 = " .. (v and "开" or "关"))
if v then F.EnsureAimOn("开自动开火") end
end })
Tabs.Combat:AddSlider("AutoFireGap", { Title = "开火间隔", Min = 0.05, Max = 1, Default = 0.12, Rounding = 2, Callback = function(v) C.AutoFireGap = v end })
Tabs.Combat:AddDropdown("AimLockMode", { Title = "锁定方式", Values = {
"转身锁人(只转人物朝向 · 不碰你视角)",
"转视角(把相机也转过去 · 枪战用)",
}, Default = "转身锁人(只转人物朝向 · 不碰你视角)", Callback = function(v)
local cam = tostring(v):find("转视角", 1, true) ~= nil
T.AimTurnCamera, T.AimTurnBody = cam, (not cam)
if F._cfgSyncing then return end
F.Out("[战斗] 锁定方式 = " .. tostring(v))
end })
Tabs.Combat:AddToggle("BulletTrack", { Title = "子弹追踪", Default = false, Callback = function(v)
T.BulletTrack = v
if F._cfgSyncing then return end
if v then pcall(F.BulletTrackEnable) else pcall(F.BulletTrackDisable) end
end })
Tabs.Combat:AddToggle("NoRecoil", { Title = "无后坐力", Default = false, Callback = function(v)
T.NoRecoil = v
if F._cfgSyncing then return end
if v then pcall(F.NoRecoilEnable) else pcall(F.NoRecoilDisable) end
end })
Tabs.Combat:AddToggle("Pierce", { Title = "穿透弹", Default = false, Callback = function(v)
T.Pierce = v
if F._cfgSyncing then return end
if v then pcall(F.PierceEnable) else pcall(F.PierceDisable) end
end })
Tabs.Surv:AddSection("生命 / 保命")
Tabs.Surv:AddToggle("GodMode", { Title = "上帝模式", Default = false, Callback = function(v)
if F._cfgSyncing then return end
F.GodModeSet(v)
end })
Tabs.Surv:AddToggle("LockHealthSolo", { Title = "锁血", Default = false, Callback = function(v)
T.LockHealthSolo = v and true or false
if F._cfgSyncing then return end
pcall(F.LockHealthSoloSet, v)
end })
Tabs.Surv:AddToggle("AntiKnockdown", { Title = "防击倒", Default = false, Callback = function(v)
T.AntiKnockdown = v
if F._cfgSyncing then return end
if v then pcall(F.AntiKnockdownEnable) else pcall(F.AntiKnockdownDisable) end
end })
Tabs.Surv:AddToggle("Regen", { Title = "自动回血", Default = false, Callback = function(v)
T.Regen = v
if F._cfgSyncing then return end
if v then pcall(RegenEnable) else pcall(RegenDisable) end
end })
Tabs.Surv:AddSlider("RegenRate", { Title = "回血速度", Min = 1, Max = 500, Default = 10, Rounding = 0, Callback = function(v) C.RegenRate = v end })
Tabs.Surv:AddButton({ Title = "回满血", Callback = function()
if not F.Once("god_refill", 0.8) then return end
F.GodRefill()
end })
Tabs.Move:AddSection("飞行")
Tabs.Move:AddToggle("FlyOn", { Title = "飞行", Default = false, Callback = function(v) F.FlySet(v) end })
Tabs.Move:AddToggle("HeliOn", { Title = "旋转角色", Default = false, Callback = function(v) F.HeliSet(v) end })
Tabs.Move:AddDropdown("HeliMode", { Title = "旋转模式", Values = {
"不飞行转(站着自转 · 照常走路跳跃)",
"飞行转(横躺旋转 · 悬空/配飞行 · WASD移动)",
}, Default = "不飞行转(站着自转 · 照常走路跳跃)", Callback = function(v)
C.HeliMode = tostring(v)
if F._cfgSyncing then return end
if T.HeliOn then pcall(F.HeliSet, true) end
end })
Tabs.Move:AddDropdown("HeliAxis", { Title = "旋转轴", Values = {
"竖直轴(水平打转 · 推荐)",
"长轴(滚筒翻滚)",
"横轴(前后翻)",
}, Default = "竖直轴(水平打转 · 推荐)", Callback = function(v)
C.HeliAxis = tostring(v)
if F._cfgSyncing then return end
if T.HeliOn then pcall(F.HeliSet, true) end
end })
Tabs.Move:AddDropdown("HeliPivot", { Title = "支点", Values = {
"身体中心(原地自转 · 推荐)",
"头部(头定点 · 身体绕头画一圈)",
}, Default = "身体中心(原地自转 · 推荐)", Callback = function(v)
C.HeliPivot = tostring(v)
if F._cfgSyncing then return end
if T.HeliOn then pcall(F.HeliSet, true) end
end })
Tabs.Move:AddSlider("HeliSpin", { Title = "旋转 · 转速", Min = 30, Max = 30000, Default = 720, Rounding = 0, Callback = function(v) C.HeliSpin = v end })
Tabs.Move:AddSlider("HeliTilt", { Title = "旋转 · 倾角", Min = 0, Max = 90, Default = 90, Rounding = 0, Callback = function(v) C.HeliTilt = v end })
Tabs.Move:AddSlider("HeliHeight", { Title = "旋转 · 初始悬停高度", Min = 0, Max = 200, Default = 0, Rounding = 0, Callback = function(v) C.HeliHeight = v end })
F.SetSpeedValue = function(kind, n)
n = tonumber(n)
local op = Fluent and Fluent.Options
local o = op and op[(kind == "fly") and "FlyValue" or "SpeedValue"]
if not n then return end
local lo = (o and tonumber(o.Min)) or 0
local hi = (o and tonumber(o.Max)) or 5000
if n < lo then n = lo end
if n > hi then n = hi end
n = math.floor(n)
if kind == "fly" then
C.FlyValue = n
F.OptSet(o, n)
if T.FlyOn then pcall(function() F.FlySet(true) end) end
else
C.SpeedValue = n
F.OptSet(o, n)
if T.SpeedOn then pcall(F.SpeedApply) end
end
F._slInGuard = true
local ib = op and op[((kind == "fly") and "FlyValueIn" or "SpeedValueIn")]
F.OptSet(ib, tostring(n))
F._slInGuard = false
F.Out("[速度] " .. ((kind == "fly") and "飞行" or "加速") .. " 已设为 " .. tostring(n) .. " 格/秒 (范围 " .. tostring(math.floor(lo)) .. "~" .. tostring(math.floor(hi)) .. ")")
end
F.SyncSpeedInput = function(kind, v)
if F._slInGuard then return end
local op = Fluent and Fluent.Options
local ib = op and op[((kind == "fly") and "FlyValueIn" or "SpeedValueIn")]
if ib and ib.Set and tonumber(v) then
F._slInGuard = true
F.OptSet(ib, tostring(math.floor(tonumber(v))))
F._slInGuard = false
end
end
Tabs.Move:AddSlider("FlyValue", { Title = "飞行速度", Min = 16, Max = 5000, Default = 60, Rounding = 0, Callback = function(v) C.FlyValue = v F.SyncSpeedInput("fly", v) end })
Tabs.Move:AddInput("FlyValueIn", { Title = "飞行速度 · 直接输入数字", Default = "60", Placeholder = "例如 500", Numeric = true, Callback = function(v)
if F._slInGuard then return end
local n = tonumber(v)
if not n then return end
pcall(F.SetSpeedValue, "fly", n)
end })
F.SPEED_TIERS = {
{ 16, 5000 }, { 5001, 10000 }, { 10001, 15000 }, { 15001, 20000 }, { 20001, 25000 }, { 25001, 30000 },
}
F.SpeedTierApply = function(idx)
idx = tonumber(idx) or 1
if idx < 1 then idx = 1 end
if idx > #F.SPEED_TIERS then idx = #F.SPEED_TIERS end
local lo, hi = F.SPEED_TIERS[idx][1], F.SPEED_TIERS[idx][2]
local op = Fluent and Fluent.Options
local function rerange(opt)
if not (opt and type(opt) == "table") then return end
opt.Min, opt.Max = lo, hi
local cur = tonumber(opt.Value) or lo
if cur < lo then cur = lo end
if cur > hi then cur = hi end
F.OptSet(opt, cur)
end
if op then rerange(op.SpeedValue) rerange(op.FlyValue) end
local cur = tonumber(C.SpeedValue) or lo
if cur < lo then cur = lo end
if cur > hi then cur = hi end
C.SpeedValue, C.FlyValue = cur, cur
pcall(function() F.SyncSpeedInput("speed", cur) end)
pcall(function() F.SyncSpeedInput("fly", cur) end)
if T.SpeedOn then pcall(F.SpeedApply) end
if T.FlyOn then pcall(function() F.FlySet(true) end) end
F.Out("[速度档位] 档" .. tostring(idx) .. " ⇒ 滑块量程改成 " .. tostring(lo) .. "~" .. tostring(hi) .. " (飞行/加速共用), 当前值 " .. tostring(cur))
end
Tabs.Move:AddDropdown("SpeedTier", { Title = "速度档位", Values = {
"档1 (16-5000)", "档2 (5001-10000)", "档3 (10001-15000)", "档4 (15001-20000)", "档5 (20001-25000)", "档6 (25001-30000)",
}, Default = "档1 (16-5000)", Callback = function(v)
local idx = tonumber(tostring(v):match("档(%d)")) or 1
if F._cfgSyncing then return end
pcall(F.SpeedTierApply, idx)
end })
Tabs.Move:AddSection("加速")
Tabs.Move:AddToggle("SpeedOn", { Title = "加速", Default = false, Callback = function(v) F.SpeedSet(v) end })
Tabs.Move:AddButton({ Title = "本服检测 / 档位自检", Callback = function()
if not F.Once("riskcheck", 4) then return end
task.spawn(function()
local a, b = F.ScanClientChecks(true)
local lvl = ((a or 0) > 0) and 2 or (((b or 0) > 0) and 1 or 0)
F.Out("[档位自检] 检测等级=" .. tostring(lvl) .. " · 绕过档位=" .. tostring(T.BypassTier or "关")
.. " · 防护档位=" .. tostring(T.ACMaster or "关"))
if lvl == 0 then
F.Out("[档位自检] ⇒ 本服客户端没扫到防加速/拉回 ⇒ 加速/飞行可以放心用, 不需要开防护档(省性能)")
else
F.Out("[档位自检] ⇒ 本服有检测 ⇒ 建议先开「防护档位」②(反拉回+伪装), 仍被拉回再升 ③")
end
pcall(function() F.LogFlush("档位自检") end)
end)
end })
Tabs.Move:AddSlider("SpeedValue", { Title = "加速速度", Min = 16, Max = 5000, Default = 60, Rounding = 0, Callback = function(v) C.SpeedValue = v F.SyncSpeedInput("speed", v) if T.SpeedOn then F.SpeedApply() end end })
Tabs.Move:AddInput("SpeedValueIn", { Title = "加速速度 · 直接输入数字", Default = "60", Placeholder = "例如 500", Numeric = true, Callback = function(v)
if F._slInGuard then return end
local n = tonumber(v)
if not n then return end
pcall(F.SetSpeedValue, "speed", n)
end })
Tabs.Move:AddSection("防护")
Tabs.Move:AddToggle("GuardAll", { Title = "防护", Default = false, Callback = function(v)
T.GuardAll = v
T.SteadyOn, T.HitGuard, T.TrapWarn = v, v, v
T.SpeedAntiTP, T.MyEgg, T.CarryGuard = v, v, v
if F._cfgSyncing then return end
pcall(F.ProtectApply)
if v then
pcall(F.SpeedAntiTPEnable)
pcall(F.SpeedFreeEnable)
pcall(F.NoPullEnable)
pcall(F.MyEggSet, true)
pcall(F.CarryGuardEnable)
else
pcall(F.SpeedAntiTPDisable)
pcall(F.SpeedFreeDisable)
pcall(F.NoPullDisable)
pcall(F.MyEggSet, false)
pcall(F.CarryGuardDisable)
end
F.Out("[防护] 稳身/反攻击/反陷阱/反拉回/防减速/反回拉/护蛋/搬运保护 = " .. (v and "开" or "关"))
end })
F.ProtectApply = function()
local steady, hit = T.SteadyOn == true, T.HitGuard == true
if steady or hit then
F.Try("CharEventsEnable", F.CharEventsEnable)
F.Try("MetaHookEnsure", F.MetaHookEnsure)
else
F.Try("CharEventsDisable", F.CharEventsDisable)
end
if steady then pcall(F.SteadyEnable) else pcall(F.SteadyDisable) end
if hit then pcall(function() F.HitGuardEnable(T.HitStrong) end) else pcall(F.HitGuardDisable) end
if T.TrapWarn then
pcall(F.TrapGuardEnable)
pcall(F.TrapAutoRemoveEnable)
else
pcall(F.TrapGuardDisable)
pcall(F.TrapAutoRemoveDisable)
end
if T.SpeedAntiTP then pcall(F.SpeedAntiTPEnable) else pcall(F.SpeedAntiTPDisable) end
F.Out(string.format("[防护] 稳身=%s · 反攻击(受击保护)=%s · 反陷阱=%s · 防拉回=%s",
steady and "开" or "关",
hit and ("开" .. (T.HitStrong and "(猛档)" or "(状态法)")) or "关",
T.TrapWarn and "开" or "关", T.SpeedAntiTP and "开" or "关"))
end
Tabs.Move:AddToggle("InstantInteract", { Title = "瞬间偷蛋 / 瞬间交互", Default = false, Callback = function(v)
local changed = (T.InstantInteract ~= nil) and (T.InstantInteract ~= v)
T.InstantInteract = v
if F._cfgSyncing or not changed then return end
if v then F.InstantInteractEnable() else F.InstantInteractDisable() end
end })
Tabs.Move:AddToggle("Invisible", { Title = "隐身", Default = false, Callback = function(v)
T.Invisible = v
if F._cfgSyncing then return end
if v then F.InvisibleEnable() else F.InvisibleDisable() end
end })
Tabs.Move:AddSection("位移")
Tabs.Setting:AddButton({ Title = "自杀 / 重置角色", Callback = function() pcall(F.SuicideNow) end })
Tabs.Move:AddToggle("InfiniteJump", { Title = "无限跳", Default = false, Callback = function(v)
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
Tabs.Move:AddSlider("HideDepth", { Title = "藏地下 · 深度", Min = -60, Max = 60, Default = 5, Rounding = 0, Callback = function(v) C.HideDepth = v end })
Tabs.Move:AddToggle("WallClimb", { Title = "爬墙", Default = false, Callback = function(v)
T.WallClimb = v
if F._cfgSyncing then return end
if v then pcall(F.WallClimbEnable) else pcall(F.WallClimbDisable) end
end })
Tabs.Move:AddSlider("WallClimbSpeed", { Title = "爬墙速度", Min = 5, Max = 300, Default = 50, Rounding = 0, Callback = function(v) C.WallClimbSpeed = v end })
end
do
Tabs.Visual:AddSection("ESP 透视")
Tabs.Visual:AddToggle("EspOn", { Title = "ESP 总开关", Default = false, Callback = function(v)
T.EspOn = v
if F._cfgSyncing then return end
F.EspSet(v)
end })
Tabs.Visual:AddToggle("EspName", { Title = "名字", Default = true, Callback = function(v) T.EspName = v end })
Tabs.Visual:AddToggle("EspDist", { Title = "距离", Default = true, Callback = function(v) T.EspDist = v end })
Tabs.Visual:AddToggle("EspHp", { Title = "血条", Default = true, Callback = function(v) T.EspHp = v end })
Tabs.Visual:AddToggle("AllyMark", { Title = "队友标记", Default = false, Callback = function(v)
if F._cfgSyncing then return end
F.AllyMarkSet(v)
end })
Tabs.Visual:AddSection("屏幕")
Tabs.Visual:AddToggle("NoScreenFx", { Title = "关屏幕特效", Default = false, Callback = function(v)
T.NoScreenFx = v and true or false
if F._cfgSyncing then return end
pcall(F.ScrFxSet, v)
end })
Tabs.Visual:AddSection("高亮 / 敌我识别")
Tabs.Visual:AddToggle("BodyHL", { Title = "身体高亮透视", Default = false, Callback = function(v)
T.BodyHL = v
if F._cfgSyncing then return end
if v then F.BodyHLEnable() else F.BodyHLDisable() end
F.Out("[高亮] 身体高亮 = " .. (v and "开(隔墙可见 · 队友绿/敌人红看下面的敌我识别)" or "关"))
end })
Tabs.Visual:AddToggle("TeamColorHL", { Title = "敌我识别", Default = false, Callback = function(v)
T.TeamColorHL = v
if F._cfgSyncing then return end
if T.BodyHL then F.BodyHLRefresh() end
F.Out("[高亮] 敌我识别 = " .. (v and "开(队友绿 / 敌人红)" or "关(统一蓝色)"))
end })
Tabs.Visual:AddToggle("IxHL", { Title = "高亮透视", Default = false, Callback = function(v)
T.IxHL = v
if F._cfgSyncing and v then return end
F.IxHLSet(v)
end })
Tabs.Visual:AddSlider("IxRange", { Title = "高亮透视 · 范围", Min = 50, Max = 3000, Default = 300, Rounding = 0, Callback = function(v)
C.IxRange = v
if F._cfgSyncing then return end
if T.IxHL then pcall(F.IxScan) end
end })
Tabs.Visual:AddDropdown("IxScope", { Title = "高亮透视 · 范围模式", Values = { "附近范围", "全图" }, Default = "附近范围", Callback = function(v)
C.IxScope = v
if F._cfgSyncing then return end
if T.IxHL then pcall(F.IxScan) end
end })
Tabs.Visual:AddSlider("IxGap", { Title = "高亮透视 · 重扫间隔", Min = 0.5, Max = 10, Default = 2, Rounding = 1, Callback = function(v)
C.IxGap = v
if F._cfgSyncing then return end
if T.IxHL then pcall(F.IxScan) end
end })
Tabs.Visual:AddSection("穿墙透视")
Tabs.Visual:AddToggle("XRay", { Title = "穿墙透视", Default = false, Callback = function(v)
T.XRay = v
if F._cfgSyncing then return end
F.XRaySet(v)
end })
Tabs.World:AddSection("画面 / 声音")
Tabs.World:AddToggle("VisionBoost", { Title = "夜视", Default = false, Callback = function(v)
T.FullBright = v T.NightVision = v T.NoFog = v
if F._cfgSyncing then return end
if v then F.FullBrightEnable() F.NightVisionEnable() F.NoFogEnable() pcall(F.LightWatchEnable)
else F.FullBrightDisable() F.NightVisionDisable() F.NoFogDisable() pcall(F.LightWatchDisable) end
F.Out("[夜视] 全亮/夜视/去雾/光照守卫 = " .. (v and "开" or "关"))
end })
Tabs.World:AddToggle("ViewBoost", { Title = "视角增强", Default = false, Callback = function(v)
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
Tabs.World:AddSection("角色识别")
Tabs.World:AddToggle("RoleTag", { Title = "头顶标记", Default = false, Callback = function(v)
T.RoleTag = v
if F._cfgSyncing then return end
F.RoleTagSet(v)
end })
Tabs.World:AddSection("HUD / 准星")
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
Tabs.World:AddDropdown("CrosshairStyle", { Title = "准星样式", Values = { "十字(默认)", "点(小圆点)", "圆(空心圈)" }, Default = "十字(默认)", Callback = function(v)
C.CrosshairStyle = tostring(v)
if F._cfgSyncing then return end
if T.Crosshair then pcall(F.CrosshairDisable) pcall(F.CrosshairEnable) end
end })
Tabs.World:AddSlider("CrosshairSize", { Title = "准星大小", Min = 6, Max = 40, Default = 14, Rounding = 0, Callback = function(v)
C.CrosshairSize = v
if F._cfgSyncing then return end
if T.Crosshair then pcall(F.CrosshairDisable) pcall(F.CrosshairEnable) end
end })
Tabs.World:AddColorPicker("CrosshairColor", { Title = "准星颜色", Default = Color3.fromRGB(0, 255, 120), Callback = function(v)
C.CrosshairColor = v
if F._cfgSyncing then return end
if T.Crosshair then pcall(F.CrosshairDisable) pcall(F.CrosshairEnable) end
end })
end
do
Tabs.TP:AddSection("传送")
Tabs.TP:AddButton({ Title = "传送到出生点", Callback = function()
task.spawn(function() pcall(F.SpawnTP) end)
end })
Tabs.TP:AddDropdown("TPTarget", { Title = "目标玩家", Values = F.PlayerNames(), Default = nil })
Tabs.TP:AddButton({ Title = "传送到目标", Callback = function()
local name = Fluent.Options.TPTarget and Fluent.Options.TPTarget.Value
if not name then F.Out("[传送] 先在左边「目标玩家」里选一个人") return end
local pl = Players:FindFirstChild(tostring(name))
if not pl then F.Out("[传送] 找不到「" .. tostring(name) .. "」(可能已离开)") return end
task.spawn(function() pcall(TeleportToPlayer, pl) end)
end })
Tabs.TP:AddToggle("ClickTP", { Title = "点击传送", Default = false, Callback = function(v)
T.ClickTP = v
if F._cfgSyncing then return end
if v then pcall(F.ClickTPEnable) else pcall(F.ClickTPDisable) end
end })
Tabs.TP:AddSection("世界 (World · 同 place 内的区域)")
Tabs.TP:AddDropdown("WorldPick", { Title = "目标世界", Values = F.WorldLabels(), Default = nil })
Tabs.TP:AddToggle("WorldAttrSync", { Title = "换世界时同时改本地世界属性", Default = false, Callback = function(v)
C.WorldAttrSync = v
end })
Tabs.TP:AddButton({ Title = "扫描世界结构", Callback = function()
task.spawn(function() pcall(F.WorldDiag) end)
end })
Tabs.TP:AddButton({ Title = "去这个世界", Callback = function()
local pick = Fluent.Options.WorldPick and Fluent.Options.WorldPick.Value
task.spawn(function() pcall(F.WorldGoto, pick) end)
end })
Tabs.TP:AddButton({ Title = "用录到的命令换世界", Callback = function()
local pick = Fluent.Options.WorldPick and Fluent.Options.WorldPick.Value
task.spawn(function() pcall(F.WorldCmd, pick) end)
end })
Tabs.TP:AddSection("针对玩家")
Tabs.TP:AddButton({ Title = "把他甩飞", Callback = function()
task.spawn(function() pcall(F.FlingPlayer) end)
end })
Tabs.TP:AddToggle("LoopFling", { Title = "循环甩飞", Default = false, Callback = function(v)
T.LoopFling = v
if F._cfgSyncing then return end
if v then pcall(F.FlingLoopStart) else pcall(F.FlingLoopStop) end
end })
Tabs.TP:AddButton({ Title = "甩飞所有人", Callback = function()
task.spawn(function() pcall(F.FlingAll) end)
end })
Tabs.TP:AddSlider("FlingInterval", { Title = "甩飞间隔", Min = 0.3, Max = 5, Default = 1.5, Rounding = 1, Callback = function(v) C.FlingInterval = v end })
Tabs.TP:AddSection("收藏点位")
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
Tabs.AFK:AddSection("挂机防踢")
Tabs.AFK:AddToggle("AFKKickGuard", { Title = "挂机防踢", Default = true, Callback = function(v)
T.AntiAFK = v
if F._cfgSyncing then return end
if v then F.Try("AntiAFKEnable", F.AntiAFKEnable) else pcall(F.AntiAFKDisable) end
end })
Tabs.AFK:AddSection("自动化")
Tabs.AFK:AddToggle("AutoTrain", { Title = "自动锻炼", Default = false, Callback = function(v)
T.AutoTrain = v
if F._cfgSyncing then return end
if v then F.AutoTrainEnable() else F.AutoTrainDisable() end
end })
Tabs.AFK:AddToggle("AutoBonus", { Title = "自动领取锻炼奖励", Default = false, Callback = function(v)
T.AutoBonus = v
if F._cfgSyncing then return end
if v then F.AutoBonusEnable() else F.AutoBonusDisable() end
end })
Tabs.AFK:AddToggle("AutoGym", { Title = "自动传送健身房", Default = false, Callback = function(v)
T.AutoGym = v
if F._cfgSyncing then return end
if v then F.AutoGymEnable() else F.AutoGymDisable() end
end })
Tabs.AFK:AddSection("脑红")
Tabs.AFK:AddButton({ Title = "收起脑红", Callback = function()
if not F.Once("withdrawall", 2) then return end
task.spawn(function() pcall(F.WithdrawAll, 30) end)
end })
Tabs.AFK:AddButton({ Title = "收集货币", Callback = function()
if not F.Once("collectall", 3) then return end
task.spawn(function() pcall(F.CollectAll, 30) end)
end })
Tabs.Trans:AddSection("① 界面翻译(游戏 UI 英文 → 中文)")
Tabs.Trans:AddToggle("Translate", { Title = "翻译游戏界面文字 → 中文", Default = false, Callback = function(v)
if F._cfgSyncing then return end
if v then F.TranslateEnable() else F.TranslateDisable() end
end })
Tabs.Trans:AddToggle("TransModel", { Title = "连本地模型实时翻译新词", Default = false, Callback = function(v)
T.TransModel = v and true or false
if F._cfgSyncing then return end
if T.Translate then pcall(Trans.ApplyMode, false) end
end })
local transStatBtn = Tabs.Trans:AddButton({ Title = "状态: 等待开启", Callback = function()
task.spawn(function() pcall(Trans.Stats) end)
end })
task.spawn(function()
while true do
task.wait(2)
if transStatBtn and transStatBtn.SetTitle then
pcall(function()
if Trans.IsMobile then
transStatBtn:SetTitle(string.format("📱 云缓存 · 已汉化 %d · 本服 %d 条 · 已保存 %d 次", Trans._cnt or 0, Trans.OwnedCount(), Trans._saveCount or 0))
elseif T.TransModel ~= true then
transStatBtn:SetTitle(string.format("📄 缓存汉化 · 已汉化 %d · 本服 %d 条 · 已保存 %d 次", Trans._cnt or 0, Trans.OwnedCount(), Trans._saveCount or 0))
elseif Trans._ready then
transStatBtn:SetTitle(string.format("✅ 待翻译 %d · 已翻译 %d · 本服 %d 条",
#(Trans.Queue or {}), Trans._cnt or 0, Trans.OwnedCount()))
else
transStatBtn:SetTitle(string.format("📄 模型没连 · 先用缓存(已汉化 %d · 本服 %d 条) · 起来自动翻新词", Trans._cnt or 0, Trans.OwnedCount()))
end
end)
end
end
end)
Tabs.Trans:AddButton({ Title = "扫描界面", Callback = function()
Trans._diagOnce = nil
task.spawn(function()
local ok, err = pcall(Trans.Scan)
if ok then
F.Out("[翻译] 已重新扫描界面: 登记 " .. tostring(Trans.RegCount()) .. " 个控件 · 待翻 " .. tostring(#(Trans.Queue or {})))
else
F.Out("[翻译] 重新扫描失败: " .. tostring(err))
end
end)
end })
Tabs.Trans:AddButton({ Title = "保存缓存", Callback = function()
task.spawn(function()
local ok = pcall(Trans.Flush)
if ok and not Trans._lastErr then
F.Out("[翻译] 缓存已手动保存 ⇒ " .. tostring(Trans.CurFile()) .. " (" .. tostring(Trans.Count()) .. " 条)")
else
F.Out("[翻译] 缓存保存失败: " .. tostring(Trans._lastErr or "未知原因"))
end
end)
end })
Tabs.Trans:AddButton({ Title = "清空当前服缓存", Callback = function()
task.spawn(function() pcall(Trans.ClearCurrent) end)
end })
Tabs.Trans:AddButton({ Title = "清空全部缓存", Callback = function()
task.spawn(function() pcall(Trans.ClearAll) end)
end })
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
pcall(function() T.CMX_AntiBanAll = false T.CMX_FakeReport = false F.CMX_BanAllApply(false) T.CMX_InboundWatch = false F.CMX_InboundWatchSet(false) end)
pcall(function() T.BypassTier = "关(什么都不开)" F.BypassTierApply(T.BypassTier) end)
pcall(function() T.ACWriteTier = "① 不改游戏(现状: 反甩 + 护界面 + 权限守卫)" F.ACWriteTierApply(T.ACWriteTier) end)
if lvl < 2 and F._tierSpoofOwn then
F._tierSpoofOwn = nil
pcall(F.SpoofPosSet, false)
F.Out("[防护档位] 已收回档位自己开的「位置上报伪造」")
end
if lvl == 0 then
T.AntiFling = false T.GuiProtect = false
pcall(F.GuiProtectionDisable)
T.CMX_SpoofIndex = false
pcall(F.CMX_SpoofIndexDisable)
if F._tierHpOwn then
F._tierHpOwn = nil
T.HpBlock, T.HealthIsolate = false, false
pcall(F.HealthIsolateSet, false)
F.Out("[防护档位] 已收回档位自己开的「血量隔离 + 拦受伤上报」")
end
pcall(AC.AntiPauseDisable)
if F._tierGuardOwn then
F._tierGuardOwn = nil
T.GuardAll, T.MyEgg, T.CarryGuard, T.SpeedFree = false, false, false, false
pcall(F.MyEggSet, false)
pcall(F.CarryGuardDisable)
pcall(F.SpeedFreeDisable)
F.Out("[防护档位] 已收回档位自己开的「完整防护」")
end
pcall(F.LockFieldsUninstall)
pcall(F.MetaHookUninstall)
if F._tierGbypOwn then
F._tierGbypOwn = nil
pcall(F.GameBypassSet, false)
F.Out("[防护档位] 已收回档位自己开的「游戏专用绕过」")
end
if T.HealthIsolate and not F.MetaActive("game.__index", "CMHealthLock") then pcall(F.HealthIsolateSet, true) end
pcall(F.CfgSyncUI)
F.Out("[防护档位] 已关 —— 档位自己装的钩子已卸; 你手动开的(血量隔离/锁血/无敌等)保持不动")
pcall(function() Fluent:Notify({ Title = "防护档位", Content = "已全部关闭", Duration = 4 }) end)
return
end
T.AntiFling = true T.GuiProtect = true T.CharPersist = true
F.Try("AntiFlingEnable", F.AntiFlingEnable)
pcall(F.AuthorityGuard, true)
F.Try("GuiProtectionEnable", F.GuiProtectionEnable)
F.Try("CharPersistEnable", F.CharPersistEnable)
if lvl >= 2 then
T.CMX_AntiBanAll = true
pcall(F.CMX_InboundWatchSet, true)
pcall(AC.InstallNamecallHook)
pcall(F.CMX_BanAllApply, true)
if not (T.HpBlock and T.HealthIsolate) then F._tierHpOwn = true end
T.HpBlock, T.HealthIsolate = true, true
pcall(F.HealthIsolateSet, true)
pcall(F.HpBlockSet, true)
pcall(AC.AntiPauseEnable)
F.Try("LockFieldsInstall", F.LockFieldsInstall)
if T.GameBypass ~= true then F._tierGbypOwn = true end
pcall(F.GameBypassSet, true)
if T.SpoofPos ~= true then F._tierSpoofOwn = true end
pcall(F.SpoofPosSet, true)
end
if lvl >= 3 then
T.CMX_FakeReport = true
T.ACWriteTier = "③ 元表钩全装(__namecall/__index/setmetatable) + 新脚本新远程监视 + 断可疑连接 + 深度中和(按名中和检测函数) + 游戏专用绕过"
pcall(F.ACWriteTierApply, T.ACWriteTier)
T.BypassTier = "④ 绕过层全开: 防护(稳身·受击·陷阱) + 速度守卫 + 读原值伪装 + 抢所有权 + 钉位 + 防拉回(清检测脚本) + 深度中和"
pcall(F.BypassTierApply, T.BypassTier)
if not T.GuardAll then F._tierGuardOwn = true end
T.GuardAll = true
T.MyEgg, T.CarryGuard, T.SpeedFree = true, true, true
pcall(F.MyEggSet, true)
pcall(F.CarryGuardEnable)
pcall(F.SpeedFreeEnable)
F.Try("LockFieldsInstall", F.LockFieldsInstall)
end
if T.HealthIsolate and not F.MetaActive("game.__index", "CMHealthLock") then pcall(F.HealthIsolateSet, true) end
pcall(F.CfgSyncUI)
F.Out("[防护档位] = " .. v)
pcall(function() Fluent:Notify({ Title = "防护档位", Content = v, Duration = 6 }) end)
end
Tabs.AC:AddDropdown("ACMaster", { Title = "防护档位", Values = {
"关(什么都不开)",
"① 轻 · 只读不改: 反甩 + 护界面 + 权限守卫 + 角色持续 + 属性读伪装(健康/速度/gcinfo 读出来都是正常值)",
"② 中 · ①全部 + namecall 元表钩 + 反封禁4层(拦上报/断错误日志/按名中和+/哈希冻结) + 血量隔离(读伪装+断本地血量监听) + 拦受伤死亡上报 + 锁字段 + 防暂停 + 服务端下发预警 + 游戏专用绕过 + 位置上报伪造(上报坐标冻结在开档位那一刻)",
"③ 重 · ②全部 + 元表钩全装(__index/setmetatable) + 新脚本新远程监视 + 断可疑连接 + 深度中和 + 完整防护(稳身/受击/陷阱/防减速/护蛋/搬运) + 绕过层(速度守卫/读原值伪装/抢所有权/钉位/防拉回) + 假上报(异常数值改回正常再发) + 游戏专用绕过 ⇒ 最激进",
}, Default = "关(什么都不开)", Callback = function(v)
T.ACMaster = v
if F._cfgSyncing then return end
pcall(F.ProtectTierApply, v)
end })
Tabs.AC:AddButton({ Title = "扫描本服绕过目标", Callback = function()
local n = 0
pcall(function() n = F.GameBypassScan() end)
F.Out("[游戏专用绕过] 扫描完成: 「检测/上报类」远程 " .. tostring(n) .. " 个 · 档位②/③会自动拦这些")
end })
Tabs.AC:AddSection("扫描")
Tabs.AC:AddButton({ Title = "一键全扫描", Callback = function()
if not F.Once("scanall", 6) then return end
task.spawn(function()
pcall(F.CMX_ScanAll)
Fluent:Notify({ Title = "全扫描完成", Content = "结果已写入日志文件, 直接发给我就行", Duration = 8 })
end)
end })
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
if F._fusing then
if not quiet then F.Out("【熔断】已有一次熔断在进行中 ⇒ 跳过这一次重复的(避免连续两次卸/装元表)") end
return
end
F._fusing = true
if not quiet then F.Out("【熔断】① 开始卸掉所有钩子") end
local steps = {
function() for slot, bucket in pairs(F.MetaLayers or {}) do for id in pairs(bucket) do pcall(F.MetaUninstall, slot, id) end end end,
function() pcall(F.KickGuardPathsDisable) end,
function() pcall(AC.UninstallNamecallHook) end,
function() pcall(AC.UninstallIndexMask) end,
function() pcall(AC.UninstallSetmetatableHook) end,
function() pcall(AC.UninstallAntiTP) end,
function() pcall(AC.WatchNewScriptsDisable) end,
function() pcall(AC.WatchNewRemotesDisable) end,
function() pcall(AC.AntiPauseDisable) end,
function() pcall(F.CMX_SpoofIndexDisable) end,
function() pcall(F.CMX_NeuterPlusDisable) end,
function() pcall(F.CMX_HashFreezeDisable) end,
function() pcall(F.CMX_BlockReportDisable) end,
function() pcall(F.CMX_CutLogDisable) end,
function() pcall(F.DeepNeuterDisable) end,
function() T.CMX_FakeReport = false end,
function() pcall(F.CMX_InboundWatchSet, false) end,
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
F._fusing = false
end
Tabs.Setting:AddSection("系统")
F.UnloadAll = UnloadAll
Tabs.Setting:AddButton({ Title = "热加载", Callback = function()
if not F.Once("reload", 6) then return end
F.HotReload(false)
end })
Tabs.Setting:AddButton({ Title = "强制重载", Callback = function()
if not F.Once("reloadforce", 3) then return end
F.HotReload(true)
end })
Tabs.Setting:AddButton({ Title = "重新进入服务器", Callback = function()
if not F.Once("rejoin", 6) then return end
F.RejoinNow()
end })
Tabs.Setting:AddButton({ Title = "一键全关", Callback = function()
if not F.Once("alloff", 2) then return end
pcall(F.PanicKeyDisableAll)
end })
Tabs.Setting:AddButton({ Title = "卸载脚本", Callback = function()
if not F.Once("unload", 4) then return end
pcall(function() Fluent:Notify({ Title = "卸载", Content = "正在卸载…界面会消失; 日志里会有 [卸载] 复核结果", Duration = 2 }) end)
task.defer(function()
pcall(F.UnloadAll)
pcall(function() F.LogFlush("卸载") end)
end)
end })
pcall(F.RecordOriginals)
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
local vw, vh = 0, 0
pcall(function()
local cam = workspace.CurrentCamera
if cam and cam.ViewportSize.X > 0 then vw, vh = cam.ViewportSize.X, cam.ViewportSize.Y end
end)
local minSide = math.min(vw, vh)
local isPhone = (vw < 760) or (vh < 500) or (UIS.TouchEnabled and minSide <= 720)
F.Out(string.format("[环境] 执行器=%s · 平台=%s · 布局=%s · 视口=%dx%d · loadstring=%s · writefile=%s · gethui=%s",
ex, (UIS.TouchEnabled and "触屏(手机/平板)" or "键鼠(PC)"), (isPhone and "手机" or "桌面"), vw, vh,
type(loadstring), type(writefile), type(gethui)))
end)
pcall(function() if UIS.TouchEnabled and UIS.MouseIconEnabled then UIS.MouseIconEnabled = false end end)
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
local _polishCache, _polishAt, _polishState = nil, 0, setmetatable({}, { __mode = "k" })
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
_polishState = setmetatable({}, { __mode = "k" })
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
if _polishState[obj] ~= isOn then
_polishState[obj] = isOn
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
end
local function startTogglePolish()
if getgenv and getgenv().CM_TogglePolish then return end
if getgenv then getgenv().CM_TogglePolish = true end
local gvTP = (type(getgenv) == "function") and getgenv() or nil
if type(gvTP) ~= "table" then gvTP = nil end
task.spawn(function()
while gvTP == nil or gvTP.CM_TogglePolish do
pcall(polishToggleVisuals)
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
pcall(function()
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
btnStart = btn.Position
end
end)
end)
UIS.InputChanged:Connect(function(input)
pcall(function()
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
btn.Position = UDim2.new(btnStart.X.Scale, btnStart.X.Offset + delta.X, btnStart.Y.Scale, btnStart.Y.Offset + delta.Y)
end
end)
end)
UIS.InputEnded:Connect(function(input)
pcall(function()
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = false
end
end)
end)
btn.MouseButton1Click:Connect(function()
pcall(function()
local w = Window or (getgenv and getgenv().CM_Window)
local gui = w and w.escmenu
if gui then gui.Visible = not gui.Visible
elseif w and w.Minimize then w:Minimize() end
end)
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
local _bt0 = os.clock()
local okBuild, buildErr = pcall(buildMenu)
F.Out(string.format("[CheatMenu] 菜单构建耗时 %.2f 秒", os.clock() - _bt0))
F._cfgSyncing = false
if not okBuild then
F.Out("[UI] ⚠ 菜单构建中断 ⇒ 断点之后的控件全都没建出来! 原因: " .. tostring(buildErr))
F.Out("[UI] 把上面这一行发出来, 就能立刻定位是哪个控件把菜单带塌的")
elseif (F._uiFails or 0) > 0 then
F.Out("[UI] ⚠ 有 " .. tostring(F._uiFails) .. " 个控件没建出来(已逐个跳过, 其余功能正常) - 把带 * 的几行发我即可定位")
end
task.defer(function() F._cfgSyncing = false end)
local gvMW = (type(getgenv) == "function") and getgenv() or nil
if type(gvMW) ~= "table" then gvMW = nil end
if gvMW == nil or not gvMW.CM_MenuWatch then
if gvMW then gvMW.CM_MenuWatch = true end
task.spawn(function()
local wasOpen = F.MenuOpen()
while gvMW == nil or gvMW.CM_MenuWatch do
task.wait(0.25)
local now = F.MenuOpen()
if wasOpen and not now then pcall(F.CloseDropdowns) end
wasOpen = now
end
end)
end
F.CFG_NOSYNC = { AimOn = true }
F.CFG_APPLY_SKIP = {}
F.ApplySavedOn = function(quiet)
if F._applyingSaved then return 0 end
F._applyingSaved = true
local op = Fluent and Fluent.Options
local applied, failed, names = 0, {}, {}
if type(op) == "table" then
pcall(function()
for name, opt in pairs(op) do
if type(name) == "string" and type(opt) == "table" and type(opt.Set) == "function" then
local skip = (F.CFG_NOSYNC[name] == true) or (F.CFG_APPLY_SKIP[name] == true)
if not skip then
for _, k in ipairs(F.PLAYER_DROPDOWNS) do if k == name then skip = true break end end
end
if not skip then
local ty = opt.Type
if type(ty) ~= "string" then
if type(opt.Value) == "boolean" then ty = "Toggle"
elseif type(opt.Value) == "number" then ty = "Slider"
elseif type(opt.Value) == "table" then ty = "Dropdown"
elseif type(opt.Value) == "string" then ty = "Input" end
end
local want = (ty == "Toggle") and T[name] or C[name]
if want == nil then want = T[name] end
local go = (want == true)
if not go and type(want) == "string" and want ~= "" and string.sub(want, 1, 3) ~= "关" then go = true end
if go then
local cb = opt.Callback
if type(cb) ~= "function" then cb = opt.callback end
local ok = false
if type(cb) == "function" then
ok = pcall(cb, want)
else
if type(want) == "boolean" then F.OptSet(opt, not want) end
ok = F.OptSet(opt, want)
end
if ok then
applied = applied + 1
if #names < 14 then names[#names + 1] = name end
else
failed[#failed + 1] = name
end
end
end
end
end
end)
end
F._applyingSaved = false
if not quiet then
F.Out("[加载] 已把上次开着的 " .. tostring(applied) .. " 个功能真正装好"
.. ((#names > 0) and (" [" .. table.concat(names, ", ") .. "]") or "")
.. ((#failed > 0) and (" · ⚠ 有 " .. tostring(#failed) .. " 个没装上: " .. table.concat(failed, ", ")) or ""))
end
return applied
end
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
if ok and F.OptSet(opt, want) then n = n + 1 end
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
if C.IxRange == nil then C.IxRange = 300 end
if C.IxGap == nil then C.IxGap = 2 end
if C.IxScope == nil then C.IxScope = "附近范围" end
local n = F.CfgSyncUI()
pcall(F.SyncMoveUI)
if n and n > 0 then F.Out("[CheatMenu] 已按存档同步 " .. n .. " 个控件的界面状态") end
pcall(F.ApplySavedOn)
pcall(function()
local keep = getgenv and getgenv().CM_RELOAD_KEEP
if type(keep) ~= "table" then return end
getgenv().CM_RELOAD_KEEP = nil
local c = 0
local op2 = Fluent and Fluent.Options
for k, v in pairs(keep) do
if v == true then
T[k] = true
c = c + 1
local opt = nil
pcall(function() opt = op2 and op2[k] end)
if opt ~= nil then pcall(F.OptSet, opt, true) end
end
end
local n2 = F.CfgSyncUI()
F.Out("[热加载] 已恢复上次开着的 " .. tostring(c) .. " 个开关 (界面同步 " .. tostring(n2) .. " 个)")
pcall(F.ApplySavedOn)
end)
end)
end)
F.Try("AntiAFKEnable", F.AntiAFKEnable)
F.Out("[挂机防踢] 已自动开启(通用防挂机 · 无元表钩子)")
F.Try("LivePlayersEnable", F.LivePlayersEnable)
pcall(F.CacheSync)
F.PerfCheck = function()
local on = {}
for k, v in pairs(T) do
if v == true and type(k) == "string" then on[#on + 1] = k end
end
table.sort(on)
local hb, rsc, stc = -1, -1, -1
pcall(function() if type(getconnections) == "function" then hb = #getconnections(RS.Heartbeat) end end)
pcall(function() if type(getconnections) == "function" then rsc = #getconnections(RS.RenderStepped) end end)
pcall(function() if type(getconnections) == "function" then stc = #getconnections(RS.Stepped) end end)
local layers = {}
pcall(function()
if type(F.MetaLayers) == "table" then
for slot, bucket in pairs(F.MetaLayers) do
local n = 0
for _ in pairs(bucket) do n = n + 1 end
if n > 0 then layers[#layers + 1] = tostring(slot) .. "×" .. tostring(n) end
end
end
end)
local frames = 0
local conn = nil
pcall(function() conn = RS.RenderStepped:Connect(function() frames = frames + 1 end) end)
task.wait(1)
if conn then pcall(function() conn:Disconnect() end) end
F.Out("[性能体检] 实测 FPS≈" .. tostring(frames) .. " · 每帧连接 Heartbeat=" .. tostring(hb)
.. " RenderStepped=" .. tostring(rsc) .. " Stepped=" .. tostring(stc))
F.Out("[性能体检] 元表钩子层数: " .. ((#layers > 0) and table.concat(layers, " ") or "无")
.. " (每多一层, 游戏每次访问 game 都要多穿一次 Lua)")
F.Out("[性能体检] 当前开着的功能 " .. tostring(#on) .. " 个: " .. table.concat(on, ", "))
if T.TransModel == true then
F.Out("[性能体检] ⚠ 开着「连本地模型」—— 本地模型跑在你这块显卡上, 和游戏抢 GPU, 是最容易掉帧的一项")
end
if #layers >= 3 then
F.Out("[性能体检] ⚠ 元表钩子叠了 " .. tostring(#layers) .. " 组 —— 层数越多每次 game 访问越慢, 不玩某项时关掉它最有效")
end
end
task.delay(12, function() pcall(F.PerfCheck) end)
