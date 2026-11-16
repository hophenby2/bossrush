-- 练习关卡使用 V101 的两周目流程，输入仍按项目的 60Hz 录像格式读取。
local runtime = dofile('mod/GAME/th44/native/runtime.lua')
local M = {level=42}

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
            return setPlayer(runtime.addPlayer(run,machine.model,machine.doll,{
                h=0x1000,l=0xe00,life=state.life,
            }),state)
        end,
    }
end

function M.open(scene)
    local w = lstg.world
    scene.pgmWorld = {w.l,w.r,w.b,w.t,w.boundl,w.boundr,w.boundb,w.boundt,
        w.scrl,w.scrr,w.scrb,w.scrt,w.pl,w.pr,w.pb,w.pt,w.world}
    local center = (w.scrl + w.scrr) / 2
    local half = (w.scrt - w.scrb) / 4
    OriginalSetWorld(-112,112,-224,224,-160,160,-270,270,
        center-half,center+half,w.scrb,w.scrt,-112,112,-224,224,w.world)
    SetBound(-160,160,-270,270)
    scene.pgmRun = runtime.init(1,nil,true)
    lstg.tmpvar.pgmRun = scene.pgmRun
end

function M.run(scene)
    local run = assert(scene.pgmRun)
    local state = assert(NativePlayers.state())
    local clock = 0
    while true do
        -- PGM 原时钟为 10MHz / (640 × 264)。
        clock = clock + 10000000
        if clock >= 10137600 then
            clock = clock - 10137600
            runtime.step(run)
            publish(run.player,state)
            if run.player.defeated then task.Wait(); return false end
            if run.stageCleared then
                local nextRun = runtime.advance(run)
                if not nextRun then return true end
                run = nextRun
                scene.pgmRun,lstg.tmpvar.pgmRun = run,run
                setPlayer(run.player,state)
            end
        end
        task.Wait()
    end
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
