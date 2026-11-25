-- 真实ANM数据与正式RemoveResource封装：覆盖同关卸载，不推进无关卡的弹幕。
local env=setmetatable({},{__index=_G});env._G=env
local state={images={},textures={},pool='stage',queries=0,loads=0,draws=0,removed={}}
env.stage={current_stage={timer=10}}
env.lstg={RemoveResource=function(...)
    local argc=select('#',...);local pool,kind,name=...
    state.removed[#state.removed+1]=argc
    if kind==nil then
        for _,r in pairs(state.images)do r.valid=false end
        state.images,state.textures={},{}
    elseif kind==2 then local r=state.images[name];if r then r.valid=false;state.images[name]=nil end
    elseif kind==1 then state.textures[name]=nil end
    return 'removed',17
end}
env.CheckRes=function(kind,name)state.queries=state.queries+1;return (kind=='tex' and state.textures or state.images)[name] and state.pool end
env.LoadTexture=function(name)state.textures[name]=true end
env.LoadImage=function(name,tex,x,y,w,h)state.loads=state.loads+1;state.images[name]={valid=true,name=name,rect={x,y,w,h}}end
env.FindResSprite=function(name)state.queries=state.queries+1;return state.images[name]end
env.GetTextureSize=function()return 512,512 end
env.Color=function(...)return {...}end
env.RenderTexture=function()end
env.ran={Int=function(_,a)return a end,Float=function(_,a)return a end}
env.lstg.AndroidRenderSprite=function(resource)
    assert(resource and resource.valid,'使用已卸载的ANM句柄');state.draws=state.draws+1
end
local function run(path,source)
    local load=assert(loadstring(source or assert(io.open(path)):read('*a'),'@'..path));setfenv(load,env);return load()
end
local f=assert(io.open('THlib/lib/Lresources.lua','rb'));local resources=f:read('*a');f:close()
local stop=assert(resources:find('-- 引擎按 stage/global',1,true));run('THlib/lib/Lresources.lua',resources:sub(1,stop-1))
run('THlib/anm/original.lua')
local A=env.OriginalANM
local data=A.load(8,'enemy');local vm
for id in pairs(data.scripts)do local v=A.new(8,'enemy',id);if v.visible and v.sprite then vm=v;break end end
assert(vm,'没有可绘制的原作敌机VM')
A.draw(vm,0,0)
local sprite=data.sprites[vm.sprite];local old=sprite.native_draw_resource
local x,y=env.RemoveResource('stage',2,sprite.img)
assert(x=='removed' and y==17,'卸载封装改变返回值')
assert(not old.valid and env.stage.current_stage.timer==10,'未覆盖同关同计时卸载')
A.draw(vm,0,0)
assert(sprite.native_draw_resource~=old and sprite.native_draw_resource==state.images[sprite.img],'句柄未重新绑定')
local loaded,queries=state.loads,state.queries
for i=1,1000 do env.stage.current_stage.timer=10+i;A.draw(vm,0,0)end
assert(state.loads==loaded and state.queries==queries,'热路径重复查询/重载资源')
env.lstg.RemoveResource('stage');assert(state.removed[#state.removed]==1,'整池卸载多传了nil参数')
A.draw(vm,0,0);assert(sprite.native_draw_resource.valid,'整池卸载后未恢复')
print('ANM同关单图/整池卸载、当前句柄重绑、返回值/参数保留及1000次绘制复用通过')
