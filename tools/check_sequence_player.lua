-- 正式对象类、原始射击表与资源结算回归；不访问 User/ 和 replay/。
local root=(arg[1] or '.'):gsub('\\','/')
local f=assert(io.open(root..'/tools/drop-tests/unit.lua','rb'));local source=f:read('*a');f:close()
local prefix=source:sub(1,assert(source:find('local cooldown=Class',1,true))-1)
prefix=prefix:gsub("local R=dofile[^\n]+", "local root=arg[1];plus={}",1)
arg[1]=root
assert(loadstring(prefix))()
local checks=0
local function check(ok,label) assert(ok,label);checks=checks+1 end
local function load(path) return dofile(root..'/'..path) end
Render=function() end;RenderRect=function() end
SetV=function(o,v,a) o.vx=v*cos(a);o.vy=v*sin(a) end
Angle=function(a,b) return math.deg(math.atan2(b.y-a.y,b.x-a.x)) end
local distance=Dist
Dist=function(a,b,c,d) if d then return ((a-c)^2+(b-d)^2)^.5 end;return distance(a,b) end
atan2=function(y,x) return math.deg(math.atan2(y,x)) end
SQRT2_2=2^-.5
local P=load('THlib/sequence_resources.lua')
load('THlib/anm/original.lua')
load('THlib/item/item.lua')
load('THlib/sequence_player.lua')
InitAllClass()
OriginalSequence={catalog=load('mod/sequence_catalog.lua')}
stage={current_stage={timer=0,is_menu=false}}
ext={replay={IsReplay=function() return false end},achievement={get=function() end}}
lstg.tmpvar={};KeyState={};KeyStatePre={}
object.BulletIndesDo=function() end
local entries={{6,'th06_lunatic',4},{7,'th07_lunatic',6},{8,'th08_lunatic_b',12},{10,'th10_lunatic',6}}
for _,entry in ipairs(entries) do
    local game,key,count=unpack(entry)
    check(#P.machines(game)==count,'原作机体数量')
    for _,machine in ipairs(P.machines(game)) do
        lstg.var={__sequence_version=1,__sequence_system_version=1,__drops_version=0,
            sequence_key=key,sequence_player=machine.id,player_name=machine.route,current_system=''}
        item.PlayerInit()
        check(P.state().power==0 and not GameDrops.enabled(),'低火力起步，不继承强化')
        local hero=P.spawnPlayer()
        local followed={vm={follow=true},rot=90,original_player=hero}
        check(P.shotRotation(followed)==((game==6 or game==7) and 0 or 90),'各作随弹旋转使用原作贴图基准')
        followed.vm.follow=false
        check(P.shotRotation(followed)==nil,'未开启随弹旋转的贴图保留ANM角度')
        for _,power in ipairs({0,8,16,24,32,48,64,80,96,100,127,128}) do
            P.state().power=math.min(game==10 and 100 or 128,power)
            for _,slow in ipairs({false,true}) do
                hero.__slow_flag=slow;hero.__shoot_flag=true
                local rows=P.rowsFor(hero)
                check(#rows>0,'每个火力档都有原作射击表')
                hero.original_shot_time=0;P.shoot(hero)
                for _,row in ipairs(rows) do
                    local shot=New(P.classes.shot,hero,row)
                    shot.original_rows=rows
                    for _=1,2 do shot.class.frame(shot) end
                end
            end
        end
        hero.__shoot_flag=false
        for _,slow in ipairs({false,true}) do for _,death in ipairs({false,true}) do
            local state=P.state();state.power=game==10 and 100 or 128;state.bombs=3;state.bomb=nil
            check(P.bombInput(hero,{spell=true,slow=slow},{spell=false},death),'Bomb / 灵击可施放')
            check(state.power==(game==10 and 80 or 128),'仅灵击消耗火力')
            check(state.bombs==(game==10 and 3 or game==8 and death and 1 or 2),'决死和普通Bomb扣费')
            local duration=state.bomb.spec.duration
            for _=1,duration+1 do P.stepBomb(hero) end
            check(state.bomb==nil,'Bomb按原作时长结束')
        end end
        P.state().power=0;P.collect('power',0,false);P.collect('power_big',0,false)
        check(P.state().power==(game==10 and 21 or 9),'小P与大P使用原单位')
        P.collect('bomb',0,true);check(P.state().bombs>0,'Bomb道具补给')
        local power=P.state().power;P.miss(hero)
        check(P.state().power<=power and lstg.var.dead==1,'死亡扣火力与掉落')
    end
end
lstg.var={__sequence_version=1,__sequence_system_version=1,sequence_key='th07_lunatic',sequence_player='reimua',player_name='reimu_player'}
item.PlayerInit();P.state().power=128;P.collect('power',0,true)
check(P.state().cherry_plus==1000,'妖妖梦满火力转樱点')
local balance=load('mod/GAME/original/low_speed_hp.lua')
check(balance.cards[7][3408]==balance.entries[7][3408].raw,'顺序模式Boss采用原作血量')
local target={_live=true,hp=1000,is_sc=false,class={base={take_damage=function(o,damage) o.hp=o.hp-damage end}}}
P.hitEnemy(target,100,false);P.flushDamage()
check(target.hp==930,'原作同帧伤害封顶70，直接扣原作HP')
target.is_sc=true;P.hitEnemy(target,100,false);P.flushDamage()
check(target.hp==920,'原作符卡对封顶后的70点伤害整数除7')
P.hitEnemy(target,100,true);P.flushDamage()
check(target.hp==892,'妖妖梦Bomb符卡伤害：70/2.5向下取整')
for _,machine in ipairs(P.machines(8)) do
    local p={original_game=8,original_machine=machine}
    local a=P.bombProfile(p,false,false);local b=P.bombProfile(p,true,false)
    if machine.id:sub(1,4)=='solo' then check(a.key==b.key,'永夜抄单人机体的高低速Bomb保持同一角色') end
end
lstg.var.__sequence_system_version=nil
check(not P.enabled() and balance.cards[7][3408]==balance.entries[7][3408].hp,'旧录像和其他模式保持旧血量')
lstg.var={__sequence_version=1,__sequence_system_version=1,sequence_key='th10_lunatic',sequence_player='reimua',player_name='reimu_player'}
item.PlayerInit()
local spawn=P.spawnItem;local drops={}
P.spawnItem=function(kind) drops[kind]=(drops[kind] or 0)+1 end
local fairy={x=0,y=0,_original_source={key='stage01:BGirl00'}}
check(P.dropOriginalEnemy(fairy) and drops.point==1,'风神录一面蓝妖精击破掉落原作蓝点')
check(P.dropOriginalEnemy(fairy) and drops.point==1,'同一敌机不重复掉落')
fairy={x=0,y=0,_original_source={key='stage01:RGirl00'}}
check(P.dropOriginalEnemy(fairy) and drops.power==1,'风神录一面红妖精击破掉落原作小P')
local before=lstg.var.score
target.is_sc=false;target.hp=1000
P.hitEnemy(target,10,false);P.flushDamage()
check(lstg.var.score==before+10,'风神录命中得分从原作十位存储还原为显示分')
P.spawnItem=spawn
local C=load('THlib/bullet/original_collision.lua')
for _,name in ipairs({'Ecl_BGirl00','Ecl_RGirl00','Ecl_GGirl00'}) do
    local e={x=0,y=0}
    C.unit(e,10,'stage01:'..name)
    check(e.a==12 and e.b==12 and e._original_contact_box[1]==16,'开场同步出生包装具有24×24受弹框、16×16体术框')
end
local oldPlayer,oldBox,oldEnemies=player,BoxCheck,object.EnemyNontjtDo
local H=load('mod/GAME/th35_interaction.lua')
local contacts=0
player={_live=true,x=9.99,y=0,A=2,B=2,class={colli=function() contacts=contacts+1 end}}
BoxCheck=function() return true end
local e={_live=true,x=0,y=0,hp=20,colli=true,protect=true,DMG_factor=1,dmg_factor=1,astral_dmg_factor=1,class=enemy}
C.unit(e,10,'stage01:Ecl_BGirl00');H.init(e,'stage01:Ecl_BGirl00')
H.frame(e);check(contacts==1,'原作16×16体术框在边界内命中')
player.x=10.01;H.frame(e);check(contacts==1,'原作体术框边界外不误判')
local hero=P.spawnPlayer();local row=P.rowsFor(hero)[1]
object.EnemyNontjtDo=function(fn) fn(e) end
local shot=New(P.classes.shot,hero,row);shot.x,shot.y=0,0
shot.class.frame(shot);P.flushDamage()
check(not IsValid(shot) and e.hp==20,'出生减伤期仍消耗命中弹，不扣敌机血量')
shot=New(P.classes.shot,hero,row);shot.x,shot.y=0,230;e.y=230;e.protect=false
shot.class.frame(shot);P.flushDamage()
check(IsValid(shot) and e.hp==20,'普通弹框尚未完全入场时不命中场外敌机')
player,BoxCheck,object.EnemyNontjtDo=oldPlayer,oldBox,oldEnemies
print('顺序模式机体、射击表、资源和Bomb检查通过：'..checks)
