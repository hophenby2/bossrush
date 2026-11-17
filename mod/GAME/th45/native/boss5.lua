-- 0x1ba6e2 用三个固定在本体上的碰撞框结算主船耐久。
return function(program,bullets,effects,art)
    local dir='mod/GAME/th45/native/'
    local tasks=dofile('mod/GAME/th44/native/boss_tasks.lua')
    local motion=dofile(dir..'boss5_motion.lua')(program,effects,tasks)
    local attacks=dofile(dir..'boss5_attacks.lua')(program,bullets,tasks)
    local aux,events=dofile(dir..'boss5_tasks.lua')(program,bullets,effects,tasks)
    local bit=require('bit')
    local band,bxor=bit.band,bit.bxor
    local s16=program.s16
    local data=program.boss5
    local H={parts=12}

    local function breakPart(o)
        if not o.detached then return end
        local part,mirror=o.extraParts[4],o.extraParts[11]
        part.flags,mirror.flags=0x8000,0x8000
        o.detached,o.draws[5],o.partWaveStopped=false,nil,false
        o.detachedHealth=-1
        tasks.stop(o.aux,5)
        tasks.stop(o.aux,6)
        effects.emitSequence({run=o.run,h=part.h,l=part.l},data.detachedBlast)
        bullets.clear(o.run,0x20)
    end

    function H.init(o)
        o.extraParts={}
        for i,row in ipairs(data.parts) do
            local p=i==1 and o or {h=0,l=0}
            p.flags,p.front,p.back,p.right,p.left,p.hp=unpack(row)
            if i>1 then o.extraParts[i-1]=p end
        end
        local run=o.run
        o.h,o.l=0xa00,s16(0x4600-run.cameraOffset)
        o.health,o.counters=data.health[1],{data.health[2],data.health[3]}
        o.clocks={unpack(data.clocks)}
        o.phase,o.palette,o.wingPalette=0,19,20
        o.wingA,o.wingB,o.hullFrame,o.partWave=0,0,0,0
        o.breakPart=breakPart
        o.repeatCadence,o.repeatShots,o.repeatSpeed=0,0,0
        o.draws={}
        o.aux={limit=25,unique=true,handlers=aux,label='五面关底部件'}
        o.events={limit=5,unique=true,handlers=events,label='五面关底事件'}
        o.attacks={limit=20,handlers=attacks,label='五面关底攻击'}
        run.boss5,run.stageFlags[0]=o,true
        tasks.attach(o.events,0)
        return true
    end

    local function change(o)
        local phase=o.phase
        if phase==0 and o.counters[1]>0 then o.counters[2]=o.counters[2]+o.counters[1] end
        o.counters[phase+1]=-1
        o.phase,o.protected=phase+1,true
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        bullets.clear(o.run,phase==0 and 0x20 or 0xb0)
        if phase==0 then breakPart(o) end
        if phase==1 then
            o.health=-1
            o.palette,o.wingPalette=19,20
            for i=1,3 do o.extraParts[i].flags=0x8000 end
        end
        tasks.attach(o.events,phase+1)
    end

    local function damageDetached(o)
        if not o.detached or o.partProtected then return end
        local part,mirror=o.extraParts[4],o.extraParts[11]
        local hit=part.impact or mirror.impact
        if hit then
            local damage=band((part.damage or 0)+(mirror.damage or 0),0xffff)
            for _,p in ipairs({part,mirror}) do p.impact,p.damage,p.hp=nil,0,0x7fff end
            o.detachedPalette=bxor(o.detachedPalette==25 and 21 or o.detachedPalette,0xa)
            o.detachedEnginePalette=bxor(o.detachedEnginePalette==25 and 10 or o.detachedEnginePalette,0x15)
            if not o.protected then o.detachedHealth=o.detachedHealth-damage end
            if o.detachedHealth<0 then breakPart(o) end
        else
            local danger=o.detachedHealth<=0x43 and not o.run.blockEnemyFire
            o.detachedPalette,o.detachedEnginePalette=danger and 25 or 21,danger and 25 or 10
        end
    end

    local function damage(o)
        if o.phase>=2 then return end
        local total,hit=0,false
        for i=1,3 do
            local p=o.extraParts[i]
            if p.impact then
                total,hit=total+(p.damage or 0),true
                p.impact,p.damage,p.hp=nil,0,0x7fff
            end
        end
        damageDetached(o)
        local hp=o.counters[o.phase+1]
        if not hit then
            o.palette,o.wingPalette=19,20
            if hp<=(o.phase==0 and 0x1a000 or 0x10e66) and not o.run.blockEnemyFire then
                o.palette,o.wingPalette=25,25
            end
            return
        end
        o.palette=bxor(o.palette==25 and 19 or o.palette,0xc)
        o.wingPalette=bxor(o.wingPalette==25 and 20 or o.wingPalette,0xb)
        if o.protected then return end
        total=band(total,0xffff)
        o.health,o.counters[o.phase+1]=o.health-total,hp-total
        if o.counters[o.phase+1]>=0 then return end
        if o.phase==0 or o.run.player and o.run.player.active then change(o)
        else o.health,o.counters[2]=0x200,0x200 end
    end

    function H.step(o)
        local run=o.run
        if o.finished then
            run.boss5,run.stageFlags[0],run.stageCleared=nil,false,true
            return false
        end
        if not run.freeze and not run.stopPathClock then
            tasks.tick(o,o.aux)
            tasks.tick(o,o.events)
        end
        if not run.stopPathClock then
            if o.nextMotion~=nil then
                o.move={index=o.nextMotion}
                o.nextMotion=nil
                motion[o.move.index][1](o,o.move)
            elseif o.move then motion[o.move.index][2](o,o.move) end
            if not run.freeze then tasks.tick(o,o.attacks) end
        end
        damage(o)
        if (o.recoil or 0)>0 then
            local dh,dl=program.vector(o.recoil,o.recoilAngle,run.slowVectors)
            o.h,o.l,o.recoil=s16(o.h+dh),s16(o.l+dl),o.recoil-1
        end
        if o.phase<2 and not run.freeze and not run.stopPathClock then
            local index=o.phase+1
            o.clocks[index]=o.clocks[index]-1
            if o.clocks[index]==0 then
                if run.player and run.player.active then change(o) else o.clocks[index]=0x78 end
            end
        end
        return true
    end

    function H.render(o)
        local assets=o.run.art
        if not assets then return end
        local function draw(name,bank,index,offset,flip)
            local h,l=program.addPacked(o.h,o.l,offset)
            art.draw(assets.sprites[data.images[name][bank][index+1]],h,l,0,0,flip)
        end
        if o.draws[0] then
            draw('wings',o.wingPalette,o.wingA,0xc00f100+0xea00f100)
            draw('wings',o.wingPalette,o.wingB,0xc00f100+0xea00f100+0x1e00,true)
        end
        if o.draws[1] then draw('hull',o.palette,o.hullFrame,0xf600f800) end
        if o.draws[2] then draw('hullTurn',o.palette,o.turnFrame,0xf400f800) end
        if o.draws[3] then
            local row=data.images.hatch[o.palette][o.hatchFrame+1]
            local h,l=program.addPacked(o.h,o.l,row[2])
            art.draw(assets.sprites[row[1]],h,l,0,0)
        end
        if o.draws[4] then
            draw('wingFold',o.wingPalette,o.foldFrame,0xe000f100+0xafff100)
            draw('wingFold',o.wingPalette,o.foldFrame,0xe000f100+0xafff100+0x1e00,true)
        end
        if o.draws[5] then
            local p=o.extraParts[4]
            local h,l=program.addPacked(p.h,p.l,0xf200f800)
            local sprite=data.images.detached[o.detachedPalette][o.detachedFrame+1]
            art.draw(assets.sprites[sprite],h,l,0,0)
            if o.detachedFrame==0 then
                local frames=program.armoredCarTracks[o.detachedEnginePalette]
                h,l=program.addPacked(p.h,p.l,0x0880fc80+0xfa00fb00)
                local engine=assets.sprites[frames[(o.detachedEngine or 15)+1]]
                art.draw(engine,h,l,0,0)
                art.draw(engine,h,s16(l+0x700),0,0,true)
            end
        end
        if o.draws[6] then draw('retreat',o.palette,o.retreatFrame,0xf800fa00) end
    end

    H.wreck={parts=1,
        init=function(o)
            o.h,o.l,o.flags=o.row.h,o.row.l,0x8000
            o.wreckFrame,o.wreckClock=15,4
            return true
        end,
        step=function(o)
            local run=o.run
            o.h=s16(o.h+run.groundScroll)
            if not run.stopPathClock and o.wreckFrame>0 then
                o.wreckClock=o.wreckClock-1
                if o.wreckClock<0 then o.wreckClock,o.wreckFrame=4,o.wreckFrame-1 end
            end
            return not run.stageCleared
        end,
        render=function(o)
            local assets=o.run.art
            if assets then
                local h,l=program.addPacked(o.h,o.l,0x01000080+0xfe00fe00)
                art.draw(assets.sprites[data.images.wreck[25][o.wreckFrame+1]],h,l,0,0)
            end
        end,
    }

    return H
end
