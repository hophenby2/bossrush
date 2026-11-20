-- Original Direct3D scene, 404x468 viewport clipped by the 384x448 playfield.
local M={State=dofile('mod/GAME/th40/scene_state.lua')}
local data=dofile('mod/GAME/th40/scene_data.lua')
local models={}
local function texture(file)
    local id='th40_scene3d_'..file
    if not CheckRes('tex',id) then
        local pool=GetResourceStatus();SetResourceStatus('global')
        LoadTexture(id,'Resources/th40/scene/'..file);SetTextureSamplerState(id,'linear+wrap')
        local w,h=GetTextureSize(id);LoadImage(id,id,0,0,w,h);SetResourceStatus(pool)
    end
    return id
end
local function model(name,floor)
    if models[name] then return models[name] end
    local d=assert(data[name],name);local parts=d.parts
    if not parts then
        local v={}
        local function vertex(x,y,u,w) v[#v+1]=x;v[#v+1]=y;v[#v+1]=0;v[#v+1]=u;v[#v+1]=w end
        if floor then
            for i=0,5 do
                local y=6000-i*1000;local a,b=i%2,(i+1)%2
                vertex(-500,y,0,a);vertex(500,y,1,a);vertex(-500,y-1000,0,b)
                vertex(500,y,1,a);vertex(500,y-1000,1,b);vertex(-500,y-1000,0,b)
            end
        else
            local x,y=-d.cx,-d.cy;local r,b=x+d.w,y+d.h
            vertex(x,y,0,0);vertex(r,y,1,0);vertex(x,b,0,1)
            vertex(r,y,1,0);vertex(r,b,1,1);vertex(x,b,0,1)
        end
        parts={{file=d.file,vertices=v}}
    end
    local result={}
    for _,p in ipairs(parts) do
        local id=texture(p.file);local w,h=GetTextureSize(id)
        result[#result+1]={id=id,vertices=p.vertices,w=w,h=h,native=lstg.AndroidCreateModelMesh and lstg.AndroidCreateModelMesh(FindResTexture(id),p.vertices)}
    end
    models[name]=result;return result
end
local function transform(o,s)
    local rx,ry=o.rx,o.ry+(o.mirror and math.pi or 0)
    local z=(o.z or 0)+(o.height or 0)
    if o.tree then rx=-math.pi/2+math.atan((s.at[3]-s.eye[3])/(s.at[2]-s.eye[2]));z=math.floor(data[o.name].h/2)*o.scale*math.cos(-rx-math.pi/2) end
    local ca,sa,cx,sx,cy,sy=math.cos(o.angle),math.sin(o.angle),math.cos(rx),math.sin(rx),math.cos(ry),math.sin(ry)
    local function point(x,y,v)
        x,y=(x*ca-y*sa)*o.scale,(x*sa+y*ca)*o.scale;v=v*o.scale
        x,v=x*cy+v*sy,-x*sy+v*cy;y,v=y*cx-v*sx,y*sx+v*cx
        return x+o.x,y+o.y,v+z
    end
    local x,y,v=point(0,0,0);local m={}
    for i=1,3 do local a,b,c=point(i==1 and 1 or 0,i==2 and 1 or 0,i==3 and 1 or 0);m[(i-1)*3+1],m[(i-1)*3+2],m[(i-1)*3+3]=a-x,b-y,c-v end
    m[10],m[11],m[12]=x,y,v;return m
end
local corners={{},{},{}}
local function draw(o,s)
    if o.alpha<1 then return end
    local m=transform(o,s);local c=Color(math.floor(o.alpha),unpack(o.rgb));local blend=o.active and 'mul+add' or ''
    for _,p in ipairs(model(o.name,o.floor)) do
        if p.native then lstg.AndroidRenderModelMesh(p.native,blend,c,m,{1,1,0,0})
        else
            for i=1,#p.vertices,15 do
                for j=1,3 do
                    local k=i+(j-1)*5;local x,y,z=p.vertices[k],p.vertices[k+1],p.vertices[k+2];local v=corners[j]
                    v[1],v[2],v[3]=m[1]*x+m[4]*y+m[7]*z+m[10],m[2]*x+m[5]*y+m[8]*z+m[11],m[3]*x+m[6]*y+m[9]*z+m[12]
                    v[4],v[5],v[6]=p.vertices[k+3]*p.w,p.vertices[k+4]*p.h,c
                end
                RenderTexture(p.id,blend,corners[1],corners[2],corners[3],corners[3])
            end
        end
    end
end
local function backdrop(name,x,y,a)
    local d=data[name];local id=texture(d.file);SetImageCenter(id,d.cx,d.cy);SetImageState(id,'',a or 255,255,255,255)
    Render(id,lstg.world.l+x,lstg.world.t-y)
end
function M.prepare(s)
    for _,o in ipairs(s.objects) do model(o.name,o.floor) end
    for _,o in ipairs(s.particles) do model(o.name,o.floor) end
    local backdrops=s.chapter=='1' and {'BG01a'} or s.chapter=='5' and {'夜空底色','星星1','星星2'} or s.chapter=='EX' and {'天色'} or {}
    for _,name in ipairs(backdrops) do texture(data[name].file) end
end
function M.render(s)
    local previous=lstg.view3d;lstg.view3d={};local w=lstg.world
    SetViewMode('world');SetImageState('white','',255,unpack(s.fogColor));RenderRect('white',w.l,w.r,w.b,w.t);SetImageState('white','',255,255,255,255)
    if s.chapter=='1' then backdrop('BG01a',256,256)
    elseif s.chapter=='5' then
        backdrop('夜空底色',205,240);local a=127*math.sin(s.time/200*2*math.pi)
        backdrop('星星1',205,240,math.floor(128+a));backdrop('星星2',205,240,math.floor(128-a))
    elseif s.chapter=='EX' then backdrop('天色',204,240) end
    local eye,at,up=s.eye,s.at,s.up;local fov=2*math.atan(math.tan(s.fov/2)*448/468)
    local far=s.chapter=='EX' and 1000 or s.fogEnd+(s.chapter=='5' and 400 or 200)
    Set3D('eye',unpack(eye));Set3D('at',unpack(at));Set3D('up',unpack(up));Set3D('fovy',fov);Set3D('z',1,far)
    Set3D('fog',s.fogStart,s.fogEnd,Color(255,unpack(s.fogColor)));SetViewMode('3d')
    SetPerspective(eye[1],eye[2],eye[3],at[1],at[2],at[3],up[1],up[2],up[3],fov,(384/404)/(448/468),1,far)
    -- 使用数字状态，兼容 Sub 与 LuaSTG-x 的深度缓冲接口。
    ClearZBuffer();SetZBufferEnable((s.chapter=='5' or s.chapter=='6' and s.story<800) and 1 or 0)
    for _,o in ipairs(s.objects) do draw(o,s) end
    SetZBufferEnable(0)
    -- BaseParticle3D uses a second camera with a 234-pixel focal length.
    if #s.particles>0 then
        Set3D('eye',0,0,234);Set3D('at',0,0,0);Set3D('up',0,-1,0);Set3D('fovy',2*math.atan(224/234));Set3D('z',1,1000);Set3D('fog',0,0,Color(255,0,0,0));SetViewMode('3d')
        table.sort(s.particles,function(a,b) return a.z<b.z end)
        for _,o in ipairs(s.particles) do local x,y=o.x,o.y;o.x,o.y=x-192,y-224;draw(o,s);o.x,o.y=x,y end
    end
    lstg.view3d=previous;SetViewMode('world')
    local fade=M.State.fade(s)
    if fade>0 then SetImageState('white','',fade,0,0,0);RenderRect('white',w.l,w.r,w.b,w.t);SetImageState('white','',255,255,255,255) end
end
return M
