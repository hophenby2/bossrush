-- 两篇 Barrage.LUpdate 共用的直线几何；各篇保留自己的索引、出屏范围与退场时限。
return function(R,interpolate,options)
    local box=require('ffi').new('float[1]')
    local function f32(x) box[0]=x;return box[0] end
    local radians,degrees,pi=f32(.0174532924),f32(57.29578),f32(math.pi)
    local function velocity(s,speed,direction)
        local a=f32(f32(direction)*radians)
        return f32(f32(f32(s.xscale or 1)*f32(speed))*f32(math.cos(a))),
               f32(f32(f32(s.yscale or 1)*f32(speed))*f32(math.sin(a)))
    end
    return function(s)
        local alive=s.age<=s.life and not s.dis
        local ray=s.Ray==true or s.Ray=='Ray'
        if alive then
            if s.Sonevents then s.Sonevents(s,s.age,R) end
            interpolate(s)
            s.wscale=f32(s.wscale);s.rwscale=s.wscale
            if ray then s.rlongs=792;s.head=s.sonspeedd
            else
                local mx,my=s.mx,s.my
                if mx==nil or s.sonmotion_dirty then mx,my=velocity(s,s.sonspeed,s.sonspeedd) end
                s.head=my~=0 and f32(f32(f32(pi/2)-f32(math.atan(f32(mx/my)))+(my<0 and pi or 0))*degrees) or (mx<0 and 180 or 0)
                if s.rlongs<s.longs and not s.alreadyLong then s.rlongs=f32(s.rlongs+s.sonspeed) end
                if s.rlongs>=s.longs then s.alreadyLong=true end
            end
            if ray or s.alreadyLong then
                if not ray then s.rlongs=s.longs end
                if s.mx==nil or s.sonmotion_dirty then s.mx,s.my=velocity(s,s.sonspeed,s.sonspeedd);s.sonmotion_dirty=false end
                if s.ax==nil or s.sonaccel_dirty then s.ax,s.ay=velocity(s,s.sonaspeed,s.sonaspeedd);s.sonaccel_dirty=false end
                local scale=f32(s.controller.slow or 1)
                s.mx=f32(s.mx+f32(s.ax*scale));s.my=f32(s.my+f32(s.ay*scale))
                s.fx=f32(s.fx+f32(s.mx*scale));s.fy=f32(s.fy+f32(s.my*scale))
            end
        else
            if not ray then
                if s.mx==nil then s.mx,s.my=velocity(s,s.sonspeed,s.sonspeedd) end
                if s.ax==nil then s.ax,s.ay=velocity(s,s.sonaspeed,s.sonaspeedd) end
                s.mx=f32(s.mx+s.ax);s.my=f32(s.my+s.ay)
                s.fx=f32(s.fx+s.mx);s.fy=f32(s.fy+s.my)
                s.rlongs=math.max(0,f32(s.rlongs-s.sonspeed))
            else s.head=s.sonspeedd end
            if options.fadeEventsFirst then interpolate(s) end
            s.wscale=math.max(0,f32(s.wscale-f32(f32(.1)*(s.rwscale or s.wscale))))
            if not options.fadeEventsFirst then interpolate(s) end
        end
        return s.type<options.firstType or not alive and (s.wscale<=0 or options.tailFrames and s.age>s.life+options.tailFrames)
            or alive and s.alreadyLong and not ray and options.outside(s)
    end
end
