-- 实际血圈绘制，覆盖共享身体、独立血槽、隐藏/删除、靠近淡化及宿主UI。
dofile('tools/check_rogue_hp_ring.lua')
local fills,centers={},{}
local color
SetImageState=function(_,_,c)color=c end
Render4V=function(_,...)fills[#fills+1]={color=color,v={...}}end
Render=function(name,x,y)if name=='portrait_hp_base' then centers[#centers+1]={x,y}end end
player={x=-90,y=80}
local b={x=0,y=100,hp=50,maxhp=100,is_combat=true,timer=120,__hpbar_timer=90,ui={}}
local left={x=-90,y=80,hp=999999,maxhp=999999}
local right={x=90,y=80,hp=100000,maxhp=100000}
local ring=dofile('THlib/enemy/portrait_hp.lua')
local u={boss=b,drawhp=true}
local function draw()fills,centers={},{};ring.drawActors(u)end
for _,kind in ipairs({'th07','th38','th39'})do
    b.th07_instruments,b.asl_controller,b.mhj3_card=nil,nil,nil
    if kind=='th07' then b.th07_instruments={roles={b,left,right}}
    elseif kind=='th38' then b.asl_controller={entities={{kind='boss',main=true},{kind='boss',native=left,alive=true},{kind='boss',native=right,alive=true}}}
    else b.mhj3_card={actors={{object=b},{object=left},{object=right},{object=left}}}end
    u.sharedHPRings=nil
    for _=1,18 do ring.frameActors(u)end
    draw();assert(#fills==540 and #centers==6,kind..'没有为三个身体分别画半血圈，或发生重复')
    assert(u.sharedHPRings[left].portrait_hp_fade==18 and u.sharedHPRings[right].portrait_hp_fade==0,'靠近淡化未按各身体单独计算')
    right.hide=true;draw();assert(#fills==360,'隐藏身体仍有血圈');right.hide=nil
    right.invalid=true;draw();assert(#fills==360 and not u.sharedHPRings[right],'删除身体血圈未回收');right.invalid=nil
    b.hp=25;draw();assert(#fills==270,'共享血槽没有同步到全部身体');b.hp=50
end
b.mhj3_card,b.th07_instruments,b.asl_controller=nil,nil,nil
b.th06={actors={{object=b,main=true},{object=right,clone=true},{object=left}}}
right.hp,right.maxhp=50,200
draw();assert(#fills==270,'红魔乡分身未读取各自HP，或把普通敌机画成Boss')
b.hp=100;draw();assert(#fills==450,'独立分身血槽随本体错误变化')
b.th06={};draw();assert(#fills==360,'红魔乡入场控制器尚未建立actors时血圈报错')
b.th06={actors={{object=b,main=true},{object=right,clone=true},{object=left}}}
local f=assert(io.open('THlib/enemy/boss_ui.lua','rb'));local source=f:read('*a');f:close()
local first=assert(source:find('function boss.ui.renderHPRing',1,true))
local last=assert(source:find('function boss.ui:init',first,true))
assert(loadstring('local hpRing=...\n'..source:sub(first,last-1)))(ring)
fills={};boss.ui.renderHPRing(u);assert(#fills==450,'宿主练习UI未绘制分身血圈')
RogueBossHUD={enabled=function()return true end}
fills={};boss.ui.renderHPRing(u);assert(#fills==0,'随机模式叠加了宿主重复血圈')
RogueBossHUD=nil
LikeDreamer={};lstg.IsValid=IsValid
Class=function(_,definition)return definition or {} end;object={}
local hud=dofile('mod/GAME/ports/dreamer/LikeDreamer/boss_hud.lua')
local a={spawnType=0x138,entityId=1,active=true,hp=50,maxhp=100,countdown=600,_bePhaseMode=1}
local c={spawnType=0x139,entityId=2,active=true,hp=25,maxhp=200,countdown=1200,_bePhaseMode=1}
local rt={boss=a,enemiesById={[1]=a,[2]=c,[3]={spawnType=0x30,entityId=3,active=true}}}
local rows=hud.snapshots(rt)
assert(#rows==2 and rows[1].boss==a and rows[2].boss==c,'独立Boss快照遗漏或误收普通敌机')
assert(rows[1].hp==50 and rows[1].maxHp==100 and rows[2].hp==25 and rows[2].maxHp==200,'独立Boss血槽被错误共享')
c.active=false;assert(#hud.snapshots(rt)==1,'已退场的独立Boss仍被收集')
print('PASS 妖妖梦/雪莲华/永夜共享身体逐一血圈、独立Boss快照与实际绘制')
