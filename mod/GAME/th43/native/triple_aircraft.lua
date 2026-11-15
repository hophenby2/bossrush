-- 0xdeafc、0xdff92、0xe087a 共用三块受击区。第四个部件槽只存尾炮状态。
return function(program, path, bullets, effects, remove, score)
    local band = require('bit').band
    local s16, word = program.s16, program.word
    local data = program.tripleAircraft
    local M = {}

    function M.canSpawn(run, kind)
        return kind ~= 0x4e or not run.mid3 or run.minor < 0x48 or run.minor >= 0x6c
    end

    function M.init(o)
        local state = o.state
        local hp, threshold = word(state,0x1c), word(state,0x3e)
        if o.kind == 0x4e then hp,threshold = 0x1c00,0x1000
        elseif o.kind == 0x50 then hp,threshold = 0x2e00,0x1a00
        elseif o.run.minor >= 0x6c then hp,threshold = 0x4c00,0x2200 end
        o.aircraftHp,o.damageAt,o.palette = hp,threshold,1
        state[0x22] = program.random(o.run,program.enemyRandom)
        state[0x23] = program.random(o.run,program.enemyRandom)
        o.tailAngle,o.tailClock = 0,o.aircraftData.tailClock
        for _, part in ipairs(o.attachments) do
            part.front,part.back = s16(part.front),s16(part.back)
            part.right,part.left = s16(part.right),s16(part.left)
        end
    end

    local function damage(o)
        local hit, hp = band(o.flags,0x5800) ~= 0, o.hp
        for _, part in ipairs(o.attachments) do
            part.h,part.l = o.h,o.l
            hit = hit or band(part.flags,0x5800) ~= 0
            hp = math.min(hp,part.hp)
        end
        if not hit then
            o.palette = o.aircraftHp < 0x900 and band(o.run.frame,0x0e) == 0 and 3 or 1
            return true
        end
        o.flags,o.hp = band(o.flags,0xa7ff),0x7fff
        for _, part in ipairs(o.attachments) do
            part.flags,part.hp = band(part.flags,0xa7ff),0x7fff
        end
        o.palette = o.palette == 2 and 1 or 2
        o.aircraftHp = o.aircraftHp - (0x7fff-hp)
        if not o.brokenTurrets then
            if o.aircraftHp <= o.damageAt then
                score.kill(score.source(o,o.attachments),0x82,nil,nil,o)
                o.brokenTurrets = true
                effects.spawn(o.run,o.h,o.l,o.aircraftData.damage,false,true)
                if o.run.onBreakPart then o.run.onBreakPart(o) end
            end
        elseif o.aircraftHp < 0 then
            score.kill(score.source(o,o.attachments),0x186,nil,nil,o)
            effects.spawn(o.run,o.h,o.l,o.aircraftData.breakup,false,true)
            if o.run.onEnemyDeath then o.run.onEnemyDeath(o) end
            remove(o)
            return false
        end
        return true
    end

    local function countdown(state, offset)
        local active = state[offset] == 0
        state[offset] = active and state[offset+1] or state[offset]-1
        return active
    end

    local function position(o, packedOffset)
        return program.add(o.h,o.l,program.unpack(packedOffset))
    end

    local function steer(o, angle, h, l)
        local run = o.run
        local target = run.pilotH and program.angle(h,l,run.pilotH,run.pilotL,angle) or band(l,0x3f)
        return program.turnToward(angle,target)
    end

    local function fireTurret(o, h, l, angle)
        local muzzle = data.turretMuzzle[band(angle,0x3e)/2+1]
        bullets.emitDirect(o.run,0xc,-4,angle,h,l,muzzle[1],muzzle[2])
        bullets.emitDirect(o.run,0xc,-2,angle,h,l,muzzle[1],muzzle[2])
    end

    local function turrets(o)
        local state, guns = o.state,o.aircraftData.guns
        for i = 1, 2 do
            local h,l = position(o,guns[i])
            if h > 0x2000 then
                local offset = 0x1f+i
                state[offset] = steer(o,state[offset],h,l)
                if countdown(state,0x22+i*2) then fireTurret(o,h,l,state[offset]) end
            end
        end
        local h,l = position(o,guns[3])
        if h > 0x2000 then
            o.tailAngle = steer(o,o.tailAngle,h,l)
            if o.tailClock == 0 then
                o.tailClock = o.aircraftData.tailReload
                fireTurret(o,h,l,o.tailAngle)
            else
                o.tailClock = o.tailClock-1
            end
        end
    end

    -- 0xdeea4 的五发扇面在两条二周目都拆成相邻的两颗。角度仍由自机位置决定。
    local function fan(o)
        local run,state = o.run,o.state
        if state[0x2c] == 0 then
            state[0x22] = band(state[0x22]+1,0x3f)
            if not countdown(state,0x28) then return end
            state[0x2c] = state[0x2d]
        end
        if not countdown(state,0x2a) then return end
        local h,l = position(o,o.aircraftData.guns[4])
        local angle = h > 0x2000 and run.pilotH and program.aimByte(h,l,run.pilotH,run.pilotL,nil,true)
        if not angle then return end
        for i = -2, 2 do
            local a = angle+i*6
            local modifier = i%2 == 0 and -3 or -2
            if run.route.loop == 1 then
                bullets.emitAngle(run,7,modifier,a-1,h,l)
                bullets.emitAngle(run,7,modifier,a+1,h,l)
            else
                bullets.emitAngle(run,7,modifier,a,h,l)
            end
        end
        state[0x2c] = state[0x2c]-1
    end

    -- 炮位炸毁后 0xdef82 打开舱口。0xf9a62 继续处理离开炮口后的加速。
    local acceleration = {8,1,1,0x18}
    local function hatch(o)
        local run,state,variant = o.run,o.state,o.aircraftData
        if state[0x1e] == 0 and countdown(state,0x36) then
            state[0x35] = state[0x35]+4
            if state[0x35] == 0x1c then
                state[0x1e] = 1
                state[0x3a] = program.random(run,program.enemyRandom)
            end
        end
        if state[0x1e] ~= 1 then return end
        local h,l = position(o,variant.hatchPivot)
        if h <= 0x2000 or not countdown(state,0x38) or not run.pilotH then return end
        local angle = program.aimByte(h,l,run.pilotH,run.pilotL,nil,true)
        if not angle then return end
        local offset = data.hatchMuzzle[band(state[0x3a],0x3f)+1]+variant.hatchPivot
        local dh,dl = program.unpack(offset)
        local narrow = o.kind == 0x4e and run.minor ~= 0
        local radius, spacing, modifier = narrow and 2 or 4, narrow and 6 or 8, narrow and -9 or -11
        for i = -radius, radius do
            bullets.emitFasterInLoop(run,0x12,modifier,angle+i*spacing,s16(o.h+dh),s16(o.l+dl),acceleration)
        end
        state[0x3a] = band(state[0x3a]+6,0xff)
    end

    function M.step(o)
        if not damage(o) or o.run.freeze then return end
        if not path.step(o) then remove(o); return end
        local visible = band(o.h+0x1400,0xffff) < 0x9800
            and band(o.l+0x2800+o.run.cameraOffset,0xffff) < 0x8800
        if not visible and o.entered then remove(o); return end
        o.entered = o.entered or visible
        if o.brokenTurrets then hatch(o)
        else
            turrets(o)
            fan(o)
        end
    end

    local function renderOffset(o, render, sprite, offset)
        local h,l = position(o,offset)
        render(o,sprite,s16(h-o.h),s16(l-o.l))
    end

    function M.render(o, render)
        local art,palette,state = o.aircraftData,o.palette,o.state
        for _, piece in ipairs(art.body) do renderOffset(o,render,piece[palette+1],piece[1]) end
        renderOffset(o,render,art.hatch[palette][state[0x35]/4+1],art.hatchDraw)
        if o.brokenTurrets then return end
        local directions = {state[0x20],state[0x21],o.tailAngle,state[0x22]}
        for i, angle in ipairs(directions) do
            local sprites = i == 4 and data.fan or data.direct
            renderOffset(o,render,sprites[palette][band(angle,0x3e)/2+1],art.guns[i]+0xfc00fc00)
        end
    end

    return M
end
