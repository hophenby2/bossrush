-- 原作ECL创建的独立ANM。径向粒子、带状网格和56/58/65的方形结界不能当普通精灵画。
local F={objects={},shakes={}}
local A=OriginalANM
-- 渲染桥接使用100像素世界单位/背景场景单位；ECL位置与速度参数保持原值。
local function camera()
    local view=lstg.view3d
    local eye,at,up=view.eye,view.at,view.up
    local x,y,z=(at[1]-eye[1])*100,(at[2]-eye[2])*100,(at[3]-eye[3])*100
    local length=math.sqrt(x*x+y*y+z*z)
    if length==0 then x,y,z,length=0,0,100,100 end
    local fx,fy,fz=x/length,y/length,z/length
    local rx,ry,rz=up[2]*fz-up[3]*fy,up[3]*fx-up[1]*fz,up[1]*fy-up[2]*fx
    local n=math.sqrt(rx*rx+ry*ry+rz*rz)
    if n==0 then rx,ry,rz,n=1,0,0,1 end
    rx,ry,rz=rx/n,ry/n,rz/n
    return {x=eye[1]*100,y=eye[2]*100,z=eye[3]*100,dx=x,dy=y,dz=z,
        fx=fx,fy=fy,fz=fz,rx=rx,ry=ry,rz=rz,
        ux=fy*rz-fz*ry,uy=fz*rx-fx*rz,uz=fx*ry-fy*rx,projection=224/math.tan(view.fovy/2)}
end
local scripts={[0]=28,29,30,31,36,37,38,39,40,41,42,43,44,45,45,45,0,32,33,51,
    56,52,54,104,104,35,53,34,57,58,59,60,48,49,50,88,88,92,71,76,81,82,83,83,
    83,83,84,72,85,86,80,73,77,88,88,87,96,55,100,78,102,103,75,74,77,98}
local function valid(o) return IsValid(o) and o.status~='del' and o.status~='kill' end
local function finished(vm)
    if not vm.finished then return false end
    for _,child in ipairs(vm.children) do if not finished(child) then return false end end
    return true
end
local function color(v,n)
    n=n%4294967296
    v.color={math.floor(n/65536)%256,math.floor(n/256)%256,n%256}
    v.alpha[1]=math.floor(n/16777216)%256
end
local function ring(o)
    local v=o.vm
    if not v.visible or not v.sprite then return end
    local s=A.sprite_resource(v)
    local g=o.geometry
    if not g then return end
    local count,wave=g.count,g.wave
    local radius,secondary=g.radius,g.secondary
    local half=g.width/math.sin((math.pi-2*math.pi/count)/2)
    local tw,th=GetTextureSize(s.tex)
    if lstg.SetTextureSamplerState then lstg.SetTextureSamplerState(s.tex,'linear+wrap') end
    local co=Color(v.alpha[1],v.color[1],v.color[2],v.color[3])
    local function points(i)
        local angle=g.angle+i*2*math.pi/count
        local r=radius
        if wave~=0 then r=r+math.cos(g.secondary_angle+i*2*math.pi*wave/count)*secondary end
        local x,y=math.cos(angle),-math.sin(angle)
        local function p(d,u)
            local px,py=x*(r+d),y*(r+d)
            if wave==0 and secondary~=0 then py=-math.sin(angle)*(secondary+d) end
            return {o.x+px,o.y+py,.5,u+v.u*tw,s[3]+s[5]*(1-i/count)+v.v*th,co}
        end
        return p(half,s[2]),p(-half,s[2]+s[4])
    end
    for i=0,count-1 do
        local a,b=points(i);local c,d=points(i+1)
        RenderTexture(s.tex,v.blend,a,c,d,b)
    end
end
F.effect=Class(object,{
    init=function(o,game,archive,script,x,y,phase,kind,argb,angle)
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY_BULLET_EF,false,false
        o.x,o.y,o.origin_x,o.origin_y=x,y,x,y
        o.game,o.phase,o.kind,o.age=game,phase,kind,0
        o.rate_source=phase and phase._native_rate_source
        o.vm=A.new(game,archive,script,o.rate_source and o.rate_source.fm)
        if argb then color(o.vm,argb) end
        if (game==7 or game==8) and kind and kind>=3 and kind<=11 then
            -- TH07/08的initCallback在SpawnEffect内执行；坐标换算只反转y分量。
            local scale=kind==3 and 4/33 or 1/12
            scale=scale*(o.rate_source and o.rate_source.fm or 1)
            o.effect_velocity={ran:Float(-128,128)*scale,-ran:Float(-128,128)*scale}
            local divisor=kind==3 and 20 or 19
            o.effect_acceleration={-o.effect_velocity[1]/divisor,-o.effect_velocity[2]/divisor}
        elseif game==8 and kind==17 then
            o.dir=ran:Float(-math.pi,math.pi)
            o.x,o.y=x+256*math.cos(o.dir),y-256*math.sin(o.dir)
        elseif game==8 and kind==26 then
            o.dir=(angle and angle>-990) and angle or ran:Float(-math.pi,math.pi)
            o.distance=128*ran:Float(1,2.5)
        elseif game==8 and (kind==60 or kind==61) then
            local a=angle or 0
            if a<=-999 then a=ran:Float(-math.pi,math.pi) end
            o.x,o.y=x+256*math.cos(a),y-256*math.sin(a)
            o.vm.rotation[3]=a+math.pi/2
        elseif game==8 and (kind==51 or kind==63) then
            local c=camera()
            o.point={c.x+c.dx/2+ran:Float(-60,60),
                c.y+c.dy/2+ran:Float(kind==51 and -100 or -200,kind==51 and 100 or 200)-(kind==51 and 50 or 200),
                c.z+c.dz/2+ran:Float(0,100)-100}
            o.velocity={ran:Float(-0.001,0.001),ran:Float(-0.03,0.03)+(kind==63 and 0.4 or 0),-ran:Float(0,0.1)-0.3}
            o.acceleration={ran:Float(-0.0001,0.0001),ran:Float(-0.0001,0.0001),-0.0003}
            -- Camera粒子只在初始化时乘fm；之后逐帧累加已缩放的速度/加速度。
            local rate=o.rate_source and o.rate_source.fm or 1
            for i=1,3 do o.velocity[i],o.acceleration[i]=o.velocity[i]*rate,o.acceleration[i]*rate end
            o.layer=LAYER.ENEMY-1
        end
        F.objects[#F.objects+1]=o
    end,
    frame=function(o)
        if (o.game==6 or o.game==7 or o.game==8) and o.kind and o.kind>=3 and o.kind<=11 then
            -- RandomSplash(Big) 首次 EffectManager 回调取两个随机速度，再逐帧减速。
            if not o.effect_velocity then
                local scale=o.kind==3 and 4/33 or 1/12
                o.effect_velocity={ran:Float(-128,128)*scale,-ran:Float(-128,128)*scale}
                local divisor=o.kind==3 and 20 or 19
                o.effect_acceleration={-o.effect_velocity[1]/divisor,-o.effect_velocity[2]/divisor}
            end
            local v,a=o.effect_velocity,o.effect_acceleration
            o.x,o.y=o.x+v[1],o.y+v[2]
            v[1],v[2]=v[1]+a[1],v[2]+a[2]
        elseif o.game==6 and o.kind==19 and o.effect_velocity then
            local v,a=o.effect_velocity,o.effect_acceleration
            o.x,o.y=o.x+v[1],o.y+v[2]
            v[1],v[2]=v[1]+a[1],v[2]+a[2]
        elseif o.game==6 and (o.kind==17 or o.kind==18) then
            -- TH06 Effect_Attract第一次回调才取随机角；不是SpawnParticles构造时取。
            if o.dir==nil then o.dir=ran:Float(-math.pi,math.pi) end
            local d=256-o.age*256/(o.kind==18 and 240 or 60)
            o.x,o.y=o.origin_x+d*math.cos(o.dir),o.origin_y-d*math.sin(o.dir)
        elseif o.game==8 and o.kind==17 then
            local d=256-o.age*256/60
            o.x,o.y=o.origin_x+d*math.cos(o.dir),o.origin_y-d*math.sin(o.dir)
        elseif o.game==8 and o.kind==26 then
            local d=o.distance*(1-(1-o.age/90)^2)
            o.x,o.y=o.origin_x+d*math.cos(o.dir),o.origin_y-d*math.sin(o.dir)
        end
        if o.point then
            for i=1,3 do o.velocity[i]=o.velocity[i]+o.acceleration[i];o.point[i]=o.point[i]+o.velocity[i] end
            local c=camera()
            local x,y,z=o.point[1]-c.x,o.point[2]-c.y,o.point[3]-c.z
            local length=math.sqrt(x*x+y*y+z*z)
            local depth=x*c.fx+y*c.fy+z*c.fz
            if length==0 or depth/length<0.94 then object.RawDel(o);return end
            o.x,o.y=c.projection*(x*c.rx+y*c.ry+z*c.rz)/depth,c.projection*(x*c.ux+y*c.uy+z*c.uz)/depth
            o.projected_scale=c.projection/depth
        end
        if o.follow then
            if not valid(o.follow) then object.RawDel(o);return end
            o.x,o.y=o.follow.x,o.follow.y
        end
        if o.pulse then
            o.pulse=o.pulse-1
            if o.pulse<=0 then object.RawDel(o);return end
            o.vm.scale[1],o.vm.scale[2]=2*o.pulse/o.duration,2*o.pulse/o.duration
        end
        if o.game==8 and (o.kind==40 or o.kind==56 or o.kind==58 or o.kind==65 or o.bomb_radial) then
            local v=o.vm
            o.geometry={count=math.max(3,math.floor(v.vars[10000] or 24)),wave=v.vars[10001] or 0,
                radius=v.position[1],secondary=v.position[2],width=v.scale[1],angle=v.rotation[3],secondary_angle=v.rotation[2]}
            if o.bomb_radial then
                local k,t=o.kind,o.age;local g=o.geometry
                if k==42 or k==43 or k==44 or k==45 then
                    local f=1-(1-t/40)^2
                    g.radius=256*f;g.count=k==42 and 64 or k==45 and 8 or 48
                    g.wave=k==42 and 5 or 0;g.width=t<40 and 8 or 8+(t-40)*(k==42 and 2 or 1.5)
                    g.secondary=k==42 and (t<40 and 0 or 64*f) or k==45 and 0 or 128*f
                    g.secondary_angle=k==43 and math.pi/4 or k==44 and -math.pi/4 or 0
                elseif k==48 then
                    local f=t<30 and 0 or ((t-30)/30)^4
                    g.radius,g.count,g.width,g.secondary,g.secondary_angle=192,48,3+80*f,.0001+192*f,math.pi/2
                elseif k==36 or k==37 then
                    g.count=k==36 and 44 or 54;g.wave,g.secondary=0,0
                    g.radius=t<40 and 192-384*(1-t/40)^2 or 192
                    g.width=t<40 and 88-t*2 or 8
                    g.angle=(o.initial_angle or math.pi/4)+(k==37 and t*math.pi/180 or 0)
                elseif k==53 then
                    g.count,g.wave,g.radius,g.width=32,4,192*(1-(1-math.min(30,t)/30)^2),64
                    g.secondary,g.secondary_angle=64,0
                    v.alpha[1]=math.max(0,255*(1-(t/30)^4))
                    v.color={255,math.max(0,255*(1-t/30)),math.max(0,255*(1-t/30))}
                    if t>=30 then object.RawDel(o);return end
                end
            end
        end
        local source=o.rate_source or valid(o.phase) and o.phase._native_rate_source
        local rate=source and source.fm or 1
        A.step(o.vm,rate)
        o.age=o.age+rate
        -- TH10击破ANM创建的碎片有独立寿命，主VM结束后仍要把子VM播完。
        if finished(o.vm) then object.RawDel(o) end
    end,
    render=function(o)
        if o.game==8 and (o.kind==40 or o.kind==56 or o.kind==58 or o.kind==65 or o.bomb_radial) then ring(o)
        elseif o.point then
            if not o.projected_scale then return end
            local v=o.vm
            A.draw(v,o.x,o.y,0,o.projected_scale,o.projected_scale,1,nil,
                {color={math.floor(v.color[1]*255/256),math.floor(v.color[2]*255/256),math.floor(v.color[3]*255/256)},alpha=math.floor(v.alpha[1]*255/256)})
        else A.draw(o.vm,o.x,o.y) end
    end,
},true)
-- TH08 ExIns1/10/17：ScreenEffect::CalcArcadePulse，保留时长、次数和原ARGB透明度。
-- 原calc优先级3在敌机11之前；出生帧尚未计算alpha，下一帧从255开始。
F.screen_pulse=Class(object,{
    init=function(o,phase,duration,repeats,alpha,color)
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.TOP-.5,false,false
        o.phase,o.age,o.alpha=phase,0,0
        o.pulse_color=color or {255,255,255}
        o.duration,o.repeats,o.maximum=duration or 60,repeats or 1,alpha or 255
        o.born=stage.current_stage.timer
        F.objects[#F.objects+1]=o
    end,
    frame=function(o)
        if stage.current_stage.timer==o.born then return end
        if o.age>=o.duration then
            o.alpha=0;o.repeats=o.repeats-1
            if o.repeats<=0 then object.RawDel(o);return end
            o.age=0
        else o.alpha=o.maximum-math.floor(o.age*o.maximum/o.duration) end
        o.age=o.age+1
    end,
    render=function(o)
        SetViewMode('world')
        SetImageState('white','',o.alpha,o.pulse_color[1],o.pulse_color[2],o.pulse_color[3])
        local w,p=lstg.world,lstg.worldoffset
        local hw,hh=(w.r-w.l)/p.hscale/2,(w.t-w.b)/p.vscale/2
        local x,y=p.centerx+p.dx/p.hscale,p.centery+p.dy/p.vscale
        RenderRect('white',x-hw,x+hw,y-hh,y+hh)
    end,
},true)
function F.shake_envelope(phase,amplitude,ramp,hold,down)
    F.shakes[#F.shakes+1]={phase=phase,born=stage.current_stage.timer,age=0,
        amplitude=amplitude or 4,ramp=ramp or 120,hold=hold or 190,down=down or 60}
end
local function release_shake()
    local p=lstg.worldoffset
    if F.shake_owned and p.dx==F.shake_x and p.dy==F.shake_y then p.dx,p.dy=0,0 end
    F.shake_owned=nil
end
function F.advance_shake()
    local scene,clock=stage.current_stage,stage.current_stage.timer
    if F.shake_scene==scene and F.shake_clock==clock then return end
    F.shake_scene,F.shake_clock=scene,clock
    local kept={}
    for _,s in ipairs(F.shakes) do
        local total=s.ramp+s.hold+s.down
        if valid(s.phase) and s.age<total-1 then
            kept[#kept+1]=s
            if clock~=s.born then
                s.age=s.age+1
                local envelope=s.age<s.ramp and s.age/s.ramp or s.age<s.ramp+s.hold and 1 or (total-s.age)/s.down
                local a=s.amplitude*envelope
                local x=ran:Int(0,2)
                local y=ran:Int(0,2)
                -- 原ANM屏幕偏移向右/下；本项目worldoffset是摄像机偏移。
                F.shake_x=-(x==1 and a or x==2 and -a or 0)
                F.shake_y=y==1 and a or y==2 and -a or 0
                lstg.worldoffset.dx,lstg.worldoffset.dy=F.shake_x,F.shake_y
                F.shake_owned=true
            end
        end
    end
    F.shakes=kept
    if #kept==0 then release_shake() end
end
function F.new(game,archive,script,x,y,phase,kind,argb,angle)
    local stage=stage and stage.current_stage
    local clock=stage and stage.timer
    if F.stage~=stage or F.clock~=clock then
        F.stage,F.clock=stage,clock
        local n=0
        for _,o in ipairs(F.objects) do if valid(o) then n=n+1;F.objects[n]=o end end
        for i=#F.objects,n+1,-1 do F.objects[i]=nil end
    end
    if game==6 or game==7 or game==8 then
        local n=0
        for _,o in ipairs(F.objects) do if valid(o) and o.game==game and not o.fixed_slot then n=n+1 end end
        if n>=(game==7 and 400 or 512) then return nil end -- 各作EffectManager的普通效果池。
    end
    return New(F.effect,game,archive,script,x,y,phase,kind,argb,angle)
end
function F.spawn8(owner,phase,id,count,argb,angle)
    local script=assert(scripts[id],'未登记的原作效果模板：'..tostring(id))
    for _=1,count do
        if not F.new(8,'etama',script,owner.x,owner.y,phase,id,argb,angle) then break end
    end
end
-- EclExIns 3/20/6 各占固定槽9、10：同一个径向网格回调，ANM决定四边形和展开半径。
-- 不能用普通精灵画script96..101：position.x是半径，scale.x是边框带宽。
function F.stop_warp(phase)
    local w=F.warp
    if not w or phase and w.phase~=phase then return end
    for _,o in ipairs(w.effects) do if valid(o) then object.RawDel(o) end end
    F.warp=nil
end
function F.start_warp(owner,phase,ex)
    F.stop_warp()
    local kind=ex==3 and 56 or ex==20 and 65 or 58
    local script=scripts[kind]
    -- 固定槽不受普通粒子池512项上限限制，不能因同屏粒子较多而漏掉结界。
    local outer=New(F.effect,8,'etama',script,owner.x,owner.y,phase,kind)
    local inner=New(F.effect,8,'etama',script+1,owner.x,owner.y,phase,kind)
    outer.fixed_slot,inner.fixed_slot=9,10
    F.warp={phase=phase,card=phase.current_card,effects={outer,inner},x=owner.x,y=owner.y}
end
function F.draw_warp_background(owner,vms)
    local w=F.warp
    if not w or w.phase~=owner or w.card~=owner.current_card then return end
    if not valid(w.effects[1]) or not valid(w.effects[2]) then return end
    -- DrawBulletWarpBarrier以黑色方环写深度，再只在环内重画反向背景。
    -- 用四个裁剪矩形等价表达深度遮罩，兼容Windows Sub和Android的二维渲染。
    local outer=w.effects[1].vm.position[1]*0.7071068286895752
    local inner=w.effects[2].vm.position[1]*0.7071068286895752
    if outer<=inner then return end
    local x,y=w.x,w.y
    local regions={{x-outer,x+outer,y+inner,y+outer},{x-outer,x+outer,y-outer,y-inner},
        {x-outer,x-inner,y-inner,y+inner},{x+inner,x+outer,y-inner,y+inner}}
    for _,clip in ipairs(regions) do
        SetImageState('white','',Color(255,0,0,0))
        RenderRect('white',clip[1],clip[2],clip[3],clip[4])
        for i,vm in ipairs(vms) do
            local view={};for k,n in pairs(vm) do view[k]=n end
            if i==1 then view.position={416,464,0};view.scale={-1.5,-1.75}
            else view.rotation={vm.rotation[1],vm.rotation[2],-vm.rotation[3]} end
            A.draw(view,-224,240,nil,nil,nil,nil,nil,{color={224,192,192},clip=clip})
        end
    end
end
function F.clear(phase)
    F.stop_warp(phase)
    for i=#F.shakes,1,-1 do if F.shakes[i].phase==phase then table.remove(F.shakes,i) end end
    if #F.shakes==0 then release_shake() end
    local n=0
    for _,o in ipairs(F.objects) do
        if valid(o) and o.phase==phase then object.RawDel(o)
        elseif valid(o) then n=n+1;F.objects[n]=o end
    end
    for i=#F.objects,n+1,-1 do F.objects[i]=nil end
end
return F
