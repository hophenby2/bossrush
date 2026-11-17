-- 0x19b284 的攻击槽保留各自的预备计时和炮口。炮口偏移与弹角分别取值。
return function(program,bullets,tasks)
    local band = require('bit').band
    local floor = math.floor
    local s16,s8 = program.s16,program.s8
    local data = program.boss4
    local H = {}
    local cannon = {0xe7000780,0xe6fff880,0xeec00480,0xeebffb80}

    local function clock(t,key,reload)
        t[key]=t[key]-1
        if t[key]>=0 then return false end
        t[key]=reload
        return true
    end

    local function emit(o,kind,speed,angle,offset,base,precise)
        local h,l=o.h,o.l
        if base then h,l=program.addPacked(h,l,base) end
        bullets.emit(o,kind,speed,angle,s16(h-o.h+floor(offset/0x10000)),s16(l-o.l+offset),precise~=false)
    end

    local function muzzle(angle)
        return program.twinTankShotOffsets[floor(band(angle+2,0xfc)/4)+1]
    end

    local function aim(o,offset,default)
        return program.angle8(s16(o.h+floor(offset/0x10000)),s16(o.l+offset),o.run.player,default)
    end

    local function entry(init,step)
        return {function(o,t) init(o,t); step(o,t) end,step}
    end

    local function close(o,t) o.attacks[t.slot]=nil end

    -- 0x19b354 的炮位为普通六位弹角，两颗炮弹共用同一出生口。
    H[0]=entry(function(_,t) t.clock=0 end,function(o,t)
        if not clock(t,'clock',8) then return end
        for _,offset in ipairs({0xd7000000,0xd7000600,0xd6fffa00,0xd7000b00,0xd7000b00}) do
            emit(o,0,0,0x80,offset,nil,false)
        end
    end)

    H[1]=entry(function(_,t)
        t.wait,t.left,t.turn=0,0,2
    end,function(o,t)
        if t.left==0 then
            if not clock(t,'wait',0x18) then return end
            t.left,t.offset,t.turn=7,0,-t.turn
        end
        o.gunAim[1],o.gunAim[2]=band(0x77+t.offset,255),band(0x89-t.offset,255)
        emit(o,6,-4,o.gunAim[1],cannon[1])
        emit(o,6,-4,o.gunAim[2],cannon[2])
        t.offset,t.left=t.offset+t.turn,t.left-1
        if t.left~=0 then return end
        t.bursts=t.bursts-1
        if t.bursts==0 then close(o,t) end
    end)

    H[2]=entry(function(_,t)
        t.wait,t.clock,t.left,t.turn=0,0,0,4
    end,function(o,t)
        if t.left==0 then
            if not clock(t,'wait',8) then return end
            t.left,t.offset,t.turn=0x14,0,-t.turn
        end
        if not clock(t,'clock',6) then return end
        o.gunAim[3],o.gunAim[4]=band(0x80+t.offset,255),band(0x80-t.offset,255)
        emit(o,13,0,o.gunAim[3],cannon[3])
        emit(o,13,-4,o.gunAim[3]-0x10,cannon[3])
        emit(o,13,0,o.gunAim[4],cannon[4])
        emit(o,13,-4,o.gunAim[4]+0x10,cannon[4])
        t.offset,t.left=t.offset+t.turn,t.left-1
    end)

    H[3]=entry(function(_,t)
        t.wait,t.clock,t.port,t.left=0x40,0,1,0
    end,function(o,t)
        if t.left==0 then
            if not clock(t,'wait',0x60) then return end
            t.left,t.angle=4,0x40
        end
        if not clock(t,'clock',8) then return end
        for side,ports in ipairs({data.staggeredLeft,data.staggeredRight}) do
            local angle=side==1 and t.angle or -t.angle
            for _,step in ipairs({3,-3}) do
                for i=0,5 do emit(o,0x19,-2*i,angle+step*i,ports[t.port]) end
            end
        end
        t.port,t.angle,t.left=t.port+1,t.angle+0x18,t.left-1
        if t.left==0 then close(o,t) end
    end)

    H[4]=entry(function(_,t)
        local left=t.reverse
        t.wait,t.clock,t.left,t.width=0x30,0,0,10
        t.ports,t.speed,t.pattern,t.angleStep=left and 7 or 1,1,0,left and -1 or 1
        t.reload,t.pause=3,0xc
    end,function(o,t)
        local port=data.crossingPorts[t.ports]
        if t.left==0 then
            if not clock(t,'wait',t.pause) then return end
            t.left,t.reload,t.speedNow,t.angle=t.reload,t.reload+1,t.speed,aim(o,port,t.angle or 0)
        end
        if not clock(t,'clock',3) then return end
        local offsets={0}
        if t.pattern==0 then
            offsets={-floor(t.width/2),floor(t.width/2)}
        else
            for i=1,t.pattern do offsets[#offsets+1]=-t.width*i end
            for i=1,t.pattern do offsets[#offsets+1]=t.width*i end
        end
        for _,offset in ipairs(offsets) do
            local angle=t.angle+offset
            emit(o,14,t.speedNow,angle,muzzle(angle),port)
        end
        t.angle,t.left=t.angle+t.angleStep,t.left-1
        if t.left~=0 then return end
        t.angleStep,t.ports,t.pattern=-t.angleStep,t.ports+1,t.pattern+1
        if t.pattern==3 then t.wait,t.pause,t.width,t.speed=0x18,5,12,t.speed+0xb end
        if t.pattern==6 then close(o,t) end
    end)

    H[5]=entry(function(_,t)
        t.wait,t.clock,t.left=0,0,0
    end,function(o,t)
        if t.left==0 then
            if not clock(t,'wait',0x14) then return end
            t.left,t.angle=3,aim(o,0xd7000000,t.angle or 0)
        end
        if not clock(t,'clock',3) then return end
        emit(o,15,2,t.angle,0xd7000000)
        t.left=t.left-1
    end)

    local function steer(t,index,limit)
        local angle,step=t.angles[index],t.turns[index]
        angle=angle+step
        t.angles[index]=angle
        if step<0 and angle<=-limit or step>0 and angle>=limit then t.turns[index]=-step end
    end

    H[7]=entry(function(o,t)
        local a=band(program.random(o.run,program.randomByte),15)
        t.clock,t.angles,t.turns=0,{a,a},{4,4}
    end,function(o,t)
        if not clock(t,'clock',0xa) then return end
        local ports={data.staggeredRight,data.staggeredLeft}
        local angles={{0xe0,0xd0,0xb0,0xa0},{0x20,0x30,0x50,0x60}}
        for side=1,2 do
            if not o.broken[side] then
                for i,offset in ipairs(ports[side]) do emit(o,13,-2,angles[side][i]+t.angles[side],offset) end
            end
            steer(t,side,0x10)
        end
    end)

    H[8]=entry(function(o,t)
        local a=band(program.random(o.run,program.randomByte),7)
        t.wait,t.clock,t.left,t.angles,t.turns=0,0,0,{a,a},{1,1}
    end,function(o,t)
        local ports={{0xf97ff600,0xf4fff600},{0xf9800a00,0xf5000a00}}
        local aimed={{0xd0+t.angles[1],0xb0-t.angles[1]},{0x30+t.angles[2],0x50+t.angles[2]}}
        if t.left==0 then
            if not clock(t,'wait',0xc) then return end
            t.left=6
            for side=1,2 do
                if not o.broken[side+2] and o.broken[side] then
                    local step=side==1 and 6 or -6
                    for port,offset in ipairs(ports[side]) do
                        for i=0,3 do emit(o,13,-6,aimed[side][port]+step*i,offset) end
                    end
                end
            end
        end
        if not clock(t,'clock',2) then return end
        for side=1,2 do
            if not o.broken[side+2] then
                for port,offset in ipairs(ports[side]) do emit(o,14,0,aimed[side][port],offset) end
            end
            steer(t,side,0xc)
        end
        t.left=t.left-1
    end)

    H[9]=entry(function(o,t)
        t.clock,t.lead,t.speed=0,0xa,0
        local target={active=true,h=0,l=o.l>=0x1c00 and 0x3800 or 0}
        t.aim={}
        for i,offset in ipairs(cannon) do
            local dl=i==3 and t.aim[2] or s16(offset)
            t.aim[i]=program.angle8(s16(o.h+floor(offset/0x10000)),s16(o.l+dl),target,0x80)
        end
    end,function(o,t)
        if not clock(t,'clock',3) then return end
        if t.lead>0 then t.lead=t.lead-1
        else
            for i,offset in ipairs(cannon) do
                local angle=t.aim[i]
                local delta=s8(aim(o,offset,angle)-angle)
                if delta~=0 then angle=band(angle+(delta>0 and 1 or -1),255) end
                t.aim[i],o.gunAim[i]=angle,angle
            end
        end
        if o.h<=0x800 then return end
        for i,offset in ipairs(cannon) do emit(o,15,t.speed,t.aim[i],offset) end
        t.speed=t.speed+1
    end)

    local function rearShot(o,kind,speed,angle,offset)
        local rear=o.rear
        bullets.emit(o,kind,speed,angle,s16(rear.h-o.h+floor(offset/0x10000)),s16(rear.l-o.l+offset),true)
    end

    H[6]=entry(function(_,t)
        t.clock,t.width,t.angle,t.turn=0,0x80,0,1
    end,function(o,t)
        if not clock(t,'clock',1) then return end
        local width,angle=t.width,t.angle
        emit(o,14,0x18,angle+width,0x00800980)
        emit(o,14,0x18,angle-width,0x007ff680)
        rearShot(o,14,0x18,0x80+angle-width,0xf5000b00)
        rearShot(o,14,0x18,0x80+angle+width,0xf4fff500)
        t.width=math.max(0x14,width-2)
        if t.width==0x14 then
            t.angle=angle+t.turn
            if t.angle==0xc or t.angle==-0xc then t.turn=-t.turn end
        end
    end)

    local function rearAim(o,dh,dl)
        return program.angle8(s16(o.rear.h+dh),s16(o.rear.l+dl),o.run.player,0x80)
    end

    H[12]=entry(function(_,t)
        t.clock=0x20
    end,function(o,t)
        if not clock(t,'clock',0x10) or o.h<=0x400 then return end
        local h,l=program.addPacked(o.h,o.l,0xd7000000)
        local queue=o.run.spawnQueue
        queue[#queue+1]={[3]=0x72,[4]=0,[10]=0x19cf9e,owner=o,h=h,l=l}
    end)

    local function spawnReturnRing(o,speed,angle)
        local h,l=program.addPacked(o.h,o.l,0xea800000)
        local queue=o.run.spawnQueue
        queue[#queue+1]={[3]=0x73,[4]=0,[10]=0x19da78,owner=o,h=h,l=l,speed=speed,angle=angle}
    end

    H[14]=entry(function(o,t)
        local right=o.l>=0x1c00
        t.wait,t.ringClock,t.turnClock,t.shotClock=0x20,0x40,0,0
        t.direction,t.turn=right and 0x10 or 0xf0,right and -1 or 1
        t.speed,t.period=0x20,2
        o.returnRingAlternate=false
    end,function(o,t)
        if t.wait then
            if clock(t,'wait',0) then t.wait,t.speed=nil,0xc end
        end
        if not t.wait then
            if not o.returnRingAlternate and clock(t,'ringClock',0x18) then
                spawnReturnRing(o,0x1b,t.direction)
                t.period=5
            end
            if clock(t,'turnClock',1) then t.direction=t.direction+t.turn end
        end
        if not clock(t,'shotClock',t.period) then return end
        emit(o,6,t.speed,t.direction-1,0xea800000)
        emit(o,6,t.speed,t.direction,0xea800000)
    end)

    H[15]=entry(function(o,t)
        t.wait,t.ringClock,t.turnClock,t.shotClock,t.rings=0x10,0x40,0,0,2
        t.direction,t.turn=0x80,o.l>=0x1c00 and 1 or -1
        t.period=2
    end,function(o,t)
        if t.wait then
            if clock(t,'wait',0) then t.wait,t.period=nil,0xa end
        end
        if not t.wait then
            if o.returnRingAlternate and clock(t,'ringClock',0x14) then
                spawnReturnRing(o,0x1b,t.direction)
                t.rings=t.rings-1
                if t.rings==0 then
                    o.returnRingAlternate,t.rings,t.ringClock=false,2,0x40
                end
            end
            if clock(t,'turnClock',3) then t.direction=t.direction+t.turn end
        end
        if not clock(t,'shotClock',t.period) then return end
        emit(o,6,7,t.direction-1,0xea800000)
        emit(o,6,7,t.direction+1,0xea800000)
    end)

    H[16]=entry(function(o,t)
        t.clock,t.left=0,4
        t.direction,t.turn=8,2
        if o.l>=0x1c00 then t.direction,t.turn=-8,-2 end
    end,function(o,t)
        if not clock(t,'clock',0x40) then return end
        if not o.run.stopPathClock then
            local h,l=program.addPacked(o.h,o.l,0xfb000000)
            local queue=o.run.spawnQueue
            queue[#queue+1]={[3]=0x74,[4]=0,[10]=0x19d312,h=h,l=l,owner=o,
                direction=t.direction,turn=t.turn}
        end
        t.turn,t.left=-t.turn,t.left-1
        if t.left==0 then close(o,t) end
    end)

    H[17]=entry(function(_,t) t.clock,t.rear=0,true end,function(o,t)
        if not clock(t,'clock',0x10) then return end
        local h,l,offset,fire
        if t.rear then
            h,l,offset,fire=o.rear.h,o.rear.l,0xfe000000,rearShot
        else
            h,l,offset,fire=o.h,o.l,0xfb000000,emit
        end
        h,l=program.addPacked(h,l,offset)
        local a=program.angle8(h,l,o.run.player,0x80)+program.random(o.run,program.randomNarrow)
        for _,delta in ipairs({0,0x14,0x28,-0x14,-0x28}) do fire(o,21,-8,a+delta,offset) end
        t.rear=not t.rear
    end)

    H[18]=entry(function(o,t)
        t.clock,t.left=0x40,3
        t.turn=data.droneWaveNoise[program.nextRandom(o.run)]<0 and -1 or 1
        tasks.attach(o.attacks,24)
    end,function(o,t)
        if not clock(t,'clock',0xa0) then return end
        local h,l=program.addPacked(o.rear.h,o.rear.l,-0x1000*t.turn)
        local queue=o.run.spawnQueue
        queue[#queue+1]={[3]=0x75,[4]=0,[10]=0x19edb8,owner=o,h=h,l=l,direction=0x28*t.turn}
        t.turn,t.left=-t.turn,t.left-1
        if t.left==0 then close(o,t) end
    end)

    H[19]=entry(function(_,t) t.clock,t.turn=0,1 end,function(o,t)
        if not clock(t,'clock',0x30) then return end
        local h,l=program.addPacked(o.rear.h,o.rear.l,-0x1000*t.turn)
        local queue=o.run.spawnQueue
        queue[#queue+1]={[3]=0x77,[4]=0,[10]=0x19f156,owner=o,h=h,l=l,turn=t.turn}
        t.turn=-t.turn
    end)

    H[20]=entry(function(_,t) t.wait,t.clock,t.left,t.side=0,0,0,1 end,function(o,t)
        if t.left==0 then
            if not clock(t,'wait',6) then return end
            t.left=4
            t.rightAim=rearAim(o,0xc00,0xc00)
            t.leftAim=rearAim(o,-0xc00,-0xc00)
        end
        if not clock(t,'clock',2) then return end
        if t.side<0 then rearShot(o,6,0,t.rightAim,0xc00)
        else rearShot(o,6,0,t.leftAim,-0xc00) end
        t.left=t.left-1
        if t.left==0 then t.side=-t.side end
    end)

    H[21]=entry(function(_,t)
        t.clock,t.turn,t.speedCount,t.shots,t.waves=0x10,8,5,0x10,2
    end,function(o,t)
        if not clock(t,'clock',8) then return end
        if not t.angle then t.angle=rearAim(o,-0x200,0)-t.turn*(floor(t.shots/2)+1) end
        for i=0,t.speedCount-1 do rearShot(o,11,-12+3*i,t.angle,0xfe000000) end
        t.angle,t.shots=t.angle+t.turn,t.shots-1
        if t.shots>0 then return end
        t.shots,t.turn,t.angle,t.speedCount,t.waves=0x10,-t.turn,nil,t.speedCount+2,t.waves-1
        if t.waves==0 then close(o,t) end
    end)

    H[22]=entry(function(_,t) t.clock,t.left=0,6 end,function(o,t)
        if not clock(t,'clock',0x1c) then return end
        local h,l=s16(o.rear.h+0x1b80),o.rear.l
        local angle=rearAim(o,0x1b80,0)+program.random(o.run,program.randomNarrow)
        local queue=o.run.spawnQueue
        queue[#queue+1]={[3]=0x78,[4]=0,[10]=0x19de96,h=h,l=l,angle=angle}
        t.left=t.left-1
        if t.left==0 then close(o,t) end
    end)

    H[23]=entry(function(_,t)
        t.wait,t.waveWait,t.clock,t.left,t.count,t.turn=0x60,0x40,0,0,2,1
    end,function(o,t)
        if o.run.stopPathClock then return end
        if t.left==0 then
            if not clock(t,'wait',t.waveWait) then return end
            t.left,t.count=t.count,math.min(0x7f,t.count+1)
            t.waveWait=math.max(0,t.waveWait-0x20)
        end
        if not clock(t,'clock',0x1c) then return end
        local dh,dl=s16(o.rear.h-o.h+0x800),s16(o.rear.l-o.l)
        bullets.emit(o,0x1d,-0x14,t.turn>0 and 0xc0 or 0x40,dh,dl,true,0x10)
        t.turn,t.left=-t.turn,t.left-1
    end)

    H[24]=entry(function(_,t)
        t.wait,t.clock,t.left,t.count,t.wave=0x10,0,0,6,1
    end,function(o,t)
        if t.left==0 then
            if not clock(t,'wait',0) then return end
            t.left=t.count
        end
        if not clock(t,'clock',0xe) then return end
        local angle=rearAim(o,-0x200,0)
        rearShot(o,11,-3,angle,0xfe000000)
        if t.wave==2 then
            rearShot(o,11,-3,angle+0x14,0xfe000000)
            rearShot(o,11,-3,angle-0x14,0xfe000000)
        elseif t.wave==3 then
            for _,delta in ipairs({0xa,0x14,-0xa,-0x14}) do
                rearShot(o,11,-3,angle+delta,0xfe000000)
            end
        end
        t.left=t.left-1
        if t.left~=0 then return end
        t.wave,t.count=t.wave+1,t.count*2
        if t.wave==4 then close(o,t) end
    end)

    return H,cannon
end
