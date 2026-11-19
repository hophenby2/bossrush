-- 原 Barrage.Judge 的命中顺序、镜像边界和非 Bomb 的逐帧伤害上限。
local T={};local checked={}
local base=Class(object,{take_damage=function(o,n) o.hp=o.hp-n end})
local fixture=Class(base,{
    init=function(o,boss)
        o.x,o.y,o.a,o.b=0,100,10,10
        o.group,o.colli,o.bound,o.hide=GROUP.ENEMY,true,false,true
        o.hp,o.maxhp=1000000,1000000
        o.IsBoss,o.is_combat=boss,boss
        if boss then o.current_card={nativeBombFactor=1} end
    end,
},true)
local ghost=Class(object,{init=function(o) o.group,o.colli,o.bound,o.hide=GROUP.GHOST,false,false,true end},true)
local boss,enemy,level,R
local function hit(amount,invincible,bomb,mirror)
    local night=level==37
    local fx={shoot=night and {[0]=0,[1]=0,[2]=amount,Count=3} or {[0]=0,[1]=amount,Count=2},bomb=bomb}
    local s={controller={friendly=fx},type=night and #R.data.bulletTypes+1 or 229,
        pattern={types={{0,0,20,20,10,10}}},fx=night and 481 or 317,fy=night and 210 or 127,
        alpha=100,layerid=0,parentid=0,wscale=mirror and -1 or 1,hscale=1,head=0,Invincible=invincible}
    R.playerWeaponHit(New(ghost),s)
end
function T.before(p)
    level=p.native_level;R=(level==37 and TH39 or TH37).runtime
    local key=AndroidInput.keys
    key[setting.keys.shoot],key[setting.keys.spell]=false,false
    local t=stage.current_stage.timer
    if t==5 then p.protect=100000 end
    if t==10 then boss=New(fixture,true);enemy=New(fixture,false) end
    if t==13 then object.RawDel(enemy) end
end
function T.after(p)
    local t=stage.current_stage.timer
    if t==12 then
        hit(10,false,false)
        assert(enemy.hp==999990 and boss.hp==1000000,'特效武器先命中敌机后仍命中了 Boss')
        checked.order=true
    elseif t==14 then
        local hp=boss.hp
        if level==37 then
            local cap=p.mhj_source.lantern.BossDamageLimit
            assert(cap>0 and cap<1000000,'测试伤害上限无效')
            hit(cap*2,true,false);hit(cap*2,true,false)
            assert(math.abs(hp-boss.hp-cap)<.001,'普通特效武器没有共享每帧伤害上限')
        end
        checked.cap=true
    elseif t==15 then
        local hp=boss.hp;hit(10,true,true);hit(10,true,true)
        assert(hp-boss.hp==20,'Bomb 错误使用了普通武器伤害上限');checked.bomb=true
    elseif t==16 then
        local hp=boss.hp;hit(10,true,true,true)
        assert(hp-boss.hp==(level==37 and 10 or 0),'特效武器镜像判定与原作不符')
        checked.mirror=true;object.RawDel(boss)
    end
end
function T.checkpoint()
    assert(checked.order and checked.cap and checked.bomb and checked.mirror)
    lstg.SystemLog('SOURCE_LOGIC: 幕华祭特效武器命中顺序、镜像和伤害上限通过')
end
return T
