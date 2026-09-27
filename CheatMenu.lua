print(('[CheatMenu] build 2026-09-27 22:22 sha 57f98cf6 bytes 36039'):format('2026-09-27 22:22','57f98cf6',36039))
print("[CheatMenu] ===== 加载开始 · v3.0.0 =====")
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
local FluentSources = {
"https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua",
"https://ghfast.top/https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://ghproxy.net/https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://gh-proxy.com/https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua",
"https://cdn.jsdelivr.net/gh/dawid-scripts/Fluent@master/main.lua",
}
for _, fsrc in ipairs(FluentSources) do
local ok1, body = pcall(function() return game:HttpGet(fsrc) end)
if ok1 and type(body) == "string" and #body > 5000 then
local ok2, chunk = pcall(loadstring, body)
if ok2 and chunk then
local ok3, loaded = pcall(chunk)
if ok3 and loaded then
Fluent = loaded
print("[CheatMenu] Fluent 加载成功 <- " .. fsrc)
break
end
end
end
end
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
local function UnloadAll()
for k in pairs(T) do T[k] = false end
local disables = { KickGuardDisable, AntiFlingDisable }
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
LoadConfig()
local Window = Fluent:CreateWindow({
Title = "CheatMenu",
SubTitle = "v3.0.0",
TabWidth = 100,
Size = UDim2.fromOffset(480, 520),
Acrylic = false,
Theme = "Dark",
MinimizeKey = Enum.KeyCode.G,
})
if getgenv then getgenv().CM_Window = Window end
local Tabs = {
AFK     = Window:AddTab({ Title = "挂机", Icon = "home" }),
AC      = Window:AddTab({ Title = "反作弊", Icon = "shield" }),
Setting = Window:AddTab({ Title = "设置", Icon = "settings" }),
}
Tabs.AFK:AddSection("挂机防踢")
Tabs.AFK:AddToggle("KickProtect", { Title = "挂机防踢(挂机+本地拦截+前兆抢传)", Default = true, Callback = function(v)
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
Tabs.AFK:AddSection("踢击训练")
Tabs.AFK:AddToggle("AutoTrain", { Title = "踢击训练", Default = false, Callback = function(v) T.AutoTrain = v if v then AutoTrainEnable() end end })
Tabs.AFK:AddToggle("AutoBonus", { Title = "领取踢击距离", Default = false, Callback = function(v) T.AutoBonus = v if v then AutoBonusEnable() end end })
Tabs.AFK:AddSlider("AutoTrainSec", { Title = "训练循环间隔(秒)", Min = 1, Max = 30, Default = 5, Rounding = 1, Callback = function(v) C.AutoTrainSec = v end })
Tabs.AFK:AddSection("基地操作")
Tabs.AFK:AddToggle("AutoSell", { Title = "卖 CPS 脑红", Default = false, Callback = function(v) T.AutoSell = v if v then sellLowCPSTools() end end })
Tabs.AFK:AddInput("SellMinCPS", { Title = "售卖门槛(可填 1M / 500K / 数字)", Default = "100K", Placeholder = "例如 1M = 100万", Callback = function(v)
local n = parseAmount(v)
if n and n > 0 then C.SellMinCPS = n end
end })
Tabs.AFK:AddButton({ Title = "一键收起脑红", Callback = function() withdrawAllBrainrots() end })
Tabs.AFK:AddButton({ Title = "一键收钱", Callback = function() collectAllCash() end })
Tabs.AC:AddSection("反作弊")
Tabs.AC:AddToggle("ACBypass", { Title = "反作弊(一键: 防踢+拦远程+防甩飞)", Default = false, Callback = function(v)
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
Tabs.AC:AddButton({ Title = "扫描抓包", Callback = function() scanRemotes() Fluent:Notify({ Title = "抓包", Content = "已列全部远程事件到控制台(F9)", Duration = 4 }) end })
Tabs.Setting:AddSection("设置")
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
Fluent:Notify({ Title = "CheatMenu", Content = "已加载 v3.0.0", Duration = 5 })
RestoreFeatures()
print("[CheatMenu] ✅ 加载完成 v3.0.0")
