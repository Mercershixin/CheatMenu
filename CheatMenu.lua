print(('[CheatMenu] build 2026-09-28 12:02 sha bbd01c01 bytes 143973'):format('2026-09-28 12:02','bbd01c01',143973))
print("[CheatMenu] ===== 加载开始 · v5.0.3 =====")
local Players  = game:GetService("Players")
local RS       = game:GetService("RunService")
local UIS      = game:GetService("UserInputService")
local HS       = game:GetService("HttpService")
local CS       = game:GetService("CollectionService")
local RStorage = game:GetService("ReplicatedStorage")
local WS       = game:GetService("Workspace")
local TS       = game:GetService("TweenService")
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
local function GC()
local ch = LP.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
local root = hum and ch:FindFirstChild("HumanoidRootPart")
return ch, hum, root
end
local function Notify(text, color)
pcall(function()
local sg = game:GetService("StarterGui")
sg:SetCore("SendNotification", { Title = "CheatMenu", Text = tostring(text), Duration = 4 })
end)
end
local RRemoteCache = {}
local function findRemote(name, cls)
local ck = cls .. "\1" .. name
if RRemoteCache[ck] then return RRemoteCache[ck] end
local function ok2(o)
return (o and o:IsA(cls) and o.Name == name) and o or nil
end
local function tryNetRoot()
local sh = RStorage:FindFirstChild("Shared")
local pk = sh and sh:FindFirstChild("Packages")
local net = pk and pk:FindFirstChild("Network")
if not net then return nil end
local pre = (cls == "RemoteEvent") and "rev_" or "ref_"
return ok2(net:FindFirstChild(pre .. name))
or ok2(net:FindFirstChild(pre .. tostring(name):gsub("%.", "_")))
end
local r = tryNetRoot()
if r then RRemoteCache[ck] = r return r end
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
if c:IsA("Folder") or c:IsA("Configuration") then
qt = qt + 1 q[qt] = c
end
end
end
end
return nil
end
local function REvent(n)    return findRemote(n, "RemoteEvent") end
local function RFunction(n) return findRemote(n, "RemoteFunction") end
local function Fire(n, ...)
local r = REvent(n)
if not r then return false end
pcall(function(...) r:FireServer(...) end, ...)
return true
end
local function OnRemote(n, cb)
local r = REvent(n)
if r then
pcall(function()
r.OnClientEvent:Connect(function(...)
pcall(cb, ...)
end)
end)
end
end
local SaveFile = "CheatMenu_Config_v1.json"
local function SaveConfig()
pcall(function()
if writefile then writefile(SaveFile, HS:JSONEncode({ T = T, C = C })) end
end)
end
local function LoadConfig()
pcall(function()
if not readfile or not isfile or not isfile(SaveFile) then return end
local raw = readfile(SaveFile)
local d = HS:JSONDecode(raw)
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
"https://gh-proxy.com/https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://cdn.jsdelivr.net/gh/dawid-scripts/Fluent@master/main.lua",
}
for _, url in ipairs(FLUENT_SOURCES) do
local ok, body = pcall(function() return game:HttpGet(url) end)
if ok and type(body) == "string" and #body > 5000 then
local ok2, chunk = pcall(loadstring, body)
if ok2 and chunk then
local ok3, loaded = pcall(chunk)
if ok3 and loaded then
Fluent = loaded
print("[CheatMenu] Fluent 加载成功 <- " .. url)
break
end
end
end
end
if not Fluent then
error("[CheatMenu] ❌ Fluent UI 加载失败(检查网络/执行器 loadstring)")
end
local AC = {}
function AC.InstallNamecallHook()
if not hookmetamethod or not newcclosure then return false end
if AC._nc then return true end
local old
old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
local method = getnamecallmethod and getnamecallmethod() or ""
if method == "Kick" and self == LP and T.NamecallHook then
local msg = select(1, ...)
pcall(function()
if getgenv then
getgenv().CheatMenu_LastKick = tostring(msg)
end
end)
print("[CheatMenu] 🦶 namecall 拦下 Kick: " .. tostring(msg))
return nil
end
if method == "FireServer" and T.RemoteBlock and not checkcaller() then
local name = tostring(self and self.Name or ""):lower()
local blocked = { "iac-respond", "iacrespond", "kick", "ban", "report", "anticheat", "anti-cheat", "antiexploit", "anti-exploit", "detect", "flag", "exploit", "verify", "suspend", "watchdog", "sentinel", "moderation", "moderator", "x-15", "x-16", "cheat", "speedcheck", "flycheck", "clientcheck", "guard" }
for _, kw in ipairs(blocked) do
if name:find(kw, 1, true) then
return nil
end
end
end
return old(self, ...)
end))
if type(old) ~= "function" then return false end
AC._nc = true
return true
end
AC.BlockedRemotes = {}
AC.BlockedCount = 0
AC._propLockOn = false
AC._propLockOld = nil
AC.SUS_KEYS = {
"iac", "anticheat", "anti-cheat", "antiexploit", "anti-exploit", "detect",
"ban", "kick", "flag", "report", "exploit", "cheat", "x-15", "x-16",
"verify", "suspend", "watchdog", "sentinel", "moderation", "moderator",
"guard", "spy", "speedcheck", "flycheck", "clientcheck",
}
function AC.isSuspicious(name)
name = tostring(name):lower()
for _, kw in ipairs(AC.SUS_KEYS) do
if name:find(kw, 1, true) then return true end
end
return false
end
function AC.hookOneRemote(remote)
if not (remote and typeof(remote) == "Instance") then return end
if not (pcall(function() return remote:IsA("RemoteEvent") end)) then return end
if not remote:IsA("RemoteEvent") then return end
if AC.BlockedRemotes[remote] then return end
if not AC.isSuspicious(remote.Name) then return end
if not hookfunction then return end
local orig
local wrapper = function(self, ...)
if (T.RemoteBlock or T.ACBypass or T.UniversalAC) and not checkcaller() then
return nil
end
if orig then return orig(self, ...) end
end
local ok, res = pcall(function()
if newcclosure then return hookfunction(remote.FireServer, newcclosure(wrapper)) else return hookfunction(remote.FireServer, wrapper) end
end)
if ok and type(res) == "function" then
orig = res
AC.BlockedRemotes[remote] = res
AC.BlockedCount = AC.BlockedCount + 1
end
end
function AC.DeepScanBlock()
pcall(function()
for _, d in ipairs(RStorage:GetDescendants()) do
if d:IsA("RemoteEvent") then AC.hookOneRemote(d) end
end
end)
if type(getgc) == "function" then
pcall(function()
local seen = 0
for _, obj in ipairs(getgc(true)) do
seen = seen + 1
if seen > 8000 then break end
if typeof(obj) == "Instance" then
if obj:IsA("RemoteEvent") then AC.hookOneRemote(obj) end
elseif type(obj) == "function" and islclosure and islclosure(obj) then
for i = 1, 40 do
local ok2, n, v = pcall(debug.getupvalue, obj, i)
if not ok2 or not n then break end
if typeof(v) == "Instance" and v:IsA("RemoteEvent") then AC.hookOneRemote(v) end
end
end
end
end)
end
print("[CheatMenu] 深度扫描完成，已拦反作弊 remote 数=" .. AC.BlockedCount)
end
function AC.ScanAndBlock()
if type(getnilinstances) == "function" then
pcall(function()
for _, inst in ipairs(getnilinstances()) do
if typeof(inst) == "Instance" and inst:IsA("RemoteEvent") then AC.hookOneRemote(inst) end
end
end)
end
AC.DeepScanBlock()
return AC.BlockedCount
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
function AC.InstallPropertyLock()
if AC._propLockOn or not hookmetamethod or not newcclosure then return end
local ok, res = pcall(function()
return hookmetamethod(game, "__newindex", newcclosure(function(t, k, v)
if (T.ACBypass or T.UniversalAC or T.PropertyLock) and not checkcaller() then
if typeof(t) == "Instance" and (k == "WalkSpeed" or k == "JumpPower") then
local isHum = false
pcall(function() isHum = t:IsA("Humanoid") end)
if isHum then
local _, hum = GC()
if hum and t == hum then
if k == "WalkSpeed" and T.Speed then
local base = C._baseWalk or 16
v = base * (C.SpeedMul or 2)
elseif k == "JumpPower" and (T.InfiniteJump or T.Speed) then
v = 50
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
print("[CheatMenu] 属性锁定已安装(WalkSpeed/JumpPower)")
end
end
AC._antiTPOld = nil
AC._antiTPAsyncOld = nil
function AC.InstallAntiTP()
if AC._antiTPOld then return true end
if not hookfunction then return false end
local ts = game:GetService("TeleportService")
local old
local wrapper = function(self, placeId, player, ...)
if not checkcaller() and not (T.KickRejoin and placeId == game.PlaceId) then
print("[CheatMenu] 🚫 拦截被传送: " .. tostring(placeId))
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
print("[CheatMenu] 防传送已安装(拦截 TeleportService.Teleport)")
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
local FlingConns = {}
local function AntiFlingEnable()
if T.AntiFling then return end
T.AntiFling = true
local function disable(part)
if part:IsA("BasePart") then
part.CanCollide = false
part.CanTouch = false
part.CanQuery = false
end
end
local function hookChar(char)
if not char then return end
for _, p in ipairs(char:GetDescendants()) do
disable(p)
end
local conn = char.DescendantAdded:Connect(disable)
table.insert(FlingConns, conn)
end
hookChar(LP.Character)
local conn = LP.CharacterAdded:Connect(hookChar)
table.insert(FlingConns, conn)
end
local function AntiFlingDisable()
T.AntiFling = false
for _, c in ipairs(FlingConns) do pcall(function() c:Disconnect() end) end
FlingConns = {}
end
local AFKConn = nil
local function AntiAFKEnable()
if AFKConn then return end
AFKConn = LP.Idled:Connect(function()
if VirtualUser then
pcall(function() VirtualUser:CaptureController() end)
pcall(function() VirtualUser:ClickButton2(Vector2.new(0, 0)) end)
end
end)
RS.Heartbeat:Connect(function()
if not T.AntiAFK then return end
if (os.clock() - (AC._afkAt or 0)) < 5 then return end
AC._afkAt = os.clock()
pcall(function() LP:SetAttribute("Heartbeat", math.floor(os.clock() * 1000)) end)
local _, hum, root = GC()
if hum and root and (root.AssemblyLinearVelocity.Magnitude < 1) then
hum.Jump = true
end
end)
end
local KG = { hooked = false, target = nil, hits = 0, lastReason = "", rjConn = nil, rjTries = 0 }
local function KickGuardEnable()
if KG.hooked then return true end
local pl = LP
if not pl then return false end
local kf = pl.Kick
if type(kf) ~= "function" then return false end
if not hookfunction then return false end
local orig
local wrapper = function(self, msg)
if self == pl and (type(msg) == "string" or type(msg) == "number") then
KG.hits = KG.hits + 1
KG.lastReason = tostring(msg)
print("[CheatMenu] 🦶 本地拦截 Kick: " .. tostring(msg))
return nil
end
if orig then return orig(self, msg) end
end
local ok, result = pcall(function()
if newcclosure then
return hookfunction(kf, newcclosure(wrapper))
else
return hookfunction(kf, wrapper)
end
end)
if not ok or type(result) ~= "function" then return false end
orig = result
KG.target = kf
KG.hooked = true
return true
end
local function KickGuardDisable()
if KG.hooked and hookfunction and KG.target then
pcall(function() hookfunction(KG.target, KG.target) end)
end
KG.hooked = false
end
local function KickRejoinEnable()
if KG.rjConn then return true end
KG.rjConn = Players.PlayerRemoving:Connect(function(p)
if p ~= LP then return end
if not T.KickRejoin then return end
KG.rjTries = KG.rjTries + 1
pcall(function()
local ts = game:GetService("TeleportService")
if game.PlaceId and game.JobId and game.JobId ~= "" then
ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
end
end)
end)
return true
end
local GYM_WEIGHT_NAMES = {
["Wooden Stick"] = true, ["Bone Barbell"] = true, ["Stone Block"] = true, ["Copper Plate"] = true,
["Iron Plate"] = true, ["Ice Barbell"] = true, ["Donut Barbell"] = true, ["Golden Barbell"] = true,
["Heaven Plate"] = true, ["Mega Golden Barbell"] = true, ["Neon Pulse"] = true,
["Giant Gold Star Barbell"] = true, ["Emerald Barbell"] = true, ["Planet Barbell"] = true,
["Big Jupiter"] = true, ["Black Hole Barbell"] = true,
}
local function equipSquatTool()
local _, hum = GC()
if not hum then return end
local ch = LP.Character
local bp = LP:FindFirstChild("Backpack")
for _, ct in ipairs({ bp, ch }) do
if ct then
for _, t in ipairs(ct:GetChildren()) do
if t:IsA("Tool") then
local ok, ht = pcall(function() return t:HasTag("SquatTool") end)
if ok and ht then
pcall(function() hum:EquipTool(t) end)
return t
end
end
end
end
end
for _, ct in ipairs({ bp, ch }) do
if ct then
for _, t in ipairs(ct:GetChildren()) do
if t:IsA("Tool") and GYM_WEIGHT_NAMES[t.Name] then
pcall(function() hum:EquipTool(t) end)
return t
end
end
end
end
return nil
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
local function AutoGymEnable()
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
elseif m:IsA("BasePart") then
pos = m.Position
end
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
elseif best:IsA("BasePart") then
pos = best.Position
end
if pos then
root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
root.AssemblyLinearVelocity = Vector3.zero
end
else
equipSquatTool()
end
end
end
task.wait(1)
end
end)
end
local TrainThread = nil
local function AutoTrainEnable()
if TrainThread then return end
TrainThread = task.spawn(function()
while T.AutoTrain do
equipSquatTool()
task.wait(math.max(0.5, C.AutoTrainSec or 5))
end
end)
end
local function multiplierFromText(v)
local compact = tostring(v or ""):upper():gsub("%s+", ""):gsub("×", "X")
if compact == "X2" or compact == "2X" then return 2
elseif compact == "X5" or compact == "5X" then return 5
elseif compact == "X10" or compact == "10X" then return 10 end
return nil
end
local function clickBtn(b)
if not b or not b:IsA("GuiButton") or not b.Visible then return false end
if firesignal then
local ok = pcall(firesignal, b.Activated)
if ok then return true end
end
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
task.delay(0.01, function()
if T.AutoBonus then Fire("TaviMishkal") end
end)
end
end
end
end
end
end
end
local BonusThread = nil
local function AutoBonusEnable()
if BonusThread then return end
OnRemote("TaviMishkal", function(m)
if T.AutoBonus then
task.spawn(function()
task.wait(0.03)
AutoBonusScan()
Fire("TaviMishkal")
end)
end
end)
BonusThread = task.spawn(function()
while T.AutoBonus do
AutoBonusScan()
task.wait(1)
end
end)
end
local CPS = {
["Noobini Pizzanini"] = 2, ["Lirili Larila"] = 3, ["Tim Cheese"] = 3, ["Talpa Di Fero"] = 4,
["Svinina Bombardino"] = 5, ["Pipi Kiwi"] = 6, ["Fruli Frula"] = 7, ["Trippi Troppi"] = 7,
["Gangster Footera"] = 15, ["Bobrito Bandito"] = 17, ["Boneca Ambalabu"] = 17,
["Ta Ta Ta Ta Sahur"] = 18, ["Ballerina Cappuccina"] = 19, ["Cappuccino Assassino"] = 22,
["Brr Brr Patapim"] = 22, ["Cacto Hipopotamo"] = 26, ["Garamararam"] = 40,
["Madung"] = 44, ["Waterdino"] = 50, ["Pesto Mortioni"] = 52, ["Pannaburro"] = 62,
["Orcalero"] = 64, ["Mangolini Parrocini"] = 64, ["John Pork"] = 72,
["Gattatino Nyanino"] = 76, ["Chimpanzini Bananini"] = 100, ["Plan Red"] = 130,
["Plan Blue"] = 140, ["Capi Taco"] = 150, ["Trulimero Trulicina"] = 160,
["Bambini Crostini"] = 160, ["Elefantucci Bananucci"] = 170,
["Bananita Dolphinita"] = 235, ["Salamino Pinguino"] = 280,
["Penguino Cocosino"] = 450, ["67"] = 500, ["Burbaloni Luliloli"] = 550,
["Chef Crabracadabra"] = 600, ["Capybara Eggplant"] = 650, ["Bangello"] = 725,
["Elefanto Frigo"] = 775, ["Rinooccio Verdini"] = 880, ["Glorbo Fruttodrillo"] = 950,
["Udin Din Din Dun"] = 1850, ["Pandaccini Bananini"] = 2000,
["Octopusini Bluberini"] = 2150, ["Strawberelli Flamingelli"] = 2300,
["Sigma Boy"] = 2450, ["Frigo Camelo"] = 2600, ["Orangutini Ananasini"] = 2700,
["Rhino Toasterino"] = 2950, ["Bombardiro Crocodilo"] = 3100,
["Bombini Gusini"] = 4750, ["Castlino Fortini"] = 5000, ["Tuff Toucan"] = 5300,
["Fryuro"] = 5850, ["Burguro"] = 6250, ["Guest666"] = 7000,
["Zibra Zubra Zibralini"] = 7750, ["Cavallo Virtuso"] = 10000,
["Gorillo Watermelondrillo"] = 12000, ["Cocofanto Elefanto"] = 14000,
["Bambu Sahur"] = 12500, ["W or L"] = 15000, ["Girafa Celeste"] = 16500,
["Tralalero Tralala"] = 17500, ["Tralalerita Tralala"] = 18000,
["Peant Jarro"] = 19500, ["Dipperi Chiperini"] = 20000, ["Rexosaurus"] = 22500,
["1x1x1x1"] = 25000, ["Matteo"] = 30000, ["Espresso Signora"] = 36500,
["Alessio"] = 27500, ["Tripi Tropi Tropa Tripa"] = 28000, ["SWAG SODA"] = 29000,
["Stoppo Luminino"] = 30000, ["Torrtuginni Dragonfrutini"] = 32000,
["Tictac Sahur"] = 38000, ["Los Primos Blue"] = 44500, ["Cactus Pingu"] = 55000,
["La Vacca Saturno Saturnita"] = 70000, ["Agarrini La Palini"] = 90000,
["Bottellini"] = 75000, ["Karkerkar Kurkur"] = 120000, ["Blackhole Goat"] = 125000,
["Cappuccino Clownino"] = 135000, ["Compactoroni Diskaloni"] = 135000,
["Nuclearo Dinossauro"] = 190000, ["Los Nooo My Hotspotsitos"] = 200000,
["Chillin Chilli"] = 220000, ["Crazylone Pizaione"] = 225000, ["Corn Sahur"] = 225000,
["Meowl"] = 275000, ["Strawberry Elephant"] = 420000,
["Dragonfrutina Dolphinita"] = 475000, ["Guerriro Digitale"] = 490000,
["Chicleteira Bicicleteira"] = 500000, ["Pot Hotspot"] = 525000,
["Krupuk Pagi Pagi"] = 540000, ["Beluga Beluga"] = 575000, ["Tralaledon"] = 625000,
["Anpali Babel"] = 750000, ["Los Primos"] = 800000, ["Ketchuru Matsuru"] = 800000,
["Mastodontico Telepiedone"] = 850000, ["Espresso Shockantoni"] = 1000000,
["Ketupat Kepat"] = 1250000, ["Professora 67"] = 1400000, ["Astro Tim"] = 1500000,
["Dumbelloni"] = 1750000, ["Baba Yaga"] = 2000000, ["Don Tiramisotto"] = 2250000,
["Kicky"] = 2500000, ["Smelloni Papayoni"] = 2750000, ["Barbelloni Gymrattoni"] = 3000000,
["Dribbloni Spaghetti"] = 7500000, ["Coinator Baconator"] = 6500000,
["Lucky Fella"] = 5000000, ["Pulcino Pistoletti"] = 10000000,
["Divinello Starblock"] = 8750000, ["Cordraculo"] = 10000000,
["Harpini Goosini"] = 11250000, ["OctoDJ"] = 15000000, ["Tubafante"] = 12500000,
["Turtinella Melodica"] = 16500000, ["Cucumbro Nerdino"] = 2500000,
}
local MutBuff = {
Golden = 1.5, Diamond = 2, Plasma = 4, Molten = 6, Radioactive = 8,
Shadow = 12, Electrified = 16, Rainbow = 40, Astral = 50, Infinity = 75,
Void = 12, Virus = 14, Wet = 16, Alien = 22, Bacon = 30, Enchanted = 12,
Phantom = 35, Volcanic = 35, Heavenly = 36, Carnival = 37,
["Block Cup"] = 38, Undead = 35, Jungle = 40, Frozen = 40,
}
local EXCLUSIVE_KEEP = {
"W", "Dragon Cannelloni", "Spaghetti Tualetti", "Esok Sekolah", "Job Job Job Sahur",
"Yess My Examen", "Lucky Kick", "Hippocopter", "Auto Grizzlioni", "Los Bombardinos", "Rocky",
"Hat Tricky", "GOAT", "Bronze Block Medali", "Golden Block Cuppy", "Silver Block Cuppy",
"Bronze Block Cuppy", "Golden Block Medali", "Silver Block Medali", "Stadoini",
"Cone Cone Cone Sahur", "Ballberto", "Soccerdino", "Netini Goalini", "Orangutango Supremo",
"Croakumber", "Lampuccio Raccoonelli", "Tuki Tuki Taco", "Professor Tigrellini",
"Patagotitan", "Frigorex", "Velacoraptor", "Bicletairussaurus", "Jet Jet Raptoret",
"Tricerabob", "Teacherrina", "Locko Blocko", "Scuolabus Giraffini", "Donutello",
"Professor Penneroni", "Brain Mogger",
}
local EXCLUSIVE_SET = {}
for _, nm in ipairs(EXCLUSIVE_KEEP) do EXCLUSIVE_SET[nm] = true end
local function isEntityTool(t)
if not t or not t:IsA("Tool") then return false end
local ok, ht = pcall(function() return t:HasTag("EntityTool") end)
return ok and ht
end
local function isExclusive(t)
if not t then return false end
if EXCLUSIVE_SET[t.Name] then return true end
if t:GetAttribute("Exclusive") or t:GetAttribute("IsExclusive")
or t:GetAttribute("Limited") or t:GetAttribute("IsLimited")
or t:GetAttribute("Percent") or t:GetAttribute("Multiplier") then return true end
local n = string.lower(t.Name)
for _, kw in ipairs({ "exclusive", "limited", "vip", "%", "x2", "x5", "x10", "x20", "x50", "percent", "lucky" }) do
if string.find(n, kw, 1, true) then return true end
end
return false
end
local function getBrainrotCPS(tool)
local base = CPS[tool.Name]
if not base then
local a = tool:GetAttribute("CPS") or tool:GetAttribute("BaseCPS")
if typeof(a) == "number" then base = a else return nil end
end
local lv = math.clamp(math.floor(tonumber(tool:GetAttribute("Level")) or 1), 1, 75)
local mut = tostring(tool:GetAttribute("Mutation") or "")
local lm = tonumber(C.SellLvMul)
if not lm or lm <= 0 then lm = 1.25 end
return base * (MutBuff[mut] or 1) * (lm ^ (lv - 1))
end
local function findSeller()
local npcs = WS:FindFirstChild("NPCs")
if not npcs then return nil end
for _, o in ipairs(npcs:GetChildren()) do
if o:IsA("Model") and (o.Name == "Timmy" or o:GetAttribute("Name") == "Timmy") then return o end
end
return nil
end
local function guiTextBlob(obj)
if not obj then return "" end
local pieces = {}
if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
pieces[#pieces + 1] = tostring(obj.Text or "")
end
for _, child in ipairs(obj:GetDescendants()) do
if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
pieces[#pieces + 1] = tostring(child.Text or "")
end
end
return table.concat(pieces, " "):lower()
end
local function visibleGuiButtons()
local result = {}
if not PG then return result end
local ok, desc = pcall(function() return PG:GetDescendants() end)
if not ok or type(desc) ~= "table" then return result end
for _, obj in ipairs(desc) do
if obj:IsA("GuiButton") and obj.Visible and obj.AbsoluteSize.X > 2 and obj.AbsoluteSize.Y > 2 then
result[#result + 1] = obj
end
end
return result
end
local function clickGuiButton(btn)
if not btn or not btn:IsA("GuiButton") then return false end
if type(firesignal) == "function" then
local ok = pcall(firesignal, btn.Activated)
if ok then return true end
end
return false
end
local function sellerDistance()
local _, _, root = GC()
local seller = findSeller()
local prompt = seller and seller:FindFirstChildWhichIsA("ProximityPrompt", true)
local part
if prompt and prompt.Parent and prompt.Parent:IsA("BasePart") then
part = prompt.Parent
end
if not part and seller then
part = seller:FindFirstChild("Hitbox", true) or seller:FindFirstChildWhichIsA("BasePart", true)
end
if not root then return math.huge, seller, prompt, part end
local position = part and part.Position
if not position then return math.huge, seller, prompt, part end
return (root.Position - position).Magnitude, seller, prompt, part
end
local function triggerSellerPrompt()
local seller = findSeller()
if not seller then return false end
local prompt = seller:FindFirstChildWhichIsA("ProximityPrompt", true)
if not prompt or not prompt.Enabled then return false end
local distance = sellerDistance()
local allowed = tonumber(prompt.MaxActivationDistance) or 10
if distance > allowed + 1 then return false end
local triggered = false
if type(fireproximityprompt) == "function" then
triggered = pcall(function() fireproximityprompt(prompt) end)
end
if not triggered then
triggered = pcall(function()
prompt:InputHoldBegin()
task.wait(math.max(0.03, tonumber(prompt.HoldDuration) or 0) + 0.03)
prompt:InputHoldEnd()
end)
end
return triggered
end
local function moveToSeller(forceNear)
local _, hum, root = GC()
if not root or not hum or root.Anchored then return false end
local distance, seller, prompt, part = sellerDistance()
local allowed = 12
if prompt then
allowed = math.max(3, math.min(18, (tonumber(prompt.MaxActivationDistance) or 10) - 1))
end
if not forceNear and distance <= allowed then return true end
if part then
local target = part.Position
local flatAway = Vector3.new(root.Position.X - target.X, 0, root.Position.Z - target.Z)
if flatAway.Magnitude < 0.1 then flatAway = Vector3.new(1, 0, 0) end
local standDistance = math.max(2.5, math.min(4, allowed * 0.45))
local standPosition = target + flatAway.Unit * standDistance
standPosition = Vector3.new(standPosition.X, root.Position.Y, standPosition.Z)
pcall(function()
root.CFrame = CFrame.lookAt(standPosition, Vector3.new(target.X, standPosition.Y, target.Z))
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
task.wait(0.10)
end
distance = sellerDistance()
return distance <= math.max(allowed, 18)
end
local function findSellAllButton()
local best, bestScore = nil, -1
for _, btn in ipairs(visibleGuiButtons()) do
local blob = guiTextBlob(btn)
local score = 0
if blob:find("sell all", 1, true) then score = score + 1000 end
if blob:find("brainrot", 1, true) then score = score + 250 end
if blob:find("sell", 1, true) then score = score + 80 end
if score > bestScore and score >= 1000 then
bestScore = score
best = btn
end
end
return best
end
local function sellAllViaUI()
moveToSeller()
task.wait(0.3)
triggerSellerPrompt()
task.wait(0.5)
local btn = findSellAllButton()
if not btn then
print("[CheatMenu] ❌ 没找到 Sell All 按钮(触发 Timmy 交互了吗?)")
return false
end
print("[CheatMenu] 点击 Sell All 按钮: " .. tostring(btn.Name))
if not clickGuiButton(btn) then
print("[CheatMenu] ❌ Sell All 点击失败")
return false
end
task.wait(0.3)
for _, b in ipairs(visibleGuiButtons()) do
local blob = guiTextBlob(b)
if blob:find("confirm", 1, true) or blob:find("yes", 1, true) then
print("[CheatMenu] 点击确认按钮: " .. tostring(b.Name))
clickGuiButton(b)
break
end
end
return true
end
local SellThread = nil
local function exactToolEquipped(tool)
local ch = LP.Character
if not ch or not tool or tool.Parent ~= ch then return false end
local held = ch:FindFirstChildOfClass("Tool")
return held == tool
end
local function ensureSellerToolEquipped(tool, timeout)
if not tool or not tool.Parent then return false end
local _, hum = GC()
if not hum then return false end
pcall(function() hum:UnequipTools() end)
task.wait(0.06)
if not tool.Parent then return false end
pcall(function() hum:EquipTool(tool) end)
local deadline = os.clock() + (timeout or 1.2)
while os.clock() < deadline do
if exactToolEquipped(tool) then return true end
task.wait(0.025)
end
return exactToolEquipped(tool)
end
local function waitForSoldTool(tool, timeout)
local backpack = LP:FindFirstChild("Backpack")
local ch = LP.Character
local deadline = os.clock() + (timeout or 1.2)
while os.clock() < deadline do
if not tool or not tool.Parent or (tool.Parent ~= backpack and tool.Parent ~= ch) then
return true
end
task.wait(0.025)
end
return not tool or not tool.Parent or (tool.Parent ~= backpack and tool.Parent ~= ch)
end
local function sellLowCPSTools()
if SellThread then return end
SellThread = task.spawn(function()
local _, hum = GC()
if not hum then SellThread = nil return end
moveToSeller()
local total = 0
local scanToolCount, scanEntityCount = 0, 0
for round = 1, 200 do
if not T.AutoSell then break end
local picks = {}
local function scan(list)
if not list then return end
for _, t in ipairs(list:GetChildren()) do
if t:IsA("Tool") then
scanToolCount = scanToolCount + 1
if isEntityTool(t) then
scanEntityCount = scanEntityCount + 1
if not isExclusive(t) then
local cps = getBrainrotCPS(t)
local th = tonumber(C.SellMinCPS) or 100000
if cps and cps < th then
picks[#picks + 1] = { Tool = t, CPS = cps }
end
end
end
end
end
end
scan(LP.Character)
scan(LP:FindFirstChild("Backpack"))
if round == 1 then
print(("[CheatMenu] 扫描: 工具%d 脑红%d 待卖%d (门槛%g)"):format(
scanToolCount, scanEntityCount, #picks, tonumber(C.SellMinCPS) or 100000))
end
if #picks == 0 then
if round == 1 then
print("[CheatMenu] ⚠️ 没有找到可卖的脑红 —— 检查: 是否带 EntityTool 标签? CPS 属性是否可读? 门槛是否太高?")
end
break
end
local function sellHeldBrainrot()
local rf = RFunction("B_Sell")
if rf then
local ok, res = pcall(function() return rf:InvokeServer() end)
if ok then return true, res end
end
local re = REvent("B_Sell")
if re then
pcall(function() re:FireServer() end)
return true, nil
end
return false, nil
end
triggerSellerPrompt()
task.wait(0.1)
local sold = 0
for _, e in ipairs(picks) do
if not T.AutoSell then break end
local tool = e.Tool
if tool and tool.Parent then
if ensureSellerToolEquipped(tool, 1.25) then
task.wait(0.16)
sellHeldBrainrot()
if waitForSoldTool(tool, 0.85) then
sold = sold + 1
total = total + 1
end
end
end
end
if sold > 0 then
print("[CheatMenu] ✅ 快速卖出 " .. sold .. " 个脑红")
break
else
print("[CheatMenu] ⚠️ B_Sell 没卖出，改用 Sell All UI 兜底")
if sellAllViaUI() then
total = total + 1
end
break
end
end
pcall(function() hum:UnequipTools() end)
print("[CheatMenu] 售卖完成 · 共 " .. total .. " 个")
SellThread = nil
if total > 0 then
T.AutoSell = false
end
end)
end
local WithdrawThread = nil
local function withdrawAllBrainrots()
if WithdrawThread then return end
WithdrawThread = task.spawn(function()
local _, hum = GC()
if not hum then WithdrawThread = nil return end
local function findEmptySlot()
local plots = WS:FindFirstChild("Plots")
if not plots then return nil end
local myPlot
for _, p in ipairs(plots:GetChildren()) do
local o = p:GetAttribute("Owner")
if o == LP.Name or o == LP.DisplayName then myPlot = p break end
end
if not myPlot then return nil end
local slots = myPlot:FindFirstChild("Slots")
if not slots then return nil end
for _, slot in ipairs(slots:GetChildren()) do
local sn = tostring(slot.Name)
local idx = tonumber(sn:match("^Slot[%s_%-]*(%d+)$")) or tonumber(sn:match("(%d+)$"))
if idx and idx >= 1 and idx <= 30 then
local has = false
for _, c in ipairs(slot:GetDescendants()) do
if c:GetAttribute("ID") ~= nil then has = true break end
end
if not has then return idx end
end
end
return nil
end
local placed = 0
for _ = 1, 30 do
local slotIdx = findEmptySlot()
if not slotIdx then break end
local tool
local bp = LP:FindFirstChild("Backpack")
if bp then
for _, t in ipairs(bp:GetChildren()) do
if isEntityTool(t) then tool = t break end
end
end
if not tool then break end
pcall(function() hum:EquipTool(tool) end)
task.wait(0.2)
if tool.Parent == LP.Character then
Fire("S_Interact", slotIdx)
placed = placed + 1
task.wait(0.15)
end
end
pcall(function() hum:UnequipTools() end)
print("[CheatMenu] 收起脑红 · 放置 " .. placed .. " 个到基地槽位")
WithdrawThread = nil
end)
end
local CollectThread = nil
local function collectAllCash()
if CollectThread then return end
CollectThread = task.spawn(function()
local _, _, root = GC()
if not root then CollectThread = nil return end
local returnCF = root.CFrame
local plots = WS:FindFirstChild("Plots")
if not plots then
for _, obj in ipairs(WS:GetChildren()) do
if obj:IsA("Folder") or obj:IsA("Model") then
for _, child in ipairs(obj:GetChildren()) do
if child:GetAttribute("Owner") ~= nil then plots = obj break end
end
if plots then break end
end
end
end
if not plots then
print("[CheatMenu] ❌ 找不到 Plots")
CollectThread = nil return
end
local myPlot
for _, p in ipairs(plots:GetChildren()) do
local o = p:GetAttribute("Owner")
if o == LP.Name or o == LP.DisplayName then myPlot = p break end
end
if not myPlot then
print("[CheatMenu] ❌ 找不到你的基地")
CollectThread = nil return
end
local slots = myPlot:FindFirstChild("Slots")
local done = 0
if slots then
for _, slot in ipairs(slots:GetChildren()) do
local sn = tostring(slot.Name)
local idx = tonumber(sn:match("^Slot[%s_%-]*(%d+)$")) or tonumber(sn:match("(%d+)$"))
if idx and idx >= 1 and idx <= 30 then
local has = false
local part
for _, c in ipairs(slot:GetDescendants()) do
if c:GetAttribute("ID") ~= nil then
has = true
if c:IsA("BasePart") then part = c end
break
end
end
if has then
local targetPos
if part then targetPos = part.Position
elseif slot:IsA("BasePart") then targetPos = slot.Position end
if not targetPos then
pcall(function()
local pv = slot:GetPivot()
if pv then targetPos = pv.Position end
end)
end
if targetPos then
root.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
root.AssemblyLinearVelocity = Vector3.zero
task.wait(0.03)
end
Fire("B_Collect", idx)
done = done + 1
task.wait(0.03)
end
end
end
else
for i = 1, 30 do Fire("B_Collect", i) task.wait(0.03) end
end
task.wait(0.15)
pcall(function()
root.CFrame = returnCF
root.AssemblyLinearVelocity = Vector3.zero
end)
print("[CheatMenu] ✅ 收起货币完成 · 领取 " .. done .. " 个槽位")
CollectThread = nil
end)
end
local Trans = {}
local HOST = "http://127.0.0.1:8080"
local KEY = "rk_4a56fc43faa5edb9f7a0cafd4ad3e91f"
local MODEL = "hymt2-7b"
local SYS_PROMPT = [[Translate the following game UI text into Chinese.
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
local TransCache = {}
local TransCacheFile = "CheatMenu_TransCache.json"
local function loadTransCache()
pcall(function()
if not (readfile and isfile and isfile(TransCacheFile)) then return end
local raw = readfile(TransCacheFile)
local d = HS:JSONDecode(raw)
if type(d) == "table" then
local n = 0
for k, v in pairs(d) do TransCache[k] = v n = n + 1 end
print("[CheatMenu] 已加载翻译缓存 " .. n .. " 条")
end
end)
end
local function saveTransCache()
pcall(function()
if not writefile then return end
writefile(TransCacheFile, HS:JSONEncode(TransCache))
end)
end
local TransLangs = {
zh = "Chinese", en = "English", ja = "Japanese", ko = "Korean",
th = "Thai", ru = "Russian", ar = "Arabic", id = "Indonesian",
}
local function promptFor(code)
if not code or code == "zh" then return SYS_PROMPT end
local lang = TransLangs[code] or "Chinese"
return "Translate the following game UI text into " .. lang
.. ". Output ONLY the translation: no explanation, no quotes, no extra words."
.. " Keep numbers, emoji, URLs and player names unchanged."
end
local requestFn = (type(syn) == "table" and syn.request) or (type(http) == "table" and http.request) or http_request or request
local function TransRequest(text)
if not requestFn then
print("[CheatMenu] ❌ 翻译失败: 执行器没有 request 函数")
return nil
end
local body = HS:JSONEncode({
model = MODEL,
messages = {
{ role = "system", content = promptFor(C.TransLang) },
{ role = "user", content = text },
},
temperature = 0.1,
top_p = 0.6,
max_tokens = 128,
stream = false,
})
local ok, res = pcall(function()
return requestFn({
Url = HOST .. "/v1/chat/completions",
Method = "POST",
Headers = {
["Content-Type"] = "application/json",
["Authorization"] = "Bearer " .. KEY,
},
Body = body,
})
end)
if not ok or type(res) ~= "table" or (res.StatusCode or 0) ~= 200 then
print("[CheatMenu] ❌ 翻译请求失败: " .. tostring(res and res.StatusCode))
return nil
end
local ok2, d = pcall(HS.JSONDecode, HS, res.Body)
if not ok2 or not d or not d.choices or not d.choices[1] then return nil end
return d.choices[1].message and d.choices[1].message.content
end
local function shouldTranslate(s)
if type(s) ~= "string" or s == "" then return false end
if #s > 200 then return false end
local hasCJK = s:find("[\228-\233]") ~= nil
local hasAlpha = s:find("%a") ~= nil
if not hasCJK and not hasAlpha then return false end
if s:find("$", 1, true) or s:find("€", 1, true) or s:find("¥", 1, true) then return false end
if s:match("^[%d%.,%%%+%-%s/()]+$") then return false end
local lang = C.TransLang or "zh"
if lang == "zh" and hasCJK then return false end
return true
end
function Trans.Translate(text, force)
if (not T.Translate and not force) or type(text) ~= "string" or text == "" then return nil end
text = text:gsub("^%s+", ""):gsub("%s+$", "")
if text == "" then return nil end
if not force and not shouldTranslate(text) then return nil end
if TransCache[text] then return TransCache[text] end
local now = os.clock()
if not force and (now - (Trans._lastAt or 0)) < (C.TransInterval or 0.15) then return nil end
Trans._lastAt = now
local r = TransRequest(text)
if r and r ~= "" and r ~= text then
r = r:gsub("^%s*(翻译|译文|中文|汉化)%s*[:：]%s*", "")
TransCache[text] = r
saveTransCache()
return r
end
return nil
end
local function sendChat(text)
if not text or text == "" then return false end
local tcs = game:GetService("TextChatService")
if tcs and tcs.TextChannels then
local channel = tcs.TextChannels:FindFirstChild("RBXGeneral")
if channel and channel.SendAsync then
pcall(function() channel:SendAsync(text) end)
return true
end
end
local chatEvents = RStorage:FindFirstChild("DefaultChatSystemChatEvents")
if chatEvents then
local say = chatEvents:FindFirstChild("SayMessageRequest")
if say then
pcall(function() say:FireServer(text, "All") end)
return true
end
end
return false
end
local function translateGuiEl(obj)
if not obj then return end
if obj:IsA("TextLabel") or obj:IsA("TextButton") then
local txt = obj.Text
if txt and shouldTranslate(txt) then
local tr = Trans.Translate(txt, true)
if tr and tr ~= txt then obj.Text = tr end
end
end
end
local function scanAndTranslate()
local roots = { PG, CoreGui }
if gethui then table.insert(roots, gethui()) end
for _, root in ipairs(roots) do
if root then
for _, obj in ipairs(root:GetDescendants()) do
translateGuiEl(obj)
end
end
end
for _, obj in ipairs(workspace:GetChildren()) do
if obj:IsA("ProximityPrompt") then
if obj.ActionText and obj.ActionText ~= "" then
local tr = Trans.Translate(obj.ActionText, true)
if tr then obj.ActionText = tr end
end
end
end
end
local TransLoop = nil
local function startTranslateLoop()
if TransLoop then return end
scanAndTranslate()
TransLoop = task.spawn(function()
while T.Translate do
task.wait(1)
scanAndTranslate()
end
TransLoop = nil
end)
end
local CM = (function()
local FlyConn = nil
local function FlyDisable()
if FlyConn then FlyConn:Disconnect() FlyConn = nil end
local _, hum = GC()
if hum then hum.PlatformStand = false end
end
local function FlyEnable()
local _, hum, root = GC()
if not (hum and root) then return end
FlyDisable()
hum.PlatformStand = true
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
if dir.Magnitude > 0 then
local sp = math.min(C.FlySpeed or 50, 300) * math.min(dt, 0.1)
r.CFrame = r.CFrame + (dir.Unit * sp)
end
r.AssemblyLinearVelocity = Vector3.zero
r.AssemblyAngularVelocity = Vector3.zero
end)
end
local SpeedConn = nil
local SpeedConn2 = nil
local baseWalk = nil
local function SpeedEnable()
if SpeedConn then return end
local function apply()
if not T.Speed then return end
local _, hum = GC()
if hum then
if not baseWalk then baseWalk = hum.WalkSpeed or 16 end
C._baseWalk = baseWalk
hum.WalkSpeed = baseWalk * (C.SpeedMul or 2)
end
end
apply()
SpeedConn = RS.Stepped:Connect(apply)
SpeedConn2 = RS.RenderStepped:Connect(apply)
end
local function SpeedDisable()
if SpeedConn then SpeedConn:Disconnect() SpeedConn = nil end
if SpeedConn2 then SpeedConn2:Disconnect() SpeedConn2 = nil end
local _, hum = GC()
if hum and baseWalk then hum.WalkSpeed = baseWalk end
baseWalk = nil
end
local JumpConn = nil
local function InfiniteJumpEnable()
if JumpConn then return end
JumpConn = UIS.JumpRequest:Connect(function()
if not T.InfiniteJump then return end
local _, hum = GC()
if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
end
local SpinConn = nil
local function SpinEnable()
if SpinConn then return end
SpinConn = RS.RenderStepped:Connect(function()
if not T.Spin then return end
local _, _, r = GC()
if r then r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(C.SpinSpeed or 10), 0) end
end)
end
local function SpinDisable()
if SpinConn then SpinConn:Disconnect() SpinConn = nil end
end
local AirWalkConn = nil
local function AirWalkEnable()
if AirWalkConn then return end
AirWalkConn = RS.RenderStepped:Connect(function(dt)
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
if dir.Magnitude > 0 then
r.CFrame = r.CFrame + dir.Unit * (C.AirWalkSpeed or 30) * math.min(dt, 0.1)
end
end)
end
local function AirWalkDisable()
if AirWalkConn then AirWalkConn:Disconnect() AirWalkConn = nil end
end
local NoClipConn = nil
local NoClipParts = {}
local function NoClipEnable()
if NoClipConn then return end
local function noclip()
local ch = LP.Character
if not ch then return end
for _, part in ipairs(ch:GetDescendants()) do
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
NoClipParts[part] = true
end
end
end
noclip()
NoClipConn = RS.Stepped:Connect(noclip)
end
local function NoClipDisable()
if NoClipConn then NoClipConn:Disconnect() NoClipConn = nil end
for part, _ in pairs(NoClipParts) do
if typeof(part) == "Instance" and part:IsA("BasePart") and part.Parent then
part.CanCollide = true
end
end
NoClipParts = {}
end
local HideConn = nil
local HideBaseY = nil
local function HideEnable()
if HideConn then return end
local _, _, root = GC()
if root then HideBaseY = root.Position.Y end
HideConn = RS.RenderStepped:Connect(function()
if not T.Hide then return end
local _, _, r = GC()
if not r then return end
local depth = math.min(C.HideDepth or 5, 10)
r.CFrame = CFrame.new(r.Position.X, HideBaseY - depth, r.Position.Z)
local cam = workspace.CurrentCamera
if cam then
local cp = cam.CFrame.Position
if cp.Y < HideBaseY - 0.5 then
cam.CFrame = CFrame.new(cp.X, HideBaseY, cp.Z) * (cam.CFrame - cam.CFrame.Position)
end
end
end)
end
local function HideDisable()
if HideConn then HideConn:Disconnect() HideConn = nil end
pcall(function()
local _, _, r = GC()
if r and HideBaseY then r.CFrame = CFrame.new(r.Position.X, HideBaseY + 2, r.Position.Z) end
end)
end
local savedLight = nil
local function FullBrightEnable()
local L = game:GetService("Lighting")
if not savedLight then
savedLight = { Brightness = L.Brightness, ClockTime = L.ClockTime, FogEnd = L.FogEnd,
GlobalShadows = L.GlobalShadows, Ambient = L.Ambient, OutdoorAmbient = L.OutdoorAmbient }
end
L.Brightness = 2
L.ClockTime = 14
L.FogEnd = 100000
L.GlobalShadows = false
L.Ambient = Color3.fromRGB(255, 255, 255)
L.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end
local function FullBrightDisable()
local L = game:GetService("Lighting")
if not savedLight then return end
L.Brightness = savedLight.Brightness
L.ClockTime = savedLight.ClockTime
L.FogEnd = savedLight.FogEnd
L.GlobalShadows = savedLight.GlobalShadows
L.Ambient = savedLight.Ambient
L.OutdoorAmbient = savedLight.OutdoorAmbient
end
local savedNV = nil
local function NightVisionEnable()
local L = game:GetService("Lighting")
if not savedNV then savedNV = { Brightness = L.Brightness, ClockTime = L.ClockTime, Ambient = L.Ambient } end
L.Brightness = 1.5
L.ClockTime = 0
L.Ambient = Color3.fromRGB(90, 255, 90)
end
local function NightVisionDisable()
local L = game:GetService("Lighting")
if not savedNV then return end
L.Brightness = savedNV.Brightness
L.ClockTime = savedNV.ClockTime
L.Ambient = savedNV.Ambient
end
local savedFog = nil
local function NoFogEnable()
local L = game:GetService("Lighting")
if not savedFog then savedFog = { FogEnd = L.FogEnd, FogStart = L.FogStart } end
L.FogEnd = 100000
L.FogStart = 100000
end
local function NoFogDisable()
local L = game:GetService("Lighting")
if not savedFog then return end
L.FogEnd = savedFog.FogEnd
L.FogStart = savedFog.FogStart
end
local function breakVelocity()
local _, _, root = GC()
if root then
pcall(function()
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
end
end
local function smoothTP(targetCF, useSmooth)
local _, _, root = GC()
if not root then return end
if not (T.TPSmooth and useSmooth ~= false) then
pcall(function() root:PivotTo(targetCF) end)
breakVelocity()
return
end
local start = root.CFrame
local seg = math.max(3, tonumber(C.TPSmoothSeg) or 8)
for i = 1, seg do
root.CFrame = start:Lerp(targetCF, i / seg)
task.wait(0.015)
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
local function getTPTargetPlayer()
local name = Fluent.Options.TPTarget and Fluent.Options.TPTarget.Value
if not name then return nil end
return Players:FindFirstChild(name)
end
local CircleConn = nil
local function CircleEnable()
if CircleConn then return end
local angle = 0
CircleConn = RS.RenderStepped:Connect(function()
if not T.Circle then return end
local target = getTPTargetPlayer()
local _, _, r = GC()
if not (target and target.Character and r) then return end
local tr = target.Character:FindFirstChild("HumanoidRootPart")
if not tr then return end
angle = angle + math.rad(C.CircleSpeed or 5)
local rad = C.CircleRadius or 10
r.CFrame = CFrame.new(tr.Position + Vector3.new(math.cos(angle) * rad, 3, math.sin(angle) * rad))
end)
end
local function CircleDisable()
if CircleConn then CircleConn:Disconnect() CircleConn = nil end
end
local function SpectateEnable()
local target = getTPTargetPlayer()
if target and target.Character then
local hum = target.Character:FindFirstChildOfClass("Humanoid")
if hum then workspace.CurrentCamera.CameraSubject = hum end
end
end
local function SpectateDisable()
local ch = LP.Character
if ch then
local hum = ch:FindFirstChildOfClass("Humanoid")
if hum then workspace.CurrentCamera.CameraSubject = hum end
end
end
local SavedPos = nil
local function savePosition()
local _, _, r = GC()
if r then SavedPos = r.CFrame print("[CheatMenu] 已保存当前位置") end
end
local function teleportToSaved()
local _, _, r = GC()
if r and SavedPos then r.CFrame = SavedPos end
end
local ClickerConn = nil
local function ClickerEnable()
if ClickerConn then return end
ClickerConn = RS.Stepped:Connect(function()
if not T.Clicker then return end
if type(mouse1click) == "function" then mouse1click()
elseif type(mouse1press) == "function" then mouse1press() task.wait(0.01) mouse1release() end
end)
end
local function ClickerDisable()
if ClickerConn then ClickerConn:Disconnect() ClickerConn = nil end
end
local function ServerHop()
local ts = game:GetService("TeleportService")
pcall(function() ts:Teleport(game.PlaceId, LP) end)
end
local AimConn = nil
local function AimDisable() if AimConn then AimConn:Disconnect() AimConn = nil end end
local function aimPartOf(ch)
local mode = C.AimHitPart or "head"
if mode == "head" then return ch:FindFirstChild("Head") end
if mode == "torso" then return ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") end
return ch:FindFirstChild("HumanoidRootPart")
end
local function predictPos(part)
if not T.AimPrediction then return part.Position end
local vel = part.AssemblyLinearVelocity
local dist = (workspace.CurrentCamera.CFrame.Position - part.Position).Magnitude
local travel = dist / math.max(1, C.AimBulletSpeed or 500)
return part.Position + vel * travel
end
local function getAimTarget()
local cam = workspace.CurrentCamera
local fovRadius = C.AimFOV or 200
local best, bestDist = nil, math.huge
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP then
local ch = pl.Character
local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hrp and hrp.Parent and hum and hum.Health > 0 then
local skip = false
if T.AimTeamCheck and pl.Team == LP.Team then skip = true end
if not skip and T.AimWallCheck then
local origin = cam.CFrame.Position
local dir = hrp.Position - origin
local params = RaycastParams.new()
params.FilterDescendantsInstances = { LP.Character, pl.Character }
params.FilterType = Enum.RaycastFilterType.Exclude
if workspace:Raycast(origin, dir, params) then skip = true end
end
if not skip then
local part = aimPartOf(ch) or hrp
local screenPos, onScreen = cam:WorldToScreenPoint(hrp.Position)
if onScreen then
local dist = (Vector2.new(screenPos.X, screenPos.Y) - cam.ViewportSize / 2).Magnitude
if dist < bestDist and dist < fovRadius then
bestDist = dist
best = part
end
end
end
end
end
end
return best
end
local function AimEnable()
AimDisable()
AimConn = RS.RenderStepped:Connect(function()
if not T.Aim then return end
if T.TriggerBot and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
local target = getAimTarget()
if not target then return end
local cam = workspace.CurrentCamera
local smooth = math.max(1, C.AimSmooth or 5)
cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position, predictPos(target)), 1 / smooth)
end)
end
local SilentAimConn = nil
local function SilentAimEnable()
if SilentAimConn then return end
SilentAimConn = RS.RenderStepped:Connect(function()
if not T.SilentAim then return end
if T.TriggerBot and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
local target = getAimTarget()
if not target then return end
workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, predictPos(target))
end)
end
local function SilentAimDisable()
if SilentAimConn then SilentAimConn:Disconnect() SilentAimConn = nil end
end
local SilentAimGhostHook = nil
local function SilentAimGhostEnable()
if SilentAimGhostHook then return end
if not (hookmetamethod and newcclosure and getnamecallmethod) then return end
local mt = getrawmetatable(game)
local old
local ok, res = pcall(function()
return hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
local method = getnamecallmethod()
if T.SilentAimGhost and not checkcaller() then
if method == "Raycast" or method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist" or method == "RaycastParams" then
local target = getAimTarget()
if target then
local origin = select(1, ...)
if typeof(origin) == "Vector3" then
local goal = predictPos(target)
local dir = (goal - origin).Unit
local dist = (goal - origin).Magnitude
local args = { ... }
if method == "Raycast" then
return old(self, origin, dir * dist, select(3, ...))
end
return old(self, origin, dir * dist, select(3, ...))
end
end
end
end
return old(self, ...)
end))
end)
if ok and type(res) == "function" then
SilentAimGhostHook = res
print("[CheatMenu] 静默自瞄·无痕版已开启(镜头不动, 射线拐目标)")
end
end
local function SilentAimGhostDisable()
if SilentAimGhostHook and hookmetamethod then
pcall(function() hookmetamethod(game, "__namecall", SilentAimGhostHook) end)
end
SilentAimGhostHook = nil
end
local SingleAimConn = nil
local function SingleAimEnable()
if SingleAimConn then return end
SingleAimConn = RS.RenderStepped:Connect(function()
if not T.SingleAim then return end
local target = getTPTargetPlayer()
if not (target and target.Character) then return end
local hrp = target.Character:FindFirstChild("HumanoidRootPart")
if hrp then workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, hrp.Position) end
end)
end
local function SingleAimDisable()
if SingleAimConn then SingleAimConn:Disconnect() SingleAimConn = nil end
end
local FaceLockConn = nil
local function FaceLockEnable()
if FaceLockConn then return end
FaceLockConn = RS.RenderStepped:Connect(function()
if not T.FaceLock then return end
local target = getTPTargetPlayer()
local _, _, r = GC()
if not (target and target.Character and r) then return end
local hrp = target.Character:FindFirstChild("HumanoidRootPart")
if hrp then r.CFrame = CFrame.lookAt(r.Position, Vector3.new(hrp.Position.X, r.Position.Y, hrp.Position.Z)) end
end)
end
local function FaceLockDisable()
if FaceLockConn then FaceLockConn:Disconnect() FaceLockConn = nil end
end
local function FlingTarget()
local target = getTPTargetPlayer()
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
local function GodEnable()
if GodConn then return end
local function apply()
local _, hum = GC()
if hum then hum.MaxHealth = math.huge hum.Health = math.huge end
end
apply()
GodConn = RS.Stepped:Connect(apply)
end
local function GodDisable()
if GodConn then GodConn:Disconnect() GodConn = nil end
end
local function InvisibleApply(ch, on)
if not ch then return end
CM._invBackup = CM._invBackup or {}
for _, d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") then
if on then
CM._invBackup[d] = d.Transparency
d.Transparency = 1
d.CastShadow = false
else
d.Transparency = CM._invBackup[d] or ((d.Name == "HumanoidRootPart") and 1 or 0)
d.CastShadow = true
end
elseif d:IsA("Decal") or d:IsA("Texture") then
if on then CM._invBackup[d] = d.Transparency d.Transparency = 1 else d.Transparency = CM._invBackup[d] or 0 end
elseif d:IsA("Accessory") then
local h = d:FindFirstChild("Handle")
if h and h:IsA("BasePart") then
if on then CM._invBackup[h] = h.Transparency h.Transparency = 1 h.CastShadow = false
else h.Transparency = CM._invBackup[h] or 0 h.CastShadow = true end
end
elseif d:IsA("ParticleEmitter") or d:IsA("Trail") then
d.Enabled = not on
elseif d:IsA("BillboardGui") or d:IsA("Highlight") then
d.Enabled = not on
end
end
end
local function InvisibleEnable()
if CM._invConn then return end
local ch, hum = GC()
if not ch then return end
if hum then
CM._invDisplayBackup = hum.DisplayDistanceType
pcall(function() hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
end
InvisibleApply(ch, true)
CM._invAddedConn = ch.DescendantAdded:Connect(function(d)
pcall(function()
if d:IsA("BasePart") then
d.Transparency = 1
d.CastShadow = false
elseif d:IsA("Decal") or d:IsA("Texture") then
d.Transparency = 1
elseif d:IsA("Accessory") then
local h = d:FindFirstChild("Handle")
if h and h:IsA("BasePart") then
h.Transparency = 1
h.CastShadow = false
end
elseif d:IsA("BillboardGui") or d:IsA("Highlight") then
d.Enabled = false
elseif d:IsA("ParticleEmitter") or d:IsA("Trail") then
d.Enabled = false
end
end)
end)
CM._invConn = RS.RenderStepped:Connect(function()
if not T.Invisible then return end
local c = LP.Character
if not c then return end
InvisibleApply(c, true)
local h = c:FindFirstChildOfClass("Humanoid")
if h and h.DisplayDistanceType ~= Enum.HumanoidDisplayDistanceType.None then
pcall(function() h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end)
end
end)
end
local function InvisibleDisable()
if CM._invConn then CM._invConn:Disconnect() CM._invConn = nil end
if CM._invAddedConn then CM._invAddedConn:Disconnect() CM._invAddedConn = nil end
local ch, hum = GC()
InvisibleApply(ch, false)
CM._invBackup = nil
if hum and CM._invDisplayBackup ~= nil then
pcall(function() hum.DisplayDistanceType = CM._invDisplayBackup end)
CM._invDisplayBackup = nil
end
end
local ESPGui = nil
local ESPObjs = {}
local ESPConn = nil
local ESPHue = 0
local function espInit()
if ESPGui and ESPGui.Parent then return end
ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "CheatMenu_ESP"
ESPGui.ResetOnSpawn = false
ESPGui.IgnoreGuiInset = true
ESPGui.Parent = gethui and gethui() or game:GetService("CoreGui")
end
local function espRemove(pl)
local o = ESPObjs[pl]
if o then
for _, inst in pairs(o) do pcall(function() inst:Destroy() end) end
ESPObjs[pl] = nil
end
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
o.top = edge(o.box)
o.bottom = edge(o.box)
o.left = edge(o.box)
o.right = edge(o.box)
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
local function espIsTeammate(pl)
if not T.ESPTeamColor then return false end
return pl.Team ~= nil and pl.Team == LP.Team
end
local function espIsFriend(pl)
if not T.ESPFriendColor then return false end
local ok, res = pcall(function() return LP:IsFriendsWith(pl.UserId) end)
return ok and res == true
end
local function espColorFor(pl)
if T.ESPRainbow then return Color3.fromHSV(ESPHue, 1, 1) end
if espIsTeammate(pl) then return Color3.fromRGB(90, 220, 120) end
if espIsFriend(pl) then return Color3.fromRGB(90, 160, 255) end
return Color3.fromRGB(255, 90, 90)
end
local function espUpdate()
if T.ESPRainbow then ESPHue = (ESPHue + 0.008) % 1 end
local cam = workspace.CurrentCamera
if not cam then return end
local vp = cam.ViewportSize
for pl, o in pairs(ESPObjs) do
local col = espColorFor(pl)
local ch = pl.Character
local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hrp and hum and hum.Health > 0 then
local pos, onScreen = cam:WorldToScreenPoint(hrp.Position)
if onScreen then
local dist = (cam.CFrame.Position - hrp.Position).Magnitude
local h = math.clamp(600 / math.max(1, dist), 20, 320)
local w = h * 0.6
local x, y = pos.X - w / 2, pos.Y - h / 2
o.box.Visible = T.ESPBox ~= false
o.box.Position = UDim2.fromOffset(x, y)
o.box.Size = UDim2.fromOffset(w, h)
o.top.Position = UDim2.fromOffset(0, 0) o.top.Size = UDim2.new(1, 0, 0, 1) o.top.BackgroundColor3 = col
o.bottom.Position = UDim2.new(0, 0, 1, -1) o.bottom.Size = UDim2.new(1, 0, 0, 1) o.bottom.BackgroundColor3 = col
o.left.Position = UDim2.fromOffset(0, 0) o.left.Size = UDim2.new(0, 1, 1, 0) o.left.BackgroundColor3 = col
o.right.Position = UDim2.new(1, -1, 0, 0) o.right.Size = UDim2.new(0, 1, 1, 0) o.right.BackgroundColor3 = col
o.name.Visible = T.ESPName ~= false
o.name.Position = UDim2.fromOffset(x, y - 16)
o.name.Size = UDim2.fromOffset(w, 16)
local tag = ""
if espIsTeammate(pl) then tag = " [队]"
elseif espIsFriend(pl) then tag = " [友]"
elseif T.ESPTeamColor then tag = " [敌]" end
o.name.Text = pl.Name .. tag
o.name.TextColor3 = col
o.dist.Visible = T.ESPDist ~= false
o.dist.Position = UDim2.fromOffset(x, y + h)
o.dist.Size = UDim2.fromOffset(w, 14)
o.dist.Text = ("[%.0f]"):format(dist)
o.hp.Visible = T.ESPHealth ~= false
o.hp.Position = UDim2.fromOffset(x - 6, y)
o.hp.Size = UDim2.new(0, 3, math.clamp(hum.Health / math.max(1, hum.MaxHealth), 0, 1), 0)
o.tracer.Visible = T.ESPTracer ~= false
local dx, dy = pos.X - vp.X / 2, pos.Y - vp.Y
local len = math.sqrt(dx * dx + dy * dy)
local ang = math.deg(math.atan2(dy, dx))
o.tracer.Position = UDim2.fromOffset(vp.X / 2, vp.Y)
o.tracer.Size = UDim2.fromOffset(len, 1)
o.tracer.Rotation = ang
o.tracer.BackgroundColor3 = col
else
o.box.Visible = false o.name.Visible = false o.dist.Visible = false o.hp.Visible = false o.tracer.Visible = false
end
else
o.box.Visible = false o.name.Visible = false o.dist.Visible = false o.hp.Visible = false o.tracer.Visible = false
end
end
end
local function ESPEnable()
espInit()
for _, pl in ipairs(Players:GetPlayers()) do espCreate(pl) end
Players.PlayerAdded:Connect(function(pl)
pl.CharacterAdded:Connect(function() task.wait(0.3) espCreate(pl) end)
end)
Players.PlayerRemoving:Connect(espRemove)
if not ESPConn then ESPConn = RS.RenderStepped:Connect(espUpdate) end
end
local function ESPDisable()
if ESPConn then ESPConn:Disconnect() ESPConn = nil end
for pl in pairs(ESPObjs) do espRemove(pl) end
ESPObjs = {}
end
local BulletHls = {}
local BulletConn = nil
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
local function BulletTracerDisable()
if BulletConn then BulletConn:Disconnect() BulletConn = nil end
for _, hl in ipairs(BulletHls) do pcall(function() hl:Destroy() end) end
BulletHls = {}
end
local AutoInteractConn = nil
local InstantPromptConn = nil
local function AutoInteractEnable()
if AutoInteractConn then return end
AutoInteractConn = RS.Stepped:Connect(function()
if not T.AutoInteract then return end
local _, _, r = GC()
if not r then return end
for _, p in ipairs(workspace:GetDescendants()) do
if p:IsA("ProximityPrompt") and p.Enabled then
local pp = p.Parent
local pos = pp and (pp:IsA("BasePart") and pp.Position or nil)
if pos and (r.Position - pos).Magnitude <= (p.MaxActivationDistance or 10) then
if type(fireproximityprompt) == "function" then
pcall(fireproximityprompt, p)
else
pcall(function() p:InputHoldBegin() task.wait(0.05) p:InputHoldEnd() end)
end
end
end
end
task.wait(1)
end)
end
local function AutoInteractDisable()
if AutoInteractConn then AutoInteractConn:Disconnect() AutoInteractConn = nil end
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
InstantPromptConn = workspace.DescendantAdded:Connect(function(d)
if T.InteractBoost or T.InstantPrompt then maxOut(d) end
end)
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
print("[CheatMenu] 徽章/群组本地绕过已开启(仅对客户端检查有效)")
end
local function MetaBypassEnable()
if not (getgc and islclosure) then return end
local function wipeMeta(v)
if type(v) == "userdata" then
pcall(function() setmetatable(v, nil) end)
end
end
local function findAndWipe(kw)
for _, v in ipairs(getgc()) do
if type(v) == "function" and islclosure(v) then
local ok, info = pcall(debug.getinfo, v, "n")
if ok and info and info.name and info.name:lower():find(kw, 1, true) then
for i = 1, 20 do
local n, uv = debug.getupvalue(v, i)
if not n then break end
wipeMeta(uv)
if type(uv) == "table" then
for _, sub in pairs(uv) do wipeMeta(sub) end
end
end
end
end
end
end
for _, kw in ipairs({ "anti", "detect", "ban", "cheat", "flag" }) do findAndWipe(kw) end
print("[CheatMenu] MetaBypass 已执行(函数定位+元表清空)")
end
local function ChatBypassEnable()
if not hookfunction then
print("[CheatMenu] 执行器不支持 hookfunction，聊天绕过不可用")
return
end
local tcs = game:GetService("TextChatService")
if not (tcs and tcs.TextChannels) then return end
local hooked = false
for _, channel in ipairs(tcs.TextChannels:GetChildren()) do
if channel:IsA("TextChannel") and channel.SendAsync then
local oldSend = channel.SendAsync
pcall(function()
hookfunction(oldSend, function(self, text, ...)
if T.ChatBypass and type(text) == "string" then
text = text:gsub("(.)", "%1\226\128\139")
end
return oldSend(self, text, ...)
end)
end)
hooked = true
end
end
if hooked then print("[CheatMenu] 自动聊天绕过已开启(正常聊天框直接发)") end
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
Players.PlayerAdded:Connect(function(pl)
pl.CharacterAdded:Connect(function() addHitbox(pl) end)
end)
end
local function HitboxDisable()
for _, e in ipairs(HitboxList) do
pcall(function() e.conn:Disconnect() end)
pcall(function() e.box:Destroy() end)
end
HitboxList = {}
end
local FlyCarConn = nil
local function FlyCarEnable()
if FlyCarConn then return end
FlyCarConn = RS.RenderStepped:Connect(function(dt)
if not T.FlyCar then return end
local _, _, root = GC()
if not root then return end
local seat = root.Parent
if not (seat and seat:IsA("VehicleSeat") or seat and seat:IsA("Seat")) then
seat = nil
for _, s in ipairs(workspace:GetDescendants()) do
if (s:IsA("VehicleSeat") or s:IsA("Seat")) and s.Occupant == LP.Character then seat = s break end
end
end
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
if dir.Magnitude > 0 then
body.CFrame = body.CFrame + dir.Unit * (C.FlyCarSpeed or 50) * math.min(dt, 0.1)
end
end)
end
local function FlyCarDisable()
if FlyCarConn then FlyCarConn:Disconnect() FlyCarConn = nil end
end
local function TeleportOnDeathEnable()
local target = getTPTargetPlayer()
LP.CharacterAdded:Connect(function()
task.wait(0.5)
if T.TeleportOnDeath then TeleportToPlayer(target) end
end)
end
local function FOVEnable()
workspace.CurrentCamera.FieldOfView = C.FOV or 100
end
local function FOVDisable()
workspace.CurrentCamera.FieldOfView = 70
end
local function ZoomEnable()
LP.CameraMaxZoomDistance = C.Zoom or 400
LP.CameraMinZoomDistance = 0.5
end
local function ZoomDisable()
LP.CameraMaxZoomDistance = 128
LP.CameraMinZoomDistance = 0.5
end
local XrayHls = {}
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
local function XrayDisable()
for _, hl in ipairs(XrayHls) do pcall(function() hl:Destroy() end) end
XrayHls = {}
end
local SelfGlowHl = nil
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
local function SelfGlowDisable()
if SelfGlowHl then SelfGlowHl:Destroy() SelfGlowHl = nil end
end
local function MuteEnable()
for _, s in ipairs(workspace:GetDescendants()) do
if s:IsA("Sound") then s.Volume = 0 end
end
end
local savedLag = nil
local function AntilagEnable()
local L = game:GetService("Lighting")
if not savedLag then
savedLag = {
GlobalShadows = L.GlobalShadows, FogEnd = L.FogEnd, FogStart = L.FogStart,
Brightness = L.Brightness, ClockTime = L.ClockTime, Ambient = L.Ambient,
}
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
L.GlobalShadows = false
L.FogEnd = 9e9
L.FogStart = 9e9
L.Brightness = 1
local ok, settingsTable = pcall(function() return settings() end)
if ok and settingsTable then
pcall(function() settingsTable.Rendering.QualityLevel = 1 end)
end
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("BasePart") then
pcall(function() v.CastShadow = false end)
end
end
print("[CheatMenu] 降画质已开启(关阴影/去水波/关雾)")
end
local function AntilagDisable()
local L = game:GetService("Lighting")
if not savedLag then return end
L.GlobalShadows = savedLag.GlobalShadows
L.FogEnd = savedLag.FogEnd
L.FogStart = savedLag.FogStart
L.Brightness = savedLag.Brightness
L.ClockTime = savedLag.ClockTime
L.Ambient = savedLag.Ambient
savedLag = nil
end
local function Rejoin()
local ts = game:GetService("TeleportService")
pcall(function() ts:Teleport(game.PlaceId, LP) end)
end
local ToolGlowHl = nil
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
local function ToolGlowDisable()
if ToolGlowHl then ToolGlowHl:Destroy() ToolGlowHl = nil end
end
return {
FlyDisable = FlyDisable,
FlyEnable = FlyEnable,
SpeedEnable = SpeedEnable,
SpeedDisable = SpeedDisable,
InfiniteJumpEnable = InfiniteJumpEnable,
SpinEnable = SpinEnable,
SpinDisable = SpinDisable,
AirWalkEnable = AirWalkEnable,
AirWalkDisable = AirWalkDisable,
NoClipEnable = NoClipEnable,
NoClipDisable = NoClipDisable,
HideEnable = HideEnable,
HideDisable = HideDisable,
FullBrightEnable = FullBrightEnable,
FullBrightDisable = FullBrightDisable,
NightVisionEnable = NightVisionEnable,
NightVisionDisable = NightVisionDisable,
NoFogEnable = NoFogEnable,
NoFogDisable = NoFogDisable,
TeleportToPlayer = TeleportToPlayer,
getTPTargetPlayer = getTPTargetPlayer,
CircleEnable = CircleEnable,
CircleDisable = CircleDisable,
SpectateEnable = SpectateEnable,
SpectateDisable = SpectateDisable,
savePosition = savePosition,
teleportToSaved = teleportToSaved,
ClickerEnable = ClickerEnable,
ClickerDisable = ClickerDisable,
ServerHop = ServerHop,
AimDisable = AimDisable,
getAimTarget = getAimTarget,
AimEnable = AimEnable,
SilentAimEnable = SilentAimEnable,
SilentAimDisable = SilentAimDisable,
SilentAimGhostEnable = SilentAimGhostEnable,
SilentAimGhostDisable = SilentAimGhostDisable,
SingleAimEnable = SingleAimEnable,
SingleAimDisable = SingleAimDisable,
FaceLockEnable = FaceLockEnable,
FaceLockDisable = FaceLockDisable,
FlingTarget = FlingTarget,
GodEnable = GodEnable,
GodDisable = GodDisable,
InvisibleEnable = InvisibleEnable,
InvisibleDisable = InvisibleDisable,
espAdd = espAdd,
ESPEnable = ESPEnable,
ESPDisable = ESPDisable,
BulletTracerEnable = BulletTracerEnable,
BulletTracerDisable = BulletTracerDisable,
AutoInteractEnable = AutoInteractEnable,
AutoInteractDisable = AutoInteractDisable,
InstantPromptEnable = InstantPromptEnable,
BadgeBypassEnable = BadgeBypassEnable,
MetaBypassEnable = MetaBypassEnable,
wipeMeta = wipeMeta,
findAndWipe = findAndWipe,
ChatBypassEnable = ChatBypassEnable,
addHitbox = addHitbox,
HitboxEnable = HitboxEnable,
HitboxDisable = HitboxDisable,
FlyCarEnable = FlyCarEnable,
FlyCarDisable = FlyCarDisable,
TeleportOnDeathEnable = TeleportOnDeathEnable,
FOVEnable = FOVEnable,
FOVDisable = FOVDisable,
ZoomEnable = ZoomEnable,
ZoomDisable = ZoomDisable,
XrayEnable = XrayEnable,
XrayDisable = XrayDisable,
SelfGlowEnable = SelfGlowEnable,
SelfGlowDisable = SelfGlowDisable,
MuteEnable = MuteEnable,
Rejoin = Rejoin,
ToolGlowEnable = ToolGlowEnable,
ToolGlowDisable = ToolGlowDisable,
}
end)()
if getgenv then getgenv().CM = CM end
do local GAME = (function()
local function getBackpackTools()
local out = {}
local bp = LP:FindFirstChild("Backpack")
local ch = LP.Character
for _, parent in ipairs({ bp, ch }) do
if parent then
for _, t in ipairs(parent:GetChildren()) do
if t:IsA("Tool") and isEntityTool(t) then out[#out + 1] = t end
end
end
end
return out
end
local UIKeywordThreads = {}
local function uiKeywordLoop(id, keywords, interval, afterFire)
if UIKeywordThreads[id] then return end
UIKeywordThreads[id] = task.spawn(function()
while T[id] do
local hit = false
for _, btn in ipairs(visibleGuiButtons()) do
local blob = guiTextBlob(btn)
for _, kw in ipairs(keywords) do
if blob:find(kw, 1, true) then
if clickGuiButton(btn) then
hit = true
if afterFire then task.delay(0.02, afterFire) end
break
end
end
end
if hit then break end
end
task.wait(interval or 1)
end
UIKeywordThreads[id] = nil
end)
end
local function AutoRebirthEnable() uiKeywordLoop("AutoRebirth", { "rebirth", "reborn", "prestige" }, 2) end
local function AutoUpgradeEnable() uiKeywordLoop("AutoUpgrade", { "upgrade" }, 1) end
local function AutoSpinEnable() uiKeywordLoop("AutoSpin", { "spin", "wheel", "lucky wheel" }, 2) end
local function AutoClaimEnable() uiKeywordLoop("AutoClaim", { "claim", "reward", "free", "offline", "gift", "daily" }, 2) end
local function AutoSkipWaveEnable() uiKeywordLoop("AutoSkipWave", { "skip", "skip wave", "next wave" }, 1) end
local SniperThread = nil
local function SniperEnable()
if SniperThread then return end
SniperThread = task.spawn(function()
while T.Sniper do
local tName = tostring(C.SniperName or ""):lower()
local tMut = tostring(C.SniperMutation or ""):lower()
if tName ~= "" or tMut ~= "" then
local _, hum = GC()
if hum then
for _, t in ipairs(getBackpackTools()) do
local nm = t.Name:lower()
local mut = tostring(t:GetAttribute("Mutation") or ""):lower()
local nameHit = tName ~= "" and nm:find(tName, 1, true)
local mutHit = tMut ~= "" and mut:find(tMut, 1, true)
if nameHit or mutHit then
pcall(function() hum:EquipTool(t) end)
break
end
end
end
end
task.wait(1)
end
end)
end
local function SniperDisable() SniperThread = nil end
local PlaceBestThread = nil
local function AutoPlaceBestEnable()
if PlaceBestThread then return end
PlaceBestThread = task.spawn(function()
while T.PlaceBest do
local _, hum = GC()
if hum then
local best, bestCPS = nil, -1
for _, t in ipairs(getBackpackTools()) do
local cps = getBrainrotCPS(t)
if cps and cps > bestCPS then bestCPS = cps best = t end
end
if best then
pcall(function() hum:UnequipTools() end)
task.wait(0.1)
pcall(function() hum:EquipTool(best) end)
task.wait(0.3)
for slot = 1, (C.PlaceBestSlots or 30) do
if not T.PlaceBest then break end
Fire("S_Interact", slot)
task.wait(0.08)
end
end
end
task.wait(2)
end
end)
end
local function AutoPlaceBestDisable() PlaceBestThread = nil end
local BlockESPObjs = {}
local BlockESPConn = nil
local function blockESPTag(obj)
if not (T.BlockESP or T.BrainrotESP) then return end
if not (obj:IsA("BasePart") or obj:IsA("Model")) then return end
local nm = obj.Name:lower()
local isBlock = nm:find("lucky", 1, true) or nm:find("block", 1, true) or nm:find("kick", 1, true)
local isBrainrot = nm:find("brainrot", 1, true) or nm:find("brain", 1, true) or obj:FindFirstChildOfClass("Tool") ~= nil
if (T.BlockESP and isBlock) or (T.BrainrotESP and isBrainrot) then
local hl = Instance.new("Highlight")
hl.FillColor = isBlock and Color3.fromRGB(255, 220, 0) or Color3.fromRGB(0, 255, 200)
hl.FillTransparency = 0.55
hl.OutlineColor = hl.FillColor
hl.OutlineTransparency = 0
hl.Parent = obj
BlockESPObjs[#BlockESPObjs + 1] = hl
end
end
local function BlockESPEnable()
if BlockESPConn then return end
for _, obj in ipairs(workspace:GetDescendants()) do blockESPTag(obj) end
BlockESPConn = workspace.DescendantAdded:Connect(blockESPTag)
end
local function BlockESPDisable()
if T.BlockESP or T.BrainrotESP then
for _, hl in ipairs(BlockESPObjs) do pcall(function() hl:Destroy() end) end
BlockESPObjs = {}
for _, obj in ipairs(workspace:GetDescendants()) do blockESPTag(obj) end
return
end
if BlockESPConn then BlockESPConn:Disconnect() BlockESPConn = nil end
for _, hl in ipairs(BlockESPObjs) do pcall(function() hl:Destroy() end) end
BlockESPObjs = {}
end
return {
AutoRebirthEnable = AutoRebirthEnable,
AutoUpgradeEnable = AutoUpgradeEnable,
AutoSpinEnable = AutoSpinEnable,
AutoClaimEnable = AutoClaimEnable,
AutoSkipWaveEnable = AutoSkipWaveEnable,
SniperEnable = SniperEnable,
SniperDisable = SniperDisable,
AutoPlaceBestEnable = AutoPlaceBestEnable,
AutoPlaceBestDisable = AutoPlaceBestDisable,
BlockESPEnable = BlockESPEnable,
BlockESPDisable = BlockESPDisable,
}
end)()
if getgenv then getgenv().GAME = GAME end
end
local function tblHasFunc(t, key)
if type(t) ~= "table" then return false end
local ok, v = pcall(rawget, t, key)
return ok and type(v) == "function"
end
local function tblHasVal(t, key)
if type(t) ~= "table" then return false end
local ok, v = pcall(rawget, t, key)
return ok and v ~= nil
end
local function scanGameModules()
local modCount = 0
print("[模块扫描] ===== 已加载模块 =====")
if type(getloadedmodules) == "function" then
local ok, mods = pcall(getloadedmodules)
if ok and type(mods) == "table" then
for _, m in ipairs(mods) do
if typeof(m) == "Instance" and m:IsA("ModuleScript") then
modCount = modCount + 1
print("[模块扫描] " .. m:GetFullName())
end
end
end
end
print("[模块扫描] 共 " .. modCount .. " 个 ModuleScript")
local nilCount = 0
if type(getnilinstances) == "function" then
print("[模块扫描] ===== nil-parented 隐藏实例 =====")
pcall(function()
for _, inst in ipairs(getnilinstances()) do
if typeof(inst) == "Instance" then
nilCount = nilCount + 1
if nilCount <= 60 then
local cls = "?"
pcall(function() cls = inst.ClassName end)
print("[模块扫描] nil# " .. cls .. " :: " .. tostring(inst.Name))
end
end
end
end)
print("[模块扫描] 共 " .. nilCount .. " 个 nil-parented 实例")
end
print("[模块扫描] ===== 函数反作弊特征(名字/常量) =====")
local funcTotal, acFuncCount = 0, 0
if type(getgc) == "function" then
pcall(function()
local seen = 0
for _, obj in ipairs(getgc(true)) do
seen = seen + 1
if seen > 8000 then break end
if type(obj) == "function" then
funcTotal = funcTotal + 1
local fname, fsrc = "?", "?"
pcall(function()
local info = debug.getinfo(obj, "nS")
if info then fname = info.name or "?" fsrc = info.short_src or info.source or "?" end
end)
local consts, hasAC = {}, false
pcall(function()
local cs = debug.getconstants(obj)
for _, c in ipairs(cs) do
if type(c) == "string" then
if AC.isSuspicious(c) then hasAC = true end
if #consts < 6 then consts[#consts + 1] = c end
end
end
end)
if AC.isSuspicious(fname) or AC.isSuspicious(fsrc) then hasAC = true end
if hasAC then
acFuncCount = acFuncCount + 1
if acFuncCount <= 50 then
print(string.format("[模块扫描] ⚠ name=%s src=%s 常量=[%s]", fname, fsrc, table.concat(consts, ",")))
end
end
end
end
end)
print(string.format("[模块扫描] 扫 %d 个函数，反作弊特征 %d 个", funcTotal, acFuncCount))
end
return modCount, funcTotal, acFuncCount
end
local AllConns = {}
local function addConn(conn)
if conn then table.insert(AllConns, conn) end
return conn
end
local function disconnectAllConns()
for _, c in ipairs(AllConns) do pcall(function() c:Disconnect() end) end
AllConns = {}
end
local AutoTouchConn = nil
local function AutoTouchEnable()
if AutoTouchConn then return end
if type(firetouchinterest) ~= "function" then
print("[CheatMenu] 执行器不支持 firetouchinterest，自动触摸不可用")
return
end
AutoTouchConn = RS.Heartbeat:Connect(function()
if not T.AutoTouch then return end
local _, _, root = GC()
if not root then return end
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("BasePart") and v.CanTouch then
pcall(function()
firetouchinterest(v, root, 0)
firetouchinterest(v, root, 1)
end)
end
end
task.wait(0.5)
end)
end
local function AutoTouchDisable()
if AutoTouchConn then AutoTouchConn:Disconnect() AutoTouchConn = nil end
end
local function NoPromptLimitEnable()
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("ProximityPrompt") or v:IsA("ClickDetector") then
pcall(function() v.MaxActivationDistance = math.huge end)
end
end
print("[CheatMenu] 互动无距离已开启")
end
local function NoPromptCooldownEnable()
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("ProximityPrompt") then
pcall(function()
v.HoldDuration = 0
v.MaxActivationDistance = math.huge
end)
end
end
end
local function FireAllTouches()
if type(firetouchinterest) ~= "function" then return end
local _, _, root = GC()
if not root then return end
local n = 0
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("BasePart") and v.CanTouch then
pcall(function()
firetouchinterest(v, root, 0)
firetouchinterest(v, root, 1)
end)
n = n + 1
end
end
print("[CheatMenu] 已触发 " .. n .. " 个触摸互动")
end
local FlyBv, FlyBg, FlyBvConn = nil, nil, nil
local function FlyPhysDisable()
if FlyBv then pcall(function() FlyBv:Destroy() end) FlyBv = nil end
if FlyBg then pcall(function() FlyBg:Destroy() end) FlyBg = nil end
end
local function FlyPhysEnable()
local _, hum, root = GC()
if not (hum and root) then return end
FlyPhysDisable()
hum.PlatformStand = true
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
if not T.FlyPhys then FlyPhysDisable() return end
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
FlyBv.Velocity = dir.Unit * (C.FlySpeed or 50) * (dir.Magnitude > 0 and 1 or 0)
FlyBg.CFrame = cam.CFrame
end)
end
local function FireAllClickDetectors()
local n = 0
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("ClickDetector") then
if type(fireclickdetector) == "function" then
pcall(fireclickdetector, v)
else
pcall(function() v.MouseClick:Fire() end)
end
n = n + 1
end
end
print("[CheatMenu] 已触发 " .. n .. " 个 ClickDetector")
end
local function NoClickLimit()
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("ClickDetector") then pcall(function() v.MaxActivationDistance = math.huge end) end
end
end
local PropWatchConn = nil
local function PropWatchEnable()
if PropWatchConn then return end
local ch = LP.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if not hum then return end
PropWatchConn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
if T.WalkSpeedLock and T.Speed then
hum.WalkSpeed = (C.SpeedMul or 2) * 16
end
end)
end
local function listConnections()
local n = 0
if type(getconnections) == "function" then
local ok, conns = pcall(getconnections, LP.Idled)
if ok and type(conns) == "table" then n = #conns end
end
print("[CheatMenu] getconnections 可用，Idled 连接数=" .. n)
end
local function setQueueOnTeleport(code)
if type(queue_on_teleport) == "function" then
pcall(queue_on_teleport, code or "")
print("[CheatMenu] queue_on_teleport 已设置")
else
print("[CheatMenu] 执行器不支持 queue_on_teleport")
end
end
local SavedPositions = {}
local function savePosSlot(slot)
local _, _, r = GC()
if r then SavedPositions[slot] = r.CFrame print("[CheatMenu] 已保存位置 " .. slot) end
end
local function tpToSlot(slot)
local _, _, r = GC()
if r and SavedPositions[slot] then r.CFrame = SavedPositions[slot] end
end
local function copyToClipboard(text)
if type(setclipboard) == "function" then
pcall(setclipboard, tostring(text or ""))
Fluent:Notify({ Title = "剪贴板", Content = "已复制", Duration = 2 })
end
end
local SKELETON = {
{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},
{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
}
local SkeletonLines = {}
local function SkeletonEnable()
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then
for i = 1, #SKELETON do
local line = Instance.new("LineHandleAdornment")
line.Adornee = pl.Character
line.Thickness = 2
line.Color3 = Color3.fromRGB(0, 255, 150)
line.Transparency = 0
line.AlwaysOnTop = true
line.ZIndex = 5
line.Parent = pl.Character
SkeletonLines[#SkeletonLines + 1] = line
end
end
end
end
local function SkeletonDisable()
for _, l in ipairs(SkeletonLines) do pcall(function() l:Destroy() end) end
SkeletonLines = {}
end
local ArrowConns = {}
local function ArrowEnable()
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then
local ch = pl.Character
local bb = Instance.new("BillboardGui")
bb.Name = "CheatArrow"
bb.Size = UDim2.fromOffset(40, 40)
bb.StudsOffset = Vector3.new(0, 3.5, 0)
bb.AlwaysOnTop = true
bb.Parent = ch
local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.fromScale(1, 1)
lbl.BackgroundTransparency = 1
lbl.Text = "▼"
lbl.TextSize = 40
lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
lbl.Parent = bb
end
end
end
local function ArrowDisable()
for _, pl in ipairs(Players:GetPlayers()) do
local ch = pl.Character
if ch then
local bb = ch:FindFirstChild("CheatArrow")
if bb then bb:Destroy() end
end
end
end
local ACBreakers = {}
local function ACBypassPlusEnable()
if type(getconnections) == "function" then
pcall(function()
for _, c in ipairs(getconnections(game:GetService("ScriptContext").Error)) do
if c.Disconnect then pcall(function() c:Disconnect() end) end
end
end)
end
if type(getgc) == "function" and type(getrawmetatable) == "function" then
pcall(function()
for _, o in ipairs(getgc(true)) do
if type(o) == "table" then
local mt = getrawmetatable(o)
if mt then ACBreakers[#ACBreakers + 1] = {o = o, mt = mt} end
end
end
end)
end
print("[CheatMenu] 反作弊绕过增强已执行")
end
function AC.AntiPauseEnable()
if AC._noPauseConn then return end
AC._noPauseConn = CoreGui.RobloxGui.ChildAdded:Connect(function(obj)
if obj.Name == "CoreScripts/NetworkPause" then
pcall(function() obj:Destroy() end)
end
end)
pcall(function()
local np = CoreGui.RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
if np then np:Destroy() end
end)
print("[CheatMenu] 防游戏暂停已开启(销毁 NetworkPause)")
end
function AC.AntiPauseDisable()
if AC._noPauseConn then AC._noPauseConn:Disconnect() AC._noPauseConn = nil end
end
local VCBackup = nil
local function VoiceBypassEnable()
pcall(function()
local vcs = game:GetService("VoiceChatService")
if vcs then
VCBackup = {}
for _, k in ipairs({"EnableVoiceChat", "EnableVoiceChatForUser"}) do
pcall(function() VCBackup[k] = vcs[k] end)
end
pcall(function() vcs.EnableVoiceChat = true end)
end
end)
pcall(function()
for _, attr in ipairs({"VoiceChatEnabled", "voiceEnabled", "VCEnabled", "MicEnabled", "isMuted", "Muted"}) do
if LP:GetAttribute(attr) ~= nil then LP:SetAttribute(attr, true) end
end
end)
if hookmetamethod and newcclosure then
pcall(function()
local gmt = getrawmetatable(game)
if gmt then
local old = gmt.__namecall
if old then
setreadonly(gmt, false)
gmt.__namecall = newcclosure(function(self, ...)
local method = getnamecallmethod and getnamecallmethod() or ""
if T.VoiceBypass and type(method) == "string"
and (method:lower():find("mute") or method:lower():find("voice")) then
return true
end
return old(self, ...)
end)
setreadonly(gmt, true)
end
end
end)
end
print("[CheatMenu] 语音绕过已开启(客户端尽力启用)")
end
local function VoiceBypassDisable()
if VCBackup then
pcall(function()
local vcs = game:GetService("VoiceChatService")
for k, v in pairs(VCBackup) do if v ~= nil then vcs[k] = v end end
end)
VCBackup = nil
end
end
local HitboxBackup = {}
local function HitboxExpandEnable()
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character and not HitboxBackup[pl] then
local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
if hrp then
HitboxBackup[pl] = hrp.Size
local s = C.HitboxSize or 10
pcall(function()
hrp.Size = Vector3.new(s, s, s)
hrp.Transparency = C.HitboxVisible and 0.6 or 1
hrp.CanCollide = false
hrp.Massless = true
end)
end
end
end
end
local function HitboxExpandDisable()
for pl, size in pairs(HitboxBackup) do
local ch = pl.Character
local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
if hrp then pcall(function() hrp.Size = size hrp.Massless = false end) end
end
HitboxBackup = {}
end
local KillAuraConn = nil
local function KillAuraEnable()
if KillAuraConn then return end
KillAuraConn = RS.Heartbeat:Connect(function()
if not T.KillAura then return end
local _, _, root = GC()
if not root then return end
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then
local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
local hum = pl.Character:FindFirstChildOfClass("Humanoid")
if hrp and hum and hum.Health > 0 and (root.Position - hrp.Position).Magnitude <= (C.KillAuraRange or 20) then
if type(mouse1click) == "function" then
pcall(mouse1click)
elseif type(mouse1press) == "function" then
pcall(function() mouse1press() task.wait(0.01) mouse1release() end)
end
break
end
end
end
task.wait(0.1)
end)
end
local function KillAuraDisable()
if KillAuraConn then KillAuraConn:Disconnect() KillAuraConn = nil end
end
local RecoilConn = nil
local function NoRecoilEnable()
if RecoilConn then return end
local cam = workspace.CurrentCamera
RecoilConn = RS.RenderStepped:Connect(function()
if not T.NoRecoil then return end
local c = workspace.CurrentCamera
if c then
c.CFrame = CFrame.new(c.CFrame.Position, c.CFrame.Position + c.CFrame.LookVector)
end
end)
end
local function NoRecoilDisable()
if RecoilConn then RecoilConn:Disconnect() RecoilConn = nil end
end
local PickupConn = nil
local function AutoPickupEnable()
if PickupConn then return end
PickupConn = RS.Heartbeat:Connect(function()
if not T.AutoPickup then return end
local _, _, root = GC()
if not root then return end
if type(firetouchinterest) ~= "function" then return end
for _, v in ipairs(workspace:GetChildren()) do
if v:IsA("BasePart") and v.CanTouch and (root.Position - v.Position).Magnitude <= (C.PickupRange or 15) then
pcall(function()
firetouchinterest(v, root, 0)
firetouchinterest(v, root, 1)
end)
end
end
task.wait(0.2)
end)
end
local function AutoPickupDisable()
if PickupConn then PickupConn:Disconnect() PickupConn = nil end
end
local ClickTPConn = nil
local function ClickTPEnable()
if ClickTPConn then return end
ClickTPConn = UIS.InputBegan:Connect(function(input, gpe)
if gpe or not T.ClickTP then return end
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
local cam = workspace.CurrentCamera
local _, _, root = GC()
if not (cam and root) then return end
local ray = cam:ViewportPointToRay(input.Position.X, input.Position.Y)
local params = RaycastParams.new()
params.FilterDescendantsInstances = { LP.Character }
params.FilterType = Enum.RaycastFilterType.Exclude
local hit = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
if hit then
root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
end
end
end)
end
local function ClickTPDisable()
if ClickTPConn then ClickTPConn:Disconnect() ClickTPConn = nil end
end
local function tpToCoords(x, y, z)
local _, _, root = GC()
if root and tonumber(x) and tonumber(y) and tonumber(z) then
smoothTP(CFrame.new(tonumber(x), tonumber(y), tonumber(z)))
end
end
local VoidConn = nil
local function AntiVoidEnable()
if VoidConn then return end
local lastSafe = nil
VoidConn = RS.Heartbeat:Connect(function()
if not T.AntiVoid then return end
local _, _, root = GC()
if not root then return end
if root.Position.Y > (C.VoidY or -50) then
lastSafe = root.CFrame
else
if lastSafe then root.CFrame = lastSafe end
end
task.wait(0.3)
end)
end
local function AntiVoidDisable()
if VoidConn then VoidConn:Disconnect() VoidConn = nil end
end
local AutoRespawnConn = nil
local function AutoRespawnEnable()
if AutoRespawnConn then return end
AutoRespawnConn = LP.CharacterAdded:Connect(function()
task.wait(0.5)
if T.AutoRespawn then
local _, hum = GC()
if hum and hum.Health <= 0 then
pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
end
end
end)
RS.Heartbeat:Connect(function()
if not T.AutoRespawn then return end
local ch = LP.Character
local hum = ch and ch:FindFirstChildOfClass("Humanoid")
if hum and hum.Health <= 0 then
pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
end
task.wait(1)
end)
end
local BringConn = nil
local BRING_KEYS = {"money", "bond", "item", "loot", "bag", "coin", "drop", "ore", "gold", "cash", "gem", "crate", "supply", "ammo", "weapon", "armor"}
local function BringItemsEnable()
if BringConn then return end
BringConn = RS.Heartbeat:Connect(function()
if not T.BringItems then return end
local _, _, root = GC()
if not root then return end
for _, v in ipairs(workspace:GetDescendants()) do
if v ~= LP.Character and (v:IsA("BasePart") or v:IsA("Model")) then
local n = v.Name:lower()
local match = false
for _, k in ipairs(BRING_KEYS) do if n:find(k, 1, true) then match = true break end end
if match then
local part = v:IsA("BasePart") and v or v.PrimaryPart
if part and not part.Anchored and (root.Position - part.Position).Magnitude <= (C.BringRange or 80) then
pcall(function() part.CFrame = root.CFrame + Vector3.new(0, -2, 0) end)
end
end
end
end
task.wait(0.5)
end)
end
local function BringItemsDisable()
if BringConn then BringConn:Disconnect() BringConn = nil end
end
local HealConn = nil
local function AutoHealEnable()
if HealConn then return end
HealConn = RS.Heartbeat:Connect(function()
if not T.AutoHeal then return end
local _, hum = GC()
if hum and hum.Health > 0 and hum.Health < (C.AutoHealHP or 50) then
local ch = LP.Character
if ch then
for _, t in ipairs(ch:GetChildren()) do
if t:IsA("Tool") then
local n = t.Name:lower()
if n:find("bandage") or n:find("medkit") or n:find("heal") or n:find("potion") or n:find("food") then
pcall(function() t:Activate() end)
end
end
end
end
end
task.wait(1)
end)
end
local function AutoHealDisable()
if HealConn then HealConn:Disconnect() HealConn = nil end
end
local ThirdPersonBackup = nil
local function ThirdPersonEnable()
pcall(function()
local pl = LP
ThirdPersonBackup = { min = pl.CameraMinZoomDistance, max = pl.CameraMaxZoomDistance }
pl.CameraMode = Enum.CameraMode.Classic
pl.CameraMinZoomDistance = 0.5
pl.CameraMaxZoomDistance = 128
end)
end
local function ThirdPersonDisable()
if ThirdPersonBackup then
pcall(function()
LP.CameraMinZoomDistance = ThirdPersonBackup.min
LP.CameraMaxZoomDistance = ThirdPersonBackup.max
end)
end
end
local ReviveConn = nil
local function AutoReviveEnable()
if ReviveConn then return end
ReviveConn = RS.Heartbeat:Connect(function()
if not T.AutoRevive then return end
local _, _, root = GC()
if not root then return end
if type(fireproximityprompt) ~= "function" then return end
for _, p in ipairs(workspace:GetDescendants()) do
if p:IsA("ProximityPrompt") and p.Enabled then
local n = (p.ActionText or ""):lower() .. (p.ObjectText or ""):lower()
if n:find("revive") or n:find("rescue") or n:find("help") or n:find("复活") then
local part = p.Parent
if part and part:IsA("BasePart") and (root.Position - part.Position).Magnitude <= (p.MaxActivationDistance or 10) then
pcall(fireproximityprompt, p)
end
end
end
end
task.wait(0.5)
end)
end
local function AutoReviveDisable()
if ReviveConn then ReviveConn:Disconnect() ReviveConn = nil end
end
local GunAuraConn = nil
local function GunAuraEnable()
if GunAuraConn then return end
GunAuraConn = RS.Heartbeat:Connect(function()
if not T.GunAura then return end
local cam = workspace.CurrentCamera
local _, _, root = GC()
if not (cam and root) then return end
local best, bestD = nil, (C.GunAuraRange or 100)
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP and pl.Character then
local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
local hum = pl.Character:FindFirstChildOfClass("Humanoid")
if hrp and hum and hum.Health > 0 and not (T.AimTeamCheck and pl.Team == LP.Team) then
local d = (root.Position - hrp.Position).Magnitude
if d < bestD then bestD = d best = hrp end
end
end
end
if best then
cam.CFrame = CFrame.lookAt(cam.CFrame.Position, best.Position)
if type(mouse1click) == "function" then pcall(mouse1click) end
end
task.wait(0.05)
end)
end
local function GunAuraDisable()
if GunAuraConn then GunAuraConn:Disconnect() GunAuraConn = nil end
end
local AntiRagdollConn = nil
local function AntiRagdollEnable()
if AntiRagdollConn then return end
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
AntiRagdollConn = RS.Stepped:Connect(apply)
end
local function AntiRagdollDisable()
if AntiRagdollConn then AntiRagdollConn:Disconnect() AntiRagdollConn = nil end
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
local TrapHls = {}
local function TrapsESPEnable()
for _, v in ipairs(workspace:GetDescendants()) do
local n = v.Name:lower()
if v:IsA("BasePart") and (n:find("trap") or n:find("mine") or n:find("spike") or n:find("sentry")) then
local hl = Instance.new("Highlight")
hl.FillColor = Color3.fromRGB(255, 60, 60)
hl.FillTransparency = 0.3
hl.OutlineColor = Color3.fromRGB(255, 0, 0)
hl.Parent = v
TrapHls[#TrapHls + 1] = hl
end
end
print("[CheatMenu] 陷阱透视: 已高亮 " .. #TrapHls .. " 个")
end
local function TrapsESPDisable()
for _, hl in ipairs(TrapHls) do pcall(function() hl:Destroy() end) end
TrapHls = {}
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
local n = 0
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("BasePart") and AC.TrapDisable.isName(v.Name) then AC.TrapDisable.part(v) n = n + 1 end
end
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("Model") and v.Name:lower():find("trap") then
for _, p in ipairs(v:GetDescendants()) do
if p:IsA("BasePart") then AC.TrapDisable.part(p) n = n + 1 end
end
end
end
return n
end
function AC.TrapDisable.Enable()
if AC.TrapDisable.conn then return end
local n = AC.TrapDisable.scan()
AC.TrapDisable.conn = workspace.DescendantAdded:Connect(function(v)
if v:IsA("BasePart") and AC.TrapDisable.isName(v.Name) then AC.TrapDisable.part(v) end
if v:IsA("Model") and v.Name:lower():find("trap") then
for _, p in ipairs(v:GetDescendants()) do
if p:IsA("BasePart") then AC.TrapDisable.part(p) end
end
end
end)
print("[CheatMenu] 陷阱不触发: 已关闭 " .. n .. " 个陷阱部件的 CanTouch")
end
function AC.TrapDisable.Disable()
if AC.TrapDisable.conn then AC.TrapDisable.conn:Disconnect() AC.TrapDisable.conn = nil end
for p, orig in pairs(AC.TrapDisable.data) do
if p and p.Parent then pcall(function() p.CanTouch = orig end) end
end
AC.TrapDisable.data = {}
end
local AntiKnockConn = nil
local function AntiKnockdownEnable()
if AntiKnockConn then return end
AntiKnockConn = RS.Heartbeat:Connect(function()
if not T.AntiKnockdown then return end
local _, hum, root = GC()
if not (hum and root) then return end
if root.AssemblyLinearVelocity.Magnitude > 200 then
root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
end
task.wait(0.1)
end)
end
local function AntiKnockdownDisable()
if AntiKnockConn then AntiKnockConn:Disconnect() AntiKnockConn = nil end
end
local SmoothSpeedEnable = nil
local function SpeedBypassEnable()
print("[CheatMenu] 速度绕过(平滑加速)已启用")
end
local function flingPlayerByName(name)
if not name then return end
local pl = Players:FindFirstChild(name)
if not (pl and pl.Character) then return end
local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
local _, _, r = GC()
if hrp and r then
for _ = 1, 15 do
r.CFrame = hrp.CFrame * CFrame.new(0, 0, -1)
r.AssemblyLinearVelocity = Vector3.new(0, 250, 0)
task.wait()
end
end
end
local LockHealthConn = nil
local function LockHealthEnable()
if LockHealthConn then return end
LockHealthConn = RS.Heartbeat:Connect(function()
if not T.LockHealth then return end
local _, hum = GC()
if hum and hum.Health > 0 then
local target = C.LockHealthValue or 100
if hum.Health ~= target then hum.Health = target end
end
task.wait(0.05)
end)
end
local function LockHealthDisable()
if LockHealthConn then LockHealthConn:Disconnect() LockHealthConn = nil end
end
local RegenConn = nil
local function RegenEnable()
if RegenConn then return end
RegenConn = RS.Heartbeat:Connect(function()
if not T.Regen then return end
local _, hum = GC()
if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
hum.Health = math.min(hum.MaxHealth, hum.Health + (C.RegenRate or 10))
end
task.wait(0.2)
end)
end
local function RegenDisable()
if RegenConn then RegenConn:Disconnect() RegenConn = nil end
end
local StealthGodConn = nil
local function StealthGodEnable()
if StealthGodConn then return end
local _, hum0 = GC()
if hum0 then pcall(function() if hum0.MaxHealth > 1e6 then hum0.MaxHealth = 100 end end) end
StealthGodConn = RS.Heartbeat:Connect(function()
if not T.StealthGod then return end
local _, hum = GC()
if hum and hum.Health > 0 then
hum.Health = hum.MaxHealth
end
task.wait(0.05)
end)
end
local function StealthGodDisable()
if StealthGodConn then StealthGodConn:Disconnect() StealthGodConn = nil end
end
local NoDeathConn = nil
local function NoDeathEnable()
if NoDeathConn then return end
NoDeathConn = RS.Heartbeat:Connect(function()
if not T.NoDeath then return end
local _, hum = GC()
if hum and hum.Health <= 0 then
pcall(function() hum.Health = hum.MaxHealth end)
end
task.wait(0.1)
end)
end
local function NoDeathDisable()
if NoDeathConn then NoDeathConn:Disconnect() NoDeathConn = nil end
end
local function scanRemotes()
local found = {}
local order = {}
local function addRemote(obj, src)
if typeof(obj) ~= "Instance" then return end
local okA, isE = pcall(function() return obj:IsA("RemoteEvent") end)
local okB, isF = pcall(function() return obj:IsA("RemoteFunction") end)
if (not okA or not isE) and (not okB or not isF) then return end
local cls = isE and "RemoteEvent" or "RemoteFunction"
local name = tostring(obj.Name)
local key = cls .. "\0" .. name
if not found[key] then
found[key] = { name = name, class = cls, srcs = {}, suspicious = AC.isSuspicious(name) }
order[#order + 1] = key
end
found[key].srcs[src] = true
end
pcall(function()
for _, d in ipairs(RStorage:GetDescendants()) do addRemote(d, "RS") end
end)
if type(getnilinstances) == "function" then
pcall(function()
for _, inst in ipairs(getnilinstances()) do addRemote(inst, "nil") end
end)
end
if type(getgc) == "function" then
pcall(function()
local seen = 0
for _, obj in ipairs(getgc(true)) do
seen = seen + 1
if seen > 8000 then break end
if typeof(obj) == "Instance" then
addRemote(obj, "gc")
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
print("[抓包] ===== 深度抓包结果(RS + nil + getgc) =====")
for _, key in ipairs(order) do
local it = found[key]
total = total + 1
local srcs = {}
for s in pairs(it.srcs) do srcs[#srcs + 1] = s end
if it.suspicious then susCount = susCount + 1 end
print(string.format("[抓包] %s [%s] %s  <- %s", it.suspicious and "⚠可疑" or " 普通", it.class, it.name, table.concat(srcs, ",")))
end
print(string.format("[抓包] 共 %d 个远程，可疑 %d 个", total, susCount))
local result = {}
for _, key in ipairs(order) do
local it = found[key]
result[#result + 1] = string.format("%s%s:%s", it.suspicious and "⚠" or "", it.class == "RemoteEvent" and "E" or "F", it.name)
end
return result, susCount
end
local function parseAmount(s)
s = tostring(s or ""):upper():gsub("%s+", ""):gsub(",", "")
if s == "" then return nil end
local plain = tonumber(s)
if plain then return plain end
local num, unit = s:match("^(%d+%.?%d*)([KM])$")
if num and unit then
local base = tonumber(num)
if not base then return nil end
if unit == "K" then return base * 1000 end
if unit == "M" then return base * 1000000 end
end
return nil
end
local function UnloadAll()
for k in pairs(T) do T[k] = false end
local disables = { KickGuardDisable, AntiFlingDisable, AntiRagdollDisable, AC.TrapDisable.Disable, AC.UnblockRemotes, AC.UninstallAntiTP, AC.AntiPauseDisable, NoClipDisable }
for _, fn in ipairs(disables) do pcall(fn) end
pcall(function() if AFKConn then AFKConn:Disconnect() end end)
pcall(function() if KG and KG.rjConn then KG.rjConn:Disconnect() end end)
pcall(function() if getgenv and getgenv().CM_Window then getgenv().CM_Window:Destroy() getgenv().CM_Window = nil end end)
pcall(function() if getgenv and getgenv().CM_ToggleSG then getgenv().CM_ToggleSG:Destroy() getgenv().CM_ToggleSG = nil end end)
print("[CheatMenu] ✅ 已干净卸载")
end
local function RestoreFeatures()
if T.KickProtect or T.AntiAFK then AntiAFKEnable() KickGuardEnable() KickRejoinEnable() end
if T.AutoBonus then AutoBonusEnable() end
if T.NamecallHook then AC.InstallNamecallHook() end
if T.RemoteBlock then AC.InstallNamecallHook() end
if T.AntiFling then AntiFlingEnable() end
if T.UniversalAC then AC.InstallPropertyLock() AC.DeepScanBlock() end
if T.AntiTP then AC.InstallAntiTP() end
if T.AntiPause then AC.AntiPauseEnable() end
if T.NoClip then NoClipEnable() end
if T.Antilag then AntilagEnable() end
end
local function HotUpdate()
Fluent:Notify({ Title = "热更新", Content = "保存配置并重新加载...", Duration = 3 })
SaveConfig()
task.spawn(function()
task.wait(0.5)
UnloadAll()
task.wait(0.3)
if type(loadstring) ~= "function" then
Fluent:Notify({ Title = "热更新", Content = "当前执行器不支持热更新，请手动重新执行脚本", Duration = 5 })
return
end
local ok, err = pcall(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua"))()
end)
if not ok then warn("[CheatMenu] 热更新失败: " .. tostring(err)) end
end)
end
LoadConfig()
local Window = Fluent:CreateWindow({
Title = "CheatMenu",
SubTitle = "v5.0.3",
TabWidth = 100,
Size = UDim2.fromOffset(500, 540),
Acrylic = true,
Theme = "Aqua",
MinimizeKey = Enum.KeyCode.G,
})
if getgenv then getgenv().CM_Window = Window end
pcall(function() Fluent:ToggleTransparency(true) end)
local function buildMenu()
local GAME = getgenv() and getgenv().GAME or {}
local Tabs = {
Combat  = Window:AddTab({ Title = "战斗", Icon = "crosshair" }),
Move    = Window:AddTab({ Title = "移动", Icon = "move" }),
World   = Window:AddTab({ Title = "视觉", Icon = "globe" }),
TP      = Window:AddTab({ Title = "传送", Icon = "map-pin" }),
AFK     = Window:AddTab({ Title = "挂机", Icon = "home" }),
Trans   = Window:AddTab({ Title = "翻译", Icon = "languages" }),
AC      = Window:AddTab({ Title = "反作弊", Icon = "shield" }),
Setting = Window:AddTab({ Title = "设置", Icon = "settings" }),
}
do
Tabs.Combat:AddSection("战斗")
Tabs.Combat:AddToggle("Aim", { Title = "自瞄", Default = false, Callback = function(v) T.Aim = v if v then CM.AimEnable() else CM.AimDisable() end end })
Tabs.Combat:AddToggle("SilentAim", { Title = "静默自瞄(硬锁)", Default = false, Callback = function(v) T.SilentAim = v if v then CM.SilentAimEnable() else CM.SilentAimDisable() end end })
Tabs.Combat:AddToggle("SilentAimGhost", { Title = "静默自瞄·无痕(镜头不动,观战看不出)", Default = false, Callback = function(v) T.SilentAimGhost = v if v then CM.SilentAimGhostEnable() else CM.SilentAimGhostDisable() end end })
Tabs.Combat:AddToggle("TriggerBot", { Title = "开火才锁(TriggerBot,更隐蔽)", Default = false, Callback = function(v) T.TriggerBot = v end })
Tabs.Combat:AddToggle("AimPrediction", { Title = "弹道预测(打移动目标)", Default = false, Callback = function(v) T.AimPrediction = v end })
Tabs.Combat:AddDropdown("AimHitPart", { Title = "命中部位", Values = { "头部", "上身", "身体" }, Default = "头部", Callback = function(v)
local map = { ["头部"] = "head", ["上身"] = "torso", ["身体"] = "body" }
C.AimHitPart = map[v] or "head"
end })
Tabs.Combat:AddSlider("AimFOV", { Title = "自瞄范围", Min = 50, Max = 500, Default = 200, Rounding = 0, Callback = function(v) C.AimFOV = v end })
Tabs.Combat:AddSlider("AimSmooth", { Title = "平滑度(越大越慢)", Min = 1, Max = 20, Default = 5, Rounding = 0, Callback = function(v) C.AimSmooth = v end })
Tabs.Combat:AddToggle("AimTeamCheck", { Title = "忽略队友", Default = true, Callback = function(v) T.AimTeamCheck = v end })
Tabs.Combat:AddToggle("AimWallCheck", { Title = "墙壁检查(穿墙不锁)", Default = true, Callback = function(v) T.AimWallCheck = v end })
Tabs.Combat:AddToggle("SingleAim", { Title = "指定玩家自瞄", Default = false, Callback = function(v) T.SingleAim = v if v then CM.SingleAimEnable() else CM.SingleAimDisable() end end })
Tabs.Combat:AddToggle("FaceLock", { Title = "面锁(面向目标)", Default = false, Callback = function(v) T.FaceLock = v if v then CM.FaceLockEnable() else CM.FaceLockDisable() end end })
Tabs.Combat:AddSection("生存 & 辅助")
Tabs.Combat:AddSection("生命保护")
Tabs.Combat:AddToggle("God", { Title = "无敌(MaxHealth=∞)", Default = false, Callback = function(v) T.God = v if v then CM.GodEnable() else CM.GodDisable() end end })
Tabs.Combat:AddToggle("StealthGod", { Title = "隐蔽无敌(锁满血,难检测)", Default = false, Callback = function(v) T.StealthGod = v if v then StealthGodEnable() else StealthGodDisable() end end })
Tabs.Combat:AddToggle("LockHealth", { Title = "锁血", Default = false, Callback = function(v) T.LockHealth = v if v then LockHealthEnable() else LockHealthDisable() end end })
Tabs.Combat:AddSlider("LockHealthValue", { Title = "锁血值", Min = 1, Max = 1000, Default = 100, Rounding = 0, Callback = function(v) C.LockHealthValue = v end })
Tabs.Combat:AddToggle("Regen", { Title = "回血(主动快速回血)", Default = false, Callback = function(v) T.Regen = v if v then RegenEnable() else RegenDisable() end end })
Tabs.Combat:AddSlider("RegenRate", { Title = "回血速度(每0.2秒)", Min = 1, Max = 100, Default = 10, Rounding = 0, Callback = function(v) C.RegenRate = v end })
Tabs.Combat:AddToggle("NoDeath", { Title = "防死亡", Default = false, Callback = function(v) T.NoDeath = v if v then NoDeathEnable() else NoDeathDisable() end end })
Tabs.Combat:AddToggle("Invisible", { Title = "隐身", Default = false, Callback = function(v) T.Invisible = v if v then CM.InvisibleEnable() else CM.InvisibleDisable() end end })
Tabs.Combat:AddToggle("Hitbox", { Title = "碰撞箱(透明)", Default = false, Callback = function(v) T.Hitbox = v if v then CM.HitboxEnable() else CM.HitboxDisable() end end })
Tabs.Combat:AddDropdown("FlingTarget", { Title = "甩飞目标玩家", Values = (function() local n = {} for _, pl in ipairs(Players:GetPlayers()) do if pl ~= LP then n[#n+1] = pl.Name end end return #n > 0 and n or { "(无人)" } end)(), Default = nil, Callback = function(v) C.FlingTarget = v end })
Tabs.Combat:AddButton({ Title = "甩飞选中玩家", Callback = function() flingPlayerByName(C.FlingTarget) end })
Tabs.Combat:AddToggle("AntiRagdoll", { Title = "反布娃娃/防击倒", Default = false, Callback = function(v) T.AntiRagdoll = v if v then AntiRagdollEnable() else AntiRagdollDisable() end end })
Tabs.Combat:AddToggle("AntiKnockdown", { Title = "防被撞飞", Default = false, Callback = function(v) T.AntiKnockdown = v if v then AntiKnockdownEnable() else AntiKnockdownDisable() end end })
Tabs.Combat:AddToggle("HitboxExpand", { Title = "Hitbox 扩展(增大敌人命中框)", Default = false, Callback = function(v) T.HitboxExpand = v if v then HitboxExpandEnable() else HitboxExpandDisable() end end })
Tabs.Combat:AddSlider("HitboxSize", { Title = "命中框大小", Min = 2, Max = 30, Default = 10, Rounding = 0, Callback = function(v) C.HitboxSize = v if T.HitboxExpand then HitboxExpandDisable() HitboxExpandEnable() end end })
Tabs.Combat:AddToggle("KillAura", { Title = "自动攻击(范围内敌人)", Default = false, Callback = function(v) T.KillAura = v if v then KillAuraEnable() else KillAuraDisable() end end })
Tabs.Combat:AddSlider("KillAuraRange", { Title = "自动攻击范围", Min = 5, Max = 100, Default = 20, Rounding = 0, Callback = function(v) C.KillAuraRange = v end })
Tabs.Combat:AddToggle("NoRecoil", { Title = "无后坐力(锁定相机)", Default = false, Callback = function(v) T.NoRecoil = v if v then NoRecoilEnable() else NoRecoilDisable() end end })
Tabs.Combat:AddToggle("GunAura", { Title = "Gun Aura(自动朝敌人开火)", Default = false, Callback = function(v) T.GunAura = v if v then GunAuraEnable() else GunAuraDisable() end end })
Tabs.Combat:AddSlider("GunAuraRange", { Title = "开火范围", Min = 20, Max = 300, Default = 100, Rounding = 0, Callback = function(v) C.GunAuraRange = v end })
Tabs.Combat:AddSection("ESP 透视")
Tabs.Combat:AddToggle("ESP", { Title = "ESP 透视(默认方框+名称+距离+血条)", Default = false, Callback = function(v)
T.ESP = v
T.ESPBox = v T.ESPName = v T.ESPDist = v T.ESPHealth = v
if v then CM.ESPEnable() else CM.ESPDisable() end
end })
Tabs.Combat:AddDropdown("ESPStyle", { Title = "ESP 样式", Values = { "完整(框+名称+距离+血条)", "简洁(仅方框)", "带追踪线", "彩虹全开" }, Default = "完整(框+名称+距离+血条)", Callback = function(v)
if v == "简洁(仅方框)" then
T.ESPBox = true T.ESPName = false T.ESPDist = false T.ESPHealth = false T.ESPTracer = false T.ESPRainbow = false
elseif v == "带追踪线" then
T.ESPBox = true T.ESPName = true T.ESPDist = true T.ESPHealth = true T.ESPTracer = true T.ESPRainbow = false
elseif v == "彩虹全开" then
T.ESPBox = true T.ESPName = true T.ESPDist = true T.ESPHealth = true T.ESPTracer = true T.ESPRainbow = true
else
T.ESPBox = true T.ESPName = true T.ESPDist = true T.ESPHealth = true T.ESPTracer = false T.ESPRainbow = false
end
end })
Tabs.Combat:AddToggle("ESPTeamColor", { Title = "敌我识别(敌红/友蓝/队绿)", Default = false, Callback = function(v) T.ESPTeamColor = v T.ESPFriendColor = v end })
Tabs.Combat:AddToggle("ESPArrow", { Title = "方向箭头", Default = false, Callback = function(v) T.ESPArrow = v if v then ArrowEnable() else ArrowDisable() end end })
Tabs.Combat:AddToggle("ESPSkeleton", { Title = "骨骼线", Default = false, Callback = function(v) T.ESPSkeleton = v if v then SkeletonEnable() else SkeletonDisable() end end })
Tabs.Combat:AddToggle("BulletTracer", { Title = "子弹追踪", Default = false, Callback = function(v) T.BulletTracer = v if v then CM.BulletTracerEnable() else CM.BulletTracerDisable() end end })
end
do
Tabs.Move:AddSection("移动")
Tabs.Move:AddParagraph({ Title = "飞行按键：WASD 移动，空格上升，左Ctrl 下降", Content = "" })
Tabs.Move:AddToggle("Fly", { Title = "飞行", Default = false, Callback = function(v) T.Fly = v if v then CM.FlyEnable() else CM.FlyDisable() end end })
Tabs.Move:AddSlider("FlySpeed", { Title = "飞行速度", Min = 10, Max = 1000, Default = 50, Rounding = 0, Callback = function(v) C.FlySpeed = v end })
Tabs.Move:AddToggle("FlyPhys", { Title = "物理飞行(BodyVelocity 模式)", Default = false, Callback = function(v) T.FlyPhys = v if v then FlyPhysEnable() else FlyPhysDisable() end end })
Tabs.Move:AddToggle("Speed", { Title = "加速", Default = false, Callback = function(v) T.Speed = v if v then CM.SpeedEnable() else CM.SpeedDisable() end end })
Tabs.Move:AddSlider("SpeedMul", { Title = "加速倍数(×)", Min = 1, Max = 50, Default = 2, Rounding = 0, Callback = function(v) C.SpeedMul = v end })
Tabs.Move:AddToggle("InfiniteJump", { Title = "无限跳", Default = false, Callback = function(v) T.InfiniteJump = v if v then CM.InfiniteJumpEnable() end end })
Tabs.Move:AddSection("移动增强")
Tabs.Move:AddToggle("Spin", { Title = "自转", Default = false, Callback = function(v) T.Spin = v if v then CM.SpinEnable() else CM.SpinDisable() end end })
Tabs.Move:AddSlider("SpinSpeed", { Title = "自转速度", Min = 1, Max = 60, Default = 10, Rounding = 0, Callback = function(v) C.SpinSpeed = v end })
Tabs.Move:AddToggle("AirWalk", { Title = "踏空(空中移动)", Default = false, Callback = function(v) T.AirWalk = v if v then CM.AirWalkEnable() else CM.AirWalkDisable() end end })
Tabs.Move:AddSlider("AirWalkSpeed", { Title = "踏空速度", Min = 10, Max = 200, Default = 30, Rounding = 0, Callback = function(v) C.AirWalkSpeed = v end })
Tabs.Move:AddToggle("NoClip", { Title = "穿墙", Default = false, Callback = function(v) T.NoClip = v if v then CM.NoClipEnable() else CM.NoClipDisable() end end })
Tabs.Move:AddToggle("Hide", { Title = "藏地下(自己视角正常)", Default = false, Callback = function(v) T.Hide = v if v then CM.HideEnable() else CM.HideDisable() end end })
Tabs.Move:AddSlider("HideDepth", { Title = "藏地下深度(浅=可交互)", Min = 1, Max = 30, Default = 5, Rounding = 0, Callback = function(v) C.HideDepth = v end })
Tabs.Move:AddToggle("FlyCar", { Title = "飞车(载具飞行)", Default = false, Callback = function(v) T.FlyCar = v if v then CM.FlyCarEnable() else CM.FlyCarDisable() end end })
Tabs.Move:AddSlider("FlyCarSpeed", { Title = "飞车速度", Min = 10, Max = 300, Default = 50, Rounding = 0, Callback = function(v) C.FlyCarSpeed = v end })
end
do
Tabs.World:AddSection("视觉增强")
Tabs.World:AddToggle("VisionBoost", { Title = "视觉增强(全亮+夜视+去雾)", Default = false, Callback = function(v)
T.FullBright = v T.NightVision = v T.NoFog = v
if v then CM.FullBrightEnable() CM.NightVisionEnable() CM.NoFogEnable()
else CM.FullBrightDisable() CM.NightVisionDisable() CM.NoFogDisable() end
end })
Tabs.World:AddToggle("XrayBoost", { Title = "透视增强(Xray+自发光)", Default = false, Callback = function(v)
T.Xray = v T.SelfGlow = v
if v then CM.XrayEnable() CM.SelfGlowEnable() else CM.XrayDisable() CM.SelfGlowDisable() end
end })
Tabs.World:AddToggle("ViewBoost", { Title = "视角增强(FOV+无限缩放)", Default = false, Callback = function(v)
T.FOV = v T.Zoom = v
if v then CM.FOVEnable() CM.ZoomEnable() else CM.FOVDisable() CM.ZoomDisable() end
end })
Tabs.World:AddSlider("FOV", { Title = "视野 FOV", Min = 70, Max = 120, Default = 100, Rounding = 0, Callback = function(v) C.FOV = v if T.FOV then CM.FOVEnable() end end })
Tabs.World:AddSlider("Zoom", { Title = "缩放距离", Min = 128, Max = 1000, Default = 400, Rounding = 0, Callback = function(v) C.Zoom = v if T.Zoom then CM.ZoomEnable() end end })
Tabs.World:AddToggle("Mute", { Title = "静音", Default = false, Callback = function(v) T.Mute = v if v then CM.MuteEnable() end end })
Tabs.World:AddToggle("Antilag", { Title = "降画质(关阴影/去水波/关雾)", Default = false, Callback = function(v) T.Antilag = v if v then AntilagEnable() else AntilagDisable() end end })
Tabs.World:AddSection("互动增强")
Tabs.World:AddToggle("InteractBoost", { Title = "互动增强(自动互动+触摸+无距离+无冷却)", Default = false, Callback = function(v)
T.AutoInteract = v T.AutoTouch = v T.InstantPrompt = v T.NoPromptLimit = v T.NoPromptCooldown = v T.NoClickLimit = v
if v then
CM.AutoInteractEnable() AutoTouchEnable() CM.InstantPromptEnable() NoPromptLimitEnable() NoPromptCooldownEnable() NoClickLimit()
else
CM.AutoInteractDisable() AutoTouchDisable()
end
end })
Tabs.World:AddButton({ Title = "触发所有互动(触摸+ClickDetector)", Callback = function() FireAllTouches() FireAllClickDetectors() end })
Tabs.World:AddToggle("WalkSpeedLock", { Title = "速度锁定(WalkSpeed 被改自动恢复)", Default = false, Callback = function(v) T.WalkSpeedLock = v if v then PropWatchEnable() end end })
Tabs.World:AddToggle("AutoPickup", { Title = "自动拾取(靠近触碰掉落物)", Default = false, Callback = function(v) T.AutoPickup = v if v then AutoPickupEnable() else AutoPickupDisable() end end })
Tabs.World:AddSlider("PickupRange", { Title = "拾取范围", Min = 5, Max = 50, Default = 15, Rounding = 0, Callback = function(v) C.PickupRange = v end })
Tabs.World:AddSection("生存辅助")
Tabs.World:AddToggle("BringItems", { Title = "物品拉取(把掉落物拉过来)", Default = false, Callback = function(v) T.BringItems = v if v then BringItemsEnable() else BringItemsDisable() end end })
Tabs.World:AddSlider("BringRange", { Title = "拉取范围", Min = 10, Max = 200, Default = 80, Rounding = 0, Callback = function(v) C.BringRange = v end })
Tabs.World:AddToggle("AutoHeal", { Title = "自动治疗(低血用治疗品)", Default = false, Callback = function(v) T.AutoHeal = v if v then AutoHealEnable() else AutoHealDisable() end end })
Tabs.World:AddSlider("AutoHealHP", { Title = "治疗血量阈值", Min = 10, Max = 100, Default = 50, Rounding = 0, Callback = function(v) C.AutoHealHP = v end })
Tabs.World:AddToggle("AutoRevive", { Title = "自动复活队友", Default = false, Callback = function(v) T.AutoRevive = v if v then AutoReviveEnable() else AutoReviveDisable() end end })
Tabs.World:AddToggle("ThirdPerson", { Title = "第三人称相机", Default = false, Callback = function(v) T.ThirdPerson = v if v then ThirdPersonEnable() else ThirdPersonDisable() end end })
end
do
Tabs.TP:AddSection("传送")
Tabs.TP:AddDropdown("TPTarget", { Title = "目标玩家", Values = (function() local n = {} for _, pl in ipairs(Players:GetPlayers()) do if pl ~= LP then n[#n+1] = pl.Name end end if #n==0 then n[1]="(无人)" end return n end)(), Default = nil })
Tabs.TP:AddButton({ Title = "传送到目标", Callback = function()
local name = Fluent.Options.TPTarget and Fluent.Options.TPTarget.Value
if not name then return end
CM.TeleportToPlayer(Players:FindFirstChild(name))
end })
Tabs.TP:AddToggle("Spectate", { Title = "观察目标", Default = false, Callback = function(v) T.Spectate = v if v then CM.SpectateEnable() else CM.SpectateDisable() end end })
Tabs.TP:AddToggle("Circle", { Title = "环绕传送", Default = false, Callback = function(v) T.Circle = v if v then CM.CircleEnable() else CM.CircleDisable() end end })
Tabs.TP:AddSlider("CircleRadius", { Title = "环绕半径", Min = 3, Max = 30, Default = 10, Rounding = 0, Callback = function(v) C.CircleRadius = v end })
Tabs.TP:AddSlider("CircleSpeed", { Title = "环绕速度", Min = 1, Max = 30, Default = 5, Rounding = 0, Callback = function(v) C.CircleSpeed = v end })
Tabs.TP:AddToggle("TeleportOnDeath", { Title = "死亡后继续传送", Default = false, Callback = function(v) T.TeleportOnDeath = v if v then CM.TeleportOnDeathEnable() end end })
Tabs.TP:AddButton({ Title = "保存当前位置", Callback = function() CM.savePosition() end })
Tabs.TP:AddButton({ Title = "传送回保存位置", Callback = function() CM.teleportToSaved() end })
Tabs.TP:AddSection("传送增强")
Tabs.TP:AddToggle("TPSmooth", { Title = "平滑传送(分段淡入,抗瞬移检测)", Default = false, Callback = function(v) T.TPSmooth = v end })
Tabs.TP:AddSlider("TPSmoothSeg", { Title = "分段数(越多越隐蔽)", Min = 3, Max = 20, Default = 8, Rounding = 0, Callback = function(v) C.TPSmoothSeg = v end })
Tabs.TP:AddToggle("ClickTP", { Title = "点击传送(点地面即传过去)", Default = false, Callback = function(v) T.ClickTP = v if v then ClickTPEnable() else ClickTPDisable() end end })
Tabs.TP:AddInput("TPCoords", { Title = "坐标传送(X,Y,Z 逗号分隔)", Default = "", Placeholder = "如 100,50,200" })
Tabs.TP:AddButton({ Title = "传送到坐标", Callback = function()
local s = Fluent.Options.TPCoords and Fluent.Options.TPCoords.Value
if not s or s == "" then return end
local x, y, z = s:match("([^,]+),([^,]+),([^,]+)")
if x then tpToCoords(x, y, z) end
end })
Tabs.TP:AddToggle("AntiVoid", { Title = "防掉虚空", Default = false, Callback = function(v) T.AntiVoid = v if v then AntiVoidEnable() else AntiVoidDisable() end end })
Tabs.TP:AddSlider("VoidY", { Title = "虚空高度阈值", Min = -200, Max = 0, Default = -50, Rounding = 0, Callback = function(v) C.VoidY = v end })
Tabs.TP:AddToggle("AutoRespawn", { Title = "自动重生", Default = false, Callback = function(v) T.AutoRespawn = v if v then AutoRespawnEnable() end end })
end
do
Tabs.AFK:AddSection("挂机防踢")
Tabs.AFK:AddToggle("KickProtect", { Title = "挂机防踢(挂机+本地拦截+前兆抢传)", Default = true, Callback = function(v)
T.KickProtect = v T.AntiAFK = v T.KickGuard = v T.KickRejoin = v
if v then AntiAFKEnable() KickGuardEnable() KickRejoinEnable() else KickGuardDisable() end
end })
Tabs.AFK:AddSection("踢击训练")
Tabs.AFK:AddToggle("AutoTrain", { Title = "踢击训练", Default = false, Callback = function(v) T.AutoTrain = v if v then AutoTrainEnable() end end })
Tabs.AFK:AddToggle("AutoBonus", { Title = "领取踢击距离", Default = false, Callback = function(v) T.AutoBonus = v if v then AutoBonusEnable() end end })
Tabs.AFK:AddSlider("AutoTrainSec", { Title = "训练循环间隔(秒)", Min = 1, Max = 30, Default = 5, Rounding = 1, Callback = function(v) C.AutoTrainSec = v end })
Tabs.AFK:AddSection("自动锻炼")
Tabs.AFK:AddToggle("AutoGym", { Title = "自动锻炼(健身房)", Default = false, Callback = function(v) T.AutoGym = v if v then AutoGymEnable() end end })
Tabs.AFK:AddSection("基地操作")
Tabs.AFK:AddToggle("AutoSell", { Title = "卖 CPS 脑红(按门槛)", Default = false, Callback = function(v) T.AutoSell = v if v then sellLowCPSTools() end end })
Tabs.AFK:AddInput("SellMinCPS", { Title = "售卖门槛(可填 1M / 500K / 数字)", Default = "100K", Placeholder = "例如 1M = 100万", Callback = function(v)
local n = parseAmount(v)
if n and n > 0 then C.SellMinCPS = n end
end })
Tabs.AFK:AddButton({ Title = "一键收起脑红", Callback = function() withdrawAllBrainrots() end })
Tabs.AFK:AddButton({ Title = "一键收钱", Callback = function() collectAllCash() end })
Tabs.AFK:AddSection("进阶自动化(学自 Axon/Stree/Fartez)")
Tabs.AFK:AddToggle("AutoRebirth", { Title = "自动重生转生", Default = false, Callback = function(v) T.AutoRebirth = v if v then GAME.AutoRebirthEnable() end end })
Tabs.AFK:AddToggle("AutoUpgrade", { Title = "自动升级(脑红/踢力)", Default = false, Callback = function(v) T.AutoUpgrade = v if v then GAME.AutoUpgradeEnable() end end })
Tabs.AFK:AddToggle("AutoSpin", { Title = "自动转盘", Default = false, Callback = function(v) T.AutoSpin = v if v then GAME.AutoSpinEnable() end end })
Tabs.AFK:AddToggle("AutoClaim", { Title = "自动领奖(离线/免费/每日)", Default = false, Callback = function(v) T.AutoClaim = v if v then GAME.AutoClaimEnable() end end })
Tabs.AFK:AddToggle("AutoSkipWave", { Title = "自动跳弱波", Default = false, Callback = function(v) T.AutoSkipWave = v if v then GAME.AutoSkipWaveEnable() end end })
Tabs.AFK:AddToggle("Sniper", { Title = "定向脑红(按名字/词缀自动装备)", Default = false, Callback = function(v) T.Sniper = v if v then GAME.SniperEnable() else GAME.SniperDisable() end end })
Tabs.AFK:AddInput("SniperName", { Title = "狙目标名字(关键词)", Default = "", Placeholder = "如 Plan Red", Callback = function(v) C.SniperName = v end })
Tabs.AFK:AddInput("SniperMutation", { Title = "狙目标词缀(关键词)", Default = "", Placeholder = "如 Rainbow / Astral", Callback = function(v) C.SniperMutation = v end })
Tabs.AFK:AddToggle("PlaceBest", { Title = "自动放最优脑红(最高CPS)", Default = false, Callback = function(v) T.PlaceBest = v if v then GAME.AutoPlaceBestEnable() else GAME.AutoPlaceBestDisable() end end })
Tabs.AFK:AddSlider("PlaceBestSlots", { Title = "放置槽位数", Min = 1, Max = 50, Default = 30, Rounding = 0, Callback = function(v) C.PlaceBestSlots = v end })
Tabs.AFK:AddSection("块/脑红 ESP")
Tabs.AFK:AddToggle("BlockESP", { Title = "幸运块透视(高亮)", Default = false, Callback = function(v) T.BlockESP = v if v then GAME.BlockESPEnable() else GAME.BlockESPDisable() end end })
Tabs.AFK:AddToggle("BrainrotESP", { Title = "脑红透视(高亮)", Default = false, Callback = function(v) T.BrainrotESP = v if v then GAME.BlockESPEnable() else GAME.BlockESPDisable() end end })
end
do
Tabs.Trans:AddSection("翻译")
Tabs.Trans:AddDropdown("TransLang", { Title = "目标语言", Values = { "中文", "英文", "日文", "韩文", "泰文", "俄文", "阿拉伯文", "印尼语" }, Default = "中文", Callback = function(v)
local map = { ["中文"] = "zh", ["英文"] = "en", ["日文"] = "ja", ["韩文"] = "ko", ["泰文"] = "th", ["俄文"] = "ru", ["阿拉伯文"] = "ar", ["印尼语"] = "id" }
C.TransLang = map[v] or "zh"
end })
Tabs.Trans:AddToggle("Translate", { Title = "界面翻译(自动翻译游戏内文字)", Default = false, Callback = function(v) T.Translate = v if v then startTranslateLoop() end end })
Tabs.Trans:AddSlider("TransInterval", { Title = "翻译请求间隔(秒,越大越不影响游戏)", Min = 0, Max = 2, Default = 0.15, Rounding = 2, Callback = function(v) C.TransInterval = v end })
Tabs.Trans:AddInput("TransInput", { Title = "输入文本", Default = "", Placeholder = "输入要翻译/发送的文字" })
Tabs.Trans:AddButton({ Title = "翻译文本", Callback = function()
local txt = Fluent.Options.TransInput and Fluent.Options.TransInput.Value
if not txt or txt == "" then Fluent:Notify({ Title = "翻译", Content = "请先输入文本", Duration = 3 }) return end
local r = Trans.Translate(txt, true)
if r then Fluent:Notify({ Title = "翻译结果", Content = r, Duration = 6 })
else Fluent:Notify({ Title = "翻译", Content = "翻译失败(检查本地翻译服务是否开启)", Duration = 4 }) end
end })
Tabs.Trans:AddButton({ Title = "翻译并发送到聊天", Callback = function()
local txt = Fluent.Options.TransInput and Fluent.Options.TransInput.Value
if not txt or txt == "" then Fluent:Notify({ Title = "翻译", Content = "请先输入文本", Duration = 3 }) return end
local r = Trans.Translate(txt, true)
if r then sendChat(r) Fluent:Notify({ Title = "已发送", Content = r, Duration = 4 })
else sendChat(txt) Fluent:Notify({ Title = "已发送(原文)", Content = txt, Duration = 4 }) end
end })
Tabs.Trans:AddButton({ Title = "清空翻译缓存", Callback = function() TransCache = {} saveTransCache() Fluent:Notify({ Title = "翻译", Content = "缓存已清空", Duration = 2 }) end })
end
do
Tabs.AC:AddSection("反作弊")
Tabs.AC:AddToggle("ACBypass", { Title = "反作弊一键(防踢+拦远程+防甩飞+元表清空)", Default = false, Callback = function(v)
T.ACBypass = v T.NamecallHook = v T.RemoteBlock = v T.AntiFling = v T.MetaBypass = v T.BadgeBypass = v
if v then
AC.InstallNamecallHook() AC.InstallPropertyLock() AntiFlingEnable() CM.MetaBypassEnable() CM.BadgeBypassEnable()
else
AntiFlingDisable()
end
end })
Tabs.AC:AddToggle("ChatBypass2", { Title = "聊天绕过(正常聊天框直接发)", Default = false, Callback = function(v) T.ChatBypass = v if v then CM.ChatBypassEnable() end end })
Tabs.AC:AddToggle("ACBypassPlus", { Title = "反作弊绕过增强(断检测连接+清元表)", Default = false, Callback = function(v) T.ACBypassPlus = v if v then ACBypassPlusEnable() end end })
Tabs.AC:AddToggle("UniversalAC", { Title = "通用反作弊v2(拦上报+深度扫描+属性锁)", Default = false, Callback = function(v)
T.UniversalAC = v T.PropertyLock = v
if v then
AC.InstallPropertyLock() AC.DeepScanBlock()
else
AC.UnblockRemotes()
end
end })
Tabs.AC:AddToggle("VoiceBypass", { Title = "语音绕过(VC Bypass)", Default = false, Callback = function(v) T.VoiceBypass = v if v then VoiceBypassEnable() else VoiceBypassDisable() end end })
Tabs.AC:AddToggle("AntiTP", { Title = "防传送(拦截被踢/传送走)", Default = false, Callback = function(v) T.AntiTP = v if v then AC.InstallAntiTP() else AC.UninstallAntiTP() end end })
Tabs.AC:AddToggle("AntiPause", { Title = "防游戏暂停(销毁网络暂停界面)", Default = false, Callback = function(v) T.AntiPause = v if v then AC.AntiPauseEnable() else AC.AntiPauseDisable() end end })
Tabs.AC:AddToggle("TrapsESP", { Title = "陷阱透视(高亮陷阱/哨兵)", Default = false, Callback = function(v) T.TrapsESP = v if v then TrapsESPEnable() else TrapsESPDisable() end end })
Tabs.AC:AddToggle("TrapDisable", { Title = "陷阱不触发(关陷阱 CanTouch)", Default = false, Callback = function(v) T.TrapDisable = v if v then AC.TrapDisable.Enable() else AC.TrapDisable.Disable() end end })
Tabs.AC:AddSection("扫描 / 抓包")
Tabs.AC:AddButton({ Title = "扫描抓包(深度·含隐藏remote)", Callback = function() local r, sus = scanRemotes() Fluent:Notify({ Title = "深度抓包", Content = "共 " .. #r .. " 个远程，可疑 " .. sus .. " 个，详见控制台(F9)", Duration = 5 }) end })
Tabs.AC:AddButton({ Title = "扫描游戏模块(深度·含常量)", Callback = function() local m, ft, ac = scanGameModules() Fluent:Notify({ Title = "模块扫描", Content = "模块 " .. m .. " / 函数 " .. ft .. " / 反作弊特征 " .. ac .. "，详见控制台(F9)", Duration = 5 }) end })
Tabs.AC:AddButton({ Title = "扫描并自动拦截反作弊", Callback = function() local n = AC.ScanAndBlock() Fluent:Notify({ Title = "自动拦截", Content = "已 hook 可疑 remote 数=" .. n .. "，详见控制台(F9)", Duration = 5 }) end })
end
do
Tabs.Setting:AddSection("设置")
Tabs.Setting:AddDropdown("Theme", { Title = "界面主题", Values = { "Aqua(青绿)", "Dark(深灰)", "Darker(更暗)", "Light(亮色)", "Amethyst(紫)", "Rose(玫瑰)" }, Default = "Aqua(青绿)", Callback = function(v)
local map = { ["Aqua(青绿)"] = "Aqua", ["Dark(深灰)"] = "Dark", ["Darker(更暗)"] = "Darker", ["Light(亮色)"] = "Light", ["Amethyst(紫)"] = "Amethyst", ["Rose(玫瑰)"] = "Rose" }
local theme = map[v] or "Aqua"
pcall(function() Fluent:SetTheme(theme) end)
C.Theme = theme
end })
Tabs.Setting:AddToggle("Clicker", { Title = "自动连点器", Default = false, Callback = function(v) T.Clicker = v if v then CM.ClickerEnable() else CM.ClickerDisable() end end })
Tabs.Setting:AddToggle("ToolGlow", { Title = "道具美化(手持发光)", Default = false, Callback = function(v) T.ToolGlow = v if v then CM.ToolGlowEnable() else CM.ToolGlowDisable() end end })
Tabs.Setting:AddButton({ Title = "服务器跳转", Callback = function() CM.ServerHop() end })
Tabs.Setting:AddButton({ Title = "重新加入", Callback = function() CM.Rejoin() end })
Tabs.Setting:AddButton({ Title = "复制脚本加载链接", Callback = function() copyToClipboard('loadstring(game:HttpGet("https://ghproxy.net/https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua"))()') end })
Tabs.Setting:AddButton({ Title = "保存配置", Callback = function() SaveConfig() Fluent:Notify({ Title = "配置", Content = "已保存", Duration = 2 }) end })
Tabs.Setting:AddButton({ Title = "热更新(保存并重载)", Callback = function() HotUpdate() end })
Tabs.Setting:AddButton({ Title = "卸载脚本", Callback = function() UnloadAll() end })
T.KickProtect = true
T.AntiAFK = true
T.KickGuard = true
T.KickRejoin = true
AntiAFKEnable()
KickGuardEnable()
KickRejoinEnable()
Fluent:Notify({ Title = "CheatMenu", Content = "已加载 v5.0.3", Duration = 5 })
RestoreFeatures()
print("[CheatMenu] ✅ 加载完成 v5.0.3")
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
Window:Minimize()
end)
end
addToggleButton(Window)
end
buildMenu()
startTogglePolish()
