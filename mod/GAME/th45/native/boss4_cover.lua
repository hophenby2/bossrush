-- 0x19ec24 的前景隔墙占独立部件槽，跟随本体横坐标并按 0x1000 周期接片。
return function(program,art)
    local s16=program.s16
    local floor=math.floor
    local H={parts=1}

    function H.init(o)
        o.owner=o.row.owner
        if not o.owner then return false end
        o.h,o.l,o.flags=-0x8000,o.owner.l,0x8000
        o.layer=LAYER.ENEMY-1
        o.phase,o.delay,o.velocity=0,0x155,0
        return true
    end

    function H.step(o)
        local run,owner=o.run,o.owner
        if run.boss4~=owner then return false end
        if run.stopPathClock or not owner.move then return true end
        o.l=owner.l
        if o.phase==0 and not run.freeze then
            o.delay=o.delay-1
            if o.delay==0 then o.phase=1 end
        end
        if o.phase==2 then
            o.h=s16(o.h+(run.freeze and floor(o.velocity/2) or o.velocity))
            o.velocity=math.max(-0xc0,o.velocity-8)
            if o.h<=-0x1000 then o.h=s16(o.h+0x1000) end
        end
        if o.phase==1 then
            local dh=run.groundScroll
            o.velocity=run.freeze and dh*2 or dh
            o.h=s16(o.h+dh)
            if o.h<=-0x1000 then o.h,o.phase=s16(o.h+0x1000),2 end
        end
        return true
    end

    function H.render(o)
        local assets=o.run.art
        if not assets then return end
        local images=program.boss4.cover
        art.draw(assets.sprites[images[1]],s16(o.h+0x1000),s16(o.l-0x1a00),0,0)
        art.draw(assets.sprites[images[2]],o.h,s16(o.l-0x1a00),0,0)
    end

    return H
end
