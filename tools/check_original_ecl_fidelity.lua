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
local delayed=New(C.TH34_cmdbullet,ball_small,2,0,0,2,0,
    {flags=0x2000,list={{type=0x2000,dur=3}}})
check(not delayed.bound,'spawnDelay 在出生时关闭出屏回收')
tick();tick();check(not delayed.bound,'spawnDelay 计时未满时仍保留槽位')
tick();check(delayed.bound,'spawnDelay 到点恢复出屏回收')
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
local spawn=upvalue(cards[3600],'spawn_bullet')
local filled=0;for _=1,2000 do if spawn(0,0,0,0,160,2) then filled=filled+1 end end
check(filled==2000,'原作2000个空槽可用')
check(spawn(0,0,0,0,160,2)==nil,'第2001发必须被原作弹池拒绝')
object.RawDel(objects[100]);if native then native.AfterFrame() end
check(spawn(0,0,0,0,160,2)~=nil,'释放槽位后可以复用')
reset()
print(('原作切割、变速、伴奏激光与文花帖回归通过：%d 项'):format(checks))
