-- 春雪篇 XNA 模型通过 LuaSTG 的透视渲染接口绘制，沿用模型材质、起始相机与循环距离。
local B={}
local path='Resources/th37/scene/'
local prepared={}
local white=Color(255,255,255,255)
local function prepare(stage)
    local d=prepared[stage]
    if not d then
        d=dofile('mod/GAME/th37/scenes/'..stage..'.lua')
        prepared[stage]=d
    end
    for _,model in ipairs(d.models) do
        local color=model[6]
        for _,part in ipairs(model[7]) do
            local name='th37_mesh_'..part[1]
            if not CheckRes('tex',name) then LoadTexture(name,path..part[1]..'.png') end
            if not part.texture then
                local w,h=GetTextureSize(name)
                part.texture,part.w,part.h=name,w,h
                part.tint=Color(255*part[2]*model[5],255*color[1],255*color[2],255*color[3])
                local vertices=part[3]
                local minz,maxz=math.huge,-math.huge
                for i=3,#vertices,5 do
                    minz=math.min(minz,vertices[i])
                    maxz=math.max(maxz,vertices[i])
                end
                part.minz,part.maxz=minz,maxz
            end
        end
    end
    return d
end
local corners={{},{},{}}
local function draw(part,blend,x,y,z)
    local vertices,w,h=part[3],part.w,part.h
    for i=1,#vertices,15 do
        for j=1,3 do
            local v=corners[j]
            local p=i+(j-1)*5
            v[1],v[2],v[3]=vertices[p]+x,vertices[p+1]+y,vertices[p+2]+z
            v[4],v[5],v[6]=vertices[p+3]*w,vertices[p+4]*h,part.tint
        end
        RenderTexture(part.texture,blend,corners[1],corners[2],corners[3],corners[3])
    end
end
local Scene=Class(background,{
    init=function(o,chapter,clock)
        background.DelBG()
        lstg.tmpvar.bg=o
        o.layer=LAYER.BG-.1
        o.bound,o.colli=false,false
        o.scene,o.clock=prepare(chapter),clock or 0
    end,
    render=function(o)
        if not setting.displayBG then return end
        local d=o.scene
        local scroll=(o.timer+o.clock)*d.speed
        if d.loop>0 then scroll=scroll%d.loop end
        local eye,at=d.eye,d.at
        local previous=lstg.view3d
        lstg.view3d={}
        SetViewMode('world')
        SetImageState('white','',255,0,0,0)
        local w=lstg.world
        RenderRect('white',w.l,w.r,w.b,w.t)
        SetImageState('white','',255,255,255,255)
        Set3D('eye',eye[1],eye[2],eye[3])
        Set3D('at',at[1],at[2],at[3])
        if eye[3]==at[3] and eye[1]==at[1] then Set3D('up',0,0,1)
        else Set3D('up',0,1,0) end
        Set3D('fovy',math.pi/4)
        Set3D('z',.2,10)
        Set3D('fog',0,0,white)
        SetViewMode('3d')
        ClearZBuffer()
        for _,m in ipairs(d.models) do
            local label,at,add,transparent,alpha=m[1],m[2],m[3],m[4],m[5]
            if alpha>0 then
                local fixed=label>=1003 and label<=1006
                local z=at[3]-(fixed and 0 or scroll)
                local blend=add and 'mul+add' or ''
                SetZBufferEnable(transparent and 0 or 1)
                for _,part in ipairs(m[7]) do
                    if part.maxz+z>eye[3]-6 and part.minz+z<eye[3]+12 then draw(part,blend,at[1],at[2],z) end
                end
            end
        end
        SetZBufferEnable(0)
        lstg.view3d=previous
        SetViewMode('world')
    end,
},true)
function B.show(chapter,clock)
    if setting and setting.displayBG then New(Scene,chapter,clock) end
end
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
