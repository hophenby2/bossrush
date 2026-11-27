-- 正式奖励、恢复、伤害/绘制、库存布局与圆槽入口；不访问玩家数据。
local function noop()end
local function near(a,b)assert(math.abs(a-b)<1e-8,tostring(a)..' / '..tostring(b))end
lstg={var={__drops_version=9},world={scrl=60,scrr=480,scrb=150,scrt=810}}
stage={current_stage={is_menu=false,AllowMissCount=9}}
Color=function(a,r,g,b)return {a=a,r=r,g=g,b=b}end
IsValid=function(o)return o~=nil end
local texts,stars,quads,wedges={},{},0,0
ui={RenderText=function(_,font,text,x,y,size,c,align)texts[#texts+1]={text=text,x=x,y=y,size=size,color=c,align=align}end}
SetImageState=noop
Render4V=function()quads=quads+1 end
RenderTexture=function()wedges=wedges+1 end
GetImageTextureRegion=function()return 'white',0,0,8,8 end
local D=dofile('THlib/drops.lua');GameDrops=D;D.reset()
local data=lstg.var.upgrades.players[1]
D.apply(1,2);assert(data.red==12000,'火力不是×1.2')
D.apply(1,1);assert(data.blue==11000,'恢复速率不是+0.1')
data.bombs=9;data.bomb_fraction=12345
D.apply(1,3);assert(data.bombs==10 and data.bomb_fraction==12345 and data.green==10000,'立即一雷改变进度或判定')
assert(D.optionLines(3)[1].text=='立即获得Bomb' and D.optionLines(3)[2].text=='+1','奖励文案不符')
local unit=D.BOMB_FRAMES*10000
data.bombs=99;data.bomb_fraction=unit-11000;D.playerStep({})
assert(data.bombs==100 and data.bomb_fraction==0,'超过9雷后没有继续恢复')
data.bomb_fraction=unit*3+7;D.playerStep({})
assert(data.bombs==103 and data.bomb_fraction==11007,'连续恢复丢失雷或进度')
local casts=0;lstg.system={castCharge4=function()casts=casts+1 end}
assert(D.bombInput({death=0},{spell=true},{spell=false}) and casts==1 and data.bombs==102,'高库存不能正常放雷')
data.red=1000000
local hpFactor=3;GameHPScale={factor=function()return hpFactor end}
local normal={hscale=.4,vscale=.6,a=3,b=4,_drop_owner=1}
local bomb=D.markBomb({hscale=.4,vscale=.6,a=3,b=4},1)
assert(D.damage(2,normal)==200 and D.bulletScale(normal)==5,'普通弹伤害或5倍封顶错误')
assert(D.damage(2,bomb)==6 and D.bulletScale(bomb)==3,'雷仍吃火力强化')
local child=D.inheritShot({},bomb)
hpFactor=12;assert(D.damage(2,child)==24 and D.bulletScale(child)==5 and child._drop_owner==1,'雷子对象丢失来源或5倍封顶')
local rendered
DefaultRenderFunc=function(o)rendered={o.hscale,o.vscale,o.a,o.b}end
D.renderBullet(bomb);near(rendered[1],2);near(rendered[2],3)
assert(rendered[3]==3 and rendered[4]==4 and bomb.hscale==.4 and bomb.vscale==.6,'放大改变判定或泄漏缩放')
D.renderStar=function(image,x,y,size,fill,alpha)stars[#stars+1]={x=x,y=y,fill=fill,image=image}end
local positions
for _,stock in ipairs({3,9,12,103})do
    texts,stars={},{}
    D.renderInventory('star_big10',stock,690,942,450,26,255,{110,235,145})
    assert(#stars==9,'库存图标不是固定9个')
    positions=positions or stars
    for i=1,9 do near(stars[i].x,positions[i].x)end
    if stock>9 then
        assert(texts[1].text=='+'..stock-9 and texts[1].x>stars[9].x,'溢出数量没有位于第九颗星右侧')
        assert(texts[1].color.g==235,'Bomb溢出数字颜色错误')
    else assert(#texts==0)end
end
local P=dofile('android/lua/portrait.lua');setting={}
local sx,sy=P.slowButton();local bx,by=P.bombButton()
near(bx-sx,68);near(by,sy)
local _,lifeY=P.elementPosition('life');local _,bombY=P.elementPosition('bombs')
near(lifeY-lstg.world.scrb,P.BOSS_BOTTOM_INSET+116);near(lifeY-bombY,30)
local saved={bomb={x=.7,y=.6}}
local x,y=P.elementPosition('bomb',saved)
near(x,60+420*.7);near(y,150+660*.6)
local G=dofile('THlib/player/bomb_gauge.lua')
local p={x=0,y=-100,timer=0,death=0}
quads,wedges=0,0;G.render(p,12,.5)
assert(quads==12 and wedges==5,'12库存点或半圈填充没有完整绘制')
for _,point in ipairs(p._bombGaugeDots.points)do near(point[1]^2+point[2]^2,G.DOT_RADIUS^2)end
quads=0;G.render(p,23,.25);assert(quads==23,'超过9个的绿点被截断')
local uploads,draws=0,0
lstg.AndroidUpdateQuadBatch=function(old,packets)uploads=uploads+1;assert(#packets==23 or #packets==24);return packets end
lstg.AndroidRenderQuadBatch=function(handle,x,y,z,ox,oy,oz,flip,n,c)draws=draws+1;assert(n==#handle and c.g==255)end
FindResSprite=function()return {}end
p._bombGaugeDots=nil;G.render(p,23,.5);G.render(p,23,.6)
assert(uploads==1 and draws==2,'库存未变时重复构造绿点批次')
G.render(p,24,.7);assert(uploads==2 and draws==3,'增雷后没有更新全部绿点')
print('PASS：三类奖励、无限库存/持续恢复、独立雷伤/子对象来源、5倍绘制且判定不变、固定9格/+x、竖屏默认位置、圆槽与23/24点批次复用。')
