-- 0x197d9c 的船首与后舱绘制分开取坐标。外壳破坏时换用同位置的残件帧。
return function(program,art,cannon)
    local band=require('bit').band
    local floor=math.floor
    local data=program.boss4

    return function(o)
        local assets=o.run.art
        if not assets then return end
        local function draw(name,bank,frame,origin,offset,flip)
            local id=data.images[name][bank][(frame or 0)+1]
            local h,l=program.addPacked(origin.h,origin.l,offset)
            art.draw(assets.sprites[id],h,l,0,0,flip)
        end
        if o.frontVisible then
            local bank=o.mainPalette
            draw('frontBase',bank,0,o,0xd8000000+0xec00f600)
            draw('frontEngine',bank,o.engineFrame,o,0xd8000000+0x22000000+0xf200f100)
            draw('frontTop',bank,0,o,0xd8000000+0x13400000+0xfa00fd00+o.frontRaise*0x10000)
            draw('leftInset',bank,0,o,0xd8000000+0xfbfff800+0xf400fe00)
            draw('rightInset',bank,0,o,0xd8000000+0xfbfff800+0xf400fe00+0x1000)
            draw('frontRotor',bank,o.frontRotor,o,0xd8000000+0x04000000+0xf600fd00)
            if o.glow then
                draw('rotorFlash',30,o.glowFrame[1],o,0xc0fffa00+0xf600fd00)
                draw('rotorFlash',30,o.glowFrame[2],o,0xc0fffa00+0xf600fd00+0xd00,true)
            end
            for i,offset in ipairs(cannon) do
                draw('gun',bank,floor(band(o.gunDraw[i]+2,0xf8)/8),o,offset+0xfc00fc00)
            end
            if o.broken[1] then draw('lowerLeftWreck',bank,0,o,0xd8000000+0xf300+0xf000fb00)
            else draw('lowerLeft',bank,o.hatchFrame,o,0xd8000000+0xf200+0xf000fa00) end
            if o.broken[2] then draw('lowerRightWreck',bank,0,o,0xd8000000+0xe00+0xf000fa00)
            else draw('lowerRight',bank,o.hatchFrame,o,0xd8000000+0xe00+0xf000fa00) end
            if o.broken[3] then draw('upperLeftWreck',bank,0,o,0xd8000000+0x1ffff400+0xf000fc00)
            else draw('upperLeft',bank,o.hatchFrame,o,0xd8000000+0x1ffff200+0xf000fa00) end
            if o.broken[4] then draw('upperRightWreck',bank,0,o,0xd8000000+0x20000c00+0xf000fc00)
            else draw('upperRight',bank,o.hatchFrame,o,0xd8000000+0x20000f00+0xf000f900) end
        end
        if o.rearVisible==false then return end
        local rear,bank=o.rear,o.rearPalette
        draw('rearBase',bank,0,rear,0xec00f400+0x1cc00000+0xf8000000)
        draw('rearVent',bank,o.rearHatch,rear,0xf400f000+0xf8000000)
        draw('rearRotor',o.rotorPalette,o.rearRotor,rear,0xec00f900+0x1d000000+0xf8000000)
        if o.glow then
            draw('rotorFlash',30,o.glowFrame[1],rear,0xe8fffa00+0xf600fd00)
            draw('rotorFlash',30,o.glowFrame[2],rear,0xe8fffa00+0xf600fd00+0xd00,true)
        end
        if o.phase>=2 then return end
        draw('rearCore',bank,0,rear,0xf200fa00+0x0f000000+0xf8000000+o.rearCoreOffset*0x10000)
        if o.broken[6] then draw('rearLeftWreck',bank,0,rear,0xf400fb00+0x037ff700+0xf8000000)
        else draw('rearLeft',bank,0,rear,0xf400fa00+0x037ff600+0xf8000000-o.rearSpan) end
        if o.broken[7] then draw('rearRightWreck',bank,0,rear,0xf400fb00+0x03800900+0xf8000000)
        else draw('rearRight',bank,0,rear,0xf400f800+0x03800c00+0xf8000000+o.rearSpan) end
    end
end
