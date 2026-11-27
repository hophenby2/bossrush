-- 首卡在首次HUD逻辑帧前已进入可绘制状态，必须先补建血条和指示器。
local b={live=true,hp=14500,maxhp=14500,x=10,name='永夜篇Boss',current_card={phase_kind='boss'}}
lstg={world={l=-192,r=192,b=-224},var={rogue_run={encounter={level=37,kind='boss',cardId=39003}}}}
stage={current_stage={stage_name='RogueTwo@RogueTwo'}};boss_group={b};GameContent={ports={}}
IsValid=function(o)return o and o.live end;SetViewMode=function()end
local advances,renders=0,0
boss={pointer=function(ui,system)return {ui=ui,system=system,frame=function()advances=advances+1 end,render=function()renders=renders+1 end}end}
local H=dofile('mod/rogue_boss_hud.lua')
assert(#H.current==0)
H.prepareRender();assert(#H.current==1 and H.current[1].hp==14500 and next(H.pointers),'首卡缺少底部HUD')
assert(advances==0,'补建HUD不能额外推进动画')
H.renderPointers();assert(renders==1,'首卡没有绘制指示器')
H.frame();assert(advances==1,'正常逻辑帧没有推进指示器动画')
H.reset();H.prepareRender();assert(#H.current==1 and next(H.pointers),'重进时首卡未重建')
lstg.var.rogue_run.encounter={level=37,kind='boss',cardId=39005}
b.current_card={phase_kind='boss'};H.prepareRender()
assert(H.entry==lstg.var.rogue_run.encounter,'换卡后仍用上一张的HUD数据')
print('随机模式首卡绘制前血条/指示器补建、动画单次推进与重进/换卡更新通过')
local countdown
GROUP={GHOST=0};object={RawDel=function(o)o.live=false end}
New=function(cls,...)local o={live=true};if cls.init then cls.init(o,...)end;return o end
boss.sc_name={init=function(o,carrier,name)o.name=name end,render=function()end}
boss.timeCounter=function(display)return {frame=function()end,render=function()countdown=display.countdown end}end
local run=lstg.var.rogue_run;run.card_title={names={'阶段卡'}}
local function header()return {right=400,y=600}end
local function renderCountdown()H.updateHeaders(run,true);H.renderHeaders(run,{},false,header)end
b.is_combat=true;b.ui={countdown=53};H.frame();renderCountdown()
assert(countdown==53,'宿主Boss倒计时没有进入竖屏HUD')
lstg.var.rogue_run.encounter={level=39,kind='boss'}
b.is_combat=nil;b._bosssys={GetCurrentCard=function()return {is_combat=true}end}
GameContent.ports[39]={source={boss={GetBossTable=function()return {b}end}}}
b.ui.countdown=26.49;H.prepareRender();renderCountdown()
assert(countdown==26.49,'祈华梦没有使用原卡倒计时')
lstg.var.rogue_run.encounter={level=40,kind='boss'}
GameContent.ports[40]={source={runtime={},BossHud={snapshots=function()return {{boss=b,hp=100,maxHp=200,phaseMode=5,countdown=3180}}end}}}
H.prepareRender();renderCountdown();assert(countdown==53,'Like Dreamer帧数未换算为秒或耐久符无倒计时')
print('宿主、祈华梦和Like Dreamer耐久符倒计时进入原生组件，来源换算通过')
