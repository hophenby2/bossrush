-- 0x163378 按路径推进后用机身朝向选择两座炮塔的挂点，炮塔各自跟踪自机。
return function(program,path,bullets,art,effects)
    local bit = require('bit')
    local band,bxor = bit.band,bit.bxor
    local floor = math.floor
    local data = program.dualCannon
    local M = {parts=1}

    function M.init(o)
        o.flags,o.front,o.back,o.right,o.left,o.hp = unpack(data.part)
        if not path.attach(o,o.row) then return false end
        local run = o.run
        local initial = data.init
        o.normalPalette,o.flashPalette = unpack(data.palettes[(run.stageMode or 0)+1])
        o.palette = o.normalPalette
        o.aims,o.burst,o.animation,o.animClock = {o.direction,o.direction},initial[3],initial[5],initial[6]
        o.shotClock = initial[1]-run.airFireRank+floor(program.random(run,program.randomHalf,127)/2)
        o.trackClock = initial[4]-floor(run.patrolTrackRank/16)
        return true
    end

    -- 0x1635f2 在卷轴 0x17c 扩大两门炮的张角，第二门炮随连射轮数提高弹速。
    local function fire(o,index)
        local aim = o.aims[index]
        local h,l = program.addPacked(o.h,o.l,data.centers[index][floor(aim/2)+1])
        local wide = o.run.stageNumber == 1 and o.run.major >= 0x17c
        local gap,count = wide and 20 or 24, (wide and 4 or 2)+index
        local kind = 26-index
        local modifier = index == 1 and 0 or (data.init[3]-o.burst)*3-2
        for ray = 0,count-1 do
            local angle = aim*4+(ray-(count-1)/2)*gap
            local muzzle = data.muzzle[floor(band(angle+2,0xfc)/4)+1]
            local dh,dl = program.addPacked(0,0,o.turrets[index]+muzzle)
            bullets.emit(o,kind,modifier,angle,h-o.h+dh,l-o.l+dl,true)
        end
    end

    function M.step(o)
        local run = o.run
        if not path.step(o,-run.groundScroll) then return false end
        if band(o.l+0x1400+run.cameraOffset,0xffff) < 0x6000 and band(o.h+0x1000,0xffff) < 0x9000 then
            o.seen = true
        elseif o.seen then return false end
        if o.impact then
            o.impact,o.flags = nil,band(o.flags,0xa6ff)
            o.palette = bxor(o.palette,o.flashPalette)
            if o.hp < 0 then
                effects.emitSequence(o,data.destruction)
                return false
            end
        else
            o.palette = o.normalPalette
        end
        local direction = floor(band(o.direction,0x3e)/2)
        o.turrets,o.visible = data.turrets[direction+1],true
        if run.freeze or run.stopPathClock then return true end
        local initial = data.init
        o.animClock = o.animClock-1
        if o.animClock < 0 then
            o.animClock = initial[7]
            if o.direction < 0x40 then o.animation = (o.animation+1)%3 end
        end
        o.trackClock = o.trackClock-1
        if o.trackClock < 0 then
            o.trackClock = initial[4]
            if o.burst == initial[3] then
                if not run.player or not run.player.active then return true end
                for index,offset in ipairs(o.turrets) do
                    local h,l = program.addPacked(o.h,o.l,offset)
                    local aim = o.aims[index]
                    o.aims[index] = program.towards(aim,program.angle(h,l,run.player,aim))
                end
            end
        end
        if band(o.flags,0x2000) == 0 or o.h < 0x3800 then return true end
        o.shotClock = o.shotClock-1
        if o.shotClock ~= 0 then return true end
        fire(o,1)
        fire(o,2)
        o.burst,o.shotClock = o.burst-1,initial[2]-floor(run.patrolTrackRank/4)
        if o.burst < 0 then o.burst,o.shotClock = initial[3],0x38-run.lateFireRank end
        return true
    end

    function M.render(o)
        local assets = o.run.art
        if not assets or not o.visible then return end
        local images = data.images[o.palette]
        local body = floor(band(o.direction,0x3e)/2)*3+o.animation+1
        art.draw(assets.sprites[images[1][body]],o.h,o.l,-0x1000,-0xc00)
        for index,offset in ipairs(o.turrets) do
            local h,l = program.addPacked(o.h,o.l,offset+0xfa00fc00)
            art.draw(assets.sprites[images[index+1][floor(o.aims[index]/2)+1]],h,l,0,0)
        end
    end

    return M
end
