-- 真实六面光背，另保留宿主载体以重现混用全局索敌列表的问题。
local T={}
local checked={}
local foreign=Class(object,{init=function(o,p)
    o.x,o.y=p.x,p.y+10;o.a,o.b=1,1
    o.group,o.colli,o.bound,o.hide=GROUP.ENEMY,true,false,true
    o.hp,o.maxhp=1e9,1e9;o._sequence_road_carrier=true
end},true)
local carrier,receiver,beforeHP,lastReceiver,stable
function T.before(p)
    local t=stage.current_stage.timer
    AndroidInput.keys[setting.keys.slow]=true
    AndroidInput.keys[setting.keys.shoot]=t>400
    AndroidInput.keys[setting.keys.spell]=false
    p.protect=100000
    if t==5 then carrier=New(foreign,p) end
    receiver=nil
    for _,o in ObjList(GROUP.NONTJT) do if o.Isbacklight then
        if IsValid(o.mst) then
            o.mst.hp=10000000
            beforeHP=o.mst.hp
            if o.colli then receiver=o end
        end
    end end
    if carrier then carrier.x,carrier.y=p.x,p.y+10 end
    stable=receiver and receiver==lastReceiver
    lastReceiver=receiver
end
function T.after(p)
    if stable then
        assert(p.target_slow==receiver,'紫锁定了宿主载体或本体，没有锁定可受击的光背')
        checked.lock=true
        if stage.current_stage.timer>420 and receiver.mst.hp<beforeHP then checked.damage=true end
    end
end
function T.checkpoint()
    assert(checked.lock and checked.damage,'光背稳定锁定与伤害转移未全部发生')
    if carrier and IsValid(carrier) then object.RawDel(carrier) end
    lstg.SystemLog('SOURCE_LOGIC: 六面光背受击切换、紫锁定与主人伤害转移通过')
end
return T
