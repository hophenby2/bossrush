-- 0x176268。两处判定盒共享耐久，中央舱门和固定炮各自推进原版计时。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local min, floor = math.min, math.floor
    local s16, world = program.s16, program.world
    local data = program.airframe
    local M = {parts=2}

    local function place(o)
        local part = o.extraParts[1]
        o.x, o.y = world(o.h,o.l)
        part.h, part.l, part.x, part.y = o.h, o.l, o.x, o.y
    end

    function M.init(o)
        local run, part = o.run, o.extraParts[1]
        if run.difficulty == 1 and run.major >= 0x100 and run.major < 0x16c and run.mid2 then return false end
        o.flags, part.flags = 0xa001, 0xa001
        o.hp = run.difficulty == 4 and 0x880 or run.difficulty == 1 and run.major >= 0x80 and 0x680 or 0x980
        part.hp = 0x980
        o.front, o.back, o.right, o.left = 0x800, 0xc00, 0x800, 0x800
        part.front, part.back, part.right, part.left = 0x200, 0x200, 0xc00, 0xc00
        local color = data.palettes[run.stageNumber]
        o.palette, o.basePalette, o.flashMask = color[1], color[1], color[2]
        o.hatch, o.hatchFrame, o.hatchClock = 0, 0, 0
        o.attackClock, o.attackCount = 0x38, 3
        o.fixedClock, o.fixedGap, o.fixedCount = 0x20, band(0x20 - program.rank(run,0x1e,'cannonRank'),0xff), 4
        if not path.attach(o) then return false end
        place(o)
        return true
    end

    local function fixed(o)
        local run = o.run
        if run.loop == 0 and run.difficulty < 3 then return end
        o.fixedClock = o.fixedClock - 1
        if o.fixedClock >= 0 then return end
        o.fixedClock = 5
        local shifts = o.fixedNarrow and {{-0xc00,-0x200},{-0xc00,0x240}} or {{-0xe00,-0x6c0},{-0xe00,0x700}}
        for _, offset in ipairs(shifts) do
            local h,l = s16(o.h + offset[1]), s16(o.l + offset[2])
            bullets.emit(run,7,2,0x20,h,l)
        end
        o.fixedCount = o.fixedCount - 1
        if o.fixedCount < 0 then
            o.fixedNarrow, o.fixedCount, o.fixedClock = not o.fixedNarrow, 4, o.fixedGap
        end
    end

    local function fireHatch(o, pilot)
        local run = o.run
        local h = s16(o.h + data.muzzles[o.attackCount + 1])
        for _, dl in ipairs({0x700,-0x700}) do
            local l = s16(o.l + dl)
            local a = program.angle256(h,l,pilot.h,pilot.l,0x80)
            bullets.emitPrecise(run,11,3,a,h,l)
            if run.loop ~= 0 then
                bullets.emitPrecise(run,11,3,a - 8,h,l)
                bullets.emitPrecise(run,11,3,a + 8,h,l)
            end
            bullets.emitPrecise(run,11,run.loop == 0 and 6 or 10,a + o.attackCount * 2,h,l)
        end
    end

    local function hatch(o)
        local run = o.run
        if o.hatch == 0 or o.hatch == 2 then
            o.attackClock = o.attackClock - 1
            if o.attackClock >= 0 then return end
            if o.hatch == 0 then
                o.hatch, o.attackClock = 1, band(0x10 - program.rank(run,0x20,'tankRank'),0xff)
                return
            end
            o.attackClock = run.difficulty <= 1 and 5 or 2
            if run.player and run.player.active then fireHatch(o,run.player) end
            o.attackCount = o.attackCount - 1
            if o.attackCount < 0 then
                o.hatch, o.attackCount, o.attackClock = 3, 3, band(0x10 - program.rank(run,0x20,'tankRank'),0xff)
            end
            return
        end
        if o.hatch == 3 and o.attackClock > 0 then o.attackClock = o.attackClock - 1; return end
        o.hatchClock = o.hatchClock - 1
        if o.hatchClock >= 0 then return end
        o.hatchClock = 1
        if o.hatch == 1 then
            o.hatchFrame = o.hatchFrame + 1
            if o.hatchFrame == 7 then o.hatch = 2 end
        else
            o.hatchFrame = o.hatchFrame - 1
            if o.hatchFrame == 0 then
                o.hatch, o.attackClock = 0, band((run.difficulty == 4 and 0x40 or 0x30) - program.rank(run,0x1c,'salvoRank'),0xff)
            end
        end
    end

    function M.step(o)
        if not path.step(o) then remove(o); return end
        local run, part = o.run, o.extraParts[1]
        if band(o.h + 0x1000,0xffff) < 0x9000 then o.entered = true
        elseif o.entered then remove(o); return end
        local flags = band(bor(o.flags,part.flags),0x5c00)
        if flags == 0 then
            o.palette = o.hp < 0x260 and 25 or o.basePalette
        else
            o.flags, part.flags = band(o.flags,0xa3ff), band(part.flags,0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and o.basePalette or o.palette,o.flashMask)
            o.hp = min(o.hp,part.hp)
            part.hp = o.hp
            if o.hp < 0 then
                hyper.kill(run,flags,55)
                local angle, speed = o.direction * 4, o.speed
                effects.emit(o,{{13,0,-0xa00,0,speed,angle}})
                if run.difficulty ~= 1 or run.major < 0x150 then
                    effects.emit(o,{{0x84,0,0x400,0,speed,angle}})
                end
                remove(o)
                return
            end
        end
        place(o)
        if o.entered and o.h >= 0x1000 and not run.freeze and run.enemyShotGrace == 0 then
            fixed(o); hatch(o)
        end
    end

    local function draw(o, id, dh, dl)
        local image = o.run.art[id]
        local x,y = world(o.h + dh,o.l + dl)
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    function M.render(o)
        if not o.run.art then return end
        local pose = data.images[o.palette]
        draw(o,pose[1],-0xe00,-0xc00)
        draw(o,pose[2][o.hatchFrame + 1],-0x300,-0x900)
    end

    function M.damage(o, amount, flags)
        o.hp, o.flags = s16(o.hp - amount), bor(o.flags,flags)
    end

    return M
end
