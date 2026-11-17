-- 0x1af684 的显示槽按登记编号叠加。同一侧翼的机匣和翼面共用受击色板。
return function(program,art)
    local data = program.mid1
    local floor = math.floor

    return function(o)
        local assets = o.run.art
        if not assets then return end
        local draw = o.drawParts
        local core,wingA,wingB = data.images[o.palette[1]],data.images[o.palette[2]],data.images[o.palette[3]]
        local function part(id,offset)
            local h,l = program.addPacked(o.h,o.l,offset)
            art.draw(assets.sprites[id],h,l,0,0)
        end
        if draw[12] then
            local row = data.approach[floor(o.roll/12)+1]
            if row then part(row[1],row[2]) end
        end
        if draw[11] then
            local id,dh,dl = unpack(data.warning[floor(o.warningFrame/4)+1])
            art.draw(assets.sprites[id],o.h,o.l,dh,dl)
        end
        if draw[10] then
            part(core.cannon[floor(o.cannonAim[1]/2)+1],0x04000500+0xfc00fd00)
            part(core.cannon[floor(o.cannonAim[2]/2)+1],0x0400fb00+0xfc00fd00)
        end
        local hatch = floor(o.hatch[1]/4)+1
        local hull = floor(o.hullFrame/4)+1
        local tail = floor(o.tailFrame/4)+1
        if draw[3] then part(core.tailB[tail],0x1200ee00+0xf400f600) end
        if draw[2] then part(core.tailA[tail],0x12001200+0xf400f600) end
        if draw[1] then part(core.hatch[floor(o.hatch[2]/4)+1],0x0c000000+0xfc00fe00) end
        if draw[9] then part(core.wreck[2],0xf500+0xf600fb00) end
        if draw[8] then part(core.wreck[1],0x0b00+0xf600fb00) end
        if draw[7] then part(wingB.wingB[hull],0xf600ef00+0xf400f900) end
        if draw[6] then part(wingA.wingA[hull],0xf6001100+0xf400f900) end
        if draw[5] then part(wingB.podB[hatch],0xf500+0xf600fb00) end
        if draw[4] then part(wingA.podA[hatch],0x0b00+0xf600fb00) end
        if draw[0] then
            part(core.body[1],0xf400f800)
            part(core.engine[floor(o.engineFrame/4)+1],0x16000000+0xf600f700)
        end
    end
end
