-- 大往生 V101 的关卡对象。生成表先分配机体，机体发射后再推进敌弹槽。
local directory = 'mod/GAME/th44/native/'
local program = dofile(directory .. 'program.lua')
local scroll = dofile(directory .. 'scroll.lua')(program)
local bullets = dofile(directory .. 'enemy_bullet.lua')(program)
local effects = dofile(directory .. 'effect.lua')(program)
local items = dofile(directory .. 'item.lua')(program)
local collision = dofile(directory .. 'collision.lua')(program)
local weapons = dofile(directory .. 'player_shot.lua')(program)
local laser = dofile(directory .. 'player_laser.lua')(program, collision, weapons)
local supply = dofile(directory .. 'player_supply.lua')(program,laser)
local hyper = dofile(directory .. 'player_hyper.lua')(program,bullets,laser,items)
local bombs = dofile(directory .. 'player_bomb.lua')(program,bullets,collision,laser,hyper)
local players = dofile(directory .. 'player.lua')(program,weapons,laser,bombs,hyper,supply)
local path = dofile('mod/GAME/th43/native/path.lua')(program)
local band = require('bit').band
local s16, word = program.s16, program.word
local M = {program=program, bullets=bullets, scroll=scroll, collision=collision, hyper=hyper, supply=supply}

function path.attach(o)
    -- 0x162096 在读取初始坐标后执行挂载的路径指令，再应用该记录的横向参数。
    local row, run = o.row, o.run
    local cursor = row[5] - run.stage.pathBase + 1
    o.path = run.stage.paths
    if row.h then
        o.h, o.l = row.h, s16(row.l + run.cameraOffset)
    else
        o.h, o.l = s16(word(o.path, cursor)), s16(word(o.path, cursor + 2))
        cursor = cursor + 4
    end
    if not path.start(o, cursor) then return false end
    o.l = s16(o.l + band(row[2] - run.scrollPhase, 0x7f) * 0x200 - 0x800)
    if band(o.spawnFlags, 1) ~= 0 then o.l = s16(o.l - run.cameraOffset) end
    return true
end

local function remove(o)
    o.run.enemies[o.slot] = nil
    local parts = o.run.partSlots[o.partPool]
    for index = o.firstPart, o.firstPart + o.parts - 1 do parts[index] = nil end
    for _, part in ipairs(o.extraParts) do object.RawDel(part) end
    object.RawDel(o)
end

local scout = dofile(directory .. 'scout.lua')(program, path, bullets, remove, hyper)
local stage3Scout = dofile(directory .. 'stage3_scout.lua')(program, path, bullets, effects, remove, hyper)
local stage3Carrier = dofile(directory .. 'stage3_carrier.lua')(program, path, bullets, effects, remove, hyper)
local stage3Bunker, stage3Hatches =
    dofile(directory .. 'stage3_fortifications.lua')(program, path, bullets, effects, remove, hyper)
local stage3Spinner = dofile(directory .. 'stage3_spinner.lua')(program, path, bullets, effects, remove, hyper)
local mid3, mid3Child = dofile(directory .. 'mid3.lua')(program, bullets, effects, remove, hyper)
local stage3Escort, mid3Backdrop = dofile(directory .. 'stage3_road.lua')(program, path, bullets, effects, remove, hyper)
local stage3Cannon, stage3Airship, stage3Pulse =
    dofile(directory .. 'stage3_after.lua')(program, path, bullets, effects, remove, hyper)
local stage3Flypast, stage3Gate, stage3WideGate =
    dofile(directory .. 'stage3_gate.lua')(program, path, bullets, effects, remove, hyper)
local stage4Pulse, stage4Bridge, stage4Hatches, stage4Turret =
    dofile(directory .. 'stage4_opening.lua')(program, path, bullets, effects, remove, hyper)
local stage4Fleet = dofile(directory .. 'stage4_fleet.lua')(program, path, bullets, effects, remove, hyper)
local mid4, mid4Daughter = dofile(directory .. 'mid4.lua')(program, path, bullets, effects, remove, supply, hyper)
local stage4Tower, stage4Scenery = dofile(directory .. 'stage4_late.lua')(program, path, bullets, effects, items, remove, hyper)
local stage4Facility, stage4Smoke =
    dofile(directory .. 'stage4_facility.lua')(program, path, bullets, effects, items, remove, hyper)
local stage5Ship, stage5Sweeper, stage5Reinforcements =
    dofile(directory .. 'stage5_opening.lua')(program, path, bullets, effects, items, remove, hyper)
local mid5Entry, mid5, mid5Flame = dofile(directory .. 'mid5.lua')(program, bullets, effects, remove, hyper)
local stage5Gun, stage5Hatch, stage5Platform =
    dofile(directory .. 'stage5_doors.lua')(program, path, bullets, effects, items, remove, hyper)
local stage5Fort = dofile(directory .. 'stage5_fort.lua')(program, path, bullets, effects, remove, hyper)
local mid5Second = dofile(directory .. 'mid5_second.lua')(program, bullets, effects, remove, hyper)
local mid5Parts = dofile(directory .. 'mid5_second_parts.lua')(program, bullets, effects, remove, hyper)
local stage5Towers = dofile(directory .. 'stage5_towers.lua')(program, path, bullets, effects, remove, hyper)
local stage5Heavy = dofile(directory .. 'stage5_heavy.lua')(program, path, bullets, effects, items, remove, hyper)
local tank = dofile(directory .. 'tank.lua')(program, path, bullets, effects, remove, hyper)
local carrier = dofile(directory .. 'carrier.lua')(program, path, bullets, effects, remove, supply, hyper)
local gunship = dofile(directory .. 'gunship.lua')(program, path, bullets, effects, remove, hyper)
local scenery = dofile(directory .. 'scenery.lua')(program, path, effects, items, remove, hyper)
local spawner = dofile(directory .. 'spawner.lua')(program, remove)
local mid1 = dofile(directory .. 'mid1.lua')(program, path, bullets, effects, remove, hyper)
local artillery = dofile(directory .. 'artillery.lua')(program, path, bullets, effects, remove, hyper)
local groundgun, stage5TrackGun = dofile(directory .. 'groundgun.lua')(program, path, bullets, effects, items, remove, hyper)
local heavy = dofile(directory .. 'heavy_tank.lua')(program, path, bullets, effects, items, remove, hyper)
local approach = dofile(directory .. 'approach.lua')(program, path, remove)
local boss1 = dofile(directory .. 'boss1.lua')(program, bullets, effects, remove, hyper)
local boss2 = dofile(directory .. 'boss2.lua')(program, bullets, effects, remove, hyper)
local boss3 = dofile(directory .. 'boss3.lua')(program, bullets, effects, remove, hyper)
local boss4 = dofile(directory .. 'boss4.lua')(program, bullets, effects, items, remove, hyper)
local boss5 = dofile(directory .. 'boss5.lua')(program, bullets, effects, items, remove, hyper)
local boss4Seed, boss4Orb = dofile(directory .. 'boss4_children.lua')(program, bullets, effects, remove, hyper)
local boss3Pod, boss3Charge = dofile(directory .. 'boss3_pods.lua')(program, bullets, effects, items, remove)
local boss2Trail = dofile(directory .. 'boss2_trail.lua')(program, effects, remove)
local wingCharge = dofile(directory .. 'wing_charge.lua')(program, bullets, effects, remove)
local airframe = dofile(directory .. 'airframe.lua')(program, path, bullets, effects, remove, hyper)
local stage2Turrets = dofile(directory .. 'stage2_turrets.lua')(program, path, bullets, effects, items, remove, hyper)
local groundShip, stage2Battleship, stage2Supply =
    dofile(directory .. 'stage2_ships.lua')(program, path, bullets, effects, items, remove, hyper)
local mid2 = dofile(directory .. 'mid2.lua')(program, path, bullets, effects, remove, hyper)
local stage2Freight, stage2SideTurret, stage2Cruiser =
    dofile(directory .. 'stage2_road.lua')(program, path, bullets, effects, items, remove, hyper)
local mid1Wreck = {
    parts = 1,
    init = function(o)
        o.flags, o.h, o.l = 0x8000, 0x3800, 0x1c00
        return true
    end,
    step = function(o)
        if o.run.major == 0x105 then remove(o); return end
        scroll.replaceRows(o.run, 0xbc / 4, program.mid1Wreck)
    end,
    render = function() end,
}
local handlers = {
    [0x1660a8]={parts=1, init=function(o) o.flags,o.h,o.l = 0x8000,0,0; return true end,
        step=remove, render=function() end},
    [0x16250a]=stage3Carrier, [0x163034]=stage3Bunker, [0x163710]=stage3Spinner,
    [0x163d14]=stage3Scout, [0x1640de]=stage3Scout, [0x164368]=mid3Backdrop,
    [0x16452c]=stage3Flypast, [0x164710]=stage3Gate, [0x164c6c]=stage3WideGate, [0x16526e]=stage3Hatches,
    [0x1642a0]=stage5Reinforcements, [0x167bdc]=stage5Sweeper, [0x1728de]=stage5Ship,
    [0x1656c0]=stage3Cannon, [0x165ab2]=stage3Pulse, [0x165c86]=stage3Escort,
    [0x166abe]=scout, [0x167158]=scout, [0x1676f8]=stage5Heavy, [0x168576]=tank, [0x168b6e]=tank,
    [0x168082]=approach, [0x168e70]=tank, [0x1690ec]=tank, [0x1695b4]=tank,
    [0x169f86]=mid1, [0x16aa82]=mid1Wreck, [0x16ac58]=mid3, [0x16bd2a]=mid3Child,
    [0x16c69a]=mid5Entry, [0x16c892]=mid5, [0x16d4ba]=mid5Flame,
    [0x16c038]=stage5Fort, [0x16de5a]=mid5Second,
    [0x16f69e]=stage5Gun, [0x16f94a]=stage5Hatch, [0x170c8c]=stage5Platform,
    [0x171314]=spawner, [0x172228]=gunship, [0x17302e]=artillery,
    [0x1734f8]=stage3Airship, [0x173b18]=groundShip, [0x17417c]=carrier,
    [0x1747e6]=heavy, [0x174d88]=stage5TrackGun, [0x174fb8]=scenery, [0x175134]=scenery, [0x1752b8]=stage2Turrets,
    [0x175bf4]=groundgun, [0x175e82]=stage2Turrets, [0x176268]=airframe,
    [0x1767d8]=stage2Cruiser, [0x176d7a]=stage4Turret, [0x177246]=stage4Pulse, [0x1774c0]=mid2, [0x17814a]=stage2Supply,
    [0x1783e0]=stage2Freight, [0x178624]=stage2Freight, [0x1787fc]=stage2Freight,
    [0x178a66]=stage2SideTurret, [0x178dfa]=stage2Battleship, [0x179596]=stage4Bridge, [0x179792]=stage4Fleet,
    [0x17a030]=mid4, [0x17aba2]=mid4Daughter, [0x17b7b2]=stage4Scenery, [0x17b918]=stage4Hatches,
    [0x17b0c0]=stage4Facility, [0x17bf2e]=stage4Tower, [0x17c3f2]=stage4Smoke,
    [0x190b0a]=boss1, [0x195020]=wingCharge, [0x195256]=approach, [0x1955ea]=boss2,
    [0x199dee]=boss2Trail, [0x199e52]=boss2Trail,
    [0x19a11e]=boss3, [0x19c9c8]=boss3Pod, [0x19ce92]=boss3Charge,
    [0x19d21c]=boss4, [0x1a1b92]=boss4Seed, [0x1a1e3e]=boss4Orb,
    [0x1a2938]=boss5,
}
for address, handler in pairs(mid5Parts) do handlers[address] = handler end
for address, handler in pairs(stage5Towers) do handlers[address] = handler end

local HitBox = Class(object, {
    init = function(o, host)
        o.host, o.run, o.damage = host, host.run, host.damage
        o.group, o.layer, o.bound, o.colli = GROUP.ENEMY, LAYER.ENEMY, false, false
    end,
})

local Enemy = Class(object, {
    init = function(o, run, slot, row, handler, partPool, firstPart)
        o.run, o.slot, o.row, o.kind, o.spawnFlags = run, slot, row, row[3], row[4]
        o.group, o.layer, o.bound, o.colli = GROUP.ENEMY, LAYER.ENEMY, false, false
        o.partPool, o.firstPart, o.parts = partPool, firstPart, handler.parts
        o.state, o.part = {}, {}
        o.callback, o.update, o.draw, o.damage = row[7], handler.step, handler.render, handler.damage
        o.extraParts = {}
        for index = 2, handler.parts do o.extraParts[index - 1] = New(HitBox, o) end
        o.initialized = handler.init(o)
        if o.initialized then o.x, o.y = program.world(o.h, o.l) end
    end,
    render = function(o) o.draw(o) end,
})

local Background = Class(object, {
    init = function(o, run)
        o.run, o.group, o.layer, o.bound, o.colli = run, GROUP.GHOST, LAYER.BG, false, false
    end,
    render = function(o)
        local run = o.run
        local x = -128 - math.floor(run.cameraOffset / 64)
        local y = -208 - math.floor(run.tileProgress[1] / 64)
        for row, tiles in ipairs(run.visibleRows) do
            for column, id in ipairs(tiles) do
                Render(run.tileArt[id][1], x + (column - 1) * 32, y + (row - 1) * 32)
            end
        end
    end,
})

local function slotRange(kind, flags)
    if kind >= 0x20 and kind <= 0x23 then return 3, 10 end
    if flags < 0 then return 1, 2 end
    return 11, 58
end

local function freeParts(slots, limit, count)
    local available = 0
    for index = 1, limit do
        available = slots[index] and 0 or available + 1
        if available == count then return index - count + 1 end
    end
end

function M.spawn(run, row)
    local begin, ending = slotRange(row[3], row[4])
    for slot = begin, ending do
        if not run.enemies[slot] then
            local handler = assert(handlers[row[7]], ('尚未翻译敌机回调 0x%06x'):format(row[7]))
            -- 0x161e40 在两个部件池中找连续空槽，失败时放弃这条生成指令。
            local bank = band(row[4], 0xa0) == 0 and 1 or 2
            local parts = run.partSlots[bank]
            local first = freeParts(parts, bank == 1 and 100 or 50, handler.parts)
            if not first then return end
            local o = New(Enemy, run, slot, row, handler, bank, first)
            if not o.initialized then remove(o); return end
            parts[first] = o
            for index, part in ipairs(o.extraParts) do parts[first + index] = part end
            run.enemies[slot] = o
            return o
        end
    end
end

local art, tileArt
local function loadArt(kind, rects)
    local sprites = {}
    local loaded = {}
    for index, rect in ipairs(rects) do
        local page, x, y, w, h = unpack(rect)
        local texture = 'th44_native_' .. kind .. '_' .. page
        if not loaded[page] then
            LoadTexture(texture, 'Resources/th44/native/native_' .. kind .. page .. '.png')
            SetTextureSamplerState(texture, 'point+clamp')
            loaded[page] = true
        end
        local name = 'th44_native_' .. kind .. '_image_' .. index
        LoadImage(name, texture, x, y, w, h)
        sprites[index] = {name,w,h}
    end
    return sprites
end

function M.init(stage, state, withArt)
    local run = {
        stage=assert(program.stages[stage]), stageNumber=stage,
        major=0, spawnIndex=1, frame=0, enemies={}, bullets={}, effects={}, items={}, partSlots={{},{}}, spawnQueue={},
        scrollPhase=0, aimPhase=3, randomByte=0, bulletCapacity=70, loop=0, difficulty=stage - 1, enemyShotGrace=0,
        enemyRank=0, fireRank=0, trackRank=0, lateRank=0, bulletRank=0, largeRank=0, salvoRank=0, tankRank=0,
        carrierRank=0, rapidRank=0, heavyRank=0, cannonRank=0, groundRank=0, gunRank=0,
        rawRank=0, escortRank=0, spinnerGate={},
        hatchOpenRank=0,
        airSupply={}, hyperItems={}, hyperMotionCursor=1, hyperBulletRank=0,
    }
    scroll.init(run)
    if state and state.loop and state.loop ~= 0 then run.bulletCapacity = 110 end
    for name, value in pairs(state or {}) do run[name] = value end
    if not run.staticRank then
        run.ranks,run.rankTime = {},run.rankTime or 0
        program.updateRank(run)
    end
    if withArt then
        if not art or not lstg.CheckRes(2, art[1][1]) then
            art = loadArt('sprites', program.sprites)
            tileArt = loadArt('tiles', program.tileRects)
        end
        run.art, run.tileArt = art, tileArt
        run.background = New(Background, run)
    end
    return run
end

function M.addPlayer(run, model, doll, options)
    assert(not run.player, '关卡已登记自机')
    run.player = players.spawn(run, model, doll, options)
    return run.player
end

function M.step(run)
    run.frame = run.frame + 1
    run.aimPhase = (run.aimPhase + 1) % 4
    local pilot = run.player
    local priorScore = pilot and pilot.score
    if pilot then hyper.rank(pilot) end
    if run.ranks and not run.freeze then run.rankTime = run.rankTime + 1 end
    program.updateRank(run)
    scroll.step(run)
    if not run.freeze and run.enemyShotGrace > 0 then run.enemyShotGrace = run.enemyShotGrace - 1 end
    if pilot then players.step(pilot) end
    scroll.camera(run)
    if pilot then
        laser.step(pilot)
        weapons.step(pilot)
        bombs.step(pilot)
    end
    program.spawnRows(run, M.spawn)
    -- 0x161cd4 在关卡表之后从队尾消费上一帧敌机登记的生成项。
    for slot = #run.spawnQueue, 1, -1 do
        local row = run.spawnQueue[slot]
        run.spawnQueue[slot] = nil
        M.spawn(run, row)
    end
    -- 0x161d90 按槽序推进，主部件先扣除相机横移量。
    for slot = 1, 58 do
        local o = run.enemies[slot]
        if o then
            o.l = s16(o.l - run.cameraStep)
            o.update(o)
        end
    end
    effects.step(run)
    items.step(run,hyper)
    supply.step(run,1,12)
    if pilot then hyper.step(pilot) end
    supply.step(run,25,25)
    bullets.step(run, items)
    if pilot then
        bombs.collide(pilot)
        if run.frame % 2 == 1 then
            if pilot.active then
                -- 0x1440a2 先检查弹心。命中直接越过道具与机身扫描。
                pilot.pendingHit = bullets.contact(run,pilot)
                if not pilot.pendingHit then
                    supply.contact(run,pilot)
                    hyper.contact(pilot)
                    items.contact(run,pilot)
                    pilot.pendingHit = collision.body(run,pilot)
                end
            end
            collision.shots(run,pilot.shots,pilot.hitFlags)
            laser.collide(pilot)
        elseif run.loop ~= 0 and pilot.active then
            -- 0x189a56 的二周目补扫只调用 0x144080，另一帧仍可被敌弹击中。
            pilot.pendingHit = bullets.contact(run,pilot)
        end
        players.extend(pilot,priorScore)
    end
end

function M.close(run)
    for _, o in pairs(run.enemies) do remove(o) end
    bullets.close(run)
    effects.close(run)
    items.close(run)
    supply.close(run)
    if run.player then
        bombs.close(run.player)
        hyper.close(run.player)
        weapons.close(run.player)
        laser.close(run.player)
        object.RawDel(run.player)
    end
    if run.background then object.RawDel(run.background) end
end

-- 0x1428da 把下一面的编号交给 0x18b96a。换面清对象槽和地面道具计数，自机库存留在自机槽。
function M.advance(run)
    if not run.stageCleared or run.stageAdvanced then return end
    local p = assert(run.player)
    if p.defeated then return end
    local nextStage,loop = run.stageNumber + 1,run.loop
    if nextStage > #program.stages then
        -- 0x18e4d6 检查一周目入场条件。原版的地蜂面数按每面加四储存。
        if loop ~= 0 or run.dual or (p.fullBeeStages < 3 and p.misses > 2 and p.bombsUsed > 3) then return end
        nextStage,loop = 1,1
    end
    local nextRun = M.init(nextStage,{
        loop=loop,dual=run.dual,randomByte=run.randomByte,rankTime=run.rankTime,
        staticRank=run.staticRank,difficulty=run.staticRank and run.difficulty or nil,
    },run.art ~= nil)
    -- 0x1496de 在关间定位 P1，0x18b9b0 恢复操作。
    local maxBombs = loop == run.loop and p.maxBombs or program.pilotBombCount[p.doll]
    local pilot = M.addPlayer(nextRun,p.model,p.doll,{h=0xc00,l=0xe00,keys=p.key,life=p.life,
        maxBombs=maxBombs,bombs=loop == run.loop and p.bombs or maxBombs,protect=0})
    pilot.shotLevel,pilot.laserLevel = p.shotLevel,p.laserLevel
    pilot.score,pilot.misses,pilot.bombsUsed = p.score,p.misses,p.bombsUsed
    pilot.scoreExtends = p.scoreExtends
    pilot.fullBeeStages,pilot.hyperStock = p.fullBeeStages,p.hyperStock
    if loop == run.loop then
        pilot.hyperGauge,pilot.hyperRank,pilot.hyperClock = p.hyperGauge,p.hyperRank,p.hyperClock
        pilot.hyperQueued = p.hyperQueued
    end
    run.stageAdvanced = true
    M.close(run)
    return nextRun
end

return M
