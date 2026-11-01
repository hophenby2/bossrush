-- 原作移植的显示与回收：精灵、调色板和动画取原作 ANM；判定和运动独立维护。
local V = {}
if not OriginalANM then dofile('THlib/anm/original.lua') end
if not OriginalStageVisual then dofile('THlib/anm/stage_visual.lua') end
V.profiles = dofile('THlib/bullet/original_profiles.lua')
local A=OriginalANM
local body8={ [0]=0,1,2,3,4,5,6,7,8,9,25,106,107,108,109,110,111,112,113,114,115 }
local body95={ [0]=0,16,32,48,64,80,96,111,127,143,159,175,211,219,227,235,243,283,296,251,259,267,275,191 }
-- TH10.exe 0x72d70 的 27 项脚本表；type24 的脚本48与type1的脚本64不能互换。
local body10={ [0]=0,64,80,96,112,128,144,160,176,192,208,224,275,283,291,299,307,347,373,315,323,331,339,240,48,374,243 }
function V.color_count(game,kind)
    if game==6 then return kind==9 and 4 or kind>=6 and 8 or 16 end
    if game==7 then return kind==10 and 4 or kind>=7 and 8 or 16 end
    if game==8 then return kind==10 and 4 or ((kind>=7 and kind<=9) or kind==14 or kind==15 or kind>=18) and 8 or 16 end
    return kind==17 and 4 or (kind==18 or (game==10 and kind==25)) and 1 or kind==23 and 3
        or (kind>=12 and kind<=22) and 8 or 16
end
local function body_vm(game,kind,color)
    local archive=game==6 and (kind==9 and 'etama4' or 'etama3') or ((game==7 or game==8) and 'etama' or 'bullet')
    local id=game==6 and (kind==9 and 0 or kind) or game==7 and (kind==10 and 25 or kind) or game==8 and body8[kind]
        or game==95 and body95[kind]+color or game==10 and body10[kind]+color
    local v=A.new(game,archive,assert(id,'原作弹型缺失'))
    if game==6 or game==7 or game==8 then
        if not (game==6 and kind==7) then v.sprite=v.sprite+color end
    else A.interrupt(v,2);A.step(v) end
    return v
end
function V.reset_anm(o,game,kind,index)
    o._native_color=(index or 1)-1
    o._native_anm=body_vm(game,kind,o._native_color)
    o._native_spawn_started=false;o._native_anm_tick=nil
end
local function spawn_left(o,game)
    if game==6 then return o.th06_spawn or 0
    elseif game==7 then return o.c_spawn_left or 0
    elseif game==8 then return o.ex_spawn or o.alice_spawn_left or o.spawn_left or 0
    elseif game==95 then return o.th095_spawn_left or 0
    elseif game==10 then return o.tb and o.tb.spawn or 0 end
    return 0
end
function V.step_anm(o)
    local c=o.imgclass
    if not c.native_game or o._native_anm_tick==o.ani then return end
    o._native_anm_tick=o.ani
    local v=o._native_anm
    local left=spawn_left(o,c.native_game)
    if left>0 and not o._native_spawn_started then
        o._native_spawn_started=true
        if c.native_game==95 or c.native_game==10 then
            local phase=left<=8 and 7 or left<=15 and 8 or 9
            v=A.new(c.native_game,'bullet',(c.native_game==95 and body95 or body10)[c.native_type]+o._native_color)
            A.interrupt(v,phase);o._native_anm=v
        else
            local kind=c.native_type
            local id
            if c.native_game==6 then id=kind==9 and 2 or kind>=6 and 20 or (left<=10 and 17 or left<=16 and 18 or 19)
            else id=kind==(c.native_game==7 and 10 or 10) and 27 or kind>=7 and kind<=9 and 24
                    or (left<=10 and 21 or left<=16 and 22 or 23)
                if kind==0 then id=left<=10 and 18 or left<=16 and 19 or 20 end
                if c.native_game==8 and kind>=14 and (kind==14 or kind==15 or kind>=18) then id=24 end
            end
            v=A.new(c.native_game,v.data.archive,id)
            local col=o._native_color
            local small={ [0]=0,1,1,1,1,2,2,2,2,3,3,3,4,4,4,0 }
            local medium={ [0]=0,1,1,2,2,3,4,0 }
            v.sprite=v.sprite+(c.native_profile.h<=16 and small[col] or c.native_profile.h<=32 and medium[col] or col)
            o._native_anm=v
        end
    elseif left==0 and o._native_spawn_started then
        o._native_spawn_started=false
        if c.native_game==95 or c.native_game==10 then A.interrupt(v,2)
        else v=body_vm(c.native_game,c.native_type,o._native_color);o._native_anm=v end
    end
    A.step(v)
end
function V.render_anm(o)
    if not o._native_anm then return false end
    local v=o._native_anm
    -- 运动角由弹体状态机提供；不能使用引擎自动 navi 去改写 ECL 的逻辑角。
    local follow=o.imgclass.native_profile.follow
    v.follow=follow
    -- 原作随弹道绘制的角是 angle+π/2；原图朝上，换成向上的 Y 轴后需再减90度。
    A.draw(v,o.x,o.y,bullet.GetRenderRotation(o)-90,o.hscale,o.vscale,(o._a or 255)/255)
    return true
end
local native_styles = {}
function V.retire(o)
    o._original_silent_remove=true
    object.RawDel(o)
end
function V.native_style(game, kind, style)
    native_styles[game] = native_styles[game] or {}
    local bykind = native_styles[game]
    bykind[kind] = bykind[kind] or {}
    if bykind[kind][style] then return bykind[kind][style] end
    local mapped = Class(style, {native_profile=assert(V.profiles[game][kind]), native_game=game,
        -- 原作弹的逐帧速度由ECL负责，不能再被本项目Rank追加一段位移。
        init=function(o,index)
            style.init(o,index);o.rank_speed=false
            V.reset_anm(o,game,kind,index)
        end,
        native_type=kind, visual_style=style.visual_style or style,
        collision_style=style.collision_style or style, size=style.size,
        RenderFunc=style.RenderFunc, SetColorFunc=style.SetColorFunc}, true)
    bykind[kind][style]=mapped
    return mapped
end

-- TH07在折向/反弹期间允许连续出屏128帧；命令结束后倒数已积累的出屏帧。
-- 用原始精灵尺寸检查本帧积分后的坐标，关闭LuaSTG默认边界，避免它提前截断回程。
function V.th07_cull(o, delay, active)
    o.bound=false
    if delay~=0 then return end
    local p=o.imgclass.native_profile or V.profiles[7][o.th07_sprite or 0]
    local x,y=o.x+o.vx,o.y+o.vy
    local outside=x+p.w/2 < -192 or x-p.w/2 > 192 or y+p.h/2 < -224 or y-p.h/2 > 224
    if not outside then o.th07_out=0;return end
    local off=o.th07_out or 0
    if active then
        off=off+1
        if off>=128 then V.retire(o) end
    elseif off==0 then V.retire(o)
    else off=off-1 end
    o.th07_out=off
end
function V.finish_bullet(o)
    local game=o.imgclass.native_game
    local p=o.imgclass.native_profile
    if game==7 and not o.th07_cull_managed then
        V.th07_cull(o,0,false)
    elseif game==95 then
        -- 文花帖的helper用精灵全宽/高作余量，没有TH07的128帧宽限。
        local x,y=o.x+o.vx,o.y+o.vy
        if x+p.w<=-192 or x-p.w>=192 or y+p.h<=-224 or y-p.h>=224 then V.retire(o) end
    elseif game==10 and not o.tb then
        local left=o.th10_cull_delay or 10
        V.th10_cull(o,left,o.x+o.vx,o.y+o.vy)
        o.th10_cull_delay=math.max(0,left-1)
    end
end
function V.th10_cull(o,delay,x,y)
    o.bound=false
    local p=o.imgclass.native_profile
    -- TH10原始g_BulletCullTop=-64，另外三边为-192/192/448。
    if delay<=0 and (x+p.w/2<=-192 or x-p.w/2>=192 or y+p.h/2<=-224 or y-p.h/2>=288) then
        V.retire(o)
        return true
    end
end
local styles = {}
function V.style(original, visual)
    visual = visual.visual_style or visual
    if original == visual then return original end
    styles[original] = styles[original] or {}
    if styles[original][visual] then return styles[original][visual] end
    local mapped = Class(visual, {
        init = function(o, index)
            -- img 赋值会从资源重置判定，所以先取原样式的判定，换图后再恢复。
            local blend = o._blend
            original.init(o, index)
            local a, b = o.a, o.b
            o._blend = blend
            visual.init(o, index)
            o.a, o.b = a, b
        end,
        size = visual.size,
        RenderFunc = visual.RenderFunc,
        SetColorFunc = visual.SetColorFunc,
        visual_style = visual,
        collision_style = original.collision_style or original,
    }, true)
    styles[original][visual] = mapped
    return mapped
end

local lasers = {}
-- 原生 TH06/07/08 在预热/消散阶段把宽度误写入长度，只有中点短段能命中。
-- 参数单独登记，避免把这段判定画成整条有伤害光柱，或直接关掉消散段判定。
function V.native_laser(o, phase, timer, width, hitend, flags, offset)
    o._native_laser_geometry = { phase=phase, timer=timer, width=width,
        hitend=hitend or 0, flags=flags or 0, offset=offset or o._native_laser_start or 0 }
end
local function laser_width(o)
    local factor = o._visual_width_factor or 1
    if factor == 2 and o.w0 == 1.2 and o.w == o.w0 then factor = 1 end
    return o.w*factor
end
function V.laser_render_width(o)
    return laser_width(o)*7/16
end
function V.render_laser_anm(o)
    local game=o._native_laser_game or ((o.th06_state or o.th06_age) and 6)
    if game~=6 and game~=8 then return false end
    local len=o.l1+o.l2+o.l3
    if len<=0 or o.w<=0 then return true end
    local color=(o.index or 1)-1
    local kind=o.th06_sprite or o._native_laser_type or 0
    local key=game..':'..kind..':'..color
    if o._native_beam_key~=key then
        local archive=game==6 and 'etama3' or 'etama'
        local v=A.new(game,archive,(game==6 and 9 or 10)+kind)
        v.sprite=v.sprite+color;v.follow=true
        o._native_beam,o._native_beam_key=v,key
        local cap=A.new(game,archive,game==6 and 20 or 24)
        local colors={ [0]=0,1,1,1,1,2,2,2,2,3,3,3,4,4,4,0 }
        cap.sprite=(game==6 and 140 or 146)+(colors[color] or 0)
        cap.scale={1,1};cap.alpha={255};cap.interps={};cap.blend='mul+add'
        o._native_beam_cap=cap
    end
    local v=o._native_beam
    local spr=v.data.sprites[v.sprite]
    local width=game==6 and o.w*16/7 or laser_width(o)
    A.draw(v,o.x+cos(o.rot)*len/2,o.y+sin(o.rot)*len/2,o.rot-90,width/spr[4],len/spr[5],o.alpha)
    local offset=o.th06_startoff or o._native_laser_start or 0
    local speed=o.th06_speed or o._native_laser_speed or 0
    local phase=o._native_laser_geometry
    local flags=o.th06_flags or phase and phase.flags or 0
    local state=o.th06_state or phase and phase.phase or 1
    if (offset<16 or speed==0) and not (math.floor(flags/2)%2==1 and state==0) then
        local full=o.th06_width or o._native_laser_phase and o._native_laser_phase[3] or width
        local scale=full/10*(16-offset)/16
        if scale<=0 then scale=full/10 end
        A.draw(o._native_beam_cap,o.x,o.y,0,scale,scale)
    end
    return true
end
function V.laser_collision(o, callback)
    local p = o._native_laser_geometry
    local game = o._native_laser_game
    if not p then
        local phase = o._native_laser_phase
        p = {phase=phase and o[phase[1]] or 2, timer=phase and o[phase[2]] or 0,
            hitend=phase and phase[3] or 0,
            width=phase and phase[4] or laser_width(o),
            offset=o._native_laser_start or 0, flags=0}
        if game == 7 and o.pl_state then
            p.phase,p.timer,p.width,p.hitend = o.pl_state+1,o.pl_t,o.pl_lw,o.pl_hbEnd
        end
    end
    local x,y,l1,l2,l3,w,alpha,colli = o.x,o.y,o.l1,o.l2,o.l3,o.w,o.alpha,o.colli
    local length, start = l1+l2+l3, 0
    local drawWidth = laser_width(o)
    if o._native_laser_box then
        -- Enemy::CheckBulletPlayerCollision 先把敌人接触框除以1.5。
        -- 横斩只是借激光绘制；原生实体结束后没有激光的残留判定。
        start,length = length/6,length*2/3
        o.w,o.colli = p.width*2/3,colli and p.phase~=3
    elseif game == 95 then
        -- PhotoEffect.cpp：两端各去掉8px；直线型另有 width>40 的原生闸门。
        start,length = 8,math.max(0,length-16)
        o.w = drawWidth < 32 and drawWidth/2 or drawWidth-16
        o.colli = colli and length > 0 and (not o._native_laser_straight or drawWidth > 40)
    else
        o.w = p.width/2
        if p.phase ~= 2 and p.flags%2 == 0 then
            local short = math.max(0,drawWidth/2)
            start,length = (length-short)/2,short
        elseif game == 8 and p.offset > 0 then
            start,length = length*0.15,length*0.7
        end
    end
    if not o._native_laser_box and game ~= 95 and p.phase == 3 then o.colli = p.timer < p.hitend end
    if o._native_cancelled then o.colli=false end
    o.x,o.y = x+cos(o.rot)*start,y+sin(o.rot)*start
    o.l1,o.l2,o.l3,o.alpha = 0,length,0,1
    callback(o)
    o.x,o.y,o.l1,o.l2,o.l3,o.w,o.alpha,o.colli = x,y,l1,l2,l3,w,alpha,colli
end
function V.laser(base, game)
    lasers[base] = lasers[base] or {}
    local key = game or 0
    if lasers[base][key] then return lasers[base][key] end
    local function render(o)
        -- laser.render 在画图时读取 laser_render_width；不改写碰撞字段。
        base.render(o)
    end
    local mapped = Class(base, {
        init = function(o, ...)
            base.init(o, ...)
            o._native_laser_game = game
        end,
        render = render,
        frame=function(o)
            if o._native_cancel_scale then o.w=o.w*o._native_cancel_scale end
            base.frame(o)
        end,
        kill = function(o) V.cancel_laser(o,true) end,
        -- 原生状态机计时结束后的RawDel直接释放槽位，不追加THlib的30帧退场。
        del = function() end,
    }, true)
    -- Class 只继承六个回调。CyGrow 等协程入口仍从 class 表显式调用。
    for k,v in pairs(base) do
        if rawget(mapped,k) == nil then mapped[k] = v end
    end
    lasers[base][key] = mapped
    return mapped
end
function V.laser_protected(o)
    return o._native_laser_game==7 and math.floor((o.pl_flags or 0)/4)%2==1
end
function V.laser_drops(o,drop,force)
    if not force and V.laser_protected(o) then return end
    local game=o._native_laser_game or o._native_laser_managed
    local phase=o._native_laser_phase
    if (phase and game==8 and o[phase[1]]>=3) or (game==7 and o.pl_state and o.pl_state>=2)
        or (o.th06_state and o.th06_state>=2) or (o.th06_age and o.th06_age>=150) then return end
    local length=o.l1+o.l2+o.l3
    local first,step,last=0,32,length-0.001
    if game==95 or game==10 then first,step,last=6,12,length-6-0.001 end
    for r=first,last,step do
        local x,y=o.x+cos(o.rot)*r,o.y+sin(o.rot)*r
        -- TH10 LaserClear/Type1Clear只在场地外32px内产生道具。
        if game~=10 or (x+32>-192 and x-32<192 and y+32>-224 and y-32<224) then drop(x,y) end
    end
end
-- 原作消激光不拆成缺少寿命的新laser对象。TH08保留原类，直接进入自己的DESPAWNING。
function V.cancel_laser(o,drop,force)
    if o._native_cancelled then return end
    -- TH07 RemoveAllBullets保留flags4的光；符卡结算的强制清场另走force。
    if not force and V.laser_protected(o) then object.Preserve(o);return end
    o._native_cancelled=true
    if drop and item and item.obj and item.obj.faith_minor then
        V.laser_drops(o,function(x,y) New(item.obj.faith_minor,x,y) end,force)
    end
    local phase=o._native_laser_phase
    if phase and o._native_laser_game==8 then
        if o[phase[1]]<3 then
            local full=phase[4]/(o._visual_width_factor or 1)
            o._native_cancel_scale=full>0 and math.min(1,o.w/full) or 0
            o[phase[1]],o[phase[2]]=3,0
        end
        o.colli=false
        object.Preserve(o)
    elseif o.th06_state then
        if o.th06_state<2 then
            o.th06_width=o.th06_draw_width or o.th06_width
            o.th06_state,o.th06_timer=2,0
        end
        o.th06_hitend,o.colli=0,false
        object.Preserve(o)
    elseif o.th06_age then
        o.th06_age=math.max(150,o.th06_age)
        o.colli=false
        object.Preserve(o)
    else
        object.Del(o)
    end
end
OriginalBulletVisual = V
return V
