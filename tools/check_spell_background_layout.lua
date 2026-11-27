-- 使用正式背景节点和渲染回调检查铺设范围/底层覆盖，不读写玩家存档。
local classes={}
Class=function(base,body)classes[#classes+1]=body;return body end
object={};background={};LAYER={BG=-700,PLAYER_BULLET=-300,ENEMY_BULLET=0,TOP=1000};GROUP={GHOST=0}
setting={displayBG=true};lstg={world={l=-192,r=192,b=-224,t=224}}
sin=function(a)return math.sin(math.rad(a))end;cos=function(a)return math.cos(math.rad(a))end
SetViewMode=function()end
local rendered,rectangles={},{ }
SetImageState=function()end
Render=function(id,x,y,rot,sx,sy)rendered[#rendered+1]={id=id,x=x,y=y,rot=rot,sx=sx,sy=sy}end
RenderRect=function(id,l,r,b,t)rectangles[#rectangles+1]={l,r,b,t}end
local data=dofile('mod/GAME/th38/actors.lua')
local A={data=data,picture=function(key)return key,data.sprites[key].scale end}
assert(loadfile('mod/GAME/th38/spell_background.lua'))(A)
local scene=classes[#classes]
for _,key in ipairs({'fuka_beijing','fuka_beijing2'})do
    local o={};scene.init(o,key)
    for _=1,180 do scene.frame(o)end
    rendered={};scene.render(o)
    local covered=false
    for _,d in ipairs(rendered)do
        local p=data.sprites[d.id]
        if p.w==768 and p.h==896 and math.abs(d.rot)<1e-6 then
            local l=d.x-p.pivot[1]*d.sx;local r=l+p.w*d.sx
            local t=d.y+p.pivot[2]*d.sy;local b=t-p.h*d.sy
            if l<=-192+1e-6 and r>=192-1e-6 and b<=-224+1e-6 and t>=224-1e-6 then covered=true end
        end
    end
    assert(covered,'符卡底图未覆盖完整场地：'..key)
end
print('PASS：雪莲华一/二面原始背景节点的底图覆盖完整384×448场地。')
dofile('mod/GAME/th39/background.lua')
scene=classes[#classes]
local draws=0
for i=1,20 do
    local key=debug.getupvalue(scene.render,i)
    if not key then break end
    if key=='R' then debug.setupvalue(scene.render,i,{drawBackground=function()draws=draws+1 end,player=function()return 0,0 end})end
end
New=function()return {}end
RogueEncounter={spellOnly=function()return true end}
local overlay={};scene.init(overlay,{script='504'},0)
assert(overlay.layer>LAYER.BG,'符卡层被保留的关卡背景覆盖')
for _,case in ipairs({{false,false,false,true},{true,false,false,false},{true,true,false,true},{true,true,true,false}})do
    local only,spell,keep,opaque=unpack(case)
    local state={spellOnly=only,effects={},spell=spell and {keep=keep,effects={{}}} or nil,fade=0}
    rectangles={};draws=0;scene.render({state=state})
    assert((#rectangles>0)==opaque,'永夜篇关卡层覆盖状态不符')
    assert(draws==(spell and 1 or 0),'覆盖底层中断了原作符卡层')
    if opaque then assert(table.concat(rectangles[1],',')=='-192,192,-224,224','底层覆盖范围偏移')end
end
print('PASS：永夜篇普通/随机/非符/KeepBackground均使用对应底层覆盖，符卡效果继续绘制。')
