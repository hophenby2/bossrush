-- 0x179792 的母舰在附属机全部失去判定后开放本体耐久。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local floor = math.floor
    local data = program.stage4Fleet
    local M = {parts=11}
    local hullWreck = {
        {0x85,0,0,0,7,0}, {0x85,2,-0x400,0x800,7,0x40}, {0x85,4,-0xe00,0,8,0x80},
        {0x85,6,-0x400,-0x800,7,0xc0}, {0x85,8,0x600,-0xa00,4,0xd0,flip=true},
        {13,10,0x200,0x600,4,0x30}, {0x85,12,-0x1000,0xa00,4,0x50},
        {13,14,-0x1000,-0x600,4,0xb0}, {13,0,-0xc00,0},
    }

    local function stateWord(o, offset, fallback)
        return (o.state[offset] or floor(fallback / 256)) * 256 + (o.state[offset + 1] or band(fallback,255))
    end

    local function aim(o, dh)
        local pilot = o.run.player
        if pilot and pilot.active then return program.angle(o.h + dh,o.l,pilot.h,pilot.l,o.face) end
    end

    function M.damage(o, amount, flags)
        o.flags,o.hp = bor(o.flags,flags),s16(o.hp - amount)
    end

    local function place(o, craft)
        craft.h,craft.l = s16(o.h + craft.mount[1]),s16(o.l + craft.mount[2])
        craft.x,craft.y = world(craft.h,craft.l)
    end

    function M.init(o)
        local run = o.run
        o.flags,o.hp = 0x8000,0x1200
        o.front,o.back,o.right,o.left = 0x1400,0x1000,0x1000,0x1000
        if not path.attach(o) then return false end
        o.mirrored = (o.part[0x1f] or 0) >= 0x80
        o.h,o.l = s16(o.h - 0x1440),s16(o.l + (o.mirrored and 1 or -1) * 0x1d40)
        o.dhMotion,o.dlMotion = s16(stateWord(o,0x18,0x24)),s16(stateWord(o,0x1a,0x34))
        if o.mirrored then o.dlMotion = -o.dlMotion end
        o.palette,o.pose,o.poseClock = 23,3,1
        local clock = stateWord(o,0x26,0x200f)
        o.clock,o.volleyGap = floor(clock / 256),band(clock,255)
        local angles = stateWord(o,0x2a,0x037c)
        o.stepGap,o.startAngle = floor(angles / 256),band(angles,255)
        o.sweep,o.sweepCount,o.muzzleL = 0,band(stateWord(o,0x28,5),255),s16(stateWord(o,0x2c,0xc00))
        if o.mirrored then o.startAngle,o.muzzleL = -o.startAngle,-o.muzzleL end
        program.bossWideRandom(run)
        if o.mirrored then
            -- 原版先申请 11 个连续槽，确定配置后释放末尾 6 个。
            for i = #o.extraParts,5,-1 do
                object.RawDel(o.extraParts[i])
                o.extraParts[i] = nil
            end
            o.parts = 5
        end
        for _, part in ipairs(o.extraParts) do part.flags = 0x8000 end
        o.crafts = {}
        for i = o.mirrored and 6 or 1,o.mirrored and 7 or 5 do
            local craft = o.extraParts[2 * #o.crafts + 1]
            local large = o.mirrored
            o.crafts[#o.crafts + 1] = craft
            craft.mount,craft.big = data.mounts[i],large
            craft.flags,craft.hp,craft.face = 0xa200,large and 0xc0 or 0x38,band(data.mounts[i][3],0xff)
            craft.front,craft.back = large and 0x600 or 0x480,large and 0x6c0 or 0x600
            craft.right,craft.left = large and 0x540 or 0x440,large and 0x540 or 0x440
            craft.palette,craft.flashMask = large and 11 or 10,large and 20 or 21
            craft.basePalette,craft.fireFrame = craft.palette,0
            craft.turnClock,craft.turnGap = 1,band(1 - floor(program.rank(run,0x20,'groundRank') / 16),255)
            craft.attackClock = large and band(0x50 - program.rank(run,0x18,'largeRank'),255)
                or band(0x60 - program.rank(run,0x16,'escortRank') + floor(program.randomEnemy(run) / 2),255)
            craft.burst = 2 + floor(run.difficulty / 2)
            place(o,craft)
        end
        return true
    end

    local function wreckCraft(o, craft)
        craft.flags,craft.wreck = 0x8080,true
        craft.wreckFrame,craft.wreckClock = 3,0
        program.bossSmallRandom(o.run)
        local run = o.run
        run.randomByte = band(run.randomByte + 1,0xff)
        craft.wreckSet = string.byte(data.craftWreckRandom,band(run.randomByte,0x7f) + 1)
    end

    local function fireCraft(o, craft)
        local run = o.run
        local big = craft.big
        craft.attackClock = band((big and 0x18 - program.rank(run,0x20,'groundRank') or 0xa4 - program.rank(run,0x0e,'fireRank')),255)
        if not program.inInterval(craft.l,0,0xc800) or not program.inInterval(craft.h,0x1000,0xa200)
            or program.pilotDistance(craft,run.player) < program.aimDistances[run.difficulty + 1] then return end
        local current = band(craft.face + 2,0x3c)
        if big then
            local target = aim(craft,0x200)
            if craft.burst == 2 + floor(run.difficulty / 2) and (not target or band(target + 2,0x3c) ~= current) then return end
            craft.attackClock = 7
            craft.burst = craft.burst - 1
            if craft.burst < 0 then
                craft.burst,craft.attackClock = 2 + floor(run.difficulty / 2),band(0x40 - program.rank(run,0x1c,'hatchOpenRank'),255)
            end
            if target then current = band(target + 2,0x3c) end
        end
        local shape = big and 0x10 or 0x11
        -- 0x17cb70 按炮塔的 32 个方向选炮口，弹道角度另按 16 个方向取整。
        local index = band(craft.face + 1,0x3e) / 2 + 1
        local at = program.muzzles[shape][index]
        local h,l = program.addPacked(craft.h,craft.l,at[1] + 0x200,at[2])
        bullets.emit(run,big and 12 or 13,run.loop == 0 and 0 or 4,current,h,l)
    end

    local function stepCraft(o, craft)
        place(o,craft)
        if craft.retired then return end
        if craft.wreck then
            craft.wreckClock = craft.wreckClock - 1
            if craft.wreckClock < 0 then craft.wreckClock,craft.wreckFrame = 1,(craft.wreckFrame - 1) % 4 end
            return
        end
        if craft.h >= 0x7000 then
            craft.flags,craft.retired = 0x8080,true
            return
        end
        local flags = band(craft.flags,0x5c00)
        if flags == 0 then craft.palette = craft.basePalette
        else
            craft.flags = band(craft.flags,0xa3ff)
            hyper.hit(craft,flags)
            craft.palette = bxor(craft.palette,craft.flashMask)
            if craft.hp < 0 then
                if craft.burning then
                    hyper.kill(o.run,flags,10)
                    effects.emit(craft,{{craft.big and 4 or 7,0,-0x200,0}})
                    wreckCraft(o,craft)
                    return
                end
                if craft.big then hyper.kill(o.run,flags,8)
                else
                    local pilot = o.run.player
                    if pilot and band(flags,pilot.hitFlags) ~= 0 then pilot.score = pilot.score + 8 end
                end
                craft.hp,craft.burning = craft.big and 0xe0 or 0x70,true
                if craft.big then craft.flags = band(craft.flags,0xfdff) end
                effects.emit(craft,{{3,0,-0x200,0}})
            end
        end
        if craft.burning then craft.fireFrame = (craft.fireFrame + 1) % 4; return end
        if o.run.freeze then return end
        craft.turnClock = craft.turnClock - 1
        if craft.turnClock < 0 then
            craft.turnClock = craft.turnGap
            local target = aim(craft,0x200)
            if not target then return end
            craft.face = program.turn64(craft.face,target)
        end
        craft.attackClock = band(craft.attackClock - 1,255)
        if craft.attackClock == 0 then fireCraft(o,craft) end
    end

    local function bodyFire(o)
        o.clock = o.clock - 1
        if o.clock >= 0 then return end
        o.clock = o.stepGap
        local a = o.startAngle + o.sweep * (o.mirrored and -3 or 3)
        local at = program.mid3.wingMuzzles[band(a + 2,0xfc) / 4 + 1]
        local dh,dl = program.addPacked(0x600,o.muzzleL,at[1],at[2])
        local run = o.run
        -- 0x17984a 把舰体地址交给炮弹槽，离膛前随舰体移动。
        if run.loop == 0 then bullets.emitMounted(o,0x13,0,a,dh,dl)
        else
            bullets.emitMounted(o,0x13,0,a - 8,dh,dl)
            bullets.emitMounted(o,0x13,0,a + 8,dh,dl)
        end
        o.sweep = o.sweep + 1
        if o.sweep == o.sweepCount then
            o.clock,o.sweep = o.volleyGap,0
        end
    end

    function M.step(o)
        local run = o.run
        if not path.step(o,run.groundScroll) then remove(o); return end
        local inside = band(o.l + run.cameraOffset + 0x1c00,0xffff) < 0x7000
            and band(o.h + 0x1a00,0xffff) < 0xa400
        if inside then o.entered = true
        elseif o.entered then remove(o); return end
        if o.dying then
            o.dying = o.dying - 1
            if o.dying < 0 then remove(o) end
            return
        end
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = o.hp < 0x480 and 25 or 23
        else
            o.flags = band(o.flags,0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and 23 or o.palette,8)
            if o.hp < 0 then
                hyper.kill(run,flags,133)
                o.flags,o.dying,o.palette = 0x8080,0x18,23
                for _, craft in ipairs(o.crafts) do craft.flags = 0x8000 end
                effects.emit(o,hullWreck)
                return
            end
        end
        if not run.freeze then
            if o.h >= 0x800 then bodyFire(o) end
            if (o.part[0x1e] or 0) ~= 0 then
                o.poseClock = o.poseClock - 1
                if o.poseClock < 0 then o.poseClock,o.pose = 1,(o.pose - 1) % 4 end
                o.h,o.l = s16(o.h + o.dhMotion),s16(o.l + o.dlMotion)
            end
        end
        local live = false
        for _, craft in ipairs(o.crafts) do
            stepCraft(o,craft)
            if not craft.wreck and not craft.retired then live = true end
        end
        if not live then o.flags = bor(o.flags,0x2000) end
        o.x,o.y = world(o.h,o.l)
    end

    local function draw(o,id,dh,dl,flip)
        local image = o.run.art[id]
        local x,y = world(s16(o.h + dh),s16(o.l + dl))
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2,0,1,flip and -1 or 1)
    end

    function M.render(o)
        if not o.run.art then return end
        draw(o,data.hull[o.palette][o.pose + 1],-0x1a00,-0x1400,o.mirrored)
        if o.dying then return end
        for _, craft in ipairs(o.crafts) do
            if craft.wreck then
                local index = craft.wreckSet * 4 + craft.wreckFrame + 1
                draw(craft,data.wreckedCraft[index][1],-0x600,-0x400)
            else
                local big = craft.big
                local art = data.craft[big and 0x10 or 0x11][craft.palette]
                draw(craft,art[1][band(craft.mount[3],0x3e) + 1],big and -0x800 or -0x600,big and -0x600 or -0x400)
                if craft.burning then draw(craft,data.fire[craft.fireFrame + 1],0x100,-0x200)
                elseif not craft.retired then draw(craft,art[2][band(craft.face + 1,0x3e) / 2 + 1],big and -0x600 or -0x400,
                    big and -0x600 or -0x400) end
            end
        end
    end

    return M
end
