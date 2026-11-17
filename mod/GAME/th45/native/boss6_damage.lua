-- 0x1ab5e6 先结算四个翼侧判定，再结算船体。各翼的耐久不计入船体总量。
return function(program,bullets,effects,tasks,wreck)
    local band=require('bit').band
    local s16,floor=program.s16,math.floor
    local data=program.boss6

    local function detach(o,index)
        local part=o.extraParts[index]
        if part.broken then return end
        part.broken,part.flags,part.palette=true,0x8000,19
        o.brokenCount=o.brokenCount+1
        o.attackPause=0x40
        tasks.clear(o.attacks)
        bullets.clear(o.run,0x40)
        for _,row in ipairs(data.wingBlast[index]) do
            local delay,kind,offset,velocity=unpack(row)
            local angle=band(velocity+program.random(o.run,program.randomNarrow),255)
            effects.emit({run=o.run,h=part.h,l=part.l},kind,band(floor(velocity/256),255),angle,offset,true,delay)
        end
    end

    local function prepareSecond(o)
        if o.counters[1]>0 then o.counters[2]=o.counters[2]+o.counters[1] end
        o.counters[1],o.phase,o.protected=-1,1,true
        o.palette=19
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        bullets.clear(o.run,0x10)
        for i=1,4 do detach(o,i) end
        tasks.attach(o.events,1)
    end

    local function finishSecond(o)
        o.counters[2],o.phase,o.flags=-1,2,0x8000
        o.palette=19
        tasks.clear(o.attacks)
        tasks.clear(o.events)
        bullets.clear(o.run,0x10)
        wreck.begin(o)
        tasks.attach(o.events,3)
    end

    local function impact(part)
        local damage=band(part.damage or 0,0xffff)
        part.impact,part.damage,part.hp=nil,0,0x7fff
        part.palette=part.palette==31 and 19 or 31
        return damage
    end

    local function warning(o,threshold)
        return threshold and not o.run.blockEnemyFire and 25 or 19
    end

    return function(o)
        if o.phase==2 then return end
        if o.phase==0 then
            for index=1,4 do
                local part=o.extraParts[index]
                if not part.broken then
                    if part.impact then
                        local damage=impact(part)
                        if not o.protected then o.armor[index]=s16(o.armor[index]-damage) end
                        if o.armor[index]<0 then detach(o,index) end
                    else part.palette=warning(o,o.armor[index]<=0x1c00) end
                end
            end
        end
        if o.impact then
            local damage=impact(o)
            if not o.protected then
                local index=o.phase+1
                o.health,o.counters[index]=o.health-damage,o.counters[index]-damage
            end
        else o.palette=warning(o,o.health<=(o.phase==0 and 0x1fee6 or 0x764c)) end
        if o.phase==0 and (o.counters[1]<0 or o.brokenCount==4) then prepareSecond(o) end
        local player=o.run.player
        if o.phase==1 and o.health<0 then
            if player and player.active then finishSecond(o)
            else o.health,o.counters[2]=0x200,0x200 end
            return
        end
        if o.run.freeze or o.run.stopPathClock then return end
        local index=o.phase+1
        o.clocks[index]=o.clocks[index]-1
        if o.clocks[index]~=0 then return end
        if not player or not player.active then o.clocks[index]=0x78
        elseif o.phase==0 then prepareSecond(o)
        else finishSecond(o) end
    end
end
