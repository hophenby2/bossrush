-- 五面开场三种回调。舰炮、滑盖炮与增援登记分别推进各自的原版计数。
return function(program, path, bullets, effects, items, remove, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local floor = math.floor
    local data = program.stage5Opening
    local Ship,Sweeper,Reinforcements = {parts=2},{parts=2},{parts=1}
    local turretOffsets = {0xa40,-0xa00}

    local function damage(o,amount,flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end
    Ship.damage,Sweeper.damage = damage,damage

    local function tick(o,key,gap)
        o[key] = o[key] - 1
        if o[key] >= 0 then return false end
        o[key] = gap
        return true
    end

    local function draw(o,id,dh,dl)
        local art = o.run.art[id]
        local x,y = world(s16(o.h + dh),s16(o.l + dl))
        Render(art[1],floor(x) + art[2] / 2,floor(y) + art[3] / 2)
    end

    local function hit(o,threshold)
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = o.hp < threshold and 25 or o.basePalette
        else
            o.flags = band(o.flags,0xa3ff)
            hyper.hit(o,flags)
            o.palette = bxor(o.palette == 25 and o.basePalette or o.palette,o.flashMask)
        end
        return flags
    end

    local function attachPath(o)
        o.extraParts[1].flags = 0x8000
        return path.attach(o)
    end

    local function aim(o,dh,dl,angle,precise)
        local pilot = o.run.player
        if not pilot or not pilot.active then return angle end
        local direction = precise and program.angle256 or program.angle
        return direction(s16(o.h + dh),s16(o.l + dl),pilot.h,pilot.l,angle)
    end

    function Ship.init(o)
        local run = o.run
        o.flags,o.hp,o.front,o.back,o.right,o.left = 0xa001,0x7fff,0xa00,0xc00,0x1000,0x1000
        if not attachPath(o) then return false end
        o.basePalette,o.flashMask = run.stageNumber == 5 and 13 or 17,run.stageNumber == 5 and 18 or 14
        o.palette = o.basePalette
        o.clock,o.arrowClock,o.trackClock = band(0x80 - program.rank(run,0x14,'tankRank'),255),0x30,1
        o.phase,o.pose,o.poseClock,o.centerBursts = 0,0,1,2
        o.arrowBursts,o.protection,o.tracking = 6,4,1
        -- 0x17283a 打开前两组扩展弹槽，避免初段舰队挤掉原本可以发出的弹。
        run.bulletCapacity = math.max(run.bulletCapacity,160)
        o.turrets = {}
        for i, at in ipairs(turretOffsets) do o.turrets[i] = aim(o,0x5c0,at,band(o.direction,63)) end
        return true
    end

    local function split(o,kind,speed,direction,h,l)
        if o.run.loop == 0 then bullets.emitPrecise(o.run,kind,speed,direction,h,l)
        else
            bullets.emitPrecise(o.run,kind,speed,direction - 8,h,l)
            bullets.emitPrecise(o.run,kind,speed,direction + 8,h,l)
        end
    end

    local function shipCenter(o)
        if o.phase == 0 then
            if tick(o,'clock',0x10) then o.phase = 1 end
        elseif o.phase == 1 then
            if tick(o,'poseClock',1) then
                o.pose = o.pose + 1
                if o.pose == 5 then o.phase = 2 end
            end
        elseif o.phase == 2 then
            if tick(o,'poseClock',1) then o.pose = o.pose == 5 and 4 or 5 end
            if not tick(o,'clock',0x10) then return end
            local pilot = o.run.player
            if pilot and pilot.active then
                local a = aim(o,-0x880,0,0x80,true)
                for _, l in ipairs({0x380,-0x380}) do
                    for _, shift in ipairs({10,-10}) do
                        split(o,5,-3,a + shift,s16(o.h - 0x880),s16(o.l + l))
                    end
                end
            end
            o.centerBursts = o.centerBursts - 1
            if o.centerBursts < 0 then
                o.centerBursts,o.clock,o.phase = 2,band(0x40 - program.rank(o.run,0x1a,'largeRank'),255),3
            end
        elseif tick(o,'poseClock',1) then
            o.pose = o.pose - 1
            if o.pose < 0 then o.pose,o.phase = 0,0 end
        end
    end

    local function shipTurrets(o)
        if tick(o,'trackClock',1) and o.arrowBursts == 6 then
            local i = o.tracking
            local a = aim(o,0x5c0,turretOffsets[i],o.turrets[i])
            o.turrets[i],o.tracking = program.turn64(o.turrets[i],a),3 - i
        end
        if o.h < 0x1000 or not tick(o,'arrowClock',8) then return end
        for i, turret in ipairs(o.turrets) do
            local at = program.boss4.turretMuzzles[band(turret,0x3e) / 2 + 1]
            for j = 0,6 do
                local angle = turret * 4 - 0x2d + j * 0xf
                local muzzle = program.shipFan[3][band(angle + 2,0xfc) / 4 + 1]
                local dh,dl = program.addPacked(0x5c0 + at[1],turretOffsets[i] + at[2],muzzle[1],muzzle[2])
                bullets.emitPrecise(o.run,7,4,angle,s16(o.h + dh),s16(o.l + dl))
            end
        end
        o.arrowBursts = o.arrowBursts - 1
        if o.arrowBursts < 0 then o.arrowBursts,o.arrowClock = 6,band(0x80 - program.rank(o.run,0x16,'hatchOpenRank'),255) end
    end

    local shipWreck = {{13,0,0x600,0},{5,0,-0x400,0},{4,0,0x200,0x800},{4,0,0x200,-0xa00},
        {8,0,-0x800,0x600},{8,0,-0x800,-0x800},{4,0,-0x400,0xe00},{4,0,-0x400,-0x1000}}

    function Ship.step(o)
        local run = o.run
        if not path.step(o,run.groundScroll) then remove(o); return end
        if band(o.h + 0xe00,0xffff) < 0x8600 then o.entered = true
        elseif o.entered then remove(o); return end
        if o.protection >= 0 then
            o.hp,o.protection = 0x7fff,o.protection - (run.hyper and 2 or 1)
            if o.protection < 0 then o.hp = 0x2600 end
        end
        local flags = hit(o,0x980)
        if flags ~= 0 and o.hp < 0 then
            hyper.kill(o.run,flags,271)
            effects.emit(o,shipWreck)
            remove(o)
            return
        end
        if not run.freeze then
            if o.h >= 0x1000 then shipCenter(o) end
            shipTurrets(o)
        end
        o.x,o.y = world(o.h,o.l)
    end

    function Ship.render(o)
        if not o.run.art then return end
        local body,turrets,cover = unpack(data.ship[o.palette])
        draw(o,body,-0x1200,-0x1200)
        draw(o,cover[o.pose + 1],-0xc00,-0x500)
        for i, at in ipairs({0x640,-0xe00}) do
            draw(o,turrets[band(o.turrets[i],0x3e) / 2 + 1],-0x40,at)
        end
    end

    function Sweeper.init(o)
        local run = o.run
        o.flags,o.hp,o.front,o.back,o.right,o.left = 0xa000,0xe00,0xa00,0xa00,0x700,0x700
        if not attachPath(o) then return false end
        o.basePalette,o.flashMask,o.palette = 10,21,10
        o.phase,o.clock,o.pose,o.poseClock,o.mainBurst,o.shotSpeed = 0,0x40,0,1,0xb,-2
        o.fanClock,o.fanBurst,o.rotorClock,o.rotor = 0,0x60,1,0
        o.kick,o.coverH = 0,0
        run.stage5Sweepers = (run.stage5Sweepers or 0) + 1
        return true
    end

    local function leaveSweeper(o)
        o.run.stage5Sweepers = o.run.stage5Sweepers - 1
        remove(o)
    end

    local function sweeperMain(o)
        if o.phase == 0 then
            if tick(o,'clock',0x10) then o.phase = 1 end
        elseif o.phase == 1 then
            if tick(o,'poseClock',1) and o.h < 0x6c00 then
                o.pose = o.pose + 1
                if o.pose == 7 then o.phase,o.shotSpeed = 2,-2 end
            end
        elseif o.phase == 2 then
            if not tick(o,'clock',o.run.difficulty <= 1 and 4 or 0) then return end
            local h,a = s16(o.h + 0xa80),aim(o,0xa80,0,0x80,true)
            for _, dl in ipairs({0x400,-0x400}) do
                local direction = a + floor(program.bossRandom(o.run) / 2)
                bullets.emitPrecise(o.run,0x13,o.shotSpeed + (o.run.loop == 0 and 0 or 4),direction,h,s16(o.l + dl))
            end
            o.shotSpeed,o.mainBurst = o.shotSpeed + 1,o.mainBurst - 1
            if o.mainBurst < 0 then o.mainBurst,o.phase,o.clock,o.poseClock = 0xb,3,0x30,0x10 end
        elseif tick(o,'poseClock',1) then
            o.pose = o.pose - 1
            if o.pose == 0 then o.phase = 0 end
        end
    end

    function Sweeper.step(o)
        local run = o.run
        if not path.step(o,run.groundScroll) then leaveSweeper(o); return end
        if band(o.h + 0xc00,0xffff) < 0x8800 then o.entered = true
        elseif o.entered then leaveSweeper(o); return end
        local flags = hit(o,0x380)
        if flags ~= 0 and o.hp < 0 then
            hyper.kill(o.run,flags,130)
            effects.emit(o,{{13,0,0x400,0},{12,0,-0x600,0x600},{0x84,0,-0x600,-0x600}})
            for _, at in ipairs(data.sweeperDrops) do items.emit(o,8,at[1],at[2]) end
            leaveSweeper(o)
            return
        end
        if not run.freeze then
            if o.direction < 0x40 then
                o.kick = band(o.kick + 0x20,0xffff)
                o.coverH = -band(o.kick,0x40)
                if tick(o,'rotorClock',1) then o.rotor = (o.rotor + (o.direction == 0 and 1 or -1)) % 4 end
            end
            if o.h >= 0x1000 and run.enemyShotGrace == 0 then
                sweeperMain(o)
                if tick(o,'fanClock',run.difficulty <= 1 and 4 or 3) then
                    for i = 0,7 do
                        bullets.emitPrecise(run,4,run.loop == 0 and -2 or 2,0x6b + i * 7,s16(o.h - 0x200),o.l)
                    end
                    o.fanBurst = o.fanBurst - 1
                    if o.fanBurst < 0 then o.fanBurst,o.fanClock = 0x60,0x20 end
                end
            end
        end
        o.x,o.y = world(o.h,o.l)
    end

    function Sweeper.render(o)
        if not o.run.art then return end
        local body,rotors,hatch = unpack(data.sweeper[o.palette])
        draw(o,rotors[o.rotor + 1],-0xe00,-0x600)
        draw(o,body,-0xc00 + o.coverH,-0x900)
        draw(o,hatch[o.pose + 1],0x800 + o.coverH,-0x600)
    end

    function Reinforcements.init(o)
        o.flags,o.h,o.l,o.clock = 0x8000,0,0,6
        return true
    end

    function Reinforcements.step(o)
        local run = o.run
        if run.major >= 0x9c then remove(o); return end
        if run.freeze or (run.stage5Sweepers or 0) > 0 or not tick(o,'clock',0) then return end
        -- 0x164026 在通常难度要求路径。这里排队的 0x3f 没有路径，只有最高难度会保留。
        if run.difficulty == 4 then
            local q = run.spawnQueue
            q[#q + 1] = {run.major,0,0x3f,0,0,0x164026,0x1640de}
        end
    end

    function Reinforcements.render() end

    return Ship,Sweeper,Reinforcements
end
