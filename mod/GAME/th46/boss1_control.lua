-- 第一面关底 Original 的入场及 c151610、c1516e0、c151740 三组攻击调度。
-- 五个主任务槽按下标更新：新任务占据后面的空槽时当步执行，占据前面的空槽时等下一步。
-- 发弹、特效和演出子任务经具名接口挂载，必须提供真实的存活查询；不能以录制时刻代替等待。
-- 差异 1：随机数经挂载接口提供，原版与粒子共用的随机序列尚未接入；回归代入原版返回值。
-- 换段及最终击破控制器仍待补齐，此模块尚未接管练习入口中的采样关底。
-- api.invoke(host,kind,args,slot)：spawn 返回子对象或 0，alive 返回布尔值；其余接口见具名调用。
-- 子任务可越过一个攻击循环存活；api.close 在整个管理器关闭时统一释放它们。
local object=object
local unit=65536
local firstWait,burstWait,sideWait,returnWait=24,96,16,128
local source={entry_init=0xc14fe20,entry=0xc14fbf0,
    pattern_init=0xc151610,pattern=0xc151880,leap_init=0xc1516e0,leap=0xc151ba0,
    wide_init=0xc151740,wide=0xc151d50}
local handlers={}
local Slot,Manager

local function closeSlot(o)
    if o.closed then return end
    o.closed=true
    if o.manager.slots[o.index]==o then o.manager.slots[o.index]=nil end
    object.RawDel(o)
end
local function add(manager,mode)
    assert(source[mode],'关底主任务入口未移植：'..tostring(mode))
    for i=1,5 do
        if not manager.slots[i]then
            local o=New(Slot,manager,mode,i)
            manager.slots[i]=o
            return o
        end
    end
    return 0
end
local function invoke(o,kind,...)
    local args={...}
    local manager=o.manager
    local result
    if kind=='control'then result=add(manager,args[1])
    elseif kind=='remove'then closeSlot(o)
    elseif kind=='random'and not manager.api.invoke then result=ran:Int(0,args[1])
    else
        result=assert(manager.api.invoke,'关底主任务缺少原生子任务接口')(o.host,kind,args,o)
    end
    if manager.api.observe then manager.api.observe(o.host,kind,args,result,o)end
    return result
end
local function spawn(o,kind,...)
    local result=invoke(o,'spawn',kind,...)
    assert(result~=nil,'关底子任务必须返回对象或分配失败的 0')
    return result
end
local function random(o,n)return invoke(o,'random',n)end
local function alive(o,pool,handle)
    local value=invoke(o,'alive',pool,handle)
    assert(type(value)=='boolean','关底存活查询必须返回布尔值，Lua 中数字 0 也是真')
    return value
end
local function motion(o,method,mode,...)
    invoke(o,'motion',method,mode,...)
end
local function pose(o,mode,wait)
    o.host.raw[88]=mode
    invoke(o,'pose',mode,wait)
end
local function switch(o,mode)o.mode=mode end
local function finish(o,following)
    invoke(o,'control',following)
    invoke(o,'remove')
end
local function jump(o)
    o.host.raw[24],o.host.raw[20]=1,5*unit
    invoke(o,'jump')
end
local function stepSlot(o)
    if o.closed or o.serial==o.run.serial then return end
    o.serial=o.run.serial
    if o.manager.api.beforeSlot then o.manager.api.beforeSlot(o.host,o)end
    handlers[o.mode](o,o.vars,o.host.raw)
    if o.manager.api.afterSlot then o.manager.api.afterSlot(o.host,o)end
end

handlers.entry_init=function(o,v)
    v[0],v[4]=0,0
    switch(o,'entry')
end
handlers.entry=function(o,v,b)
    if v[0]==0 then
        v[4]=v[4]-1
        if v[4]>=0 then return end
        invoke(o,'signal','boss_scene',1)
        invoke(o,'signal','open_view')
        invoke(o,'signal','clear_footprints')
        v[8]=spawn(o,'enter_pose')
        motion(o,'ensure','simple_init')
        v[0],v[4]=1,0
    elseif v[0]==1 then
        if alive(o,'task',v[8])then return end
        b[28],b[32]=16,0
        motion(o,'ensure','move_init',4,120*unit,360*unit)
        pose(o,8,16)
        invoke(o,'signal','stage_scroll',1)
        v[0],v[4]=10,returnWait
    elseif v[0]==10 then
        v[4]=v[4]-1
        if v[4]>=0 then return end
        v[8]=spawn(o,'enter_flash')
        invoke(o,'signal','boss_scene',2)
        invoke(o,'signal','activate_boss',1)
        invoke(o,'signal','enable_collision',true)
        v[0],v[4]=20,0
    elseif v[0]==20 then
        if alive(o,'task',v[8])then return end
        assert(b[40]==0,'主任务目前只支持 Original')
        finish(o,'pattern_init')
    end
end

local function initPattern(o,v,b,wide)
    v[0],v[4],v[8]=0,0,2
    v[16],v[20],v[24],v[28]=wide and 64 or 32,64,2,16
    v[40],v[44]=wide and 80 or sideWait,wide and 32 or 0
    if wide then switch(o,'wide');return end
    b[0x233c]=(b[0x233c]+1)%2
    motion(o,'ensure','move_init',2,120*unit,360*unit)
    spawn(o,'tilt',random(o,1)+1,0)
    switch(o,'pattern')
end
handlers.pattern_init=function(o,v,b)initPattern(o,v,b,false)end
handlers.wide_init=function(o,v,b)initPattern(o,v,b,true)end

handlers.pattern=function(o,v,b)
    if v[0]==0 then
        v[4]=v[4]-1
        if v[4]>0 then return end
        v[32]=spawn(o,'head')
        v[0],v[4]=10,firstWait
    elseif v[0]==10 then
        if v[4]~=0 then
            v[4]=v[4]-1
            if v[4]<=0 then v[4]=0;spawn(o,'tilt',random(o,1)+1,0)end
            return
        end
        v[16]=v[16]-1
        if v[16]>=0 then return end
        v[16]=v[20]
        local count,interval=v[24],v[28]
        v[24],v[28]=4,12
        v[12]=spawn(o,'burst',count,interval)
        v[0],v[4]=20,0
    elseif v[0]==20 then
        if alive(o,'gun',v[12])then return end
        v[8],v[0],v[4]=v[8]-1,10,burstWait
        if v[8]>0 then
            spawn(o,'pose_left');spawn(o,'pose_right')
            spawn(o,'side',32,2,0,8)
        else v[0],v[4],v[8]=30,0,0 end
    elseif v[0]==30 then
        v[40]=v[40]-1
        if v[40]>=0 then return end
        v[40]=v[44]
        spawn(o,'pose_left');spawn(o,'pose_right')
        v[36]=spawn(o,'side',0,6,4,6)
        motion(o,'replace','move_init',0,(b[0x233c]~=0 and 200 or 40)*unit,340*unit)
        v[0],v[4]=40,0
        invoke(o,'stop',v[32],1)
    elseif v[0]==40 then
        if not alive(o,'gun',v[36])then v[0],v[4]=50,0 end
    elseif v[0]==50 then
        if v[4]~=0 then
            v[4]=v[4]-1
            if v[4]<=0 then v[0],v[4]=10,0 end
            return
        end
        invoke(o,'control','leap_init')
        b[0x2340]=1
        spawn(o,'tilt',random(o,1)+1,0)
        invoke(o,'remove')
    end
end

handlers.leap_init=function(o,v)
    v[0],v[4],v[8]=0,1,2
    switch(o,'leap')
end
handlers.leap=function(o,v,b)
    if v[0]==0 then
        if v[4]~=0 then
            v[4]=v[4]-1
            if v[4]<=0 then v[4]=0 end
            return
        end
        v[0],v[4]=10,64
        pose(o,0,0)
        spawn(o,'leap_smoke')
    elseif v[0]==10 then
        if v[4]~=0 then
            v[4]=v[4]-1
            if v[4]>0 then return end
            v[4]=0
            spawn(o,'leap_gun',2)
            motion(o,'replace','move_init',4,(b[0x233c]~=0 and 20 or 220)*unit,360*unit)
            jump(o)
        elseif b[24]==0 then
            v[0],v[4]=20,64
            spawn(o,'tilt',random(o,1)+1,32)
        end
    elseif v[0]==20 then
        if v[4]~=0 then
            v[4]=v[4]-1
            if v[4]<=0 then v[4]=0 end
            return
        end
        pose(o,8,0)
        finish(o,'wide_init')
    end
end

handlers.wide=function(o,v,b)
    if v[0]==0 then
        v[4]=v[4]-1
        if v[4]>0 then return end
        v[32]=spawn(o,'wide_gun',b[0x233c])
        v[0],v[4]=10,burstWait
        motion(o,'replace','move_init',0,120*unit,280*unit)
    elseif v[0]==10 then
        if alive(o,'gun',v[32])then return end
        spawn(o,'reset_pose')
        v[0],v[4]=20,returnWait
        motion(o,'ensure','move_init',1,120*unit,360*unit)
    elseif v[0]==20 then
        if v[4]~=0 then
            v[4]=v[4]-1
            if v[4]<=0 then v[4]=0 end
            return
        end
        finish(o,'pattern_init')
    end
end

Slot=Class(object,{
    init=function(o,manager,mode,index)
        o.manager,o.host,o.run,o.index=manager,manager.host,manager.run,index
        o.mode,o.closed,o.serial=mode,false,-1
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
        o.vars={};for at=0,76,4 do o.vars[at]=0 end
    end,
    -- 统一由管理对象扫描槽位；不能再让引擎按对象出生顺序重复执行一次。
    frame=function()end,
})
local function step(manager)
    if manager.closed or manager.serial==manager.run.serial then return end
    manager.serial=manager.run.serial
    for i=1,5 do
        local o=manager.slots[i]
        if o then stepSlot(o)end
    end
end
Manager=Class(object,{
    init=function(o,host,api)
        assert(not host.controlGroup,'关底只能有一份主任务管理器')
        o.host,o.run,o.api,o.slots=host,host.run,api or {},{}
        o.serial,o.closed=host.run.serial,false
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
        host.controlGroup=o
    end,
    frame=step,
})
return {
    source=source,
    fields={40,20,24,28,32,88,0x233c,0x2340},
    create=function(host,api,mode)
        local manager=New(Manager,host,api)
        add(manager,mode or'entry_init')
        return manager
    end,
    step=step,
    close=function(o)
        if not o or o.closed then return end
        o.closed=true
        for i=1,5 do if o.slots[i]then closeSlot(o.slots[i])end end
        if o.api.close then o.api.close(o.host)end
        if o.host.controlGroup==o then o.host.controlGroup=nil end
        object.RawDel(o)
    end,
}
