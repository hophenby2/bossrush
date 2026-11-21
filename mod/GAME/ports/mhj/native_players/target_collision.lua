-- 原桥接的矩形受弹判定；直接计算单精度坐标，避免每发自机弹为每个目标创建 Vector2。
return function(CS,valid,scale,cx,cy)
    return function(o,p,extend,ray)
        if not valid(o) or not o.colli then return false end
        local c=o.native_actor_collision
        if c and c.noDamage then return false end
        -- pos(o) 的 Vector2 构造会分别舍入 x/y，不能直接拿未舍入的宿主坐标比较。
        local x,y=CS.f(o.x/scale+cx),CS.f(cy-o.y/scale)
        local a,b=c and c.damage[1] or o.a,c and c.damage[2] or o.b
        if ray then a,b=a*2,b*2 end
        return math.abs(p.X-x)<=a/scale+extend and math.abs(p.Y-y)<=b/scale+extend
    end
end
