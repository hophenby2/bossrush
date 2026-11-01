-- 骚符的独立时序/参数验收。依据 ecldata4.ecl Sub121–126 的 Lunatic 分支；
-- 源文件 SHA256 fad7b7a81a179c9c75e97111de3b2492df8b70d450967be7f3a063046f722c7f。
-- 这里保留的是人工读原指令得出的事件，不在游戏里执行 ECL，也不读取生成的事件表。
local f=assert(io.open('tools/check_original_ecl_fidelity.lua','rb'))
local setup=f:read('*a');f:close()
local env=assert(loadstring(setup:sub(1,assert(setup:find('local function upvalue',1,true))-1)
    ..'\nreturn {class=C,cards=cards,objects=objects,make=make}'))()
local C,objects=env.class,env.objects
local checks,clock,births,shots=0,0,{},{}
local function check(ok,why) assert(ok,why);checks=checks+1 end
local function near(a,b) return math.abs(a-b)<0.002 end
ran.Float=function(_,a,b) return (a+b)/2 end
local ghost_init=C.TH34_poltergeist_ghost.init
C.TH34_poltergeist_ghost.init=function(o,...)
    ghost_init(o,...)
    o.test_birth=clock
    births[#births+1]={t=clock,object=o,x=o.x,y=o.y}
end
local function shoot(o,ox,oy,op,sprite,color,c1,c2,v1,v2,a1,a2,cmd)
    shots[#shots+1]={t=clock,object=o,x=o.x,y=o.y,op=op,sprite=sprite,color=color,
        c1=c1,c2=c2,v1=v1,v2=v2,a1=a1,a2=a2}
end
local replaced=false
for i=1,30 do
    local name=debug.getupvalue(C.TH34_poltergeist_ghost.frame,i)
    if name=='shoot6' then debug.setupvalue(C.TH34_poltergeist_ghost.frame,i,shoot);replaced=true;break end
end
check(replaced,'截取正式 Lua 幽灵的发弹入口')
local owner={x=0,y=96,rot=0,timer=0,ani=0,hp=10000,maxhp=10000,colli=true,_live=true}
local card=env.cards[4441]
card.init(owner)
for t=0,1850 do
    clock=t
    card.frame(owner);task.Do(owner)
    -- 原作 SpawnEnemyEx 出生即执行t=0，敌机扫描仍在当帧处理新槽。
    -- Windows 引擎也遍历可增长的更新链，不能用旧桩件的固定数组长度。
    local i=1
    while i<=#objects do
        local o=objects[i]
        if IsValid(o) then
            if o.class.frame then o.class.frame(o) end
            o.x,o.y=o.x+(o.vx or 0),o.y+(o.vy or 0)
            o.timer,o.ani=o.timer+1,o.ani+1
        end
        i=i+1
    end
    owner.ani,owner.timer=owner.ani+1,owner.timer+1
end
local function count(t,partner)
    local n=0
    for _,b in ipairs(births) do
        if b.t==t and b.object.pg_partner==partner then n=n+1 end
    end
    return n
end
check(count(354,true)==22,'Sub122/123首拍：左4+6，右6+6')
for _,t in ipairs({414,474,534,634,694,754,814,914}) do
    check(count(t,true)==24,'伴奏两次同步调用，每拍合计24只：'..t)
end
check(count(614,true)==0 and count(615,true)==0,'伴奏一轮是280帧，不能误写成260帧')
for _,base in ipairs({206,718,1230,1742}) do
    for j=0,35 do check(count(base+j*3,false)==1,'Sub124每三帧一只：'..(base+j*3)) end
    if base+108<=1850 then check(count(base+108,false)==1,'108帧后同帧进入下一组') end
end
local first={}
for _,s in ipairs(shots) do
    local o=s.object
    local born
    for _,b in ipairs(births) do if b.object==o then born=b.t;break end end
    check(s.t-born==119,'出生帧立即执行后，第119帧发弹；不多走一步')
    if o.pg_partner then
        check(s.op==67 and s.sprite==1 and s.c1==9 and s.c2==1 and s.v1==1 and s.v2==1,
            'Sub126 i3!=0 的L行：九发绝对圆环，速度1')
        check(s.color==2,'伴奏的i0=4映射红色色档2')
    else
        check(s.op==64 and s.sprite==6 and s.c1==1 and s.c2==3,'主奏一发三层自机狙')
        first[o.pg_variant]=first[o.pg_variant] or s
    end
end
for variant,expected in pairs({[0]={325,2.5,1.5,2},[1]={433,3,1.5,10},
    [2]={541,3.4,1.6,6},[3]={649,3.6,1.7,13}}) do
    local s=assert(first[variant])
    check(s.t==expected[1] and s.v1==expected[2] and s.v2==expected[3] and s.color==expected[4],
        '四种主奏幽灵的首发帧、速度与色档：'..variant)
end
local raw=OriginalANM.load(7,'stg4enm')
for _,b in ipairs(births) do
    check(b.object._original_actor.vm.id==raw.ids[149+b.object.pg_variant],
        '八路互斥分支按传入类型选ANM，不能全部落到156')
end
-- 使用非零曲率单独验收第60帧转弯和第120帧发弹前的119次位移。
clock=2000
local g=New(C.TH34_poltergeist_ghost,0,0,2,0,0.01,false,{speed=3.4,slow=1.6,spread=0})
for i=1,59 do clock=2000+i-1;g.class.frame(g);g.ani=g.ani+1 end
check(near(g.x,59*1.2) and near(g.y,0),'前59次位移沿原方向')
local x,y=59*1.2,0
for i=1,60 do
    x=x+math.cos(i*.01)*1.2;y=y-math.sin(i*.01)*1.2
    clock=2058+i;g.class.frame(g);g.ani=g.ani+1
end
check(near(g.x,x) and near(g.y,y),'第60至119次位移转弯，Y轴取反')
local oldx,oldy=g.x,g.y
clock=2119;g.class.frame(g)
check(not IsValid(g) and near(g.x,oldx) and near(g.y,oldy),'t=120先发弹并终止，不再位移')
card.del(owner)
for _,o in ipairs(objects) do check(not IsValid(o),'换卡清除演奏者、幽灵和控制对象') end
print(('骚符人工转译验收通过：%d项，%d只幽灵，%d次发弹'):format(checks,#births,#shots))
