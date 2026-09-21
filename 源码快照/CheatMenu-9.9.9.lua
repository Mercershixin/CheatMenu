--############################################################
--# ⛔ 改这个文件之前【必读】—— 任何 AI / 智能体, 不管哪个账号
--#   (完整规范 = 仓库根目录 AGENTS.md; 同一份还在 CLAUDE.md / .github / .cursor/rules)
--#
--#  1) 只做用户明确要求的那一件事。不擅自新增功能、不改用户没让动的地方。
--#     同一条请求换个说法再问, 答案要一致。
--#  2) ⛔⛔ 验证只允许三种手段, 没有例外:
--#     ① 静态分析(luau-compile / luau-analyze / check_globals.py / 等价性比对)
--#     ② 单元测试(加载器探针 / _ballistic_unit.py 那种"抽真代码 + 真解释器")
--#     ③ 真云端分发链路验证(.workbuddy/build/cloud_verify.py: 真网络/真CDN/真字节,
--#        与本地发行产物逐字节比对 + 送编译器)。★ 不需要真机, 也不需要在执行器里跑 Lua 功能。
--#     ⛔ 整脚本仿真 / 任何 mock 环境 / "循环检测"(模拟→修复→再模拟) / 多轮深度验证
--#        —— 一律禁跑、禁修、禁扩展(sim/run_full.py · full_sim.lua · run_smoke.py · run_probe_v69.py)。
--#        理由: 那是 lupa+Lua 5.5 的 mock, 不是 Luau 也不是 Roblox, 只会把"仿真台自己的坑"算成脚本 bug。
--#     ⛔ 也别为了"确认我没改坏"顺手跑门禁(verify_all.py / check.py / check_globals.py / luau-compile):
--#        改完直接交付, 或问用户要不要验。只在用户明确说"跑一下 / 验证一下 / 测试一下 / 发版"时才跑。
--#        用户原话: "我让你做你才做, 没让你做我不做。"
--#        (发版本身要跑 push_now.py —— 那是交付步骤, 不算"额外的验证循环"。)
--#  3) ⛔ 接口红线: 单点 hookfunction 可以(明确目标就 hook 哪个);
--#     挂 hookmetamethod(game,"__namecall") 或 "__index" 做关键词搜索【绝对不行】——
--#     那是所有实例方法调用的总入口, 实测就是"开过检测极度卡顿掉帧"的病根。
--#  4) UI 上标"不推荐 / 有风险"是给用户看的提示, 不是让你改行为(不删选项/不改默认/不加限制)。
--#  5) ⛔ 已删除的功能不要"顺手加回来"(清单见 AGENTS.md §2)。只有用户本人重新提起才能加。
--#     例外(用户明确说"还需要", 别再删): 穿墙 NoClip / 防甩飞 AntiFling / 无限跳 / Ctrl+数字路径点。
--#
--#  🎨 透视 / 高亮配色规范(别再自己加颜色):
--#     · 所有高亮 = 边框高亮(填充近乎透明 0.88, 隔墙 0.93, 只留描边)
--#     · 普通物件 + 普通门 = 统一亮青 (0,200,255) / 描边 (0,170,230)
--#     · 危险(陷阱 / 伤害机关 / 切割 / 假门) = 红 (255,30,30) / (255,0,0) + ☠ 骷髅头
--#     · 人物 = 队友绿 / 敌人红 / 幽灵紫 ;  怪物·NPC = 橙
--#     · 掉落物 / 可交互 / 门·陷阱·假门 三个透视已合并成一个开关「🔍 物件透视」, 别再拆开
--#
--#  🚀 发版: 改源码 -> dist/repo/CHANGELOG.md 顶部写条目 -> push_now.py --patch
--#          -> (若 API 失败) push_api.py -> local_sync.py
--#          -> 核对 version.txt == CHANGELOG 顶部 == 远端实际文件
--#          (门禁 = 等价性 + luau-compile + 加载器探针; 仿真已禁用, --fast 只剩兼容意义)
--#  🗂 模块定位: 用分节标题(如 "-- [11.5] 战斗模块")grep, 不要把行号抄进文档(每次改源码都会漂移)。
--############################################################
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
do local _u=GENV.RblxSessionB or GENV["Cheat".."Unload"]
   if (GENV.RblxSessionA or GENV["Cheat".."Loaded"]) and type(_u)=="function" then pcall(_u) end end
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

-- ★ v4.5.0 设备标志: 后面「UI 层」里每个控件的高度都要按它决定(触摸设备加高), 所以必须在最前面探测
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
        ESP=false,ESPNameTag=false,ESPItem=false,ESPWeapon=false,ESP_NPC=false,ESP_Pick=false,ESP_Door=false,ESP_Mini=false,BlockHandlers=false,QuickInteract=false,AutoHide=false,AutoDodge=false,AutoHitMinigame=false,MenuMouse=true,FreeCam=false,Tracer=false,
        -- ★★ 强化(用户要求): 子弹射线扩成多目标 —— TracerAll=给每个其他玩家各画一条(池化多目标)。
        --   (距离/条数两道上限在 SYS.C_ 里: TracerMaxDist / TracerMaxN)
        -- ★★ v9.9.7 默认改成【开】: 新的语义是"每个人自己的准心线", 别人那条才是重点
        TracerAll=true,
        AntiAFK=true,AutoBonus=false,
        AutoRebirth=false,AutoGym=false,AutoTrain=false,
        TransChat=false,TransUI=false,
        AutoSell=false,SellThresholdEnabled=false,
        -- ★ v57/v59: 战斗开关默认全关, 仅「不打队友」默认开(用户要求)
        CB_Aim=false,CB_Silent=false,CB_Fire=false,
        CB_PauseMove=false,CB_Predict=true,CB_Team=false,CB_Wall=true,
        -- ★★ v9.5.0 新增「隐蔽模式」(用户要求: 可以加, 但必须给开关, 默认关)
        --   开 = 开火前【不做瞬时对准相机】-> 改回"等准星自己压上去" -> 少一次相机跳变, 但命中率会降。
        --   关 = 保持现状(开火那一帧瞬时对准, 命中率高, 但相机有一帧跳变)。
        CB_Stealth=false,
        -- ★★ v8.7.0: CB_Predict 默认 false -> **true**。用户实测"打不中速度快的人" ——
        --   根因就是预测默认关着, 对移动目标完全没有提前量(等于永远瞄他"上一帧的位置")。
        --   现在默认开; 老存档里显式存过 false 的仍尊重存档(不会强改用户的选择)。
        -- ★★ v7.8.4 抛射物弹道预判(用户: "对于 fps 射击类的 有用就能")。
        --   与 CB_Predict 是【两条独立路径】: CB_Predict 是线性提前量(只对瞬发枪械准),
        --   这个是四次方程解算(补"子弹飞行时间 + 重力下坠")。默认【关】—— 老行为零变化。
        CB_Ballistic=false,
        CB_TgtStrict=false,
        CB_SnapFire=false,
        -- ★ v71 只锁"有血量且>0"的活人(用户要求)。关掉 = 回到旧行为(没有 Humanoid 也算活人)
        CB_OnlyAlive=true,
        CB_SkipFF=true,        -- 无敌盾: 跳过带 ForceField 的目标(等护盾结束再打)
        CB_Melee=false,        -- ★ v4.1.0 近距离补刀(默认关, 用户自己在战斗页打开)
                               --   ★ v5.4.0: 与"补刀也打非目标"合并为一个开关(优先锁定目标, 其次最近敌人)
        -- ★ v122 反陷阱免伤(地图道具/生物/陷阱的攻击与控制; 实现见 [05] 移动模块)
        TrapImmune=false,
        -- ★ v6.6.0 数值锁定(LockSpeed/LockJump/LockGravity) —— ★ v9.9.0 删除清理:
        --   移动页的「数值锁定」分区早就没了(现在是 飞行/移动加速/穿墙/免伤/跳跃),
        --   而 SYS.SetLocks() 全文件没被调用过一次 ⇒ 三个键是"有读无写"的死键。
        --   键已删 + 记进 SYS.REMOVED_FEATURES(挡老存档复活), 后端 LockTick 一并删。
        -- ★ v6.6.0 融合自 ChronixHub 路径点页: Ctrl+数字 直达传送(前 9 个保存点)
        PathKey=false,
        -- ★ v71 启动时自动检查 git 上的新版本并热重载
        AutoUpdateCheck=true,
        -- ★ v124(用户要求): 【加载时】更新检查 —— 重新加载的那一下先看有没有新脚本(见 SYS.BootUpdateCheck)
        BootUpdateCheck=true,
        --================ ★ v6.7.0 融合(ChronixHub)新增开关 · 一律默认关 ================
        -- 滤镜控制器 / 多路径点 —— ★ v9.9.0 删除清理: 两块都没有界面入口了
        --   (FX_Enable / WPShow / WPKey 全是"有读无写"的死键), 键连同死后端一起删。
        -- 光照档位包
        NightVision=false,NightVisionPro=false,Lantern=false,SuperLight=false,
        NoFog=false,NoShadow=false,
        -- 自杀 / 角色状态(防死亡·防击倒 并入上帝模式)
        NoDeath=false,NoKnock=false,
        -- 瞄准补强: ★ v9.9.0 删除清理 —— CB_MissMode(漏打/命中率)已删(界面早没了, 函数也没人调)
        -- 默认关闭的三项(用户点名: 加入但默认关)
        CB_SilentAim=false,CB_BulletWall=false,CB_BlockRay=false,
        -- ★★ v6.9.19 补声明(静态检查抓到: 这 5 个键被 UI/后端读写但没在默认表里, 状态是 nil):
        --   360 无死角 / 无延迟模式 / 真·静默(不转相机) / 翻译中英对照
        --   ★ v9.9.0 删除清理: AutoLowPing 拿掉 —— 它当年就是"删 UI 后残留"
        --   (6.9.19 CHANGELOG 原话), 现在连后端 SYS.AutoHopCheck/SYS.HopLowPing 一起删。
        CB_360=false,CB_SilentNoTurn=false,
        NoAggro=false,      -- ★ v6.9.24 无仇恨模式(隐身+免伤+自动躲 一键开)
        TransBilingual=false,
        TransDyn=true,
        
        -- ★ v6.9.0 冷却加速倍率(1=关闭; 只对客户端判定的冷却有效)
        -- 防护
        -- ★★★ v9.9.8 用户要求【默认开启】: 它只动我们自己的实例, 且菜单仍留在 PlayerGui
        --   (位置不受影响)、不改任何输入绑定 ⇒ 对正常游戏 UI/控制无副作用。
        --   默认 true 后, 启动时由下面那个 `for key,fn in pairs(SYS.SwitchOnChange)` 自动装上
        --   (UI.Switch 会把回调注册进 SwitchOnChange, 见 UI.Switch 实现)。
        Prot_AntiAdmin=true,Prot_HideGui=false,
        -- ★★ v7.7.0 补强批次2(概念来源: 公开脚本的"人速护栏"; 实现自写):
        --   移动限速护栏 —— 打开后所有走 WalkSpeed 的加速路径最终写进去的值都被压到 SpeedCap 以内。
        Prot_SpeedCap=false,
        -- ★★ 新增(2026-09-20, 参考公开脚本 AntiFling): 防被甩飞(被别人用约束把高速速度传染给你)
        AntiFling=false,
        -- 玩家控制(动手类)
        PC_LoopTP=false,PC_OnHead=false,PC_Orbit=false,PC_Stare=false,PC_Follow=false,
        -- ★ v9.9.0 删除清理: PC_Freeze(整蛊工具) + 整蛊 PG_* 八个开关
        --   整蛊页 6.9.6 就删了(全是只改本地副本, 对方看不到、服务端不认), 但后端整块留着、
        --   只有"统一卸载"路径还在调 PG.StopAll —— 那正是"界面已删、后端保留"的指纹。
        --   键已删 + 记进 REMOVED_FEATURES, 后端 SYS.Prank 整块删除。
    },
    C_={
        -- ★ v3.9.0(用户要求): 飞行默认执行器改回 BodyVelocity —— 最兼容老执行器
        --   (Align 依赖 LinearVelocity/AlignOrientation, 老执行器造不出来 -> 飞行直接不生效;
        --    选了 Align 但执行器不支持时, FlyTick 里还有一层"自动降级"兜底)
        FlySpeed=3,FlyMode="BodyVelocity",
        SpeedMult=2,TPMethod="CFrame",SpeedMode="Linear",
        JumpMult=2,
        -- ★★ v7.7.0 G8 移动限速护栏的上限(格/秒)。Roblox 默认走路是 16;
        --   服务端统计类反作弊最爱看"长期 >30 格/秒"这种一眼假的数。默认 28 是留了余量的安全值。
        SpeedCap=28,
        -- ★ v6.6.0 世界重力(格/秒²) —— ★ v9.9.0 删除清理: 唯一读者是「数值锁定」的 LockTick,
        --   该功能已删(无界面入口), 所以这个参数键一并删除。
        MouseTPMode="Raycast",AutoTPDist=5,TPMaxStep=300,
        FreeCamSpeed=60,FreeCamSens=0.3,PerfCull=300,
        -- ★★ 强化(用户要求"人物射线"): 多目标射线的两道上限(视觉页「🎯 射线」)。
        --   TracerMaxDist=最远画到几格(0=不限); TracerMaxN=最多同时几条(人多时防卡)。
        TracerMaxDist=500,TracerMaxN=12,
        -- ★ v3.9.0: 名字标签在"角色顶部之上"再加多少格(0=自动贴顶; 正数=更往上)
        ESPNameH=0,
        -- ★★ v6.9.35 「全图高亮」: 物件/门/小游戏 透视的距离上限(格)。
        --   原来只在代码里写死 1200, 配置表里没有这个键 -> 界面改不了也存不住。现在接出来(视觉页「透视距离」)。
        PickDist=1200,
        -- ★★ v6.11 对照公开脚本补的两个参数
        QuickRange=60,      -- 快速交互: 把 ProximityPrompt/ClickDetector 的触发距离拉到多少格
        AutoHideDist=40,    -- 自动藏身: 敌对生物进到多少格就自动钻藏身点
        -- ★ v69: 藏地下隐身的深度(格) —— 小=离地面近(还能被距离判定的交互够到), 大=藏得深
        DeepHideDepth=120,
        -- ★ v3.10.0: 藏身方向("down"=地下 / "up"=天上) + 藏身偏移(相对开启点, 格; X=左右 Z=前后)
        DeepHideMode="down",DeepHideOffX=0,DeepHideOffZ=0,
        -- ★ v3.10.0: 强制相机视角("off"/"first"/"third")
        ForceCam="off",
        AutoTrainSec=5,RebirthCheck=3,
        SellMinCPS=100000,SellLvMul=1.25,
        CB_AimPart=2,CB_Smooth=0.28,CB_Fov=200,CB_MaxDist=1200,CB_MeleeDist=9,CB_MeleeGap=0.35,
        -- ★★ 修复(设置页「索敌间隔 (毫秒 · 0=每帧秒锁)」改了存不住): 这个键一直被界面读/写、
        --   也被索敌主循环读(6 处), 但【从来没在 SYS.C_ 里声明过】。
        --   而 SaveConfig 是 `for k,v in pairs(SYS.C_) do` —— 只遍历【声明表】的键;
        --   LoadConfig 又要求 `SYS.C_[k]~=nil` 才回填。于是: 拖了滑块 -> 内存里立刻生效,
        --   但写盘写不出去、重载读不回来 -> 每次都回到这里的默认值。
        --   补上声明, 与同族的 CB_FireDelay / CB_Smooth 一致, 滑块即可正常持久化。
        CB_ScanMs=33,
        -- ★ v6.8.0 反作弊补强(对抗靶场 D7 未通过): 默认开火间隔 0.035s(28 发/秒) 是最容易被
        --   统计出来的特征 —— 统计几十枪就能判定脚本。抬到人类下限 0.08s(12.5 发/秒,
        --   对扳机来说仍然很快; 而且大多数枪本身的开火上限就在 0.1~0.15s, 实际手感几乎无差别)。
        --   想要更快可以自己往左拖, 但靶场会如实把 D7 标成未通过。
        CB_FireDelay=0.08,CB_HpThr=0,CB_PrioMode=1,
        CB_TargetMode=1,CB_TargetName="",CB_RingMode=1,CB_PredictTime=0.14,
        -- ★★ v7.8.4 抛射物弹道解算的两个参数。★ 直接在这里声明 —— 理由同上面的 CB_ScanMs:
        --   SaveConfig 只遍历【声明表】的键, 未声明 = 界面调了也写不出去、重载回默认。
        --   · CB_ProjSpeed: 抛射物初速(studs/秒), 看武器面板/游戏 wiki 填。
        --   · CB_ProjGrav : 下坠加速度(studs/秒²), 0 = 不补下坠(纯飞行时间修正)。
        --     标准重力是 196.2; 想知道当前地图的重力, 控制台跑 print(workspace.Gravity)。
        CB_ProjSpeed=100,CB_ProjGrav=196.2,
        -- ★ v69: 圈显示模式改成默认「一直显示」; Ver 用来把老配置里存的 2(仅菜单)迁移过来
        CB_RingModeVer=0,
        CB_SnapDelay=0.03,
        -- ★ v71 快照瞄准防踢限流: 角色 CFrame 写入的最小间隔(秒) + 单次最大转角(度)
        CB_SnapMinGap=0.08,CB_SnapMaxAngle=360,
        -- ★ v102 移植: 可自定义热键(值是 KeyCode 名字; 在设置页「热键设置」里改)
        Key_Menu="G",Key_CycleTarget="V",Key_Teleport="T",
        --================ ★ v6.7.0 融合新增参数 ================
        -- ★ v9.9.0 删除清理: FX_Sat/FX_Bri/FX_Con/FX_CB 与 FX_Enable 一起删(滤镜模块整块删除)。
        -- v6.7.0 界面缩放(0 = 自动适配; >0 = 直接用这个值, 范围 0.3~3.0)
        UIScaleManual=0,
        -- ★ v7.6.0 触摸端(手机/平板)菜单位置记忆: 存"视口比例"0~1(换屏幕/转屏都能按比例还原)。
        --   MenuPosSaved=false = 用户还没拖过 -> 建菜单仍用默认居中;
        --   PC 端(SYS.TouchUI=false)永远不读不写这三个键 -> 行为保持"每次居中"不变。
        MenuPosX=0.5,MenuPosY=0.5,MenuPosSaved=false,
        -- ★ v9.9.0 删除清理: AudioMaster/AudioThr/PC_Speed 三个键全文件从未被读过(纯残留声明), 删。
        -- ★ v9.9.0 删除清理: CB_HitRate/CB_MissRate 随「命中率/漏打」闸门一起删。
        PC_Sel="",PC_Range=8,PC_SpinSpeed=3,
        -- ★ v8.2.0 M1: 跟随/环绕 合并成互斥下拉后的"当前模式"("off"/"PC_LoopTP"/…), 必须在这里声明才能存住
        PC_Mode="off",
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
--============================================================
-- [00B] v6.8.0 反指纹: 中性名表 + GENV 键别名
--   为什么: 游戏侧反作弊(LocalScript)能做的事里, 最有效的一条就是
--   【遍历 CoreGui / PlayerGui / Workspace / Lighting, 按名字查外挂特征】。
--   我们原来的名字是 CheatMenuV52 / CheatMenu_WP1 / CheatMenu_Lantern / CheatMenu_FX …
--   —— 一个 string.find(n,"cheat") 就全暴露了。下面把这些名字换成
--   ① 与游戏原生对象无法区分的名字(Part / Light / 类名)  ② 每局随机(没有固定签名)。
--============================================================
local function _rands(n)
    local hex="0123456789abcdef" local t={}
    for i=1,n do local k=math.random(1,16) t[i]=hex:sub(k,k) end
    return table.concat(t)
end
SYS.N={
    -- 菜单/浮动按钮: 从"看起来就像引擎自带"的名字里随机挑一个(每局不同 -> 没有固定指纹)
    Gui    = ({"App","MainGui","Interface","CorePack","UiRoot","HudRoot","PanelRoot"})[math.random(1,7)],
    Float  = "FloatingButton",
    Hud    = ({"HudRoot","Interface","UiRoot"})[math.random(1,3)],   -- ★ v6.9.29 HUD 也用中性名(原来写死 CM_Hud, 是反指纹漏洞)
    F3     = "Stats",
    Combat = "Render",
    CAS    = "CoreAction_".._rands(4),
    FX     = "ColorCorrectionEffect",     -- 与类名同名 -> 与游戏自带后处理无法区分
    Lantern= "Light",
    WP     = "Part",                      -- 与地图里 90% 的部件同名
    Cfg    = "cfg.dat",
    Diag   = "dbg.txt",
    Cache  = "tr.dat",
    -- 旧名(只读兼容 / 迁移用)
    OldCfg = "CheatMenuV491_Config.json",
    OldCache="TransCache.json",
    OldDiag="CheatMenu_Diag.txt",
}
-- GENV 键中性化: 原来叫 CheatLoaded/CheatUnload/__SYS, 任何脚本 getgenv() 一读就认出来了。
--   注意: 必须保留【旧键的读取兼容】—— 否则热重载时找不到上一版实例的卸载函数, 会叠出两个菜单。
SYS.GK={ loaded="RblxSessionA", unload="RblxSessionB", boot="RblxSessionC", note="RblxSessionD" }
local function _gv(...)
    for i=1,select("#",...) do
        local k=select(i,...)
        if k and GENV[k]~=nil then return GENV[k] end
    end
    return nil
end
SYS.GV=_gv
GENV.__SYS=SYS   -- ★ 保持原名: '__SYS' 不含任何外挂关键词, 不在反指纹范围; 执行器生态与仿真台都认它

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
    -- ★ v6.8.0 反指纹: 落盘文件名改成中性名(cfg.dat / .bak)
    --   旧名 CheatMenuV491_Config.json 仍【可读】(迁移), 但不再新写 —— 同目录下
    --   留着一个带 "CheatMenu" 的文件, 等于给任何扫目录的脚本立了个路标。
    local CFG=SYS.N.Cfg
    local CFG_LEGACY=SYS.N.OldCfg
    local HAS_FS=(type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function")
    SYS.HAS_FS=HAS_FS
    SYS.has_fs_txt=HAS_FS and ("持久化启用 · "..CFG) or "执行器不支持 writefile"

    function SYS.SaveConfig()
        if not HAS_FS or not HS then return end
        P(function()
            local data={T_={},C_={}}
            -- ★ v57: 开关状态(T_)【永不】写盘 —— 用户要求"默认全关",
            --   且不能被旧配置干扰。每次加载都用代码默认值; 参数(C_)照常保存。
            -- ★★ v6.9.0 例外(修用户报的「热更新完所有功能都关了, 要手动一个个重开」):
            --   正在热更新时(SYS._updating)必须把 T_ 一起存下去 + 打 _resumeT 标记,
            --   否则新版起来全是关的。日常启动/退出【不受影响】, 仍然是默认全关。
            local withT = SYS._updating == true
            if withT then
                for k,v in pairs(SYS.T_) do
                    if type(v)=="boolean" then data.T_[k]=v end
                end
                data._resumeT = true
            end
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
    -- ★★ v6.9.33 已删功能黑名单(用户要求删除: 反陷阱预警 / 自动连用) —— 界面入口已删,
    --   这里再兜一道: 热更新恢复开关状态时【跳过】它们, 免得"删了又自己回来"。
SYS.REMOVED_FEATURES = { TrapWatch=true, AutoUse=true,
-- ★ v8.2.0: FootstepESP(落脚点指示)的后端早已删除, 但它当时被忘了从 SYS.T_ 里拿掉 ——
--   审计发现它是"读取 0 次 + 界面无控件"的纯残留声明。现在从声明表移除, 并存进黑名单挡住老存档复活。
FootstepESP=true,
AutoClaim=true, AutoPickup=true, AutoRespawn=true, AutoShop=true, AutoTeam=true, AutoEmote=true,
-- ★ v120.2: 翻译云端后端整段删除(用户实测 api 更慢) —— 存进黑名单, 挡住热更新残留把它复活。
TransSili=true,
-- ★★ v9.9.0 删除清理批次(2026-09-21 全功能体检「④ 删了界面、留着后端」) ——
--   ① 翻不动的死键(全文件只有读取、没有任何地方置位) + ② 整蛊残留(界面 6.9.6 就删了)。
--   界面入口都不在了, 键连带后端一起删; 这里再兜一道, 免得热更新恢复 T_ 时把它们写回来。
--   移动页「数值锁定」整块(SYS.SetLocks/LockTick 从未被调用过)
LockSpeed=true, LockJump=true, LockGravity=true,
--   「路径点」多路径点列表(界面早删; 保留下来的 WP.TweenTo/WalkTo 是"玩家控制"在用)
WPShow=true, WPKey=true,
--   滤镜控制器(滤镜页已删, 模块整块删除)
FX_Enable=true,
--   自动跳低延迟服务器(CHANGELOG 6.9.19 原话点名"删 UI 后残留") + 后端 HopLowPing/AutoHopCheck
AutoLowPing=true,
--   战斗页「命中率 / 漏打」闸门(CB_MissMode + 后端 AimEx.HitGate/MissGate)
CB_MissMode=true,
--   整蛊工具(后端 PC.Freeze + SYS.Prank 整块删除)
PC_Freeze=true,
PG_Spin=true, PG_SpinHit=true, PG_FlyHit=true, PG_WalkHit=true,
PG_HideHit=true, PG_OrbitTool=true, PG_BlackHole=true, PG_KillNear=true,
--   防护两项(2026-09-22 按"防不住就删"删掉): 真实的踢/封/传送由服务端发出, 客户端 hook 拦不到;
--   且 hook 本身会被反作弊反向检测(对非玩家对象调 Kick 看返回 nil)。记进黑名单挡老存档复活。
Prot_AntiAC=true, Prot_AntiTP=true }
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
                -- ★★ v6.9.0 例外: 只有【热更新留下的 _resumeT 标记】才恢复 T_
                --   —— 用户报"热更新后功能全没了要手动重开"。恢复完立刻重存一次抹掉标记,
                --   下次正常启动仍然是默认全关。
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
                        for _, f in ipairs(SYS.BtnRefs or {}) do P(f) end   -- 刷新界面显示
                        SYS.Notify(("♻ 热更新完成, 已自动恢复 %d 个开关状态"):format(n), SYS.CY.green)
                        P(SYS.SaveConfig)                                   -- 重存(不带 T_)抹掉标记
                    end)
                end
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
--   递归保护: 新版启动时会看到 GENV[SYS.GK.boot]=true 而跳过检查, 否则无限套娃。
--   取不到版本号(离线/执行器没有 HttpGet)一律当"没新版", 正常打开, 绝不挡路。
--============================================================
function SYS.BootUpdateCheck()
    if GENV[SYS.GK.boot] then return false end
    GENV[SYS.GK.boot]=true
    if SYS.T_.BootUpdateCheck==false then return false end
    if type(game.HttpGet)~="function" then return false end
    -- 从发行时写进脚本的地址里解析出 用户/仓库/分支, 再拼多源候选(raw.githubusercontent 在国内常连不上)
    local base=tostring(SYS.BuildURL or "")
    -- 本地版/开发版地址是空的 -> 用内置仓库基址兜底(见 SYS.FallbackRepo 的说明)
    if base=="" or base:find("{{",1,true) then base=tostring(SYS.FallbackRepo or "") end
    local user,repo,branch=base:match("^https://raw%.githubusercontent%.com/([^/]+)/([^/]+)/([^/]+)")
    local VER,SRC
    if user then
        -- ★ 候选顺序 = 新鲜优先(2026-09-20 云端实测后的结论, 别改回去):
        --   raw      : 官方源, 原生缓存约 5 分钟(推送后稍等即生效); 国内常连不上
        --   ghproxy  : 反代 raw, 内容同样新 + 国内可达
        --   ghfast   : 反代 raw, 同上(实测与本地发行产物逐字节一致)
        --   jsDelivr : 响应最快, 但【对分支 @main 是文件级长缓存】—— 实测同一时刻它的
        --              version.txt 已是新版、CheatMenu.lua 却还停在前一版(三个边缘节点
        --              各自停在不同旧版本), 命中时会把【旧脚本】静默喂进来。
        --              所以它必须排最后: 前面任何一家活着就轮不到它。
        -- ★ v5.2.1 的思路(加时间戳查询参数穿缓存)对 raw 系有效, 但【对 jsDelivr 实测无效】
        --   —— 带与不带 query 返回的是同一份旧字节。所以不能靠这个参数救 jsDelivr,
        --   只能靠"把它排在最后"。参数本身无害, 保留。
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
    GENV[SYS.GK.note]=("🆕 已更新 %s → %s"):format(mine,rv)
    local ok,err=pcall(chunk)
    if not ok then
        GENV[SYS.GK.note]=nil
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

--##########################################################################
--# ★★ v9.9.3 通道风险标注: 蜜罐 / 管理后台 —— 只标注, 绝不在任何功能里自动触发
--#   由来(DOORS 那份扫描里实打实存在的):
--#     ReplicatedStorage.RemotesFolder.DroneStickyNoteMyNameIsExploiterAndIThinkICanCheatWithThis
--#       ↑ 名字直接写着"我是开挂的, 我以为用这个能作弊" —— 这是游戏方【摆着的诱饵】,
--#         谁 FireServer 谁就被记录(甚至当场封)。
--#     还有 conch_networking.*(register_command / log / log_command) 与 AdminPanelRunCommand,
--#     这些是后台/审计通道, 碰了等于自报家门。
--#   所以扫描清单里必须一眼看出"这条不能碰", 而不是跟正常通道混在一起列。
--##########################################################################
do
    -- 一级 ⛔ 蜜罐: 名字里直接点名开挂/作弊(DOORS 那条 DroneStickyNote... 就是)
    local HONEY={"exploiter","exploiters","cheater","cheaters","cheat","cheating","hacker",
                 "hackers","hacking","abuser","abusers"}
    -- 二级 ⛔ 后台/处罚: 触发=自报家门
    local ADMIN={"admin","ban","kick","punish","punishment","report","registercommand",
                 "logcommand","updateuserroles","invokeservercommand","createuser"}
    -- 三级 ⚠ 审计/日志: 通常是反作弊在收集行为, 也别主动触发
    local LOGNET={"log","logs","logging","audit","telemetry","analytics","anticheat","antiheat",
                  "detect","detection","integritycheck","monitor"}
    -- 词组(不拆词, 直接在整串小写里找) —— 下划线形态的后台命令靠这个兜住
    local PHRASE_HONEY={"sticky note","i think i can cheat","my name is"}
    local PHRASE_ADMIN={"register_command","log_command","invoke_server_command",
                        "update_user_roles","create_user","run_command"}

    -- ★ 按【词】匹配, 不能按子串 —— 子串会把 `SetDialogInUse` 里的 "dia-log" 当成 log 通道,
    --   `AnalyticsSender` 这种 Roblox 自己的统计也会跟着误报。先把 camelCase / 下划线拆成词。
    local function toks(name)
        local s=name:gsub("(%l)(%u)","%1 %2")
        s=s:gsub("(%u)(%u)(%l)","%1 %2%3")
        s=s:gsub("_"," "):gsub("%."," "):lower()
        local t={}
        for w in s:gmatch("%w+") do t[#t+1]=w end
        return t
    end

    --- 返回 nil(正常) / 风险说明。只看【名字】, 不做任何网络动作。
    function SYS.RemoteRisk(name)
        if type(name)~="string" or #name==0 then return nil end
        local low=name:lower()
        for i=1,#PHRASE_HONEY do
            if low:find(PHRASE_HONEY[i],1,true) then
                return "⛔ 蜜罐嫌疑(名字点名开挂/作弊) —— 千万别 FireServer"
            end
        end
        for i=1,#PHRASE_ADMIN do
            if low:find(PHRASE_ADMIN[i],1,true) then
                return "⛔ 后台命令通道(conch/管理类) —— 触发=自报家门"
            end
        end
        local tk=toks(name)
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
        for i=1,#tk do
            local w=tk[i]
            for j=1,#LOGNET do if w==LOGNET[j] then
                return "⚠ 审计/日志通道 —— 通常被反作弊收集, 不要主动触发" end end
        end
        return nil
    end

    --- 这个物件（或它的 3 层祖先）是不是"蜜罐味"的名字。
    --- ★ 用户口径（2026-09-21）：「不要动蜜罐就行」。
    ---   高亮无所谓（只画轮廓、不发任何请求），但【自动藏身 / 自动小游戏】是真的会按下去，
    ---   所以凡是"自动触发"的路径，动手前一律先过这一关。
    function SYS.IsHoneypot(obj)
        local o=obj
        for _=1,4 do
            if not o then break end
            local nm=o.Name
            if type(nm)=="string" and nm~="" then
                local low=nm:lower()
                for i=1,#PHRASE_HONEY do
                    if low:find(PHRASE_HONEY[i],1,true) then return true end
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
--##########################################################################
--# ★★ v6.9.0 事件通用化: 别名表 + 关键词模糊扫描（跨游戏）
--#   目的: 同一类事件在不同游戏里叫法五花八门。这里把常见命名列成别名，
--#   精确找不到就按关键词扫 Remote 树 —— 用户抓到新游戏后，只要命名落在这套表里，
--#   依赖它的功能（回血/复活/购买/领取…）就自动生效，不用改代码。
--##########################################################################
SYS.RemoteAlias = {
    heal    = {"EntityService.Heal","Heal","RequestHeal","HealSelf","SelfHeal","HealPlayer",
               "Regen","Regenerate","RestoreHealth","RequestHealSelf"},
    revive  = {"GameService.Revive","Revive","RequestRevive","ReviveSelf","RevivePlayer","Resurrect","Resurrection",
               "Any.Suicide","GameService.Revive",
               -- ★ v6.10.1 DOORS: 复活自己 / 救队友(还带 "获得赠送的复活" 这条)——这游戏复活是玩法核心
               "ReviveFriend","ObtainGiftedRevive","CheckRevive","ReviveRift"},
    respawn = {"GameService.Respawn","Respawn","RequestRespawn","CharacterReset","Reset","RespawnSelf",
               "PlayerRespawn","RequestCharacterReset","GameService.Respawn","GameService.Join","GameService.JoinLater",
               -- ★ v6.10.1 DOORS: 重开一局 / 继续存档
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
               -- ★ v6.10.1 DOORS: 躲藏点(HidePickup) / 扔东西 / 纸飞机奖券
               "HidePickup","DropItem","PaperPlanePickup","RequestItemInfo"},
    trade   = {"Trade","RequestTrade","TradeRequest","TradeOffer","CashTrade",
               "Trade.Request","Trade.Ready","Trade.Select","Trade.SetConfirm","Trade.Toggle","Trade.Cancel",
               "CashGun.Fire","CashGun.Pickup","TradeLobby.Teleport"},
    chat    = {"Chat","SayMessage","SendMessage","Message","ChatMessage","PostieSent",
               -- ★ v6.10.1 DOORS: 游戏自己的系统播报/字幕(想刷屏或看官方提示都走这两条)
               "SystemMessage","Caption","CaptionWithChat"},
    round   = {"RoundStart","RoundEnd","GameStart","GameEnd","GameMode","RoundResult"},
    -- ★ v6.10.1 DOORS: Teleport / ServerTeleported / SwitchServers(换服) / SkipToRoomNumber(跳房间)
    teleport= {"Teleport","ServerTeleported","SwitchServers","SkipToRoomNumber","UpdateFloor",
               "RequestTeleport","TeleportTo","JoinServer","TeleportToServer","CharacterService_TeleportCharacter",
               "Any.Teleport","Any.Teleporter","Any.PlaceTeleport","Any.ServerTeleport","EntityService.Teleported",
               "ReplicateService.Teleport","ClientTeleported","TradeLobby.Teleport"},
    kick    = {"Kick","KickPlayer","Ban","PlayerKick"},
    -- ★★ v6.9.0 用【事件库】里的真实 remote 名扩充（用户要求"根据现在的事件库补全补强"）
    --   下面这些名字全部来自 事件库/ 的抓包清单, 以前主脚本一个都没用上。
    itemuse = {"TryUse","UseItem","Use","RequestUse","ConsumeItem","UseTool","UseAbility",
               "ItemService.TryUse","Any.Track",
               -- ★ v6.10.1 DOORS: 用道具(手电/维生素/开锁器) / 用敌人模块 / 用事件模块
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
    -- ★★ v6.9.0 C 类新功能用的类别（名字同样取自事件库抓包清单）
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
    -- ★ v6.10.1 DOORS: 背包就是一条平铺的 Inventory(四件套), 没有 View/Query 那套
    inventory= {"Inventory","RequestInventory","RequestItemInfo",
               "RequestInventoryView","InventoryViewResponse","InventoryQueryService",
               "InventoryQueryService.Query","WeaponService.GetGlobalCounts","WeaponService.GetTradeCounts","CareerStatsService.Request",
                "RequestItems","SetBackpack","BackpackService"},
    emote   = {"PlayEmote","StopEmote","GlobalEmote","RequestEmote","EmoteService"},
    deathfx = {"DeathEffects_ClearAll","DeathEffects_ClearPersisting","EntityService.Died","TouchDead",
               -- ★ v6.10.1 DOORS: 这才是它真正的死亡信号(挂在 RemotesFolder 下, 平铺命名)
               --   —— 以前只找 ReplicatedStorage.Remote 这个容器, 所以控制台报
               --   "80 秒内没等到 ReplicatedStorage.Remote -> 死亡事件没订上"。
               "PlayerDied","Jumpscare","SpiderJumpscare","HideMonster"},
    -- ★★ v6.9.15 下面两类专门为【对战/交易服】补的(名字取自 2026-09-19 那份"没有机器人"扫描报告)
    combat  = {"CombatService.Action","CombatService.ActionEvent","CombatService.SetWeapon","CombatService.Ammo",
               "CombatService.SwitchSlot","WeaponService.SetSkin","WeaponService.SetWrap","WeaponService.SetFavorite",
               "WeaponService.ReName","WeaponService.ResetName","ShootingRangeDummy"},
    -- ★★ v6.10.1 用 2026-09-19【DOORS(门 · PlaceId 6839171747)】抓包清单补的事件名
    --   —— 用户要求: "功能缺少的事件在这部补"。
    --   这个游戏的 remote 全在 `ReplicatedStorage/RemotesFolder` 下、命名【平铺直白】,
    --   前面那些分层名(GameService.Revive 之类)一个都对不上, 所以通用功能在它里面全是"没找到"。
    --   下面每一类都只补【主脚本真会调用】的类别, 不加空类别。
    --   ⚠ DOORS 特色: 门 = `Workspace.CurrentRooms.<间号>.Door`(带 Func_Open 等 BindableEvent +
    --     ManualOpenPrompt); **假门 = `DoorFake`**(在 `SideroomDupe` 那种复制侧房里); 正常门 = `DoorNormal`。
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
    -- ★ v6.9.0 关键词也按事件库补
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
    -- ★★ v6.10.1 DOORS(门) 关键词(模糊查找用; 关键词是【子串匹配】, 所以只写最独特的那段)
    doors   = {"hitdoor","interaction_door","dooropen","doorfake","doornormal","currentrooms"},
    doorshop= {"prerunshop","requestshop","purchaseshopitem","inventoryshop","shopcode","giftproduct"},
}

-- 在 Remote 树里做关键词模糊扫描（限深 6，扫 Remote 容器 + ReplicatedStorage 根，避免漏）
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

-- ★ 通用查找: 先按别名精确找（走 findRemote 的路径/递归/缓存），再关键词模糊扫。
--   返回 (remote, 命中的名字, "alias"|"fuzzy")
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

-- 列出某类事件在当前游戏里到底有没有 / 叫什么（诊断用: SYS.ProbeEvent("heal")）
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



--##########################################################################
--# ★★ v6.9.0 自动领取 / 自动收集 / 死亡自动重生
--#   全部走 SYS.FindEvent 通用查找(别名表 + 关键词模糊扫描) —— 换游戏只要命名落表就生效。
--#
--#   ⚠️ 能力边界(写在最前面, 免得以为"没生效"):
--#     ✅ 能做: 游戏**本身免费**的 —— 每日/活动奖励、0 元商品、地上掉落物、宝箱。
--#     ⛔ 做不到: **白嫖付费物品**。购买是服务端权威: 客户端 FireServer(itemId) 之后,
--#        服务端查货币余额, 不够就拒绝 —— 客户端改不动服务端余额, 这是引擎架构, 不是脚本不行。
--#        真能 0 元买的, 只有服务端自己标价 0 的商品(用下面的「一键 0 元扫货」)。
--##########################################################################



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
    -- ★★ v7.7.0 G8) 移动限速护栏 —— 【唯一收口点】。所有"最终要写进 WalkSpeed / 物理约束"的速度
    --   都从这里过一道。开关关着时它只是"看一眼 return"(零开销), 开着时把超限值压到 SpeedCap。
    --   ⚠ 故意【不】去收 expectSpeed(): 那个是"我本来该有多快"这个判定基准, 收窄了反而会让
    --   反陷阱把我自己的正常速度误判成"被撞"。只收窄真正写出去的值, 判定基准不动。
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

    --================ ★ v6.6.0 数值锁定 —— ★ v9.9.0 整块删除(删除清理) ================
    --   删了什么: LockSpeed / LockJump / LockGravity 三个开关键 + LOCK_EPS / lockOrigJump /
    --             SYS.LockTick / SYS.SetLocks(连参数键 C_.Gravity 一起)。
    --   为什么删: 移动页的「数值锁定」分区早已不在界面上(现在是 飞行/移动加速/穿墙/免伤/跳跃),
    --             三个键因此变成"有读无写"的死键, 而 SYS.SetLocks() **全文件从未被调用过一次** ——
    --             也就是说这功能连"偷偷生效"都做不到, 纯粹躺着占地(还会被老存档的 T_ 复活成假开关)。
    --   卸载对称性不受影响: 它登记的循环 key 是 "Locks"(统一卸载走 SYS.Loops), 删了自然没有;
    --             世界重力由 UnloadAll 里已有的 `WS.Gravity=SYS.Orig.Gravity` 还原, 与本块无关。

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
                    -- ★★ v6.9.8 修「开了反陷阱免伤以后像被定住、很难走」(用户实测):
                    --   原来这段在 0.45 秒的复位窗口里【每帧】干两件事: ①水平速度清零 ②位置压回撞击点。
                    --   它分不清"被陷阱推走"和"我自己按 WASD 走开", 于是:
                    --     · 速度清零把你自己的移动速度也清掉了 -> 走两步停一下;
                    --     · 锚点 = 撞击那一刻的位置, 而 TRAP_BACK 只有 1.2 格 —— 正常走路 0.45 秒能走 7 格,
                    --       必然超阈值, 于是你刚迈出去就被拽回原地 = 表现就是"被定住、很难走"。
                    --   现在按【你有没有在按方向键】分开处理:
                    --     · 在走  -> 只把速度修正成"你自己的移动意图"(外力那部分照样抵消), 锚点跟着你走, 绝不回拉;
                    --     · 没在走却有水平速度 / 位移 -> 这才是被推开, 照旧清零 + 压回锚点。
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

--##########################################################################
--# ★★ v6.9.16 防回退(位置上报伪装) —— 按你的要求【融进飞行 / 加速】:
--#   开飞行或加速时自动挂上, 两个都关掉时自动卸下, 不单独占一个开关。
--#
--#   原理(来自 2026-09-19 那份对战服扫描报告): 客户端用 `ClientReplicateCFrame` 上报自己的 CFrame,
--#   服务端拿它跟自己的模拟比对, 发现"这一步走得太远"就判定瞬移 -> 把你拉回去(回退)。
--#   做法: hook 这个 remote 的 FireServer(单点 hook, 每次上报才触发, 不是每帧, 不掉帧),
--#   上报值改成【从上一个上报位置按正常速度走得出来的点】—— 服务端看到的就是"一直按规矩走"。
--#   ⚠ 只改上报值, 不动你的真实位置(飞行照飞); 切枪/落地的额外校验若存在, 仍可能被纠正, 这是极限。
--##########################################################################
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
                -- 正常速度(默认 22)*3 的可容忍步长: 留够余地, 又不至于一眼看出瞬移
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

    -- 飞行 / 加速 任一开着 -> 开; 都关 -> 关(卸载时也走这里)
    function SYS.SyncAntiRevert()
        local want=(SYS.T_.Fly==true) or (SYS.T_.Speed==true)
        if want then
            -- ★★★ v9.9.8 修【静默失效】(用户问「反检测开着和关着有什么区别」时发现的):
            --   旧写法 `P(AR.On)` 把返回值丢了 —— 而 AR.On 在**执行器没有 hookfunction**或
            --   **找不到 ClientReplicateCFrame** 时会 return false,"原因"，没人看见。
            --   后果: 防回退根本没挂上, 用户却毫不知情(开着飞行被拉回, 还以为是脚本坏了)。
            --   ⇒ 挂不上必须说出来。注意 AR.On 是"正常返回 false", 所以要看第二个返回值。
            local ok2,res,err=P(AR.On)
            if ok2 and res==false then
                SYS.Notify("⚠ 防回退没挂上: "..tostring(err or "未知原因").." (飞行/加速照常, 只是位置按真实值上报)", SYS.CY.yellow)
            end
        else
            P(AR.Off)
        end
    end
end

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
        local md=tostring(SYS.C_.DeepHideMode or "down")
        local ox=tonumber(SYS.C_.DeepHideOffX) or 0
        local oz=tonumber(SYS.C_.DeepHideOffZ) or 0
        -- ★★ v6.10.8 用户要求新增「平地」模式: 像左右偏移那样【只动水平、不动上下】——
        --   位置 = 当前 X/Z 加上左右/前后偏移, Y 保持你现在站着的高度(不潜地也不上天)。
        if md=="flat" then
            return Vector3.new(root.Position.X+ox, root.Position.Y, root.Position.Z+oz)
        end
        local sign=(md=="up") and 1 or -1
        local ty=DeepHideY + sign*depth
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

    --##########################################################################
    --# ★★ v6.9.0 事件预告 —— 提前把"要发生什么"播到 HUD（关菜单也看得见）
    --#   原理: Remote 的名字通常就写明用途。监听名字命中关键词的那些 remote 的 OnClientEvent，
    --#        一有动静就如实转述（不猜测）。例: monster / fake / real / boss / wave / round。
    --#   ⚠️ 能不能预告取决于游戏发不发信号：有些事件是纯本地演的，那就没有 remote 可听。
    --##########################################################################
    SYS.EventWatch = {
        keywords = {"monster","fake","real","boss","wave","round","event","spawn","alert","warn","announce","hint","notice",
                    -- ★ v6.9.0 补: 名字直接取自【事件库】抓包清单
                    "touchdamage","damagedeny","denyinform","highlight","renam","resetname",
                    "status","playstate","preSpawnDarken","prespawndarken","querylock",
                    "selectrole","selectedrole","deathEffects","deatheffects",
                    -- ★ v6.9.0 C5: 把 C 类新功能的信号也纳入预告
                    "mailbox","roulette","secretcase","prototypecase","socialrewards",
                    "friendreward","milestone","onlinereward","battlepass","minipass",
                    "serverlist","joinserver","teleporttoserver","pickgameteam","selectloadout",
                    "inventoryview","inventoryquery","operate","companion","dungeon",
                    -- ★★ v6.11 扩充(用户: "检查下我没有的监听事件…然后补强") —— 全部取自【事件库】抓包的
                    --   真实 remote 名 + 公开反作弊面。以前这几族一个都没在听, 所以"提前知道"总有盲区。
                    --   ① 经济/购买/领取(事件库里未覆盖最多的一族: 69 个)
                    "purchase","buyproduct","buygamepass","boxbuy","buyeventitem","purchaseresult",
                    "claimreward","claimdaily","claimweeklycase","claimpremiumreward","claimrebirthreward",
                    "claimseasonweapon","claimstall","claimtradetokenreward","collectrionclaim","dailyreward",
                    "rewardreceived","commanditemsreceived","friendreward","milestonereward","onlinereward",
                    --   ② 拾取/收集/掉落(58 个)
                    "pickup","collect","lootevent","dropcoin","dropflag","orbpickup","itemcapture","craftitems",
                    --   ③ 对局/回合/匹配(24 个) —— 提前知道"这局开局/结束/换模式"
                    "roundstart","roundend","gamestart","gameend","matchend","matchstart","result",
                    --   ④ 箱/抽奖/赌(开箱预告)
                    "gacha","spin","raffle","secretluck","case","jackpot",
                    --   ⑤ 任务/赛季/排位
                    "quest","seasonchanged","challenge","ranked",
                    --   ⑥ 死亡/复活/复活队友(玩恐怖/跑图游戏最有用)
                    "playerdied","revive","resurrect","checkrevive",
                    --   ⑦ ★ 反作弊/管理员信号 —— 能"提前知道自己被盯上了", 比事后被踢强
                    "detect","detected","violation","flagged","punish","suspicious","antich","automod","report"},
        conns = {}, seen = {},
    }

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
    --##########################################################################
    --# ★★ v6.9.0 抓包自动带游戏名
    --#   游戏名优先走 MarketplaceService:GetProductInfo(PlaceId)（官方 API，拿不到就退化）；
    --#   无论拿不拿得到，PlaceId / GameId / CreatorId 一定会有 —— 换游戏时靠它们区分。
    --##########################################################################
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
                nm="Place"..pid          -- 拿不到名字就用 PlaceId 兜底
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


    -- ★★ v8.11.0 新增: 【纯 ASCII】文件名安全化(治"中文文件名乱码")。
    --   实测(用户桌面实拍): 执行器写出的文件名里 ASCII 部分正常, 中文全变乱码 ——
    --     `Remotes_[W2]_踢一个幸运块_77340226777613_x.txt`
    --     实机文件名 = `Remotes_[W2]_韪竴涓垢杩愬潡_77340226777613_x.txt`
    --   成因: 执行器写文件名时用的不是 UTF-8(走的是系统 ANSI 代码页),
    --   所以**只要路径里有中文就一定会花** —— 换执行器也治不了。
    --   ⇒ 结论: 路径(文件夹名 + 文件名)一律只用 ASCII; 真正的中文服务器名写进【文件内容】里
    --     (文件内容编码没问题, 实测内容读出来是正常的)。
    local function safeAscii(s, maxLen)
        local r=tostring(s or "")
        r=r:gsub('[\\/:*?"<>|]',"_")
        r=r:gsub("[^%w%._%-]","")        -- 只留 字母/数字/下划线/点/短横
        r=r:gsub("_+","_")
        r=r:gsub("^_+",""):gsub("_+$","")
        if maxLen and #r>maxLen then r=r:sub(1,maxLen) end
        if r=="" then r="srv" end
        return r
    end
    SYS.SafeAscii=safeAscii

    -- 抓包结果写文件（执行器有 writefile 才写）。返回文件名或 nil。
    function SYS.SaveRemotes(found)
        if not writefile then return nil end
        -- ★★ 9.8.1 用户定稿「完完整整的放一个文件 CheatMenu 里面」——
        --   在「综合扫描」里【不再另出一个文件】, 与 SYS.SaveDump 同一条口径。
        --   实测旧行为: 综合扫描会在同一目录里再落一个 `remotes_<PlaceId>_<时间>.txt`,
        --   用户看到的就是"明明说好一个文件, 结果目录里两个"。清单本身已由
        --   SYS.DumpRemotes 逐行 SYS.ScanEmit 进扫描缓冲 ⇒ 内容一条不少, 只是不另开文件。
        if SYS.ScanOutFile then return SYS.ScanOutFile end
        local info,nm,pid=SYS.GameInfoLine()
        local stamp=os.date("%Y%m%d_%H%M")
        -- ★★ v9.1.0 文件名改用【纯 ASCII】(治乱码): remotes_<PlaceId>_<时间>.txt
        --   真名写在文件内容里(info 那一行本来就有)。
        local fn=("remotes_%s_%s.txt"):format(safeAscii(pid,20),stamp)
        local buf={}
        buf[#buf+1]="-- CheatMenu 抓包清单"
        buf[#buf+1]="-- "..info
        buf[#buf+1]="-- 服务器名: "..tostring(nm).."    PlaceId: "..tostring(pid)
        buf[#buf+1]="-- 时间: "..os.date("%Y-%m-%d %H:%M:%S")
        buf[#buf+1]="-- 由 SYS.DumpRemotes() 生成 · 共 "..tostring(#(found or {})).." 条"
        buf[#buf+1]=""
        for i,r in ipairs(found or {}) do buf[#buf+1]=("  [%d] %s"):format(i,r) end
        local ok=P(function() writefile(fn,table.concat(buf,"\n")) end)
        return ok and fn or nil
    end

    -- ★ 通用落盘: 把任意一段扫描结果写成文件(给「综合扫描」的 DEX 层 / Remote 层用)。
    --   ★★ v9.1.0 起: 在「综合扫描」里面【不再单独落盘】—— 统一返回 SYS.ScanOutFile(那一个 txt),
    --   内容由 line() 的缓冲在扫描结尾一次性写出。只有在扫描之外被调用时才自己写一个 ASCII 名文件
    --   (`dump_<标签>_<PlaceId>_<时间戳>.txt`; 中文名只写在内容里)。
    --   执行器没有 writefile 就返回 nil, 由调用方自己决定怎么提示。
    -- ★★ v9.1.0 改: 原来每层各写一个文件(`DEX_*.txt` / `Remote_*.txt`), 文件名里带中文 -> **乱码**,
    --   而且违反用户"只出一个 txt"的要求。
    --   现在【不单独写】—— 返回即将生成的那个【单文件名】(由 FullScan 在开始时就定下来),
    --   调用方照常打印"✅ 完整清单已落盘: xxx", 但内容由结尾统一写入那一个文件。
    --   ⚠ 若在「综合扫描」之外被调用(没有 SYS.ScanOutFile), 才退回自己写一个 ASCII 名文件。
    function SYS.SaveDump(tag, lines)
        if not writefile then return nil end
        if SYS.ScanOutFile then
            SYS.ScanOutExtra=SYS.ScanOutExtra or {}
            SYS.ScanOutExtra[#SYS.ScanOutExtra+1]=tostring(tag).."("..tostring(#(lines or {})).." 行)"
            return SYS.ScanOutFile
        end
        local info,nm,pid=SYS.GameInfoLine()
        local stamp=os.date("%Y%m%d_%H%M%S")
        local fn=("dump_%s_%s_%s.txt"):format(safeAscii(tag,12),safeAscii(pid,20),stamp)
        local buf={
            "-- CheatMenu 综合扫描 · "..tostring(tag),
            "-- "..tostring(info),
            "-- 服务器名: "..tostring(nm).."    PlaceId: "..tostring(pid),
            "-- 时间: "..os.date("%Y-%m-%d %H:%M:%S"),
            "-- 共 "..tostring(#(lines or {})).." 行",
            "",
        }
        for i=1,#(lines or {}) do buf[#buf+1]=tostring(lines[i]) end
        local ok=P(function() writefile(fn,table.concat(buf,"\n")) end)
        return ok and fn or nil
    end

    --##########################################################################
    --# ★★ v8.9.0 综合扫描【全部十层】落盘 —— 桌面\CheatMenu\<服务器名>\
    --#   用户要求:「把全部抓到的 自动发到电脑桌面 然后文件夹是服务器的名字」
    --#   ⚠ 执行器的 writefile 能否写【绝对路径】因执行器而异(多数只允许自己的工作目录),
    --#     所以这里【逐个探测】候选路径(先建目录、写一个探针文件、再用 isfile 查在不在),
    --#     第一个真能写进去的才用 —— 不靠猜、也不假装成功。
    --#   全都不行 -> 退回执行器工作目录(相对路径), 并把【实际去向】明确打出来。
    --##########################################################################
    SYS.ScanOutDir=nil
    SYS.ScanOutWhy=nil
    function SYS.ResolveScanDir()
        if SYS.ScanOutDir then return end
        if type(writefile)~="function" or type(isfile)~="function" then
            SYS.ScanOutWhy="执行器不支持 writefile / isfile"
            return
        end
        local _,nm,pid=SYS.GameInfoLine()
        -- ★★ v8.11.0 路径规则(按用户要求 + 治乱码):
        --   ① 【文件夹名只用 ASCII】: `<PlaceId>_<服务器名里的ASCII片段>` ——
        --      因为执行器写文件名走系统 ANSI 代码页, 中文必然乱码(用户桌面实拍已证实)。
        --      真正的中文服务器名写进【文件内容】+ 文件夹里另放一个 `服务器名.txt`。
        --   ② 优先放到用户的「包」目录(方便管理), 其次桌面, 最后执行器工作目录。
        -- ★★ v9.1.0 按用户要求收口:「保持在这里了 C:\...\Real\workspace 这里就这里吧」
        --   ⇒ **不再尝试写桌面 / 「包」**，直接用【执行器工作目录】(相对路径 = workspace)。
        --     实测执行器 = Real, 工作目录 = C:\Users\Administrator\AppData\Local\Real\workspace
        --     (与 .workbuddy/build/local_sync.py 里的 WS 常量一致)。
        --   文件夹名仍然只用 ASCII(治乱码); 真名写在文件内容里。
        local folder=("%s_%s"):format(safeAscii(pid,20),safeAscii(nm,16))
        -- ★★ 9.8.1 用户定稿:「完完整整的放一个文件 CheatMenu 里面」——
        --   ⇒ ① 直接就是 workspace\CheatMenu, **不再按服务器再套一层子文件夹**。
        --     文件名本身是 scan_<PlaceId>.txt, 天然按游戏区分, 换游戏也不会互相覆盖。
        --     实测旧行为: 落到了 workspace\CheatMenu\89469502395769_srv\, 用户的原话是"你位置都错了"。
        --   ②③④ 只是建不出来时的兜底。
        local cands={
            "CheatMenu",             -- ① workspace\CheatMenu                       ← 用户要的位置
            "CheatMenu\\"..folder,   -- ② workspace\CheatMenu\<PlaceId>_<ASCII名>     (兜底)
            folder,                  -- ③ workspace\<PlaceId>_<ASCII名>
            ".",                     -- ④ workspace 根
        }
        -- ★★ v8.11.0 修「没到我要的位置」的根因:
        --   很多执行器的 `makefolder` 只能建【最后一级】(不是 mkdir -p)。
        --   而 `包\<PlaceId>_<名字>` 是【两级全新的目录】—— 只调一次 makefolder 时,
        --   父级 `包` 还不存在 -> 建不出来 -> writefile 到不存在的目录 -> 探针失败
        --   -> 一路退到执行器工作目录(用户看到的"没到我要的位置")。
        --   现在改成【逐级建目录】(等价 mkdir -p), 并且失败时把"试过哪些路径"打出来。
        local function mkdirp(full)
            if type(makefolder)~="function" then return end
            local parts={}
            for seg in tostring(full):gmatch("[^\\/]+") do parts[#parts+1]=seg end
            local acc=""
            for i=1,#parts do
                if i==1 then
                    acc=parts[i]                       -- "C:" 或 相对目录的第一级
                else
                    acc=acc.."\\"..parts[i]
                end
                pcall(makefolder,acc)
            end
        end
        local tried={}
        for _,dir in ipairs(cands) do
            local ok=P(function()
                mkdirp(dir)
                writefile(dir.."\\_probe.txt","ok")
            end)
            if ok and isfile(dir.."\\_probe.txt") then
                SYS.ScanOutDir=dir
                SYS.ScanOutWhy=(dir:find("\\包\\") and "包目录") or (dir:find("Desktop") and "桌面") or "执行器工作目录"
                -- ★★ 9.8.1 用户要求「就一个文件」⇒ 不再额外写 server_name.txt。
                --   服务器真名/PlaceId/JobId 本来就在扫描 txt 的头几行里(GameInfoLine + 文件名带 PlaceId),
                --   信息一点没少, 目录里也不会再出现第二个文件。
                -- 探针用完删掉, 别在用户目录里留垃圾
                pcall(function()
                    if type(delfile)=="function" then delfile(dir.."\\_probe.txt") end
                end)
                return
            end
            tried[#tried+1]=dir
        end
        SYS.ScanOutTried=tried
        SYS.ScanOutWhy="所有候选路径都写不进去。试过:\n       "..table.concat(tried,"\n       ")
    end

    -- ★★ v8.10.0 按用户要求改成【只出一个 txt】:
    --   原话「然后能让那些全部扫描出来的 不要分多个txt文档吗 就放在一个里面」——
    --   所以不再按十层拆文件, 全部十层原样拼在【同一个 txt】里(十层的分隔线仍然保留, 里面照样能按层看)。
    --   文件名带上服务器名, 即使被挪出文件夹也知道是哪台服务器抓的。
    function SYS.DumpScanAll(buf)
        SYS.ResolveScanDir()
        local dir=SYS.ScanOutDir
        if not dir then return nil,SYS.ScanOutWhy end
        local info,nm,pid=SYS.GameInfoLine()
        local stamp=os.date("%Y%m%d_%H%M%S")
        -- ★★ v9.1.0 文件名【纯 ASCII】(治乱码): scan_<PlaceId>_<时间戳>.txt
        --   优先用 FullScan 开始时就定好的 SYS.ScanOutFile(与中途 SaveDump 返回的名字一致)。
        local fn=SYS.ScanOutFile or ("scan_%s_%s.txt"):format(safeAscii(pid,20),stamp)
        -- ★ 9.9.2: 这个数字是【缓冲条目数】, 不是文件的物理行数 ——
        --   A/B/C 三层有 3 处 `SYS.ScanEmit(table.concat(out,"\n"))`, 一整块多行文本算【1 条】,
        --   于是落盘文件会比这里多几十~上百物理行(实测 1306 条 → 1445 行)。
        --   以前只写"共 N 行", 用户拿行数一数对不上会以为内容被截断了。
        --   ⚠ 别把"行"改成"条": 门禁 _scan_out_unit.py 的 R5 锁的就是 `共 N 行` 这个子串。
        local t={"-- CheatMenu 综合扫描（全部十一层 · 单文件）",
                 "-- "..tostring(info),
                 "-- 服务器名: "..tostring(nm).."    PlaceId: "..tostring(pid),
                 "-- 时间: "..os.date("%Y-%m-%d %H:%M:%S"),
                 "-- 共 "..tostring(#(buf or {})).." 行(缓冲条目数; 部分条目自身含换行, 文件物理行数会更多)",
                 "-- 输出目录: "..dir,
                 ""}
        for i=1,#(buf or {}) do t[#t+1]=tostring(buf[i]) end
        local text=table.concat(t,"\n")
        local path=dir.."\\"..fn
        -- ★★ 9.8.1 只在【内容真的不同】时才留 `.prev.txt`。
        --   用户原话是"覆盖旧的可以, 除非内容不同"; 旧实现是**无条件备份**,
        --   实测两份内容一模一样却照样生成了 `.prev.txt` ⇒ 目录里平白多一个文件,
        --   和"就一个文件"的要求相冲突。现在内容相同 ⇒ 不产生任何多余文件。
        pcall(function()
            if type(isfile)=="function" and isfile(path) and type(readfile)=="function" then
                local old=readfile(path)
                if old~=text and type(writefile)=="function" then
                    writefile(path..".prev.txt", old)
                end
            end
        end)
        if P(function() writefile(path,text) end) then
            return {fn}, SYS.ScanOutWhy, dir
        end
        return nil, "写入失败("..fn..")", dir
    end

    -- ★ 2026-09-21 删掉过的一段孤儿代码(留个说明, 免得以后又被人加回来):
    --   这里原先重复声明了 HudGui/HudLabel/HudHideAt 三个【同名】local, 并把自动隐藏心跳挂在
    --   这组变量上。真正的实现在下面 L3061 那一节(那里自己也有一组同名 local 和一条心跳)。
    --   同名 local 在后 = 后面那组遮蔽前面这组, 于是上面那条心跳闭包捕获的三个变量【永远为 nil】
    --   -> 每帧 `if HudHideAt and ...` 判定恒假, 纯空转死代码。真正生效的是 L3105 那条。
    --   附带风险: 改 HUD 的人很容易先看到上面这份, 改了却一点效果都没有。

    --##########################################################################
    --# ★★ v6.9.0 C 类推荐功能（用户选定）—— 别名全部取自事件库
    --#   C1 自动商店 + 一键开箱 · C2 一键全领 · C3 服务器列表/换服
    --#   C4 背包读取 · C6 自动选队伍/角色
    --##########################################################################









    --##########################################################################
    --# ★★ v6.9.0 冷却加速 / 自动连用（"无限使用"能实现的那一部分）
    --#
    --#   ⛔ 绕不过的: 物品【数量】·【耐久】·【使用次数上限】·背包里有没有
    --#      —— 这些数字在【服务端】。客户端发的只是"我想用"的请求, 服务端拿自己的副本校验 + 扣减。
    --#      要"凭空加数量/免耐久", 等于改服务端数据, 客户端没有这个通道。
    --#      (本地把显示改成「999」只是骗自己, 一操作就被服务端覆盖回来。)
    --#   ✅ 能做的:
    --#      · 【冷却加速】很多游戏把"上次使用时间"存在客户端, 用 os.clock()/tick()/os.time()
    --#        算"够不够时间"。把时间函数 hook 成走得更快 -> 冷却立刻到期, 就能连续用。
    --#        ⚠️ 只对【客户端判定的冷却】有效; 服务端若也限流, 还是会被拒。
    --#      · 【自动连用】不用手点, 脚本帮你按住不放 —— 消耗照旧, 频率拉满。
    --##########################################################################

    -- 时间加速: 平滑地把"时间流逝"放大 scale 倍(1.0 = 关闭)。不用乘性跳变, 避免游戏逻辑错乱。
    SYS._realClock = SYS._realClock or os.clock
    SYS._realTime  = SYS._realTime  or os.time
    SYS._timeScale = 1
    SYS._timeAcc   = 0
    SYS._timeLast  = SYS._realClock()
    local _tsHooked = false


    --##########################################################################
    --# ★★ v6.9.0 反陷阱预警 / 状态监听（信号名全部取自事件库）
    --#
    --#   事件库里这几个名字就是"陷阱/伤害/状态"的权威信号:
    --#     · TouchDamage        —— 接触伤害（陷阱、地刺、压碎机造成的伤害几乎都走这条）
    --#     · DamageDenyInform   —— 伤害被拒（无敌/护盾挡下来了）
    --#     · StatusService / PlayState —— 状态变化
    --#     · QueryLock / SelectedRole  —— 目标锁定 / 角色选择
    --#   把这些【监听】起来并 HUD 播报 —— 也就是"反陷阱"最实用的形态:
    --#   陷阱一触发你立刻知道(而不是莫名其妙掉血), 伤害被挡也告诉你。
    --#
    --#   ⚠️ 注意: 这是【预警/播报】, 不是"让陷阱无效"。让陷阱不造成伤害属于改服务端判定,
    --#      客户端做不到 —— 客户端能做的本地处理见 TrapImmune(本地免伤)。
    --#      ★ 2026-09-22: 原来这里还写着 Prot_AntiAC(本地拦 Kick), 那项已按"防不住就删"删除
    --#        —— 真实踢/封由服务端发出, 客户端 hook 拦不到, 而且 hook 本身会被反向检测。
    --##########################################################################
    -- 一次性把本游戏里这些信号是否可用打印出来（抓包/换游戏时先跑这个）
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




    --##########################################################################
    --# ★★ v6.9.0 隔空获取（全部 / 单独）
    --#   ✅ 只要游戏有 pickup/collect 类 remote，客户端不靠近也能触发它。
    --#   ✅ 全部 = 把场景里所有可拾取物逐个发一遍；单独 = 只拿离你最近的那个。
    --#   ⛔ 刷物品: 做不到。物品增减是【服务端】权威 —— 客户端发的是"请求"，
    --#      服务端按自己的库存/规则处理。凭空造物只可能来自游戏自身漏洞，客户端没有合法途径。
    --##########################################################################
    -- 收集场景里"可以拿"的东西：ProximityPrompt / ClickDetector / Tool / 名字像掉落物的部件
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


    --##########################################################################
    --# ★★ v6.9.0 HUD 常驻提示 —— 独立于菜单，【关掉 UI 也看得见】
    --#   用途: 热更新提示 / 事件预告(怪物出现等) / 关键状态播报。
    --#   用法: SYS.Hud("文本", 显示秒数)   留空秒数 = 4 秒; 传 0 = 常驻不自动消失
    --##########################################################################
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
    -- 自动隐藏
    if RS and RS.Heartbeat then
        T(RS.Heartbeat:Connect(function()
            if HudHideAt and os.clock() >= HudHideAt then
                HudHideAt = nil
                P(function() if HudGui then HudGui.Enabled = false end end)
            end
        end))
    end

    --##########################################################################
    --# ★★ v6.9.0 统一扫描器
    --#   ① SYS.RegisterScanner(name, fn, desc)  —— 注册表。以后加探测项只要注册一行,
    --#      它就自动进统一扫描, 不用再改别的地方。
    --#   ② SYS.ScanAll(opts)  —— 一键全扫: 控制台 + 文件 + 剪贴板 三通道。
    --#      opts.copy  = true 时把结果复制到剪贴板
    --#      opts.file  = false 时不写文件
    --#      并且会【核对】: 收集到的行数 == 写进文件的行数, 不一致就报警
    --#      (就是"扫描到的东西有没有被漏掉"的自检)。
    --##########################################################################
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



    --##########################################################################
    --# 把现有探测函数注册进统一扫描（以后新增: 再加一行 SYS.RegisterScanner 即可）
    --##########################################################################
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

    -- ★★ v6.9.28 自动躲避状态: 整合进统一扫描(原来在 MachineParty 页单独一个按钮, 用户要求合并)
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

    -- ★★ v6.9.12 反作弊专项扫描(用户要求): 把客户端【看得见】的反作弊痕迹一次扫出来, 结果直接进「统一扫描」报告。
    --   为什么要它: 飞行/加速/传送被"回退"时, 你首先得知道【是谁在拦你】——
    --   是客户端脚本(能看到, 可想办法绕) 还是纯服务端(看不到, 只能控制位移幅度别触发阈值)。
    --   三层:
    --     ① 名字命中反作弊关键词的实例(ReplicatedStorage / PlayerScripts / PlayerGui / Workspace …);
    --     ② 名字像【位置上报/校验】的 Remote —— 这是"位置回退"最常见的来源(客户端上报 -> 服务端比对);
    --     ③ 已加载的模块脚本(要执行器有 getloadedmodules, 没有就跳过)。
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

        -- ① 名字命中的实例
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

        -- ② 像"位置上报 / 校验"的 Remote
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

        -- ③ 已加载模块
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
        -- ★★ 9.8.1 用户报「还少了」: 这 200 多条清单以前只走 `print`, **绕过了扫描缓冲**
        --   ⇒ 落盘的那唯一一个 txt 里【没有 A 通信层的完整清单】(只有 FullScan 里那几行关键词命中)。
        --   现在有扫描缓冲就同时写进去; 单独调用(没有缓冲)时它就是普通 print。
        SYS.ScanEmit("========== 【A 通信层】游戏接口完整清单(Remote / Bindable / 交互) ==========")
        SYS.ScanEmit("[Remote] ===== "..info.." =====")
        SYS.ScanEmit("[Remote] 抓包时间: "..os.date("%Y-%m-%d %H:%M:%S"))
        SYS.ScanEmit(("[Remote] ===== 全方位扫描: 网络 RemoteEvent %d + RemoteFunction %d | 本地 BindableEvent %d + BindableFunction %d | 交互 ProximityPrompt %d + ClickDetector %d =====")
            :format(counts.RE,counts.RF,counts.BE,counts.BF,counts.PP,counts.CD))
        -- ★ v9.9.3: 逐条标风险(蜜罐/管理后台/审计), 免得照着清单手发把自己送进去
        local risky=0
        for i,r in ipairs(found) do
            local nm=tostring(r):match("([%w_%.]+)$") or tostring(r)
            local risk=SYS.RemoteRisk(nm)
            if risk then risky=risky+1 end
            SYS.ScanEmit("  ["..i.."] "..r..(risk and ("\n            "..risk) or ""))
        end
        if risky>0 then
            SYS.ScanEmit(("[Remote] ⚠ 上面有 %d 条被判为高风险(蜜罐/后台/审计) —— 只列出来, 不要触发"):format(risky))
        end
        SYS.ScanEmit("[Remote] 扫描完成, 清单在上面")
        -- ★ v6.9.0: 自动落盘（文件名自动带游戏名 + PlaceId + 时间）
        local savedFn=SYS.SaveRemotes(found)
        if savedFn then
            -- ★★ 9.8.1: 综合扫描里不再单独落文件(见 SaveRemotes), 别谎报"已另存"。
            if SYS.ScanOutFile then
                print("[Remote] (清单已并入本次综合扫描的那【一个】txt, 不再另存文件)")
            else
                print("[Remote] ✅ 已保存: "..savedFn.."   （即工作目录）")
            end
        else
            print("[Remote] (这台执行器不能写文件, 请手动复制上面的清单)")
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
        -- ★★ 补强(2026-09-20, 参考公开脚本的挂机防踢做法): 只挂 Idled 挡不住"服务端按心跳/活跃度判 AFK"
        --   的守卫。这里再补两手(都纯本地, 且是低频 5 秒一次 -> 几乎零开销):
        --     ① 周期性给 LocalPlayer 写一个心跳属性 —— 不少游戏的守卫读 Attribute("Heartbeat")/("AFK")
        --        这类客户端可写字段来判"你还在不在"。
        --     ② 站着不动时让角色跳一下 —— 骗过"按位移/状态判活跃"的守卫。
        --        ★ 只在速度 <1(基本站定)时跳, 移动中不打扰; 服务端若按位移判定仍可能不认, 属正常边界。
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

    local HL,LB,HB={},{},{}   -- HL=人物高亮(Highlight) LB=名字标签 HB=方框(可选)
    -- ★★ 新增: 怪物/NPC 透视池(HN) + 缓存的 NPC 列表(扫描节流用)
    local HN={} SYS._npcList=nil SYS._npcN=0
    -- ★★ 新增: 可交互道具透视池(HP) + 缓存列表
    local HP={} SYS._pickList=nil SYS._pickN=0
    -- ★★ 新增: 门 / 陷阱类透视池(HD) + 缓存列表
    local HD={} SYS._doorList=nil SYS._doorN=0
    -- ★★ 新增: 门/陷阱/地雷的骷髅头标记池(HD_SK, BillboardGui ☠)
    local HD_SK={}
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

    --##########################################################################
    --# ★★ 合并: 统一扫描索引器 SYS.Index()
    --#   合并前 —— 下面这些消费者【各自】调一次 WS:GetDescendants():
    --#     生物透视 / 可交互透视 / 门·陷阱透视 / 小游戏区域透视 /
    --#     自动触发小游戏 / 快速交互 / 读密码提示 / 自动藏身找藏身点  = 8 处。
    --#     同一份数据被完整遍历 8 遍; 图大的时候这就是主要的卡顿来源。
    --#   合并后 —— 只保留【一次】扫描 + 缓存, 8 个消费者全部读它。
    --#     各消费者内部的判据 / 配色 / 池子逻辑【一行都没改】(所以行为不变)。
    --#
    --#   ★ 为什么 TTL 取 0.4s:
    --#     消费者本来就各自节流(多数是 25 tick ≈ 0.42s、快速交互 2s、读提示手动触发),
    --#     TTL 设成 0.4s 正好让它们落进同一个窗口共用同一次扫描。
    --#     取 1s 以上会明显滞后(新出现的物件要等一秒才亮), 取太小又失去合并意义。
    --#   ★ 为什么安全:
    --#     返回的列表可能是"上一次的", 里面可能有已销毁的实例 —— 但改之前也是这样
    --#     (扫描完成到真正使用之间实例就可能被销毁), 各消费者本来就有 o.Parent 判空
    --#     且整体包在 P() 里。这里不引入新的错误类型, 只是把"扫描"这一步去重。
    --#   ★ 不接进来的: 掉落物透视 (:4918 注释明确写了"绝不上 GetDescendants")、
    --#     自动躲避 (:5088 只用浅扫) —— 它们本来就便宜, 保持原样。
    --##########################################################################
    local IDX={ t=0, desc=nil }
    function SYS.Index()
        local now=os.clock()
        if IDX.desc and (now-IDX.t)<0.4 then return IDX.desc end
        local ok,d=P(function() return WS:GetDescendants() end)
        if ok and type(d)=="table" and #d>0 then
            IDX.desc=d IDX.t=now
            return d
        end
        -- 扫描失败(或这张图暂时一个对象都没有): 有旧的就先拿旧的顶着 —— 返回空表而不是 nil,
        -- 免得调用方 ipairs(nil) 当场炸掉。
        return IDX.desc or {}
    end
    --##########################################################################
    --# ★★ 合并: 共享判据表 (SYS.Kw*)
    --#   合并前 —— 同一套判据被两个以上功能各写了一份, 改一处必忘另一处:
    --#     ① 小游戏区域名: ESP_Mini 里一份 + AUTO_MINI_AREA 里又一份 (内容一模一样)
    --#     ② 危险/伤害词:   门·陷阱透视的 KW 前 39 项 == 自动躲避的 DODGE_KW (逐项比对过)
    --#     ③ 藏身点词:      透视的「躲藏点」+ 自动藏身的 AH_KW
    --#     ④ 线索物件词:    透视的「书籍/纸张/线索」+ 读密码提示内联那一串
    --#   合并后 —— 全部集中到这里声明一次, 各功能引用同一份。
    --#   ★ 声明位置: [08] 是顶层 do...end, 脚本加载期就执行 —— 后面的模块(:12139 的 AH_KW 等)
    --#     引用它时一定已经存在, 不存在"读到 nil"的时序坑。
    --##########################################################################

    -- ① 小游戏区域名(命中即算"小游戏里的东西")。来自抓包: Workspace.duck hunt / Chisel Gauntlet /
    --    Lobby.MPStation_* / MPPadHost_* + 模块名 RightOfWay / Blindout / CrushHour / BumperMadness
    --   ★★ v9.9.8 补齐(用户「陷阱都补强」+ 问「雷区那个小游戏」): 拿机器派对抓包里的
    --      `MachineParty*` 模块名逐个对了一遍, 发现原来只覆盖 11 个、**漏了一大半真实小游戏**,
    --      包括用户问的那个 **Minefield(雷区)**。漏的后果: 那些区域不算"小游戏区域"⇒
    --      区域内的机关既不会走 ESP_Mini(青色)、也不会被新的"区域内→危险升级"标红。
    --   ⚠ 只加【具体到不会误伤】的名字: 刻意不加裸 "mine"(会命中 mineral/minetown 这类普通物件名)——
    --     雷区靠 "minefield" 命中即可, 而雷本身名字里的 "mine" 由 KwHazard 的 hazard 词表负责。
    SYS.MiniArea = {"duck hunt","duckhunt","chisel","gauntlet","rightofway","blindout","crushhour",
                    "bumpermadness","mppadhost","mpstation","machin",
                    "minefield","trainrace","tablemanners","stablefooting","lethalrebound",
                    "spinebreaker","firearmfactory","wrongway","cellbarrier"}
    SYS.MiniAreaCN = {"小游戏","关卡","模式"}

    -- ②-b 敌意 / 怪物词 —— 【活物透视的敌对判定】与【自动藏身/躲避的怪物判定】共用这一份。
    --   ★ v9.9.7 合并: 这两处原来各写一份, 而且内容还不一样(一份有 kill/attack/guard, 另一份没有)
    --     —— 典型的"改一处必忘另一处", 现在只有这里一处。
    --   ★ v9.9.7 补 DOORS 实体名(用户要求"怪物透视也要在报告里面全部进行透视"): 抓包里出现的
    --     Screech / Firedamp / Dread 补上, 另补 Grumble / Timothy / Goblino / Lookman / Blitz /
    --     Giggle / Shadow(Seek / Rush / Ambush / Eyes / Dupe / Figure / Halt / Snare / Glitch 本来就有)。
    --   ⚠ 刻意【不】加 hide / window / void / bob / jeff —— 那些会撞上"藏身点""窗户""地图道具"的名字,
    --     把道具误标成怪物。宁可漏标, 不可误标(与"拿不准一律算中立橙"同一个保守口径)。
    SYS.KwHostile = {"monster","enemy","hostile","killer","kill","attack","aggro","boss","guard",
                     "zombie","mob","hunter","stalker","chaser","demon","ghoul","skeleton","brute",
                     "seek","rush","ambush","figure","halt","screech","eyes","dupe","snare","spider",
                     "jumpscare","cursed","glitch","entity",
                     "grumble","firedamp","dread","timothy","goblino","lookman","blitz","giggle","shadow"}
    SYS.KwHostileCN = {"怪","敌","杀手","恶魔","猎","鬼","僵尸","追","凶"}

    -- ★★★ v9.9.8 防护加强(用户「看看还能过哪些检测, 加强补上」):
    --   统一的"自建可视实例"工厂 —— 凡是我们自己往世界里挂的实例(Highlight / 标签 / 线)
    --   都从这里造, 一次把两件事做掉:
    --     ① `Archivable=false` —— 反作弊会用 `GetDescendants()+Clone()` 把可疑实例打包带走,
    --        Archivable=false 的实例【Clone 不出来】, 这条对它有效;
    --     ② 中性名 —— 不用默认类名, 减少"按名字扫"的可命中面。
    --   ⚠ 诚实边界: 这**挡不住**"遍历 Workspace 找 Highlight / 多出来的 Part" ——
    --     那种检测靠 `:IsA("Highlight")` 认类, 跟名字和 Archivable 都无关。透视类功能
    --     只要把实例挂进世界, 就有这个固有代价; 唯一可能规避的办法(挂受保护容器+Adornee)
    --     在"能否正常渲染"上不确定, 不敢默认开。
    function SYS.NewVis(cls)
        local ok,inst=P(function()
            local o=Instance.new(cls)
            o.Archivable=false
            return o
        end)
        if not ok or not inst then return nil end
        P(function()
            if inst.Name==cls then inst.Name=SYS.N.Combat end   -- 中性名(与环境里已有的渲染实例同名)
        end)
        return inst
    end

    -- ②-a 危险/伤害类词 —— 【门·陷阱透视】与【自动躲避】共用这一份(原来各写一份, 现已去重)
    SYS.KwHazard = {"door","gate","trap","trapdoor","hatch","portal","hazard","damage","damaging","kill","lava",
        "spike","spikes","pit","void","saw","blade","crusher","crush","piston","hammer","press",
        "fire","burn","acid","poison","zap","electric","deadly","spider","rig","bumper","chisel","gauntlet",
        "obstacle","mine","landmine","bomb","tnt","explosive"}
    -- ②-b 门/通道类扩展词 —— ★ 只有【门·陷阱透视】认这些; 【自动躲避】绝不能认:
    --      认了就会去"躲"出口/楼梯/传送门/假门 —— 那是行为事故, 不是功能。
    SYS.KwGateExtra = {"exit","entrance","entry","doorway","doorframe","threshold","archway","passage","corridor",
        "tunnel","stairs","stair","elevator","lift","teleport","warp","fake","decoy","false",
        "trick","danger","death","fatal","hurt","ouch"}
    -- ②-c 合并结果 ≡ 原来那份 KW(顺序与内容完全一致, 纯去重不改行为)
    SYS.KwGate = {}
    for _,w in ipairs(SYS.KwHazard)    do SYS.KwGate[#SYS.KwGate+1]=w end
    for _,w in ipairs(SYS.KwGateExtra) do SYS.KwGate[#SYS.KwGate+1]=w end
    SYS.KwGateCN = {"门","陷阱","机关","刺","熔岩","伤害","危险","地雷","炸弹","关卡","考验",
                    "出口","入口","传送","电梯","楼梯","假门","伪装","死亡","致死","致命","坑"}
    -- ②-d 危险词(只这些才标红 + ☠), 与 ②-a 是不同用途, 别混
    SYS.KwTrap = {"trap","trapdoor","hazard","damage","damaging","kill","lava","spike","pit","void","saw",
                  "blade","crusher","crush","piston","hammer","press","fire","burn","acid","poison",
                  "zap","electric","deadly","mine","landmine","bomb","tnt","explosive",
                  "fake","dupe","false","danger","death","fatal","hurt","ouch"}
    SYS.KwTrapCN = {"陷阱","机关","刺","熔岩","伤害","危险","地雷","炸弹","假门","伪装","致死","致命","坑"}
    -- ②-e 切割类(Chisel Gauntlet 那种凿子/切割台)
    SYS.KwCut = {"chisel","gauntlet","cut","slice","sliceable","grind","machin"}
    -- ②-f MachineParty 专属老关键词(原来内联在 ESP_Pick 的兜底分支里) —— 表里没有但以前认得的
    SYS.KwMpExtra = {"mpbuy","limiteddrop","mpstation","mppadhost"}

    -- ③ 藏身点 —— ★ 刻意分两份, 不要合并成一份:
    --    · KwHidePick  = 透视判据, 宽松(抽屉/箱子也算"能躲的地方", 亮了不碍事)
    --    · KwHidePrompt= 自动藏身判据, 严格(必须是真的能钻进去的 Prompt/动作文本)
    --    合并成一份的后果: 要么自动藏身跑去翻抽屉(认了 chest/drawer), 要么该亮的藏身点不亮。
    SYS.KwHidePick   = {"hide","hiding","wardrobe","closet","drawer","undercouch","locker","cabinet","chest",
                        "躲","藏身","衣柜","抽屉"}
    SYS.KwHidePrompt = {"hide","hiding","hideprompt","closet","wardrobe","bed","locker","cabinet",
                        "藏身","躲","衣柜","床","柜"}

    -- ④ 线索物件(书 / 密码纸条 / 提示牌 / 图书馆书 / 画作) —— 透视与「读密码提示」共用
    SYS.KwClue = {"book","bookshelf","shelf","journal","note","notepad","paper","page","diary","library",
                  "lore","hint","clue","code","password","passcode","padlock","combination","document",
                  "letter","scroll","manual","guide","poster","painting","portrait","puzzle","riddle","sign",
                  -- DOORS 的密码书/提示纸真名: LiveHintBook / LibraryHintPaper / LibraryBook
                  "livehint","libraryhint","librarybook","hintbook","hintpaper",
                  "书","笔记","纸","页","日记","图书","线索","密码","提示","文件","信","画","牌"}
    -- ★ 「读密码提示」是 KwClue 的【真子集】: 它还要去读物件表面的 SurfaceGui 文字,
    --   名单放宽只会白扫一堆没有 SurfaceGui 的东西, 所以刻意收窄。
    SYS.KwClueText = {"hint","librarybook","note","paper","book"}

    --##########################################################################
    --# ★★ 合并: 互锁判断收成一处 (原来 4 个开关的回调里各写了一遍几乎相同的条件)
    --#   改之前各写各的, 条件【互相不一致】:
    --#     · 「玩家透视」那条漏了 ESPWeapon / ESP_Pick / ESP_Door / ESP_Mini
    --#     · 「头顶武器标记」那条漏了 ESPWeapon 自己之外的 ESP_Pick / ESP_Door / ESP_Mini
    --#   后果: 关掉玩家透视时, 即使「物件透视」还开着也会误调一次 ClearESP() ——
    --#   把 HP/HD/HM 这些池子瞬间清空, 下一帧再重建, 表现为一闪。
    --#   现在统一走 ESPAnyOn()(所有池的总和) -> 只要还有任何一个透视开着就不清。
    --#   ★ 这是顺手修掉的一致性缺陷, 不是新增行为。
    --##########################################################################
    function SYS.ESPAnyOn()
        return SYS.T_.ESP or SYS.T_.ESPNameTag or SYS.T_.ESPWeapon
            or SYS.T_.ESPItem or SYS.T_.ESP_Pick or SYS.T_.ESP_Door
            or SYS.T_.ESP_NPC or SYS.T_.ESP_Mini or false
    end
    -- 所有透视都关了才真正清池子(开关回调统一调这个, 别再各写一遍条件)
    function SYS.ESPMaybeClear()
        if not SYS.ESPAnyOn() then SYS.ClearESP() end
    end

    function SYS.ClearESP()
        for _,h in pairs(HN) do if h then h:Destroy() end end    -- ★ 怪物透视池
        HN={} SYS._npcList=nil
        for _,h in pairs(HP) do if h then h:Destroy() end end    -- ★ 可交互道具池
        HP={} SYS._pickList=nil
        for _,h in pairs(HD) do if h then h:Destroy() end end    -- ★ 门/陷阱池
        HD={} SYS._doorList=nil
        for _,s in pairs(HD_SK) do if s then s:Destroy() end end  -- ★ 骷髅头标记池
        HD_SK={}
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

    -- ★★ v8.7.0 敌我阵营判定的【权威来源】(修「透视全显示绿色」) ────────────────
    --   根因: 这个游戏(自由对战/FFA)【没有队伍数据】—— Player.Team 恒 nil、也没有 MP*/team 属性,
    --        于是下面 ateam() 两边都拿到 nil -> `team = not (mt and pt and mt~=pt)` = true
    --        -> **所有人按"队友绿"**。用户实测:"敌我透视还是没成功分出敌对阵营和我阵营队友, 都显示成绿的了"。
    --   ★ 权威判据就在游戏自己身上(综合扫描实锤):
    --        Workspace.Highlight.Enemy.HighlightHolder.<玩家名>
    --      游戏把【当前敌人】都挂在这个容器里(它自己用它做敌人高亮)。日志 [8][9] 两行 + 实例层都指到它。
    --   ⚠ 为什么不能直接读 CB.EnemyHolder: CB=SYS.Combat 定义在本段【之后】(L6876),
    --      这里(ESP)读不到 —— 这正是 v6.9.22 只把敌人容器接进了「索敌」、没接进「配色」的原因。
    --      所以这里自带一份缓存查找, 不依赖战斗模块。
    local EHCache, EHAt = nil, -99
    local function espEnemyHolder()
        if EHCache and EHCache.Parent then return EHCache end
        local now=os.clock()
        if now-EHAt<2 then return EHCache end          -- 找不到时 2 秒才重找一次, 不做全图遍历
        EHAt=now
        local _,hl=P(function()
            local w=WS:FindFirstChild("Highlight")
            local en=w and w:FindFirstChild("Enemy")
            return en and en:FindFirstChild("HighlightHolder")
        end)
        EHCache=hl
        return hl
    end
    SYS.EspEnemyHolder=espEnemyHolder

    function SYS.ESPTick()
        -- ★★ 合并遗留: 老存档里「头顶武器标记 (ESPWeapon)」是个独立开关, 现在它跟着
        --   「🪧 头顶标签 (ESPNameTag)」一起走 ——【必须双向跟随】。
        --   ⛔ 修 2026-09-21(用户报「武器标记标红没成功 / 根本看不到 🔫 那行」): 原来是【单向】的
        --      `if ESPWeapon and not ESPNameTag then ESPNameTag=true end`, 只处理"武器标记开→名字也开"。
        --      真实漏掉的正是【反方向】: 老存档 ESPNameTag=true 但 ESPWeapon=false(合并前
        --      「手持武器透视」是个独立开关, 用户当时关着) ⇒ 读档后 ESPWeapon 恒为 false,
        --      而合并开关的回调【只有用户点击时才写 ESPWeapon】、加载时不触发
        --      ⇒ 界面显示"头顶标签 开", 头顶却永远不出现武器标记(而且毫无报错, 纯静默)。
        --   双向跟随才是合并后的正确语义: 开关显示开着, 两个池(名字 LB / 武器 LW)就都该在。
        if SYS.T_.ESPNameTag ~= SYS.T_.ESPWeapon then SYS.T_.ESPWeapon=SYS.T_.ESPNameTag end
        -- ★★ 用 ESPAnyOn() 代替原来手写的 8 项条件 —— 漏写一项就会"开关全关但池子不清",
        --   而下面那句 next(HL/LB/HI/LW) 只看 4 个池, 漏了 HN/HP/HD/HM/LW, 同样容易留残留。
        if not SYS.ESPAnyOn() then
            SYS.ClearESP()
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
                    -- ★★ v6.11 修「一进柜子就不高亮」: 藏身/幽灵态下游戏常把 Humanoid.Health 打成 0
                    --   (或 Alive=false) —— 旧代码"有 Humanoid 但死了就跳过" -> 进柜子立刻不亮。
                    --   透视本来就该看得见"活着的和藏起来的", 所以这里【不再用 Health 过滤】。
                    --   (索敌那边另有 alive 判据, 不受影响 —— 不会去打尸体。)
                    act[p]=c
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
                    h=SYS.NewVis("Highlight")
                    h.Adornee=c
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop   -- 穿墙可见
                    h.FillTransparency=0.88
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
                -- ★★ v8.7.0 阵营判定改成【三级优先级】(修「敌我透视全显示绿色」):
                --   ① 游戏自己的敌人容器 `Workspace.Highlight.Enemy.HighlightHolder` —— **权威**:
                --        名字在里面 = 敌人(红); 容器非空但他不在 = 队友(绿)。
                --        ★ 关键: 只有【容器确实存在且非空】时, "不在里面" 才能当"是队友"的判据 ——
                --          否则容器还没建好/为空时会把所有人误判成队友(那就又全绿了)。
                --   ② 拿不到容器 -> 退回原来的队伍属性判定。
                --   ③ 连队伍属性也没有 -> 保守按队友(绿)。
                local faction=nil                   -- nil=未知 / true=队友 / false=敌人
                do
                    local holder=espEnemyHolder()
                    if holder and holder.Parent then
                        local hasKid=false
                        for _ in ipairs(holder:GetChildren()) do hasKid=true break end
                        if holder:FindFirstChild(p.Name) then
                            faction=false           -- 在游戏的敌人容器里 = 敌人
                        elseif hasKid then
                            faction=true            -- 容器非空、他不在 = 队友
                        end
                    end
                end
                if faction==nil then
                    local mt=ateam(LP) local pt=ateam(p)
                    -- ★ v6.9.2: DOORS 这类游戏【根本没有队伍数据】(Player.Team 恒 nil, 也没有 MP* 属性),
                    --   原来 mt/pt 拿到 nil -> team=nil -> 所有人都是"敌人红", 看着就是"颜色全错了"。
                    --   现在: 只有【两边都拿到队伍、且确实不是一队】才算敌人; 拿不到数据一律按【队友绿】。
                    faction=not (mt and pt and mt~=pt)
                end
                team=faction
                -- ★ v3.10.3 用户要求: 队友=绿色, 敌人=红色, 颜色要【够醒目】(高饱和)。
                --   颜色本身【不偏移、不淡化】—— 隔墙与否只靠 FillTransparency(填充透明度)区分:
                --   隔墙=填充更透(能看穿墙, 一眼知道"在墙后"), 可见=填充更实。RGB 色值永远不变。
                -- ★★ MachineParty: 这游戏用 `MPGhost` Attribute 表示"被服务器隐身/幽灵态"
                --   (综合扫描实锤: 本机玩家就是 MPGhost=true + MPWalkSpeed=0)。幽灵态用【紫色】单独标出,
                --   一眼分辨"谁现在是隐身的" —— 比全都一个颜色有用得多。
                -- ★★ v6.9.31 修「隐身人物效果没了」: 原来只认 MachineParty 的 `MPGhost` 属性,
                --   换到别的游戏(比如那份对战服)就恒为 false -> 隐身的人不再被标紫。
                --   现在三层判定(任一命中即算"他隐形/幽灵态"), 全部只读、不改游戏状态:
                --     ① MachineParty 的 MPGhost(保留原判据)
                --     ② 通用属性: 名字像隐身且值为 true(Ghost/Invisible/Stealth/Hidden/Vanish/Phantom/Cloak…)
                --     ③ 结构兜底: 本地看到的角色【整体透明】(0.6 以上透明度的部件占 7 成以上) -> 判定"他隐身了"
                --        —— 这条对"只在自己客户端能看到的隐身"同样有效(透视本来就穿墙, 再加颜色标记更好认)
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
                -- ★ v6.9.0: 统一边框高亮 —— 填充近乎透明(0.88/0.93), 只留描边轮廓, 一眼看出"框"
                local fillT=wall and 0.93 or 0.88      -- 隔墙更透 / 可见仍以轮廓为主
                h.FillTransparency=fillT
                if ghost then
                    h.FillColor   =Color3.fromRGB(190,60,255)    -- 紫 = 幽灵态(被服务器隐身)
                    h.OutlineColor=Color3.fromRGB(160,40,230)
                else
                    h.FillColor   = team and Color3.fromRGB(0,255,90)  or Color3.fromRGB(255,40,50)
                    h.OutlineColor= team and Color3.fromRGB(0,210,70)  or Color3.fromRGB(255,20,30)
                    --   (team=true 绿=队友/没队伍数据, false 红=明确不同队)
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
                -- ★★ v6.10.7 「生物透视」用户要求: "只要是生物/活物就透视高亮, 并区分敌人还是中立生物"。
                --   这里给每个活物判【敌对(红) / 中立(橙)】, 判据全部只读:
                --     ① Attribute 命中 true: Hostile / Enemy / IsEnemy / Aggro / Dangerous / Killer
                --     ② 名字或【3 层祖先名】命中敌意词(中英)
                --     ③ 都拿不准 -> 算【中立】—— 不误标红(和人物透视"拿不到队伍=队友绿"同一个保守口径)
                -- ★ v9.9.7 合并: 词表统一走 SYS.KwHostile (原来这里和自动藏身那边各写一份, 内容还不一样)
                local HOST_KW=SYS.KwHostile
                local HOST_CN=SYS.KwHostileCN
                local HOST={}          -- ★ 侧表: 模型 -> 是不是敌对生物
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
                            -- ★★ v6.11 同上: 不再要求 Health>0 —— 藏身/尸体也照样亮(用户要"只要是生物就高亮")。
                            --   没有 Humanoid 的纯骨架(假人)一条照旧收。
                            if not isPlayerChar then
                                list[#list+1]=m
                                HOST[m]=isHostile(m)          -- ★ v6.10.7 敌对 or 中立
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
                    h=SYS.NewVis("Highlight")
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
                -- ★★ v6.10.7 分色: 敌对生物 = 红(危险色) / 中立生物 = 橙(沿用原"怪物"色)
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

        --##########################################################################
        --# ★★ v6.9.0 可交互对象【分类表】—— 按类型分色, 一眼看出是什么
        --#   用户要求: "可交互对象(箱子物品道具梯子啥的乱七八糟的)来个高亮透视"
        --#   命中哪一类就用哪一类的颜色; 都没命中但结构上可交互(带 ClickDetector/
        --#   ProximityPrompt)的, 归「通用可交互」= 青色。
        --#   想加新类别: 往这张表里加一行就行。
        --##########################################################################
        local PK = {}   -- ★ v6.9.0 可交互对象 -> 所属分类(决定高亮颜色)
        SYS.PickKinds = {
            { name = "箱子/收纳", color = Color3.fromRGB(0,200,255),
              kws = {"chest","crate","locker","cabinet","vault","safe","coffer","stash","case","box","container",
                     -- ★ v6.10.6 按 DOORS 抓包补: 抽屉/柜子/桌子这类"要翻找的容器"
                     "drawer","dresser","desk","table","knobs","cupboard","bookcase","checkout","wardrobe",
                     "宝箱","箱子","柜","收纳","棺材","抽屉","桌"} },
            { name = "拾取物", color = Color3.fromRGB(0,200,255),
              kws = {"pickup","drop","loot","reward","token","orb","collect","coin","cash","gem","item","scrap",
                     "money","cash","orb","star","card","key","gold","coin",
                     "金币","掉落","奖励","拾取","道具"} },
            -- ★★ v6.10.2 用户: "把缺少可交互的东西补上高亮透视" —— 按 DOORS 抓包补两类它特有的可交互物
            { name = "道具/补给", color = Color3.fromRGB(0,200,255),
              kws = {"flashlight","torch","lighter","vitamin","bandage","medkit","crucif","lockpick","skeleton",
                     "battery","fuse","candle","bottle","ribbon","cheese","bone","keycard","syringe","potion",
                     -- ★ v6.10.6 按 DOORS 抓包补(全是它真实存在的道具/交互物名)
                     "alarmclock","clock","globe","typewriter","keyobtain","padlock","lever","breaker","timer",
                     "paperplane","portrait","rift","revive","chandelier","obstruction",
                     "手电","打火机","维生素","绷带","开锁","骷髅","电池","保险丝","蜡烛","钟","地球仪","打字机",
                     "密码锁","拉杆","电闸","定时"} },
            { name = "躲藏点", color = Color3.fromRGB(0,200,255),
              -- ★★ 合并: 引用 SYS.KwHidePick(见 [08] 顶部 ③ —— 透视用宽松版, 自动藏身用严格版, 刻意不合成一份)
              kws = SYS.KwHidePick },
            -- ★★ v6.10.3 用户: "可交互的一些书 或者密码书之类的呢 怎么没透视高亮"
            --   书本 / 密码纸条 / 提示牌 / 图书馆书 / 画作 = 名字里是 book/note/paper/hint/...,
            --   以前分类表里一个词都没有 -> 全都不亮。
            { name = "书籍/纸张/线索", color = Color3.fromRGB(0,200,255),
              -- ★★ 合并: 引用 SYS.KwClue(「读密码提示」用的是它的子集 SYS.KwClueText)
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
            -- ★★ 合并: 第 12 类「小游戏区域」—— 原来这是 MachineParty 页的独立开关 ESP_Mini,
            --   现已并入「🔍 物件透视」总闸。★ 必须放【最后】: pickKind 是"从上到下命中即停",
            --   放前面会把本该归到"按钮/机关""梯子"的物件抢过来(虽然颜色都一样, 但诊断标签会错)。
            { name = "小游戏区域", color = Color3.fromRGB(0,200,255),
              kws = {"duck hunt","duckhunt","chisel","gauntlet","rightofway","blindout","crushhour",
                     "bumpermadness","mppadhost","mpstation","machin",
                     "小游戏","关卡","模式"} },
        }
        local function pickKind(o)
            -- 先按名字分类(从上到下, 命中即停)
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

        -- ★★ v9.9.4 补漏(用户: "交互物透视 补漏"): 原实现用「子物体数 > 60 就直接放弃」
        --   当防爆门槛 —— 于是【大地图模型整块被跳过】。DOORS 那份扫描里 Workspace 有 11182+ 子对象、
        --   全图 65416 实例, 地图就是几个超大 Model ⇒ 藏在里面的交互提示(书柜里的书、抽屉里的东西)
        --   永远不亮, 表现出来就是"交互物透视有时候不灵"。
        --   改成【带预算的迭代下钻】: 深度 ≤ 8 层、总访问节点 ≤ 4000, 一找到 Prompt/ClickDetector
        --   立刻返回。预算用完就停(不会卡帧), 既不漏也不再靠"物体数"这种粗暴门槛。
        local function deepHasI(root)
            local stack, budget = {root}, 4000
            local depth = {[root]=0}
            while #stack>0 and budget>0 do
                local n=stack[#stack] stack[#stack]=nil
                budget=budget-1
                local d=depth[n] or 0
                if d<8 then
                    local ok,kids=P(function() return n:GetChildren() end)
                    if ok and type(kids)=="table" then
                        -- ★ 下钻顺序有讲究: 容器类(Model/Folder/Attachment/Accoutrement)【后压栈】,
                        --   于是【先被弹出】—— 提示通常就在容器附近, 先钻容器能在预算耗尽前命中。
                        --   纯 BasePart 先压栈、后弹出(它们是叶子多, 钻它们只为够到挂在上面的 Attachment)。
                        local containers
                        for i=1,#kids do
                            local c=kids[i]
                            if c:FindFirstChildOfClass("ProximityPrompt")~=nil
                               or c:FindFirstChildOfClass("ClickDetector")~=nil then
                                return true
                            end
                            local cc=c.ClassName
                            if c:IsA("Model") or cc=="Folder"
                               or c:IsA("Attachment") or c:IsA("Accoutrement") then
                                containers=containers or {}
                                containers[#containers+1]=c
                            elseif c:IsA("BasePart") then
                                -- ★★ 必须也钻 BasePart: 官方允许把 ProximityPrompt 挂在
                                --   【Attachment】上, 而 Attachment 是挂在某个 BasePart 下面的 ——
                                --   只钻 Model/Folder 会整类够不到这类提示(本测试的 B 用例就是这么抓出来的)。
                                depth[c]=d+1
                                stack[#stack+1]=c
                            end
                        end
                        if containers then
                            for i=1,#containers do
                                depth[containers[i]]=d+1
                                stack[#stack+1]=containers[i]
                            end
                        end
                    end
                end
            end
            return false
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
                local names={}          -- ★ v6.10.2 自诊断: 候选名字样本
                local camPos=SYS.Cam and SYS.Cam.CFrame and SYS.Cam.CFrame.Position
                -- ★ 上限可配(默认 1200, 原来写死 600 会漏掉"散落在远处"的): C_.PickDist
                local MAXD=tonumber(SYS.C_.PickDist) or 1200
                P(function()
                    -- ★★★ v9.9.7 时间预算(必须): v9.9.4 把可交互物的搜索挖深了(会下钻 BasePart/Attachment),
                    --   而 DOORS 这种图【全图 8 万+ 实例】(抓包实测 Workspace 2 万子对象、全图 8 万)——
                    --   一轮扫完可能几十~上百毫秒, 直接把帧率拖下去。
                    --   这里给每轮 120ms 上限: 到点就用已有结果收尾(下一轮接着扫), 宁可慢一拍也不卡帧。
                    local _t0=os.clock()
                    local _budget=0.12
                    for _,o in ipairs(SYS.Index()) do
                        if os.clock()-_t0>_budget then break end
                        local cn=o.ClassName
                        local ok=false
                        if cn=="Tool" then ok=true
                        -- ★★ v6.10.2 类名放宽: 以前只认 Part/MeshPart/UnionOperation/TrussPart,
                        --   于是【楔形板/座椅/圆柱/球/霓虹牌】这些可交互物全部漏掉 -> 改成任意 BasePart。
                        --   (Model/Folder 保留: 它们装的是子部件)
                        -- ★★ v9.9.4 类覆盖加强(用户: "透视目标类 加强现有类覆盖"):
                        --   Roblox 的 ProximityPrompt 除挂在 BasePart 上, 官方也允许挂在
                        --   【Attachment】(定向挂点)上; 另有 Accessory / Accoutrement 这类
                        --   "既不是 BasePart 也不是 Model/Folder"的挂点类 —— 它们以前【整类被跳过】,
                        --   挂在上面的交互提示自然永远不亮。这里把挂点类一并纳入候选。
                        elseif o:IsA("BasePart") or o:IsA("Model") or cn=="Folder"
                            or o:IsA("Attachment") or o:IsA("Accoutrement") then
                            -- 结构判定: 自己带 ClickDetector / ProximityPrompt
                            -- ★★ v6.11 增强(用户: "我截图的那个书没给高亮"): hasI 支持【递归】查找 +
                            --   往上爬祖先再递归 —— 专治"交互提示藏在多层子模型里"的物件。
                            --   事件库实锤(MM2 类): Workspace.Entities.MapModel.SecretBookshelf1.PromptPoint.ProximityPrompt
                            --   —— 提示在【模型 > PromptPoint > ProximityPrompt]两层下面;
                            --   老代码只查"自己/父级/直接子级", 遇到更深一层就只剩下那个小 PromptPoint 亮，
                            --   看上去就像"整本书没亮"。
                            --   ⚠ 防爆量: 递归前先看直接子对象数量, 超过 60 个(多半是整张地图大模型)就不递归。
                            local function hasI(x, deep)
                                if not x then return false end
                                if x:FindFirstChildOfClass("ClickDetector")~=nil
                                   or x:FindFirstChildOfClass("ProximityPrompt")~=nil then return true end
                                if deep and (x:IsA("Model") or x:IsA("Folder")) then
                                    -- ★★ v9.9.4: 原来是 `if #x:GetChildren() > 60 then return false end`
                                    --   —— 大地图模型(DOORS 这种)一超 60 就直接放弃, 深层交互物全漏。
                                    --   换成 deepHasI() 的带预算下钻(深度≤8 / 节点≤4000)。
                                    local ok2, has = P(function() return deepHasI(x) end)
                                    if ok2 and has == true then return true end
                                end
                                return false
                            end
                            if hasI(o) then ok=true
                            else
                                -- ★ 也看父级(挂在外层模型上) —— 以及【子级】:
                                --   柜子/箱子/门这类常见做法是把 ClickDetector 放进模型里的【某个子部件】,
                                --   只看自己和父级会漏掉它们(用户反馈"地图上的柜子交互不上")。
                                if hasI(o.Parent) then ok=true
                                else
                                    for _,ch in ipairs(o:GetChildren()) do if hasI(ch) then ok=true break end end
                                    -- ★★ v6.11: 还没命中 -> 向上爬 1~2 层祖先做【递归】查找,
                                    --   让"整本书/整个物件"整组点亮, 而不是只亮里面的一个交互点。
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
                        -- ★ v6.9.0: 先按【分类表】判类型(决定颜色); 结构判定只作兜底。
                        local kind = pickKind(o)
                        -- ★★ v6.10.2 只看自己的名字会漏一大片: 可交互物常见结构是
                        --   「外层模型叫 Flashlight / Wardrobe(命中关键词), 里面的部件叫 Part / Handle(不命中)」。
                        --   现在按【名字 + 最多 3 层祖先名】判分类(与门/陷阱透视同一套做法)。
                        if not kind and type(o.Name)=="string" then
                            local anc=o
                            for _=1,4 do
                                if not anc then break end
                                kind=pickKind(anc)
                                if kind then break end
                                anc=anc.Parent
                            end
                        end
                        -- ★★ v6.10.3 结构兜底(与名字无关): 部件上挂了【SurfaceGui + 文字】= 能读的东西。
                        --   密码纸条 / 提示牌 / 告示 / 书页内容 这类常常名字很随意(Book1 / Part / Page),
                        --   光靠名字认不出来 —— 只要它"上面写着字", 就当线索点亮(粉紫)。
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
                            -- 老关键词表保留(MachineParty 专属, 表里没有但以前认得的)
                            -- ★★ 合并: 这串原来内联在 ESP_Pick 里, 挪到 SYS.KwMpExtra 统一放
                            local nm=o.Name:lower()
                            for _,kw in ipairs(SYS.KwMpExtra) do
                                if nm:find(kw,1,true) then ok=true break end
                            end
                        end
                        if (ok or kind) and o.Parent and o~=LP.Character then
                            local part=o.PrimaryPart or (cn~="Model" and cn~="Folder" and o) or o:FindFirstChildWhichIsA("BasePart")
                            -- ★★ v9.9.4: Attachment / Accoutrement 这类【挂点类】不能直接当 Highlight 的载体
                            --   (Adornee 只收 BasePart / Model), 要爬回最近的 BasePart 才画得出来 ——
                            --   否则算了一场却什么都看不见。
                            if part and not (part:IsA("BasePart") or part:IsA("Model")) then
                                local a, up = part.Parent, nil
                                for _=1,4 do
                                    if not a then break end
                                    if a:IsA("BasePart") then up=a break end
                                    if a:IsA("Model") then
                                        up=a.PrimaryPart or a:FindFirstChildWhichIsA("BasePart")
                                        if up then break end
                                    end
                                    a=a.Parent
                                end
                                part=up
                            end
                            if part and part.Position then
                                local d=camPos and (part.Position-camPos).Magnitude or 0
                                if not camPos or d<=MAXD then
                                    -- ★★ v6.10.6 修「书柜上的密码书 / 抽屉里的东西看不见高亮」:
                                    --   以前对 Model/Folder 只挑【一个】部件高亮(PrimaryPart 或第一个 BasePart)——
                                    --   而书/道具往往只是模型里的一个小零件, 还被柜门挡着 -> 看起来就像"没亮"。
                                    --   现在: 模型命中就把里面【所有 BasePart】都点亮(每个模型最多 12 个, 防爆量)。
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
                    h=SYS.NewVis("Highlight")
                    h.Adornee=p
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                    h.OutlineTransparency=0
                    h.Parent=p
                    HP[p]=h
                elseif h.Parent~=p then
                    P(function() h.Parent=p end)
                end
                local wall=espWall(p)
                -- ★ v6.9.2: 改回【按类型上色】—— 6.9.0 曾统一成青色, 结果箱子/梯子/按钮/食物全一个色,
                --   隔着墙根本分不清是什么。分类表 pickKind 每类自带 color, 直接用; 没分类到的才用青。
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

        -- ★★ 门 / 陷阱 / 【假门】透视(黄=陷阱机关, 品红=切割, 橙=形状认出来的"假门/薄门板")。★先说清楚边界:
        --   ✔ 能判: ① 自己或【最多 3 层祖先】的名字命中门/伤害关键词(中英)
        --           ② 结构上是会转的门(HingeConstraint / Motor6D)
        --           ③ ★v6.9.32 新增: 结构上就是一块【竖直薄板】(高最高、厚<=1.5、宽>=2.2),
        --              且带"门的样子"(不可碰撞 / 半透明 / 有贴花 / 有交互提示)
        --              —— 专门抓【名字里根本没有 door 字样】的假门。
        --   ✗ 判不了: **"碰了会不会掉血"客户端看不出来** —— 伤害是服务端结算的, 本地没有可读信号, 只按名字/结构给提示。
        --   ★★ v6.9.32 修【门/假门一直不亮】的致命 bug: 以前颜色侧表 CUTOF 声明在"重算块"里,
        --      却在块外读取 -> 每次都是 nil[part] -> 当场抛错, 整个门高亮循环被打断
        --      (所以门从来没亮过, 连带后面的小游戏区域透视也一起崩)。现在统一从 SYS._doorCut 读。
        if SYS.T_.ESP_Door then
            SYS._doorN=(SYS._doorN or 0)+1
            local _now=os.clock()
            if (SYS._doorN%25==1 and (not SYS._doorAt or _now-SYS._doorAt>1)) or not SYS._doorList then
                SYS._doorAt=_now
                local list={}
                local CUTOF={}          -- 侧表: 部件 -> 是不是"切割类"(决定颜色)
                local SOFT={}           -- 侧表: 部件 -> 是不是"只靠形状猜出来的"(橙色区分)
                local FAKE={}           -- ★ v6.10.1 侧表: 部件 -> 是不是"假门"
                local TRAP={}           -- ★ v6.10.4 侧表: 部件 -> 是不是"危险"(红+☠); 其余=普通门(亮青)
                local camPos=SYS.Cam and SYS.Cam.CFrame and SYS.Cam.CFrame.Position
                local MAXD=tonumber(SYS.C_.PickDist) or 1200
                -- ★★ 合并: 这四张表原来在这里内联声明, 其中「危险词表」与「自动躲避」的
                --   DODGE_KW 是同一份内容、「门/陷阱词表」与自动躲避的取词范围也重合 ——
                --   现在全部集中到 [08] 顶部的 SYS.Kw* 声明一次(见 SYS.KwTrap / SYS.KwGate ...)。
                --   ★ 这里只做"换个地方引用", 词表内容与顺序与改前逐项一致 -> 行为不变。
                local TRAPKW=SYS.KwTrap
                local TRAPCN=SYS.KwTrapCN
                local KW=SYS.KwGate
                local CUTKW=SYS.KwCut
                local CNKW=SYS.KwGateCN
                -- ★ v6.9.32 【竖直薄板】判据(与名字无关) —— "假门"最常见的形态。
                --   还要同时有"门的样子"(不可碰撞 / 半透明 / 有贴花贴图 / 带交互提示)才收,
                --   免得把普通薄墙、栏杆、玻璃、招牌全点亮。
                local function doorShaped(o, pr)
                    if not pr then return false end
                    local okS,sz=pcall(function() return pr.Size end)
                    if not okS or typeof(sz)~="Vector3" then return false end
                    local x,y,z=sz.X,sz.Y,sz.Z
                    local mn=math.min(x,y,z)
                    local mx=math.max(x,y,z)
                    if y~=mx then return false end                 -- 高度得是最大那一维(竖着的板)
                    if y<3.5 then return false end                 -- 至少一人多高
                    if mn>1.5 then return false end                -- 厚度够薄才算"门板"
                    if (x+y+z-mn-mx)<2.2 then return false end     -- 宽度够
                    local cc=nil
                    local tr=nil
                    pcall(function() cc=pr.CanCollide end)
                    pcall(function() tr=pr.Transparency end)
                    if cc==false then return true end              -- 穿得过去的板 = 通道/触发器
                    if type(tr)=="number" and tr>0.05 then return true end
                    if pr:FindFirstChildOfClass("Decal") or pr:FindFirstChildOfClass("Texture")
                       or pr:FindFirstChildOfClass("SurfaceGui") then return true end
                    if pr:FindFirstChildOfClass("ProximityPrompt") or pr:FindFirstChildOfClass("ClickDetector") then return true end
                    if o~=pr and (o:FindFirstChildOfClass("ProximityPrompt") or o:FindFirstChildOfClass("ClickDetector")) then return true end
                    return false
                end
                local names={}
                P(function()
                    local _t0=os.clock()
                    for _,o in ipairs(SYS.Index()) do
                        -- ★ v9.9.8 时间预算: 这次补强给每个物件多加了"区域上下文 + 祖先判定"的活,
                        --   80k 实例的图必须限时, 到点就用已有结果收尾(下一轮接着扫)。
                        if (os.clock()-_t0)>0.12 then break end
                        local cn=o.ClassName
                        local ok=false
                        local soft=false
                        local inMini=false
                        local isCharPart=false
                        if o:IsA("BasePart") or cn=="Model" then
                            -- ★★★ v9.9.8 陷阱补强①【小游戏区域上下文】+ ②【约束类机关】——
                            --   用户原话「陷阱都补强」。依据(机器派对抓包): 这游戏的"陷阱"就是小游戏机关
                            --   (Crush Hour 压碎机 / Chisel Gauntlet 刀 / Bumper Madness 撞车), 而它们的
                            --   名字多半【不叫】 trap/crusher ⇒ 只靠名字全漏, 被涂成"安全的青色"。
                            --   ⚠ ② 必须双重限定: 本游戏有 BallSocketConstraint 910 / NoCollisionConstraint 1235 /
                            --     AnimationConstraint 975, 而 AnimationConstraint 就挂在【人形骨架】上 ——
                            --     无条件认会把每个玩家都标成陷阱。所以要求【在小游戏区域里】且【不在角色身上】。
                            do
                                local a=o
                                for _=1,4 do
                                    if not a then break end
                                    local rn=a.Name
                                    if type(rn)=="string" and rn~="" then
                                        local low=rn:lower()
                                        for _,kw in ipairs(SYS.MiniArea) do if low:find(kw,1,true) then inMini=true break end end
                                        if not inMini then
                                            for _,cw in ipairs(SYS.MiniAreaCN) do if rn:find(cw,1,true) then inMini=true break end end
                                        end
                                    end
                                    if inMini then break end
                                    a=a.Parent
                                end
                                if inMini then
                                    P(function() isCharPart=(o:FindFirstAncestorOfClass("Humanoid")~=nil) end)
                                end
                            end
                            -- ① 结构: 会转的门(铰链/马达关节)
                            if o:FindFirstChildOfClass("HingeConstraint") or o:FindFirstChildOfClass("Motor6D") then ok=true end
                            -- ② 结构: 约束类机关 —— 只在"小游戏区域内 + 非角色"时认
                            if not ok and inMini and not isCharPart then
                                local CONS={"BallSocketConstraint","NoCollisionConstraint","AnimationConstraint",
                                            "PrismaticConstraint","CylindricalConstraint"}
                                for ci=1,#CONS do
                                    local okc,has=P(function() return o:FindFirstChildOfClass(CONS[ci])~=nil end)
                                    if okc and has then ok=true break end
                                end
                            end
                            -- ② 名字: 门 / 陷阱 / 伤害类 —— ★ 不只看自己, 还看【祖先】(最多 3 层)。
                            --   这游戏的陷阱区叫 `Chisel Gauntlet` / `MachinePartyCrushHour` 这类【外层模型名】,
                            --   真正的尖刺/压板是【里面名字很普通的子部件】—— 只比自己的名字会全部漏掉。
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
                            -- ③ ★ v6.9.32: 形状兜底 —— 名字里没有门字样的"假门"主要靠这条认出来
                            if not ok then
                                local pr=(cn~="Model") and o or o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")
                                if doorShaped(o, pr) then ok=true soft=true end
                            end
                        end
                        -- ★ v6.1.4: 顺带区分【切割类】(Chisel Gauntlet 那种凿子/切割台) 与【陷阱/伤害类】, 用两种颜色标出来
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
                        -- ★★ v6.10.1 【假门】单独上色 —— 真名实证: DOORS(门) 里假门就叫 `DoorFake`
                        --   (挂在 `CurrentRooms.<间号>.SideroomDupe.*` 那种"复制出来的侧房"里),
                        --   正常门叫 `Door` / `DoorNormal`。名字或 3 层祖先含 fake/dupe/false/假门/伪装
                        --   => 判为假门, 用【红色】, 跟普通门·陷阱(黄)、切割(品红)、形状猜的(橙)分开。
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
                                    -- ★ v6.10.4 危险词(陷阱/伤害机关/地雷...) —— 命中才红+☠
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
                            -- ★★★ v9.9.8 陷阱补强①: 已经落进"门/陷阱"池、又身处【小游戏区域】的物件,
                            --   一律按【危险】处理(红 + ☠)。理由: 机器派对这类游戏里,"小游戏区域内的
                            --   机件"就是能弄死你的东西, 但名字不叫 trap ⇒ 原来会亮成"安全的青色"。
                            --   只在【已经命中 ok】身上升级, 不做无差别染色, 不会把普通道具误标成危险。
                            if not isTrap and inMini then isTrap=true end
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
            -- ★ v6.9.32: 从 SYS._door* 读侧表(以前读的是已出作用域的局部 CUTOF -> nil -> 抛错)
            local DCUT=SYS._doorCut or {}
            local DSOFT=SYS._doorSoft or {}
            local DFAKE=SYS._doorFake or {}
            local DTRAP=SYS._doorTrap or {}
            for p in pairs(dact) do
                local h=HD[p]
                if not h then
                    h=SYS.NewVis("Highlight")
                    h.Adornee=p
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                    h.OutlineTransparency=0
                    h.Parent=p
                    HD[p]=h
                elseif h.Parent~=p then
                    P(function() h.Parent=p end)
                end
                local wall=espWall(p)
                h.FillTransparency=wall and 0.93 or 0.88   -- 边框高亮: 填充近乎透明, 只留描边轮廓
                h.OutlineTransparency=0
                -- ★ v6.9.2: 切割类=品红, 陷阱/伤害类=黄; ★ v6.9.32 形状猜出来的"假门"=橙, 三种一眼分得清
                -- ★★ v6.10.4 按规范统一配色(原来是 黄/品红/红/橙 四种):
                --   危险(陷阱·伤害机关·切割·假门) = 红色描边 + ☠ 骷髅头;
                --   其他(普通门 / 形状猜出来的薄门板) = 统一亮青。
                if DTRAP[p]==true then
                    h.FillColor   =Color3.fromRGB(255,30,30)
                    h.OutlineColor=Color3.fromRGB(255,0,0)
                else
                    h.FillColor   =Color3.fromRGB(0,200,255)
                    h.OutlineColor=Color3.fromRGB(0,170,230)
                end
                -- 骷髅头标记: 挂一个 BillboardGui ☠, 危险机关不靠颜色、靠骷髅头一眼认出
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
                -- ★ v6.10.4 ☠ 只给【危险】的挂(普通门不挂)
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
                -- ★★ 合并: 区域名表原来在这里内联一份、AutoHitMinigame 那边 AUTO_MINI_AREA 又一份
                --   (内容完全相同) —— 现在统一引用 [08] 顶部的 SYS.MiniArea。
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
                    h=SYS.NewVis("Highlight")
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
                -- ★★ v6.10.4 按规范: 小游戏里的东西也属"普通物件" -> 统一亮青(原来是亮黄绿)
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
                    h=SYS.NewVis("Highlight")
                    h.Adornee=o
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                    h.FillTransparency=0.88
                    h.OutlineTransparency=0
                    -- ★★ v6.10.4 按仓库里记录的规范(透视统一边框高亮 + 颜色统一): 普通物件一律【统一亮青】
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

        -- ★ v3.10.3 「头顶武器标记」(用户改需求: 原「手持武器透视」改为「检查背包物品栏是否有武器」):
        --   判据 = 背包(Backpack)里有 Tool【或】手上(角色模型下)有 Tool —— 两者任一 = 这个人有武器。
        --   有武器就在【头顶】挂一个醒目标记(武器名), 没武器不留标签。
        --   ⚠ 别人的背包默认不复制到客户端(Roblox 引擎行为), 但【Backpack 容器 + 手上 Tool】通常可见;
        --     若 Backpack 读不到(部分游戏), 则退化为只看手上 Tool。
        if SYS.T_.ESPWeapon then
            local wpnN=0
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
                        wpnN=wpnN+1
                    end
                end
            end
            -- ★ v9.9.7 一次性自诊断(用户报过"根本看不到 🔫 那行"): 只在第一轮打印一次,
            --   把"看不到"变成一个能自己核的数字 —— 而不是又一个静默失效。
            if not SYS._wpnLogged then
                SYS._wpnLogged=true
                print(("[ESP] 头顶武器标记: 本轮检测到 %d 人有武器 (别人的背包 Roblox 不复制给客户端, 所以只看得到【拿在手上】的)")
                    :format(wpnN))
            end
        elseif next(LW) then
            for _,l in pairs(LW) do P(function() l:Destroy() end) end LW={} LWL={}
        end
    end

    --================================================================
    -- ★ v6.9.0 小游戏自动: 自动躲伤害机关 + 自动触发小游戏目标(通用, 跨游戏)
    --   AutoDodge      : 扫描伤害机关(名字/祖先命中陷阱关键词, 与「门/陷阱透视」同判据),
    --                    靠太近就自动往反方向走位(MoveTo, 服务端认可, 不会触发瞬移检测)。
    --   AutoHitMinigame: 扫描【小游戏区域】里的 ProximityPrompt/ClickDetector, 自动触发
    --                    (fireproximityprompt/fireclickdetector 优先, InputHoldBegin 兜底)。
    --   两个都默认关, 只在用户开开关后生效; 卸载时随 SYS.Conns 一起断开。
    --================================================================
    -- ★★ 合并: 这份原来内联在这里, 与「门/陷阱透视」的 KW 前 39 项逐项相同 ——
    --   现在统一引用 SYS.KwHazard。★ 注意【不要】改成 SYS.KwGate: 合并版里多出的
    --   exit/stairs/teleport/fake 那一组是"门与通道", 自动躲避认了会跑去躲出口。
    local DODGE_KW = SYS.KwHazard
    SYS._hitSeen = setmetatable({}, {__mode="k"})
    -- ★★ v6.9.27 修「自动躲避没成功」: 旧实现每 1 秒对【整个 Workspace】GetDescendants ——
    --   这游戏 Workspace 有近万个对象, 一次扫描几百毫秒, 主线程被拖住, 表现就是"开了没反应/卡"。
    --   现在只扫【Workspace 直接子对象 + 每个子对象的一层】(陷阱通常就在这两层), 便宜两个数量级。
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
                    for _=1,2 do                      -- 只看自己 + 1 层祖先(原来 4 层, 更慢也更容易误判)
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
            -- ★★ v6.9.27 躲避动作改成【限速渐进位移】:
            --   旧写法用 Humanoid:MoveTo 每帧重设目标点 —— 会被游戏自己的移动控制盖掉,
            --   而且每帧换目标点会互相打架, 结果人根本不动("没成功"就是这个)。
            --   现在每帧沿"远离机关"的方向挪一小步(最多 0.35 格/帧 ≈ 21 格/秒, 正常跑步量级,
            --   不会触发服务端的瞬移校验), 朝向保持不变。
            local away = root.Position - nearest.Position
            -- ★★ v6.10.9 修「自动躲把玩家上下推」: away 是【从陷阱指向你】的全 3D 向量 ——
            --   陷阱在地板/铰链/压板上时它有明显的 Y 分量 -> 每帧把你往上推, 重力再拉回来 =
            --   **上下弹跳(看起来就是上下瞬移)**。压平到水平面, 只做水平退开。
            away = Vector3.new(away.X, 0, away.Z)
            if away.Magnitude < 0.001 then away = Vector3.new(1, 0, 0) end
            local step = math.min(0.35, math.max(0.06, (thr - nd) * 0.25))
            local dir = away.Unit
            P(function()
                local rp = root.Position
                local rot = root.CFrame - rp          -- 只挪位置, 朝向不动
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

    -- ★★ 合并: 原来这里内联一份, 与 ESP_Mini 的区域名表内容完全相同 -> 引用 SYS.MiniArea
    local AUTO_MINI_AREA = SYS.MiniArea
    local function _globalFn(n)
        local f = rawget(_G, n)
        if type(f) ~= "function" then P(function() f = getfenv()[n] end) end
        return type(f) == "function" and f or nil
    end
    local function fireObj(obj)
        -- ★★★ v9.9.7 蜜罐闸门（用户口径「不要动蜜罐就行」）——
        --   这里是【所有自动触发】的唯一入口(自动藏身 / 自动小游戏都走它),
        --   所以挡在这里一处就够了。名字(或 3 层祖先名)带 exploiter/cheat/hack/ban/report/sticky note…
        --   一律不按: 高亮照常(只画轮廓), 但绝不替用户去踩。返回 false 让调用方知道"这条跳过了"。
        if SYS.IsHoneypot and SYS.IsHoneypot(obj) then return false end
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

    -- ★ v9.5.0 自由视角「状态对账」—— 让【开关状态】成为唯一真源。
    --   修的就是用户报的「重载后开关显示开着、自由视角却没生效」:
    --   以前自由视角只有 UI 回调这一条驱动路径(SYS.T_.FreeCam 全程被读取 0 次 —— 这也是
    --   死开关审计把它标出来的原因), 于是只要运行态被别的路径关掉, 开关就会"挂空档":
    --     · 角色重生/换角色: OnChar 里 SYS.StopFreeCam() 关了运行态, 但没动 SYS.T_.FreeCam;
    --     · 重载(更新顶上来的那一版): 相机被新脚本重置, 旧运行态没了, 开关仍是"开";
    --     · 卸载残留 / 相机被游戏自己改掉。
    --   现在主循环每 0.5s 对账一次:
    --     · 开关=开 & 运行态=关 -> 补开(角色已就绪才动, 免得跟重生流程抢相机)
    --     · 开关=关 & 运行态=开 -> 补关
    --   幂等: 两边一致时直接 return, 不做任何事。
    function SYS.SyncFreeCam()
        if SYS.Unloaded then return end
        local want=SYS.T_.FreeCam==true
        if want==SYS.FreeCamActive then return end
        if want then
            -- 角色还没就绪(加载中/刚重生/CameraSubject 还没绑)时不抢, 等下一轮对账;
            -- 否则会在重生流程中途把相机设成 Scriptable, 出现"镜头卡死"。
            local _,h=GC()
            if not h or not SYS.Cam then return end
            SYS.StartFreeCam()
        else
            SYS.StopFreeCam()
        end
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
    -- ★★ v9.9.7 用户要求重做（原话：「应该是看其他玩家准心在看哪里 和自己的准心在哪里的
    --   准心伸出一条线 第三人称 第一人称都看得到」）：
    --   语义从"我能不能打到他"改成"**每个人自己在瞄哪**"。
    --     · 旧「全部玩家」画的是【我 → 他】的连线 —— 那是"谁在我视野里/我能打到谁"，
    --       不是"他在瞄哪"，所以用户说"错了"。
    --     · 新：每个人从【自己的头部/眼睛】沿【自己的瞄准方向】伸一条线。
    --         - 自己 = 相机 LookVector（就是准星，精确）；
    --         - 其他玩家 = 他的 Head 朝向。
    --   ⚠⚠ 诚实边界（必须写清，别让人以为能读别人鼠标）：客户端**读不到别人的相机/鼠标/准心**。
    --     别人的线是"他的身体/头部朝向"。第三人称游戏大多会让身体转向瞄准方向，所以多数情况够用；
    --     他若开自由视角就会对不上。拿不到的东西不编。
    --   ⚠ 线仍必须 CanQuery/CanTouch/CanCollide = false —— 否则 clearShot 的射线会先打到线本身，
    --     把索敌判成"隔墙"，等于自己把自己锁死（老注释的边界要求，保持不变）。
    local RFT=(function()
        local ok,v=P(function() return Enum.RaycastFilterType.Exclude end)
        if ok and v then return v end
        return Enum.RaycastFilterType.Blacklist
    end)()

    --- 取某个角色的瞄准(起点, 单位方向)。isSelf=true 时用相机视线(=准星, 精确)。
    local function aimOf(ch,isSelf)
        if not ch then return nil,nil end
        local hd=ch:FindFirstChild("Head")
        local root=ch:FindFirstChild("HumanoidRootPart") or ch.PrimaryPart
        local o=(hd and hd.Position) or (root and (root.Position+Vector3.new(0,1.5,0)))
        if not o then return nil,nil end
        local d
        if isSelf then
            local cam=WS.CurrentCamera
            d=(cam and cam.CFrame and cam.CFrame.LookVector)
              or (hd and hd.CFrame.LookVector) or (root and root.CFrame.LookVector)
        else
            d=(hd and hd.CFrame.LookVector) or (root and root.CFrame.LookVector)
        end
        if not d or d.Magnitude<0.001 then return nil,nil end
        return o,d.Unit
    end

    --- 沿方向求终点: 撞到东西就停在撞点（这样"他指着的那面墙"一眼可见），否则给满长度。
    local function aimEnd(o,d,maxD,owner)
        local len=(maxD and maxD>0) and maxD or 500
        local ok,hit=P(function()
            local pa=RaycastParams.new()
            pa.FilterType=RFT
            pa.FilterDescendantsInstances={owner or LP.Character}
            pcall(function() pa.IgnoreWater=true end)
            return WS:Raycast(o,d*len,pa)
        end)
        if ok and hit and hit.Position then return hit.Position end
        return o+d*len
    end
    --##########################################################################
    --# ★★ 强化(用户要求"人物射线"): 从【只画锁定目标一条】扩成【多目标池化】
    --#   参考公开脚本的通行做法(justforcountryballs 的 tracerParts / Exunys 的常驻画线):
    --#     · 池化 —— 每个目标一条常驻 Neon 薄片, 存在则只改 Size/CFrame, 不每帧 new/Destroy
    --#     · 每条都独立跟着自己的目标走, 所以"谁在哪、谁在看我"一眼就有数
    --#     · 加两道闸防卡: 距离上限 + 最多几条(几十人局不至于画满屏、也不是几十个 Part 在动)
    --#   为什么不用 Beam: Beam 不能穿墙(它没有 Highlight 那种 DepthMode),
    --#     而 Neon + Transparency 0.4 的薄片天然可见、还能直接看出方向; 换 Beam 只会更难看清。
    --#   为什么不用 Drawing: 只有部分执行器有, 现在这套在任意执行器都能跑(零依赖)。
    --##########################################################################
    local TPL={}                      -- 多目标池(键=玩家, 值=Neon 薄片)
    local function tracerDrop(p)
        local q=TPL[p]
        if q then TPL[p]=nil P(function() q:Destroy() end) end
    end
    function SYS.TracerHide()
        if line then P(function() line:Destroy() end) line=nil end
        for p in pairs(TPL) do tracerDrop(p) end
    end
    -- 造一条常驻 Neon 薄片(池化: 存在就只改几何, 不每帧 new/Destroy)
    -- ⚠ 变量名保持 q: 门禁 check.py 的回归锁按字面查 `q.CanQuery=false` —— 改名字会让锁变红。
    local function newTracer(col)
        local ok,pt=P(function()
            local q=Instance.new("Part")
            q.Anchored=true q.CanCollide=false q.CastShadow=false
            q.CanQuery=false q.CanTouch=false        -- ★ 必须: 别让射线/触碰打到自己这条线上
            q.Material=Enum.Material.Neon q.Transparency=0.4
            q.Color=col
            q.Archivable=false
            q.Parent=WS
            return q
        end)
        return (ok and pt) or nil
    end
    local function setTracer(q,o,endP)
        if not q then return end
        local d=endP-o
        local len=d.Magnitude
        if len<2 then return end
        P(function()
            q.Size=Vector3.new(0.07,0.07,len)
            q.CFrame=CFrame.lookAt(o+d*0.5,endP)
        end)
    end
    local SELF_COL=Color3.fromRGB(120,255,180)    -- 自己的线: 亮青绿
    local OTHER_COL=Color3.fromRGB(255,190,60)    -- 别人的线: 橙
    -- 新建/复用一个目标上的线(池里没有才 new, 有就只更新几何)
    local function tracerDraw(key,o,endP)
        local q=TPL[key]
        if not q then
            q=newTracer(OTHER_COL)
            if not q then return end
            TPL[key]=q
        end
        setTracer(q,o,endP)
    end
    function SYS.TracerTick()
        if not SYS.T_.Tracer then
            if line or next(TPL) then SYS.TracerHide() end
            return
        end
        local maxD=tonumber(SYS.C_.TracerMaxDist) or 500
        local cap=tonumber(SYS.C_.TracerMaxN) or 12
        local all=SYS.T_.TracerAll and true or false
        -- ① 自己: 相机视线 = 真正的准星(第三人称下相机在身后, 但方向就是准星方向)
        local myO
        do
            local o,d=aimOf(LP.Character,true)
            if o and d then
                myO=o
                if not line then line=newTracer(SELF_COL) end
                setTracer(line,o,aimEnd(o,d,maxD,LP.Character))
            elseif line then
                P(function() line:Destroy() end) line=nil
            end
        end
        -- ② 其他玩家: 各自头部朝向(近似 —— 客户端读不到别人的相机/准心, 见上面 block 的诚实边界)
        if all then
            local used,n={},0
            for _,pl in ipairs(Players:GetPlayers()) do
                if pl~=LP and n<cap then
                    local o,d=aimOf(pl.Character,false)
                    if o and d and (not myO or maxD<=0 or (o-myO).Magnitude<=maxD) then
                        used[pl]=true n=n+1
                        tracerDraw(pl,o,aimEnd(o,d,maxD,pl.Character))
                    end
                end
            end
            -- 离开视野 / 超距离 / 已离场的: 收掉(不留孤儿 Part)
            for p in pairs(TPL) do if not used[p] then tracerDrop(p) end end
        elseif next(TPL) then
            for p in pairs(TPL) do tracerDrop(p) end
        end
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

    -- ★★ v8.6.0 新增: 只取【基础 CPS】(不含等级/词缀的加成)。
    --   用户实测要求: "自动售卖 cps 是看背包里面的基础的 cps" ——
    --   背包里显示的就是这个基础值。原来门槛判的是 GetBrainrotCPS() 的**当前值**
    --   (基础 × 词缀 × 1.25^(等级-1)) —— 同一只脑红升过级/带词缀后数值暴涨,
    --   于是"明明门槛设得不高, 却什么都不卖"或者"该留的被卖了"。
    --   现在门槛按【基础 CPS】判, 与背包显示一致。
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
        -- ★★ v8.2.0: 等级乘数原来是【硬编码】1.25^(lv-1)。若本游戏的实际 CPS 并不随等级指数增长,
        --   它会把【低 CPS 物品算成高 CPS】→ 门槛看起来"没生效 / 什么都不卖"。
        --   现在做成可配: SYS.C_.SellLvMul, **默认 1.25 = 与改前完全一致(行为不变)**;
        --   设成 1 就是"不考虑等级"(纯基础值×词缀)。
        local lm=tonumber(SYS.C_.SellLvMul)
        if not lm or lm<=0 then lm=1.25 end
        return base*(MutBuff[mut] or 1)*(lm^(lv-1))
    end

    -- ★ v8.2.0 新增(排错用): 把这个物品的 CPS 是【怎么算出来的】摊开。
    --   以前只打印一个结果值, 分不清是"等级乘数"还是"词缀"把值抬上去的 —— 门槛判错时无从下手。
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

    -- ★ 独家物品保护检测
    -- ★★ v8.3.0 修 + 增强（交叉核对来源脚本 1.txt 得到）:
    --   ① 真 bug: 关键词表里的 "%%" 在 `string.find(n, kw, 1, true)`(**plain 模式**)下
    --      要的是【两个字面 %】，而名字里根本不会有 "%%" -> 这一条永远匹配不到。
    --      本意是"名字带 % 的物品"(如 Best-% 类)，应该写 "%"。**plain 模式下没有转义**。
    --   ② 增强: 关键词表只是猜。来源脚本里有**权威数据** —— BrainrotData 里
    --      `Best=<数字> / Upgradeable=false` 的 41 个物品就是"不可升级的 Best-% 独家物"。
    --      这里把它们列成白名单直接命中，比猜关键词可靠。
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
    SYS.ExclusiveKeepSet = EXCLUSIVE_KEEP_SET          -- 也给诊断用

    local function isExclusiveTool(t)
        if not t then return false end
        if EXCLUSIVE_KEEP_SET[t.Name] then return true end   -- ★ 权威名单(不可升级的 Best 类)
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
    -- ★★ v8.3.0 补（来源脚本 1.txt 的 SellHeldBrainrot 有这个兜底，我们漏了）:
    --   这个游戏里 B_Sell **优先是 RemoteFunction(ref_B_Sell)**，但同一份客户端代码里
    --   也存在 RemoteEvent(rev_B_Sell) 形态（来源脚本是按 "先 ref_ 再 rev_ 兜底" 的顺序写的）。
    --   我们原来只试 RFunction -> 一旦某个游戏版本把 B_Sell 做成 RemoteEvent，
    --   就会永远打印"❌ ref_B_Sell 找不到"，**整个自动售卖静默失效**。
    --   现在按 ref_ -> rev_ 的顺序试，与来源行为一致。
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
                    if not isExclusiveTool(t) then -- ★ 跳过独家物品
                        -- ★★ v9.4.0 回到【你在背包里看到的那个 CPS 值】= base × 词缀 × 1.25^(等级-1)。
                        --   8.6.0 我把它改成了"纯基础值(表里的 base)"—— 那是**另一个量纲**:
                        --   同一只脑红, 背包显示 90M, 表里 base 可能只有几万。
                        --   用户实测就是因此乱的: 「设 80M, 却卖了 80M 以上的, 40M 一个没卖」。
                        --   ⇒ 门槛必须比【显示值】, 这样"设 80M = 卖掉显示值低于 80M 的"才符合直觉。
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

                -- ★★ v8.2.0 修「自动售卖 / CPS 门槛 只生效一次就自己关了」── 这是真 bug, 不是设计:
                --   旧实现在【卖出过东西之后】就把 AutoSell 与 SellThresholdEnabled 两个开关**自动关掉**。
                --   但 UI 文案写的是「自动售卖 (每5秒)」, 下面也确实有个 5 秒循环 + 2 秒冷却 ——
                --   一个"每5秒跑"的循环在第一次成功后自我关闭, 是自相矛盾的。
                --   用户看到的现象正是: 「CPS 门槛开了又自己关」「自动售卖没反应」。
                --   现在: 卖出后【不再自动关闭两个开关】, 只存盘 + 刷新界面; 要停由用户自己关。
                -- ★★ v9.4.0 按用户要求【恢复「卖完自动关」】──
                --   历史: 8.1.0 及以前本来就是"卖出去过就把 AutoSell / CPS门槛 自动关掉";
                --   我 8.2.0 把它当成 bug 删了(理由: 与「自动售卖(每5秒)」文案矛盾)。
                --   但用户 2026-09-21 明确说:「就保留卖完自动关呗」—— 这是**他要的行为**:
                --   跑一轮把该卖的卖掉 -> 自动收手, 不会一直挂在那儿反复扫。
                --   ⇒ 这次恢复, 并在界面文案里写明它是"卖完一轮自动关"。
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
                    for _,f in ipairs(SYS.BtnRefs) do P(f) end -- 刷新UI开关状态(界面同步)
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
        local all={}            -- ★ v9.5.0: 全部物品 + 两个值 + 判定(给"看得见"的明细用)
        -- ★ v8.2.0 去重: 这里原来又把 isEntityTool 抄了一份(与本模块上方那份逐字相同)。
        --   同一套判据抄两份 = 改一处必忘另一处(见 AGENTS §2-D)。现在直接用外层那一份。
        local function scan(list)
            if not list then return end
            for _,t in ipairs(list:GetChildren()) do
                if isEntityTool(t) then
                    if not isExclusiveTool(t) then -- ★ 跳过独家物品
                        -- ★★ v9.4.0 同 pickLow: 门槛比【背包显示值】(不再是表里的纯 base)
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

    -- ★★ v9.2.0 曾在此加过「服务端播报监听(倍率/Boss/糖果/天气)」——
    --   用户 2026-09-21 明确表示【不需要】(日常播报噪音太大), 已整块撤掉。
    --   需要时按扫描落盘文件里的通道名重新接即可(纯 OnClientEvent, 无副作用)。


    -- ========== 健身房部分（全新） ==========
    -- ★★ v8.4.0 修「健身房 TP 没反应，而控制台一个字都不打」──
    --   病灶: liveMachines() 只靠 CollectionService 的标签 "LiftMachine" 找机器,
    --   而**标签名是游戏方打的、我们只是猜的**。猜错 -> 静默返回空表 ->
    --   StartGym 的循环每秒空转一次 -> 用户看到"开了没反应", 且**零日志**, 完全无从判断。
    --   现在: ① 按名字兜底找一遍(Model 才算, 排除自己角色/背包里的东西);
    --         ② 标签/名字各找到几个、以及最终用了哪个来源, 都打到控制台;
    --         ③ 每类提示只打一次, 不刷屏。
    local GymDiag = { tagWarn = false, nameWarn = false, emptyWarn = false, enterFail = false,
                      toolWarn = false, recogWarn = false }
    local function gymOnce(key, fmt, ...)
        if GymDiag[key] then return end
        GymDiag[key] = true
        print(("[Gym] " .. fmt):format(...))
    end
    SYS.GymDiag = GymDiag

    -- ★★ v8.5.0 按来源脚本逐条移植（**这是本次健身房 TP 的真修复**）────────────
    --   来源 1.txt 的 moveToLiftMachinePart 在传送【之前】先调 unequipAndUnanchor()：
    --       hum:UnequipTools() + root.Anchored=false + 速度清零
    --   而我们的实现【没有这一步】，反而在开头 `if root.Anchored then return false end` ——
    --   于是**角色一旦被 Anchor 住（藏地下隐身 / 飞行 / 被游戏锚定），健身房 TP 就永久静默失效**。
    --   ⇒ 现在照来源补齐：先"卸装 + 反锚定"，再传送。
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

    -- 来源 WeightData 的 16 档配重名（用来识别"举铁道具"，见 ensureGymTool 的名字兜底）
    local GYM_WEIGHT_NAMES = {
        ["Wooden Stick"]=true, ["Bone Barbell"]=true, ["Stone Block"]=true, ["Copper Plate"]=true,
        ["Iron Plate"]=true, ["Ice Barbell"]=true, ["Donut Barbell"]=true, ["Golden Barbell"]=true,
        ["Heaven Plate"]=true, ["Mega Golden Barbell"]=true, ["Neon Pulse"]=true,
        ["Giant Gold Star Barbell"]=true, ["Emerald Barbell"]=true, ["Planet Barbell"]=true,
        ["Big Jupiter"]=true, ["Black Hole Barbell"]=true,
    }
    SYS.GymWeightNames = GYM_WEIGHT_NAMES

    -- 记住上次"被游戏认可"的落点，下次优先试它（来源 Gym.Event.LastVerifiedPart 的做法）
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

        -- ① 标签没找到 -> 按名字兜底（只认 Model，且必须在 Workspace 里、不在自己身上）
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
        -- ★★ v8.5.0 修（来源有、我们没有）：传送【之前】必须"卸装 + 反锚定"。
        --   原来这里是 `if not root or root.Anchored then return false end` ——
        --   角色被 Anchor 住时直接返回 false，健身房 TP 就永远不动且无提示。
        gymPrepareRoot()
        local _, _, root = GC()
        if not root then return false end
        if root.Anchored then
            -- 反锚定后仍然是 anchored: 说明是别的模块/游戏在按住它, 这时传了也会被弹回去
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

    -- ★★ v8.5.0（来源有、我们没有）：只认 SquatTool 标签太窄 ——
    --   来源的判据是 `hasTag(tool,"SquatTool") or WeightByName[tool.Name]`（**名字兜底**）。
    --   补上之后，即使某个配重没被打标签，也能被认出来。
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
        -- ★ v8.5.0（来源有、我们没有）：循环结束后【再查一次】——
        --   属性可能正好在 deadline 那一刻翻过去，只查循环内会漏掉这一次。
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
        -- ★ v8.5.0（来源有、我们没有）：上次被认可过的落点，这次【优先】试它
        --   （来源 Gym.Event.LastVerifiedPart 的做法）—— 省掉盲试其它落点的来回传送。
        if GymLastPart and GymLastPart.Parent and machine == GymLastMachine then
            table.insert(candidates, 1, { Part = GymLastPart, Score = math.huge })
        end
        local maximum = math.min(#candidates, 8)
        local lastStage = "未开始"
        -- ★★ v8.4.0: 失败时**必须说清卡在哪一步** —— 原来这一步是静默 return false,
        --   于是"健身房tp 不生效"完全无法定位。现在把四个阶段分别报出来。
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
                    GymLastPart, GymLastMachine = part, machine     -- 记住这次被认可的落点
                    GymDiag.enterFail = false                       -- 成功一次后允许以后再报错
                    return true
                end
            end
            -- ★ v8.5.0（照来源 6773 行）：每个落点失败后都再"卸装+反锚定"一次再试下一个，
            --   否则失败留下的锚定状态会让后续所有落点一起失败。
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
    -- ★★ v9.9.5 修「超过一定距离就传不过去」—— 根因: 远距离分支【无视 TPMaxStep】。
    --   旧代码是 `tpStepChain(root,from,d.Unit,dist,4)` 固定 4 步, 单步 = dist/4:
    --   传 1200 格单步就是 300(正好压在设定值上), 传 4000 格单步 1000 格 ——
    --   单帧位移越大越会被服务端位置校验拉回, 越远越传不动, 表现出来就是"有个距离墙"。
    --   现在步数按 TPMaxStep 算: n = ceil(dist/STEP), 单步【绝不超过用户设定值】;
    --   上限 40 步(约 0.8 秒)防止超远距离无限拖。
    local function tpStepChain(root,from,dir,total,n,pos)
        local i=0
        local function one()
            if not root or not root.Parent then return end
            i=i+1
            local target = (i>=n) and (from+dir*total) or (from+dir*(total*i/n))
            root.CFrame=CFrame.new(target)
            if i<n then
                -- ⚠ 中间步【不做】补刀: 补刀和"下一步"都排在 +0.02s, 谁先跑不定 ——
                --   补刀若跑在后面会把位置倒回上一步(看得见的来回抖)。中间步现在都很小
                --   (<= TPMaxStep), 被拉回的概率低, 交给最后那一步统一收口即可。
                task.delay(0.02,one)
            else
                -- 最后一步: 先补一刀(0.05s)压住拉回, 再在 0.16s 后核一次是否真的到了
                task.delay(0.05,function()
                    if root.Parent then root.CFrame=CFrame.new(target) end
                end)
                if pos then
                    task.delay(0.16,function()
                        if root and root.Parent and (root.Position-pos).Magnitude>8 then
                            root.CFrame=CFrame.new(pos)
                        end
                    end)
                end
            end
        end
        one()
    end
    -- ★ v9.9.5: 落点贴地。旧版一律按"目标+2格"盲传 —— 传送到悬空的玩家/空中点时会
    --   落进空气里然后下坠, 看着也像"传送失败"。这里从目标上方 6 格向下打一条射线,
    --   只有【竖向差得明显(>4格)】才改成落在地面上, 避免影响本来就贴地的鼠标传送。
    local function groundSnap(pos)
        local ok,hit=P(function()
            local pa=RaycastParams.new()
            local okFT,ft=pcall(function()
                return Enum.RaycastFilterType.Exclude or Enum.RaycastFilterType.Blacklist
            end)
            pa.FilterType=(okFT and ft) or Enum.RaycastFilterType.Blacklist
            local ch=LP.Character
            if ch then pa.FilterDescendantsInstances={ch} end
            return WS:Raycast(pos+Vector3.new(0,6,0),Vector3.new(0,-40,0),pa)
        end)
        if ok and hit and hit.Position then
            local g=hit.Position+Vector3.new(0,3,0)
            if math.abs(g.Y-pos.Y)>4 then return g end
        end
        return pos
    end
    function SYS.TPTo(pos)
        local _,hum,root=GC() if not root then return false end
        if SYS.C_.TPMethod~="CFrame" then
            if hum then P(function() hum:MoveTo(pos) end) end
            return true
        end
        pos=groundSnap(pos)
        local STEP=math.max(20,tonumber(SYS.C_.TPMaxStep) or 300)
        local from=root.Position
        local d=pos-from
        local dist=d.Magnitude
        if dist<=STEP or dist<=0 then
            root.CFrame=CFrame.new(pos)
            task.delay(0.05,function() if root.Parent then root.CFrame=CFrame.new(pos) end end)
        else
            -- 远距离: 步数按 TPMaxStep 算, 单步不超过设定值(旧版固定 4 步 = 单步 dist/4, 越远越离谱)
            -- ★ v9.9.5: 上限 200 步(= 200×TPMaxStep, 默认 60000 格) —— 任何真实地图都到得了;
            --   不是"字面无限": 步数随时长增长, 再远只会更慢, 所以留这个上限只当失控保护。
            local n=math.min(200,math.max(2,math.ceil(dist/STEP)))
            tpStepChain(root,from,d.Unit,dist,n,pos)
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
CB.RenderName=SYS.N.Combat

--##########################################################################
--# ★★ v9.4.0 · FPS 服「服务端战斗数据」记录器（用户: "fps的做法能补强就上"）
--#   来源: 2026-09-21 综合扫描实锤 —— 对战服是【扁平】网络结构,
--#     remote 全在 `ReplicatedStorage.Remote.<服务名>.<名字>`（73 个 / 15 个服务分组）;
--#   同机器那份十层扫描的 GC 函数表还实锤了命中链路是【客户端算 → 报服务端】:
--#     `AsyncRaycast` / `AutoHitScan` / `ClientWeapon` → `CombatService.ActionEvent` → 服务端结算
--#   ⇒ 三条"权威输入"最有机会治「打不中 / 打了没伤害 / 空仓瞎按」:
--#     `EntityService.BeDamagedUnreliable`              → 命中确认
--#     `EntityService.DamageShield` / `DamageImmunity`  → 权威无敌盾
--#     `CombatService.Ammo`                             → 真实弹药
--#   ★★ 本版【只记录、绝不改变任何行为】—— 因为这三个通道的**参数格式都没实机见过**。
--#     猜着拿去当判据会出大问题(例如把 DamageShield 的参数理解成"所有人都有盾" -> 直接不开枪,
--#     连原来能打中的都打不了了)。**先让它把真实参数打出来, 拿到样本再接判据** ——
--#     这才是"补强"的正确顺序, 也是本项目的铁律(假警会引导人去改本来正确的代码)。
--##########################################################################
CB.Srv={}                     -- [通道] = {count=, last=, sample={前3次}}
local function srvRec(name, ...)
    local e=CB.Srv[name]
    if not e then e={count=0,last="",sample={}} CB.Srv[name]=e end
    e.count=e.count+1
    local args=table.pack(...)
    local parts={}
    for i=1,math.min(args.n,6) do
        local v=args[i]
        local tv
        if typeof(v)=="Instance" then
            tv="<"..v.ClassName..":"..tostring(v.Name)..">"
        elseif type(v)=="table" then
            local n=0 for _ in pairs(v) do n=n+1 end
            tv="{table "..n.." 项}"
        else
            tv=tostring(v)
        end
        if #tv>60 then tv=tv:sub(1,60).."…" end
        parts[#parts+1]=tv
    end
    e.last=table.concat(parts,", ")
    if #e.sample<3 then e.sample[#e.sample+1]=e.last end
end
CB.SrvRec=srvRec

function CB.StartSrvWatch()
    -- ★ 用【路径】传给 findRemote（它支持 "A.B" 逐级走 ReplicatedStorage.Remote.A.B）
    local CH={
        "CombatService.Ammo",
        "CombatService.ActionEvent",
        "EntityService.BeDamagedUnreliable",
        "EntityService.DamageShield",
        "EntityService.DamageImmunity",
        "EntityService.HealUnreliable",
        "EntityService.KnockbackUnreliable",
        "Any.TouchDamage",
    }
    CB.SrvCh={}
    local n=0
    for _,full in ipairs(CH) do
        local ev=SYS.REvent(full)
        if ev then
            n=n+1
            local name=full
            T(ev.OnClientEvent:Connect(function(...) srvRec(name, ...) end))
        end
    end
    print(("[Combat] 服务端战斗数据记录器已启动: 接上 %d/%d 个通道（**只记录, 不改任何行为**）"):format(n,#CH))
    if n>0 then
        print("[Combat] 玩一局后点「📡 看服务端战斗数据」, 把输出发我 -> 我就按真实参数把命中确认/权威盾/弹药接成判据")
    end
    return n
end
function CB.DumpSrv()
    local any=false
    for k,e in pairs(CB.Srv) do
        any=true
        print(("  [Srv] %-34s 收到 %d 次"):format(k,e.count))
        print(("        最近参数: %s"):format(e.last))
        for i,s in ipairs(e.sample) do print(("        样本%d   : %s"):format(i,s)) end
    end
    if not any then
        print("  [Srv] 还没收到任何战斗通道数据（这个游戏可能没有这些通道 / 或本局没打过）")
    end
    print("  （用途: 确认「谁有什么参数」—— 拿到后就能把命中确认/权威无敌盾/弹药接成判据）")
end
CB.StartSrvWatch()          -- ★ v9.4.0 立即挂上(只记录, 零行为影响)

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
    -- ★★ v6.10.1 按【DOORS(门)】抓包补: 容器不能只认 "Remote" 一个名字。
    --   DOORS 的死亡事件是 `ReplicatedStorage.RemotesFolder.PlayerDied` —— 容器叫 RemotesFolder,
    --   而且事件【平铺】挂在容器下(没有 GameService/EntityService 那一层)。
    --   旧代码只 FindFirstChild("Remote") -> 永远拿不到 -> 控制台刷
    --   "80 秒内没等到 ReplicatedStorage.Remote -> 死亡事件没订上(会退化回 Humanoid 判断)"。
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
    -- ★★ v6.10.1 平铺命名兜底(DOORS 那一类: 事件直接挂在【容器 / ReplicatedStorage 根】下, 不分层)
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
    -- 再兜一层: 一个都没订上时, 按关键词在容器里扫一遍(最多 200 个子项, 只认 Remote/Bindable 类型)
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
    -- ★★ v6.9.22 接入【游戏自己的敌我容器】(你的扫描报告实锤: Workspace.Highlight.Enemy.HighlightHolder.<玩家名>)。
    --   这是本游戏最权威的敌我信号 —— 比 @Team 靠谱得多(混战里 @Team 所有人取值一样, 区分不出敌我)。
    --   容器在、且他的名字在里面 -> 直接判敌人, 并跳过后面的"不打队友"排除(否则混战里会被整队排掉)。
    --   容器不在(换游戏) -> 返回 nil, 完全不影响原逻辑。
    if CB.GameSaysEnemy and CB.GameSaysEnemy(pl)==true then return true end
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
-- ★★ v7.7.0 补强批次2(概念来源: 公开 ESP 的"半透明遮挡重试射线" —— 只抄思路, 实现全自写):
--   视线判定里最冤的一类误判是"视觉上看得到、射线却打住了":
--     · 玻璃 / 栅栏 / 警戒线 / 力场 这类半透明网格(Transparency 0.25~0.9);
--     · 纯碰撞用的隐形墙(Transparency=1 且 CanCollide=true) —— 眼睛看不见它, 但它挡射线;
--     · 水面(FindPartOnRay 的第 4 参可直接忽略)。
--   老实现一条射线打住就返回"有遮挡" -> 真机上表现为"ESP 里明明亮着, 就是锁不上/子弹打在空气上"。
--   现在: 命中点若是【透明度 >= 0.25 的看得穿物件】, 就把它单独忽略、从命中点往后接着打, 最多 3 跳;
--   真墙(不透明)第一跳就停 —— 所以"打真墙"这个最常见场景的开销与老逻辑一模一样。
--   ⚠ 只用 FindPartOnRay 的"单实例忽略"参数做循环, 不新建 RaycastParams、不建忽略表 -> 不产生垃圾。
local RAY_HOPS=3
-- ★★ v7.8.0 修「静默退化」: FindPartOnRay 的 4 参形态(第 3/4 参 terrainCellsAreCubes / ignoreWater)
--   不是所有执行器都吃。万一不吃, 上面那句 pcall 会【把错误吞掉】-> hit=nil -> 判定成"视线全通"
--   -> 隔墙也会锁人 —— 这是只在【真实执行器里跑起来】才暴露、静态分析永远查不出的退化,
--   所以这里用"首次使用时探测一次 + 自动降级"在运行时自保, 不依赖任何外部验证手段。
--   现在首次使用时探测一次: 不通过就【永久降级为 2 参调用】(= 与 7.6.1 及以前逐字节同行为),
--   之后不再有任何探测开销。探测只朝正上方打 1 格、结果丢弃、不动角色。
local RAY_FULL=nil
local function rayProbe()
    if RAY_FULL~=nil then return RAY_FULL end
    RAY_FULL=false
    local ok=P(function()
        return WS:FindPartOnRay(Ray.new(Vector3.new(0,0,0),Vector3.new(0,0.001,0)),nil,false,true)
    end)
    if ok then RAY_FULL=true end
    SYS.RayFull=RAY_FULL          -- 供诊断面板(DiagUI)打印
    if not RAY_FULL then
        warn("[CheatMenu] 本执行器的 Workspace:FindPartOnRay 不接受 4 参形态 -> 视线判定已自动降级为 2 参(与旧版一致)")
    end
    return RAY_FULL
end
local function castVis(o,d)
    -- 返回: 真正挡住视线的那个 part; nil = 通(含"连着 3 层都是半透明" -> 视为看得见)
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
        -- 看得穿 -> 忽略它, 从命中点往后接着打; 拿不到命中点/推进太小就停(防死循环)
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
        -- ★ v7.7.0: 交给 castVis —— 半透明遮挡会自己让路(见函数头注释), 真墙行为不变。
        local hit=castVis(o,d)
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
    -- ★ v7.7.0: 同上, 走 castVis(半透明遮挡不算遮挡)
    local hit=castVis(o,d)
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
-- ★★ v9.9.0: 把"目标身上真正看得见的那一点"暴露出去 —— 射线改写(v9.9.0 修准头)要用它。
--   为什么不直接调 visPoint: 它是本段的 local, 而射线改写模块(§A33)在【另一段】里
--   —— 本项目的跨段调用一律走表(SYS.Combat.*), 见 `CB.BodyOf=bodyOf` 同一套路。
CB.HitPoint=visPoint

--======================== 抛射物弹道解算 (v7.8.4 新增) ========================
--  为什么需要: 下面的「预测瞄准」是【线性提前量】—— 它假设子弹是瞬发的(hitscan),
--  只要把准星搬到"目标 t 秒后所在的位置"就完事。但 FPS 里还有一整类【抛射物】武器
--  (弓/火箭筒/手雷/雪球/投掷物): 它们有【飞行时间】, 而且会【下坠】—— 线性提前量
--  只能补"目标在动", 补不了"子弹在飞的过程中往下掉", 于是远距离/高抛永远打低。
--  这里把三件事一起解: 求一个时间 t, 让"从枪口以初速 s 打出、受重力 g 下坠的子弹"
--  正好在 t 秒后撞上"以 v 匀速移动的目标" —— 这是关于 t 的【四次方程】, 闭式求根。
--
--  来源: 7GrandDadPGN/VapeV4ForRoblox  src/libraries/prediction.lua
--        SHA 9f8f19e943d58f21411192f592bcfcd78f14c0b0 (2026-09-19 仍在更新)
--        上游算法出处: devforum「Predict projectile ballistics (including gravity and motion)」
--        https://devforum.roblox.com/t/predict-projectile-ballistics-including-gravity-and-motion/1842434
--  相对上游的改动(4 处, 其余逐行保真):
--    (a) 剥掉上游那段"气球/跳跃玩家重力"的 Raycast 分支 —— 那是某个具体游戏的反物理补偿
--        (读 InflatedBalloons / IsOwlTarget 这类游戏私有 Attribute), 通用菜单里没有对应物。
--    (b) 取【最小正根】(最早的物理交点) 而不是上游"第一个正根" —— 上游正根的遍历顺序是按
--        三次方程求根顺序排的, 不保证最小, 会随机落到较晚的交点上。
--    (c) 补了一条 gravity<=0 的【二次方程】分支(上游那条路要除以 c0=l²=0, 会出 NaN)。
--    (d) r=0 的降次分支补回上游漏掉的 y=0 根(详见 bpQuartic 内注释)。
--
--  ★ 纯函数: 只吃 number / Vector3, 不碰实例、不建长期引用, 可离线单测。
--  单测见 .workbuddy/build/_ballistic_unit.py(从下面 @@BALLISTIC_BEGIN/END 之间
--  原样抽出真代码, 用真 luau.exe 跑, 正向积分反验交点)。
-- @@BALLISTIC_BEGIN
local BP_EPS=1e-9
local function bpIsZero(d) return (d>-BP_EPS and d<BP_EPS) end
local function bpCbrt(x)
    return (x>0) and (x^(1/3)) or -((-x)^(1/3))
end

-- 二次: c0 x² + c1 x + c2 = 0
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

-- 三次: c0 x³ + c1 x² + c2 x + c3 = 0
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
        -- 三个实根(不可约情形)。acos 的入参夹到 [-1,1] 防浮点越界出 NaN。
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
    -- ★ 必须把"没有的根"显式置 nil: Lua 里 0 是【真值】, 留着占位的 0 会被上层
    --   当成"这个根存在, 值是 0"而多解一遍(上游用 {solveCubic(...)} 靠表构造截断规避,
    --   这里直接返回多值, 就得自己清干净)。
    local sub=(1/3)*A
    if num>0 then s0=s0-sub else s0=nil end
    if num>1 then s1=s1-sub else s1=nil end
    if num>2 then s2=s2-sub else s2=nil end
    return s0,s1,s2,num
end

-- 四次: c0 x⁴ + c1 x³ + c2 x² + c3 x + c4 = 0
-- 做法(Ferrari/降次): 先用预解三次方程求 z, 再把四次拆成两个二次来解。
-- ★ 返回【数组】而不是多返回值 —— 上游的多返回值写法在"根的个数不定"时很容易串位。
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
        -- r=0: 降次后的四次式是 y·(y³ + p·y + q) -> 根 = {y=0} ∪ 三次的根。
        -- ★ 上游在这里【漏掉了 y=0 那一个根】(只解了三次), 这里补回来。
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

-- 解"抛射物与移动目标的交点"。返回 (瞄准点, 飞行时间); 解不出来返回 nil。
--   origin     : 发射点(本菜单用相机位置 —— 与下面的瞄准几何同源, 方向才对得上)
--   speed      : 抛射物初速(studs/秒)
--   gravity    : 下坠加速度(studs/秒²); <=0 走无下坠的二次分支
--   targetPos  : 目标【当前位置】(调用前已过 visPoint, 头皮位时是露出来的那块)
--   targetVel  : 目标速度向量
--   返回的瞄准点语义 = origin + 需要的【发射速度向量】: 方向即正确枪口朝向,
--   所以直接丢给 CFrame.lookAt(相机位置, 瞄准点) 就是对的(与上游 Vape 的用法一致)。
local function bpSolve(origin,speed,gravity,targetPos,targetVel)
    if not (speed and speed>1) then return nil end
    local disp=targetPos-origin
    local p,q,r=targetVel.X,targetVel.Y,targetVel.Z
    local h,j,k=disp.X,disp.Y,disp.Z

    -- 无重力: |disp + v·t|² = s²t²  ->  (|v|²-s²)t² + 2(disp·v)t + |disp|² = 0
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
    -- 回代求发射速度向量:  u = (disp + v·t)/t - ½g·t
    --   e 那一项里 -l*t*t = +0.5*g*t², 就是"往上抬"的补偿量(子弹会掉, 所以要抬高打)。
    local d=(h+p*t)/t
    local e=(j+q*t-l*t*t)/t
    local f=(k+r*t)/t
    return origin+Vector3.new(d,e,f),t
end
-- @@BALLISTIC_END

-- 抛射物弹道瞄准点。开关关 / 参数不对 / 解不出交点 -> 一律返回 nil, 由 leadPos 静默退回线性路径。
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

-- 命中点(带预测提前量)。CB_Predict 关掉时就是目标当前位置。
-- 为什么需要: 打移动目标时, 直接瞄"他现在的位置"等子弹/判定到达就已经偏了;
-- 瞄"他 CB_PredictTime 秒之后会在的位置"才命中。目标的横向速度越快, 这个值要越大。
local function leadPos()
    local p=CB.TargetPart
    if not p then return nil end
    -- ★ v3.9.0: 基准点先过一遍"可见点"(头皮位时瞄露出来的那块, 而不是被掩体挡住的中心)
    local pos=visPoint(p)
    -- ★★ v7.8.4 抛射物弹道预判(独立开关, 默认关): 见上面 [抛射物弹道解算] 块。
    --   拿到"子弹真正会撞上目标的那一点"就用它; 解不出来(超出射程 / 初速填错)就静默
    --   退回下面的老路径 —— 默认关时这段完全不执行, 老行为零变化。
    --   ★ 返回值同样是"相机该朝的方向上的一个点", 与下面线性路径的语义一致,
    --     所以 aimTick / fireTick 里那三处 leadPos() 调用(都只拿它当 lookAt 目标)不用改。
    if SYS.T_.CB_Ballistic then
        local bp=CB.BallisticPoint(p,pos)
        if bp then return bp end
    end
    if not SYS.T_.CB_Predict then return pos end
    -- ★★ v8.7.0 提前量改进(对照公开实现 Open-Aimbot 的 "Move Direction Prediction / Auto Offset")
    --   ① 原来 t 是**固定** 0.14s —— 但真正该补的是"从我决定瞄他、到子弹真的出膛"这段延迟,
    --      它随【距离】变化(越远越要提前; Open-Aimbot 的 AutoOffset 就是 `* dist/1000`)。
    --      所以现在 t 按距离放大, 并封顶, 避免远距离把准星甩飞。
    --   ② 速度优先用 AssemblyLinearVelocity(真速度, 含冲刺/被推); 它接近 0 时退回
    --      Humanoid.MoveDirection(输入方向, 单位向量) —— 公开实现普遍用后者,
    --      因为人类角色的 Velocity 常被物理/摩擦抹平, 而 MoveDirection 一定反映"他往哪走"。
    local base=SYS.C_.CB_PredictTime or 0.14
    -- ★★ v9.9.0 修「提前量不随距离放大」(代码与界面说明不一致):
    --   旧代码这里算的是 p2=CB.TargetPart.Position 与 pos=visPoint(同一个部位) 的距离 ——
    --   那是【同一个目标身上】"中心 ↔ 可见点"的距离, 恒定 ~0.5 格, 于是
    --   t 恒等于 base、距离放大这一档<b>从来没生效过</b>; 而战斗页 Tip 明明写着
    --   "提前量会随距离自动放大（越远补得越多，最多 3 倍）"。
    --   现在改成【射手 -> 目标】的真实距离, 代码与界面说明一致。
    --   ⚠ 行为变化: 远距离的提前量会比以前大(最多 3 倍 base)。若觉得远距离甩过头,
    --     调小战斗页的「预测提前量」滑条即可(默认 0.14 秒)。
    local me=bodyOf(SYS.LP.Character)
    local myPos=(me and me.Position) or (SYS.Cam and SYS.Cam.CFrame and SYS.Cam.CFrame.Position)
    local dist=(myPos and (pos-myPos).Magnitude) or 0
    local t=base*math.clamp(1+dist/500,1,3.0)          -- 距离越远补得越多, 最多 3 倍
    local v=p.AssemblyLinearVelocity
    if not v then
        local ok,r=pcall(function() return p.Velocity end)
        if ok then v=r end
    end
    local lead=pos
    local vspeed=(v and v.Magnitude) or 0
    if vspeed>0.05 then
        lead=lead+v*t
    else
        -- 速度不可靠 -> 用目标的人形输入方向兜底(单位向量 × 提前量距离)
        local h0=CB.Target and humOf(CB.Target)
        local md=h0 and h0.MoveDirection
        if md and md.Magnitude>0.01 then
            lead=lead+md.Unit*(vspeed>0 and vspeed or (7*t))   -- 无速度时按"常速 7 格/秒"估
        end
    end
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
-- ★ 保留(v3.7.2 复核更正): 战斗页诊断读的是【别名】CB.BodyOf, 按字面名扫描会漏掉它 -> 不是死代码
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
        -- ★★ v8.7.0 修「怎么还锁隔墙的人」──
        --   原来这里还有一条 `(SYS.C_.CB_ScanMs or 33)<=0` 的旁路: 把【索敌间隔设 0(每帧秒锁)】
        --   和【不看视线】捆在了一起 —— 用户为了"快"把间隔设 0, 代价就是隔墙也锁。
        --   现在把这两件事解耦: 间隔只决定"多快扫", **视线永远由 CB_Wall 决定**。
        --   想无视墙请用「子弹穿墙 / 360」这两个显式开关, 不要再靠"把间隔调 0" 顺手带出来。
        if p and (not SYS.T_.CB_Wall or SYS.T_.CB_360 or clearShot(p)) then return pl,p end
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
                        -- ★★ v8.7.0 同上: 去掉 `CB_ScanMs<=0` 这条"为了快就不看墙"的旁路。
                        --   保留 CB_SilentNoTurn(真·静默): 那条路径会改写射线命中, 墙本来就绕过去了, 语义不同。
                        if pp and (not SYS.T_.CB_Wall or SYS.T_.CB_360
                   or SYS.T_.CB_SilentNoTurn or clearShot(pp)) then return hp,pp end
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
    -- ★★ v6.9.21 修「真·静默还是不行」(用户实测): 开了真静默就【一点都不转】——
    --   相机不转、角色也不转, 连"自动瞄准"那一档的每帧转向也一起压掉。
    --   否则你看到的依旧是"它还在瞄人"(因为自动瞄准每帧把相机拽过去, 真静默只管了扣扳机那一瞬)。
    if SYS.T_.CB_SilentNoTurn then return end
    -- v60: 打开「自动瞄准」就持续瞄。C/End 键热键已在 v66 移除, "按住临时瞄"不再存在。
    if not SYS.T_.CB_Aim then return end
    -- ★ v6.7.0 瞄准补强(融合自 ChronixHub 瞄准设置): 命中率闸门
    -- ★ v6.9.17: 「命中率」已删 -> 不再有"这一帧不瞄"的跳过
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
    -- ★ v6.8.0 反指纹: 开火间隔加 ±20% 抖动 —— 恒定间隔是最容易被统计出来的特征
    --   (平均值不变, 快慢手感不变; 只是不再"每一枪都精确隔 0.060 秒")。
    -- ★★ v6.9.18 无延迟模式: 间隔压到 5ms(不再抖动); 平时仍是"用户设置 + ±20% 抖动"(反指纹)
    -- ★★ v6.9.21: 开火间隔设 0 = 每帧都开(不再抖动); >0 时保留 ±20% 抖动(反指纹)
    local fd=tonumber(SYS.C_.CB_FireDelay) or 0.06
    local fireGap=(fd<=0) and 0 or (fd*(0.8+math.random()*0.4))
    if now-CB.LastFire<fireGap then return end
    -- ★ v6.7.0 漏打模式: 按概率跳过这次开火(制造"打偏"观感)
    -- ★ v6.9.17: 「漏打模式」已删 -> 开火不再按概率跳过
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
    -- ★★ v6.9.16 修「瞄到锁到都不开火 / 开火慢 / 没能 360(有人却不打)」:
    --   旧逻辑把【静默 / 快照开火】和自动瞄准捆在一起, 要求"准星必须压在瞄准点上";
    --   而这两种模式要么射线已被改写、要么开火前会把相机瞬时对准目标 —— 等准星纯属白等,
    --   表现就是"锁到了不开火"。自动瞄准那边也一样: 默认平滑 0.28 = 相机要几百毫秒才转到位,
    --   这期间准星不在 6% 容差内 -> 一直不开火。
    --   现在分三档:
    --     · 360 / 静默 / 快照开火  -> 直接放行(不看准星)
    --     · 自动瞄准 + 平滑>=1     -> 直接放行(相机是瞬时转过去的)
    --     · 自动瞄准 + 渐进转向    -> 容差从 6% 放宽到 12%(还在转的途中也允许开火)
    local zeroScan=(tonumber(SYS.C_.CB_ScanMs) or 33)<=0
    -- ★ v9.5.0 隐蔽模式: 不看"索敌间隔=0"这条快捷放行 —— 那会让"准星还没压上去也开火"
    local silo=(SYS.T_.CB_Silent or SYS.T_.CB_SilentAim or SYS.T_.CB_360 or SYS.T_.CB_SnapFire
                or (zeroScan and not SYS.T_.CB_Stealth))
    if SYS.T_.CB_Silent or SYS.T_.CB_Aim or SYS.T_.CB_SnapFire or SYS.T_.CB_360 then
        local ap=CB.TargetPart and (leadPos() or CB.TargetPart.Position)
        if not ap then return end
        -- ★ v3.9.x 自动开火适配自动瞄准: 跟随速度拉满(CB_Smooth>=1)时相机是【瞬时】转到目标的,
        --   此刻准星必然已经压在瞄准点上 —— 不用再走屏幕投影容差判定(那一步会因"瞄准点≠部位中心"
        --   或远距离小目标而误判没压中, 结果就是"瞄准对上了却不开火")。直接放行开火。
        --   只有渐进转向(CB_Smooth<1)时才需要等准星真正压中, 避免空放。
        if silo or (SYS.C_.CB_Smooth or 0.25)>=1 then
            canFire=true
        else
            local sp,on=cam:WorldToViewportPoint(ap)
            if not (on and sp.Z>0) then return end
            local tol=(vp.Y or 1080)*0.12     -- ★ v6.9.16: 6% -> 12%(转向途中也允许开火)
            canFire=((sp.X-vp.X/2)^2+(sp.Y-vp.Y/2)^2)<=tol*tol
        end
    else
        canFire = crosshairOnEnemy()
    end
    if not canFire then return end
    -- ★★ v6.9.16: 360 / 快照开火 -> 扣扳机之前先把【相机 + 角色朝向】瞬时对准目标。
    --   服务端是按"角色朝向/枪口方向"判定命中的: 不转过去, 点击发出去了也打不中(用户看到的"开枪没伤害")。
    -- ★★ v6.9.18 真·静默: 开了「不改朝向」时【不转相机也不转角色】—— 纯靠改写射线命中,
    --   这样视觉上就是"我都没瞄他, 子弹却打中了"(用户要的静默语义)。
    -- ★★ v6.9.21: 合并后「真·静默」自己就代表"不转向"(装 hook 也在这个开关里), 不用再 and 两个键。
    local noTurn=SYS.T_.CB_SilentNoTurn
    -- ★★ v8.7.0 修「不够快 / 打不中」的关键一步: 扣扳机之前把【相机 + 角色朝向】瞬时对准瞄准点。
    --   原来只有 360 / 快照开火 才做这一步; 而【自动瞄准 + 自动开火】默认 CB_Smooth=0.28 是渐进转向 ——
    --   相机还在转、准星还没压上去, 就按 12% 容差"放行开火"了
    --   => **一边转一边开枪 = 大量空放**, 用户感受就是"不够快、也不准"。
    --   现在: 只要开了自动瞄准且开着自动开火, 就在【开火那一帧】瞬时对准。
    --   视觉上仍是平滑跟随, 只有扣扳机瞬间跳到点上 —— 命中率立刻上来, 又不必把平滑调成"不自然"。
    --   ⇔ 如果你更在意"别让人看出来"(反指纹自检 D8 相机行为 / D7 开火节奏 会盯这两样),
    --     就把「🙈 隐蔽模式」打开: 那时**不做这一帧对准**, 改回"等准星自己压上去再开火"
    --     —— 命中率会降一点, 但没有相机跳变。
    if (SYS.T_.CB_360 or SYS.T_.CB_SnapFire or (SYS.T_.CB_Aim and SYS.T_.CB_Fire))
       and not noTurn and not SYS.T_.CB_Stealth then
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
    -- ★★ v6.9.18: 总闸补上 360 / 静默瞄准 / 子弹穿墙 —— 原来只认"自动瞄准/静默/开火"三种,
    --   导致【只开 360 或只开静默瞄准】时整个战斗循环空转(用户看到的就是"开了没反应")。
    local anyOn=SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_Fire
        or SYS.T_.CB_360 or SYS.T_.CB_SilentAim or SYS.T_.CB_BulletWall or SYS.T_.CB_SilentNoTurn
    if not anyOn then
        CB.Target=nil CB.TargetPart=nil
        return
    end

    -- ★★ v6.9.18 「无延迟模式」: 选人从 30Hz 提到【每帧】(看到就锁), 并且不看视线(隔墙也锁)。
    -- ★★ v6.9.21「无延迟」改成参数: 索敌间隔(毫秒)可设 0 = 每帧秒锁(原来是一个写死的 30Hz + 一个开关)
    local scanMs=tonumber(SYS.C_.CB_ScanMs)
    if scanMs==nil then scanMs=33 end
    local scanDt=scanMs/1000
    accScan=accScan+dt
    if accScan>=scanDt then
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
    SYS.C_.CB_Smooth=1 SYS.C_.CB_FireDelay=0.08   -- ★ v6.8.0: 抬到人类下限(原 0.04), 见 CB_FireDelay 默认值注释
    SYS.C_.CB_AimPart=1
    -- ★ 注意: QueueSave 是 [02] 段的 local, 本模块在 [11.5] 词法作用域取不到 -> 走 SYS 查表
    P(SYS.QueueSave)
    for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
    CB.Start()
    CB.Say("⚡ 一键开战: 自动瞄准 + 自动开火 + 预测 + 锁头 + 优先链(正在瞄我的→指定→最近→屏幕中心)",SYS.CY.green)
    print("[Combat] ⚡ 一键开战: 自动瞄准 + 自动开火 0.04s + 预测 + 锁头 + 优先链 1")
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
-- ★★ v9.9.0 修: 补上【真·静默】的两个键(`CB_SilentAim` / `CB_SilentNoTurn`)。
--   原来这里只看 CB_Aim / CB_Silent / CB_Fire —— 于是"只开真·静默"时这个看门狗每帧都在
--   执行 else 分支的 `CB.Stop()`, 把战斗循环停掉 ⇒ `CB.TargetPart` 恒为 nil
--   ⇒ 射线改写钩子拿不到目标, 那一枪原样走真实射线(=真·静默一点都不生效)。
--   (用户报"静默瞄准的准头不准"时通常还开着自动开火, 所以旧实现能跑起来; 但只开真·静默 = 完全无效。)
T(RS.Heartbeat:Connect(function()
    if SYS.Unloaded then return end
    if SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_Fire
       or SYS.T_.CB_SilentAim or SYS.T_.CB_SilentNoTurn then
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
    if (SYS.C_.CB_FireDelay or 0.08)==0.06 then SYS.C_.CB_FireDelay=0.08 end
    print(("[Combat] v72 参数: 单次转角上限=360° 最小间隔=%.2f 转向后延迟=%.2f 开火间隔=%.3f")
        :format(SYS.C_.CB_SnapMinGap,SYS.C_.CB_SnapDelay,SYS.C_.CB_FireDelay))
end
P(CB.MigrateV72)
P(hookDeathEvents,0)   -- ★ v76: 订阅死亡/复活事件(只读); ★ v103 带重试

-- 模块加载时若配置里有开着的战斗开关, 直接起来
--   ★ v9.9.0: 同步加上真·静默的两个键(理由同上面的 Heartbeat 看门狗)
if SYS.T_.CB_Aim or SYS.T_.CB_Silent or SYS.T_.CB_Fire
   or SYS.T_.CB_SilentAim or SYS.T_.CB_SilentNoTurn then
    CB.Start()
end

print("[CheatMenu] 战斗模块已加载 (菜单战斗页: 一键开战/停战 + 各开关 · 按 V 切换指定目标)")

--============================================================
--============================================================
-- [12] 翻译模块 v120 · 分层重写
-- ------------------------------------------------------------
-- 这一版把【提示词 / 词表 / 清单 / 阈值】全部收进最上面的「① 数据层」,
-- 逻辑层只跑流程 —— 以后要改翻译行为, 先看 ①, 不必再翻遍整个模块。
--
-- 分层(自上而下, 每层只用它上面的东西):
--   ① 数据层   提示词 · 词表 · 表情 · 保留词 · 各种上限
--   ② 工具层   扫脚本 / 判中文 / 去富文本 / 拆前缀 / 字面替换 / 混排切分
--   ③ 短语层   本地词表(零延迟, 不吃服务器槽位)
--   ④ 判定层   Outputs→Self→Dyn→玩家名 → shouldTranslate → verdictOf
--   ⑤ 缓存层   TransCache.json(原子写 + .bak 回退)
--   ⑥ 网络层   掩码 → 请求 → 质量门 → 失败退避 / 全局闸门
--   ⑦ 翻译层   translate / translateTo
--   ⑧ 并发池   真并发(上限=服务器槽位, 排队绝不丢弃)
--   ⑨ 落字层   写回控件 / 中英对照 / 混排回填 / 变更钩子
--   ⑩ 驱动层   扫描(界面·3D·Prompt) / 聊天 / 还原原文
--   ⑪ 诊断层   dump* / 探测 / 卸载 / 初始化
--
-- 对外契约(UI「翻译」页 + [16.1] 忽略表只认这些, 少一个界面就断):
--   LANGS langName SendLang Stats cacheCount CACHE_FILE IgnoreObjects WaitN
--   startUIScan stopUIScan startChatListener stopChatListener forceRescan reqOn
--   dumpDyn dumpFails restoreSource checkLocal probeServer saveCache
--   clearCache smartSend refreshLocalStatus Unload
--
-- ⚠️ 模块内部 local 全部包在一个 do..end 里 —— 不占 main chunk 的
--    「每函数最多 200 个 local」额度, 以后往这里加东西不会再被这个上限卡住。
-- 唯一挂载点 SYS.Trans; 开关 SYS.T_.{TransChat,TransUI,TransBilingual,TransDyn,LocalPhrase}。
--============================================================
local Trans={}
SYS.Trans=Trans
do

--============================================================
-- ① 数据层 —— 改提示词 / 词表 / 阈值, 只动这一段
--============================================================

-- ★ 本地后端 = llama.cpp 加载 Hy-MT2-7B(混元翻译第二代 GGUF), 固定本机不做成可改项。
--   「本地 Hy-MT2」和「云端 Hunyuan-MT-7B」同属腾讯混元翻译(Hunyuan-MT)家族 —— 一个模型两种接入。
local HOST="http://127.0.0.1:8080"
local KEY="rk_4a56fc43faa5edb9f7a0cafd4ad3e91f"
local MODEL="hymt2-7b"
local function hostOf() return HOST end

-- ★★ v120.2 定稿: 翻译【只走本机 llama.cpp】, 云端后端(硅基流动)整段删除。
--   理由(2026-09-21 实测): 同一条文本云端 hot 0.32s / cold 1.38s, 本地 hot 0.05s;
--   云端还被免费档限流卡在并发 4, 高并发下尾部延迟比本地差一个数量级。
--   云端的唯一好处是"不吃本机显存", 但代价是每次请求都要绕公网 + 撞限流 ->
--   用户实测"api 翻译也慢"。既然本地同源模型更快, 就没有保留双后端的必要。
--   (曾经的双后端实现见 v120.1; 采样参数、提示词、词表完全不受影响。)

-- ★ 采样参数(Hunyuan-MT 官方推荐值的确定性变体)。
--   取值依据: Hunyuan-MT 官方推荐 top_k=20 / top_p=0.6 / repetition_penalty=1.05;
--   temperature 官方给 0.7 是为"多样性翻译", 游戏 UI 要术语一致(确定性) → 用 0.1。
local SAMP_TEMP=0.1
local SAMP_TOP_P=0.6
local SAMP_TOP_K=20
local SAMP_REP_PEN=1.05

-- 系统提示词(针对 Hunyuan-MT / Hy-MT 混元翻译模型): 官方翻译指令风格 + 术语词表 + 占位符/货币保护。
-- ★ 实测三条铁律(2026-09-20 真 API):
--   ① 官方只用 user "Translate...into Chinese" 会丢术语(Coins→硬币)和占位符({5}) —— 必须用 system 塞词表+约束;
--   ② 词表放 user 会被当待译内容原样复述出来 —— 词表只能放 system;
--   ③ user 不能再加"Translate..."前缀(短词会触发词表复述) —— user 保持裸文本, 指令+词表全在 system。
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

-- 反向翻译(中->外)的提示词模板, 供「翻译后发送」用
Trans.LANG_PROMPT={en="English",zh="Chinese",ja="Japanese",ko="Korean",th="Thai",ru="Russian",ar="Arabic"}

-- 颜文字 / 表情: 整串精确命中 -> 不翻(不会误伤正常单词)
local EMOTICONS="qaq|qwq|qoq|awa|owo|uwu|ovo|tvt|o_o|0_0|-_-|^_^|>_<|t_t|u_u|x_x|o3o|:3|:)|:(|:d|:p|xd|orz|otl|233|555|www|hhh|aaa"
-- 物品等级 / 稀有度分类词: 整串命中 -> 保留原样(中文服也常写英文)
local KEEPW="og|secret|mythic|legendary|epic|rare|uncommon|common|divine|celestial|exclusive|limited|godly|ultra|special|unique|hidden|ancient|eternal|transcendent|op"

-- 各种上限 / 阈值(集中在此, 要调节行为先看这里)
local OUTCAP=12000        -- 输出集合(防重翻)两代轮换阈值
local SELFCAP=8000        -- 自噬保护网两代轮换阈值
local VERDICT_CAP=8000    -- 判定缓存上限
local DYN_MAX=6000        -- 动态文本判定表上限
local DYN_WIN=12          -- 动态文本: 同一控件的计数窗口(秒)
local DYN_HITS=4          -- 窗口内变化 >= 4 次 -> 判为动态文本
local DYN_LEN=60          -- 超过这么长的文本不参与动态判定
local T2O_CAP=2000        -- 译文->原文 反查表上限
-- ★ 与 T2O_N 配对的【计数器】必须声明在这里(而不是放在"⑨ 落字层"那一段):
--   Trans.clearCache() 定义在⑨之前, local 若写在后面, 那里的 T2O_N 会被解析成【全局】——
--   ① 写全局 = 泄漏一个可检测的名字(本项目全局名一律走 SYS.N / SYS.GK 中性池);
--   ② 真正那个计数清不掉 => 反查表上限形同虚设, T2O 表会一路膨胀。
local T2O_N=0
local RV_CAP=2000         -- 反向翻译缓存上限
local FAIL_BASE,FAIL_CAP,FAIL_MAXN=3,300,4000   -- 失败退避: 3s 起, 每级翻倍, 300s 封顶, 表容量
local NET_STREAK_MAX,NET_GATE_S=3,4             -- 连续 3 次传输失败 -> 全体暂停 4s(自动恢复)
local HOOK_MAX=1500       -- 文本变更钩子数量上限
local HOOK_PER_SEC=40     -- 每秒最多新挂 40 个(摊平首次扫描的突发)
local RETRY_MAX=5         -- 单控件被游戏改回后的重翻次数上限
local RETRY_GAP=0.1       -- 节流: 0.1s 内的重复变更合并成一次
local SCAN_GAP=0.5        -- 界面扫描间隔(秒)
local SCAN_IDLE=1         -- 一轮什么都没扫到时的退避(秒)
local WS_EVERY=10         -- 每 N 轮额外扫一次 Workspace(世界 3D 文本)
local REQ_TIMEOUT=60      -- 请求超时(秒): 本机 7B 单条可能要几十秒
local MAX_TOK_FALLBACK=512
local PROMPT_FIELDS={"ActionText","ObjectText"}   -- ProximityPrompt 没有 .Text

-- 语种清单 / 发送方向 / 统计(契约成员, UI 页直接读)
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

-- 本地短语表(零延迟直译; 词表只在 lookupLocal 里查)
local WORD_TABLE={ -- 358 条(已去重, 取最终生效值)
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
local PHRASE_TABLE={ -- 50 条(已去重, 取最终生效值)
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
--============================================================
-- ② 工具层 —— 纯函数, 无状态
--============================================================
local NON_ASCII="[\128-\255]"
local utf8codes=(type(utf8)=="table" and type(utf8.codes)=="function") and utf8.codes or nil

-- 一趟扫描同时问出 汉字/假名/谚文 三标志(utf8 不可用时退到字节判)
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
    -- 字节兜底: E4-E9=汉字; E3 81-83=假名, E3 90-BF=扩展A汉字; EA-ED=谚文
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

-- 纯正中文 = 含汉字 且 不含假名/谚文(日文假名/韩文谚文要交给翻译)
local function hasChinese(s)
    if type(s)~="string" or s=="" then return false end
    if not s:find(NON_ASCII) then return false end          -- 纯 ASCII 快通道(C 层一次 find)
    local han,kana,hangul=scanScript(s)
    return han and not kana and not hangul
end
local function hasKanaOrHangul(s)
    local _,kana,hangul=scanScript(s)
    return kana or hangul
end
-- 有没有外文字符(latin / 假名 / 谚文 / 泰文 / 西里尔 / 阿拉伯)
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
-- 拆出 "名字: " 前缀(富文本 font 前缀 / 普通冒号前缀; 但不像 http://)
local function splitPrefix(text)
    if type(text)~="string" then return "",text or "" end
    local p1,c1=text:match("^(<font[^>]*>.-:</font>%s*)(.+)$")
    if p1 and c1 and c1~="" then return p1,c1 end
    local p3,c3=text:match("^(.-[:：]%s*)([^/%s].*)$")
    if p3 and c3 and c3~="" and #p3<=40 and not text:match("^%a[%w%+%-%.]*://") then return p3,c3 end
    return "",text
end
-- ★ v120.2 在【原始串(含标签)】上切前缀 —— 前缀里的标签要原样保住(游戏给玩家名/频道加色用的):
--   老做法是在 stripRich() 之后切, 前缀的 <font color=..> 就没了, 写回去时颜色丢失。
--   ⚠ 普通的"冒号前缀"分支遇到标签会切坏(<b>Reward:</b> 会被切成前缀 "<b>Reward:" + 正文 "</b> .."),
--     所以【只对无标签的串】用冒号分支; 有标签时只认完整闭合的 <font ...>...</font> 前缀。
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
-- 去标签 + 压空白 + 小写
local function normalizeKey(text)
    if type(text)~="string" then return text end
    text=(text:gsub("<[^>]*>",""))
    return ((text:gsub("^%s+","")):gsub("%s+$","")):lower()
end
local function trim(s) return (s:gsub("^%s+","")):gsub("%s+$","") end
-- 字面替换: 原文含 %  -  . 等模式字符也不会被当正则
--   (以前 cur:gsub(plain,hit,1) 会把原文当 Lua 模式 -> "50% exp" 这类直接抛错, 静默杀掉整个扫描)
local function plainReplace(s,from,to)
    if type(s)~="string" or type(from)~="string" or from=="" then return s end
    local i,j=s:find(from,1,true)
    if not i then return s end
    return s:sub(1,i-1)..tostring(to)..s:sub(j+1)
end
local function isHanCp(cp)
    return (cp>=0x4E00 and cp<=0x9FFF) or (cp>=0x3400 and cp<=0x4DBF) or (cp>=0xF900 and cp<=0xFAFF)
end
-- 混排切分: 返回 { {text=..,han=bool}, ... }(汉字段 / 外文数字标点段)
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
    -- 字节兜底: E4-E9 开头按汉字(3 字节/字)聚段
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

--============================================================
-- ③ 短语层 —— 本地词表(零延迟, 不吃服务器槽位)
--============================================================
local function lookupLocal(text)
    -- 「本地短语表」开关关掉 -> 没开翻译模型就什么都不翻
    --   (用户"清空了缓存却发现还有东西被翻译", 就是这张内置离线短语表在起作用, 它跟缓存无关)
    if SYS.T_.LocalPhrase==false then return nil end
    if type(text)~="string" then return nil end
    -- "数值 + 货币名"整段: "1K Coins" -> "1K 金币"(保留数值原样)
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

--============================================================
-- ④ 判定层 —— "这句要不要翻 / 翻过没有"
--============================================================
-- (a) 输出集合: 我们自己产出过的译文 -> 永不重翻(防二次翻译的根)
Trans.Outputs={}
Trans.OutputsOld={}
Trans.OutputsN=0
local function markOutput(s)
    if type(s)~="string" or s=="" or not hasChinese(s) then return end
    if Trans.Outputs[s] or Trans.OutputsOld[s] then return end
    if Trans.OutputsN>=OUTCAP then
        -- 两代轮换: 旧的一代降级保留, 绝不整表丢弃
        --   (整表丢弃的那一瞬间, alreadyOurs 对所有历史译文都返回 false = 保护网出现空窗)
        Trans.OutputsOld=Trans.Outputs Trans.Outputs={} Trans.OutputsN=0
    end
    Trans.Outputs[s]=true
    Trans.OutputsN=Trans.OutputsN+1
end
Trans.markOutput=markOutput
local function alreadyOurs(s) return type(s)=="string" and (Trans.Outputs[s]==true or Trans.OutputsOld[s]==true) end
Trans.alreadyOurs=alreadyOurs

-- (b) 玩家名清单: 顶栏/记分板/头顶名牌这类整条就是玩家名的东西, 不翻
--   事件置脏 + 每 64 次调用兜底复查一次 —— 常规路径只剩 1 次哈希查表, GetPlayers() 降到 1/64
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
    -- ⚠️ T() 必须写在 pcall 内部: 直接 T(pcall(...)) 只会拿到 pcall 的第一个返回值(ok), 登记不上。
    --   Players 服务常驻, 不登记会在每次卸载/热重载后残留并逐次累积。
    T(game:GetService("Players").PlayerAdded:Connect(function() PlayerDirty=true task.defer(refreshPlayerNames) end))
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

-- ★★ v8.6.0 玩家名保护（用户实测：玩家名被翻译了，而且翻得不准）
--   为什么原来没挡住: 老逻辑只处理"**整条就是玩家名**"(isPlayerName 用在 shouldTranslate ③)。
--   可现实里名字几乎不会单独出现 ——
--     · 聊天:    "冬雪泽: 几率的哦"      (带 名字: 前缀)
--     · 头顶名牌: "NoobGamer123\n[Lv.5]"  (名字 + 别的行)
--     · 记分板:  "1. NoobGamer123"        (名次 + 名字)
--   这些整条都【不等于】任何名字 -> isPlayerName=false -> 整条被送出去翻 -> 名字被翻译/音译。
--   正确做法: 送翻译【之前】把已知玩家名换成占位符 〔n〕, 拿回译文【之后】再原样换回来。
--   用占位符而不是"整条跳过"的好处: 聊天内容照样翻, 只有名字本人不动。
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
                orig[i] = tok                      -- 记住原始大小写
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

-- (c) 动态文本识别: "每时每刻都在变"的文本(CPS/倒计时/金币/分数/打字中/滚动字幕)
--   以前每变一次 = 一次请求 + 一条缓存 —— 这是"缓存疯涨 / 越玩越卡 / 槽位永远占满"的头号来源。
--   判据是"同一个控件在短时间内多次变化", 不是"同一段文字出现多次" —— 所以静态短词
--   (Buy/Sell 出现在几十个不同标签上)不会被误判。归一化: 数字 -> #, 压空白, 转小写。
--   ⚠️ 与"绝不引入永久拉黑"的铁律不冲突: 跳过的是"本来每帧就在变、翻了也立刻过期"的文本;
--      判定表在【强制重扫】【清空缓存】时一并清掉, 用户随时能让它们再试。
local DynByObj=setmetatable({},{__mode="k"})   -- 控件 -> {last=,t=,n=,keys=}
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
    if e.last==text then return end        -- 没变 = 不是动态信号(静态标签每次扫描都会被看到)
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
    if Trans.DynN==0 then return false end    -- 快通道: 一个都没标记过 -> 零成本
    return Trans.Dyn[dynNorm(s)]==true
end
Trans.dynNorm=dynNorm Trans.dynMark=dynMark Trans.dynNote=dynNote Trans.dynIsBlocked=dynIsBlocked

-- (d) Self 保护网: "我们自己写进去的文本"(含中英对照的 "金币 (Coins)")
--   症状: 开了中英对照后, 写进去的文本会被自己的钩子再扫一遍, 混排分支把 " (Coins)" 当新文本
--         送去翻译 -> 写回 "金币(金币)", 原文被吃掉。
--   做法: ① 写控件【之前】就登记进来(属性写入会同步触发钩子); ② verdictOf 遇到就整条跳过。
--   两代结构: 满了一代降级保留一代, 不做整表丢弃(丢一次就等于重开这个 bug 的窗口)。
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

-- (e) 颜文字 / 保留词
Trans.IsEmoticon=function(v)
    if type(v)~="string" then return false end
    local t=v:lower():gsub("%s+","")
    if t=="" or #t>12 then return false end
    for w in EMOTICONS:gmatch("[^|]+") do if t==w then return true end end
    return false
end
Trans.KeepWords={}
for w in KEEPW:gmatch("[^|]+") do Trans.KeepWords[w]=true end

-- (f) 唯一一处"能不能翻"的判据 —— 全是"确实没有可翻内容"的情况
function Trans.shouldTranslate(s,isChat)
    if type(s)~="string" then return false end
    if alreadyOurs(s) then return false end                       -- ① 我们自己产出过的译文
    s=trim(s)
    if s=="" or #s<2 then return false end                        -- ② 空 / 太短
    if isPlayerName(s) then return false end                      -- ③ 整条是玩家名/ID
    if hasChinese(s) then return false end                        -- ④ 纯正中文
    if not hasForeign(s) then return false end                    -- ⑤ 没有外文
    if s:match("^https?://%S+$") or s:match("^www%.%S+$") then return false end  -- ⑥ 整条网址
    if not s:find("[%w]") and not hasKanaOrHangul(s) then return false end       -- ⑦ 纯符号/emoji(假名谚文不算)
    if Trans.IsEmoticon(s) then return false end                  -- ⑧ 颜文字/表情
    if Trans.KeepWords[s:lower()] then return false end           -- ⑨ 物品等级/稀有度分类词保留原样
    if not s:find("%a") then return false end                     -- ⑩ 纯数字/纯符号(没有可翻的内容)
    -- ★ v8.6.0 ⑪ 纯数值 + 量级后缀(18.5M / 1,234K / 3.4b) -> 不翻。
    --   ⑩ 挡不住它(带了一个字母 M), 于是这种"数值标签"会被送去翻译 ——
    --   结果要么把数值标签里的数字改坏, 要么跟原值叠加显示(用户看到的"重影")。
    if s:match("^[%d%s%.,:：]+[KkMmBbTtQq]?%s*$") then return false end
    if dynIsBlocked(s) then return false end                      -- ⑪ 动态文本(每帧在变)
    return true
end

-- (g) 判定缓存 + 混排识别
Trans.Verdict={}
local VerdictN=0
local function verdictOf(raw,isChat)
    local key=(isChat and "c" or "u")..raw
    local v=Trans.Verdict[key]
    if v then return v end
    v={}
    local plain=stripRich(raw)
    -- 整条就是我们自己写进去的(例如中英对照的 "金币 (Coins)") -> 立即 skip。
    --   缺这道闸, 混排分支会拿【片段】再翻一遍, 把原文吃掉。
    if Trans.isSelf(plain) then
        v.skip=true
        if VerdictN>=VERDICT_CAP then Trans.Verdict={} VerdictN=0 end
        Trans.Verdict[key]=v VerdictN=VerdictN+1
        return v
    end
    -- ★ v120.2 在原始串上切前缀(前缀里的标签原样保住); 正文(可含标签)整体交给富文本路径。
    --   core 里还有标签 -> v.tagged, processLabel 会走"标签保护"翻译(不再 stripRich 后硬替换 ——
    --   那对 <b>Buy</b> now / <font>Reward:</font><font>500 Coins</font> 这类被标签切开的文本是必败的)。
    local pre,core=splitPrefixRich(raw)
    local corePlain=stripRich(core)
    v.pre=pre v.core=core v.tagged=(core~=corePlain)
    if corePlain=="" then
        v.skip=true
    elseif hasChinese(corePlain) then
        -- 含汉字 -> 切分看有没有外文片段(混排); 没有才是纯中文(跳过)
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
        -- 有标签时不做本地短语表直替(短语表里没有标签, 直替会把标签弄丢)
        -- ⚠ 不要写 v.tagged and nil or X —— Lua 里 a and nil or b 恒等于 b, 是个假三元。
        if not v.tagged then v.loc=lookupLocal(corePlain) end
    end
    if VerdictN>=VERDICT_CAP then Trans.Verdict={} VerdictN=0 end
    Trans.Verdict[key]=v VerdictN=VerdictN+1
    return v
end
Trans.verdictOf=verdictOf

--============================================================
-- ⑤ 缓存层 —— 内存 + 原子写盘 + .bak 回退
--============================================================
local Cache={}
local MODEL_TAG="hymt2-7b-v70"      -- 换版本号 -> 启动时自动丢弃全部旧缓存
local CFG=SYS.N.Cache               -- 中性文件名(反指纹; 原 TransCache.json)
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
        -- 原子写: 先写 .tmp 再改名(避免写一半断电留下半个 JSON)
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

--============================================================
-- ⑥ 网络层 —— 掩码 → 请求 → 质量门; 失败退避 / 全局闸门
--============================================================
-- 送模型前把"不该翻的东西"换成哨兵 〖n〗, 译文回来再回填 —— 解决 7B 模型把
-- {coins}/%d/[E]/$1,000/50%/#FF0000/<b>/**code** 误译或破坏的问题。
-- ⚠️ 顺序敏感: 长模式在前, 短模式在后, 别乱调。
-- ★★ v120.2 哨兵字符换血: ▮n▮ -> 〖n〗
--   实测(2026-09-21, 15 组真实形态样本 × 本地 Hy-MT2-7B):
--     ▮n▮ 只有 9/15 原样回来(尤其 "Reward:" 打头的句子, 模型会把 ▮1▮ 改写成 ▲1▲,
--     数字保住了、哨兵法却变了 -> unmask 认不出来 -> 标签/货币被吞, 译文里 `<font>` 直接消失);
--     〖n〗(U+3016/3017 粗括号) 13/15, 是候选里最稳的; 加强提示词【无效】(实测无提升)。
--   ⚠ 为什么不能用 〔n〕: 那是玩家名保护(NAME_SLOT_L/R)已占用的字符, 会互相撞车。
--   ⚠ 译文里标签的"顺序"会变(模型把标签跟着它包的词走) —— 所以校验只比"计数是否一致",
--     绝不做"顺序一致"的强校验(那会把正确译文判成错的)。
local SENT_L,SENT_R="〖","〗"
local function maskSpecials(s)
    if type(s)~="string" or s=="" then return s,{},0 end
    local tok={} local n=0
    local function prot(pat)
        s=s:gsub(pat,function(m) n=n+1 tok[n]=m return SENT_L..n..SENT_R end)
    end
    prot("{{[^{}]-}}")               -- {{token}}
    prot("{[^{}]-}")                 -- {coins} {0} {player}
    prot("%%[-+0-9%.]*[sdifgxXoc]")  -- %d %s %2.1f %-3d %1$s
    prot("%%%w+%%")                  -- %WORD%
    prot("</?[%a!][^>]*>")           -- <b> </font> <font ..> <Key> <!x>
    prot("%[%/?%w+[^%]]*%]")         -- BBCode [b] [/b] [color=red] [size=5] [player]
    prot("%[%*%]")                   -- [*] Markdown 列表项
    prot("`[^`]+`")                  -- `code`
    prot("%*%*[^%*]+%*%*")           -- **bold**
    prot("%$%w+%$")                  -- $WORD$
    prot("%$%s*[%d%.,]+")            -- $1,000 / $ 1,000 货币($在前)
    prot("[%d%.,]+%s*%$")            -- 1,500 $ / 1500$ 货币($在后; 实测 Hunyuan-MT 会把孤立的 $ 翻成"美元")
    prot("#%x%x%x%x%x%x")            -- #FF0000 颜色
    prot("[@#&!]%w+")                -- @player #player &player !player
    prot("%d+%.?%d*%%")              -- 50% 12.5%
    prot("%d+%.?%d*[eE][+-]?%d+")    -- 科学计数法 1e11 / 1.5e10
    prot("%d+%.?%d*[QSODNVT]%l")     -- 双字母单位 1Qa/1Qi/1Sx/1Sp/1Oc/1No/1Dc/1Vg
    prot("%d+%.?%d*[KMBT]")          -- 单字母单位 1K/10M/1.5B/2T
    -- 组合单位能到 3~4 个字母(1UDc / 1QaDc / 1TgDc); 要求首字母大写, 所以 2nd/3rd 不会被误掩码
    prot("%d+%.?%d*%u%l?%u?%l?%u?%l?")
    prot("\\.")                      -- \n \t \\ \" \u 转义
    return s,tok,n
end
Trans.maskSpecials=maskSpecials
local function unmask(s,tok,n)
    if type(s)~="string" then return s end
    if tok and n and n>0 then
        s=s:gsub(SENT_L.."%s*(%d+)%s*"..SENT_R,function(d) local i=tonumber(d) return (i and tok[i]) or "" end)
    end
    -- 模型只丢了一侧哨兵时上面排不上 -> 会漏出一个孤立编号; 这两条把它清掉
    s=s:gsub(SENT_L.."%s*%d+",""):gsub("%d+%s*"..SENT_R,"")
    -- 剩下的哨兵字符只能是"配不成对"的残片 -> 逐字符清掉
    --   ⚠ 不要用 [^〖〗] 这种含多字节字符的字符类: Lua 模式按【字节】匹配, 多字节字符类会切坏 UTF-8。
    s=s:gsub(SENT_L,""):gsub(SENT_R,"")
    return s
end
Trans.unmask=unmask

-- 哨兵完整性: 送出去的 n 个哨兵, 是不是【每个都恰好原样回来一次】。
--   为什么要这道闸: maskSpecials 保护的是 {coins}/$1,000/50%/<b> 这些"绝不能动"的东西。
--   模型偶尔会吞掉或改写某个哨兵 -> unmask 认不出来 -> 那件东西就在译文里凭空消失
--   (实测: `<font>` 被吞 -> 译文丢了颜色; `1,500 $` 被吞 -> 金额不见了)。
--   宁可这条"不翻"(退避后重试), 也绝不写一个把标签/金额弄没的译文进去。
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

-- 失败退避(不是永久拉黑): 同一条失败后进入指数冷却 3s→6→12→…→300s 封顶,
--   冷却期内直接跳过(不改变任何翻译结果), 到点自动重试。
--   没有它时: 服务器离线 -> 0.5s 一轮的界面扫描会每秒重发几百次必然失败的请求。
--   ⚠️ "某些文本整局永不翻译"是另一个毛病, 绝不能引入。
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
        -- 只清"冷却已过"的, 保住仍在退避中的(否则等于把退避一起清没)
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

-- 服务器整体不可用时的全局闸门: 连续 3 次传输失败 -> 全体暂停 4 秒, 自动恢复(不是关掉功能)
local NetStreak,NetGateUntil=0,0
local function netGateOn() return os.clock()<NetGateUntil end
-- ★ v120.2 「本地服务没开」提示: 触到全局闸门 = 连着 3 次连不上本机 8080 = 模型没跑起来。
--   给出【明确可执行】的提示(而不是让用户对着"翻译不生效"发呆), 90s 内只提示一次(防刷屏)。
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

-- 当前翻译后端(v120.2 起只有本机 llama.cpp 一个):
--   返回 url, key, model, maxTok(输出上限, 跟随 /props 的每槽上下文), samp(采样参数)。
local function backend()
    return HOST,KEY,MODEL,(Trans.maxTok or MAX_TOK_FALLBACK),{temperature=SAMP_TEMP,top_p=SAMP_TOP_P,top_k=SAMP_TOP_K,repeat_penalty=SAMP_REP_PEN}
end

-- 自适应并发的取样窗口: 每次请求的真实耗时都记进来, adaptTick() 每 5s 结算一次(见 ⑧)
local function noteLat(dt)
    Trans._adL=(Trans._adL or 0)+dt
    Trans._adN=(Trans._adN or 0)+1
end

-- 返回: 译文, 传输失败?, 哨兵丢失?
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
        -- 「翻译后发送」是独立功能, 不该把界面翻译一起停 -> noGate 时不计全局闸门
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
    -- ★ 先校验哨兵(在 unmask 之前看原始输出): 有哨兵被吞/被改写 -> 报 lossy, 由上层决定
    --   (普通文本: 宁可不翻; 富文本: 退到"逐段翻译"这条更稳的路)
    local lossy=not sentinelsOk(v,tokN)
    v=trim(unmask(v,tok,tokN))
    if v=="" then return nil,false,false end
    return v,false,lossy
end

-- 质量门: 只挡真正没用的输出(空 / 原样返回 / 模型把说明吐出来 / 长度离谱)
local function tidy(res,src)
    res=trim(stripRich(res))
    if res=="" then return nil end
    -- 模型把说明文字一起吐出来(Translation: / 翻译： / Here is ...)
    res=res:gsub("^%s*[Tt]ranslation%s*[:：]%s*","")
    res=res:gsub("^%s*[Hh]ere is[^\n:：]*[:：]%s*","")
    res=res:gsub("^%s*(翻译|译文|中文|汉化)%s*[:：]%s*","")
    res=trim(res)
    if res=="" then return nil end
    -- 只把大小写改了(Coins -> coins) = 没翻
    if not hasChinese(src) and res:lower()==src:lower() then return nil end
    -- 长度离谱(# 是字节: 中文 1 字 3 字节, 正常译文通常比源短)。保守取值, 宁漏判不误杀。
    if #src>=24 and #res>#src*3+60 then return nil end
    return res
end

--------------------------------------------------------------
-- ⑥b 富文本(带标签文本)支持 —— ★ v120.2 新增
--   背景(用户实测): `<b>Buy</b> now` 这类"被标签切开的文本"整条【翻不动】,
--   因为老路径是 stripRich() 拿到纯文本 -> 翻好 -> 再 plainReplace(cur,plain,tr) 塞回原串;
--   可 plain 已不是 cur 的连续子串("Buy now" 在 "<b>Buy</b> now" 里被 </b> 断开) ->
--   plainReplace 原地返回 -> 不翻。多段文本 `<font>Reward: </font><font>500 Coins</font>` 同理。
--   现在的做法(两条路):
--     ① 把【原始串】整条送模型, 标签交给 maskSpecials 变成哨兵 〖n〗 保护, 回来 unmask 还原 ——
--        一次请求搞定, 且标签位置由哨兵精确复位(不再需要"连续子串"这个前提);
--     ② 万一哨兵没保住(模型吞了/改了) -> 退到"逐段翻译": 把标签之间的纯文本段分别翻译、
--        原位置拼回。慢一点但绝不会把标签弄丢。
--   ⚠ 标签完整性只比【计数】(不比顺序): 实测模型会把标签跟着它包的词一起挪位, 顺序变了
--     但译文是对的 —— 用顺序做判据会误杀正确译文。
--------------------------------------------------------------
Trans.RichCache={}          -- 富文本正文(含标签) -> 译好的正文(含标签)
local RichN=0
local RICH_CAP=4000
local function storeRich(core,val)
    Trans.RichCache[core]=val
    RichN=RichN+1
    if RichN>RICH_CAP then Trans.RichCache={} RichN=0 end
end
function Trans.clearRichCache() Trans.RichCache={} RichN=0 end

-- 标签名计数表(<font>, </font>, <b>, <color=..> 只取名字, 属性改了不算差异)
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

-- 标签是否"配得上对"(同名开闭嵌套合法): 计数一致还不够 —— 模型若把 </b> 挪到 <b> 前面,
--   计数仍然对得上, 但渲染出来就是坏的(文字属性错乱/标签露字)。所以再加一道配平检查。
--   注意: 只查"同名开闭"的配平, 不查跨标签嵌套顺序 —— 实测模型会把【整对标签】跟着它包的词搬走,
--   那种搬动是正确行为, 用严格的整串顺序判据会误杀(见 ⑥b 头注)。
local function tagsBalanced(s)
    if type(s)~="string" then return false end
    local stack={}
    for tag in s:gmatch("<[^>]*>") do
        local nm=tag:match("^</?%s*([%a!][%w%-_:]*)")
        if nm then                          -- 取不到名字的 "< 50 >" 之类不算标签, 直接跳过
            nm=nm:lower()
            if tag:match("^</") then
                if stack[#stack]~=nm then return false end    -- 闭标签对不上最近的开标签
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

-- 富文本专用质量门: 与 tidy 同规则, 但【不 stripRich】—— 标签必须留着, 否则等于白护
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

-- 取"标签之间的纯文本段"在串里的位置(标签本身原样不动)
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

-- 逐段翻译: 只翻"确实该翻的"纯文本段(汉字段与纯符号段自动跳过), 原位置拼回
local function translateRuns(s)
    local runs=textRuns(s)
    if #runs==0 then return nil end
    local out=s
    local changed=false
    for i=#runs,1,-1 do                       -- 从后往前替换, 下标不会因前面的替换而失效
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

--============================================================
-- ⑦ 翻译层
--============================================================
local function transPrompt() return SYS_PROMPT end
function Trans.promptFor(code)
    local name=Trans.LANG_PROMPT[code] or Trans.langName(code)
    return ("Translate the following game UI text into %s.\n"
        .."Output ONLY the translation: no explanation, no quotes, no extra words, no added punctuation.\n"
        .."Preserve the original line breaks and the original number of lines.\n"
        .."Some characters in the input are opaque placeholder markers, not words. Copy every non-word marker character exactly as it appears, in its original position, together with the digits attached to it. Never translate, drop, replace, renumber, merge or reorder them.\n"
        .."Keep numbers, currency ($), emoji, URLs, placeholders and player names unchanged."):format(name)
end

-- 英 -> 中(界面 / 聊天主路径)
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
    -- 冷却 / 全局闸门内直接返回 —— 不改任何结果, 只是不再每轮重发同一条必败请求
    if inCool(nk) or netGateOn() then return nil end
    local t0=os.clock()
    -- 输出上限跟随服务器每槽上下文(Trans.maxTok, 见 probeServer)。
    --   以前这里硬编码 1024, 而每槽往往只有 512 -> 长段落被服务端静默截断(finish_reason=length)。
    local res,netFail,lossy=rawRequest(text,transPrompt(),0.1,Trans.maxTok or MAX_TOK_FALLBACK)
    -- lossy: 有哨兵被模型吞掉/改写(例如 {coins} 或 $1,000 会凭空消失) -> 这条不采用,
    --   退避后重试。宁可这一条不翻, 也不写一个把金额/占位符弄没的译文进去。
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
    markFail(nk)              -- 翻不出来就退避(3s 起, 指数到 300s 封顶, 到点自动重试)
    if not netFail then Trans.Stats.fail=Trans.Stats.fail+1 end
    return nil
end

-- 中 -> 外(供「翻译后发送」用); 独立缓存避免与英->中缓存冲突
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
    -- 这条路径用独立的失败键退避, 并让 rawRequest 不计数全局闸门(见 noGate)
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

--============================================================
-- ⑧ 并发池 —— 真并发工作池
--   以前只做"同文本去重", 不同文本会无限并发 -> 开界面瞬间上百个阻塞式 HTTP 一起打向本地
--   7B(16~32 槽), 超出的全部排队/超时, 用户看到"翻译慢 / 整屏卡住"。
--   现在: 在途数到达上限就把任务【排队】(绝不丢弃), 每完成一个就补一个。
--   上限取自 /props 的 total_slots(见 probeServer), 默认保守 8。
--============================================================
Trans.MaxConc=8
Trans.InflightN=0
Trans.WaitN=0
local Inflight={}      -- key -> 回调数组(在途)
local WaitQ={}         -- key -> {fn=,prio=,cbs={}}(排队; fn 是"这一格要跑什么")
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
    for kk,ww in pairs(WaitQ) do k,w=kk,ww break end   -- prio 只影响语义, 不影响出队顺序
    if not k then return end
    WaitQ[k]=nil Trans.WaitN=Trans.WaitN-1
    runJob(k,w.fn,w.cbs)
    if Trans.WaitN>0 and Trans.InflightN<Trans.MaxConc then Trans.pumpQueue() end
end

-- ★ v120.2 自适应并发(提速): 每 5s 结算一次"真实请求耗时"窗口。
--   平均 >1.5s 说明在排队/抢槽位 -> 并发 -1; 平均 <0.45s 说明还有余量 -> 并发 +1。
--   为什么值得做: 并发上限写死成槽位数时 —— 用户一边玩一边翻(游戏本身在吃 CPU/显存),
--   每条都变慢、全部挤在一起; 压到"这台机器实际吃得下"的并发, 总吞吐反而更高。
--   空载时又能自动放开, 不会白白空着槽位。上下界 [1, MaxConcCap]。
function Trans.adaptTick()
    local now=os.clock()
    local t=Trans._adT
    if not t then Trans._adT=now Trans._adL=0 Trans._adN=0 return end
    if now-t<5 then return end
    local n=Trans._adN or 0
    local l=Trans._adL or 0
    Trans._adT=now Trans._adL=0 Trans._adN=0
    if n<4 then return end                        -- 样本太少不调, 免得被冷启动那几条带偏
    local avg=l/n
    local cap=Trans.MaxConcCap or Trans.MaxConc or 8
    local minc=Trans.MinConc or 1
    -- ★★ 阈值按本机实测标定(2026-09-21 · 16 槽 × 每槽 1024 ctx · 生产提示词 1190 字符):
    --     K=1  墙钟 0.05s  19.0 条/s      K=12 墙钟 0.62s  19.4 条/s
    --     K=14 墙钟 0.63s  **22.0 条/s(峰值)**  单条均 0.39s / p50 0.45s
    --     K=16 墙钟 0.78s  20.5 条/s(回落)       K=20 墙钟 0.93s  21.6 条/s
    --   ⇒ 甜点在 slots-2, 所以 MaxConcCap=slots-2; 再往上只是排队+尾延迟变差。
    --   ⚠ "回升阈值"必须明显高于稳态均耗时(0.39s): 原来取 0.45s, 就在稳态值边上,
    --     一旦抖动到 0.5s 就再也回不到上限了 -> 现在取 0.6s。
    --   ⚠ "降档阈值"取 1.2s: 只有明显劣化(机器被游戏占满/显存被挤)才砍并发, 正常波动不动它。
    --   0.6~1.2 之间是死区(不动), 避免贴着阈值来回抖。
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
    -- ★★ v8.6.0 玩家名保护(用户实测: 名字被翻译且不准):
    --   在【唯一的请求出口】这里统一遮罩 —— 聊天/界面/混排片段全部经过这里,
    --   所以只改一处就能覆盖所有路径。占位符参与缓存键, 所以"换个名字同一句话"也能命中缓存。
    do
        local masked, restore, didMask = protectNames(text)
        if didMask then
            text = masked
            local ocb = cb
            cb = ocb and function(res)
                local fixed = restore(res)
                -- 占位符没被模型保住(它可能把 〔1〕 改写/吞掉) -> 宁可不翻,
                --   也绝不能把名字弄丢或弄错 —— 名字错了比不翻更糟。
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
    local q=Inflight[nk]                 -- 在途: 挂回调
    if q then
        if cb then q[#q+1]=cb end
        return
    end
    local w=WaitQ[nk]                    -- 已排队: 挂回调, 不重复入队
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

-- ★ v120.2 富文本(正文含标签)请求出口 —— 与 Trans.request 共用同一个并发池
--   (另开一条不受限的路会把 7B 的槽位瞬间打爆, 那正是"翻译慢/整屏卡住"的老毛病)
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

-- 富文本正文的翻译本体: ① 整条带标签送模型(标签被哨兵保护) -> ② 标签计数不一致才退到逐段翻译
function Trans.translateRichCore(core,isMixed)
    if Trans.Unloaded or type(core)~="string" or core=="" then return nil end
    local rk="\2R\2"..normalizeKey(core)
    if inCool(rk) or netGateOn() then return nil end
    if not isMixed then
        local res,netFail,lossy=rawRequest(core,transPrompt(),0.1,Trans.maxTok or MAX_TOK_FALLBACK)
        if res and not lossy then
            local v=tidyRich(res,core)
            -- 标签计数一致(= 一个都没丢) 且 开闭配平(= 没被挪成坏结构) 才采用
            if v and tagNamesEq(core,v) and tagsBalanced(v) then
                storeRich(core,v) clearFail(rk) markOutput(v)
                return v
            end
        end
        if netFail then
            -- 服务不可达 -> 别再退到逐段那路白打一通必然失败的请求
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

--============================================================
-- ⑨ 落字层 —— 写回控件 + 记录原文(按文本, 不按对象)
--============================================================
Trans.Trans2Orig={}     -- 译文(纯文本) -> 原文(纯文本)
Trans.Orig2Trans={}     -- 原文(纯文本) -> 译文(纯文本)
--    （配套计数器 T2O_N 已上移到 T2O_CAP 旁边, 别再这里重复声明 —— 见那里的说明）

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
    -- ⚠️ 技能 §4.7 铁律: 属性写入会【同步】触发 GetPropertyChangedSignal("Text"),
    --    所以必须"先标记再写" —— 否则钩子回来时保护网里还没有这条, 就会把自己的译文再翻一遍。
    Trans.markSelf(newText)
    local np=stripRich(newText)
    Trans.markSelf(np)
    local _,ncore=splitPrefix(np)
    if ncore~="" then Trans.markSelf(stripRich(ncore)) end
    local ok=pcall(function() obj[field]=newText end)
    if ok then
        Trans.Stats.replaced=Trans.Stats.replaced+1
        -- 引擎可能立刻回写 -> 复查
        -- ★★ v8.6.0 修「翻译重影」(用户实测: 原文和译文叠在一起显示):
        --   机制: 我们写进译文后, 游戏在下一帧把【原文】又写回来 ——
        --   屏幕上就同时留着原文和译文 = 重影。
        --   原来只盯到 0.25s(两次), 回写稍慢就漏掉, 原文就一直留在那儿。
        --   现在盯到 1.2s(四次), 并且: 如果游戏写成了【第三个】值(既不是原文也不是我们的译文),
        --   把现场打出来一次 —— 那正是重影的典型来源, 便于定位。
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

-- 混排片段翻译: 中文原样保留, 只翻外文片段, 全部到齐后一次性回填成全中文
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
--   ⚠️ 不做缓存: 每轮只多 4 次属性读, 比后面的字符串处理便宜; 缓存反而会在"换父级"后失真。
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

-- 游戏会自己把 Text 写回原文 -> 给游戏自己的文本控件挂变更钩子, 一改就重翻
--   (连接经 T() 登记; 节流 0.1s + 重试 ≤5 次; 弱键表: 控件销毁自动出表)
local TextHooked=setmetatable({},{__mode="k"})
local TextRetry=setmetatable({},{__mode="k"})
local TextLastAt=setmetatable({},{__mode="k"})
local TextHookedN=0

local function onTextChanged(obj)
    if Trans.Unloaded or not Trans.UIScanActive then return end
    local okc,c0=pcall(function() return obj.Text end)
    if okc and Trans.isSelf(c0) then return end    -- 我们自己刚写进去的, 直接放过
    local now=os.clock()
    local last=TextLastAt[obj]
    if last and now-last<RETRY_GAP then return end        -- 节流
    TextLastAt[obj]=now
    local n=(TextRetry[obj] or 0)+1
    TextRetry[obj]=n
    if n>RETRY_MAX then return end                        -- 重试上限: 超过不再纠缠
    task.defer(function()
        if Trans.Unloaded or not Trans.UIScanActive then return end
        P(Trans.processLabel,obj,"ui")
    end)
end

function Trans.HookText(obj)
    if not obj then return false end
    if TextHooked[obj] then return true end
    if TextHookedN>=HOOK_MAX then return false end
    -- 首次扫描会一次遇到上千个文本控件, 全挂监听有明显突发 -> 限速: 每秒最多新挂 40 个
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

-- 中英对照: 显示成 "译文 (原文)"; 关掉就是整段替换
--   ⚠ 开了之后同一段文字会变长, 尺寸写死的按钮/标签可能显示不全 —— 那就关掉这个开关。
local function biText(plain,hit)
    if not SYS.T_.TransBilingual then return hit end
    if (not plain) or plain=="" or plain==hit then return hit end
    return tostring(hit).." ("..tostring(plain)..")"
end

-- ★ v120.2 富文本控件写回: 正文("带标签的译好正文", 标签由哨兵机制原样还原) + 原样前缀 = 整串写回。
--   注意这里【不再用 plainReplace】—— 被标签切开的文本在原文里根本不是连续子串, 替换必失败;
--   改成"前缀..译文"直接拼接, 既绕开连续性子串的前提, 也不会动到前缀里的标签。
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

-- 处理一个 TextLabel / TextButton
function Trans.processLabel(obj,source)
    if not obj or not obj.Parent or Trans.Unloaded then return end
    if Trans.isIgnored(obj) then return end        -- 忽略控件表(自己 + 3 层父级)
    local ok,cur=pcall(function() return obj.Text end)
    if not ok or type(cur)~="string" or cur=="" then return end
    Trans.dynNote(obj,cur)                         -- 观察这个控件变过几次(动态文本识别)
    local isChat=(source=="chat")
    local v=verdictOf(cur,isChat)
    if v.skip then return end
    -- ★ 带标签的正文优先走富文本路径(含"带标签的混排"—— 那条走逐段翻译, 汉字段自动保留)
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

-- ProximityPrompt(它没有 .Text, 只有 ActionText / ObjectText)
Trans.PromptFields=PROMPT_FIELDS
local PromptHooked=setmetatable({},{__mode="k"})   -- 本代次私有 + 弱键(对象销毁自动出表, 不积压)
local function processPrompt(p)
    if not p or not p.Parent or Trans.Unloaded or not Trans.UIScanActive then return end
    if Trans.isIgnored(p) then return end          -- 忽略控件表(自己 + 3 层父级)
    -- 游戏会在鼠标靠近时把 ActionText 改回原文 -> 挂钩子, 被改回就立刻再翻
    --   (钩子里再进来必然缓存命中 -> writeProp(cur~=raw) 返回 false -> 不会死循环)
    if not PromptHooked[p] then
        pcall(function()
            -- 两条都挂上才置位: 某次 Connect 抛错(执行器事件缺失/实例正在销毁)不能记成"已钩"却没连接,
            --   否则之后永不重试 = 静默失效。
            local okA,ca=pcall(function() return p:GetPropertyChangedSignal("ActionText"):Connect(function() task.defer(processPrompt,p) end) end)
            local okB,cb2=pcall(function() return p:GetPropertyChangedSignal("ObjectText"):Connect(function() task.defer(processPrompt,p) end) end)
            -- 两条都要登记: 世界里的 prompt 不随卸载销毁, 不登记就会残留
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

--============================================================
-- ⑩ 驱动层 —— 扫描(界面·3D·Prompt) / 聊天 / 还原原文
--============================================================
-- 一次祖先遍历同时判两件事(旧实现两次遍历, 每个文本对象每轮最多 22 次父级跳转):
--   · 自己的界面: 10 层以内到 SYS.ScreenGui
--   · 官方顶栏:   12 层以内祖先名字含 topbar
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
                P(Trans.HookText,o)          -- 挂变更钩子(游戏写回原文时立刻重翻)
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
    Trans.clearAllFails()      -- 用户要求"全都再试一次" -> 连带清空全部失败冷却
    -- 动态文本判定也一并清掉 —— 强制重扫就是"全都再试一次", 不能因为之前判过动态就永远不给机会
    --   (那是"永久拉黑", 铁律禁止)。
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
            task.wait(SCAN_GAP)
            if Trans.UIScanActive then
                pcall(Trans.adaptTick)      -- ★ 自适应并发: 每 5s 按真实耗时窗口微调 MaxConc
                local before=Trans.Stats.hit+Trans.Stats.replaced
                local n=0
                n=scanRoot(SYS.PG,n)
                if SYS.CoreGui then n=scanRoot(SYS.CoreGui,n) end
                pcall(function() if gethui then n=scanRoot(gethui(),n) end end)
                if n==0 and before==Trans.Stats.hit+Trans.Stats.replaced then
                    Trans.Stats.sweepSkip=Trans.Stats.sweepSkip+1
                    task.wait(SCAN_IDLE)
                end
                -- 世界 3D 每 N 轮扫一次(整套 Workspace 遍历; 别每轮都跑)
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

-- 聊天
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
                    -- 译完立即重扫, 气泡马上变中文(不再等 1 秒)
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

-- 还原原文(按文本反查, 不依赖控件生命周期 —— 控件会被引擎销毁重建)
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

--============================================================
-- ⑪ 诊断层 —— 失败/动态可观测 + 探测 + 发送 + 卸载 + 初始化
--============================================================
-- 失败侧可观测: 以前只有 dumpPairs 打成功, 用户完全看不出"这条为什么没翻"。
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

-- ★ v120.2 槽位预热(提速): 真翻译的第一个请求最贵 —— 它要把整个 system 提示词(约 340 token)
--   从头 prefill 一遍, 冷启动那条实测 0.23s(p50 而后只需 0.05s)。这里在探测完槽位后,
--   用 max_tokens=1 的空请求把提示词前缀先喂进每槽的 KV 前缀缓存 —— 用户按下列的第一次翻译
--   就直接命中缓存, 不再有"第一屏卡一下"。后台低优先, 失败无所谓(不影响任何翻译结果)。
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
    Trans.offlineHint(false)     -- 明确告诉用户"双击翻译模型开关.bat"(90s 内只提示一次)
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
    -- 输出上限跟随"每槽上下文"(system 提示词约 340 token + 输入 + 输出 都要装进每槽):
    --   实测每槽 512 + 615 字符长文本 -> finish_reason=length(被服务端静默截断);
    --        每槽 1024 -> finish_reason=stop(正常翻完)。
    Trans.SlotCtx=ctx
    Trans.Slots=slots
    Trans.maxTok=math.max(128,math.min(512,ctx-512))
    -- ★ 在途上限 = 服务器真实槽位数 - 2(留 2 个余量给"手动强制全屏扫描"那种突发)。
    --   实测依据见 ⑧ adaptTick: 吞吐在 slots-2 处达峰, 用满反而更慢。
    --   上限天花板 32: 以前写死 16, 意味着"用户把 -np 开到 24/32 也用不上" —— 现在跟着服务器走。
    local reserve=(slots>=4) and 2 or 1
    Trans.MaxConcCap=math.max(1,math.min(32,slots-reserve))
    Trans.MaxConc=Trans.MaxConcCap
    Trans.MinConc=1
    print(("[Trans] 服务器: %d 槽 × 每槽 %d ctx  ->  并发区间 %d~%d(当前 %d), 单次输出上限 %d token")
        :format(slots,ctx,Trans.MinConc,Trans.MaxConcCap,Trans.MaxConc,Trans.maxTok))
    Trans.warmSlots()            -- 预热 system 提示词前缀 -> 首屏翻译不用等 prefill
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
        -- 中 -> 外(反向翻译)。以前这里方向写反成"英译中", 已修。
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
    -- ★★★ v6.8.2 性能修复(用户报「手机版要等很长时间, 触摸移动才跟手」):
    --   原来【每个滑块实例】各自挂一条 UIS.InputChanged + 一条 UIS.InputEnded --
    --   全脚本 42 个滑块 = 42 条常驻回调, 手机上手指每次移动会【同时触发全部 42 条】,
    --   触摸响应被这 42 次跨 VM 调用拖慢(桌面端鼠标事件频率低 + CPU 强, 所以一直没暴露)。
    --   改成【全局各只挂一条】+ 一个"当前正在拖的滑块"指针: 42 -> 1, 其余全部空跑返回。
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
            SYS._SlActive=proc           -- 登记: 共享的那条 InputChanged 认这个
            SYS._SlRelease=function()    -- 松手收尾(还原 knob)
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
        -- ★ v6.9.2 修「下拉浮层不跟着菜单缩放」: 浮层挂在 ScreenGui 下(菜单的 UIScale 管不到它),
        --   位置本来用的是【屏幕像素】(已含缩放) 所以是对的, 但尺寸和字都是【原始大小】——
        --   菜单放大到 1.75(手机)时浮层显得特别小、缩到 0.75 时又撑得特别大, 看着像两个界面。
        --   修法: 给浮层自己也挂一个 UIScale(= 菜单当前缩放), 并把 Position/Size/CanvasSize
        --   先除回"缩放前"的数值 —— 乘回来之后正好等于原来的屏幕像素, 位置不变、大小跟着走。
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
        -- ★ v68.8 修"下拉浮层残留": 同屏只留一个浮层 + 记录引用, 切页/关菜单时统一关闭
        if SYS.CloseActiveDropdown and SYS.CloseActiveDropdown~=close then
            pcall(SYS.CloseActiveDropdown)
        end
        SYS.CloseActiveDropdown=close
    end))
    return btn
end

-- [13.5] 游戏内通知 (自己实现的通知条, 不依赖任何 UI 库 —— 早期参考过 WindUI 的交互, 代码已全部重写)
--   所有"print"反馈在游戏里看不到(要开执行器控制台), 补一个右上角通知 toast:
--   3 秒自动消失、多条向下堆叠、自动上移/回落。
--============================================================
do
    local NotifyList={}
    function SYS.Notify(text,col)
        local sg=SYS.ScreenGui
        -- ★★★ v9.9.8 用户原话:「全部 lua 里面的推送信息全部都要能做到关闭 ui 菜单还能进行推送」。
        --   旧实现第一行就是 `if not sg or not sg.Parent then return end` —— 菜单一关(ScreenGui 被
        --   禁用/移除)【整条推送直接 return, 什么都不显示】, 用户什么都看不到。
        --   现在: 菜单不可见时【改走 HUD】——SYS.Hud 本来就是"独立于菜单、关掉 UI 也看得见"的那套。
        --   判据: ScreenGui 存在 + 没被 Enabled=false 关掉 + SYS.MenuOpen 为真。三者任一不满足就走 HUD。
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

--============================================================
--============================================================
-- [12B] v6.7.0 ChronixHub 融合模块（逻辑层 · 全部可逆 · 只写本客户端）
--   滤镜控制器(★v9.9.0删) / 光照档位包 / 音频控制器+检查器 / 聊天接收器 / 多路径点(★v9.9.0删, 只留移动助手) /
--   自杀与角色状态(防死亡·防击倒 并入上帝模式) / 瞄准补强 + 白黑名单 /
--   静默瞄准·子弹穿墙·阻挡射线(默认关) / 防护(反作弊绕过·管理员检测·防踢出) /
--   玩家控制(动手类) / 整蛊工具(★v9.9.0整块删) / 工具增删
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

    -- ★ v6.9.0 整合: 单一档位(互斥) + 独立叠加开关。旧 key 会自动迁移(见 MigrateLightMode)。
    SYS.LIGHT_MODES={"关闭","夜视","超级光明","全亮"}
    function SYS.MigrateLightMode()
        -- 老配置里可能是 FullBright / NightVision / NightVisionPro / SuperLight 各自为 true
        if SYS.C_.LightMode==nil or SYS.C_.LightMode=="" then
            if SYS.T_.FullBright then SYS.C_.LightMode="全亮"
            elseif SYS.T_.SuperLight or SYS.T_.NightVisionPro then SYS.C_.LightMode="超级光明"
            elseif SYS.T_.NightVision then SYS.C_.LightMode="夜视"
            else SYS.C_.LightMode="关闭" end
        end
        -- 同步成"档位互斥"的开关状态(旧的几个 T_ 由档位统一表达, 不再各自为政)
        local m=SYS.C_.LightMode
        SYS.T_.FullBright=(m=="全亮")
        SYS.T_.SuperLight=(m=="超级光明")
        SYS.T_.NightVisionPro=false
        SYS.T_.NightVision=(m=="夜视")
        return m
    end
    -- ★ v6.9.0 光照守护 tick: 低频(0.4s)检查关键属性有没有被游戏改回去, 改了就用
    --   轻量方式写回(不整个重算, 避免和玩家的滑条操作打架)。只有档位非「关闭」时才被挂上。
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
            -- 灯笼本体丢了(换角色/被清)就补一根
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
                -- 原 SYS.SetFullBright 的行为: 提亮 + 关后期效果(景深/模糊/泛光/光晕/色偏)
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
            -- 「全亮」档本身就要关阴影; 平时由「禁用全局阴影」开关决定
            LT.GlobalShadows=not (ns or mode=="全亮")
            if nf or mode=="全亮" then
                LT.FogEnd=1e6 LT.FogStart=1e6
            else
                LT.FogEnd=O.FogEnd LT.FogColor=O.FogColor
                LT.FogStart=(ex.FS~=nil) and ex.FS or LT.FogStart
            end
        end)
        -- ★ v6.9.0 光照守护(实时监听): 原来只在操作开关那一刻应用一次, 游戏回头改一下
        --   Lighting 就把设置冲掉了(不少游戏每帧改) -> 用户感觉"开了没用/一闪一闪"。
        --   这里按"当前有没有生效中的设置"挂一条低频守护, 被改回就自动抢回来。
        local wantGuard=(SYS.C_.LightMode~="关闭" and SYS.C_.LightMode~=nil)
            or SYS.T_.NoFog==true or SYS.T_.NoShadow==true or SYS.T_.Lantern==true
        if wantGuard then
            SYS.SetLoop("LightGuard",true,RS.Heartbeat,SYS.LightGuardTick)
        else
            SYS.SetLoop("LightGuard",false)
        end
        -- 随身灯笼(挂在角色根部件上的 PointLight, 只在本地可见)
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


    --============================================================
    -- A6) 路径点移动助手 —— 只保留「缓动 / 步行」两个工具
    --   ★ v9.9.0 删除清理: 多路径点列表(Add/Remove/Mark/Unmark/RefreshMarks/Goto/Stop)
    --   整块删除 —— 「路径点」界面早已不在, 唯一入口是已删的 WPKey 分支(死键)。
    --   这里保留 WP.TweenTo / WP.WalkTo: 玩家控制的「缓动到他 / 寻路走到他」在调用。
    --============================================================
    local WP={} SYS.WP=WP

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

    -- ★★ 新增(2026-09-20, 参考公开脚本的 AntiFling): 防被甩飞
    --   被"甩飞"(fling)的机制: 别人用约束/焊接把自己身上的高速速度传染给你的角色,
    --   你的角色获得一个远超正常的 AssemblyLinearVelocity, 于是被弹上天/弹到地图外。
    --   它通常不掉血, 纯粹恶心你。做法: 每帧看自己的 AssemblyLinearVelocity, 超过阈值就清零。
    --   纯本地、只清自己的速度 —— 不改服务端判定, 也不碰正常移动。
    --   ★ 阈值 80 的取法: 正常跑步 16~30, 开了加速也就 30~60; 而甩飞往往是 300~4000。
    --     而且飞行/加速走的是约束(LinearVelocity/BodyVelocity), 不写 AssemblyLinearVelocity, 不会误伤。
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

    -- ★★ 9.8.0 按用户要求删除: 「原地重生 / 设置当前位置为重生点 / 恢复默认重生点」
    --   三个按钮及其全部实现(SpawnRec / SetSpawnHere / ClearSpawnHere / RespawnHere)。
    --   理由(用户原话): 没用 —— 重生位置由服务端决定时, 本地记账 RespawnLocation 无效;
    --   想要"原地满血"用「强制自杀(抹除)」后等游戏把你重生回来即可。
    --   ⚠ 顺带移除了 SYS.FuseClean(统一卸载)里的 ClearSpawnHere 调用, 否则会留下
    --     一个永远返回 nil 的悬空引用。注意与 [SYS.GetSpawnRec/SetSpawnRec] 区分:
    --     那是给传送系功能记"默认出生点"的另一套东西, 本次不动。

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
    -- A32) 瞄准补强闸门 —— ★ v9.9.0 整块删除(删除清理)
    --   原文: 「命中率 HitGate / 漏打 MissGate」两个闸门(靠 SYS.T_.CB_MissMode + C_.CB_MissRate)。
    --   事实: 战斗页早就写了"已移除「命中率 / 漏打模式」—— 不再有任何「故意打偏」",
    --         界面入口没了, 但 `SYS.AimEx` 这两个函数一直留着 —— 而它们**全文件没有任何调用点**。
    --   危害不在"打偏"(没人调), 而在【老存档能把它复活】: 旧配置里 CB_MissMode=true 会在
    --   热更新恢复开关状态时被写回 T_, 一旦将来谁再把它接回开火路径, 就变成"静默地打不准"。
    --   ⇒ 连键带函数一起删, 并把 CB_MissMode 记进 SYS.REMOVED_FEATURES 挡住复活。
    --   ★ 「锁定保持 / 粘性瞄准」用户早前明确要求删除, check.py 里带回归锁 -> 依旧不提供。
    --============================================================

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







    -- 隐藏自身 GUI(管理员/反作弊脚本常扫 PlayerGui/CoreGui 找外挂界面)
    -- ★★ v6.9.10 重写(用户实测: 开着「管理员检测绕过」极度卡顿掉帧 + 游戏交互异常)
    --   旧实现 hookmetamethod(game,"__namecall") —— 那是【所有实例方法调用的总入口】:
    --     · 游戏每个 obj:Method() 都要先过我们的回调(DOORS 每秒几百次) -> 帧率必崩;
    --     · 回调里还夹着 LP:FindFirstChildOfClass("PlayerGui") —— 等于每次调用都查一遍实例;
    --     · 最要命的是它【重写 WaitForChild / FindFirstChild 的返回值】-> 游戏自己拿不到东西,
    --       表现就是"点了没反应 / 界面不刷新"的交互异常。
    --   新做法: 一次 hook 都不装, 只做三件零开销的事 ——
    --     ① 过一遍 SafeParentGui(★ v7.7.0 更正注释: 现状是【固定挂 PlayerGui】——
    --        这是 v5.2.2 的定案, 起因是挂 CoreGui 时菜单位置会偏 58px; 位置正确 > 那点反检测收益);
    --     ② 中性名(反指纹, 建菜单时已从名字池随机挑, 见 SYS.N.Gui / SYS.N.Hud);
    --     ③ Archivable=false(不会被 GetDescendants + Clone 一类批量抓走);
    --     ④ ★ v7.7.0 新增: 装完立刻跑一次反指纹自检, 把"名字里带可疑词"的容器就地改成中性名。
    --   ⚠ 诚实边界: 对"逐帧遍历 PlayerGui/gethui 的检测"无效 —— 那种检测本来也拦不住,
    --   用 hook 去拦换来的是卡顿 + 游戏抽风, 得不偿失。要自查还有哪些破绽, 用「🔎 反指纹自检」。
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
        -- ★ v7.7.0: 顺手把名字里的可疑词擦掉(零开销, 只改几个字符串)。
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

    --============================================================
    -- ★★ v7.7.0 补强批次2 —— 反指纹自检与"就地擦除" (对应批次1 遗留缺口 G6/G7)
    --   概念来源(只抄思路, 实现全自写):
    --     · 公开执行器环境脚本(sUNC 能力清单 / Luau-ENV 元表挂钩)先把自己暴露了什么摊开看;
    --     · 公开透视/挂机脚本的"上线前自查"流程 —— 扫一遍自己的名字再收工。
    --   原则与 v6.9.10 一致: 【只做零开销的查询与改名, 绝不挂 __namecall / __index】。
    --   反作弊找外挂通常就看三样:
    --     ① 你的 GUI 名字/层级里有没有 cheat / hack / 外挂 这类词;
    --     ② 你的 ScreenGui 挂在哪个容器(PlayerGui 谁都能遍历 / CoreGui·gethui 权限更高);
    --     ③ 你的实例是不是 Archivable(能被 GetDescendants + Clone 批量打包抓走)。
    --   下面把这三项一次查清; ①②能就地修, ③由 InstallHideGui 处理。
    --============================================================
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

    -- 就地擦除: 只改"名字里真的带可疑词"的那几个容器, 中性名(名字池里挑的)一律不碰。
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

    -- 只读自检: 返回一段可打印的文本行(不改任何东西)。供「🔎 反指纹自检」按钮与统一扫描共用。
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
        -- 执行器指纹面(只报不删 —— 删全局会连带废掉脚本运行环境)
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


    --=========== 静默瞄准 / 子弹穿墙 / 阻挡射线 (默认关) ===========
    --   三者共用一条 Workspace 射线 hook:
    --     · 阻挡射线   = 让游戏自己的射线一律"打空"(返回 nil) —— 游戏用它做视线/检测时看不到任何东西
    --     · 静默瞄准   = 把游戏射线的命中点改写成当前锁定目标
    --     · 子弹穿墙   = 同上, 但不要求视线(隔墙也改写)
    -- ★★ v6.9.18: 先把【全局 Ray 构造器】抓下来 —— 下面 `local Ray={}` 会把全局 Ray 遮蔽掉,
    --   而改写射线返回值时必须能造出 RaycastResult.Ray 这个字段(很多枪械逻辑会读它)。
    local RayCtor=Ray
    local Ray={} SYS.RayHook=Ray
    Ray.Hooked=false Ray.Unhook=nil Ray.Rewrites=0

    --==========================================================================
    -- ★★ v9.9.0 修「静默瞄准准头不准」：改写出来的那份 RaycastResult 必须【处处自洽】。
    --
    --   旧实现有两个实打实的问题，表现出来就是"准头不准 / 打了像没打中"：
    --     ① 命中点直接用部位【中心】(tp.Position) —— 那是身体【里面】的一个点。
    --        枪械逻辑若拿它回推方向、或再拿它做一次校验射线，打中的正好是"身前那面墙"；
    --     ② Distance / Normal / Material / Ray 四个字段全部沿用【真实射线】(打到的是墙)。
    --        于是同一份结果里 **Instance = 敌人、Distance = 到墙的距离** —— 自相矛盾。
    --        读 Distance 做射程/伤害衰减、读 Normal 画弹孔、读 Ray 求方向的枪，拿到的全是墙上的值。
    --     ③ 附带: 旧代码把 `RayCtor.new(...)` 包在 P() 里 —— P 是【延迟执行】，
    --        所以返回那一刻 Ray 字段**永远是 nil**（注释写着"补上了"，其实没补）。现在同步构造。
    --
    --   修法（每步只用白名单射线打【目标角色自己】，很便宜；0.04s 内复用同一结果）：
    --     ① 先沿【原射线方向】打一次 —— 准星真对着人时，这就是最真实的那一点；
    --     ② 没中（静默时准星常不指着人，这是常态）→ 换成"从射线起点指向目标"再打一次；
    --     ③ 还不行 → 退回目标身上"看得见的那一点"(`SYS.Combat.HitPoint`) → 最后才是部位中心。
    --   四个字段(Position/Distance/Normal/Material)全部按这一个点重算 —— 不再有"敌人的壳、墙的芯"。
    --==========================================================================
    Ray.Busy=false                  -- 我们自己打白名单射线时置位，免得又被这个 hook 扭一次
    local HC={t=0,part=nil,pos=nil,nrm=nil}

    -- 只对指定角色打一条射线；打中返回 (位置, 法线)，否则 nil
    local function castChar(origin,dir,ch)
        if not ch or not (RayCtor and RayCtor.new) then return nil end
        if typeof(origin)~="Vector3" or typeof(dir)~="Vector3" or dir.Magnitude<0.001 then return nil end
        Ray.Busy=true
        local ok,p,n=pcall(function()
            local a,b,c=WS:FindPartOnRayWithWhitelist(RayCtor.new(origin,dir),{ch},false)
            if a then return b,c end
        end)
        Ray.Busy=false
        if ok and p then return p,n end
        return nil
    end

    -- 命中点 + 法线（传原始射线的起点/方向，可为 nil）
    local function hitOf(origin,rdir,tp)
        local now=os.clock()
        if HC.part~=tp or (now-HC.t)>0.04 then
            HC.part,HC.t,HC.pos,HC.nrm=tp,now,nil,nil
            local ch=tp.Parent
            -- ① 原射线方向（先确认"确实是朝目标那边打"的，免得取到背面的点）
            if typeof(origin)=="Vector3" and typeof(rdir)=="Vector3" and rdir.Magnitude>0.001 then
                local fwd=tp.Position-origin
                if fwd.Magnitude>0.001 and rdir.Unit:Dot(fwd.Unit)>0.2 then
                    local p,n=castChar(origin,rdir,ch)              -- 方向照原样(长度即射程)
                    if p then HC.pos,HC.nrm=p,n end
                end
            end
            -- ② 射线起点 -> 目标（静默时的常态路径）
            if not HC.pos and typeof(origin)=="Vector3" then
                local p,n=castChar(origin,tp.Position-origin,ch)
                if p then HC.pos,HC.nrm=p,n end
            end
            -- ③ 兜底: 目标身上看得见的那一点 -> 最次部位中心
            --   (HitPoint 内部自己也会打射线, 所以要一并挡住这个 hook, 否则它的"视线判定"会被我们自己的改写污染)
            if not HC.pos then
                Ray.Busy=true
                local ok2,hp=pcall(function()
                    return (SYS.Combat and SYS.Combat.HitPoint and SYS.Combat.HitPoint(tp)) or tp.Position
                end)
                Ray.Busy=false
                HC.pos=(ok2 and hp) or tp.Position
            end
            if not HC.nrm and typeof(origin)=="Vector3" then
                local d=HC.pos-origin
                if d.Magnitude>0.001 then HC.nrm=-d.Unit end     -- 法线朝着射手
            end
        end
        return HC.pos,(HC.nrm or Vector3.new(0,1,0))
    end

    function Ray.Target()
        if not SYS.Combat or not SYS.Combat.TargetPart then return nil end
        return SYS.Combat.TargetPart
    end

    function Ray.Install()
        local c=Prot.Caps()
        if not c.hmm or not c.gnm then return false,"这台执行器没有 hookmetamethod/getnamecallmethod" end
        if Ray.Hooked then return true end
        local ok,err=pcall(function()
            -- ★ v6.8.1 同上: 先声明 h
            local h
            h=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
                -- ★★ v6.9.10 性能: 加两道【最便宜的早退】, 把绝大多数调用直接放行 ——
                --   ① checkcaller(): 游戏自己的调用(占绝大多数)立刻返回, 不做任何后续判断;
                --   ② self~=WS: 非 Workspace 的方法调用直接放行(比 getnamecallmethod 便宜)。
                --   另外原来的 string.lower(tostring(m)) 每次调用都要新建字符串, 改成精确比较。
                if checkcaller and checkcaller() then return h(self,...) end
                if self~=WS then return h(self,...) end
                -- ★ v9.9.0: 我们自己在 hitOf() 里打白名单射线, 别再被自己扭一次
                if Ray.Busy then return h(self,...) end
                local m=getnamecallmethod()
                if m then
                    local lm=m
                    if lm=="Raycast" then
                        -- 阻挡射线: 直接返回"什么都没打到"
                        if SYS.T_.CB_BlockRay==true then
                            Ray.Rewrites=Ray.Rewrites+1
                            return nil
                        end
                        local a1,a2=...          -- ★ v6.9.18: 留下 origin/direction 用来算命中点/补 Ray 字段
                        local res=h(self,...)
                        if SYS.T_.CB_SilentAim==true or SYS.T_.CB_BulletWall==true then
                            local tp=Ray.Target()
                            if tp then
                                Ray.Rewrites=Ray.Rewrites+1
                                -- ★★ v9.9.0: 命中点/法线/距离/材质/Ray 全部按【同一次命中】算
                                --   (旧版这里 Position=目标、Distance/Normal/Material=墙 —— 见本模块顶部注释)
                                local pos,nrm=hitOf(a1,a2,tp)
                                local dist=0
                                if typeof(a1)=="Vector3" then dist=(pos-a1).Magnitude end
                                local rayObj=nil
                                if typeof(a1)=="Vector3" and typeof(a2)=="Vector3"
                                   and a2.Magnitude>0.001 and RayCtor and RayCtor.new then
                                    rayObj=RayCtor.new(a1,a2)     -- 原样重建: 方向/长度与游戏当初传的一致
                                end
                                if not rayObj and res then rayObj=res.Ray end
                                return {
                                    Instance = tp,
                                    Position = pos,
                                    Normal   = nrm,
                                    Material = (tp.Material or Enum.Material.Plastic),
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
                                -- ★ v9.9.0: 第 1 参是 Ray 对象(标准签名), 老形态才是 (origin,direction)
                                local o,dv
                                if typeof(a)=="Ray" then o,dv=a.Origin,a.Direction
                                elseif typeof(a)=="Vector3" then o,dv=a,b end
                                local pos,nrm=hitOf(o,dv,tp)
                                -- ★ v6.9.0 标准签名是 (Instance, Position, Normal, Material), 4 个都自洽
                                return tp,pos,nrm,(tp.Material or Enum.Material.Plastic)
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
        -- ★ v9.9.0: 顺手清掉复用状态, 免得下次开时用上一次的陈旧命中点
        Ray.Busy=false
        HC.part=nil HC.pos=nil HC.nrm=nil HC.t=0
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

    --============================================================
    -- ★★ v8.2.0 M1 · 「跟随 / 环绕」5 个开关融合成【互斥下拉】
    --   为什么必须融合: 下面这 5 个模式都在**写你的 CFrame / 相机** ——
    --   以前是 5 个独立开关、可以同时打开, 于是互相抢位置 -> 表现为**抖动 / 瞬移**。
    --   (本项目铁律: 同一时刻只允许一个模块写位置; 排查抖动先问"现在有几个模块在写位置"。)
    --   现在只暴露一个下拉, 每次最多一个生效 —— **互斥由控件保证**, 从结构上消灭这一类 bug。
    --   ★ 下面那些 setter(LoopTP/OnHead/Orbit/Stare/Follow)一行没改, ApplyFollowMode 只是
    --     "每次只把一个置 true", 不碰它们内部的行为。
    --============================================================
    PC.FollowModes ={"PC_LoopTP","PC_OnHead","PC_Orbit","PC_Stare","PC_Follow"}
    PC.FollowLabels={"循环跟传","坐他头上","绕着他旋转","盯着他","行走跟随"}
    function PC.FollowModeIndex(mode)
        for i,k in ipairs(PC.FollowModes) do if k==mode then return i end end
        return 0
    end
    function PC.ApplyFollowMode(mode)
        if mode~="off" and PC.FollowModeIndex(mode)==0 then mode="off" end
        for _,k in ipairs(PC.FollowModes) do
            local want=(k==mode)
            if SYS.T_[k]~=want then
                local setter=k:sub(4)                       -- "PC_Follow" -> "Follow"
                if type(PC[setter])=="function" then pcall(PC[setter],want) end
            end
        end
        SYS.C_.PC_Mode=mode
        QueueSave()
        for _,f in ipairs(SYS.BtnRefs or {}) do pcall(f) end     -- 刷新界面
        print(("[PC] 跟随模式 -> %s"):format(mode=="off" and "关闭" or mode))
        return mode
    end
    -- 老配置迁移: 以前允许同时开好几个 -> 只保留一个(按上表顺序取第一个开着的),
    -- 并把其余标志**落回 false**, 免得一进游戏就有两个模块抢位置。
    do
        local cur=tostring(SYS.C_.PC_Mode or "")
        if PC.FollowModeIndex(cur)==0 then
            local pick="off"
            for _,k in ipairs(PC.FollowModes) do
                if SYS.T_[k]==true then pick=k break end
            end
            for _,k in ipairs(PC.FollowModes) do SYS.T_[k]=(k==pick) end
            SYS.C_.PC_Mode=pick
            if pick~="off" then
                print(("[PC] v8.2.0 迁移: 跟传类 5 个开关已合并为一个互斥下拉, 只保留「%s」"):format(pick))
            end
        else
            for _,k in ipairs(PC.FollowModes) do
                if k~=cur and SYS.T_[k]==true then SYS.T_[k]=false end
            end
        end
    end


    --============================================================
    -- 统一卸载(由 SYS.UnloadAll 调用)
    --============================================================
    function SYS.FuseClean()
        P(SYS.RestoreLight)
        P(Audio.RestoreAll)
        P(ChatLog.Stop)
        P(function() SYS.SetNoDeath(false) end)
        P(function() SYS.SetNoKnock(false) end)
        P(PC.OnHead,false) P(PC.Orbit,false) P(PC.Stare,false)
        P(PC.Follow,false) P(PC.LoopTP,false)
        P(function() SYS.SetLoop("WPTween",false) SYS.SetLoop("WPWalk",false) end)
        -- ★ 2026-09-22: RemoveKickGuard / RemoveTPGuard 已随那两项功能一起删除(见 [13] 段说明)
        P(Prot.RemoveHideGui)
        P(Ray.Remove)
    end
end
--============================================================
-- [12C] v6.8.0 反作弊对抗靶场 (SYS.AC)
--   ⚠ 先说清楚这一层是什么:
--     Hyperion(Byfron) 是【客户端原生反篡改】—— 内存注入扫描 / DLL 签名 / 反调试 /
--     线程监控 / 内存加密, 工作在进程与内核层, 有 268(拦截)/267(体验封禁)/279(连接) 这些错误码,
--     但【没有公开版本号】, 而且 Lua 脚本根本碰不到它:
--     Lua 能跑 = 注入早就成功了; Hyperion 判定时客户端在 Lua 之前就崩了。
--     所以"Lua 与 Hyperion 6.0 对抗并全部通过"没有可执行接口 —— 这里不编造那种结果。
--   ✅ 本靶场做的是【真正能踢你/标记你的那一层】: 游戏自己的反作弊脚本(LocalScript)。
--     它没有 getrawmetatable / getgc(那是执行器才有的), 但它能:
--       · 遍历 CoreGui / PlayerGui / Workspace / Lighting, 按名字找外挂
--       · 读 Player / Humanoid 的数值与位移(服务端也能读到 -> 这部分客户端改不了)
--       · 统计开枪间隔 / 相机行为 / 远程事件频率
--     我们先把这些检测器【自己写出来打自己】, 再把能修的修掉, 然后复测 -> 看通过率。
--============================================================
do
    local AC={} SYS.AC=AC
    -- 旧键名【碎片化拼接】: 不写成连续字符串, 免得被本补丁自己的批量改名规则改掉
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

    --=========== 采样器: 记录单帧最大位移 / 相机与角色最大偏离 ===========
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


    --=========== 检测器 ===========
    -- D1 实例足迹: 按名字特征扫 CoreGui / PlayerGui / Workspace / Lighting
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

    -- D2 菜单可见性: 名字是否中性 + 枚举隐藏钩子是否开着
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

    -- D3 GENV 足迹: 任何脚本 getgenv() 一读就能认出我们
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

    -- D4 落盘足迹: 同目录下的文件名就是路标
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

    -- D5 角色数值: 服务端也能读到 -> 这一层客户端遮不住, 只能如实报告
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
        -- ★ 原「重力」检查已在 v9.9.0 删除清理时一并拿掉:
        --   它由已删的黑名单键 SYS.T_.LockGravity 守卫, 而脚本自 v116 起【不再改 WS.Gravity】
        --   (移动模块里那句 gravZero 只用于清理老版本残留) —— 守卫恒 nil => 这条是永不执行的死分支。
        --   而且它不能被改成"无条件检查": 低重力地图会让它永久误报, 反而盖住上面那三条真信号。
        if #bad==0 then return true,"角色数值全在正常范围内" end
        return false,("服务端可测到的异常: "..table.concat(bad," · ").."  (这类遮不住, 建议用时再开)")
    end

    -- D6 位移跳变: 单帧位移超过合理值 = 瞬移
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

    -- D7 开火节奏: 恒定 + 过快的间隔是最容易被统计的特征
    local function d7()
        local d=SYS.C_.CB_FireDelay or 0.06
        if d<0.08 then
            return false,("开火间隔 %.3f 秒 < 人类下限 0.08 —— 统计几十枪就能判定脚本(现已加 ±20%% 抖动, 但基准仍偏快)"):format(d)
        end
        return true,("开火间隔 %.3f 秒 + ±20%% 抖动, 节奏不恒定"):format(d)
    end

    -- D8 相机行为: 相机离角色太远 = 自由视角/灵魂出窍
    local function d8()
        if not AC.SamplerOn then return true,"采样器未运行(点「开始采样」)" end
        if AC.CamMax>40 then
            return false,("相机与角色最大偏离 %.0f 格 —— 自由视角/灵魂出窍在客户端很显眼"):format(AC.CamMax)
        end
        return true,("相机与角色最大偏离 %.1f 格, 正常"):format(AC.CamMax)
    end

    -- D9 hook 自检: 这一层只有【执行器级对手】能看, 但我们要知道自己装了什么
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

    -- D10 全局函数足迹: 我们的 SYS 挂在 GENV.__SYS 上, 任何脚本都能直接读
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



    --=========== 实例中性化(可重复调用) ===========
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
        -- 随身灯笼
        pcall(function()
            local ch=LP.Character
            local root=ch and ch:FindFirstChild("HumanoidRootPart")
            if root then
                for _,c in ipairs(root:GetChildren()) do
                    if c.Name==SYS.N.OldLantern or c.Name=="CheatMenu_Lantern" then ren(c,SYS.N.Lantern) end
                end
            end
        end)
        return ok
    end
end

--============================================================
-- [A9] ★★ v6.11 对照公开脚本补的四项能力(用户批准 "1234都加")
--   ① ⚡ 快速交互 : ProximityPrompt 免按住(HoldDuration=0) + 触发距离拉大
--   ② 🏃 自动藏身 : 敌对生物靠近 -> 用最近的藏身点 Prompt 钻进去
--                   (fireproximityprompt = 等价于你按 E, 走【服务端认可】那条路)
--   ③ 📖 密码提示 : 把密码书/提示纸(部件上 SurfaceGui 的文字)读出来 -> 控制台 + HUD
--   ④ 🧱 表现层对抗: 禁布娃娃/物理/平台站立(纯本地)
--   ⚠ 诚实说明: 本执行器【没有 getconnections】, 做不到"让游戏根本不播"跳脸/震屏,
--     只能事后对抗(禁状态)。能禁用连接的执行器才做得到"完全不播"。
--============================================================
do
    -- ★★ 合并: 引用 SYS.KwHidePrompt(严格版, 见 [08] 顶部 ③: 透视那份更宽松, 刻意没合)
    local AH_KW=SYS.KwHidePrompt
    -- ★ v9.9.7 合并: 与活物透视共用同一份敌意词表(原来这里另写了一份, 内容还不一致)
    local HOST_KW2=SYS.KwHostile
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
        -- ★★ v9.9.7 蜜罐闸门(用户口径「不要动蜜罐就行」): 自动藏身是【真的按下去】的路径,
        --   而它不走 fireObj() 那个共用入口, 所以这里单独挡一道。
        if SYS.IsHoneypot and SYS.IsHoneypot(pr) then
            SYS.Notify("⛔ 自动藏身: 那个藏身点名字像蜜罐, 已跳过(绝不替你按)", SYS.CY.yellow)
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
                -- ★★ 合并: 这串词原来内联在这里, 就是「书籍/纸张/线索」分类表的子集 -> 引用 SYS.KwClueText
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

-- [14] UI 页面
--============================================================
-- ★ v6.9.2 页面顺序按【使用频率】重排(原来是按"用途域", 结果最常用的几页被压在后面):
--   ①打得赢(战斗/视觉/移动) ②找得到人(玩家/传送/MachineParty) ③自动化(挂机) ④工具箱(功能) ⑤辅助(翻译/设置)
--   共 11 页: 侧栏 y = 7 + 11*46 = 513, 底部搜索框在 546 —— 仍留 33px 余量, 不会撞。
--   ★ 改这个表的顺序 = 改侧栏显示顺序; UI.Pages 里各页代码的【先后顺序无所谓】(按名字查表)。
UI.Defs={
    {name="战斗",icon="⚔"},{name="视觉",icon="◉"},{name="移动",icon="◈"},{name="玩家",icon="👤"},
    {name="MachineParty",icon="🎮"},{name="传送",icon="➲"},{name="挂机",icon="★"},{name="功能",icon="✱"},{name="翻译",icon="🌐"},{name="设置",icon="⚙"},
}

UI.Pages["移动"]=function(p)
    UI.Section(p,"✈️ 飞行",CY.accent)
    UI.Switch(p,"飞行 (Fly)","Fly",function(on)
        if not on then SYS.CleanFly() end
        SYS.SetLoop("Fly",on,SYS.PhysicsStep,SYS.FlyTick)
        P(SYS.SyncAntiRevert)     -- ★ v6.9.16 飞行/加速任一开着 -> 自动挂「防回退」(位置上报限速)
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
        P(SYS.SyncAntiRevert)     -- ★ v6.9.16 同上: 加速也一起挂防回退, 两个都关才卸下
    end)
    UI.Slider(p,"移动速度倍率",0,20,0.5,function() return SYS.C_.SpeedMult end,function(v) SYS.C_.SpeedMult=v end)
    -- ★ v123: 默认改用官方推荐的 LinearVelocity(旧的 BodyVelocity 已弃用, 降级为兼容选项);
    --   并给倍率加风险提示 —— 服务端按【位移 vs 正常速度 ×2】容差判定, 倍率超过 2 就会被记一笔。
    UI.Cycle(p,"加速模式",{"Linear","BodyVelocity","WalkSpeed"},
        function() return SYS.C_.SpeedMode end,
        function(v) SYS.C_.SpeedMode=v if SYS.T_.Speed then SYS.CleanSpeed() end end)
    UI.Tip(p,"默认「Linear」= 官方推荐的 LinearVelocity(旧 BodyVelocity 已弃用, 保留兼容)。\n「WalkSpeed」= 只改走路速度, 最朴素也最稳。\n⚠️ 倍率建议 ≤ 2: 服务端按【每 tick 位移 > 正常速度 ×2】判定加速作弊, 调太高会被记一笔。",CY.yellow)
    UI.Div(p)
    -- ★★ 2026-09-20(用户要求「穿墙的功能我还是需要的」): 把穿墙的界面入口加回来。
    --   背景: 它的界面入口在 v6.9.6 被删过一轮, 但后端 SYS.SetNoclip / SYS.ApplyNoclip 一直保留着
    --   (卸载流程里也还在调它), 所以这里只补一个开关、不动实现。
    --   实现要点: 关掉角色所有 BasePart 的 CanCollide + 一条守护循环(游戏把碰撞写回来会再关一次)
    --            + 监听 CharacterAdded(重生后自动套到新角色上); 关闭时一并还原。
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
    -- ★ v6.9.6: 穿墙(Noclip)按你的要求删除 —— 界面入口没了, SYS.SetNoclip / ApplyNoclip 后端保留
    -- ★★ v6.9.24 新增「🕊 无仇恨模式」(用户要求: 敌对生物/NPC 无视我、别攻击我)。
    --   说清楚边界: 怪物/NPC 的仇恨 AI 跑在【服务端】—— 客户端改不了"它恨不恨你"。
    --   所以这里做的是【让它找不到你 / 找到也伤不到你】三件客户端能做的事:
    --     ① 藏地下隐身(角色从别人视野里消失) ② 反陷阱免伤(被打也不掉血/不被推)
    --     ③ 自动躲伤害机关(靠近陷阱/地雷自动退开)
    --   三个一起开 = 实际体感最接近"无仇恨"。关掉就三个一起还原。
    --============================================================
    -- ★★ v6.9.25 「无仇恨模式」= 甩仇(用户澄清: "让怪物和他打, 相当于怪物和所有人打 除了我")
    --   怪物打谁是【服务端 AI】定的, 客户端唯一能插手的两条路:
    --     ① 若怪物把"当前目标"存在【客户端可读写的 Attribute】里(Attribute
    --        Target|Enemy|Aggro|TargetPlayer …): 直接改成"离它最近的【别的玩家】" -> 它就去打别人;
    --        ★★ 2026-09-20: 这里原来还写着 Humanoid.Target —— 查过官方 API 文档, Humanoid
    --        【根本没有 Target 属性】(只有 Vector3 的 TargetPoint), 裸读必抛
    --        "Target is not a valid member of Humanoid", 所以那条路从来不可能生效, 已删除。
    --     ② 那个字段不存在/写不动 -> 退化成【隐去自己】(它找不到你, 只能找别人) + 免伤 + 自动躲。
    --   开关开着时: 每 0.5 秒扫一遍附近 NPC 试 ①, 同时把 ② 挂上; 通知里告诉你走了哪条。
    --============================================================
    local NA={tick=0, wrote=0, scanned=0, others={}}
    SYS.NoAggroInfo=NA
    -- 找"离怪最近的别的玩家角色"
    local function otherTarget(pos)
        local best,bd=nil,math.huge
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl~=SYS.LP then
                -- ★★ 修复(2026-09-20 仿真验证发现): bodyOf 要的是【角色模型/BasePart】,
                --   传 Player 进去永远是 nil(Player 没有 HumanoidRootPart/PrimaryPart,
                --   子对象 PlayerGui/Backpack 也不是 BasePart) -> otherTarget 恒返回 nil
                --   -> 无仇恨"甩仇"从来没写成过一次。这里传角色。
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
            -- ★★ 修复(2026-09-20 仿真验证发现): 原来写的是 bodyOf(SYS.LP) —— 传 Player 进去
            --   恒返回 nil, 于是这一行之后【立刻 return】, 整个甩仇循环等于空转
            --   (实测: NA.tick 永远是 0, 也就是函数体一次都没跑完)。这里改成传角色。
            local me=bodyOf(SYS.LP.Character)
            if not me then return end
            local n,w=0,0
            for _,m in ipairs(WS:GetChildren()) do
                local h=pcall(function() return m:FindFirstChildOfClass("Humanoid") end) and m:FindFirstChildOfClass("Humanoid") or nil
                if h then
                    -- 是不是玩家角色? 是就跳过
                    local pl=Players:GetPlayerFromCharacter(m)
                    if not pl then
                        n=n+1
                        local root=m.PrimaryPart or m:FindFirstChild("HumanoidRootPart")
                        local pos=root and root.Position
                        -- ★★ 2026-09-20(仿真验证 + 官方 API 核对后删除): 这里原来还有一条
                        --   "① Humanoid.Target 指向我 -> 改成别人"。真机 Humanoid 【没有 Target
                        --   属性】(只有 Vector3 的 TargetPoint), 裸读必抛 "Target is not a valid
                        --   member of Humanoid"; 就算像上一版那样包一层 pcall, 也只是变成
                        --   "每个怪每 0.5s 白抛一次异常"(Roblox 里抛异常不便宜), 而写入同样抛错。
                        --   这条通道【从来不可能生效】, 已整体删除, 只保留下面真正能用的 Attribute 通道。
                        -- ① Attribute 形式(客户端唯一写得上、且游戏 AI 可能真去读的通路)
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
    -- ★★ 修复(仿真台跑出来的真问题): 原来 SetNoAggro(false) 会【无条件】把
    --   「反陷阱免伤」和「自动躲」一起关掉 —— 哪怕这两项是用户自己开的, 也被顺手关掉;
    --   而且如果用户本来开着「自动躲」, 关掉无仇恨后它的开关还显示"开"、循环却没了(静默失效)。
    --   这正是脚本 v115 注释里记过的那类历史 bug: "临时关掉某个开关会触发兜底 Stop ->
    --   把别的开关也一并误关了"。现在: 开无仇恨时记住这两项【原本】的状态, 关的时候只还原
    --   "不是用户自己开的那部分", 属于用户自己的那部分确保循环恢复。
    local NoAggroPrev=nil
    function SYS.SetNoAggro(on)
        SYS.T_.NoAggro = on and true or false
        if not on then
            -- 关: 只还原【无仇恨自己挂上的】两项(不再去动藏地下隐身 —— 那是用户自己的开关)
            local prev=NoAggroPrev or {}
            NoAggroPrev=nil
            if not prev.trap  then SYS.T_.TrapImmune=false end
            if not prev.dodge then SYS.T_.AutoDodge=false end
            P(function()
                if not prev.trap and SYS.SetTrapImmune then SYS.SetTrapImmune(false) end
                if not prev.dodge and SYS.SetAutoDodge then SYS.SetAutoDodge(false) end
                -- ★ 用户本来就开着的那项: 开关还亮着, 就把循环补回来(可能在上面被停掉了)
                if prev.dodge and SYS.T_.AutoDodge and SYS.SetAutoDodge then SYS.SetAutoDodge(true) end
                if prev.trap  and SYS.T_.TrapImmune and SYS.SetTrapImmune then SYS.SetTrapImmune(true) end
            end)
            SYS.Notify("🕊 无仇恨模式已关",SYS.CY.sub)
            return
        end
        -- ★★ v6.10.9 修「开了无仇恨就上下瞬移」: 原来这里【强绑三件套】, 其中一件是
        --   「藏地下隐身」——它每 1/30s 把你按到地下(默认深度 120 格), 而服务端不同意这个位置,
        --   每帧把你拉回地面 -> 客户端压下、服务端拉回 -> **上下疯狂弹跳(看起来就是上下瞬移)**。
        --   现在: 无仇恨只挂【反陷阱免伤 + 自动躲】两项(position 安全), 不再自动开藏地下隐身。
        --   想连"隐身"一起用 -> 自己去视觉页打开「🕳 藏地下隐身」(并建议把深度调小)。
        -- ★ 记录"开无仇恨之前"这两项原本是开还是关 —— 关闭时只还原【不是用户自己开的】那部分
        NoAggroPrev={trap=SYS.T_.TrapImmune and true or false, dodge=SYS.T_.AutoDodge and true or false}
        SYS.T_.TrapImmune=true SYS.T_.AutoDodge=true
        P(function()
            if SYS.SetTrapImmune then SYS.SetTrapImmune(true) end
            if SYS.SetAutoDodge then SYS.SetAutoDodge(true) end
        end)
        -- 甩仇循环(每 0.5s 一次, 只扫 Workspace 直接子对象, 很便宜)
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
                    -- ★ 2026-09-20: 原来这里直接打印怪的 Humanoid.Target —— Humanoid 没有这个
                    --   属性, 读必抛错, 这条诊断按钮点一次就在控制台里丢一个异常。
                    --   改成打印真正会被"甩仇"读写的 Attribute(Target|Enemy|Aggro…),
                    --   有就列出来、没有就明说没有。
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
            -- 开着的时候拖滑条 -> 关再开, 立刻按新倍率重应用
            if SYS.T_.JumpBoost then P(SYS.SetJumpBoost,false) P(SYS.SetJumpBoost,true) end
        end,"x%.1f")
end

UI.Pages["视觉"]=function(p)
    UI.Section(p,"👁 活物透视 (玩家 / 生物)",CY.accent)
    -- ★ v72: 方框选项已删(用户要的是人物高亮, 不是框)
    UI.Tip(p,"透视 = 人物高亮(把整个人染色描边, 穿墙可见)。\n掉落物透视用同款高亮(统一亮青) —— 只认【客户端已经拿到】的世界物件(名字像掉落物, 或带可捡/可交互提示)。\nRoblox 不会把别人的背包复制给你, 所以别人包里的东西看不到是引擎限制, 不是脚本问题。")
    -- ★★ 合并(用户要求): 原来「玩家透视 (ESP)」与「🐾 生物透视 (ESP_NPC)」是【两个开关】,
    --   但底层的生物透视回调里自己就写着 `if on then SYS.T_.ESP=true end` —— 开生物透视会
    --   自动把玩家透视也开上(不然不算"所有活物"), 还要靠 SYS.BtnRefs 手动去刷上面那个开关的
    --   显示。语义上本来就是同一个东西(要不要看"活物"、看到哪一档), 所以合并成一个三态选项。
    --   底层 ESP / ESP_NPC 两个配置键都保留 -> 老存档照样能读回来。
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
    -- ★★ 合并(用户要求): 原来「玩家名字 (ESPNameTag)」与「头顶武器标记 (ESPWeapon)」是两个开关,
    --   但它们都是挂在同一个头顶挂点(tagPart)上的 BillboardGui、共用同一个高度参数(ESPNameH)、
    --   走同一个清理函数, 而且两边的回调里各写了一遍几乎一样的互锁判断(共 4 处)。
    --   现在合成一个开关同时驱动两个池(LB 名字 / LW 武器标签) —— 想只要名字不要武器标记的
    --   场景基本不存在(有武器才标, 没武器什么都不显示, 不占地方)。
    UI.Switch(p,"🪧 头顶标签 (名字+血量+距离 · 有武器就标红)","ESPNameTag",function(on)
        SYS.T_.ESPWeapon=on          -- ★ 一个开关同时管"名字标签"和"武器标记"两个池
        SYS.ESPMaybeClear()
    end)
    -- ★ v3.9.0 名字高度: 默认自动贴到角色顶部之上, 这里只做【额外】抬高
    UI.Slider(p,"名字高度(额外抬高)",0,8,0.2,
        function() return SYS.C_.ESPNameH end,function(v) SYS.C_.ESPNameH=v end,"+%.1f")
    UI.Tip(p,"标签内容 = 名字(优先 DisplayName) + 当前/最大血量 + 离你几格; 血量低于 60% 转橙、低于 30% 转红。\n"..
        "有武器(手上或背包里, 标准 Backpack 属性)就在下方再标一行 🔫 武器名(红字)。\n"..
        "挂点自动回退 Head -> UpperTorso -> Torso -> HumanoidRootPart, 名字高度再按角色包围盒自动贴顶。",CY.sub)
    UI.Div(p)
    -- ★★ v6.11 用户批准 "1234都加"(对照公开脚本补的能力)
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
    -- ★★ UI 审计: 顺手修掉一处【分区错位】——「📦 物件高亮」这个标题原来挂在这里之前,
    --   但它后面跟的第一个控件是【交互·藏身】那一组, 总闸反而落在 交互·藏身 分区的末尾,
    --   等于那个标题下面什么都没有。现在把标题挪到它真正对应的总闸前面。
    UI.Div(p)
    UI.Section(p,"📦 物件高亮 (掉落物 / 可交互 / 门·陷阱·假门 / 小游戏)",CY.accent)
    -- ★★ 合并(用户要求): 「🎮 小游戏区域透视 (ESP_Mini)」原来在 MachineParty 页单独占一个开关 ——
    --   它的判据(区域名命中)本质就是物件分类表里的第 12 类, 却要用户跑另一个页面再开一次;
    --   开着「物件透视」时小游戏里的按钮/靶子不亮, 是明显的体验割裂。现在并入这个总闸。
    --   底层 ESP_Mini 配置键保留 -> 老存档照样能读回来, 底层扫描逻辑一行没改。
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
    -- ★★ UI 审计: 这个分区标题原来叫「👣 落脚点 · 射线」—— 落脚点指示早在 v6.9.26 就按用户要求
    --   删掉了(v7.2.0 清理时把它的后端 SYS.SetFootstep 也一并删了), 分区里只剩「子弹射线」。
    --   标题还挂着"落脚点"属于【没有对应功能的提示】, 改掉。
    UI.Section(p,"🎯 射线 (人物射线 / 弹道)",CY.accent)
    -- ★ v3.9.0 子弹射线: 只画线, 不改弹道
    -- ★★ 强化(用户要求, 参考公开脚本的 tracerParts 池化做法): 原来只有"开/关", 开了只画锁定目标一条。
    --   现在三态 —— 关闭 / 只锁定的目标(原行为) / 全部玩家(每个玩家一条, 池化多目标)。
    -- ★★ v9.9.7 语义重做(用户原话: 「应该是看其他玩家准心在看哪里 和自己的准心在哪里的
    --   准心伸出一条线 第三人称 第一人称都看得到」):
    --   旧「全部玩家」画的是【我 → 他】的连线(我能不能打到他), **不是"他在瞄哪"** ⇒ 用户说"错了"。
    --   现在是【每个人自己的瞄准线】: 自己 = 相机视线(=准星, 精确); 别人 = 他的头部朝向。
    --   ⚠ 诚实边界: 客户端读不到别人的相机/鼠标, 别人的线是"他的身体/头部朝哪边"。
    local TR_MODES={"关闭","只看自己","自己+其他玩家"}
    UI.Cycle(p,"子弹射线 (每个人自己的准心线)",TR_MODES,
        function()
            if not SYS.T_.Tracer then return "关闭" end
            return SYS.T_.TracerAll and "自己+其他玩家" or "只看自己"
        end,
        function(v)
            SYS.T_.Tracer=(v~="关闭")
            SYS.T_.TracerAll=(v=="自己+其他玩家")
            if not SYS.T_.Tracer then P(SYS.TracerHide) end
        end)
    UI.Slider(p,"射线最远距离 (格 · 0=不限)",0,2000,50,
        function() return SYS.C_.TracerMaxDist or 500 end,
        function(v) SYS.C_.TracerMaxDist=v end,"%.0f")
    UI.Slider(p,"射线最多几条 (人多时防卡)",1,24,1,
        function() return SYS.C_.TracerMaxN or 12 end,
        function(v) SYS.C_.TracerMaxN=v end,"%.0f")
    UI.Tip(p,"从每个人【自己的头部】沿【他自己瞄准的方向】伸一条线; 撞到东西就停在那面墙上。\n"..
        "· 只看自己 = 一条, 用相机视线 —— 那就是你的准星, 精确。\n"..
        "· 自己+其他玩家 = 每个人都有一条; 别人的用【他的头部朝向】。\n"..
        "⚠ 客户端读不到别人的鼠标/相机, 所以别人的线是「他的身体/头朝哪边」—— 第三人称游戏多数会让\n"..
        "  身体转向瞄准方向, 够用; 他若开自由视角就会对不上。拿不到的不编。\n"..
        "🎨 自己 = 亮青绿 · 别人 = 橙。线是 3D 物体, 第一人称/第三人称都看得见;\n"..
        "  池化复用(每条常驻, 只改位置/长度), 「最远距离」「最多几条」两道上限防人多时画满屏。\n"..
        "纯视觉: 只画线, 不改弹道、不改命中判定。",CY.sub)
    UI.Div(p)
    UI.Section(p,"🎥 自由视角 (镜头飞出去看, 人留在原地)",CY.cyan)
    UI.Switch(p,"自由视角","FreeCam",function(on)
        if on then SYS.StartFreeCam() else SYS.StopFreeCam() end
    end)
    UI.Slider(p,"自由视角速度",10,300,5,function() return SYS.C_.FreeCamSpeed end,function(v) SYS.C_.FreeCamSpeed=v end,"%.0f")
    UI.Slider(p,"自由视角灵敏度",0.1,2,0.05,function() return SYS.C_.FreeCamSens end,function(v) SYS.C_.FreeCamSens=v end,"%.2f")

    -- ★★ v6.9.35 用户问"我的高亮 / 全图高亮 / 去迷雾的功能呢" ——
    --   ① 玩家透视(人物高亮)本来就有(本页最上面「玩家透视 (ESP)」);
    --   ② 【光照档位 / 禁雾 / 夜视】的实现一直都在(第 A5 段 光照档位包 + SYS.ReapplyLight),
    --      但**界面上从来没接过入口**, 所以点不到 —— 这里补上;
    --   ③ 【全图高亮】= 物件/门/小游戏 透视的距离上限, 原来写死 1200 格且不可调, 现在可选到"全图"。
    UI.Div(p)
    UI.Section(p,"🌗 光照 · 去雾 (夜视 / 全亮 / 禁雾)",CY.orange)
    UI.Cycle(p,"光照档位",SYS.LIGHT_MODES,
        function() return SYS.C_.LightMode or "关闭" end,
        function(v) SYS.C_.LightMode=v P(SYS.ReapplyLight) end)
    UI.Switch(p,"🚫 禁雾 (去迷雾 · 远处不再白茫茫)","NoFog",function() P(SYS.ReapplyLight) end)
    UI.Switch(p,"🌑 禁阴影","NoShadow",function() P(SYS.ReapplyLight) end)
    UI.Switch(p,"🏮 随身灯笼 (只有你看得见的光)","Lantern",function() P(SYS.ReapplyLight) end)
    -- ★★ v6.9.35 全图高亮: 拉满 = 地图另一头的物件/门/小游戏也高亮
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
    -- ★ v4.2.0 扫描主入口(从设置页搬来; 用户要求放功能页)
    UI.Section(p,"🔍 综合扫描 (十一层一次扫完)",CY.green)
    UI.Btn(p,"🔍 综合扫描 (通信/代码/脚本/实例/数据/连接/环境/反查/值对象/DEX/Remote 十一层一次扫完)",CY.green,function()
        P(function() SYS.Lab.FullScan() end)
    end)
    UI.Btn(p,"📋 复制扫描摘要到剪贴板",CY.cyan,function() P(function() SYS.Lab.Summary() end) end)
    UI.Btn(p,"🔎 探测本游戏的领取/收集/购买 remote",CY.sub,function()
        P(function() SYS.ProbeEvent("claim") end)
        P(function() SYS.ProbeEvent("pickup") end)
        P(function() SYS.ProbeEvent("buy") end)
        SYS.Notify("探测结果已打到控制台(F9)",SYS.CY.cyan)
    end)
    UI.Tip(p,"点【综合扫描】一个按钮, 结果全部打到控制台(F9), 按十一层分行:\n  A 通信层 = 游戏有哪些 Remote(能触发什么) —— 原来是单独一个按钮, 现在合并进来了\n  B 代码层 = 游戏有哪些函数 + 名字可疑的(damage/fire/aim…)\n  C 脚本层 = 跑了哪些脚本/模块\n  D 实例层 = getnilinstances(游戏藏起来的对象) + Workspace 规模\n  E 数据层 = 自己和他人身上的 Attribute 全字段(vs @Health/@Team 就来自这里)\n  F 连接层 = 游戏自己挂了哪些事件监听\n  G 环境层 = 执行器/游戏全局 + registry + 线程身份(能判断脚本跑在什么权限下)\n  H 反查层 = getcallingscript(谁调起的) + 函数闭包 upvalue 概览\n  I DEX 层 = 全图实例浏览器: 类名 TOP30 + RemoteEvent/Script/ProximityPrompt 等关键类的完整路径 + 属性快照\n  J Remote 层 = 每条通道能不能用: 收向监听几条/谁在收 + 命中我们哪个功能类别 + 34 个类别的通道对账\n  K 值对象层 = Value 对象里的游戏状态(阶段/计时/分数/目标 —— 原来只数类名, 现在把值本身列出来)\n★ I/J/K 与其余八层是【同一个按钮、同一次全图遍历】, 不会为了它们把整个游戏多走一遍。\n★ 十层的**完整**内容(含 A 层 200+ 条 remote 全清单)只落成【一个】txt: `CheatMenu\scan_<PlaceId>.txt`\n  —— 就在执行器工作目录的 CheatMenu 文件夹里, 不再套服务器子文件夹、也不会另出第二个文件。",CY.sub)
    UI.Div(p)
    -- ★ v5.4.0 「进阶: 观察某个函数(函数名输入 + 开始观察/调用记录/调用链/停止观察)」整段删除
    --   —— 用户要求: "进阶观察函数名那个删了吧"。这套东西要用户自己观察、自己记函数名, 不是他要的。
    --   (SYS.Lab 里的观察实现留在原处但界面入口已无 —— 不占界面、也不会被误触。)

    UI.Switch(p,"上帝模式","GodMode",SYS.SetGod)
    UI.Switch(p,"无坠落伤害","NoFall",SYS.SetNoFall)
    -- ★ v82: 「隐身」只能本地生效(别人仍看得到你), 用户要求删除
    UI.Switch(p,"🕳 藏地下隐身 (服务器认可)","DeepHide",SYS.SetDeepHide)
    -- ★★ v6.10.8 用户要求: 加「平地」—— 只做左右/前后偏移, 不动上下(不潜地也不上天)
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
    --================ ★ v6.7.0 自杀 ================
    -- ★★ 9.8.0: 「原地重生 / 设置当前位置为重生点 / 恢复默认重生点」三个按钮已按用户要求删除
    --   (原话: "原地重生 出生地设置 恢复默认重生 删除吧 没用")。功能实现也一并删除。
    UI.Section(p,"☠ 自杀",CY.red)
    UI.Btn(p,"☠ 强制自杀 (抹除)",CY.red,function() SYS.ForceSuicide("erase") end)
    UI.Btn(p,"🕳 强制自杀 (虚空抹除)",CY.red,function() SYS.ForceSuicide("void") end)
    UI.Tip(p,"「抹除」= 直接移除你自己的角色模型; 「虚空抹除」= 先把角色挪到 -5000 高度再判死(某些游戏对出界的处理不同)。\n两条【只作用于你自己】。",CY.sub)

    UI.Div(p)

    UI.Div(p)
    --================ ★ v6.7.0 防护 ================
    UI.Section(p,"🛡 防护 (反作弊绕过 / 管理员检测 / 防踢出)",CY.orange)
    UI.Switch(p,"🛡 一键开启全部防护","Prot_HideGui",function(on)
        -- ★ v6.9.1 修(实测抓到): 原来签名是 setOne(k, s, f) —— 但下面三处调用【都只传了两个参数】
        --   (k 和"要执行的函数"), 于是 f 恒为 nil、点「一键开启全部防护」必定报
        --   "attempt to call a nil value"。之前 WindUI 那条路径不构建页面, 回调没被执行,
        --   这个 bug 一直没暴露。现在按真实调用改成 (k, f), 并顺手加一条能力判空。
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
            SYS.T_.Prot_AntiAdmin=true
            setOne("Prot_AntiAdmin",function()
                if SYS.ScreenGui then P(function() SYS.ScreenGui.Name="RobloxGui_Backpack" end) end
                return SYS.Prot.InstallHideGui()
            end)
            -- ★★ 2026-09-20: 「防甩飞」也纳入一键防护(它是纯本地速度清零, 不存在"装不上"的情况)
            setOne("AntiFling",SYS.SetAntiFling)
            SYS.Notify("🛡 全部防护已尝试开启(失败项会单独提示)",SYS.CY.green)
        else
            SYS.T_.Prot_AntiAdmin=false
            SYS.Prot.RemoveHideGui()
            P(SYS.SetAntiFling,false)
            SYS.Notify("防护已全部卸下",SYS.CY.sub)
        end
        for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end
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
    -- ★★★ v9.9.8 【按用户规则删掉两项】(用户:「防不住就删了」) ——
    --   删了「反作弊绕过(hook 本地 Kick/Shutdown/BanAsync)」与「防止被换服(拦本地 TeleportService)」, 理由:
    --     ① 真实的踢/封/传送都是【服务端发出】的, 客户端 hook 根本拦不到 ⇒ 实际防不住;
    --     ② 更糟: **hook 本身就是可被检测的特征** —— 公开反踢补丁(Adonis 那套)的讨论里明说,
    --        反作弊可以对一个【非玩家对象】调用 Kick, 若返回 nil 就说明 Kick 被替换过 ⇒ 直接坐实你在改客户端;
    --     ③ 拦 TeleportService 还会破坏正常玩法(小游戏换场景走不了)。
    --   ⇒ 净收益为负, 与"不制造特征"的原则直接冲突, 故整块删除(后端函数随后按死代码清掉)。
    --   保留的是【真能对抗真实检测】的那一项: 管理员检测绕过(名字/容器/Archivable 三条都能就地修), 以及防甩飞。
    -- ★★★ v9.9.8 补上这个分区的说明(用户问「那三个功能呢」—— 会来问就说明界面上没写清)。
    UI.Tip(p,"本分区只保留【真能对抗真实检测】的项目。\n"..
        "· 管理员检测绕过【已默认开启】= ① `protect_gui`(在支持它的执行器上, 游戏脚本完全看不到这个 GUI)\n"..
        "    ② `Archivable=false`(反作弊用 GetDescendants+Clone 打包可疑实例时, 它 Clone 不出来)\n"..
        "    ③ 擦掉实例名里的可疑词。⇒ 对抗的就是反作弊真会看的三样: GUI 名字、容器、能不能被打包。\n"..
        "    ✅ 只动【我们自己的】实例, 不碰游戏 UI、不改任何按键绑定; 菜单仍留在 PlayerGui ⇒ 位置不受影响。\n"..
        "    ⚠ 对「逐帧遍历 PlayerGui/gethui 找可疑 GUI」的检测【防不住】—— 那种本来也拦不住。\n"..
        "    ⚠ 也【挡不住】遍历 Workspace 找 Highlight/多出来的 Part —— 那是透视类功能的固有代价。\n"..
        "· 🎈 防甩飞 = 纯本地速度清零, 不 hook 任何函数。\n"..
        "★ 共同原则: 【只做零开销的改名与本地处理, 绝不挂 __namecall / __index】。\n"..
        "❌ 已删除(2026-09-22): 「反作弊绕过(hook 本地 Kick/BanAsync)」与「防止被换服(拦 TeleportService)」——\n"..
        "   真实踢/封/传送都由服务端发出, 客户端拦不到; 而且 **hook 本身就是可被检测的特征**\n"..
        "   (反作弊对非玩家对象调 Kick 看是否返回 nil, 就能认出你替换过函数)。\n"..
        "📌 一句话: 能降低「被本地脚本顺手清掉」的概率, 但改变不了服务端看到的东西。",CY.sub)
    -- ★★ 新增(2026-09-20, 参考公开脚本 AntiFling): 防甩飞 —— 被别人弹上天/弹出地图时把速度清零。
    UI.Switch(p,"🎈 防甩飞 (被别人弹飞时立即清零速度)","AntiFling",SYS.SetAntiFling)
    UI.Tip(p,"有人用约束/焊接把高速速度传染到你的角色上(俗称 fling/甩飞), 你会被弹到天上或地图外。\n"..
        "这里每帧检查你自己的 AssemblyLinearVelocity, 超过 80 格/秒就清零。\n"..
        "纯本地: 只动你自己的速度, 不改服务端判定; 正常跑步(16~30)与飞行/加速(走约束、不写这个字段)都不会被误伤。",CY.sub)

    UI.Div(p)
    --================ ★★ v7.7.0 补强批次2: 移动限速护栏(G8) ================
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
    --================ ★★ v7.7.0 补强批次2: 反指纹自检(G6/G7) ================
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

-- ★★ v6.9.25 整页恢复(用户: "我挂机页的功能你全部恢复吧") —— 用 6.9.0 原版挂机页替换
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
    UI.Tip(p,"★ 门槛判的是【背包里显示的基础 CPS】，不是带等级/词缀加成后的当前值 —— "
        .. "同一只脑红升级后当前值会涨很多，按当前值判会「门槛没设多高却什么都不卖」。",CY.sub)
    -- ★★ v8.2.0 修「只开『自动售卖』没反应」──
    --   「自动售卖」的唯一语义就是"按 CPS 门槛自动卖", 而判定函数 pickLow 在【门槛开关没开】时
    --   直接返回空 → 5 秒循环每轮都空转, 用户看到的就是"CPS 门槛/自动售卖 出 bug 了"。
    --   这里在打开自动售卖时**顺带把门槛开关也打开**(只往"更安全"的方向走 ——
    --   绝不会变成"把全部脑红都卖掉", 所以不会误卖贵重物品)。
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
    local row=Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,42) row.BackgroundColor3=CY.card
    row.BackgroundTransparency=0.3 row.BorderSizePixel=0 row.Parent=p
    UI.Round(row,10) UI.Stroke(row,CY.line,1,0.85)
    local lb=Instance.new("TextLabel")
    lb.Size=UDim2.new(1,-130,1,0) lb.Position=UDim2.new(0,12,0,0)
    lb.BackgroundTransparency=1 lb.Text="低于此值就卖掉 (可写 80m)"    lb.TextColor3=CY.text lb.Font=Enum.Font.GothamMedium
    lb.TextSize=13 lb.TextXAlignment=Enum.TextXAlignment.Left lb.Parent=row
    -- ★★ v9.4.0 简写解析/显示 —— 修「设了 80M 却乱卖」的直接原因之一:
    --   游戏里数字都显示成 `80m` / `1.2b` 这种简写, 用户自然照着填;
    --   而旧代码是 `tonumber(box.Text)` —— **`tonumber("80m")` = nil** ->
    --   走进 else 分支**静默恢复旧值** -> **门槛根本没生效**(还是默认 100000) -> 于是"乱卖"。
    --   现在支持 k/m/b/t/q 后缀(大小写都行, 逗号/空格也认), 并且显示也用简写。
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
                    -- ★★ v9.5.0 「看得见」的明细 —— 每一件都列出【背包显示值】与【表里基础值】+ 判定,
                    --   这样"门槛到底在拿哪个值比"不用猜, 一眼就能对出来。
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
end


UI.Pages["翻译"]=function(p)
    UI.Section(p,"💬 翻译开关",CY.accent)
    -- ★ v120.2 「翻译后端」下拉已删: 只剩本机 llama.cpp 一条路(云端 SiliconFlow 实测更慢且被限流)。
    --   替换成一条常驻说明 + 一个"重探槽位"按钮, 用户想知道"模型在哪/怎么开"时一眼能看到。
    UI.Label(p,"🖥️ 翻译后端: 本机 llama.cpp (Hy-MT2-7B · 127.0.0.1:8080)",CY.sub)
    UI.Tip(p,"翻译走本机模型, 不需要联网。模型没跑起来时界面翻译不会生效 ——\n双击桌面「翻译模型开关.bat」一键启动(开/关各一个), 起来后会自动重试, 不用重开脚本。",CY.sub)
    UI.Switch(p,"💬 聊天翻译","TransChat",function(on)
        if on then Trans.startChatListener() else Trans.stopChatListener() end
    end)
    UI.Switch(p,"🖼️ 界面翻译","TransUI",function(on)
        if on then Trans.startUIScan() else Trans.stopUIScan() end
    end)
    UI.Switch(p,"🔤 中英对照 (显示成「译文 (原文)」)","TransBilingual",function(on)
        -- 切换后立刻重扫一遍: 开=把原文补回来, 关=只留译文
        if Trans.reqOn(false) or Trans.reqOn(true) then P(function() Trans.forceRescan() end) end
        SYS.Notify(on and "🔤 中英对照已开: 译文 (原文)" or "🔤 已关: 只显示译文",SYS.CY.cyan)
    end)
    -- ★ v82: 「短文本批量合并」是死开关(v70 重写版已不做批量, BatchOn 没人读) -> 删除
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
    -- ★ 新增：实时并发监控
    local statConcurrent = UI.Label(p, "命中 0 | 本地 0 | 失败 0 | 跳过扫 0 | 均 0ms", CY.cyan)
    -- ★ v120.2 并发一行单独显示: 用户问"我的并发是多少上下" —— 直接把 在途/上限(区间) 摆出来。
    --   区间 = [Trans.MinConc, Trans.MaxConcCap]; Trans.MaxConc 是自适应当前值，在区间内浮动。
    local statConc = UI.Label(p, "并发: -", CY.purple)

    task.spawn(function()
        while not SYS.Unloaded do
            task.wait(0.5)
            if statL and statL.Parent then statL.Text=("已缓存 %d 条"):format(Trans.cacheCount or 0) end
            if statConcurrent and statConcurrent.Parent then
                local st=Trans.Stats or {}
                -- ⚠ 这里以前少乘了 1000: os.clock() 差是【秒】, 却按 ms 打印 -> 永远显示 0ms
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
        -- ★★ v9.9.3: 把【CheatMenu 自己的函数】从 GC 结果里剔掉。
        --   依据: DOORS 那份扫描里, "名字可疑的函数"57 个里超过 20 个其实是我们自己的
        --   (AutoHitScan / fireTick / aimTick / ClaimEverything / SetNoDeath ...) ——
        --   ① 列出来是【误导】(看着像游戏函数, 其实是本脚本的);
        --   ② 更糟: 落盘 txt 里等于把自己的内部函数名交出去, 与全局中性化的口径相悖。
        --   判据: 同一份 loadstring 出来的所有函数共享同一个 source(debug.info(f,"s"));
        --   先比【长度】再比串, 长度不符一下就刷掉, 7000 个函数也不慢。
        local selfSrc,selfLen=nil,0
        P(function()
            if type(debug)=="table" and type(debug.info)=="function" then
                local s=debug.info(1,"s")
                if type(s)=="string" and #s>0 then selfSrc,selfLen=s,#s end
            end
        end)
        local selfN=0
        local function isSelf(f)
            if not selfSrc then return false end
            local ok,s=P(function() return debug.info(f,"s") end)
            if not ok or type(s)~="string" then return false end
            if #s~=selfLen then return false end
            return s==selfSrc
        end
        local ok,err=P(function()
            for _,v in pairs(g(true)) do
                if type(v)=="function" then
                    if isSelf(v) then selfN=selfN+1
                    else
                        fns[#fns+1]=v
                        local own=ownerOf(v)
                        if own then
                            local k=own.Name or tostring(own)
                            byScript[k]=byScript[k] or {n=0}
                            byScript[k].n=byScript[k].n+1
                        end
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
            selfSrc and ("(已剔除 CheatMenu 自身函数 %d 个 —— 它们不该被当成游戏函数)"):format(selfN)
                     or  "(这台执行器取不到 debug.info 的 source, 没能剔除自身函数)",
            "按归属脚本分组(前 25):"}
        for i=1,math.min(#rows,25) do out[#out+1]=rows[i] end
        out[#out+1]="(归属拿不到 = C/引擎侧或匿名函数, hook 不了)"
        LAB.LastFns=fns
        SYS.ScanEmit(table.concat(out,"\n"))
        SYS.Notify(("GC 扫描完成: %d 函数 / %d 表"):format(#fns,#tbls),SYS.CY.green)
        return {fns=#fns,tbls=#tbls}
    end

    -- ② 可疑函数清单(只读)
    local KEY={"damage","hit","hurt","fire","shoot","aim","kill","die","death","health","attack","weapon","bullet"}
    -- ★ v9.9.3 去噪: DOORS 那份里 `Fire` 一口气出现 6 次, 全都是【信号库】的 Fire
    --   (Signal / GoodSignal / MadworkScriptSignal / FastCastRedux / ReplicaController / net),
    --   跟"开火"一点关系没有 —— 名字命中关键词但脚本是信号库, 一律跳过。
    local SIG_LIB={Signal=true,signal=true,GoodSignal=true,MadworkScriptSignal=true,
                   FastCastRedux=true,ReplicaController=true,net=true,SimpleSignal=true,
                   SignalPlus=true,LemonSignal=true}
    -- 这些名字只有在信号库里才叫噪声; 别的脚本里出现仍要报(比如 ProjectileHandler.FireProjectile)
    local SIG_NOISE={["fire"]=true,["firesync"]=true,["_fireevent"]=true,["fireserver"]=true}
    function LAB.ListHookable()
        local fns=LAB.LastFns
        if not fns then SYS.Notify("先点① GC 扫描",SYS.CY.yellow) return end
        local hits,skipped={},0
        for i=1,#fns do
            local f=fns[i] local nm=nameOf(f)
            if type(nm)=="string" and #nm>1 and #nm<40 then
                local low=nm:lower()
                for _,k in ipairs(KEY) do
                    if low:find(k,1,true) then
                        local own=ownerOf(f)
                        local on=own and (own.Name or "?") or "-"
                        if SIG_NOISE[low] and SIG_LIB[on] then
                            skipped=skipped+1
                            break
                        end
                        hits[#hits+1]=("  %-30s  脚本=%s"):format(nm:sub(1,30),on)
                        break
                    end
                end
            end
        end
        table.sort(hits)
        local out={("========== 名字可疑的函数(可能可 hook) =========="),
            ("命中 %d 个 (关键词: damage/hit/fire/aim/kill/health ...)"):format(#hits)}
        -- ⚠ 别写成 `{..., cond and s or nil}` —— 表里有 nil 洞时 `#t` 行为未定义,
        --   table.concat 会把后面所有条目(包括候选清单)整段吞掉。只能分条件追加。
        if skipped>0 then
            out[#out+1]=("(另跳过 %d 个信号库的 fire/fireSync —— 那是事件通知不是开火)"):format(skipped)
        end
        for i=1,math.min(#hits,40) do out[#out+1]=hits[i] end
        out[#out+1]="这些只是【候选】—— 想观察哪个, 用 ④ 按名字包一层(只记录, 不改返回值)"
        SYS.ScanEmit(table.concat(out,"\n"))
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
        SYS.ScanEmit(table.concat(out,"\n"))
        SYS.Notify("脚本清单已输出到控制台",SYS.CY.green)
    end


--  ══════════════════════════════════════════════════════════════
--  ① 综合扫描: 通信/代码/脚本/实例/数据/连接/环境/反查/DEX/Remote 十层一次点完, 全部打到控制台
--  ══════════════════════════════════════════════════════════════
    -- ══════════════════════════════════════════════════════════════
    --  ★ v4.2.0 综合扫描: 一个按钮点完, 输出按层分行, 全部打到控制台
    --  ★ 新增 I(DEX 实例浏览器) + J(Remote 每条通道能不能用) 两层 —— 与其余八层【同一个按钮】,
    --    I/J 共用一次全图遍历(融合成一个功能, 不是再开两个按钮)。
    --  ══════════════════════════════════════════════════════════════
    -- ★★ v8.9.0: line() 现在【同时】把内容收进缓冲 —— 扫描结束时把【全部十层】拆成多个 txt,
    --   落到「桌面\CheatMenu\<服务器名>\」。控制台照旧打印(不再需要靠控制台看全部, 它本来也只显示前 60 条)。
    -- ★★ v9.2.0 落盘缓冲统一到 SYS 上 —— 这样【后面的 head()/分组标题】也能抄进来。
    --   用户实测暴露: 单文件里【十层的分节标题一条都没有】, 因为 head() 走的是 print 而不是 line(),
    --   绕过了缓冲。现在所有"要进落盘文件"的输出都走 SYS.ScanBufNote()。
    SYS.ScanBuf={}
    function SYS.ScanBufNote(s) SYS.ScanBuf[#SYS.ScanBuf+1]=tostring(s) end

    -- ★★ 9.8.1 新增: 「控制台 + 落盘」二合一输出。
    --   起因(用户报「还少了」): B 代码层 / C 脚本层用的还是**裸 `print(table.concat(out,"\n"))`**,
    --   绕过了扫描缓冲 ⇒ 落盘文件里【整层缺失】。凡是"要进那唯一一个 txt"的输出都必须走这里。
    --   ⚠ 在综合扫描之外调用(没有 SYS.ScanOutFile)时, 它就等于一个普通 print。
    function SYS.ScanEmit(s)
        print(s)
        if SYS.ScanOutFile and SYS.ScanBuf then
            SYS.ScanBuf[#SYS.ScanBuf+1]=tostring(s)
        end
    end

    local DumpBuf = SYS.ScanBuf                       -- 兼容旧引用(同一张表)
    local function line(s)
        print("  "..s)
        SYS.ScanBufNote("  "..s)
    end
    local function head(s)
        local t="════════ "..s.." ════════"
        print(""); print(t)
        SYS.ScanBufNote(""); SYS.ScanBufNote(t)
    end

    --##########################################################################
    --# ★★ 新增 I 层 · DEX(实例浏览器效果) + J 层 · Remote(每条通道能不能用)
    --#   为什么要"融合进综合扫描"而不是各做一个按钮:
    --#     两层都要**全图遍历** game。做成两个按钮 = 用户点两次 = 全图走两遍。
    --#     现在共用一次 scanWholeGame(), I/J 同吃一份结果 —— 一个按钮、一遍遍历、两个层的结论。
    --#
    --#   ⛔ 铁律遵守: 全程【零 __namecall】。本层只用 GetChildren / ClassName /
    --#     GetFullName / 属性只读 / getconnections(只读枚举) ——
    --#     绝不挂元方法总入口去抓 FireServer(那是本项目明令否掉的"开过检测卡顿掉帧"病根)。
    --#     诚实边界: 这样能安全看到的是【服务器→我】这一向(谁在收);
    --#     我→服务器那一向本来就是本脚本自己发的, 不需要 spy。
    --##########################################################################
    -- ★ v9.9.8: 原来的 `SCAN_CAP=80000` 计数上限【已废弃】—— 见下面 scanWholeGame 的说明:
    --   改成"分帧可续跑"后不再需要按计数截断(只留一个极高的应急上限防内存失控)。
    local NET_CLS={                 -- 跨网络的通道(能真正影响服务端的就这几类)
        "RemoteEvent","UnreliableRemoteEvent","RemoteFunction",
    }
    local DEX_KEY={                 -- 关键类: "能做的事"和"代码在哪"都落在这几类上
        "RemoteEvent","UnreliableRemoteEvent","RemoteFunction",
        "BindableEvent","BindableFunction",
        "Script","LocalScript","ModuleScript",
        "ProximityPrompt","ClickDetector","Highlight","SurfaceGui",
    }
    -- 属性快照要看的字段(DEX 的 Properties 面板效果)。
    -- ★ 名字写错/该实例没有这个属性 -> 被 pcall 吃掉、直接不打印, 不会报错也不会编造。
    local DEX_PROPS={
        ProximityPrompt={"ActionText","ObjectText","HoldDuration","MaxActivationDistance","Enabled","RequiresLineOfSight"},
        ClickDetector={"MaxActivationDistance"},
        Highlight={"Enabled","FillColor","OutlineColor","FillTransparency","OutlineTransparency","DepthMode"},
        SurfaceGui={"Enabled","Face","LightInfluence","AlwaysOnTop","MaxDistance"},
        Script={"Enabled","RunContext"},
        LocalScript={"Enabled"},
    }

    -- ★★★ v9.9.8 全图遍历改成【分帧可续跑】—— 用户原话:「抓完不卡 可以慢慢抓」。
    --   旧实现是【一次性同步 BFS】+ 80000 计数上限: 要么一帧卡很久, 要么抓不完就截断。
    --   现在: 队列与游标做成【跨帧状态】, 每帧只跑一小段(默认 8ms)就让出, 直到走完整棵树。
    --   ⇒ 能【抓完】, 而且【不卡帧】; 单次扫描只是慢一点(几帧~几百毫秒), 这正是用户要的取舍。
    -- ★ 2026-09-22 用户要求「400000 多加的点, 以防又上限, 翻倍下」⇒ 翻倍到 800000。
    --   ⚠ 这个数的性质要说清: 它**不是**"能抓到的上限", 而是**防内存失控的紧急闸门** ——
    --   遍历本身已经不按计数截断了(分帧可续跑), 所以正常地图无论多大都会抓完。
    --   代价只在这里: 80 万个 Instance 引用常驻一张表, 内存大约几十 MB。真遇到更强的图,
    --   要么继续调大、要么改成"边扫边出报告"(不复用整份列表) —— 后者才是根治, 但要改调用方。
    local SCAN_EMERGENCY=800000
    local SCAN={q=nil,i=0,n=0,done=false,capped=false}
    local function scanBegin()
        SCAN.q={game} SCAN.i=1 SCAN.n=0 SCAN.done=false SCAN.capped=false
    end
    --- 推进一段; 返回 true=已走完(或撞应急上限)。budget=本段最多占用多少秒。
    local function scanStep(budget)
        if SCAN.done then return true end
        if not SCAN.q then scanBegin() end
        local out=SCAN.q
        local t0=os.clock()
        while SCAN.i<=#out do
            local inst=out[SCAN.i] SCAN.i=SCAN.i+1
            local okc,ch=P(function() return inst:GetChildren() end)
            if okc and type(ch)=="table" then
                local m=#out
                for k=1,#ch do m=m+1 out[m]=ch[k] end
                SCAN.n=SCAN.n+#ch
                if SCAN.n>=SCAN_EMERGENCY then
                    SCAN.capped=true SCAN.done=true return true
                end
            end
            if (os.clock()-t0)>=budget then return false end      -- 本段用完, 让出
        end
        SCAN.done=true
        return true
    end
    -- 全图遍历。I 层与 J 层共用 —— 这是"融合成一个功能"的落点。
    --   能在协程里跑就分帧(不卡帧); 万一在不能让出的上下文被调用, 退回"一次跑完"但仍然【不按计数截断】。
    local function scanWholeGame()
        scanBegin()
        local yieldOK=false
        P(function()
            if type(coroutine)=="table" and type(coroutine.isyieldable)=="function" then
                yieldOK=coroutine.isyieldable()
            end
        end)
        if yieldOK then
            while not scanStep(0.008) do task.wait() end
        else
            while not scanStep(0.05) do end
        end
        return SCAN.q,SCAN.n,SCAN.capped,true
    end

    -- 取一片属性。属性不存在就跳过(不报错、不编造)。
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

    -- 名字 -> 功能类别 索引(供 J 层给每条 remote 打标签; 预建一次, 不在循环里遍历 34 类)
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

    -- ① DEX 层: 全图实例浏览器
    function LAB.DexScan(shared, sharedN, sharedCapped)
        head("I · DEX 层(全图实例浏览器: 游戏里都有哪些东西 / 在哪)")
        local list,n,capped,ok
        if shared then list,n,capped,ok=shared,sharedN or 0,sharedCapped or false,true
        else list,n,capped,ok=scanWholeGame() end
        if not ok then line("!! 全图遍历中断(某实例 GetChildren 抛错) —— 下面是已扫到的部分") end

        -- ①-1 类名直方图: 哪一类最多, 哪里就是主战场
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
        -- ★ v9.9.8 修: 原句是 `(遍历上限 %d)` 且吃 SCAN_CAP —— 而 SCAN_CAP 已被删除(改分帧遍历),
        --   传 nil 给 %d 会【运行时直接报错】把 DEX 层打挂。现在只在真的撞上应急上限时提示,
        --   并且措辞改准(那不是"遍历上限", 是防内存失控的闸门)。
        line(("全图实例 %d 个%s · 共 %d 种 ClassName")
            :format(n, capped and " · 已达应急上限(数据可能不全)" or "", #rows))
        line("  ── 类名 TOP 60 ──")
        for i=1,math.min(#rows,60) do
            line(("    %-9d %s"):format(rows[i][2],rows[i][1]))
        end

        -- ①-2 关键类全路径(每类最多列 12 条, 完整清单落盘)
        local want={}
        for _,k in ipairs(DEX_KEY) do want[k]={} end
        for i=1,#list do
            local w=want[list[i].ClassName]
            if w and #w<40 then w[#w+1]=list[i] end
        end
        local dump={("========== 类名全量(共 %d 种) =========="):format(#rows)}
        for i=1,#rows do dump[#dump+1]=("%-9d %s"):format(rows[i][2],rows[i][1]) end
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
                    -- ★★ v9.4.0 控制台省略, 但【落盘文件补全】(用户: 一个 txt 可以无限放, 怕什么)
                    SYS.ScanBufNote("        ── 以下为完整清单(控制台已省略) ──")
                    for i=13,#hits do
                        local okp2,path2=P(function() return hits[i]:GetFullName() end)
                        local p2=tostring(okp2 and path2 or "?")
                        SYS.ScanBufNote(("        %s"):format(p2))
                        dump[#dump+1]=("%s  %s"):format(k,p2)
                    end
                end
            end
        end

        -- ①-3 属性快照(每类取第一个实例)
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

    -- ② Remote 层: 每条通道能不能用 / 谁在收
    function LAB.RemoteScan(shared, sharedN, sharedCapped)
        head("J · Remote 层(每条 remote 能不能用 · 谁在收)")
        local list,n,capped,ok
        if shared then list,n,capped,ok=shared,sharedN or 0,sharedCapped or false,true
        else list,n,capped,ok=scanWholeGame() end
        if not ok then line("!! 全图遍历中断 —— 下面是已扫到的部分") end

        -- ②-1 分类统计(★ 补上原来 DumpRemotes 漏掉的 UnreliableRemoteEvent)
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

        -- ②-2 逐条侦察: 收向监听数 + 谁在收(只读) + 命中我们哪个功能类别
        local gi=_G.getconnections
        local hasGc=(type(gi)=="function")
        if not hasGc then
            line("  (这台执行器没有 getconnections —— 跳过「谁在收」, 只列清单与归类)")
        end
        local nameKind=kindIndex()
        local riskyN=0
        local dump={("========== Remote 逐条侦察(共 %d 条, 列前 60) =========="):format(#net)}
        local withRecv=0
        local MAXROW=60
        -- ★★ v9.4.0 控制台只显示前 MAXROW 条, 但【每一条都进落盘文件】(文件不截断)
        local function row(s,i) if i<=MAXROW then line(s) else SYS.ScanBufNote(s) end end
        for i=1,#net do
            local r=net[i]
            local cls=r.ClassName
            local okp,path=P(function() return r:GetFullName() end)
            local p=tostring(okp and path or "?")
            local tail=(type(r.Name)=="string") and r.Name or "?"
            local tag=nameKind[tail] and ("  ★命中类别: "..tostring(nameKind[tail])) or ""
            -- ★ v9.9.3: 同 A 层, 高风险通道就地标注(蜜罐 / 管理后台 / 审计)
            local risk=SYS.RemoteRisk(tail)
            if risk then
                riskyN=riskyN+1
                tag=tag.."\n            "..risk
            end

            -- 收向监听: 只对 RemoteEvent 系(OnClientEvent 是真事件);
            -- RemoteFunction 的 OnClientInvoke 是"可赋值回调", 不是事件, 单独判有没有被设置。
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

            row(("    [%d] %-22s %s"):format(i,cls,p),i)
            row(("          收向监听: %s%s"):format(tostring(recv),tag),i)
            dump[#dump+1]=("[%d] %s  %s"):format(i,cls,p)
            dump[#dump+1]=("     收向监听: "..tostring(recv)..tag)
        end
        if #net>MAXROW then line(("    … 还有 %d 条(完整清单见落盘文件)"):format(#net-MAXROW)) end

        -- ②-3 功能类别对账: 我们 34 个类别, 这个游戏到底有几条通道是真存在的
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
            if riskyN>0 then
                line(("  ⚠ 另有 %d 条通道被判为高风险(蜜罐/管理后台/审计日志) —— 只在清单里标出, 别触发"):format(riskyN))
            end
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
        -- ★★ 9.8.0 修(实测 bug —— 用户报「综合扫描失效了, 就扫描几个东西」的真因):
        --   这里原来是 `SYS.ScanBuf={}` —— 【换了一张新表】。但模块级 `local DumpBuf=SYS.ScanBuf`
        --   在脚本加载时就绑定到了【旧表】。于是扫描全程 line()/head() 把十层内容写进新表,
        --   结尾 `SYS.DumpScanAll(DumpBuf)` 却仍然拿【旧表】(空) ⇒ 落盘的 txt 只剩 6 行文件头、
        --   "-- 共 0 行", 控制台又只显示前 60 行 ⇒ 看起来"就扫了几个东西"。
        --   改成【清空同一张表】, DumpBuf 的别名永远有效。
        if type(table.clear)=="function" then table.clear(SYS.ScanBuf)
        else for i=#SYS.ScanBuf,1,-1 do SYS.ScanBuf[i]=nil end end
        local _banner={"","##################  🔍 综合扫描  ##################",
                       ("时间 %s"):format(os.date("%H:%M:%S")),""}
        for _,x in ipairs(_banner) do print(x) SYS.ScanBufNote(x) end
        -- ★★ v8.11.0: 先把【落盘目录】解析出来并打出来 —— 不用等扫完就知道文件会去哪。
        --   用户问过「落盘在电脑桌面吗 / 没到我要的位置吗」—— 这里给个一眼可见的答案。
        --   解析失败也不中断扫描, 只是把"试过哪些路径"先摆出来。
        pcall(function() SYS.ResolveScanDir() end)
        -- ★★ v9.1.0: 文件名在这里【一次定死】—— 中途 DexScan/RemoteScan 会向 SaveDump 要"落盘文件名",
        --   统一返回这一个 ⇒ 全程只产生【一个】txt（不再有 DEX_*.txt / Remote_*.txt 那些带中文的乱码名文件）。
        SYS.ScanOutExtra=nil
        local _info,_nm,_pid=SYS.GameInfoLine()
        -- ★★ v9.4.0 按用户要求: **同一台服务器固定一个文件名**(重扫就覆盖旧的, 不再累积一堆带时间戳的)
        --   旧的那份会先备份成 `xxx.prev.txt`, 所以"内容不同"时也没丢。
        SYS.ScanOutFile=("scan_%s.txt"):format(SYS.SafeAscii(_pid,20))
        if SYS.ScanOutDir then
            local m1=("  📂 落盘目录: %s   （%s）"):format(tostring(SYS.ScanOutDir),tostring(SYS.ScanOutWhy))
            local m2=("     单文件名: %s   （全部十一层都在里面）"):format(tostring(SYS.ScanOutFile))
            print(m1) print(m2) SYS.ScanBufNote(m1) SYS.ScanBufNote(m2)
        else
            local m1=("  ⚠ 落盘目录暂时定不下来: %s"):format(tostring(SYS.ScanOutWhy))
            print(m1) SYS.ScanBufNote(m1)
        end
        print("") SYS.ScanBufNote("")

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
                    -- ★★ v9.2.0: 这一行原来只用 print -> 落盘文件里缺了 J 层的分组标题
                    local _gh=("  ── %s (%d) ──"):format(g[1],#hits)
                    print(_gh) SYS.ScanBufNote(_gh)
                    -- ★★ v9.4.0 控制台列 14 条, 落盘文件列全部
                    for x=1,#hits do
                        if x<=14 then line(hits[x]) else SYS.ScanBufNote("  "..tostring(hits[x])) end
                    end
                    if #hits>14 then line(("... 还有 %d 个(文件里有全部)"):format(#hits-14)) end
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
            else
                -- ★★★ v9.9.9 补强: 没有 getnilinstances 时用 getgc 兜底。
                --   从 GC 里找【Parent 为 nil 的实例】—— 被 Destroy() 但还被脚本引用着的对象、
                --   以及游戏刻意"摘下来藏起来"的对象都在这里(它们不在 GetDescendants 里, 所以
                --   常规遍历永远看不到)。Real 这台执行器正好没有 getnilinstances, 抓包实测如此。
                local g=_G.getgc or _G.getGC
                if type(g)=="function" then
                    local found=0
                    local shownN=0
                    local t0=os.clock()
                    P(function()
                        for _,v in pairs(g(true)) do
                            if os.clock()-t0>1.5 then break end          -- 时间预算: 别把帧拖死
                            if typeof(v)=="Instance" then
                                local par=nil
                                pcall(function() par=v.Parent end)
                                if par==nil then
                                    found=found+1
                                    if shownN<18 then
                                        local cls,nm="?","?"
                                        pcall(function() cls=v.ClassName end)
                                        pcall(function() nm=v.Name end)
                                        line(("  · %-22s %s"):format(tostring(cls),tostring(nm)))
                                        shownN=shownN+1
                                    end
                                end
                            end
                        end
                    end)
                    line(("getgc 兜底: 找到 %d 个【父级为 nil 的实例】(getnilinstances 不可用时的替代)"):format(found))
                    if found>shownN then line(("  ... 其余 %d 个(完整属性要看的话用它自己的 GetFullName 已不可用, 只能看类名/名字)"):format(found-shownN)) end
                else
                    line("(没有 getnilinstances, 也没有 getgc —— 这一层拿不到)")
                end
            end
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
            -- ★★★ v9.9.9 补强: 不只玩家 —— 游戏也把状态挂在【关键实例】上(关卡/怪物/机关/载具…)。
            --   扫 Workspace 下带 Attribute 的 Model/BasePart, 只留【名字或属性名像状态】的,
            --   免得把一堆装饰件也列出来。控制台前 40 条, 其余全量落盘 + 时间预算。
            P(function()
                local shown,scanned,found=0,0,0
                local AKEY={"stage","phase","state","hp","health","damage","team","owner","target",
                            "objective","round","wave","locked","open","active","timer","spawn",
                            "阶段","状态","血","倒计"}
                local _t=os.clock()
                for _,v in ipairs(SYS.Index()) do
                    if os.clock()-_t>0.6 then break end
                    local c=v.ClassName
                    if c=="Model" or v:IsA("BasePart") then
                        scanned=scanned+1
                        local okA,attrs=P(function() return v:GetAttributes() end)
                        if okA and type(attrs)=="table" then
                            local ks={}
                            for k,_ in pairs(attrs) do ks[#ks+1]=k end
                            if #ks>0 then
                                local nm=type(v.Name)=="string" and v.Name:lower() or ""
                                local hot=false
                                for i=1,#AKEY do
                                    local kw=AKEY[i]
                                    if nm:find(kw,1,true) then hot=true break end
                                    for j=1,#ks do
                                        if tostring(ks[j]):lower():find(kw,1,true) then hot=true break end
                                    end
                                    if hot then break end
                                end
                                if hot then
                                    found=found+1
                                    table.sort(ks)
                                    local okp,path=P(function() return v:GetFullName() end)
                                    local hdr=("  · %s"):format(tostring(okp and path or v.Name))
                                    if shown<40 then line(hdr) shown=shown+1 else SYS.ScanBufNote(hdr) end
                                    for j=1,#ks do
                                        local kv,av=P(function() return v:GetAttribute(ks[j]) end)
                                        local r=("      %-18s = %s"):format(tostring(ks[j]),tostring(kv and av or "?"))
                                        if shown<=40 then line(r) else SYS.ScanBufNote(r) end
                                    end
                                end
                            end
                        end
                    end
                end
                line(("非玩家实例带 Attribute 的命中 %d 个(扫了 %d 个 Model/BasePart; 耗时 %.2fs; 控制台显示前 40)"):format(found,scanned,os.clock()-_t))
            end)
        end)
        if not okE then line("!! 数据层扫描异常") end

        -- ── K 值对象层(★ v9.9.9 新增): 游戏状态最常藏在 Value 对象里 ──
        --   为什么加这一层: 机器派对抓包实测有 Vector3Value 4536 / IntValue 2614 / StringValue 1300 /
        --   NumberValue 1136 —— 近万个值对象, 里面往往就是【阶段/计时/分数/目标/血量】这类内部状态。
        --   原十层里只有 I 层列了"类名个数", 从没列过【值本身】⇒ 这一层专门把它们打开看。
        --   ★ 过滤: 只列【名字命中状态关键字】的 + 全部 ObjectValue(它指向对象, 信息量大);
        --     其余按类计数。命中的完整清单全落盘(不受控制台条数限制)。
        head("K · 值对象层(Value 对象里的游戏状态)")
        local okK=P(function()
            local VCLS={IntValue=1,NumberValue=1,StringValue=1,BoolValue=1,Vector3Value=1,
                        CFrameValue=1,ObjectValue=1,Color3Value=1,BrickColorValue=1,RayValue=1}
            local KEY={"stage","phase","state","timer","time","round","wave","score","point","coin",
                       "cash","money","hp","health","damage","target","objective","level","progress",
                       "count","left","remain","spawn","door","room","阶段","计时","分数","目标","血","倒计"}
            local rows,byCls,all,hot= {}, {}, 0, 0
            local _t0=os.clock()
            for _,v in ipairs(SYS.Index()) do
                if os.clock()-_t0>0.6 then break end
                local c=v.ClassName
                if VCLS[c] then
                    all=all+1
                    byCls[c]=(byCls[c] or 0)+1
                    local nm=type(v.Name)=="string" and v.Name or ""
                    local low=nm:lower()
                    local hit=false
                    for i=1,#KEY do if low:find(KEY[i],1,true) then hit=true break end end
                    if hit or c=="ObjectValue" then
                        hot=hot+1
                        local okv,val=P(function() return v.Value end)
                        local s=tostring(okv and val or "?")
                        if #s>64 then s=s:sub(1,64).."…" end
                        local okp,path=P(function() return v:GetFullName() end)
                        rows[#rows+1]=("  %-14s %-26s = %s"):format(c,nm:sub(1,26),s)
                        rows[#rows+1]=("        @ "..tostring(okp and path or "(取不到完整路径)"))
                    end
                end
            end
            local cs={}
            for k,n in pairs(byCls) do cs[#cs+1]=("%s×%d"):format(k,n) end
            table.sort(cs)
            line(("值对象共 %d 个 · 分类: %s   [扫完耗时 %.2fs ｜ 超过 0.6s 会被截断, 看这个数就知道全不全]"):format(all,table.concat(cs," · "),os.clock()-_t0))
            line(("名字命中状态关键字的 %d 个(下列全量落盘, 控制台只显示前 40 条):"):format(hot))
            if hot==0 then
                line("(没有名字命中状态关键字的值对象 —— 这游戏的内部状态可能不在 Value 里, 或用了中性名)")
            else
                for i=1,#rows do
                    if i<=40 then line(rows[i]) else SYS.ScanBufNote(rows[i]) end
                end
            end
        end)
        if not okK then line("!! 值对象层扫描异常") end

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
                -- ★ 9.9.2: 这里扫描线程里拿到 nil 是【正常的】, 旧输出只有孤零零一行 nil,
                --   容易被当成"反查失败"。它只有在 hook 回调内部调用才会有调用者。
                if ok2 and s==nil then
                    line("  (只有在 hook 回调内部调用才有调用者; 这里是扫描线程, nil 属正常)")
                end
            else line("(这台执行器没有 getcallingscript)") end
            -- 挑一个可疑函数看它"闭包里有什么"(upvalue 名 + 值概要)
            local fns=LAB.LastFns
            if fns and #fns>0 then
                local f=fns[1]
                -- ★ 9.9.2: 先说清楚"这是哪个函数的闭包" —— 以前直接开列 upvalue,
                --   用户根本不知道看的是谁(实测出来往往是 CoreGui 的聊天模块, 跟游戏无关)。
                local src=""
                P(function()
                    if type(debug)=="table" and type(debug.info)=="function" then
                        src=tostring(debug.info(f,"s") or "")
                    end
                end)
                line(("  被查函数: %s%s"):format(tostring(f),
                    (src~="" and src~="nil") and ("   来源="..src) or ""))
                local okU=P(function()
                    if type(debug)=="table" and type(debug.getupvalue)=="function" then
                        local i,cnt=1,0
                        while true do
                            -- ★ 逐个下标单独兜错: 有的执行器越界会【直接抛错】而不是返回 nil,
                            --   旧代码把整个 while 包在一个 pcall 里, 一抛就"全部失真"(下面整段
                            --   退化成一行"(读 upvalue 失败)")。现在最多停在当前这个。
                            local ok,first,second=pcall(function()
                                return debug.getupvalue(f,i)
                            end)
                            if not ok then
                                line(("    (第 %d 个读取失败: %s)"):format(i,tostring(first)))
                                break
                            end
                            if first==nil and second==nil then break end
                            -- ★★ 返回值约定兼容 —— 这条是 v9.9.2 修的真 bug:
                            --   标准 Lua 的 debug.getupvalue 返回 (名字, 值);
                            --   但不少执行器(用户这台就是)同名函数【只返回值】/返回(值,名字),
                            --   旧代码一律按 (名字,值) 解 => 名字列打印出 `table: 0x…`、
                            --   `CoreGui…maybeAssert`、`6` 这些【值】, 而值列整列全是 nil ——
                            --   看着像"读到了", 其实一列全错。
                            local nm,val=first,second
                            if type(nm)~="string" then nm,val=nil,first end
                            cnt=cnt+1
                            if cnt<=12 then
                                local vs=tostring(val)
                                if #vs>60 then vs=vs:sub(1,60).."…" end
                                line(("    upvalue[%d] %-26s = %s"):format(i,
                                    nm or "(执行器不暴露名字)", vs))
                            end
                            i=i+1
                            if i>60 then line("    (upvalue 超过 60 个, 到此为止)") break end
                        end
                        line(("(该函数共 %d 个 upvalue)"):format(cnt))
                    else line("(这台执行器没有 debug.getupvalue)") end
                end)
                if not okU then line("(读 upvalue 失败)") end
            else
                line("(LAB GC 扫描没有留下可选的函数)") 
            end
        end)

        -- ── I · DEX 层 + J · Remote 层(新增) ──
        --   ★ 两层共用【同一次】全图遍历: 融合在一个按钮里, 不为两个层把整个游戏走两遍。
        local shared,sharedN,sharedCapped=scanWholeGame()
        P(function() LAB.DexScan(shared,sharedN,sharedCapped) end)
        P(function() LAB.RemoteScan(shared,sharedN,sharedCapped) end)

        print(""); print(("##################  扫描完毕 (%.2fs)  ##################"):format(os.clock()-t0))
        -- ★★ v8.10.0 全部十层落盘到「桌面\CheatMenu\<服务器名>\」下的【一个】txt
        --   用户要求:「把全部抓到的 自动发到电脑桌面 然后文件夹是服务器的名字」+「不要分多个txt 就放一个里面」
        local w,why,dir=SYS.DumpScanAll(DumpBuf)
        if w and #w>0 then
            local full=tostring(dir).."\\"..tostring(w[1])
            print("  ✅ 已落盘（单个 txt，含全部十一层）: "..full)
            SYS.Notify(("综合扫描完成 —— 全部内容已写进一个 txt：\n%s"):format(full),SYS.CY.green)
        else
            print("  ⚠ 落盘失败: "..tostring(why or "未知").."（控制台只显示前 60 条, 其余看不到）")
            SYS.Notify("综合扫描完成 —— 结果在控制台(F9)。落盘失败: "..tostring(why or "?"),SYS.CY.yellow)
        end
    end

    -- 一键复制摘要
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

end

UI.Pages["传送"]=function(p)
    UI.Section(p,"🖱 鼠标传送 · 快速跳转",CY.accent)
    UI.Switch(p,"允许鼠标传送 (T)","TPEnabled")
    UI.Btn(p,"传送到鼠标位置",CY.cyan,SYS.TPToMouse)
    UI.Btn(p,"传送到最近玩家",CY.cyan,SYS.TPToNearest)
    -- ★ v3.9.0 恢复观战: 停止观战按钮(观战入口在下方「玩家列表」右键)
    UI.Btn(p,"停止观战 (回自己视角)",CY.orange,SYS.StopSpectate)
    UI.Btn(p,"回到主城",CY.green,function() SYS.TPTo(SYS.GetDefSpawn()) end)
    -- ★★ v6.9.24 恢复: 保存当前坐标
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
    -- ★★ v6.9.24 恢复: 自动回点距离 + Ctrl+数字 直达保存点
    UI.Slider(p,"自动回点距离 (离开保存点超过它就传送回去)",1,50,1,function() return SYS.C_.AutoTPDist end,function(v) SYS.C_.AutoTPDist=v end,"%.0f")
    -- ★ v6.6.0 融合自 ChronixHub 路径点页: Ctrl+数字 直达传送
    UI.Switch(p,"⌨ Ctrl+数字 直达保存点","PathKey",SYS.SetPathKey)
    UI.Tip(p,"按住 Ctrl 再按数字键 1~9 -> 直接传送到下面「已保存位置」里对应的那一条(主键盘/小键盘都认)。\n只对前 9 个生效; 那一条还不存在时会在屏幕上提示。默认关(避免误触)。",CY.sub)

    UI.Section(p,"👥 玩家列表",CY.cyan)
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


    -- ★★ v6.9.24 恢复(用户: "坐标保存和tp坐标不要删除 恢复") —— 已保存位置列表
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
    UI.Section(p,"📊 实时状态",CY.accent)
    local card,inner=UI.Card(p,175)
    local _,targetV=UI.Stat(inner,"当前目标","—")
    local _,wantV=UI.Stat(inner,"指定目标","自动")
    local _,lockV=UI.Stat(inner,"锁定状态","未锁定")
    local _,aimV=UI.Stat(inner,"瞄准方式","关闭")
    local _,distV=UI.Stat(inner,"距离","—")
    local _,perfV=UI.Stat(inner,"循环频率(选人/开火)","—")

    --========== 一键 ==========
    UI.Section(p,"⚔ 一键开战 / 停战",CY.green)
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
    UI.Section(p,"🎯 瞄准 (自动瞄准 / 关闭)",CY.accent)
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
    -- ★★ v6.9.16 新增(用户要求"360 有人就杀"): 不管目标在哪个方向、隔不隔墙, 只要在距离内就锁定,
    --   并且开火前把相机+角色【瞬时】对准它 —— 不看准星、也不怕"打了没伤害"。
    --   想更狠可以把下面的「只打视野内」关掉(这条本身就忽略它)。
    UI.Switch(p,"🎯 360 无死角 (有人就锁就打 · 不看方向/视野)","CB_360")
    -- ★★ v6.9.21(用户: "无延迟不是功能, 是给那些自动开火和索敌速度啥的设置 0ms 的"):
    --   原来的「无延迟模式」开关删掉, 改成把【参数下限放开】—— 下面这个滑块设 0 = 每帧索敌(秒锁),
    --   配合开火间隔设 0 = 每帧开火, 就是完整的"无延迟"。
    UI.Slider(p,"索敌间隔 (毫秒 · 0=每帧秒锁)",0,200,1,
        function() return SYS.C_.CB_ScanMs or 33 end,
        function(v) SYS.C_.CB_ScanMs=v QueueSave() end,"%.0f")

    -- ★ v77: 「锁人速度」三档已删 —— 它只调快照瞄准的转向限流(单次转角/最小间隔/转向后延迟),
    --   快照都删了, 留着只会让人不知道该调哪个。"背身快不快"现在由「跟随速度」决定。

    UI.Cycle(p,"瞄准部位",{"头","身","自动(离准星最近)"},
        function() return ({"头","身","自动(离准星最近)"})[SYS.C_.CB_AimPart or 2] end,
        function(v) SYS.C_.CB_AimPart = (v=="头") and 1 or ((v=="身") and 2 or 3) end)
    UI.Switch(p,"📐 预测瞄准 (算目标移动的提前量)","CB_Predict")
    UI.Tip(p,"★ v8.7.0 起【默认打开】—— 打移动目标必须有它，不然等于永远瞄他上一帧的位置。"..
        "提前量会随距离自动放大（越远补得越多，最多 3 倍）；速度取不到时退回用人形的移动方向估。",CY.sub)
    UI.Slider(p,"预测提前量 (秒 · 目标越快调越大)",0.05,0.60,0.01,
        function() return SYS.C_.CB_PredictTime end,
        function(v) SYS.C_.CB_PredictTime=v end,"%.2f")
    -- ★★ v7.8.4 抛射物弹道预判(用户: "对于 fps 射击类的 有用就能")。
    --   和上面那条是【两条独立路径】, 谁开谁生效, 互不覆盖:
    --     · 瞬发枪械(hitscan, 一扣扳机即刻判定) -> 用「📐 预测瞄准」;
    --     · 有飞行时间 + 会下坠的武器(弓/火箭/手雷/投掷物) -> 打开这个。
    --   默认关; 关着的时候上面那条线性提前量的行为【一模一样】, 不影响老配置。
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
    -- ★★ v6.9.17 删掉「命中率 / 漏打模式」(用户: "漏打模式不需要偏移, 开了就是最对准"):
    --   这两个原来都会【故意打偏】—— 命中率让部分帧不转相机(手抖感), 漏打模式按概率跳过开火。
    --   你要的是"开了就最准", 所以整套移除: 现在瞄准每帧都转、开火不做任何概率跳过。
    UI.Tip(p,"★ 已移除「命中率 / 漏打模式」—— 不再有任何「故意打偏」, 开了就是最准。\n★ 平滑度/预判量/索敌半径已经在上面 —— 对应「跟随速度 / 预测提前量 / 索敌范围」, 不再重复给控件。\n★ 「粘性瞄准(锁定保持)」你早前明确删过, 这次没有加回来 —— 需要的话单独说。",CY.yellow)

    UI.Div(p)
    --========== 开火 ==========
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
    --========== 打谁 ==========
    UI.Section(p,"🧭 打谁 · 选人规则",CY.purple)
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
    UI.Tip(p,"★ v8.7.0 修：这条【不再被「索敌间隔」影响】。\n"..
        "以前把索敌间隔设成 0（每帧秒锁）会连带【不判视线】→ 隔墙也会锁人。现在两件事解耦：\n"..
        "间隔只管「扫多快」，视线只看这个开关。真要无视墙请用「子弹穿墙」或「360 无死角」。",CY.sub)
    UI.Switch(p,"🚶 移动时暂停瞄准 (按 WASD 让出相机)","CB_PauseMove")
    -- ★★ v9.5.0 隐蔽模式（用户要求: 可以加, 但必须给开关）
    UI.Switch(p,"🙈 隐蔽模式 (不做开火前瞬时对准)","CB_Stealth")
    UI.Tip(p,"★ 两者是【命中率 ↔ 不显眼】的取舍, 你按需要选:\n"
        .. "  关(默认) = 扣扳机那一帧把相机瞬时对准目标 -> 命中率高, 但相机会有一次跳变。\n"
        .. "  开       = 不跳, 改成「等准星自己压上去才开火」-> 少一次机器特征, 命中率略降。\n"
        .. "★ 为什么要给这个开关: 本脚本的反指纹自检里 D8「相机行为」和 D7「开火节奏」\n"
        .. "  正是在盯「相机有没有异常跳变 / 开火间隔是不是太规律」—— 想稳就把隐蔽模式打开。",CY.sub)
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
    UI.Section(p,"☢ 高风险瞄准 (默认全关 · 需要才开)",CY.red)
    -- ★★ v6.11 用户要求: 把"高风险行为"的封号风险提示放进这个高风险区
    UI.Switch(p,"🧱 表现层对抗 (禁布娃娃/物理状态 · 纯本地)","BlockHandlers",SYS.SetBlockHandlers)
    UI.Tip(p,"⚠ 封号风险自查(由高到低):\n"..
        "① 在【热门服】飞天 / 瞬移 / 乱杀 = 最高 —— 会被其他玩家举报 -> 人工复核, 任何绕过都藏不住行为;\n"..
        "② 自动打人 / 自动农场 = 高(服务端行为统计能看出规律);  ③ 纯视觉(透视 / 光照 / 屏蔽表现) = 最低。\n"..
        "🧱 表现层对抗 = 禁布娃娃 / 物理 / 平台站立状态(纯本地, 不影响别人)。\n"..
        "⚠ 本执行器【没有 getconnections】, 做不到「让游戏根本不播」跳脸 / 震屏 —— 只能事后对抗状态。\n"..
        -- ★★ v6.11 新增: 现代客户端反作弊到底在查什么(取自 2026-09 公开反作弊 Zenith 的能力清单)。
        --   只做"提示", 不改任何功能行为 —— 你知道它在看什么, 自己决定怎么用。
        "— 现代反作弊在查什么(2026-09 公开清单, 知道=能避):\n"..
        "  · 服务端侧: 飞行(CFrame/载具/座位) · 移速与速度异常 · 位置/传送校验 · 穿墙碰撞 · 多工具/背包利用 · 角色物理完整性;\n"..
        "  · 客户端侧: __namecall/__index/__newindex 被 hook · 元表被改(setreadonly/getrawmetatable) · 函数被 hook(debug.info/getfenv/hookfunction) · CoreGui 注入 · gcinfo/collectgarbage 伪装 · 弱表操纵;\n"..
        "  · 战斗侧: 静默瞄准的弹道分析 · 命中盒扩张 · 近战/射程超限;\n"..
        "  · 网络侧: Remote 速率限制 · 远程方法 hook 检测 · 挑战-应答令牌。\n"..
        "⇒ 直接推论: 本菜单把『管理员检测绕过』改成【不 hook __namecall、只挪进隐藏容器】是对的;\n"..
        "  自动开火间隔带 ±20% 抖动也是对的(恒定节奏最容易被速率统计抓)。这两条别改回去。",CY.yellow)
    UI.Switch(p,"🙈 真·静默 (不转相机/不转角色, 只改射线命中)","CB_SilentNoTurn",function(on)
        SYS.T_.CB_SilentAim = on and true or false      -- 后端读的还是这个键, 保持语义一致
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
    -- ★★ v9.4.0 服务端战斗数据（FPS 服扫描新发现的权威通道, 先记录后接判据）
    UI.Btn(p,"📡 看服务端战斗数据 (控制台)",CY.purple,function()
        print("[Combat] ===== 服务端战斗数据（只记录, 未接判据） =====")
        pcall(function() SYS.Combat.DumpSrv() end)
        SYS.Notify("📡 已打到控制台(F9) —— 把这几行发我，我按真实参数接成判据",SYS.CY.purple)
    end)
    UI.Tip(p,"★ 服务端战斗数据 = 综合扫描新发现的 3 条【权威输入】(FPS 服):\n"
        .. "  · EntityService.BeDamagedUnreliable（命中确认）\n"
        .. "  · EntityService.DamageShield / DamageImmunity（权威无敌盾）\n"
        .. "  · CombatService.Ammo（真实弹药）\n"
        .. "现在【只记录不改行为】—— 因为这三条的参数格式还没实机见过，猜着当判据会把原来能打中的也打不中。\n"
        .. "你玩一局 -> 点上面那个按钮 -> 把控制台几行发我，我就按真实参数把它们接成判据（这才是补强的正确顺序）。",CY.sub)
    UI.Tip(p,"⚠ 这三条都改写【游戏自己的射线】—— 属反检测对抗类, 风险最高, 因此默认全关:\n  · 静默瞄准 = 游戏射线命中点被改写成当前锁定目标\n  · 子弹穿墙 = 同上, 且不要求视线\n  · 阻挡射线检测 = 游戏射线一律返回空(游戏的视线判定/检测会整体失灵, 副作用最大)\n★ 三条共用同一个 hook, 关掉最后一个才会真正卸下。\n★ 游戏更新后若射线 API 改名, 可能失效 —— 失效就关掉。",CY.yellow)

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
    -- ★★ 合并(用户要求): 本页原来的「🎮 小游戏区域透视 (ESP_Mini)」开关已【并入视觉页的
    --   「🔍 物件透视」总闸】—— 那个判据本质是物件分类表的第 12 类(小游戏区域),
    --   没必要单独占一个开关, 也没必要让你为看小游戏里的按钮专门跑回这个页面。
    --   本页只保留"自动"类功能。底层 ESP_Mini 配置键与扫描逻辑都还在, 只是改由总闸驱动。
    UI.Section(p,"🤖 小游戏 · 自动",CY.accent)
    UI.Tip(p,"🎮 小游戏区域透视已并入【视觉页 -> 🔍 物件透视】(判据合并, 一个开关一起亮)。",CY.sub)
    UI.Switch(p,"🏃 自动躲伤害机关 (靠近陷阱/地雷/压板/弹球自动退开)","AutoDodge",SYS.SetAutoDodge)
    -- ★★ v6.9.28 自动躲避的诊断【整合进「统一扫描」】(用户: "自动躲避状态扫描 整合啊 不要拆开")
    --   见功能页扫描区 / SYS.Scanners 里的「自动躲避状态」那一项。
    UI.Switch(p,"🎯 自动触发小游戏目标 (小游戏区域里的按钮/可交互物自动触发)","AutoHitMinigame",SYS.SetAutoHitMinigame)
    UI.Tip(p,"自动躲: 扫全图伤害机关(与「🔍 物件透视」里门·陷阱那条同判据, 已含地雷 mine/bomb/landmine/地雷/炸弹), 离你约 15 格内自动走开。\n自动触发: 只扫【小游戏区域】里的 ProximityPrompt/ClickDetector, 自动帮你按/点(打鸭子那类)。\n两个都纯客户端、默认关, 关掉即停; 隔墙/隐形的地雷也能扫到(只要客户端有这个实例)。",CY.sub)
end
UI.Pages["设置"]=function(p)
    UI.Section(p,"💾 配置 (自动保存 / 自动读回)",CY.green)
    UI.Label(p,SYS.has_fs_txt,SYS.HAS_FS and CY.green or CY.yellow)
    -- ★ v57: 用户要求去掉手动的"立即保存 / 立即加载"入口。
    --   保存与加载本身仍然是自动的: 改动任何开关会自动排队保存,
    --   下次加载脚本时自动读回并生效 —— 这里只是不再提供手动按钮。
    UI.Tip(p,"开关改动会自动保存, 下次加载脚本时自动生效(无需手动操作)。",CY.sub)
    UI.Div(p)

    --========== ★ v102 热键设置(移植: 点一下再按新键) ==========
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
            if SYS.SetForceCam then P(SYS.SetForceCam,SYS.C_.ForceCam) end
        end)
    UI.Tip(p,"强制视角 = 把相机锁成第一/第三人称(每 0.5s 兜底抢回, 防游戏脚本改回去)。\n第一人称 = 相机锁进角色头里; 第三人称 = 强制可拉远的经典视角。",CY.sub)
    --================ ★ v6.7.0 手机/平板界面适配 (用户反馈「菜单和字体太小」) ================
    UI.Div(p)
    UI.Section(p,"📱 界面缩放 (手机 / 平板适配)",CY.cyan)
    -- ★ v7.6.0: 本段新增的东西【只在触摸设备(手机/平板)出现】, PC 端页面与旧版逐行相同。
    local TDEV=(SYS.DEV and SYS.DEV.anyTouch)==true
    UI.Slider(p,"界面缩放 (0 = 自动适配)",0,(TDEV and 3.0 or 2.5),0.05,
        function() return SYS.C_.UIScaleManual or 0 end,
        function(v)
            SYS.C_.UIScaleManual=v
            if SYS.ApplyUIScale then P(SYS.ApplyUIScale) end
        end,"%.2f")
    if TDEV then
        -- ★ v7.6.0 手机/平板"自定义大小"加强(用户要求):
        --   ① ➖/➕ 微调: 手指在滑杆上很难一次点到 0.05 这一格, 给两个大按钮点一下走一格;
        --   ② 实时显示"当前生效倍数": 原来 0=自动 时滑块只显示 0, 用户看不到实际放到了多少;
        --   ③ 菜单右下角还有 ◢ 把手, 可以直接拖着改尺寸(和这个滑块是同一个值, 永远同步)。
        local lb=UI.Label(p,"",CY.accent)
        local function bump(d)
            local cur=tonumber(SYS.C_.UIScaleManual) or 0
            -- 自动挡(0)时以"当前实际倍数"为起点, 点一下 + 就从自动值开始往上加, 不会先跳到 0.05
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
-- [14.9] v6.7.0 新增页面: 玩家(动手类)　※ 整蛊页 6.9.6 删了界面, v9.9.0 连后端一起删; 本段只剩「玩家」页
--============================================================
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
    -- ★★ v8.2.0 M1: 「🔁 循环跟传」原来在这个开关位上, 现在收进下面的「跟随模式」互斥下拉
    UI.Btn(p,"🧲 把他拉过来 (客户端)",CY.orange,function() SYS.PC.BringTarget() end)
    UI.Tip(p,"带「客户端」字样的按钮只改你本地看到的画面 —— 服务端不认, 他本人没感觉, 而且很快会被拉回。\n这是引擎机制(客户端无权改别人角色), 不是脚本没生效。",CY.sub)

    UI.Div(p)
    UI.Section(p,"🔄 跟随 / 环绕 (动的是你自己 · 互斥下拉)",CY.purple)
    -- ★★ v8.2.0 M1 融合: 这里原来是 5 个独立开关(循环跟传 / 坐他头上 / 绕着他旋转 / 盯着他 / 行走跟随),
    --   五个**可以同时打开** —— 但它们都在写你的 CFrame / 相机, 同时开就是互相抢,
    --   表现为**抖动 / 瞬移**(本项目铁律: 同一时刻只允许一个模块写位置)。
    --   现在合成【一个互斥下拉】: 每次只可能一个生效, 互斥由控件保证。
    --   ★ 后端 SYS.PC.* 一行没改, 见 PC.ApplyFollowMode。
    UI.Cycle(p,"跟随模式",{"关闭","循环跟传","坐他头上","绕着他旋转","盯着他","行走跟随"},
        function()
            local i=SYS.PC.FollowModeIndex(tostring(SYS.C_.PC_Mode or "off"))
            return SYS.PC.FollowLabels[i] or "关闭"
        end,
        function(v)
            local i=1
            for idx,lab in ipairs(SYS.PC.FollowLabels) do if lab==v then i=idx break end end
            SYS.PC.ApplyFollowMode(SYS.PC.FollowModes[i] or "off")
        end)
    UI.Slider(p,"旋转速度",0.5,12,0.5,function() return SYS.C_.PC_SpinSpeed end,
        function(v) SYS.C_.PC_SpinSpeed=v end,"%.1f")
    UI.Slider(p,"环绕距离 (格)",2,30,1,function() return SYS.C_.PC_Range end,
        function(v) SYS.C_.PC_Range=v end,"%.0f")
    UI.Tip(p,"这 5 个模式都是「动你自己」, 不是动他。「循环跟传」原来在上一节「传送类」, 一并收进来了。\n"..
        "⛔ 以前能同时开多个 —— 那种情况下它们互相抢你的位置, 表现就是抖动/瞬移。现在互斥, 一次只能选一个。",CY.sub)

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

    -- 每 0.5 秒刷新一次信息条(距离会变)
    SYS.SpawnLoop(function()
        while not SYS.Unloaded do
            task.wait(0.5)
            if SYS.PCRender then P(SYS.PCRender) end
        end
    end)
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




local function CreateMenuLegacy()
    print("[CheatMenu] CreateMenu 开始")
    if SYS.ScreenGui then pcall(function() SYS.ScreenGui:Destroy() end) SYS.ScreenGui=nil end
    local sg=Instance.new("ScreenGui")
    sg.Name=SYS.N.Gui sg.ResetOnSpawn=false sg.IgnoreGuiInset=true
    -- ★★ v5.2.3 修「菜单纵向差 58px」的真凶(用户日志实测: 缩放=1.00 时 期望Y=208 实际Y=150):
    --   反推可知 ScreenGui 的可用高度只有 1080-2×58 = 964 —— 也就是【它被"安全区"上下各让出 58px】,
    --   菜单在那个缩小区域里居中, 所以整体偏上(而且顶部会被切掉一点)。
    --   `IgnoreGuiInset` 只管旧的顶部栏; 新的安全区是 `ScreenInsets` -> 设成 **None = 用整块视口**,
    --   这样锚点居中算出来就是真正的屏幕中心(545,208)。
    P(function() sg.ScreenInsets=Enum.ScreenInsets.None end)
    -- ★ v78 防"注入后还是旧版/出现两个菜单":
    --   旧实例理论上被【文件开头的 GENV 卸载钩子】卸载, 但如果那个旧实例是更早的版本
    --   (没注册过卸载钩子), 或者执行器的 getgenv 不共享, 旧菜单就会留在屏幕上 ——
    --   这时你看到的是旧界面, 会以为"没更新成功"。这里按名字把旧残骸清掉, 只留新建的这个。
    P(function()
        local roots={SYS.PG,SYS.CoreGui}
        if gethui then local h=gethui() if h then roots[#roots+1]=h end end
        local killed=0
        for i=1,#roots do
            local r=roots[i]
            -- ★ v6.8.1 加固(整脚本冒烟抓到): 以前直接 r:GetChildren() —— 若执行器的
            --   getgethui()/CoreGui 拿到的东西不是标准实例, 这里会抛 "attempt to call a
            --   nil value (method 'GetChildren')", 而且【被外层 pcall 吞掉】-> 真机上表现
            --   为"残留菜单没清干净, 屏幕上出现两个菜单"且毫无提示。
            --   现在先查能力再调, 拿不到就跳过(清理本来只是兜底)。
            if r and type(r.GetChildren)=="function" then
                for _,c in ipairs(r:GetChildren()) do
                    -- ⚠ 只按【旧版固定名】清: 新版名字是从中性池随机挑的(App/MainGui/…),
                    --   拿那种通用名去 Destroy 有误伤游戏自己 GUI 的风险, 绝不能按它清。
                    --   同版本重复加载由【文件开头的 GENV 卸载钩子】+ 上面的 Destroy 兜住。
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

    --============ ★ v7.6.0 触摸端(手机/平板)UI 位置工具: 边界夹取 + 位置记忆 ============
    -- ⛔ 只作用于触摸设备: PC 端 SYS.TouchUI=false -> 下面这些函数一律【直接返回】,
    --    PC 的"建菜单居中一次、之后不动"行为完全不变(用户要求"电脑不动")。
    --
    -- ★ 与 v5.2.3 删掉的「位置自检」本质不同(那个被用户明令删过, 别误解成复活它):
    --   · 旧自检拿【写死的 W/H】算"期望位置"再判偏差 —— 判据本身就是错的, 于是把好菜单挪走;
    --   · 这里只用【已知的 W/H × 当前真实缩放】和【真实视口】做"出界才夹回"的钳制,
    --     没出界时【一个像素都不动】(下面有 <0.5px 就直接 return)。
    local function vpSize()
        local cam=WS.CurrentCamera
        local vp=cam and cam.ViewportSize or nil
        if not vp or vp.X<10 or vp.Y<10 then return nil end
        return vp
    end
    -- 菜单当前中心(屏幕坐标): Position 的 Offset 会被 UIScale 一起缩放, 所以要乘 sc
    local function centerOf(sc,vp)
        local px,py=main.Position.X,main.Position.Y
        return vp.X*(px.Scale or 0.5)+sc*(px.Offset or 0),
               vp.Y*(py.Scale or 0.5)+sc*(py.Offset or 0)
    end
    -- 菜单当前【渲染后】尺寸: 读 main.Size 的真实值(收起时高度只有 62, 不是 H),
    -- 再乘当前缩放。这样"收起成一条"时边界夹取也是准的。
    local function menuSizeOf(sc,vp)
        local sz=main.Size
        local w=(tonumber(sz.X.Offset) or W)+(tonumber(sz.X.Scale) or 0)*vp.X
        local h=(tonumber(sz.Y.Offset) or H)+(tonumber(sz.Y.Scale) or 0)*vp.Y
        if w<10 then w=W end
        if h<10 then h=H end
        return w*sc,h*sc
    end
    -- 把"菜单中心"夹回屏幕内: 标题栏必须留在屏幕上、任一轴至少留 MINV 可见
    local function clampCenter(cx,cy,sc,vp)
        vp=vp or vpSize() if not vp then return cx,cy end
        local mw,mh=menuSizeOf(sc,vp)
        local MINV=80                       -- 任一轴至少留 80px 可见(还能抓回来)
        local TOPKEEP=math.min(mh,54)       -- 纵向至少留这么多(标题栏)在屏幕里
        local minX=MINV-mw*0.5
        local maxX=vp.X-MINV+mw*0.5
        local minY=mh*0.5                   -- 顶边不许跑到屏幕上边线之外
        local maxY=vp.Y-TOPKEEP+mh*0.5
        if maxX<minX then minX,maxX=vp.X*0.5,vp.X*0.5 end
        if maxY<minY then minY,maxY=vp.Y*0.5,vp.Y*0.5 end
        return math.clamp(cx,minX,maxX), math.clamp(cy,minY,maxY)
    end
    -- ★ 边界约束: 出界才夹回(没出界不动)。缩放变化后 / 恢复记忆位置后都调它。
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
    -- ★ v7.6.0: 「手机 / 平板」统一判定 —— 只要 TouchEnabled 就算(手机/平板/触屏设备)。
    --   PC 端 Roblox 的 TouchEnabled=false -> SYS.TouchUI=false -> 新增的适配与把手全部不生效、
    --   设置页也不显示新增控件, 保证【电脑版行为和以前一模一样】。
    SYS.TouchUI=(DEV.anyTouch==true)
    print(("[CheatMenu] 触摸端UI适配=%s"):format(tostring(SYS.TouchUI)))

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
            -- ★ v7.6.0 触摸端: 缩放一变, 渲染位置也跟着变(Position 的 Offset 会被 UIScale 一起缩放)
            --   -> 可能把菜单推出屏幕, 这里做一次【出界才夹回】。没出界时函数内部一个像素都不动。
            --   PC 端 SYS.TouchUI=false -> 不执行, 行为与旧版完全一致。
            if SYS.TouchUI==true and SYS.ClampMenuPos then SYS.ClampMenuPos() end
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

    -- ★ v7.6.0 触摸端(手机/平板): 恢复【上次拖到的位置】(按视口比例还原, 再夹进屏幕内)。
    --   · 存的是比例(0~1) 不是像素 -> 换分辨率 / 手机转屏 都能落回"同一个相对位置";
    --   · MenuPosSaved=false(从没拖过) 时不进这里 -> 仍是默认居中;
    --   · PC 端 SYS.TouchUI=false -> 永远走默认居中, 与旧版一致。
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
            -- 兜底: 万一 0.5 锚点假设和某个执行器不一致, 用实际渲染值再夹一次
            if SYS.ClampMenuPos then SYS.ClampMenuPos() end
        end)
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
    -- ★ v7.6.0: 缩放把手的手势状态(和拖动共用"同一时间只允许一个手势"的互斥锁 SYS._uiGesture)
    local rsz,rD0,rSc=false,nil,nil
    local TCH=(SYS.TouchUI==true)          -- 本段只有触摸端才加"更好抓"的手感, PC 完全不变
    -- ★ v4.6.0: 手机上根本【没有】鼠标事件 —— 原来只认 MouseButton1/MouseMovement,
    --   所以手机上一个都拖不动(用户实测)。补上 Touch(触摸屏的按下/移动都是 Touch)。
    local function isGrab(i)
        return i.UserInputType==Enum.UserInputType.MouseButton1
            or i.UserInputType==Enum.UserInputType.Touch
    end
    -- ★ 保留: ☰ 悬浮按钮的拖动还在用它(见下面 FloatGui 那段)
    local function isMove(i)
        return i.UserInputType==Enum.UserInputType.MouseMovement
            or i.UserInputType==Enum.UserInputType.Touch
    end
    -- ★ v7.6.0 多指隔离: 只有【起拖的那根手指】能继续拖动/结束拖动。
    --   旧写法 `isMove(input)` 对"任意 Touch"都放行 -> 第二根手指一动就把菜单拽走、一抬就把拖动结束
    --   (用户报的"手机多指会乱")。Touch 的 InputObject 同一根手指在 began/changed/ended 里是同一个对象,
    --   所以直接比对象身份即可; 鼠标没有多指问题, 仍按 UserInputType 判。
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
    -- ★ v7.6.0 更好抓(仅触摸端): 把标题栏命中矩形【上下左右各扩 14px】。
    --   因为我们走的是"全局监听 + 自己算矩形"(不依赖 z 序 / 也不依赖那个控件能不能收到事件),
    --   所以扩出来的这一圈是【真的能按到】的 —— 手指不必刚好戳在那 62px 高的条里。
    --   纵向只多 14px: 菜单内部 y=68 起才是侧栏/内容区, 扩出来的一圈不会盖到顶部那几个控件上。
    --   PC 端 TCH=false -> GPAD=0 -> 判定和旧版逐像素一致。
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
            -- ★ v7.6.0 手势互斥 + 多指隔离:
            --   · 已有手势(拖动/缩放把手)在跑 -> 新按下的手指直接忽略(不会抢走、也不会打断);
            --   · 两边标志都是 false 但锁还挂着 -> 说明丢了"抬起"事件(手指滑出屏幕等), 当陈旧标记清掉。
            if SYS._uiGesture and (drg or rsz) then return end
            SYS._uiGesture=nil
            if not isGrab(input) then return end
            local pos=input.Position
            if not inTitle(pos) then return end
            if onTitleBtn(pos) then return end    -- 标题栏上的按钮不参与拖动
            drg=true dS=pos fS=main.Position
            SYS._dragInput=input                    -- ★ 记住是哪根手指/鼠标在拖
            SYS._uiGesture="move"
            SYS._UserMoved=true      -- 用户手动拖过 -> 记下来
        end)
    end))
    T(UIS.InputChanged:Connect(function(input)
        if not input then return end
        -- ★ v7.6.0 缩放把手: 只认"起手的那根手指"; 按离菜单中心的距离比例换算缩放(角把手手感)
        if rsz and SYS._rzInput==input and input.Position then
            P(function()
                local vp=vpSize() if not vp then return end
                local sc0=curScale()
                local cx,cy=centerOf(sc0,vp)
                local d=math.max(24,(input.Position-Vector2.new(cx,cy)).Magnitude)
                local sc=math.clamp(rSc*(d/rD0),0.30,3.0)
                -- 写回手动值(ApplyScale 只认这个键) —— 松手时才落盘, 拖动过程不刷盘
                SYS.C_.UIScaleManual=math.floor(sc*100+0.5)/100
                if SYS.ApplyUIScale then P(SYS.ApplyUIScale) end
            end)
            return
        end
        if drg and sameGrab(input) and input.Position then
            local d=input.Position-dS
            local sc=curScale()
            main.AnchorPoint=Vector2.new(0.5,0.5)   -- 保证和"居中"用的是同一套锚点
            main.Position=UDim2.new(fS.X.Scale,fS.X.Offset+d.X/sc,fS.Y.Scale,fS.Y.Offset+d.Y/sc)
            -- ★ v7.6.0 边界约束: 拖动过程实时夹取, 保证标题栏永远留在屏幕里、拖不丢
            if TCH and SYS.ClampMenuPos then SYS.ClampMenuPos() end
        end
    end))
    T(UIS.InputEnded:Connect(function(input)
        if not input then return end
        -- ★ v7.6.0: 只有"起手的那根手指/那个鼠标键"抬起才算结束(多指隔离)
        if rsz and SYS._rzInput==input then
            rsz=false SYS._rzInput=nil SYS._uiGesture=nil
            SYS.C_.UIScaleManual=math.floor(curScale()*100+0.5)/100
            for _,f in ipairs(SYS.BtnRefs or {}) do P(f) end   -- 让设置页的滑块/倍数显示跟上
            if SYS.SaveMenuState then P(SYS.SaveMenuState) end
            return
        end
        if drg and sameGrab(input) then
            drg=false SYS._dragInput=nil SYS._uiGesture=nil
            if SYS.SaveMenuState then P(SYS.SaveMenuState) end    -- ★ 记住这次拖到的位置
        end
    end))

    -- ★ v7.6.0 触摸端: 把"菜单拖到哪了"记进配置(存【视口比例】0~1, 换分辨率/转屏都能按比例还原)。
    --   PC 端直接返回 -> 不写配置、下次仍是默认居中。
    function SYS.SaveMenuState()
        P(function()
            if SYS.TouchUI~=true then return end
            local vp=vpSize() if not vp then return end
            local sc=curScale()
            local cx,cy=centerOf(sc,vp)
            local nx,ny=clampCenter(cx,cy,sc,vp)      -- 存之前先夹一次, 免得存进一个出界的比例
            SYS.C_.MenuPosX=math.clamp(nx/vp.X,0,1)
            SYS.C_.MenuPosY=math.clamp(ny/vp.Y,0,1)
            SYS.C_.MenuPosSaved=true
            QueueSave()
        end)
    end

    --============ ★ v7.6.0 右下角「缩放把手」—— 手机/平板"拖边角改菜单尺寸" ============
    -- 只在触摸端出现(PC 不建这个控件 -> 电脑版一个像素都不变)。
    -- 手上动作 = 按住右下角把手往外/往里拖 -> 按"离菜单中心的距离比例"换算缩放倍数,
    -- 结果写回 SYS.C_.UIScaleManual(和设置页那个滑块是同一个值, 所以两处永远一致)。
    -- ⚠ 为什么不去改 main.Size: 菜单内部上千个控件全是【按 830×664 写死的绝对偏移】画的,
    --   直接改宽高会让整页错位; 走 UIScale 才是唯一不会把版式弄坏的"改大小"方式。
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
                if drg or rsz then return end        -- 已有手势 -> 不抢
                if not isGrab(input) then return end
                local vp=vpSize() if not vp then return end
                local sc0=curScale()
                local cx,cy=centerOf(sc0,vp)
                rsz=true rSc=sc0
                -- 起手距离: 太小(手已经按在菜单中心附近)就没法按比例算 -> 兜一个下限
                rD0=math.max(24,(input.Position-Vector2.new(cx,cy)).Magnitude)
                SYS._rzInput=input SYS._uiGesture="resize"
            end)
        end))
    end

    --============ ★ v120 收起/展开(手机/平板把菜单缩成一条标题栏, 免得挡住游戏) ============
    local collapseBtn=Instance.new("TextButton")
    collapseBtn.Size=UDim2.new(0,34,0,34) collapseBtn.Position=UDim2.new(1,-96,0.5,-17)
    collapseBtn.BackgroundColor3=CY.panel collapseBtn.BackgroundTransparency=0.25
    collapseBtn.Text="▬" collapseBtn.TextSize=18 collapseBtn.TextColor3=CY.text
    collapseBtn.Font=Enum.Font.GothamBold collapseBtn.BorderSizePixel=0
    collapseBtn.Parent=top
    P(function() local r=Instance.new("UICorner") r.CornerRadius=UDim.new(1,0) r.Parent=collapseBtn end)
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
        fg.Name=SYS.N.Float P(function() fg.ResetOnSpawn=false end)
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

-- ★ v6.9.1: WindUI 内嵌库与适配层已【彻底删除】, 菜单壳只剩【旧自绘】这一套 ——
--   原来"先建 WindUI 窗口、失败再回退旧壳"的分支连同 1.7 万行内嵌库一起清掉了,
--   现在 CreateMenu 就是旧壳本身(行为 = 6.8.x 及以前的界面)。
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
    -- ★ v6.9.1: 这里原本有一段"WindUI 要显式 Open/Close"的分支, 随 WindUI 一起删除。
    --   旧自绘壳的开关【只靠 ScreenGui.Enabled】就够了(上面那两行), 不需要额外动作。
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
            -- ★ v9.5.0 自由视角状态对账: 开关=唯一真源(见 SYS.SyncFreeCam 头部说明)。
            --   放这条 0.5s 局内务循环里: 它一直转、与重生/重载解耦, 且 0.5s 的延迟用户无感。
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
            -- ★ v6.9.0 修: 原来外层只放行 ESP / ESPNameTag 两个开关, 而 ESPTick
            --   内部认 8 个(含 NPC/掉落物/武器/可交互/门/小游戏) -> 只开那几个时 tick
            --   根本不跑, 用户看到的就是"开了没效果"。改成直接调, 由内部自己判断。
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
    -- ★★ v6.9.0: 热更新时【不能】在这里再存一次 —— 上面 CheckUpdate 已经把"带 T_ 的快照"
    --   存好了, 而这里刚把 T_ 全清空过, 再存会把快照抹成空表, 新版起来啥都恢复不出来。
    if not SYS._updating then P(SYS.SaveConfig) end
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
    P(SYS.StopTrain) P(SYS.StopReb) P(SYS.StopGym)
    -- ★ v114(审计修复 EV-03): 卸载必须显式关掉「反陷阱」—— 原来这里漏了,
    --   它的三条连接(角色 Touched / CharacterAdded / RenderStepped)会留下来, 每次重载叠一条。
    P(function() if SYS.CleanTrapGuard then SYS.CleanTrapGuard() end end)
    P(function() if SYS.Combat then SYS.Combat.Stop() end end)
    P(function() if SYS.SetNoclip then SYS.SetNoclip(false) end end) -- ★ v49.3 卸载时清穿墙
    -- ★ v6.7.0 融合模块统一卸载(光照/音频/聊天/防护/玩家控制; 滤镜·路径点·整蛊 v9.9.0 已删)
    P(function() if SYS.FuseClean then SYS.FuseClean() end end)
    for _,c in ipairs(SYS.NoclipConns or {}) do DS(c) end SYS.NoclipConns={} -- ★ v49.3 补清穿墙连接
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
        -- ★ v3.9.0: 卸载也走唯一实现(原来的写法直接用脚本加载时的值, 会把
        --   StopFreeCam 刚恢复好的正确状态又覆盖掉 -> "卸载后鼠标不正常")
        SYS.RestoreMouse()
    end)
    P(SYS.ResetCam)
    -- ★ v3.10.0: 卸载时还原强制视角(把 CameraMode/CameraMaxZoomDistance 归位)
    P(function() if SYS.SetForceCam then SYS.SetForceCam("off") end end)
    P(function() if SYS.RestoreCamOpts then SYS.RestoreCamOpts() end end)
    P(function() if SYS.ScreenGui then SYS.ScreenGui:Destroy() end end)
    SYS.ScreenGui=nil SYS.MenuOpen=false
    -- ★ v4.8.1 修「点了卸载, 右边的 ☰ 浮动按钮还留着」:
    --   浮动按钮是【独立的 ScreenGui】(不挂在菜单 ScreenGui 下面), 所以销毁菜单不会连带销毁它。
    --   卸载必须显式销毁, 否则卸载后屏幕上永远留一个按钮 —— 看起来就是"卸载不干净"。
    P(function() if SYS.FloatGui then SYS.FloatGui:Destroy() end end)
    SYS.FloatGui=nil SYS.FloatBtn=nil
    if GENV[SYS.GK.unload]==SYS.UnloadAll then
        GENV[SYS.GK.loaded]=nil GENV[SYS.GK.unload]=nil
    end
    -- ★ v124: 卸载时把"加载时检查已做过"的锁也清掉 —— 否则【卸载后再重新加载】那一次会被锁跳过,
    --   而"卸载脚本 -> 重新加载"正是用户点名要覆盖的场景(退出游戏重进同理, 那会换新的 getgenv)。
    GENV[SYS.GK.boot]=nil
    GENV[SYS.GK.note]=nil
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
    SYS._updating = true     -- ★ v6.9.0: 让 SaveConfig 连 T_ 一起存(否则更新完开关全丢)
    P(SYS.SaveConfig)        -- ① 必须在 UnloadAll 之前
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

    GENV[SYS.GK.loaded]=true
    -- ★ v6.8.0 反指纹: 建完菜单就把所有自建实例改成中性名(每局随机)
    P(function() if SYS.ApplyNeutralNames then SYS.ApplyNeutralNames() end end)
    -- ★ v6.8.0: 顺手起采样器, 让「对抗靶场」的 D6/D8 一进去就有数据
    P(function() if SYS.AC and SYS.AC.StartSampler then SYS.AC.StartSampler() end end)
    GENV[SYS.GK.unload]=SYS.UnloadAll

    task.spawn(function()
        task.wait(1.5)
        if SYS.T_.AntiAFK then P(SYS.enableAntiAFK) end
        for key,fn in pairs(SYS.SwitchOnChange) do
            if key~="AntiAFK" and SYS.T_[key]==true then P(fn,true) end
        end
        print("[CheatMenu] ✅ 已根据配置激活开关")
        -- ★ v124: 如果这次是"加载时更新"顶上来的, 在这里把更新前后版本号告诉用户
        --   (检查发生在界面之前, 那时还没有通知栏; 所以把话留到这一刻再说)
        if GENV[SYS.GK.note] then
            local note=GENV[SYS.GK.note]
            GENV[SYS.GK.note]=nil
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
