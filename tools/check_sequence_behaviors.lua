-- 针对报告过的差异检查轨迹和几何，不能用“没有报错”代替行为对表。
dofile('tools/check_sequence_player.lua')
local P,A=SequenceResources,OriginalANM
local count=0
local function check(ok,message) assert(ok,message);count=count+1 end
local function near(a,b) return math.abs(a-b)<.0001 end
local function start(game,machine,key)
    lstg.var={__sequence_version=1,__sequence_system_version=1,sequence_key=key or ('th%02d_lunatic'):format(game),sequence_player=machine,player_name='reimu_player'}
    item.PlayerInit();local p=P.spawnPlayer();player=p;p.__shoot_flag=true;p.__slow_flag=false
    return p,P.state()
end
local p,s=start(7,'reimua')
check(s.cherry_max==300000 and s.cherry_plus==0,'Lunatic初始CherryMax为300000')
s.cherry=240000;s.cherry_plus=49000;P.miss(p)
check(s.cherry==140000 and s.cherry_plus==49000,'死亡扣Cherry封顶100000，保留Cherry+')
p.death=0;p.protect=0;s.cherry_plus=50000;P.stepCherry(p)
check(s.border==540,'Cherry+满50000开启540帧森罗结界')
local bombs=s.bombs
P.bombInput(p,{spell=true},{spell=false},false)
check(s.border==0 and s.cherry_plus==0 and s.bombs==bombs and s.border_cancel.age==0,'主动破界保留Bomb库存，建立50帧扩圈消弹')
s.border=1;s.cherry=140000;s.cherry_plus=100;local cap=s.cherry_max;P.stepCherry(p)
check(s.cherry_max==cap+10000 and s.cherry==150000 and s.cherry_plus==0,'自然结界结束提高当前Cherry及上限10000')
p,s=start(7,'sakuyaa');s.cherry=200000;s.cherry_plus=25000;P.miss(p)
check(s.cherry==140000 and s.cherry_plus==25000,'咲夜死亡Cherry扣减上限60000')
p,s=start(8,'team0','th08_lunatic_b');s.time=0;s.gauge=0;s.total_time=0;lstg.var.pointrate=300000
P.collect('time',0,false)
check(s.time==1 and s.gauge==-111 and lstg.var.pointrate==300010,'时间点推进时刻计数、人妖槽及最大点价值')
P.collect('time',0,false)
check(s.time==2 and lstg.var.pointrate==300010,'最大点价值按总时间点奇偶更新')
p,s=start(10,'reimua');s.power=100;s.lives=2
local records={};local spawn=P.spawnItem
P.spawnItem=function(kind,x,y,flags) records[#records+1]={kind=kind,x=x,y=y,flags=flags};return spawn(kind,x,y,flags) end
p.x,p.y=72,-120;P.miss(p)
check(#records==0 and s.power==100 and p.original_drop_delay==3,'风神录死亡第三帧才扣火力、生成掉落')
P.deathDrops(p);P.spawnItem=spawn
check(s.power==36 and #records==7,'风神录死亡扣64原单位，掉落七个P')
for i,r in ipairs(records) do
    local expected=atan2(224,-72)+22.5-(i-1)*.11219973862171173*180/math.pi
    check(near(r.flags.velocity[1],3*cos(expected)) and near(r.flags.velocity[2],3*sin(expected)),'死亡P初速度遵循源程序扇形')
    check(r.kind==(i%2==0 and 'power_big' or 'power'),'死亡P大小交替')
end
local drop=New(P.classes.pickup,'power',0,0,{death=true,velocity={1,1}})
drop.class.frame(drop)
check(near(drop.x,1) and near(drop.y,1) and near(drop.motion_y,.97) and drop.original_death==nil,'死亡P使用速度积分、0.03重力，不走随机目标插值')
p,s=start(8,'team1','th08_lunatic_b');s.power=128
local rows=P.data(8,'ply01a').levels[6].shots;local missile
for _,row in ipairs(rows) do if row.callbacks[2]==3 then missile=row;break end end
check(missile and missile.speed==-2,'永夜抄导弹按SHT保留最初向下的速度')
object.EnemyNontjtDo=function() end
local shot=New(P.classes.shot,p,missile)
check(shot.vy<0,'导弹先从自机下方弹出')
for _=1,9 do shot.class.frame(shot) end
check(shot.vy>0,'导弹逐帧加速后向上飞，不会一直下沉')
p.__slow_flag=true;P.updateOptions(p);local laser
for _,row in ipairs(P.data(8,'ply01as').levels[6].shots) do if row.callbacks[2]==5 then laser=row;break end end
shot=New(P.classes.shot,p,laser);shot.original_rows=P.rowsFor(p);p.original_rows=shot.original_rows
local option=p.original_options[1]
check(near(shot.x,option[1]+laser.x) and near(shot.y,option[2]+208),'爱丽丝激光中心在子机上方208像素')
check(shot.b==224 and not shot.vm.follow and near(shot.vm.rotation[3],math.pi/2),'激光保持448像素及ANM原生旋转')
for _=1,6 do shot.class.frame(shot) end
check(#shot.history==6 and shot.history[1][2]>shot.y,'爱丽丝激光按源回调保存向上漂移的残影')
local regionHits=0;local hit=P.hitEnemy
object.EnemyNontjtDo=function(fn) fn({_live=true,colli=true,hp=100,x=shot.x,y=shot.y,a=0,b=0}) end
P.hitEnemy=function(_,damage) check(damage==1,'爱丽丝残影各段伤害为原始1点');regionHits=regionHits+1 end
shot.original_age=7;shot.class.frame(shot)
check(regionHits==3,'六个历史位置生成隔帧三段残影判定')
regionHits=0;p.__shoot_flag=false
P.hitEnemy=function(_,damage) check(damage==laser.damage,'激光释放后的消退阶段保留原伤害');regionHits=regionHits+1 end
shot.class.frame(shot)
check(regionHits==1 and shot.original_fade>0,'松开射击后保留主激光判定，不再建立残影区域')
P.hitEnemy=hit;object.EnemyNontjtDo=function() end
for _,machine in ipairs(P.machines(8)) do
    p,s=start(8,machine.id,'th08_lunatic_b');p.__slow_flag=true;P.updateOptions(p)
    if machine.id=='solo4' then check(p.original_options[1]~=nil,'紫单人具有追踪子机')
    elseif machine.id=='solo5' then check(p.original_options[1][2]==p.y+32,'爱丽丝单人子机位于上方32像素')
    elseif machine.id=='solo6' then check(#p.original_options==4,'蕾米莉亚单人具有四颗旋转子机')
    elseif machine.id=='solo3' then check(p.original_options[3]~=nil,'妖梦单人具有第三槽跟随子机') end
end
local calls={};local draw=A.draw
CheckRes=function() return true end
A.draw=function(vm,x,y,angle,sx,sy,alpha,tint,override,rotation) calls[#calls+1]={x=x,y=y,rotation=rotation} end
p,s=start(6,'marisab');P.bombInput(p,{spell=true},{},false);for _=1,130 do P.stepBomb(p) end;P.renderBomb(p)
check(#calls==4 and near(calls[1].rotation,18) and near(calls[4].rotation,-18),'红魔乡魔炮四束按18/6/-6/-18度展开')
for _,v in ipairs(calls) do check(v.y>p.y,'魔炮从自机前方延伸') end
A.draw=draw
for _,game in ipairs({6,7,8,10}) do
    p,s=start(game,P.machines(game)[1].id,game==8 and 'th08_lunatic_a' or nil)
    s.stage_name='1';s.power=99;s.points=200;s.cherry_plus=25000
    check(P.canContinue(),'通常关卡允许续关')
    local restart=OriginalSequence.restartChapter;local restarted=false
    OriginalSequence.restartChapter=function() restarted=true end
    P.continueRun({})
    check(s.lives==2 and s.continues==1 and s.power==0 and lstg.var.score==1,'续关恢复初始残机、重置火力分数并记录次数')
    check(restarted==(game==10),'仅风神录回到本关开头')
    if game==7 then check(s.cherry_plus==25000,'妖妖梦续关只重置当前Cherry，不清除Cherry+') end
    if game==8 then s.stage_name='6B';check(not P.canContinue(),'Final B禁止续关');s.stage_name='1';s.clock=11;check(not P.canContinue(),'接近天明时不能继续') end
    OriginalSequence.restartChapter=restart
    lstg.var.sequence_key=('th%02d_extra'):format(game);check(not P.canContinue(),'Extra不提供续关')
end
print('原作行为轨迹、激光几何、结界和续关检查通过：'..count)
