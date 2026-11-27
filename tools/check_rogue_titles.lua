-- 名称单行自适应、原生组件交接、持续倒计时与共享字号/完整画布。
screen={width=960,height=540};lstg={world={scrl=288,scrr=672,scrb=18,scrt=522},viewmode='world'}
local portrait,scale=false,.48
local glyphs,headers=0,0
SetViewMode=function(mode)lstg.viewmode=mode end
SetRenderRect=function()end
GetImageScale=function()return scale end;SetImageScale=function(value)scale=value end
CalcTextSize=function(font,text)return #text*7 end
Color=function(...)return {...}end
boss={sc_name={renderLabel=function(name,p)assert(scale==1,'标题继承了弹幕绘制倍率');glyphs=glyphs+1 end}}
AndroidPortrait={enabled=function()return portrait end,cardHeader=function(slot)
 local w=lstg.world
 return {right=w.scrr-12,nameRight=w.scrr-96,nameWidth=w.scrr-w.scrl-108,y=w.scrt-68-((slot or 1)-1)*26}
end}
RogueBossHUD={updateHeaders=function()end,renderHeaders=function(run,rows,settled)
 headers=headers+1
 if settled then assert(#rows==#run.card_title.names,'落位名称丢失')end
end}
local T=dofile('mod/rogue_titles.lua')
local function near(a,b)assert(math.abs(a-b)<1e-8)end
for _,p in ipairs({false,true})do
 portrait=p
 screen.width,screen.height=p and 540 or 960,p and 960 or 540
 lstg.world.scrl,lstg.world.scrr=p and 45 or 288,p and 495 or 672
 lstg.world.scrt=p and 820 or 522
 for _,dual in ipairs({false,true})do
  local run={}
  T.announce(run,{title=string.rep('长符卡名',12)},dual and {title='第二张非符'} or nil)
  run.card_title.age=6
  local rows=T.nameLayout(run)
  assert(#rows==(dual and 2 or 1) and not rows[1].text:find('\n'),'名称被换行')
  local width=T.textWidth(rows[1].text,'sc_menu')
  near(rows[1].x-width*rows[1].size/2,screen.width/2)
  assert(width*rows[1].size<=screen.width-48+1e-8,'中央名称超出画布')
  glyphs=0;T.render(run);assert(glyphs==#rows and scale==.48 and lstg.viewmode=='world')
  run.card_title.age=T.NAME_DURATION
  rows=T.nameLayout(run)
  near(rows[1].x,T.headerLayout(1).nameRight);near(rows[1].y,T.headerLayout(1).y)
  glyphs=0;T.render(run);assert(glyphs==0,'落位后仍由覆盖层画卡名')
  run.stage_banner={};local before=headers
  T.render(run);assert(headers==before+1,'中央阶段提示遮住了原生倒计时')
 end
 local p=T.flightLayout('×1.20',6,130,160,1,nil,.85)
 near(p.size,.85);near(p.x-T.textWidth(p.text,'sc_menu')*p.size/2,screen.width/2);near(p.y,screen.height/2)
end
print('PASS：横竖屏/双卡/超长名单行适配、原生卡名交接、阶段提示期间倒计时、倍率同字号居中及画布倍率还原。')
