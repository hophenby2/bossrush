-- 对真实映射表和贴图资源验收：不缩放子弹、保留旧判定、激光显示与命中分开。
arg[1] = 'bullet-visuals'
local f = assert(io.open('tools/check_stage.lua', 'rb')); local setup = f:read('*a'); f:close()
assert(loadstring(setup:sub(1, assert(setup:find('if path == "--all" then', 1, true)) - 1)))()
local resources, textures, calls = {}, {}, {}
local function pngsize(path)
    local f = assert(io.open(path:gsub('\\', '/'), 'rb')); local h = f:read(24); f:close()
    local function n(i) local a,b,c,d = h:byte(i,i+3); return ((a*256+b)*256+c)*256+d end
    return n(17), n(21)
end
LoadTexture = function(name, path) textures[name] = { pngsize(path) } end
LoadImage = function(name, _, _, _, w, h, a, b, rect)
    resources[name] = { w=w, h=h, a=a or 0, b=b or a or 0, rect=rect or false, scale=1 }
end
LoadImageGroup = function(prefix, tex, x, y, w, h, cols, rows, a, b, rect)
    for i=1,cols*rows do LoadImage(prefix..i,tex,x,y,w,h,a,b,rect) end
end
LoadImageGroupFromFile = function(prefix, path, mip, cols, rows, a, b, rect)
    LoadTexture(prefix,path); local z=textures[prefix]
    LoadImageGroup(prefix,prefix,0,0,z[1]/cols,z[2]/rows,cols,rows,a,b,rect)
end
CopyImage = function(name, other)
    local copy={};for k,v in pairs(assert(resources[other],other)) do copy[k]=v end;resources[name]=copy
end
EnumRes2 = function(kind) local out={};if kind=='img' then for k,v in pairs(resources) do if not v.animation then out[#out+1]=k end end end;return out end
SetImageCenter = function() end
SetAnimationCenter = function() end
SetAnimationState = function() end
SetImageScale = function(name, scale) assert(resources[name],name).scale=scale end
SetAnimationScale = SetImageScale
LoadAnimation = function(name,tex,x,y,w,h,cols,rows,interval,a,b,rect)
    LoadImage(name,tex,x,y,w,h,a,b,rect); resources[name].animation=true
end
Render = function(name,x,y,rot,h,v) calls[#calls+1]={name=name,x=x,y=y,rot=rot,h=h or 1,v=v or h or 1} end
RenderAnimation = function(name,ani,x,y,rot,h,v)
    assert(type(ani)=='number','动画弹与灰色拖影需要有效动画帧号')
    Render(name,x,y,rot,h,v)
end
CheckRes = function(kind,name) return kind=='img' and resources[name]~=nil end
local fields={class=true,img=true,x=true,y=true,rot=true,hscale=true,vscale=true,a=true,b=true,rect=true,vx=true,vy=true,dx=true,dy=true,ani=true,timer=true,omiga=true}
New = function(class,...)
    local attrs={class=class,x=0,y=0,rot=0,hscale=1,vscale=1,a=0,b=0,rect=false,vx=0,vy=0,dx=0,dy=0,timer=0,ani=0,omiga=0}
    local o=setmetatable({_live=true},{
        __index=function(_,k) if fields[k] then return attrs[k] end end,
        __newindex=function(t,k,v)
            if fields[k] then
                attrs[k]=v
                if k=='img' then local r=assert(resources[v],v);attrs.a,attrs.b,attrs.rect=r.a,r.b,r.rect end
            else rawset(t,k,v) end
        end,
    })
    class.init(o,...); return o
end
IsValid=function(o) return o~=nil and rawget(o,'_live')~=false end
object.RawDel=function(o) o._live=false end
Include=function() end
dofile('THlib/lib/Ltask.lua'); dofile('THlib/bullet/bullet.lua'); dofile('THlib/bullet/bulletStyle.lua')
dofile('THlib/bullet/visual_match.lua'); dofile('THlib/laser/laser.lua')
local checks=0
local function check(v,label) assert(v,label); checks=checks+1 end
local function near(a,b) return math.abs(a-b)<1e-7 end
local roots, actual_lasers = {}, {}
boss.card.add=function(parts) for _,p in ipairs(parts) do roots[#roots+1]=p[1] end end
local function find(name)
    local seen={}
    local function visit(v)
        if (type(v)~='function' and type(v)~='table') or seen[v] then return end
        seen[v]=true
        if type(v)=='function' then
            for i=1,100 do
                local n,u=debug.getupvalue(v,i);if not n then break end
                if n==name then return u end
                local found=visit(u);if found then return found end
            end
        else
            for _,u in pairs(v) do local found=visit(u);if found then return found end end
        end
    end
    return assert(visit(roots),name)
end
local expected={
    th31={[2]=grain_a,[4]=arrow_small,[5]=grain_b,[6]=arrow_big_c,[8]=butterfly,[9]=knife,[16]=grain_b,[17]=grain_c,[18]=gun_bullet,[19]=water_drop,[20]=knife},
    th33={[3]=grain_a,[10]=grain_c,[14]=knife,[18]=water_drop,[21]=knife},
    th34={[2]=grain_a,[9]=knife},
    th35={[3]=grain_a,[10]=grain_c,[14]=knife,[18]=water_drop,[21]=knife,[25]=water_drop,[26]=grain_a},
}
local mapper_names={th31='style_of',th33='sg_style',th34='th07_style',th35='t10_style'}
for _,game in ipairs({'th31','th33','th34','th35'}) do
    roots={};dofile('mod/GAME/'..game..'.lua');local mapper=find(mapper_names[game])
    if game=='th31' then actual_lasers.th08=find('lw209_laser') end
    if game=='th35' then actual_lasers.th10=find('th10_laser') end
    if game=='th33' then
        local fixed=find('sg_visual')
        local mapped=fixed(butterfly,18)
        local old=NewSimpleBullet(butterfly,2,0,0,1,0,false,0,false)
        local changed=NewSimpleBullet(mapped,2,0,0,1,0,false,0,false)
        check(mapped.visual_style==water_drop and changed.a==old.a and changed.b==old.b,
            'TH33 固定调用点换图时，保留该调用原来的蝶形判定，不能误套全局 type18 判定')
        local parts=find('sg_parts')
        check(parts(mapped)==mapped,'TH33 样式类本身不能被误认为 type 描述数组')
        local body,t=parts(mapper(3));check(body.visual_style==grain_a and t==3,'TH33 描述数组仍只查一次色表')
    end
    for t,visual in pairs(expected[game]) do
        local mapped=mapper(t);if game=='th33' then mapped=mapped[1] end
        check(mapped.visual_style==visual,game..' type'..t..' 选用默认大小接近的样式')
        local old=assert(mapped.collision_style)
        for color=1,16 do
            local original=NewSimpleBullet(old,color,0,0,1,0,false,0,false)
            local changed=NewSimpleBullet(mapped,color,0,0,1,0,false,0,false)
            check(near(changed.a,original.a) and near(changed.b,original.b) and changed.rect==original.rect,
                game..' 保留既有碰撞尺寸及形状')
            check(changed.hscale==1 and changed.vscale==1,game..' 不额外缩放子弹')
            calls={};bullet.render(changed)
            check(#calls==1 and calls[1].name==changed.img and calls[1].h==1 and calls[1].v==1,game..' 使用样式默认渲染尺寸')
            if visual==water_drop or visual==gun_bullet then
                changed.graysmear={{img=changed.img,x=0,y=0,rot=0,hscale=1,vscale=1,alpha=80}}
                calls={};bullet.render(changed)
                check(#calls==2 and calls[1].h==1 and calls[1].v==1,game..' 动画样式的灰色拖影也使用默认尺寸和正确帧号')
            end
            bullet.ChangeImage(changed,mapped,16)
            local gray=NewSimpleBullet(old,16,0,0,1,0,false,0,false)
            check(near(changed.a,gray.a) and near(changed.b,gray.b),game..' 飞行中换色/换图仍保留原判定')
        end
    end
end
-- 接收真实 laser.frame 的命中回调，用矩形内外两点校验宽度和轴向裁剪。
local hits=0
player={x=0,y=0,grazer={a=0,class={colli=function() end}},class={colli=function() hits=hits+1 end}}
local function ray(game,full,factor,start,straight)
    local cls=OriginalBulletVisual.laser(laser,game)
    local o=New(cls,1,0,0,0,0,100,0,full/(factor or 1),0,0)
    o.w=full/(factor or 1);o.alpha=1;o.colli=true;o.bound=false
    o._visual_width_factor=factor;o._native_laser_start=start;o._native_laser_straight=straight
    return o
end
for _,game in ipairs({7,8,95}) do
    local o=ray(game,16)
    check(rawget(o.class,'CyGrow')==laser.CyGrow and rawget(o.class,'_TurnOn')==laser._TurnOn,
        '真实 Class 只复制六个回调，代理类必须显式保留激光静态方法')
    player.x,player.y=50,3.9;hits=0;o.class.frame(o);check(hits==1,'原作 16px 光束命中半宽 4px：内点命中')
    player.y=4.1;hits=0;o.class.frame(o);check(hits==0,'原作光束判定外点不命中')
    calls={};o.class.render(o)
    local middle=calls[2];local g=resources[middle.name]
    check(near(g.h*g.scale*middle.v,16),'激光显示全宽 16px')
    check(o.w==16 and o.w0==16,'渲染后不污染碰撞宽度和最大宽度')
end
local half=ray(8,16,2)
player.x,player.y=50,3.9;hits=0;half.class.frame(half);check(hits==1,'已减半的 TH31 激光不重复减半')
player.y=4.1;hits=0;half.class.frame(half);check(hits==0,'TH31 半宽口径仍与原版一致')
local shifted=ray(8,16,nil,64)
player.x,player.y=10,0;hits=0;shifted.class.frame(shifted);check(hits==0,'起点偏移正数时，原作两端各裁去 15%')
player.x=20;hits=0;shifted.class.frame(shifted);check(hits==1,'原作中间 70% 保持有判定')
local th07shifted=ray(7,16,nil,64)
player.x=10;hits=0;th07shifted.class.frame(th07shifted);check(hits==1,'TH07 不套用 TH08 的 70% 长度规则')
local straight=ray(95,16,nil,0,true)
player.x,player.y=50,0;hits=0;straight.class.frame(straight);check(hits==0,'TH095 ins145 保留原版 width>40 的判定闸')
for _,game in ipairs({7,8}) do
    local o=ray(game,16)
    if game==7 then o.pl_state,o.pl_t,o.pl_lw,o.pl_hbEnd=2,1,16,20
    else o._native_laser_phase={'phase','clock',20,16};o.phase,o.clock=3,1 end
    o.colli=false;o.w=8
    player.x,player.y=10,0;hits=0;o.class.frame(o);check(hits==0,'收束只保留中点小矩形，不能整条仍有判定')
    player.x,player.y=50,3.9;hits=0;o.class.frame(o);check(hits==1,'原作收束期的中点判定不能被完全删掉')
    if game==7 then o.pl_t=21 else o.clock=21 end
    hits=0;o.class.frame(o);check(hits==0,'原作 hitboxEndDelay 到点关闭中点判定')
end
local wide95=ray(95,64)
player.x,player.y=50,23.9;hits=0;wide95.class.frame(wide95);check(hits==1,'TH095 大于32的宽激光使用 width−16 的判定全宽')
player.y=24.1;hits=0;wide95.class.frame(wide95);check(hits==0,'TH095 宽光束外点不命中')
local box=ray(7,32);box._native_laser_box=true
player.x,player.y=10,12;hits=0;box.class.frame(box);check(hits==1,'敌人矩形斩击不套用激光的半宽或中点裁剪')
local live=New(actual_lasers.th08,0,0,0)
player.x,player.y=300,2.4
for _=1,111 do live.class.frame(live) end
hits=0;live.class.frame(live);check(hits==1,'真实 TH31 卡209 满宽期命中半宽2.5px')
player.y=2.6;hits=0;live.class.frame(live);check(hits==0,'真实 TH31 卡209 满宽期外点不命中')
for _=1,50 do live.class.frame(live) end
player.x,player.y=10,0;hits=0;live.class.frame(live);check(hits==0,'真实 TH31 卡209 收束期不留下整根判定')
player.x=300;hits=0;live.class.frame(live);check(hits==1,'真实 TH31 卡209 收束期恢复原作中点小判定')
local wide10=New(actual_lasers.th10,0,0,13,1,0,128,128,0,0,46)
player.x,player.y=64,7.4;hits=0;wide10.class.frame(wide10);check(hits==1,'TH35 原作宽46激光命中半宽7.5px')
player.y=7.6;hits=0;wide10.class.frame(wide10);check(hits==0,'TH35 宽激光碰撞公式保持原版')
print(('子弹映射与激光尺寸回归通过：%d 项'):format(checks))
