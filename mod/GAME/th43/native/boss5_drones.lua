-- 0x12daa6 分配里二周目的旋转子机。每只子机独立追踪阵心、翻转和发射。
return function(program, bullets, effects)
    local floor = math.floor
    local data = program.boss5
    local band = require('bit').band
    local M = {}

    local Drone = Class(object, {
        init = function(p, owner, index)
            p.run, p.host, p.slot = owner.run, owner, index
            p.h, p.l = owner.h, owner.l
            p.target = owner.formation.points[index]
            p.group,p.layer,p.bound,p.colli = GROUP.ENEMY,LAYER.ENEMY,false,false
            p.kind, p.hitPool, p.bodyContact, p.hp = 0x67, 1, false, 0x7fff
            p.front,p.back,p.right,p.left = unpack(data.droneBoxes)
            p.damage = function(part, amount) part.damagePending=(part.damagePending or 0)+amount end
            p.heading, p.face, p.frameIndex, p.zoom, p.zoomClock = 0, 0, 0, 0, 4
            p.flipClock, p.burst, p.burstClock, p.fireClock, p.needleClock = 4, 0, 0x10, 0, 8
        end,
        render = function(p)
            if p.l <= -0x400 or p.l >= 0x3c00 then return end
            local index = floor(p.target.face/8)+1
            local image = p.run.art.sprites[data.droneArt[p.flash and 2 or 1][index][p.frameIndex+1]]
            local x,y = program.world(p.h-0xe00,p.l-0xa00)
            local scale = (32-data.droneZoom[p.zoom+1])/32
            Render(image[1],floor(x)+image[2]*scale/2,floor(y)+image[3]*scale/2,0,scale,scale)
        end,
    })

    function M.prepare(o)
        local phase = program.random(o.run, program.effectRandom)*4
        local f = {mode=0, angle=phase, turn=1, clock=8, interval=8, radius=0, points={}}
        for i = 1, 16 do
            f.points[i] = {h=0,l=0,face=band(phase+(i-1)*16,0xff)}
        end
        o.formation = f
    end

    function M.spawn(o,index)
        o.children[index]=New(Drone,o,index)
    end

    function M.offsets(f)
        for i, p in ipairs(f.points) do
            local h, l = program.vector(f.radius, f.angle+(i-1)*16)
            p.h,p.l = program.s16(h*8),program.s16(l*16)
        end
    end

    function M.align(f)
        local aligned = true
        for _, p in ipairs(f.points) do
            if p.face ~= 0 then
                aligned = false
                p.face = band(p.face+(p.face > 0x80 and 2 or -2), 0xff)
            end
        end
        return aligned
    end

    local function moveDrone(o, p)
        local run,f = o.run,o.formation
        local h,l = program.s16(f.h+p.target.h),program.s16(f.l+p.target.l)
        local distance=program.distance(p.h,p.l,h,l)
        local speed=0x18
        for _, row in ipairs(data.droneSpeed) do
            if distance<=row[1] then speed=row[2];break end
        end
        p.heading=program.angle(p.h,p.l,h,l,p.heading)
        local dh,dl=program.vector(speed,p.heading*4)
        p.h,p.l=program.s16(p.h+dh),program.s16(p.l+dl+run.cameraStep)
        p.x,p.y=program.world(p.h,p.l)
    end

    local function fire(o,p)
        local run=o.run
        p.colli,p.bodyContact,p.flipped=true,true,false
        if p.burst==0 then
            p.burstClock=p.burstClock-1
            if p.burstClock<0 then p.burstClock,p.burst=0x20,8 end
        end
        if p.burst>0 then
            p.fireClock=p.fireClock-1
            if p.fireClock<0 then
                p.fireClock,p.burst=3,p.burst-1
                bullets.emitAngle(run,2,-8,p.face*0x80,p.h,p.l,p.face==0 and 0xc00 or -0xc00,0)
            end
        end
        p.needleClock=p.needleClock-1
        if p.needleClock<0 then
            p.needleClock=0xc
            -- 0x12dd08 进入 0xf7180；子机的组标志为 0、首部件为 0xa301，走 0xf6f7a 的同速三向。
            bullets.emitCenterAndWide(run,9,-2,(1-p.face)*0x80,p.h,p.l,p.face==1 and 0xc00 or -0xc00,0)
        end
    end

    local function flip(p)
        if p.flipped then return end
        p.flipClock = p.flipClock-1
        if p.flipClock >= 0 then return end
        p.flipClock = 4
        local target = (1-p.face)*8
        if p.frameIndex == target then return end
        p.frameIndex = band(p.frameIndex+1,15)
        if p.frameIndex == target then p.face,p.flipped,p.burst = 1-p.face,true,0 end
    end

    function M.step(o)
        local f=o.formation
        if not f then return end
        for i=1,16 do
            local p=o.children[i]
            if p then
                if o.phase~=4 then
                    effects.spawn(o.run,p.h,p.l,{{0,0x88,0,0,0,0,0}},false,true)
                    o.children[i]=nil
                    object.RawDel(p)
                else
                    p.front = data.droneHeight[p.frameIndex+1]
                    p.back = p.front
                    p.flash = (p.damagePending or 0)>0 and not p.flash
                    p.damagePending=0
                    p.hp = 0x7fff
                    moveDrone(o,p)
                    if not p.zoomFinished then
                        p.zoomClock = p.zoomClock-1
                        if p.zoomClock < 0 then
                            p.zoomClock,p.zoom = 4,p.zoom+1
                            if p.zoom == 30 then p.zoom,p.zoomFinished = 16,true end
                        end
                    end
                    if f.mode==1 then fire(o,p) end
                    if f.mode==2 then flip(p) end
                end
            end
        end
    end

    function M.close(o)
        for _,p in pairs(o.children) do if IsValid(p) then object.RawDel(p) end end
        o.children={}
    end

    return M
end
