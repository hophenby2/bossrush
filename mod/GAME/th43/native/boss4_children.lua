-- 0x62、0x7a、0x7c/0x7d、0x60/0x7e 和 0x61 的对象分别读取母机发布的坐标与命令。
return function(program, bullets, effects, data)
    local band = require('bit').band
    local floor, min, max = math.floor, math.min, math.max
    local add, s16 = program.add, program.s16
    local M, update = {}, {}
    local offsets = {{0xa80,0x700},{0xa7f,-0x700},{0xa80,0x700},{0xa7f,-0x700}}
    local tetherTargets = {{0x9ff,-0x1180},{0x19ff,-0xa00},{0xa00,0x1180},{0x1a00,0xa00}}
    local orbitSetup = {{8,0x40,1},{0x10,0x80,-2},{0x18,0x40,3},{8,0xc0,1},{0x10,0,-2},{0x18,0xc0,3}}

    local function damage(p, amount)
        p.damagePending = p.damagePending + amount
    end

    local function draw(p, rows, frame, dh, dl, flipped)
        local image = p.run.art.sprites[rows[frame][flipped and 2 or 1]]
        local h, l = add(p.h, p.l, dh, dl)
        Render(image[1], floor(l/64) - 112 + image[2]/2, floor(h/64) - 224 + image[3]/2)
    end

    local Child = Class(object, {
        init = function(p, boss, kind, h, l, index)
            p.host, p.run, p.hitPool, p.kind = boss, boss.run, 1, kind
            p.h, p.l, p.index, p.age = h, l, index, 0
            p.group, p.layer, p.bound, p.colli = GROUP.ENEMY, LAYER.ENEMY + 1, false, false
            p.damage, p.damagePending = damage, 0
            p.hp, p.front, p.back, p.right, p.left = 0x7fff, 0x380, 0x380, 0x200, 0x200
            p.x, p.y = program.world(h, l)
        end,
        render = function(p)
            if p.kind == 0x62 then
                local spread = floor((p.retract or 0) / 2) * 0x100
                draw(p, data.carrier, 1, -0x1780, 0x400+spread)
                draw(p, data.carrier, 1, -0x1780, -0x1000-spread, true)
                draw(p, data.carrier, 2, -0x2000, spread)
                draw(p, data.carrier, 2, -0x2000, -0xc00-spread, true)
            elseif p.kind == 0x7a and p.host.carrierReady then
                draw(p, data.thruster, floor((p.extension or 0)/4)+1, -0xe00, -0x500, p.index % 2 == 0)
            elseif p.kind == 0x7b then
                if p.linkH then
                    for i = 1, 8 do
                        local dh = floor(s16(p.linkH-p.h+0x800)*i/8)-0x800
                        local dl = floor(s16(p.linkL-p.l)*i/8)
                        draw(p,data.tetherLink,1,dh-0x400,dl-0x400,i%2==0)
                    end
                end
                draw(p,data.tether,p.age%8+1,-0x1000,-0x900)
            elseif p.kind == 0x7c or p.kind == 0x7d then
                local flip = p.kind == 0x7d
                draw(p, data.wing, 1, -0x1400, flip and -0x1000 or 0x400, flip)
                draw(p, flip and data.leftWing or data.rightWing, 1, -0x1400, flip and -0x400 or 0)
            elseif p.kind == 0x61 then
                draw(p, data.orbit, floor(p.age/2)%8+1, -0x300, -0x300)
            elseif p.kind == 0x60 or p.kind == 0x7e then
                draw(p, data.nozzle, floor(p.age/2)%16+1, -0x800, -0x500)
            end
        end,
    })

    local function spawn(o, kind, h, l, index)
        for i = 1, 48 do
            if not o.children[i] then
                local p = New(Child, o, kind, h, l, index or 1)
                o.children[i] = p
                return p
            end
        end
    end

    local function aim(p, h, l)
        return p.run.pilotH and program.aimByte(h, l, p.run.pilotH, p.run.pilotL, 0x80) or 0x80
    end

    local function signedRandom(run)
        local n = program.random(run, program.effectRandom)
        return n < 128 and n or n - 256
    end

    local function fly(p, speed, a, scroll)
        local dh, dl = program.vector(speed, a)
        p.h = s16(p.h + dh)
        p.l = s16(p.l + dl - (scroll and p.run.cameraStep or 0))
    end

    local function attachTethers(o, parent, count)
        for i = 1, count do
            local p = spawn(o,0x7b,parent.h,parent.l,i)
            p.parent, p.speed = parent, 8
        end
    end

    function M.carrier(o)
        local p = spawn(o, 0x62, s16(0xa400), 0x1c00)
        p.retract, p.state = 0x20, 0
        attachTethers(o,p,4)
    end

    update[0x62] = function(p, o)
        -- 0x12480c 贴近机身后才依次收装四块机组，最后用场消隐位推进撤离。
        if p.state == 0 then
            local h, l = add(o.h, o.l, 0x400, 0)
            local d = program.distance(p.h, p.l, h, l)
            fly(p, 0x20, 4 * program.angle(p.h, p.l, h, l), false)
            if d <= 0x100 then p.state, p.clock = 1, 0x25 end
        elseif p.state == 1 then
            p.h, p.l = o.h, o.l
            p.clock = p.clock - 1
            if p.clock == 0 then p.state = 2 end
        elseif band(p.run.frame, 1) == 0 then
            p.retract = p.retract - 1
            if p.retract == 0 then o.carrierReady = true; return true end
        end
    end

    -- 0x123ca4 在载体展开时追随锚点，解锁后牵引端独立按加速度和反转推进。
    update[0x7b] = function(p)
        local parent = p.parent
        if not p.detached then
            local valid = IsValid(parent)
            local ph,pl = p.linkH or p.h,p.linkL or p.l
            if valid then ph,pl=parent.h,parent.l end
            local dh,dl = unpack(tetherTargets[p.index])
            local h,l = add(ph,pl,dh,dl)
            p.linkH,p.linkL = ph,pl
            local distance = program.distance(p.h,p.l,h,l)
            local speed = min(0x1c, floor(distance/96))
            fly(p,speed,4*program.angle(p.h,p.l,h,l),false)
            local elapsed = valid and (parent.kind == 0x62 and parent.state == 2
                or parent.kind ~= 0x62 and parent.state == 1 and parent.clock < 0x10)
            if elapsed or not valid then
                p.detached,p.velocityH,p.velocityL = true,0,0
                local vh,vl = program.vector(1,4*program.angle(ph,pl,p.h-0x1000,p.l))
                p.pullH,p.pullL = floor(vh/2),vl
                p.angle = floor(signedRandom(p.run)/2)*4
                p.speed = 0
            end
        else
            p.velocityH,p.velocityL = s16(p.velocityH+p.pullH),s16(p.velocityL+p.pullL)
            p.linkH,p.linkL = s16(p.linkH+p.velocityH),s16(p.linkL+p.velocityL-p.run.cameraStep)
            if (p.linkH >= p.h-0x1000) == (p.pullH > 0) then p.pullH=-p.pullH end
            if (p.linkL >= p.l) == (p.pullL > 0) then p.pullL=-p.pullL end
            if p.age % 2 == 0 then p.speed = band(p.speed+1,0xff) end
            fly(p,p.speed,p.angle,false)
            if band(p.h+0x1400,0xffff) >= 0x9800
                or band(p.l+p.run.cameraOffset+0x1200,0xffff) >= 0x5c00 then return true end
        end
    end

    function M.thrusters(o)
        for i, offset in ipairs(offsets) do
            local h, l = add(o.h, o.l, unpack(offset))
            local p = spawn(o, 0x7a, h, l, i)
            p.extension, p.command, p.clock = 0, 0, 0
            p.front, p.back, p.right, p.left = 0xa00, 0xa00, 0x600, 0x600
            p.bodyContact = false
        end
    end

    update[0x7a] = function(p, o)
        if o.phase > 0 or o.locked and o.active then
            effects.spawn(o.run,p.h,p.l,{{0,0x88,0,-0x800,0,0,0},{0,0xb,0,0x800,0,0,0}},false,true)
            return true
        end
        local run, command = o.run, o.childCommand
        local dh, dl = unpack(offsets[p.index])
        p.h, p.l = add(o.h, o.l, dh, dl)
        p.colli = o.carrierReady
        if p.command ~= command then
            p.command, p.clock = command, ({[1]=0x14,[2]=1,[3]=0x18,[4]=2})[command] or 0
            p.opened = false
        end
        if command == 0 then return end
        if command == 2 then
            if p.age % 2 == 0 then p.extension = max(0, p.extension - 4) end
            return
        end
        if not p.opened and p.age % 2 == 0 then
            p.extension = min(0x1c, p.extension + 4)
            p.opened = p.extension == 0x1c
        end
        if not p.opened or not run.pilotH then return end
        p.clock = p.clock - 1
        if p.clock >= 0 then return end
        local h, l = add(p.h, p.l, -0x580, 0)
        if command == 1 then
            p.clock = ({0x20,0x18,0x10,0x10})[run.difficulty+1]
            local a = aim(p, h, l) + floor(signedRandom(run)/4)
            bullets.emitLongPair(run, 0xb, 4, a, h, l)
            bullets.emitLongPair(run, 0xb, 4, a + 1, h, l)
        elseif command == 3 then
            p.clock = 0x18
            bullets.emitFasterInLoop(run, 0xb, 8, 0x80, h, l)
            bullets.emitFasterInLoop(run, 0xb, 8, 0xa0, h, l)
        else
            p.clock = ({8,2,2,1})[run.difficulty+1]
            local a = 0x80 + 2 * signedRandom(run)
            local motion = {0x18,1,1,0x7f}
            bullets.emitSpread(run, 0x25, -20, a, h, l, nil, nil, motion)
        end
    end

    function M.wing(o, side)
        local l = side == 1 and 0x2a00 or 0xe00
        local p = spawn(o, side == 1 and 0x7c or 0x7d, 0x7e00, l, side)
        p.state, p.clock = 0, 0
        attachTethers(o,p,2)
    end

    for _, kind in ipairs({0x7c,0x7d}) do
        update[kind] = function(p, o)
            if p.state == 0 then
                local d = program.distance(p.h, p.l, o.h, o.l)
                fly(p, p.index == 1 and 0x18 or 0x20, 4 * program.angle(p.h, p.l, o.h, o.l), false)
                if d <= 0x80 then p.state, p.clock = 1, 0x10 + 0x18 end
            else
                p.h, p.l = o.h, o.l
                p.clock = p.clock - 1
                if p.clock <= 0 then o.wingReady[p.index] = true; return true end
            end
        end
    end

    function M.shell(o, h, l, angle, pattern)
        local p = spawn(o, 0x60, h, l)
        if p then
            p.angle, p.pattern, p.hp = angle, pattern, 0x7fff
            p.front, p.back, p.right, p.left = 0x400, 0x400, 0x280, 0x280
            p.clock, p.spread = pattern == 0 and 1 or 0, 0x82
        end
    end

    update[0x60] = function(p,o)
        if o.phase == 2 or o.dead then
            effects.spawn(p.run,p.h,p.l,{{0,0x8b,0,0,0,0,0}},false,true)
            return true
        end
        fly(p, 0x30, p.angle, true)
        p.colli = true
        if band(p.h+0x800,0xffff) < 0x8000 and band(p.l + p.run.cameraOffset+0x1c00,0xffff) < 0x7000 then
            p.onScreen = true
        elseif p.onScreen then return true end
        p.clock = p.clock - 1
        if p.clock >= 0 then return end
        p.clock = p.pattern == 0 and 0x15 or 0x10
        if p.h <= 0x1800 then return end
        local a = p.angle+0x80
        if p.pattern == 0 then
            bullets.emitFasterInLoop(p.run,0xb,-1,a-p.spread,p.h,p.l)
            bullets.emitFasterInLoop(p.run,0xb,-1,a+p.spread,p.h,p.l)
        else
            bullets.emitWidePair(p.run,0xc,-3,a-p.spread,p.h,p.l)
            bullets.emitWidePair(p.run,0xc,-3,a+p.spread,p.h,p.l)
        end
        p.spread = band(p.spread+(p.pattern == 0 and 2 or 8),0xff)
    end

    function M.wingPulse(o, interval)
        local p = spawn(o, 0x7e, s16(o.h + 0x1400), o.l)
        p.interval, p.clock, p.spread, p.hp = interval, 0, interval, 0x7fff
        o.pulseDone = false
    end

    update[0x7e] = function(p, o)
        fly(p, 0x20, 0, true)
        if p.h >= 0x7400 or p.h < 0 then o.pulseDone = true; return true end
        if p.age <= 15 or not p.run.pilotH then return end
        p.clock = p.clock - 1
        if p.clock >= 0 then return end
        p.clock = p.interval
        local a = aim(p, p.h, p.l) + band(program.random(p.run, program.randomSign), 7) - 4
        bullets.emitSpread(p.run, 0xb, 0, a, p.h, p.l)
        for i = 1, 4 do bullets.emitAngle(p.run, 0xb, 0, a+i*p.spread, p.h, p.l) end
        for i = 1, 4 do bullets.emitAngle(p.run, 0xb, 0, a-i*p.spread, p.h, p.l) end
    end

    function M.orbits(o)
        o.orbitsReady, o.orbitsTurn, o.orbitCount = false, false, 0
        for i, row in ipairs(orbitSetup) do
            local p = spawn(o, 0x61, o.h, o.l, i)
            p.radius, p.angle, p.turn = unpack(row)
            p.hp, p.arrived = 0x7fff, false
            p.stageClock = ({0x500,0x100,0x180,0x80})[o.run.difficulty+1]
            p.trigger, p.fireClock = 0,p.stageClock
            p.volley = {3,2,1}
        end
    end

    update[0x61] = function(p, o)
        if o.dead then return true end
        if o.orbitsTurn then p.angle = band(p.angle + p.turn, 0xff) end
        local dh, dl = program.vector(p.radius, p.angle)
        local h, l = add(o.h, o.l, dh * 16, dl * 16)
        local distance = program.distance(p.h, p.l, h, l)
        local speed = 0x2e
        for _, row in ipairs(data.orbitSpeed) do
            if distance <= row[1] then speed=row[2];break end
        end
        fly(p, speed, 4 * program.angle(p.h, p.l, h, l), false)
        if not p.arrived and speed <= 1 then
            p.arrived, o.orbitCount = true, o.orbitCount + 1
            if o.orbitCount == #orbitSetup then o.orbitsReady = true end
        end
        if o.orbitsReady and p.arrived then
            if not p.run.pilotH then p.trigger,p.fireClock=0,p.stageClock;return end
            p.fireClock = p.fireClock - 1
            if p.fireClock < 0 then p.fireClock,p.trigger=p.stageClock,min(2,p.trigger+1) end
            if (p.index-1)%3 ~= p.trigger then return end
            local n = p.trigger+1
            p.volley[n] = p.volley[n]-1
            if p.volley[n] < 0 then
                p.volley[n] = 0
                local a = p.angle + ({0,-0x20,-0x40})[n]
                local speed = ({8,14,18})[n]
                if p.run.route.loop == 1 then speed=speed-1 end
                bullets.emitMotion(p.run,0x2f,speed,a,p.h,p.l)
            end
        end
    end

    function M.step(o)
        for i = 1, 48 do
            local p = o.children[i]
            if p then
                if p.kind ~= 0x7a then p.hp = p.hp - p.damagePending end
                p.damagePending = 0
                local broken = p.hp < 0
                if broken or update[p.kind](p, o) then
                    if broken then
                        effects.spawn(o.run, p.h, p.l, {{0,0x8b,0,0,0,0,0}}, false, true)
                        if p.kind == 0x61 and not p.arrived then
                            o.orbitCount = o.orbitCount + 1
                            if o.orbitCount == #orbitSetup then o.orbitsReady = true end
                        end
                    end
                    o.children[i] = nil
                    object.RawDel(p)
                else
                    p.age = p.age + 1
                    p.x, p.y = program.world(p.h, p.l)
                end
            end
        end
    end

    function M.close(o)
        for i, p in pairs(o.children) do
            if IsValid(p) then object.RawDel(p) end
            o.children[i] = nil
        end
    end

    return M
end
