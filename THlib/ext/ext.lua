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
DoFile(extpath .. "ext_quiz.lua")--原符卡与强化掉落共用实体

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
    if AndroidPlatform then return end -- 移动端 SetTitle 为空实现，不逐帧构造废弃的标题字符串。
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
    if ui.OriginalHUD then ui.OriginalHUD.layout(stage.next_stage) end
    if ui.NativeHUD then ui.NativeHUD.layout(stage.next_stage) end
    ResetCurSystem()--重制system选择
    -- 初次进入加载画面和离开分辨率选择时没有新的游玩进度，不重复重写刚读取的存档。
    if stage.current_stage and stage.current_stage.stage_name~='settings' then
        SaveSpellCardData()
        SaveScoreData()
    end
    if SaveProfiles.pending then ReloadSaveProfile() end
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
    if SaveResume then SaveResume.prepareStage() end
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
    if ui.ResourceLoading then ui.ResourceLoading.stageReady() end
    if SaveResume then SaveResume.afterStageInit() end
end

---行为帧动作(和游戏循环的帧更新分开)
local function DoFrame()
    --切关处理
    local stage = stage
    if stage.next_stage then
        --切关时清空资源和回收对象
        if stage.current_stage then
            stage.current_stage:del()
            if TH37 then TH37.runtime.clearAll() end
            if TH38 then TH38.runtime.presentation.clearAudio() end
            if TH39 then TH39.runtime.clearAll() end
            if TH43 then TH43.stop() end
            task.Clear(stage.current_stage)
            if stage.preserve_res then
                stage.preserve_res = nil
            else
                RemoveResource 'stage'
            end
            ResetPool()
        end
        ChangeGameStage()
        if NativeTime then NativeTime.reset() end
    end
    -- 允许切场景和同步初始化，但加载画面撤下之前不消费输入或推进任何战斗帧。
    if ui.ResourceLoading and ui.ResourceLoading.state then return end
    if RogueEncounter and RogueEncounter.preloading() then return end
    if NativeTime and not NativeTime.allowFrame() then return end
    if SaveResume and not SaveResume.beforeLogic() then return end
    --刷新输入
    GetInput()
    if SequenceResources and SequenceResources.continueFrame and SequenceResources.continueFrame(stage.current_stage) then
        if SaveResume then SaveResume.afterLogic() end
        return
    end
    -- 永夜抄符卡决死窗口只推进自机决策，冻结道中、敌弹和射击计时。
    if SequenceResources and SequenceResources.deathbombFrame and SequenceResources.deathbombFrame() then
        if SaveResume then SaveResume.afterLogic() end
        return
    end
    if GameNet then GameNet.beforeLogic() end
    --stage和object逻辑
    local perf=AndroidProfiler
    local nopause = (GetCurrentSuperPause() <= 0)
    if nopause or stage.nopause then
        if not stage.current_stage.is_menu and not ext.notUIdraw then
            lstg.system:frame()
        end
        if perf then perf.begin('logic.stage') end
        task.Do(stage.current_stage)
        if RogueEncounter and RogueEncounter.preloading() then
            if perf then perf.finish('logic.stage') end
            return
        end
        stage.current_stage:frame()
        stage.current_stage.timer = stage.current_stage.timer + 1
        if perf then perf.finish('logic.stage') end
    end
    ObjFrame()
    if SequenceResources and SequenceResources.enabled() then
        SequenceResources.resolveShotHits()
        SequenceResources.flushDamage()
    end
    ext.boss_ui:frame()
    if nopause or stage.nopause then
        BoundCheck()
    end
    if nopause then
        ---@type object

        local ck = CollisionCheck
        local GROUP = GROUP
        if OriginalCollision then OriginalCollision.begin() end
        if NativeActorCollision then NativeActorCollision.begin() end
        if TH37 then TH37.runtime.beginCollisions() end
        ck(GROUP.PLAYER, GROUP.ENEMY_BULLET)
        ck(GROUP.PLAYER, GROUP.ENEMY_BULLET2)
        ck(GROUP.PLAYER, GROUP.ENEMY)
        ck(GROUP.PLAYER, GROUP.INDES)

        ck(GROUP.PLAYER, GROUP.LASER)
        if TH37 then TH37.runtime.finishCollisions() end
        if OriginalCollision then OriginalCollision.shots() end
        if NativeActorCollision then NativeActorCollision.shots() end
        ck(GROUP.ENEMY, GROUP.PLAYER_BULLET)
        ck(GROUP.NONTJT, GROUP.PLAYER_BULLET)
        if OriginalCollision then OriginalCollision.secondary() end
        ck(GROUP.ITEM, GROUP.PLAYER)
        ck(GROUP.ITEM2, GROUP.PLAYER)
        ck(GROUP.SPELL, GROUP.ENEMY)
        ck(GROUP.SPELL, GROUP.NONTJT)
        ck(GROUP.SPELL, GROUP.ENEMY_BULLET)
        ck(GROUP.SPELL, GROUP.ENEMY_BULLET2)
        ck(GROUP.SPELL, GROUP.INDES)
        ck(GROUP.SPELL, GROUP.LASER)
        if NativeActorCollision then NativeActorCollision.finish() end
        if OriginalCollision then OriginalCollision.finish() end
    end
    -- 使用本帧正常移动和碰撞后的自机位置接取，掉落不冻结关卡或额外移动自机。
    if nopause and GameDrops then
        if perf then perf.begin('logic.drops') end
        GameDrops.frame(stage.current_stage)
        if RogueTen then RogueTen.afterLogic(stage.current_stage) end
        if perf then perf.finish('logic.drops') end
    end
    UpdateXY()
    AfterFrame()
    if SaveResume then SaveResume.afterLogic() end
end
_G.DoFrame = DoFrame
---缓速和加速
local function DoFrameEx()
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
        ext.MusicFrame("faketimer")
    end

    ext.FastMusic()
end

----------------------------------------
---extra game call-back function
local mask_fader = mask_fader
local ui_drawing = ui_drawing
local setting = setting
function FrameFunc()
    if GameNet then GameNet.poll();GameNet.controls() end
    if SaveSync then SaveSync.frame() end
    if SaveSync and SaveSync.visible and not SaveProfiles.pending then
        -- 同步页只暂停战斗，不累计等待期间的逻辑帧。
        return false
    end

    if GameNet and GameNet.client() then
        if stage.next_stage then DoFrame() end
        GameNet.clientFrame();return false
    end
    if ui.ResourceLoading and ui.ResourceLoading.beforeFrame() then return false end
    if ui.ResourceLoading and ui.ResourceLoading.state then
        -- 加载入口只执行一次场景初始化，不经过倍率、录像和音乐逻辑时钟。
        if stage.next_stage then DoFrame() end
        return false
    end
    -- 预载仅占显示帧，不消费录像输入或推进战斗时钟；缓存命中不会改变录像帧序。
    if RogueEncounter and RogueEncounter.preloadFrame() then
        return false
    end
    if GameNet and not GameNet.readyForLogic() then
        return false
    end
    if SaveResume and SaveResume.recovering then
        SaveResume.pump(DoFrame)
        return false
    end
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
        local loading = (stage.current_stage and stage.current_stage.stage_name == 'init')
            or (stage.next_stage and stage.next_stage.stage_name == 'init')
        if loading then
            -- 加载入口清空上一场景的倍率余数，不补跑初始化期间的帧。
            ext.FrameCounter = 0
        end
        -- 每次显示回调只推进当前倍率对应的逻辑帧，不按墙钟时间追帧。
        DoFrameEx()
        if ui.ResourceLoading then ui.ResourceLoading.afterFrame() end
        --按键弹出菜单
        if not (GameNet and GameNet.active()) and (GetLastKey() == setting.keysys.menu and not lstg.tmpvar.noPause or ext.pop_pause_menu) and not ext.StageIsMenu() then
            ext.pause_menu:FlyIn()
            if SaveResume then SaveResume.flush("暂停") end
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
    if SaveResume and SaveResume.recovering then return SaveResume.renderRecovery() end
    if SaveSync and SaveSync.visible then return end
    if ui.ResourceLoading and ui.ResourceLoading.state then
        BeginScene()
        SetViewMode('ui')
        RenderClear(Color(255,0,0,0))
        ui.ResourceLoading.render()
        EndScene()
        return
    end
    if AndroidPortrait and AndroidPortrait.editor then
        -- 编辑页使用独立空画布，场景对象、音乐栏和淡出遮罩不参与绘制。
        BeginScene();SetViewMode('ui');RenderClear(Color(255,0,0,0))
        AndroidPortrait.editor:render();EndScene();return
    end
    if GameNet and GameNet.client() then
        BeginScene();GameNet.clientRender();GameNet.render();EndScene();return
    end
    if GameNet then GameNet.Capture.begin() end
    BeginScene()
    SetViewMode("ui")
    -- SetWorldFlag(1)
    Failed_Show:BeforeRender()

    ext.saveScreenBefore()
    ext.BeforeRender()
    local stage = stage

    mask_fader:BeforeRender()
    if stage.current_stage then

        local perf=AndroidProfiler
        if perf then perf.begin('render.ui.before') end
        ui_drawing:Beforerender()
        if perf then perf.finish('render.ui.before');perf.begin('render.stage') end
        local visual=TH38 and NativePlayers.enabled(nil,36) and TH38.visual
        local deathEffect=visual and visual.beginWorld()
        stage.current_stage:render()
        if perf then perf.finish('render.stage') end
        ext.CameraBefore()
        ObjRender()
        if GameDrops then GameDrops.render() end
        ext.CameraAfter()
        if deathEffect then visual.endWorld(deathEffect) end
        if perf then perf.begin('render.ui.after') end
        ui_drawing:Afterrender()
        if SequenceResources and SequenceResources.renderContinue then SequenceResources.renderContinue(stage.current_stage) end
        if perf then perf.finish('render.ui.after') end

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
    if SaveSync then SaveSync.render() end

    EndScene()
    if GameNet then GameNet.Capture.finish() end
    if SaveResume then SaveResume.afterRender() end


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
    if SaveResume then SaveResume.flush("失去焦点") end
    --[[
        if not stage.current_stage.is_menu and ext.pause_menu:IsKilled() then
            ext.pause_menu:FlyIn()
        end--]]
end--失去焦点时弹出暂停
