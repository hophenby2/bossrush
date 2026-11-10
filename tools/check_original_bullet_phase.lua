-- 按TH07/08原作VM规则检查妖梦白箭头和铃仙停弹朝向，不改运动状态。
arg[1] = 'bullet-visuals'
local f = assert(io.open('tools/check_stage.lua', 'rb')); local setup = f:read('*a'); f:close()
assert(loadstring(setup:sub(1, assert(setup:find('if path == "--all" then', 1, true)) - 1)))()
-- 原作音效现为按需载入；本组检查只验证逻辑/绘制。
LoadSound=function() end
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
local collecting
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
    class.init(o,...)
    if collecting then collecting[#collecting+1]=o end
    return o
end
IsValid=function(o) return o~=nil and rawget(o,'_live')~=false end
object.RawDel=function(o) o._live=false end
Include=function() end
dofile('THlib/lib/Ltask.lua'); dofile('THlib/bullet/bullet.lua'); dofile('THlib/bullet/bulletStyle.lua')
dofile('THlib/bullet/visual_match.lua'); dofile('THlib/laser/laser.lua')
local checks=0
local function check(v,label) assert(v,label); checks=checks+1 end
local function near(a,b) return math.abs(a-b)<1e-7 end
local visual=OriginalBulletVisual
local slowArrow=NewSimpleBullet(visual.native_style(7,6,arrow_big_c),2,0,0,2,0,false,0,false)
local arrowVM,arrowSprite=slowArrow._native_anm,slowArrow._native_anm.sprite
slowArrow.own_gray=true;visual.render_anm(slowArrow)
check(calls[#calls].name==arrowVM.data.sprites[arrowSprite-slowArrow._native_color+15].img,
    '妖梦缓时使用原作白色箭头精灵')
check(slowArrow._native_anm==arrowVM and arrowVM.sprite==arrowSprite,'缓时换色不重开动画或污染弹型状态')
slowArrow.own_gray=false;visual.render_anm(slowArrow)
check(calls[#calls].name==arrowVM.data.sprites[arrowSprite].img,'恢复速度同时恢复原箭头颜色')
-- 原作按sprite96..111筛选，不能把type4的小箭头误认成type6箭头。
local smallArrow=NewSimpleBullet(visual.native_style(7,4,arrow_small),2,0,0,2,37,false,0,false)
smallArrow.own_gray=true;visual.render_anm(smallArrow)
check(calls[#calls].name==smallArrow._native_anm.data.sprites[smallArrow._native_anm.sprite].img,
    '妖梦变白不改sprite64..79的小箭头')
slowArrow.own_gray=true;slowArrow.c_spawn_left=10;visual.render_anm(slowArrow)
check(calls[#calls].name==slowArrow._native_anm.data.sprites[slowArrow._native_anm.sprite].img,
    '缓时期间出生动画保持原色')
slowArrow.c_spawn_left=0;visual.render_anm(slowArrow)
check(calls[#calls].name==slowArrow._native_anm.data.sprites[111].img,
    '缓时指令命中出生中的主弹，出生结束仍显示白箭头')
slowArrow.own_gray=false;visual.render_anm(slowArrow)
check(calls[#calls].name==slowArrow._native_anm.data.sprites[arrowSprite].img,
    '出生期间换白也能恢复进入缓时前的颜色')
-- TH08 Draw会保存上次写入VM的朝向；停弹、隐藏和淡入不能丢rot。
for _,angle in ipairs({-147,0,37,165}) do
    local reisen=NewSimpleBullet(visual.native_style(8,6,arrow_big_c),3,0,0,2,angle,false,0,false)
    reisen.ex_angle=math.rad(angle)
    visual.render_anm(reisen)
    local before=calls[#calls].rot
    visual.reisen_phase(reisen,0)
    reisen.ex_vx,reisen.ex_vy,reisen.vx,reisen.vy=0,0,0,0
    reisen.dx,reisen.dy=0,0
    for frame=1,3 do
        reisen.ani=frame;visual.step_anm(reisen);visual.render_anm(reisen)
        check(near(calls[#calls].rot,before),'铃仙type0停弹保留冻结前的VM旋转：'..angle)
    end
    visual.reisen_phase(reisen,2,15);reisen.ex_angle=math.rad(angle+13);visual.render_anm(reisen)
    check(near(calls[#calls].rot,angle+13-90),'铃仙type2淡入按原作继续更新朝向')
    visual.reisen_phase(reisen,1);visual.render_anm(reisen)
    check(near(calls[#calls].rot,angle+13-90),'铃仙恢复实体时朝向连续')
end
-- 使用TH34的真实ExIns入口，验证一念无量劫factor=1也换白。
dofile('mod/GAME/th34.lua')
local C=_editor_class.TH34
local pool
for i=1,20 do
    local name,value=debug.getupvalue(C.th07_set_speed,i)
    if name=='pool4' then pool=value;break end
end
check(pool~=nil,'缓时入口使用本关真实弹池')
local existing=NewSimpleBullet(visual.native_style(7,6,arrow_big_c),5,0,0,2,37,false,0,false)
local small=NewSimpleBullet(visual.native_style(7,4,arrow_small),5,0,0,2,37,false,0,false)
existing.th07_sprite,small.th07_sprite=6,4
pool[#pool+1],pool[#pool+2]=existing,small
ObjList=function() return function() end end
local owner={};lstg.var.timeslow=1
local vx,vy,rot=existing.vx,existing.vy,existing.rot
C.th07_set_speed(owner,1)
visual.render_anm(existing)
check(lstg.var.timeslow==1 and existing.own_gray and not small.own_gray,
    '一念无量劫ExIns10(1)只给既存type6箭头换白')
check(calls[#calls].name==existing._native_anm.data.sprites[111].img,
    '不减速变白实际绘制原作sprite111')
local later=NewSimpleBullet(visual.native_style(7,6,arrow_big_c),5,0,0,2,37,false,0,false)
check(not later.own_gray,'指令后新生子弹不受之前的换白影响')
C.th07_restore_speed(owner)
check(lstg.var.timeslow==1 and not existing.own_gray and existing.vx==vx and existing.vy==vy and existing.rot==rot,
    '一念无量劫恢复颜色，全程保持弹速和逻辑朝向')
lstg.var.timeslow=4;C.th07_set_speed(owner,3)
check(lstg.var.timeslow==3 and existing.own_gray and existing.vx==vx and existing.vy==vy,
    '普通缓时换白，不重复缩小原有速度')
C.th07_restore_speed(owner)
check(lstg.var.timeslow==4 and not existing.own_gray,'缓时结束恢复之前的时间倍率和箭头颜色')
print('铃仙停弹/淡入朝向、妖梦缓时及一念无量劫白箭头检查通过：'..checks)
