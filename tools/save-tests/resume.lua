-- 临时目录中的真实续玩模块和输入/录像实现；模拟物理、协程和成长奖励，校验重建。
local host=dofile(assert(arg[1])..'/tools/save-tests/runtime.lua');local C,P=host.C,host.P
P.init();local total=0
local function check(value,label) assert(value,label);total=total+1 end
local keys,last={},0
setting={mod='Boss Rush HD',keys={up=38,down=40,left=37,right=39,shoot=90,slow=16,spell=88,special=67},sevolume=100,bgmvolume=100}
max=math.max;Print=function() end;KEY={CTRL=17};GetKeyState=function(k) return keys[k]==true end;GetLastKey=function() return last end
local function random()
    local r={value=1,seed=1};function r:Seed(v) self.value=v%2147483646+1;self.seed=v end
    function r:GetSeed() return self.seed end
    function r:Float(a,b) self.value=self.value*48271%2147483647;return a+(b-a)*self.value/2147483647 end
    function r:Int(a,b) return a+math.floor(self:Float(0,1)*(b-a+1)) end
    function r:Sign() return self:Int(0,1)*2-1 end
    return r
end
Rand=random;ran=Rand();StopWatch=function() return {GetElapsed=function() return 0 end} end
lstg={var={},SystemLog=function(v) if v:find('restore') then print(v) end end}
scoredata={money=10,Achievement={},NoticeAchievement={},Duration={0,0,0,0,0},hiscore={}};spell_card_data={{reimu={0,0}}}
EncodeSpellCardData=function() return spell_card_data end
local fraction,offset=0,7
GetSaveMoneyState=function() return {fraction=fraction,offset=offset} end
SetSaveMoneyState=function(value) fraction,offset=value.fraction,value.offset;CurrentMoney=scoredata.money+offset end
SaveScoreData=function() if not SaveResume or not SaveResume.recovering then P.write('Score.dat',C.lock(Serialize(scoredata))) end end
SaveSpellCardData=function() if not SaveResume or not SaveResume.recovering then P.write('Spellcard.dat',C.lock(Serialize(spell_card_data))) end end
plus.EnumFiles=function() return {} end
dofile(host.root..'/THlib/plus/Utility.lua');dofile(host.root..'/THlib/plus/IO.lua');dofile(host.root..'/THlib/plus/Replay.lua')
__UTF8ToANSI=function(s) return s end;SystemLog=function() end
KeyState,KeyStatePre={},{}
mask_fader={time=0,maxtime=30,mode=true}
local R=dofile(host.root..'/THlib/save/resume.lua');R.codeHash=function() return C.sha256('headless deterministic scene') end
stage={stages={},groups={}}
local group={title='menu',number=1,[1]='TH06@BossRush'};stage.groups.BossRush=group
stage.stages.menu={is_menu=true,stage_name='menu',save_replay={}}
local objects,hero,worker={}
local withRevive,withRank,skipRankInit,withDrops,withTouch,withBomb=false,false,false,false,false,false
local stageObject={is_menu=false,stage_name='TH06@BossRush',number=1,group=group,timer=0}
stage.stages[stageObject.stage_name]=stageObject;stage.current_stage=stage.stages.menu
ObjList=function(g)
    local i=0;return function() repeat i=i+1;if not objects[i] then return nil end until objects[i].group==g;return i,objects[i] end
end
ext={ResetTicker=function() end,pause_menu={init=function() end,FlyIn=function() end},music={}}
dofile(host.root..'/THlib/ext/ext_replay.lua');dofile(host.root..'/THlib/lib/Linput.lua')
local capturedRandom=math.random
function stageObject:init()
    mask_fader.time=31
    objects={};hero={group=1,x=0,y=-100,vx=0,vy=0,rot=0,timer=0,life=3,protect=0,power=1};objects[1]=hero
    if withRevive then
        player=hero;hero._live=true;hero.death=0;hero.lock=false;hero.dialog=false;hero.hide=false;hero.colli=true;hero.time_stop=false
        hero.hspeed=4;hero.lspeed=2
    end
    if withRank then if not skipRankInit then GameRank.reset() end;hero.group=4 end
    if withDrops then GameDrops.reset();GameDrops.bind(hero);hero.nextshoot=0 end
    self.watch=StopWatch()
    worker=coroutine.create(function()
        while true do
            if self.timer%7==0 then objects[#objects+1]={_live=true,status='normal',group=withRank and 1 or 2,x=ran:Float(-100,100),y=120,vx=capturedRandom(-2,2),vy=-2,rot=0,timer=0,hp=1} end
            coroutine.yield()
        end
    end)
end
local function initialize()
    R.prepareStage();if lstg.nextvar then lstg.var=lstg.nextvar;lstg.nextvar=nil end
    ran:Seed(lstg.var.ran_seed);stage.current_stage=stage.next_stage;stage.next_stage=nil
    stage.current_stage.timer=0;stage.current_stage:init();R.afterStageInit()
end
local function step()
    if stage.next_stage then initialize() end
    if not R.beforeLogic() then return end
    GetInput()
    if withRevive then
        if not withDrops and stage.current_stage.timer==80 and not lstg.var.test_missed then lstg.var.dead=10;lstg.var.test_missed=true;if withRank then GameRank.miss() end end
        if GameRevive.frame(stage.current_stage) then if withDrops then GameDrops.suspend() end;R.afterLogic();return end
    end
    if withDrops then
        if stage.current_stage.timer==45 and not lstg.var.test_drop then
            lstg.var.test_drop=true
            local card={card_id=998,is_combat=true};local b={is_combat=true,current_card=card,otherboss={}}
            GameDrops.beginCard(b,card);GameDrops.award(b)
        end
        GameDrops.playerStep(hero)
        if withBomb then GameDrops.bombInput(hero,KeyState,KeyStatePre) end
        GameDrops.shoot(hero,function(p)
            if p.timer%4==0 then objects[#objects+1]={_live=true,group=3,x=p.x,y=p.y,vx=0,vy=3,rot=0,timer=0,hp=1} end
        end)
    end
    if withRank then
        GameRank.step()
        if stage.current_stage.timer==40 then
            local b={is_sc=true,otherboss={}};GameRank.beginCard(b,{card_id=999,is_sc=true,t1=1,t3=10});GameRank.capture(b)
        end
        GameRank.beforeObjects()
    end
    stage.current_stage.timer=stage.current_stage.timer+1
    if withTouch then
        local dx,dy=TouchInputMovement(hero,KeyState,KeyState.slow and 2 or 4);hero.vx=dx or 0;hero.x=hero.x+hero.vx;hero.y=hero.y+(dy or 0)
    else hero.vx=(KeyState.right and 2 or 0)-(KeyState.left and 2 or 0);hero.x=hero.x+hero.vx end
    if GetKeyState(65) then hero.y=hero.y+1 end
    if GetLastKey()==13 then hero.y=hero.y-1 end
    local ok,err=coroutine.resume(worker);assert(ok,err)
    for _,obj in ipairs(objects) do obj.x=obj.x+((obj.group==2 or (withRank and obj~=hero)) and obj.vx or 0);obj.y=obj.y+(obj.vy or 0);obj.timer=obj.timer+1 end
    if withRank then GameRank.afterObjects() end
    if withDrops then GameDrops.frame(stage.current_stage) end
    if stage.current_stage.timer%5==0 then scoredata.money=scoredata.money+1;CurrentMoney=scoredata.money+offset;spell_card_data[1].reimu[2]=spell_card_data[1].reimu[2]+1 end
    lstg.var.score=stage.current_stage.timer*10;R.afterLogic()
end
lstg.var={player_name='reimu',rep_player='reimu',score=0,dead=0,getsc=0,graze=0,saving=0,current_system='',is_practice=false}
stage.Set('save',stageObject.stage_name)
for frame=1,420 do
    keys={[frame%40<20 and 39 or 37]=true,[90]=true,[65]=frame%11==0};last=frame%13==0 and 13 or 0
    step()
    -- 显示帧随机消耗不参与逻辑序列；重建阶段不会执行这些调用。
    for _=1,frame%5 do ran:Float(0,1);math.random() end
    mask_fader.time=math.max(0,mask_fader.time-1)
end
check(R.flush('test'),'关内位置保存')
local expectedSignature=R.signature();local expectedMoney=scoredata.money;local expectedSpell=spell_card_data[1].reimu[2]
local data=assert(R.peek());check(data.frames==420,'准确逻辑帧计数');check(data.signature==expectedSignature,'持久化终点校验')
check(R.decode(P.read('resume.dat')).frames==420,'落盘数据解码')
local bundle=P.export({P.index.active},true);check(bundle.version==2 and bundle.entries[1].files['resume.dat'],'续玩点随存档同步')
check(P.preview(bundle)[1].identical,'交换包续玩校验');check(not P.export({P.index.active},false).entries[1].files['resume.dat'],'可排除续玩数据')
local stored=P.read('resume.dat');R.session=nil;R.enabled=false;R.inLogic=false;stage.current_stage=stage.stages.menu;stage.next_stage=nil
-- 从不同的外部随机状态和键盘状态开始冷重建。
for _=1,100 do math.random();ran:Int(1,100) end
keys={};last=0;R.request()
for _=1,1000 do if not R.recovering then break end;R.pump(step) end
check(not R.recovering and not R.failure and R.session,'重建完成')
check(R.signature()==expectedSignature,'对象、协程与随机运动终点一致')
check(scoredata.money==expectedMoney and spell_card_data[1].reimu[2]==expectedSpell,'恢复不会重复增长金币或符卡次数')
check(scoredata.resume_count==1,'恢复次数单独记录')
check(stage.current_stage.watch:GetElapsed()==420/60,'逻辑时钟重建')
check(mask_fader.time==0,'重建恢复保存时的入场转场，避免暂停背景遮黑')
check(not R.beforeLogic() and R.session.frames==420,'完整绘制前逻辑保持保存帧')
R.afterRender();check(not R.pauseAfterRender,'完整绘制后切入暂停')
-- 状态不一致时停止，保存原记录，不把半重建数据写成新的存档。
local bad=clone and clone(data) or DeSerialize(Serialize(data));bad.signature=string.rep('0',64)
P.atomic(P.path('resume.dat'),R.encode(bad));R.memo=nil;R.session=nil;stage.current_stage=stage.stages.menu;stage.next_stage=nil
R.request();for _=1,1000 do if not R.recovering then break end;R.pump(step) end
check(not R.recovering and R.session==nil and stage.next_stage==stage.stages.menu,'偏离时退回标题')
check(P.read('resume.dat')==R.encode(bad),'失败后原续玩文件保留')
local broken=assert(io.open(P.path('resume.dat'),'wb'));broken:write('broken');broken:close();R.memo=nil
check(R.peek()~=nil,'损坏主记录可从备份恢复')
P.atomic(P.path('resume.dat'),stored);R.memo=nil;local originalCode=R.codeHash;R.codeHash=function() return string.rep('f',64) end
check(not pcall(R.request),'脚本版本不同拒绝重建');R.codeHash=originalCode
local malformed=DeSerialize(Serialize(data));malformed.frames=1000001;check(not pcall(R.validate,malformed),'超长输入拒绝')
malformed=DeSerialize(Serialize(data));malformed.start.context.globals.ExecuteFlag={};check(not pcall(R.validate,malformed),'非法上下文拒绝')
malformed=DeSerialize(Serialize(data));malformed.target.music={bad={timer=-1}};check(not pcall(R.validate,malformed),'非法音轨位置拒绝')
malformed=DeSerialize(Serialize(data));local growth=DeSerialize(malformed.target.stats.score);growth.PlayerBrand={};malformed.target.stats.score=Serialize(growth)
check(not pcall(R.validate,malformed),'非法成长字段拒绝')
-- 未标记的旧录像不改变原有随机序列。
R.enabled=false;R.inLogic=false;local legacy=Rand();legacy:Seed(2468);ran:Seed(2468)
check(ran:Float(-1,1)==legacy:Float(-1,1) and ran:Float(-1,1)==legacy:Float(-1,1),'旧录像随机路径保持原样')
stage.current_stage=stage.stages.menu;stage.next_stage=nil;R.session=nil
stage.Set('save',stageObject.stage_name);initialize();check(R.flush('zero'),'零帧位置保存')
local zeroSignature=R.signature();R.session=nil;stage.current_stage=stage.stages.menu;stage.next_stage=nil
R.request();R.pump(step)
check(not R.recovering and R.session.frames==0 and R.signature()==zeroSignature,'零帧恢复不多跑一个逻辑帧')
print('关内续玩回归通过：'..total..' 项；420 帧随机物理与协程重建，成长数据不重复。')

-- 答题期间与复活后的完整冷重建：世界帧冻结，题目、选项、答题时间和次数不能重抽。
dofile(host.root..'/THlib/ext/ext_quiz.lua');GameQuiz.selection=function() end;GameQuiz.clearSelection=function() end;local V=dofile(host.root..'/THlib/ext/ext_revive.lua')
IsValid=function(o) return o and o._live end;PlaySound=function() end
withRevive=true;stageObject.revive_miss_limit=9;replayWriter=nil
R.session=nil;R.pauseAfterRender=nil;R.recoveryStopped=nil;R.enabled=false;R.inLogic=false
stage.current_stage=stage.stages.menu;stage.next_stage=nil
lstg.var={player_name='reimu',rep_player='reimu',score=0,dead=0,getsc=0,graze=0,saving=0,current_system='',is_practice=false,__revive_version=1}
keys={};last=0;stage.Set('save',stageObject.stage_name)
for _=1,200 do step() end
check(V.active() and stageObject.timer==80 and lstg.var.revive.quiz.age==120,'答题中物理冻结而续玩帧持续记录')
check(R.flush('quiz'),'答题中保存')
local quiz=Serialize(lstg.var.revive.quiz);local quizSignature=R.signature()
local function coldRestore()
    R.memo=nil;R.session=nil;R.pauseAfterRender=nil;R.recoveryStopped=nil
    stage.current_stage=stage.stages.menu;stage.next_stage=nil;keys={};last=0
    if withTouch then replayWriter=nil;lstg.var={} end
    R.request();for _=1,1000 do if not R.recovering then break end;R.pump(step) end
    check(not R.recovering and not R.failure and R.session,'复活状态冷重建完成：'..tostring(R.failure or R.message))
    R.afterRender()
end
coldRestore()
check(Serialize(lstg.var.revive.quiz)==quiz and R.signature()==quizSignature,'答题恢复题目、乱序选项、时间、选择和世界签名一致')
local correct=lstg.var.revive.quiz.correct
for _=1,100 do
    local lane=GameQuiz.answer(hero.x)
    if lane==correct then break end
    keys={[lane<correct and 39 or 37]=true};step()
end
keys={[38]=true};for _=1,GameQuiz.TIME do step();if lstg.var.revive.quiz and lstg.var.revive.quiz.result~=nil then break end end;keys={}
for _=1,60 do step() end
check(not V.active() and lstg.var.revive.used==1 and V.misses()==9 and lstg.var.dead==10,'恢复后可正确作答，累计失误不回退')
for _=1,15 do step() end
check(R.flush('revived'),'复活后保存')
local revivedSignature=R.signature();local used=lstg.var.revive.used
coldRestore()
check(R.signature()==revivedSignature and lstg.var.revive.used==used and used==1,'复活次数与无敌时间冷重建，不额外补机会')
print('含答题与复活的续玩回归通过：'..total..' 项。')

-- Rank、倍率后的弹幕位置和答题冻结一起冷重建；不能再次补收卡或重复扣 Rank。
GameRank=dofile(host.root..'/THlib/rank.lua');withRank=true;replayWriter=nil
R.session=nil;R.pauseAfterRender=nil;R.recoveryStopped=nil;R.enabled=false;R.inLogic=false
stage.current_stage=stage.stages.menu;stage.next_stage=nil
lstg.var={player_name='reimu',rep_player='reimu',score=0,dead=0,getsc=0,graze=0,saving=0,current_system='',is_practice=false,__revive_version=1,__rank_version=1}
keys={};last=0;stage.Set('save',stageObject.stage_name)
for _=1,200 do step() end
check(lstg.var.rank.frames==80 and lstg.var.rank.captures==1 and lstg.var.rank.misses==1,'自然成长只累计真实战斗帧，收卡和中弹各发生一次')
check(lstg.var.rank.units==50*1200+80+3*1200-8*1200,'Rank 按整数单位记录准确值')
check(R.flush('rank'),'含 Rank 的关内位置保存')
local rankSignature=R.signature();local savedRank=Serialize(lstg.var.rank)
coldRestore()
check(R.signature()==rankSignature and Serialize(lstg.var.rank)==savedRank,'Rank、事件计数及变速后的世界签名完全重建')
check(lstg.var.rank.captures==1 and lstg.var.rank.misses==1,'恢复没有重复加收卡奖励或重复扣 Rank')
print('含 Rank 的续玩回归通过：'..total..' 项。')

skipRankInit=true;replayWriter=nil;R.session=nil;R.pauseAfterRender=nil;R.recoveryStopped=nil;R.inLogic=false
stage.current_stage=stage.stages.menu;stage.next_stage=nil
lstg.var={player_name='reimu',rep_player='reimu',score=0,dead=0,getsc=0,graze=0,saving=0,current_system='',is_practice=false,__revive_version=1,__rank_version=1}
stage.Set('save',stageObject.stage_name);initialize();check(R.flush('rank-zero'),'迁移后的零帧 Rank 位置保存')
local beforeHUD=R.signature();GameRank.value();GameRank.factor()
check(lstg.var.rank==nil and R.signature()==beforeHUD,'零帧 HUD 显示不改变保存状态')
coldRestore();check(R.signature()==beforeHUD and lstg.var.rank==nil,'旧检查点默认 Rank 的零帧冷重建一致')
print('含 Rank 和零帧边界的续玩回归通过：'..total..' 项。')

-- 掉落过程和成长后的射击时钟也参与精确重建。
GameDrops=dofile(host.root..'/THlib/drops.lua');withDrops=true;replayWriter=nil
lstg.world={l=-192,r=192,b=-224,t=224,pl=-192,pr=192,pb=-224,pt=224}
lstg.var={player_name='reimu',rep_player='reimu',score=0,dead=0,getsc=0,graze=0,saving=0,current_system='',is_practice=false,__revive_version=1,__rank_version=1,__drops_version=1}
stage.current_stage=stage.stages.menu;stage.next_stage=nil;stage.Set('save',stageObject.stage_name);initialize()
keys={[39]=true};last=0
for i=1,62 do step() end
check(lstg.var.upgrades.active and lstg.var.upgrades.active.age==17 and stageObject.timer==62,'掉落叠加期间关卡与输入逻辑帧同步前进')
check(R.flush('drops-active'),'掉落中途保存')
local activeDropSignature=R.signature();local activeDrop=Serialize(lstg.var.upgrades)
coldRestore();check(R.signature()==activeDropSignature and Serialize(lstg.var.upgrades)==activeDrop,'下落位置、候选项、玩家数值和射击时钟冷重建一致')
for i=1,GameQuiz.TIME do if not lstg.var.upgrades.active and #lstg.var.upgrades.queue==0 then break end;step() end
local red,blue=GameDrops.values(1);check(red~=100 or blue~=100,'重建后可继续接取道具')
check(R.flush('drops-picked'),'成长后保存')
local pickedSignature=R.signature();local pickedValues=Serialize(lstg.var.upgrades)
coldRestore();check(R.signature()==pickedSignature and Serialize(lstg.var.upgrades)==pickedValues,'已接取奖励不会因恢复重复应用')
for i=1,30 do step() end;check(R.flush('drops-shoot'),'成长后的发弹过程保存')
local shootSignature=R.signature();coldRestore();check(R.signature()==shootSignature,'成长后真实弹数与射击节拍重新构建一致')
print('含掉落与火力 / 射速的续玩回归通过：'..total..' 项。')


-- 新版拖拽输入、Bomb 自然恢复和红蓝掉落的完整冷重建。
withTouch,withBomb=true,true;skipRankInit=false;replayWriter=nil;R.session=nil;R.recoveryStopped=nil;R.inLogic=false
R.pauseAfterRender=nil;R.memo=nil;R.enabled=false;LoadSaveInputState({})
stage.current_stage=stage.stages.menu;stage.next_stage=nil
lstg.var={player_name='reimu',rep_player='reimu',score=0,dead=0,getsc=0,graze=0,saving=0,current_system='',is_practice=false,
    __revive_version=1,__rank_version=1,__drops_version=2,__input_version=2}
local liveTouch={};AndroidInput={reset=function() end,readMovement=function(out) out.touch_x,out.touch_y=liveTouch.x,liveTouch.y end}
lstg.system={castCharge4=function(_,p) p.protect=300;objects[#objects+1]={_live=true,group=3,x=p.x,y=p.y,vx=0,vy=1,rot=0,timer=0,hp=1} end}
keys={};last=0;stage.Set('save',stageObject.stage_name)
for i=1,180 do
    liveTouch=i<150 and {x=math.floor(math.sin(i/18)*100*16)/16,y=math.floor((-100+math.cos(i/21)*40)*16)/16} or {}
    keys={[16]=true,[88]=i==5 or i==35};step()
end
local bombCount,progress=GameDrops.bombState(hero)
check(bombCount==1 and progress>0 and KeyState.touch_x==nil,'新版实际输入释放两次 Bomb，抬手后目标清空且恢复持续推进')
check(R.flush('touch-bomb'),'新版拖拽与 Bomb 恢复进度保存')
local touchSignature=R.signature();local savedHeroX,savedHeroY=hero.x,hero.y;local growth=Serialize(lstg.var.upgrades)
local checkpoint=assert(R.peek());local changed=DeSerialize(Serialize(checkpoint))
changed.inputs=C.base64(C.unbase64(changed.inputs):sub(1,-2))
check(not pcall(R.validate,changed),'拒绝缺失拖拽字节的续玩输入')
coldRestore()
check(R.signature()==touchSignature and hero.x==savedHeroX and hero.y==savedHeroY,'任意角度拖拽与抬手后的实际移动完整重建')
check(Serialize(lstg.var.upgrades)==growth and GameDrops.bombState(hero)==1,'红蓝成长、Bomb 数量和恢复余量完整重建')
print('含精确拖拽和 Bomb 的续玩回归通过：'..total..' 项。')

-- 真二进制录像：新旧格式混排，按帧数而非字节数定位下一关。
local inputs={{shoot=true,touch_x=-16.25,touch_y=-173.0625},{slow=true,touch_x=100.125,touch_y=9.5},{spell=true}}
local records={}
for _,version in ipairs({1,2,1,2}) do
    lstg.var.__input_version=version;local writer=plus.ReplayFrameWriter()
    for _,input in ipairs(inputs) do writer:Record(input) end
    records[#records+1]={stageName='test'..#records,stagePlayer='reimu',stageExtendInfo=Serialize({__input_version=version}),
        frameData=writer,score=0,randomSeed=1,stageDate=0}
end
local replayPath=P.userRoot()..'/touch-test.rep'
plus.ReplayManager.SaveReplayInfo(replayPath,{gameName='Boss Rush HD',gameVersion=1,group_finish=0,userName='test',stages=records})
local info=plus.ReplayManager.ReadReplayInfo(replayPath)
check(#info.stages==4,'新旧帧格式混排可读取所有关卡')
for i,record in ipairs(info.stages) do
    local version=DeSerialize(record.stageExtendInfo).__input_version
    -- 故意使当前游戏版本与录像相反，验证读取不依赖菜单的旧 var。
    lstg.var.__input_version=version==2 and 1 or 2
    local reader=plus.ReplayFrameReader(replayPath,record.frameDataPosition,record.frameCount,version);local out={}
    for frame,input in ipairs(inputs) do
        check(reader:Next(out) and KeyState2Byte(out)==KeyState2Byte(input),'新旧录像按键准确读取')
        check(out.touch_x==(version==2 and input.touch_x or nil) and out.touch_y==(version==2 and input.touch_y or nil),'新录像恢复目标，旧录像和抬手帧清除目标')
    end
    check(not reader:Next(out),'帧数不被扩展输入字节改变');reader:Close()
end
print('新旧二进制录像回归通过：'..total..' 项。')

local previous=records[2];previous.stageName='previous@BossRush'
local current=records[4];current.stageName=checkpoint.stage;current.stageExtendInfo=checkpoint.start.var
plus.ReplayManager.SaveReplayInfo(P.path('saving1.file'),{gameName='Boss Rush HD',gameVersion=1,group_finish=0,userName='test',stages={previous,current}})
stageObject.number=2;replayWriter=nil;replayReader=nil;lstg.var={};stage.current_stage=stage.stages.menu;stage.next_stage=nil
R.pending=checkpoint;R.recovering=true;stage.Set('resume',checkpoint.stage)
check(replayWriter._touch,'冷启动续玩按保存初态创建扩展帧写入器')
R.recovering=false;R.pending=nil
local names=stage.stages[group.title].save_replay
check(#names==2 and names[1]==previous.stageName,'续玩保留此前关卡顺序')
ext.saving.Save({previous.stageName})
local copied=plus.ReplayManager.ReadReplayInfo(P.path('saving1.file')).stages[1]
local reader=plus.ReplayFrameReader(P.path('saving1.file'),copied.frameDataPosition,copied.frameCount,2);local out={}
check(reader:Next(out) and out.touch_x==inputs[1].touch_x and out.touch_y==inputs[1].touch_y,'续玩复制此前关卡时保留拖拽坐标，不按单字节截断')
reader:Close()
print('含跨关卡扩展帧复制的回归通过：'..total..' 项。')
