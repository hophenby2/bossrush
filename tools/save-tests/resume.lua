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
    self.watch=StopWatch()
    worker=coroutine.create(function()
        while true do
            if self.timer%7==0 then objects[#objects+1]={group=2,x=ran:Float(-100,100),y=120,vx=capturedRandom(-2,2),vy=-2,rot=0,timer=0,hp=1} end
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
    GetInput();stage.current_stage.timer=stage.current_stage.timer+1
    hero.vx=(KeyState.right and 2 or 0)-(KeyState.left and 2 or 0);hero.x=hero.x+hero.vx
    if GetKeyState(65) then hero.y=hero.y+1 end
    if GetLastKey()==13 then hero.y=hero.y-1 end
    local ok,err=coroutine.resume(worker);assert(ok,err)
    for _,obj in ipairs(objects) do obj.x=obj.x+(obj.group==2 and obj.vx or 0);obj.y=obj.y+(obj.vy or 0);obj.timer=obj.timer+1 end
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
