-- TH31 原生生命、使魔受击与父伤害回归；不按密度修改弹幕。
-- 来源：TH08 EclRunLow.inl:77/79..81、EnemyManager::ApplyDamageToParent，
-- 原版 ecldata_al/Sub2、ecldata7sp/Sub80、ecldata4b/Sub21 与 Last Word 生成助手。
local native=rawget(_G,'TH31_COMBAT_NATIVE')
arg={'th31-combat'}
local original_popen=io.popen
if package.config:sub(1,1)=='\\' and debug.getinfo(io.popen).what=='C' then
    local commands={
        ['ls Resources/Special/ 2>/dev/null']='dir /b "Resources\\Special" 2>NUL',
        ['ls Resources/BossBackGround/ 2>/dev/null']='dir /b "Resources\\BossBackGround" 2>NUL',
        ["find mod THlib Resources -name '*.lua' 2>/dev/null"]='dir /b /s "mod\\*.lua" "THlib\\*.lua" "Resources\\*.lua" 2>NUL',
    }
    io.popen=function(c) return original_popen(commands[c] or c) end
end
local f=assert(io.open('tools/check_stage.lua','rb'));local s=f:read('*a');f:close()
assert(loadstring(s:sub(1,assert(s:find('if path == "--all" then',1,true))-1)))()
io.popen=original_popen
local objects,cards,checks={}, {},0
local function check(v,msg) assert(v,msg);checks=checks+1 end
local function near(a,b) return math.abs(a-b)<0.00001 end
local helpers=object
dofile('THlib/lib/Lobject.lua')
for k,v in pairs(helpers) do if rawget(object,k)==nil then object[k]=v end end
dofile('THlib/lib/Ltask.lua')
-- 使用真实enemybase的colli元表，避免桩件漏掉「低速一次后永久不可打」的问题。
SetAttr=function(o,k,v)
    if native and rawget(o,3)~=nil then return native.SetAttr(o,k,v) end
    rawset(o,k=='colli' and '_test_engine_colli' or k,v)
end
GetAttr=function(o,k)
    if native and rawget(o,3)~=nil then return native.GetAttr(o,k) end
    return rawget(o,k=='colli' and '_test_engine_colli' or k)
end
lstg.var.score,lstg.var.man=0,0
SearchStageLevel={}
BoxCheck=function(o,l,r,b,t) return o.x>=l and o.x<=r and o.y>=b and o.y<=t end
AddMoney=function() end
GameRank=false
GameDrops=false
local ef=assert(io.open('THlib/enemy/enemy.lua','rb'));local es=ef:read('*a');ef:close()
local enemy_start=assert(es:find('local cos, sin = cos, sin',1,true))
assert(loadstring(es:sub(enemy_start)))()

New=function(c,...)
    InitAllClass()
    local o
    if native then o=native.New(c,...)
    else
        o={class=c,x=0,y=0,rot=0,vx=0,vy=0,omiga=0,timer=0,ani=0,_live=true,
            hscale=1,vscale=1}
        setmetatable(o,{__index=GetAttr,__newindex=function(t,k,v)
            if k=='colli' then SetAttr(t,k,v) else rawset(t,k,v) end
        end})
        if c.init then c.init(o,...) end
    end
    objects[#objects+1]=o;return o
end
IsValid=function(o)
    if o==nil then return false end
    if native and rawget(o,3)~=nil then return native.IsValid(o) end
    return o._live~=false
end
object.RawDel=function(o)
    if not IsValid(o) then return end
    if native then o.status='del' else o._live=false end
end
object.Kill=function(o)
    if not IsValid(o) then return end
    if native then native.Kill(o)
    else if o.class.kill then o.class.kill(o) end;o._live=false end
end
Damage=function(o,v) o.class.base.take_damage(o,v) end
local BossBase=Class(object,{
    take_damage=function(o,v)
        o.hp=o.hp-v*(o.dmg_factor or 1)*(o.DMG_factor or 1)
    end,
},true)
local BossClass=Class(BossBase,{init=function(o)
    o.hp,o.maxhp,o.x,o.y=100000,100000,0,96
    o.dmg_factor,o.DMG_factor=1,1
    o.StageLevel=29
end},true)
boss.card.add=function(parts,_,_,id) cards[id]=parts[1][1] end
dofile('mod/GAME/th31.lua')
local M=_editor_class.TH31.th08_combat
local function boss_owner(id)
    local o=New(BossClass);o.th08_combat_card=id or 218
    o.th08_actors,o.th08_actor_counts={},{};M.owner=o;return o
end
local function step(o,n)
    for _=1,n do o.class.frame(o) end
end
local definition={init=function(o,x,y) o.x,o.y=x or 0,y or 0 end,
    frame=function(o) o.test_steps=(o.test_steps or 0)+1 end}
local owner=boss_owner()
local Doll=M.actor('ecldata_al:2',definition)
local doll=New(Doll,0,96)
check(doll.hp==9000 and doll.maxhp==9000 and doll.a==12 and doll.b==12 and doll.rect,
    '爱丽丝人偶使用原生9000血与24×24受弹框')
check(doll.group==GROUP.NONTJT and doll.colli,'生成使魔只关闭接触判定，仍能成为自机弹目标')
Damage(doll,200);check(doll.hp==9000,'30帧出生免伤')
step(doll,30);Damage(doll,200);check(doll.hp==9000,'第30帧仍不吃伤害')
step(doll,1);Damage(doll,200)
check(doll.hp==8800 and owner.hp==99900,'免伤结束后受击，并将实受伤害的一半传给父Boss')
local before=doll.test_steps
if native then
    GameDrops=false
    local Shot=Class(object,{init=function(o)
        o.group,o.colli,o.a,o.b=GROUP.PLAYER_BULLET,true,1,1
        o.x,o.y,o.dmg,o.mute=doll.x,doll.y,20,true
    end},true)
    local shot=New(Shot)
    native.CollisionCheck(GROUP.NONTJT,GROUP.PLAYER_BULLET)
    check(doll.hp==8780 and owner.hp==99890,'真实引擎碰撞矩阵调用使魔的受击回调')
    native.AfterFrame()
    check(not IsValid(shot),'真实碰撞后消耗自机弹')
end
Damage(doll,10000)
check(doll.th08_dead and doll.task==nil,'击破后立即停止对象协程')
if native then native.AfterFrame() end
check(not IsValid(doll),'击破后释放对象')
-- 妖怪形态使用项目已有的7帧过渡；改变形态不等同于销毁使魔。
owner=boss_owner()
local target=New(Doll,0,96);step(target,31)
stage={current_stage={timer=0}}
player.slow=1
for t=1,8 do stage.current_stage.timer=t;step(target,1) end
check(not target.colli and not target.th08_accept,'妖怪形态不受击；不是把所有使魔一直设成无敌')
local hp=target.hp;Damage(target,200);check(target.hp==hp,'低速形态不扣使魔血量')
player.slow=0
for t=9,16 do stage.current_stage.timer=t;step(target,1) end
check(target.colli and target.th08_accept,'回到人类形态后恢复受击')
owner=boss_owner(210)
local Tree=M.actor('ecldata7sp:80',{init=function(o) o.x,o.y=0,96 end})
local tree=New(Tree,0,96,0)
check(tree.hp==4000 and not tree.colli,'蓬莱之树海的第一棵树4000血，飞行前120帧关闭受击')
step(tree,119);Damage(tree,100);check(tree.hp==4000,'树在第119帧仍不可受击')
step(tree,1);check(tree.colli and tree.group==GROUP.ENEMY,'第120帧按 ENABLE_INTERACTION_FLAGS 3 恢复受击与接触')
Damage(tree,100);check(tree.hp==3900,'树落位后可打掉')
local invulnerable=M.actor('ecldata4asp:44',{init=function() end})
local hidden=New(invulnerable,0,96,0,1);step(hidden,60)
local hp=hidden.hp;Damage(hidden,99999)
check(not hidden.colli and hidden.hp==hp,'梦想天生的使魔保持原作 DISABLE 3，不批量开启')
-- Last Word：14张有限血量；三张原生耐久不改成击破卡。
local finite=0
-- 独立记录生成助手中 SET_LIFE -> CALL LW 的分支值，避免只检查表与自身一致。
local source_life={3300,3300,4800,3500,4000,4000,4000,4400,4000,
    false,false,3300,3300,6000,4000,5000,false}
for n=205,221 do
    local card=assert(cards[351+n-205])
    if M.lastwords[n] then
        local p=M.lastwords[n];finite=finite+1
        check(card.hp==source_life[n-204] and near(card.t1,p[2]/60) and card.t1<card.t3,
            'Last Word '..n..'保留原始life与110帧入场无敌')
    else check(card.t1==card.t3,'原作耐久Last Word：'..n) end
end
check(finite==14,'14张可击破，3张原生耐久')
local card=cards[364];owner=boss_owner(218);card.init(owner)
check(owner.colli and not owner.no_hp_render and not owner.NotPlayTimeOutSound,'可击破LW显示血条，超时按普通符卡结算')
for _=1,110 do card.frame(owner) end
card.frame(owner);check(near(owner.DMG_factor,1/9),'LW开启受伤后原生120帧九倍防御')
for _=1,120 do card.frame(owner) end
check(owner.DMG_factor==1,'原生保护结束后恢复全伤害')
local actors=owner.th08_actors
card.del(owner)
check(owner.DMG_factor==1 and owner.th08_combat_card==nil,'换卡恢复伤害因子与阶段上下文')
if native then native.AfterFrame() end
for _,o in ipairs(actors) do check(not IsValid(o),'换卡清理仍存活的使魔') end
-- 真的构造魔理沙一非的使魔，原作700血不能当成700帧寿命。
local function find(root,key)
    local seen={}
    local function visit(v)
        if (type(v)~='function' and type(v)~='table') or seen[v] then return end;seen[v]=true
        if type(v)=='function' then
            for i=1,100 do local name,u=debug.getupvalue(v,i);if not name then break end
                if name==key then return u end
                local r=visit(u);if r then return r end
            end
        else for _,u in pairs(v) do local r=visit(u);if r then return r end end end
    end
    return assert(visit(root),key)
end
owner=boss_owner(452)
local orb=New(find(cards[452],'c452_orb'),45,117,0,1)
check(orb.img=='ellipse16' and orb.th08_source=='ecldata4b:70',
    'Final Master Spark实际构造原生使魔，图片资源使用已注册的ellipse16')
owner=boss_owner(443)
local Familiar=find(cards[443].init,'familiar')
local fam=New(Familiar,owner,2,700,{})
for _=1,701 do if IsValid(fam) then fam.class.frame(fam) end end
check(IsValid(fam) and fam.hp==700,'原作HP不再每帧递减，也不自动当寿命回收')
-- 7帧过渡由卡片每帧推进；没有使魔、长时间没有射击也不能停计时。
local noop=function() end
local idle={t1=0,t3=1,init=noop,frame=noop,del=noop}
M.bind(idle,99999)
stage={current_stage={timer=0}};player.slow=0
owner=boss_owner(99999);idle.init(owner);M.form()
local function tick(t,slow)
    stage.current_stage.timer=t;player.slow=slow;idle.frame(owner)
end
for t=1,7 do
    tick(t,1)
    for _=1,40 do assert(not M.form(),'同帧多使魔/多发弹不加快形态过渡') end
    check(not M.form(),'同帧多次查询不推进过渡')
end
tick(8,1);check(M.form(),'无发弹时也在第7个稳定帧进入妖怪形态')
check(M.shot_allowed({th08_attached=true},0x8000),'附着使魔允许妖怪专属弹')
check(not M.shot_allowed({th08_attached=true},0x10000),'附着使魔跳过人类专属弹')
check(M.shot_allowed({},0x10000) and not M.shot_allowed({},0x8000),
    '独立敌机和Boss保持自身youkaiAligned，不直接套用自机低速')
check(M.shot_allowed({th08_attached=true},0x202),'没有形态条件的使魔照常发弹')
for t=9,15 do tick(t,0);check(M.form(),'松开低速的过渡期间仍是妖怪形态') end
tick(16,0);check(not M.form(),'7帧反向过渡后恢复人类形态')
for t=17,19 do tick(t,1) end
tick(20,0);check(not M.form(),'不足7帧的低速轻按不改变已提交形态')
-- 实际Sub36枪：0x3f/0x5f互斥，发数/弹色/速度必须取原件对应的一行。
local impl=find(cards[427].frame,'impl')
local source_fam=find(impl,'familiar')
local EX=find(impl,'EX')
local shoot=EX.shoot;local shots={}
EX.shoot=function(w,x,y,a) shots[#shots+1]=a end
local emitter={th08_attached=true,x=0,y=96,li1=6,li2=8,gun_ang=0}
source_fam.fire(emitter)
check(#shots==1 and shots[1].count1==8 and near(shots[1].speed1,3.65) and shots[1].color==EX.color(8),
    'Sub36高速：一圈8发、色8、速3.5+原生rank0.15')
for t=21,28 do tick(t,1) end
source_fam.fire(emitter)
check(#shots==2 and shots[2].count1==8 and near(shots[2].speed1,2.65) and shots[2].color==EX.color(6),
    'Sub36低速：一圈8发、色6、速2.5+原生rank0.15，不把两支同时叠加')
local color_seen
M.render(emitter,function(o) color_seen={o._r,o._g,o._b,o._a} end)
check(color_seen[1]==32 and color_seen[2]==32 and color_seen[3]==192 and color_seen[4]==127.5,
    '妖怪使魔沿用原作蓝色半透明显示')
EX.shoot=shoot
-- 七套道中调度都通过同一unit入口；实际enemybase在每帧重新计算colli。
local Unit=M.unit({init=function(o,sub,x,y,mirror,parent)
    enemybase.init(o,600,false)
    o.x,o.y=x,y;o.img='servant';o.reduction=0;o._a=255
end})
local independent=New(Unit,0,0,96,false,nil)
local linked=New(Unit,0,0,96,false,independent)
local hp=linked.hp
M.unit_collision(linked)
check(not linked.colli and linked._colli,'低速只关本帧判定，保留enemybase持久_colli')
Damage(linked,100);check(linked.hp==hp,'道中使魔低速时直调Damage也不受伤')
Damage(independent,100);check(independent.hp==500,'独立道中敌机在低速时正常受击')
for t=29,36 do tick(t,0) end
enemybase.frame(linked);M.unit_collision(linked)
check(linked.colli and linked._colli,'回到高速后恢复真实enemybase受弹判定')
Damage(linked,100)
check(linked.hp==500 and independent.hp==450,'高速道中使魔受击，并将一半实伤传给父机')
idle.del(owner)
print(('TH31 Last Word 与使魔受击回归通过：%d 项'):format(checks))
