-- 0x155d5a 在两条镜像路径使用同一套翼炮、中央炮和三处共血判定。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local s16,packed = program.s16,program.addPacked
    local data = program.stage4Gunship
    local H = {parts=4}

    function H.init(o)
        o.extraParts={}
        for index,box in ipairs(data.parts) do
            local part=index==1 and o or {}
            part.flags,part.front,part.back,part.right,part.left,part.hp=unpack(box)
            if index>1 then o.extraParts[index-1]=part end
        end
        if not path.attach(o,o.row) then return false end
        for _,part in ipairs(o.extraParts) do part.h,part.l=o.h,o.l end
        local state,scratch=data.state,data.scratch
        o.health,o.palette,o.rotorPalette=data.health,19,10
        o.phase,o.wing,o.rotor,o.burst=0,0,state[14]/4,0
        o.wingClock,o.rotorClock,o.rotorPeriod=state[7],state[11],state[12]
        o.prep,o.sweepClock,o.sweepPeriod=state[27],state[29],state[30]
        o.prepCannon,o.cannonClock,o.cannonPeriod=scratch[1]-o.run.tankFireRank,scratch[3],scratch[4]
        o.cannonShots,o.cannonBanks=scratch[5],scratch[7]
        o.waitCannon=scratch[9]*256+scratch[10]
        o.run.stage4Gunship=o
        return true
    end

    local function emit(o,kind,speed,angle,offset,precise)
        bullets.emit(o,kind,speed,angle,s16(floor(offset/0x10000)),s16(offset),precise)
    end

    local function animated(o,key,reload)
        o[key]=o[key]-1
        if o[key]>=0 then return false end
        o[key]=reload
        return true
    end

    local function damage(o)
        if o.dying then return end
        local hit,total=false,0
        for index=0,2 do
            local part=index==0 and o or o.extraParts[index]
            if part.impact then
                hit,total=true,total+(part.damage or 0)
                part.impact,part.damage,part.hp=nil,0,0x7fff
            end
        end
        if hit then
            o.health=o.health-band(total,0xffff)
            if o.health<0 then
                o.dying,o.speed,o.driftClock,o.deathClock,o.blastIndex=1,0,2,0x20,1
                o.direction,o.palette=0x20,19
                o.flags,o.extraParts[1].flags,o.extraParts[2].flags=0x8000,0x8000,0x8000
                effects.emitSequence(o,data.hitBlast)
                return
            end
            o.palette=bxor(o.palette==25 and 19 or o.palette,12)
            o.rotorPalette=bxor(o.rotorPalette==25 and 10 or o.rotorPalette,0x15)
        elseif o.health<0x2c00 then o.palette,o.rotorPalette=25,25
        else o.palette,o.rotorPalette=19,10 end
    end

    local function moveWings(o)
        if o.phase==0 then
            if animated(o,'wingClock',1) then
                o.wing=o.wing+1
                if o.wing==8 then o.phase,o.wing,o.wingClock=1,0,0 end
            end
        elseif o.phase==1 then
            if animated(o,'wingClock',2) then
                o.wing=o.wing+1
                if o.wing==8 then o.phase,o.wing,o.wingClock=2,0,0 end
            end
        elseif o.burst==2 and animated(o,'wingClock',2) then
            o.wing=o.wing+1
            if o.wing==8 then o.wing=4 end
        elseif o.burst~=2 and o.wing>0 and animated(o,'wingClock',2) then
            o.wing=(o.wing+1)%12
        end
    end

    local function broadside(o)
        if not o.sweep then
            if not animated(o,'prep',data.state[28]) then return end
            o.sweep,o.sweepStep=0x30,8
        end
        if not animated(o,'sweepClock',o.sweepPeriod) then return end
        for index,offset in ipairs({0xfa7ff740,0xec800480,0xfa800900,0xec7ffb80}) do
            local a=0x80+(index<=2 and o.sweep or -o.sweep)
            local shift=program.twinTankShotOffsets[floor(band(a+2,0xfc)/4)+1]
            emit(o,13,index<=2 and -4 or -3,a+0x10,offset+shift,true)
            emit(o,13,index<=2 and -4 or -3,a-0x10,offset+shift,true)
        end
        o.sweep=o.sweep+o.sweepStep
        if o.sweepStep<0 and o.sweep<=-0x30 or o.sweepStep>0 and o.sweep>=0x30 then
            o.sweepStep=-o.sweepStep
        end
    end

    local function charge(o)
        if o.cannonShots==0 then
            if not animated(o,'prepCannon',4) then return end
            o.cannonShots=data.scratch[6]
        end
        if not animated(o,'cannonClock',o.cannonPeriod) then return end
        o.cannonShots=o.cannonShots-1
        if o.cannonShots~=0 then return end
        o.cannonBanks=o.cannonBanks-1
        if o.cannonBanks>0 then return end
        o.cannonBanks,o.prepCannon,o.burst=data.scratch[7],data.scratch[2],1
    end

    local function central(o)
        local p=o.run.player
        if o.frontLeft>0 and animated(o,'frontClock',10) then
            if p and p.active then
                local a=program.angle8(s16(o.h-0x1000),o.l,p,0x80)+program.random(o.run,program.randomNarrow)
                for i=-4,4 do
                    local angle=a+7*i
                    local muzzle=program.mid1.ringOffsets[floor(band(angle+2,0xfc)/4)+1]
                    emit(o,2,5,angle,0xf0000000+muzzle,true)
                end
            end
            o.frontLeft=o.frontLeft-1
        end
        if o.roundLeft>0 and animated(o,'roundClock',2) then
            if not o.roundAim then
                o.roundAim=program.angle(s16(o.h-0x1000),o.l,p,0x20)
            end
            for _,step in ipairs({-3,3}) do
                for i=1,6 do
                    local angle=band(o.roundAim+step*i,63)
                    local h,l=packed(o.h,o.l,0xf0000000)
                    local muzzle=program.twinTankShotOffsets[angle+1]
                    local dh=s16(h-o.h+floor(muzzle/0x10000))
                    local dl=s16(l-o.l+muzzle)
                    bullets.emit(o,0x19,o.roundSpeed,angle*4,dh,dl)
                end
            end
            o.roundLeft,o.roundSpeed=o.roundLeft-1,o.roundSpeed+3
        end
        if o.frontLeft==0 and o.roundLeft==0 then
            o.burst,o.sweep=0,nil
        end
    end

    local function fire(o)
        if o.burst==0 then
            broadside(o)
            charge(o)
        end
        if o.burst==1 then
            o.waitCannon=o.waitCannon-1
            if o.waitCannon==0 then
                o.burst,o.waitCannon=2,0x28
                o.roundLeft,o.roundClock,o.roundSpeed,o.roundAim=5,0x10,-7,nil
                o.frontLeft,o.frontClock=10,0x30
            end
        end
        if o.burst==2 then central(o) end
    end

    local function death(o)
        local run=o.run
        if not run.freeze and o.speed<8 and animated(o,'driftClock',2) then o.speed=o.speed+1 end
        if not run.stopPathClock then
            local dh,dl=program.vector(o.speed,o.direction*4,run.slowVectors)
            o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        end
        if run.freeze then return true end
        if o.dying==1 then
            if not animated(o,'deathClock',4) then return true end
            effects.emitSequence(o,{data.retreatBlast[o.blastIndex]})
            o.blastIndex=o.blastIndex+1
            if o.blastIndex>#data.retreatBlast then o.dying,o.deathClock=2,0x1c end
        else
            o.deathClock=o.deathClock-1
            if o.deathClock==0 then
                effects.emitSequence(o,data.finalBlast)
                bullets.clear(run,0x40)
                return false
            end
        end
        return true
    end

    function H.step(o)
        local run=o.run
        if not o.dying and not path.step(o,-run.groundScroll) then return false end
        if band(o.h+0x1800,0xffff)<0xa000 and band(o.l+run.cameraOffset+0x1c00,0xffff)<0x7000 then
            o.seen=true
        elseif o.seen then return false end
        for _,part in ipairs(o.extraParts) do part.h,part.l=o.h,o.l end
        if o.dying then return death(o) end
        damage(o)
        if o.dying then return true end
        if animated(o,'rotorClock',o.rotorPeriod) then o.rotor=(o.rotor-1)%16 end
        if not run.freeze and not run.stopPathClock then
            moveWings(o)
            if o.phase>=2 and o.h>=0x1800 and not run.blockEnemyFire then fire(o) end
        end
        return true
    end

    function H.render(o)
        local assets=o.run.art
        if not assets then return end
        local bank=data.images[o.palette]
        local function draw(image,offset,flip)
            local h,l=packed(o.h,o.l,offset)
            art.draw(assets.sprites[image],h,l,0,0,flip)
        end
        local frames=o.phase==0 and bank.closed or o.phase==1 and bank.opening or bank.open
        for _,piece in ipairs(frames[o.wing+1]) do draw(piece[1],piece[2]) end
        if o.phase==0 then return end
        local rotor=data.images[o.rotorPalette].rotor[o.rotor+1]
        draw(rotor,0x12800a40+0xf600f600,true)
        draw(rotor,0x1280f540+0xf600f600)
        draw(bank.strut,0x12bffc40+0xf800fd00)
        draw(bank.strut,0x12bffc40+0xf800fd00+0x780,true)
    end

    return H
end
