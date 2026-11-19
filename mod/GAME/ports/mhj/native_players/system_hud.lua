-- StringHelper 保留原版十进制字符池的填充和首位索引语义。
return function(B)
    local CS,E=B.CS,B.CS.env
    E.Color={White=CS.Colors(1,1,1,1)}
    E.TextureAlign={Left=0}
    E.StringHelper={__static=true,
        GetBitCountOfInt=function(n)
            local count=1
            while CS.trunc(n/10)~=0 do n=CS.trunc(n/10);count=count+1 end
            return count
        end,
        GetBitByBigEndian=function(n,count,index) return index>=0 and index<count and math.floor(n/10^(count-index-1))%10 or 0 end,
        IntParse=function(chars,n,right,holder)
            local original,first,seen=n,0,false
            holder=holder or 48
            if holder=='0' then holder=48 end
            for i=0,chars.Length-1 do
                local divisor=10^(chars.Length-i-1)
                local digit=CS.trunc(n/divisor)
                if digit~=0 then n=n-divisor*digit;if not seen then first,seen=i,true end end
                chars[i]=digit==0 and not seen and holder or digit+48
            end
            if right and seen then for j=first,chars.Length-1 do
                chars[j-first]=chars[j];if first~=0 then chars[j]=holder end
            end end
            if original==0 then chars[chars.Length-1]=48;return chars.Length-1 end
            return first
        end,
    }
    E.EffectHelper={__static=true,Circle=2,DrawCircle=function(s,...) s:Circle(...) end}
    E.Game.Res=E.Game.Res or {}
    E.Game.Res.number='39_hud_number'
    local batch=dofile('THlib/UI/native/mhj.lua')(B.level,CS)
    return function(system,x,y)
        if x then
            local night=B.level==37
            local z=night and .65 or 1
            batch:transform(x-(night and 36 or 27)*z,screen.height-y-(night and 544 or 428)*z,z,screen.height)
        elseif B.level==37 then batch:transform(240,0,1.5,1080)
        else batch:transform(0,0,1,480) end
        system:Draw(batch)
    end
end
