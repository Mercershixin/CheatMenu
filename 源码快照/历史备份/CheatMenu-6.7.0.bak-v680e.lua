--============================================================
--  Cheat Menu v49.1 · 完整整合版
--  - UI 页面用 "UI.Pages[name]=function" 语法(兼容所有执行器)
--  - 中文检测强化: 汉字 + 中文标点 + 硬保护词表
--  - 保留: 收脑红 / 收金币 / 低CPS售卖 / 翻译 / 健身房
--============================================================
print("[CheatMenu] ===== v68 加载开始 =====")

--============================================================
-- [00] 全局状态
--============================================================
local GENV
do local ok,e=pcall(getgenv) GENV=(ok and type(e)=="table") and e or _G end
if GENV.CheatLoaded and type(GENV.CheatUnload)=="function" then pcall(GENV.CheatUnload) end
-- ★ v83 防多加载: 用户"点多了会一次性加载很多个"。上面那行只在 getgenv 共享时能卸载旧实例;
--   这里再补一刀 —— 不管环境是否共享, 一进来就把残留的同名菜单全删掉, 保证只剩自己这一个。
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

-- ★ v4.5.0 设备标志: UI 控件定义(约 6360 行)要按它决定按钮高度, 所以必须在最前面探测
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
        ESP=false,ESPNameTag=false,ESPItem=false,ESPWeapon=false,ESP_NPC=false,ESP_Pick=false,ESP_Door=false,ESP_Mini=false,InstantPrompt=false,ClickInspect=false,FootstepESP=false,AntiVoid=false,AirWalk=false,F3Debug=false,MenuMouse=true,PickDist=1200,CamFov=70,CamZoom=20,FreeCam=false,Tracer=false,
        AntiAFK=true,AutoBonus=false,
        AutoRebirth=false,AutoGym=false,AutoTrain=false,
        TransChat=false,TransUI=false,
        AutoSell=false,SellThresholdEnabled=false,
        -- ★ v57/v59: 战斗开关默认全关, 仅「不打队友」默认开(用户要求)
        CB_Aim=false,CB_Silent=false,CB_Fire=false,
        CB_PauseMove=false,CB_Predict=false,CB_Team=false,CB_Wall=true,
        CB_TgtStrict=false,
        CB_SnapFire=false,
        -- ★ v71 只锁"有血量且>0"的活人(用户要求)。关掉 = 回到旧行为(没有 Humanoid 也算活人)
        CB_OnlyAlive=true,
        CB_SkipFF=true,        -- 无敌盾: 跳过带 ForceField 的目标(等护盾结束再打)
        CB_Melee=false,        -- ★ v4.1.0 近距离补刀(默认关, 用户自己在战斗页打开)
                               --   ★ v5.4.0: 与"补刀也打非目标"合并为一个开关(优先锁定目标, 其次最近敌人)
        -- ★ v122 反陷阱免伤(地图道具/生物/陷阱的攻击与控制; 实现见 [05] 移动模块)
        TrapImmune=false,
        -- ★ v6.6.0 数值锁定(融合自 ChronixHub 基础设置页的「滑块 + 锁定」成对模式)
        --   只写【自己角色】+【本地 Workspace.Gravity】 -> 只影响本客户端
        LockSpeed=false,LockJump=false,LockGravity=false,
        -- ★ v6.6.0 融合自 ChronixHub 路径点页: Ctrl+数字 直达传送(前 9 个保存点)
        PathKey=false,
        -- ★ v71 启动时自动检查 git 上的新版本并热重载
        AutoUpdateCheck=true,
        -- ★ v124(用户要求): 【加载时】更新检查 —— 重新加载的那一下先看有没有新脚本(见 SYS.BootUpdateCheck)
        BootUpdateCheck=true,
        --================ ★ v6.7.0 融合(ChronixHub)新增开关 · 一律默认关 ================
        -- 滤镜控制器
        FX_Enable=false,
        FX_HBlur=false,FX_HBloom=false,FX_HDoF=false,FX_HRays=false,FX_HCC=false,
        -- 光照档位包
        NightVision=false,NightVisionPro=false,Lantern=false,SuperLight=false,
        NoFog=false,NoShadow=false,
        -- 音频 / 聊天
        AudioCtl=false,AudioProbe=false,ChatLog=false,
        -- 多路径点
        WPShow=false,WPKey=false,
        -- 自杀 / 角色状态(防死亡·防击倒 并入上帝模式)
        NoDeath=false,NoKnock=false,
        -- 瞄准补强(注: 「锁定保持/粘性瞄准」用户早前明确删除过, code 里有回归锁, 不再加回)
        CB_MissMode=false,
        -- 默认关闭的三项(用户点名: 加入但默认关)
        CB_SilentAim=false,CB_BulletWall=false,CB_BlockRay=false,
        -- 防护
        Prot_AntiAC=false,Prot_AntiAdmin=false,Prot_AntiTP=false,Prot_HideGui=false,
        -- 玩家控制(动手类)
        PC_LoopTP=false,PC_OnHead=false,PC_Orbit=false,PC_Stare=false,PC_Follow=false,
        PC_Freeze=false,PC_Mute=false,
        -- 整蛊工具
        PG_Spin=false,PG_FlingAll=false,PG_SpinHit=false,PG_FlyHit=false,
        PG_WalkHit=false,PG_HideHit=false,PG_OrbitTool=false,PG_BlackHole=false,
        PG_KillNear=false,
    },
    C_={
        -- ★ v3.9.0(用户要求): 飞行默认执行器改回 BodyVelocity —— 最兼容老执行器
        --   (Align 依赖 LinearVelocity/AlignOrientation, 老执行器造不出来 -> 飞行直接不生效;
        --    选了 Align 但执行器不支持时, FlyTick 里还有一层"自动降级"兜底)
        FlySpeed=3,FlyMode="BodyVelocity",
        SpeedMult=2,TPMethod="CFrame",SpeedMode="Linear",
        JumpMult=2,
        -- ★ v6.6.0 世界重力(格/秒² · 196.2 = Roblox 默认) —— 配合「锁定世界重力」
        Gravity=196.2,
        MouseTPMode="Raycast",AutoTPDist=5,TPMaxStep=300,
        FreeCamSpeed=60,FreeCamSens=0.3,PerfCull=300,
        -- ★ v3.9.0: 名字标签在"角色顶部之上"再加多少格(0=自动贴顶; 正数=更往上)
        ESPNameH=0,
        -- ★ v69: 藏地下隐身的深度(格) —— 小=离地面近(还能被距离判定的交互够到), 大=藏得深
        DeepHideDepth=120,
        -- ★ v3.10.0: 藏身方向("down"=地下 / "up"=天上) + 藏身偏移(相对开启点, 格; X=左右 Z=前后)
        DeepHideMode="down",DeepHideOffX=0,DeepHideOffZ=0,
        -- ★ v3.10.0: 强制相机视角("off"/"first"/"third")
        ForceCam="off",
        AutoTrainSec=5,RebirthCheck=3,
        SellMinCPS=100000,
        CB_AimPart=2,CB_Smooth=0.28,CB_Fov=200,CB_MaxDist=1200,CB_MeleeDist=9,CB_MeleeGap=0.35,
        CB_FireDelay=0.035,CB_HpThr=0,CB_PrioMode=1,
        CB_TargetMode=1,CB_TargetName="",CB_RingMode=1,CB_PredictTime=0.14,
        -- ★ v69: 圈显示模式改成默认「一直显示」; Ver 用来把老配置里存的 2(仅菜单)迁移过来
        CB_RingModeVer=0,
        CB_SnapDelay=0.03,
        -- ★ v71 快照瞄准防踢限流: 角色 CFrame 写入的最小间隔(秒) + 单次最大转角(度)
        CB_SnapMinGap=0.08,CB_SnapMaxAngle=360,
        -- ★ v102 移植: 可自定义热键(值是 KeyCode 名字; 在设置页「热键设置」里改)
        Key_Menu="G",Key_CycleTarget="V",Key_Teleport="T",
        --================ ★ v6.7.0 融合新增参数 ================
        FX_Sat=0,FX_Bri=0,FX_Con=0,FX_CB="关闭",
        -- ★ v6.7.0 界面缩放(0 = 自动适配; >0 = 直接用这个值, 范围 0.3~3.0)
        UIScaleManual=0,
        AudioMaster=100,AudioThr=15,
        CB_HitRate=100,CB_MissRate=0,
        PC_Sel="",PC_Speed=120,PC_Range=8,PC_SpinSpeed=3,
        PG_SpinSpeed=8,PG_OrbitRange=8,PG_OrbitSpeed=60,PG_OrbitMode=1,
        PG_BH_Range=40,PG_BH_Height=30,PG_BH_Speed=6,PG_BH_Pull=120,
        PG_KillDist=13,PG_Target="",
    },
    SavedPos={},Loops={},BtnRefs={},SwitchOnChange={},Pages={},
    ScreenGui=nil,MenuOpen=false,FreeCamActive=false,MenuPrevMouseBehav=nil,MenuPrevMouseIcon=nil,
    -- ★ v3.9.0: 进自由视角【之前】真正的鼠标状态(关自由视角时照它恢复, 见 StartFreeCam/StopFreeCam)
    FCPrevBehav=nil,FCPrevIcon=nil,
}
-- ★ v71 自更新: 下面三行由 .workbuddy/build/publish.py 在发行时【自动改写】, 手改没用
SYS.BuildVer="{{CM_VER}}"
SYS.BuildURL="{{CM_URL}}"
SYS.BuildVerURL="{{CM_VERURL}}"
-- ★ v124: 本地版(local_sync)故意把上面两个地址留空(= 零网络自用版), 但"重新加载时查新版"
--   恰恰是本地版最需要的 —— 本机那份 CheatMenu.lua 正是最容易过期的。所以内置一份仓库基址兜底:
--   地址为空/占位符时改用它来推导; 拉不到就安静跳过, 离线使用完全不受影响。
--   ★ 这一行也是占位符, 由发行脚本按 publish.json 里的仓库自动填 —— 换账号/换仓库不用手改源码。
SYS.FallbackRepo="{{CM_REPO}}"
GENV.__SYS=SYS

--============================================================
-- [01] 服务 + 工具
--============================================================
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

-- ★ v102 移植: 键名字符串 -> Enum.KeyCode(名字非法就返回 nil, 不会误触发任何热键)
function SYS.KeyCodeOf(name)
    if type(name)~="string" or name=="" then return nil end
    local ok,k=pcall(function() return Enum.KeyCode[name] end)
    if ok and k~=nil and typeof(k)=="EnumItem" then return k end
    return nil
end

--============================================================
-- [02] 配置持久化
--============================================================
do
    local CFG="CheatMenuV491_Config.json"
    local HAS_FS=(type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function")
    SYS.HAS_FS=HAS_FS
    SYS.has_fs_txt=HAS_FS and ("持久化启用 · "..CFG) or "执行器不支持 writefile"

    function SYS.SaveConfig()
        if not HAS_FS or not HS then return end
        P(function()
            local data={T_={},C_={}}
            -- ★ v57: 开关状态(T_)【永不】写盘 —— 用户要求"默认全关",
            --   且不能被旧配置干扰。每次加载都用代码默认值; 参数(C_)照常保存。
            -- ★ v68.10: 传送点(SavedPos)不再持久化 —— 坐标是当前服务器的,
            --   换服/重进后就没意义了, 应随脚本卸载/退出一起消失。

            for k,v in pairs(SYS.C_) do
                -- ★ v69: 「指定目标」是【本局意图】, 不该跨会话持久化 —— 旧版会把上一局的
                --   玩家名/模式存进配置, 重启脚本后选人分支一直先去查一个根本不在线的人,
                --   界面上还显示着那个旧名字, 看起来就像"索敌坏了"。
                if k~="CB_TargetName" and k~="CB_TargetMode" then
                    local tv=type(v)
                    if tv=="number" or tv=="string" or tv=="boolean" then data.C_[k]=v end
                end
            end
            local json=HS:JSONEncode(data)
            if type(json)~="string" then return end
            -- ★ v52(F41): 原子写 + .bak 备份(同翻译缓存 F35)。否则写一半崩溃 -> 半截 JSON ->
            --   下次 LoadConfig 的 JSONDecode 抛错被吞 -> 配置静默丢失。
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
    function SYS.LoadConfig()
        if not HAS_FS or not HS then return end
        P(function()
            if not isfile(CFG) then return end
            local function apply(raw)
                local data=HS:JSONDecode(raw)
                if type(data)~="table" then return false end
                -- ★ v4.5.0 设备默认值: 触摸设备(手机/平板)性能弱, 默认开【帧率优化】;
    --   注意放在配置读取之前, 用户自己存过的配置仍然以配置为准(下面会覆盖回去)。
    if _TOUCH then
        if SYS.T_.PerfBoost==false then SYS.T_.PerfBoost=true end
        if SYS.T_.AntiAFK==false then SYS.T_.AntiAFK=true end
    end

    -- ★ v57: 不再读回开关状态(T_) —— 每次加载都用代码默认值(默认全关),
                --   这样旧配置文件里残留的开关状态也不会再干扰新默认值。
                for k,v in pairs(data.C_ or {}) do if SYS.C_[k]~=nil and type(v)==type(SYS.C_[k]) then SYS.C_[k]=v end end
                -- ★ v69: 读回配置后强制清掉"上一局的指定目标"(老配置里可能存着, 见 SaveConfig 注释)
                SYS.C_.CB_TargetName="" SYS.C_.CB_TargetMode=1
                -- ★ v69 一次性迁移: 老配置里 FOV 圈存的是 2=仅菜单打开, 会让"圈开了却只在菜单里
                --   看得到" —— 正是用户报的"FOV 圆圈不生效"。迁移成 1=一直显示, 并打上版本号
                --   (之后用户在界面上怎么选都保留, 不会再被覆盖)。
                if SYS.C_.CB_RingModeVer~=2 then
                    SYS.C_.CB_RingMode=1
                    SYS.C_.CB_RingModeVer=2
                end
                return true
            end
            -- ★ v52(F41): 主配置损坏时回退 .bak(同翻译缓存 F35)
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

--============================================================
-- ★ v124(用户要求): 【加载时】更新检查 —— "重新加载的那一下先看看仓库有没有新脚本"
--   两条自更新分工(合起来才完整):
--     · v71  AutoUpdateCheck : 脚本【正跑着】的时候发现新版 -> 存配置 + 卸旧实例 + 拉新版 + 热重载
--     · v124 BootUpdateCheck: 脚本【刚被加载】的那一下(退出游戏 / 卸载脚本后重新注入) -> 先检查一遍;
--                             有新脚本就【直接用新版启动】(用户看不到旧版界面), 没有就正常打开。
--   为什么钉在最前面(这里界面/循环/事件一个都还没建): 换版最干净 —— 零残留、不会两个实例抢相机。
--   递归保护: 新版启动时会看到 GENV.CheatBootDone=true 而跳过检查, 否则无限套娃。
--   取不到版本号(离线/执行器没有 HttpGet)一律当"没新版", 正常打开, 绝不挡路。
--============================================================
function SYS.BootUpdateCheck()
    if GENV.CheatBootDone then return false end
    GENV.CheatBootDone=true
    if SYS.T_.BootUpdateCheck==false then return false end
    if type(game.HttpGet)~="function" then return false end
    -- 从发行时写进脚本的地址里解析出 用户/仓库/分支, 再拼多源候选(raw.githubusercontent 在国内常连不上)
    local base=tostring(SYS.BuildURL or "")
    -- 本地版/开发版地址是空的 -> 用内置仓库基址兜底(见 SYS.FallbackRepo 的说明)
    if base=="" or base:find("{{",1,true) then base=tostring(SYS.FallbackRepo or "") end
    local user,repo,branch=base:match("^https://raw%.githubusercontent%.com/([^/]+)/([^/]+)/([^/]+)")
    local VER,SRC
    if user then
        -- ★ 候选顺序 = 权威源优先:
        --   raw      : 内容最新(推送后约 5 分钟生效), 国内常连不上
        --   ghproxy  : 反代 raw, 内容同样新 + 国内可达
        --   jsDelivr : 最快, 但【分支缓存约 12h】—— 刚推的新版可能还没同步, 所以放最后
        -- ★ v5.2.1 修「更新不了」(用户实测): raw 与 jsDelivr 对【分支 @main】都有 CDN 缓存
        --   (raw ≈5 分钟, jsDelivr ≈12 小时) —— 直接请求会拿到【旧文件】, 表现就是"更新不了/还是旧版"。
        --   给每个源加一个【时间戳查询参数】: CDN 会把 query 算进缓存键 -> 每次请求都拿到最新内容。
        local ts=tostring(os.time() or 0)
        local function bust(u)
            return u..(u:find("?",1,true) and "&" or "?").."t="..ts
        end
        VER={
            bust(("https://raw.githubusercontent.com/%s/%s/%s/version.txt"):format(user,repo,branch)),
            bust(("https://ghproxy.net/https://raw.githubusercontent.com/%s/%s/%s/version.txt"):format(user,repo,branch)),
            bust(("https://cdn.jsdelivr.net/gh/%s/%s@%s/version.txt"):format(user,repo,branch)),
        }
        SRC={
            bust(("https://raw.githubusercontent.com/%s/%s/%s/CheatMenu.lua"):format(user,repo,branch)),
            bust(("https://ghproxy.net/https://raw.githubusercontent.com/%s/%s/%s/CheatMenu.lua"):format(user,repo,branch)),
            bust(("https://cdn.jsdelivr.net/gh/%s/%s@%s/CheatMenu.lua"):format(user,repo,branch)),
        }
    else
        VER={tostring(SYS.BuildVerURL or "")} SRC={base}
    end
    -- 版本号必须形如 "3.7" 或 "3.7.0" 才算数(见 .workbuddy/build/version.py: 主.次.补丁)
    local function isVer(v)
        return v:match("^%d+%.%d+$")~=nil or v:match("^%d+%.%d+%.%d+$")~=nil
    end
    -- 逐个源问版本号: ★ 只有合法版本号才算数 —— CDN 错误页/限流页会被跳过并自动换下一个源,
    --   既避免"把垃圾当版本号"(会误更新), 也避免"第一个源返回垃圾就放弃"。
    local rv=""
    for i=1,#VER do
        local u=VER[i]
        if u~="" and not u:find("{{",1,true) then
            local ok,body=pcall(game.HttpGet,game,u)
            if ok and type(body)=="string" then
                local flat=body:gsub("%s","")     -- ★ gsub 返回 (串, 次数) 两个值, 这里只要第一个
                local v=flat:sub(1,16)
                if isVer(v) then rv=v break end
            end
        end
    end
    if rv=="" then return false end              -- 一个源都没给出像样的版本号 -> 当"没有新版", 正常打开
    local mine=tostring(SYS.BuildVer or ""):gsub("%s","")
    if rv==mine then return false end
    -- 版本号比大小: 主.次.补丁 三段("3.7.0"), 也兼容旧的两段("3.7" = "3.7.0")。
    -- 权重 主*1000000 + 次*1000 + 补丁 —— 与 .workbuddy/build/version.py 的进制一一对应。
    local function score(v)
        local a,b,c=v:match("^(%d+)%.(%d+)%.(%d+)$")
        if a then return tonumber(a)*1000000+tonumber(b)*1000+tonumber(c) end
        local a2,b2=v:match("^(%d+)%.(%d+)$")
        if a2 then return tonumber(a2)*1000000+tonumber(b2)*1000 end
        return nil
    end
    local rn,mn=score(rv),score(mine)
    if not rn or not mn then return false end    -- 本地版本号不是标准格式(开发版占位符) -> 不自我更新
    if rn<=mn then return false end
    print(("[CheatMenu] 加载时更新检查: 发现新脚本 %s -> %s, 改用新版启动"):format(mine,rv))
    -- 拉新版源码: 长度门槛(1000) + 404 文案 双重挡掉"错误页被当成脚本"
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
    -- 提示先挂上(新版可能在 pcall 里让出, 之后再挂就来不及显示); 启动失败则撤销, 免得旧版显示假消息
    GENV.CheatUpdateNote=("🆕 已更新 %s → %s"):format(mine,rv)
    local ok,err=pcall(chunk)
    if not ok then
        GENV.CheatUpdateNote=nil
        print("[CheatMenu] ⚠️ 新版启动失败, 回到当前版本: "..tostring(err))
        return false
    end
    -- ★ 本机那份自愈: 顺手把新版写回本地文件 —— 否则"本机文件是旧的"会让【每次重新加载都重下一次】。
    --   只在原来就有这个文件时才覆盖, 并留一份 .bak(与 local_sync.py 的约定一致)。
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
    -- ★ P() 返回 (ok, 函数返回值...) 多值 —— 写 local x=P(...) 拿到的是布尔 ok, 必须 local _,x=
    local _,booted=P(SYS.BootUpdateCheck)
    if booted then return end          -- 已经用新版启动过, 旧版到此为止(不再建界面/起循环)
end

--============================================================
-- [03] 角色 / 相机 / 控制
--============================================================
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

    -- ★ v3.10.0 强制相机视角(第一人称 / 第三人称)
    --   原理: Roblox 的视角由 Player.CameraMode + CameraMaxZoomDistance 决定。
    --     第一人称 = CameraMode=LockFirstPerson(引擎把相机锁进角色头里);
    --     第三人称 = CameraMode=Classic + CameraMaxZoomDistance 调大(可拉远)。
    --   打开时记录原值, 关闭/卸载时还原。
    local ForceCamOrig=nil
    local ForceCamConn=nil
    function SYS.SetForceCam(mode)
        mode=mode or SYS.C_.ForceCam or "off"
        -- 记录一次原始状态(只在第一次开时记, 避免覆盖)
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
        -- 每 0.5s 兜底抢一次(有些游戏脚本每帧改回相机模式)
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

    -- ★★ 新增: 视野(FOV) 与 第三人称拉远 —— 纯客户端视觉(只改你自己看到的画面, 不碰任何别人)
    --   · FOV : 直接写 Camera.FieldOfView(默认 70 = 原版; 拉大 = 看得更广, 边缘会有鱼眼变形)
    --   · 拉远: 写 Player.CameraMaxZoomDistance(滚轮最多能拉到多远) —— 原来"强制第三人称"
    --           把它【硬写成 20】(太近), 现在改成读配置 C_.CamZoom(默认 20, 可拉到 500)
    --   两者都会保存原始值, 卸载 / 关掉时【还原】, 不把游戏相机改坏。
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

--============================================================
-- [04] 远程事件
--============================================================
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
    -- ★ v4.1.0 Remote 多路径解析(借鉴别人的做法 —— Remote Go Brr / Knit 框架脚本):
    --   旧实现【只】认 Shared.Packages.Network.rev_<n>; 而本游戏的 Remote 挂在
    --   ReplicatedStorage.Remote.<Service>.<Name>(抓包实锤: Any.RebackReward / GameService.Killed /
    --   CombatService.Ammo …) -> 导致 SYS.Fire / SYS.OnRemote 在这个游戏里【一直是死的】。
    --   现在四级兜底 + 结果缓存(cache 命中直接返回, 不重复遍历):
    --     ① 参数本身就是实例
    --     ② 完整路径 "Any.RebackReward" / "服务名.事件名"(从 ReplicatedStorage.Remote 起算)
    --     ③ ReplicatedStorage.Remote 下按名字【递归】找(限深度 3)
    --     ④ 老式网络库: Shared.Packages.Network 的 rev_/ref_<n>
    local RRemoteCache={}
    local function findRemote(n,wantCls)
        if typeof(n)=="Instance" and n:IsA(wantCls) then return n end
        if type(n)~="string" or n=="" then return nil end
        local ck=wantCls.."|"..n
        local hit=RRemoteCache[ck] if hit and hit.Parent then return hit end
        if not RStorage then return nil end
        local function ok2(inst) return inst and inst:IsA(wantCls) and inst or nil end
        -- ② 完整/两段路径: "A.B" 或直接名字
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
            -- ③ Remote 下递归(限深度 3)
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
        -- ④ 老式网络库 rev_/ref_
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
    -- ★ 触发 RemoteFunction(别人的脚本大量用 :InvokeServer(); 我们原来没有这个原语)
    --   ⚠ 预留接口: 目前没有功能调用它 —— 做"自动领奖/自动购买"这类需要回包的功能时用它,
    --     别当死代码删了。(功能本身有 pcall 兜底, 失败返回 false)
    function SYS.Invoke(n,...)
        local r=SYS.RFunction(n) if not r then return false,nil end
        local a=table.pack(...)
        local ok,res=P(function() return r:InvokeServer(table.unpack(a,1,a.n)) end)
        return ok,res
    end
    -- ★ 触发 UnreliableRemoteEvent(高频信号用, 人的项目里也有)
    --   ⚠ 预留接口: 目前没有功能调用它 —— 高频(每帧级)信号用它比 RemoteEvent 省带宽, 别当死代码删了。
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
local Fire=SYS.Fire local OnRemote=SYS.OnRemote

-- ★★ 新增: 回血 / 复活 / 重生 —— ★关键在于"走【游戏自己的 remote】", 这才是**服务端认可的真实生效**。
--   ⚠️ 为什么不能"客户端改血": 直接写 Humanoid.Health / Player 的 @Health **只骗自己** ——
--   服务端才是权威, 下一次复制就把你的修改盖回去(这个项目的血量本来就以 Attribute 为准, 同理)。
--   ✅ 事件库(2026-09-18 完整Remote清单)已确认这三条 remote 存在, 所以按用户"有就加入"的规矩加进来:
--        ReplicatedStorage.Remote.EntityService.Heal   回血
--        ReplicatedStorage.Remote.GameService.Revive   复活
--        ReplicatedStorage.Remote.GameService.Respawn  重生
--   ⚠️ 清单里没记参数形式 -> 先按【无参】发; 服务端会自己校验(参数不对通常被忽略, 不会出事)。
function SYS.HealSelf()
    local ok=SYS.Fire("Heal")
    SYS.Notify(ok and "🩹 已发送回血请求 (EntityService.Heal)" or "回血失败: 没找到 EntityService.Heal(换图/改版了?)",
               ok and SYS.CY.green or SYS.CY.yellow)
    return ok
end
function SYS.ReviveSelf()
    local ok=SYS.Fire("Revive")
    if not ok then ok=SYS.Fire("Respawn") end
    SYS.Notify(ok and "✨ 已发送复活请求 (GameService.Revive)" or "复活失败: 没找到 Revive/Respawn",
               ok and SYS.CY.green or SYS.CY.yellow)
    return ok
end
function SYS.RespawnSelf()
    local ok=SYS.Fire("Respawn")
    SYS.Notify(ok and "♻ 已发送重生请求 (GameService.Respawn)" or "重生失败: 没找到 Respawn",
               ok and SYS.CY.green or SYS.CY.yellow)
    return ok
end

--============================================================
-- [05] 移动模块
--============================================================
do
    local FlyBV,FlyGyro,SpeedBV,SpeedGyro,gravZero=false,false,false,false,false
    -- ★ v123: 加速的新执行器(老式 SpeedBV/SpeedGyro 已弃用, 保留作兼容选项)
    local SpeedAtt,SpeedLV=false,false
    local InfiniteJumpConn=nil
    local noclipThread=nil
    -- ★ v3.9.0 穿墙防回弹: 轻推用的速度约束(移动时沿前进方向给温和推力挤过服务端碰撞)
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

    -- ★ v116 飞行执行器重写(参考公开实现 Archon 的 FlyController / Ziffixture 的 Fly.lua)
    --   三个"不被拉回"的关键点(社区共识, 也是官方推荐用法):
    --     ① 【不再改 WS.Gravity=0】。那只是【客户端本地】改重力, 服务端照样给他的角色施加重力,
    --        两边算出来不一致 -> 服务端位置校正把你拽回去 —— 这就是"开飞行被拉回"的经典来源。
    --        改用 LinearVelocity(MaxForce=无穷大) 只对角色自身抵消重力, 不动全局。
    --     ② 【接管 Humanoid 状态机】: 关掉 Running + ChangeState(PlatformStanding)。
    --        否则角色控制器一直在跟你的速度"抢方向盘"(贴地时尤其明显) -> 抖动/回弹。
    --     ③ 【不要逐帧写 root.CFrame】。那是"逐帧瞬移", 服务端位置校验必然把你拉回。
    --        只用速度约束驱动。所以 CFrame 模式已在 UI 标注为"会被拉回、不推荐"。
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
        SYS.FlyTeardown()                       -- 角色重生/换 root 时自愈重建(参考 Archon 的 createFly)
        -- ★ v3.9.0 老执行器兼容: Attachment/LinearVelocity/AlignOrientation 在部分老执行器里
        --   Instance.new 会直接报错(或属性不存在) —— 整段用【裸 pcall】包住(不进 P() 的错误统计),
        --   任何一步失败就返回 false, 由调用方自动降级成 BodyVelocity。绝不半途抛错炸掉渲染循环。
        local okF=pcall(function()
            a=Instance.new("Attachment") a.Name="CM_FlyAtt" a.Parent=root
            v=Instance.new("LinearVelocity") v.Name="CM_FlyVel" v.Attachment0=a
            v.MaxForce=math.huge
            pcall(function() v.VelocityConstraintMode=Enum.VelocityConstraintMode.Vector end)
            v.VectorVelocity=Vector3.zero v.Parent=root
            al=Instance.new("AlignOrientation") al.Name="CM_FlyAlign" al.Attachment0=a
            pcall(function() al.Mode=Enum.OrientationAlignmentMode.OneAttachment end)
            al.MaxTorque=math.huge al.Responsiveness=200 al.RigidityEnabled=false
            al.Parent=root
        end)
        if (not okF) or (not v) or (not al) then
            -- 半成品残骸当场清干净, 免得留一串"有 Attachment 没约束"的垃圾
            if v  then pcall(function() v:Destroy()  end) end
            if al then pcall(function() al:Destroy() end) end
            if a  then pcall(function() a:Destroy()  end) end
            SYS._FlyAtt,SYS._FlyVel,SYS._FlyAlign=nil,nil,nil
            return false
        end
        SYS._FlyAtt,SYS._FlyVel,SYS._FlyAlign=a,v,al
        return true
    end
    -- 接管/归还 Humanoid 状态机(这是"不被角色控制器拽回去"的关键)
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

    -- ★ v3.9.0: BodyVelocity 驱动 —— 「显式选了 BodyVelocity」和「Align 自动降级」两条路共用这一份,
    --   不许再写第二份(否则改一处漏一处, 就是"老执行器还能用"这类问题反复的来源)。
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
            -- ★ v3.10.3 修「CFrame 模式只有加速、飞不起来」: 旧实现逐帧写 root.CFrame += d.Unit*spd*dt,
            --   但【逐帧瞬移】会被服务端位置校验拉回 —— 尤其垂直方向, 每帧那点向上的位移被重力+服务端校正
            --   完全抵消, 于是只剩水平"加速"、垂直"飞不起来"。而且 PlatformStanding 状态机也会把角色
            --   锁在地面高度。修: CFrame 模式也改用 LinearVelocity 驱动(和 Align 同一条路), 用 MaxForce=∞
            --   的 LinearVelocity 真正抵消重力 + 提供三轴速度, 才能稳定悬浮/升降, 不再被拉回。
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
            -- 显式选的老执行器模式, 或已发生过一次自动降级
            FlyBodyDrive(root,d,spd)
            return
        end
        -- 模式 Align: Attachment + LinearVelocity + AlignOrientation
        if not FlyEnsure(root) then
            -- ★ v3.9.0 自动降级: 这台执行器造不出新约束 -> 本次改用 BodyVelocity, 飞行照样能用。
            --   记下 _FlyDegraded 免得每帧重试 + 每帧弹提示; 切模式/关飞行时 CleanFly 会清掉标记。
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
    -- ★ v3.9.0 反陷阱的两个基准值(以前各处各自硬编码, 就是"开反陷阱自带加速"的来源) ——
    --   expectSpeed()   = 用户【合理拥有】的速度(加速开关开着就含倍率, 与加速用什么模式无关)
    --                     -> 只用来判"我是不是被撞/被推了"。
    --   wantWalkSpeed() = 我们该把 WalkSpeed 写回多少。★只有加速的 WalkSpeed 模式才含倍率★,
    --                     其它模式(Linear/BodyVelocity)的加成走物理约束, 不走 WalkSpeed ——
    --                     所以这里绝不能把倍率算进去, 否则等于白送一份叠加加速。
    local function expectSpeed()
        local base=SYS.Orig.WalkSpeed or 16
        if SYS.T_.Speed then return base*(SYS.C_.SpeedMult or 1) end
        return base
    end
    local function wantWalkSpeed()
        local base=SYS.Orig.WalkSpeed or 16
        if SYS.T_.Speed and SYS.C_.SpeedMode=="WalkSpeed" then return base*(SYS.C_.SpeedMult or 1) end
        return base
    end
    function SYS.SpeedTick()
        if not SYS.T_.Speed or SYS.T_.Fly or SYS.FreeCamActive then return end
        local _,hum,root=GC() if not hum or not root then return end
        local spd=SYS.Orig.WalkSpeed*SYS.C_.SpeedMult
        -- ★ 审查: BodyVelocity 模式不再碰 WalkSpeed(旧版两者叠加≈2倍速); WalkSpeed 模式才写
        if SYS.C_.SpeedMode=="WalkSpeed" then
            -- ★ v3.10.0 修「WalkSpeed 模式没效果」: 旧实现只在 SpeedMult 变化时才写一次 WalkSpeed
            --   (`SpeedMult~=lastSM` 才写), 但很多游戏【每帧】把 WalkSpeed 重置回默认值(或反陷阱写回
            --   base 值) —— 倍率没变就不会再写, 于是加速一开就被游戏覆盖掉 -> 等于没加速。
            --   改成: 只要当前 WalkSpeed 偏离目标就写回(带 1% 容差, 避免每帧无谓赋值)。
            if math.abs(hum.WalkSpeed-spd)>spd*0.01 then hum.WalkSpeed=spd end
            lastSM=SYS.C_.SpeedMult
            return
        end
        -- ★ v123: 执行器换代(同飞行那次) —— 默认用【官方推荐】的 Attachment + LinearVelocity(Vector),
        --   旧的 BodyVelocity/BodyGyro 已被标记弃用, 降级为兼容选项保留。
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
        -- 默认 Linear: 角色重生后自愈重建(Instance 挂在 root 上)
        if not (SpeedAtt and SpeedAtt.Parent==root) or not (SpeedLV and SpeedLV.Parent==root) then
            if SpeedLV then SpeedLV:Destroy() SpeedLV=nil end
            if SpeedAtt then SpeedAtt:Destroy() SpeedAtt=nil end
            SpeedAtt=Instance.new("Attachment") SpeedAtt.Name="CM_SpdAtt" SpeedAtt.Parent=root
            SpeedLV=Instance.new("LinearVelocity") SpeedLV.Name="CM_SpdVel" SpeedLV.Attachment0=SpeedAtt
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
        -- ★ v116: 新执行器(Attachment/LinearVelocity/AlignOrientation)与 Humanoid 状态一起收干净
        if SYS.FlyTeardown then P(SYS.FlyTeardown) end
        if SYS.FlyReleaseStates then P(SYS.FlyReleaseStates) end
        SYS._FlyStateHeld=false
        -- ★ v3.9.0: 清掉"已自动降级"标记 —— 关飞行/切模式后重开会重新尝试一次所选执行器
        SYS._FlyDegraded=false
        -- 兼容兜底: v116 起不再改全局重力, 这里只负责清掉老版本可能留下的 gravZero 状态
        if gravZero then WS.Gravity=SYS.Orig.Gravity gravZero=false end
    end
    function SYS.CleanSpeed()
        if SpeedBV then SpeedBV:Destroy() SpeedBV=nil end
        if SpeedGyro then SpeedGyro:Destroy() SpeedGyro=nil end
        -- ★ v123: 新执行器(Attachment + LinearVelocity)一起销毁, 别在角色上留残留
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
        -- ★ v3.9.0 穿墙防回弹: 关穿墙时一并清掉轻推用的速度约束
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
                    -- ★ v3.9.0 防回弹: 服务端自己做碰撞时, 光关 CanCollide 会被服务端位置校正
                    --   推回墙外。这里在你【正朝某个方向移动】时, 沿移动方向给一个温和推力
                    --   (LinearVelocity, 力量远小于飞行), 帮你挤过服务端判定。不动时不推, 避免误位移。
                    local root=c:FindFirstChild("HumanoidRootPart")
                    local cam=WS and WS.CurrentCamera
                    if root and cam and cam.CFrame then
                        local d=GetInputDir(cam.CFrame)
                        if d.Magnitude>0.1 then
                            if not NoclipVel or NoclipVel.Parent~=root then
                                if NoclipVel then NoclipVel:Destroy() end
                                if NoclipAtt then NoclipAtt:Destroy() end
                                local okA,att=pcall(function()
                                    local a=Instance.new("Attachment") a.Name="CM_NoclipAtt" a.Parent=root
                                    return a
                                end)
                                local okV,vel=pcall(function()
                                    local v=Instance.new("LinearVelocity") v.Name="CM_NoclipVel"
                                    v.Attachment0=att v.MaxForce=math.huge
                                    v.VectorVelocity=Vector3.zero v.Parent=root
                                    return v
                                end)
                                if okA and att and okV and vel then
                                    NoclipAtt=att NoclipVel=vel
                                end
                            end
                            if NoclipVel then
                                -- 推力 = 移动方向 × 一个温和倍率(约正常走速), 只用于挤墙、不抢走你的操控
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

    --================ ★ v6.6.0 数值锁定 (融合自 ChronixHub 基础设置页的「滑块 + 锁定」成对模式) ================
    -- 为什么需要: 不少游戏的脚本 / 反陷阱回写会【每帧把属性改回默认值】 —— 于是"滑块拖了,
    --   过一会儿自己变回去"。锁定 = 持续抢回, 让设定值稳住(这就是 ChronixHub 那套的标准做法)。
    -- 与现有功能的关系: 不替代「加速」「超级跳跃」, 而是给它们【加一层不回弹的保护】——
    --   锁移速的目标值会跟着「移动速度倍率」走(开着加速时锁的是加速后的值)。
    -- 只写自己角色的属性 + 本地 Workspace.Gravity -> 只影响本客户端。
    -- 卸载对称: 走 SYS.SetLoop(连接统一登记进 SYS.Loops) + UnloadAll 里已有的 WS.Gravity 还原。
    local LOCK_EPS=0.35
    local function lockOrigJump(hum)
        -- JumpPower / JumpHeight 谁在用由 Humanoid.UseJumpPower 决定, 两个都记下来按需锁
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
                if SYS.T_.Speed then want=base*(SYS.C_.SpeedMult or 1) end
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
    -- 三个开关共用一个循环 key —— 否则开两个会连两条 PhysicsStep, 同一帧跑两遍
    function SYS.SetLocks()
        SYS.SetLoop("Locks",
            (SYS.T_.LockSpeed or SYS.T_.LockJump or SYS.T_.LockGravity) and true or false,
            SYS.PhysicsStep,SYS.LockTick)
    end

    --================ ★ v6.6.0 Ctrl+数字 路径点直达 (融合自 ChronixHub 路径点页的快捷键) ================
    -- 按住 Ctrl 再按数字键 N(1~9) -> 传送到「已保存位置」列表第 N 项; 主键盘和小键盘都认。
    -- 只走本地传送(SYS.TPTo, 与列表点击完全同一条路径), 不新增任何对别人生效的东西。
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
            -- ★ v6.7.0 路径点优先(WPKey 打开时, 该序号有路径点就先去路径点)
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

    --================ ★ v6.6.0 手动选服 (融合自 ChronixHub ServerFinderModule) ================
    -- 我们原来只有「自动跳到下一个低延迟服务器」(SYS.HopLowPing) —— 这里补上 ChronixHub 那种
    -- 【列出全部服务器 -> 自己挑一个加入】的交互(想挑人多的 / 人少的 / 稳定的都行)。
    -- 复用同一条官方接口 + TeleportService, 纯只读列表 + 官方跳转, 不新增任何对别人生效的东西。
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
        -- ★ 同 HopLowPing: 没有 queue_on_teleport 的话跳过去脚本就没了 -> 先明说
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

    --================ ★ v122 反陷阱免伤 ================
    -- 用户要求: 地图上各类道具/生物/陷阱的攻击与控制都免; 被滚石撞了不掉血、不弹开、不被压着推走。
    -- ★ 诚实边界(先说清楚, 免得当成"无敌"):
    --   【能免】① 位移/弹开/被推走  ② 定身(WalkSpeed 被清零)  ③ 布娃娃(Physics/PlatformStand)
    --          ④ 坐骑锁定  ⑤ 被焊接钉住  ⑥ 客户端脚本结算的伤害
    --     原因: 客户端拥有自己角色的物理(network ownership) -> 每帧抢回来就有效。
    --   【免不了】服务端结算的伤害 与 服务端强制的人形状态
    --     —— 服务端是权威, 它复制下来的 Health/状态会盖掉客户端的写入。
    --     所以这个开关的实际强度 = 【本局的伤害/状态是谁结算的】决定的(休闲图多数在客户端, 就基本无敌)。
    local TrapConns,TrapOn=nil,false
    local TRAP_WIN  = 0.45    -- 被撞后的"复位窗口"(秒): 窗口内持续压回, 过了就恢复正常
    local TRAP_SPD  = 1.6     -- 水平速度 > 正常走路速度的这个倍数 -> 判定"被撞/被推"
    local TRAP_BACK = 1.2     -- 被撞后位置被拉走超过这么多格 -> 开始压回
    local TRAP_MAXSTEP = 40   -- 每帧最多回拉多少格(渐进; 一次拉太多会触发 267 Illegal Teleport 踢人)
    function SYS.CleanTrapGuard()
        TrapOn=false
        if TrapConns then for _,c in ipairs(TrapConns) do DS(c) end end
        TrapConns=nil SYS.TrapHit=false
        P(SYS.TrapIgnore)      -- 顺手把"无视触发"的触碰状态也还原(关开关/卸载都要对称还原)
    end

    -- ★ v3.9.0「无视陷阱触发」: 把角色所有 BasePart 的 CanTouch/CanQuery 关掉,
    --   陷阱的 Touched 判定 / 射线命中根本收不到"你" —— 直接不触发, 而不是触发后再抢救。
    --   ⚠ 老实说清边界: ① 这会同时让"友好交互"(捡东西/踩机关)也失效 —— 本来就是"无视一切触碰";
    --                  ② 服务端自己的碰撞/校验不归客户端管, 部分地图仍可能被服务端判中;
    --                  ③ 会连带关掉上面①那条 Touched 触发器 —— 所以"速度异常"兜底已挪到 RenderStepped。
    local TrapIgnored=false
    function SYS.TrapIgnore(on)
        if on and TrapIgnored then return end      -- 幂等: 反复开不重扫
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
        -- ① 触发判定(只读, 不改游戏逻辑): 钉在角色的 HumanoidRootPart 上听 Touched,
        --   并把"我自己速度异常"也算作被撞 —— 有些陷阱不触发 Touched(纯物理推动/区域判定)。
        local function hookChar(ch)
            if not ch then return end
            local hrp=ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            table.insert(TrapConns,hrp.Touched:Connect(function(hit)
                if not (TrapOn and SYS.T_.TrapImmune) then return end
                local v=hrp.AssemblyLinearVelocity
                local hv=Vector3.new(v.X,0,v.Z).Magnitude
                -- ★ v3.9.0: 基准改用 expectSpeed()。旧代码硬编码 Orig.WalkSpeed, 而加速开着时
                --   我的实际速度本来就超过它 -> 【自己】被判成"被撞", 于是每帧清零水平速度 + 回拉。
                local ws=expectSpeed()
                local hitV=0
                P(function() hitV=hit.AssemblyLinearVelocity.Magnitude end)
                if hv>ws*TRAP_SPD or hitV>ws*TRAP_SPD then
                    SYS.TrapHit=os.clock()          -- 记下撞击时刻 -> 进入复位窗口
                    SYS.TrapAnchor=hrp.Position     -- 记下撞击前的位置 -> 作为"不被推走"的锚点
                end
            end))
        end
        hookChar(LP.Character)
        table.insert(TrapConns,LP.CharacterAdded:Connect(function(c)
            hookChar(c)
            -- ★ v3.9.0: 重生后新角色默认 CanTouch/CanQuery 是 true —— 立即重新"无视"掉
            if TrapIgnored then P(function() SYS.TrapIgnore(true) end) end
        end))
        -- ② 每帧维持(免疫范围全在这里)
        -- ★ v3.9.0: 回调要收 dt 来给 (f) 的"回拉"限速
        TrapConns[#TrapConns+1]=RS.RenderStepped:Connect(function(dt)
            if SYS.Unloaded or not TrapOn or not SYS.T_.TrapImmune then return end
            P(function()
                local ch,hum,hrp=GC()
                if not ch or not hum or not hrp then return end
                -- (0) ★ v3.9.0: "我自己速度异常"的兜底判定挪到 RenderStepped, 不再只挂在 Touched 回调里。
                --   两个原因: ① 有些陷阱不触发 Touched(纯物理推/区域判定), 原来那条兜底根本跑不到;
                --             ② 开了「无视陷阱触发」后角色 CanTouch=false, 自己的 Touched 彻底不触发,
                --                兜底若还挂在里面就等于没有。
                --   ⚠ 飞行/加速/自由视角开着时跳过: 那几种状态下"速度大"是用户自己要的, 不是被撞。
                if not (SYS.T_.Fly or SYS.T_.Speed or SYS.FreeCamActive) then
                    local vv=hrp.AssemblyLinearVelocity
                    if Vector3.new(vv.X,0,vv.Z).Magnitude>expectSpeed()*TRAP_SPD then
                        if not SYS.TrapHit then SYS.TrapAnchor=hrp.Position end
                        SYS.TrapHit=os.clock()
                    end
                end
                -- (a) 伤害: 掉了立刻补满。对【客户端结算】的伤害有效(服务端结算的会被再次覆盖)
                if hum.Health>0 and hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end
                -- (b) 定身: 游戏把 WalkSpeed 清零/调小 -> 每帧写回【用户本来就该有的速度】
                --   ★ v3.9.0 修「开反陷阱免伤自带加速」: 旧代码无条件写 Orig.WalkSpeed*SpeedMult(=32),
                --   而加速的默认模式是 Linear(走物理约束, 不碰 WalkSpeed) -> 等于白送一份叠加加速。
                --   现在只在加速的 WalkSpeed 模式下才把倍率算进去(wantWalkSpeed 负责这层判断)。
                local want=wantWalkSpeed()
                if hum.WalkSpeed<want*0.9 then hum.WalkSpeed=want end
                -- (c) 布娃娃/平台站立: 抢回控制(上帝模式开着时不抢, 免得两个功能互相打架)
                if not SYS.T_.GodMode then
                    local ok,st=pcall(function() return hum:GetState() end)
                    if (ok and st==Enum.HumanoidStateType.Physics) or hum.PlatformStand==true then
                        P(function() hum.PlatformStand=false hum:ChangeState(Enum.HumanoidStateType.Running) end)
                    end
                end
                -- (d) 坐骑锁定(陷阱常用 Seat 把人钉住)
                if hum.Sit then P(function() hum.Sit=false end) end
                -- (e) 被焊接: 断开【非角色自带】的焊接。自带关节的 Part0/Part1 一定含 HumanoidRootPart,
                --     所以这条不会误伤自己的骨骼。
                for _,d in ipairs(ch:GetDescendants()) do
                    if d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") then
                        if d.Part0~=hrp and d.Part1~=hrp then DS(d) end
                    end
                end
                -- (f) ★ 受击后的"反弹与位移逻辑" = 不反弹、不位移:
                --     水平速度清零(竖直保留, 不影响下落/跳跃) + 位置被拉走就【渐进】压回锚点。
                --     为什么是"压回"不是"反弹": 反弹会产生新位移, 服务端看到的还是异常位移;
                --     压回锚点 = 服务端看到你基本原地不动, 这才是"不被推开"。
                local hit=SYS.TrapHit
                if hit and (os.clock()-hit)<TRAP_WIN then
                    local v=hrp.AssemblyLinearVelocity
                    hrp.AssemblyLinearVelocity=Vector3.new(0,v.Y,0)
                    local a=SYS.TrapAnchor
                    if a then
                        local d=hrp.Position-a
                        local hz=Vector3.new(d.X,0,d.Z)
                        local hzm=hz.Magnitude
                        if hzm>TRAP_BACK then
                            local dir=hz.Unit
                            -- ★ v3.9.0 回拉限速: 旧写法每帧最多 TRAP_MAXSTEP=40 格 = 2400 格/秒 ——
                            --   那不叫"回位", 叫"瞬移", 引擎/服务端会当成高速位移(表现就是开了加速),
                            --   极端情况还会撞 267。现在按【合理速度的 1.5 倍】限速: 照样压得住被推走,
                            --   但始终待在正常移动的量级里。TRAP_MAXSTEP 保留作硬上限。
                            local cap=math.min(TRAP_MAXSTEP, math.max(0.5, expectSpeed()*(dt or 1/60)*1.5))
                            local np=hrp.Position-dir*math.min(hzm,cap)
                            -- 保留当前朝向: 旧写法 CFrame.new(Vector3) 会把角色朝向重置成 +Z
                            local rot=hrp.CFrame-hrp.CFrame.Position
                            hrp.CFrame=CFrame.new(Vector3.new(np.X,np.Y,np.Z))*rot
                        end
                    end
                elseif hit then
                    SYS.TrapHit=false
                end
            end)
        end)
        -- ★ v114(审计修复 EV-03): 上面这三条连接(角色 Touched / CharacterAdded / RenderStepped)
        --   以前【没有】登记进 SYS.Conns, 而卸载清单里又漏了 CleanTrapGuard —— 于是"开着反陷阱
        --   卸载"会把 CharacterAdded + RenderStepped 留在世界里; 每次"卸载→重载"再叠一条。
        --   (回调内部靠 SYS.Unloaded / SYS.T_ 早退, 不会产生错误行为, 但白跑且持续累积。)
        --   现在统一登记: 卸载时随 SYS.Conns 一起断开 —— 与卸载显式调 CleanTrapGuard 双保险。
        for i=1,#TrapConns do T(TrapConns[i]) end
        -- ★ v3.9.0「无视触发」: 开开关即关掉角色触碰/射线命中 —— 陷阱直接不触发
        P(function() SYS.TrapIgnore(true) end)
        print("[CheatMenu] 反陷阱免伤: 已开启(无视触发 + 免疫 位移/弹开/定身/布娃娃/坐骑/焊接 + 补血; 服务端结算的伤害拦不住)")
    end
end
--============================================================
-- [06] 上帝 / 全亮 / 玩家穿透
--============================================================
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
        -- ★ v6.7.0 用户要求: 防死亡 / 防击倒【并入】上帝模式(开上帝模式即同时生效)
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

    -- ★ v68: 无坠落伤害 (参考 GitHub ADMIN-HUB NoFallDamage 补齐)
    --   禁 FallingDown(落地摔倒受伤) + Freefall(自由落体), 从高处跳下不掉血。
    --   FallingDown 与 GodMode 共享: 任一功能开着就保持禁用, 关掉时按另一功能状态回退。
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

    -- ★ v68: 超级跳跃 (参考 GitHub ADMIN-HUB JumpPower 补齐)
    --   放大 JumpPower 与 JumpHeight(新 API), 首次应用时缓存原始值以便恢复。
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
            -- ★ v83 地图高亮: 关阴影 + 关掉限制视野的后期效果(景深/模糊/泛光/光晕/色偏)
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

    -- ★ v68.8 藏地下隐身 v2: 角色真传送进地下(服务器认可) + 【相机留在地面】
    --   原理: 本地隐形锚点 Part 固定在地面高度, 每帧同步角色的 X/Z —— 相机跟锚点走,
    --   看起来就像正常第三人称在地面走, 只是画面里没有你; 角色(和服务器视角的你)在地下。
    --   交互/射击射线从相机出发 -> 相机在地面就能正常点人/开枪(能否命中取决于游戏服务器校验)。
    --   ⚠ 服务器可能检测异常位置校正/踢人; 向下速度维持所有权减轻回弹。
    local DeepHideConn, DeepHideCharConn, DeepHideAnchor, DeepHideY = nil, nil, nil, 0
    -- ★ v68.9 抽公共逻辑: 建锚点 + 传送角色到地下 + 相机跟锚点(重生时复用)
    -- ★ v69 藏地下隐身三修(用户反馈"开了藏地下隐身, 我的速度被影响了" + 挂一会儿就摔死):
    --   ① 旧版每帧写 AssemblyLinearVelocity=(0,-30,0) —— 连【水平分量一起清零】。移动控制器
    --      刚给的水平速度, 下一帧就被抹掉 -> 走不动 / 越走越慢, 这就是"速度被影响"的真身。
    --      现在只掐 Y 分量, 水平速度原样保留(下沉与走位互不干扰)。
    --   ② 旧版每帧给恒定 -30 = 角色以 30 studs/s 【永远】下沉, 十几秒后越过
    --      Workspace.FallenPartsDestroyHeight(默认 -500) 被引擎销毁 -> 直接摔死/被重置。
    --      现在算一个安全深度, 并对 Y 做硬上限(漂出去就拉回)。
    --   ③ 地下没有地面 -> Humanoid 永远是 Freefall(空中控制, 移动手感本来就差), 而且很多游戏
    --      有"掉出地图就重置角色"的逻辑。现在在脚下放一块【客户端隐形地板】, 角色正常站立行走。
    local DeepHideFloor=nil
    local DH_ACC=0
    -- ★ v69.1 角色【脚底】的世界 Y(拿不到就用 root-3 这个通用估算)
    --   地板必须按它来放: 顶面高于脚底 = 角色嵌进地板 -> 卡住走不动。
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
    -- ★ v69 深度可调(界面「藏地下隐身深度」滑杆, 参数会持久化):
    --   小(10~20): 贴着地面下面 —— 别人看你在下面, 但商店/NPC/偷取这类【按距离判定】的
    --     交互还有机会够到(相当于"半隐身"); 代价是更可能被看见/被判定到。
    --   大(120+): 藏得深, 基本看不见 —— 但所有按距离判定的世界交互都够不到。
    --   (射线类攻击不受深度影响: 命中判定在客户端, 静默/快照瞄准会把射线换成直指目标。)
    local function deepHideDepthNow()
        local d=tonumber(SYS.C_.DeepHideDepth) or 120
        if d<5 then d=5 elseif d>400 then d=400 end
        -- 硬约束: 不能低于 FallenPartsDestroyHeight, 低于它角色会被引擎直接销毁
        local ok,fdh=P(function() return WS.FallenPartsDestroyHeight end)
        if ok and type(fdh)=="number" and fdh>-1e6 then
            local maxD=DeepHideY-fdh-60
            if maxD>=5 and d>maxD then d=maxD end
        end
        return d
    end
    -- ★ v3.10.0 藏身目标位置: 支持「天上/地下」+「左右/前后偏移」。
    --   方向: down = 地表 Y 往下挖 depth; up = 往上抬 depth(藏天上)。
    --   偏移: 相对【开启点】的 X(左右, 正右负左) 与 Z(前后, 正前负后), 单位格。
    --   返回的只是一个 Vector3(锚点仍锁在开启时的地表高度, 偏移只作用在角色身上)。
    local function deepHideTarget(root)
        local depth=deepHideDepthNow()
        local sign=(tostring(SYS.C_.DeepHideMode or "down")=="up") and 1 or -1
        local ty=DeepHideY + sign*depth
        local ox=tonumber(SYS.C_.DeepHideOffX) or 0
        local oz=tonumber(SYS.C_.DeepHideOffZ) or 0
        return Vector3.new(root.Position.X+ox, ty, root.Position.Z+oz)
    end
    -- ★ v68.9 抽公共逻辑: 建锚点 + 传送角色到地下 + 相机跟锚点(重生时复用)
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
        -- ★ v3.10.0: 藏身目标位置(含天上/地下 + 左右前后偏移)
        local tp=deepHideTarget(root)
        root.CFrame=CFrame.new(tp.X,tp.Y,tp.Z)
        pcall(function() root.AssemblyLinearVelocity=Vector3.zero end)
        -- ★ v69 ③ 隐形地板(纯客户端, 不与其他玩家/服务器同步):
        --   CanQuery/CanTouch 关掉 -> 不影响索敌射线与任何触发; 只给角色一个可以站的地面。
        if DeepHideFloor then DeepHideFloor:Destroy() DeepHideFloor=nil end
        local fl=Instance.new("Part")
        fl.Name="DH_Floor" fl.Size=Vector3.new(400,2,400) fl.Transparency=1
        fl.Anchored=true fl.CanCollide=true fl.CanQuery=false fl.CanTouch=false
        -- ★ v69.1: 顶面放在脚底下方 1 格(中心 = 脚底-1-1), 保证角色是"落到地板上"而不是嵌在里面
        fl.CFrame=CFrame.new(tp.X,DeepHideFeetY(root)-2,tp.Z)
        fl.Parent=WS
        DeepHideFloor=fl
        local cam=WS and WS.CurrentCamera
        if cam then pcall(function() cam.CameraSubject=a end) end
    end
    function SYS.SetDeepHide(on)
        -- ★ v68.9 两个连接分开管理: 之前共用一个 DeepHideConn, 后写的 CharacterAdded
        --   覆盖了 RenderStepped, 导致关闭时 RenderStepped 永久泄漏(锚点循环每帧空转)。
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
                -- 锚点跟随角色 X/Z, Y 锁在开启时的地面高度(每帧: 相机要跟手, 不然画面一顿一顿)
                if r and DeepHideAnchor and DeepHideAnchor.Parent then
                    DeepHideAnchor.CFrame=CFrame.new(r.Position.X,DeepHideY,r.Position.Z)
                end
                -- 游戏把相机抢回去就再指回锚点
                if cc and DeepHideAnchor and cc.CameraSubject~=DeepHideAnchor then
                    pcall(function() cc.CameraSubject=DeepHideAnchor end)
                end
                -- ★ v69 ②③ 深度维持(30Hz, 不再每帧写物理属性):
                --   只掐竖直速度, 【保留水平速度】-> 走位速度不再被影响;
                --   只在漂出安全范围时才硬拉回一次, 不会永远下沉。
                DH_ACC=DH_ACC+(tonumber(dt) or 1/60)
                if r and DH_ACC>=1/30 then
                    DH_ACC=0
                    -- ★ v3.10.0: 目标 Y 用 deepHideTarget 算(支持天上/地下); 偏移不参与垂直维持
                    local tp=deepHideTarget(r)
                    local hy=tp.Y
                    local sign=(tostring(SYS.C_.DeepHideMode or "down")=="up") and 1 or -1
                    local p=r.Position
                    -- ★ v69.1 用户反馈"开启状态下移动不生效": 位置每帧被硬拉回会让移动输入反复
                    --   被打断。现在只有【漂出安全范围】才硬拉回; 被服务器反向拉时改用
                    --   竖直速度压回隐藏深度 —— X/Z(也就是你的走位)一律不碰。
                    -- ★ v3.10.0: 地下(sign=-1)= 沉太深才拉回、被往上拉则向下压;
                    --            天上(sign=+1)= 飘太高才拉回、被往下拽则向上顶。
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
                    -- 地板跟着角色走(漂 >60 才动, 免得地板推着角色走), 顶面始终留在脚底下方
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
                if r then deepHideApply(r) end -- ★ v68.9 重生后重建锚点
            end)
            T(DeepHideCharConn)
        else
            -- ★ v88: 关闭分支必须先判断"是否真的开启过" —— UnloadAll 会【无条件】调用
            --   SetDeepHide(false), 而用户可能从没开过藏地下: 此时 DeepHideY 还是初始值 0,
            --   旧代码照样执行浮回 -> 射线从世界 Y=8 向下打 -> 命中即把角色瞬移到低处/地下
            --   (用户实测: 没开藏地下, 点卸载被瞬移 + Illegal Teleport 267 踢出)。
            --   只有真正开过(锚点/地板还在)才需要收尾; 重复关闭也在这里安全返回。
            if not (DeepHideAnchor or DeepHideFloor) then return end
            local ch=LP.Character
            local root=ch and ch:FindFirstChild("HumanoidRootPart")
            -- ★ v69.1 用户要求: 关闭时【不要弹回"开启时那个点"】——
            --   就在当前 X/Z 原地浮回地面(走了一段路之后不会被拉回原点)。
            --   地面高度优先用向下射线实测(地形/高度变化也对得上), 拿不到才用开启时记录的表层 Y。
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
                    -- 从"开启时记录的地表"上方 8 格往下打, 拿到脚下真实地面(避免打到更上方的屋顶)
                    local hit=WS:Raycast(Vector3.new(pos.X,(DeepHideY or pos.Y)+8,pos.Z),Vector3.new(0,-600,0),rp)
                    if hit and hit.Position then ty=hit.Position.Y end
                end)
                if type(ty)~="number" then ty=DeepHideY end
                local rot=(root.CFrame-root.CFrame.Position)   -- 保留当前朝向
                -- ★ v3.9.0 用户要求改回【单帧浮回】: 关闭瞬间一步回到地面。
                --   ⚠️ 风险提示(用户已知情并确认): 单帧 CFrame 从地下拉回 = 服务端可能判
                --   Illegal Teleport(错误 267)踢出 —— 这是 v87 改成渐进浮回的原因。
                --   现在按用户要求改回单帧; 保留朝向, 原地(X/Z 不变)浮到实测地表上方 3 格。
                pcall(function()
                    root.CFrame=CFrame.new(pos.X,ty+3,pos.Z)*rot
                    root.AssemblyLinearVelocity=Vector3.zero
                end)
                print(("[DeepHide] 单帧浮回地面 (X=%.0f Z=%.0f  %.0f -> %.0f)")
                    :format(pos.X,pos.Z,pos.Y,ty+3))
            end
            if DeepHideAnchor then DeepHideAnchor:Destroy() DeepHideAnchor=nil end
            if DeepHideFloor then DeepHideFloor:Destroy() DeepHideFloor=nil end  -- ★ v69 地板一起清
            local cc=WS and WS.CurrentCamera
            local h=ch and ch:FindFirstChildOfClass("Humanoid")
            if cc and h then pcall(function() cc.CameraSubject=h end) end
        end
    end

    -- ★ v69: 拖动「藏地下隐身深度」时立刻按新深度重新落位(不必关掉再开)
    --   相机锚点仍停在开启时的地面高度 -> 视角不变, 只有"你在地下多深"变了。
    function SYS.DeepHideReapply()
        if not SYS.T_.DeepHide then return end
        local ch=LP.Character
        local root=ch and ch:FindFirstChild("HumanoidRootPart")
        if not root then return end
        -- ★ v3.10.0: 用 deepHideTarget 统一算(支持天上/地下 + 偏移)
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

    -- ★ v68.6 重进服务器(参考 Infinite Yield rejoin)
    function SYS.Rejoin()
        pcall(function()
            local TS=game:GetService("TeleportService")
            if TS and TS.Teleport and game.PlaceId then
                TS:Teleport(game.PlaceId)
            end
        end)
    end

    --================ ★ 延迟：测量 / 低延迟模式 / 自动跳到低延迟服务器 ================
    -- 参考公开实现(qWixxyLuau/FlamesHub 的 SAB Auto Joiner、NHMdz/BloxFruit 的 Hop) —— 三条硬事实:
    --   ① 服务器列表 API: `games.roblox.com/v1/games/{placeId}/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true`
    --      ★ 返回里【没有可靠的 ping 字段】(公开实现也不用它) -> 想找低延迟只能"跳过去再测", 不满意再跳下一个。
    --   ② 跳指定服务器要用 `TeleportService:TeleportToPlaceInstance(placeId, jobId, LP)`。
    --   ③ ★ 必须 `queue_on_teleport(重新注入脚本)` —— 否则跳完脚本就没了(公开实现里最容易漏的一条)。
    -- ★★ 诚实边界: **ping 由你到 Roblox 数据中心的物理距离决定, 客户端改不了**。
    --    能做的只有两件: (a) 换到延迟更低的服务器; (b) 压低【帧时间】(这不是 ping, 但操作更跟手、画面更顺)。
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

    -- 低延迟模式: 只压帧时间(全部可逆, 关掉原样还原)
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
            P(function() if SYS.SetPerf then SYS.SetPerf(true) end end)   -- 顺带把帧率优化开上
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

    -- 跳服务器找低延迟。★ 防死循环: 已跳次数用 queue_on_teleport 带到新服(_G.CM_HOPN), 超上限就停。
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
        -- ★ 重新注入: 网络版用脚本自己的地址; 本地版没有地址 -> 明说, 不假装能自动回来
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

    -- 自动判定: ping 超阈值就跳(开关 AutoLowPing 打开时由启动流程调用)
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

    -- ★ v68.7 观战别人(看别人视角): 相机跟随目标 —— 用于搞怪后看效果/观察别人
    --   v3.9.0 恢复(3.7.2 清理时误删): 连接登记进 SYS.Conns, 卸载时一并断开。
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

    -- ★ v68.8 全方位扫描 v2: 网络 Remote + 本地 Bindable + 交互件 全部扫出来分类统计
    --   (原来只扫 RemoteEvent/RemoteFunction, 现在把 BindableEvent/BindableFunction/
    --    ProximityPrompt/ClickDetector 也扫上, 范围加 StarterGui/LocalPlayer/CoreGui)
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
        print(("[Remote] ===== 全方位扫描: 网络 RemoteEvent %d + RemoteFunction %d | 本地 BindableEvent %d + BindableFunction %d | 交互 ProximityPrompt %d + ClickDetector %d =====")
            :format(counts.RE,counts.RF,counts.BE,counts.BF,counts.PP,counts.CD))
        for i,r in ipairs(found) do print("  ["..i.."] "..r) end
        print("[Remote] 扫描完成, 清单在上面")
        SYS.Notify(("扫描完成: 网络 %d · 本地 %d · 交互 %d (看控制台)")
            :format(counts.RE+counts.RF,counts.BE+counts.BF,counts.PP+counts.CD),SYS.CY.cyan)
        return found
    end

    local NCConns={}
    -- ★ v52(F36): NCCache/NCByPlayer 用弱键表。原实现是普通表, 会强引用已离开的 Player
    --   及其角色 parts —— 长会话里玩家进出越多, 泄漏越大, 且阻止 Player 被 GC。
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
    -- ★ v52(F36): 玩家离开时断开其连接 + 清缓存, 避免 NCConns 数组持续累积死连接
    T(Players.PlayerRemoving:Connect(function(p)
        local conn=NCByPlayer[p]
        if conn then
            pcall(function() conn:Disconnect() end)
            NCByPlayer[p]=nil
            -- ★ 轮7: 从 NCConns 数组移除(旧版只 Disconnect 不清数组, 死连接随玩家进出持续累积)
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
--============================================================
-- [07] 帧率优化 (含纹理/画质降级)
--============================================================
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
                -- ★ v49.6 爆炸特效减弱(防闪屏+防意外伤害)
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
                -- ★ v68.5 强制兼容渲染模式(参考开源 FPS booster): FPS 提升最明显的一招
                BkProp(LT,"Technology") LT.Technology=Enum.Technology.Compatibility
                -- 禁用 2022 新材质(省显存/渲染)
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
            -- ★ v52(F43): swap-remove。原来只清 Set/Bk, 不清 All —— All 数组只增不减,
            --   已销毁的 part 永远留在数组里, CullTick 每轮遍历越来越多无效项(泄漏 + 越来越慢)。
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

--============================================================
-- [08] 防踢 / ESP / 自由视角
--============================================================
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
    end
    function SYS.disableAntiAFK()
        if AFKConn then AFKConn:Disconnect() AFKConn=nil end
    end

    local HL,LB,HB={},{},{}   -- HL=人物高亮(Highlight) LB=名字标签 HB=方框(可选)
    -- ★★ 新增: 怪物/NPC 透视池(HN) + 缓存的 NPC 列表(扫描节流用)
    local HN={} SYS._npcList=nil SYS._npcN=0
    -- ★★ 新增: 可交互道具透视池(HP) + 缓存列表
    local HP={} SYS._pickList=nil SYS._pickN=0
    -- ★★ 新增: 门 / 陷阱类透视池(HD) + 缓存列表
    local HD={} SYS._doorList=nil SYS._doorN=0
    -- ★★ 新增: 小游戏区域透视池(HM)
    local HM={} SYS._miniList=nil SYS._miniN=0
    -- ★ v3.9.0 修「玩家名字没有正确透视出来」:
    --   名字标签的 TextLabel 原来写成 BillboardGui 的自定义属性(l.TextLabel=t), 但 BillboardGui
    --   根本没有 TextLabel 这个属性 -> 赋值当场抛错; 而整个 ESPTick 被 P() 包着(见主循环), 错误被静默吞掉
    --   -> 每帧都在这里断掉, 名字标签一个都建不出来(高亮在它前面, 所以现象是"只有高亮没有名字")。
    --   现在把 TextLabel 引用放进侧表 LBL, 不碰 BillboardGui 的属性表。
    local LBL={}
    -- ★ v3.9.0 掉落物透视的高亮池(键=被高亮的实例)
    local HI={}
    -- ★ v3.9.0 手持武器标签池 + 它的 TextLabel 侧表(理由同 LBL: 不能写自定义属性)
    local LW,LWL={},{}
    -- ★ v3.10.3 ESP 隔墙判断缓存(键=目标 Part, 弱表; 独立于战斗的 SHOT_CACHE, 不依赖 CB_Wall 开关)
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
    function SYS.ClearESP()
        for _,h in pairs(HN) do if h then h:Destroy() end end    -- ★ 怪物透视池
        HN={} SYS._npcList=nil
        for _,h in pairs(HP) do if h then h:Destroy() end end    -- ★ 可交互道具池
        HP={} SYS._pickList=nil
        for _,h in pairs(HD) do if h then h:Destroy() end end    -- ★ 门/陷阱池
        HD={} SYS._doorList=nil
        for _,h in pairs(HM) do if h then h:Destroy() end end    -- ★ 小游戏区域池
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
        if not (SYS.T_.ESP or SYS.T_.ESPNameTag or SYS.T_.ESPItem or SYS.T_.ESPWeapon or SYS.T_.ESP_NPC or SYS.T_.ESP_Pick or SYS.T_.ESP_Door or SYS.T_.ESP_Mini) then
            if next(HL) or next(LB) or next(HI) or next(LW) then SYS.ClearESP() end
            return
        end
        -- ★ v68.8 标签挂点兼容: 有些游戏角色没有标准 Head(实测名字标签不显示),
        --   按 Head -> UpperTorso -> Torso -> HumanoidRootPart 逐级回退。
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
                -- ★ v3.9.0: 原来硬要求 HumanoidRootPart -> 没有 HRP 的自定义角色连高亮和名字都拿不到,
                --   下面的 tagPart 回退链(Head->UpperTorso->Torso->HRP)等于永远走不到。
                --   改用 tagPart(c) 判"模型可挂点", 与名字标签的挂点判据保持一致。
                if c and tagPart(c) then
                    local h=c:FindFirstChildOfClass("Humanoid")
                    -- Humanoid 可选(有些游戏用自定义血量系统); 有 Humanoid 且死了才跳过
                    if not h or h.Health>0 then act[p]=c end
                end
            end
        end
        if SYS.T_.ESP then
            -- ★ v71 按用户要求把透视主体改回【人物高亮】(Highlight)。
            --   之前换成方框是因为 Highlight 有实例配额(超了会被引擎静默丢弃, 官方文档);
            --   但实测这游戏里 Highlight 画得出来 —— 战斗页那个"目标高亮"一直可见, 它就是把
            --   Highlight 直接挂在角色模型上。所以现在: 主体=高亮(挂角色, 与已验证做法一致)。
            -- ★ v72: 按用户要求("我要的是人物高亮 不是框")方框已整块删除, 透视只有高亮。
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
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop   -- 穿墙可见
                    h.FillTransparency=0.5
                    h.OutlineTransparency=0
                    h.Parent=c
                    HL[p]=h
                elseif h.Parent~=c then
                    P(function() h.Parent=c end)      -- 角色重生/换模型后重新挂
                end
                local team=false
                -- ★ v3.10.3 队伍判断改用 Attribute 的 @Team(与 isEnemyEx 一致; 这个游戏 Player.Team 是 nil)
                local function ateam(pp)
                    -- ★ v6.2.1(用户反馈"透视没正确区分队友/敌人"): 原来只读【Team 属性】或 Player.Team ——
                    --   而当前游戏(MachineParty)的扫描里这两样都没有(它的数据全是 MP* 那套),
                    --   于是所有人的 team 都是 nil -> 颜色恒定"敌人红" -> 看起来就是"没区分" ✗。
                    --   现在按【信号优先级】多试几种(都是只读, 不猜不写):
                    --     ① Team 属性  ② MPTeam 属性  ③ MPTeamId 属性  ④ Player.Team.Name  ⑤ team 属性
                    for _,k in ipairs({"Team","MPTeam","MPTeamId","team","MPFaction","MPSide"}) do
                        local ok,v=pcall(function() return pp:GetAttribute(k) end)
                        if ok and v~=nil and tostring(v)~="" then return tostring(v) end
                    end
                    local ok2,nm=pcall(function() return pp.Team and pp.Team.Name end)
                    if ok2 and nm and nm~="" then return nm end
                    return nil
                end
                local mt=ateam(LP) local pt=ateam(p)
                team=(mt and pt and mt==pt)
                -- ★ v3.10.3 用户要求: 队友=绿色, 敌人=红色, 颜色要【够醒目】(高饱和)。
                --   颜色本身【不偏移、不淡化】—— 隔墙与否只靠 FillTransparency(填充透明度)区分:
                --   隔墙=填充更透(能看穿墙, 一眼知道"在墙后"), 可见=填充更实。RGB 色值永远不变。
                -- ★★ MachineParty: 这游戏用 `MPGhost` Attribute 表示"被服务器隐身/幽灵态"
                --   (综合扫描实锤: 本机玩家就是 MPGhost=true + MPWalkSpeed=0)。幽灵态用【紫色】单独标出,
                --   一眼分辨"谁现在是隐身的" —— 比全都一个颜色有用得多。
                local ghost=false
                if type(p.GetAttribute)=="function" then
                    P(function() ghost=(p:GetAttribute("MPGhost")==true) end)
                end
                local wall=espWall(tagPart(c) or c.PrimaryPart)
                local fillT=wall and 0.75 or 0.35      -- 隔墙更透 / 可见更实
                h.FillTransparency=fillT
                if ghost then
                    h.FillColor   =Color3.fromRGB(190,60,255)    -- 紫 = 幽灵态(被服务器隐身)
                    h.OutlineColor=Color3.fromRGB(160,40,230)
                else
                    h.FillColor   = team and Color3.fromRGB(0,255,90)  or Color3.fromRGB(255,40,50)
                    h.OutlineColor= team and Color3.fromRGB(0,210,70)  or Color3.fromRGB(255,20,30)
                end
                h.OutlineTransparency=0
            end
            -- ★ v72 按用户要求: 透视只保留【人物高亮】, 方框(BoxHandleAdornment)整块删除。
            if not SYS._ESPLogged then
                SYS._ESPLogged=true
                local _espN=0 for _ in pairs(act) do _espN=_espN+1 end
                print(("[ESP] 人物高亮=Highlight %d 个 · 挂点=角色模型"):format(_espN))
            end
        else
            if next(HL) then for _,h in pairs(HL) do h:Destroy() end HL={} end
            if next(HB) then for _,b in pairs(HB) do b:Destroy() end HB={} end
        end

        -- ★★ 新增: 怪物 / NPC 透视 = 给【不属于任何玩家】但带 Humanoid 的模型挂高亮(橙色, 与玩家区分)。
        --   ① 复用同一套 Highlight + espWall(隔墙更透) + 同样的回收逻辑, 不另造机制。
        --   ② 整棵 Workspace 遍历不便宜 -> 扫描【节流】: 每 10 个 tick 只重扫一次, 其余复用上次结果。
        --   ③ 只影响本客户端(纯视觉), 不碰任何别人。
        if SYS.T_.ESP_NPC then
            SYS._npcN=(SYS._npcN or 0)+1
            -- ★ 性能(用户反馈"加载就卡顿"): 原来每 10 tick 全场景 GetDescendants 一次, 太重。
            --   现在 ① 拉长到每 25 tick; ② 再用 os.clock 兜一道"距上次不足 1s 就不扫"。
            local _now=os.clock()
            if (SYS._npcN%25==1 and (not SYS._npcAt or _now-SYS._npcAt>1)) or not SYS._npcList then
                SYS._npcAt=_now
                local list={}
                P(function()
                    for _,m in ipairs(WS:GetDescendants()) do
                        -- ★ v6.4.0(融合 AH_FakeNPCHighlighter): 原来只认"带 Humanoid"的模型 ->
                        --   而游戏里的【假人/木桩】常常是【没有 Humanoid 的 R6/R15 骨架】(只有 Head+HRP)。
                        --   现在: 带 Humanoid 的算, 或者"有 Head + HumanoidRootPart"的也算 -> 假人也点亮。
                        local isRig=(m:FindFirstChild("Head")~=nil and m:FindFirstChild("HumanoidRootPart")~=nil)
                        if m:IsA("Model") and m~=LP.Character and (m:FindFirstChildOfClass("Humanoid") or isRig) then
                            -- 玩家角色算"玩家透视"那边的, 这里只收 NPC(不属于任何 Player)
                            local isPlayerChar=false
                            if Players.GetPlayerFromCharacter then
                                local ok,pl=pcall(function() return Players:GetPlayerFromCharacter(m) end)
                                isPlayerChar=(ok and pl~=nil)
                            end
                            local h=m:FindFirstChildOfClass("Humanoid")
                            -- 有 Humanoid -> 要求活着; 没 Humanoid 的假人(纯骨架) -> 直接收
                            if not isPlayerChar and ((h and h.Health>0) or (not h and isRig)) then list[#list+1]=m end
                        end
                    end
                end)
                SYS._npcList=list
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
                h.FillTransparency=wall and 0.75 or 0.4
                h.FillColor=Color3.fromRGB(255,150,0)          -- 橙色: 一眼和玩家(绿/红)区分
                h.OutlineColor=Color3.fromRGB(255,110,0)
            end
        else
            if next(HN) then for _,h in pairs(HN) do P(function() h:Destroy() end) end HN={} end
            SYS._npcList=nil
        end

        -- ★★ 新增: 可交互道具透视 = 能"点/按/拿"的东西。★与「掉落物透视」的区别:
        --   掉落物那条是【按名字关键词】猜(drop/item/chest…), 名字对不上就漏;
        --   这条是【按结构判定】—— 只要这个部件/模型带 ClickDetector(点击拾取) 或
        --   ProximityPrompt(按 E) 或本身就是 Tool, 就是"可交互、能拿起来", 不靠名字。
        --   ★ 只影响本客户端(纯视觉); 扫描同样节流(每 10 tick 重扫一次)。
        if SYS.T_.ESP_Pick then
            SYS._pickN=(SYS._pickN or 0)+1
            local _now=os.clock()          -- ★ 同 NPC: 25 tick + 至少间隔 1s
            if (SYS._pickN%25==1 and (not SYS._pickAt or _now-SYS._pickAt>1)) or not SYS._pickList then
                SYS._pickAt=_now
                local list={}
                local camPos=SYS.Cam and SYS.Cam.CFrame and SYS.Cam.CFrame.Position
                -- ★ 上限可配(默认 1200, 原来写死 600 会漏掉"散落在远处"的): C_.PickDist
                local MAXD=tonumber(SYS.C_.PickDist) or 1200
                P(function()
                    for _,o in ipairs(WS:GetDescendants()) do
                        local cn=o.ClassName
                        local ok=false
                        if cn=="Tool" then ok=true
                        elseif cn=="Part" or cn=="MeshPart" or cn=="UnionOperation" or cn=="TrussPart"
                               or cn=="Model" or cn=="Folder" then
                            -- 结构判定: 自己带 ClickDetector / ProximityPrompt
                            local function hasI(x)
                                return x and (x:FindFirstChildOfClass("ClickDetector")~=nil or x:FindFirstChildOfClass("ProximityPrompt")~=nil)
                            end
                            if hasI(o) then ok=true
                            else
                                -- ★ 也看父级(挂在外层模型上) —— 以及【子级】:
                                --   柜子/箱子/门这类常见做法是把 ClickDetector 放进模型里的【某个子部件】,
                                --   只看自己和父级会漏掉它们(用户反馈"地图上的柜子交互不上")。
                                if hasI(o.Parent) then ok=true
                                else
                                    for _,ch in ipairs(o:GetChildren()) do if hasI(ch) then ok=true break end end
                                end
                            end
                        end
                        -- ★ 补: 宝箱 / 箱子 / 收纳柜 这类【名字】关键词兜底 —— 有些箱子根本不用
                        --   ClickDetector/ProximityPrompt(靠 Touched 开), 只靠结构判定会漏。
                        if not ok and type(o.Name)=="string" and o.Name~="" then
                            local nm=o.Name:lower()
                            for _,kw in ipairs({"chest","crate","locker","cabinet","vault","safe","coffer","stash",
                                                "pickup","drop","loot","reward","token","orb","collect","coin","cash","gem",
                                                "mpbuy","limiteddrop","mpstation","mppadhost"}) do
                                if nm:find(kw,1,true) then ok=true break end
                            end
                            if not ok and (o.Name:find("宝箱") or o.Name:find("箱子") or o.Name:find("柜") or o.Name:find("箱")) then ok=true end
                        end
                        if ok and o.Parent and o~=LP.Character then
                            local part=o.PrimaryPart or (cn~="Model" and cn~="Folder" and o) or o:FindFirstChildWhichIsA("BasePart")
                            if part and part.Position then
                                local d=camPos and (part.Position-camPos).Magnitude or 0
                                if not camPos or d<=MAXD then list[#list+1]=part end
                            end
                        end
                    end
                end)
                SYS._pickList=list
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
                h.FillTransparency=wall and 0.7 or 0.35
                h.FillColor=Color3.fromRGB(0,200,255)          -- 青色: 与玩家(绿/红)、怪物(橙)区分
                h.OutlineColor=Color3.fromRGB(0,160,255)
            end
        else
            if next(HP) then for _,h in pairs(HP) do P(function() h:Destroy() end) end HP={} end
            SYS._pickList=nil
        end

        -- ★★ 新增: 门 / 陷阱类透视(黄色)。★先说清楚边界:
        --   ✔ 能判: 名字含 door/gate/trap/hazard/damage/kill/lava/spike/pit/void/saw/blade/crusher/press/
        --           fire/burn/acid/poison/zap/electric, 或中文 门/陷阱/机关/刺/熔岩/伤害/危险;
        --     结构上带 HingeConstraint / Motor6D(会转的那种门)。
        --   ✗ 判不了: **"碰了会不会掉血"客户端看不出来** —— 伤害是服务端结算的, 本地没有可读信号。
        --     所以这条只能"按名字/结构给提示", **会有误报**(名字像陷阱但实际无害)。
        --   想更准: 用「综合扫描」看 Remote 层, 找这游戏真正扣血的信号(那是另一件事)。
        if SYS.T_.ESP_Door then
            SYS._doorN=(SYS._doorN or 0)+1
            local _now=os.clock()
            if (SYS._doorN%25==1 and (not SYS._doorAt or _now-SYS._doorAt>1)) or not SYS._doorList then
                SYS._doorAt=_now
                local list={}
                local CUTOF={}          -- 侧表: 部件 -> 是不是"切割类"(决定颜色)
                local camPos=SYS.Cam and SYS.Cam.CFrame and SYS.Cam.CFrame.Position
                local MAXD=tonumber(SYS.C_.PickDist) or 1200
                local KW={"door","gate","trap","trapdoor","hatch","portal","hazard","damage","damaging","kill","lava",
                          "spike","spikes","pit","void","saw","blade","crusher","crush","piston","hammer","press",
                          "fire","burn","acid","poison","zap","electric","deadly","spider","rig","bumper","chisel","gauntlet","obstacle"}
                P(function()
                    for _,o in ipairs(WS:GetDescendants()) do
                        local cn=o.ClassName
                        local ok=false
                        if cn=="Part" or cn=="MeshPart" or cn=="UnionOperation" or cn=="Model" then
                            -- 结构: 会转的门(铰链/马达关节)
                            if o:FindFirstChildOfClass("HingeConstraint") or o:FindFirstChildOfClass("Motor6D") then ok=true end
                            -- 名字: 门 / 陷阱 / 伤害类 —— ★ 不只看自己, 还看【祖先】(最多 3 层)。
                            --   理由(用户扫描实锤): 这游戏的陷阱区叫 `Chisel Gauntlet` / `MachinePartyCrushHour` 这类
                            --   【外层模型名】, 而真正的尖刺/压板是【里面那些名字很普通的子部件】——
                            --   只比自己的名字会全部漏掉。现在: 祖先命中关键词 => 里面的东西一律算陷阱。
                            if not ok then
                                local anc=o
                                for _=1,4 do
                                    if not anc then break end
                                    local raw=anc.Name
                                    if type(raw)=="string" and raw~="" then
                                        local nm=raw:lower()
                                        for _,kw in ipairs(KW) do if nm:find(kw,1,true) then ok=true break end end
                                        if not ok then
                                            if raw:find("门") or raw:find("陷阱") or raw:find("机关") or raw:find("刺")
                                               or raw:find("熔岩") or raw:find("伤害") or raw:find("危险")
                                               or raw:find("关卡") or raw:find("考验") then ok=true end
                                        end
                                    end
                                    if ok then break end
                                    anc=anc.Parent
                                end
                            end
                        end
                        -- ★ v6.1.4: 顺带区分【切割类】(Chisel Gauntlet 那种凿子/切割台) 与【陷阱/伤害类】,
                        --   用两种颜色标出来: 切割=品红, 陷阱=黄。判据同上一段(自己也看祖先)。
                        local isCut=false
                        if ok then
                            local anc=o
                            for _=1,4 do
                                if not anc then break end
                                local raw=anc.Name
                                if type(raw)=="string" and raw~="" then
                                    local nm=raw:lower()
                                    for _,kw in ipairs({"chisel","gauntlet","cut","slice","sliceable","grind","machin"}) do
                                        if nm:find(kw,1,true) then isCut=true break end
                                    end
                                    if not isCut then
                                        if raw:find("切割") or raw:find("凿") or raw:find("切") then isCut=true end
                                    end
                                end
                                if isCut then break end
                                anc=anc.Parent
                            end
                        end
                        if ok and o.Parent and o~=LP.Character then
                            local part=o.PrimaryPart or (cn~="Model" and o) or o:FindFirstChildWhichIsA("BasePart")
                            if part and part.Position then
                                local d=camPos and (part.Position-camPos).Magnitude or 0
                                if not camPos or d<=MAXD then list[#list+1]=part CUTOF[part]=isCut end
                            end
                        end
                    end
                end)
                SYS._doorList=list
                SYS._doorCut=CUTOF
                if not SYS._doorLogged then
                    SYS._doorLogged=true
                    print(("[ESP] 门/陷阱透视: 找到 %d 个候选(名字/结构命中)。若为 0, 把陷阱门的真名发来我加关键词"):format(#list))
                end
            end
            local dact={}
            for _,p in ipairs(SYS._doorList or {}) do if p and p.Parent then dact[p]=true end end
            for p,h in pairs(HD) do
                if not dact[p] or h.Adornee~=p then P(function() h:Destroy() end) HD[p]=nil end
            end
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
                h.FillTransparency=wall and 0.7 or 0.35
                if (SYS._doorCut or {})[p] then
                    h.FillColor   =Color3.fromRGB(255,70,200)  -- 品红 = 切割类(Chisel Gauntlet 那种)
                    h.OutlineColor=Color3.fromRGB(230,40,180)
                else
                    h.FillColor   =Color3.fromRGB(255,225,0)   -- 黄 = 陷阱/伤害类
                    h.OutlineColor=Color3.fromRGB(255,200,0)
                end
            end
        else
            if next(HD) then for _,h in pairs(HD) do P(function() h:Destroy() end) end HD={} end
            SYS._doorList=nil
        end

        -- ★★ 新增: 小游戏区域透视 —— 把【小游戏里要操作/要躲的那些东西】统一点亮(亮黄绿)。
        --   区域名来自用户扫描: Workspace.duck hunt / Chisel Gauntlet / Lobby / MPPadHost_* +
        --   MachineParty 的小游戏模块名(RightOfWay / Blindout / CrushHour / BumperMadness)。
        --   判据: 自己或【最多 3 层祖先】的名字命中这些区域名 -> 算小游戏里的东西。
        if SYS.T_.ESP_Mini then
            SYS._miniN=(SYS._miniN or 0)+1
            local _now=os.clock()
            if (SYS._miniN%25==1 and (not SYS._miniAt or _now-SYS._miniAt>1)) or not SYS._miniList then
                SYS._miniAt=_now
                local list={}
                local camPos=SYS.Cam and SYS.Cam.CFrame and SYS.Cam.CFrame.Position
                local MAXD=tonumber(SYS.C_.PickDist) or 1200
                local AREA={"duck hunt","duckhunt","chisel","gauntlet","rightofway","blindout","crushhour",
                            "bumpermadness","mppadhost","mpstation","machin"}
                P(function()
                    for _,o in ipairs(WS:GetDescendants()) do
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
                                    if not hit and (raw:find("小游戏") or raw:find("关卡") or raw:find("模式")) then hit=true end
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
                h.FillTransparency=wall and 0.7 or 0.35
                h.FillColor   =Color3.fromRGB(180,255,60)     -- 亮黄绿 = 小游戏区域
                h.OutlineColor=Color3.fromRGB(140,220,30)
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
                    -- ★ v3.9.0 名字高度: 原来写死"挂点上方 3.2 格" —— 但挂点可能回退到躯干/HRP,
                    --   那样字就压在人物身上。现在【自动贴到角色包围盒顶部之上】, 再用 ESPNameH 微调。
                    --   用 GetBoundingBox()(所有部件的外框, 与 PrimaryPart 无关), 比拿 pivot 猜高度可靠。
                    local off=SYS.C_.ESPNameH or 0
                    local okBB,bcf,bsz=pcall(function() local a,b=c:GetBoundingBox() return a,b end)
                    if okBB and bcf and bsz then
                        off=off+(bcf.Position.Y+bsz.Y*0.5-hd.Position.Y)+1.1
                    else
                        off=off+3.2        -- 拿不到包围盒时退回旧行为
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
                        LBL[p]=t                     -- ★ v3.9.0: 侧表记引用, 不再写 l.TextLabel(会抛错)
                        LB[p]=l
                    else
                        l.StudsOffsetWorldSpace=Vector3.new(0,off,0)   -- 每轮刷新(角色变高/挂点变化也跟着走)
                    end
                    -- ★ v66: 名字标签加血量, 血量低变色; v68.8 显示 DisplayName(与游戏内一致)
                    local hh=c:FindFirstChildOfClass("Humanoid")
                    local hp=hh and math.floor(hh.Health+0.5) or 0
                    local mx=hh and math.floor(hh.MaxHealth+0.5) or 0
                    -- ★ v3.9.0: 侧表取引用; 兜底 FindFirstChildOfClass 覆盖"旧版残留的标签"(热重载跨代次)
                    local tl=LBL[p] or (LB[p] and LB[p]:FindFirstChildOfClass("TextLabel"))
                    if tl then
                        -- ★ v6.5.0(融合 NameTagModule/PlayerESP 的信息展示): 名字标签补【距离】——
        --   血量本来就有(hp/mx); 加上"离我多远" -> 判断该不该打/追谁 一眼就有数。
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

        -- ★ v3.9.0 新增「掉落物透视」: 与人物透视同款(Highlight + 穿墙), 换金色以便一眼区分。
        --   为什么不能"看全"别人的东西: Roblox【不会】把别人的背包/物品复制到你客户端 ——
        --   能看到的只有已经复制过来的世界物件。所以这里用两手抓:
        --     ① 名字像掉落物(drop/loot/item/pickup/coin/crate/supply/chest/weapon)
        --     ② 带典型的"可捡/可交互/有标签"子对象(ProximityPrompt / ClickDetector / BillboardGui / Tool)
        --   只扫 Workspace 的直接子节点 + 名字像容器的文件夹里一层 ——
        --   绝不上 GetDescendants(整张地图全量遍历, 这是《帧率优化-排查报告》明确点过的性能雷)。
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
            -- 有"可捡/可交互/带标签"的直接子对象 -> 基本可以断定是掉落物/可拾取物
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
                        -- 只在"名字像容器"的文件夹里下一层(避免把地图各分区全遍历)
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
                    if i%120==0 and (os.clock()-t0)>0.004 then return end   -- 时间预算: 别拖帧
                end
            end
            scanOne(WS)
            -- 过滤: 排除属于任何角色(玩家/自己)的物件 + 超出距离上限的
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
            -- 维护高亮池(与人物透视同款参数)
            for o,h in pairs(HI) do
                if not actI[o] or not o.Parent then P(function() h:Destroy() end) HI[o]=nil end
            end
            for o in pairs(actI) do
                local h=HI[o]
                if not h then
                    h=Instance.new("Highlight")
                    h.Adornee=o
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                    h.FillTransparency=0.5
                    h.OutlineTransparency=0
                    h.FillColor=Color3.fromRGB(255,200,40)
                    h.OutlineColor=Color3.fromRGB(255,150,0)
                    P(function() h.Parent=o end)
                    HI[o]=h
                elseif h.Parent~=o then
                    P(function() h.Parent=o end)
                end
            end
        elseif next(HI) then
            for _,h in pairs(HI) do P(function() h:Destroy() end) end HI={}
        end

        -- ★ v3.10.3 「头顶武器标记」(用户改需求: 原「手持武器透视」改为「检查背包物品栏是否有武器」):
        --   判据 = 背包(Backpack)里有 Tool【或】手上(角色模型下)有 Tool —— 两者任一 = 这个人有武器。
        --   有武器就在【头顶】挂一个醒目标记(武器名), 没武器不留标签。
        --   ⚠ 别人的背包默认不复制到客户端(Roblox 引擎行为), 但【Backpack 容器 + 手上 Tool】通常可见;
        --     若 Backpack 读不到(部分游戏), 则退化为只看手上 Tool。
        if SYS.T_.ESPWeapon then
            for p,c in pairs(act) do
                local wpn=nil
                -- ① 手上(角色模型下的 Tool): 一定读得到
                local ok1,ks=pcall(function() return c:GetChildren() end)
                if ok1 and type(ks)=="table" then
                    for i=1,#ks do
                        if ks[i].ClassName=="Tool" and ks[i].Name~="" then wpn=ks[i].Name break end
                    end
                end
                -- ② 背包里的 Tool(没装备但带着): Backpack 是 Player 标准属性
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
                            -- 头顶标记: 挂在角色顶部(与名字标签同向, 略低一点避免重叠)
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
    -- ★ v3.9.0 鼠标状态恢复的【唯一实现】: 菜单关闭 / 关自由视角 / 卸载 三处共用。
    --   优先级(从"最接近用户本来状态"往下):
    --     ① 打开菜单前的状态(菜单是最外层覆盖)
    --     ② 进自由视角前的状态
    --     ③ 脚本加载时的状态(只在①②都没记录过时兜底)
    --   旧实现三处各写各的、都用③兜底 -> 关掉自由视角/关掉菜单/卸载之后鼠标被恢复成
    --   脚本加载时的值(常常是 Default+显示指针), 于是游戏里"鼠标不正常"(指针冒出来 / 转不动)。
    function SYS.RestoreMouse()
        -- ★ v3.9.x 重构(用户反馈"开自由视角后关闭, 鼠标仍隐形+固定, 开菜单正常关菜单又固定"):
        --   根因: 旧实现的优先级链 MenuPrev -> FCPrev -> Orig.MouseBehav, 其中任何一档都可能存着
        --   LockCenter(FPS 游戏加载/自由视角残留), 导致关闭 UI 后鼠标被锁在屏幕中心+隐藏。
        --   用户期望很明确: 关掉菜单/自由视角后, 鼠标【可见 + 可移动】。所以这里直接定死:
        --   关闭一切 UI = Default(自由移动) + 显示图标。不再追"打开前那一刻"的旧值(那经常是 LockCenter)。
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
        -- ★ v3.9.0 修「关掉自由视角后鼠标不正常」: 记下【进入自由视角之前】真正的鼠标状态。
        --   菜单开着时 UIS 上的当前值已被菜单强制成 Default+显示图标, 那份不是"真值";
        --   真值在 SYS.MenuPrevMouseBehav/Icon(菜单打开那一刻记的)里。
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
            -- ★ v101 菜单打开时【不抢鼠标】: 原来自由视角每帧 LockCenter+隐藏图标, 和菜单的
            --   "显示鼠标(Default)"每帧打架 -> 自由视角下打开菜单鼠标不出现/闪烁(用户报的 bug)。
            if not SYS.MenuOpen then
                P(function()
                    if UIS.MouseBehavior~=Enum.MouseBehavior.LockCenter then UIS.MouseBehavior=Enum.MouseBehavior.LockCenter end
                    if UIS.MouseIconEnabled then UIS.MouseIconEnabled=false end
                end)
            end
            -- ★ v52(F37): 删掉"GetMouseLocation 差值"这第二套鼠标处理。
            --   原来鼠标移动同时被两处累加: InputChanged 的 MouseMovement.Delta(相对量, 不受屏幕边界限制)
            --   和这里的 GetMouseLocation 差值(绝对屏幕坐标, 鼠标贴边就饱和)。
            --   两套并存 => 灵敏度翻倍 + 边界不一致。统一只用 InputChanged 的 Delta(见上方 FMC)。
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
        -- ★ v3.9.0 修「关掉自由视角后鼠标不正常」:
        --   旧实现只在"菜单没开"时恢复, 而且恢复的是【脚本加载时】抓的 SYS.Orig(常常是 Default+显示图标)
        --   —— 游戏里真值通常是 LockCenter+隐藏图标 -> 关掉自由视角后鼠标就可见/转不动了。
        --   现在一律照"进自由视角之前"的那份(SYS.FCPrev*)恢复。
        if not SYS.MenuOpen then
            SYS.RestoreMouse()
        else
            -- 菜单开着: 鼠标暂时归菜单管(它每帧抢 Default+显示指针)。
            --   但菜单记的"打开前状态"此刻是【自由视角已生效】的 LockCenter+隐藏 ->
            --   必须改写成"进自由视角之前"的那份, 否则关菜单时会把鼠标恢复成已失效的 FreeCam 状态。
            if SYS.FCPrevBehav~=nil then SYS.MenuPrevMouseBehav=SYS.FCPrevBehav end
            if SYS.FCPrevIcon~=nil then SYS.MenuPrevMouseIcon=SYS.FCPrevIcon end
        end
        -- ★ v3.9.0 修「关 UI 后鼠标被锁死」: 自由视角这份"进之前"的记录是一次性的,
        --   用完必须清空 —— 否则下一轮"开菜单→关菜单"时 RestoreMouse 会捡到这个陈旧的
        --   LockCenter 值, 把鼠标永远锁在屏幕中心动不了。
        SYS.FCPrevBehav=nil SYS.FCPrevIcon=nil
    end
end

--============================================================
-- [08.4] 物品栏来源诊断(只读) —— 已按用户要求删除(2026-09-17)
--============================================================

--============================================================
-- [08.5] 子弹射线(纯本地可视化)
--============================================================
-- ★ v3.9.0 新增「子弹射线」: 在本地画一条线, 表示"这一枪会从哪打到哪"。
--   ⚠ 它【只画线】, 不改变任何弹道/命中判定/伤害(边界要求: 不做任何服务端对抗)。
--   ⚠ 关键: 这条线必须 CanQuery=false / CanTouch=false / CanCollide=false ——
--     否则 clearShot 的射线会先打到这条线, 直接把索敌判成"隔墙", 等于自己把自己锁死。
do
    local line=nil
    -- ★ v3.10.0 修「子弹射线方向错了」: 旧实现起点优先枪口/工具 Handle、没有就用相机位置,
    --   方向用相机 LookVector —— 但第三人称下相机在角色身后, 相机朝向 ≠ 枪口/角色朝向,
    --   导致画出来的线是"相机→准星"那条, 不是枪打出去的那条。
    --   改成: 起点=角色【眼睛/头部】(第一人称视角), 方向=角色【朝向】(root.LookVector)。
    --   这样画的就是"人物正面打出去"的弹道线, 和枪口一致。
    local function tracerOrigin()
        -- ★ v6.1.0(用户要求): 用【人物视角】划线 —— 从【相机】出发, 沿【屏幕正前方(准星指向)】。
        --   第三人称下这才是"你实际在看/在瞄"的方向; 老逻辑(角色正面朝向)作为没有相机时的兜底。
        local cam=WS.CurrentCamera
        if cam and cam.CFrame then
            return cam.CFrame.Position, cam.CFrame.LookVector
        end
        local ch=SYS.LP and SYS.LP.Character
        if not ch then return nil,nil end
        local root=ch:FindFirstChild("HumanoidRootPart")
        local hd=ch:FindFirstChild("Head")
        local eye
        if hd then eye=hd.Position
        elseif root then eye=root.Position+Vector3.new(0,1.5,0)
        end
        local dir=root and root.CFrame.LookVector or nil
        return eye,dir
    end
    function SYS.TracerHide()
        if line then P(function() line:Destroy() end) line=nil end
    end
    function SYS.TracerTick()
        if not SYS.T_.Tracer then
            if line then SYS.TracerHide() end
            return
        end
        local o,dir=tracerOrigin()
        if not o or not dir then return end
        -- 终点: 有锁定目标就画到目标身上; 没有就沿角色朝向画一条固定长度的射线
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
                q.CanQuery=false q.CanTouch=false        -- ★ 必须: 别让射线/触碰打到自己这条线上
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
    -- 常驻一条 RenderStepped(关着的时候只做一次 if, 几乎零开销); 注册进 SYS.Conns 以便卸载时断开
    T(RS.RenderStepped:Connect(function() P(SYS.TracerTick) end))
end

--============================================================
-- [09] 基地操作（收脑红 / 收金币 / 低 CPS 售卖）
--============================================================
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

    -- ★ 独家物品保护检测
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
                    if not isExclusiveTool(t) then -- ★ 跳过独家物品
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
                    for _,f in ipairs(SYS.BtnRefs) do P(f) end -- ★ v49.3 自动关闭后刷新UI开关状态(界面同步)
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
                    if not isExclusiveTool(t) then -- ★ 跳过独家物品
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
--============================================================
-- [10] HUD / 训练 / 重生 / 健身房 / 自动奖励
--============================================================
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
    local lastRebFire=0 -- ★ v49.7 重生触发冷却(防服务器未更新时重复Fire)
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
                    lastRebFire=now -- ★ v49.7 5s冷却内不重复触发
                    Fire("RebirthRequest") task.wait(2)
                end
            end
        end))
    end

    -- ========== 健身房部分（全新） ==========
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

    -- ========== 训练加成部分（全新） ==========
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
                local itv=os.clock()<AFK.BonusWin and 0.05 or 1.0 -- ★ v49.7 非活动期1s一查(原0.2s全扫3个GUI树, CPU大户; 加成出现时事件驱动0.05s)
                task.wait(itv)
                if not SYS.Unloaded and SYS.T_.AutoBonus then P(ScanBonus) end
            else
                task.wait(0.5)
            end
        end
    end))
end
--============================================================
-- [11] 传送
--============================================================
do
    local Spawn=Vector3.new(0,10,0)
    local Rec=false
    local autoIn={} local autoCool={}
    -- ★ v116: 远距离传送改【分步插值】。一次性写 CFrame = "单帧不可能位移", 服务端位置校验会把你拉回
    --   (和 CFrame 飞行模式被拉回是同一个根因)。这里按每步最多 TPMaxStep 格分帧走, 最后一步精确落点;
    --   近距离(<= 一步)仍然是瞬间到, 不影响手感。用 task.delay 串联而非 task.wait, 避免在非协程环境里报错。
    -- ★ v3.9.x(用户反馈"鼠标传送只能传一点点"): 旧版 STEP=60 太小 —— 稍远一点就切成分步插值,
    --   而分步插值的每一帧中间位置都会被服务端 ServerReplicateCFrame 校验拉回, 最终停在半路。
    --   改成: 步数固定最多 4 步(每步大步跳), 且每步落地后 0.05s 补一刀 —— 大步跳比细碎小步更容易
    --   被服务端当作"合法终点"接受。绝大多数距离(<=STEP)仍是单帧瞬移+补刀。
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
            -- 远距离: 大步分帧(最多 4 步), 每步落地后补刀防拉回
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
            -- ★ v86: 只有【俯视】(d.Y<0)时射线才会交到"脚所在水平面"—— 几何上就是准星指的地面。
            --   平瞄/抬头旧写法算出负 t -> clamp -2000 会把自己传到身后/近距离。
            --   这类视线交不到脚平面 -> 沿准心的水平分量直投 500 studs(抬头指楼顶就往楼顶方向去)。
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
            -- ★ v69: Enum.RaycastFilterType.Blacklist 已被 Roblox 标记 deprecated(新名字 Exclude)。
            --   老客户端没有 Exclude、新客户端用旧名会告警 —— 两个都试, 取存在的那个, 都不会报错。
            local okFT,ft=pcall(function()
                return Enum.RaycastFilterType.Exclude or Enum.RaycastFilterType.Blacklist
            end)
            pa.FilterType=(okFT and ft) or Enum.RaycastFilterType.Blacklist
            pa.FilterDescendantsInstances={LP.Character}
            -- ★ v86: 第三视角下相机与角色之间有墙/护栏/树叶时, 旧写法命中近处 -> 传到近距离。
            --   判据: 命中点在角色【身后】(相对瞄准方向) -> 换成从角色头部沿准心方向平行重投。
            --   头部投射不受相机与角色之间任何障碍物影响; 距离 10000 覆盖整张地图。
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
        -- ★ v3.9.x(用户反馈"自动循环TP与自动回点不同步/检测太长"): 去掉 acc<3 节流(原来是 3×0.15s≈0.45s
        --   才检测一次), 并把传送冷却从 2s 降到 0.5s —— 离开保存点后能更快被拉回, 不会"走了好远才想起来拉"。
        local _,_,root=GC() if not root then return end
        local now=tick()
        for i,s in ipairs(SYS.SavedPos) do
            if s.autoTP then
                local dist=(root.Position-s.position).Magnitude
                if dist>SYS.C_.AutoTPDist then
                    local was=autoIn[i] local cool=autoCool[i] or 0
                    if was~=false or now-cool>0.5 then
                        -- ★ v69 走和"点击传送"同一条路径: 旧版只写一次 CFrame, 会被服务器位置
                        --   校验/网络所有权拉回去 -> 用户看到"自动循环传送没效果"。TPTo 会补第二刀,
                        --   并且尊重「传送方式」设置。
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
--============================================================
-- [11.5] 战斗模块  (自动瞄准 / 静默瞄准 / 自动开火 / 目标提示)
--
--  设计要点:
--    · 所有开关走 SYS.T_、所有参数走 SYS.C_ —— 直接享受现有配置持久化
--    · 瞄准写在 BindToRenderStep(Camera 优先级 +1), 保证不被相机脚本覆盖
--    · hookfunction 不可逆 -> 卸载靠"关开关 + 清目标"让 hook 空转回原逻辑
--    · 无执行器 hook 能力时自动降级为"仅自动瞄准", 不报错
--============================================================
SYS.Combat={}
local CB=SYS.Combat

CB.Target=nil           -- 当前目标玩家
CB.TargetPart=nil       -- 当前瞄准的部位
CB.HookOK=false         -- 静默 hook 是否可用
CB.HookStat={cam=0,mouse=0,ray=0}  -- v61/v63: 各 hook 被【游戏】调用的次数(判断游戏用哪个 API 判定命中)
CB.RenderBound=false
CB.Moving=false         -- 是否正按着 WASD(v53: 移动时暂停转相机)
CB.FallbackConn=nil     -- v54: RenderStepped 回退连接(必须单独存, Stop 才能断掉)
CB.UsingFallback=false
CB.LastFire=0
CB.RenderName="CheatMenuCombat"

--======================== 工具 ========================
-- ★ v54 兼容性重写(解释"索敌完全不生效"):
--   原来这几个函数都硬依赖"Humanoid 是角色的直接子级 + 有标准 Head/HumanoidRootPart"。
--   但大量游戏做不到 —— R15 自定义骨架、角色外面又包了一层 Model、甚至干脆没有 Humanoid。
--   结果就是: 敌人明明站在眼前, 脚本判定"一个可选目标都没有" -> 瞄准和开火全部不动。
--   现在统一改成"标准结构优先, 找不到就逐层兜底"。

-- ⚠ 性能(v56 重写): 下面这几个函数每 50ms 就要对【每个玩家】跑一遍, 是整条链路最热的地方。
--   上一版为了"安全"给每次调用都套了 pcall, 并且兜底时把角色的子对象**全部**遍历一遍 ——
--   但游戏里的角色常常塞着上百个附件/衣服, 于是变成
--   "20Hz × 玩家数 × 几百次 pcall", 帧时间直接被吃光(用户反馈"战斗一开就巨卡")。
--   现在的做法:
--     · 快速路径直接调用, 不套 pcall(实例方法在对象有效时不会抛错, pcall 是纯浪费)
--     · 兜底遍历最多看 40 个子对象
--     · 兜底结果按角色缓存(弱键), 角色销毁后自动回收, 绝不每次重扫
local HUMC=setmetatable({},{__mode="k"})    -- ch -> Humanoid | false(已确认没有)
local BODYC=setmetatable({},{__mode="k"})   -- ch -> BasePart | false

-- Humanoid: 直接子级 -> 往下一层找(最多 40 个) -> nil
-- ★ v76 用上用户抓到的 Remote 清单 —— 只做【只读监听】, 一个 Remote 都不 hook。
--   为什么只挑这两个方向: 清单里 460 多个 Remote, 对"索敌/瞄准/透视"真正有用的只有
--   ①死亡/复活信号 ②游戏自己的敌人高亮容器; 其余(UpdateData/Query/Purchase/Trade/Market/
--   Gacha/Postie/ByteNet/__DEBUG/Cmdr...)接了没有任何收益, 只会增加被反作弊盯上和改坏游戏的风险。
--
--   ① 死亡/复活 -> 权威死亡表。用户报的"锁死人 / 打不死"从此不再只靠 Health 猜:
--      游戏自己报"他死了"就立刻松开锁定并从候选里排除, 报"复活/重生"就放回来。
--      带 TTL 自愈: 万一某个游戏的复活事件名字不同, 也不会把这个人永久判死。
CB.DeadAt={}          -- [玩家名] = 收到死亡信号的时刻
CB.DeadCh={}          -- ★ v3.9.0: [玩家名] = 收到死亡信号时【他当时的角色实例】(实例换了才叫复活)
CB.DeadTTL=8          -- 秒(仅在没有绑到角色实例时兜底, 见 alive)
CB.DeathHooked={}     -- 订阅成功的事件名(诊断用)
CB.EnemyHolder=nil    -- 游戏自己的敌人高亮容器(只读)

local function hookDeathEvents(attempt)
    attempt=attempt or 0
    local _,rp=P(function() return game:GetService("ReplicatedStorage") end)
    if not rp then return end
    -- ★ v103 修「人死了倒地还在锁尸体」的真正根因:
    --   脚本加载常常【早于】游戏把这套 Remote 结构建出来(这游戏是 ReplicatedStorage.Remote.*,
    --   运行时才挂), 而旧代码只 FindFirstChild 一次 -> 7 个 sub() 全拿不到实例直接返回 ->
    --   CB.DeathHooked 是空的 -> DeadAt 永远为空 -> 只剩 Humanoid 猜, 于是锁死人。
    --   现在: 找不到就每 2 秒重试(最多 40 次 = 80 秒窗口), 订上了才停。
    local R=rp:FindFirstChild("Remote")
    if not R then
        if attempt<40 then
            SYS.TT(task.delay(2,function() P(hookDeathEvents,attempt+1) end))
        else
            warn("[CheatMenu] 80 秒内没等到 ReplicatedStorage.Remote -> 死亡事件没订上(会退化回 Humanoid 判断)")
        end
        return
    end
    CB.DeathHookedSet=CB.DeathHookedSet or {}
    local function sub(inst,label,mode)
        if not inst then return end
        if CB.DeathHookedSet[label] then return end      -- ★ v103 重试时别重复订阅
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
                -- ★ v3.9.x 修「活人被误判成已死亡, 导致索敌全空(诊断: 角色=true Humanoid=true Health=100 被挡)」:
                --   根因: 上面 take() 会把事件参数里的【任意字符串】都当玩家名 —— 但游戏死亡事件的参数
                --   常常是 (击杀者, 受害者, 武器名, 伤害) 这种多字段, 或第一个参数根本不是受害者。
                --   于是把满血活人(甚至击杀者自己)的名字写进 DeadAt -> alive() 把他判死 -> 没人可打。
                --   修: 只认【当前 Players 里真实存在的玩家名】, 其余字符串(武器名/物品名/击杀者昵称等)一律丢弃。
                --   这是白名单式过滤 —— 宁可不收"疑似名字", 也不误杀活人。
                local valid={}
                for i=1,#names do
                    local nm=names[i]
                    if Players and Players:FindFirstChild(nm) then valid[#valid+1]=nm end
                end
                -- ★ v3.9.x 再加一道防误标: 一次事件若带了【多个】在玩家列表里的名字, 多半是
                --   广播型事件(回合结算/全队状态), 参数语义不明 —— 分不清谁是受害者, 宁可全部忽略
                --   (死亡判定还有 Humanoid 兜底, 不会真的漏掉死人)。
                if #valid>1 then valid={} end
                for i=1,#valid do
                    local nm=valid[i]
                    if mode=="die" then
                        CB.DeadAt[nm]=os.clock()
                        -- ★ v3.9.0: 把死亡信号绑到他【当时】那个角色实例 —— 之后只要角色实例没换, 他就还是那具尸体
                        --   (旧实现只记时间 + 8 秒 TTL, TTL 一过就把死亡证据丢掉 -> 尸体被重新判活).
                        local _dp=Players and Players:FindFirstChild(nm)
                        CB.DeadCh[nm]=_dp and _dp.Character or nil
                        -- 立刻松开死人的锁定, 不等下一轮扫描
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
    -- ★ v3.9.0 补订(用户给的 Remote 清单里明确存在、上一版漏掉的战斗信号):
    --   · GameService.GameClient.Killed —— 客户端专属击杀信号(比 GameService.Killed 更精准,
    --     是"你击杀/他击杀"这一层的权威; 有些游戏只有这条、没有外层 Killed)。
    --   ★ 注意: 只补这条【击杀】信号。EntityService.BeDamaged/Heal 是"受击/回血", 不等于死亡,
    --     若硬塞进 die/alive 二元判定会把"刚被打但没死的人"误排出去 -> 故意不接。
    local GC_=GS and GS:FindFirstChild("GameClient") or nil
    sub(GC_ and GC_:FindFirstChild("Killed"), "GameService.GameClient.Killed", "die")
    -- ★ v103: 一个都没订上(结构还没建全) -> 继续重试
    if #CB.DeathHooked==0 and attempt<40 then
        SYS.TT(task.delay(2,function() P(hookDeathEvents,attempt+1) end))
    end
end

-- 游戏自己的敌人高亮容器(清单 [8][9][10] 都指向它)。
-- 返回 true = 容器在且里面有他; false = 容器在但没他; nil = 这局没有这个容器(不做判断)
function CB.GameSaysEnemy(pl)
    local hh=CB.EnemyHolder
    if not (hh and hh.Parent) then
        -- ★ 注意: P() 包了 pcall 会【返回多值】(ok, 结果) -> 必须写 local _,x=P(...) 才拿到结果,
        --   写 local x=P(...) 得到的是布尔 ok —— 这里踩过一次(运行时 attempt to index a boolean)
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
    -- ★ v72 修「还在锁死人」的真根因: 缓存里的 Humanoid 可能【已经被销毁】——
    --   已销毁实例读 .Health 仍返回最后一次的值(通常满血), 于是死人被当成活人。
    --   必须校验它还在场景里: Parent==nil 就是没了(缓存也要一并清掉)。
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

-- 躯干: 标准部位优先, 其次 PrimaryPart, 再其次任意一个 BasePart(最多 40 个)
local function bodyOf(ch)
    if not ch or ch.Parent==nil then return nil end
    local b=ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso")
        or ch:FindFirstChild("Torso") or ch:FindFirstChild("Head")
    if b then return b end
    -- ★ v72 同上: PrimaryPart / 缓存也可能是【已销毁】的旧部件 —— 读 .Position 返回旧坐标,
    --   脚本就会照着尸体当时的位置瞄和开火(表现: 锁死人 / 打不死)。
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
    -- ★ v3.10.1 重写(用户贴的「物品栏来源诊断」实锤): 这个游戏的【权威血量/状态不在 Humanoid 里,
    --   在 Player 的 Attribute 里】。诊断抓到的字段:
    --     @Health / @MaxHealth   真实血量(非zaza1462 的 @Health=0 @State=Dead, 但 Humanoid 还在)
    --     @State                 Sprint / Slide / Stand / Dead(权威状态, 比 Humanoid.GetState 准)
    --     @Shield / @TempShield  护盾值(0=无盾)
    --     @combatPaused          战斗暂停(换弹/受控/无法攻击)
    --   之前用 Humanoid.Health/GetState 判定 -> 满血活人被误判成已死亡(索敌全空), 就是这个根因。
    local function attr(k)
        local ok,v=pcall(function() return pl:GetAttribute(k) end)
        return ok and v or nil
    end
    local st=attr("State")
    if type(st)=="string" and st=="Dead" then return false end
    local hp=attr("Health")
    if type(hp)=="number" and hp<=0 then return false end
    -- ★ v3.10.2 修「活人被误判死亡」第二处根因(2.txt 诊断实锤: wswyx12345 角色=true Humanoid=true Health=100
    --   却被判死): Attribute 明明说他活着(@State=Stand @Health=100), 但 CB.DeadAt 里还有他的旧记录
    --   (死亡事件在交易大厅/回合切换时误发, 或参数解析误标), 且角色实例没换(dc==ch) -> 8 秒 TTL 内
    --   被无条件 return false。修: Attribute 给出【明确的活着证据】(活跃状态 + 血量>0) 时, 直接清掉
    --   DeadAt 误标并放行 —— Attribute 是实时权威, 高于历史死亡信号。
    if type(st)=="string" and st~="Dead" and st~="" and type(hp)=="number" and hp>0 then
        if CB.DeadAt[pl.Name] then CB.DeadAt[pl.Name]=nil CB.DeadCh[pl.Name]=nil end
        -- 直接进入下面的 Humanoid 回退校验(Attribute 已证明活着, 不该被 DeadAt 拦下)
    end
    -- 死亡信号(游戏 Remote 报的)仍然保留, 只当 Attribute 没给出明确结论时才用(Attribute 是实时权威)
    local dt=CB.DeadAt[pl.Name]
    if dt then
        local dc=CB.DeadCh[pl.Name]
        if dc==ch then
            local h0=humOf(pl)
            local st0
            if h0 then local ok0,s0=pcall(function() return h0:GetState() end) if ok0 then st0=s0 end end
            if (os.clock()-dt)>=(CB.DeadTTL or 8) and h0 and h0.Health>0
               and st0~=Enum.HumanoidStateType.Dead and st0~=Enum.HumanoidStateType.Physics then
                CB.DeadAt[pl.Name]=nil CB.DeadCh[pl.Name]=nil     -- 复用实例复活 -> 放行
            else
                return false
            end
        elseif dc~=nil then
            CB.DeadAt[pl.Name]=nil CB.DeadCh[pl.Name]=nil         -- 换了角色实例 = 复活/重生
        elseif (os.clock()-dt)>=(CB.DeadTTL or 8) then
            CB.DeadAt[pl.Name]=nil                                -- 没绑到实例: TTL 过期 -> 靠 Attribute 自愈
        else
            return false
        end
    end
    -- 回退: 没有 Attribute 信息时才用 Humanoid 猜(兼容别的游戏)
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
-- ★ v3.9.0 修「带盾的(刚复活的无敌盾)还在被打 / 游戏提示"免疫力"」:
--   原来「跳过无敌盾(CB_SkipFF)」只在【候选池】里生效(见 pickTarget), 而【指定目标】(specResolve)
--   与【准星指向】两条路径都绕过候选池 -> 带盾的人照样被锁定/开火。UI 的说明写的是"带无敌盾的人
--   【完全不打】", 指定目标却照打 = 文案与行为不符。
--   现在收敛成唯一判据 hasShield(), 三条路径共用(候选池 / 指定目标 / 准星指向)。
--   只用直接子节点查找: ForceField 由引擎挂在角色模型下(现网唯一形态), 且这是 30Hz 热路径
--   ——《帧率优化-排查报告-v3.7.0》明确点过"每帧 GetDescendants"是性能问题, 这里不能上递归扫描。
local function hasShield(pl)
    local ch=pl and pl.Character
    -- ★ v3.10.1: 优先读 Attribute 的 @Shield / @TempShield(诊断实锤: 护盾值在 Attribute 里, 0=无盾)。
    local function attr(k)
        local ok,v=pcall(function() return pl:GetAttribute(k) end)
        return ok and v or nil
    end
    local sh=attr("Shield")
    if type(sh)=="number" and sh>0 then return true end
    local tsh=attr("TempShield")
    if type(tsh)=="number" and tsh>0 then return true end
    -- 回退: 标准 ForceField(别的游戏用)
    return (ch and ch:FindFirstChildOfClass("ForceField"))~=nil
end

-- mode: 1=Head  2=Body  3=Head/Body 中离准星最近的
local function partOf(pl,mode)
    local ch=pl and pl.Character
    if not ch then return nil end
    local body=bodyOf(ch)
    local hd=ch:FindFirstChild("Head")
    if mode==1 then return hd or body end        -- 没有"头"就用躯干, 不要整个目标丢掉
    if mode==3 then
        local cam=SYS.Cam
        -- ★ v67: 相机销毁瞬间 cam.CFrame / cam.ViewportSize 可能为 nil, 判空后再取
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

-- 从命中的 Part 往上找"到底是哪个玩家"。
-- ★ v54: 原来只取 FindFirstAncestorOfClass("Model") —— 很多角色里还嵌着别的 Model
--   (配件 / 包裹层), 拿到的是内层 Model, GetPlayerFromCharacter 返回 nil -> 永远不开火。
local function playerFromPart(part)
    if not part or part.Parent==nil then return nil end
    local node=part
    for _=1,12 do                          -- 最多往上 12 层, 防止异常结构下死循环
        -- v56: 去掉 pcall(这里每次自动开火检测都要走, pcall 是白给的开销)
        local pl=Players:GetPlayerFromCharacter(node)
        if pl then return pl end
        node=node.Parent
        if not node then break end
    end
    return nil
end
-- ★ v69 索敌自愈 + 原因可查(用户反馈"没有成功索敌"):
--   v65 加了两条"过滤"—— 跳过带 ForceField(出生无敌盾)的目标、跳过同队目标。
--   但很多游戏里这两条【对所有玩家都成立】(全员常驻无敌盾 / 全服同一个 Team),
--   于是一个敌人都选不出来, 而且界面上没有任何提示 —— 表现就是"敌人就在眼前却索不敌"。
--   现在: ① 把过滤拆成可带"忽略标记"的形式; ② 一旦发现"活着的其他人存在, 但全被这两条挡掉",
--   就自动判定"该条件在本局没有区分意义"并忽略它(只提示一次) + 诊断里逐条列出被谁挡住。
CB.NoTeamFilter=false   -- 本局「不打队友」被自动忽略(全服同队)
CB.NoFFFilter=false     -- 本局「跳过无敌盾」被自动忽略(全员常驻 ForceField)
CB.SelfHealAt=0

-- ★ v4.1.0 统一队伍判据: @Team Attribute 优先(本游戏队伍在这), Player.Team 回退。
function CB.TeamKey(p)
    if not p then return nil end
    local ok,v=pcall(function() return p:GetAttribute("Team") end)
    if ok and type(v)=="string" and v~="" then return v end
    return p.Team and p.Team.Name or nil
end
-- ★ v4.1.0 判据能否区分敌我(1 秒最多算一次): 全服(含自己)的 teamKey 里
--   出现【两个不同值】才算"这游戏真的用队伍分队"; 全同/全 nil => 没区分力 => 「不打队友」不该生效。
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
    -- ★ 修: P() 返回的是 (成功与否, 结果)。原来写成 `local _,pok=P(...)`, 于是 pok 拿到的是
    --   【结果】(这里闭包没 return, 结果=nil) -> (pok and second) 永远 false ->
    --   团队战里"判据永远无效" -> 从不排除队友(队伍过滤形同虚设)。现在只取第一个值。
    local pok=P(function()
        for _,pl in ipairs(Players:GetPlayers()) do feed(CB.TeamKey(pl)) end
    end)
    CB._tkVal=(pok and second)==true
    return CB._tkVal
end

local function isEnemyEx(pl,ignoreTeam,ignoreFF)
    if not pl or pl==SYS.LP then return false end
    -- ★ v6.7.0 白名单/黑名单(融合自 ChronixHub 瞄准设置): 黑名单直接否; 白名单非空时只放行白名单
    if SYS.WL and not SYS.WL.Allow(pl.Name) then return false end
    if not alive(pl) then return false end
    -- ★ v72 改法: 无敌盾不再"直接排除", 改成在 pickTarget 里【降权】(有盾 = 最后才考虑)。
    --   硬排除 + 自愈那套的体感是"时好时坏"(全服都有盾时要么索不到、要么自动放开);
    --   降权的行为永远确定: 有别人可打就不打有盾的, 全服都有盾时仍然选得到人。
    --   (ignoreFF 参数保留, 供诊断/兼容调用)
    -- ★ v3.10.1 队伍判断改用 Attribute 的 @Team(诊断实锤: 这个游戏队伍在 Attribute 里,
    --   标准 Player.Team 是 nil —— 之前"队伍=nil"就是它)。@Team 是 Team1/Team3 这种字符串。
    if not ignoreTeam and SYS.T_.CB_Team then
        local mt=CB.TeamKey(SYS.LP) local pt=CB.TeamKey(pl)
        -- ★ v4.1.0 修「不打队友把敌人也当队友, 结果谁都锁不上」:
        --   本游戏 Player.Team 恒为 nil, 队伍在 @Team Attribute 里; 而 @Team 在【所有人】身上取值相同
        --   (自建房/混战类游戏本来就没有队友) -> 旧逻辑"mt==pt 就排除"会把全服都排除掉,
        --   而自愈又因为看的是 Player.Team(恒 nil) 永不触发 -> 候选池全空, 一个都锁不上。
        --   现在: 只有"判据确实能区分出至少两支队伍"时才排除。
        if mt and pt and mt==pt and CB.TeamKeyUseful() then return false end
    end
    return true
end
local function isEnemy(pl) return isEnemyEx(pl,CB.NoTeamFilter,CB.NoFFFilter) end

-- 单个玩家被挡住的【原因】(诊断用; 不参与热路径)
function CB.RejectReason(pl)
    if not pl then return "nil" end
    if pl==SYS.LP then return "是自己" end
    if not alive(pl) then
        -- ★ v72: 把判死依据也打出来 —— 用户报"锁死人"时, 这一行能直接定性是"真死了"还是判据不对
        -- ★ v3.10.2: 精确到判据 —— 到底是被 @State=Dead / @Health<=0 / 死亡事件 DeadAt / Humanoid 哪条判死的,
        --   否则"活人被误判死亡"没法定位(之前只打 Humanoid.Health, 但 Humanoid.Health=100 也可能被判死)。
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
    return nil   -- 没被"身份过滤"挡
end

-- ★ v69 自愈: 一个都选不到, 但确实有活着的其他人 -> 说明过滤条件把候选全挡了。
--   只放宽【确实挡掉了全部候选】的那一条, 并且只提示一次(1 秒冷却, 不刷屏)。
function CB.SelfHealFilters()
    local now=os.clock()
    if now-CB.SelfHealAt<1 then return end
    CB.SelfHealAt=now
    local others,ffc,teamc=0,0,0
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl~=SYS.LP and alive(pl) then
            others=others+1
            if hasShield(pl) then ffc=ffc+1 end
            -- ★ v4.1.0: 原来这里看 Player.Team(本游戏恒 nil) -> teamc 永远 0 -> 自愈永不触发。
            do
                local a=CB.TeamKey(SYS.LP) local b=CB.TeamKey(pl)
                if a and b and a==b then teamc=teamc+1 end
            end
        end
    end
    if others==0 then return end
    -- ★ v72: 无敌盾已改成"降权", 不再需要自愈放开。ffc 仍计数, 供诊断显示"本局有几个带盾的"。
    if (not CB.NoTeamFilter) and SYS.T_.CB_Team and teamc>=others then
        CB.NoTeamFilter=true
        CB.Say(("⚠ 全服 %d 个目标都与我同队 -> 该游戏不用队伍区分敌我, 「不打队友」本局已自动忽略"):format(others),SYS.CY.yellow)
    end
end


-- 隔墙检查(只在开关打开时才做 ray)
-- ★ 性能(v53): FindPartOnRay 是整个战斗循环里最贵的一步, 而目标在 0.25 秒内
--   基本不会换位置 -> 加一层短期缓存, 把"每帧每目标一次线检测"降到
--   "每人每 0.25 秒一次"。缓存键是 Part(角色重生会换新 Part, 旧键由弱表自动回收, 不泄漏)。
local SHOT_CACHE=setmetatable({},{__mode="k"})
local function clearShot(part)
    if not SYS.T_.CB_Wall then return true end
    local now=os.clock()
    local c=SHOT_CACHE[part]
    -- ★ v100 0.25 -> 0.1 秒: 旧缓存太长, 目标"已经缩回墙后"仍会被判成可见(用户报"有时候还会隔墙锁到人")
    if c and now-c.t<0.1 then return c.ok end
    local cam=SYS.Cam
    if not cam then return true end
    local cf=cam.CFrame
    if not cf then return true end
    local o=cf.Position
    -- ★ v4.1.0 子弹缝: 原来【只看中心一条射线】—— 远处敌人只露半身/头皮时中心常被掩体挡住,
    --   于是直接判"看不见" -> 不进候选 -> 表现为"敌人离开一定距离就不锁了"(用户报的)。
    --   现在改成多点采样: 中心 + 头皮 + 左右上下 + 四个斜上角, 只要【有一点通】就算"有缝可打"。
    --   顺序固定(先中心后边缘), 找到第一个通的就停, 不会来回跳。
    local pts={part.Position}
    local sz=part.Size
    if sz then
        local fx,fy,fz=sz.X*0.45,sz.Y*0.45,sz.Z*0.45
        local c=part.Position
        pts[#pts+1]=c+Vector3.new(0,fy,0)          -- 头皮(最常露出来的)
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
        -- ★ P() 返回 pcall 的多个值: 第一个是成功与否, 结果在第 2 个。
        local _,hit=P(function()
            return WS:FindPartOnRay(Ray.new(o,d.Unit*(d.Magnitude-1)),SYS.LP.Character)
        end)
        if hit==nil or (part.Parent and hit:IsDescendantOf(part.Parent)) then ok=true break end
    end
    SHOT_CACHE[part]={t=now,ok=ok}
    return ok
end

-- ★ v3.9.0 修「头皮位打不中」: 对枪时对方只露一点头皮/侧边, 瞄"部位中心"时射线被掩体挡住,
--   子弹打在墙上 = 开了枪但没打中。这里在中心被挡时沿部位边缘取几个点, 挑【第一个真正看得见】的点
--   当瞄准点(顺序固定 -> 不会左右跳, 避免抖动导致二次失准)。
--   ★ 开销: 只在"中心被挡"这种少数情况才多打射线, 且按 part 缓存 0.12 秒(理由同 SHOT_CACHE: 射线最贵)。
local SCALP_CACHE=setmetatable({},{__mode="k"})
local function sightOK(part,o,q)
    local d=q-o
    if d.Magnitude<1 then return true end
    local _,hit=P(function()
        return WS:FindPartOnRay(Ray.new(o,d.Unit*(d.Magnitude-1)),SYS.LP.Character)
    end)
    local par=part.Parent
    return hit==nil or (par and hit:IsDescendantOf(par))
end
local function visPoint(part)
    local c=part.Position
    local cam=SYS.Cam
    local o=cam and cam.CFrame and cam.CFrame.Position
    if not o then return c end
    if sightOK(part,o,c) then return c end          -- 中心可见 -> 直接用(绝大多数情况)
    local now=os.clock()
    local cc=SCALP_CACHE[part]
    if cc and now-cc.t<0.12 then return cc.p end
    local sz=part.Size
    local cands={
        c+Vector3.new(0,sz.Y*0.45,0),               -- 头顶: 头皮位最常露的就是这块
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

-- 命中点(带预测提前量)。CB_Predict 关掉时就是目标当前位置。
-- 为什么需要: 打移动目标时, 直接瞄"他现在的位置"等子弹/判定到达就已经偏了;
-- 瞄"他 CB_PredictTime 秒之后会在的位置"才命中。目标的横向速度越快, 这个值要越大。
local function leadPos()
    local p=CB.TargetPart
    if not p then return nil end
    -- ★ v3.9.0: 基准点先过一遍"可见点"(头皮位时瞄露出来的那块, 而不是被掩体挡住的中心)
    local pos=visPoint(p)
    if not SYS.T_.CB_Predict then return pos end
    local t=SYS.C_.CB_PredictTime or 0.14
    local v=p.AssemblyLinearVelocity
    if not v then
        local ok,r=pcall(function() return p.Velocity end)
        if ok then v=r end
    end
    local lead=pos
    if v then lead=lead+v*t end
    -- ★ v65 空中命中: 目标在空中(跳跃/下落)时补上重力二次项 ½gt²,
    --   否则线性预测会"打高"—— 瞄的是抛物线的起点而不是落点。
    local h=CB.Target and humOf(CB.Target)
    if h and h.FloorMaterial==Enum.Material.Air then
        local g=(WS and WS.Gravity) or 196.2
        lead=lead+Vector3.new(0,-0.5*g*t*t,0)
    end
    return lead
end

--======================== 指定目标 (v53 新增) ========================
--  两种选人方式:
--    · 自动 —— 按优先链自己挑(默认 正在瞄我的 → 我指定的目标 → 最近的敌人 → 屏幕中心; 见 CB_CHAINS)
--      ★ v3.7.2 注: 旧的 CB_Priority 参数已随"单选优先级"一起删除, 选人完全由优先链决定。
--    · 指定 —— 只打某一个人, 由「锁定当前目标」按钮或热键 V 循环切换来设定
--  指定的人死亡 / 退出 / 离场时, 默认自动回退到自动选择;
--  若打开 CB_TgtStrict, 则他不在场时完全不动手(严格只打他一个)。
local function enemyList()
    local t={}
    for _,pl in ipairs(Players:GetPlayers()) do
        if isEnemy(pl) then t[#t+1]=pl end
    end
    return t
end
CB.Enemies=enemyList

-- ★ v69 反馈通道: 战斗的提示以前只 print 到执行器控制台, 游戏里什么都看不到 ——
--   用户点按钮没反应就判定"功能无效"。统一改成 游戏内通知 + 控制台双写。
function CB.Say(txt,col)
    P(function() if SYS.Notify then SYS.Notify(tostring(txt),col or SYS.CY.green) end end)
    print("[Combat] "..tostring(txt))
end
-- ★ 保留(v3.7.2 复核更正): 战斗页诊断读的是【别名】cb.BodyOf(L6544), 字面扫描漏了 -> 不是死代码
CB.BodyOf=bodyOf      -- v60: 暴露给战斗页算"本地玩家到目标的距离"(兼容自定义骨架)

function CB.TargetName()
    local n=SYS.C_.CB_TargetName
    return (type(n)=="string" and n~="") and n or nil
end

-- 锁定指定玩家; 可传玩家对象, 也可以直接传名字(下拉框选出来的就是名字)
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

-- dir=1 下一个, -1 上一个; 只在活着的敌人之间轮换, 返回新目标名字
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

--======================== 目标选择 ========================
--======================== 目标选择 ========================
-- ★ v82 重写: 从"单选一个优先级"改成【优先链】—— 按第一优先筛, 没有就下一优先, 逐级兜底。
--   ★ v111: 默认链改为「最近 -> 正在瞄我的 -> 屏幕中心」。
--   ★ v113(用户 2026-09-17 再次要求): 默认顺序改为
--       ①正在瞄我的 ②我指定的目标 ③最近的敌人 ④屏幕中心
--     —— 也就是把「正在瞄我的」提到最前, 「指定目标」从"永远第 1"退到第 2 位。
--   实现: 「指定目标」仍不进 CB_CHAINS, 而是当成一枚【虚拟环 "specified"】按 specSlot 插进
--   实际执行顺序 —— 链首是 "aiming" 时插第 2 位(新默认), 否则插最前(= v111 的旧行为)。
--   所以实际生效顺序(模式 1) = 正在瞄我的 -> 我指定的目标 -> 最近的敌人 -> 屏幕中心。
--   ★ 例外: 打开「只打指定目标」(CB_TgtStrict) 时指定目标仍【绝对最优先】且整条链不参与 ——
--     那个开关的语义就是"只打他一个", 让他排在"正在瞄我的人"之后是自相矛盾的。
--   无敌盾的人直接不进候选池(CB_SkipFF), 等护盾结束再恢复。
local CB_CHAINS={
    [1]={"aiming","near","center"},   -- 正在瞄我的 -> 最近的 -> 屏幕中心 (默认; 指定目标插在第 2 位)
    [2]={"near","center"},            -- 最近 -> 屏幕中心
    [3]={"crosshair","near","center"},-- 准星指向 -> 最近 -> 屏幕中心
    [4]={"lowhp","near","center"},    -- 血量最低 -> 最近 -> 屏幕中心
    [5]={"center","near"},            -- 屏幕中心 -> 最近
}

-- ★ v113: 算出【实际生效的执行顺序】= 把虚拟环 "specified"(我指定的目标) 插进链里。
--   specSlot = 链首是 "aiming" 时取 2, 否则取 1(排最前 = v111 的旧行为)。
--   ★ pickTarget 与战斗页「立即测试一次」的诊断共用这一份 —— 免得改了一处忘了另一处,
--     出现"界面/诊断说的顺序"和"真实选人顺序"对不上的老毛病(v111 就漏过这种漏改)。
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

-- ★ 解析「我指定的目标」: 在场 + 活着 + (开了"只打视野内"时不隔墙) 就返回 (玩家, 部位)。
--   ★ 它【不】看 maxD —— 指定了就一直打他(v111 及以前就是这个行为, 没动)。
--   ★ v3.9.0: 但它现在【看 CB_SkipFF】—— 指定的人带无敌盾(刚复活)时本轮不返回, 等护盾结束自动恢复。
--     与 UI 文案"带无敌盾(ForceField)的人【完全不打】"保持一致(旧实现漏了这条 -> 用户看到"免疫力"提示)。
--   ★ 唯一副作用: 人不在了/死了就把指定清掉、退回自动 —— 也保持原样。
--   ★ 放【模块级】而不是放进 pickTarget: pickTarget 每帧都被调用, 写在里面等于每帧新建一个闭包。
--     (见《帧率优化-排查报告-v3.7.0》: 热路径上的闭包分配是明确点过的问题)
local function specResolve(mode)
    if not (CB.TargetName() and (SYS.C_.CB_TargetMode or 1)==2) then return nil end
    local pl=Players:FindFirstChild(CB.TargetName())
    if pl and isEnemy(pl) and not (SYS.T_.CB_SkipFF and hasShield(pl)) then
        local p=partOf(pl,mode)
        if p and (not SYS.T_.CB_Wall or clearShot(p)) then return pl,p end
    end
    if (not pl) or (not alive(pl)) then
        SYS.C_.CB_TargetName="" SYS.C_.CB_TargetMode=1
    end
    return nil
end

-- 供诊断显示用: 把执行顺序翻译成中文串(链里没有的档不显示)
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

-- ★★ v5.0.0「漏手打手 · 漏头皮打头皮」(用户要求: 不要"完全漏出身体或头"才能打)
--   公开实现里这叫 per-part visibility / "可见部位优先"。做法: 按【用户偏好顺序】逐个部位试,
--   取第一个"能打中"的暴露部位 —— 头露出来就打头, 只有手露出来就打手, 只有腿露出来就打腿。
--   ⚠️ 顺序里的名字要同时覆盖 R15(UpperTorso/LeftUpperArm) 与 R6(Torso/"Left Arm" 带空格)。
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
    -- ★★ 贴脸兜底(必须有, 否则会打不出近距离补刀):
    --   距离很近时射线起点几乎在敌人【身体内部】-> clearShot 对所有部位都返回 false
    --   -> 以前"至少还能选中头/身", 改成逐部位判定后反而一个都选不到, 贴脸补刀失效(仿真 C2 实测抓到)。
    --   近身(<=12 格)就按用户偏好直接把部位给它 —— 都贴上了, 不存在"打不穿"的问题。
    local hrp=bodyOf(ch)
    local my=bodyOf(SYS.LP.Character)
    if hrp and my and (hrp.Position-my.Position).Magnitude<=12 then
        return partOf(pl,mode)
    end
    return nil      -- 远距离且全身都被挡住 -> 这个目标这帧不可打(下一帧再看)
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

    -- ★ v113: 「只打指定目标」(严格) 的语义 = 只打他一个 -> 整条链不参与, 仍【绝对最优先】。
    --   必须【同时】有指定目标才短路; 没指定时保持旧行为(照常走优先链, 不是"完全不动手")。
    if SYS.T_.CB_TgtStrict and CB.TargetName() and (SYS.C_.CB_TargetMode or 1)==2 then
        return specResolve(mode)
    end

    -- ② 准星指向(模式 3)已并入下面的执行顺序循环 —— 见 "crosshair" 分支

    -- ③ 收集候选 + 算好每种优先度的值
    local vp=cam.ViewportSize
    local cx,cy=vp.X/2,vp.Y/2
    local myRoot=bodyOf(SYS.LP.Character)
    local cands={}
    for _,pl in ipairs(Players:GetPlayers()) do
        if isEnemy(pl) then
            -- ★★ v5.0.0: 旧逻辑是"先按设置挑【一个】部位(头/身), 再要求这个部位 clearShot 通过"
            --   -> **只要头或身子被挡住, 整个目标就被否掉**, 哪怕手/腿/头皮露在外面也不打(用户实测)。
            --   现在改成 PickVisiblePart: 按偏好顺序逐个试, 取【第一个能打中的暴露部位】= 漏哪儿打哪儿。
            --   (ClearShot 已经在 PickVisiblePart 里判过, 下面不再重复判)
            local p=CB.PickVisiblePart(pl,mode)
            if p then
                local d=(p.Position-camPos).Magnitude
                -- ★ v106 无敌盾改为【直接跳过】: 带 ForceField(出生/复活无敌) 的目标不进候选池,
                --   等护盾自然结束就能被选中 —— 用户要"等护盾结束后再发起攻击"。
                --   (旧行为是"降权排最后": 全服都有盾时仍锁着不放, 打不掉还占着扳机)
                -- ★ v3.9.0: 判据收敛到 hasShield(); 一次查找同时供"是否跳过"与"降权标记"用(原来查了两次)
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
                    -- ★ v3.10.1 血量用 Attribute 权威值 @Health(诊断实锤: Humanoid.Health 不可信)。
                    local function aattr(k)
                        local ok,v=pcall(function() return pl:GetAttribute(k) end)
                        return ok and v or nil
                    end
                    local ahp=aattr("Health")
                    if type(ahp)=="number" then hp=ahp end
                    local ff=_sh
                    -- ★ v3.10.1 威胁度升级(用户要「换弹的人降权」): 判据换成【双信号】。
                    --   @combatPaused = 战斗暂停(换弹/受控/无法攻击), 这是最权威的"暂时没威胁"信号;
                    --   手上没 Tool(收起武器) 作为兜底。两个都"无威胁"才降权 -> 避免误降。
                    --   威胁值 armed: 能攻击=true / 换弹或收枪=false(排到能开枪的后面)。
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

    -- ④ 实际执行顺序 = 链 + 插进去的「指定目标」虚拟环(见 chainOrder)
    --   例: 模式 1 = {aiming,near,center} -> {aiming, specified, near, center}
    local order=chainOrder(chain)

    -- ⑤ 按执行顺序逐级【筛选】; 无敌盾排最后
    --   ★ v100 修「优先模式搞错了(实际只按第一环生效)」: 旧实现是"每环都 pickBy 排序后直接 return",
    --     而 pickBy 只要候选非空就必定挑出一个 -> 第一环(alming)永远吞掉一切, near/center 永远走不到。
    --     现在改成真筛选: 每环有自己的"入选条件", 筛完为空才进下一环。
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
            -- 「我指定的目标」这一环: 他在场/活着/不隔墙就直接是他
            local a,b=specResolve(mode)
            if a then return a,b end
        elseif key=="crosshair" then
            -- 准星指向: 只有它是链首(模式 3)才算一环 —— 与旧实现一致
            if chain[1]=="crosshair" then
                local okH,hit=P(function()
                    return WS:FindPartOnRay(Ray.new(camPos,cf0.LookVector*(maxD+50)),SYS.LP.Character)
                end)
                if okH and hit then
                    local hp=playerFromPart(hit)
                    -- ★ v3.9.0: 补上 CB_SkipFF 判据 —— 准星指向这一环原来完全绕过候选池, 带无敌盾的
                    --   人(刚复活)被准星扫到就直接锁定+开火, 游戏侧表现为"免疫力/无敌"提示。
                    if hp and isEnemy(hp) and not (SYS.T_.CB_SkipFF and hasShield(hp)) then
                        local pp=partOf(hp,mode)
                        if pp and (not SYS.T_.CB_Wall or clearShot(pp)) then return hp,pp end
                    end
                end
            end
        else
            local pass={}
            for j=1,#cands do
                local c=cands[j]
                if key=="aiming" then
                    -- 只有【正在瞄我】的人才算命中这一环; 没人在瞄我就整环为空 -> 落到下一环
                    if c.s.aiming==0 then pass[#pass+1]=c end
                else
                    -- near / center / lowhp: 全体参与, 按各自的值排序取最优
                    pass[#pass+1]=c
                end
            end
            if #pass>0 then
                -- ★ v3.10.0 威胁度排序: aiming 环内先比【手上有没有武器】(有枪能立刻开枪的最危险),
                --   再比距离(多个持枪瞄我的人里选最近的)。没武器的(换弹/收起)自动排到持枪者后面。
                if key=="aiming" then
                    local c=pickBy(pass,"near")
                    -- 优先挑"持枪"的瞄我者; 只有所有人都没枪时才用纯距离结果
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
    -- ⑥ 兜底(几乎走不到, 因为每档链都含 near)
    if #cands==0 then P(CB.SelfHealFilters) end
    return nil,nil
end

--======================== 自动瞄准 ========================
local function aimTick()
    -- v60: 打开「自动瞄准」就持续瞄。C/End 键热键已在 v66 移除, "按住临时瞄"不再存在。
    if not SYS.T_.CB_Aim then return end
    -- ★ v6.7.0 瞄准补强(融合自 ChronixHub 瞄准设置): 命中率闸门
    if SYS.AimEx and not SYS.AimEx.HitGate() then return end
    -- ★ v68 快照瞄准(秒锁射击): 开快照时【不】做持续瞄准 —— 只在开枪瞬间转向、开枪后切回。
    --   否则持续瞄准每帧转相机, "秒切回"刚恢复就被下一帧又转走了。
    if SYS.T_.CB_SnapFire then return end
    -- ★ v62: 菜单打开时不抢相机 —— 用户在调菜单, 第一人称下转相机会让视角乱飘
    if SYS.MenuOpen then return end
    -- ★ v53 修「角色不能正常移动」: 自动瞄准会把相机指向目标, 而角色的前进方向又是
    --   跟着相机走的 —— 于是瞄准一开, 按 W 就朝目标走, 玩家会以为"角色卡住/不听使唤"。
    --   打开 CB_PauseMove 后, 一旦检测到 WASD 就暂停转相机, 松开立即恢复瞄准。
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
    -- ★ v68.2 模拟操作射准(服务端判定用【角色/枪口朝向】): 静止时也把角色【原地转向】目标,
    --   让枪口真实对准 —— 不依赖 Humanoid.AutoRotate(它可能被游戏关闭/转向太慢)。
    --   移动时(CB.Moving=true, 见上)已在前面 return, 不会改角色朝向、不破坏移动方向。
    --   CFrame.lookAt(rpos,pos) 位置=rpos=当前角色位置, 只改朝向、不瞬移。
    local root=bodyOf(SYS.LP.Character)
    if root then
        local rpos=root.Position
        if (pos-rpos).Magnitude>0.01 then
            local rwant=CFrame.lookAt(rpos,pos)
            root.CFrame = (spd>=1) and rwant or root.CFrame:Lerp(rwant,math.clamp(spd,0.02,1))
        end
    end
end

--======================== 静默瞄准(已删除) ========================
-- ★ 轮2: 静默瞄准整块已删(v74 起 CB_Silent 恒 false, 原 ~210 行 hook 永不执行)。
--   保留 CB.HookOK / CB.HookStat 字段供诊断读取(恒为 false / 0)。
function CB.InstallHook() CB.HookOK=false return false end

--======================== 自动开火 ========================
local function crosshairOnEnemy()
    local cam=SYS.Cam
    if not cam then return false end
    local cf=cam.CFrame
    if not cf then return false end
    local dist=SYS.C_.CB_MaxDist or 1200
    local _,part=P(function()
        return WS:FindPartOnRay(Ray.new(cf.Position,cf.LookVector*(dist+50)),SYS.LP.Character)
    end)
    -- v54: 用逐层回溯找玩家(见 playerFromPart 注释), 不再依赖"角色就是一个 Model"
    return isEnemy(playerFromPart(part))
end

local function fireTick()
    if not SYS.T_.CB_Fire then return end
    -- ★ v62: 菜单打开时停火 —— 自动开火往屏幕中心发"点击", 第一人称开菜单时
    --   会点在菜单控件上(开关被乱翻), 用户表现为"无法开关功能"
    if SYS.MenuOpen then return end
    local now=os.clock()
    if now-CB.LastFire<(SYS.C_.CB_FireDelay or 0.06) then return end
    -- ★ v6.7.0 漏打模式: 按概率跳过这次开火(制造"打偏"观感)
    if SYS.AimEx and not SYS.AimEx.MissGate() then CB.LastFire=now return end
    -- ★ v60 修「扳机没生效」: 旧逻辑在非静默时一律要求"准星精确压在敌人身上", 但
    --   没开自动瞄准时准星是玩家自己控制的, 很难正好压中 -> 扳机几乎永远不开火。
    --   正确语义:
    --     · 开了自动瞄准(相机已转向目标) 或 静默瞄准(射线已改) -> 有目标就直接打
    --     · 只开扳机、没开任何瞄准 -> 才要求准星真压在敌人身上(纯 triggerbot)
    -- ★ v3.9.0 修「开枪了但是没打中」: 自动瞄准模式下不能再"有目标就扣扳机"——
    --   相机是【渐进】转向的(CB_Smooth<1), 而且「移动时暂停瞄准」(CB_PauseMove) 会让 aimTick
    --   直接 return、相机根本不动; 这两种情况准星还偏着就开火 = 空放, 用户看到的就是"开枪了没打中"。
    --   现在自动瞄准模式追加一条: 准星(屏幕中心)必须已经落在【实际的瞄准点】上才开火。
    --   注意比较的是 leadPos()(相机就是朝它转的), 不是部位中心 —— 否则一开预测就会自我否决。
    local cam=SYS.Cam
    if not cam then return end
    local vp=cam.ViewportSize
    local canFire
    if SYS.T_.CB_Silent or SYS.T_.CB_Aim or SYS.T_.CB_SnapFire then
        local ap=CB.TargetPart and (leadPos() or CB.TargetPart.Position)
        if not ap then return end
        -- ★ v3.9.x 自动开火适配自动瞄准: 跟随速度拉满(CB_Smooth>=1)时相机是【瞬时】转到目标的,
        --   此刻准星必然已经压在瞄准点上 —— 不用再走屏幕投影容差判定(那一步会因"瞄准点≠部位中心"
        --   或远距离小目标而误判没压中, 结果就是"瞄准对上了却不开火")。直接放行开火。
        --   只有渐进转向(CB_Smooth<1)时才需要等准星真正压中, 避免空放。
        if (SYS.C_.CB_Smooth or 0.25)>=1 then
            canFire=true
        else
            local sp,on=cam:WorldToViewportPoint(ap)
            if not (on and sp.Z>0) then return end
            local tol=(vp.Y or 1080)*0.06     -- 屏幕高度的 6% 以内算"压住了"(约 65px@1080p)
            canFire=((sp.X-vp.X/2)^2+(sp.Y-vp.Y/2)^2)<=tol*tol
        end
    else
        canFire = crosshairOnEnemy()
    end
    if not canFire then return end
    -- 血量阈值: 只在目标血量低于阈值时开火(0=不限制)
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

--======================== 叠加层(FOV 圈 / 距离标签 / 目标高亮) 已删除 ========================
-- ★ v72 按用户要求整块删除("视场 pov 删掉吧 不要了")。
--   这三个原来都只有 hudTick(12Hz) 在画, 而 v71 起 UI 里已经没有它们的开关了 —— 纯死代码。
--   透视请看「视觉」页的 玩家透视(ESP) = 人物高亮 Highlight。
--======================== 移动检测 (v54) ========================
-- ★ 只靠 UIS:IsKeyDown 不可靠: 部分执行器 / 游戏的输入层拿不到真实按键状态,
--   于是"移动时暂停瞄准"形同虚设 —— 角色照样被相机带偏, 用户以为移动坏了。
--   现在双路径: InputBegan/InputEnded 记账为主(不理会 gp, 玩家按了就是按了), IsKeyDown 兜底。
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
    -- v56: 去掉 pcall(这个函数每 50ms 调一次)
    return UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.A)
        or UIS:IsKeyDown(Enum.KeyCode.S) or UIS:IsKeyDown(Enum.KeyCode.D)
end

--======================== 主循环 ========================
-- ★ v53 性能重写: 原来所有逻辑都挂在 RenderStep 上, 也就是每帧(60fps)都要跑一遍
--   「遍历全部玩家 + 视口投影 + 射线检测 + 叠加层刷新」, 玩家一多或有隔墙检测时直接掉帧。
--   现在拆成三层频率 —— 只有确实需要每帧的部分才每帧跑:
--     · 瞄准(转相机)  每帧 —— 必须跟手, 否则镜头一顿一顿
--     · 开火判定      每帧(开了瞄准/静默/快照时) —— ★ v72: 它只用缓存的 TargetPart, 很便宜,
--                     原来压 20Hz 最坏白等 50ms, 手感就是"开火慢"
--     · 选人          30Hz  —— 含射线检测(clearShot), 是最贵的部分; ★ v72 从 20Hz 提到 30Hz
--   实际开销约为原来的 1/3, 而手感没有可感知的变化。
local SCAN_DT=1/30          -- 选人检测周期(★ v72: 20Hz -> 30Hz)
local accScan=0
-- v53: 轻量计数器, 用来证明分层真的生效(1 秒内各层各跑几次), 也方便做性能自检
CB.Stat={scan=0,hud=0,aim=0}

local function tickBody(dt)
    dt=tonumber(dt) or 0.016
    if dt>0.5 then dt=0.5 end        -- 掉帧/挂起后不要一次性补偿太多

    -- ★ v3.9.0: 自己死了就别再瞄准/开火 —— 死了还在转相机 + 点左键, 既是完全无效的操作,
    --   也是"人已死但仍在发输入"的异常特征(容易招反作弊注意)。复活后自动恢复。
    --   ★ 判死要【双条件】: 血量归零【且】Humanoid 状态是 Dead/Physics。只看血量太脆 ——
    --   自定义血量系统的游戏里 Humanoid.Health 可能长期是 0(不代表死), 那样会把战斗功能整个停掉。
    local me=humOf(SYS.LP)
    if me and (me.Health or 1)<=0 then
        local okS,st=pcall(function() return me:GetState() end)
        if okS and (st==Enum.HumanoidStateType.Dead or st==Enum.HumanoidStateType.Physics) then
            CB.Target=nil CB.TargetPart=nil
            return
        end
    end

    -- ★ v60 总闸: 所有战斗开关都关时彻底空转 —— 不清目标、不跑 pickTarget。
    --   否则哪怕什么功能都没开, 每 50ms 还在对全服玩家做一遍视口投影 + 射线检测。
    -- ★ v72: FOV 圈 / 距离标签 / 目标高亮 整组已删(用户要求; v71 起 UI 里也已没有入口)
    local anyOn=SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_Fire
    if not anyOn then
        CB.Target=nil CB.TargetPart=nil
        return
    end

    accScan=accScan+dt
    if accScan>=SCAN_DT then
        accScan=0
        CB.Stat.scan=CB.Stat.scan+1
        -- 移动检测(20Hz 足够; 走 InputBegan/Ended 记账 + IsKeyDown 兜底, 见 movingNow)
        CB.Moving = SYS.T_.CB_PauseMove and movingNow() or false
        local t,p=pickTarget()
        CB.Target=t CB.TargetPart=p
        -- ★ v72: 纯"扳机模式"(没开任何瞄准)才留在这里 —— 它自己要做准星射线, 最贵
        if not (SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_SnapFire) then fireTick() end
        -- ★ v74: 静默瞄准已删除 -> 这里不再自动安装 hook(那 6 处 hook 就是最大的一堆报错来源)
    end

    -- ★ v72 修「开火慢了」: 开火判定本身很便宜(用的是缓存的 TargetPart), 之前被压在 20Hz,
    --   最坏情况白等 50ms。开了瞄准/静默/快照时改成【每帧】判一次。
    if SYS.T_.CB_Fire and (SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_SnapFire) then
        fireTick()
        CB.Stat.hud=CB.Stat.hud+1     -- 这个计数器现在记的是"开火判定次数"(原来是叠加层刷新)
    end

    aimTick()
    CB.Stat.aim=CB.Stat.aim+1
    if CB.meleeTick then CB.meleeTick() end    -- ★ v4.1.0 近距离补刀(贴脸没打中 -> 按 F 用刀)
end

-- ★ 性能兜底: BindToRenderStep 的回调一旦抛错, Roblox 会【每帧】把错误刷进控制台,
--   日志量级足以把游戏拖到十几帧。所以这里包一层, 出错计数并自我停用。
local CBERR=0
local function cbRenderTick(dt)
    if SYS.Unloaded then return end
    -- v54: 用 P(tickBody, dt) 直接带参调用 —— 既走真 pcall, 又不每帧新建一个闭包
    local ok,err=P(tickBody,dt)
    if ok then
        CBERR=0
        return
    end
    CBERR=CBERR+1
    -- ★ v56: 上一版只报前 3 次就彻底闭嘴 —— 结果真机出错时用户什么都看不到,
    --   我们也没法定位(表现为"功能全没生效 + 每帧还在空转所以很卡")。
    --   改成: 前 5 次全报, 之后每 60 次报一条(约 1 秒一条, 既不刷屏也不静默),
    --   并且把次数和最后一条错误挂在 CB 上, 诊断按钮随时能读。
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

-- ★ v4.1.0 近距离补刀: 目标贴脸(< CB_MeleeDist 格)时枪常打不中(准星/弹道),
--   这时自动按 F 用近战收掉。节流 CB_MeleeGap 秒一次, 避免刷屏式按键。
--   只在【已锁定目标】且【距离够近】时才按 —— 不影响中远距离的枪战。
-- ★ v5.3.0 补刀"打谁"的选择(用户要求: 能选"全部敌人"):
--   默认 = 只认【锁定的目标】(老行为)。
--   开了 `CB_MeleeAll` -> 改成在【附近所有敌人】里挑最近的那个 —— 解决
--   "旁边有非目标的敌人贴脸, 但因为不是当前锁定目标所以不补刀"的问题。
--   敌我判定直接走 `isEnemyEx`(和索敌同一套规则: 队伍 / 队友免伤开关都生效), **不另造一套**。
local function meleeCandidate(root)
    local MD=SYS.C_.CB_MeleeDist or 9
    -- ★ v5.4.0: 合成一个开关后, 这里【优先锁定目标, 其次最近敌人】——
    --   既保留原来的"优先打我在打的人", 又解决了"旁边非目标贴脸不补刀"。
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
    -- ★ v5.2.1 修「自动近战后被罚站, 动不了」(用户实测):
    --   根因: 近战(按 F)会进【攻击动画】, 动画期间角色是被锁住不能走的;
    --   而原实现【每 CB_MeleeGap(0.35s) 就重按一次 F】—— 目标一直贴脸 -> 一直重按 ->
    --   动画永远在播 -> 玩起来就是"罚站动不了"。
    --   修法: ①同一个目标【只补一刀】, 离过身(> 距离)才允许再补 -> 不再刷屏式连按;
    --         ②保证"松开键"(有些游戏只认 keyup, 少了它就等于 F 一直被按住);
    --         ③补完挂一个看门狗: 0.6s 后还走不动就把移动能力写回来(兜底解卡)。
    if d>MD then
        CB.MeleeDoneFor=nil            -- 目标离开射程 -> 允许下次再补
        return
    end
    if CB.MeleeDoneFor==p then return end          -- ① 同一目标只补一刀
    if CB.MeleeLockUntil and os.clock()<CB.MeleeLockUntil then return end
    local now=os.clock()
    if now-(CB.LastMelee or 0)<(SYS.C_.CB_MeleeGap or 0.35) then return end
    CB.LastMelee=now
    CB.MeleeDoneFor=p
    CB.MeleeLockUntil=now+0.9                      -- 一刀之后至少歇 0.9s, 别把动画连成一串
    -- ★ 用 VirtualInputManager 发真实按键(F 键 = 近战), 与手动按 F 等效
    local function key(down)
        P(function()
            if SYS.VIM and SYS.VIM.SendKeyEvent then
                SYS.VIM:SendKeyEvent(down,Enum.KeyCode.F,false,game)
            end
        end)
    end
    key(true)
    task.delay(0.05,function()
        key(false)                                    -- ② 松开
        task.delay(0.25,function() key(false) end)    -- 再补一次松开(防丢事件)
    end)
    -- ③ 看门狗: 补完 0.6s 还动不了(走路速度被清零/状态卡住) -> 写回来解卡
    task.delay(0.6,function()
        if SYS.Unloaded or not SYS.T_.CB_Melee then return end
        P(function()
            local _,hum,r2=GC()
            if not hum or not r2 then return end
            local want=(SYS.Orig.WalkSpeed or 16)*(SYS.C_.SpeedMult or 1)
            if hum.WalkSpeed<want*0.5 then             -- 明确被清零了才动它, 不瞎改
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
        -- 老执行器没有 BindToRenderStep 时退回 RenderStepped。
        -- ★ v54 修(性能泄漏): 这条连接原来塞进全局 Conns(只在卸载时清理), CB.Stop() 根本断不掉 ->
        --   "开关关掉了循环还在跑"; 更糟的是每次 Start 都会再加一条, 越玩越卡。
        --   现在单独留引用, Stop 时精确断开。
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
    -- v54: 断开回退连接(否则关掉开关后循环还在跑)
    if CB.FallbackConn then
        P(function() CB.FallbackConn:Disconnect() end)
        CB.FallbackConn=nil
    end
    CB.UsingFallback=false
    -- ★ v60: Stop 只负责停循环 + 清目标 + 清叠加层, 【不再改开关状态】。
    --   否则"临时关掉某个开关"会触发 Heartbeat 兜底 Stop -> 把别的开关也一并误关了。
    --   hook 不可逆, 靠"清目标"让 fakeRay 返回 nil 空转回原逻辑(不需要关 CB_Silent)。
    CB.Target=nil CB.TargetPart=nil CB.Moving=false
    CB.ResetClock()
end

-- 关掉所有"会驱动循环"的战斗开关(紧急停止用)。hook 不可逆, 关 CB_Silent 让它彻底失效。
function CB.DisableAll()
    SYS.T_.CB_Aim=false SYS.T_.CB_Silent=false SYS.T_.CB_Fire=false
    CB.Say("已关闭全部战斗功能",SYS.CY.red)
end

-- ★ v68 极速模式(一键秒锁秒开枪): 用户要"快速锁秒锁、慢一步就被打死"。
--   一条按钮把相关参数全设到位。
--   ★ v77 起: 用户要求删掉「快照瞄准」-> 一键开战改成打开【自动瞄准】。
--   (历史备注: 快照瞄准曾是"开枪瞬间同时转相机+角色朝向+临时关 AutoRotate", 移动中也准;
--    代价是高频直写角色 CFrame, 有被踢风险 —— 既然不要了, 那两段代码恒不执行。)
function CB.QuickMode()
    -- ★ v75/v77: 快照瞄准已删除 -> 这里只打开自动瞄准; 开火间隔 0.04s(v75 按用户反馈从 0.08 调快)
    -- ★ v75 三处改动(用户反馈):
    --   ① 【不再重置「目标优先级」】—— 原来这里写着 SYS.C_.CB_Priority=5, 于是每次点「一键开战」
    --      都把用户选的优先级覆盖回"准星指向", 表现就是"点不动 / 自己回去"。
    --   ② 静默已删除, 且瞄准方式默认开【自动瞄准】(用户实测"就自动瞄准挺好的")。
    --   ③ 开火间隔 0.08 -> 0.04(用户报"开火慢了")。
    SYS.T_.CB_Aim=true SYS.T_.CB_Fire=true
    SYS.T_.CB_SnapFire=false SYS.T_.CB_Silent=false
    SYS.T_.CB_Predict=true
    SYS.C_.CB_PrioMode=1   -- ★ v113: 一键开战默认优先链 = 正在瞄我的 -> 指定目标 -> 最近的 -> 屏幕中心
    SYS.C_.CB_Smooth=1 SYS.C_.CB_FireDelay=0.04
    SYS.C_.CB_AimPart=1
    -- ★ 注意: QueueSave 是 [02] 段的 local, 本模块在 [11.5] 词法作用域取不到 -> 走 SYS 查表
    P(SYS.QueueSave)
    for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
    CB.Start()
    CB.Say("⚡ 一键开战: 自动瞄准 + 自动开火 + 预测 + 锁头 + 优先链(正在瞄我的→指定→最近→屏幕中心)",SYS.CY.green)
    print("[Combat] ⚡ 一键开战: 自动瞄准 + 自动开火 0.04s + 预测 + 锁头 + 优先链 1")
end

--======================== 立即测试一次 (v56) ========================
-- 手动跑一遍完整的"选人 -> 瞄准 -> 静默 -> 开火判定", 每一步都把结果打出来。
-- 目的: "功能没生效"以前只能靠猜, 现在用户点一下按钮就能看到卡在哪一步。
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

    -- ★ v79: 「静默瞄准」和「快照瞄准」都已按用户要求删除 -> 诊断里不再列这两项
    add("瞄准方式: "..(SYS.T_.CB_Aim and "自动瞄准(每帧把准星转到目标)" or "关闭")
        .."   (静默瞄准 / 快照瞄准 已删除)")

    add(("tick 错误计数: %d %s")
        :format(CBERR, (CBERR>0 and (", 最后一条: "..tostring(CB.LASTERR)) or "")))
    CB.Say(("测试: 可选敌人 %d · 选人 %s · tick错误 %d"):format(#list,t and t.Name or "无",CBERR),SYS.CY.cyan)
    local txt=table.concat(L,"\n")
    print(txt)
    return txt
end

--======================== 一键诊断 (v54) ========================
-- 战斗页上的「输出诊断」按钮会调它。以前"某个功能没生效"只能靠猜,
-- 现在把所有关键前提一次性打出来: 循环在不在跑 / 认出几个敌人 / 每个敌人的结构 /
-- 当前目标 / 开关状态 / 准星是否真的压在敌人身上。
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
    -- ★ v65 诊断: 相机 CFrame 状态 + 视野内外分布 —— 定位"有敌人却选不到目标"
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
    -- ★ v65: 「不打队友」靠标准 Player.Team 匹配。如果这个游戏用自定义分队,
    --   这里会显示 nil —— 把这段发我, 我按它的分队方式加判断。
    add(("我的队伍: %s   队伍色: %s   (上面若全是 nil, 说明游戏不用标准队伍, 需要按它的方式加判断)")
        :format(tostring(SYS.LP.Team and SYS.LP.Team.Name or "nil"), tostring(SYS.LP.TeamColor)))
    add(("当前目标: %s   瞄准部位: %s")
        :format(CB.Target and CB.Target.Name or "无",
                CB.TargetPart and tostring(CB.TargetPart.Name) or "无"))
    add(("指定目标: %s (模式=%s 严格=%s)")
        :format(tostring(CB.TargetName()), tostring(SYS.C_.CB_TargetMode), tostring(SYS.T_.CB_TgtStrict)))
    -- ★ v113: 把【实际生效的选人顺序】直接打出来 —— "为什么选了他"一眼对照(与 pickTarget 同一份数据)
    --   ⚠️ P() 返回 (ok, 结果), 不能直接嵌进 tostring()(那样拿到的是 true)
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
    -- ★ v63: 关键判断 —— 游戏到底用哪个 API 判定命中。打一枪再看这三个计数:
    --   · ray>0   => 游戏用 Workspace:FindPartOnRay/Raycast 判定(工作区射线已替换 -> 精准)
    --   · cam>0   => 游戏调用了 Camera:ScreenPointToRay/ViewportPointToRay
    --   · mouse>0 => 游戏读 mouse.UnitRay
    --   · 都是 0  => 服务端判定命中, 客户端做不到, 只能自动瞄准
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

--======================== 热键 ========================
-- ★ v66: C/End 热键已移除 —— 战斗的开/关全部走战斗页的 UI 开关(用户要求)。
--   只保留 V 键(切换指定目标)。若 V 也被游戏占用再换成按钮。
T(UIS.InputBegan:Connect(function(inp)
    if SYS.Unloaded then return end
    if inp.KeyCode==(SYS.KeyCodeOf(SYS.C_.Key_CycleTarget) or Enum.KeyCode.V) then
        -- ★ P() 返回 pcall 的多个值: 第一个是成功与否, 结果在第二个
        local ok,r=P(function() return CB.CycleTarget(1) end)
        print((ok and r) and ("[Combat] 指定目标 -> "..r) or "[Combat] 附近没有可选目标")
    end
end))
-- 有任何战斗开关打开就确保循环在跑; 全关则停循环(不再每帧空转)
T(RS.Heartbeat:Connect(function()
    if SYS.Unloaded then return end
    if SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_Fire then
        CB.Start()
    else
        CB.Stop()
    end
end))

-- ★ v72 一次性迁移(用户报: 还在锁死人 / 背身锁慢 / 开火慢)
--   · CB_OnlyAlive 可能是老配置里存下的 false -> 强制打开(没有 Humanoid 的模型一律不算活人)
--   · 快照限流的老默认值(60 度 / 0.25s / 0.05s / 0.06s)会把"背身"卡成要连开好几枪才转过去:
--     ① 0.25s 最小间隔 + ② 60 度最大转角 => 转 180 度要 3 枪 × 0.25s ≈ 0.75 秒, 手感就是"背身锁慢"
--     只升级【当前值恰好等于旧默认值】的项, 用户自己调过的值一律不动
function CB.MigrateV72()
    -- ★ v74: 静默瞄准已删除(用户: "静默 删除 bug太多 不要了") -> 老配置里开着的强制关掉
    if SYS.T_.CB_Silent then
        SYS.T_.CB_Silent=false
        print("[Combat] v74 迁移: 静默瞄准已删除 -> 已关闭")
    end
    -- ★ v77: 快照瞄准已删除(用户: "快照瞄准是什么来着 可以也不要了")
    if SYS.T_.CB_SnapFire then
        SYS.T_.CB_SnapFire=false
        print("[Combat] v77 迁移: 快照瞄准已删除 -> 已关闭")
    end
    -- ★ v75: 「只打视野内」默认打开。穿墙/追踪是跟着静默瞄准一起删掉的, 所以把 CB_Wall 关掉
    --   现在只剩"隔墙也会锁"这个坏处(锁着一个打不到的人) -> 老配置里关着的一律打开。
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
    if (SYS.C_.CB_FireDelay or 0.06)==0.06 then SYS.C_.CB_FireDelay=0.035 end
    print(("[Combat] v72 参数: 单次转角上限=360° 最小间隔=%.2f 转向后延迟=%.2f 开火间隔=%.3f")
        :format(SYS.C_.CB_SnapMinGap,SYS.C_.CB_SnapDelay,SYS.C_.CB_FireDelay))
end
P(CB.MigrateV72)
P(hookDeathEvents,0)   -- ★ v76: 订阅死亡/复活事件(只读); ★ v103 带重试

-- 模块加载时若配置里有开着的战斗开关, 直接起来
if SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_Fire then
    CB.Start()
end

print("[CheatMenu] 战斗模块已加载 (菜单战斗页: 一键开战/停战 + 各开关 · 按 V 切换指定目标)")

--============================================================
--============================================================
-- [12] 翻译模块 v70 · 重写版（干净实现，不继承旧版任何逻辑）
-- ------------------------------------------------------------
-- 设计原则（用户要求：删掉老的避让/提示/多层拦截，重新写过）
--   ① 判据只有一条链 shouldTranslate，没有白名单、没有避让表；
--   ② 不掩码、不批量、不做三级降级：送进去的是原文，出来的就是译文，只有成/不成；
--   ③ 防重复翻译只靠【输出集合】这一个不依赖时序的判据（不看对象、不看标记、不看顺序）；
--   ④ 还原原文按【文本】反查，不依赖控件生命周期（控件会被引擎销毁重建）；
--   ⑤ 三条落地路径：界面标签 / ProximityPrompt 文案 / 聊天。
--   ⑥ 出问题只可能出一处 —— 想看"谁翻了什么"就点「导出翻译对照表」。
--============================================================
local Trans={}
SYS.Trans=Trans

Trans.LANGS={ {name="英语",code="en"},{name="中文",code="zh"},{name="日语",code="ja"},
              {name="韩语",code="ko"},{name="泰语",code="th"},{name="俄语",code="ru"},
              {name="阿拉伯语",code="ar"} }
function Trans.langName(c)
    for _,l in ipairs(Trans.LANGS) do if l.code==c then return l.name end end
    return c
end
Trans.SendLang="en"
Trans.cacheCount=0
Trans.Stats={hit=0,loc=0,fail=0,netfail=0,skip=0,sweepSkip=0,lat=0,latN=0,replaced=0}

-- 服务地址(与旧版一致: 本机 llama-server)
local HOST="http://127.0.0.1:8080"
local KEY="rk_4a56fc43faa5edb9f7a0cafd4ad3e91f"
local MODEL="hymt2-7b"
local SYS_PROMPT=[[You are a game-UI translation engine. Translate the user's text into ZH.
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
If the text is already ZH or contains CJK characters, output it unchanged.]]

--============================================================
-- 文本工具
--============================================================
local NON_ASCII="[\128-\255]"
local utf8codes=(type(utf8)=="table" and type(utf8.codes)=="function") and utf8.codes or nil

-- ★ v91: 精确脚本识别(一次扫描, 返回 汉字/假名/谚文 三标志)。
--   只有"纯正中文"(含汉字 且 不含假名/谚文)才不翻; 日文假名/韩文谚文交给翻译。
local function scanScript(s)
    local han,kana,hangul=false,false,false
    if type(s)~="string" or s=="" then return han,kana,hangul end
    if utf8codes then
        local ok,iter,state,init=pcall(utf8codes,s)
        if ok and type(iter)=="function" then
            local ok2=pcall(function()
                for _,cp in iter,state,init do
                    if cp>=0x4E00 and cp<=0x9FFF then han=true
                    elseif cp>=0x3400 and cp<=0x4DBF then han=true
                    elseif cp>=0xF900 and cp<=0xFAFF then han=true
                    elseif cp>=0x3040 and cp<=0x30FF then kana=true
                    elseif cp>=0xAC00 and cp<=0xD7AF then hangul=true
                    end
                end
            end)
            if ok2 then return han,kana,hangul end
        end
    end
    -- 字节兜底(utf8 不可用时): E4-E9=汉字; E3 81-83=假名, E3 90-BF=扩展A汉字; EA-ED=谚文
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
        elseif b>=0xEA and b<=0xED then hangul=true
        end
        i=i+1
    end
    return han,kana,hangul
end
-- 含中文 = 纯正中文(含汉字 且 不含假名/谚文)
local function hasChinese(s)
    if type(s)~="string" or s=="" then return false end
    if not s:find(NON_ASCII) then return false end          -- 纯 ASCII 快通道(C 层一次 find)
    local han,kana,hangul=scanScript(s)
    return han and not kana and not hangul
end
-- 含日文假名/韩文谚文(要交给翻译)
local function hasKanaOrHangul(s)
    local _,kana,hangul=scanScript(s)
    return kana or hangul
end

-- 一趟扫描问出"有没有外文字符"(latin/kana/hangul/泰文/西里尔/阿拉伯)
local function hasForeign(s)
    if type(s)~="string" or s=="" then return false end
    if s:find("[A-Za-z]") then return true end
    if not s:find(NON_ASCII) then return false end
    local i=1
    while true do
        local b=s:byte(i)
        if not b then break end
        if b>=0xC0 then
            -- 多字节: 看首字节对应的区段粗判(日文假名/韩文/泰文/西里尔/阿拉伯)
            if (b>=0xE0 and b<=0xEF) then return true end
            if (b>=0xD0 and b<=0xD1) then return true end
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
Trans.stripRich=stripRich

local function splitPrefix(text)
    if type(text)~="string" then return "",text or "" end
    local p1,c1=text:match("^(<font[^>]*>.-:</font>%s*)(.+)$")
    if p1 and c1 and c1~="" then return p1,c1 end
    local p3,c3=text:match("^(.-[:：]%s*)([^/%s].*)$")
    if p3 and c3 and c3~="" and #p3<=40 and not text:match("^%a[%w%+%-%.]*://") then return p3,c3 end
    return "",text
end
Trans.splitPrefix=splitPrefix

local function normalizeKey(text)
    if type(text)~="string" then return text end
    text=(text:gsub("<[^>]*>",""))
    return ((text:gsub("^%s+","")):gsub("%s+$","")):lower()
end
Trans.normalizeKey=normalizeKey

-- ★ 轮1: 字面替换(原文含 %、-、. 等模式字符也不会被 gsub 当正则)。
--   之前 cur:gsub(plain,hit,1) 会把原文当 Lua 模式 -> "50% exp" 这类原文直接抛
--   "malformed pattern" 且发生在扫描循环里 -> 静默杀掉整个翻译扫描。
local function plainReplace(s, from, to)
    if type(s)~="string" or type(from)~="string" or from=="" then return s end
    local i, j = s:find(from, 1, true)   -- plain=true: 不做模式匹配
    if not i then return s end
    return s:sub(1, i-1) .. tostring(to) .. s:sub(j+1)
end
Trans.plainReplace=plainReplace

-- ★ v92: 混排文本切分(汉字段 vs 外文/数字/标点段), 用于"跳过中文只翻外文, 得到全中文"。
--   返回 { {text=.., han=bool}, ... }, han=true 是汉字段, han=false 是外文/假名/谚文/数字/标点段。
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
    -- 字节兜底: E4-E9 开头 = 汉字(3字节/字), 其余算外文段
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
Trans.splitSegments=splitSegments

--============================================================
-- 本地短语表(零延迟, 不吃服务器槽位)
--============================================================
local WORD_TABLE={
    ["train"]="训练",["gym"]="健身房",["power"]="力量",["kick"]="踢击",["rebirth"]="重生",
    ["reborn"]="重生",["stamina"]="体力",["bonus"]="加成",["strength"]="力量",["damage"]="伤害",
    ["energy"]="能量",["coin"]="金币",["coins"]="金币",["gem"]="宝石",["gems"]="宝石",["robux"]="Robux",
    ["rare"]="稀有",["epic"]="史诗",["common"]="普通",
    ["speed"]="速度",["luck"]="幸运",["exp"]="经验",["level"]="等级",["quest"]="任务",
    ["shop"]="商店",["trade"]="交易",
    ["respawn"]="重生",["spawn"]="出生点",["equip"]="装备",["buy"]="购买",["sell"]="出售",
    ["upgrade"]="升级",["craft"]="制作",["stats"]="属性",["skill"]="技能",["attack"]="攻击",
    ["defense"]="防御",["health"]="生命值",["gold"]="金币",["cash"]="现金",["pet"]="宠物",
    ["pets"]="宠物",["hatch"]="孵化",["evolve"]="进化",["weapon"]="武器",["armor"]="护甲",
    ["lol"]="哈哈",["gg"]="打得漂亮",["wp"]="打得漂亮",["ty"]="谢谢",["thx"]="谢谢",
    ["nice"]="不错",["afk"]="挂机",["brb"]="马上回来",["omg"]="天啊",["help"]="救命",
    ["index"]="索引",["store"]="商店",["rebirths"]="重生",["settings"]="设置",
    ["acceleration"]="加速度",["achievement"]="成就",["aim"]="瞄准",["align"]="对齐",
    ["alliance"]="联盟",["amplitude"]="振幅",["anchor"]="锚点",["angle"]="角度",
    ["angularvelocity"]="角速度",["area"]="面积",["avatar"]="形象",["axis"]="轴",
    ["back"]="返回",["badge"]="徽章",["beam"]="光束",["block"]="屏蔽",
    ["boolvalue"]="布尔值",["branch"]="分支",["bundle"]="礼包",
    ["buoyancy"]="浮力",["camera"]="相机",["cancel"]="取消",["cancollide"]="可碰撞",
    ["canquery"]="可查询",["cantouch"]="可触摸",["character"]="角色",["chat"]="聊天",
    ["checkpoint"]="检查点",["circumference"]="周长",["claim"]="领取",
    ["click"]="点击",["close"]="关闭",["codex"]="图鉴",["collision"]="碰撞",
    ["color"]="颜色",["colorsequence"]="颜色序列",["community"]="社区",["complete"]="完成",
    ["cone"]="圆锥",["configuration"]="配置",["confirm"]="确认",["connecting"]="连接中",
    ["controller"]="手柄",["controls"]="控制",["cooldown"]="冷却",["crate"]="宝箱",
    ["creator"]="创作者",["crouch"]="蹲下",["cube"]="立方体",
    ["cylinder"]="圆柱",["defeat"]="失败",["degree"]="度",
    ["density"]="密度",["depth"]="深度",["deselect"]="取消选择",["developer"]="开发者",
    ["dialogue"]="对话",["diameter"]="直径",["discount"]="折扣",["distance"]="距离",
    ["drag"]="拖动",["drop"]="丢弃",["effect"]="效果",
    ["elasticity"]="弹性",["equipped"]="已装备",["error"]="错误",["euler"]="欧拉",
    ["event"]="活动",["experience"]="体验",["expired"]="已过期",["explosion"]="爆炸",
    ["failed"]="失败",["featured"]="精选",["floatvalue"]="浮点",["folder"]="文件夹",
    ["force"]="力",["fps"]="帧率",["free"]="免费",["frequency"]="频率",
    ["friction"]="摩擦",["friends"]="好友",["gradient"]="渐变",["graphics"]="图形",
    ["gravity"]="重力",["grid"]="网格",["heal"]="治疗",
    ["heat"]="热量",["height"]="高度",["hitbox"]="命中框",["hot"]="热门",
    ["hover"]="悬停",["humanoid"]="人形",["hurtbox"]="受击框",["impulse"]="冲量",
    ["incomplete"]="未完成",["inertia"]="惯性",["intvalue"]="整数",["join"]="加入",
    ["jump"]="跳跃",["keyboard"]="键盘",["language"]="语言",["leaderboard"]="排行榜",
    ["leave"]="离开",["length"]="长度",["lhello"]="你好",["lift"]="升力",
    ["limited"]="限定",["loading"]="加载中",["lobby"]="大厅",["locked"]="已锁定",
    ["lore"]="传说",["maintenance"]="维护",["mana"]="法力",["map"]="地图",
    ["massless"]="无质量",["material"]="材质",["matrix"]="矩阵",["mesh"]="网格",
    ["mission"]="任务",["mobile"]="移动端",["model"]="模型",["momentum"]="动量",
    ["mouse"]="鼠标",["move"]="移动",["music"]="音乐",["mute"]="静音",
    ["narration"]="旁白",["new"]="新",["next"]="下一步",["no"]="不",
    ["notifications"]="通知",["numberrange"]="数字范围",["numbersequence"]="数字序列",["numbervalue"]="数字值",
    ["objective"]="目标",["objectvalue"]="对象值",["official"]="官方",["ok"]="好的",
    ["open"]="打开",["option"]="选项",["orientation"]="方向",["owned"]="已拥有",
    ["pan"]="平移",["particle"]="粒子",["party"]="队伍",
    ["pc"]="电脑",["phase"]="相位",["ping"]="延迟",["place"]="场所",
    ["plane"]="平面",["play"]="开始",["popular"]="流行",["position"]="位置",
    ["premium"]="高级",["pressure"]="压力",["privacy"]="隐私",["progress"]="进度",
    ["projectile"]="弹体",["prone"]="趴下",["quality"]="画质",["quaternion"]="四元数",
    ["radian"]="弧度",["radius"]="半径",["rank"]="排名",["rate"]="速率",
    ["ready"]="准备就绪",["recommended"]="推荐",["rect"]="矩形",["reflectance"]="反射率",
    ["region"]="区域",["reload"]="换弹",["report"]="举报",["resize"]="调整大小",
    ["retry"]="重试",["reward"]="奖励",["rotate"]="旋转",["rotation"]="旋转",
    ["round"]="回合",["run"]="奔跑",["sale"]="促销",["scalar"]="标量",
    ["scale"]="缩放",["scroll"]="滚动",["season"]="赛季",["select"]="选择",
    ["sensitivity"]="灵敏度",["server"]="服务器",["sfx"]="音效",["shoot"]="射击",
    ["size"]="大小",["skip"]="跳过",["snap"]="吸附",["sphere"]="球体",
    ["spin"]="抽取",["status"]="状态",["stringvalue"]="字符串值",["subtitle"]="字幕",
    ["success"]="成功",["support"]="支持",["team"]="队伍",["temperature"]="温度",
    ["terms"]="条款",["texture"]="纹理",["thrust"]="推力",["tier"]="层级",
    ["time"]="时间",["torque"]="扭矩",["touch"]="触摸",["trail"]="拖尾",
    ["transparency"]="透明度",["trending"]="趋势",["trigger"]="触发器",["unequip"]="卸下",
    ["universe"]="宇宙",["unlocked"]="已解锁",["update"]="更新",["use"]="使用",
    ["value"]="值",["vector"]="向量",["velocity"]="速度",["verified"]="已认证",
    ["vibration"]="振动",["victory"]="胜利",["vip"]="贵宾",["volume"]="音量",
    ["walk"]="行走",["wavelength"]="波长",["wedge"]="楔形",["width"]="宽度",
    ["work"]="工作",["yes"]="是",["zoom"]="缩放",
    -- ★ v4.8.0 扩充(高频词/短句, 本地 0 毫秒直译)
    ["accept"]="接受",
    ["ammo"]="弹药",
    ["apply"]="应用",
    ["armor"]="护甲",
    ["assist"]="助攻",
    ["back"]="返回",
    ["block"]="屏蔽",
    ["bonus"]="加成",
    ["buy"]="购买",
    ["cancel"]="取消",
    ["cash"]="现金",
    ["chat"]="聊天",
    ["claim"]="领取",
    ["close"]="关闭",
    ["collect"]="收取",
    ["combo"]="连击",
    ["complete"]="完成",
    ["completed"]="已完成",
    ["confirm"]="确认",
    ["cooldown"]="冷却中",
    ["daily"]="每日",
    ["death"]="死亡",
    ["deaths"]="死亡",
    ["decline"]="拒绝",
    ["defeat"]="失败",
    ["delete"]="删除",
    ["draw"]="平局",
    ["drop"]="丢弃",
    ["energy"]="体力",
    ["equip"]="装备",
    ["exit"]="退出",
    ["expired"]="已过期",
    ["free"]="免费",
    ["friend"]="好友",
    ["friends"]="好友",
    ["gold"]="金币",
    ["grenade"]="手雷",
    ["headshot"]="爆头",
    ["health"]="生命值",
    ["help"]="帮助",
    ["hp"]="生命",
    ["incomplete"]="未完成",
    ["info"]="信息",
    ["inventory"]="背包",
    ["invite"]="邀请",
    ["join"]="加入",
    ["kills"]="击杀",
    ["knife"]="刀",
    ["leave"]="离开",
    ["load"]="读取",
    ["loading"]="加载中",
    ["locked"]="未解锁",
    ["mana"]="法力",
    ["match"]="对局",
    ["maxed"]="已满级",
    ["medkit"]="医疗包",
    ["menu"]="菜单",
    ["message"]="消息",
    ["mission"]="任务",
    ["missions"]="任务",
    ["mp"]="法力",
    ["mute"]="静音",
    ["new"]="新",
    ["next"]="下一步",
    ["now"]="现在",
    ["objective"]="目标",
    ["ok"]="确定",
    ["okay"]="确定",
    ["open"]="打开",
    ["options"]="选项",
    ["owned"]="已拥有",
    ["party"]="队伍",
    ["paused"]="已暂停",
    ["pistol"]="手枪",
    ["play"]="开始",
    ["progress"]="进度",
    ["quest"]="任务",
    ["quests"]="任务",
    ["quit"]="退出",
    ["rank"]="段位",
    ["ready"]="准备就绪",
    ["reconnecting"]="正在重连",
    ["reload"]="换弹",
    ["report"]="举报",
    ["reset"]="重置",
    ["respawn"]="复活",
    ["resume"]="继续",
    ["resumed"]="已继续",
    ["reward"]="奖励",
    ["rewards"]="奖励",
    ["rifle"]="步枪",
    ["round"]="回合",
    ["save"]="保存",
    ["score"]="得分",
    ["select"]="选择",
    ["selected"]="已选择",
    ["sell"]="出售",
    ["send"]="发送",
    ["settings"]="设置",
    ["shield"]="护盾",
    ["shotgun"]="霰弹枪",
    ["sniper"]="狙击枪",
    ["spawn"]="出生",
    ["spectate"]="观战",
    ["spectating"]="观战中",
    ["stamina"]="体力",
    ["start"]="开始",
    ["store"]="商店",
    ["streak"]="连杀",
    ["team"]="队伍",
    ["tie"]="平局",
    ["today"]="今天",
    ["tomorrow"]="明天",
    ["trade"]="交易",
    ["trading"]="交易中",
    ["unequip"]="卸下",
    ["unlock"]="解锁",
    ["unlocked"]="已解锁",
    ["unmute"]="取消静音",
    ["upgrade"]="升级",
    ["use"]="使用",
    ["victory"]="胜利",
    ["vote"]="投票",
    ["waiting"]="等待中",
    ["weapon"]="武器",
    ["weapons"]="武器",
    ["weekly"]="每周",
    ["welcome"]="欢迎",
    ["yes"]="是",

}
local PHRASE_TABLE={
    ["good game"]="打得漂亮",["well played"]="打得好",["nice shot"]="好枪法",
    ["thank you"]="谢谢",["anyone here"]="有人在吗",["join our discord"]="加入我们的 Discord",
    ["click to buy"]="点击购买",["max value"]="最大值",["best value"]="最值",
    -- ★ v4.8.0 扩充(高频词/短句, 本地 0 毫秒直译)
    ["add friend"]="加好友",
    ["anyone here"]="有人吗",
    ["are you sure"]="确定吗",
    ["are you sure?"]="确定吗？",
    ["best value"]="最优值",
    ["claim all"]="全部领取",
    ["click to buy"]="点击购买",
    ["collect all"]="全部收取",
    ["coming soon"]="即将推出",
    ["connection lost"]="连接断开",
    ["daily reward"]="每日奖励",
    ["double kill"]="双杀",
    ["game over"]="游戏结束",
    ["good luck"]="祝你好运",
    ["great job"]="干得好",
    ["insufficient funds"]="余额不足",
    ["join our discord"]="加入我们的 Discord",
    ["kill streak"]="连杀",
    ["level required"]="等级不足",
    ["level up"]="升级",
    ["loading..."]="加载中…",
    ["max level"]="满级",
    ["max value"]="最大值",
    ["nice shot"]="好枪法",
    ["not enough coins"]="金币不足",
    ["not enough gems"]="宝石不足",
    ["not ready"]="未准备",
    ["open all"]="全部打开",
    ["out of ammo"]="弹药耗尽",
    ["out of stock"]="缺货",
    ["please wait"]="请稍候",
    ["press any key"]="按任意键",
    ["press space to continue"]="按空格继续",
    ["respawn now"]="立即复活",
    ["sold out"]="已售罄",
    ["start game"]="开始游戏",
    ["team up"]="组队",
    ["thank you"]="谢谢",
    ["time left"]="剩余时间",
    ["times up"]="时间到",
    ["triple kill"]="三杀",
    ["upgrade all"]="全部升级",
    ["weekly reset"]="每周重置",
    ["welcome back"]="欢迎回来",
    ["well played"]="打得漂亮",
    ["you died"]="你已死亡",
    ["you have been eliminated"]="你已被淘汰",
    ["you lose"]="你输了",
    ["you win"]="你赢了",

}
local function lookupLocal(text)
    -- ★ v80: 「本地短语表」开关 —— 关掉后, 没开翻译模型就什么都不翻。
    --   (之前用户"清空了缓存却发现还有东西被翻译", 就是这张内置离线短语表在起作用, 它跟缓存无关)
    if SYS.T_.LocalPhrase==false then return nil end
    if type(text)~="string" then return nil end
    -- ★ v99: "数值单位 + 货币名"整段匹配: "1K Coins" -> "1K 金币"(保留数值大小写)
    --   词表只存单词 coins=金币, 但 "1K Coins" 整段查不到 -> 走模型翻成"硬币"。
    --   这里识别数值前缀(1K/10M/1.5B/1e11/1,234,567), 只翻译后面的货币名。
    local _raw=text:gsub("^%s+","")
    _raw=_raw:gsub("%s+$","")
    local _num,_rest = _raw:match("^(%d[%d%.,eE%+%-%w]*)[%s]+(%a+)$")
    if _num and _rest then
        local _rv = WORD_TABLE[_rest:lower()] or PHRASE_TABLE[_rest:lower()]
        if _rv then return _num .. " " .. _rv end
    end
    local k=(text:gsub("^%s+","")):gsub("%s+$","")
    k=k:lower()
    k=(k:gsub("[%p]+$",""))
    if k=="" or #k>48 then return nil end
    local v=WORD_TABLE[k] or PHRASE_TABLE[k]
    if v then return v end
    local k2=(k:gsub("^the ",""):gsub("^a ",""):gsub("^an ",""))
    if k2~=k then return WORD_TABLE[k2] or PHRASE_TABLE[k2] end
    return nil
end
Trans.lookupLocal=lookupLocal

--============================================================
-- 判定链(唯一一处) + 输出集合(防二次翻译的根因判据)
--============================================================
Trans.Outputs={}
Trans.OutputsN=0
local function markOutput(s)
    if type(s)~="string" or s=="" or not hasChinese(s) then return end
    if Trans.Outputs[s] then return end
    if Trans.OutputsN>=12000 then Trans.Outputs={} Trans.OutputsN=0 end
    Trans.Outputs[s]=true
    Trans.OutputsN=Trans.OutputsN+1
end
Trans.markOutput=markOutput
local function alreadyOurs(s) return type(s)=="string" and Trans.Outputs[s]==true end
Trans.alreadyOurs=alreadyOurs

-- ★ v115(性能): 玩家名清单 —— 顶栏/记分板/头顶名牌这类整条就是玩家名的东西, 不翻
--   原先 isPlayerName **每一次调用**都要 `game:GetService("Players"):GetPlayers()` 再比人数;
--   而 isPlayerName 在 shouldTranslate 链里 —— 每扫一轮界面会被上百条文本各调一次,
--   等于每轮新建上百个玩家列表 table。改成"事件置脏 + 每 64 次调用兜底复查一次":
--   常规路径只剩 1 次哈希查表, GetPlayers() 调用量降到 1/64。
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
    -- ★ v114(审计修复 EV-01): 这条监听以前是裸 :Connect —— Players 服务永不销毁, 卸载/热重载后
    --   它会一直留着, 每重载一次再叠一条(白跑 + 连接数累积)。统一走 T() 登记进 SYS.Conns。
    --   注意 T 必须写在 pcall 内部: 直接 T(pcall(...)) 只会拿到 pcall 的第一个返回值(ok), 登记不上。
    T(game:GetService("Players").PlayerAdded:Connect(function() PlayerDirty=true task.defer(refreshPlayerNames) end))
    -- ★ v115(性能): 有人离开时也重算 —— 以前没有这条, 只能等"人数对不上"被动发现
    T(game:GetService("Players").PlayerRemoving:Connect(function() PlayerDirty=true task.defer(refreshPlayerNames) end))
end)
local function isPlayerName(s)
    if PlayerNameCount<0 or PlayerDirty then
        refreshPlayerNames()
    else
        -- 兜底: 事件万一没投递(执行器差异), 也不至于永远不更新
        PlayerCheckN=PlayerCheckN+1
        if PlayerCheckN>=PLAYER_CHECK_EVERY then
            PlayerCheckN=0
            if #game:GetService("Players"):GetPlayers()~=PlayerNameCount then refreshPlayerNames() end
        end
    end
    return PlayerNames[s:lower()]==true
end

-- 能不能翻: 只有这 6 条, 全是"确实没有可翻内容"的情况
function Trans.shouldTranslate(s,isChat)
    if type(s)~="string" then return false end
    if alreadyOurs(s) then return false end                      -- ① 我们自己产出过的译文
    s=(s:gsub("^%s+","")):gsub("%s+$","")
    if s=="" or #s<2 then return false end                       -- ② 空/太短
    if isPlayerName(s) then return false end                     -- ★ v85: 整条是玩家名/ID -> 不翻
    if hasChinese(s) then return false end                       -- ③ 含中文 -> 整条跳过
    if not hasForeign(s) then return false end                   -- ④ 没有外文
    if s:match("^https?://%S+$") or s:match("^www%.%S+$") then return false end   -- ⑤ 整条网址
    if not s:find("[%w]") and not hasKanaOrHangul(s) then return false end   -- ⑥ 纯符号/emoji(假名/谚文不算)
    if Trans.IsEmoticon(s) then return false end                 -- ⑦ 颜文字/表情(qaq/owo/owo/…)
    if Trans.KeepWords[s:lower()] then return false end          -- ⑧ 物品等级/稀有度分类词(OG/Secret/…)保留原样
    -- ⑨ ★★ 用户反馈「数字类文本一直被翻, 缓存疯涨」: 一个字母都没有的文本(纯数字/纯符号/纯日期)
    --    其实【没什么可翻的】, 以前照样发请求 + 进缓存 —— 而金币数 / 倒计时 / CPS 这类【每秒都在变】,
    --    每变一次就是【一次请求 + 一个新条目】-> 缓存和请求一直往上加。这里直接挡在源头。
    if not s:find("%a") then return false end                    -- ⑨ 纯数字/纯符号: 没有可翻的内容
    return true
end

-- ★★ v5.5.0(用户要求): ⑦ 颜文字不翻 ⑧ 物品等级/稀有度分类词保留原样。整串精确匹配, 不误伤正常单词。
local EMOTICONS="qaq|qwq|qoq|awa|owo|uwu|ovo|tvt|o_o|0_0|-_-|^_^|>_<|t_t|u_u|x_x|o3o|:3|:)|:(|:d|:p|xd|orz|otl|233|555|www|hhh|aaa"
Trans.IsEmoticon=function(v)
    if type(v)~="string" then return false end
    local t=v:lower():gsub("%s+","")
    if t=="" or #t>12 then return false end
    for w in EMOTICONS:gmatch("[^|]+") do if t==w then return true end end
    return false
end
local KEEPW="og|secret|mythic|legendary|epic|rare|uncommon|common|divine|celestial|exclusive|limited|godly|ultra|special|unique|hidden|ancient|eternal|transcendent|op"
Trans.KeepWords={}
for w in KEEPW:gmatch("[^|]+") do Trans.KeepWords[w]=true end


-- 文本(防重复请求 + 判定缓存)
Trans.Verdict={}
local VerdictN=0
local function verdictOf(raw,isChat)
    local key=(isChat and "c" or "u")..raw
    local v=Trans.Verdict[key]
    if v then return v end
    v={}
    local plain=stripRich(raw)
    local core=select(2,splitPrefix(plain))
    if core~="" then plain=stripRich(core) end
    if plain=="" then
        v.skip=true
    elseif hasChinese(plain) then
        -- ★ v92: 含汉字 -> 切分看是否有外文片段(混排); 没有才是纯中文(跳过)
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
    if VerdictN>=8000 then Trans.Verdict={} VerdictN=0 end
    Trans.Verdict[key]=v VerdictN=VerdictN+1
    return v
end
Trans.verdictOf=verdictOf

--============================================================
-- ★ v115(性能): 失败退避冷却 —— 以前【完全没有】重试节流
--   症状: 一条翻不出来的文本(服务器没开 / 质量门不过 / 模型抽风)会被 0.5 秒一轮的界面扫描
--   **无限重发**: 每轮 Cache 未命中 + 不在途 -> 立刻再发一次。服务器离线时等于每秒几百次
--   必然失败的请求, 白烧 CPU、白刷日志、把槽位全占住。
--   现在: 同一条文本失败后进入**指数退避**冷却(3s→6→12→24→48→96→192→300 封顶),
--   冷却期内直接跳过(不改变任何翻译结果), 到点**自动重试**。
--   ⚠️ 这是"退避", 不是"永久拉黑" —— "某些文本整局永不翻译"是另一个毛病, 绝不能引入。
--   ⚠️ 冷却用 os.clock(): 与模块里既有的计时口径一致, 仿真台也把它换成了虚拟时钟, 可测。
--============================================================
Trans.Fail={}
Trans.FailN=0
local FAIL_BASE,FAIL_CAP,FAIL_MAXN=3,300,4000
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
Trans.inCool=inCool
local function markFail(key)
    if not key or key=="" then return end
    local f=Trans.Fail[key]
    if f then f.n=f.n+1 f.t=os.clock() return end
    Trans.FailN=Trans.FailN+1
    if Trans.FailN>FAIL_MAXN then
        -- 只清"冷却已过"的, 保住仍在退避中的(否则等于把退避一起清没)
        local dead={} local now=os.clock()
        for k,g in pairs(Trans.Fail) do if (now-g.t)>=failCool(k) then dead[#dead+1]=k end end
        for i=1,#dead do Trans.Fail[dead[i]]=nil end
        Trans.FailN=0
    end
    Trans.Fail[key]={n=1,t=os.clock()}
end
local function clearFail(key) if key and Trans.Fail[key] then Trans.Fail[key]=nil end end
Trans.clearFail=clearFail
Trans.clearAllFails=function() Trans.Fail={} Trans.FailN=0 end
-- 服务器整体不可用时的全局闸门: 连续 3 次传输失败 -> 全体暂停 4 秒, 自动恢复(不是关掉功能)
local NetStreak,NetGateUntil=0,0
local function netGateOn() return os.clock()<NetGateUntil end
local function noteNetFail()
    NetStreak=NetStreak+1
    if NetStreak>=3 then NetGateUntil=os.clock()+4 end
end
local function noteNetOk() NetStreak=0 NetGateUntil=0 end
Trans.netGateOn=netGateOn

--============================================================
-- 缓存(内存 + 原子写盘 + .bak 回退)
--============================================================
local Cache={}
local MODEL_TAG="hymt2-7b-v70"      -- ★ 换版本号 -> 加载时自动丢弃全部旧缓存
local CFG="TransCache.json"
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
                markOutput(v)                 -- 磁盘里的译文也算"我们产出过的"
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
    Cache={} Trans.cacheCount=0 Trans.Verdict={} VerdictN=0
    Trans.Trans2Orig={} Trans.Outputs={} Trans.OutputsN=0
    Trans.clearAllFails()          -- ★ v115: 清缓存 = 连同失败冷却一起清, 让每条都能重新试
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

--============================================================
-- HTTP / 服务器(OpenAI 兼容)
--============================================================
-- ★ v90: 送模型前掩码(占位符/代码符号/富文本/货币/颜色/格式符), 译文回来再回填。
--   解决 7B 模型把 {coins}/%d/[E]/$1,000/50%/#FF0000/<b>/**code** 误译或破坏的问题。
local function maskSpecials(s)
    if type(s)~="string" or s=="" then return s,{},0 end
    local tok={} local n=0
    local function prot(pat)
        s=s:gsub(pat,function(m) n=n+1 tok[n]=m return "▮"..n.."▮" end)
    end
    prot("{{[^{}]-}}")            -- {{token}}
    prot("{[^{}]-}")              -- {coins} {0} {player}
    prot("%%[-+0-9%.]*[sdifgxXoc]") -- %d %s %2.1f %-3d %1$s
    prot("%%%w+%%")               -- %WORD% 占位
    prot("</?[%a!][^>]*>")        -- <b> </font> <font ..> <Key> <!x>
    prot("%[%/?%w+[^%]]*%]")      -- BBCode [b] [/b] [color=red] [size=5] [player]
    prot("%[%*%]")               -- [*] Markdown 无序列表项
    prot("`[^`]+`")               -- `code`
    prot("%*%*[^%*]+%*%*")        -- **bold**
    prot("%$%w+%$")               -- $WORD$ 占位
    prot("%$[%d%.,]+")            -- $1,000 货币
    prot("#%x%x%x%x%x%x")         -- #FF0000 颜色
    prot("[@#&!]%w+")             -- @player #player &player !player 前缀占位
    prot("%d+%.?%d*%%")           -- 50% 12.5%
    prot("%d+%.?%d*[eE][+-]?%d+")  -- 科学计数法 1e11 / 1.5e10
    prot("%d+%.?%d*[QSODNVT]%l")   -- 双字母单位 1Qa/1Qi/1Sx/1Sp/1Oc/1No/1Dc/1Vg/1Tg/1Qd/1Qg
    prot("%d+%.?%d*[KMBT]")        -- 单字母单位 1K/10M/1.5B/2T
    -- ★ v119(基准实测发现): 上面只覆盖到【双字母】单位,而这类大数字游戏的组合单位能到 3~4 个字母
    --   (1UDc / 1QaDc / 1TgDc …) -> 会漏给模型, 被翻成"1亿1千万"这种。这里补一条【数字+大小写混排字母】,
    --   要求首字母大写(所以 2nd / 3rd 这种小写序数词不会被误掩码)。
    prot("%d+%.?%d*%u%l?%u?%l?%u?%l?")
    prot("\\.")                   -- \n \t \\ \" \u 转义
    return s,tok,n
end
Trans.maskSpecials=maskSpecials
local function unmask(s,tok,n)
    if type(s)~="string" then return s end
    if tok and n and n>0 then
        s=s:gsub("▮%s*(%d+)%s*▮",function(d) local i=tonumber(d) return (i and tok[i]) or "" end)
    end
    s=s:gsub("▮[^▮]*▮",""):gsub("▮","")   -- 模型丢掉的哨兵 -> 清掉, 别露出来
    return s
end
Trans.unmask=unmask
local function rawRequest(body,system,temp,maxTok)
    if type(request)~="function" then return nil,true end
    local masked,tok,tokN=maskSpecials(body)
    local payload=HS:JSONEncode({
        model=MODEL,
        messages={ {role="system",content=system}, {role="user",content=masked} },
        temperature=temp or 0.1, top_p=0.9, max_tokens=maxTok or 512, stream=false,
    })
    local ok,res=pcall(function()
        return request({
            Url=HOST.."/v1/chat/completions", Method="POST",
            Headers={["Content-Type"]="application/json",["Authorization"]="Bearer "..KEY},
            Body=payload, Timeout=30,
        })
    end)
    if not ok or type(res)~="table" or not res.Body then
        Trans.Stats.netfail=Trans.Stats.netfail+1
        noteNetFail()          -- ★ v115(性能): 连续传输失败 -> 全局闸门 4s, 防"服务没开"时刷请求
        return nil,true
    end
    local okd,d=pcall(function() return HS:JSONDecode(res.Body) end)
    if not okd or type(d)~="table" then
        Trans.Stats.netfail=Trans.Stats.netfail+1
        noteNetFail()
        return nil,true
    end
    noteNetOk()                -- ★ v115(性能): 通了就清掉连败计数与全局闸门
    local ch=d.choices
    local c=type(ch)=="table" and ch[1]
    local m=c and c.message
    local v=m and m.content
    if type(v)~="string" then return nil,false end
    v=unmask(v,tok,tokN)
    v=(v:gsub("^%s+","")):gsub("%s+$","")
    if v=="" then return nil,false end
    return v,false
end

-- 极简质量门: 只有"空"和"原样返回(没翻出来)"算失败; 剥掉模型可能编出来的 <标签>
local function tidy(res,src)
    res=stripRich(res)
    res=(res:gsub("^%s+","")):gsub("%s+$","")
    if res=="" then return nil end
    if res==src and not hasChinese(src) then return nil end     -- 原样吐回来 = 没翻
    return res
end

function Trans.translate(text,prio)
    if Trans.Unloaded then return nil end
    if type(text)~="string" or text=="" then return nil end
    text=(text:gsub("^%s+","")):gsub("%s+$","")
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
    -- ★ v115(性能): 冷却 / 全局闸门内直接返回 —— 不改任何结果, 只是不再每轮重发同一必败请求
    if inCool(nk) or netGateOn() then return nil end
    local t0=os.clock()
    local res,netFail=rawRequest(text,SYS_PROMPT,0.1,Trans.maxTok or 512)
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
    markFail(nk)              -- ★ v115(性能): 翻不出来就退避(3s 起, 指数到 300s 封顶, 到点自动重试)
    if not netFail then Trans.Stats.fail=Trans.Stats.fail+1 end
    return nil
end

-- ★ v90: 反向翻译(中->外), 供「翻译后发送」用; 独立缓存避免与英->中缓存冲突
Trans.LANG_PROMPT={en="English",zh="Chinese",ja="Japanese",ko="Korean",th="Thai",ru="Russian",ar="Arabic"}
Trans.RvCache={} local RvN=0
function Trans.promptFor(code)
    local name=Trans.LANG_PROMPT[code] or Trans.langName(code)
    return ("You are a game-UI translation engine. Translate the user's text into %s.\n"
        .."Output ONLY the translation: no explanation, no quotes, no extra words, no added punctuation.\n"
        .."Preserve the original line breaks and the original number of lines.\n"
        .."Some characters in the input are opaque placeholder markers, not words. Copy every non-word marker character exactly as it appears, in its original position, together with the digits attached to it. Never translate, drop, replace, renumber, merge or reorder them.\n"
        .."Keep numbers, currency ($), emoji, URLs, placeholders and player names unchanged."):format(name)
end
function Trans.translateTo(text,code)
    if Trans.Unloaded or type(text)~="string" then return nil end
    text=(text:gsub("^%s+","")):gsub("%s+$","")
    if text=="" then return nil end
    local c=code or "en"
    if c=="zh" then return text end
    if type(request)~="function" or not HS then return nil end
    local key=c.."\1"..normalizeKey(text)
    local hit=Trans.RvCache[key]
    if hit then return hit end
    local res=rawRequest(text,Trans.promptFor(c),0.1,Trans.maxTok or 512)
    if not res then return nil end
    res=(res:gsub("^%s+","")):gsub("%s+$","")
    if res=="" or res==text then return nil end
    Trans.RvCache[key]=res
    RvN=RvN+1
    if RvN>2000 then Trans.RvCache={} RvN=0 end
    return res
end

-- ★ v85: 并发去重(模块化拆分的一半: 同文本只发一次, 其余等结果; 不做跨文本合批避免行错位)
local Inflight={}
function Trans.request(text,prio,cb)
    if Trans.Unloaded or type(text)~="string" or text=="" then
        if cb then pcall(cb,nil) end return
    end
    if alreadyOurs(text) or not Trans.shouldTranslate(text,false) then
        if cb then pcall(cb,nil) end return
    end
    local nk=normalizeKey(text)            -- ★ v115(性能): 只算一次(原来同一段里算了两次)
    local hit=Cache[text] or Cache[nk] or lookupLocal(text)
    if hit then
        Trans.Stats.hit=Trans.Stats.hit+1
        if cb then pcall(cb,hit) end
        return
    end
    local key=nk
    -- ★ v115(性能): 退避冷却内直接跳过 —— 不改结果, 只是不再每轮重发同一必败请求
    if inCool(key) or netGateOn() then
        if cb then pcall(cb,nil) end
        return
    end
    local q=Inflight[key]
    if q then
        if cb then q[#q+1]=cb end
        return
    end
    Inflight[key]={}
    task.spawn(function()
        local r=Trans.translate(text,prio)
        local q2=Inflight[key] Inflight[key]=nil
        if cb then pcall(cb,r) end
        if q2 then for _,f in ipairs(q2) do pcall(f,r) end end
    end)
end

--============================================================
-- 落文字: 写回控件 + 记录原文(按文本, 不按对象)
--============================================================
Trans.Trans2Orig={}     -- 译文(纯文本) -> 原文(纯文本)
Trans.Orig2Trans={}     -- 原文(纯文本) -> 译文(纯文本)
local T2O_N=0

local function remember(raw,newText,plain,newPlain)
    if newPlain=="" or plain=="" or newPlain==plain then return end
    if Trans.Trans2Orig[newPlain]==nil then
        Trans.Trans2Orig[newPlain]=plain
        T2O_N=T2O_N+1
        if T2O_N>2000 then Trans.Trans2Orig={} T2O_N=0 end
    end
    Trans.Orig2Trans[plain]=newPlain
    markOutput(newText)
end

local function writeProp(obj,field,raw,newText)
    if not obj or not obj.Parent then return false end
    local cur=obj[field]
    if cur~=raw then return false end
    local ok=pcall(function() obj[field]=newText end)
    if ok then
        Trans.Stats.replaced=Trans.Stats.replaced+1
        -- 引擎可能立刻回写 -> 复查两次
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

-- ★ v92: 混排片段翻译(中文保留, 只翻外文片段, 全部完成后一次性回填成全中文)
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


-- 命中忽略表: 控件自己 + 最多 3 层父级(任何一层名字命中就跳过)
--   ⚠️ 不做缓存: 每轮扫描只多 4 次属性读, 比后面那些字符串处理便宜得多; 缓存反而会在"换父级"后失真。
function Trans.isIgnored(obj)
    if not obj then return false end
    local o=obj
    for _=1,4 do                 -- 自己 + 3 层父级 = 最多 4 个
        if not o then break end
        local ok,n=pcall(function() return o.Name end)
        if ok and type(n)=="string" and Trans.IgnoreObjects[n] then return true end
        local okp,p=pcall(function() return o.Parent end)
        o=okp and p or nil
    end
    return false
end


-- ★★ 修「文本又变回英文」: 游戏会自己把 Text 写回原文 -> 给【游戏自己的】文本控件挂
--   GetPropertyChangedSignal("Text") 一改就重翻(复用 processLabel; 连接经 T(); 节流 0.1s + 重试≤5)
local TextHooked=setmetatable({},{__mode="k"})   -- 已挂钩子的控件(弱键: 控件销毁自动出表)
local TextRetry=setmetatable({},{__mode="k"})    -- 每控件的重试计数
local TextLastAt=setmetatable({},{__mode="k"})   -- 上次处理时间(节流用)
local TextHookedN=0
local TEXT_HOOK_MAX=1500     -- 挂钩数量上限(个别游戏 UI 上万, 防把连接数拉爆)
local TEXT_RETRY_MAX=5       -- 同一个控件最多替它重翻多少次
local TEXT_GAP=0.1           -- 节流: 0.1s 内的重复变更合并成一次

local function onTextChanged(obj)
    if Trans.Unloaded or not Trans.UIScanActive then return end
    local now=os.clock()
    local last=TextLastAt[obj]
    if last and now-last<TEXT_GAP then return end        -- 节流
    TextLastAt[obj]=now
    local n=(TextRetry[obj] or 0)+1
    TextRetry[obj]=n
    if n>TEXT_RETRY_MAX then return end                  -- 重试上限: 超过不再纠缠
      task.defer(function()
        if Trans.Unloaded or not Trans.UIScanActive then return end
        P(Trans.processLabel,obj,"ui")
    end)
end

function Trans.HookText(obj)
    if not obj then return false end
    if TextHooked[obj] then return true end
    if TextHookedN>=TEXT_HOOK_MAX then return false end
    -- ★ 性能(用户反馈"加载就卡顿"): 首次扫描会一次性遇到上千个文本控件, 全挂监听会有明显突发。
    --   这里【限速】: 每秒最多新挂 40 个(剩下的下一轮扫描继续挂), 摊平掉这波开销。
    local now=os.clock()
    if not SYS._hkT or now-SYS._hkT>=1 then SYS._hkT=now SYS._hkN=0 end
    SYS._hkN=(SYS._hkN or 0)+1
    if SYS._hkN>40 then return false end
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

-- 处理一个 TextLabel/TextButton
function Trans.processLabel(obj,source)
    if not obj or not obj.Parent or Trans.Unloaded then return end
    if Trans.isIgnored(obj) then return end        -- ★ 忽略控件表(自己 + 3 层父级)
    local ok,cur=pcall(function() return obj.Text end)
    if not ok or type(cur)~="string" or cur=="" then return end
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
        local newText=(plain==cur) and hit or plainReplace(cur,plain,hit)
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
        local newText=(plain==cur) and res or plainReplace(cur,plain,res)
        if writeProp(obj,"Text",cur,newText) then remember(cur,newText,plain,res) end
    end)
end

-- 处理一个 ProximityPrompt(它没有 .Text! 只有 ActionText / ObjectText)
Trans.PromptFields={"ActionText","ObjectText"}
-- ★ v114(审计修复 EV-02): 已挂钩子的 prompt 集合 —— 本代次私有 + 弱键(对象销毁自动出表, 不积压)。
--   以前用实例属性 __TransHook 代替它, 那个属性会跨脚本代次残留 -> 热重载后钩子挂不上。
local PromptHooked=setmetatable({},{__mode="k"})
local function processPrompt(p)
    if not p or not p.Parent or Trans.Unloaded or not Trans.UIScanActive then return end
    if Trans.isIgnored(p) then return end          -- ★ 忽略控件表(自己 + 3 层父级)
    -- ★ v85: 游戏会在鼠标靠近时把 ActionText 改回原文 -> 挂变更钩子, 被改回立刻再翻
    --   钩子里再进来时: 缓存必命中 -> writeProp(cur~=raw) 返回 false -> 不会死循环
    if not PromptHooked[p] then
        -- ★ v114(审计 ISSUE-02): 标记必须等【两条都挂上】之后才置位 —— 否则某次 Connect 抛错
        --   (执行器事件缺失 / 实例正在销毁) 会把 prompt 记成"已钩"却没有连接, 之后永不重试 = 静默失效。
        pcall(function()
            local okA,ca=pcall(function() return p:GetPropertyChangedSignal("ActionText"):Connect(function() task.defer(processPrompt,p) end) end)
            local okB,cb2=pcall(function() return p:GetPropertyChangedSignal("ObjectText"):Connect(function() task.defer(processPrompt,p) end) end)
            -- 两条都要登记: 世界里的 prompt 不会随卸载销毁, 不登记就会残留
            if okA and ca then T(ca) end
            if okB and cb2 then T(cb2) end
            if okA and okB then PromptHooked[p]=true end
        end)
    end
    for _,f in ipairs(Trans.PromptFields) do
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

--============================================================
-- 扫描(界面 + 世界 3D + Prompt)
--============================================================
-- ★ v115(性能): 把"是不是我们自己的界面"与"是不是官方顶栏"两次祖先遍历合并成一次。
--   原先 scanRoot 对每个 TextLabel/TextButton 先 isOwnUI(最多 10 层) 再 isOfficialTopbar(最多 12 层)
--   = 每个文本对象每轮最多 22 次父级跳转; 而这是每 0.5 秒一轮的扫描循环里最贵的单点。
--   合并后一次走完(≤12 层)同时得出两个结论, 语义完全不变:
--     · 自己的 UI 仍按"10 层以内到 SYS.ScreenGui"判定(超出 10 层不算, 与旧实现一致)
--     · 官方顶栏仍按"12 层以内祖先名字含 topbar"判定
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
                P(Trans.HookText,o)          -- ★ 挂 Text 变更钩子(游戏写回原文时立刻重翻)
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

-- 单个节点的分发(扫描与外部驱动共用)
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
    Trans.clearAllFails()          -- ★ v115: 用户要求"全都再试一次" -> 清空全部失败冷却
    local n=0
    n=scanRoot(SYS.PG,n)
    if SYS.CoreGui then n=scanRoot(SYS.CoreGui,n) end
    pcall(function() if gethui then n=scanRoot(gethui(),n) end end)
    pcall(function() n=scanRoot(WS,n) end)
    if Trans.ChatActive then pcall(Trans.scanChatOnce) end
    print("[Trans] 强制重扫: 覆盖 "..n.." 个文本对象")
    return n
end

-- 开关状态
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
            -- ★ v104 用户要求"冷却低点/翻译快点": 扫描间隔 1.0 -> 0.5 秒
            task.wait(0.5)
            if Trans.UIScanActive then
                local before=Trans.Stats.hit+Trans.Stats.replaced
                local n=0
                n=scanRoot(SYS.PG,n)
                if SYS.CoreGui then n=scanRoot(SYS.CoreGui,n) end
                pcall(function() if gethui then n=scanRoot(gethui(),n) end end)
                if n==0 and before==Trans.Stats.hit+Trans.Stats.replaced then
                    Trans.Stats.sweepSkip=Trans.Stats.sweepSkip+1
                    task.wait(1)      -- ★ v104 空转 2 -> 1 秒
                end
                -- 世界 3D 每 10 轮扫一次(整套 Workspace 遍历)
                Trans._w=(Trans._w or 0)+1
                if Trans._w%10==0 then pcall(function() scanRoot(WS,0) end) end
            end
        end
    end)
    -- ★ v115(性能): 这里原先还有第二条"每 20 秒扫一次 Workspace"的循环 ——
    --   而上面主循环里的 Trans._w%10 已经每 ~5 秒扫一次 WS, 20 秒那条**完全被覆盖**,
    --   等于白白多跑 25%~30% 的整棵 Workspace 遍历
    --   (GetDescendants 会把全场景实例列成一个表)。
    --   删掉它: WS 的兜底扫描仍由主循环负责, 行为不变。
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

--============================================================
-- 聊天
--============================================================
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
                    -- ★ v90: 译完立即重扫, 气泡马上变中文(不再等 1 秒)
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

--============================================================
-- 还原原文(按文本反查, 不依赖控件生命周期)
--============================================================
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
            for _,f in ipairs(Trans.PromptFields) do
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

-- 翻译对照表(诊断: 谁被翻成了什么)
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

--============================================================
-- 服务器探测 / 发送
--============================================================
function Trans.checkLocal()
    local ok,res=pcall(function()
        return request({Url=HOST.."/health",Method="GET",Timeout=10})
    end)
    if ok and type(res)=="table" and res.StatusCode==200 then return "online" end
    return "offline"
end
function Trans.probeServer()
    local ok,res=pcall(function() return request({Url=HOST.."/props",Method="GET",Timeout=10,
        Headers={["Authorization"]="Bearer "..KEY}}) end)
    if not ok or type(res)~="table" or not res.Body then return false end
    local okd,d=pcall(function() return HS:JSONDecode(res.Body) end)
    if not okd or type(d)~="table" then return false end
    local slots=tonumber(d.total_slots) or 8
    local ctx=tonumber(d.default_generation_settings and d.default_generation_settings.n_ctx) or 512
    Trans.maxTok=math.max(96,math.min(768,ctx-200))
    print(("[Trans] 服务器: %d 槽 × 每槽 %d ctx")
        :format(slots,ctx))
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
    text=(text:gsub("^%s+","")):gsub("%s+$","")
    local target=Trans.SendLang or "en"
    local final=text
    if target~="zh" and hasChinese(text) then
        -- ★ v90: 中->外(反向翻译), 修掉旧的 "not hasChinese -> 英译中" 方向错误
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
print("[Trans] ✅ 翻译模块 v70(重写版) 已加载, 缓存="..tostring(Trans.cacheCount).." 条")


-- [13] UI 工具  (现代化重写 · API 与旧版完全兼容)
--============================================================
--============================================================
-- [13] UI 工具 (v68 炫酷重写 · 玻璃拟态 + 霓虹渐变 + 流畅动画)
--  API 签名与旧版完全一致, 所有页面无需改动即可享受新视觉。
--============================================================
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
    glow=Color3.fromRGB(80,200,255), -- 霓虹发光
}
SYS.CY=CY

local UI={}
SYS.UI=UI
UI.Pages={}
UI.Defs={}

-- 统一缓动(带"回弹"的 Easing, 比 Quad 更有质感)
local function tw(o,t,props)
    P(function()
        TweenService:Create(o,TweenInfo.new(t or 0.18,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),props):Play()
    end)
end
UI.Tween=tw

-- 圆角
function UI.Round(o,r)
    local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=o return c
end

-- 描边(可选发光: trans 越小越"亮", 配合亮色即霓虹效果)
function UI.Stroke(o,col,t,trans)
    local s=Instance.new("UIStroke")
    s.Color=col or CY.line s.Thickness=t or 1 s.Transparency=trans or 0.6
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=o return s
end

-- 渐变
function UI.Grad(o,c1,c2,rot)
    local g=Instance.new("UIGradient")
    g.Color=ColorSequence.new(c1 or CY.card2,c2 or CY.card)
    g.Rotation=rot or 90 g.Parent=o return g
end

-- 霓虹渐变(青→紫→青 三色)
function UI.NeonGrad(o)
    local g=Instance.new("UIGradient")
    g.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(56,180,255)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(170,120,255)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(56,180,255)),
    })
    g.Parent=o return g
end

-- 阴影(一层深色描边 + 一层发光描边, 模拟立体+霓虹)
function UI.Shadow(o)
    local s=Instance.new("UIStroke")
    s.Color=CY.dark s.Thickness=3 s.Transparency=0.5
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=o
    return s
end

-- 悬停反馈
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

-- 分组标题: 霓虹色条 + 标题 + 右侧细分隔线(带淡入动画)
function UI.Section(parent,title,col)
    local row=Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,30) row.BackgroundTransparency=1 row.Parent=parent
    local bar=Instance.new("Frame")
    bar.Size=UDim2.new(0,4,0,16) bar.Position=UDim2.new(0,0,0.5,-8)
    bar.BackgroundColor3=col or CY.accent bar.BorderSizePixel=0 bar.Parent=row
    UI.Round(bar,2)
    -- 霓虹发光: 色条上加一层渐变
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

-- 卡片容器(玻璃拟态: 半透明 + 渐变 + 细边框)
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

-- 小提示文字
function UI.Tip(parent,text,col)
    local l=Instance.new("TextLabel")
    l.Size=UDim2.new(1,0,0,30) l.BackgroundTransparency=1
    l.Text=text or "" l.TextColor3=col or CY.sub
    l.Font=Enum.Font.GothamMedium l.TextSize=11
    l.TextXAlignment=Enum.TextXAlignment.Left l.TextWrapped=true l.Parent=parent
    return l
end

-- 状态行: 左标签 + 右数值
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

-- 按钮(渐变底 + 悬停发光 + 按下微缩)
function UI.Btn(parent,text,col,fn)
    local b=Instance.new("TextButton")
    local BH=_TOUCH and 46 or 40          -- ★ v4.5.0 触摸设备加高(手指比鼠标粗, 缩放后更难点准)
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

-- 开关(霓虹: 开=绿光 关=灰; knob 带发光描边 + 滑动动画)
function UI.Switch(parent,label,key,onChange)
    if not parent then return end
    local row=Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,_TOUCH and 50 or 44) row.BackgroundColor3=CY.card   -- ★ v4.5.0 触摸加高
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
    -- ★ 第1轮审查修「双触发 bug」: 只保留 sw.MouseButton1Click 单一触发源
    --   (原 row.InputBegan 会因点击冒泡导致一次点击 toggle 两次抵消)
    T(sw.MouseButton1Click:Connect(function()
        SYS.T_[key]=not SYS.T_[key] refresh(true) QueueSave()
        if onChange then P(onChange,SYS.T_[key]) end
    end))
    SYS.BtnRefs[#SYS.BtnRefs+1]=function() refresh(false) end
    return row
end

-- 滑杆(渐变填充 + 发光 knob + 拖动)
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

    local dragging=false
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
    T(bar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
            or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true proc(input)
            tw(knob,0.1,{Size=UDim2.new(0,18,0,18),Position=UDim2.new(knob.Position.X.Scale,-9,0.5,-9)})
        end
    end))
    T(UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement
            or input.UserInputType==Enum.UserInputType.Touch) then proc(input) end
    end))
    T(UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1
            or input.UserInputType==Enum.UserInputType.Touch then
            dragging=false
            tw(knob,0.1,{Size=UDim2.new(0,14,0,14),Position=UDim2.new(knob.Position.X.Scale,-7,0.5,-7)})
        end
    end))
    UI.Hover(row,CY.card2,CY.card)
    SYS.BtnRefs[#SYS.BtnRefs+1]=refresh
    return row
end

-- 循环选择
-- ★ v102 移植: 文本输入框(配置管理/热键设置用)
function UI.Input(parent,label,placeholder,get,set)
    local row=Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,_TOUCH and 50 or 44) row.BackgroundColor3=CY.card   -- ★ v4.5.0 触摸加高
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
    row.Size=UDim2.new(1,0,0,_TOUCH and 50 or 44) row.BackgroundColor3=CY.card   -- ★ v4.5.0 触摸加高
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
    -- ★ v71 修「点一次却跳好几格」:
    --   ① 旧版把当前索引缓存在局部 idx 里。一旦配置被别处改写(例如极速模式会重置
    --      CB_Priority 并刷新按钮文字), idx 就和真实值脱钩 —— 之后每点一次都从错的基准往前跳,
    --      看起来就是"一次跳了好几格"。现在每次都从 get() 现算当前索引, 只认配置这一个依据。
    --   ② 加 250ms 同按钮去重: 输 入层把一次点击报成两次时也不会跳两格。
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

-- 下拉选择(opts 可为函数: 每次展开现算)
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
        panel.Position=UDim2.fromOffset(ap.X,ap.Y+asz.Y+4)
        panel.Size=UDim2.fromOffset(asz.X,math.min(#list,9)*30+10)
        panel.CanvasSize=UDim2.fromOffset(0,#list*30+10)
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
        -- ★ v68.8 修"下拉浮层残留": 同屏只留一个浮层 + 记录引用, 切页/关菜单时统一关闭
        if SYS.CloseActiveDropdown and SYS.CloseActiveDropdown~=close then
            pcall(SYS.CloseActiveDropdown)
        end
        SYS.CloseActiveDropdown=close
    end))
    return btn
end

-- [13.5] 游戏内通知 (参考 WindUI Notification 补齐)
--   所有"print"反馈在游戏里看不到(要开执行器控制台), 补一个右上角通知 toast:
--   3 秒自动消失、多条向下堆叠、自动上移/回落。
--============================================================
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

--============================================================
--============================================================
-- [12B] v6.7.0 ChronixHub 融合模块（逻辑层 · 全部可逆 · 只写本客户端）
--   滤镜控制器 / 光照档位包 / 音频控制器+检查器 / 聊天接收器 / 多路径点 /
--   自杀与角色状态(防死亡·防击倒 并入上帝模式) / 瞄准补强 + 白黑名单 /
--   静默瞄准·子弹穿墙·阻挡射线(默认关) / 防护(反作弊绕过·管理员检测·防踢出) /
--   玩家控制(动手类) / 整蛊工具 / 工具增删
--
--   ⚠ 本块内【不引用 UI.*】—— 本块是纯逻辑层, 界面一律在页面函数里做。
--     (位置在 [13] UI 库之后、[14] UI 页面之前, 这样不落入「翻译模块体量锁」的计量区间)
--
--   技术来源(2026-09 复核 · 均为近 2 个月内更新的开源实现):
--     · Windows81/Personal-Roblox-Client-Scripts  anti-kick.lua
--       → hookfunction(Player.Kick / Player.Destroy) + hookmetamethod(game,"__namecall")
--         过滤 kick/destroy, 并用 getcallingscript 记下"谁踢的"
--     · Direnta/RBLXAntiKick
--       → getrawmetatable(game) 替换 __namecall, 命中 Kick 直接丢弃调用
--     · CF-Trail/random utilLoader(anti-kick.lua 出处)
--       → Adonis 识别特征: ReplicatedStorage 下带 __FUNCTION RemoteFunction 的 RemoteEvent
--     · Roblox DevForum「如何做有效的反作弊」线程
--       → 反制面: __namecall 完整性校验 / 蜜罐对象 / debug.info 调用栈 —— 我们只做"不中招", 不主动伪造
--============================================================
do
    local function Svc(n) local ok,v=pcall(function() return game:GetService(n) end) return ok and v or nil end
    local SoundService=Svc("SoundService")
    local UserGS=Svc("UserSettings")

    --=========== 通用: 动态列表里的小控件 ===========
    --  ⚠ 这些按钮的点击连接【不进 SYS.Conns】—— 行销毁时连接随之失效, 不会越积越多。
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

    -- 动态列表容器(统一外观)
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

    --============================================================
    -- A1) 滤镜控制器
    --============================================================
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
            x.Name="CheatMenu_FX" x.Saturation=0 x.Brightness=0 x.Contrast=0
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

    --============================================================
    -- A5) 光照档位包(夜视 / 随身灯笼 / 超级光明 / 禁雾 / 禁阴影)
    --   唯一实现: 所有开关都只改"意图", 由 ReapplyLight() 统一算出最终状态。
    --============================================================
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

    function SYS.ReapplyLight()
        if not LT then return end
        local ex=ltExtra()
        local nv=SYS.T_.NightVision==true
        local nvp=SYS.T_.NightVisionPro==true
        local sl=SYS.T_.SuperLight==true
        local nf=SYS.T_.NoFog==true
        local ns=SYS.T_.NoShadow==true
        local O=SYS.Orig
        P(function()
            if sl or nvp then
                LT.Brightness=3
                LT.Ambient=Color3.new(1,1,1)
                LT.OutdoorAmbient=Color3.new(1,1,1)
                LT.ClockTime=12
            elseif nv then
                LT.Brightness=2
                LT.Ambient=Color3.fromRGB(120,120,120)
                LT.OutdoorAmbient=Color3.fromRGB(120,120,120)
                LT.ClockTime=O.ClockTime
            else
                LT.Brightness=O.Brightness
                LT.Ambient=O.Ambient
                LT.OutdoorAmbient=O.OutdoorAmbient
                LT.ClockTime=O.ClockTime
            end
            LT.GlobalShadows=(not ns) and (ex.GS~=false) and true or false
            if nf then
                LT.FogEnd=1e6 LT.FogStart=1e6
            else
                LT.FogEnd=O.FogEnd LT.FogColor=O.FogColor
                LT.FogStart=(ex.FS~=nil) and ex.FS or LT.FogStart
            end
        end)
        -- 随身灯笼(挂在角色根部件上的 PointLight, 只在本地可见)
        P(function()
            if SYS.T_.Lantern==true then
                local ch=LP.Character
                local root=ch and ch:FindFirstChild("HumanoidRootPart")
                if root and not (LanternLight and LanternLight.Parent==root) then
                    if LanternLight and LanternLight.Parent then LanternLight:Destroy() end
                    local pl=Instance.new("PointLight")
                    pl.Name="CheatMenu_Lantern" pl.Brightness=3 pl.Range=60
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

    --============================================================
    -- A3/A4) 音频控制器 + 音频检查器
    --============================================================
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

    --============================================================
    -- A2) 聊天接收器
    --============================================================
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

    --============================================================
    -- A6) 多路径点系统
    --============================================================
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
            p.Name="CheatMenu_WP"..tostring(i) p.Anchored=true p.CanCollide=false
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

    -- 缓动到目标点(自己实现, 不依赖外部)
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

    -- 步行到目标点(交给 Humanoid:MoveTo, 最"干净"但会撞墙)
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

    --============================================================
    -- A26/A28) 强制自杀 / 防死亡 / 防击倒 / 重生点记账
    --============================================================
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

    -- 重生点记账(纯本地: 决定本地 RespawnLocation)
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

    --============================================================
    -- A31) 白名单 / 黑名单
    --============================================================
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
    -- 选人闸门: 黑名单直接否; 白名单非空时只放行白名单里的人
    function WL.Allow(name)
        name=tostring(name or "")
        if WL.Black[name] then return false end
        local hasWL=false
        for _ in pairs(WL.White) do hasWL=true break end
        if hasWL and not WL.White[name] then return false end
        return true
    end

    --============================================================
    -- A32) 瞄准补强闸门(粘性 / 命中率 / 漏打)
    --   ⚠ 不重写战斗核心: aimTick/fireTick 每帧现读这些闸门, 关掉即恢复原样。
    --============================================================
    local Aim={} SYS.AimEx=Aim
    -- 注: 「锁定保持 / 粘性瞄准」用户早前明确要求删除, check.py 里带回归锁 -> 不提供。

    -- 命中率: 100 = 每帧都瞄; 越低越"手抖"
    function Aim.HitGate()
        local r=tonumber(SYS.C_.CB_HitRate)
        if not r or r>=100 then return true end
        if r<=0 then return false end
        return (math.random()*100)<=r
    end

    -- 漏打: 开火前按概率跳过(制造"打偏"观感)
    function Aim.MissGate()
        if SYS.T_.CB_MissMode~=true then return true end
        local r=tonumber(SYS.C_.CB_MissRate) or 0
        if r<=0 then return true end
        return (math.random()*100)>r
    end

    --============================================================
    -- A33) 防护: 反作弊绕过 / 管理员检测绕过 / 防踢出 / 隐藏自身 GUI
    --   技术来源见文件头注释(Windows81 anti-kick / Direnta RBLXAntiKick / CF-Trail utilLoader)
    --   ⚠ 全部走能力探测: 执行器没有 hookmetamethod/hookfunction 就明确提示"本机不支持", 不静默失败。
    --============================================================
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

    -- 谁在踢我们(拿调用脚本名, 拿不到就写未知)
    local function callerName()
        if type(getcallingscript)~="function" then return "未知来源" end
        local ok,s=pcall(getcallingscript)
        if ok and s then
            local ok2,n=pcall(function() return s:GetFullName() end)
            if ok2 and n then return tostring(n) end
        end
        return "未知来源"
    end

    -- 识别常见的 Adonis 结构(CF-Trail utilLoader 的做法: 带 __FUNCTION 的 RemoteFunction)
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

    -- 安装"踢人/抹除"拦截
    function Prot.InstallKickGuard()
        local c=Prot.Caps()
        if not c.ok then return false,"这台执行器没有 hookmetamethod/newcclosure" end
        if Prot.Hooks.kick then return true end
        local ok,err=pcall(function()
            -- ① __namecall 过滤: self==自己 且方法名为 kick/destroy -> 直接吞掉
            if c.hmm and c.gnm then
                local h=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
                    if checkcaller and checkcaller() then return h(self,...) end
                    local m=getnamecallmethod()
                    if m then
                        local lm=string.lower(tostring(m))
                        if (lm=="kick" or lm=="kickplayer" or lm=="destroy") and self==LP then
                            Prot.Blocked=Prot.Blocked+1
                            Prot.LastFrom=callerName()
                            print(("[CheatMenu] 🛡 已拦截 %s (来源: %s) 第 %d 次")
                                :format(lm,Prot.LastFrom,Prot.Blocked))
                            return
                        end
                    end
                    return h(self,...)
                end))
                Prot.Unhook.namecall=h
            end
            -- ② 直接替换 LocalPlayer.Kick / Destroy(老式客户端自踢)
            if c.hf then
                local okK,oldK=pcall(function() return hookfunction(LP.Kick,newcclosure(function() end)) end)
                if okK then Prot.Unhook.kick=oldK end
                local okD,oldD=pcall(function() return hookfunction(LP.Destroy,newcclosure(function() end)) end)
                if okD then Prot.Unhook.destroy=oldD end
            end
        end)
        if not ok then return false,tostring(err) end
        Prot.Hooks.kick=true
        return true
    end

    function Prot.RemoveKickGuard()
        if not Prot.Hooks.kick then return end
        local c=Prot.Caps()
        if c.hmm and Prot.Unhook.namecall then
            P(function() hookmetamethod(game,"__namecall",Prot.Unhook.namecall) end)
        end
        if c.hf then
            if Prot.Unhook.kick then P(function() hookfunction(LP.Kick,Prot.Unhook.kick) end) end
            if Prot.Unhook.destroy then P(function() hookfunction(LP.Destroy,Prot.Unhook.destroy) end) end
        end
        Prot.Unhook={} Prot.Hooks.kick=nil
    end

    -- 拦截传送(防止被换服/换游戏)
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
                    local ok2,old=pcall(function()
                        return hookfunction(f,newcclosure(function(...)
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

    -- 隐藏自身 GUI(管理员/反作弊脚本常扫 CoreGui 找外挂界面)
    function Prot.InstallHideGui()
        local c=Prot.Caps()
        if not c.hmm then return false,"这台执行器没有 hookmetamethod" end
        if Prot.Hooks.hide then return true end
        local ok,err=pcall(function()
            local h=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
                if checkcaller and checkcaller() then return h(self,...) end
                local m=getnamecallmethod()
                if m then
                    local lm=string.lower(tostring(m))
                    if (lm=="getchildren" or lm=="getdescendants" or lm=="findfirstchild"
                        or lm=="findfirstchildofclass")
                        and (self==SYS.CoreGui or self==LP:FindFirstChildOfClass("PlayerGui")) then
                        local res=h(self,...)
                        local hideName=function(o)
                            if not o then return false end
                            if o==SYS.ScreenGui or o==SYS.FloatGui then return true end
                            local nm=tostring(o.Name or "")
                            return nm==tostring(SYS.ScreenGui and SYS.ScreenGui.Name or "\1")
                                or nm==tostring(SYS.FloatGui and SYS.FloatGui.Name or "\2")
                        end
                        if lm=="getchildren" or lm=="getdescendants" then
                            if type(res)=="table" then
                                local out={}
                                for i=1,#res do
                                    if not hideName(res[i]) then out[#out+1]=res[i] end
                                end
                                return out
                            end
                        else
                            if hideName(res) then return nil end
                        end
                        return res
                    end
                end
                return h(self,...)
            end))
            Prot.Unhook.hide=h
        end)
        if not ok then return false,tostring(err) end
        Prot.Hooks.hide=true
        return true
    end

    function Prot.RemoveHideGui()
        if not Prot.Hooks.hide then return end
        local c=Prot.Caps()
        if c.hmm and Prot.Unhook.hide then
            P(function() hookmetamethod(game,"__namecall",Prot.Unhook.hide) end)
        end
        Prot.Unhook.hide=nil Prot.Hooks.hide=nil
    end

    --=========== 静默瞄准 / 子弹穿墙 / 阻挡射线 (默认关) ===========
    --   三者共用一条 Workspace 射线 hook:
    --     · 阻挡射线   = 让游戏自己的射线一律"打空"(返回 nil) —— 游戏用它做视线/检测时看不到任何东西
    --     · 静默瞄准   = 把游戏射线的命中点改写成当前锁定目标
    --     · 子弹穿墙   = 同上, 但不要求视线(隔墙也改写)
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
            local h=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
                local m=getnamecallmethod()
                if m and self==WS then
                    local lm=string.lower(tostring(m))
                    if lm=="raycast" then
                        -- 阻挡射线: 直接返回"什么都没打到"
                        if SYS.T_.CB_BlockRay==true then
                            Ray.Rewrites=Ray.Rewrites+1
                            return nil
                        end
                        local res=h(self,...)
                        if SYS.T_.CB_SilentAim==true or SYS.T_.CB_BulletWall==true then
                            local tp=Ray.Target()
                            if tp then
                                Ray.Rewrites=Ray.Rewrites+1
                                return {Instance=tp,Position=tp.Position,Normal=Vector3.new(0,1,0)}
                            end
                        end
                        return res
                    elseif lm=="findpartonray" or lm=="findpartonraywithignorelist"
                        or lm=="findpartonraywithwhitelist" then
                        if SYS.T_.CB_BlockRay==true then
                            Ray.Rewrites=Ray.Rewrites+1
                            return nil,nil
                        end
                        local a,b=h(self,...)
                        if SYS.T_.CB_SilentAim==true or SYS.T_.CB_BulletWall==true then
                            local tp=Ray.Target()
                            if tp then
                                Ray.Rewrites=Ray.Rewrites+1
                                return tp,tp.Position
                            end
                        end
                        return a,b
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

    --============================================================
    -- A34) 工具增删
    --============================================================
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

    --============================================================
    -- B8) 玩家控制(动手类) —— 全部只写【本地副本】, 服务端不认可(见界面提示)
    --============================================================
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

    -- 语音静音: 客户端【没有】静音别人语音的公开 API -> 退化成"静音他角色里的所有 Sound"(本地)
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

    --============================================================
    -- B9) 整蛊工具(全部只动本地副本 —— 对方看不到, 服务端不认可)
    --============================================================
    local PG={} SYS.PG=PG

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

    function PG.SpinHit(on)   -- 旋转击飞: 边转边给速度
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

    function PG.FlyHit(on)    -- 飞行击飞
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

    function PG.WalkHit(on)   -- 走路击飞(靠近谁谁被击飞)
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

    function PG.HideHit(on)   -- 隐身击飞: 自己透明 + 靠近就击飞
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

    -- 环绕工具: 让自己手里的 Tool 绕自己转 / 附着到别人身上
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

    -- 黑洞: 把自己附近的可移动部件往中心吸(含别人角色)
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

    --============================================================
    -- 统一卸载(由 SYS.UnloadAll 调用)
    --============================================================
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
-- [14] UI 页面
--============================================================
-- ★ v6.7.0 页面按「用途域」重排: 打人类(战斗/玩家/整蛊) → 自身与世界(移动/视觉/功能) → 位置与挂机 → 游戏专用 → 文本 → 设置
--   共 11 页: 侧栏 y = 7 + 11*46 = 513, 底部搜索框在 546 —— 仍留 33px 余量, 不会撞。
UI.Defs={
    {name="战斗",icon="⚔"},{name="玩家",icon="👤"},{name="整蛊",icon="😈"},{name="移动",icon="◈"},{name="视觉",icon="◉"},{name="功能",icon="✱"},
    {name="传送",icon="➲"},{name="挂机",icon="★"},{name="MachineParty",icon="🎮"},{name="翻译",icon="🌐"},{name="设置",icon="⚙"},
}

UI.Pages["移动"]=function(p)
    UI.Switch(p,"飞行 (Fly)","Fly",function(on)
        if not on then SYS.CleanFly() end
        SYS.SetLoop("Fly",on,SYS.PhysicsStep,SYS.FlyTick)
    end)
    UI.Slider(p,"飞行速度倍率",0,20,0.5,function() return SYS.C_.FlySpeed end,function(v) SYS.C_.FlySpeed=v end)
    UI.Cycle(p,"飞行模式",{"Align","BodyVelocity","CFrame"},
        function() return SYS.C_.FlyMode end,
        function(v) SYS.C_.FlyMode=v if SYS.T_.Fly then SYS.CleanFly() end end)
    UI.Tip(p,"★ 默认「Align」= 官方推荐的 LinearVelocity + AlignOrientation, 也最不容易被服务器拉回。\n「BodyVelocity」= 老执行器(已弃用), 兼容用。\n「CFrame」= 逐帧瞬移, **会被服务端位置校验拉回**, 不推荐。\n另外: 新版本开飞行时不再把世界重力清零(那正是被拉回的经典原因), 只对角色自身抵消重力。",CY.yellow)
    UI.Div(p)
    UI.Switch(p,"加速 (Speed)","Speed",function(on)
        if not on then SYS.CleanSpeed() end
        SYS.SetLoop("Speed",on,SYS.PhysicsStep,SYS.SpeedTick)
    end)
    UI.Slider(p,"移动速度倍率",0,20,0.5,function() return SYS.C_.SpeedMult end,function(v) SYS.C_.SpeedMult=v end)
    -- ★ v123: 默认改用官方推荐的 LinearVelocity(旧的 BodyVelocity 已弃用, 降级为兼容选项);
    --   并给倍率加风险提示 —— 服务端按【位移 vs 正常速度 ×2】容差判定, 倍率超过 2 就会被记一笔。
    UI.Cycle(p,"加速模式",{"Linear","BodyVelocity","WalkSpeed"},
        function() return SYS.C_.SpeedMode end,
        function(v) SYS.C_.SpeedMode=v if SYS.T_.Speed then SYS.CleanSpeed() end end)
    UI.Tip(p,"默认「Linear」= 官方推荐的 LinearVelocity(旧 BodyVelocity 已弃用, 保留兼容)。\n「WalkSpeed」= 只改走路速度, 最朴素也最稳。\n⚠️ 倍率建议 ≤ 2: 服务端按【每 tick 位移 > 正常速度 ×2】判定加速作弊, 调太高会被记一笔。",CY.yellow)
    UI.Div(p)
    UI.Switch(p,"穿墙 (Noclip)","Noclip",SYS.SetNoclip)
    UI.Switch(p,"🛡 反陷阱免伤 (地图道具/生物/陷阱都免)","TrapImmune",SYS.SetTrapImmune)
    UI.Tip(p,"★ 完全豁免: 被撞/被弹开/被推走的位移 · 定身(走不动) · 布娃娃倒地 · 被坐骑锁住 · 被焊接钉住 · 客户端结算的伤害(掉血立刻补回)。\n★ 免不了: 服务端结算的伤害 —— 服务端是权威, 它扣的血客户端改不动。\n★ 滚石: 被撞后【水平速度清零 + 被拉走就渐进压回撞击点】, 所以不弹开、不被压着推走。\n★ 与「上帝模式」同开时会互相让位(不抢同一个状态)。",CY.yellow)
    UI.Switch(p,"无限跳跃","InfiniteJump",SYS.SetInfiniteJump)
    UI.Switch(p,"⤴ 超级跳跃 (跳得更高)","JumpBoost",SYS.SetJumpBoost)
    UI.Slider(p,"跳跃高度倍率",1,10,0.5,function() return SYS.C_.JumpMult end,
        function(v)
            SYS.C_.JumpMult=v
            -- 开着的时候拖滑条 -> 关再开, 立刻按新倍率重应用
            if SYS.T_.JumpBoost then P(SYS.SetJumpBoost,false) P(SYS.SetJumpBoost,true) end
        end,"x%.1f")
    --================ ★ v6.6.0 数值锁定 (融合自 ChronixHub 基础设置页) ================
    UI.Div(p)
    UI.Switch(p,"🔒 锁定移速 (被改回去就抢回来)","LockSpeed",SYS.SetLocks)
    UI.Switch(p,"🔒 锁定跳跃 (跳跃力/高度都锁)","LockJump",SYS.SetLocks)
    UI.Switch(p,"🔒 锁定世界重力","LockGravity",SYS.SetLocks)
    UI.Slider(p,"世界重力",0,500,5,function() return SYS.C_.Gravity or 196.2 end,
        function(v) SYS.C_.Gravity=v if SYS.T_.LockGravity then P(function() WS.Gravity=v end) end end,"%.0f")
    UI.Tip(p,"「锁定」= 持续把数值抢回来。很多游戏的脚本每帧把移速/跳跃改回默认值, 于是「滑块拖了过一会儿自己变回去」 —— 开锁就稳住。\n★ 锁移速的目标会跟着上面的「移动速度倍率」走(开着加速时锁的是加速后的值), 两者不打架。\n★ 世界重力 196 = 原版; 调大更沉(掉得快), 调小更飘(跳得远)。\n★ 只写你自己和本地 Workspace, 卸载时自动还原(重力随已有逻辑恢复原值)。",CY.sub)
end

UI.Pages["视觉"]=function(p)
    UI.Switch(p,"玩家透视 (ESP)","ESP",function(on)
        if not on and not SYS.T_.ESPNameTag and not SYS.T_.ESPItem and not SYS.T_.ESP_NPC then SYS.ClearESP() end
    end)
    UI.Switch(p,"玩家名字","ESPNameTag",function(on)
        if not on and not SYS.T_.ESP and not SYS.T_.ESPItem and not SYS.T_.ESP_NPC then SYS.ClearESP() end
    end)
    -- ★ v3.9.0 新增: 掉落物透视(与人物透视同款 Highlight, 金色区分)
    UI.Switch(p,"👹 怪物/NPC 透视 (不属于玩家的怪也高亮, 橙色)","ESP_NPC",function(on)
        if not on and not SYS.T_.ESP and not SYS.T_.ESPNameTag and not SYS.T_.ESPItem and not SYS.T_.ESPWeapon and not SYS.T_.ESP_Pick then SYS.ClearESP() end
    end)
    UI.Tip(p,"把地图里【不属于任何玩家】但带 Humanoid 的模型(怪物/NPC/假人)用【橙色】高亮, 与玩家(队友绿·敌人红)区分。\n全 Workspace 扫描已节流(约每 0.5s 重扫一次), 不影响帧率; 隔墙时填充更透。",CY.sub)
    UI.Switch(p,"掉落物透视","ESPItem",function(on)
        if not on and not SYS.T_.ESP and not SYS.T_.ESPNameTag and not SYS.T_.ESPWeapon and not SYS.T_.ESP_NPC then SYS.ClearESP() end
    end)
    -- ★ v3.10.3 头顶武器标记(检查背包物品栏+手上是否有武器, 有就在头顶标红武器名)
    UI.Switch(p,"🖐 可交互道具透视 (点击/按E/能拿的东西, 青色)","ESP_Pick",function(on)
        if not on and not SYS.T_.ESP and not SYS.T_.ESPNameTag and not SYS.T_.ESPItem
           and not SYS.T_.ESPWeapon and not SYS.T_.ESP_NPC then SYS.ClearESP() end
    end)
    UI.Slider(p,"🖐 可交互道具探测距离 (格)",200,5000,100,function() return SYS.C_.PickDist or 1200 end,function(v) SYS.C_.PickDist=v end,"%.0f")
    UI.Tip(p,"按【结构】找, 不看名字: 带 ClickDetector(点击拾取) / ProximityPrompt(按 E) 的部件与模型, 以及 Tool 本身。\n所以名字里没有 item/drop 的道具也照样点亮(这是它和上面「掉落物透视」的区别)。\n青色高亮; 只点亮 600 格内的(免得整张图都是框); 扫描已节流。",CY.sub)
    UI.Switch(p,"🚪 门/陷阱/切割 透视 (陷阱·伤害机关=黄, 切割类=品红)","ESP_Door",function(on)
        if not on and not SYS.T_.ESP and not SYS.T_.ESPNameTag and not SYS.T_.ESPItem
           and not SYS.T_.ESPWeapon and not SYS.T_.ESP_NPC and not SYS.T_.ESP_Pick then SYS.ClearESP() end
    end)
    UI.Tip(p,"判据: 名字含 door/gate/trap/hazard/damage/lava/spike/pit/… 或中文 门/陷阱/机关/刺/熔岩/伤害/危险;\n结构上带 HingeConstraint / Motor6D(会转的门)。\n⚠️ 【碰了会不会掉血】客户端看不出来(伤害在服务端结算) -> 这条只能按名字给提示, 会有误报。\n探测距离用上面那个「可交互道具探测距离」滑块。",CY.sub)
    -- ★★ 融合自 ChronixHub 的 FootstepHighlighter: 在每个人【脚下】放一个光圈标记,
    --   一眼看出"谁站哪 / 往哪走"。比它那版轻: 只用一块 Neon 薄片(不用 Model+Billboard+光柱),
    --   扫描节流(0.2s), 关闭即清空, 连接经 T() 卸载即断。
    local FSMark={} SYS._fsN=0
    function SYS.SetFootstep(on)
        if not on then
            for _,m in pairs(FSMark) do P(function() m:Destroy() end) end
            FSMark={} SYS.Notify("👣 落脚点指示 已关闭",SYS.CY.sub) return
        end
        SYS.TT(task.spawn(function()
            while SYS.T_.FootstepESP and not SYS.Unloaded do
                local act={}
                P(function()
                    for _,pl in ipairs(Players:GetPlayers()) do
                        if pl~=LP then
                            local ch=pl.Character
                            local root=ch and ch:FindFirstChild("HumanoidRootPart")
                            if root then
                                -- 从脚下向下打一条线, 找到"他站在哪个面上"
                                local hit=select(1,WS:FindPartOnRayWithIgnoreList(Ray.new(root.Position,Vector3.new(0,-12,0)),{ch}))
                                local pos=(hit and hit.Position) or (root.Position+Vector3.new(0,-3,0))
                                act[root]=pos
                            end
                        end
                    end
                end)
                for k,m in pairs(FSMark) do
                    if not act[k] then P(function() m:Destroy() end) FSMark[k]=nil end
                end
                for root,pos in pairs(act) do
                    local m=FSMark[root]
                    if not m then
                        local ok,pt=P(function()
                            local q=Instance.new("Part")
                            q.Shape=Enum.PartType.Cylinder
                            q.Size=Vector3.new(0.08,3.2,3.2)
                            q.Anchored=true q.CanCollide=false q.CastShadow=false
                            q.CanQuery=false q.CanTouch=false q.Archivable=false
                            q.Material=Enum.Material.Neon q.Transparency=0.55
                            q.Color=Color3.fromRGB(255,80,80)
                            q.Parent=WS
                            return q
                        end)
                        if ok and pt then m=pt FSMark[root]=m end
                    end
                    if m then P(function() m.CFrame=CFrame.new(pos)*CFrame.Angles(0,0,math.rad(90)) end) end
                end
                task.wait(0.2)
            end
        end))
        SYS.Notify("👣 落脚点指示 已开启",SYS.CY.green)
    end
    UI.Switch(p,"👣 落脚点指示 (每个人脚下的光圈, 看谁站哪/往哪走)","FootstepESP",function(on) P(SYS.SetFootstep,on) end)
    UI.Switch(p,"头顶武器标记 (背包/手上有武器就标记)","ESPWeapon",function(on)
        if not on and not SYS.T_.ESP and not SYS.T_.ESPNameTag and not SYS.T_.ESPItem then SYS.ClearESP() end
    end)
    -- ★ v3.9.0 名字高度: 默认自动贴到角色顶部之上, 这里只做额外抬高
    UI.Slider(p,"名字高度(额外抬高)",0,8,0.2,
        function() return SYS.C_.ESPNameH end,function(v) SYS.C_.ESPNameH=v end,"+%.1f")
    -- ★ v3.9.0 子弹射线: 只画线, 不改弹道
    UI.Switch(p,"子弹射线 (只画线, 不改弹道)","Tracer",function(on)
        if not on then P(SYS.TracerHide) end
    end)
    -- ★ v72: 方框选项已删(用户要的是人物高亮, 不是框)
    UI.Tip(p,"透视 = 人物高亮(把整个人染色描边, 穿墙可见)。\n掉落物透视用同款高亮、金色 —— 只认【客户端已经拿到】的世界物件(名字像掉落物, 或带可捡/可交互提示)。\nRoblox 不会把别人的背包复制给你, 所以别人包里的东西看不到是引擎限制, 不是脚本问题。")
    UI.Div(p)
    UI.Switch(p,"全亮 (FullBright)","FullBright",SYS.SetFullBright)
    UI.Switch(p,"自由视角","FreeCam",function(on)
        if on then SYS.StartFreeCam() else SYS.StopFreeCam() end
    end)
    UI.Slider(p,"自由视角速度",10,300,5,function() return SYS.C_.FreeCamSpeed end,function(v) SYS.C_.FreeCamSpeed=v end,"%.0f")
    UI.Slider(p,"自由视角灵敏度",0.1,2,0.05,function() return SYS.C_.FreeCamSens end,function(v) SYS.C_.FreeCamSens=v end,"%.2f")

    UI.Div(p)
    --================ ★ v6.7.0 光照档位包 (融合自 ChronixHub 工具页) ================
    UI.Section(p,"💡 光照档位包 (各档独立 · 关掉精确还原)",CY.yellow)
    UI.Switch(p,"🌙 夜视","NightVision",SYS.ReapplyLight)
    UI.Switch(p,"🌕 超级夜视 (更亮 + 强制正午)","NightVisionPro",SYS.ReapplyLight)
    UI.Switch(p,"🏮 随身灯笼 (角色发光 · 只本地可见)","Lantern",SYS.ReapplyLight)
    UI.Switch(p,"☀ 超级光明 (最亮档)","SuperLight",SYS.ReapplyLight)
    UI.Switch(p,"🌫 禁用雾效","NoFog",SYS.ReapplyLight)
    UI.Switch(p,"🕶 禁用全局阴影","NoShadow",SYS.ReapplyLight)
    UI.Tip(p,"六档各管一段、互相叠加(取最亮的那档生效), 全部关掉会精确还原成加载时的光照。\n★ 和上面的「全亮」是两套写法 —— 同时开时以最后操作的那个为准, 想稳妥就只留一套。\n★ 游戏若每帧把 Lighting 改回去, 就会看到闪烁 —— 那种图请用「全亮」。",CY.sub)

    UI.Div(p)
    --================ ★ v6.7.0 滤镜控制器 (融合自 ChronixHub 滤镜控制器页) ================
    UI.Section(p,"🎨 滤镜控制器 (只改你自己的画面)",CY.purple)
    UI.Switch(p,"启用滤镜 (自建后处理)","FX_Enable",SYS.FX.Apply)
    UI.Slider(p,"饱和度",-1,1,0.05,function() return SYS.C_.FX_Sat end,
        function(v) SYS.C_.FX_Sat=v SYS.FX.Apply() end,"%.2f")
    UI.Slider(p,"亮度",-1,1,0.05,function() return SYS.C_.FX_Bri end,
        function(v) SYS.C_.FX_Bri=v SYS.FX.Apply() end,"%.2f")
    UI.Slider(p,"对比度",-1,1,0.05,function() return SYS.C_.FX_Con end,
        function(v) SYS.C_.FX_Con=v SYS.FX.Apply() end,"%.2f")
    UI.Dropdown(p,"🌈 色盲模拟 (选中即覆盖上面三个滑块)",SYS.FX.Modes,
        function() return SYS.C_.FX_CB or "关闭" end,
        function(v)
            SYS.C_.FX_CB=v
            if SYS.T_.FX_Enable~=true then SYS.T_.FX_Enable=true end
            SYS.FX.Apply()
            for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
        end)
    UI.Btn(p,"♻ 重置滤镜为默认",CY.orange,function()
        SYS.C_.FX_Sat=0 SYS.C_.FX_Bri=0 SYS.C_.FX_Con=0 SYS.C_.FX_CB="关闭"
        SYS.FX.Apply()
        for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
        SYS.Notify("♻ 滤镜已重置",SYS.CY.sub)
    end)
    UI.Label(p,"后处理特效开关 (逐个隐藏游戏自带的后处理)",CY.sub)
    UI.Switch(p,"隐藏 模糊 (Blur)","FX_HBlur",function(on) SYS.FX.HidePost("BlurEffect",on) end)
    UI.Switch(p,"隐藏 泛光 (Bloom)","FX_HBloom",function(on) SYS.FX.HidePost("BloomEffect",on) end)
    UI.Switch(p,"隐藏 景深 (DepthOfField)","FX_HDoF",function(on) SYS.FX.HidePost("DepthOfFieldEffect",on) end)
    UI.Switch(p,"隐藏 太阳光晕 (SunRays)","FX_HRays",function(on) SYS.FX.HidePost("SunRaysEffect",on) end)
    UI.Switch(p,"隐藏 色彩校正 (ColorCorrection)","FX_HCC",function(on) SYS.FX.HidePost("ColorCorrectionEffect",on) end)
    UI.Tip(p,"色盲模拟是【近似】—— Roblox 没有真正的色盲变换矩阵, 这里用「去饱和 + 色调偏移」模拟观感, 不能当医学用途。\n「隐藏后处理」只关你自己客户端看到的效果, 关掉会把原状态写回。",CY.sub)

    UI.Div(p)
    --================ ★ v6.7.0 音频 (控制器 + 检查器 合并成一页一组) ================
    UI.Section(p,"🔊 音频 (控制器 + 检查器)",CY.cyan)
    UI.Switch(p,"启用音频检测 (每 3 秒自动刷新列表)","AudioCtl",function()
        if SYS.AudioRender then P(SYS.AudioRender) end
    end)
    UI.Switch(p,"只看正在响的 (按响度阈值过滤)","AudioProbe",function()
        if SYS.AudioRender then P(SYS.AudioRender) end
    end)
    UI.Slider(p,"响度阈值 (建议 10-50)",0,200,5,function() return SYS.C_.AudioThr end,
        function(v) SYS.C_.AudioThr=v if SYS.AudioRender then P(SYS.AudioRender) end end,"%.0f")
    UI.Slider(p,"总音量 (%)",0,100,5,function() return SYS.C_.AudioMaster end,
        function(v) SYS.C_.AudioMaster=v SYS.Audio.SetMaster(v) end,"%.0f")
    UI.Btn(p,"🔄 立即刷新音频列表",CY.cyan,function() if SYS.AudioRender then P(SYS.AudioRender) end end)
    UI.Btn(p,"🔊 恢复全部静音与总音量",CY.purple,function()
        SYS.Audio.RestoreAll()
        if SYS.AudioRender then P(SYS.AudioRender) end
        SYS.Notify("🔊 已恢复全部音频设置",SYS.CY.purple)
    end)
    local aList=SYS.MiniList(p,190)
    UI.Tip(p,"只列【你本地已经拿到】的 Sound(扫 SoundService / Workspace / ReplicatedStorage / 你的角色, 最多 4 层)。\n静音与总音量都只影响你自己听到的, 不会传给别人。\n⚠ 客户端没有静音他人语音的公开 API —— 想要那个请用「玩家」页的本地静音(它只静音对方角色里的音效)。",CY.sub)
    local function audioRender()
        SYS.MiniClear(aList)
        local arr=SYS.Audio.Scan(60)
        local probeOn=SYS.T_.AudioProbe==true
        local thr=SYS.C_.AudioThr or 15
        local head=SYS.MiniRow(aList,24)
        local hl=SYS.MiniText(head,("总音量 %d%%   扫到 %d 个声音"):format(math.floor(SYS.C_.AudioMaster or 100),#arr),11,CY.sub)
        hl.Size=UDim2.new(1,-8,1,0) hl.Position=UDim2.new(0,6,0,0)
        local shown=0
        for i=1,#arr do
            local s=arr[i]
            if i>60 then break end
            local okL,loud=pcall(function() return s.PlaybackLoudness end)
            loud=(okL and loud) or 0
            local okP,playing=pcall(function() return s.Playing end)
            playing=okP and playing
            if (not probeOn) or (playing and loud>=thr) then
                shown=shown+1
                local r=SYS.MiniRow(aList,26)
                local okId,sid=pcall(function() return s.SoundId end)
                sid=tostring((okId and sid) or "?")
                sid=(sid:gsub("rbxassetid://",""))
                if #sid>34 then sid=sid:sub(1,34).."…" end
                local nm=SYS.MiniText(r,("%s · %s"):format(tostring(s.Name),sid),11,playing and CY.text or CY.sub)
                nm.Size=UDim2.new(1,-196,1,0) nm.Position=UDim2.new(0,6,0,0)
                local lb=SYS.MiniText(r,("%.0f"):format(loud),11,CY.yellow)
                lb.Size=UDim2.new(0,32,1,0) lb.Position=UDim2.new(1,-190,0,0)
                local mb=SYS.MiniBtn(r,SYS.Audio.IsMuted(s) and "已静音" or "静音",CY.orange,function()
                    SYS.Audio.Mute(s,not SYS.Audio.IsMuted(s))
                    P(audioRender)
                end,58)
                mb.Position=UDim2.new(1,-154,0,2)
                local cb=SYS.MiniBtn(r,"复制ID",CY.cyan,function()
                    if setclipboard then
                        setclipboard(tostring(sid))
                        SYS.Notify("📋 已复制 "..sid,CY.cyan)
                    end
                end,58)
                cb.Position=UDim2.new(1,-92,0,2)
            end
        end
        if shown==0 then
            local r=SYS.MiniRow(aList,26)
            local l=SYS.MiniText(r,probeOn and "未检测到超过阈值的音频" or "点上面「立即刷新音频列表」开始扫描",11,CY.sub)
            l.Size=UDim2.new(1,-8,1,0) l.Position=UDim2.new(0,6,0,0)
        end
    end
    SYS.AudioRender=audioRender
    audioRender()
    SYS.SpawnLoop(function()
        while not SYS.Unloaded do
            task.wait(3)
            if SYS.T_.AudioCtl==true and SYS.AudioRender then P(SYS.AudioRender) end
        end
    end)
end

UI.Pages["功能"]=function(p)
    -- ★ v4.2.0 扫描主入口(从设置页搬来; 用户要求放功能页)
    UI.Btn(p,"🔍 综合扫描 (通信/代码/脚本/实例/数据/连接/环境/反查 八层一次扫完)",CY.green,function()
        P(function() SYS.Lab.FullScan() end)
    end)
    UI.Btn(p,"📋 复制扫描摘要到剪贴板",CY.cyan,function() P(function() SYS.Lab.Summary() end) end)
    UI.Tip(p,"点【综合扫描】一个按钮, 结果全部打到控制台(F9), 按六层分行:\n  A 通信层 = 游戏有哪些 Remote(能触发什么) —— 原来是单独一个按钮, 现在合并进来了\n  B 代码层 = 游戏有哪些函数 + 名字可疑的(damage/fire/aim…)\n  C 脚本层 = 跑了哪些脚本/模块\n  D 实例层 = getnilinstances(游戏藏起来的对象) + Workspace 规模\n  E 数据层 = 自己和他人身上的 Attribute 全字段(vs @Health/@Team 就来自这里)\n  F 连接层 = 游戏自己挂了哪些事件监听\n  G 环境层 = 执行器/游戏全局 + registry + 线程身份(能判断脚本跑在什么权限下)\n  H 反查层 = getcallingscript(谁调起的) + 函数闭包 upvalue 概览",CY.sub)
    UI.Div(p)
    -- ★ v5.4.0 「进阶: 观察某个函数(函数名输入 + 开始观察/调用记录/调用链/停止观察)」整段删除
    --   —— 用户要求: "进阶观察函数名那个删了吧"。这套东西要用户自己观察、自己记函数名, 不是他要的。
    --   (SYS.Lab 里的观察实现留在原处但界面入口已无 —— 不占界面、也不会被误触。)

    UI.Switch(p,"上帝模式","GodMode",SYS.SetGod)
    UI.Switch(p,"无坠落伤害","NoFall",SYS.SetNoFall)
    -- ★ v82: 「隐身」只能本地生效(别人仍看得到你), 用户要求删除
    UI.Switch(p,"🕳 藏地下隐身 (服务器认可)","DeepHide",SYS.SetDeepHide)
    UI.Cycle(p,"藏身方向",{"地下","天上"},
        function() return SYS.C_.DeepHideMode=="up" and "天上" or "地下" end,
        function(v)
            SYS.C_.DeepHideMode=(v=="天上") and "up" or "down"
            if SYS.DeepHideReapply then P(SYS.DeepHideReapply) end
        end)
    UI.Slider(p,"藏地下隐身深度 (格 · 小=能交互 / 大=藏得深)",5,300,5,
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
    UI.Label(p,"帧率优化（强化版）",CY.cyan)
    UI.Switch(p,"帧率优化 (一键)","PerfBoost",SYS.SetPerf)
    UI.Slider(p,"剔除距离",30,500,10,function() return SYS.C_.PerfCull end,function(v) SYS.C_.PerfCull=v end,"%.0f")

    UI.Div(p)
    --================ ★ v6.7.0 自杀 / 重生点 / 工具增删 ================
    UI.Section(p,"☠ 自杀 / 重生点",CY.red)
    UI.Btn(p,"☠ 强制自杀 (抹除)",CY.red,function() SYS.ForceSuicide("erase") end)
    UI.Btn(p,"🕳 强制自杀 (虚空抹除)",CY.red,function() SYS.ForceSuicide("void") end)
    UI.Tip(p,"「抹除」= 直接移除你自己的角色模型; 「虚空抹除」= 先把角色挪到 -5000 高度再判死(某些游戏对出界的处理不同)。\n两条【只作用于你自己】。",CY.sub)
    UI.Btn(p,"♻ 原地重生 (满血 + 回到当前点)",CY.green,function() SYS.RespawnHere() end)
    UI.Btn(p,"📍 设置当前位置为重生点",CY.cyan,function() SYS.SetSpawnHere() end)
    UI.Btn(p,"↩️ 恢复默认重生点",CY.orange,function() SYS.ClearSpawnHere() end)
    UI.Tip(p,"重生点记账是【纯本地】的(写本地 RespawnLocation + 死了把你挪回去)。\n若这个游戏的重生位置由服务端决定, 本地改无效 —— 那时只有「原地重生」按钮能立即生效。",CY.sub)

    UI.Div(p)
    UI.Section(p,"🧰 工具增删",CY.green)
    UI.Btn(p,"🧰 获取游戏内全部工具 (复制进背包)",CY.green,function() SYS.GiveAllTools() end)
    UI.Btn(p,"✋ 把手中工具放回背包",CY.orange,function()
        local ch=LP.Character
        local t=ch and ch:FindFirstChildOfClass("Tool")
        local bp=LP:FindFirstChildOfClass("Backpack")
        if t and bp then
            P(function() t.Parent=bp end)
            SYS.Notify("✋ 已把手中工具放回背包",SYS.CY.sub)
        else
            SYS.Notify("手里没有工具(或没有背包)",SYS.CY.sub)
        end
    end)
    UI.Btn(p,"🧹 移除全部工具 (背包 + 手上)",CY.red,function() SYS.RemoveAllTools() end)
    UI.Tip(p,"「获取全部工具」是把场景里所有 Tool 复制一份进你的背包 —— 只影响你自己, 别人看不到。\n背包里放太多会被游戏脚本卡顿, 用完记得「移除全部工具」。",CY.sub)

    UI.Div(p)
    --================ ★ v6.7.0 防护 ================
    UI.Section(p,"🛡 防护 (反作弊绕过 / 管理员检测 / 防踢出)",CY.orange)
    UI.Switch(p,"🛡 一键开启全部防护","Prot_HideGui",function(on)
        local function setOne(k,s,f)
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
            SYS.Notify("🛡 全部防护已尝试开启(失败项会单独提示)",SYS.CY.green)
        else
            SYS.T_.Prot_AntiAC=false
            SYS.T_.Prot_AntiAdmin=false
            SYS.T_.Prot_AntiTP=false
            SYS.Prot.RemoveKickGuard()
            SYS.Prot.RemoveHideGui()
            SYS.Prot.RemoveTPGuard()
            SYS.Notify("防护已全部卸下",SYS.CY.sub)
        end
        for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
    end)
    UI.Switch(p,"反作弊绕过 (拦截客户端踢人 / 抹除)","Prot_AntiAC",function(on)
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
    UI.Switch(p,"管理员检测绕过 (对自己 GUI 隐身)","Prot_AntiAdmin",function(on)
        if on then
            if SYS.ScreenGui then P(function() SYS.ScreenGui.Name="RobloxGui_Backpack" end) end
            local ok,err=SYS.Prot.InstallHideGui()
            if not ok then
                SYS.T_.Prot_AntiAdmin=false
                SYS.Notify("❌ 开启失败: "..tostring(err),SYS.CY.red)
                for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
            else
                SYS.Notify("🕵 自己的 GUI 已从 CoreGui 枚举里隐藏",SYS.CY.green)
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
    UI.Btn(p,"🧪 防护能力自检 (这台支持哪些 hook)",CY.cyan,function()
        local t={
            "=== 防护能力自检 ===",
            SYS.Prot.CapsText(),
            "识别到 Adonis 结构: "..tostring(SYS.Prot.DetectAdonis()),
            "已拦截次数: "..tostring(SYS.Prot.Blocked),
            "最后被拦截来源: "..tostring(SYS.Prot.LastFrom),
        }
        print(table.concat(t,"\n"))
        SYS.Notify("🧪 结果已打到控制台(F9)",SYS.CY.cyan)
    end)
    UI.Tip(p,"技术来源(2026-09 复核 · 均为近 2 个月内更新的开源实现):\n  · Windows81/Personal-Roblox-Client-Scripts · anti-kick.lua —— hookfunction(Player.Kick/Destroy) + __namecall 过滤 kick/destroy\n  · Direnta/RBLXAntiKick —— getrawmetatable(game) 换掉 __namecall, 命中 Kick 直接丢弃\n  · CF-Trail/random utilLoader —— Adonis 识别特征: 带 __FUNCTION 的 RemoteFunction\n★ 只能拦【客户端发起的】踢人与传送 —— 服务端直接判定你违规时, 客户端拦不住。\n★ 需要执行器有 hookmetamethod / hookfunction / newcclosure; 没有会在上面自检里如实报出来。\n★ 单独关掉某一项会把它卸下(和「一键开启」不联动)。",CY.yellow)
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
    UI.Switch(p,"💬 聊天翻译","TransChat",function(on)
        if on then Trans.startChatListener() else Trans.stopChatListener() end
    end)
    UI.Switch(p,"🖼️ 界面翻译","TransUI",function(on)
        if on then Trans.startUIScan() else Trans.stopUIScan() end
    end)
    -- ★ v82: 「短文本批量合并」是死开关(v70 重写版已不做批量, BatchOn 没人读) -> 删除

    UI.Btn(p,"🔍 立即强制全屏扫描翻译",CY.cyan,function()
        task.spawn(function()
            print("[Trans] 手动触发全屏扫描...")
            if Trans.forceRescan then pcall(Trans.forceRescan) end
            print("[Trans] ✅ 手动全屏扫描完成")
        end)
    end)
    UI.Div(p)
    UI.Label(p,"📤 发送消息",CY.yellow)
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
    UI.Label(p,"💾 缓存 · "..tostring(Trans.CACHE_FILE or "TransCache.json"),CY.cyan)
    local statL=UI.Label(p,("已缓存 %d 条"):format(Trans.cacheCount or 0),CY.green)
    -- ★ 新增：实时并发监控
    local statConcurrent = UI.Label(p, "命中 0 | 本地 0 | 失败 0 | 跳过扫 0 | 均 0ms", CY.cyan)
    
    task.spawn(function()
        while not SYS.Unloaded do
            task.wait(0.5)
            if statL and statL.Parent then statL.Text=("已缓存 %d 条"):format(Trans.cacheCount or 0) end
            if statConcurrent and statConcurrent.Parent then
                local st=Trans.Stats or {}
                local avg=(st.latN and st.latN>0) and (st.lat/st.latN) or 0
                statConcurrent.Text = ("命中 %d | 本地 %d | 失败 %d | 跳过扫 %d | 均 %.0fms"):format(
                    st.hit or 0, st.loc or 0, st.fail or 0, st.sweepSkip or 0, avg
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
    UI.Label(p,"🔌 本地模型状态",CY.cyan)
    local stL=UI.Label(p,"本地模型: ⚪ 检测中...",CY.sub)
    local function refresh()
        if not stL or not stL.Parent then return end
        task.spawn(function()
            stL.Text="本地模型: ⚪ 检测中..." stL.TextColor3=CY.sub
            local s="unknown"
            pcall(function() s=Trans.checkLocal() end)
            if s=="online" then stL.Text="本地模型: 🟢 在线" stL.TextColor3=CY.green
            else stL.Text="本地模型: 🔴 离线" stL.TextColor3=CY.red end
        end)
    end
    Trans.refreshLocalStatus=refresh
    task.spawn(function() task.wait(0.6) refresh() end)
    UI.Btn(p,"🔄 立即检测本地模型",CY.cyan,refresh)
    UI.Btn(p,"⚙️ 重新探测服务器槽位与上下文",CY.purple,function()
        task.spawn(function()
            if Trans.probeServer then
                local pok=Trans.probeServer()
                print(pok and "[Trans] ✅ 探测成功" or "[Trans] ❌ 探测失败(服务器没开?)")
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
    --================ ★ v6.7.0 聊天接收器 (融合自 ChronixHub 聊天接收器页) ================
    UI.Section(p,"📨 聊天接收器 (实时看全部聊天 · 一键复制)",CY.cyan)
    UI.Switch(p,"开始接收聊天","ChatLog",function(on)
        if on then SYS.ChatLog.Start() else SYS.ChatLog.Stop() end
        if SYS.ChatLogRender then P(SYS.ChatLogRender) end
    end)
    UI.Btn(p,"📋 复制全部消息到剪贴板",CY.cyan,function()
        local m=SYS.ChatLog.Msgs
        local out={}
        for i=1,#m do out[#out+1]="["..m[i].who.."] "..m[i].txt end
        if setclipboard then
            setclipboard(table.concat(out,"\n"))
            SYS.Notify(("📋 已复制 %d 条消息"):format(#out),SYS.CY.cyan)
        else
            SYS.Notify("这台执行器没有 setclipboard",SYS.CY.yellow)
        end
    end)
    UI.Btn(p,"🗑️ 清空所有消息",CY.orange,function() SYS.ChatLog.Clear() end)
    local cList=SYS.MiniList(p,200)
    UI.Tip(p,"同时兼容新聊天(TextChatService.MessageReceived)与旧聊天(OnMessageDoneFiltering)。\n只读取本地已经收到的消息 —— 不加任何东西、不发任何东西。\n★ 和我们自己的「聊天翻译」是一对: 一个翻, 一个留档。",CY.sub)
    local function chatRender()
        SYS.MiniClear(cList)
        local m=SYS.ChatLog.Msgs
        if #m==0 then
            local r=SYS.MiniRow(cList,26)
            local l=SYS.MiniText(r,"还没有收到消息(把开关打开后开始接收)",11,CY.sub)
            l.Size=UDim2.new(1,-8,1,0) l.Position=UDim2.new(0,6,0,0)
            return
        end
        local from=math.max(1,#m-120)
        for i=from,#m do
            local e=m[i]
            local r=SYS.MiniRow(cList,24)
            local nm=SYS.MiniText(r,tostring(e.who),11,CY.green)
            nm.Size=UDim2.new(0,124,1,0) nm.Position=UDim2.new(0,6,0,0)
            local tx=SYS.MiniText(r,tostring(e.txt),11,CY.text)
            tx.Size=UDim2.new(1,-190,1,0) tx.Position=UDim2.new(0,132,0,0)
            local cb=SYS.MiniBtn(r,"复制",CY.cyan,function()
                if setclipboard then
                    setclipboard(tostring(e.txt))
                    SYS.Notify("📋 已复制该条",CY.cyan)
                end
            end,52)
            cb.Position=UDim2.new(1,-58,0,1)
        end
    end
    SYS.ChatLogRender=chatRender
    chatRender()
end

--============================================================
-- [14.6] 🔬 实验室 · 执行器高级 API 实验区
--   用户要求: 研究 getgc(true) / hookfunc / pcall+caller, 对已有代码和数据做实验。
--   ★ 边界: 只做【观察 + 可撤销包装】, 不改游戏逻辑、不碰反检测, 全部只影响本客户端。
--   ① GC 扫描  ② 可疑函数清单  ③ 脚本/模块清单  ④ 包一层观察  ⑤ 调用链探测
--============================================================
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
    -- 只读: 这个函数属于哪个脚本 / 叫什么名字
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

    -- ① GC 扫描(只读)
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

    -- ② 可疑函数清单(只读)
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

    -- ③ 已加载脚本/模块清单(只读)
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

    -- ④ 调用观察: 包一层, 只记录参数/返回值, 原样转发(绝不改行为)
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

--  ══════════════════════════════════════════════════════════════
--  ① 综合扫描: 通信层 + 代码层 + 脚本层, 一次点完, 全部打到控制台
--  ══════════════════════════════════════════════════════════════
    -- ══════════════════════════════════════════════════════════════
    --  ★ v4.2.0 综合扫描: 一个按钮点完, 输出按层分行, 全部打到控制台
    --  ══════════════════════════════════════════════════════════════
    local function line(s) print("  "..s) end
    local function head(s) print(""); print("════════ "..s.." ════════") end

    function LAB.FullScan()
        local t0=os.clock()
        print(""); print("##################  🔍 综合扫描  ##################")
        print(("时间 %s"):format(os.date("%H:%M:%S")))
        print("")

        -- ── A 通信层: Remote(复用设置页那个, 它会自己打完整清单并返回列表) ──
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

        -- ── B 代码层: GC 函数/表 + 可疑函数 ──
        head("B · 代码层(游戏函数: 怎么实现的)")
        LAB.ScanGC()
        LAB.ListHookable()

        -- ── C 脚本层 ──
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

        -- ── D 实例层(新): 父级为 nil 的实例 + 关键容器统计 ──
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
            -- ★ 补: 关键对象统计(角色/高亮/交互点/触发区) —— 这些是"能做的事"的落点
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

        -- ── E 数据层(新): Player Attributes 全扫 + 自己角色上的 ──
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
            -- 挑一个别的玩家看看(对比出"哪些字段是每人都有的")
            local n=0
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl~=SYS.LP and n<2 then n=n+1 dumpAttr(pl,"他人") end
            end
            -- 自己角色上的 Attribute(有的游戏把状态挂角色)
            local ch=SYS.LP and SYS.LP.Character
            if ch then dumpAttr(ch,"自己角色") end
            -- ★ 补: Leaderstats(排行榜/金币/等级这类跨网络同步的数据常在这)
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

        -- ── F 连接层(新): getconnections ──
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

        -- ── G 环境层(新): 执行器/游戏环境对比 + registry ──
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
                -- DEV 是 CreateMenu 里的局部变量, 这里看不到 -> 现场重新探测一遍
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

        -- ── H 反查层(新): 当前调用者 + 函数闭包概览 ──
        head("H · 反查层(这段代码是被谁调起来的)")
        P(function()
            if type(getcallingscript)=="function" then
                local ok2,s=P(function() return getcallingscript() end)
                line(("getcallingscript(): %s"):format(ok2 and tostring(s and s:GetFullName() or s) or "?"))
            else line("(这台执行器没有 getcallingscript)") end
            -- 挑一个可疑函数看它"闭包里有什么"(upvalue 名 + 类型, 值可能是大对象就不打印)
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

        print(""); print(("##################  扫描完毕 (%.2fs)  ##################"):format(os.clock()-t0))
        SYS.Notify("综合扫描完成 —— 结果在控制台(F9)",SYS.CY.green)
    end

    -- 一键复制摘要
    function LAB.Summary()
        local out={"=== CheatMenu 扫描摘要 ===", "时间: "..os.date("%Y-%m-%d %H:%M:%S")}
        local c=LAB.Caps()
        out[#out+1]=("执行器: getgc=%s hook=%s restore=%s getscripts=%s")
            :format(tostring(c.getgc),tostring(c.hookfn),tostring(c.restore),tostring(c.scripts))
        if LAB.LastFns then out[#out+1]=("GC 函数数: %d"):format(#LAB.LastFns) end
        if #LAB.Log>0 then out[#out+1]=("调用记录 %d 条, 最近: %s"):format(#LAB.Log,LAB.Log[#LAB.Log]) end
        local txt=table.concat(out,"\n")
        local ok=P(function()
            if type(setclipboard)=="function" then setclipboard(txt)
            elseif type(toclipboard)=="function" then toclipboard(txt) end
        end)
        if ok then SYS.Notify("摘要已复制到剪贴板",SYS.CY.green) else print(txt) SYS.Notify("无剪贴板, 已打到控制台") end
        return txt
    end

    -- ⑤ 调用链探测: immediate caller (pcall + debug.info)
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
    UI.Switch(p,"允许鼠标传送 (T)","TPEnabled")
    UI.Btn(p,"传送到鼠标位置",CY.cyan,SYS.TPToMouse)
    UI.Btn(p,"传送到最近玩家",CY.cyan,SYS.TPToNearest)
    -- ★ v3.9.0 恢复观战: 停止观战按钮(观战入口在下方「玩家列表」右键)
    UI.Btn(p,"停止观战 (回自己视角)",CY.orange,SYS.StopSpectate)
    UI.Btn(p,"回到主城",CY.green,function() SYS.TPTo(SYS.GetDefSpawn()) end)
    UI.Btn(p,"保存当前坐标",CY.purple,function()
        local _,_,root=GC()
        if root then
            -- ★ v69: 保存坐标【默认不开】自动循环传送(用户明确要求)。
            --   要开就点该行上的「自动」按钮(变成绿色「自动✓」), 想关再点一次。
            --   为什么不默认开: 自动传送会把你【反复拉回】这个点 —— 挂机守点很有用,
            --   但正常在玩的时候会一直把你拽回去, 反而碍事。
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
    -- ★ v6.6.0 融合自 ChronixHub 路径点页: Ctrl+数字 直达传送
    UI.Switch(p,"⌨ Ctrl+数字 直达保存点","PathKey",SYS.SetPathKey)
    UI.Tip(p,"按住 Ctrl 再按数字键 1~9 -> 直接传送到下面「已保存位置」里对应的那一条(主键盘/小键盘都认)。\n只对前 9 个生效; 那一条还不存在时会在屏幕上提示。默认关(避免误触)。",CY.sub)

    --================ ★ v6.6.0 手动选服 (融合自 ChronixHub ServerFinderModule) ================
    UI.Label(p,"服务器列表 (同游戏的其它房间)",CY.sub)
    local svrList=Instance.new("ScrollingFrame")
    svrList.Size=UDim2.new(1,0,0,132) svrList.BackgroundColor3=CY.card
    svrList.BackgroundTransparency=0.3 svrList.BorderSizePixel=0 svrList.Parent=p
    svrList.ClipsDescendants=true
    P(function() svrList.CanvasSize=UDim2.new(0,0,0,0) svrList.AutomaticCanvasSize=Enum.AutomaticSize.Y end)
    P(function() svrList.ScrollBarThickness=6 svrList.ScrollBarImageColor3=CY.accent end)
    P(function() svrList.ScrollingDirection=Enum.ScrollingDirection.Y end)
    P(function() svrList.ElasticBehavior=Enum.ElasticBehavior.Never end)
    UI.Round(svrList,8) UI.Stroke(svrList,CY.line,1,0.85)
    local svrLay=Instance.new("UIListLayout") svrLay.Padding=UDim.new(0,4) svrLay.Parent=svrList
    local svrPad=Instance.new("UIPadding")
    svrPad.PaddingTop=UDim.new(0,6) svrPad.PaddingLeft=UDim.new(0,6)
    svrPad.PaddingRight=UDim.new(0,6) svrPad.Parent=svrList
    local function ClearSvr()
        for _,c in ipairs(svrList:GetChildren()) do
            if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end
        end
    end
    local function svrHint(txt,col)
        ClearSvr()
        local h=Instance.new("TextLabel")
        h.Size=UDim2.new(1,-12,0,26) h.BackgroundTransparency=1
        h.Text=txt h.TextColor3=col or CY.sub h.Font=Enum.Font.GothamMedium h.TextSize=12
        h.TextXAlignment=Enum.TextXAlignment.Left h.Parent=svrList
    end
    svrHint("点下面「刷新」拉取列表")
    local function RenderServers(arr)
        ClearSvr()
        for _,s in ipairs(arr) do
            local r=Instance.new("Frame")
            r.Size=UDim2.new(1,-12,0,28) r.BackgroundColor3=CY.panel
            r.BackgroundTransparency=0.3 r.BorderSizePixel=0 r.Parent=svrList
            UI.Round(r,6)
            local nm=Instance.new("TextLabel")
            nm.Size=UDim2.new(1,-90,1,0) nm.Position=UDim2.new(0,6,0,0)
            nm.BackgroundTransparency=1 nm.TextColor3=CY.text
            nm.Text=("%d/%d 人%s"):format(s.playing,s.max,s.cur and "   ← 当前房间" or "")
            nm.Font=Enum.Font.GothamMedium nm.TextSize=12
            nm.TextXAlignment=Enum.TextXAlignment.Left nm.Parent=r
            local jb=Instance.new("TextButton")
            jb.Size=UDim2.new(0,64,1,0) jb.Position=UDim2.new(1,-70,0,0)
            jb.BackgroundColor3=s.cur and CY.sub or CY.green
            jb.BackgroundTransparency=0.3 jb.TextColor3=CY.text
            jb.Text=s.cur and "当前" or "加入"
            jb.Font=Enum.Font.GothamBold jb.TextSize=11
            jb.BorderSizePixel=0 jb.Parent=r UI.Round(jb,4)
            if not s.cur then
                jb.MouseButton1Click:Connect(function() P(SYS.JoinServer,s.id) end)
            end
        end
    end
    UI.Btn(p,"🔄 刷新服务器列表",CY.cyan,function()
        svrHint("⏳ 正在拉取...",CY.yellow)
        task.spawn(function()
            local arr,err=SYS.FetchServers()
            if not arr then svrHint("❌ "..tostring(err),CY.red) return end
            if #arr==0 then svrHint("没有拿到服务器(接口返回空)",CY.yellow) return end
            table.sort(arr,function(a,b) return a.playing>b.playing end)
            RenderServers(arr)
        end)
    end)
    UI.Tip(p,"只读官方接口拉取【同游戏的其它房间】, 按人数从多到少排, 点「加入」换过去。\n★ 列表里没有可靠的延迟字段(Roblox 接口不给) —— 想按延迟挑请用「自动找低延迟服务器」。\n★ 本地版跳过去后脚本不会自动回来, 要重新执行一次加载器(网络版会自动重注入)。",CY.sub)

    UI.Div(p)
    --================ ★ v6.7.0 多路径点系统 (融合自 ChronixHub 路径点传送页) ================
    UI.Section(p,"📍 多路径点系统 (保存 / 世界显示 / 三种前往方式)",CY.cyan)
    UI.Input(p,"备注名 (留空自动编号)","",
        function() return SYS.C_.WPNote or "" end,
        function(v) SYS.C_.WPNote=v end)
    UI.Btn(p,"➕ 添加路径点 (记录当前位置)",CY.green,function() SYS.WP.Add(SYS.C_.WPNote or "") end)
    UI.Switch(p,"在世界中显示路径点 (蓝色光柱 + 编号)","WPShow",function() SYS.WP.RefreshMarks() end)
    UI.Switch(p,"⌨ Ctrl+数字 用于路径点 (优先于保存位置)","WPKey")
    UI.Btn(p,"🧹 清空全部路径点",CY.red,function()
        for i=#SYS.WP.List,1,-1 do SYS.WP.Remove(i) end
        SYS.Notify("🧹 路径点已清空",SYS.CY.sub)
    end)
    local wList=SYS.MiniList(p,170)
    UI.Tip(p,"每个路径点三个按钮: 传送(瞬移) / 缓动(1.2 秒平滑过去) / 步行(交给 Humanoid 走, 会撞墙但最不容易被判定瞬移)。\n「Ctrl+数字」打开后: 前 9 个路径点用 Ctrl+1~9 直达 —— 若那个序号没有路径点, 会自动回退到「已保存位置」。\n★ 路径点只存在内存里, 卸载/换服就没了(坐标是当前服务器专用的)。",CY.sub)
    local function wpRender()
        SYS.MiniClear(wList)
        local L2=SYS.WP.List
        if #L2==0 then
            local r=SYS.MiniRow(wList,26)
            local l=SYS.MiniText(r,"还没有路径点 —— 点上面「添加路径点」把当前位置存下来",11,CY.sub)
            l.Size=UDim2.new(1,-8,1,0) l.Position=UDim2.new(0,6,0,0)
            return
        end
        for i=1,#L2 do
            local w=L2[i]
            local r=SYS.MiniRow(wList,28)
            local nm=SYS.MiniText(r,("%d. %s"):format(i,tostring(w.name)),11,CY.text)
            nm.Size=UDim2.new(1,-262,1,0) nm.Position=UDim2.new(0,6,0,0)
            local b1=SYS.MiniBtn(r,"传送",CY.cyan,function() SYS.WP.Goto(i,"tp") end,46)
            b1.Position=UDim2.new(1,-256,0,3)
            local b2=SYS.MiniBtn(r,"缓动",CY.purple,function() SYS.WP.Goto(i,"tween") end,46)
            b2.Position=UDim2.new(1,-208,0,3)
            local b3=SYS.MiniBtn(r,"步行",CY.green,function() SYS.WP.Goto(i,"walk") end,46)
            b3.Position=UDim2.new(1,-160,0,3)
            local b4=SYS.MiniBtn(r,"去标记",CY.orange,function() SYS.WP.Unmark(i) end,56)
            b4.Position=UDim2.new(1,-112,0,3)
            local b5=SYS.MiniBtn(r,"删除",CY.red,function() SYS.WP.Remove(i) end,44)
            b5.Position=UDim2.new(1,-52,0,3)
        end
    end
    SYS.WPRender=wpRender
    wpRender()
    UI.Label(p,"玩家列表")
    local plList=Instance.new("ScrollingFrame")
    plList.Size=UDim2.new(1,0,0,140) plList.BackgroundColor3=CY.card
    plList.BackgroundTransparency=0.3 plList.BorderSizePixel=0 plList.Parent=p
    plList.ClipsDescendants=true   -- ★ v89: 玩家一多, 列表项不溢出到下面的「保存位置」
    -- ★ v4.11.0 修「玩家列表没法滚动, 看不到下面的玩家」(用户实测):
    --   原来是【普通 Frame】+ ClipsDescendants -> 超过 140px 的部分被裁掉, 而且【没有任何滚动手段】。
    --   换成 ScrollingFrame + AutomaticCanvasSize(Y): 内容多高画布就多长, 滚轮 / 手指 / 拖动滚动条都能滚。
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
                -- ★ v3.9.x 改三栏布局: 名字 + 「传送」 + 「观战」两个显式按钮。
                --   旧实现是"左键传送、右键观战", 右键入口太隐蔽, 用户反馈"没有选谁观战的功能了"。
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
    svList.ClipsDescendants=true   -- ★ v89: 保存位置多时同样不外溢
    -- ★ v4.11.0: 同上 —— 「已保存位置」也不能滚, 一并换成 ScrollingFrame
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
    --========== 实时状态卡 ==========
    local card,inner=UI.Card(p,175)
    local _,targetV=UI.Stat(inner,"当前目标","—")
    local _,wantV=UI.Stat(inner,"指定目标","自动")
    local _,lockV=UI.Stat(inner,"锁定状态","未锁定")
    local _,aimV=UI.Stat(inner,"瞄准方式","关闭")
    local _,distV=UI.Stat(inner,"距离","—")
    local _,perfV=UI.Stat(inner,"循环频率(选人/开火)","—")

    --========== 一键 ==========
    UI.Section(p,"一键 · 开战 / 停战",CY.green)
    UI.Btn(p,"⚡ 一键开战 (秒锁秒开枪 · 移动中也准)",CY.green,function()
        if SYS.Combat and SYS.Combat.QuickMode then SYS.Combat.QuickMode() end
    end)
    UI.Btn(p,"🛑 一键停战 (关掉全部开关 + 恢复视角与控制)",CY.red,function()
        if SYS.Combat then
            P(SYS.Combat.DisableAll)   -- 关掉所有战斗开关(hook 彻底失效)
            P(SYS.Combat.Stop)         -- 停循环 + 清目标
        end
        for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
        P(SYS.ResetCam)                -- 相机类型/主体/CFrame 复位
        P(SYS.EnablePlayerControls)    -- 防止角色控制被留在"禁用"状态
        SYS.Combat.Say("已停战, 视角与控制已恢复",SYS.CY.red)
    end)
    UI.Tip(p,"「一键开战」= 自动瞄准 + 自动开火 0.04 秒 + 锁头 + 预测 + 优先链(正在瞄我的→指定→最近→屏幕中心)。\n点完直接打就行。",CY.green)

    UI.Div(p)
    --========== 瞄准 ==========
    UI.Section(p,"瞄准 · 关闭 / 自动瞄准",CY.accent)
    local AIM_OFF   ="关闭"
    local AIM_AUTO  ="自动瞄准 · 持续把准星转过去"
    UI.Cycle(p,"瞄准方式",{AIM_OFF,AIM_AUTO},
        function()
            if SYS.T_.CB_Aim then return AIM_AUTO end
            return AIM_OFF
        end,
        function(v)
            -- ★ v74 删「静默瞄准」(它要 hook 游戏射线, 是报错最多的一块)
            -- ★ v77 删「快照瞄准」(用户: "快照瞄准是什么来着 可以也不要了")
            --   快照 = 只在【开火那一瞬间】把枪口瞬时对准目标、打完切回原视角, 给服务端判定用;
            --   代价是要直写角色转向, 开火越快写得越密 -> 有被踢风险。既然不要, 就整块停用。
            --   现在只剩「自动瞄准」一档, 另外两个开关恒为 false -> 那两段代码永不执行。
            SYS.T_.CB_Aim     =(v==AIM_AUTO)
            SYS.T_.CB_SnapFire=false
            SYS.T_.CB_Silent=false
            if SYS.Combat then
                SYS.Combat.Start()
                SYS.Combat.Say("瞄准方式 -> "..v,SYS.CY.accent)
            end
        end)
    UI.Tip(p,"「自动瞄准」= 每帧把准星转到目标身上。移动中被相机带偏就打开「移动时暂停瞄准」。\n背身锁得快不快看下面的「跟随速度」(调大更快)。",CY.yellow)

    -- ★ v77: 「锁人速度」三档已删 —— 它只调快照瞄准的转向限流(单次转角/最小间隔/转向后延迟),
    --   快照都删了, 留着只会让人不知道该调哪个。"背身快不快"现在由「跟随速度」决定。

    UI.Cycle(p,"瞄准部位",{"头","身","自动(离准星最近)"},
        function() return ({"头","身","自动(离准星最近)"})[SYS.C_.CB_AimPart or 2] end,
        function(v) SYS.C_.CB_AimPart = (v=="头") and 1 or ((v=="身") and 2 or 3) end)
    UI.Switch(p,"📐 预测瞄准 (算目标移动的提前量)","CB_Predict")
    UI.Slider(p,"预测提前量 (秒 · 目标越快调越大)",0.05,0.60,0.01,
        function() return SYS.C_.CB_PredictTime end,
        function(v) SYS.C_.CB_PredictTime=v end,"%.2f")
    UI.Slider(p,"跟随速度 (自动瞄准跟得多紧)",0.05,1,0.05,
        function() return SYS.C_.CB_Smooth end,
        function(v) SYS.C_.CB_Smooth=v end,"%.2f")
    UI.Slider(p,"索敌范围 (屏幕像素半径 · 越小越只锁正前方)",40,600,10,
        function() return SYS.C_.CB_Fov end,
        function(v) SYS.C_.CB_Fov=v end,"%.0f")
    UI.Slider(p,"最大距离",50,2000,50,
        function() return SYS.C_.CB_MaxDist end,
        function(v) SYS.C_.CB_MaxDist=v end,"%.0f")
    --================ ★ v6.7.0 瞄准补强 (融合自 ChronixHub 瞄准设置) ================
    UI.Slider(p,"命中率 (% · 100=每帧都瞄, 调低=像手抖)",5,100,5,
        function() return SYS.C_.CB_HitRate end,
        function(v) SYS.C_.CB_HitRate=v end,"%.0f")
    UI.Switch(p,"🚫 漏打模式 (按概率故意打偏一枪)","CB_MissMode")
    UI.Slider(p,"漏打概率 (%)",0,80,5,
        function() return SYS.C_.CB_MissRate end,
        function(v) SYS.C_.CB_MissRate=v end,"%.0f")
    UI.Tip(p,"「命中率」= 只有 n% 的帧去转相机; 100 = 最准, 调低后更接近人手的间歇感。\n「漏打模式」= 开火前按概率跳过一枪, 避免每枪都爆头的统计特征。\n★ 平滑度/预判量/索敌半径已经在上面 —— 对应「跟随速度 / 预测提前量 / 索敌范围」, 不再重复给控件。\n★ 「粘性瞄准(锁定保持)」你早前明确删过, 这次没有加回来 —— 需要的话单独说。",CY.sub)

    UI.Div(p)
    --========== 开火 ==========
    UI.Section(p,"开火 · Triggerbot",CY.red)
    UI.Switch(p,"🔫 自动开火","CB_Fire",function(on) if on then SYS.Combat.Start() end end)
    UI.Slider(p,"开火间隔 (秒 · 调小=更快)",0.02,0.50,0.005,
        function() return SYS.C_.CB_FireDelay end,
        function(v) SYS.C_.CB_FireDelay=v end,"%.3f")
    UI.Slider(p,"只打血量低于此值的目标 (0=不限)",0,100,5,
        function() return SYS.C_.CB_HpThr end,
        function(v) SYS.C_.CB_HpThr=v end,"%.0f")
    UI.Tip(p,"「自动开火」要看得见目标才开枪: 开着自动瞄准时直接用锁定目标;\n瞄准关着时要求准星真压在敌人身上(纯扳机模式)。",CY.sub)

    UI.Div(p)
    --========== 打谁 ==========
    UI.Section(p,"打谁 · 选人规则",CY.purple)
    -- ★ v56: 点开就列出当前在线玩家, 直接点名字指定。选项用函数现算, 每次展开都是最新名单。
    UI.Dropdown(p,"指定目标(点开选择)", function()
        local L={AUTO_TXT}
        local names={}
        local ps=Players:GetPlayers()
        if ps then
            for _,pl in ipairs(ps) do
                -- ★ v82: 只列【已进地图】的人(有活角色); 还在大厅/观战的人不列
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
    --================ ★ v6.7.0 白名单 / 黑名单 (融合自 ChronixHub 瞄准设置) ================
    UI.Section(p,"白名单 / 黑名单 (选人硬规则)",CY.orange)
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
    UI.Section(p,"选人偏好",CY.purple)
    UI.Cycle(p,"优先模式 (自动选人的先后顺序)",{"正在瞄我的→指定→最近→屏幕中心","最近→屏幕中心","准星指向→最近→屏幕中心","血量最低→最近→屏幕中心","屏幕中心→最近"},
        function() return ({"正在瞄我的→指定→最近→屏幕中心","最近→屏幕中心","准星指向→最近→屏幕中心","血量最低→最近→屏幕中心","屏幕中心→最近"})[SYS.C_.CB_PrioMode or 1] end,
        function(v)
            local m={["正在瞄我的→指定→最近→屏幕中心"]=1,["最近→屏幕中心"]=2,["准星指向→最近→屏幕中心"]=3,["血量最低→最近→屏幕中心"]=4,["屏幕中心→最近"]=5}
            SYS.C_.CB_PrioMode = m[v] or 1
        end)
    UI.Tip(p,"优先模式 = 按顺序一级级筛: 先满足第一优先, 没有再往下。\n★ 「指定」= 你在战斗页指定的那个人。默认链里它排第 2 —— 有人正瞄着你时先打他, 没人瞄你才轮到指定目标。\n★ 打开「只打指定目标」后, 指定目标仍【绝对最优先】(整条链都不参与)。\n默认「正在瞄我的→指定→最近→屏幕中心」: 先打正瞄着你的人, 其次你指定的, 再次最近的, 最后屏幕中间那个。",CY.sub)
    -- ★ v82: 「锁定保持」已删(用户要求; 现在由优先链决定, 不再粘住一个目标)
    UI.Switch(p,"💀 只锁活人 (没有血量的尸体不算人)","CB_OnlyAlive")
    UI.Switch(p,"🛡 不打队友 (混战/自建房请关掉)","CB_Team")
    -- ★ v5.4.0(用户要求合并): 原来拆成"近距离补刀"+"补刀也打非目标"两个开关 —— 用户指出
    --   "两个效果一样的, 别拆开"。**合成一个**: 开了就在【射程内】补刀 —— 优先补锁定的目标,
    --   锁定目标不在射程内(或没锁定)就补【最近的敌人】。所以不再需要第二个开关。
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
    --========== 诊断 ==========
    -- ★★ 融合自 ChronixHub 的 AntiVoid / AirWalk / UNCAndWUNCGet / F3DebugScreen / 清理组
    --   (全部纯客户端: 只动自己的角色/自己看到的画面; 不需要的关掉就干净)
    UI.Div(p)
    --================ ★ v6.7.0 高风险瞄准三项 (用户要求: 加入但默认全关) ================
    UI.Section(p,"⚠ 高风险瞄准 (默认全关 · 需要才开)",CY.red)
    UI.Switch(p,"静默瞄准 (准星没对上也判定命中)","CB_SilentAim",function(on)
        if on then
            local ok,err=SYS.RayHook.Install()
            if not ok then
                SYS.T_.CB_SilentAim=false
                SYS.Notify("❌ 开启失败: "..tostring(err),SYS.CY.red)
                for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
            else
                SYS.Notify("⚠ 静默瞄准已开 —— 射线改写中",SYS.CY.red)
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
    UI.Section(p,"工具 / 调试 (融合自 ChronixHub)",CY.purple)
    UI.Switch(p,"🕳 防掉虚空 (掉太深自动拉回原位)","AntiVoid",function(on)
        if not on then SYS.Notify("🕳 防掉虚空 已关闭",SYS.CY.sub) return end
        SYS.TT(task.spawn(function()
            local lastGood=nil
            while SYS.T_.AntiVoid and not SYS.Unloaded do
                P(function()
                    local ch=LP.Character
                    local root=ch and ch:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- 记录"站在地面上的最后位置"(每 0.5s 更新一次)
                        local hit=select(1,WS:FindPartOnRayWithIgnoreList(Ray.new(root.Position,Vector3.new(0,-6,0)),{ch}))
                        if hit then lastGood=root.CFrame
                        elseif root.Position.Y < -50 and lastGood then
                            -- 掉太深 -> 拉回最后的安全位置(用 CFrame 一步回去, 会被服务端校验, 但只影响自己)
                            root.CFrame=lastGood
                        end
                    end
                end)
                task.wait(0.5)
            end
        end))
        SYS.Notify("🕳 防掉虚空 已开启",SYS.CY.green)
    end)
    UI.Switch(p,"🦅 空中走 (悬停在地面高度上, 不落地)","AirWalk",function(on)
        if not on then
            if SYS._awConn then P(function() SYS._awConn:Disconnect() end) SYS._awConn=nil end
            SYS.Notify("🦅 空中走 已关闭",SYS.CY.sub) return
        end
        if SYS._awConn then return end
        SYS._awConn=RS.Heartbeat:Connect(function()
            if not SYS.T_.AirWalk or SYS.Unloaded then return end
            P(function()
                local ch=LP.Character
                local root=ch and ch:FindFirstChild("HumanoidRootPart")
                local hum=ch and ch:FindFirstChildOfClass("Humanoid")
                if root and hum then
                    -- 站住不动时把 Y 速度钉住(≈悬停); 用速度而不是 CFrame, 免得被判定瞬移
                    local v=root.AssemblyLinearVelocity
                    if math.abs(v.Y)>0.5 then root.AssemblyLinearVelocity=Vector3.new(v.X,0,v.Z) end
                end
            end)
        end)
        T(SYS._awConn)
        SYS.Notify("🦅 空中走 已开启(悬停, 不落地)",SYS.CY.green)
    end)
    UI.Btn(p,"🧪 执行器能力自检 (这台支持哪些函数, 打到控制台)",CY.cyan,function()
        P(function()
            print("========== 执行器能力自检 ==========")
            local list={"getgc","getgenv","getrenv","getreg","getconnections","getnilinstances","getrunningscripts",
                        "getscripts","getloadedmodules","getcallingscript","getscriptsource","getscriptbytecode",
                        "fireclickdetector","fireproximityprompt","firetouchinterest","hookfunction","replaceclosure",
                        "newcclosure","checkcaller","islclosed","isreadonly","setreadonly","getupvalue","setupvalue",
                        "getrawmetatable","setrawmetatable","make_writeable","identifyexecutor","request","http_request",
                        "writefile","readfile","isfile","listfiles","makefolder","delfile","loadstring","getcustomasset","setclipboard"}
            for _,n in ipairs(list) do
                local f=nil
                P(function() f=getfenv()[n] end)
                if f==nil then P(function() f=_G[n] end) end
                print(("  %-22s %s"):format(n, type(f)=="function" and "✓ 有" or "✗ 没有"))
            end
            print("===================================")
        end)
    end)
    UI.Switch(p,"📊 F3 调试屏 (FPS / 延迟 / 坐标 / 实例数)","F3Debug",function(on)
        if not on then
            if SYS._f3Gui then P(function() SYS._f3Gui:Destroy() end) SYS._f3Gui=nil end
            SYS.Notify("📊 调试屏 已关闭",SYS.CY.sub) return
        end
        if SYS._f3Gui then return end
        P(function()
            local g=Instance.new("ScreenGui")
            g.Name="CheatMenuF3" g.ResetOnSpawn=false g.IgnoreGuiInset=true
            P(function() if gethui then g.Parent=gethui() end end)
            if not g.Parent then g.Parent=SYS.PG end
            local t=Instance.new("TextLabel")
            t.Size=UDim2.new(0,240,0,86) t.Position=UDim2.new(0,10,0,10)
            t.BackgroundColor3=Color3.fromRGB(10,12,18) t.BackgroundTransparency=0.3
            t.BorderSizePixel=0 t.TextColor3=Color3.fromRGB(180,255,120)
            t.Font=Enum.Font.Code t.TextSize=13 t.TextXAlignment=Enum.TextXAlignment.Left
            t.Text="…" t.Parent=g
            SYS._f3Gui=g SYS._f3Lbl=t
        end)
        SYS.TT(task.spawn(function()
            local last,acc=os.clock(),0
            while SYS.T_.F3Debug and not SYS.Unloaded do
                P(function()
                    local f=RS.RenderStepped:Wait()
                    acc=acc+1
                    local now=os.clock()
                    if now-last>=0.5 then
                        local fps=math.floor(acc/(now-last)+0.5)
                        acc=0 last=now
                        local ch=LP.Character
                        local root=ch and ch:FindFirstChild("HumanoidRootPart")
                        local pos=root and root.Position or Vector3.new(0,0,0)
                        local ping=0
                        P(function() ping=math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
                        if SYS._f3Lbl and SYS._f3Lbl.Parent then
                            SYS._f3Lbl.Text=("FPS %d   Ping %d ms\n位置 %.0f, %.0f, %.0f\nWorkspace 实例 %d\n角色 %d  玩家 %d")
                                :format(fps,ping,pos.X,pos.Y,pos.Z,#WS:GetChildren(),#Players:GetPlayers())
                        end
                    end
                end)
            end
        end))
        SYS.Notify("📊 调试屏 已开启",SYS.CY.green)
    end)
    UI.Section(p,"客户端清理",CY.sub)
    UI.Btn(p,"🧹 清理游戏里乱动的垃圾部件 (只删明显是特效残留的)",CY.orange,function()
        P(function()
            local n=0
            for _,o in ipairs(WS:GetDescendants()) do
                if o:IsA("BasePart") and o.Name:lower():find("debris",1,true) and not o:IsDescendantOf(LP.Character) then
                    n=n+1 P(function() o:Destroy() end)
                end
            end
            SYS.Notify(("🧹 清理完成, 删了 %d 个"):format(n),SYS.CY.green)
        end)
    end)
    UI.Btn(p,"🗑 删掉游戏自带的广告/公告 GUI (只删名字可疑的)",CY.orange,function()
        P(function()
            local n=0
            local PG=SYS.PG
            if PG then
                for _,o in ipairs(PG:GetChildren()) do
                    local nm=o:GetDescendants()
                    local hit=false
                    P(function() if o.Name:lower():find("ad",1,true) or o.Name:lower():find("promo",1,true)
                        or o.Name:lower():find("notice",1,true) or o.Name:lower():find("公告") then hit=true end end)
                    if hit and o~=SYS.ScreenGui then n=n+1 P(function() o:Destroy() end) end
                end
            end
            SYS.Notify(("🗑 已删 %d 个广告类 GUI"):format(n),SYS.CY.green)
        end)
    end)
    -- ★★ 融合自 ChronixHub 的 ClickInspectModule: 按住 Ctrl + 左键点一个部件 -> 把它的
    --   名字/完整路径/类型/位置/材质/锚定/子级数 打到控制台。纯只读, 排障神器(比综合扫描更细)。
    function SYS.SetClickInspect(on)
        if not on then SYS._ciOn=false return end
        SYS._ciOn=true
        T(UIS.InputBegan:Connect(function(input,gp)
            if not SYS._ciOn or SYS.Unloaded then return end
            if input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
            local ctrl=false
            P(function() ctrl=UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl) end)
            if not ctrl then return end
            P(function()
                local cam=WS.CurrentCamera
                local m=LP:GetMouse()
                local unit=WS.CurrentCamera.CFrame:PointToWorldSpace(Vector3.new(0,0,0))
                local ray=WS.CurrentCamera:ScreenPointToRay(m.X,m.Y)
                -- ★ 用鼠标射一条线, 命中就是"你指的那个部件"(兼容第三人称)
                local hit=select(1,WS:FindPartOnRayWithIgnoreList(Ray.new(ray.Origin,ray.Direction*600),{LP.Character}))
                if not hit then print("🔍 Ctrl+点击: 没命中任何部件") return end
                print(string.rep("═",56))
                print("🔍 部件信息 (Ctrl+点击)")
                print("  名称      : "..tostring(hit.Name))
                print("  完整路径  : "..tostring(hit:GetFullName()))
                print("  类型      : "..tostring(hit.ClassName))
                local par=hit.Parent
                print("  父级      : "..tostring(par and par:GetFullName()))
                print("  位置      : "..tostring(hit.Position))
                print("  大小      : "..tostring(hit.Size))
                print("  材质/颜色 : "..tostring(hit.Material).." / "..tostring(hit.Color))
                print("  锚定/碰撞 : "..tostring(hit.Anchored).." / "..tostring(hit.CanCollide))
                print("  透明度    : "..tostring(hit.Transparency))
                local at=hit:GetAttributes()
                local ak={} for k,v in pairs(at or {}) do ak[#ak+1]=k.."="..tostring(v) end
                if #ak>0 then table.sort(ak) print("  属性      : "..table.concat(ak,", ")) end
                print("  子级      : "..tostring(#hit:GetChildren()).." 个")
                print(string.rep("═",56))
            end)
        end))
        SYS.Notify("🔍 Ctrl+点击 看部件 已开启",SYS.CY.green)
    end
    UI.Switch(p,"🔍 Ctrl+点击 看部件信息 (只读, 排障用)","ClickInspect",function(on) P(SYS.SetClickInspect,on) end)
    UI.Tip(p,"按住 Ctrl 用鼠标左键点一个部件 -> 控制台打出它的名字/路径/类型/位置/材质/属性/子级数。\n纯只读, 不改任何东西。",CY.sub)
    UI.Section(p,"诊断",CY.sub)
    -- ★ v5.4.2(用户要求): 「🩺 一键诊断」按钮已删除(用户说没必要了)。
    --   函数本身保留: 需要时在控制台执行 `SYS.DiagUI()` 照样能把 UI/拖动/居中 的全部事实打出来。
    UI.Btn(p,"▶ 立即测试一次 (结果看控制台)",CY.green,function()
        if SYS.Combat and SYS.Combat.TestOnce then SYS.Combat.TestOnce() end
    end)
    UI.Btn(p,"📋 输出战斗诊断到控制台",CY.accent,function()
        if SYS.Combat and SYS.Combat.Diag then SYS.Combat.Diag() end
    end)
    UI.Tip(p,"不生效就先点「立即测试一次」: 它逐条打出 选没选到目标 / 相机转没转 /\nhook 装没装 / 准星在不在敌人身上 —— 一眼看出卡在哪一步。",CY.red)

    --========== 状态刷新 ==========
    -- ★ v53 性能: 2Hz 刷新 + 只在本页可见时更新(切走/关菜单完全空转)
    task.spawn(function()
        local lastScan,lastHud=0,0
        while card.Parent do
            task.wait(0.5)
            -- ★ v69 修「宣称只在可见时刷新, 实际一直在刷」: card.Visible 是自己这个控件的属性,
            --   父级页面切走(pg.Visible=false)时它【仍然是 true】-> 切到别的 tab 也在 2Hz 白刷。
            if card.Visible and p.Visible then
                for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
                local cb=SYS.Combat
                if cb then
                    local st=cb.Stat or {scan=0,hud=0}
                    -- ★ v72: hud 计数现在记的是"开火判定次数"(原来是叠加层刷新)
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
    -- ★★ 用户要求: 给这游戏(MachineParty)里的小游戏单独做一个页面, 页面名就用游戏名。
    --   依据是那份综合扫描: 小游戏 = DuckHunt / RightOfWay / Blindout / CrushHour / BumperMadness,
    --   场景区域 = Workspace.duck hunt / Workspace.Chisel Gauntlet / Lobby.MPStation_* / MPPadHost_*。
    UI.Section(p,"小游戏 · 透视",CY.accent)
    UI.Switch(p,"🎮 小游戏区域透视 (小游戏里的东西统一点亮, 亮黄绿)","ESP_Mini")
    UI.Tip(p,"判据 = 自己或最多 3 层祖先的名字命中: duck hunt / chisel / gauntlet / rightofway / blindout /\ncrushhour / bumpermadness / mpstation / mppadhost。开关一开, 控制台会打印【找到 N 个候选】。",CY.sub)
    UI.Section(p,"小游戏 · 状态",CY.sub)
    UI.Btn(p,"📋 列出小游戏脚本 & 场景(打到控制台)",CY.cyan,function()
        P(function()
            print("========== MachineParty 小游戏状态 ==========")
            local names={"MachinePartyDuckHunt","MachinePartyRightOfWay","MachinePartyBlindout",
                         "MachinePartyCrushHour","BumperMadness","MachinePartyActions","MachinePartyControlCard",
                         "MachinePartyLimitedStand","MachinePartyStationSigns","MachinePartyPadFocus","MachinePartyWorldUI"}
            local PS=SYS.LP and SYS.LP.PlayerScripts
            for _,n in ipairs(names) do
                local has=(PS and PS:FindFirstChild(n)) and "有" or "无"
                print(("  PlayerScripts.%-28s %s"):format(n,has))
            end
            local areas={"duck hunt","Chisel Gauntlet","Lobby","MPPadHost_LimitedDrop","MPPadHost_Vault100"}
            for _,n in ipairs(areas) do
                local o=WS:FindFirstChild(n)
                print(("  Workspace.%-28s %s"):format(n,o and "有" or "无"))
            end
            print("  相关 Remote: Sniper.Shoot / MachineParty.Event (见「综合扫描」A 层)")
            print("=============================================")
        end)
    end)
    UI.Btn(p,"🔍 探测小游戏里的可交互物(打到控制台)",CY.purple,function()
        P(function()
            print("========== 小游戏可交互物探测 ==========")
            local n1,n2=0,0
            for _,o in ipairs(WS:GetDescendants()) do
                local nm=tostring(o.Name):lower()
                if nm:find("chisel",1,true) or nm:find("duck",1,true) or nm:find("gauntlet",1,true) then
                    if o:IsA("ClickDetector") then n1=n1+1
                    elseif o:IsA("ProximityPrompt") then n2=n2+1
                    elseif o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then
                        print("  Remote: "..o:GetFullName())
                    end
                end
            end
            print(("  ClickDetector=%d  ProximityPrompt=%d"):format(n1,n2))
            print("=======================================")
        end)
    end)
    UI.Section(p,"敌我 / 队伍",CY.yellow)
    UI.Btn(p,"👥 敌我诊断 (打出每个玩家的队伍信号, 打到控制台)",CY.yellow,function()
        P(function()
            print("========== 敌我 / 队伍 诊断 ==========")
            print(("[1] 本机 Player.Team = %s"):format(tostring(SYS.LP and SYS.LP.Team and SYS.LP.Team.Name)))
            for _,pl in ipairs(Players:GetPlayers()) do
                local ap={}
                if type(pl.GetAttributes)=="function" then
                    local ok,t=pcall(function() return pl:GetAttributes() end)
                    if ok and type(t)=="table" then
                        for k,v in pairs(t) do
                            local lk=tostring(k):lower()
                            if lk:find("team") or lk:find("side") or lk:find("role") or lk:find("faction")
                               or lk:find("cell") or lk:find("group") or lk:find("party") then
                                ap[#ap+1]=k.."="..tostring(v)
                            end
                        end
                    end
                end
                table.sort(ap)
                print(("  %-22s Team=%-8s 可疑属性: %s"):format(
                    pl.Name, tostring(pl.Team and pl.Team.Name),
                    #ap>0 and table.concat(ap,", ") or "(无 team/side/role/cell 类属性)"))
            end
            print("  ↑ 把这几行发我, 我按真实字段接进透视的颜色判定")
            print("====================================")
        end)
    end)
    UI.Tip(p,"透视现在是: 队友=绿 / 敌人=红 / 幽灵(MPGhost)=紫。若所有人都红, 说明【队伍信号没读到】——\n点上面这个按钮把结果发我即可(这游戏的队伍字段名必须按实际数据接, 不能猜)。",CY.sub)
    -- ★★ 融合自 ChronixHub 的 InstantInteraction: 把 ProximityPrompt 的 HoldDuration 改成 0
    --   -> "按住 E 读条"变成"一按就成"。这是【纯客户端】的(只改你本地看到的提示时长),
    --   开关关掉会把原值写回; 新出现的 prompt 也会自动纳入(经 T() 登记, 卸载即断)。
    --   ★ 对"自动切割/自动交互"这类需求是基础件。
    local IPrompt={}      -- prompt -> 原始 HoldDuration
    function SYS.SetInstantPrompt(on)
        if not on then
            for p,v in pairs(IPrompt) do P(function() if p and p.Parent then p.HoldDuration=v end end) end
            IPrompt={}
            SYS.Notify("⚡ 瞬间交互 已关闭(时长已还原)",SYS.CY.sub)
            return
        end
        local function apply(p)
            if not p or IPrompt[p]~=nil then return end
            P(function()
                IPrompt[p]=p.HoldDuration
                p.HoldDuration=0
            end)
        end
        P(function()
            for _,v in ipairs(WS:GetDescendants()) do
                if v:IsA("ProximityPrompt") then apply(v) end
            end
        end)
        T(WS.DescendantAdded:Connect(function(d)
            if SYS.T_.InstantPrompt and d:IsA("ProximityPrompt") then apply(d) end
        end))
        -- 有人把它改回去就再压回 0(只在开关开着时)
        T((SYS.TT or function() end)(task.spawn(function()
            while SYS.T_.InstantPrompt and not SYS.Unloaded do
                for p in pairs(IPrompt) do
                    P(function() if p and p.Parent and p.HoldDuration~=0 then p.HoldDuration=0 end end)
                end
                task.wait(0.5)
            end
        end)))
        SYS.Notify("⚡ 瞬间交互 已开启(提示变成一按即用)",SYS.CY.green)
    end
    UI.Switch(p,"⚡ 瞬间交互 (按住读条变成一按即成, 纯客户端)","InstantPrompt",function(on) P(SYS.SetInstantPrompt,on) end)
    UI.Tip(p,"把游戏里 ProximityPrompt(按 E 的那种)的【按住时长】设成 0 -> 一按就用。\n只改你本地, 不改服务端; 关闭会把原时长写回。",CY.sub)
    UI.Section(p,"自动 / 辅助",CY.accent)
    UI.Tip(p,"⚠️ 「自动切割」等自动化功能【还没做】—— 不是不能做, 而是必须先知道这游戏【人是怎么操作的】:\n是鼠标点部件 / 按 E / 走上去碰? 切的是石料还是怪? 有没有次数?\n把玩法说一句, 或者点上面那个「探测」把结果发我, 我就能按真实信号做。",CY.yellow)
end
UI.Pages["设置"]=function(p)
    UI.Label(p,"配置",CY.green)
    UI.Label(p,SYS.has_fs_txt,SYS.HAS_FS and CY.green or CY.yellow)
    -- ★ v57: 用户要求去掉手动的"立即保存 / 立即加载"入口。
    --   保存与加载本身仍然是自动的: 改动任何开关会自动排队保存,
    --   下次加载脚本时自动读回并生效 —— 这里只是不再提供手动按钮。
    UI.Tip(p,"开关改动会自动保存, 下次加载脚本时自动生效(无需手动操作)。",CY.sub)
    UI.Div(p)

    --========== ★ v102 热键设置(移植: 点一下再按新键) ==========
    UI.Section(p,"热键设置 · 点一下再按新键",CY.cyan)
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
    -- ★ v3.10.0 强制相机视角
    UI.Switch(p,"🖱 打开菜单时接管鼠标 (显示鼠标 + 自由移动)","MenuMouse")
    UI.Tip(p,"开(默认) = 开菜单后把鼠标切回【显示 + 自由移动】(第一人称/锁鼠标的游戏里, 不这样菜单点不到)。\n关 = 【完全不碰】鼠标行为 —— 有些服务器每帧把鼠标锁回 LockCenter, 我们每帧抢回会和它互刷(鼠标抖动/不听使唤), 这种服务器上关掉更稳(但菜单可能点不到, 得用键盘/触屏)。",CY.sub)
    UI.Cycle(p,"强制视角",{"关","第一人称","第三人称"},
        function()
            local m=SYS.C_.ForceCam or "off"
            return (m=="first") and "第一人称" or ((m=="third") and "第三人称" or "关")
        end,
        function(v)
            SYS.C_.ForceCam=(v=="第一人称") and "first" or ((v=="第三人称") and "third" or "off")

    UI.Slider(p,"🔭 视野 FOV (70=原版, 越大看得越广)",60,180,1,function() return SYS.C_.CamFov or 70 end,function(v) SYS.C_.CamFov=v if SYS.SetCamFov then P(SYS.SetCamFov,v) end end,"%.0f")
    UI.Slider(p,"🔭 第三人称最远距离 (格)",20,500,10,function() return SYS.C_.CamZoom or 20 end,function(v) SYS.C_.CamZoom=v if SYS.SetCamZoom then P(SYS.SetCamZoom,v) end end,"%.0f")
    UI.Tip(p,"两个都是【纯客户端视觉】, 只改你自己看到的画面, 不碰任何别人; 卸载时会还原。\n第一人称想拉远没用(相机锁在头里) —— 拉远要先切【第三人称】。",CY.sub)            if SYS.SetForceCam then P(SYS.SetForceCam,SYS.C_.ForceCam) end
        end)
    UI.Tip(p,"强制视角 = 把相机锁成第一/第三人称(每 0.5s 兜底抢回, 防游戏脚本改回去)。\n第一人称 = 相机锁进角色头里; 第三人称 = 强制可拉远的经典视角。",CY.sub)
    --================ ★ v6.7.0 手机/平板界面适配 (用户反馈「菜单和字体太小」) ================
    UI.Div(p)
    UI.Section(p,"📱 界面缩放 (手机 / 平板适配)",CY.cyan)
    UI.Slider(p,"界面缩放 (0 = 自动适配)",0,2.5,0.05,
        function() return SYS.C_.UIScaleManual or 0 end,
        function(v)
            SYS.C_.UIScaleManual=v
            if SYS.ApplyUIScale then P(SYS.ApplyUIScale) end
        end,"%.2f")
    UI.Btn(p,"📐 恢复自动适配",CY.green,function()
        SYS.C_.UIScaleManual=0
        if SYS.ApplyUIScale then P(SYS.ApplyUIScale) end
        for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
        SYS.Notify("📐 已恢复自动适配",SYS.CY.green)
    end)
    UI.Btn(p,"🧪 打印设备与缩放信息 (控制台)",CY.purple,function()
        local D=SYS.DEV or {}
        local cam=WS.CurrentCamera
        local vp=(cam and cam.ViewportSize) or Vector2.new(0,0)
        local t={
            "=== 界面适配诊断 ===",
            ("视口         : %.0f x %.0f"):format(vp.X,vp.Y),
            ("触屏 / 纯触屏: %s / %s"):format(tostring(D.anyTouch),tostring(D.touch)),
            ("视口档位     : %s"):format(tostring(D.vds)),
            ("小屏适配     : %s"):format(tostring(D.small)),
            ("fit(可容纳)  : %s"):format(tostring(SYS.LastUIScaleFit)),
            ("自动结果     : %s"):format(tostring(SYS.LastUIScaleAuto)),
            ("当前实际缩放 : %s"):format(tostring(SYS.LastUIScale)),
            ("手动缩放值   : %s   (0 = 自动)"):format(tostring(SYS.C_.UIScaleManual)),
        }
        print(table.concat(t,"\n"))
        SYS.Notify("🧪 结果已打到控制台(F9)",SYS.CY.cyan)
    end)
    UI.Tip(p,"★ 默认「自动适配」: 按屏幕尺寸算出可用的最大倍数 ——\n"
        .."   手机 / 平板(纯触屏) 最多放大到 1.75 倍, 小视口 1.35 倍, PC 保持 1.0 倍。\n"
        .."   算法是 sc = min(fit, 上限), fit 已扣掉刘海 / 顶部栏边距 -> 【永远塞得进屏幕】。\n"
        .."★ 还是嫌小就往右拉滑块(会覆盖自动值); 想回到自动点「恢复自动适配」。\n"
        .."⚠ 手动拉得过大(超过 fit)菜单会超出屏幕、边角按钮点不到 —— 拉回来或点恢复自动即可。",CY.sub)
    UI.Btn(p,"🩹 回血 (走游戏自己的 remote)",CY.green,function() P(SYS.HealSelf) end)
    UI.Btn(p,"✨ 复活 (走游戏自己的 remote)",CY.green,function() P(SYS.ReviveSelf) end)
    UI.Btn(p,"♻ 重生 (Respawn)",CY.cyan,function() P(SYS.RespawnSelf) end)
    UI.Tip(p,"这三条都是【发游戏自己的 remote】—— 所以是服务端认可的真实生效, 不是客户端自欺(客户端改血会被服务端覆盖)。\n源: 事件库确认 EntityService.Heal / GameService.Revive / GameService.Respawn 存在。\n⚠️ 参数形式清单里没记, 先按无参发; 若某条没反应, 告诉我, 我按实际参数补。",CY.sub)
    -- ★★ 融合自 ChronixHub ConfigModule 的思路, 但按我们的配置规矩做(只认已声明的键):
    --   导出 = 把 C_(所有设置) 拼成一串放剪贴板; 导入 = 校验前缀 + 只回填【已知键】-> 不会写脏配置。
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
                if k and k~="" and SYS.C_[k]~=nil then      -- ★ 只回填【已声明】的键, 陌生键一律丢弃
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
    UI.Btn(p,"📤 导出全部配置到剪贴板",CY.cyan,function() P(SYS.ExportConfig) end)
    UI.Btn(p,"📥 从剪贴板导入配置 (只认已知项)",CY.purple,function()
        P(function()
            local str=nil
            if getclipboard then P(function() str=getclipboard() end) end
            if not str then SYS.Notify("这台没有 getclipboard —— 请用「导出」把串发我, 我手动帮你回填",SYS.CY.yellow) return end
            P(SYS.ImportConfig,str)
        end)
    end)
    UI.Tip(p,"导出 = 把你当前所有设置拼成一行放剪贴板(方便备份/换号); 导入 = 校验前缀后只回填【已声明】的键,\n陌生键一律丢弃(和我们配置加载的规矩一致, 不会写脏配置)。",CY.sub)
    UI.Btn(p,"🔄 重进服务器 (Rejoin)",CY.purple,function()
        SYS.Notify("正在重进服务器...",CY.purple)
        SYS.Rejoin()
    end)
    UI.Div(p)
    -- ★ v4.8.1: 「🫥 深度隐藏菜单」整个删掉(用户要求: "深度隐藏没用, 删了")。
    --   它把菜单挂到执行器的 gethui 容器 -> 那个容器不保证全屏 -> 菜单跑到左上角/被压小。
    --   现在固定挂 CoreGui(见 SYS.SafeParentGui), 位置永远正常, 界面里不再需要这个开关。
    UI.Div(p)
    UI.Switch(p,"🔁 有新版本时自动热重载","AutoUpdateCheck")
    UI.Tip(p,"★ 每次启动都会检查一次新版本；检查到就会弹消息告诉你【新版本号】。\n本开关只决定「要不要自动升级」：开着=直接热重载到新版；关掉=只提示不升级，想升级再点上面的按钮。",CY.sub)
    UI.Btn(p,"⬆️ 检查更新并热重载",CY.green,function() P(function() SYS.CheckUpdate(false) end) end)
    UI.Tip(p,"热重载 = 先保存当前配置(含所有开关) -> 卸载旧实例 -> 拉取新版 -> 加载。\n新实例启动时会自动按配置把开关开回来, 所以你会看到功能自己恢复。")
    -- ★ v124(用户要求): 加载时检查 —— 与上面的"会话内热重载"是两件事
    UI.Switch(p,"🚀 重新加载时先检查新版本","BootUpdateCheck")
    UI.Tip(p,"★ 管的是【刚加载的那一瞬间】: 退出游戏 / 卸载脚本后重新注入时, 先看一眼仓库有没有新脚本。\n有 -> 直接用新版启动(启动后会弹「已更新 x → y」); 没有 -> 正常打开。\n好处: 你永远不会先看到旧版界面再被换掉。检查在界面建立之前完成, 取不到版本号(离线 / 执行器没有 HttpGet)就照常打开, 绝不挡路。",CY.sub)
    UI.Div(p)
    UI.Btn(p,"🗑️ 卸载脚本 (干净退出)",CY.red,function()
        SYS.Notify("正在卸载...",CY.red)
        task.delay(0.1,function() P(SYS.UnloadAll) end)
    end)
    UI.Tip(p,"卸载 = 关掉全部功能 + 销毁菜单 + 恢复相机/控制; 不会重进服务器、不会断开连接。\n换服务器用上面的「重进服务器」。(之前报 277 被踢, 是点到重进服务器了, 不是卸载)",CY.sub)
end

--============================================================

--============================================================
-- [14.9] v6.7.0 新增页面: 玩家(动手类) / 整蛊工具
--============================================================
UI.Pages["玩家"]=function(p)
    UI.Section(p,"选择目标",CY.cyan)
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
    UI.Section(p,"传送类 (只把你送过去 / 拉过来)",CY.green)
    UI.Btn(p,"🚀 传送到他",CY.green,function() SYS.PC.GotoTarget("tp") end)
    UI.Btn(p,"🎯 缓动到他 (1.2 秒滑过去)",CY.purple,function() SYS.PC.GotoTarget("tween") end)
    UI.Btn(p,"🚶 寻路/步行到他",CY.cyan,function() SYS.PC.GotoTarget("walk") end)
    UI.Switch(p,"🔁 循环跟传 (离远了自动再过去)","PC_LoopTP",function(on) SYS.PC.LoopTP(on) end)
    UI.Btn(p,"🧲 把他拉过来 (客户端)",CY.orange,function() SYS.PC.BringTarget() end)
    UI.Tip(p,"带「客户端」字样的按钮只改你本地看到的画面 —— 服务端不认, 他本人没感觉, 而且很快会被拉回。\n这是引擎机制(客户端无权改别人角色), 不是脚本没生效。",CY.sub)

    UI.Div(p)
    UI.Section(p,"控制类 (全部只写本地副本)",CY.orange)
    UI.Switch(p,"🧊 冻结他 (客户端)","PC_Freeze",function(on) SYS.PC.Freeze(on) end)
    UI.Btn(p,"⚡ 闪现半秒 (客户端)",CY.purple,function() SYS.PC.Blink(0.5) end)
    UI.Switch(p,"🗣 本地静音他 (只静音他角色里的音效)","PC_Mute",function(on) SYS.PC.MuteVoice(on) end)
    UI.Tip(p,"⚠ 客户端【没有】静音他人语音的公开 API —— 这条只能静音他角色里的 Sound。\n「冻结 / 闪现 / 拉过来」同理: 只改你本地副本。",CY.yellow)

    UI.Div(p)
    UI.Section(p,"跟随 / 环绕类 (动的是你自己)",CY.purple)
    UI.Switch(p,"🎩 坐他头上","PC_OnHead",function(on) SYS.PC.OnHead(on) end)
    UI.Switch(p,"🌀 绕着他旋转","PC_Orbit",function(on) SYS.PC.Orbit(on) end)
    UI.Slider(p,"旋转速度",0.5,12,0.5,function() return SYS.C_.PC_SpinSpeed end,
        function(v) SYS.C_.PC_SpinSpeed=v end,"%.1f")
    UI.Slider(p,"环绕距离 (格)",2,30,1,function() return SYS.C_.PC_Range end,
        function(v) SYS.C_.PC_Range=v end,"%.0f")
    UI.Switch(p,"👁 盯着他 (相机锁死在他身上)","PC_Stare",function(on) SYS.PC.Stare(on) end)
    UI.Switch(p,"🚶 行走跟随","PC_Follow",function(on) SYS.PC.Follow(on) end)

    UI.Div(p)
    UI.Section(p,"好友",CY.cyan)
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

    -- 每 0.5 秒刷新一次信息条(距离会变)
    SYS.SpawnLoop(function()
        while not SYS.Unloaded do
            task.wait(0.5)
            if SYS.PCRender then P(SYS.PCRender) end
        end
    end)
end

UI.Pages["整蛊"]=function(p)
    UI.Section(p,"目标",CY.orange)
    UI.Input(p,"玩家名 (留空 = 用「玩家」页选中的那位)","",
        function() return SYS.C_.PG_Target or "" end,
        function(v) SYS.C_.PG_Target=v end)
    UI.Btn(p,"🌀 甩飞这个玩家",CY.orange,function()
        local pl=SYS.PG.Target()
        if pl and SYS.PG.Fling(pl) then
            SYS.Notify("🌀 已甩飞 "..pl.Name.."(本地)",SYS.CY.orange)
        else
            SYS.Notify("没找到目标 —— 先在「玩家」页选人, 或在这里填名字",SYS.CY.sub)
        end
    end)
    local function flingAllLoop(on)
        SYS.T_.PG_FlingAll=on==true
        if not on then SYS.SetLoop("PGFlingAll",false) return end
        SYS.SetLoop("PGFlingAll",true,RS.Heartbeat,function()
            if SYS.T_.PG_FlingAll~=true then return end
            if not SYS.PG._lastAll or (os.clock()-SYS.PG._lastAll)>0.5 then
                SYS.PG._lastAll=os.clock()
                SYS.PG.FlingAll()
            end
        end)
    end
    UI.Switch(p,"🔁 持续甩飞全部玩家 (每 0.5 秒一轮)","PG_FlingAll",flingAllLoop)
    UI.Tip(p,"⚠ 整蛊工具全部只写【你本地的副本】: 对方屏幕上不会动, 服务端也不认 —— 但你会看到他被甩飞。\n这是引擎机制(客户端无权改别人角色), 不是脚本没生效。",CY.yellow)

    UI.Div(p)
    UI.Section(p,"旋转 / 击飞",CY.purple)
    UI.Slider(p,"旋转速度",1,30,1,function() return SYS.C_.PG_SpinSpeed end,
        function(v) SYS.C_.PG_SpinSpeed=v end,"%.0f")
    UI.Switch(p,"🌀 开始旋转 (所有玩家原地打转)","PG_Spin",function(on) SYS.PG.Spin(on) end)
    UI.Switch(p,"🌀↑ 旋转击飞","PG_SpinHit",function(on) SYS.PG.SpinHit(on) end)
    UI.Switch(p,"🚀 飞行击飞","PG_FlyHit",function(on) SYS.PG.FlyHit(on) end)
    UI.Switch(p,"🚶 走路击飞 (靠近谁谁飞)","PG_WalkHit",function(on) SYS.PG.WalkHit(on) end)
    UI.Switch(p,"🫥 隐身击飞 (自己透明 + 靠近就飞)","PG_HideHit",function(on) SYS.PG.HideHit(on) end)

    UI.Div(p)
    UI.Section(p,"工具环绕 / 附着",CY.cyan)
    UI.Switch(p,"🛠 环绕工具 (手里道具绕自己转)","PG_OrbitTool",function(on) SYS.PG.OrbitTool(on) end)
    UI.Slider(p,"环绕范围 (格)",2,30,1,function() return SYS.C_.PG_OrbitRange end,
        function(v) SYS.C_.PG_OrbitRange=v end,"%.0f")
    UI.Slider(p,"环绕速度 (度/秒)",10,360,10,function() return SYS.C_.PG_OrbitSpeed end,
        function(v) SYS.C_.PG_OrbitSpeed=v end,"%.0f")
    UI.Input(p,"要附着的玩家名","",function() return SYS.C_.PG_Attach or "" end,
        function(v) SYS.C_.PG_Attach=v end)
    UI.Btn(p,"🧲 把工具附着到他身上 (客户端)",CY.orange,function()
        SYS.PG.AttachToolTo(SYS.C_.PG_Attach)
    end)
    UI.Btn(p,"📌 把工具钉在脚下",CY.purple,function()
        local ch=LP.Character
        local t=ch and ch:FindFirstChildOfClass("Tool")
        local h=t and (t:FindFirstChild("Handle") or t:FindFirstChildWhichIsA("BasePart"))
        if not h then SYS.Notify("手里没有工具",SYS.CY.sub) return end
        local _,_,r=GC()
        P(function()
            h.Anchored=true
            if r then h.CFrame=CFrame.new(r.Position+Vector3.new(0,-2,0)) end
        end)
        SYS.Notify("📌 工具已钉在脚下",SYS.CY.purple)
    end)

    UI.Div(p)
    UI.Section(p,"黑洞 (把附近的人和物吸过来)",CY.purple)
    UI.Switch(p,"🕳 开启黑洞","PG_BlackHole",function(on) SYS.PG.BlackHole(on) end)
    UI.Slider(p,"范围 (格)",10,200,5,function() return SYS.C_.PG_BH_Range end,
        function(v) SYS.C_.PG_BH_Range=v end,"%.0f")
    UI.Slider(p,"中心高度 (格 · 0=脚底)",0,200,5,function() return SYS.C_.PG_BH_Height end,
        function(v) SYS.C_.PG_BH_Height=v end,"%.0f")
    UI.Slider(p,"吸引力",10,500,10,function() return SYS.C_.PG_BH_Pull end,
        function(v) SYS.C_.PG_BH_Pull=v end,"%.0f")

    UI.Div(p)
    UI.Section(p,"近距离击杀",CY.red)
    UI.Switch(p,"☠ 击杀贴着你的人","PG_KillNear",function(on) SYS.PG.KillNear(on) end)
    UI.Slider(p,"距离 (格)",1,40,1,function() return SYS.C_.PG_KillDist end,
        function(v) SYS.C_.PG_KillDist=v end,"%.0f")
    UI.Tip(p,"「击杀」只在【你本地】把对方 Humanoid.Health 写成 0 —— 服务端不认, 对方不死。\n真要击杀请用「战斗」页(走游戏自己的伤害链路)。",CY.yellow)
end

-- [15] 创建菜单
--============================================================
local function GetGuiParent()
    -- ★★ v5.2.2 定案：菜单统一挂 **PlayerGui**。
    --   理由(用户日志实测): 挂 CoreGui 时菜单【真的会偏】(缩放 1.00 下 Y 差 58px + 顶部被切),
    --   而 PlayerGui 是引擎保证全屏、原点就在屏幕左上角的容器 —— 公开 UI 库的最终兜底也是它。
    --   另外之前"自检挪到 PlayerGui、SafeParentGui 又挪回 CoreGui"两处打架, 现在只留一条路。
    return PG
end

-- ★ v121 「反检测 · 基础版」(用户要求: 高级做法办不到, 就把普通版做进去)
--   游戏自己的本地反作弊最常见的两招: ①遍历 PlayerGui 找可疑 GUI(按名字/结构/大小) ②本地脚本直接踢人。
--   下面做两件"不需要高级 hook 也能做"的事:
--   ① SafeParentGui: 把我们的 GUI 挂到【普通脚本遍历不到】的容器(gethui > CoreGui > PlayerGui 兜底),
--      并尽量打上执行器的"保护"标记。⚠️ 只是降低被扫到的概率, 不是隐身; 服务端反作弊完全不受影响。
--   ② TryAntiKick: 拦【本地发起的 Kick】。⚠️ 服务端踢人拦不住(那是服务端断连, 客户端改不了任何东西)。
function SYS.SafeParentGui(gui)
    if not gui then return "nil" end
    P(function() if protect_gui then protect_gui(gui) end end)
    P(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    -- ★★ v5.2.2 定案：**默认挂 PlayerGui**。
    --   用户日志铁证: 挂在 CoreGui 时菜单【真的偏】(缩放=1.00 时 Y 差了 58px, 顶部还被切掉),
    --   而 PlayerGui 是引擎保证【全屏、原点在屏幕左上角】的那个容器 —— 也是公开 UI 库最终的兜底选择。
    --   之前还踩过一次：我的"位置自检"把它挪到 PlayerGui, 随后这里的 CoreGui 分支又把它挪回去,
    --   **两处在打架**, 位置自然废掉。现在只留一条路: PlayerGui。
    --   (反检测那点收益远不如"菜单位置一定正确"重要 —— 用户实测过好几轮了。)
    P(function() gui.Parent=SYS.PG end)
    if gui.Parent then return "PlayerGui" end
    -- PlayerGui 万一写不进去(极少数执行器), 再退 CoreGui 兜底
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
        -- 常见姿势: 把 Player:Kick 换成空函数 -> 本地脚本调它就没反应了
        hookfunction(lp.Kick,function() return nil end)
        SYS.KickHooked=true
    end)
    if ok and SYS.KickHooked then
        print("[CheatMenu] 防踢已启用(只拦本地 Kick; 服务端踢人拦不住)")
        return "已启用"
    end
    return "不可用"
end

local function CreateMenu()
    print("[CheatMenu] CreateMenu 开始")
    if SYS.ScreenGui then pcall(function() SYS.ScreenGui:Destroy() end) SYS.ScreenGui=nil end
    local sg=Instance.new("ScreenGui")
    sg.Name="CheatMenuV52" sg.ResetOnSpawn=false sg.IgnoreGuiInset=true
    -- ★★ v5.2.3 修「菜单纵向差 58px」的真凶(用户日志实测: 缩放=1.00 时 期望Y=208 实际Y=150):
    --   反推可知 ScreenGui 的可用高度只有 1080-2×58 = 964 —— 也就是【它被"安全区"上下各让出 58px】,
    --   菜单在那个缩小区域里居中, 所以整体偏上(而且顶部会被切掉一点)。
    --   `IgnoreGuiInset` 只管旧的顶部栏; 新的安全区是 `ScreenInsets` -> 设成 **None = 用整块视口**,
    --   这样锚点居中算出来就是真正的屏幕中心(545,208)。
    P(function() sg.ScreenInsets=Enum.ScreenInsets.None end)
    -- ★ v78 防"注入后还是旧版/出现两个菜单":
    --   旧实例理论上被 GENV.CheatUnload 卸载(文件第 14 行), 但如果那个旧实例是更早的版本
    --   (没注册过卸载钩子), 或者执行器的 getgenv 不共享, 旧菜单就会留在屏幕上 ——
    --   这时你看到的是旧界面, 会以为"没更新成功"。这里按名字把旧残骸清掉, 只留新建的这个。
    P(function()
        local roots={SYS.PG,SYS.CoreGui}
        if gethui then local h=gethui() if h then roots[#roots+1]=h end end
        local killed=0
        for i=1,#roots do
            local r=roots[i]
            if r then
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
    -- ★ v4.7.0 修「手机上菜单跑角落/偏位」的真根因:
    --   原来用 (0.5,-W/2, 0.5,-H/2) 居中 —— 靠【Offset 偏移】实现的。
    --   而 UIScale 会把 Position 的 Offset 一起缩放 -> 偏移量变小 -> 菜单越缩越偏。
    --   改成【锚点居中】(AnchorPoint 0.5,0.5 + Position 全用 Scale), 缩放不影响它, 永远居中。
    main.AnchorPoint=Vector2.new(0.5,0.5)
    main.Position=UDim2.new(0.5,0,0.5,0)
    main.BackgroundColor3=CY.bg main.BackgroundTransparency=0.06
    main.BorderSizePixel=0 main.ClipsDescendants=true main.Parent=sg
    UI.Round(main,16)
    UI.Grad(main,CY.bg2,CY.bg,90)
    UI.Stroke(main,CY.accent,1,0.72)

    -- 顶部霓虹条(发光)
    local accentBar=Instance.new("Frame")
    accentBar.Size=UDim2.new(1,0,0,4) accentBar.BackgroundColor3=Color3.new(1,1,1)
    accentBar.BorderSizePixel=0 accentBar.ZIndex=100 accentBar.Parent=main
    UI.NeonGrad(accentBar)

    -- ★ v108 手机/平板自适应(参考 Roblox 官方跨平台指南 + 开源 UI 库的做法):
    --   ① 设备检测: TouchEnabled(纯触屏=手机/平板) + ViewportDisplaySize(Small/Medium/Large)
    --   ② SafeArea: 用 GuiService:GetGuiInset() 留出刘海/圆角/顶部栏的边距
    --   ③ 触摸友好: 手机/平板允许【放大】到 1.25(小屏字太小), 且缩放下限抬到 0.75
    --      (原来只缩不放、下限 0.55 -> 手机上菜单缩成一小块, 按钮小到点不准)
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
    SYS.DEV=DEV                       -- ★ v6.7.0: 设置页诊断要读设备档位

    -- 缩放适配
    local scale=Instance.new("UIScale") scale.Parent=main
    local function ApplyScale()
        P(function()
            local cam=WS.CurrentCamera
            local vp=cam and cam.ViewportSize or Vector2.new(1280,720)
            if vp.X<10 or vp.Y<10 then vp=Vector2.new(1280,720) end
            -- ★ SafeArea: 顶部栏/刘海高度也算进去(手机横屏时尤其明显)
            local pad=DEV.small and 28 or 40
            pcall(function()
                local gs=game:GetService("GuiService")
                -- ★ GetService 在桩环境/部分执行器里可能返回 nil, 不能直接索引(否则被 pcall 吞掉)
                if gs then
                    local ok1,i1,i2=pcall(function() return gs:GetGuiInset() end)
                    if ok1 and i1 then pad=pad+(i1.Y or 0)+(i2 and i2.Y or 0) end
                end
            end)
            local fit=math.min((vp.X-pad*2)/W,(vp.Y-pad*2)/H)
            -- ★ v120 修「手机/平板上菜单太大、右边按钮点不到」:
            --   旧逻辑 hi=1.25 + lo=0.75 —— 真正让按钮点不到的是【下限 0.75】:
            --   sc = min(fit, hi) 且 fit 已按屏幕算过 -> sc<=fit 永远塞得进;
            --   是旧代码 "if sc<lo then sc=lo end" 在小屏把 sc 强行抬到 0.75 -> 超出屏幕。
            -- ★ v6.7.0 手机/平板适配修正(用户反馈「手机上菜单和字体太小, 完全看不清」):
            --   v120 把"能放大"也一起砍了(上限恒 1) -> 手机/平板永远停在 1.0 倍, 字太小。
            --   现在恢复放大能力, 只按设备给上限; 因为仍是 sc=min(fit,hi) 且 fit 已扣掉
            --   刘海/顶部栏边距, 所以【任何情况下都不会超出屏幕】, 不会重新引入"点不到"。
            --     纯触屏(手机/平板): 1.75   |   小视口: 1.35   |   其余(PC): 1.0
            --   另: 设置页「界面缩放」可手动覆盖(0 = 自动适配)。
            local hi=1.0
            if DEV.touch then hi=1.75
            elseif DEV.small then hi=1.35 end
            local lo=0.30
            local man=tonumber(SYS.C_.UIScaleManual) or 0
            local sc
            if man>0 then
                sc=math.clamp(man,0.30,3.0)     -- 手动值: 用户自己定(拉太大就超出屏幕, 见设置页提示)
            else
                sc=math.min(fit,hi)
                if sc<lo then sc=lo end
            end
            scale.Scale=sc
            SYS.LastUIScale=sc
            SYS.LastUIScaleFit=fit
            SYS.LastUIScaleAuto=math.min(fit,hi)
            -- ★★ v5.2.3(用户明确要求「删掉那个自检, 恢复最初的默认居中」):
            --   这里【不再做任何"位置自检 / 自动回中"】—— 恢复原版行为:
            --   **建菜单时定一次位置, 之后只改缩放**。最简单, 也最不容易出错。
            --   (旧自检会在"误判"时把菜单挪走 -> 越修越歪:
            --    用户实测日志 建完菜单(545,150) -> 自检后(130,-182); 而且我拿写死的 H 算期望值本身就错。)
            --   手动拖歪了想回正中 —— 用标题栏那个 ⊙ 按钮, 或者重开菜单。
        end)
    end
    SYS.ApplyUIScale=ApplyScale       -- ★ v6.7.0: 设置页「界面缩放」滑块要用
    ApplyScale()
    local cam0=WS.CurrentCamera
    -- ★ v64 修「死亡/重生瞬间开菜单 -> CreateMenu 炸成空壳」:
    --   重生瞬间 CurrentCamera 可能是【已销毁】的旧实例, 对它调 GetPropertyChangedSignal
    --   会返回 nil(执行器行为), 链式 ".Connect" 直接把 CreateMenu 炸断 —— 菜单只剩黑框,
    --   所有开关点不了, 战斗功能全没生效。链式调用全部改 pcall 防御, 失败就跳过监听。
    if cam0 then
        local okS,sig=P(function() return cam0:GetPropertyChangedSignal("ViewportSize") end)
        if okS and sig and type(sig.Connect)=="function" then
            local okC,conn=P(function() return sig:Connect(ApplyScale) end)
            if okC and conn then T(conn) end
        end
    end

    --============ 顶部栏 ============
    -- ★★ v4.9.1 拖动把手改用【TextButton】，不再用 Frame:
    --    原来 top 是 Frame —— Frame 想收输入必须靠 `Active=true`, 而这个属性在不同执行器 /
    --    不同 ZIndex 叠放下的行为并不一致(用户实测: 给了 Active=true 仍然拖不动)。
    --    **按钮(TextButton)天生就接收输入**, 不依赖任何属性、不用猜 —— 这是最稳的写法。
    local top=Instance.new("TextButton")
    top.Size=UDim2.new(1,0,0,62) top.BackgroundTransparency=1
    top.Text="" top.AutoButtonColor=false top.Active=true top.Parent=main

    local logo=Instance.new("TextLabel")
    logo.Size=UDim2.new(0,220,1,0) logo.Position=UDim2.new(0,24,0,0)
    logo.BackgroundTransparency=1 logo.Text="CHEATMENU"
    logo.TextColor3=CY.text logo.Font=Enum.Font.GothamBold logo.TextSize=19
    logo.TextXAlignment=Enum.TextXAlignment.Left logo.Parent=top
    -- 霓虹发光描边(青→紫渐变)
    local logoS=Instance.new("UIStroke")
    logoS.Color=CY.accent logoS.Thickness=1 logoS.Transparency=0.35
    logoS.ApplyStrokeMode=Enum.ApplyStrokeMode.Border logoS.Parent=logo

    local verTag=Instance.new("TextLabel")
    verTag.Size=UDim2.new(0,90,0,18) verTag.Position=UDim2.new(0,168,0.5,-9)
    verTag.BackgroundColor3=CY.accent verTag.BackgroundTransparency=0.75
    -- ★ v78: 这里原来写死 "v68 · BATTLE" —— 结果换了新版屏幕上还写着 v68, 谁都以为没更新成功。
--   现在显示真实构建版本: 本地版是 local-YYYYMMDD-HHMM, 网络版是源码 sha 前 10 位。
-- ★ v79 用户反馈"版本号太长了" -> 这里只显示【短】的:
--   本地版 local-YYYYMMDD-HHMM -> "本 HHMM"; 网络版(源码 sha 前 10) -> "#" + 前 6 位
--   完整版本号仍然打在控制台(加载完成那一行), 要核对时看控制台就行。
local _bv=tostring(SYS.BuildVer or "?")
local _short
-- ★ v86: 语义化版本(1.0 -> 1.1 -> ... -> 1.10 -> 2.0)直接显示; 旧格式兼容
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

    --============ 侧栏 ============
    local side=Instance.new("Frame")
    side.Size=UDim2.new(0,154,1,-78) side.Position=UDim2.new(0,14,0,68)
    side.BackgroundColor3=CY.panel side.BackgroundTransparency=0.32
    side.BorderSizePixel=0 side.Parent=main
    UI.Round(side,12) UI.Stroke(side,CY.line,1,0.82)
    UI.Grad(side,CY.card2,CY.panel,135)   -- 玻璃拟态渐变

    -- 选中指示条(霓虹渐变 + 发光, 滑动动画)
    local ind=Instance.new("Frame")
    ind.Size=UDim2.new(0,3,0,22) ind.Position=UDim2.new(0,0,0,15)
    ind.BackgroundColor3=CY.accent ind.BorderSizePixel=0 ind.Visible=false
    ind.Parent=side UI.Round(ind,2)
    UI.NeonGrad(ind)

    -- ★ v102 移植(参考 1.txt UI 库的搜索): 侧栏底部搜索框, 过滤【当前页】的控件行。
    --   放底部 = 不动现有 tab 布局(零回归风险)。
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

    -- ★ v54 性能: 页面改成"第一次切到才构建"。
    --   原来 CreateMenu 会一次性把 8 个页面全部建出来 —— 上千个实例, 每页还各带一个
    --   UIListLayout, 打开菜单那一瞬间全部要参与布局计算, 这是"菜单卡一下"的主因。
    --   现在只建当前页, 切到哪个建哪个(建过就缓存)。
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
                -- ★ v68.9 构建【失败】要允许重试: 之前 built[name]=true 已设置,
                --   失败的页面以后永远空白(切回去也不重建)。失败则重置, 下次切换重试。
                built[name]=false
                warn(("[CheatMenu] 页面 %s 构建失败(切走再切回会重试): %s"):format(name,tostring(err)))
            else
                print("[CheatMenu] 页面 "..name.." OK")
            end
        end
    end
    SYS.EnsurePage=ensurePage

    local function ShowTab(name)
        if SYS.CloseActiveDropdown then pcall(SYS.CloseActiveDropdown) end -- ★ v68.8 切页关闭下拉浮层
        ensurePage(name)                       -- 先确保建好, 再切过去
        SYS.ActiveTabName=name                 -- ★ v102 搜索需要知道当前页
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
        -- ★ v102 切页后重应用当前搜索词(新页面的元素 _sv 是新的)
        if SYS.SearchText and SYS.SearchText~="" then P(SYS.ApplySearch,SYS.SearchText) end
    end
    SYS.ShowTab=ShowTab

    -- ★ v102 搜索实现: 遍历当前页的直接子元素(每个组件=一行), 文本不含关键词就隐藏。
    --   页面的 UIListLayout 会自动收拢 -> 看起来就是"只剩匹配项"; 清空搜索即恢复。
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

    --============ 生成 tab + 页面 ============
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

        -- v54: 页面构建已延后到"第一次切到它"(见上面的 ensurePage), 这里不再立即构建
    end

    --============ 底部提示 ============
    local foot=Instance.new("TextLabel")
    foot.Size=UDim2.new(1,-40,0,16) foot.Position=UDim2.new(0,24,1,-22)
    foot.BackgroundTransparency=1
    foot.Text="G/右Shift 开关菜单    ·    V 切换指定目标"
    foot.TextColor3=CY.sub foot.Font=Enum.Font.GothamMedium foot.TextSize=11
    foot.TextXAlignment=Enum.TextXAlignment.Left foot.Parent=main

    --============ 拖动(★ v120: 鼠标 + 触屏 都支持) ============
    -- ★ 旧实现只认 MouseButton1 / MouseMovement -> 手机平板上【根本没鼠标事件, 菜单拖不动】(用户实测)
    local drg,dS,fS=false,nil,nil
    -- ★ v4.6.0: 手机上根本【没有】鼠标事件 —— 原来只认 MouseButton1/MouseMovement,
    --   所以手机上一个都拖不动(用户实测)。补上 Touch(触摸屏的按下/移动都是 Touch)。
    local function isGrab(i)
        return i.UserInputType==Enum.UserInputType.MouseButton1
            or i.UserInputType==Enum.UserInputType.Touch
    end
    local function isMove(i)
        return i.UserInputType==Enum.UserInputType.MouseMovement
            or i.UserInputType==Enum.UserInputType.Touch
    end
    -- ★ v4.9.1 拖动补偿: UIScale 会把 Position 的 Offset **一起缩放** —— 直接加 d 会出现
    --   "鼠标走了 100px, 菜单只走 60px"(拖不满/不跟手)。除以当前 scale 就是 1:1 跟手。
    local function curScale()
        local ok,v=pcall(function() return scale.Scale end)
        local n=(ok and tonumber(v)) or 1
        if not n or n<=0 then n=1 end
        return n
    end
    -- ★★★ v5.4.0 【绝对可靠的拖动】(用户最高优先要求: 全设备 / 全平台都必须能拖)
    --   旧写法 `top.InputBegan` 的致命弱点: 它要求【标题栏自己收到这次输入】——
    --   而这会被 z 序 / Active / 被别的控件盖住 / 执行器差异影响(前面已经栽过好几次)。
    --   新写法 = 【全局监听 + 自己算矩形】:
    --     任何平台、任何一次按下(鼠标 / 手指), 只要按下的点**落在标题栏矩形里**, 就进入拖动。
    --     ★ 不再依赖"标题栏能不能收到事件" —— 只要能按下, 就能拖。
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
    T(UIS.InputBegan:Connect(function(input,gp)
        -- ★ 必须【先判存在】再取值: 桩环境/部分执行器给的 input 可能没有 Position,
        --   直接索引会报错(那会被门禁记成"被 pcall 吞掉的错误" -> 拒绝发行)。
        --   这里不用 pcall 掩盖, 而是老老实实判空。
        if not input or not input.Position then return end
        P(function()
            -- ★★ v5.4.2 删掉原来的 `if gp then return end` —— 它是"拖不动"的最后一根挡路石:
            --   `gp`(gameProcessedEvent)=true 表示"这次输入已被 GUI 处理", 而**按在我们自己的
            --   标题栏上时它正好就是 true** -> 于是每次都被它挡掉, 永远进不了拖动。
            --   我们本来就靠【点是否落在标题栏矩形里】来判定, 这个判断已经足够精确, 不需要 gp。
            if not SYS.MenuOpen then return end
            if not isGrab(input) then return end
            local pos=input.Position
            if not inRect(pos, top) then return end
            if onTitleBtn(pos) then return end    -- 标题栏上的按钮不参与拖动
            drg=true dS=pos fS=main.Position
            SYS._UserMoved=true      -- 用户手动拖过 -> 记下来
        end)
    end))
    T(UIS.InputChanged:Connect(function(input)
        if drg and isMove(input) then
            local d=input.Position-dS
            local sc=curScale()
            main.AnchorPoint=Vector2.new(0.5,0.5)   -- 保证和"居中"用的是同一套锚点
            main.Position=UDim2.new(fS.X.Scale,fS.X.Offset+d.X/sc,fS.Y.Scale,fS.Y.Offset+d.Y/sc)
        end
    end))
    T(UIS.InputEnded:Connect(function(input)
        if isGrab(input) then drg=false end
    end))

    --============ ★ v120 收起/展开(手机/平板把菜单缩成一条标题栏, 免得挡住游戏) ============
    local collapseBtn=Instance.new("TextButton")
    collapseBtn.Size=UDim2.new(0,34,0,34) collapseBtn.Position=UDim2.new(1,-96,0.5,-17)
    collapseBtn.BackgroundColor3=CY.panel collapseBtn.BackgroundTransparency=0.25
    collapseBtn.Text="▬" collapseBtn.TextSize=18 collapseBtn.TextColor3=CY.text
    collapseBtn.Font=Enum.Font.GothamBold collapseBtn.BorderSizePixel=0
    collapseBtn.Parent=top
    P(function() local r=Instance.new("UICorner") r.CornerRadius=UDim.new(1,0) r.Parent=collapseBtn end)
    -- ★ v5.4.2(用户要求): 标题栏上的 **`⊙` 一键居中按钮已删除** —— 用户不需要它。
    --   居中由「锚点居中 + 打开动画不再动 Position」保证(见 v5.4.1 的真根因修复),
    --   拖歪了想回正中: 重开一次菜单即可。
    --   (保留 SYS.CenterMenu 这个函数本身, 需要时可在控制台调 SYS.CenterMenu(); 只是不再有界面入口。)
    function SYS.CenterMenu()
        SYS._UserMoved=false
        main.AnchorPoint=Vector2.new(0.5,0.5)
        main.Position=UDim2.new(0.5,0,0.5,0)
        P(ApplyScale)
    end
    -- ★ 登记标题栏上的按钮 —— 全局拖动会跳过落在它们身上的按下(免得一按就跟着走)
    SYS.CM_TitleBtns={closeBtn,collapseBtn}

    -- ★★ v5.2.3【「位置自检」整块删掉】(用户明确要求: "你就不能彻底删除那个B玩意吗, 直接恢复最初的默认中间")
    --   删掉的原因(有实测证据):
    --     · 判据本身是错的: 拿写死的 W/H 算"期望位置", 而菜单实际尺寸不等于它 -> 算出的偏差是假的;
    --     · 判成"偏了"之后它会【把菜单挪走】-> 原本 (545,150) 变成 (130,-182), **越修越歪**;
    --     · 它还会和 SafeParentGui 抢父容器(一个挪到 PlayerGui, 另一个挪回 CoreGui)。
    --   现在的行为 = **最初的默认**: 建菜单时用锚点居中定一次位置, 之后只改缩放, 谁都不再动它。
    --   想回正中: 标题栏的 ⊙ 按钮。
    -- ★★★ v5.4.0 【一键诊断】(用户要求: "把东西一键全部扫描出来给你处理, 而不是我自己观察和记录")
    --   一次把 UI / 拖动 / 居中 相关的【全部事实】扫出来: 打印到控制台 + 写进文件(能写的话)。
    --   ★ 重点: 做【标题栏命中测试】—— 按在标题栏正中那个点上, 究竟是谁在最上层。
    --     这是"拖不动"的头号嫌疑(标题栏被别人盖住 -> 按下收不到)。
    SYS.MenuMain=main
    function SYS.DiagUI()
        local L={}
        local function A(f,...) L[#L+1]="  "..(select("#",...)>0 and f:format(...) or f) end
        A("=========== CheatMenu UI 诊断 ===========")
        A("版本=%s  时间=%.0f",tostring(SYS.BuildVer),os.time())
        local cam=WS.CurrentCamera
        local vp=cam and cam.ViewportSize or Vector2.new(0,0)
        A("视口=%dx%d  触屏=%s",vp.X,vp.Y,tostring(UIS.TouchEnabled))
        A("菜单开着=%s  用户拖过=%s",tostring(SYS.MenuOpen),tostring(SYS._UserMoved))
        -- ★ 先判方法存不存在再调 —— 桩环境/个别执行器没有这些方法, 直接调会报错,
        --   而那种错会被门禁记成"被 pcall 吞掉的错误"(= 拒绝发行)。所以不靠 pcall 掩盖。
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
            -- ★ 命中测试: 标题栏正中那个点, 谁在最上层?
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
        local ok=pcall(function() writefile("CheatMenu_Diag.txt",txt) end)
        SYS.Notify(ok and "🩺 诊断已输出: 控制台 + CheatMenu_Diag.txt" or "🩺 诊断已输出到控制台(该执行器不能写文件)",SYS.CY.green)
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

    --============ ★ v120 快捷打开按钮 ============
    -- 触屏上没有 G / 右Shift 可按 -> 不给一个常驻浮动按钮, 手机上【根本打不开菜单】。
    if not SYS.FloatGui then P(function()
        local fg=Instance.new("ScreenGui")
        fg.Name="CheatMenuFloat" P(function() fg.ResetOnSpawn=false end)
        P(function() fg.IgnoreGuiInset=true end) P(function() fg.DisplayOrder=999 end)
        P(function() if gethui then fg.Parent=gethui() end end)
        SYS.SafeParentGui(fg)          -- ★ v121: 浮动按钮也走同一套隐藏容器
        local fb=Instance.new("TextButton")
        -- ★ v4.5.0: 小屏用 52, 大屏 58; 位置避开右上角(有的游戏那里有按钮)
        local fsz=DEV.small and 52 or 58
        fb.Size=UDim2.new(0,fsz,0,fsz) fb.Position=UDim2.new(1,-(fsz+18),0,96)
        fb.BackgroundColor3=CY.accent fb.BackgroundTransparency=0.12
        fb.Text="☰" fb.TextSize=28 fb.TextColor3=CY.text
        fb.Font=Enum.Font.GothamBold fb.BorderSizePixel=0 fb.AutoButtonColor=true
        fb.Parent=fg
        P(function() local r=Instance.new("UICorner") r.CornerRadius=UDim.new(1,0) r.Parent=fb end)
        SYS.FloatGui=fg
        -- 浮动按钮本身也能拖(手指按住拖走 -> 别挡住要点的东西); 轻点=开关菜单
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
    -- ★ v121 反检测基础版: 把菜单挪进执行器的隐藏容器(游戏的本地反作弊遍历 PlayerGui 时会扫不到),
    --   同时尝试拦"本地踢人"。两步都失败也只是降级, 不影响菜单本身。
    P(function()
        local where=SYS.SafeParentGui(sg)
        print("[CheatMenu] 菜单挂载: "..tostring(where).." · 防踢: "..tostring(SYS.TryAntiKick()))
    end)
    sg.Enabled=true SYS.MenuOpen=true
    -- ★ v101 记录"打开菜单前"的鼠标状态(关闭时据此恢复)。旧实现关闭菜单用的是脚本【加载时】的旧值,
    --   那个值常常是 Default -> 关掉菜单后鼠标还一直可见(用户报的 bug)。
    SYS.MenuPrevMouseBehav=UIS.MouseBehavior
    SYS.MenuPrevMouseIcon=UIS.MouseIconEnabled
    -- ★★ 受开关控制: 关掉就【完全不碰】鼠标行为/图标 —— 有些服务器每帧把鼠标锁回 LockCenter,
    --   我们每帧抢回会和它互刷(鼠标抖/不听使唤), 这种服务器上关掉更稳。
    if SYS.T_.MenuMouse~=false then
        UIS.MouseBehavior=Enum.MouseBehavior.Default
        UIS.MouseIconEnabled=true
    end

    -- ★ v62 修「第一人称开菜单鼠标消失、点不了开关」: 第一人称游戏/引擎每帧把鼠标锁回
    --   LockCenter 并隐藏图标, 下面只设一次立刻被覆盖。菜单打开期间每帧抢回
    --   (Default + 显示图标), 关菜单(ToggleMenu)/卸载时停掉守护。
    --   ★ v64: RS.RenderStepped 也走 pcall 防御 —— 个别执行器事件缺失时不再炸掉整个 CreateMenu。
    if not (SYS.MenuGuard and SYS.MenuGuard.Connected) then
        if SYS.MenuGuard then P(function() SYS.MenuGuard:Disconnect() end) end
        local okG,gconn=P(function() return RS.RenderStepped:Connect(function()
            if SYS.Unloaded or not SYS.MenuOpen then return end
            if SYS.T_.MenuMouse==false then return end      -- ★ 关掉"接管鼠标"就不再每帧抢
            P(function()
                if UIS.MouseBehavior~=Enum.MouseBehavior.Default then UIS.MouseBehavior=Enum.MouseBehavior.Default end
                if not UIS.MouseIconEnabled then UIS.MouseIconEnabled=true end
            end)
        end) end)
        if okG and gconn then SYS.MenuGuard=T(gconn) end
    end

    -- 打开动画(缩放 + 淡入)
    -- ★★ v5.4.1 修【真根因】——「菜单被推到左上角 + 标题栏整条跑到屏幕外 → 全设备都拖不动」:
    --   这里原来是 `Position=UDim2.new(0.5,-W/2,0.5,-H/2)` —— 那是【旧的"靠 Offset 偏移居中"时代】的写法。
    --   而菜单早已换成【锚点居中】(AnchorPoint=(0.5,0.5) + Position=(0.5,0,0.5,0)),
    --   两者叠加 = **居中了两次**:
    --       绝对位置 = 0.5*1920 − 0.5*830 − 415 = **130**   <- 与用户日志里的 实际=(130,…) 逐字对上
    --   菜单被推到 (130, 负值) —— 标题栏(y 为负)【整条都在屏幕外】→ 根本按不到 →
    --   `inRect` 永远 false → **拖动永远进不去**；✕/▬/⊙ 三个按钮也全在屏幕外, 用户连救都救不了。
    --   修法: **动画只改 Size 和 Transparency**, Position 全程保持 (0.5,0,0.5,0), 由锚点负责居中。
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
        -- ★ v101 先记录"打开菜单前"的鼠标状态, 关闭时恢复它(不再用脚本加载时的旧值)
        SYS.MenuPrevMouseBehav=UIS.MouseBehavior
        SYS.MenuPrevMouseIcon=UIS.MouseIconEnabled
        UIS.MouseBehavior=Enum.MouseBehavior.Default
        UIS.MouseIconEnabled=true
        -- ★ v62 修「第一人称开菜单鼠标消失、点不了开关」: 第一人称游戏每帧把鼠标锁回
        --   LockCenter 并隐藏图标, 上面"设一次"立刻被引擎覆盖。菜单打开期间每帧抢回。
        --   ★ v64: RenderStepped 连接走 pcall 防御(个别执行器事件缺失时不炸 ToggleMenu)。
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
            -- ★ v101 自由视角还开着 -> 恢复它的"锁定居中 + 隐藏图标"(否则视角转不动)
            UIS.MouseBehavior=Enum.MouseBehavior.LockCenter
            UIS.MouseIconEnabled=false
        else
            -- ★ v3.9.0: 改走唯一实现 SYS.RestoreMouse()(优先"打开菜单前" -> "进自由视角前" -> 加载时)。
            --   旧实现在"两个都没记录过"时才用加载时值, 语义与这里一致但少了中间的 FCPrev 一档。
            SYS.RestoreMouse()
        end
        SYS.MenuPrevMouseBehav=nil SYS.MenuPrevMouseIcon=nil
        -- ★ v3.9.0: 关菜单后把自由视角那份"进之前"记录也一并清空,
        --   避免陈旧 LockCenter 残留到下一轮开关里锁死鼠标。
        SYS.FCPrevBehav=nil SYS.FCPrevIcon=nil
    end
end

--============================================================
-- [16] 状态栏 / 循环 / 初始化 / 卸载
--============================================================

--============================================================
-- [16.1] 翻译忽略名单(★用户维护的【数据】, 不是逻辑)
--   为什么不放 [12] 翻译模块里: 那份名单有 142 项, 放进去会把 [12] 顶过
--   check.py 的 60K 体量锁 —— 而那个锁是管【代码】的, 不该被一份名单撑爆。
--   执行顺序没问题: 本文件整体加载完才会开始扫描, 赋值早于任何一次扫描。
--   命中规则见 Trans.isIgnored(): 控件自己 + 最多 3 层父级 的 Name 命中 => 跳过翻译。
--============================================================
-- ★★ 忽略控件表(用户提供; 1.txt 142 个控件名)。命中规则见 Trans.isIgnored(): 自己 + 最多 3 层父级。
local IGNORE_LIST="A_Timer|ActualPower|All|Amount|AreaName|B_Timer|BossName|BrainrotChance|BrainrotName|Brainrots|C_Timer|Cancel|Cash|Chance|ChanceLabel|Charging|ClaimButton|ClickRegion|Close|CoinLabel|Console|ConsoleModifierLabel|Count|CountLabel|CP/s|CPS|CPSLabel|CurrencyLabel|Day|DebounceFrame|Description|Discount|DiscountedPrice|DiscountLabel|DisplayName|EventTitle|Exp|Favorite|Favorites|Field|FreeSpinLabel|FriendsLabel|Gift|GiftButton|GiftingTo|GuideLabel|Header|Header1|Header2|Header3|HereText|IconLabel|Info|InfoLabel|InfoText|ItemName|KickPower|Label|LabelContent|Level|LevelLabel|Limited|LockedText|Lucky Blocks|Lvl|Message|Mobile|Mutation|MutationChance|MutationLabel|Name|NameLabel|New|Next|NoPlayers|Now|Odds|One|OP|OreName|Owned|PC|Percentage|Pity|PlayerName|Plus|Plus1|Plus2|Points|PowerLabel|Prevoius|Price|PriceLabel|Progress|ProgressBar|Rarity|RarityLabel|Reached|RebirthLevel|RefreshLabel|RewardLabel|RobuxLabel|S_Timer|SelectedLabel|SlotNum|SpinsLabel|StatusLabel|Stock|StockUpdateLabel|SubHeader|Suggest|SunHeader|TaskLabel|TextButton|TextLabel|Three|Tier|TimeLabel|TimeLeft|Timer|TimerLabel|TItle|Title|TitleDown|TitleLabel|TitleUp|TotalLuckLabel|TradeLimit|Two|Txt|Txt1|Txt2|Txt3|Type|Typed|UnlockedLabel|UnlockLabel|Value|ValueLabel|WeatherName|WeightLabel|WorldName"
Trans.IgnoreObjects={}
for w in IGNORE_LIST:gmatch("[^|]+") do Trans.IgnoreObjects[w]=true end
print("[Trans] 忽略控件表已装载: "..tostring(#IGNORE_LIST).." 字符")
do
    local fps,fT=0,os.clock()
    T(RS.Heartbeat:Connect(function()
        if not SYS.Unloaded then fps+=1 end -- ★ v49.7 菜单关闭也计数(FPS真实帧率)
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
                else SYS.FPSL.Text="FPS --" end -- ★ v49.7 菜单关闭时不再显示 FPS 0
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
            if SYS.T_.ESP or SYS.T_.ESPNameTag then P(SYS.ESPTick) end
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

-- ★ v68.8 玩家进出自动刷新: 战斗目标下拉框、退场玩家自动从目标里清掉
do
    local function refreshUI()
        task.delay(0.3, function()
            if SYS.Unloaded then return end
            for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
        end)
    end
    T(Players.PlayerAdded:Connect(function() refreshUI() end))
    T(Players.PlayerRemoving:Connect(function(pl)
        -- 退出的人是指定目标 -> 立即清掉(不锁死人)
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
        -- ★ v54: 切换后自检一次并给出明确结论(以前"按 G 收不回菜单"只能靠猜)
        local before=SYS.ScreenGui and (SYS.ScreenGui.Enabled==true)
        P(SYS.ToggleMenu)
        local after=SYS.ScreenGui and (SYS.ScreenGui.Enabled==true)
        if after==before then
            warn("[CheatMenu] 菜单没有切换成功 —— 可能这个键被游戏/其他脚本占用了。试试 右Shift 键。")
        end
        return true
    end
    -- ★ v3.9.0 修「改键后旧键(默认 G)还在生效」:
    --   菜单键有【两条】触发路径 —— ①CAS 绑定(为了抢在游戏自己的按键上下文之前) ②UIS.InputBegan。
    --   ①原来只在加载时按【当时的 Key_Menu】注册一次, 而设置页改键只更新了②(它每次现读配置)
    --   -> 新键能用、旧键(默认 G)照样能开菜单。
    --   现在把①收敛成可重绑的函数: 改键后立刻按当前配置重绑, 两条路径永远用同一个键。
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
        -- ★ v102 键位监听【优先】: 设置页点了「改键」后, 下一次按键就是绑定值(不触发功能)
        if SYS.KeyPickTarget then
            local foc=false
            pcall(function() foc=UIS:GetFocusedTextBox()~=nil end)
            if foc then return end                       -- 正在输入框打字 -> 不当按键
            local k=input.KeyCode
            if k==Enum.KeyCode.Unknown then return end
            SYS.C_[SYS.KeyPickTarget]=k.Name
            SYS.Notify(("已绑定: %s -> %s"):format(tostring(SYS.KeyPickTarget),k.Name),SYS.CY.green)
            SYS.KeyPickTarget=nil
            -- ★ v3.9.0: 立刻按新配置重绑 CAS —— 否则旧键(默认 G)那条绑定还在, 新旧键同时生效
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
    -- ★ v52(F39): 先清空开关状态, 再保存配置 —— 否则 SaveConfig 会把"卸载前的开关状态"
    --   写进磁盘, 下次加载时"根据配置激活开关"又会把这些开关自动打开(用户点卸载本意是干净退出)。
    for k in pairs(SYS.T_) do SYS.T_[k]=false end
    P(SYS.SaveConfig)
    P(SYS.SetGod,false) P(SYS.SetNoFall,false) P(SYS.SetJumpBoost,false)
    P(SYS.SetDeepHide,false)
    P(SYS.CleanFly) P(SYS.CleanSpeed)
    P(SYS.SetInfiniteJump,false)   -- ★ v52(F39): 补上无限跳连接断开(原来卸载后 UIS 连接残留)
    -- ★ v6.6.0 卸载对称: Ctrl+数字 直达用的 UIS 连接不在 SYS.Loops 里, 必须显式断
    --   (数值锁定走 SYS.SetLoop/SYS.Loops, 后面统一清; 世界重力由下面那行还原)
    P(SYS.SetPathKey,false)
    P(function() WS.Gravity=SYS.Orig.Gravity end)
    P(SYS.SetFullBright,false) P(SYS.SetPerf,false) P(SYS.ClearPerfConns)
    P(function() SYS.RefreshNC(false) end)
    P(SYS.StopFreeCam) P(SYS.ClearESP) P(SYS.TracerHide) P(SYS.disableAntiAFK) P(SYS.StopSpectate)
    -- ★ v6.5.0 卸载对称补齐(我们自己定的规矩: 建了什么就清什么, 重复卸载不报错)
    P(function() if SYS._f3Gui then SYS._f3Gui:Destroy() SYS._f3Gui=nil SYS._f3Lbl=nil end end)
    P(function() if SYS._awConn then SYS._awConn:Disconnect() SYS._awConn=nil end end)
    P(function() SYS._ciOn=false end)
    P(function() if SYS.SetFootstep then SYS.SetFootstep(false) end end)
    P(function() if SYS.SetInstantPrompt then SYS.SetInstantPrompt(false) end end)
    P(SYS.StopTrain) P(SYS.StopReb) P(SYS.StopGym)
    -- ★ v114(审计修复 EV-03): 卸载必须显式关掉「反陷阱」—— 原来这里漏了,
    --   它的三条连接(角色 Touched / CharacterAdded / RenderStepped)会留下来, 每次重载叠一条。
    P(function() if SYS.CleanTrapGuard then SYS.CleanTrapGuard() end end)
    P(function() if SYS.Combat then SYS.Combat.Stop() end end)
    P(function() if SYS.SetNoclip then SYS.SetNoclip(false) end end) -- ★ v49.3 卸载时清穿墙
    -- ★ v6.7.0 融合模块统一卸载(滤镜/光照/音频/聊天/路径点/防护/玩家控制/整蛊)
    P(function() if SYS.FuseClean then SYS.FuseClean() end end)
    for _,c in ipairs(SYS.NoclipConns or {}) do DS(c) end SYS.NoclipConns={} -- ★ v49.3 补清穿墙连接
    if CAS then P(function() CAS:UnbindAction("CheatMenuV49_Toggle") end) end
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
        -- ★ v3.9.0: 卸载也走唯一实现(原来的写法直接用脚本加载时的值, 会把
        --   StopFreeCam 刚恢复好的正确状态又覆盖掉 -> "卸载后鼠标不正常")
        SYS.RestoreMouse()
    end)
    P(SYS.ResetCam)
    -- ★ v3.10.0: 卸载时还原强制视角(把 CameraMode/CameraMaxZoomDistance 归位)
    P(function() if SYS.SetForceCam then SYS.SetForceCam("off") end end)
    P(function() if SYS.RestoreCamOpts then SYS.RestoreCamOpts() end end)
    P(function() if SYS.SetInstantPrompt then SYS.SetInstantPrompt(false) end end)   -- ★ 还原 prompt 时长   -- ★ 还原 FOV / 拉远
    P(function() if SYS.ScreenGui then SYS.ScreenGui:Destroy() end end)
    SYS.ScreenGui=nil SYS.MenuOpen=false
    -- ★ v4.8.1 修「点了卸载, 右边的 ☰ 浮动按钮还留着」:
    --   浮动按钮是【独立的 ScreenGui】(不挂在菜单 ScreenGui 下面), 所以销毁菜单不会连带销毁它。
    --   卸载必须显式销毁, 否则卸载后屏幕上永远留一个按钮 —— 看起来就是"卸载不干净"。
    P(function() if SYS.FloatGui then SYS.FloatGui:Destroy() end end)
    SYS.FloatGui=nil SYS.FloatBtn=nil
    if GENV.CheatUnload==SYS.UnloadAll then
        GENV.CheatLoaded=nil GENV.CheatUnload=nil
    end
    -- ★ v124: 卸载时把"加载时检查已做过"的锁也清掉 —— 否则【卸载后再重新加载】那一次会被锁跳过,
    --   而"卸载脚本 -> 重新加载"正是用户点名要覆盖的场景(退出游戏重进同理, 那会换新的 getgenv)。
    GENV.CheatBootDone=nil
    GENV.CheatUpdateNote=nil
    print("✅ 已卸载")
end


-- ★ v71 自更新(用户要求: 有人还在跑旧版时, 自动拉新版 + 卸载旧的 + 加载新的 + 开关自动恢复)
--   为什么必须先存配置再卸载: SYS.UnloadAll 会把 T_ 全清空并令 SaveConfig 跳过 T_,
--   若先卸载再存, 新版起来时所有开关都是关的(用户看到"更新完功能全没了")。
--   流程: ① SaveConfig(含 T_) ② UnloadAll 干净卸载 ③ HttpGet 拉源码 ④ loadstring+执行
--         ⑤ 新实例自己会打印"已根据配置激活开关", 功能回到原样。
function SYS.CheckUpdate(silent,notifyOnly)
    if SYS.UpdateBusy then return end
    if not SYS.BuildVerURL or SYS.BuildVerURL=="" or SYS.BuildVerURL:find("{{",1,true) then
        if not silent then SYS.Notify("ℹ️ 当前是本地开发版, 没有配置更新地址",SYS.CY.sub) end
        return
    end
    -- ★ v71 执行器兼容(实机测 bat 时抓到): 有些环境没有 game.HttpGet(或它不是函数),
    --   不先判能力就直接调, 会在加载 1.5s 后抛一个 "attempt to call a nil value (method 'HttpGet')"
    --   的 traceback —— 用户看不懂、还以为脚本坏了。这里先查能力, 没有就安静跳过。
    if type(game.HttpGet)~="function" then
        if not silent then SYS.Notify("ℹ️ 当前执行器没有 HttpGet, 跳过更新检查",SYS.CY.sub) end
        return
    end
    SYS.UpdateBusy=true
    -- ★ 修: P() 返回(ok,结果)多值, 直接赋值拿到的是布尔 -> 自更新永远报"取版本号失败"
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
    -- ★ v113(用户要求): 让"还在用旧版本"的人也能收到推送消息, 且消息里必须带【新旧版本号】。
    --   notifyOnly = 只提示、不自动更新(用户关掉了「自动检查更新」时走这条路 —— 仍然告知, 但不擅自重载)。
    local msg=("🆕 发现新版本 %s → %s"):format(tostring(SYS.BuildVer),tostring(rv))
    print(("[CheatMenu] "..msg.."  (%s)"):format(notifyOnly and "仅提示, 未自动更新" or "开始热重载"))
    if notifyOnly then
        SYS.UpdateBusy=false
        SYS.Notify(msg.."\n已跳过自动更新 —— 想升级就点设置页的「⬆️ 检查更新并热重载」",SYS.CY.yellow)
        return
    end
    SYS.Notify(msg.." 正在热重载…",SYS.CY.yellow)
    local _,src=P(function() return game:HttpGet(SYS.BuildURL) end)
    if type(src)~="string" or #src<1000 then
        SYS.UpdateBusy=false
        SYS.Notify("❌ 更新失败: 新版源码下载异常(保留当前版本)",SYS.CY.red)
        return
    end
    local chunk,cerr=(loadstring or load)(src,"@CheatMenu_update")
    if type(chunk)~="function" then
        SYS.UpdateBusy=false
        SYS.Notify("❌ 更新失败: 新版编译不过, 已保留当前版本",SYS.CY.red)
        warn("[CheatMenu] 新版编译失败: "..tostring(cerr))
        return
    end
    P(SYS.SaveConfig)        -- ① 必须在 UnloadAll 之前(否则 T_ 被跳过)
    P(SYS.UnloadAll)         -- ② 干净卸载旧的
    local ok,err=P(chunk)    -- ③④ 执行新版(它会自己恢复开关)
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
        -- ★ v64: 建到一半失败必须清掉半成品, 下次按 G 才会重试重建(否则永远停在空壳)
        P(function() if SYS.ScreenGui then SYS.ScreenGui:Destroy() end end)
        SYS.ScreenGui=nil SYS.MenuOpen=false
    else
        print("[CheatMenu] CreateMenu 成功")
    end

    GENV.CheatLoaded=true
    GENV.CheatUnload=SYS.UnloadAll

    task.spawn(function()
        task.wait(1.5)
        if SYS.T_.AntiAFK then P(SYS.enableAntiAFK) end
        for key,fn in pairs(SYS.SwitchOnChange) do
            if key~="AntiAFK" and SYS.T_[key]==true then P(fn,true) end
        end
        print("[CheatMenu] ✅ 已根据配置激活开关")
        -- ★ v124: 如果这次是"加载时更新"顶上来的, 在这里把更新前后版本号告诉用户
        --   (检查发生在界面之前, 那时还没有通知栏; 所以把话留到这一刻再说)
        if GENV.CheatUpdateNote then
            local note=GENV.CheatUpdateNote
            GENV.CheatUpdateNote=nil
            SYS.Notify(note,SYS.CY.green)
            print("[CheatMenu] "..note)
        end
        -- ★ v71 启动时自动检查更新; ★ v113(用户要求): 即使「自动检查更新」关着也【仍然检查】,
        --   只是降级成"只提示、不自动重载" —— 否则用户永远不知道已经有新版本了。
        task.wait(1.0)
        P(function() SYS.CheckUpdate(true, not SYS.T_.AutoUpdateCheck) end)
    end)
end

-- ★ v78: 原来写死 "v68" -> 改成真实版本, 这样一眼就能确认游戏里跑的是哪一版
print(("[CheatMenu] ===== 加载完成 · 版本 %s ====="):format(tostring(SYS.BuildVer)))
print("[CheatMenu] (local-开头=本地版 / 10 位十六进制=仓库网络版)")
print("[CheatMenu] 热键: G 打开/关闭 | T 传送到鼠标")
print("[CheatMenu] 中文/中文标点/硬保护词 全部跳过翻译")
