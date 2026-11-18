-- 第五面关底的二十槽演出任务，按 c077d30 在主任务、炮台之后扫描。
-- 身体动画读写原偏移；改动作、换段或清槽后，旧控制器必须实际结束，不能代填等待时间。
-- 参数池释放保留旧字节，槽配置在空指针重用时也保留；句柄与其它任务共用 16 位计数器。
-- 粒子、碎片、绘图层、武器与场景队列仍由具名工厂提供；本模块尚未接入正式关卡。
local object=object
local parameters=dofile('mod/GAME/th46/parameters.lua')
local handles=dofile('mod/GAME/th46/boss5_handles.lua')
local source,handlers={},{}
local Slot,Manager
local function register(name,address,handler)
    source[name]=address;handlers[name]=handler
end
local function observe(o,kind,args,result)
    local api=o.manager.api
    if api.observe then api.observe(o.host,kind,args,result,o)end
    return result
end
local function invoke(o,kind,...)
    local args={...}
    return observe(o,kind,args,assert(o.manager.api.invoke,'第五面演出缺少原生效果接口：'..kind)(o.host,kind,args,o))
end
local function random(o,n)
    local value=invoke(o,'random',n)
    assert(type(value)=='number'and value>=0 and value<=n and value==math.floor(value),
        '第五面演出随机数越界')
    return value
end
local function closeSlot(o)
    if rawget(o,'closed')then return end
    o.closed=true;parameters.release(o.block)
    if o.manager.slots[o.index]==o then o.manager.slots[o.index]=nil end
    object.RawDel(o)
end
local function remove(o)observe(o,'remove',{});closeSlot(o)end
local function allocate(o,size)
    assert(not o.block,'第五面演出重复分配私有参数')
    o.block=assert(parameters.allocate(o.manager.pool,size),'第五面演出参数池已满')
end
local function switch(o,mode)
    assert(source[mode],'第五面演出入口未实现：'..tostring(mode))
    o.mode=mode;observe(o,'switch',{mode})
end
local function add(manager,mode,config)
    if type(mode)=='number'then
        local name
        for k,v in pairs(source)do if v==mode then name=k;break end end
        mode=assert(name,'第五面演出入口未移植：'..string.format('%x',mode))
    end
    assert(source[mode],'第五面演出入口未移植：'..tostring(mode))
    for i=1,20 do
        if not manager.slots[i]then
            if config then
                manager.configs[i]={unpack(config)}
            end
            local o=New(Slot,manager,mode,i,handles.next(manager.host),manager.configs[i]or{})
            manager.slots[i]=o
            return o.handle,o
        end
    end
    return 0
end
local function spawn(o,entry,...)
    local config={...}
    local handle=add(o.manager,entry,#config>0 and config or nil)
    return observe(o,'spawn',{'task',entry,unpack(config)},handle)
end
local function alive(manager,handle)
    for i=1,20 do local o=manager.slots[i];if o and o.handle==handle then return true end end
    return false
end
local function query(o,handle)
    return observe(o,'alive',{'task',handle},alive(o.manager,handle))
end
local function tick(v,a)v[a]=v[a]-1;return v[a]end

-- 同一关节的互斥状态决定控制器寿命；部分伸展先减速，再固定到最后一帧。
do
    local init={
        head_up_init={0xc1bc5a0,0x1e18,1,2,'head_up','zero'},
        head_down_init={0xc1bc620,0x1e18,3,2,'head_down','zero'},
        left_up_init={0xc1bc6a0,0x2010,1,1,'arm_up','zero'},
        right_up_init={0xc1bc710,0x2064,1,1,'arm_up','zero'},
        left_down_init={0xc1bc780,0x2010,3,2,'arm_down','zero'},
        right_down_init={0xc1bc800,0x2064,3,2,'arm_down','zero'},
        core_open_init={0xc1bc880,0x21b4,3,2,'core_open','two'},
        core_close_init={0xc1bc900,0x21b4,5,2,'core_close','two'},
        left_restore_init={0xc1bc980,0x1c20,1,2,'restore','one'},
        right_restore_init={0xc1bca00,0x1c74,1,2,'restore','one'},
        body_restore_init={0xc1bca80,0x1bcc,1,2,'body_restore','one'},
        joint_up_init={0xc1bcb00,0x1d1c,1,2,'joint_up','one'},
        pose_init={0xc1bcde0,0x2304,1,2,'pose','one'},
        pose_reset_init={0xc1bcea0,0x2304,3,2,'pose_reset','three'},
        damage_init={0xc1bcf20,0x2304,4,2,'damage','four'},
        damage_slow_init={0xc1bcfa0,0x2304,4,3,'damage_slow','four'},
        defeat_init={0xc1bd020,0x2304,6,3,'defeat','six'},
    }
    local resets={zero=0,one=1,two=2,three=3,four=4,six=6}
    for name,r in pairs(init)do
        register(name,r[1],function(o,v,b)
            allocate(o,16);v[4]=r[2]
            local previous=b[r[2]+68]
            if (r[6]=='zero'or r[6]=='two')and previous==resets[r[6]]
                or(r[6]~='zero'and r[6]~='two')and previous~=resets[r[6]]then b[r[2]]=0 end
            b[r[2]+68]=r[3];v[8],v[12]=r[4],r[4]
            if name=='pose_init'then
                if b[0x2638]==0 then invoke(o,'service',0xc1109f0)end
                if b[0x2638]==1 then invoke(o,'service',0xc1109d0)end
            end
            switch(o,r[5])
        end)
    end
    local frames={
        head_up={0xc1bde60,1,1,15,15,2},head_down={0xc1bdee0,3,-1,0,0,0},
        arm_up={0xc1bdf60,1,1,15,15,2},arm_down={0xc1be000,3,-1,0,0,0},
        core_open={0xc1be080,3,1,11,11,4},core_close={0xc1be110,5,-1,0,0,2},
        restore={0xc1be190,1,1,15,15,2},body_restore={0xc1be210,1,1,11,11,2},
        joint_up={0xc1be2b0,1,1,23,23,2},pose={0xc1be470,1,1,8,0,2},
        pose_reset={0xc1be4f0,3,1,4,0,0},damage={0xc1be570,4,1,16,0,0},
        damage_slow={0xc1be5f0,4,1,16,0,5},defeat={0xc1be670,6,1,8,0,7},
    }
    for name,r in pairs(frames)do
        register(name,r[1],function(o,v,b)
            local a=v[4]
            if b[a+68]~=r[2]then remove(o);return end
            if tick(v,8)>0 then return end
            v[8]=v[12]
            if name=='arm_up'then
                if b[a]>8 then v[8]=v[8]+1 end
                if b[a]>11 then v[8]=v[8]+1 end
            end
            b[a]=b[a]+r[3]
            if r[3]==1 and b[a]<r[4]or r[3]==-1 and b[a]>r[4]then return end
            b[a],b[a+68]=r[5],r[6]
            if name=='body_restore'then b[0x1bbc]=1 end
            remove(o)
        end)
    end
end
do
    local alpha,decay=255,8
    local function flash(o,_,b)
        b[0x262c]=alpha
        if o.mode=='flash_init'then b[0x2630]=0xffffff end
        invoke(o,'layer',o.mode=='flash_init'and 0xc1b46b0 or 0xc1b4610)
        switch(o,'flash')
    end
    register('flash_init',0xc1bc4f0,flash)
    register('flash_resume',0xc1bc550,flash)
    register('flash',0xc1bde00,function(o,_,b)
        b[0x262c]=b[0x262c]-decay
        if b[0x262c]>0 then return end
        b[0x262c]=0;invoke(o,'layer',0xc1b4630);remove(o)
    end)
end

-- 较长的入场、离体零件和场景时间线另外注册，保持槽、参数和结束条件同源。
local context={register=register,allocate=allocate,switch=switch,remove=remove,
    invoke=invoke,spawn=spawn,alive=query,tick=tick,random=random}
dofile('mod/GAME/th46/boss5_task_parts.lua')(context)
dofile('mod/GAME/th46/boss5_task_entry.lua')(context)

Slot=Class(object,{
    init=function(o,manager,mode,index,handle,config)
        o.manager,o.host,o.run,o.index=manager,manager.host,manager.run,index
        o.mode,o.handle,o.config,o.closed=mode,handle,config,false
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
        o.vars=setmetatable({},{
            __index=function(_,a)return parameters.read(assert(o.block),a,4)end,
            __newindex=function(_,a,n)parameters.write(assert(o.block),a,4,n)end,
        })
    end,
    frame=function()end,
})
local function stepSlot(o)
    if rawget(o,'closed')then return end
    local api=o.manager.api
    if api.beforeSlot then api.beforeSlot(o.host,o)end
    handlers[o.mode](o,o.vars,o.host.raw)
    if api.afterSlot then api.afterSlot(o.host,o)end
end
local function step(manager)
    if rawget(manager,'closed')or manager.serial==manager.run.serial then return end
    manager.serial=manager.run.serial
    for i=1,20 do
        local o=manager.slots[i]
        if o then
            stepSlot(o)
        end
    end
end
local function clear(manager)
    for i=1,20 do if manager.slots[i]then closeSlot(manager.slots[i])end end
end
Manager=Class(object,{
    init=function(o,host,api)
        assert(not host.taskGroup,'第五面只能有一份演出管理器')
        o.host,o.run,o.api,o.slots,o.configs=host,host.run,api or{},{},{}
        o.pool=host.nativeParameters or parameters.create();host.nativeParameters=o.pool
        o.serial,o.closed=host.run.serial,false
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
        host.taskGroup=o
    end,
    frame=function()end,
})
return{source=source,context=context,parameters=parameters,
    create=function(host,api)return New(Manager,host,api)end,
    add=add,step=step,stepSlot=stepSlot,clear=clear,alive=alive,
    close=function(manager)
        if not manager or rawget(manager,'closed')then return end
        manager.closed=true;clear(manager)
        if manager.host.taskGroup==manager then manager.host.taskGroup=nil end
        object.RawDel(manager)
    end,
}
