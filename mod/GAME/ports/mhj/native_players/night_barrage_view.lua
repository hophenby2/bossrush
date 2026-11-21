-- SpecialSystem 只在 Update 内使用弹体视图；属性始终读写正式弹体，复用容器避免逐帧创建代理与闭包。
return function(CS,R)
    local csm,owners,particles,stamp,populated
    local particleMeta={
        __index=function(p,k)
            local b=p[2]
            if k=='Dis' then return b.dis~=nil elseif k=='NeedDelete' then return 0 elseif k=='time' then return b.age
            elseif k=='x' then return b.fx elseif k=='y' then return b.fy elseif k=='add' then return 0
            elseif k=='centerMasked' then return false end
            return b[k]
        end,
        __newindex=function(p,k,v)
            local o,b=p[1],p[2]
            if k=='Dis' then if v and not b.dis then Del(o) end
            elseif k=='time' then b.age=v else b[k]=v end
        end,
    }
    local function clearList(list)
        for i=list.count-1,0,-1 do list.items[i]=nil end
        list.count=0
    end
    local function reset()
        csm={csc=CS.List()};owners={};particles={};stamp=0;populated=false
    end
    local function view(required)
        if required==false then
            if populated then reset() end
            return csm
        end
        populated=true
        stamp=stamp+1
        clearList(csm.csc)
        for _,owner in pairs(owners) do clearList(owner.layerm.LayerArray[0].Barrages) end
        for o in pairs(R.objects) do if IsValid(o) then
            local b=o.mhj
            if b and b.is_projectile and not b.controller.effectLayer and not b.familiar then
                local owner=owners[b.controller]
                if not owner then
                    owner={highlightDispel=true,layerm={LayerArray=CS.List()}}
                    owner.layerm.LayerArray:Add({Barrages=CS.List()});owners[b.controller]=owner
                end
                if owner.viewStamp~=stamp then
                    owner.viewStamp=stamp;owner.highlightDispel=true;csm.csc:Add(owner)
                end
                local particle=particles[o]
                if particle then particle[2],particle[3]=b,stamp
                else particle=setmetatable({o,b,stamp},particleMeta);particles[o]=particle end
                owner.layerm.LayerArray[0].Barrages:Add(particle)
            end
        end end
        -- 强引用缓存显式移除退役对象，不让代理到引擎对象的引用形成弱表环。
        for o,p in pairs(particles) do if p[3]~=stamp then particles[o]=nil end end
        for controller,owner in pairs(owners) do if owner.viewStamp~=stamp then owners[controller]=nil end end
        return csm
    end
    reset()
    return view,reset
end
