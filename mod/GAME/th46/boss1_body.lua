-- 0x0c14b1b0 的 Original 本体初始化。先清零，再按原宽度写入；不能用某个实战姿态当出生状态。
-- 关节、移动及绘图已移植；六个牵引点在绘图后同步，完整战斗主驱动仍等待挂载。
local core=dofile('mod/GAME/th46/boss1_core.lua')
local motion=dofile('mod/GAME/th46/boss1_motion.lua')
local pose=motion.pose
local view=dofile('mod/GAME/th46/boss1_view.lua')
local control=dofile('mod/GAME/th46/boss1_control.lua')
local tasks=dofile('mod/GAME/th46/boss1_tasks.lua')
local guns=dofile('mod/GAME/th46/boss1_guns.lua')
local bindings=dofile('mod/GAME/th46/boss1_bindings.lua')
local children=dofile('mod/GAME/th46/boss1_children.lua')
local unit,floor=65536,math.floor
local phases={256,300,388,344,476,432,300,344,388,432,212,168,300,344,388,432}
local function initialize(camera)
    local bytes={}
    for at=0,0x3f4f do bytes[at]=0 end
    local function put(at,width,value)
        for i=width-1,0,-1 do bytes[at+i]=value%256;value=floor(value/256)end
    end
    local x,y=120*unit-camera,500*unit
    for _,r in ipairs({{8,x},{12,y},{28,16},{76,256},{80,4},{0xbc,256},{0x22c,256},
        {0x1ab0,256},{0x1bc0,256},{0x1ffc,170752},{0x2000,170752},{0x2004,16704},
        {0x22f4,66816},{0x22f8,103936},{0x22fc,66816},{0x2304,18000},{0x2308,18000}})do
        put(r[1],4,r[2])
    end
    for _,at in ipairs({0xc0,0x230,0x1ac6,0x2020})do put(at,2,1)end
    for i=0,71 do put(0x1d50+i*8,4,x);put(0x1d54+i*8,4,y)end
    for i,v in ipairs(phases)do put(0x37c+(i-1)*0x120,4,v)end
    for i=0,5 do put(0x2010+i*0x8c,4,0x808080)end
    local fields={}
    for _,list in ipairs({pose.inputFields,pose.outputFields,view.draw.inputFields,view.draw.outputFields})do
        for _,r in ipairs(list)do fields[r[1]]=r[2]end
    end
    for _,at in ipairs({8,12,16,20,24,28,32,48,52,88,0x1ffc,0x2000,0x2004,0x22ec,0x2314})do fields[at]=4 end
    fields[56]=2
    fields[0x2010],fields[0x22e0],fields[0x22e4]=4,4,4
    for _,at in ipairs(control.fields)do fields[at]=4 end
    for _,r in ipairs(tasks.fields)do fields[r[1]]=r[2]end
    local raw={}
    for at,width in pairs(fields)do
        local value=0
        for i=0,width-1 do value=value*256+bytes[at+i]end
        if value>=2^(width*8-1)then value=value-2^(width*8)end
        raw[at]=value
    end
    return raw
end
local function syncHealth(o)
    o.raw[0x1ffc],o.raw[0x2000],o.raw[0x2004],o.raw[0x22ec]=o.hp,o.maxhp,o.warningHP,o.phase
end
-- c077d30 固定先移动，再扫描五个主槽、三十炮台槽及二十演出槽，最后生成绘图。
-- 协调对象必须先出生；各组件自己的 serial 防止引擎稍后再遍历时重复推进。
local function step(clock)
    if clock.closed or clock.serial==clock.run.serial then return end
    clock.serial=clock.run.serial
    local o=clock.host
    if o.motion then motion.step(o.motion)end
    if o.controlGroup then control.step(o.controlGroup)end
    guns.step(o.run)
    if o.taskGroup then tasks.step(o.taskGroup)end
    if o.view then view.step(o.view)end
end
local Clock=Class(object,{
    init=function(o,run)
        o.run,o.serial,o.closed=run,run.serial,false
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
    end,
    frame=step,
})
return {
    core=core,
    motion=motion,
    view=view,
    control=control,
    tasks=tasks,
    guns=guns,
    children=children,
    makeControlAPI=function(o,ports)
        return bindings(o,{core=core,motion=motion,tasks=tasks,guns=guns,children=children},ports)
    end,
    attachTasks=function(o,api)return tasks.create(o,api)end,
    attachControl=function(o,api,mode)return control.create(o,api,mode)end,
    attachView=function(o,random)return view.create(o,random,core.sync)end,
    initialize=initialize,
    step=function(o)step(o.clock)end,
    create=function(run,p,camera,notify)
        local clock=New(Clock,run)
        local o=core.create(run,p,function(host,kind,event,cause)
            if host.raw then syncHealth(host)end
            if notify then notify(host,kind,event,cause)end
        end)
        o.raw=initialize(camera)
        o.clock,clock.host=clock,o
        o.renderDepth=120
        o.boardX,o.boardY=o.raw[8],o.raw[12]
        o.x,o.y=o.boardX/unit-120,o.boardY/unit-160
        return o
    end,
    syncHealth=syncHealth,
    close=function(o)
        if not o or o.closed then return end
        o.clock.closed=true;object.RawDel(o.clock)
        if o.controlGroup then control.close(o.controlGroup)end
        if o.taskGroup then tasks.close(o.taskGroup)end
        children.close(o.run)
        if o.motion then motion.close(o.motion)end
        if o.view then view.close(o.view)end
        core.close(o)
    end,
}
