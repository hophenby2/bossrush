-- 0x189e80 从旋转挂点取目标，每架护航机独立移动、切换射击和处理判定。
return function(program,bullets,art,effects,mounts)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor,min,max = math.floor,math.min,math.max
    local s16 = program.s16
    local data = program.boss1
    local coreOffsets = program.boss1Core.escortOffsets
    local M = {parts=3}

    function M.init(o)
        local row = o.row
        o.boss,o.mount,o.h,o.l = row.boss,row.mount,row.h,row.l
        o.angle,o.direction,o.drawFrame,o.palette = 0,0,0,17
        o.flags,o.front,o.back,o.right,o.left,o.hp = 0xa001,0x300,0x300,0x200,0x200,0x7fff
        o.second = {flags=0xa000,h=o.h,l=o.l,front=0x700,back=0x700,right=0x580,left=0x580,hp=0x7fff}
        o.extraParts = {o.second,{flags=0,h=o.h,l=o.l}}
        o.mount.escort = o
        return true
    end

    local function move(o,speed,direction)
        local h,l = program.vector(speed,direction,o.run.slowVectors)
        o.h,o.l = s16(o.h+h),s16(o.l+l)
    end

    local function approach(o,h,l)
        local distance = mounts.distance(o,h,l)
        local speed = mounts.speed(distance,data.escortSpeeds,0x18)
        o.direction = program.angle8(o.h,o.l,{h=h,l=l,active=true},o.direction)
        move(o,speed,o.direction)
        return distance
    end

    local function rotate(o,target,maxStep)
        local delta = program.s8(target-o.angle)
        o.angle = band(o.angle+max(-maxStep,min(maxStep,delta)),255)
    end

    local function fire(o)
        o.fireClock = o.fireClock-1
        if o.fireClock >= 0 then return end
        o.fireClock = 8
        local angle = band(o.angle,0xfe)
        bullets.emit(o,14,-5,angle,0,0,true)
        bullets.emit(o,14,-6,angle+0x80,0,0,true)
    end

    local function burst(o)
        if o.shots == 0 then
            o.rest = o.rest-1
            if o.rest >= 0 then return end
            o.rest,o.shots,o.count,o.modifier = 0x30,o.count,o.count+1,-4
            o.aim = program.angle8(o.h,o.l,o.run.player,0x80)
        end
        o.fireClock = o.fireClock-1
        if o.fireClock >= 0 then return end
        o.fireClock = 1
        local step = o.mount.index==2 and 2 or 1
        for ray = -1,1,step do
            local angle = o.aim+ray*0x18
            local h,l = program.addPacked(0,0,program.dualCannon.muzzle[floor(band(angle+2,0xfc)/4)+1])
            bullets.emit(o,13,o.modifier,angle,h,l,true)
        end
        o.shots,o.modifier = o.shots-1,o.modifier+2
    end

    -- 0x18a6ec 先各自飞到核心挂点，0x18a750 到位后才逐帧锁定相对位置。
    local function followCore(o,mount)
        local core = o.boss.core
        local dh,dl = unpack(coreOffsets[mount.index])
        local h,l = s16(core.h+dh),s16(core.l+dl)
        mount.depth = mount.depth-max(-0x80,min(0x80,mount.depth))
        rotate(o,0,3)
        if o.mode == 20 then o.h,o.l = h,l
        elseif approach(o,h,l) <= 0x100 then mount.mode = 20 end
    end

    local function breakEscort(o)
        local run = o.run
        if not o.deathClock then
            o.flags,o.second.flags,o.mount.escort = 0x8000,0x8000,nil
            o.deathClock,o.deathCount,o.deathSpeed = 2,7,0
            effects.emit(o,0x85,0,0,0,true)
            local fragments = o.boss.escortsVisible and 6 or 2
            for index = 0,fragments-1 do
                local kind,base,delay = 0x8b,8,index*4
                if index >= 2 then kind,base,delay = 11,0x18,(index-1)*2 end
                local speed = base+band(program.random(run,program.randomByte),15)
                effects.emit(o,kind,speed,program.random(run,program.randomNarrow)*4,0,true,delay)
            end
            move(o,o.deathSpeed,0x80)
            return true
        end
        o.deathClock = o.deathClock-1
        if o.deathClock < 0 then
            o.deathClock,o.deathCount,o.deathSpeed = 4,o.deathCount-1,o.deathSpeed+1
            local speed = 4+band(program.random(run,program.randomByte),7)
            effects.emit(o,6,speed,0x80+program.random(run,program.randomNarrow)*4,0,false)
        end
        move(o,o.deathSpeed,0x80)
        return o.deathCount > 0
    end

    function M.step(o)
        local mount = o.mount
        if o.boss.dying then
            if o.run.freeze then return true end
            return breakEscort(o)
        end
        o.palette = 17
        if o.impact or o.second.impact then
            o.impact,o.second.impact = nil,nil
            o.flags,o.second.flags = band(o.flags,0xa6ff),band(o.second.flags,0xa6ff)
            o.hp,o.second.hp,o.damage,o.second.damage = 0x7fff,0x7fff,0,0
            o.palette = bxor(o.palette,0xe)
        end
        if not o.run.freeze then
            if o.mode ~= mount.mode then
                o.mode,o.fireClock,o.rest,o.shots,o.count = mount.mode,0,0,0,3
            end
            if o.mode == 4 then
                o.angle = band(o.angle+mount.yawStep,255)
                if approach(o,mount.h,mount.l) <= 0x100 then mount.mode = 0 end
            elseif o.mode == 16 or o.mode == 20 then
                followCore(o,mount)
            else
                if o.mode == 12 then fire(o)
                elseif o.mode == 8 then burst(o) end
                rotate(o,mount.yaw,1)
                approach(o,mount.h,mount.l)
            end
            o.second.h,o.second.l = o.h,o.l
        end
        local visible = o.boss.escortsVisible
        if o.visible ~= visible then
            o.visible = visible
            o.flags,o.second.flags = visible and 0xa001 or 0x8000,visible and 0xa000 or 0x8000
        end
        if visible then o.drawFrame = (o.drawFrame+1)%8 end
        return true
    end

    function M.render(o)
        if not o.visible or o.deathClock or not o.run.art then return end
        local angle = floor(o.angle/8)
        local image = data.arms[o.palette][angle*8+o.drawFrame+1]
        art.draw(o.run.art.sprites[image],o.h,o.l,-0x800,-0x500,angle>16)
    end

    return M
end
