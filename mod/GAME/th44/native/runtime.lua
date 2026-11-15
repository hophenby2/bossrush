-- 大往生 V101 的关卡对象。生成表先分配机体，机体发射后再推进敌弹槽。
local directory = 'mod/GAME/th44/native/'
local program = dofile(directory .. 'program.lua')
local scroll = dofile(directory .. 'scroll.lua')(program)
local bullets = dofile(directory .. 'enemy_bullet.lua')(program)
local effects = dofile(directory .. 'effect.lua')(program)
local items = dofile(directory .. 'item.lua')(program)
local collision = dofile(directory .. 'collision.lua')(program)
local weapons = dofile(directory .. 'player_shot.lua')(program)
local players = dofile(directory .. 'player.lua')(program, weapons)
local path = dofile('mod/GAME/th43/native/path.lua')(program)
local band = require('bit').band
local s16, word = program.s16, program.word
local M = {program=program, bullets=bullets, scroll=scroll, collision=collision}

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

local scout = dofile(directory .. 'scout.lua')(program, path, bullets, remove)
local tank = dofile(directory .. 'tank.lua')(program, path, bullets, effects, remove)
local carrier = dofile(directory .. 'carrier.lua')(program, path, bullets, effects, remove)
local gunship = dofile(directory .. 'gunship.lua')(program, path, bullets, effects, remove)
local scenery = dofile(directory .. 'scenery.lua')(program, path, effects, items, remove)
local spawner = dofile(directory .. 'spawner.lua')(program, remove)
local mid1 = dofile(directory .. 'mid1.lua')(program, path, bullets, effects, remove)
local artillery = dofile(directory .. 'artillery.lua')(program, path, bullets, effects, remove)
local groundgun = dofile(directory .. 'groundgun.lua')(program, path, bullets, effects, items, remove)
local heavy = dofile(directory .. 'heavy_tank.lua')(program, path, bullets, effects, items, remove)
local approach = dofile(directory .. 'approach.lua')(program, path, remove)
local boss1 = dofile(directory .. 'boss1.lua')(program, bullets, effects, remove)
local wingCharge = dofile(directory .. 'wing_charge.lua')(program, bullets, effects, remove)
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
    [0x166abe]=scout, [0x167158]=scout, [0x168576]=tank, [0x168b6e]=tank,
    [0x168082]=approach, [0x168e70]=tank, [0x1690ec]=tank, [0x1695b4]=tank,
    [0x169f86]=mid1, [0x16aa82]=mid1Wreck, [0x171314]=spawner, [0x172228]=gunship, [0x17302e]=artillery, [0x17417c]=carrier,
    [0x1747e6]=heavy, [0x174fb8]=scenery, [0x175134]=scenery, [0x175bf4]=groundgun,
    [0x190b0a]=boss1, [0x195020]=wingCharge, [0x195256]=approach,
}

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
        scrollPhase=0, aimPhase=3, randomByte=0, bulletCapacity=70, loop=0, difficulty=0, enemyShotGrace=0,
        enemyRank=0, fireRank=0, trackRank=0, lateRank=0, bulletRank=0, largeRank=0, salvoRank=0, tankRank=0,
        carrierRank=0, rapidRank=0, heavyRank=0,
    }
    scroll.init(run)
    for name, value in pairs(state or {}) do run[name] = value end
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
    scroll.step(run)
    if not run.freeze and run.enemyShotGrace > 0 then run.enemyShotGrace = run.enemyShotGrace - 1 end
    local pilot = run.player
    if pilot then players.step(pilot) end
    scroll.camera(run)
    if pilot then weapons.step(pilot) end
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
    items.step(run)
    bullets.step(run, items)
    if pilot then
        if pilot.active then
            pilot.pendingHit = bullets.contact(run, pilot) or collision.body(run, pilot)
            items.contact(run, pilot)
        end
        collision.shots(run, pilot.shots, pilot.hitFlags)
    end
end

function M.close(run)
    for _, o in pairs(run.enemies) do remove(o) end
    bullets.close(run)
    effects.close(run)
    items.close(run)
    if run.player then
        weapons.close(run.player)
        object.RawDel(run.player)
    end
    if run.background then object.RawDel(run.background) end
end

return M
