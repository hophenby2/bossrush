-- Unity 变换的数值求值；保留原适配层每一步 Vector 运算的单精度舍入。
-- 中间父级变换使用数字返回值，最终属性仍返回独立值对象，不能把可变向量缓存给调用方。
return function(CS)
    local f=CS.f
    local function angle(t)
        local parent=rawget(t,'_parent')
        return f(t._angle+(parent and angle(parent) or 0))
    end
    local function scale(t)
        local s=t._scale;local parent=rawget(t,'_parent')
        if not parent then return s.x,s.y,s.z,s.w end
        local x,y,z,w=scale(parent)
        return f(x*s.x),f(y*s.y),f(z*s.z),f(w*s.w)
    end
    local function position(t)
        local v=t._local;local parent=rawget(t,'_parent')
        if not parent then return v.x,v.y,v.z,v.w end
        local x,y,z,w=position(parent)
        local sx,sy,sz=scale(parent)
        local vx,vy,vz=f(v.x*sx),f(v.y*sy),f(v.z*sz)
        local a=angle(parent)
        local rx,ry=f(vx*cos(a)-vy*sin(a)),f(vx*sin(a)+vy*cos(a))
        return f(x+rx),f(y+ry),f(z+vz),f(w+0)
    end
    return {
        angle=angle,
        coordinates=position,
        position=function(t) return CS.Vector4(position(t)) end,
        scale=function(t) return CS.Vector4(scale(t)) end,
    }
end
