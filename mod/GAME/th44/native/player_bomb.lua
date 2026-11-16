-- 0x148bd4 从炸弹库存登记武器对象，0x154fe2 按低位选择普通炸弹或激光炸弹。
return function(program,bullets,collision,laser,hyper)
    local band = require('bit').band
    local min,max,floor = math.min,math.max,math.floor
    local world,s16 = program.world,program.s16
    local M = {}

    local function draw(o)
        if not o.sprite or not o.run.art then return end
        local image = o.run.art[o.sprite]
        local x,y = world(o.h + o.drawH,o.l + o.drawL)
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2)
    end

    local Part = Class(object, {
        init = function(o,run,h,l,shape)
            o.run,o.h,o.l = run,h,l
            o.drawH,o.drawL,o.front,o.back,o.right,o.left = unpack(shape)
            o.visible = true
            o.group,o.layer,o.bound,o.colli = GROUP.PLAYER_BULLET,LAYER.PLAYER_BULLET,false,false
            o.x,o.y = world(h,l)
        end,
        render = function(o) if o.visible then draw(o) end end,
    })

    local trailShape = {-0x200,-0x800,0x200,0x200,0x800,0x800}
    local laserShapes = {
        {-0xe00,-0xe00,0x1200,0xe00,0xe00,0xe00},
        {-0xf80,-0xc00,0xe00,0xe00,0xc00,0xc00},
        {0x200,-0xc00,0x1600,-0x200,0xc00,0xc00},
        {-0x800,-0xe00,0x1000,0x800,0xe00,0xe00},
    }

    local function setPicture(o,art,h,l)
        o.sprite = art
        if h then o.drawH,o.drawL = h,l end
    end

    local function place(o,h,l)
        o.h,o.l = s16(h),s16(l)
        o.x,o.y = world(o.h,o.l)
    end

    local function release(p)
        local o = p.bomb
        if not o then return end
        if o.parts then
            for _, part in ipairs(o.parts) do object.RawDel(part) end
            for _, part in pairs(o.trail) do object.RawDel(part) end
        end
        object.RawDel(o)
        p.bomb,p.run.bombMode = nil,nil
    end

    local function finish(p)
        release(p)
        hyper.bombEnd(p)
        p.protect = 0x28
        p.speed = min(p.speed,p.baseSpeed)
    end

    local function normal(p,o)
        local run = p.run
        o.l = s16(o.l - run.cameraStep)
        if o.phase == 0 then
            local row = o.profile.opening[o.frameIndex]
            setPicture(o,row[3],row[1],row[2])
            o.clock = o.clock - 1
            if o.clock >= 0 then return end
            o.frameIndex,o.clock = o.frameIndex + 1,1
            if o.frameIndex <= #o.profile.opening then return end
            o.phase,o.frameIndex,o.cycles = 1,#o.profile.primary,6
        end
        if o.phase == 1 then
            run.randomByte = band(run.randomByte + 1,255)
            local direction = program.pilotBombShake:byte(run.randomByte + 1)
            place(o,o.h,o.l + (direction == 0 and -0x40 or 0x40))
            setPicture(o,o.profile.primary[o.frameIndex],-0x2000,-0x1800)
            if run.frame % 2 == 0 then return end
            o.frameIndex = o.frameIndex - 1
            if o.frameIndex > 0 then return end
            o.cycles = o.cycles - 1
            o.frameIndex = #o.profile.primary
            if o.cycles > 0 then return end
            o.phase,o.frameIndex = 2,1
        end
        setPicture(o,o.profile.closing[o.frameIndex],-0x2000,-0x1800)
        if run.frame % 2 ~= 0 then return end
        o.frameIndex = o.frameIndex + 1
        if o.frameIndex > #o.profile.closing then finish(p) end
    end

    local function trail(o,index,h,image)
        local p = o.pilot
        local part = o.trail[index]
        if part then place(part,h,p.l)
        else
            part = New(Part,p.run,h,p.l,trailShape)
            o.trail[index] = part
        end
        part.sprite = image
        return part
    end

    local function advanceTrail(o)
        local p,bank = o.pilot,o.profile.shaft
        local spawned = false
        for i = 1,41 do
            local part = o.trail[i]
            if part then
                local check = s16(part.h + p.deltaH + 0x200)
                if band(check,0xffff) >= 0x7800 or o.groundHit and check > o.endH then
                    object.RawDel(part)
                    o.trail[i] = nil
                else
                    place(part,check + 0x200,p.l)
                    part.sprite = bank[part.pattern][o.pulse]
                end
            elseif not spawned then
                local newPart = trail(o,i,p.h + 0x600,bank[o.pattern][o.pulse])
                newPart.pattern,spawned = o.pattern,true
            end
        end
    end

    local function reformTrail(o,bank)
        local p = o.pilot
        local h = p.h + 0x600 - p.deltaH
        local limit = o.groundHit and o.endH or 0x7800
        for i = 1,41 do
            if h < limit then
                trail(o,i,h,bank[(o.pattern - 2 + i) % #bank + 1]).pattern = o.pattern
                h = h + 0x400
            elseif o.trail[i] then object.RawDel(o.trail[i]); o.trail[i] = nil end
        end
    end

    local function beam(p,o)
        local head,muzzle,tip = unpack(o.parts)
        place(o,p.h,p.l)
        place(muzzle,p.h,p.l)
        place(head,head.h,p.l)
        place(tip,o.endH,p.l)
        o.pulse = (o.pulse - 2) % 3 + 1
        local art
        if o.clock > 0 then o.clock = o.clock - 1 end
        if o.clock == 0 then
            local row = o.profile.release[o.closeIndex]
            if not row then finish(p); return end
            o.phase,o.closeIndex = 1,o.closeIndex + 1
            art = row[1]
            reformTrail(o,row[2])
        else
            art = {}
            for i,frames in ipairs(o.profile.laser) do art[i] = frames[o.pulse] end
            advanceTrail(o)
        end
        o.sprite,head.sprite,muzzle.sprite,tip.sprite = unpack(art)
        local advancing = not o.groundHit and head.h < 0x7e00
        if advancing then place(head,head.h + 0x400 + p.deltaH,p.l) end
        head.visible,tip.visible = advancing,o.groundHit
        o.pattern = (o.pattern - 2) % #o.profile.shaft + 1
    end

    local Bomb = Class(object, {
        init = function(o,p,mode)
            o.pilot,o.run,o.mode,o.profile = p,p.run,mode,program.pilotBombs[p.model]
            o.group,o.layer,o.colli,o.bound = GROUP.PLAYER_BULLET,LAYER.PLAYER_BULLET,false,false
            o.phase,o.frameIndex,o.clock = 0,1,0
            if mode == 'laser' then
                o.parts,o.trail = {},{}
                o.clock,o.pulse,o.pattern,o.closeIndex = 0x78,3,1,1
                o.endH,o.recoilIndex = 0x7800,24
                o.drawH,o.drawL,o.front,o.back,o.right,o.left = unpack(laserShapes[1])
                for i = 2,4 do o.parts[i - 1] = New(Part,p.run,p.h,p.l,laserShapes[i]) end
                place(o.parts[1],p.h - 0x200,p.l)
                place(o,p.h,p.l)
                o.updateBomb = beam
            else
                place(o,0x4400,p.l)
                o.front,o.back,o.right,o.left = 0x1800,0x1800,0x1800,0x1800
                o.updateBomb = normal
            end
        end,
        render = draw,
    })

    function M.input(p,pressed)
        if not pressed or p.bomb or p.bombs == 0 or p.run.major < 4 or p.run.freeze then return end
        local mode = p.laserState.merged and 'laser' or 'shot'
        p.bombHadCombo = p.comboClock ~= 0
        p.bombs,p.bombsUsed,p.protect = p.bombs - 1,p.bombsUsed + 1,0xff
        p.stageBombs = p.stageBombs + 1
        -- 0x148cce 扣两级，关掉连加分，补给恢复满库存后才重新启用。
        if not p.maximumSuspended then p.maximum = max(0,p.maximum - 2) end
        p.maximumSuspended = true
        p.run.bombMode = mode
        p.bomb = New(Bomb,p,mode)
        if mode == 'laser' then
            p.bomb.speedClock = p.laserState.speedClock
            laser.reset(p)
        else p.speed = p.speed + 6 end
    end

    function M.recoil(p)
        local o = p.bomb
        if not o or o.mode ~= 'laser' then return end
        if o.recoilIndex > 1 then
            o.recoil = (o.recoil or 0) - program.pilotBombRecoil[o.recoilIndex]
            o.recoilIndex = o.recoilIndex - 1
        end
        if o.groundHit then
            local push = min(0x48,p.h - 0x800)
            p.h,p.deltaH = p.h - push,p.deltaH - push
        end
    end

    function M.step(p)
        local o = p.bomb
        if not o then return end
        o.updateBomb(p,o)
        if p.bomb and o.mode == 'shot' then bullets.clearWithChips(p.run,0) end
    end

    function M.collide(p)
        local o = p.bomb
        if not o or p.run.frame % 2 == 0 then return end
        if o.mode == 'shot' then collision.shotBomb(p.run,p); return end
        local boxes = {o}
        for _, part in ipairs(o.parts) do if part.visible then boxes[#boxes + 1] = part end end
        for i = 1,41 do if o.trail[i] then boxes[#boxes + 1] = o.trail[i] end end
        collision.laserBomb(p.run,p,o,boxes)
        bullets.eraseBomb(p.run,boxes,o.groundHit and o.endH)
    end

    M.close = release
    return M
end
