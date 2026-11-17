-- 0x1b99f0 的六个攻击入口分别持有波次时钟与瞄准角。
return function(program,bullets,tasks)
    local band = require('bit').band
    local floor,min = math.floor,math.min
    local data,s16,s8 = program.mid4,program.s16,program.s8
    local attach,stop = tasks.attach,tasks.stop
    local attacks = {}

    local function clock(t,key,reload)
        t[key] = t[key]-1
        if t[key]>=0 then return false end
        t[key] = reload
        return true
    end

    local function word(row,i)
        return s16(row[i]*256+row[i+1])
    end

    local function emit(o,kind,speed,angle,offset,center)
        local h,l = o.h,o.l
        if center then h,l = program.addPacked(h,l,center) end
        bullets.emit(o,kind,speed,angle,s16(h-o.h+floor(offset/0x10000)),s16(l-o.l+offset),true)
    end

    local function muzzle(table,angle)
        return table[floor(band(angle+2,0xfc)/4)+1]
    end

    local function cannonFan(row,index,kind)
        return {
            function(o,t)
                local tune = o.tune[index]
                t.clock,t.period,t.pause = row[1],row[7]-tune.period,row[8]
                t.count,t.reload = word(row,3)+tune.length,word(row,5)+tune.length
                t.waves,t.speed = row[9]+tune.waves,word(row,11)+tune.speed
            end,
            function(o,t)
                if not clock(t,'clock',t.period) then return end
                local step,count,spread
                if index==4 then
                    o.lockAim,step,count,spread = true,0x14,5,0x28
                else
                    step,count,spread = 0xd,5,0x1a
                    if t.waves%2==1 then count,spread=4,0x13 end
                end
                for side,aim in ipairs(o.cannonAim) do
                    local center = data.cannonMuzzles[floor(aim/2)+1]
                    local base = side==1 and 0x04000900 or 0x03fff700
                    local a = aim*4-spread
                    for i=0,count-1 do
                        local angle = a+i*step
                        local offset = base+muzzle(program.gunshipMainShotOffsets,angle)
                        emit(o,kind,t.speed,angle,offset,center)
                    end
                end
                if not clock(t,'count',t.reload) then return end
                o.lockAim,t.clock,t.waves = false,t.pause,t.waves-1
                if t.waves>=0 then return end
                local tune = o.tune[index]
                if index==4 then
                    tune.waves,tune.period,tune.speed = min(2,tune.waves+1),min(2,tune.period+1),min(2,tune.speed+1)
                else
                    tune.length,tune.waves,tune.period = min(2,tune.length+1),min(4,tune.waves+2),min(8,tune.period+4)
                end
                stop(o.attacks,index)
            end,
        }
    end

    attacks[0] = cannonFan(data.cannonFan,0,0x15)
    attacks[4] = cannonFan(data.aimedFan,4,6)

    attacks[1] = {
        function(o,t)
            local row,tune = data.openWingFan,o.tune[1]
            t.clock,t.period,t.pause = row[1],row[7],row[8]-tune.period
            t.count,t.reload,t.waves = word(row,3),word(row,5),row[9]+tune.waves
            t.speed,t.accel,t.aimStep,t.aimOffset = word(row,11)+tune.speed,word(row,13),row[17],row[18]
            t.aim = {}
        end,
        function(o,t)
            if not clock(t,'clock',t.period) then return end
            local p = o.run.player
            if t.count==t.reload then
                if not p or not p.active then return end
                t.aim[1] = program.angle8(s16(o.h-0x200),s16(o.l+0xd40),p,0x80)+t.aimOffset
                t.aim[2] = program.angle8(s16(o.h-0x200),s16(o.l-0xd40),p,0x80)+t.aimOffset
            end
            for side,aim in ipairs(t.aim) do
                local base = side==1 and 0xfe000d40 or 0xfdfff2c0
                -- 0x1b9cda 复用 d2 的低字节，左翼从被角度步进值覆盖的横坐标发弹。
                local center = side==2 and band(t.aimStep,255)-band(o.l,255) or nil
                for i=-3,3 do
                    local angle = aim+i*0x14
                    emit(o,0x1a,t.speed,angle,base+muzzle(program.mid1.ringOffsets,angle),center)
                end
                t.aim[side] = aim-t.aimStep
            end
            if not clock(t,'count',t.reload) then return end
            t.aimStep,t.aimOffset = -t.aimStep,-t.aimOffset
            t.aimOffset = t.aimOffset+(t.aimOffset<0 and -4 or 4)
            t.pause,t.speed = t.pause-4,t.speed<0x15 and t.speed+6 or t.speed
            t.reload = min(0xb,t.reload+t.accel)
            t.clock,t.count,t.waves = t.pause,t.reload,t.waves-1
            if t.waves>=0 then return end
            local tune = o.tune[1]
            tune.waves,tune.speed,tune.period = min(2,tune.waves+1),min(4,tune.speed+2),min(4,tune.period+2)
            stop(o.attacks,1)
            attach(o.aux,1)
        end,
    }

    attacks[2] = {
        function(o,t)
            local row,tune = data.coreFan,o.tune[2]
            local reverse = program.random(o.run,program.randomByte)>=0x80
            -- 0x1b9e20 初始化直接落入 0x1b9e24，本帧也扣一次时钟。
            t.clock,t.period,t.pause = row[1]-tune.period-1,row[7],row[8]
            t.count,t.reload,t.waves = word(row,3),word(row,5),row[9]
            t.speed,t.baseSpeed,t.longer = word(row,11)+tune.speed,word(row,19),word(row,13)
            t.turn = s8(row[16])*(reverse and -1 or 1)
            t.arrowTurn = s8(row[22])*(reverse and -1 or 1)
            t.angle = program.random(o.run,program.randomByte)
            t.arrowAngle = t.angle
        end,
        function(o,t)
            if not clock(t,'clock',t.period) then return end
            local arrow = t.count%2==1
            local angle = arrow and t.arrowAngle or t.angle
            for i=0,11 do
                local a = band(angle+i*0x15,255)
                local lo,hi = arrow and 0x50 or 0x38,arrow and 0xb0 or 0xc8
                if a>=lo and a<=hi then
                    local offset = (arrow and 0xfa000000 or 0x13000000)+muzzle(program.mid1.ringOffsets,a)
                    emit(o,arrow and 0xd or 0x16,arrow and 3 or t.speed,a,offset)
                end
            end
            t.angle,t.arrowAngle = t.angle+t.turn,t.arrowAngle-t.arrowTurn
            if not clock(t,'count',t.reload) then return end
            local sign = t.turn<0 and -1 or 1
            if t.turn~=sign then t.turn=t.turn-sign end
            t.turn,t.arrowTurn = -t.turn,-t.arrowTurn
            t.reload,t.baseSpeed = min(0x36,t.reload+t.longer),t.baseSpeed-2
            t.clock,t.count,t.speed,t.waves = t.pause,t.reload,t.baseSpeed,t.waves-1
            if t.waves>=0 then return end
            local tune = o.tune[2]
            tune.speed,tune.period = min(2,tune.speed+1),min(0x10,tune.period+2)
            stop(o.attacks,2)
            attach(o.attacks,2)
        end,
    }

    attacks[3] = {
        function(o,t)
            local row,tune = data.podFan,o.tune[3]
            t.clock,t.pause,t.count,t.reload,t.waves = row[1],row[8],word(row,3),word(row,5),row[9]+tune.waves
            t.speed,t.baseSpeed = word(row,11),word(row,19)
            t.left = program.random(o.run,program.randomByte)>=0x80
        end,
        function(o,t)
            if t.clock>0 then
                t.clock = t.clock-1
                if t.clock==0 then attach(o.aux,t.left and 3 or 2); return end
            end
            local side = t.left and 2 or 1
            if o.pod[side]~=13 then return end
            local p = o.run.player
            if p and p.active then
                local base = t.left and 0x09fffc80 or 0x0a000380
                local angle = program.angle8(s16(o.h+0xa00),s16(o.l+(t.left and -0x380 or 0x380)),p,0x80)
                local step = t.left and 1 or -1
                angle=angle-13*step
                for wave=0,5 do
                    for i=0,6 do
                        emit(o,0xd,t.speed+wave+i,angle,base+muzzle(program.mid1.ringOffsets,angle))
                        angle=angle+step
                    end
                    angle=angle+step
                end
            end
            if not clock(t,'count',t.reload) then return end
            t.baseSpeed=t.baseSpeed+1
            t.clock,t.speed,t.left,t.waves = t.pause,t.baseSpeed,not t.left,t.waves-1
            if t.waves>=0 then return end
            local tune=o.tune[3]
            tune.waves=min(2,tune.waves+1)
            stop(o.attacks,3)
        end,
    }

    attacks[5] = {
        function(o,t)
            local row,tune = data.wingFan,o.tune[5]
            t.clock,t.period,t.pause = row[1],row[7],row[8]
            t.count,t.reload,t.waves,t.speed = word(row,3)+tune.length,word(row,5)+tune.length,row[9]+tune.waves,word(row,11)+tune.speed
            t.angles,t.angleStep = {row[15],row[16]},row[17]
            t.right = program.random(o.run,program.randomByte)>=0x80
        end,
        function(o,t)
            if not clock(t,'clock',t.period) then return end
            local side,step = t.right and 1 or 2,t.right and 1 or -1
            local base = t.right and 0xf7000f80 or 0xf6fff080
            for i=0,3 do emit(o,0xe,t.speed-2*i,t.angles[side]+step*0x14*i,base-step*0x80*i) end
            t.angles[side] = t.angles[side]+step*t.angleStep
            if not clock(t,'count',t.reload) then return end
            t.angles,t.right,t.clock,t.waves = {data.wingFan[21],data.wingFan[22]},not t.right,t.pause,t.waves-1
            if t.waves>=0 then return end
            local tune = o.tune[5]
            tune.length,tune.speed,tune.waves = min(2,tune.length+1),min(2,tune.speed+1),min(4,tune.waves+2)
            stop(o.attacks,5)
        end,
    }

    return attacks
end
