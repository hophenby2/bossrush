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
