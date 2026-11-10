-- 对照原作发射器的边界场景：松键续射、子机展开、持久槽、命中ANM和特殊系统。
-- 期望值来自各作Player.cpp/SHT/原版TH10回调，不能只枚举“可创建、无报错”。
dofile('tools/check_sequence_player.lua')
local P,A=SequenceResources,OriginalANM
local checks=0
local function check(ok,label) assert(ok,label);checks=checks+1 end
local function near(a,b) return math.abs(a-b)<.0001 end
local function start(game,id,power)
    lstg.var={__sequence_version=1,__sequence_system_version=1,sequence_key=('th%02d_lunatic%s'):format(game,game==8 and '_b' or ''),sequence_player=id,player_name='reimu_player'}
    item.PlayerInit();local p=P.spawnPlayer();player=p;P.state().power=power or 128
    p.__slow_flag=false;p.__shoot_flag=true;p.death=0;p.protect=0
    P.updateOptions(p)
    return p,P.state()
end
object.EnemyNontjtDo=function() end
for _,game in ipairs({6,7,8,10}) do
    for _,m in ipairs(P.machines(game)) do
        local p=start(game,m.id,game==10 and 100 or 128)
        local archive=(game==10 and 'pl' or 'player')..('%02d'):format(m.character)
        for _,slow in ipairs({false,true}) do
            p.__slow_flag=slow
            for _=1,8 do P.updateOptions(p) end
            for _,row in ipairs(P.rowsFor(p)) do
                local id=row.animation+(game==7 and -1024 or game==8 and 10 or game==10 and 5 or 0)
                local vm=P.animation(game,archive,id)
                check(vm.data.archive==archive and vm.id==vm.data.ids[id],'每个机体使用所属角色ANM及原始SHT脚本号')
                if game==10 then check(type(row.hit)=='number' and A.load(game,archive).ids[row.hit+5]~=nil,'风神录命中ANM从SHT导出') end
            end
            for _,o in pairs(p.original_option_state) do
                check(o.vm.data.archive==archive and o.vm.id==o.vm.data.ids[o.id],'子机ANM不跨角色档案')
            end
        end
    end
end
-- 红/妖/永的30/30/20帧周期在松键后继续走完；风神录还要发出第15帧的行。
for _,game in ipairs({6,7,8,10}) do
    local p=start(game,game==8 and 'solo0' or 'reimub',0)
    local rows=P.rowsFor(p);local actual={};local new=New
    New=function(c,hero,row,...)
        if c==P.classes.shot then actual[row]=(actual[row] or 0)+1 end
        return new(c,hero,row,...)
    end
    local duration=game==10 and 16 or game==8 and 20 or 30
    for i=0,duration-1 do P.updateShooting(p,i==0,true) end
    New=new
    for _,row in ipairs(rows) do
        local expected=0;for i=0,duration-1 do if i%row.interval==row.frame then expected=expected+1 end end
        check(actual[row]==expected,'松键不能截掉原作周期内的发弹')
    end
    check(p.original_shot_time==-1,'一轮射击结束后回到未射击状态')
end
local p,s=start(7,'marisab')
check(p.original_option_state[1].id==128 and p.original_option_state[2].id==129,'妖妖梦魔理沙B子机采用1152/1153减原作载入基址1024')
check(p.original_option_state[1].vm.sprite==128,'魔理沙B子机最终精灵来自player01的sprite128')
p.original_shot_time=0;P.shoot(p)
check(p.original_fire_slots[0].owner and p.original_fire_slots[1].owner,'高速两束激光分别占0/1槽')
local old=p.original_fire_slots[0].owner
p.__slow_flag=true;P.updateOptions(p);P.stepShotSlots(p);P.shoot(p)
check(not p.original_fire_slots[0].owner and not p.original_fire_slots[2].owner,'未完全收拢时不生成低速激光')
check(not old.vm.stopped,'高速激光切换时走ANM中断退场')
for _=1,7 do P.updateOptions(p) end
check(p.original_option_phase==3,'八帧完成收拢')
P.shoot(p);local focused=p.original_fire_slots[2].owner
check(focused and p.original_fire_slots[2].time==999,'低速主激光使用独立2槽和999计时')
focused.class.frame(focused)
check(#focused.history==0,'聚焦激光首帧不能填入伪残影')
p.__slow_flag=false;P.updateOptions(p)
check(near(p.original_options[2][1]-p.x,8.25),'展开第一帧横向偏移为8+16/64')
P.stepShotSlots(p);check(not IsValid(focused),'离开完全收拢状态立即回收低速激光')
p,s=start(8,'team1');p.__slow_flag=true;P.updateOptions(p);p.original_shot_time=0;P.shoot(p)
local beam=p.original_fire_slots[0].owner;local option=p.original_option_state[1]
check(beam and beam.row.callbacks[1]==4,'永夜抄持久激光使用第4号出生回调')
for _=1,5 do beam.class.frame(beam) end
p.__shoot_flag=false;beam.class.frame(beam)
check(not beam.original_trail_stopped,'仅松键不提前中断尚未结束的20帧周期')
p.original_shot_time=-1;beam.class.frame(beam)
check(beam.original_trail_stopped and not p.original_fire_slots[0].owner,'周期结束后释放槽，完成当帧回调再停止残影更新')
local length=#beam.history;beam.class.frame(beam);check(#beam.history==length,'回调停用后历史不能继续扩散')
p.__slow_flag=false;P.updateOptions(p)
check(p.original_option_state[1]==option and option.exit==1,'切回高速保留同一个子机执行退场ANM')
for _=1,17 do P.updateOptions(p) end
check(not p.original_option_state[1],'退场计时大于16后停用子机')
p,s=start(10,'marisab',80);p.original_shot_time=0;P.shoot(p)
for _,slot in pairs(p.original_fire_slots) do
    beam=slot.owner
    check(near(beam.y,p.original_options[beam.row.option][2]+240),'风神录激光仅使用SHT的一次240偏移')
end
local homing
p,s=start(10,'reimua',80)
for _,r in ipairs(P.rowsFor(p)) do if r.callbacks[2]==1 then homing=r;break end end
local target={_live=true,colli=true,hp=1000,x=180,y=-160};p.original_homing_target=target
local shot=New(P.classes.shot,p,homing);shot.speed=10;shot.rot=90;shot.original_vx,shot.original_vy=0,10
shot.class.frame(shot)
check(shot.speed<10 and shot.speed>=4 and shot.rot<90,'风神录追踪札转大弯时减速并按角差的20%转向')
local angle=shot.rot;shot.original_age=120;shot.class.frame(shot)
check(near(shot.rot,angle),'追踪札120帧后不再转向')
target._live=false;p.original_homing_target={_live=true,colli=true,hp=100,x=-100,y=0};shot.class.frame(shot)
check(shot.original_target==nil,'目标死亡后不能换成另一只敌机')
p,s=start(8,'solo4');s.focus_frames=30;s.last_focus=false;s.gauge=0;s.human=0;s.gauge_ramp=150;p.original_shot_time=1
P.gaugeStep(p);check(s.gauge==-10,'紫单人高速射击仍使人妖槽向人侧移动')
p,s=start(7,'reimua');s.bomb={};s.cherry_plus=0;s.cherry=0
P.collect('star',0,true,0);P.collect('star',0,true,1)
check(s.cherry==20 and s.cherry_plus==10,'妖妖梦Bomb消弹星按道具槽奇偶分别加Cherry+和Cherry')
p,s=start(8,'team0');s.bombs=1;s.time=0;s.stage_name='1';boss_group={{_live=true,is_sc=true,is_combat=true}}
P.collide(p,{})
check(p.original_deathbomb==21 and p.original_death_freeze,'结界组符卡决死窗口为floor(6×2×9/5)，冻结弹幕')
boss_group={}
p,s=start(8,'solo1');s.bombs=3;s.time=3000;s.stage_name='1';P.collide(p,{})
check(p.original_deathbomb==15,'普通状态决死窗口按雷数、时符条件封顶15')
-- CalcDamageToEnemy按主框、副框各走一遍；蕾米莉亚的6型弹穿透，普通弹只命中第一次。
local function fixture()
    return {_live=true,x=0,y=0,hp=1000,colli=true,a=16,b=16,_original_damage_box={32,32},_original_secondary_box={32,32},
        class={base={take_damage=function(e,n) e.hp=e.hp-n end}}}
end
p,s=start(8,'solo6')
local e=fixture();object.EnemyNontjtDo=function(fn) fn(e) end
local row=P.data(8,'ply02as').levels[7].shots[1]
shot=New(P.classes.shot,p,row);shot.x,shot.y=0,0;p.original_shot_pool={[1]=shot};shot.original_pool_slot=1
P.resolveShotHits();P.flushDamage()
check(e.hp==930 and not shot.original_hit,'45点6型弹两次命中，副框除1.7后同帧封顶70；不切换命中ANM')
check(e.original_time_accumulator==50,'主框45点补入积累后，副框先消耗40，再补入45')
p,s=start(8,'solo6');e=fixture()
row=P.data(8,'ply02as').levels[6].shots[1]
shot=New(P.classes.shot,p,row);shot.x,shot.y=0,0;p.original_shot_pool={[1]=shot};shot.original_pool_slot=1
P.resolveShotHits();P.flushDamage()
check(e.hp==1000-row.damage and shot.original_hit,'普通弹主框命中后不再重复命中副框')
check(shot.vm.time==1,'命中ANM仅执行一次初始化，不在当帧额外推进')
p,s=start(8,'team3');e=fixture();P.queueHitRegion(0,0,32,32,7,false)
P.resolveShotHits();P.flushDamage();check(e.hp==992,'幽冥组副框伤害在整批区域结算后除6.5')
object.EnemyNontjtDo=function() end
-- 风神录位置表是两组10个Float3，power=2时的两个子机必须左右对称。
p,s=start(10,'reimua',40)
check(#p.original_data.options==20 and near(p.original_options[1][1]-p.x,-32) and near(p.original_options[2][1]-p.x,32),'按12字节读取Float3，不能把Z读成下一个子机X')
p.__slow_flag=true;for _=1,40 do P.updateOptions(p) end
check(near(p.original_options[1][1]-p.x,-16) and near(p.original_options[2][1]-p.x,16),'低速子机位置从0x98的第10项偏移表读取')
for _,game in ipairs({7,8,10}) do
    p,s=start(game,game==8 and 'team0' or 'reimua',128);p.__slow_flag=true
    for _=1,8 do P.updateOptions(p) end
    P.updateFocusVisual(p)
    local vm=p.original_focus_vm.vm
    check(vm.data.archive==(game==10 and 'bullet' or 'etama') and vm.id==(game==7 and 51 or game==8 and 54 or 352),'慢速判定标记使用各作自己的ANM及正确编号口径')
end
shot=New(P.classes.shot,p,P.rowsFor(p)[1]);lstg.var.original_resources=nil
local ok=pcall(shot.class.render,shot)
check(ok,'切换机体时系统版本有效但资源账本已清空，旧自机弹必须停止绘制')
print('原作发弹边界、ANM归属及特殊系统对表通过：'..checks)
