-- 五面装甲载具。履带跟随路径，舱口和外炮分别持有发射状态。
return function(program, path, bullets, effects, remove, score)
    local band = require('bit').band
    local data = program.heavyHatch
    local s16, word, pack, unpackPosition = program.s16, program.word, program.pack, program.unpack
    local gunBase = {[0x5e]=0x09800500, [0x5f]=0x08800380, [0x0e]=0x0d800000}
    local trackOffset = {[0x5e]=0xf100ff80+0xfe00f700, [0x5f]=0xf4c00000+0xfc00f100,
        [0x0e]=0xfa00f800+0xf800fd00}
    local bodyOffset = {[0x5e]=0xf200f400, [0x5f]=0xf200f100, [0x0e]=0xf000f400}
    local M = {}

    local function tick(s, index)
        local timer = s[index]
        s[index] = (timer-1)%256
        return timer == 0
    end

    function M.init(o)
        local s,run = o.state,o.run
        o.colorFrame = 1
        if o.kind == 0x5e and run.stageNumber == 5 then run.patrol42Block = true end
        if o.kind == 0x5f and run.stageNumber == 5 and run.minor == 0x48 then
            o.hp, s[0x38], s[0x39], s[0x3a], s[0x3b] = 0x4c00,0x0c,0xaa,0x4c,0
        end
        if o.kind == 0x0e and program.random(run,program.randomParity) >= 0x80 then
            s[0x3f] = (-s[0x3f])%256
        end
    end

    local function retire(o)
        if o.kind ~= 0x0e and o.run.stageNumber == 5 then o.run.patrol42Block = true end
        remove(o)
    end

    local function aimHatch(o, port)
        local run = o.run
        if not run.pilotH then return 0x80 end
        return program.aimByte(s16(o.h+port[1]),s16(o.l+port[2]),run.pilotH,run.pilotL,0x80,true)
    end

    -- 0xe583a / 0xe5fa4。中间射线沿用前一条主射线的弹口。
    local function fan(o, definition)
        local s,run = o.state,o.run
        local port = definition.ports[word(s,0x2c)/4+1]
        local wide = run.minor == 0x48
        local rays,spacing,layers = wide and 9 or 5,wide and 10 or 16,wide and 4 or 3
        local angle = aimHatch(o,port)-(wide and 40 or 32)
        local base = pack(port[1],port[2])+0xfd00fd40
        s[0x3e] = angle%256
        for index=1,rays do
            local h,l = unpackPosition(base+data.radial[band(angle+2,0xfc)/4+1])
            for layer=0,layers-1 do
                bullets.emitAngle(run,3,-1+6*layer,angle,o.h,o.l,h,l)
            end
            if index < rays then
                for layer=0,layers-1 do
                    bullets.emitAngle(run,0x23,8+6*layer,angle+spacing/2,o.h,o.l,h,l)
                end
            end
            angle = angle+spacing
        end
        s[0x28] = 3
    end

    -- 0xe664c。六次齐射共用首发瞄准，发完后才反转下一轮角速度。
    local function rotatingFan(o, definition)
        local s = o.state
        local port = definition.ports[word(s,0x36)/4+1]
        local wave = word(s,0x32)
        if wave == 0 then s[0x3e] = (aimHatch(o,port)-0x2c)%256 end
        for ray=0,4 do
            bullets.emitAngle(o.run,3,5+wave,s[0x3e]+0x16*ray,o.h,o.l,port[1],port[2])
        end
        s[0x3e],s[0x37],s[0x33] = (s[0x3e]+s[0x3f])%256,(s[0x37]+4)%16,wave+1
        if s[0x33] == 6 then s[0x33],s[0x3f],s[0x28] = 0,(-s[0x3f])%256,3 end
    end

    local function hatch(o, definition)
        local s = o.state
        if s[0x28] == 0 and not o.run.bulletHold and o.h >= 0x2400 and tick(s,0x2e) then
            s[0x2e],s[0x28] = s[0x2f],1
        end
        if s[0x28] == 1 and tick(s,0x2a) then
            s[0x2a],s[0x2d] = s[0x2b],s[0x2d]+4
            if s[0x2d] == 0x14 then s[0x28] = 2 end
        end
        if s[0x28] == 2 and tick(s,0x30) then
            s[0x30] = s[0x31]
            if o.kind == 0x0e then rotatingFan(o,definition) else fan(o,definition) end
        end
        if s[0x28] == 3 and tick(s,0x2a) then
            s[0x2a],s[0x2d] = s[0x2b],s[0x2d]+4
            if s[0x2d] == 0x28 then s[0x2d],s[0x28] = 0,0 end
        end
    end

    local function trackGun(o, position)
        local run,s = o.run,o.state
        if not run.pilotH then return end
        local h,l = unpackPosition(position)
        local target = program.angle(s16(o.h+h),s16(o.l+l),run.pilotH,run.pilotL,s[0x26])
        s[0x26] = program.turnToward(s[0x26],target)
    end

    local function gun(o, definition)
        local s,run = o.state,o.run
        local position = gunBase[o.kind]
        local paired = o.kind == 0x0e
        if (paired and s[0x3d]==0) or (not paired and run.frame%2==1) then trackGun(o,position) end
        if run.bulletHold or o.h < 0x2400 or not tick(s,0x34) then return end
        s[0x34] = s[0x3c]
        local muzzle = definition.muzzle[band(s[0x26],0x3e)/2+1]
        local angle,burst = s[0x26]*4,s[0x3d]
        local h,l = unpackPosition(pack(o.h,o.l)+position)
        if paired then
            for ray=0,2 do
                bullets.emitLongPair(run,0x18,2,angle-5*burst-16*ray,h,l,muzzle[1],muzzle[2])
            end
            for ray=0,2 do
                bullets.emitLongPair(run,0x18,2,angle+5*burst+16*ray,h,l,muzzle[3],muzzle[4])
            end
        else
            local speed = 2+2*burst
            local loop = run.route.loop == 1
            bullets.emitAngle(run,2,speed+(loop and 2 or 0),angle,h,l,muzzle[1],muzzle[2])
            if loop then
                bullets.emitAngle(run,2,speed,angle-8,h,l,muzzle[1],muzzle[2])
                bullets.emitAngle(run,2,speed,angle+8,h,l,muzzle[1],muzzle[2])
            end
        end
        s[0x3d] = burst+1
        if s[0x3d] == (paired and 12 or 8) then s[0x3d],s[0x34] = 0,s[0x35] end
    end

    function M.step(o)
        local run,s = o.run,o.state
        local definition = data[o.kind]
        if band(o.flags,0x5800) ~= 0 then
            o.flags, o.colorFrame = band(o.flags,0xa7ff),o.colorFrame == 2 and 1 or 2
            if o.hp < 0 then
                score.kill(o,0xd2)
                effects.spawn(run,o.h,o.l,definition.death,true,true)
                if run.onEnemyDeath then run.onEnemyDeath(o) end
                retire(o)
                return
            end
        else
            o.colorFrame = o.hp <= word(s,0x38) and band(run.frame,0x0e)==0 and 3 or 1
        end
        effects.attachSmoke(o,definition.smoke)
        if run.freeze then return end
        if not path.step(o) then remove(o); return end
        local margin = o.kind == 0x0e and 0x1400 or 0x1800
        local inside = band(o.h+0x1200,0xffff)<0x9400
            and band(o.l+margin+run.cameraOffset,0xffff)<0x3800+2*margin
        if o.entered and not inside then retire(o); return end
        o.entered = o.entered or inside
        hatch(o,definition)
        gun(o,definition)
        if o.direction < 0x40 and o.speed ~= 0 and tick(s,0x1a) then
            s[0x1a] = o.speed <=4 and 5 or o.speed <=8 and 1 or 0
            s[0x1d] = (s[0x1d]+4)%16
        end
    end

    function M.render(o, draw)
        local kind,s,color = o.kind,o.state,o.colorFrame
        local definition = data[kind]
        local track = word(s,0x1c)/4+1
        local pose = pack(word(s,0x1e),word(s,0x20))
        draw(o,definition.tracks[color][track],unpackPosition(trackOffset[kind]))
        if definition.rightTrack then
            draw(o,definition.rightTrack[color][track],unpackPosition(0xfa000680+0xf800fd00))
        end
        draw(o,definition.body[color],unpackPosition(bodyOffset[kind]+pose))
        if definition.hatch then
            local index = word(s,0x2c)/4+1
            local port,cap = definition.ports[index],definition.capOffsets[index]
            draw(o,definition.hatch[color],unpackPosition(0xee00fb00+pose+pack(port[1],port[2])))
            draw(o,definition.cap[color],unpackPosition(0xf800fd00+pose+pack(cap[1],cap[2])))
        end
        local gunIndex = band(s[0x26],0x3e)/2+1
        local gunPose = pack(word(s,0x22),word(s,0x24))
        draw(o,definition.gun[color][gunIndex],unpackPosition(gunBase[kind]+0xfa00fb00+gunPose))
    end

    return M
end
