-- 读取原卡注册，验证抽取与十战生命周期；不读写玩家 User/ 或 replay/。
local checkDual=arg[1]=='--dual'
arg[1]='roguelike-registry'
local file=assert(io.open('tools/check_stage.lua','rb'));local source=file:read('*a');file:close()
local position=assert(source:find('if path == "--all" then',1,true))
assert(loadstring(source:sub(1,position-1)))()
screen={width=960,height=540}
local total=0
local function check(value,label) assert(value,label);total=total+1 end
local oldAdd=boss.card.add
_sc_pr_table={}
-- 卡池判断读的是注册后的帧数；部分移植会直接写入原作免疫帧，不能沿用静态桩的秒数。
local newCard=boss.card.New
boss.card.New=function(...)
    local c=newCard(...)
    c.t1,c.t2,c.t3=math.floor(c.t1*60),math.floor(c.t2*60),math.floor(c.t3*60)
    return c
end
boss.card.add=function(parts,level,label,id,...)
    -- 与正式Card.add一致，在登记前应用妖妖梦／风神录的最终无敌帧校准。
    local game=({[32]=7,[33]=10})[level]
    local balance=game and OriginalBalance and OriginalBalance.entries[game][id]
    if balance then for _,part in ipairs(parts) do
        local c=part[1]
        if c.t1<c.t3 then c._original_balance=balance;c.hp,c.t1,c.t2=balance.hp,balance.immune,balance.immune end
    end end
    oldAdd(parts,level,label,id,...)
    local unit={CardName=label,sc_group={}}
    for _,part in ipairs(parts) do unit.sc_group[#unit.sc_group+1]={boss=_editor_boss[part[2]..level],card=part[1]} end
    _sc_pr_table[level]=_sc_pr_table[level] or {};table.insert(_sc_pr_table[level],unit)
end
dofile('mod/_editor_output.lua')
for _,id in ipairs({'31','32','34','35','36'}) do dofile('mod/GAME/th'..id..'.lua') end
local function random()
    local gen={value=1}
    function gen:Seed(v) self.value=v%2147483646+1 end
    function gen:Int(a,b) self.value=self.value*48271%2147483647;return a+math.floor(self.value/2147483647*(b-a+1)) end
    return gen
end
Rand=random
-- 使用框架实际的关卡注册与协程实现，战斗对象只模拟存活三帧，不执行弹幕。
dofile('THlib/lib/Lstage.lua');dofile('THlib/ext/ext_stage_group.lua');dofile('THlib/lib/Ltask.lua')
stage.stages.menu={is_menu=true};stage.current_stage=stage.stages.menu
local replay=false;local cleared,saved,spawned=0,0,{}
local panels={}
ext={replay={IsReplay=function() return replay end},GetPauseMenuOrder=function() end,achievement={get=function() end}}
SaveResume={clear=function() cleared=cleared+1 end}
SaveScoreData=function() saved=saved+1 end;SaveSpellCardData=function() end
local musicEvents,backgroundEvents={},{}
PlayMusic=function(name) musicEvents[#musicEvents+1]=name end
local stopped={}
StopMusic=function(name) check(name=='SCORE','只停止上局结算音乐');stopped[#stopped+1]=name end
background.Create=function(class) backgroundEvents[#backgroundEvents+1]=class end
mask_fader={Do=function() end};lstg={var={},tmpvar={}};scoredata={}
-- Start只向录像初态写版本，掉落实体由独立掉落回归覆盖。
GameDrops={VERSION=4}
GROUP.GHOST,GROUP.ENEMY=0,2;LAYER.TOP=0
function stage.Set(mode,name)
    stage.next_stage=assert(stage.stages[name]);lstg.var.stage_name=name
    if mode=='save' then lstg.var.ran_seed=(lstg.var.ran_seed or 1234)+1 end
end
function stage:Option()
    lstg.var.score=100;lstg.var.dead=0;lstg.var.getsc=0;lstg.var.init_player_data=true
    player={_live=true,protect=0};self.stop_watch={GetElapsed=function() return self.timer/60 end}
end
New=function(class,cards)
    local obj=setmetatable({_live=true,otherboss={}}, {__index=class})
    obj.group=GROUP.ENEMY
    if cards then
        obj.life=3;obj.maxhp=100;obj.hp=100;obj.t3=3600;obj.timer=0;obj.is_combat=true;obj.__is_waiting=false
        spawned[#spawned+1]={obj=obj,class=class,card=cards[1],tick=stage.current_stage.timer}
    elseif class.init then class.init(obj);if obj.group==GROUP.GHOST and obj.layer==LAYER.TOP then panels[#panels+1]={obj=obj,class=class} end end
    return obj
end
local G=dofile('THlib/rogue_hp.lua')
local R=dofile('mod/roguelike.lua')
local bossFilters=R.defaultFilters('dual')
local pool=R.buildPool(bossFilters)
local counts={};local original={};local spell,non=false,false
-- 锁住会暴露“拿 Boss 资源 id 查标定表”的代表卡：三面非符、五面中 BOSS 非符、二面过渡非符。
local calibrated={[427]=1079,[3433]=1153,[467]=338}
for _,bucket in ipairs(pool) do
    counts[bucket.code]=#bucket.cards
    for _,entry in ipairs(bucket.cards) do
        check(not entry.title:find('道中',1,true),'不混入整段道中')
        local c=_sc_pr_table[entry.level][entry.index].sc_group[1].card
        if calibrated[entry.cardId] then check(c.hp==calibrated[entry.cardId],'TH31 灵梦标定 HP 取键正确') end
        original[c]={hp=c.hp,t1=c.t1,t2=c.t2,t3=c.t3,init=c.init,frame=c.frame}
        spell=spell or entry.spell;non=non or not entry.spell
    end
end
check(spell and non,'卡池同时包含符卡与非符')
check(R.modes.chain and stage.groups[R.modes.chain.name],'接续模式已注册')
local function atThreshold(t)
    t._live=true
    local done,why=R.chainDone(t)
    return done,why
end
local done=atThreshold{is_combat=true,hp=16,maxhp=100,t3=1000,timer=0}
check(not done,'接续模式：剩余 16% 不推进')
done=atThreshold{is_combat=true,hp=15,maxhp=100,t3=1000,timer=0}
check(done,'接续模式：剩余 15% 推进')
done=atThreshold{is_combat=true,hp=100,maxhp=100,t3=1000,timer=820}
check(not done,'接续模式：剩余 180 帧不推进')
done=atThreshold{is_combat=true,hp=100,maxhp=100,t3=1000,timer=821}
check(done,'接续模式：剩余 179 帧推进')
local function keys(cards) local out={};for _,v in ipairs(cards) do out[#out+1]=v.key end;return table.concat(out,',') end
local observed={}
for seed=1,400 do
    local plan=R.draw(seed,1,bossFilters);check(#plan==10,'恰好十战')
    local seen={};for _,entry in ipairs(plan) do assert(not seen[entry.key],'本局重复卡');seen[entry.key]=true;observed[entry.source]=true end
    check(keys(plan)==keys(R.draw(seed,1,bossFilters)),'相同种子固定路线，支持录像与重建')
end
check(observed.TH31 and observed.TH34 and observed.TH35,'三个来源均能抽到')
check(keys(R.draw(17,1,bossFilters))~=keys(R.draw(31415,1,bossFilters)),'不同种子产生不同路线')
-- 新池的来源、交集筛选、小池拒绝和副本隔离；不通过标题猜测难度。
local all,count=R.buildPool(R.defaultFilters(nil,6),6)
check(#all==4 and count==410,'新局关闭地灵殿，包含四作410个已核对条目')
local noTime=R.defaultFilters(nil,6);noTime.cards.survival=false
local filtered,filteredCount=R.buildPool(noTime)
local timeIds={[383]=true,[392]=true,[393]=true,[394]=true,[395]=true,[396]=true,
    [3984]=true,[3440]=true,[3442]=true,[3470]=true,[4401]=true,[4434]=true,[3607]=true,[3619]=true,[3620]=true}
local timeCount,roadCount,filteredRoads=0,0,0
for _,bucket in ipairs(all) do for _,e in ipairs(bucket.cards) do
    if e.survival then timeCount=timeCount+1;check(timeIds[e.cardId],'按真实无敌时限识别耐久卡，不按卡名猜测') end
    if e.kind=='road' then roadCount=roadCount+1;check(not e.survival,'道中宿主不是时符') end
end end
for _,bucket in ipairs(filtered) do for _,e in ipairs(bucket.cards) do
    check(not e.survival and not timeIds[e.cardId],'取消时符后不包含任何耐久卡')
    if e.kind=='road' then filteredRoads=filteredRoads+1 end
end end
check(timeCount==15 and filteredCount==395 and filteredRoads==roadCount,'时符开关精确排除15张，保留全部道中')
for seed=1,30 do
    for _,e in ipairs(R.draw(seed,1,noTime,6,true)) do check(not e.survival,'无限模式各轮也遵守时符筛选') end
end
local _,oldTimeCount=R.buildPool(noTime,5)
check(oldTimeCount==410,'版本5录像保留原卡池，不因时符筛选改变路线')
local remembered=R.copyFilters(noTime)
check(not remembered.cards.survival and not noTime.cards.survival,'时符关闭状态进入筛选副本')
local th36=R.defaultFilters(nil,4);th36.stages={TH36=true}
local disabled,disabledCount=R.buildPool(th36)
check(#disabled==0 and disabledCount==0 and not R.copyFilters(th36).stages.TH36,'旧配置不能重新启用地灵殿')
local historical,historicalCount=R.buildPool(nil,4)
check(#historical==5 and historicalCount==503,'版本4录像保留五作503项')
local only36,n36=R.buildPool(th36,4)
check(#only36==1 and n36==93,'地灵殿含86阶段和7独立道中')
local bosses,roads=0,0
for _,entry in ipairs(only36[1].cards) do
    check(entry.cardId<11101 or entry.cardId>11107,'地灵殿整关不伪装成道中入池')
    if entry.kind=='road' then
        roads=roads+1
        check(_sc_pr_table[entry.level][entry.index].sc_group[1].card.th11_source.road_only,'道中入口显式剥离Boss')
    else bosses=bosses+1 end
end
check(bosses==86 and roads==7,'地灵殿分类完整')
th36.difficulties={extra=true};th36.encounters={road=true}
local ex36,exCount=R.buildPool(th36,4)
check(exCount==1 and ex36[1].cards[1].cardId==11207,'可只选地灵殿Extra道中')
check(#R.draw(17,1,th36,4,true)==1,'单候选无限模式不跨池补抽')
local _,version3=R.buildPool(nil,3)
check(version3==410,'版本3保持四作410项')
local _,version7=R.buildPool(nil,7)
check(version7==351,'版本7录像缺少筛选初态时仍保留Extra/Phantasm')
local oldRoutes={
    {2,17,'TH31:409,TH35:3602,TH32:3938,TH32:3912,TH34:4395,TH34:3471,TH32:3955,TH34:3480,TH35:3648,TH31:392'},
    {3,17,'TH31:409,TH35:3602,TH32:3938,TH32:3912,TH34:3480,TH34:3411,TH32:3955,TH34:3446,TH35:3648,TH31:392'},
    {3,31415,'TH34:3480,TH31:462,TH32:3925,TH32:3982,TH32:3914,TH31:388,TH32:3932,TH34:4464,TH32:3956,TH34:3406'},
    {4,17,'TH31:409,TH36:11004,TH34:3484,TH32:3912,TH35:3656,TH35:3662,TH34:4402,TH35:3651,TH35:3648,TH31:392'},
}
for _,row in ipairs(oldRoutes) do check(keys(R.draw(row[2],1,nil,row[1]))==row[3],'旧版本相同种子保持原路线') end
check(not R.defaultFilters('dual').stages.TH36 and not R.defaultFilters('chain').stages.TH36,'历史双Boss/接续不扩大来源')
local forbidden={[4408]=true,[4439]=true,[4457]=true,[4468]=true,[4470]=true,
    [4471]=true,[4472]=true,[4473]=true,[4475]=true,[4476]=true,[351]=true,[368]=true}
for _,bucket in ipairs(all) do for _,entry in ipairs(bucket.cards) do
    check(not forbidden[entry.cardId],'Normal/Hard/Last Word/自制不进入新池')
end end
local merged=R.defaultFilters(nil,6)
merged.stages={TH31=false,TH32=false,TH34=true,TH35=false}
merged.difficulties={lunatic=false,extra=true}
local mergedPool,mergedCount=R.buildPool(merged)
local phBoss,phRoad,exBoss=false,false,false
for _,entry in ipairs(mergedPool[1].cards) do
    phBoss=phBoss or entry.cardId==3440
    phRoad=phRoad or entry.cardId==3407
    exBoss=exBoss or entry.cardId==3471
    check(entry.difficulty=='extra','Extra与Phantasm共用同一筛选键')
end
check(mergedCount==45 and phBoss and phRoad and exBoss,'妖妖梦合并池含原EX与PH的Boss和道中')
local _,oldCount=R.buildPool(nil,2)
check(oldCount==387,'版本2录像保留原卡池，不因并入Phantasm重抽路线')
merged.difficulties={lunatic=true,extra=false}
local lunatic=R.buildPool(merged)
for _,entry in ipairs(lunatic[1].cards) do check(entry.originalDifficulty=='lunatic','只选Lunatic不混入Extra/Phantasm') end
local selected=R.defaultFilters()
selected.stages={TH31=false,TH32=true,TH34=false,TH35=false}
selected.difficulties={lunatic=false,extra=true}
selected.encounters={boss=true,road=false}
for seed=1,30 do
    local drawn=R.draw(seed,1,selected)
    local seen={}
    for _,entry in ipairs(drawn) do
        check(entry.source=='TH32' and entry.difficulty=='extra' and entry.kind=='boss','只抽所选红魔乡Extra Boss')
        check(not seen[entry.cardId],'筛选后仍然不重复');seen[entry.cardId]=true
    end
    check(keys(drawn)==keys(R.draw(seed,1,selected)),'筛选后的种子可重建')
end
local small=R.defaultFilters();small.difficulties={lunatic=false,extra=true};small.encounters.boss=false;small.encounters.road=true
local state=R.poolStatus(small)
check(state.valid and state.count==7,'关闭地灵殿后Extra/Phantasm独立道中池含七项')
check(not R.poolStatus(small,1).valid,'历史十战模式仍检查至少十张')
check(not pcall(R.draw,123,1,small),'直接抽取小池也拒绝，防止绕过准备界面')
local empty=R.copyFilters(selected);empty.difficulties.extra=false
check(not R.poolStatus(empty).valid,'空难度不能开始')
empty=R.copyFilters(selected);empty.encounters.boss=false
check(not R.poolStatus(empty).valid,'空战斗类型不能开始')
empty=R.copyFilters(selected);empty.stages.TH32=false
check(not R.poolStatus(empty).valid,'空来源不能开始')
local copy=R.copyFilters(selected);copy.stages.TH31=true
check(not selected.stages.TH31,'筛选副本不回写菜单/本局快照')
do
    local menuUI=dofile('THlib/UI/rogue_pool.lua')
    local remembered,rememberedVersion=scoredata.rogue10_filters,scoredata.rogue10_filters_version
    scoredata.rogue10_filters=R.defaultFilters(nil,7);scoredata.rogue10_filters_version=7
    local o={timer=0,orot=0};menuUI.fresh(o,'roguelike')
    check(not o.pool_expanded and not o.pool_options.difficulties.extra and not o.pool_options.cards.survival and not o.pool_options.encounters.road and o.pool_status.count==249,'高级选项默认折叠，新默认排除Extra/Phantasm、道中和时符')
    check(o.pool_options.cards.nonspell and o.pool_options.cards.spell and o.pool_options.stages.TH32,'默认包含四作的非符和符卡')
    menuUI.toggle(o,9)
    check(o.pool_options.cards.survival and o.pool_status.count==257 and menuUI.ready(o),'独立勾选时符，不影响非符/符卡')
    menuUI.toggle(o,10);menuUI.toggle(o,11)
    check(o.pool_status.count==8,'仅勾选时符时只保留Lunatic耐久卡')
    menuUI.toggle(o,9);check(not menuUI.ready(o),'三种卡片类型全部取消时不能开空局')
    menuUI.toggle(o,10);menuUI.toggle(o,11)
    local oldMenu,oldLast,oldMouse,oldBounds,oldKey,oldSetting=menu,GetLastKey,ext.mouse,sp.math.PointBoundCheck,KEY,setting
    KEY={ENTER=13};setting={keys={shoot=90}}
    menu=setmetatable({keyYes=function() return true end},{__index=function() return function() return false end end})
    GetLastKey=function() return 0 end;o.pool_focus=1
    menuUI.frame(o);check(o.pool_expanded,'射击键展开高级选项')
    o.pool_focus=10;menuUI.frame(o);check(o.pool_options.cards.survival,'射击键切换展开后的时符')
    menu.keyYes=function() return false end
    sp.math.PointBoundCheck=function(x,y,l,r,b,t) return x>=l and x<=r and y>=b and y<=t end
    ext.mouse={x=520,y=110,_wheel=0,isDown=function() return true end}
    menuUI.frame(o);check(not o.pool_options.cards.survival,'触控命中新的时符区域')
    ext.mouse.y=440;menuUI.frame(o);check(not o.pool_expanded,'点击高级选项标题可以折叠')
    ext.mouse.y=110;menuUI.frame(o);check(not o.pool_options.cards.survival,'折叠后的隐藏选项不参与触控命中')
    check(scoredata.rogue10_filters_version==R.POOL_VERSION and not R.savedFilters().cards.survival,'新版记住用户实际勾选，不继承旧默认')
    menu,GetLastKey,ext.mouse,sp.math.PointBoundCheck=oldMenu,oldLast,oldMouse,oldBounds
    KEY,setting=oldKey,oldSetting
    scoredata.rogue10_filters,scoredata.rogue10_filters_version=remembered,rememberedVersion
end

for c,values in pairs(original) do for k,v in pairs(values) do assert(c[k]==v,'原卡参数被改动') end end
check(true,'抽取不改原卡参数与函数')
local function simulate(seed,failRound,variant,endless,filters)
    lstg.var={ran_seed=seed,player_name='reimu_player',current_system='ABC'};lstg.tmpvar={};spawned={};musicEvents={};backgroundEvents={}
    R.start(variant,filters)
    -- 历史十战生命周期仍单独回归；新局无限标记另用下面的跨轮检查覆盖。
    if not endless then lstg.var.__rogue_endless_version=nil end
    local battle=stage.next_stage;stage.next_stage=nil;stage.current_stage=battle;battle.timer=0;battle.task=nil;battle:init()
    check(lstg.var.current_system=='','仅选人，不启用异变系统')
    check(lstg.var.__revive_version==0 and lstg.var.revive==nil,'新局禁用答题复活并清除旧状态')
    check(lstg.var.__rank_version==0 and lstg.var.rank==nil and G.enabled(),'新局禁用Rank并启用阶段HP倍率')
    for tick=1,3000 do
        task.Do(battle);battle:frame();battle.timer=battle.timer+1
        for _,entry in ipairs(spawned) do if entry.obj._live then entry.obj.life=entry.obj.life-1;if entry.obj.life<=0 then entry.obj._live=false;entry.died=stage.current_stage.timer end end end
        if failRound and lstg.var.rogue_run.current==failRound then lstg.var.dead=R.MISS_LIMIT end
        if stage.next_stage then break end
    end
    return battle,lstg.var.rogue_run
end
local battle,run=simulate(100)
check(stage.next_stage==stage.stages[R.RESULT] and run.won and run.completed==10,'十战完成进入成功结算')
check(#spawned==10,'每次只运行抽中的一张卡，共十张')
check(#musicEvents==1 and musicEvents[1]==spawned[1].class.bgm,'短流程不提前换曲，首位Boss决定首曲')
check(#backgroundEvents==1 and backgroundEvents[1]==spawned[1].class._bg,'单 Boss 十战只创建首位 Boss 的关卡背景')
for i=2,#spawned do
    check(spawned[i].tick==spawned[i-1].died,'单 Boss 随机十战死亡后立即创建下一位，没有两战之间的固定等待')
end
check(not spawned[1].obj.__NoCleanBullet,'普通随机十战沿用原有 Boss 自动消弹开关')
for i,entry in ipairs(spawned) do local e=run.cards[i];check(entry.card==_sc_pr_table[e.level][e.index].sc_group[1].card,'运行原始卡对象') end
check(cleared==1,'完成清理续玩点')
stage.current_stage=stage.next_stage;stage.next_stage=nil;stage.current_stage:init()
check(scoredata.rogue10.played==1 and scoredata.rogue10.cleared==1 and saved==1,'独立模式记录，不记为主线通关')
local beforeStop=#stopped
stage.current_stage:del()
check(#stopped==beforeStop+1,'离开结算页停止 SCORE，返回菜单和重开共用此生命周期')
battle,run=simulate(333,3)
check(#stopped==beforeStop+2,'新局入口也停止残留 SCORE')
check(stage.next_stage==stage.stages[R.RESULT] and not run.won and run.completed<10,'十次失误结束，失败不算通关')
stage.current_stage=stage.next_stage;stage.next_stage=nil;stage.current_stage:init()
check(scoredata.rogue10.played==2 and scoredata.rogue10.cleared==1,'失败次数与通关次数分开')
replay=true;cleared=0;stage.next_stage=nil;battle.rogue_finished=false;lstg.var.dead=0;run.completed=10
R.finish(battle,true)
check(ext.rep_over and ext.pop_pause_menu and not stage.next_stage and cleared==0,'录像结束使用回放菜单，不删玩家续玩点')

-- 接续模式：达到血量或时间阈值时下一帧创建下一张，旧 Boss 继续存活。
replay=false;ext.rep_over=nil;ext.pop_pause_menu=nil
lstg.var={ran_seed=8801,player_name='reimu_player',current_system='ABC'};lstg.tmpvar={};spawned={}
R.start('chain');battle=stage.next_stage;stage.next_stage=nil;stage.current_stage=battle;battle.timer=0;battle.task=nil;battle:init()
local function chainTick()
    task.Do(battle);battle:frame();battle.timer=battle.timer+1
end
for _=1,150 do chainTick() end
check(#spawned==1,'接续模式：先创建第一张')
local first=spawned[1].obj
check(first.__NoCleanBullet==true,'接续首个 Boss 禁止击破结算和死亡爆炸自动全屏消弹')
first.hp=16;chainTick();check(#spawned==1,'接续模式：16% 仍等待')
first.ui={};first.hp=15;chainTick()
check(#spawned==2 and IsValid(first) and first.ui.no_infobar and first.NotPlayTimeOutSound,'接续模式：15% 创建下一张、旧 Boss 保留并静默旧 UI')
local second=spawned[2].obj
check(second.group==GROUP.GHOST,'接续模式：旧 Boss 存活时新 Boss 使用 GHOST 碰撞组')
first._live=false;chainTick()
check(second.group==GROUP.ENEMY,'接续模式：旧 Boss 死亡后恢复新 Boss 碰撞组')
chainTick();check(second.group==GROUP.ENEMY,'接续模式：恢复后不会再次变回 GHOST')
second.hp=second.maxhp;second.t3=1000;second.timer=820;chainTick();check(#spawned==2,'接续模式：剩余 3 秒仍等待')
second.timer=821;chainTick();check(#spawned==3,'接续模式：不足 3 秒创建下一张')
check(spawned[3].obj.group==GROUP.GHOST,'接续模式：每张新 Boss 都先以 GHOST 等待前一张死亡')
while #spawned<10 do
    local current=spawned[#spawned].obj
    current.hp=current.maxhp*R.CHAIN_HP
    chainTick()
end
-- 接续复用同一条 prepare 路径，不能在新 Boss 入场时重建场景。
check(battle.rogue_scene_ready and battle.now_music==spawned[1].class.bgm,'接续模式仍持有首位 Boss 音乐')
check(#spawned==10 and run and lstg.var.rogue_run.completed==9,'接续模式：创建满十张')
for _,entry in ipairs(spawned) do check(entry.obj.__NoCleanBullet==true,'接续后续 Boss 均继承不消弹开关') end
local last=spawned[10].obj;last.hp=last.maxhp*R.CHAIN_HP;chainTick()
run=lstg.var.rogue_run
check(stage.next_stage==stage.stages[R.modes.chain.result] and run.won and run.completed==10,'接续模式：第十张达到阈值后成功结算')
-- 进度栏在 ObjRender 中先于符卡名绘制，不能把后续对象留在 UI 坐标系。
local panel=assert(panels[#panels]);local setView,oldUI=SetViewMode,ui
local stageText={}
ui={RenderText=function(_,_,value) stageText[#stageText+1]=value end,RunHUD=dofile('THlib/UI/run_hud.lua')}
lstg.world={scrl=288,scrr=672,scrb=46,scrt=494}
SetViewMode=function(mode) lstg.viewmode=mode end
for _,view in ipairs({'world','ui','3d'}) do
    lstg.viewmode=view;panel.class.render(panel.obj)
    check(lstg.viewmode==view,'随机模式进度栏恢复调用方坐标系：'..view)
end
check(#stageText==9 and stageText[1]=='10' and stageText[4]=='10' and stageText[7]=='10','左侧显示大号阶段数字及累计倍率和入场动画')
stageText={}
local renderClear=RenderClear;RenderClear=function() end
stage.stages[R.modes.chain.result].render({run=lstg.var.rogue_run})
RenderClear=renderClear
check(#stageText==3 and stageText[1]=='10','结算中央仅显示结束时的阶段数字，其余文字仅为返回/重开按钮')
SetViewMode,ui=setView,oldUI
-- 真实无限入口：风神录Extra道中单卡池抽完后继续，直到失误结束。
local endlessFilters=R.defaultFilters()
endlessFilters.stages={TH35=true};endlessFilters.difficulties={extra=true};endlessFilters.encounters={road=true}
local endlessBattle,endlessRun=simulate(777,25,'single',true,endlessFilters)
check(endlessRun.endless and endlessRun.poolVersion==R.POOL_VERSION,'新局写入当前卡池版本及无限标记')
check(endlessRun.completed>=24 and not endlessRun.won,'无限模式超过十战后仍继续')
check(endlessRun.cycle>=24 and #endlessRun.cards==1,'小池跨轮洗牌只保留当前轮')
for _,entry in ipairs(spawned) do check(entry.card.card_id==3685,'多轮严格沿用风神录Extra道中筛选') end
-- 使用正式 Boss 系统函数验证两种自动清屏，而不是只检查接续对象上的标记。
local f=assert(io.open('THlib/enemy/boss_system.lua','rb'));local bossSource=f:read('*a');f:close()
local system={}
for _,name in ipairs({'explode','popResult'}) do
    local a=assert(bossSource:find('function system:'..name..'(',1,true))
    local b=assert(bossSource:find('\nfunction system:',a+1,true))
    assert(loadstring('local system=...\n'..bossSource:sub(a,b-1)))(system)
end
local oldNew,oldDel=New,object.Del
local cleaners=0
New=function(class) if class==bullet_cleaner then cleaners=cleaners+1 end end
object.Del=function(o) o._live=false end
local function cleanCount(name,disabled)
    cleaners=0
    local b={_live=true,x=0,y=0,timer=0,hp=100,sc_left=1,is_combat=true,
        __NoCleanBullet=disabled,__dieinstantly=true,__no_drop_explode_cherry=true}
    local sys={boss=b,popSpellResult=function() end,popResult=function() end,
        setIsSpellcard=function() end,setSCName=function() end,setIsWaiting=function() end}
    system[name](sys,false)
    if name=='explode' then task.Do(b) end
    return cleaners
end
for _,name in ipairs({'explode','popResult'}) do
    check(cleanCount(name,first.__NoCleanBullet)==0,'接续真实结算不创建全屏消弹器：'..name)
    check(cleanCount(name,nil)==1,'普通真实结算仍创建全屏消弹器：'..name)
end
New,object.Del=oldNew,oldDel
print(('随机十战回归通过：%d 项；TH31=%d、TH34=%d、TH35=%d；含接续模式阈值与重叠生成。'):format(total,counts.TH31,counts.TH34,counts.TH35))

if checkDual then
    local verify=dofile('tools/check_dual_rogue.lua')
    verify({R=R,pool=pool,check=check,simulate=simulate,spawns=function() return spawned end,setReplay=function(v) replay=v end})
    print('双 Boss 检查累计通过：'..total..' 项')
end
