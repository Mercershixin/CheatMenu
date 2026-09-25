print(('[CheatMenu] build 2026-09-25 22:51 sha f466460e bytes 232382'):format('2026-09-25 22:51','f466460e',232382))
print("[CheatMenu] ===== 加载开始 · V3 内核 [gen v86] =====")
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
AntiAFK=true,AutoTrain=false,AutoBonus=false,AutoGym=false,
AutoSell=false,SellThresholdEnabled=false,
DeepHide=false,
TransChat=false,TransUI=false,TransBilingual=false,TransDyn=true,LocalPhrase=true,
MenuMouse=true,
NoFog=false,NoShadow=false,Lantern=false,
AutoUpdateCheck=true,BootUpdateCheck=true,
},
C_={
AtlasCap=60000,
CamZoom=20,
LightMode="",
WL_Sel="",
GameNameCache="",
FlySpeed=6,FlyMode="BodyVelocity",FlyGroundH=4,
SpeedMult=6,TPMethod="CFrame",SpeedMode="Linear",
JumpMult=6,
MouseTPMode="Raycast",AutoTPDist=5,TPMaxStep=300,
FreeCamSpeed=140,FreeCamSens=0.3,PerfCull=300,
TracerMaxDist=3000,TracerMaxN=40,
ESPNameH=0,
PickDist=3000,
QuickRange=60,
AutoHideDist=40,
DeepHideDepth=120,
DeepHideMode="down",DeepHideOffX=0,DeepHideOffZ=0,
ForceCam="off",
AutoTrainSec=5,
SellMinCPS=100000,SellLvMul=1.25,
CB_AimPart=1,CB_Smooth=1,CB_Fov=600,CB_MaxDist=2000,CB_MeleeDist=25,CB_MeleeGap=0.10,
DodgeDist=15,
DodgeDepth=2,
DodgeCap=80,
DodgeScanSec=0.6,
DodgeStep=0.35,
CB_ScanMs=0,
CB_FireDelay=0.02,CB_HpThr=0,CB_PrioMode=1,
CB_TargetMode=1,CB_TargetName="",CB_RingMode=1,CB_PredictTime=0.22,
CB_ProjSpeed=100,CB_ProjGrav=196.2,
CB_RingModeVer=0,
CB_SnapDelay=0.03,
CB_SnapMinGap=0.08,CB_SnapMaxAngle=360,
Key_Menu="G",Key_CycleTarget="V",Key_Teleport="T",
UIScaleManual=0,
MenuPosX=0.5,MenuPosY=0.5,MenuPosSaved=false,
PC_Sel="",PC_Range=8,PC_SpinSpeed=3,
PC_Mode="off",
FireJitter=0.03,
CamGuardDist=30,
MoveSmooth=0.25,
JumpSpoofMode="Height",
FlyAbs=0,
SpeedAbs=0,
RevertCap=0,
RevertJump=150,
FireTypeSigN=3,
UA_ReactMs=120,UA_MaxDeg=420,UA_Dead=1.5,UA_Noise=0.35,
},
SavedPos={},Loops={},BtnRefs={},SwitchOnChange={},Pages={},
ScreenGui=nil,MenuOpen=false,FreeCamActive=false,MenuPrevMouseBehav=nil,MenuPrevMouseIcon=nil,
FCPrevBehav=nil,FCPrevIcon=nil,
}
SYS.BuildVer="1.0.1"
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
Info   = ({"Status","Info","Overlay"})[math.random(1,3)],
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
do
local K="RblxSessionN"
local prev=GENV[K]
if type(prev)=="table" and type(prev.Gui)=="string" then
for k,v in pairs(prev) do SYS.N[k]=v end
else
local cp={} for k,v in pairs(SYS.N) do cp[k]=v end
GENV[K]=cp
end
end
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
SYS.Errors = SYS.Errors or {}
SYS.ErrN = SYS.ErrN or 0
SYS.ErrPrintN = SYS.ErrPrintN or 0
SYS.ErrSlot = SYS.ErrSlot or 0
local function P_(f,...)
if type(f)~="function" then return false end
local ok,a,b = pcall(f,...)
if not ok then
SYS.ErrN = SYS.ErrN + 1
local msg = tostring(a)
if #msg > 160 then msg = msg:sub(1,160) end
local e = SYS.Errors[msg]
if e then
e.n = e.n + 1
elseif SYS.ErrSlot < 60 then
SYS.ErrSlot = SYS.ErrSlot + 1
SYS.Errors[msg] = {n=1,t=os.clock()}
if SYS.ErrPrintN < 30 then
SYS.ErrPrintN = SYS.ErrPrintN + 1
print("[CheatMenu] ⚠ 内部错误(已记账, 设置页 🩺 可查): "..msg)
end
else
SYS.ErrOther = (SYS.ErrOther or 0) + 1
end
end
return ok,a,b
end
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
do
local K={ Ver="V3" }
SYS.K=K
local LOG={}
K.LOG=LOG
function K.Log(cat,text,cap)
if cat==nil then return end
local t=LOG[cat]
if not t then t={} LOG[cat]=t end
t[#t+1]=("[%s] %s"):format(os.date("%H:%M:%S"),tostring(text))
local c=tonumber(cap) or 200
if c<10 then c=10 end
while #t>c do table.remove(t,1) end
end
function K.LogGet(cat,n)
local t=LOG[cat]
if not t then return {} end
local out={}
local from=#t-(tonumber(n) or 20)+1
if from<1 then from=1 end
for i=from,#t do out[#out+1]=t[i] end
return out
end
function K.LogClear(cat)
if cat then LOG[cat]={} else for k in pairs(LOG) do LOG[k]=nil end end
end
local ERRS={}
K.ERRS=ERRS
K.ErrN=0
K.ErrSlot=0
K.ErrOther=0
K.ErrPrintN=0
K.ErrPrintMax=40
function K.Guard(where,fn,...)
if type(fn)~="function" then return false end
local a,b,c=pcall(fn,...)
if a then return a,b,c end
K.ErrN=K.ErrN+1
local m=tostring(b)
if #m>200 then m=m:sub(1,200) end
local w=tostring(where)
local key=w.."|"..m
local e=ERRS[key]
if e then
e.n=e.n+1
elseif K.ErrSlot<80 then
K.ErrSlot=K.ErrSlot+1
ERRS[key]={n=1,t=os.clock(),where=w,msg=m}
K.Log("err",w.." -> "..m,300)
if K.ErrPrintN<K.ErrPrintMax then
K.ErrPrintN=K.ErrPrintN+1
print(("[CheatMenu] ⚠ 错误显形[%s]: %s"):format(w,m))
end
else
K.ErrOther=K.ErrOther+1
end
return a,b,c
end
function K.ErrList()
local out={}
for _,e in pairs(ERRS) do out[#out+1]=e end
table.sort(out,function(x,y) return (x.n or 0)>(y.n or 0) end)
return out
end
function K.ErrText()
local l=K.ErrList()
if #l==0 then return "无错误记录" end
local s={}
local n=#l
if n>8 then n=8 end
for i=1,n do
s[#s+1]=("[%s x%d] %s"):format(tostring(l[i].where),l[i].n or 1,tostring(l[i].msg))
end
return table.concat(s,"\n")
end
local SC={ jobs={}, order={}, drivers={}, n=0, paused=false, cost=0, tickN=0, profile=false, prof={} }
K.Sched=SC
function SC.Ensure(sig)
if not sig then return nil end
local d=SC.drivers[sig]
if d then return d end
local ok,conn=pcall(function() return sig:Connect(function(dt) SC.Pump(sig,dt) end) end)
if not ok or not conn then return nil end
d={conn=conn}
SC.drivers[sig]=d
SYS.Conns[#SYS.Conns+1]=conn
return d
end
function SC.Add(name,fn,opt)
if type(name)~="string" or type(fn)~="function" then return nil end
opt=opt or {}
local rec=SC.jobs[name]
if rec then
if rec.dead then rec.dead=false rec.on=true SC.n=SC.n+1 end
rec.fn=fn
if opt.sig then rec.sig=opt.sig end
if opt.every~=nil then rec.every=tonumber(opt.every) or rec.every end
else
rec={ name=name, fn=fn, sig=opt.sig, every=tonumber(opt.every) or 0,
acc=0, done=0, cost=0, on=true, dead=false, where="job:"..name }
SC.jobs[name]=rec
SC.order[#SC.order+1]=name
SC.n=SC.n+1
end
if SC.profile then SC.prof[name]=SC.prof[name] or {n=0,cost=0} end
SC.Ensure(rec.sig)
return rec
end
function SC.Del(name)
local rec=SC.jobs[name]
if not rec or rec.dead then return false end
rec.dead=true
rec.on=false
SC.n=SC.n-1
SC.dirty=true
return true
end
local function scCompact()
if not SC.dirty then return end
SC.dirty=false
local out={}
local ord=SC.order
for i=1,#ord do
local rec=SC.jobs[ord[i]]
if rec and not rec.dead then out[#out+1]=ord[i] end
end
SC.order=out
end
function SC.Has(name)
local rec=SC.jobs[name]
return (rec~=nil) and (rec.dead~=true)
end
function SC.Pause(on)
SC.paused=on and true or false
return SC.paused
end
function SC.Pump(sig,dt)
if SC.paused then return end
scCompact()
SC.tickN=SC.tickN+1
local t0=os.clock()
local ord=SC.order
local prof=SC.profile
for i=1,#ord do
local rec=SC.jobs[ord[i]]
if rec and rec.on and not rec.dead and rec.sig==sig then
local run=false
if rec.every<=0 then
run=true
else
rec.acc=rec.acc+dt
if rec.acc>=rec.every then rec.acc=0 run=true end
end
if run then
rec.done=rec.done+1
if prof then
local a0=os.clock()
K.Guard(rec.where,rec.fn,dt)
local c0=os.clock()-a0
rec.cost=rec.cost*0.9+c0*0.1
local p=SC.prof[rec.name]
if p then p.n=p.n+1 p.cost=p.cost*0.9+c0*0.1 end
else
K.Guard(rec.where,rec.fn,dt)
end
end
end
end
SC.cost=SC.cost*0.88+(os.clock()-t0)*0.12
end
function SC.Top(n)
local out={}
for _,rec in pairs(SC.jobs) do
if not rec.dead then out[#out+1]={name=rec.name,cost=rec.cost,done=rec.done} end
end
table.sort(out,function(x,y) return (x.cost or 0)>(y.cost or 0) end)
local r={}
local m=#out
local lim=tonumber(n) or 5
if m>lim then m=lim end
for i=1,m do r[#r+1]=out[i] end
return r
end
function SC.Count() return SC.n end
function SC.DriverCount()
local c=0
for _ in pairs(SC.drivers) do c=c+1 end
return c
end
function SC.Clear()
SC.jobs={} SC.order={} SC.n=0 SC.dirty=false
end
function SC.Profile(on)
SC.profile=on and true or false
if SC.profile then
for name in pairs(SC.jobs) do SC.prof[name]=SC.prof[name] or {n=0,cost=0} end
end
return SC.profile
end
local BUS={ recs={}, n=0 }
K.Bus=BUS
local function busAdd(conn,tag,owner)
if not conn or type(conn.Disconnect)~="function" then return nil end
BUS.recs[#BUS.recs+1]={conn=conn,tag=tostring(tag or "?"),owner=tostring(owner or "?"),live=true}
BUS.n=#BUS.recs
return conn
end
function BUS.Raw(conn,tag,owner)
return busAdd(conn,tag,owner)
end
function BUS.Sig(inst,evt,fn,owner)
if not inst or type(evt)~="string" or type(fn)~="function" then return nil end
local ok,sig=pcall(function() return inst[evt] end)
if not ok or not sig or type(sig.Connect)~="function" then return nil end
local ok2,conn=pcall(function() return sig:Connect(fn) end)
if not ok2 then return nil end
return busAdd(conn,evt,owner)
end
function BUS.Off(owner)
local n=0
local keep={}
for i=1,#BUS.recs do
local r=BUS.recs[i]
if r.owner==owner then
pcall(function() r.conn:Disconnect() end)
r.live=false
n=n+1
else
keep[#keep+1]=r
end
end
BUS.recs=keep BUS.n=#keep
return n
end
function BUS.OffAll()
local n=#BUS.recs
for i=1,#BUS.recs do pcall(function() BUS.recs[i].conn:Disconnect() end) end
BUS.recs={} BUS.n=0
return n
end
function BUS.Count() return BUS.n end
local HK={ list={}, n=0 }
K.Hook=HK
function HK.API()
local f=SYS.HookAPI
if type(f)=="function" then
local ok,v=pcall(f)
if ok then return v end
end
return nil
end
function HK.Find(target)
for i=1,#HK.list do if HK.list[i].target==target then return HK.list[i] end end
return nil
end
function HK.Has(target) return HK.Find(target)~=nil end
local function hkRestoreOne(rec)
if type(restorefunction)=="function" then
pcall(restorefunction,rec.target)
else
local HF=HK.API()
if HF then pcall(HF,rec.target,rec.orig) end
end
end
function HK.Set(target,wrapper,owner,tag)
if type(target)~="function" or type(wrapper)~="function" then return nil,"目标/包装不是函数" end
local ex=HK.Find(target)
if ex then return ex.orig end
local HF=HK.API()
if not HF then return nil,"本机没有 hookfunction" end
local ok,orig=pcall(HF,target,wrapper)
if not ok or type(orig)~="function" then return nil,"hookfunction 不返回原函数(按原则不动手)" end
HK.list[#HK.list+1]={target=target,orig=orig,owner=tostring(owner or "?"),tag=tostring(tag or "?")}
HK.n=#HK.list
return orig
end
function HK.Drop(target)
for i=#HK.list,1,-1 do
if HK.list[i].target==target then
table.remove(HK.list,i)
HK.n=#HK.list
return true
end
end
return false
end
function HK.Restore(target)
local rec=HK.Find(target)
if not rec then return false end
hkRestoreOne(rec)
HK.Drop(target)
return true
end
function HK.RestoreAll()
local n=0
for i=#HK.list,1,-1 do
hkRestoreOne(HK.list[i])
table.remove(HK.list,i)
n=n+1
end
HK.n=0
return n
end
function HK.Count() return HK.n end
local NET={ atlas={t=0,list={},byClass={},n=0}, bound={}, pending={}, spy=false, recvN=0, cap=300, tracked=false, healthN=0, healthLast=0 }
K.Net=NET
local CLSSET={ RemoteEvent=true, UnreliableRemoteEvent=true, RemoteFunction=true,
BindableEvent=true, BindableFunction=true, ProximityPrompt=true, ClickDetector=true }
NET.Order={"RemoteEvent","UnreliableRemoteEvent","RemoteFunction","BindableEvent","BindableFunction","ProximityPrompt","ClickDetector"}
local _roots=nil
function NET.Roots()
if _roots then return _roots end
local r={}
if RStorage then r[#r+1]=RStorage end
if WS then r[#r+1]=WS end
if LP and LP.PlayerScripts then r[#r+1]=LP.PlayerScripts end
if LP and LP.PlayerGui then r[#r+1]=LP.PlayerGui end
if CoreGui then r[#r+1]=CoreGui end
_roots=r
return _roots
end
local function atlasAdd(e)
local A=NET.atlas
A.list[#A.list+1]=e
local t=A.byClass[e.cls]
if not t then t={} A.byClass[e.cls]=t end
t[#t+1]=e
A.n=A.n+1
end
function NET.Scan(root,limit)
limit=tonumber(limit) or tonumber(SYS.C_ and SYS.C_.AtlasCap) or 60000
local ok,ds=pcall(function() return root:GetDescendants() end)
if not ok or not ds then return 0 end
if #ds>limit then
K.Log("atlas",("跳过(实例过多 %d > %d): %s"):format(#ds,limit,root.Name),60)
return 0
end
local c=0
for i=1,#ds do
local d=ds[i]
local cls=d.ClassName
if CLSSET[cls] then
local okp,path=pcall(function() return d:GetFullName() end)
atlasAdd({inst=d,name=d.Name,cls=cls,path=okp and path or d.Name})
c=c+1
end
end
return c
end
function NET.Atlas(force)
local A=NET.atlas
if (not force) and A.n>0 and (os.clock()-A.t)<15 then return A end
A.list={} A.byClass={} A.n=0
local rt=NET.Roots()
for i=1,#rt do K.Guard("atlas.scan",NET.Scan,rt[i]) end
A.t=os.clock()
K.Log("atlas",("图谱重建: %d 条"):format(A.n),60)
return A
end
function NET.Track()
if NET.tracked then return end
NET.tracked=true
local rt=NET.Roots()
for i=1,#rt do
BUS.Sig(rt[i],"DescendantAdded",function(d)
local cls=d.ClassName
if CLSSET[cls] then
local okp,path=pcall(function() return d:GetFullName() end)
atlasAdd({inst=d,name=d.Name,cls=cls,path=okp and path or d.Name})
end
if SYS.T_.LazyRebind~=false and next(NET.pending)~=nil then
K.Guard("net.rebind",NET.Rebind)
end
local Wc=K.Watch
if Wc then
if Wc.on.ents then K.Guard("dyn.ent",Wc.Entity,d) end
if Wc.on.values then K.Guard("dyn.val",Wc.Value,d) end
if Wc.on.attrs then K.Guard("dyn.attr",Wc.Attr,d) end
end
end,"V3:atlas")
end
K.Log("atlas","增量维护已开启(不再全量轮询)")
end
function NET.Resolve(name,cls)
if type(name)~="string" then return nil end
if cls=="RemoteFunction" and SYS.RFunction then
local ok,f=pcall(SYS.RFunction,name)
if ok and f then return f end
end
if SYS.REvent then
local ok,f=pcall(SYS.REvent,name)
if ok and f then return f end
end
if cls=="RemoteEvent" or cls==nil then
if SYS.REventU then
local ok,f=pcall(SYS.REventU,name)
if ok and f then return f end
end
end
return nil
end
function NET.Attach(name,r,cb)
if not r or type(cb)~="function" then return nil end
local b=NET.bound[name]
if b and b.remote==r then
b.cbs[#b.cbs+1]=cb
return r
end
if b then
pcall(function() b.conn:Disconnect() end)
NET.bound[name]=nil
end
local sig
if r.ClassName=="RemoteFunction" then sig=r.OnClientInvoke else sig=r.OnClientEvent end
if not sig or type(sig.Connect)~="function" then return nil end
local rec={remote=r,cbs={cb},name=name,cls=r.ClassName,n=0,at=os.clock(),lastAt=nil,ever=false}
local ok,conn=pcall(function()
return sig:Connect(function(...)
rec.n=rec.n+1
rec.lastAt=os.clock()
rec.ever=true
NET.recvN=NET.recvN+1
if NET.spy then
K.Log("recv",("▸ [%s] %s  (参数 %d)"):format(rec.cls,name,select("#",...)),NET.cap)
end
local cbs=rec.cbs
for i=1,#cbs do K.Guard("netcb:"..name,cbs[i],...) end
end)
end)
if not ok or not conn then return nil end
rec.conn=conn
NET.bound[name]=rec
SYS.Conns[#SYS.Conns+1]=conn
K.Log("bind",("已挂 %s (%s)"):format(name,rec.cls),150)
return r
end
function NET.Bind(name,cb,cls)
if type(name)~="string" or type(cb)~="function" then return nil end
local r=NET.Resolve(name,cls)
if r then return NET.Attach(name,r,cb) end
local p=NET.pending[name]
if not p then p={list={},cls=cls} NET.pending[name]=p end
p.list[#p.list+1]=cb
K.Log("bind",("挂起(等远程下发): %s"):format(name),150)
return nil
end
function NET.Rebind()
local n=0
for name,p in pairs(NET.pending) do
local r=NET.Resolve(name,p.cls)
if r then
for i=1,#p.list do NET.Attach(name,r,p.list[i]) end
NET.pending[name]=nil
n=n+1
end
end
if n>0 then K.Log("bind",("远程下发后重绑 %d 个监听"):format(n),150) end
return n
end
function NET.Health()
local now=os.clock()
local rows={}
for name,b in pairs(NET.bound) do
local dead=false
pcall(function() dead=(b.remote==nil or b.remote.Parent==nil) end)
rows[#rows+1]={ name=name, cls=b.cls, dead=dead, ever=b.ever==true,
n=b.n or 0, age=now-((b.lastAt or b.at) or now) }
end
table.sort(rows,function(x,y)
if x.dead~=y.dead then return x.dead end
return (x.n or 0)>(y.n or 0)
end)
return rows
end
function NET.HealthRebind()
local n=0
for name,b in pairs(NET.bound) do
local dead=false
pcall(function() dead=(b.remote==nil or b.remote.Parent==nil) end)
if dead then
local cbs=b.cbs or {}
pcall(function() if b.conn then b.conn:Disconnect() end end)
NET.bound[name]=nil
local p={list={},cls=b.cls}
for i=1,#cbs do p.list[#p.list+1]=cbs[i] end
NET.pending[name]=p
n=n+1
end
end
if n>0 then K.Log("bind",("健康检查: %d 个绑定目标已失效 -> 改挂起等重发"):format(n),150) end
NET.healthN=n
NET.healthLast=os.clock()
return n
end
function NET.PendingN()
local c=0
for _ in pairs(NET.pending) do c=c+1 end
return c
end
function NET.BoundN()
local c=0
for _ in pairs(NET.bound) do c=c+1 end
return c
end
function NET.Spy(on)
NET.spy=on and true or false
return NET.spy
end
function NET.DetachAll()
local n=0
for _,b in pairs(NET.bound) do
pcall(function() b.conn:Disconnect() end)
n=n+1
end
NET.bound={}
return n
end
function NET.Categories()
local WANT={
{"box","盒子 / 宝箱"},{"pickup","拾取"},{"equip","装备"},{"revive","复活"},
{"buy","购买"},{"shop","商店"},{"sell","出售"},{"trade","交易"},
{"claim","领取"},{"daily","每日"},{"mail","邮件"},{"friend","好友"},
{"chat","聊天"},{"emote","表情"},{"team","队伍"},{"round","回合"},
{"respawn","重生"},{"kill","击杀"},{"damage","伤害"},{"heal","治疗"},
{"doors","门"},{"teleport","传送"},{"move","移动"},{"server","服务器"},
{"kick","踢出"},{"inventory","背包"},{"itemuse","使用道具"},{"craft","制造"},
{"loot","战利品"},{"orb","光球"},{"milestone","里程碑"},{"stall","摊位"},
{"deathfx","死亡特效"},{"doorshop","门商店"},
}
local out={}
local miss=0
if type(SYS.FindEvent)~="function" then return out,0 end
for i=1,#WANT do
local k=WANT[i][1]
local ok,r,nm,how=pcall(SYS.FindEvent,k)
if not ok then r=nil nm=nil how=nil end
out[#out+1]={key=k,label=WANT[i][2],inst=r,name=nm,how=how}
if not r then miss=miss+1 end
end
return out,miss
end
local W={ on={}, attrN=0, valN=0, tagN=0, entN=0 }
K.Watch=W
local function seen(key)
if W.on[key] then return true end
W.on[key]=true
return false
end
local function clearPrefix(pre)
local rm={}
for k in pairs(W.on) do
if type(k)=="string" and k:sub(1,#pre)==pre then rm[#rm+1]=k end
end
for i=1,#rm do W.on[rm[i]]=nil end
return #rm
end
W.ClearPrefix=clearPrefix
function W.Hum(p,ch)
if not p or not ch then return end
local h=ch:FindFirstChildOfClass("Humanoid")
if not h then
if not seen("humwait:"..p.Name) then
BUS.Sig(ch,"ChildAdded",function(c)
if c:IsA("Humanoid") then W.Hum(p,ch) end
end,"V3:hum")
end
return
end
if W.on["hum:"..p.Name]==h then return end
W.on["hum:"..p.Name]=h
BUS.Sig(h,"Died",function() K.Log("evt","Died "..p.Name) end,"V3:hum")
BUS.Sig(h,"StateChanged",function(_,s)
if p==LP then K.Log("evt","状态 -> "..tostring(s)) end
end,"V3:hum")
end
function W.Char(p)
if not p then return end
if seen("char:"..p.Name) then return end
BUS.Sig(p,"CharacterAdded",function(ch)
K.Log("evt","CharacterAdded "..p.Name)
W.Hum(p,ch)
end,"V3:char")
local ch=p.Character
if ch then W.Hum(p,ch) end
end
function W.Players(on)
if on==false then
BUS.Off("V3:players") BUS.Off("V3:char") BUS.Off("V3:hum")
clearPrefix("char:") clearPrefix("hum:") clearPrefix("humwait:")
W.on.players=false
return false
end
if W.on.players then return true end
W.on.players=true
BUS.Sig(Players,"PlayerAdded",function(p) W.Char(p) K.Log("evt","PlayerAdded "..p.Name) end,"V3:players")
BUS.Sig(Players,"PlayerRemoving",function(p) K.Log("evt","PlayerRemoving "..p.Name) end,"V3:players")
local pls=Players:GetPlayers()
for i=1,#pls do W.Char(pls[i]) end
W.Char(LP)
return true
end
function W.Attr(inst)
if not inst then return end
local ok,names=pcall(function() return inst:GetAttributes() end)
if not ok or type(names)~="table" then return end
local has=false
for _ in pairs(names) do has=true break end
if not has then return end
if seen("attr:"..tostring(inst)) then return end
W.attrN=W.attrN+1
BUS.Sig(inst,"AttributeChanged",function(nm,v)
K.Log("attr",("%s.%s = %s"):format(inst.Name,tostring(nm),tostring(v)),250)
end,"V3:attr")
end
function W.Attrs(on)
if on==false then
BUS.Off("V3:attr") clearPrefix("attr:") W.on.attrs=false W.attrN=0
return false
end
if W.on.attrs then return true end
W.on.attrs=true
local rt=NET.Roots()
for i=1,#rt do
local root=rt[i]
K.Guard("attr.scan",function()
local ds=root:GetDescendants()
if #ds>40000 then return end
for j=1,#ds do W.Attr(ds[j]) end
end)
end
return true
end
function W.Value(inst)
if not inst then return end
local c=inst.ClassName
if c~="IntValue" and c~="NumberValue" and c~="StringValue" and c~="BoolValue" and c~="ObjectValue" then return end
if seen("val:"..tostring(inst)) then return end
W.valN=W.valN+1
local ok,label=pcall(function()
local p=inst.Parent
return (p and (p.Name.."."..inst.Name)) or inst.Name
end)
if not ok or type(label)~="string" then label=inst.Name end
BUS.Sig(inst,"Changed",function(v)
K.Log("val",("%s = %s"):format(label,tostring(v)),250)
end,"V3:val")
end
function W.Values(on)
if on==false then
BUS.Off("V3:val") clearPrefix("val:") W.on.values=false W.valN=0
return false
end
if W.on.values then return true end
W.on.values=true
local rt=NET.Roots()
for i=1,#rt do
local root=rt[i]
K.Guard("val.scan",function()
local ds=root:GetDescendants()
if #ds>40000 then return end
for j=1,#ds do W.Value(ds[j]) end
end)
end
return true
end
function W.Tags(on)
if on==false then
BUS.Off("V3:tag") W.on.tags=false W.tagN=0
return false
end
if W.on.tags then return true end
if not CS then return false end
W.on.tags=true
local ok,tags=pcall(function() return CS:GetTags() end)
if not ok or type(tags)~="table" then return true end
local n=0
for i=1,#tags do
if n>=80 then break end
local tg=tostring(tags[i])
n=n+1
W.tagN=W.tagN+1
local okA,sigA=pcall(function() return CS:GetInstanceAddedSignal(tg) end)
if okA and sigA then
local ok2,c=pcall(function()
return sigA:Connect(function(inst)
local okp,path=pcall(function() return inst:GetFullName() end)
K.Log("tag",("+ [%s] %s"):format(tg,okp and path or tostring(inst)))
end)
end)
if ok2 then BUS.Raw(c,"tag:"..tg,"V3:tag") end
end
end
K.Log("tag",("已挂 %d 个标签的变动信号"):format(n))
return true
end
function W.Entity(d)
if not d then return end
if d.ClassName~="Model" then return end
if seen("ent:"..tostring(d)) then return end
W.entN=W.entN+1
local nm=nil
pcall(function() nm=d:GetAttribute("EntityName") end)
local hum=(d:FindFirstChildOfClass("Humanoid")~=nil)
if nm or hum then
K.Log("ent",("+ %s%s%s"):format(d.Name,
nm and (" EntityName="..tostring(nm)) or "",
hum and " (有 Humanoid)" or ""),250)
end
end
function W.Entities(on)
if on==false then
BUS.Off("V3:ent") clearPrefix("ent:") W.on.ents=false W.entN=0
return false
end
if W.on.ents then return true end
W.on.ents=true
return true
end
local CN={ n=0, lastAt=0, rows={} }
K.Conn=CN
function CN.API()
local ok,f=pcall(function() return rawget(getfenv(),"getconnections") end)
if ok and type(f)=="function" then return f end
local ok2,f2=pcall(function() return getconnections end)
if ok2 and type(f2)=="function" then return f2 end
return nil
end
function CN.Count(sig)
if not sig then return nil end
local gc=CN.API()
if not gc then return nil end
local ok,cs=pcall(gc,sig)
if not ok or type(cs)~="table" then return nil end
return #cs
end
function CN.Probe()
CN.rows={}
CN.n=0
CN.lastAt=os.clock()
if not CN.API() then return CN.rows,"本机没有 getconnections" end
local ch,hum,root=nil,nil,nil
local okG,a,b,c=pcall(function() return SYS.GC() end)
if okG then ch,hum,root=a,b,c end
local function add(label,getSig)
local ok,sig=pcall(getSig)
local n=(ok and sig) and CN.Count(sig) or nil
CN.rows[#CN.rows+1]={label=label,n=n}
end
add("工作区 子对象增删",function() return WS and WS.ChildAdded end)
add("玩家 加入",function() return Players and Players.PlayerAdded end)
add("玩家 离开",function() return Players and Players.PlayerRemoving end)
if hum then
add("自己 血量变化",function() return hum:GetPropertyChangedSignal("Health") end)
add("自己 速度变化",function() return hum:GetPropertyChangedSignal("WalkSpeed") end)
end
if root then
add("自己 位置变化",function() return root:GetPropertyChangedSignal("Position") end)
end
local cnt=0
for i=1,#CN.rows do if CN.rows[i].n then cnt=cnt+1 end end
CN.n=cnt
return CN.rows,nil
end
local IDLE={ on=false }
K.Idle=IDLE
function IDLE.Set(on)
on=on and true or false
IDLE.on=on
SC.Pause(on)
if on then
NET.Spy(false)
if W.on.values then W.Values(false) end
if W.on.attrs then W.Attrs(false) end
if W.on.tags then W.Tags(false) end
if W.on.ents then W.Entities(false) end
K.Log("idle","进入静默: 调度器挂起 / 下行监听停 / 属性·值·标签·实体监听全摘")
else
K.Log("idle","退出静默: 调度器恢复")
end
return IDLE.on
end
function SYS.V3Boot()
local K2=SYS.K
if not K2 then return end
if K2._booted then return end
K2._booted=true
K2.Net.Track()
K2.Guard("v3.prof",K2.Sched.Profile,false)
if true then
K2.Sched.Add("V3Rebind",function()
if K2.Net.PendingN()>0 then K2.Guard("v3.rebind",K2.Net.Rebind) end
K2.Guard("v3.health",K2.Net.HealthRebind)
end,{sig=RS.Heartbeat,every=3})
end
print("[CheatMenu] ✅ V3 内核就绪: 统一调度 / 事件总线 / 错误显形 / hook 归属 / 事件图谱")
end
function SYS.V3Teardown()
local K2=SYS.K
if not K2 then return end
K2.Guard("v3.net",K2.Net.DetachAll)
K2.Guard("v3.bus",K2.Bus.OffAll)
K2.Guard("v3.hook",K2.Hook.RestoreAll)
K2.Idle.on=false
K2.Sched.Pause(false)
K2.Sched.Clear()
end
end
do
local CFG=SYS.N.Cfg
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
data._resumeT = os.time()
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
Fly=true, Noclip=true, Speed=true, InfiniteJump=true, JumpBoost=true, GodMode=true, NoFall=true, FullBright=true, PerfBoost=true, TPEnabled=true, NoCollide=true, ESP=true, ESPNameTag=true, ESPItem=true, ESPWeapon=true, ESP_NPC=true, ESP_Pick=true, ESP_Door=true, ESP_Mini=true, BlockHandlers=true, QuickInteract=true, AutoHide=true, AutoDodge=true, FreeCam=true, Tracer=true, ESP_WallWise=true, HUD_Info=true, DeadRails_LockHp=true, DeadRails_NoFlop=true, TracerAll=true, EventAtlas=true, LazyRebind=true, WatchPlayers=true, AttrWatch=true, ValueWatch=true, TagWatch=true, EntityWatch=true, NetSpy=true, IdleStealth=true, PerfProfile=true, CB_Aim=true, CB_Silent=true, CB_Fire=true, CB_PauseMove=true, CB_Predict=true, CB_Team=true, CB_Wall=true, CB_Stealth=true, CB_Ballistic=true, CB_TgtStrict=true, CB_SnapFire=true, CB_OnlyAlive=true, CB_SkipFF=true, CB_Melee=true, TrapImmune=true, UA_Auto=true, UA_Mouse=true, UA_Human=true, CB_HitboxFirst=true, PathKey=true, NightVision=true, NightVisionPro=true, Lantern=true, SuperLight=true, NoFog=true, NoShadow=true, NoDeath=true, NoKnock=true, CB_SilentAim=true, CB_BulletWall=true, CB_BlockRay=true, Gun_NoRecoil=true, Gun_InfAmmo=true, Gun_InstantReload=true, Gun_NoDrop=true, Gun_NoCooldown=true, Gun_InfItem=true, Gun_AimStable=true, Gun_NoSpread=true, CB_360=true, CB_SilentNoTurn=true, NoAggro=true, Prot_AntiAdmin=true, PC_LoopTP=true, PC_OnHead=true, PC_Orbit=true, PC_Stare=true, PC_Follow=true, ACBlock=true, AntiRevertExtra=true, CamGuard=true, PosRebound=true, CB_BlockDeathSignal=true, AntiRevert=true, KickGuard=true, KickRejoin=true, SpeedJitter=true, FlyGround=true, ConnAudit=true, Prot_Survive=true, Prot_Kick=true, Prot_Revert=true,
SpeedCap=true,
ACBlock=true, KickGuard=true, KickRejoin=true, AntiRevert=true, AntiRevertExtra=true, PosRebound=true, GodMode=true, NoFall=true, DeadRails_LockHp=true, DeadRails_NoFlop=true, UA_Auto=true, UA_Mouse=true, UA_Human=true, CB_BlockRay=true, FlyGround=true, Gun_InfAmmo=true, Gun_InstantReload=true, Gun_NoRecoil=true, Gun_NoDrop=true, Gun_NoCooldown=true, Gun_InfItem=true, Gun_AimStable=true, Gun_NoSpread=true, MenuMouse=true,
SpeedJitter=true, PathKey=true, CB_BlockDeathSignal=true, CB_HitboxFirst=true, CB_OnlyAlive=true, CB_Melee=true, CB_PauseMove=true, CB_Stealth=true, CB_SkipFF=true, BlockHandlers=true, EventAtlas=true, NetSpy=true, LazyRebind=true, ConnAudit=true, WatchPlayers=true, AttrWatch=true, ValueWatch=true, TagWatch=true, EntityWatch=true, IdleStealth=true, PerfProfile=true,
FootstepESP=true,
AutoClaim=true, AutoPickup=true, AutoRespawn=true, AutoShop=true, AutoTeam=true, AutoEmote=true,
TransSili=true,
LockSpeed=true, LockJump=true, LockGravity=true,
WPShow=true, WPKey=true,
FX_Enable=true,
AutoLowPing=true,
CB_MissMode=true,
PC_Freeze=true,
PG_Spin=true, PG_SpinHit=true, PG_FlyHit=true, PG_WalkHit=true,
PG_HideHit=true, PG_OrbitTool=true, PG_BlackHole=true, PG_KillNear=true,
Prot_AntiAC=true, Prot_AntiTP=true,
Key_Auto=true,
AutoRebirth=true, RebirthCheck=true,
Prot_HideGui=true,
Prot_SpeedCap=true }
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
local _rt = tonumber(data._resumeT) or 0
if _rt > 0 and (os.time() - _rt) <= 60 and type(data.T_) == "table" then
local n = 0
for k, v in pairs(data.T_) do
if SYS.T_[k] ~= nil and type(v) == "boolean" and not (SYS.REMOVED_FEATURES and SYS.REMOVED_FEATURES[k]) then
SYS.T_[k] = v
n = n + 1
end
end
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
local pending=false
function SYS.QueueSave()
return
end
function SYS.SetLoop(k,on,sig,fn)
if on then
if not sig then return end
if SYS.K.Idle and SYS.K.Idle.on then
SYS.K.Idle.Set(false)
P(function() SYS.Notify("🙈 有功能被打开, 已自动退出空闲静默",SYS.CY and SYS.CY.yellow) end)
end
SYS.K.Sched.Add(k,fn,{sig=sig})
SYS.Loops[k]={sched=true}
SYS._LoopRec=SYS._LoopRec or {}
SYS._LoopRec[k]={sig=sig,fn=fn,conn=nil,sched=true}
else
SYS.K.Sched.Del(k)
if SYS.Loops[k] then SYS.Loops[k]=nil end
if SYS._LoopRec then SYS._LoopRec[k]=nil end
end
end
SYS._FireSig=SYS._FireSig or {}
SYS._FireOrder=SYS._FireOrder or {}
SYS._fireLog=SYS._fireLog or {}
function SYS.SpeedTarget()
local a=tonumber(SYS.C_.SpeedAbs)
if a and a>0 then return a end
return (SYS.Orig.WalkSpeed or 16)*(tonumber(SYS.C_.SpeedMult) or 1)
end
function SYS.FlyTarget()
local a=tonumber(SYS.C_.FlyAbs)
if a and a>0 then return a end
return (SYS.Orig.WalkSpeed or 16)*(tonumber(SYS.C_.FlySpeed) or 6)
end
function SYS.SmoothSpd(base)
local now=os.clock()
local dt=now-(SYS._smT or now)
SYS._smT=now
local cur=SYS._smCur
if type(cur)~="number" or dt>0.4 then SYS._smCur=base return base end
local tau=math.max(0.05,tonumber(SYS.C_.MoveSmooth) or 0.25)
local k=math.min(1,dt/tau)
local nx=cur+(base-cur)*k
SYS._smCur=nx
return nx
end
function SYS.SpawnLoop(fn)
local co=task.spawn(function()
SYS.K.Guard("spawnloop",fn)
end)
return SYS.TT(co)
end
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
local NEGC={}
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
local key2="G"..ck
local neg=NEGC[key2]
if neg and (os.clock()-neg)<8 then return nil end
local want=tostring(n)
local leaf=want:match("([^%.]+)$") or want
local q,qt,dep,nodes={ RStorage },1,{ [RStorage]=0 },0
local qh,found=1,nil
local budget2=6000
while qh<=qt and budget2>0 do
local node=q[qh] qh=qh+1
nodes=nodes+1 budget2=budget2-1
local d=dep[node] or 0
if d<6 then
local ok4,kids=pcall(function() return node:GetChildren() end)
if ok4 and type(kids)=="table" then
for i=1,#kids do
local c=kids[i]
if c.Name==want or c.Name==leaf then
local r=ok2(c)
if r then found=r break end
end
if c:IsA("Folder") or c:IsA("Configuration") then
dep[c]=d+1 qt=qt+1 q[qt]=c
end
end
end
end
if found then break end
end
if found then RRemoteCache[ck]=found return found end
NEGC[key2]=os.clock()
return nil
end
function SYS.REvent(n) return findRemote(n,"RemoteEvent") end
function SYS.REventU(n) return findRemote(n,"UnreliableRemoteEvent") end
function SYS.RFunction(n) return findRemote(n,"RemoteFunction") end
function SYS.Fire(n,...)
local r=SYS.REvent(n) if not r then return false end
if SYS.T_.ACBlock and type(SYS.RemoteRisk)=="function" and SYS.RemoteRisk(r.Name) then
SYS._ACBlockedN=(SYS._ACBlockedN or 0)+1
SYS._ACBlockedLast=r.Name
return false
end
local a=table.pack(...)
local sig=""
do
local parts={}
for i=1,math.min(a.n,6) do
parts[#parts+1]=((typeof and typeof(a[i])) or type(a[i]))
end
sig=a.n..":"..table.concat(parts,"|")
end
local SIG=SYS._FireSig
if SIG then
local rec=SIG[r.Name]
if rec==nil then
if #SYS._FireOrder>=32 then
local old=table.remove(SYS._FireOrder,1)
SIG[old]=nil
end
SIG[r.Name]={ sig=sig, n=1 }
SYS._FireOrder[#SYS._FireOrder+1]=r.Name
elseif rec.sig==sig then
rec.n=rec.n+1
else
if rec.n>=(tonumber(SYS.C_.FireTypeSigN) or 3) then
SYS._FireTypeWarn=(SYS._FireTypeWarn or 0)+1
if SYS._FireTypeWarn<=5 then
P(SYS.Notify,("⚠ 这条上行的参数类型和以往不一样(已照发, 不拦): %s\n   以往 %s / 这次 %s"):format(r.Name,rec.sig,sig),SYS.CY.yellow)
end
end
rec.sig=sig rec.n=1
end
end
do
local t=SYS._fireLog
if type(t)=="table" then
t[#t+1]=os.clock()
while #t>400 do table.remove(t,1) end
end
end
local jitter=math.random()*(SYS.C_.FireJitter or 0.03)
if jitter>0.001 then
return P(function()
pcall(function() task.wait(jitter) end)
r:FireServer(table.unpack(a,1,a.n))
end)
end
return P(function() r:FireServer(table.unpack(a,1,a.n)) end)
end
function SYS.OnRemote(n,cb)
return SYS.K.Net.Bind(n,cb)
end
end
do
local HONEY={"exploiter","exploiters","cheater","cheaters","cheat","cheating","hacker",
"hackers","hacking","abuser","abusers",
"hack","hacks","wallhack","wallhacks","aimbot","aimbots","triggerbot",
"silentaim","noclip","godmode","godmodeon","speedhack","flyhack",
"infammo","infiniteammo","autofarm","autoclicker","espuser","flyexploit"}
local ADMIN={"admin","punish","punishment","registercommand","logcommand",
"updateuserroles","invokeservercommand","createuser"}
local ADMIN_WEAK={"ban","unban","kick","report"}
local ADMIN_CTX={"player","players","user","users","account","accounts","client",
"member","members","name","id","moderator","staff"}
local PHRASE_ADMIN_WEAK={"banplayer","banuser","unbanplayer","unbanuser","kickplayer",
"kickuser","banhammer","banlist","bannedusers","bannedplayer",
"playerreport","reportplayer","reportuser","ban_player","ban_user",
"unban_player","unban_user","kick_player","kick_user",
"report_player","report_user","ban_list","moderateplayer"}
local LOGNET={"log","logs","logging","audit","telemetry","analytics","anticheat","antiheat",
"detect","detection","monitor"}
local PHRASE_BUILTIN={"integritycheck","robloxreplicatedstorage","robloxgui","coregui",
"corepackages","robloxscriptservice",
"serverauthority","playermodule"}
local PHRASE_HONEY={"sticky note","i think i can cheat","my name is",
"godmode","triggerbot","infiniteammo","autofarm","silentaim",
"wallhack","speedhack","flyhack","autoclicker","no clip"}
local PHRASE_ADMIN={"register_command","log_command","invoke_server_command",
"update_user_roles","create_user","run_command"}
local function toks(name)
local s=name:gsub("(%l)(%u)","%1 %2")
s=s:gsub("(%u)(%u)(%l)","%1 %2%3")
s=s:gsub("_"," "):gsub("%."," "):lower()
local t={}
for w in s:gmatch("%w+") do t[#t+1]=w end
return t
end
local function flat(s) return (tostring(s):gsub("[%s_%.%-]","")) end
function SYS.RemoteRisk(name)
if type(name)~="string" or #name==0 then return nil end
local low=name:lower()
local lf=flat(low)
local function phr(list) for i=1,#list do if lf:find(flat(list[i]),1,true) then return true end end return false end
if phr(PHRASE_BUILTIN) then
return "ℹ Roblox 官方自带(与游戏无关) —— 不是游戏的反作弊, 无需刻意避开"
end
if phr(PHRASE_HONEY) then
return "⛔ 蜜罐嫌疑(名字点名开挂/作弊) —— 千万别 FireServer"
end
if phr(PHRASE_ADMIN) then
return "⛔ 后台命令通道(conch/管理类) —— 触发=自报家门"
end
if phr(PHRASE_ADMIN_WEAK) then
return "⛔ 管理后台/处罚通道(ban/kick/report 固定搭配) —— 触发=自报家门"
end
local tk=toks(name)
local isRoblox=false
for i=1,#tk do if tk[i]=="roblox" then isRoblox=true break end end
if isRoblox then
return "ℹ Roblox 官方自带(与游戏无关) —— 不是游戏的反作弊, 无需刻意避开"
end
for i=1,#tk do
local w=tk[i]
for j=1,#HONEY do if w==HONEY[j] then
return "⛔ 蜜罐嫌疑(名字点名开挂/作弊) —— 千万别 FireServer" end end
end
for i=1,#tk do
local w=tk[i]
for j=1,#ADMIN do if w==ADMIN[j] then
return "⛔ 管理后台/处罚通道 —— 触发=自报家门" end end
end
local hasCtx=false
for i=1,#tk do
for j=1,#ADMIN_CTX do if tk[i]==ADMIN_CTX[j] then hasCtx=true break end end
if hasCtx then break end
end
if hasCtx then
for i=1,#tk do
local w=tk[i]
for j=1,#ADMIN_WEAK do if w==ADMIN_WEAK[j] then
return "⛔ 管理后台/处罚通道(含 ban/kick/report + 玩家词) —— 触发=自报家门" end end
end
end
for i=1,#tk do
local w=tk[i]
for j=1,#LOGNET do if w==LOGNET[j] then
return "⚠ 审计/日志通道 —— 通常被反作弊收集, 不要主动触发" end end
end
return nil
end
function SYS.IsHoneypot(obj)
local o=obj
for _=1,4 do
if not o then break end
local nm=o.Name
if type(nm)=="string" and nm~="" then
local low=nm:lower()
local lf=flat(low)
for i=1,#PHRASE_HONEY do
if lf:find(flat(PHRASE_HONEY[i]),1,true) then return true end
end
local tk=toks(nm)
for j=1,#tk do
local w=tk[j]
for k=1,#HONEY do if w==HONEY[k] then return true end end
end
end
o=o.Parent
end
return false
end
end
function SYS.KeyCodeOf(name)
if type(name)~="string" or name=="" then return nil end
local ok,k=pcall(function() return Enum.KeyCode[name] end)
if ok and k~=nil and typeof(k)=="EnumItem" then return k end
return nil
end
do
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
end
do
local function safeAscii(s, maxLen)
local r=tostring(s or "")
r=r:gsub('[\\/:*?"<>|]',"_")
r=r:gsub("[^%w%._%-]","")
r=r:gsub("_+","_")
r=r:gsub("^_+",""):gsub("_+$","")
if maxLen and #r>maxLen then r=r:sub(1,maxLen) end
if r=="" then r="srv" end
return r
end
SYS.SafeAscii=safeAscii
end
do
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
end
do
function SYS.HookAPI()
local names={"hookfunction","hookfunc","replaceclosure"}
for i=1,#names do
local f=rawget(_G,names[i])
if type(f)=="function" then return f end
end
return nil
end
SYS._Hooks={}
function SYS.SafeHook(target,wrapper,tag)
if type(target)~="function" then return nil,"目标不是函数" end
local orig,err=SYS.K.Hook.Set(target,wrapper,tag or "?","hook")
if not orig then return nil,err or "hookfunction 不可用(按原则不动手)" end
SYS._Hooks[target]={orig=orig,tag=tag or "?"}
return orig
end
function SYS.SafeUnhook(target)
local rec=SYS._Hooks[target]
if not rec then
if SYS.K.Hook.Has(target) then return SYS.K.Hook.Restore(target) end
return false
end
if type(restorefunction)=="function" then
pcall(restorefunction,target)
else
local HF=SYS.HookAPI()
if HF then pcall(HF,target,rec.orig) end
end
SYS._Hooks[target]=nil
SYS.K.Hook.Drop(target)
return true
end
function SYS.UnhookAllSafe()
local n=0
for t in pairs(SYS._Hooks) do
if SYS.SafeUnhook(t) then n=n+1 end
end
n=n+SYS.K.Hook.RestoreAll()
return n
end
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
local gap=5*(0.85+math.random()*0.3)
if now-(SYS._afkAt or 0)<gap then return end
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
end
do
function SYS.RestoreMouse()
UIS.MouseBehavior=Enum.MouseBehavior.Default
UIS.MouseIconEnabled=true
SYS.MenuPrevMouseBehav=nil SYS.MenuPrevMouseIcon=nil
SYS.FCPrevBehav=nil SYS.FCPrevIcon=nil
end
end
do
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
LT.Ambient=Color3.new(1,1,1)
LT.OutdoorAmbient=Color3.new(1,1,1)
for _,o in ipairs(LT:GetChildren()) do
if o:IsA("Atmosphere") and (o.Density and o.Density>0.001) then o.Density=0.001 end
if o:IsA("ColorCorrectionEffect") then
if o.Brightness and o.Brightness~=0 then o.Brightness=0 end
if o.Contrast and o.Contrast~=0 then o.Contrast=0 end
if o.Saturation and o.Saturation~=0 then o.Saturation=0 end
end
end
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
function SYS.GetBrainrotBaseCPS(tool)
if not tool then return nil end
local base=CPS[tool.Name]
if base then return base end
local a=tool:GetAttribute("CPS") or tool:GetAttribute("BaseCPS")
if typeof(a)=="number" then return a end
return nil
end
function SYS.GetBrainrotCPS(tool)
if not tool then return nil end
local base=CPS[tool.Name]
if not base then
local a=tool:GetAttribute("CPS") or tool:GetAttribute("BaseCPS")
if typeof(a)=="number" then base=a else return nil end
end
local lv=math.clamp(math.floor(tonumber(tool:GetAttribute("Level")) or 1),1,75)
local mut=tostring(tool:GetAttribute("Mutation") or "")
local lm=tonumber(SYS.C_.SellLvMul)
if not lm or lm<=0 then lm=1.25 end
return base*(MutBuff[mut] or 1)*(lm^(lv-1))
end
function SYS.DescribeBrainrotCPS(tool)
if not tool then return "?" end
local base,src=nil,nil
base=CPS[tool.Name]
if base then src="内置表" end
if not base then
local a=tool:GetAttribute("CPS") or tool:GetAttribute("BaseCPS")
if typeof(a)=="number" then base=a src="物品属性" end
end
if not base then return "(不认识这个物品, 无法估算 CPS —— 不会参与售卖)" end
local lv=math.clamp(math.floor(tonumber(tool:GetAttribute("Level")) or 1),1,75)
local mut=tostring(tool:GetAttribute("Mutation") or "")
local lm=tonumber(SYS.C_.SellLvMul); if not lm or lm<=0 then lm=1.25 end
return ("base=%.0f(%s) · lv=%d · 词缀=%s(×%.2f) · 等级乘数=%.2f^%d"):format(
base,src,lv,(mut=="" and "无" or mut),(MutBuff[mut] or 1),lm,lv-1)
end
local function isEntityTool(t)
if not t or not t:IsA("Tool") then return false end
local ok,ht=pcall(function() return t:HasTag("EntityTool") end)
return ok and ht
end
local EXCLUSIVE_KEEP = {
"W","Dragon Cannelloni","Spaghetti Tualetti","Esok Sekolah","Job Job Job Sahur",
"Yess My Examen","Lucky Kick","Hippocopter","Auto Grizzlioni","Los Bombardinos","Rocky",
"Hat Tricky","GOAT","Bronze Block Medali","Golden Block Cuppy","Silver Block Cuppy",
"Bronze Block Cuppy","Golden Block Medali","Silver Block Medali","Stadoini",
"Cone Cone Cone Sahur","Ballberto","Soccerdino","Netini Goalini","Orangutango Supremo",
"Croakumber","Lampuccio Raccoonelli","Tuki Tuki Taco","Professor Tigrellini",
"Patagotitan","Frigorex","Velacoraptor","Bicletairussaurus","Jet Jet Raptoret",
"Tricerabob","Teacherrina","Locko Blocko","Scuolabus Giraffini","Donutello",
"Professor Penneroni","Brain Mogger",
}
local EXCLUSIVE_KEEP_SET = {}
for _, nm in ipairs(EXCLUSIVE_KEEP) do EXCLUSIVE_KEEP_SET[nm] = true end
SYS.ExclusiveKeepSet = EXCLUSIVE_KEEP_SET
local function isExclusiveTool(t)
if not t then return false end
if EXCLUSIVE_KEEP_SET[t.Name] then return true end
local n = string.lower(t.Name)
local exclusiveKeywords = {
"exclusive", "独家", "专属", "limited", "限定",
"vip", "%", "x2", "x5", "x10", "x20", "x50",
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
if rf then
local ok,res=pcall(function() return rf:InvokeServer() end)
if ok then print("[Sell] ✅ 返回:",tostring(res)) return true end
end
local re=SYS.REvent("B_Sell")
if re then
local ok=P(function() re:FireServer() end)
if ok then print("[Sell] ✅ 已发 rev_B_Sell (这条没有返回值)") return true end
end
print("[Sell] ❌ ref_B_Sell / rev_B_Sell 都没找到")
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
print(("[Sell] 没有低于 %d 的脑红（按背包显示的 CPS 判）"):format(SYS.AFK_Sell.MinCPS))
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
print(("[Sell] [%d] %s · CPS=%.0f  ⟵ %s"):format(
totalSold+1,tool.Name,e.CPS or 0,
SYS.GetBrainrotCPS(tool) or 0,
SYS.DescribeBrainrotCPS and SYS.DescribeBrainrotCPS(tool) or ""))
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
print("[Sell] ✅ 本轮卖完 -> 已自动关闭「自动售卖」(要再卖请重新打开)")
end
if SYS.T_.SellThresholdEnabled then
SYS.T_.SellThresholdEnabled=false
pcall(function()
if SYS.SwitchOnChange and SYS.SwitchOnChange["SellThresholdEnabled"] then
SYS.SwitchOnChange["SellThresholdEnabled"](false)
end
end)
print("[Sell] ✅ 本轮卖完 -> 已自动关闭「启用 CPS 门槛」")
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
local all={}
local function scan(list)
if not list then return end
for _,t in ipairs(list:GetChildren()) do
if isEntityTool(t) then
if not isExclusiveTool(t) then
local cps=SYS.GetBrainrotCPS(t)
local base=SYS.GetBrainrotBaseCPS(t)
local pass=(cps~=nil and cps<threshold)
all[#all+1]={Name=t.Name,CPS=cps or 0,Base=base or 0,Pass=pass}
if pass then
table.insert(picks,{Name=t.Name,CPS=cps})
end
end
end
end
end
scan(LP.Character)
scan(LP:FindFirstChild("Backpack"))
table.sort(picks,function(a,b) return a.CPS<b.CPS end)
table.sort(all,function(a,b) return a.CPS<b.CPS end)
return picks,threshold,all
end
TT(task.spawn(function()
while not SYS.Unloaded do
task.wait(5*(0.85+math.random()*0.3))
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
local AFK={Kick=nil,LastBonus=0,BonusWin=0,WTool=nil,WToolT=0}
SYS.AFK=AFK
task.spawn(function()
task.wait(2)
OnRemote("KickData",function(v) if typeof(v)=="number" then AFK.Kick=v end end)
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
local GymDiag = { tagWarn = false, nameWarn = false, emptyWarn = false, enterFail = false,
toolWarn = false, recogWarn = false }
local function gymOnce(key, fmt, ...)
if GymDiag[key] then return end
GymDiag[key] = true
print(("[Gym] " .. fmt):format(...))
end
SYS.GymDiag = GymDiag
local function gymPrepareRoot()
pcall(function()
local _, hum, root = GC()
if hum then hum:UnequipTools() end
if root then
root.Anchored = false
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end
end)
end
local GYM_WEIGHT_NAMES = {
["Wooden Stick"]=true, ["Bone Barbell"]=true, ["Stone Block"]=true, ["Copper Plate"]=true,
["Iron Plate"]=true, ["Ice Barbell"]=true, ["Donut Barbell"]=true, ["Golden Barbell"]=true,
["Heaven Plate"]=true, ["Mega Golden Barbell"]=true, ["Neon Pulse"]=true,
["Giant Gold Star Barbell"]=true, ["Emerald Barbell"]=true, ["Planet Barbell"]=true,
["Big Jupiter"]=true, ["Black Hole Barbell"]=true,
}
SYS.GymWeightNames = GYM_WEIGHT_NAMES
local GymLastPart, GymLastMachine = nil, nil
local function liveMachines()
local r = {}
if not CS then return r end
local tagN = 0
local ok, t = pcall(CS.GetTagged, CS, "LiftMachine")
if ok and type(t) == "table" then
tagN = #t
for _, m in ipairs(t) do
if m and m.Parent and m:IsDescendantOf(WS) then
table.insert(r, m)
end
end
end
if #r > 0 then return r end
local nameHits = {}
pcall(function()
local me = LP and LP.Character
for _, d in ipairs(WS:GetDescendants()) do
if d:IsA("Model") and d.Parent and d ~= me and not (me and d:IsDescendantOf(me)) then
local nm = tostring(d.Name):lower()
if nm:find("liftmachine", 1, true) or nm:find("lift_machine", 1, true)
or nm:find("lift machine", 1, true) then
table.insert(nameHits, d)
end
end
end
end)
if #nameHits > 0 then
gymOnce("nameWarn",
"标签 \"LiftMachine\" 一个都没有(GetTagged 返回 %d 个)，但按【名字】找到 %d 个候选 -> 改用名字兜底。首个: %s",
tagN, #nameHits, tostring(nameHits[1].Name))
return nameHits
end
gymOnce("emptyWarn",
"找不到任何健身机器: 标签 \"LiftMachine\" %d 个 / 按名字(liftmachine|lift_machine|lift machine) 0 个。"
.. "若游戏里确实有机器，请把机器在 Explorer 里的【准确名字/路径】告诉我，我按真名适配。", tagN)
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
gymPrepareRoot()
local _, _, root = GC()
if not root then return false end
if root.Anchored then
gymOnce("enterFail", "角色处于 Anchor 状态且反锚定失败 -> 传送会被弹回(检查飞行/隐身类功能是否在开)")
return false
end
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
local function isGymWeight(t)
if not t or not t:IsA("Tool") then return false end
local ok, ht = pcall(function() return t:HasTag("SquatTool") end)
if ok and ht then return true end
return GYM_WEIGHT_NAMES[t.Name] == true
end
local function ensureGymTool()
local _, hum, _ = GC()
if not hum then return nil end
for _, t in ipairs(hum.Parent:GetChildren()) do
if isGymWeight(t) then return t end
end
local bp = LP:FindFirstChild("Backpack")
local target
if bp then
for _, t in ipairs(bp:GetChildren()) do
if isGymWeight(t) then target = t break end
end
end
if not target then
gymOnce("toolWarn",
"背包/角色里找不到举铁道具（按 [SquatTool] 标签 和 16 档配重名 都查过）-> 传送过去也无法开始举铁。"
.. "需要先拿到/装备配重（Wooden Stick → Black Hole Barbell），或把道具的准确名字告诉我")
return nil
end
pcall(function() hum:UnequipTools() end)
task.wait(0.08)
for _ = 1, 3 do
pcall(function() hum:EquipTool(target) end)
task.wait(0.15)
if target.Parent == hum.Parent then return target end
end
gymOnce("toolWarn", "举铁道具(%s) 找到了，但连试 3 次 EquipTool 都没穿上",
tostring(target.Name))
return nil
end
local function waitLiftMachineRecognition(timeout)
local deadline = os.clock() + (timeout or 1.0)
while os.clock() < deadline do
local m = math.max(1, tonumber(LP:GetAttribute("liftMachine")) or 1)
if m > 1 then return true end
task.wait(0.03)
end
return (math.max(1, tonumber(LP:GetAttribute("liftMachine")) or 1)) > 1
end
local function enterGymMachine(machine)
if not machine or not machine.Parent then return false end
local candidates = liftMachineCandidateParts(machine)
if #candidates == 0 then
gymOnce("enterFail", "机器 %s 里找不到任何可作为落点的 BasePart -> 跳过它",
tostring(machine.Name))
return false
end
if GymLastPart and GymLastPart.Parent and machine == GymLastMachine then
table.insert(candidates, 1, { Part = GymLastPart, Score = math.huge })
end
local maximum = math.min(#candidates, 8)
local lastStage = "未开始"
for i = 1, maximum do
local part = candidates[i].Part
if not moveToLiftMachinePart(part) then
lastStage = ("第 %d/%d 个落点【传送没成功】(落点=%s; 可能角色被别人/游戏 Anchor 住了)")
:format(i, maximum, tostring(part.Name))
else
local tool = ensureGymTool()
if not tool then
lastStage = "传送到位了，但【拿不到举铁道具】-> 无法开始"
elseif not waitLiftMachineRecognition(0.9) then
lastStage = "传送 + 装备都成功，但游戏没把 liftMachine 属性置为 >1（= 站位没被认可）"
else
print("[Gym] ✅ 已进入 LiftMachine:", machine.Name)
GymLastPart, GymLastMachine = part, machine
GymDiag.enterFail = false
return true
end
end
gymPrepareRoot()
task.wait(0.05)
end
gymOnce("enterFail", "进入 %s 失败，卡在: %s", tostring(machine.Name), lastStage)
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
local HOST="http://127.0.0.1:8080"
local KEY="rk_4a56fc43faa5edb9f7a0cafd4ad3e91f"
local MODEL="hymt2-7b"
local function hostOf() return HOST end
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
local T2O_N=0
local RV_CAP=2000
local FAIL_BASE,FAIL_CAP,FAIL_MAXN=3,300,4000
local NET_STREAK_MAX,NET_GATE_S=3,4
local HOOK_MAX=6000
local HOOK_PER_SEC=200
local RETRY_WIN=1.0
local RETRY_WIN_N=20
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
local function splitPrefixRich(raw)
if type(raw)~="string" then return "",raw or "" end
local p1,c1=raw:match("^(<font[^>]*>.-:</font>%s*)(.+)$")
if p1 and c1 and c1~="" then return p1,c1 end
if not raw:find("<",1,true) then
local p3,c3=raw:match("^(.-[:：]%s*)([^/%s].*)$")
if p3 and c3 and c3~="" and #p3<=40 and not raw:match("^%a[%w%+%-%.]*://") then return p3,c3 end
end
return "",raw
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
local NAME_SLOT_L, NAME_SLOT_R = "〔", "〕"
local function protectNames(text)
if type(text)~="string" or text=="" then return text, function(x) return x end end
if PlayerNameCount<0 or PlayerDirty then refreshPlayerNames() end
if PlayerNameCount<=0 then return text, function(x) return x end end
local idx, orig = {}, {}
local masked = text:gsub("[%w_]+", function(tok)
if PlayerNames[tok:lower()] then
local i = idx[tok:lower()]
if not i then
i = #orig + 1
idx[tok:lower()] = i
orig[i] = tok
end
return NAME_SLOT_L..i..NAME_SLOT_R
end
return tok
end)
if #orig==0 then return text, function(x) return x end end
local function restore(s)
if type(s)~="string" then return s end
return (s:gsub(NAME_SLOT_L.."(%d+)"..NAME_SLOT_R, function(d)
local i = tonumber(d)
return (i and orig[i]) or d
end))
end
return masked, restore, true
end
Trans.protectNames=protectNames
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
if Trans.isSelf(text) or Trans.alreadyOurs(text) then return end
if Trans.Orig2Trans and Trans.Orig2Trans[text] then return end
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
if s:match("^[%d%s%.,:：]+[KkMmBbTtQq]?%s*$") then return false end
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
local pre,core=splitPrefixRich(raw)
local corePlain=stripRich(core)
v.pre=pre v.core=core v.tagged=(core~=corePlain)
if corePlain=="" then
v.skip=true
elseif hasChinese(corePlain) then
local segs=splitSegments(corePlain)
local hasF=false
for _,seg in ipairs(segs) do
if not seg.han and Trans.shouldTranslate(seg.text,isChat) then hasF=true break end
end
if hasF then
v.mixed=true v.segs=segs v.plain=corePlain v.nk=normalizeKey(corePlain)
else
v.skip=true
end
elseif not Trans.shouldTranslate(corePlain,isChat) then
v.skip=true
else
v.plain=corePlain
v.nk=normalizeKey(corePlain)
if not v.tagged then v.loc=lookupLocal(corePlain) end
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
if Trans.clearRichCache then Trans.clearRichCache() end
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
local SENT_L,SENT_R="〖","〗"
local function maskSpecials(s)
if type(s)~="string" or s=="" then return s,{},0 end
local tok={} local n=0
local function prot(pat)
s=s:gsub(pat,function(m) n=n+1 tok[n]=m return SENT_L..n..SENT_R end)
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
s=s:gsub(SENT_L.."%s*(%d+)%s*"..SENT_R,function(d) local i=tonumber(d) return (i and tok[i]) or "" end)
end
s=s:gsub(SENT_L.."%s*%d+",""):gsub("%d+%s*"..SENT_R,"")
s=s:gsub(SENT_L,""):gsub(SENT_R,"")
return s
end
Trans.unmask=unmask
local function sentinelsOk(raw,n)
if not n or n<=0 then return true end
if type(raw)~="string" then return false end
local seen={}
for d in raw:gmatch(SENT_L.."%s*(%d+)%s*"..SENT_R) do
local i=tonumber(d)
if i then seen[i]=(seen[i] or 0)+1 end
end
for i=1,n do if seen[i]~=1 then return false end end
return true
end
Trans.sentinelsOk=sentinelsOk
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
local _offNotifyAt=0
function Trans.offlineHint(force)
local now=os.clock()
if not force and now-_offNotifyAt<90 then return end
_offNotifyAt=now
Trans._wasOffline=true
local msg="⚠️ 连不上本地翻译服务(127.0.0.1:8080) —— 先双击桌面「翻译模型开关.bat」把模型跑起来"
print("[Trans] "..msg)
pcall(function()
if SYS and SYS.Notify then SYS.Notify(msg,(SYS.CY and SYS.CY.yellow) or nil) end
end)
end
local function noteNetFail()
NetStreak=NetStreak+1
if NetStreak>=NET_STREAK_MAX then
NetGateUntil=os.clock()+NET_GATE_S
Trans.offlineHint(false)
end
end
local function noteNetOk()
NetStreak=0 NetGateUntil=0
if Trans._wasOffline then
Trans._wasOffline=false
pcall(function()
if SYS and SYS.Notify then SYS.Notify("✅ 本地翻译服务已恢复",(SYS.CY and SYS.CY.green) or nil) end
end)
end
end
Trans.netGateOn=netGateOn
local function backend()
return HOST,KEY,MODEL,(Trans.maxTok or MAX_TOK_FALLBACK),{temperature=SAMP_TEMP,top_p=SAMP_TOP_P,top_k=SAMP_TOP_K,repeat_penalty=SAMP_REP_PEN}
end
local function noteLat(dt)
Trans._adL=(Trans._adL or 0)+dt
Trans._adN=(Trans._adN or 0)+1
end
local function rawRequest(body,system,temp,maxTok,noGate)
if type(request)~="function" then return nil,true,false end
local url,key,model,bMaxTok,samp=backend()
local masked,tok,tokN=maskSpecials(body)
local payload=HS:JSONEncode({
model=model,
messages={ {role="system",content=system}, {role="user",content=masked} },
temperature=temp or samp.temperature, top_p=samp.top_p, top_k=samp.top_k,
repeat_penalty=samp.repeat_penalty,
max_tokens=maxTok or bMaxTok or MAX_TOK_FALLBACK, stream=false,
})
local t0=os.clock()
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
return nil,true,false
end
noteLat(os.clock()-t0)
local okd,d=pcall(function() return HS:JSONDecode(res.Body) end)
if not okd or type(d)~="table" then
Trans.Stats.netfail=Trans.Stats.netfail+1
if not noGate then noteNetFail() end
return nil,true,false
end
if not noGate then noteNetOk() end
local ch=d.choices
local c=type(ch)=="table" and ch[1]
local m=c and c.message
local v=m and m.content
if type(v)~="string" then return nil,false,false end
local lossy=not sentinelsOk(v,tokN)
v=trim(unmask(v,tok,tokN))
if v=="" then return nil,false,false end
return v,false,lossy
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
Trans.RichCache={}
local RichN=0
local RICH_CAP=4000
local function storeRich(core,val)
Trans.RichCache[core]=val
RichN=RichN+1
if RichN>RICH_CAP then Trans.RichCache={} RichN=0 end
end
function Trans.clearRichCache() Trans.RichCache={} RichN=0 end
local function tagNames(s)
local t={}
for tag in s:gmatch("<[^>]*>") do
local nm=tag:match("^</?%s*([%a!][%w%-_:]*)")
if nm then nm=nm:lower() t[nm]=(t[nm] or 0)+1 end
end
return t
end
local function tagNamesEq(a,b)
local A,B=tagNames(a),tagNames(b)
for k,v in pairs(A) do if B[k]~=v then return false end end
for k,v in pairs(B) do if A[k]~=v then return false end end
return true
end
Trans.tagNamesEq=tagNamesEq
local function tagsBalanced(s)
if type(s)~="string" then return false end
local stack={}
for tag in s:gmatch("<[^>]*>") do
local nm=tag:match("^</?%s*([%a!][%w%-_:]*)")
if nm then
nm=nm:lower()
if tag:match("^</") then
if stack[#stack]~=nm then return false end
stack[#stack]=nil
else
local selfClosed=(tag:sub(-2)=="/>") or (nm=="br") or (nm=="img") or (nm=="hr")
if not selfClosed then stack[#stack+1]=nm end
end
end
end
return #stack==0
end
Trans.tagsBalanced=tagsBalanced
local function tidyRich(res,src)
if type(res)~="string" then return nil end
res=trim(res)
if res=="" then return nil end
res=res:gsub("^%s*[Tt]ranslation%s*[:：]%s*","")
res=res:gsub("^%s*[Hh]ere is[^\n:：]*[:：]%s*","")
res=res:gsub("^%s*(翻译|译文|中文|汉化)%s*[:：]%s*","")
res=trim(res)
if res=="" then return nil end
local sp,rp=stripRich(src),stripRich(res)
if sp=="" then return nil end
if not hasChinese(sp) and rp:lower()==sp:lower() then return nil end
if #sp>=24 and #rp>#sp*3+60 then return nil end
return res
end
local function textRuns(s)
local runs={}
local i,n=1,#s
while i<=n do
local lt=s:find("<",i,true)
if not lt then runs[#runs+1]={i,n} break end
if lt>i then runs[#runs+1]={i,lt-1} end
local gt=s:find(">",lt,true)
if not gt then break end
i=gt+1
end
return runs
end
local function translateRuns(s)
local runs=textRuns(s)
if #runs==0 then return nil end
local out=s
local changed=false
for i=#runs,1,-1 do
local a,b=runs[i][1],runs[i][2]
local frag=s:sub(a,b)
if Trans.shouldTranslate(frag,false) then
local tr=Trans.translate(frag,3)
if tr and tr~="" and tr~=frag then
out=out:sub(1,a-1)..tr..out:sub(b+1)
changed=true
end
end
end
if changed and out~=s then return out end
return nil
end
Trans.translateRuns=translateRuns
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
local res,netFail,lossy=rawRequest(text,transPrompt(),0.1,Trans.maxTok or MAX_TOK_FALLBACK)
if res and not lossy then
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
local res,_,lossy=rawRequest(text,Trans.promptFor(c),0.1,Trans.maxTok or MAX_TOK_FALLBACK,true)
if not res or lossy then
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
local function runJob(key,fn,cbs)
Inflight[key]=cbs or {}
Trans.InflightN=Trans.InflightN+1
task.spawn(function()
local r=fn()
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
runJob(k,w.fn,w.cbs)
if Trans.WaitN>0 and Trans.InflightN<Trans.MaxConc then Trans.pumpQueue() end
end
function Trans.adaptTick()
local now=os.clock()
local t=Trans._adT
if not t then Trans._adT=now Trans._adL=0 Trans._adN=0 return end
if now-t<5 then return end
local n=Trans._adN or 0
local l=Trans._adL or 0
Trans._adT=now Trans._adL=0 Trans._adN=0
if n<4 then return end
local avg=l/n
local cap=Trans.MaxConcCap or Trans.MaxConc or 8
local minc=Trans.MinConc or 1
if avg>1.2 and Trans.MaxConc>minc then
Trans.MaxConc=math.max(minc,Trans.MaxConc-1)
elseif avg<0.6 and Trans.MaxConc<cap then
Trans.MaxConc=Trans.MaxConc+1
end
end
function Trans.request(text,prio,cb)
if Trans.Unloaded or type(text)~="string" or text=="" then
if cb then pcall(cb,nil) end return
end
if alreadyOurs(text) or not Trans.shouldTranslate(text,false) then
if cb then pcall(cb,nil) end return
end
do
local masked, restore, didMask = protectNames(text)
if didMask then
text = masked
local ocb = cb
cb = ocb and function(res)
local fixed = restore(res)
if type(fixed)=="string" and fixed:find(NAME_SLOT_L, 1, true) then
pcall(ocb, nil) return
end
pcall(ocb, fixed)
end or nil
end
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
local fn=function() return Trans.translate(text,prio) end
if Trans.InflightN>=Trans.MaxConc then
WaitQ[nk]={fn=fn,prio=prio,cbs=(cb and {cb}) or {}}
Trans.WaitN=Trans.WaitN+1
Trans.Stats.wait=Trans.WaitN
return
end
runJob(nk,fn,(cb and {cb}) or {})
end
function Trans.requestRich(core,prio,cb,isMixed)
if Trans.Unloaded or type(core)~="string" or core=="" then
if cb then pcall(cb,nil) end return
end
if not isMixed and not Trans.shouldTranslate(stripRich(core),false) then
if cb then pcall(cb,nil) end return
end
local rk="\2R\2"..normalizeKey(core)
local hit=Trans.RichCache[core]
if hit then Trans.Stats.hit=Trans.Stats.hit+1 if cb then pcall(cb,hit) end return end
if inCool(rk) or netGateOn() then if cb then pcall(cb,nil) end return end
local q=Inflight[rk]
if q then if cb then q[#q+1]=cb end return end
local w=WaitQ[rk]
if w then if cb then w.cbs[#w.cbs+1]=cb end return end
local fn=function() return Trans.translateRichCore(core,isMixed) end
if Trans.InflightN>=Trans.MaxConc then
WaitQ[rk]={fn=fn,prio=prio,cbs=(cb and {cb}) or {}}
Trans.WaitN=Trans.WaitN+1 Trans.Stats.wait=Trans.WaitN
return
end
runJob(rk,fn,(cb and {cb}) or {})
end
function Trans.translateRichCore(core,isMixed)
if Trans.Unloaded or type(core)~="string" or core=="" then return nil end
local rk="\2R\2"..normalizeKey(core)
if inCool(rk) or netGateOn() then return nil end
if not isMixed then
local res,netFail,lossy=rawRequest(core,transPrompt(),0.1,Trans.maxTok or MAX_TOK_FALLBACK)
if res and not lossy then
local v=tidyRich(res,core)
if v and tagNamesEq(core,v) and tagsBalanced(v) then
storeRich(core,v) clearFail(rk) markOutput(v)
return v
end
end
if netFail then
markFail(rk)
return nil
end
end
local v2=translateRuns(core)
if v2 then
storeRich(core,v2) clearFail(rk) markOutput(v2)
return v2
end
markFail(rk)
return nil
end
Trans.Trans2Orig={}
Trans.Orig2Trans={}
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
for i=1,4 do
task.wait(({0.08,0.25,0.6,1.2})[i])
if not obj or not obj.Parent or Trans.Unloaded then return end
local now=obj[field]
if now==raw then
pcall(function() obj[field]=newText end)
elseif now~=newText then
if not Trans.GhostWarn then
Trans.GhostWarn=true
print(("[Trans] ⚠ 控件被游戏改写成第三个值(重影来源): 原文=%q / 我方译文=%q / 游戏写成=%q")
:format(tostring(raw):sub(1,40),tostring(newText):sub(1,40),tostring(now):sub(1,40)))
end
return
end
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
local TextLastAt=setmetatable({},{__mode="k"})
local TextHookedN=0
local TextWin = setmetatable({}, {__mode="k"})
local function onTextChanged(obj)
if Trans.Unloaded or not Trans.UIScanActive then return end
local okc,c0=pcall(function() return obj.Text end)
if okc and Trans.isSelf(c0) then return end
local now=os.clock()
local last=TextLastAt[obj]
if last and now-last<RETRY_GAP then return end
TextLastAt[obj]=now
local w=TextWin[obj]
if not w or now-w.t>RETRY_WIN then
TextWin[obj]={t=now,n=1}
else
w.n=w.n+1
if w.n>RETRY_WIN_N then return end
end
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
function Trans.processRichLabel(obj,field,cur,v,isChat)
if not obj or not obj.Parent or Trans.Unloaded then return end
field=field or "Text"
local core,pre,pl=v.core,v.pre,v.plain
local hit=Trans.RichCache[core]
if hit then
local tr=biText(pl,hit)
local newText=pre..tr
if writeProp(obj,field,cur,newText) then
Trans.Stats.hit=Trans.Stats.hit+1
remember(cur,newText,pl,stripRich(tr))
end
return
end
if not Trans.reqOn(isChat) then return end
Trans.requestRich(core,isChat and 1 or 3,function(res)
if not res or res=="" then return end
if not obj or not obj.Parent or Trans.Unloaded then return end
local ok2,now=pcall(function() return obj[field] end)
if not ok2 or now~=cur then return end
local tr=biText(pl,res)
local newText=pre..tr
if writeProp(obj,field,cur,newText) then remember(cur,newText,pl,stripRich(tr)) end
end,v.mixed)
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
if v.tagged then
Trans.processRichLabel(obj,"Text",cur,v,isChat)
return
end
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
if v.tagged then
Trans.processRichLabel(p,f,t,v,false)
elseif v.mixed then
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
pcall(Trans.adaptTick)
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
for _=1,12 do
if not p then break end
local n=tostring(p.Name):lower()
if n:find("chat") or n:find("bubble") or n:find("message")
or n:find("textchat") or n:find("chatwindow") or n:find("chatscroll") then
return true
end
p=p.Parent
end
return false
end
function Trans.scanChatOnce()
if not Trans.ChatActive or Trans.Unloaded then return 0 end
local n=0
local roots={SYS.PG,SYS.CoreGui}
pcall(function() if gethui then roots[#roots+1]=gethui() end end)
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
task.wait(0.4)
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
function Trans.warmSlots()
local n=math.min(Trans.Slots or 0,8)
if n<=0 or type(request)~="function" or not HS then return end
if Trans._warmOn then return end
Trans._warmOn=true
task.spawn(function()
local okN=0
for i=1,n do
if Trans.Unloaded then break end
local ok=pcall(function()
return request({
Url=hostOf().."/v1/chat/completions", Method="POST",
Headers={["Content-Type"]="application/json",["Authorization"]="Bearer "..KEY},
Body=HS:JSONEncode({model=MODEL,
messages={{role="system",content=SYS_PROMPT},{role="user",content="OK"}},
max_tokens=1,stream=false}), Timeout=20,
})
end)
if ok then okN=okN+1 end
task.wait(0.05)
end
Trans._warmOn=false
print(("[Trans] 槽位预热完成 (%d/%d)"):format(okN,n))
end)
end
function Trans.checkLocal()
local ok,res=pcall(function()
return request({Url=hostOf().."/health",Method="GET",Timeout=10})
end)
if ok and type(res)=="table" and res.StatusCode==200 then
if Trans._wasOffline then
Trans._wasOffline=false
pcall(function() if SYS and SYS.Notify then SYS.Notify("✅ 本地翻译服务已恢复",(SYS.CY and SYS.CY.green) or nil) end end)
end
return "online"
end
Trans.offlineHint(false)
return "offline"
end
function Trans.probeServer()
local ok,res=pcall(function() return request({Url=hostOf().."/props",Method="GET",Timeout=10,
Headers={["Authorization"]="Bearer "..KEY}}) end)
if not ok or type(res)~="table" or not res.Body then
Trans.offlineHint(false)
return false
end
local okd,d=pcall(function() return HS:JSONDecode(res.Body) end)
if not okd or type(d)~="table" then return false end
local slots=tonumber(d.total_slots) or 8
local ctx=tonumber(d.default_generation_settings and d.default_generation_settings.n_ctx) or 512
Trans.SlotCtx=ctx
Trans.Slots=slots
Trans.maxTok=math.max(128,math.min(512,ctx-512))
local reserve=(slots>=4) and 2 or 1
Trans.MaxConcCap=math.max(1,math.min(32,slots-reserve))
Trans.MaxConc=Trans.MaxConcCap
Trans.MinConc=1
print(("[Trans] 服务器: %d 槽 × 每槽 %d ctx  ->  并发区间 %d~%d(当前 %d), 单次输出上限 %d token")
:format(slots,ctx,Trans.MinConc,Trans.MaxConcCap,Trans.MaxConc,Trans.maxTok))
Trans.warmSlots()
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
print("[Trans] ✅ 翻译模块 v120.2(纯本地 + 富文本保护 + 自适应并发) 已加载, 缓存="..tostring(Trans.cacheCount).." 条")
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
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,22) row.BackgroundTransparency=1 row.Parent=parent
local btn=Instance.new("TextButton")
btn.Size=UDim2.new(0,72,0,20) btn.Position=UDim2.new(0,14,0,1)
btn.BackgroundColor3=CY.card2 btn.BackgroundTransparency=0.3 btn.AutoButtonColor=false
btn.Text="? 说明" btn.TextColor3=col or CY.sub
btn.Font=Enum.Font.GothamMedium btn.TextSize=11 btn.Parent=row
UI.Round(btn,8) if UI.Stroke then UI.Stroke(btn,CY.line,1,0.7) end
local l=Instance.new("TextLabel")
l.Size=UDim2.new(1,-28,0,0) l.Position=UDim2.new(0,14,0,26)
l.BackgroundTransparency=1 l.Visible=false
l.Text=text or "" l.TextColor3=col or CY.sub
l.Font=Enum.Font.GothamMedium l.TextSize=11
l.TextXAlignment=Enum.TextXAlignment.Left l.TextWrapped=true l.Parent=row
l.AutomaticSize=Enum.AutomaticSize.Y
local open=false
T(btn.MouseButton1Click:Connect(function()
open=not open
l.Visible=open
btn.Text=open and "? 收起" or "? 说明"
row.Size=open and UDim2.new(1,0,0,26+math.max(24,l.TextBounds.Y)+8) or UDim2.new(1,0,0,22)
end))
return row
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
T(UIS.InputEnded:Connect(function(input)
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
local menuVisible = sg and sg.Parent and sg.Enabled ~= false and SYS.MenuOpen
if not menuVisible then
P(function() if SYS.Hud then SYS.Hud(text, 4) end end)
return
end
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
end
UI.Defs={
{name="挂机",icon="★"},{name="功能",icon="✱"},{name="翻译",icon="🌐"},{name="设置",icon="⚙"}
}
UI.Pages["功能"]=function(p)
UI.Section(p,"🕳 藏身 · 自杀",CY.green)
UI.Switch(p,"🕳 藏地下隐身 (服务器认可)","DeepHide",SYS.SetDeepHide)
UI.Btn(p,"☠ 自杀 (抹除自己的角色)",CY.red,function() P(SYS.ForceSuicide,"erase") end)
UI.Div(p)
UI.Section(p,"🌗 光照 · 去雾 (夜视 / 全亮 / 禁雾)",CY.orange)
UI.Cycle(p,"光照模式",SYS.LIGHT_MODES or {"关闭","夜视","超级光明","全亮"},
function() return SYS.C_.LightMode or "关闭" end,
function(v) SYS.C_.LightMode=v P(SYS.ReapplyLight) end)
UI.Switch(p,"🚫 禁雾 (去迷雾 · 远处不再白茫茫)","NoFog",function() P(SYS.ReapplyLight) end)
UI.Switch(p,"🌑 禁阴影","NoShadow",function() P(SYS.ReapplyLight) end)
UI.Switch(p,"🏮 随身灯笼 (只有你看得见的光)","Lantern",function() P(SYS.ReapplyLight) end)
UI.Div(p)
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
UI.Label(p,"训练加成")
UI.Switch(p,"自动领取训练加成","AutoBonus")
UI.Div(p)
UI.Label(p,"健身房事件")
UI.Switch(p,"优先参加健身事件","AutoGym",function(on)
if on then SYS.StartGym() else SYS.StopGym() end
end)
UI.Div(p)
UI.Label(p,"基地操作",CY.cyan)
UI.Div(p)
UI.Label(p,"自动售卖（低于 CPS 门槛才卖）",CY.yellow)
UI.Switch(p,"自动售卖 (每5秒)","AutoSell",function(on)
if on and not SYS.T_.SellThresholdEnabled then
SYS.T_.SellThresholdEnabled=true
if SYS.SwitchOnChange and SYS.SwitchOnChange["SellThresholdEnabled"] then
pcall(function() SYS.SwitchOnChange["SellThresholdEnabled"](true) end)
end
local th=(SYS.AFK_Sell and SYS.AFK_Sell.MinCPS) or 100000
print(("[Sell] 已顺带打开「启用 CPS 门槛」(当前门槛 %.0f, 按【基础 CPS】判) —— 自动售卖靠它决定卖哪些"):format(th))
end
end)
UI.Switch(p,"启用 CPS 门槛","SellThresholdEnabled")
UI.Div(p)
UI.Label(p,"📊 CPS 统计",CY.purple)
local scanResL=UI.Label(p,"输入 CPS 后点击扫描",CY.sub)
UI.Btn(p,"🔍 扫描低于当前门槛的脑红数量",CY.purple,function()
task.spawn(function()
if scanResL and scanResL.Parent then
scanResL.Text="扫描中..." scanResL.TextColor3=CY.yellow
end
local picks,th,all=0,0,nil
pcall(function()
picks,th,all=SYS.scanLowCPSCount()
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
scanResL.Text=("低于 %.0f 的脑红: 一个都没有"):format(th)
scanResL.TextColor3=CY.green
else
scanResL.Text=("低于 %.0f 共 %d 个  |  %s"):format(th,cnt,preview)
scanResL.TextColor3=CY.cyan
end
print(("[Scan] 低于 %.0f 共 %d 个（按背包显示的 CPS 判）"):format(th,cnt))
local fc=SYS.SellFmtCompact or tostring
print(("[Scan] 门槛 = %s (%d)   —— 判定规则: 背包显示值 < 门槛 就卖"):format(fc(th),math.floor(th)))
print(("  %-30s %12s %12s   %s"):format("物品","背包显示值","表里基础值","判定"))
for i=1,math.min(#(all or {}),25) do
local it=all[i]
print(("  %-30s %12s %12s   %s"):format(
tostring(it.Name):sub(1,30), fc(it.CPS), fc(it.Base),
it.Pass and "★卖" or "留"))
end
if all and #all>25 then print(("  … 还有 %d 件"):format(#all-25)) end
else
scanResL.Text="扫描失败"
scanResL.TextColor3=CY.red
end
end
end)
end)
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,42) row.BackgroundColor3=CY.card
row.BackgroundTransparency=0.3 row.BorderSizePixel=0 row.Parent=p
UI.Round(row,10) UI.Stroke(row,CY.line,1,0.85)
local lb=Instance.new("TextLabel")
lb.Size=UDim2.new(1,-130,1,0) lb.Position=UDim2.new(0,12,0,0)
lb.BackgroundTransparency=1 lb.Text="低于此值就卖掉 (可写 80m)"    lb.TextColor3=CY.text lb.Font=Enum.Font.GothamMedium
lb.TextSize=13 lb.TextXAlignment=Enum.TextXAlignment.Left lb.Parent=row
local function parseCompactStr(v)
if type(v)=="number" then return v end
local s=tostring(v or ""):lower():gsub("[,%s]","")
if s=="" then return nil end
local num,suf=s:match("^([%d%.]+)([kmbtq]?)$")
if not num then return nil end
local n=tonumber(num)
if not n then return nil end
local MULT={k=1e3,m=1e6,b=1e9,t=1e12,q=1e15}
return n*(MULT[suf] or 1)
end
local function fmtCompactStr(n)
n=tonumber(n) or 0
if n>=1e15 then return ("%.2fq"):format(n/1e15) end
if n>=1e12 then return ("%.2fT"):format(n/1e12) end
if n>=1e9  then return ("%.2fB"):format(n/1e9) end
if n>=1e6  then return ("%.2fM"):format(n/1e6) end
if n>=1e3  then return ("%.2fK"):format(n/1e3) end
return tostring(math.floor(n))
end
SYS.SellParseCompact=parseCompactStr
SYS.SellFmtCompact=fmtCompactStr
local box=Instance.new("TextBox")
box.Size=UDim2.new(0,110,0,28) box.Position=UDim2.new(1,-122,0.5,-14)
box.BackgroundColor3=CY.panel box.BackgroundTransparency=0.2
box.Text=fmtCompactStr((SYS.AFK_Sell and SYS.AFK_Sell.MinCPS) or 100000)
box.TextColor3=CY.cyan box.Font=Enum.Font.Code
box.TextSize=13 box.BorderSizePixel=0 box.ClearTextOnFocus=false box.Parent=row
UI.Round(box,6) UI.Stroke(box,CY.cyan,1,0.7)
box.FocusLost:Connect(function()
local v=parseCompactStr(box.Text)
if v and v>=0 then
if SYS.AFK_Sell then SYS.AFK_Sell.MinCPS=v end
if SYS.SyncMinCPS then SYS.SyncMinCPS() end
box.Text=fmtCompactStr(v)
print(("[Sell] CPS 门槛设为 %s (%d) —— 低于它的脑红会被卖掉"):format(box.Text,math.floor(v)))
else
local keep=(SYS.AFK_Sell and SYS.AFK_Sell.MinCPS) or 100000
box.Text=fmtCompactStr(keep)
print(("[Sell] 看不懂 %q, 门槛保持 %s（可写 80m / 1.2b / 500k）"):format(tostring(box.Text),fmtCompactStr(keep)))
end
end)
UI.Div(p)
UI.Label(p,"📊 CPS 统计",CY.purple)
local scanResL=UI.Label(p,"输入 CPS 后点击扫描",CY.sub)
end
UI.Pages["翻译"]=function(p)
UI.Section(p,"💬 翻译开关",CY.accent)
UI.Label(p,"🖥️ 翻译后端: 本机 llama.cpp (Hy-MT2-7B · 127.0.0.1:8080)",CY.sub)
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
local statConc = UI.Label(p, "并发: -", CY.purple)
task.spawn(function()
while not SYS.Unloaded do
task.wait(0.5)
if statL and statL.Parent then statL.Text=("已缓存 %d 条"):format(Trans.cacheCount or 0) end
if statConcurrent and statConcurrent.Parent then
local st=Trans.Stats or {}
local avg=((st.latN and st.latN>0) and (st.lat/st.latN) or 0)*1000
statConcurrent.Text = ("命中 %d | 本地 %d | 失败 %d | 跳过扫 %d | 均 %.0fms | 动态 %d | 排队 %d"):format(
st.hit or 0, st.loc or 0, st.fail or 0, st.sweepSkip or 0, avg, st.dyn or 0, Trans.WaitN or 0
)
end
if statConc and statConc.Parent then
local lo=Trans.MinConc or 1
local hi=Trans.MaxConcCap or Trans.MaxConc or 8
local cur=Trans.MaxConc or hi
statConc.Text=("并发: %d 在途 / 当前上限 %d  (区间 %d~%d, 服务器 %d 槽)"):format(
Trans.InflightN or 0, cur, lo, hi, Trans.Slots or 0)
end
end
end)
UI.Btn(p,"🗑️ 清空缓存",CY.red,function()
Trans.clearCache()
if statL then statL.Text="已缓存 0 条" end
end)
UI.Switch(p,"📖 本地短语表 (train→训练 这类常见词离线直译)","LocalPhrase")
UI.Div(p)
UI.Section(p,"🔌 模型状态",CY.cyan)
local stL=UI.Label(p,"模型: ⚪ 检测中...",CY.sub)
local function refresh()
if not stL or not stL.Parent then return end
task.spawn(function()
local name="🖥️ 本机模型"
stL.Text=name..": ⚪ 检测中..." stL.TextColor3=CY.sub
local s="unknown"
pcall(function() s=Trans.checkLocal() end)
if s=="online" then
stL.Text=name..": 🟢 在线" stL.TextColor3=CY.green
else
stL.Text=name..": 🔴 离线 —— 双击「翻译模型开关.bat」启动模型"
stL.TextColor3=CY.red
end
end)
end
Trans.refreshLocalStatus=refresh
task.spawn(function() task.wait(0.6) refresh() end)
UI.Div(p)
UI.Div(p)
end
UI.Pages["设置"]=function(p)
UI.Section(p,"📱 界面缩放",CY.cyan)
local TDEV=(SYS.DEV and SYS.DEV.anyTouch)==true
UI.Slider(p,"界面缩放 (0 = 自动适配)",0,(TDEV and 3.0 or 2.5),0.05,
function() return SYS.C_.UIScaleManual or 0 end,
function(v)
SYS.C_.UIScaleManual=v
if SYS.ApplyUIScale then P(SYS.ApplyUIScale) end
end,"%.2f")
UI.Div(p)
UI.Section(p,"🔄 热更新",CY.green)
UI.Switch(p,"🔁 有新版本时自动热重载","AutoUpdateCheck")
UI.Btn(p,"⬆️ 检查更新并热重载",CY.green,function() P(function() SYS.CheckUpdate(false) end) end)
UI.Switch(p,"🚀 重新加载时先检查新版本","BootUpdateCheck")
UI.Div(p)
UI.Section(p,"🚪 退出",CY.red)
UI.Btn(p,"🗑️ 卸载脚本 (干净退出)",CY.red,function()
SYS.Notify("正在卸载...",CY.red)
task.delay(0.1,function() P(SYS.UnloadAll) end)
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
local function CreateMenu()
SYS.BtnRefs={}
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
local pg=Pages[name]
if not pg then return end
if built[name]==false then
for _,c in ipairs(pg:GetChildren()) do
pcall(function() c:Destroy() end)
end
end
built[name]=true
local buildFn=UI.Pages[name]
if type(buildFn)=="function" then
local ok,err=pcall(buildFn,pg)
if not ok then
built[name]=false
warn(("[CheatMenu] 页面 %s 构建失败(切走再切回会重试): %s"):format(name,tostring(err)))
else
print("[CheatMenu] 页面 "..name.." OK")
end
else
warn(("[CheatMenu] 页面 %s 没有对应的 UI.Pages 实现 —— 显示占位提示"):format(tostring(name)))
local okP=pcall(function()
local t=Instance.new("TextLabel")
t.Size=UDim2.new(1,0,0,60) t.BackgroundTransparency=1
t.Text=("页面「%s」暂未实现"):format(tostring(name))
t.TextColor3=CY.sub t.Font=Enum.Font.GothamMedium t.TextSize=14
t.TextXAlignment=Enum.TextXAlignment.Center
t.Parent=pg
end)
if not okP then built[name]=false end
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
SYS.CM_TitleBtns={closeBtn,collapseBtn}
SYS.MenuMain=main
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
ShowTab("挂机")
P(function()
local where=SYS.SafeParentGui(sg)
print("[CheatMenu] 菜单挂载: "..tostring(where))
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
local IGNORE_LIST="A_Timer|ActualPower|All|Amount|AreaName|B_Timer|BossName|BrainrotChance|BrainrotName|Brainrots|C_Timer|Cancel|Cash|Chance|ChanceLabel|Charging|ClaimButton|ClickRegion|Close|CoinLabel|Console|ConsoleModifierLabel|Count|CountLabel|CP/s|CPS|CPSLabel|CurrencyLabel|Day|DebounceFrame|Description|Discount|DiscountedPrice|DiscountLabel|DisplayName|EventTitle|Exp|Favorite|Favorites|Field|FreeSpinLabel|FriendsLabel|Gift|GiftButton|GiftingTo|GuideLabel|Header|Header1|Header2|Header3|HereText|IconLabel|ItemName|KickPower|LabelContent|Level|LevelLabel|Limited|LockedText|Lucky Blocks|Lvl|Mobile|Mutation|MutationChance|MutationLabel|New|Next|NoPlayers|Now|Odds|One|OP|OreName|Owned|PC|Percentage|Pity|PlayerName|Plus|Plus1|Plus2|Points|PowerLabel|Prevoius|Price|PriceLabel|Progress|ProgressBar|Rarity|RarityLabel|Reached|RebirthLevel|RefreshLabel|RewardLabel|RobuxLabel|S_Timer|SelectedLabel|SlotNum|SpinsLabel|StatusLabel|Stock|StockUpdateLabel|SubHeader|Suggest|SunHeader|TaskLabel|Three|Tier|TimeLabel|TimeLeft|Timer|TimerLabel|TotalLuckLabel|TradeLimit|Two|Txt|Txt1|Txt2|Txt3|Type|Typed|UnlockedLabel|UnlockLabel|Value|ValueLabel|WeatherName|WeightLabel|WorldName"
Trans.IgnoreObjects={}
for w in IGNORE_LIST:gmatch("[^|]+") do Trans.IgnoreObjects[w]=true end
do
local n = 0
for _ in pairs(Trans.IgnoreObjects) do n = n + 1 end
print("[Trans] 忽略控件表已装载: "..tostring(n).." 项")
end
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
P(SYS.SyncFreeCam)
end
end)
SYS.SpawnLoop(function()
while not SYS.Unloaded do
if SYS.T_.PerfBoost then P(SYS.PerfCullTick) task.wait(0.12) else task.wait(0.5) end
end
end)
TT(task.spawn(function()
while not SYS.Unloaded do
local okE,errE = pcall(SYS.ESPTick)
if not okE and not SYS._espErrOnce then
SYS._espErrOnce = true
print("[高亮] ESPTick 报错(只提示一次): "..tostring(errE))
print("        ↑ 把这行发我, 就能定位高亮为什么不出")
end
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
do
local function rootHum()
local ch=SYS.LP and SYS.LP.Character
if not ch then return nil,nil end
return ch:FindFirstChild("HumanoidRootPart"), ch:FindFirstChildOfClass("Humanoid")
end
SYS._ACEvents=SYS._ACEvents or {}
local ACEN={}
function SYS.ACELog(tag,text)
local key=tostring(tag)
local n=(ACEN[key] or 0)+1
ACEN[key]=n
local t=SYS._ACEvents
t[#t+1]=("%s x%d  %s"):format(key,n,tostring(text))
while #t>200 do table.remove(t,1) end
print(("[CheatMenu][AC监听] %s x%d  %s"):format(key,n,tostring(text)))
if n<=3 then P(SYS.Notify,"👂 通道下行: "..key,SYS.CY.cyan) end
end
function SYS.StartACWatch()
if SYS._ACWatch then return end
SYS._ACWatch=true
local kws=(SYS.EventWatch and SYS.EventWatch.keywords) or {}
local ok,d=pcall(function() return SYS.RStorage:GetDescendants() end)
if not ok or type(d)~="table" then return end
local seen={}
local n=0
local MAXN=60
for i=1,#d do
if n>=MAXN then break end
local o=d[i]
local cls=o.ClassName
if cls=="RemoteEvent" or cls=="UnreliableRemoteEvent" then
local nm=tostring(o.Name)
local low=nm:lower()
local hit=false
for j=1,#kws do
local k=tostring(kws[j]):lower()
if k~="" and low:find(k,1,true) then hit=true break end
end
local risky=false
if hit and not seen[nm] and type(SYS.RemoteRisk)=="function" then
local v=SYS.RemoteRisk(nm)
if type(v)=="string" then
local c=v:sub(1,1)
risky=(c=="⛔" or c=="⚠")
end
end
if risky then
seen[nm]=true
n=n+1
T(o.OnClientEvent:Connect(function(...)
local args=table.pack(...)
local s={}
for q=1,math.min(args.n,4) do s[#s+1]=tostring(args[q]) end
SYS.ACELog(nm,table.concat(s,", "))
end))
if n%8==0 and SYS.Stagger then P(SYS.Stagger,1) end
end
end
end
print(("[CheatMenu][AC监听] 已只读接入 %d 个反作弊/审计通道(从不 FireServer; 上限 %d)"):format(n,MAXN))
end
function SYS.StartAdminWatch()
if SYS._AdminWatch then return end
SYS._AdminWatch=true
local pl=SYS.LP
if pl and pl.OnTeleport then
T(pl.OnTeleport:Connect(function(...)
local args=table.pack(...)
local s={}
for q=1,math.min(args.n,4) do s[#s+1]=tostring(args[q]) end
SYS.ACELog("LP.OnTeleport",table.concat(s,", "))
end))
end
local NAMES={"Kick","Ban","BanAsync","KickPlayer","BanPlayer","Punish","RemovePlayer"}
local ok,d=pcall(function() return SYS.RStorage:GetDescendants() end)
if ok and type(d)=="table" then
for i=1,#d do
local o=d[i]
local cls=o.ClassName
if cls=="RemoteEvent" or cls=="UnreliableRemoteEvent" then
local nm=tostring(o.Name)
local hit=false
for j=1,#NAMES do if nm==NAMES[j] or nm:find(NAMES[j],1,true) then hit=true break end end
if hit then
T(o.OnClientEvent:Connect(function(...)
local args=table.pack(...)
local s={}
for q=1,math.min(args.n,4) do s[#s+1]=tostring(args[q]) end
SYS.ACELog("管理通道:"..nm,table.concat(s,", "))
end))
end
end
end
end
if Players then
T(Players.PlayerRemoving:Connect(function(p)
if pl and p==pl then
SYS.ACELog("PlayerRemoving(自己)","自己被移除但脚本还在跑 —— 可能被踢")
else
SYS.ACELog("PlayerRemoving",tostring(p and p.Name))
end
end))
end
print("[CheatMenu][管理监听] 已只读接入 Teleport/Kick/Ban 类通道 + PlayerRemoving")
end
local CG={ on=false, pulls=0, last=0 }
SYS.CamGuard=CG
function SYS.SetCamGuard(on)
on=on and true or false
local wasOn=CG.on
SYS.T_.CamGuard=on
CG.on=on
if not on then
SYS.SetLoop("CamGuard",false)
if wasOn then P(SYS.Notify,"🎥 相机护栏已关",SYS.CY.sub) end
return true
end
SYS.SetLoop("CamGuard",true,RS.Heartbeat,function()
if not CG.on then return end
if SYS.FreeCamActive or SYS.MenuOpen then return end
local any=SYS.T_.Fly or SYS.T_.Speed
if not any then
local K2={"CB_Aim","CB_Silent","CB_Fire","CB_360","CB_Ballistic","AutoDodge"}
for i=1,#K2 do if SYS.T_[K2[i]] then any=true break end end
end
if not any then return end
local now=os.clock()
if now-(CG.last or 0)<0.1 then return end
CG.last=now
local cam=SYS.Cam
local root=rootHum()
if not cam or not root then return end
local d=(cam.CFrame.Position-root.Position).Magnitude
local lim=math.max(5,tonumber(SYS.C_.CamGuardDist) or 30)
if d>lim then
CG.pulls=CG.pulls+1
P(function()
local look=cam.CFrame.LookVector
cam.CFrame=CFrame.lookAt(root.Position-look*lim,root.Position)
end)
end
end)
P(SYS.Notify,"🎥 相机护栏已开 (相机离角色超过 "..tostring(tonumber(SYS.C_.CamGuardDist) or 30).." 格就拉回)",SYS.CY.green)
return true
end
local PR={ on=false, conn=nil, applied=0 }
function SYS.SetPosRebound(on)
on=on and true or false
local wasOn=PR.on
SYS.T_.PosRebound=on
PR.on=on
if PR.conn then PR.conn:Disconnect() PR.conn=nil end
if not on then
if wasOn then P(SYS.Notify,"📍 位置下行回压已关",SYS.CY.sub) end
return true
end
local ev=SYS.REvent("ServerReplicateCFrame") or SYS.REventU("ServerReplicateCFrame")
if not ev then
SYS.T_.PosRebound=false PR.on=false
P(SYS.Notify,"📍 位置下行回压: 这个游戏没有 ServerReplicateCFrame, 开不了",SYS.CY.yellow)
return false
end
PR.conn=T(ev.OnClientEvent:Connect(function(...)
if not PR.on then return end
if not (SYS.T_.Fly or SYS.T_.Speed) then return end
local args=table.pack(...)
local cf=nil
for i=1,args.n do
local v=args[i]
local tp=(typeof and typeof(v)) or type(v)
if tp=="CFrame" then cf=v break end
end
if not cf then return end
PR.applied=PR.applied+1
task.defer(function()
if not PR.on then return end
local root=rootHum()
if root then P(function() root.CFrame=cf end) end
end)
end))
P(SYS.Notify,"📍 位置下行回压已开 (仅飞行/加速时生效)",SYS.CY.green)
return true
end
SYS._TimeSnap=nil
function SYS.TimeCheck()
local s=SYS._TimeSnap
if not s then return {"(未做时间快照)"} end
local out={}
local function chk(label,old,now)
if old~=nil and now~=old then
out[#out+1]=("⚠ %s 的函数身份变了 —— 有别的脚本 hook 了时间函数"):format(label)
else
out[#out+1]=("✅ %s 未被替换"):format(label)
end
end
chk("os.clock",s.clock,os.clock)
chk("os.time",s.time,os.time)
chk("tick",s.tick,tick)
chk("time",s.luaTime,time)
return out
end
function SYS.TimeSnapshot()
SYS._TimeSnap={ clock=os.clock, time=os.time, tick=tick, luaTime=time }
end
SYS._MetaSnap=nil
function SYS.MetaCheck()
local out={}
if type(getmetatable)~="function" then return {"(本机没有 getmetatable, 跳过)"} end
local ok,mt=pcall(getmetatable,game)
if not ok or type(mt)~="table" then return {"(取 game 元表失败 —— 可能被锁)"} end
SYS._MetaSnap=SYS._MetaSnap or {}
local snap=SYS._MetaSnap
local bad=0
local KS={"__index","__namecall","__newindex"}
for i=1,#KS do
local k=KS[i]
local v=nil
pcall(function() v=rawget(mt,k) end)
if snap[k]==nil then
snap[k]=v
elseif v~=snap[k] then
bad=bad+1
out[#out+1]=("⚠ game 元表 %s 与快照不同 —— 被别的脚本改过"):format(k)
end
end
if bad==0 then out[#out+1]="✅ game 元表 __index/__namecall/__newindex 与快照一致" end
out[#out+1]="(只报告, 本脚本绝不改元表)"
return out
end
function SYS.NetOwnerInfo()
local root=rootHum()
if not root then return {"(没有角色)"} end
local ok,pl=pcall(function() return root:GetNetworkOwner() end)
if ok and pl then return {("网络所有权: %s (这个人能权威地移动它)"):format(tostring(pl.Name))} end
return {"网络所有权: 服务端(或取不到) —— 你的位置由服务端拍板"}
end
SYS._fps=60
function SYS.FpsGcInfo()
local g=0
pcall(function() if type(gcinfo)=="function" then g=gcinfo() end end)
return ("FPS≈%.0f   gcinfo≈%.0f KB (原样上报, 不做伪装)"):format(tonumber(SYS._fps) or 0,tonumber(g) or 0)
end
SYS._fireLog={}
function SYS.FireRateStat()
local t=SYS._fireLog
local now=os.clock()
local n,last,ds,dn=0,nil,0,0
for i=1,#t do
local e=t[i]
if now-e<=10 then
n=n+1
if last then ds=ds+(e-last) dn=dn+1 end
last=e
end
end
local mean=dn>0 and (ds/dn) or 0
local var=0
if dn>0 then
local l2=nil
local acc=0
for i=1,#t do
local e=t[i]
if now-e<=10 then
if l2 then acc=acc+(e-l2-mean)^2 end
l2=e
end
end
var=math.sqrt(acc/dn)
end
local out={ ("近 10 秒上行 %d 次   平均间隔 %.1f ms   标准差 %.1f ms"):format(n,mean*1000,var*1000) }
if n>=8 and mean*1000>0 and var*1000<5 then
out[#out+1]="⚠ 间隔标准差 < 5ms —— 这条上行太规律了, 开火抖动可能没生效"
end
return out
end
SYS._airAt=nil
function SYS.FlyAirMimicTick(dt)
if SYS.T_.FlyAirMimic~=true then SYS._airAt=nil return end
local _,hum=rootHum()
if not hum then return end
local mat=hum.FloorMaterial
if mat==Enum.Material.Air then
SYS._airAt=SYS._airAt or os.clock()
if os.clock()-(SYS._airAt)>=5 then
SYS._airAt=os.clock()
P(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
end
else
SYS._airAt=nil
end
end
SYS.Diag=SYS.Diag or {}
function SYS.Diag.ACFramework()
local r={ name="unknown", strength=1, hits={} }
local function hit(s) r.hits[#r.hits+1]=s end
local words={"byfron","hyperion","electron","sirhurt","solvent","oxygen","scriptware"}
local roots={}
pcall(function() roots[#roots+1]=SYS.CoreGui end)
roots[#roots+1]=SYS.PG
for i=1,#roots do
local rt=roots[i]
if rt then
pcall(function()
for _,c in ipairs(rt:GetDescendants()) do
local nm=tostring(c.Name):lower()
for j=1,#words do
if nm:find(words[j],1,true) then hit(tostring(rt.Name).."."..tostring(c.Name).." <-"..words[j]) break end
end
end
end)
end
end
local gg={"is_sirhurt_closure","syn","KRNL_LOADED","secure_load","isbyfron","hyperion"}
for i=1,#gg do
local ok,v=pcall(function() return _G[gg[i]] end)
if ok and v~=nil then hit("执行器全局 "..gg[i]) end
end
local rs=SYS.RStorage
if rs then
local NM={"CommonClientAntiCheat","Replica","ReplicaShared","jecs","AntiCheat","ACService",
"validateLivingCharacter","DeathFlowTelemetry","AntiCheatService","ACRemote"}
for i=1,#NM do
local ok,c=pcall(function() return rs:FindFirstChild(NM[i],true) end)
if ok and c then hit("ReplicatedStorage."..NM[i]) end
end
end
local byfron=false
local ac=false
for i=1,#r.hits do
local h=r.hits[i]:lower()
if h:find("byfron",1,true) or h:find("hyperion",1,true) or h:find("electron",1,true) then byfron=true end
if h:find("anticheat",1,true) or h:find("acservice",1,true) or h:find("commonclientanticheat",1,true)
or h:find("deathflowtelemetry",1,true) or h:find("validatelivingcharacter",1,true)
or h:find("replica",1,true) or h:find("jecs",1,true) then ac=true end
end
if byfron then r.name="byfron" r.strength=3
elseif ac or #r.hits>0 then r.name="custom" r.strength=(ac and 2 or 1)
else r.name="none" r.strength=1 end
return r
end
SYS.Stagger=function(frames)
local n=math.max(1,math.min(3,tonumber(frames) or 1))
for _=1,n do RS.Heartbeat:Wait() end
end
SYS.SpawnLoop(function()
local last=os.clock()
local acc=0
while not SYS.Unloaded do
RS.Heartbeat:Wait()
local now=os.clock()
acc=acc+(now-last)
last=now
if acc>=0.5 then
SYS._fps=math.min(999,1/ math.max(acc,0.001))
acc=0
end
end
end)
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
P(function() if SYS.Info then SYS.Info.Clear() end end)
P(function() if SYS.DeadOnTime then SYS.DeadOnTime.UnhookAll() SYS.DeadOnTime.Clear() end end)
P(function() if SYS.DRCombat and SYS.DRCombat.UnloadAll then SYS.DRCombat.UnloadAll() end end)
P(function() if SYS.DRHp and SYS.DRHp.UnloadAll then SYS.DRHp.UnloadAll() end end)
P(function() if SYS.SetKickGuard then SYS.SetKickGuard(false) end end)
P(function() if SYS.SetKickRejoin then SYS.SetKickRejoin(false) end end)
P(function() if SYS.SetAntiCheatBlock then SYS.SetAntiCheatBlock(false) end end)
P(function() if SYS.SetCamGuard then SYS.SetCamGuard(false) end end)
P(function() if SYS.SetPosRebound then SYS.SetPosRebound(false) end end)
P(function() if SYS.UnhookAllSafe then SYS.UnhookAllSafe() end end)
P(function() if SYS.V3Teardown then SYS.V3Teardown() end end)
P(function() if SYS._f3Gui then SYS._f3Gui:Destroy() SYS._f3Gui=nil SYS._f3Lbl=nil end end)
P(function() if SYS._awConn then SYS._awConn:Disconnect() SYS._awConn=nil end end)
P(function() SYS._ciOn=false end)
P(SYS.StopTrain) P(SYS.StopGym)
P(function() if SYS.CleanTrapGuard then SYS.CleanTrapGuard() end end)
P(function() if SYS.Combat then SYS.Combat.Stop() end end)
P(function() if SYS.SetNoclip then SYS.SetNoclip(false) end end)
P(function() if SYS.FuseClean then SYS.FuseClean() end end)
P(function() if SYS.Gun and SYS.Gun.Sync then SYS.Gun.Sync() end end)
P(SYS.SyncAntiRevert)
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
if SYS.T_.ACBlock~=false and SYS.SetAntiCheatBlock then
P(function() SYS.SetAntiCheatBlock(true) end)
end
if SYS.TimeSnapshot then P(SYS.TimeSnapshot) end
if SYS.StartACWatch then P(SYS.StartACWatch) end
if SYS.V3Boot then P(SYS.V3Boot) end
if SYS.StartAdminWatch then P(SYS.StartAdminWatch) end
if SYS.SyncAntiRevert then P(SYS.SyncAntiRevert) end
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
