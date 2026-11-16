-- 五面后段轨道炮用 ROM 的炮口、角度及绘制表同步推进。
return function(program,path,bullets,effects,remove,hyper)
    local bit = require('bit')
    local band,bor,bxor = bit.band,bit.bor,bit.bxor
    local s16,world,packed = program.s16,program.world,program.addPacked
    local floor = math.floor
    local data = program.fifthTowers
    local types = {
        [0x48]={parts=2,hp=0x1800,front=0xc00,back=0xc00,right=0xc00,left=0xc00,edge=-0x1400,
            start=0x201,muzzle=data.side48,modifier=-2,first=-10,gap=5,rays=5,count=3,delay=0x20,burstGap=4,
            point=230,drawH=-0xa00,drawL=-0xa00},
        [0x49]={parts=1,hp=0x2200,front=0xc00,back=0x800,right=0x800,left=0xa00,edge=-0x2000,
            start=0x1f3,muzzle=data.muzzle49,angles=data.angle49,flipped=data.angle49Flip,delay=3,
            point=350,drawH=-0x1000,drawL=-0xa00},
        [0x4a]={parts=2,hp=0x2400,front=0x1000,back=0x1000,right=0x1000,left=0x1000,edge=-0x2400,
            start=0x2b6,muzzle=data.side4a,modifier=-1,first=-9,gap=3,rays=7,count=6,delay=0x30,burstGap=4,
            point=280,drawH=-0x1200,drawL=-0x1400},
        [0x4b]={parts=1,hp=0x3e00,front=0x1200,back=0xc00,right=0xe00,left=0xe00,edge=-0x3c00,
            start=0x299,muzzle=data.muzzle4b,angles=data.angle4b,flipped=data.angle4bFlip,delay=3,
            point=390,drawH=-0x1e00,drawL=-0x1600},
    }

    local function tick(o,key,gap)
        o[key] = o[key] - 1
        if o[key] >= 0 then return false end
        o[key] = gap
        return true
    end

    local function damage(o,amount,flags)
        o.hp,o.flags = s16(o.hp - amount),bor(o.flags,flags)
    end

    local function start(o)
        local p,run = o.model,o.run
        o.flags,o.hp,o.palette = 0xa000,p.hp,22
        o.front,o.back,o.right,o.left = p.front,p.back,p.right,p.left
        o.pose,o.poseClock,o.fireClock,o.burstClock,o.volley = 1,2,p.delay,4,0
        o.flip = run.major == p.start
        if not path.attach(o) then return false end
        if p.parts == 2 then
            o.extraParts[1].flags = 0x8000
            program.bossWideRandom(run)
            program.bossWideRandom(run)
        elseif o.kind == 0x49 then
            o.lane = run.major < 0x260 and 0x40 or 0x44
            if o.lane == 0x40 then run.fifthMid2Projectiles = true end
        else
            o.lane = run.major < 0x280 and 0x42 or 0x46
            if o.lane == 0x46 then o.fireClock = 2 end
        end
        run.bulletCapacity = math.max(run.bulletCapacity,160)
        return true
    end

    local function wreck(o,flags)
        hyper.kill(o.run,flags,o.model.point)
        local commands = {}
        for i, row in ipairs(data.wreck[o.kind]) do
            commands[i] = {row[2],row[1],row[4],row[5],floor(row[6] / 256),band(row[6],255),
                flip=band(row[3],0x40) ~= 0,scrolls=true}
        end
        effects.emit(o,commands)
        o.dying,o.flags = true,0x8000
    end

    local function release(o)
        if o.lane == 0x40 then o.run.fifthMid2Projectiles = false end
        remove(o)
    end

    local function hits(o)
        local flags = band(o.flags,0x5c00)
        if flags == 0 then o.palette = 22; return false end
        o.flags,o.palette = band(o.flags,0xa3ff),bxor(o.palette,9)
        hyper.hit(o,flags)
        return o.hp < 0 and flags or nil
    end

    local function sideFire(o)
        local p,run = o.model,o.run
        if o.volley == 0 then
            if not tick(o,'fireClock',p.delay) then return end
            o.volley = p.count
        end
        local pilot = run.player
        if not pilot or not pilot.active then return end
        local m = p.muzzle[o.flip and 1 or 2]
        local angle = program.angle256(s16(o.h + m[1]),s16(o.l + m[2]),pilot.h,pilot.l,0x80)
        if not tick(o,'burstClock',p.burstGap) then return end
        local h,l = packed(o.h,o.l,m[1],m[2])
        for i = 0,p.rays - 1 do
            local a = angle + p.first + i * p.gap
            if run.loop == 0 then bullets.emitPrecise(run,11,p.modifier,a,h,l)
            elseif o.kind == 0x48 then
                bullets.emitPrecise(run,11,p.modifier,a,h,l)
                bullets.emitPrecise(run,11,p.modifier + 6,a,h,l)
            else
                bullets.emitPrecise(run,11,p.modifier,a - 8,h,l)
                bullets.emitPrecise(run,11,p.modifier,a + 8,h,l)
            end
        end
        o.volley = o.volley - 1
    end

    local function sideStep(o)
        local p,run = o.model,o.run
        if not o.dying then
            if o.h <= 0x2800 and (o.kind == 0x48 or o.entered) then wreck(o,0)
            else
                local flags = hits(o)
                if flags then wreck(o,flags) end
            end
        end
        if o.h > p.edge then o.entered = true
        elseif o.entered then remove(o); return end
        o.h = s16(o.h - run.groundScroll)
        o.x,o.y = world(o.h,o.l)
        if run.freeze and o.kind == 0x4a then return end
        if not o.dying then sideFire(o) end
        if tick(o,'poseClock',2) then o.pose = o.pose % 8 + 1 end
    end

    local function aimed49(o)
        local p,run = o.model,o.run
        local m = p.muzzle[o.pose]
        local h,l = packed(o.h,o.l,m[1],o.flip and -m[2] or m[2])
        local a = (o.flip and p.flipped or p.angles)[o.pose]
        bullets.emitPrecise(run,4,0,a,h,l)
        if run.loop == 0 then bullets.emitPrecise(run,5,-4,a,h,l)
        else
            bullets.emitPrecise(run,5,-4,a - 8,h,l)
            bullets.emitPrecise(run,5,-4,a + 8,h,l)
        end
        if run.major >= 0x268 then
            bullets.emitPrecise(run,3,4,a,h,l)
            if run.loop ~= 0 then bullets.emitPrecise(run,3,10,a,h,l) end
        end
    end

    local function aimed4b(o)
        local p,run = o.model,o.run
        local m = p.muzzle[o.pose]
        local h,l = packed(o.h,o.l,m[1],o.flip and -m[2] or m[2])
        local a = (o.flip and p.flipped or p.angles)[o.pose]
        bullets.emitPrecise(run,3,1,a,h,l)
        if run.loop ~= 0 then bullets.emitPrecise(run,3,7,a,h,l) end
        bullets.emitPrecise(run,4,-3,a + 2,h,l)
        bullets.emitPrecise(run,4,-3,a - 2,h,l)
        bullets.emitPrecise(run,5,-7,a + 1,h,l)
    end

    local function fixedStep(o)
        local p,run = o.model,o.run
        local flags = hits(o)
        if flags then wreck(o,flags); release(o); return end
        if o.h > p.edge then o.entered = true
        elseif o.entered then release(o); return end
        o.h = s16(o.h - run.groundScroll)
        o.x,o.y = world(o.h,o.l)
        if run.freeze and o.kind == 0x4b then return end
        if tick(o,'fireClock',o.lane == 0x46 and 2 or p.delay) then
            if o.kind == 0x49 then aimed49(o); o.pose = o.pose % 30 + 1
            else o.pose = o.pose % 30 + 1; aimed4b(o) end
        end
    end

    local function render(o)
        if not o.run.art or o.dying then return end
        local p = o.model
        local image = o.run.art[data[o.kind][o.palette][o.pose]]
        local h,l = packed(o.h,o.l,p.drawH,p.drawL)
        local x,y = world(h,l)
        Render(image[1],floor(x) + (o.flip and -1 or 1) * image[2] / 2,floor(y) + image[3] / 2,
            0,o.flip and -1 or 1)
    end

    local handlers = {}
    for kind,model in pairs(types) do
        local function init(o) o.model = model; return start(o) end
        handlers[program.actorCallbacks[kind][2]] =
            {parts=model.parts,init=init,step=model.parts == 2 and sideStep or fixedStep,render=render,damage=damage}
    end
    return handlers
end
