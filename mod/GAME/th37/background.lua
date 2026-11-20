-- 春雪篇原始XNA网格、背景时间轴、相机、UV动画与深度模式。
local B={}
local State=dofile('mod/GAME/th37/scene_state.lua')
local models={}
local white=Color(255,255,255,255)
local alphaMode,cutoutMode='',''
local modesReady=false
local function modes()
    if modesReady then return end;modesReady=true
    if lstg.RenderMode and CreateShaderProgramFromPath then
        local normal=lstg.RenderMode:getByName(''):getProgram()
        local cutout=assert(CreateShaderProgramFromPath('src/shader/Common.vert','game/mod/GAME/th37/xna_cutout.frag'))
        lstg.RenderMode:create('xna:alpha',ccb.BlendOperation.ADD,ccb.BlendFactor.ONE,ccb.BlendFactor.ONE_MINUS_SRC_ALPHA,normal)
        lstg.RenderMode:create('xna:cutout',ccb.BlendOperation.ADD,ccb.BlendFactor.ONE,ccb.BlendFactor.ONE_MINUS_SRC_ALPHA,cutout)
        alphaMode,cutoutMode='xna:alpha','xna:cutout'
    end
end
local function prepare(name)
    local d=models[name]
    if d then return d end
    modes()
    d=dofile('mod/GAME/th37/scenes/models/'..name..'.lua');models[name]=d
    local pool=GetResourceStatus();SetResourceStatus('global')
    for _,part in ipairs(d) do
        local id='th37_mesh_'..part[1]
        if not CheckRes('tex',id) then LoadTexture(id,'Resources/th37/scene/'..part[1]..'.png') end
        SetTextureSamplerState(id,'linear+wrap')
        part.texture=id;part.w,part.h=GetTextureSize(id)
        if lstg.AndroidCreateModelMesh then part.native=lstg.AndroidCreateModelMesh(FindResTexture(id),part[3]) end
        if RogueEncounter then RogueEncounter.checkpoint() end
    end
    SetResourceStatus(pool)
    return d
end
local corners={{},{},{}}
local function draw(m,frame,particle)
    if m.alpha<=0 or m.prepare or m.separate and not particle then return end
    local data=prepare(m.name)
    local pos,scale,rotation=m.pos,m.scale,m.rotation
    local blend=m.blend==1 and (m.cutout and cutoutMode or alphaMode) or 'mul+add'
    local a=m.alpha*(particle and particle.alpha or 1)
    if particle then pos,scale,rotation=particle.pos,particle.scale,particle.rotation end
    local tint=Color(255*a,255*m.color[1]*a,255*m.color[2]*a,255*m.color[3]*a)
    -- Sub 的深度状态要求数字；第二参保留给 LuaSTG-x 的深度写入开关。
    SetZBufferEnable(m.label~="1003" and 1 or 0,not m.depth)
    local u,v=m.uv and m.uv[1]*frame or 0,m.uv and m.uv[2]*frame or 0
    local cx,sx,cy,sy,cz,sz=math.cos(rotation[1]),math.sin(rotation[1]),math.cos(rotation[2]),math.sin(rotation[2]),math.cos(rotation[3]),math.sin(rotation[3])
    for _,part in ipairs(data) do
        if part.native then
            lstg.AndroidRenderModelMesh(part.native,blend,tint,pos[1],pos[2],pos[3],scale[1],scale[2],scale[3],rotation[1],rotation[2],rotation[3],u,v)
        else
            local vertices=part[3]
            for i=1,#vertices,15 do
                for j=1,3 do
                    local out=corners[j];local k=i+(j-1)*5
                    local x,y,z=(vertices[k]+pos[1])*scale[1],(vertices[k+1]+pos[2])*scale[2],(vertices[k+2]+pos[3])*scale[3]
                    y,z=y*cx-z*sx,y*sx+z*cx;x,z=x*cy+z*sy,-x*sy+z*cy
                    out[1],out[2],out[3]=x*cz-y*sz,x*sz+y*cz,z
                    out[4],out[5],out[6]=(vertices[k+3]+u)*part.w,(vertices[k+4]+v)*part.h,tint
                end
                RenderTexture(part.texture,blend,corners[1],corners[2],corners[3],corners[3])
            end
        end
    end
end
local snapshot,ready
function B.prepare(chapter,clock)
    if not setting or not setting.displayBG then return end
    if not snapshot or snapshot.chapter~=chapter or snapshot.clock~=clock then
        snapshot={chapter=chapter,clock=clock,state=State.new(chapter,clock,B.musicFrames and B.musicFrames[chapter])}
    end
    local state=RogueEncounter.copyPrepared(snapshot.state)
    for _,m in ipairs(state.models) do prepare(m.name) end
    for _,p in ipairs(state.particles) do prepare(p.model.name) end
    ready={chapter=chapter,clock=clock,state=state}
end
function B.clearPrepared() snapshot,ready=nil,nil end
local Scene=Class(background,{
    init=function(o,chapter,clock)
        background.DelBG();lstg.tmpvar.bg=o
        o.layer,o.group,o.bound,o.colli=LAYER.BG-.1,GROUP.GHOST,false,false
        if ready and ready.chapter==chapter and ready.clock==(clock or 0) then o.state=ready.state;ready=nil
        else o.state=State.new(chapter,clock or 0,B.musicFrames and B.musicFrames[chapter]) end
        o.chapter=chapter
    end,
    frame=function(o) State.step(o.state,o.boss and IsValid(o.boss)) end,
    render=function(o)
        if not setting.displayBG then return end
        local s=o.state;local eye,at,travel=s.eye,s.at,s.travel
        local previous=lstg.view3d;lstg.view3d={}
        SetViewMode('world');SetImageState('white','',255,0,0,0)
        local w=lstg.world;RenderRect('white',w.l,w.r,w.b,w.t);SetImageState('white','',255,255,255,255)
        Set3D('eye',eye[1]+travel[1],eye[2]+travel[2],eye[3]+travel[3])
        Set3D('at',at[1]+travel[1],at[2]+travel[2],at[3]+travel[3]);Set3D('up',unpack(s.up))
        -- 原作先画640×480，再裁取384×448战斗区；保留240/tan(pi/8)的像素焦距。
        local fov=2*math.atan(math.tan(math.pi/8)*448/480)
        Set3D('fovy',fov);Set3D('z',20,s.far);Set3D('fog',0,0,white)
        SetViewMode('3d')
        -- LuaSTG为左手坐标；XNA为右手坐标。负横纵比恢复原模型的投影方向。
        SetPerspective(eye[1]+travel[1],eye[2]+travel[2],eye[3]+travel[3],at[1]+travel[1],at[2]+travel[2],at[3]+travel[3],s.up[1],s.up[2],s.up[3],fov,-(w.r-w.l)/(w.t-w.b),20,s.far)
        ClearZBuffer()
        for _,m in ipairs(s.models) do if m.label~='1003' then draw(m,s.frame) end end
        for _,p in ipairs(s.particles) do draw(p.model,0,p) end
        local overlay=State.find(s,1003);if overlay then draw(overlay,s.frame) end
        SetZBufferEnable(0);lstg.view3d=previous;SetViewMode('world')
        if s.fade>0 then SetImageState('white','',255*s.fade,0,0,0);RenderRect('white',w.l,w.r,w.b,w.t);SetImageState('white','',255,255,255,255) end
    end,
},true)
B.class,B.State=Scene,State
local function current() local o=lstg.tmpvar.bg;return o and IsValid(o) and o.class==Scene and o end
function B.show(chapter,clock)
    if setting and setting.displayBG then return New(Scene,chapter,clock) end
end
function B.setBoss(boss) local o=current();if o then o.boss=boss end end
function B.signalMusic() local o=current();if o and o.state.mode=='music' then o.state.mode='boss' end end
-- 原作Data/<stage><bgtype>.xna：按BSprite更新、循环、缩放及混合顺序绘制。
local spellData=dofile('mod/GAME/th37/spell_backgrounds.lua')
local spellObject
local Spell=Class(object,{
    init=function(o,key)
        o.layer=LAYER.BG-.05;o.group=GROUP.GHOST;o.bound,o.colli=false,false
        o.parts={}
        for i,p in ipairs(spellData[key]) do
            local name='mhj2_spell_'..p.texture
            if not CheckRes('tex',name) then
                local pool=GetResourceStatus();SetResourceStatus('global')
                LoadTexture(name,'Resources/th37/spell'..p.texture..'.png')
                local w,h=GetTextureSize(name);LoadImage(name,name,0,0,w,h)
                SetResourceStatus(pool)
            end
            o.parts[i]={data=p,x=p.position[1],y=p.position[2],rotation=0}
        end
    end,
    frame=function(o)
        for _,s in ipairs(o.parts) do
            local p=s.data
            s.x,s.y=s.x+p.move[1],s.y+p.move[2]
            s.rotation=(s.rotation+p.rotate)%360
            for _,t in ipairs(p.turn) do
                local x=t[1]=='nul' or (t[1]-s.x)*p.move[1]<=0
                local y=t[2]=='nul' or (t[2]-s.y)*p.move[2]<=0
                if x and y then
                    if t[3]~='nul' then s.x=t[3] end
                    if t[4]~='nul' then s.y=t[4] end
                end
            end
        end
    end,
    render=function(o)
        if not setting.displayBG then return end
        SetViewMode('world')
        SetImageState('white','',255,0,0,0)
        local w=lstg.world;RenderRect('white',w.l,w.r,w.b,w.t)
        SetImageState('white','',255,255,255,255)
        for _,add in ipairs({false,true}) do
            for _,s in ipairs(o.parts) do
                local p=s.data
                if p.add==add then
                    local name='mhj2_spell_'..p.texture
                    SetImageCenter(name,p.origin[1],p.origin[2])
                    SetImageState(name,add and 'mul+add' or '',255*p.alpha/100*math.min(1,(o.timer+1)/60),255,255,255)
                    Render(name,s.x-192,224-s.y,-s.rotation,p.scale[1],p.scale[2])
                end
            end
        end
    end,
})
function B.endSpell()
    if spellObject and IsValid(spellObject) then Del(spellObject) end
    spellObject=nil
end
function B.spell(stage,variant)
    B.endSpell()
    local key=tostring(stage)..tostring(variant)
    if setting and setting.displayBG and spellData[key] then spellObject=New(Spell,key) end
end
return B
