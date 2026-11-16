-- 0x19d21c 先按任务槽更新，再结算主体和翼面判定框的伤害。
return function(program, bullets, effects, items, remove, hyper)
    local directory = 'mod/GAME/th44/native/'
    local scheduler = dofile(directory .. 'boss_tasks.lua')
    local attach,clear,stop,tick = scheduler.attach,scheduler.clear,scheduler.stop,scheduler.tick
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world = program.s16,program.world
    local max,min,abs,floor = math.max,math.min,math.abs,math.floor
    local data = program.boss4
    local M = {parts=13}
    local actions
    local colors = {19,20,21,21,21,20}
    local flashes = {12,11,10,10,10,11}

    local function pose(part,h,l)
        part.h,part.l = s16(h),s16(l)
        part.x,part.y = world(part.h,part.l)
    end

    local function place(o)
        local p = o.boxes
        local h,l = o.h,o.l
        pose(o,h,l)
        pose(p[2],h + o.hullH,l + o.hullL)
        pose(p[3],p[2].h - 0x2200,p[2].l)
        pose(p[4],p[3].h + 0xa00,p[3].l)
        local leftH,leftL = program.addPacked(h,l,-0xd41,-0xb00)
        local rightH,rightL = program.addPacked(h,l,-0xd00,0xac0)
        pose(p[5],leftH + o.leftH,leftL + o.leftL)
        pose(p[6],rightH + o.rightH,rightL + o.rightL)
        pose(p[7],p[3].h + 0xa40,p[3].l - 0xa40)
        pose(p[8],p[3].h + 0xa40,p[3].l + 0xa40)
        pose(p[9],p[3].h - 0x4c0,p[3].l)
        pose(p[10],h - 0x1400,l)
    end

    local function distance(h,l,th,tl)
        local dh,dl = abs(s16(h - th)),abs(s16(l - tl))
        dh = dh - floor(dh / 4)
        return max(dh,dl) + floor(min(dh,dl) / 2)
    end

    local function phase(o, index)
        o.pendingPhase = index
    end

    local function moveCore(o,m)
        m.speedClock = m.speedClock - 1
        if m.speedClock < 0 then
            m.speedClock = m.speedGap
            if o.speed ~= m.targetSpeed then o.speed = o.speed + (o.speed < m.targetSpeed and 1 or -1) end
        end
        local dh,dl = program.vector(o.speed,o.dir * 4)
        o.h,o.l = s16(o.h + dh),s16(o.l + dl)
        place(o)
    end

    local function beginMove(o,index)
        local m = {speedClock=0,speedGap=0,targetSpeed=0,cursor=1}
        o.phase,o.motion = index,m
        if index == 0 then
            o.speed,o.dir,o.protected = 0,0x20,false
            o.entryFrame,o.entryFrontFrame = 7,0
            m.launch,m.angle,m.frontClock = 0x280,0,1
        elseif index == 1 then
            m.targetSpeed = 4
        elseif index == 2 then
            o.speed,o.dir,m.targetSpeed,m.speedClock,m.speedGap = 0,0x20,0x20,3,3
        elseif index == 3 then
            m.targetSpeed,m.speedClock,m.speedGap = 4,2,2
            attach(o.components,0)
        elseif index == 4 then
            o.speed,o.dir,o.hullSpeed = 0,0x20,6
        elseif index == 5 then
            o.dir,m.targetSpeed = 0x20,1
        elseif index == 6 then
            o.speed,o.dir = 0,0x20
        elseif index == 7 then
            m.slowClock = 8
        elseif index == 8 then
            o.speed,o.dir,o.hullSpeed,m.cursor = 0,0x20,4,2
        end
    end

    local function patrol(o,m,points,range,moveHull)
        local h,l = o.h,o.l
        if moveHull then h,l = s16(h + o.hullH),s16(l + o.hullL) end
        local point = points[m.cursor]
        local dir = moveHull and o.hullDir or o.dir
        dir = program.turn64(dir,program.angle(h,l,point[1],point[2],dir))
        if distance(h,l,point[1],point[2]) <= range then m.cursor = m.cursor % #points + 1 end
        if moveHull then
            local dh,dl = program.vector(o.hullSpeed,dir * 4)
            o.hullDir,o.hullH,o.hullL = dir,s16(o.hullH + dh),s16(o.hullL + dl)
        else o.dir = dir end
    end

    local function move(o)
        if o.pendingPhase ~= nil then
            local index = o.pendingPhase
            o.pendingPhase = nil
            beginMove(o,index)
        end
        local index,m,run = o.phase,o.motion,o.run
        if index < 0 then return end
        if index == 0 then
            if m.launch > 0 then
                m.angle = band(m.angle + 2,255)
                local _,dl = program.vector(floor(m.launch / 4),m.angle)
                dl = s16(dl * 8)
                o.entryFrame = min(15,max(0,floor(-dl / 1024) + 7))
                o.h,o.l = s16(o.h + m.launch),s16(0x1c00 + dl - run.cameraOffset)
                m.launch = max(0,m.launch - 5)
                if m.launch == 0 then o.draws[10],o.draws[11] = nil,true end
            end
            if m.launch == 0 then
                m.frontClock = m.frontClock - 1
                if m.frontClock < 0 then
                    m.frontClock,o.entryFrontFrame = 1,o.entryFrontFrame + 1
                    if o.entryFrontFrame == 8 then
                        o.entryFrontFrame,o.draws[11],o.draws[10] = 0,nil,nil
                        for i = 0,5 do o.draws[i] = true end
                        attach(o.directors,3)
                        attach(o.components,9)
                        attach(o.components,10)
                        phase(o,1)
                        for i = 2,4 do o.boxes[i].flags = 0xa001 end
                    end
                end
            end
        elseif index == 1 then patrol(o,m,data.patrol,0x200,false)
        elseif index == 3 then
            local l = s16(0x1c00 - run.cameraOffset)
            o.dir = program.angle(o.h,o.l,0x6000,l,o.dir)
            local d = distance(o.h,o.l,0x6000,l)
            if d > 0x1400 then m.targetSpeed = 0x20
            else
                if not m.slow then m.slow,m.speedClock,m.speedGap = true,0,0 end
                m.targetSpeed = 4
                if d <= 0x200 then
                    o.speed,o.phase = 0,-1
                    attach(o.directors,5)
                end
            end
        elseif index == 4 then patrol(o,m,data.orbit,0x400,true)
        elseif index == 7 then
            m.slowClock = m.slowClock - 1
            if m.slowClock < 0 then m.slowClock,o.hullSpeed = 8,max(2,o.hullSpeed - 1) end
            patrol(o,m,data.fastOrbit,0x200,true)
        elseif index == 8 then patrol(o,m,data.finalOrbit,0x400,true) end
        moveCore(o,m)
    end

    local function endFight(o, flags)
        local run,pilot = o.run,o.run.player
        if not pilot or not pilot.active then return false end
        clear(o.attacks)
        clear(o.directors)
        attach(o.directors,2)
        o.health,o.dying,run.bossEnding = -1,true,true
        o.boxes[2].flags = 0x8000
        o.colors = {unpack(colors)}
        actions.breakWings(o)
        o.orbCommand = 3
        pilot.protect = 0xff
        hyper.kill(run,flags,60000)
        bullets.clearWithChips(run,0)
        return true
    end

    local function hitState(o)
        if o.dying then return end
        local damage,flags = 0,0
        for i = 2,4 do
            local part = o.boxes[i]
            flags = bor(flags,band(part.flags,0x5c00))
            damage = max(damage,band(0x7fff - part.hp,0xffff))
        end
        if o.wingDamage > 0 then damage,flags = floor(o.wingDamage / 2),o.wingCredit end
        o.wingDamage = 0
        if flags == 0 then
            local palette = o.health <= 0xc400 and 25
            for i, color in ipairs(colors) do o.colors[i] = palette or color end
        else
            hyper.hit(o,flags)
            if not o.protected then o.health = o.health - damage end
            for i = 2,4 do
                local p = o.boxes[i]
                p.flags,p.hp = band(p.flags,0xa3ff),0x7fff
            end
            for i, mask in ipairs(flashes) do
                if not o.transformed or i == 1 or i == 6 then
                    o.colors[i] = bxor(o.colors[i] == 25 and colors[i] or o.colors[i],mask)
                end
            end
            o.credit = flags
        end
        for i = 5,6 do
            local part = o.boxes[i]
            local credit = band(part.flags,0x5c00)
            if credit == 0 then part.palette = 19
            else
                part.flags = band(part.flags,0xa3ff)
                part.palette = bxor(part.palette,12)
                local d = s16(0x7fff - part.hp)
                if d > o.wingDamage then o.wingDamage,o.wingCredit = d,credit end
                part.hp = 0x7fff
            end
        end
        if o.health < 0 then
            if endFight(o,o.credit) then return end
            o.health = 0x200
        end
        if not o.transformed then
            o.timeout = o.timeout - 1
            if o.timeout == 0 or o.health < 0x23000 then
                o.transformed,o.reverseSides = true,true
                clear(o.attacks)
                clear(o.directors)
                attach(o.directors,1)
                bullets.clearWithFade(o.run)
            end
        end
        if not o.final and o.health < 0xc400 then
            o.final = true
            stop(o.directors,5)
            attach(o.directors,6)
            actions.breakWings(o)
            bullets.clearWithFade(o.run)
        end
        if o.transformed and not o.run.freeze then
            o.finalTimeout = o.finalTimeout - 1
            if o.finalTimeout == 0 and not endFight(o,0) then o.finalTimeout = 0x78 end
        end
    end

    actions = dofile(directory .. 'boss4_tasks.lua')(program,bullets,effects,items,scheduler,phase)

    function M.init(o)
        o.run.bossHyper,o.run.scoreOnlyKills,o.run.hyperDropsLocked = true,true,true
        o.boxes = {o,unpack(o.extraParts)}
        o.h,o.l,o.speed,o.dir = s16(0xc800),0x1c00,0,0
        o.hullH,o.hullL,o.hullSpeed,o.hullDir = 0,0,0,0
        o.leftH,o.leftL,o.rightH,o.rightL = 0,0,0,0
        o.health,o.timeout,o.finalTimeout,o.credit = 0x46000,0x1c20,0x1c20,0
        o.wingDamage,o.wingCredit = 0,0
        o.phase,o.protected = -1,true
        o.colors,o.draws = {unpack(colors)},{}
        o.orbAngles = {0,0}
        o.hullFrame,o.coverFrame = 0,0
        for i, part in ipairs(o.boxes) do
            part.front,part.back,part.right,part.left,part.hp = unpack(data.boxes[i])
            part.flags,part.frame,part.palette,part.turn = 0x8000,0,19,0
        end
        o.directors = {label='四面关底调度',limit=5,handlers=actions.directors}
        o.attacks = {label='四面关底攻击',limit=10,handlers=actions.attacks}
        o.components = {label='四面关底部件',limit=10,unique=true,handlers=actions.components}
        attach(o.directors,0)
        local run = o.run
        run.boss4 = o
        run.bulletCapacity = max(run.bulletCapacity,run.loop == 0 and 160 or 190)
        place(o)
        return true
    end

    function M.damage(part,amount,flags)
        part.flags,part.hp = bor(part.flags,flags),s16(part.hp - amount)
    end

    function M.step(o)
        if o.finished then
            o.run.boss4,o.run.stageCleared = nil,true
            remove(o)
            return
        end
        if not o.run.freeze then
            tick(o,o.directors)
            move(o)
            tick(o,o.attacks)
            tick(o,o.components)
        end
        hitState(o)
    end

    local function draw(o,part,key,color,index,dh,dl,flip)
        local image = o.run.art[data.images[key][color][index + 1]]
        local x,y = world(program.addPacked(part.h,part.l,dh,dl))
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2,0,1,flip and -1 or 1)
    end

    function M.render(o)
        if not o.run.art then return end
        local p,d,c = o.boxes,o.draws,o.colors
        if d[0] then draw(o,p[2],'hull',c[1],p[2].frame,-0x1200,-0x1200) end
        if d[1] then draw(o,p[3],'armor',c[2],p[3].frame,-0x1800,-0x1400) end
        if d[2] then draw(o,p[4],'cover',c[3],o.coverFrame,-0xa00,-0x600) end
        if d[3] then draw(o,p[7],'cannon',c[4],p[7].turn,-0x800,-0x600) end
        if d[4] then draw(o,p[8],'cannon',c[5],p[8].turn,-0x800,-0x600) end
        if d[5] then draw(o,p[9],'turret',c[6],floor(band(p[9].turn + 1,0x3e) / 2),-0x600,-0x500) end
        if d[6] then draw(o,p[2],'transformedHull',c[1],o.hullFrame,-0x1e00,-0x1600) end
        if d[7] then
            draw(o,p[5],'leftWing',p[5].palette,p[5].frame,-0x1000,-0x800)
            draw(o,p[5],'wingHatch',p[5].palette,p[5].hatch or 0,-0xcc0,-0x200)
        end
        if d[8] then
            draw(o,p[6],'rightWing',p[6].palette,p[6].frame,-0x1000,-0x800)
            draw(o,p[6],'wingHatch',p[5].palette,p[6].hatch or 0,-0xcc0,-0x5c0,true)
        end
        if d[9] then
            draw(o,p[2],'vanishingHull',c[1],o.hullFrame,-0x1600,-0x1d00)
            draw(o,p[2],'tail',c[1],0,0x300,-0xa00)
        end
        if d[10] then draw(o,p[10],'entry',21,o.entryFrame,-0x2800,-0x1800) end
        if d[11] then draw(o,p[10],'entryFront',21,o.entryFrontFrame,-0x2400,-0x1200) end
    end

    return M
end
