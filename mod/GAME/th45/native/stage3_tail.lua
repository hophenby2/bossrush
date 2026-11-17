-- 0x15b34c 的编队机读取公共发弹时钟，0x1628b2 和 0x1607a8 则只推进舰体演出。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local s16,addPacked = program.s16,program.addPacked
    local data = program.stage3Tail
    local escort,deck,vent,cover = {parts=1},{parts=1},{parts=1},{parts=1}

    function escort.init(o)
        local run = o.run
        if (run.stageNumber==3 or run.stageNumber==4) and run.stageFlags[0] then return false end
        o.flags,o.front,o.back,o.right,o.left,o.hp = unpack(data.escortBody)
        o.palette,o.animation = 13,run.freeze and 1 or 2
        return path.attach(o,o.row)
    end

    function escort.step(o)
        local run = o.run
        if o.impact then
            o.impact = nil
            o.palette = bxor(o.palette,18)
            if o.hp<0 then
                effects.emit(o,10,o.speed+8,o.direction*4,0,true)
                local retaliate = run.stageNumber==5 or program.random(run,program.randomByte)>=0x80
                local player = run.player
                if retaliate and player and player.active then
                    local aim = band(program.angle(o.h,o.l,player,0x20),0x3e)
                    bullets.emit(o,13,run.stageNumber==5 and -3 or 0,aim*4,0,0)
                end
                return false
            end
        else o.palette = 13 end
        if band(o.l+0xe00+run.cameraOffset,0xffff)<0x5400 and band(o.h+0x600,0xffff)<0x7c00 then
            o.seen = true
        elseif o.seen then return false end
        if not path.step(o,-run.groundScroll) then return false end
        local player = run.player
        if not run.freeze and not run.stopPathClock and band(run.frame+(run.escortClockOffset or 0),31)==0
            and player and player.active then
            local aim = band(program.angle(o.h,o.l,player,0x20),0x3e)
            local socket = floor(band(o.direction+1,0x3e)/2)+1
            local h,l = addPacked(o.h,o.l,data.escortMuzzle[socket])
            bullets.emit(o,13,run.stageNumber==5 and -3 or 0,aim*4,s16(h-o.h),s16(l-o.l))
        end
        if not run.freeze then o.animation = 3-o.animation end
        o.visible = true
        return true
    end

    function escort.render(o)
        if not o.run.art or not o.visible then return end
        local index = band(o.direction,0x3e)+o.animation
        art.draw(o.run.art.sprites[data.escortImages[o.palette][index]],o.h,o.l,-0x800,-0x500)
    end

    function deck.init(o)
        o.flags,o.animation,o.ventFrame,o.clock,o.speed = 0x8000,0,0,0,0
        if not path.attach(o,o.row) then return false end
        o.h = s16(o.h+0x2600)
        return true
    end

    function deck.step(o)
        local run = o.run
        if run.major>=0x203 or not path.step(o,-run.groundScroll) then return false end
        if o.speed>0 then
            o.clock = o.clock-1
            if o.clock<0 then
                o.clock = data.deckDelays[math.min(o.speed,16)+1]
                o.animation,o.ventFrame = (o.animation+1)%8,(o.ventFrame+1)%4
            end
        end
        o.visible = true
        return true
    end

    function vent.init(o)
        o.flags,o.animation,o.clock,o.speed = 0x8000,0,0,0
        local index = (o.run.stageMode or 2)+1
        o.palette = data.ventPalettes[index][1]
        return path.attach(o,o.row)
    end

    function vent.step(o)
        if not path.step(o,-o.run.groundScroll) or o.h<=-0x800 then return false end
        if not o.run.freeze then
            o.clock = o.clock-1
            if o.clock<0 then o.clock,o.animation = 0,(o.animation+1)%4 end
        end
        o.visible = true
        return true
    end

    local function draw(o,image,offset,flip)
        local h,l = addPacked(o.h,o.l,offset)
        art.draw(o.run.art.sprites[image],h,l,0,0,flip)
    end

    function deck.render(o)
        if not o.run.art or not o.visible then return end
        for _,row in ipairs(data.deck) do
            local frame = #row==3 and 3 or o.animation+3
            draw(o,row[frame],row[1],row[2]==1)
        end
        local vent = data.ventImages[22][o.ventFrame+1]
        draw(o,vent,0xe500dd00)
        draw(o,vent,0xe5001100)
    end

    function vent.render(o)
        if not o.run.art or not o.visible then return end
        draw(o,data.ventImages[o.palette][o.animation+1],0xf800f700)
    end

    function cover.init(o)
        o.flags,o.front,o.back,o.right,o.left,o.hp = unpack(data.coverBody)
        o.protection,o.animation,o.speed = 0x70,3,0
        if not path.attach(o,o.row) then return false end
        o.h = s16(o.h-0x180)
        return true
    end

    function cover.step(o)
        local run = o.run
        if not path.step(o,-run.groundScroll) then return false end
        if band(o.l+0xc00+run.cameraOffset,0xffff)<0x5000 and band(o.h+0x600,0xffff)<0x7c00 then
            o.seen = true
        elseif o.seen then return false end
        if run.awakeningMode==2 then o.flags=bit.bor(o.flags,0x2000)
        else o.flags=band(o.flags,0xdfff) end
        if o.protection>=0 then
            o.protection = o.protection-1
            o.hp,o.damage = o.protection<0 and 0x2000 or 0x7fff,0
        end
        o.visible = o.impact==true
        if o.impact then
            o.impact = nil
            if o.hp<0 then effects.emitSequence(o,data.coverBlast); return false end
            o.animation = (o.animation-1)%4
        end
        return true
    end

    function cover.render(o)
        if not o.run.art or not o.visible then return end
        draw(o,data.coverImages[o.animation+1],0xfa00fc00)
    end

    return escort,deck,vent,cover
end
