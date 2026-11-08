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
GetImageTextureRegion=function(img) assert(img=='star_big10' or img=='star_big2');return 'v310_bullet2',224,img=='star_big2' and 0 or 128,32,32 end
RenderTexture=noop
local drawn={};SetViewMode=noop;RenderRect=noop
ui={RenderText=function(_,font,text,x,y,scale,color) drawn[#drawn+1]={text=text,color=color,x=x,y=y,scale=scale,mode=lstg.viewmode} end}
ui.RenderStatusRow=load('THlib/UI/status_row.lua')
ui.RunHUD=load('THlib/UI/run_hud.lua')
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
object.Del=Del
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
-- 自机接触实体弹不同于Bomb消弹：致死弹、保护期接触弹都退场，不触发掉落。
do
    local original=OriginalBulletVisual
    OriginalBulletVisual={cancel_bullet=function() error('接触消弹不能被Bomb免疫拦截') end}
    local function target(group,style,laser)
        local b=New(object);b.group=group;b.imgclass=style and {};b.IsLaser=laser;return b
    end
    reset();lstg.var.__contact_cancel_version=1
    local p=hero(reimu_player);p.protect=0
    local b=target(GROUP.ENEMY_BULLET,true);local dead=lstg.var.dead
    check(player_class.colli(p,b) and p.death==90 and lstg.var.dead==dead+1,'实体弹命中只结算一次死亡')
    check(not IsValid(b) and not b.colli,'致死弹在返回前消除')
    for _,death in ipairs({0,1,49,91}) do
        p.death,p.protect=death,300
        for _,group in ipairs({GROUP.ENEMY_BULLET,GROUP.ENEMY_BULLET2,GROUP.INDES}) do
            b=target(group,true);b.ex_flags=4096;b.protect=999
            player_class.colli(p,b)
            check(not IsValid(b) and not b.colli,'保护期接触实体弹绕过Bomb免疫：'..death..'/'..group)
            check(p.death==death and lstg.var.dead==dead+1,'保护期不重复结算死亡')
        end
    end
    p.death,p.protect=0,300
    for _,b in ipairs({target(GROUP.ENEMY,true),target(GROUP.INDES,false),
        target(GROUP.PLAYER_BULLET,true),target(GROUP.ENEMY_BULLET,true,true)}) do
        player_class.colli(p,b);check(IsValid(b),'不把敌机、实体结构、自机弹或激光当作实体弹消除')
    end
    p.death=84;b=target(GROUP.ENEMY_BULLET,true);player_class.colli(p,b)
    check(IsValid(b),'死亡演出不扩大成自机消弹区域')
    p.death=0;p.dialog=true;b=target(GROUP.ENEMY_BULLET,true);player_class.colli(p,b)
    check(IsValid(b),'对白阶段保持原有无交互');p.dialog=false
    p.protect=0;cheat=true;b=target(GROUP.ENEMY_BULLET,true);player_class.colli(p,b)
    check(not IsValid(b) and p.death==0,'练习无敌也消除实际接触的实体弹');cheat=nil
    OriginalBulletVisual=original
    lstg.var.__contact_cancel_version=nil
    p.protect=0;b=target(GROUP.ENEMY_BULLET,true);player_class.colli(p,b)
    check(IsValid(b) and p.death==90,'旧录像未带版本标志，保留致死分支行为')
    p.death,p.protect=49,300;b=target(GROUP.ENEMY_BULLET,true);player_class.colli(p,b)
    check(IsValid(b),'旧录像保留复活计时未归零时的行为')
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
    for i=1,D.TIME do
        for _,unit in ipairs(ps) do unit.timer=unit.timer+1;unit._playersys:frame() end
        D.frame(stage.current_stage);if not lstg.var.upgrades.active and #lstg.var.upgrades.queue==0 then return i,ps end end
    error('击破掉落未在 120 帧内结束')
end
reset();p=hero(reimu_player);D.award(boss(69));D.frame(stage.current_stage)
local row=lstg.var.upgrades.active;local board=Q.selection('drops',row,nil,{D.optionLines(row.options[1]),D.optionLines(row.options[2])})
check(#board.walls==41 and #board.labels==2,'二选一由 33 颗横弹和 8 颗分隔弹组成，选项是实体文字')
check(board.walls[34].x==0 and near(board.walls[41].y,Q.top(row.age,D.TIME)-96),'二选一竖向分隔位置与原卡一致')
local gap=board.walls[1].y-board.labels[1].y;row.age=D.TIME/2
Q.selection('drops',row,nil,{D.optionLines(1),D.optionLines(2)})
check(near(board.walls[1].y,Q.top(D.TIME/2,D.TIME)) and near(board.walls[1].y-board.labels[1].y,gap),'两秒内走完原下落曲线，子弹与选项文字同步')
check(near(D.rowY(row),board.labels[1].y),'接取位置和实际文字使用相同的两秒时钟')
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
local stationary=pick(false);red,blue=D.values(1);check(stationary==120 and D.TIME==120 and red==105 and blue==100,'击破掉落在两秒整按所在区选择并结束')
check(Q.TIME==500,'缩短掉落时长不改变复活答题和原 Special 的时长')
local early=pick(true);check(early<stationary,'向上移动可以提前接取')
pick(false,true);local r1,b1=D.values(1);local r2,b2=D.values(2)
check(r1==105 and b1==100 and r2==100 and b2==105,'联机两人独立选择，各自生效')
drawn={};D.renderHUD(672,504,255);local text={};for _,v in ipairs(drawn) do text[#text+1]=v.text end
local labels={};for _,label in ipairs(text) do labels[label]=true end
check(labels['火力'] and labels['P1 105'] and labels['P2 100'],'右侧属性条下方分别显示两位玩家数值')
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
local originalDraw=D.draw
local diagnostic=load('android/lua/drops_check.lua');RogueTen=nil
check(pcall(diagnostic.install,'drops-new'),'私有诊断不提前访问尚未加载的随机模式')
R.P.init();lstg.var.__drops_version=1;D.reset();stage.current_stage={is_menu=false,timer=0,stage_name='test'}
check(pcall(D.frame,stage.current_stage),'私有诊断能在测试槽写出状态，使用独立文件而非受限存档文件名')
local df=assert(io.open(R.P.userRoot()..'/drops-check.json','rb'));local data=DeSerialize(df:read('*a'));df:close()
check(data.phase=='battle' and data.red==100 and data.blue==100,'真实诊断输出包含初始数值')
D.draw=originalDraw


-- 新版：红蓝选项独立、匀速掉落和自然恢复 Bomb；旧版回归继续保留在上文。
local function modernReset()
    reset();lstg.var.__drops_version=2;lstg.var.__input_version=2;D.reset();stage.current_stage={is_menu=false,timer=0}
end
modernReset()
check(D.bombState(1)==3 and D.recoveryRate(1)==1 and D.rate(1)==1,'新版开局三枚 Bomb，蓝字不改变射速')
for seed=1,250 do
    local pair=D.draw(seed*7919,7)
    check(pair[1]%2==1 and pair[2]%2==0,'左红右蓝随机池')
    local beforeRed,beforeBlue=D.values(1)
    D.apply(1,pair[1]);local red,blue=D.values(1);check(blue==beforeBlue,'红色选项不改蓝值')
    D.apply(1,pair[2]);local r,b=D.values(1);check(r==red,'蓝色选项不改红值')
end
local function modernShots(class,blue)
    modernReset();local p=New(class);lstg.var.upgrades.players[1].blue=blue*100;KeyState={shoot=true}
    for i=0,239 do p.timer=i;p._playersys:frame() end
    local n=0;for _,o in ipairs(objects) do if o.group==3 then n=n+1 end end;return n,p.shots
end
for _,hero in ipairs({reimu_player,chiruno_player,cooldown}) do
    local base,n=modernShots(hero,100);local blue,m=modernShots(hero,250)
    check(base==blue and n==m,'蓝字提高后角色实际发弹和冷却保持原速')
end
modernReset();local p=New(reimu_player);local p2=New(reimu_player);p2._net_slot=2
local state=lstg.var.upgrades;state.players[1].bombs=0;state.players[2].bombs=0;state.players[2].blue=20000
for i=1,D.BOMB_FRAMES/2-1 do D.playerStep(p);D.playerStep(p2) end
check(D.bombState(p)==0 and D.bombState(p2)==0,'恢复完成前没有整数 Bomb')
D.playerStep(p);D.playerStep(p2)
check(D.bombState(p)==0 and D.bombState(p2)==1,'200 蓝值十五秒恢复一枚，双方独立')
for i=1,D.BOMB_FRAMES/2 do D.playerStep(p) end
check(D.bombState(p)==1,'100 蓝值三十秒恢复一枚')
state.players[1].bombs=3;state.players[1].bomb_fraction=77;D.playerStep(p)
local bombs,progress=D.bombState(p);check(bombs==3 and progress==0,'库存上限三枚且满库存不预存恢复量')
local casts=0;lstg.system={castCharge4=function(_,owner) check(owner==p,'Bomb 使用正确自机');casts=casts+1 end}
p.death=0;p.dialog=false;p.hide=false;p.lock=false
check(D.bombInput(p,{spell=true},{spell=false}) and D.bombState(p)==2 and casts==1,'X 按下消耗一枚并立即释放')
check(not D.bombInput(p,{spell=true},{spell=true}) and casts==1,'长按不连续消耗 Bomb')
state.players[1].bombs=0;check(not D.bombInput(p,{spell=true},{}) and casts==1,'没有 Bomb 不能释放')
state.players[1].bombs=1;p.death=90;check(not D.bombInput(p,{spell=true},{}),'死亡期间不释放');p.death=0
for _,death in ipairs({0,1,49,91,100}) do
    state.players[1].bombs=1;p.death=death;p.protect=300
    check(D.bombInput(p,{spell=true},{}),'无敌与复活可操作阶段可以释放 Bomb：'..death)
end
for _,death in ipairs({50,84,90}) do
    state.players[1].bombs=1;p.death=death
    check(not D.bombInput(p,{spell=true},{}),'死亡演出阶段禁止释放：'..death)
end
p.death=0;p.time_stop=true;check(not D.bombInput(p,{spell=true},{}),'时间停止期间不释放');p.time_stop=false
p.dialog=true;check(not D.bombInput(p,{spell=true},{}),'对话期间不释放');p.dialog=false
local sig=D.signature();state.players[1].bomb_fraction=1;check(sig~=D.signature(),'Bomb 恢复进度参与确定性签名')
modernReset();p=New(reimu_player);p.x=-96;p.y=-100;player=p
check(D.award(boss(101)),'新版击破产生选项');local row=lstg.var.upgrades.queue[1]
check(row.duration==120 and row.linear and row.colorMask,'新版两秒匀速红蓝遮罩')
local last=Q.offset(0,row.duration,row.linear)
for i=1,120 do
    local current=Q.offset(i,row.duration,row.linear);check(near(current-last,460/120),'每帧下降距离恒定');last=current
end
row.age=36;local board=Q.selection('modern',row,nil,{D.optionLines(row.options[1]),D.optionLines(row.options[2])})
check(board.mask and IsValid(board.mask) and near(board.mask.y,330-460*36/120),'遮罩跟随选项一起下落')
local rects={};RenderRect=function(_,l,r,b,t) rects[#rects+1]={l,r,b,t} end;board.mask.class[4](board.mask)
check(#rects==2 and rects[1][1]==-192 and rects[1][2]==0 and rects[2][1]==0 and rects[2][2]==192,'遮罩分别覆盖左半和右半')
Q.setSelectionVisible('modern',false);check(board.mask.hide and board.labels[1].hide,'复活时同时隐藏遮罩与文字')
Q.clearSelection('modern');check(not IsValid(board.mask),'选取结束清理遮罩')
local top=Q.top(70,120,true)
check(Q.contact({x=-90,y=top+5},{x=-90,y=top-1,A=3},69,70,2,120,true)==1,'接取扫掠与显示使用同一匀速轨迹')

-- 九枚库存使用新初态版本；旧录像的恢复封顶和选项位置仍必须逐帧一致。
do
    for _,version in ipairs({1,2,3,4,5,D.VERSION}) do
        modernReset();lstg.var.__drops_version=version;D.reset()
        local c=lstg.var.upgrades.players[1];c.red=99000
        D.apply(1,9)
        check(D.values(1)==(version>=6 and 1188 or 1000),'火力跨越旧上限，仅新版本不截断：'..version)
        c.red=D.MAX;D.apply(1,1)
        check(D.values(1)==(version>=6 and 1005 or 1000),'满旧上限后加法升级继续生效：'..version)
    end
    modernReset();lstg.var.__drops_version=D.VERSION;D.reset()
    local p=hero(reimu_player);local c=lstg.var.upgrades.players[1];c.red=120000
    local e=New(targetClass);local shot={dmg=10,killflag=true,mute=true,_drop_owner=1}
    enemybase.colli(e,shot)
    check(e.hp==9880 and shot.dmg==10,'超过1000的实际火力仍在命中时乘入一次')
    for _=1,50 do D.apply(1,9) end
    check(D.values(1)>1000000,'火力多次乘法升级能够超过一百万')
    c.blue=D.MAX;D.apply(1,2);c.green=D.HITBOX_MIN;D.apply(1,11)
    check(c.blue==D.MAX and c.green==D.HITBOX_MIN,'取消红色上限不改变蓝绿的边界')
    local axis=ui.RunHUD.powerAxis
    check(axis(1)==3 and axis(1000)==3 and axis(1000.01)==4 and axis(1000000)==6 and axis(math.huge)==309,'对数轴以完整十进制数量级扩展，并能处理浮点溢出')
    local rect=RenderRect;local strips={}
    RenderRect=function(_,...) strips[#strips+1]={...} end
    for _,value in ipairs({10,100,1000}) do
        strips={};ui.RunHUD.powerTrack(0,300,100,value,255,3)
        check(near(strips[2][2],100*math.log(value)/math.log(10)),'10、100、1000在对数条上等距：'..value)
    end
    strips={};ui.RunHUD.powerTrack(0,300,100,1000,255,6)
    check(near(strips[2][2],150),'双人共用百万量程时1000落在中点')
    RenderRect=rect
    for _,version in ipairs({2,3,4,5,D.VERSION}) do
        modernReset();lstg.var.__drops_version=version;D.reset()
        local p=New(reimu_player);local c=lstg.var.upgrades.players[1]
        check(D.bombState(p)==3,'各版初始持有三枚Bomb：'..version)
        local limit=version>=5 and 9 or 3
        check(D.bombLimit()==limit,'版本对应的库存上限：'..version)
        if version>=3 then
            check(D.hitboxScale(p)==1 and c.green==10000,'三色版本保留判定属性：'..version)
            local options=D.draw(18373,5)
            check(options[1]%2==(version>=4 and 0 or 1) and options[3]>=11,'新旧三色选项位置：'..version)
        end
        c.bomb_fraction=D.BOMB_FRAMES*10000-10000;D.playerStep(p)
        check(D.bombState(p)==(version>=5 and 4 or 3),'初始三枚时新版继续恢复，旧版封顶：'..version)
        c.bombs=limit-1;c.bomb_fraction=D.BOMB_FRAMES*10000-1;c.blue=100000
        D.playerStep(p)
        local stock,progress=D.bombState(p)
        check(stock==limit and progress==0,'最后一枚恢复时封顶，余量归零：'..version)
        D.playerStep(p);stock,progress=D.bombState(p)
        check(stock==limit and progress==0,'满库存不额外蓄积：'..version)
    end
    modernReset();lstg.var.__drops_version=D.VERSION;D.reset()
    local p=New(reimu_player);local c=lstg.var.upgrades.players[1]
    c.bombs=9;c.bomb_fraction=12345
    local previous=lstg.system;local cast=0;lstg.system={castCharge4=function() cast=cast+1 end}
    check(D.bombInput(p,{spell=true},{}) and c.bombs==8 and cast==1 and c.bomb_fraction==12345,'九枚库存释放消耗一枚，保留原有恢复量')
    check(not D.bombInput(p,{spell=true},{spell=true}) and c.bombs==8,'长按Bomb不重复扣库存')
    lstg.system=previous
    local red,blue=D.optionLines(1),D.optionLines(8)
    check(red[1].text=='火力' and red[2].text=='+5','红色掉落同时显示属性名和增量')
    check(blue[1].text=='Bomb恢复速度' and blue[2].text=='×1.1','蓝色掉落同时显示Bomb恢复速度和倍率')
    local renderTexture=RenderTexture;local quads={}
    RenderTexture=function(tex,blend,...)
        check(tex=='v310_bullet2' and blend=='','Bomb使用已有绿色大星图集和普通混合')
        quads[#quads+1]={...}
    end
    c.bombs=3
    for _,part in ipairs({0,.25,.5,.75}) do
        c.bomb_fraction=part*D.BOMB_FRAMES*10000;quads={}
        local before=Serialize(lstg.var);D.renderBombs(678,954,144,255,1)
        check(Serialize(lstg.var)==before,'库存图标渲染不改变录像初态和恢复量')
        local whole,dim,triangles=0,0,{}
        for _,quad in ipairs(quads) do
            if quad[1][6].a<255 then dim=dim+1
            elseif quad[1]==quad[4] then triangles[#triangles+1]=quad
            else whole=whole+1 end
            for _,vertex in ipairs(quad) do
                check(vertex[4]>=224-1e-8 and vertex[4]<=256+1e-8 and vertex[5]>=128-1e-8 and vertex[5]<=160+1e-8,'裁切UV保持绿色star_big10范围')
            end
        end
        check(whole==3 and dim==6,'九个槽位中三颗满星、六颗暗星')
        if part==0 then check(#triangles==0,'零进度不画恢复扇区')
        else
            local area=0
            for _,q in ipairs(triangles) do
                local a,b,d=q[1],q[2],q[3]
                area=area+math.abs((b[1]-a[1])*(d[2]-a[2])-(d[1]-a[1])*(b[2]-a[2]))/2
            end
            check(near(area,26*26*part),'四分之一、半枚和四分之三按实际角度裁切星形')
            local last=triangles[#triangles];local center,edge=last[1],last[3]
            local dx,dy=edge[1]-center[1],edge[2]-center[2]
            check(part==.25 and near(dx,13) and near(dy,0) or part==.5 and near(dx,0) and near(dy,-13) or part==.75 and near(dx,-13) and near(dy,0),'恢复从顶部顺时针到达90、180、270度')
        end
    end
    quads={};c.bombs=9;c.bomb_fraction=0;D.renderBombs(678,954,144,255,1)
    check(#quads==9,'九枚满库存只绘制九颗完整星形')
    for _,q in ipairs(quads) do check(q[1][6].a==255,'九枚满星全部明亮') end
    quads={};c.bombs=3;c.bomb_fraction=0;lstg.var.upgrades.players[2].bombs=2
    D.renderBombs(678,954,144,255,2)
    check(#quads==18,'联机分别显示两行九槽库存')
    for i,q in ipairs(quads) do
        local cy=i<=9 and 119 or 91
        check(q[1][1]>=678 and q[2][1]<=954 and near(q[1][2],cy+11.5),'联机两行星形留在右侧UI范围内')
    end
    RenderTexture=renderTexture
    lstg.var.upgrades=nil;local before=Serialize(lstg.var);D.renderHUD(672,494,255)
    check(Serialize(lstg.var)==before,'新版零帧HUD保持只读，不建立成长状态')
    local rect=RenderRect;local strips={}
    RenderRect=function(_,...) strips[#strips+1]={...} end
    for _,value in ipairs({-.5,0,.5,1,1.5}) do
        strips={};ui.RunHUD.track(0,200,100,value,255,{255,110,120},1)
        check(#strips==(value>0 and 2 or 1),'属性条零值不画填充，其他值只画一个填充')
        if value>0 then check(near(strips[2][2],200*math.min(value,1)),'属性条按数值比例填充并限制在边框内') end
    end
    RenderRect=rect
    local oldRevive,oldRogue,oldRank=GameRevive,RogueTen,GameRank
    GameRevive={misses=function() return lstg.var.dead end};RogueTen={MISS_LIMIT=10}
    GameRank={MAX=100,enabled=function() return true end,value=function() return 50 end,factor=function() return 1 end}
    D.reset();lstg.var.rogue_run={current=42};lstg.var.dead=1
    lstg.var.upgrades.players[1].red=13500;lstg.var.upgrades.players[1].blue=17500;lstg.var.upgrades.players[1].green=7500
    local redStars,brightRed=0,0;local render=RenderTexture
    RenderTexture=function(_,_,a) if a[5]==0 then redStars=redStars+1;if a[6].a==255 then brightRed=brightRed+1 end end end
    drawn={};before=Serialize(lstg.var);ui.RunHUD.draw(672,494,255)
    check(Serialize(lstg.var)==before,'完整资源栏绘制只读')
    check(redStars==10 and brightRed==9,'十条生命失去一条后，只点亮九颗红色大星')
    local visible={};for _,call in ipairs(drawn) do visible[call.text]=call end
    check(visible['生命'] and visible['9'] and visible['Bomb'] and visible['3 / 9'],'右上只呈现剩余生命与Bomb库存')
    check(visible['135'].y==307 and visible['175'].y==243 and visible['75%'].y==172,'三项实际数值置于各自属性条下方，火力留出对数刻度')
    check(not visible['Rank'] and not visible['×1.000'],'右下不再显示Rank条或Rank倍率')
    for _,label in ipairs({'最高分','当前分数','擦弹','资金力','死亡数','收卡数','答题复活','读档次数'}) do check(not visible[label],'极简资源栏不显示旧统计：'..label) end
    drawn={};ui.RunHUD.stage(42,144,270,288)
    check(#drawn==1 and drawn[1].text=='42' and drawn[1].scale>=4,'阶段区仅绘制大号阿拉伯数字')
    lstg.var.dead=10;check(ui.RunHUD.lives()==0,'生命耗尽显示零，不出现负数')
    RenderTexture=render;GameRevive,RogueTen,GameRank=oldRevive,oldRogue,oldRank
end

-- 复用正式花映冢效果与协程，而非复制一套近似 Bomb。
modernReset();p=New(reimu_player);player=p
LoadSound=noop;LoadImageSetCenter=noop;LoadAniFromFile=noop;DoFile=noop
scoredata={Player_playtime={0,0,0,0}};load('THlib/lib/Ltask.lua');load('Resources/System/system.lua');InitAllClass()
check(D.bombInput(p,{spell=true},{}) and D.bombState(p)==2,'正式四段效果可直接释放')
local large
for _,o in ipairs(objects) do if o.class==Circle_Attack and o.radius==250 then large=o end end
check(large and large.dmg==1 and p.protect==300,'四段大圈半径、伤害和保护时间沿用原效果')
local other=New(marisa_player);other.x=99;other.protect=8;player=other;task.Do(p)
check(p.protect==300 and other.protect==8 and lstg.var.charge==0,'二段小圈不缩短保护、不扣旧蓄力、协程不串到另一自机')
local small
for _,o in ipairs(objects) do if o.class==Circle_Attack and o.radius==80 then small=o end end
check(small and small.x==p.x,'四段包含原二段小圈')

-- 真触控模块 + 正式自机移动：任意位置相对拖拽、任意角度和抬手停止。
package.preload.keycode=function()
    return setmetatable({},{__index=function(t,k) local v=#k==1 and k:byte() or 1000+#k;t[k]=v;return v end})
end
lstg.GetKeyState=function() return false end;lstg.GetLastKey=function() return 0 end
setting={keys={up=38,down=40,left=37,right=39,slow=16,shoot=90,spell=88,special=67}}
local menuMode,paused=true,false
ext.StageIsMenu=function() return menuMode end;ext.pause_menu={IsKilled=function() return not paused end}
KEY={CTRL=17};load('THlib/lib/Linput.lua')
AndroidInput=load('android/lua/input.lua');local I=AndroidInput
modernReset();p=New(cooldown);p.x=0;p.y=-100;player=p
lstg.world.scrl=288;lstg.world.scrr=672;lstg.world.scrb=46;lstg.world.scrt=494
I.beginFrame();menuMode=false;I.beginFrame()
check(I.toggles.shoot and I.toggles.slow,'手机进关卡默认开启低速和射击')
do
    local rect,ttf=RenderRect,RenderTTF;local buttons={}
    RenderRect=function(_,x1,x2,y1,y2) buttons[#buttons+1]={x1,x2,y1,y2} end
    RenderTTF=noop;I.render();RenderRect,RenderTTF=rect,ttf
    for i=1,4 do
        local b=buttons[i]
        check(b[1]>=678 and b[2]<=954 and b[3]>=0 and b[4]<79.5,'四个触控按钮不遮挡属性和两人库存')
        if i>1 then check(b[1]>buttons[i-1][2],'底部触控按钮互不重叠') end
    end
end
local function mobileFrame()
    I.beginFrame();KeyState={shoot=I.keys[90] or false,slow=I.keys[16] or false};I.readMovement(KeyState)
    p._playersys:frame()
end
I.touch(1,350,300,'began');mobileFrame();check(p.x==0 and p.y==-100,'屏幕任意位置按下不会瞬移')
I.touch(1,382,324,'moved');mobileFrame()
check(near(p.x,1.6) and near(p.y,-98.8),'3:4 拖拽按原低速沿精确角度移动')
I.touch(1,310,360,'moved');local beforeX,beforeY=p.x,p.y;mobileFrame()
check(p.x<beforeX and p.y>beforeY and near(((p.x-beforeX)^2+(p.y-beforeY)^2)^0.5,p.lspeed),'拖动途中改位置立即改变终点，速度保持一致')
I.touch(1,310,360,'ended');beforeX,beforeY=p.x,p.y;mobileFrame();check(p.x==beforeX and p.y==beforeY and KeyState.touch_x==nil,'抬手当帧停止移动')
I.touch(2,849,43,'began');check(I.movementId==nil and I.keys[88],'右侧 Bomb 按钮不抢移动');I.touch(2,849,43,'ended')
I.touch(3,781,43,'began');I.touch(3,781,43,'ended');check(not I.toggles.slow,'低速开关可手动关闭')
paused=true;I.beginFrame();paused=false;I.beginFrame();check(not I.toggles.slow and I.toggles.shoot,'暂停回来保持手动开关')
stage.current_stage={is_menu=false,timer=0};I.beginFrame();check(I.toggles.slow and I.toggles.shoot,'下一关重新默认低速和射击')
-- 默认场地所有中心区域均可起拖，边缘 UI 不产生拖拽。
for _,point in ipairs({{289,47},{480,270},{671,493}}) do
    I.touch(4,point[1],point[2],'began');check(I.touches[4].drag,'战斗区任意位置可起拖');I.touch(4,point[1],point[2],'cancelled')
end
local dx,dy=TouchInputMovement(p,{touch_x=p.x+.2,touch_y=p.y+.1},2)
check(near(dx,.2) and near(dy,.1),'末帧截断到终点，不抖动也不越过目标')

-- 无移速限制随关卡初态决定，实际自机直接跟随相对向量；默认仍限速。
I.reset();lstg.var.__touch_unlimited=true;I.beginFrame();local ux,uy=p.x,p.y
I.touch(30,400,270,'began');I.touch(30,432,294,'moved');mobileFrame()
local function quantize(v) return math.floor(v*16+.5)/16 end
check(near(p.x,quantize(ux+32)) and near(p.y,quantize(uy+24)),'开启无移速限制后单帧跟随完整拖拽向量')
I.touch(30,416,282,'moved');mobileFrame()
check(near(p.x,quantize(ux+16)) and near(p.y,quantize(uy+12)),'无移速限制下转向立即更新向量终点')
I.touch(30,416,282,'ended');ux,uy=p.x,p.y;mobileFrame()
check(p.x==ux and p.y==uy,'无移速限制抬手同样立即停止')
lstg.var.__touch_unlimited=false
dx,dy=TouchInputMovement(p,{touch_x=p.x+30,touch_y=p.y+40},2)
check(near((dx*dx+dy*dy)^.5,2),'默认关闭无移速限制仍保持设定移速')
lstg.var.__touch_unlimited=true
dx,dy=TouchInputMovement(p,{touch_x=p.x+30,touch_y=p.y+40,touch_unlimited=false},2)
check(near((dx*dx+dy*dy)^.5,2),'远端明确关闭无限速时不继承房主选项')
lstg.var.__touch_unlimited=false

-- 使用可控实时时钟验证双击窗口和真实 Bomb 扣除；拖动、取消和 UI 操作不触发。
local tapClock=0;lstg.AndroidClock=function() return tapClock end
local function tap(id,x,y,time,ending)
    tapClock=time;I.touch(id,x,y,'began');tapClock=time+.02;I.touch(id,x,y,ending or 'ended')
end
I.reset();I.beginFrame();tap(31,400,270,1)
tapClock=1.09;I.touch(32,400,270,'began')
check(lstg.GetKeyState(88),'默认 0.1 秒内第二次按下产生 Bomb 输入')
local bombsBefore=D.bombState(p);D.bombInput(p,{spell=lstg.GetKeyState(88)},{})
check(D.bombState(p)==bombsBefore-1,'双击输入经过正式 Bomb 路径扣除一枚')
I.touch(32,400,270,'ended');I.endFrame();I.endFrame();check(not lstg.GetKeyState(88),'双击脉冲不会一直保持 Bomb')
I.reset();tap(31,400,270,2);tapClock=2.11;I.touch(32,400,270,'began')
check(not lstg.GetKeyState(88),'超过默认 0.1 秒不触发 Bomb')
I.reset();setting.touchBombInterval=300;tap(31,400,270,3);tapClock=3.25;I.touch(32,400,270,'began')
check(lstg.GetKeyState(88),'设置为 0.3 秒后较慢双击可触发')
I.reset();setting.touchBombInterval=nil;tapClock=4;I.touch(31,400,270,'began');I.touch(31,430,270,'moved');I.touch(31,400,270,'moved');I.touch(31,400,270,'ended')
tapClock=4.05;I.touch(32,400,270,'began');check(not lstg.GetKeyState(88),'拖动后回原点也不会被当成第一次点击')
I.reset();tap(31,400,270,5,'cancelled');tapClock=5.05;I.touch(32,400,270,'began')
check(not lstg.GetKeyState(88),'取消触点不构成双击')
I.reset();tap(31,713,43,6);tapClock=6.05;I.touch(32,400,270,'began')
check(not lstg.GetKeyState(88),'点击射击按钮不会与战斗区触点组合成双击')
I.reset();lstg.AndroidClock=nil


-- 文文独立的移动回调也使用拖拽目标，并保留拍照蓄力时的超低速。
local oldInclude=Include;Include=noop;CreateRenderTarget=noop;load('THlib/player/aya/aya.lua');Include=oldInclude
AyaWalkImageSystem=PlayerWalkImageSystem;TenguCamera=function() return {photoing=false,frame=noop} end;GetSoundState=function() return 'playing' end;StopSound=noop;InitAllClass()
modernReset();p=New(aya_player);p.x=0;p.y=-100;player=p
for _,case in ipairs({{true,true,.5},{true,false,2},{false,false,6.5}}) do
    local x,y=p.x,p.y;KeyState={slow=case[1],shoot=case[2],touch_x=x+30,touch_y=y+40};p._playersys:frame()
    check(near(((p.x-x)^2+(p.y-y)^2)^.5,case[3]),'文文高速、低速与蓄力超低速均保持设定速度')
end

-- 真实自机选择菜单：随机模式不接受系统键盘、滚轮或鼠标输入。
local f=assert(io.open(root..'/THlib/UI/menu.lua','rb'));local source=f:read('*a'):gsub('\r\n','\n');f:close()
local section=assert(source:match('(player_system_select = Class%(object%).-)\nlocal valid'))
-- 菜单抽取段依赖段外的local；保持正式卡池面板，补足测试宿主的只读查询。
RogueTen={POOL_VERSION=7,savedFilters=function() return {stages={},difficulties={},encounters={},cards={survival=false,nonspell=true,spell=true}} end,
    copyFilters=function() return {stages={},difficulties={},encounters={},cards={survival=false,nonspell=true,spell=true}} end,
    poolStatus=function() return {valid=true,count=410} end}
assert(loadstring('local rogue_pool_menu=dofile('..string.format('%q',root..'/THlib/UI/rogue_pool.lua')..')\n'..section,'@THlib/UI/menu.lua:player_system_select'))()
scoredata={UnlockSystem={true,true,true},system_selectid={true,false,true},player_select=1}
SystemList={};player_list={{'灵梦','reimu_player','Reimu'}}
sp={math={PointBoundCheck=function() return false end},CopyTable=function(_,v) local out={};for k,item in pairs(v) do out[k]=item end;return out end,TweakValue=function(_,v) return v end}
local oldDist=Dist;Dist=function(a,b,c,d) if type(a)=='table' then return oldDist(a,b) end;return ((a-c)^2+(b-d)^2)^.5 end
menu={ControlExit=noop,Updatekey=noop,keyYes=function() return false end,keyNo=function() return false end,keyLeft=function() return false end,keyRight=function() return false end,keyUp=function() return false end,keyDown=function() return false end}
GetLastKey=function() return setting.keys.special end
ext.mouse={x=800,y=270,_wheel=1,isDown=function() return true end}
local started=false;InitAllClass();local select=New(player_system_select,function() started=true end)
for _,mode in ipairs({'roguelike','rogue_dual','rogue_chain'}) do
    select:fresh(mode);select.locked=false
    check(select.simple_mode and select.simple_title,'三个随机模式入口直接禁用系统选择')
    select:setsystem();select:addpos2(1);select.class[3](select)
    GetLastKey=function() return 0 end;select.class[3](select);GetLastKey=function() return setting.keys.special end
    check(select.pos2==1 and select.system_selectid[1] and select.system_selectid[3],'特殊键、滚轮和列表点击不能修改随机模式系统')
    lstg.var.current_system='ABC';select:yes()
    check(started and lstg.var.current_system=='' and scoredata.system_selectid[1] and scoredata.system_selectid[3],'随机模式开始时清空系统，不覆盖普通模式配置')
end
select:fresh();check(not select.simple_mode,'返回普通模式恢复系统选择')

print('阶段掉落回归通过：'..count..' 项。')
