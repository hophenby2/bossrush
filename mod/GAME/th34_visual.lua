-- 妖妖梦原生发弹源和段式激光。尺寸/动画来自etama、stg6enm、stg8enm的ANM，
-- 状态切换照BulletManager.cpp:1124..1248；拖尾绘制/碰撞照EnemyManager，不改变发弹参数。
local N = {}
local tex = 'th34_native'
LoadTexture(tex, 'Resources/System/th34_native.png')
for i=0,15 do
    LoadImage('th34_laser0_'..i,tex,i*16,0,16,14)
    LoadImage('th34_laser1_'..i,tex,i*16,16,16,16)
    -- etama脚本12/13与10/11使用同一精灵，但保持普通混合；梅露兰非符使用这两种。
    LoadImage('th34_laser2_'..i,tex,i*16,0,16,14)
    LoadImage('th34_laser3_'..i,tex,i*16,16,16,16)
end
for i=0,4 do LoadImage('th34_orb_'..i,tex,i*32,32,30,30) end
LoadImage('th34_source_circle',tex,192,32,64,64)
LoadImage('th34_source_spirit',tex,0,80,48,16)
local orb_index={0,1,1,1,1,2,2,2,2,3,3,3,4,4,4,0}
-- ECL的零等待不让出一帧；例如同一时间轴位置连续生成的敌机。
function N.task_api(scheduler)
    return setmetatable({Wait=function(n)
        if n~=nil and n<=0 then return end
        return scheduler.Wait(n)
    end},{__index=scheduler})
end
-- 道中敌机也先RunEcl(0)；独立年龄不借用LuaSTG尚未递增的timer。
function N.wrap_road_actor(cls)
    local init,frame=cls.init,cls.frame
    cls.init=function(o,...)
        o.th07_road_age=0
        init(o,...)
        if not IsValid(o) or o.status=='del' or o.status=='kill' then return end
        local x,y=o.x,o.y
        frame(o)
        if not IsValid(o) or o.status=='del' or o.status=='kill' then return end
        o.th07_road_position=nil
        o.x,o.y=x,y
        o.th07_road_age=1
    end
    cls.frame=function(o)
        frame(o)
        if not IsValid(o) or o.status=='del' or o.status=='kill' then return end
        local p=o.th07_road_position
        o.th07_road_position=nil
        if p then o.x,o.y=p[1],p[2] end
        o.th07_road_age=o.th07_road_age+1
    end
    cls[1],cls[3]=cls.init,cls.frame
end
function N.road_position(o,x,y)
    o.th07_road_position={x,y}
end
function N.road_interval(o,n)
    if n<=0 then return 0 end
    local low=math.floor(n/5)
    local scaled=(o.th07_rank or 16)*(-2*low)/32
    return n+math.ceil(scaled)+low -- C++整数除法向零截断。
end
function N.source(o,kind)
    o.th07_source_kind,o.th07_source_start=kind,o.ani
    if kind=='spirit' then
        if not o._original_actor then
            OriginalStageVisual.bind_source(o,7,'ecldata6:53')
            o._original_visual_origin=o.timer
        end
        o.th07_source_history={}
        o._inf_graze=true -- 原作isProjectile在每6帧的接触检查中可再次擦弹
    end
end
function N.circle_script(o)
    N.source(o,'circle')
    task.Wait(120)
end
-- SET_TRAIL 的历史长度、判定长度和采样间隔分别独立；不借用激光对象的直线判定。
function N.trail(o,archive,script,count,collision_count,step,width,height)
    OriginalStageVisual.actor(o,7,archive,script)
    o._original_explicit=true
    o.th07_trail={history={},count=count,collision_count=collision_count,step=step or 1,
        width=width or 8,height=height or width or 8}
    o._inf_graze=true
    o.th07_trail_x,o.th07_trail_y=o.x,o.y
end
function N.interrupt(o,label)
    OriginalANM.interrupt(o._original_actor.vm,label)
end
-- 爱丽丝的人偶把体术和受弹开关分开：不可受弹的人偶仍可能撞到自机。
-- 对象仍走 enemy 的受击入口；手动体术沿用原作24×24框及碰撞扣10点原始血量。
function N.doll_interaction(o,contact,hittable)
    o.group,o.colli,o.protect=GROUP.NONTJT,hittable,not hittable
    o.th07_contact_box=contact and {24,24} or nil
end
function N.doll(o,script,life,spell,contact,hittable)
    OriginalStageVisual.actor(o,7,'stg3enm',script)
    o._original_explicit,o.th07_doll=true,true
    o._original_collision_game,o._original_damage_box=7,{24,24}
    o.a,o.b,o.rect=12,12,true
    o.hp=life
    OriginalBalance.unit(o,7,spell)
    N.doll_interaction(o,contact,hittable)
end
function N.trail_outside(o)
    local h=o.th07_trail.history
    local tail=h[#h]
    local s=OriginalANM.sprite_resource(o._original_actor.vm)
    -- GameManager::IsInBounds 使用未缩放的精灵全宽高，场地为384×448。
    local hw,hh=s[4]/2,s[5]/2
    local function outside(p) return p.x < -192-hw or p.x > 192+hw or p.y < -224-hh or p.y > 224+hh end
    return tail and outside(o) and outside(tail)
end
local function record_trail(o)
    local tr=o.th07_trail
    if tr.tick==o.ani then return end
    tr.tick=o.ani
    local dx,dy=o.x-o.th07_trail_x,o.y-o.th07_trail_y
    o.th07_trail_x,o.th07_trail_y=o.x,o.y
    local angle=tr.angle or 0
    if dx~=0 or dy~=0 then angle=math.atan2(dy,dx) end
    tr.angle=angle
    table.insert(tr.history,1,{x=o.x,y=o.y,a=angle})
    tr.history[tr.count+1]=nil
    local function check(p)
        if not p or not IsValid(p) then return end
        local function node(v)
            local dx,dy=math.abs(p.x-v.x),math.abs(p.y-v.y)
            if dx<=tr.width/3+(p.A or p.a or 0) and dy<=tr.height/3+(p.B or p.b or 0) then p.class.colli(p,o) end
            if o.timer%6==0 and p.grazer and dx<=tr.width/1.4+20 and dy<=tr.height/1.4+20 then
                p.grazer.class.colli(p.grazer,o)
            end
        end
        node(tr.history[1])
        for j=2,tr.collision_count,6 do if tr.history[j] then node(tr.history[j]) end end
    end
    if GameNet then GameNet.forEachPlayer(check) else check(player) end
end
local function draw_trail(o)
    local tr,v=o.th07_trail,o._original_actor.vm
    if not v.visible or not v.sprite then return end
    local s=OriginalANM.sprite_resource(v)
    if lstg.SetTextureSamplerState then lstg.SetTextureSamplerState(s.tex,'linear+wrap') end
    local tw,th=GetTextureSize(s.tex)
    local h,n=tr.history,#tr.history
    local count=math.floor((n-1)/tr.step)+1
    if count<2 then return end
    local color=Color(v.alpha[1],v.color[1],v.color[2],v.color[3])
    local function vertex(k)
        local i=1+k*tr.step
        local p,a=h[i],h[i].a
        if i>1 then a=h[i-1].a+((a-h[i-1].a+math.pi)%(2*math.pi)-math.pi)/2 end
        local half=v.scale[2]*s[5]/2
        local nx,ny=-math.sin(a)*half,math.cos(a)*half
        local u=s[2]+s[4]*(1-k/(count-1))+v.u*tw
        local y=s[3]+v.v*th
        return {p.x+nx,p.y+ny,.5,u,y,color},{p.x-nx,p.y-ny,.5,u,y+s[5],color}
    end
    for k=0,count-2 do
        local a,b=vertex(k)
        local c,d=vertex(k+1)
        RenderTexture(s.tex,v.blend,a,c,d,b)
    end
end
-- ECL138必须独立于主ANM选择保留；不能只给少数手写发射器补拖尾。
OriginalStageVisual.adapters[7]={
    event=function(o,c)
        if c[2]==138 then
            if c[3]==0 then o.th07_trail=nil;return end
            local box=o._original_contact_box or o._original_damage_box or {8,8}
            o.th07_trail={history={},flags=c[3],count=c[4],collision_count=c[5],step=c[6],
                width=box[1],height=box[2]}
            o._original_trail_source=true
            o.th07_trail_x,o.th07_trail_y=o.x,o.y
            o._inf_graze=true
        elseif c[2]==120 then o._original_rotate_with_movement=c[3]~=0
        elseif c[2]==150 and o._original_actor then o._original_actor.vm.rotation[3]=c[3] end
    end,
    tick=function(o) if o.th07_trail then record_trail(o) end end,
    draw=function(o)
        if not o.th07_trail then return false end
        draw_trail(o);return true
    end,
}
function N.record_source(o)
    if o._original_actor then OriginalStageVisual.tick(o) end
    if o.th07_trail then record_trail(o);return end
    if o.th07_contact_box then
        -- Enemy::CheckBulletPlayerCollision 将敌机全宽高除以1.5，再与自机方框相交。
        local box=o.th07_contact_box
        local function contact(p)
            if p and IsValid(p) and math.abs(p.x-o.x)<=box[1]/3+(p.A or p.a or 0)
                and math.abs(p.y-o.y)<=box[2]/3+(p.B or p.b or 0) then
                if p.class.colli(p,o) then o.hp=o.hp-10*(o._original_hp_scale or 1) end
            end
        end
        if GameNet then GameNet.forEachPlayer(contact) else contact(player) end
    end
    if o.th07_source_kind~='spirit' then return end
    local h=o.th07_source_history
    table.insert(h,1,{x=o.x,y=o.y,a=(o.th07_source_angle or 0)*math.pi/180})
    if #h>48 then h[49]=nil end
    -- sub53的hitbox为8×8；原作除以1.5后当全宽高使用。拖尾在1/7/13帧前各查一次。
    local function collide(p)
        local function node(v)
            local dx,dy=math.abs(p.x-v.x),math.abs(p.y-v.y)
            if dx<=8/3+(p.A or p.a or 0) and dy<=8/3+(p.B or p.b or 0) then
                p.class.colli(p,o)
            end
            if o.timer%6==0 and p.grazer and dx<=8/1.4+20 and dy<=8/1.4+20 then
                p.grazer.class.colli(p.grazer,o)
            end
        end
        node(h[1])
        for j=2,14,6 do if h[j] then node(h[j]) end end
    end
    if GameNet then GameNet.forEachPlayer(collide) else collide(player) end
end
function N.render_source(o)
    if o.th07_trail then draw_trail(o);return end
    if OriginalStageVisual.draw(o) then return end
    local t=o.ani-(o.th07_source_start or 0)
    if o.th07_source_kind=='circle' then
        SetImageState('th34_source_circle','mul+add',255,255,255,255)
        Render('th34_source_circle',o.x,o.y,-(t+1)*3)
    elseif o.th07_source_kind=='spirit' then
        -- SET_TRAIL(25,48,16,1)：48帧宽32的带状拖尾，flag16隐藏头部，不能只画一个灵体。
        local h=o.th07_source_history
        local n=#h
        local color=Color(255,255,255,255)
        local function vertex(i)
            local p=h[i]
            local a=p.a
            if i>1 then
                local d=(p.a-h[i-1].a+math.pi)%(2*math.pi)-math.pi
                a=h[i-1].a+d/2
            end
            local nx,ny=-math.sin(a)*16,math.cos(a)*16
            local u=48*(1-(i-1)/(n-1))
            return {p.x+nx,p.y+ny,0.5,u,80,color},{p.x-nx,p.y-ny,0.5,u,96,color}
        end
        for i=1,n-1 do
            local a,b=vertex(i)
            local c,d=vertex(i+1)
            RenderTexture(tex,'',a,c,d,b)
        end
    end
end
function N.sync_laser(o)
    local a,d=o.pl_ang,o.pl_eOff-o.pl_sOff
    o.x,o.y=o.pl_x+math.cos(a)*o.pl_sOff,o.pl_y+math.sin(a)*o.pl_sOff
    o.rot=a*180/math.pi
    o.l1,o.l2,o.l3=0,math.max(0,d),0
    o.w0,o.w=o.pl_lw,o.pl_w
end
function N.init_laser(o,s)
    o.pl_sprite,o.pl_color=s.sprite or 0,s.color or s.spr or 4
    o.pl_hide=s.hide and true or false
    o.pl_alpha=255
    o.pl_state=o.pl_tStart==0 and 1 or 0
    o.pl_w=o.pl_lw
    if o.pl_state==0 then
        if o.pl_flags%2==1 then o.pl_alpha=0 else o.pl_w=1.2 end
    end
    N.sync_laser(o)
end
function N.step_laser(o)
    o.pl_eOff=o.pl_eOff+o.pl_spd
    if o.pl_sLen<o.pl_eOff-o.pl_sOff then o.pl_sOff=o.pl_eOff-o.pl_sLen end
    o.pl_sOff=math.max(0,o.pl_sOff)
    local t,full=o.pl_t,o.pl_lw
    local fade=o.pl_flags%2==1
    local entered,remove_after=o.pl_state,false
    o.pl_w=full
    if o.pl_state==0 then
        if fade then o.pl_alpha=math.min(255,t*255/math.max(1,o.pl_tStart))
        else
            o.pl_w=o.pl_tStart-math.min(o.pl_tStart,30)<t and t*full/math.max(1,o.pl_tStart) or 1.2
        end
        o.colli=t>=o.pl_hbStart
        if t>=o.pl_tStart then o.pl_state,t=1,0 end
    end
    if o.pl_state==1 then
        o.colli=true
        if t>=o.pl_dur then
            o.pl_state,t=2,0
            if o.pl_tEnd==0 then remove_after=true end
        end
    end
    if o.pl_state==2 then
        -- 原作flags&1的收束分支仍使用startTime作除数，且alpha从0上升，照实保留。
        if fade then o.pl_alpha=math.min(255,t*255/math.max(1,o.pl_tStart))
        else o.pl_w=full*math.max(0,1-t/math.max(1,o.pl_tEnd)) end
        o.colli=t<o.pl_hbEnd
        if t>=o.pl_tEnd then remove_after=true end
    end
    if o.pl_sOff>=640 then remove_after=true end
    N.sync_laser(o)
    -- 展开末帧落入ACTIVE时，原作仍沿用本帧已算好的短判定长度。
    OriginalBulletVisual.native_laser(o,o.pl_state+1,t,full,o.pl_hbEnd,o.pl_flags,o.pl_sOff,entered+1)
    if remove_after then
        -- 原作先判定这一帧，再释放槽；零收束和尾偏移回收也走同一顺序。
        laser.frame(o)
        object.RawDel(o)
        return false
    end
    o.pl_t=t+1
    return true
end
function N.cancel_laser(o)
    -- RemoveAllBullets使用当前targetWidth开始原作收束，取消判定；保留原生角度与源点。
    if o.pl_state<2 then
        o.pl_lw,o.pl_state,o.pl_t=o.pl_w,2,0
    end
    o.pl_hbEnd,o.colli=0,false
    object.Preserve(o)
end
function N.render_laser(o)
    local len=o.pl_eOff-o.pl_sOff
    local color=math.max(0,math.min(15,o.pl_color))
    local image='th34_laser'..o.pl_sprite..'_'..color
    local h=o.pl_sprite%2==0 and 14 or 16
    if len>0 and o.pl_w>0 then
        SetImageState(image,o.pl_sprite<2 and 'mul+add' or '',o.pl_alpha,255,255,255)
        local mid=(o.pl_sOff+o.pl_eOff)/2
        Render(image,o.pl_x+math.cos(o.pl_ang)*mid,o.pl_y+math.sin(o.pl_ang)*mid,
            o.rot-90,o.pl_w/16,len/h)
    end
    if (o.pl_sOff<16 or o.pl_spd==0) and (not o.pl_hide or o.pl_state~=0) then
        local image='th34_orb_'..orb_index[color+1]
        local scale=o.pl_lw/10*(16-o.pl_sOff)/16
        if scale<=0 then scale=o.pl_lw/10 end
        SetImageState(image,'mul+add',255,255,255,255)
        Render(image,o.x,o.y,0,scale)
    end
end
return N
