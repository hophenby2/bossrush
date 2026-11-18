-- 第一面关底的独立移动槽：0x0c14f630 / 0x0c14f6d0 / 0x0c14f960 / 0x0c14fa80。
-- 移动先积分并更新关节，随后才寻向或加减速；新入口下一逻辑步执行，不能当帧抢跑。
-- 此对象等待完整本体控制器挂载；坐标、相机和存活输入均由控制器按原更新顺序提供。
-- 差异 1：默认使用 LuaSTG 录像随机数，原版与粒子共用的随机队列尚未接入。
local pose=dofile('mod/GAME/th46/boss1_pose.lua')
local direction=dofile('mod/GAME/th46/direction.lua')
local object,unit,heading,vector=object,direction.unit,direction.heading,direction.vector
local floor,abs,min,max=math.floor,math.abs,math.min,math.max
-- 0x0c307cd0 的十六档：等待计时初值 / 每次速度增减量。
local parameters={{16,1},{8,1},{4,1},{3,1},{2,1},{1,1},{0,1},{0,2},
    {0,3},{0,4},{0,5},{0,6},{0,7},{0,8},{0,9},{0,10}}
local modes={simple_init=true,simple=true,wander_init=true,wander=true,
    move_init=true,move=true,entry_init=true,entry=true}
local function distance(x,y,tx,ty)
    local a,b=abs(x-tx),abs(y-ty)
    return max(a,b)+floor(min(a,b)/2)
end
local function turn(current,target)
    return(current+max(-4,min(4,(target-current+256)%512-256)))%512
end
local function switch(o,mode,config)
    assert(modes[mode],'关底移动入口未实现')
    o.mode,o.originalMode,o.config=mode,mode,{unpack(config or {})}
    o.state,o.clock,o.interval,o.acceleration,o.half=0,0,0,0,0
    o.anchorX,o.anchorY,o.targetX,o.targetY=0,0,0,0
end
local function event(o,name,...)
    if o.host.motionEvent then o.host.motionEvent(o.host,name,...)end
end
local function randomTarget(o)
    o.targetX=o.anchorX+(o.random(48)-24)*unit
    o.targetY=o.anchorY+(o.random(24)-12)*unit
end
local function integrate(o,input)
    local b=o.host.raw
    local x,y=vector(b[28],b[32])
    b[8],b[12]=b[8]+x,b[12]+y
    local landed=pose.update(b,unpack(input))
    local host=o.host
    host.boardX,host.boardY=b[8],b[12]
    host.x,host.y=b[8]/unit-120,b[12]/unit-160
    if landed then event(o,'land')end
    if host.onPose then host.onPose(host)end
end
local function decelerate(o,b)
    o.clock=o.clock-1
    if o.clock<0 then o.clock=o.interval;b[28]=b[28]-o.acceleration end
end
local Driver=Class(object,{
    init=function(o,host,mode,config,random)
        assert(not host.motion or host.motion.closed,'关底只能有一个移动槽')
        o.host,o.run,o.random=host,host.run,random or function(n)return ran:Int(0,n)end
        o.serial,o.closed=host.run.serial,false
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
        switch(o,mode,config);host.motion=o
    end,
    frame=function(o)
        if o.closed or o.serial==o.run.serial then return end
        o.serial=o.run.serial
        local b=o.host.raw
        local input=assert(o.host.motionInput,'关底缺少本步相机及自机输入')
        local camera=input[2]
        if o.mode=='simple_init'then o.mode='simple';return end
        if o.mode=='entry_init'then
            o.state,b[28],b[32],o.mode=0,1,256,'entry';return
        end
        if o.mode=='wander_init'then
            o.anchorX,o.anchorY=b[8],b[12]
            randomTarget(o);b[28]=assert(o.config[1]);o.mode='wander';return
        end
        if o.mode=='move_init'then
            local p=parameters[min(15,max(0,assert(o.config[1])))+1]
            o.state,o.clock,o.interval,o.acceleration=0,p[1],p[1],p[2]
            o.targetX,o.targetY=assert(o.config[2]),assert(o.config[3])
            if b[28]==0 then b[28]=1 end
            o.half=floor(distance(b[8],b[12],o.targetX-camera,o.targetY)/2)
            b[32]=heading(b[8],b[12],o.targetX-camera,o.targetY)
            o.mode='move';return
        end
        if o.mode=='entry'then
            if o.state==0 then
                if b[48]<=0 then o.state,o.clock=1,16 end
            elseif o.state==1 then
                o.clock=o.clock-1
                if o.clock<0 then
                    b[28],b[88]=13,15
                    -- 0x0c155960 先写幅度，再排队执行 0x0c1558e0。
                    event(o,'entry_pose',15,0)
                    b[48],b[52],o.state=48,256,2
                end
            end
        end
        integrate(o,input)
        if o.mode=='wander'then
            local tx=o.targetX-(b[56]==0 and camera or 0)
            b[32]=turn(b[32],heading(b[8],b[12],tx,o.targetY))
            if distance(b[8],b[12],tx,o.targetY)<=16*unit then randomTarget(o)end
        elseif o.mode=='move'then
            local tx=o.targetX-camera
            local d=distance(b[8],b[12],tx,o.targetY)
            if o.state==0 then
                b[32]=heading(b[8],b[12],tx,o.targetY)
                if d>o.half then
                    o.clock=o.clock-1
                    if o.clock<0 then o.clock=o.interval;b[28]=b[28]+o.acceleration end
                    if d>8*unit then return end
                end
                o.state=1
            end
            if o.state==1 then decelerate(o,b)end
            if b[28]<=0 or d<=0x3ffff then
                b[28]=0
                -- 原槽换入口后先释放旧参数，下一步才取寻点随机数与设置速度 4。
                switch(o,'wander_init',{4})
            end
        end
    end,
})
return {
    pose=pose,
    create=function(host,mode,config,random)return New(Driver,host,mode,config,random)end,
    switch=switch,
    ensure=function(o,mode,config)if o.originalMode~=mode then switch(o,mode,config)end end,
    step=function(o)Driver.frame(o)end,
    close=function(o)
        if not o or o.closed then return end
        o.closed=true
        if o.host.motion==o then o.host.motion=nil end
        object.RawDel(o)
    end,
}
