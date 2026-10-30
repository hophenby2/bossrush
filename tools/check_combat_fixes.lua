-- 使用实际子弹与答题模块，验证朝向、换形、冻结、复活上限和输入回放；不读写玩家目录。
arg[1]='combat-fixes'
local file=assert(io.open('tools/check_stage.lua','rb'));local source=file:read('*a');file:close()
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
local total=0
local function check(v,label) assert(v,label);total=total+1 end
local function near(a,b) return math.abs(a-b)<1e-6 end
dofile('THlib/bullet/bullet.lua')
local drawn
local function style()
    return {size=1,init=function(o) o.img='white' end,SetColorFunc=function() end,
        RenderFunc=function(_,_,_,r) drawn=r end}
end
local arrow=style();star_small=style();star_big=style();music=style()
local b={class=bullet,rot=15,vx=0,vy=0,dx=0,dy=3,x=0,y=0,hscale=1,vscale=1,ani=0,omiga=0}
bullet.init(b,arrow,1,false,true)
bullet.render(b);check(near(drawn,90) and b.rot==15,'手算坐标的方向弹跟随实际位移，逻辑角保持不变')
b.dx,b.dy=-2,-2;bullet.render(b);check(near(drawn,-135),'转弯后朝向更新')
bullet.frame(b);b.dx,b.dy=0,0;bullet.render(b);check(near(drawn,-135),'停止时保留最后方向')
bullet.ChangeImage(b,star_small,1);bullet.render(b);check(drawn==15,'换成星弹保留原自转角')
b.dx,b.dy=2,0;bullet.ChangeImage(b,arrow,2);bullet.render(b);check(drawn==0,'星弹中途换成方向弹，重新获得跟随朝向')
bullet.ChangeImage(b,arrow,16,true);bullet.render(b);check(drawn==0,'灰色换色保留方向策略')
b.omiga=3;bullet.render(b);check(drawn==15,'显式角速度不被自动朝向覆盖')
b.auto_rotate=true;bullet.render(b);check(drawn==0,'可显式要求旋转弹继续跟随运动')
b.auto_rotate=false;bullet.render(b);check(drawn==15,'可显式固定绘制朝向')
-- 八道原题的正确答案位置随机打散，所有边界均与原四区判题一致。
local Q=dofile('THlib/ext/ext_quiz.lua')
local function random()
    local g={v=1};function g:Seed(v) self.v=v%2147483646+1 end
    function g:Int(a,z) self.v=self.v*48271%2147483647;return a+math.floor(self.v/2147483647*(z-a+1)) end
    return g
end
Rand=random
check(#Q.questions==8,'保留现有八道题')
for seed=1,100 do
    local g=Rand();g:Seed(seed)
    for i=1,8 do local q=Q.new(i,g);check(#q.choices==4 and q.choices[q.correct]==Q.questions[i][2],'每题四个选项且正确答案随排布更新') end
end
check(Q.answer(-192)==1 and Q.answer(-96)==2 and Q.answer(0)==3 and Q.answer(96)==4 and Q.answer(192)==4,'四区边界判题')
for _,row in ipairs(Q.questions) do check(table.concat(Q.wrap(row[1],24)):gsub('\n','')==row[1]:gsub('\n',''),'换行不截断中文或题意') end
local keys,previous={},{}
KeyIsDown=function(k) return keys[k] end
KeyIsPressed=function(k) return keys[k] and not previous[k] end
IsValid=function(o) return o and o._live end
PlaySound=function() end
lstg={var={},tmpvar={}};stage={current_stage={is_menu=false,revive_miss_limit=9,timer=100}}
local selectionCount=0
Q.selection=function(key,q,text,choices) selectionCount=selectionCount+1;assert(key=='revive' and #choices==4 and text==q.text) end
Q.clearSelection=function() end
local V=dofile('THlib/ext/ext_revive.lua')
local function reset(dead)
    lstg.var={__revive_version=1,ran_seed=12345,dead=dead or 10}
    player={_live=true,x=0,y=-100,death=90,protect=0,lock=false,dialog=false,hide=false,colli=true,time_stop=false,hspeed=4,lspeed=2}
    keys={};previous={};stage.current_stage.revive_miss_limit=9
end
local function step(nextKeys)
    previous=keys;keys=nextKeys or {};return V.frame(stage.current_stage)
end
local function answer(correct)
    local q=lstg.var.revive.quiz
    player.x=((correct and q.correct or q.correct%4+1)-2.5)*96
    for _=1,Q.TIME do if q.result~=nil then break end;step({up=true}) end
    check(q.result==correct and q.age<Q.TIME,'上顶子弹横线提前按所在区判题')
    for _=1,60 do step() end
end
reset();check(V.frame(stage.current_stage) and V.active(),'失败前进入答题')
check(player.death==0 and not player.lock and not player.colli,'答题允许移动且不参与碰撞')
local x,y=player.x,player.y;step({left=true,up=true});check(player.x<x and player.y>y,'方向键允许上下左右移动，向上可提前触发')
local q=lstg.var.revive.quiz;step({shoot=true});check(q.result==nil,'射击不再越过接触逻辑直接确认');check(selectionCount>0,'复活调用与原符卡相同的子弹 / 文字实体工厂')
answer(true)
check(lstg.var.dead==10 and V.misses()==9 and lstg.var.revive.used==1,'成功后保留累计死亡，只补一个失败余量')
check(player.death==0 and player.protect==180 and player.colli and not player.lock,'复活有三秒无敌并恢复操作')
for i=2,3 do lstg.var.dead=lstg.var.dead+1;check(step() and V.active(),'下次失败仍可答题');answer(true);check(lstg.var.revive.used==i,'累计复活次数') end
check(#lstg.var.revive.asked==3 and lstg.var.revive.asked[1]~=lstg.var.revive.asked[2] and lstg.var.revive.asked[2]~=lstg.var.revive.asked[3],'三次题目不重复')
lstg.var.dead=lstg.var.dead+1;check(not step() and not V.active(),'第四次失败不再复活')
reset();step();answer(false);check(not step() and not V.active() and lstg.var.revive.used==0,'答错后恢复原失败流程且不重新弹题')
reset();step();for _=1,30 do step() end;step({spell=true});for _=1,60 do step() end
check(not step() and not V.active(),'符卡键放弃进入失败')
reset();step();local q=lstg.var.revive.quiz;player.x=(q.correct-2.5)*96
for _=1,Q.TIME do step() end
check(q.result==true,'倒计时结束也按所在答案区判定')
reset(80);stage.current_stage.revive_miss_limit=10;step();answer(true)
check(V.misses()==10 and lstg.var.dead==80,'主线关卡超额失误也能复活通过门槛，真实统计不回退')
reset();lstg.var.__revive_version=nil;check(not step(),'旧录像没有新版本标记时不插入答题')
-- 新规则每次答对后有完整五次失误余量，前三次作答机会仍保持原上限。
reset();lstg.var.__revive_version=2;step();answer(true)
check(lstg.var.dead==10 and V.misses()==5 and lstg.var.revive.credits==5,'新版复活补五条命，真实死亡数不回退')
for revive=2,3 do
    for _=1,4 do lstg.var.dead=lstg.var.dead+1;check(not step() and not V.active(),'复活后的前四次失误不再答题') end
    lstg.var.dead=lstg.var.dead+1;check(step() and V.active(),'第五次失误触发下一次答题')
    answer(true);check(lstg.var.revive.used==revive and V.misses()==5,'每次复活均恢复五条命')
end
lstg.var.dead=lstg.var.dead+5;check(not step() and not V.active(),'三次复活后耗尽五条命仍结束')
reset(80);lstg.var.__revive_version=2;stage.current_stage.revive_miss_limit=0;step();answer(true)
check(V.misses()==-4 and lstg.var.dead==80,'低容错关卡与超额累计失误同样恢复五条命')
-- 执行实际 DoFrame 入口，确保冻结不消耗 Boss/弹幕协程或物理帧，而输入与续玩仍记录。
reset();local calls={input=0,world=0,save=0,task=0}
SaveResume={beforeLogic=function() return true end,afterLogic=function() calls.save=calls.save+1 end}
GetInput=function() calls.input=calls.input+1 end
GetCurrentSuperPause=function() return 0 end
task.Do=function() calls.task=calls.task+1 end
ObjFrame=function() calls.world=calls.world+1 end
BoundCheck=function() end;CollisionCheck=function() end;UpdateXY=function() end;AfterFrame=function() end
ext={notUIdraw=false,GetPauseMenuOrder=function() end,boss_ui={frame=function() end}}
local f=assert(io.open('THlib/ext/ext.lua','rb'));local code=f:read('*a');f:close()
local first=assert(code:find('local function DoFrame()',1,true));local last=assert(code:find('_G.DoFrame = DoFrame',first,true))
assert(loadstring(code:sub(first,last-1)..'\n_G.DoFrame=DoFrame'))()
DoFrame();DoFrame();check(calls.input==2 and calls.save==2 and calls.world==0 and calls.task==0 and stage.current_stage.timer==100,'答题冻结整个战斗但连续记录输入和存档帧')
stage.current_stage.is_menu=true;stage.current_stage.frame=function() end
DoFrame();ui=nil;V.render()
check(not V.active() and calls.world==1 and calls.task==1 and stage.current_stage.timer==101,'答题中返回标题后菜单可用，不被旧答题状态覆盖或冻结')
stage.current_stage.is_menu=false
local commands=0
stage.group={frame_pause=function(scene) commands=commands+1;stage.next_stage={is_menu=true} end}
ext.GetPauseMenuOrder=function() return '返回标题菜单' end
DoFrame()
check(commands==1 and stage.next_stage and calls.world==1 and calls.task==1,'答题期间暂停菜单的退出指令仍执行，并立即停止旧场景物理更新')

print('战斗修复回归通过：'..total..' 项（朝向/换形、八题共用、三次复活、失败/放弃/超时、实际循环冻结）。')
