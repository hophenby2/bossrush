-- 六面A主Boss首非：ecldata6 Sub33/34/35/49，Lunatic。
-- Boss Rush从宿主入场落位进入攻击根；辉夜陪场与原对话由阶段接口承接。
return function(EX)
    local PI=math.pi
    local function norm(a) return (a+PI)%(2*PI)-PI end
    local function burst(o,reverse)
        OriginalStageVisual.source_event(o,8,'ecldata6',{0,62})
        if EX.pool_used()<EX.POOL_MAX then OriginalStageVisual.presentation.sound.play(8,7,o.x) end
        local a=ran:Float(-PI,PI)
        EX.set_record(o,0,EX.K.CULL,0,120,-1,-1,-1)
        for i=0,31 do
            local n=32-i
            local x,y=o.x+64*math.cos(a),o.y-64*math.sin(a)
            EX.set_record(o,1,EX.K.REL,1,60,1,
                n%2==0 and 2.5132741928100586 or -2.5132741928100586,1.3)
            EX.set_record(o,2,EX.K.WAIT,0,n,-1,-1,-1)
            EX.set_record(o,3,EX.K.SPRITE,0,2,reverse and 2 or 6,-1,-1)
            a=norm(a+(reverse and -1 or 1)*0.19634954631328583)
            EX.shoot(o,x,y,{op=97,type=17,color=EX.color(reverse and 1 or 5),
                count1=22,count2=1,speed1=3.65,speed2=0.875,
                angle=-a,step=-0.2454369217157364,flags=156224})
        end
    end
    local function move(o,c)
        local x,y=o.x+192,224-o.y
        local a
        if player.x<o.x then a=norm(ran:Float(0,PI/2)+3*PI/4)
        else a=ran:Float(0,PI/2)-PI/4 end
        if x<128 then
            if a>PI/2 then a=PI-a elseif a< -PI/2 then a=-PI-a end
        end
        if x>256 then
            if a<PI/2 and a>=0 then a=PI-c.angle
            elseif a> -PI/2 and a<=0 then a=-PI-a end
        end
        if y<96 and a<0 then a=-a end
        if y>80 and a>0 then a=-a end
        c.move={x=o.x,y=o.y,dx=60*math.cos(a),dy=-60*math.sin(a),t=0}
    end
    return {
        init=function(o)
            EX.clear_records(o);EX.pool_clear()
            o.th08_manual_main_anm=true
            OriginalStageVisual.source_event(o,8,'ecldata6',{0,59,0})
            o.eirin_first={t=0,angle=0}
        end,
        frame=function(o)
            local c=o.eirin_first
            if not c then return end
            local t=c.t
            -- t60的CALL49耗32拍；尾跳540→60落在CALL34，后续不重放CALL49。
            if t>=92 then
                local p=(t-92)%480
                if p==0 then burst(o,false)
                elseif p==240 then burst(o,true)
                elseif p==180 or p==420 then move(o,c) end
            end
            local m=c.move
            if m then
                m.t=m.t+1
                local u=math.min(1,m.t/60)
                local p=1-(1-u)^2
                local x,y=m.x+m.dx*p,m.y+m.dy*p
                c.angle=math.atan2(-(y-o.y),x-o.x)
                o.x,o.y=x,y
                if m.t>=60 then c.move=nil end
            end
            o.x=math.max(-160,math.min(160,o.x))
            o.y=math.max(96,math.min(176,o.y))
            c.t=t+1
        end,
        del=function(o)
            o.eirin_first=nil
            o.th08_manual_main_anm=nil
            EX.clear_records(o);EX.pool_clear()
        end,
    }
end
