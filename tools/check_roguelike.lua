-- 读取原卡注册，验证抽取与十战生命周期；不读写玩家 User/ 或 replay/。
local checkDual=arg[1]=='--dual'
arg[1]='roguelike-registry'
local file=assert(io.open('tools/check_stage.lua','rb'));local source=file:read('*a');file:close()
local position=assert(source:find('if path == "--all" then',1,true))
assert(loadstring(source:sub(1,position-1)))()
local total=0
local function check(value,label) assert(value,label);total=total+1 end
local oldAdd=boss.card.add
_sc_pr_table={}
boss.card.add=function(parts,level,label,id,...)
    oldAdd(parts,level,label,id,...)
    local unit={CardName=label,sc_group={}}
    for _,part in ipairs(parts) do unit.sc_group[#unit.sc_group+1]={boss=_editor_boss[part[2]..level],card=part[1]} end
    _sc_pr_table[level]=_sc_pr_table[level] or {};table.insert(_sc_pr_table[level],unit)
end
dofile('mod/_editor_output.lua')
for _,id in ipairs({'31','34','35'}) do dofile('mod/GAME/th'..id..'.lua') end
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
StopMusic=function() error('随机十战不应在战斗中切换音乐') end
background.Create=function(class) backgroundEvents[#backgroundEvents+1]=class end
mask_fader={Do=function() end};lstg={var={},tmpvar={}};scoredata={}
GROUP={GHOST=0,ENEMY=2};LAYER={TOP=0}
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
local R=dofile('mod/roguelike.lua');local pool=R.buildPool()
local counts={};local original={};local spell,non=false,false
-- 锁住会暴露“拿 Boss 资源 id 查标定表”的代表卡：三面非符、五面中 BOSS 非符、二面过渡非符。
local calibrated={[427]=725,[3433]=774,[467]=227}
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
    local plan=R.draw(seed);check(#plan==10,'恰好十战')
    local seen={};for _,entry in ipairs(plan) do assert(not seen[entry.key],'本局重复卡');seen[entry.key]=true;observed[entry.source]=true end
    check(keys(plan)==keys(R.draw(seed)),'相同种子固定路线，支持录像与重建')
end
check(observed.TH31 and observed.TH34 and observed.TH35,'三个来源均能抽到')
check(keys(R.draw(17))~=keys(R.draw(31415)),'不同种子产生不同路线')
for c,values in pairs(original) do for k,v in pairs(values) do assert(c[k]==v,'原卡参数被改动') end end
check(true,'抽取不改原卡参数与函数')
local function simulate(seed,failRound,variant)
    lstg.var={ran_seed=seed,player_name='reimu_player',current_system='ABC'};lstg.tmpvar={};spawned={};musicEvents={};backgroundEvents={}
    R.start(variant);local battle=stage.next_stage;stage.next_stage=nil;stage.current_stage=battle;battle.timer=0;battle.task=nil;battle:init()
    check(lstg.var.current_system=='','仅选人，不启用异变系统')
    check(lstg.var.__revive_version==2,'新局使用五命复活规则')
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
check(#musicEvents==1 and musicEvents[1]==spawned[1].class.bgm,'单 Boss 十战全程只播放首位 Boss 的 BGM')
check(#backgroundEvents==1 and backgroundEvents[1]==spawned[1].class._bg,'单 Boss 十战只创建首位 Boss 的关卡背景')
for i=2,#spawned do
    check(spawned[i].tick==spawned[i-1].died,'单 Boss 随机十战死亡后立即创建下一位，没有两战之间的固定等待')
end
check(not spawned[1].obj.__NoCleanBullet,'普通随机十战沿用原有 Boss 自动消弹开关')
for i,entry in ipairs(spawned) do local e=run.cards[i];check(entry.card==_sc_pr_table[e.level][e.index].sc_group[1].card,'运行原始卡对象') end
check(cleared==1,'完成清理续玩点')
stage.current_stage=stage.next_stage;stage.next_stage=nil;stage.current_stage:init()
check(scoredata.rogue10.played==1 and scoredata.rogue10.cleared==1 and saved==1,'独立模式记录，不记为主线通关')
battle,run=simulate(333,3)
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
ui={RenderText=function() end}
SetViewMode=function(mode) lstg.viewmode=mode end
for _,view in ipairs({'world','ui','3d'}) do
    lstg.viewmode=view;panel.class.render(panel.obj)
    check(lstg.viewmode==view,'随机模式进度栏恢复调用方坐标系：'..view)
end
SetViewMode,ui=setView,oldUI
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
