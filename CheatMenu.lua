print(('[CheatMenu] build 2026-09-27 18:59 sha 4517db13 bytes 27199'):format('2026-09-27 18:59','4517db13',27199))
print("[CheatMenu] ===== 加载开始 · v1.1.0 =====")
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
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
if not Fluent then
error("[CheatMenu] ❌ Fluent UI 库加载失败(检查网络)")
end
local AC = {}
function AC.InstallNamecallHook()
if not hookmetamethod or not newcclosure then return false end
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
return old(self, ...)
end))
return old ~= nil
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
orig = hookfunction(kf, wrapper)
if type(orig) ~= "function" then return false end
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
local m = math.max(1, tonumber(LP:GetAttribute("liftMachine")) or 1)
if m <= 1 then
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
local function sellHeld()
local rf = RFunction("B_Sell")
if rf then
local ok, res = pcall(function() return rf:InvokeServer() end)
if ok then return true end
end
local re = REvent("B_Sell")
if re then
pcall(function() re:FireServer() end)
return true
end
return false
end
local function moveToSeller()
local seller = findSeller()
local _, _, root = GC()
if not root then return end
local pos
if seller then
local part = seller:FindFirstChild("HumanoidRootPart") or seller.PrimaryPart
or seller:FindFirstChildWhichIsA("BasePart", true)
if part then pos = part.Position end
end
if not pos then pos = Vector3.new(134.125, 0.125, 83.866) end
root.CFrame = CFrame.new(pos + Vector3.new(4, 0, 0))
root.AssemblyLinearVelocity = Vector3.zero
task.wait(0.2)
end
local SellThread = nil
local function sellLowCPSTools()
if SellThread then return end
SellThread = task.spawn(function()
local _, hum = GC()
if not hum then SellThread = nil return end
moveToSeller()
local total = 0
for round = 1, 200 do
if not T.AutoSell then break end
local picks = {}
local function scan(list)
if not list then return end
for _, t in ipairs(list:GetChildren()) do
if isEntityTool(t) and not isExclusive(t) then
local cps = getBrainrotCPS(t)
local th = tonumber(C.SellMinCPS) or 100000
if cps and cps < th then
picks[#picks + 1] = { Tool = t, CPS = cps }
end
end
end
end
scan(LP.Character)
scan(LP:FindFirstChild("Backpack"))
if #picks == 0 then break end
for _, e in ipairs(picks) do
if not T.AutoSell then break end
local tool = e.Tool
if tool and tool.Parent then
pcall(function() hum:UnequipTools() end)
task.wait(0.08)
pcall(function() hum:EquipTool(tool) end)
task.wait(0.2)
if tool.Parent == LP.Character then
sellHeld()
task.wait(0.3)
if not tool.Parent then total = total + 1 end
end
end
task.wait(0.05)
end
task.wait(0.2)
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
pcall(function() hum:UnequipTools() end)
task.wait(0.1)
local done, failed = 0, 0
for i = 1, 30 do
pcall(function() hum:UnequipTools() end)
if Fire("S_Interact", i) then done = done + 1 else failed = failed + 1 end
task.wait(0.1)
end
print("[CheatMenu] 收起脑红 · 触发 " .. done .. " · 失败 " .. failed)
WithdrawThread = nil
end)
end
local CollectThread = nil
local function collectAllCash()
if CollectThread then return end
CollectThread = task.spawn(function()
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
if slots then
for _, slot in ipairs(slots:GetChildren()) do
local idx = tonumber(tostring(slot.Name):match("(%d+)"))
if idx and idx >= 1 and idx <= 30 then
local has = false
for _, c in ipairs(slot:GetDescendants()) do
if c:GetAttribute("ID") ~= nil then has = true break end
end
if has then
Fire("B_Collect", idx)
task.wait(0.05)
end
end
end
else
for i = 1, 30 do Fire("B_Collect", i) task.wait(0.03) end
end
print("[CheatMenu] ✅ 收起货币完成")
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
Use natural, colloquial Chinese.
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
local function TransRequest(text)
if not HS then return nil end
local body = HS:JSONEncode({
model = MODEL,
messages = {
{ role = "system", content = SYS_PROMPT },
{ role = "user", content = text },
},
temperature = 0.1,
top_p = 0.6,
max_tokens = 512,
stream = false,
})
local ok, res = pcall(function()
return HS:RequestAsync({
Url = HOST .. "/v1/chat/completions",
Method = "POST",
Headers = {
["Content-Type"] = "application/json",
["Authorization"] = "Bearer " .. KEY,
},
Body = body,
})
end)
if not ok or not res or res.StatusCode ~= 200 then return nil end
local ok2, d = pcall(HS.JSONDecode, HS, res.Body)
if not ok2 or not d or not d.choices or not d.choices[1] then return nil end
local out = d.choices[1].message and d.choices[1].message.content
return out
end
local function shouldTranslate(s)
if type(s) ~= "string" or s == "" then return false end
if string.find(s, "[\228-\233]") then return false end
if not string.find(s, "[%a]") then return false end
return true
end
function Trans.Translate(text)
if not T.Translate or type(text) ~= "string" or text == "" then return nil end
text = text:gsub("^%s+", ""):gsub("%s+$", "")
if text == "" or not shouldTranslate(text) then return nil end
if TransCache[text] then return TransCache[text] end
local r = TransRequest(text)
if r and r ~= "" and r ~= text then
r = r:gsub("^%s*(翻译|译文|中文|汉化)%s*[:：]%s*", "")
TransCache[text] = r
return r
end
return nil
end
LoadConfig()
local Window = Fluent:CreateWindow({
Title = "CheatMenu",
SubTitle = "v1.1.0",
TabWidth = 100,
Size = UDim2.fromOffset(480, 540),
Acrylic = true,
Theme = "Dark",
MinimizeKey = Enum.KeyCode.G,
})
local Tabs = {
AFK = Window:AddTab({ Title = "挂机", Icon = "home" }),
AC  = Window:AddTab({ Title = "反作弊", Icon = "shield" }),
}
Tabs.AFK:AddSection("挂机防踢")
Tabs.AFK:AddToggle("AntiAFK", { Title = "挂机防踢 (AntiAFK)", Default = (T.AntiAFK ~= false), Callback = function(v) T.AntiAFK = v if v then AntiAFKEnable() end end })
Tabs.AFK:AddToggle("KickGuard", { Title = "本地防踢 (KickGuard)", Default = false, Callback = function(v) T.KickGuard = v if v then KickGuardEnable() else KickGuardDisable() end end })
Tabs.AFK:AddToggle("KickRejoin", { Title = "前兆抢传 (KickRejoin)", Default = false, Callback = function(v) T.KickRejoin = v if v then KickRejoinEnable() end end })
Tabs.AFK:AddSection("训练")
Tabs.AFK:AddToggle("AutoTrain", { Title = "自动训练 (踢击力量)", Default = false, Callback = function(v) T.AutoTrain = v if v then AutoTrainEnable() end end })
Tabs.AFK:AddToggle("AutoBonus", { Title = "自动领取训练加成", Default = false, Callback = function(v) T.AutoBonus = v if v then AutoBonusEnable() end end })
Tabs.AFK:AddSlider("AutoTrainSec", { Title = "训练循环间隔(秒)", Min = 1, Max = 30, Default = 5, Rounding = 1, Callback = function(v) C.AutoTrainSec = v end })
Tabs.AFK:AddSection("健身房")
Tabs.AFK:AddToggle("AutoGym", { Title = "自动锻炼 (AutoGym)", Default = false, Callback = function(v) T.AutoGym = v if v then AutoGymEnable() end end })
Tabs.AFK:AddSection("基地操作")
Tabs.AFK:AddToggle("AutoSell", { Title = "自动售卖 CPS (每轮)", Default = false, Callback = function(v) T.AutoSell = v if v then sellLowCPSTools() end end })
Tabs.AFK:AddSlider("SellMinCPS", { Title = "CPS 售卖门槛", Min = 1000, Max = 1000000, Default = 100000, Rounding = 0, Callback = function(v) C.SellMinCPS = v end })
Tabs.AFK:AddButton({ Title = "一键收起脑红", Callback = function() withdrawAllBrainrots() end })
Tabs.AFK:AddButton({ Title = "一键收起货币", Callback = function() collectAllCash() end })
Tabs.AFK:AddSection("翻译")
Tabs.AFK:AddToggle("Translate", { Title = "界面翻译", Default = false, Callback = function(v) T.Translate = v end })
Tabs.AFK:AddButton({ Title = "翻译测试 (Hello World)", Callback = function()
local r = Trans.Translate("Collect all eggs")
print("[CheatMenu] 翻译测试: " .. tostring(r))
Fluent:Notify({ Title = "翻译", Content = tostring(r), Duration = 4 })
end })
Tabs.AC:AddSection("反作弊")
Tabs.AC:AddToggle("NamecallHook", { Title = "namecall 拦截 (防踢)", Default = false, Callback = function(v) T.NamecallHook = v if v then AC.InstallNamecallHook() end end })
Tabs.AC:AddToggle("AntiFling", { Title = "防甩飞 (AntiFling)", Default = false, Callback = function(v) T.AntiFling = v if v then AntiFlingEnable() else AntiFlingDisable() end end })
Tabs.AC:AddButton({ Title = "保存配置", Callback = function() SaveConfig() Fluent:Notify({ Title = "配置", Content = "已保存", Duration = 2 }) end })
T.AntiAFK = true
AntiAFKEnable()
Fluent:Notify({ Title = "CheatMenu", Content = "已加载 v1.1.0 (呼出键 G)", Duration = 5 })
print("[CheatMenu] ✅ 加载完成 v1.1.0 (呼出键 G)")
