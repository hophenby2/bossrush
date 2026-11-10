-- STD直接使用原作模型/实例、镜头、雾和ANM。只在顺序模式创建，不依赖全局背景开关。
-- 两代STD的跳转单位、插值指令和暂停不同，不能把风神录编号套给红妖永。
local B={}
local A=OriginalANM
local function copy(v) local r={};for i,n in ipairs(v) do r[i]=n end;return r end
local function vec(a,b,c) return {a,b,c} end
local function color(n) return {math.floor(n/65536)%256,math.floor(n/256)%256,n%256,math.floor(n/16777216)%256} end
local function lerp(a,b,t) local out={};for i,n in ipairs(a) do out[i]=n+(b[i]-n)*t end;return out end
local function ease(t,m)
    if m>=1 and m<=3 then return 1-(1-t)^(m+1)
    elseif m>=4 and m<=6 then return t^(m-2) end
    return t
end
local function begin(s,key,duration,mode,from,to,t0,t1)
    s.interps[key]={time=0,duration=math.max(1,duration),mode=mode or 0,from=copy(from),to=copy(to),t0=t0,t1=t1}
end
local function newVm(s,id)
    local archive=s.data.archive
    if s.data.game==7 and archive=='stg4bg' and id>=16 then
        archive=archive..(math.floor(id/16)+1);id=id%16
    end
    if s.data.game==6 or s.data.game==7 then id=A.load(s.data.game,archive).ids[id] or id end
    return A.new(s.data.game,archive,id,nil,nil,s.random)
end
local function overlay(s,index,id)
    s.overlays[index]=id>=0 and newVm(s,id) or nil
end
local function old(s,c)
    local op,a,b,d=c[2],c[3],c[4],c[5]
    if op==0 then
        s.offset=vec(a,b,d)
        local following
        for i=s.pc+1,#s.data.commands do if s.data.commands[i][2]==0 then following=s.data.commands[i];break end end
        if following and following[1]>c[1] then
            s.offsetKey={time=c[1],last=following[1],from=copy(s.offset),to=vec(following[3],following[4],following[5])}
        else s.offsetKey=nil end
    elseif op==1 then
        local fog=color(a);fog[5],fog[6]=b,d
        s.fogTarget=fog;s.fog=fog
        if s.interps.fog then s.interps.fog.to=copy(fog) end
    elseif s.data.game==6 then
        if op==2 then s.starts.direction=copy(s.targets.direction);s.targets.direction=vec(a,b,d)
            if not s.interps.direction then s.direction=copy(s.targets.direction)
            else s.interps.direction.from=copy(s.starts.direction);s.interps.direction.to=copy(s.targets.direction) end
        elseif op==3 then begin(s,'direction',a,0,s.starts.direction,s.targets.direction)
        elseif op==4 then begin(s,'fog',a,0,s.fog,s.fogTarget)
        elseif op==5 then
            if s.unpause then s.unpause=nil else return false end
        end
    elseif op==2 then begin(s,'fog',a,0,s.fog,s.fogTarget)
    elseif op==3 then return false
    elseif op==4 then s.pc,s.time=a,b;s.interps.position=nil;return 'jump'
    elseif op==5 or op==7 or op==9 or op==11 then
        local key=({[5]='position',[7]='direction',[9]='up',[11]='fov'})[op]
        local target=op==11 and {a} or vec(a,b,d)
        s.starts[key]=copy(s.targets[key]);s.targets[key]=target
        if not s.interps[key] then s[key]=copy(target)
        else
            -- 旧STD先写插值时长、再写目标；求值时读取刚更新的起终点。
            s.interps[key].from=copy(s.starts[key]);s.interps[key].to=copy(target)
        end
    elseif op==6 or op==8 or op==10 or op==12 then
        local key=({[6]='position',[8]='direction',[10]='up',[12]='fov'})[op]
        begin(s,key,a,b,s.starts[key],s.targets[key])
    elseif op==13 then s.clear=color(a)
    elseif op>=14 and op<=28 then
        local key=op<=18 and 'position' or op<=23 and 'direction' or 'up'
        local part=(op-14)%5
        if part==0 then s.starts[key]=vec(a,b,d)
        elseif part==1 then s.targets[key]=vec(a,b,d)
        elseif part==2 then s.tangent0[key]=vec(a,b,d)
        elseif part==3 then s.tangent1[key]=vec(a,b,d)
        else begin(s,key,a,7,s.starts[key],s.targets[key],s.tangent0[key],s.tangent1[key]) end
    elseif op==29 or op==30 or op==34 then overlay(s,op==29 and 1 or op==30 and 2 or 3,a)
    elseif op==31 then -- ECL信号标签，由signal()从原作控制点续行。
    elseif op==32 then s.eyeOffset=vec(a,b,d)
    elseif op==33 then s.motion,s.motionTime=a,0
    else error('未实现的旧STD指令：'..op) end
    return true
end
local function modern(s,c)
    local op,a,b,d,e,f=c[2],c[3],c[4],c[5],c[6],c[7]
    if op==0 then return false
    elseif op==1 then s.pc,s.time=a,b;return 'jump'
    elseif op==2 or op==4 or op==6 then s[({[2]='position',[4]='direction',[6]='up'})[op]]=vec(a,b,d)
    elseif op==3 or op==5 then
        local key=op==3 and 'position' or 'direction';begin(s,key,a,b,s[key],vec(d,e,f))
    elseif op==7 then s.fov={a}
    elseif op==8 then s.fog=color(a);s.fog[5],s.fog[6]=b,d
    elseif op==9 then
        local fog=color(d);fog[5],fog[6]=e,f;begin(s,'fog',a,b,s.fog,fog)
    elseif op==10 or op==11 then
        local key=op==10 and 'position' or 'direction'
        begin(s,key,a,8,s[key],vec(c[8],c[9],c[10]),vec(d,e,f),vec(c[11],c[12],c[13]))
    elseif op==12 then s.motion,s.motionTime=a,0
    elseif op==13 then s.clear=color(a)
    elseif op==14 then overlay(s,a+1,b)
    else error('未实现的新STD指令：'..op) end
    return true
end
local function step(s)
    local halted=false
    for budget=1,8192 do
        local c=s.data.commands[s.pc]
        if not c or c[1]<0 or c[1]>s.time then break end
        local result=(s.modern and modern or old)(s,c)
        if result==false then halted=true;break end
        if result~='jump' then s.pc=s.pc+1 end
        assert(budget<8192,'原作STD同帧跳转没有收敛')
    end
    for key,p in pairs(s.interps) do
        p.time=math.min(p.time+1,p.duration)
        local t=p.time/p.duration
        if p.t0 then
            local t2,t3=t*t,t*t*t;local out={}
            for i,n in ipairs(p.from) do out[i]=(2*t3-3*t2+1)*n+(t3-2*t2+t)*p.t0[i]+(-2*t3+3*t2)*p.to[i]+(t3-t2)*p.t1[i] end
            s[key]=out
        else
            -- 旧STD的1..6顺序与新ANM/STD相反；新式使用ANM的插值定义。
            local mode=p.mode
            if s.modern and mode>=1 and mode<=6 then mode=mode<=3 and mode+3 or mode-3 end
            s[key]=lerp(p.from,p.to,ease(t,mode))
        end
        if p.time>=p.duration then s.interps[key]=nil end
    end
    if s.offsetKey then
        local k=s.offsetKey;s.offset=lerp(k.from,k.to,math.max(0,math.min(1,(s.time-k.time)/(k.last-k.time))))
    end
    if s.motion~=0 then
        local angle=s.motionTime*math.pi*2/(s.motion==3 and 4800 or s.data.game==10 and 512 or 480)-math.pi
        if s.data.game==10 then s.eyeOffset[1]=math.sin(angle)*-100
        elseif s.motion==1 then s.eyeOffset[1]=math.sin(angle)*40
        elseif s.motion==2 then s.eyeOffset[1]=math.sin(angle)*70;s.up[1]=-math.sin(angle)*.1
        elseif s.motion==3 then s.up[1],s.up[3]=math.sin(angle),math.cos(angle) end
        s.motionTime=s.motionTime+1
    end
    for _,row in ipairs(s.models) do for _,v in ipairs(row.vms) do A.step(v) end end
    for _,v in pairs(s.overlays) do A.step(v) end
    if not halted then s.time=s.time+1 end
end
function B.signal(s,label)
    if not s then return end
    if s.data.game==6 then s.unpause=true;return end
    for i,c in ipairs(s.data.commands) do
        if c[2]==31 and c[3]==label then s.pc,s.time=i+1,c[1];return true end
    end
end
local function normalize(v)
    local n=math.sqrt(v[1]^2+v[2]^2+v[3]^2);return {v[1]/n,v[2]/n,v[3]/n}
end
local function cross(a,b) return {a[2]*b[3]-a[3]*b[2],a[3]*b[1]-a[1]*b[3],a[1]*b[2]-a[2]*b[1]} end
local function drawQuad(s,q,v,instance,right,up)
    if not v.visible or not v.sprite then return end
    local sprite=A.sprite_resource(v)
    if q.script then
        -- 永夜抄竹林的type1是两端点之间的朝相机带状面，不能当作普通平面丢掉第二端点。
        local a,b=q.start,q['end'];local width=q.width~=0 and q.width or sprite[4]
        local dx,dy,dz=b[1]-a[1],b[2]-a[2],b[3]-a[3]
        local horizontal=dx*right[1]+dy*right[2]+dz*right[3]
        local vertical=dx*up[1]+dy*up[2]+dz*up[3]
        local length=math.sqrt(horizontal^2+vertical^2)
        if length<1e-6 then return end
        local ox,oy,oz=(right[1]*vertical-up[1]*horizontal)*width/length/2,
            (right[2]*vertical-up[2]*horizontal)*width/length/2,(right[3]*vertical-up[3]*horizontal)*width/length/2
        local c=v.color;local co=Color(v.alpha[1],c[1],c[2],c[3])
        local function point(p,k,u,w) return {p[1]+instance[2]-s.offset[1]+ox*k,p[2]+instance[3]-s.offset[2]+oy*k,
            p[3]+instance[4]-s.offset[3]+oz*k,u,w,co} end
        RenderTexture(sprite.tex,v.blend,point(a,-1,sprite[2],sprite[3]),point(a,1,sprite[2]+sprite[4],sprite[3]),
            point(b,1,sprite[2]+sprite[4],sprite[3]+sprite[5]),point(b,-1,sprite[2],sprite[3]+sprite[5]))
        return
    end
    local width=q[5]~=0 and q[5] or sprite[4]*v.scale[1]
    local height=q[6]~=0 and q[6] or sprite[5]*v.scale[2]
    local x,y,z=q[2]+instance[2]-s.offset[1],q[3]+instance[3]-s.offset[2],q[4]+instance[4]-s.offset[3]
    if s.data.game==6 then y=-y end
    if v.anchor==1 or v.anchor_x==1 then x=x+math.abs(width)/2
    elseif v.anchor_x==2 then x=x-math.abs(width)/2 end
    local ysign=s.data.game==6 and -1 or 1
    if v.anchor==1 or v.anchor_y==1 then y=y+math.abs(height)/2*ysign
    elseif v.anchor_y==2 then y=y-math.abs(height)/2*ysign end
    local ax,ay,az=v.rotation[1],v.rotation[2],v.rotation[3]
    local cx,sx,cy,sy,cz,sz=math.cos(ax),math.sin(ax),math.cos(ay),math.sin(ay),math.cos(az),math.sin(az)
    local c=v.secondary and v.color2 or v.color
    local co=Color(v.secondary and v.alpha2[1] or v.alpha[1],c[1],c[2],c[3])
    local tw,th=GetTextureSize(sprite.tex)
    if lstg.SetTextureSamplerState then lstg.SetTextureSamplerState(sprite.tex,'linear+wrap') end
    local u,w=sprite[2]+v.u*tw,sprite[3]+v.v*th
    local function point(dx,dy,tx,ty)
        local dz=0
        if v.position_mode==2 then
            dx,dy=dx*cz-dy*sz,dx*sz+dy*cz
            return {x+right[1]*dx+up[1]*dy,y+right[2]*dx+up[2]*dy,z+right[3]*dx+up[3]*dy,tx,ty,co}
        end
        -- 与D3DX行向量矩阵相同：先绕X，再Y，最后Z；红魔乡的Y尺度为负。
        if s.data.game==6 then dy=-dy end
        dy,dz=dy*cx-dz*sx,dy*sx+dz*cx
        dx,dz=dx*cy+dz*sy,-dx*sy+dz*cy
        dx,dy=dx*cz-dy*sz,dx*sz+dy*cz
        return {x+dx,y+dy,z+dz,tx,ty,co}
    end
    RenderTexture(sprite.tex,v.blend,point(-width/2,-height/2,u,w),point(width/2,-height/2,u+sprite[4],w),
        point(width/2,height/2,u+sprite[4],w+sprite[5]),point(-width/2,height/2,u,w+sprite[5]))
end
local function render(s)
    SetViewMode('world')
    local c=s.clear or s.fog
    SetImageState('white','',Color(255,c[1],c[2],c[3]));RenderRect('white',lstg.world.l,lstg.world.r,lstg.world.b,lstg.world.t)
    for _,v in pairs(s.overlays) do
        if not s.modern or (v.drawmode or 0)<4 then A.draw(v,-192,224) end
    end
    local eye,dir=copy(s.position),s.direction
    if s.data.game==6 then
        local distance=224/math.tan(math.pi/12)
        eye={192,-224,-distance*dir[3]};dir={dir[1],dir[2],distance*dir[3]}
    end
    local at={eye[1]+dir[1],eye[2]+dir[2],eye[3]+dir[3]}
    for i=1,3 do eye[i]=eye[i]+s.eyeOffset[i] end
    Set3D('eye',unpack(eye));Set3D('at',unpack(at));Set3D('up',unpack(s.up));Set3D('fovy',s.fov[1])
    Set3D('z',s.data.game==6 and 100 or 30,s.data.game==6 and 10000 or 1800)
    Set3D('fog',s.fog[5],s.fog[6],Color(255,s.fog[1],s.fog[2],s.fog[3]))
    SetViewMode('3d');ClearZBuffer();SetZBufferEnable(1)
    local forward=normalize(dir);local right=normalize(cross(s.up,forward));local up=cross(forward,right)
    for _,instance in ipairs(s.instances) do
        local model=s.models[instance[1]];local bound=model.source.bounds
        local dy=bound[2]+instance[3]-s.offset[2]
        if s.data.game==6 then dy=-dy end
        local dx,dz=bound[1]+instance[2]-s.offset[1]-eye[1],bound[3]+instance[4]-s.offset[3]-eye[3];dy=dy-eye[2]
        local depth=dx*forward[1]+dy*forward[2]+dz*forward[3]
        local radius=model.radius
        if depth+radius>0 and (s.data.game==6 or depth-radius<1800) then
            for i,q in ipairs(model.source.quads) do drawQuad(s,q,model.vms[i],instance,right,up) end
        end
    end
    SetZBufferEnable(0);SetViewMode('world')
end
B.class=Class(background)
function B.class:init(game,key)
    background.init(self,false)
    self.data=dofile('mod/GAME/original/std/'..game..'_'..key..'.lua')
    self.modern=game==95 or game==10
    -- 背景随机只影响装饰，不额外消耗已有弹幕ECL的随机流；录像由初始种子重建。
    self.random={seed=((lstg.var.ran_seed or 1)+game*7919)%2147483646+1}
    function self.random:Float(a,b) self.seed=self.seed*16807%2147483647;return a+(b-a)*self.seed/2147483647 end
    function self.random:Int(a,b) return math.min(b,math.floor(self:Float(a,b+1))) end
    self.time,self.pc,self.models,self.instances,self.interps,self.overlays=0,1,{},copy(self.data.instances),{},{}
    self.position,self.direction,self.up,self.fov={0,0,1000},{0,300,600},{0,1,0},{math.pi/6}
    self.offset,self.eyeOffset,self.fog,self.fogTarget={0,0,0},{0,0,0},{0,0,0,255,1000,2000},{0,0,0,255,1000,2000}
    self.starts,self.targets,self.tangent0,self.tangent1={},{},{},{}
    self.motion,self.motionTime=0,0
    for _,name in ipairs({'position','direction','up','fov'}) do self.starts[name]=copy(self[name]);self.targets[name]=copy(self[name]) end
    for _,model in ipairs(self.data.objects) do
        local row={source=model,vms={},radius=math.sqrt(model.bounds[4]^2+model.bounds[5]^2+model.bounds[6]^2)/2}
        for _,q in ipairs(model.quads) do row.vms[#row.vms+1]=newVm(self,q.script or q[1]) end
        self.models[#self.models+1]=row
    end
    for i,instance in ipairs(self.instances) do instance.source_order=i end
    table.sort(self.instances,function(a,b)
        local x,y=self.models[a[1]].source.layer,self.models[b[1]].source.layer
        return x==y and a.source_order<b.source_order or x<y
    end)
    step(self)
end
function B.class:frame() step(self) end
function B.class:render() if not self.hide then render(self) end end
B.step=step
B.render=render
return B
