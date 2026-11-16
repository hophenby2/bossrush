-- 0x165c86 在旋转炮所在区段生成护卫机。0x164368 更新中 Boss 背后的两块滚动精灵。
return function(program, path, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band, bor, bxor = bit.band, bit.bor, bit.bxor
    local s16, world = program.s16, program.world
    local floor = math.floor
    local data = program.stage3Escort
    local E, B = {parts=1}, {parts=2}

    local function draw(o, id, dh, dl)
        local image = o.run.art[id]
        local x,y = world(s16(o.h + dh),s16(o.l + dl))
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    function E.init(o)
        local run = o.run
        o.flags,o.hp = 0xa200,0x60
        o.front,o.back,o.right,o.left = 0x480,0x600,0x440,0x440
        o.fireClock = band(0xc0 - program.rank(run,0x16,'escortRank') + floor(program.randomEnemy(run) / 2),0xff)
        o.trackClock = band(1 - floor(program.rank(run,0x20,'groundRank') / 16),0xff)
        o.basePalette,o.flashMask = unpack(data.palettes[run.stageNumber])
        o.palette,o.flame = o.basePalette,0
        if not path.attach(o) then return false end
        local h, major = o.h,run.major
        if major >= 0xac then
            if h < 0x6400 and not run.spinnerGate[0xac] then return false end
        elseif major >= 0x8d then
            if h > -0x3c00 and h < 0x6400 and not run.spinnerGate[0x8d] then return false end
        elseif major >= 0x48 and not run.spinnerGate[0x48] then return false end
        o.face = band(o.direction,0x3f)
        return true
    end

    function E.damage(o, amount, flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end

    function E.step(o)
        local run = o.run
        if not path.step(o) then remove(o); return end
        local inside = band(o.h + 0x600,0xffff) < 0x7c00
            and band(o.l + 0xc00 + run.cameraOffset,0xffff) < 0x5000
        if inside then o.entered = true
        elseif o.entered then remove(o); return end
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = o.basePalette
        else
            o.palette,o.flags = bxor(o.palette,o.flashMask),band(o.flags,0xa3ff)
            hyper.hit(o,flags)
            if o.hp < 0 then
                if o.broken then
                    hyper.kill(run,flags,10)
                    effects.emit(o,{{7,0,-0x200,0,scrolls=true}})
                    remove(o)
                    return
                end
                local player = run.player
                if player and band(flags,player.hitFlags) ~= 0 then player.score = player.score + 8 end
                o.hp,o.broken = 0xc0,true
                effects.emit(o,{{3,0,-0x200,0,scrolls=true}})
            end
        end
        if o.broken then o.flame = (o.flame + 1) % 4
        elseif not run.freeze then
            local player = run.player
            o.trackClock = o.trackClock - 1
            if o.trackClock < 0 then
                o.trackClock = 1
                if player and player.active then
                    o.face = program.turn64(o.face,program.angle(o.h + 0x200,o.l,player.h,player.l,o.face))
                else return end
            end
            o.fireClock = band(o.fireClock - 1,0xff)
            if o.fireClock == 0 then
                o.fireClock = band(0xa4 - program.rank(run,0x0e,'escortRank'),0xff)
                if band(o.flags,0x2000) ~= 0 and program.inAimBounds(run,o.h,o.l) then
                    local a = band(o.face + 2,0x3c)
                    local at = program.muzzles[0x11][a / 4 + 1]
                    local h,l = program.addPacked(o.h,o.l,at[1] + 0x200,at[2])
                    bullets.emit(run,13,run.loop == 0 and 2 or 6,a,h,l)
                end
            end
        end
        o.x,o.y = world(o.h,o.l)
    end

    function E.render(o)
        if not o.run.art then return end
        local art = data.images[o.palette]
        local direction = band(o.direction,0x3e)
        local lit = band(o.direction,0x40) == 0 and band(o.run.frame,4) ~= 0
        draw(o,art[1][direction + (lit and 2 or 1)],-0x600,-0x400)
        if not o.broken then draw(o,art[2][band(o.face + 1,0x3e) / 2 + 1],-0x400,-0x400)
        elseif band(o.run.frame,1) == 0 then draw(o,data.flame[o.flame + 1],0x100,-0x200) end
    end

    function B.init(o)
        o.group,o.layer = GROUP.GHOST,LAYER.BG + 0.1
        o.h,o.l,o.flags = 0x7000,-0x800 - o.run.cameraOffset,0x8000
        o.extraParts[1].flags = 0x8000
        o.rows = {{h=o.h, image=1}, {h=o.h}}
        o.offset,o.activeRow,o.sequence,o.trailing = 0,2,1,2
        return true
    end

    function B.step(o)
        local run = o.run
        if run.major == 0x118 then remove(o); return end
        if run.freeze then return end
        local dh = program.vector(0x40,0x80)
        for _, row in ipairs(o.rows) do row.h = s16(row.h + dh) end
        o.offset = o.offset + dh
        if o.offset > -0x7000 then return end
        o.offset = o.offset + 0x7000
        local row = o.rows[o.activeRow]
        row.h,row.image = 0x7000 + o.offset,o.sequence
        if o.sequence == 1 and not run.mid3Backdrop then
            o.trailing = math.max(0,o.trailing - 1)
        end
        if o.trailing == 0 then row.image = nil end
        o.activeRow,o.sequence = 3 - o.activeRow,o.sequence % 4 + 1
    end

    function B.render(o)
        if not o.run.art then return end
        for _, row in ipairs(o.rows) do
            if row.image then
                local image = o.run.art[program.mid3.backdrop[row.image]]
                local x,y = world(row.h,o.l)
                Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
            end
        end
    end

    return E,B
end
