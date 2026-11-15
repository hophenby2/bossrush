-- 一面四座炮台分别推进平台和炮口，机械动作结束后才切换受击标志。
return function(program,path,bullets,effects,remove,score)
    local band=require('bit').band
    local s16,word,pack,unpackPosition=program.s16,program.word,program.pack,program.unpack
    local data=program.risingTurret
    local M={}

    local function tick(s,index)
        local clock=s[index]
        s[index]=(clock-1)%256
        return clock==0
    end

    function M.init(o)
        o.colorFrame,o.heading,o.doorH,o.doorL,o.rise=1,0x2c,0,0,0
        if o.kind>=0x8a then
            o.heading,o.cover,o.doorPhase=0x20,word(o.state,0x2c)/4,word(o.state,0x30)
        end
    end

    local function salvo(o,shotClock,volley,left,right)
        local s,run=o.state,o.run
        local base=band(o.heading,0x3e)
        local muzzles=data.muzzles[base/2+1]
        local function emit(index,delta)
            local angle=base*4+delta
            local p=program.breakawayTank.ring[band(angle+2,0xfc)/4+1]
            local dh,dl=unpackPosition(pack(p[1],p[2])+pack(muzzles[index],muzzles[index+1])+pack(o.rise,0))
            if o.kind>=0x8a then
                bullets.emitFasterInLoop(run,9,3,angle,s16(o.h+dh),s16(o.l+dl))
            else
                bullets.emitLongPair(run,9,o.kind-0x87,angle,o.h,o.l,dh,dl)
            end
        end
        if s[volley]%2==1 then
            emit(1,-left)
            emit(3,left)
        else
            emit(1,0)
            emit(1,right)
            emit(3,0)
            emit(3,-right)
        end
        if tick(s,volley) then s[volley],s[shotClock]=s[volley+1],0x40 end
    end

    local function track(o,h)
        local run=o.run
        if not run.pilotH then return end
        local target=program.angle(s16(h),o.l,run.pilotH,run.pilotL,o.heading)
        o.heading=program.turnToward(o.heading,target)
    end

    -- 0xf09bc / 0xf1080。先让过门板，再下降防护盖，最后开放炮身。
    local function slide(o)
        local run,s=o.run,o.state
        if o.doorPhase==1 then
            o.doorH=o.doorH-0x54
            if o.doorH<=-0x1554 then o.doorPhase=2 end
        elseif o.doorPhase==2 then
            o.doorH=o.doorH+0x54
            if o.doorH>=-0x1500 then o.doorPhase=0 end
        elseif o.cover>0 then
            if tick(s,0x2e) then
                s[0x2e],o.cover=s[0x2f],o.cover-1
                if o.cover==0 then o.flags=0xa100 end
            end
        elseif not run.freeze and tick(s,0x26) then
            s[0x26]=s[0x27]
            if s[0x24]==s[0x25] then track(o,o.h) end
        end
        if not run.freeze and not run.bulletHold and o.doorPhase==0 and o.cover==0
            and o.h>=0x1c00 and tick(s,0x22) then
            s[0x22]=4
            salvo(o,0x22,0x24,o.kind==0x8a and 2 or 4,4)
        end
    end

    function M.step(o)
        local run,s=o.run,o.state
        if o.wreck then
            o.wreck=o.wreck-1
            if o.wreck==0 then remove(o) end
            return
        end
        if not path.step(o) then remove(o); return end
        local inside=band(o.h+0xc00,0xffff)<0x8800
        if o.entered and not inside then remove(o); return end
        o.entered=o.entered or inside
        if o.destroyed then return end
        if band(o.flags,0x5800)==0 then
            local threshold=o.kind>=0x8a and 0x480 or 0x280
            o.colorFrame=o.hp<threshold and band(run.frame,0x0e)==0 and 3 or 1
        else
            o.flags,o.colorFrame=band(o.flags,0xa7ff),o.colorFrame==2 and 1 or 2
            if o.hp<0 then
                score.kill(o,o.kind>=0x8a and 0x140 or 0xd2)
                effects.spawn(run,o.h,o.l,data[o.kind].death,true,true)
                o.flags,o.colorFrame=0x8080,1
                if o.kind>=0x8a then o.destroyed=true else o.wreck=s[0x2b] end
                if run.onEnemyDeath then run.onEnemyDeath(o) end
                return
            end
        end
        if o.kind>=0x8a then slide(o); return end
        if o.doorH>-0x1180 then
            if tick(s,0x20) then
                s[0x20],o.doorH,o.doorL=s[0x21],o.doorH-0x46,o.doorL-0x34
            end
            return
        end
        if o.rise<0x600 then
            o.rise=o.rise+0x30
            if o.rise>=0x600 then o.flags=0xa100 end
        elseif not run.freeze and tick(s,0x28) then
            s[0x28]=s[0x29]
            if s[0x26]==s[0x27] and run.pilotH then
                track(o,o.h+(o.kind==0x88 and o.rise or 0))
            end
        end
        if not run.freeze and not run.bulletHold and o.h>=0x1800 and o.rise>=0x600 and tick(s,0x24) then
            s[0x24]=4
            salvo(o,0x24,0x26,16,22)
        end
    end

    function M.render(o,draw)
        local definition=data[o.kind]
        local pos=pack(o.h,o.l)
        local function sprite(id,offset)
            local h,l=unpackPosition(pos+offset)
            draw(o,id,s16(h-o.h),s16(l-o.l))
        end
        if o.kind>=0x8a then
            local first=o.kind==0x8a
            local cover=definition.cover[o.cover+1]
            local coverOffset=first and 0xf1c0f800 or 0xf1c1f440
            local doorH=s16(o.h+o.doorH+0x80)
            local door=pack(doorH,s16(o.l+(first and 0x440 or -0x400)))+0xee00f600
            if o.doorPhase~=0 then sprite(cover,coverOffset) end
            if doorH>-0x400 then
                local h,l=unpackPosition(door)
                draw(o,definition.door,s16(h-o.h),s16(l-o.l))
            end
            if o.doorPhase==0 then sprite(cover,coverOffset) end
            if o.doorPhase~=0 or o.cover~=0 or o.destroyed then return end
        end
        sprite(definition.gun[o.colorFrame][band(o.heading,0x3e)/2+1],0xf400f600+pack(o.rise,0))
        if o.doorH>-0x1180 then
            local first=o.kind==0x88
            sprite(definition.door,(first and 0xeb00f280 or 0xeb00f240)+pack(o.doorH,o.doorL))
            sprite(definition.platform,first and 0xd841e040 or 0xd841d740)
        end
    end

    return M
end
