-- TH10 EnemyRuntimeUpdate：受弹、受伤、接触、隐藏与清场保护分别处理。
-- 接触框由手动判定维护，使flags1/2不再被LuaSTG的单一colli开关合并。
local H={}
local bit=bit or require('bit')
local entries=dofile('mod/GAME/th35_interaction_sources.lua')
local default_birth_guard=dofile('mod/GAME/th35_birth_guard.lua')
function H.flags(o,value,on)
    o.t10_flags=on and bit.bor(o.t10_flags or 0,value) or bit.band(o.t10_flags or 0,bit.bnot(value))
    o.t10_no_oob=bit.band(o.t10_flags,4)~=0
end
function H.init(o,key)
    if o.t10_interaction_key==key then return end
    o.t10_interaction_key=key
    o.t10_flags=o.t10_flags or 0
    o.t10_contact_timer=0
    if o.invuln~=nil and default_birth_guard[key] then
        o.invuln=2;o.protect=true
    end
    for _,event in ipairs(entries[key] or {}) do
        if event[1]==361 then o.t10_contact_timer=event[2]
        else H.flags(o,event[2],event[1]==322) end
    end
end
function H.wrap(cls)
    local init=cls.init
    cls.init=function(o,...)
        init(o,...)
        local source=o._original_source
        if source then H.init(o,source.key) end
    end
    cls[1]=cls.init
end
function H.frame(o)
    local target=o.th10_boss or o
    local flags=o.t10_flags or 0
    target._original_hidden=bit.band(flags,16)~=0
    if type(target.hp)=='number' then
        local accepts=bit.band(flags,17)==0
        target.group=GROUP.NONTJT
        target._colli=accepts
        SetAttr(target,'colli',accepts and BoxCheck(target,lstg.world.boundl,lstg.world.boundr,lstg.world.boundb,lstg.world.boundt))
        -- 保留项目伤害口径；flags8只控制是否扣血，不阻止子弹命中和消失。
        if target.t10_interaction_factor==nil then target.t10_interaction_factor=target.DMG_factor or 1 end
        target.DMG_factor=bit.band(flags,8)==0 and target.t10_interaction_factor or 0
        if not o.t10_ecl_birth and bit.band(flags,18)==0 and (o.t10_contact_timer or 0)<=0 then
            local box=target._original_contact_box or target._original_damage_box
            if box then
                local function contact(p)
                    if p and IsValid(p) and math.abs(p.x-target.x)<=box[1]/2+(p.A or p.a or 0)
                        and math.abs(p.y-target.y)<=box[2]/2+(p.B or p.b or 0) then p.class.colli(p,target) end
                end
                if GameNet then GameNet.forEachPlayer(contact) else contact(player) end
            end
        end
    end
    o.t10_contact_timer=math.max(0,(o.t10_contact_timer or 0)-1)
end
function H.kill_all_target(o)
    local flags=o.t10_flags or 0
    return bit.band(flags,0xc050)==0 or bit.band(flags,0x80)~=0
end
function H.release(b)
    b.group,b._colli=GROUP.ENEMY,true
    if b.t10_interaction_factor~=nil then b.DMG_factor=b.t10_interaction_factor;b.t10_interaction_factor=nil end
    b._original_hidden=false
end
return H
