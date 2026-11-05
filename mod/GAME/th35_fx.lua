-- TH10 263/264/272独立ANM；与259/262管理的本体槽分开，不替换角色行走图。
local H={}
local entries=dofile('mod/GAME/th35_effect_sources.lua')
local P=OriginalStageVisual.presentation
local function valid(o) return o and IsValid(o) and o.status~='del' and o.status~='kill' end
local function phase(o)
    local root=o.t10_root or o
    return o.th10_boss or root.th10_boss or root.t10_road_owner or root
end
function H.play(o,stage,bank,id,high)
    if type(id)~='number' or id<0 then return end
    local archive=bank==0 and 'bullet' or bank==1 and 'enemy' or ('stgenm%02d'):format(stage)
    local v=P.new_effect(10,archive,id,o.x,o.y,phase(o))
    v.layer=high and LAYER.ENEMY_BULLET_EF or LAYER.ENEMY-1
    return v
end
function H.fire(o,c,address)
    local e=assert(entries[c.key] and entries[c.key][address],'缺少原生独立ANM指令')
    if not e.repeatable and c.seen[address] then return end
    c.seen[address]=true
    local number=tonumber(c.key:match('stage(%d+)'))
    if e.op==264 then
        local archive=e.bank==0 and 'bullet' or e.bank==1 and 'enemy' or ('stgenm%02d'):format(number)
        P.new_effect(10,archive,e.script,-224,240,phase(o))
    else
        local v=H.play(o,number,e.bank,e.script,e.op==272)
        if v and e.op==273 then
            v.vm.rotation[3]=type(e.rotation)=='number' and e.rotation or math.atan2(o.ecs.vy or 0,o.ecs.vx or 0)
        end
    end
end
function H.context(key) return {key=key,seen={}} end
function H.shadow(o,stage,bank,script,period,high,initial_delay)
    local function draw()
        local id=type(script)=='function' and script(o) or script
        H.play(o,stage,bank,id,high)
    end
    -- TH10新异步线程不参与本拍快照，首个本地t0沿既有调度进入下一拍。
    task.New(o,function()
        if initial_delay and initial_delay>0 then task.Wait(initial_delay) end
        while valid(o) do draw();task.Wait(period or 1) end
    end)
end
local function maple_emit(o)
    local age=o.age
    if age<o.delay then return end
    age=age-o.delay
    local p=o.profile
    local id,period,offset=p.first,p.period,0
    if p.second then
        -- 78是后减；先输出count次first，再切到second（3366/4992拍）。
        local change=p.count*p.period
        if age>=change then id,period,offset=p.second,p.second_period,change end
    end
    if (age-offset)%period~=0 then return end
    -- 264不加敌机位置，脚本采用640×480屏幕坐标。
    local v=P.new_effect(10,'bullet',id,-224,240,o)
    v.layer=LAYER.BG+2
end
H.ambient=Class(object,{
    init=function(o,number,delay,owner)
        o.group,o.bound,o.colli=GROUP.GHOST,false,false
        o.stage_id,o.delay,o.age=number,delay or 0,0
        o.profile=entries._ambient[number]
        o.scene,o.scene_start=stage.current_stage,stage.current_stage.timer
        o.level=owner.class.StageLevel
        maple_emit(o)
    end,
    frame=function(o)
        local current=boss_group[1]
        if stage.current_stage~=o.scene or (o.scene.timer or 0)<o.scene_start
            or current and current.class.StageLevel~=o.level then P.clear(o);object.RawDel(o);return end
        o.age=o.age+1
        maple_emit(o)
    end,
},true)
function H.ensure(o,key,road)
    local number=tonumber(key:match('stage(%d+)'))
    if not number then return end
    local old=H.current
    if valid(old) and old.stage_id==number and old.scene==stage.current_stage
        and (old.scene.timer or 0)>=old.scene_start then return end
    if valid(old) then P.clear(old);object.RawDel(old) end
    H.current=New(H.ambient,number,road and number==1 and 2200 or 0,o)
end
function H.clear(o) P.clear(o) end
return H
