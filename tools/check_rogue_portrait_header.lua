-- 长卡名仍为单行；右侧保留倒计时，横屏布局不占用该空间。
setting={androidPortrait=true,resx=1080,resy=1920}
screen={width=540,height=960};lstg={world={scrl=0,scrr=540,scrb=165,scrt=795}}
AndroidPlatform=true
local function measure(text)
    local width=0
    for c in text:gmatch('[%z\1-\127\194-\244][\128-\191]*')do width=width+(#c>1 and 32 or 16)end
    return {x=width,y=32}
end
FindResFont=function()return {calcSize=function(_,text)return measure(text)end}end
Color=function(...)return {...}end
local drawn
ui={RenderText=function(_,font,text,x,y,size)drawn={text=text,x=x,y=y,size=size}end}
AndroidPortrait=dofile('android/lua/portrait.lua')
local T=dofile('mod/rogue_titles.lua')
local run={};T.announce(run,{title=string.rep('重弹「狂铳追猎（月面狙击手）」',3)})
run.card_title.age=60
local row=T.nameLayout(run)[1];local header=AndroidPortrait.cardHeader()
AndroidPortrait.cardCountdown(4.99)
assert(row.y==drawn.y and row.x==header.nameRight,'倒计时和卡名未对齐')
assert(row.x-measure(row.text).x*.5*row.size>=12,'长卡名超出左边界')
assert(drawn.x-measure(drawn.text).x*.5*drawn.size>row.x,'倒计时压住卡名')
assert(not row.text:find('\n',1,true),'卡名被换行')
setting.androidPortrait=false
assert(T.nameLayout(run)[1].x==lstg.world.scrr-12,'横屏被竖屏倒计时挤占')
print('PASS 竖屏长卡名单行缩放、右侧倒计时与横屏布局保持')
