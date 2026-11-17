-- 0x18a998 将两台机臂登记为独立敌机。0x18ab18 每次读取母机上一帧写好的挂点。
return function(program,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor,min = math.floor,math.min
    local M = {parts=3}

    function M.init(o)
        local row = o.row
        o.boss,o.mount = row.boss,row.mount
        o.h,o.l = row.h,row.l
        o.flags,o.front,o.back,o.right,o.left,o.hp = 0xa401,0x300,0x300,0x200,0x200,0x7fff
        o.second = {flags=0xa000,h=o.h,l=o.l,front=0x700,back=0x700,right=0x580,left=0x580,hp=0x7fff}
        o.extraParts = {o.second,{flags=0x8000,h=o.h,l=o.l}}
        o.mode,o.deploy,o.scale,o.elevation,o.extension = 4,0,0,0,0x38
        o.drawFrame,o.angle,o.palette = 0,0x80,17
        o.mount.arm = o
        return true
    end

    local function deploy(o)
        if o.deploy == 0 then
            o.scale = o.scale+4
            if o.scale < 0x3c then return end
            o.deploy = 1
        end
        if o.deploy == 1 then
            o.elevation = o.elevation+8
            if o.elevation < 0x80 then return end
            o.deploy = 2
        end
        o.extension = o.extension+3
        if o.extension >= 0xb0 then o.mode = 0 end
    end

    local function burst(o)
        if not o.shots then
            o.fireDelay,o.fireClock,o.shots,o.volleys = 0x10,0,0,o.mount.volleys
        end
        if o.shots == 0 then
            o.fireDelay = o.fireDelay-1
            if o.fireDelay >= 0 then return end
            o.fireDelay,o.shots = 0x20,7
            o.fireAim = program.angle8(o.h,o.l,o.run.player,0x80)
        end
        o.fireClock = o.fireClock-1
        if o.fireClock >= 0 then return end
        o.fireClock = 4
        local b = bullets.emit(o,13,6-o.shots,o.fireAim,0,0,true)
        if b then b.origin = o.boss end
        o.shots = o.shots-1
        if o.shots ~= 0 then return end
        o.volleys = o.volleys-1
        if o.volleys == 0 then o.mode,o.shots = 0,nil end
    end

    local function sweepShot(o,kind,modifier,angle,offsets)
        local h,l = program.addPacked(0,0,offsets[floor(band(angle+2,0xfc)/4)+1])
        local bullet = bullets.emit(o,kind,modifier,angle,h,l,true)
        if bullet then bullet.origin = o.boss end
    end

    -- 0x18aef6 跟随偏航瞄准，载体折返后改为沿相反方向扫射。
    local function sweep(o)
        local muzzle = program.dualCannon.muzzle
        if not o.sweepClock then
            o.fireAim,o.sweepClock,o.sweepGap = o.angle,0,2
            o.sweepSign = o.mount.index == 1 and 1 or -1
        end
        o.sweepClock = o.sweepClock-1
        if o.sweepClock >= 0 then return end
        o.sweepClock = o.sweepGap
        local aim = o.fireAim
        if not o.mount.reversed then
            if o.run.player and o.run.player.active then
                local target = program.angle8(o.h,o.l,o.run.player,aim)
                local delta = band(target-aim+128,255)-128
                aim = band(aim+math.max(-4,min(4,delta)),255)
                sweepShot(o,6,-1,aim,muzzle)
                sweepShot(o,6,-1,aim-0x2e*o.sweepSign,muzzle)
            end
            o.fireAim = band(aim+o.sweepSign,255)
            return
        end
        if not o.sweepReversed then
            o.sweepReversed,o.sweepClock,o.sweepGap = true,0x40,1
        else
            local reverse = band(aim+0x80,255)
            if aim >= 0x38 and aim <= 0xc8 then
                for speed = -3,-5,-1 do sweepShot(o,14,speed,aim,program.mid1.ringOffsets) end
            end
            if reverse >= 0x38 and reverse <= 0xc8 then
                for speed = -5,-3 do sweepShot(o,14,speed,reverse,muzzle) end
            end
        end
        o.fireAim = band(aim+9*o.sweepSign,255)
    end

    -- 0x18b0b8 拆解时关判定，碎片沿原机臂所在的位置向外散出。
    local function destroy(o)
        local run = o.run
        if not o.deathClock then
            o.flags,o.second.flags = 0x8000,0x8000
            o.deathClock,o.deathCount,o.mode = 2,7,0x10
            effects.emit(o,0x85,0,0,0,true)
            for i = 0,5 do
                local kind,base,delay = 0x8b,8,i*4
                if i>=2 then kind,base,delay = 11,0x18,(i-1)*2 end
                local speed = base+band(program.random(run,program.randomByte),15)
                local angle = program.random(run,program.randomNarrow)*4
                effects.emit(o,kind,speed,angle,0,false,delay)
            end
        end
        o.deathClock = o.deathClock-1
        if o.deathClock < 0 then
            o.deathClock,o.deathCount = 4,o.deathCount-1
            local speed = 4+band(program.random(run,program.randomByte),7)
            local angle = 0x80+program.random(run,program.randomNarrow)*4
            effects.emit(o,6,speed,angle,0,true)
        end
        if o.deathCount>0 then return true end
        o.mount.arm = nil
        return false
    end

    function M.step(o)
        if o.boss.armDestroyed then
            if o.run.freeze then return true end
            return destroy(o)
        end
        local mount = o.mount
        if o.impact or o.second.impact then
            o.impact,o.second.impact = nil,nil
            o.flags,o.second.flags = band(o.flags,0xa6ff),band(o.second.flags,0xa6ff)
            o.hp,o.second.hp,o.damage,o.second.damage = 0x7fff,0x7fff,0,0
            o.palette = bxor(o.palette,0xe)
        else o.palette = 17 end
        if not o.run.freeze then
            o.h,o.l,o.angle = mount.h,mount.l,mount.angle
            o.second.h,o.second.l = o.h,o.l
            if o.sweepClock then
                local inside = band(o.l+o.run.cameraOffset+0x1c00,0xffff) < 0x7000
                    and band(o.h+0x800,0xffff) < 0x8000
                if not inside and o.seen then
                    mount.arm = nil
                    return false
                end
                o.seen = o.seen or inside
            end
            if o.mode == 4 then deploy(o)
            elseif o.mode == 8 then burst(o)
            elseif o.mode == 12 then sweep(o) end
        end
        o.drawFrame = (o.drawFrame+1)%8
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if not assets or o.mode>=0x10 then return end
        local angle = floor(o.angle/8)
        local image = assets.sprites[program.boss1.arms[o.palette][angle*8+o.drawFrame+1]]
        local x,y = program.world(o.h-0x800,o.l-0x500)
        local scale = o.mode == 4 and min(1,0.5+o.scale/0x78) or 1
        Render(image[1],floor(x)+image[2]/2,floor(y)+image[3]/2,0,angle>16 and -scale or scale,scale)
    end

    return M
end
