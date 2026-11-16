-- 0x14b398 由副机收束挂载起射任务。0x153e28 在动画指令触发时才登记激光判定。
return function(program, collision, weapons)
    local bit = require('bit')
    local band = bit.band
    local floor,min,max = math.floor,math.min,math.max
    local world,s16,vector = program.world,program.s16,program.vector
    local M = {}

    local function draw(p, imageId, h, l, mirror)
        if not imageId or not p.run.art then return end
        local image = p.run.art[imageId]
        local x,y = world(h,l)
        Render(image[1],floor(x) + image[2] / 2,floor(y) + image[3] / 2,0,mirror and -1 or 1,1)
    end

    local function partInit(o,p)
        o.pilot = p
        o.group,o.layer,o.bound,o.colli = GROUP.PLAYER_BULLET,LAYER.PLAYER_BULLET,false,false
    end

    local Option = Class(object, {
        init = function(o,p)
            partInit(o,p)
            o.layer = LAYER.PLAYER - 1
        end,
        render = function(o)
            if o.pilot.active then draw(o.pilot,o.sprite,o.h + o.drawH,o.l + o.drawL,o.mirror) end
        end,
    })

    local Head = Class(object, {
        init = function(o,p,profile)
            partInit(o,p)
            o.profile,o.cursor = profile,0
        end,
        render = function(o)
            local h,l = unpack(o.profile.head)
            draw(o.pilot,o.sprite,o.h + h,o.l + l)
        end,
    })

    local Beam = Class(object, {
        init = function(o,p,profile)
            partInit(o,p)
            o.profile = profile
            o.h,o.l = s16(p.h + profile.box[1]),s16(p.l + profile.box[2])
            o.length,o.right,o.left,o.damage = unpack(profile.box,3)
            o.endH,o.armed,o.time,o.segmentFrame = 0,false,0,1
        end,
        render = function(o)
            local p = o.pilot
            local drawH,drawL = unpack(o.profile.halo)
            local frame = 6 - floor(max(0,o.time - 1) / 2) % 6
            draw(p,o.profile.haloFrames[frame],p.h + drawH,p.l + drawL)
        end,
    })

    local Segment = Class(object, {
        init = function(o,p,h,l,images,offset,leading)
            partInit(o,p)
            o.h,o.l,o.images,o.offset = h,l,images,offset
            o.leading,o.pos = leading,1
        end,
        render = function(o)
            if o.visible then draw(o.pilot,o.images[o.pos],o.h + o.offset[1],o.l + o.offset[2]) end
        end,
    })

    local Tip = Class(object, {
        init = function(o,p)
            partInit(o,p)
            o.pos = 1
        end,
        render = function(o)
            if o.info then draw(o.pilot,o.info[3],o.h + o.info[1],o.l + o.info[2]) end
        end,
    })

    local function delete(o)
        if o then object.RawDel(o) end
    end

    local function clearBeam(s)
        delete(s.beam)
        delete(s.head)
        delete(s.tip)
        for i, o in pairs(s.segments) do delete(o); s.segments[i] = nil end
        s.beam,s.head,s.tip = nil,nil,nil
    end

    local function nextOrbit(angle, count)
        for _ = 1,count do
            angle = band(angle + 1,63)
            if angle == 16 or angle == 48 then break end
        end
        return angle
    end

    local function merge(p,s)
        if not s.held then
            -- 0x14b5a0 解除时逐帧恢复机速，副机角度以两格还原。
            if s.merged then clearBeam(s) end
            s.merged,s.aligned,s.holdClock,s.speedClock = false,false,s.holdDelay,4
            if p.speed < p.baseSpeed then p.speed = p.speed + 1 end
            s.angle = min(s.home,s.angle + 2)
            return
        end
        if s.holdClock > 0 then
            s.holdClock = s.holdClock - 1
            if s.holdClock > 0 then return end
        end
        if s.merged then
            if p.speed > p.lockSpeed then
                s.speedClock = s.speedClock - 1
                if s.speedClock == 0 then p.speed,s.speedClock = p.speed - 1,p.doll + 3 end
            end
            return
        end
        if p.doll == 2 and not s.aligned then
            if s.orbit ~= 16 and s.orbit ~= 48 then return end
            s.orbit,s.aligned = 16,true
        end
        s.angle = max(0,s.angle - s.turnSpeed)
        if s.angle == 0 then s.merged,s.armHead = true,true end
    end

    -- 0x14c430 的普通副机与 0x14bafa 的环绕副机分别换算锚点。
    local function placeOptions(p,s)
        local orbiting = p.doll == 2 and not s.aligned
        if orbiting then s.orbit = nextOrbit(s.orbit,s.holdClock == 0 and 4 or 1) end
        if not s.merged then s.idleTick = (s.idleTick + 1) % (#s.images * 2) end
        for i,o in ipairs(s.options) do
            local h,l,angle = 0,0,0
            if orbiting then
                angle = band(s.orbit + (i - 1) * 32,63)
                local phase = min(angle,64 - angle)
                h,l = unpack(program.pilotOptionOrbit[phase + 1])
                if p.hyperPower then l = l + floor(l / 4) end
                if angle > 32 then l = -l end
                o.sprite = s.images[phase + 1]
            else
                angle = i == 1 and s.angle or -s.angle
                h,l = vector(s.orbitSpeed,angle * 4)
                h = h - floor(h / 8)
                if p.hyperPower then l = l + floor(l / 4) end
                l = l + floor(l / (p.doll == 3 and 2 or 4))
                o.sprite = s.merged and s.focusImage or s.images[#s.images - floor(s.idleTick / 2)]
            end
            o.h,o.l,o.mirror = s16(p.h + h),s16(p.l + l),angle < 0 or angle > 32
            o.angle = angle
            if s.merged then o.drawH,o.drawL = -0x400,-0x300
            else o.drawH,o.drawL = -0x400,-0x200 end
            o.x,o.y = world(o.h,o.l)
        end
    end

    local function advanceHead(p,s)
        local o = s.head
        if not o then return end
        o.cursor = o.cursor + 1
        local command = o.profile.start[o.cursor]
        if not command then delete(o); s.head = nil; return end
        o.sprite = command[2]
        o.h,o.l = s16(s.options[1].h + o.profile.head[3]),s.options[1].l
        o.x,o.y = world(o.h,o.l)
        if command[1] == 1 then s.beam = New(Beam,p,o.profile) end
    end

    local function stream(p,s,b)
        local profile = b.profile
        local option = s.options[1]
        b.h,b.l = s16(p.h + profile.box[1]),s16(p.l + profile.box[2])
        if b.hit or b.reachedEnd then b.length = max(0,b.endH - b.h)
        else b.length = b.length + 0x800 end
        if not b.sentLead then
            s.segments[31] = New(Segment,p,s16(option.h - 0x600),option.l,profile.leadFrames,profile.lead,true)
            b.sentLead = true
            return
        end
        for i = 1,30 do
            if not s.segments[i] then
                local o = New(Segment,p,s16(option.h - p.deltaH - 0x300),option.l,profile.shaftFrames,profile.shaft)
                o.pos = b.segmentFrame
                b.segmentFrame = b.segmentFrame % #o.images + 1
                s.segments[i] = o
                return
            end
        end
    end

    local function advanceStream(p,s,b)
        local tip = s.tip
        for i = 1,31 do
            local o = s.segments[i]
            if o then
                o.h,o.l = s16(o.h + p.deltaH + 0x800),p.l
                o.x,o.y = world(o.h,o.l)
                if o.leading then o.pos = o.pos % #o.images + 1 end
                local reached = band(o.h,0xffff) >= 0x7800
                if reached then b.reachedEnd = true end
                if reached or b.hit and not o.leading and o.h >= b.endH then
                    delete(o)
                    s.segments[i] = nil
                else o.visible = true end
            end
        end
        if b.hit then
            if not tip then tip = New(Tip,p); s.tip = tip end
            tip.h,tip.l = max(s.options[1].h + 0x400,b.endH + 0x180),p.l
            tip.info = b.profile.tip[tip.pos]
            tip.pos = tip.pos % #b.profile.tip + 1
            tip.x,tip.y = world(tip.h,tip.l)
        elseif tip then delete(tip); s.tip = nil end
        b.time = b.time + 1
    end

    function M.bind(p)
        local images,setup = unpack(program.pilotOptions[p.doll])
        p.optionWeapon = program.pilotOptionWeapons[p.model][p.doll]
        p.laserState = {
            images=images,focusImage=setup[1],home=setup[2],angle=setup[2],turnSpeed=setup[3],
            holdDelay=setup[4],holdClock=setup[4],orbitSpeed=setup[4 + p.model],
            idleTick=0,speedClock=4,orbit=0,merged=false,supportBurst=0,supportFlash=3,
            options={New(Option,p),New(Option,p)},segments={},
        }
        p.laserLevel = 1
        placeOptions(p,p.laserState)
    end

    function M.input(p,held)
        p.laserState.held = held
    end

    function M.step(p)
        local s = p.laserState
        if not p.active or p.run.freeze then return end
        if p.run.bombMode == 'laser' then
            local bomb = p.bomb
            bomb.speedClock = bomb.speedClock - 1
            if bomb.speedClock == 0 then p.speed,bomb.speedClock = max(p.lockSpeed,p.speed - 1),p.doll + 3 end
            placeOptions(p,s)
            return
        end
        if p.run.bossEnding then s.held = false end
        merge(p,s)
        placeOptions(p,s)
        if not p.run.bossEnding then weapons.support(p,s) end
        if s.beam then stream(p,s,s.beam); advanceStream(p,s,s.beam) end
        advanceHead(p,s)
        if s.armHead then
            local profiles = p.hyperPower and program.pilotHyperLasers or program.pilotLasers
            s.head = New(Head,p,profiles[p.model][p.doll][p.laserLevel])
            s.armHead = false
        end
    end

    function M.collide(p)
        local b = p.laserState.beam
        if b and p.active then collision.laser(p.run,p,b) end
    end

    function M.weaponChanged(p)
        local s = p.laserState
        clearBeam(s)
        s.armHead = s.merged
    end

    function M.reset(p)
        local s = p.laserState
        clearBeam(s)
        s.held,s.merged,s.aligned,s.armHead = false,false,false,false
        s.angle,s.holdClock,s.speedClock = s.home,s.holdDelay,4
        s.supportHeld,s.supportBurst,s.supportFlash = false,0,3
    end

    function M.close(p)
        M.reset(p)
        for _, o in ipairs(p.laserState.options) do delete(o) end
    end

    return M
end
