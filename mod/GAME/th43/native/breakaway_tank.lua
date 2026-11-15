-- 大型舱炮坦克。受损先拆炮，车体换用环射指令并继续走关卡路径。
return function(program, path, bullets, effects, remove, score)
    local band = require('bit').band
    local s16, word, pack, unpackPosition = program.s16, program.word, program.pack, program.unpack
    local data = program.breakawayTank
    local turretBase = {[0x2c]={0xc00,0},[0x2d]={0xb80,0x400},[0x2e]={0xaff,-0x880}}
    local hullBase = {[0x2c]=0xf000ed00,[0x2d]=0xf000ee00,[0x2e]=0xf000ee00}
    local trackBase = {[0x2c]=0xf6000000+0xfe00f700,[0x2d]=0xf9fffe00+0xf800f100,
        [0x2e]=0xf9ffff00+0xf800f100}
    local acceleration = {2,2,1,0x7f}
    local fireWindow = {{0x3400,0x3800},{0x3200,0x3c00},{0x3000,0x3e00},{0x2e00,0x4000},{0x2c00,0x4400}}
    local M = {}

    local function tick(s, index)
        local clock = s[index]
        s[index] = (clock-1)%256
        return clock == 0
    end

    function M.init(o)
        local run,s = o.run,o.state
        o.colorFrame, o.hatchFrame, o.trackFrame, o.wave, o.pair = 1,0,0,0,1
        o.flashAt,o.breakAt = word(s,0x38),word(s,0x3a)
        if run.stageNumber == 3 then
            o.hp,o.flashAt,o.breakAt = 0x3200,0x4aa,0x1c00
        elseif run.stageNumber == 5 then
            o.hp,o.flashAt,o.breakAt = 0x5000,0x800,0x3000
        end
    end

    local function damage(o, definition)
        local run = o.run
        if band(o.flags,0x5800) == 0 then
            o.colorFrame = o.hp <= o.flashAt and band(run.frame,0x0e)==0 and 3 or 1
            return true
        end
        o.flags,o.colorFrame = band(o.flags,0xa7ff),o.colorFrame == 2 and 1 or 2
        if not o.weakened then
            if o.hp < o.breakAt then
                score.kill(o,0x82,0x600)
                o.weakened = true
                effects.spawn(run,o.h,o.l,definition.breakup,true,true)
                if run.onBreakPart then run.onBreakPart(o) end
            end
        elseif o.hp < 0 then
            score.kill(o,0x37a)
            effects.spawn(run,o.h,o.l,definition.death,true,true)
            if run.onEnemyDeath then run.onEnemyDeath(o) end
            remove(o)
            return false
        end
        return true
    end

    local function aim(o, offset, fallback)
        local run = o.run
        if not run.pilotH then return fallback end
        return program.angle(s16(o.h+offset[1]),s16(o.l+offset[2]),run.pilotH,run.pilotL,fallback)
    end

    -- 0xd9e8a。每轮用一个左右炮口对，两边分别瞄准并发射自带加速计时的 0x0d 弹。
    local function hatchVolley(o, definition)
        local run = o.run
        for i=o.pair,o.pair+1 do
            local p = definition.ports[i]
            local h,l = s16(o.h+p[1]),s16(o.l+p[2])
            local a = aim(o,p,0x20)
            bullets.emitWidePair(run,0x0d,-20,a*4,h,l,nil,nil,acceleration)
            if run.stageNumber == 5 then
                bullets.emitFasterInLoop(run,0x0d,-20,(a+6)*4,h,l,acceleration)
                bullets.emitFasterInLoop(run,0x0d,-20,a*4,h,l,acceleration)
            end
        end
        o.pair,o.wave = (o.pair+1)%6+1,o.wave+1
    end

    local function hatch(o, definition, inRange)
        local s = o.state
        if s[0x28] == 0 and inRange and not o.run.bulletHold and tick(s,0x2e) then s[0x2e],s[0x28]=s[0x2f],1 end
        if s[0x28] == 1 and tick(s,0x2a) then
            s[0x2a],o.hatchFrame = s[0x2b],o.hatchFrame+1
            if o.hatchFrame == 7 then s[0x28] = 2 end
        end
        if s[0x28] == 2 then
            if inRange and tick(s,0x30) then
                s[0x30] = s[0x31]
                hatchVolley(o,definition)
            end
            if not inRange or o.wave == 10 then o.wave,s[0x28] = 0,3 end
        end
        if s[0x28] == 3 and tick(s,0x2a) then
            s[0x2a],o.hatchFrame = s[0x2b],o.hatchFrame-1
            if o.hatchFrame == 0 then s[0x28] = 0 end
        end
    end

    local function turret(o, inRange)
        local run,s,base = o.run,o.state,turretBase[o.kind]
        s[0x26] = program.turnToward(s[0x26],aim(o,base,s[0x26]))
        if not inRange or run.bulletHold or not tick(s,0x34) then return end
        s[0x34] = s[0x35]
        local p = data.muzzle[band(s[0x26],0x3e)/2+1]
        local h,l = program.add(o.h,o.l,base[1],base[2])
        h,l = s16(h+p[1]),s16(l+p[2])
        local angle = s[0x26]*4
        for _,direction in ipairs({1,-1}) do
            for i=0,2 do bullets.emitLongPair(run,0xb,0,angle+4*direction*i,h,l) end
            for _,offset in ipairs({6,7,11,12}) do
                bullets.emitFasterInLoop(run,0xb,0,angle+4*direction*offset,h,l)
            end
        end
    end

    local function ring(o, inRange)
        local run,s,base = o.run,o.state,turretBase[o.kind]
        local fifth = run.stageNumber == 5
        if not inRange or run.bulletHold or run.frame%(fifth and 16 or 32) ~= 0 then return end
        local h,l = program.add(o.h,o.l,base[1],base[2])
        for i=0,15 do
            local a = band(s[0x26]+4*i,0x3f)
            local p = data.ring[a+1]
            bullets.emitFasterInLoop(run,2,0,a*4,s16(h+p[1]),s16(l+p[2]))
        end
        if fifth then
            for i=0,15 do
                local a = band(s[0x26]+2+4*i,0x3f)
                local p = data.outerRing[a+1]
                bullets.emitFasterInLoop(run,2,2,a*4,s16(h+p[1]),s16(l+p[2]))
            end
            s[0x26] = band(s[0x26]+1,0x3f)
        end
    end

    function M.step(o)
        local run,s,definition = o.run,o.state,data[o.kind]
        if not damage(o,definition) then return end
        effects.attachSmoke(o,definition.smoke)
        if run.freeze then return end
        if not path.step(o) then remove(o); return end
        local inside = band(o.h+0x1000,0xffff)<0x9000
            and band(o.l+0x1a00+run.cameraOffset,0xffff)<0x6c00
        if o.entered and not inside then remove(o); return end
        o.entered = o.entered or inside
        local limits = fireWindow[run.stageNumber]
        local inRange = band(o.h-limits[1],0xffff)<limits[2]
        if o.weakened then
            ring(o,inRange)
        else
            hatch(o,definition,inRange)
            turret(o,inRange)
        end
        local moving = o.direction < 0x40 and o.speed ~= 0
        if run.frame%3 == 0 then
            o.hullBounce,o.gunBounce = 0,0
            if moving then
                local a = data.jitter[band(program.random(run,program.randomParity),15)+1]
                local b = data.jitter[band(program.random(run,program.randomParity),15)+1]
                o.hullBounce = -a-math.floor(a/2)
                o.gunBounce = o.hullBounce+b
            end
        end
        if moving and tick(s,0x1a) then
            s[0x1a] = o.speed <= 4 and 5 or o.speed <= 8 and 1 or 0
            o.trackFrame = (o.trackFrame+1)%4
        end
    end

    function M.render(o, draw)
        local art = data[o.kind].art[o.run.stageNumber]
        local color,base = o.colorFrame,turretBase[o.kind]
        local pos = pack(o.h,o.l)
        local function sprite(id, offset, bounce)
            local h,l = unpackPosition(pos+offset)
            draw(o,id,s16(h-o.h+(bounce or 0)),s16(l-o.l))
        end
        sprite(art.hull[color][o.weakened and 9 or o.hatchFrame+1],hullBase[o.kind],o.hullBounce)
        sprite(art.tracks[color][o.trackFrame+1],trackBase[o.kind])
        if not o.weakened then
            sprite(art.gun[color][band(o.state[0x26],0x3e)/2+1],pack(base[1],base[2])+0xf800f700,o.gunBounce)
        end
    end

    return M
end
