-- 0xd7cdc。车体、舱口和两门炮使用各自的碰撞框，炮台共用车体血量。
return function(program, path, bullets, effects, remove, score)
    local band = require('bit').band
    local floor, max = math.floor, math.max
    local word, s16, add = program.word, program.s16, program.add
    local data = program.heavyTank
    local T = {}

    local function tick(state, index)
        local timer = state[index]
        state[index] = (timer-1) % 256
        return timer == 0
    end

    local function place(o)
        local hatch, left, right = unpack(o.attachments)
        hatch.h,hatch.l = add(o.h,o.l,-0x800,0)
        left.h,left.l = o.h,o.l
        right.h,right.l = o.h,o.l
        for _, part in ipairs(o.attachments) do part.x,part.y = program.world(part.h,part.l) end
    end

    function T.init(o)
        o.hatch, o.colorFrame, o.trackIndex = 0, 1, {0,0}
        o.breakAt = word(o.state,0x38)
        if o.run.stageNumber == 3 then
            o.hp,o.breakAt = 0xa80,0x600
            o.state[0x2f] = o.state[0x2f]+3
        end
        for i, gun in ipairs(o.attachments) do
            gun.heading,gun.colorFrame = 0x20,1
            if i > 1 then gun.lockable = true end
        end
        place(o)
    end

    local function damage(o)
        local hatch,left,right = unpack(o.attachments)
        local amount = max(0,0x7fff-left.hp,0x7fff-right.hp)
        local hit = band(o.flags,0x5800) ~= 0 or amount > 0 or hatch.hp < 0x7fff
        o.flags,hatch.flags = band(o.flags,0xa7ff),band(hatch.flags,0xa7ff)
        hatch.hp = 0x7fff
        o.hp = o.hp-amount
        if hit then
            o.colorFrame = o.colorFrame == 2 and 1 or 2
        else
            o.colorFrame = o.hp < 0xd5 and band(o.run.frame,0x0e) == 0 and 3 or 1
        end
        local crossing = hit and o.hp <= o.breakAt
        for i = 2,3 do
            local p = o.attachments[i]
            local struck = band(p.flags,0x5800) ~= 0
            p.flags,p.hp = band(p.flags,0xa7ff),0x7fff
            if crossing and not p.broken then
                p.flags,p.broken = 0x8100,true
                local side = i == 2 and -1 or 1
                effects.spawn(o.run,p.h,p.l,{
                    {2,0x8b,0,-0x200,side*0xa00,0xe,side == -1 and 0x90 or 0x70},
                    {0,0x88,0,0,side*(i == 2 and 0x800 or 0x600),0xa,side == -1 and 0x88 or 0x78},
                },true,true)
            elseif struck then
                p.colorFrame = p.colorFrame == 2 and 1 or 2
            else
                p.colorFrame = o.colorFrame
            end
        end
        if crossing and not o.weakened then
            local hit = score.source(o,o.attachments)
            hit.multiplierDivisor = 30
            score.kill(hit,0xfa,-0x800,nil,o)
            hit.multiplierDivisor = nil
            o.weakened = true
            o.state[0x2f] = o.state[0x2f]+1
            if o.run.onBreakPart then o.run.onBreakPart(o) end
        end
    end

    local function open(o)
        local state,hatch = o.state,o.attachments[1]
        local delay = word(state,0x26)
        if delay ~= 0 then
            delay=delay-1
            state[0x26],state[0x27] = floor(delay/256),delay%256
            if delay == 0 then hatch.flags = 0xa001 end
            return
        end
        if not tick(state,0x1e) then return end
        state[0x1e] = state[0x1f]
        hatch.right,hatch.left = hatch.right+0xc0,hatch.left+0xc0
        o.hatch = o.hatch+1
        if o.hatch == 8 then
            o.hatch,state[0x24],state[0x25] = 7,1,1
            hatch.flags = 0x8000
            for i = 2,3 do
                local gun = o.attachments[i]
                if not gun.broken then gun.flags = 0xa101 end
            end
        end
    end

    local function track(o)
        local run = o.run
        if run.frame % 2 == 0 or not run.pilotH then return end
        for i = 2,3 do
            local gun = o.attachments[i]
            local l = i == 2 and -0x580 or 0x580
            local target = program.angle(o.h-0x600,o.l+l,run.pilotH,run.pilotL,gun.heading)
            gun.heading = program.turnToward(gun.heading,target)
        end
    end

    -- 0xf7064 在二周目把同一炮口朝向前后错开四个角度单位。
    local function fan(o)
        local run,state = o.run,o.state
        if state[0x2e] == 0 then
            if not tick(state,0x28) then return end
            state[0x28],state[0x2e] = state[0x29],state[0x2f]
        end
        if not tick(state,0x2c) then return end
        state[0x2c] = state[0x2d]
        if not run.pilotH then return end
        local h,l = s16(o.h-0xe00),o.l
        local direction = program.aimByte(h,l,run.pilotH,run.pilotL,0x80)
        local count = o.attachments[2].broken and o.attachments[3].broken and 5 or 4
        local spread = run.route.loop == 1 and 4 or 0
        for i = 1,count do
            local a = direction+24*(i-(count+1)/2)
            bullets.emitAngle(run,2,0,a-spread,h,l)
            if spread > 0 then bullets.emitAngle(run,2,0,a+spread,h,l) end
        end
        state[0x2e] = state[0x2e]-1
        if state[0x2e] == 0 then state[0x24] = 2 end
    end

    local function aimed(o)
        local run,state = o.run,o.state
        if state[0x36] == 0 then
            track(o)
            if not tick(state,0x30) then return end
            state[0x30],state[0x36] = state[0x31],state[0x37]
        end
        if not tick(state,0x34) then return end
        state[0x34] = state[0x35]
        for i = 2,3 do
            local p = o.attachments[i]
            if not p.broken then
                local h,l = add(o.h,o.l,i == 2 and -0x601 or -0x600,i == 2 and -0x580 or 0x580)
                local muzzle = data.muzzle[band(p.heading,0x3e)/2+1]
                bullets.emit(run,0xc,2,p.heading,h,l,muzzle[1],muzzle[2])
            end
        end
        state[0x36] = state[0x36]-1
        if state[0x36] == 0 then state[0x24] = 1 end
    end

    local function close(o)
        local state,hatch = o.state,o.attachments[1]
        if state[0x25] ~= 0 then
            state[0x25],hatch.flags = 0,0xffff
            for i = 2,3 do o.attachments[i].flags = 0x8000 end
        end
        if not tick(state,0x1e) then return end
        state[0x1e] = state[0x1f]
        hatch.right,hatch.left = hatch.right-0xc0,hatch.left-0xc0
        o.hatch = max(0,o.hatch-1)
        if o.hatch == 0 then
            hatch.flags,state[0x24],state[0x26],state[0x27] = 0x8000,0,0,0x10
        end
    end

    function T.step(o)
        local run,state = o.run,o.state
        damage(o)
        if o.hp < 0 then
            score.kill(score.source(o,o.attachments),0x208,-0x400,nil,o)
            effects.spawn(run,o.h,o.l,data.breakup,true,true)
            if run.onEnemyDeath then run.onEnemyDeath(o) end
            remove(o)
            return
        end
        if run.freeze then return end
        if not path.step(o) then remove(o); return end
        place(o)
        local visible = band(o.h+0x1000,0xffff) < 0x8800
            and band(o.l+0x1600+run.cameraOffset,0xffff) < 0x6400
        if not visible and o.entered then remove(o); return end
        o.entered = o.entered or visible
        if state[0x24] == 0 then open(o) end
        if state[0x24] == 1 then
            track(o)
            if not run.suppressShots then fan(o) end
        end
        if (run.stageNumber == 3 or state[0x24] == 2) and not run.suppressShots then aimed(o) end
        if state[0x24] == 3 then close(o) end
        local trackIndex = run.frame % 2+1
        o.drawTrack = trackIndex
        o.trackIndex[trackIndex] = (o.trackIndex[trackIndex]+1)%4
    end

    function T.render(o, render)
        local stage = data.stages[o.run.stageNumber]
        local body = stage.body[o.colorFrame]
        render(o,body[1],-0x1400,-0x900)
        for i = 2,3 do
            local gun = o.attachments[i]
            if not gun.broken then
                local art = stage.guns[i-1][gun.colorFrame]
                local side = i == 2 and -1 or 1
                if o.state[0x25] == 0 then
                    render(o,art[o.hatch+1],-0xa00,-0x400+side*0x500)
                else
                    render(o,art[9+floor(band(gun.heading,0x3e)/2)],-0xb00,-0x400+side*0x580)
                end
            end
        end
        if o.drawTrack then
            render(o,body[2+o.trackIndex[o.drawTrack]],o.drawTrack == 1 and -0xd00 or 0x800,-0x900)
        end
    end

    return T
end
