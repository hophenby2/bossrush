-- 六面地面步兵共用转身和行军图。0x15734e 停步瞄准，0x157bcc 旋转炮口扫射。
return function(program,path,bullets,art,effects)
    local bit=require('bit')
    local band,bxor=bit.band,bit.bxor
    local floor,s16=math.floor,program.s16
    local data=program.stage6Patrol
    local H,Sweep,Glide,Hop={parts=1},{parts=1},{parts=1},{parts=1}

    local function init(o)
        o.flags,o.front,o.back,o.right,o.left,o.hp=unpack(data.box)
        o.normalPalette,o.flashPalette=unpack(data.palettes[(o.run.stageMode or 5)+1])
        o.palette=o.normalPalette
        if not path.attach(o,o.row) then return false end
        return true
    end

    function H.init(o)
        if not init(o) then return false end
        o.walkFrame,o.walkClock,o.fireClock,o.fireGroup,o.turnClock=0,2,1,3,1
        if (o.part[0x1e] or 0)>=0x80 then
            o.part[0x1e],o.hp=0,0x1e0
        end
        return true
    end

    function Sweep.init(o)
        if not init(o) then return false end
        local run=o.run
        o.sweepDirection=program.random(run,program.randomByte)<0x80 and 6 or -6
        o.sweepAngle,o.fireClock,o.pattern=0,8,0
        if run.major>=0x124 then
            local zoom=o.part[0x1e] or 0
            if zoom>=0x80 then
                o.part[0x1e],o.pattern,o.hp=0,2,0x1e0
                o.sweepDirection=zoom==0xff and -8 or 4
            else
                o.pattern=1
                o.sweepDirection=o.sweepDirection<0 and -8 or 8
            end
        end
        o.aim=0
        return true
    end

    local function damage(o)
        if not o.impact then o.palette=o.normalPalette; return true end
        o.flags,o.impact,o.damage=band(o.flags,0xa6ff),nil,0
        if o.hp>=0 then
            o.palette=bxor(o.palette,o.flashPalette)
            return true
        end
        effects.emit(o,0x8f,0,0,0,false)
        effects.emit(o,0x13,4,program.random(o.run,program.randomByte),0,false)
        local run=o.run
        if band(o.flags,1)==0 then
            program.random(run,program.randomByte)
            if run.halfPathSpeed and program.atPatrolDistance(o) and not run.blockEnemyFire then
                local angle=program.angle8(o.h,o.l,run.player,0x80)
                bullets.emit(o,12,-6,angle,0,0,true)
                if program.random(run,program.randomByte)>=0x80 then
                    bullets.emit(o,12,-3,angle,0,0,true)
                else
                    bullets.emit(o,12,-6,angle-8,0,0,true)
                    bullets.emit(o,12,-6,angle+8,0,0,true)
                end
            end
        end
        return false
    end

    local function canFire(o,height)
        return o.h>height and band(o.flags,0x2000)~=0 and not o.run.blockEnemyFire
            and program.atPatrolDistance(o)
    end

    local function fire(o,modifier,angle,offset,precise)
        bullets.emit(o,12,modifier,angle,s16(floor(offset/0x10000)),s16(offset),precise)
    end

    local function aimed(o)
        local run=o.run
        if not o.parked then
            if run.major>0x40 and canFire(o,0x2800) and
                (run.halfPathSpeed or run.frame%4==0) then
                local angle=program.angle8(o.h,o.l,run.player,0x80)
                fire(o,-6,angle,data.muzzle[floor(angle/8)+1],true)
            end
            if o.direction>=0x40 then
                o.parked,o.speed,o.aim=true,0,o.direction
                program.nextRandom(run)
            end
        end
        if o.parked then
            o.turnClock=o.turnClock-1
            if o.turnClock<0 then
                o.turnClock=1
                local heading=program.angle(o.h,o.l,run.player,band(o.aim,0x3f))
                o.aim=program.towards(o.aim,heading)
                if canFire(o,0x1c00) then
                    o.fireClock=o.fireClock-1
                    if o.fireClock<0 then
                        local modifier=run.major<0x40 and -6 or run.major<0x90 and -5 or -3
                        local angle=run.major<0x40 and band(o.aim,0x3e) or o.aim
                        local port=data.muzzle[floor(band(angle,0x3e)/2)+1]
                        fire(o,modifier,angle*4,port,false)
                        o.fireClock=(run.halfPathSpeed and 5 or 7)-floor(run.patrolFireRank/4)
                        if run.major<0x40 then o.fireClock=o.fireClock-1 end
                        o.fireGroup=o.fireGroup-1
                        if o.fireGroup<0 then
                            o.fireGroup=3
                            o.fireClock=o.fireClock+(run.halfPathSpeed and 1 or 4)
                        end
                        o.fireClock=band(o.fireClock,255)
                    end
                end
            end
            if o.direction<0x40 then o.parked,o.speed=false,5 end
        end
        if not o.parked then
            o.walkClock=o.walkClock-1
            if o.walkClock<0 then o.walkClock,o.walkFrame=2,(o.walkFrame+1)%8 end
        end
    end

    local function sweep(o)
        local run=o.run
        if o.pattern==1 then
            if not run.halfPathSpeed and run.frame%4~=0 then return end
        else
            o.fireClock=o.fireClock-1
            if o.fireClock>=0 then return end
            o.fireClock=band((run.halfPathSpeed and 4 or 7)-floor(run.patrolFireRank/4),255)
        end
        o.sweepAngle=band(o.sweepAngle+o.sweepDirection,255)
        local angle=o.sweepAngle
        if canFire(o,0x2000) then
            local port=data.muzzle[floor(angle/8)+1]
            local function shot(a) fire(o,(a<0x40 or a>0xc0) and 3 or -5,a,port,true) end
            if o.pattern==0 then
                shot(band(angle+0x40,255))
                shot(band(angle+0xc0,255))
            else shot(angle) end
        end
        o.aim=floor(angle/4)
    end

    local function aimAt(o,h,l)
        return program.angle(o.h,o.l,{h=h,l=l-o.run.cameraOffset,active=true},o.direction)
    end

    local function initAir(o,passes)
        if not init(o) then return false end
        o.flags,o.homeH,o.homeL=0xa201,o.h,o.l
        o.passes,o.airPhase,o.wave,o.pose,o.poseClock=passes,0,0,0,1
        o.cooldown,o.shotClock,o.shots=0x10,3,0
        return true
    end

    function Glide.init(o) return initAir(o,12) end

    local function hopHeading(o)
        o.speed=8
        local run=o.run
        if run.player and run.player.active then
            local angle=program.angle(o.h,o.l,run.player,o.direction)
            o.direction=band(angle+program.random(run,program.randomNarrow),0x3f)
        end
    end

    function Hop.init(o)
        if not initAir(o,10) then return false end
        o.height,o.verticalSpeed,o.landings=0,0,3
        hopHeading(o)
        return true
    end

    local function finishPass(o)
        o.airPhase,o.standing,o.passes=0,false,band(o.passes-1,255)
    end

    local function airFire(o,precise)
        local run,p=o.run,o.run.player
        if o.scrollAway then return true end
        if o.shots==0 then
            o.cooldown=o.cooldown-1
            if o.cooldown>=0 then return false end
            o.cooldown=0x10
            if p and p.active then
                o.aim=precise and program.angle8(o.h,o.l,p,0x80) or program.angle(o.h,o.l,p,0x20)
            elseif precise then return false
            else o.aim=0x20 end
            o.shots=2
        end
        o.shotClock=o.shotClock-1
        if o.shotClock>=0 then return false end
        o.shotClock=3
        if o.h>0x1c00 and not run.blockEnemyFire and p and p.active then
            if not precise then o.aim=program.towards(o.aim,program.angle(o.h,o.l,p,o.aim)) end
            bullets.emit(o,13,-2,precise and o.aim or o.aim*4,0,0,precise)
        end
        o.shots=o.shots-1
        return o.shots==0
    end

    local function baseMotion(o)
        local run=o.run
        o.h,o.l=o.homeH,o.homeL
        if not run.freeze then
            local dh,dl=program.vector(o.speed,o.direction*4,run.slowVectors)
            o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        end
        if run.major>=0x17c then
            o.flags,o.scrollAway=band(o.flags,0xfffe),true
            o.h=s16(o.h+run.groundScroll)
        end
        o.homeH,o.homeL=o.h,o.l
        o.l=s16(o.l-run.cameraOffset)
    end

    local function glide(o)
        local run=o.run
        o.wave=band(o.wave+2,255)
        if run.stopPathClock then return end
        if o.airPhase==0 then
            local h,l=0x7800,o.targetL or 0x1c00
            if o.passes==0 then o.speed=0xc
            else
                h=0x3c00+program.hovercraftRandom[program.nextRandom(run,127)]
                l=0x1c00+program.hovercraftRandom[program.nextRandom(run,127)]
                    +data.smallOffset[program.nextRandom(run,63)]
                o.speed=0x24
            end
            o.airPhase,o.standing,o.targetL=2,false,l
            o.direction=aimAt(o,h,l)
        end
        if o.passes~=0 then o.speed=math.max(0,o.speed-1) end
        if o.speed==0 and airFire(o,true) then
            finishPass(o)
            o.pose=0
        end
    end

    local function hop(o)
        local run=o.run
        if o.airPhase==0 and not run.stopPathClock then
            if o.passes~=0 and o.landings==0 and o.verticalSpeed<=0 then
                o.airPhase,o.standing,o.speed,o.wave=1,true,0,0
            else
                o.height=o.height+o.verticalSpeed
                o.verticalSpeed=o.verticalSpeed-8
                if o.height<=0 then
                    o.height,o.verticalSpeed=0,0x100
                    hopHeading(o)
                    o.landings=o.landings-1
                end
            end
        end
        if o.airPhase==1 then
            local _,shift=program.vector(0x40,o.wave,run.slowVectors)
            o.h,o.wave=s16(o.h+shift),band(o.wave+2,255)
            if o.pose>=0x10 and airFire(o,false) then
                finishPass(o)
                o.landings=3
            end
        end
    end

    local function inside(o)
        if band(o.l+0x1000+o.run.cameraOffset,0xffff)<0x5800 and band(o.h+0x800,0xffff)<0x8000 then
            o.seen=true
        elseif o.seen then return false end
        return true
    end

    local function step(o,fireStep)
        local run=o.run
        if not path.step(o,-run.groundScroll) then return false end
        if not inside(o) then return false end
        if not damage(o) then return false end
        if not run.freeze and not run.stopPathClock then fireStep(o) end
        return true
    end

    function H.step(o) return step(o,aimed) end
    function Sweep.step(o) return step(o,sweep) end

    local function airStep(o,isHop)
        local run=o.run
        baseMotion(o)
        if isHop then o.h=s16(o.h+o.height)
        else o.h=s16(o.h+program.vector(0x40,o.wave,run.slowVectors)) end
        if not inside(o) or not damage(o) then return false end
        if not run.freeze then
            if isHop then hop(o) else glide(o) end
            if o.standing or not run.stopPathClock then
                o.poseClock=o.poseClock-1
                if o.poseClock<0 then
                    o.poseClock,o.pose=1,o.pose+1
                    if o.standing then
                        if o.pose>=0x30 then o.pose=0x20 end
                    elseif o.pose>=0x20 then o.pose=0 end
                    if not isHop and o.pose==0x1f then o.standing=true end
                end
            end
        end
        return true
    end

    function Glide.step(o) return airStep(o,false) end
    function Hop.step(o) return airStep(o,true) end

    local function draw(o,standing)
        local assets=o.run.art
        if not assets then return end
        local poses=data.images[o.palette]
        local pose,h,l
        if standing then
            pose=poses[2][floor(band(o.aim,0x3e)/2)+1]
            h,l=program.addPacked(o.h,o.l,0xf800fc00)
        else
            local dir=band(o.direction,0x38)
            pose=poses[1][dir+o.walkFrame+1]
            h,l=program.addPacked(o.h,o.l,0xf800fb00)
        end
        art.draw(assets.sprites[pose[1]],h,l,0,0,pose[2]~=0)
    end

    function H.render(o) draw(o,o.parked) end
    function Sweep.render(o) draw(o,true) end

    local function drawAir(o,isHop)
        local assets=o.run.art
        if not assets then return end
        local images=data.images[o.palette]
        if not o.run.stopPathClock and not (o.standing and not isHop) then
            local shadow=data.images[o.normalPalette].shadow
            local dh,dl=isHop and -0x600 or -0x1400,isHop and -0x200+floor(o.height/2) or 0x400
            art.draw(assets.sprites[shadow],o.homeH,s16(o.homeL-o.run.cameraOffset),dh,dl)
        end
        local pose=images.jump[o.pose+1]
        local h,l=program.addPacked(o.h,o.l,pose[2])
        art.draw(assets.sprites[pose[1]],h,l,0,0)
    end

    function Glide.render(o) drawAir(o,false) end
    function Hop.render(o) drawAir(o,true) end

    return H,Sweep,Glide,Hop
end
