-- 使用真实front/ascii及ANM验证顶部行分组、特殊系统和渲染的只读边界。
local function noop() end
object={};GROUP={GHOST=1};LAYER={TOP=100}
Class=function(_,methods) return methods end
Color=function(...) return {...} end
CheckRes=function() return false end
LoadTexture,LoadImage,SetImageState=noop,noop,noop
local draws={}
Render=function(name,x,y,rot,sx,sy) draws[#draws+1]={name=name,x=x,y=y,sx=sx,sy=sy} end
RenderRect,SetViewMode=noop,noop
RenderTexture=function(_,_,a,b,c,d)
    local ratio=math.abs(math.abs((b[1]-a[1])/(b[4]-a[4]))-math.abs((d[2]-a[2])/(d[5]-a[5])))
    assert(ratio<1e-8,'原作底板裁切必须保持像素比例')
end
local randomCalls=0
ran={Float=function(_,a,b) randomCalls=randomCalls+1;return a end,Int=function(_,a,b) randomCalls=randomCalls+1;return a end}
screen={width=540,height=1200,scale=1,dx=0,dy=0}
setting={androidPortrait=true,resx=720,resy=1600}
lstg={world={l=-192,r=192,b=-224,t=224,scrl=0,scrr=540,scrb=285,scrt=915},
    var={ran_seed=12345,score=123456789,graze=42},tmpvar={hiscore=900000000}}
stage={current_stage={timer=0}}
AndroidPortrait=dofile('android/lua/portrait.lua')
OriginalANM=dofile('THlib/anm/original.lua') or OriginalANM
local s
SequenceResources={state=function() return s end,game=function() return s.game end,
    machine=function() return {id='team0'} end,humanThreshold=function() return -80 end,youkaiThreshold=function() return 80 end}
local H=dofile('THlib/UI/original_hud.lua')
ui={OriginalHUD=H}
local checks=0
local function check(v,why) assert(v,why);checks=checks+1 end
local function signature(t)
    local rows={};for k,v in pairs(t) do rows[#rows+1]=k..'='..tostring(v) end
    table.sort(rows);return table.concat(rows,';')
end
for _,game in ipairs({6,7,8,95,10}) do
    s={game=game,machine='team0',lives=2,bombs=3,power=80,extends=0,points=42,stage_points=17,
        cherry=123450,cherry_max=400000,cherry_plus=49000,border=300,human=60,time=1600,clock=4,faith=50000,faith_timer=65}
    lstg.var.sequence_key=game==8 and 'th08_lunatic_a' or 'th'..game..'_lunatic'
    stage.current_stage={timer=0}
    local before=signature(s);local o={};H.controller.init(o)
    for frame=1,180 do stage.current_stage.timer=frame;H.controller.frame(o) end
    check(randomCalls==0,'竖屏UI动画不得消耗弹幕随机源')
    local rows=H.portraitRows(s)
    check(rows[1][1]=='lives' and #rows[1]==1 and rows[2][1]=='bombs' and #rows[2]==1,'残机与Bomb各占一行')
    for i=3,#rows do
        check(#rows[i]==2 or i==#rows,'其它项两列，单项只在末行')
        for _,key in ipairs(rows[i]) do check(key~='score' and key~='high','原右栏不重复显示分数') end
    end
    draws={};check(H.portraitBanner(),'真实原作底板及字体可绘制')
    for _,d in ipairs(draws) do
        check(d.y>=lstg.world.scrt-1 and d.y<=screen.height+1,'顶部UI位于游戏区域外')
    end
    draws={};check(H.portraitLower(12,351,255),'场内资源与特殊系统可绘制')
    for _,d in ipairs(draws) do check(d.x>=0 and d.x<=220 and d.y>380 and d.y<560,'原作特殊系统及资源集中在按钮上方') end
    check(signature(s)==before,'UI渲染不得改写原作资源账本')
    -- 小尺寸竖屏也为顶部原作面板留出空间，战斗世界比例保持不变。
    screen.height=800;AndroidPortrait.layoutWorld()
    local w=lstg.world
    check(screen.height-w.scrt>=H.portraitHeight()-1e-8,'顶部完整容纳行布局')
    check(math.abs((w.scrt-w.scrb)/(w.scrr-w.scrl)-448/384)<1e-8,'缩放不改变战斗比例')
    screen.height=1200;AndroidPortrait.layoutWorld()
end
print('五作原作竖屏行布局、真实ANM、区域边界、只读状态与独立随机源检查通过：'..checks)
