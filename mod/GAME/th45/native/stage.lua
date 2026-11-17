-- 练习从第一面连续进入六面，原程序时钟与项目录像时钟分别推进。
local runtime = dofile('mod/GAME/th45/native/runtime.lua')
local M = {level=43}
local native = NativePlayers
local gameClock,boardClock = 10000000,10137600

local function publish(p,state)
    local v = lstg.var
    state.life = p.run.gameOver and -1 or math.max(0,p.reserveLives)
    state.bombs,state.power = math.floor(p.guardEnergy/0x400),p.power
    v.score,v.lifeleft,v.bomb = p.score,state.life,state.bombs
    v.dead,v.bomb_used = p.misses,p.guardsUsed
end

local HUD = Class(object,{
    init = function(o,scene)
        o.scene = scene
        o.group,o.layer,o.bound,o.colli = GROUP.GHOST,LAYER.TOP,false,false
    end,
    render = function(o)
        local p = o.scene.pgmRun.player
        if not p then return end
        -- 0x6e 和 0x24 分别是精灵石库存与护罩槽，觉圣死界只在库存为零时显示。
        local gems = p.form == 2 and p.gems == 0 and '觉圣死界' or ('精灵石 %03d'):format(p.gems)
        local color = Color(255,255,255,255)
        ui:RenderText('big_text',gems,-108,215,0.24,color,'left','vcenter','noclip')
        ui:RenderText('big_text',('第 %d 面'):format(p.run.stageNumber),108,215,0.24,color,'right','vcenter','noclip')
        SetImageState('white','',Color(200,30,39,45))
        RenderRect('white',-108,108,-220,-216)
        if p.guardEnergy > 0 then
            SetImageState('white','',Color(255,116,208,246))
            RenderRect('white',-108,-108+216*p.guardEnergy/0xfa0,-220,-216)
        end
        SetImageState('white','',color)
    end,
})

if native then
    native.adapters[M.level] = {
        spawn = function(state)
            local run = assert(lstg.tmpvar.pgmRun)
            run.reserveLives = state.life
            local p = runtime.addPlayer(run,0x2bec,0x1c00)
            player,lstg.player = p,p
            publish(p,state)
            return p
        end,
    }
end

function M.open(scene)
    local w = lstg.world
    scene.pgmWorld = {w.l,w.r,w.b,w.t,w.boundl,w.boundr,w.boundb,w.boundt,
        w.scrl,w.scrr,w.scrb,w.scrt,w.pl,w.pr,w.pb,w.pt,w.world}
    local center = (w.scrl+w.scrr)/2
    local half = (w.scrt-w.scrb)/4
    OriginalSetWorld(-112,112,-224,224,-160,160,-270,270,
        center-half,center+half,w.scrb,w.scrt,-112,112,-224,224,w.world)
    SetBound(-160,160,-270,270)
    scene.pgmRun = runtime.init(1,nil,true)
    lstg.tmpvar.pgmRun = scene.pgmRun
    scene.pgmHUD = New(HUD,scene)
end

function M.run(scene,sequence)
    local run = assert(scene.pgmRun)
    local state = assert(native.state())
    local clock = 0
    while true do
        clock = clock + gameClock
        if clock >= boardClock then
            clock = clock - boardClock
            runtime.step(run)
            local p = run.player
            publish(p,state)
            if sequence then
                sequence.chapter,sequence.road_time = run.stageNumber,run.frame
                sequence.chapter_name = ('第 %d 面'):format(run.stageNumber)
            end
            if run.gameOver then task.Wait(); return false end
            if run.stageCleared and p.active then
                if sequence then sequence.completed = run.stageNumber end
                if run.stageNumber == #runtime.program.stages then return true end
                run = assert(runtime.advance(run))
                scene.pgmRun,lstg.tmpvar.pgmRun = run,run
            end
        end
        task.Wait()
    end
end

function M.close(scene)
    if not scene.pgmWorld then return end
    object.RawDel(scene.pgmHUD)
    runtime.close(scene.pgmRun)
    if player == scene.pgmRun.player then player,lstg.player = nil,nil end
    OriginalSetWorld(unpack(scene.pgmWorld))
    SetBound(lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt)
    scene.pgmHUD,scene.pgmRun,scene.pgmWorld,lstg.tmpvar.pgmRun = nil,nil,nil,nil
end

return M
