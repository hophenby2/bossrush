-- 0x1658c0 和 0x1660f4 的车身与底座各占一个判定槽，共用耐久。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local data = program.stage2Carriers
    local large,small = {parts=2},{parts=2}
    local sideH,sideL = -0x180,{0x580,-0x580}
    local sideOffset = {0xfe800580,0xfe80fa80}
    local centerH,centerL = 0xac0,0x40

    local function positionParts(o)
        o.base.h,o.base.l = o.h,o.l
    end

    local function attach(o,kind)
        local base = {}
        for index,part in ipairs({o,base}) do
            part.flags,part.front,part.back,part.right,part.left,part.hp = unpack(kind.parts[index])
        end
        o.base,o.extraParts,o.health = base,{base},kind.health
        o.normalPalette,o.flashMask = unpack(kind.palettes[o.run.stageNumber])
        o.palette,o.trackPalette = o.normalPalette,10
        if not path.attach(o,o.row) then return false end
        positionParts(o)
        return true
    end

    local function hit(o,lowHealth)
        local base = o.base
        if not o.impact and not base.impact then
            if o.hp < lowHealth and not o.run.dual then o.palette,o.trackPalette = 25,25
            else o.palette,o.trackPalette = o.normalPalette,10 end
            return true
        end
        o.health = o.health-band((o.damage or 0)+(base.damage or 0),0xffff)
        if o.health < 0 then return false end
        for _,part in ipairs({o,base}) do
            part.impact,part.damage,part.hp,part.flags = nil,0,0x7fff,band(part.flags,0xa6ff)
        end
        if o.palette == 25 then o.palette,o.trackPalette = o.normalPalette,10 end
        o.palette,o.trackPalette = bxor(o.palette,o.flashMask),bxor(o.trackPalette,0x15)
        return true
    end

    local function advance(o,hOffset,hLimit,lOffset,lLimit)
        if not path.step(o,-o.run.groundScroll) then return false end
        if band(o.h+hOffset,0xffff) < hLimit
            and band(o.l+lOffset+o.run.cameraOffset,0xffff) < lLimit then
            o.seen = true
        elseif o.seen then return false end
        positionParts(o)
        return true
    end

    local function fire(o,kind,speed,angle,offset,offsets)
        local muzzle = offsets[floor(band(angle+2,0xfc)/4)+1]
        local h,l = program.addPacked(0,0,offset+muzzle)
        bullets.emit(o,kind,speed,angle,h,l,true)
    end

    local function turretOffset(aim,offset)
        return data.muzzles[floor(aim/2)+1]+offset
    end

    function large.init(o)
        if not attach(o,data.large) then return false end
        local state = data.large.state
        local run = o.run
        if run.stageNumber == 2 and run.major >= 0x70 then o.health = 0x1c00 end
        local aim = program.angle(o.h,o.l,run.player,0x20)
        o.aims = {aim,aim}
        o.hatch,o.hatchFrame,o.hatchClock,o.hatchGap = 0,0,state[15],state[16]
        o.centerClock,o.centerGap,o.rings,o.ringReload = state[11],state[31],state[13],state[14]
        o.sideClock,o.sideCount,o.sideReload = state[19],state[21],state[22]
        o.trackClock,o.trackGap,o.trackFrame = state[33],state[34],state[36]
        o.lightClock,o.lightGap,o.lightFrame = state[37],state[38],state[40]
        o.aimClock,o.aimGap = state[23],state[24]
        o.ringAngle,o.ringStep = state[41],state[42]
        if program.random(run,program.randomByte) >= 0x80 then o.ringStep = -o.ringStep end
        o.protection = state[10]
        return true
    end

    -- 炮罩从 0x1659de 到 0x165b38 开闭。环射使用独立的八位角，侧炮不等炮罩。
    local function center(o)
        if not o.seen then return end
        if o.hatch == 0 then
            o.centerClock = o.centerClock-1
            if o.centerClock < 0 then o.centerClock,o.hatch = 4,1 end
        elseif o.hatch == 1 then
            o.hatchClock = o.hatchClock-1
            if o.hatchClock >= 0 then return end
            o.hatchClock,o.hatchFrame = o.hatchGap,o.hatchFrame+4
            if o.hatchFrame == 0x28 then o.hatch,o.hatchFrame = 2,0x20 end
        elseif o.hatch == 2 then
            o.centerClock = o.centerClock-1
            if o.centerClock >= 0 then return end
            o.centerClock = o.centerGap
            local player = o.run.player
            if o.h >= 0x3400 and (o.rings ~= o.ringReload or player and player.active) then
                if o.rings == o.ringReload then
                    o.ringAngle = program.angle8(o.h+centerH,o.l+centerL,player,0x80)
                    if program.random(o.run,program.randomByte) >= 0x80 then o.ringStep = -o.ringStep end
                end
                for ray = 0,7 do
                    fire(o,2,-1,o.ringAngle+ray*0x20,0x0ac00040,program.dualCannon.muzzle)
                end
                o.ringAngle = band(o.ringAngle+o.ringStep,255)
            end
            o.rings = o.rings-1
            if o.rings < 0 then o.rings,o.hatch,o.centerClock = o.ringReload,3,4 end
        elseif o.centerClock > 0 then
            o.centerClock = o.centerClock-1
        else
            o.hatchClock = o.hatchClock-1
            if o.hatchClock >= 0 then return end
            o.hatchClock,o.hatchFrame = o.hatchGap,o.hatchFrame-4
            if o.hatchFrame == 0 then o.hatch,o.centerClock = 0,data.large.state[12]-o.run.gunshipMainRank end
        end
    end

    local function sides(o)
        o.aimClock = o.aimClock-1
        if o.aimClock < 0 then
            o.aimClock = o.aimGap
            if o.sideCount == o.sideReload then
                for index,dl in ipairs(sideL) do
                    local prior = o.aims[index]
                    o.aims[index] = program.towards(prior,program.angle(o.h+sideH,o.l+dl,o.run.player,prior))
                end
            end
        end
        if o.h<0x3400 or o.run.freeze or o.run.stopPathClock or o.run.blockEnemyFire then return end
        o.sideClock = o.sideClock-1
        if o.sideClock >= 0 then return end
        o.sideClock,o.sideCount = 6,o.sideCount-1
        for index,aim in ipairs(o.aims) do
            local offset = turretOffset(aim,sideOffset[index])
            for ray = -1,1 do fire(o,13,1,aim*4+ray*0x12,offset,program.gunshipMainShotOffsets) end
        end
        if o.sideCount < 0 then o.sideClock,o.sideCount = 0x60-o.run.lateFireRank,o.sideReload end
    end

    function large.step(o)
        if not advance(o,0x1800,0xa000,0x1400,0x6000) then return false end
        if o.protection >= 0 then
            o.protection,o.damage,o.base.damage = o.protection-1,0,0
        end
        if not hit(o,0x580) then
            effects.emitSequence(o,data.large.destruction)
            return false
        end
        o.trackClock,o.lightClock = o.trackClock-1,o.lightClock-1
        if o.trackClock < 0 then o.trackClock,o.trackFrame = o.trackGap,(o.trackFrame-4)%0x40 end
        if o.lightClock < 0 then o.lightClock,o.lightFrame = o.lightGap,(o.lightFrame-4)%0x20 end
        center(o)
        sides(o)
        return true
    end

    function small.init(o)
        local run = o.run
        if run.stageNumber == 2 and run.major >= 0xce and run.stageFlags[0] then return false end
        if not attach(o,data.small) then return false end
        local state = data.small.state
        o.aim = program.angle(o.h,o.l,run.player,0x20)
        o.sideClock,o.sideCount,o.sideReload = state[17]-run.lateFireRank,state[19],state[20]
        o.aimClock,o.aimGap,o.trackFrame = state[21],state[22],state[30]
        o.modifier,o.bulletKind = state[32],state[34]
        if run.stageNumber == 5 then
            o.sideClock,o.sideCount,o.sideReload,o.modifier = 0x40-run.lateFireRank,5,5,3
        end
        return true
    end

    function small.step(o)
        local run = o.run
        if not advance(o,0xe00,0x8c00,0x1600,0x6400) then return false end
        if not hit(o,0x100) then
            effects.emitSequence(o,data.small.destruction)
            return false
        end
        o.trackFrame = (o.trackFrame-4)%0x40
        if run.freeze or run.stopPathClock or run.blockEnemyFire then return true end
        o.aimClock = o.aimClock-1
        if o.aimClock < 0 then
            o.aimClock = o.aimGap
            if o.sideCount == o.sideReload then
                o.aim = program.towards(o.aim,program.angle(o.h+0x480,o.l-0x40,run.player,o.aim))
            end
        end
        if o.h < 0x3000 then return true end
        o.sideClock = o.sideClock-1
        if o.sideClock >= 0 then return true end
        local offset = turretOffset(o.aim,0x0480ffc0)
        local angle = o.aim*4
        local spread = run.stageNumber == 5 and 8 or 3
        fire(o,o.bulletKind,o.modifier,angle-spread,offset,program.mid1.ringOffsets)
        fire(o,o.bulletKind,o.modifier,angle+spread,offset,program.mid1.ringOffsets)
        fire(o,o.bulletKind,o.modifier+(run.stageNumber==5 and 5 or 4),angle,offset,program.mid1.ringOffsets)
        o.sideClock,o.sideCount = 5,o.sideCount-1
        if o.sideCount < 0 then o.sideClock,o.sideCount = 0x60-run.patrolTrackRank,o.sideReload end
        return true
    end

    local function draw(o,id,offset,flip)
        local h,l = program.addPacked(o.h,o.l,offset)
        art.draw(o.run.art.sprites[id],h,l,0,0,flip)
    end

    function large.render(o)
        if not o.run.art then return end
        local images = data.images[o.palette]
        draw(o,images.largeBody[1],0xe800f500)
        local lightFrame,hatchFrame = floor(o.lightFrame/4)+1,floor(o.hatchFrame/4)+1
        draw(o,images.lightsA[lightFrame],0x0ac00040+0xfe00fe00)
        draw(o,images.lightsB[lightFrame],0x05800040+0xfe00fe00)
        draw(o,images.caps[1],data.hatchOffsetsA[hatchFrame]+0xf800fd00)
        draw(o,images.caps[2],data.hatchOffsetsB[hatchFrame]+0xf800fd00)
        local track = data.largeTracks[o.trackPalette][floor(o.trackFrame/4)+1]
        draw(o,track,0x0980f480+0xf600f600)
        draw(o,track,0x0980f480+0xf600f600+0x1700,true)
        draw(o,images.caps[3],0x09c0fbc0+0xf800fd00)
        draw(o,images.caps[3],0x09c0fbc0+0xf800fd00+0x8c0,true)
        for index,aim in ipairs(o.aims) do
            draw(o,images.sideTurrets[floor(aim/2)+1],sideOffset[index]+0xfa00fc00)
        end
    end

    function small.render(o)
        if not o.run.art then return end
        local images = data.images[o.palette]
        draw(o,images.body[1],0xf200f800)
        local track = data.smallTracks[o.trackPalette][floor(o.trackFrame/4)+1]
        draw(o,track,0x0a80fac0+0xfa00fb00)
        local h = program.addPacked(o.h,o.l,0x0a80fac0+0xfa00fb00)
        art.draw(o.run.art.sprites[track],h,o.l+0x40,0,0,true)
        draw(o,images.turrets[floor(o.aim/2)+1],0x0480ffc0+0xfa00fc00)
    end

    return large,small
end
