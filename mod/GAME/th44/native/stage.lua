-- 练习关卡使用 V101 的两周目流程，输入仍按项目的 60Hz 录像格式读取。
local runtime = dofile('mod/GAME/th44/native/runtime.lua')
local M = {level=42}
local gameClock, boardClock = 10000000,10137600
local stages = #runtime.program.stages
local chapterNames = {}
for loop=0,1 do
    for index=1,stages do
        chapterNames[loop * stages + index] = ('%s · 第%d面'):format(loop == 0 and '一周目' or '二周目',index)
    end
end

local LoopChoice = Class(object, {
    init = function(o)
        o.layer,o.bound,o.colli = LAYER.TOP,false,false
        o.confirm,o.remaining = false,0x258
    end,
    render = function(o)
        local bright,normal = Color(255,255,226,138),Color(255,196,196,196)
        ui:RenderText('big_text','进入二周目？',0,44,0.48,bright,'centerpoint')
        ui:RenderText('big_text','继续',-44,2,0.38,o.confirm and bright or normal,'centerpoint')
        ui:RenderText('big_text','结束',44,2,0.38,o.confirm and normal or bright,'centerpoint')
        ui:RenderText('big_text',tostring(math.ceil(o.remaining / 60)),
            0,-37,0.32,normal,'centerpoint')
    end,
})

local function chooseLoop(clock)
    local prompt = New(LoopChoice)
    local keys = KeyState
    local left,right = not not keys.left,not not keys.right
    local shoot,spell = not not keys.shoot,not not keys.spell
    while prompt.remaining > 0 do
        task.Wait()
        clock = clock + gameClock
        if clock >= boardClock then
            clock = clock - boardClock
            keys = KeyState
            -- 0x18f512 读取按键边沿，左右各切换一次。A 或 B 确定当前选择。
            local nextLeft,nextRight = not not keys.left,not not keys.right
            local nextShoot,nextSpell = not not keys.shoot,not not keys.spell
            if (nextLeft and not left) ~= (nextRight and not right) then prompt.confirm = not prompt.confirm end
            if nextShoot and not shoot or nextSpell and not spell then break end
            left,right,shoot,spell = nextLeft,nextRight,nextShoot,nextSpell
            prompt.remaining = prompt.remaining - 1
        end
    end
    local confirm = prompt.confirm
    object.RawDel(prompt)
    return confirm,clock
end

local function publish(p,state)
    state.life,state.bombs,state.power = p.life,p.bombs,p.shotLevel
    local v = lstg.var
    v.score,v.lifeleft,v.bomb,v.bomb_used,v.dead = p.score,p.life,p.bombs,p.bombsUsed,p.misses
end

local function setPlayer(p,state)
    player,lstg.player = p,p
    publish(p,state)
    return p
end

if NativePlayers then
    NativePlayers.adapters[M.level] = {
        spawn = function()
            local state = assert(NativePlayers.state())
            local machine = assert(NativePlayers.machine(M.level,lstg.var.native_player_id))
            local run = assert(lstg.tmpvar.pgmRun)
            local pilot = runtime.addPlayer(run,machine.model,machine.doll,{
                h=0x1000,l=0xe00,life=state.life,
            })
            if run.practice then runtime.preparePractice(run) end
            return setPlayer(pilot,state)
        end,
    }
end

function M.open(scene, practice)
    local w = lstg.world
    scene.pgmWorld = {w.l,w.r,w.b,w.t,w.boundl,w.boundr,w.boundb,w.boundt,
        w.scrl,w.scrr,w.scrb,w.scrt,w.pl,w.pr,w.pb,w.pt,w.world}
    local center = (w.scrl + w.scrr) / 2
    local half = (w.scrt - w.scrb) / 4
    OriginalSetWorld(-112,112,-224,224,-160,160,-270,270,
        center-half,center+half,w.scrb,w.scrt,-112,112,-224,224,w.world)
    SetBound(-160,160,-270,270)
    scene.pgmRun = practice and runtime.initPractice(practice,true) or runtime.init(1,nil,true)
    lstg.tmpvar.pgmRun = scene.pgmRun
end

function M.run(scene,sequence)
    local run = assert(scene.pgmRun)
    local state = assert(NativePlayers.state())
    local clock = 0
    while true do
        -- PGM 原时钟为 10MHz / (640 × 264)。
        clock = clock + gameClock
        if clock >= boardClock then
            clock = clock - boardClock
            if run.practice and lstg.var.cheat then run.player.protect = 0xff end
            runtime.step(run)
            publish(run.player,state)
            if run.practiceComplete then return true end
            if sequence then
                sequence.chapter = run.loop * stages + run.stageNumber
                sequence.chapter_name,sequence.road_time = chapterNames[sequence.chapter],run.frame
            end
            if run.player.defeated then task.Wait(); return false end
            if run.stageCleared and run.player.active then
                if sequence then sequence.completed = sequence.chapter end
                local confirm
                if runtime.canEnterSecondLoop(run) then
                    runtime.settle(run)
                    publish(run.player,state)
                    confirm,clock = chooseLoop(clock)
                end
                local nextRun = runtime.advance(run,confirm)
                if not nextRun then
                    publish(run.player,state)
                    run.moveAfterClear = not sequence
                    return true
                end
                run = nextRun
                scene.pgmRun,lstg.tmpvar.pgmRun = run,run
                setPlayer(run.player,state)
                if sequence and run.loop ~= 0 then sequence.total = 2 * stages end
            end
        end
        task.Wait()
    end
end

function M.registerPractice()
    dofile('mod/GAME/pgm/practice.lua').register(M.level,'大往生',runtime.practiceEntries)
end

function M.close(scene)
    if not scene.pgmWorld then return end
    runtime.close(scene.pgmRun)
    if player == scene.pgmRun.player then player,lstg.player = nil,nil end
    OriginalSetWorld(unpack(scene.pgmWorld))
    SetBound(lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt)
    scene.pgmRun,scene.pgmWorld,lstg.tmpvar.pgmRun = nil,nil,nil
end

return M
