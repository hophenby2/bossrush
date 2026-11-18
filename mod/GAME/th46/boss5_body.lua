-- 第五面关底 Original 本体；0x0c1b0290 先清零，0x0c075cc0 再覆盖为根对象出生坐标。
-- 实际 0xD9 的指令坐标为 (0,0)，不能把构造器中途的 (120-camera,500) 当作最终出生位置。
-- 根对象、管理器和判定管理器的四个地址字段由原生对象关系持有，不把模拟器指针带入游戏。
local core=dofile('mod/GAME/th46/boss5_core.lua')
local motion=dofile('mod/GAME/th46/boss5_motion.lua')
local control=dofile('mod/GAME/th46/boss5_control.lua')
local guns=dofile('mod/GAME/th46/boss5_guns.lua')
local tasks=dofile('mod/GAME/th46/boss5_tasks.lua')
local bulletFactory=dofile('mod/GAME/th46/boss5_bullet_factory.lua')
local object=object
local floor,unit=math.floor,65536
local close
local function bind(api)
    api=api or {}
    local bound={}
    for k,v in pairs(api)do bound[k]=v end
    bound.invoke=function(owner,kind,args,slot)
        if kind=='collision'then return core.enable(owner,args[1])
        elseif kind=='box'then return core.setBox(owner,args[1],args[2])
        elseif kind=='hit_effect'then owner.boxes[args[1]].hitEffect=args[2];return
        elseif kind=='root_field96'then owner.rootFlag96=args[1];return
        elseif kind=='retire'then owner.retireRequested=true;return
        elseif kind=='motion_is'then return owner.motion~=nil and owner.motion.mode==args[1]
        elseif kind=='motion'then
            local method,mode,config=args[1],args[2],{unpack(args,3)}
            if not owner.motion then return motion.create(owner,mode,config,api.random)end
            if method=='ensure'then return motion.ensure(owner.motion,mode,config)end
            assert(method=='replace','第五面移动挂载方式无效')
            return motion.switch(owner.motion,mode,config)
        elseif kind=='random'then
            return api.random and api.random(args[1])or ran:Int(0,args[1])
        elseif owner.bulletFactory and(kind=='bullet'or kind=='fan')then
            return bulletFactory.enqueue(owner.bulletFactory,kind,args)
        elseif owner.gunGroup and args[1]=='gun'then
            if kind=='spawn'then return guns.add(owner.gunGroup,args[2],#args>2 and{unpack(args,3)}or nil)
            elseif kind=='alive'then return guns.alive(owner.gunGroup,args[2])
            elseif kind=='clear'then return guns.clear(owner.gunGroup)end
        elseif owner.taskGroup and args[1]=='task'then
            if kind=='spawn'then return tasks.add(owner.taskGroup,args[2],#args>2 and{unpack(args,3)}or nil)
            elseif kind=='alive'then return tasks.alive(owner.taskGroup,args[2])
            elseif kind=='clear'then return tasks.clear(owner.taskGroup)end
        end
        return assert(api.invoke,'第五面缺少发弹、爆件或演出工厂：'..kind)(owner,kind,args,slot)
    end
    return bound
end
local phases={256,148,220,210,218,294,302,292,328,256,260,268,296,304,294,302,294,302,258,266,292,328,0}
local function initialize(x,y)
    x,y=x or 0,y or 0
    local bytes={}
    for a=0,0x27a7 do bytes[a]=0 end
    local function put(a,width,value)
        value=value%2^(width*8)
        for i=width-1,0,-1 do bytes[a+i]=value%256;value=floor(value/256)end
    end
    for _,r in ipairs({{8,x},{12,y},{16,16},{0x84,256},{0xfc,64*unit},{0x100,64*unit},
        {0x12c,48*unit},{0x1cf8,256},{0x2238,256},{0x228c,256},{0x2598,32*unit},{0x259c,-96*unit},
        {0x2604,1807744},{0x2608,1807744},{0x260c,136416},{0x2618,0x808080},{0x2628,0x10000},
        {0x2664,1069056},{0x2668,545664},{0x266c,738688},{0x2670,523392},{0x2674,545664},
        {0x267c,18000},{0x2680,18000},{0x2684,18000},{0x27a4,64}})do put(r[1],4,r[2])end
    for i,value in ipairs(phases)do put(0x160+(i-1)*0x120,4,value)end
    for i=0,71 do put(0x2358+i*8,4,x);put(0x235c+i*8,4,y)end
    local fields={}
    for a=0,0x27a7,4 do fields[a]=4 end
    for _,list in ipairs({motion.pose.inputFields,motion.pose.outputFields})do
        for _,field in ipairs(list)do fields[field[1]]=field[2]end
    end
    -- 受弹系统按半字访问死亡、无敌和换段标记；不能只保留其所在的长字别名。
    fields[0x2634],fields[0x2636],fields[0x263c]=2,2,2
    local raw={}
    for a,width in pairs(fields)do
        local n=0
        for i=0,width-1 do n=n*256+bytes[a+i]end
        raw[a]=n>=2^(width*8-1)and n-2^(width*8)or n
    end
    return raw
end
local function step(clock)
    if clock.closed or not clock.active or clock.serial==clock.run.serial then return end
    clock.serial=clock.run.serial
    local host=clock.host
    local input=assert(host.inputs,'第五面本体缺少本步控制输入')
    core.advance(host,input.paused,input.inhibitDefeat)
    if input.paused then return end
    host.motionInput=assert(input.motion,'第五面本体缺少移动输入')
    host.controlCounter=input.motion[6]or input.motion.globalLogicCounter
    if host.motion then motion.step(host.motion)end
    if host.controlGroup then control.step(host.controlGroup)end
    if host.gunGroup then guns.step(host.gunGroup)end
    if host.taskGroup then tasks.step(host.taskGroup)end
    if host.bulletFactory then bulletFactory.step(host.bulletFactory)end
    core.refresh(host)
    -- 根对象在管理器的全部演出槽之后结算累积伤害；换段清槽作用于下一步任务。
    core.applyPending(host,input.damageEvent)
    if host.retireRequested then close(host)end
end
local Clock=Class(object,{
    init=function(o,run)
        o.run,o.serial,o.active,o.closed=run,run.serial,false,false
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
    end,
    frame=step,
})
close=function(host)
    if not host or rawget(host,'closed')then return end
    if host.controlGroup then control.close(host.controlGroup)end
    if host.gunGroup then guns.close(host.gunGroup)end
    if host.taskGroup then tasks.close(host.taskGroup)end
    if host.motion then motion.close(host.motion)end
    if host.bulletFactory then bulletFactory.close(host.bulletFactory)end
    host.clock.closed=true;object.RawDel(host.clock)
    core.close(host)
end
return {
    core=core,motion=motion,control=control,guns=guns,tasks=tasks,bulletFactory=bulletFactory,initialize=initialize,
    create=function(run,p,x,y,notify)
        local clock=New(Clock,run)
        local host=core.create(run,p,function(owner,request)
            if owner.controlGroup then control.transition(owner.controlGroup,request.phase)end
            if notify then notify(owner,request)end
        end)
        host.raw=initialize(x,y)
        host.clock,clock.host=clock,host
        host.boardX,host.boardY=host.raw[8],host.raw[12]
        host.x,host.y=host.boardX/unit-120,host.boardY/unit-160
        host.renderDepth=83
        host.rootFlag96,host.retireRequested=1,false
        return host
    end,
    attachMotion=function(host,mode,config,random)
        local driver=motion.create(host,mode,config,random)
        host.clock.active=true
        return driver
    end,
    attachControl=function(host,api,mode)
        local manager=control.create(host,bind(api),mode)
        host.clock.active=true
        return manager
    end,
    attachTasks=function(host,api)
        local manager=tasks.create(host,bind(api))
        host.clock.active=true
        return manager
    end,
    attachGuns=function(host,api)
        local manager=guns.create(host,bind(api))
        host.clock.active=true
        return manager
    end,
    attachBullets=function(host,options)
        host.bulletFactory=bulletFactory.create(host.run,options)
        host.clock.active=true
        return host.bulletFactory
    end,
    step=function(host)step(host.clock)end,
    close=close,
}
