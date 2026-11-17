-- 核心充能、两种放出装置和卫星使用原关卡的敌机队列及部件槽。
return function(program,bullets,art,effects,mounts)
    local band = require('bit').band
    local floor,max = math.floor,math.max
    local s16 = program.s16
    local data = program.boss1Core
    local M = {}

    function M.queue(origin,kind,h,l)
        local run = origin.run
        local queue = run.spawnQueue
        if #queue == 40 then return {} end
        local c = data.callbacks[kind]
        local row = {run.major,run.minor,kind,0,0,0,0,c[1],c[2],c[3],
            h=h or origin.h,l=l or origin.l,boss=origin.boss or origin}
        queue[#queue+1] = row
        return row
    end

    local function move(o,speed,angle)
        local dh,dl = program.vector(speed,angle,o.run.slowVectors)
        o.h,o.l = s16(o.h+dh),s16(o.l+dl)
    end

    function M.shot(o,kind,modifier,angle)
        local offset = program.mid1.ringOffsets[floor(band(angle+2,0xfc)/4)+1]
        local dh,dl = program.addPacked(0,0,offset)
        bullets.emit(o,kind,modifier,angle,dh,dl,true)
    end

    local function inside(o,h,l,hLimit,lLimit)
        return band(o.h+h,0xffff) < hLimit and band(o.l+l,0xffff) < lLimit
    end

    local function advanceImage(o,count)
        o.imageClock = o.imageClock-1
        if o.imageClock >= 0 then return end
        o.imageClock,o.imageFrame = 1,o.imageFrame%count+1
    end

    local function image(o,id,h,l,offset)
        if not o.run.art then return end
        h,l = program.addPacked(h,l,offset)
        art.draw(o.run.art.sprites[id],h,l,0,0)
    end

    local function initCharge(o)
        o.h,o.l,o.boss = o.row.h,o.row.l,o.row.boss
        o.imageClock,o.imageFrame,o.flags = 1,1,0x8000
        o.speed,o.direction = 0,0
    end

    local function chargeTarget(o)
        local core = o.boss.core
        local h = s16(core.h-0x1180)
        return h,core.l,{h=h,l=core.l,active=true}
    end

    local function drawRing(o,id,offset)
        for ray = 0,7 do
            local dh,dl = program.vector(o.radius,o.spin+ray*0x20,o.run.slowVectors)
            local h,l = program.addPacked(o.h,o.l,dh*2*0x10000+band(dl*4,0xffff))
            image(o,id,h,l,offset)
        end
    end

    local function releaseCharge(o,recoil)
        if not o.burstClock then
            o.burstClock,o.burstFrame = 1,1
            if recoil then
                local dh,dl = program.vector(o.speed,o.direction,o.run.slowVectors)
                o.dh,o.dl = floor(dh/2),floor(dl/2)
            end
        end
        o.burstClock = o.burstClock-1
        if o.burstClock < 0 then o.burstClock,o.burstFrame = 1,o.burstFrame+1 end
        return o.burstFrame <= #program.bulletHitImages
    end

    -- 0x18e9ea 每次移动叠加向心加速和反向减速，并将环的半径减八。
    local ring = {parts=1}
    function ring.init(o)
        initCharge(o)
        local _,_,target = chargeTarget(o)
        o.direction = program.angle8(target.h,target.l,{h=o.h,l=o.l,active=true},0)
        o.radius,o.spin,o.spinStep,o.repel = o.row.radius,0,o.row.spinStep,0x40
        return true
    end

    function ring.step(o)
        if o.boss.dying then return releaseCharge(o,false) end
        local h,l,target = chargeTarget(o)
        o.direction = program.angle8(o.h,o.l,target,o.direction)
        o.speed,o.repel = band(o.speed+2,255),max(0,o.repel-1)
        move(o,o.speed,o.direction)
        move(o,o.repel,0x80)
        if mounts.distance(o,h,l) <= 0x200 then return false end
        o.spin,o.radius = band(o.spin+o.spinStep,255),max(0,o.radius-8)
        advanceImage(o,4)
        return true
    end

    function ring.render(o)
        if o.burstFrame then drawRing(o,program.bulletHitImages[o.burstFrame],0xfe00fe00)
        else drawRing(o,data.chargeRing[o.imageFrame],0xfc00fe00) end
    end

    -- 0x18ec74 的散点先按随机角离开机身，充能打开后才向核心加速。
    local orb = {parts=1}
    function orb.init(o)
        initCharge(o)
        local run = o.run
        local _,_,target = chargeTarget(o)
        o.direction = program.angle8(target.h,target.l,{h=o.h,l=o.l,active=true},0)
        o.speed,o.scatter,o.scatterClock = 0x20,0x12,0
        local aim = program.angle8(o.h,o.l,run.player,0x80)
        o.scatterAngle = aim+program.random(run,program.randomNarrow)*8+program.random(run,program.randomNarrow)
        o.images = data.chargeOrb[program.random(run,program.randomByte)%2+1]
        return true
    end

    function orb.step(o)
        if o.boss.dying then
            if not releaseCharge(o,true) then return false end
            o.h,o.l = s16(o.h+o.dh),s16(o.l+o.dl)
        else
            local h,l,target = chargeTarget(o)
            o.direction = program.angle8(o.h,o.l,target,o.direction)
            if o.boss.core.charging and (o.h>0x1000 or o.homing) then
                o.homing,o.speed = true,band(o.speed+1,255)
                move(o,o.speed,o.direction)
                if o.scatter > 0 then
                    o.scatterClock = o.scatterClock-1
                    if o.scatterClock < 0 then o.scatterClock,o.scatter = 4,o.scatter-1 end
                end
            end
            move(o,o.scatter,o.scatterAngle)
            if mounts.distance(o,h,l) <= 0x180 then return false end
            advanceImage(o,4)
        end
        return inside(o,0x200,0x200,0x7400,0x3c00)
    end

    function orb.render(o)
        local id = o.burstFrame and program.bulletHitImages[o.burstFrame] or o.images[o.imageFrame]
        image(o,id,o.h,o.l,0xfe00fe00)
    end

    -- 0x18e59c 放出的飞行装置保留两组判定和独立的 0x100 耐久。
    local vessel = {parts=2}
    function vessel.init(o)
        local row = o.row
        o.h,o.l,o.boss,o.angle,o.twin = row.h,row.l,row.boss,row.angle,row.twin
        o.flags,o.front,o.back,o.right,o.left,o.hp = 0xa601,0x280,0x280,0x200,0x200,0x7fff
        o.second = {flags=0xa200,h=o.h,l=o.l,front=0x500,back=0x500,right=0x500,left=0x500,hp=0x7fff}
        o.extraParts = {o.second}
        o.health,o.speed,o.direction,o.palette = 0x100,0x20,0x80,7
        o.fireClock,o.waves,o.bullet,o.modifier = 0,2,10,-1
        o.imageClock,o.imageFrame = 1,1
        return true
    end

    function vessel.step(o)
        if o.boss.dying then
            effects.emit(o,0x8b,o.speed,o.direction,0,false)
            return false
        end
        if not o.run.freeze then move(o,o.speed,o.direction) end
        if inside(o,0xa00,0x400,0x8400,0x4000) then o.seen = true
        elseif o.seen then return false end
        o.second.h,o.second.l = o.h,o.l
        if not o.run.freeze and not o.run.stopPathClock then
            if o.waves > 0 then
                o.fireClock = o.fireClock-1
                if o.fireClock < 0 then
                    o.fireClock = 0
                    local step = o.bullet==2 and 0x80 or 0x40
                    for delta = 0,255,step do
                        local angle = band(o.angle+delta,255)
                        if angle >= 0x10 and angle <= 0xf0 then M.shot(o,o.bullet,o.modifier,angle) end
                    end
                    o.angle,o.bullet,o.modifier = band(-o.angle,0xf8),2,-10
                    o.waves = o.twin and 0 or o.waves-1
                end
            end
            advanceImage(o,8)
        end
        o.palette = 7
        if o.impact or o.second.impact then
            o.palette = 31
            o.health = o.health-band((o.damage or 0)+(o.second.damage or 0),0xffff)
            if o.health < 0 then
                effects.emit(o,0x8b,o.speed,o.direction,0,false)
                return false
            end
            for _,part in ipairs({o,o.second}) do
                part.impact,part.damage,part.hp,part.flags = nil,0,0x7fff,band(part.flags,0xa6ff)
            end
        end
        return true
    end

    function vessel.render(o)
        image(o,data.vesselGlow[o.imageFrame],o.h,o.l,0xf600fd00)
        image(o,data.vessels[o.palette][(o.imageFrame-1)%4+1],o.h,o.l,0xf8c0fc00)
    end

    -- 0x18b490 卫星收拢 32 次更新才启用可击破耐久，退场按 0x18b574。
    local satellite = {parts=1}
    function satellite.init(o)
        local row = o.row
        o.h,o.l,o.boss,o.direction,o.shotAngle = row.h,row.l,row.boss,row.direction,row.shotAngle
        o.flags,o.front,o.back,o.right,o.left,o.hp = 0xa600,0x400,0x400,0x300,0x300,0x7fff
        o.speed,o.turn,o.palette = 2,0,13
        o.speedClock,o.fireClock,o.shots = 0,0,8
        return true
    end

    function satellite.step(o)
        if o.boss.dying then return false end
        o.palette = 13
        if o.impact then
            o.impact,o.damage,o.palette = nil,0,31
            if not o.armed then o.hp = 0x7fff end
            if o.hp < 0 then
                effects.emit(o,11,o.speed+8,o.direction,0,false)
                return false
            end
        end
        if o.run.freeze then return true end
        if not o.armed then
            o.turn = o.turn+4
            if o.turn == 0x80 then o.armed,o.hp = true,0x200 end
        end
        if o.armed then
            o.speedClock = o.speedClock-1
            if o.speedClock < 0 then o.speedClock,o.speed = 1,o.speed+1 end
        end
        move(o,o.speed,o.direction)
        if inside(o,0x800,0x600,0x8000,0x4400) then o.seen = true
        elseif o.seen then return false end
        if o.armed and o.shots>0 then
            o.fireClock = o.fireClock-1
            if o.fireClock < 0 then
                o.fireClock,o.shots = 4,o.shots-1
                bullets.emit(o,25,-8,o.direction+o.shotAngle,0,0,true)
            end
        end
        return true
    end

    function satellite.render(o)
        local index = floor(band(o.direction+o.turn,0xf8)/8)+1
        image(o,data.satellites[o.palette][index],o.h,o.l,0xf800fa00)
    end

    local dispenser = {parts=1}
    function dispenser.init(o)
        o.h,o.l,o.boss = o.row.h,o.row.l,o.row.boss
        o.clock,o.flags = 2,0x8000
        return true
    end

    function dispenser.step(o)
        o.clock = o.clock-1
        if o.clock > 0 then
            if not o.run.freeze then move(o,0x30,0x80) end
            return true
        end
        if o.boss.dying then return false end
        local run = o.run
        local offset = program.random(run,program.randomByte)%2==0 and -0x60 or 0x60
        local direction = program.random(run,program.randomByte)
        for ray = 0,15 do
            local angle = direction+ray*0x10
            local muzzle = data.satelliteMuzzles[floor(band(angle+2,0xfc)/4)+1]
            local h,l = program.addPacked(o.h,o.l,muzzle)
            local row = M.queue(o,0x63,h,l)
            row.direction,row.shotAngle = band(angle,255),offset
            M.shot(o,11,0,angle+0x1e)
            M.shot(o,11,0,angle+0x22)
        end
        return false
    end

    function dispenser.render(o)
        image(o,data.satellites[13][1],o.h,o.l,0xf800fa00)
    end

    M.handlers = {[0x18b490]=satellite,[0x18e59c]=vessel,[0x18e812]=dispenser,[0x18e9ea]=ring,[0x18ec74]=orb}
    return M
end
