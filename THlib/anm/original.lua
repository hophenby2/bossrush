-- 原作 ANM 播放器：保留源精灵矩形和时间轴，坐标到绘制时才从向下的 Y 轴转换。
-- 指令编号来自各作 AnmManager；不能把永夜抄的旧编号当作文花帖的新编号。
OriginalANM = {}
local A = OriginalANM
local rad, floor, min, max = math.pi/180, math.floor, math.min, math.max
local cache = {}
local resource_scope,resource_epoch=nil,0
local resource_timer=-1
local op6 = { [0]='delete','sprite','scale','alpha','packed_color','jump','nop','flipx','flipy',
    'rotation','omega','growth','fade','additive','normal','static','sprite_random','position',
    'position_linear','position_decel','position_decel4','stop','interrupt','anchor','stop_hide',
    'position_mode','follow','add_u','add_v','visible','scale_linear','zwrite' }
local op8 = { [0]='nop','delete','static','sprite','jump','jump_dec','position','scale','alpha','color',
    'flipx','flipy','rotation','omega','growth','fade','additive_value','position_linear','position_decel',
    'position_decel4','stop','interrupt','anchor','stop_hide','position_mode','follow','add_u','add_v',
    'visible','scale_linear','zwrite','camera','position_time','color_time','alpha_time','rotation_time',
    'scale_time','iset','fset','iadd','fadd','isub','fsub','imul','fmul','idiv','fdiv','imod','fmod',
    'iset_add','fset_add','iset_sub','fset_sub','iset_mul','fset_mul','iset_div','fset_div','iset_mod',
    'fset_mod','irandom','frandom','sin','cos','tan','acos','atan','normalize','ijeq','fjeq','ijne','fjne',
    'ijlt','fjlt','ijle','fjle','ijgt','fjgt','ijge','fjge','wait','u_speed','v_speed','blend',
    'drawmode','color2','alpha2','color2_time','alpha2_time','secondary','return' }
local op95 = { [0]='nop','delete','static','sprite','jump','jump_dec','iset','fset','iadd','fadd',
    'isub','fsub','imul','fmul','idiv','fdiv','imod','fmod','iset_add','fset_add','iset_sub','fset_sub',
    'iset_mul','fset_mul','iset_div','fset_div','iset_mod','fset_mod','ijeq','fjeq','ijne','fjne','ijlt',
    'fjlt','ijle','fjle','ijgt','fjgt','ijge','fjge','irandom','frandom','sin','cos','tan','acos','atan',
    'normalize','position','rotation','scale','alpha','color','omega','growth','fade','position_time',
    'color_time','alpha_time','rotation_time','scale_time','flipx','flipy','stop','interrupt','anchor_state',
    'blend','drawmode','render_byte','stop_hide','u_speed','v_speed','visible','zwrite','flag13','wait',
    'color2','alpha2','color2_time','alpha2_time','secondary','return','flag27','commit_position',
    'vertices','flag28','unit_speed','alternate_rng' }
op95[88],op95[89],op95[90],op95[91],op95[92]='child','point_filter','child','child','child'
local op11={}
for id,name in pairs(op95) do op11[id]=name end
op11[95],op11[100],op11[101],op11[102]='child','position_bezier','ring_vertices','sprite_random'
function A.load(game, archive)
    local key=game..'/'..archive
    if cache[key] then return cache[key] end
    local data=assert(dofile('mod/GAME/original/'..key..'.lua'))
    data.key=key
    for id,s in pairs(data.sprites) do
        local tex='original/'..key..'/'..s[1]
        s.img='original/'..key..'/sprite'..id
        s.tex=tex
        s.path='Resources/Original/'..game..'/'..archive..'_'..s[1]..'.png'
    end
    local ops=game==6 and op6 or ((game==7 or game==8) and op8 or game==11 and op11 or op95)
    for _,script in pairs(data.scripts) do
        script.interrupts={}
        for i,c in ipairs(script) do
            c.op=c[2]==-1 and 'delete' or assert(ops[c[2]],'未支持的原作ANM指令 '..key..':'..c[2])
            if game==7 and c[2]==9 then c.op='packed_color' end
            if game==7 and c[2]==33 then c.op='packed_color_time' end
            if c.op=='interrupt' then script.interrupts[c[3]]=i+1 end
        end
    end
    cache[key]=data
    return data
end
local function vector(...) return {...} end
local function interp(v,key,duration,mode,target)
    if duration<=0 then v.interps[key]=nil;return end
    local source=v[key]
    local from={}
    for i,n in ipairs(source) do from[i]=n end
    v.interps[key]={time=0,duration=duration,mode=mode,from=from,target=target}
end
local function value(v,a)
    if type(a)~='table' then return a end
    local id=a.var
    if v.data.game==11 then
        if id==10010 then return ran:Float(-math.pi,math.pi) end
        if id==10011 then return ran:Float(0,1) end
        if id==10012 then return ran:Float(-1,1) end
        if id==10022 then return ran:Int(0,2147483647) end
    end
    if id==10010 then return ran:Float(0,1) end
    if id==10011 then return ran:Float(-1,1) end
    if id==10012 then return ran:Float(-math.pi,math.pi) end
    if id>=10013 and id<=10015 then return v.position[id-10012] end
    return v.vars[id] or 0
end
local function put(v,a,n)
    assert(type(a)=='table' and a.var,'ANM变量目标缺失')
    v.vars[a.var]=n
end
local function jump(v,pc,time)
    v.pc=pc;v.time=time or v.script[pc][1]
end
function A.interrupt(v,id)
    local pc=v.script.interrupts[id] or v.script.interrupts[-1]
    if not pc then return false end
    v.return_pc,v.return_time=v.pc,v.time
    jump(v,pc)
    v.stopped=false;v.visible=true;v.finished=false
    return true
end
local function execute(v)
    local script=v.script
    for budget=1,8192 do
        local c=script[v.pc]
        if not c or c[1]>floor(v.time) then return end
        local op=c.op
        local a,b,d,e,f=value(v,c[3]),value(v,c[4]),value(v,c[5]),value(v,c[6]),value(v,c[7])
        v.pc=v.pc+1
        if op=='delete' then v.visible=false;v.finished=true;return
        elseif op=='static' then v.finished=true;return
        elseif op=='sprite' then v.sprite=v.sprite_resolver and v.sprite_resolver(a) or a+v.sprite_base;v.visible=true
        elseif op=='sprite_random' then v.sprite=a+ran:Int(0,b-1);v.visible=true
        elseif op=='jump' then jump(v,a,b)
        elseif op=='jump_dec' then
            put(v,c[3],a-1);if a>1 then jump(v,b,d) end
        elseif op=='stop' or op=='stop_hide' then
            v.pc=v.pc-1;v.stopped=true
            if op=='stop_hide' then v.visible=false end
            return
        elseif op=='return' then jump(v,v.return_pc,v.return_time)
        elseif op=='visible' then v.visible=a~=0
        elseif op=='position' then v.position=vector(a,b,d)
        elseif op=='rotation' then v.rotation=vector(a,b,d)
        elseif op=='omega' then v.omega=vector(a,b,d)
        elseif op=='growth' then v.growth=vector(a,b)
        elseif op=='scale' then v.scale=vector(a,b)
        elseif op=='alpha' then v.alpha=vector(a%256)
        elseif op=='color' then v.color=vector(a%256,b%256,d%256)
        elseif op=='packed_color' then v.color=vector(floor(a/65536)%256,floor(a/256)%256,a%256)
        elseif op=='alpha2' then v.alpha2=vector(a%256)
        elseif op=='color2' then v.color2=vector(a%256,b%256,d%256)
        elseif op=='flipx' then v.scale[1]=-v.scale[1]
        elseif op=='flipy' then v.scale[2]=-v.scale[2]
        elseif op=='blend' or op=='additive_value' then v.blend=a~=0 and 'mul+add' or ''
        elseif op=='additive' then v.blend='mul+add'
        elseif op=='normal' then v.blend=''
        elseif op=='follow' then v.follow=a~=0
        elseif op=='flag27' then v.follow=a~=0
        elseif op=='anchor' then v.anchor=1
        elseif op=='anchor_state' then v.anchor_x=a;v.anchor_y=b
        elseif op=='drawmode' then v.drawmode=a
        elseif op=='secondary' then v.secondary=a~=0
        elseif op=='child' then
            v.children[#v.children+1]=A.new(v.data.game,v.data.archive,a)
        elseif op=='add_u' then v.u=(v.u+a)%1
        elseif op=='add_v' then v.v=(v.v+a)%1
        elseif op=='u_speed' then v.us=a
        elseif op=='v_speed' then v.vs=a
        elseif op=='unit_speed' then v.unit_speed=a~=0
        elseif op=='position_time' then interp(v,'position',a,b,vector(d,e,f))
        elseif op=='position_bezier' then
            interp(v,'position',a,8,vector(value(v,c[7]),value(v,c[8]),value(v,c[9])))
            v.interps.position.controls={vector(b,d,e),vector(value(v,c[10]),value(v,c[11]),value(v,c[12]))}
        elseif op=='ring_vertices' then v.ring_vertices=a
        elseif op=='rotation_time' then interp(v,'rotation',a,b,vector(d,e,f))
        elseif op=='scale_time' then interp(v,'scale',a,b,vector(d,e))
        elseif op=='color_time' then interp(v,'color',a,b,vector(d,e,f))
        elseif op=='packed_color_time' then interp(v,'color',a,b,vector(d%256,floor(d/256)%256,floor(d/65536)%256))
        elseif op=='alpha_time' then interp(v,'alpha',a,b,vector(d))
        elseif op=='color2_time' then interp(v,'color2',a,b,vector(d,e,f))
        elseif op=='alpha2_time' then interp(v,'alpha2',a,b,vector(d))
        elseif op=='position_linear' or op=='position_decel' or op=='position_decel4' then
            interp(v,'position',e,op=='position_linear' and 0 or op=='position_decel' and 4 or 6,vector(a,b,d))
        elseif op=='fade' then interp(v,'alpha',b,0,vector(a))
        elseif op=='scale_linear' then interp(v,'scale',d,0,vector(a,b))
        elseif op=='wait' then
            v.wait=v.wait or a
            if v.wait>0 then v.wait=v.wait-1;v.pc=v.pc-1;return else v.wait=nil end
        elseif op=='iset' or op=='fset' then put(v,c[3],b)
        elseif op=='irandom' or op=='frandom' then put(v,c[3],op=='irandom' and ran:Int(0,b-1) or ran:Float(0,b))
        elseif op=='sin' or op=='cos' or op=='tan' or op=='acos' or op=='atan' then put(v,c[3],math[op](b))
        elseif op=='normalize' then put(v,c[3],(a+math.pi)%(2*math.pi)-math.pi)
        elseif op:sub(2,2)=='j' then
            local cmp=op:sub(3)
            if (cmp=='eq' and a==b) or (cmp=='ne' and a~=b) or (cmp=='lt' and a<b)
                or (cmp=='le' and a<=b) or (cmp=='gt' and a>b) or (cmp=='ge' and a>=b) then jump(v,d,e) end
        elseif op:sub(1,1)=='i' or op:sub(1,1)=='f' then
            local arithmetic=op:sub(2);local x,y=a,b
            if arithmetic:sub(1,4)=='set_' then arithmetic=arithmetic:sub(5);x,y=b,d end
            local n
            if arithmetic=='add' then n=x+y elseif arithmetic=='sub' then n=x-y
            elseif arithmetic=='mul' then n=x*y elseif arithmetic=='div' then n=x/y
            elseif arithmetic=='mod' then n=x%y end
            if n then
                if op:sub(1,1)=='i' then n=n<0 and math.ceil(n) or floor(n) end
                put(v,c[3],n)
            end
        end
    end
    error('原作ANM同帧指令未收敛：'..v.data.key..'/'..v.id)
end
function A.step(v,dt)
    if v.children[1] then
        for _,child in ipairs(v.children) do A.step(child,dt) end
        if v.data.game==11 then
            for i=#v.children,1,-1 do
                local child=v.children[i]
                if child.finished and not child.visible then table.remove(v.children,i) end
            end
        end
    end
    if v.finished then return end
    if not v.stopped then execute(v) end
    if v.finished then return end
    dt=v.unit_speed and 1 or (dt or 1)
    -- 绝大多数弹雾没有三轴自转/UV流动；不逐粒执行恒为零的积分，保留原指令顺序。
    local omega,growth=v.omega,v.growth
    if omega[1]~=0 or omega[2]~=0 or omega[3]~=0 then
        for i=1,3 do v.rotation[i]=v.rotation[i]+omega[i]*dt end
    end
    if growth[1]~=0 or growth[2]~=0 then
        for i=1,2 do v.scale[i]=v.scale[i]+growth[i]*dt end
    end
    for key,p in pairs(v.interps) do
        p.time=min(p.duration,p.time+dt)
        local t=p.time/p.duration
        if p.mode>=1 and p.mode<=3 then t=t^(p.mode+1)
        elseif p.mode>=4 and p.mode<=6 then t=1-(1-t)^(p.mode-2)
        elseif p.mode>=9 and p.mode<=11 then
            local power=p.mode-7;local u=t*2
            t=u<1 and u^power/2 or 1-(2-u)^power/2
        elseif p.mode>=12 and p.mode<=14 then
            local power=p.mode-10;local u=t*2
            t=u<1 and (1-(1-u)^power)/2 or ((u-1)^power+1)/2
        elseif p.mode==15 then t=0 elseif p.mode==16 then t=1 end
        for i,n in ipairs(p.target) do
            if p.controls then
                local t2,t3=t*t,t*t*t
                v[key][i]=(2*t3-3*t2+1)*p.from[i]+(t3-2*t2+t)*p.controls[1][i]+(-2*t3+3*t2)*n+(t3-t2)*p.controls[2][i]
            else v[key][i]=p.from[i]+(n-p.from[i])*t end
        end
        if p.time>=p.duration then v.interps[key]=nil end
    end
    if v.us~=0 or v.u<0 or v.u>=1 then v.u=(v.u+v.us*dt)%1 end
    if v.vs~=0 or v.v<0 or v.v>=1 then v.v=(v.v+v.vs*dt)%1 end
    if not v.stopped and not v.wait then v.time=v.time+dt end
end
function A.new(game,archive,id,dt,sprite_resolver)
    local data=A.load(game,archive)
    local script=assert(data.scripts[id], '原作ANM脚本缺失：'..data.key..'/'..id)
    local v={data=data,id=id,script=script,pc=1,time=0,vars={},interps={},visible=false,
        sprite_base=data.sprite_bases and data.sprite_bases[id] or 0,sprite_resolver=sprite_resolver,
        position=vector(0,0,0),rotation=vector(0,0,0),omega=vector(0,0,0),scale=vector(1,1),
        growth=vector(0,0),color=vector(255,255,255),alpha=vector(255),color2=vector(255,255,255),
        alpha2=vector(255),blend='',u=0,v=0,us=0,vs=0,children={}}
    A.step(v,dt)
    return v
end
function A.sprite_resource(v)
    local s=assert(v.data.sprites[v.sprite], '原作ANM精灵缺失：'..v.data.key..'/'..v.sprite)
    local scope=stage and stage.current_stage
    local timer=scope and scope.timer or 0
    -- 重试会复用同一张 stage 表，但 ext.lua 会清空 stage 资源池并把 timer 归零。
    if scope~=resource_scope or timer<resource_timer then
        resource_scope=scope;resource_epoch=resource_epoch+1
        -- 图像句柄随stage资源池释放，避免ANM元数据缓存把上一关纹理永久留在内存中。
        for _,data in pairs(cache) do
            for _,sprite in pairs(data.sprites) do sprite.native_draw_resource=nil end
        end
    end
    resource_timer=timer
    if not s.loaded or s.epoch~=resource_epoch then
        if not CheckRes('tex',s.tex) then LoadTexture(s.tex,s.path) end
        if not CheckRes('img',s.img) then LoadImage(s.img,s.tex,s[2],s[3],s[4],s[5]) end
        s.loaded,s.epoch=true,resource_epoch
    end
    if lstg.AndroidRenderSprite and not s.native_draw_resource then
        s.native_draw_resource=assert(FindResSprite(s.img))
    end
    return s
end
function A.draw(v,x,y,angle,sx,sy,alpha,tint,override,rotation)
    if v.children[1] then for _,child in ipairs(v.children) do A.draw(child,x,y,angle,sx,sy,alpha,tint,override) end end
    if not v.visible or not v.sprite then return end
    local s=A.sprite_resource(v)
    local color=override and override.color or (v.secondary and v.color2 or v.color)
    if override and override.mix then
        -- TH08 MixColors：先对VM顶点色乘/128并截断饱和，再与纹理相乘。
        local m=override.mix
        color={min(255,floor(color[1]*m[1]/128)),min(255,floor(color[2]*m[2]/128)),min(255,floor(color[3]*m[3]/128))}
    end
    if tint then color={color[1]*tint[1]/255,color[2]*tint[2]/255,color[3]*tint[3]/255} end
    local a=(override and override.alpha or (v.secondary and v.alpha2[1] or v.alpha[1]))*(alpha or 1)
    local image=s.img
    local ca,cr,cg,cb=max(0,min(255,floor(a))),floor(color[1]),floor(color[2]),floor(color[3])
    if v.ring_vertices and RenderTexture then
        -- TH11 mode13：scale.x是带宽、scale.y是半径，rotation.x是弧长；
        -- 不能把这三项当作平面精灵的缩放/俯仰角。原码见AnimationExecutionUpdate.inc。
        local count=v.vars[10000] or v.ring_vertices
        if count<2 then return end
        local tw,th=GetTextureSize(s.tex)
        if lstg.SetTextureSamplerState then lstg.SetTextureSamplerState(s.tex,'linear+wrap') end
        local co=Color(ca,cr,cg,cb)
        local first=v.rotation[3]-v.rotation[1]/2
        local step=v.rotation[1]/(count-1)
        local outer,inner=v.scale[2]+v.scale[1]/2,v.scale[2]-v.scale[1]/2
        local cx,cy=x+v.position[1],y-v.position[2]
        local repeats=v.vars[10001] or 1
        local function point(theta,r,u,w) return {cx+math.cos(theta)*r,cy-math.sin(theta)*r,.5,u,w,co} end
        for i=0,count-2 do
            local aa,bb=first+i*step,first+(i+1)*step
            local vv,ww=(v.v+i*repeats/(count-1))*th,(v.v+(i+1)*repeats/(count-1))*th
            local u0,u1=s[2]+v.u*tw,s[2]+s[4]+v.u*tw
            RenderTexture(s.tex,v.blend,point(aa,outer,u0,vv),point(bb,outer,u0,ww),point(bb,inner,u1,ww),point(aa,inner,u1,vv))
        end
        return
    end
    sx,sy=(sx or 1)*v.scale[1],(sy or sx or 1)*v.scale[2]
    -- TH06 TranslateRotation为(x*c+y*s,-x*s+y*c)，后续作品则为(x*c-y*s,x*s+y*c)。
    -- 翻转屏幕Y轴后，TH06的VM角保持正号，其余作品取负号。
    -- rotation只覆盖当前VM，表示BulletManager最终赋值的世界角，不改变其他调用方的附加旋转。
    local rot=(v.data.game==6 and 1 or -1)*v.rotation[3]/rad+(v.follow and (angle or 0) or 0)
    if rotation~=nil then rot=rotation end
    -- X/Y 旋转在原作相机正交的二维精灵上体现为投影宽高。
    sx=sx*math.cos(v.rotation[2]);sy=sy*math.cos(v.rotation[1])
    local px,py=x+v.position[1],y-v.position[2]
    if v.anchor==1 then px=px+s[4]*sx/2;py=py-s[5]*sy/2 end
    if v.anchor_x==1 then px=px+s[4]*sx/2 elseif v.anchor_x==2 then px=px-s[4]*sx/2 end
    if v.anchor_y==1 then py=py-s[5]*sy/2 elseif v.anchor_y==2 then py=py+s[5]*sy/2 end
    if (v.u~=0 or v.v~=0) and RenderTexture then
        local tw,th=GetTextureSize(s.tex)
        if lstg.SetTextureSamplerState then lstg.SetTextureSamplerState(s.tex,'linear+wrap') end
        local co=Color(ca,cr,cg,cb)
        SetImageState(image,v.blend,co)
        local cr,sr=math.cos(rot*rad),math.sin(rot*rad)
        local function corner(dx,dy,u,w)
            return {px+dx*cr-dy*sr,py+dx*sr+dy*cr,.5,u,w,co}
        end
        local u,w=s[2]+v.u*tw,s[3]+v.v*th
        RenderTexture(s.tex,v.blend,corner(-s[4]*sx/2,s[5]*sy/2,u,w),
            corner(s[4]*sx/2,s[5]*sy/2,u+s[4],w),corner(s[4]*sx/2,-s[5]*sy/2,u+s[4],w+s[5]),
            corner(-s[4]*sx/2,-s[5]*sy/2,u,w+s[5]))
    elseif lstg.AndroidRenderSprite then
        lstg.AndroidRenderSprite(s.native_draw_resource,v.blend,px,py,rot,sx,sy,ca,cr,cg,cb)
    else
        SetImageState(image,v.blend,Color(ca,cr,cg,cb))
        Render(image,px,py,rot,sx,sy)
    end
end
function A.sprite(v,id) assert(v.data.sprites[id],v.data.key..'/sprite'..id);v.sprite=id end
function A.cache() return cache end
