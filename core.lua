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
lstg.DoFile("THlib\\lib\\Lobject.lua")--Luastg的Class、object
lstg.DoFile("THlib\\lib\\LObjectEvents.lua")--一些object事件函数

lstg.DoFile("THlib\\lib\\Lscreen.lua")--world、3d、viewmode的参数设置
lstg.DoFile("THlib\\lib\\Linput.lua")--按键状态更新
lstg.DoFile("THlib\\lib\\Ltask.lua")--task
lstg.DoFile("THlib\\lib\\Lstage.lua")--stage关卡系统
lstg.DoFile("THlib\\lib\\Ltext.lua")--文字渲染
lstg.DoFile("THlib\\lib\\Lscoredata.lua")--玩家存档
--lstg.DoFile("lib\\Lplugin.lua")--用户插件

----------------------------------------
---用户定义的一些函数



function GameExit()
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
    STAGE_COUNT = 24--总共有多少关卡（不包括统计）
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