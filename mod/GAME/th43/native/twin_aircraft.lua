-- 0xe1168。两段机身共享血量，机腹炮与两侧小炮使用各自的发弹计数。
return function(program, path, bullets, effects, remove, score)
    local band = require('bit').band
    local min, max = math.min, math.max
    local word, add = program.word, program.add
    local data = program.twinAircraft
    local M = {}
    local pivot = {{0,-0x300},{0x100,0x300}}

    local function countdown(state, offset)
        local timer = state[offset]
        state[offset] = (timer-1) % 256
        return timer == 0
    end

    local function aim(o, h, l, heading)
        local run = o.run
        if run.pilotH then
            return program.angle(h,l,run.pilotH,run.pilotL,heading)
        end
        return heading
    end

    local function place(o)
        local rear = o.attachments[1]
        rear.h,rear.l = o.h,o.l
        rear.x,rear.y = program.world(rear.h,rear.l)
    end

    function M.init(o)
        local run,state = o.run,o.state
        o.aircraftHp,o.damageAt = word(state,0x1e),word(state,0x3e)
        if run.stageNumber == 5 then o.aircraftHp,o.damageAt = 0x1300,0x800 end
        o.armorClock = word(state,0x34)
        o.colorFrame,o.exhaust = 1,0
        o.heading={0,0}
        for i, offset in ipairs(pivot) do
            local h,l = add(o.h,o.l,offset[1],offset[2])
            o.heading[i] = aim(o,h,l,0)
        end
        local side = band(program.random(run,program.randomParity),1)
        state[0x26],state[0x27] = side,side
        place(o)
    end

    local function damage(o)
        local rear = o.attachments[1]
        local hit = band(o.flags,0x5800) ~= 0 or band(rear.flags,0x5800) ~= 0
        local amount = 0x7fff-min(o.hp,rear.hp)
        if o.armorClock > 0 then o.armorClock,amount = o.armorClock-1,0 end
        o.flags,rear.flags = band(o.flags,0xa7ff),band(rear.flags,0xa7ff)
        o.hp,rear.hp = 0x7fff,0x7fff
        if not hit then
            o.colorFrame = o.aircraftHp < 0x255 and band(o.run.frame,0x0e) == 0 and 3 or 1
            return
        end
        o.colorFrame = o.colorFrame == 2 and 1 or 2
        o.aircraftHp = o.aircraftHp-max(amount,0)
        if not o.brokenTurrets and o.aircraftHp <= o.damageAt then
            local source = score.source(o,o.attachments)
            source.multiplierDivisor = 30
            score.kill(source,0x168,-0x600,nil,o)
            source.multiplierDivisor = nil
            o.brokenTurrets = true
            effects.spawn(o.run,o.h,o.l,data.damage,false,true)
            if o.run.onBreakPart then o.run.onBreakPart(o) end
        end
    end

    local function belly(o)
        local run,state = o.run,o.state
        if state[0x24] == 0 then
            if not countdown(state,0x20) then return end
            state[0x20],state[0x24] = state[0x21],state[0x25]
            state[0x26] = 1-state[0x26]
        end
        if not countdown(state,0x22) then return end
        state[0x22] = state[0x23]
        local h,l = add(o.h,o.l,state[0x26] == 0 and -0xb41 or -0xb40,state[0x26] == 0 and -0x480 or 0x480)
        if state[0x24] == state[0x25] then
            if not run.pilotH then return end
            o.bellyHeading = program.angle(o.h-0xb40,l,run.pilotH,run.pilotL,o.bellyHeading or 0)
        end
        local direction = o.bellyHeading or 0
        bullets.emit(run,0x16,2,direction,h,l)
        if run.stageNumber == 5 then
            for _, delta in ipairs({2,-2}) do
                local angle = direction+delta
                local muzzle = data.fanMuzzle[band(angle,0x3f)+1]
                bullets.emit(run,0x16,2,angle,h,l,muzzle[1],muzzle[2])
            end
        end
        state[0x24] = state[0x24]-1
    end

    local function turrets(o)
        if o.brokenTurrets then return end
        local run,state = o.run,o.state
        if state[0x2c] == 0 then
            for i, offset in ipairs(pivot) do
                local h,l = add(o.h,o.l,offset[1],offset[2])
                o.heading[i] = program.turnToward(o.heading[i],aim(o,h,l,o.heading[i]))
            end
            if not countdown(state,0x28) then return end
            state[0x28],state[0x2c] = state[0x29],state[0x2d]
            state[0x27] = 1-state[0x27]
        end
        if not countdown(state,0x2a) then return end
        state[0x2a] = state[0x2b]
        local side = state[0x27]+1
        local h,l = add(o.h,o.l,unpack(pivot[side]))
        local heading = o.heading[side]
        local muzzle = data.turretMuzzle[band(heading,0x3e)/2+1]
        local count,spacing = 5,2
        if run.stageNumber == 5 then count,spacing = 7,7 end
        local split = run.route.loop == 1 and 8 or 0
        for i = 1,count do
            local angle = heading*4+spacing*(i-(count+1)/2)
            bullets.emitAngle(run,6,2,angle-split,h,l,muzzle[1],muzzle[2])
            if split ~= 0 then bullets.emitAngle(run,6,2,angle+split,h,l,muzzle[1],muzzle[2]) end
        end
        state[0x2c] = state[0x2c]-1
    end

    function M.step(o)
        local run = o.run
        damage(o)
        if o.aircraftHp < 0 then
            score.kill(score.source(o,o.attachments),0xf0,-0xa00,nil,o)
            effects.spawn(run,o.h,o.l,data.breakup,false,true)
            if run.onEnemyDeath then run.onEnemyDeath(o) end
            remove(o)
            return
        end
        if run.freeze then return end
        if not path.step(o) then remove(o); return end
        place(o)
        local visible = band(o.h+0x1400,0xffff) < 0x8c00
            and band(o.l+0x1200+run.cameraOffset,0xffff) < 0x5c00
        if not visible and o.entered then remove(o); return end
        o.entered = o.entered or visible
        if run.frame % 2 == 0 then o.exhaust = (o.exhaust+1)%4 end
        if run.suppressShots then return end
        local limit = program.aimLimits[1][run.stageNumber]
        if band(o.h-limit[2],0xffff)+limit[1] >= 0x10000 then return end
        belly(o)
        turrets(o)
    end

    function M.render(o, render)
        local art = data.art[o.run.stageNumber][o.colorFrame]
        render(o,art.body,-0x1200,-0xa00)
        if not o.brokenTurrets then
            render(o,art.turret[band(o.heading[1],0x3e)/2+1],-0x201,-0x600)
            render(o,art.turret[band(o.heading[2],0x3e)/2+1],-0x100,0)
        end
        if o.run.frame % 2 == 0 then
            render(o,art.tail[o.exhaust+1],-0x940,-0x1000)
        elseif o.run.stageNumber ~= 5 then
            render(o,art.flare,-0x1e00,0x300)
        end
    end

    return M
end
