-- 一面 0xeed4a / 0xef614。主炮和两间舱室分别受击，各按自己的残骸计时退场。
return function(program,path,bullets,effects,remove,score)
    local band=require('bit').band
    local s16,word,pack,unpackPosition=program.s16,program.word,program.pack,program.unpack
    local data=program.linkedCannon
    local mounts={
        [0x86]={{0,0},{0x1500,-0xf00},{0x1500,-0x1cc0}},
        [0x87]={{0,0},{0x1400,0xc80},{0xfc0,0x14c0}},
    }
    local hitOrder={[0x86]={3,2,1},[0x87]={1,2,3}}
    local scoreOrigins={[0x86]={{0x300,-0x200},{0,0},{0x200,-0x100}},
        [0x87]={{0x480,0x100},{0,0},{0x480,0x280}}}
    local M={}

    local function tick(s,index)
        local clock=s[index]
        s[index]=(clock-1)%256
        return clock==0
    end

    local function place(o)
        for i,part in ipairs(o.parts) do
            local mount=mounts[o.kind][i]
            if i~=1 then part.h,part.l=program.add(o.h,o.l,mount[1],mount[2]) end
            part.x,part.y=program.world(part.h,part.l)
        end
    end

    function M.init(o)
        local s,run=o.state,o.run
        o.parts,o.remaining,o.armor={o,unpack(o.attachments)},word(s,0x30),word(s,0x22)
        local first=o.kind==0x86
        local life={s[first and 0x21 or 0x20],s[0x2d],s[first and 0x20 or 0x21]}
        local definition=data[o.kind]
        local records={definition.part,unpack(definition.second)}
        for i,part in ipairs(o.parts) do
            part.colorFrame,part.wreckLife=1,life[i]
            part.drawH,part.drawL=s16(word(records[i],3)),s16(word(records[i],5))
        end
        place(o)
        local gun=mounts[o.kind][2]
        o.heading=run.pilotH and program.angle(s16(o.h+gun[1]),s16(o.l+gun[2]),run.pilotH,run.pilotL,0x20) or 0x20
    end

    local function breakPart(o,index)
        local part=o.parts[index]
        if part.broken then return end
        part.flags,part.broken,part.colorFrame=0x8080,true,1
        o.remaining=o.remaining-1
        effects.spawn(o.run,part.h,part.l,data[o.kind].death,true,true)
        if o.run.onBreakPart then o.run.onBreakPart(part) end
    end

    local function hit(o,index)
        local part=o.parts[index]
        if part.broken then
            if part.wreckLife>0 then
                part.wreckLife=part.wreckLife-1
                if part.wreckLife==0 and o.remaining==0 then
                    if o.run.onEnemyDeath then o.run.onEnemyDeath(o) end
                    remove(o)
                    return true
                end
            end
            return false
        end
        if band(part.flags,0x5800)==0 then
            local threshold=index==3 and 0x200 or index==2 and o.kind==0x86 and 0x300 or 0x180
            part.colorFrame=part.hp<threshold and band(o.run.frame,0xe)==0 and 3 or 1
            return false
        end
        part.flags,part.colorFrame=band(part.flags,0xa7ff),part.colorFrame==2 and 1 or 2
        if part.hp<0 then
            score.kill(part,index==2 and 0xb4 or 0x78,unpack(scoreOrigins[o.kind][index]))
            if index==2 and o.kind==0x87 then breakPart(o,3) end
            breakPart(o,index)
            if index==2 then
                o.left,o.parts[3].right=0xc00,0xc00
                o.a=(o.right+o.left)/128
                o.parts[3].a=(o.parts[3].right+o.parts[3].left)/128
            end
        end
        return false
    end

    local function salvo(o)
        local s,run=o.state,o.run
        local aim=band(o.heading,0x3e)
        local ports=program.risingTurret.muzzles[aim/2+1]
        local origin=mounts[o.kind][2]
        local function fire(index,delta)
            local angle=4*aim+delta
            local p=program.breakawayTank.ring[band(angle+2,0xfc)/4+1]
            local dh,dl=unpackPosition(pack(origin[1],origin[2])+pack(ports[index],ports[index+1])+pack(p[1],p[2]))
            bullets.emitLongPair(run,9,0,angle,o.h,o.l,dh,dl)
        end
        if s[0x28]%2==1 then
            fire(1,-16)
            fire(3,16)
        else
            fire(1,0)
            fire(1,22)
            fire(3,0)
            fire(3,-22)
        end
        if tick(s,0x28) then s[0x28],s[0x26]=s[0x29],0x60 end
    end

    function M.step(o)
        local run,s=o.run,o.state
        if not path.step(o) then remove(o); return end
        local inside=band(o.h+0x2600,0xffff)<0xbc00
        if o.entered and not inside then remove(o); return end
        o.entered=o.entered or inside
        if o.armor>=0 then
            local player=run.player
            o.armor=o.armor-(player and player.bombObjects and next(player.bombObjects) and 2 or 1)
            for _,part in ipairs(o.parts) do part.hp=0x7fff end
            if o.armor<0 then
                o.hp,o.parts[2].hp,o.parts[3].hp=0x600,o.kind==0x86 and 0xc00 or 0x600,0x800
            end
        end
        place(o)
        for _,index in ipairs(hitOrder[o.kind]) do
            if hit(o,index) then return end
        end
        if not run.freeze and tick(s,0x2a) then
            s[0x2a]=s[0x2b]
            local base=mounts[o.kind][2]
            if s[0x28]==s[0x29] and run.pilotH then
                local target=program.angle(s16(o.h+base[1]),s16(o.l+base[2]),run.pilotH,run.pilotL,o.heading)
                o.heading=program.turnToward(o.heading,target)
            end
        end
        if o.parts[2].broken or run.freeze or run.bulletHold or o.h<0x1800 then return end
        if tick(s,0x26) then s[0x26]=4; salvo(o) end
    end

    function M.render(o,draw)
        local definition=data[o.kind]
        for _,index in ipairs({3,2,1}) do
            local part=o.parts[index]
            if part.wreckLife>0 then
                local sprite
                if index==2 then sprite=definition.gun[part.colorFrame][band(o.heading,0x3e)/2+1]
                else sprite=definition.art[index==1 and 1 or 2][part.colorFrame] end
                draw(part,sprite,part.drawH,part.drawL)
            end
        end
    end

    return M
end
