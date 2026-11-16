-- 0x16c038 在地堡上交替推进对生旋转环与镜像扫射。两段均以部件自己的计数切换。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local floor = math.floor
    local data = program.fifthFort
    local M = {parts=4}

    local function tick(o,key,gap)
        o[key] = o[key] - 1
        if o[key] >= 0 then return false end
        o[key] = gap
        return true
    end

    function M.init(o)
        o.flags,o.hp,o.palette,o.health = 0xa000,0x7fff,16,0x1c000
        o.front,o.back,o.right,o.left = 0x1400,0x1400,0x1400,0x1400
        if not path.attach(o) then return false end
        for _, part in ipairs(o.extraParts) do part.flags,part.h,part.l = 0x8000,o.h,o.l end
        o.phase,o.openClock,o.poseClock,o.pose = 0,0x180,3,0
        o.windup,o.frameClock,o.deathClock = 0xc0,0x60,0x60
        o.run.fifthFort = o
        o.run.bulletCapacity = math.max(o.run.bulletCapacity,110)
        return true
    end

    function M.damage(o,amount,flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end

    local function restoreScroll(run)
        run.scrollSpeed[1],run.scrollSpeed[2] = 0x20,0x20
    end

    local function blast(o)
        local wreck = {}
        for i, row in ipairs(data.wreck) do
            wreck[i] = {row[2],row[1],row[4],row[5],floor(row[6] / 256),band(row[6],255),
                flip=band(row[3],0x40) ~= 0}
        end
        effects.emit(o,wreck)
    end

    local function checkDamage(o)
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = 16; return end
        o.flags,o.palette = band(o.flags,0xa3ff),bxor(o.palette,15)
        hyper.hit(o,flags)
        o.health,o.hp = o.health - band(0x7fff - o.hp,0xffff),0x7fff
        if o.health >= 0 then return end
        local run = o.run
        o.dying,o.flags,o.hitFlags = true,0x8000,flags
        hyper.kill(run,flags,1000)
        restoreScroll(run)
        blast(o)
        bullets.clearWithFade(run,flags)
    end

    local function startRing(o)
        o.attack,o.attackClock,o.attackLeft = 2,1,0x258
        o.rotationSpeed = 0x3c
        local start = 0x40 - band(program.bossWideRandom(o.run),31)
        -- 原版先空转 60 次，每次角加速度为 1。
        o.rotationAngle = band(start + 0x3c * 0x3d / 2,255)
    end

    local function ring(o)
        local run = o.run
        if tick(o,'attackClock',4) then
            o.rotationSpeed = band(o.rotationSpeed + 1,255)
            o.rotationAngle = band(o.rotationAngle + o.rotationSpeed,255)
            local h,a = s16(o.h + 0x1000),o.rotationAngle - 0x18
            for i = 0,3 do
                for _, offset in ipairs({0,0x80}) do
                    local angle = a + offset + i * 0xc
                    if run.loop == 0 then bullets.emitPrecise(run,3,5,angle,h,o.l)
                    else
                        bullets.emitPrecise(run,3,5,angle - 8,h,o.l)
                        bullets.emitPrecise(run,3,5,angle + 8,h,o.l)
                    end
                end
            end
        end
        o.attackLeft = o.attackLeft - 1
        if o.attackLeft == 0 then
            local extra = run.loop == 0 and 3 or 2
            o.attack,o.attackLeft,o.alternate = 3,0x258,0
            o.attackClock,o.attackGap = 2 + (run.aimPhase < 2 and extra or 0),2 + extra
            o.rotationAngle = band(program.bossWideRandom(run) - 0x20,255)
        end
    end

    local function sweep(o)
        local run = o.run
        o.rotationAngle = band(o.rotationAngle + 2,255)
        o.attackClock = o.attackClock - 1
        if o.attackClock >= 0 then
            local h = s16(o.h + 0x1000)
            local a = o.rotationAngle
            for _, angle in ipairs({a,-a}) do
                bullets.emitPrecise(run,4,-3,angle,h,o.l)
                if run.loop ~= 0 and o.alternate == 0 then bullets.emitPrecise(run,4,3,angle,h,o.l) end
            end
            if run.loop ~= 0 then o.alternate = 1 - o.alternate end
        elseif o.attackClock <= (band(o.rotationAngle + 0x10,255) <= 0x20 and -2 or -3) then
            o.attackClock = o.attackGap
        end
        o.attackLeft = o.attackLeft - 1
        if o.attackLeft == 0 then startRing(o) end
    end

    function M.step(o)
        local run = o.run
        if run.freeze then return end
        if o.deathClock == 0 then restoreScroll(run); remove(o); return end
        checkDamage(o)
        if o.dying then o.deathClock = o.deathClock - 1 end
        if o.h > -0x3800 then o.entered = true
        elseif o.entered then
            run.fifthFort = nil
            remove(o)
            return
        end
        o.h = s16(o.h - run.groundScroll)
        o.x,o.y = world(o.h,o.l)
        if o.dying then run.fifthFort = nil; return end
        if o.phase == 0 then
            o.openClock = o.openClock - 1
            if o.openClock == 0 then o.phase = 1 end
        end
        if o.phase == 1 and tick(o,'poseClock',3) then
            o.pose = o.pose + 1
            if o.pose == 7 then o.phase,o.attack = 2,1 end
        end
        if o.phase ~= 2 then return end
        if o.attack == 1 then
            o.windup = o.windup - 1
            if o.windup == 0 then startRing(o) end
        end
        if o.attack == 2 then ring(o) end
        if o.attack == 3 then sweep(o) end
    end

    function M.render(o)
        if not o.run.art or o.dying then return end
        local art = o.run.art[data.images[o.palette]]
        local h,l = program.addPacked(o.h,o.l,-0x1c00,-0x1600)
        local x,y = world(h,l)
        Render(art[1],floor(x) + art[2] / 2,floor(y) + art[3] / 2)
    end

    return M
end
