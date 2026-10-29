-- 正式自机、敌机碰撞、阶段掉落、联机独立选择与帧循环回归；只写调用方的临时目录。
local R=dofile(assert(arg[1])..'/tools/save-tests/runtime.lua');local root=R.root
local function load(path) return dofile(root..'/'..path) end
local count=0;local function check(v,label) assert(v,label);count=count+1 end
local function near(a,b) return math.abs(a-b)<1e-7 end
local noop=function() end
local function random()
    local g={v=1};function g:Seed(v) self.v=v%2147483646+1 end
    function g:Int(a,b) self.v=self.v*48271%2147483647;return a+math.floor(self.v/2147483647*(b-a+1)) end
    function g:Float(a,b) return a+(b-a)*self:Int(0,1000000)/1000000 end
    function g:Sign() return self:Int(0,1)*2-1 end;return g
end
Rand=random;ran=Rand()
abs=math.abs;max=math.max;min=math.min;int=math.floor;SQRT2_2=2^-0.5
cos=function(a) return math.cos(math.rad(a)) end;sin=function(a) return math.sin(math.rad(a)) end
acos=function(x) return math.deg(math.acos(x)) end
Forbid=function(v,a,b) return max(a,min(b,v)) end
Dist=function(a,b) return ((a.x-b.x)^2+(a.y-b.y)^2)^0.5 end
DefaultRenderFunc=noop;PlaySound=noop;GameNet=nil;GameRank=nil
lstg={var={},tmpvar={},world={l=-192,r=192,b=-224,t=224,pl=-192,pr=192,pb=-224,pt=224}}
SearchStageLevel={};SetCurSystem=noop;GetGlobal=function(k) return lstg.var[k] end
for _,name in ipairs({'CopyImage','CopyAnimation','LoadTexture','LoadImage','LoadPS','LoadImageGroup','LoadAnimation','SetImageState','SetAnimationState','SetAnimationCenter','SetImageCenter','LoadImageFromFile','SetImageScale'}) do _G[name]=noop end
GetTextureSize=function() return 512,512 end
Color=function(a,r,g,b) return {a=a,r=r,g=g,b=b} end
local drawn={};SetViewMode=noop;RenderRect=noop
ui={RenderText=function(_,font,text,x,y,scale,color) drawn[#drawn+1]={text=text,color=color,x=x,y=y,mode=lstg.viewmode} end}
GetAttr=function(o,k) return rawget(o,k) end;SetAttr=rawset
load('THlib/lib/Lobject.lua');load('THlib/plus/Utility.lua');load('THlib/eventListener.lua')
task={Do=noop,Clear=noop,New=noop,SetMode={[1]=function(x) return x end,[2]=function(x) return x end,[3]=function(x) return x end}}
object.EnemyNontjtDo=noop;object.DelServants=noop;object.RawDel=function(o) o._live=false end;object.Kill=function(o) o._live=false end
local objects={}
IsValid=function(o) return type(o)=='table' and o._live==true end
New=function(class,...)
    local o={class=class,_live=true,timer=0,ani=0,x=0,y=0,vx=0,vy=0,dx=0,dy=0,rot=0,hscale=1,vscale=1,group=0,world=1,a=1,b=1,colli=true}
    objects[#objects+1]=o;assert(type(class[1])=='function','类未整理');class[1](o,...);return o
end
ObjList=function(group) local i=0;return function() repeat i=i+1 until not objects[i] or (objects[i]._live and objects[i].group==group);if objects[i] then return i,objects[i] end end end
Include=function(path) return load(path:gsub('\\','/')) end
System=Class(object);BulletBreak_Table=Class(object)
PlayerWalkImageSystem=function() return {frame=noop,render=noop} end
EnemyWalkImageSystem=PlayerWalkImageSystem
local D=load('THlib/drops.lua');local Q=load('THlib/ext/ext_quiz.lua')
-- 图形桩保留真实对象池 / 数字回调语义，实际贴图与渲染另由安卓原生回归验证。
NewObject=function(c) return New(c) end
Del=function(o) if o.class[2] then o.class[2](o) end;o._live=false end
bullet=Class(object,{init=function(o,style)
    if not style then return end
    o.imgclass=style;o.class=bullet;o.group=GROUP.INDES;o.a=4;o.b=4;o._layer=-200
end,render=function(o) drawn[#drawn+1]={bullet=true,x=o.x,y=o.y,alpha=o._a} end},true)
ball_mid={}

load('THlib/player/player.lua');load('THlib/player/reimu/reimu.lua');load('THlib/player/marisa/marisa.lua');load('THlib/player/chiruno/chiruno.lua')
local include=Include;Include=noop;load('THlib/enemy/enemy.lua');Include=include
local cooldown=Class(player_class,{init=function(p) player_class.init(p);p.shots=0 end,shoot=function(p) p.shots=p.shots+1;p.nextshoot=4 end})
local targetClass=Class(enemy,{init=function(o) enemybase.init(o,10000) end})
InitAllClass();item={};ext={replay={IsReplay=function() return false end},achievement={get=noop}}
AddMoney=noop;load('THlib/item/item_func.lua')
stage={current_stage={is_menu=false,timer=0}};KeyState={};KeyStatePre={}
local function reset()
    GameNet=nil;objects={};lstg.var={__drops_version=1,ran_seed=18373,player_name='reimu_player',current_system=''}
    item.PlayerInit();object.EnemyNontjtDo=noop;player=nil
end
local function hero(class,slot)
    local p=New(class);if slot==2 then p._net_slot=2;D.bind(p) end;player=p;lstg.player=p;return p
end
local function shots(class,blue,enabled,start)
    reset();if enabled==false then lstg.var.__drops_version=nil;lstg.var.upgrades=nil end
    local p=hero(class);if class==chiruno_player then p._playersys:removeFrameEvent('frame.ice') end;if D.enabled() then lstg.var.upgrades.players[1].blue=blue*100 end
    KeyState={shoot=true}
    for i=start or 0,(start or 0)+239 do p.timer=i;p._playersys:frame();check(p.timer==i,'射击虚拟时钟不改变真实自机计时') end
    local n=0;for _,o in ipairs(objects) do if o.group==3 then n=n+1 end end
    return n,p.shots
end
for _,class in ipairs({reimu_player,chiruno_player}) do
    local base=shots(class,100);local legacy=shots(class,100,false)
    check(base==legacy and base>0,'100 射速与原始发弹数量一致')
    local faster=shots(class,200);check(faster==base*2,'200 射速实际弹数翻倍')
    check(shots(class,50)==base/2,'50 射速实际弹数减半')
    check(near(shots(class,110),base*1.1),'110 射速保留小数累积，不被取整吞掉')
    check(shots(class,100,true,1)==shots(class,100,false,1),'首次回调 timer=1 也与原始节拍一致')
end
local _,base=shots(cooldown,100);local _,fast=shots(cooldown,200);local _,slow=shots(cooldown,50)
check(base==60 and fast==120 and slow==30,'nextshoot 冷却按同一虚拟节拍计算，不重复扣减')
-- 魔理沙激光的直伤也与红字和射速分别相乘。
local function laserDamage(red,blue)
    reset();local p=hero(marisa_player);local state=lstg.var.upgrades.players[1];state.red=red*100;state.blue=blue*100
    local damage=0;local enemy={x=0,y=p.y,a=1000,colli=true,hp=10000,maxhp=10000,class={base={take_damage=function(_,n) damage=damage+n end}}}
    object.EnemyNontjtDo=function(fn) fn(enemy) end;marisa_player.IsInLaser=function() return true end
    KeyState={shoot=true};for i=0,119 do p.timer=i;p._playersys:frame() end;return damage
end
local ray=laserDamage(100,100);check(ray>0 and near(laserDamage(200,100),ray*2),'魔理沙激光火力倍率生效')
check(near(laserDamage(100,200),ray*2),'魔理沙持续激光射速倍率生效')
-- 移动端开关关闭当帧停火；桌面原有短连射与旧录像仍沿用原规则。
local function releaseBurst(touch,version,coop,guestTouch)
    reset();AndroidPlatform=touch and {} or nil;lstg.var.__touch_toggle_version=version
    local p=hero(reimu_player);if coop then GameNet={host=function() return true end};p.key={shoot=true,touch_shoot=guestTouch} end
    KeyState={shoot=true};p._playersys:frame();check(p.__shoot_flag,'射击按下正常发弹')
    KeyState={};if coop then p.key.shoot=false end;p._playersys:frame()
    local stopped=not p.__shoot_flag;AndroidPlatform=nil;GameNet=nil;return stopped
end
check(releaseBurst(true,1),'移动端新局关闭时立即停火')
check(not releaseBurst(false,1),'桌面按键保留原有15帧短连射')
check(not releaseBurst(true,nil),'旧录像无新标记时保留旧行为')
check(releaseBurst(false,1,true,true),'Windows 房主收到移动端关闭也立即停火')
check(not releaseBurst(true,1,true,false),'Android 房主不改变桌面客机原有松键行为')
-- 真实自机类的绘制尺寸随当前火力线性变化，绘制后恢复物理对象缩放。
reset();local visualPlayer=hero(reimu_player);lstg.var.upgrades.players[1].red=15000
local defaultDraw,rawRender=DefaultRenderFunc,Render
local defaultCalls,trailCalls={},{}
DefaultRenderFunc=function(o) defaultCalls[#defaultCalls+1]={h=o.hscale,v=o.vscale,img=o.img} end
Render=function(img,x,y,rot,h,v) trailCalls[#trailCalls+1]={h=h,v=v,img=img} end
local visualShots={
    New(reimu_player.bullets.square,0,0,10,90,.3),New(reimu_player.bullets.needle,0,0,10,90,.3),
    New(reimu_player.bullets.trail,0,0,10,90,5,.3),New(marisa_player.bullets.main,0,0,10,90,.3),
    New(marisa_player.bullets.missile,0,0,10,90,.3),New(marisa_player.bullets.missile_ef,0,0,.3,5),
    New(chiruno_player.bullets.main,0,0,10,90,.3),
}
for _,o in ipairs(visualShots) do
    o.hscale=.8;o.vscale=1.2;local a,b,dmg=o.a,o.b,o.dmg;o.class[4](o)
    local call=defaultCalls[#defaultCalls]
    check(near(call.h,1.2) and near(call.v,1.8),'火力150使正式子弹宽高均乘1.5')
    check(o.hscale==.8 and o.vscale==1.2 and o.a==a and o.b==b and o.dmg==dmg,'绘制恢复缩放，不累乘尺寸或改写碰撞及伤害')
end
local trace=visualShots[3];trace.smear={{x=0,y=0,rot=90,alpha=40}};trace.class[4](trace)
check(near(trailCalls[1].h,1.2) and near(trailCalls[1].v,1.8),'追踪弹拖影与弹体按相同比例放大')
D.apply(1,1);trace.class[4](trace);check(near(defaultCalls[#defaultCalls].h,.8*1.55),'已经在场的子弹立即使用提升后的当前火力')
lstg.var.upgrades.players[2].red=25000;trace._drop_owner=2;trace.class[4](trace)
check(near(defaultCalls[#defaultCalls].h,2) and near(defaultCalls[#defaultCalls].v,3),'联机 P2 子弹按各自火力放大')
DefaultRenderFunc=function() error('绘制测试错误') end
check(not pcall(D.renderBullet,trace) and trace.hscale==.8 and trace.vscale==1.2,'绘制异常也恢复基准尺寸')
DefaultRenderFunc=function(o) defaultCalls[#defaultCalls+1]={h=o.hscale,v=o.vscale} end
lstg.var.__drops_version=nil;D.renderBullet(trace);check(defaultCalls[#defaultCalls].h==.8,'旧录像保持原尺寸')
-- 魔理沙的光束沿弹道延伸，只按火力放大横向宽度与发射光点。
reset();local beamPlayer=hero(marisa_player);lstg.var.upgrades.players[1].red=15000
beamPlayer.fire=1;beamPlayer.nextshoot=0
local oldLaser,oldPlayerRender=marisa_player.CreateLaser,player_class.render;local widths={}
marisa_player.CreateLaser=function(_,x,y,a,w) widths[#widths+1]=w end;player_class.render=noop
marisa_player.render(beamPlayer)
check(#widths==4 and near(widths[1],42),'魔理沙四条光束的宽度也按火力150放大1.5倍')
marisa_player.CreateLaser,player_class.render=oldLaser,oldPlayerRender
DefaultRenderFunc,Render=defaultDraw,rawRender
-- 标准弹、穿透弹与伤害转移均在命中处乘一次，弹体基准伤害不被写回。
reset();local p=hero(reimu_player);lstg.var.upgrades.players[1].red=15000
local e=New(targetClass);local shot={dmg=10,killflag=true,mute=true,_drop_owner=1}
enemybase.colli(e,shot);enemybase.colli(e,shot)
check(near(e.hp,9970) and shot.dmg==10,'穿透重复命中每次只乘一次火力')
local master=New(targetClass);e._master=master;e._dmg_transfer=.5;enemybase.colli(e,shot)
check(near(master.hp,9992.5),'传递到主机的伤害不会再次乘倍率')
lstg.var.upgrades.players[2].red=20000;shot._drop_owner=2;enemybase.colli(e,shot)
check(near(e.hp,9935),'碰撞使用子弹所属玩家的火力')
-- 选项运算与数值显示。
reset();D.apply(1,1);D.apply(1,4);local red,blue=D.values(1)
check(red==105 and blue==110,'红加法与蓝乘法')
D.apply(1,5);red,blue=D.values(1);check(red==115 and blue==105,'红+10蓝-5同时生效')
for _=1,200 do D.apply(1,9) end;red,blue=D.values(1)
check(red==1000 and blue>=1,'倍率有上界，下限不归零')
local seen={};for seed=1,300 do local pair=D.draw(seed*7919,7);check(pair[1]~=pair[2],'两个选项不重复');seen[pair[1]]=true;seen[pair[2]]=true;check(table.concat(pair,',')==table.concat(D.draw(seed*7919,7),','),'同种子与序号稳定重建') end
local total=0;for _ in pairs(seen) do total=total+1 end;check(total==#D.pool,'随机池中的所有道具都可抽到')
local function boss(id,others)
    local card={card_id=id,is_combat=true};local b={current_card=card,is_combat=true,otherboss=others or {}}
    D.beginCard(b,card);return b
end
reset();local a,b=boss(50),boss(50);a.otherboss={b};b.otherboss={a}
check(D.award(a) and not D.award(a) and not D.award(b) and #lstg.var.upgrades.queue==1,'同卡多 Boss 和重复结算只掉一次')
D.beginCard(a,a.current_card);D.beginCard(b,b.current_card)
check(D.award(b) and not D.award(a),'下次出现同一张卡仍可正常掉落')
local other=boss(51);other.timeout=true;check(not D.award(other),'普通符卡拖到超时不算击破')
other.time_sc=true;check(D.award(other),'完成耐久阶段可以掉落')
local fake=boss(52);fake.cannot_kill=true;check(not D.award(fake),'伪击破不掉落')
fake.cannot_kill=false;fake.is_combat=false;check(not D.award(fake),'非战斗过场不掉落')
reset();check(D.award(boss(53)) and D.award(boss(54)) and #lstg.var.upgrades.queue==2,'双 Boss 的不同卡分别排队，选择不重叠')
-- 接续只移除强化掉落；其它模式仍发放，已有队列也不能让接续战斗停下。
reset();local chainHero=hero(reimu_player);lstg.var.rogue_run={mode='chain'}
local oldGroup=stage.current_stage.group;stage.current_stage.group={_name='RogueChain'}
check(not D.award(boss(55)) and lstg.var.upgrades.count==0 and #lstg.var.upgrades.queue==0,'接续击破阶段不生成强化，也不消耗掉落序号')
local pending={id=1,age=100,options={1,2},picks={false,false},previous={{x=chainHero.x,y=chainHero.y}}}
lstg.var.upgrades.active=pending;lstg.var.upgrades.queue={pending}
local cached=Q.selection('drops',pending,nil,{D.optionLines(1),D.optionLines(2)})
check(not D.frame(stage.current_stage) and not lstg.var.upgrades.active and #lstg.var.upgrades.queue==0,'接续清除旧检查点待选掉落，不冻结战斗')
check(not IsValid(cached.walls[1]) and not IsValid(cached.labels[1]),'接续移除已经显示的强化弹体与文字')
for _,variant in ipairs({'single','dual','main'}) do
    reset();lstg.var.rogue_run={mode=variant=='main' and 'chain' or variant}
    stage.current_stage.group={_name=({single='RogueTen',dual='RogueDuo',main='BossRush'})[variant]}
    check(D.award(boss(56)) and #lstg.var.upgrades.queue==1,'其它模式正常掉落，残留接续记录不会影响主线：'..variant)
end
stage.current_stage.group=oldGroup
-- 从正式 Boss 系统取出击破回调，验证真实生命周期入口。
local bf=assert(io.open(root..'/THlib/enemy/boss_system.lua','rb'));local bs=bf:read('*a');bf:close()
local start=assert(bs:find('function system:kill()',1,true));local ending=assert(bs:find('---boss系统消亡逻辑',start,true))
local sys={};assert(loadstring('local system=...\n'..bs:sub(start,ending-1)))(sys)
reset();local phase=boss(60);phase.ui={};phase.countdown=12;phase.__NoPlayerProtect=true;phase.current_card.del=noop
local runtime=setmetatable({boss=phase,KillBonus=noop,refresh=noop,popSpellResult=noop,popResult=noop},{__index=sys})
runtime:kill();check(#lstg.var.upgrades.queue==1,'正式 Boss 击破回调确实生成掉落')
reset();phase=boss(61);phase.ui={};phase.current_card.del=function(b) b.cannot_kill=true end
runtime.boss=phase;object.Preserve=noop;runtime:kill();check(#lstg.var.upgrades.queue==0,'卡片 del 中声明继续存活时不掉落')
local function pick(up,coop)
    reset();local p=hero(reimu_player);p.x=-96;p.y=-176
    local ps={p};if coop then local q=hero(reimu_player,2);q.x=96;q.y=-176;q.key={};ps[2]=q;GameNet={host=function() return true end,players=ps} end
    player=p;KeyState={up=up};p.key=KeyState
    D.award(boss(70));lstg.var.upgrades.queue[1].options={1,2}
    for i=1,Q.TIME do
        for _,unit in ipairs(ps) do unit.timer=unit.timer+1;unit._playersys:frame() end
        D.frame(stage.current_stage);if not lstg.var.upgrades.active and #lstg.var.upgrades.queue==0 then return i,ps end end
    error('掉落未在原卡 500 帧内结束')
end
reset();p=hero(reimu_player);D.award(boss(69));D.frame(stage.current_stage)
local row=lstg.var.upgrades.active;local board=Q.selection('drops',row,nil,{D.optionLines(row.options[1]),D.optionLines(row.options[2])})
check(#board.walls==41 and #board.labels==2,'二选一由 33 颗横弹和 8 颗分隔弹组成，选项是实体文字')
check(board.walls[34].x==0 and near(board.walls[41].y,Q.top(row.age)-96),'二选一竖向分隔位置与原卡一致')
local gap=board.walls[1].y-board.labels[1].y;row.age=250
Q.selection('drops',row,nil,{D.optionLines(1),D.optionLines(2)})
check(near(board.walls[1].y,Q.top(250)) and near(board.walls[1].y-board.labels[1].y,gap),'子弹与选项文字按同一原始曲线下落，偏移不变')
local oldView=SetViewMode;SetViewMode=function(mode) lstg.viewmode=mode end;lstg.viewmode='ui'
local rectangles=0;local rect=RenderRect;RenderRect=function() rectangles=rectangles+1 end
for _,o in ipairs(board.walls) do o.class[4](o) end;for _,o in ipairs(board.labels) do o.class[4](o) end;D.render()
check(rectangles==0,'选择呈现不绘制遮挡矩形或浮层');RenderRect=rect
check(drawn[#drawn].mode=='world' and lstg.viewmode=='ui','文字明确使用世界坐标并恢复原视图，不会落到屏幕左下角');SetViewMode=oldView
Q.clearSelection('drops',true);check(not IsValid(board.walls[1]) and not IsValid(board.labels[1]),'选择结束清理弹体与文字，不残留覆盖')
local gen=Rand();gen:Seed(17);local quiz=Q.new(1,gen);quiz.age=220
local beforeRandom=ran;local four=Q.selection('revive',quiz,quiz.text,quiz.choices)
check(ran==beforeRandom and #four.walls==57 and #four.labels==4 and four.question,'四区答题使用相同工厂：33 横弹、24 分隔弹、题目与四个答案，不替换战斗随机源')
check(four.walls[34].x==-96 and four.walls[42].x==0 and four.walls[50].x==96,'四区分隔与原符卡 -96 / 0 / 96 完全一致')
local y=four.labels[1].y;Q.selection('revive',quiz,quiz.text,quiz.choices,.5)
check(four.labels[1].alpha==.5 and four.walls[1]._a==127.5 and four.labels[1].y==y,'答题结果时弹体和文字一起淡出，位置保持同步')
Q.clearSelection('revive');check(not IsValid(four.question) and not IsValid(four.walls[57]),'四区结果淡出后清理全部实体')
local live=Q.spawn(quiz.text,quiz.choices)
check(#live.walls==57 and live.walls[1].group~=GROUP.GHOST,'原卡调用同一工厂，保留真实敌弹碰撞组')
local stationary=pick(false);red,blue=D.values(1);check(stationary==Q.TIME and D.TIME==Q.TIME and red==105 and blue==100,'原地等待沿用原符卡 500 帧周期，超时按所在区选择')
local early=pick(true);check(early<stationary,'向上移动可以提前接取')
pick(false,true);local r1,b1=D.values(1);local r2,b2=D.values(2)
check(r1==105 and b1==100 and r2==100 and b2==105,'联机两人独立选择，各自生效')
drawn={};D.renderHUD(672,504,255);local text={};for _,v in ipairs(drawn) do text[#text+1]=v.text end
check(table.concat(text,'|'):find('P1 火力 105',1,true) and table.concat(text,'|'):find('P2 火力 100',1,true),'右侧 HUD 显式显示两位玩家数值')
-- 真正死亡时先让重生逻辑继续，不冻结在死亡状态里。
reset();p=hero(reimu_player);p.death=90;D.award(boss(72));check(not D.frame(stage.current_stage) and not lstg.var.upgrades.active,'死亡时延后开始选项落下')
p.death=0;check(not D.frame(stage.current_stage) and D.active(),'重生后叠加选择，但不接管战斗')
check(D.active(),'下落选择状态可供暂停流程识别');stage.current_stage.is_menu=true;drawn={};D.render()
check(not D.active() and #drawn==0,'回标题或切换存档后不会在菜单继续画旧选项');stage.current_stage.is_menu=false
-- 使用正式 DoFrame：选择期间世界正常前进，自机仍按原系统只移动 / 射击一次。
reset();p=hero(reimu_player);p.x=-96;KeyState={up=true,shoot=true};p.key=KeyState
D.award(boss(73));lstg.var.upgrades.queue[1].options={1,2}
local physics,recorded,rank,collisions=0,0,0,0;local phase
SaveResume={beforeLogic=function() return true end,afterLogic=function() recorded=recorded+1 end}
GameRevive={active=function() return false end,frame=function() return false end};GameRank={step=function() rank=rank+1 end,beforeObjects=noop,afterObjects=noop}
GetInput=function() phase='input' end;GetCurrentSuperPause=function() return 0 end;stage.current_stage.frame=noop;stage.current_stage.timer=0
lstg.system={frame=noop}
ObjFrame=function()
    physics=physics+1;phase='physics'
    if GetCurrentSuperPause()<=0 then p.timer=p.timer+1;p._playersys:frame() end
end
UpdateXY=noop;AfterFrame=noop;BoundCheck=noop
CollisionCheck=function() collisions=collisions+1;phase='collision' end
ext={notUIdraw=false,boss_ui={frame=noop},GetPauseMenuOrder=noop}
local f=assert(io.open(root..'/THlib/ext/ext.lua','rb'));local code=f:read('*a');f:close()
local first=assert(code:find('local function DoFrame()',1,true));local last=assert(code:find('_G.DoFrame = DoFrame',first,true))
local tick=assert(loadstring(code:sub(first,last-1)..'\nreturn DoFrame'))()
local update=D.frame
D.frame=function(scene) check(phase=='collision','掉落在正常物理和碰撞后更新');return update(scene) end
local y=p.y;tick();check(near(p.y,y+p.hspeed),'叠加掉落不额外移动自机')
for _=1,12 do tick() end
local shotCount=0;for _,o in ipairs(objects) do if o.group==GROUP.PLAYER_BULLET then shotCount=shotCount+1 end end
check(D.active() and shotCount>0 and physics==13 and stage.current_stage.timer==13 and rank==13 and collisions>0,'选项下落期间仍正常移动、射击、碰撞、计时和增长Rank')
-- 超级暂停沿用游戏规则，掉落自身不建立新的暂停。
local age=lstg.var.upgrades.active.age;GetCurrentSuperPause=function() return 1 end;tick()
check(lstg.var.upgrades.active.age==age,'超级暂停时不额外推进掉落')
GetCurrentSuperPause=function() return 0 end
while lstg.var.upgrades.active or #lstg.var.upgrades.queue>0 do tick() end
check(rank==stage.current_stage.timer and recorded==physics and rank==physics-1,'选择完成前后战斗与输入持续前进，仅尊重原超级暂停')
local previous=physics;tick();check(physics==previous+1,'接取完成后继续正常战斗')
D.frame=update;GameRank=nil
-- 答题复活冻结原战斗时隐藏掉落，结束后原进度恢复且不把传送算作接取。
reset();p=hero(reimu_player);D.award(boss(74));D.frame(stage.current_stage)
local row=lstg.var.upgrades.active;local board=Q.selection('drops',row,nil,{D.optionLines(row.options[1]),D.optionLines(row.options[2])})
local age=row.age;p.x=-100;p.y=-200;D.suspend()
check(board.walls[1].hide and board.labels[1].hide and row.age==age and row.previous[1].y==-200,'复活答题隐藏选项并保持下落进度，同步自机位置')
D.frame(stage.current_stage);check(not board.walls[1].hide and not board.labels[1].hide and row.age==age+1,'答题结束恢复叠加掉落')
-- 中弹先于拾取结算，本帧已死亡的自机不能因为穿过横线获得强化。
row.age=400;p.y=Q.top(401);row.previous[1]={x=p.x,y=p.y};p.death=90
D.frame(stage.current_stage);check(not row.picks[1],'死亡状态不能接取正在下落的强化')
lstg.var.upgrades=nil;local before=Serialize(lstg.var);D.values(1);D.power(1);D.rate(1);D.signature();check(Serialize(lstg.var)==before,'零帧 HUD 与签名只读')
lstg.var.__drops_version=nil;check(D.power(1)==1 and D.rate(1)==1,'旧录像没有版本标记时保持原倍率')
-- 正式符卡名组件：保留底部上移入场，进度栏 / 三维对象不能改变屏幕锚点。
local oldBoss,oldView,oldRender,oldText,oldFont,oldDist=_G.boss,SetViewMode,Render,RenderText,SetFontState,Dist
local oldRank,oldSmooth=GameRank,task.Smooth;GameRank=nil;task.Smooth=task.SetMode[3]
_G.boss={};SetViewMode=function(mode) lstg.viewmode=mode end
Render=noop;RenderText=noop;SetFontState=noop
Dist=function(a,b,c,d) if type(a)=='table' then return oldDist(a,b) end;return ((a-c)^2+(b-d)^2)^.5 end
load('THlib/enemy/boss_ui.lua');InitAllClass();reset();hero(reimu_player)
local oldWorld=lstg.world
for _,viewport in ipairs({{288,672,46,494},{192,768,30,510}}) do
    lstg.world={l=-192,r=192,b=-224,t=224,scrl=viewport[1],scrr=viewport[2],scrb=viewport[3],scrt=viewport[4]}
    for slot=1,2 do for _,score in ipairs({true,false}) do
        local b={_live=true,ui_slot=slot,sc_bonus=100000,_sc_hist={1,2},ui={_live=true,drawspell=true,sc_hist={1,2}}}
        local label=New(_G.boss.sc_name,b,'标题锚点回归',score)
        for _,tick in ipairs({0,1,30,60,100,110,140,150,220}) do
            label.timer=tick;if tick>0 then label.class[3](label) end
            if tick==100 then check(near(label.yoffset,-190),'保留原有下方上移入场的中点') end
            if tick>=140 then check(label.yoffset==0,'原入场结束后精确回到顶端锚点') end
            for _,view in ipairs({'ui','world','3d'}) do
                lstg.viewmode=view;drawn={};label.class[4](label)
                local text;for _,call in ipairs(drawn) do if call.text==label.name then text=call end end
                check(text and text.mode=='ui','符卡名主动使用屏幕坐标，不受前一对象影响')
                check(text.x==viewport[2]-8 and near(text.y,viewport[4]-1-(slot-1)*44+label.yoffset),'入场沿右侧上移，稳定后固定右上角，保留多Boss分行')
                check(lstg.viewmode==view,'显示 / 隐藏收卡分数都完整恢复原视图')
            end
        end
    end end
end
local calls=0;local b={_live=true}
local function part() return {render=function() check(lstg.viewmode=='world','Boss计时器等战斗坐标组件主动设置视图');calls=calls+1 end} end
local widget={boss=b,infobar=part(),timeCounter=part(),pointer=part()};lstg.viewmode='ui';_G.boss.ui.render(widget)
check(calls==3 and lstg.viewmode=='ui','Boss信息栏显示完成恢复调用方视图')
GameRank,task.Smooth=oldRank,oldSmooth
lstg.world=oldWorld;_G.boss,SetViewMode,Render,RenderText,SetFontState,Dist=oldBoss,oldView,oldRender,oldText,oldFont,oldDist
local diagnostic=load('android/lua/drops_check.lua');RogueTen=nil
check(pcall(diagnostic.install,'drops-new'),'私有诊断不提前访问尚未加载的随机模式')
R.P.init();lstg.var.__drops_version=1;D.reset();stage.current_stage={is_menu=false,timer=0,stage_name='test'}
check(pcall(D.frame,stage.current_stage),'私有诊断能在测试槽写出状态，使用独立文件而非受限存档文件名')
local df=assert(io.open(R.P.userRoot()..'/drops-check.json','rb'));local data=DeSerialize(df:read('*a'));df:close()
check(data.phase=='battle' and data.red==100 and data.blue==100,'真实诊断输出包含初始数值')

print('阶段掉落回归通过：'..count..' 项。')
