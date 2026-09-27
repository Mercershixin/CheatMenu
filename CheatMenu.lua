print(('[CheatMenu] build 2026-09-27 20:39 sha eacfdb34 bytes 68744'):format('2026-09-27 20:39','eacfdb34',68744))
print("[CheatMenu] ===== 加载开始 · v2.0.0 =====")
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
local function loadTransCache()
LoadConfig()
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
local blocked = { "iac-respond", "iacrespond", "kick", "ban", "report", "anticheat", "detect", "flag", "exploit" }
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
local function triggerSellerPrompt()
local npcs = WS:FindFirstChild("NPCs")
if not npcs then return false end
for _, o in ipairs(npcs:GetDescendants()) do
if o:IsA("ProximityPrompt") and o.Enabled then
local parent = o.Parent
if parent and (parent.Name == "Timmy" or tostring(parent:GetAttribute("Name")) == "Timmy") then
if type(fireproximityprompt) == "function" then
local ok = pcall(fireproximityprompt, o)
if ok then return true end
end
pcall(function() o:InputHoldBegin() end)
task.wait(0.05)
pcall(function() o:InputHoldEnd() end)
return true
end
end
end
return false
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
pcall(function() hum:UnequipTools() end)
task.wait(0.06)
pcall(function() hum:EquipTool(tool) end)
task.wait(0.16)
if tool.Parent == LP.Character then
sellHeldBrainrot()
local deadline = os.clock() + 0.85
while os.clock() < deadline and tool.Parent do task.wait(0.025) end
if not tool.Parent then
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
local out = d.choices[1].message and d.choices[1].message.content
return out
end
local function shouldTranslate(s)
if type(s) ~= "string" or s == "" then return false end
local hasCJK = string.find(s, "[\228-\233]") ~= nil
local hasAlpha = string.find(s, "[%a]") ~= nil
if not hasCJK and not hasAlpha then return false end
if s:find("$", 1, true) or s:find("€", 1, true) or s:find("¥", 1, true) then return false end
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
for _, obj in ipairs(workspace:GetDescendants()) do
if obj:IsA("ProximityPrompt") then
if obj.ActionText and obj.ActionText ~= "" then
local tr = Trans.Translate(obj.ActionText, true)
if tr then obj.ActionText = tr end
end
elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
for _, child in ipairs(obj:GetDescendants()) do
translateGuiEl(child)
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
task.wait(2)
scanAndTranslate()
end
TransLoop = nil
end)
end
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
local sp = (C.FlySpeed or 50) * math.min(dt, 0.1)
r.CFrame = r.CFrame + (dir.Unit * sp)
end
r.AssemblyLinearVelocity = Vector3.zero
r.AssemblyAngularVelocity = Vector3.zero
end)
end
local SpeedConn = nil
local SpeedConn2 = nil
local function SpeedEnable()
if SpeedConn then return end
local function apply()
if not T.Speed then return end
local _, hum = GC()
if hum then hum.WalkSpeed = C.Speed or 30 end
end
apply()
SpeedConn = RS.Stepped:Connect(apply)
SpeedConn2 = RS.RenderStepped:Connect(apply)
print("[CheatMenu] 加速已开 · WalkSpeed=" .. tostring(C.Speed or 30))
end
local function SpeedDisable()
if SpeedConn then SpeedConn:Disconnect() SpeedConn = nil end
if SpeedConn2 then SpeedConn2:Disconnect() SpeedConn2 = nil end
local _, hum = GC()
if hum then hum.WalkSpeed = 16 end
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
local NoClipConn = nil
local function NoClipEnable()
if NoClipConn then return end
local function noclip()
local ch = LP.Character
if not ch then return end
for _, part in ipairs(ch:GetDescendants()) do
if part:IsA("BasePart") then part.CanCollide = false end
end
end
noclip()
NoClipConn = RS.Stepped:Connect(noclip)
end
local function NoClipDisable()
if NoClipConn then NoClipConn:Disconnect() NoClipConn = nil end
local ch = LP.Character
if ch then
for _, part in ipairs(ch:GetDescendants()) do
if part:IsA("BasePart") then part.CanCollide = true end
end
end
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
local function TeleportToPlayer(target)
local _, _, root = GC()
if not root or not target then return end
local tchar = target.Character
if not tchar then return end
local troot = tchar:FindFirstChild("HumanoidRootPart")
if not troot then return end
root.CFrame = troot.CFrame + Vector3.new(0, 3, 0)
end
local function scanRemotes()
local events, functions = {}, {}
for _, obj in ipairs(RStorage:GetDescendants()) do
if obj:IsA("RemoteEvent") then events[#events + 1] = obj.Name
elseif obj:IsA("RemoteFunction") then functions[#functions + 1] = obj.Name end
end
local function dedup(list)
local seen, out = {}, {}
for _, v in ipairs(list) do if not seen[v] then seen[v] = true out[#out + 1] = v end end
table.sort(out)
return out
end
events, functions = dedup(events), dedup(functions)
print("[抓包] ===== RemoteEvent 共 " .. #events .. " 个 =====")
for _, n in ipairs(events) do print("[抓包] Event: " .. n) end
print("[抓包] ===== RemoteFunction 共 " .. #functions .. " 个 =====")
for _, n in ipairs(functions) do print("[抓包] Function: " .. n) end
local result = {}
for _, n in ipairs(events) do result[#result + 1] = "E:" .. n end
for _, n in ipairs(functions) do result[#result + 1] = "F:" .. n end
return result
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
local AimConn = nil
local function AimDisable()
if AimConn then AimConn:Disconnect() AimConn = nil end
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
local skip = (not (hrp and hrp.Parent and hum and hum.Health > 0))
if T.AimTeamCheck and pl.Team == LP.Team then skip = true end
if not skip and T.AimWallCheck then
local origin = cam.CFrame.Position
local dir = hrp.Position - origin
local params = RaycastParams.new()
params.FilterDescendantsInstances = { LP.Character, pl.Character }
params.FilterType = Enum.RaycastFilterType.Exclude
local hit = workspace:Raycast(origin, dir, params)
if hit then skip = true end
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
return best
end
local function AimEnable()
AimDisable()
AimConn = RS.RenderStepped:Connect(function()
if not T.Aim then return end
local target = getAimTarget()
if not target then return end
local cam = workspace.CurrentCamera
local smooth = math.max(1, C.AimSmooth or 5)
cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position, target.Position), 1 / smooth)
end)
end
local function cleanupHitbox(ch)
pcall(function()
for _, o in ipairs(ch:GetDescendants()) do
if o.Name == "CheatHitbox" then o:Destroy() end
end
end)
end
if LP.Character then cleanupHitbox(LP.Character) end
LP.CharacterAdded:Connect(function(ch) task.wait(0.5) cleanupHitbox(ch) end)
local GodConn = nil
local function GodEnable()
if GodConn then return end
local function apply()
local _, hum = GC()
if hum then
hum.MaxHealth = math.huge
hum.Health = math.huge
end
end
apply()
GodConn = RS.Stepped:Connect(apply)
end
local function GodDisable()
if GodConn then GodConn:Disconnect() GodConn = nil end
end
local function InvisibleEnable()
local ch = LP.Character
if not ch then return end
for _, part in ipairs(ch:GetDescendants()) do
if part:IsA("BasePart") then part.Transparency = 1 end
end
end
local function InvisibleDisable()
local ch = LP.Character
if not ch then return end
for _, part in ipairs(ch:GetDescendants()) do
if part:IsA("BasePart") then part.Transparency = 0 end
end
end
local ESPMap = {}
local function espAdd(pl)
if pl == LP or not T.ESP then return end
local ch = pl.Character
if not ch then return end
local hl = Instance.new("Highlight")
hl.Name = "CheatESP"
hl.FillColor = Color3.fromRGB(255, 90, 90)
hl.FillTransparency = 0.6
hl.OutlineColor = Color3.fromRGB(255, 255, 255)
hl.OutlineTransparency = 0
hl.Parent = ch
ESPMap[pl] = hl
end
local function ESPEnable()
for _, pl in ipairs(Players:GetPlayers()) do espAdd(pl) end
Players.PlayerAdded:Connect(function(pl)
pl.CharacterAdded:Connect(function() espAdd(pl) end)
end)
end
local function ESPDisable()
for _, hl in pairs(ESPMap) do pcall(function() hl:Destroy() end) end
ESPMap = {}
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
if r and HideBaseY then
r.CFrame = CFrame.new(r.Position.X, HideBaseY + 2, r.Position.Z)
end
end)
end
local function UnloadAll()
for k in pairs(T) do T[k] = false end
local disables = { FlyDisable, AimDisable, GodDisable, NoClipDisable, HideDisable,
ESPDisable, InvisibleDisable, KickGuardDisable, AntiFlingDisable, FullBrightDisable, NoFogDisable, SpeedDisable }
for _, fn in ipairs(disables) do pcall(fn) end
pcall(function() if AFKConn then AFKConn:Disconnect() end end)
pcall(function() if KG and KG.rjConn then KG.rjConn:Disconnect() end end)
pcall(function() if JumpConn then JumpConn:Disconnect() end end)
pcall(function() if getgenv and getgenv().CM_Window then getgenv().CM_Window:Destroy() getgenv().CM_Window = nil end end)
pcall(function() if getgenv and getgenv().CM_ToggleSG then getgenv().CM_ToggleSG:Destroy() getgenv().CM_ToggleSG = nil end end)
print("[CheatMenu] ✅ 已干净卸载")
end
local function RestoreFeatures()
if T.KickProtect or T.AntiAFK then AntiAFKEnable() KickGuardEnable() KickRejoinEnable() end
if T.Fly then FlyEnable() end
if T.Speed then SpeedEnable() end
if T.InfiniteJump then InfiniteJumpEnable() end
if T.NoClip then NoClipEnable() end
if T.Hide then HideEnable() end
if T.FullBright then FullBrightEnable() end
if T.NoFog then NoFogEnable() end
if T.Aim then AimEnable() end
if T.God then GodEnable() end
if T.Invisible then InvisibleEnable() end
if T.ESP then ESPEnable() end
if T.AutoTrain then AutoTrainEnable() end
if T.AutoGym then AutoGymEnable() end
if T.AutoBonus then AutoBonusEnable() end
if T.NamecallHook then AC.InstallNamecallHook() end
if T.RemoteBlock then AC.InstallNamecallHook() end
if T.AntiFling then AntiFlingEnable() end
end
local function HotUpdate()
Fluent:Notify({ Title = "热更新", Content = "保存配置并重新加载...", Duration = 3 })
SaveConfig()
task.spawn(function()
task.wait(0.5)
UnloadAll()
task.wait(0.3)
local ok, err = pcall(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua"))()
end)
if not ok then warn("[CheatMenu] 热更新失败: " .. tostring(err)) end
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
local function MuteEnable()
for _, s in ipairs(workspace:GetDescendants()) do
if s:IsA("Sound") then s.Volume = 0 end
end
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
local CircleConn = nil
local function getTPTargetPlayer()
local name = Fluent.Options.TPTarget and Fluent.Options.TPTarget.Value
if not name then return nil end
return Players:FindFirstChild(name)
end
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
local ClickerConn = nil
local function ClickerEnable()
if ClickerConn then return end
ClickerConn = RS.Stepped:Connect(function()
if not T.Clicker then return end
if type(mouse1click) == "function" then
mouse1click()
elseif type(mouse1press) == "function" then
mouse1press()
task.wait(0.01)
mouse1release()
end
end)
end
local function ClickerDisable()
if ClickerConn then ClickerConn:Disconnect() ClickerConn = nil end
end
local function ServerHop()
local ts = game:GetService("TeleportService")
pcall(function() ts:Teleport(game.PlaceId, LP) end)
end
local SilentAimConn = nil
local function SilentAimEnable()
if SilentAimConn then return end
SilentAimConn = RS.RenderStepped:Connect(function()
if not T.SilentAim then return end
local target = getAimTarget()
if not target then return end
workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, target.Position)
end)
end
local function SilentAimDisable()
if SilentAimConn then SilentAimConn:Disconnect() SilentAimConn = nil end
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
local function FlingTarget()
local target = getTPTargetPlayer()
if not (target and target.Character) then return end
local hrp = target.Character:FindFirstChild("HumanoidRootPart")
local _, _, r = GC()
if not (hrp and r) then return end
for i = 1, 12 do
r.CFrame = hrp.CFrame * CFrame.new(0, 0, -1)
r.AssemblyLinearVelocity = Vector3.new(0, 200, 0)
task.wait()
end
end
local function TeleportOnDeathEnable()
if not T.TeleportOnDeath then return end
local target = getTPTargetPlayer()
LP.CharacterAdded:Connect(function()
task.wait(0.5)
if T.TeleportOnDeath then TeleportToPlayer(target) end
end)
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
local AutoInteractConn = nil
local function AutoInteractEnable()
if AutoInteractConn then return end
AutoInteractConn = RS.Stepped:Connect(function()
if not T.AutoInteract then return end
local _, _, r = GC()
if not r then return end
for _, p in ipairs(workspace:GetDescendants()) do
if p:IsA("ProximityPrompt") and p.Enabled then
local pp = p.Parent
local pos = pp and (pp:IsA("BasePart") and pp.Position or (pp:IsA("Model") and (function() local ok,pv = pcall(pp.GetPivot,pp) return ok and pv.Position or nil end)()) or nil)
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
for _, p in ipairs(workspace:GetDescendants()) do
if p:IsA("ProximityPrompt") then p.HoldDuration = 0 end
end
end
local function BadgeBypassEnable()
if not hookfunction then return end
local bs = game:GetService("BadgeService")
pcall(function() hookfunction(bs.UserHasBadgeAsync, function() return true end) end)
end
local function ChatBypassEnable()
local urls = {
"https://raw.githubusercontent.com/AnnaRoblox/AnnaBypasser/refs/heads/main/AnnaBypasser.lua",
}
for _, u in ipairs(urls) do
local ok = pcall(function() loadstring(game:HttpGet(u))() end)
if ok then return end
end
print("[CheatMenu] 聊天绕过脚本加载失败")
end
LoadConfig()
local Window = Fluent:CreateWindow({
Title = "CheatMenu",
SubTitle = "v2.0.0",
TabWidth = 100,
Size = UDim2.fromOffset(480, 540),
Acrylic = false,
Theme = "Dark",
MinimizeKey = Enum.KeyCode.G,
})
if getgenv then getgenv().CM_Window = Window end
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
Tabs.AFK:AddSection("防踢")
Tabs.AFK:AddToggle("KickProtect", { Title = "防踢（挂机防踢 + 本地拦截 + 前兆抢传）", Default = true, Callback = function(v)
T.KickProtect = v
T.AntiAFK = v
T.KickGuard = v
T.KickRejoin = v
if v then
AntiAFKEnable()
KickGuardEnable()
KickRejoinEnable()
else
KickGuardDisable()
end
end })
Tabs.AFK:AddSection("训练")
Tabs.AFK:AddToggle("AutoTrain", { Title = "自动训练", Default = false, Callback = function(v) T.AutoTrain = v if v then AutoTrainEnable() end end })
Tabs.AFK:AddToggle("AutoBonus", { Title = "自动领取训练加成", Default = false, Callback = function(v) T.AutoBonus = v if v then AutoBonusEnable() end end })
Tabs.AFK:AddSlider("AutoTrainSec", { Title = "训练循环间隔(秒)", Min = 1, Max = 30, Default = 5, Rounding = 1, Callback = function(v) C.AutoTrainSec = v end })
Tabs.AFK:AddSection("健身房")
Tabs.AFK:AddToggle("AutoGym", { Title = "自动锻炼", Default = false, Callback = function(v) T.AutoGym = v if v then AutoGymEnable() end end })
Tabs.AFK:AddSection("基地操作")
Tabs.AFK:AddToggle("AutoSell", { Title = "自动售卖", Default = false, Callback = function(v) T.AutoSell = v if v then sellLowCPSTools() end end })
Tabs.AFK:AddInput("SellMinCPS", { Title = "售卖门槛(可填 1M / 500K / 数字)", Default = "100K", Placeholder = "例如 1M = 100万", Callback = function(v)
local n = parseAmount(v)
if n and n > 0 then C.SellMinCPS = n end
end })
Tabs.AFK:AddButton({ Title = "一键收起脑红", Callback = function() withdrawAllBrainrots() end })
Tabs.AFK:AddButton({ Title = "一键收起货币", Callback = function() collectAllCash() end })
Tabs.Trans:AddSection("翻译")
Tabs.Trans:AddDropdown("TransLang", { Title = "目标语言", Values = { "中文", "英文", "日文", "韩文", "泰文", "俄文", "阿拉伯文", "印尼语" }, Default = "中文", Callback = function(v)
local map = { ["中文"] = "zh", ["英文"] = "en", ["日文"] = "ja", ["韩文"] = "ko", ["泰文"] = "th", ["俄文"] = "ru", ["阿拉伯文"] = "ar", ["印尼语"] = "id" }
C.TransLang = map[v] or "zh"
end })
Tabs.Trans:AddToggle("Translate", { Title = "界面翻译(自动翻译游戏内文字)", Default = false, Callback = function(v) T.Translate = v if v then startTranslateLoop() end end })
Tabs.Trans:AddInput("TransInput", { Title = "输入文本", Default = "", Placeholder = "输入要翻译/发送的文字" })
Tabs.Trans:AddButton({ Title = "翻译文本", Callback = function()
local txt = Fluent.Options.TransInput and Fluent.Options.TransInput.Value
if not txt or txt == "" then Fluent:Notify({ Title = "翻译", Content = "请先输入文本", Duration = 3 }) return end
local r = Trans.Translate(txt, true)
if r then
Fluent:Notify({ Title = "翻译结果", Content = r, Duration = 6 })
else
Fluent:Notify({ Title = "翻译", Content = "翻译失败(检查本地翻译服务是否开启)", Duration = 4 })
end
end })
Tabs.Trans:AddButton({ Title = "翻译并发送到聊天", Callback = function()
local txt = Fluent.Options.TransInput and Fluent.Options.TransInput.Value
if not txt or txt == "" then Fluent:Notify({ Title = "翻译", Content = "请先输入文本", Duration = 3 }) return end
local r = Trans.Translate(txt, true)
if r then
sendChat(r)
Fluent:Notify({ Title = "已发送", Content = r, Duration = 4 })
else
sendChat(txt)
Fluent:Notify({ Title = "已发送(原文)", Content = txt, Duration = 4 })
end
end })
Tabs.Move:AddSection("移动")
Tabs.Move:AddParagraph({ Title = "飞行按键：WASD 移动，空格上升，左Ctrl 下降", Content = "" })
Tabs.Move:AddToggle("Fly", { Title = "飞行", Default = false, Callback = function(v) T.Fly = v if v then FlyEnable() else FlyDisable() end end })
Tabs.Move:AddSlider("FlySpeed", { Title = "飞行速度", Min = 10, Max = 1000, Default = 50, Rounding = 0, Callback = function(v) C.FlySpeed = v end })
Tabs.Move:AddToggle("Speed", { Title = "加速", Default = false, Callback = function(v) T.Speed = v if v then SpeedEnable() else SpeedDisable() end end })
Tabs.Move:AddSlider("SpeedVal", { Title = "移动速度", Min = 16, Max = 1000, Default = 30, Rounding = 0, Callback = function(v) C.Speed = v if T.Speed then SpeedEnable() end end })
Tabs.Move:AddToggle("InfiniteJump", { Title = "无限跳", Default = false, Callback = function(v) T.InfiniteJump = v if v then InfiniteJumpEnable() end end })
Tabs.Move:AddToggle("NoClip", { Title = "穿墙", Default = false, Callback = function(v) T.NoClip = v if v then NoClipEnable() else NoClipDisable() end end })
Tabs.Move:AddToggle("Hide", { Title = "藏地下", Default = false, Callback = function(v) T.Hide = v if v then HideEnable() else HideDisable() end end })
Tabs.Move:AddSlider("HideDepth", { Title = "藏地下深度(浅=可交互)", Min = 1, Max = 30, Default = 5, Rounding = 0, Callback = function(v) C.HideDepth = v end })
Tabs.Move:AddToggle("Spin", { Title = "自转", Default = false, Callback = function(v) T.Spin = v if v then SpinEnable() else SpinDisable() end end })
Tabs.Move:AddSlider("SpinSpeed", { Title = "自转速度", Min = 1, Max = 60, Default = 10, Rounding = 0, Callback = function(v) C.SpinSpeed = v end })
Tabs.Move:AddToggle("AirWalk", { Title = "踏空(空中移动)", Default = false, Callback = function(v) T.AirWalk = v if v then AirWalkEnable() else AirWalkDisable() end end })
Tabs.Move:AddSlider("AirWalkSpeed", { Title = "踏空速度", Min = 10, Max = 200, Default = 30, Rounding = 0, Callback = function(v) C.AirWalkSpeed = v end })
Tabs.World:AddSection("世界")
Tabs.World:AddToggle("FullBright", { Title = "全亮", Default = false, Callback = function(v) T.FullBright = v if v then FullBrightEnable() else FullBrightDisable() end end })
Tabs.World:AddToggle("NoFog", { Title = "去雾", Default = false, Callback = function(v) T.NoFog = v if v then NoFogEnable() else NoFogDisable() end end })
Tabs.World:AddToggle("NightVision", { Title = "夜视", Default = false, Callback = function(v) T.NightVision = v if v then NightVisionEnable() else NightVisionDisable() end end })
Tabs.World:AddToggle("Xray", { Title = "Xray 透视", Default = false, Callback = function(v) T.Xray = v if v then XrayEnable() else XrayDisable() end end })
Tabs.World:AddToggle("SelfGlow", { Title = "自发光", Default = false, Callback = function(v) T.SelfGlow = v if v then SelfGlowEnable() else SelfGlowDisable() end end })
Tabs.World:AddToggle("Mute", { Title = "静音", Default = false, Callback = function(v) T.Mute = v if v then MuteEnable() end end })
Tabs.World:AddSlider("FOV", { Title = "视野 FOV", Min = 70, Max = 120, Default = 100, Rounding = 0, Callback = function(v) C.FOV = v if T.FOV then FOVEnable() end end })
Tabs.World:AddToggle("FOVToggle", { Title = "启用自定义 FOV", Default = false, Callback = function(v) T.FOV = v if v then FOVEnable() else FOVDisable() end end })
Tabs.World:AddSlider("Zoom", { Title = "无限缩放距离", Min = 128, Max = 1000, Default = 400, Rounding = 0, Callback = function(v) C.Zoom = v if T.Zoom then ZoomEnable() end end })
Tabs.World:AddToggle("ZoomToggle", { Title = "启用无限缩放", Default = false, Callback = function(v) T.Zoom = v if v then ZoomEnable() else ZoomDisable() end end })
Tabs.World:AddToggle("AutoInteract", { Title = "自动互动", Default = false, Callback = function(v) T.AutoInteract = v if v then AutoInteractEnable() else AutoInteractDisable() end end })
Tabs.World:AddToggle("InstantPrompt", { Title = "瞬时互动(免长按)", Default = false, Callback = function(v) T.InstantPrompt = v if v then InstantPromptEnable() end end })
local function getPlayerNames()
local names = {}
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LP then names[#names + 1] = pl.Name end
end
return names
end
Tabs.TP:AddSection("传送")
local tpNames = getPlayerNames()
Tabs.TP:AddDropdown("TPTarget", { Title = "目标玩家", Values = tpNames, Default = tpNames[1] })
Tabs.TP:AddButton({ Title = "传送到目标", Callback = function()
local name = Fluent.Options.TPTarget and Fluent.Options.TPTarget.Value
if not name then return end
local target = Players:FindFirstChild(name)
TeleportToPlayer(target)
end })
Tabs.TP:AddToggle("Circle", { Title = "环绕传送", Default = false, Callback = function(v) T.Circle = v if v then CircleEnable() else CircleDisable() end end })
Tabs.TP:AddSlider("CircleRadius", { Title = "环绕半径", Min = 3, Max = 30, Default = 10, Rounding = 0, Callback = function(v) C.CircleRadius = v end })
Tabs.TP:AddSlider("CircleSpeed", { Title = "环绕速度", Min = 1, Max = 30, Default = 5, Rounding = 0, Callback = function(v) C.CircleSpeed = v end })
Tabs.TP:AddToggle("Spectate", { Title = "观察目标", Default = false, Callback = function(v) T.Spectate = v if v then SpectateEnable() else SpectateDisable() end end })
Tabs.TP:AddToggle("TeleportOnDeath", { Title = "死亡后继续传送", Default = false, Callback = function(v) T.TeleportOnDeath = v if v then TeleportOnDeathEnable() end end })
Tabs.TP:AddButton({ Title = "保存当前位置", Callback = function() savePosition() end })
Tabs.TP:AddButton({ Title = "传送回保存位置", Callback = function() teleportToSaved() end })
Tabs.Combat:AddSection("战斗")
Tabs.Combat:AddToggle("Aim", { Title = "自瞄", Default = false, Callback = function(v) T.Aim = v if v then AimEnable() else AimDisable() end end })
Tabs.Combat:AddToggle("AimTeamCheck", { Title = "忽略队友", Default = true, Callback = function(v) T.AimTeamCheck = v end })
Tabs.Combat:AddToggle("AimWallCheck", { Title = "墙壁检查(穿墙不锁)", Default = true, Callback = function(v) T.AimWallCheck = v end })
Tabs.Combat:AddSlider("AimFOV", { Title = "自瞄范围", Min = 50, Max = 500, Default = 200, Rounding = 0, Callback = function(v) C.AimFOV = v end })
Tabs.Combat:AddSlider("AimSmooth", { Title = "平滑度(越大越慢)", Min = 1, Max = 20, Default = 5, Rounding = 0, Callback = function(v) C.AimSmooth = v end })
Tabs.Combat:AddToggle("God", { Title = "无敌", Default = false, Callback = function(v) T.God = v if v then GodEnable() else GodDisable() end end })
Tabs.Combat:AddToggle("Invisible", { Title = "隐身", Default = false, Callback = function(v) T.Invisible = v if v then InvisibleEnable() else InvisibleDisable() end end })
Tabs.Combat:AddToggle("ESP", { Title = "透视高亮", Default = false, Callback = function(v) T.ESP = v if v then ESPEnable() else ESPDisable() end end })
Tabs.Combat:AddToggle("SilentAim", { Title = "静默自瞄(硬锁)", Default = false, Callback = function(v) T.SilentAim = v if v then SilentAimEnable() else SilentAimDisable() end end })
Tabs.Combat:AddToggle("SingleAim", { Title = "指定玩家自瞄", Default = false, Callback = function(v) T.SingleAim = v if v then SingleAimEnable() else SingleAimDisable() end end })
Tabs.Combat:AddToggle("FaceLock", { Title = "面锁(面向目标)", Default = false, Callback = function(v) T.FaceLock = v if v then FaceLockEnable() else FaceLockDisable() end end })
Tabs.Combat:AddButton({ Title = "甩飞目标", Callback = function() FlingTarget() end })
Tabs.AC:AddSection("反作弊")
Tabs.AC:AddToggle("ACBypass", { Title = "反作弊(一键全开: 防踢+拦远程+防甩飞)", Default = false, Callback = function(v)
T.ACBypass = v
T.NamecallHook = v
T.RemoteBlock = v
T.AntiFling = v
if v then
AC.InstallNamecallHook()
AntiFlingEnable()
else
AntiFlingDisable()
end
end })
Tabs.Setting:AddButton({ Title = "保存配置", Callback = function() SaveConfig() Fluent:Notify({ Title = "配置", Content = "已保存", Duration = 2 }) end })
Tabs.Setting:AddButton({ Title = "热更新(保存并重载)", Callback = function() HotUpdate() end })
Tabs.AC:AddToggle("BadgeBypass", { Title = "徽章绕过", Default = false, Callback = function(v) T.BadgeBypass = v if v then BadgeBypassEnable() end end })
Tabs.AC:AddToggle("ChatBypass", { Title = "聊天绕过", Default = false, Callback = function(v) T.ChatBypass = v if v then ChatBypassEnable() end end })
Tabs.AC:AddButton({ Title = "抓包扫描(列全部远程事件)", Callback = function() scanRemotes() Fluent:Notify({ Title = "抓包", Content = "已打印全部远程事件到控制台(F9)", Duration = 4 }) end })
Tabs.Setting:AddToggle("Clicker", { Title = "自动连点器", Default = false, Callback = function(v) T.Clicker = v if v then ClickerEnable() else ClickerDisable() end end })
Tabs.Setting:AddButton({ Title = "服务器跳转", Callback = function() ServerHop() end })
Tabs.Setting:AddButton({ Title = "卸载脚本", Callback = function() UnloadAll() end })
T.KickProtect = true
T.AntiAFK = true
T.KickGuard = true
T.KickRejoin = true
AntiAFKEnable()
KickGuardEnable()
KickRejoinEnable()
local function addToggleButton()
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
addToggleButton()
Fluent:Notify({ Title = "CheatMenu", Content = "已加载 v2.0.0", Duration = 5 })
RestoreFeatures()
print("[CheatMenu] ✅ 加载完成 v2.0.0")
