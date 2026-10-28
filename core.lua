---=====================================
---core
---所有基础的东西都会在这里定义
---=====================================

lstg = lstg or {}

----------------------------------------
---各个模块
lstg.DoFile("THlib\\lib\\Lresources.lua")--资源的加载函数、资源枚举和判断

lstg.DoFile("THlib\\lib\\Llog.lua")--简单的log系统
lstg.DoFile("THlib\\lib\\Lglobal.lua")--用户全局变量
lstg.DoFile("THlib\\lib\\Lmath.lua")--数学常量、数学函数、随机数系统
lstg.DoFile("THlib\\plus\\plus.lua")--CHU神的plus库，replay系统、plusClass、NativeAPI
lstg.DoFile("THlib/save/codec.lua")
lstg.DoFile("THlib/save/profiles.lua")
SaveProfiles.init()
lstg.DoFile("THlib/save/transport.lua")
lstg.DoFile("THlib/save/service.lua")
lstg.DoFile("THlib/save/resume.lua")
lstg.DoFile("THlib\\lib\\Lobject.lua")--Luastg的Class、object
lstg.DoFile("THlib\\lib\\LObjectEvents.lua")--一些object事件函数

lstg.DoFile("THlib\\lib\\Lscreen.lua")--world、3d、viewmode的参数设置
lstg.DoFile("THlib/net/codec.lua")
lstg.DoFile("THlib/net/session.lua")
lstg.DoFile("THlib/net/capture.lua")
if GameNet then GameNet.Capture.install() end
lstg.DoFile("THlib\\lib\\Linput.lua")--按键状态更新
lstg.DoFile("THlib\\lib\\Ltask.lua")--task
lstg.DoFile("THlib\\lib\\Lstage.lua")--stage关卡系统
lstg.DoFile("THlib\\lib\\Ltext.lua")--文字渲染
lstg.DoFile("THlib\\lib\\Lscoredata.lua")--玩家存档
--lstg.DoFile("lib\\Lplugin.lua")--用户插件

----------------------------------------
---用户定义的一些函数



function GameExit()
    if GameNet and GameNet.active() then GameNet.leave() end
    if SaveResume then SaveResume.flush('退出游戏') end
    if not lstg.quit_flag then
        if not scoredata["Alt+F4"] then
            scoredata["Alt+F4"] = true
        end
    end
    SaveSpellCardData()
    SaveScoreData()
end

----------------------------------------
---全局回调函数，底层调用

function GameInit()
    --加载mod包
    if setting.mod ~= 'launcher' then
        Include 'mod\\root.lua'
    else
        Include 'launcher.lua'
    end
    --最后的准备
    SYSTEM_COUNT = 11--总共有多少系统
    STAGE_COUNT = 33--总共有多少关卡（不包括统计）
    musicList = {}
    musicBarList = {}
    AchievementInfo = {}
    InitAllClass()--对所有class的回调函数进行整理，给底层调用
    InitScoreData()--装载玩家存档
    InitSpellCardData()
    math.randomseed(os.time())
    CurrentVerifiableOffset = math.random(5, 100)
    CurrentMoney = scoredata.money + CurrentVerifiableOffset
    boss_group = {}

    SaveSpellCardData()
    SaveScoreData()

    SetViewMode("world")
    if stage.next_stage == nil then
        error('Entrance stage not set.')
    end
    --SetResourceStatus("stage")
end

local floatmoney = 0
function GetSaveMoneyState() return {fraction=floatmoney,offset=CurrentVerifiableOffset or 0} end
function SetSaveMoneyState(value)
    floatmoney=value.fraction or 0
    CurrentVerifiableOffset=value.offset or CurrentVerifiableOffset or 0
    CurrentMoney=scoredata.money+CurrentVerifiableOffset
end
-- 只在旧场景完成结算与销毁后调用；重建与玩家存档有关的运行时缓存。
function ReloadSaveProfile()
    local which=assert(SaveProfiles.pending)
    SaveProfiles.activate(which)
    InitScoreData()
    InitSpellCardData()
    scoredata.PlayerBrand=scoredata.PlayerBrand or 'PLAYER'
    -- 符卡注册只在启动时执行一次，换到空存档后须重新补齐所有已注册的历史槽。
    for _,unit in ipairs(_sc_table or {}) do
        local number=unit.card.card_id
        if number then
            if type(spell_card_data[number])~='table' then spell_card_data[number]={} end
            for _,playerInfo in ipairs(player_list) do
                local history=spell_card_data[number][playerInfo[2]]
                if type(history)~='table' then spell_card_data[number][playerInfo[2]]={0,0} end
            end
        end
    end
    floatmoney=0
    CurrentMoney=scoredata.money+CurrentVerifiableOffset
    if ext.achievement then
        ext.achievement.getcount=0
        ext.achievement.achievement={}
        for _,value in pairs(scoredata.Achievement) do
            if value==true then ext.achievement.getcount=ext.achievement.getcount+1 end
        end
    end
    if ext.saving then
        ext.saving.SaveManager._repdir=SaveProfiles.userRoot()
        ext.saving.SaveManager:Refresh()
    end
    if AndroidInput then AndroidInput.reset() end
    if lstg.AndroidClock then lstg.SystemLog('BOSSRUSH_PROFILE_SWITCH: '..which) end
    SaveProfiles.pending=nil
end
function AddMoney(nums)
    if not ext.replay.IsReplay() then
        local data = scoredata
        local offset = CurrentVerifiableOffset
        floatmoney = floatmoney + nums - int(nums)
        if floatmoney >= 1 then
            floatmoney = floatmoney - 1
            nums = nums + 1
        end
        data.money = data.money + int(nums)
        if data.money >= 80000 then
            ext.achievement:get(10)
        elseif data.money >= 40000 then
            ext.achievement:get(8)
        elseif data.money >= 10000 then
            ext.achievement:get(3)
        end
        CurrentMoney = data.money + offset
    end
end

function CheckMoney()
    local data = scoredata
    local offset = CurrentVerifiableOffset
    if CurrentMoney - offset ~= data.money then
        data.money = CurrentMoney - offset
        data.money = math.ceil(data.money)
        error("Invalid value")
    end
end

local j = 1
function AddMusic(id, loopend, looplen, name, noinbar)
    musicList[id] = { loopend, looplen, name }
    if not noinbar then
        musicBarList[j] = { id, name, loopend, looplen }
        j = j + 1
    end
end
function DefineAchievement(id, name, getway, describe, hide, rank)
    AchievementInfo[id] = { name, getway, describe, hide, rank }
    local data = scoredata
    if data.Achievement[id] == true then
        ext.achievement.getcount = ext.achievement.getcount + 1
    else
        data.Achievement[id] = false
    end
    data.NoticeAchievement[id] = data.NoticeAchievement[id] == true
end
