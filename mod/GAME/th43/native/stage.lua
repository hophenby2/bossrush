local runtime = dofile('mod/GAME/th43/native/runtime.lua')
local M = {level=41}
local stages = #runtime.program.stages
local routeNames = {first='一周目',omote='表二周目',ura='里二周目'}

local function publish(p, state)
    local v = lstg.var
    state.life, state.bombs, state.power = p.life, p.bombs, p.level
    v.score, v.lifeleft, v.bomb, v.bomb_used = p.score, p.life, p.bombs, p.bombsUsed
    v.dead = p.misses
end

local function setPlayer(p)
    player, lstg.player = p, p
    publish(p, NativePlayers.state())
    return p
end

if NativePlayers then
    NativePlayers.adapters[M.level] = {
        spawn = function()
            local run = assert(lstg.tmpvar.pgmRun)
            local model = lstg.var.native_player_id == 'panzer' and 2 or 1
            return setPlayer(runtime.addPlayer(run, model))
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
    scene.pgmRun = practice and runtime.initPractice(practice, true) or runtime.init(1, 'first', true)
    lstg.tmpvar.pgmRun = scene.pgmRun
end

function M.run(scene, sequence)
    local run = assert(scene.pgmRun)
    local state = assert(NativePlayers.state())
    local clock = 0
    while true do
        -- PGM 帧率为 10MHz / (640 × 264)。录像继续按项目的 60Hz 记录按键。
        clock = clock + 10000000
        if clock >= 10137600 then
            clock = clock - 10137600
            if run.practice and lstg.var.cheat then run.player.protect = math.max(2, run.player.protect) end
            runtime.step(run)
            publish(run.player, state)
            if run.practiceComplete then return true end
            if sequence then
                sequence.chapter = run.route.loop * stages + run.stageNumber
                sequence.chapter_name = ('%s · 第%d面'):format(routeNames[run.routeName], run.stageNumber)
                sequence.road_time = run.frame
            end
            if run.player.defeated then
                -- 关卡组在本帧处理失败和录像结算。
                task.Wait()
                return false
            end
            if run.stageCleared then
                if sequence then sequence.completed = sequence.chapter end
                if run.campaignCleared then
                    run.moveAfterClear = not sequence
                    return true
                end
                run = assert(runtime.advance(run))
                scene.pgmRun, lstg.tmpvar.pgmRun = run, run
                setPlayer(run.player)
                if sequence and run.route.loop > 0 then sequence.total = 2 * stages end
            end
        end
        task.Wait()
    end
end

function M.registerPractice()
    dofile('mod/GAME/pgm/practice.lua').register(M.level,'绊地狱',runtime.practiceEntries)
end

function M.close(scene)
    if not scene.pgmWorld then return end
    runtime.close(scene.pgmRun)
    if player == scene.pgmRun.player then player, lstg.player = nil, nil end
    OriginalSetWorld(unpack(scene.pgmWorld))
    SetBound(lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt)
    scene.pgmRun, scene.pgmWorld, lstg.tmpvar.pgmRun = nil, nil, nil
end

return M
