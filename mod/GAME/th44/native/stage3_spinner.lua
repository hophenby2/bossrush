-- 0x163710 每次更新先计算四座炮的位置，发射方向和半径相互独立。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local floor = math.floor
    local data = program.stage3Spinner
    local M = {parts=1}

    function M.init(o)
        local run = o.run
        o.flags,o.hp = 0xa000,0x7fff
        o.front,o.back,o.right,o.left = 0x1180,0x1400,0xe00,0xe00
        o.protection,o.palette,o.spinFrame = 0xc0,18,0
        o.orbit,o.angle,o.volleyClock,o.burstClock,o.rounds = 0,0,0x40,0,0x20
        o.burstGap = 4
        o.mounts = {{},{},{},{}}
        if not path.attach(o) then return false end
        o.entry = run.major
        if o.entry == 0x48 or o.entry == 0x8d or o.entry == 0xac then
            o.h,o.l = s16(o.h + 0x900),s16(o.l - 0x100)
            run.spinnerGate[o.entry] = true
            if o.entry == 0x48 then run.spinnerGate[0x8d],run.spinnerGate[0xac] = true,true end
        end
        run.bulletCapacity = math.max(run.bulletCapacity,110)
        o.rotation = program.bossWideRandom(run) >= 0x80 and 2 or -2
        return true
    end

    function M.damage(o, amount, flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end

    local function leave(o)
        o.run.spinnerGate[o.entry] = nil
        remove(o)
    end

    local function fire(o)
        local run = o.run
        if o.rounds == 0 then
            o.volleyClock = o.volleyClock - 1
            if o.volleyClock >= 0 then return end
            o.volleyClock,o.rounds = 0xc,0x20
            o.burstGap = program.rank(run,0x02,'rawRank') >= 0xe0 and 2 or program.rank(run,0x02,'rawRank') >= 0xc0 and 3 or 4
        end
        o.burstClock = o.burstClock - 1
        if o.burstClock >= 0 then return end
        o.burstClock = o.burstGap
        if o.h <= 0x1800 then return end
        local angle = o.angle
        local delta = o.rotation < 0 and -0x40 or 0x40
        for _, mount in ipairs(o.mounts) do
            local h,l = s16(o.h + mount[1]),s16(o.l + mount[2])
            if run.loop == 0 then
                bullets.emitPrecise(run,4,2,angle,h,l)
                bullets.emitPrecise(run,4,0,angle + delta,h,l)
            else
                bullets.emitPrecise(run,4,4,angle,h,l)
                bullets.emitPrecise(run,4,2,angle + delta - 8,h,l)
                bullets.emitPrecise(run,4,2,angle + delta + 8,h,l)
            end
            angle = angle + delta
        end
        o.rounds = o.rounds - 1
    end

    function M.step(o)
        if o.h >= -0x2200 then o.entered = true
        elseif o.entered then leave(o); return end
        local run = o.run
        o.h = s16(o.h - run.groundScroll)
        if o.protection >= 0 then
            o.protection = o.protection - (run.hyper and 2 or 1)
            o.hp = o.protection < 0 and 0x1c00 or 0x7fff
        end
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = 18
        else
            o.flags,o.palette = band(o.flags,0xa3ff),bxor(o.palette,13)
            hyper.hit(o,flags)
            if o.hp < 0 then
                hyper.kill(run,flags,632)
                for _, cmd in ipairs(data.wreck) do
                    effects.emit(o,{{cmd[2],cmd[1],cmd[4],cmd[5],scrolls=true}})
                end
                leave(o)
                return
            end
        end
        o.orbit,o.angle = band(o.orbit + 1,0xff),band(o.angle + o.rotation,0xff)
        for i, mount in ipairs(o.mounts) do
            local h,l = program.vector(0x40,o.orbit + (i - 1) * 0x40)
            mount[1],mount[2] = h * 4 + 0x400,l * 4
        end
        fire(o)
        o.spinFrame = (o.spinFrame + 1) % 16
        o.x,o.y = world(o.h,o.l)
    end

    function M.render(o)
        if not o.run.art then return end
        local art,images = o.run.art,data.images[o.palette]
        local function draw(id, dh, dl)
            local image = art[id]
            local x,y = world(s16(o.h + dh),s16(o.l + dl))
            Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
        end
        draw(images[1][o.spinFrame + 1],-0x2200,-0x1500)
        for _, mount in ipairs(o.mounts) do
            if mount[1] then draw(images[2],mount[1] - 0x400,mount[2] - 0x300) end
        end
    end

    return M
end
