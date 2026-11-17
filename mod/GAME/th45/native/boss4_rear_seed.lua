-- 0x19edb8 沿后舱输送带落下。0x19ef3a 将游机放出的五个光点分别推进。
return function(program,bullets,effects,art)
    local band=require('bit').band
    local floor,s16=math.floor,program.s16
    local images=program.boss4.images
    local seed,spark={parts=1},{parts=1}

    local function place(o)
        o.owner,o.h,o.l=o.row.owner,o.row.h,o.row.l
        o.frame,o.artClock=0,1
    end

    local function beyond(o)
        if band(o.h+0x800,0xffff)<0x8000 and
            band(o.l+0x1000+o.run.cameraOffset,0xffff)<0x5800 then
            o.seen=true
        else return o.seen end
    end

    local function animation(o,count)
        o.artClock=o.artClock-1
        if o.artClock>=0 then return end
        o.artClock=1
        o.frame=(o.frame+1)%count
    end

    function seed.init(o)
        place(o)
        o.flags,o.front,o.back,o.right,o.left,o.hp=unpack(program.boss4.rearSeedBox)
        o.delay,o.palette=0x18,19
        return true
    end

    function seed.step(o)
        local run,owner=o.run,o.owner
        if owner.phase>=2 or run.boss4~=owner or o.hp<0 then
            effects.emit(o,0x8b,0x10,0x80,0,false,12)
            return false
        end
        o.palette=o.impact and (o.palette==19 and 31 or 19) or 19
        o.impact=nil
        if run.stopPathClock then return true end
        local speed=owner.engineOffset
        if run.freeze then speed=floor(speed/2) end
        o.h,o.l=s16(o.h-speed),s16(o.l+owner.deltaL+run.cameraStep)
        if beyond(o) then return false end
        if run.freeze then return true end
        if o.delay>=0 then
            o.delay=o.delay-1
            if o.delay<0 then
                local queue=run.spawnQueue
                for i=0,4 do
                    queue[#queue+1]={[3]=0x76,[4]=0,[10]=0x19ef3a,owner=owner,h=o.h,l=o.l,
                        speed=8+6*i,angle=o.row.direction,shotSpeed=2*i}
                end
            end
        end
        animation(o,8)
        return true
    end

    function seed.render(o)
        local assets=o.run.art
        if assets then art.draw(assets.sprites[images.drone[o.palette][o.frame+1]],o.h,o.l,-0x400,-0x300) end
    end

    function spark.init(o)
        place(o)
        o.flags=0x8000
        o.speed,o.angle,o.shotSpeed=o.row.speed,o.row.angle,o.row.shotSpeed
        o.fireClock,o.left,o.count=0x10,2,2
        return true
    end

    function spark.step(o)
        local run=o.run
        local dh,dl=program.vector(o.speed,o.angle,run.slowVectors)
        o.h,o.l=s16(o.h+dh),s16(o.l+dl)
        if beyond(o) then return false end
        if run.freeze then return true end
        if o.dissolve then
            animation(o,17)
            return o.frame<16
        end
        if o.owner.phase>=2 or run.boss4~=o.owner then
            o.dissolve,o.frame,o.artClock=true,0,1
        else
            o.fireClock=o.fireClock-1
            if o.fireClock<0 then
                o.fireClock=1
                bullets.emit(o,13,o.shotSpeed,0x80,0,0,false)
                o.left=o.left-1
                if o.left==0 then o.left,o.count,o.fireClock=o.count,o.count+1,0xe end
            end
            animation(o,6)
        end
        return true
    end

    function spark.render(o)
        local assets=o.run.art
        if assets then
            local frames=o.dissolve and images.rearSparkEnd[26] or images.rearSpark[26]
            art.draw(assets.sprites[frames[o.frame+1]],o.h,o.l,o.dissolve and -0x200 or -0x400,-0x200)
        end
    end

    return seed,spark
end
