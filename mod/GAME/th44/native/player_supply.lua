-- 0x17d0d8 按种类分配空中道具槽。0x17d2be 分派飞行、拾取和提示图的回调。
return function(program, laser)
    local bit = require('bit')
    local band,bor = bit.band,bit.bor
    local floor,min,abs = math.floor,math.min,math.abs
    local s16,world = program.s16,program.world
    local ranges = {[0]={1,8},[4]={9,10},[8]={11,12},[0x10]={25,25}}
    local M = {}

    local Supply = Class(object,{
        init = function(o,run,slot,kind,h,l)
            o.run,o.slot,o.kind,o.h,o.l = run,slot,kind,h,l
            o.x,o.y = world(h,l)
            local box
            box,o.offset,o.images = unpack(program.pilotSupply[kind])
            o.front,o.back,o.right,o.left = unpack(box)
            o.group,o.layer,o.bound,o.colli = GROUP.GHOST,LAYER.ENEMY + 5 / 4,false,false
        end,
        render = function(o)
            if not o.run.art or not o.pose then return end
            local sprite = o.run.art[o.images[o.pose]]
            local x,y = world(o.drawH,o.drawL)
            Render(sprite[1],floor(x) + sprite[2] / 2,floor(y) + sprite[3] / 2)
        end,
    })

    local function remove(o)
        o.run.airSupply[o.slot] = nil
        object.RawDel(o)
    end

    function M.emit(host,kind,shiftH)
        local run = host.run
        local first,last = unpack(ranges[kind])
        for slot = first,last do
            if not run.airSupply[slot] then
                local o = New(Supply,run,slot,kind,s16(host.h + (shiftH or 0)),host.l)
                run.airSupply[slot] = o
                return o
            end
        end
    end

    local function move(o)
        if o.run.freeze then return end
        local dh,dl = program.vector(o.speed,o.angle * 4)
        o.h,o.l = s16(o.h + dh),s16(o.l + dl)
    end

    -- 0x17d3ae / 0x17d55e 只在弹跳时限内修正方向。左右限位也会写回位置。
    local function bounce(o)
        if o.run.bossEnding or o.remaining == 0 then return end
        if not o.run.freeze then o.remaining = o.remaining - 1 end
        local h,l = band(o.h,0xffff),band(o.l + 0x800,0xffff)
        local angle,reflect = o.angle,false
        if l <= 0xb00 then
            o.l = 0x300
            reflect = angle >= 0x20
            if reflect and h >= (o.kind == 0 and 0x2b00 or 0x3500) then angle = 0x28 end
        elseif l >= 0x3d00 then
            o.l = 0x3500
            reflect = angle <= 0x20
            if reflect and h >= 0x2b00 then angle = 0x18 end
        end
        if reflect then angle = band(-angle + program.bossRandom(o.run),0x3f) end
        local descending = angle > 0x10 and angle <= 0x30
        if h >= 0x6d00 and (angle < 0x10 or angle > 0x30) or h <= 0x700 and descending then
            angle = band(-angle - 0x20 + program.bossRandom(o.run),0x3f)
        end
        o.angle = angle
    end

    -- 炸弹补给向屏幕内的固定点靠拢，到达后每次转过四分之一圈。
    local function orbit(o)
        local run = o.run
        if run.bossEnding then return end
        if not o.orbiting then
            if run.frame % 8 == 0 then o.angle = program.angle(o.h,o.l,0x4600,0x1c00,o.angle) end
            local dh,dl = abs(s16(o.h - 0x4600)),abs(s16(o.l - 0x1c00))
            dh = dh - floor(dh / 4)
            if math.max(dh,dl) + floor(min(dh,dl) / 2) <= 0x200 then
                local quadrant = o.angle - 8
                o.orbiting,o.speed = true,0xa
                o.angle = band(quadrant,0x20) == 0 and 0 or (band(quadrant,0x10) == 0 and 0x20 or 0x10)
            end
        elseif not run.freeze then
            o.remaining = o.remaining - 1
            if o.remaining < 0 then return end
            o.turnClock = o.turnClock - 1
            if o.turnClock == 0 then
                o.angle = band(o.angle + 0x10,0x3f)
                o.turnDelay = band(o.turnDelay + 8,0xff)
                o.turnClock = o.turnDelay
            end
        end
    end

    -- 0x1520f6。补足炸弹登记一级 MAXIMUM，初次满库存拾取登记两级。
    local function collectBomb(p)
        if p.bombs < p.maxBombs then
            p.bombs = p.bombs + 1
            if p.bombs == p.maxBombs then
                p.maximumStarted,p.maximumSuspended = true,false
                p.maximum = min(99,p.maximum + 1)
            end
        elseif p.maximum < 99 then
            p.maximum = p.maximum + 1
            if not p.maximumSuspended and not p.maximumStarted then
                p.maximum,p.maximumStarted = p.maximum + 1,true
            end
            p.maximumSuspended = false
        end
    end

    -- 0x17de12 / 0x17de48 把拾取结果写回同一个槽，直到提示图播完才释放。
    local function collect(o,p)
        local kind,score = o.kind,10
        if kind == 8 then
            collectBomb(p)
        elseif kind == 0x10 then
            p.life = min(p.life + 1,0x14)
        else
            if p.shotLevel == 5 and p.laserLevel == 5 then score = 1000 end
            local laserLevel = p.laserLevel
            local levels = kind == 0 and 1 or 4
            p.shotLevel,p.laserLevel = min(5,p.shotLevel + levels),min(5,laserLevel + levels)
            if laserLevel ~= p.laserLevel then laser.weaponChanged(p) end
            kind = 0
        end
        p.score = p.score + score
        o.offset,o.images = unpack(program.pilotSupplyText[score == 1000 and -1 or kind])
        o.text,o.pose,o.clock = true,nil,2
        o.textPose = 1
        o.angle = band(o.l + o.run.cameraStep,0xffff) < 0x1c00 and 0x10 or 0x30
        o.speed = band(abs(program.bossRandom(o.run)),6) + 7
    end

    local function advance(o,p)
        local run,kind = o.run,o.kind
        o.l = s16(o.l - run.cameraStep)
        if o.text then
            o.pose = o.textPose
            o.drawH,o.drawL = program.addPacked(o.h,o.l,unpack(o.offset))
            move(o)
            o.clock = o.clock - 1
            if o.clock == 0 then
                o.textPose,o.clock = o.textPose + 1,2
                if not o.images[o.textPose] then remove(o) end
            end
            return
        end
        if not o.pose then
            o.pose,o.clock,o.remaining,o.speed = 1,2,0x700,0xb
            if kind == 0 then o.angle = floor(program.randomEnemy(run) / 2) + 0x10
            elseif kind == 4 then o.angle = bor(program.randomEnemy(run),8)
            elseif kind == 8 then
                o.angle = program.angle(o.h,o.l,0x4600,0x1c00,0x20)
                o.turnClock,o.turnDelay = 7,0x14
            end
        end
        if o.taken then collect(o,p); return end
        if kind == 0x10 then o.h = s16(o.h - run.scrollStep * 64)
        else
            if kind == 8 then orbit(o) else bounce(o) end
            move(o)
        end
        if band(o.l + 0x1c00 + run.cameraOffset,0xffff) >= 0x7000
            or band(o.h + 0x800,0xffff) >= 0x8000 then remove(o); return end
        o.clock = o.clock - 1
        if o.clock < 0 then o.pose,o.clock = o.pose % 4 + 1,2 end
        o.drawH,o.drawL = s16(o.h + o.offset[1]),s16(o.l + o.offset[2])
    end

    function M.step(run,first,last)
        for slot = first,last do
            local o = run.airSupply[slot]
            if o then
                advance(o,run.player)
                if run.airSupply[slot] then o.x,o.y = world(o.h,o.l) end
            end
        end
    end

    function M.contact(run,p)
        if run.frame % 2 == 0 then return end
        for _,o in pairs(run.airSupply) do
            if o.pose and not o.text
                and p.h + p.front >= o.h - o.back and p.h - p.back <= o.h + o.front
                and p.l + p.right >= o.l - o.left and p.l - p.left <= o.l + o.right then
                o.taken = true
            end
        end
    end

    function M.close(run)
        for _,o in pairs(run.airSupply) do remove(o) end
    end

    return M
end
