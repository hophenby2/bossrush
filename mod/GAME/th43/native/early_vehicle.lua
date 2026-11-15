-- 一、二面装甲载具。伤害先按各自的装甲和碰撞框结算，再推进炮位和路径。
return function(program, path, bullets, effects, remove, score)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local floor, min, max = math.floor, math.min, math.max
    local s16, word, add = program.s16, program.word, program.add
    local data = program.earlyVehicle
    local air = data[0x84]
    local tank = data[0x44]
    local groundPoints = {[0x44]=0x172,[0x45]=0x8c,[0x4a]=0x64,[0x4b]=0x64,[0x55]=0xd2,[0x56]=0xd2}
    local rotorScoreOffsets = {{-1,-0xb40},{-0x3c0,-0x680},{0,0xb00},{-0x3c0,0x640}}
    local M = {}

    local function tick(s, index)
        local timer = s[index]
        s[index] = (timer-1)%256
        return timer == 0
    end

    local function aim(o, h, l, fallback)
        local run = o.run
        if run.pilotH then return program.angle(h,l,run.pilotH,run.pilotL,fallback) end
        return fallback
    end

    local function place(o)
        for _, p in ipairs(o.attachments) do
            p.h, p.l = o.h, o.l
            p.x, p.y = program.world(p.h,p.l)
        end
    end

    function M.init(o)
        local s = o.state
        o.colorFrame = 1
        if o.kind == 0x84 then
            o.front,o.back,o.right,o.left = s16(o.front),s16(o.back),s16(o.right),s16(o.left)
            o.a, o.b = (o.right+o.left)/128, (o.front+o.back)/128
            local early = o.run.major >= 0x200
            o.armor, o.breakAt = early and 0x50 or 0xa0, word(s,0x38)
            o.hp = early and 0xe00 or o.hp
            for _, p in ipairs(o.attachments) do
                p.front,p.back,p.right,p.left = s16(p.front),s16(p.back),s16(p.right),s16(p.left)
                p.hp = o.hp
            end
            place(o)
            o.rotor, o.headings, o.activeMount = word(s,0x30)/4, {}, 0
            local cycle = air.cycle[program.random(o.run,air.order)+1]
            o.gunIndex, o.gunStep = cycle[1]/8+1,cycle[2]/8
            for _, p in ipairs(air.mounts) do
                if not o.headings[p[4]] then
                    o.headings[p[4]] = aim(o,s16(o.h+p[2]),s16(o.l+p[3]),o.direction)
                end
            end
            local rank = program.rank(o.run)
            local adjust = floor(rank/4)-floor(rank/8)
            o.firingSides = word(s,0x18) ~= 0
            s[0x1e], s[0x22] = band(s[0x1e]-adjust,0xff),band(s[0x22]-adjust+8,0xff)
        elseif o.kind == 0x44 then
            o.trackFrame, o.rearFan, o.frontFan = 0, 1, 1
        elseif o.kind == 0x48 then
            o.signal = o.part[0x1e]
            o.run.turret48Flags = o.run.turret48Flags or {}
            o.run.turret48Flags[o.signal] = false
            s[0x1a] = program.random(o.run,data[0x48].initialHeading)
            s[0x22] = s[0x1a]
        elseif o.kind == 0x46 or o.kind == 0x47 then
            o.boxes = {o,unpack(o.attachments)}
            for _,part in ipairs(o.boxes) do
                part.front,part.back = s16(part.front),s16(part.back)
                part.right,part.left = s16(part.right),s16(part.left)
                part.a,part.b = (part.right+part.left)/128,(part.front+part.back)/128
            end
            o.durability = word(s,0x28)*65536+word(s,0x2a)
            o.panelHeight = {0,0,0}
            o.panelDelay = {word(s,0x20),word(s,0x22),word(s,0x24)}
            o.breakDelay = 0
        elseif o.kind == 0x55 or o.kind == 0x56 then
            o.trackFrame, o.hatchFrame, o.hatchMuzzle, o.waves = 0,0,1,0
            if o.run.major >= 0x130 then o.hp, o.flashAt = 0xd00,0x22a
            else o.flashAt = word(s,0x38) end
        end
    end

    local function visible(o, dh, hMax, dl, lMax)
        local inside = band(o.h+dh,0xffff)<hMax and band(o.l+dl+o.run.cameraOffset,0xffff)<lMax
        if o.entered and not inside then remove(o); return false end
        o.entered = o.entered or inside
        return true
    end

    local function retire(o, commands, scrolls)
        effects.spawn(o.run,o.h,o.l,commands,scrolls,true)
        if o.run.onEnemyDeath then o.run.onEnemyDeath(o) end
        remove(o)
    end

    local function aircraftDamage(o)
        local run, s = o.run, o.state
        if o.armor >= 0 then
            o.armor = o.armor-(run.suppressShots and 2 or 1)
            o.hp = o.armor < 0 and 0x1500 or 0x7fff
            for _, p in ipairs(o.attachments) do p.hp = o.hp end
        end
        local flags, hp = o.flags, o.hp
        for _, p in ipairs(o.attachments) do flags, hp = bor(flags,p.flags),min(hp,p.hp) end
        if band(flags,0x5800) == 0 then
            o.colorFrame = o.hp < 0x300 and band(run.frame,0x0e)==0 and 3 or 1
            return false
        end
        o.colorFrame = o.colorFrame == 2 and 1 or 2
        o.flags, o.hp = band(o.flags,0xa7ff),hp
        for _, p in ipairs(o.attachments) do p.flags, p.hp = band(p.flags,0xa7ff),hp end
        local late = run.major >= 0x200
        local hit = score.source(o,o.attachments)
        if hp < 0 then
            score.kill(hit,0xe6,late and -0x600 or 0,nil,o)
            retire(o,air.death,false)
            return true
        end
        if hp < o.breakAt and not o.weakened then
            for _,pos in ipairs(rotorScoreOffsets) do
                score.kill(hit,0x6e,pos[1]-(late and 0xf40 or 0),pos[2],o)
            end
            o.weakened, o.firingSides, s[0x1e] = true,false,0x30
            -- 0xeb5a8 在一面后段只分配四个炮位爆炸，机体火光由后续指令控制。
            local commands = air.breakup
            if run.major >= 0x200 then commands = {unpack(commands,1,4)} end
            effects.spawn(run,o.h,o.l,commands,false,true)
            if run.onBreakPart then run.onBreakPart(o) end
        end
        return false
    end

    local function fan(o)
        local run, s = o.run, o.state
        if o.firingSides or o.h < 0x1000 or not tick(s,0x1e) then return end
        s[0x1e] = s[0x2c]
        if run.pilotH then
            local angle = program.aimByte(s16(o.h-0x200),o.l,run.pilotH,run.pilotL,0x80,true)-0x30
            local count, spacing = o.weakened and 9 or 7, o.weakened and 12 or 16
            for i=0,count-1 do
                local a = angle+i*spacing
                local h,l = program.unpack(air.radial[band(a+2,0xfc)/4+1] + 0xfe000000)
                bullets.emitSpread(run,7,1,a,o.h,o.l,h,l)
            end
        end
        if tick(s,0x20) then
            s[0x20] = s[0x21]
            s[0x1e] = (o.weakened and 0x40 or 0x20)-floor(program.rank(run)/16)
            o.firingSides = not o.weakened
        end
    end

    local function trackGuns(o)
        local run,s = o.run,o.state
        if not tick(s,0x28) then return end
        s[0x28] = s[0x29]
        if not run.pilotH then return end
        local first = band(o.flags,0x40)==0 and 1 or 3
        o.flags = bxor(o.flags,0x40)
        local i1, i2 = first==1 and 1 or 4, first==1 and 2 or 3
        for _, i in ipairs({i1,i2}) do
            local p = air.mounts[i]
            local gun = p[4]
            if o.activeMount ~= gun then
                local angle = aim(o,s16(o.h+p[2]),s16(o.l+p[3]),o.headings[gun])
                o.headings[gun] = program.turnToward(o.headings[gun],angle)
            end
        end
    end

    local function sides(o)
        local run,s = o.run,o.state
        if not o.firingSides or o.h < 0x1000 or not tick(s,0x22) then return end
        s[0x22] = s[0x2d]
        local mount = air.mounts[o.gunIndex]
        local angle = o.headings[mount[4]]
        local nozzle = air.nozzle[band(angle,0x3e)/2+1]
        local h,l = add(mount[2],mount[3],nozzle[1],nozzle[2])
        o.activeMount = mount[4]
        bullets.emitFasterInLoop(run,0xb,5,angle*4,s16(o.h+h),s16(o.l+l))
        if tick(s,0x24) then
            local rank = program.rank(run)
            local _,_,delay = program.groundRank(run)
            s[0x24],s[0x22],o.activeMount = s[0x25],4-floor(rank/64),0
            o.gunIndex = (o.gunIndex + o.gunStep - 1)%#air.mounts+1
            if tick(s,0x26) then
                s[0x26],s[0x22],o.firingSides = s[0x27],0x30-delay,false
            end
        end
    end

    local function aircraft(o)
        local run,s = o.run,o.state
        if not path.step(o) then remove(o); return end
        if not visible(o,0x1600,0x9c00,0x1800,0x6800) then return end
        place(o)
        if aircraftDamage(o) then return end
        effects.attachSmoke(o,air.smoke)
        o.rotor = (o.rotor-1)%4
        if run.freeze or run.bulletHold then return end
        fan(o)
        if o.weakened then
            if s[0x35] ~= 0 then s[0x35] = s[0x35]-1 end
        else
            trackGuns(o)
            sides(o)
        end
    end

    local function armVolley(o, angle, count, speed, h, spacing)
        local run = o.run
        local offset = spacing == 2 and count-1 or floor((count-1)/2)
        local split = run.route.loop
        for i=0,count-1 do
            local a = (angle-offset+i*spacing)*4
            bullets.emitAngle(run,0xc,speed,a-split,h,o.l)
            if split ~= 0 then bullets.emitAngle(run,0xc,speed,a+split,h,o.l) end
        end
    end

    local function front(o)
        local s = o.state
        if s[0x26] == 0 then
            if not o.run.pilotH then return end
            s[0x20] = program.turnToward(s[0x20],aim(o,s16(o.h+0xb00),o.l,s[0x20]))
            if not tick(s,0x22) then return end
            s[0x22],s[0x26],o.frontFan = s[0x23],s[0x27],1
            if s[0x27] ~= 6 then s[0x27] = s[0x27]+1 end
        end
        if not tick(s,0x24) then return end
        s[0x24],s[0x26] = s[0x25],s[0x26]-1
        armVolley(o,s[0x20],o.frontFan,6,s16(o.h+0xb00),2)
        o.frontFan = o.frontFan+2
        if s[0x26] == 0 then s[0x1e] = 1 end
    end

    local function rear(o)
        local s = o.state
        if s[0x2c] == 0 then
            if not o.run.pilotH then return end
            s[0x21] = program.turnToward(s[0x21],aim(o,s16(o.h-0x180),o.l,s[0x21]))
            if not tick(s,0x28) then return end
            s[0x28],s[0x2c],o.rearFan = s[0x29],s[0x2d],1
            if s[0x2d] ~= 4 then s[0x2d] = s[0x2d]+1 end
        end
        if not tick(s,0x2a) then return end
        s[0x2a],s[0x2c] = s[0x2b],s[0x2c]-1
        armVolley(o,s[0x21],o.rearFan,word(s,0x34),s16(o.h-0x180),1)
        o.rearFan = o.rearFan+2
        if s[0x2c] == 0 then s[0x1e] = 0 end
    end

    local staticDeath = {
        [0x4a]={{0,0x88,0,-0x300,0,0,0}},
        [0x4b]={{6,0x89,0,0,0,0,0},{3,0x85,0,-0xc00,0,0,0},{0,0x84,0,-0x600,0,0,0}},
    }

    -- 0xe3528 的舱口四阶段和 0xe3658 的外炮计时可以同时推进。
    local function hatchWeapons(o, inRange)
        local run,s = o.run,o.state
        local hatchTank = data[o.kind]
        if s[0x28] == 0 and not run.bulletHold and o.h >= 0x1000 and tick(s,0x2e) then
            s[0x2e],s[0x28] = s[0x2f],1
        end
        if s[0x28] == 1 and tick(s,0x2a) then
            s[0x2a],o.hatchFrame = s[0x2b],o.hatchFrame+1
            if o.hatchFrame == 7 then s[0x28] = 2 end
        end
        if s[0x28] == 2 then
            if inRange and tick(s,0x30) then
                s[0x30] = s[0x31]
                local port = hatchTank.hatchMuzzle[o.hatchMuzzle]
                local h,l = s16(o.h+port[1]),s16(o.l+port[2])
                if o.waves == 0 then
                    o.fanAngle = (run.pilotH and program.aimByte(h,l,run.pilotH,run.pilotL,0x80,true) or 0x80)-0x30
                end
                for i=0,4 do
                    bullets.emitShortPair(run,2,0,(o.fanAngle+0x18*i)/4,h,l)
                end
                o.hatchMuzzle,o.waves = o.hatchMuzzle%4+1,o.waves+1
            end
            if not inRange or o.waves == 4 then o.waves,s[0x28] = 0,3 end
        end
        if s[0x28] == 3 and tick(s,0x2a) then
            s[0x2a],o.hatchFrame = s[0x2b],o.hatchFrame-1
            if o.hatchFrame == 0 then s[0x28] = 0 end
        end
        local gunH,gunL = 0x5bf,-0x300
        if o.kind == 0x55 then gunH,gunL = 0x600,0x300 end
        local h,l = add(o.h,o.l,gunH,gunL)
        s[0x26] = program.turnToward(s[0x26],aim(o,s16(o.h+gunH),s16(o.l+gunL),s[0x26]))
        if not run.bulletHold and inRange and tick(s,0x34) then
            s[0x34] = s[0x35]
            local muzzle = hatchTank.muzzle[band(s[0x26],0x3e)/2+1]
            h,l = s16(h+muzzle[1]),s16(l+muzzle[2])
            bullets.emitLongPair(run,0xc,1,s[0x26]*4,h,l)
            bullets.emitLongPair(run,0xc,4,s[0x26]*4,h,l)
        end
    end

    -- 0xe6c12。连射期间锁住朝向，两个炮口各自使用原程序的角度偏移表。
    local function twinGuns(o, inRange)
        local run,s = o.run,o.state
        if s[0x20] == 0 then
            if run.pilotH then
                local desired = program.aimByte(o.h,o.l,run.pilotH,run.pilotL,s[0x1a],true)
                local turn = (desired-s[0x1a])%256
                if turn ~= 0 then s[0x1a] = (s[0x1a]+(turn < 128 and 1 or -1))%256 end
            end
            if not tick(s,0x1c) then return end
            s[0x1c],s[0x20] = s[0x1d],s[0x21]
        end
        if not tick(s,0x1e) then return end
        s[0x1e],s[0x20] = s[0x1f],s[0x20]-1
        if run.bulletHold or not inRange then return end
        local angle = s[0x1a]
        local index = floor(angle/8)+1
        local left,right = data[0x45].leftMuzzle[index],data[0x45].rightMuzzle[index]
        bullets.emitSpread(run,9,5,angle,o.h,o.l,left[1],left[2])
        bullets.emitSpread(run,9,5,angle,o.h,o.l,right[1],right[2])
    end

    -- 0xe7a8e。炮塔转向结束才换用另一套炮口，击毁信号等残骸计时结束再写入。
    local function rotatingTurret(o)
        local run,s = o.run,o.state
        if s[0x25] ~= 0 then
            if not path.step(o) then remove(o); return end
            s[0x25] = s[0x25]-1
            if s[0x25] == 0 then
                run.turret48Flags[o.signal] = true
                remove(o)
            end
            return
        end
        if band(o.flags,0x5800) ~= 0 then
            o.flags,o.colorFrame = band(o.flags,0xa7ff),o.colorFrame == 2 and 1 or 2
            if o.hp < 0 then
                score.kill(o,0x2b2)
                effects.spawn(run,o.h,o.l,data[0x48].death,true,true)
                s[0x25],o.flags,o.colorFrame = 0x20,0x8080,3
                if run.onEnemyDeath then run.onEnemyDeath(o) end
                return
            end
        else
            o.colorFrame = o.hp < 0x300 and band(run.frame,0x0e)==0 and 3 or 1
        end
        if run.freeze then return end
        if not path.step(o) then remove(o); return end
        if not visible(o,0x800,0x8000,0x1c00,0x7000) then return end
        if s[0x1b] == 0 and tick(s,0x26) then
            s[0x26],s[0x1b],s[0x1c],s[0x1d] = s[0x27],1,0x7f,0x7f
            s[0x22] = aim(o,o.h,o.l,band(s[0x22]+0x10,0x3f))
        end
        if s[0x1b] == 1 then
            s[0x1a] = program.turnToward(s[0x1a],s[0x22])
            if s[0x1a] == s[0x22] then
                s[0x1b],s[0x1c],s[0x1d],s[0x24] = 0,4,4,1-s[0x24]
            end
        end
        if run.bulletHold or o.h < 0x1c00 or not tick(s,0x1c) then return end
        s[0x1c],s[0x29] = s[0x1d],4-s[0x29]
        local definition = data[0x48]
        local ports = s[0x24]==0 and definition.leftMuzzle or definition.rightMuzzle
        local port = ports[band(s[0x1a],0x3e)/2+1]
        local angle,spread = s[0x1a]*4,run.route.loop
        bullets.emitAngle(run,0xb,7,angle-spread,o.h,o.l,port[1],port[2])
        if spread == 1 then bullets.emitAngle(run,0xb,7,angle+1,o.h,o.l,port[1],port[2]) end
    end

    -- 0xe6e50 / 0xe746e。在原位的四块碰撞盒中取同帧最大伤害，0x46 完全打开才扣主耐久。
    local function doors(o)
        local run,s = o.run,o.state
        place(o)
        if o.breakDelay > 0 then
            o.breakDelay = o.breakDelay-1
            if o.breakDelay == 0 then remove(o); return end
        else
            local flags = 0
            for _,part in ipairs(o.boxes) do flags = bor(flags,part.flags) end
            if band(flags,0x5800) ~= 0 then
                local loss = 0
                for _,part in ipairs(o.boxes) do
                    loss = max(loss,band(0x7fff-part.hp,0xffff))
                    part.flags,part.hp = band(part.flags,0xa7ff),0x7fff
                end
                o.colorFrame = o.colorFrame == 2 and 1 or 2
                if o.kind == 0x47 or s[0x26] ~= 0 then o.durability = o.durability-loss end
                if o.durability < 0 then
                    score.kill(score.source(o,o.attachments),0x17c,nil,nil,o)
                    local dl = o.kind == 0x46 and 0x600 or -0x600
                    effects.spawn(run,s16(o.h-0x800),s16(o.l+dl),data[o.kind].death,true,true)
                    o.breakDelay,o.colorFrame = 0x30,1
                    if run.onEnemyDeath then run.onEnemyDeath(o) end
                end
            else
                o.colorFrame = o.durability < 0x155 and band(run.frame,0x0e)==0 and 3 or 1
            end
        end
        if not path.step(o) then remove(o); return end
        if o.h <= -0x1a00 and o.entered then remove(o); return end
        o.entered = o.entered or o.h > -0x1a00
        if s[0x26] ~= 0 then return end
        for i=1,3 do
            local delay = max(0,o.panelDelay[i]-1)
            o.panelDelay[i] = delay
            if delay == 0 then o.panelHeight[i] = min(0xa00,o.panelHeight[i]+0x40) end
        end
        if min(unpack(o.panelHeight)) == 0xa00 then s[0x26] = 1 end
    end

    local function ground(o)
        local run,s = o.run,o.state
        local armed = o.kind == 0x44
        local hatch = o.kind == 0x55 or o.kind == 0x56
        local twins = o.kind == 0x45
        local threshold = o.flashAt or (armed and 0x100 or twins and 0x140 or o.kind == 0x4a and 0x200 or 0x400)
        if band(o.flags,0x5800) == 0 then
            local weak = hatch and o.hp <= threshold or o.hp < threshold
            o.colorFrame = weak and band(run.frame,0x0e)==0 and 3 or 1
        else
            o.flags, o.colorFrame = band(o.flags,0xa7ff),o.colorFrame == 2 and 1 or 2
            if armed and not o.weakened then
                if o.hp <= threshold then
                    score.base(o,0x8c)
                    o.weakened = true
                    effects.spawn(run,o.h,o.l,tank.breakup,true,true)
                    if run.onBreakPart then run.onBreakPart(o) end
                end
            elseif o.hp < 0 then
                score.kill(o,groundPoints[o.kind])
                retire(o,data[o.kind].death or staticDeath[o.kind],true)
                return
            end
        end
        if armed or hatch then effects.attachSmoke(o,data[o.kind].smoke) end
        if run.freeze then return end
        if not path.step(o) then remove(o); return end
        if not visible(o,armed and 0xe00 or hatch and 0xa00 or 0x800,
                armed and 0x8c00 or hatch and 0x8400 or 0x8000,
                armed and 0x1000 or hatch and 0x1200 or 0x1c00,
                armed and 0x5800 or hatch and 0x5c00 or 0x7000) then return end
        if not armed and not hatch and not twins then return end
        local inRange = band(o.h-0x3200,0xffff)<0x3c00
        if twins then
            twinGuns(o,inRange)
            return
        elseif hatch then
            hatchWeapons(o,inRange)
        elseif not o.weakened and not run.bulletHold and inRange then
            if s[0x1e] == 0 then front(o) end
            if s[0x1e] == 1 then rear(o) end
        end
        if o.direction < 0x40 and o.speed ~= 0 and tick(s,0x1a) then
            s[0x1a] = o.speed <= 4 and 5 or o.speed <= 8 and 1 or 0
            o.trackFrame = (o.trackFrame+1)%(hatch and 4 or 2)
        end
    end

    function M.step(o)
        if o.kind == 0x84 then
            aircraft(o)
        elseif o.kind == 0x48 then
            rotatingTurret(o)
        elseif o.kind == 0x46 or o.kind == 0x47 then
            doors(o)
        else
            ground(o)
        end
    end

    local doorOffsets = {
        [0x46]={0xf600fb00+0xf23ffac0,0xf600fb00+0xebc003c0,0xf800fc00+0xe6000b00},
        [0x47]={0xf800fc00+0xe6bff4c0,0xf600fb00+0xebfffbc0,0xf600fb00+0xf24004c0},
    }

    function M.render(o, draw)
        local art,color = data[o.kind],o.colorFrame
        if o.kind == 0x84 then
            draw(o,air.rotors[color][o.rotor+1],-0x100,-0xf00)
            draw(o,air.rotors[color][(o.rotor-1)%4+1],-0x100,0x700)
            draw(o,air.rotors[color][(o.rotor-2)%4+1],0x400,-0xa40)
            draw(o,air.rotors[color][(o.rotor-3)%4+1],0x400,0x240)
            draw(o,air.body[color],-0x1600,-0x1000)
            if o.state[0x35] == 0 then return end
            local gun = air.gun[color]
            draw(o,gun[band(o.headings[1],0x3e)/2+1],-0x740,-0xf40)
            draw(o,gun[band(o.headings[3],0x3e)/2+1],-0x740,0x700)
            draw(o,gun[band(o.headings[2],0x3e)/2+1],-0x240,-0xa80)
            draw(o,gun[band(o.headings[4],0x3e)/2+1],-0x240,0x240)
        elseif o.kind == 0x44 then
            draw(o,art.body[color],-0xe00,-0xb00)
            draw(o,art.tracks[color][o.trackFrame+1],-0xdff,-0x800)
            draw(o,art.tracks[color][o.trackFrame+3],-0xdff,0x400)
            if o.weakened then return end
            draw(o,art.frontGun[color][band(o.state[0x20],0x3e)/2+1],0x700,-0x400)
            draw(o,art.rearGun[color][band(o.state[0x21],0x3e)/2+1],-0x780,-0x500)
        elseif o.kind == 0x55 or o.kind == 0x56 then
            local s = o.state
            local h,l = add(-0xa00,-0xa00,s16(word(s,0x1e)),s16(word(s,0x20)))
            draw(o,art.hatch[color][o.hatchFrame+1],h,l)
            local trackL,gunH,gunL = -0x800,0x340,-0x780
            if o.kind == 0x55 then trackL,gunH,gunL = -0xa00,0x380,-0x80 end
            draw(o,art.tracks[color][o.trackFrame+1],-0xb00,trackL)
            h,l = add(gunH,gunL,s16(word(s,0x22)),s16(word(s,0x24)))
            draw(o,art.gun[color][band(s[0x26],0x3e)/2+1],h,l)
        elseif o.kind == 0x45 then
            draw(o,art.gun[color][floor((o.state[0x1a]+2)%256/8)+1],-0x800,-0x700)
        elseif o.kind == 0x48 then
            local s = o.state
            if s[0x25] > 0 and s[0x25] < 0x20 then return end
            draw(o,art.gun[color][2*s[0x1a]+s[0x29]/4+1],-0xc00,s[0x1a]>0x20 and -0xc00 or -0xa00)
        elseif o.panelHeight then
            for i,height in ipairs(o.panelHeight) do
                if height ~= 0xa00 then
                    local h,l = program.unpack(doorOffsets[o.kind][i])
                    draw(o,art.doors[color][i],h+height,l)
                end
            end
            draw(o,art.body[color],-0x1a00,-0xf00)
        elseif o.kind == 0x4a then
            draw(o,art.body[color],-0x800,-0x400)
        else
            draw(o,art.body[color],-0xe00,-0x500)
        end
    end

    return M
end
