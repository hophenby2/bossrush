-- 0x16ea8a 至 0x16f4ce 是独立敌机槽。炮口先释放滑行件，滑行件再登记弹体与可打掉的子机。
return function(program, bullets, effects, remove, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local floor,min = math.floor,math.min
    local data = program.mid5b
    local Small,SmallShot,Large,LargeShot,Pod,Seeker =
        {parts=1},{parts=1},{parts=1},{parts=1},{parts=1},{parts=1}

    local function queue(o,kind,h,l)
        local run = o.run
        local q,entry = run.spawnQueue,program.actorCallbacks[kind]
        q[#q + 1] = {run.major,0,kind,0,0,entry[1],entry[2],h=h,l=l}
    end

    local function set(o,flags,front,back,width,hp,speed,angle)
        o.h,o.l,o.flags,o.hp = o.row.h,o.row.l,flags,hp
        o.front,o.back,o.right,o.left = front,back,width,width
        o.speed,o.angle = speed,angle
    end

    local function place(o)
        o.x,o.y = world(o.h,o.l)
    end

    local function move(o,speed,angle)
        local dh,dl = program.vector(speed,angle * 4)
        o.h,o.l = s16(o.h + dh),s16(o.l + dl)
    end

    local function damage(o,amount,flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end
    Small.damage,SmallShot.damage,Large.damage,LargeShot.damage,Pod.damage,Seeker.damage =
        damage,damage,damage,damage,damage,damage

    local function visible(o)
        return band(o.l + o.run.cameraOffset + 0x1c00,0xffff) < 0x7000
            and band(o.h + 0x800,0xffff) < 0x8000
    end

    local function draw(o,id,dh,dl,flip)
        if not o.run.art then return end
        local art = o.run.art[id]
        local h,l = program.addPacked(o.h,o.l,dh,dl)
        local x,y = world(h,l)
        Render(art[1],floor(x) + (flip and -1 or 1) * art[2] / 2,floor(y) + art[3] / 2,0,flip and -1 or 1)
    end

    function Small.init(o)
        set(o,0x8001,0x600,0x600,0x180,0x7fff,0xa,0x20)
        o.clock,o.offset = 0x28,o.row.arg
        return true
    end

    function Small.step(o)
        move(o,o.speed,o.angle)
        o.clock = o.clock - 1
        if o.clock == 0 then
            queue(o,0x4f,o.h,o.l)
            queue(o,0x4f,s16(o.h + 0xa00),s16(o.l + o.offset))
            remove(o)
        else place(o) end
    end

    function Small.render(o) draw(o,data.images[18][4],-0x600,-0x100) end

    function Large.init(o)
        set(o,0x8001,0x800,0x800,0x200,0x7fff,8,0x20)
        o.clock = 0x30
        return true
    end

    function Large.step(o)
        if not o.run.fifthMid2Projectiles then
            effects.emit(o,{{4,0,0,0}})
            remove(o)
            return
        end
        move(o,o.speed,o.angle)
        o.clock = o.clock - 1
        if o.clock == 0 then
            queue(o,0x51,o.h,o.l)
            remove(o)
        else place(o) end
    end

    function Large.render(o) draw(o,data.images[18][5],-0xa00,-0x200) end

    function SmallShot.init(o)
        set(o,0x8001,0x400,0x400,0x280,0x7fff,0x10,0)
        o.pose,o.poseClock = 1,1
        return true
    end

    function LargeShot.init(o)
        set(o,0x8000,0x400,0x400,0x400,0x7fff,0x18,0)
        o.pose,o.poseClock = 1,1
        return true
    end

    local function shotStep(o,large)
        local run = o.run
        if not large and not run.fifthMid2Projectiles then
            effects.emit(o,{{4,0,0,0}})
            remove(o)
            return
        end
        if visible(o) then o.entered = true
        elseif o.entered then remove(o); return end
        move(o,o.speed,o.angle)
        if not o.released then
            o.speed = o.speed - 1
            if o.speed == 0 then o.released,o.angle,o.flags = true,0x20,0x8001 end
        elseif large then
            o.speed = min(run.loop == 0 and 0x1c or 0x3c,o.speed + (run.loop == 0 and 1 or 4))
        else
            o.speed = band(o.speed + (run.loop == 0 and 1 or 2),255)
        end
        o.poseClock = o.poseClock - 1
        if o.poseClock < 0 then
            o.poseClock,o.pose = 1,o.pose + 1
            if o.pose == (large and 15 or 12) then o.pose = large and 11 or 6 end
        end
        place(o)
    end

    function SmallShot.step(o) shotStep(o,false) end
    function LargeShot.step(o) shotStep(o,true) end
    function SmallShot.render(o) draw(o,data.small[20][o.pose],-0x600,-0x400) end
    function LargeShot.render(o) draw(o,data.large[20][o.pose],-0xa00,-0x600) end

    local function podHit(o)
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = 19; return false end
        o.flags,o.palette = band(o.flags,0xa3ff),bxor(o.palette,12)
        hyper.hit(o,flags)
        return o.hp < 0
    end

    local function endPod(o)
        effects.emit(o,{{0x14,0,0,0}})
        remove(o)
    end

    function Pod.init(o)
        set(o,0xa001,0x200,0x200,0x200,0x200,0x20,o.row.arg)
        o.phase,o.arming,o.pose,o.life,o.palette = 0,true,0,0x1e0,19
        return true
    end

    function Pod.step(o)
        local run = o.run
        if not run.freeze then move(o,o.speed,o.angle) end
        o.life = o.life - 1
        if o.life == 0 or not run.fifthMid2 or podHit(o) then endPod(o); return end
        local even = run.aimPhase % 2 == 0
        if o.arming then
            if not o.bounced then
                -- 原程序依次检查左右边缘和纵向下限，一次更新可以撞到两个条件。
                for _, edge in ipairs({o.l < 0,o.l > 0x3800,o.h < 0x3200}) do
                    if edge then o.angle,o.bounced = band(o.angle + 0x20,63),true end
                end
            end
            o.speed = o.speed - 1
            if o.speed == 8 then o.arming,o.phase,o.pose = false,2,0 end
        end
        if o.phase == 0 and even then
            o.pose = o.pose + 1
            if o.pose == 3 then o.phase,o.pose,o.clock = 1,0,8 end
        end
        if o.phase == 1 then
            if o.clock == 0 then o.phase,o.pose = -1,0
            elseif even then o.clock,o.pose = o.clock - 1,o.pose % 2 + 1 end
        end
        if o.phase == 2 then
            local pilot = run.player
            if pilot and pilot.active then
                local a = program.angle(o.h,o.l,pilot.h,pilot.l,o.angle)
                o.angle = program.turn64(o.angle,a)
                if o.angle == a then o.phase,o.clock,o.shots = 3,0x10,4 end
            else o.phase,o.clock,o.shots,o.empty = 3,0x10,4,true end
        end
        if o.phase == 3 then
            if o.clock > 0 then o.clock = o.clock - 1
            elseif o.shots == 0 then
                o.phase,o.clock,o.target,o.empty = 4,0x10,band(o.angle + program.bossRandom(run),63),false
            elseif o.empty or (run.frame - 1) % 8 == 0 then
                if not o.empty then
                    for _, a in ipairs({o.angle + 1,o.angle - 1}) do
                        bullets.emit(run,7,run.loop == 0 and 8 or 12,a,o.h,o.l)
                    end
                    move(o,0x30,o.angle + 0x1f)
                end
                o.shots = o.shots - 1
            end
        end
        if o.phase == 4 then
            if o.clock > 0 then o.clock = o.clock - 1
            else
                o.angle = program.turn64(o.angle,o.target)
                if o.angle == o.target then o.phase,o.clock = 5,0x10 end
            end
        end
        if o.phase == 5 then
            o.clock = o.clock - 1
            if o.clock == 0 then
                o.phase,o.arming,o.bounced,o.speed = 0,true,false,0x20 + band(program.bossWideRandom(run),7)
            end
        end
        place(o)
    end

    function Pod.render(o)
        if o.phase == 0 or o.phase == 1 then
            local row = data.spin[o.palette][band(o.angle,0x3e) / 2 + 1]
            draw(o,row[o.pose + 1],-0x600,-0x400,band(row[4],0x40) ~= 0)
        else
            draw(o,data.mine[o.palette][band(o.angle,0xe) / 2 + 1],-0x600,-0x400)
        end
    end

    function Seeker.init(o)
        set(o,0xa001,0x200,0x200,0x200,0x200,0xc,o.row.arg)
        o.dh,o.dl = program.vector(o.speed,o.angle * 4)
        local pilot = o.run.player
        o.fireAngle = pilot and pilot.active and program.angle(o.h,o.l,pilot.h,pilot.l,0x20) or 0x20
        o.pose,o.clock,o.shots,o.palette = 1,0x10,8,19
        return true
    end

    function Seeker.step(o)
        local run = o.run
        if o.h <= -0x400 then remove(o); return end
        o.h,o.l = program.addPacked(o.h,o.l,o.dh,o.dl)
        o.dh = s16(o.dh - 2)
        if not run.fifthMid2 or podHit(o) then endPod(o); return end
        if run.aimPhase == 0 then o.pose = o.pose % 8 + 1 end
        if o.shots > 0 then
            o.clock = o.clock - 1
            if o.clock < 0 then
                o.clock,o.shots,o.fireAngle = 3,o.shots - 1,band(o.fireAngle + 3,63)
                for i = 0,2 do
                    local a = band(o.fireAngle + i * 0x15,63)
                    if a > 0xc and a < 0x34 then bullets.emit(run,7,run.loop == 0 and -4 or 0,a,o.h,o.l) end
                end
            end
        end
        place(o)
    end

    function Seeker.render(o) draw(o,data.mine[o.palette][o.pose],-0x600,-0x400) end

    return {[0x16ea8a]=Small,[0x16eb4e]=SmallShot,[0x16ecae]=Large,[0x16ed7e]=LargeShot,
        [0x16eefc]=Pod,[0x16f4ce]=Seeker}
end
