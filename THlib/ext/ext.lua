---=====================================
---stagegroup|replay|pausemenu system
---extra game loop
---=====================================

----------------------------------------
---ext加强库

---@class ext @额外游戏循环加强库
ext = {}
local ext = ext

local extpath = "THlib\\ext\\"
DoFile(extpath .. "ext_pause_menu.lua")--暂停菜单和暂停菜单资源
DoFile(extpath .. "ext_replay.lua")--CHU爷爷的replay系统以及切关函数重载
DoFile(extpath .. "ext_stage_group.lua")--关卡组
DoFile(extpath .. "ext_achievement.lua")--成就
DoFile(extpath .. "ext_boss.lua")--可能会很傻逼的操作，boss的ui集中渲染
DoFile(extpath .. "ext_manual.lua")--像天邪鬼那样的弹出界面来说明游戏内容的
DoFile(extpath .. "ext_other.lua")--一些函数整理
DoFile(extpath .. "ext_mouse.lua")--鼠标控制

local replayTicker = 0--控制录像播放速度时有用
local slowTicker = 0--控制时缓的变量
ext.FrameCounter = 0--用来改变假fps的变量

ext.time_slow_level = { 1, 0.5, 1 / 3, 0.25 }--60/30/20/15 4个程度
ext.MusicChange = {
    task = {},
    frame = task.Do,
    change = function(self, before, now, t, start_time)
        task.New(self, function()
            ext.PlayMusic(now, 0, start_time or 0)
            t = t or 20
            for i = 1, t do
                SetBGMVolume(now, i / t)
                if before then
                    SetBGMVolume(before, 1 - i / t)
                end
                task.Wait()
            end
            if before then
                StopMusic(before)
            end
        end)
    end
}
ext.Aya_texture = nil
ext.FrameEvent = eventListener()

LoadFX("fx:SaveScreen", "shader\\screen_save.hlsl")

---重置缓速计数器
function ext.ResetTicker()
    replayTicker = 0
    slowTicker = 0
end

function ext.StageIsMenu()
    local stage = stage
    if stage.current_stage then
        if stage.current_stage.is_menu then
            return true
        end
    else
        return true
    end
    return false
end

---获取暂停菜单发送的命令
---@return string
function ext.GetPauseMenuOrder()
    return ext.pause_menu_order
end

---发送暂停菜单的命令，命令有以下类型：
---'Continue'
---'Return to Title'
---'Quit and Save Replay'
---'Give up and Retry'
---'Restart'
---'Replay Again'
---@param msg string
function ext.PushPauseMenuOrder(msg)
    ext.pause_menu_order = msg
end

----------------------------------------
---extra user function
---设置标题
local function ChangeGameTitle()
    local mod = setting.mod
    local t = table.concat({
        string.format("FPS=%.1f", GetFPS()),
        "Objects=" .. GetnObj(),
        "LuaSTG",
        ui.version,
        "作者：吃药图书"
    }, " | ")
    if mod then
        SetTitle(mod .. " | " .. t)
    else
        SetTitle(t)
    end
end

---切关处理
local function ChangeGameStage()
    if lstg.world.t > 224 then
        SetWorld()
    end
    if ext.needSaveToFile then
        ext.needSaveToFile = nil
        if not plus.DirectoryExists("User") then
            plus.CreateDirectory("User")
        end
        SaveTexture("LittleSnapShot", "User\\menu_bg_2.png")
    end
    ResetWorldOffset()--by ETC，重置world偏移
    ResetCurSystem()--重制system选择
    SaveSpellCardData()
    SaveScoreData()
    ext.Aya_texture = nil--重制拍照图像
    ext.notUIdraw = nil
    sp:UnitListUpdate(boss_group)
    lstg.ResetLstgtmpvar()--重置lstg.tmpvar
    ext.DefaultMusic()
    if lstg.nextvar then
        lstg.var = lstg.nextvar
        lstg.nextvar = nil
    end
    if lstg.nexttmpvar then
        lstg.tmpvar = lstg.nexttmpvar
        lstg.nexttmpvar = nil
    end
    -- 初始化随机数
    if lstg.var.ran_seed then
        ran:Seed(lstg.var.ran_seed)
    end


    --刷新最高分
    if not stage.next_stage.is_menu then
        if scoredata.hiscore == nil then
            scoredata.hiscore = {}
        end
        lstg.tmpvar.hiscore = scoredata.hiscore[stage.next_stage.stage_name .. '@' .. tostring(lstg.var.player_name)]
    else
        -- lstg.var.FakeGameFPS = nil
    end
    ext.boss_ui:refresh()
    --切换关卡
    stage.current_stage = stage.next_stage
    stage.next_stage = nil
    stage.current_stage.timer = 0
    stage.current_stage:init()
    if not stage.current_stage.is_menu then
        lstg.system:init_value()
    end
end

---行为帧动作(和游戏循环的帧更新分开)
local function DoFrame()
    --切关处理
    local stage = stage
    if stage.next_stage then
        --切关时清空资源和回收对象
        if stage.current_stage then
            stage.current_stage:del()
            task.Clear(stage.current_stage)
            if stage.preserve_res then
                stage.preserve_res = nil
            else
                RemoveResource 'stage'
            end
            ResetPool()
        end
        ChangeGameStage()
    end
    --刷新输入
    GetInput()
    --stage和object逻辑
    local nopause = (GetCurrentSuperPause() <= 0)
    if nopause or stage.nopause then
        if not stage.current_stage.is_menu and not ext.notUIdraw then
            lstg.system:frame()
        end
        task.Do(stage.current_stage)
        stage.current_stage:frame()
        stage.current_stage.timer = stage.current_stage.timer + 1
    end
    ObjFrame()
    ext.boss_ui:frame()
    if nopause or stage.nopause then
        BoundCheck()
    end
    if nopause then
        ---@type object

        local ck = CollisionCheck
        local GROUP = GROUP
        ck(GROUP.PLAYER, GROUP.ENEMY_BULLET)
        ck(GROUP.PLAYER, GROUP.ENEMY_BULLET2)
        ck(GROUP.PLAYER, GROUP.ENEMY)
        ck(GROUP.PLAYER, GROUP.INDES)

        ck(GROUP.PLAYER, GROUP.LASER)
        ck(GROUP.ENEMY, GROUP.PLAYER_BULLET)
        ck(GROUP.NONTJT, GROUP.PLAYER_BULLET)
        ck(GROUP.ITEM, GROUP.PLAYER)
        ck(GROUP.ITEM2, GROUP.PLAYER)
        ck(GROUP.SPELL, GROUP.ENEMY)
        ck(GROUP.SPELL, GROUP.NONTJT)
        ck(GROUP.SPELL, GROUP.ENEMY_BULLET)
        ck(GROUP.SPELL, GROUP.ENEMY_BULLET2)
        ck(GROUP.SPELL, GROUP.INDES)
        ck(GROUP.SPELL, GROUP.LASER)
    end
    UpdateXY()
    AfterFrame()
end
_G.DoFrame = DoFrame
---缓速和加速
local function DoFrameEx(differ)
    local Count = ext.GetFakeFPS()
    local setting = setting
    if ext.replay.IsReplay() then
        --播放录像时
        replayTicker = replayTicker + 1
        slowTicker = slowTicker + 1
        Count = setting.RepNoGameFps and 1 or Count
        if GetKeyState(setting.keysys.repfast) then
            Count = setting.ReplayFastSpeed / 60 * Count
            ext.FrameCounter = ext.FrameCounter + Count
        elseif GetKeyState(setting.keysys.repslow) then
            Count = setting.ReplaySlowSpeed / 60 * Count
            ext.FrameCounter = ext.FrameCounter + Count
        else
            ext.FrameCounter = ext.FrameCounter + Count
        end
    else
        --正常游戏时
        slowTicker = slowTicker + 1
        ext.FrameCounter = ext.FrameCounter + Count
    end
    --键盘映射

    local music_frame = differ
    if cur_setting and cur_setting.frameskip and differ < 2 then
        if ext.replay.IsRecording() or ext.replay.IsReplay() then
            ext.FrameCounter = ext.FrameCounter * differ
        end
        music_frame = nil
    end
    if ext.sc_pr then
        for _ = 1, ext.FrameCounter do
            DoFrame()
            ext.FrameCounter = ext.FrameCounter - 1
            ext.pause_menu_order = nil
        end
        ext.MusicFrame("timer")
        ext.MusicFrame("faketimer")
    else
        for _ = 1, ext.FrameCounter do
            DoFrame()
            ext.MusicFrame("timer")
            ext.FrameCounter = ext.FrameCounter - 1
            ext.pause_menu_order = nil
        end
        ext.MusicFrame("faketimer", music_frame)
    end

    ext.FastMusic()
end

----------------------------------------
---extra game call-back function
local differ = 1
local offset = 0
local stopWatch = lstg.StopWatch()
local before, after = 0, 0
local mask_fader = mask_fader
local ui_drawing = ui_drawing
local setting = setting
function FrameFunc()

    after = stopWatch:GetElapsed()
    differ = (after - before) * 60
    before = stopWatch:GetElapsed()
    --Print(differ)

    --标题设置
    ChangeGameTitle()

    local stage, lstg = stage, lstg
    --执行场景逻辑
    if stage.current_stage and stage.current_stage.is_menu and lstg.var.timeslow ~= 1 then
        lstg.var.timeslow = 1
    end
    if ext.pause_menu:IsKilled() and ext.manual:IsKilled() then
        --处理录像速度与正常更新逻辑
        CheckMoney()
        if stage.current_stage and not stage.current_stage.is_menu then
            ext.FRAMECOUNT = ext.FRAMECOUNT + 1
            if ext.FRAMECOUNT >= 3000 then
                ext.saveScreenToFile = true
                ext.FRAMECOUNT = 0
            end
        else
            ext.FRAMECOUNT = 0
        end
        local add = 0
        offset = offset + (differ - 1)
        if offset > 1 then
            add = int(offset)
            offset = offset - add
        end
        DoFrameEx(1 + add)
        --按键弹出菜单
        if (GetLastKey() == setting.keysys.menu and not lstg.tmpvar.noPause or ext.pop_pause_menu) and not ext.StageIsMenu() then
            ext.pause_menu:FlyIn()
        end
    end
    --暂停菜单更新
    if stage.current_stage then
        if not stage.current_stage.is_menu then
            --ext.manual:frame()
            ext.pause_menu:frame()
            ui_drawing:frame()
        else
            ext.music = {}
        end
    end
    ext.achievement:frame()
    ext.MusicChange:frame()
    ext.Debugging()

    --游玩时间计算
    ext.InputDuration()
    --与时间有关的成就
    ext.DurationAchievement()

    if lstg.quit_flag then
        GameExit()
    end
    --退出游戏逻辑
    return lstg.quit_flag
end

function RenderFunc()
    BeginScene()
    SetViewMode("ui")
    SetWorldFlag(1)
    Failed_Show:BeforeRender()

    ext.saveScreenBefore()
    ext.BeforeRender()
    local stage = stage

    mask_fader:BeforeRender()
    if stage.current_stage then

        ui_drawing:Beforerender()
        stage.current_stage:render()
        ext.CameraBefore()
        ObjRender()
        ext.CameraAfter()
        ui_drawing:Afterrender()

        --DrawCollider()
        if DEBUG and Collision_Checker then
            Collision_Checker.render()
        end
    end
    mask_fader:AfterRender()

    mask_fader:frame()
    ext.AfterRender()
    SetViewMode("ui")
    ext.saveScreenAfter()

    Failed_Show:AfterRender()

    Failed_Show:frame()

    EndScene()


    --截图
    if GetLastKey() == setting.keysys.snapshot then
        if not plus.DirectoryExists("snapshot") then
            plus.CreateDirectory("snapshot")
        end
        Snapshot('snapshot\\' .. os.date("!%Y-%m-%d-%H-%M-%S",
                os.time() + setting.timezone * 3600) .. '.png')--支持时区
    end
end

function FocusLoseFunc()
    --[[
        if not stage.current_stage.is_menu and ext.pause_menu:IsKilled() then
            ext.pause_menu:FlyIn()
        end--]]
end--失去焦点时弹出暂停
