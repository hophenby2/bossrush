-- 只验收 Boss 位置与运动语义，不按密度改动原作发弹参数；不接触玩家目录。
-- 来源：原作/ECL 中的 TH06/07/08/10 二进制，经 thecl -d <版本> -r -x 离线解释。
-- 指令语义核对克隆工程：TH06 EclManager.cpp、TH07 EclManager.cpp、
-- TH08 EclDependencies.cpp/EnemyManager.cpp、TH095 EclDependencies.cpp/EnemyMovement.cpp、
-- TH10 Enemy.cpp/EnemyEclDispatcher.cpp。TH095 尚缺二进制，只验证解释器通用语义。
-- 在游戏发行目录执行：luajit tools/check_boss_motion.lua
arg = { 'boss-motion' }
local original_popen = io.popen
if package.config:sub(1,1) == '\\' and debug.getinfo(io.popen).what == 'C' then
    -- check_stage 的引导段用 POSIX 命令枚举文件；Windows 的同等只读命令。
    local commands = {
        ['ls Resources/Special/ 2>/dev/null'] = 'dir /b "Resources\\Special" 2>NUL',
        ['ls Resources/BossBackGround/ 2>/dev/null'] = 'dir /b "Resources\\BossBackGround" 2>NUL',
        ["find mod THlib Resources -name '*.lua' 2>/dev/null"] =
            'dir /b /s "mod\\*.lua" "THlib\\*.lua" "Resources\\*.lua" 2>NUL',
    }
    io.popen = function(command) return original_popen(commands[command] or command) end
end
local file = assert(io.open('tools/check_stage.lua', 'rb'))
local setup = file:read('*a'); file:close()
assert(loadstring(setup:sub(1, assert(setup:find('if path == "--all" then', 1, true)) - 1)))()
io.popen = original_popen
local checks, cards = 0, {}
local function check(ok, why) assert(ok, why); checks = checks + 1 end
local function near(a, b) return math.abs(a - b) < 0.000001 end
boss.card.add = function(parts, level, _, id)
    cards[level] = cards[level] or {}
    for _, part in ipairs(parts) do cards[level][id] = part[1] end
end
for _, n in ipairs({31,32,33,34,35}) do dofile('mod/GAME/th' .. n .. '.lua') end

local function upvalues(root, name)
    local seen, found = {}, {}
    local function walk(value)
        local kind = type(value)
        if (kind ~= 'function' and kind ~= 'table') or seen[value] then return end
        seen[value] = true
        if kind == 'function' then
            for i = 1, 100 do
                local key, child = debug.getupvalue(value, i)
                if not key then break end
                if key == name then found[#found+1] = child end
                walk(child)
            end
        else
            for _, child in pairs(value) do walk(child) end
        end
    end
    walk(root)
    check(#found > 0, '没有找到真实实现：' .. name)
    return found
end
local function find(root, name) return upvalues(root, name)[1] end

-- TH06 SET_POSITION 在本条指令内夹框，后面的 MOVE_TO 从实际位置取快照。
local H = find(cards[30], 'H')
local b = {x=0,y=0,th06_actor={bounds={32,48,352,128}}}
H.position(b, 0, 0, 0)
check(b.x == -160 and b.y == 176, 'TH06 左上原点与即时夹框')
H.move_to(b, 60, 192, 128, 0, 1)
check(b.th06_actor.move.x == -160 and b.th06_actor.move.y == 176, 'TH06 插值起点取夹框后位置')
H.move_dir(b, 60, 0, 2, 1)
check(near(b.th06_actor.move.dx,60), 'TH06 极坐标插值距离为速度乘帧数再除二')
local saved={x=5,y=9,dx=12,dy=18,t=7,n=60}
b={x=17,y=23,th06_previous_motion={stage=6,group=1,mode='interp',move=saved,
    angle=1.2,speed=3,angular=0.1,accel=0.2,axisx=2,axisy=1,bounds={32,48,352,120}}}
local a=H.new_actor({actors={}},b,6,17,true,{epoch=0,group=1})
check(a.move==saved and a.angle==1.2 and a.bounds[4]==120,
      'TH06 同一敌机切换子程序保留插值、方向与活动框')
a=H.new_actor({actors={}},b,6,9,true,{epoch=0,group=12})
check(a.mode=='axis' and a.move==nil and a.bounds==nil,
      'TH06 不把六面正式 Boss 的运动上下文传给道中 Boss')

-- TH08 的普通卡需要有独立来源，不能让单卡练习把框外的框架出生点当插值起点。
local mapped = 0
for _, card in pairs(cards[29]) do
    local source = card.th08_motion_source
    if source then
        mapped = mapped + 1
        check(source.file:match('^ecldata') and source.sub >= 0, 'TH08 阶段来源完整')
    end
end
check(mapped == 99, 'TH08 普通 Boss 阶段共 99 个来源上下文')
local c = cards[29][427]
local source = c.th08_motion_source
local actor = {x=-224,y=384,th08_motion_carry={key=source.key,x=71,y=133}}
c.frame(actor)
check(actor.x==-224 and actor.y==384, 'TH08 卡初始化以前不推进运动')
c.init(actor)
check(actor.x==71 and actor.y==133, 'TH08 普通非符继承上张卡的位置')
c.del(actor)
check(actor.th08_motion_carry.x==71, 'TH08 结束时保存实际位置')
actor={x=-224,y=384}
cards[29][470].init(actor)
check(actor.x==-96 and actor.y==272, 'TH08 一面道中 SET_POSITION(96,-48) 翻转原点')
cards[29][470].del(actor)
c=cards[29][397]
source=c.th08_motion_source
actor={th08_motion_carry={key=source.key,x=80,y=144}}
c.init(actor)
check(actor.x==80 and actor.y==144, 'TH08 符卡 MOVE_TO 从实际位置开始')
c.frame(actor)
local progress=1-(1-1/90)^2
check(near(actor.x,80*(1-progress)) and near(actor.y,144+(96-144)*progress),
      'TH08 首帧按 1/90 二次减速插值，而非瞬移到终点')
c.del(actor)

-- TH095 的随机方向先归一化，然后反射；活动框在每一帧生效，而非只修正目标角。
local sg_ease = find(cards[31], 'sg_ease')
check(near(sg_ease(function(t) return t*t end)(0.5),0.25), 'TH095 保留函数形式缓动')
local sg_move = find(cards[31], 'sg_move')
local old_new, old_wait, old_float, old_player = task.New, task.Wait, ran.Float, player
local pending
task.New = function(_, fn) pending=coroutine.create(fn); return pending end
task.Wait = function() coroutine.yield() end
local function advance(n)
    for _=1,n do local ok,err=coroutine.resume(pending);assert(ok,err) end
end
local o, state = {x=0,y=128}, {}
sg_move(o,state,200,128,20,0,{-160,48,160,128})
advance(20)
check(o.x==160 and o.y==128, 'TH095 每帧按原作框端点夹位置')
ran.Float = function(_,lo,hi) return lo+(hi-lo)*0.75 end
player={x=-100,y=-176}
o,state={x=0,y=128},{}
find(cards[31],'sg_bmove')(o,state,60,0,1,{-160,48,160,128})
advance(1)
check(o.y>128,'TH095 左侧扇区超过 π 时先折回负角，避免上下方向反转')
task.New,task.Wait,ran.Float,player=old_new,old_wait,old_float,old_player

-- TH07 的贴框移动方向是本帧目标减当前位置；新直线段覆盖旧圆运动。
local steppers = upvalues(cards[32],'bstep')
for _, step in ipairs(steppers) do
    o={x=0,y=0,_mv={x0=0,y0=0,dx=60,dy=60,n=29,t=60,ease=0}}
    step(o)
    check(near(o.x,30) and near(o.y,30), 'TH07 从快照求插值目标')
end
for _, move in ipairs(upvalues(cards[32],'bmove')) do
    o={x=0,y=0,_orb={}}
    move(o,60,4,20,30)
    check(o._mv~=nil, 'TH07 新位移建立插值状态')
end
local th07=_editor_class.TH34
local move=upvalues(cards[32],'bmove')[1]
o={x=-224,y=384}
th07.th07_motion_begin(o,4432,move)
check(o.x==0 and o.y==96 and o._mv==nil, 'TH07 三面本体继承宿主落位，Sub32 没有重新进场')
o.x,o.y=79,117
th07.th07_motion_end(o)
th07.th07_motion_begin(o,4433,move)
check(o.x==79 and o.y==117, 'TH07 同一 Boss 换卡继承位置')
check(o._mv.x0==79 and o._mv.y0==117 and o._mv.t==120,
      'TH07 Sub42 从继承位置移动 120 帧')
th07.th07_motion_end(o)
th07.th07_motion_begin(o,4392,move)
check(o.x==0 and o.y==112, 'TH07 六面正式 Boss 的宿主终点为原生 (192,112)')
th07.th07_motion_begin(o,4430,move)
check(o.x==-224 and o.y==96 and o._box==nil,
      'TH07 道中爱丽丝保留阶段显式 SET_POS，60 帧后才启用活动框')
th07.th07_motion_begin(o,4403,move)
check(o._box==nil and o._mv.dx==128 and o._mv.dy==-128,
      'TH07 妖梦餓王剣关闭活动框，目的地原生 (320,256)')
th07.th07_motion_begin(o,4408,move)
check(o._mv.x0+o._mv.dx==128 and o._mv.y0+o._mv.dy==0 and o._box==nil,
      'TH07 畜趣剑保留 Normal 行入口 (320,224)，不跳过这条位移')
th07.th07_motion_begin(o,4457,move)
check(o._mv.t==120 and o._mv.y0+o._mv.dy==112,
      'TH07 冬符保留 Normal 行的 120 帧移动，不套用 Lunatic 分支')

-- TH10 两路运动的编号、首帧采样、圆心、随机方向与宿主活动框。
local cls=_editor_class.TH35
for _,sample in ipairs({{-97.46,-97.45999908447266},{-1.01,-1.0099999904632568},
    {-0.29,-0.28999999165534973},{1.24,1.2400000095367432},
    {133.719999,133.72000122070312},{100.001,100}}) do
    -- 预期值独立用 float32 的加/乘/floor/存储顺序计算，覆盖正负小数边界。
    check(near(cls.t10_motion_quantize(sample[1]),sample[2]),'TH10 单精度坐标取整')
end
local stationary=cls.t10_motion_quantize(-97.46)
for _=1,1200 do stationary=cls.t10_motion_quantize(stationary) end
check(near(stationary,-97.45999908447266),'TH10 静止负坐标不因 double 取整持续漂移')
check(near(cls.t10_motion_ease(4,0.5),0.75), 'TH10 二次减速不再线性近似')
check(near(cls.t10_motion_ease(1,0.5),0.25), 'TH10 二次加速')
local attach=find(cards[33],'ecs_attach')
local sync=find(cards[33],'ecs_sync')
local step=find(cards[33],'ecs_step')
local pos_time=find(cards[33],'m_pos_time')
local circle=find(cards[33],'m_circle')
o={};attach(o,10,20);sync(o)
check(o.x==10 and o.y==204, 'TH10 横坐标已经居中，仅翻转纵坐标')
pos_time(o,'off',10,4,110,120)
step(o);check(near(o.tx,10) and near(o.ty,20),'TH10 插值首帧采样为零')
for _=1,5 do step(o) end
check(math.abs(o.tx-85)<0.02 and math.abs(o.ty-95)<0.02,'TH10 插值中点使用原作缓动')
o={};attach(o,10,20);sync(o)
circle(o,'off',0,0,30,0)
step(o)
check(near(o.tx,40) and near(o.ty,20),'TH10 从出生位置保存圆心，不绕世界原点转')
check(near(find(cards[33],'t10_final_angle')(o),0), 'TH10 FINAL_ANGLE 使用世界位移，不把圆心当速度')
circle(o,'off',math.pi/2,0,30,0)
step(o)
check(near(find(cards[33],'t10_final_angle')(o),3*math.pi/4),
      'TH10 改变圆周位置后的世界位移角')
o={};attach(o,0,0);sync(o)
find(cards[33],'m_limit')(o,0,96,280,64)
local random=find(cards[33],'m_rand')
ran.Float=function(_,lo,hi) return (lo+hi)/2 end
o.ecs.base.x=120;o.ecs.off.x=-120;sync(o)
player={x=100,y=0};random(o,'off',60,4,2)
check(near(o.ecs.off.scal.a0,math.pi/4),'TH10 随机移动判断世界位置，不判断偏移通道位置')
check(o.ecs.off.scal.mode==4,'TH10 随机位移保留缓动参数')
find(cards[33],'m_limit_clear')(o)
check(o.ecs.lim==nil and o.ecs.bounds.w==280,'TH10 关闭夹框不抹掉随机方向仍读取的边界参数')
ran.Float,player=old_float,old_player
check(cls.t10_boss_entry[3643].bounds[4]==100,'TH10 一面宿主框高度来自原生 Boss()')
check(cls.t10_boss_entry[3660].bounds[4]==64,'TH10 三面宿主框不套用一面高度')
check(cls.t10_boss_entry[3666].y==128,'TH10 六面宿主直接落位于原生 y=128')
print(('Boss 坐标、移动与活动框回归通过：%d 项'):format(checks))
