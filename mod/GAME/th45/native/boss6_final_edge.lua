-- 0x1a6dd4 接管触边弹。沿边移动的判定在缩放结束时开启，第三形态退场时统一清除。
return function(program,bullets,effects,art)
    local s16,floor,abs=program.s16,math.floor,math.abs
    local data=program.boss6
    local H={parts=1}
    local deathVolley={{0xc00,-12,-1},{0x1800,-8,0},{0x2400,-4,0},{0x3000,0,1},{0x3c00,4,1}}

    function H.init(o)
        o.h,o.l,o.heading=o.row.h,o.row.l,o.row.heading
        o.flags,o.front,o.back,o.right,o.left,o.hp=0x8000,0x400,0x400,0x280,0x280,0x180
        o.speed=math.min(3,1+(o.run.finalEdgeLevel or 0))
        o.life,o.grow,o.anim=0x3fc,15,0
        o.growClock,o.fireClock,o.animClock=0,0,0
        return true
    end

    local function sendDeathVolley(o)
        local p=o.run.player
        if not p or not p.active then return end
        local h,l=abs(s16(o.h-p.h)),abs(s16(o.l-p.l))
        h=h-floor(h/4)
        local distance=math.max(h,l)+floor(math.min(h,l)/2)
        local row=deathVolley[#deathVolley]
        for _,entry in ipairs(deathVolley) do
            if distance<=entry[1] then row=entry; break end
        end
        local aim=program.angle8(o.h,o.l,p,0x80)
        bullets.emit(o,0x15,row[2],aim,0,0,true)
        for _,sign in ipairs({-1,1}) do
            for i=1,row[3]+1 do bullets.emit(o,0x15,row[2],aim+sign*2*i,0,0,true) end
        end
    end

    local function burst(o,shoot)
        if shoot then sendDeathVolley(o) end
        program.nextRandom(o.run) -- 0x17d312 选取爆破音。
        effects.emit(o,0x8f,0,0,0,false,0)
        effects.emit(o,0x13,4,program.random(o.run,program.randomByte),0,false,0)
        return false
    end

    function H.step(o)
        local run=o.run
        if run.finalEdgePurge then return burst(o,false) end
        if o.impact and o.hp<0 then return burst(o,true) end
        o.hitFlash,o.impact=o.impact and not o.hitFlash or false,nil
        if run.stopPathClock then return true end
        local dh,dl=program.vector(o.speed,o.heading*4,run.slowVectors)
        o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        if run.freeze then return true end
        o.life=o.life-1
        if o.life<0 then return burst(o,true) end
        if o.grow>0 then
            o.growClock=o.growClock-1
            if o.growClock<0 then o.growClock,o.grow=2,o.grow-1 end
            if o.grow==0 then o.flags=0xa201 end
        end
        if o.grow==0 and not o.quiet then
            o.quiet=run.finalEdgeClosing
            o.fireClock=o.fireClock-1
            if o.fireClock<0 then
                o.fireClock=2
                if o.heading==0x10 or o.heading==0x30 then bullets.emit(o,0xd,0x20,0x80,0,0,false) end
            end
        end
        if o.h<0x400 then o.h,o.heading=0x400,0
        elseif o.h>0x6c00 then o.h,o.heading=0x6c00,0x20 end
        if o.l<0 then o.l,o.heading=0,0x10
        elseif o.l>0x3800 then o.l,o.heading=0x3800,0x30 end
        o.animClock=o.animClock-1
        if o.animClock<0 then o.animClock,o.anim=2,(o.anim+1)%32 end
        return true
    end

    function H.render(o)
        if not o.run.art then return end
        local sprites=o.run.art.sprites
        local frames=o.hitFlash and data.images.finalEdgeHit or data.images.finalEdge
        local surface=sprites[frames[o.anim+1]]
        if o.grow==0 then art.draw(surface,o.h,o.l,-0x800,-0x500); return end
        local core=sprites[program.boss1Core.chargeRing[o.anim%4+1]]
        local x,y=program.world(o.h,o.l)
        local surfaceScale=(16-o.grow)/16
        local coreScale=(o.grow+1)/16
        Render(surface[1],floor(x),floor(y),0,surfaceScale,surfaceScale)
        Render(core[1],floor(x),floor(y),0,coreScale,coreScale)
    end

    return H
end
