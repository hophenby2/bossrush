-- 雪莲华 Unity 场景的背景节点。原作的 FixedUpdate 为 120 Hz。
local B={}
local Source=dofile('mod/GAME/ports/source_mesh.lua')
local path='mod/GAME/th38/scenes/'
local assets='Resources/th38/background/unity/'
local scenes={}
local releaseGeometry=dofile(path..'release_geometry.lua')
local Presentation=dofile('mod/GAME/th38/presentation.lua')
local meshes
local ready
local floor,min,max=math.floor,math.min,math.max
local sin,cos,rad=math.sin,math.cos,math.rad
local identity={0,0,0,1}
local noUV={1,1,0,0}
local noScripts={}
local vertexPool={}
local function unit(x) return max(0,min(1,x)) end
local function translated(p,v,k)
    return {p[1]+v[1]*k,p[2]+v[2]*k,p[3]+v[3]*k}
end
local function multiply(a,b)
    local x,y,z,w=a[1],a[2],a[3],a[4]
    local u,v,t,s=b[1],b[2],b[3],b[4]
    return {w*u+x*s+y*t-z*v,w*v-x*t+y*s+z*u,w*t+x*v-y*u+z*s,w*s-x*u-y*v-z*t}
end
local function euler(x,y,z)
    x,y,z=rad(x)*.5,rad(y)*.5,rad(z)*.5
    -- Unity Quaternion.Euler 依次应用 Z、X、Y。
    return multiply(multiply({0,sin(y),0,cos(y)},{sin(x),0,0,cos(x)}),{0,0,sin(z),cos(z)})
end
local function power(q,n)
    if n==0 then return identity end
    local a=math.acos(max(-1,min(1,q[4])))
    local denom=sin(a)
    if math.abs(denom)<1e-9 then return identity end
    local f=sin(a*n)/denom
    return {q[1]*f,q[2]*f,q[3]*f,cos(a*n)}
end
-- 列分别是局部 X/Y/Z 轴在父坐标下的向量，后三项是平移。
local function matrix(p,q,s)
    local x,y,z,w=q[1],q[2],q[3],q[4]
    return {
        (1-2*(y*y+z*z))*s[1],2*(x*y+z*w)*s[1],2*(x*z-y*w)*s[1],
        2*(x*y-z*w)*s[2],(1-2*(x*x+z*z))*s[2],2*(y*z+x*w)*s[2],
        2*(x*z+y*w)*s[3],2*(y*z-x*w)*s[3],(1-2*(x*x+y*y))*s[3],
        p[1],p[2],p[3],
    }
end
local function vector(m,x,y,z)
    return m[1]*x+m[4]*y+m[7]*z,m[2]*x+m[5]*y+m[8]*z,m[3]*x+m[6]*y+m[9]*z
end
local function point(m,x,y,z)
    local a,b,c=vector(m,x,y,z)
    return a+m[10],b+m[11],c+m[12]
end
local function compose(a,b)
    local x1,y1,z1=vector(a,b[1],b[2],b[3])
    local x2,y2,z2=vector(a,b[4],b[5],b[6])
    local x3,y3,z3=vector(a,b[7],b[8],b[9])
    local x,y,z=point(a,b[10],b[11],b[12])
    return {x1,y1,z1,x2,y2,z2,x3,y3,z3,x,y,z}
end
local function position(origin,track,t)
    if not track then return origin end
    local p=translated(origin,track.speed_start,max(0,t+1))
    for i,at in ipairs(track.time_change) do
        local elapsed=max(0,t-at)
        local length=max(1,track.time_change_long[i])
        local n=min(length,elapsed)
        -- Camara_translate 先移动，再改变速度。每段加速的积分为三角数。
        p=translated(p,track.speed_change[i],n*(n+1)/(2*length)+max(0,elapsed-length))
    end
    return p
end
local function rotation(original,track,t)
    if not track then return original end
    local angles=track.rotate_start
    for i,at in ipairs(track.time_change) do
        if t>at then
            local f=unit((t-at-1)/max(1,track.time_change_long[i]))
            angles=translated(track.baseline[i],track.rotate_change[i],(1-cos(math.pi*f))*.5)
        end
    end
    return euler(unpack(angles))
end
local function recycle(loop,speeds,t,started)
    local nextTick=started+loop.time_start
    local period=loop.time_start
    local count=0
    if period<=0 then return 0 end
    local function countUntil(last)
        if nextTick<=last then
            local n=floor((last-nextTick)/period)+1
            count,nextTick=count+n,nextTick+n*period
        end
    end
    for i,at in ipairs(speeds and speeds.set_time or {}) do
        if at>t then break end
        if at>=started then
            countUntil(at-1)
            -- 变速不重置正在进行的那一轮。
            period=max(1,speeds.set_speed[i])
        end
    end
    countUntil(t)
    return count
end
local function fade(script,t)
    return unit((t-(script.time_yanshi or 0)+1)/max(1,script.time_long or 1))
        *(script.a_kuadu~=0 and script.a_kuadu or 1)*(script.jianxian_or_jianyin==1 and 1 or -1)
end
local function sceneData(key)
    if not scenes[key] then
        local raw=dofile(path..key..'.lua')
        for index,geometry in pairs(releaseGeometry[key] or {}) do
            local sprite=assert(raw.nodes[tonumber(index)].sprite)
            sprite.size,sprite.pivot=geometry.size,geometry.pivot
        end
        local names={}
        for i,d in ipairs(raw.nodes) do
            names[d.name]=names[d.name] or i
            d.scripts=d.scripts or noScripts
            if next(d.scripts)==nil then d.staticMatrix=matrix(d.pos,d.rot,d.scale) end
            local rotationTrack=d.scripts.Camara_rotate
            if rotationTrack then
                local m=matrix({0,0,0},d.rot,{1,1,1})
                local angles={math.deg(math.asin(max(-1,min(1,-m[8])))),
                    math.deg(math.atan2(m[7],m[9])),math.deg(math.atan2(m[2],m[5]))}
                rotationTrack.baseline={}
                for j,delta in ipairs(rotationTrack.rotate_change) do
                    rotationTrack.baseline[j]=angles
                    angles=translated(angles,delta,1)
                end
            end
            if d.scripts.St4BG then raw.colorTrack=d.scripts.St4BG end
            if d.particles then
                local ps=d.particles
                ps.shapeMatrix=matrix(ps.shapePos,euler(unpack(ps.shapeRot)),ps.shapeScale)
                ps.forward=matrix({0,0,0},euler(unpack(ps.shapeRot)),{1,1,1})
                ps.seed=ps.seed~=0 and ps.seed or i*97
            end
            if d.children then
                d.childSlot={}
                for j,child in ipairs(d.children) do d.childSlot[child]=j end
            end
        end
        raw.names=names
        scenes[key]=raw
    end
    return scenes[key]
end
local function cameraPos(data,name,t)
    local d=data.nodes[data.names[name]]
    return position(d.pos,d.scripts.Camara_translate,t)
end
local function stageChanges(o)
    local t,story=o.clock,o.story
    if o.chapter=='3' and o.variant=='' then
        if story>=11970 and not o.gate then o.gate=t-(story-11970) end
        if story>=12170 and not o.flash then o.flash=t-(story-12170) end
        if story>=12320 and not o.second then o.second=t-(story-12320) end
    elseif o.chapter=='5' and o.variant~='_spell' then
        if t>=11000 and not o.partB and o.variant=='' then o.partB=11000 end
        if o.partC and t>=o.partC and not o.partCPos then
            o.partCPos=cameraPos(o.data,'Camera_3D',o.partC)[3]
        end
    elseif o.chapter=='EXA' and story>=21700 and not o.extraWave then
        o.extraWave=t
        o.extraY=cameraPos(o.data,'Camera_3D',t)[2]
    end
end
local function phase(o,d,parent)
    local at=parent and parent.start or 0
    local active=d.on~=0 and (not parent or parent.active)
    local game=o.story
    if d.phase=='gate' then
        at=o.gate or 0;active=active and o.gate~=nil
    elseif d.phase=='second' then
        at=o.second or 0;active=active and o.second~=nil
    elseif d.name=='ST3_part1' and o.second then
        active=false
    elseif o.chapter=='5' and o.variant~='_spell' then
        if d.name=='ST5A' then active=active and not o.partB and not o.partCPos end
        if d.name=='ST5B' then
            at=o.partB or 0
            active=(o.partB~=nil or o.variant=='_boss') and not o.partCPos
        end
        if d.name=='ST5C' then active=o.partCPos~=nil;at=o.partC or 0 end
    elseif o.chapter=='6' then
        if d.name=='WaterProNighttime' then active=active and game>=8500 and game<14500 end
        if d.name=='WaterProDaytime' then active=active and game<8800 end
    end
    local rock=parent and parent.data.scripts.St4rock
    if rock then
        if d.name=='p1' then active=active and game<rock.change1+240 end
        if d.name=='p2' then active=active and game>=rock.change1 and game<rock.change2+240 end
        if d.name=='p3' then active=active and game>=rock.change2 end
        if d.name=='p2' and game>=rock.change1 then at=o.clock-(game-rock.change1) end
        if d.name=='p3' and game>=rock.change2 then at=o.clock-(game-rock.change2) end
    end
    return active,at
end
local function transforms(o)
    local nodes=o.data.nodes
    local list=o.transforms
    local t,story=o.clock,o.story
    for i,d in ipairs(nodes) do
        local parent=list[d.parent]
        local scripts=d.scripts
        local n=list[i]
        if not n then n={data=d};list[i]=n end
        local active,started=phase(o,d,parent)
        local age=max(0,t-started)
        local tr=position(d.pos,scripts.Camara_translate,t)
        local q=rotation(d.rot,scripts.Camara_rotate,t)
        local shift=scripts.Tongyong_weiyi_add
        if shift then
            for j,at in ipairs(shift.start_time) do
                local len=max(1,shift.time_long[j])
                local k=unit((t-at+1)/len)
                if shift.ifsin==1 then k=(1-cos(math.pi*k))*.5
                elseif len~=1 then k=0 end -- C# 的 1 / time_long 是整除。
                tr=translated(tr,shift.pos_add[j],k)
            end
        end
        local align=scripts.Tongyong_weiyi_jiaozhun
        if align and story>=align.time then tr=align.weizhi end
        local rotate=scripts.Tongyong_xuanzhuan2
        if rotate then q=multiply(q,power(euler(unpack(rotate.zhuansu)),age+1)) end
        local drift=scripts.Tongyong_translate
        if drift then
            local axes=matrix({0,0,0},q,{1,1,1})
            tr=translated(tr,{vector(axes,unpack(drift.v3))},age+1)
        end
        if parent and parent.cycles and #parent.data.children>0 then
            local slot=parent.data.childSlot[i]
            local size=#parent.data.children
            if slot then
                local laps=max(0,1+floor((parent.cycles-slot)/size))
                if laps>0 then tr=translated(tr,parent.data.scripts.Camara_BG_xunhuan.pos_add,laps) end
            end
        end
        local loop=scripts.Camara_BG_xunhuan
        n.cycles=loop and recycle(loop,scripts.Camara_setBG_speed,t,started)
        local vanish=scripts.Camara_death
        local storyVanish=scripts.Tongyong_death_shijianzhou or scripts.Tongyong_death_time_kedu
        if vanish and t>=vanish.time or storyVanish and story>=storyVanish.death_time and not o.boss then
            active=false
        end
        if o.chapter=='3' then
            if d.phase=='gate' and o.gate then
                tr={tr[1],tr[2],cameraPos(o.data,'Camera_3D',o.gate)[3]+50}
            elseif parent and parent.data.phase=='second' and o.second then
                if d.name=='xuedi' then tr={tr[1],tr[2],cameraPos(o.data,'Camera_3D',o.second)[3]+7.5} end
                if d.name=='lianhua' then tr={tr[1],tr[2],cameraPos(o.data,'Camera_3D',t)[3]+16.5+min(10,age*.02)} end
            end
        elseif o.chapter=='5' then
            if d.name=='ADD' and parent and parent.data.name=='ST5B' and o.partB then
                tr={tr[1],tr[2],tr[3]+cameraPos(o.data,'Camera_3D',o.partB)[3]}
            elseif d.name=='ADD' and parent.data.name=='ST5C' and o.partCPos then
                tr={tr[1],tr[2],tr[3]+o.partCPos}
            elseif d.name=='Camera_3D_back' and o.variant~='_spell' then
                if o.partCPos then tr={-100,0,0}
                elseif o.partB then tr={-100,3.6,3.6} end
            elseif d.name=='Camera_3D' and o.partCPos then q=euler(10,.5,0) end
        elseif o.chapter=='6' and d.name=='WaterProDaytime' and story>=8500 then
            tr={tr[1],tr[2],tr[3]-(story-8500+1)*.1}
        elseif o.chapter=='6' and d.name=='WaterProNighttime' and story>=13500 then
            tr={tr[1],tr[2],tr[3]-(story-13500+1)*.03}
        elseif o.chapter=='EXA' and o.extraWave and d.name=='Camera_3D' then
            local lock=nodes[o.data.names.Camera_3D_back].scripts.STEX_came_lock
            if lock then tr={tr[1],o.extraY-2+2*cos((t-o.extraWave)%lock.shangxiazhouqi/lock.shangxiazhouqi*math.pi*2),tr[3]} end
        end
        local m=tr==d.pos and q==d.rot and d.staticMatrix or matrix(tr,q,d.scale)
        if parent then m=compose(parent.m,m) end
        local floating=scripts.ST5_piece_flot
        if floating then
            m[11]=m[11]+sin((age+floating.time_pianyi)/max(1,floating.time_zhouqi)*math.pi*2)*floating.beilv
        end
        local alpha=scripts.Tongyong_jianxianjianyin
        n.alpha=n.data.sprite and n.data.sprite.color[4] or 1
        if alpha then n.alpha=n.alpha+fade(alpha,age) end
        if parent then n.alpha=n.alpha+(parent.inheritedAlpha or 0) end
        n.inheritedAlpha=(parent and parent.inheritedAlpha or 0)+(alpha and alpha.yingyongziwuti==1 and fade(alpha,age) or 0)
        local pulse=scripts.Tongyong_minganbianhua
        if pulse and age>=pulse.time_start and pulse.zhouqi>0 then
            n.alpha=(pulse.max+pulse.min+(pulse.max-pulse.min)*sin((age-pulse.time_start)*2*math.pi/pulse.zhouqi))*.5
        end
        n.m,n.q,n.start,n.active=m,q,started,active
    end
    o.sceneLight,o.waterSpeed=nil,nil
    for _,n in ipairs(list) do
        local d,s=n.data,n.data.scripts
        if n.active and s.ST5_colorSet then o.sceneLight=s.ST5_colorSet.light_color end
        if n.active and s.st6_speed then o.waterSpeed=s.st6_speed end
        local lock=s.STEX_came_lock
        local follow=s.Tongyong_gensui_gameobj or s.Tongyong_pos_base
        if lock then
            local main=list[o.data.names.Camera_3D]
            n.m=matrix({n.m[10],main.m[11]*lock.beilv,n.m[12]},main.q,d.scale)
        elseif follow then
            local target=follow.if_camera==1 and o.data.names.Camera_3D or follow.obj or follow.father
            local base=list[target]
            if base then
                local p=follow.pianyi
                local x,y,z=base.m[10]+p[1],base.m[11]+p[2],base.m[12]+p[3]
                n.shiftX,n.shiftY,n.shiftZ=x-n.m[10],y-n.m[11],z-n.m[12]
                n.m[10],n.m[11],n.m[12]=x,y,z
            end
        end
    end
    -- 位置跟随脚本通常挂在一整组布景上。把位置变化传给已合成的子节点。
    for _,n in ipairs(list) do
        local p=list[n.data.parent]
        local x,y,z=0,0,0
        if p then
            x,y,z=p.dx,p.dy,p.dz
            n.m[10],n.m[11],n.m[12]=n.m[10]+x,n.m[11]+y,n.m[12]+z
        end
        n.dx,n.dy,n.dz=x+(n.shiftX or 0),y+(n.shiftY or 0),z+(n.shiftZ or 0)
        n.shiftX,n.shiftY,n.shiftZ=nil,nil,nil
    end
    return list
end
local function texture(o,key)
    if not key then return nil,1,1 end
    local name='th38_unity_'..key
    if not CheckRes('tex',name) then
        LoadTexture(name,assets..key)
        o.resources[name]=GetResourceStatus()
        SetTextureSamplerState(name,'linear+wrap')
    end
    local size=o.sizes[name]
    if not size then size={GetTextureSize(name)};o.sizes[name]=size end
    return name,size[1],size[2]
end
local function viewPoint(cam,x,y,z)
    local m=cam.matrix
    x,y,z=x-m[10],y-m[11],z-m[12]
    local distance=m[7]*x+m[8]*y+m[9]*z
    return (m[1]*x+m[2]*y+m[3]*z)*cam.zoomX+distance*cam.shift,
        (m[4]*x+m[5]*y+m[6]*z)*cam.zoomY,distance
end
local function vertex(camera,node,x,y,z,u,v,c)
    x,y,z=viewPoint(camera,point(node.m,x,y,z))
    return {x,y,z,u,v,c}
end
local function drawSprite(o,cam,n)
    Source.flush(o.meshBatch)
    local d=n.data.sprite
    local a=unit(n.alpha)
    if a<=0 then return end
    local tex,w,h=texture(o,d.tex)
    local rw,rh=d.size[1],d.size[2]
    local l,b=-rw*d.pivot[1],-rh*d.pivot[2]
    local rgb=d.color
    local u0,u1,v0,v1=0,w,0,h
    if d.flip[1]==1 then u0,u1=u1,u0 end
    if d.flip[2]==1 then v0,v1=v1,v0 end
    local r,t=l+rw,b+rh
    local function quad(texture,blend,u0,v0,u1,v1,color)
        RenderTexture(texture,blend,vertex(cam,n,l,t,0,u0,v0,color),vertex(cam,n,r,t,0,u1,v0,color),
            vertex(cam,n,r,b,0,u1,v1,color),vertex(cam,n,l,b,0,u0,v1,color))
    end
    quad(tex,d.blend,u0,v0,u1,v1,Color(a*255,rgb[1]*255,rgb[2]*255,rgb[3]*255))
    if d.cloud then
        local clock=o.clock/120
        local g=o.story
        local water=o.waterSpeed
        local speed=0
        if water then
            local up=unit((g-water.speed_add_time)/water.speed_add_long)
            local down=unit((g-water.speed_red_time)/water.speed_red_long)
            speed=water.speed+water.speed_add*(1-cos(math.pi*up))*.5-water.speed_red_zhen*(1-cos(math.pi*down))*.5
        end
        local sx,sy={3,-1.5-speed/100,1+speed/150,0},{-6-speed/6,0,0,1.5-speed/14}
        local tint=d.cloudColor
        local storm=n.data.name=='SKY1' and (unit((g-7700)/800)-unit((g-8600)/100)) or 0
        for i,key in ipairs(d.cloud) do
            local octave,ow,oh=texture(o,key)
            local u=sx[i]*clock/20*(.5+i*.5)*ow
            local v=-sy[i]*clock/20*(.5+i*.5)*oh
            local color=Color(80/(2^(i-1)),255*unit(tint[1]-.72*storm),
                255*unit(tint[2]-.72*storm),255*unit(tint[3]-.6*storm))
            quad(octave,'',u,v,u+ow,v+oh,color)
        end
    end
end
local function channel(keys,time,index,fallback)
    local first=keys[1]
    if not first then return fallback end
    for i=2,#keys do
        local nextKey=keys[i]
        if time<nextKey[1] then
            local f=unit((time-first[1])/(nextKey[1]-first[1]))
            return first[index]+(nextKey[index]-first[index])*f
        end
        first=nextKey
    end
    return first[index]
end
local function sizeAt(keys,time)
    local first=keys[1]
    if not first then return 1 end
    for i=2,#keys do
        local nextKey=keys[i]
        if time<nextKey[1] then
            local interval=nextKey[1]-first[1]
            local f=unit((time-first[1])/interval)
            local inv=1-f
            return (1+2*f)*inv*inv*first[2]+f*inv*inv*interval*first[4]
                +(3-2*f)*f*f*nextKey[2]-f*f*inv*interval*nextKey[3]
        end
        first=nextKey
    end
    return first[2]
end
local function gpuQuad(o,tex)
    o.quadMeshes=o.quadMeshes or {}
    if not o.quadMeshes[tex] then
        o.quadMeshes[tex]=lstg.CreateSourceModelMesh(tex,{-1,1,0,0,0,1,1,0,1,0,1,-1,0,1,1,-1,1,0,0,0,1,-1,0,1,1,-1,-1,0,0,1})
    end
    return o.quadMeshes[tex]
end
local function particleParameters(ps,i)
    local seed=(i*6151+ps.seed*197)%2147483646+1
    local function rand() seed=seed*16807%2147483647;return seed/2147483647 end
    local function between(range) return range[1]+(range[2]-range[1])*rand() end
    local p={life=between(ps.life)}
    local x,y,z
    if ps.shape==10 then
        local angle=rand()*math.pi*2;local radius=ps.radius*math.sqrt(1-rand()*ps.thickness)
        x,y,z=radius*cos(angle),radius*sin(angle),0
    else x,y,z=rand()-.5,rand()-.5,ps.shape==18 and 0 or rand()-.5 end
    p.x,p.y,p.z=point(ps.shapeMatrix,x,y,z)
    p.vx,p.vy,p.vz=vector(ps.forward,0,0,between(ps.speed))
    p.dx,p.dy,p.dz=between(ps.drift[1]),between(ps.drift[2]),between(ps.drift[3])
    p.size=between(ps.size);p.mix=rand();p.angle=between(ps.angle);p.spin=between(ps.rotating)
    return p
end
local function drawParticles(o,cam,n)
    local ps=n.data.particles
    local time=(o.clock-n.start)/120*ps.simulation-ps.delay
    if ps.prewarm==1 then time=time+ps.length end
    if time<=0 then return end
    local tex,w,h=texture(o,ps.tex)
    local latest=floor((ps.loop==1 and time or min(time,ps.length))*ps.rate)
    local earliest=max(1,latest-ps.maxCount+1,floor((time-max(unpack(ps.life)))*ps.rate)+1)
    local follow=n.data.scripts.Tongyong_gensui_gameobj
    local cache=n.particleCache
    if not cache or latest<cache.last then cache={first=earliest,last=latest,values={}};n.particleCache=cache end
    for i=cache.first,min(cache.last,earliest-1) do cache.values[i]=nil end
    cache.first,cache.last=earliest,latest
    local followsCamera=ps.localSpace==0 and follow and follow.if_camera==1
    local now=followsCamera and cameraPos(o.data,'Camera_3D',o.clock)
    local blend=tex and Source.available() and Source.blend(ps.blend)
    local quad=blend and gpuQuad(o,tex)
    local transform={}
    if not blend then Source.flush(o.meshBatch) end
    for i=earliest,latest do
        local p=cache.values[i]
        if not p then p=particleParameters(ps,i);cache.values[i]=p end
        local age=time-i/ps.rate
        local life=p.life
        if age<life and age>=0 then
            local px,py,pz=p.x+p.vx*age,p.y+p.vy*age,p.z+p.vz*age
            local x,y,z=point(n.m,px,py,pz)
            x,y,z=x+p.dx*age,y+p.dy*age-.5*9.81*ps.gravity*age*age,z+p.dz*age
            if followsCamera then
                local clock=o.clock-age*120/ps.simulation
                if p.bornClock~=clock then p.bornClock=clock;p.born=cameraPos(o.data,'Camera_3D',clock) end
                local born=p.born
                x,y,z=x+born[1]-now[1],y+born[2]-now[2],z+born[3]-now[3]
            end
            x,y,z=viewPoint(cam,x,y,z)
            local ratio=age/max(.0001,life)
            local r=min(p.size*sizeAt(ps.sizeCurve,ratio)*.5,z*cam.halfHeight*ps.maxSize)
            if r>0 and z>=cam.near and z<=cam.far and math.abs(x)<z*cam.halfWidth+r
                    and math.abs(y)<z*cam.halfHeight+r then
                local mix=p.mix
                local tint,alpha=ps.tint,channel(ps.alpha,ratio,2,1)
                local color,low=ps.color,ps.colorMin or ps.color
                alpha=alpha*(low[4]+(color[4]-low[4])*mix)*tint[4]
                if alpha>0 then
                    local c=Color(unit(alpha)*255,
                        unit(tint[1]*(low[1]+(color[1]-low[1])*mix)*channel(ps.rgb,ratio,2,1))*255,
                        unit(tint[2]*(low[2]+(color[2]-low[2])*mix)*channel(ps.rgb,ratio,3,1))*255,
                        unit(tint[3]*(low[3]+(color[3]-low[3])*mix)*channel(ps.rgb,ratio,4,1))*255)
                    local a=p.angle+p.spin*age
                    local rx,ry=r*cos(a),r*sin(a)
                    if quad then
                        transform[1],transform[2],transform[3]=rx,ry,0
                        transform[4],transform[5],transform[6]=-ry,rx,0
                        transform[7],transform[8],transform[9]=0,0,1
                        transform[10],transform[11],transform[12]=x,y,z
                        Source.queue(o.meshBatch,quad,transform,c,noUV,blend,0,false,0)
                    else RenderTexture(tex,ps.blend,{x-rx-ry,y+rx-ry,z,0,0,c},
                        {x+rx-ry,y+rx+ry,z,w,0,c},{x+rx+ry,y-rx+ry,z,w,h,c},{x-rx+ry,y-rx-ry,z,0,h,c})
                    end
                end
            end
        end
    end
end
local function nativeMesh(d,part,tex)
    d.native=d.native or setmetatable({},{__mode='k'})
    local byTexture=d.native[part] or {};d.native[part]=byTexture
    if not byTexture[tex] then
        local vertices={}
        for _,index in ipairs(part) do for j=1,5 do vertices[#vertices+1]=d.verts[index][j] end end
        byTexture[tex]=lstg.AndroidCreateModelMesh(FindResTexture(tex),vertices)
    end
    return byTexture[tex]
end
local function gpuMesh(o,d,part,tex)
    o.gpuMeshes=o.gpuMeshes or {}
    local byPart=o.gpuMeshes[d]
    if not byPart then byPart={};o.gpuMeshes[d]=byPart end
    local byTexture=byPart[part]
    if not byTexture then byTexture={};byPart[part]=byTexture end
    local key=tex or false
    if not byTexture[key] then
        local vertices={}
        for _,index in ipairs(part) do for j=1,5 do vertices[#vertices+1]=d.verts[index][j] end end
        byTexture[key]=lstg.CreateSourceModelMesh(tex,vertices)
    end
    return byTexture[key]
end
local function viewTransform(o,cam,n)
    if n.viewFrame~=o.renderRevision or n.viewCamera~=cam then
        local transform=n.viewMatrix or {};n.viewMatrix=transform
        local x,y,z=viewPoint(cam,point(n.m,0,0,0))
        for i=1,3 do
            local a,b,c=viewPoint(cam,point(n.m,i==1 and 1 or 0,i==2 and 1 or 0,i==3 and 1 or 0))
            transform[(i-1)*3+1],transform[(i-1)*3+2],transform[(i-1)*3+3]=a-x,b-y,c-z
        end
        transform[10],transform[11],transform[12]=x,y,z
        n.viewFrame,n.viewCamera=o.renderRevision,cam
    end
    return n.viewMatrix
end
local function drawMesh(o,cam,n,d,part,mat)
    local tex,w,h=texture(o,mat.tex)
    local rgb=mat.color or {1,1,1,1}
    local scripts=n.data.scripts
    local pulse=scripts.Tongyong_minganbianhua_shader or scripts.Tongyong_minganbianhua_shader2
    local opacity=rgb[4]
    if pulse then
        local time=o.clock-n.start-(pulse.time_start or 0)
        if time>=0 then
            opacity=(pulse.min+pulse.max+(pulse.max-pulse.min)*sin(time*2*math.pi/max(1,pulse.zhouqi)))*.5
        elseif pulse.first_base==1 then opacity=(pulse.min+pulse.max)*.5 end
    end
    -- 无纹理分支沿用白图 Render4V 的颜色口径。
    local c=Color(tex and unit(opacity)*255 or rgb[4]*255,rgb[1]*255,rgb[2]*255,rgb[3]*255)
    local uv=mat.uv or noUV
    local offset=mat.water and o.clock/120*.01 or 0
    local blend=Source.available() and Source.blend(mat.blend)
    if blend then
        local m=n.m
        local det=m[1]*(m[5]*m[9]-m[6]*m[8])-m[2]*(m[4]*m[9]-m[5]*m[6])+m[3]*(m[4]*m[8]-m[5]*m[7])
        Source.queue(o.meshBatch,gpuMesh(o,d,part,tex),viewTransform(o,cam,n),c,
            {uv[1],-uv[2],uv[3],1-uv[4]+offset},blend,mat.opaque==1 and 2 or 0,false,
            mat.cull==1 and (det<0 and 2 or 1) or 0)
        return
    end
    Source.flush(o.meshBatch)
    if tex and lstg.AndroidCreateModelMesh then
        local native=nativeMesh(d,part,tex)
        local x,y,z=viewPoint(cam,point(n.m,0,0,0))
        local transform={}
        for i=1,3 do
            local a,b,c=viewPoint(cam,point(n.m,i==1 and 1 or 0,i==2 and 1 or 0,i==3 and 1 or 0))
            transform[(i-1)*3+1],transform[(i-1)*3+2],transform[(i-1)*3+3]=a-x,b-y,c-z
        end
        transform[10],transform[11],transform[12]=x,y,z
        local m=n.m
        local det=m[1]*(m[5]*m[9]-m[6]*m[8])-m[2]*(m[4]*m[9]-m[6]*m[7])+m[3]*(m[4]*m[8]-m[5]*m[7])
        lstg.AndroidRenderModelMesh(native,mat.blend,c,transform,{uv[1],-uv[2],uv[3],1-uv[4]+offset},mat.cull==1 and det or 0)
        return
    end
    for i,v in ipairs(d.verts) do
        local output=vertexPool[i] or {}
        local x,y,z=viewPoint(cam,point(n.m,v[1],v[2],v[3]))
        output[1],output[2],output[3]=x,y,z
        output[4],output[5],output[6]=(v[4]*uv[1]+uv[3])*w,(1-v[5]*uv[2]-uv[4]+offset)*h,c
        local fx,fy=z*cam.halfWidth,z*cam.halfHeight
        output.clip=(x< -fx and 1 or 0)+(x>fx and 2 or 0)+(y< -fy and 4 or 0)
            +(y>fy and 8 or 0)+(z<cam.near and 16 or 0)+(z>cam.far and 32 or 0)
        vertexPool[i]=output
    end
    if not tex then SetImageState('white',mat.blend,rgb[4]*255,rgb[1]*255,rgb[2]*255,rgb[3]*255) end
    local m=n.m
    local det=m[1]*(m[5]*m[9]-m[6]*m[8])-m[2]*(m[4]*m[9]-m[6]*m[7])+m[3]*(m[4]*m[8]-m[5]*m[7])
    for i=1,#part,3 do
        local a,b,c=vertexPool[part[i]],vertexPool[part[i+1]],vertexPool[part[i+2]]
        if bit.band(a.clip,b.clip,c.clip)==0 then
            local facing=a[1]*(b[2]*c[3]-b[3]*c[2])-a[2]*(b[1]*c[3]-b[3]*c[1])+a[3]*(b[1]*c[2]-b[2]*c[1])
            if mat.cull~=1 or facing*det<0 then
                if tex then RenderTexture(tex,mat.blend,a,b,c,c)
                else Render4V('white',a[1],a[2],a[3],b[1],b[2],b[3],c[1],c[2],c[3],c[1],c[2],c[3]) end
            end
        end
    end
end
local function queueOrder(a,b)
    if a.sort~=b.sort then return a.sort<b.sort end
    if a.distance~=b.distance then return a.distance>b.distance end
    return a.index<b.index
end
local function drawCamera(o,cam,nodes)
    local camNode=nodes[cam.node]
    cam.matrix=camNode.m
    local world=lstg.world
    local width,height=world.r-world.l,world.t-world.b
    local aspect=width/height
    local fov=rad(o.sceneLight and cam.name=='main' and 80 or cam.fov)
    local tangent=math.tan(fov*.5)
    -- Unity 以 4:3 画布投影。其正交主相机中心在 (6.4,-4.8)，战斗原点在 (4.5,-4.8)。
    cam.halfWidth,cam.halfHeight=tangent*aspect,tangent
    cam.zoomX=6.4*48/(width*.5)*aspect/(4/3)
    cam.zoomY=4.8*48/(height*.5)
    cam.shift=(6.4+cam.rect*12.8-4.5)*48/(width*.5)*tangent*aspect
    Set3D('eye',0,0,0)
    Set3D('at',0,0,1)
    Set3D('up',0,1,0)
    Set3D('z',cam.near,cam.far)
    Set3D('fovy',fov)
    Set3D('fog',0,0,Color(255,0,0,0))
    SetViewMode('3d')
    ClearZBuffer()
    SetZBufferEnable(1)
    local queue={}
    for i,n in ipairs(nodes) do
        local d=n.data
        if n.active and floor(cam.mask/2^d.layer)%2==1 and (d.sprite or d.mesh or d.particles) then
            local x,y,z=viewPoint(cam,n.m[10],n.m[11],n.m[12])
            if d.sprite then
                local extent=max(d.sprite.size[1],d.sprite.size[2])
                    *max(math.abs(n.m[1])+math.abs(n.m[2])+math.abs(n.m[3]),math.abs(n.m[4])+math.abs(n.m[5])+math.abs(n.m[6]))
                if z+extent>=cam.near and z-extent<=cam.far and math.abs(x)<max(0,z)*tangent*aspect+extent
                        and math.abs(y)<max(0,z)*tangent+extent then
                    queue[#queue+1]={node=n,distance=z,sort=d.sprite.order,index=i}
                end
            elseif d.particles then
                queue[#queue+1]={node=n,particles=true,distance=z,sort=d.particles.order,index=i}
            else
                local mesh=meshes[d.mesh.key]
                local b=mesh.bounds
                local cx,cy,cz=viewPoint(cam,point(n.m,b[1],b[2],b[3]))
                local m=n.m
                local ax,ay,az=math.abs(m[1])+math.abs(m[2])+math.abs(m[3]),
                    math.abs(m[4])+math.abs(m[5])+math.abs(m[6]),math.abs(m[7])+math.abs(m[8])+math.abs(m[9])
                local e=b[4]*ax+b[5]*ay+b[6]*az
                local stretch=max(cam.zoomX+math.abs(cam.shift),cam.zoomY,1)
                if cz+e>=cam.near and cz-e<=cam.far and math.abs(cx)<=max(0,cz+e)*cam.halfWidth+e*stretch
                        and math.abs(cy)<=max(0,cz+e)*cam.halfHeight+e*stretch then
                    -- 将细分后的网格提交给兼容渲染接口。
                    local drawMeshData=mesh
                    for j,part in ipairs(drawMeshData.parts) do
                        local material=d.mesh.materials[j] or d.mesh.materials[#d.mesh.materials]
                        if material.opaque==1 then drawMesh(o,cam,n,drawMeshData,part,material)
                        else queue[#queue+1]={node=n,mesh=drawMeshData,mat=material,part=part,distance=cz,sort=0,index=i} end
                    end
                end
            end
        end
    end
    SetImageState('white','',255,255,255,255)
    SetZBufferEnable(0)
    table.sort(queue,queueOrder)
    for _,draw in ipairs(queue) do
        if draw.part then drawMesh(o,cam,draw.node,draw.mesh,draw.part,draw.mat)
        elseif draw.particles then drawParticles(o,cam,draw.node)
        else drawSprite(o,cam,draw.node) end
    end
    Source.flush(o.meshBatch)
end
local function fill(r,g,b,a)
    local w=lstg.world
    SetImageState('white','',a,r,g,b)
    RenderRect('white',w.l,w.r,w.b,w.t)
    SetImageState('white','',255,255,255,255)
end
local Scene=Class(background,{
    init=function(o,chapter,variant,start)
        background.DelBG()
        lstg.tmpvar.bg=o
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.BG-.1,false,false
        o.chapter,o.variant=chapter,variant
        o.data=sceneData(chapter..variant)
        o.clock,o.story=start,start
        o.transforms,o.resources,o.sizes={},{},{}
        o.meshBatch=Source.newBatch()
        if ready and ready.key==chapter..variant then
            o.resources,o.sizes,o.gpuMeshes,o.quadMeshes=ready.resources,ready.sizes,ready.gpuMeshes,ready.quadMeshes;ready=nil
        end
        stageChanges(o)
    end,
    frame=function(o)
        o.clock=o.clock+2
        if not o.sequence then
            if o.variant=='' then Presentation.title(o.chapter,o.story+1,o.story+2) end
            o.story=o.story+2
        end
        stageChanges(o)
    end,
    render=function(o)
        if not setting or not setting.displayBG then return end
        meshes=meshes or dofile(path..'meshes.lua')
        local previous=lstg.view3d
        lstg.view3d={}
        o.renderRevision=(o.renderRevision or 0)+1
        local list=transforms(o)
        local clear=o.data.cameras[1].clear
        local tint=o.data.colorTrack
        if tint then
            local k1,k2=unit((o.story-tint.time1+1)/300),unit((o.story-tint.time2+1)/300)
            clear=translated(translated(clear,tint.a1,k1-k2),tint.a2,k2)
        end
        SetViewMode('world')
        fill(unit(clear[1])*255,unit(clear[2])*255,unit(clear[3])*255,255)
        for _,cam in ipairs(o.data.cameras) do drawCamera(o,cam,list) end
        lstg.view3d=previous
        SetViewMode('world')
        if o.flash then
            local t=o.clock-o.flash
            local opacity=unit((t-90)/60)-unit((t-150)/60)
            if opacity>0 then fill(255,255,255,opacity*255) end
        end
    end,
    del=function(o)
        if RogueEncounter and RogueEncounter.stopping then return end
        for _,mesh in pairs(meshes or {}) do mesh.native=nil end
        o.gpuMeshes,o.quadMeshes,o.meshBatch=nil,nil,nil
        for key,pool in pairs(o.resources) do lstg.RemoveResource(pool,1,key) end
    end,
},true)
local function current()
    local o=lstg.tmpvar.bg
    if IsValid(o) and o.class==Scene then return o end
end
function B.prepare(chapter,variant)
    if not setting or not setting.displayBG then return end
    meshes=meshes or dofile(path..'meshes.lua')
    local data=sceneData(chapter..variant)
    local o={key=chapter..variant,resources={},sizes={}}
    for _,node in ipairs(data.nodes) do
        if node.sprite then texture(o,node.sprite.tex) end
        if node.particles then
            local tex=texture(o,node.particles.tex)
            if tex and Source.available() and Source.blend(node.particles.blend) then gpuQuad(o,tex) end
        end
        if node.mesh then
            local mesh=meshes[node.mesh.key]
            for j,part in ipairs(mesh.parts) do
                local mat=node.mesh.materials[j] or node.mesh.materials[#node.mesh.materials]
                local tex=texture(o,mat.tex)
                if Source.available() and Source.blend(mat.blend) then gpuMesh(o,mesh,part,tex)
                elseif tex and lstg.AndroidCreateModelMesh then nativeMesh(mesh,part,tex) end
                if RogueEncounter then RogueEncounter.checkpoint() end
            end
        end
        if RogueEncounter then RogueEncounter.checkpoint() end
    end
    ready=o
end
function B.clearPrepared() ready=nil end
function B.releaseMeshes()
    for _,mesh in pairs(meshes or {}) do mesh.native=nil end
end
function B.show(chapter,variant,start,sequence)
    if RogueEncounter and RogueEncounter.spellOnly(36) then return end
    if not setting or not setting.displayBG then return end
    local o=current()
    if not o or o.chapter~=chapter or o.variant~=variant then
        o=New(Scene,chapter,variant,start or 0)
    end
    o.sequence=sequence
    return o
end
function B.story(t)
    local o=current()
    if o then
        Presentation.title(o.chapter,t,t)
        o.story=t;stageChanges(o)
    end
end
function B.card(chapter,spell)
    if RogueEncounter and RogueEncounter.spellOnly(36) then return end
    local o=current()
    if not o or not o.sequence then
        local variant=spell and '_spell' or (chapter=='EXA' and '' or '_boss')
        o=B.show(chapter,variant,0,false)
    end
    if o then o.boss=true end
end
function B.endCard(thirdPart)
    local o=current()
    if o then
        o.boss=false
        if thirdPart and o.variant~='_spell' then o.partC=o.clock+400 end
    end
end
return B
