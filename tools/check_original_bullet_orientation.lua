-- 以原作二维矩阵作独立期望值，验证各弹型的最终顶点方向，不只比较传入角度。
-- TH06 AnmManager::TranslateRotation: (x*c+y*s,-x*s+y*c)；TH07/08/095相应函数为(x*c-y*s,x*s+y*c)。
-- BulletManager的autoRotate覆盖Z角：TH06为π/2-angle，后续作品为π/2+angle。
local function read(path)
    local f=assert(io.open(path,'rb'));local text=f:read('*a');f:close();return text:gsub('\r\n','\n')
end
lstg={};stage={current_stage={timer=0}};object={};OriginalStageVisual={}
object.Preserve=function() end;task={Clear=function() end}
function Class(base,definition) return setmetatable(definition or {},{__index=base}) end
ran={Float=function(_,a) return a end,Int=function(_,a) return a end}
local images,textures={},{}
function CheckRes(kind,name) return (kind=='img' and images[name]) or (kind=='tex' and textures[name]) end
function LoadTexture(name) textures[name]=true end
function LoadImage(name) images[name]={name=name} end
function FindResSprite(name) return images[name] end
function Color(...) return {...} end
function SetImageState() end
local draws={}
function Render(name,x,y,rot,sx,sy) draws[#draws+1]={name=name,x=x,y=y,rot=rot,sx=sx,sy=sy} end
function cos(a) return math.cos(a*math.pi/180) end
function sin(a) return math.sin(a*math.pi/180) end
local prefix=read('THlib/bullet/bullet.lua')
prefix=prefix:sub(1,assert(prefix:find('\n--------------------------',1,true))-1)
bullet={GetRenderRotation=assert(loadstring(prefix..'\nreturn render_rotation'))()}
dofile('THlib/anm/original.lua')
local A=OriginalANM
local V=dofile('THlib/bullet/visual_match.lua')
local checks=0
local function near(a,b) return math.abs(a-b)<1e-6 end
local function verify(draw,vm,game,nativeAngle)
    local px,py=3,5 -- 纹理局部坐标，Y向下。
    local c,s=math.cos(nativeAngle),math.sin(nativeAngle)
    local rx,ry
    if game==6 then rx,ry=px*draw.sx*c+py*draw.sy*s,-px*draw.sx*s+py*draw.sy*c
    else rx,ry=px*draw.sx*c-py*draw.sy*s,px*draw.sx*s+py*draw.sy*c end
    local r=draw.rot*math.pi/180
    local x=px*draw.sx*math.cos(r)+py*draw.sy*math.sin(r)
    local y=px*draw.sx*math.sin(r)-py*draw.sy*math.cos(r)
    assert(near(x,rx) and near(y,-ry),'绘制矩阵与原作不一致：'..game..'/'..vm.id)
    checks=checks+1
end
for _,fast in ipairs({false,true}) do
    lstg.AndroidRenderSprite=fast and function(resource,blend,x,y,rot,sx,sy)
        Render(resource.name,x,y,rot,sx,sy)
    end or nil
    for _,game in ipairs({6,7,8,95,10}) do
        for kind,profile in pairs(V.profiles[game]) do
            for color=1,V.color_count(game,kind) do
                for _,angle in ipairs({0,math.pi/2,math.pi,-math.pi/2,.37,-1.19}) do
                    local o={imgclass={native_game=game,native_type=kind,native_profile=profile},
                        x=15,y=30,rot=23,vx=math.cos(angle)*2,vy=-math.sin(angle)*2,ani=12,hscale=.75,vscale=1.25}
                    if game==6 then o.th06_angle=angle elseif game==8 then o.ex_angle=-angle end
                    V.reset_anm(o,game,kind,color)
                    local vm=o._native_anm
                    for _=1,3 do A.step(vm) end
                    local original=vm.rotation[3]
                    draws={};V.render_anm(o)
                    local draw=assert(draws[#draws],'主弹必须有可见精灵')
                    local z=vm.follow and (math.pi/2+(game==6 and -angle or angle)) or original
                    verify(draw,vm,game,z)
                    assert(o.x==15 and o.y==30 and o.rot==23 and vm.rotation[3]==original,'绘制不得改写弹道或VM状态')
                    if vm.follow then
                        -- 原作autoRotate直接赋值，不叠加脚本中的旧旋转角。
                        vm.rotation[3]=.7;draws={};V.render_anm(o);verify(draws[#draws],vm,game,z)
                    end
                end
            end
        end
    end
    for _,game in ipairs({6,7,8,95,10}) do
        local archive=game==6 and 'etama3' or (game==7 or game==8) and 'etama' or 'bullet'
        local vm=A.new(game,archive,0)
        if game==95 or game==10 then A.interrupt(vm,2);A.step(vm) end
        vm.follow=false;vm.rotation[3]=.83
        draws={};A.draw(vm,0,0,17)
        verify(assert(draws[#draws]),vm,game,.83)
        vm.follow=true;draws={};A.draw(vm,0,0,17)
        local expected=(game==6 and 1 or -1)*.83*180/math.pi+17
        assert(near(draws[#draws].rot,expected),'非子弹调用方的附加旋转语义应保持不变')
    end
    for _,game in ipairs({6,7,8,95,10}) do
        local kind=(game==95 or game==10) and 6 or 4
        local angle=.63
        local o={imgclass={native_game=game,native_type=kind,native_profile=V.profiles[game][kind]},
            x=0,y=0,rot=0,vx=math.cos(angle),vy=-math.sin(angle),ani=0,hscale=1,vscale=1,layer=-200}
        if game==6 then o.th06_angle=angle elseif game==8 then o.ex_angle=-angle end
        V.reset_anm(o,game,kind,2)
        local field=game==6 and 'th06_spawn' or game==7 and 'c_spawn_left' or game==8 and 'ex_spawn'
            or game==95 and 'th095_spawn_left' or 'th10_spawn_left'
        for _,left in ipairs({8,0}) do
            o[field]=left;V.sync_spawn(o);A.step(o._native_anm);draws={};V.render_anm(o)
            local vm=o._native_anm
            local z=vm.follow and math.pi/2+(game==6 and -angle or angle) or vm.rotation[3]
            verify(assert(draws[#draws]),vm,game,z)
        end
        assert(V.emit_despawn(o,false))
        draws={};o.class.render(o)
        local vm=o.vm
        local z=vm.follow and math.pi/2+(game==6 and -angle or angle) or vm.rotation[3]
        verify(assert(draws[#draws]),vm,game,z)
    end
    for _,game in ipairs({6,8}) do
        for _,angle in ipairs({0,90,180,270,33}) do
            local o={_native_laser_game=game,rot=angle,x=10,y=20,l1=0,l2=100,l3=0,w=8,alpha=1,index=2}
            draws={};assert(V.render_laser_anm(o))
            assert(near(draws[1].rot,angle+(game==6 and 90 or -90)),'激光必须使用本作旋转换算')
            assert(o.rot==angle and o.x==10 and o.y==20,'激光绘制不得改写判定方向或源点')
            checks=checks+1
        end
    end
end
print(('原作子弹方向检查通过：%d项；五作全部弹型/颜色、六向飞行、静态旋转、自动转向覆盖、激光及两条绘制路径'):format(checks))
