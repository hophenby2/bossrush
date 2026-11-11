-- 捕获实际绘制入口，检查红白弧比例、血条边界和横竖屏指示器位置。
local function noop() end
local function class() return {} end
Class=class;plus={Class=class};object={};boss={};ext={};task={}
sin=function(a) return math.sin(math.rad(a)) end
abs,min,max=math.abs,math.min,math.max
Color=function(...) return {...} end
IsValid=function(o) return o and not o.invalid end
SetViewMode,SetFontState,SetRenderRect,RenderText=noop,noop,noop,noop
local quads,rects,sprites,color={},{},{},{}
SetImageState=function(_,_,...) color={...} end
Render4V=function(_,...) quads[#quads+1]={v={...},color=color} end
RenderRect=function(_,...) rects[#rects+1]={...} end
Render=function(name,x,y,rot,scale) sprites[#sprites+1]={name=name,x=x,y=y,scale=scale} end
lstg={world={l=-192,r=192,b=-224,t=224,scrl=0,scrr=540,scrb=285,scrt=915}}
player={x=0};stage={current_stage={}}
ui={RenderText=noop};sp={HSVtoRGB=function() return 255,100,100 end}
dofile('THlib/enemy/boss_ui.lua')
local file=assert(io.open('THlib/ext/ext_boss.lua','rb'));local source=file:read('*a');file:close()
source=source:gsub('\r\n','\n')
assert(loadstring(source:sub(1,assert(source:find('local Smooth = task.Smooth',1,true))-1)))()
local P=dofile('android/lua/portrait.lua');AndroidPortrait=P
setting={androidPortrait=true,resx=1080,resy=2400}
local checks=0
local function check(v,why) assert(v,why);checks=checks+1 end
local function near(a,b) return math.abs(a-b)<1e-6 end
local b={x=17,y=93,hp=100,maxhp=100,is_combat=true,__hpbar_timer=90,
    ui={drawhp=true,infobar={}},name='测试Boss',sc_left=1,dmgt=0,dmgmaxt=1,_sp_point_auto={}}
local u={boss=b,drawhp=true}
setting.androidPortrait=false
for _,hp in ipairs({100,50,37.5,0,-10,120}) do
    b.hp=hp;quads={};boss.ui.renderHPRing(u)
    local arcs={red=0,white=0}
    for _,q in ipairs(quads) do
        local v=q.v
        local ax,ay=v[1]-b.x,v[2]-b.y
        local bx,by=v[10]-b.x,v[11]-b.y
        local delta=math.atan2(ax*by-ay*bx,ax*bx+ay*by)
        check(delta<0,'血条从顶部顺时针连续拼接')
        check(near(ax*ax+ay*ay,36*36) and near((v[4]-b.x)^2+(v[5]-b.y)^2,34*34),
            '血条跟随Boss中心，宽度保持2个世界单位')
        local key=q.color[3]==64 and 'red' or 'white'
        arcs[key]=arcs[key]-delta
    end
    local ratio=min(1,max(0,hp/100))
    check(near(arcs.red,2*math.pi*ratio) and near(arcs.white,2*math.pi*(1-ratio)),
        '红弧表示剩余血量，白弧表示损失血量：'..hp)
    check(#quads<=97,'每个Boss每帧最多97条线段')
end
for _,flag in ipairs({'__is_waiting','no_hp_render','time_sc'}) do
    b[flag]=true;quads={};boss.ui.renderHPRing(u)
    check(#quads==0,'隐藏无血量展示阶段：'..flag);b[flag]=nil
end
b.is_combat=false;quads={};boss.ui.renderHPRing(u)
check(#quads==0,'道中不在隐藏Boss载体周围画血圈');b.is_combat=true
u.drawhp=false;boss.ui.renderHPRing(u);check(#quads==0,'遵从Boss血条显示开关');u.drawhp=true
b.maxhp=0;boss.ui.renderHPRing(u);check(#quads==0,'零血量上限不产生除零');b.maxhp=100;b.hp=37.5
setting.androidPortrait=true
for _,hp in ipairs({100,50,37.5,0,-10,120}) do
    b.hp=hp;quads,sprites={},{};boss.ui.renderHPRing(u)
    check(#quads==math.floor(360*min(1,max(0,hp/100))),'竖屏按参考库的一度白弧绘制当前血量')
    for _,q in ipairs(quads) do
        local v=q.v
        check(near((v[1]-b.x)^2+(v[2]-b.y)^2,60*60)
            and near((v[4]-b.x)^2+(v[5]-b.y)^2,64*64),'参考库60..64半径')
    end
    check(#sprites==2 and sprites[1].name=='portrait_hp_base'
        and sprites[1].scale==.274 and sprites[2].scale==.256,'内外红圈复用参考库纹理与缩放')
end
b.hp=100;b.__hpbar_timer=30;quads={};boss.ui.renderHPRing(u)
check(#quads==180,'参考库的60帧血条填充动画')
b.__hpbar_timer=90;b.sp_point={180};b._sp_point_auto={{dmg=50}};sprites={};boss.ui.renderHPRing(u)
check(#sprites==4 and sprites[3].name=='portrait_hp_node' and near(sprites[3].x,b.x-61),'手动阶段点位于参考半径61')
check(near(sprites[4].y,b.y-61),'自动伤害节点仍使用真实血量比例')
b.sp_point={};b._sp_point_auto={};b.hp=37.5
boss_group={b}
for _,portrait in ipairs({true,false}) do
    setting.androidPortrait=portrait;rects={}
    local bars=ext.boss_ui;bars.alpha=1;bars.curlen=540;bars:render()
    check(#rects==2,'底部血条复用横屏的阴影和本体')
    local bottom=lstg.world.scrb+(portrait and 32 or 0)
    check(near(rects[2][3],bottom-22) and near(rects[2][4],bottom-25),'底部血条只改变布局偏移')
    check(near(rects[2][2],540*.375),'底部血量与圆弧读取同一Boss当前血量')
    if portrait then check(rects[2][4]>lstg.world.scrb,'安卓底部血条位于游戏区域内') end
    local p={ui={pointer_x=190,drawpointer=true},system={boss=b},scale=1,y=-224,EnemyIndicater=0}
    sprites={};boss.pointer.render(p)
    local draw=sprites[1];check(draw and draw.name=='boss_pointer','复用横屏Boss指示器资源')
    if portrait then
        check(draw.x+24<=192 and draw.y-16>-224,'竖屏指示器完整位于游戏区域内')
    else check(draw.x==190 and draw.y==-224,'横屏保留原有指示器位置') end
end
print('横屏红白血圈、竖屏AEX血圈、底部血条与指示器检查通过：'..checks)
