-- 调用正式横屏绘制函数，验证竖屏复用、触区变换及场内 HUD。
setting={androidPortrait=true,resx=1080,resy=2400}
cur_setting={easyrender=true}
screen={width=540,height=1200,scale=2,dx=0,dy=0}
stage={current_stage={timer=120,AllowMissCount=10}}
lstg={world={scrl=0,scrr=540,scrb=285,scrt=915},var={}}
KEY={['8']=56,DOWN=40,COMMA=188,PERIOD=190}
local function noop() end
local inMenu=true
ext={StageIsMenu=function() return inMenu end}
local texts,stars,pulses={},{},{}
local viewport,ortho
SetViewport=function(...) viewport={...} end
SetOrtho=function(...) ortho={...} end
SetImageState,OriginalSetImageState,RenderRect,Render,Render4V,SetImageScale,PlaySound=noop,noop,noop,noop,noop,noop,noop
SetViewMode=function() if AndroidPortrait then AndroidPortrait.applyMenuView() end end
Color=function(...) return {...} end
CheckRes=function() return false end
sin=function(v) return math.sin(math.rad(v)) end
cos=function(v) return math.cos(math.rad(v)) end
min,max,abs,sign=math.min,math.max,math.abs,function(v) return v<0 and -1 or v>0 and 1 or 0 end
sp={HSVtoRGB=function() return 240,230,220 end}
task={SetMode={[5]=function(v) return v end}}
ui={version='test',menu={line_height=24,shake_range=3,shake_speed=40},RenderText=function(_,font,value,x,y,scale,color,align)
    texts[#texts+1]={font=font,value=tostring(value),x=x,y=y,scale=scale,color=color,align=align}
end}
AndroidInput={menuMode=function() return inMenu end,pulse=function(key) pulses[#pulses+1]=key end}
local P=dofile('android/lua/portrait.lua');AndroidPortrait=P
local function renderMethod(path,name)
    local f=assert(io.open(path,'rb'));local source=f:read('*a'):gsub('\r\n','\n');f:close()
    assert(loadstring(assert(source:match('(function '..name..'%b()%s*\n.-\nend)')),'@'..path))()
end
menu={};main_menu={}
renderMethod('THlib/UI/menu.lua','menu:RenderExit')
renderMethod('THlib/UI/menu.lua','main_menu:render')
local main={alpha=1,text={'随机模式','其他设置'},sub_title={'Roguelike','Options'},nopos={},pos=1,timer=0,_pos=1,tri_alpha=1,pos_changed=0}
local function render()
    P.beginRender();main_menu.render(main)
end
local function tap(x,y)
    P.touch(1,x,y,'began');P.touch(1,x,y,'ended')
end
local function tapControl(c) tap((c.x1+c.x2)/2,(c.y1+c.y2)/2) end
render()
local notes=0;local subtitle=false
for _,t in ipairs(texts) do
    if t.value:find('♪',1,true) then notes=notes+1 end
    if t.value=='Options' and t.font=='pretty' then subtitle=true end
end
assert(notes==1 and subtitle,'主菜单使用横屏字体、副标题，只保留横屏当前项的标记')
local second=P.controls[3] -- 关闭、第一项、第二项
local sx,sy=(second.x1+second.x2)/2,(second.y1+second.y2)/2
tap(sx,sy);assert(main.pos==1 and #pulses==0,'触摸回调不直接修改菜单状态')
P.dispatch();assert(main.pos==2 and pulses[1]==13,'共享菜单第二项触区对应实际动作')
render();tapControl(P.controls[#P.controls]);P.dispatch();assert(pulses[2]==56,'版本号仍可输入调试口令')
render();P.touch(1,sx,sy,'began');P.touch(1,sx+20,sy,'moved');P.touch(1,sx+20,sy,'ended');P.dispatch()
assert(#pulses==2,'滑动抬手不误触菜单')
render();tap(sx,sy);stage.current_stage={timer=120,AllowMissCount=10};P.dispatch();assert(#pulses==2,'切换场景后旧触点失效')
render();tap(sx,sy);P.clearInput();P.dispatch();assert(#pulses==2,'重置清空待处理触点')
render()
local notice={x=270,y=270,width=350,height=160,pheight=50,timer=0,pos=1}
P.notice(notice,true,noop);tap(sx,sy);P.dispatch();assert(#pulses==2,'提示框阻止点击穿透')
local cancel=P.controls[#P.controls-1];tapControl(cancel);P.dispatch();assert(notice.pos==2 and pulses[3]==13,'原提示框取消触区随绘制一起变换')
-- 拖动滑块的坐标也必须逆变换，不能只移动可见文字。
P.beginRender();local owner={timer=0};P.rendering=true;P.place(100,200,270,600,.7)
local tx,ty;P.bind(owner,80,120,180,220,noop,function(x,y) tx,ty=x,y end)
local c=P.controls[1];P.touch(1,(c.x1+c.x2)/2,(c.y1+c.y2)/2,'began');P.dispatch()
assert(math.abs(tx-100)<1e-10 and math.abs(ty-200)<1e-10,'组件拖动使用逆变换坐标')
P.clearInput()
-- 练习卡片复用轮播绘制，只临时改变位置与卡片间距。
local practice={alpha=1,x=480,y=270,moveUnit=420,pulseUnit=30,ox=0,pos=1,stage_count=2,stage_selects={{},{}}}
P.stagePractice(practice,function(o) assert(o.x==270 and o.y==600 and o.moveUnit==300) end)
assert(practice.x==480 and practice.y==270 and practice.moveUnit==420,'竖屏排版不改变菜单状态')
P.beginRender()
local exited=false
local keys={alpha=1,x=480,y=270,count=1,edit=true,exit_func=function() exited=true end}
P.keys(keys,{},function(o) P.exit(o,1) end)
tapControl(P.controls[1]);P.dispatch()
assert(exited and not keys.edit and #pulses==3,'关闭按键面板取消编辑，不把ESC重新绑定到按键')
GameRevive={misses=function() return 7 end}
RogueTen={MISS_LIMIT=10}
GameDrops={bombsEnabled=function() return true end,bombState=function() return 2 end,renderStar=function(image,x,y,size)
    stars[#stars+1]={image=image,x=x,y=y,size=size}
end}
ui.RunHUD=dofile('THlib/UI/run_hud.lua')
New=noop
GameHPScale=dofile('THlib/rogue_hp.lua')
for _,height in ipairs({960,1200}) do
    screen.height=height
    local w=lstg.world;w.scrb,w.scrt=(height-630)/2,(height+630)/2
    inMenu=false;texts,stars={},{}
    local run={current=12,hp_growth={shown=123.456,shown_stage=12}}
    lstg.var.rogue_run,lstg.var.__hp_scale_version=run,1
    lstg.var.score=12345
    P.hud(255);P.roguePanel(run)
    assert(stars[1].image=='star_big2' and stars[2].image=='star_big10' and #stars==2,'命和雷各画一颗星')
    assert(stars[1].x==stars[2].x and stars[1].y-stars[2].y==30,'命在上、雷在下，左侧对齐竖排')
    assert(stars[2].y-10>=w.scrb+P.BOSS_BOTTOM_INSET,'命雷计数避开新增的底部血条与Boss指示器')
    local found={}
    for _,t in ipairs(texts) do
        assert(t.x>=w.scrl and t.x<=w.scrr and t.y>=w.scrb and t.y<=w.scrt,'战斗HUD全在场地内')
        found[t.value]=t
    end
    assert(found.x3 and found.x2,'命和雷使用阿拉伯数字')
    assert(found['12345'].x==270 and found['12345'].y==w.scrt-28,'分数顶部居中，不再绘制阶段号')
    assert(found['12345'].scale==2.5,'大分数避让右上倍率')
    assert(found['×123.456'].align=='right' and found['×123.456'].x==w.scrr-14,'倍率右上对齐')
    local px,py=P.pauseButton();assert(px==w.scrl+32 and py==w.scrt-28,'暂停入口使用场内左上角')
    P.applyMenuView()
    assert(viewport[3]==w.scrb*2 and viewport[4]==w.scrt*2 and ortho[3]==w.scrb,'战斗UI视口裁切到实际游戏区域')
    GameHPScale.init(run);GameHPScale.enter(1)
    local function flying()
        texts={};P.roguePanel(run)
        for _,t in ipairs(texts) do if t.value=='×1.01' then return t end end
        error('缺少倍率飞入文字')
    end
    local first=flying()
    assert(first.x==270 and first.y==height/2,'倍率飞入从画面中央出发')
    for _=1,30 do GameHPScale.frame() end
    local middle=flying()
    assert(middle.x>270 and middle.x<w.scrr-14 and middle.y>height/2 and middle.y<w.scrt-28,'倍率向右上角飞行')
    for _=31,54 do GameHPScale.frame() end
    local last=flying()
    assert(last.x==w.scrr-14 and last.y==w.scrt-28,'倍率飞行落点与右上角显示一致')
    for _=55,GameHPScale.DURATION do GameHPScale.frame() end
    assert(not run.hp_growth.animation and run.hp_growth.shown==1.01,'飞行结束后更新累计倍率')
end
lstg.var.rogue_run=nil;lstg.var.__sequence_version=1;lstg.var.sequence_run={chapter=1,chapter_name='PH'}
texts,stars={},{};P.hud(255)
local scoreFound=false
for _,t in ipairs(texts) do
    assert(not t.value:find('×',1,true),'顺序模式不显示血量倍率')
    assert(t.value~='PH','面数不再作为大数字')
    if t.value=='12345' then scoreFound=t.x==270 and t.scale==3 end
end
assert(scoreFound,'顺序模式顶部居中显示分数')
lstg.var.__sequence_version,lstg.var.sequence_run=nil,nil
P.clearInput();setting.androidPortrait=false
assert(not P.enabled() and not P.touch(1,270,644,'began'),'横屏交还原有触控处理')
print('共享菜单绘制、触区/拖动变换、模态阻挡、状态还原及16:9/20:9场内HUD检查通过')
