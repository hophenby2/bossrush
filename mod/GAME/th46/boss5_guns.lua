-- 第五面 Original 三十槽炮台；c077d30 在主任务之后、演出之前按槽下标扫描。
-- 参数、句柄与移动/主任务/演出共用；结束来自原计数及状态，不能预填寿命。
-- 出膛参数交给原生弹工厂；图形、弹运动及场景队列未就绪前不接正式关卡。
local object=object
local parameters=dofile('mod/GAME/th46/parameters.lua')
local handles=dofile('mod/GAME/th46/boss5_handles.lua')
local direction=dofile('mod/GAME/th46/direction.lua')
local min,max=math.min,math.max
local source,handlers={},{}
local Slot,Manager
local function observe(o,kind,args,result)
    if o.manager.api.observe then o.manager.api.observe(o.host,kind,args,result,o)end
    return result
end
local function invoke(o,kind,...)
    local args={...}
    return observe(o,kind,args,assert(o.manager.api.invoke,'第五面炮台缺少原生工厂：'..kind)(o.host,kind,args,o))
end
local function register(name,entry,handler)source[name]=entry;handlers[name]=handler end
local function closeSlot(o)
    if rawget(o,'closed')then return end
    o.closed=true;parameters.release(o.block)
    if o.manager.slots[o.index]==o then o.manager.slots[o.index]=nil end
    object.RawDel(o)
end
local function remove(o)observe(o,'remove',{});closeSlot(o)end
local function allocate(o,size)
    assert(not o.block,'第五面炮台重复分配参数')
    o.block=assert(parameters.allocate(o.manager.pool,size),'第五面炮台参数池已满')
    -- 第二段末尾先释放槽再写旧参数指针；仍指向同一池字节，不能重新占用它。
    o.pointer={pool=o.block.pool,index=o.block.index,count=o.block.count,closed=false}
end
local function switch(o,mode)o.mode=mode;observe(o,'switch',{mode})end
local function tick(v,a)v[a]=v[a]-1;return v[a]end
local function random(o,n)
    local value=invoke(o,'random',n)
    assert(type(value)=='number'and value>=0 and value<=n and value==math.floor(value),'第五面炮台随机数越界')
    return value
end
local function aim(o,x,y)
    local input=assert(o.host.motionInput,'第五面炮台缺少本步自机输入')
    local active=input[5]
    assert(active~=nil,'第五面炮台缺少自机存活标志')
    local angle=active~=false and active~=0 and direction.heading(x,y,input[3],input[4])or 256
    return observe(o,'aim',{x,y},angle)
end
local function turn(target,current,amount)
    return(current+max(-amount,min(amount,(target-current+256)%512-256)))%512
end
local function fan(o,kind,x,y,speed,angle,count,step,flag)
    invoke(o,'fan',kind,x,y,speed,angle,count,step,flag or 0)
end
local function bullet(o,kind,x,y,speed,angle,flag)
    invoke(o,'bullet',kind,x,y,speed,angle,flag or 0)
end
local function spawn(o,entry,...)return invoke(o,'spawn','task',entry,...)end
local context={register=register,allocate=allocate,switch=switch,remove=remove,invoke=invoke,
    observe=observe,tick=tick,random=random,aim=aim,turn=turn,fan=fan,bullet=bullet,spawn=spawn,
    vector=direction.vector,heading=direction.heading,parameters=parameters}
dofile('mod/GAME/th46/boss5_guns_first.lua')(context)
dofile('mod/GAME/th46/boss5_guns_second.lua')(context)
dofile('mod/GAME/th46/boss5_guns_third.lua')(context)
Slot=Class(object,{
    init=function(o,manager,mode,index,handle,config)
        o.manager,o.host,o.run,o.index=manager,manager.host,manager.run,index
        o.mode,o.handle,o.config,o.closed=mode,handle,config,false
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
        o.vars=setmetatable({},{
            __index=function(_,a)return parameters.read(assert(o.pointer),a,4)end,
            __newindex=function(_,a,n)parameters.write(assert(o.pointer),a,4,n)end,
        })
    end,
    frame=function()end,
})
local function add(manager,mode,config)
    if type(mode)=='number'then
        local name
        for k,v in pairs(source)do if v==mode then name=k;break end end
        mode=assert(name,'第五面炮台入口未移植：'..string.format('%x',mode))
    end
    assert(source[mode],'第五面炮台入口未移植：'..tostring(mode))
    for i=1,30 do
        if not manager.slots[i]then
            if config then manager.configs[i]={unpack(config)}end
            local o=New(Slot,manager,mode,i,handles.next(manager.host),manager.configs[i]or{})
            manager.slots[i]=o;return o.handle,o
        end
    end
    return 0
end
local function stepSlot(o)
    if rawget(o,'closed')then return end
    local api=o.manager.api
    if api.beforeSlot then api.beforeSlot(o.host,o)end
    assert(handlers[o.mode],'第五面炮台执行入口未移植')(o,o.vars,o.host.raw)
    if api.afterSlot then api.afterSlot(o.host,o)end
end
local function clear(manager)
    for i=1,30 do if manager.slots[i]then closeSlot(manager.slots[i])end end
end
Manager=Class(object,{
    init=function(o,host,api)
        assert(not host.gunGroup,'第五面只能有一份炮台管理器')
        o.host,o.run,o.api,o.slots,o.configs=host,host.run,api or{},{},{}
        o.pool=host.nativeParameters or parameters.create();host.nativeParameters=o.pool
        o.serial,o.closed=host.run.serial,false
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
        host.gunGroup=o
    end,
    frame=function()end,
})
return{source=source,context=context,parameters=parameters,add=add,stepSlot=stepSlot,clear=clear,
    create=function(host,api)return New(Manager,host,api)end,
    alive=function(manager,handle)
        for i=1,30 do local o=manager.slots[i];if o and o.handle==handle then return true end end
        return false
    end,
    step=function(manager)
        if rawget(manager,'closed')or manager.serial==manager.run.serial then return end
        manager.serial=manager.run.serial
        for i=1,30 do if manager.slots[i]then stepSlot(manager.slots[i])end end
    end,
    close=function(manager)
        if not manager or rawget(manager,'closed')then return end
        manager.closed=true;clear(manager)
        if manager.host.gunGroup==manager then manager.host.gunGroup=nil end
        object.RawDel(manager)
    end,
}
