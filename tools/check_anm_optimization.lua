-- 将修改前源码路径作为参数，逐帧比较实际ANM状态和绘制参数；不读写玩家数据，不替代GPU验收。
local reference=assert(arg[1],'需要修改前ANM源码路径')
local function engine(path,fast)
    local env=setmetatable({},{__index=_G})
    env._G=env
    local state={images={},textures={},draws={},colors=0,native=0,capture=true,seed=12345}
    env.stage={current_stage={timer=0}}
    env.lstg={SetTextureSamplerState=function() end}
    env.ran={Float=function(_,a,b)
        state.seed=state.seed*16807%2147483647
        return a+(b-a)*state.seed/2147483647
    end}
    env.ran.Int=function(_,a,b) return math.floor(env.ran:Float(a,b+1)) end
    env.CheckRes=function(kind,name) return (kind=='tex' and state.textures or state.images)[name]~=nil end
    env.LoadTexture=function(name) state.textures[name]=true end
    env.LoadImage=function(name) state.images[name]={name=name} end
    env.FindResSprite=function(name) return state.images[name] end
    env.GetTextureSize=function() return 512,512 end
    local function color(a,r,g,b) return {a%256,r%256,g%256,b%256} end
    env.Color=function(a,r,g,b) state.colors=state.colors+1;return color(a,r,g,b) end
    env.SetImageState=function(name,blend,c) state.images[name].color=c;state.images[name].blend=blend end
    env.Render=function(name,x,y,rot,sx,sy)
        if state.capture then
            local image=assert(state.images[name]);local c=assert(image.color)
            state.draws[#state.draws+1]={name,image.blend,x,y,rot,sx,sy,c[1],c[2],c[3],c[4]}
        end
    end
    env.RenderTexture=function(name,blend,...)
        if state.capture then state.draws[#state.draws+1]={name,blend,...} end
    end
    if fast then env.lstg.AndroidRenderSprite=function(resource,blend,x,y,rot,sx,sy,a,r,g,b)
        state.native=state.native+1
        if state.capture then
            local c=color(a,r,g,b)
            state.draws[#state.draws+1]={resource.name,blend,x,y,rot,sx,sy,c[1],c[2],c[3],c[4]}
        end
    end end
    local load=assert(loadfile(path));setfenv(load,env);load()
    return env.OriginalANM,state,env
end
local old,oldState=engine(reference,false)
local new,newState,newEnv=engine('THlib/anm/original.lua',true)
local checks=0
local function equal(a,b,label)
    if type(a)=='table' then
        assert(type(b)=='table',label)
        for k,v in pairs(a) do equal(v,b[k],label..'.'..tostring(k)) end
        for k in pairs(b) do assert(a[k]~=nil,label..'.'..tostring(k)) end
    elseif type(a)=='number' and type(b)=='number' then assert(math.abs(a-b)<1e-8,label)
    else assert(a==b,label..': '..tostring(a)..' / '..tostring(b)) end
end
local fields={'pc','time','sprite','stopped','finished','visible','position','rotation','omega','scale','growth',
    'color','alpha','color2','alpha2','vars','interps','u','v','us','vs','blend','secondary','anchor','anchor_x','anchor_y'}
local function compare(a,b)
    for _,key in ipairs(fields) do equal(a[key],b[key],key) end
    assert(#a.children==#b.children)
    for i,child in ipairs(a.children) do compare(child,b.children[i]) end
end
for _,source in ipairs({{6,'etama3'},{6,'etama4'},{7,'etama'},{8,'etama'},{95,'bullet'},{10,'bullet'}}) do
    local game,archive=unpack(source)
    local data=old.load(game,archive)
    for id in pairs(data.scripts) do
        for _,interrupt in ipairs(game>=95 and {0,7,8,9} or {0}) do
            oldState.seed,newState.seed=1000+id,1000+id
            local a,b=old.new(game,archive,id),new.new(game,archive,id)
            if interrupt~=0 then old.interrupt(a,interrupt);new.interrupt(b,interrupt) end
            for frame=1,25 do
                compare(a,b)
                oldState.draws,newState.draws={},{}
                local tint=frame%2==0 and {192,255,128} or nil
                local override=frame%3==0 and {mix={160,128,200},alpha=192} or nil
                old.draw(a,20,-30,17,.75,1.5,.8,tint,override)
                new.draw(b,20,-30,17,.75,1.5,.8,tint,override)
                equal(oldState.draws,newState.draws,'绘制 '..game..'/'..id..'/'..interrupt..'/'..frame)
                local dt=({1,.5,1.25,0,2})[frame%5+1]
                old.step(a,dt);new.step(b,dt)
                checks=checks+1
            end
        end
    end
end
-- 资源池重建后必须重新取得当前句柄；旧元数据不能持有已经释放的图像。
local v=new.new(7,'etama',21)
new.draw(v,0,0)
local sprite=v.data.sprites[v.sprite]
local resource=sprite.native_draw_resource
newEnv.stage.current_stage={timer=0};newState.images,newState.textures={},{}
new.draw(v,0,0)
assert(sprite.native_draw_resource~=resource and sprite.native_draw_resource==newState.images[sprite.img])
-- 对同一批出生动画统计Color分配；计时仅供主机Lua解释器参考，不是真机帧率。
local function bench(A,s)
    s.capture=false;s.colors=0;s.native=0
    local particles={}
    for i=1,2000 do particles[i]=A.new(7,'etama',21) end
    local start=os.clock()
    for frame=1,20 do
        for _,p in ipairs(particles) do A.draw(p,0,0);A.step(p) end
    end
    return os.clock()-start,s.colors,s.native
end
local before,colors=bench(old,oldState)
local after,optimized,native=bench(new,newState)
assert(colors>0 and optimized==0 and native>0,'普通ANM精灵应消除逐粒Color创建')
print(('ANM逐帧状态及绘制参数一致：%d次；2000弹雾×20帧 Color %d→%d，主机参考耗时 %.3f→%.3fs'):format(
    checks,colors,optimized,before,after))
