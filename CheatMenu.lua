print(('[CheatMenu] build 2026-09-20 20:28 sha a377461a bytes 487780'):format('2026-09-20 20:28','a377461a',487780))
print("[CheatMenu] ===== v68 加载开始 =====")
local GENV
do local ok,e=pcall(getgenv) GENV=(ok and type(e)=="table") and e or _G end
do local _u=GENV.RblxSessionB or GENV["Cheat".."Unload"]
if (GENV.RblxSessionA or GENV["Cheat".."Loaded"]) and type(_u)=="function" then pcall(_u) end end
pcall(function()
local lp=game:GetService("Players").LocalPlayer
local roots={lp and lp.PlayerGui, game:GetService("CoreGui")}
if gethui then local h=gethui() if h then roots[#roots+1]=h end end
for i=1,#roots do
local r=roots[i]
if r then
for _,c in ipairs(r:GetChildren()) do
if c.Name=="CheatMenuV52" then c:Destroy() end
end
end
end
end)
local _UIS_EARLY=(game and game.GetService) and game:GetService("UserInputService") or nil
local _TOUCH=false
pcall(function()
if _UIS_EARLY then
_TOUCH=(_UIS_EARLY.TouchEnabled==true) and (_UIS_EARLY.MouseEnabled~=true or _UIS_EARLY.KeyboardEnabled~=true)
end
end)
local SYS={
Conns={},Threads={},Unloaded=false,
T_={
Fly=false,Noclip=false,Speed=false,InfiniteJump=false,JumpBoost=false,
GodMode=false,NoFall=false,DeepHide=false,
LocalPhrase=true,FullBright=false,PerfBoost=false,TPEnabled=false,NoCollide=false,
ESP=false,ESPNameTag=false,ESPItem=false,ESPWeapon=false,ESP_NPC=false,ESP_Pick=false,ESP_Door=false,ESP_Mini=false,BlockHandlers=false,QuickInteract=false,AutoHide=false,AutoDodge=false,AutoHitMinigame=false,FootstepESP=false,MenuMouse=true,FreeCam=false,Tracer=false,
TracerAll=false,
AntiAFK=true,AutoBonus=false,
AutoRebirth=false,AutoGym=false,AutoTrain=false,
TransChat=false,TransUI=false,
AutoSell=false,SellThresholdEnabled=false,
CB_Aim=false,CB_Silent=false,CB_Fire=false,
CB_PauseMove=false,CB_Predict=false,CB_Team=false,CB_Wall=true,
CB_Ballistic=false,
CB_TgtStrict=false,
CB_SnapFire=false,
CB_OnlyAlive=true,
CB_SkipFF=true,
CB_Melee=false,
TrapImmune=false,
LockSpeed=false,LockJump=false,LockGravity=false,
PathKey=false,
AutoUpdateCheck=true,
BootUpdateCheck=true,
FX_Enable=false,
NightVision=false,NightVisionPro=false,Lantern=false,SuperLight=false,
NoFog=false,NoShadow=false,
WPShow=false,WPKey=false,
NoDeath=false,NoKnock=false,
CB_MissMode=false,
CB_SilentAim=false,CB_BulletWall=false,CB_BlockRay=false,
CB_360=false,CB_SilentNoTurn=false,
NoAggro=false,
TransBilingual=false,
TransDyn=true,
TransSili=false,
AutoLowPing=false,
Prot_AntiAC=false,Prot_AntiAdmin=false,Prot_AntiTP=false,Prot_HideGui=false,
Prot_SpeedCap=false,
AntiFling=false,
PC_LoopTP=false,PC_OnHead=false,PC_Orbit=false,PC_Stare=false,PC_Follow=false,
PC_Freeze=false,
PG_Spin=false,PG_SpinHit=false,PG_FlyHit=false,
PG_WalkHit=false,PG_HideHit=false,PG_OrbitTool=false,PG_BlackHole=false,
PG_KillNear=false,
},
C_={
FlySpeed=3,FlyMode="BodyVelocity",
SpeedMult=2,TPMethod="CFrame",SpeedMode="Linear",
JumpMult=2,
SpeedCap=28,
Gravity=196.2,
MouseTPMode="Raycast",AutoTPDist=5,TPMaxStep=300,
FreeCamSpeed=60,FreeCamSens=0.3,PerfCull=300,
TracerMaxDist=500,TracerMaxN=12,
ESPNameH=0,
PickDist=1200,
QuickRange=60,
AutoHideDist=40,
DeepHideDepth=120,
DeepHideMode="down",DeepHideOffX=0,DeepHideOffZ=0,
ForceCam="off",
AutoTrainSec=5,RebirthCheck=3,
SellMinCPS=100000,
CB_AimPart=2,CB_Smooth=0.28,CB_Fov=200,CB_MaxDist=1200,CB_MeleeDist=9,CB_MeleeGap=0.35,
CB_ScanMs=33,
CB_FireDelay=0.08,CB_HpThr=0,CB_PrioMode=1,
CB_TargetMode=1,CB_TargetName="",CB_RingMode=1,CB_PredictTime=0.14,
CB_ProjSpeed=100,CB_ProjGrav=196.2,
CB_RingModeVer=0,
CB_SnapDelay=0.03,
CB_SnapMinGap=0.08,CB_SnapMaxAngle=360,
Key_Menu="G",Key_CycleTarget="V",Key_Teleport="T",
FX_Sat=0,FX_Bri=0,FX_Con=0,FX_CB="关闭",
UIScaleManual=0,
MenuPosX=0.5,MenuPosY=0.5,MenuPosSaved=false,
AudioMaster=100,AudioThr=15,
CB_HitRate=100,CB_MissRate=0,
PC_Sel="",PC_Speed=120,PC_Range=8,PC_SpinSpeed=3,
PG_SpinSpeed=8,PG_OrbitRange=8,PG_OrbitSpeed=60,PG_OrbitMode=1,
PG_BH_Range=40,PG_BH_Height=30,PG_BH_Speed=6,PG_BH_Pull=120,
PG_KillDist=13,PG_Target="",
},
SavedPos={},Loops={},BtnRefs={},SwitchOnChange={},Pages={},
ScreenGui=nil,MenuOpen=false,FreeCamActive=false,MenuPrevMouseBehav=nil,MenuPrevMouseIcon=nil,
FCPrevBehav=nil,FCPrevIcon=nil,
}
SYS.BuildVer="8.1.0"
SYS.BuildURL="https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua"
SYS.BuildVerURL="https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/version.txt"
SYS.FallbackRepo="https://raw.githubusercontent.com/Mercershixin/CheatMenu/main/CheatMenu.lua"
local function _rands(n)
local hex="0123456789abcdef" local t={}
for i=1,n do local k=math.random(1,16) t[i]=hex:sub(k,k) end
return table.concat(t)
end
SYS.N={
Gui    = ({"App","MainGui","Interface","CorePack","UiRoot","HudRoot","PanelRoot"})[math.random(1,7)],
Float  = "FloatingButton",
Hud    = ({"HudRoot","Interface","UiRoot"})[math.random(1,3)],
F3     = "Stats",
Combat = "Render",
CAS    = "CoreAction_".._rands(4),
FX     = "ColorCorrectionEffect",
Lantern= "Light",
WP     = "Part",
Cfg    = "cfg.dat",
Diag   = "dbg.txt",
Cache  = "tr.dat",
OldCfg = "CheatMenuV491_Config.json",
OldCache="TransCache.json",
OldDiag="CheatMenu_Diag.txt",
}
SYS.GK={ loaded="RblxSessionA", unload="RblxSessionB", boot="RblxSessionC", note="RblxSessionD" }
local function _gv(...)
for i=1,select("#",...) do
local k=select(i,...)
if k and GENV[k]~=nil then return GENV[k] end
end
return nil
end
SYS.GV=_gv
GENV.__SYS=SYS
local Players,RS,UIS,WS,CAS,LT,Stats,TweenService,VIM,VirtualUser,RStorage,CS,HS
do
local function G(n) local ok,s=pcall(function() return game:GetService(n) end) return ok and s or nil end
Players=G("Players") RS=G("RunService") UIS=G("UserInputService") WS=G("Workspace")
CAS=G("ContextActionService") LT=G("Lighting") Stats=G("Stats")
TweenService=G("TweenService") VIM=G("VirtualInputManager") VirtualUser=G("VirtualUser")
RStorage=G("ReplicatedStorage") CS=G("CollectionService") HS=G("HttpService")
end
SYS.Players=Players SYS.RS=RS SYS.UIS=UIS SYS.WS=WS SYS.CAS=CAS SYS.LT=LT
SYS.Stats=Stats SYS.TweenService=TweenService SYS.VIM=VIM SYS.VirtualUser=VirtualUser
SYS.RStorage=RStorage SYS.CS=CS SYS.HS=HS
if not Players or not RS or not UIS or not WS then warn("[CheatMenu] ❌ 关键服务缺失"); return end
local LP=Players.LocalPlayer
local PG=LP and LP:WaitForChild("PlayerGui",15)
if not LP or not PG then warn("[CheatMenu] ❌ 角色服务缺失"); return end
SYS.LP=LP SYS.PG=PG SYS.Cam=WS.CurrentCamera
local CoreGui=nil pcall(function() CoreGui=game:GetService("CoreGui") end)
SYS.CoreGui=CoreGui
SYS.Orig={
WalkSpeed=16,Gravity=WS.Gravity,
MouseBehav=UIS.MouseBehavior,MouseIcon=UIS.MouseIconEnabled,
Brightness=LT and LT.Brightness or 1,ClockTime=LT and LT.ClockTime or 14,
Ambient=LT and LT.Ambient or Color3.new(0.5,0.5,0.5),
OutdoorAmbient=LT and LT.OutdoorAmbient or Color3.new(0.5,0.5,0.5),
FogEnd=LT and LT.FogEnd or 1000,FogColor=LT and LT.FogColor or Color3.new(0.5,0.5,0.5),
}
do
local function T_(c) if c and type(c.Disconnect)=="function" then SYS.Conns[#SYS.Conns+1]=c end return c end
local function TT_(co) if co then SYS.Threads[#SYS.Threads+1]=co end return co end
local function P_(f,...) if type(f)~="function" then return false end return pcall(f,...) end
local function DS_(c)
if not c then return end
pcall(function()
if type(c)=="thread" then task.cancel(c)
elseif type(c.Disconnect)=="function" then c:Disconnect()
elseif type(c.Destroy)=="function" then c:Destroy() end
end)
end
SYS.T=T_ SYS.TT=TT_ SYS.P=P_ SYS.DisconnectSafe=DS_
SYS.PhysicsStep=RS.PreSimulation or RS.Heartbeat
T_(WS:GetPropertyChangedSignal("CurrentCamera"):Connect(function() SYS.Cam=WS.CurrentCamera end))
end
local T=SYS.T local TT=SYS.TT local P=SYS.P local DS=SYS.DisconnectSafe
function SYS.KeyCodeOf(name)
if type(name)~="string" or name=="" then return nil end
local ok,k=pcall(function() return Enum.KeyCode[name] end)
if ok and k~=nil and typeof(k)=="EnumItem" then return k end
return nil
end
do
local CFG=SYS.N.Cfg
local CFG_LEGACY=SYS.N.OldCfg
local HAS_FS=(type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function")
SYS.HAS_FS=HAS_FS
SYS.has_fs_txt=HAS_FS and ("持久化启用 · "..CFG) or "执行器不支持 writefile"
function SYS.SaveConfig()
if not HAS_FS or not HS then return end
P(function()
local data={T_={},C_={}}
local withT = SYS._updating == true
if withT then
for k,v in pairs(SYS.T_) do
if type(v)=="boolean" then data.T_[k]=v end
end
data._resumeT = true
end
for k,v in pairs(SYS.C_) do
if k~="CB_TargetName" and k~="CB_TargetMode" then
local tv=type(v)
if tv=="number" or tv=="string" or tv=="boolean" then data.C_[k]=v end
end
end
local json=HS:JSONEncode(data)
if type(json)~="string" then return end
if type(renamefile)=="function" then
writefile(CFG..".tmp",json)
pcall(function() renamefile(CFG..".tmp",CFG) end)
else
if isfile(CFG) then
pcall(function() writefile(CFG..".bak", readfile(CFG)) end)
end
writefile(CFG,json)
end
end)
end
SYS.REMOVED_FEATURES = { TrapWatch=true, AutoUse=true,
AutoClaim=true, AutoPickup=true, AutoRespawn=true, AutoShop=true, AutoTeam=true, AutoEmote=true }
function SYS.LoadConfig()
if not HAS_FS or not HS then return end
P(function()
if not isfile(CFG) then return end
local function apply(raw)
local data=HS:JSONDecode(raw)
if type(data)~="table" then return false end
if _TOUCH then
if SYS.T_.PerfBoost==false then SYS.T_.PerfBoost=true end
if SYS.T_.AntiAFK==false then SYS.T_.AntiAFK=true end
end
if data._resumeT == true and type(data.T_) == "table" then
local n = 0
for k, v in pairs(data.T_) do
if SYS.T_[k] ~= nil and type(v) == "boolean" and not (SYS.REMOVED_FEATURES and SYS.REMOVED_FEATURES[k]) then
SYS.T_[k] = v
n = n + 1
end
end
SYS._resumedFromUpdate = true
task.delay(0.6, function()
for _, f in ipairs(SYS.BtnRefs or {}) do P(f) end
SYS.Notify(("♻ 热更新完成, 已自动恢复 %d 个开关状态"):format(n), SYS.CY.green)
P(SYS.SaveConfig)
end)
end
for k,v in pairs(data.C_ or {}) do if SYS.C_[k]~=nil and type(v)==type(SYS.C_[k]) then SYS.C_[k]=v end end
SYS.C_.CB_TargetName="" SYS.C_.CB_TargetMode=1
if SYS.C_.CB_RingModeVer~=2 then
SYS.C_.CB_RingMode=1
SYS.C_.CB_RingModeVer=2
end
return true
end
local ok1=pcall(function()
if not apply(readfile(CFG)) then error("配置不可用") end
end)
if not ok1 then
local ok2=pcall(function()
if isfile(CFG..".bak") and apply(readfile(CFG..".bak")) then return end
error("无备份")
end)
if not ok2 then print("[CheatMenu] ⚠️ 配置文件损坏且无备份, 使用默认配置") end
end
end)
end
SYS.LoadConfig()
local pending=false
function SYS.QueueSave()
if not HAS_FS or pending then return end
pending=true
task.delay(1.0,function() pending=false SYS.SaveConfig() end)
end
function SYS.SetLoop(k,on,sig,fn)
if not sig then return end
if on and not SYS.Loops[k] then SYS.Loops[k]=T(sig:Connect(fn))
elseif not on and SYS.Loops[k] then SYS.Loops[k]:Disconnect() SYS.Loops[k]=nil end
end
function SYS.SpawnLoop(fn)
local co=task.spawn(function()
local ok,err=pcall(fn)
if not ok then warn("[CheatMenu] loop:",tostring(err)) end
end)
return SYS.TT(co)
end
end
local QueueSave=SYS.QueueSave
function SYS.BootUpdateCheck()
if GENV[SYS.GK.boot] then return false end
GENV[SYS.GK.boot]=true
if SYS.T_.BootUpdateCheck==false then return false end
if type(game.HttpGet)~="function" then return false end
local base=tostring(SYS.BuildURL or "")
if base=="" or base:find("{{",1,true) then base=tostring(SYS.FallbackRepo or "") end
local user,repo,branch=base:match("^https://raw%.githubusercontent%.com/([^/]+)/([^/]+)/([^/]+)")
local VER,SRC
if user then
local ts=tostring(os.time() or 0)
local function bust(u)
return u..(u:find("?",1,true) and "&" or "?").."t="..ts
end
VER={
bust(("https://raw.githubusercontent.com/%s/%s/%s/version.txt"):format(user,repo,branch)),
bust(("https://ghproxy.net/https://raw.githubusercontent.com/%s/%s/%s/version.txt"):format(user,repo,branch)),
bust(("https://ghfast.top/https://raw.githubusercontent.com/%s/%s/%s/version.txt"):format(user,repo,branch)),
bust(("https://cdn.jsdelivr.net/gh/%s/%s@%s/version.txt"):format(user,repo,branch)),
}
SRC={
bust(("https://raw.githubusercontent.com/%s/%s/%s/CheatMenu.lua"):format(user,repo,branch)),
bust(("https://ghproxy.net/https://raw.githubusercontent.com/%s/%s/%s/CheatMenu.lua"):format(user,repo,branch)),
bust(("https://ghfast.top/https://raw.githubusercontent.com/%s/%s/%s/CheatMenu.lua"):format(user,repo,branch)),
bust(("https://cdn.jsdelivr.net/gh/%s/%s@%s/CheatMenu.lua"):format(user,repo,branch)),
}
else
VER={tostring(SYS.BuildVerURL or "")} SRC={base}
end
local function isVer(v)
return v:match("^%d+%.%d+$")~=nil or v:match("^%d+%.%d+%.%d+$")~=nil
end
local rv=""
for i=1,#VER do
local u=VER[i]
if u~="" and not u:find("{{",1,true) then
local ok,body=pcall(game.HttpGet,game,u)
if ok and type(body)=="string" then
local flat=body:gsub("%s","")
local v=flat:sub(1,16)
if isVer(v) then rv=v break end
end
end
end
if rv=="" then return false end
local mine=tostring(SYS.BuildVer or ""):gsub("%s","")
if rv==mine then return false end
local function score(v)
local a,b,c=v:match("^(%d+)%.(%d+)%.(%d+)$")
if a then return tonumber(a)*1000000+tonumber(b)*1000+tonumber(c) end
local a2,b2=v:match("^(%d+)%.(%d+)$")
if a2 then return tonumber(a2)*1000000+tonumber(b2)*1000 end
return nil
end
local rn,mn=score(rv),score(mine)
if not rn or not mn then return false end
if rn<=mn then return false end
print(("[CheatMenu] 加载时更新检查: 发现新脚本 %s -> %s, 改用新版启动"):format(mine,rv))
local function get(urls,minlen)
for i=1,#urls do
local u=urls[i]
if u~="" and not u:find("{{",1,true) then
local ok,body=pcall(game.HttpGet,game,u)
if ok and type(body)=="string" and #body>=minlen and not body:find("404: Not Found",1,true) then return body end
end
end
return nil
end
local src=get(SRC,1000)
if type(src)~="string" then print("[CheatMenu] ⚠️ 新版源码没拉到, 继续用当前版本") return false end
local chunk,cerr=(loadstring or load)(src,"@CheatMenu_boot")
if type(chunk)~="function" then print("[CheatMenu] ⚠️ 新版编译不过: "..tostring(cerr)) return false end
GENV[SYS.GK.note]=("🆕 已更新 %s → %s"):format(mine,rv)
local ok,err=pcall(chunk)
if not ok then
GENV[SYS.GK.note]=nil
print("[CheatMenu] ⚠️ 新版启动失败, 回到当前版本: "..tostring(err))
return false
end
P(function()
if type(writefile)~="function" or type(readfile)~="function" or type(isfile)~="function" then return end
local name="CheatMenu.lua"
local ws=nil
if type(getworkspace)=="function" then
local kok,p=pcall(getworkspace)
if kok and type(p)=="string" and p~="" then ws=(p:gsub("[/\\]+$","")) end
end
local path=(ws and (ws.."/"..name)) or name
if not isfile(path) then return end
local old=readfile(path)
if type(old)=="string" and #old>1000 then writefile(path..".bak",old) end
writefile(path,src)
print("[CheatMenu] 已把新版写回本机: "..path)
end)
return true
end
do
local _,booted=P(SYS.BootUpdateCheck)
if booted then return end
end
do
local cChar,cHum,cRoot=nil,nil,nil
local charConns={}
local function Bind(c)
for _,x in ipairs(charConns) do x:Disconnect() end
charConns={}
cChar=c cHum=c:FindFirstChildOfClass("Humanoid") cRoot=c:FindFirstChild("HumanoidRootPart")
table.insert(charConns,c.ChildAdded:Connect(function(ch)
if ch:IsA("Humanoid") then cHum=ch end
if ch.Name=="HumanoidRootPart" then cRoot=ch end
end))
table.insert(charConns,c.ChildRemoved:Connect(function(ch)
if ch==cHum then cHum=nil end
if ch==cRoot then cRoot=nil end
end))
end
function SYS.GC()
if cChar and cChar.Parent then
if not cHum or not cHum.Parent then cHum=cChar:FindFirstChildOfClass("Humanoid") end
if not cRoot or not cRoot.Parent then cRoot=cChar:FindFirstChild("HumanoidRootPart") end
return cChar,cHum,cRoot
end
local c=LP.Character if c then Bind(c) end
return cChar,cHum,cRoot
end
T(LP.CharacterAdded:Connect(Bind))
T(LP.CharacterRemoving:Connect(function()
for _,x in ipairs(charConns) do x:Disconnect() end
charConns={} cChar,cHum,cRoot=nil,nil,nil
end))
if LP.Character then Bind(LP.Character) end
function SYS.ResetCam()
local _,hum,root=SYS.GC()
if hum and root and SYS.Cam then
SYS.Cam.CameraType=Enum.CameraType.Custom
SYS.Cam.CameraSubject=hum
local p=root.Position+Vector3.new(0,1.5,0)
SYS.Cam.CFrame=CFrame.new(p+root.CFrame.LookVector*-8,p)
elseif SYS.Cam then
SYS.Cam.CameraSubject=nil
SYS.Cam.CFrame=CFrame.new(Vector3.new(0,10,0),Vector3.zero)
end
end
local ForceCamOrig=nil
local ForceCamConn=nil
function SYS.SetForceCam(mode)
mode=mode or SYS.C_.ForceCam or "off"
if not ForceCamOrig then
local cm,zd=nil,nil
pcall(function() cm=LP.CameraMode end)
pcall(function() zd=LP.CameraMaxZoomDistance end)
ForceCamOrig={mode=cm,zoom=zd}
end
if ForceCamConn then DS(ForceCamConn) ForceCamConn=nil end
if mode=="off" then
if ForceCamOrig then
pcall(function()
if ForceCamOrig.mode then LP.CameraMode=ForceCamOrig.mode end
if ForceCamOrig.zoom then LP.CameraMaxZoomDistance=ForceCamOrig.zoom end
end)
end
ForceCamOrig=nil
return
end
if mode=="first" then
pcall(function() LP.CameraMode=Enum.CameraMode.LockFirstPerson end)
elseif mode=="third" then
pcall(function()
LP.CameraMode=Enum.CameraMode.Classic
LP.CameraMaxZoomDistance=math.max(LP.CameraMaxZoomDistance or 12, tonumber(SYS.C_.CamZoom) or 20)
end)
end
ForceCamConn=SYS.TT(task.spawn(function()
while (SYS.C_.ForceCam~="off") and not SYS.Unloaded do
if SYS.C_.ForceCam=="first" then
pcall(function() LP.CameraMode=Enum.CameraMode.LockFirstPerson end)
elseif SYS.C_.ForceCam=="third" then
pcall(function()
LP.CameraMode=Enum.CameraMode.Classic
local _cz=tonumber(SYS.C_.CamZoom) or 20 if LP.CameraMaxZoomDistance<_cz then LP.CameraMaxZoomDistance=_cz end
end)
end
task.wait(0.5)
end
end))
SYS.CamOrig=SYS.CamOrig or {}
function SYS.SetCamFov(v)
local cam=SYS.Cam or WS.CurrentCamera
if not cam then return end
if SYS.CamOrig.fov==nil then P(function() SYS.CamOrig.fov=cam.FieldOfView end) end
local n=tonumber(v) or 70
P(function() cam.FieldOfView=n end)
end
function SYS.SetCamZoom(v)
if SYS.CamOrig.zoom==nil then P(function() SYS.CamOrig.zoom=LP.CameraMaxZoomDistance end) end
local n=tonumber(v) or 20
if n<1 then n=1 end
P(function() LP.CameraMaxZoomDistance=n end)
if SYS.C_.ForceCam=="third" and SYS.SetForceCam then P(SYS.SetForceCam,"third") end
end
function SYS.RestoreCamOpts()
P(function() if SYS.CamOrig.fov and (SYS.Cam or WS.CurrentCamera) then (SYS.Cam or WS.CurrentCamera).FieldOfView=SYS.CamOrig.fov end end)
P(function() if SYS.CamOrig.zoom then LP.CameraMaxZoomDistance=SYS.CamOrig.zoom end end)
end
end
local FreeCtrl=nil
function SYS.DisablePlayerControls()
if FreeCtrl then P(function() FreeCtrl:Disable() end) return true end
local ps=LP:FindFirstChild("PlayerScripts")
local pm=ps and ps:FindFirstChild("PlayerModule")
if not pm or not pm:IsA("ModuleScript") then return false end
local ok,m=pcall(require,pm)
if not ok or not m then return false end
local ok2,c=pcall(function() return m:GetControls() end)
if not ok2 or not c then return false end
local df,ef
pcall(function() df=c.Disable ef=c.Enable end)
if type(df)~="function" or type(ef)~="function" then return false end
FreeCtrl=c
P(function() c:Disable() end)
return true
end
function SYS.EnablePlayerControls()
if FreeCtrl then P(function() FreeCtrl:Enable() end) FreeCtrl=nil end
end
end
local GC=SYS.GC
do
local NetRoot=nil
task.spawn(function()
if not RStorage then return end
pcall(function()
local shared=RStorage:WaitForChild("Shared",15)
if shared then
local pk=shared:WaitForChild("Packages",15)
if pk then NetRoot=pk:WaitForChild("Network",15) end
end
end)
end)
local RRemoteCache={}
local function findRemote(n,wantCls)
if typeof(n)=="Instance" and n:IsA(wantCls) then return n end
if type(n)~="string" or n=="" then return nil end
local ck=wantCls.."|"..n
local hit=RRemoteCache[ck] if hit and hit.Parent then return hit end
if not RStorage then return nil end
local function ok2(inst) return inst and inst:IsA(wantCls) and inst or nil end
local rel=RStorage:FindFirstChild("Remote")
if rel then
local seg={}
for s in tostring(n):gmatch("[^%.]+") do seg[#seg+1]=s end
local cur=rel
for i=1,#seg do
local nx=cur and cur:FindFirstChild(seg[i])
if i<#seg then cur=nx else
local r2=ok2(nx)
if r2 then RRemoteCache[ck]=r2 return r2 end
end
end
local function dig(root,d)
if d>3 then return nil end
for _,c in ipairs(root:GetChildren()) do
if c.Name==n then local r3=ok2(c) if r3 then return r3 end end
if c:IsA("Folder") or c:IsA("Configuration") then
local r4=dig(c,d+1) if r4 then return r4 end
end
end
return nil
end
local r5=dig(rel,1)
if r5 then RRemoteCache[ck]=r5 return r5 end
end
if not NetRoot then
pcall(function()
local sh=RStorage:FindFirstChild("Shared")
local pk=sh and sh:FindFirstChild("Packages")
NetRoot=pk and pk:FindFirstChild("Network")
end)
end
if NetRoot then
local pre=(wantCls=="RemoteEvent") and "rev_" or "ref_"
local r6=ok2(NetRoot:FindFirstChild(pre..n))
if r6 then RRemoteCache[ck]=r6 return r6 end
local r7=ok2(NetRoot:FindFirstChild(pre..tostring(n):gsub("%.","_")))
if r7 then RRemoteCache[ck]=r7 return r7 end
end
return nil
end
function SYS.REvent(n) return findRemote(n,"RemoteEvent") end
function SYS.RFunction(n) return findRemote(n,"RemoteFunction") end
function SYS.Invoke(n,...)
local r=SYS.RFunction(n) if not r then return false,nil end
local a=table.pack(...)
local ok,res=P(function() return r:InvokeServer(table.unpack(a,1,a.n)) end)
return ok,res
end
function SYS.REventU(n) return findRemote(n,"UnreliableRemoteEvent") end
function SYS.Fire(n,...)
local r=SYS.REvent(n) if not r then return false end
local a=table.pack(...)
return P(function() r:FireServer(table.unpack(a,1,a.n)) end)
end
function SYS.OnRemote(n,cb)
local r=SYS.REvent(n) if not r then return end
T(r.OnClientEvent:Connect(cb))
end
end
SYS.RemoteAlias = {
heal    = {"EntityService.Heal","Heal","RequestHeal","HealSelf","SelfHeal","HealPlayer",
"Regen","Regenerate","RestoreHealth","RequestHealSelf"},
revive  = {"GameService.Revive","Revive","RequestRevive","ReviveSelf","RevivePlayer","Resurrect","Resurrection",
"Any.Suicide","GameService.Revive",
"ReviveFriend","ObtainGiftedRevive","CheckRevive","ReviveRift"},
respawn = {"GameService.Respawn","Respawn","RequestRespawn","CharacterReset","Reset","RespawnSelf",
"PlayerRespawn","RequestCharacterReset","GameService.Respawn","GameService.Join","GameService.JoinLater",
"PlayAgain","ContinueOrSave"},
kill    = {"GameService.Killed","Killed","Kill","Damage","CombatEvent","Died"},
damage  = {"Damage","Hit","Damaged","TakeDamage","ApplyDamage","DamageEvent","BeDamaged"},
buy     = {"BuyProduct","Buy","Purchase","BuyItem","RequestBuy","BuyGamepass","BoxBuy","ItemBuyEvent"},
claim   = {"ClaimReward","Claim","ClaimDaily","ClaimBonus","ClaimRewardEvent","CollectReward",
"ClaimWeeklyCase","ClaimPremiumReward","ClaimRebirthReward","ClaimRebirth3Reward",
"ClaimSeasonWeapon","ClaimTradeTokenReward","ClaimLimitedBundleReward","ClaimStall",
"Days7Claim","Days4RecurClaim","NewBieClaim","OnlineRewardClaim","TryGroupReward",
"CollectrionClaim","CodeInviteClaim","RebackRewardInvok","RebackReward",
"QuestService.ClaimReward","Challenge.Claim","RankedService.ClaimReward","MailboxService.Claim"},
sell    = {"Sell","SellItem","RequestSell","SellProduct","AutoSell",
"WeaponService.Sell","PlayerMarketService.Purchase","PlayerMarketService.AddListing",
"PlayerMarketService.SetPrice","PlayerMarketService.RemoveListing","PlayerMarketService.LoadListed",
"AuctionService.Bid","PlayerMarketService.Query"},
pickup  = {"Pickup","Collect","PickupItem","Loot","PickItem","Grab","CollectItem","DropCoin",
"HidePickup","DropItem","PaperPlanePickup","RequestItemInfo"},
trade   = {"Trade","RequestTrade","TradeRequest","TradeOffer","CashTrade",
"Trade.Request","Trade.Ready","Trade.Select","Trade.SetConfirm","Trade.Toggle","Trade.Cancel",
"CashGun.Fire","CashGun.Pickup","TradeLobby.Teleport"},
chat    = {"Chat","SayMessage","SendMessage","Message","ChatMessage","PostieSent",
"SystemMessage","Caption","CaptionWithChat"},
round   = {"RoundStart","RoundEnd","GameStart","GameEnd","GameMode","RoundResult"},
teleport= {"Teleport","ServerTeleported","SwitchServers","SkipToRoomNumber","UpdateFloor",
"RequestTeleport","TeleportTo","JoinServer","TeleportToServer","CharacterService_TeleportCharacter",
"Any.Teleport","Any.Teleporter","Any.PlaceTeleport","Any.ServerTeleport","EntityService.Teleported",
"ReplicateService.Teleport","ClientTeleported","TradeLobby.Teleport"},
kick    = {"Kick","KickPlayer","Ban","PlayerKick"},
itemuse = {"TryUse","UseItem","Use","RequestUse","ConsumeItem","UseTool","UseAbility",
"ItemService.TryUse","Any.Track",
"UsePowerup","UseEnemyModule","UseEventModule"},
equip   = {"TryEquip","Equip","SetEquip","RequestGear","RequestEquip","EquipmentService",
"BackpackService.TryEquip","EquipmentService.SetEquip","CharmService.Equip","WeaponService.SetWeapon"},
unequip = {"TryUnequip","Unequip","UnEquip","CleanEquipped","BackpackService.TryUnequip",
"CharmService.UnEquip","EmoteService.CleanEquipped"},
orb     = {"OrbPickupRequest","OrbPickup","OrbPickupApproved","PickUpPrompt","WeaponPickup","PickUp"},
daily   = {"RequestDailyReward","OnlineRewardClaim","ClaimDaily","ClaimReward","DailyRewardReceived",
"ClaimSeasonWeapon","NewBieClaim","ClaimStall","CollectrionClaim","ClaimLimitedBundleReward",
"ClaimRebirthReward","ClaimTradeTokenReward","RouletteClaimConfirm","CodeInviteClaim"},
craft   = {"CraftItems","CraftEvent","WeaponCraft","Craft"},
stall   = {"ClaimStall","PlayerStall","SetStallName","StallSkinConfig"},
loot    = {"LootEventCapture","LootEventSettled","DropCoin","DropFlag"},
shop    = {"OpenShop","RandomShopService","CustomShopService","ShopService","BuyProduct",
"BuyGamepass","BuyEventItem","PurchasePromptEnded","VerifyGamePass",
"ShopService.Purchase","ShopService.Gift","Shop.Purchase","Any.Purchase",
"RandomShopService.Purchase","RandomShopService.Refresh","RandomShopService.Gift",
"CustomShopService.Purchase","CustomShopService.Select","Beginner.OpenShop"},
box     = {"RouletteEvent","RouletteAnnounce","PrototypeCase_AX50","SecretCase_v2",
"RouletteClaimConfirm","ReplicaSet","SecretCase",
"Spin.Spin","GachaService.Gacha","GachaService.InvokeServer","Any.GachaResult",
"RaffleService.Join","Any.Raffle","Any.SecretLuck"},
mail    = {"MailboxService","RemoveMail","CommandItemsReceived","FriendRewardReceivedBox",
"MailboxService.Claim","MailboxService.MarkRead","MailboxService.RemoveMail"},
friend  = {"RequestFriendReward","FriendRewardReceived","SocialRewardsClaim","SocialRewardsChest",
"FriendTokensReceived","SocialRewardsCheck","InviteNotify","AllowInvite"},
milestone= {"RequestMilestoneReward","MilestoneRewardReceived","OnlineRewardUpdateData",
"BattlepassService.Claim","BattlepassService.ClaimPremiumRebirth","MinipassService.Claim","QuestService.ClaimReward","Challenge.Claim","RankedService.ClaimReward",
"BattlepassService","MinipassService","SeasonChanged","RankedService"},
server  = {"ServerList","ServerListService","GetServerData","UpdateServerData","JoinAny",
"JoinLater","TeleportToServer","TeleportToJobId","PlaceTeleport",
"ServerListService.Join","ServerListService.JoinAny","ServerListService.Cancel"},
team    = {"PickGameTeam","SelectRole","SelectRoleRequest","SelectLoadout","TeamService",
"TeamService.Invite","TeamService.Accept","TeamService.Kick","TeamService.Leave",
"GameService.SelectRole","GameService.SelectRoleRequest"},
inventory= {"Inventory","RequestInventory","RequestItemInfo",
"RequestInventoryView","InventoryViewResponse","InventoryQueryService",
"InventoryQueryService.Query","WeaponService.GetGlobalCounts","WeaponService.GetTradeCounts","CareerStatsService.Request",
"RequestItems","SetBackpack","BackpackService"},
emote   = {"PlayEmote","StopEmote","GlobalEmote","RequestEmote","EmoteService"},
deathfx = {"DeathEffects_ClearAll","DeathEffects_ClearPersisting","EntityService.Died","TouchDead",
"PlayerDied","Jumpscare","SpiderJumpscare","HideMonster"},
combat  = {"CombatService.Action","CombatService.ActionEvent","CombatService.SetWeapon","CombatService.Ammo",
"CombatService.SwitchSlot","WeaponService.SetSkin","WeaponService.SetWrap","WeaponService.SetFavorite",
"WeaponService.ReName","WeaponService.ResetName","ShootingRangeDummy"},
doors   = {"HitDoor","Interaction_Door","ClientOpen","DoorOpen","DoorClose","ManualOpen","DoorFunc"},
doorshop= {"PreRunShop","RequestShop","PurchaseShopItem","InventoryShopFunc","ShopCode","GiftProduct","ProductPurchased"},
move    = {"EntityService.WalkSpeed","EntityService.Jump","EntityService.SetState","EntityService.SetInAir",
"EntityService.PitchYaw","Any.AirJump","Any.JumpPad","ClientReplicateCFrame","ServerReplicateCFrame"},
}
SYS.RemoteKeywords = {
heal    = {"heal","regen","restorehealth","restore"},
revive  = {"revive","resurrect"},
respawn = {"respawn","characterreset"},
kill    = {"killed","kill","death","died","playerdied","jumpscare"},
damage  = {"damage","hit"},
buy     = {"buy","purchase"},
claim   = {"claim","reward"},
sell    = {"sell"},
pickup  = {"pickup","collect","loot","hidepickup","dropitem"},
trade   = {"trade"},
chat    = {"chat","message","say","systemmessage","caption"},
round   = {"roundstart","roundend","gamestart","gameend","elevator"},
teleport= {"teleport","joinserver"},
kick    = {"kick","ban"},
itemuse = {"tryuse","useitem","usepowerup","useenemy","useevent"},
equip   = {"tryequip","equip","requestgear"},
unequip = {"tryunequip","unequip"},
orb     = {"orbpickup","pickupprompt","weaponpickup"},
daily   = {"dailyreward","onlinereward","claimseason","newbieclaim","claimstall","rouletteclaim"},
craft   = {"craftitems","craftevent","weaponcraft"},
stall   = {"claimstall","playerstall"},
loot    = {"lootevent","dropcoin"},
shop    = {"openshop","shopservice","buyservice"},
box     = {"roulette","secretcase","prototypecase"},
mail    = {"mailbox","removemail","commanditems"},
friend  = {"friendreward","socialrewards","friendtoken"},
milestone= {"milestone","onlinereward","battlepass","minipass"},
server  = {"serverlist","joinserver","teleporttoserver","switchservers","skiptoroom"},
team    = {"pickgameteam","selectrole","selectloadout"},
inventory= {"inventoryview","inventoryquery","requestitems","iteminfo","dropitem"},
emote   = {"playemote","globalemote","requestemote"},
deathfx = {"deatheffects"},
doors   = {"hitdoor","interaction_door","dooropen","doorfake","doornormal","currentrooms"},
doorshop= {"prerunshop","requestshop","purchaseshopitem","inventoryshop","shopcode","giftproduct"},
}
local function scanRemoteByKeywords(kws, wantCls)
if not RStorage then return nil end
local roots={}
local r1=RStorage:FindFirstChild("Remote")
if r1 then roots[#roots+1]=r1 end
roots[#roots+1]=RStorage
local found=nil
local function dig(root,d)
if found or d>6 then return end
local ok,cs=pcall(function() return root:GetChildren() end)
if not ok or not cs then return end
for _,c in ipairs(cs) do
if found then return end
local ln=string.lower(tostring(c.Name))
for _,k in ipairs(kws) do
if ln:find(k,1,true) then
local okc=pcall(function() return c:IsA(wantCls) end)
if okc and c:IsA(wantCls) then found=c return end
end
end
if c:IsA("Folder") or c:IsA("Configuration") or c:IsA("Model") then dig(c,d+1) end
end
end
for _,r in ipairs(roots) do
dig(r,1)
if found then break end
end
return found
end
function SYS.FindEvent(kind, wantCls)
wantCls = wantCls or "RemoteEvent"
local list = SYS.RemoteAlias[kind]
if list then
for _, n in ipairs(list) do
local r = SYS.REvent(n)
if r then return r, n, "alias" end
end
end
local kws = SYS.RemoteKeywords[kind]
if kws then
local f = scanRemoteByKeywords(kws, wantCls)
if f then return f, f.Name, "fuzzy" end
end
return nil
end
function SYS.ProbeEvent(kind)
local r,name,how = SYS.FindEvent(kind)
if r then
print(("[CheatMenu] 🔎 %s -> 命中 %s (%s)"):format(kind, tostring(name), tostring(how)))
else
print(("[CheatMenu] 🔎 %s -> 本游戏没有"):format(kind))
end
return r,name,how
end
local Fire=SYS.Fire local OnRemote=SYS.OnRemote
local function _fireEvent(kind, pl)
local tried = {}
local cands = {}
local list = SYS.RemoteAlias and SYS.RemoteAlias[kind]
if list then
for _, n in ipairs(list) do
local r = SYS.REvent(n)
if r then cands[#cands+1] = { r = r, name = n } end
end
end
if #cands == 0 then
local r, name, how = SYS.FindEvent(kind)
if r then cands[#cands+1] = { r = r, name = tostring(name) .. "[" .. tostring(how) .. "]" } end
end
if #cands == 0 then return false, nil, 0 end
local anyOk, lastName = false, nil
for _, c in ipairs(cands) do
if not tried[c.name] then
tried[c.name] = true
local ok = false
if pl then
ok = P(function() c.r:FireServer(pl) end)
if not ok then ok = P(function() c.r:FireServer(pl.Name) end) end
end
if not ok then ok = P(function() c.r:FireServer() end) end
if ok then anyOk = true end
lastName = c.name
end
end
return anyOk, lastName, #cands
end
function SYS.HealSelf(pl)
pl = pl or LP
local ok,name=_fireEvent("heal", pl)
SYS.Notify(ok and ("🩹 已发送回血请求 -> "..tostring(pl and pl.Name).."  ·  remote="..tostring(name))
or "回血失败: 本游戏没找到回血 remote（可按 F9 看 SYS.ProbeEvent(\"heal\") 的结果）",
ok and SYS.CY.green or SYS.CY.yellow)
return ok
end
function SYS.ReviveSelf(pl)
pl = pl or LP
local ok,name=_fireEvent("revive", pl)
if not ok then ok,name=_fireEvent("respawn", pl) end
SYS.Notify(ok and ("✨ 已发送复活请求 -> "..tostring(pl and pl.Name).."  ·  remote="..tostring(name))
or "复活失败: 本游戏没找到 Revive/Respawn",
ok and SYS.CY.green or SYS.CY.yellow)
return ok
end
function SYS.RespawnSelf(pl)
pl = pl or LP
local ok,name=_fireEvent("respawn", pl)
SYS.Notify(ok and ("♻ 已发送重生请求 -> "..tostring(pl and pl.Name).."  ·  remote="..tostring(name))
or "重生失败: 本游戏没找到 Respawn",
ok and SYS.CY.green or SYS.CY.yellow)
return ok
end
function SYS.HealSelected()
local pl=SYS.PC and SYS.PC.Get()
return SYS.HealSelf(pl or LP)
end
function SYS.ReviveSelected()
local pl=SYS.PC and SYS.PC.Get()
return SYS.ReviveSelf(pl or LP)
end
function SYS.RespawnSelected()
local pl=SYS.PC and SYS.PC.Get()
return SYS.RespawnSelf(pl or LP)
end
function SYS.FreeSweep()
local n0, bought = 0, 0
local mps = game:GetService("MarketplaceService")
local r = SYS.FindEvent("buy")
if not r then
SYS.Notify("⛔ 本游戏没找到 buy 类 remote", SYS.CY.yellow)
return 0
end
local ids = {}
pcall(function()
for _, d in ipairs(WS:GetDescendants()) do
local pid = d:GetAttribute("ProductId") or d:GetAttribute("productId")
or d:GetAttribute("GamepassId") or d:GetAttribute("gamepassId")
if type(pid) == "number" and not ids[pid] then ids[pid] = true end
end
end)
for pid in pairs(ids) do
local ok, info = pcall(function() return mps:GetProductInfo(pid) end)
if ok and info then
n0 = n0 + 1
if (info.PriceInRobux or 0) == 0 then
local okFire = P(function() r:FireServer(pid) end)
if okFire then bought = bought + 1 end
end
end
end
SYS.Notify(("🔎 0 元扫货: 扫到 %d 个商品, 其中免费并已尝试购买 %d 个"):format(n0, bought),
bought > 0 and SYS.CY.green or SYS.CY.yellow)
return bought
end
function SYS.HealReviveAuto()
local pl=SYS.PC and SYS.PC.Get()
pl = pl or LP
local a=SYS.HealSelf(pl)
local b=SYS.ReviveSelf(pl)
local c=SYS.RespawnSelf(pl)
SYS.Notify(("自动尝试: 回血=%s 复活=%s 重生=%s"):format(tostring(a),tostring(b),tostring(c)),
(a or b or c) and SYS.CY.green or SYS.CY.yellow)
return a or b or c
end
do
local FlyBV,FlyGyro,SpeedBV,SpeedGyro,gravZero=false,false,false,false,false
local SpeedAtt,SpeedLV=false,false
local InfiniteJumpConn=nil
local noclipThread=nil
local NoclipAtt,NoclipVel=false,false
SYS.NoclipConns={}
local function GetInputDir(camCF)
local d=Vector3.zero local f=camCF.LookVector*Vector3.new(1,0,1)
if UIS:IsKeyDown(Enum.KeyCode.W) then d+=f end
if UIS:IsKeyDown(Enum.KeyCode.S) then d-=f end
if UIS:IsKeyDown(Enum.KeyCode.A) then d-=camCF.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then d+=camCF.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.Space) then d+=Vector3.yAxis end
if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d-=Vector3.yAxis end
return d
end
local function FlyParts()
return SYS._FlyAtt,SYS._FlyVel,SYS._FlyAlign
end
function SYS.FlyTeardown()
local a,v,al=FlyParts()
if v  then P(function() v:Destroy()  end) end
if al then P(function() al:Destroy() end) end
if a  then P(function() a:Destroy()  end) end
SYS._FlyAtt,SYS._FlyVel,SYS._FlyAlign=nil,nil,nil
end
local function FlyEnsure(root)
local a,v,al=FlyParts()
if a and a.Parent==root and v and v.Parent==root and al and al.Parent==root then return true end
SYS.FlyTeardown()
local okF=pcall(function()
a=Instance.new("Attachment") a.Name="Attachment" a.Parent=root
v=Instance.new("LinearVelocity") v.Name="LinearVelocity" v.Attachment0=a
v.MaxForce=math.huge
pcall(function() v.VelocityConstraintMode=Enum.VelocityConstraintMode.Vector end)
v.VectorVelocity=Vector3.zero v.Parent=root
al=Instance.new("AlignOrientation") al.Name="AlignOrientation" al.Attachment0=a
pcall(function() al.Mode=Enum.OrientationAlignmentMode.OneAttachment end)
al.MaxTorque=math.huge al.Responsiveness=200 al.RigidityEnabled=false
al.Parent=root
end)
if (not okF) or (not v) or (not al) then
if v  then pcall(function() v:Destroy()  end) end
if al then pcall(function() al:Destroy() end) end
if a  then pcall(function() a:Destroy()  end) end
SYS._FlyAtt,SYS._FlyVel,SYS._FlyAlign=nil,nil,nil
return false
end
SYS._FlyAtt,SYS._FlyVel,SYS._FlyAlign=a,v,al
return true
end
local function FlyHoldStates(on)
local _,hum=GC() if not hum then return end
if on then
P(function()
hum:SetStateEnabled(Enum.HumanoidStateType.Running,false)
hum:ChangeState(Enum.HumanoidStateType.PlatformStanding)
end)
SYS._FlyStateHeld=true
elseif SYS._FlyStateHeld then
P(function()
hum:SetStateEnabled(Enum.HumanoidStateType.Running,true)
hum:ChangeState(Enum.HumanoidStateType.Freefall)
end)
SYS._FlyStateHeld=false
end
end
function SYS.FlyReleaseStates() FlyHoldStates(false) end
local function FlyBodyDrive(root,d,spd)
if not FlyBV or FlyBV.Parent~=root then
if FlyBV then FlyBV:Destroy() end
FlyBV=Instance.new("BodyVelocity")
FlyBV.MaxForce=Vector3.new(1e9,1e9,1e9) FlyBV.Parent=root
end
FlyBV.Velocity=d.Magnitude>0 and d.Unit*spd or Vector3.zero
end
function SYS.FlyTick(dt)
if not SYS.T_.Fly then return end
local _,_,root=GC() if not root then return end
local cam=WS.CurrentCamera if not cam or not cam.CFrame then return end
local mode=tostring(SYS.C_.FlyMode or "Align")
local d=GetInputDir(cam.CFrame)
local spd=SYS.Orig.WalkSpeed*SYS.C_.FlySpeed
if mode=="CFrame" then
FlyHoldStates(true)
if not FlyEnsure(root) then
SYS._FlyDegraded=true
FlyBodyDrive(root,d,spd)
return
end
if SYS._FlyVel then
SYS._FlyVel.VectorVelocity=d.Magnitude>0 and d.Unit*spd or Vector3.zero
end
return
end
FlyHoldStates(true)
if mode=="BodyVelocity" or SYS._FlyDegraded then
FlyBodyDrive(root,d,spd)
return
end
if not FlyEnsure(root) then
SYS._FlyDegraded=true
SYS.Notify("⚠ 这台执行器不支持 LinearVelocity/AlignOrientation, 飞行已自动降级为 BodyVelocity",SYS.CY.yellow)
FlyBodyDrive(root,d,spd)
return
end
local f=cam.CFrame.LookVector*Vector3.new(1,0,1)
if f.Magnitude>0.1 and SYS._FlyAlign then
SYS._FlyAlign.CFrame=CFrame.lookAt(root.Position,root.Position+f.Unit)
end
if SYS._FlyVel then
SYS._FlyVel.VectorVelocity=d.Magnitude>0 and d.Unit*spd or Vector3.zero
end
end
local lastSM=-1
local function expectSpeed()
local base=SYS.Orig.WalkSpeed or 16
if SYS.T_.Speed then return base*(SYS.C_.SpeedMult or 1) end
return base
end
local function guardSpeed(v)
if SYS.T_.Prot_SpeedCap then
local cap=tonumber(SYS.C_.SpeedCap) or 0
if cap>0 and v and v>cap then return cap end
end
return v
end
local function wantWalkSpeed()
local base=SYS.Orig.WalkSpeed or 16
if SYS.T_.Speed and SYS.C_.SpeedMode=="WalkSpeed" then return guardSpeed(base*(SYS.C_.SpeedMult or 1)) end
return guardSpeed(base)
end
function SYS.SpeedTick()
if not SYS.T_.Speed or SYS.T_.Fly or SYS.FreeCamActive then return end
local _,hum,root=GC() if not hum or not root then return end
local spd=guardSpeed(SYS.Orig.WalkSpeed*(SYS.C_.SpeedMult or 1))
if SYS.C_.SpeedMode=="WalkSpeed" then
if math.abs(hum.WalkSpeed-spd)>spd*0.01 then hum.WalkSpeed=spd end
lastSM=SYS.C_.SpeedMult
return
end
if SYS.C_.SpeedMode=="BodyVelocity" then
if not SpeedBV or SpeedBV.Parent~=root then
if SpeedBV then SpeedBV:Destroy() end
SpeedBV=Instance.new("BodyVelocity")
SpeedBV.MaxForce=Vector3.new(1e9,0,1e9) SpeedBV.Parent=root
end
if not SpeedGyro or SpeedGyro.Parent~=root then
if SpeedGyro then SpeedGyro:Destroy() end
SpeedGyro=Instance.new("BodyGyro")
SpeedGyro.MaxTorque=Vector3.new(1e9,1e9,1e9)
SpeedGyro.P=1e5 SpeedGyro.D=1000 SpeedGyro.Parent=root
end
local c0=WS.CurrentCamera if not c0 or not c0.CFrame then return end
local f0=c0.CFrame.LookVector*Vector3.new(1,0,1)
if f0.Magnitude>0.1 then SpeedGyro.CFrame=CFrame.lookAt(root.Position,root.Position+f0.Unit) end
local d0=Vector3.zero
if UIS:IsKeyDown(Enum.KeyCode.W) then d0+=f0 end
if UIS:IsKeyDown(Enum.KeyCode.S) then d0-=f0 end
if UIS:IsKeyDown(Enum.KeyCode.A) then d0-=c0.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then d0+=c0.CFrame.RightVector end
SpeedBV.Velocity=d0.Magnitude>0 and d0.Unit*spd or Vector3.zero
return
end
if not (SpeedAtt and SpeedAtt.Parent==root) or not (SpeedLV and SpeedLV.Parent==root) then
if SpeedLV then SpeedLV:Destroy() SpeedLV=nil end
if SpeedAtt then SpeedAtt:Destroy() SpeedAtt=nil end
SpeedAtt=Instance.new("Attachment") SpeedAtt.Name="Attachment" SpeedAtt.Parent=root
SpeedLV=Instance.new("LinearVelocity") SpeedLV.Name="LinearVelocity" SpeedLV.Attachment0=SpeedAtt
SpeedLV.MaxForce=math.huge
P(function() SpeedLV.VelocityConstraintMode=Enum.VelocityConstraintMode.Vector end)
SpeedLV.VectorVelocity=Vector3.zero SpeedLV.Parent=root
end
local cam=WS.CurrentCamera if not cam or not cam.CFrame then return end
local f=cam.CFrame.LookVector*Vector3.new(1,0,1)
local d=Vector3.zero
if UIS:IsKeyDown(Enum.KeyCode.W) then d+=f end
if UIS:IsKeyDown(Enum.KeyCode.S) then d-=f end
if UIS:IsKeyDown(Enum.KeyCode.A) then d-=cam.CFrame.RightVector end
if UIS:IsKeyDown(Enum.KeyCode.D) then d+=cam.CFrame.RightVector end
SpeedLV.VectorVelocity=d.Magnitude>0 and d.Unit*spd or Vector3.zero
end
function SYS.CleanFly()
if FlyBV then FlyBV:Destroy() FlyBV=nil end
if FlyGyro then FlyGyro:Destroy() FlyGyro=nil end
if SYS.FlyTeardown then P(SYS.FlyTeardown) end
if SYS.FlyReleaseStates then P(SYS.FlyReleaseStates) end
SYS._FlyStateHeld=false
SYS._FlyDegraded=false
if gravZero then WS.Gravity=SYS.Orig.Gravity gravZero=false end
end
function SYS.CleanSpeed()
if SpeedBV then SpeedBV:Destroy() SpeedBV=nil end
if SpeedGyro then SpeedGyro:Destroy() SpeedGyro=nil end
if SpeedLV then SpeedLV:Destroy() SpeedLV=nil end
if SpeedAtt then SpeedAtt:Destroy() SpeedAtt=nil end
lastSM=-1
local _,hum=GC() if hum then hum.WalkSpeed=SYS.Orig.WalkSpeed end
end
function SYS.ApplyNoclip(ch,on)
if not ch then return end
for _,p in ipairs(ch:GetDescendants()) do
if p:IsA("BasePart") then p.CanCollide=not on end
end
end
function SYS.SetNoclip(on)
for _,c in ipairs(SYS.NoclipConns) do DS(c) end
SYS.NoclipConns={}
if noclipThread then task.cancel(noclipThread) noclipThread=nil end
if NoclipVel then NoclipVel:Destroy() NoclipVel=nil end
if NoclipAtt then NoclipAtt:Destroy() NoclipAtt=nil end
if not on then
local ch=LP.Character if ch then SYS.ApplyNoclip(ch,false) end
return
end
local ch=LP.Character if ch then SYS.ApplyNoclip(ch,true) end
table.insert(SYS.NoclipConns,LP.CharacterAdded:Connect(function(c)
task.defer(function() if SYS.T_.Noclip then SYS.ApplyNoclip(c,true) end end)
end))
noclipThread=task.spawn(function()
while SYS.T_.Noclip and not SYS.Unloaded do
local c=LP.Character
if c then
for _,p in ipairs(c:GetDescendants()) do
if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end
end
local root=c:FindFirstChild("HumanoidRootPart")
local cam=WS and WS.CurrentCamera
if root and cam and cam.CFrame then
local d=GetInputDir(cam.CFrame)
if d.Magnitude>0.1 then
if not NoclipVel or NoclipVel.Parent~=root then
if NoclipVel then NoclipVel:Destroy() end
if NoclipAtt then NoclipAtt:Destroy() end
local okA,att=pcall(function()
local a=Instance.new("Attachment") a.Name="Attachment" a.Parent=root
return a
end)
local okV,vel=pcall(function()
local v=Instance.new("LinearVelocity") v.Name="LinearVelocity"
v.Attachment0=att v.MaxForce=math.huge
v.VectorVelocity=Vector3.zero v.Parent=root
return v
end)
if okA and att and okV and vel then
NoclipAtt=att NoclipVel=vel
end
end
if NoclipVel then
local ws=SYS.Orig.WalkSpeed or 16
NoclipVel.VectorVelocity=d.Unit*ws
end
elseif NoclipVel then
NoclipVel.VectorVelocity=Vector3.zero
end
end
end
task.wait(0.15)
end
end)
end
function SYS.SetInfiniteJump(on)
if InfiniteJumpConn then DS(InfiniteJumpConn) InfiniteJumpConn=nil end
if not on then return end
InfiniteJumpConn=UIS.InputBegan:Connect(function(input,gp)
if gp or not SYS.T_.InfiniteJump or input.KeyCode~=Enum.KeyCode.Space then return end
local _,h=GC()
if h and h.Health>0 then
pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end)
end
end)
end
local LOCK_EPS=0.35
local function lockOrigJump(hum)
if SYS.Orig.JumpPower==nil then
local ok1,jp=pcall(function() return hum.JumpPower end)
SYS.Orig.JumpPower=(ok1 and tonumber(jp)) or 50
local ok2,jh=pcall(function() return hum.JumpHeight end)
SYS.Orig.JumpHeight=(ok2 and tonumber(jh)) or nil
end
end
function SYS.LockTick()
local _,hum,root=GC()
if hum and root then
if SYS.T_.LockSpeed then
local base=SYS.Orig.WalkSpeed or 16
local want=base
if SYS.T_.Speed then want=guardSpeed(base*(SYS.C_.SpeedMult or 1)) end
if math.abs((hum.WalkSpeed or 0)-want)>LOCK_EPS then hum.WalkSpeed=want end
end
if SYS.T_.LockJump then
lockOrigJump(hum)
local jm=SYS.C_.JumpMult or 1
if SYS.Orig.JumpPower then
local wp=SYS.Orig.JumpPower*jm
if math.abs((hum.JumpPower or 0)-wp)>LOCK_EPS then P(function() hum.JumpPower=wp end) end
end
if SYS.Orig.JumpHeight then
local wh=SYS.Orig.JumpHeight*jm
if math.abs((hum.JumpHeight or 0)-wh)>LOCK_EPS then P(function() hum.JumpHeight=wh end) end
end
end
end
if SYS.T_.LockGravity then
local g=tonumber(SYS.C_.Gravity)
if g and g>=0 and math.abs((WS.Gravity or 196.2)-g)>0.05 then P(function() WS.Gravity=g end) end
end
end
function SYS.SetLocks()
SYS.SetLoop("Locks",
(SYS.T_.LockSpeed or SYS.T_.LockJump or SYS.T_.LockGravity) and true or false,
SYS.PhysicsStep,SYS.LockTick)
end
local PathKeyConn=nil
local NUM_NAME={One=1,Two=2,Three=3,Four=4,Five=5,Six=6,Seven=7,Eight=8,Nine=9}
function SYS.SetPathKey(on)
if PathKeyConn then DS(PathKeyConn) PathKeyConn=nil end
if not on then return end
PathKeyConn=UIS.InputBegan:Connect(function(input,gp)
if gp or not SYS.T_.PathKey then return end
if not (UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl)) then return end
local nm=tostring(input.KeyCode):match("KeyCode%.(%w+)$")
if not nm then return end
local idx=NUM_NAME[nm] or NUM_NAME[(nm:gsub("^Keypad",""))]
if not idx then return end
if SYS.T_.WPKey==true and SYS.WP and SYS.WP.List[idx] then
P(function() SYS.WP.Goto(idx,"tp") end)
return
end
local s=SYS.SavedPos[idx]
if not s then
P(function()
SYS.Notify(("📍 没有第 %d 个保存点 (当前共 %d 个)"):format(idx,#SYS.SavedPos),SYS.CY.sub)
end)
return
end
P(function() SYS.TPTo(s.position+Vector3.new(0,2,0)) end)
end)
end
function SYS.FetchServers()
if type(game.HttpGet)~="function" then return nil,"这台执行器没有 HttpGet" end
if not game.PlaceId then return nil,"读不到 PlaceId" end
local ok,body=pcall(function()
return game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100"):format(game.PlaceId))
end)
if not ok or type(body)~="string" or body=="" then return nil,"拉列表失败(网络不通 / 执行器限制)" end
local list
P(function()
local hs=game:GetService("HttpService")
local d=hs and hs:JSONDecode(body)
if d and type(d.data)=="table" then list=d.data end
end)
if type(list)~="table" then return nil,"列表解析失败(接口字段变了?)" end
local out={}
for _,v in ipairs(list) do
if type(v)=="table" and type(v.id)=="string" then
out[#out+1]={id=v.id,playing=tonumber(v.playing) or 0,
max=tonumber(v.maxPlayers) or 0,cur=(v.id==game.JobId)}
end
end
return out,nil
end
function SYS.JoinServer(jobId)
if type(jobId)~="string" or jobId=="" then return false end
local TS=game:GetService("TeleportService")
if not (TS and TS.TeleportToPlaceInstance and game.PlaceId) then
SYS.Notify("跳服不可用(拿不到 TeleportService)",SYS.CY.red) return false
end
local url=tostring(SYS.BuildURL or "")
if url:sub(1,4)=="http" and type(queue_on_teleport)=="function" then
P(function() queue_on_teleport(('loadstring(game:HttpGet("%s"))()'):format(url)) end)
else
SYS.Notify("⚠️ 本地版没有网络地址 -> 跳过去后【脚本不会自动回来】, 要重新执行一次加载器。",SYS.CY.yellow)
end
SYS.Notify("🚀 正在加入所选服务器...",SYS.CY.cyan)
task.delay(0.5,function() P(function() TS:TeleportToPlaceInstance(game.PlaceId,jobId,LP) end) end)
return true
end
local TrapConns,TrapOn=nil,false
local TRAP_WIN  = 0.45
local TRAP_SPD  = 1.6
local TRAP_BACK = 1.2
local TRAP_MAXSTEP = 40
function SYS.CleanTrapGuard()
TrapOn=false
if TrapConns then for _,c in ipairs(TrapConns) do DS(c) end end
TrapConns=nil SYS.TrapHit=false
P(SYS.TrapIgnore)
end
local TrapIgnored=false
function SYS.TrapIgnore(on)
if on and TrapIgnored then return end
if (not on) and (not TrapIgnored) then return end
local ch=LP and LP.Character
if ch then
for _,p in ipairs(ch:GetDescendants()) do
if p:IsA("BasePart") then
p.CanTouch=not on
p.CanQuery=not on
end
end
end
TrapIgnored=on and true or false
end
function SYS.SetTrapImmune(on)
SYS.CleanTrapGuard()
if not on then return end
TrapConns={} TrapOn=true
local function hookChar(ch)
if not ch then return end
local hrp=ch:FindFirstChild("HumanoidRootPart")
if not hrp then return end
table.insert(TrapConns,hrp.Touched:Connect(function(hit)
if not (TrapOn and SYS.T_.TrapImmune) then return end
local v=hrp.AssemblyLinearVelocity
local hv=Vector3.new(v.X,0,v.Z).Magnitude
local ws=expectSpeed()
local hitV=0
P(function() hitV=hit.AssemblyLinearVelocity.Magnitude end)
if hv>ws*TRAP_SPD or hitV>ws*TRAP_SPD then
SYS.TrapHit=os.clock()
SYS.TrapAnchor=hrp.Position
end
end))
end
hookChar(LP.Character)
table.insert(TrapConns,LP.CharacterAdded:Connect(function(c)
hookChar(c)
if TrapIgnored then P(function() SYS.TrapIgnore(true) end) end
end))
TrapConns[#TrapConns+1]=RS.RenderStepped:Connect(function(dt)
if SYS.Unloaded or not TrapOn or not SYS.T_.TrapImmune then return end
P(function()
local ch,hum,hrp=GC()
if not ch or not hum or not hrp then return end
if not (SYS.T_.Fly or SYS.T_.Speed or SYS.FreeCamActive) then
local vv=hrp.AssemblyLinearVelocity
if Vector3.new(vv.X,0,vv.Z).Magnitude>expectSpeed()*TRAP_SPD then
if not SYS.TrapHit then SYS.TrapAnchor=hrp.Position end
SYS.TrapHit=os.clock()
end
end
if hum.Health>0 and hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end
local want=wantWalkSpeed()
if hum.WalkSpeed<want*0.9 then hum.WalkSpeed=want end
if not SYS.T_.GodMode then
local ok,st=pcall(function() return hum:GetState() end)
if (ok and st==Enum.HumanoidStateType.Physics) or hum.PlatformStand==true then
P(function() hum.PlatformStand=false hum:ChangeState(Enum.HumanoidStateType.Running) end)
end
end
if hum.Sit then P(function() hum.Sit=false end) end
for _,d in ipairs(ch:GetDescendants()) do
if d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") then
if d.Part0~=hrp and d.Part1~=hrp then DS(d) end
end
end
local hit=SYS.TrapHit
if hit and (os.clock()-hit)<TRAP_WIN then
local v=hrp.AssemblyLinearVelocity
local md=hum.MoveDirection
local walking=md and (math.abs(md.X)>0.01 or math.abs(md.Z)>0.01)
if walking then
local w2=wantWalkSpeed()
hrp.AssemblyLinearVelocity=Vector3.new(md.X*w2,v.Y,md.Z*w2)
SYS.TrapAnchor=hrp.Position
else
local v=hrp.AssemblyLinearVelocity
hrp.AssemblyLinearVelocity=Vector3.new(0,v.Y,0)
local a=SYS.TrapAnchor
if a then
local d=hrp.Position-a
local hz=Vector3.new(d.X,0,d.Z)
local hzm=hz.Magnitude
if hzm>TRAP_BACK then
local dir=hz.Unit
local cap=math.min(TRAP_MAXSTEP, math.max(0.5, expectSpeed()*(dt or 1/60)*1.5))
local np=hrp.Position-dir*math.min(hzm,cap)
local rot=hrp.CFrame-hrp.CFrame.Position
hrp.CFrame=CFrame.new(Vector3.new(np.X,np.Y,np.Z))*rot
end
end
end
elseif hit then
SYS.TrapHit=false
end
end)
end)
for i=1,#TrapConns do T(TrapConns[i]) end
P(function() SYS.TrapIgnore(true) end)
print("[CheatMenu] 反陷阱免伤: 已开启(无视触发 + 免疫 位移/弹开/定身/布娃娃/坐骑/焊接 + 补血; 服务端结算的伤害拦不住)")
end
end
do
local AR = { on=false, ev=nil, orig=nil, lastPos=nil, lastT=0, fixed=0 }
SYS.AntiRevert = AR
local function findRepl()
local r=RStorage
if not r then return nil end
local ok,ev=P(function() return r:FindFirstChild("ClientReplicateCFrame", true) end)
if ok and ev and (ev:IsA("RemoteEvent") or ev:IsA("UnreliableRemoteEvent")) then return ev end
if SYS.FindEvent then
local ok2,e2=P(function() return SYS.FindEvent("move") end)
if ok2 and e2 and e2.FireServer then return e2 end
end
return nil
end
function AR.On()
if AR.on then return true end
if type(hookfunction)~="function" then return false,"这台执行器没有 hookfunction" end
local ev=findRepl()
if not ev then return false,"没找到位置上报的 remote(ClientReplicateCFrame)" end
local ok=pcall(function()
AR.ev=ev
AR.orig=hookfunction(ev.FireServer,newcclosure(function(self,...)
if not AR.on then return AR.orig(self,...) end
local n=select("#",...)
if n==0 then return AR.orig(self,...) end
local now=os.clock()
local dt=now-(AR.lastT or now)
local maxStep=math.max(3,(SYS.C_.WalkSpeed or 22)*3*math.min(dt,0.5))
local a={...}
local touched=false
for i=1,n do
local v=a[i]
local tp=(typeof and typeof(v)) or type(v)
if tp=="CFrame" then
local p=v.Position
if AR.lastPos then
local d=p-AR.lastPos
local m=d.Magnitude
if m>maxStep and m>0 then
local np=AR.lastPos+d.Unit*maxStep
a[i]=CFrame.new(np, np+v.LookVector)
AR.fixed=AR.fixed+1
touched=true
p=np
end
end
AR.lastPos=p
elseif tp=="Vector3" then
if AR.lastPos then
local d=v-AR.lastPos
local m=d.Magnitude
if m>maxStep and m>0 then
a[i]=AR.lastPos+d.Unit*maxStep
AR.fixed=AR.fixed+1
touched=true
end
end
AR.lastPos=a[i]
end
end
AR.lastT=now
return AR.orig(self, table.unpack(a,1,n))
end))
end)
if not ok then return false,"hook 失败" end
AR.on=true AR.lastPos=nil AR.lastT=os.clock()
print("[CheatMenu] 防回退已随飞行/加速开启(位置上报限速)")
return true
end
function AR.Off()
if not AR.on then return end
AR.on=false
if AR.ev and AR.orig and type(hookfunction)=="function" then
P(function() hookfunction(AR.ev.FireServer,AR.orig) end)
end
AR.lastPos=nil
print("[CheatMenu] 防回退已关闭")
end
function SYS.SyncAntiRevert()
local want=(SYS.T_.Fly==true) or (SYS.T_.Speed==true)
if want then P(AR.On) else P(AR.Off) end
end
end
do
local GodConn,GodHP
local function ApplyGod(h)
if not h then return end
P(function()
h:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
h:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
h.BreakJointsOnDeath=false
end)
end
local function RestoreGod(h)
if not h then return end
P(function()
h:SetStateEnabled(Enum.HumanoidStateType.Dead,true)
h:SetStateEnabled(Enum.HumanoidStateType.FallingDown,not SYS.T_.NoFall)
h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
h.BreakJointsOnDeath=true
end)
end
local function BindGod()
local _,h=GC() if not h then return end
ApplyGod(h)
if GodHP then GodHP:Disconnect() end
GodHP=h.HealthChanged:Connect(function(v)
if v>0 and v<h.MaxHealth then h.Health=h.MaxHealth end
end)
end
function SYS.SetGod(on)
if SYS.SetNoDeath then P(SYS.SetNoDeath,on) end
if SYS.SetNoKnock then P(SYS.SetNoKnock,on) end
if on then
BindGod()
if not GodConn then
GodConn=LP.CharacterAdded:Connect(function()
task.wait(0.4) if SYS.T_.GodMode then BindGod() end
end)
end
else
if GodConn then GodConn:Disconnect() GodConn=nil end
if GodHP then GodHP:Disconnect() GodHP=nil end
local _,h=GC() RestoreGod(h)
end
end
local NoFallConn
function SYS.SetNoFall(on)
if NoFallConn then NoFallConn:Disconnect() NoFallConn=nil end
local function sync(h)
if not h then return end
local blockFall=SYS.T_.GodMode or SYS.T_.NoFall
P(function()
h:SetStateEnabled(Enum.HumanoidStateType.FallingDown,not blockFall)
h:SetStateEnabled(Enum.HumanoidStateType.Freefall,not SYS.T_.NoFall)
end)
end
local _,h=GC() sync(h)
if on then
NoFallConn=LP.CharacterAdded:Connect(function()
task.wait(0.4) if SYS.T_.NoFall then local _,hh=GC() sync(hh) end
end)
end
end
local JumpConn,JumpOrig,JHOrig=nil,nil,nil
function SYS.SetJumpBoost(on)
if JumpConn then JumpConn:Disconnect() JumpConn=nil end
local function apply(h)
if not h then return end
if JumpOrig==nil then
JumpOrig=h.JumpPower or 50
JHOrig=(h.JumpHeight and h.JumpHeight>0) and h.JumpHeight or nil
end
local mult=tonumber(SYS.C_.JumpMult) or 2
P(function()
h.UseJumpPower=true
h.JumpPower=JumpOrig*mult
if JHOrig then h.JumpHeight=JHOrig*mult end
end)
end
local function restore(h)
if not h then return end
P(function()
if JumpOrig then h.JumpPower=JumpOrig end
if JHOrig then h.JumpHeight=JHOrig end
end)
end
local _,h=GC()
if on then apply(h) else restore(h) JumpOrig=nil JHOrig=nil end
if on then
JumpConn=LP.CharacterAdded:Connect(function()
task.wait(0.4) if SYS.T_.JumpBoost then local _,hh=GC() apply(hh) end
end)
end
end
function SYS.SetFullBright(on)
if not LT then return end
if on then
LT.Brightness=2 LT.ClockTime=12
LT.Ambient=Color3.new(1,1,1) LT.OutdoorAmbient=Color3.new(1,1,1)
LT.FogEnd=1e5 LT.FogColor=Color3.new(1,1,1)
LT.GlobalShadows=false
SYS.OrigFX={}
for _,e in ipairs(LT:GetChildren()) do
if e:IsA("PostEffect") then SYS.OrigFX[e]=e.Enabled e.Enabled=false end
end
else
LT.Brightness=SYS.Orig.Brightness LT.ClockTime=SYS.Orig.ClockTime
LT.Ambient=SYS.Orig.Ambient LT.OutdoorAmbient=SYS.Orig.OutdoorAmbient
LT.FogEnd=SYS.Orig.FogEnd LT.FogColor=SYS.Orig.FogColor
LT.GlobalShadows=true
if SYS.OrigFX then for e,en in pairs(SYS.OrigFX) do e.Enabled=en end SYS.OrigFX=nil end
end
end
local DeepHideConn, DeepHideCharConn, DeepHideAnchor, DeepHideY = nil, nil, nil, 0
local DeepHideFloor=nil
local DH_ACC=0
local function DeepHideFeetY(root)
local y=nil
pcall(function()
local par=root.Parent
local h=par and par:FindFirstChildOfClass("Humanoid")
local hip=(h and h.HipHeight) or 2
local sz=root.Size
y=root.Position.Y-(hip+((sz and sz.Y) and sz.Y/2 or 1))
end)
if type(y)~="number" then y=root.Position.Y-3 end
return y
end
local function deepHideDepthNow()
local d=tonumber(SYS.C_.DeepHideDepth) or 120
if d<5 then d=5 elseif d>400 then d=400 end
local ok,fdh=P(function() return WS.FallenPartsDestroyHeight end)
if ok and type(fdh)=="number" and fdh>-1e6 then
local maxD=DeepHideY-fdh-60
if maxD>=5 and d>maxD then d=maxD end
end
return d
end
local function deepHideTarget(root)
local depth=deepHideDepthNow()
local md=tostring(SYS.C_.DeepHideMode or "down")
local ox=tonumber(SYS.C_.DeepHideOffX) or 0
local oz=tonumber(SYS.C_.DeepHideOffZ) or 0
if md=="flat" then
return Vector3.new(root.Position.X+ox, root.Position.Y, root.Position.Z+oz)
end
local sign=(md=="up") and 1 or -1
local ty=DeepHideY + sign*depth
return Vector3.new(root.Position.X+ox, ty, root.Position.Z+oz)
end
local function deepHideApply(root)
if DeepHideAnchor then DeepHideAnchor:Destroy() end
local a=Instance.new("Part")
a.Name="DH_Anchor"
a.Size=Vector3.new(1,1,1) a.Transparency=1 a.Anchored=true
a.CanCollide=false a.CanQuery=false a.CanTouch=false
a.CFrame=CFrame.new(root.Position)
a.Parent=WS
DeepHideAnchor=a
DeepHideY=root.Position.Y
local tp=deepHideTarget(root)
root.CFrame=CFrame.new(tp.X,tp.Y,tp.Z)
pcall(function() root.AssemblyLinearVelocity=Vector3.zero end)
if DeepHideFloor then DeepHideFloor:Destroy() DeepHideFloor=nil end
local fl=Instance.new("Part")
fl.Name="DH_Floor" fl.Size=Vector3.new(400,2,400) fl.Transparency=1
fl.Anchored=true fl.CanCollide=true fl.CanQuery=false fl.CanTouch=false
fl.CFrame=CFrame.new(tp.X,DeepHideFeetY(root)-2,tp.Z)
fl.Parent=WS
DeepHideFloor=fl
local cam=WS and WS.CurrentCamera
if cam then pcall(function() cam.CameraSubject=a end) end
end
function SYS.SetDeepHide(on)
if DeepHideConn then DeepHideConn:Disconnect() DeepHideConn=nil end
if DeepHideCharConn then DeepHideCharConn:Disconnect() DeepHideCharConn=nil end
if on then
local ch=LP.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
if not root then return end
deepHideApply(root)
DeepHideConn=RS.RenderStepped:Connect(function(dt)
if SYS.Unloaded then return end
local r=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
local cc=WS and WS.CurrentCamera
if r and DeepHideAnchor and DeepHideAnchor.Parent then
DeepHideAnchor.CFrame=CFrame.new(r.Position.X,DeepHideY,r.Position.Z)
end
if cc and DeepHideAnchor and cc.CameraSubject~=DeepHideAnchor then
pcall(function() cc.CameraSubject=DeepHideAnchor end)
end
DH_ACC=DH_ACC+(tonumber(dt) or 1/60)
if r and DH_ACC>=1/30 then
DH_ACC=0
local tp=deepHideTarget(r)
local hy=tp.Y
local sign=(tostring(SYS.C_.DeepHideMode or "down")=="up") and 1 or -1
local p=r.Position
local outOfRange = (sign<0) and (p.Y<hy-60) or (p.Y>hy+60)
pcall(function()
if outOfRange then
r.CFrame=CFrame.new(p.X,hy,p.Z)
else
local v=r.AssemblyLinearVelocity
if (sign<0) and p.Y>hy+4 then
r.AssemblyLinearVelocity=Vector3.new(v.X,-60,v.Z)
elseif (sign>0) and p.Y<hy-4 then
r.AssemblyLinearVelocity=Vector3.new(v.X,60,v.Z)
elseif (sign<0) and v.Y<-1 then
r.AssemblyLinearVelocity=Vector3.new(v.X,-1,v.Z)
elseif (sign>0) and v.Y>1 then
r.AssemblyLinearVelocity=Vector3.new(v.X,1,v.Z)
end
end
end)
if DeepHideFloor and DeepHideFloor.Parent then
local fc=DeepHideFloor.Position
if math.abs(fc.X-p.X)>60 or math.abs(fc.Z-p.Z)>60 then
DeepHideFloor.CFrame=CFrame.new(p.X,DeepHideFeetY(r)-2,p.Z)
end
end
end
end)
T(DeepHideConn)
DeepHideCharConn=LP.CharacterAdded:Connect(function(c)
task.wait(0.3)
if SYS.Unloaded or not SYS.T_.DeepHide then return end
local r=c:FindFirstChild("HumanoidRootPart")
if r then deepHideApply(r) end
end)
T(DeepHideCharConn)
else
if not (DeepHideAnchor or DeepHideFloor) then return end
local ch=LP.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
if root then
local pos=root.Position
local ty=DeepHideY
pcall(function()
local rp=RaycastParams.new()
local okFT,ft=pcall(function()
return Enum.RaycastFilterType.Exclude or Enum.RaycastFilterType.Blacklist
end)
rp.FilterType=(okFT and ft) or Enum.RaycastFilterType.Blacklist
local ig={ch}
if DeepHideFloor then ig[#ig+1]=DeepHideFloor end
rp.FilterDescendantsInstances=ig
local hit=WS:Raycast(Vector3.new(pos.X,(DeepHideY or pos.Y)+8,pos.Z),Vector3.new(0,-600,0),rp)
if hit and hit.Position then ty=hit.Position.Y end
end)
if type(ty)~="number" then ty=DeepHideY end
local rot=(root.CFrame-root.CFrame.Position)
pcall(function()
root.CFrame=CFrame.new(pos.X,ty+3,pos.Z)*rot
root.AssemblyLinearVelocity=Vector3.zero
end)
print(("[DeepHide] 单帧浮回地面 (X=%.0f Z=%.0f  %.0f -> %.0f)")
:format(pos.X,pos.Z,pos.Y,ty+3))
end
if DeepHideAnchor then DeepHideAnchor:Destroy() DeepHideAnchor=nil end
if DeepHideFloor then DeepHideFloor:Destroy() DeepHideFloor=nil end
local cc=WS and WS.CurrentCamera
local h=ch and ch:FindFirstChildOfClass("Humanoid")
if cc and h then pcall(function() cc.CameraSubject=h end) end
end
end
function SYS.DeepHideReapply()
if not SYS.T_.DeepHide then return end
local ch=LP.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
if not root then return end
local tp=deepHideTarget(root)
pcall(function()
root.CFrame=CFrame.new(tp.X,tp.Y,tp.Z)
root.AssemblyLinearVelocity=Vector3.zero
end)
if DeepHideFloor and DeepHideFloor.Parent then
DeepHideFloor.CFrame=CFrame.new(tp.X,DeepHideFeetY(root)-2,tp.Z)
end
print(("[DeepHide] 藏身位置已调整: 方向=%s Y=%.0f 偏移(%.0f, %.0f)")
:format(tostring(SYS.C_.DeepHideMode or "down"),tp.Y,tp.X-root.Position.X,tp.Z-root.Position.Z))
end
function SYS.Rejoin()
pcall(function()
local TS=game:GetService("TeleportService")
if TS and TS.Teleport and game.PlaceId then
TS:Teleport(game.PlaceId)
end
end)
end
SYS.EventWatch = {
keywords = {"monster","fake","real","boss","wave","round","event","spawn","alert","warn","announce","hint","notice",
"touchdamage","damagedeny","denyinform","highlight","renam","resetname",
"status","playstate","preSpawnDarken","prespawndarken","querylock",
"selectrole","selectedrole","deathEffects","deatheffects",
"mailbox","roulette","secretcase","prototypecase","socialrewards",
"friendreward","milestone","onlinereward","battlepass","minipass",
"serverlist","joinserver","teleporttoserver","pickgameteam","selectloadout",
"inventoryview","inventoryquery","operate","companion","dungeon",
"purchase","buyproduct","buygamepass","boxbuy","buyeventitem","purchaseresult",
"claimreward","claimdaily","claimweeklycase","claimpremiumreward","claimrebirthreward",
"claimseasonweapon","claimstall","claimtradetokenreward","collectrionclaim","dailyreward",
"rewardreceived","commanditemsreceived","friendreward","milestonereward","onlinereward",
"pickup","collect","lootevent","dropcoin","dropflag","orbpickup","itemcapture","craftitems",
"roundstart","roundend","gamestart","gameend","matchend","matchstart","result",
"gacha","spin","raffle","secretluck","case","jackpot",
"quest","seasonchanged","challenge","ranked",
"playerdied","revive","resurrect","checkrevive",
"detect","detected","violation","flagged","punish","suspicious","antich","automod","report"},
conns = {}, seen = {},
}
function SYS.EventWatchScan()
local roots = {}
local r1 = RStorage:FindFirstChild("Remote")
if r1 then roots[#roots+1] = r1 end
roots[#roots+1] = RStorage
local n, names, seen = 0, {}, {}
pcall(function()
for _, root in ipairs(roots) do
for _, c in ipairs(root:GetDescendants()) do
local ln = string.lower(tostring(c.Name))
for _, k in ipairs(SYS.EventWatch.keywords) do
if ln:find(k, 1, true) and not seen[c.Name] then
seen[c.Name] = true
n = n + 1 names[#names+1] = c.Name break
end
end
end
end
end)
return n, names, RStorage
end
function SYS.SetEventWatch(on)
SYS.T_.EventWatch = on and true or false
local E = SYS.EventWatch
for _, c in ipairs(E.conns) do P(function() c:Disconnect() end) end
E.conns = {}
if not SYS.T_.EventWatch then return end
local n, names, rel = SYS.EventWatchScan()
for _, nm in ipairs(names) do
local inst = rel and rel:FindFirstChild(nm, true)
if inst then
pcall(function()
E.conns[#E.conns+1] = inst.OnClientEvent:Connect(function(...)
if not SYS.T_.EventWatch then return end
local a = table.pack(...)
local parts = {}
for i = 1, math.min(a.n, 3) do
local tv = type(a[i])
if tv == "string" or tv == "number" or tv == "boolean" then
parts[#parts+1] = tostring(a[i])
end
end
local d = table.concat(parts, " · ")
local key = nm .. "|" .. d
local now = os.clock()
if E.seen[key] and now - E.seen[key] < 8 then return end
E.seen[key] = now
P(function() SYS.Hud("📣 " .. nm .. (d ~= "" and ("  →  " .. d) or ""), 6) end)
end)
end)
end
end
SYS.Notify(("📣 事件预告已开: 挂上 %d 条信号"):format(#E.conns),
#E.conns > 0 and SYS.CY.green or SYS.CY.yellow)
print(("[CheatMenu] 事件预告: 命中 %d 条 -> %s"):format(n, table.concat(names, ", ")))
end
function SYS.GetPingMs()
local ms
P(function()
local ok,v=pcall(function() return LP:GetNetworkPing() end)
if ok and type(v)=="number" and v>0 then ms=math.floor(v*1000+0.5) end
end)
if not ms then
P(function()
local st=game:GetService("Stats")
local it=st.Network.ServerStatsItem["Data Ping"]
if it then ms=math.floor(it:GetValue()+0.5) end
end)
end
return ms
end
local LowLatSaved=nil
function SYS.SetLowLatency(on)
local LT=game:GetService("Lighting")
if on then
if not LowLatSaved then
LowLatSaved={}
P(function() LowLatSaved.Shadows=LT.GlobalShadows LT.GlobalShadows=false end)
P(function() LowLatSaved.Soft=LT.ShadowSoftness LT.ShadowSoftness=0 end)
P(function() LowLatSaved.EnvD=LT.EnvironmentDiffuseScale LT.EnvironmentDiffuseScale=0 end)
P(function() LowLatSaved.EnvS=LT.EnvironmentSpecularScale LT.EnvironmentSpecularScale=0 end)
end
P(function() if SYS.SetPerf then SYS.SetPerf(true) end end)
SYS.Notify("🚀 低延迟模式已开: 关阴影/环境反射(压帧时间) —— 注意这降的是【帧时间】, 不是 ping",SYS.CY.green)
else
if LowLatSaved then
P(function() if LowLatSaved.Shadows~=nil then LT.GlobalShadows=LowLatSaved.Shadows end end)
P(function() if LowLatSaved.Soft~=nil then LT.ShadowSoftness=LowLatSaved.Soft end end)
P(function() if LowLatSaved.EnvD~=nil then LT.EnvironmentDiffuseScale=LowLatSaved.EnvD end end)
P(function() if LowLatSaved.EnvS~=nil then LT.EnvironmentSpecularScale=LowLatSaved.EnvS end end)
LowLatSaved=nil
end
end
end
function SYS.HopLowPing(reason)
if SYS._Hopping then return false end
local maxTry=tonumber(SYS.C_.HopMaxTry) or 4
local n=tonumber(_G and _G.CM_HOPN) or 0
if n>=maxTry then
SYS.Notify(("已跳 %d 次仍未达标, 停止(避免一直跳) —— 当前 ping %s ms")
:format(n,tostring(SYS.GetPingMs())),SYS.CY.yellow)
return false
end
local TS=game:GetService("TeleportService")
if not (TS and TS.TeleportToPlaceInstance and game.PlaceId) then
SYS.Notify("跳服不可用(拿不到 TeleportService)",SYS.CY.red) return false
end
local okH,body=pcall(function()
return game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"):format(game.PlaceId))
end)
if not okH or type(body)~="string" or body=="" then
SYS.Notify("拉服务器列表失败(执行器没有 HttpGet / 网络不通) -> 不跳",SYS.CY.red); return false
end
local list=nil
P(function()
local hs=game:GetService("HttpService")
local d=hs and hs:JSONDecode(body)
if d and d.data then list=d.data end
end)
if type(list)~="table" then SYS.Notify("服务器列表解析失败 -> 不跳",SYS.CY.red); return false end
local tried=SYS.HopTried or {} SYS.HopTried=tried
local pick=nil
for _,v in ipairs(list) do
local id=(type(v)=="table") and v.id or nil
local pl=tonumber((type(v)=="table") and v.playing) local mx=tonumber((type(v)=="table") and v.maxPlayers)
if type(id)=="string" and id~=game.JobId and not tried[id] and pl and mx and pl<mx then
pick=id break
end
end
if not pick then SYS.Notify("没有可跳的服务器(都满了 / 都试过了)",SYS.CY.yellow); return false end
tried[pick]=true
SYS._Hopping=true
local url=tostring(SYS.BuildURL or "")
local canReinject=(url:sub(1,4)=="http") and (type(queue_on_teleport)=="function")
if canReinject then
P(function()
queue_on_teleport(('_G.CM_HOPN=%d loadstring(game:HttpGet("%s"))()'):format(n+1,url))
end)
else
SYS.Notify("⚠️ 本地版没有网络地址 -> 跳过去后【脚本不会自动回来】, 要重新执行一次加载器。\n(网络版/加载器版会自动重注入)",SYS.CY.yellow)
end
SYS.Notify(("🚀 跳到下一个服务器找低延迟(第 %d/%d 次) reason=%s"):format(n+1,maxTry,tostring(reason or "")),SYS.CY.cyan)
task.delay(0.8,function() P(function() TS:TeleportToPlaceInstance(game.PlaceId,pick,LP) end) end)
return true
end
function SYS.AutoHopCheck(tag)
if not SYS.T_.AutoLowPing then return end
local limit=tonumber(SYS.C_.HopPingLimit) or 120
local ms=SYS.GetPingMs()
if not ms then return end
if ms>limit then
SYS.Notify(("📡 当前 ping %d ms > 阈值 %d ms -> 自动找低延迟服务器"):format(ms,limit),SYS.CY.yellow)
P(function() SYS.HopLowPing(tag or "auto") end)
else
SYS.Notify(("✅ 当前服务器 ping %d ms, 低于阈值 %d ms, 保持不动"):format(ms,limit),SYS.CY.green)
end
end
local SpectateConn=nil
function SYS.Spectate(pl)
local hum=pl and pl.Character and pl.Character:FindFirstChildOfClass("Humanoid")
local cam=SYS.Cam
if not hum or not cam then SYS.Notify("观战失败: 目标无角色",SYS.CY.red) return end
if SpectateConn then DS(SpectateConn) SpectateConn=nil end
cam.CameraSubject=hum cam.CameraType=Enum.CameraType.Custom
SpectateConn=T(RS.RenderStepped:Connect(function()
local h2=pl and pl.Character and pl.Character:FindFirstChildOfClass("Humanoid")
if not h2 then SYS.StopSpectate() return end
cam.CameraSubject=h2
end))
SYS.Notify("👁 已观战 "..pl.Name,SYS.CY.cyan)
end
function SYS.StopSpectate()
if SpectateConn then DS(SpectateConn) SpectateConn=nil end
P(SYS.ResetCam)
end
function SYS.GameTag()
local pid=tostring(game.PlaceId or 0)
local nm=SYS.C_.GameNameCache
if not nm then
local ok,info=pcall(function()
return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)
if ok and info and info.Name and info.Name~="" then
nm=info.Name
else
nm="Place"..pid
end
SYS.C_.GameNameCache=nm
end
return nm, pid
end
function SYS.GameInfoLine()
local nm,pid=SYS.GameTag()
local gid=tostring(game.GameId or 0)
local jid=tostring(game.JobId or "")
local cid=tostring(game.CreatorId or 0)
return ("游戏: %s | PlaceId: %s | GameId: %s | CreatorId: %s | JobId: %s")
:format(nm,pid,gid,cid,jid), nm, pid
end
local function safeFileName(s)
local r=tostring(s or ""):gsub('[\\/:*?"<>|]',"_")
r=r:gsub("%s+","_")
if #r>40 then r=r:sub(1,40) end
if r=="" then r="unknown" end
return r
end
function SYS.SaveRemotes(found)
if not writefile then return nil end
local info,nm,pid=SYS.GameInfoLine()
local stamp=os.date("%Y%m%d_%H%M")
local fn=("Remotes_%s_%s_%s.txt"):format(safeFileName(nm),safeFileName(pid),stamp)
local buf={}
buf[#buf+1]="-- CheatMenu 抓包清单"
buf[#buf+1]="-- "..info
buf[#buf+1]="-- 时间: "..os.date("%Y-%m-%d %H:%M:%S")
buf[#buf+1]="-- 由 SYS.DumpRemotes() 生成 · 共 "..tostring(#(found or {})).." 条"
buf[#buf+1]=""
for i,r in ipairs(found or {}) do buf[#buf+1]=("  [%d] %s"):format(i,r) end
local ok=P(function() writefile(fn,table.concat(buf,"\n")) end)
return ok and fn or nil
end
function SYS.SaveDump(tag, lines)
if not writefile then return nil end
local info,nm,pid=SYS.GameInfoLine()
local stamp=os.date("%Y%m%d_%H%M%S")
local fn=("%s_%s_%s_%s.txt"):format(safeFileName(tag),safeFileName(nm),safeFileName(pid),stamp)
local buf={
"-- CheatMenu 综合扫描 · "..tostring(tag),
"-- "..info,
"-- 时间: "..os.date("%Y-%m-%d %H:%M:%S"),
"-- 共 "..tostring(#(lines or {})).." 行",
"",
}
for i=1,#(lines or {}) do buf[#buf+1]=tostring(lines[i]) end
local ok=P(function() writefile(fn,table.concat(buf,"\n")) end)
return ok and fn or nil
end
local HudGui, HudLabel, HudHideAt = nil, nil, nil
if RS and RS.Heartbeat then
T(RS.Heartbeat:Connect(function()
if HudHideAt and os.clock() >= HudHideAt then
HudHideAt = nil
P(function() if HudGui then HudGui.Enabled = false end end)
end
end))
end
local function tryMany(kind)
local list = SYS.RemoteAlias[kind] or {}
local okN, hit = 0, {}
for _, n in ipairs(list) do
local r = SYS.REvent(n)
if r then
if P(function() r:FireServer() end) then
okN = okN + 1
hit[#hit + 1] = n
end
end
end
return okN, hit
end
function SYS.ClaimEverything()
local total, names = 0, {}
for _, kind in ipairs({"daily", "mail", "friend", "milestone", "claim", "stall", "loot"}) do
local n, hit = tryMany(kind)
total = total + n
for _, h in ipairs(hit) do names[#names + 1] = h end
end
local msg = ("🎁 一键全领: 发出 %d 条 · %s"):format(total, table.concat(names, ", "):sub(1, 110))
SYS.Notify(msg, total > 0 and SYS.CY.green or SYS.CY.yellow)
SYS.Hud(msg, 7)
return total
end
function SYS.OpenAllBoxes()
local n, hit = tryMany("box")
local msg = ("📦 一键开箱: 发出 %d 条 · %s"):format(n, table.concat(hit, ", "):sub(1, 90))
SYS.Notify(msg, n > 0 and SYS.CY.green or SYS.CY.yellow)
SYS.Hud(msg, 6)
return n
end
function SYS.DumpInventory()
local out = {}
local rel = RStorage:FindFirstChild("Remote")
local got = false
for _, kind in ipairs({"inventory"}) do
for _, n in ipairs(SYS.RemoteAlias[kind] or {}) do
local rel = RStorage:FindFirstChild("Remote")
local rf = rel and rel:FindFirstChild(n, true)
if rf and rf:IsA("RemoteFunction") then
local ok, res = pcall(function() return rf:InvokeServer() end)
if ok and res ~= nil then
out[#out + 1] = "[" .. n .. "] -> " .. tostring(res):sub(1, 800)
got = true
break
end
end
end
end
pcall(function()
local ch = LP.Character
local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
if bp then
local names = {}
for _, t in ipairs(bp:GetChildren()) do
if t:IsA("Tool") then names[#names + 1] = t.Name end
end
out[#out + 1] = ("[背包(本地Tool)] %d 件: %s"):format(#names, table.concat(names, ", "):sub(1, 500))
end
if ch then
local held = ch:FindFirstChildOfClass("Tool")
out[#out + 1] = "[手持] " .. (held and held.Name or "无")
end
for _, g in ipairs(LP.PlayerGui:GetChildren()) do
local ln = string.lower(tostring(g.Name))
if ln:find("backpack") or ln:find("inventory") then
local kids = {}
for _, c in ipairs(g:GetDescendants()) do
if c:IsA("TextLabel") and c.Text and c.Text ~= "" then kids[#kids + 1] = c.Text end
if #kids > 40 then break end
end
out[#out + 1] = ("[%s] %s"):format(g.Name, table.concat(kids, " | "):sub(1, 700))
end
end
end)
if not got then out[#out + 1] = "(服务端没返回背包远程数据, 上面是本地可见的部分)" end
local txt = table.concat(out, "\n")
print("[CheatMenu][背包]\n" .. txt)
SYS.Hud("🎒 背包信息已打到控制台(F9)", 6)
return txt
end
function SYS.DumpServerList()
local out = {}
for _, kind in ipairs({"server"}) do
for _, n in ipairs(SYS.RemoteAlias[kind] or {}) do
local rel = RStorage:FindFirstChild("Remote")
local rf = rel and rel:FindFirstChild(n, true)
if rf and rf:IsA("RemoteFunction") then
local ok, res = pcall(function() return rf:InvokeServer() end)
if ok and res ~= nil then
out[#out + 1] = "[" .. n .. "] -> " .. tostring(res):sub(1, 1200)
end
end
end
end
pcall(function()
for _, g in ipairs(LP.PlayerGui:GetChildren()) do
local ln = string.lower(tostring(g.Name))
if ln:find("server") then
local t = {}
for _, c in ipairs(g:GetDescendants()) do
if c:IsA("TextLabel") and c.Text and c.Text ~= "" then t[#t + 1] = c.Text end
if #t > 60 then break end
end
out[#out + 1] = ("[UI %s] %s"):format(g.Name, table.concat(t, " | "):sub(1, 900))
end
end
end)
local txt = #out > 0 and table.concat(out, "\n") or "(没拿到服务器列表)"
print("[CheatMenu][服务器]\n" .. txt)
SYS.Notify("🖥 服务器列表已打到控制台(F9)", SYS.CY.cyan)
SYS.Hud("🖥 服务器列表见控制台(F9)", 6)
return txt
end
function SYS.JoinNextServer()
for _, n in ipairs({"JoinAny", "JoinLater", "TeleportToServer", "TeleportToJobId"}) do
local r = SYS.REvent(n)
if r then
if P(function() r:FireServer() end) then
SYS.Notify("🖥 已发出换服请求 (" .. n .. ")", SYS.CY.green)
SYS.Hud("🖥 已发出换服请求", 5)
return true
end
end
end
SYS.Notify("⛔ 本游戏没找到换服通道(先跑「读服务器列表」看看)", SYS.CY.yellow)
return false
end
SYS._realClock = SYS._realClock or os.clock
SYS._realTime  = SYS._realTime  or os.time
SYS._timeScale = 1
SYS._timeAcc   = 0
SYS._timeLast  = SYS._realClock()
local _tsHooked = false
function SYS.SetTimeScale(scale)
scale = tonumber(scale) or 1
if scale < 1 then scale = 1 end
if scale > 50 then scale = 50 end
SYS._timeScale = scale
SYS.C_.TimeScale = scale
if scale <= 1 then
SYS.Notify("⏱ 冷却加速: 关", SYS.CY.sub)
SYS.Hud("⏱ 冷却加速已关闭", 4)
return
end
if not _tsHooked then
local rc, rt = SYS._realClock, SYS._realTime
local ok = pcall(function()
os.clock = newcclosure(function()
local real = rc()
local d = real - SYS._timeLast
if d > 0 then
SYS._timeAcc = SYS._timeAcc + d * (SYS._timeScale - 1)
SYS._timeLast = real
end
return real + SYS._timeAcc
end)
os.time = newcclosure(function(...)
return rt(...) + math.floor(SYS._timeAcc)
end)
end)
if not ok then
SYS.Notify("⛔ 本执行器不支持 hook 时间函数, 冷却加速不可用", SYS.CY.yellow)
return
end
_tsHooked = true
end
SYS.Notify(("⏱ 冷却加速: %.1fx (只对客户端判定的冷却有效) "):format(scale), SYS.CY.green)
SYS.Hud(("⏱ 冷却加速 %.1fx 已开"):format(scale), 5)
end
function SYS.ProbeTrapWatch()
local rel = RStorage:FindFirstChild("Remote")
local names = {"TouchDamage","DamageDenyInform","StatusService","PlayState",
"QueryLock","SelectedRole","PreSpawnDarken","HighlightEmote",
"ReName","ResetName","UpdateTradeHighlights"}
local have, miss = {}, {}
for _, nm in ipairs(names) do
local inst = rel and rel:FindFirstChild(nm, true)
if inst then have[#have + 1] = nm .. "(" .. inst.ClassName .. ")"
else miss[#miss + 1] = nm end
end
print(("[CheatMenu] 陷阱/状态信号 有 %d: %s"):format(#have, table.concat(have, ", ")))
print(("[CheatMenu] 陷阱/状态信号 无 %d: %s"):format(#miss, table.concat(miss, ", ")))
SYS.Hud(("信号探测: 有 %d / 无 %d (详见 F9)"):format(#have, #miss), 6)
return have, miss
end
function SYS.UseItem(arg)
local r, nm = SYS.FindEvent("itemuse")
if not r then
SYS.Notify("⛔ 本游戏没找到使用类 remote", SYS.CY.yellow)
SYS.Hud("⛔ 本游戏没找到使用类 remote", 6)
return false
end
local ok = false
if arg ~= nil then
ok = P(function() r:FireServer(arg) end)
if not ok then ok = P(function() r:FireServer(arg.Name) end) end
end
if not ok then ok = P(function() r:FireServer() end) end
local msg = ("🎒 使用道具: %s · remote=%s"):format(tostring(ok), tostring(nm))
SYS.Notify(msg, ok and SYS.CY.green or SYS.CY.yellow)
SYS.Hud(msg, 5)
return ok
end
function SYS.ToggleEquip(on, arg)
local kind = on and "equip" or "unequip"
local r, nm = SYS.FindEvent(kind)
if not r then
local m = ("⛔ 本游戏没找到%s类 remote"):format(on and "装备" or "卸下")
SYS.Notify(m, SYS.CY.yellow)
SYS.Hud(m, 6)
return false
end
local ok = false
if arg ~= nil then
ok = P(function() r:FireServer(arg) end)
if not ok then ok = P(function() r:FireServer(arg.Name) end) end
end
if not ok then ok = P(function() r:FireServer() end) end
local msg = ("⚔ %s: %s · remote=%s"):format(on and "装备" or "卸下", tostring(ok), tostring(nm))
SYS.Notify(msg, ok and SYS.CY.green or SYS.CY.yellow)
SYS.Hud(msg, 5)
return ok
end
function SYS.ClaimAllDaily()
local list = SYS.RemoteAlias.daily or {}
local done, hit = 0, {}
for _, n in ipairs(list) do
local r = SYS.REvent(n)
if r then
local ok = P(function() r:FireServer() end)
if ok then done = done + 1 hit[#hit + 1] = n end
end
end
local msg = ("🎁 一键领取: 命中 %d 条并已发出 · %s"):format(done, table.concat(hit, ", "):sub(1, 100))
SYS.Notify(msg, done > 0 and SYS.CY.green or SYS.CY.yellow)
SYS.Hud(msg, 6)
return done
end
function SYS.FindGrabbables(limit)
limit = limit or 400
local out, seen = {}, {}
pcall(function()
for _, d in ipairs(WS:GetDescendants()) do
if #out >= limit then break end
local cn = d.ClassName
local ok = false
if cn == "ProximityPrompt" or cn == "ClickDetector" then
ok = true
elseif cn == "Tool" then
ok = true
else
local ln = string.lower(tostring(d.Name))
for _, k in ipairs({"drop", "item", "coin", "coin", "loot", "pickup", "collect", "orb", "cash", "scrap"}) do
if ln:find(k, 1, true) then ok = true break end
end
end
if ok and not seen[d] then
seen[d] = true
out[#out+1] = d
end
end
end)
return out
end
function SYS.RangedGrab(mode)
local r, nm = SYS.FindEvent("pickup")
if not r then
SYS.Notify("⛔ 本游戏没找到 pickup/collect 类 remote —— 隔空获取用不了", SYS.CY.yellow)
SYS.Hud("⛔ 本游戏没有可用的拾取 remote", 6)
return 0
end
local list = SYS.FindGrabbables()
if #list == 0 then
SYS.Notify("附近/场景里没找到可拾取物", SYS.CY.yellow)
return 0
end
local targets = list
if mode == "one" then
local mine = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
local best, bestD = nil, math.huge
if mine then
for _, d in ipairs(list) do
local p = d.Position or (d.Parent and d.Parent.Position)
if p then
local dd = (p - mine.Position).Magnitude
if dd < bestD then bestD, best = dd, d end
end
end
end
targets = { best or list[1] }
end
local done = 0
for _, d in ipairs(targets) do
local sent = P(function() r:FireServer(d) end)
if not sent then sent = P(function() r:FireServer(d.Name) end) end
if not sent then sent = P(function() r:FireServer() end) end
if sent then done = done + 1 end
end
local tip = ("🧺 隔空获取(%s): 目标 %d 个 · 已发 %d 次 · remote=%s")
:format(mode == "all" and "全部" or "单独", #targets, done, tostring(nm))
SYS.Notify(tip, done > 0 and SYS.CY.green or SYS.CY.yellow)
SYS.Hud(tip, 6)
return done
end
local HudGui, HudLabel, HudHideAt = nil, nil, nil
function SYS.Hud(text, secs)
secs = tonumber(secs) or 4
P(function()
local pg = (SYS.SafeParentGui and SYS.ScreenGui) or LP:FindFirstChildOfClass("PlayerGui") or LP.PlayerGui
if not pg then return end
if not HudGui then
local gui = Instance.new("ScreenGui")
gui.Name = SYS.N.Hud
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
P(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
local fr = Instance.new("Frame")
fr.Name = "Box"
fr.AnchorPoint = Vector2.new(0.5, 0)
fr.Position = UDim2.new(0.5, 0, 0, 42)
fr.Size = UDim2.new(0, 520, 0, 34)
fr.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
fr.BackgroundTransparency = 0.18
fr.BorderSizePixel = 0
fr.Parent = gui
local r = Instance.new("UICorner")
r.CornerRadius = UDim.new(0, 9)
r.Parent = fr
local lab = Instance.new("TextLabel")
lab.Size = UDim2.new(1, -20, 1, 0)
lab.Position = UDim2.new(0, 10, 0, 0)
lab.BackgroundTransparency = 1
lab.Font = Enum.Font.GothamMedium
lab.TextSize = 15
lab.TextColor3 = Color3.fromRGB(235, 240, 250)
lab.TextXAlignment = Enum.TextXAlignment.Center
lab.TextWrapped = true
lab.Parent = fr
gui.Parent = pg
HudGui, HudLabel = gui, lab
end
HudLabel.Text = tostring(text or "")
HudGui.Enabled = true
HudHideAt = (secs > 0) and (os.clock() + secs) or nil
end)
print("[CheatMenu][HUD] " .. tostring(text))
end
if RS and RS.Heartbeat then
T(RS.Heartbeat:Connect(function()
if HudHideAt and os.clock() >= HudHideAt then
HudHideAt = nil
P(function() if HudGui then HudGui.Enabled = false end end)
end
end))
end
SYS.Scanners = SYS.Scanners or {}
function SYS.RegisterScanner(name, fn, desc)
for _, s in ipairs(SYS.Scanners) do
if s.name == name then
s.fn = fn
s.desc = desc or s.desc
return s
end
end
local s = { name = name, fn = fn, desc = desc or "" }
SYS.Scanners[#SYS.Scanners + 1] = s
return s
end
local function copyText(t)
local fns = { setclipboard, toclipboard, set_clipboard }
for _, f in ipairs(fns) do
if type(f) == "function" then
local ok = pcall(function() f(t) end)
if ok then return true end
end
end
return false
end
function SYS.ScanAll(opts)
opts = opts or {}
local L = {}
local function add(s) L[#L + 1] = s end
add("################  CheatMenu 统一扫描  ################")
add(SYS.GameInfoLine())
add("扫描时间: " .. os.date("%Y-%m-%d %H:%M:%S"))
add(("执行器能力: %s"):format((SYS.Prot and SYS.Prot.CapsText and SYS.Prot.CapsText()) or "?"))
if SYS.Prot and SYS.Prot.SelfAudit then
local ok2,lines=pcall(SYS.Prot.SelfAudit)
if ok2 and type(lines)=="table" then
for _,l in ipairs(lines) do add(l) end
end
end
add("")
local ran, skipped = 0, 0
for _, s in ipairs(SYS.Scanners) do
add(("---------- [%d] %s ----------"):format(#L, tostring(s.name)))
local ok, res = pcall(s.fn)
if ok then
ran = ran + 1
if type(res) == "table" then
for _, line in ipairs(res) do add(tostring(line)) end
elseif type(res) == "string" then
for line in tostring(res):gmatch("[^\n]+") do add(line) end
else
add("(无输出)")
end
else
skipped = skipped + 1
add("!! 该项失败: " .. tostring(res))
end
add("")
end
local txt = table.concat(L, "\n")
local expected = #L
local actual = select(2, txt:gsub("\n", "\n")) + 1
add("=======================================================")
add(("扫描项 %d 个(成功 %d / 失败 %d) · 行数自检 %d/%d %s")
:format(#SYS.Scanners, ran, skipped, expected, actual,
expected == actual and "一致 ✓" or "!! 不一致(有内容丢失)"))
txt = table.concat(L, "\n")
print(txt)
local fn = nil
if opts.file ~= false and writefile then
local mm, pid = SYS.GameTag()
local safe = function(s) return (tostring(s or ""):gsub('[\\/:*?"<>|]', "_")) end
fn = ("Scan_%s_%s_%s.txt"):format(safe(mm), safe(pid), os.date("%Y%m%d_%H%M"))
if not P(function() writefile(fn, txt) end) then fn = nil end
end
local copied = false
if opts.copy ~= false then copied = copyText(txt) end
local msg = ("🔍 扫描完成: %d 项 · %d 行%s%s")
:format(#SYS.Scanners, actual,
fn and (" · 已存 " .. fn) or " · 未存文件",
copied and " · 已复制到剪贴板" or " · 未复制")
SYS.Notify(msg, SYS.CY.green)
SYS.Hud(msg, 8)
return txt, fn, copied
end
SYS.RegisterScanner("游戏信息 / 执行器能力", function()
return {
"（见头部）",
}
end)
SYS.RegisterScanner("功能可用性总表 (每类事件在当前游戏有没有)", function()
local out = {}
local kinds = {}
for k in pairs(SYS.RemoteAlias or {}) do kinds[#kinds + 1] = k end
table.sort(kinds)
for _, k in ipairs(kinds) do
local r, nm, how = SYS.FindEvent(k)
local list = SYS.RemoteAlias[k] or {}
out[#out + 1] = ("  %-10s %s   候选%d个%s"):format(
k,
r and ("✅ " .. tostring(nm) .. " [" .. tostring(how) .. "]") or "❌ 无",
#list,
r and "" or ("   试过: " .. table.concat(list, "/"):sub(1, 90)))
end
return out
end)
SYS.RegisterScanner("陷阱 / 状态 / 锁定信号", function()
local have, miss = SYS.ProbeTrapWatch()
return { "有: " .. table.concat(have, ", "), "无: " .. table.concat(miss, ", ") }
end)
SYS.RegisterScanner("场景可拾取物", function()
local l = SYS.FindGrabbables()
local out = { ("共 %d 个"):format(#l) }
for i, d in ipairs(l) do
if i > 40 then out[#out + 1] = "  ... 还有 " .. (#l - 40) .. " 个" break end
out[#out + 1] = ("  %-28s %s"):format(tostring(d.Name):sub(1, 28), tostring(d.ClassName))
end
return out
end)
SYS.RegisterScanner("自动躲避状态 (扫到几个机关 / 躲了几次)", function()
local st = SYS._dodgeStat or {n=0, hits=0}
local out = {
("扫到机关部件: %s 个"):format(tostring(st.n)),
("躲避已触发  : %s 次"):format(tostring(st.hits)),
("扫描间隔    : 2 秒   |   触发距离: %.0f 格"):format(tonumber(SYS.C_.DodgeDist) or 15),
("开关状态    : %s"):format(SYS.T_.AutoDodge and "已开" or "关"),
"判据: 名字含 trap/hazard/spike/lava/fire/burn/acid/poison/mine/bomb/地雷/炸弹/机关/陷阱/刺… 或带 HingeConstraint/Motor6D",
}
local l = SYS._dodgeList or {}
if #l == 0 then
out[#out+1] = "(当前没扫到机关 —— 这局可能没有可判定的陷阱, 或名字不在判据里)"
else
out[#out+1] = ("被判为机关的前 %d 个:"):format(math.min(#l, 12))
for i = 1, math.min(#l, 12) do
local x = l[i]
if x and x.Parent then
out[#out+1] = ("   %s   %s"):format(tostring(x.Name), tostring(x:GetFullName()))
end
end
end
return out
end)
SYS.RegisterScanner("Remote 总量统计", function()
local rel = RStorage:FindFirstChild("Remote")
local c = {}
if rel then
pcall(function()
for _, d in ipairs(rel:GetDescendants()) do
local cn = d.ClassName
c[cn] = (c[cn] or 0) + 1
end
end)
end
local out = {}
for k, v in pairs(c) do out[#out + 1] = ("  %-24s %d"):format(k, v) end
table.sort(out)
return out
end)
SYS.RegisterScanner("反作弊模块痕迹 (客户端可见部分)", function()
local L = {}
local function add(s) L[#L + 1] = tostring(s) end
local function nmOf(o)
local ok, v = P(function() return tostring(o.Name) end)
return (ok and type(v) == "string") and v or ""
end
local function pathOf(o)
local ok, v = P(function() return o:GetFullName() end)
return (ok and type(v) == "string") and v or "?"
end
local KW = {"anticheat","anti_cheat","anti-cheat","antiexploit","exploit","guard","moderation",
"detect","sanit","validate","verify","integrity","suspicious","speedhack","flyhack",
"cheat","hack","ban","kick","反作弊","检测","校验","拦截","封禁"}
local function hitKW(nm)
local ln = string.lower(nm)
for i = 1, #KW do if string.find(ln, KW[i], 1, true) then return KW[i] end end
return nil
end
add("① 名字含反作弊关键词的实例:")
local roots = {}
for _, sn in ipairs({"ReplicatedStorage","ReplicatedFirst","Workspace","Lighting","StarterGui","StarterPlayer","Players"}) do
local ok, v = P(function() return game:GetService(sn) end)
if ok and v then roots[#roots + 1] = v end
end
if LP then
for _, cn in ipairs({"PlayerGui","PlayerScripts","Backpack"}) do
local ok, v = P(function() return LP:FindFirstChild(cn) end)
if ok and v then roots[#roots + 1] = v end
end
end
local n1 = 0
for r = 1, #roots do
local ok, ds = P(function() return roots[r]:GetDescendants() end)
if ok and type(ds) == "table" then
for i = 1, #ds do
local o = ds[i]
local nm = nmOf(o)
local k = hitKW(nm)
if k then
local cl = ""
P(function() cl = tostring(o.ClassName) end)
add(("   [%s] %s   <- 命中 \"%s\"   %s"):format(cl, nm, k, pathOf(o)))
n1 = n1 + 1
if n1 > 60 then add("   ...(超过 60 条, 先列这些)") break end
end
end
end
end
if n1 == 0 then
add("   (客户端可见范围内没扫到名字可疑的实例 —— 反作弊很可能【全在服务端】, 客户端这边看不到)")
end
add("")
add("② 像「位置上报 / 校验」的 Remote (位置被回退时, 优先怀疑它们):")
local P2 = {"position","cframe","move","movement","sync","update","pos","velocity","speed",
"teleport","tp","distance","walk","humanoid","character","report","heartbeat"}
local n2 = 0
local okr, rs = P(function() return game:GetService("ReplicatedStorage") end)
if okr and rs then
local okd, ds = P(function() return rs:GetDescendants() end)
if okd and type(ds) == "table" then
for i = 1, #ds do
local o = ds[i]
local cl = ""
P(function() cl = tostring(o.ClassName) end)
if cl == "RemoteEvent" or cl == "RemoteFunction" or cl == "UnreliableRemoteEvent" then
local ln = string.lower(nmOf(o))
for q = 1, #P2 do
if string.find(ln, P2[q], 1, true) then
add(("   [%s] %s   %s"):format(cl, nmOf(o), pathOf(o)))
n2 = n2 + 1
break
end
end
end
if n2 > 60 then break end
end
end
end
if n2 == 0 then add("   (没扫到 —— 位置校验可能用别的命名, 或直接在服务端做校验)") end
add("")
add("③ 已加载的模块脚本:")
if type(getloadedmodules) == "function" then
local okm, mods = P(getloadedmodules)
if okm and type(mods) == "table" then
add(("   共 %d 个已加载模块"):format(#mods))
local n3 = 0
for i = 1, #mods do
local o = mods[i]
local nm = nmOf(o)
local k = hitKW(nm)
if k then add(("   %s   <- 命中 \"%s\"   %s"):format(nm, k, pathOf(o))) n3 = n3 + 1 end
end
if n3 == 0 then add("   (模块名里没有可疑关键词)") end
else
add("   (getloadedmodules() 没返回表)")
end
else
add("   (这台执行器没有 getloadedmodules)")
end
return L
end)
function SYS.DumpRemotes()
local counts={RE=0,RF=0,BE=0,BF=0,PP=0,CD=0}
local found={} local seen={}
local function scan(container,path,depth)
if not container or depth>7 then return end
pcall(function()
for _,child in ipairs(container:GetChildren()) do
local p=path.."."..child.Name
local cls=child.ClassName
local tag=nil
if cls=="RemoteEvent" then tag="RemoteEvent" counts.RE+=1
elseif cls=="RemoteFunction" then tag="RemoteFunction" counts.RF+=1
elseif cls=="BindableEvent" then tag="BindableEvent" counts.BE+=1
elseif cls=="BindableFunction" then tag="BindableFunction" counts.BF+=1
elseif cls=="ProximityPrompt" then tag="ProximityPrompt" counts.PP+=1
elseif cls=="ClickDetector" then tag="ClickDetector" counts.CD+=1
end
if tag and not seen[p] then
seen[p]=true
found[#found+1]=tag.."  "..p
end
scan(child,p,depth+1)
end
end)
end
pcall(function() scan(RStorage,"ReplicatedStorage",0) end)
pcall(function() scan(WS,"Workspace",0) end)
pcall(function() scan(LP.PlayerGui,"PlayerGui",0) end)
pcall(function() scan(LP,"LocalPlayer",0) end)
pcall(function() scan(game:GetService("StarterGui"),"StarterGui",0) end)
pcall(function()
local cg=game:GetService("CoreGui")
if cg then scan(cg,"CoreGui",0) end
end)
table.sort(found)
local info,nm,fn_hint=SYS.GameInfoLine()
print("[Remote] ===== "..info.." =====")
print("[Remote] 抓包时间: "..os.date("%Y-%m-%d %H:%M:%S"))
print(("[Remote] ===== 全方位扫描: 网络 RemoteEvent %d + RemoteFunction %d | 本地 BindableEvent %d + BindableFunction %d | 交互 ProximityPrompt %d + ClickDetector %d =====")
:format(counts.RE,counts.RF,counts.BE,counts.BF,counts.PP,counts.CD))
for i,r in ipairs(found) do print("  ["..i.."] "..r) end
print("[Remote] 扫描完成, 清单在上面")
local savedFn=SYS.SaveRemotes(found)
if savedFn then
print("[Remote] ✅ 已保存: "..savedFn.."   （即工作目录）")
else
print("[Remote] (这台执行器不能写文件, 请手动复制上面的清单; 建议文件名带上游戏名)")
end
SYS.Notify(savedFn
and (("扫描完成: 网络 %d · 本地 %d · 交互 %d → 已存 %s")
:format(counts.RE+counts.RF,counts.BE+counts.BF,counts.PP+counts.CD,savedFn))
or (("扫描完成: 网络 %d · 本地 %d · 交互 %d (看控制台)")
:format(counts.RE+counts.RF,counts.BE+counts.BF,counts.PP+counts.CD)),
SYS.CY.cyan)
return found, savedFn
end
local NCConns={}
local NCCache=setmetatable({},{__mode="k"})
local NCByPlayer=setmetatable({},{__mode="k"})
local function CacheParts(p)
if p==LP or not p.Character then return end
local t={}
for _,pt in ipairs(p.Character:GetDescendants()) do
if pt:IsA("BasePart") then table.insert(t,pt) end
end
NCCache[p]=t
end
function SYS.TrackCollide(p)
if p==LP then return end
local function handle(ch)
CacheParts(p)
if SYS.T_.NoCollide then
task.wait(0.2)
local t=NCCache[p]
if t then for _,pt in ipairs(t) do if pt.Parent then pt.CanCollide=false end end end
end
end
if p.Character then handle(p.Character) end
local conn=p.CharacterAdded:Connect(handle)
table.insert(NCConns,conn)
NCByPlayer[p]=conn
end
T(Players.PlayerRemoving:Connect(function(p)
local conn=NCByPlayer[p]
if conn then
pcall(function() conn:Disconnect() end)
NCByPlayer[p]=nil
for i,c in ipairs(NCConns) do
if c==conn then table.remove(NCConns,i) break end
end
end
NCCache[p]=nil
end))
function SYS.RefreshNC(on)
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP then
local t=NCCache[p]
if not t then CacheParts(p) t=NCCache[p] end
if t then for _,pt in ipairs(t) do if pt.Parent then pt.CanCollide=not on end end end
end
end
end
SYS.NCConns=NCConns
end
do
local Bk,All,Set,Cull,Active={},{},{},1,false
local AnimStopped={} local SoundBk={} local Conns={}
local KW={"effect","vfx","hitbox","damage","skill","impact","explosion","spark",
"slash","aura","beam","flash","projectile","bullet","missile","shockwave",
"particle","trail","smoke","fire","flame","glow","neon","energy","magic",
"特效","技能","伤害","爆炸","火花","治疗"}
local function NameKW(n) n=n:lower() for i=1,#KW do if n:find(KW[i],1,true) then return true end end return false end
local function IsVFX(p)
if NameKW(p.Name) then return true end
local par,d=p.Parent,0
while par and d<3 do
if NameKW(par.Name) then return true end
par=par.Parent d=d+1
end
return false
end
local function BkProp(o,k)
if not o then return end
local t=Bk[o] if not t then t={} Bk[o]=t end
if t[k]==nil then local ok,v=pcall(function() return o[k] end) if ok then t[k]=v end end
end
local function StripTexture(o)
if not o then return end
if o:IsA("MeshPart") then
pcall(function()
if o.TextureID and o.TextureID~="" then
BkProp(o,"TextureID") o.TextureID=""
end
end)
if o.RenderFidelity~=Enum.RenderFidelity.Performance then
BkProp(o,"RenderFidelity") o.RenderFidelity=Enum.RenderFidelity.Performance
end
end
if o:IsA("SpecialMesh") then
pcall(function()
if o.TextureId and o.TextureId~="" then
BkProp(o,"TextureId") o.TextureId=""
end
end)
end
if o:IsA("SurfaceAppearance") then
pcall(function()
if o.TexturePack and o.TexturePack~="" then BkProp(o,"TexturePack") o.TexturePack="" end
if o.ColorMap and o.ColorMap~="" then BkProp(o,"ColorMap") o.ColorMap="" end
if o.NormalMap and o.NormalMap~="" then BkProp(o,"NormalMap") o.NormalMap="" end
if o.RoughnessMap and o.RoughnessMap~="" then BkProp(o,"RoughnessMap") o.RoughnessMap="" end
if o.MetalnessMap and o.MetalnessMap~="" then BkProp(o,"MetalnessMap") o.MetalnessMap="" end
end)
end
if o:IsA("Decal") or o:IsA("Texture") then
pcall(function()
if o.Texture and o.Texture~="" then BkProp(o,"Texture") o.Texture="" end
end)
if o.Transparency<1 then BkProp(o,"Transparency") o.Transparency=1 end
end
if o:IsA("Sky") then
pcall(function()
if o.SkyboxBk and o.SkyboxBk~="" then BkProp(o,"SkyboxBk") o.SkyboxBk="" end
if o.SkyboxDn and o.SkyboxDn~="" then BkProp(o,"SkyboxDn") o.SkyboxDn="" end
if o.SkyboxFt and o.SkyboxFt~="" then BkProp(o,"SkyboxFt") o.SkyboxFt="" end
if o.SkyboxLf and o.SkyboxLf~="" then BkProp(o,"SkyboxLf") o.SkyboxLf="" end
if o.SkyboxRt and o.SkyboxRt~="" then BkProp(o,"SkyboxRt") o.SkyboxRt="" end
if o.SkyboxUp and o.SkyboxUp~="" then BkProp(o,"SkyboxUp") o.SkyboxUp="" end
BkProp(o,"StarCount") o.StarCount=0
BkProp(o,"SunAngularSize") o.SunAngularSize=0
BkProp(o,"MoonAngularSize") o.MoonAngularSize=0
end)
end
if o:IsA("ImageHandleAdornment") then
pcall(function() if o.Image and o.Image~="" then BkProp(o,"Image") o.Image="" end end)
end
end
local function Simple(o)
P(function()
if CoreGui and o:IsDescendantOf(CoreGui) then return end
local ch=LP.Character local mine=ch and o:IsDescendantOf(ch)
StripTexture(o)
if o:IsA("BasePart") then
if not mine then
if o.CastShadow then BkProp(o,"CastShadow") o.CastShadow=false end
if o.Reflectance>0 then BkProp(o,"Reflectance") o.Reflectance=0 end
local m=o.Material
if m==Enum.Material.Water or m==Enum.Material.ForceField
or m==Enum.Material.Glass or m==Enum.Material.Neon
or m==Enum.Material.Ice or m==Enum.Material.Foil
or m==Enum.Material.Marble or m==Enum.Material.Granite
or m==Enum.Material.Pebble or m==Enum.Material.Sand
or m==Enum.Material.Slate or m==Enum.Material.Rock then
BkProp(o,"Material") o.Material=Enum.Material.SmoothPlastic
end
if IsVFX(o) then
o:SetAttribute("__Hide","vfx")
BkProp(o,"LocalTransparencyModifier") o.LocalTransparencyModifier=1
end
for _,c in ipairs(o:GetChildren()) do
if c:IsA("Sound") and c.Playing then
if not SoundBk[c] then SoundBk[c]=true end
c.Playing=false
end
end
end
elseif o:IsA("Explosion") then
if o.BlastRadius>5 then BkProp(o,"BlastRadius") o.BlastRadius=5 end
if o.BlastPressure>1 then BkProp(o,"BlastPressure") o.BlastPressure=1 end
elseif o:IsA("ParticleEmitter") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then
if o.Enabled then BkProp(o,"Enabled") o.Enabled=false end
elseif o:IsA("PointLight") or o:IsA("SpotLight") or o:IsA("SurfaceLight") then
if o.Enabled then BkProp(o,"Enabled") o.Enabled=false end
elseif o:IsA("Trail") or o:IsA("Beam") then
if o.Enabled then BkProp(o,"Enabled") o.Enabled=false end
elseif o:IsA("Atmosphere") then
BkProp(o,"Density") o.Density=0
BkProp(o,"Haze") o.Haze=0
BkProp(o,"Glare") o.Glare=0
elseif o:IsA("Clouds") then
BkProp(o,"Cover") o.Cover=0
BkProp(o,"Density") o.Density=0
elseif o:IsA("BloomEffect") or o:IsA("BlurEffect") or o:IsA("SunRaysEffect")
or o:IsA("ColorCorrectionEffect") or o:IsA("DepthOfFieldEffect") then
if o.Enabled then BkProp(o,"Enabled") o.Enabled=false end
end
end)
end
local function Track(p)
if not p:IsA("BasePart") then return end
if Set[p] then return end
table.insert(All,p) Set[p]=#All
end
local function Scan()
local ok,list=pcall(function() return WS:GetDescendants() end)
if ok and type(list)=="table" then
local n=0
for _,o in ipairs(list) do
if not Active then break end
Simple(o) Track(o) n+=1
if n%800==0 then task.wait() end
end
end
if LT then
local ok2,lt=pcall(function() return LT:GetDescendants() end)
if ok2 and type(lt)=="table" then
for _,o in ipairs(lt) do Simple(o) end
end
pcall(function()
BkProp(LT,"GlobalShadows") LT.GlobalShadows=false
BkProp(LT,"FogEnd") LT.FogEnd=1e9 BkProp(LT,"FogStart") LT.FogStart=1e6
BkProp(LT,"EnvironmentDiffuseScale") LT.EnvironmentDiffuseScale=0
BkProp(LT,"EnvironmentSpecularScale") LT.EnvironmentSpecularScale=0
BkProp(LT,"ShadowSoftness") LT.ShadowSoftness=0
BkProp(LT,"Technology") LT.Technology=Enum.Technology.Compatibility
pcall(function()
local MS=game:GetService("MaterialService")
if MS and MS.Use2022Materials~=nil then MS.Use2022Materials=false end
end)
end)
end
pcall(function()
if settings and settings().Rendering then
settings().Rendering.QualityLevel=Enum.QualityLevel.Level01
end
end)
pcall(function()
local US=UserSettings and UserSettings()
if US then
local UGS=US:GetService("UserGameSettings")
if UGS then UGS.SavedQualityLevel=0 end
end
end)
print("[Perf] 扫描完成 (含纹理降级)")
end
local function Restore()
local n=0
for o,ps in pairs(Bk) do
if o and o.Parent then
pcall(function()
for k,v in pairs(ps) do o[k]=v end
o:SetAttribute("__Hide",nil)
o:SetAttribute("__Culled",nil)
end)
end
n=n+1
if n%1000==0 then task.wait() end
end
for s,_ in pairs(SoundBk) do pcall(function() if s and s.Parent then s.Playing=true end end) end
Bk={} All={} Set={} Cull=1 AnimStopped={} SoundBk={}
pcall(function()
if settings and settings().Rendering then
settings().Rendering.QualityLevel=Enum.QualityLevel.Level07
end
end)
pcall(function()
local MS=game:GetService("MaterialService")
if MS then MS.Use2022Materials=true end
end)
end
local function CullTick()
if not Active then return end
local _,_,root=GC() if not root then return end
local m=SYS.C_.PerfCull*SYS.C_.PerfCull
local tot=#All if tot==0 then return end
for _=1,math.min(48,tot) do
Cull=Cull%tot+1
local p=All[Cull]
if not p or not p.Parent then
if p then Set[p]=nil end
elseif not p:GetAttribute("__Hide") then
local dx=p.Position.X-root.Position.X
local dy=p.Position.Y-root.Position.Y
local dz=p.Position.Z-root.Position.Z
if dx*dx+dy*dy+dz*dz>m then
if not p:GetAttribute("__Culled") then
p:SetAttribute("__Culled",true)
BkProp(p,"LocalTransparencyModifier") p.LocalTransparencyModifier=1
end
elseif p:GetAttribute("__Culled") then
local bk=Bk[p] local o=bk and bk.LocalTransparencyModifier
p.LocalTransparencyModifier=o~=nil and o or 0
p:SetAttribute("__Culled",nil)
end
end
end
end
local function StopAnim()
for _,pl in ipairs(Players:GetPlayers()) do
if pl~=LP then
local c=pl.Character
if c then
local h=c:FindFirstChildOfClass("Humanoid")
if h and not AnimStopped[h] then
local a=h:FindFirstChildOfClass("Animator")
if a then P(function() for _,t in ipairs(a:GetPlayingAnimationTracks()) do t:Stop(0) end end) end
AnimStopped[h]=true
end
end
end
end
end
function SYS.SetPerf(on)
for _,c in ipairs(Conns) do DS(c) end
Conns={}
if not on then
Active=false Restore() print("[Perf] 帧率优化已关闭") return
end
Active=true
task.spawn(function() P(Scan) end)
table.insert(Conns,WS.DescendantAdded:Connect(function(o)
if not Active then return end
Simple(o) Track(o)
end))
table.insert(Conns,WS.DescendantRemoving:Connect(function(o)
if Bk[o] then Bk[o]=nil end
local idx=Set[o]
if idx then
local last=All[#All]
All[idx]=last
if last then Set[last]=idx end
All[#All]=nil
Set[o]=nil
end
end))
if LT then
table.insert(Conns,LT.DescendantAdded:Connect(function(o)
if Active then Simple(o) end
end))
end
table.insert(Conns,task.spawn(function()
while Active and not SYS.Unloaded do task.wait(1.5) if Active then P(StopAnim) end end
end))
print("[Perf] 帧率优化已开启 (含纹理降级)")
end
SYS.PerfCullTick=CullTick
function SYS.ClearPerfConns() for _,c in ipairs(Conns) do DS(c) end Conns={} end
end
do
local AFKConn
function SYS.enableAntiAFK()
if AFKConn then AFKConn:Disconnect() end
AFKConn=LP.Idled:Connect(function()
if VirtualUser then
pcall(function() VirtualUser:CaptureController() end)
pcall(function() VirtualUser:ClickButton2(Vector2.new(0,0)) end)
end
end)
SYS.SetLoop("AntiAFKBeat",true,RS.Heartbeat,function()
if SYS.T_.AntiAFK~=true then return end
local now=os.clock()
if now-(SYS._afkAt or 0)<5 then return end
SYS._afkAt=now
P(function()
if LP.SetAttribute then LP:SetAttribute("Heartbeat",math.floor(now*1000)) end
end)
P(function()
local _,hum,root=GC()
if not (hum and root) then return end
local v=root.AssemblyLinearVelocity
if v and v.Magnitude<1 then hum.Jump=true end
end)
end)
end
function SYS.disableAntiAFK()
if AFKConn then AFKConn:Disconnect() AFKConn=nil end
SYS.SetLoop("AntiAFKBeat",false)
end
local HL,LB,HB={},{},{}
local HN={} SYS._npcList=nil SYS._npcN=0
local HP={} SYS._pickList=nil SYS._pickN=0
local HD={} SYS._doorList=nil SYS._doorN=0
local HD_SK={}
local HM={} SYS._miniList=nil SYS._miniN=0
local LBL={}
local HI={}
local LW,LWL={},{}
local ESP_WALL_CACHE=setmetatable({},{__mode="k"})
local function espWall(part)
if not part then return false end
local cam=SYS.Cam if not cam or not cam.CFrame then return false end
local now=os.clock()
local c=ESP_WALL_CACHE[part]
if c and now-c.t<0.2 then return c.ok end
local o=cam.CFrame.Position
local d=part.Position-o
local ok=false
if d.Magnitude>1 then
local _,hit=P(function()
return WS:FindPartOnRay(Ray.new(o,d.Unit*(d.Magnitude-1)),SYS.LP.Character)
end)
ok=not (hit==nil or (part.Parent and hit:IsDescendantOf(part.Parent)))
end
ESP_WALL_CACHE[part]={t=now,ok=ok}
return ok
end
local IDX={ t=0, desc=nil }
function SYS.Index()
local now=os.clock()
if IDX.desc and (now-IDX.t)<0.4 then return IDX.desc end
local ok,d=P(function() return WS:GetDescendants() end)
if ok and type(d)=="table" and #d>0 then
IDX.desc=d IDX.t=now
return d
end
return IDX.desc or {}
end
function SYS.IndexDrop() IDX.desc=nil IDX.t=0 end
SYS.MiniArea = {"duck hunt","duckhunt","chisel","gauntlet","rightofway","blindout","crushhour",
"bumpermadness","mppadhost","mpstation","machin"}
SYS.MiniAreaCN = {"小游戏","关卡","模式"}
SYS.KwHazard = {"door","gate","trap","trapdoor","hatch","portal","hazard","damage","damaging","kill","lava",
"spike","spikes","pit","void","saw","blade","crusher","crush","piston","hammer","press",
"fire","burn","acid","poison","zap","electric","deadly","spider","rig","bumper","chisel","gauntlet",
"obstacle","mine","landmine","bomb","tnt","explosive"}
SYS.KwGateExtra = {"exit","entrance","entry","doorway","doorframe","threshold","archway","passage","corridor",
"tunnel","stairs","stair","elevator","lift","teleport","warp","fake","decoy","false",
"trick","danger","death","fatal","hurt","ouch"}
SYS.KwGate = {}
for _,w in ipairs(SYS.KwHazard)    do SYS.KwGate[#SYS.KwGate+1]=w end
for _,w in ipairs(SYS.KwGateExtra) do SYS.KwGate[#SYS.KwGate+1]=w end
SYS.KwGateCN = {"门","陷阱","机关","刺","熔岩","伤害","危险","地雷","炸弹","关卡","考验",
"出口","入口","传送","电梯","楼梯","假门","伪装","死亡","致死","致命","坑"}
SYS.KwTrap = {"trap","trapdoor","hazard","damage","damaging","kill","lava","spike","pit","void","saw",
"blade","crusher","crush","piston","hammer","press","fire","burn","acid","poison",
"zap","electric","deadly","mine","landmine","bomb","tnt","explosive",
"fake","dupe","false","danger","death","fatal","hurt","ouch"}
SYS.KwTrapCN = {"陷阱","机关","刺","熔岩","伤害","危险","地雷","炸弹","假门","伪装","致死","致命","坑"}
SYS.KwCut = {"chisel","gauntlet","cut","slice","sliceable","grind","machin"}
SYS.KwMpExtra = {"mpbuy","limiteddrop","mpstation","mppadhost"}
SYS.KwHidePick   = {"hide","hiding","wardrobe","closet","drawer","undercouch","locker","cabinet","chest",
"躲","藏身","衣柜","抽屉"}
SYS.KwHidePrompt = {"hide","hiding","hideprompt","closet","wardrobe","bed","locker","cabinet",
"藏身","躲","衣柜","床","柜"}
SYS.KwClue = {"book","bookshelf","shelf","journal","note","notepad","paper","page","diary","library",
"lore","hint","clue","code","password","passcode","padlock","combination","document",
"letter","scroll","manual","guide","poster","painting","portrait","puzzle","riddle","sign",
"livehint","libraryhint","librarybook","hintbook","hintpaper",
"书","笔记","纸","页","日记","图书","线索","密码","提示","文件","信","画","牌"}
SYS.KwClueText = {"hint","librarybook","note","paper","book"}
function SYS.ESPAnyOn()
return SYS.T_.ESP or SYS.T_.ESPNameTag or SYS.T_.ESPWeapon
or SYS.T_.ESPItem or SYS.T_.ESP_Pick or SYS.T_.ESP_Door
or SYS.T_.ESP_NPC or SYS.T_.ESP_Mini or false
end
function SYS.ESPMaybeClear()
if not SYS.ESPAnyOn() then SYS.ClearESP() end
end
function SYS.ClearESP()
for _,h in pairs(HN) do if h then h:Destroy() end end
HN={} SYS._npcList=nil
for _,h in pairs(HP) do if h then h:Destroy() end end
HP={} SYS._pickList=nil
for _,h in pairs(HD) do if h then h:Destroy() end end
HD={} SYS._doorList=nil
for _,s in pairs(HD_SK) do if s then s:Destroy() end end
HD_SK={}
for _,h in pairs(HM) do if h then h:Destroy() end end
HM={} SYS._miniList=nil
for _,h in pairs(HL) do if h then h:Destroy() end end
for _,l in pairs(LB) do if l then l:Destroy() end end
for _,b in pairs(HB) do if b then b:Destroy() end end
for _,h in pairs(HI) do if h then h:Destroy() end end
for _,l in pairs(LW) do if l then l:Destroy() end end
HL,LB,HB,LBL={},{},{},{}
HI={}
LW,LWL={},{}
end
function SYS.ESPTick()
if SYS.T_.ESPWeapon and not SYS.T_.ESPNameTag then SYS.T_.ESPNameTag=true end
if not SYS.ESPAnyOn() then
SYS.ClearESP()
return
end
local function tagPart(c)
return c:FindFirstChild("Head")
or c:FindFirstChild("UpperTorso")
or c:FindFirstChild("Torso")
or c:FindFirstChild("HumanoidRootPart")
end
local act={}
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP then
local c=p.Character
if c and tagPart(c) then
local h=c:FindFirstChildOfClass("Humanoid")
act[p]=c
end
end
end
if SYS.T_.ESP then
for p,h in pairs(HL) do
if not act[p] or h.Adornee~=act[p] then
P(function() h:Destroy() end) HL[p]=nil
end
end
for p,c in pairs(act) do
local h=HL[p]
if not h then
h=Instance.new("Highlight")
h.Adornee=c
h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
h.FillTransparency=0.88
h.OutlineTransparency=0
h.Parent=c
HL[p]=h
elseif h.Parent~=c then
P(function() h.Parent=c end)
end
local team=false
local function ateam(pp)
for _,k in ipairs({"Team","MPTeam","MPTeamId","team","MPFaction","MPSide"}) do
local ok,v=pcall(function() return pp:GetAttribute(k) end)
if ok and v~=nil and tostring(v)~="" then return tostring(v) end
end
local ok2,nm=pcall(function() return pp.Team and pp.Team.Name end)
if ok2 and nm and nm~="" then return nm end
return nil
end
local mt=ateam(LP) local pt=ateam(p)
team=not (mt and pt and mt~=pt)
local ghost=false
if type(p.GetAttribute)=="function" then
P(function()
if p:GetAttribute("MPGhost")==true then ghost=true return end
local KEYS={"Ghost","IsGhost","Invisible","IsInvisible","Stealth","IsStealth",
"Hidden","IsHidden","Vanish","Vanished","Phantom","InvisibleMode",
"GhostMode","Cloak","Cloaked","Camouflage","ShadowMode"}
for i=1,#KEYS do
local ok,v=pcall(function() return p:GetAttribute(KEYS[i]) end)
if ok and v==true then ghost=true return end
end
end)
P(function()
if ghost then return end
local ch2=p.Character
if not ch2 then return end
local tot,n=0,0
for _,d in ipairs(ch2:GetChildren()) do
if d:IsA("BasePart") then
tot=tot+1
if (d.Transparency or 0)>0.6 then n=n+1 end
end
end
if tot>=3 and n/tot>=0.7 then ghost=true end
end)
end
local wall=espWall(tagPart(c) or c.PrimaryPart)
local fillT=wall and 0.93 or 0.88
h.FillTransparency=fillT
if ghost then
h.FillColor   =Color3.fromRGB(190,60,255)
h.OutlineColor=Color3.fromRGB(160,40,230)
else
h.FillColor   = team and Color3.fromRGB(0,255,90)  or Color3.fromRGB(255,40,50)
h.OutlineColor= team and Color3.fromRGB(0,210,70)  or Color3.fromRGB(255,20,30)
end
h.OutlineTransparency=0
end
if not SYS._ESPLogged then
SYS._ESPLogged=true
local _espN=0 for _ in pairs(act) do _espN=_espN+1 end
print(("[ESP] 人物高亮=Highlight %d 个 · 挂点=角色模型"):format(_espN))
end
else
if next(HL) then for _,h in pairs(HL) do h:Destroy() end HL={} end
if next(HB) then for _,b in pairs(HB) do b:Destroy() end HB={} end
end
if SYS.T_.ESP_NPC then
SYS._npcN=(SYS._npcN or 0)+1
local _now=os.clock()
if (SYS._npcN%25==1 and (not SYS._npcAt or _now-SYS._npcAt>1)) or not SYS._npcList then
SYS._npcAt=_now
local list={}
local HOST_KW={"monster","enemy","hostile","killer","kill","attack","aggro","boss","guard",
"zombie","mob","hunter","stalker","chaser","demon","ghoul","skeleton","brute",
"seek","rush","ambush","figure","halt","screech","eyes","dupe","snare","spider",
"jumpscare","cursed","glitch","entity"}
local HOST_CN={"怪","敌","杀手","恶魔","猎","鬼","僵尸","追","凶"}
local HOST={}
local function isHostile(m)
for _,k in ipairs({"Hostile","Enemy","IsEnemy","Aggro","Dangerous","Killer"}) do
local ok,v=pcall(function() return m:GetAttribute(k) end)
if ok and v==true then return true end
end
local anc=m
for _=1,4 do
if not anc then break end
local raw=anc.Name
if type(raw)=="string" and raw~="" then
local nm=raw:lower()
for _,kw in ipairs(HOST_KW) do if nm:find(kw,1,true) then return true end end
for _,cw in ipairs(HOST_CN) do if raw:find(cw,1,true) then return true end end
end
anc=anc.Parent
end
return false
end
P(function()
for _,m in ipairs(SYS.Index()) do
local isRig=(m:FindFirstChild("Head")~=nil and m:FindFirstChild("HumanoidRootPart")~=nil)
if m:IsA("Model") and m~=LP.Character and (m:FindFirstChildOfClass("Humanoid") or isRig) then
local isPlayerChar=false
if Players.GetPlayerFromCharacter then
local ok,pl=pcall(function() return Players:GetPlayerFromCharacter(m) end)
isPlayerChar=(ok and pl~=nil)
end
local h=m:FindFirstChildOfClass("Humanoid")
if not isPlayerChar then
list[#list+1]=m
HOST[m]=isHostile(m)
end
end
end
end)
SYS._npcList=list
SYS._npcHostile=HOST
if not SYS._npcLogged then
SYS._npcLogged=true
local hn=0
for _,mm in ipairs(list) do if HOST[mm]==true then hn=hn+1 end end
print(("[ESP] 生物透视: 活物 %d 个 (敌对 %d / 中立 %d)"):format(#list,hn,#list-hn))
end
end
local nact={}
for _,m in ipairs(SYS._npcList or {}) do if m and m.Parent then nact[m]=true end end
for m,h in pairs(HN) do
if not nact[m] or h.Adornee~=m then P(function() h:Destroy() end) HN[m]=nil end
end
for m in pairs(nact) do
local h=HN[m]
if not h then
h=Instance.new("Highlight")
h.Adornee=m
h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
h.OutlineTransparency=0
h.Parent=m
HN[m]=h
elseif h.Parent~=m then
P(function() h.Parent=m end)
end
local part=m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
local wall=espWall(part)
h.FillTransparency=wall and 0.93 or 0.88
if (SYS._npcHostile and SYS._npcHostile[m])==true then
h.FillColor   =Color3.fromRGB(255,30,30)
h.OutlineColor=Color3.fromRGB(255,0,0)
else
h.FillColor   =Color3.fromRGB(255,140,0)
h.OutlineColor=Color3.fromRGB(255,105,0)
end
end
else
if next(HN) then for _,h in pairs(HN) do P(function() h:Destroy() end) end HN={} end
SYS._npcList=nil
SYS._npcHostile=nil
end
local PK = {}
SYS.PickKinds = {
{ name = "箱子/收纳", color = Color3.fromRGB(0,200,255),
kws = {"chest","crate","locker","cabinet","vault","safe","coffer","stash","case","box","container",
"drawer","dresser","desk","table","knobs","cupboard","bookcase","checkout","wardrobe",
"宝箱","箱子","柜","收纳","棺材","抽屉","桌"} },
{ name = "拾取物", color = Color3.fromRGB(0,200,255),
kws = {"pickup","drop","loot","reward","token","orb","collect","coin","cash","gem","item","scrap",
"money","cash","orb","star","card","key","gold","coin",
"金币","掉落","奖励","拾取","道具"} },
{ name = "道具/补给", color = Color3.fromRGB(0,200,255),
kws = {"flashlight","torch","lighter","vitamin","bandage","medkit","crucif","lockpick","skeleton",
"battery","fuse","candle","bottle","ribbon","cheese","bone","keycard","syringe","potion",
"alarmclock","clock","globe","typewriter","keyobtain","padlock","lever","breaker","timer",
"paperplane","portrait","rift","revive","chandelier","obstruction",
"手电","打火机","维生素","绷带","开锁","骷髅","电池","保险丝","蜡烛","钟","地球仪","打字机",
"密码锁","拉杆","电闸","定时"} },
{ name = "躲藏点", color = Color3.fromRGB(0,200,255),
kws = SYS.KwHidePick },
{ name = "书籍/纸张/线索", color = Color3.fromRGB(0,200,255),
kws = SYS.KwClue },
{ name = "梯子/攀爬", color = Color3.fromRGB(0,200,255),
kws = {"ladder","truss","climb","rope","vine","wallrun","grapple",
"梯","爬","绳","藤"} },
{ name = "按钮/机关", color = Color3.fromRGB(0,200,255),
kws = {"button","switch","lever","panel","console","puzzle","mechanism","trigger","valve","terminal",
"按钮","机关","开关","拉杆","控制"} },
{ name = "传送/入口", color = Color3.fromRGB(0,200,255),
kws = {"portal","warp","teleport","gateway","exit","entrance","door","gate","elevator","stairs",
"传送","入口","出口","楼梯","电梯"} },
{ name = "座位/载具", color = Color3.fromRGB(0,200,255),
kws = {"seat","vehicle","chair","mount","cart","boat","car","bike","ride",
"坐","车","船"} },
{ name = "商店/交互台", color = Color3.fromRGB(0,200,255),
kws = {"shop","vendor","merchant","trader","station","kiosk","market","atm","bank","forge","workbench",
"商店","商人","柜台","工作台","锻造"} },
{ name = "检查点/目标", color = Color3.fromRGB(0,200,255),
kws = {"checkpoint","flag","goal","finish","objective","spawn","base",
"检查点","终点","目标","旗"} },
{ name = "小游戏区域", color = Color3.fromRGB(0,200,255),
kws = {"duck hunt","duckhunt","chisel","gauntlet","rightofway","blindout","crushhour",
"bumpermadness","mppadhost","mpstation","machin",
"小游戏","关卡","模式"} },
}
local function pickKind(o)
local nm = type(o.Name) == "string" and o.Name:lower() or ""
if nm ~= "" then
for _, k in ipairs(SYS.PickKinds) do
for _, kw in ipairs(k.kws) do
if nm:find(kw, 1, true) or (o.Name:find(kw, 1, true)) then
return k
end
end
end
end
return nil
end
if SYS.T_.ESP_Pick then
SYS._pickN=(SYS._pickN or 0)+1
local _now=os.clock()
if (SYS._pickN%25==1 and (not SYS._pickAt or _now-SYS._pickAt>1)) or not SYS._pickList then
SYS._pickAt=_now
local list={}
local names={}
local camPos=SYS.Cam and SYS.Cam.CFrame and SYS.Cam.CFrame.Position
local MAXD=tonumber(SYS.C_.PickDist) or 1200
P(function()
for _,o in ipairs(SYS.Index()) do
local cn=o.ClassName
local ok=false
if cn=="Tool" then ok=true
elseif o:IsA("BasePart") or o:IsA("Model") or cn=="Folder" then
local function hasI(x, deep)
if not x then return false end
if x:FindFirstChildOfClass("ClickDetector")~=nil
or x:FindFirstChildOfClass("ProximityPrompt")~=nil then return true end
if deep and (x:IsA("Model") or x:IsA("Folder")) then
local ok2, has = P(function()
if #x:GetChildren() > 60 then return false end
return (x:FindFirstChildWhichIsA("ProximityPrompt", true) ~= nil)
or (x:FindFirstChildWhichIsA("ClickDetector", true) ~= nil)
end)
if ok2 and has == true then return true end
end
return false
end
if hasI(o) then ok=true
else
if hasI(o.Parent) then ok=true
else
for _,ch in ipairs(o:GetChildren()) do if hasI(ch) then ok=true break end end
if not ok then
local anc=o.Parent
for _=1,2 do
if not anc then break end
if hasI(anc,true) then ok=true break end
anc=anc.Parent
end
end
end
end
end
local kind = pickKind(o)
if not kind and type(o.Name)=="string" then
local anc=o
for _=1,4 do
if not anc then break end
kind=pickKind(anc)
if kind then break end
anc=anc.Parent
end
end
if not kind then
local sg=o:FindFirstChildOfClass("SurfaceGui")
if sg then
local hasText=false
for _,g in ipairs(sg:GetDescendants()) do
if g:IsA("TextLabel") or g:IsA("TextBox") then hasText=true break end
end
if hasText then kind={name="文字线索", color=Color3.fromRGB(0,200,255)} end
end
end
if not kind and not ok and type(o.Name)=="string" and o.Name~="" then
local nm=o.Name:lower()
for _,kw in ipairs(SYS.KwMpExtra) do
if nm:find(kw,1,true) then ok=true break end
end
end
if (ok or kind) and o.Parent and o~=LP.Character then
local part=o.PrimaryPart or (cn~="Model" and cn~="Folder" and o) or o:FindFirstChildWhichIsA("BasePart")
if part and part.Position then
local d=camPos and (part.Position-camPos).Magnitude or 0
if not camPos or d<=MAXD then
local kk=kind or {name="通用可交互", color=Color3.fromRGB(0,200,255)}
if cn=="Model" or cn=="Folder" then
local _n=0
for _,ch in ipairs(o:GetChildren()) do
if ch:IsA("BasePart") and ch.Position then
_n=_n+1
if _n>12 then break end
list[#list+1]=ch
PK[ch]=kk
end
end
if _n==0 then list[#list+1]=part PK[part]=kk end
else
list[#list+1]=part
PK[part]=kk
end
if #names<16 and type(o.Name)=="string" then
local dup=false
for _,n in ipairs(names) do if n==o.Name then dup=true break end end
if not dup then
names[#names+1]=o.Name..(kind and ("["..kind.name.."]") or "[结构]")
end
end
end
end
end
end
end)
SYS._pickList=list
if not SYS._pickLogged then
SYS._pickLogged=true
print(("[ESP] 可交互透视: 找到 %d 个候选。名字样本: %s"):format(#list, table.concat(names,", ")))
if #list==0 then
print("[ESP] 一个可交互物都没找到 -> 把那个物件(比如躲藏点/道具)的名字或截图发来, 我按真名加判据")
end
end
end
local pact={}
for _,p in ipairs(SYS._pickList or {}) do if p and p.Parent then pact[p]=true end end
for p,h in pairs(HP) do
if not pact[p] or h.Adornee~=p then P(function() h:Destroy() end) HP[p]=nil end
end
for p in pairs(pact) do
local h=HP[p]
if not h then
h=Instance.new("Highlight")
h.Adornee=p
h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
h.OutlineTransparency=0
h.Parent=p
HP[p]=h
elseif h.Parent~=p then
P(function() h.Parent=p end)
end
local wall=espWall(p)
local kk=PK[p]
local kc=(kk and kk.color) or Color3.fromRGB(0,200,255)
h.FillTransparency=wall and 0.93 or 0.88
h.FillColor=kc
h.OutlineColor=kc
end
else
if next(HP) then for _,h in pairs(HP) do P(function() h:Destroy() end) end HP={} end
SYS._pickList=nil PK={}
end
if SYS.T_.ESP_Door then
SYS._doorN=(SYS._doorN or 0)+1
local _now=os.clock()
if (SYS._doorN%25==1 and (not SYS._doorAt or _now-SYS._doorAt>1)) or not SYS._doorList then
SYS._doorAt=_now
local list={}
local CUTOF={}
local SOFT={}
local FAKE={}
local TRAP={}
local camPos=SYS.Cam and SYS.Cam.CFrame and SYS.Cam.CFrame.Position
local MAXD=tonumber(SYS.C_.PickDist) or 1200
local TRAPKW=SYS.KwTrap
local TRAPCN=SYS.KwTrapCN
local KW=SYS.KwGate
local CUTKW=SYS.KwCut
local CNKW=SYS.KwGateCN
local function doorShaped(o, pr)
if not pr then return false end
local okS,sz=pcall(function() return pr.Size end)
if not okS or typeof(sz)~="Vector3" then return false end
local x,y,z=sz.X,sz.Y,sz.Z
local mn=math.min(x,y,z)
local mx=math.max(x,y,z)
if y~=mx then return false end
if y<3.5 then return false end
if mn>1.5 then return false end
if (x+y+z-mn-mx)<2.2 then return false end
local cc=nil
local tr=nil
pcall(function() cc=pr.CanCollide end)
pcall(function() tr=pr.Transparency end)
if cc==false then return true end
if type(tr)=="number" and tr>0.05 then return true end
if pr:FindFirstChildOfClass("Decal") or pr:FindFirstChildOfClass("Texture")
or pr:FindFirstChildOfClass("SurfaceGui") then return true end
if pr:FindFirstChildOfClass("ProximityPrompt") or pr:FindFirstChildOfClass("ClickDetector") then return true end
if o~=pr and (o:FindFirstChildOfClass("ProximityPrompt") or o:FindFirstChildOfClass("ClickDetector")) then return true end
return false
end
local names={}
P(function()
for _,o in ipairs(SYS.Index()) do
local cn=o.ClassName
local ok=false
local soft=false
if o:IsA("BasePart") or cn=="Model" then
if o:FindFirstChildOfClass("HingeConstraint") or o:FindFirstChildOfClass("Motor6D") then ok=true end
if not ok then
local anc=o
for _=1,4 do
if not anc then break end
local raw=anc.Name
if type(raw)=="string" and raw~="" then
local nm=raw:lower()
for _,kw in ipairs(KW) do if nm:find(kw,1,true) then ok=true break end end
if not ok then
for _,cw in ipairs(CNKW) do if raw:find(cw,1,true) then ok=true break end end
end
end
if ok then break end
anc=anc.Parent
end
end
if not ok then
local pr=(cn~="Model") and o or o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")
if doorShaped(o, pr) then ok=true soft=true end
end
end
local isCut=false
if ok then
local anc=o
for _=1,4 do
if not anc then break end
local raw=anc.Name
if type(raw)=="string" and raw~="" then
local nm=raw:lower()
for _,kw in ipairs(CUTKW) do if nm:find(kw,1,true) then isCut=true break end end
if not isCut then
if raw:find("切割",1,true) or raw:find("凿",1,true) then isCut=true end
end
end
if isCut then break end
anc=anc.Parent
end
end
local isFake=false
local isTrap=false
if ok then
local anc=o
for _=1,4 do
if not anc then break end
local raw=anc.Name
if type(raw)=="string" and raw~="" then
local nm=raw:lower()
if nm:find("fake",1,true) or nm:find("dupe",1,true) or nm:find("false",1,true)
or raw:find("假门",1,true) or raw:find("伪装",1,true) then isFake=true end
if not isTrap then
for _,kw in ipairs(TRAPKW) do if nm:find(kw,1,true) then isTrap=true break end end
end
if not isTrap then
for _,cw in ipairs(TRAPCN) do if raw:find(cw,1,true) then isTrap=true break end end
end
end
if isFake and isTrap then break end
anc=anc.Parent
end
end
if ok and o.Parent and o~=LP.Character then
local part=o.PrimaryPart or (cn~="Model" and o) or o:FindFirstChildWhichIsA("BasePart")
if part and part.Position then
local d=camPos and (part.Position-camPos).Magnitude or 0
if not camPos or d<=MAXD then
list[#list+1]=part
CUTOF[part]=isCut
SOFT[part]=soft
FAKE[part]=isFake
TRAP[part]=(isTrap or isCut or isFake)
if #names<14 and type(o.Name)=="string" then
local dup=false
for _,n in ipairs(names) do if n==o.Name then dup=true break end end
if not dup then names[#names+1]=o.Name end
end
end
end
end
end
end)
SYS._doorList=list
SYS._doorCut=CUTOF
SYS._doorSoft=SOFT
SYS._doorFake=FAKE
SYS._doorTrap=TRAP
if not SYS._doorLogged then
SYS._doorLogged=true
print(("[ESP] 门/陷阱/假门透视: 找到 %d 个候选。名字样本: %s"):format(#list, table.concat(names,", ")))
if #list==0 then
print("[ESP] 门/假门一个都没找到 -> 把那个假门的真名(或截图)发来, 我按名字直接加判据")
end
end
end
local dact={}
for _,p in ipairs(SYS._doorList or {}) do if p and p.Parent then dact[p]=true end end
for p,h in pairs(HD) do
if not dact[p] or h.Adornee~=p then P(function() h:Destroy() end) HD[p]=nil end
end
for p,s in pairs(HD_SK) do
if not dact[p] or s.Adornee~=p then P(function() s:Destroy() end) HD_SK[p]=nil end
end
local DCUT=SYS._doorCut or {}
local DSOFT=SYS._doorSoft or {}
local DFAKE=SYS._doorFake or {}
local DTRAP=SYS._doorTrap or {}
for p in pairs(dact) do
local h=HD[p]
if not h then
h=Instance.new("Highlight")
h.Adornee=p
h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
h.OutlineTransparency=0
h.Parent=p
HD[p]=h
elseif h.Parent~=p then
P(function() h.Parent=p end)
end
local wall=espWall(p)
h.FillTransparency=wall and 0.93 or 0.88
h.OutlineTransparency=0
if DTRAP[p]==true then
h.FillColor   =Color3.fromRGB(255,30,30)
h.OutlineColor=Color3.fromRGB(255,0,0)
else
h.FillColor   =Color3.fromRGB(0,200,255)
h.OutlineColor=Color3.fromRGB(0,170,230)
end
local sk=HD_SK[p]
if not sk then
sk=Instance.new("BillboardGui")
sk.Size=UDim2.new(0,44,0,44)
sk.AlwaysOnTop=true
sk.Adornee=p
sk.Parent=p
local t=Instance.new("TextLabel")
t.Size=UDim2.fromScale(1,1)
t.BackgroundTransparency=1
t.Text="☠"
t.TextColor3=Color3.fromRGB(255,30,30)
t.TextScaled=true
t.Font=Enum.Font.GothamBold
t.Parent=sk
HD_SK[p]=sk
elseif sk.Parent~=p then
P(function() sk.Parent=p end)
end
if sk then sk.Enabled=(DTRAP[p]==true) end
end
else
if next(HD) then for _,h in pairs(HD) do P(function() h:Destroy() end) end HD={} end
if next(HD_SK) then for _,s in pairs(HD_SK) do P(function() s:Destroy() end) end HD_SK={} end
SYS._doorList=nil
SYS._doorCut=nil
SYS._doorSoft=nil
SYS._doorFake=nil
SYS._doorTrap=nil
end
if SYS.T_.ESP_Mini then
SYS._miniN=(SYS._miniN or 0)+1
local _now=os.clock()
if (SYS._miniN%25==1 and (not SYS._miniAt or _now-SYS._miniAt>1)) or not SYS._miniList then
SYS._miniAt=_now
local list={}
local camPos=SYS.Cam and SYS.Cam.CFrame and SYS.Cam.CFrame.Position
local MAXD=tonumber(SYS.C_.PickDist) or 1200
local AREA=SYS.MiniArea
local AREACN=SYS.MiniAreaCN
P(function()
for _,o in ipairs(SYS.Index()) do
local cn=o.ClassName
if cn=="Part" or cn=="MeshPart" or cn=="UnionOperation" or cn=="Model" then
local hit=false
local anc=o
for _=1,4 do
if not anc then break end
local raw=anc.Name
if type(raw)=="string" and raw~="" then
local nm=raw:lower():gsub("%s+","")
for _,kw in ipairs(AREA) do if nm:find(kw,1,true) then hit=true break end end
if not hit then
for _,cw in ipairs(AREACN) do if raw:find(cw,1,true) then hit=true break end end
end
end
if hit then break end
anc=anc.Parent
end
if hit and o.Parent and o~=LP.Character then
local part=o.PrimaryPart or (cn~="Model" and o) or o:FindFirstChildWhichIsA("BasePart")
if part and part.Position then
local d=camPos and (part.Position-camPos).Magnitude or 0
if not camPos or d<=MAXD then list[#list+1]=part end
end
end
end
end
end)
SYS._miniList=list
if not SYS._miniLogged then
SYS._miniLogged=true
print(("[ESP] 小游戏区域透视: 找到 %d 个候选"):format(#list))
end
end
local mact={}
for _,p in ipairs(SYS._miniList or {}) do if p and p.Parent then mact[p]=true end end
for p,h in pairs(HM) do
if not mact[p] or h.Adornee~=p then P(function() h:Destroy() end) HM[p]=nil end
end
for p in pairs(mact) do
local h=HM[p]
if not h then
h=Instance.new("Highlight")
h.Adornee=p
h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
h.OutlineTransparency=0
h.Parent=p
HM[p]=h
elseif h.Parent~=p then
P(function() h.Parent=p end)
end
local wall=espWall(p)
h.FillTransparency=wall and 0.93 or 0.88
h.FillColor   =Color3.fromRGB(0,200,255)
h.OutlineColor=Color3.fromRGB(0,170,230)
end
else
if next(HM) then for _,h in pairs(HM) do P(function() h:Destroy() end) end HM={} end
SYS._miniList=nil
end
if SYS.T_.ESPNameTag then
for p,l in pairs(LB) do
local c=act[p] local hd=c and tagPart(c)
if not hd or l.Adornee~=hd then l:Destroy() LB[p]=nil LBL[p]=nil end
end
for p,c in pairs(act) do
local hd=tagPart(c)
if hd then
local off=SYS.C_.ESPNameH or 0
local okBB,bcf,bsz=pcall(function() local a,b=c:GetBoundingBox() return a,b end)
if okBB and bcf and bsz then
off=off+(bcf.Position.Y+bsz.Y*0.5-hd.Position.Y)+1.1
else
off=off+3.2
end
local l=LB[p]
if not l then
l=Instance.new("BillboardGui")
l.Size=UDim2.new(0,240,0,36) l.Adornee=hd l.AlwaysOnTop=true
l.StudsOffsetWorldSpace=Vector3.new(0,off,0) l.Parent=hd
local t=Instance.new("TextLabel")
t.Size=UDim2.fromScale(1,1) t.BackgroundTransparency=1
t.TextColor3=Color3.new(1,1,1) t.TextScaled=true
t.Font=Enum.Font.Code t.TextStrokeTransparency=0.4 t.Parent=l
LBL[p]=t
LB[p]=l
else
l.StudsOffsetWorldSpace=Vector3.new(0,off,0)
end
local hh=c:FindFirstChildOfClass("Humanoid")
local hp=hh and math.floor(hh.Health+0.5) or 0
local mx=hh and math.floor(hh.MaxHealth+0.5) or 0
local tl=LBL[p] or (LB[p] and LB[p]:FindFirstChildOfClass("TextLabel"))
if tl then
local _dist=""
P(function()
local me=LP.Character
local mr=me and me:FindFirstChild("HumanoidRootPart")
local tp2=tagPart(c) or c.PrimaryPart
if mr and tp2 and tp2.Position then _dist=("  %d格"):format((tp2.Position-mr.Position).Magnitude) end
end)
tl.Text=(p.DisplayName or p.Name).."  "..hp.."/"..mx.._dist
if mx>0 and hp<=mx*0.3 then tl.TextColor3=Color3.fromRGB(255,80,80)
elseif mx>0 and hp<=mx*0.6 then tl.TextColor3=Color3.fromRGB(255,190,80)
else tl.TextColor3=Color3.new(1,1,1) end
end
end
end
elseif next(LB) then
for _,l in pairs(LB) do l:Destroy() end LB={} LBL={}
end
if SYS.T_.ESPItem then
local t0=os.clock()
local actI={}
local maxI=SYS.C_.PerfCull or 300
local camPos=SYS.Cam and SYS.Cam.CFrame and SYS.Cam.CFrame.Position
local function nameLike(nm)
if type(nm)~="string" or nm=="" then return false end
local s=nm:lower()
return s:find("drop",1,true)~=nil or s:find("loot",1,true)~=nil or s:find("item",1,true)~=nil
or s:find("pickup",1,true)~=nil or s:find("coin",1,true)~=nil or s:find("crate",1,true)~=nil
or s:find("supply",1,true)~=nil or s:find("chest",1,true)~=nil or s:find("weapon",1,true)~=nil
end
local function isPartClass(cn)
return cn=="Part" or cn=="MeshPart" or cn=="UnionOperation" or cn=="TrussPart" or cn=="Tool"
end
local function lookDroppable(o)
local ok1,c1=pcall(function() return o:GetChildren() end)
if not ok1 or type(c1)~="table" then return false end
local n=#c1
if n>16 then n=16 end
for i=1,n do
local cn=c1[i].ClassName
if cn=="ProximityPrompt" or cn=="ClickDetector" or cn=="BillboardGui" then return true end
end
return false
end
local function take(o)
if not o or not o.Parent then return end
local cn=o.ClassName
if cn=="Model" or isPartClass(cn) then
if nameLike(o.Name) or lookDroppable(o) then actI[o]=true end
end
end
local function scanOne(cont)
local ok,ks=pcall(function() return cont:GetChildren() end)
if not ok or type(ks)~="table" then return end
for i=1,#ks do
local o=ks[i]
local cn=o.ClassName
if cn=="Folder" then
if nameLike(o.Name) then
local ok2,ks2=pcall(function() return o:GetChildren() end)
if ok2 and type(ks2)=="table" then
local m=#ks2
if m>200 then m=200 end
for j=1,m do take(ks2[j]) end
end
end
else
take(o)
end
if i%120==0 and (os.clock()-t0)>0.004 then return end
end
end
scanOne(WS)
local chars={}
for _,pl in ipairs(Players:GetPlayers()) do
local c=pl.Character
if c then chars[#chars+1]=c end
end
for o in pairs(actI) do
local bad=false
for i=1,#chars do if o:IsDescendantOf(chars[i]) then bad=true break end end
if not bad and camPos then
local okP,pos=pcall(function() return o:GetPivot().Position end)
if not okP then local okP2,p2=pcall(function() return o.Position end) if okP2 then pos=p2 end end
if pos and (pos-camPos).Magnitude>maxI then bad=true end
end
if bad then actI[o]=nil end
end
for o,h in pairs(HI) do
if not actI[o] or not o.Parent then P(function() h:Destroy() end) HI[o]=nil end
end
for o in pairs(actI) do
local h=HI[o]
if not h then
h=Instance.new("Highlight")
h.Adornee=o
h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
h.FillTransparency=0.88
h.OutlineTransparency=0
h.FillColor=Color3.fromRGB(0,200,255)
h.OutlineColor=Color3.fromRGB(0,170,230)
P(function() h.Parent=o end)
HI[o]=h
elseif h.Parent~=o then
P(function() h.Parent=o end)
end
end
elseif next(HI) then
for _,h in pairs(HI) do P(function() h:Destroy() end) end HI={}
end
if SYS.T_.ESPWeapon then
for p,c in pairs(act) do
local wpn=nil
local ok1,ks=pcall(function() return c:GetChildren() end)
if ok1 and type(ks)=="table" then
for i=1,#ks do
if ks[i].ClassName=="Tool" and ks[i].Name~="" then wpn=ks[i].Name break end
end
end
if not wpn then
local bp=p.Backpack
if bp then
local ok2,bs=pcall(function() return bp:GetChildren() end)
if ok2 and type(bs)=="table" then
for i=1,#bs do
if bs[i].ClassName=="Tool" and bs[i].Name~="" then wpn=bs[i].Name break end
end
end
end
end
local lw=LW[p]
if not wpn then
if lw then P(function() lw:Destroy() end) LW[p]=nil LWL[p]=nil end
else
local hd=tagPart(c)
if hd then
if not lw then
lw=Instance.new("BillboardGui")
lw.Size=UDim2.new(0,240,0,26) lw.Adornee=hd lw.AlwaysOnTop=true
lw.StudsOffsetWorldSpace=Vector3.new(0,1.6,0)
lw.Parent=hd
local t=Instance.new("TextLabel")
t.Size=UDim2.fromScale(1,1) t.BackgroundTransparency=1
t.TextColor3=Color3.fromRGB(255,90,90) t.TextScaled=true
t.Font=Enum.Font.GothamBold t.TextStrokeTransparency=0.2 t.Parent=lw
LWL[p]=t
LW[p]=lw
end
local tl=LWL[p]
if tl then tl.Text="🔫 "..wpn end
end
end
end
elseif next(LW) then
for _,l in pairs(LW) do P(function() l:Destroy() end) end LW={} LWL={}
end
end
local DODGE_KW = SYS.KwHazard
SYS._hitSeen = setmetatable({}, {__mode="k"})
SYS._dodgeStat = SYS._dodgeStat or {n=0, hits=0}
function SYS.AutoDodgeScan()
local list = {}
P(function()
local function consider(o)
if not o then return end
local cn = o.ClassName
if not (cn == "Part" or cn == "MeshPart" or cn == "UnionOperation" or cn == "Model") then return end
local ok = false
if o:FindFirstChildOfClass("HingeConstraint") or o:FindFirstChildOfClass("Motor6D") then ok = true end
if not ok then
local anc = o
for _=1,2 do
if not anc then break end
local raw = anc.Name
if type(raw)=="string" and raw~="" then
local nm = raw:lower()
for _,kw in ipairs(DODGE_KW) do if nm:find(kw,1,true) then ok=true break end end
if not ok and (raw:find("门") or raw:find("陷阱") or raw:find("机关") or raw:find("刺")
or raw:find("熔岩") or raw:find("伤害") or raw:find("危险")
or raw:find("地雷") or raw:find("炸弹")
or raw:find("关卡") or raw:find("考验")) then ok = true end
end
if ok then break end
anc = anc.Parent
end
end
if ok and o.Parent then
local part = o.PrimaryPart or (cn ~= "Model" and o) or o:FindFirstChildWhichIsA("BasePart")
if part and part.Position then list[#list+1] = part end
end
end
for _, o in ipairs(WS:GetChildren()) do
consider(o)
local ok, kids = P(function() return o:GetChildren() end)
if ok and type(kids)=="table" then
local n = #kids
if n > 80 then n = 80 end
for i = 1, n do consider(kids[i]) end
end
end
end)
return list
end
function SYS.AutoDodgeTick()
if not SYS.T_.AutoDodge then return end
local _, hum, root = GC()
if not (hum and root) then return end
local now = os.clock()
if (now - (SYS._dodgeAt or 0)) > 2 or not SYS._dodgeList then
SYS._dodgeAt = now
local l = SYS.AutoDodgeScan()
SYS._dodgeList = l
SYS._dodgeStat = SYS._dodgeStat or {n=0, hits=0}
SYS._dodgeStat.n = #l
end
local nearest, nd = nil, math.huge
for _, p in ipairs(SYS._dodgeList or {}) do
if p and p.Parent then
local d = (p.Position - root.Position).Magnitude
if d < nd then nd = d nearest = p end
end
end
local thr = tonumber(SYS.C_.DodgeDist) or 15
if nearest and nd < thr then
local away = root.Position - nearest.Position
away = Vector3.new(away.X, 0, away.Z)
if away.Magnitude < 0.001 then away = Vector3.new(1, 0, 0) end
local step = math.min(0.35, math.max(0.06, (thr - nd) * 0.25))
local dir = away.Unit
P(function()
local rp = root.Position
local rot = root.CFrame - rp
root.CFrame = CFrame.new(rp + dir * step) * rot
end)
SYS._dodgeOn = true
if SYS._dodgeStat then SYS._dodgeStat.hits = SYS._dodgeStat.hits + 1 end
elseif SYS._dodgeOn then
SYS._dodgeOn = false
end
end
function SYS.SetAutoDodge(on)
SYS.T_.AutoDodge = on and true or false
SYS.SetLoop("AutoDodge", on, RS.Heartbeat, SYS.AutoDodgeTick)
if on then SYS.Notify("🏃 自动躲机关: 已开(靠近陷阱/地雷/压板会自动退开)", SYS.CY.green) end
end
local AUTO_MINI_AREA = SYS.MiniArea
local function _globalFn(n)
local f = rawget(_G, n)
if type(f) ~= "function" then P(function() f = getfenv()[n] end) end
return type(f) == "function" and f or nil
end
local function fireObj(obj)
if obj:IsA("ProximityPrompt") then
local fp = _globalFn("fireproximityprompt")
if fp then P(function() fp(obj) end) end
P(function() obj:InputHoldBegin() end)
P(function() obj:InputHoldEnd() end)
elseif obj:IsA("ClickDetector") then
local fc = _globalFn("fireclickdetector")
if fc then P(function() fc(obj) end) end
end
end
function SYS.AutoHitScan()
local list = {}
P(function()
for _, o in ipairs(SYS.Index()) do
if o:IsA("ProximityPrompt") or o:IsA("ClickDetector") then
local inMini = false
local anc = o.Parent
for _=1,4 do
if not anc then break end
local raw = anc.Name
if type(raw)=="string" and raw~="" then
local nm = raw:lower():gsub("%s+","")
for _,kw in ipairs(AUTO_MINI_AREA) do if nm:find(kw,1,true) then inMini=true break end end
if not inMini and (raw:find("小游戏") or raw:find("关卡") or raw:find("模式")) then inMini = true end
end
if inMini then break end
anc = anc.Parent
end
if inMini then
local p = o.Parent
if p and p:IsA("BasePart") and p.Position then
list[#list+1] = { part=p, obj=o }
end
end
end
end
end)
return list
end
function SYS.AutoHitTick()
if not SYS.T_.AutoHitMinigame then return end
local _, _, root = GC()
if not root then return end
local now = os.clock()
if (now - (SYS._hitAt or 0)) > 0.5 or not SYS._hitList then
SYS._hitAt = now
SYS._hitList = SYS.AutoHitScan()
end
local thr = tonumber(SYS.C_.HitDist) or 30
for _, it in ipairs(SYS._hitList or {}) do
local p = it.part
if p and p.Parent and (p.Position - root.Position).Magnitude < thr then
if not SYS._hitSeen[it.obj] or now - SYS._hitSeen[it.obj] > 3 then
SYS._hitSeen[it.obj] = now
fireObj(it.obj)
end
end
end
end
function SYS.SetAutoHitMinigame(on)
SYS.T_.AutoHitMinigame = on and true or false
SYS.SetLoop("AutoHitMinigame", on, RS.Heartbeat, SYS.AutoHitTick)
if on then SYS.Notify("🎯 自动触发小游戏目标: 已开(小游戏区域里的按钮/可交互物自动触发)", SYS.CY.green) end
end
local FPos,FYaw,FPitch=Vector3.zero,0,0
local FConn,FMC,FKC=nil,nil,nil
local FHum={}
local function Freeze()
local _,h=GC() if not h then return end
if next(FHum)==nil then
FHum={WalkSpeed=h.WalkSpeed,UseJumpPower=h.UseJumpPower,JumpPower=h.JumpPower,JumpHeight=h.JumpHeight}
end
h.WalkSpeed=0
P(function() h.UseJumpPower=true h.JumpPower=0 end)
P(function() h:Move(Vector3.zero,false) end)
end
local function Unfreeze()
local _,h=GC()
if h and next(FHum)~=nil then
h.WalkSpeed=FHum.WalkSpeed or 16
P(function()
if FHum.UseJumpPower~=nil then h.UseJumpPower=FHum.UseJumpPower end
if FHum.JumpPower then h.JumpPower=FHum.JumpPower end
if FHum.JumpHeight then h.JumpHeight=FHum.JumpHeight end
end)
end
FHum={}
end
function SYS.RestoreMouse()
UIS.MouseBehavior=Enum.MouseBehavior.Default
UIS.MouseIconEnabled=true
SYS.MenuPrevMouseBehav=nil SYS.MenuPrevMouseIcon=nil
SYS.FCPrevBehav=nil SYS.FCPrevIcon=nil
end
function SYS.StartFreeCam()
if SYS.FreeCamActive or not SYS.Cam then return end
SYS.FreeCamActive=true
FPos=SYS.Cam.CFrame.Position
local look=SYS.Cam.CFrame.LookVector
FYaw=math.atan2(-look.X,-look.Z)
FPitch=math.asin(math.clamp(look.Y,-1,1))
SYS.Cam.CameraType=Enum.CameraType.Scriptable
SYS.Cam.CameraSubject=nil
if SYS.MenuOpen and SYS.MenuPrevMouseBehav~=nil then
SYS.FCPrevBehav=SYS.MenuPrevMouseBehav
SYS.FCPrevIcon=SYS.MenuPrevMouseIcon
else
SYS.FCPrevBehav=UIS.MouseBehavior
SYS.FCPrevIcon=UIS.MouseIconEnabled
end
UIS.MouseBehavior=Enum.MouseBehavior.LockCenter
UIS.MouseIconEnabled=false
P(SYS.DisablePlayerControls)
Freeze()
FKC=task.spawn(function()
while SYS.FreeCamActive and not SYS.Unloaded do Freeze() task.wait(0.25) end
end)
FMC=T(UIS.InputChanged:Connect(function(input)
if not SYS.FreeCamActive or input.UserInputType~=Enum.UserInputType.MouseMovement then return end
local s=SYS.C_.FreeCamSens*0.01
FYaw=FYaw-input.Delta.X*s
FPitch=math.clamp(FPitch-input.Delta.Y*s,-math.pi/2+0.01,math.pi/2-0.01)
end))
FConn=RS.RenderStepped:Connect(function(dt)
if not SYS.FreeCamActive or not SYS.Cam then return end
if not SYS.MenuOpen then
P(function()
if UIS.MouseBehavior~=Enum.MouseBehavior.LockCenter then UIS.MouseBehavior=Enum.MouseBehavior.LockCenter end
if UIS.MouseIconEnabled then UIS.MouseIconEnabled=false end
end)
end
local rot=CFrame.Angles(0,FYaw,0)*CFrame.Angles(FPitch,0,0)
local cf=CFrame.new(FPos)*rot
local dir=Vector3.zero
local f,r=cf.LookVector,cf.RightVector
if UIS:IsKeyDown(Enum.KeyCode.W) then dir+=f end
if UIS:IsKeyDown(Enum.KeyCode.S) then dir-=f end
if UIS:IsKeyDown(Enum.KeyCode.D) then dir+=r end
if UIS:IsKeyDown(Enum.KeyCode.A) then dir-=r end
if UIS:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.yAxis end
if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir-=Vector3.yAxis end
local spd=SYS.C_.FreeCamSpeed
if UIS:IsKeyDown(Enum.KeyCode.Q) then spd*=3 end
if dir.Magnitude>0 then FPos+=dir.Unit*spd*dt end
SYS.Cam.CFrame=CFrame.new(FPos)*rot
end)
T(FConn)
end
function SYS.StopFreeCam()
if not SYS.FreeCamActive then return end
SYS.FreeCamActive=false
if FConn then FConn:Disconnect() FConn=nil end
if FMC then FMC:Disconnect() FMC=nil end
if FKC then DS(FKC) FKC=nil end
P(SYS.EnablePlayerControls)
Unfreeze()
if SYS.Cam then
SYS.Cam.CameraType=Enum.CameraType.Custom
local _,h,root=GC()
if h then SYS.Cam.CameraSubject=h end
if root then
local l=root.CFrame.LookVector*Vector3.new(1,0,1)
if l.Magnitude<0.01 then l=Vector3.new(0,0,-1) end
l=l.Unit
local cp=root.Position-l*12+Vector3.new(0,3,0)
SYS.Cam.CFrame=CFrame.new(cp,root.Position+Vector3.new(0,1.5,0))
end
end
if not SYS.MenuOpen then
SYS.RestoreMouse()
else
if SYS.FCPrevBehav~=nil then SYS.MenuPrevMouseBehav=SYS.FCPrevBehav end
if SYS.FCPrevIcon~=nil then SYS.MenuPrevMouseIcon=SYS.FCPrevIcon end
end
SYS.FCPrevBehav=nil SYS.FCPrevIcon=nil
end
end
do
local line=nil
local function tracerOrigin()
local ch=SYS.LP and SYS.LP.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
local hd=ch and ch:FindFirstChild("Head")
local cam=WS.CurrentCamera
local dir
if cam and cam.CFrame then dir=cam.CFrame.LookVector
elseif root then dir=root.CFrame.LookVector end
local eye
if hd then eye=hd.Position
elseif root then eye=root.Position+Vector3.new(0,1.5,0)
elseif cam and cam.CFrame then eye=cam.CFrame.Position end
return eye,dir
end
local TPL={}
local function tracerDrop(p)
local q=TPL[p]
if q then TPL[p]=nil P(function() q:Destroy() end) end
end
function SYS.TracerHide()
if line then P(function() line:Destroy() end) line=nil end
for p in pairs(TPL) do tracerDrop(p) end
end
local function tracerDraw(key,o,endP)
local d=endP-o
local len=d.Magnitude
if len<2 then return end
local q=TPL[key]
if not q then
local ok,pt=P(function()
local w=Instance.new("Part")
w.Anchored=true w.CanCollide=false w.CastShadow=false
w.CanQuery=false w.CanTouch=false
w.Material=Enum.Material.Neon w.Transparency=0.4
w.Color=Color3.fromRGB(140,255,170)
w.Archivable=false
w.Parent=WS
return w
end)
if not ok or not pt then return end
q=pt TPL[key]=q
end
P(function()
q.Size=Vector3.new(0.07,0.07,len)
q.CFrame=CFrame.lookAt(o+d*0.5,endP)
end)
end
function SYS.TracerTick()
if not SYS.T_.Tracer then
if line or next(TPL) then SYS.TracerHide() end
return
end
local o,dir=tracerOrigin()
if not o or not dir then return end
local maxD=tonumber(SYS.C_.TracerMaxDist) or 500
local cap=tonumber(SYS.C_.TracerMaxN) or 12
local all=SYS.T_.TracerAll and true or false
if all then
if line then P(function() line:Destroy() end) line=nil end
elseif next(TPL) then
for p in pairs(TPL) do tracerDrop(p) end
end
if all then
local used,n={},0
for _,pl in ipairs(Players:GetPlayers()) do
if pl~=LP and n<cap then
local c=pl.Character
local rp=c and (c.PrimaryPart or c:FindFirstChild("HumanoidRootPart"))
if rp and rp.Position then
local dd=(rp.Position-o).Magnitude
if maxD<=0 or dd<=maxD then
used[pl]=true n=n+1
tracerDraw(pl,o,rp.Position)
end
end
end
end
for p in pairs(TPL) do if not used[p] then tracerDrop(p) end end
return
end
local tp=SYS.Combat and SYS.Combat.TargetPart
local endP
if tp and tp.Position then endP=tp.Position else endP=o+dir*200 end
local d=endP-o
local len=d.Magnitude
if len<2 then return end
if not line then
local ok,pt=P(function()
local q=Instance.new("Part")
q.Anchored=true q.CanCollide=false q.CastShadow=false
q.CanQuery=false q.CanTouch=false
q.Material=Enum.Material.Neon q.Transparency=0.4
q.Color=Color3.fromRGB(140,255,170)
q.Archivable=false
q.Parent=WS
return q
end)
if not ok or not pt then return end
line=pt
end
P(function()
line.Size=Vector3.new(0.07,0.07,len)
line.CFrame=CFrame.lookAt(o+d*0.5,endP)
end)
end
T(RS.RenderStepped:Connect(function() P(SYS.TracerTick) end))
end
do
local CPS={
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
local MutBuff={Golden=1.5,Diamond=2,Plasma=4,Molten=6,Radioactive=8,
Shadow=12,Electrified=16,Rainbow=40,Astral=50,Infinity=75,
Void=12,Virus=14,Wet=16,Alien=22,Bacon=30,Enchanted=12,
Phantom=35,Volcanic=35,Heavenly=36,Carnival=37,
["Block Cup"]=38,Undead=35,Jungle=40,Frozen=40}
function SYS.GetBrainrotCPS(tool)
if not tool then return nil end
local base=CPS[tool.Name]
if not base then
local a=tool:GetAttribute("CPS") or tool:GetAttribute("BaseCPS")
if typeof(a)=="number" then base=a else return nil end
end
local lv=math.clamp(math.floor(tonumber(tool:GetAttribute("Level")) or 1),1,75)
local mut=tostring(tool:GetAttribute("Mutation") or "")
return base*(MutBuff[mut] or 1)*(1.25^(lv-1))
end
local function isEntityTool(t)
if not t or not t:IsA("Tool") then return false end
local ok,ht=pcall(function() return t:HasTag("EntityTool") end)
return ok and ht
end
local function isExclusiveTool(t)
if not t then return false end
local n = string.lower(t.Name)
local exclusiveKeywords = {
"exclusive", "独家", "专属", "limited", "限定",
"vip", "%%", "x2", "x5", "x10", "x20", "x50",
"percent", "百分比", "幸运", "lucky"
}
for _, kw in ipairs(exclusiveKeywords) do
if string.find(n, kw, 1, true) then return true end
end
if t:GetAttribute("Exclusive") or t:GetAttribute("IsExclusive")
or t:GetAttribute("Limited") or t:GetAttribute("IsLimited")
or t:GetAttribute("Percent") or t:GetAttribute("Multiplier") then
return true
end
return false
end
local function isHoldingEntity()
local ch=LP.Character if not ch then return false end
return isEntityTool(ch:FindFirstChildOfClass("Tool"))
end
local WithdrawThread
function SYS.withdrawAllBrainrots(maxSlot)
if WithdrawThread then print("[Withdraw] 已在进行中") return end
maxSlot=math.clamp(math.floor(tonumber(maxSlot) or 30),1,30)
WithdrawThread=task.spawn(function()
local ok,err=pcall(function()
local _,hum=GC() if not hum then print("[Withdraw] ❌ 无角色") return end
pcall(function() hum:UnequipTools() end)
task.wait(0.08)
local done,failed=0,0
for i=1,maxSlot do
if SYS.Unloaded then break end
if isHoldingEntity() then
pcall(function() hum:UnequipTools() end)
task.wait(0.08)
end
if Fire("S_Interact",i) then done+=1 else failed+=1 end
task.wait(0.10)
if i%5==0 then print(("[Withdraw] %d/%d"):format(i,maxSlot)) end
end
pcall(function() hum:UnequipTools() end)
print(("[Withdraw] ✅ 触发 %d · 失败 %d"):format(done,failed))
end)
WithdrawThread=nil
if not ok then warn("[Withdraw] ❌:",tostring(err)) end
end)
end
local CollectThread
function SYS.collectAllCash(maxSlot)
if CollectThread then print("[Collect] 已在进行中") return end
maxSlot=math.clamp(math.floor(tonumber(maxSlot) or 30),1,30)
CollectThread=task.spawn(function()
local ok,err=pcall(function()
local plots=WS:FindFirstChild("Plots")
if not plots then
for _,obj in ipairs(WS:GetChildren()) do
if obj:IsA("Folder") or obj:IsA("Model") then
for _,child in ipairs(obj:GetChildren()) do
if child:GetAttribute("Owner")~=nil then plots=obj break end
end
if plots then break end
end
end
end
if not plots then print("[Collect] ❌ 找不到 Plots") return end
local myPlot
for _,p in ipairs(plots:GetChildren()) do
local o=p:GetAttribute("Owner")
if o==LP.Name or o==LP.DisplayName then myPlot=p break end
end
if not myPlot then print("[Collect] ❌ 找不到你的基地") return end
print("[Collect] ✅ "..myPlot:GetFullName())
local _,_,retRoot=GC()
local returnCF=retRoot and retRoot.CFrame or nil
local slots=myPlot:FindFirstChild("Slots")
local slotList={}
if slots then
for _,slot in ipairs(slots:GetChildren()) do
local it=tostring(slot.Name):match("(%d+)")
local idx=it and tonumber(it)
if idx and idx>=1 and idx<=maxSlot then
local has=false
local part=nil
for _,c in ipairs(slot:GetDescendants()) do
if c:GetAttribute("ID")~=nil then
has=true
if c:IsA("BasePart") then part=c
elseif c.Parent and c.Parent:IsA("BasePart") then part=c.Parent
end
break
end
end
if has then table.insert(slotList,{Index=idx,Slot=slot,Part=part}) end
end
end
end
if #slotList==0 then
print("[Collect] ⚠️ 无带 ID 槽位, TP 到基地中心 + 暴力 1-"..maxSlot)
pcall(function()
local _,_,root=GC()
if root then
local pv=nil
pcall(function() pv=myPlot:GetPivot() end)
if not pv and myPlot.PrimaryPart then pv=CFrame.new(myPlot.PrimaryPart.Position) end
if pv then
root.CFrame=CFrame.new(pv.Position+Vector3.new(0,5,0))
root.AssemblyLinearVelocity=Vector3.zero
root.AssemblyAngularVelocity=Vector3.zero
end
end
end)
task.wait(0.15)
for i=1,maxSlot do
if SYS.Unloaded then break end
Fire("B_Collect",i)
task.wait(0.02)
end
else
print(("[Collect] 找到 %d 个槽位, 逐个 TP 收取"):format(#slotList))
for i,e in ipairs(slotList) do
if SYS.Unloaded then break end
local idx=e.Index
local targetPos=nil
if e.Part and e.Part:IsA("BasePart") then
targetPos=e.Part.Position
elseif e.Slot:IsA("BasePart") then
targetPos=e.Slot.Position
elseif e.Slot:IsA("Model") then
pcall(function()
local pv=e.Slot:GetPivot()
if pv then targetPos=pv.Position end
end)
end
if not targetPos then
for _,c in ipairs(e.Slot:GetDescendants()) do
if c:IsA("BasePart") then targetPos=c.Position break end
end
end
if targetPos then
pcall(function()
local _,_,root=GC()
if root then
root.CFrame=CFrame.new(targetPos+Vector3.new(0,3,0))
root.AssemblyLinearVelocity=Vector3.zero
root.AssemblyAngularVelocity=Vector3.zero
end
end)
task.wait(0.03)
end
Fire("B_Collect",idx)
task.wait(0.02)
end
end
if returnCF then
task.wait(0.15)
pcall(function()
local _,_,r2=GC()
if r2 then
r2.CFrame=returnCF
r2.AssemblyLinearVelocity=Vector3.zero
end
end)
end
print("[Collect] ✅ 完成")
end)
CollectThread=nil
if not ok then warn("[Collect] ❌:",tostring(err)) end
end)
end
local SellThread
SYS.AFK_Sell={
LastSellAt=0,
SellCooldown=2,
MaxPerVisit=20,
MoveToSeller=true,
MinCPS=tonumber(SYS.C_.SellMinCPS) or 100000,
}
local function syncMinCPS()
SYS.C_.SellMinCPS=tonumber(SYS.AFK_Sell.MinCPS) or 100000
QueueSave()
end
SYS.SyncMinCPS=syncMinCPS
local SELLER="Timmy"
local SELLER_CF=CFrame.new(134.125,0.125,83.866)*CFrame.Angles(0,-1.5707963267948966,0)
local function findSeller()
local npcs=WS:FindFirstChild("NPCs") if not npcs then return nil end
for _,o in ipairs(npcs:GetChildren()) do
if o:IsA("Model") and (o.Name==SELLER or o:GetAttribute("Name")==SELLER) then return o end
end
for _,o in ipairs(npcs:GetDescendants()) do
if o:IsA("Model") and (o.Name==SELLER or o:GetAttribute("Name")==SELLER) then return o end
end
return nil
end
local function sellHeld()
local rf=SYS.RFunction("B_Sell")
if not rf then print("[Sell] ❌ ref_B_Sell 找不到") return false end
local ok,res=pcall(function() return rf:InvokeServer() end)
if ok then print("[Sell] ✅ 返回:",tostring(res)) return true end
return false
end
local function moveToSeller()
local seller=findSeller()
local _,_,root=GC() if not root then return false end
if not seller then
pcall(function()
local r=root.CFrame-root.CFrame.Position
root.CFrame=SELLER_CF*r
root.AssemblyLinearVelocity=Vector3.zero
end)
task.wait(0.2) return true
end
local part=seller:FindFirstChild("HumanoidRootPart") or seller.PrimaryPart
or seller:FindFirstChildWhichIsA("BasePart",true)
if not part then return false end
local target=part.Position
local away=Vector3.new(root.Position.X-target.X,0,root.Position.Z-target.Z)
if away.Magnitude<0.1 then away=Vector3.new(1,0,0) end
local stand=Vector3.new(target.X,root.Position.Y,target.Z)+away.Unit*4
pcall(function()
root.CFrame=CFrame.new(stand,Vector3.new(target.X,stand.Y,target.Z))
root.AssemblyLinearVelocity=Vector3.zero
end)
task.wait(0.2) return true
end
local function pickLow(force)
local picks={}
if not force and not SYS.T_.SellThresholdEnabled then
return picks
end
local th=tonumber(SYS.AFK_Sell.MinCPS) or 0
local function scan(list)
if not list then return end
for _,t in ipairs(list:GetChildren()) do
if isEntityTool(t) then
if not isExclusiveTool(t) then
local cps=SYS.GetBrainrotCPS(t)
if cps~=nil and cps<th then
table.insert(picks,{Tool=t,CPS=cps})
end
end
end
end
end
scan(LP.Character)
scan(LP:FindFirstChild("Backpack"))
return picks
end
function SYS.sellLowCPSTools(force)
if SellThread then print("[Sell] 已在进行中") return end
SellThread=task.spawn(function()
local ok,err=pcall(function()
local now=os.clock()
if now-SYS.AFK_Sell.LastSellAt<SYS.AFK_Sell.SellCooldown then
print(("[Sell] 冷却中 %.1fs"):format(SYS.AFK_Sell.SellCooldown-(now-SYS.AFK_Sell.LastSellAt)))
return
end
local _,hum=GC() if not hum then print("[Sell] ❌ 无角色") return end
local _,_,retRoot=GC()
local returnCF=retRoot and retRoot.CFrame or nil
if SYS.AFK_Sell.MoveToSeller then
print("[Sell] 移动到 Timmy") moveToSeller() task.wait(0.3)
end
SYS.AFK_Sell.LastSellAt=os.clock()
local totalSold=0
local round=0
local MAX_ROUNDS=200
local noProgressCount=0
while not SYS.Unloaded and round<MAX_ROUNDS do
if not force and not SYS.T_.SellThresholdEnabled then
print("[Sell] 门槛开关已关闭, 停止售卖")
break
end
round+=1
local picks=pickLow(force)
if #picks==0 then
if round==1 then
print(("[Sell] 没有低于 %d CPS 的脑红"):format(SYS.AFK_Sell.MinCPS))
else
print(("[Sell] 第 %d 轮: 无更多低 CPS 脑红"):format(round))
end
break
end
print(("[Sell] 第 %d 轮 · 剩余 %d 个待卖"):format(round,#picks))
if SYS.AFK_Sell.MoveToSeller then
local seller=findSeller()
if seller then
local part=seller:FindFirstChild("HumanoidRootPart") or seller.PrimaryPart
local _,_,r=GC()
if r and part and (r.Position-part.Position).Magnitude>20 then
moveToSeller() task.wait(0.25)
end
end
end
local soldThisRound=0
for i=1,#picks do
if SYS.Unloaded then break end
local e=picks[i] local tool=e.Tool
if tool and tool.Parent then
pcall(function() hum:UnequipTools() end)
task.wait(0.08)
pcall(function() hum:EquipTool(tool) end)
task.wait(0.20)
if tool.Parent==LP.Character then
print(("[Sell] [%d] %s · CPS=%.0f"):format(totalSold+1,tool.Name,e.CPS or 0))
sellHeld()
task.wait(0.30)
if not tool.Parent then
soldThisRound+=1
totalSold+=1
end
end
task.wait(0.05)
end
end
if soldThisRound==0 then
noProgressCount+=1
print(("[Sell] 第 %d 轮无进展 (%d/2)"):format(round,noProgressCount))
if noProgressCount>=2 then
print("[Sell] 连续无进展, 停止")
break
end
task.wait(0.5)
else
noProgressCount=0
task.wait(0.15)
end
end
pcall(function() hum:UnequipTools() end)
print(("[Sell] ✅ 全部完成 · 共卖 %d 个 · %d 轮"):format(totalSold,round))
if totalSold>0 then
if SYS.T_.AutoSell then
SYS.T_.AutoSell=false
if SYS.SwitchOnChange and SYS.SwitchOnChange["AutoSell"] then
pcall(function() SYS.SwitchOnChange["AutoSell"](false) end)
end
print("[Sell] 🔕 已自动关闭: AutoSell")
end
if SYS.T_.SellThresholdEnabled then
SYS.T_.SellThresholdEnabled=false
pcall(function()
if SYS.SwitchOnChange and SYS.SwitchOnChange["SellThresholdEnabled"] then
SYS.SwitchOnChange["SellThresholdEnabled"](false)
end
end)
print("[Sell] 🔕 已自动关闭: SellThresholdEnabled")
end
QueueSave()
for _,f in ipairs(SYS.BtnRefs) do P(f) end
end
if returnCF then
pcall(function()
local _,_,r2=GC()
if r2 then
r2.CFrame=returnCF
r2.AssemblyLinearVelocity=Vector3.zero
end
end)
end
end)
SellThread=nil
if not ok then warn("[Sell] ❌:",tostring(err)) end
end)
end
function SYS.scanLowCPSCount(threshold)
threshold=tonumber(threshold) or (tonumber(SYS.AFK_Sell.MinCPS) or 0)
local picks={}
local function isEntityTool(t)
if not t or not t:IsA("Tool") then return false end
local ok,ht=pcall(function() return t:HasTag("EntityTool") end)
return ok and ht
end
local function scan(list)
if not list then return end
for _,t in ipairs(list:GetChildren()) do
if isEntityTool(t) then
if not isExclusiveTool(t) then
local cps=SYS.GetBrainrotCPS(t)
if cps and cps<threshold then
table.insert(picks,{Name=t.Name,CPS=cps})
end
end
end
end
end
scan(LP.Character)
scan(LP:FindFirstChild("Backpack"))
table.sort(picks,function(a,b) return a.CPS<b.CPS end)
return picks,threshold
end
TT(task.spawn(function()
while not SYS.Unloaded do
task.wait(5)
if SYS.T_.AutoSell and not SYS.Unloaded then pcall(SYS.sellLowCPSTools) end
end
end))
end
do
local function FindHUD() return PG:FindFirstChild("HUD") end
local function ParseNum(v)
if typeof(v)=="number" then return v end
if type(v)~="string" then return nil end
local S={k=1e3,m=1e6,b=1e9,t=1e12,qa=1e15,qi=1e18,sx=1e21,sp=1e24,oc=1e27,no=1e30,dc=1e33}
local tx=v:gsub(",",""):gsub("%$",""):gsub("%s+"," ")
local raw=tx:match("[-+]?[%d%.]+[eE][-+]?%d+")
if raw then return tonumber(raw) end
local nt,sf=tx:match("([-+]?[%d%.]+)%s*([%a]+)")
if nt then
local n=tonumber(nt) if not n then return nil end
if sf then local m=S[sf:lower()] if m then return n*m end end
return n
end
return tonumber(tx:match("[-+]?[%d%.]+"))
end
SYS.FindHUD=FindHUD
local AFK={Kick=nil,Reb=nil,LastBonus=0,BonusWin=0,WTool=nil,WToolT=0}
SYS.AFK=AFK
task.spawn(function()
task.wait(2)
OnRemote("KickData",function(v) if typeof(v)=="number" then AFK.Kick=v end end)
OnRemote("RebirthUpdate",function(v) if typeof(v)=="number" then AFK.Reb=v end end)
end)
local kt,kv=0,0
function SYS.CurKick()
if type(AFK.Kick)=="number" then return AFK.Kick end
local now=os.clock()
if now-kt<0.5 then return kv end
kt=now
local h=FindHUD()
local bl=h and h:FindFirstChild("BottomLeft")
local kl=bl and bl:FindFirstChild("KickLevel")
local lb=kl and kl:FindFirstChild("TextLabel")
if lb and lb:IsA("TextLabel") then kv=ParseNum(lb.Text) or 0 end
return kv
end
local rt,rv=0,0
function SYS.CurReb()
if type(AFK.Reb)=="number" then return AFK.Reb end
local now=os.clock()
if now-rt<0.5 then return rv end
rt=now
local f=PG:FindFirstChild("Frames")
local r=f and f:FindFirstChild("Rebirth")
local l=r and r:FindFirstChild("RebirthLevel")
if l and l:IsA("TextLabel") then rv=math.max(0,math.floor(ParseNum(l.Text) or 0)) end
return rv
end
local CurKick=SYS.CurKick local CurReb=SYS.CurReb
local TrainThread
function SYS.StopTrain() if TrainThread then task.cancel(TrainThread) TrainThread=nil end end
function SYS.StartTrain()
SYS.StopTrain()
TrainThread=TT(task.spawn(function()
while not SYS.Unloaded and SYS.T_.AutoTrain do
local ch=LP.Character
if ch then
local h=ch:FindFirstChildOfClass("Humanoid")
if h then
local bp=LP:FindFirstChild("Backpack")
for _,ct in ipairs({bp,ch}) do
if ct then
for _,t in ipairs(ct:GetChildren()) do
if t:IsA("Tool") then
local ok,ht=pcall(function() return t:HasTag("SquatTool") end)
if ok and ht then P(function() h:EquipTool(t) end) break end
end
end
end
end
end
end
task.wait(math.max(0.5,SYS.C_.AutoTrainSec))
end
end))
end
local RebThread
local lastRebFire=0
function SYS.StopReb() if RebThread then task.cancel(RebThread) RebThread=nil end end
function SYS.StartReb()
SYS.StopReb()
RebThread=TT(task.spawn(function()
while not SYS.Unloaded and SYS.T_.AutoRebirth do
task.wait(SYS.C_.RebirthCheck)
if SYS.Unloaded or not SYS.T_.AutoRebirth then break end
local lv=CurReb() local pw=CurKick()
local now=os.clock()
if lv<10 and pw>=(10^(lv+3)) and now-(lastRebFire or 0)>5 then
lastRebFire=now
Fire("RebirthRequest") task.wait(2)
end
end
end))
end
local function liveMachines()
local r = {}
if not CS then return r end
local ok, t = pcall(CS.GetTagged, CS, "LiftMachine")
if not ok or type(t) ~= "table" then return r end
for _, m in ipairs(t) do
if m and m.Parent and m:IsDescendantOf(WS) then
table.insert(r, m)
end
end
return r
end
local function isDescFolder(o, n)
local p = o and o.Parent
while p do
if p.Name == n then return true end
p = p.Parent
end
return false
end
local function liftMachinePartScore(part)
if not part or not part:IsA("BasePart") then return -math.huge end
local name = tostring(part.Name or ""):lower()
local score = 0
if isDescFolder(part, "StandingPlatforms") then score = score + 1200 end
if isDescFolder(part, "Hitboxes") then score = score + 1100 end
if name:find("standing", 1, true) or name:find("platform", 1, true) or name:find("pad", 1, true) then score = score + 500 end
if name:find("hitbox", 1, true) or name:find("zone", 1, true) then score = score + 450 end
if name:find("lift", 1, true) or name:find("squat", 1, true) then score = score + 250 end
if part.Transparency >= 0.95 and not part.CanCollide then score = score + 80 end
if part.Size.X >= 3 and part.Size.Z >= 3 then score = score + 60 end
return score
end
local function liftMachineCandidateParts(machine)
local candidates = {}
local seen = {}
local function add(part)
if part and part:IsA("BasePart") and part.Parent and not seen[part] then
seen[part] = true
table.insert(candidates, { Part = part, Score = liftMachinePartScore(part) })
end
end
if not machine then return candidates end
if machine:IsA("BasePart") then add(machine)
elseif machine:IsA("Model") then add(machine.PrimaryPart) end
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
local score = liftMachinePartScore(descendant)
if score >= 200 then add(descendant) end
end
end
if #candidates == 0 then add(machine:FindFirstChildWhichIsA("BasePart", true)) end
table.sort(candidates, function(a, b) return a.Score > b.Score end)
return candidates
end
local function gymTargetPosition(part)
local _, hum, root = GC()
if not part or not root or not hum then return nil end
local isHitbox = isDescFolder(part, "Hitboxes")
or tostring(part.Name):lower():find("hitbox", 1, true)
or tostring(part.Name):lower():find("zone", 1, true)
if isHitbox then return part.Position end
local rootHalf = math.max(1, root.Size.Y * 0.5)
local yOffset = part.Size.Y * 0.5 + math.max(1.5, hum.HipHeight or 2) + rootHalf
return part.CFrame:PointToWorldSpace(Vector3.new(0, yOffset, 0))
end
local function moveToLiftMachinePart(part)
if not part or not part.Parent then return false end
local _, _, root = GC()
if not root or root.Anchored then return false end
local target = gymTargetPosition(part)
if not target then return false end
pcall(function()
local rot = root.CFrame - root.CFrame.Position
root.CFrame = CFrame.new(target) * rot
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
task.wait(0.16)
local _, _, newRoot = GC()
return newRoot ~= nil and (newRoot.Position - target).Magnitude <= 8
end
local function ensureGymTool()
local _, hum, _ = GC()
if not hum then return nil end
for _, t in ipairs(hum.Parent:GetChildren()) do
if t:IsA("Tool") and t:HasTag("SquatTool") then return t end
end
local bp = LP:FindFirstChild("Backpack")
local target
if bp then
for _, t in ipairs(bp:GetChildren()) do
if t:IsA("Tool") and t:HasTag("SquatTool") then target = t break end
end
end
if not target then return nil end
pcall(function() hum:UnequipTools() end)
task.wait(0.08)
for _ = 1, 3 do
pcall(function() hum:EquipTool(target) end)
task.wait(0.15)
if target.Parent == hum.Parent then return target end
end
return nil
end
local function waitLiftMachineRecognition(timeout)
local deadline = os.clock() + (timeout or 1.0)
while os.clock() < deadline do
local m = math.max(1, tonumber(LP:GetAttribute("liftMachine")) or 1)
if m > 1 then return true end
task.wait(0.03)
end
return false
end
local function enterGymMachine(machine)
if not machine or not machine.Parent then return false end
local candidates = liftMachineCandidateParts(machine)
if #candidates == 0 then return false end
local maximum = math.min(#candidates, 8)
for i = 1, maximum do
local part = candidates[i].Part
if moveToLiftMachinePart(part) then
if ensureGymTool() then
if waitLiftMachineRecognition(0.9) then
print("[Gym] ✅ 已进入 LiftMachine:", machine.Name)
return true
end
end
end
task.wait(0.05)
end
return false
end
local GymThread
function SYS.StartGym()
if GymThread then task.cancel(GymThread) GymThread = nil end
GymThread = TT(task.spawn(function()
while not SYS.Unloaded and SYS.T_.AutoGym do
local machines = liveMachines()
if #machines > 0 then
local _, _, root = GC()
local best, bestDist = nil, math.huge
for _, m in ipairs(machines) do
local pos
if m:IsA("Model") then
local ok, pivot = pcall(m.GetPivot, m)
if ok then pos = pivot.Position end
elseif m:IsA("BasePart") then
pos = m.Position
end
if pos and root then
local d = (root.Position - pos).Magnitude
if d < bestDist then bestDist = d best = m end
end
end
if best then
local m = math.max(1, tonumber(LP:GetAttribute("liftMachine")) or 1)
if m <= 1 then enterGymMachine(best) else ensureGymTool() end
end
end
task.wait(1)
end
end))
end
function SYS.StopGym()
if GymThread then task.cancel(GymThread) GymThread = nil end
end
local TrainingBonusButtonClicks = setmetatable({}, {__mode = "k"})
local function GuiVis(o)
if not o or not o:IsA("GuiObject") or not o.Visible then return false end
local p=o.Parent
while p do
if p:IsA("GuiObject") and not p.Visible then return false end
if p:IsA("ScreenGui") and not p.Enabled then return false end
p=p.Parent
end
return true
end
local function trainingMultiplierFromText(value)
local compact = tostring(value or ""):upper():gsub("%s+", ""):gsub("×", "X")
if compact == "X2" or compact == "2X" then return 2
elseif compact == "X5" or compact == "5X" then return 5
elseif compact == "X10" or compact == "10X" then return 10
end
return nil
end
local function trainingMultiplierForButton(button)
if not button or not button:IsA("GuiButton") then return nil end
if button:IsA("TextButton") then
local direct = trainingMultiplierFromText(button.Text)
if direct then return direct end
end
local ok, descendants = pcall(button.GetDescendants, button)
if ok and type(descendants) == "table" then
for _, child in ipairs(descendants) do
if child:IsA("TextLabel") or child:IsA("TextButton") then
local mult = trainingMultiplierFromText(child.Text)
if mult then return mult end
end
end
end
local parent = button.Parent
if parent and parent:IsA("GuiObject") then
local children = parent:GetChildren()
local parentName = tostring(parent.Name or ""):lower()
local buttonName = tostring(button.Name or ""):lower()
local likelyPopup = parentName:find("bonus", 1, true) or parentName:find("tavi", 1, true)
or parentName:find("mish", 1, true) or parentName:find("mult", 1, true)
or buttonName:find("bonus", 1, true) or buttonName:find("tavi", 1, true)
or buttonName:find("mish", 1, true)
if likelyPopup or #children <= 12 then
for _, child in ipairs(children) do
if child:IsA("TextLabel") or child:IsA("TextButton") then
local mult = trainingMultiplierFromText(child.Text)
if mult then return mult end
end
end
end
end
return nil
end
local function ClickBtn(b)
if not b or not b:IsA("GuiButton") or not b.Visible then return false end
if type(firesignal) == "function" then
local ok = P(firesignal, b.Activated)
if ok then return true end
end
if SYS.VIM then
local center = b.AbsolutePosition + b.AbsoluteSize * 0.5
local ok = P(function()
SYS.VIM:SendMouseMoveEvent(center.X, center.Y, game)
task.wait()
SYS.VIM:SendMouseButtonEvent(center.X, center.Y, 0, true, game, 0)
task.wait(0.025)
SYS.VIM:SendMouseButtonEvent(center.X, center.Y, 0, false, game, 0)
end)
if ok then return true end
end
return false
end
local function ScanBonus()
if not SYS.T_.AutoBonus or SYS.Unloaded then return 0 end
local now = os.clock()
if now - (AFK.LastBonus or 0) < 0.03 then return 0 end
AFK.LastBonus = now
local clicked = 0
local roots = {PG, SYS.CoreGui}
if gethui then table.insert(roots, gethui()) end
for _, root in ipairs(roots) do
if root then
local ok, list = pcall(function() return root:GetDescendants() end)
if ok and type(list) == "table" then
for _, obj in ipairs(list) do
if obj:IsA("GuiButton") and GuiVis(obj) then
local m = trainingMultiplierForButton(obj)
if m then
local last = TrainingBonusButtonClicks[obj] or 0
if now - last >= 0.20 then
TrainingBonusButtonClicks[obj] = now
if ClickBtn(obj) then
clicked = clicked + 1
task.delay(0.01, function()
if not SYS.Unloaded and SYS.T_.AutoBonus then
Fire("TaviMishkal")
end
end)
end
end
end
end
end
end
end
end
return clicked
end
SYS.ScanBonus = ScanBonus
task.spawn(function()
task.wait(2)
local r=SYS.REvent("TaviMishkal")
if not r then return end
T(r.OnClientEvent:Connect(function(m)
if not SYS.T_.AutoBonus or typeof(m)~="number" then return end
AFK.BonusWin=os.clock()+3
task.spawn(function()
task.wait(0.03)
if SYS.Unloaded or not SYS.T_.AutoBonus then return end
ScanBonus()
Fire("TaviMishkal")
end)
end))
end)
TT(task.spawn(function()
while not SYS.Unloaded do
if SYS.T_.AutoBonus then
local itv=os.clock()<AFK.BonusWin and 0.05 or 1.0
task.wait(itv)
if not SYS.Unloaded and SYS.T_.AutoBonus then P(ScanBonus) end
else
task.wait(0.5)
end
end
end))
end
do
local Spawn=Vector3.new(0,10,0)
local Rec=false
local autoIn={} local autoCool={}
local function tpStepChain(root,from,dir,total,n)
local i=0
local function one()
if not root or not root.Parent then return end
i=i+1
local target = (i>=n) and (from+dir*total) or (from+dir*(total*i/n))
root.CFrame=CFrame.new(target)
task.delay(i>=n and 0.05 or 0.02,function()
if root.Parent then root.CFrame=CFrame.new(target) end
end)
if i<n then task.delay(0.02,one) end
end
one()
end
function SYS.TPTo(pos)
local _,hum,root=GC() if not root then return false end
if SYS.C_.TPMethod~="CFrame" then
if hum then P(function() hum:MoveTo(pos) end) end
return true
end
local STEP=SYS.C_.TPMaxStep or 300
local from=root.Position
local d=pos-from
local dist=d.Magnitude
if dist<=STEP or dist<=0 then
root.CFrame=CFrame.new(pos)
task.delay(0.05,function() if root.Parent then root.CFrame=CFrame.new(pos) end end)
else
tpStepChain(root,from,d.Unit,dist,4)
end
return true
end
function SYS.TPToMouse()
local mouse=LP:GetMouse() if not mouse or not SYS.Cam then return end
local _,_,root=GC() if not root then return end
local ray=SYS.Cam:ScreenPointToRay(mouse.X,mouse.Y)
if SYS.C_.MouseTPMode=="Infinite" then
local ty=root.Position.Y
local d=ray.Direction
local tp
if d.Y<=-0.001 then
local t=math.clamp((ty-ray.Origin.Y)/d.Y,0,2000)
tp=ray.Origin+d*t
else
local hz=Vector3.new(d.X,0,d.Z)
if hz.Magnitude<1e-4 then hz=root.CFrame.LookVector end
tp=root.Position+hz.Unit*500
end
SYS.TPTo(Vector3.new(tp.X,ty+2,tp.Z))
else
local pa=RaycastParams.new()
local okFT,ft=pcall(function()
return Enum.RaycastFilterType.Exclude or Enum.RaycastFilterType.Blacklist
end)
pa.FilterType=(okFT and ft) or Enum.RaycastFilterType.Blacklist
pa.FilterDescendantsInstances={LP.Character}
local r=WS:Raycast(ray.Origin,ray.Direction*10000,pa)
if r and (r.Position-root.Position):Dot(ray.Direction)<0 then r=nil end
if not r then
r=WS:Raycast(root.Position+Vector3.new(0,2,0),ray.Direction*10000,pa)
end
if r then SYS.TPTo(r.Position+Vector3.new(0,2,0)) end
end
end
function SYS.TPToPlayer(p)
if typeof(p)=="Instance" and p:IsA("Player") and p.Character then
local r=p.Character:FindFirstChild("HumanoidRootPart")
if r then SYS.TPTo(r.Position+Vector3.new(0,2,0)) end
end
end
function SYS.TPToNearest()
local _,_,mr=GC() if not mr then return end
local best,bd=nil,math.huge
for _,p in ipairs(Players:GetPlayers()) do
if p~=LP and p.Character then
local r=p.Character:FindFirstChild("HumanoidRootPart")
if r then
local d=(r.Position-mr.Position).Magnitude
if d<bd then bd=d best=p end
end
end
end
if best then SYS.TPToPlayer(best) end
end
function SYS.AutoTPTick()
local _,_,root=GC() if not root then return end
local now=tick()
for i,s in ipairs(SYS.SavedPos) do
if s.autoTP then
local dist=(root.Position-s.position).Magnitude
if dist>SYS.C_.AutoTPDist then
local was=autoIn[i] local cool=autoCool[i] or 0
if was~=false or now-cool>0.5 then
P(SYS.TPTo,s.position+Vector3.new(0,2,0))
autoCool[i]=now
end
autoIn[i]=false
else autoIn[i]=true end
end
end
end
function SYS.GetDefSpawn() return Spawn end
function SYS.SetDefSpawn(v) Spawn=v end
function SYS.GetSpawnRec() return Rec end
function SYS.SetSpawnRec(v) Rec=v end
end
SYS.Combat={}
local CB=SYS.Combat
CB.Target=nil
CB.TargetPart=nil
CB.HookOK=false
CB.HookStat={cam=0,mouse=0,ray=0}
CB.RenderBound=false
CB.Moving=false
CB.FallbackConn=nil
CB.UsingFallback=false
CB.LastFire=0
CB.RenderName=SYS.N.Combat
local HUMC=setmetatable({},{__mode="k"})
local BODYC=setmetatable({},{__mode="k"})
CB.DeadAt={}
CB.DeadCh={}
CB.DeadTTL=8
CB.DeathHooked={}
CB.EnemyHolder=nil
local function hookDeathEvents(attempt)
attempt=attempt or 0
local _,rp=P(function() return game:GetService("ReplicatedStorage") end)
if not rp then return end
local function firstOf(par,...)
for i=1,select("#",...) do
local c=par:FindFirstChild(select(i,...))
if c then return c end
end
return nil
end
local R=firstOf(rp,"Remote","RemotesFolder","Remotes","RemoteEvents","Events","GameRemotes","Net","Shared")
if not R then
if attempt<40 then
SYS.TT(task.delay(2,function() P(hookDeathEvents,attempt+1) end))
else
warn("[CheatMenu] 80 秒内没等到任何 Remote 容器(Remote/RemotesFolder/Remotes/RemoteEvents/Events/Net/Shared) -> 死亡事件没订上(会退化回 Humanoid 判断)")
end
return
end
CB.DeathHookedSet=CB.DeathHookedSet or {}
local function sub(inst,label,mode)
if not inst then return end
if CB.DeathHookedSet[label] then return end
P(function()
if not inst.OnClientEvent then return end
T(inst.OnClientEvent:Connect(function(a,...)
local names={}
local function take(v)
if type(v)=="string" then names[#names+1]=v return end
if type(v)=="table" and type(v.Name)=="string" then names[#names+1]=v.Name return end
local ok,nm=pcall(function() return v.Name end)
if ok and type(nm)=="string" then names[#names+1]=nm end
end
take(a)
local rest={...}
for i=1,#rest do take(rest[i]) end
local valid={}
for i=1,#names do
local nm=names[i]
if Players and Players:FindFirstChild(nm) then valid[#valid+1]=nm end
end
if #valid>1 then valid={} end
for i=1,#valid do
local nm=valid[i]
if mode=="die" then
CB.DeadAt[nm]=os.clock()
local _dp=Players and Players:FindFirstChild(nm)
CB.DeadCh[nm]=_dp and _dp.Character or nil
if CB.Target and CB.Target.Name==nm then CB.Target=nil CB.TargetPart=nil end
else
CB.DeadAt[nm]=nil CB.DeadCh[nm]=nil
end
end
end))
CB.DeathHookedSet[label]=true
CB.DeathHooked[#CB.DeathHooked+1]=label
end)
end
local GS=R:FindFirstChild("GameService")
local ES=R:FindFirstChild("EntityService")
local AN=R:FindFirstChild("Any")
local function C(par,nm) return par and par:FindFirstChild(nm) or nil end
sub(C(GS,"Killed"), "GameService.Killed", "die")
sub(C(ES,"Died"),   "EntityService.Died",  "die")
sub(C(AN,"TouchDead"), "Any.TouchDead",    "die")
sub(C(AN,"Suicide"),   "Any.Suicide",      "die")
sub(C(GS,"Respawn"), "GameService.Respawn", "alive")
sub(C(GS,"Revive"),  "GameService.Revive",  "alive")
sub(C(ES,"Spawned"), "EntityService.Spawned", "alive")
local GC_=GS and GS:FindFirstChild("GameClient") or nil
sub(GC_ and GC_:FindFirstChild("Killed"), "GameService.GameClient.Killed", "die")
local FLAT_DIE  ={"PlayerDied","Died","Death","PlayerKilled","Killed","CharacterDied","OnDeath"}
local FLAT_ALIVE={"Revive","PlayerRevived","OnRevive","Respawn","PlayerRespawn","CharacterAdded","Spawned"}
local function flatScan(par,list,mode,tag)
if not par then return end
for i=1,#list do
local inst=par:FindFirstChild(list[i])
if inst then sub(inst,tag.."."..list[i],mode) end
end
end
flatScan(R,FLAT_DIE,"die","flat")    flatScan(rp,FLAT_DIE,"die","rs")
flatScan(R,FLAT_ALIVE,"alive","flat")flatScan(rp,FLAT_ALIVE,"alive","rs")
if #CB.DeathHooked==0 then
P(function()
local n=0
for _,o in ipairs(R:GetChildren()) do
n=n+1
if n>200 then break end
if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") or o:IsA("BindableEvent") then
local nm=o.Name:lower()
if nm:find("died",1,true) or nm:find("killed",1,true) or nm:find("death",1,true) then
sub(o,"kw."..o.Name,"die")
elseif nm:find("revive",1,true) or nm:find("respawn",1,true) then
sub(o,"kw."..o.Name,"alive")
end
end
end
end)
end
if #CB.DeathHooked==0 and attempt<40 then
SYS.TT(task.delay(2,function() P(hookDeathEvents,attempt+1) end))
end
end
function CB.GameSaysEnemy(pl)
local hh=CB.EnemyHolder
if not (hh and hh.Parent) then
local _,hl=P(function() return WS:FindFirstChild("Highlight") end)
local _,en=P(function() return hl and hl:FindFirstChild("Enemy") end)
local _,h2=P(function() return en and en:FindFirstChild("HighlightHolder") end)
hh=h2
CB.EnemyHolder=hh
end
if not (hh and hh.Parent) then return nil end
return hh:FindFirstChild(pl.Name)~=nil
end
local function humOf(pl)
local ch=pl and pl.Character
if not ch or ch.Parent==nil then return nil end
local h=ch:FindFirstChildOfClass("Humanoid")
if h then return h end
local c=HUMC[ch]
if c==false then return nil end
if c~=nil then
if c.Parent==nil then HUMC[ch]=nil return nil end
return c
end
local kids=ch:GetChildren()
local n=#kids
if n>40 then n=40 end
for i=1,n do
local d=kids[i]
if d and d.Parent then
local h2=d:FindFirstChildOfClass("Humanoid")
if h2 then HUMC[ch]=h2 return h2 end
end
end
HUMC[ch]=false
return nil
end
local function bodyOf(ch)
if not ch or ch.Parent==nil then return nil end
local b=ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso")
or ch:FindFirstChild("Torso") or ch:FindFirstChild("Head")
if b then return b end
if ch.PrimaryPart and ch.PrimaryPart.Parent then return ch.PrimaryPart end
local c=BODYC[ch]
if c==false then return nil end
if c~=nil then
if c.Parent==nil then BODYC[ch]=nil return nil end
return c
end
local kids=ch:GetChildren()
local n=#kids
if n>40 then n=40 end
for i=1,n do
local d=kids[i]
if d and d.Parent and d:IsA("BasePart") then
BODYC[ch]=d return d
end
end
BODYC[ch]=false
return nil
end
local function alive(pl)
local ch=pl and pl.Character
if not ch or ch.Parent==nil then return false end
local function attr(k)
local ok,v=pcall(function() return pl:GetAttribute(k) end)
return ok and v or nil
end
local st=attr("State")
if type(st)=="string" and st=="Dead" then return false end
local hp=attr("Health")
if type(hp)=="number" and hp<=0 then return false end
if type(st)=="string" and st~="Dead" and st~="" and type(hp)=="number" and hp>0 then
if CB.DeadAt[pl.Name] then CB.DeadAt[pl.Name]=nil CB.DeadCh[pl.Name]=nil end
end
local dt=CB.DeadAt[pl.Name]
if dt then
local dc=CB.DeadCh[pl.Name]
if dc==ch then
local h0=humOf(pl)
local st0
if h0 then local ok0,s0=pcall(function() return h0:GetState() end) if ok0 then st0=s0 end end
if (os.clock()-dt)>=(CB.DeadTTL or 8) and h0 and h0.Health>0
and st0~=Enum.HumanoidStateType.Dead and st0~=Enum.HumanoidStateType.Physics then
CB.DeadAt[pl.Name]=nil CB.DeadCh[pl.Name]=nil
else
return false
end
elseif dc~=nil then
CB.DeadAt[pl.Name]=nil CB.DeadCh[pl.Name]=nil
elseif (os.clock()-dt)>=(CB.DeadTTL or 8) then
CB.DeadAt[pl.Name]=nil
else
return false
end
end
local h=humOf(pl)
if h then
if h.Health<=0 then return false end
local ok,st2=pcall(function() return h:GetState() end)
if ok and (st2==Enum.HumanoidStateType.Dead or st2==Enum.HumanoidStateType.Physics) then return false end
if SYS.T_.CB_OnlyAlive and h.PlatformStand==true then return false end
return true
end
if SYS.T_.CB_OnlyAlive then return false end
if CB.GameSaysEnemy and CB.GameSaysEnemy(pl) then return true end
return bodyOf(ch)~=nil
end
local function hasShield(pl)
local ch=pl and pl.Character
local function attr(k)
local ok,v=pcall(function() return pl:GetAttribute(k) end)
return ok and v or nil
end
local sh=attr("Shield")
if type(sh)=="number" and sh>0 then return true end
local tsh=attr("TempShield")
if type(tsh)=="number" and tsh>0 then return true end
return (ch and ch:FindFirstChildOfClass("ForceField"))~=nil
end
local function partOf(pl,mode)
local ch=pl and pl.Character
if not ch then return nil end
local body=bodyOf(ch)
local hd=ch:FindFirstChild("Head")
if mode==1 then return hd or body end
if mode==3 then
local cam=SYS.Cam
if hd and body and cam and cam.CFrame then
local a,b=cam:WorldToViewportPoint(hd.Position),cam:WorldToViewportPoint(body.Position)
local vp=cam.ViewportSize
if vp and a and b then
local cx,cy=vp.X/2,vp.Y/2
local da=math.sqrt((a.X-cx)^2+(a.Y-cy)^2)
local db=math.sqrt((b.X-cx)^2+(b.Y-cy)^2)
return da<=db and hd or body
end
end
return hd or body
end
return body
end
local function playerFromPart(part)
if not part or part.Parent==nil then return nil end
local node=part
for _=1,12 do
local pl=Players:GetPlayerFromCharacter(node)
if pl then return pl end
node=node.Parent
if not node then break end
end
return nil
end
CB.NoTeamFilter=false
CB.NoFFFilter=false
CB.SelfHealAt=0
function CB.TeamKey(p)
if not p then return nil end
local ok,v=pcall(function() return p:GetAttribute("Team") end)
if ok and type(v)=="string" and v~="" then return v end
return p.Team and p.Team.Name or nil
end
function CB.TeamKeyUseful()
local now=os.clock()
if CB._tkAt and (now-CB._tkAt)<1 then return CB._tkVal==true end
CB._tkAt=now
local first,second=nil,false
local function feed(k)
if k==nil then return end
if first==nil then first=k elseif k~=first then second=true end
end
feed(CB.TeamKey(SYS.LP))
local pok=P(function()
for _,pl in ipairs(Players:GetPlayers()) do feed(CB.TeamKey(pl)) end
end)
CB._tkVal=(pok and second)==true
return CB._tkVal
end
local function isEnemyEx(pl,ignoreTeam,ignoreFF)
if not pl or pl==SYS.LP then return false end
if SYS.WL and not SYS.WL.Allow(pl.Name) then return false end
if not alive(pl) then return false end
if CB.GameSaysEnemy and CB.GameSaysEnemy(pl)==true then return true end
if not ignoreTeam and SYS.T_.CB_Team then
local mt=CB.TeamKey(SYS.LP) local pt=CB.TeamKey(pl)
if mt and pt and mt==pt and CB.TeamKeyUseful() then return false end
end
return true
end
local function isEnemy(pl) return isEnemyEx(pl,CB.NoTeamFilter,CB.NoFFFilter) end
function CB.RejectReason(pl)
if not pl then return "nil" end
if pl==SYS.LP then return "是自己" end
if not alive(pl) then
local ch=pl.Character
local h=ch and ch:FindFirstChildOfClass("Humanoid")
local function a(k)
local ok,v=pcall(function() return pl:GetAttribute(k) end)
return ok and v or nil
end
local st=a("State") local hp=a("Health") local dt=CB.DeadAt[pl.Name]
local reason
if type(st)=="string" and st=="Dead" then reason="Attribute @State==Dead" end
if not reason and type(hp)=="number" and hp<=0 then reason="Attribute @Health<=0" end
if not reason and dt then reason="死亡事件 DeadAt 仍生效(收到过 Killed/Died 信号)" end
if not reason then reason="Humanoid 判定(Health="..tostring(h and h.Health).." 或状态异常)" end
return ("已死亡/无角色 [%s] (角色=%s Humanoid=%s H.Health=%s @State=%s @Health=%s)"):format(
reason, tostring(ch~=nil), tostring(h~=nil), tostring(h and h.Health),
tostring(st), tostring(hp))
end
if hasShield(pl) then return "有无敌盾(ForceField) [打不掉血 → 最后才选]" end
if SYS.T_.CB_Team and SYS.LP.Team and pl.Team and SYS.LP.Team==pl.Team then
return "与我同队("..tostring(pl.Team and pl.Team.Name)..") [可被自动忽略]"
end
return nil
end
function CB.SelfHealFilters()
local now=os.clock()
if now-CB.SelfHealAt<1 then return end
CB.SelfHealAt=now
local others,ffc,teamc=0,0,0
for _,pl in ipairs(Players:GetPlayers()) do
if pl~=SYS.LP and alive(pl) then
others=others+1
if hasShield(pl) then ffc=ffc+1 end
do
local a=CB.TeamKey(SYS.LP) local b=CB.TeamKey(pl)
if a and b and a==b then teamc=teamc+1 end
end
end
end
if others==0 then return end
if (not CB.NoTeamFilter) and SYS.T_.CB_Team and teamc>=others then
CB.NoTeamFilter=true
CB.Say(("⚠ 全服 %d 个目标都与我同队 -> 该游戏不用队伍区分敌我, 「不打队友」本局已自动忽略"):format(others),SYS.CY.yellow)
end
end
local SHOT_CACHE=setmetatable({},{__mode="k"})
local RAY_HOPS=3
local RAY_FULL=nil
local function rayProbe()
if RAY_FULL~=nil then return RAY_FULL end
RAY_FULL=false
local ok=P(function()
return WS:FindPartOnRay(Ray.new(Vector3.new(0,0,0),Vector3.new(0,0.001,0)),nil,false,true)
end)
if ok then RAY_FULL=true end
SYS.RayFull=RAY_FULL
if not RAY_FULL then
warn("[CheatMenu] 本执行器的 Workspace:FindPartOnRay 不接受 4 参形态 -> 视线判定已自动降级为 2 参(与旧版一致)")
end
return RAY_FULL
end
local function castVis(o,d)
local dir=d.Unit
local cur=o
local left=d.Magnitude
local full=rayProbe()
for _=1,RAY_HOPS do
if left<1 then return nil end
local _,hit,hp
if full then
_,hit,hp=P(function()
return WS:FindPartOnRay(Ray.new(cur,dir*(left-1)),SYS.LP.Character,false,true)
end)
else
_,hit,hp=P(function()
return WS:FindPartOnRay(Ray.new(cur,dir*(left-1)),SYS.LP.Character)
end)
end
if hit==nil then return nil end
local tr=0 P(function() tr=hit.Transparency or 0 end)
if tr<0.25 then return hit end
if not hp then return hit end
local adv=(hp-cur).Magnitude
if adv<0.05 then return hit end
cur=hp+dir*0.05
left=left-adv
end
return nil
end
local function clearShot(part)
if not SYS.T_.CB_Wall then return true end
local now=os.clock()
local c=SHOT_CACHE[part]
if c and now-c.t<0.1 then return c.ok end
local cam=SYS.Cam
if not cam then return true end
local cf=cam.CFrame
if not cf then return true end
local o=cf.Position
local pts={part.Position}
local sz=part.Size
if sz then
local fx,fy,fz=sz.X*0.45,sz.Y*0.45,sz.Z*0.45
local c=part.Position
pts[#pts+1]=c+Vector3.new(0,fy,0)
pts[#pts+1]=c+Vector3.new(fx,0,0)
pts[#pts+1]=c+Vector3.new(-fx,0,0)
pts[#pts+1]=c+Vector3.new(0,0,fz)
pts[#pts+1]=c+Vector3.new(0,0,-fz)
pts[#pts+1]=c+Vector3.new(fx,fy,0)
pts[#pts+1]=c+Vector3.new(-fx,fy,0)
pts[#pts+1]=c+Vector3.new(0,fy,fz)
pts[#pts+1]=c+Vector3.new(0,fy,-fz)
end
local ok=false
for i=1,#pts do
local d=pts[i]-o
if d.Magnitude<1 then ok=true break end
local hit=castVis(o,d)
if hit==nil or (part.Parent and hit:IsDescendantOf(part.Parent)) then ok=true break end
end
SHOT_CACHE[part]={t=now,ok=ok}
return ok
end
local SCALP_CACHE=setmetatable({},{__mode="k"})
local function sightOK(part,o,q)
local d=q-o
if d.Magnitude<1 then return true end
local hit=castVis(o,d)
local par=part.Parent
return hit==nil or (par and hit:IsDescendantOf(par))
end
local function visPoint(part)
local c=part.Position
local cam=SYS.Cam
local o=cam and cam.CFrame and cam.CFrame.Position
if not o then return c end
if sightOK(part,o,c) then return c end
local now=os.clock()
local cc=SCALP_CACHE[part]
if cc and now-cc.t<0.12 then return cc.p end
local sz=part.Size
local cands={
c+Vector3.new(0,sz.Y*0.45,0),
c+Vector3.new(sz.X*0.45,0,0),
c-Vector3.new(sz.X*0.45,0,0),
c+Vector3.new(0,0,sz.Z*0.45),
c-Vector3.new(0,0,sz.Z*0.45),
}
local use=c
for i=1,#cands do
if sightOK(part,o,cands[i]) then use=cands[i] break end
end
SCALP_CACHE[part]={t=now,p=use}
return use
end
local BP_EPS=1e-9
local function bpIsZero(d) return (d>-BP_EPS and d<BP_EPS) end
local function bpCbrt(x)
return (x>0) and (x^(1/3)) or -((-x)^(1/3))
end
local function bpQuadric(c0,c1,c2)
if bpIsZero(c0) then return nil end
local p=c1/(2*c0)
local q=c2/c0
local D=p*p-q
if bpIsZero(D) then return -p end
if D<0 then return nil end
local sd=math.sqrt(D)
return sd-p,-sd-p
end
local function bpCubic(c0,c1,c2,c3)
if bpIsZero(c0) then return nil end
local A=c1/c0 local B=c2/c0 local C=c3/c0
local sqA=A*A
local p=(1/3)*(-(1/3)*sqA+B)
local q=0.5*((2/27)*A*sqA-(1/3)*A*B+C)
local cb_p=p*p*p
local D=q*q+cb_p
local s0,s1,s2=0,0,0
local num=0
if bpIsZero(D) then
if bpIsZero(q) then
s0=0 num=1
else
local u=bpCbrt(-q) s0=2*u s1=-u num=2
end
elseif D<0 then
local phi=(1/3)*math.acos(math.clamp(-q/math.sqrt(-cb_p),-1,1))
local t=2*math.sqrt(-p)
s0=t*math.cos(phi)
s1=-t*math.cos(phi+math.pi/3)
s2=-t*math.cos(phi-math.pi/3)
num=3
else
local sd=math.sqrt(D)
local u=bpCbrt(sd-q)
local v=-bpCbrt(sd+q)
s0=u+v num=1
end
local sub=(1/3)*A
if num>0 then s0=s0-sub else s0=nil end
if num>1 then s1=s1-sub else s1=nil end
if num>2 then s2=s2-sub else s2=nil end
return s0,s1,s2,num
end
local function bpQuartic(c0,c1,c2,c3,c4)
if bpIsZero(c0) then return nil end
local A=c1/c0 local B=c2/c0 local C=c3/c0 local D=c4/c0
local sqA=A*A
local p=-0.375*sqA+B
local q=0.125*sqA*A-0.5*A*B+C
local r=-(3/256)*sqA*sqA+0.0625*sqA*B-0.25*A*C+D
local out={}
local sub=0.25*A
if bpIsZero(r) then
out[#out+1]=-sub
local a,b,c=bpCubic(1,0,p,q)
if a then out[#out+1]=a-sub end
if b then out[#out+1]=b-sub end
if c then out[#out+1]=c-sub end
else
local z=bpCubic(1,-0.5*p,-r,0.5*r*p-0.125*q*q)
if not z then return nil end
local u=z*z-r
local v=2*z-p
if bpIsZero(u) then u=0 elseif u>0 then u=math.sqrt(u) else return nil end
if bpIsZero(v) then v=0 elseif v>0 then v=math.sqrt(v) else return nil end
local a1,a2=bpQuadric(1, q<0 and -v or v, z-u)
if a1 then out[#out+1]=a1-sub end
if a2 then out[#out+1]=a2-sub end
local b1,b2=bpQuadric(1, q<0 and v or -v, z+u)
if b1 then out[#out+1]=b1-sub end
if b2 then out[#out+1]=b2-sub end
end
if #out==0 then return nil end
return out
end
local function bpSolve(origin,speed,gravity,targetPos,targetVel)
if not (speed and speed>1) then return nil end
local disp=targetPos-origin
local p,q,r=targetVel.X,targetVel.Y,targetVel.Z
local h,j,k=disp.X,disp.Y,disp.Z
if not (gravity and gravity>0) then
local a=p*p+q*q+r*r-speed*speed
local b=2*(h*p+j*q+k*r)
local c=h*h+j*j+k*k
local t=nil
if math.abs(a)<BP_EPS then
if math.abs(b)>BP_EPS then
local t0=-c/b
if t0>BP_EPS then t=t0 end
end
else
local Dd=b*b-4*a*c
if Dd>=0 then
local sd=math.sqrt(Dd)
local t1=(-b-sd)/(2*a)
local t2=(-b+sd)/(2*a)
if t1>BP_EPS and (t==nil or t1<t) then t=t1 end
if t2>BP_EPS and (t==nil or t2<t) then t=t2 end
end
end
if not t then return nil end
return origin+Vector3.new((h+p*t)/t,(j+q*t)/t,(k+r*t)/t),t
end
local l=-0.5*gravity
local roots=bpQuartic(
l*l,
-2*q*l,
q*q-2*j*l-speed*speed+p*p+r*r,
2*j*q+2*h*p+2*k*r,
j*j+h*h+k*k
)
if not roots then return nil end
local t=nil
for i=1,#roots do
local v=roots[i]
if v>BP_EPS and (t==nil or v<t) then t=v end
end
if not t then return nil end
local d=(h+p*t)/t
local e=(j+q*t-l*t*t)/t
local f=(k+r*t)/t
return origin+Vector3.new(d,e,f),t
end
function CB.BallisticPoint(part,base)
if not part then return nil end
local cam=SYS.Cam
local o=cam and cam.CFrame and cam.CFrame.Position
if not o then return nil end
local v=part.AssemblyLinearVelocity
if not v then
local ok,r2=pcall(function() return part.Velocity end)
if ok then v=r2 end
end
if not v then v=Vector3.zero end
local speed=tonumber(SYS.C_.CB_ProjSpeed) or 100
local g=tonumber(SYS.C_.CB_ProjGrav)
if g==nil then g=(WS and WS.Gravity) or 196.2 end
local aim=bpSolve(o,speed,g,base or part.Position,v)
return aim
end
local function leadPos()
local p=CB.TargetPart
if not p then return nil end
local pos=visPoint(p)
if SYS.T_.CB_Ballistic then
local bp=CB.BallisticPoint(p,pos)
if bp then return bp end
end
if not SYS.T_.CB_Predict then return pos end
local t=SYS.C_.CB_PredictTime or 0.14
local v=p.AssemblyLinearVelocity
if not v then
local ok,r=pcall(function() return p.Velocity end)
if ok then v=r end
end
local lead=pos
if v then lead=lead+v*t end
local h=CB.Target and humOf(CB.Target)
if h and h.FloorMaterial==Enum.Material.Air then
local g=(WS and WS.Gravity) or 196.2
lead=lead+Vector3.new(0,-0.5*g*t*t,0)
end
return lead
end
local function enemyList()
local t={}
for _,pl in ipairs(Players:GetPlayers()) do
if isEnemy(pl) then t[#t+1]=pl end
end
return t
end
CB.Enemies=enemyList
function CB.Say(txt,col)
P(function() if SYS.Notify then SYS.Notify(tostring(txt),col or SYS.CY.green) end end)
print("[Combat] "..tostring(txt))
end
CB.BodyOf=bodyOf
function CB.TargetName()
local n=SYS.C_.CB_TargetName
return (type(n)=="string" and n~="") and n or nil
end
function CB.LockTarget(pl)
local n
if type(pl)=="string" then n=pl
elseif pl then n=pl.Name
else n=CB.Target and CB.Target.Name end
if not n or n=="" then return nil end
SYS.C_.CB_TargetName=n
SYS.C_.CB_TargetMode=2
return n
end
function CB.ClearTarget()
SYS.C_.CB_TargetName=""
SYS.C_.CB_TargetMode=1
end
function CB.CycleTarget(dir)
local list=enemyList()
if #list==0 then CB.Say("附近没有可选目标",SYS.CY.red) return nil end
local cur=CB.TargetName() or ""
local at=0
for i=1,#list do if list[i].Name==cur then at=i break end end
local n=#list
dir=dir or 1
at=(at==0) and 1 or (((at-1+dir)%n)+1)
SYS.C_.CB_TargetName=list[at].Name
SYS.C_.CB_TargetMode=2
CB.Say("指定目标 → "..list[at].Name,SYS.CY.yellow)
return list[at].Name
end
local CB_CHAINS={
[1]={"aiming","near","center"},
[2]={"near","center"},
[3]={"crosshair","near","center"},
[4]={"lowhp","near","center"},
[5]={"center","near"},
}
local function chainOrder(chain)
local slot=(chain[1]=="aiming") and 2 or 1
local o={}
for i=1,#chain do
if i==slot then o[#o+1]="specified" end
o[#o+1]=chain[i]
end
if slot>#chain then o[#o+1]="specified" end
return o
end
local function specResolve(mode)
if not (CB.TargetName() and (SYS.C_.CB_TargetMode or 1)==2) then return nil end
local pl=Players:FindFirstChild(CB.TargetName())
if pl and isEnemy(pl) and not (SYS.T_.CB_SkipFF and hasShield(pl)) then
local p=partOf(pl,mode)
if p and (not SYS.T_.CB_Wall or SYS.T_.CB_360 or (tonumber(SYS.C_.CB_ScanMs) or 33)<=0 or clearShot(p)) then return pl,p end
end
if (not pl) or (not alive(pl)) then
SYS.C_.CB_TargetName="" SYS.C_.CB_TargetMode=1
end
return nil
end
local CHAIN_NM={aiming="正在瞄我的",near="最近的",center="屏幕中心",crosshair="准星指向",lowhp="血量最低",specified="我指定的"}
function CB.ChainOrderNames()
local ch=CB_CHAINS[SYS.C_.CB_PrioMode or 1] or CB_CHAINS[1]
local o=chainOrder(ch)
local t={}
for i=1,#o do t[#t+1]=CHAIN_NM[o[i]] or o[i] end
local s=table.concat(t," → ")
if SYS.T_.CB_TgtStrict then s=s.."    ★「只打指定目标」开着: 实际只打指定的那个人, 整条链不参与" end
return s
end
local CB_PART_ORDER={
[1]={"Head","UpperTorso","Torso","LowerTorso","LeftUpperArm","RightUpperArm","Left Arm","Right Arm","LeftLowerArm","RightLowerArm","LeftHand","RightHand","LeftUpperLeg","RightUpperLeg","Left Leg","Right Leg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"},
[2]={"UpperTorso","Torso","LowerTorso","Head","LeftUpperArm","RightUpperArm","Left Arm","Right Arm","LeftLowerArm","RightLowerArm","LeftHand","RightHand","LeftUpperLeg","RightUpperLeg","Left Leg","Right Leg","LeftLowerLeg","RightLowerLeg","LeftFoot","RightFoot"},
[3]={"UpperTorso","Torso","Head","LowerTorso","LeftUpperArm","RightUpperArm","Left Arm","Right Arm","LeftLowerArm","RightLowerArm","LeftHand","RightHand","LeftUpperLeg","RightUpperLeg","Left Leg","Right Leg","LeftLowerLeg","RightLowerLeg"},
}
function CB.PickVisiblePart(pl,mode)
local ch=pl and pl.Character
if not ch then return nil end
local order=CB_PART_ORDER[mode] or CB_PART_ORDER[2]
for i=1,#order do
local p=ch:FindFirstChild(order[i])
if p and p:IsA("BasePart") and clearShot(p) then return p end
end
local hrp=bodyOf(ch)
local my=bodyOf(SYS.LP.Character)
if hrp and my and (hrp.Position-my.Position).Magnitude<=12 then
return partOf(pl,mode)
end
return nil
end
local function pickTarget()
local cam=SYS.Cam
if not cam then return nil,nil end
local mode=SYS.C_.CB_AimPart or 2
local cf0=cam.CFrame
if not cf0 then return nil,nil end
local camPos=cf0.Position
local maxD=SYS.C_.CB_MaxDist or 1200
local chain=CB_CHAINS[SYS.C_.CB_PrioMode or 1] or CB_CHAINS[1]
if SYS.T_.CB_TgtStrict and CB.TargetName() and (SYS.C_.CB_TargetMode or 1)==2 then
return specResolve(mode)
end
local vp=cam.ViewportSize
local cx,cy=vp.X/2,vp.Y/2
local myRoot=bodyOf(SYS.LP.Character)
local cands={}
for _,pl in ipairs(Players:GetPlayers()) do
if isEnemy(pl) then
local p=CB.PickVisiblePart(pl,mode)
if p then
local d=(p.Position-camPos).Magnitude
local _sh=hasShield(pl)
if (not (SYS.T_.CB_SkipFF and _sh)) and d<=maxD then
local sp,on=cam:WorldToViewportPoint(p.Position)
local inView=on and sp.Z>0
local dd=inView and math.sqrt((sp.X-cx)^2+(sp.Y-cy)^2) or 1e7
local aiming=false
local fc=bodyOf(pl.Character)
if fc and myRoot then
local dir=(myRoot.Position-fc.Position)
if dir.Magnitude>0.1 then
aiming=fc.CFrame.LookVector:Dot(dir.Unit)>0.72
end
end
local h=humOf(pl)
local hp=h and (h.Health or 1e9) or 1e9
local function aattr(k)
local ok,v=pcall(function() return pl:GetAttribute(k) end)
return ok and v or nil
end
local ahp=aattr("Health")
if type(ahp)=="number" then hp=ahp end
local ff=_sh
local ch2=pl.Character
local hasTool=ch2 and (ch2:FindFirstChildOfClass("Tool"))~=nil
local paused=aattr("combatPaused")
local canAttack = not (paused==true) and hasTool
cands[#cands+1]={
pl=pl,p=p,d=d,
s={aiming=(aiming and 0 or 1),near=d,center=dd,lowhp=hp},
ff=ff,armed=canAttack,
}
end
end
end
end
local order=chainOrder(chain)
local function pickBy(list,key)
local best=nil local bestk
for i=1,#list do
local c=list[i]
local v=c.s[key] or 1e18
local k0=(c.ff and 1e9 or 0)+v
if not best or k0<bestk then best=c bestk=k0 end
end
return best
end
for i=1,#order do
local key=order[i]
if key=="specified" then
local a,b=specResolve(mode)
if a then return a,b end
elseif key=="crosshair" then
if chain[1]=="crosshair" then
local okH,hit=P(function()
return WS:FindPartOnRay(Ray.new(camPos,cf0.LookVector*(maxD+50)),SYS.LP.Character)
end)
if okH and hit then
local hp=playerFromPart(hit)
if hp and isEnemy(hp) and not (SYS.T_.CB_SkipFF and hasShield(hp)) then
local pp=partOf(hp,mode)
if pp and (not SYS.T_.CB_Wall or SYS.T_.CB_360 or (tonumber(SYS.C_.CB_ScanMs) or 33)<=0
or SYS.T_.CB_SilentNoTurn or clearShot(pp)) then return hp,pp end
end
end
end
else
local pass={}
for j=1,#cands do
local c=cands[j]
if key=="aiming" then
if c.s.aiming==0 then pass[#pass+1]=c end
else
pass[#pass+1]=c
end
end
if #pass>0 then
if key=="aiming" then
local c=pickBy(pass,"near")
for j=1,#pass do
if pass[j].armed then return pass[j].pl,pass[j].p end
end
if c then return c.pl,c.p end
else
local c=pickBy(pass,key)
if c then return c.pl,c.p end
end
end
end
end
if #cands==0 then P(CB.SelfHealFilters) end
return nil,nil
end
local function aimTick()
if SYS.T_.CB_SilentNoTurn then return end
if not SYS.T_.CB_Aim then return end
if SYS.T_.CB_SnapFire then return end
if SYS.MenuOpen then return end
if CB.Moving then return end
local cam=SYS.Cam
if not cam or not CB.TargetPart then return end
local pos=leadPos()
if not pos then return end
local cf=cam.CFrame
if not cf then return end
local want=CFrame.lookAt(cf.Position,pos)
local spd=SYS.C_.CB_Smooth or 0.25
cam.CFrame = (spd>=1) and want or cf:Lerp(want,math.clamp(spd,0.02,1))
local root=bodyOf(SYS.LP.Character)
if root then
local rpos=root.Position
if (pos-rpos).Magnitude>0.01 then
local rwant=CFrame.lookAt(rpos,pos)
root.CFrame = (spd>=1) and rwant or root.CFrame:Lerp(rwant,math.clamp(spd,0.02,1))
end
end
end
function CB.InstallHook() CB.HookOK=false return false end
local function crosshairOnEnemy()
local cam=SYS.Cam
if not cam then return false end
local cf=cam.CFrame
if not cf then return false end
local dist=SYS.C_.CB_MaxDist or 1200
local _,part=P(function()
return WS:FindPartOnRay(Ray.new(cf.Position,cf.LookVector*(dist+50)),SYS.LP.Character)
end)
return isEnemy(playerFromPart(part))
end
local function fireTick()
if not SYS.T_.CB_Fire then return end
if SYS.MenuOpen then return end
local now=os.clock()
local fd=tonumber(SYS.C_.CB_FireDelay) or 0.06
local fireGap=(fd<=0) and 0 or (fd*(0.8+math.random()*0.4))
if now-CB.LastFire<fireGap then return end
local cam=SYS.Cam
if not cam then return end
local vp=cam.ViewportSize
local canFire
local zeroScan=(tonumber(SYS.C_.CB_ScanMs) or 33)<=0
local silo=(SYS.T_.CB_Silent or SYS.T_.CB_SilentAim or SYS.T_.CB_360 or SYS.T_.CB_SnapFire or zeroScan)
if SYS.T_.CB_Silent or SYS.T_.CB_Aim or SYS.T_.CB_SnapFire or SYS.T_.CB_360 then
local ap=CB.TargetPart and (leadPos() or CB.TargetPart.Position)
if not ap then return end
if silo or (SYS.C_.CB_Smooth or 0.25)>=1 then
canFire=true
else
local sp,on=cam:WorldToViewportPoint(ap)
if not (on and sp.Z>0) then return end
local tol=(vp.Y or 1080)*0.12
canFire=((sp.X-vp.X/2)^2+(sp.Y-vp.Y/2)^2)<=tol*tol
end
else
canFire = crosshairOnEnemy()
end
if not canFire then return end
local noTurn=SYS.T_.CB_SilentNoTurn
if (SYS.T_.CB_360 or SYS.T_.CB_SnapFire) and not noTurn then
local ap2=CB.TargetPart and (leadPos() or CB.TargetPart.Position)
if ap2 then
P(function() cam.CFrame=CFrame.lookAt(cam.CFrame.Position,ap2) end)
local root2=bodyOf(SYS.LP.Character)
if root2 then
local rp=root2.Position
if (ap2-rp).Magnitude>0.01 then
P(function() root2.CFrame=CFrame.lookAt(rp,ap2) end)
end
end
end
end
local thr=SYS.C_.CB_HpThr or 0
if thr>0 then
local h=CB.Target and humOf(CB.Target)
if not h or h.Health>thr then return end
end
CB.LastFire=now
local x,y=math.floor(vp.X/2),math.floor(vp.Y/2)
local function doFire()
P(function() VIM:SendMouseButtonEvent(x,y,0,true,game,0) end)
task.delay(0.02,function()
P(function() VIM:SendMouseButtonEvent(x,y,0,false,game,0) end)
end)
end
doFire()
end
local MOVING={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true}
local moveHeld={}
T(UIS.InputBegan:Connect(function(inp)
if MOVING[inp.KeyCode] then moveHeld[inp.KeyCode]=true end
end))
T(UIS.InputEnded:Connect(function(inp)
if MOVING[inp.KeyCode] then moveHeld[inp.KeyCode]=nil end
end))
local function movingNow()
if next(moveHeld)~=nil then return true end
return UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.A)
or UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.D)
end
local SCAN_DT=1/30
local accScan=0
CB.Stat={scan=0,hud=0,aim=0}
local function tickBody(dt)
dt=tonumber(dt) or 0.016
if dt>0.5 then dt=0.5 end
local me=humOf(SYS.LP)
if me and (me.Health or 1)<=0 then
local okS,st=pcall(function() return me:GetState() end)
if okS and (st==Enum.HumanoidStateType.Dead or st==Enum.HumanoidStateType.Physics) then
CB.Target=nil CB.TargetPart=nil
return
end
end
local anyOn=SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_Fire
or SYS.T_.CB_360 or SYS.T_.CB_SilentAim or SYS.T_.CB_BulletWall or SYS.T_.CB_SilentNoTurn
if not anyOn then
CB.Target=nil CB.TargetPart=nil
return
end
local scanMs=tonumber(SYS.C_.CB_ScanMs)
if scanMs==nil then scanMs=33 end
local scanDt=scanMs/1000
accScan=accScan+dt
if accScan>=scanDt then
accScan=0
CB.Stat.scan=CB.Stat.scan+1
CB.Moving = SYS.T_.CB_PauseMove and movingNow() or false
local t,p=pickTarget()
CB.Target=t CB.TargetPart=p
if not (SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_SnapFire) then fireTick() end
end
if SYS.T_.CB_Fire and (SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_SnapFire) then
fireTick()
CB.Stat.hud=CB.Stat.hud+1
end
aimTick()
CB.Stat.aim=CB.Stat.aim+1
if CB.meleeTick then CB.meleeTick() end
end
local CBERR=0
local function cbRenderTick(dt)
if SYS.Unloaded then return end
local ok,err=P(tickBody,dt)
if ok then
CBERR=0
return
end
CBERR=CBERR+1
CB.LASTERR=tostring(err)
if CBERR<=5 or CBERR%60==0 then
warn(("[Combat] tick 出错(第 %d 次): %s"):format(CBERR,tostring(err)))
end
if CBERR>=90 then
warn("[Combat] 连续报错, 已自动停止战斗模块(避免每帧刷错拖慢游戏)")
CB.Stop()
end
end
function CB.ResetClock()
accScan=0 CBERR=0
CB.Stat.scan=0 CB.Stat.hud=0 CB.Stat.aim=0
end
local function meleeCandidate(root)
local MD=SYS.C_.CB_MeleeDist or 9
local tp=CB.TargetPart
if tp then
local d=(tp.Position-root.Position).Magnitude
if d<=MD then return tp end
end
local best,bestD=nil,MD
for _,pl in ipairs(Players:GetPlayers()) do
if pl~=SYS.LP and isEnemyEx(pl) then
local ch=pl.Character
local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
local hum=ch and ch:FindFirstChildOfClass("Humanoid")
if hrp and hum and hum.Health>0 then
local dd=(hrp.Position-root.Position).Magnitude
if dd<=bestD then bestD=dd best=hrp end
end
end
end
return best
end
function CB.meleeTick()
if not SYS.T_.CB_Melee then return end
local root=bodyOf(SYS.LP.Character)
if not root then return end
local p=meleeCandidate(root)
if not p then return end
local d=(p.Position-root.Position).Magnitude
local MD=SYS.C_.CB_MeleeDist or 9
if d>MD then
CB.MeleeDoneFor=nil
return
end
if CB.MeleeDoneFor==p then return end
if CB.MeleeLockUntil and os.clock()<CB.MeleeLockUntil then return end
local now=os.clock()
if now-(CB.LastMelee or 0)<(SYS.C_.CB_MeleeGap or 0.35) then return end
CB.LastMelee=now
CB.MeleeDoneFor=p
CB.MeleeLockUntil=now+0.9
local function key(down)
P(function()
if SYS.VIM and SYS.VIM.SendKeyEvent then
SYS.VIM:SendKeyEvent(down,Enum.KeyCode.F,false,game)
end
end)
end
key(true)
task.delay(0.05,function()
key(false)
task.delay(0.25,function() key(false) end)
end)
task.delay(0.6,function()
if SYS.Unloaded or not SYS.T_.CB_Melee then return end
P(function()
local _,hum,r2=GC()
if not hum or not r2 then return end
local want=(SYS.Orig.WalkSpeed or 16)*(SYS.C_.SpeedMult or 1)
if hum.WalkSpeed<want*0.5 then
hum.WalkSpeed=want
print("[CheatMenu] 近战解卡: WalkSpeed 被清零, 已写回 "..tostring(want))
end
local ok,st=pcall(function() return hum:GetState() end)
if ok and st==Enum.HumanoidStateType.Physics and not SYS.T_.GodMode then
P(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
end
end)
end)
CB.Stat.melee=(CB.Stat.melee or 0)+1
end
function CB.Start()
if CB.RenderBound or SYS.Unloaded then return end
CB.ResetClock()
P(function() RS:UnbindFromRenderStep(CB.RenderName) end)
local ok=P(function()
RS:BindToRenderStep(CB.RenderName,Enum.RenderPriority.Camera.Value+1,cbRenderTick)
return true
end)
CB.UsingFallback=false
if not ok then
CB.FallbackConn=RS.RenderStepped:Connect(function(dt) cbRenderTick(dt) end)
CB.UsingFallback=true
warn("[Combat] 这台执行器不支持 BindToRenderStep, 已退回 RenderStepped(功能不变, 略费性能)")
end
CB.RenderBound=true
end
function CB.Stop()
if CB.RenderBound then
P(function() RS:UnbindFromRenderStep(CB.RenderName) end)
CB.RenderBound=false
end
if CB.FallbackConn then
P(function() CB.FallbackConn:Disconnect() end)
CB.FallbackConn=nil
end
CB.UsingFallback=false
CB.Target=nil CB.TargetPart=nil CB.Moving=false
CB.ResetClock()
end
function CB.DisableAll()
SYS.T_.CB_Aim=false SYS.T_.CB_Silent=false SYS.T_.CB_Fire=false
CB.Say("已关闭全部战斗功能",SYS.CY.red)
end
function CB.QuickMode()
SYS.T_.CB_Aim=true SYS.T_.CB_Fire=true
SYS.T_.CB_SnapFire=false SYS.T_.CB_Silent=false
SYS.T_.CB_Predict=true
SYS.C_.CB_PrioMode=1
SYS.C_.CB_Smooth=1 SYS.C_.CB_FireDelay=0.08
SYS.C_.CB_AimPart=1
P(SYS.QueueSave)
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
CB.Start()
CB.Say("⚡ 一键开战: 自动瞄准 + 自动开火 + 预测 + 锁头 + 优先链(正在瞄我的→指定→最近→屏幕中心)",SYS.CY.green)
print("[Combat] ⚡ 一键开战: 自动瞄准 + 自动开火 0.04s + 预测 + 锁头 + 优先链 1")
end
function CB.TestOnce()
local L={}
local function add(s) L[#L+1]=s end
add("========== 战斗: 立即测试一次 ==========")
if not CB.RenderBound then
CB.Start()
add("循环本来没在跑 -> 已经重新启动")
end
local list=CB.Enemies()
add(("可选敌人: %d 个"):format(#list))
CB.Moving = SYS.T_.CB_PauseMove and movingNow() or false
local t,p=pickTarget()
CB.Target=t CB.TargetPart=p
add(("选人结果: %s / 瞄准部位: %s")
:format(t and t.Name or "无", p and tostring(p.Name) or "无"))
local cam=SYS.Cam
if cam then
add(("相机类型: %s"):format(tostring(cam.CameraType)))
end
if SYS.T_.CB_Aim then
local before=cam and cam.CFrame
aimTick()
local moved=(cam and before and cam.CFrame~=before)
add(("自动瞄准: 开 -> 相机%s")
:format(moved and "已转向目标" or "没有变化(没有目标? 或正按着移动键暂停了?)"))
else
add("自动瞄准: 关 —— 打开「自动瞄准」开关才会转视角")
end
if SYS.T_.CB_Silent then
CB.InstallHook()
add(("静默瞄准: 开 -> hook %s")
:format(CB.HookOK and "已安装" or "装不上(这台执行器没有 hookfunction)"))
add("          只在游戏用【客户端射线】判定时有效; 服务端判定表现为'看着中了但不掉血'")
else
add("静默瞄准: 关")
end
if SYS.T_.CB_Fire then
local on=crosshairOnEnemy()
add(("自动开火: 开 -> 准星压在敌人身上=%s %s")
:format(tostring(on),
on and "" or "—— 瞄准关着时要求准星真压在敌人身上; 想无视准星就打开「自动瞄准」"))
else
add("自动开火: 关")
end
add("瞄准方式: "..(SYS.T_.CB_Aim and "自动瞄准(每帧把准星转到目标)" or "关闭")
.."   (静默瞄准 / 快照瞄准 已删除)")
add(("tick 错误计数: %d %s")
:format(CBERR, (CBERR>0 and (", 最后一条: "..tostring(CB.LASTERR)) or "")))
CB.Say(("测试: 可选敌人 %d · 选人 %s · tick错误 %d"):format(#list,t and t.Name or "无",CBERR),SYS.CY.cyan)
local txt=table.concat(L,"\n")
print(txt)
return txt
end
function CB.Diag()
local L={}
local function add(s) L[#L+1]=s end
add("========== CheatMenu 战斗诊断 ==========")
add(("循环运行: %s   回退模式: %s   tick错误计数: %d")
:format(tostring(CB.RenderBound), tostring(CB.UsingFallback), CBERR))
add(("调用频率(选人/瞄准/开火判定): %d / %d / %d 次")
:format(CB.Stat.scan, CB.Stat.aim, CB.Stat.hud))
add(("相机: %s   CameraType=%s")
:format(SYS.Cam and "有" or "无", SYS.Cam and tostring(SYS.Cam.CameraType) or "-"))
if SYS.Cam then
local cfd=SYS.Cam.CFrame
if not cfd then
add("   ⚠ 相机 CFrame 是 nil —— 这就是选不到目标的直接原因(相机被游戏接管/未就绪)")
else
local inn,outn=0,0
for _,pl in ipairs(Players:GetPlayers()) do
if pl~=SYS.LP and isEnemy(pl) and pl.Character then
local pd=bodyOf(pl.Character)
if pd then
local spd,on=SYS.Cam:WorldToViewportPoint(pd.Position)
if on and spd.Z>0 then inn=inn+1 else outn=outn+1 end
end
end
end
add(("视野内敌人 %d / 视野外 %d   (v65 起视野外也会兜底索到最近的)")
:format(inn,outn))
end
end
local list=CB.Enemies()
add(("可选敌人: %d 个"):format(#list))
for i=1,math.min(#list,8) do
local pl=list[i]
local ch=pl.Character
add(("   · %-20s 角色=%s Humanoid=%s 躯干=%s 头=%s 队伍=%s")
:format(tostring(pl.Name), tostring(ch~=nil), tostring(humOf(pl)~=nil),
tostring(ch and bodyOf(ch)~=nil), tostring(ch and ch:FindFirstChild("Head")~=nil),
tostring(pl.Team and pl.Team.Name or "nil")))
end
add(("过滤自愈状态: 队伍过滤忽略=%s  无敌盾过滤忽略=%s   (true = 本局自动放宽, 因为该条件把所有人都挡住了)")
:format(tostring(CB.NoTeamFilter),tostring(CB.NoFFFilter)))
for _,pl in ipairs(Players:GetPlayers()) do
if pl~=SYS.LP then
local rsn=CB.RejectReason(pl)
if rsn then add(("   ✗ %-20s 被挡: %s"):format(tostring(pl.Name),rsn)) end
end
end
add("   ↑ 若上面所有人都被挡, 就是索敌失败的根因(自愈会在 1 次扫描内放开它)")
add(("我的队伍: %s   队伍色: %s   (上面若全是 nil, 说明游戏不用标准队伍, 需要按它的方式加判断)")
:format(tostring(SYS.LP.Team and SYS.LP.Team.Name or "nil"), tostring(SYS.LP.TeamColor)))
add(("当前目标: %s   瞄准部位: %s")
:format(CB.Target and CB.Target.Name or "无",
CB.TargetPart and tostring(CB.TargetPart.Name) or "无"))
add(("指定目标: %s (模式=%s 严格=%s)")
:format(tostring(CB.TargetName()), tostring(SYS.C_.CB_TargetMode), tostring(SYS.T_.CB_TgtStrict)))
local _,chts=P(CB.ChainOrderNames)
add(("选人顺序: %s"):format(tostring(chts or "?")))
add(("开关: 瞄准=%s 静默=%s 开火=%s 移动保护=%s")
:format(tostring(SYS.T_.CB_Aim), tostring(SYS.T_.CB_Silent),
tostring(SYS.T_.CB_Fire), tostring(SYS.T_.CB_PauseMove)))
add(("快照限流: 角色写入 %d / 跳过(太快) %d / 跳过(角度过大) %d   [间隔>=%.2fs, 单次<=%.0f°]")
:format(CB.SnapWrite or 0,CB.SnapSkip or 0,CB.SnapBig or 0,
SYS.C_.CB_SnapMinGap or 0.25,SYS.C_.CB_SnapMaxAngle or 60))
add(("参数: FOV=%s 最大距离=%s 部位=%s 静默hook=%s")
:format(tostring(SYS.C_.CB_Fov), tostring(SYS.C_.CB_MaxDist),
tostring(SYS.C_.CB_AimPart), tostring(CB.HookOK)))
add(("执行器能力: hookfunction=%s  getrawmetatable=%s   (静默瞄准需要它们)")
:format(tostring(type(hookfunction)=="function"),
tostring(type(getrawmetatable)=="function")))
add(("hook 被游戏调用次数: 相机=%d  鼠标=%d  工作区=%d")
:format(CB.HookStat.cam, CB.HookStat.mouse, CB.HookStat.ray))
if CB.HookOK then
if SYS.T_.CB_Silent and CB.HookStat.cam==0 and CB.HookStat.mouse==0 and CB.HookStat.ray==0 then
add("   ⚠ 静默装了但游戏从没调用被 hook 的函数 -> 追踪/穿墙不会生效")
add("     打一枪再看; 若仍全 0 = 服务端判定命中, 客户端做不到, 只能自动瞄准")
else
do
local hn=#(CB.DeathHooked or {})
local hh=CB.EnemyHolder
add(("权威信号: 死亡事件订阅=%d 个%s | 游戏敌人容器=%s")
:format(hn, hn>0 and "" or "(这局没有这些事件, 只能靠血量判活)",
(hh and hh.Parent) and ("有, "..tostring(#(hh:GetChildren())).." 个敌人") or "无"))
end
if CB.HookStat.ray>0 then add("   ✓ 游戏用 Workspace 射线判定(服务端判定的游戏就是这一类)") end
if CB.HookStat.cam>0 then add("   · 游戏用相机射线") end
if CB.HookStat.mouse>0 then add("   · 游戏读鼠标 UnitRay") end
end
end
add(("tick 错误计数: %d %s")
:format(CBERR, (CBERR>0 and ("(最后一条: "..tostring(CB.LASTERR)..")") or "(没有报错)")))
add(("正在按移动键: %s   (移动保护靠它判断, 若恒为 false 说明按键检测不到)")
:format(tostring(CB.Moving)))
local cross=crosshairOnEnemy()
add(("准星压在敌人身上: %s   <- 自动开火只看这个"):format(tostring(cross)))
if SYS.T_.CB_Fire and not cross then
add("   ↑ 所以现在不开火: 把准星移到敌人身上, 或改用静默瞄准(它不看准星)")
end
local txt=table.concat(L,"\n")
print(txt)
return txt
end
T(UIS.InputBegan:Connect(function(inp)
if SYS.Unloaded then return end
if inp.KeyCode==(SYS.KeyCodeOf(SYS.C_.Key_CycleTarget) or Enum.KeyCode.V) then
local ok,r=P(function() return CB.CycleTarget(1) end)
print((ok and r) and ("[Combat] 指定目标 -> "..r) or "[Combat] 附近没有可选目标")
end
end))
T(RS.Heartbeat:Connect(function()
if SYS.Unloaded then return end
if SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_Fire then
CB.Start()
else
CB.Stop()
end
end))
function CB.MigrateV72()
if SYS.T_.CB_Silent then
SYS.T_.CB_Silent=false
print("[Combat] v74 迁移: 静默瞄准已删除 -> 已关闭")
end
if SYS.T_.CB_SnapFire then
SYS.T_.CB_SnapFire=false
print("[Combat] v77 迁移: 快照瞄准已删除 -> 已关闭")
end
if SYS.T_.CB_Wall==false then
SYS.T_.CB_Wall=true
print("[Combat] v75 迁移: 已打开「只打视野内」(穿墙/追踪已随静默瞄准删除)")
end
if SYS.T_.CB_OnlyAlive==false then
SYS.T_.CB_OnlyAlive=true
print("[Combat] v72 迁移: 已强制打开「只锁活人」(无 Humanoid 的模型不算活人, 治锁尸体)")
end
if (SYS.C_.CB_SnapMaxAngle or 60)==60 then SYS.C_.CB_SnapMaxAngle=360 end
if (SYS.C_.CB_SnapMinGap or 0.25)==0.25 then SYS.C_.CB_SnapMinGap=0.08 end
if (SYS.C_.CB_SnapDelay or 0.05)==0.05 then SYS.C_.CB_SnapDelay=0.03 end
if (SYS.C_.CB_FireDelay or 0.08)==0.06 then SYS.C_.CB_FireDelay=0.08 end
print(("[Combat] v72 参数: 单次转角上限=360° 最小间隔=%.2f 转向后延迟=%.2f 开火间隔=%.3f")
:format(SYS.C_.CB_SnapMinGap,SYS.C_.CB_SnapDelay,SYS.C_.CB_FireDelay))
end
P(CB.MigrateV72)
P(hookDeathEvents,0)
if SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_Fire then
CB.Start()
end
print("[CheatMenu] 战斗模块已加载 (菜单战斗页: 一键开战/停战 + 各开关 · 按 V 切换指定目标)")
local Trans={}
SYS.Trans=Trans
do
local HOST="http://127.0.0.1:8080"
local KEY="rk_4a56fc43faa5edb9f7a0cafd4ad3e91f"
local MODEL="hymt2-7b"
local function hostOf() return HOST end
local SILI_URL="https://api.siliconflow.cn/v1"
local SILI_KEY="sk-ooxveeyffgfpxpenjfgybrelrkcdbkxpyakjvoqzwduovdxe"
local SILI_MODEL="tencent/Hunyuan-MT-7B"
local SILI_MAXTOK=512
local SILI_MAXCONC=4
local SAMP_TEMP=0.1
local SAMP_TOP_P=0.6
local SAMP_TOP_K=20
local SAMP_REP_PEN=1.05
local SYS_PROMPT=[[Translate the following game UI text into Chinese.
Output ONLY the translation: no explanation, no quotes, no extra words, no added punctuation.
Preserve the original line breaks and the original number of lines.
Some characters in the input are opaque placeholder markers, not words. Copy every non-word marker character exactly as it appears.
Keep numbers, emoji, URLs and player names unchanged.
Use natural, colloquial, native-sounding Chinese — plain and direct, no stiff or literary wording.
Translate game terms CONSISTENTLY (same English term -> the same Chinese term every time):
Coins->金币, Gold->金币, Cash->金币, Gems->宝石, XP->经验, Level->等级, HP->生命, MP->法力,
Loot->战利品, Kill->击杀, Death->死亡, Respawn->复活, Round->回合, Match->对局,
Objective->目标, Score->得分, Streak->连杀, Loadout->配装, Inventory->背包, Shop->商店,
Trade->交易, Quest->任务, Reward->奖励, Rank->段位, Damage->伤害, Shield->护盾,
Ammo->弹药, Reload->换弹, Headshot->爆头, Victory->胜利, Defeat->失败.
Currency symbols (\$, €, ¥) must ALWAYS be kept EXACTLY as-is, even standing alone: write "1,500 $", NEVER write "美元"/"欧元"/"人民币". The word Robux is kept as-is too.
If the text is already Chinese or contains CJK characters, output it unchanged.]]
Trans.LANG_PROMPT={en="English",zh="Chinese",ja="Japanese",ko="Korean",th="Thai",ru="Russian",ar="Arabic"}
local EMOTICONS="qaq|qwq|qoq|awa|owo|uwu|ovo|tvt|o_o|0_0|-_-|^_^|>_<|t_t|u_u|x_x|o3o|:3|:)|:(|:d|:p|xd|orz|otl|233|555|www|hhh|aaa"
local KEEPW="og|secret|mythic|legendary|epic|rare|uncommon|common|divine|celestial|exclusive|limited|godly|ultra|special|unique|hidden|ancient|eternal|transcendent|op"
local OUTCAP=12000
local SELFCAP=8000
local VERDICT_CAP=8000
local DYN_MAX=6000
local DYN_WIN=12
local DYN_HITS=4
local DYN_LEN=60
local T2O_CAP=2000
local RV_CAP=2000
local FAIL_BASE,FAIL_CAP,FAIL_MAXN=3,300,4000
local NET_STREAK_MAX,NET_GATE_S=3,4
local HOOK_MAX=1500
local HOOK_PER_SEC=40
local RETRY_MAX=5
local RETRY_GAP=0.1
local SCAN_GAP=0.5
local SCAN_IDLE=1
local WS_EVERY=10
local REQ_TIMEOUT=60
local MAX_TOK_FALLBACK=512
local PROMPT_FIELDS={"ActionText","ObjectText"}
Trans.LANGS={ {name="英语",code="en"},{name="中文",code="zh"},{name="日语",code="ja"},
{name="韩语",code="ko"},{name="泰语",code="th"},{name="俄语",code="ru"},
{name="阿拉伯语",code="ar"} }
function Trans.langName(c)
for _,l in ipairs(Trans.LANGS) do if l.code==c then return l.name end end
return c
end
Trans.SendLang="en"
Trans.cacheCount=0
Trans.Stats={hit=0,loc=0,fail=0,netfail=0,skip=0,sweepSkip=0,lat=0,latN=0,replaced=0,dyn=0,wait=0}
local WORD_TABLE={
["train"]="训练",["gym"]="健身房",["power"]="力量",["kick"]="踢击",["rebirth"]="重生",["reborn"]="重生",
["stamina"]="体力",["bonus"]="加成",["strength"]="力量",["damage"]="伤害",["energy"]="体力",["coin"]="金币",
["coins"]="金币",["gem"]="宝石",["gems"]="宝石",["robux"]="Robux",["rare"]="稀有",["epic"]="史诗",["common"]="普通",
["speed"]="速度",["luck"]="幸运",["exp"]="经验",["level"]="等级",["quest"]="任务",["shop"]="商店",["trade"]="交易",
["respawn"]="复活",["spawn"]="出生",["equip"]="装备",["buy"]="购买",["sell"]="出售",["upgrade"]="升级",["craft"]="制作",
["stats"]="属性",["skill"]="技能",["attack"]="攻击",["defense"]="防御",["health"]="生命值",["gold"]="金币",
["cash"]="现金",["pet"]="宠物",["pets"]="宠物",["hatch"]="孵化",["evolve"]="进化",["weapon"]="武器",["armor"]="护甲",
["lol"]="哈哈",["gg"]="打得漂亮",["wp"]="打得漂亮",["ty"]="谢谢",["thx"]="谢谢",["nice"]="不错",["afk"]="挂机",
["brb"]="马上回来",["omg"]="天啊",["help"]="帮助",["index"]="索引",["store"]="商店",["rebirths"]="重生",
["settings"]="设置",["acceleration"]="加速度",["achievement"]="成就",["aim"]="瞄准",["align"]="对齐",
["alliance"]="联盟",["amplitude"]="振幅",["anchor"]="锚点",["angle"]="角度",["angularvelocity"]="角速度",
["area"]="面积",["avatar"]="形象",["axis"]="轴",["back"]="返回",["badge"]="徽章",["beam"]="光束",["block"]="屏蔽",
["boolvalue"]="布尔值",["branch"]="分支",["bundle"]="礼包",["buoyancy"]="浮力",["camera"]="相机",["cancel"]="取消",
["cancollide"]="可碰撞",["canquery"]="可查询",["cantouch"]="可触摸",["character"]="角色",["chat"]="聊天",
["checkpoint"]="检查点",["circumference"]="周长",["claim"]="领取",["click"]="点击",["close"]="关闭",["codex"]="图鉴",
["collision"]="碰撞",["color"]="颜色",["colorsequence"]="颜色序列",["community"]="社区",["complete"]="完成",
["cone"]="圆锥",["configuration"]="配置",["confirm"]="确认",["connecting"]="连接中",["controller"]="手柄",
["controls"]="控制",["cooldown"]="冷却中",["crate"]="宝箱",["creator"]="创作者",["crouch"]="蹲下",["cube"]="立方体",
["cylinder"]="圆柱",["defeat"]="失败",["degree"]="度",["density"]="密度",["depth"]="深度",["deselect"]="取消选择",
["developer"]="开发者",["dialogue"]="对话",["diameter"]="直径",["discount"]="折扣",["distance"]="距离",["drag"]="拖动",
["drop"]="丢弃",["effect"]="效果",["elasticity"]="弹性",["equipped"]="已装备",["error"]="错误",["euler"]="欧拉",
["event"]="活动",["experience"]="体验",["expired"]="已过期",["explosion"]="爆炸",["failed"]="失败",["featured"]="精选",
["floatvalue"]="浮点",["folder"]="文件夹",["force"]="力",["fps"]="帧率",["free"]="免费",["frequency"]="频率",
["friction"]="摩擦",["friends"]="好友",["gradient"]="渐变",["graphics"]="图形",["gravity"]="重力",["grid"]="网格",
["heal"]="治疗",["heat"]="热量",["height"]="高度",["hitbox"]="命中框",["hot"]="热门",["hover"]="悬停",
["humanoid"]="人形",["hurtbox"]="受击框",["impulse"]="冲量",["incomplete"]="未完成",["inertia"]="惯性",
["intvalue"]="整数",["join"]="加入",["jump"]="跳跃",["keyboard"]="键盘",["language"]="语言",["leaderboard"]="排行榜",
["leave"]="离开",["length"]="长度",["lhello"]="你好",["lift"]="升力",["limited"]="限定",["loading"]="加载中",
["lobby"]="大厅",["locked"]="未解锁",["lore"]="传说",["maintenance"]="维护",["mana"]="法力",["map"]="地图",
["massless"]="无质量",["material"]="材质",["matrix"]="矩阵",["mesh"]="网格",["mission"]="任务",["mobile"]="移动端",
["model"]="模型",["momentum"]="动量",["mouse"]="鼠标",["move"]="移动",["music"]="音乐",["mute"]="静音",
["narration"]="旁白",["new"]="新",["next"]="下一步",["no"]="不",["notifications"]="通知",["numberrange"]="数字范围",
["numbersequence"]="数字序列",["numbervalue"]="数字值",["objective"]="目标",["objectvalue"]="对象值",
["official"]="官方",["ok"]="确定",["open"]="打开",["option"]="选项",["orientation"]="方向",["owned"]="已拥有",
["pan"]="平移",["particle"]="粒子",["party"]="队伍",["pc"]="电脑",["phase"]="相位",["ping"]="延迟",["place"]="场所",
["plane"]="平面",["play"]="开始",["popular"]="流行",["position"]="位置",["premium"]="高级",["pressure"]="压力",
["privacy"]="隐私",["progress"]="进度",["projectile"]="弹体",["prone"]="趴下",["quality"]="画质",
["quaternion"]="四元数",["radian"]="弧度",["radius"]="半径",["rank"]="段位",["rate"]="速率",["ready"]="准备就绪",
["recommended"]="推荐",["rect"]="矩形",["reflectance"]="反射率",["region"]="区域",["reload"]="换弹",["report"]="举报",
["resize"]="调整大小",["retry"]="重试",["reward"]="奖励",["rotate"]="旋转",["rotation"]="旋转",["round"]="回合",
["run"]="奔跑",["sale"]="促销",["scalar"]="标量",["scale"]="缩放",["scroll"]="滚动",["season"]="赛季",["select"]="选择",
["sensitivity"]="灵敏度",["server"]="服务器",["sfx"]="音效",["shoot"]="射击",["size"]="大小",["skip"]="跳过",
["snap"]="吸附",["sphere"]="球体",["spin"]="抽取",["status"]="状态",["stringvalue"]="字符串值",["subtitle"]="字幕",
["success"]="成功",["support"]="支持",["team"]="队伍",["temperature"]="温度",["terms"]="条款",["texture"]="纹理",
["thrust"]="推力",["tier"]="层级",["time"]="时间",["torque"]="扭矩",["touch"]="触摸",["trail"]="拖尾",
["transparency"]="透明度",["trending"]="趋势",["trigger"]="触发器",["unequip"]="卸下",["universe"]="宇宙",
["unlocked"]="已解锁",["update"]="更新",["use"]="使用",["value"]="值",["vector"]="向量",["velocity"]="速度",
["verified"]="已认证",["vibration"]="振动",["victory"]="胜利",["vip"]="贵宾",["volume"]="音量",["walk"]="行走",
["wavelength"]="波长",["wedge"]="楔形",["width"]="宽度",["work"]="工作",["yes"]="是",["zoom"]="缩放",["accept"]="接受",
["ammo"]="弹药",["apply"]="应用",["assist"]="助攻",["collect"]="收取",["combo"]="连击",["completed"]="已完成",
["daily"]="每日",["death"]="死亡",["deaths"]="死亡",["decline"]="拒绝",["delete"]="删除",["draw"]="平局",
["exit"]="退出",["friend"]="好友",["grenade"]="手雷",["headshot"]="爆头",["hp"]="生命",["info"]="信息",
["inventory"]="背包",["invite"]="邀请",["kills"]="击杀",["knife"]="刀",["load"]="读取",["match"]="对局",
["maxed"]="已满级",["medkit"]="医疗包",["menu"]="菜单",["message"]="消息",["missions"]="任务",["mp"]="法力",
["now"]="现在",["okay"]="确定",["options"]="选项",["paused"]="已暂停",["pistol"]="手枪",["quests"]="任务",
["quit"]="退出",["reconnecting"]="正在重连",["reset"]="重置",["resume"]="继续",["resumed"]="已继续",["rewards"]="奖励",
["rifle"]="步枪",["save"]="保存",["score"]="得分",["selected"]="已选择",["send"]="发送",["shield"]="护盾",
["shotgun"]="霰弹枪",["sniper"]="狙击枪",["spectate"]="观战",["spectating"]="观战中",["start"]="开始",["streak"]="连杀",
["tie"]="平局",["today"]="今天",["tomorrow"]="明天",["trading"]="交易中",["unlock"]="解锁",["unmute"]="取消静音",
["vote"]="投票",["waiting"]="等待中",["weapons"]="武器",["weekly"]="每周",["welcome"]="欢迎",
}
local PHRASE_TABLE={
["good game"]="打得漂亮",["well played"]="打得漂亮",["nice shot"]="好枪法",["thank you"]="谢谢",["anyone here"]="有人吗",
["join our discord"]="加入我们的 Discord",["click to buy"]="点击购买",["max value"]="最大值",["best value"]="最优值",
["add friend"]="加好友",["are you sure"]="确定吗",["are you sure?"]="确定吗？",["claim all"]="全部领取",
["collect all"]="全部收取",["coming soon"]="即将推出",["connection lost"]="连接断开",["daily reward"]="每日奖励",
["double kill"]="双杀",["game over"]="游戏结束",["good luck"]="祝你好运",["great job"]="干得好",
["insufficient funds"]="余额不足",["kill streak"]="连杀",["level required"]="等级不足",["level up"]="升级",
["loading..."]="加载中…",["max level"]="满级",["not enough coins"]="金币不足",["not enough gems"]="宝石不足",
["not ready"]="未准备",["open all"]="全部打开",["out of ammo"]="弹药耗尽",["out of stock"]="缺货",
["please wait"]="请稍候",["press any key"]="按任意键",["press space to continue"]="按空格继续",["respawn now"]="立即复活",
["sold out"]="已售罄",["start game"]="开始游戏",["team up"]="组队",["time left"]="剩余时间",["times up"]="时间到",
["triple kill"]="三杀",["upgrade all"]="全部升级",["weekly reset"]="每周重置",["welcome back"]="欢迎回来",
["you died"]="你已死亡",["you have been eliminated"]="你已被淘汰",["you lose"]="你输了",["you win"]="你赢了",
}
local NON_ASCII="[\128-\255]"
local utf8codes=(type(utf8)=="table" and type(utf8.codes)=="function") and utf8.codes or nil
local function scanScript(s)
local han,kana,hangul=false,false,false
if type(s)~="string" or s=="" then return han,kana,hangul end
if utf8codes then
local ok,iter,state,init=pcall(utf8codes,s)
if ok and type(iter)=="function" then
local ok2=pcall(function()
for _,cp in iter,state,init do
if (cp>=0x4E00 and cp<=0x9FFF) or (cp>=0x3400 and cp<=0x4DBF) or (cp>=0xF900 and cp<=0xFAFF) then han=true
elseif cp>=0x3040 and cp<=0x30FF then kana=true
elseif cp>=0xAC00 and cp<=0xD7AF then hangul=true end
end
end)
if ok2 then return han,kana,hangul end
end
end
local i=1
while true do
local b=s:byte(i)
if not b then break end
if b>=0xE4 and b<=0xE9 then han=true
elseif b==0xE3 then
local b2=s:byte(i+1)
if b2 then
if b2>=0x81 and b2<=0x83 then kana=true
elseif b2>=0x90 and b2<=0xBF then han=true end
end
elseif b>=0xEA and b<=0xED then hangul=true end
i=i+1
end
return han,kana,hangul
end
local function hasChinese(s)
if type(s)~="string" or s=="" then return false end
if not s:find(NON_ASCII) then return false end
local han,kana,hangul=scanScript(s)
return han and not kana and not hangul
end
local function hasKanaOrHangul(s)
local _,kana,hangul=scanScript(s)
return kana or hangul
end
local function hasForeign(s)
if type(s)~="string" or s=="" then return false end
if s:find("[A-Za-z]") then return true end
if not s:find(NON_ASCII) then return false end
local i=1
while true do
local b=s:byte(i)
if not b then break end
if b>=0xC0 then
if b>=0xE0 and b<=0xEF then return true end
if b>=0xD0 and b<=0xD1 then return true end
end
i=i+1
end
return false
end
Trans.hasChinese=hasChinese
Trans.hasKanaOrHangul=hasKanaOrHangul
local function stripRich(s)
if type(s)~="string" then return s end
return (s:gsub("<[^>]*>",""))
end
local function splitPrefix(text)
if type(text)~="string" then return "",text or "" end
local p1,c1=text:match("^(<font[^>]*>.-:</font>%s*)(.+)$")
if p1 and c1 and c1~="" then return p1,c1 end
local p3,c3=text:match("^(.-[:：]%s*)([^/%s].*)$")
if p3 and c3 and c3~="" and #p3<=40 and not text:match("^%a[%w%+%-%.]*://") then return p3,c3 end
return "",text
end
local function normalizeKey(text)
if type(text)~="string" then return text end
text=(text:gsub("<[^>]*>",""))
return ((text:gsub("^%s+","")):gsub("%s+$","")):lower()
end
local function trim(s) return (s:gsub("^%s+","")):gsub("%s+$","") end
local function plainReplace(s,from,to)
if type(s)~="string" or type(from)~="string" or from=="" then return s end
local i,j=s:find(from,1,true)
if not i then return s end
return s:sub(1,i-1)..tostring(to)..s:sub(j+1)
end
local function isHanCp(cp)
return (cp>=0x4E00 and cp<=0x9FFF) or (cp>=0x3400 and cp<=0x4DBF) or (cp>=0xF900 and cp<=0xFAFF)
end
local function splitSegments(s)
local segs={}
if type(s)~="string" or s=="" then return segs end
if utf8codes then
local ok,iter,state,init=pcall(utf8codes,s)
if ok and type(iter)=="function" then
local ok2=pcall(function()
local buf="" local bufHan=nil
for _,cp in iter,state,init do
local isHan=isHanCp(cp)
local ch=utf8.char(cp)
if bufHan==nil then bufHan=isHan buf=ch
elseif isHan==bufHan then buf=buf..ch
else segs[#segs+1]={text=buf,han=bufHan} buf=ch bufHan=isHan end
end
if buf~="" then segs[#segs+1]={text=buf,han=bufHan} end
end)
if ok2 and #segs>0 then return segs end
end
end
local n=#s local i=1
while i<=n do
local b=s:byte(i)
local isHan=(b~=nil and b>=0xE4 and b<=0xE9)
local j=i
if isHan then
while j<=n do local bj=s:byte(j) if bj and bj>=0xE4 and bj<=0xE9 then j=j+3 else break end end
else
while j<=n do local bj=s:byte(j) if bj and bj>=0xE4 and bj<=0xE9 then break end j=j+1 end
end
segs[#segs+1]={text=s:sub(i,j-1),han=isHan}
i=j
end
return segs
end
Trans.stripRich=stripRich
Trans.splitPrefix=splitPrefix
Trans.normalizeKey=normalizeKey
Trans.plainReplace=plainReplace
Trans.splitSegments=splitSegments
local function lookupLocal(text)
if SYS.T_.LocalPhrase==false then return nil end
if type(text)~="string" then return nil end
local _raw=trim(text)
local _num,_rest=_raw:match("^(%d[%d%.,eE%+%-%w]*)[%s]+(%a+)$")
if _num and _rest then
local _rv=WORD_TABLE[_rest:lower()] or PHRASE_TABLE[_rest:lower()]
if _rv then return _num.." ".._rv end
end
local k=trim(text) k=k:lower()
k=(k:gsub("[%p]+$",""))
if k=="" or #k>48 then return nil end
local v=WORD_TABLE[k] or PHRASE_TABLE[k]
if v then return v end
local k2=(k:gsub("^the ",""):gsub("^a ",""):gsub("^an ",""))
if k2~=k then return WORD_TABLE[k2] or PHRASE_TABLE[k2] end
return nil
end
Trans.lookupLocal=lookupLocal
Trans.Outputs={}
Trans.OutputsOld={}
Trans.OutputsN=0
local function markOutput(s)
if type(s)~="string" or s=="" or not hasChinese(s) then return end
if Trans.Outputs[s] or Trans.OutputsOld[s] then return end
if Trans.OutputsN>=OUTCAP then
Trans.OutputsOld=Trans.Outputs Trans.Outputs={} Trans.OutputsN=0
end
Trans.Outputs[s]=true
Trans.OutputsN=Trans.OutputsN+1
end
Trans.markOutput=markOutput
local function alreadyOurs(s) return type(s)=="string" and (Trans.Outputs[s]==true or Trans.OutputsOld[s]==true) end
Trans.alreadyOurs=alreadyOurs
local PlayerNames={} local PlayerNameCount=-1 local PlayerDirty=true local PlayerCheckN=0
local PLAYER_CHECK_EVERY=64
local function refreshPlayerNames()
local cnt=0
pcall(function()
for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
cnt=cnt+1
PlayerNames[p.Name:lower()]=true
PlayerNames[p.DisplayName:lower()]=true
end
end)
PlayerNameCount=cnt PlayerDirty=false
end
pcall(function()
T(game:GetService("Players").PlayerAdded:Connect(function() PlayerDirty=true task.defer(refreshPlayerNames) end))
T(game:GetService("Players").PlayerRemoving:Connect(function() PlayerDirty=true task.defer(refreshPlayerNames) end))
end)
local function isPlayerName(s)
if PlayerNameCount<0 or PlayerDirty then
refreshPlayerNames()
else
PlayerCheckN=PlayerCheckN+1
if PlayerCheckN>=PLAYER_CHECK_EVERY then
PlayerCheckN=0
if #game:GetService("Players"):GetPlayers()~=PlayerNameCount then refreshPlayerNames() end
end
end
return PlayerNames[s:lower()]==true
end
local DynByObj=setmetatable({},{__mode="k"})
Trans.Dyn={}
Trans.DynN=0
local function dynNorm(s)
if type(s)~="string" or s=="" then return "" end
return ((s:lower():gsub("%d+","#")):gsub("%s+"," "))
end
local function dynMark(nk)
if nk=="" or Trans.Dyn[nk] then return end
if Trans.DynN>=DYN_MAX then Trans.Dyn={} Trans.DynN=0 end
Trans.Dyn[nk]=true Trans.DynN=Trans.DynN+1
end
local function dynNote(obj,text)
if SYS.T_.TransDyn==false then return end
if not obj or type(text)~="string" or text=="" or #text>DYN_LEN then return end
local now=os.clock()
local e=DynByObj[obj]
if not e then DynByObj[obj]={last=text,t=now,n=0,keys={}} return end
if e.last==text then return end
if now-e.t>DYN_WIN then e.t=now e.n=0 e.keys={} end
e.last=text
e.n=e.n+1
local nk=dynNorm(text)
if nk~="" then e.keys[nk]=true end
if e.n>=DYN_HITS then
for k in pairs(e.keys) do dynMark(k) end
Trans.Stats.dyn=Trans.Stats.dyn+1
e.t=now e.n=0 e.keys={}
end
end
local function dynIsBlocked(s)
if Trans.DynN==0 then return false end
return Trans.Dyn[dynNorm(s)]==true
end
Trans.dynNorm=dynNorm Trans.dynMark=dynMark Trans.dynNote=dynNote Trans.dynIsBlocked=dynIsBlocked
Trans.Self={}
Trans.SelfOld={}
Trans.SelfN=0
local function markSelf(s)
if type(s)~="string" or s=="" then return end
if Trans.Self[s] or Trans.SelfOld[s] then return end
if Trans.SelfN>=SELFCAP then Trans.SelfOld=Trans.Self Trans.Self={} Trans.SelfN=0 end
Trans.Self[s]=true Trans.SelfN=Trans.SelfN+1
end
local function isSelf(s)
return type(s)=="string" and (Trans.Self[s]==true or Trans.SelfOld[s]==true)
end
Trans.markSelf=markSelf Trans.isSelf=isSelf
Trans.IsEmoticon=function(v)
if type(v)~="string" then return false end
local t=v:lower():gsub("%s+","")
if t=="" or #t>12 then return false end
for w in EMOTICONS:gmatch("[^|]+") do if t==w then return true end end
return false
end
Trans.KeepWords={}
for w in KEEPW:gmatch("[^|]+") do Trans.KeepWords[w]=true end
function Trans.shouldTranslate(s,isChat)
if type(s)~="string" then return false end
if alreadyOurs(s) then return false end
s=trim(s)
if s=="" or #s<2 then return false end
if isPlayerName(s) then return false end
if hasChinese(s) then return false end
if not hasForeign(s) then return false end
if s:match("^https?://%S+$") or s:match("^www%.%S+$") then return false end
if not s:find("[%w]") and not hasKanaOrHangul(s) then return false end
if Trans.IsEmoticon(s) then return false end
if Trans.KeepWords[s:lower()] then return false end
if not s:find("%a") then return false end
if dynIsBlocked(s) then return false end
return true
end
Trans.Verdict={}
local VerdictN=0
local function verdictOf(raw,isChat)
local key=(isChat and "c" or "u")..raw
local v=Trans.Verdict[key]
if v then return v end
v={}
local plain=stripRich(raw)
if Trans.isSelf(plain) then
v.skip=true
if VerdictN>=VERDICT_CAP then Trans.Verdict={} VerdictN=0 end
Trans.Verdict[key]=v VerdictN=VerdictN+1
return v
end
local core=select(2,splitPrefix(plain))
if core~="" then plain=stripRich(core) end
if plain=="" then
v.skip=true
elseif hasChinese(plain) then
local segs=splitSegments(plain)
local hasF=false
for _,seg in ipairs(segs) do
if not seg.han and Trans.shouldTranslate(seg.text,isChat) then hasF=true break end
end
if hasF then
v.mixed=true v.segs=segs v.plain=plain v.nk=normalizeKey(plain)
else
v.skip=true
end
elseif not Trans.shouldTranslate(plain,isChat) then
v.skip=true
else
v.plain=plain
v.nk=normalizeKey(plain)
v.loc=lookupLocal(plain)
end
if VerdictN>=VERDICT_CAP then Trans.Verdict={} VerdictN=0 end
Trans.Verdict[key]=v VerdictN=VerdictN+1
return v
end
Trans.verdictOf=verdictOf
local Cache={}
local MODEL_TAG="hymt2-7b-v70"
local CFG=SYS.N.Cache
local HAS_FS=(type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function")
Trans.CACHE_FILE=CFG
local function saveNow()
if not HAS_FS or not HS then return false end
local data={["__model__"]=MODEL_TAG}
local n=0
for k,v in pairs(Cache) do
if type(k)=="string" and type(v)=="string" and #v>0 then data[k]=v n=n+1 end
end
Trans.cacheCount=n
local ok,json=pcall(function() return HS:JSONEncode(data) end)
if not ok or type(json)~="string" then return false end
local p=Trans.CACHE_FILE
if type(renamefile)=="function" then
local ok1=pcall(function() writefile(p..".tmp",json) end)
if ok1 then pcall(function() renamefile(p..".tmp",p) end) end
else
if isfile and isfile(p) then pcall(function() writefile(p..".bak",readfile(p)) end) end
pcall(function() writefile(p,json) end)
end
return true
end
function Trans.saveCache()
if Trans.Unloaded then return false end
local ok,r=pcall(saveNow)
return ok and r
end
local pendingSave=false
function Trans.queueCacheSave()
if pendingSave or not HAS_FS then return end
pendingSave=true
task.delay(2,function() pendingSave=false if not Trans.Unloaded then Trans.saveCache() end end)
end
local function loadCache()
if not HAS_FS or not HS then return end
if not isfile(Trans.CACHE_FILE) then return end
local function apply(path,label)
local raw=readfile(path)
if type(raw)~="string" or raw=="" then return false,"空文件" end
local ok,d=pcall(function() return HS:JSONDecode(raw) end)
if not ok or type(d)~="table" then return false,"JSON 解析失败" end
local tag=d["__model__"]
if type(tag)=="string" and tag~=MODEL_TAG then
print("[Trans] 版本已变("..tag.." -> "..MODEL_TAG.."), 丢弃旧缓存")
Cache={} Trans.cacheCount=0
return true,nil
end
local n=0
for k,v in pairs(d) do
if type(k)=="string" and type(v)=="string" and #v>0 then
Cache[k]=v n=n+1
markOutput(v)
end
end
Trans.cacheCount=n
print("[Trans] 已加载 "..n.." 条缓存("..label..")")
return true,nil
end
local ok=pcall(function()
if not apply(Trans.CACHE_FILE,"主文件") then error("主缓存不可用") end
end)
if not ok then
local ok2=pcall(function()
if not isfile(Trans.CACHE_FILE..".bak") then error("无备份") end
if not apply(Trans.CACHE_FILE..".bak","备份") then error("备份不可用") end
end)
if not ok2 then print("[Trans] 缓存损坏且无备份, 以空缓存启动") end
end
end
function Trans.clearCache()
Cache={} Trans.cacheCount=0
Trans.Verdict={} VerdictN=0
Trans.Trans2Orig={} Trans.Orig2Trans={} T2O_N=0
Trans.Outputs={} Trans.OutputsOld={} Trans.OutputsN=0
Trans.Self={} Trans.SelfOld={} Trans.SelfN=0
Trans.Dyn={} Trans.DynN=0
Trans.WaitN=0 Trans.InflightN=0
Trans.clearAllFails()
pcall(function()
if type(delfile)=="function" then
for _,suf in ipairs({"",".bak",".tmp"}) do
if isfile and isfile(Trans.CACHE_FILE..suf) then delfile(Trans.CACHE_FILE..suf) end
end
end
end)
pcall(saveNow)
print("[Trans] 缓存已重置(内存+磁盘)")
task.spawn(function() pcall(Trans.forceRescan) end)
return true
end
local function maskSpecials(s)
if type(s)~="string" or s=="" then return s,{},0 end
local tok={} local n=0
local function prot(pat)
s=s:gsub(pat,function(m) n=n+1 tok[n]=m return "▮"..n.."▮" end)
end
prot("{{[^{}]-}}")
prot("{[^{}]-}")
prot("%%[-+0-9%.]*[sdifgxXoc]")
prot("%%%w+%%")
prot("</?[%a!][^>]*>")
prot("%[%/?%w+[^%]]*%]")
prot("%[%*%]")
prot("`[^`]+`")
prot("%*%*[^%*]+%*%*")
prot("%$%w+%$")
prot("%$%s*[%d%.,]+")
prot("[%d%.,]+%s*%$")
prot("#%x%x%x%x%x%x")
prot("[@#&!]%w+")
prot("%d+%.?%d*%%")
prot("%d+%.?%d*[eE][+-]?%d+")
prot("%d+%.?%d*[QSODNVT]%l")
prot("%d+%.?%d*[KMBT]")
prot("%d+%.?%d*%u%l?%u?%l?%u?%l?")
prot("\\.")
return s,tok,n
end
Trans.maskSpecials=maskSpecials
local function unmask(s,tok,n)
if type(s)~="string" then return s end
if tok and n and n>0 then
s=s:gsub("▮%s*(%d+)%s*▮",function(d) local i=tonumber(d) return (i and tok[i]) or "" end)
end
s=s:gsub("▮%s*%d+",""):gsub("%d+%s*▮","")
s=s:gsub("▮[^▮]*▮",""):gsub("▮","")
return s
end
Trans.unmask=unmask
Trans.Fail={}
Trans.FailN=0
local function failCool(key)
local f=Trans.Fail[key]
if not f then return 0 end
local c=FAIL_BASE*2^(f.n-1)
return c>FAIL_CAP and FAIL_CAP or c
end
local function inCool(key)
local f=Trans.Fail[key]
if not f then return false end
return (os.clock()-f.t)<failCool(key)
end
local function markFail(key)
if not key or key=="" then return end
local f=Trans.Fail[key]
if f then f.n=f.n+1 f.t=os.clock() return end
Trans.FailN=Trans.FailN+1
if Trans.FailN>FAIL_MAXN then
local dead={} local now=os.clock()
for k,g in pairs(Trans.Fail) do if (now-g.t)>=failCool(k) then dead[#dead+1]=k end end
for i=1,#dead do Trans.Fail[dead[i]]=nil end
Trans.FailN=0
end
Trans.Fail[key]={n=1,t=os.clock()}
end
local function clearFail(key) if key and Trans.Fail[key] then Trans.Fail[key]=nil end end
local function clearAllFails() Trans.Fail={} Trans.FailN=0 end
Trans.inCool=inCool Trans.clearFail=clearFail Trans.clearAllFails=clearAllFails
local NetStreak,NetGateUntil=0,0
local function netGateOn() return os.clock()<NetGateUntil end
local function noteNetFail()
NetStreak=NetStreak+1
if NetStreak>=NET_STREAK_MAX then NetGateUntil=os.clock()+NET_GATE_S end
end
local function noteNetOk() NetStreak=0 NetGateUntil=0 end
Trans.netGateOn=netGateOn
local function backend()
if SYS.T_.TransSili==true then
return SILI_URL,SILI_KEY,SILI_MODEL,SILI_MAXTOK,{temperature=SAMP_TEMP,top_p=SAMP_TOP_P,top_k=SAMP_TOP_K,repetition_penalty=SAMP_REP_PEN}
end
return HOST,KEY,MODEL,(Trans.maxTok or MAX_TOK_FALLBACK),{temperature=SAMP_TEMP,top_p=SAMP_TOP_P,top_k=SAMP_TOP_K,repeat_penalty=SAMP_REP_PEN}
end
local function rawRequest(body,system,temp,maxTok,noGate)
if type(request)~="function" then return nil,true end
local url,key,model,bMaxTok,samp=backend()
local masked,tok,tokN=maskSpecials(body)
local payload=HS:JSONEncode({
model=model,
messages={ {role="system",content=system}, {role="user",content=masked} },
temperature=temp or samp.temperature, top_p=samp.top_p, top_k=samp.top_k,
repetition_penalty=samp.repetition_penalty, repeat_penalty=samp.repeat_penalty,
max_tokens=maxTok or bMaxTok or MAX_TOK_FALLBACK, stream=false,
})
local ok,res=pcall(function()
return request({
Url=url.."/v1/chat/completions", Method="POST",
Headers={["Content-Type"]="application/json",["Authorization"]="Bearer "..key},
Body=payload, Timeout=REQ_TIMEOUT,
})
end)
if not ok or type(res)~="table" or not res.Body then
Trans.Stats.netfail=Trans.Stats.netfail+1
if not noGate then noteNetFail() end
return nil,true
end
local okd,d=pcall(function() return HS:JSONDecode(res.Body) end)
if not okd or type(d)~="table" then
Trans.Stats.netfail=Trans.Stats.netfail+1
if not noGate then noteNetFail() end
return nil,true
end
if not noGate then noteNetOk() end
local ch=d.choices
local c=type(ch)=="table" and ch[1]
local m=c and c.message
local v=m and m.content
if type(v)~="string" then return nil,false end
v=trim(unmask(v,tok,tokN))
if v=="" then return nil,false end
return v,false
end
local function tidy(res,src)
res=trim(stripRich(res))
if res=="" then return nil end
res=res:gsub("^%s*[Tt]ranslation%s*[:：]%s*","")
res=res:gsub("^%s*[Hh]ere is[^\n:：]*[:：]%s*","")
res=res:gsub("^%s*(翻译|译文|中文|汉化)%s*[:：]%s*","")
res=trim(res)
if res=="" then return nil end
if not hasChinese(src) and res:lower()==src:lower() then return nil end
if #src>=24 and #res>#src*3+60 then return nil end
return res
end
local function transPrompt() return SYS_PROMPT end
function Trans.promptFor(code)
local name=Trans.LANG_PROMPT[code] or Trans.langName(code)
return ("Translate the following game UI text into %s.\n"
.."Output ONLY the translation: no explanation, no quotes, no extra words, no added punctuation.\n"
.."Preserve the original line breaks and the original number of lines.\n"
.."Some characters in the input are opaque placeholder markers, not words. Copy every non-word marker character exactly as it appears, in its original position, together with the digits attached to it. Never translate, drop, replace, renumber, merge or reorder them.\n"
.."Keep numbers, currency ($), emoji, URLs, placeholders and player names unchanged."):format(name)
end
function Trans.translate(text,prio)
if Trans.Unloaded then return nil end
if type(text)~="string" or text=="" then return nil end
text=trim(text)
if text=="" then return nil end
if alreadyOurs(text) then return nil end
if not Trans.shouldTranslate(text,false) then return nil end
local fixed=lookupLocal(text)
if fixed then
Cache[text]=fixed Cache[normalizeKey(text)]=fixed
Trans.Stats.hit=Trans.Stats.hit+1 Trans.Stats.loc=Trans.Stats.loc+1
Trans.queueCacheSave() markOutput(fixed)
return fixed
end
local nk=normalizeKey(text)
if Cache[text] then Trans.Stats.hit=Trans.Stats.hit+1 return Cache[text] end
if Cache[nk] then Cache[text]=Cache[nk] Trans.Stats.hit=Trans.Stats.hit+1 return Cache[nk] end
if type(request)~="function" or not HS then return nil end
if inCool(nk) or netGateOn() then return nil end
local t0=os.clock()
local res,netFail=rawRequest(text,transPrompt(),0.1,Trans.maxTok or MAX_TOK_FALLBACK)
if res then
local v=tidy(res,text)
if v then
Cache[text]=v Cache[nk]=v
Trans.cacheCount=Trans.cacheCount+1
Trans.Stats.lat=Trans.Stats.lat+(os.clock()-t0)
Trans.Stats.latN=Trans.Stats.latN+1
Trans.queueCacheSave()
clearFail(nk)
markOutput(v)
return v
end
end
markFail(nk)
if not netFail then Trans.Stats.fail=Trans.Stats.fail+1 end
return nil
end
Trans.RvCache={}
local RvN=0
function Trans.translateTo(text,code)
if Trans.Unloaded or type(text)~="string" then return nil end
text=trim(text)
if text=="" then return nil end
local c=code or "en"
if c=="zh" then return text end
if type(request)~="function" or not HS then return nil end
local key=c.."\1"..normalizeKey(text)
local hit=Trans.RvCache[key]
if hit then return hit end
if inCool(key) or netGateOn() then return nil end
local res=rawRequest(text,Trans.promptFor(c),0.1,Trans.maxTok or MAX_TOK_FALLBACK,true)
if not res then
markFail(key)
return nil
end
clearFail(key)
res=trim(res)
if res=="" or res==text then return nil end
Trans.RvCache[key]=res
RvN=RvN+1
if RvN>RV_CAP then Trans.RvCache={} RvN=0 end
return res
end
Trans.MaxConc=8
Trans.InflightN=0
Trans.WaitN=0
local Inflight={}
local WaitQ={}
local function runJob(key,text,prio,cbs)
Inflight[key]=cbs or {}
Trans.InflightN=Trans.InflightN+1
task.spawn(function()
local r=Trans.translate(text,prio)
Trans.InflightN=Trans.InflightN-1
local q=Inflight[key] Inflight[key]=nil
if q then for i=1,#q do pcall(q[i],r) end end
Trans.pumpQueue()
end)
end
function Trans.pumpQueue()
if Trans.WaitN<=0 or Trans.InflightN>=Trans.MaxConc then return end
local k,w=nil,nil
for kk,ww in pairs(WaitQ) do k,w=kk,ww break end
if not k then return end
WaitQ[k]=nil Trans.WaitN=Trans.WaitN-1
runJob(k,w.text,w.prio,w.cbs)
if Trans.WaitN>0 and Trans.InflightN<Trans.MaxConc then Trans.pumpQueue() end
end
function Trans.request(text,prio,cb)
if Trans.Unloaded or type(text)~="string" or text=="" then
if cb then pcall(cb,nil) end return
end
if alreadyOurs(text) or not Trans.shouldTranslate(text,false) then
if cb then pcall(cb,nil) end return
end
local nk=normalizeKey(text)
local hit=Cache[text] or Cache[nk] or lookupLocal(text)
if hit then
Trans.Stats.hit=Trans.Stats.hit+1
if cb then pcall(cb,hit) end
return
end
if inCool(nk) or netGateOn() then
if cb then pcall(cb,nil) end
return
end
local q=Inflight[nk]
if q then
if cb then q[#q+1]=cb end
return
end
local w=WaitQ[nk]
if w then
if cb then w.cbs[#w.cbs+1]=cb end
return
end
if Trans.InflightN>=Trans.MaxConc then
WaitQ[nk]={text=text,prio=prio,cbs=(cb and {cb}) or {}}
Trans.WaitN=Trans.WaitN+1
Trans.Stats.wait=Trans.WaitN
return
end
runJob(nk,text,prio,(cb and {cb}) or {})
end
Trans.Trans2Orig={}
Trans.Orig2Trans={}
local T2O_N=0
local function remember(raw,newText,plain,newPlain)
if newPlain=="" or plain=="" or newPlain==plain then return end
Trans.markSelf(newPlain) Trans.markSelf(newText)
if Trans.Trans2Orig[newPlain]==nil then
Trans.Trans2Orig[newPlain]=plain
T2O_N=T2O_N+1
if T2O_N>T2O_CAP then Trans.Trans2Orig={} T2O_N=0 end
end
Trans.Orig2Trans[plain]=newPlain
markOutput(newText)
end
local function writeProp(obj,field,raw,newText)
if not obj or not obj.Parent then return false end
local cur=obj[field]
if cur~=raw then return false end
Trans.markSelf(newText)
local np=stripRich(newText)
Trans.markSelf(np)
local _,ncore=splitPrefix(np)
if ncore~="" then Trans.markSelf(stripRich(ncore)) end
local ok=pcall(function() obj[field]=newText end)
if ok then
Trans.Stats.replaced=Trans.Stats.replaced+1
task.spawn(function()
for i=1,2 do
task.wait(i==1 and 0.08 or 0.25)
if not obj or not obj.Parent or Trans.Unloaded then return end
if obj[field]==raw then pcall(function() obj[field]=newText end) end
end
end)
end
return ok
end
function Trans.processMixed(obj,field,cur,v,isChat)
if not obj or not obj.Parent or Trans.Unloaded then return end
local targets={}
for _,seg in ipairs(v.segs) do
if not seg.han and Trans.shouldTranslate(seg.text,isChat) then
targets[#targets+1]=seg.text
end
end
if #targets==0 then return end
local results={}
local pending=#targets
local flushed=false
local function flush()
if flushed or pending>0 then return end
flushed=true
if not obj or not obj.Parent or Trans.Unloaded then return end
local ok,now=pcall(function() return obj[field] end)
if not ok or now~=cur then return end
local newText=cur
local changed=false
for _,frag in ipairs(targets) do
local r=results[frag]
if r and r~="" and r~=frag then
newText=plainReplace(newText,frag,r)
changed=true
end
end
if changed and newText~=cur then
if writeProp(obj,field,cur,newText) then
Trans.Stats.hit=Trans.Stats.hit+1
remember(cur,newText,v.plain,stripRich(newText))
end
end
end
for _,frag in ipairs(targets) do
local f=frag
local hit=Cache[f] or Cache[normalizeKey(f)] or lookupLocal(f)
if hit and hit~="" and hit~=f then
results[f]=hit
pending=pending-1
elseif Trans.reqOn(isChat) then
Trans.request(f,isChat and 1 or 3,function(res)
results[f]=res
pending=pending-1
flush()
end)
else
pending=pending-1
end
end
flush()
end
function Trans.isIgnored(obj)
if not obj then return false end
local o=obj
for _=1,4 do
if not o then break end
local ok,n=pcall(function() return o.Name end)
if ok and type(n)=="string" and Trans.IgnoreObjects[n] then return true end
local okp,p=pcall(function() return o.Parent end)
o=okp and p or nil
end
return false
end
local TextHooked=setmetatable({},{__mode="k"})
local TextRetry=setmetatable({},{__mode="k"})
local TextLastAt=setmetatable({},{__mode="k"})
local TextHookedN=0
local function onTextChanged(obj)
if Trans.Unloaded or not Trans.UIScanActive then return end
local okc,c0=pcall(function() return obj.Text end)
if okc and Trans.isSelf(c0) then return end
local now=os.clock()
local last=TextLastAt[obj]
if last and now-last<RETRY_GAP then return end
TextLastAt[obj]=now
local n=(TextRetry[obj] or 0)+1
TextRetry[obj]=n
if n>RETRY_MAX then return end
task.defer(function()
if Trans.Unloaded or not Trans.UIScanActive then return end
P(Trans.processLabel,obj,"ui")
end)
end
function Trans.HookText(obj)
if not obj then return false end
if TextHooked[obj] then return true end
if TextHookedN>=HOOK_MAX then return false end
local now=os.clock()
if not SYS._hkT or now-SYS._hkT>=1 then SYS._hkT=now SYS._hkN=0 end
SYS._hkN=(SYS._hkN or 0)+1
if SYS._hkN>HOOK_PER_SEC then return false end
local ok,conn=pcall(function()
return obj:GetPropertyChangedSignal("Text"):Connect(function() onTextChanged(obj) end)
end)
if ok and conn then
T(conn)
TextHooked[obj]=true
TextHookedN=TextHookedN+1
return true
end
return false
end
local function biText(plain,hit)
if not SYS.T_.TransBilingual then return hit end
if (not plain) or plain=="" or plain==hit then return hit end
return tostring(hit).." ("..tostring(plain)..")"
end
function Trans.processLabel(obj,source)
if not obj or not obj.Parent or Trans.Unloaded then return end
if Trans.isIgnored(obj) then return end
local ok,cur=pcall(function() return obj.Text end)
if not ok or type(cur)~="string" or cur=="" then return end
Trans.dynNote(obj,cur)
local isChat=(source=="chat")
local v=verdictOf(cur,isChat)
if v.skip then return end
if v.mixed then
Trans.processMixed(obj,"Text",cur,v,isChat)
return
end
local plain=v.plain
local hit=Cache[plain] or Cache[v.nk] or v.loc
if hit and hit~="" and hit~=plain then
local tr=biText(plain,hit)
local newText=(plain==cur) and tr or plainReplace(cur,plain,tr)
if writeProp(obj,"Text",cur,newText) then
Trans.Stats.hit=Trans.Stats.hit+1
remember(cur,newText,plain,hit)
end
return
end
if not Trans.reqOn(isChat) then return end
Trans.request(plain,isChat and 1 or 3,function(res)
if not res or res=="" then return end
if not obj or not obj.Parent or Trans.Unloaded then return end
local now=obj.Text
if now~=cur then return end
local tr=biText(plain,res)
local newText=(plain==cur) and tr or plainReplace(cur,plain,tr)
if writeProp(obj,"Text",cur,newText) then remember(cur,newText,plain,res) end
end)
end
Trans.PromptFields=PROMPT_FIELDS
local PromptHooked=setmetatable({},{__mode="k"})
local function processPrompt(p)
if not p or not p.Parent or Trans.Unloaded or not Trans.UIScanActive then return end
if Trans.isIgnored(p) then return end
if not PromptHooked[p] then
pcall(function()
local okA,ca=pcall(function() return p:GetPropertyChangedSignal("ActionText"):Connect(function() task.defer(processPrompt,p) end) end)
local okB,cb2=pcall(function() return p:GetPropertyChangedSignal("ObjectText"):Connect(function() task.defer(processPrompt,p) end) end)
if okA and ca then T(ca) end
if okB and cb2 then T(cb2) end
if okA and okB then PromptHooked[p]=true end
end)
end
for _,f in ipairs(PROMPT_FIELDS) do
local ok,t=pcall(function() return p[f] end)
if ok and type(t)=="string" and t~="" then
local v=verdictOf(t,false)
if v.mixed then
Trans.processMixed(p,f,t,v,false)
elseif not v.skip then
local plain=v.plain
local hit=Cache[plain] or Cache[v.nk] or v.loc
if hit and hit~="" and hit~=plain then
if writeProp(p,f,t,hit) then remember(t,hit,plain,hit) end
elseif Trans.reqOn(false) then
Trans.request(plain,3,function(res)
if not res or res=="" or not p.Parent or Trans.Unloaded then return end
local ok2,now=pcall(function() return p[f] end)
if not ok2 or now~=t then return end
if writeProp(p,f,t,res) then remember(t,res,plain,res) end
end)
end
end
end
end
end
local function uiBlocked(o)
local p=o
for d=1,12 do
if not p then break end
if d<=10 and p==SYS.ScreenGui then return true end
local nm=p.Name
if type(nm)=="string" and nm:lower():find("topbar",1,true) then return true end
p=p.Parent
end
return false
end
local function scanRoot(root,count)
if not root then return count end
local ok,ds=pcall(function() return root:GetDescendants() end)
if not ok or type(ds)~="table" then return count end
local t0=os.clock()
for i=1,#ds do
local o=ds[i]
local cls=o.ClassName
if cls=="TextLabel" or cls=="TextButton" then
if not uiBlocked(o) then
P(Trans.HookText,o)
Trans.processLabel(o,"ui")
count=count+1
end
elseif cls=="ProximityPrompt" then
processPrompt(o)
end
if i%120==0 then
if os.clock()-t0>0.003 then task.wait() t0=os.clock() end
end
end
return count
end
Trans.scanRoot=scanRoot
function Trans.worldNode(o)
if not o then return end
local cls=o.ClassName
if cls=="TextLabel" or cls=="TextButton" then
if not uiBlocked(o) then P(Trans.HookText,o) Trans.processLabel(o,"ui") end
elseif cls=="ProximityPrompt" then
processPrompt(o)
end
end
function Trans.forceRescan()
Trans.Verdict={} VerdictN=0
Trans.clearAllFails()
Trans.Dyn={} Trans.DynN=0
local n=0
n=scanRoot(SYS.PG,n)
if SYS.CoreGui then n=scanRoot(SYS.CoreGui,n) end
pcall(function() if gethui then n=scanRoot(gethui(),n) end end)
pcall(function() n=scanRoot(WS,n) end)
if Trans.ChatActive then pcall(Trans.scanChatOnce) end
print("[Trans] 强制重扫: 覆盖 "..n.." 个文本对象")
return n
end
function Trans.reqOn(isChat)
if isChat then return SYS.T_.TransChat==true end
return SYS.T_.TransUI==true
end
local uiLoop=nil
function Trans.startUIScan()
if Trans.UIScanActive then return end
Trans.UIScanActive=true
P(Trans.forceRescan)
if uiLoop then task.cancel(uiLoop) uiLoop=nil end
uiLoop=task.spawn(function()
while Trans.UIScanActive and not Trans.Unloaded do
task.wait(SCAN_GAP)
if Trans.UIScanActive then
local before=Trans.Stats.hit+Trans.Stats.replaced
local n=0
n=scanRoot(SYS.PG,n)
if SYS.CoreGui then n=scanRoot(SYS.CoreGui,n) end
pcall(function() if gethui then n=scanRoot(gethui(),n) end end)
if n==0 and before==Trans.Stats.hit+Trans.Stats.replaced then
Trans.Stats.sweepSkip=Trans.Stats.sweepSkip+1
task.wait(SCAN_IDLE)
end
Trans._w=(Trans._w or 0)+1
if Trans._w%WS_EVERY==0 then pcall(function() scanRoot(WS,0) end) end
end
end
end)
Trans.UIconns=Trans.UIconns or {}
print("[Trans] 界面翻译已启动 (PlayerGui/CoreGui/gethui + 世界3D + ProximityPrompt)")
end
function Trans.stopUIScan()
if not Trans.UIScanActive then return end
Trans.UIScanActive=false
if uiLoop then task.cancel(uiLoop) uiLoop=nil end
for _,c in ipairs(Trans.UIconns or {}) do P(DS,c) end
Trans.UIconns={}
Trans.restoreSource("ui")
print("[Trans] 界面翻译已停止")
end
local function isChatLabel(o)
local p=o
for _=1,8 do
if not p then break end
local n=tostring(p.Name):lower()
if n:find("chat") or n:find("bubble") or n:find("message") then return true end
p=p.Parent
end
return false
end
function Trans.scanChatOnce()
if not Trans.ChatActive or Trans.Unloaded then return 0 end
local n=0
local roots={SYS.PG,SYS.CoreGui}
for _,r in ipairs(roots) do
if r then
local ok,ds=pcall(function() return r:GetDescendants() end)
if ok and type(ds)=="table" then
for i=1,#ds do
local o=ds[i]
local cls=o.ClassName
if (cls=="TextLabel" or cls=="TextButton") and o.Parent and isChatLabel(o) then
Trans.processLabel(o,"chat")
n=n+1
end
end
end
end
end
return n
end
local oldOnIncoming=nil
function Trans.startChatListener()
if Trans.ChatActive then return end
Trans.ChatActive=true
local ok,TCS=pcall(function() return game:GetService("TextChatService") end)
if ok and TCS then
if oldOnIncoming==nil then oldOnIncoming=TCS.OnIncomingMessage end
TCS.OnIncomingMessage=function(msg)
local base=nil
if oldOnIncoming then
local okO,r=pcall(oldOnIncoming,msg)
if okO and typeof(r)=="Instance" and r:IsA("TextChatMessageProperties") then base=r end
end
if not Trans.ChatActive or Trans.Unloaded then return base end
local text=(msg and msg.Text) or ""
if text=="" then return base end
local _,core=splitPrefix(text)
local plain=stripRich(core)
if not Trans.shouldTranslate(plain,true) then return base end
local hit=Cache[plain] or Cache[normalizeKey(plain)] or lookupLocal(plain)
if hit then
Trans.Stats.hit=Trans.Stats.hit+1
local p=Instance.new("TextChatMessageProperties")
p.Text=hit
if msg and msg.PrefixText then p.PrefixText=msg.PrefixText end
markOutput(hit)
return p
end
Trans.request(plain,1,function(res)
if res and res~="" then
markOutput(res)
task.defer(function() if Trans.ChatActive and not Trans.Unloaded then pcall(Trans.scanChatOnce) end end)
end
end)
return base
end
end
task.spawn(function()
while Trans.ChatActive and not Trans.Unloaded do
task.wait(1.0)
if Trans.ChatActive then pcall(Trans.scanChatOnce) end
end
end)
print("[Trans] 聊天翻译已启动")
end
function Trans.stopChatListener()
Trans.ChatActive=false
pcall(function()
local ok,TCS=pcall(function() return game:GetService("TextChatService") end)
if ok and TCS then
if oldOnIncoming~=nil then TCS.OnIncomingMessage=oldOnIncoming else TCS.OnIncomingMessage=nil end
end
end)
Trans.restoreSource("chat")
print("[Trans] 聊天翻译已停止")
end
local function restoreIn(root)
if not root then return 0 end
local ok,ds=pcall(function() return root:GetDescendants() end)
if not ok or type(ds)~="table" then return 0 end
local n=0
for i=1,#ds do
local o=ds[i]
local cls=o.ClassName
if cls=="TextLabel" or cls=="TextButton" then
local ok2,cur=pcall(function() return o.Text end)
if ok2 and type(cur)=="string" and cur~="" then
local _,core=splitPrefix(cur)
local p=stripRich(core)
local orig=Trans.Trans2Orig[p]
if orig and orig~="" then
local nt=(p==cur) and orig or plainReplace(cur,p,orig)
if pcall(function() o.Text=nt end) then n=n+1 end
end
end
elseif cls=="ProximityPrompt" then
for _,f in ipairs(PROMPT_FIELDS) do
local ok3,t=pcall(function() return o[f] end)
if ok3 and type(t)=="string" and t~="" then
local orig=Trans.Trans2Orig[t]
if orig and orig~="" then
if pcall(function() o[f]=orig end) then n=n+1 end
end
end
end
end
end
return n
end
function Trans.restoreSource(source)
local n=0
n=n+restoreIn(SYS.PG)
if SYS.CoreGui then n=n+restoreIn(SYS.CoreGui) end
pcall(function() if gethui then n=n+restoreIn(gethui()) end end)
if source~="chat" then n=n+restoreIn(WS) end
Trans.Trans2Orig={} T2O_N=0
print("[Trans] 已还原原文 "..n.." 条")
return n
end
function Trans.restoreChatLive() return Trans.restoreSource("chat") end
function Trans.dumpFails()
local n,now=0,os.clock()
print("===== 翻译失败/退避清单 =====")
for k,f in pairs(Trans.Fail) do
n=n+1
local cool=failCool(k)
local left=cool-(now-f.t)
print(("[%d] 失败 %d 次  冷却 %.0fs  还剩 %.0fs  |  %s")
:format(n,f.n,cool,left>0 and left or 0,k:sub(1,60)))
end
print(("===== 共 %d 条 (动态文本已跳过 %d 类, 排队中 %d, 在途 %d) =====")
:format(n,Trans.DynN or 0,Trans.WaitN or 0,Trans.InflightN or 0))
return n
end
function Trans.dumpDyn()
local n=0
print("===== 已判定为动态文本(不再翻译) =====")
for k in pairs(Trans.Dyn) do n=n+1 print(("  [%d] %s"):format(n,k)) end
print(("===== 共 %d 类 ====="):format(n))
return n
end
function Trans.dumpPairs()
local n=0
print("===== 翻译对照表 (原文 -> 译文) =====")
for og,tr in pairs(Trans.Orig2Trans) do
n=n+1
print("["..n.."] "..tostring(og))
print("     -> "..tostring(tr))
end
print(("===== 共 %d 条 ====="):format(n))
return n
end
function Trans.checkLocal()
if SYS.T_.TransSili==true then return "online" end
local ok,res=pcall(function()
return request({Url=hostOf().."/health",Method="GET",Timeout=10})
end)
if ok and type(res)=="table" and res.StatusCode==200 then return "online" end
return "offline"
end
function Trans.probeServer()
if SYS.T_.TransSili==true then
Trans.SlotCtx=32768
Trans.Slots=SILI_MAXCONC
Trans.maxTok=SILI_MAXTOK
Trans.MaxConc=SILI_MAXCONC
print(("[Trans] 后端=硅基流动(%s): 并发上限 %d, 单次输出上限 %d token")
:format(SILI_MODEL,Trans.MaxConc,Trans.maxTok))
return true
end
local ok,res=pcall(function() return request({Url=hostOf().."/props",Method="GET",Timeout=10,
Headers={["Authorization"]="Bearer "..KEY}}) end)
if not ok or type(res)~="table" or not res.Body then return false end
local okd,d=pcall(function() return HS:JSONDecode(res.Body) end)
if not okd or type(d)~="table" then return false end
local slots=tonumber(d.total_slots) or 8
local ctx=tonumber(d.default_generation_settings and d.default_generation_settings.n_ctx) or 512
Trans.SlotCtx=ctx
Trans.Slots=slots
Trans.maxTok=math.max(128,math.min(512,ctx-512))
Trans.MaxConc=math.max(2,math.min(16,slots-2))
print(("[Trans] 服务器: %d 槽 × 每槽 %d ctx  ->  并发上限 %d, 单次输出上限 %d token")
:format(slots,ctx,Trans.MaxConc,Trans.maxTok))
return true
end
function Trans.sendToChat(text)
if not text or text=="" then return false,"空" end
local ok,TCS=pcall(function() return game:GetService("TextChatService") end)
if ok and TCS then
local cib=TCS:FindFirstChild("ChatInputBarConfiguration")
if cib and cib.TargetTextChannel then
if pcall(function() cib.TargetTextChannel:SendAsync(text) end) then return true end
end
local chans=TCS:FindFirstChild("TextChannels")
if chans then
local g=chans:FindFirstChild("RBXGeneral") or chans:FindFirstChildWhichIsA("TextChannel")
if g and pcall(function() g:SendAsync(text) end) then return true end
end
end
return false,"失败"
end
function Trans.smartSend(text)
if not text or text:gsub("%s","")=="" then return false,"空" end
text=trim(text)
local target=Trans.SendLang or "en"
local final=text
if target~="zh" and hasChinese(text) then
local r=Trans.translateTo(text,target)
if r then final=r end
end
return Trans.sendToChat(final)
end
function Trans.refreshLocalStatus() end
function Trans.Unload()
Trans.Unloaded=true
pcall(Trans.stopUIScan)
pcall(Trans.stopChatListener)
pcall(Trans.saveCache)
end
pcall(loadCache)
pcall(function() Trans.probeServer() end)
print("[Trans] ✅ 翻译模块 v120(分层重写) 已加载, 缓存="..tostring(Trans.cacheCount).." 条")
end
local CY={
bg=Color3.fromRGB(8,10,18), bg2=Color3.fromRGB(16,19,32),
panel=Color3.fromRGB(20,24,40), card=Color3.fromRGB(26,31,50),
card2=Color3.fromRGB(38,45,70), sub=Color3.fromRGB(148,156,180),
text=Color3.fromRGB(236,241,253), line=Color3.fromRGB(52,60,82),
cyan=Color3.fromRGB(56,180,255), green=Color3.fromRGB(64,214,138),
red=Color3.fromRGB(255,84,104), yellow=Color3.fromRGB(255,198,86),
orange=Color3.fromRGB(255,150,60), purple=Color3.fromRGB(170,120,255),
accent=Color3.fromRGB(56,180,255), accent2=Color3.fromRGB(170,120,255),
dark=Color3.fromRGB(6,8,14),
glow=Color3.fromRGB(80,200,255),
}
SYS.CY=CY
local UI={}
SYS.UI=UI
UI.Pages={}
UI.Defs={}
local function tw(o,t,props)
P(function()
TweenService:Create(o,TweenInfo.new(t or 0.18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),props):Play()
end)
end
UI.Tween=tw
function UI.Round(o,r)
local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=o return c
end
function UI.Stroke(o,col,t,trans)
local s=Instance.new("UIStroke")
s.Color=col or CY.line s.Thickness=t or 1 s.Transparency=trans or 0.6
s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=o return s
end
function UI.Grad(o,c1,c2,rot)
local g=Instance.new("UIGradient")
g.Color=ColorSequence.new(c1 or CY.card2,c2 or CY.card)
g.Rotation=rot or 90 g.Parent=o return g
end
function UI.NeonGrad(o)
local g=Instance.new("UIGradient")
g.Color=ColorSequence.new({
ColorSequenceKeypoint.new(0,Color3.fromRGB(56,180,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(170,120,255)),
ColorSequenceKeypoint.new(1,Color3.fromRGB(56,180,255)),
})
g.Parent=o return g
end
function UI.Shadow(o)
local s=Instance.new("UIStroke")
s.Color=CY.dark s.Thickness=3 s.Transparency=0.5
s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=o
return s
end
function UI.Hover(btn,onBg,offBg,stroke)
local base=offBg or CY.card
T(btn.MouseEnter:Connect(function()
tw(btn,0.12,{BackgroundColor3=onBg or CY.card2})
if stroke then tw(stroke,0.12,{Transparency=0.25}) end
end))
T(btn.MouseLeave:Connect(function()
tw(btn,0.12,{BackgroundColor3=base})
if stroke then tw(stroke,0.12,{Transparency=0.7}) end
end))
end
function UI.Label(parent,text,col)
local l=Instance.new("TextLabel")
l.Size=UDim2.new(1,0,0,24) l.BackgroundTransparency=1
l.Text=text or "" l.TextColor3=col or CY.text
l.Font=Enum.Font.GothamMedium l.TextSize=13
l.TextXAlignment=Enum.TextXAlignment.Left l.TextWrapped=true
l.Parent=parent return l
end
function UI.Section(parent,title,col)
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,30) row.BackgroundTransparency=1 row.Parent=parent
local bar=Instance.new("Frame")
bar.Size=UDim2.new(0,4,0,16) bar.Position=UDim2.new(0,0,0.5,-8)
bar.BackgroundColor3=col or CY.accent bar.BorderSizePixel=0 bar.Parent=row
UI.Round(bar,2)
local g=Instance.new("UIGradient")
g.Color=ColorSequence.new(col or CY.accent, CY.glow) g.Rotation=90 g.Parent=bar
local t=Instance.new("TextLabel")
t.Size=UDim2.new(1,-80,1,0) t.Position=UDim2.new(0,14,0,0)
t.BackgroundTransparency=1 t.Text=title or ""
t.TextColor3=col or CY.accent t.Font=Enum.Font.GothamBold t.TextSize=13
t.TextXAlignment=Enum.TextXAlignment.Left t.Parent=row
return row
end
function UI.Div(parent)
local f=Instance.new("Frame")
f.Size=UDim2.new(1,0,0,1) f.BackgroundColor3=CY.line
f.BackgroundTransparency=0.55 f.BorderSizePixel=0 f.Parent=parent
return f
end
function UI.Card(parent,h)
local card=Instance.new("Frame")
card.Size=UDim2.new(1,0,0,h or 100) card.BackgroundColor3=CY.card
card.BackgroundTransparency=1 card.BorderSizePixel=0 card.Parent=parent
UI.Round(card,12) UI.Grad(card,CY.card2,CY.card,90)
UI.Stroke(card,CY.line,1,0.7)
local inner=Instance.new("Frame")
inner.Size=UDim2.new(1,-20,1,-16) inner.Position=UDim2.new(0,10,0,8)
inner.BackgroundTransparency=1 inner.Parent=card
local lay=Instance.new("UIListLayout")
lay.Padding=UDim.new(0,6) lay.SortOrder=Enum.SortOrder.LayoutOrder lay.Parent=inner
return card,inner
end
function UI.Tip(parent,text,col)
local l=Instance.new("TextLabel")
l.Size=UDim2.new(1,0,0,30) l.BackgroundTransparency=1
l.Text=text or "" l.TextColor3=col or CY.sub
l.Font=Enum.Font.GothamMedium l.TextSize=11
l.TextXAlignment=Enum.TextXAlignment.Left l.TextWrapped=true l.Parent=parent
return l
end
function UI.Stat(parent,label,value,valCol)
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,22) row.BackgroundTransparency=1 row.Parent=parent
local l=Instance.new("TextLabel")
l.Size=UDim2.new(0.55,0,1,0) l.BackgroundTransparency=1
l.Text=label l.TextColor3=CY.sub l.Font=Enum.Font.GothamMedium l.TextSize=12
l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=row
local v=Instance.new("TextLabel")
v.Size=UDim2.new(0.45,-2,1,0) v.Position=UDim2.new(0.55,0,0,0)
v.BackgroundTransparency=1 v.Text=tostring(value or "-")
v.TextColor3=valCol or CY.text v.Font=Enum.Font.Code
v.TextSize=12 v.TextXAlignment=Enum.TextXAlignment.Right v.Parent=row
return row,v
end
function UI.Btn(parent,text,col,fn)
local b=Instance.new("TextButton")
local BH=_TOUCH and 46 or 40
b.Size=UDim2.new(1,0,0,BH) b.BackgroundColor3=col or CY.card
b.BackgroundTransparency=0.25 b.TextColor3=CY.text b.Text=text
b.Font=Enum.Font.GothamMedium b.TextSize=14
b.AutoButtonColor=false b.BorderSizePixel=0 b.Parent=parent
UI.Round(b,10)
local st=UI.Stroke(b,col or CY.line,1,0.7)
UI.Hover(b,Color3.new(
math.min(1,(col or CY.card).R*1.25+0.05),
math.min(1,(col or CY.card).G*1.25+0.05),
math.min(1,(col or CY.card).B*1.25+0.05)), col or CY.card, st)
T(b.MouseButton1Down:Connect(function() tw(b,0.06,{Size=UDim2.new(1,-8,0,BH-4)}) end))
T(b.MouseButton1Up:Connect(function() tw(b,0.10,{Size=UDim2.new(1,0,0,BH)}) end))
T(b.MouseButton1Click:Connect(function() P(fn) end))
return b
end
function UI.Switch(parent,label,key,onChange)
if not parent then return end
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,_TOUCH and 50 or 44) row.BackgroundColor3=CY.card
row.BackgroundTransparency=0.18 row.BorderSizePixel=0 row.Parent=parent
UI.Round(row,10) UI.Stroke(row,CY.line,1,0.75)
local lb=Instance.new("TextLabel")
lb.Size=UDim2.new(1,-84,1,0) lb.Position=UDim2.new(0,14,0,0)
lb.BackgroundTransparency=1 lb.Text=label lb.TextColor3=CY.text
lb.Font=Enum.Font.GothamMedium lb.TextSize=14
lb.TextXAlignment=Enum.TextXAlignment.Left lb.Parent=row
local sw=Instance.new("TextButton")
sw.Size=UDim2.new(0,48,0,26) sw.Position=UDim2.new(1,-60,0.5,-13)
sw.BackgroundColor3=SYS.T_[key] and CY.green or CY.card2
sw.BackgroundTransparency=0.15 sw.Text="" sw.AutoButtonColor=false
sw.BorderSizePixel=0 sw.Parent=row UI.Round(sw,13)
local swst=UI.Stroke(sw,SYS.T_[key] and CY.green or CY.line,1,0.4)
local knob=Instance.new("Frame")
knob.Size=UDim2.new(0,20,0,20) knob.Position=UDim2.new(0,3,0,3)
knob.BackgroundColor3=Color3.new(1,1,1) knob.BorderSizePixel=0
knob.Parent=sw UI.Round(knob,10)
local ksh=Instance.new("UIStroke")
ksh.Color=Color3.fromRGB(200,205,220) ksh.Thickness=1 ksh.Transparency=0.5
ksh.ApplyStrokeMode=Enum.ApplyStrokeMode.Border ksh.Parent=knob
local function refresh(animate)
local on=SYS.T_[key]==true
local pos=on and UDim2.new(1,-23,0,3) or UDim2.new(0,3,0,3)
if animate then tw(knob,0.16,{Position=pos}) else knob.Position=pos end
local col=on and CY.green or CY.card2
if animate then tw(sw,0.16,{BackgroundColor3=col}) else sw.BackgroundColor3=col end
if swst then
local scol=on and CY.green or CY.line
if animate then tw(swst,0.16,{Color=scol}) else swst.Color=scol end
end
end
refresh(false)
if onChange then SYS.SwitchOnChange[key]=onChange end
UI.Hover(row,CY.card2,CY.card)
T(sw.MouseButton1Click:Connect(function()
SYS.T_[key]=not SYS.T_[key] refresh(true) QueueSave()
if onChange then P(onChange,SYS.T_[key]) end
end))
SYS.BtnRefs[#SYS.BtnRefs+1]=function() refresh(false) end
return row
end
function UI.Slider(parent,label,min,max,step,get,set,fmt)
if not parent then return end
fmt=fmt or "%.1f"
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,56) row.BackgroundColor3=CY.card
row.BackgroundTransparency=0.18 row.BorderSizePixel=0 row.Parent=parent
UI.Round(row,10) UI.Stroke(row,CY.line,1,0.75)
local lb=Instance.new("TextLabel")
lb.Size=UDim2.new(1,-20,0,22) lb.Position=UDim2.new(0,14,0,6)
lb.BackgroundTransparency=1 lb.Text=label lb.TextColor3=CY.text
lb.Font=Enum.Font.GothamMedium lb.TextSize=13
lb.TextXAlignment=Enum.TextXAlignment.Left lb.Parent=row
local valL=Instance.new("TextLabel")
valL.Size=UDim2.new(0,90,0,22) valL.Position=UDim2.new(1,-104,0,6)
valL.BackgroundTransparency=1 valL.Text=string.format(fmt,get() or min)
valL.TextColor3=CY.accent valL.Font=Enum.Font.Code valL.TextSize=13
valL.TextXAlignment=Enum.TextXAlignment.Right valL.Parent=row
local bar=Instance.new("Frame")
bar.Size=UDim2.new(1,-28,0,7) bar.Position=UDim2.new(0,14,0,38)
bar.BackgroundColor3=CY.dark bar.BackgroundTransparency=0.2
bar.BorderSizePixel=0 bar.Parent=row UI.Round(bar,4)
local fill=Instance.new("Frame")
fill.Size=UDim2.new(0,0,1,0) fill.BackgroundColor3=CY.accent
fill.BorderSizePixel=0 fill.Parent=bar UI.Round(fill,4)
UI.Grad(fill,CY.accent2,CY.accent,0)
local knob=Instance.new("Frame")
knob.Size=UDim2.new(0,14,0,14) knob.Position=UDim2.new(0,-7,0.5,-7)
knob.BackgroundColor3=Color3.new(1,1,1) knob.BorderSizePixel=0
knob.AnchorPoint=Vector2.new(0,0) knob.Parent=bar UI.Round(knob,7)
local ksh=Instance.new("UIStroke")
ksh.Color=CY.accent ksh.Thickness=2 ksh.Transparency=0.2
ksh.ApplyStrokeMode=Enum.ApplyStrokeMode.Border ksh.Parent=knob
local function refresh()
local v=get() or min
local pct=(max-min)>0 and ((v-min)/(max-min)) or 0
fill.Size=UDim2.new(pct,0,1,0)
knob.Position=UDim2.new(pct,-7,0.5,-7)
valL.Text=string.format(fmt,v)
end
refresh()
local function proc(input)
local relX=input.Position.X-bar.AbsolutePosition.X
local pct=math.clamp(relX/bar.AbsoluteSize.X,0,1)
local raw=min+pct*(max-min)
local snapped=math.floor((raw-min)/step+0.5)*step+min
set(math.clamp(snapped,min,max)) refresh() QueueSave()
end
if not SYS._SlMove then
SYS._SlMove=T(UIS.InputChanged:Connect(function(input)
local h=SYS._SlActive
if not h or not input then return end
local ut=input.UserInputType
if ut==Enum.UserInputType.MouseMovement or ut==Enum.UserInputType.Touch then P(h,input) end
end))
SYS._SlDrop=T(UIS.InputEnded:Connect(function(input)
if not input then return end
local ut=input.UserInputType
if ut==Enum.UserInputType.MouseButton1 or ut==Enum.UserInputType.Touch then
local fin=SYS._SlRelease
SYS._SlActive=nil SYS._SlRelease=nil
if fin then P(fin) end
end
end))
end
T(bar.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1
or input.UserInputType==Enum.UserInputType.Touch then
SYS._SlActive=proc
SYS._SlRelease=function()
tw(knob,0.1,{Size=UDim2.new(0,14,0,14),Position=UDim2.new(knob.Position.X.Scale,-7,0.5,-7)})
end
proc(input)
tw(knob,0.1,{Size=UDim2.new(0,18,0,18),Position=UDim2.new(knob.Position.X.Scale,-9,0.5,-9)})
end
end))
UI.Hover(row,CY.card2,CY.card)
SYS.BtnRefs[#SYS.BtnRefs+1]=refresh
return row
end
function UI.Input(parent,label,placeholder,get,set)
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,_TOUCH and 50 or 44) row.BackgroundColor3=CY.card
row.BackgroundTransparency=0.18 row.BorderSizePixel=0 row.Parent=parent
UI.Round(row,10) UI.Stroke(row,CY.line,1,0.75)
local lb=Instance.new("TextLabel")
lb.Size=UDim2.new(0.42,0,1,0) lb.Position=UDim2.new(0,14,0,0)
lb.BackgroundTransparency=1 lb.Text=label lb.TextColor3=CY.text
lb.Font=Enum.Font.GothamMedium lb.TextSize=13
lb.TextXAlignment=Enum.TextXAlignment.Left lb.Parent=row
local tb=Instance.new("TextBox")
tb.Size=UDim2.new(0.58,-22,1,-14) tb.Position=UDim2.new(0.42,8,0.5,-7)
tb.BackgroundColor3=CY.panel tb.BackgroundTransparency=0.1
tb.TextColor3=CY.text tb.PlaceholderColor3=CY.sub
tb.PlaceholderText=placeholder or ""
tb.Text=tostring(get() or "") tb.Font=Enum.Font.Code tb.TextSize=13
tb.TextScaled=false tb.ClearTextOnFocus=false tb.BorderSizePixel=0 tb.Parent=row
UI.Round(tb,8) UI.Stroke(tb,CY.accent,1,0.6)
T(tb.FocusLost:Connect(function(enter) if enter then P(set,tb.Text) end end))
UI.Hover(row,CY.card2,CY.card)
return row,tb
end
function UI.Cycle(parent,label,opts,get,set)
if not parent then return end
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,_TOUCH and 50 or 44) row.BackgroundColor3=CY.card
row.BackgroundTransparency=0.18 row.BorderSizePixel=0 row.Parent=parent
UI.Round(row,10) UI.Stroke(row,CY.line,1,0.75)
local lb=Instance.new("TextLabel")
lb.Size=UDim2.new(1,-150,1,0) lb.Position=UDim2.new(0,14,0,0)
lb.BackgroundTransparency=1 lb.Text=label lb.TextColor3=CY.text
lb.Font=Enum.Font.GothamMedium lb.TextSize=14
lb.TextXAlignment=Enum.TextXAlignment.Left lb.Parent=row
local btn=Instance.new("TextButton")
btn.Size=UDim2.new(0,126,0,28) btn.Position=UDim2.new(1,-138,0.5,-14)
btn.BackgroundColor3=CY.panel btn.BackgroundTransparency=0.1
btn.Text=tostring(get() or opts[1]) btn.TextColor3=CY.accent
btn.Font=Enum.Font.GothamMedium btn.TextSize=13
btn.AutoButtonColor=false btn.BorderSizePixel=0 btn.Parent=row
UI.Round(btn,8) UI.Stroke(btn,CY.accent,1,0.55)
local lastClick=0
local function curIdx()
local c=get()
for i,o in ipairs(opts) do if o==c then return i end end
return 1
end
T(btn.MouseButton1Click:Connect(function()
local now=os.clock()
if now-lastClick<0.25 then return end
lastClick=now
local i=curIdx()
local v=opts[i%#opts+1]
btn.Text=v set(v) QueueSave()
tw(btn,0.12,{TextColor3=CY.green})
task.delay(0.18,function() P(function() tw(btn,0.2,{TextColor3=CY.accent}) end) end)
end))
UI.Hover(row,CY.card2,CY.card)
UI.Hover(btn,CY.card2,CY.panel)
SYS.BtnRefs[#SYS.BtnRefs+1]=function() btn.Text=tostring(get()) end
return row
end
function UI.Dropdown(parent,label,opts,get,set)
local function optList()
if type(opts)=="function" then return opts() or {} end
return opts or {}
end
local btn=Instance.new("TextButton")
btn.Size=UDim2.new(1,0,0,44) btn.BackgroundColor3=CY.card
btn.BackgroundTransparency=0.18 btn.TextColor3=CY.text
btn.Font=Enum.Font.GothamMedium btn.TextSize=14
btn.TextXAlignment=Enum.TextXAlignment.Left
btn.BorderSizePixel=0 btn.AutoButtonColor=false btn.Parent=parent
UI.Round(btn,10) UI.Stroke(btn,CY.line,1,0.75)
local pad=Instance.new("UIPadding") pad.PaddingLeft=UDim.new(0,14) pad.Parent=btn
local panel=nil
local function refresh()
if not btn.Parent then return end
btn.Text=label..":  "..tostring(get())
end
refresh()
SYS.BtnRefs[#SYS.BtnRefs+1]=refresh
local function close() if panel then panel:Destroy() panel=nil end end
T(btn.MouseButton1Click:Connect(function()
if panel then close() return end
local list=optList()
local ap=btn.AbsolutePosition
local asz=btn.AbsoluteSize
panel=Instance.new("ScrollingFrame")
panel.BackgroundColor3=CY.panel panel.BackgroundTransparency=0.02
panel.BorderSizePixel=0 panel.ZIndex=600
local sc=tonumber(SYS.LastUIScale) or 1
if not (sc>0) then sc=1 end
panel.Position=UDim2.fromOffset(ap.X/sc,(ap.Y+asz.Y+4)/sc)
panel.Size=UDim2.fromOffset(asz.X/sc,(math.min(#list,9)*30+10)/sc)
panel.CanvasSize=UDim2.fromOffset(0,(#list*30+10)/sc)
local psc=Instance.new("UIScale") psc.Scale=sc psc.Parent=panel
panel.ScrollBarThickness=3 panel.ScrollBarImageColor3=CY.accent
panel.Parent=SYS.ScreenGui
UI.Round(panel,10) UI.Stroke(panel,CY.accent,1,0.5)
local lay=Instance.new("UIListLayout") lay.Padding=UDim.new(0,2) lay.Parent=panel
local ppad=Instance.new("UIPadding")
ppad.PaddingTop=UDim.new(0,5) ppad.PaddingLeft=UDim.new(0,5)
ppad.PaddingRight=UDim.new(0,5) ppad.Parent=panel
for _,o in ipairs(list) do
local ob=Instance.new("TextButton")
ob.Size=UDim2.new(1,-10,0,28)
ob.BackgroundColor3=(tostring(get())==o) and CY.accent or CY.card
ob.BackgroundTransparency=0.25 ob.TextColor3=CY.text
ob.Text=o ob.Font=Enum.Font.GothamMedium ob.TextSize=13
ob.TextXAlignment=Enum.TextXAlignment.Left
ob.AutoButtonColor=false ob.BorderSizePixel=0 ob.Parent=panel
UI.Round(ob,7)
local op=Instance.new("UIPadding") op.PaddingLeft=UDim.new(0,10) op.Parent=ob
UI.Hover(ob,CY.card2,CY.card)
T(ob.MouseButton1Click:Connect(function() set(o) refresh() close() end))
end
if SYS.CloseActiveDropdown and SYS.CloseActiveDropdown~=close then
pcall(SYS.CloseActiveDropdown)
end
SYS.CloseActiveDropdown=close
end))
return btn
end
do
local NotifyList={}
function SYS.Notify(text,col)
local sg=SYS.ScreenGui
if not sg or not sg.Parent then return end
local base=60
for _,n in ipairs(NotifyList) do
n.Position=UDim2.new(1,-276,0,n.Position.Y.Offset+52)
end
local f=Instance.new("Frame")
f.Size=UDim2.new(0,260,0,46)
f.Position=UDim2.new(1,-276,0,base)
f.BackgroundColor3=col or CY.green
f.BackgroundTransparency=0.15 f.BorderSizePixel=0 f.Parent=sg
UI.Round(f,9) UI.Stroke(f,col or CY.green,1,0.5)
local l=Instance.new("TextLabel")
l.Size=UDim2.new(1,-14,1,0) l.Position=UDim2.new(0,7,0,0)
l.BackgroundTransparency=1 l.Text=text l.TextColor3=CY.text
l.Font=Enum.Font.GothamMedium l.TextSize=13
l.TextXAlignment=Enum.TextXAlignment.Left l.TextWrapped=true l.Parent=f
table.insert(NotifyList,f)
local ref=f
task.delay(3,function()
pcall(function() ref:Destroy() end)
for i,n in ipairs(NotifyList) do
if n==ref then table.remove(NotifyList,i) break end
end
for _,n in ipairs(NotifyList) do
local y=n.Position.Y.Offset
if y>base then n.Position=UDim2.new(1,-276,0,y-52) end
end
end)
end
end
do
local function Svc(n) local ok,v=pcall(function() return game:GetService(n) end) return ok and v or nil end
local SoundService=Svc("SoundService")
local UserGS=Svc("UserSettings")
function SYS.MiniBtn(parent,text,col,fn,w)
local b=Instance.new("TextButton")
b.Size=UDim2.new(0,w or 54,1,-4) b.BackgroundColor3=col or SYS.CY.card2
b.BackgroundTransparency=0.25 b.TextColor3=SYS.CY.text
b.Text=text b.Font=Enum.Font.GothamBold b.TextSize=11
b.AutoButtonColor=false b.BorderSizePixel=0 b.Parent=parent
pcall(function()
local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,4) c.Parent=b
end)
b.MouseButton1Click:Connect(function() P(fn) end)
return b
end
function SYS.MiniRow(parent,h)
local r=Instance.new("Frame")
r.Size=UDim2.new(1,-12,0,h or 26) r.BackgroundColor3=SYS.CY.panel
r.BackgroundTransparency=0.3 r.BorderSizePixel=0 r.Parent=parent
pcall(function()
local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,5) c.Parent=r
end)
return r
end
function SYS.MiniText(parent,txt,size,col)
local l=Instance.new("TextLabel")
l.BackgroundTransparency=1 l.Text=tostring(txt or "")
l.TextColor3=col or SYS.CY.text l.Font=Enum.Font.GothamMedium
l.TextSize=size or 11 l.TextXAlignment=Enum.TextXAlignment.Left
l.Parent=parent
return l
end
function SYS.MiniList(parent,h)
local f=Instance.new("ScrollingFrame")
f.Size=UDim2.new(1,0,0,h or 160) f.BackgroundColor3=SYS.CY.card
f.BackgroundTransparency=0.3 f.BorderSizePixel=0 f.Parent=parent
f.ClipsDescendants=true
pcall(function()
f.CanvasSize=UDim2.new(0,0,0,0)
f.AutomaticCanvasSize=Enum.AutomaticSize.Y
f.ScrollBarThickness=6 f.ScrollBarImageColor3=SYS.CY.accent
f.ScrollingDirection=Enum.ScrollingDirection.Y
f.ElasticBehavior=Enum.ElasticBehavior.Never
local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,8) c.Parent=f
end)
local lay=Instance.new("UIListLayout")
lay.Padding=UDim.new(0,4) lay.Parent=f
local pad=Instance.new("UIPadding")
pad.PaddingTop=UDim.new(0,6) pad.PaddingLeft=UDim.new(0,6)
pad.PaddingRight=UDim.new(0,6) pad.Parent=f
return f
end
function SYS.MiniClear(f)
if not f then return end
for _,c in ipairs(f:GetChildren()) do
if c:IsA("Frame") or c:IsA("TextLabel") then P(function() c:Destroy() end) end
end
end
local FX={} SYS.FX=FX
local FXEff=nil
local FXHidden={}
local CB_MODES={
["关闭"]         ={sat=0,    bri=0,   con=0,   tint=Color3.new(1,1,1)},
["红色盲(近似)"]  ={sat=-0.65,bri=0.02,con=0.12,tint=Color3.fromRGB(190,255,205)},
["绿色盲(近似)"]  ={sat=-0.65,bri=0.02,con=0.12,tint=Color3.fromRGB(255,205,195)},
["蓝色盲(近似)"]  ={sat=-0.60,bri=0.02,con=0.10,tint=Color3.fromRGB(255,245,185)},
["全色盲(灰)"]    ={sat=-1,   bri=0.04,con=0.18,tint=Color3.new(1,1,1)},
}
FX.Modes={"关闭","红色盲(近似)","绿色盲(近似)","蓝色盲(近似)","全色盲(灰)"}
local function fxEff()
if FXEff and FXEff.Parent then return FXEff end
if not LT then return nil end
local ok,e=pcall(function()
local x=Instance.new("ColorCorrectionEffect")
x.Name=SYS.N.FX x.Saturation=0 x.Brightness=0 x.Contrast=0
x.Enabled=false x.Parent=LT
return x
end)
FXEff=(ok and e) or nil
return FXEff
end
function FX.Apply()
local e=fxEff() if not e then return end
if SYS.T_.FX_Enable~=true then
P(function() e.Enabled=false end) return
end
local mode=SYS.C_.FX_CB or "关闭"
local m=CB_MODES[mode] or CB_MODES["关闭"]
local sat,bri,con=(SYS.C_.FX_Sat or 0),(SYS.C_.FX_Bri or 0),(SYS.C_.FX_Con or 0)
if mode~="关闭" then sat,bri,con=m.sat,m.bri,m.con end
P(function()
e.Saturation=math.clamp(sat,-1,1)
e.Brightness=math.clamp(bri,-1,1)
e.Contrast=math.clamp(con,-1,1)
e.TintColor=(mode~="关闭") and m.tint or Color3.new(1,1,1)
e.Enabled=true
end)
end
function FX.HidePost(cls,on)
if not LT then return end
local key=tostring(cls)
FXHidden[key]=FXHidden[key] or {}
for _,e in ipairs(LT:GetChildren()) do
if e:IsA(cls) and e.Name~="CheatMenu_FX" then
if on then
if FXHidden[key][e]==nil then FXHidden[key][e]=e.Enabled end
P(function() e.Enabled=false end)
else
local o=FXHidden[key][e]
P(function() if e.Parent then e.Enabled=(o~=false) end end)
FXHidden[key][e]=nil
end
end
end
end
function FX.RestoreAll()
for key,t in pairs(FXHidden) do
for e,o in pairs(t) do
P(function() if e and e.Parent then e.Enabled=(o~=false) end end)
end
FXHidden[key]={}
end
P(function() if FXEff and FXEff.Parent then FXEff.Enabled=false end end)
end
local LanternLight=nil
local LTExtra=nil
local function ltExtra()
if LTExtra or not LT then return LTExtra end
local ok,t=pcall(function()
return {FS=LT.FogStart,GS=LT.GlobalShadows}
end)
LTExtra=(ok and t) or {}
return LTExtra
end
SYS.LIGHT_MODES={"关闭","夜视","超级光明","全亮"}
function SYS.MigrateLightMode()
if SYS.C_.LightMode==nil or SYS.C_.LightMode=="" then
if SYS.T_.FullBright then SYS.C_.LightMode="全亮"
elseif SYS.T_.SuperLight or SYS.T_.NightVisionPro then SYS.C_.LightMode="超级光明"
elseif SYS.T_.NightVision then SYS.C_.LightMode="夜视"
else SYS.C_.LightMode="关闭" end
end
local m=SYS.C_.LightMode
SYS.T_.FullBright=(m=="全亮")
SYS.T_.SuperLight=(m=="超级光明")
SYS.T_.NightVisionPro=false
SYS.T_.NightVision=(m=="夜视")
return m
end
local __lightGuardAt=0
function SYS.LightGuardTick()
local now=os.clock()
if now-__lightGuardAt<0.4 then return end
__lightGuardAt=now
if not LT then return end
local mode=SYS.C_.LightMode or "关闭"
P(function()
if mode=="全亮" then
if LT.Brightness~=2 then LT.Brightness=2 end
if LT.ClockTime~=12 then LT.ClockTime=12 end
if LT.FogEnd<1e5 then LT.FogEnd=1e6 LT.FogStart=1e6 end
if LT.GlobalShadows then LT.GlobalShadows=false end
elseif mode=="超级光明" then
if LT.Brightness~=3 then LT.Brightness=3 end
if LT.ClockTime~=12 then LT.ClockTime=12 end
elseif mode=="夜视" then
if LT.Brightness~=2 then LT.Brightness=2 end
end
if SYS.T_.NoFog==true and LT.FogEnd<1e5 then LT.FogEnd=1e6 LT.FogStart=1e6 end
if SYS.T_.NoShadow==true and LT.GlobalShadows then LT.GlobalShadows=false end
if SYS.T_.Lantern==true then
local ch=LP.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
local lant
if root then
for _,c in ipairs(root:GetChildren()) do
if c.Name==SYS.N.Lantern then lant=c break end
end
if not lant then
local pl=Instance.new("PointLight")
pl.Name=SYS.N.Lantern pl.Brightness=3 pl.Range=60
pl.Color=Color3.fromRGB(255,240,200) pl.Parent=root
end
end
end
end)
end
function SYS.ReapplyLight()
if not LT then return end
local ex=ltExtra()
local mode=SYS.MigrateLightMode()
local nf=SYS.T_.NoFog==true
local ns=SYS.T_.NoShadow==true
local O=SYS.Orig
P(function()
if mode=="全亮" then
LT.Brightness=2
LT.ClockTime=12
LT.Ambient=Color3.new(1,1,1)
LT.OutdoorAmbient=Color3.new(1,1,1)
if not SYS.OrigFX then
SYS.OrigFX={}
for _,e in ipairs(LT:GetChildren()) do
if e:IsA("PostEffect") then SYS.OrigFX[e]=e.Enabled e.Enabled=false end
end
end
elseif mode=="超级光明" then
LT.Brightness=3
LT.Ambient=Color3.new(1,1,1)
LT.OutdoorAmbient=Color3.new(1,1,1)
LT.ClockTime=12
if SYS.OrigFX then for e,en in pairs(SYS.OrigFX) do P(function() e.Enabled=en end) end SYS.OrigFX=nil end
elseif mode=="夜视" then
LT.Brightness=2
LT.Ambient=Color3.fromRGB(120,120,120)
LT.OutdoorAmbient=Color3.fromRGB(120,120,120)
LT.ClockTime=O.ClockTime
if SYS.OrigFX then for e,en in pairs(SYS.OrigFX) do P(function() e.Enabled=en end) end SYS.OrigFX=nil end
else
LT.Brightness=O.Brightness
LT.Ambient=O.Ambient
LT.OutdoorAmbient=O.OutdoorAmbient
LT.ClockTime=O.ClockTime
if SYS.OrigFX then for e,en in pairs(SYS.OrigFX) do P(function() e.Enabled=en end) end SYS.OrigFX=nil end
end
LT.GlobalShadows=not (ns or mode=="全亮")
if nf or mode=="全亮" then
LT.FogEnd=1e6 LT.FogStart=1e6
else
LT.FogEnd=O.FogEnd LT.FogColor=O.FogColor
LT.FogStart=(ex.FS~=nil) and ex.FS or LT.FogStart
end
end)
local wantGuard=(SYS.C_.LightMode~="关闭" and SYS.C_.LightMode~=nil)
or SYS.T_.NoFog==true or SYS.T_.NoShadow==true or SYS.T_.Lantern==true
if wantGuard then
SYS.SetLoop("LightGuard",true,RS.Heartbeat,SYS.LightGuardTick)
else
SYS.SetLoop("LightGuard",false)
end
P(function()
if SYS.T_.Lantern==true then
local ch=LP.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
if root and not (LanternLight and LanternLight.Parent==root) then
if LanternLight and LanternLight.Parent then LanternLight:Destroy() end
local pl=Instance.new("PointLight")
pl.Name=SYS.N.Lantern pl.Brightness=3 pl.Range=60
pl.Color=Color3.fromRGB(255,240,200) pl.Parent=root
LanternLight=pl
end
elseif LanternLight then
local l=LanternLight LanternLight=nil
P(function() if l and l.Parent then l:Destroy() end end)
end
end)
end
function SYS.RestoreLight()
P(function()
if LanternLight and LanternLight.Parent then LanternLight:Destroy() end
LanternLight=nil
end)
if not LT then return end
local ex=LTExtra or {}
local O=SYS.Orig
P(function()
LT.Brightness=O.Brightness LT.ClockTime=O.ClockTime
LT.Ambient=O.Ambient LT.OutdoorAmbient=O.OutdoorAmbient
LT.FogEnd=O.FogEnd LT.FogColor=O.FogColor
if ex.FS~=nil then LT.FogStart=ex.FS end
if ex.GS~=nil then LT.GlobalShadows=ex.GS end
end)
end
local Audio={} SYS.Audio=Audio
Audio.Muted={} Audio.OrigVol={} Audio.SavedMaster=nil
function Audio.Scan(maxN)
local out,seen={},{}
maxN=maxN or 150
local function walk(inst,depth)
if #out>=maxN or depth>4 then return end
local ok,kids=pcall(function() return inst:GetChildren() end)
if not ok or not kids then return end
for i=1,#kids do
local c=kids[i]
if c:IsA("Sound") then
if not seen[c] then seen[c]=true out[#out+1]=c end
elseif c:IsA("Model") or c:IsA("Folder") or c:IsA("Tool")
or c:IsA("BasePart") or c:IsA("SoundGroup") or c:IsA("Accessory")
or c:IsA("PlayerGui") or c:IsA("PlayerScripts") then
walk(c,depth+1)
end
end
end
if SoundService then walk(SoundService,0) end
if WS then walk(WS,0) end
if RStorage then walk(RStorage,0) end
local ch=LP.Character
if ch then walk(ch,0) end
return out
end
function Audio.Mute(s,on)
if not s then return end
if on then
if Audio.OrigVol[s]==nil then
local ok,v=pcall(function() return s.Volume end)
Audio.OrigVol[s]=ok and v or 0.5
end
Audio.Muted[s]=true
P(function() s.Volume=0 end)
else
local o=Audio.OrigVol[s]
Audio.Muted[s]=nil
P(function() if s.Parent then s.Volume=(o~=nil) and o or 0.5 end end)
Audio.OrigVol[s]=nil
end
end
function Audio.IsMuted(s) return Audio.Muted[s]==true end
function Audio.OrigOf(s) return Audio.OrigVol[s] end
function Audio.SetMaster(pct)
if not UserGS then return false end
return pcall(function()
local ug=UserGS:GetService("UserGameSettings")
if Audio.SavedMaster==nil then Audio.SavedMaster=ug.MasterVolume end
ug.MasterVolume=math.clamp((tonumber(pct) or 100)/100*10,0,10)
end)
end
function Audio.RestoreMaster()
if Audio.SavedMaster==nil then return end
local v=Audio.SavedMaster Audio.SavedMaster=nil
P(function()
if UserGS then UserGS:GetService("UserGameSettings").MasterVolume=v end
end)
end
function Audio.RestoreAll()
for s,_ in pairs(Audio.Muted) do
local o=Audio.OrigVol[s]
P(function() if s and s.Parent then s.Volume=(o~=nil) and o or 0.5 end end)
end
Audio.Muted={} Audio.OrigVol={}
Audio.RestoreMaster()
end
local ChatLog={} SYS.ChatLog=ChatLog
ChatLog.Msgs={} ChatLog.Max=200 ChatLog.C1=nil ChatLog.C2=nil
function ChatLog.Push(who,txt)
local m=ChatLog.Msgs
m[#m+1]={who=tostring(who or "?"),txt=tostring(txt or "")}
while #m>ChatLog.Max do table.remove(m,1) end
if SYS.ChatLogRender then P(SYS.ChatLogRender) end
end
function ChatLog.Start()
if ChatLog.C1 or ChatLog.C2 then return end
local TCS=Svc("TextChatService")
if TCS and TCS.MessageReceived then
ChatLog.C1=T(TCS.MessageReceived:Connect(function(msg)
local src=msg and msg.TextSource
local nm=src and tostring(src.DisplayName or "") or ""
local un=src and tostring(src.Name or "") or ""
if nm=="" then nm=un~="" and un or "?" end
if un~="" and un~=nm then nm=nm.." (@"..un..")" end
ChatLog.Push(nm,msg and msg.Text or "")
end))
end
local dcs=RStorage and RStorage:FindFirstChild("DefaultChatSystemChatEvents")
if dcs then
local ev=dcs:FindFirstChild("OnMessageDoneFiltering")
if ev and ev.OnClientEvent then
ChatLog.C2=T(ev.OnClientEvent:Connect(function(d)
if type(d)=="table" then
ChatLog.Push(d.FromSpeaker or d.Speaker or "?", d.Message or "")
end
end))
end
end
end
function ChatLog.Stop()
if ChatLog.C1 then DS(ChatLog.C1) ChatLog.C1=nil end
if ChatLog.C2 then DS(ChatLog.C2) ChatLog.C2=nil end
end
function ChatLog.Clear()
ChatLog.Msgs={}
if SYS.ChatLogRender then P(SYS.ChatLogRender) end
end
local WP={} SYS.WP=WP
WP.List={} WP.Marks={}
function WP.Add(name)
local _,_,root=GC()
if not root then SYS.Notify("没有角色, 存不了路径点",SYS.CY.red) return nil end
local nm=tostring(name or "")
if nm=="" then nm="路径点 "..(#WP.List+1) end
WP.List[#WP.List+1]={name=nm,pos=root.Position}
if SYS.WPRender then P(SYS.WPRender) end
return WP.List[#WP.List]
end
function WP.Remove(i)
if not WP.List[i] then return end
table.remove(WP.List,i)
WP.UnmarkAll() WP.RefreshMarks()
if SYS.WPRender then P(SYS.WPRender) end
end
function WP.Mark(i)
local w=WP.List[i] if not w then return end
if WP.Marks[i] and WP.Marks[i].Parent then return end
local ok,m=pcall(function()
local p=Instance.new("Part")
p.Name=SYS.N.WP p.Anchored=true p.CanCollide=false
p.CanQuery=false p.CanTouch=false p.Transparency=0.55
p.Size=Vector3.new(4,8,4) p.Position=w.pos
p.Color=Color3.fromRGB(56,180,255)
p.Material=Enum.Material.ForceField
p.Parent=WS
local bb=Instance.new("BillboardGui")
bb.Size=UDim2.new(0,150,0,30) bb.AlwaysOnTop=true
bb.StudsOffset=Vector3.new(0,7,0) bb.Parent=p
local l=Instance.new("TextLabel")
l.Size=UDim2.new(1,0,1,0) l.BackgroundTransparency=1
l.Text=tostring(i)..". "..tostring(w.name)
l.TextColor3=Color3.fromRGB(56,180,255)
l.Font=Enum.Font.GothamBold l.TextSize=13
l.TextStrokeTransparency=0.2 l.Parent=bb
return p
end)
if ok then WP.Marks[i]=m end
end
function WP.Unmark(i)
local m=WP.Marks[i] WP.Marks[i]=nil
if m then P(function() if m.Parent then m:Destroy() end end) end
end
function WP.UnmarkAll()
for i in pairs(WP.Marks) do WP.Unmark(i) end
WP.Marks={}
end
function WP.RefreshMarks()
if SYS.T_.WPShow~=true then WP.UnmarkAll() return end
for i=1,#WP.List do WP.Mark(i) end
end
function WP.TweenTo(dest,secs)
local _,_,root=GC()
if not root then return end
secs=tonumber(secs) or 1.2
local from=root.CFrame
local to=CFrame.new(dest)
local t0=os.clock()
SYS.SetLoop("WPTween",true,RS.RenderStepped,function()
local a=(os.clock()-t0)/secs
if a>=1 or not root.Parent then
SYS.SetLoop("WPTween",false)
return
end
pcall(function() root.CFrame=from:Lerp(to,a) end)
end)
end
function WP.WalkTo(dest,timeoutS)
local _,hum,root=GC()
if not hum or not root then return end
local t0=os.clock()
SYS.SetLoop("WPWalk",true,RS.Heartbeat,function()
local _,h2,r2=GC()
if not h2 or not r2 or (os.clock()-t0)>(timeoutS or 20) then
SYS.SetLoop("WPWalk",false) return
end
if (r2.Position-dest).Magnitude<4 then
SYS.SetLoop("WPWalk",false) return
end
pcall(function() h2:MoveTo(dest) end)
end)
end
function WP.Goto(i,mode)
local w=WP.List[i]
if not w then SYS.Notify("路径点 "..tostring(i).." 不存在",SYS.CY.sub) return end
local dest=w.pos+Vector3.new(0,3,0)
if mode=="tween" then WP.TweenTo(dest,1.2)
elseif mode=="walk" then WP.WalkTo(dest,25)
else P(function() SYS.TPTo(dest) end) end
end
function WP.Stop()
SYS.SetLoop("WPTween",false)
SYS.SetLoop("WPWalk",false)
end
function SYS.ForceSuicide(mode)
local ch=LP.Character
local hum=ch and ch:FindFirstChildOfClass("Humanoid")
if not ch or not hum then SYS.Notify("没有角色",SYS.CY.sub) return end
if mode=="void" then
P(function()
local root=ch:FindFirstChild("HumanoidRootPart")
if root then
root.CFrame=CFrame.new(Vector3.new(root.Position.X,-5000,root.Position.Z))
end
hum.Health=0
end)
else
P(function()
hum.Health=0
pcall(function() hum:Destroy() end)
end)
end
SYS.Notify("☠ 强制自杀("..((mode=="void") and "虚空抹除" or "抹除")..")",SYS.CY.red)
end
function SYS.SetNoDeath(on)
SYS.T_.NoDeath=on==true
if on then
if not SYS.T_.GodMode then
SYS.Notify("「防死亡」已并入上帝模式 —— 建议把「上帝模式」也打开",SYS.CY.yellow)
end
SYS.SetLoop("NoDeath",true,RS.Heartbeat,function()
if SYS.T_.NoDeath~=true then return end
local ch=LP.Character
local hum=ch and ch:FindFirstChildOfClass("Humanoid")
if not hum then return end
local hp=hum.Health
if hp<=0 then
P(function() hum.Health=hum.MaxHealth end)
end
end)
else
SYS.SetLoop("NoDeath",false)
end
end
function SYS.SetNoKnock(on)
SYS.T_.NoKnock=on==true
if on then
SYS.SetLoop("NoKnock",true,RS.Heartbeat,function()
if SYS.T_.NoKnock~=true then return end
local ch=LP.Character
local hum=ch and ch:FindFirstChildOfClass("Humanoid")
if not hum then return end
P(function()
if hum:GetState()==Enum.HumanoidStateType.FallingDown then
hum:ChangeState(Enum.HumanoidStateType.Running)
end
if hum.PlatformStand then hum.PlatformStand=false end
end)
end)
else
SYS.SetLoop("NoKnock",false)
end
end
local FLING_MAX=80
function SYS.SetAntiFling(on)
SYS.T_.AntiFling=on==true
if on then
SYS.SetLoop("AntiFling",true,RS.Heartbeat,function()
if SYS.T_.AntiFling~=true then return end
local _,_,root=GC()
if not root then return end
P(function()
local v=root.AssemblyLinearVelocity
if v and v.Magnitude>FLING_MAX then
root.AssemblyLinearVelocity=Vector3.zero
SYS._flingN=(SYS._flingN or 0)+1
end
end)
end)
SYS.Notify(("🎈 防甩飞: 已开(速度超过 %d 格/秒立即清零)"):format(FLING_MAX),SYS.CY.green)
else
SYS.SetLoop("AntiFling",false)
SYS.Notify("🎈 防甩飞: 已关",SYS.CY.sub)
end
end
local SpawnRec={}
function SYS.SpawnRec()
if SpawnRec.def==nil then
local ok,v=pcall(function() return LP.RespawnLocation end)
SpawnRec.def=ok and v or false
end
return SpawnRec
end
function SYS.SetSpawnHere()
local _,_,root=GC()
if not root then return end
SYS.SpawnRec()
P(function() LP.RespawnLocation=nil end)
SpawnRec.here=root.CFrame
SYS.SetLoop("SpawnHere",true,RS.Heartbeat,function()
if not SpawnRec.here then return end
local ch=LP.Character
local hum=ch and ch:FindFirstChildOfClass("Humanoid")
if hum and hum.Health<=0 then
P(function() ch:PivotTo(SpawnRec.here) end)
end
end)
SYS.Notify("📍 已把当前位置设为本地重生点",SYS.CY.green)
end
function SYS.ClearSpawnHere()
SYS.SetLoop("SpawnHere",false)
SpawnRec.here=nil
local d=SpawnRec.def
P(function() LP.RespawnLocation=(d~=false) and d or nil end)
SYS.Notify("♻ 已恢复默认重生点",SYS.CY.sub)
end
function SYS.RespawnHere()
local ch=LP.Character
local hum=ch and ch:FindFirstChildOfClass("Humanoid")
if not hum then return end
local pos=SpawnRec.here or (ch and ch:GetPivot())
P(function()
if pos then ch:PivotTo(pos) end
hum.Health=hum.MaxHealth
end)
SYS.Notify("♻ 原地重生",SYS.CY.green)
end
local WL={} SYS.WL=WL
WL.White={} WL.Black={}
function WL.List(white)
local t=white and WL.White or WL.Black
local out={}
for k in pairs(t) do out[#out+1]=k end
table.sort(out)
return out
end
function WL.Add(name,white)
name=tostring(name or "")
if name=="" then return false end
if white then WL.White[name]=true WL.Black[name]=nil
else WL.Black[name]=true WL.White[name]=nil end
return true
end
function WL.Del(name,white)
local t=white and WL.White or WL.Black
t[tostring(name or "")]=nil
end
function WL.Allow(name)
name=tostring(name or "")
if WL.Black[name] then return false end
local hasWL=false
for _ in pairs(WL.White) do hasWL=true break end
if hasWL and not WL.White[name] then return false end
return true
end
local Aim={} SYS.AimEx=Aim
function Aim.HitGate()
local r=tonumber(SYS.C_.CB_HitRate)
if not r or r>=100 then return true end
if r<=0 then return false end
return (math.random()*100)<=r
end
function Aim.MissGate()
if SYS.T_.CB_MissMode~=true then return true end
local r=tonumber(SYS.C_.CB_MissRate) or 0
if r<=0 then return true end
return (math.random()*100)>r
end
local Prot={} SYS.Prot=Prot
Prot.Hooks={} Prot.Unhook={} Prot.Blocked=0 Prot.LastFrom=""
function Prot.Caps()
local c={
hmm=type(hookmetamethod)=="function",
hf=type(hookfunction)=="function",
ncc=type(newcclosure)=="function",
gnm=type(getnamecallmethod)=="function",
cc=type(checkcaller)=="function",
gcs=type(getcallingscript)=="function",
gmt=type(getrawmetatable)=="function",
}
c.ok=(c.hmm or c.hf) and c.ncc
return c
end
function Prot.CapsText()
local c=Prot.Caps()
local t={}
t[#t+1]="hookmetamethod="..tostring(c.hmm)
t[#t+1]="hookfunction="..tostring(c.hf)
t[#t+1]="newcclosure="..tostring(c.ncc)
t[#t+1]="getnamecallmethod="..tostring(c.gnm)
t[#t+1]="checkcaller="..tostring(c.cc)
t[#t+1]="getcallingscript="..tostring(c.gcs)
return table.concat(t,"  ")
end
local function callerName()
if type(getcallingscript)~="function" then return "未知来源" end
local ok,s=pcall(getcallingscript)
if ok and s then
local ok2,n=pcall(function() return s:GetFullName() end)
if ok2 and n then return tostring(n) end
end
return "未知来源"
end
function Prot.DetectAdonis()
if not RStorage then return false end
local ok,found=pcall(function()
for _,o in ipairs(RStorage:GetDescendants()) do
if o:IsA("RemoteEvent") then
local f=o:FindFirstChildWhichIsA("RemoteFunction")
if f and f.Name=="__FUNCTION" then return true end
end
end
return false
end)
return (ok and found) or false
end
function Prot.InstallKickGuard()
local c=Prot.Caps()
if not c.hf then return false,"这台执行器没有 hookfunction" end
if Prot.Hooks.kick then return true end
local ok,err=pcall(function()
local okK,oldK=pcall(function()
return hookfunction(LP.Kick,newcclosure(function()
Prot.Blocked=Prot.Blocked+1
Prot.LastFrom=callerName()
print(("[CheatMenu] 🛡 已拦截本地 Kick (来源: %s) 第 %d 次"):format(Prot.LastFrom,Prot.Blocked))
end))
end)
if okK then Prot.Unhook.kick=oldK end
local okD,oldD=pcall(function() return hookfunction(LP.Destroy,newcclosure(function() end)) end)
if okD then Prot.Unhook.destroy=oldD end
local okS,oldS=pcall(function()
return hookfunction(game.Shutdown,newcclosure(function()
Prot.Blocked=Prot.Blocked+1 Prot.LastFrom=callerName()
print(("[CheatMenu] 🛡 已拦截 game:Shutdown (来源: %s) 第 %d 次"):format(Prot.LastFrom,Prot.Blocked))
end))
end)
if okS then Prot.Unhook.shutdown=oldS end
local okB,oldB=pcall(function()
if Players and Players.BanAsync then
return hookfunction(Players.BanAsync,newcclosure(function()
Prot.Blocked=Prot.Blocked+1 Prot.LastFrom=callerName()
print(("[CheatMenu] 🛡 已拦截本地 BanAsync (来源: %s) 第 %d 次"):format(Prot.LastFrom,Prot.Blocked))
return nil
end))
end
end)
if okB and oldB then Prot.Unhook.ban=oldB end
if LP and LP.AncestryChanged then
local okA,conn=pcall(function()
return LP.AncestryChanged:Connect(function()
if not SYS.Unloaded and not LP:IsDescendantOf(Players) then
print("[CheatMenu] ⚠ 本地玩家已被移出 Players(被踢/被断开) —— 服务端的断开拦不住, 但记录一下")
end
end)
end)
if okA and conn then T(conn) end
end
end)
if not ok then return false,tostring(err) end
Prot.Hooks.kick=true
return true
end
function Prot.RemoveKickGuard()
if not Prot.Hooks.kick then return end
local c=Prot.Caps()
if c.hf then
if Prot.Unhook.kick then P(function() hookfunction(LP.Kick,Prot.Unhook.kick) end) end
if Prot.Unhook.destroy then P(function() hookfunction(LP.Destroy,Prot.Unhook.destroy) end) end
if Prot.Unhook.shutdown then P(function() hookfunction(game.Shutdown,Prot.Unhook.shutdown) end) end
if Prot.Unhook.ban and Players and Players.BanAsync then
P(function() hookfunction(Players.BanAsync,Prot.Unhook.ban) end)
end
end
Prot.Unhook.kick=nil Prot.Unhook.destroy=nil Prot.Unhook.namecall=nil Prot.Unhook.ban=nil
Prot.Hooks.kick=nil
end
function Prot.InstallTPGuard()
local c=Prot.Caps()
if not c.hf then return false,"这台执行器没有 hookfunction" end
if Prot.Hooks.tp then return true end
local TS=Svc("TeleportService")
if not TS then return false,"拿不到 TeleportService" end
local ok,err=pcall(function()
local names={"Teleport","TeleportAsync","TeleportToPlaceInstance","TeleportToSpawnByName","TeleportPartyAsync"}
Prot.Unhook.tp={}
for i=1,#names do
local n=names[i]
local f=TS[n]
if type(f)=="function" then
local old
local ok2=pcall(function()
old=hookfunction(f,newcclosure(function(...)
if checkcaller and checkcaller() then return old(...) end
Prot.Blocked=Prot.Blocked+1
Prot.LastFrom=callerName()
print(("[CheatMenu] 🛡 已拦截 TeleportService.%s (来源: %s)"):format(n,Prot.LastFrom))
return
end))
end)
if ok2 then Prot.Unhook.tp[n]=old end
end
end
end)
if not ok then return false,tostring(err) end
Prot.Hooks.tp=true
return true
end
function Prot.RemoveTPGuard()
if not Prot.Hooks.tp then return end
local c=Prot.Caps()
local TS=Svc("TeleportService")
if c.hf and TS then
for n,old in pairs(Prot.Unhook.tp or {}) do
local f=TS[n]
P(function() if type(f)=="function" then hookfunction(f,old) end end)
end
end
Prot.Unhook.tp={} Prot.Hooks.tp=nil
end
function Prot.InstallHideGui()
if Prot.Hooks.hide then return true end
if SYS.SafeParentGui and SYS.ScreenGui then
P(function() SYS.SafeParentGui(SYS.ScreenGui) end)
end
P(function()
if SYS.ScreenGui then SYS.ScreenGui.Archivable=false end
if SYS.FloatGui then SYS.FloatGui.Archivable=false end
end)
Prot.Hooks.hide=true
if Prot.NeutralizeNames then P(function() Prot.LastRenamed=Prot.NeutralizeNames() end) end
return true
end
function Prot.RemoveHideGui()
if not Prot.Hooks.hide then return end
P(function()
if SYS.ScreenGui then SYS.ScreenGui.Archivable=true end
if SYS.FloatGui then SYS.FloatGui.Archivable=true end
end)
Prot.Hooks.hide=nil
end
Prot.FPWords={"cheat","hack","exploit","aimbot","macro","autofarm","inject",
"cheatmenu","synapse","krnl","script-ware","fluxus"}
local function fpBad(name)
local lo=string.lower(tostring(name or ""))
for i=1,#Prot.FPWords do
local w=Prot.FPWords[i]
if string.find(lo,w,1,true) then return w end
end
return nil
end
Prot.fpBad=fpBad
function Prot.NeutralizeNames()
local n=0
local function fix(o,tag)
if o and fpBad(o.Name) then P(function() o.Name=tag n=n+1 end) end
end
fix(SYS.ScreenGui,"RBX_Overlay")
fix(SYS.FloatGui,"RBX_Float")
if SYS.ScreenGui then
P(function()
if type(SYS.ScreenGui.GetChildren)=="function" then
for _,c in ipairs(SYS.ScreenGui:GetChildren()) do
if fpBad(c.Name) then c.Name="RBX_Panel" n=n+1 end
end
end
end)
end
return n
end
function Prot.SelfAudit()
local L={}
local function A(f,...) L[#L+1]="  "..(select("#",...)>0 and f:format(...) or f) end
A("=========== CheatMenu 反指纹自检 (G6/G7) ===========")
local root=SYS.ScreenGui
if not root then
A("!! ScreenGui=nil (菜单还没建)")
else
local w=fpBad(root.Name)
A("ScreenGui.Name=%q  可疑词=%s",tostring(root.Name),w or "(无)")
local par=root.Parent
local pn="nil"
if par then
if par==SYS.PG then pn="PlayerGui (任何脚本都能遍历)"
elseif SYS.CoreGui and par==SYS.CoreGui then pn="CoreGui (权限更高)"
else P(function() pn=par:GetFullName() end) end
end
A("ScreenGui 父级=%s",pn)
A("Archivable: ScreenGui=%s  FloatGui=%s  (false=不会被 GetDescendants+Clone 抓走)",
tostring(root.Archivable),tostring(SYS.FloatGui and SYS.FloatGui.Archivable))
local subs={}
P(function()
local seen={}
for _,d in ipairs(root:GetDescendants()) do
local dw=fpBad(d.Name)
if dw and not seen[d.Name] then
seen[d.Name]=true
subs[#subs+1]=("%s<%s>"):format(tostring(d.Name),d.ClassName)
end
end
end)
if #subs==0 then
A("GUI 树可疑名: (无)")
else
local show=math.min(#subs,12)
A("GUI 树可疑名 %d 处: %s%s",#subs,table.concat(subs,", ",1,show),#subs>show and " …" or "")
A("   -> 点「🧹 擦掉 GUI 可疑名」可一键换成中性名(子元素本来就是 t/fr/lab 这类, 不会动)")
end
end
local eg={"getgenv","gethui","getrawmetatable","hookmetamethod","hookfunction","checkcaller",
"setreadonly","getconnections","firesignal","getscriptbytecode","setfflag",
"is_sirhurt_closure","syn","KRNL_LOADED","secure_load"}
local seenG={}
local G=_G
for i=1,#eg do
local ok,v=pcall(function() return G[eg[i]] end)
if ok and v~=nil then seenG[#seenG+1]=eg[i] end
end
A("可见执行器全局 %d 个: %s",#seenG,#seenG>0 and table.concat(seenG,",") or "(无)")
A("⚠ 边界: 这些全局是执行器注入的, 脚本层删不掉(删了脚本自己也没得用)。")
A("  能做的只有「少暴露自己」: 中性名 + 少留特征实例 —— 上面已经逐项列出。")
return L
end
local RayCtor=Ray
local Ray={} SYS.RayHook=Ray
Ray.Hooked=false Ray.Unhook=nil Ray.Rewrites=0
function Ray.Target()
if not SYS.Combat or not SYS.Combat.TargetPart then return nil end
return SYS.Combat.TargetPart
end
function Ray.Install()
local c=Prot.Caps()
if not c.hmm or not c.gnm then return false,"这台执行器没有 hookmetamethod/getnamecallmethod" end
if Ray.Hooked then return true end
local ok,err=pcall(function()
local h
h=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
if checkcaller and checkcaller() then return h(self,...) end
if self~=WS then return h(self,...) end
local m=getnamecallmethod()
if m then
local lm=m
if lm=="Raycast" then
if SYS.T_.CB_BlockRay==true then
Ray.Rewrites=Ray.Rewrites+1
return nil
end
local a1,a2=...
local res=h(self,...)
if SYS.T_.CB_SilentAim==true or SYS.T_.CB_BulletWall==true then
local tp=Ray.Target()
if tp then
Ray.Rewrites=Ray.Rewrites+1
local pos = tp.Position
local nrm = (res and res.Normal) or Vector3.new(0,1,0)
local mat = (res and res.Material) or (tp.Material or Enum.Material.Plastic)
local dist = (res and res.Distance) or 0
if not res then
local cam=WS.CurrentCamera
if cam then dist=(cam.CFrame.Position-pos).Magnitude end
end
local rayObj=(res and res.Ray) or nil
if not rayObj and RayCtor and RayCtor.new
and (typeof(a1)=="Vector3") and (typeof(a2)=="Vector3") then
P(function() rayObj=RayCtor.new(a1, a2*(dist>0 and dist or 1)) end)
end
return {
Instance = tp,
Position = pos,
Normal   = nrm,
Material = mat,
Distance = dist,
Ray      = rayObj,
}
end
end
return res
elseif lm=="FindPartOnRay" or lm=="FindPartOnRayWithIgnoreList"
or lm=="FindPartOnRayWithWhitelist" then
if SYS.T_.CB_BlockRay==true then
Ray.Rewrites=Ray.Rewrites+1
return nil,nil
end
local a,b,c,d=h(self,...)
if SYS.T_.CB_SilentAim==true or SYS.T_.CB_BulletWall==true then
local tp=Ray.Target()
if tp then
Ray.Rewrites=Ray.Rewrites+1
return tp, tp.Position,
(c or Vector3.new(0,1,0)),
(d or (tp.Material or Enum.Material.Plastic))
end
end
return a,b,c,d
end
end
return h(self,...)
end))
Ray.Unhook=h
end)
if not ok then return false,tostring(err) end
Ray.Hooked=true
return true
end
function Ray.Remove()
if not Ray.Hooked then return end
local c=Prot.Caps()
if c.hmm and Ray.Unhook then
P(function() hookmetamethod(game,"__namecall",Ray.Unhook) end)
end
Ray.Unhook=nil Ray.Hooked=false
end
function SYS.GiveAllTools()
local bp=LP:FindFirstChildOfClass("Backpack")
if not bp then SYS.Notify("没有 Backpack",SYS.CY.sub) return 0 end
local n=0
local ok,err=pcall(function()
for _,o in ipairs(game:GetDescendants()) do
if o:IsA("Tool") and o.Parent~=bp and o.Parent~=LP.Character then
local c=o:Clone()
c.Parent=bp n=n+1
if n>=200 then break end
end
end
end)
SYS.Notify(("🧰 已复制 %d 个工具到背包%s"):format(n,(not ok) and " (中途出错)" or ""),SYS.CY.green)
return n
end
function SYS.RemoveAllTools()
local n=0
P(function()
local bp=LP:FindFirstChildOfClass("Backpack")
if bp then
for _,c in ipairs(bp:GetChildren()) do
if c:IsA("Tool") then c:Destroy() n=n+1 end
end
end
local ch=LP.Character
if ch then
for _,c in ipairs(ch:GetChildren()) do
if c:IsA("Tool") then c:Destroy() n=n+1 end
end
end
end)
SYS.Notify(("🧹 已移除 %d 个工具"):format(n),SYS.CY.orange)
return n
end
local PC={} SYS.PC=PC
function PC.Get()
local n=SYS.C_.PC_Sel
if not n or n=="" then return nil end
return Players:FindFirstChild(n)
end
function PC.Root(pl)
local ch=pl and pl.Character
return ch and (ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart)
end
function PC.GotoTarget(kind)
local tgt=PC.Get()
local r=PC.Root(tgt)
if not r then SYS.Notify("目标没有角色",SYS.CY.sub) return end
local dest=r.Position+Vector3.new(0,3,0)
if kind=="tween" then WP.TweenTo(dest,1.2)
elseif kind=="walk" then WP.WalkTo(dest,25)
else P(function() SYS.TPTo(dest) end) end
SYS.Notify("➲ 已传送到 "..tostring(tgt and tgt.Name),SYS.CY.cyan)
end
function PC.BringTarget()
local tgt=PC.Get()
local r=PC.Root(tgt)
if not r then SYS.Notify("目标没有角色",SYS.CY.sub) return end
local _,_,mine=GC()
if not mine then return end
P(function() r.CFrame=CFrame.new(mine.Position+Vector3.new(0,3,0)) end)
SYS.Notify("（客户端）已把 "..tostring(tgt and tgt.Name).." 拉过来 —— 服务端不认可, 很快会被拉回",SYS.CY.yellow)
end
function PC.Freeze(on)
local tgt=PC.Get()
local r=PC.Root(tgt)
if not r then SYS.Notify("目标没有角色",SYS.CY.sub) return end
PC._frozen=PC._frozen or {}
if on then
if PC._frozen[r]==nil then
local ok,v=pcall(function() return r.Anchored end)
PC._frozen[r]=ok and v or false
end
P(function() r.Anchored=true end)
SYS.SetLoop("PCFrozen",true,RS.Heartbeat,function()
if SYS.T_.PC_Freeze~=true then SYS.SetLoop("PCFrozen",false) return end
for rr in pairs(PC._frozen or {}) do
P(function() if rr.Parent then rr.Anchored=true end end)
end
end)
SYS.Notify("🧊 已冻结 "..tostring(tgt and tgt.Name).."(客户端)",SYS.CY.cyan)
else
SYS.SetLoop("PCFrozen",false)
for rr,v in pairs(PC._frozen or {}) do
P(function() if rr.Parent then rr.Anchored=v end end)
end
PC._frozen={}
SYS.Notify("🔥 已解冻",SYS.CY.sub)
end
end
function PC.Blink(secs)
local tgt=PC.Get()
local ch=tgt and tgt.Character
if not ch then return end
local saved={}
P(function()
for _,d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") then
saved[d]=d.LocalTransparencyModifier
d.LocalTransparencyModifier=1
elseif d:IsA("Decal") then
saved[d]=d.Transparency d.Transparency=1
end
end
end)
task.delay(tonumber(secs) or 0.5,function()
P(function()
for d,v in pairs(saved) do
if d.Parent then
if d:IsA("BasePart") then d.LocalTransparencyModifier=v
else d.Transparency=v end
end
end
end)
end)
end
function PC.OnHead(on)
SYS.T_.PC_OnHead=on==true
if not on then SYS.SetLoop("PCOnHead",false) return end
SYS.SetLoop("PCOnHead",true,RS.Heartbeat,function()
if SYS.T_.PC_OnHead~=true then return end
local tgt=PC.Get()
local r=PC.Root(tgt)
local _,_,mine=GC()
if not r or not mine then return end
local head=tgt.Character and tgt.Character:FindFirstChild("Head")
local y=(head and head.Position.Y or r.Position.Y)+4
P(function() mine.CFrame=CFrame.new(Vector3.new(r.Position.X,y,r.Position.Z)) end)
end)
end
function PC.Orbit(on)
SYS.T_.PC_Orbit=on==true
if not on then SYS.SetLoop("PCOrbit",false) return end
local a=0
SYS.SetLoop("PCOrbit",true,RS.RenderStepped,function(dt)
if SYS.T_.PC_Orbit~=true then return end
local tgt=PC.Get()
local r=PC.Root(tgt)
local _,_,mine=GC()
if not r or not mine then return end
a=a+(dt or 0.016)*(SYS.C_.PC_SpinSpeed or 3)
local rad=SYS.C_.PC_Range or 8
local p=r.Position+Vector3.new(math.cos(a)*rad,2.5,math.sin(a)*rad)
P(function() mine.CFrame=CFrame.new(p) end)
end)
end
function PC.Stare(on)
SYS.T_.PC_Stare=on==true
if not on then SYS.SetLoop("PCStare",false) return end
SYS.SetLoop("PCStare",true,RS.RenderStepped,function()
if SYS.T_.PC_Stare~=true then return end
local tgt=PC.Get()
local r=PC.Root(tgt)
local cam=SYS.Cam
if not r or not cam then return end
P(function()
local cf=cam.CFrame
cam.CFrame=CFrame.lookAt(cf.Position,r.Position)
end)
end)
end
function PC.Follow(on)
SYS.T_.PC_Follow=on==true
if not on then SYS.SetLoop("PCFollow",false) return end
SYS.SetLoop("PCFollow",true,RS.Heartbeat,function()
if SYS.T_.PC_Follow~=true then return end
local tgt=PC.Get()
local r=PC.Root(tgt)
local _,hum,mine=GC()
if not r or not hum then return end
if (r.Position-mine.Position).Magnitude>6 then
P(function() hum:MoveTo(r.Position) end)
end
end)
end
function PC.LoopTP(on)
SYS.T_.PC_LoopTP=on==true
if not on then SYS.SetLoop("PCLoopTP",false) return end
SYS.SetLoop("PCLoopTP",true,RS.Heartbeat,function()
if SYS.T_.PC_LoopTP~=true then return end
local tgt=PC.Get()
local r=PC.Root(tgt)
local _,_,mine=GC()
if not r or not mine then return end
if (r.Position-mine.Position).Magnitude>6 then
P(function() mine.CFrame=CFrame.new(r.Position+Vector3.new(0,3,0)) end)
end
end)
end
function PC.MuteVoice(on)
local tgt=PC.Get()
local ch=tgt and tgt.Character
if not ch then SYS.Notify("目标没有角色",SYS.CY.sub) return end
local n=0
P(function()
for _,d in ipairs(ch:GetDescendants()) do
if d:IsA("Sound") then
Audio.Mute(d,on) n=n+1
end
end
end)
SYS.Notify((on and "🔇 已本地静音 " or "🔊 已解除静音 ")
..tostring(tgt and tgt.Name)..(" (%d 个声音)"):format(n).."\n⚠ 客户端无法静音他人语音, 这只能静音他角色里的音效",SYS.CY.yellow)
end
local PG={} SYS.Prank=PG
function PG.Target()
local n=SYS.C_.PG_Target
if n and n~="" then
local pl=Players:FindFirstChild(n)
if pl then return pl end
end
return SYS.C_.PC_Sel and Players:FindFirstChild(SYS.C_.PC_Sel) or nil
end
function PG.AllPlayers()
local t={}
for _,pl in ipairs(Players:GetPlayers()) do
if pl~=LP and pl.Character and PC.Root(pl) then t[#t+1]=pl end
end
return t
end
function PG.Fling(pl)
local r=PC.Root(pl)
if not r then return false end
P(function()
local v=Vector3.new((math.random()-0.5)*2,(math.random()*0.8+0.6),(math.random()-0.5)*2)
local ok=pcall(function() r.AssemblyLinearVelocity=v*800 end)
if not ok then
pcall(function() r.Velocity=v*800 end)
end
end)
return true
end
function PG.FlingAll()
local n=0
for _,pl in ipairs(PG.AllPlayers()) do
if PG.Fling(pl) then n=n+1 end
end
SYS.Notify(("🌀 已甩飞 %d 个玩家(本地)"):format(n),SYS.CY.orange)
end
function PG.Spin(on)
SYS.T_.PG_Spin=on==true
if not on then SYS.SetLoop("PGSpin",false) PG.spinConn=nil return end
local a=0
SYS.SetLoop("PGSpin",true,RS.RenderStepped,function(dt)
if SYS.T_.PG_Spin~=true then return end
a=a+(dt or 0.016)*(SYS.C_.PG_SpinSpeed or 8)
for _,pl in ipairs(PG.AllPlayers()) do
local r=PC.Root(pl)
if r then
P(function()
r.CFrame=CFrame.new(r.Position)*CFrame.Angles(0,a,0)
end)
end
end
end)
end
function PG.SpinHit(on)
SYS.T_.PG_SpinHit=on==true
if not on then SYS.SetLoop("PGSpinHit",false) return end
SYS.SetLoop("PGSpinHit",true,RS.Heartbeat,function()
if SYS.T_.PG_SpinHit~=true then return end
for _,pl in ipairs(PG.AllPlayers()) do
local r=PC.Root(pl)
if r then P(function() r.AssemblyLinearVelocity=Vector3.new(0,60,0)+Vector3.new(math.random()-0.5,0,math.random()-0.5)*60 end) end
end
end)
end
function PG.FlyHit(on)
SYS.T_.PG_FlyHit=on==true
if not on then SYS.SetLoop("PGFlyHit",false) return end
SYS.SetLoop("PGFlyHit",true,RS.Heartbeat,function()
if SYS.T_.PG_FlyHit~=true then return end
for _,pl in ipairs(PG.AllPlayers()) do
local r=PC.Root(pl)
if r then P(function() r.AssemblyLinearVelocity=Vector3.new(0,140,0) end) end
end
end)
end
function PG.WalkHit(on)
SYS.T_.PG_WalkHit=on==true
if not on then SYS.SetLoop("PGWalkHit",false) return end
SYS.SetLoop("PGWalkHit",true,RS.Heartbeat,function()
if SYS.T_.PG_WalkHit~=true then return end
local _,_,mine=GC()
if not mine then return end
for _,pl in ipairs(PG.AllPlayers()) do
local r=PC.Root(pl)
if r and (r.Position-mine.Position).Magnitude<12 then PG.Fling(pl) end
end
end)
end
function PG.HideHit(on)
SYS.T_.PG_HideHit=on==true
if not on then
SYS.SetLoop("PGHideHit",false)
local ch=LP.Character
if ch then
P(function()
for _,d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") then d.LocalTransparencyModifier=0 end
end
end)
end
return
end
SYS.SetLoop("PGHideHit",true,RS.Heartbeat,function(dt)
if SYS.T_.PG_HideHit~=true then return end
local ch=LP.Character
if ch then
P(function()
for _,d in ipairs(ch:GetDescendants()) do
if d:IsA("BasePart") then d.LocalTransparencyModifier=1 end
end
end)
end
local _,_,mine=GC()
if not mine then return end
for _,pl in ipairs(PG.AllPlayers()) do
local r=PC.Root(pl)
if r and (r.Position-mine.Position).Magnitude<12 then PG.Fling(pl) end
end
end)
end
function PG.OrbitTool(on)
SYS.T_.PG_OrbitTool=on==true
if not on then SYS.SetLoop("PGOrbitTool",false) PG.toolOrig=nil return end
local a=0
SYS.SetLoop("PGOrbitTool",true,RS.RenderStepped,function(dt)
if SYS.T_.PG_OrbitTool~=true then return end
local ch=LP.Character
if not ch then return end
local tool=ch:FindFirstChildOfClass("Tool")
if not tool then return end
local handle=tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
if not handle then return end
if PG.toolOrig==nil then PG.toolOrig=handle.Anchored end
a=a+(dt or 0.016)*(SYS.C_.PG_OrbitSpeed or 60)
local _,_,root=GC()
if not root then return end
local rad=SYS.C_.PG_OrbitRange or 8
local p=root.Position+Vector3.new(math.cos(math.rad(a))*rad,1,math.sin(math.rad(a))*rad)
P(function()
handle.Anchored=true
handle.CFrame=CFrame.new(p)
end)
end)
end
function PG.AttachToolTo(name)
local pl=Players:FindFirstChild(tostring(name or ""))
local r=PC.Root(pl)
local ch=LP.Character
local tool=ch and ch:FindFirstChildOfClass("Tool")
local handle=tool and (tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart"))
if not r or not handle then SYS.Notify("缺目标角色或手里没工具",SYS.CY.sub) return end
P(function()
handle.Anchored=true
handle.CFrame=CFrame.new(r.Position+Vector3.new(0,3,0))
end)
SYS.Notify("🧲 工具已附着到 "..tostring(pl and pl.Name).."(本地)",SYS.CY.cyan)
end
function PG.BlackHole(on)
SYS.T_.PG_BlackHole=on==true
if not on then SYS.SetLoop("PGBlackHole",false) PG.bhMark=nil return end
local _,_,root0=GC()
if root0 then PG.bhMark=root0.CFrame end
SYS.SetLoop("PGBlackHole",true,RS.Heartbeat,function()
if SYS.T_.PG_BlackHole~=true then return end
local _,_,mine=GC()
if not mine then return end
local center=SYS.C_.PG_BH_Height and (mine.Position+Vector3.new(0,SYS.C_.PG_BH_Height or 30,0)) or mine.Position
local rad=SYS.C_.PG_BH_Range or 40
local pull=SYS.C_.PG_BH_Pull or 120
for _,pl in ipairs(PG.AllPlayers()) do
local r=PC.Root(pl)
if r and (r.Position-center).Magnitude<=rad then
P(function()
local d=(center-r.Position)
if d.Magnitude>0.1 then
r.AssemblyLinearVelocity=d.Unit*pull
end
end)
end
end
end)
end
function PG.KillNear(on)
SYS.T_.PG_KillNear=on==true
if not on then SYS.SetLoop("PGKillNear",false) return end
SYS.SetLoop("PGKillNear",true,RS.Heartbeat,function()
if SYS.T_.PG_KillNear~=true then return end
local _,_,mine=GC()
if not mine then return end
local dist=SYS.C_.PG_KillDist or 13
local nm=tostring(SYS.C_.PG_Target or "")
for _,pl in ipairs(PG.AllPlayers()) do
local r=PC.Root(pl)
if r and (r.Position-mine.Position).Magnitude<=dist then
if nm=="" or pl.Name==nm then
local hum=pl.Character and pl.Character:FindFirstChildOfClass("Humanoid")
if hum then P(function() hum.Health=0 end) end
end
end
end
end)
end
function PG.StopAll()
SYS.SetLoop("PGSpin",false) SYS.SetLoop("PGSpinHit",false)
SYS.SetLoop("PGFlyHit",false) SYS.SetLoop("PGWalkHit",false)
SYS.SetLoop("PGHideHit",false) SYS.SetLoop("PGOrbitTool",false)
SYS.SetLoop("PGBlackHole",false) SYS.SetLoop("PGKillNear",false)
end
function SYS.FuseClean()
P(FX.RestoreAll)
P(SYS.RestoreLight)
P(Audio.RestoreAll)
P(ChatLog.Stop)
P(WP.Stop) P(WP.UnmarkAll)
P(function() SYS.SetNoDeath(false) end)
P(function() SYS.SetNoKnock(false) end)
P(function() SYS.ClearSpawnHere() end)
P(PC.Freeze,false)
P(PC.OnHead,false) P(PC.Orbit,false) P(PC.Stare,false)
P(PC.Follow,false) P(PC.LoopTP,false)
P(PG.StopAll)
P(function() SYS.SetLoop("PGFlingAll",false) end)
P(function() SYS.SetLoop("WPTween",false) SYS.SetLoop("WPWalk",false) end)
P(PG.OrbitTool,false)
P(Prot.RemoveKickGuard)
P(Prot.RemoveTPGuard)
P(Prot.RemoveHideGui)
P(Ray.Remove)
end
end
do
local AC={} SYS.AC=AC
local LEG_LOADED="Cheat".."Loaded"
local LEG_UNLOAD="Cheat".."Unload"
local LEG_BOOT="Cheat".."BootDone"
local LEG_NOTE="Cheat".."UpdateNote"
AC.Results={}
AC.PosMax=0 AC.LastP=nil AC.CamMax=0
local SUS={"cheat","hack","exploit","aimbot","esp","inject","macro","autofarm",
"cheatmenu","byfrox","synapse","krnl","script-","cheatengine","speedhack"}
local function nameSus(n)
n=string.lower(tostring(n or ""))
for i=1,#SUS do if string.find(n,SUS[i],1,true) then return SUS[i] end end
return nil
end
local function eachChild(root,fn,maxd)
if not root then return end
local function walk(o,d)
local ok,kids=pcall(function() return o:GetChildren() end)
if not ok or not kids then return end
for i=1,#kids do
local c=kids[i]
fn(c)
if d<(maxd or 1) then walk(c,d+1) end
end
end
walk(root,1)
end
function AC.StartSampler()
if AC.SamplerOn then return end
AC.SamplerOn=true
SYS.SetLoop("ACSample",true,RS.Heartbeat,function()
local _,_,root=GC()
if root then
local p=root.Position
if AC.LastP then
local d=(p-AC.LastP).Magnitude
if d>AC.PosMax then AC.PosMax=d end
end
AC.LastP=p
end
local cam=SYS.Cam
if cam and root then
local d=(cam.CFrame.Position-root.Position).Magnitude
if d>AC.CamMax then AC.CamMax=d end
end
end)
end
function AC.ResetSampler()
AC.PosMax=0 AC.CamMax=0 AC.LastP=nil
SYS.SetLoop("ACSample",false) AC.SamplerOn=nil
end
local function d1()
local found={}
local function scan(root,label,maxd)
eachChild(root,function(c)
local hit=nameSus(c.Name)
if hit then found[#found+1]=("%s.%s ←命中:%s"):format(label,tostring(c.Name),hit) end
end,maxd or 1)
end
scan(SYS.CoreGui,"CoreGui",2)
scan(LP:FindFirstChildOfClass("PlayerGui"),"PlayerGui",2)
scan(WS,"Workspace",1)
scan(LT,"Lighting",1)
if #found==0 then return true,"未发现带外挂关键词的实例" end
return false,("命中 %d 个: %s"):format(#found,table.concat(found," | "))
end
local function d2()
local g=SYS.ScreenGui
if not g then return true,"菜单尚未创建" end
local hit=nameSus(g.Name)
if hit then return false,("菜单名 %s 带关键词 %s"):format(tostring(g.Name),hit) end
if (SYS.Prot and SYS.Prot.Hooks.hide)~=true then
return false,("菜单名已中性(%s), 但【枚举隐藏未开】—— 游戏脚本遍历 CoreGui 仍能看到它"):format(tostring(g.Name))
end
return true,("菜单名 %s · CoreGui 枚举已过滤"):format(tostring(g.Name))
end
local function d3()
if type(getgenv)~="function" then return true,"这台执行器没有 getgenv(该层不可测)" end
local ok,g=pcall(getgenv)
if not ok or type(g)~="table" then return true,"getgenv 不可用" end
local bad={}
local legacy={LEG_LOADED,LEG_UNLOAD,LEG_BOOT,LEG_NOTE}
for i=1,#legacy do if g[legacy[i]]~=nil then bad[#bad+1]=legacy[i] end end
for k in pairs(g) do
if type(k)=="string" then
local hit=nameSus(k)
if hit and #bad<8 then bad[#bad+1]=("%s←命中:%s"):format(k,hit) end
end
end
if #bad==0 then return true,"getgenv 里没有可被直接认出的键" end
return false,("可直接读到: "..table.concat(bad,", "))
end
local function d4()
if type(isfile)~="function" then return true,"这台执行器没有 isfile(该层不可测)" end
local bad={}
local list={SYS.N.OldCfg,SYS.N.OldCfg..".bak",SYS.N.OldCache,SYS.N.OldDiag}
for i=1,#list do
local ok,v=pcall(isfile,list[i])
if ok and v then bad[#bad+1]=list[i] end
end
if #bad==0 then return true,"工作目录里没有带外挂名的旧文件" end
return false,("仍存在: "..table.concat(bad,", ").."  (点「一键修复」可删)")
end
local function d5()
local _,hum,root=GC()
if not hum then return true,"当前没有角色" end
local bad={}
local okW,ws=pcall(function() return hum.WalkSpeed end)
if okW and ws and ws>24 then bad[#bad+1]=("WalkSpeed=%.1f (默认16)"):format(ws) end
local okJ,jp=pcall(function() return hum.JumpPower end)
if okJ and jp and jp>80 then bad[#bad+1]=("JumpPower=%.0f (默认50)"):format(jp) end
local okH,hh=pcall(function() return hum.HipHeight end)
if okH and hh and math.abs(hh-2)>4 then bad[#bad+1]=("HipHeight=%.1f (默认2)"):format(hh) end
if SYS.T_.LockGravity and math.abs((WS.Gravity or 196.2)-196.2)>0.5 then
bad[#bad+1]=("Gravity=%.1f (默认196.2)"):format(WS.Gravity)
end
if #bad==0 then return true,"角色数值全在正常范围内" end
return false,("服务端可测到的异常: "..table.concat(bad," · ").."  (这类遮不住, 建议用时再开)")
end
local function d6()
if not AC.SamplerOn then
return true,"采样器未运行 —— 点「开始采样」并正常玩 5~10 秒再测"
end
local m=AC.PosMax
if m<=0 then return true,"采样中, 尚未记录到位移" end
if m>60 then
return false,("单帧最大位移 %.0f 格 (正常走路 60fps ≈ 0.3 格) —— 这一跳服务端一定看得见"):format(m)
end
return true,("单帧最大位移 %.1f 格, 在合理范围内"):format(m)
end
local function d7()
local d=SYS.C_.CB_FireDelay or 0.06
if d<0.08 then
return false,("开火间隔 %.3f 秒 < 人类下限 0.08 —— 统计几十枪就能判定脚本(现已加 ±20%% 抖动, 但基准仍偏快)"):format(d)
end
return true,("开火间隔 %.3f 秒 + ±20%% 抖动, 节奏不恒定"):format(d)
end
local function d8()
if not AC.SamplerOn then return true,"采样器未运行(点「开始采样」)" end
if AC.CamMax>40 then
return false,("相机与角色最大偏离 %.0f 格 —— 自由视角/灵魂出窍在客户端很显眼"):format(AC.CamMax)
end
return true,("相机与角色最大偏离 %.1f 格, 正常"):format(AC.CamMax)
end
local function d9()
local P_=SYS.Prot or {}
local installed={}
if (P_.Hooks or {}).kick then installed[#installed+1]="踢人拦截" end
if (P_.Hooks or {}).tp then installed[#installed+1]="传送拦截" end
if (P_.Hooks or {}).hide then installed[#installed+1]="GUI枚举隐藏" end
if SYS.RayHook and SYS.RayHook.Hooked then installed[#installed+1]="射线改写" end
local caps=(P_.CapsText and P_.CapsText()) or "不可用"
if #installed==0 then
return true,"当前没有装任何 hook (攻击面最小); 执行器能力: "..caps
end
return true,("%d 个 hook 在装: %s —— 只有【执行器级】对手能枚举出来, 游戏脚本看不到。执行器能力: %s")
:format(#installed,table.concat(installed,"/"),caps)
end
local function d10()
local g=SYS.GV and SYS.GV(SYS.GK.loaded,LEG_LOADED) or nil
local viaNew=(GENV[SYS.GK.loaded]~=nil)
local viaOld=(GENV[LEG_LOADED]~=nil)
if viaOld then
return false,"旧键 GENV."..LEG_LOADED.." 仍存在 —— 执行器里任何脚本都能据此确认我们在跑"
end
if viaNew then return true,"状态键已是中性名("..SYS.GK.loaded..")" end
return true,"会话未注册外部状态键"
end
AC.List={
{"D1","实例足迹扫描",d1},
{"D2","菜单可见性",d2},
{"D3","getgenv 足迹",d3},
{"D4","落盘文件足迹",d4},
{"D5","角色数值异常",d5},
{"D6","位移跳变(瞬移)",d6},
{"D7","开火节奏",d7},
{"D8","相机行为",d8},
{"D9","hook 自检",d9},
{"D10","外部状态键",d10},
}
function AC.RunAll(quiet)
AC.Results={}
local pass=0
local out={"","=== CheatMenu 反作弊对抗靶场 · 自检结果 ==="}
out[#out+1]=("被测: 本脚本 v%s   时间 %s"):format(tostring(SYS.BuildVer or "?"),os.date("%Y-%m-%d %H:%M:%S"))
out[#out+1]="说明: 对手 = 游戏侧反作弊脚本(Lua 可见层)。Hyperion 是原生层, Lua 碰不到(见脚本头注释)。"
out[#out+1]=string.rep("-",72)
for i=1,#AC.List do
local id,nm,fn=AC.List[i][1],AC.List[i][2],AC.List[i][3]
local ok,res,detail=pcall(fn)
local p=(ok and res==true)
if p then pass=pass+1 end
AC.Results[#AC.Results+1]={id=id,name=nm,pass=p,detail=tostring(detail or (ok and "" or res))}
out[#out+1]=("%s %-4s %-18s %s"):format(p and "[通过]" or "[未通过]",id,nm,tostring(detail or ""))
end
out[#out+1]=string.rep("-",72)
out[#out+1]=("通过 %d / %d"):format(pass,#AC.List)
if not quiet then
print(table.concat(out,"\n"))
SYS.Notify(("🧪 对抗靶场: 通过 %d/%d"):format(pass,#AC.List),
pass==#AC.List and SYS.CY.green or SYS.CY.orange)
end
AC.Pass=pass AC.Total=#AC.List
if SYS.ACRender then P(SYS.ACRender) end
return pass,#AC.List
end
function AC.FixAll()
local done={}
if SYS.ApplyNeutralNames then
local n=P(SYS.ApplyNeutralNames)
done[#done+1]=n and "实例名已中性化" or "实例名中性化失败"
end
if SYS.Prot and SYS.Prot.InstallHideGui then
local ok,err=SYS.Prot.InstallHideGui()
if ok then SYS.T_.Prot_AntiAdmin=true done[#done+1]="CoreGui 枚举隐藏已开"
else done[#done+1]="枚举隐藏失败: "..tostring(err) end
end
local cleared={}
local legacy={LEG_LOADED,LEG_UNLOAD,LEG_BOOT,LEG_NOTE}
for i=1,#legacy do
if GENV[legacy[i]]~=nil then
pcall(function() GENV[legacy[i]]=nil end)
cleared[#cleared+1]=legacy[i]
end
end
done[#done+1]=(#cleared>0) and ("已清旧状态键: "..table.concat(cleared,",")) or "无旧状态键需清"
if type(delfile)=="function" then
local dl={}
local list={SYS.N.OldCfg,SYS.N.OldCfg..".bak",SYS.N.OldDiag}
for i=1,#list do
local okf,v=pcall(isfile,list[i])
if okf and v then
local okd=pcall(delfile,list[i])
if okd then dl[#dl+1]=list[i] end
end
end
done[#done+1]=(#dl>0) and ("已删旧文件: "..table.concat(dl,",")) or "无旧文件需删"
else
done[#done+1]="这台执行器没有 delfile(旧文件要手动删)"
end
if (SYS.C_.CB_FireDelay or 0.06)<0.08 then
SYS.C_.CB_FireDelay=0.08
done[#done+1]="开火间隔已抬到 0.08s(人类下限)"
end
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
print("[CheatMenu] 对抗靶场 · 一键修复: "..table.concat(done," · "))
SYS.Notify("🔧 修复完成, 重新测一次看通过率",SYS.CY.green)
P(function() AC.RunAll(true) end)
end
function SYS.ApplyNeutralNames()
local ok=true
local function ren(o,n)
if not o then return true end
local k=P(function() o.Name=n end)
if not k then ok=false end
return k
end
ren(SYS.ScreenGui,SYS.N.Gui)
ren(SYS.FloatGui,SYS.N.Float)
ren(SYS._f3Gui,SYS.N.F3)
if SYS.WP and SYS.WP.Marks then
for _,m in pairs(SYS.WP.Marks) do ren(m,SYS.N.WP) end
end
pcall(function()
local ch=LP.Character
local root=ch and ch:FindFirstChild("HumanoidRootPart")
if root then
for _,c in ipairs(root:GetChildren()) do
if c.Name==SYS.N.OldLantern or c.Name=="CheatMenu_Lantern" then ren(c,SYS.N.Lantern) end
end
end
end)
pcall(function()
if not LT then return end
for _,c in ipairs(LT:GetChildren()) do
if c.Name=="CheatMenu_FX" then ren(c,SYS.N.FX) end
end
end)
return ok
end
end
do
local AH_KW=SYS.KwHidePrompt
local HOST_KW2={"monster","enemy","hostile","killer","seek","rush","ambush","figure","halt","screech","eyes",
"dupe","snare","spider","jumpscare","zombie","mob","hunter","chaser","怪","敌","杀手","鬼"}
local QI_ORIG={}
local function nearestEnemyDist()
local _,_,root=GC()
local mp=root and root.Position
if not mp then return nil end
local bd=nil
P(function()
for _,m in ipairs(WS:GetChildren()) do
local h=m:FindFirstChildOfClass("Humanoid")
if h and h.Health>0 and not Players:GetPlayerFromCharacter(m) then
local rp=m.PrimaryPart or m:FindFirstChild("HumanoidRootPart")
if rp then
local nm=tostring(m.Name or ""):lower()
local hit=false
for _,kw in ipairs(HOST_KW2) do if nm:find(kw,1,true) then hit=true break end end
if hit then
local d=(rp.Position-mp).Magnitude
if not bd or d<bd then bd=d end
end
end
end
end
end)
return bd
end
local function findHidePrompt()
local _,_,root=GC()
local mp=root and root.Position
if not mp then return nil end
local best,bd=nil,1e9
P(function()
for _,o in ipairs(SYS.Index()) do
if o.ClassName=="ProximityPrompt" then
local nm=tostring(o.Name or ""):lower()
local act=tostring(o.ActionText or ""):lower()
local hit=false
for _,kw in ipairs(AH_KW) do
if nm:find(kw,1,true) or act:find(kw,1,true) then hit=true break end
end
if hit then
local par=o.Parent
local pos=par and par.Position
if pos then
local d=(pos-mp).Magnitude
if d<bd then bd=d best=o end
end
end
end
end
end)
return best,bd
end
function SYS.QuickInteractTick()
if not SYS.T_.QuickInteract then return end
local now=os.clock()
if now-(SYS._qiAt or 0)<2 then return end
SYS._qiAt=now
local rng=tonumber(SYS.C_.QuickRange) or 60
P(function()
for _,o in ipairs(SYS.Index()) do
local cn=o.ClassName
if cn=="ProximityPrompt" or cn=="ClickDetector" then
local rec=QI_ORIG[o]
if not rec then
rec={}
pcall(function() rec.h=o.HoldDuration end)
pcall(function() rec.d=o.MaxActivationDistance end)
QI_ORIG[o]=rec
end
if cn=="ProximityPrompt" then pcall(function() o.HoldDuration=0 end) end
pcall(function() if o.MaxActivationDistance<rng then o.MaxActivationDistance=rng end end)
end
end
end)
end
function SYS.SetQuickInteract(on)
SYS.T_.QuickInteract = on and true or false
if on then
SYS.SetLoop("QuickInteract",true,RS.Heartbeat,SYS.QuickInteractTick)
SYS.QuickInteractTick()
SYS.Notify(("⚡ 快速交互: 开 —— 按住时长归零 + 触发距离 >= %d 格"):format(tonumber(SYS.C_.QuickRange) or 60), SYS.CY.green)
else
SYS.SetLoop("QuickInteract",false)
P(function()
for pr,v in pairs(QI_ORIG) do
if pr and pr.Parent then
if v.h then pcall(function() pr.HoldDuration=v.h end) end
if v.d then pcall(function() pr.MaxActivationDistance=v.d end) end
end
end
end)
QI_ORIG={}
SYS.Notify("⚡ 快速交互: 关(已还原)", SYS.CY.sub)
end
end
function SYS.AutoHideNow()
local pr,d=findHidePrompt()
if not pr then
SYS.Notify("🏃 自动藏身: 没找到藏身点(名字/动作里没有 hide/closet/wardrobe/bed…)", SYS.CY.yellow)
return false
end
local ok=false
if type(fireproximityprompt)=="function" then
ok=P(function() fireproximityprompt(pr) end)
end
if not ok then
ok=P(function() pr:InputHoldBegin() end)
if ok then task.delay(0.05,function() P(function() pr:InputHoldEnd() end) end) end
end
SYS.Notify(ok and ("🏃 自动藏身: 已钻进 %s (离你 %.0f 格)"):format(tostring(pr.Parent and pr.Parent.Name or pr.Name), d or 0)
or "🏃 自动藏身: 触发失败(执行器不支持 fireproximityprompt)", ok and SYS.CY.green or SYS.CY.yellow)
return ok
end
function SYS.AutoHideTick()
if not SYS.T_.AutoHide then return end
local now=os.clock()
if now-(SYS._ahAt or 0)<1 then return end
SYS._ahAt=now
local d=nearestEnemyDist()
local thr=tonumber(SYS.C_.AutoHideDist) or 40
if d and d<thr then SYS.AutoHideNow() end
end
function SYS.SetAutoHide(on)
SYS.T_.AutoHide = on and true or false
if on then
SYS.SetLoop("AutoHide",true,RS.Heartbeat,SYS.AutoHideTick)
SYS.Notify(("🏃 自动藏身: 开 —— 敌对生物进到 %d 格内自动钻最近藏身点"):format(tonumber(SYS.C_.AutoHideDist) or 40), SYS.CY.green)
else
SYS.SetLoop("AutoHide",false)
SYS.Notify("🏃 自动藏身: 关", SYS.CY.sub)
end
end
function SYS.ReadHintTexts()
local out={}
P(function()
for _,o in ipairs(SYS.Index()) do
local nm=tostring(o.Name or ""):lower()
local isHint=false
for _,kw in ipairs(SYS.KwClueText) do if nm:find(kw,1,true) then isHint=true break end end
if isHint then
local sg=o:FindFirstChildOfClass("SurfaceGui")
if not sg and o.Parent then sg=o.Parent:FindFirstChildOfClass("SurfaceGui") end
if sg then
local txt={}
for _,g in ipairs(sg:GetDescendants()) do
if g:IsA("TextLabel") or g:IsA("TextBox") then
local t=tostring(g.Text or "")
if t~="" and #t<200 then txt[#txt+1]=t end
end
end
if #txt>0 then out[#out+1]={name=tostring(o.Name),text=table.concat(txt," / ")} end
end
end
end
end)
return out
end
function SYS.DumpHintTexts()
local list=SYS.ReadHintTexts()
if #list==0 then
print("[Hint] 没读到密码书/提示纸的文字(可能是贴图 Decal, 或还没复制到客户端)")
SYS.Hud("📖 没读到密码提示(可能是贴图)",4)
return
end
print(("[Hint] 读到 %d 条提示:"):format(#list))
for i,v in ipairs(list) do print(("   %d) %s -> %s"):format(i,v.name,v.text)) end
SYS.Hud(("📖 %s"):format(tostring(list[1].text)):sub(1,120),8)
end
function SYS.BlockHandlersTick()
if not SYS.T_.BlockHandlers then return end
local now=os.clock()
if now-(SYS._bhAt or 0)<0.5 then return end
SYS._bhAt=now
local _,h=GC()
if h then
P(function()
h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
h:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
h:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
h:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
end)
end
end
function SYS.SetBlockHandlers(on)
SYS.T_.BlockHandlers = on and true or false
if on then
SYS.SetLoop("BlockHandlers",true,RS.Heartbeat,SYS.BlockHandlersTick)
SYS.BlockHandlersTick()
SYS.Notify("🧱 表现层对抗: 开(禁布娃娃/物理状态)", SYS.CY.green)
else
SYS.SetLoop("BlockHandlers",false)
SYS.Notify("🧱 表现层对抗: 关", SYS.CY.sub)
end
end
end
UI.Defs={
{name="战斗",icon="⚔"},{name="视觉",icon="◉"},{name="移动",icon="◈"},{name="玩家",icon="👤"},
{name="MachineParty",icon="🎮"},{name="传送",icon="➲"},{name="挂机",icon="★"},{name="功能",icon="✱"},{name="翻译",icon="🌐"},{name="设置",icon="⚙"},
}
UI.Pages["移动"]=function(p)
UI.Section(p,"✈️ 飞行",CY.accent)
UI.Switch(p,"飞行 (Fly)","Fly",function(on)
if not on then SYS.CleanFly() end
SYS.SetLoop("Fly",on,SYS.PhysicsStep,SYS.FlyTick)
P(SYS.SyncAntiRevert)
end)
UI.Slider(p,"飞行速度倍率",0,20,0.5,function() return SYS.C_.FlySpeed end,function(v) SYS.C_.FlySpeed=v end)
UI.Cycle(p,"飞行模式",{"Align","BodyVelocity","CFrame"},
function() return SYS.C_.FlyMode end,
function(v) SYS.C_.FlyMode=v if SYS.T_.Fly then SYS.CleanFly() end end)
UI.Tip(p,"★ 默认「Align」= 官方推荐的 LinearVelocity + AlignOrientation, 也最不容易被服务器拉回。\n「BodyVelocity」= 老执行器(已弃用), 兼容用。\n「CFrame」= 逐帧瞬移, **会被服务端位置校验拉回**, 不推荐。\n另外: 新版本开飞行时不再把世界重力清零(那正是被拉回的经典原因), 只对角色自身抵消重力。",CY.yellow)
UI.Div(p)
UI.Section(p,"⚡ 移动加速",CY.accent)
UI.Switch(p,"加速 (Speed)","Speed",function(on)
if not on then SYS.CleanSpeed() end
SYS.SetLoop("Speed",on,SYS.PhysicsStep,SYS.SpeedTick)
P(SYS.SyncAntiRevert)
end)
UI.Slider(p,"移动速度倍率",0,20,0.5,function() return SYS.C_.SpeedMult end,function(v) SYS.C_.SpeedMult=v end)
UI.Cycle(p,"加速模式",{"Linear","BodyVelocity","WalkSpeed"},
function() return SYS.C_.SpeedMode end,
function(v) SYS.C_.SpeedMode=v if SYS.T_.Speed then SYS.CleanSpeed() end end)
UI.Tip(p,"默认「Linear」= 官方推荐的 LinearVelocity(旧 BodyVelocity 已弃用, 保留兼容)。\n「WalkSpeed」= 只改走路速度, 最朴素也最稳。\n⚠️ 倍率建议 ≤ 2: 服务端按【每 tick 位移 > 正常速度 ×2】判定加速作弊, 调太高会被记一笔。",CY.yellow)
UI.Div(p)
UI.Section(p,"🕳 穿墙 (NoClip)",CY.accent)
UI.Switch(p,"穿墙 (角色各部位关碰撞)","Noclip",function(on)
P(SYS.SetNoclip,on)
SYS.Notify(("🕳 穿墙 %s"):format(on and "已开" or "已关"), on and SYS.CY.green or SYS.CY.sub)
end)
UI.Tip(p,"把角色所有部件的 CanCollide 关掉, 并每帧复查一遍(游戏写回来会再关一次); 重生后自动套到新角色。\n"..
"⚠ 纯客户端: 服务端仍按它自己的碰撞判定走 —— 能不能真穿过去取决于该游戏是客户端还是服务端权威。\n"..
"⚠ 部分游戏对「位置异常/卡进几何体」另有校验, 出现被拉回或被踢属正常风险。",CY.yellow)
UI.Div(p)
UI.Section(p,"🛡 免伤",CY.green)
local NA={tick=0, wrote=0, scanned=0, others={}}
SYS.NoAggroInfo=NA
local function otherTarget(pos)
local best,bd=nil,math.huge
for _,pl in ipairs(Players:GetPlayers()) do
if pl~=SYS.LP then
local r=bodyOf(pl.Character)
if r then
local d=(r.Position-pos).Magnitude
if d<bd then bd=d best=r end
end
end
end
return best
end
local NA_ATTRS={"Target","Enemy","Aggro","TargetPlayer","TargetEntity","Hostile"}
function SYS.NoAggroTick()
if not SYS.T_.NoAggro then return end
P(function()
local me=bodyOf(SYS.LP.Character)
if not me then return end
local n,w=0,0
for _,m in ipairs(WS:GetChildren()) do
local h=pcall(function() return m:FindFirstChildOfClass("Humanoid") end) and m:FindFirstChildOfClass("Humanoid") or nil
if h then
local pl=Players:GetPlayerFromCharacter(m)
if not pl then
n=n+1
local root=m.PrimaryPart or m:FindFirstChild("HumanoidRootPart")
local pos=root and root.Position
for _,k in ipairs(NA_ATTRS) do
local ok,av=P(function() return m:GetAttribute(k) end)
if ok and av~=nil then
local isMe=(av==SYS.LP.Name) or (av==SYS.LP) or (av==SYS.LP.Character)
if isMe and pos then
local newt=otherTarget(pos)
if newt then
local ok2=P(function() m:SetAttribute(k,newt.Name) end)
if ok2 then w=w+1 end
end
end
end
end
end
end
end
NA.scanned=n NA.wrote=NA.wrote+w NA.tick=NA.tick+1
end)
end
local NoAggroPrev=nil
function SYS.SetNoAggro(on)
SYS.T_.NoAggro = on and true or false
if not on then
local prev=NoAggroPrev or {}
NoAggroPrev=nil
if not prev.trap  then SYS.T_.TrapImmune=false end
if not prev.dodge then SYS.T_.AutoDodge=false end
P(function()
if not prev.trap and SYS.SetTrapImmune then SYS.SetTrapImmune(false) end
if not prev.dodge and SYS.SetAutoDodge then SYS.SetAutoDodge(false) end
if prev.dodge and SYS.T_.AutoDodge and SYS.SetAutoDodge then SYS.SetAutoDodge(true) end
if prev.trap  and SYS.T_.TrapImmune and SYS.SetTrapImmune then SYS.SetTrapImmune(true) end
end)
SYS.Notify("🕊 无仇恨模式已关",SYS.CY.sub)
return
end
NoAggroPrev={trap=SYS.T_.TrapImmune and true or false, dodge=SYS.T_.AutoDodge and true or false}
SYS.T_.TrapImmune=true SYS.T_.AutoDodge=true
P(function()
if SYS.SetTrapImmune then SYS.SetTrapImmune(true) end
if SYS.SetAutoDodge then SYS.SetAutoDodge(true) end
end)
SYS.SpawnLoop(function()
while SYS.T_.NoAggro and not SYS.Unloaded do
task.wait(0.5)
P(SYS.NoAggroTick)
end
end)
SYS.Notify("🕊 无仇恨模式已开: 正在把怪的目标改写到别人身上\n(附赠 反陷阱免伤 + 自动躲; 不再自动潜地 —— 要隐身请自己开「藏地下隐身」\n控制台可看 SYS.NoAggroInfo)",SYS.CY.cyan)
end
UI.Switch(p,"🕊 无仇恨模式 (怪去打别人 · 唯独不打你)","NoAggro",function(on)
P(SYS.SetNoAggro,on)
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
end)
UI.Tip(p,"「无仇恨」= 把怪物的目标从你身上【挪到别人身上】。怪物打谁由服务端 AI 决定, 客户端只能: \n① 若它把目标存在客户端可读写的 Attribute 里(Target|Enemy|Aggro|TargetPlayer…) -> 直接改写成最近的别的玩家;\n② 改不动 -> 退化成「隐去自己 + 免伤 + 自动躲」(它找不到你, 只能去找别人)。\n诊断: 控制台执行 print(SYS.NoAggroInfo) 看 扫了几个怪 / 改写成功几次。",CY.sub)
UI.Btn(p,"🔎 看看有哪些怪 / 甩仇成功几次 (控制台)",CY.cyan,function()
P(function()
local i=SYS.NoAggroInfo or {}
print(("[NoAggro] 扫描轮次=%s  扫到非玩家 Humanoid=%s  改写成功=%s")
:format(tostring(i.tick),tostring(i.scanned),tostring(i.wrote)))
local n=0
for _,m in ipairs(WS:GetChildren()) do
local h=m:FindFirstChildOfClass("Humanoid")
if h and not Players:GetPlayerFromCharacter(m) then
n=n+1
local at={}
for _,k in ipairs(NA_ATTRS) do
local av=m:GetAttribute(k)
if av~=nil then at[#at+1]=k.."="..tostring(av) end
end
print(("   %s  %s"):format(tostring(m.Name),
#at>0 and table.concat(at,"  ") or "(没有任何 Target/Enemy/Aggro 类属性)"))
end
end
if n==0 then print("   (Workspace 里没有非玩家的 Humanoid 模型 —— 这局可能全是玩家)") end
end)
end)
UI.Switch(p,"🛡 反陷阱免伤","TrapImmune",SYS.SetTrapImmune)
UI.Tip(p,"★ 完全豁免: 被撞/被弹开/被推走的位移 · 定身(走不动) · 布娃娃倒地 · 被坐骑锁住 · 被焊接钉住 · 客户端结算的伤害(掉血立刻补回)。\n★ 免不了: 服务端结算的伤害 —— 服务端是权威, 它扣的血客户端改不动。\n★ 滚石: 被撞后【水平速度清零 + 被拉走就渐进压回撞击点】, 所以不弹开、不被压着推走。\n★ 与「上帝模式」同开时会互相让位(不抢同一个状态)。",CY.yellow)
UI.Section(p,"🦘 跳跃",CY.accent)
UI.Switch(p,"无限跳跃","InfiniteJump",SYS.SetInfiniteJump)
UI.Switch(p,"⤴ 超级跳跃 (跳得更高)","JumpBoost",SYS.SetJumpBoost)
UI.Slider(p,"跳跃高度倍率",1,10,0.5,function() return SYS.C_.JumpMult end,
function(v)
SYS.C_.JumpMult=v
if SYS.T_.JumpBoost then P(SYS.SetJumpBoost,false) P(SYS.SetJumpBoost,true) end
end,"x%.1f")
end
UI.Pages["视觉"]=function(p)
UI.Section(p,"👁 活物透视 (玩家 / 生物)",CY.accent)
UI.Tip(p,"透视 = 人物高亮(把整个人染色描边, 穿墙可见)。\n掉落物透视用同款高亮(统一亮青) —— 只认【客户端已经拿到】的世界物件(名字像掉落物, 或带可捡/可交互提示)。\nRoblox 不会把别人的背包复制给你, 所以别人包里的东西看不到是引擎限制, 不是脚本问题。")
local LIVING_MODES={"关闭","仅玩家","全部活物(含 NPC/怪物)"}
UI.Cycle(p,"👁 活物透视",LIVING_MODES,
function()
if SYS.T_.ESP_NPC then return "全部活物(含 NPC/怪物)" end
if SYS.T_.ESP    then return "仅玩家" end
return "关闭"
end,
function(v)
SYS.T_.ESP_NPC=(v=="全部活物(含 NPC/怪物)")
SYS.T_.ESP    =(v~="关闭")
SYS.ESPMaybeClear()
end)
UI.Tip(p,"把所有【活物】都点亮。🎨 配色: 玩家 = 队友绿 / 敌人红 / 幽灵紫; "..
"非玩家生物 = 敌对红 / 中立橙。\n"..
"「敌对」判据 = 名字或 3 层祖先命中敌意词(monster / enemy / seek / rush / ambush / figure / halt / screech / eyes / dupe / snare / spider …)，"..
"或 Attribute Hostile / Enemy / Aggro 为 true。\n"..
"拿不准一律算【中立橙】—— 与玩家透视「拿不到队伍 = 队友绿」同一个保守口径, 不误标红。\n"..
"藏身/幽灵态(Humanoid.Health 被游戏打成 0)照样亮 —— 透视本来就该看得见「藏起来的」。\n"..
"全 Workspace 扫描已节流, 并与其它透视共用同一次扫描; 隔墙时填充更透。",CY.sub)
UI.Div(p)
UI.Section(p,"🪧 头顶标签 (名字 / 武器标记)",CY.accent)
UI.Switch(p,"🪧 头顶标签 (名字+血量+距离 · 有武器就标红)","ESPNameTag",function(on)
SYS.T_.ESPWeapon=on
SYS.ESPMaybeClear()
end)
UI.Slider(p,"名字高度(额外抬高)",0,8,0.2,
function() return SYS.C_.ESPNameH end,function(v) SYS.C_.ESPNameH=v end,"+%.1f")
UI.Tip(p,"标签内容 = 名字(优先 DisplayName) + 当前/最大血量 + 离你几格; 血量低于 60% 转橙、低于 30% 转红。\n"..
"有武器(手上或背包里, 标准 Backpack 属性)就在下方再标一行 🔫 武器名(红字)。\n"..
"挂点自动回退 Head -> UpperTorso -> Torso -> HumanoidRootPart, 名字高度再按角色包围盒自动贴顶。",CY.sub)
UI.Div(p)
UI.Section(p,"⚡ 交互 · 藏身 (对照公开脚本补的)",CY.green)
UI.Switch(p,"⚡ 快速交互 (免按住 + 触发距离拉大)","QuickInteract",SYS.SetQuickInteract)
UI.Slider(p,"快速交互距离 (格)",10,300,5,function() return SYS.C_.QuickRange or 60 end,
function(v) SYS.C_.QuickRange=v end,"%.0f")
UI.Switch(p,"🏃 自动藏身 (敌对生物靠近自动钻进藏身点)","AutoHide",SYS.SetAutoHide)
UI.Slider(p,"自动藏身触发距离 (格)",5,150,5,function() return SYS.C_.AutoHideDist or 40 end,
function(v) SYS.C_.AutoHideDist=v end,"%.0f")
UI.Btn(p,"🏃 立即钻一次藏身点",CY.green,function() P(SYS.AutoHideNow) end)
UI.Btn(p,"📖 读密码提示 (控制台 + HUD)",CY.cyan,function() P(SYS.DumpHintTexts) end)
UI.Tip(p,"⚡ 快速交互 = ProximityPrompt 的「按住时长」归零 + 触发距离拉大(本地视角; 服务端一般只校验距离/权限)。\n"..
"🏃 自动藏身 = 敌意生物进到设定距离, 用最近的藏身点 Prompt 钻进去 —— 等价于你按 E, **走服务端认可那条路**(不保证服务端一定接受)。\n"..
"📖 读密码提示 = 找名字含 hint/book/note/paper 的物件并读出它表面 SurfaceGui 上的文字(贴图 Decal 读不到)。",CY.sub)
UI.Div(p)
UI.Section(p,"📦 物件高亮 (掉落物 / 可交互 / 门·陷阱·假门 / 小游戏)",CY.accent)
UI.Switch(p,"🔍 物件透视 (掉落物 / 可交互 / 门·陷阱·假门 / 小游戏 一起)","ESP_Pick",function(on)
SYS.T_.ESPItem=on SYS.T_.ESP_Door=on SYS.T_.ESP_Mini=on
SYS.ESPMaybeClear()
end)
UI.Tip(p,"一个开关同时点亮四类物件(判据合并, 不用分别开):\n"..
"· 掉落物: 名字像掉落物(pickup/item/chest/gold…), 或客户端能看到的可捡物件\n"..
"· 可交互: 带 ClickDetector / ProximityPrompt / Tool; 或名字与 3 层祖先名命中分类表(箱子/梯子/按钮/传送/座位/商店/检查点/书·线索/道具·补给/躲藏点/小游戏); 或部件上挂了 SurfaceGui 且里面有字(=密码纸条/提示牌)\n"..
"· 门 / 陷阱 / 假门: 名字或 3 层祖先命中门·危险词; 或结构是会转的门(Hinge/Motor6D); 或竖直薄板(高>=3.5、厚<=1.5、宽>=2.2, 且不可碰撞/半透明/带贴花/带交互提示)\n"..
"· 小游戏区域: 名字或 3 层祖先命中区域名(duck hunt / chisel / gauntlet / rightofway / blindout / crushhour / bumpermadness / mpstation / mppadhost / machin) 或含「小游戏/关卡/模式」\n"..
"🎨 颜色统一: 普通物件 + 普通门 + 小游戏里的东西 = 【亮青轮廓】; 危险(陷阱·伤害机关·切割·假门) = 【红色】+ ☠ 骷髅头。\n"..
"💡 小游戏区域透视已并入本开关 —— MachineParty 页不再单独提供。",CY.sub)
UI.Div(p)
UI.Section(p,"🎯 射线 (人物射线 / 弹道)",CY.accent)
local TR_MODES={"关闭","只锁定的目标","全部玩家"}
UI.Cycle(p,"子弹射线 (只画线, 不改弹道)",TR_MODES,
function()
if not SYS.T_.Tracer then return "关闭" end
return SYS.T_.TracerAll and "全部玩家" or "只锁定的目标"
end,
function(v)
SYS.T_.Tracer=(v~="关闭")
SYS.T_.TracerAll=(v=="全部玩家")
if not SYS.T_.Tracer then P(SYS.TracerHide) end
end)
UI.Slider(p,"射线最远距离 (格 · 0=不限)",0,2000,50,
function() return SYS.C_.TracerMaxDist or 500 end,
function(v) SYS.C_.TracerMaxDist=v end,"%.0f")
UI.Slider(p,"射线最多几条 (人多时防卡)",1,24,1,
function() return SYS.C_.TracerMaxN or 12 end,
function(v) SYS.C_.TracerMaxN=v end,"%.0f")
UI.Tip(p,"从一个挂点(枪口 / 手 / 头, 都取不到就退回相机)画一条 Neon 细线。\n"..
"· 只锁定的目标 = 画到【战斗页当前锁定的目标】身上; 没有目标就沿朝向画 200 格(原行为)\n"..
"· 全部玩家 = 给每个其他玩家各画一条 —— 池化复用(每人一条常驻, 只改位置/长度, 不每帧新建),\n"..
"  谁在哪、谁在朝我这边, 一眼就有数。「最远距离」「最多几条」两道上限防几十人局画满屏。\n"..
"纯视觉: 只画线, 不改弹道、不改命中判定。",CY.sub)
UI.Div(p)
UI.Section(p,"🎥 自由视角 (镜头飞出去看, 人留在原地)",CY.cyan)
UI.Switch(p,"自由视角","FreeCam",function(on)
if on then SYS.StartFreeCam() else SYS.StopFreeCam() end
end)
UI.Slider(p,"自由视角速度",10,300,5,function() return SYS.C_.FreeCamSpeed end,function(v) SYS.C_.FreeCamSpeed=v end,"%.0f")
UI.Slider(p,"自由视角灵敏度",0.1,2,0.05,function() return SYS.C_.FreeCamSens end,function(v) SYS.C_.FreeCamSens=v end,"%.2f")
UI.Div(p)
UI.Section(p,"🌗 光照 · 去雾 (夜视 / 全亮 / 禁雾)",CY.orange)
UI.Cycle(p,"光照档位",SYS.LIGHT_MODES,
function() return SYS.C_.LightMode or "关闭" end,
function(v) SYS.C_.LightMode=v P(SYS.ReapplyLight) end)
UI.Switch(p,"🚫 禁雾 (去迷雾 · 远处不再白茫茫)","NoFog",function() P(SYS.ReapplyLight) end)
UI.Switch(p,"🌑 禁阴影","NoShadow",function() P(SYS.ReapplyLight) end)
UI.Switch(p,"🏮 随身灯笼 (只有你看得见的光)","Lantern",function() P(SYS.ReapplyLight) end)
local __DIST={"600","1200","3000","8000","全图"}
UI.Cycle(p,"透视距离 (物件/门/小游戏)",__DIST,
function()
local d=tonumber(SYS.C_.PickDist) or 1200
if d>=9000 then return "全图" end
return tostring(math.floor(d+0.5))
end,
function(v)
local m={["600"]=600,["1200"]=1200,["3000"]=3000,["8000"]=8000,["全图"]=99999}
SYS.C_.PickDist=m[v] or 1200
end)
UI.Tip(p,"禁雾 = 把 Lighting 的 FogEnd/FogStart 拉到极远 —— 远处不再白茫茫一片。\n"..
"光照档位互斥: 关闭 / 夜视(提亮) / 超级光明(最亮) / 全亮(亮 + 正午 + 禁雾 + 禁阴影)。\n"..
"透视距离只作用于【物件 / 门 / 小游戏】; 玩家透视本来就是全图, 不受它限制。\n"..
"⚠ 有 0.4s 低频守护: 游戏把光改回去会自动抢回来。",CY.sub)
UI.Div(p)
end
UI.Pages["功能"]=function(p)
UI.Section(p,"🔍 综合扫描 (十层一次扫完)",CY.green)
UI.Btn(p,"🔍 综合扫描 (通信/代码/脚本/实例/数据/连接/环境/反查/DEX/Remote 十层一次扫完)",CY.green,function()
P(function() SYS.Lab.FullScan() end)
end)
UI.Btn(p,"📋 复制扫描摘要到剪贴板",CY.cyan,function() P(function() SYS.Lab.Summary() end) end)
UI.Btn(p,"🔎 探测本游戏的领取/收集/购买 remote",CY.sub,function()
P(function() SYS.ProbeEvent("claim") end)
P(function() SYS.ProbeEvent("pickup") end)
P(function() SYS.ProbeEvent("buy") end)
SYS.Notify("探测结果已打到控制台(F9)",SYS.CY.cyan)
end)
UI.Tip(p,"点【综合扫描】一个按钮, 结果全部打到控制台(F9), 按十层分行:\n  A 通信层 = 游戏有哪些 Remote(能触发什么) —— 原来是单独一个按钮, 现在合并进来了\n  B 代码层 = 游戏有哪些函数 + 名字可疑的(damage/fire/aim…)\n  C 脚本层 = 跑了哪些脚本/模块\n  D 实例层 = getnilinstances(游戏藏起来的对象) + Workspace 规模\n  E 数据层 = 自己和他人身上的 Attribute 全字段(vs @Health/@Team 就来自这里)\n  F 连接层 = 游戏自己挂了哪些事件监听\n  G 环境层 = 执行器/游戏全局 + registry + 线程身份(能判断脚本跑在什么权限下)\n  H 反查层 = getcallingscript(谁调起的) + 函数闭包 upvalue 概览\n  I DEX 层 = 全图实例浏览器: 类名 TOP30 + RemoteEvent/Script/ProximityPrompt 等关键类的完整路径 + 属性快照\n  J Remote 层 = 每条通道能不能用: 收向监听几条/谁在收 + 命中我们哪个功能类别 + 34 个类别的通道对账\n★ I/J 与其余八层是【同一个按钮、同一次全图遍历】, 不会为了它们把整个游戏多走一遍。\n★ I/J 的完整清单会自动落盘(DEX_/Remote_ 开头, 带游戏名与时间戳), 控制台只列前若干条。",CY.sub)
UI.Div(p)
UI.Switch(p,"上帝模式","GodMode",SYS.SetGod)
UI.Switch(p,"无坠落伤害","NoFall",SYS.SetNoFall)
UI.Switch(p,"🕳 藏地下隐身 (服务器认可)","DeepHide",SYS.SetDeepHide)
UI.Cycle(p,"藏身方向",{"地下","天上","平地"},
function()
local m=tostring(SYS.C_.DeepHideMode or "down")
return (m=="up") and "天上" or ((m=="flat") and "平地" or "地下")
end,
function(v)
SYS.C_.DeepHideMode=(v=="天上") and "up" or ((v=="平地") and "flat" or "down")
if SYS.DeepHideReapply then P(SYS.DeepHideReapply) end
end)
UI.Slider(p,"藏地下隐身深度 (格 · 小=能交互 / 大=藏得深 · 平地模式用不到)",5,300,5,
function() return SYS.C_.DeepHideDepth end,
function(v)
SYS.C_.DeepHideDepth=v
if SYS.DeepHideReapply then P(SYS.DeepHideReapply) end
end,"%.0f")
UI.Slider(p,"左右偏移 (格 · 正=右 负=左)",-100,100,1,
function() return SYS.C_.DeepHideOffX end,
function(v)
SYS.C_.DeepHideOffX=v
if SYS.DeepHideReapply then P(SYS.DeepHideReapply) end
end,"%.0f")
UI.Slider(p,"前后偏移 (格 · 正=前 负=后)",-100,100,1,
function() return SYS.C_.DeepHideOffZ end,
function(v)
SYS.C_.DeepHideOffZ=v
if SYS.DeepHideReapply then P(SYS.DeepHideReapply) end
end,"%.0f")
UI.Tip(p,"⚠ 藏地下=【真的把你传送进地下】(位置是服务器同步的, 无法只骗别人不骗自己)。\n"
.."· 能真实走动(水平速度不再被清零 + 脚下有块客户端隐形地板, 不会一直自由落体)。\n"
.."· 枪械/近战命中在客户端判定 -> 不受深度影响(能不能打中还取决于游戏是客户端还是服务端判定)。\n"
.."· 商店/NPC/偷取这类【按距离判定】的交互够不到 -> 把深度调到 10~20 格才有机会够到。\n"
.."· 藏天上 = 把你抬到头顶高处(相机仍留地面); 偏移 = 开启时往旁边挪一点(左/右/前/后)。\n"
.."· 关闭时会【在原地浮回地面】, 不会把你弹回开启时的位置。\n"
.."· 高风险: 服务器可能做位置校验把你拉回/踢掉。",CY.yellow)
UI.Switch(p,"穿透玩家","NoCollide",function(on) SYS.RefreshNC(on) end)
UI.Div(p)
UI.Section(p,"⚡ 帧率优化 (强化版)",CY.cyan)
UI.Switch(p,"帧率优化 (一键)","PerfBoost",SYS.SetPerf)
UI.Slider(p,"剔除距离",30,500,10,function() return SYS.C_.PerfCull end,function(v) SYS.C_.PerfCull=v end,"%.0f")
UI.Div(p)
UI.Section(p,"☠ 自杀 / 重生点",CY.red)
UI.Btn(p,"☠ 强制自杀 (抹除)",CY.red,function() SYS.ForceSuicide("erase") end)
UI.Btn(p,"🕳 强制自杀 (虚空抹除)",CY.red,function() SYS.ForceSuicide("void") end)
UI.Tip(p,"「抹除」= 直接移除你自己的角色模型; 「虚空抹除」= 先把角色挪到 -5000 高度再判死(某些游戏对出界的处理不同)。\n两条【只作用于你自己】。",CY.sub)
UI.Btn(p,"♻ 原地重生 (满血 + 回到当前点)",CY.green,function() SYS.RespawnHere() end)
UI.Btn(p,"📍 设置当前位置为重生点",CY.cyan,function() SYS.SetSpawnHere() end)
UI.Btn(p,"↩️ 恢复默认重生点",CY.orange,function() SYS.ClearSpawnHere() end)
UI.Tip(p,"重生点记账是【纯本地】的(写本地 RespawnLocation + 死了把你挪回去)。\n若这个游戏的重生位置由服务端决定, 本地改无效 —— 那时只有「原地重生」按钮能立即生效。",CY.sub)
UI.Div(p)
UI.Div(p)
UI.Section(p,"🛡 防护 (反作弊绕过 / 管理员检测 / 防踢出)",CY.orange)
UI.Switch(p,"🛡 一键开启全部防护","Prot_HideGui",function(on)
local function setOne(k,f)
if type(f)~="function" then
SYS.T_[k]=false
SYS.Notify("❌ "..k.." 开启失败: 这个功能在本机不可用",SYS.CY.red)
return false
end
local ok,err=f(on)
if not ok and on then
SYS.T_[k]=false
SYS.Notify("❌ "..k.." 开启失败: "..tostring(err),SYS.CY.red)
return false
end
return true
end
if on then
SYS.T_.Prot_AntiAC=true
SYS.T_.Prot_AntiAdmin=true
SYS.T_.Prot_AntiTP=true
setOne("Prot_AntiAC",SYS.Prot.InstallKickGuard)
setOne("Prot_AntiAdmin",function()
if SYS.ScreenGui then P(function() SYS.ScreenGui.Name="RobloxGui_Backpack" end) end
return SYS.Prot.InstallHideGui()
end)
setOne("Prot_AntiTP",SYS.Prot.InstallTPGuard)
setOne("AntiFling",SYS.SetAntiFling)
SYS.Notify("🛡 全部防护已尝试开启(失败项会单独提示)",SYS.CY.green)
else
SYS.T_.Prot_AntiAC=false
SYS.T_.Prot_AntiAdmin=false
SYS.T_.Prot_AntiTP=false
SYS.Prot.RemoveKickGuard()
SYS.Prot.RemoveHideGui()
SYS.Prot.RemoveTPGuard()
P(SYS.SetAntiFling,false)
SYS.Notify("防护已全部卸下",SYS.CY.sub)
end
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
end)
UI.Switch(p,"反作弊绕过 (只拦本地 Kick · 零开销)","Prot_AntiAC",function(on)
if on then
local ok,err=SYS.Prot.InstallKickGuard()
if not ok then
SYS.T_.Prot_AntiAC=false
SYS.Notify("❌ 开启失败: "..tostring(err),SYS.CY.red)
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
else
SYS.Notify("🛡 已装踢人拦截 · 被拦次数看控制台",SYS.CY.green)
end
else
SYS.Prot.RemoveKickGuard()
SYS.Notify("已卸下踢人拦截",SYS.CY.sub)
end
end)
UI.Switch(p,"管理员检测绕过 (挪进隐藏容器 · 零开销不卡)","Prot_AntiAdmin",function(on)
if on then
if SYS.ScreenGui then P(function() SYS.ScreenGui.Name="RobloxGui_Backpack" end) end
local ok,err=SYS.Prot.InstallHideGui()
if not ok then
SYS.T_.Prot_AntiAdmin=false
SYS.Notify("❌ 开启失败: "..tostring(err),SYS.CY.red)
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
else
SYS.Notify("🕵 菜单已挪进执行器隐藏容器 + 关闭 Archivable\n(不再 hook __namecall —— 之前那个是卡顿主因)",SYS.CY.green)
end
else
SYS.Prot.RemoveHideGui()
end
end)
UI.Switch(p,"防止被换服 / 换游戏 (拦截 TeleportService)","Prot_AntiTP",function(on)
if on then
local ok,err=SYS.Prot.InstallTPGuard()
if not ok then
SYS.T_.Prot_AntiTP=false
SYS.Notify("❌ 开启失败: "..tostring(err),SYS.CY.red)
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
else
SYS.Notify("🛡 已拦截 TeleportService",SYS.CY.green)
end
else
SYS.Prot.RemoveTPGuard()
end
end)
UI.Switch(p,"🎈 防甩飞 (被别人弹飞时立即清零速度)","AntiFling",SYS.SetAntiFling)
UI.Tip(p,"有人用约束/焊接把高速速度传染到你的角色上(俗称 fling/甩飞), 你会被弹到天上或地图外。\n"..
"这里每帧检查你自己的 AssemblyLinearVelocity, 超过 80 格/秒就清零。\n"..
"纯本地: 只动你自己的速度, 不改服务端判定; 正常跑步(16~30)与飞行/加速(走约束、不写这个字段)都不会被误伤。",CY.sub)
UI.Div(p)
UI.Section(p,"🚦 移动限速护栏 (开加速但别太离谱)",CY.yellow)
UI.Switch(p,"🚦 限制最高移速 (默认关)","Prot_SpeedCap",function(on)
if on then
SYS.Notify(("🚦 移速护栏已开 —— 所有加速路径最高 %.0f 格/秒"):format(tonumber(SYS.C_.SpeedCap) or 28),SYS.CY.green)
else
SYS.Notify("移速护栏已关(恢复原来的倍率)",SYS.CY.sub)
end
end)
UI.Slider(p,"护栏上限 (格/秒)",16,100,1,
function() return tonumber(SYS.C_.SpeedCap) or 28 end,
function(v) SYS.C_.SpeedCap=v end,"%.0f")
UI.Tip(p,"Roblox 默认走路是 16 格/秒; 服务端统计类反作弊最爱看「长期 >30」这种一眼假的数。\n"..
"打开后, 加速的三种模式(WalkSpeed / BodyVelocity / Linear)【最终写出去的速度】都会被压到上限以内;\n"..
"飞行、传送、防陷阱的判定基准(「我本来该有多快」)都不受影响 —— 只收窄真正写出去的数。\n"..
"默认 28: 比正常快一截, 又不至于离谱。想要原汁原味的倍率, 把它关掉即可。",CY.sub)
UI.Div(p)
UI.Section(p,"🔎 反指纹自检 (G6/G7)",CY.cyan)
UI.Btn(p,"🔎 跑一次反指纹自检 (结果打到控制台)",CY.cyan,function()
local fn=SYS.Prot and SYS.Prot.SelfAudit
local lines=fn and fn()
if type(lines)=="table" then
for _,l in ipairs(lines) do print(l) end
SYS.Notify(("🔎 自检完成: 共 %d 行, 详见控制台(F9)"):format(#lines),SYS.CY.cyan)
else
SYS.Notify("❌ 自检不可用",SYS.CY.red)
end
end)
UI.Btn(p,"🧹 擦掉 GUI 可疑名 (换成中性名)",CY.orange,function()
local fn=SYS.Prot and SYS.Prot.NeutralizeNames
local n=(fn and fn()) or 0
if n>0 then SYS.Notify(("🧹 已把 %d 个可疑名换成中性名"):format(n),SYS.CY.green)
else SYS.Notify("✔ GUI 名字里没有可疑词, 不用改",SYS.CY.sub) end
end)
UI.Tip(p,"只查三样(反作弊找外挂就看这些):\n"..
"① GUI 名字/层级里有没有 cheat / hack / 外挂 这类词 —— 有就点上面那个「擦掉」;\n"..
"② ScreenGui 挂在哪个容器: PlayerGui 任何脚本都能遍历, CoreGui 权限更高;\n"..
"③ 实例是不是 Archivable(能被 GetDescendants + Clone 打包抓走) —— 开「管理员检测绕过」会设成 false。\n"..
"⚠ 边界: 执行器自己的全局(getgenv / hookfunction 等)是注入的, 脚本层删不掉, 只做如实列出。\n"..
"  「擦掉」只动名字里真带可疑词的容器, 中性名(名字池里挑的那些)一律不碰。",CY.sub)
end
UI.Pages["挂机"]=function(p)
UI.Label(p,"挂机增强")
UI.Switch(p,"挂机防踢","AntiAFK",function(on)
if on then SYS.enableAntiAFK() else SYS.disableAntiAFK() end
end)
UI.Div(p)
UI.Label(p,"训练")
UI.Switch(p,"自动训练踢击力量","AutoTrain",function(on)
if on then SYS.StartTrain() else SYS.StopTrain() end
end)
UI.Slider(p,"训练循环间隔(秒)",1,30,0.5,function() return SYS.C_.AutoTrainSec end,function(v) SYS.C_.AutoTrainSec=v end,"%.1f")
UI.Div(p)
UI.Label(p,"进度")
UI.Switch(p,"自动重生","AutoRebirth",function(on)
if on then SYS.StartReb() else SYS.StopReb() end
end)
UI.Slider(p,"重生检查间隔(秒)",1,15,0.5,function() return SYS.C_.RebirthCheck end,function(v) SYS.C_.RebirthCheck=v end,"%.1f")
UI.Div(p)
UI.Label(p,"训练加成")
UI.Switch(p,"自动领取训练加成","AutoBonus")
UI.Div(p)
UI.Label(p,"健身房事件")
UI.Switch(p,"优先参加健身事件","AutoGym",function(on)
if on then SYS.StartGym() else SYS.StopGym() end
end)
UI.Div(p)
UI.Label(p,"基地操作",CY.cyan)
UI.Btn(p,"💰 一键收取基地金币",CY.green,function() SYS.collectAllCash(30) end)
UI.Btn(p,"📥 一键收起全部脑红 (1-30)",CY.cyan,function() SYS.withdrawAllBrainrots(30) end)
UI.Div(p)
UI.Label(p,"自动售卖（低于 CPS 门槛才卖）",CY.yellow)
UI.Switch(p,"自动售卖 (每5秒)","AutoSell")
UI.Switch(p,"启用 CPS 门槛","SellThresholdEnabled")
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,42) row.BackgroundColor3=CY.card
row.BackgroundTransparency=0.3 row.BorderSizePixel=0 row.Parent=p
UI.Round(row,10) UI.Stroke(row,CY.line,1,0.85)
local lb=Instance.new("TextLabel")
lb.Size=UDim2.new(1,-130,1,0) lb.Position=UDim2.new(0,12,0,0)
lb.BackgroundTransparency=1 lb.Text="最低 CPS 门槛"
lb.TextColor3=CY.text lb.Font=Enum.Font.GothamMedium
lb.TextSize=13 lb.TextXAlignment=Enum.TextXAlignment.Left lb.Parent=row
local box=Instance.new("TextBox")
box.Size=UDim2.new(0,110,0,28) box.Position=UDim2.new(1,-122,0.5,-14)
box.BackgroundColor3=CY.panel box.BackgroundTransparency=0.2
box.Text=tostring((SYS.AFK_Sell and SYS.AFK_Sell.MinCPS) or 100000)
box.TextColor3=CY.cyan box.Font=Enum.Font.Code
box.TextSize=13 box.BorderSizePixel=0 box.ClearTextOnFocus=false box.Parent=row
UI.Round(box,6) UI.Stroke(box,CY.cyan,1,0.7)
box.FocusLost:Connect(function()
local v=tonumber(box.Text)
if v and v>=0 then
if SYS.AFK_Sell then SYS.AFK_Sell.MinCPS=v end
if SYS.SyncMinCPS then SYS.SyncMinCPS() end
box.Text=tostring(math.floor(v))
print("[Sell] CPS 门槛设为: "..box.Text.." (已保存)")
else
box.Text=tostring((SYS.AFK_Sell and SYS.AFK_Sell.MinCPS) or 100000)
end
end)
UI.Btn(p,"💸 一键卖出低 CPS 脑红",CY.yellow,function()
if SYS.sellLowCPSTools then SYS.sellLowCPSTools(true) end
end)
UI.Div(p)
UI.Label(p,"📊 CPS 统计",CY.purple)
local scanResL=UI.Label(p,"输入 CPS 后点击扫描",CY.sub)
UI.Btn(p,"🔍 扫描低于当前门槛的脑红数量",CY.purple,function()
task.spawn(function()
if scanResL and scanResL.Parent then
scanResL.Text="扫描中..." scanResL.TextColor3=CY.yellow
end
local picks,th=0,0
pcall(function()
picks,th=SYS.scanLowCPSCount()
end)
if scanResL and scanResL.Parent then
if type(picks)=="table" then
local cnt=#picks
local names={}
for i=1,math.min(cnt,8) do
table.insert(names,("%s(%.0f)"):format(picks[i].Name,picks[i].CPS))
end
local preview=table.concat(names,", ")
if cnt>8 then preview=preview..(" ... +%d"):format(cnt-8) end
if cnt==0 then
scanResL.Text=("门槛 %.0f: 无低 CPS 脑红"):format(th)
scanResL.TextColor3=CY.green
else
scanResL.Text=("门槛 %.0f: 共 %d 个  |  %s"):format(th,cnt,preview)
scanResL.TextColor3=CY.cyan
end
print(("[Scan] 门槛 %.0f · 共 %d 个"):format(th,cnt))
else
scanResL.Text="扫描失败"
scanResL.TextColor3=CY.red
end
end
end)
end)
end
UI.Pages["翻译"]=function(p)
UI.Section(p,"💬 翻译开关",CY.accent)
local backOpts={"🖥️ 本地 llama.cpp","☁️ 硅基流动 (云端)"}
UI.Dropdown(p,"🔀 翻译后端",backOpts,
function() return SYS.T_.TransSili and backOpts[2] or backOpts[1] end,
function(v)
SYS.T_.TransSili=(v==backOpts[2])
pcall(function() Trans.clearAllFails() end)
pcall(function() Trans.probeServer() end)
if Trans.reqOn(false) or Trans.reqOn(true) then P(function() Trans.forceRescan() end) end
SYS.Notify(SYS.T_.TransSili and "☁️ 已切到硅基流动(云端)翻译" or "🖥️ 已切回本地翻译",SYS.CY.cyan)
end)
UI.Switch(p,"💬 聊天翻译","TransChat",function(on)
if on then Trans.startChatListener() else Trans.stopChatListener() end
end)
UI.Switch(p,"🖼️ 界面翻译","TransUI",function(on)
if on then Trans.startUIScan() else Trans.stopUIScan() end
end)
UI.Switch(p,"🔤 中英对照 (显示成「译文 (原文)」)","TransBilingual",function(on)
if Trans.reqOn(false) or Trans.reqOn(true) then P(function() Trans.forceRescan() end) end
SYS.Notify(on and "🔤 中英对照已开: 译文 (原文)" or "🔤 已关: 只显示译文",SYS.CY.cyan)
end)
UI.Switch(p,"⏱️ 跳过动态文本 (CPS/倒计时/金币这类每帧在变的, 不再反复发请求与写缓存)","TransDyn")
UI.Btn(p,"🧹 查看已跳过的动态文本 (控制台)",CY.sub,function() pcall(Trans.dumpDyn) end)
UI.Btn(p,"🧾 查看失败/退避清单 (控制台)",CY.sub,function() pcall(Trans.dumpFails) end)
UI.Btn(p,"🔍 立即强制全屏扫描翻译",CY.cyan,function()
task.spawn(function()
print("[Trans] 手动触发全屏扫描...")
if Trans.forceRescan then pcall(Trans.forceRescan) end
print("[Trans] ✅ 手动全屏扫描完成")
end)
end)
UI.Div(p)
UI.Section(p,"📤 发送消息",CY.yellow)
local langOpts={}
for _,l in ipairs(Trans.LANGS or {}) do table.insert(langOpts,l.name) end
if #langOpts>0 then
UI.Dropdown(p,"🌐 发送语言",langOpts,
function() return Trans.langName(Trans.SendLang or "en") end,
function(v)
for _,l in ipairs(Trans.LANGS) do
if l.name==v then Trans.SendLang=l.code break end
end
end)
end
local inBox=Instance.new("TextBox")
inBox.Size=UDim2.new(1,0,0,60) inBox.BackgroundColor3=CY.card
inBox.BackgroundTransparency=0.3 inBox.TextColor3=CY.text
inBox.PlaceholderText="请输入文本" inBox.PlaceholderColor3=CY.sub
inBox.Font=Enum.Font.Gotham inBox.TextSize=13
inBox.TextXAlignment=Enum.TextXAlignment.Left
inBox.TextYAlignment=Enum.TextYAlignment.Top
inBox.TextWrapped=true inBox.MultiLine=true inBox.ClearTextOnFocus=false
inBox.BorderSizePixel=0 inBox.Parent=p
UI.Round(inBox,10) UI.Stroke(inBox,CY.line,1,0.85)
UI.Btn(p,"📤 发送",CY.green,function()
local t=inBox.Text
if not t or t:gsub("%s","")=="" then return end
task.spawn(function()
local ok=Trans.smartSend(t)
if ok then inBox.Text="" end
end)
end)
UI.Div(p)
UI.Section(p,"💾 缓存 · "..tostring(Trans.CACHE_FILE or SYS.N.Cache),CY.cyan)
local statL=UI.Label(p,("已缓存 %d 条"):format(Trans.cacheCount or 0),CY.green)
local statConcurrent = UI.Label(p, "命中 0 | 本地 0 | 失败 0 | 跳过扫 0 | 均 0ms", CY.cyan)
task.spawn(function()
while not SYS.Unloaded do
task.wait(0.5)
if statL and statL.Parent then statL.Text=("已缓存 %d 条"):format(Trans.cacheCount or 0) end
if statConcurrent and statConcurrent.Parent then
local st=Trans.Stats or {}
local avg=(st.latN and st.latN>0) and (st.lat/st.latN) or 0
statConcurrent.Text = ("命中 %d | 本地 %d | 失败 %d | 跳过扫 %d | 均 %.0fms | 动态 %d | 排队 %d"):format(
st.hit or 0, st.loc or 0, st.fail or 0, st.sweepSkip or 0, avg, st.dyn or 0, Trans.WaitN or 0
)
end
end
end)
UI.Btn(p,"💾 立即保存缓存",CY.cyan,function() Trans.saveCache() end)
UI.Btn(p,"🗑️ 清空缓存",CY.red,function()
Trans.clearCache()
if statL then statL.Text="已缓存 0 条" end
end)
UI.Switch(p,"📖 本地短语表 (train→训练 这类常见词离线直译)","LocalPhrase")
UI.Tip(p,"「清空缓存」只清已缓存的译文 + 删除缓存文件, 不动这个内置短语表。\n关掉这个开关 = 完全依赖翻译模型, 模型没开就一个都不翻。",CY.sub)
UI.Div(p)
UI.Section(p,"🔌 模型状态",CY.cyan)
local stL=UI.Label(p,"模型: ⚪ 检测中...",CY.sub)
local function refresh()
if not stL or not stL.Parent then return end
task.spawn(function()
local name=SYS.T_.TransSili and "☁️ 硅基流动(云端)" or "🖥️ 本地模型"
stL.Text=name..": ⚪ 检测中..." stL.TextColor3=CY.sub
local s="unknown"
pcall(function() s=Trans.checkLocal() end)
if s=="online" then stL.Text=name..": 🟢 在线" stL.TextColor3=CY.green
else stL.Text=name..": 🔴 离线" stL.TextColor3=CY.red end
end)
end
Trans.refreshLocalStatus=refresh
task.spawn(function() task.wait(0.6) refresh() end)
UI.Btn(p,"🔄 立即检测模型",CY.cyan,refresh)
UI.Btn(p,"⚙️ 重新探测服务器槽位与上下文",CY.purple,function()
task.spawn(function()
if Trans.probeServer then
local pok=Trans.probeServer()
print(pok and "[Trans] ✅ 探测成功" or "[Trans] ❌ 探测失败(服务器没开?)")
refresh()
end
end)
end)
UI.Div(p)
UI.Btn(p,"↩️ 恢复聊天翻译原文",CY.purple,function()
local r=Trans.restoreSource("chat")
P(function()
SYS.Notify(("↩️ 已恢复聊天原文 %d 条; 之后引擎重绘也会保持原文"):format(r or 0),CY.purple)
end)
end)
UI.Btn(p,"↩️ 恢复界面翻译原文",CY.purple,function() Trans.restoreSource("ui") end)
UI.Div(p)
end
do
local LAB={Hooks={}, Log={}, MaxLog=200}
SYS.Lab=LAB
local function has(n) return type(_G[n])=="function" end
LAB.Caps=function()
return {
getgc   = has("getgc") or has("getGC"),
hookfn  = has("hookfunction") or has("hookfunc") or has("replaceclosure") or has("replacefunc"),
restore = has("restorefunction") or has("restorefunc") or has("restoreclosure"),
scripts = has("getscripts") or has("getrunningscripts"),
modules = has("getloadedmodules"),
}
end
local function gcApi() if type(getgc)=="function" then return getgc end if type(_G.getGC)=="function" then return getGC end return nil end
local function hookApi()
if type(hookfunction)=="function" then return hookfunction end
if type(_G.hookfunc)=="function" then return hookfunc end
if type(_G.replaceclosure)=="function" then return replaceclosure end
if type(_G.replacefunc)=="function" then return replacefunc end
return nil
end
local function restoreApi()
if type(restorefunction)=="function" then return restorefunction end
if type(_G.restorefunc)=="function" then return restorefunc end
if type(_G.restoreclosure)=="function" then return restoreclosure end
return nil
end
local function ownerOf(f)
local ok,s=P(function()
if type(getfenv)=="function" then
local e=select(2,pcall(getfenv,f))
return e and e.script or nil
end
return nil
end)
return ok and s or nil
end
local function nameOf(f)
local ok,n=P(function()
if type(getinfo)=="function" then return getinfo(f).name end
if type(debug)=="table" and type(debug.getinfo)=="function" then return debug.getinfo(f).name end
return nil
end)
return ok and n or nil
end
function LAB.ScanGC()
local g=gcApi()
if not g then SYS.Notify("这台执行器没有 getgc",SYS.CY.yellow) return nil end
local fns,tbls,byScript={},{},{}
local ok,err=P(function()
for _,v in pairs(g(true)) do
if type(v)=="function" then
fns[#fns+1]=v
local own=ownerOf(v)
if own then
local k=own.Name or tostring(own)
byScript[k]=byScript[k] or {n=0}
byScript[k].n=byScript[k].n+1
end
elseif type(v)=="table" then tbls[#tbls+1]=v end
end
end)
if not ok then SYS.Notify("getgc 遍历失败: "..tostring(err):sub(1,60),SYS.CY.red) return nil end
local rows={}
for k,v in pairs(byScript) do rows[#rows+1]=("  %-42s %d 个函数"):format(k:sub(1,42),v.n) end
table.sort(rows)
local out={("========== GC 扫描 =========="),
("函数 %d 个 | 表 %d 个"):format(#fns,#tbls),
"按归属脚本分组(前 25):"}
for i=1,math.min(#rows,25) do out[#out+1]=rows[i] end
out[#out+1]="(归属拿不到 = C/引擎侧或匿名函数, hook 不了)"
LAB.LastFns=fns
print(table.concat(out,"\n"))
SYS.Notify(("GC 扫描完成: %d 函数 / %d 表"):format(#fns,#tbls),SYS.CY.green)
return {fns=#fns,tbls=#tbls}
end
local KEY={"damage","hit","hurt","fire","shoot","aim","kill","die","death","health","attack","weapon","bullet"}
function LAB.ListHookable()
local fns=LAB.LastFns
if not fns then SYS.Notify("先点① GC 扫描",SYS.CY.yellow) return end
local hits={}
for i=1,#fns do
local f=fns[i] local nm=nameOf(f)
if type(nm)=="string" and #nm>1 and #nm<40 then
local low=nm:lower()
for _,k in ipairs(KEY) do
if low:find(k,1,true) then
local own=ownerOf(f)
hits[#hits+1]=("  %-30s  脚本=%s"):format(nm:sub(1,30),own and (own.Name or "?") or "-")
break
end
end
end
end
table.sort(hits)
local out={("========== 名字可疑的函数(可能可 hook) =========="),
("命中 %d 个 (关键词: damage/hit/fire/aim/kill/health ...)"):format(#hits)}
for i=1,math.min(#hits,40) do out[#out+1]=hits[i] end
out[#out+1]="这些只是【候选】—— 想观察哪个, 用 ④ 按名字包一层(只记录, 不改返回值)"
print(table.concat(out,"\n"))
SYS.Notify(("找到 %d 个候选函数"):format(#hits),SYS.CY.green)
end
function LAB.ListScripts()
local out={"========== 已加载脚本 / 模块 =========="}
local n=0
P(function()
if type(getscripts)=="function" then
for _,s in ipairs(getscripts()) do
n=n+1
if n<=40 then
local ok,nm=pcall(function() return s:GetFullName() end)
out[#out+1]=("  S %-68s"):format(tostring(ok and nm or s):sub(1,68))
end
end
out[#out+1]=("脚本共 %d 个(只列前 40)"):format(n)
else
out[#out+1]="  这台执行器没有 getscripts"
end
if type(getloadedmodules)=="function" then
local m=0
for _,s in ipairs(getloadedmodules()) do
m=m+1
if m<=20 then
local ok,nm=pcall(function() return s:GetFullName() end)
out[#out+1]=("  M %-68s"):format(tostring(ok and nm or s):sub(1,68))
end
end
out[#out+1]=("已加载模块 %d 个(只列前 20)"):format(m)
end
end)
print(table.concat(out,"\n"))
SYS.Notify("脚本清单已输出到控制台",SYS.CY.green)
end
function LAB.Watch(name,limit)
if type(name)~="string" or name=="" then SYS.Notify("先填函数名",SYS.CY.yellow) return false end
local hf=hookApi()
if not hf then SYS.Notify("这台执行器没有 hookfunction",SYS.CY.yellow) return false end
local fns=LAB.LastFns
if not fns then SYS.Notify("先点① GC 扫描",SYS.CY.yellow) return false end
local target
for i=1,#fns do if nameOf(fns[i])==name then target=fns[i] break end end
if not target then SYS.Notify("没找到函数: "..name,SYS.CY.yellow) return false end
if LAB.Hooks[name] then SYS.Notify("已经在观察 "..name,SYS.CY.yellow) return true end
limit=tonumber(limit) or 50
local cnt=0
local ok,old=P(function()
return hf(target,function(...)
cnt=cnt+1
if cnt<=limit then
local a=table.pack(...)
local parts={}
for i=1,math.min(a.n,4) do
local v=a[i]
parts[#parts+1]=(type(v)=="Instance") and ("Instance:"..tostring(v.Name)) or tostring(v)
end
LAB.Log[#LAB.Log+1]=("  [%s] #%d (%d 参) %s"):format(name,cnt,a.n,table.concat(parts,", "):sub(1,90))
if #LAB.Log>LAB.MaxLog then table.remove(LAB.Log,1) end
end
return target(...)
end)
end)
if not ok then SYS.Notify("hook 失败(局部/匿名函数 hook 不了): "..tostring(old):sub(1,50),SYS.CY.red) return false end
LAB.Hooks[name]=old
SYS.Notify("正在观察 "..name.." (最多记录 "..limit.." 次)",SYS.CY.green)
return true
end
function LAB.Unwatch(name)
local old=LAB.Hooks[name]
if not old then return false end
local rf=restoreApi()
local hf=hookApi()
local ok=P(function()
if rf then rf(old)
elseif hf then hf(old,old) end
end)
LAB.Hooks[name]=nil
SYS.Notify("已停止观察 "..name,ok and SYS.CY.green or SYS.CY.red)
return ok
end
function LAB.UnwatchAll()
local ks={} for k in pairs(LAB.Hooks) do ks[#ks+1]=k end
for _,k in ipairs(ks) do LAB.Unwatch(k) end
return #ks
end
function LAB.DumpLog()
local out={"========== 调用记录 (最近 "..#LAB.Log.." 条) =========="}
for i=math.max(1,#LAB.Log-60),#LAB.Log do out[#out+1]=LAB.Log[i] end
if #LAB.Log==0 then out[#out+1]="  (还没有记录 —— 先在 ④ 里填函数名开始观察)" end
print(table.concat(out,"\n"))
SYS.Notify("调用记录已输出",SYS.CY.green)
end
local function line(s) print("  "..s) end
local function head(s) print(""); print("════════ "..s.." ════════") end
local SCAN_CAP=80000
local NET_CLS={
"RemoteEvent","UnreliableRemoteEvent","RemoteFunction",
}
local DEX_KEY={
"RemoteEvent","UnreliableRemoteEvent","RemoteFunction",
"BindableEvent","BindableFunction",
"Script","LocalScript","ModuleScript",
"ProximityPrompt","ClickDetector","Highlight","SurfaceGui",
}
local DEX_PROPS={
ProximityPrompt={"ActionText","ObjectText","HoldDuration","MaxActivationDistance","Enabled","RequiresLineOfSight"},
ClickDetector={"MaxActivationDistance"},
Highlight={"Enabled","FillColor","OutlineColor","FillTransparency","OutlineTransparency","DepthMode"},
SurfaceGui={"Enabled","Face","LightInfluence","AlwaysOnTop","MaxDistance"},
Script={"Enabled","RunContext"},
LocalScript={"Enabled"},
}
local function scanWholeGame()
local out={game}
local i,n,capped=1,0,false
local ok=P(function()
while i<=#out do
local inst=out[i] i=i+1
local ch=inst:GetChildren()
for k=1,#ch do
out[#out+1]=ch[k]
n=n+1
if n>=SCAN_CAP then capped=true return end
end
end
end)
return out,n,capped,ok
end
local function snapProps(inst, names)
local got={}
for _,p in ipairs(names) do
local ok,v=P(function() return inst[p] end)
if ok and v~=nil then
local vs=tostring(v)
if #vs>48 then vs=vs:sub(1,48).."…" end
got[#got+1]=("        %s = %s"):format(p,vs)
end
end
return got
end
local function kindIndex()
local idx={}
local A=SYS.RemoteAlias
if type(A)=="table" then
for kind,list in pairs(A) do
idx[kind]=kind
if type(list)=="table" then
for _,nm in ipairs(list) do idx[nm]=kind end
end
end
end
return idx
end
function LAB.DexScan(shared, sharedN, sharedCapped)
head("I · DEX 层(全图实例浏览器: 游戏里都有哪些东西 / 在哪)")
local list,n,capped,ok
if shared then list,n,capped,ok=shared,sharedN or 0,sharedCapped or false,true
else list,n,capped,ok=scanWholeGame() end
if not ok then line("!! 全图遍历中断(某实例 GetChildren 抛错) —— 下面是已扫到的部分") end
local hist={}
for i=1,#list do
local cls=list[i].ClassName
hist[cls]=(hist[cls] or 0)+1
end
local rows={}
for cls,cnt in pairs(hist) do rows[#rows+1]={cls,cnt} end
table.sort(rows,function(a,b)
if a[2]~=b[2] then return a[2]>b[2] end
return a[1]<b[1]
end)
line(("全图实例 %d 个(遍历上限 %d%s) · 共 %d 种 ClassName")
:format(n,SCAN_CAP,capped and " · 已达上限" or "",#rows))
line("  ── 类名 TOP 30 ──")
for i=1,math.min(#rows,30) do
line(("    %-9d %s"):format(rows[i][2],rows[i][1]))
end
local want={}
for _,k in ipairs(DEX_KEY) do want[k]={} end
for i=1,#list do
local w=want[list[i].ClassName]
if w and #w<40 then w[#w+1]=list[i] end
end
local dump={"========== 类名 TOP 30 =========="}
for i=1,math.min(#rows,30) do dump[#dump+1]=("%-9d %s"):format(rows[i][2],rows[i][1]) end
dump[#dump+1]=""
dump[#dump+1]="========== 关键类全路径 =========="
line("  ── 关键类清单(路径可直接复制进执行器) ──")
for _,k in ipairs(DEX_KEY) do
local hits=want[k]
if #hits>0 then
local total=hist[k] or #hits
line(("    ▼ %s   × %d"):format(k,total))
for i=1,math.min(#hits,12) do
local okp,path=P(function() return hits[i]:GetFullName() end)
local p=tostring(okp and path or "?")
line(("        %s"):format(p))
dump[#dump+1]=("%s  %s"):format(k,p)
end
if total>12 then
line(("        … 还有 %d 个(完整清单见落盘文件)"):format(total-12))
end
end
end
line("  ── 属性快照(每类取第一个实例) ──")
local anySnap=false
for _,k in ipairs(DEX_KEY) do
local inst=want[k][1]
local names=DEX_PROPS[k]
if inst and names and #names>0 then
local got=snapProps(inst,names)
if #got>0 then
anySnap=true
local okp,nm=P(function() return inst:GetFullName() end)
line(("    [%s] %s"):format(k,tostring(okp and nm or "?")))
for i=1,#got do line(got[i]) end
dump[#dump+1]=""
dump[#dump+1]=("[属性快照] "..k.."  "..tostring(okp and nm or "?"))
for i=1,#got do dump[#dump+1]=got[i] end
end
end
end
if not anySnap then
line("    (本图没有可快照的关键类实例, 或该执行器读不到这些属性)")
end
local fn=SYS.SaveDump("DEX",dump)
if fn then line("  ✅ 完整清单已落盘: "..fn)
elseif type(writefile)=="function" then line("  (落盘失败)")
else line("  (这台执行器不能写文件, 只能看控制台)") end
SYS.Notify(("DEX 层完成: %d 个实例 / %d 种类名"):format(n,#rows),SYS.CY.green)
LAB.LastDex={inst=n,classes=#rows}
return n,#rows,fn
end
function LAB.RemoteScan(shared, sharedN, sharedCapped)
head("J · Remote 层(每条 remote 能不能用 · 谁在收)")
local list,n,capped,ok
if shared then list,n,capped,ok=shared,sharedN or 0,sharedCapped or false,true
else list,n,capped,ok=scanWholeGame() end
if not ok then line("!! 全图遍历中断 —— 下面是已扫到的部分") end
local net,byCls={},{}
for i=1,#list do
local c=list[i]
local cls=c.ClassName
local isNet=false
for j=1,#NET_CLS do if cls==NET_CLS[j] then isNet=true break end end
if isNet then
net[#net+1]=c
byCls[cls]=(byCls[cls] or 0)+1
elseif cls=="BindableEvent" or cls=="BindableFunction" then
byCls[cls]=(byCls[cls] or 0)+1
end
end
line(("网络通道 RemoteEvent %d · UnreliableRemoteEvent %d · RemoteFunction %d   |   本地 BindableEvent %d · BindableFunction %d")
:format(byCls.RemoteEvent or 0,byCls.UnreliableRemoteEvent or 0,byCls.RemoteFunction or 0,
byCls.BindableEvent or 0,byCls.BindableFunction or 0))
local gi=_G.getconnections
local hasGc=(type(gi)=="function")
if not hasGc then
line("  (这台执行器没有 getconnections —— 跳过「谁在收」, 只列清单与归类)")
end
local nameKind=kindIndex()
local dump={("========== Remote 逐条侦察(共 %d 条, 列前 60) =========="):format(#net)}
local withRecv=0
local MAXROW=60
for i=1,math.min(#net,MAXROW) do
local r=net[i]
local cls=r.ClassName
local okp,path=P(function() return r:GetFullName() end)
local p=tostring(okp and path or "?")
local tail=(type(r.Name)=="string") and r.Name or "?"
local tag=nameKind[tail] and ("  ★命中类别: "..tostring(nameKind[tail])) or ""
local recv="?"
if cls=="RemoteFunction" then
local ok1,set1=P(function() return r.OnClientInvoke~=nil end)
recv=(ok1 and set1) and "OnClientInvoke 已设置(服务端可反向调用)" or "OnClientInvoke 未设置"
elseif hasGc then
local okE,ev=P(function() return r.OnClientEvent end)
local cnt=0
if okE and ev~=nil then
local okC,conns=P(function() return gi(ev) end)
if okC and type(conns)=="table" then
cnt=#conns
local who={}
for k=1,math.min(#conns,3) do
local f=nil
local okF,v=P(function() return conns[k].Function end)
if okF then f=v end
if f then
local ow=ownerOf(f)
who[#who+1]=tostring(nameOf(f) or "?").."@"..tostring(ow and (ow.Name or "?") or "-")
end
end
if #who>0 then recv=("%d(谁在收: %s)"):format(cnt,table.concat(who,", "))
else recv=tostring(cnt) end
else
recv="0"
end
else
recv="读不到 OnClientEvent"
end
else
recv="(无 getconnections)"
end
if type(recv)=="string" and recv~="0" and recv~="?" and recv:find("^%d") then withRecv=withRecv+1 end
line(("    [%d] %-22s %s"):format(i,cls,p))
line(("          收向监听: %s%s"):format(tostring(recv),tag))
dump[#dump+1]=("[%d] %s  %s"):format(i,cls,p)
dump[#dump+1]=("     收向监听: "..tostring(recv)..tag)
end
if #net>MAXROW then line(("    … 还有 %d 条(完整清单见落盘文件)"):format(#net-MAXROW)) end
local okA,kinds=P(function()
local t={}
for k in pairs(SYS.RemoteAlias or {}) do t[#t+1]=k end
table.sort(t) return t
end)
if okA and kinds then
local byName={}
for i=1,#net do byName[net[i].Name]=net[i] end
local have={} local missN=0
for _,kind in ipairs(kinds) do
local found=nil
for _,nm in ipairs((SYS.RemoteAlias and SYS.RemoteAlias[kind]) or {}) do
if byName[nm] then found=nm break end
end
if found then have[#have+1]=("    ✅ %-12s → %s"):format(kind,found)
else missN=missN+1 end
end
line(("  ── 功能类别通道对账: 有 %d / 共 %d(其余 %d 个本游戏没有同名通道) ──")
:format(#have,#kinds,missN))
for i=1,#have do line(have[i]) end
dump[#dump+1]=""
dump[#dump+1]=("========== 功能类别对账: 有 %d / 共 %d =========="):format(#have,#kinds)
for i=1,#have do dump[#dump+1]=have[i] end
end
local fn=SYS.SaveDump("Remote",dump)
if fn then line("  ✅ 完整清单已落盘: "..fn)
elseif type(writefile)=="function" then line("  (落盘失败)")
else line("  (这台执行器不能写文件, 只能看控制台)") end
SYS.Notify(("Remote 层完成: 网络通道 %d 条, 其中有收向监听 %d 条"):format(#net,withRecv),SYS.CY.green)
LAB.LastRemote={net=#net,recv=withRecv}
return #net,withRecv,fn
end
function LAB.FullScan()
local t0=os.clock()
print(""); print("##################  🔍 综合扫描  ##################")
print(("时间 %s"):format(os.date("%H:%M:%S")))
print("")
head("A · 通信层(游戏接口: 能触发什么)")
local remotes
P(function() remotes=SYS.DumpRemotes() end)
if type(remotes)=="table" then
local GROUPS={
{"⚔ 战斗/伤害",{"Combat","Damage","Hit","Killed","Death","Die","Weapon","Ammo","Reload","Equip"}},
{"💰 经济/商城",{"Shop","Buy","Purchase","Product","Gamepass","Gacha","Spin","Reward","Claim","Coin","Cash","Sell"}},
{"📦 物品/背包",{"Inventory","Item","Stack","Backpack","Loot","Pickup","Collect","Drop"}},
{"👥 社交/交易",{"Trade","Friend","Postie","Social","Vote"}},
{"🏃 角色/移动",{"Character","Teleport","Respawn","Spawn","Jump","Move","AFK","Suicide"}},
}
local gen=0
for _,g in ipairs(GROUPS) do
local hits={}
for _,r in ipairs(remotes) do
for _,k in ipairs(g[2]) do
if r:find(k,1,true) then hits[#hits+1]=r break end
end
end
if #hits>0 then
print(("  ── %s (%d) ──"):format(g[1],#hits))
for x=1,math.min(#hits,14) do line(hits[x]) end
if #hits>14 then line(("... 还有 %d 个"):format(#hits-14)) end
gen=gen+#hits
end
end
line(("→ 命中可做功能的关键词 %d 个 / Remote 总数 %d(完整清单见上)"):format(gen,#remotes))
else line("!! Remote 扫描失败") end
head("B · 代码层(游戏函数: 怎么实现的)")
LAB.ScanGC()
LAB.ListHookable()
head("C · 脚本层(跑了哪些脚本)")
LAB.ListScripts()
P(function()
if type(getrunningscripts)=="function" then
local list=getrunningscripts()
line(("getrunningscripts: %d 个【正在运行】的脚本(比 getscripts 更准, 含动态加载的)"):format(#list))
local shown=0
for _,s in ipairs(list) do
if shown<14 then
local ok2,nm=P(function() return s:GetFullName() end)
line(("  · "..tostring(ok2 and nm or s))); shown=shown+1
end
end
else line("(这台执行器没有 getrunningscripts)") end
end)
head("D · 实例层(游戏藏在哪)")
local okD=P(function()
local gi=_G.getnilinstances
if type(gi)=="function" then
local list=gi()
line(("getnilinstances: %d 个(父级为 nil 的实例 —— 游戏刻意藏起来的对象常在这)"):format(#list))
local shown=0
for _,v in ipairs(list) do
if shown<18 then
local cls="?"
pcall(function() cls=v.ClassName end)
local nm="?"
pcall(function() nm=v.Name end)
line(("  · %-22s %s"):format(tostring(cls),tostring(nm)))
shown=shown+1
end
end
else line("(这台执行器没有 getnilinstances)") end
end)
if not okD then line("!! 实例层扫描异常") end
P(function()
local ws=game:GetService("Workspace")
local n=0
for _,v in ipairs(ws:GetDescendants()) do n=n+1 if n>20000 then break end end
line(("Workspace 子对象: %d+ 个"):format(n))
local chars,hl,pp,cd,trig=0,0,0,0,0
for _,v in ipairs(ws:GetDescendants()) do
local c=v.ClassName
if c=="Model" and v:FindFirstChildOfClass("Humanoid") then chars=chars+1
elseif c=="Highlight" then hl=hl+1
elseif c=="ProximityPrompt" then pp=pp+1
elseif c=="ClickDetector" then cd=cd+1
elseif c=="Part" and v:FindFirstChildOfClass("TouchTransmitter") then trig=trig+1 end
end
line(("角色模型 %d · Highlight %d · ProximityPrompt %d · ClickDetector %d (可交互 %d)")
:format(chars,hl,pp,cd,pp+cd))
end)
head("E · 数据层(游戏把数据放哪)")
local okE=P(function()
local function dumpAttr(obj,tag)
local ok2,attrs=P(function()
local t2={}
for k,v in pairs(obj:GetAttributes()) do t2[#t2+1]=("    %-18s = %s"):format(k,tostring(v)) end
return t2
end)
if ok2 and type(attrs)=="table" and #attrs>0 then
line(("%s (%s) 有 %d 个 Attribute:"):format(obj.Name,obj.ClassName,#attrs))
table.sort(attrs)
for x=1,math.min(#attrs,22) do line(attrs[x]) end
end
end
if SYS.LP then dumpAttr(SYS.LP,"自己") end
local n=0
for _,pl in ipairs(Players:GetPlayers()) do
if pl~=SYS.LP and n<2 then n=n+1 dumpAttr(pl,"他人") end
end
local ch=SYS.LP and SYS.LP.Character
if ch then dumpAttr(ch,"自己角色") end
if SYS.LP then
local ls=SYS.LP:FindFirstChild("leaderstats") or SYS.LP:FindFirstChild("Leaderstats")
if ls then
line("leaderstats 字段:")
for _,v in ipairs(ls:GetChildren()) do
line(("    %-18s = %s"):format(v.Name,tostring(v.Value)))
end
else line("(没有 leaderstats)") end
end
end)
if not okE then line("!! 数据层扫描异常") end
head("F · 连接层(游戏自己挂了哪些监听)")
P(function()
local gc2=_G.getconnections
if type(gc2)~="function" then line("(这台执行器没有 getconnections)"); return end
line("getconnections 可用 —— 可用于查看/挂起游戏自己的事件连接")
local targets={
{"Players.LocalPlayer.Idled", SYS.LP and SYS.LP.Idled},
{"RunService.Heartbeat", game:GetService("RunService").Heartbeat},
{"RunService.RenderStepped", game:GetService("RunService").RenderStepped},
}
for _,x in ipairs(targets) do
if x[2] then
local ok3,cnt=P(function() return #gc2(x[2]) end)
line(("  %-28s %s 个连接"):format(x[1], ok3 and tostring(cnt) or "?"))
end
end
end)
head("G · 环境层(脚本跑在什么环境里)")
P(function()
if type(getgenv)=="function" then
local n=0 for _ in pairs(getgenv()) do n=n+1 end
line(("getgenv()  执行器全局: %d 个键"):format(n))
end
if type(getrenv)=="function" then
local n=0 for _ in pairs(getrenv()) do n=n+1 end
line(("getrenv()  游戏全局:   %d 个键"):format(n))
end
if type(getreg)=="function" then
local n=0 pcall(function() for _ in pairs(getreg()) do n=n+1 end end)
line(("getreg()   Lua registry: %d 个键"):format(n))
end
do
local vds="?"
pcall(function()
if UIS.ViewportDisplaySize~=nil then
vds=(tostring(UIS.ViewportDisplaySize):gsub("Enum.ViewportDisplaySize.",""))
end
end)
line(("设备: 触屏=%s 键盘=%s 鼠标=%s 视口档=%s")
:format(tostring(UIS.TouchEnabled),tostring(UIS.KeyboardEnabled),
tostring(UIS.MouseEnabled),vds))
end
if type(getthreadidentity)=="function" then
local ok2,v=P(function() return getthreadidentity() end)
line(("线程身份(identity): %s   (7=执行器, 2=普通脚本)"):format(ok2 and tostring(v) or "?"))
end
end)
head("H · 反查层(这段代码是被谁调起来的)")
P(function()
if type(getcallingscript)=="function" then
local ok2,s=P(function() return getcallingscript() end)
line(("getcallingscript(): %s"):format(ok2 and tostring(s and s:GetFullName() or s) or "?"))
else line("(这台执行器没有 getcallingscript)") end
local fns=LAB.LastFns
if fns and #fns>0 then
local f=fns[1]
local ok2=pcall(function()
if type(debug)=="table" and type(debug.getupvalue)=="function" then
local i=1
local cnt=0
while true do
local nm,val=debug.getupvalue(f,i)
if nm==nil then break end
cnt=cnt+1
if cnt<=12 then
local vs=tostring(val)
if #vs>60 then vs=vs:sub(1,60).."…" end
line(("    upvalue[%d] %-20s = %s"):format(i,tostring(nm),vs))
end
i=i+1
end
line(("(该函数共 %d 个 upvalue)"):format(cnt))
end
end)
if not ok2 then line("(读 upvalue 失败)") end
end
end)
local shared,sharedN,sharedCapped=scanWholeGame()
P(function() LAB.DexScan(shared,sharedN,sharedCapped) end)
P(function() LAB.RemoteScan(shared,sharedN,sharedCapped) end)
print(""); print(("##################  扫描完毕 (%.2fs)  ##################"):format(os.clock()-t0))
SYS.Notify("综合扫描完成 —— 结果在控制台(F9)",SYS.CY.green)
end
function LAB.Summary()
local out={"=== CheatMenu 扫描摘要 ===", "时间: "..os.date("%Y-%m-%d %H:%M:%S")}
local c=LAB.Caps()
out[#out+1]=("执行器: getgc=%s hook=%s restore=%s getscripts=%s")
:format(tostring(c.getgc),tostring(c.hookfn),tostring(c.restore),tostring(c.scripts))
if LAB.LastFns then out[#out+1]=("GC 函数数: %d"):format(#LAB.LastFns) end
if LAB.LastDex then out[#out+1]=("DEX: 全图 %d 个实例 / %d 种类名"):format(LAB.LastDex.inst,LAB.LastDex.classes) end
if LAB.LastRemote then out[#out+1]=("Remote: 网络通道 %d 条(其中有收向监听 %d)"):format(LAB.LastRemote.net,LAB.LastRemote.recv) end
if #LAB.Log>0 then out[#out+1]=("调用记录 %d 条, 最近: %s"):format(#LAB.Log,LAB.Log[#LAB.Log]) end
local txt=table.concat(out,"\n")
local ok=P(function()
if type(setclipboard)=="function" then setclipboard(txt)
elseif type(toclipboard)=="function" then toclipboard(txt) end
end)
if ok then SYS.Notify("摘要已复制到剪贴板",SYS.CY.green) else print(txt) SYS.Notify("无剪贴板, 已打到控制台") end
return txt
end
function LAB.WhoCalls(name)
local fns=LAB.LastFns
if not fns then SYS.Notify("先点① GC 扫描",SYS.CY.yellow) return end
local target
for i=1,#fns do if nameOf(fns[i])==name then target=fns[i] break end end
if not target then SYS.Notify("没找到函数: "..tostring(name),SYS.CY.yellow) return end
local info=function(lv)
local ok,r=P(function()
if type(getinfo)=="function" then return getinfo(lv) end
if type(debug)=="table" and type(debug.getinfo)=="function" then return debug.getinfo(lv) end
return nil
end)
return ok and r or nil
end
local _,res=P(function() return target() end)
local me=info(1) local caller=info(2) local up=info(3)
local out={"========== 调用链探测: "..tostring(name).." ==========",
("  本帧   : %s"):format(me and (me.name or me.short_src or "?") or "?"),
("  调用者 : %s"):format(caller and (caller.name or caller.short_src or "?") or "? (顶层/匿名)"),
("  再上层 : %s"):format(up and (up.name or up.short_src or "?") or "?"),
("  返回值 : %s"):format(tostring(res):sub(1,80)),
"  ^ 这就是 pcall + immediate caller: 能看出「谁在调这个函数」"}
print(table.concat(out,"\n"))
SYS.Notify("调用链已输出到控制台",SYS.CY.green)
end
end
UI.Pages["传送"]=function(p)
UI.Section(p,"🖱 鼠标传送 · 快速跳转",CY.accent)
UI.Switch(p,"允许鼠标传送 (T)","TPEnabled")
UI.Btn(p,"传送到鼠标位置",CY.cyan,SYS.TPToMouse)
UI.Btn(p,"传送到最近玩家",CY.cyan,SYS.TPToNearest)
UI.Btn(p,"停止观战 (回自己视角)",CY.orange,SYS.StopSpectate)
UI.Btn(p,"回到主城",CY.green,function() SYS.TPTo(SYS.GetDefSpawn()) end)
UI.Btn(p,"保存当前坐标",CY.purple,function()
local _,_,root=GC()
if root then
table.insert(SYS.SavedPos,{name="位置"..#SYS.SavedPos+1,position=root.Position,autoTP=false})
if SYS.RebuildSaved then SYS.RebuildSaved() end
P(function()
SYS.Notify(("📍 已保存位置 #%d (自动循环传送: 关 · 点该行的「自动」按钮开启)")
:format(#SYS.SavedPos),SYS.CY.cyan)
end)
print("[TP] 已保存位置 #"..#SYS.SavedPos.." (autoTP=false · 需要时点列表行里的「自动」按钮)")
end
end)
UI.Cycle(p,"传送方式",{"CFrame","MoveTo"},
function() return SYS.C_.TPMethod end,
function(v) SYS.C_.TPMethod=v end)
UI.Cycle(p,"鼠标传送模式",{"Raycast","Infinite"},
function() return SYS.C_.MouseTPMode end,
function(v) SYS.C_.MouseTPMode=v end)
UI.Slider(p,"自动回点距离 (离开保存点超过它就传送回去)",1,50,1,function() return SYS.C_.AutoTPDist end,function(v) SYS.C_.AutoTPDist=v end,"%.0f")
UI.Switch(p,"⌨ Ctrl+数字 直达保存点","PathKey",SYS.SetPathKey)
UI.Tip(p,"按住 Ctrl 再按数字键 1~9 -> 直接传送到下面「已保存位置」里对应的那一条(主键盘/小键盘都认)。\n只对前 9 个生效; 那一条还不存在时会在屏幕上提示。默认关(避免误触)。",CY.sub)
UI.Section(p,"👥 玩家列表",CY.cyan)
local plList=Instance.new("ScrollingFrame")
plList.Size=UDim2.new(1,0,0,140) plList.BackgroundColor3=CY.card
plList.BackgroundTransparency=0.3 plList.BorderSizePixel=0 plList.Parent=p
plList.ClipsDescendants=true
P(function() plList.CanvasSize=UDim2.new(0,0,0,0) plList.AutomaticCanvasSize=Enum.AutomaticSize.Y end)
P(function() plList.ScrollBarThickness=6 plList.ScrollBarImageColor3=CY.accent end)
P(function() plList.ScrollingDirection=Enum.ScrollingDirection.Y end)
P(function() plList.ElasticBehavior=Enum.ElasticBehavior.Never end)
UI.Round(plList,8) UI.Stroke(plList,CY.line,1,0.85)
local lay=Instance.new("UIListLayout") lay.Padding=UDim.new(0,4) lay.Parent=plList
local pad=Instance.new("UIPadding")
pad.PaddingTop=UDim.new(0,6) pad.PaddingLeft=UDim.new(0,6)
pad.PaddingRight=UDim.new(0,6) pad.Parent=plList
local function Ref()
for _,c in ipairs(plList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
for _,pl in ipairs(Players:GetPlayers()) do
if pl~=LP then
local row=Instance.new("Frame")
row.Size=UDim2.new(1,-12,0,28) row.BackgroundColor3=CY.panel
row.BackgroundTransparency=0.3 row.BorderSizePixel=0 row.Parent=plList
UI.Round(row,6)
local nm=Instance.new("TextLabel")
nm.Size=UDim2.new(1,-120,1,0) nm.Position=UDim2.new(0,4,0,0)
nm.BackgroundTransparency=1 nm.TextColor3=CY.text nm.Text=pl.Name
nm.Font=Enum.Font.GothamMedium nm.TextSize=13 nm.TextXAlignment=Enum.TextXAlignment.Left
nm.Parent=row
local tb=Instance.new("TextButton")
tb.Size=UDim2.new(0,56,1,0) tb.Position=UDim2.new(1,-116,0,0)
tb.BackgroundColor3=CY.cyan tb.BackgroundTransparency=0.3 tb.TextColor3=CY.text
tb.Text="传送" tb.Font=Enum.Font.GothamBold tb.TextSize=11
tb.BorderSizePixel=0 tb.Parent=row UI.Round(tb,4)
tb.MouseButton1Click:Connect(function() P(SYS.TPToPlayer,pl) end)
local sb=Instance.new("TextButton")
sb.Size=UDim2.new(0,56,1,0) sb.Position=UDim2.new(1,-56,0,0)
sb.BackgroundColor3=CY.orange sb.BackgroundTransparency=0.3 sb.TextColor3=CY.text
sb.Text="观战" sb.Font=Enum.Font.GothamBold sb.TextSize=11
sb.BorderSizePixel=0 sb.Parent=row UI.Round(sb,4)
sb.MouseButton1Click:Connect(function() P(SYS.Spectate,pl) end)
end
end
end
Ref()
T(Players.PlayerAdded:Connect(function() task.wait(0.3) P(Ref) end))
T(Players.PlayerRemoving:Connect(function() task.wait(0.3) P(Ref) end))
UI.Label(p,"已保存位置 (点行里的「自动」按钮才会循环传送, 默认关)",CY.sub)
local svList=Instance.new("ScrollingFrame")
svList.Size=UDim2.new(1,0,0,140) svList.BackgroundColor3=CY.card
svList.BackgroundTransparency=0.3 svList.BorderSizePixel=0 svList.Parent=p
svList.ClipsDescendants=true
P(function() svList.CanvasSize=UDim2.new(0,0,0,0) svList.AutomaticCanvasSize=Enum.AutomaticSize.Y end)
P(function() svList.ScrollBarThickness=6 svList.ScrollBarImageColor3=CY.accent end)
P(function() svList.ScrollingDirection=Enum.ScrollingDirection.Y end)
P(function() svList.ElasticBehavior=Enum.ElasticBehavior.Never end)
UI.Round(svList,8) UI.Stroke(svList,CY.line,1,0.85)
local svLay=Instance.new("UIListLayout") svLay.Padding=UDim.new(0,4) svLay.Parent=svList
local svPad=Instance.new("UIPadding")
svPad.PaddingTop=UDim.new(0,6) svPad.PaddingLeft=UDim.new(0,6)
svPad.PaddingRight=UDim.new(0,6) svPad.Parent=svList
local function RebuildSaved()
for _,c in ipairs(svList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
for i,s in ipairs(SYS.SavedPos) do
local r=Instance.new("Frame")
r.Size=UDim2.new(1,-12,0,30) r.BackgroundColor3=CY.panel
r.BackgroundTransparency=0.3 r.BorderSizePixel=0 r.Parent=svList
UI.Round(r,6)
local tp=Instance.new("TextButton")
tp.Size=UDim2.new(0.5,0,1,0) tp.BackgroundTransparency=1
tp.TextColor3=CY.text
tp.Text=string.format("%s (%.0f,%.0f,%.0f)",s.name,s.position.X,s.position.Y,s.position.Z)
tp.Font=Enum.Font.GothamMedium tp.TextSize=12
tp.TextXAlignment=Enum.TextXAlignment.Left tp.Parent=r
tp.MouseButton1Click:Connect(function() P(SYS.TPTo,s.position+Vector3.new(0,2,0)) end)
local au=Instance.new("TextButton")
au.Size=UDim2.new(0,60,1,0) au.Position=UDim2.new(0.55,0,0,0)
au.BackgroundColor3=s.autoTP and CY.green or CY.sub
au.BackgroundTransparency=0.3 au.TextColor3=CY.text
au.Text=s.autoTP and "自动✓" or "自动"
au.Font=Enum.Font.GothamBold au.TextSize=11
au.BorderSizePixel=0 au.Parent=r UI.Round(au,4)
au.MouseButton1Click:Connect(function()
s.autoTP=not s.autoTP
au.Text=s.autoTP and "自动✓" or "自动"
au.BackgroundColor3=s.autoTP and CY.green or CY.sub
P(function()
SYS.Notify(s.autoTP and ("📍 「"..s.name.."」自动循环传送已开启")
or ("📍 「"..s.name.."」自动循环传送已关闭"),
s.autoTP and CY.green or CY.sub)
end)
end)
local dl=Instance.new("TextButton")
dl.Size=UDim2.new(0,40,1,0) dl.Position=UDim2.new(1,-44,0,0)
dl.BackgroundColor3=CY.red dl.BackgroundTransparency=0.3
dl.TextColor3=CY.text dl.Text="删"
dl.Font=Enum.Font.GothamBold dl.TextSize=11
dl.BorderSizePixel=0 dl.Parent=r UI.Round(dl,4)
dl.MouseButton1Click:Connect(function()
table.remove(SYS.SavedPos,i) RebuildSaved()
end)
end
end
SYS.RebuildSaved=RebuildSaved
RebuildSaved()
end
UI.Pages["战斗"]=function(p)
local AUTO_TXT="自动 · 按优先级挑"
UI.Section(p,"📊 实时状态",CY.accent)
local card,inner=UI.Card(p,175)
local _,targetV=UI.Stat(inner,"当前目标","—")
local _,wantV=UI.Stat(inner,"指定目标","自动")
local _,lockV=UI.Stat(inner,"锁定状态","未锁定")
local _,aimV=UI.Stat(inner,"瞄准方式","关闭")
local _,distV=UI.Stat(inner,"距离","—")
local _,perfV=UI.Stat(inner,"循环频率(选人/开火)","—")
UI.Section(p,"⚔ 一键开战 / 停战",CY.green)
UI.Btn(p,"⚡ 一键开战 (秒锁秒开枪 · 移动中也准)",CY.green,function()
if SYS.Combat and SYS.Combat.QuickMode then SYS.Combat.QuickMode() end
end)
UI.Btn(p,"🛑 一键停战 (关掉全部开关 + 恢复视角与控制)",CY.red,function()
if SYS.Combat then
P(SYS.Combat.DisableAll)
P(SYS.Combat.Stop)
end
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
P(SYS.ResetCam)
P(SYS.EnablePlayerControls)
SYS.Combat.Say("已停战, 视角与控制已恢复",SYS.CY.red)
end)
UI.Tip(p,"「一键开战」= 自动瞄准 + 自动开火 0.04 秒 + 锁头 + 预测 + 优先链(正在瞄我的→指定→最近→屏幕中心)。\n点完直接打就行。",CY.green)
UI.Div(p)
UI.Section(p,"🎯 瞄准 (自动瞄准 / 关闭)",CY.accent)
local AIM_OFF   ="关闭"
local AIM_AUTO  ="自动瞄准 · 持续把准星转过去"
UI.Cycle(p,"瞄准方式",{AIM_OFF,AIM_AUTO},
function()
if SYS.T_.CB_Aim then return AIM_AUTO end
return AIM_OFF
end,
function(v)
SYS.T_.CB_Aim     =(v==AIM_AUTO)
SYS.T_.CB_SnapFire=false
SYS.T_.CB_Silent=false
if SYS.Combat then
SYS.Combat.Start()
SYS.Combat.Say("瞄准方式 -> "..v,SYS.CY.accent)
end
end)
UI.Tip(p,"「自动瞄准」= 每帧把准星转到目标身上。移动中被相机带偏就打开「移动时暂停瞄准」。\n背身锁得快不快看下面的「跟随速度」(调大更快)。",CY.yellow)
UI.Switch(p,"🎯 360 无死角 (有人就锁就打 · 不看方向/视野)","CB_360")
UI.Slider(p,"索敌间隔 (毫秒 · 0=每帧秒锁)",0,200,1,
function() return SYS.C_.CB_ScanMs or 33 end,
function(v) SYS.C_.CB_ScanMs=v QueueSave() end,"%.0f")
UI.Cycle(p,"瞄准部位",{"头","身","自动(离准星最近)"},
function() return ({"头","身","自动(离准星最近)"})[SYS.C_.CB_AimPart or 2] end,
function(v) SYS.C_.CB_AimPart = (v=="头") and 1 or ((v=="身") and 2 or 3) end)
UI.Switch(p,"📐 预测瞄准 (算目标移动的提前量)","CB_Predict")
UI.Slider(p,"预测提前量 (秒 · 目标越快调越大)",0.05,0.60,0.01,
function() return SYS.C_.CB_PredictTime end,
function(v) SYS.C_.CB_PredictTime=v end,"%.2f")
UI.Switch(p,"🏹 抛射物弹道预判 (弓/火箭/手雷等抛物线武器)","CB_Ballistic")
UI.Slider(p,"抛射物初速 (studs/秒 · 看武器面板)",20,600,10,
function() return SYS.C_.CB_ProjSpeed end,
function(v) SYS.C_.CB_ProjSpeed=v QueueSave() end,"%.0f")
UI.Slider(p,"下坠加速度 (0=不补下坠)",0,400,5,
function() return SYS.C_.CB_ProjGrav end,
function(v) SYS.C_.CB_ProjGrav=v QueueSave() end,"%.0f")
UI.Tip(p,"★ 「抛射物弹道预判」解的是: 子弹要飞多久才追得上目标 + 飞行途中掉多少 —— 两个一起补,\n  所以远距离/高抛不会再打低。初速对着武器面板(或游戏 wiki)填; 下坠填 196.2 是标准重力,\n  填 0 = 只补飞行时间、不补下坠。\n★ 参数填错顶多「解不出交点」, 会自动退回上面的线性提前量, 不会把瞄准弄坏。\n★ 想知道当前地图的重力: 控制台执行 print(workspace.Gravity)。",CY.yellow)
UI.Slider(p,"跟随速度 (自动瞄准跟得多紧)",0.05,1,0.05,
function() return SYS.C_.CB_Smooth end,
function(v) SYS.C_.CB_Smooth=v end,"%.2f")
UI.Slider(p,"索敌范围 (屏幕像素半径 · 越小越只锁正前方)",40,600,10,
function() return SYS.C_.CB_Fov end,
function(v) SYS.C_.CB_Fov=v end,"%.0f")
UI.Slider(p,"最大距离",50,2000,50,
function() return SYS.C_.CB_MaxDist end,
function(v) SYS.C_.CB_MaxDist=v end,"%.0f")
UI.Tip(p,"★ 已移除「命中率 / 漏打模式」—— 不再有任何「故意打偏」, 开了就是最准。\n★ 平滑度/预判量/索敌半径已经在上面 —— 对应「跟随速度 / 预测提前量 / 索敌范围」, 不再重复给控件。\n★ 「粘性瞄准(锁定保持)」你早前明确删过, 这次没有加回来 —— 需要的话单独说。",CY.yellow)
UI.Div(p)
UI.Section(p,"🔫 自动开火 (Triggerbot)",CY.red)
UI.Switch(p,"🔫 自动开火","CB_Fire",function(on) if on then SYS.Combat.Start() end end)
UI.Slider(p,"开火间隔 (秒 · 0=每帧都开, 最快)",0,0.50,0.005,
function() return SYS.C_.CB_FireDelay end,
function(v) SYS.C_.CB_FireDelay=v end,"%.3f")
UI.Slider(p,"只打血量低于此值的目标 (0=不限)",0,100,5,
function() return SYS.C_.CB_HpThr end,
function(v) SYS.C_.CB_HpThr=v end,"%.0f")
UI.Tip(p,"「自动开火」要看得见目标才开枪: 开着自动瞄准时直接用锁定目标;\n瞄准关着时要求准星真压在敌人身上(纯扳机模式)。",CY.sub)
UI.Div(p)
UI.Section(p,"🧭 打谁 · 选人规则",CY.purple)
UI.Dropdown(p,"指定目标(点开选择)", function()
local L={AUTO_TXT}
local names={}
local ps=Players:GetPlayers()
if ps then
for _,pl in ipairs(ps) do
if pl~=SYS.LP and pl.Character and pl.Character.Parent then
names[#names+1]=pl.Name
end
end
end
table.sort(names)
for i=1,#names do L[#L+1]=names[i] end
return L
end,
function()
if SYS.C_.CB_TargetMode==2 and SYS.C_.CB_TargetName and SYS.C_.CB_TargetName~="" then
return SYS.C_.CB_TargetName
end
return AUTO_TXT
end,
function(v)
if (not v) or v==AUTO_TXT then
SYS.Combat.ClearTarget()
print("[Combat] 选人方式 -> 自动")
SYS.Combat.Say("指定目标已清除, 回到自动选人",SYS.CY.sub)
else
local got=SYS.Combat.LockTarget(v)
SYS.Combat.Say(got and ("指定目标 -> "..got) or "指定失败",got and SYS.CY.green or SYS.CY.red)
end
SYS.Combat.Start()
end)
UI.Btn(p,"🎯 锁定此刻正在打的目标",CY.green,function()
local n=SYS.Combat.LockTarget()
if n then SYS.Combat.Say("已锁定目标: "..n,SYS.CY.green)
else SYS.Combat.Say("当前没有目标可锁(点「输出战斗诊断」能看到被什么挡住)",SYS.CY.red) end
end)
UI.Btn(p,"🔄 换下一个目标 (热键 V)",CY.accent,function()
local n=SYS.Combat.CycleTarget(1)
SYS.Combat.Say(n and ("已切到: "..n) or "附近没有可选目标",n and SYS.CY.green or SYS.CY.red)
end)
UI.Switch(p,"🚫 只打指定目标 (他不在就不动手)","CB_TgtStrict")
UI.Div(p)
UI.Div(p)
UI.Section(p,"📋 白名单 / 黑名单 (选人硬规则)",CY.orange)
UI.Dropdown(p,"选一个玩家", function()
local L={}
local ps=Players:GetPlayers()
for i=1,#ps do
local pl=ps[i]
if pl~=LP then L[#L+1]=pl.Name end
end
table.sort(L)
return L
end,
function() return SYS.C_.WL_Sel or "" end,
function(v) SYS.C_.WL_Sel=v end)
UI.Btn(p,"⬜ 加入白名单 (白名单非空时只选白名单里的人)",CY.cyan,function()
local n=SYS.C_.WL_Sel
if SYS.WL.Add(n,true) then SYS.Notify("⬜ 已加入白名单: "..tostring(n),SYS.CY.cyan)
else SYS.Notify("先在上面选一个玩家",SYS.CY.sub) end
end)
UI.Btn(p,"⬛ 加入黑名单 (永远不选他)",CY.red,function()
local n=SYS.C_.WL_Sel
if SYS.WL.Add(n,false) then SYS.Notify("⬛ 已加入黑名单: "..tostring(n),SYS.CY.red)
else SYS.Notify("先在上面选一个玩家",SYS.CY.sub) end
end)
UI.Btn(p,"📋 打印当前名单 (控制台)",CY.purple,function()
local w=SYS.WL.List(true) local b=SYS.WL.List(false)
print("[CheatMenu] 白名单("..#w.."): "..table.concat(w,", "))
print("[CheatMenu] 黑名单("..#b.."): "..table.concat(b,", "))
SYS.Notify("📋 名单已打到控制台(F9)",SYS.CY.purple)
end)
UI.Btn(p,"🧹 清空白名单 / 黑名单",CY.orange,function()
SYS.WL.White={} SYS.WL.Black={}
SYS.Notify("🧹 名单已清空",SYS.CY.sub)
end)
UI.Tip(p,"规则: 黑名单里的名字【永远不选】; 白名单【非空】时只从白名单里选人(其余全部排除)。\n两边互斥 —— 加进一边会自动从另一边移除。",CY.sub)
UI.Section(p,"🔀 选人偏好 (自动选人的先后顺序)",CY.purple)
UI.Cycle(p,"优先模式 (自动选人的先后顺序)",{"正在瞄我的→指定→最近→屏幕中心","最近→屏幕中心","准星指向→最近→屏幕中心","血量最低→最近→屏幕中心","屏幕中心→最近"},
function() return ({"正在瞄我的→指定→最近→屏幕中心","最近→屏幕中心","准星指向→最近→屏幕中心","血量最低→最近→屏幕中心","屏幕中心→最近"})[SYS.C_.CB_PrioMode or 1] end,
function(v)
local m={["正在瞄我的→指定→最近→屏幕中心"]=1,["最近→屏幕中心"]=2,["准星指向→最近→屏幕中心"]=3,["血量最低→最近→屏幕中心"]=4,["屏幕中心→最近"]=5}
SYS.C_.CB_PrioMode = m[v] or 1
end)
UI.Tip(p,"优先模式 = 按顺序一级级筛: 先满足第一优先, 没有再往下。\n★ 「指定」= 你在战斗页指定的那个人。默认链里它排第 2 —— 有人正瞄着你时先打他, 没人瞄你才轮到指定目标。\n★ 打开「只打指定目标」后, 指定目标仍【绝对最优先】(整条链都不参与)。\n默认「正在瞄我的→指定→最近→屏幕中心」: 先打正瞄着你的人, 其次你指定的, 再次最近的, 最后屏幕中间那个。",CY.sub)
UI.Switch(p,"💀 只锁活人 (没有血量的尸体不算人)","CB_OnlyAlive")
UI.Switch(p,"🛡 不打队友 (混战/自建房请关掉)","CB_Team")
UI.Switch(p,"🔪 近距离补刀 (贴脸自动按 F, 含非目标)","CB_Melee")
UI.Tip(p,"开 = 有敌人在补刀距离内就自动按 F: 优先补【锁定的目标】, 它不在射程内就补【最近的敌人】。\n(所以旁边的非目标敌人贴脸也会补, 不会漏。) 距离用下面的滑块调。",CY.sub)
UI.Slider(p,"补刀距离(格)",3,25,1,function() return SYS.C_.CB_MeleeDist end,function(v) SYS.C_.CB_MeleeDist=v end,"%.0f")
UI.Tip(p,"和敌人贴脸时枪常打不中(准星/弹道问题), 开着这个会自动按 F 用近战收掉。\n只对【已锁定的目标】且在设定距离内才按, 不影响中远距离枪战。",CY.sub)
UI.Switch(p,"👁 只打视野内 (只选屏幕上看得见的人)","CB_Wall")
UI.Switch(p,"🚶 移动时暂停瞄准 (按 WASD 让出相机)","CB_PauseMove")
UI.Tip(p,"「只锁活人」默认开 —— 关掉它 = 允许锁定没有 Humanoid 的模型, 某些游戏会锁到尸体。",CY.yellow)
UI.Tip(p,"开着 = 只打你【看得见】的人: 隔墙的人不选(这就是「不穿墙」)。\n背身/360° 转身照样锁得到 —— 判定按实时相机走, 只要你和目标之间没有墙。\n关掉 = 隔墙的人也选(会对着墙开枪, 基本没用)。",CY.yellow)
UI.Switch(p,"🛡 跳过无敌盾 (带盾的不打, 等护盾结束)",'CB_SkipFF')
UI.Tip(p,"开 = 带「无敌盾」(ForceField/刚出生·刚复活的无敌)的人【完全不打】, 等护盾结束自动恢复锁定。\n关 = 旧行为(把他们排到最后, 全服都有盾时仍会去打)。",CY.sub)
UI.Div(p)
UI.Div(p)
UI.Section(p,"☢ 高风险瞄准 (默认全关 · 需要才开)",CY.red)
UI.Switch(p,"🧱 表现层对抗 (禁布娃娃/物理状态 · 纯本地)","BlockHandlers",SYS.SetBlockHandlers)
UI.Tip(p,"⚠ 封号风险自查(由高到低):\n"..
"① 在【热门服】飞天 / 瞬移 / 乱杀 = 最高 —— 会被其他玩家举报 -> 人工复核, 任何绕过都藏不住行为;\n"..
"② 自动打人 / 自动农场 = 高(服务端行为统计能看出规律);  ③ 纯视觉(透视 / 光照 / 屏蔽表现) = 最低。\n"..
"🧱 表现层对抗 = 禁布娃娃 / 物理 / 平台站立状态(纯本地, 不影响别人)。\n"..
"⚠ 本执行器【没有 getconnections】, 做不到「让游戏根本不播」跳脸 / 震屏 —— 只能事后对抗状态。\n"..
"— 现代反作弊在查什么(2026-09 公开清单, 知道=能避):\n"..
"  · 服务端侧: 飞行(CFrame/载具/座位) · 移速与速度异常 · 位置/传送校验 · 穿墙碰撞 · 多工具/背包利用 · 角色物理完整性;\n"..
"  · 客户端侧: __namecall/__index/__newindex 被 hook · 元表被改(setreadonly/getrawmetatable) · 函数被 hook(debug.info/getfenv/hookfunction) · CoreGui 注入 · gcinfo/collectgarbage 伪装 · 弱表操纵;\n"..
"  · 战斗侧: 静默瞄准的弹道分析 · 命中盒扩张 · 近战/射程超限;\n"..
"  · 网络侧: Remote 速率限制 · 远程方法 hook 检测 · 挑战-应答令牌。\n"..
"⇒ 直接推论: 本菜单把『管理员检测绕过』改成【不 hook __namecall、只挪进隐藏容器】是对的;\n"..
"  自动开火间隔带 ±20% 抖动也是对的(恒定节奏最容易被速率统计抓)。这两条别改回去。",CY.yellow)
UI.Switch(p,"🙈 真·静默 (不转相机/不转角色, 只改射线命中)","CB_SilentNoTurn",function(on)
SYS.T_.CB_SilentAim = on and true or false
if on then
local ok,err=SYS.RayHook.Install()
if not ok then
SYS.T_.CB_SilentAim=false SYS.T_.CB_SilentNoTurn=false
SYS.Notify("❌ 开启失败: "..tostring(err),SYS.CY.red)
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
else
SYS.Notify("🙈 真·静默已开 —— 射线改写中, 相机与角色都不动",SYS.CY.red)
end
elseif SYS.T_.CB_BulletWall~=true and SYS.T_.CB_BlockRay~=true then
SYS.RayHook.Remove()
end
end)
UI.Switch(p,"子弹穿墙 (隔墙也判定命中)","CB_BulletWall",function(on)
if on then
local ok,err=SYS.RayHook.Install()
if not ok then
SYS.T_.CB_BulletWall=false
SYS.Notify("❌ 开启失败: "..tostring(err),SYS.CY.red)
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
else
SYS.Notify("⚠ 子弹穿墙已开 —— 射线改写中",SYS.CY.red)
end
elseif SYS.T_.CB_SilentAim~=true and SYS.T_.CB_BlockRay~=true then
SYS.RayHook.Remove()
end
end)
UI.Switch(p,"阻挡射线检测 (游戏自己的射线一律打空)","CB_BlockRay",function(on)
if on then
local ok,err=SYS.RayHook.Install()
if not ok then
SYS.T_.CB_BlockRay=false
SYS.Notify("❌ 开启失败: "..tostring(err),SYS.CY.red)
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
else
SYS.Notify("⚠ 阻挡射线已开 —— 副作用很大, 用完记得关",SYS.CY.red)
end
elseif SYS.T_.CB_SilentAim~=true and SYS.T_.CB_BulletWall~=true then
SYS.RayHook.Remove()
end
end)
UI.Btn(p,"🧪 射线改写统计 (控制台)",CY.cyan,function()
print("[CheatMenu] 射线改写次数: "..tostring(SYS.RayHook.Rewrites)
.."  hook 已装: "..tostring(SYS.RayHook.Hooked))
SYS.Notify("🧪 结果已打到控制台(F9)",SYS.CY.cyan)
end)
UI.Tip(p,"⚠ 这三条都改写【游戏自己的射线】—— 属反检测对抗类, 风险最高, 因此默认全关:\n  · 静默瞄准 = 游戏射线命中点被改写成当前锁定目标\n  · 子弹穿墙 = 同上, 且不要求视线\n  · 阻挡射线检测 = 游戏射线一律返回空(游戏的视线判定/检测会整体失灵, 副作用最大)\n★ 三条共用同一个 hook, 关掉最后一个才会真正卸下。\n★ 游戏更新后若射线 API 改名, 可能失效 —— 失效就关掉。",CY.yellow)
task.spawn(function()
local lastScan,lastHud=0,0
while card.Parent do
task.wait(0.5)
if card.Visible and p.Visible then
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
local cb=SYS.Combat
if cb then
local st=cb.Stat or {scan=0,hud=0}
perfV.Text=("%d / %d 次每秒%s"):format((st.scan-lastScan)*2,(st.hud-lastHud)*2,
(cb.RenderBound and "" or "  ⚠未运行"))
lastScan=st.scan lastHud=st.hud
targetV.Text=cb.Target and cb.Target.Name or "—"
targetV.TextColor3=cb.Target and CY.green or CY.text
local want=cb.TargetName and cb.TargetName()
if want and (SYS.C_.CB_TargetMode or 1)==2 then
wantV.Text=want
wantV.TextColor3=CY.yellow
else
wantV.Text="自动"
wantV.TextColor3=CY.sub
end
lockV.Text=cb.Target and "已锁定" or "未锁定"
lockV.TextColor3=cb.Target and CY.green or CY.sub
if SYS.T_.CB_Aim then
aimV.Text="自动瞄准" aimV.TextColor3=CY.green
else
aimV.Text="关闭" aimV.TextColor3=CY.sub
end
local root=(cb.BodyOf and cb.BodyOf(SYS.LP.Character)) or nil
distV.Text=(cb.TargetPart and root)
and ("%.0f m"):format((cb.TargetPart.Position-root.Position).Magnitude) or "—"
end
end
end
end)
end
UI.Pages["MachineParty"]=function(p)
UI.Section(p,"🤖 小游戏 · 自动",CY.accent)
UI.Tip(p,"🎮 小游戏区域透视已并入【视觉页 -> 🔍 物件透视】(判据合并, 一个开关一起亮)。",CY.sub)
UI.Switch(p,"🏃 自动躲伤害机关 (靠近陷阱/地雷/压板/弹球自动退开)","AutoDodge",SYS.SetAutoDodge)
UI.Switch(p,"🎯 自动触发小游戏目标 (小游戏区域里的按钮/可交互物自动触发)","AutoHitMinigame",SYS.SetAutoHitMinigame)
UI.Tip(p,"自动躲: 扫全图伤害机关(与「🔍 物件透视」里门·陷阱那条同判据, 已含地雷 mine/bomb/landmine/地雷/炸弹), 离你约 15 格内自动走开。\n自动触发: 只扫【小游戏区域】里的 ProximityPrompt/ClickDetector, 自动帮你按/点(打鸭子那类)。\n两个都纯客户端、默认关, 关掉即停; 隔墙/隐形的地雷也能扫到(只要客户端有这个实例)。",CY.sub)
end
UI.Pages["设置"]=function(p)
UI.Section(p,"💾 配置 (自动保存 / 自动读回)",CY.green)
UI.Label(p,SYS.has_fs_txt,SYS.HAS_FS and CY.green or CY.yellow)
UI.Tip(p,"开关改动会自动保存, 下次加载脚本时自动生效(无需手动操作)。",CY.sub)
UI.Div(p)
UI.Section(p,"⌨ 热键设置 (点一下再按新键)",CY.cyan)
local function keyRow(label,field)
local b=UI.Btn(p,label.."  ["..tostring(SYS.C_[field] or "?").."]",CY.card,function()
SYS.KeyPickTarget=field
SYS.Notify("请按下一个键来绑定「"..label.."」",SYS.CY.yellow)
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
end)
SYS.BtnRefs[#SYS.BtnRefs+1]=function()
if b and b.Parent then
local cur=(SYS.KeyPickTarget==field) and "[等待按键...]" or tostring(SYS.C_[field] or "?")
b.Text=label.."  ["..cur.."]"
end
end
end
keyRow("打开/关闭菜单","Key_Menu")
keyRow("循环切换指定目标","Key_CycleTarget")
keyRow("鼠标传送到准星","Key_Teleport")
UI.Tip(p,"点按钮 -> 提示「等待按键」-> 按你要的键就绑好了。\n(右Shift 始终能开菜单, 作为备用键)",CY.sub)
UI.Div(p)
UI.Btn(p,"自杀",CY.red,function()
if SYS.T_.GodMode then return end
local c=LP.Character
if c then
local h=c:FindFirstChildOfClass("Humanoid")
if h then h.Health=0 end
end
end)
UI.Btn(p,"重置相机",CY.cyan,SYS.ResetCam)
UI.Switch(p,"🖱 打开菜单时接管鼠标 (显示鼠标 + 自由移动)","MenuMouse")
UI.Tip(p,"开(默认) = 开菜单后把鼠标切回【显示 + 自由移动】(第一人称/锁鼠标的游戏里, 不这样菜单点不到)。\n关 = 【完全不碰】鼠标行为 —— 有些服务器每帧把鼠标锁回 LockCenter, 我们每帧抢回会和它互刷(鼠标抖动/不听使唤), 这种服务器上关掉更稳(但菜单可能点不到, 得用键盘/触屏)。",CY.sub)
UI.Cycle(p,"强制视角",{"关","第一人称","第三人称"},
function()
local m=SYS.C_.ForceCam or "off"
return (m=="first") and "第一人称" or ((m=="third") and "第三人称" or "关")
end,
function(v)
SYS.C_.ForceCam=(v=="第一人称") and "first" or ((v=="第三人称") and "third" or "off")
if SYS.SetForceCam then P(SYS.SetForceCam,SYS.C_.ForceCam) end
end)
UI.Tip(p,"强制视角 = 把相机锁成第一/第三人称(每 0.5s 兜底抢回, 防游戏脚本改回去)。\n第一人称 = 相机锁进角色头里; 第三人称 = 强制可拉远的经典视角。",CY.sub)
UI.Div(p)
UI.Section(p,"📱 界面缩放 (手机 / 平板适配)",CY.cyan)
local TDEV=(SYS.DEV and SYS.DEV.anyTouch)==true
UI.Slider(p,"界面缩放 (0 = 自动适配)",0,(TDEV and 3.0 or 2.5),0.05,
function() return SYS.C_.UIScaleManual or 0 end,
function(v)
SYS.C_.UIScaleManual=v
if SYS.ApplyUIScale then P(SYS.ApplyUIScale) end
end,"%.2f")
if TDEV then
local lb=UI.Label(p,"",CY.accent)
local function bump(d)
local cur=tonumber(SYS.C_.UIScaleManual) or 0
local base=(cur>0) and cur or (tonumber(SYS.LastUIScale) or 1)
SYS.C_.UIScaleManual=math.clamp(math.floor((base+d)*100+0.5)/100,0.30,3.0)
if SYS.ApplyUIScale then P(SYS.ApplyUIScale) end
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
end
UI.Btn(p,"➖ 缩小 0.05",CY.panel,function() bump(-0.05) end)
UI.Btn(p,"➕ 放大 0.05",CY.panel,function() bump(0.05) end)
SYS.BtnRefs[#SYS.BtnRefs+1]=function()
local man=tonumber(SYS.C_.UIScaleManual) or 0
local eff=tonumber(SYS.LastUIScale) or 1
if man>0 then
lb.Text=("当前 %.2f×（手动）  可拉到 3.00"):format(eff)
else
lb.Text=("当前 %.2f×（自动）  自动上限 %.2f"):format(eff,tonumber(SYS.LastUIScaleAuto) or eff)
end
end
end
UI.Btn(p,"📐 恢复自动适配",CY.green,function()
SYS.C_.UIScaleManual=0
if SYS.ApplyUIScale then P(SYS.ApplyUIScale) end
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
SYS.Notify("📐 已恢复自动适配",SYS.CY.green)
end)
UI.Tip(p,"★ 默认「自动适配」: 按屏幕尺寸算出可用的最大倍数 ——\n"
.."   手机 / 平板(纯触屏) 最多放大到 1.75 倍, 小视口 1.35 倍, PC 保持 1.0 倍。\n"
.."   算法是 sc = min(fit, 上限), fit 已扣掉刘海 / 顶部栏边距 -> 【永远塞得进屏幕】。\n"
.."★ 还是嫌小就往右拉滑块(会覆盖自动值); 想回到自动点「恢复自动适配」。\n"
..(TDEV and ("★ 手机 / 平板专属: 上面有 ➖/➕ 微调; 也可以直接拖菜单右下角的 ◢ 把手改尺寸。\n"
.."   菜单拖到哪会记住, 下次打开回到原位(拖出屏幕会被自动拉回来)。\n") or "")
.."⚠ 手动拉得过大(超过 fit)菜单会超出屏幕、边角按钮点不到 —— 拉回来或点恢复自动即可。",CY.sub)
function SYS.ExportConfig()
P(function()
local parts={}
for k,v in pairs(SYS.C_ or {}) do parts[#parts+1]=("%s=%s"):format(k,tostring(v)) end
table.sort(parts)
local str="CheatMenuCfg|"..table.concat(parts,";")
if setclipboard then setclipboard(str) SYS.Notify("📤 配置已复制到剪贴板",SYS.CY.green)
else print(str) SYS.Notify("📤 已打到控制台(这台没有 setclipboard)",SYS.CY.yellow) end
end)
end
function SYS.ImportConfig(str)
P(function()
if type(str)~="string" or not str:find("CheatMenuCfg|",1,true) then
SYS.Notify("📥 配置串不合法(缺少 CheatMenuCfg| 前缀)",SYS.CY.red) return
end
local body=str:sub(select(2,str:find("CheatMenuCfg|",1,true))+#"CheatMenuCfg|")
local n=0
for pair in body:gmatch("[^;]+") do
local k,v=pair:match("^([^=]+)=(.*)$")
if k and k~="" and SYS.C_[k]~=nil then
local num=tonumber(v)
if num~=nil then SYS.C_[k]=num
elseif v=="true" then SYS.C_[k]=true
elseif v=="false" then SYS.C_[k]=false
else SYS.C_[k]=v end
n=n+1
end
end
P(SYS.SaveConfig)
SYS.Notify(("📥 已导入 %d 项(切页/重载菜单后生效)"):format(n),SYS.CY.green)
end)
end
UI.Btn(p,"🔄 重进服务器 (Rejoin)",CY.purple,function()
SYS.Notify("正在重进服务器...",CY.purple)
SYS.Rejoin()
end)
UI.Div(p)
UI.Div(p)
UI.Switch(p,"🔁 有新版本时自动热重载","AutoUpdateCheck")
UI.Tip(p,"★ 每次启动都会检查一次新版本；检查到就会弹消息告诉你【新版本号】。\n本开关只决定「要不要自动升级」：开着=直接热重载到新版；关掉=只提示不升级，想升级再点上面的按钮。",CY.sub)
UI.Btn(p,"⬆️ 检查更新并热重载",CY.green,function() P(function() SYS.CheckUpdate(false) end) end)
UI.Tip(p,"热重载 = 先保存当前配置(含所有开关) -> 卸载旧实例 -> 拉取新版 -> 加载。\n新实例启动时会自动按配置把开关开回来, 所以你会看到功能自己恢复。")
UI.Switch(p,"🚀 重新加载时先检查新版本","BootUpdateCheck")
UI.Tip(p,"★ 管的是【刚加载的那一瞬间】: 退出游戏 / 卸载脚本后重新注入时, 先看一眼仓库有没有新脚本。\n有 -> 直接用新版启动(启动后会弹「已更新 x → y」); 没有 -> 正常打开。\n好处: 你永远不会先看到旧版界面再被换掉。检查在界面建立之前完成, 取不到版本号(离线 / 执行器没有 HttpGet)就照常打开, 绝不挡路。",CY.sub)
UI.Div(p)
UI.Btn(p,"🗑️ 卸载脚本 (干净退出)",CY.red,function()
SYS.Notify("正在卸载...",CY.red)
task.delay(0.1,function() P(SYS.UnloadAll) end)
end)
UI.Tip(p,"卸载 = 关掉全部功能 + 销毁菜单 + 恢复相机/控制; 不会重进服务器、不会断开连接。\n换服务器用上面的「重进服务器」。(之前报 277 被踢, 是点到重进服务器了, 不是卸载)",CY.sub)
end
UI.Pages["玩家"]=function(p)
UI.Section(p,"🎯 选择目标",CY.cyan)
UI.Dropdown(p,"选择玩家", function()
local L={}
local ps=Players:GetPlayers()
for i=1,#ps do
local pl=ps[i]
if pl~=LP then L[#L+1]=pl.Name end
end
table.sort(L)
return L
end,
function() return SYS.C_.PC_Sel or "" end,
function(v)
SYS.C_.PC_Sel=v
if SYS.PCRender then P(SYS.PCRender) end
end)
local infoCard,info=UI.Card(p,118)
local _,nL=UI.Stat(info,"昵称","—")
local _,uL=UI.Stat(info,"用户名","—")
local _,idL=UI.Stat(info,"用户ID","—")
local _,jL=UI.Stat(info,"账号年龄","—")
local _,dL=UI.Stat(info,"距离","—")
local function pcRender()
local pl=SYS.PC.Get()
if not pl then
nL.Text="—" uL.Text="—" idL.Text="—" jL.Text="—" dL.Text="—"
return
end
nL.Text=tostring(pl.DisplayName or pl.Name)
uL.Text="@"..tostring(pl.Name)
idL.Text=tostring(pl.UserId)
local okAge,age=pcall(function() return pl.AccountAge end)
jL.Text=(okAge and age) and (tostring(age).." 天") or "?"
local r=SYS.PC.Root(pl)
local _,_,mine=GC()
if r and mine then
dL.Text=("%.0f 格"):format((r.Position-mine.Position).Magnitude)
else
dL.Text="—"
end
end
SYS.PCRender=pcRender
pcRender()
UI.Btn(p,"🔄 刷新信息",CY.cyan,function() pcRender() end)
UI.Div(p)
UI.Section(p,"🚀 传送类 (只把你送过去 / 拉过来)",CY.green)
UI.Btn(p,"🚀 传送到他",CY.green,function() SYS.PC.GotoTarget("tp") end)
UI.Btn(p,"🎯 缓动到他 (1.2 秒滑过去)",CY.purple,function() SYS.PC.GotoTarget("tween") end)
UI.Btn(p,"🚶 寻路/步行到他",CY.cyan,function() SYS.PC.GotoTarget("walk") end)
UI.Switch(p,"🔁 循环跟传 (离远了自动再过去)","PC_LoopTP",function(on) SYS.PC.LoopTP(on) end)
UI.Btn(p,"🧲 把他拉过来 (客户端)",CY.orange,function() SYS.PC.BringTarget() end)
UI.Tip(p,"带「客户端」字样的按钮只改你本地看到的画面 —— 服务端不认, 他本人没感觉, 而且很快会被拉回。\n这是引擎机制(客户端无权改别人角色), 不是脚本没生效。",CY.sub)
UI.Div(p)
UI.Section(p,"🔄 跟随 / 环绕 (动的是你自己)",CY.purple)
UI.Switch(p,"🎩 坐他头上","PC_OnHead",function(on) SYS.PC.OnHead(on) end)
UI.Switch(p,"🌀 绕着他旋转","PC_Orbit",function(on) SYS.PC.Orbit(on) end)
UI.Slider(p,"旋转速度",0.5,12,0.5,function() return SYS.C_.PC_SpinSpeed end,
function(v) SYS.C_.PC_SpinSpeed=v end,"%.1f")
UI.Slider(p,"环绕距离 (格)",2,30,1,function() return SYS.C_.PC_Range end,
function(v) SYS.C_.PC_Range=v end,"%.0f")
UI.Switch(p,"👁 盯着他 (相机锁死在他身上)","PC_Stare",function(on) SYS.PC.Stare(on) end)
UI.Switch(p,"🚶 行走跟随","PC_Follow",function(on) SYS.PC.Follow(on) end)
UI.Div(p)
UI.Section(p,"👥 好友",CY.cyan)
UI.Btn(p,"➕ 添加好友",CY.green,function()
local pl=SYS.PC.Get()
if not pl then SYS.Notify("先在上面选一个玩家",SYS.CY.sub) return end
P(function()
local ok=pcall(function() LP:RequestFriendship(pl) end)
if not ok then ok=pcall(function() pl:RequestFriendship(LP) end) end
SYS.Notify(ok and ("➕ 已向 "..pl.Name.." 发起好友请求")
or "这台执行器/这个客户端不支持发起好友请求",
ok and SYS.CY.green or SYS.CY.yellow)
end)
end)
UI.Btn(p,"➖ 移除好友",CY.red,function()
local pl=SYS.PC.Get()
if not pl then SYS.Notify("先在上面选一个玩家",SYS.CY.sub) return end
P(function()
local ok=pcall(function() LP:RevokeFriendship(pl) end)
SYS.Notify(ok and ("➖ 已解除与 "..pl.Name.." 的好友关系") or "操作失败",
ok and SYS.CY.red or SYS.CY.yellow)
end)
end)
UI.Tip(p,"好友操作走 Roblox 官方 API(RequestFriendship / RevokeFriendship), 部分执行器会屏蔽这两个函数。",CY.sub)
SYS.SpawnLoop(function()
while not SYS.Unloaded do
task.wait(0.5)
if SYS.PCRender then P(SYS.PCRender) end
end
end)
end
local function GetGuiParent()
return PG
end
function SYS.SafeParentGui(gui)
if not gui then return "nil" end
P(function() if protect_gui then protect_gui(gui) end end)
P(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
P(function() gui.Parent=SYS.PG end)
if gui.Parent then return "PlayerGui" end
local ok2=pcall(function() gui.Parent=game:GetService("CoreGui") end)
if ok2 and gui.Parent then return "CoreGui(兜底)" end
return "失败"
end
function SYS.TryAntiKick()
if SYS.KickHooked then return "已启用" end
if type(hookfunction)~="function" then return "不可用(执行器没提供 hookfunction)" end
local ok=pcall(function()
local lp=SYS.LP
if not lp then return end
hookfunction(lp.Kick,function() return nil end)
SYS.KickHooked=true
end)
if ok and SYS.KickHooked then
print("[CheatMenu] 防踢已启用(只拦本地 Kick; 服务端踢人拦不住)")
return "已启用"
end
return "不可用"
end
local function CreateMenuLegacy()
print("[CheatMenu] CreateMenu 开始")
if SYS.ScreenGui then pcall(function() SYS.ScreenGui:Destroy() end) SYS.ScreenGui=nil end
local sg=Instance.new("ScreenGui")
sg.Name=SYS.N.Gui sg.ResetOnSpawn=false sg.IgnoreGuiInset=true
P(function() sg.ScreenInsets=Enum.ScreenInsets.None end)
P(function()
local roots={SYS.PG,SYS.CoreGui}
if gethui then local h=gethui() if h then roots[#roots+1]=h end end
local killed=0
for i=1,#roots do
local r=roots[i]
if r and type(r.GetChildren)=="function" then
for _,c in ipairs(r:GetChildren()) do
if c~=sg and c.Name=="CheatMenuV52" then c:Destroy() killed=killed+1 end
end
end
end
if killed>0 then print(("[CheatMenu] 清掉了 %d 个残留的旧菜单"):format(killed)) end
end)
sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling sg.DisplayOrder=999
local okP=pcall(function() sg.Parent=GetGuiParent() end)
if not okP then sg.Parent=PG end
SYS.ScreenGui=sg
print("[CheatMenu] ScreenGui 父级:",sg.Parent and sg.Parent:GetFullName() or "nil")
local Pages=SYS.Pages
local W,H=830,664
local main=Instance.new("Frame")
main.Size=UDim2.new(0,W,0,H)
main.AnchorPoint=Vector2.new(0.5,0.5)
main.Position=UDim2.new(0.5,0,0.5,0)
main.BackgroundColor3=CY.bg main.BackgroundTransparency=0.06
main.BorderSizePixel=0 main.ClipsDescendants=true main.Parent=sg
UI.Round(main,16)
UI.Grad(main,CY.bg2,CY.bg,90)
UI.Stroke(main,CY.accent,1,0.72)
local function vpSize()
local cam=WS.CurrentCamera
local vp=cam and cam.ViewportSize or nil
if not vp or vp.X<10 or vp.Y<10 then return nil end
return vp
end
local function centerOf(sc,vp)
local px,py=main.Position.X,main.Position.Y
return vp.X*(px.Scale or 0.5)+sc*(px.Offset or 0),
vp.Y*(py.Scale or 0.5)+sc*(py.Offset or 0)
end
local function menuSizeOf(sc,vp)
local sz=main.Size
local w=(tonumber(sz.X.Offset) or W)+(tonumber(sz.X.Scale) or 0)*vp.X
local h=(tonumber(sz.Y.Offset) or H)+(tonumber(sz.Y.Scale) or 0)*vp.Y
if w<10 then w=W end
if h<10 then h=H end
return w*sc,h*sc
end
local function clampCenter(cx,cy,sc,vp)
vp=vp or vpSize() if not vp then return cx,cy end
local mw,mh=menuSizeOf(sc,vp)
local MINV=80
local TOPKEEP=math.min(mh,54)
local minX=MINV-mw*0.5
local maxX=vp.X-MINV+mw*0.5
local minY=mh*0.5
local maxY=vp.Y-TOPKEEP+mh*0.5
if maxX<minX then minX,maxX=vp.X*0.5,vp.X*0.5 end
if maxY<minY then minY,maxY=vp.Y*0.5,vp.Y*0.5 end
return math.clamp(cx,minX,maxX), math.clamp(cy,minY,maxY)
end
function SYS.ClampMenuPos()
P(function()
if SYS.TouchUI~=true then return end
local vp=vpSize() if not vp then return end
local sc=tonumber(SYS.LastUIScale) or 1
if sc<=0 then sc=1 end
local cx,cy=centerOf(sc,vp)
local nx,ny=clampCenter(cx,cy,sc,vp)
if math.abs(nx-cx)<0.5 and math.abs(ny-cy)<0.5 then return end
main.AnchorPoint=Vector2.new(0.5,0.5)
main.Position=UDim2.new(0.5,(nx-vp.X*0.5)/sc,0.5,(ny-vp.Y*0.5)/sc)
end)
end
local accentBar=Instance.new("Frame")
accentBar.Size=UDim2.new(1,0,0,4) accentBar.BackgroundColor3=Color3.new(1,1,1)
accentBar.BorderSizePixel=0 accentBar.ZIndex=100 accentBar.Parent=main
UI.NeonGrad(accentBar)
local DEV={touch=false,anyTouch=false,vds="Medium",small=false}
pcall(function()
DEV.anyTouch=UIS.TouchEnabled==true
DEV.touch=(UIS.TouchEnabled==true) and (UIS.MouseEnabled~=true)
local ok,v=pcall(function() return UIS.ViewportDisplaySize end)
if ok and v~=nil then DEV.vds=(tostring(v):gsub("Enum.ViewportDisplaySize.","")) end
DEV.small=(DEV.vds=="Small") or DEV.touch
end)
print(("[CheatMenu] 设备: 触屏=%s 纯触屏=%s 视口档=%s 小屏适配=%s")
:format(tostring(DEV.anyTouch),tostring(DEV.touch),DEV.vds,tostring(DEV.small)))
SYS.DEV=DEV
SYS.TouchUI=(DEV.anyTouch==true)
print(("[CheatMenu] 触摸端UI适配=%s"):format(tostring(SYS.TouchUI)))
local scale=Instance.new("UIScale") scale.Parent=main
local function ApplyScale()
P(function()
local cam=WS.CurrentCamera
local vp=cam and cam.ViewportSize or Vector2.new(1280,720)
if vp.X<10 or vp.Y<10 then vp=Vector2.new(1280,720) end
local pad=DEV.small and 28 or 40
pcall(function()
local gs=game:GetService("GuiService")
if gs then
local ok1,i1,i2=pcall(function() return gs:GetGuiInset() end)
if ok1 and i1 then pad=pad+(i1.Y or 0)+(i2 and i2.Y or 0) end
end
end)
local fit=math.min((vp.X-pad*2)/W,(vp.Y-pad*2)/H)
local hi=1.0
if DEV.touch then hi=1.75
elseif DEV.small then hi=1.35 end
local lo=0.30
local man=tonumber(SYS.C_.UIScaleManual) or 0
local sc
if man>0 then
sc=math.clamp(man,0.30,3.0)
else
sc=math.min(fit,hi)
if sc<lo then sc=lo end
end
scale.Scale=sc
SYS.LastUIScale=sc
SYS.LastUIScaleFit=fit
SYS.LastUIScaleAuto=math.min(fit,hi)
if SYS.TouchUI==true and SYS.ClampMenuPos then SYS.ClampMenuPos() end
end)
end
SYS.ApplyUIScale=ApplyScale
ApplyScale()
local cam0=WS.CurrentCamera
if cam0 then
local okS,sig=P(function() return cam0:GetPropertyChangedSignal("ViewportSize") end)
if okS and sig and type(sig.Connect)=="function" then
local okC,conn=P(function() return sig:Connect(ApplyScale) end)
if okC and conn then T(conn) end
end
end
if SYS.TouchUI==true and SYS.C_.MenuPosSaved==true then
P(function()
if SYS.C_.MenuPosSaved~=true then return end
local vp=vpSize() if not vp then return end
local sc=tonumber(SYS.LastUIScale) or 1
if sc<=0 then sc=1 end
local cx=(tonumber(SYS.C_.MenuPosX) or 0.5)*vp.X
local cy=(tonumber(SYS.C_.MenuPosY) or 0.5)*vp.Y
local nx,ny=clampCenter(cx,cy,sc,vp)
main.AnchorPoint=Vector2.new(0.5,0.5)
main.Position=UDim2.new(0.5,(nx-vp.X*0.5)/sc,0.5,(ny-vp.Y*0.5)/sc)
SYS._UserMoved=true
if SYS.ClampMenuPos then SYS.ClampMenuPos() end
end)
end
local top=Instance.new("TextButton")
top.Size=UDim2.new(1,0,0,62) top.BackgroundTransparency=1
top.Text="" top.AutoButtonColor=false top.Active=true top.Parent=main
local logo=Instance.new("TextLabel")
logo.Size=UDim2.new(0,220,1,0) logo.Position=UDim2.new(0,24,0,0)
logo.BackgroundTransparency=1 logo.Text="CHEATMENU"
logo.TextColor3=CY.text logo.Font=Enum.Font.GothamBold logo.TextSize=19
logo.TextXAlignment=Enum.TextXAlignment.Left logo.Parent=top
local logoS=Instance.new("UIStroke")
logoS.Color=CY.accent logoS.Thickness=1 logoS.Transparency=0.35
logoS.ApplyStrokeMode=Enum.ApplyStrokeMode.Border logoS.Parent=logo
local verTag=Instance.new("TextLabel")
verTag.Size=UDim2.new(0,90,0,18) verTag.Position=UDim2.new(0,168,0.5,-9)
verTag.BackgroundColor3=CY.accent verTag.BackgroundTransparency=0.75
local _bv=tostring(SYS.BuildVer or "?")
local _short
if _bv:match("^%d+%.%d+$") then _short="v".._bv
elseif _bv:sub(1,6)=="local-" then _short="本 ".._bv:sub(-4)
else _short="#".._bv:sub(1,6) end
verTag.Text="BATTLE · ".._short
verTag.TextColor3=CY.accent
verTag.Font=Enum.Font.GothamBold verTag.TextSize=10 verTag.Parent=top
UI.Round(verTag,9)
local statBox=Instance.new("Frame")
statBox.Size=UDim2.new(0,330,0,34) statBox.Position=UDim2.new(1,-420,0.5,-17)
statBox.BackgroundColor3=CY.panel statBox.BackgroundTransparency=0.35
statBox.BorderSizePixel=0 statBox.Parent=top
UI.Round(statBox,10) UI.Stroke(statBox,CY.line,1,0.8)
local FPSL=Instance.new("TextLabel")
FPSL.Size=UDim2.new(1/3,0,1,0) FPSL.BackgroundTransparency=1
FPSL.Text="FPS --" FPSL.TextColor3=CY.text
FPSL.Font=Enum.Font.Code FPSL.TextSize=13 FPSL.Parent=statBox
local TimeL=Instance.new("TextLabel")
TimeL.Size=UDim2.new(1/3,0,1,0) TimeL.Position=UDim2.new(1/3,0,0,0)
TimeL.BackgroundTransparency=1 TimeL.Text="--:--"
TimeL.TextColor3=CY.text TimeL.Font=Enum.Font.Code
TimeL.TextSize=13 TimeL.Parent=statBox
local StatusL=Instance.new("TextLabel")
StatusL.Size=UDim2.new(1/3,0,1,0) StatusL.Position=UDim2.new(2/3,0,0,0)
StatusL.BackgroundTransparency=1 StatusL.Text="Ping --"
StatusL.TextColor3=CY.text StatusL.Font=Enum.Font.Code
StatusL.TextSize=13 StatusL.Parent=statBox
SYS.FPSL=FPSL SYS.TimeL=TimeL SYS.StatusL=StatusL
local closeBtn=Instance.new("TextButton")
closeBtn.Size=UDim2.new(0,34,0,34) closeBtn.Position=UDim2.new(1,-48,0.5,-17)
closeBtn.BackgroundColor3=CY.panel closeBtn.BackgroundTransparency=0.3
closeBtn.TextColor3=CY.sub closeBtn.Text="✕"
closeBtn.Font=Enum.Font.GothamBold closeBtn.TextSize=16
closeBtn.AutoButtonColor=false closeBtn.BorderSizePixel=0 closeBtn.Parent=top
UI.Round(closeBtn,10)
UI.Stroke(closeBtn,CY.red,1,0.72)
T(closeBtn.MouseEnter:Connect(function()
UI.Tween(closeBtn,0.12,{BackgroundColor3=CY.red,BackgroundTransparency=0.45})
UI.Tween(closeBtn,0.12,{TextColor3=Color3.new(1,1,1)})
end))
T(closeBtn.MouseLeave:Connect(function()
UI.Tween(closeBtn,0.12,{BackgroundColor3=CY.panel,BackgroundTransparency=0.3})
UI.Tween(closeBtn,0.12,{TextColor3=CY.sub})
end))
local side=Instance.new("Frame")
side.Size=UDim2.new(0,154,1,-78) side.Position=UDim2.new(0,14,0,68)
side.BackgroundColor3=CY.panel side.BackgroundTransparency=0.32
side.BorderSizePixel=0 side.Parent=main
UI.Round(side,12) UI.Stroke(side,CY.line,1,0.82)
UI.Grad(side,CY.card2,CY.panel,135)
local ind=Instance.new("Frame")
ind.Size=UDim2.new(0,3,0,22) ind.Position=UDim2.new(0,0,0,15)
ind.BackgroundColor3=CY.accent ind.BorderSizePixel=0 ind.Visible=false
ind.Parent=side UI.Round(ind,2)
UI.NeonGrad(ind)
SYS.SearchText=""
SYS.ActiveTabName=nil
local searchBox=Instance.new("TextBox")
searchBox.Size=UDim2.new(1,-16,0,32) searchBox.Position=UDim2.new(0,8,1,-40)
searchBox.BackgroundColor3=CY.card searchBox.BackgroundTransparency=0.15
searchBox.TextColor3=CY.text searchBox.PlaceholderColor3=CY.sub
searchBox.PlaceholderText="搜索本页..."
searchBox.Text="" searchBox.Font=Enum.Font.GothamMedium searchBox.TextSize=12
searchBox.ClearTextOnFocus=false searchBox.BorderSizePixel=0 searchBox.Parent=side
UI.Round(searchBox,8) UI.Stroke(searchBox,CY.line,1,0.7)
T(searchBox:GetPropertyChangedSignal("Text"):Connect(function()
SYS.SearchText=searchBox.Text
P(SYS.ApplySearch,searchBox.Text)
end))
local content=Instance.new("Frame")
content.Size=UDim2.new(1,-196,1,-78) content.Position=UDim2.new(0,182,0,68)
content.BackgroundTransparency=1 content.Parent=main
local tabList={}
local tabBtns={}
local built={}
local function ensurePage(name)
if built[name] then return end
built[name]=true
local pg=Pages[name]
if not pg then return end
local buildFn=UI.Pages[name]
if type(buildFn)=="function" then
local ok,err=pcall(buildFn,pg)
if not ok then
built[name]=false
warn(("[CheatMenu] 页面 %s 构建失败(切走再切回会重试): %s"):format(name,tostring(err)))
else
print("[CheatMenu] 页面 "..name.." OK")
end
end
end
SYS.EnsurePage=ensurePage
local function ShowTab(name)
if SYS.CloseActiveDropdown then pcall(SYS.CloseActiveDropdown) end
ensurePage(name)
SYS.ActiveTabName=name
for n,pg in pairs(Pages) do pg.Visible=(n==name) end
local idx=1
for i,t in ipairs(tabList) do
local act=(t.name==name)
if act then idx=i end
UI.Tween(t.btn,0.16,{
BackgroundColor3=act and CY.card2 or CY.panel,
BackgroundTransparency=act and 0.05 or 0.6})
UI.Tween(t.icon,0.16,{TextColor3=act and CY.accent or CY.sub})
UI.Tween(t.text,0.16,{TextColor3=act and CY.text or CY.sub})
end
ind.Visible=true
UI.Tween(ind,0.18,{Position=UDim2.new(0,0,0,15+(idx-1)*46)})
if SYS.SearchText and SYS.SearchText~="" then P(SYS.ApplySearch,SYS.SearchText) end
end
SYS.ShowTab=ShowTab
local function nodeText(node)
local parts={}
local function walk(o)
local cls=o.ClassName
if cls=="TextLabel" or cls=="TextButton" or cls=="TextBox" then
parts[#parts+1]=o.Text or ""
end
for _,c in ipairs(o:GetChildren()) do walk(c) end
end
walk(node)
return table.concat(parts," "):lower()
end
function SYS.ApplySearch(q)
local name=SYS.ActiveTabName
local pg=name and Pages[name]
if not pg then return end
q=tostring(q or ""):lower():gsub("^%s+",""):gsub("%s+$","")
for _,c in ipairs(pg:GetChildren()) do
if c:IsA("GuiObject") then
if c:GetAttribute("_sv")==nil then pcall(function() c:SetAttribute("_sv",c.Visible) end) end
local orig=c:GetAttribute("_sv")
if q=="" then
c.Visible=(orig~=false)
else
c.Visible=(nodeText(c):find(q,1,true)~=nil) and (orig~=false)
end
end
end
end
for i,def in ipairs(UI.Defs) do
local b=Instance.new("TextButton")
b.Size=UDim2.new(1,-16,0,40) b.Position=UDim2.new(0,8,0,7+(i-1)*46)
b.BackgroundColor3=CY.panel b.BackgroundTransparency=0.6
b.Text="" b.AutoButtonColor=false b.BorderSizePixel=0 b.Parent=side
UI.Round(b,9)
local icon=Instance.new("TextLabel")
icon.Size=UDim2.new(0,26,1,0) icon.Position=UDim2.new(0,9,0,0)
icon.BackgroundTransparency=1 icon.Text=def.icon
icon.TextColor3=CY.sub icon.Font=Enum.Font.GothamBold
icon.TextSize=15 icon.Parent=b
local text=Instance.new("TextLabel")
text.Size=UDim2.new(1,-44,1,0) text.Position=UDim2.new(0,36,0,0)
text.BackgroundTransparency=1 text.Text=def.name
text.TextColor3=CY.sub text.Font=Enum.Font.GothamMedium
text.TextSize=14 text.TextXAlignment=Enum.TextXAlignment.Left text.Parent=b
tabBtns[def.name]=b
tabList[#tabList+1]={name=def.name,btn=b,icon=icon,text=text}
T(b.MouseButton1Click:Connect(function() ShowTab(def.name) end))
T(b.MouseEnter:Connect(function()
if Pages[def.name] and Pages[def.name].Visible then return end
UI.Tween(b,0.12,{BackgroundTransparency=0.4})
end))
T(b.MouseLeave:Connect(function()
if Pages[def.name] and Pages[def.name].Visible then return end
UI.Tween(b,0.12,{BackgroundTransparency=0.6})
end))
local pg=Instance.new("ScrollingFrame")
pg.Size=UDim2.fromScale(1,1) pg.BackgroundTransparency=1
pg.BorderSizePixel=0 pg.ScrollBarThickness=3 pg.ScrollBarImageColor3=CY.accent
pg.CanvasSize=UDim2.new(0,0,0,0) pg.AutomaticCanvasSize=Enum.AutomaticSize.Y
pg.Visible=false pg.Parent=content
local lay=Instance.new("UIListLayout")
lay.Padding=UDim.new(0,7) lay.SortOrder=Enum.SortOrder.LayoutOrder
lay.HorizontalAlignment=Enum.HorizontalAlignment.Center lay.Parent=pg
local pad=Instance.new("UIPadding")
pad.PaddingTop=UDim.new(0,4) pad.PaddingBottom=UDim.new(0,16)
pad.PaddingLeft=UDim.new(0,4) pad.PaddingRight=UDim.new(0,10) pad.Parent=pg
Pages[def.name]=pg
end
local foot=Instance.new("TextLabel")
foot.Size=UDim2.new(1,-40,0,16) foot.Position=UDim2.new(0,24,1,-22)
foot.BackgroundTransparency=1
foot.Text="G/右Shift 开关菜单    ·    V 切换指定目标"
foot.TextColor3=CY.sub foot.Font=Enum.Font.GothamMedium foot.TextSize=11
foot.TextXAlignment=Enum.TextXAlignment.Left foot.Parent=main
local drg,dS,fS=false,nil,nil
local rsz,rD0,rSc=false,nil,nil
local TCH=(SYS.TouchUI==true)
local function isGrab(i)
return i.UserInputType==Enum.UserInputType.MouseButton1
or i.UserInputType==Enum.UserInputType.Touch
end
local function isMove(i)
return i.UserInputType==Enum.UserInputType.MouseMovement
or i.UserInputType==Enum.UserInputType.Touch
end
local function sameGrab(i)
local g=SYS._dragInput
if not g or not i then return false end
if i.UserInputType==Enum.UserInputType.Touch then return i==g end
if i.UserInputType==Enum.UserInputType.MouseMovement
or i.UserInputType==Enum.UserInputType.MouseButton1 then
return g.UserInputType==Enum.UserInputType.MouseButton1
end
return false
end
local function curScale()
local ok,v=pcall(function() return scale.Scale end)
local n=(ok and tonumber(v)) or 1
if not n or n<=0 then n=1 end
return n
end
local function inRect(pos, obj)
if not obj then return false end
local ok,ap,asz=pcall(function() return obj.AbsolutePosition, obj.AbsoluteSize end)
if not ok or not ap or not asz then return false end
return pos.X>=ap.X and pos.X<=(ap.X+asz.X) and pos.Y>=ap.Y and pos.Y<=(ap.Y+asz.Y)
end
local function onTitleBtn(pos)
for _,b in ipairs(SYS.CM_TitleBtns or {}) do
if inRect(pos,b) then return true end
end
return false
end
local GPAD=TCH and 14 or 0
local function inTitle(pos)
if inRect(pos, top) then return true end
if GPAD<=0 then return false end
local ok,ap,asz=pcall(function() return top.AbsolutePosition, top.AbsoluteSize end)
if not ok or not ap or not asz then return false end
return pos.X>=(ap.X-GPAD) and pos.X<=(ap.X+asz.X+GPAD)
and pos.Y>=(ap.Y-GPAD) and pos.Y<=(ap.Y+asz.Y+GPAD)
end
T(UIS.InputBegan:Connect(function(input,gp)
if not input or not input.Position then return end
P(function()
if not SYS.MenuOpen then return end
if SYS._uiGesture and (drg or rsz) then return end
SYS._uiGesture=nil
if not isGrab(input) then return end
local pos=input.Position
if not inTitle(pos) then return end
if onTitleBtn(pos) then return end
drg=true dS=pos fS=main.Position
SYS._dragInput=input
SYS._uiGesture="move"
SYS._UserMoved=true
end)
end))
T(UIS.InputChanged:Connect(function(input)
if not input then return end
if rsz and SYS._rzInput==input and input.Position then
P(function()
local vp=vpSize() if not vp then return end
local sc0=curScale()
local cx,cy=centerOf(sc0,vp)
local d=math.max(24,(input.Position-Vector2.new(cx,cy)).Magnitude)
local sc=math.clamp(rSc*(d/rD0),0.30,3.0)
SYS.C_.UIScaleManual=math.floor(sc*100+0.5)/100
if SYS.ApplyUIScale then P(SYS.ApplyUIScale) end
end)
return
end
if drg and sameGrab(input) and input.Position then
local d=input.Position-dS
local sc=curScale()
main.AnchorPoint=Vector2.new(0.5,0.5)
main.Position=UDim2.new(fS.X.Scale,fS.X.Offset+d.X/sc,fS.Y.Scale,fS.Y.Offset+d.Y/sc)
if TCH and SYS.ClampMenuPos then SYS.ClampMenuPos() end
end
end))
T(UIS.InputEnded:Connect(function(input)
if not input then return end
if rsz and SYS._rzInput==input then
rsz=false SYS._rzInput=nil SYS._uiGesture=nil
SYS.C_.UIScaleManual=math.floor(curScale()*100+0.5)/100
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
if SYS.SaveMenuState then P(SYS.SaveMenuState) end
return
end
if drg and sameGrab(input) then
drg=false SYS._dragInput=nil SYS._uiGesture=nil
if SYS.SaveMenuState then P(SYS.SaveMenuState) end
end
end))
function SYS.SaveMenuState()
P(function()
if SYS.TouchUI~=true then return end
local vp=vpSize() if not vp then return end
local sc=curScale()
local cx,cy=centerOf(sc,vp)
local nx,ny=clampCenter(cx,cy,sc,vp)
SYS.C_.MenuPosX=math.clamp(nx/vp.X,0,1)
SYS.C_.MenuPosY=math.clamp(ny/vp.Y,0,1)
SYS.C_.MenuPosSaved=true
QueueSave()
end)
end
if TCH then
local grip=Instance.new("TextButton")
grip.Size=UDim2.new(0,38,0,38) grip.Position=UDim2.new(1,-44,1,-78)
grip.BackgroundColor3=CY.panel grip.BackgroundTransparency=0.35
grip.Text="◢" grip.TextColor3=CY.accent grip.TextSize=19
grip.Font=Enum.Font.GothamBold grip.BorderSizePixel=0
grip.AutoButtonColor=false grip.Parent=main
UI.Round(grip,12) UI.Stroke(grip,CY.accent,1,0.55)
SYS.CM_Grip=grip
T(grip.InputBegan:Connect(function(input)
if not input or not input.Position then return end
P(function()
if not SYS.MenuOpen then return end
if drg or rsz then return end
if not isGrab(input) then return end
local vp=vpSize() if not vp then return end
local sc0=curScale()
local cx,cy=centerOf(sc0,vp)
rsz=true rSc=sc0
rD0=math.max(24,(input.Position-Vector2.new(cx,cy)).Magnitude)
SYS._rzInput=input SYS._uiGesture="resize"
end)
end))
end
local collapseBtn=Instance.new("TextButton")
collapseBtn.Size=UDim2.new(0,34,0,34) collapseBtn.Position=UDim2.new(1,-96,0.5,-17)
collapseBtn.BackgroundColor3=CY.panel collapseBtn.BackgroundTransparency=0.25
collapseBtn.Text="▬" collapseBtn.TextSize=18 collapseBtn.TextColor3=CY.text
collapseBtn.Font=Enum.Font.GothamBold collapseBtn.BorderSizePixel=0
collapseBtn.Parent=top
P(function() local r=Instance.new("UICorner") r.CornerRadius=UDim.new(1,0) r.Parent=collapseBtn end)
function SYS.CenterMenu()
SYS._UserMoved=false
SYS.C_.MenuPosSaved=false
main.AnchorPoint=Vector2.new(0.5,0.5)
main.Position=UDim2.new(0.5,0,0.5,0)
P(ApplyScale)
if SYS.TouchUI==true then QueueSave() end
end
SYS.CM_TitleBtns={closeBtn,collapseBtn}
SYS.MenuMain=main
function SYS.DiagUI()
local L={}
local function A(f,...) L[#L+1]="  "..(select("#",...)>0 and f:format(...) or f) end
A("=========== CheatMenu UI 诊断 ===========")
A("版本=%s  时间=%.0f",tostring(SYS.BuildVer),os.time())
local cam=WS.CurrentCamera
local vp=cam and cam.ViewportSize or Vector2.new(0,0)
A("视口=%dx%d  触屏=%s",vp.X,vp.Y,tostring(UIS.TouchEnabled))
A("触摸端UI适配=%s  当前缩放=%.3f(自动值 %.3f)  手动缩放=%s",
tostring(SYS.TouchUI),tonumber(SYS.LastUIScale) or -1,
tonumber(SYS.LastUIScaleAuto) or -1,tostring(SYS.C_.UIScaleManual))
A("位置记忆=%s  比例=(%s,%s)  缩放把手=%s",
tostring(SYS.C_.MenuPosSaved),tostring(SYS.C_.MenuPosX),tostring(SYS.C_.MenuPosY),
tostring(SYS.CM_Grip~=nil))
A("菜单开着=%s  用户拖过=%s",tostring(SYS.MenuOpen),tostring(SYS._UserMoved))
A("防护: AntiAC=%s AntiAdmin=%s AntiTP=%s HideGui=%s  已拦截=%s",
tostring(SYS.T_.Prot_AntiAC),tostring(SYS.T_.Prot_AntiAdmin),
tostring(SYS.T_.Prot_AntiTP),tostring(SYS.T_.Prot_HideGui),
tostring(SYS.Prot and SYS.Prot.Blocked or 0))
local susName="?"
if SYS.Prot and SYS.Prot.fpBad then
susName=(SYS.Prot.fpBad(SYS.ScreenGui and SYS.ScreenGui.Name) and "有可疑词" or "无")
end
A("移速护栏=%s 上限=%.0f  屏幕GUI名自检=%s",
tostring(SYS.T_.Prot_SpeedCap),tonumber(SYS.C_.SpeedCap) or -1,susName)
A("视线射线: FindPartOnRay 4参=%s (nil=还没探测过)",tostring(SYS.RayFull))
local gs=game:GetService("GuiService")
if gs and gs.GetGuiInset then
P(function()
local t,b=gs:GetGuiInset()
A("GuiInset: top=%d bottom=%d",t and t.Y or -1,(b and b.Y) or -1)
end)
else
A("GuiInset: (该环境没有 GuiService:GetGuiInset)")
end
local s=SYS.ScreenGui
if not s then A("!! ScreenGui=nil") else
P(function() A("ScreenGui: 父=%s Enabled=%s IgnoreGuiInset=%s ScreenInsets=%s",
tostring(s.Parent and s.Parent:GetFullName() or "nil"),tostring(s.Enabled),
tostring(s.IgnoreGuiInset),tostring(s.ScreenInsets)) end)
P(function() A("ScreenGui: 尺寸=%dx%d 位置=%d,%d",s.AbsoluteSize.X,s.AbsoluteSize.Y,
s.AbsolutePosition.X,s.AbsolutePosition.Y) end)
end
local m=SYS.MenuMain
if not m then A("!! main=nil") else
P(function()
A("main: 位置=%d,%d 尺寸=%dx%d 锚点=%.2f,%.2f 可见=%s",
m.AbsolutePosition.X,m.AbsolutePosition.Y,m.AbsoluteSize.X,m.AbsoluteSize.Y,
m.AnchorPoint.X,m.AnchorPoint.Y,tostring(m.Visible))
A("居中校验: 期望=(%d,%d) 实际=(%d,%d)  [两者一致=居中正确]",
(vp.X-m.AbsoluteSize.X)*0.5,(vp.Y-m.AbsoluteSize.Y)*0.5,
m.AbsolutePosition.X,m.AbsolutePosition.Y)
end)
end
P(function() A("UIScale=%.3f (挂在 %s 上)",scale.Scale,tostring(scale.Parent and scale.Parent.Name or "nil")) end)
P(function()
if not top then return end
A("拖动把手: 类=%s Active=%s 可见=%s 位置=%d,%d 尺寸=%dx%d",
top.ClassName,tostring(top.Active),tostring(top.Visible),
top.AbsolutePosition.X,top.AbsolutePosition.Y,top.AbsoluteSize.X,top.AbsoluteSize.Y)
local cx=top.AbsolutePosition.X+top.AbsoluteSize.X*0.5
local cy=top.AbsolutePosition.Y+top.AbsoluteSize.Y*0.5
local names={}
if not PG.GetGuiObjectsAtPosition then
A("命中测试: (该环境没有 PlayerGui:GetGuiObjectsAtPosition, 跳过)")
else
P(function()
local objs=PG:GetGuiObjectsAtPosition(cx,cy)
if objs then
for i=1,math.min(#objs,6) do
names[#names+1]=("%s(%s)"):format(tostring(objs[i].Name),tostring(objs[i].ClassName))
end
end
end)
A("命中测试(%d,%d) 最上层: %s",cx,cy,#names>0 and table.concat(names," > ") or "(该点没有任何 GUI)")
end
end)
local txt=table.concat(L,"\n")
print("[CheatMenu]"..txt)
local ok=pcall(function() writefile(SYS.N.Diag,txt) end)
SYS.Notify(ok and ("🩺 诊断已输出: 控制台 + "..SYS.N.Diag) or "🩺 诊断已输出到控制台(该执行器不能写文件)",SYS.CY.green)
return txt
end
function SYS.SetMenuCollapsed(v)
SYS.Collapsed=v and true or false
for _,c in ipairs(main:GetChildren()) do
if c~=top and c:IsA("GuiObject") then P(function() c.Visible=not SYS.Collapsed end) end
end
main.Size=UDim2.new(0,W,0,SYS.Collapsed and 62 or H)
collapseBtn.Text=SYS.Collapsed and "▣" or "▬"
ApplyScale()
end
T(collapseBtn.MouseButton1Click:Connect(function() SYS.SetMenuCollapsed(not SYS.Collapsed) end))
T(closeBtn.MouseButton1Click:Connect(function() SYS.ToggleMenu() end))
if not SYS.FloatGui then P(function()
local fg=Instance.new("ScreenGui")
fg.Name=SYS.N.Float P(function() fg.ResetOnSpawn=false end)
P(function() fg.IgnoreGuiInset=true end) P(function() fg.DisplayOrder=999 end)
P(function() if gethui then fg.Parent=gethui() end end)
SYS.SafeParentGui(fg)
local fb=Instance.new("TextButton")
local fsz=DEV.small and 52 or 58
fb.Size=UDim2.new(0,fsz,0,fsz) fb.Position=UDim2.new(1,-(fsz+18),0,96)
fb.BackgroundColor3=CY.accent fb.BackgroundTransparency=0.12
fb.Text="☰" fb.TextSize=28 fb.TextColor3=CY.text
fb.Font=Enum.Font.GothamBold fb.BorderSizePixel=0 fb.AutoButtonColor=true
fb.Parent=fg
P(function() local r=Instance.new("UICorner") r.CornerRadius=UDim.new(1,0) r.Parent=fb end)
SYS.FloatGui=fg
local fd,fs,fp,moved=false,nil,nil,false
T(fb.InputBegan:Connect(function(i)
if isGrab(i) then fd=true fs=i.Position fp=fb.Position moved=false end
end))
T(UIS.InputChanged:Connect(function(i)
if fd and isMove(i) then
local d=i.Position-fs
if d.Magnitude>8 then moved=true end
fb.Position=UDim2.new(fp.X.Scale,fp.X.Offset+d.X,fp.Y.Scale,fp.Y.Offset+d.Y)
end
end))
T(UIS.InputEnded:Connect(function(i)
if isGrab(i) then
if fd and not moved then P(SYS.ToggleMenu) end
fd=false
end
end))
end) end
ShowTab("战斗")
P(function()
local where=SYS.SafeParentGui(sg)
print("[CheatMenu] 菜单挂载: "..tostring(where).." · 防踢: "..tostring(SYS.TryAntiKick()))
end)
sg.Enabled=true SYS.MenuOpen=true
SYS.MenuPrevMouseBehav=UIS.MouseBehavior
SYS.MenuPrevMouseIcon=UIS.MouseIconEnabled
if SYS.T_.MenuMouse~=false then
UIS.MouseBehavior=Enum.MouseBehavior.Default
UIS.MouseIconEnabled=true
end
if not (SYS.MenuGuard and SYS.MenuGuard.Connected) then
if SYS.MenuGuard then P(function() SYS.MenuGuard:Disconnect() end) end
local okG,gconn=P(function() return RS.RenderStepped:Connect(function()
if SYS.Unloaded or not SYS.MenuOpen then return end
if SYS.T_.MenuMouse==false then return end
P(function()
if UIS.MouseBehavior~=Enum.MouseBehavior.Default then UIS.MouseBehavior=Enum.MouseBehavior.Default end
if not UIS.MouseIconEnabled then UIS.MouseIconEnabled=true end
end)
end) end)
if okG and gconn then SYS.MenuGuard=T(gconn) end
end
local tw0=main.Size
main.Size=UDim2.new(0,W*0.93,0,H*0.93)
main.Position=UDim2.new(0.5,0,0.5,0)
main.BackgroundTransparency=0.5
P(function()
TweenService:Create(main,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
{Size=tw0,BackgroundTransparency=0.06}):Play()
end)
print("[CheatMenu] ✅ UI 创建完成")
end
local function CreateMenu()
return CreateMenuLegacy()
end
SYS.CreateMenu=CreateMenu
function SYS.ToggleMenu()
if SYS.Unloaded then return end
if not SYS.ScreenGui or not SYS.ScreenGui.Parent then
local ok,err=pcall(CreateMenu)
if not ok then warn("[CheatMenu] CreateMenu 失败:",tostring(err)) end
return
end
SYS.MenuOpen=not (SYS.ScreenGui.Enabled==true)
SYS.ScreenGui.Enabled=SYS.MenuOpen
if SYS.MenuOpen then
SYS.MenuPrevMouseBehav=UIS.MouseBehavior
SYS.MenuPrevMouseIcon=UIS.MouseIconEnabled
UIS.MouseBehavior=Enum.MouseBehavior.Default
UIS.MouseIconEnabled=true
if not (SYS.MenuGuard and SYS.MenuGuard.Connected) then
if SYS.MenuGuard then P(function() SYS.MenuGuard:Disconnect() end) end
local okG,gconn=P(function() return RS.RenderStepped:Connect(function()
if SYS.Unloaded or not SYS.MenuOpen then return end
P(function()
if UIS.MouseBehavior~=Enum.MouseBehavior.Default then UIS.MouseBehavior=Enum.MouseBehavior.Default end
if not UIS.MouseIconEnabled then UIS.MouseIconEnabled=true end
end)
end) end)
if okG and gconn then SYS.MenuGuard=T(gconn) end
end
else
if SYS.MenuGuard then P(function() SYS.MenuGuard:Disconnect() end) SYS.MenuGuard=nil end
if SYS.FreeCamActive then
UIS.MouseBehavior=Enum.MouseBehavior.LockCenter
UIS.MouseIconEnabled=false
else
SYS.RestoreMouse()
end
SYS.MenuPrevMouseBehav=nil SYS.MenuPrevMouseIcon=nil
SYS.FCPrevBehav=nil SYS.FCPrevIcon=nil
end
end
local IGNORE_LIST="A_Timer|ActualPower|All|Amount|AreaName|B_Timer|BossName|BrainrotChance|BrainrotName|Brainrots|C_Timer|Cancel|Cash|Chance|ChanceLabel|Charging|ClaimButton|ClickRegion|Close|CoinLabel|Console|ConsoleModifierLabel|Count|CountLabel|CP/s|CPS|CPSLabel|CurrencyLabel|Day|DebounceFrame|Description|Discount|DiscountedPrice|DiscountLabel|DisplayName|EventTitle|Exp|Favorite|Favorites|Field|FreeSpinLabel|FriendsLabel|Gift|GiftButton|GiftingTo|GuideLabel|Header|Header1|Header2|Header3|HereText|IconLabel|Info|InfoLabel|InfoText|ItemName|KickPower|Label|LabelContent|Level|LevelLabel|Limited|LockedText|Lucky Blocks|Lvl|Message|Mobile|Mutation|MutationChance|MutationLabel|Name|NameLabel|New|Next|NoPlayers|Now|Odds|One|OP|OreName|Owned|PC|Percentage|Pity|PlayerName|Plus|Plus1|Plus2|Points|PowerLabel|Prevoius|Price|PriceLabel|Progress|ProgressBar|Rarity|RarityLabel|Reached|RebirthLevel|RefreshLabel|RewardLabel|RobuxLabel|S_Timer|SelectedLabel|SlotNum|SpinsLabel|StatusLabel|Stock|StockUpdateLabel|SubHeader|Suggest|SunHeader|TaskLabel|TextButton|TextLabel|Three|Tier|TimeLabel|TimeLeft|Timer|TimerLabel|TItle|Title|TitleDown|TitleLabel|TitleUp|TotalLuckLabel|TradeLimit|Two|Txt|Txt1|Txt2|Txt3|Type|Typed|UnlockedLabel|UnlockLabel|Value|ValueLabel|WeatherName|WeightLabel|WorldName"
Trans.IgnoreObjects={}
for w in IGNORE_LIST:gmatch("[^|]+") do Trans.IgnoreObjects[w]=true end
print("[Trans] 忽略控件表已装载: "..tostring(#IGNORE_LIST).." 字符")
do
local fps,fT=0,os.clock()
T(RS.Heartbeat:Connect(function()
if not SYS.Unloaded then fps+=1 end
end))
SYS.SpawnLoop(function()
while not SYS.Unloaded do
task.wait(0.5)
local now=os.clock()
local el=math.max(0.001,now-fT)
local f=math.floor(fps/el+0.5)
fps=0 fT=now
if SYS.FPSL and SYS.FPSL.Parent then
if SYS.ScreenGui and SYS.ScreenGui.Enabled then SYS.FPSL.Text="FPS "..f
else SYS.FPSL.Text="FPS --" end
end
if SYS.TimeL and SYS.TimeL.Parent then SYS.TimeL.Text=os.date("%H:%M:%S") end
local ping=0
P(function()
local ok,v=pcall(function() return LP:GetNetworkPing() end)
if ok and type(v)=="number" and v>0 then ping=math.floor(v*1000+0.5)
elseif Stats then ping=math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()+0.5) end
end)
if SYS.StatusL and SYS.StatusL.Parent then SYS.StatusL.Text="Ping "..ping end
end
end)
SYS.SpawnLoop(function()
while not SYS.Unloaded do
if SYS.T_.PerfBoost then P(SYS.PerfCullTick) task.wait(0.12) else task.wait(0.5) end
end
end)
TT(task.spawn(function()
while not SYS.Unloaded do
P(SYS.ESPTick)
P(SYS.AutoTPTick)
task.wait(0.15)
end
end))
end
do
local function OnChar(c)
if not c then return end
local h=c:WaitForChild("Humanoid",5) if not h then return end
task.wait(0.3)
if SYS.Unloaded then return end
if SYS.FreeCamActive then SYS.StopFreeCam() end
SYS.Orig.WalkSpeed=h.WalkSpeed
if not SYS.GetSpawnRec() then
local r=c:FindFirstChild("HumanoidRootPart")
if r then SYS.SetDefSpawn(r.Position) SYS.SetSpawnRec(true) end
end
if SYS.T_.GodMode then SYS.SetGod(true) end
if SYS.T_.Speed then SYS.CleanSpeed() SYS.SetLoop("Speed",true,SYS.PhysicsStep,SYS.SpeedTick) end
if SYS.T_.Fly then SYS.CleanFly() SYS.SetLoop("Fly",true,SYS.PhysicsStep,SYS.FlyTick) end
if SYS.T_.Noclip then task.delay(0.5,function() if not SYS.Unloaded then SYS.ApplyNoclip(c,true) end end) end
if SYS.T_.NoCollide then SYS.RefreshNC(true) end
end
T(LP.CharacterAdded:Connect(OnChar))
if LP.Character then OnChar(LP.Character) end
end
do
local function refreshUI()
task.delay(0.3, function()
if SYS.Unloaded then return end
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
end)
end
T(Players.PlayerAdded:Connect(function() refreshUI() end))
T(Players.PlayerRemoving:Connect(function(pl)
if SYS.C_ and SYS.C_.CB_TargetName and (SYS.C_.CB_TargetName==pl.Name or SYS.C_.CB_TargetName==pl.DisplayName) then
SYS.C_.CB_TargetName=""
pcall(function() if SYS.Combat and SYS.Combat.ClearTarget then SYS.Combat.ClearTarget() end end)
end
refreshUI()
end))
end
do
local MENU_ACTION="CheatMenuV49_Toggle"
local last=0
local function Handle()
if SYS.Unloaded then return false end
local foc=false
pcall(function() foc=UIS:GetFocusedTextBox()~=nil end)
if foc then return false end
local now=os.clock()
if now-last<0.2 then return true end
last=now
local before=SYS.ScreenGui and (SYS.ScreenGui.Enabled==true)
P(SYS.ToggleMenu)
local after=SYS.ScreenGui and (SYS.ScreenGui.Enabled==true)
if after==before then
warn("[CheatMenu] 菜单没有切换成功 —— 可能这个键被游戏/其他脚本占用了。试试 右Shift 键。")
end
return true
end
local function bindMenuKey()
if not CAS then return end
pcall(function()
CAS:UnbindAction(MENU_ACTION)
CAS:BindActionAtPriority(MENU_ACTION,function(_,state)
if state~=Enum.UserInputState.Begin or SYS.Unloaded then
return Enum.ContextActionResult.Pass
end
if Handle() then return Enum.ContextActionResult.Sink end
return Enum.ContextActionResult.Pass
end,false,10000,(SYS.KeyCodeOf(SYS.C_.Key_Menu) or Enum.KeyCode.G))
end)
end
SYS.RebindMenuKey=bindMenuKey
bindMenuKey()
T(UIS.InputBegan:Connect(function(input,gp)
if SYS.Unloaded then return end
if SYS.KeyPickTarget then
local foc=false
pcall(function() foc=UIS:GetFocusedTextBox()~=nil end)
if foc then return end
local k=input.KeyCode
if k==Enum.KeyCode.Unknown then return end
SYS.C_[SYS.KeyPickTarget]=k.Name
SYS.Notify(("已绑定: %s -> %s"):format(tostring(SYS.KeyPickTarget),k.Name),SYS.CY.green)
SYS.KeyPickTarget=nil
P(SYS.RebindMenuKey)
for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
return
end
if input.KeyCode==(SYS.KeyCodeOf(SYS.C_.Key_Menu) or Enum.KeyCode.G)
or input.KeyCode==Enum.KeyCode.RightShift then
Handle() return
end
if gp then return end
if SYS.T_.TPEnabled
and input.KeyCode==(SYS.KeyCodeOf(SYS.C_.Key_Teleport) or Enum.KeyCode.T) then
SYS.TPToMouse() return
end
end))
end
function SYS.UnloadAll()
if SYS.Unloaded then return end
SYS.Unloaded=true
for k in pairs(SYS.T_) do SYS.T_[k]=false end
if not SYS._updating then P(SYS.SaveConfig) end
P(SYS.SetGod,false) P(SYS.SetNoFall,false) P(SYS.SetJumpBoost,false)
P(SYS.SetDeepHide,false)
P(SYS.CleanFly) P(SYS.CleanSpeed)
P(SYS.SetInfiniteJump,false)
P(SYS.SetPathKey,false)
P(function() WS.Gravity=SYS.Orig.Gravity end)
P(SYS.SetFullBright,false) P(SYS.SetPerf,false) P(SYS.ClearPerfConns)
P(function() SYS.RefreshNC(false) end)
P(SYS.StopFreeCam) P(SYS.ClearESP) P(SYS.TracerHide) P(SYS.disableAntiAFK) P(SYS.StopSpectate)
P(function() if SYS._f3Gui then SYS._f3Gui:Destroy() SYS._f3Gui=nil SYS._f3Lbl=nil end end)
P(function() if SYS._awConn then SYS._awConn:Disconnect() SYS._awConn=nil end end)
P(function() SYS._ciOn=false end)
P(SYS.StopTrain) P(SYS.StopReb) P(SYS.StopGym)
P(function() if SYS.CleanTrapGuard then SYS.CleanTrapGuard() end end)
P(function() if SYS.Combat then SYS.Combat.Stop() end end)
P(function() if SYS.SetNoclip then SYS.SetNoclip(false) end end)
P(function() if SYS.FuseClean then SYS.FuseClean() end end)
for _,c in ipairs(SYS.NoclipConns or {}) do DS(c) end SYS.NoclipConns={}
if CAS then P(function() CAS:UnbindAction(SYS.N.CAS) end) end
P(SYS.EnablePlayerControls)
P(function()
if Trans and Trans.restoreSource then
Trans.restoreSource("chat") Trans.restoreSource("ui")
end
end)
P(function() if Trans and Trans.Unload then Trans.Unload() end end)
for _,c in pairs(SYS.Loops) do DS(c) end SYS.Loops={}
for _,c in ipairs(SYS.Conns) do DS(c) end SYS.Conns={}
for _,c in ipairs(SYS.NCConns or {}) do DS(c) end SYS.NCConns={}
for _,co in ipairs(SYS.Threads) do DS(co) end SYS.Threads={}
P(function()
SYS.RestoreMouse()
end)
P(SYS.ResetCam)
P(function() if SYS.SetForceCam then SYS.SetForceCam("off") end end)
P(function() if SYS.RestoreCamOpts then SYS.RestoreCamOpts() end end)
P(function() if SYS.ScreenGui then SYS.ScreenGui:Destroy() end end)
SYS.ScreenGui=nil SYS.MenuOpen=false
P(function() if SYS.FloatGui then SYS.FloatGui:Destroy() end end)
SYS.FloatGui=nil SYS.FloatBtn=nil
if GENV[SYS.GK.unload]==SYS.UnloadAll then
GENV[SYS.GK.loaded]=nil GENV[SYS.GK.unload]=nil
end
GENV[SYS.GK.boot]=nil
GENV[SYS.GK.note]=nil
print("✅ 已卸载")
end
function SYS.CheckUpdate(silent,notifyOnly)
if SYS.UpdateBusy then return end
if not SYS.BuildVerURL or SYS.BuildVerURL=="" or SYS.BuildVerURL:find("{{",1,true) then
if not silent then SYS.Notify("ℹ️ 当前是本地开发版, 没有配置更新地址",SYS.CY.sub) end
return
end
if type(game.HttpGet)~="function" then
if not silent then SYS.Notify("ℹ️ 当前执行器没有 HttpGet, 跳过更新检查",SYS.CY.sub) end
return
end
SYS.UpdateBusy=true
local _,remote=P(function() return game:HttpGet(SYS.BuildVerURL) end)
if type(remote)~="string" then
SYS.UpdateBusy=false
if not silent then SYS.Notify("❌ 检查更新失败: 取版本号失败(网络?)",SYS.CY.red) end
return
end
local rv=remote:gsub("%s","")
local mine=tostring(SYS.BuildVer or ""):gsub("%s","")
if rv=="" or rv==mine then
SYS.UpdateBusy=false
if not silent then SYS.Notify(("✅ 已是最新版 (%s)"):format(tostring(SYS.BuildVer)),SYS.CY.green) end
print(("[CheatMenu] 更新检查: 已是最新版 %s"):format(tostring(SYS.BuildVer)))
return
end
local msg=("🆕 发现新版本 %s → %s"):format(tostring(SYS.BuildVer),tostring(rv))
print(("[CheatMenu] "..msg.."  (%s)"):format(notifyOnly and "仅提示, 未自动更新" or "开始热重载"))
if notifyOnly then
SYS.UpdateBusy=false
SYS.Notify(msg.."\n已跳过自动更新 —— 想升级就点设置页的「⬆️ 检查更新并热重载」",SYS.CY.yellow)
P(function() SYS.Hud("🆕 "..msg.."  (未自动更新, 可在设置页手动升级)", 10) end)
return
end
SYS.Notify(msg.." 正在热重载…",SYS.CY.yellow)
P(function() SYS.Hud("🆕 "..msg.." 正在热重载…", 8) end)
local _,src=P(function() return game:HttpGet(SYS.BuildURL) end)
if type(src)~="string" or #src<1000 then
SYS.UpdateBusy=false
SYS.Notify("❌ 更新失败: 新版源码下载异常(保留当前版本)",SYS.CY.red)
P(function() SYS.Hud("❌ 更新失败: 下载异常, 已保留当前版本", 8) end)
return
end
local chunk,cerr=(loadstring or load)(src,"@CheatMenu_update")
if type(chunk)~="function" then
SYS.UpdateBusy=false
SYS.Notify("❌ 更新失败: 新版编译不过, 已保留当前版本",SYS.CY.red)
warn("[CheatMenu] 新版编译失败: "..tostring(cerr))
return
end
SYS._updating = true
P(SYS.SaveConfig)
P(SYS.UnloadAll)
local ok,err=P(chunk)
if not ok then warn("[CheatMenu] 更新后执行新版失败: "..tostring(err)) end
SYS.UpdateBusy=false
end
do
local pls=Players:GetPlayers()
for i=1,#pls do SYS.TrackCollide(pls[i]) end
T(Players.PlayerAdded:Connect(SYS.TrackCollide))
local okC,errC=pcall(SYS.CreateMenu)
if not okC then
warn("[CheatMenu] ❌ CreateMenu:") warn(tostring(errC))
P(function() if SYS.ScreenGui then SYS.ScreenGui:Destroy() end end)
SYS.ScreenGui=nil SYS.MenuOpen=false
else
print("[CheatMenu] CreateMenu 成功")
end
GENV[SYS.GK.loaded]=true
P(function() if SYS.ApplyNeutralNames then SYS.ApplyNeutralNames() end end)
P(function() if SYS.AC and SYS.AC.StartSampler then SYS.AC.StartSampler() end end)
GENV[SYS.GK.unload]=SYS.UnloadAll
task.spawn(function()
task.wait(1.5)
if SYS.T_.AntiAFK then P(SYS.enableAntiAFK) end
for key,fn in pairs(SYS.SwitchOnChange) do
if key~="AntiAFK" and SYS.T_[key]==true then P(fn,true) end
end
print("[CheatMenu] ✅ 已根据配置激活开关")
if GENV[SYS.GK.note] then
local note=GENV[SYS.GK.note]
GENV[SYS.GK.note]=nil
SYS.Notify(note,SYS.CY.green)
print("[CheatMenu] "..note)
end
task.wait(1.0)
P(function() SYS.CheckUpdate(true, not SYS.T_.AutoUpdateCheck) end)
end)
end
print(("[CheatMenu] ===== 加载完成 · 版本 %s ====="):format(tostring(SYS.BuildVer)))
print("[CheatMenu] (local-开头=本地版 / 10 位十六进制=仓库网络版)")
print("[CheatMenu] 热键: G 打开/关闭 | T 传送到鼠标")
print("[CheatMenu] 中文/中文标点/硬保护词 全部跳过翻译")
