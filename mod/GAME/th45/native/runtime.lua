-- 0x14ee3c 先调度已经挂载的敌机，0x14ecfa 再消费同一卷轴位置的生成指令。
local directory = 'mod/GAME/th45/native/'
local program = dofile(directory .. 'program.lua')
local scroll = dofile(directory .. 'scroll.lua')(program)
local path = dofile(directory .. 'path.lua')(program)
local art = dofile(directory .. 'art.lua')(program)
local bullets = dofile(directory .. 'enemy_bullet.lua')(program,art)
local effects = dofile(directory .. 'effect.lua')(program,art)
local shots = dofile(directory .. 'pilot_shot.lua')(program,art)
local lasers = dofile(directory .. 'pilot_laser.lua')(program,art)
local guards = dofile(directory .. 'pilot_guard.lua')(program,art)
local rewards = dofile(directory .. 'reward.lua')(program,art,bullets)
local collision = dofile(directory .. 'collision.lua')(program,bullets,shots)
local pilot = dofile(directory .. 'pilot.lua')(program,shots,lasers,guards,art)
local groundTank,stationaryTank,trackingTank = dofile(directory .. 'ground_tank.lua')(program,path,bullets,art,effects,rewards)
local scout,patrol,heavyPatrol = dofile(directory .. 'aircraft.lua')(program,path,bullets,art,effects,rewards)
local hovercraft = dofile(directory .. 'hovercraft.lua')(program,path,bullets,art,effects)
local armoredCar = dofile(directory .. 'armored_car.lua')(program,path,bullets,art,effects)
local twinTank = dofile(directory .. 'twin_tank.lua')(program,path,bullets,art,effects)
local gunship = dofile(directory .. 'gunship.lua')(program,path,bullets,art,effects)
local mid1 = dofile(directory .. 'mid1.lua')(program,bullets,effects,art)
local dualCannon = dofile(directory .. 'dual_cannon.lua')(program,path,bullets,art,effects)
local formation = dofile(directory .. 'formation.lua')(program)
local boss1Mount = dofile(directory .. 'boss1_mount.lua')(program)
local boss1Core = dofile(directory .. 'boss1_core_actors.lua')(program,bullets,art,effects,boss1Mount)
local boss1 = dofile(directory .. 'boss1.lua')(program,bullets,art,effects,boss1Mount,boss1Core)
local boss1Arm = dofile(directory .. 'boss1_arm.lua')(program,bullets,art,effects)
local boss1Escort = dofile(directory .. 'boss1_escort.lua')(program,bullets,art,effects,boss1Mount)
local stage2Turret = dofile(directory .. 'stage2_turret.lua')(program,path,bullets,art,effects)
local largeCarrier,smallCarrier = dofile(directory .. 'stage2_carriers.lua')(program,path,bullets,art,effects)
local shed,fortCannons = dofile(directory .. 'stage2_forts.lua')(program,path,bullets,art,effects)
local mid2,mid2Exhaust,mid2Drone = dofile(directory .. 'mid2.lua')(program,bullets,effects,art)
local tailLead,tailChild,tailTank = dofile(directory .. 'stage2_tail.lua')(program,path,bullets,art,effects)
local boss2 = dofile(directory .. 'boss2.lua')(program,bullets,art,effects)
local boss2Orb = dofile(directory .. 'boss2_orb.lua')(program,bullets,art)
local boss2Mine = dofile(directory .. 'boss2_mine.lua')(program,bullets,art,effects)
local stage3Airships = dofile(directory .. 'stage3_airship.lua')(program,path,bullets,art,effects)
local stage3Raider = dofile(directory .. 'stage3_raider.lua')(program,path,bullets,art,effects)
local platform = dofile(directory .. 'stage3_platform.lua')(program,path,bullets,art,effects)
local mid3 = dofile(directory .. 'mid3.lua')(program,bullets,effects,art)
local mid3Drone = dofile(directory .. 'mid3_drone.lua')(program,bullets,effects,art)
local stage3Escort,stage3Deck,stage3Vent,stage3Cover = dofile(directory .. 'stage3_tail.lua')(program,path,bullets,art,effects)
local stage3Hull = dofile(directory .. 'stage3_hull.lua')(program,path,bullets,art,effects)
local stage3Heavy = dofile(directory .. 'stage3_heavy.lua')(program,path,bullets,art,effects)
local stage3TwinGun,stage3Gun,stage3Craft,stage3BroadGun = dofile(directory .. 'stage3_guns.lua')(program,path,bullets,art,effects)
local boss3 = dofile(directory .. 'boss3.lua')(program,bullets,art,effects)
local boss3Chain = dofile(directory .. 'boss3_chain.lua')(program,bullets,art,effects)
local boss3Flyer = dofile(directory .. 'boss3_flyer.lua')(program,bullets,art,effects)
local stage4Air,stage4Tank,stage4Carrier,stage4Mirrored = dofile(directory .. 'stage4_armor.lua')(program,path,bullets,art,effects)
local stage4Gunship = dofile(directory .. 'stage4_gunship.lua')(program,path,bullets,art,effects)
local mid4 = dofile(directory .. 'mid4.lua')(program,bullets,effects,art)
local boss4 = dofile(directory .. 'boss4.lua')(program,bullets,effects,art)
local boss4Cover = dofile(directory .. 'boss4_cover.lua')(program,art)
local boss4Drone = dofile(directory .. 'boss4_drone.lua')(program,bullets,effects,art)
local boss4Ring = dofile(directory .. 'boss4_ring.lua')(program,bullets)
local boss4CrossingDrone = dofile(directory .. 'boss4_crossing_drone.lua')(program,bullets,effects,art)
local boss4RearSeed,boss4RearSpark = dofile(directory .. 'boss4_rear_seed.lua')(program,bullets,effects,art)
local boss4ReturnDrone,boss4ReturnRing = dofile(directory .. 'boss4_return_actors.lua')(program,bullets,effects,art)
local boss4Core = dofile(directory .. 'boss4_core.lua')(program,bullets,art)
local stage5Gunship = dofile(directory .. 'stage5_gunship.lua')(program,path,bullets,art,effects)
local stage5TurretShip = dofile(directory .. 'stage5_turret_ship.lua')(program,path,bullets,art,effects)
local stage5Ark = dofile(directory .. 'stage5_ark.lua')(program,path,bullets,art,effects)
local stage6Patrol,stage6Sweep,stage6Glide,stage6Hop =
    dofile(directory .. 'stage6_patrol.lua')(program,path,bullets,art,effects)
local boss5 = dofile(directory .. 'boss5.lua')(program,bullets,effects,art)
local boss6Ring,boss6Node = dofile(directory .. 'boss6_ring.lua')(program,bullets,effects,art)
local boss6,boss6Escort,boss6Debris = dofile(directory .. 'boss6_opening.lua')(program,bullets,art,effects,boss6Ring)
local boss6Final = dofile(directory .. 'boss6_final.lua')(program,bullets,art,effects,rewards)
local boss6FinalRing = dofile(directory .. 'boss6_final_ring.lua')(program,bullets,effects,art)
local boss6FinalEdge = dofile(directory .. 'boss6_final_edge.lua')(program,bullets,effects,art)
local boss6FinalShard = dofile(directory .. 'boss6_final_shard.lua')(program,art)
local boss6FinalPort = dofile(directory .. 'boss6_final_port.lua')(program,bullets,art)
local smoke = dofile(directory .. 'smoke.lua')(program,path,effects)
local band = require('bit').band
local M = {program=program,collision=collision}

local handlers = {
    [0x14f3a6]={parts=1,init=function() return true end,step=function() return false end},
    [0x14fcc2]=formation,
    [0x159b3a]=groundTank,
    [0x159216]=stationaryTank,
    [0x159e88]=trackingTank,
    [0x15a73e]=tailTank,
    [0x150128]=scout,
    [0x150818]=hovercraft,
    [0x155514]=stage3Raider,
    [0x155d5a]=stage4Gunship,
    [0x154a62]=stage3Heavy,
    [0x15bd6a]=patrol,
    [0x15c372]=heavyPatrol,
    [0x15b34c]=stage3Escort,
    [0x1607a8]=stage3Vent,
    [0x160a9e]=stage3Hull,
    [0x16137a]=stage3Gun,
    [0x1618bc]=stage3TwinGun,
    [0x161eb4]=stage3BroadGun,
    [0x1559d6]=stage3Craft,
    [0x1628b2]=stage3Deck,
    [0x163378]=dualCannon,
    [0x164166]=stage5Ark,
    [0x1649f2]=twinTank,
    [0x164fd8]=armoredCar,
    [0x165446]=smoke,
    [0x165584]=mid2Exhaust,
    [0x1658c0]=largeCarrier,
    [0x1660f4]=smallCarrier,
    [0x166596]=stage2Turret,
    [0x1668a8]=shed,
    [0x166be8]=platform,
    [0x167038]=fortCannons,
    [0x16778a]=tailLead,
    [0x167e7e]=tailChild,
    [0x168b56]=stage4Air,
    [0x169214]=stage4Tank,
    [0x169876]=stage4Carrier,
    [0x169f38]=stage4Mirrored,
    [0x16b26c]=stage5Gunship,
    [0x16ac34]=stage5TurretShip,
    [0x16c36a]=gunship,
    [0x16bd8e]=stage3Cover,
    [0x188a56]=boss1,
    [0x189e80]=boss1Escort,
    [0x18ab18]=boss1Arm,
    [0x18b25e]=boss1Mount.carrier,
    [0x18f0ac]=boss2,
    [0x192c58]=boss2Mine,
    [0x192e3c]=boss2Orb,
    [0x19319e]=boss3,
    [0x195426]=boss3Chain,
    [0x195f92]=boss3Flyer,
    [0x197d7e]=boss4,
    [0x19ec24]=boss4Cover,
    [0x19f156]=boss4Drone,
    [0x19de96]=boss4Ring,
    [0x19d312]=boss4CrossingDrone,
    [0x19edb8]=boss4RearSeed,
    [0x19ef3a]=boss4RearSpark,
    [0x19cf9e]=boss4ReturnDrone,
    [0x19da78]=boss4ReturnRing,
    [0x19ea9e]=boss4Core,
    [0x1af618]=mid1,
    [0x1b1e90]=mid2,
    [0x1b5166]=mid2Drone,
    [0x1b56c0]=mid3,
    [0x1b79ba]=mid3Drone,
    [0x1b8026]=mid4,
    [0x1ba6e2]=boss5,
    [0x16a95c]=boss5.wreck,
    [0x15734e]=stage6Patrol,
    [0x157bcc]=stage6Sweep,
    [0x1585b6]=stage6Glide,
    [0x158ba8]=stage6Hop,
    [0x1a7e60]=boss6,
    [0x1adc4e]=boss6Escort,
    [0x1aa65a]=boss6Ring,
    [0x1ab12a]=boss6Node,
    [0x1af1b2]=boss6Debris,
    [0x19f6be]=boss6Final,
    [0x1a74aa]=boss6FinalRing,
    [0x1a6dd4]=boss6FinalEdge,
    [0x1a7ac0]=boss6FinalShard,
    [0x1a78ac]=boss6FinalShard,
    [0x1a7774]=boss6FinalPort,
}
for callback,handler in pairs(boss1Core.handlers) do handlers[callback] = handler end
for callback,handler in pairs(stage3Airships) do handlers[callback] = handler end

local Enemy = Class(object,{
    init = function(o,run,slot,row,handler,bank,firstPart)
        o.run,o.slot,o.row,o.kind,o.spawnFlags = run,slot,row,row[3],row[4]
        o.partPool,o.firstPart,o.partCount = bank,firstPart,handler.parts
        o.group,o.layer,o.bound,o.colli = GROUP.ENEMY,LAYER.ENEMY,false,false
        o.part,o.state = {},{}
        o.callback,o.update,o.draw = row[10],handler.step,handler.render
        o.initialized = handler.init(o)
        -- 0x14efb4 在初始化返回后统一处理带地面标志的相机偏移。
        if o.initialized and o.l and band(o.spawnFlags,1) ~= 0 then
            o.l = program.s16(o.l-run.cameraOffset)
        end
        o.x,o.y = program.world(o.h or 0,o.l or 0)
    end,
    render = function(o)
        if o.draw then o.draw(o) end
    end,
})

local function slotRange(kind,flags)
    if kind >= 0x20 and kind <= 0x23 then return 3,10 end
    if band(flags,0x8000) ~= 0 then return 1,2 end
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
    if run.stage4Gunship==o then run.stage4Gunship=nil end
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
            for index,part in ipairs(o.extraParts or {}) do parts[firstPart + index] = part end
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
    -- 0x14ed90 在关卡表之后从队尾取出同帧登记的子机，子机下一帧才推进路径。
    local queue = run.spawnQueue
    while #queue > 0 do spawn(run,table.remove(queue)) end
end

function M.init(number, state, withArt)
    local run = {stageNumber=number,stageMode=number-1,stage=assert(program.stages[number]),frame=0,major=0,minor=0,
        spawnIndex=1,enemies={},bullets={},effects={},rewards={},partSlots={{},{}},spawnQueue={},tankStartRank=6,tankFireRank=15,
        bulletRank=0,awakeningBoost=7,awakeningDelay=0x12,randomIndex=0,
        airFireRank=0,lateFireRank=0,patrolTrackRank=0,patrolFireRank=0,volleyRank=0,
        sweepFireRank=0,
        gunshipMainRank=0xf,gunshipWingRank=0x15,fortStartRank=0x1b,fortBurstRank=4,
        roadChildRank=0x14,roadReloadRank=5,roadTankStartRank=11,platformFireRank=0x27}
    scroll.init(run)
    for key,value in pairs(state or {}) do run[key] = value end
    if withArt then art.load(run) end
    return run
end

function M.step(run)
    if run.stageCleared then
        local p = run.nativePlayer
        if p and not p.active then pilot.step(p) end
        return
    end
    run.frame = run.frame + 1
    local player,stopPathClock = run.nativePlayer,run.stopPathClock
    scroll.step(run)
    if player then
        pilot.step(player)
        shots.step(player)
        run.stopPathClock = stopPathClock or player.awakeningTick
    end
    stepEnemies(run)
    bullets.step(run,rewards.fromCancelledBullet)
    run.awakeningReload = false
    run.stopPathClock = stopPathClock
    effects.step(run)
    if player then rewards.step(run,player) end
    if player and player.active then
        collision.pilot(run,player)
        collision.body(run,player)
        if not player.pendingHit or player.protect ~= 0 then rewards.collect(run,player) end
        collision.shots(run,player)
        if player.guard then collision.guard(run,player)
        else collision.lasers(run,player) end
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
    for _,reward in pairs(run.rewards) do rewards.remove(reward) end
    if run.nativePlayer then
        for _,shot in pairs(run.nativePlayer.shots) do shots.remove(shot) end
        lasers.clear(run.nativePlayer)
        guards.clear(run.nativePlayer)
        object.RawDel(run.nativePlayer)
    end
    if run.background then object.RawDel(run.background) end
end

function M.advance(run)
    local p = run.nativePlayer
    if not run.stageCleared or run.stageAdvanced or not p or not p.active or run.stageNumber >= #program.stages then return end
    local nextRun = M.init(run.stageNumber+1,nil,run.art ~= nil)
    pilot.enterStage(p,nextRun)
    run.nativePlayer,run.player,run.stageAdvanced = nil,nil,true
    M.close(run)
    nextRun.nativePlayer,nextRun.player = p,p
    return nextRun
end

return M
