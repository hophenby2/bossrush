-- 0xf1a4c 炮阵。门板时钟决定展开、发射、收拢，击破后只绘制残骸。
return function(program, path, bullets, effects, remove, score)
    local band = require('bit').band
    local s16,add=program.s16,program.add
    local data=program.platformCannon
    local M={}

    local function tick(s,index)
        local clock=s[index]
        s[index]=(clock-1)%256
        return clock==0
    end

    function M.init(o)
        local s=o.state
        local _,warmup=program.smallRank(o.run)
        local _,_,interval=program.groundRank(o.run)
        s[0x1c],s[0x1d]=(s[0x1c]-warmup)%256,(s[0x1d]-interval)%256
        o.colorFrame,o.cover,o.phase=1,1,0
        if o.part[0x1e]~=0 then o.right,o.left,o.a=0x1200,0xc00,120 end
    end

    local function salvo(o)
        local run,s=o.run,o.state
        local port=data.ports[s[0x1e]+1]
        if run.pilotH then
            local h,l=s16(o.h+port[1]),s16(o.l+port[2])
            local aim=program.aimByte(h,l,run.pilotH,run.pilotL,0x80,true)
            for angle=aim-16,aim+16,16 do
                local p=program.breakawayTank.ring[band(angle+2,0xfc)/4+1]
                local dh,dl=add(p[1],p[2],port[1],port[2])
                local muzzleH,muzzleL=s16(o.h+dh),s16(o.l+dl)
                bullets.emitFasterInLoop(run,4,1,angle,muzzleH,muzzleL)
                bullets.emitFasterInLoop(run,4,4,angle,muzzleH,muzzleL)
            end
        end
    end

    function M.step(o)
        local run,s=o.run,o.state
        if not path.step(o) then remove(o); return end
        local inside=band(o.h+0x1200,0xffff)<0x9400 and band(o.l+0x1800+run.cameraOffset,0xffff)<0x6800
        if o.entered and not inside then remove(o); return end
        o.entered=o.entered or inside
        if o.wreck then
            o.wreck=o.wreck-1
            if o.wreck==0 then remove(o) end
            return
        end
        if band(o.flags,0x5800)==0 then
            o.colorFrame=o.hp<0x1800 and band(run.frame,0x0e)==0 and 3 or 1
        else
            o.flags,o.colorFrame=band(o.flags,0xa7ff),o.colorFrame==2 and 1 or 2
            if o.hp<0 then
                score.kill(o,0x4ec)
                effects.spawn(run,o.h,o.l,data.death,true,true)
                bullets.clearFor(run,0x40)
                o.wreck,o.flags,o.colorFrame=0x20,0x8080,1
                if run.onEnemyDeath then run.onEnemyDeath(o) end
                return
            end
        end
        if run.freeze or run.bulletHold or not o.entered then return end
        if o.phase==0 then
            if tick(s,0x1c) then
                s[0x1c]=2
                if o.h>=0x1000 then o.phase=1 end
            end
        elseif o.phase==1 then
            if tick(s,0x22) then
                s[0x22],o.cover=s[0x23],o.cover+1
                if o.cover==16 then o.phase=2 end
            end
        elseif o.phase==2 then
            if o.h>=0x1000 then
                if not tick(s,0x1c) then return end
                s[0x1c]=s[0x26]
                if not run.pilotH then return end
                salvo(o)
            end
            if tick(s,0x1e) then s[0x1e],s[0x1c],o.phase=s[0x1f],2,3 end
        elseif s[0x1c]~=0 then
            s[0x1c]=s[0x1c]-1
        elseif tick(s,0x22) then
            s[0x22],o.cover=s[0x23],o.cover-1
            if o.cover==1 then
                local _,_,interval=program.groundRank(run)
                s[0x1c],o.phase=(0x38-interval)%256,0
            end
        end
    end

    function M.render(o,draw)
        local frame=data.frames[o.cover]
        local function sprite(row)
            local h,l=add(o.h,o.l,row[4],row[5])
            draw(o,row[o.colorFrame],s16(h-o.h),s16(l-o.l))
        end
        for i=1,4 do sprite(frame[i]) end
        sprite(frame[o.part[0x1e]~=0 and 6 or 5])
    end

    return M
end
