-- 低速满火力活跃TTK中位数；ECL执行窗口内恢复原作life，窗口外供框架扣换算后的血量。
-- TH11的七倍精度只属于执行spell指令的演员，不能像TH06一样给全场杂兵一起减伤。
local M=dofile('mod/GAME/original/th11_low_speed_hp.lua')
local bit=require('bit')
local phases={}
for _,entry in pairs(M.entries) do phases[entry.stage..':'..entry.sub]=entry end
local function clean(n)
    local i=math.floor(n+.5)
    return math.abs(n-i)<1e-8 and i or n
end
function M.raw(a)
    if a.session.hp_raw or not a.hp_exposed then return a.o.hp end
    return clean(a.o.hp/a.hp_scale+a.hp_baseline)
end
function M.maximum(a)
    return a.session.hp_raw and a.o.maxhp or a.hp_raw_max or a.o.maxhp
end
function M.phase(a,name)
    local entry=phases[a.session.stage..':'..name]
    if entry then a.hp_phase=entry end
end
function M.enter(s)
    if s.hp_raw then return false end
    for _,a in ipairs(s.actors) do
        if not a.dead and a.hp_exposed then
            a.o.hp=M.raw(a);a.o.maxhp=a.hp_raw_max
            a.hp_exposed=false
        end
    end
    s.hp_raw=true
    return true
end
function M.leave(s,owned)
    if owned==false then return end
    for _,a in ipairs(s.actors) do
        if not a.dead then
            local o=a.o
            local entry=a.practice and M.entries[a.practice.id] or a.hp_phase
            local baseline=0
            if a.is_boss or a.practice then
                for i=0,7 do local q=a.interrupts[i];if q and q.hp>=0 then baseline=q.hp;break end end
                if a.practice then baseline=a.practice.threshold end
            end
            -- 过渡子程序会先移除当前阈值；不能继续把上一张卡的分段比例套给下一槽。
            if entry and not a.practice and baseline~=entry.threshold then entry=nil end
            local rawmax=o.maxhp
            local raw=entry and entry.raw or math.max(0,rawmax-baseline)
            local spell=entry and entry.spell or a.hp_spell or false
            local scale=M.scale[spell and 'spell' or 'normal']
            if entry then scale=entry.survival and 1 or entry.hp/entry.raw
            elseif raw<=0 or rawmax>=999999 or bit.band(a.flags,0x20)~=0 then scale=1
            elseif a.is_boss then scale=math.max(1,math.floor(raw*scale+.5))/raw
            else scale=math.max(1,raw*scale)/raw end
            a.hp_scale,a.hp_baseline,a.hp_raw_max=scale,baseline,rawmax
            o.hp=math.max(0,(o.hp-baseline)*scale)
            o.maxhp=math.max(1,raw*scale)
            a.hp_exposed=true
        end
    end
    s.hp_raw=false
end
-- 弧形受击节点收集的是框架伤害；原作回调里的life扣减仍要回到原始单位。
function M.damage(a,damage) return damage/(a.hp_scale or 1) end
return M
