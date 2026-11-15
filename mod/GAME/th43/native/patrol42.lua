-- 0xdd34e。中炮和两侧炮位有独立计数，机体的两块判定共用耐久。
return function(program, path, bullets, effects, remove, score)
    local band = require('bit').band
    local s16, word = program.s16, program.word
    local data = program.patrol42
    local M = {}

    function M.init(o)
        local state, run = o.state, o.run
        o.aircraftHp = word(state,0x32)
        if run.major >= 0x1b0 then
            if run.patrol42Block then return false end
            run.patrol42Block = true
            o.aircraftHp = 0x2500
        end
        state[0x22] = state[0x22]-band(program.random(run,program.randomParity),0x1f)
        state[0x28] = state[0x28]-band(program.random(run,program.randomParity),0x1f)
        if run.route.loop == 1 then state[0x24],state[0x25] = 6,6 end
        o.palette = 1
        return true
    end

    local function countdown(state, offset)
        local ready = state[offset] == 0
        state[offset] = ready and state[offset+1] or state[offset]-1
        return ready
    end

    local function damage(o, wing)
        local hit = band(o.flags,0x5800) ~= 0 or band(wing.flags,0x5800) ~= 0
        if not hit then
            o.palette = o.aircraftHp < 0xb66 and band(o.run.frame,0x0e) == 0 and 3 or 1
            return
        end
        o.aircraftHp = o.aircraftHp-(0x7fff-math.min(o.hp,wing.hp))
        o.flags,wing.flags = band(o.flags,0xa7ff),band(wing.flags,0xa7ff)
        o.hp,wing.hp = 0x7fff,0x7fff
        o.palette = o.palette == 2 and 1 or 2
        if o.aircraftHp >= 0 then return end
        score.kill(score.source(o,o.attachments),0x212,-0x800,nil,o)
        o.crashing,o.flags,wing.flags,o.palette = true,0x8000,0x8000,1
        o.run.patrol42Block = nil
        effects.spawn(o.run,o.h,o.l,data.damage,false,true)
        if o.run.onEnemyDeath then o.run.onEnemyDeath(o) end
    end

    local function fire(o)
        local state,run = o.state,o.run
        if run.pilotH then
            local angle = program.angle(s16(o.h-0x700),o.l,run.pilotH,run.pilotL,state[0x20])
            state[0x20] = program.turnToward(state[0x20],angle)
        end
        if state[0x1f] == 0 and countdown(state,0x22) then
            local a, modifier = state[0x20]*4,s16(word(state,0x26))
            for i = -3, 3 do bullets.emitAngle(run,7,modifier,a+i*12,o.h,o.l,-0x700,0) end
            state[0x23] = math.max(4,state[0x23]-1)
            state[0x24] = state[0x24]-1
            if state[0x24] == 0 then
                state[0x24] = state[0x25]
                state[0x2e] = math.max(4,state[0x2e]-1)
                state[0x23] = state[0x2e]
                local _,rank = program.smallRank(run)
                state[0x22] = 0x80-rank
            end
        end

        if state[0x2c] == 0 then
            if not countdown(state,0x28) then return end
            state[0x2c] = state[0x2d]
            state[0x21] = program.random(run,program.randomParity)
        end
        if not countdown(state,0x2a) then return end
        local first, second = (0x18+state[0x21])*4,(0x28-state[0x21])*4
        bullets.emitCenterAndWide(run,0x18,0,first,o.h,o.l,-0x600,0x8c0)
        bullets.emitCenterAndWide(run,0x18,0,first+0x80,o.h,o.l,-0x600,0x8c0)
        bullets.emitCenterAndWide(run,0x18,0,second,o.h,o.l,-0x601,-0x8c0)
        bullets.emitCenterAndWide(run,0x18,0,second+0x80,o.h,o.l,-0x601,-0x8c0)
        state[0x21] = band(state[0x21]+2,0xff)
    end

    local function animate(o)
        local state = o.state
        if state[0x1e] == 0 then
            state[0x1b] = band(state[0x1b]+4,0xf)
            if o.part[0x1e] ~= 0 then state[0x1e] = 1 end
        end
        if state[0x1e] == 1 then
            state[0x1b] = state[0x1b]+4
            if state[0x1b] == 0x2c then state[0x1e] = 2 end
        end
        if state[0x1e] == 2 then
            state[0x1b] = state[0x1b]+4
            if state[0x1b] >= 0x3c then state[0x1b] = 0x30 end
            if o.part[0x1e] == 0 then state[0x1e] = 3 end
        end
        if state[0x1e] == 3 then
            state[0x1b] = state[0x1b]-4
            if state[0x1b] == 0x10 then state[0x1e] = 0 end
        end
    end

    function M.step(o)
        local state,run,wing = o.state,o.run,o.attachments[1]
        if o.crashing then
            o.h = s16(o.h-0x20)
            state[0x1d] = state[0x1d]-1
            if state[0x1d] == 0 then
                effects.spawn(run,o.h,o.l,data.breakup,false,true)
                remove(o)
            end
            return
        end
        damage(o,wing)
        if run.freeze then return end
        if not path.step(o) then remove(o); return end
        wing.h,wing.l = o.h,o.l
        local visible = band(o.h+0xc00,0xffff) < 0x8400
            and band(o.l+0x1800+run.cameraOffset,0xffff) < 0x6800
        if not visible and o.entered then
            run.patrol42Block = nil
            remove(o)
            return
        end
        o.entered = o.entered or visible
        if not run.bulletHold and o.h >= 0x1000 then fire(o) end
        animate(o)
    end

    function M.render(o, render)
        local palette = o.palette
        render(o,data.body[palette],-0x1000,-0xc00)
        render(o,data.turret[palette][band(o.state[0x20],0x3e)/2+1],-0x900,-0x200)
        if not o.crashing then
            local sprite = data.hatch[palette][o.state[0x1b]/4+1]
            render(o,sprite,-0xa01,-0x1200)
            render(o,sprite,-0xa00,0x800)
        end
    end

    return M
end
