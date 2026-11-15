-- 飞机按各自的回调走路径或减速离场，击破时使用共用的五面反击指令。
return function(program, path, bullets, effects, remove, score)
    local bit = require('bit')
    local band, bxor = bit.band, bit.bxor
    local floor = math.floor
    local s16 = program.s16
    local data = program.raid
    local M = {}

    local function randomSigned(run, values)
        local value = program.random(run, values)
        return value < 0x80 and value or value-0x100
    end

    local function tick(state, offset)
        local timer = state[offset]
        state[offset] = (timer-1)%256
        return timer == 0
    end

    local function aim(o)
        local run = o.run
        if run.pilotH then return program.angle(o.h,o.l,run.pilotH,run.pilotL,o.aimDirection) end
    end

    function M.init(o)
        local run, state = o.run, o.state
        if o.kind == 0x9e then
            o.h, o.l, o.group, o.hitPool = 0, 0, GROUP.GHOST, nil
            o.lane = program.word(state,0x1c)/2 + 1 - (7 + randomSigned(run,data.jitter))
            return
        end
        o.aimDirection, o.drawDirection, o.animation, o.colorFrame = 0x20, o.direction, 2, 1
        if o.kind==0x1f then return end
        o.aimDirection = aim(o) or o.aimDirection
        if o.kind == 0x1c then
            o.exitDirection = band(o.direction+0x20,0x3c)
        else
            o.speed = band(o.speed+floor(randomSigned(run,program.effectRandom)/4),0xff)
        end
        o.direction = band(o.direction+floor(randomSigned(run,program.effectRandom)/2),0xff)
    end

    local function queue(run, kind, l)
        if #run.pendingSpawns >= 40 then return end
        local def = program.spawnTypes[kind]
        local row = {0,0,kind,0x40,0,0,0,0,def[1],def[2]}
        row.h, row.l, row.path = 0x7400, l, data.path
        run.pendingSpawns[#run.pendingSpawns+1] = row
    end

    local function group(o)
        local run, state = o.run, o.state
        if run.major < 0x70 then remove(o); return end
        if not tick(state,0x18) then return end
        state[0x18] = 8
        queue(run,0x1d,data.lanes[o.lane])
        o.lane = o.lane == 1 and #data.lanes or o.lane-1
        queue(run,0x1a,data.lanes[band(program.random(run,program.randomParity),0xf)+1])
        if band(state[0x1a],1) ~= 0 then
            queue(run,0x1c,data.lanes[band(program.random(run,program.randomParity),0xf)+1])
        end
        if tick(state,0x1a) then state[0x1a], state[0x18] = state[0x1b], state[0x19] end
    end

    local function retire(o)
        local run = o.run
        score.kill(o,0xa0)
        local lastSection = run.minor == 0x48
        local effect = (run.route.loop == 1 or lastSection and run.major >= 0x1a2) and 0xa or 2
        effects.spawn(run,o.h,o.l,{{0,effect,0x10,0,0,o.speed+8,o.direction*4}},false,true)
        if run.pilotH and not (lastSection and run.major >= 0x18f) then
            local angle = program.aimByte(o.h,o.l,run.pilotH,run.pilotL,o.direction*4,true)
            local kind = run.route.ura and 0xe or 0x25
            if run.minor == 0 and run.major >= 0x50 then
                bullets.emitAcceleration(run,kind,-17+run.route.loop*4,angle,o.h,o.l,{1,1,1,0x1c})
                if not run.route.ura then
                    if run.route.loop == 0 then
                        bullets.emitAcceleration(run,kind,-15,angle,o.h,o.l,{1,1,1,0x1e})
                    else
                        bullets.emitAcceleration(run,kind,-15,angle-0x12,o.h,o.l,{1,1,1,0x1e})
                        bullets.emitAcceleration(run,kind,-15,angle+0x12,o.h,o.l,{1,1,1,0x1e})
                    end
                end
            else
                bullets.emitAcceleration(run,kind,-17,angle,o.h,o.l,{1,1,1,0x1c})
                if run.route.loop == 1 then bullets.emitAcceleration(run,kind,-11,angle,o.h,o.l,{1,1,1,0x1c}) end
            end
        end
        if run.onEnemyDeath then run.onEnemyDeath(o) end
        remove(o)
    end

    local function brake(o)
        local run, state = o.run, o.state
        if o.speed ~= 0 and tick(state,0x24) then
            state[0x24], o.speed = state[0x25], o.speed-1
            if o.speed == 0 then
                state[0x24], state[0x25], state[0x18], state[0x1a] = 0, o.kind == 0x1c and 3 or 2, 0x10, 0x30
                o.direction = band(o.aimDirection,0x3c)
                local shotAngle = o.direction
                if run.pilotH then
                    shotAngle = program.aimByte(o.h,o.l,run.pilotH,run.pilotL,o.direction*4,true)
                    bullets.emitFasterInLoop(run,0x17,-4,shotAngle,o.h,o.l)
                end
                if o.kind == 0x1c and shotAngle ~= o.exitDirection then
                    o.turnStep = shotAngle > o.exitDirection and 4 or -4
                end
            end
        end
        local heading = run.frame%4 == 0 and aim(o)
        if heading then o.aimDirection = program.turnToward(o.aimDirection,heading) end
        if o.speed == 0 then o.leaving = true end
    end

    local function leave(o)
        local state = o.state
        local narrow = o.kind == 0x1c
        if o.speed ~= 0x1c and tick(state,0x24) then
            state[0x24], o.speed = state[0x25], o.speed + (narrow and 1 or 2)
        end
        if narrow then
            if not o.turned and tick(state,0x1a) then
                state[0x1a] = state[0x1b]
                o.direction = band(o.direction+(o.turnStep or 0),0x3c)
                o.turned = o.direction == o.exitDirection
            end
        elseif state[0x29] ~= 0 and tick(state,0x1a) then
            state[0x1a], state[0x29] = state[0x1b], state[0x29]-1
            local heading = aim(o)
            if heading then o.direction = program.turnToward(band(o.direction,0x3f),heading) end
        end
    end

    function M.step(o)
        if o.kind == 0x9e then group(o); return end
        local run = o.run
        if band(o.flags,0x5800) ~= 0 then
            o.flags, o.colorFrame = band(o.flags,0xa7ff), bxor(o.colorFrame-1,1)+1
            if o.hp < 0 then retire(o); return end
        else
            o.colorFrame = 1
        end
        local visible = band(o.h+0x600,0xffff) < 0x7c00 and band(o.l+0xe00+run.cameraOffset,0xffff) < 0x5400
        if o.entered and not visible then remove(o); return end
        o.entered = o.entered or visible
        if o.kind==0x1f then
            if not path.step(o) then remove(o); return end
            o.drawDirection,o.animation=o.direction,o.animation%3+1
            local target=run.frame%8==0 and aim(o)
            if target then
                local p=data.scoutMuzzles[band(o.direction+1,0x3e)/2+1]
                local h,l=program.add(o.h,o.l,p[1],p[2])
                local last=run.major>=0x1c0
                bullets.emitFasterInLoop(run,9,last and 4 or 0,4*(last and band(target,0x3e) or target),h,l)
            end
            return
        end
        o.drawDirection = o.aimDirection
        if not run.freeze then
            local h, l = program.vector(o.speed,o.direction*4)
            o.h, o.l = s16(o.h+h), s16(o.l+l)
            if o.leaving then
                leave(o)
                o.drawDirection = o.direction
            else
                brake(o)
                o.drawDirection = o.aimDirection
            end
        end
        o.animation = o.animation%3+1
    end

    function M.render(o, renderSprite)
        if o.kind == 0x9e then return end
        local index = band(o.drawDirection,0x3e)/2+1
        local offset = data.offsets[index]
        renderSprite(o,data.art[o.colorFrame][index][o.animation],offset[1],offset[2])
    end

    return M
end
