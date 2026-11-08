-- 真实HP入口、原作life换算、阶段累乘和动画时序；不读写玩家存档。
local count=0
local function check(v,label) assert(v,label);count=count+1 end
local function near(a,b) return math.abs(a-b)<1e-8*math.max(1,math.abs(b)) end
lstg={var={__hp_scale_version=1,rogue_run={}},tmpvar={}}
GROUP={ENEMY=2,NONTJT=6,GHOST=0};IsValid=function(o) return o and o._live~=false end
New=function(c,...) local o={_live=true,group=2};if c.init then c.init(o,...) end;return o end
local H=dofile('THlib/rogue_hp.lua');H.init(lstg.var.rogue_run)
local state=lstg.var.rogue_run.hp_growth
check(H.enabled() and H.factor()==1 and state.shown==1,'初始累计倍率1，未进入阶段不增加HP')
H.enter(1)
check(near(H.factor(),1.01) and state.shown==1 and state.animation.factor==1.01,'第一阶段实际HP先乘1.01，显示等待动画')
local drawn={};Color=function(a,r,g,b) return {a=a,r=r,g=g,b=b} end
ui={RenderText=function(_,_,text,x,y,scale,color) drawn[#drawn+1]={text=text,x=x,y=y,scale=scale,color=color} end}
local age,total=state.animation.age,state.total;H.render(144,165)
check(#drawn==2 and drawn[1].text=='×1' and drawn[2].text=='×1.01' and drawn[2].x==480 and drawn[2].y==270,'第一阶段从屏幕中央显示×1.01')
check(state.animation.age==age and state.total==total,'渲染保持只读，逻辑帧决定动画')
for _=1,18 do H.frame() end
drawn={};H.render(144,165)
check(drawn[2].x<480 and drawn[2].x>144 and drawn[2].y<270 and drawn[2].y>165,'倍率文字快速向左下移动')
for _=19,30 do H.frame() end
drawn={};H.render(144,165)
check(drawn[1].color.a==0 and state.shown==1,'落定前淡出旧数值，避免两串倍率重叠，尚不更新累计值')
for _=31,35 do H.frame() end
check(state.shown==1,'消失前不提前更新左下累计倍率')
H.frame();check(near(state.shown,1.01) and not state.animation and state.shown_stage==1,'第36帧消失时更新显示及颜色')
H.enter(1);check(near(H.factor(),1.01),'重复进入同一阶段不重复乘血')
local c={is_combat=true,t1=60,t3=3600,hp=1000}
local boss={current_card=c,_bosssys={},_live=true};H.beginCard(boss)
local f=assert(io.open('THlib/enemy/boss_system.lua','rb'));local source=f:read('*a');f:close()
local start=assert(source:find('function system:setHP(maxhp, hp)',1,true))
local ending=assert(source:find('---设置掉落物',start,true));local system={boss=boss}
assert(loadstring('local system=...\n'..source:sub(start,ending-1)))(system)
system:setHP(1000,400)
check(near(boss.maxhp,1010) and near(boss.hp,404) and c.hp==1000,'正式Boss.setHP按倍率放大实际血量，原卡不变')
boss.hp=300;H.verify(boss);check(boss.hp==300 and near(boss.maxhp,1010),'每帧验证不会再次乘血或回血')
boss.maxhp,boss.hp=2000,500;H.verify(boss)
check(near(boss.maxhp,2020) and near(boss.hp,505),'脚本重新设置HP仍采用本阶段快照')
local actor={init=function(o,hp) o.hp,o.maxhp=hp,hp end}
local first=New(actor,100);check(near(first.hp,101),'普通敌机同样使用阶段HP倍率')
H.enter(2);check(near(H.factor(),1.0302) and near(H.factor(first),1.01),'跨阶段累计，已出生单位保留自身倍率')
local second=New(actor,100);check(near(second.hp,103.02),'新敌机使用新的累计倍率')
H.enter(3);check(near(H.factor(),1.061106) and #state.queue==1,'快速连续推进不漏动画，第三阶段累计正确')
for _=1,36 do H.frame() end
check(near(state.shown,1.0302) and state.animation.stage==3,'第二次动画落定后才切入第三次')
for _=1,36 do H.frame() end
check(near(state.shown,1.061106) and state.shown_stage==3,'左侧显示真实累计值')
local M=dofile('mod/GAME/th32_hp.lua')
local red={_live=true};M.main(red,{hp=1000,spell=true},4000)
check(near(red.hp,1061.106) and near(M.raw(red),4000),'红魔乡主机HP放大，ECL仍读取原始life')
red.hp=2000*red._th06_hp_scale
check(near(M.raw(red),2000),'原始life阈值不随额外HP漂移')
local before=red.hp;H.verify(red);check(red.hp==before,'代理血槽不重复放大')
local minion={_live=true,group=2};M.unit(minion,200,true)
local rawMax=M.raw(minion);minion.hp=minion.hp/2
M.spell({spell=true,actors={{object=minion,main=false}}},false)
check(near(M.raw(minion),rawMax/2),'切换符卡状态保留残血比例，不因阶段倍率回血')
local baseline=dofile('mod/GAME/original/low_speed_hp.lua');OriginalBalance=baseline
local calibrated=New({init=function(o) o.hp,o.maxhp=100,100;baseline.unit(o,8,false) end})
check(near(calibrated.hp,100*baseline.scale[8].normal*H.factor()),'原作自机TTK校准和阶段倍率各作用一次')
local survival={current_card={t1=100,t3=100},hp=1000};H.beginCard(survival)
local maxhp,hp=H.health(survival,1000);check(hp==1000 and maxhp==1000,'耐久阶段不改时限或占位HP')
check(New(actor,999999).hp==999999,'不可击破结构不作为真实血槽缩放')
local boundaries={{1,255,255,255},{9,255,255,255},{10,110,235,145},{19,110,235,145},
    {20,110,190,255},{29,110,190,255},{30,255,235,100},{39,255,235,100},
    {40,255,165,75},{49,255,165,75},{50,255,90,100},{90,255,90,100}}
for _,row in ipairs(boundaries) do
    local r,g,b=H.rgb(row[1]);check(r==row[2] and g==row[3] and b==row[4],'倍率配色边界：'..row[1])
end
local product=H.factor()
for index=4,100 do H.enter(index);product=product*(1+index/100);check(near(H.factor(),product),'逐阶段累乘：'..index) end
-- 已累计到很大数值时，左下颜色仍取最新乘入的倍率，而不是累计值。
state.shown=1000;state.shown_stage=9;state.animation=nil;drawn={};H.render(144,165)
check(drawn[1].color.r==255 and drawn[1].color.g==255 and drawn[1].color.b==255,'累计值1000、本次1.09时仍显示白色')
for _,value in ipairs({1.01,10000,123456789012345,1e30,1e100,1e300}) do
    local label=H.format(value)
    check(not label:find('[eE]') and label:sub(1,#'×')=='×','倍率始终使用普通十进制：'..value)
    local lines,scale,gap=H.layout(value,288,157)
    check(table.concat(lines)==label,'换行不丢失、重复或省略数字：'..value)
    check(#lines*22*scale<=157 and (#lines<=1 or gap>0),'超长倍率全部留在左侧高度内：'..value)
    if value>=1e30 then check(#lines>1,'一行放不下时增加行数：'..value) end
    state.shown=value;state.animation=nil;drawn={};H.render(144,165,288)
    check(#drawn==#lines,'所有数字行实际进入绘制：'..value)
    for i,row in ipairs(drawn) do
        check(row.text==lines[i] and row.y>=8 and row.y<=165,'各行从倍率位置向下排列：'..value)
        check(row.scale==scale and row.color.r==255 and row.color.b==255,'换行保留最新倍率颜色：'..value)
    end
end
lstg.var.__hp_scale_version=nil
check(not H.enabled() and H.factor()==1 and New(actor,100).hp==100,'旧录像不启用阶段HP倍率')
drawn={};H.render(144,165);check(#drawn==0,'旧录像不凭空插入倍率动画')
print(('阶段血量倍率回归通过：%d 项。'):format(count))
