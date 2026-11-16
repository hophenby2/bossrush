-- 0x14ee3c 先调度已经挂载的敌机，0x14ecfa 再消费同一卷轴位置的生成指令。
local directory = 'mod/GAME/th45/native/'
local program = dofile(directory .. 'program.lua')
local scroll = dofile(directory .. 'scroll.lua')(program)
local path = dofile(directory .. 'path.lua')(program)
local art = dofile(directory .. 'art.lua')(program)
local bullets = dofile(directory .. 'enemy_bullet.lua')(program,art)
local effects = dofile(directory .. 'effect.lua')(program,art)
local shots = dofile(directory .. 'pilot_shot.lua')(program,art)
local collision = dofile(directory .. 'collision.lua')(program,bullets,shots)
local pilot = dofile(directory .. 'pilot.lua')(program,shots)
local groundTank,stationaryTank = dofile(directory .. 'ground_tank.lua')(program,path,bullets,art,effects)
local scout,patrol,heavyPatrol = dofile(directory .. 'aircraft.lua')(program,path,bullets,art,effects)
local armoredCar = dofile(directory .. 'armored_car.lua')(program,path,bullets,art,effects)
local smoke = dofile(directory .. 'smoke.lua')(program,path,effects)
local band = require('bit').band
local M = {program=program,collision=collision}

local handlers = {
    [0x14f3a6]={parts=1,init=function() return true end,step=function() return false end},
    [0x159b3a]=groundTank,
    [0x159216]=stationaryTank,
    [0x150128]=scout,
    [0x15bd6a]=patrol,
    [0x15c372]=heavyPatrol,
    [0x164fd8]=armoredCar,
    [0x165446]=smoke,
}

local Enemy = Class(object,{
    init = function(o,run,slot,row,handler,bank,firstPart)
        o.run,o.slot,o.row,o.kind,o.spawnFlags = run,slot,row,row[3],row[4]
        o.partPool,o.firstPart,o.partCount = bank,firstPart,handler.parts
        o.group,o.layer,o.bound,o.colli = GROUP.ENEMY,LAYER.ENEMY,false,false
        o.part,o.state = {},{}
        o.callback,o.update,o.draw = row[10],handler.step,handler.render
        o.initialized = handler.init(o)
        o.x,o.y = program.world(o.h or 0,o.l or 0)
    end,
    render = function(o)
        if o.draw then o.draw(o) end
    end,
})

local function slotRange(kind,flags)
    if kind >= 0x20 and kind <= 0x23 then return 3,10 end
    if band(flags,0x80) ~= 0 then return 1,2 end
    return 11,58
end

local function freeParts(slots,count,limit)
    local free = 0
    for i = 1,limit do
        free = slots[i] and 0 or free + 1
        if free == count then return i - free + 1 end
    end
end

local function remove(o)
    local run = o.run
    run.enemies[o.slot] = nil
    local parts = run.partSlots[o.partPool]
    for index = o.firstPart,o.firstPart + o.partCount - 1 do parts[index] = nil end
    object.RawDel(o)
end

local function spawn(run,row)
    local kind,flags,callback = row[3],row[4],row[10]
    local first,last = slotRange(kind,flags)
    for slot = first,last do
        if not run.enemies[slot] then
            local handler = assert(handlers[callback],('尚未翻译 Espgaluda 敌机回调 0x%06x'):format(callback))
            local bank = band(flags,0xa0) == 0 and 1 or 2
            local parts = run.partSlots[bank]
            local firstPart = freeParts(parts,handler.parts,bank == 1 and 90 or 30)
            if not firstPart then return end
            local o = New(Enemy,run,slot,row,handler,bank,firstPart)
            if not o.initialized then object.RawDel(o); return end
            run.enemies[slot],parts[firstPart] = o,o
            return o
        end
    end
end

local function stepEnemies(run)
    for slot = 1,58 do
        local o = run.enemies[slot]
        if o then
            if band(o.spawnFlags,0x40) == 0 and o.l then o.l = program.s16(o.l - run.cameraStep) end
            if not o.update(o) then remove(o)
            else o.x,o.y = program.world(o.h,o.l) end
        end
    end
    local list = run.stage.spawns
    local row = list[run.spawnIndex]
    while row and row[1] == run.major and row[2] == run.minor do
        spawn(run,row)
        run.spawnIndex = run.spawnIndex + 1
        row = list[run.spawnIndex]
    end
end

function M.init(number, state, withArt)
    local run = {stageNumber=number,stage=assert(program.stages[number]),frame=0,major=0,minor=0,
        spawnIndex=1,enemies={},bullets={},effects={},partSlots={{},{}},tankStartRank=6,tankFireRank=15,
        bulletRank=0,awakeningBoost=7,awakeningDelay=0x12,randomIndex=0,
        airFireRank=0,lateFireRank=0,patrolTrackRank=0,patrolFireRank=0}
    scroll.init(run)
    for key,value in pairs(state or {}) do run[key] = value end
    if withArt then art.load(run) end
    return run
end

function M.step(run)
    run.frame = run.frame + 1
    scroll.step(run)
    if run.nativePlayer then pilot.step(run.nativePlayer) end
    if run.nativePlayer then shots.step(run.nativePlayer) end
    stepEnemies(run)
    bullets.step(run)
    effects.step(run)
    if run.nativePlayer and run.nativePlayer.active then
        collision.pilot(run,run.nativePlayer)
        collision.body(run,run.nativePlayer)
        collision.shots(run,run.nativePlayer)
    end
end

function M.addPlayer(run,h,l,keys,protect)
    assert(not run.player,'此关卡已有自机')
    run.nativePlayer = pilot.spawn(run,h,l,keys,protect)
    run.player = run.nativePlayer
    return run.player
end

function M.close(run)
    for _,enemy in pairs(run.enemies) do remove(enemy) end
    for _,bullet in pairs(run.bullets) do bullets.remove(bullet) end
    for _,effect in pairs(run.effects) do effects.remove(effect) end
    if run.nativePlayer then
        for _,shot in pairs(run.nativePlayer.shots) do shots.remove(shot) end
        object.RawDel(run.nativePlayer)
    end
    if run.background then object.RawDel(run.background) end
end

return M
