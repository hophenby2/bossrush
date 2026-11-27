-- 使用真实光背类、终符时间表、强化火力和阶段HP换算，检查多层转伤。
local function read(path)local f=assert(io.open(path,'rb'));local s=f:read('*a');f:close();return s end
local fixture=read('tools/check_theis_entry.lua')
fixture=fixture:sub(1,assert(fixture:find('local savedDrops=GameDrops',1,true))-1)
local W,E=assert(loadstring(fixture..'\nreturn W,E'))()
W.prepareRogue()
player.nextspell,player.protect=0,0
-- 本专项核对伤害和任务状态，实例不借助类方法继承，也不模拟精灵资源系统。
New=function(class,...)
    local o={class=class,_live=true,timer=0,ani=0,x=0,y=0,rot=0,vx=0,vy=0,ax=0,ay=0,omiga=0,hscale=1,vscale=1}
    local init=class.init or class[1];if init then init(o,...)end
    return o
end
local H=dofile('THlib/rogue_hp.lua')
local D=dofile('THlib/drops.lua')
local host=read('THlib/enemy/enemy.lua')
assert(loadstring(host:sub(assert(host:find('function GetDamageHandler',1,true)),assert(host:find('\nenemy = Class',1,true))-1)))()
local playerSource=read('THlib/player/player.lua')
local playerClass={};player_lib={}
assert(loadstring('local player_class=...\n'..playerSource:sub(assert(playerSource:find('function player_lib.CanTarget',1,true)),assert(playerSource:find('\nlocal SetImageState',1,true))-1)))(playerClass)
local cls=E._editor_class['stage6bossScpr:Lunatic']
local card=cls.cards[20]
assert(card.name:find('诸行无常',1,true) and card.t1==300 and card.t2==1200 and card.t3==7200)
local rate=dofile('mod/rogue_ttk_hp.lua').damageUnits[39]
local function near(a,b,label)assert(math.abs(a-b)<1e-7*math.max(1,math.abs(b)),label..': '..a..' / '..b)end
for _,mode in ipairs({'practice','disabled','enhanced'})do
    lstg.var.__hp_scale_version=mode~='practice' and H.VERSION or nil
    lstg.var.__drops_version=mode~='practice' and D.VERSION or nil
    local run={source_hp=true,source_damage=rate,enhanced=mode=='enhanced'};lstg.var.rogue_run=run
    H.init(run);D.reset()
    if mode=='enhanced' then
        for i=1,38 do H.enter(i)end
        lstg.var.upgrades.players[1].red=1000000
    end
    local owner={class=cls,_live=true,group=GROUP.ENEMY,hp=5000,maxhp=5000,spell_damage=0,
        dmg_factor=0,dmgrate=1,protect=false,x=0,y=169,dx=0,dy=0,colli=true,sc_pro=0}
    H.wrapSourceClass(cls);H.apply(owner)
    local light=E.New(E.s6_boss.back_light,owner)
    E.s6_boss.back_light.appear(light)
    for _=1,151 do light.class.frame(light)end
    assert(light.colli and not owner.colli,'原作光背展开后的受击目标切换失败')
    object.EnemyNontjtDo=function(fn)fn(owner);fn(light)end
    local p={x=0,y=-176};playerClass.findtarget(p)
    assert(player_lib.CanTarget(light) and p.target==light,'实际索敌遗漏光背自身的转伤接口')
    local timerSystem={boss=owner,GetCurrentCard=function()return card end}
    local shot={dmg=10,killflag=true,mute=true}
    for _,row in ipairs({{299,1},{750,.5},{1200,1}})do
        owner.timer,owner.dmgrate=row[1],row[2]
        E.BossSystem.CheckTimer(timerSystem)
        local expected=10*D.power(shot)*(mode~='practice' and rate/H.factor(light) or 1)*owner.dmg_factor*owner.dmgrate
        local hp=owner.hp;light.class.colli(light,shot)
        near(hp-owner.hp,expected,'碰撞火力、伤害单位或阶段倍率错误：'..mode)
        assert(shot.dmg==10 and shot.killerenemy==owner,'转伤改写原始弹伤或命中归属')
        hp=owner.hp;Damage(light,D.damage(shot.dmg,shot))
        near(hp-owner.hp,expected,'宿主直接伤害未正确转交原作Boss：'..mode)
        if row[1]>=300 then assert(expected>0,'原作可受伤时段被误设为无敌')end
    end
    -- 同一原作回调作对照：强化后的实际损血必须是漏乘火力时的100倍。
    if mode=='enhanced' then
        local sourceCollision
        for i=1,20 do
            local name,value=debug.getupvalue(light.class.colli,i)
            if not name then break end
            if name=='sourceCollision' then sourceCollision=value;break end
        end
        local hp=owner.hp;assert(sourceCollision)(light,shot);local legacy=hp-owner.hp
        hp=owner.hp;light.class.colli(light,shot)
        near(hp-owner.hp,legacy*100,'没有覆盖独立回调漏乘强化火力的问题')
    end
    light.class=object
    assert(not player_lib.CanTarget(light),'退役对象仍凭旧派发指针被当作可受伤目标')
    print(('PASS 光背转伤：%s，火力%.1f，HP倍率%.6f，5秒无敌/渐进减伤/碰撞/直接伤害/索敌'):format(mode,D.power(shot),H.factor(owner)))
end
