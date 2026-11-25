-- 独立后端的实际共用血圈绘制：坐标、HP、入场、靠近淡化、切卡、宿主去重。
local noop=function()end
local draws,centers={},{}
IsValid=function(o)return o and not o.invalid end
Color=function(...)return {...}end
local color
SetImageState=function(_,_,c)color=c end
Render4V=function(_,...)draws[#draws+1]={...};draws[#draws].color=color end
Render=function(name,x,y)centers[#centers+1]={name,x,y}end
SetViewMode=function(mode)lstg.viewmode=mode end
local ring=dofile('THlib/enemy/portrait_hp.lua')
boss={ui={renderHPRing=ring.draw},pointer=function()return {ui={},frame=noop,render=noop}end}
lstg={world={l=-192,r=192,b=-224,t=224},viewmode='ui',var={rogue_run={encounter={level=39},finished=false}}}
stage={current_stage={stage_name='RogueTwo@RogueTwo'}}
player={x=0,y=-180}
local sourceCard={is_combat=true}
local sourceBoss={x=40,y=100,hp=50,maxhp=100,timer=120,
    _bosssys={GetCurrentCard=function()return sourceCard end},ui={drawhp=true,class={}}}
local active={sourceBoss}
GameContent={ports={[39]={source={boss={GetBossTable=function()return active end}}}}}
local H=dofile('mod/rogue_boss_hud.lua')
local function draw()
    draws,centers={},{};H.prepareRender();H.renderRings()
    assert(lstg.viewmode=='ui','绘制后没有恢复视口')
end
H.frame();draw()
assert(#draws==180 and #centers==2,'独立后端未补齐半血血圈')
assert(centers[1][2]==40 and centers[1][3]==100,'没有跟随真实Boss坐标')
sourceCard.is_combat=false;H.frame();draw();assert(#draws==0,'祈华梦非战斗卡仍绘制血圈')
sourceCard.is_combat=true
sourceBoss.x,sourceBoss.y,sourceBoss.hp=75,80,25;H.frame();draw()
assert(#draws==90 and centers[1][2]==75 and centers[1][3]==80,'坐标/真实血量未更新')
sourceBoss.timer=30;H.frame();draw();assert(#draws==45,'入场填充动画错误')
sourceBoss.timer=120;player.x,player.y=75,80
for i=1,18 do H.frame()end;draw();assert(draws[1].color[1]==102,'靠近淡化未接入')
sourceBoss.ui.drawhp=false;H.frame();draw();assert(#draws==90,'原作UI关闭后随机模式血圈也被误关')
sourceBoss.ui.drawhp=true
for _,flag in ipairs({'__is_waiting','time_sc'})do
    sourceBoss[flag]=true;H.frame();draw();assert(#draws==0,flag..'仍然画血圈');sourceBoss[flag]=nil
end
sourceBoss.no_hp_render=true;sourceBoss.ui.hide=true;H.frame();draw()
assert(#draws==90,'原作HUD的隐藏标志误伤随机模式血圈')
sourceBoss.ui.class=boss.ui;H.frame();draw()
assert(#draws==90,'宿主UI没有接入同一条血圈绘制路径')
sourceBoss.ui.class={}
sourceBoss.invalid=true;H.frame();draw();assert(next(H.rings)==nil,'旧Boss血圈状态未释放')
sourceBoss.invalid=nil
-- 首次绘制可能发生在HUD逻辑帧前；模式1同样补齐，不推进靠近动画。
stage.current_stage.stage_name='RogueTen@RogueTen';H.reset();draw()
assert(#draws==90 and H.rings[sourceBoss].portrait_hp_fade==nil,'首次渲染补齐失败或推进了动画')
local info={boss=sourceBoss,hp=75,maxHp=100,phaseMode=1,timer=120}
GameContent.ports[40]={source={runtime={},BossHud={snapshot=function()return info end}}}
lstg.var.rogue_run.encounter={level=40};H.frame();draw();assert(#draws==270,'快照后端血量未正确接入')
info.phaseMode=0;H.frame();draw();assert(#draws==0,'快照后端入场仍绘制血圈')
stage.current_stage.stage_name='Spell Practice@Spell Practice';H.frame();draw()
assert(#draws==0 and next(H.rings)==nil,'影响了原作练习UI')
print('PASS 随机模式独立后端血圈、实际坐标/血量、入场/淡化、宿主去重、跨卡回收')
