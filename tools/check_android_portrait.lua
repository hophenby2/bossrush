-- 使用正式竖屏布局生成触区，验证点击、拖动、模态窗口与切换场景后的失效。
setting={androidPortrait=true,resx=1080,resy=2400}
screen={width=540,height=1200}
stage={current_stage={}}
KEY={['8']=56}
local function noop() end
SetViewMode,SetImageState,RenderRect=noop,noop,noop
Color=function(...) return {...} end
CheckRes=function() return false end
ui={version='test',RenderText=noop}
local pulses={}
AndroidInput={menuMode=function() return true end,pulse=function(key) pulses[#pulses+1]=key end}
local P=dofile('android/lua/portrait.lua')
local menu={alpha=1,text={'第一项','第二项'},nopos={},pos=1,timer=0}
local function render()
    P.beginRender();P.mainMenu(menu)
end
local function tap(x,y)
    P.touch(1,x,y,'began');P.touch(1,x,y,'ended')
end
render();tap(270,556)
assert(menu.pos==1 and #pulses==0,'触摸回调不直接修改菜单状态')
P.dispatch();assert(menu.pos==2 and pulses[1]==13,'点选竖屏第二项对应实际菜单动作')
render();tap(270,1036);P.dispatch()
assert(pulses[2]==56,'竖屏版本号触区可输入调试口令')
render();P.touch(1,270,644,'began');P.touch(1,290,644,'moved');P.touch(1,290,644,'ended');P.dispatch()
assert(menu.pos==2 and #pulses==2,'滑动抬手不误触菜单')
render();tap(270,644);stage.current_stage={};P.dispatch()
assert(menu.pos==2 and #pulses==2,'切换场景后旧触点不能触发新菜单')
render();tap(270,644);P.clearInput();P.dispatch()
assert(menu.pos==2 and #pulses==2,'屏幕重置时清空待处理触点')
render()
local notice={title='提示',texts={'内容'},timer=0,pos=1}
P.notice(notice,true);tap(270,644);P.dispatch()
assert(menu.pos==2 and #pulses==2,'提示框阻止点击穿透到底层菜单')
tap(400,88);P.dispatch()
assert(notice.pos==2 and pulses[3]==13,'提示框取消按钮使用自己的触区')
P.clearInput();setting.androidPortrait=false
assert(not P.enabled() and not P.touch(1,270,644,'began'),'横屏交还原有触控处理')
print('竖屏菜单点选、版本号口令、滑动防误触、场景切换和模态触区检查通过')
