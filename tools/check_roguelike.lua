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
ext={replay={IsReplay=function() return replay end},GetPauseMenuOrder=function() end,achievement={get=function() end}}
SaveResume={clear=function() cleared=cleared+1 end}
SaveScoreData=function() saved=saved+1 end;SaveSpellCardData=function() end
PlayMusic=function() end;StopMusic=function() end;background.Create=function() end
mask_fader={Do=function() end};lstg={var={},tmpvar={}};scoredata={}
GROUP={GHOST=0};LAYER={TOP=0}
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
    if cards then obj.life=3;spawned[#spawned+1]={obj=obj,class=class,card=cards[1],tick=stage.current_stage.timer}
    elseif class.init then class.init(obj) end
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
    lstg.var={ran_seed=seed,player_name='reimu_player',current_system='ABC'};lstg.tmpvar={};spawned={}
    R.start(variant);local battle=stage.next_stage;stage.next_stage=nil;stage.current_stage=battle;battle.timer=0;battle.task=nil;battle:init()
    check(lstg.var.current_system=='','仅选人，不启用异变系统')
    for tick=1,3000 do
        task.Do(battle);battle:frame();battle.timer=battle.timer+1
        for _,entry in ipairs(spawned) do if entry.obj._live then entry.obj.life=entry.obj.life-1;if entry.obj.life<=0 then entry.obj._live=false end end end
        if failRound and lstg.var.rogue_run.current==failRound then lstg.var.dead=R.MISS_LIMIT end
        if stage.next_stage then break end
    end
    return battle,lstg.var.rogue_run
end
local battle,run=simulate(100)
check(stage.next_stage==stage.stages[R.RESULT] and run.won and run.completed==10,'十战完成进入成功结算')
check(#spawned==10,'每次只运行抽中的一张卡，共十张')
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
print(('随机十战回归通过：%d 项；TH31=%d、TH34=%d、TH35=%d；400 个种子、十战成功与失败、录像收尾。'):format(total,counts.TH31,counts.TH34,counts.TH35))

if checkDual then
    local verify=dofile('tools/check_dual_rogue.lua')
    verify({R=R,pool=pool,check=check,simulate=simulate,spawns=function() return spawned end,setReplay=function(v) replay=v end})
    print('双 Boss 检查累计通过：'..total..' 项')
end
