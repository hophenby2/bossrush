-- 日文1.00a的BeginSpell(0x40c650)和DrawSpellBackground(0x40c4a0)：
-- 两个背景VM按顺序绘制，只由ANM控制60帧淡入、旋转、UV、顶点色与混合。
-- 原版EndSpell(0x40cd60)清active位，背景立即停画，没有额外淡出或interrupt。
-- 六面／EX原版以MSG序号>=24区分中Boss；本项目略过MSG，等价地用原生符卡号区分。
local H,class=...
local A,object=OriginalANM,object
local presets={
    [1]={7,8,10},[2]={7,8,10},[3]={8,9,11},[4]={12,13,15},[5]={16,17,19},
}
function H.background_scripts(stage,id)
    if stage==6 then return id<142 and {21,22,23} or {18,17,20} end
    if stage==7 then return id<165 and {7,8,10} or {11,12,13} end
    local p=assert(presets[stage])
    local portrait=p[3]
    if stage==1 and id<2 then portrait=11 end
    if stage==5 and id<122 then portrait=false end
    return {p[1],p[2],portrait}
end
class.spell_background=Class(object,{
    init=function(o,s,ids)
        o.session=s;o.born=s.frame;o.vms={}
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.BG+1,false,false
        local file=('stgenm%02d'):format(s.stage)
        for i=1,2 do o.vms[i]=A.new(11,file,ids[i]) end
    end,
    frame=function(o) if o.session.done then object.RawDel(o) end end,
    render=function(o)
        SetViewMode('world')
        -- ANM用640×480屏幕坐标，(224,240)对应本项目场地中心(0,0)。
        for _,vm in ipairs(o.vms) do A.draw(vm,-224,240) end
    end,
},true)
class.spell_portrait=Class(object,{
    init=function(o,s,id)
        o.session=s;o.born=s.frame;o.vm=A.new(11,('stgenm%02d'):format(s.stage),id)
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY+1,false,false
    end,
    frame=function(o) if o.session.done then object.RawDel(o) end end,
    render=function(o) A.draw(o.vm,-224,240) end,
},true)
function H.end_background(s)
    if s.spell_background and IsValid(s.spell_background) then object.RawDel(s.spell_background) end
    s.spell_background=nil
end
function H.start_background(a,id)
    local s=a.session;H.end_background(s)
    local ids=H.background_scripts(s.stage,id)
    s.spell_background=New(class.spell_background,s,ids)
    s.effects[#s.effects+1]=s.spell_background
    if ids[3] then
        local portrait=New(class.spell_portrait,s,ids[3])
        s.effects[#s.effects+1]=portrait
    end
end
function H.step_backgrounds(s)
    for _,o in ipairs(s.effects) do
        if IsValid(o) and o.born and o.born~=s.frame then
            if o.vms then for _,vm in ipairs(o.vms) do A.step(vm) end
            elseif o.vm then
                A.step(o.vm)
                if o.vm.finished and not o.vm.visible then object.RawDel(o) end
            end
        end
    end
end
