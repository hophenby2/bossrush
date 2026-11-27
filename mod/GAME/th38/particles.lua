-- 发行包自机粒子：使用原纹理、发射率、寿命及颜色/尺寸曲线，不参与攻击随机数与判定。
local D=dofile('mod/GAME/th38/release_particles.lua')
local M={data=D}
local sin,cos,pi=math.sin,math.cos,math.pi
local serial,images=0,{}
local function curve(keys,t)
    keys=keys.m_Curve
    if #keys==0 then return 0 end
    if t<=keys[1].time then return keys[1].value end
    for i=2,#keys do
        local b,a=keys[i],keys[i-1]
        if t<=b.time then
            local dt=b.time-a.time;local u=(t-a.time)/dt
            if a.outSlope==math.huge then return a.value end
            return (2*u^3-3*u^2+1)*a.value+(u^3-2*u^2+u)*dt*a.outSlope
                +(-2*u^3+3*u^2)*b.value+(u^3-u^2)*dt*b.inSlope
        end
    end
    return keys[#keys].value
end
local function value(c,t,r)
    if type(c)=='number' then return c end
    if c.constant~=nil then return c.constant end
    local mode=c.minMaxState
    if mode==0 then return c.scalar end
    if mode==1 then return curve(c.maxCurve,t)*c.scalar end
    if mode==2 then return (curve(c.minCurve,t)*(1-r)+curve(c.maxCurve,t)*r)*c.scalar end
    return c.minScalar+(c.scalar-c.minScalar)*r
end
local function gradient(g,t)
    local result={}
    local function channel(name,prefix,count)
        local previous=0
        for i=1,count-1 do
            local nextTime=g[prefix..i]/65535
            if t<=nextTime then
                local start=g[prefix..previous]/65535
                local k=g.m_Mode==1 and 0 or math.max(0,math.min(1,(t-start)/math.max(1e-9,nextTime-start)))
                return g['key'..previous][name]*(1-k)+g['key'..i][name]*k
            end
            previous=i
        end
        return g['key'..previous][name]
    end
    for i,name in ipairs({'r','g','b','a'}) do
        result[i]=channel(name,i==4 and 'atime' or 'ctime',i==4 and g.m_NumAlphaKeys or g.m_NumColorKeys)
    end
    return result
end
local function color(c,t,r)
    local mode=c.minMaxState
    if mode==1 then return gradient(c.maxGradient,t) end
    if mode==3 then
        local a,b=gradient(c.minGradient,t),gradient(c.maxGradient,t)
        for i=1,4 do a[i]=a[i]+(b[i]-a[i])*r end
        return a
    end
    if mode==4 then return gradient(c.maxGradient,r) end
    local out={}
    for i,k in ipairs({'r','g','b','a'}) do
        out[i]=mode==2 and c.minColor[k]+(c.maxColor[k]-c.minColor[k])*r or c.maxColor[k]
    end
    return out
end
local function rotate(x,y,a) return x*cos(a)-y*sin(a),x*sin(a)+y*cos(a) end
local function image(key,textures)
    local d=(textures or D.textures)[key]
    if images[d.file] then return images[d.file] end
    local id=(textures and 'asl_effect_particle_' or 'asl_particle_')..key
    local previous=GetResourceStatus();SetResourceStatus('global')
    LoadTexture(id,d.file);LoadImage(id,id,0,0,unpack(d.size));SetResourceStatus(previous)
    images[d.file]=id;return id
end
function M.new(cfg,transform,textures)
    serial=serial+1
    local initial,shape,emission=cfg.InitialModule,cfg.ShapeModule,cfg.EmissionModule
    local ps={isPlaying=false,time=0,particles={},shape={radius=shape.radius.value},material={},
        emission={enabled=true,rateOverTime={constant=emission.rateOverTime.scalar}},startColor=nil}
    local seed=serial*7919+97
    local function random() seed=seed*48271%2147483647;return seed/2147483647 end
    local accumulator,delay=0,value(cfg.startDelay,0,random())
    local function spawn(t)
        if #ps.particles>=initial.maxNumParticles then return end
        -- 原 prefab 的 Mesh 形状没有指定网格，Unity 不会从空网格生成粒子。
        if shape.type==6 then return end
        local q,s=transform.position,transform.lossyScale
        local angle=shape.arc.mode==1 and (ps.time-delay)*value(shape.arc.speed,t,0)*2*pi or random()*shape.arc.value*pi/180
        local radius=ps.shape.radius*math.sqrt((1-shape.radiusThickness)^2+random()*(1-(1-shape.radiusThickness)^2))
        local x,y=radius*cos(angle),radius*sin(angle)
        local vx,vy=cos(angle),sin(angle)
        if shape.type==12 then x,y=(random()*2-1)*ps.shape.radius,0;vx,vy=0,0 end
        x,y=x*shape.m_Scale.x+shape.m_Position.x,y*shape.m_Scale.y+shape.m_Position.y
        local localSpace=cfg.moveWithTransform==1
        local a=transform.eulerAngles.z*pi/180
        local scale=cfg.scalingMode==2 and 1 or s.x
        if not localSpace then x,y=rotate(x*s.x,y*s.y,a);x,y=x+q.x,y+q.y;vx,vy=rotate(vx,vy,a) end
        local r=random();local speed=value(initial.startSpeed,t,random())*(localSpace and 1 or scale)
        local p={x=x,y=y,vx=vx*speed,vy=vy*speed,age=0,life=value(initial.startLifetime,t,random()),r=r,
            sx=value(initial.startSize,t,random()),sy=0,rotation=value(initial.startRotation,t,random()),
            color=ps.startColor and {ps.startColor.r,ps.startColor.g,ps.startColor.b,ps.startColor.a} or color(initial.startColor,t,random())}
        p.sy=initial.size3D and value(initial.startSizeY,t,random()) or p.sx
        p.rx=initial.rotation3D and value(initial.startRotationX,t,random()) or 0
        p.ry=initial.rotation3D and value(initial.startRotationY,t,random()) or 0
        p.gravity=value(initial.gravityModifier,t,random())*-9.81
        ps.particles[#ps.particles+1]=p
    end
    function ps:Play()
        if not self.isPlaying then self.time=0;accumulator=0 end
        self.isPlaying=true
    end
    function ps:Stop() self.isPlaying=false end
    function ps:Clear() self.particles={} end
    function ps:FixedUpdate()
        local dt=cfg.simulationSpeed/120
        for i=#self.particles,1,-1 do
            local p=self.particles[i];p.age=p.age+dt
            if p.age>=p.life then table.remove(self.particles,i)
            else
                local t=p.age/p.life
                local speed=cfg.VelocityModule and value(cfg.VelocityModule.speedModifier,t,p.r) or 1
                p.x,p.y=p.x+p.vx*speed*dt,p.y+p.vy*speed*dt;p.vy=p.vy+p.gravity*dt
                if cfg.RotationModule then
                    local m=cfg.RotationModule
                    p.rotation=p.rotation+value(m.curve,t,p.r)*dt
                    if m.separateAxes then
                        p.rx=p.rx+value(m.x,t,p.r)*dt;p.ry=p.ry+value(m.y,t,p.r)*dt
                    end
                end
                if cfg.RotationBySpeedModule then
                    local m=cfg.RotationBySpeedModule;local speed=math.sqrt(p.vx^2+p.vy^2)
                    local k=math.max(0,math.min(1,(speed-m.range.x)/(m.range.y-m.range.x)))
                    p.rotation=p.rotation+value(m.curve,k,p.r)*dt
                end
            end
        end
        if not self.isPlaying then return end
        self.time=self.time+dt
        if self.time<delay then return end
        local t=self.time-delay
        if t>=cfg.lengthInSec then
            if cfg.looping then t=t%cfg.lengthInSec else self.isPlaying=false;return end
        end
        if self.emission.enabled then
            accumulator=accumulator+value(self.emission.rateOverTime,t/cfg.lengthInSec,random())*dt
            while accumulator>=1 do accumulator=accumulator-1;spawn(t/cfg.lengthInSec) end
        end
    end
    function ps:Render()
        local r=cfg.renderer;local id=image(r.texture,textures)
        local q,s=transform.position,transform.lossyScale;local a=transform.eulerAngles.z*pi/180
        local soft=r.shader=='Legacy Shaders/Particles/Additive (Soft)'
        -- Soft Additive 着色器没有 Tint 属性，使用 One / OneMinusSrcColor 混合。
        local tintKey=r.shader=='Sprites/Default' and '_Color' or not soft and '_TintColor'
        local tint=tintKey and assert(r.colors[tintKey]) or {1,1,1,1}
        local override=tintKey and self.material[tintKey]
        if override then tint={override.r,override.g,override.b,override.a} end
        local gain=r.shader=='Legacy Shaders/Particles/Additive' and 2 or 1
        local blend=r.shader=='Sprites/Default' and '' or soft and 'mul+screen' or 'mul+add'
        for _,p in ipairs(self.particles) do
            local t=p.age/p.life;local x,y=p.x,p.y
            if cfg.moveWithTransform==1 then x,y=rotate(x*s.x,y*s.y,a);x,y=x+q.x,y+q.y end
            local sx,sy=p.sx,p.sy
            if cfg.SizeModule then
                sx=sx*value(cfg.SizeModule.curve,t,p.r)
                sy=sy*value(cfg.SizeModule.separateAxes and cfg.SizeModule.y or cfg.SizeModule.curve,t,p.r)
            end
            if cfg.scalingMode~=2 then sx,sy=sx*s.x,sy*s.y end
            local c={unpack(p.color)}
            if cfg.ColorModule then local v=color(cfg.ColorModule.gradient,t,p.r);for i=1,4 do c[i]=c[i]*v[i] end end
            for i=1,4 do c[i]=math.max(0,math.min(1,c[i]*tint[i]*gain))*255 end
            SetImageState(id,blend,c[4],c[1],c[2],c[3])
            local function vertex(vx,vy)
                vx,vy=rotate(vx*sx/2,vy*sy/2,p.rotation)
                local z=vy*sin(p.rx);vy=vy*cos(p.rx);vx=vx*cos(p.ry)+z*sin(p.ry)
                return (x+vx-4.5)*48,(y+vy+4.8)*48,.5
            end
            local v1,v2,v3=vertex(-1,1);local v4,v5,v6=vertex(1,1)
            local v7,v8,v9=vertex(1,-1);local v10,v11,v12=vertex(-1,-1)
            Render4V(id,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12)
        end
    end
    function ps:Dispose() self:Stop();self:Clear() end
    return ps
end
return M
