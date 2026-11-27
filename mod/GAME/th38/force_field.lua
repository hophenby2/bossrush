-- Basic 的敌机类型20实际选择 emy41；Enemy_lichang 并非普通敌机。
-- 颜色R/G控制太阳的世界缩放；阴影材质只读Alpha，光环另有闪烁/旋转组件。
local F={data=dofile('mod/GAME/th38/force_field_data.lua')}
local D=F.data
local images={}
local floatBox=require('ffi').new('float[1]')
local function f32(x) floatBox[0]=x;return tonumber(floatBox[0]) end
local function valid(o) return o and IsValid(o) end
function F.prepare()
    local old=GetResourceStatus();SetResourceStatus('global')
    for key,cfg in pairs(D.sprites) do
        local id='asl_force_field_'..key
        if not CheckRes('img',id) then
            LoadTexture(id,cfg.file);LoadImage(id,id,0,0,unpack(cfg.size))
            SetImageCenter(id,unpack(cfg.center))
            if RogueEncounter then RogueEncounter.checkpoint() end
        end
        images[key]=id
    end
    SetResourceStatus(old)
end
local Rings=Class(object,{
    init=function(o,s)
        o.field=s;o.group,o.layer=GROUP.GHOST,LAYER.ENEMY_BULLET+.2
        o.bound,o.colli=false,false
    end,
    frame=function(o) if not o.field.alive or o.field.c.closed then object.RawDel(o) end end,
    render=function(o)
        if not o.field.alive then return end
        for i=2,#D.nodes do F.draw(o.field,i) end
    end,
},true)
function F.init(s)
    F.prepare()
    s.c.forceFieldSerial=(s.c.forceFieldSerial or 0)+1
    s.field={sx=0,sy=0,seed=7919+s.birth+s.c.forceFieldSerial*104729,children={}}
    for i,cfg in ipairs(D.nodes) do
        local n={angle=math.deg(2*math.atan2(unpack(cfg.rotation))),alpha=cfg.color[4],scripts={}}
        for _,script in ipairs(cfg.scripts) do n.scripts[#n.scripts+1]={cfg=script,time=0} end
        s.field.children[i]=n
    end
    s.field.rings=New(Rings,s)
end
function F.clear(s)
    local rings=s.field and s.field.rings
    if valid(rings) then object.RawDel(rings) end
    if s.field then s.field.rings=nil end
end
function F.outside(s)
    local b=D.bounds
    return s.x<b[1] or s.x>b[2] or s.y<b[3] or s.y>b[4]
end
function F.contains(s,p)
    local field=s.field
    local inset=(p.A or p.a or 0)/48
    local radius=f32(D.radius)
    local rx=f32(f32(field.sx*radius)+inset)
    local ry=f32(f32(field.sy*radius)+inset)
    local dx,dy=f32(s.x-f32(p.x/48+4.5)),f32(s.y-f32(p.y/48-4.8))
    -- 原作先检查横纵边界，再用横轴半径做圆判定，不能改成普通敌机椭圆。
    return math.abs(dx)<rx and math.abs(dy)<ry and f32(rx*rx)>f32(f32(dx*dx)+f32(dy*dy))
end
local function consume(s,p)
    local scene=stage and stage.current_stage;local group=scene and scene.group
    if group and (group._name=='RogueTen' or group._name=='RogueTwo') and GameDrops and GameDrops.enabled() then
        GameDrops.drainBombGauge(p,D.drain,D.shield_unit)
        return
    end
    local state=NativePlayers and p.native_level==36 and NativePlayers.state()
    if state then
        local remaining=state.barrier-D.drain
        state.barrier=math.max(0,remaining)
        local source=p.unity_source and p.unity_source.Sincos
        if source then source.steam_5ring=false;source.jiejie_cengshu=NativePlayers.barriers(state) end
        if remaining>=0 then return end
    end
    -- 原作盾耗尽后才进入通常受击流程；无敌时间不阻止扣盾本身。
    if p.class and p.class.colli then p.class.colli(p,s.native) end
end
function F.step(s)
    local field=s.field
    field.sx,field.sy=f32(s.red*.01),f32(s.green*.01)
    for _,n in ipairs(field.children) do
        for _,script in ipairs(n.scripts) do
            local cfg,t=script.cfg,script.time
            if cfg.kind=='Tongyong_minganbianhua' and cfg.dont==0 and t>=cfg.time_start then
                local elapsed=t-cfg.time_start
                n.alpha=f32(f32((cfg.max-cfg.min)*.5)*sin(f32(360/cfg.zhouqi*elapsed)%360)+f32((cfg.max+cfg.min)*.5))
                if cfg.set_chaoxiang_in_min==1 and elapsed%cfg.zhouqi==math.floor(cfg.zhouqi*3/4) then
                    -- 仅供表现，不占用弹幕随机序列；原组件在最暗时改世界朝向。
                    field.seed=field.seed*48271%2147483647
                    n.angle=field.seed/2147483647*360-(s.rotation-90)
                end
            elseif cfg.kind=='Tongyong_xuanzhuan' then n.angle=f32(n.angle+cfg.zhuansu) end
            script.time=t+1
        end
    end
    if GameNet and GameNet.host() then
        for _,p in ipairs(GameNet.players) do if valid(p) and F.contains(s,p) then consume(s,p) end end
    elseif valid(player) and F.contains(s,player) then consume(s,player) end
end
function F.draw(s,index)
    local field=s.field;local cfg=D.nodes[index];local n=field.children[index]
    local sprite=D.sprites[cfg.sprite];local id=images[cfg.sprite]
    local alpha=index==1 and s.alpha/100 or n.alpha
    -- 发行版 grab减色经过SrcAlpha混合后等价于 dst - tex.rgb*tex.a*alpha。
    -- 使用原生反向减法即可保留阴影，无需每个太阳复制整屏纹理。
    SetImageState(id,index==1 and 'mul+rev' or 'mul+add',math.max(0,math.min(255,alpha*255)),255,255,255)
    local root=s.rotation-90;local cr,sr=cos(root),sin(root)
    local cn,sn=cos(n.angle),sin(n.angle);local scale=48/sprite.ppu
    local function point(x,y)
        local rx,ry=(x*cn-y*sn)*cfg.scale[1],(x*sn+y*cn)*cfg.scale[2]
        -- 根节点的初始缩放为零；首个FixedUpdate改为R/G，不能再次乘零。
        if index==1 then rx,ry=x,y end
        rx,ry=(rx*scale+cfg.position[1]*48)*field.sx,(ry*scale+cfg.position[2]*48)*field.sy
        return (s.x-4.5)*48+rx*cr-ry*sr,(s.y+4.8)*48+rx*sr+ry*cr
    end
    local l,t=-sprite.center[1],sprite.center[2]
    local r,b=l+sprite.size[1],t-sprite.size[2]
    local x1,y1=point(l,t);local x2,y2=point(r,t);local x3,y3=point(r,b);local x4,y4=point(l,b)
    Render4V(id,x1,y1,.5,x2,y2,.5,x3,y3,.5,x4,y4,.5)
end
return F
