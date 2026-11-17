-- E4 拆去外翼后露出核心。E15 在十六个布置点就位后才开放横贯弹。
return function(program,art,effects,tasks,events,attacks,moveTo,emit)
    local band=require('bit').band
    local floor=math.floor
    local data=program.boss6

    local function crossing(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        t.clock=0x13
        for _,side in ipairs({1,-1}) do
            local aim=side==1 and t.right or t.left
            local l=side==1 and 0x37c0 or 0
            for i=0,7 do
                local h=0xb00+i*0xc00
                local dh,dl=program.s16(h-o.h),band(l-o.l,0xffff)
                emit(o,0x22,-12+i,aim+side*i*t.spread,dh*0x10000+dl)
            end
        end
        if t.swivel then
            t.right,t.left=t.right+t.rightStep,t.left+t.leftStep
            if t.right>=0xe4 or t.right<=0xb4 then t.rightStep=-t.rightStep end
            if t.left>=0x64 or t.left<=0x34 then t.leftStep=-t.leftStep end
        end
        t.groups=t.groups-1
        if t.groups>=0 then return end
        t.groups=3
        if t.swivel then t.spread=math.min(4,t.spread+1) else t.swivel=true end
    end
    attacks[9]={function(o,t)
        program.nextRandom(o.run)
        local turn=program.random(o.run,program.randomByte)<0x80 and 1 or -1
        t.right,t.left,t.rightStep,t.leftStep=0xc0,0x40,turn,turn
        t.clock,t.groups,t.spread,t.swivel=0x20,4,0,false
        crossing(o,t)
    end,crossing}

    local function open(o,t)
        t.clock=t.clock-1
        if t.clock>=0 then return end
        if t.phase==0 then
            o.coreVisible,o.coreAura,o.coreAge=true,true,0
            t.phase,t.clock=1,0x7f
        else
            tasks.attach(o.events,15)
            o.events[t.slot]=nil
        end
    end
    events[4]={function(o,t)
        o.recoil,o.recoilAngle=0x18,program.random(o.run,program.randomNarrow)
        o.speed=0
        moveTo(o,0x5600,0x1c00,2)
        t.phase,t.clock=0,0
    end,open}

    local function core(o,t)
        t.clock=t.clock-1
        if t.clock>0 then return end
        if t.phase==0 then
            o.coreAura,o.coreOpening=false,0
            t.phase,t.clock=1,0xf
        elseif t.phase==1 then
            local run=o.run
            for i=1,16 do
                local packed=data.finalCoreShards[i]
                local h,l=program.addPacked(0,0,packed)
                run.spawnQueue[#run.spawnQueue+1]={0,0,0x4b,0,0,0,0,0,0,0x1a78ac,
                    h=o.h,l=o.l,targetH=h,targetL=l}
            end
            o.protected=false
            t.phase,t.clock=2,0x3f
        elseif t.phase==2 then
            tasks.attach(o.attacks,9)
            o.coreOpening=23
            o.events[t.slot]=nil
        end
    end
    events[15]={function(o,t)
        o.run.bulletCapacity=200
        o.run.centerCamera=true
        o.coreAura=true
        moveTo(o,0x5a00,0x1c00,1)
        t.phase,t.clock=0,31
    end,core}

    local function dust(run)
        return program.hovercraftRandom[program.nextRandom(run,127)]
    end

    local function blast(o,kind,speed,angle,h,l)
        effects.emit({run=o.run,h=h,l=l},kind,speed,angle,0,false,0)
    end

    local function smallBlast(o)
        local run=o.run
        local l=floor(dust(run)/4)
        local h=o.h-0x600+floor(dust(run)/4)
        local angle=2*program.random(run,program.randomNarrow)
        local speed=2+band(program.random(run,program.randomByte),7)
        blast(o,0x13,speed,angle,h,o.l+l+floor(l/2))
    end

    local function largeBlast(o)
        local run=o.run
        local index=band(program.random(run,program.randomByte),7)+1
        local speed=0x14+program.s8(program.random(run,program.randomNarrow))
        local angle=program.random(run,program.randomByte)
        local h=2*program.debrisOffsets[program.nextRandom(run,63)][1]
        local l=2*program.debrisOffsets[program.nextRandom(run,63)][1]
        blast(o,data.finalCoreBlast[index],speed,angle,o.h+program.s16(h),o.l+program.s16(l))
    end

    local function death(o,t)
        t.age=t.age+1
        o.coreDeath=t.age
        if t.age>=10 and t.age<268 and (t.age-10)%4==0 then largeBlast(o) end
        if t.age>=318 then
            if t.age%2==0 then smallBlast(o) end
            if t.age%4==0 then largeBlast(o) end
        end
        if t.closingClock then
            -- 0x1a1c94 的停机等待和末次调色合计 0x21c 帧，取自 V100 的停机采样。
            t.closingClock=t.closingClock-1
            if t.closingClock==0 then
                o.run.stageFlags[0]=false
                o.run.stageCleared=true
            end
        elseif t.age>=322 and o.speed==0 then
            t.closingClock=0x21c
        end
    end
    events[5]={function(o,t)
        o.move={kind=1,init=true,target={active=true,h=0x3a00,l=0x1c00}}
        t.age=-1
        death(o,t)
    end,death}

    local function render(o)
        local images,sprites=data.images,o.run.art.sprites
        local suffix=o.tint or ''
        local frame=floor(o.coreAge/2)%16+1
        if o.coreOpening then
            local row=images['finalCoreOpen'..suffix][o.coreOpening+1]
            local h,l=program.addPacked(o.h,o.l,row[2])
            art.draw(sprites[row[1]],h,l,0,0)
        else
            art.draw(sprites[images['finalCore'..suffix][frame]],o.h,o.l,-0xe00,-0x700)
        end
        if o.coreAura then
            local aura=sprites[images.finalCoreAura[floor(o.coreAge/2)%32+1]]
            art.draw(aura,o.h,o.l,-0x1400,-0xd00)
        end
        if o.coreDeath and o.coreDeath<10 then
            local flash=sprites[images.finalCoreFlash[o.coreDeath+1]]
            art.draw(flash,o.h,o.l,0,-0x1c00)
            art.draw(flash,o.h,o.l,-0x3800,-0x1c00,true)
        end
    end

    return render
end
