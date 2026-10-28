-- 实际 Rank 模块与框架事件回归，不读取玩家 User/ 或 replay/。
local count=0
local function check(v,label) assert(v,label);count=count+1 end
local function near(a,b) return math.abs(a-b)<1e-8 end
local objects={}
lstg={var={},tmpvar={}}
stage={current_stage={is_menu=false}}
IsValid=function(o) return o and o._live~=false end
New=function(class,...)
    local o={_live=true,status='normal',group=0,x=0,y=0,vx=0,vy=0}
    objects[#objects+1]=o;if class.init then class.init(o,...) end;return o
end
ObjList=function(group)
    local i=0
    return function() repeat i=i+1;if not objects[i] then return end until objects[i].group==group and IsValid(objects[i]);return i,objects[i] end
end
local R=dofile('THlib/rank.lua')
lstg.var.__rank_version=1
check(R.value()==50 and R.factor()==1 and lstg.var.rank==nil,'HUD getter 不创建 Rank 状态或改变零帧存档')
local function reset(value)
    objects={};lstg.var={__rank_version=1,dead=0,getsc=0,man=0};R.reset();R.add((value or 50)-50);R.inObjects=false
end
reset();check(R.value()==50 and R.factor()==1,'初始 Rank 50，原始倍率')
for _=1,1200 do R.step() end
check(R.value()==51 and lstg.var.rank.frames==1200,'每秒自然 +0.05，整数积累无漂移')
R.add(1000);R.step();check(R.value()==100 and near(R.factor(),1.1),'上限 100 / 110%')
R.miss();check(R.value()==92 and lstg.var.rank.misses==1,'中弹减 8')
R.add(-1000);R.miss();check(R.value()==0 and near(R.factor(),0.9),'下限 0 / 90%')
stage.current_stage.is_menu=true;local frames=lstg.var.rank.frames;R.step();check(lstg.var.rank.frames==frames,'菜单不自然成长');stage.current_stage.is_menu=false
local shot={init=function(o,g,x,y,vx,vy) o.group=g;o.x=x;o.y=y;o.vx=vx;o.vy=vy end}
local function moveAll(fn)
    R.beforeObjects();if fn then fn() end
    for _,o in ipairs(objects) do if IsValid(o) then o.x=o.x+o.vx;o.y=o.y+o.vy end end
    R.afterObjects()
end
reset(100)
local a=New(shot,1,0,0,3,-4);local b=New(shot,5,0,0,2,1);local c=New(shot,12,0,0,-2,1)
local hero=New(shot,4,0,0,3,-4);local playerShot=New(shot,3,0,0,3,-4);local npc=New(shot,2,0,0,3,-4)
moveAll();check(near(a.x,3.3) and near(a.y,-4.4) and near(b.x,2.2) and near(c.x,-2.2),'普通、不可消和第二敌弹组统一加速')
check(hero.x==3 and playerShot.x==3 and npc.x==3,'自机、自机弹和敌机移动不受弹速倍率影响')
moveAll();check(near(a.x,6.6) and a.vx==3 and a.vy==-4,'倍率不写回原速度，不会逐帧指数累乘')
reset(100);local manual=New(shot,1,5,8,0,0)
moveAll(function() manual.x=manual.x+4;manual.y=manual.y-2 end)
check(near(manual.x,9.4) and near(manual.y,5.8),'脚本直接累加坐标也按同一倍率移动')
R.add(-100);moveAll(function() manual.x=manual.x+4 end);check(near(manual.x,13),'已存在的弹随 Rank 降低立即减速')
reset(100);local newborn
moveAll(function() newborn=New(shot,1,80,90,2,0) end)
check(near(newborn.x,82.2),'ObjFrame 内新生成的弹出生当帧也应用倍率')
reset(100);local warp=New(shot,1,180,0,0,0)
moveAll(function() warp.x=-180 end);check(warp.x==-180,'穿屏传送不被倍率放大')
reset(100);local fast=New(shot,1,0,0,100,0);moveAll();check(near(fast.x,110),'真正的高速直线弹仍应用倍率')
reset(100);local fixed=New(shot,1,0,0,2,0);fixed.rank_speed=false;moveAll();check(fixed.x==2,'支持特定固定结构显式退出位移倍率')
-- 实际中弹事件与初始化入口。
item={};max=math.max;int=math.floor;SearchStageLevel={};ext={achievement={get=function() end}}
GetGlobal=function() return 'reimu_player' end;ran={Int=function(_,a) return a end}
dofile('THlib/item/item_func.lua');reset(60)
item.PlayerMiss({name='Reimu',protect=0});check(R.value()==52 and lstg.var.dead==1,'真正 PlayerMiss 同时增加失误并降低 Rank')
item.PlayerInit();check(R.value()==50 and lstg.var.rank.misses==0,'新局初始化重置 Rank')
-- 使用实际收卡与 HP 接口，验证普通非符、特殊收卡、重复结算和原同卡多 Boss。
local f=assert(io.open('THlib/enemy/boss_system.lua','rb'));local text=f:read('*a');f:close()
local first=assert(text:find('function system:GetBonus(b)',1,true));local last=assert(text:find('---符卡结算',first,true))
local system={finishSpellHist=function() end}
assert(loadstring('local system=...\n'..text:sub(first,last-1)))(system)
local hpStart=assert(text:find('function system:setHP(maxhp, hp)',1,true));local hpEnd=assert(text:find('---设置掉落物',hpStart,true))
assert(loadstring('local system=...\n'..text:sub(hpStart,hpEnd-1)))(system)
AddMoney=function() end
local card={card_id=12,is_sc=true,is_combat=true,t1=60,t3=3600,hp=1000}
local function boss(cardValue)
    local o={current_card=cardValue,is_sc=cardValue.is_sc,chip_bonus=true,bombchip_bonus=true,sc_bonus=100,hp=0,otherboss={}}
    R.beginCard(o,cardValue);return o
end
reset();local left,right=boss(card),boss(card);left.otherboss={right};right.otherboss={left}
system.boss=left;system:CheckGetCard();system:CheckGetCard();check(R.value()==53 and lstg.var.rank.captures==1,'真实收卡额外 +3，重复结算不重复加 Rank')
R.beginCard(left,{card_id=14,is_sc=true,t1=60,t3=3600})
system.boss=right;system:CheckGetCard();check(R.value()==53,'同卡一侧已经进入下一卡，旧卡仍只奖励一次')
R.beginCard(left,card);system.boss=left;system:CheckGetCard();check(R.value()==56,'下一次运行同一卡可再次提高 Rank')
reset();local nonspell=boss({card_id=13,is_sc=false,t1=60,t3=3600});system.boss=nonspell;system:CheckGetCard();check(R.value()==50,'非符收取不额外加 Rank')
reset();local special=boss(card);system.boss=special;system:SpecialCheckGetCard();check(R.value()==53,'特殊收卡入口也提高 Rank')
reset(100);local target=boss(card);system.boss=target;system:setHP(1000,400)
check(near(target.maxhp,1100) and near(target.hp,440) and card.hp==1000,'Boss HP 按开卡倍率提高，不修改共享卡片参数')
R.add(-100);target.hp=300;R.verifyHealth(target);check(near(target.maxhp,1100) and target.hp==300,'中途 Rank 降低不改变当前卡血量或回血')
target.maxhp=2000;target.hp=500;R.verifyHealth(target);check(near(target.maxhp,2200) and near(target.hp,550),'脚本重新设置血量仍沿用本卡快照，避免丢失倍率')
R.beginCard(target,card);system:setHP(1000);check(near(target.hp,900),'下一卡采样新的低 Rank')
reset(100);local survival=boss({is_sc=true,is_combat=true,t1=3600,t3=3600});system.boss=survival;system:setHP(10000000);check(survival.hp==10000000,'耐久卡不改变原时限与占位 HP')
local proxy=boss(card);proxy._rank_hp_proxy=true;proxy.maxhp,proxy.hp=1500,1200;proxy._rank_hp_ready=true;proxy._rank_hp_last=1100;R.verifyHealth(proxy);check(proxy.hp==1200,'镜像血条不把子机已经缩放的 HP 再乘一次')
-- 实际 DoFrame 调用顺序：先逻辑与出生，再倍率校正，最后边界和碰撞。
reset(100);local bullet=New(shot,1,0,0,10,0);local frozen=false
stage.current_stage={is_menu=false,timer=0,frame=function() end};stage.group={};GROUP={}
GetInput=function() end;GetCurrentSuperPause=function() return 0 end
GameRevive={active=function() return false end,frame=function() return frozen end}
lstg.system={frame=function() end};task={Do=function() end}
ObjFrame=function() bullet.x=bullet.x+bullet.vx end
local checked
BoundCheck=function() checked=bullet.x end;CollisionCheck=function() check(near(bullet.x,11),'碰撞使用校正后的敌弹坐标') end
UpdateXY=function() end;AfterFrame=function() end;ext={notUIdraw=false,boss_ui={frame=function() end}}
f=assert(io.open('THlib/ext/ext.lua','rb'));text=f:read('*a');f:close()
first=assert(text:find('local function DoFrame()',1,true));last=assert(text:find('_G.DoFrame = DoFrame',first,true))
assert(loadstring(text:sub(first,last-1)..'\n_G.DoFrame=DoFrame'))();DoFrame()
check(near(checked,11) and lstg.var.rank.frames==1,'实际循环在碰撞和越界检查之前校正弹速')
frozen=true;DoFrame();check(lstg.var.rank.frames==1 and near(bullet.x,11),'答题冻结期间 Rank 和敌弹都不推进')
lstg.var.__rank_version=nil;R.beforeObjects();bullet.x=0;bullet.vx=10;bullet.x=bullet.x+bullet.vx;R.afterObjects();check(bullet.x==10 and R.factor()==1,'旧录像没有 Rank 标记时保持原运动与 HP')
print('Rank 回归通过：'..count..' 项。')
