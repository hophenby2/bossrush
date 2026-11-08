-- TH11专用回调表来自日文1.00a VA0x4a3d64；地址由native_evidence.py复核。
-- 这些是每敌机的普通Lua回调，和ECL异步线程各持独立时钟。
local H,class=...
local band,bor=require('bit').band,require('bit').bor
local function bullets(a,fn)
    for _,b in pairs(a.session.bullets) do if IsValid(b) and not b.fading and b.birth==0 then fn(b) end end
end
local callbacks={}
local ring_base=Class(enemy,{
    take_damage=function(o,damage)
        local a=o.master
        if not a.dead and a.invul<=0 and band(a.flags,0x31)==0 and not a.survival and not a.transition_pending then
            a.ring_damage=(a.ring_damage or 0)+damage
        end
    end,
})
local ring_node=Class(ring_base,{
    init=function(o,master)
        enemybase.init(o,10000000,true)
        o.master=master;o.img='img_void';o.a,o.b,o.rect=8,8,true
        o._original_collision_game=11;o._original_damage_box={16,16}
    end,
    frame=function(o) if o.master.dead then object.RawDel(o) end end,
    render=function() end,
})
local function ring_collision(a)
    local vm=a.anm[0];if not vm then return end
    -- 0x417ef0/418050：31个受击采样点、32个体术采样点；弧长随生命值收拢。
    local life=math.max(0,a.o.hp/math.max(1,a.o.maxhp))
    local arc=H.f32(.39269909262657166+life*5.890486240386963)
    vm.rotation[1]=arc
    local start=vm.rotation[3]-arc*.5+arc*.015625
    local radius=vm.scale[2]
    if a.damage_callback then
        a.ring_nodes=a.ring_nodes or {}
        for i=1,31 do
            local node=a.ring_nodes[i]
            if not node or not IsValid(node) then node=New(ring_node,a);a.ring_nodes[i]=node end
            local theta=start+(i-1)*arc*.03125
            node.x,node.y=a.o.x+math.cos(theta)*radius,a.o.y-math.sin(theta)*radius
            node.colli=band(a.flags,0x21)==0 and a.invul<=0
        end
        local damage=a.ring_damage or 0;a.ring_damage=0
        if damage>=30 then damage=30+math.floor((damage-30)*3/5) end
        if damage>=70 then damage=50+math.floor((damage-50)/5) end
        damage=math.min(80,damage);a.o.hp=a.o.hp-H.hp.damage(a,damage)
    end
    if a.contact_callback and band(a.flags,0x22)==0 and a.contact_invul<=0 and player and IsValid(player) then
        local hit=4+16*life
        for i=0,31 do
            local theta=start+i*arc*.03125
            local x,y=a.o.x+math.cos(theta)*radius,a.o.y-math.sin(theta)*radius
            if (player.x-x)^2+(player.y-y)^2<hit*hit and player.class and player.class.colli then player.class.colli(player,a.o);break end
        end
    end
end
callbacks[0]=function() end
-- 0x418170/418200/418240：尸体使魔的400标志及I1通知，不额外生成一层弹。
callbacks[2]=function(a)
    for _,e in ipairs(a.session.actors) do if e~=a and band(e.flags,0x400)~=0 then e.o.hp=e.o.hp-99999 end end
end
callbacks[3]=function(a)
    for _,e in ipairs(a.session.actors) do if band(e.flags,0x400)~=0 then e.vars[-9984]=1 end end
end
callbacks[4]=function(a)
    for _,e in ipairs(a.session.actors) do if band(e.flags,0x400)~=0 then e.flags=bor(band(e.flags,require('bit').bnot(0x400)),0x100) end end
end
-- 0x418460：从所有type13（主脚本64）的弹位置生成MBossCard2_at2，参数继承调用者。
callbacks[6]=function(a)
    bullets(a,function(b) if H.projectile_profiles[b.kind].script==64 then
        H.spawn(a,257,'MBossCard2_at2',b.x,224-b.y,10,10,-2)
    end end)
end
-- 0x4188c0：I1周期、slot1枪；源type27心形本身继续运动，花瓣从心形当前点发。
callbacks[8]=function(a)
    local period=a.vars[-9984] or 0
    if period<=0 or a.phase_time%period~=0 then return end
    local p=a.guns[1]
    bullets(a,function(b) if H.projectile_profiles[b.kind].script==191 then H.emit_pattern(a.session,p,b.x+p.ox,224-b.y+p.oy) end end)
end
callbacks[9]=function(a) a.session.bullet_phase=3 end
callbacks[11]=function(a) a.session.bullet_phase=2 end
-- 0x428610：只转动预警态直线激光；末60帧或扫到自机时锁住实际角。
callbacks[1]=function(a)
    local omega=a.vars[-9981] or 0
    for _,l in ipairs(a.session.lasers) do if IsValid(l) and l.params.stationary and l.state==3 then
        l.hypno_target=H.angle((l.hypno_target or l.angle)-omega)
        local co,si=math.cos(l.angle),math.sin(l.angle)
        local dx,dy=player.x-l.x,(224-player.y)-(224-l.y)
        local along,across=dx*co+dy*si,-dx*si+dy*co
        local near=along>=l.length*.1 and along<=l.length*1.1 and math.abs(across)<=5
        l.hypno_blocked=near or l.state_time>=l.params.warn-60
        if not l.hypno_blocked then
            local delta=H.angle(l.hypno_target-l.angle)
            if math.abs(delta)<.04908738657832146 then delta=delta*.10000000149011612 end
            l.angle=H.angle(l.angle+delta);l.params.angle=l.angle;l.rot=-math.deg(l.angle)
        end
    end end
end
-- 0x418290：核球朝中心加速；I0为1时才吸引自机。位移取F3，作用于type1小玉。
callbacks[5]=function(a)
    local pull=a.vars[-9978] or 0
    if a.vars[-9985]==1 and pull~=0 then
        local px,py=player.x,224-player.y
        local dx,dy=H.f32(a.o.x-px),H.f32((224-a.o.y)-py)
        local r=math.sqrt(H.f32(H.f32(dx*dx)+H.f32(dy*dy)))
        if r>0 then
            local inv=H.f32(1/r)
            px=H.f32(px+H.f32(H.f32(dx*inv)*pull));py=H.f32(py+H.f32(H.f32(dy*inv)*pull))
            -- 0x410580：坐标×128后向零取整；保留F3的符号，不套自制卡的6px限速。
            player.x=H.int(H.f32(px*128))/128;player.y=224-H.int(H.f32(py*128))/128
        end
    end
    bullets(a,function(b)
        if H.projectile_profiles[b.kind].script==34 then
            b.speed=-pull;b.mx,b.my=math.cos(b.angle)*b.speed,math.sin(b.angle)*b.speed
            if (b.x-a.o.x)^2+(b.y-a.o.y)^2<(a.vars[-9981] or 0)^2*.25 then H.projectile_fade(b) end
        end
    end)
end
callbacks[7]=function(a)
    -- 0x418520：沿F0射线取F1距离，投影到184/32/432边界，再按I1的节拍发枪0。
    local angle,r=a.vars[-9981] or 0,a.vars[-9980] or 0
    local co,si=math.cos(angle),math.sin(angle)
    local x,y=a.o.x+co*r,224-a.o.y+si*r
    if x>=184 then r=184/co
    elseif x<=-184 then r=-184/co
    elseif y<=32 then r=-192/si
    elseif y>=432 then r=208/si end
    x,y=a.o.x+co*r,224-a.o.y+si*r
    local period=a.vars[-9984] or 1
    local phase=period~=0 and a.phase_time%period or 0
    if phase==0 or ((x-player.x)^2+(y-(224-player.y))^2>=576 and (phase==3 or phase==6)) then H.emit_pattern(a.session,a.guns[0],x,y) end
    local theta=math.pi-angle;local ct,st=math.cos(theta),math.sin(theta)
    bullets(a,function(b)
        if b.color==a.vars[-9985] then
            local dx,dy=a.o.x-b.x,(224-a.o.y)-(224-b.y)
            local xx,yy=dx*ct-dy*st,dx*st+dy*ct
            if xx>0 and xx<295 and yy> -8 and yy<8 then H.projectile_fade(b) end
        end
    end)
end
callbacks[10]=function(a)
    -- 0x4189d0：F4-32内切为type28，离开后恢复type1；只换型，不重置弹运动。
    local r=(a.vars[-9935] or 0)-32
    bullets(a,function(b)
        local inside=(b.x-a.o.x)^2+(b.y-a.o.y)^2<r*r
        if inside and not b.highlight then
            b.highlight=true
            H.projectile_sprite(b,28,b.color==6 and 1 or b.color==13 and 3 or 0)
            b.a,b.b=H.projectile_profiles[28].radius*1.2,H.projectile_profiles[28].radius*1.2
        elseif not inside and b.highlight then
            b.highlight=false
            H.projectile_sprite(b,1,b.color==1 and 6 or b.color==3 and 13 or 2)
        end
    end)
end
callbacks[12]=function(a)
    -- 0x418d20：两种颜色各自比较F0/F1方向；偏角超过F2才扩大判定和换型。
    bullets(a,function(b)
        local blue=b.color==6 or b.color==1
        local axis=a.vars[blue and -9981 or -9980] or 0
        local large=math.abs(H.angle(b.angle-axis))>(a.vars[-9979] or 0)
        if large and not b.highlight then
            b.highlight=true;H.projectile_sprite(b,28,blue and 1 or 0)
            b.a,b.b=H.projectile_profiles[28].radius*1.6,H.projectile_profiles[28].radius*1.6
        elseif not large and b.highlight then
            b.highlight=false;H.projectile_sprite(b,1,blue and 6 or 2)
        end
    end)
end
function H.callback(a,op,id)
    assert(callbacks[id],'TH11未知专用回调：'..id)
    if op==443 then a.callback=id
    elseif op==449 then callbacks[id](a)
    elseif op==444 then assert(id==0 or id==1);a.damage_callback=id==1
    elseif op==445 then assert(id==0 or id==1);a.contact_callback=id==1 end
end
function H.run_callback(a)
    if a.callback then callbacks[a.callback](a) end
    if a.damage_callback or a.contact_callback then ring_collision(a) end
end
class.callbacks=callbacks
