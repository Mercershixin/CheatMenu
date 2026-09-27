print(('[CheatMenu] build 2026-09-27 18:50 sha 28dd8b55 bytes 36842'):format('2026-09-27 18:50','28dd8b55',36842))
print("[CheatMenu] ===== 加载开始 · v1.0.0 =====")
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
local Menu = {}
local THEME = {
BG      = Color3.fromRGB(20, 20, 24),
TITLE   = Color3.fromRGB(30, 30, 36),
ACCENT  = Color3.fromRGB(255, 255, 255),
SUB     = Color3.fromRGB(150, 150, 160),
GREEN   = Color3.fromRGB(90, 220, 120),
YELLOW  = Color3.fromRGB(240, 200, 80),
RED     = Color3.fromRGB(230, 90, 90),
CYAN    = Color3.fromRGB(90, 200, 220),
PURPLE  = Color3.fromRGB(180, 130, 240),
}
local function makeLabel(parent, text, size, color, pos, transparency)
local l = Instance.new("TextLabel")
l.Text = tostring(text)
l.TextSize = size or 14
l.TextColor3 = color or THEME.ACCENT
l.BackgroundTransparency = 1
l.Font = Enum.Font.Gotham
l.TextXAlignment = Enum.TextXAlignment.Left
l.TextWrapped = true
if transparency then l.TextTransparency = transparency end
if pos then l.Position = pos end
l.Parent = parent
return l
end
function Menu.CreateWindow(cfg)
cfg = cfg or {}
local Key = cfg.Key or Enum.KeyCode.G
local uiRoot = Instance.new("ScreenGui")
uiRoot.Name = "CheatMenu"
uiRoot.ResetOnSpawn = false
uiRoot.IgnoreGuiInset = true
uiRoot.Parent = CoreGui
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(480, 520)
main.Position = UDim2.new(0.5, -240, 0.5, -260)
main.BackgroundColor3 = THEME.BG
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = uiRoot
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main
local title = Instance.new("Frame")
title.Size = UDim2.fromScale(1, 0)
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundColor3 = THEME.TITLE
title.BorderSizePixel = 0
title.Parent = main
makeLabel(title, cfg.Title or "CheatMenu", 16, THEME.ACCENT, UDim2.fromOffset(14, 9))
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.fromOffset(30, 24)
minBtn.Position = UDim2.new(1, -40, 0, 7)
minBtn.Text = "—"
minBtn.TextColor3 = THEME.ACCENT
minBtn.BackgroundColor3 = THEME.TITLE
minBtn.BorderSizePixel = 0
minBtn.Parent = title
local dragging, dragStart, winStart = false, nil, nil
title.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
dragStart = input.Position
winStart = main.Position
end
end)
UIS.InputChanged:Connect(function(input)
if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
local delta = input.Position - dragStart
main.Position = UDim2.new(winStart.X.Scale, winStart.X.Offset + delta.X, winStart.Y.Scale, winStart.Y.Offset + delta.Y)
end
end)
UIS.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
minBtn.MouseButton1Click:Connect(function()
main.Visible = not main.Visible
end)
local minimized = false
UIS.InputBegan:Connect(function(input, gpe)
if gpe then return end
if input.KeyCode == Key then
minimized = not minimized
main.Visible = not minimized
end
end)
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 34)
tabBar.Position = UDim2.fromOffset(0, 38)
tabBar.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
tabBar.BorderSizePixel = 0
tabBar.Parent = main
local pages = Instance.new("Frame")
pages.Size = UDim2.new(1, 0, 1, -72)
pages.Position = UDim2.fromOffset(0, 72)
pages.BackgroundTransparency = 1
pages.Parent = main
local win = { Root = uiRoot, Main = main, Tabs = {} }
local function buildTab(name)
local holder = Instance.new("ScrollingFrame")
holder.Size = UDim2.fromScale(1, 1)
holder.BackgroundTransparency = 1
holder.ScrollBarThickness = 3
holder.CanvasSize = UDim2.fromScale(0, 0)
holder.AutomaticCanvasSize = Enum.AutomaticSize.Y
holder.Visible = false
holder.Parent = pages
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = holder
local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 12)
pad.PaddingRight = UDim.new(0, 12)
pad.PaddingTop = UDim.new(0, 10)
pad.PaddingBottom = UDim.new(0, 10)
pad.Parent = holder
local tab = { Holder = holder, Name = name }
return tab, holder
end
function win:AddTab(name)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 90, 1, 0)
btn.Text = name
btn.TextSize = 14
btn.TextColor3 = THEME.SUB
btn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
btn.BorderSizePixel = 0
btn.AutoButtonColor = false
btn.Parent = tabBar
btn.Position = UDim2.fromOffset(#win.Tabs * 90, 0)
local tab, holder = buildTab(name)
tab.Button = btn
btn.MouseButton1Click:Connect(function()
for _, t in pairs(win.Tabs) do
t.Holder.Visible = false
t.Button.TextColor3 = THEME.SUB
end
tab.Holder.Visible = true
btn.TextColor3 = THEME.ACCENT
end)
win.Tabs[#win.Tabs + 1] = tab
if #win.Tabs == 1 then
tab.Holder.Visible = true
btn.TextColor3 = THEME.ACCENT
end
return tab
end
local TabAPI = {}
TabAPI.__index = TabAPI
local function newTabApi(tab)
return setmetatable({ Tab = tab }, TabAPI)
end
function TabAPI:AddSection(titleText)
local label = makeLabel(self.Tab.Holder, titleText or "", 13, THEME.ACCENT)
label.TextSize = 13
label.LayoutOrder = -1
return label
end
function TabAPI:AddLabel(text, color)
return makeLabel(self.Tab.Holder, text, 13, color or THEME.SUB)
end
function TabAPI:AddDivider()
local d = Instance.new("Frame")
d.Size = UDim2.new(1, 0, 0, 1)
d.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
d.BorderSizePixel = 0
d.Parent = self.Tab.Holder
return d
end
function TabAPI:AddToggle(text, key, default, cb)
local row = Instance.new("Frame")
row.Size = UDim2.new(1, 0, 0, 32)
row.BackgroundTransparency = 1
row.Parent = self.Tab.Holder
makeLabel(row, text, 14, THEME.ACCENT, UDim2.fromOffset(0, 8))
local box = Instance.new("TextButton")
box.Size = UDim2.fromOffset(40, 20)
box.Position = UDim2.new(1, -40, 0, 6)
box.Text = ""
box.BackgroundColor3 = Color3.fromRGB(60, 60, 68)
box.BorderSizePixel = 0
box.AutoButtonColor = false
box.Parent = row
local dot = Instance.new("Frame")
dot.Size = UDim2.fromOffset(16, 16)
dot.Position = UDim2.fromOffset(2, 2)
dot.BackgroundColor3 = THEME.SUB
dot.BorderSizePixel = 0
dot.Parent = box
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
local state = (T[key] ~= nil) and T[key] or (default or false)
T[key] = state
local function render()
dot.BackgroundColor3 = state and THEME.GREEN or THEME.SUB
dot.Position = state and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
end
render()
box.MouseButton1Click:Connect(function()
state = not state
T[key] = state
render()
if cb then pcall(cb, state) end
end)
return row
end
function TabAPI:AddButton(text, cb, color)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, 0, 0, 32)
btn.Text = tostring(text)
btn.TextSize = 14
btn.TextColor3 = THEME.ACCENT
btn.BackgroundColor3 = Color3.fromRGB(46, 46, 56)
btn.BorderSizePixel = 0
btn.AutoButtonColor = false
btn.Parent = self.Tab.Holder
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
if color then btn.TextColor3 = color end
btn.MouseButton1Click:Connect(function()
pcall(cb or function() end)
end)
return btn
end
function TabAPI:AddSlider(text, min, max, step, getter, setter, fmt)
local row = Instance.new("Frame")
row.Size = UDim2.new(1, 0, 0, 40)
row.BackgroundTransparency = 1
row.Parent = self.Tab.Holder
local valLabel = makeLabel(row, "", 13, THEME.GREEN, UDim2.new(1, -70, 0, 0))
valLabel.TextXAlignment = Enum.TextXAlignment.Right
local bar = Instance.new("TextButton")
bar.Size = UDim2.new(1, 0, 0, 14)
bar.Position = UDim2.fromOffset(0, 22)
bar.Text = ""
bar.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
bar.BorderSizePixel = 0
bar.AutoButtonColor = false
bar.Parent = row
Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
local fill = Instance.new("Frame")
fill.Size = UDim2.fromScale(0.3, 1)
fill.BackgroundColor3 = THEME.GREEN
fill.BorderSizePixel = 0
fill.Parent = bar
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
local function render()
local v = getter and getter() or C[text]
if not v then v = min end
local pct = (v - min) / math.max(1e-6, (max - min))
fill.Size = UDim2.fromScale(math.clamp(pct, 0, 1), 1)
valLabel.Text = tostring(text) .. ": " .. (fmt and string.format(fmt, v) or tostring(v))
end
render()
local function setFromMouse(x)
local pct = math.clamp((x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
local v = min + (max - min) * pct
if step then v = min + math.floor((v - min) / step + 0.5) * step end
v = math.clamp(v, min, max)
if setter then pcall(setter, v) end
render()
end
local sliding = false
bar.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then
sliding = true
setFromMouse(input.Position.X)
end
end)
UIS.InputChanged:Connect(function(input)
if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
setFromMouse(input.Position.X)
end
end)
UIS.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
end)
return row
end
function TabAPI:AddDropdown(text, options, default, cb)
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, 0, 0, 32)
btn.Text = tostring(text) .. ": " .. tostring(default or (options and options[1]) or "")
btn.TextSize = 14
btn.TextColor3 = THEME.ACCENT
btn.BackgroundColor3 = Color3.fromRGB(46, 46, 56)
btn.BorderSizePixel = 0
btn.AutoButtonColor = false
btn.Parent = self.Tab.Holder
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
local list = Instance.new("Frame")
list.Size = UDim2.new(1, 0, 0, 0)
list.BackgroundColor3 = Color3.fromRGB(34, 34, 42)
list.BorderSizePixel = 0
list.ClipsDescendants = true
list.Parent = self.Tab.Holder
Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)
local layout = Instance.new("UIListLayout")
layout.Parent = list
local open = false
local current = default or (options and options[1]) or ""
local function refreshOpts()
for _, child in pairs(list:GetChildren()) do
if child:IsA("TextButton") then child:Destroy() end
end
for _, opt in ipairs(options or {}) do
local ob = Instance.new("TextButton")
ob.Size = UDim2.new(1, 0, 0, 26)
ob.Text = tostring(opt)
ob.TextSize = 13
ob.TextColor3 = THEME.ACCENT
ob.BackgroundTransparency = 1
ob.AutoButtonColor = false
ob.Parent = list
ob.MouseButton1Click:Connect(function()
current = opt
btn.Text = tostring(text) .. ": " .. tostring(opt)
open = false
list.Size = UDim2.new(1, 0, 0, 0)
if cb then pcall(cb, opt) end
end)
end
end
refreshOpts()
btn.MouseButton1Click:Connect(function()
open = not open
list.Size = open and UDim2.new(1, 0, 0, 26 * #(options or {})) or UDim2.new(1, 0, 0, 0)
end)
return btn
end
local originalAddTab = win.AddTab
function win.AddTab(name)
local tab = originalAddTab(name)
return setmetatable({ Tab = tab, Holder = tab.Holder, Button = tab.Button }, {
__index = function(_, k)
if TabAPI[k] then return function(_, ...) return TabAPI[k](tab, ...) end end
end
})
end
return win
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
local Win = Menu.CreateWindow({ Title = "CheatMenu v1.0.0", Key = Enum.KeyCode.G })
local PageAFK = Win.AddTab("挂机")
PageAFK:AddSection("挂机防踢")
PageAFK:AddToggle("挂机防踢 (AntiAFK)", "AntiAFK", true, function(on)
if on then AntiAFKEnable() end
end)
PageAFK:AddToggle("本地防踢 (KickGuard)", "KickGuard", false, function(on)
if on then KickGuardEnable() else KickGuardDisable() end
end)
PageAFK:AddToggle("前兆抢传 (KickRejoin)", "KickRejoin", false, function(on)
if on then KickRejoinEnable() end
end)
PageAFK:AddDivider()
PageAFK:AddSection("训练")
PageAFK:AddToggle("自动训练 (踢击力量)", "AutoTrain", false, function(on)
if on then AutoTrainEnable() end
end)
PageAFK:AddToggle("自动领取训练加成", "AutoBonus", false, function(on)
if on then AutoBonusEnable() end
end)
PageAFK:AddSlider("训练循环间隔(秒)", 1, 30, 0.5, function() return C.AutoTrainSec or 5 end, function(v) C.AutoTrainSec = v end, "%.1f")
PageAFK:AddDivider()
PageAFK:AddSection("健身房")
PageAFK:AddToggle("自动锻炼 (AutoGym)", "AutoGym", false, function(on)
if on then AutoGymEnable() end
end)
PageAFK:AddDivider()
PageAFK:AddSection("基地操作")
PageAFK:AddToggle("自动售卖 CPS (每轮)", "AutoSell", false, function(on)
if on then sellLowCPSTools() end
end)
PageAFK:AddSlider("CPS 售卖门槛", 1000, 1000000, 1000, function() return C.SellMinCPS or 100000 end, function(v) C.SellMinCPS = v end, "%.0f")
PageAFK:AddButton("一键收起脑红", function() withdrawAllBrainrots() end)
PageAFK:AddButton("一键收起货币", function() collectAllCash() end)
PageAFK:AddDivider()
PageAFK:AddSection("翻译")
PageAFK:AddToggle("界面翻译", "Translate", false)
PageAFK:AddButton("翻译测试 (Hello World)", function()
local r = Trans.Translate("Collect all eggs")
print("[CheatMenu] 翻译测试: " .. tostring(r))
Notify("翻译: " .. tostring(r))
end)
local PageAC = Win.AddTab("反作弊")
PageAC:AddSection("反作弊")
PageAC:AddToggle("namecall 拦截 (防踢)", "NamecallHook", false, function(on)
if on then AC.InstallNamecallHook() end
end)
PageAC:AddToggle("防甩飞 (AntiFling)", "AntiFling", false, function(on)
if on then AntiFlingEnable() else AntiFlingDisable() end
end)
PageAC:AddButton("保存配置", function() SaveConfig() Notify("已保存配置") end)
T.AntiAFK = true
AntiAFKEnable()
print("[CheatMenu] ✅ 加载完成 v1.0.0 (呼出键 G)")
