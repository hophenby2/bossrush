-- 一面母舰 0x80。0x12f1d2 管开舱和换段，0x12fc04 管移动，判定按机身区域挂载。
return function(program, path, bullets, effects, score)
    local directory = 'mod/GAME/th43/native/'
    local drones = dofile(directory .. 'mid1_drones.lua')(program,bullets,effects)
    local emitters = dofile(directory .. 'mid1_emitters.lua')(program,bullets,drones)
    local band = require('bit').band
    local s16,floor = program.s16,math.floor
    local data = program.mid1
    local M = {}
    local offsets = {{-0xa00,-0xc00},{-0xa00,0xc00},{-0xa00,-0xc00},{-0xa00,0xc00},
        {-0x400,0},{-0x400,0},{-0x400,0}}
    local wander = {{0x3c00,0x4c00,0x6000,0x6400},{0x4000,0x4800,0x5c00,0x6400},
        {0x3a00,0x4e00,0x5a00,0x6200}}

    local function position(o)
        for i, p in ipairs(o.parts) do
            p.h,p.l = s16(o.h+offsets[i][1]),s16(o.l+offsets[i][2])
        end
    end

    local Part = Class(object, {
        init = function(p, host, i)
            p.group,p.layer,p.colli,p.bound = GROUP.ENEMY,LAYER.ENEMY,false,false
            p.host,p.hitPool,p.hp,p.damagePending = host,2,0x7fff,0
            p.front,p.back,p.right,p.left = unpack(data.boxes[i])
            p.damage = function(self, amount) self.damagePending = self.damagePending+amount end
        end,
    })

    local function beginGate(o, name, opening)
        local last = name == 'bay' and 7 or 11
        o.gates[name] = {clock=opening and (name=='bay' and 0x20 or 0x40) or 0,
            opening=opening, frame=opening and 0 or last, last=last, created=o.tick}
        o.picture[name] = o.gates[name].frame
    end

    local function gateStep(o, name)
        local gate = o.gates[name]
        if not gate or gate.created == o.tick then return end
        gate.clock = gate.clock-1
        if gate.clock >= 0 then return end
        gate.frame = gate.frame+(gate.opening and 1 or -1)
        gate.clock,o.picture[name] = 1,gate.frame
        if gate.frame == (gate.opening and gate.last or 0) then o.gates[name] = nil end
    end

    local function draw(o, id, dh, dl)
        local image = o.run.art.sprites[id]
        Render(image[1],floor(s16(o.l+dl)/64)-112+image[2]/2,
            floor(s16(o.h+dh)/64)-224+image[3]/2)
    end

    local Carrier = Class(object, {
        init = function(o, run, row)
            o.run,o.group,o.layer,o.bound,o.colli = run,GROUP.GHOST,LAYER.ENEMY,false,false
            o.spawnFlags,o.part,o.state = row[4],{},{}
            assert(path.init(o,row),'一面母舰缺少入场路径')
            o.parts,o.wings,o.children,o.drones = {},{},{},{}
            for i = 1,#offsets do o.parts[i] = New(Part,o,i) end
            for i = 1,2 do o.wings[i] = {hp=data.hp[i+1],palette=1} end
            o.emit,o.picture,o.gates,o.tick = {},{bay=0,barrel=0,deck=0,shell=0},{},0
            o.hp,o.palette,o.mode = data.hp[1],1,0
            o.beginGate = beginGate
            o.mainStrength,o.mainWaveBonus,o.mainDelayBonus,o.droneRise = 0,0,0,0
            o.rounds,o.wingsBroken = 0,0
            position(o)
        end,
        render = function(o)
            if o.hidden then return end
            local art,picture = data.art,o.picture
            if not o.armed then
                if o.shellFrame then
                    draw(o,art.shellOpen[1][o.shellFrame+1],-0x1e00,-0x1800)
                else
                    draw(o,art.shell[1][picture.shell+1],-0x1c00,-0x1800)
                end
                return
            end
            draw(o,art.hull[o.palette],-0x1e00,-0xc00)
            for i, wing in ipairs(o.wings) do
                local side = i == 1 and 'left' or 'right'
                local dl = i == 1 and -0x1800 or 0
                if not wing.hidden then draw(o,art[side][wing.palette][picture.bay+1],-0x1800,dl) end
            end
            draw(o,art.barrel[o.palette][picture.barrel+1],-0x1700,-0x200)
            draw(o,art.deck[o.palette][picture.deck+1],-0x1080,-0x1600)
        end,
    })

    local function motion(o, mode, speed, direction)
        o.mode,o.targetDirection = mode,nil
        if speed then o.speed,o.direction = speed,direction end
    end

    local function moveVector(o)
        local h,l = program.vector(o.speed,o.direction*4)
        o.h,o.l = s16(o.h+h),s16(o.l+l)
    end

    local function move(o)
        if o.mode == 0 then
            if o.tick == 1 then
                o.h,o.l = -0x8000,s16(0x3000-o.run.cameraOffset)
                o.speed,o.direction,o.entryClock,o.entryDelay,o.entryHold = 1,0x3c,0xe,0xe,0x220
                o.openCountdown = 0x10
            end
            if o.entryHold > 0 then
                o.entryHold = o.entryHold-1
                o.h = s16(o.h-o.run.scrollStep*64)
            else
                o.entryClock = o.entryClock-1
                if o.entryClock < 0 then
                    o.entryDelay = math.max(3,o.entryDelay-1)
                    o.entryClock = o.entryDelay
                    if o.speed < 10 then o.speed = o.speed+1
                    elseif o.openCountdown > 0 then
                        o.openCountdown = o.openCountdown-1
                    end
                end
                moveVector(o)
            end
        else
            moveVector(o)
            if o.mode == 5 then
                if band(o.h+0x1e00,0xffff) >= 0xac00 then o.retire = true end
            else
                if o.targetDirection then o.direction = program.turnToward(o.direction,o.targetDirection) end
                local limits = wander[o.mode]
                local r = program.random(o.run,program.effectRandom)
                local l,h = band(o.l+0x2800,0xffff),band(o.h,0xffff)
                if l < limits[1] then r = r+0x10
                elseif l >= limits[2] then r = r+0x30
                elseif h >= limits[4] then r = r+0x20
                elseif h >= limits[3] then return end
                o.targetDirection = band(r,0x3f)
            end
        end
    end

    local function beginMain(o)
        motion(o,1)
        beginGate(o,'barrel',true)
        o.phase = 'mainOpen'
    end

    local function stepEntry(o)
        if o.shellFrame then
            o.shellClock = o.shellClock-1
            if o.shellClock >= 0 then return end
            o.shellFrame,o.shellClock = o.shellFrame+1,1
            if o.shellFrame ~= 16 then return end
            o.armed,o.speed = true,6
            for _, i in ipairs({1,2,5,6,7}) do o.parts[i].colli = true end
            beginMain(o)
        else
            o.picture.shell = (o.picture.shell+1)%8
            if o.openCountdown == 0 and o.picture.shell == 0 then o.shellFrame,o.shellClock = 0,1 end
        end
    end

    local function phase(o)
        if not o.armed then
            stepEntry(o)
        elseif o.phase == 'mainOpen' and not o.gates.barrel then
            emitters.start(o,1)
            o.phase = 'mainVolley'
        elseif o.phase == 'mainVolley' and not o.emit[1] and not o.gates.barrel then
            motion(o,2)
            beginGate(o,'bay',true)
            beginGate(o,'barrel',true)
            o.phase,o.droneSpawnStarted = 'bayOpen',false
        elseif o.phase == 'bayOpen' then
            if not o.gates.bay and not o.droneSpawnStarted then
                o.droneSpawnStarted = true
                emitters.start(o,2)
                emitters.start(o,3)
            end
            if not o.gates.barrel then
                emitters.start(o,4)
                o.phase = 'bayVolley'
            end
        elseif o.phase == 'bayVolley' and not o.emit[2] and not o.gates.bay then
            o.emit[4] = nil
            beginGate(o,'barrel',false)
            o.rounds = o.rounds+1
            if o.rounds == 3 then
                motion(o,5,10,0)
                o.invulnerable,o.phase = true,'exit'
            else
                o.phase = 'close'
            end
        elseif o.phase == 'close' and not o.gates.barrel then
            o.phase,o.pause = 'pause',0x30
        elseif o.phase == 'pause' then
            o.pause = o.pause-1
            if o.pause == 0 then beginMain(o) end
        end
    end

    local function consume(o, ...)
        local value,hit = 0,nil
        for _, i in ipairs({...}) do
            local p = o.parts[i]
            if p.damagePending > value then value,hit = p.damagePending,p end
            p.damagePending = 0
        end
        return value,hit
    end

    local function palette(run, before, amount, hp, threshold)
        if amount > 0 then return before == 2 and 1 or 2 end
        return hp < threshold and band(run.frame,0x0e) == 0 and 3 or 1
    end

    local function breakWing(o, i)
        local wing = o.wings[i]
        if wing.broken then return end
        wing.broken,wing.hp,wing.palette = true,-1,1
        o.parts[i].colli,o.parts[i+2].colli = false,false
        o.parts[i].broken,o.parts[i+2].broken = true,true
        o.wingsBroken = o.wingsBroken+1
        wing.explodeAt,wing.hideAt = o.tick+1,o.tick+12
        o.recoil,o.recoilAngle = 0x1e,i == 1 and 0x40 or 0xc0
    end

    local function destroy(o)
        o.dead,o.hp,o.palette = true,-1,1
        o.emit,o.droneClock = {},nil
        motion(o,3)
        for _, p in ipairs(o.parts) do p.colli,p.broken = false,true end
        o.forcedWings = 2-o.wingsBroken
        breakWing(o,1)
        breakWing(o,2)
        local before = ({[0]=0x18,0xc,0x28})[o.forcedWings]
        o.deathBlast,o.deathEnd = o.tick+before+8,o.tick+before+8+3+0x20
        bullets.clearFor(o.run,0x400)
    end

    -- 0x12ff48 先算三块核心的最大伤害。任一翼部击破时，剩余主血量减半。
    local function damage(o)
        local amount,hit = consume(o,5,6,7)
        o.palette = palette(o.run,o.palette,amount,o.hp,0x46cc)
        if not o.invulnerable then
            o.hp = o.hp-amount
            if o.hp < 0 then
                if hit then score.kill(hit,0xb18,-0x1000,nil,o.parts[7]) end
                destroy(o)
                return
            end
        end
        for i, wing in ipairs(o.wings) do
            if not wing.broken then
                amount,hit = consume(o,i,i+2)
                wing.palette = palette(o.run,wing.palette,amount,wing.hp,0x153d)
                if not o.invulnerable then wing.hp = wing.hp-amount end
                if wing.hp < 0 then
                    if hit then
                        hit.multiplierDivisor = 30
                        score.kill(hit,0x690,nil,nil,o.parts[i])
                    end
                    bullets.clearFor(o.run,0x20)
                    breakWing(o,i)
                    if o.wingsBroken == 2 then destroy(o); return end
                    o.hp = floor(o.hp/2)
                end
            end
        end
    end

    local function explosions(o)
        for i, wing in ipairs(o.wings) do
            if o.tick == wing.explodeAt then
                local l = o.forcedWings == 2 and s16(o.l+(i == 1 and -0x800 or 0x800)) or o.l
                effects.spawn(o.run,o.h,l,i == 1 and data.leftBreak or data.rightBreak,false,true)
            end
            if o.tick == wing.hideAt then wing.hidden = true end
        end
        if not o.dead then return end
        if o.tick == o.deathBlast then effects.spawn(o.run,o.h,o.l,data.hullBreak,false,true) end
        if o.tick == o.deathBlast+3 then o.hidden = true end
        if o.tick == o.deathEnd then
            bullets.clearFor(o.run,0x40)
            o.retire = true
        end
    end

    function M.spawn(run,row)
        run.mid1 = New(Carrier,run,row)
        return run.mid1
    end

    function M.close(o)
        drones.clear(o)
        for _, p in ipairs(o.parts) do object.RawDel(p) end
        o.run.mid1 = nil
        object.RawDel(o)
    end

    function M.touch(o,h,l,front,back,right,left)
        for _, p in ipairs(o.parts) do
            if p.colli and band(p.h+0x2800-p.back,0xffff) < 0xf800
                and program.overlap(p,h,l,front,back,right,left) then
                p.damage(p,1)
                return p
            end
        end
    end

    function M.step(o)
        if o.retire then M.close(o); return end
        if not o.run.freeze then o.tick = o.tick+1 end
        o.l = s16(o.l-o.run.cameraStep)
        if not o.dead then damage(o) end
        if not o.run.freeze then
            explosions(o)
            gateStep(o,'bay')
            gateStep(o,'barrel')
            if o.armed then o.picture.deck = (o.picture.deck+1)%8 end
            if not o.dead then phase(o) end
            if o.recoil and o.recoil > 0 then
                local dh,dl = program.vector(o.recoil,o.recoilAngle)
                o.h,o.l,o.recoil = s16(o.h+dh),s16(o.l+dl),o.recoil-1
            end
            move(o)
            position(o)
            emitters.step(o)
        end
        drones.step(o)
    end

    return M
end
