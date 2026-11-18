-- 第五面关底的原生移动槽：直行、边界游走与加减速寻点。
-- 0x0c1b58b0 先积分，再推进完整姿态；0x0c1b65c0 随后寻向并调整下一步速度。
-- 差异 1：默认使用 LuaSTG 录像随机数；原版与粒子共用的随机队列尚未统一。
-- 差异 2：移动、主任务、炮台与演出共用参数池；独立移动回归仍输入其它槽留下的字节。
local pose=dofile('mod/GAME/th46/boss5_pose.lua')
local direction=dofile('mod/GAME/th46/direction.lua')
local parametersPool=dofile('mod/GAME/th46/parameters.lua')
local object,vector,heading=object,direction.vector,direction.heading
local floor,abs,min,max=math.floor,math.abs,math.min,math.max
local unit=65536
local parameters={{16,1},{8,1},{4,1},{3,1},{2,1},{1,1},{0,1},{0,2},
    {0,3},{0,4},{0,5},{0,6},{0,7},{0,8},{0,9},{0,10}}
local entries={simple_init=0xc1b59c0,simple=0xc1b5990,wander_init=0xc1b5b10,
    wander=0xc1b5a00,move_init=0xc1b5b90,move=0xc1b65c0,
    retreat_init=0xc1b5e50,retreat=0xc1b5c90}
local function signed(n)return(n+2147483648)%4294967296-2147483648 end
local function distance(x,y,tx,ty)
    local a,b=abs(x-tx),abs(y-ty)
    return max(a,b)+floor(min(a,b)/2)
end
local function turn(current,target,amount)
    return(current+max(-amount,min(amount,(target-current+256)%512-256)))%512
end
local privateFields={
    wander={{16,'targetX',4},{20,'targetY',4},{48,'turnTarget',2},{50,'turning',1}},
    move={{0,'state',4},{16,'targetX',4},{20,'targetY',4},{24,'clock',4},{28,'interval',4},{32,'acceleration',4},{36,'half',4}},
    retreat={{0,'state',4},{4,'clock',4},{16,'targetX',4},{20,'targetY',4}},
}
local function save(o)
    if not o.parameters then return end
    for _,f in ipairs(privateFields[o.mode]or{})do
        if not(o.mode=='retreat'and o.state==0 and f[2]=='clock')then parametersPool.write(o.parameters,f[1],f[3],o[f[2]])end
    end
end
local function switch(o,mode,config)
    assert(entries[mode],'第五面移动入口未实现：'..tostring(mode))
    save(o);parametersPool.release(o.parameters);o.parameters=nil
    o.mode,o.originalMode,o.config=mode,mode,{unpack(config or{})}
    o.state,o.clock,o.interval,o.acceleration,o.half=0,0,0,0,0
    o.targetX,o.targetY,o.turning,o.turnTarget=0,0,0,0
end
local function allocate(o)
    if o.parameters then return end
    o.parameters=assert(parametersPool.allocate(o.pool,52),'第五面任务参数池已满')
    if o.host.motionMemoryInput then o.host.motionMemoryInput(o.host,o.mode,o.parameters,parametersPool)end
    o.turnTarget=parametersPool.read(o.parameters,48,2)
    o.turning=parametersPool.read(o.parameters,50,1)
end
local function integrate(o)
    local b=o.host.raw
    local dx,dy=vector(b[16],b[20])
    b[8],b[12]=signed(b[8]+dx),signed(b[12]+dy)
    if b[0x134]~=0 then
        dx,dy=vector(b[0x134],b[0x130])
        b[0x128],b[0x12c]=signed(b[0x128]+dx),signed(b[0x12c]+dy)
    end
    local input=assert(o.host.motionInput,'第五面关底缺少相机及自机输入')
    pose.update(b,unpack(input))
    local host=o.host
    host.boardX,host.boardY=b[8],b[12]
    host.x,host.y=b[8]/unit-120,b[12]/unit-160
    if host.onPose then host.onPose(host)end
end
local function step(o)
    if o.closed or o.serial==o.run.serial then return end
    o.serial=o.run.serial
    local b,c=o.host.raw,o.config
    if o.mode=='simple_init'then o.mode='simple';return end
    if o.mode=='retreat_init'then
        allocate(o)
        o.state,o.targetX,o.targetY=0,120*unit,192*unit
        b[16],b[20],b[0x130],b[0x134],b[0x138],b[0x13c]=1,256,0,4,64,32
        o.mode='retreat';return
    end
    if o.mode=='wander_init'then
        allocate(o)
        b[16],o.targetX,o.targetY=assert(c[1]),assert(c[2]),assert(c[3])
        b[0x2778],b[0x277c],b[0x2780],b[0x2784]=assert(c[4]),assert(c[5]),assert(c[6]),assert(c[7])
        o.mode='wander';return
    end
    if o.mode=='move_init'then
        allocate(o)
        local p=parameters[min(15,max(0,assert(c[1])))+1]
        o.state,o.clock,o.interval,o.acceleration=0,p[1],p[1],p[2]
        o.targetX,o.targetY=assert(c[2]),assert(c[3])
        b[0x2778],b[0x277c],b[0x2780],b[0x2784]=assert(c[4]),-c[4],assert(c[5]),-c[5]
        if b[16]==0 then b[16]=1 end
        o.half=floor(distance(b[8],b[12],o.targetX,o.targetY)/2)
        b[20]=heading(b[8],b[12],o.targetX,o.targetY)
        o.mode='move';return
    end
    if o.mode=='wander'then
        if o.turning~=0 then
            b[20]=turn(b[20],o.turnTarget,8)
            if b[20]==o.turnTarget then o.turning=0 end
        end
        local base
        if b[8]<o.targetX+b[0x277c]then base=120
        elseif b[8]>o.targetX+b[0x2778]then base=376
        elseif b[12]>o.targetY+b[0x2780]then base=248
        elseif b[12]<o.targetY+b[0x2784]then base=-8 end
        if base then o.turnTarget,o.turning=base+o.random(15),1 end
        integrate(o);return
    end
    if o.mode=='retreat'then
        if o.state==0 then
            if b[36]<=0 then o.state,o.clock=1,16 end
        elseif o.state==1 then
            o.clock=o.clock-1
            if o.clock<0 then b[16],b[36],b[40],o.state=13,48,256,2 end
        end
        local x,y=b[8]+b[0x128],b[12]+b[0x12c]
        b[0x130]=turn(b[0x130],heading(x,y,o.targetX,o.targetY),4)
        b[0x134]=distance(x,y,o.targetX,o.targetY)>16*unit and 6 or 4
        b[0x1da0]=b[0x130]
        local counter=assert(o.host.motionInput[6],'第五面退场缺少原版逻辑计数')
        if b[0x2348]~=8 and counter%4==0 then
            local px=x+(o.random(16)-8)*unit
            local py=y+(o.random(16)-24)*unit
            local kind=20+o.random(1)
            local speed=16+o.random(8)
            local angle=248+o.random(16)
            assert(o.host.motionParticle,'第五面退场缺少粒子挂载接口')(o.host,kind,px,py,b[0xb7c]-1,speed,angle)
        end
        if b[0x2348]==7 then b[0xf8]=min(255,b[0xf8]+4)end
        integrate(o);return
    end
    integrate(o)
    if o.mode~='move'then return end
    local d=distance(b[8],b[12],o.targetX,o.targetY)
    if o.state==0 then
        local desired=heading(b[8],b[12],o.targetX,o.targetY)
        b[20]=turn(b[20],desired,4)
        if d>o.half then
            o.clock=o.clock-1
            if o.clock<0 then
                o.clock=o.interval
                if abs((desired-b[20]+256)%512-256)<=63 then b[16]=signed(b[16]+o.acceleration)end
            end
            if d>8*unit then return end
        end
        o.state=1
    end
    if o.state==1 then
        o.clock=o.clock-1
        if o.clock<0 then o.clock=o.interval;b[16]=signed(b[16]-o.acceleration)end
    end
    if b[16]<=0 or d<=0x3ffff then
        b[16]=0
        switch(o,'wander_init',{3,o.targetX,o.targetY,b[0x2778],b[0x277c],b[0x2780],b[0x2784]})
    end
end
local function frame(o)step(o);save(o)end
local Driver=Class(object,{
    init=function(o,host,mode,config,random)
        assert(not host.motion or host.motion.closed,'第五面关底只能有一个移动槽')
        o.host,o.run,o.random=host,host.run,random or function(n)return ran:Int(0,n)end
        host.nativeParameters=host.nativeParameters or parametersPool.create()
        o.pool=host.nativeParameters
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
        o.serial,o.closed=host.run.serial,false
        switch(o,mode,config);host.motion=o
    end,
    frame=frame,
})
return {
    pose=pose,entries=entries,step=frame,switch=switch,parameters=parametersPool,
    create=function(host,mode,config,random)return New(Driver,host,mode,config,random)end,
    ensure=function(o,mode,config)if o.originalMode~=mode then switch(o,mode,config)end end,
    close=function(o)
        if not o or rawget(o,'closed')then return end
        o.closed=true
        save(o);parametersPool.release(o.parameters);o.parameters=nil
        if o.host.motion==o then o.host.motion=nil end
        object.RawDel(o)
    end,
}
