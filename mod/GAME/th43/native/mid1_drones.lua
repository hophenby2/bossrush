-- 0x82 的回调在 0x130a58。每架子机有自己的移动、耐久和炮口，母机只给发射许可。
return function(program, bullets, effects)
    local band = require('bit').band
    local s16, floor = program.s16, math.floor
    local data = program.mid1
    local M = {}

    local Box = Class(object, {
        init = function(p, drone, index)
            p.group,p.layer,p.bound,p.colli = GROUP.ENEMY,LAYER.ENEMY,false,true
            p.h,p.l,p.hp = drone.h,drone.l,0x60
            p.front,p.back,p.right,p.left = unpack(data.droneBoxes[index])
            p.hitPool,p.bodyContact,p.lockable = 1,index == 1,index == 1
            p.damage = function(self,value) self.hp = self.hp-value end
        end,
    })

    local Drone = Class(object, {
        init = function(p, owner, slot, side, initialFrame, aim)
            p.run,p.host,p.slot = owner.run,owner,slot
            p.h,p.l = s16(owner.h-0xe80),s16(owner.l+side*0x12c0)
            p.group,p.layer,p.bound,p.colli = GROUP.GHOST,LAYER.ENEMY,false,false
            p.speed,p.angle,p.aim = 8,side < 0 and 0x86 or 0x7a,aim
            p.speedClock,p.zoomClock,p.zoom = 0x40,1,0
            p.picture = initialFrame/4-band(program.random(p.run,program.randomParity),7)
            p.palette,p.hp = 1,0x60
            p.boxes = {New(Box,p,1),New(Box,p,2)}
            owner.children[slot],owner.children[slot+1] = unpack(p.boxes)
        end,
        render = function(p)
            local index = p.picture%8+1
            local image = p.run.art.sprites[data.art.drones[p.palette][index]]
            local scale = math.min(16,p.zoom+1)/16
            Render(image[1],floor((p.l-0x400)/64)-112+image[2]*scale/2,
                floor((p.h-0x400)/64)-224+image[3]*scale/2,0,scale,scale)
        end,
    })

    local function remove(p)
        local o,slot = p.host,p.slot
        o.children[slot],o.children[slot+1],o.drones[slot] = nil,nil,nil
        for _, box in ipairs(p.boxes) do object.RawDel(box) end
        object.RawDel(p)
    end

    local function breakDrone(p)
        effects.spawn(p.run,p.h,p.l,{{4,0x8b,0,0,0,p.speed,p.angle}},false,true)
        remove(p)
    end

    local function step(p)
        local run = p.run
        if p.host.dead then breakDrone(p); return end
        local dh,dl = program.vector(p.speed,p.angle)
        p.h,p.l = s16(p.h+dh),s16(p.l+dl-run.cameraStep)
        local visible = band(p.h+0x200,0xffff) < 0x7400
        if not visible and p.entered then remove(p); return end
        p.entered = p.entered or visible

        local first,second = unpack(p.boxes)
        local hp = math.min(first.hp,second.hp)
        if hp < 0 then breakDrone(p); return end
        if hp < p.hp then p.palette = p.palette == 2 and 1 or 2
        else p.palette = hp < 0x18 and band(run.frame,0x0e) == 0 and 3 or 1 end
        p.hp = hp
        for _, box in ipairs(p.boxes) do box.h,box.l,box.hp = p.h,p.l,hp end
        p.picture = (p.picture-1)%8
        p.zoomClock,p.speedClock = p.zoomClock-1,p.speedClock-1
        if p.zoomClock < 0 then p.zoom,p.zoomClock = p.zoom+1,1 end
        if p.speedClock < 0 then p.speed,p.speedClock = math.min(0x24,p.speed+1),3 end

        if p.h >= 0x2000 and p.host.droneClock == 0 and not run.bulletHold and not run.freeze then
            local offset = data.droneMuzzle[band(p.aim,0x3e)/2+1]
            local mh,ml = program.unpack(offset)
            bullets.emitFasterInLoop(run,0xb,-6,p.aim*4,s16(p.h+mh),s16(p.l+ml))
        end
    end

    function M.spawn(o, side, frame, aim)
        for slot = 1, 47, 2 do
            if not o.drones[slot] then
                o.drones[slot] = New(Drone,o,slot,side,frame,aim)
                return
            end
        end
    end

    function M.step(o)
        for slot = 1, 47, 2 do
            local p = o.drones[slot]
            if p then step(p) end
        end
    end

    function M.clear(o)
        for _, p in pairs(o.drones) do remove(p) end
    end

    return M
end
