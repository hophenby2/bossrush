-- 原作 ECL 的交互回归：只验指令、时序、坐标，不用弹幕密度反推参数。
-- TH07：ecldata4/5 的 Sub132..152、Sub57..77；EnemyEclInstr.cpp 的 ExIns7/8/10..14/21。
-- TH095：原版 th095.dat/ecl16_a.ecl 的 Sub2..7。TH10：BulletManager::SpawnSingleBullet。
-- 可直接运行：luajit tools/check_original_ecl_fidelity.lua。图像与命中另跑 check_bullet_visuals.lua。
local native=rawget(_G,'ORIGINAL_ECL_NATIVE')
arg={'ecl-fidelity'}
local original_popen=io.popen
if package.config:sub(1,1)=='\\' and debug.getinfo(io.popen).what=='C' then
    local commands={
        ['ls Resources/Special/ 2>/dev/null']='dir /b "Resources\\Special" 2>NUL',
        ['ls Resources/BossBackGround/ 2>/dev/null']='dir /b "Resources\\BossBackGround" 2>NUL',
        ["find mod THlib Resources -name '*.lua' 2>/dev/null"]=
            'dir /b /s "mod\\*.lua" "THlib\\*.lua" "Resources\\*.lua" 2>NUL',
    }
    io.popen=function(command) return original_popen(commands[command] or command) end
end
local f=assert(io.open('tools/check_stage.lua','rb'));local setup=f:read('*a');f:close()
assert(loadstring(setup:sub(1,assert(setup:find('if path == "--all" then',1,true))-1)))()
io.popen=original_popen
local helpers=object
-- 用实际的 Class 与协程库；实例不能从类表继承普通方法。
dofile('THlib/lib/Lobject.lua')
for k,v in pairs(helpers) do if rawget(object,k)==nil then object[k]=v end end
dofile('THlib/lib/Ltask.lua')
for _,base in ipairs({enemy,bullet,laser}) do
    for _,name in ipairs({'init','del','frame','render','colli','kill'}) do
        if base[name]==nil then base[name]=object[name] end
    end
end
local objects,checks,clock,cards={},0,0,{}
local function check(ok,why) assert(ok,why);checks=checks+1 end
local function near(a,b) return math.abs(a-b)<0.00001 end
local function make(cls,...)
    InitAllClass()
    local o
    if native then o=native.New(cls,...)
    else
        o={class=cls,x=0,y=0,rot=0,vx=0,vy=0,omiga=0,timer=0,ani=0,bound=true,_live=true,
            hscale=1,vscale=1}
        if cls.init then cls.init(o,...) end
    end
    objects[#objects+1]=o
    o.test_birth=clock
    return o
end
New=make
IsValid=function(o)
    if o==nil then return false end
    if native and rawget(o,3)~=nil then return native.IsValid(o) end
    return o._live~=false
end
object.RawDel=function(o)
    if not IsValid(o) then return end
    if native then native.Del(o)
    else o._live=false;if o.class.del then o.class.del(o) end end
end
object.Del,object.Kill=object.RawDel,object.RawDel
-- 模拟基础弹的运动入口，精灵资源不参与这组逻辑验收。
local Straight=Class(object,{
    init=function(o,style,col,x,y,v,a,frame)
        o.imgclass,o.real_index,o._index=style,col,col
        o.x,o.y,o.rot=x,y,a
        o.vx,o.vy=v*cos(a),v*sin(a)
        o.frame_other=frame
        o.group,o.colli=GROUP.ENEMY_BULLET,true
    end,
    frame=function(o) if o.frame_other then o.frame_other(o) end end,
})
NewSimpleBullet=function(style,col,x,y,v,a,aim,omega,stay,destroy,rebound,through,frame)
    return New(Straight,style,col,x,y,v,aim and a+Angle({x=x,y=y},player) or a,frame)
end
-- 反射时会直接换 class，故样式桩也必须是合法 Class。
for _,n in ipairs({'arrow_big','arrow_big_b','arrow_big_c','arrow_mid','arrow_small',
    'ball_small','ball_mid','ball_mid_c','ball_big','ball_huge','ball_light','grain_a','grain_b',
    'grain_c','grain_d','butterfly','ellipse','knife','knife_b','square','star_small','star_big',
    'heart','diamond','silence','music','water_drop','money','money_big','gun_bullet','mildew',
    'flower2','sakura','sakura_big'}) do _G[n]=Class(object,_G[n],true) end
-- 桩件的 enemy.frame 不执行协程，真实框架在此执行一次。
enemy.frame=task.Do
bullet.ChangeImage=function(o,style,col)
    if o.class==o.imgclass then o.class=style end
    o.imgclass,o.real_index,o._index=style,col,col
    style.init(o,col)
end
boss.card.add=function(parts,level,_,id)
    cards[id]=parts[1][1]
end
-- check_stage把未知字段补成空函数；显式启用真实TH095拍照包装，避免把补丁本身跳过。
boss.photo_damage_patch=false
boss.take_damage2=function() end
for _,n in ipairs({33,34,35}) do dofile('mod/GAME/th'..n..'.lua') end
local C=_editor_class.TH34
local function upvalue(root,name)
    local seen={}
    local function visit(v)
        if (type(v)~='function' and type(v)~='table') or seen[v] then return end
        seen[v]=true
        if type(v)=='function' then
            for i=1,100 do local k,u=debug.getupvalue(v,i);if not k then break end
                if k==name then return u end
                local found=visit(u);if found then return found end
            end
        else for _,u in pairs(v) do local found=visit(u);if found then return found end end end
    end
    return assert(visit(root),'缺少真实实现：'..name)
end
local function reset()
    for _,o in ipairs(objects) do if IsValid(o) then object.RawDel(o) end end
    if native then native.AfterFrame() end
    objects={};clock=0;lstg.var.timeslow=1
end
local function tick(owner,card)
    clock=clock+1
    if card and card.frame then card.frame(owner) end
    if owner then task.Do(owner) end
    if native then native.ObjFrame();native.AfterFrame()
    else
        local n=#objects
        for i=1,n do local o=objects[i]
            if IsValid(o) then
                if o.class.frame then o.class.frame(o) end
                o.x,o.y=o.x+(o.vx or 0),o.y+(o.vy or 0)
                o.rot=o.rot+(o.omiga or 0);o.timer,o.ani=o.timer+1,o.ani+1
            end
        end
    end
end
local function start(id)
    reset()
    local b={x=0,y=96,timer=0,ani=0,hp=10000,maxhp=10000,colli=true,_live=true}
    local card=assert(cards[id])
    card.init(b)
    return b,card
end
-- 真机 frame 后积分：变速弹不能多走一段旧速度，也不能把位置回退。
local b=New(C.TH34_cmdbullet,ball_small,2,0,0,2,0,
    {type=0x20,dur=3,angle=0,speed=1})
for _=1,3 do tick() end
check(near(b.x,12) and near(b.vx,5),'0x20 三帧位移必须是3+4+5')
reset()
local delayed=New(C.TH34_cmdbullet,ball_small,2,300,0,0,0,
    {flags=0x2000,list={{type=0x2000,dur=3}}})
check(not delayed.bound,'spawnDelay 在出生时关闭出屏回收')
tick();tick();check(not delayed.bound,'spawnDelay 计时未满时仍保留槽位')
tick();check(not IsValid(delayed),'spawnDelay 到点按原生边界释放场外弹')
reset()
local returning=New(C.TH34_cmdbullet,ball_small,2,230,0,1,180,
    {type=0x40,dur=300,loop=1,angle=0,speed=1})
tick()
check(IsValid(returning) and not returning.bound and returning.th07_out==1,
    'TH07折向中屏外弹保留原槽位，不受LuaSTG的224边界提前回收')
for _=1,40 do tick() end
check(IsValid(returning) and returning.x<192 and returning.th07_out==0,'TH07回程弹重新入屏后清零出屏计数')
reset()
local timeout=New(C.TH34_cmdbullet,ball_small,2,300,0,0,0,
    {type=0x40,dur=300,loop=1,angle=0,speed=0})
for _=1,127 do tick() end
check(IsValid(timeout) and timeout.th07_out==127,'TH07连续屏外第127帧仍存活')
tick();check(not IsValid(timeout),'TH07连续屏外第128帧释放')
reset()
local boss,card=start(3444)
for _=1,212 do tick(boss,card) end
local black
for _,o in ipairs(objects) do if IsValid(o) and o.c_list and #o.c_list==5 then black=o;break end end
check(black and black.c_list[2].dur==60 and black.c_list[3].dur==180,
    '二重黑死蝶保留Sub110..113两条原生0x2000记录')
black.x,black.y,black.vx,black.vy=300,0,0,0
for _=1,121 do if IsValid(black) then black.class.frame(black) end end
check(IsValid(black) and black.c_spawn_delay>0,'二重黑死蝶折向后仍保留屏外180帧延迟')
card.del(boss);task.Clear(boss)
reset()
local pool=upvalue(C.th07_cut_bullets,'pool4')
local function add(kind,x,y,v)
    local b=New(C.TH34_cmdbullet,kind==10 and ball_huge or ball_small,2,x,y,v or 0,0,
        {type=0x20,dur=0,angle=0,speed=0})
    b.th07_sprite,b.th07_color=kind,2;pool[#pool+1]=b;return b
end
local owner={x=0,y=0,_live=true}
local big=add(10,2,47.9);local edge=add(10,3,48);add(3,4,0)
local count,shots=C.th07_cut_bullets(owner,0,false,3)
check(count==1 and shots==25 and big.th07_cut_removed and IsValid(edge),'ExIns12 的L档严格48px带与25发切割')
local c,n=C.th07_cut_bullets(owner,1,true,3)
if native then native.AfterFrame() end
check(c==1 and n==15 and not IsValid(edge),'ExIns21 的180px带与15发第二次切割')
for _,o in ipairs(pool) do if IsValid(o) and o.th07_sprite~=3 then
    check(o.y>=31.9 and o.y<=64,'切割散射点只翻转y轴，保持原作32px随机范围')
end end
reset();for i=#pool,1,-1 do pool[i]=nil end
local curved=add(0,0,-20,2);local outside=add(0,16,-20,2)
C.th07_curve_bullets(owner)
check(curved.th07_special_state==1 and outside.th07_special_state==nil,'ExIns13 只弯曲本体下方严格32px窄带')
tick()
check(near(curved.rot,3) and near(curved.c_spawn_delay,0),'原作偶数槽的弯曲角按y轴翻转')
player.x,player.y=0,-100
C.th07_redirect_bullets(owner)
local vx,vy=curved.vx,curved.vy
local a=Angle(curved,player);tick()
check(curved.th07_special_state==2 and near(curved.vx,vx+2/75*cos(a))
    and near(curved.vy,vy+2/75*sin(a)),'ExIns14 按重瞄快照加速度，覆盖原弯曲命令')
local arrow=add(4,0,0);local round=add(0,0,0)
lstg.var.timeslow=4;C.th07_set_speed(owner,3)
check(lstg.var.timeslow==3 and arrow.own_gray and not round.own_gray,'缓时只临时改箭头色，不再次缩小速度')
C.th07_motion_end(owner)
check(lstg.var.timeslow==4 and not arrow.own_gray and owner.th07_speed_effect==nil,'提前结束也恢复原缓时与颜色')
-- ECL的激光改弹：光柱交点反射的是同一颗弹，不增删弹数。
C.th07_lasers={{pl_state=1,pl_ang=0,pl_lw=16,pl_x=0,pl_y=0,pl_sOff=0,pl_eOff=100,_live=true}}
owner.th07_laser_interaction,owner.th07_laser_tick=7,1
local reflect=add(0,50,0,2);reflect.vy=-2;reflect.vx=0
local original_class=reflect.class
C.th07_laser_interact(owner)
check(reflect.th07_special_state==10 and near(reflect.vy,-1.9) and reflect.th07_sprite==5,
    'ExIns7 原槽弹改为米弹并沿光柱法向反射')
check(reflect.class==original_class,'激光改弹保留飞行回调，不重新播放出生动画')
-- 阶段时序按原作墙钟：同步 Sub2 多占16帧，不能把子线程的等待重复算一遍。
for _,case in ipairs({{4476,416},{4447,346},{4448,466}}) do
    local boss,card=start(case[1]);local first,hasLeft,hasRight
    for t=0,case[2]+2 do
        for _,l in ipairs(C.th07_lasers) do if IsValid(l) and not first then first=t end end
        if t==1 then
            for _,o in ipairs(objects) do if IsValid(o) and o.hp==999999 then
                hasLeft=hasLeft or o.x<0;hasRight=hasRight or o.x>0
            end end
        end
        tick(boss,card)
    end
    check(hasLeft and hasRight,'三姐妹必须同时运行另外两人的实体分支：'..case[1])
    check(first and math.abs(first-case[2])<=1,'第一条伴奏激光的源ECL时点：'..case[1]..'/'..tostring(first))
    if case[1]==4476 then
        check(near(boss.x,0) and near(boss.y,128),'合葬主机按Sub132移到(192,96)后停驻，不能凭观感添加游走')
        local before=#objects
        for _,o in ipairs(objects) do if IsValid(o) and o.hp==999999 then
            o.class.kill(o)
            check(o.task==nil,'陪战Boss结束时立即清除协程')
        end end
        check(#objects==before,'999999占位血量不再生成十万个死亡圆环')
    end
    for _=1,320 do tick(boss,card) end
    if case[1]==4448 then
        check(#C.th07_lasers==6,'大合葬的三人各两条旋转激光')
        local x=C.th07_lasers[2].pl_ang
        tick(boss,card)
        check(C.th07_lasers[2].pl_ang~=x,'旋转激光角必须逐帧更新')
    end
    card.del(boss);task.Clear(boss)
    if native then native.AfterFrame() end
    for _,l in ipairs(C.th07_lasers) do check(not IsValid(l),'结束时回收所有伴奏激光') end
end
local boss,card=start(4408)
for _=1,600 do tick(boss,card) end
local fired=0;for _,o in ipairs(objects) do if IsValid(o) and o.imgclass then fired=fired+1 end end
check(fired>0,'畜趣剑必须执行有弹幕的Normal分支')
card.del(boss);task.Clear(boss)
-- 文花帖场景70：入场130帧，移动子机40帧后首个32弹环；本体枪在45帧后开启。
boss,card=start(4480)
check(boss.x==-128 and boss.y==288,'ecl16_a 初始x已居中，只把y=-64换成288')
for _=1,174 do tick(boss,card) end
local shots=0;for _,o in ipairs(objects) do if IsValid(o) and o.imgclass then shots=shots+1 end end
check(shots==32,'ecl16_a Sub6 首次32弹环，不能提前启动本体枪')
for _=1,4 do tick(boss,card) end
shots=0;for _,o in ipairs(objects) do if IsValid(o) and o.imgclass then shots=shots+1 end end
check(shots==65,'ecl16_a 第二环与Sub5首次单弹时点')
card.del(boss);task.Clear(boss)
reset()
local transform=upvalue(cards,'sg_tr_hook')
local recolor=NewSimpleBullet(ball_small,2,0,0,2,0)
local flight=recolor.class
transform({{kind=0x4000,allow=0,i0=14,i1=5,f0=0,f1=0}},0x4000)(recolor)
check(recolor.imgclass.visual_style==knife and recolor.real_index~=2 and recolor.class==flight,
    'TH095 0x4000 即时换弹型/色号，并保留原弹运动')
-- TH10 两条发弹实现共用2000槽；满槽停止，不抽随机数。
reset()
local emit=upvalue(cards,'t10_spawn_one')
local pattern={aim=1,c1=1,c2=1,s1=0,s2=0,astep=0,angle=0,type=0,color=2,
    ex={[0]={a=0,k=0x2000,i0=3,i1=0,f0=0,f1=0}}}
check(emit(pattern,300,0,0,0,0),'TH10 出屏延迟测试弹能生成')
local delayed=objects[#objects]
for _=1,3 do tick() end
check(IsValid(delayed) and not delayed.bound,'TH10 0x2000在第三帧仍保留场外弹')
tick()
check(not IsValid(delayed) or delayed.bound,'TH10 检查完出屏再递减延迟')
reset()
local wrapped={aim=1,c1=1,c2=1,s1=2,s2=0,astep=0,angle=0,type=14,color=2,
    ex={[0]={a=1,k=0x100000,i0=4,i1=0,f0=0,f1=0}}}
emit(wrapped,206,224,0,0,0)
local torus=objects[#objects]
tick()
check(near(torus.x,-206) and torus.tb.st.wrap_x.left==3,'TH10穿过右边后平移384+30像素，扣一次穿墙次数')
for _=1,3 do torus.x=206;tick() end
check(torus.tb.af.wrap_x==nil and torus.tb.st.wrap_x.left==0,'TH10四次穿墙耗尽后关闭变换，不能当四帧定时器')
torus.x=206;tick()
check(torus.x>192,'TH10穿墙次数耗尽后不再传送')
reset()
wrapped.s1=0;wrapped.ex[0].k=0x200000;wrapped.ex[0].i0=2
emit(wrapped,0,-16,0,0,0)
local vertical=objects[#objects];tick()
check(near(vertical.y,-238) and vertical.tb.st.wrap_y.left==1,'TH10纵向穿墙使用448+精灵高，并翻转Y坐标')
reset()
local plain={aim=1,c1=1,c2=1,s1=0,s2=0,astep=0,angle=0,type=3,color=2,ex={}}
emit(plain,0,-46,0,0,0)
local top=objects[#objects]
for _=1,12 do tick() end
check(IsValid(top) and near(top.y,270) and not top.bound,'TH10顶部原生-64余量保留越过LuaSTG256边界的弹')
top.y=300;tick();check(not IsValid(top),'TH10超过原生顶部余量才静默回收')
reset()
local torus_boss,torus_card=start(3624)
for _=1,90 do tick(torus_boss,torus_card) end
local active_wrap=false
for _,o in ipairs(objects) do if IsValid(o) and o.tb and o.tb.af.wrap_x then active_wrap=true end end
check(active_wrap,'神秘「ヤマトトーラス」的实际枪接通横向四次穿墙')
torus_card.del(torus_boss);task.Clear(torus_boss)
reset()
local spawn=upvalue(cards[3600],'spawn_bullet')
local filled=0;for _=1,2000 do if spawn(0,0,0,0,160,2) then filled=filled+1 end end
check(filled==2000,'原作2000个空槽可用')
check(spawn(0,0,0,0,160,2)==nil,'第2001发必须被原作弹池拒绝')
object.RawDel(objects[100]);if native then native.AfterFrame() end
check(spawn(0,0,0,0,160,2)~=nil,'释放槽位后可以复用')
reset()
-- 消弹也走原作收束，不能换成THlib的另一个激光类导致位置/贴图丢失。
local laser_factory=upvalue(cards[4476],'plaser')
local cancelled=laser_factory(0,0,0,{tStart=10,dur=100,tEnd=4,w=16,hbEnd=3})
tick();tick()
local original=cancelled.class
cancelled.class.kill(cancelled)
check(cancelled.class==original and cancelled.pl_state==2 and not cancelled.colli,
    '激光消弹保留原生类、坐标和纹理，从当前宽度进入收束')
for _=1,5 do tick() end
check(not IsValid(cancelled),'激光消弹按原作endTime释放')
reset()
-- 出生阶段与NORMAL分开；场外出生也要等动画结束才进入原生回收判断。
local delayed_spawn=New(C.TH34_cmdbullet,ball_small,2,500,0,2,180,
    {flags=0x2002,list={{type=0x2000,dur=20}}})
check(near(delayed_spawn.x,508),'原作SPAWN_FAST出生点先退四帧位移')
for _=1,9 do tick() end
check(IsValid(delayed_spawn) and delayed_spawn.c_spawn_delay==20
    and not delayed_spawn.colli,'出生动画期间不倒数spawnDelay，也不回收或开启判定')
tick()
check(delayed_spawn.c_spawn_left==0 and delayed_spawn.c_spawn_delay==19
    and near(delayed_spawn.x,496),'出生末帧先走半速，再落入NORMAL走全速')
reset()
local negative=New(C.TH34_cmdbullet,ball_small,2,500,0,0,0,
    {flags=0x2000,list={{type=0x2000,dur=-1}}})
tick()
check(IsValid(negative) and negative.c_spawn_delay==-2,'负spawnDelay按原作!=0继续递减，不钳为0')
reset()
-- 首张骚符也同时运行Sub122/123；子机在354帧起各放六只幽灵，不能只有主Boss。
local trio,trio_card=start(4441)
for _=1,121 do tick(trio,trio_card) end
local sides={}
for _,o in ipairs(objects) do if IsValid(o) and o.th07_prism_side then
    sides[o.th07_prism_side]=o
end end
check(sides[-1] and sides[1],'首张骚符同时生成梅露兰与莉莉卡')
check(near(sides[-1].x,-96) and near(sides[1].x,96)
    and near(sides[-1].y,128) and near(sides[1].y,128),'Sub122/123按原作移动到96/288,96')
for _=122,356 do tick(trio,trio_card) end
local ghosts=0
for _,o in ipairs(objects) do if IsValid(o) and o.th07_prism_emitter then ghosts=ghosts+1 end end
check(ghosts==12,'Sub125的第一拍左右各生成六只发弹幽灵')
trio_card.del(trio);task.Clear(trio);reset()
for _,id in ipairs({3447,3465}) do
    local owner,spell=start(id)
    for _=1,240 do tick(owner,spell) end
    local b
    for _,o in ipairs(objects) do if IsValid(o) and o.c_list and #o.c_list==2
        and o.c_list[1].type==0x40 and o.c_list[2].dur==200 then b=o;break end end
    check(b and b.c_spawn_delay>0,'实际曲线枪保留原作slot1/allow1/200帧命令：'..id)
    b.x,b.y,b.vx,b.vy=500,0,0,0
    for _=1,90 do tick() end
    check(IsValid(b) and b.c_spawn_delay>0,'折向完成后场外弹仍等原作延迟：'..id)
    spell.del(owner);task.Clear(owner);reset()
end
-- 检查实际PLASER的flags&1、零收束和原始纹理，不以THlib代理光柱代替。
local plaser=upvalue(cards[4476],'plaser')
local fade=plaser(0,0,0,{sprite=1,color=6,w=16,sOff=0,eOff=100,sLen=100,
    tStart=10,dur=3,tEnd=4,hbStart=5,hbEnd=2,flags=1})
check(fade.pl_alpha==0,'淡入激光刚出生时透明，不能先闪一帧满亮光柱')
for _=1,6 do tick() end
check(near(fade.pl_w,16) and near(fade.pl_alpha,127.5),'flags1展开以完整宽度淡入，不套用细线变粗')
for _=1,8 do tick() end
check(fade.pl_state==2 and fade.pl_alpha==0,'flags1收束保留原作从零渐亮的行为')
for _=1,4 do tick() end
check(not IsValid(fade),'原生激光计时结束立即释放，不再触发THlib额外30帧收束')
reset()
local instant=plaser(0,0,0,{tStart=0,dur=2,tEnd=0,w=8})
check(instant.pl_state==1,'startTime0从ACTIVE状态出生')
for _=1,3 do tick() end
check(not IsValid(instant),'endTime0在ACTIVE结束当帧释放')
reset()
local visual=upvalue(cards[4397],'NativeVisual')
local owner,spell=start(3449)
for _=1,311 do tick(owner,spell) end
local circle
for _,o in ipairs(objects) do if IsValid(o) and o.th07_source_kind=='circle' then circle=o;break end end
check(circle and circle.timer>=80,'动与静的法阵到达目的地后继续保留并发弹')
local render_saved,texture_saved=Render,RenderTexture
local draws,quads={},{}
Render=function(name,x,y,rot,hs,vs) draws[#draws+1]={name=name,x=x,y=y,rot=rot,hs=hs,vs=vs} end
RenderTexture=function(tex,blend,a,b,c,d) quads[#quads+1]={tex=tex,a=a,b=b,c=c,d=d} end
visual.render_source(circle)
check(draws[1].name=='th34_source_circle' and near(draws[1].x,circle.x),'法阵从真实发弹源坐标绘制原作64px精灵')
spell.del(owner);task.Clear(owner);reset()
local owner,spell=start(4397)
for _=1,320 do tick(owner,spell) end
local ribbon
for _,o in ipairs(objects) do if IsValid(o) and o.th07_source_kind=='spirit' then ribbon=o;break end end
check(ribbon and #ribbon.th07_source_history==48,'蝶妄想实际Sub53保留48帧拖尾，不能是空渲染控制器')
quads={};visual.render_source(ribbon)
check(#quads==47 and quads[1].tex=='th34_native','蝶妄想绘制47段原作纹理带')
local q=quads[1]
check(near(math.sqrt((q.a[1]-q.d[1])^2+(q.a[2]-q.d[2])^2),32),'拖尾宽度按48×16精灵的scaleY2保持32px')
spell.del(owner);task.Clear(owner);reset()
local owner,spell=start(4397)
for _=1,200 do tick(owner,spell) end
for _,o in ipairs(objects) do if IsValid(o) and o.th07_sprite==8 and o.th07_color==4 then
    OriginalBulletVisual.retire(o)
end end
for _=201,270 do tick(owner,spell) end
local stale_sources=0
for _,o in ipairs(objects) do if IsValid(o) and o.th07_source_kind=='spirit' then stale_sources=stale_sources+1 end end
check(stale_sources==0,'ex17不能从已回收蝶弹的最后位置创建幽灵发射源')
spell.del(owner);task.Clear(owner);reset()
local hits=0
local saved_player=player
player={x=0,y=0,A=1,B=1,class={colli=function() hits=hits+1 end}}
local source={x=0,y=0,ani=0,timer=1}
visual.source(source,'spirit')
for i=1,48 do source.x=i*10;visual.record_source(source) end
player.x=420;hits=0
visual.record_source(source)
check(hits>0,'拖尾历史第7帧节点也有原作接触判定')
player.x=source.x;player.y=4;hits=0;visual.record_source(source)
check(hits==0,'原作8/1.5全宽判定不能误作半宽扩大一倍')
player=saved_player
Render,RenderTexture=render_saved,texture_saved
-- 青鬼赤鬼的ExIns22：只在大玉折向结束且原坐标y<320时撒弹。
reset()
local oni_owner,oni_card=start(3460)
local oni_pool=upvalue(C.th07_oni_emit,'pool4')
local large=New(C.TH34_cmdbullet,ball_huge,2,20,30,0,0,
    {flags=0,list={}})
large.th07_sprite,large.th07_color=10,1;oni_pool[#oni_pool+1]=large
large.c_exf=0x40
check(C.th07_oni_emit(oni_owner,211)==0,'大玉的0x40折向尚未结束时不撒小弹')
large.c_exf=0
check(C.th07_oni_emit(oni_owner,213)==0,'每3帧跳过一次ExIns22')
large.y=-96
check(C.th07_oni_emit(oni_owner,211)==0,'原作y=320边界严格排除，翻转后y=-96')
large.y=30
check(C.th07_oni_emit(oni_owner,211)==1,'奇数帧从每颗大玉生成一发小弹')
local child=oni_pool[#oni_pool]
check(child.th07_sprite==1 and child.th07_color==6 and child.c_flags==0x248
    and child.c_spawn_left==32 and child.c_list[1].speed==3.1,
    '青鬼奇数帧使用精灵1色6、慢出生及60帧后同向3.1速命令')
large.th07_color=0
check(C.th07_oni_emit(oni_owner,212)==2,'偶数帧从大玉生成两发，不递归从小弹生成')
local a,b=oni_pool[#oni_pool-1],oni_pool[#oni_pool]
check(a.th07_sprite==3 and a.th07_color==2 and a.c_flags==0x208
    and near(a.vx,-b.vx) and near(a.vy,-b.vy),'赤鬼偶数帧精灵3色2，两发0.8速反向直线弹')
oni_card.del(oni_owner);task.Clear(oni_owner);reset()
local oni_owner,oni_card=start(3460)
for _=1,121 do tick(oni_owner,oni_card) end
check(near(oni_owner.y,160) and oni_owner._box==nil,'青鬼赤鬼进场120帧后按原作解除活动框')
for _=122,400 do tick(oni_owner,oni_card) end
local small,huge=false,false
for _,o in ipairs(objects) do if IsValid(o) then
    if o.th07_sprite==1 or o.th07_sprite==3 then small=true end
    if o.th07_sprite==10 then huge=true end
end end
check(small and huge and oni_owner.th07_oni_active,'实际符卡时间轴同时出现鬼玉与撒出的两种小弹')
oni_card.del(oni_owner);task.Clear(oni_owner)
check(not oni_owner.th07_oni_active,'换卡停止ExIns22回调')
reset()
-- TH095出生状态与变换认领在实际sg_shot出口验证，不以框架默认11帧雾化代替。
local photo_shot=upvalue(cards[478],'sg_shot')
local photo_style=upvalue(cards[478],'sg_style')
local photo_hook=upvalue(cards[478],'sg_tr_hook')
local callback_steps=0
photo_shot(87,photo_style(1),1,0,0,1,1,2,0,0,0,false,0x202,
    function(o) callback_steps=callback_steps+1 end)
local spawned=objects[#objects]
check(near(spawned.x,-8) and spawned.th095_spawn_left==8,'TH095 FAST出生点先退四帧速度')
for _=1,7 do tick() end
check(callback_steps==0 and near(spawned.x,-1) and not spawned.colli,
    'TH095出生阶段只走半速，不推进发弹记录或碰撞')
tick()
check(callback_steps==1 and near(spawned.x,2) and spawned.colli,
    'TH095出生末帧执行半步与完整ACTIVE步')
reset()
local hook=photo_hook({{kind=0x2000,allow=0,i0=99,i1=0,f0=0,f1=0},
    {kind=0x20,allow=0,i0=3,i1=-1,f0=1,f1=0}},0x2020)
photo_shot(87,photo_style(1),1,0,0,1,1,2,0,0,0,false,0x2020,hook)
local active=objects[#objects]
check(active.sg_cull_delay==99 and active.sg_tr.acts[1].timer==0,
    'TH095出生当帧执行即时记录并认领首条运动记录，暂不推进计时')
tick()
check(near(active.x,3) and near(active.vx,3),'无SPAWN的TH095弹首帧立即执行原生加速')
reset()
local native95=upvalue(cards[495],'PhotoNative')
check(_editor_boss['2a31'].name=='八云蓝' and _editor_boss['2a31'].img=='Ran',
    'enm16的原版素材是八云蓝，不能把这组卡挂到妖梦行走图上')
check(_editor_boss['14a31'].name=='魂魄妖梦' and _editor_boss['14a31'].img=='Youmu',
    'enm13的四张剑符与缓时对应妖梦')
local owner,spell=start(412)
for _=1,450 do tick(owner,spell) end
check(near(owner.x,0) and near(owner.y,96),'死蝶浮月本体按Sub3的320帧插值升到原作y128后停留')
local sources=0
for _,o in ipairs(objects) do
    if IsValid(o) and o.class==_editor_class.TH33.dead_moth then
        sources=sources+1
        check(o.hide and o.y>=-32 and o.y<=32,'死蝶浮月的Sub4是下方活动带内的隐藏独立发弹源')
    end
end
check(sources==1,'ins83(4)生成一个Sub4，不是四个装饰蝶')
for _=451,590 do tick(owner,spell) end
local released=false
for _,o in ipairs(objects) do
    if IsValid(o) and o.sg_tag==1 and o.th095_motion_reset then
        check(near(math.sqrt(o.vx*o.vx+o.vy*o.vy),4.5),'ExIns21让被标记的旋转蝶以4.5速直飞')
        released=true;break
    end
end
check(released,'死蝶浮月第一轮激光预热结束执行原版ExIns21')
spell.del(owner);task.Clear(owner);reset()
local key=New(_editor_class.TH33.key,-128,256)
for _=1,10 do tick() end
check(near(key.y,236),'秘鍵子发弹体出生即以2速下行，不能等淡入完才开始移动')
check(key.img=='th33_key' and near(key.hscale,1-(1-10/15)^2),
    '秘鍵使用原版enm16/script8的128×144法阵及15帧生长')
for _=11,315 do tick() end
check(not IsValid(key),'秘鍵按128×144精灵出场回收，不额外停留25帧淡出')
reset()
local old_float,old_px=ran.Float,player.x
ran.Float=function(_,a) return a end;player.x=200
local angle=native95.boundary_angle(100,224,{-160,0,160,448},-0.2)
check(near(angle,-3.1415927+0.2),'TH095右边界负角分支同样读取上一帧movementAngle')
ran.Float=old_float;player.x=old_px
local line=New(laser,3,0,0,0,0,0,0,24,0,0)
native95.straight(line,256,24,8)
for _=1,32 do tick() end
check(near(line.l2,256) and near(line.x,0),'文花帖145先长满256px，不能在生长时移动尾端')
tick()
check(near(line.x,8) and IsValid(line),'文花帖145长满后整根每帧前进8px，没有虚构的维持40帧')
reset()
local target={x=10,y=20,_live=true}
local ray=New(laser,3,0,0,0,0,0,0,16,0,0)
native95.rotating(ray,target,32,16,8,3,2,3,2,1,2,0,true)
for _=1,3 do tick() end
check(near(ray.w,2) and not ray.colli and near(ray.l2,24) and near(ray.x,12),
    '文花帖旋转光预热保持2px并逐帧增长，锚点跟随本体后再加速度')
tick();check(ray.th095_laser_state==4 and near(ray.w,2) and ray.colli,
    '文花帖预热转生长的当帧保持2px，而非直接画满宽或透明渐入')
tick();check(near(ray.w,8),'文花帖生长阶段按本段计时器线性长宽')
tick();check(ray.th095_laser_state==2 and near(ray.w,16),'文花帖生长结束当帧进入满宽维持')
for _=1,3 do tick() end
check(ray.th095_laser_state==5 and not ray.colli and near(ray.w,16),'文花帖维持到点直接进入无判定收束')
tick();check(near(ray.w,8),'文花帖收束按原作计时缩宽')
tick();check(not IsValid(ray),'文花帖旋转光收束结束直接释放，不追加框架淡出')
reset()
local source_count=0
for id,source in pairs(dofile('mod/GAME/th33_sources.lua')) do
    source_count=source_count+1
    check(cards[id].t3==source.timeout_start+source.timeout and #source.sha256==64,
        '文花帖每幕时限来自原版ECL的ins114及赋值时刻：'..id)
    local owner,spell=start(id)
    check(owner.photo_damage_limit==source.photos,'文花帖逐幕快门上限与原版ins141一致：'..id)
    owner.protect=true
    _G.boss.take_damage2(owner,1)
    check(owner.photo_hit_count==0,'受保护目标不能推进有效拍照张数：'..id)
    spell.del(owner);task.Clear(owner);reset()
end
check(source_count==85 and cards[495].t3==7908,'文花帖85幕齐全，天女返し不是统一50秒')
for _=1,1601 do photo_shot(87,photo_style(1),1,0,0,1,1,0,0,0,0,false,0) end
check(#objects==1600,'文花帖0x640个弹槽即1600，不是十进制640或无限生成')
reset()
photo_shot(87,photo_style(1),1,0,0,1,1,2,0,0,0,false,0)
local fading=objects[#objects]
native95.despawn(fading)
check(IsValid(fading) and not fading.colli and fading.th095_despawn_duration==8,
    '文花帖小弹退场保留原对象8帧并立即关闭判定')
for _=1,7 do tick() end
check(IsValid(fading) and near(fading.x,7),'文花帖小弹退场期间以原速度一半前进')
tick();check(not IsValid(fading),'文花帖小弹ANM结束才释放弹槽')
reset()
local owner,spell=start(495)
local rates={}
for i=1,400 do
    tick(owner,spell)
    local value=lstg.var.CYFPS
    if value and rates[#rates]~=value then rates[#rates+1]=value end
end
check(rates[1]==15 and rates[2]==60 and near(rates[3],14.4) and rates[4]==60,
    '天女返し逐轮保留原版0.25与0.24两个缓时窗口及其恢复')
spell.del(owner);task.Clear(owner)
check(lstg.var.CYFPS==nil,'文花帖换卡恢复进入缓时之前的全局时钟')
reset()
print(('原作切割、变速、伴奏激光与文花帖回归通过：%d 项'):format(checks))
