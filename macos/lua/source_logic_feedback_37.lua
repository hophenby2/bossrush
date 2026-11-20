-- 使用原作双 Boss 卡和真实装备主炮，分别射击两侧。
local T={}
local checked={}
local originalHP
local start
local familiar
local ghost=Class(object,{init=function(o) o.group,o.colli,o.bound,o.hide=GROUP.GHOST,false,false,true end},true)
local function actors()
    for _,o in ipairs(boss_group) do if o.mhj3_card then return o,o.mhj3_card end end
end
function T.before(p)
    local t=stage.current_stage.timer
    local owner,ctx=actors()
    if not start and ctx and ctx.clock>=200 and ctx.actors[1].object.colli and ctx.actors[2].object.colli then start=t end
    local age=start and t-start or -1
    local shooting=age>=1 and age<41 or age>=51 and age<91
    AndroidInput.keys[setting.keys.shoot]=shooting
    AndroidInput.keys[setting.keys.spell]=false
    p.protect=100000
    if shooting and ctx then
        local o=ctx.actors[age<41 and 1 or 2].object
        p.x,p.y=o.x,o.y-90
        if age==1 or age==51 then originalHP=owner.hp end
    end
    if age==120 then
        -- 使用当前原作配置创建受弹开关样本，避免等待符卡后半段才出现使魔。
        local c=ctx.actors[2].controller
        familiar=New(TH39.runtime.classes.familiar,{controller=c,fx=481,fy=200,life=1000,changes={}},4,ctx.configs[3])
    elseif age==150 then
        assert(checked.familiar,'使魔原作出生保护结束后仍未开放受弹')
        object.RawDel(familiar)
    end
end
function T.after(p)
    local t=stage.current_stage.timer
    local owner,ctx=actors()
    local age=start and t-start or -1
    for _,o in ObjList(GROUP.ENEMY) do
        local s=o.mhj
        if s and s.familiar and s.age>=20 and s.age>(s.Mist and 15 or 0) and (s.alpha or 100)>99 then
            assert(o.colli,'使魔超过原作保护时间后仍未打开引擎受弹开关')
            checked.familiar=true
        end
    end
    if age==0 then
        assert(ctx and #ctx.actors==2,'未进入原作双 Boss 场景')
        for _,a in ipairs(ctx.actors) do
            local o=a.object
            assert(o.IsBoss and o.is_combat and o.colli,('副 Boss 标记错误：IsBoss=%s combat=%s colli=%s'):format(tostring(o.IsBoss),tostring(o.is_combat),tostring(o.colli)))
        end
    elseif age==41 or age==91 then
        local index=age==41 and 1 or 2
        assert(owner.hp<originalHP,'射击双 Boss 的第 '..index..' 个没有扣除共用血量')
        checked[index]=true
    elseif age==160 then
        local cap=p.mhj_source.lantern.BossDamageLimit
        local hp=owner.hp
        for _,a in ipairs(ctx.actors) do
            local o=a.object
            local s={controller={friendly={shoot={[0]=0,[1]=0,[2]=cap*2,Count=3}}},
                type=#TH39.runtime.data.bulletTypes+1,pattern={types={{0,0,20,20,10,10}}},
                fx=o.x*1.5+481,fy=360-o.y*1.5,alpha=100,layerid=0,parentid=0,wscale=1,hscale=1,head=0,Invincible=true}
            local b=New(ghost);TH39.runtime.playerWeaponHit(b,s);object.RawDel(b)
        end
        assert(hp>owner.hp and hp-owner.hp<=cap+.001,'双 Boss 未共用原 BossStage 的逐帧伤害上限')
        checked.limit=true
    end
end
function T.checkpoint()
    assert(checked[1] and checked[2] and checked.limit and checked.familiar,'双 Boss、使魔受弹与共用伤害上限未全部完成')
    lstg.SystemLog('SOURCE_LOGIC: 永夜双 Boss 两侧实体主炮命中、使魔受弹开关、共用血量与伤害上限通过')
end
return T
