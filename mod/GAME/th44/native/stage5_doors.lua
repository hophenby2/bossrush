-- 五面卷轴 0xd0 起的地炮与方形舱门，后者排队升起浮台 0x55。
return function(program, path, bullets, effects, items, remove, hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local floor = math.floor
    local data = program.stage5Doors
    local Gun,Hatch,Platform = {parts=1},{parts=1},{parts=1}
    local hatchClocks = {[0xe6]=0x60,[0xe4]=0xf0,[0x108]=0x40,[0x106]=0xf0,[0x116]=0x80}

    local function tick(o,key,gap)
        o[key] = o[key] - 1
        if o[key] >= 0 then return false end
        o[key] = gap
        return true
    end

    local function aim(o,precise,dh)
        local p = o.run.player
        if not p or not p.active then return end
        local direction = precise and program.angle256 or program.angle
        return direction(s16(o.h + (dh or 0)),o.l,p.h,p.l,o.aim or 0)
    end

    local function draw(o,id,dh,dl)
        if not o.run.art then return end
        local art = o.run.art[id]
        local h,l = program.addPacked(o.h,o.l,dh,dl)
        local x,y = world(h,l)
        Render(art[1],floor(x) + art[2] / 2,floor(y) + art[3] / 2)
    end

    local function hit(o,base,mask,points)
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = base; return false end
        o.flags,o.palette = band(o.flags,0xa3ff),bxor(o.palette,mask)
        hyper.hit(o,flags)
        if o.hp >= 0 then return false end
        hyper.kill(o.run,flags,points)
        return true
    end

    local function damage(o,amount,flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end
    Gun.damage,Platform.damage = damage,damage

    function Gun.init(o)
        o.flags,o.hp,o.palette = 0xa000,0x600,22
        o.front,o.back,o.right,o.left = 0x400,0x400,0x400,0x400
        o.phase,o.pose,o.wait,o.poseClock = 0,1,0x20,3
        o.aim,o.fireClock,o.cycle,o.volley = 0,0,0,0
        o.run.bulletCapacity = math.max(o.run.bulletCapacity,110)
        return path.attach(o)
    end

    function Gun.step(o)
        local run = o.run
        if o.h <= -0x800 then remove(o); return end
        o.h = s16(o.h - run.groundScroll)
        if hit(o,22,9,34) then
            effects.emit(o,{{0x88,0,0,0,scrolls=true}})
            items.emit(o,8)
            remove(o)
            return
        end
        if o.phase == 0 and tick(o,'wait',0x10) then o.phase = 1 end
        if o.phase == 1 then
            if tick(o,'poseClock',3) and o.pose < 8 then o.pose = o.pose + 1 end
            if o.pose == 8 then
                local angle = aim(o)
                if angle then
                    o.aim,o.phase = band(angle + 2,0x3c),2
                    o.cycle,o.fireClock,o.volley = 8,0,0
                end
            end
        end
        if o.phase == 2 then
            if o.h < 0x1400 then o.phase = 3 end
            if o.volley ~= 0 or tick(o,'cycle',8) then
                if o.volley == 0 then o.volley = 3 end
                if tick(o,'fireClock',3) then
                    bullets.emit(run,6,run.loop == 0 and -2 or 2,o.aim,o.h,o.l)
                    o.volley = o.volley - 1
                    if o.volley == 0 then o.aim = aim(o) or o.aim end
                end
            end
        end
        if o.phase == 3 and tick(o,'poseClock',3) then
            o.pose = o.pose - 1
            if o.pose == 1 then o.phase = 4 end
        end
        o.x,o.y = world(o.h,o.l)
    end

    function Gun.render(o) draw(o,data.gun[o.palette][o.pose],-0x400,-0x400) end

    function Hatch.init(o)
        o.flags,o.hp = 0x8000,0x7fff
        o.phase,o.pose,o.poseClock = 0,1,2
        o.clock = hatchClocks[o.run.major] or 0x20
        return path.attach(o)
    end

    function Hatch.step(o)
        local run = o.run
        if o.h > -0x2000 then o.entered = true
        elseif o.entered then remove(o); return end
        o.h = s16(o.h - run.groundScroll)
        if run.freeze then return end
        if o.phase == 0 and o.entered and o.h > 0x5000 and o.h < 0x7000 and o.l > 0 and o.l < 0x3800
            and tick(o,'clock',0) then
            o.clock,o.phase = band(program.bossWideRandom(run),0x3f) + 0x20,1
        end
        if o.phase == 1 and (o.pose > 1 or o.h > 0x3c00) and tick(o,'poseClock',2) then
            o.pose = o.pose + 1
            if o.pose == 8 then
                o.phase,o.platformClock = 2,0x1e
                program.bossWideRandom(run)
            end
        end
        if o.phase == 2 and tick(o,'platformClock',0) then
            local q = run.spawnQueue
            q[#q + 1] = {run.major,0,0x55,0,0,0x170bf8,0x170c8c,h=o.h,l=o.l}
            o.phase = 4
        elseif o.phase == 3 and tick(o,'poseClock',2) then
            o.pose = o.pose - 1
            if o.pose == 1 then o.phase = 4 end
        end
        o.x,o.y = world(o.h,o.l)
    end

    function Hatch.render(o) draw(o,data.hatch[22][o.pose],-0x1000,-0x1000) end

    function Platform.init(o)
        o.h,o.l,o.flags,o.hp = s16(o.row.h + 0x200),o.row.l,0x8000,0x7fff
        o.front,o.back,o.right,o.left = 0xc00,0x600,0x600,0x600
        o.phase,o.pose,o.poseClock,o.palette = 0,1,3,21
        o.phaseAngle,o.dh,o.rise,o.protection = 0,0,0x10,0x10
        return o.h > 0x2800
    end

    local function firePlatform(o)
        local run = o.run
        if not tick(o,'fireClock',0x10) or run.enemyShotGrace > 0 or o.h <= 0x2000 then return end
        if o.volley == 1 then o.aim = aim(o,true,-0x600) or 0x80 end
        local kind,count,layers,within,spacing,first = 5,5,3,4,0x18,-0x34
        if o.volley == 0 then kind,count,layers,within,spacing,first = 4,4,5,2,0x14,-0x22 end
        for i = 0,count - 1 do
            for j = 0,layers - 1 do
                local angle = o.aim + first + i * spacing + j * within
                local m = program.shipFan[4][band(angle + 2,0xfc) / 4 + 1]
                local h,l = s16(o.h + m[1] + 0x200),s16(o.l + m[2])
                bullets.emitPrecise(run,kind,-1,angle,h,l)
                if o.volley == 0 and run.loop ~= 0 then bullets.emitPrecise(run,kind,5,angle,h,l) end
            end
        end
        if o.volley == 0 then o.volley,o.fireClock = 1,0x60 else o.volley = 0 end
    end

    function Platform.step(o)
        local run = o.run
        if o.phase ~= 0 and o.protection ~= 0 then
            o.protection = o.protection - 1
            o.hp = o.protection == 0 and 0x1100 or 0x7fff
        end
        if hit(o,21,10,213) then
            local wreck = {}
            for i, row in ipairs(data.wreck) do
                wreck[i] = {row[2],row[1],row[4],row[5],flip=band(row[3],0x40) ~= 0}
            end
            effects.emit(o,wreck)
            remove(o)
            return
        end
        if run.freeze then return end
        o.h = s16(o.h - o.dh - run.groundScroll)
        if band(o.h + 0x1400,0xffff) < 0x8c00 then o.entered = true
        elseif o.entered then remove(o); return end
        if o.phase == 0 and tick(o,'poseClock',3) then
            o.pose = o.pose + 1
            if o.pose == 9 then
                o.flags,o.phase,o.fireClock,o.volley = 0xa001,2,0x10,1
            end
        end
        if o.phase >= 2 then
            o.dh = program.vector(0x28,o.phaseAngle)
            o.phaseAngle = band(o.phaseAngle + 2,255)
            o.h = s16(o.h + o.dh)
            if o.rise < 0x600 then
                o.rise,o.front,o.back = o.rise + 0x40,o.front + 0x40,o.back - 0x40
            end
        end
        if o.phase == 2 and tick(o,'poseClock',3) then
            o.pose = o.pose + 1
            if o.pose == 16 then o.phase = 3 end
        end
        if o.phase == 3 then firePlatform(o) end
        o.x,o.y = world(o.h,o.l)
    end

    function Platform.render(o)
        local row = data.platform[o.palette][o.pose]
        draw(o,row[1],row[2] + o.rise,row[3])
    end

    return Gun,Hatch,Platform
end
