-- c076960/c076b70 → c06db00/c06dc90：先收集至多 500 份请求，再按顺序展开。
-- Original 场景 c06d830 将活动许可设为 64；取消中的弹仍占用许可，不能提前补发。
-- 源队列先分配，再扫描旧弹/新弹，出界回收因此晚于本步的分配判断。
local bullets=dofile('mod/GAME/th46/boss5_bullets.lua')
local object=object
local floor=math.floor
local requestLimit,activeLimit=500,64
local texture='th46_boss5_bullets_'
local function signed16(n)return(n+32768)%65536-32768 end
local function inhibited(factory)
    local value=factory.options.inhibited
    if type(value)=='function'then return value(factory.run)end
    if value~=nil then return value end
    local run=factory.run
    return run.roadShotResume~=nil and assert(run.roadFrame)<run.roadShotResume
end
local function enqueue(factory,kind,args)
    assert(kind=='bullet'or kind=='fan','第五面未知出膛接口')
    if inhibited(factory)or #factory.jobs>=requestLimit then return false end
    local k,x,y,speed,angle=args[1]%256,args[2],args[3],signed16(args[4]),args[5]%65536
    local count,spread,flag=1,0,args[6]or 0
    if kind=='fan'then count,spread,flag=args[6]%65536,args[7]%65536,args[8]or 0 end
    factory.jobs[#factory.jobs+1]={k,x,y,speed,angle,count,spread,signed16(flag)}
    return true
end
local function allocate(factory,job,angle)
    local run,options=factory.run,factory.options
    local external=options.externalCount and options.externalCount(run)or 0
    local o
    if not inhibited(factory)and(run.boss5BulletCount or 0)+external<activeLimit then
        o=bullets.emit(run,job[2],job[3],angle,job[4],job[1],{
            depthFlag=job[8],baseSpeed=factory.baseSpeed})
        if o then o.factory=factory end
    end
    if options.allocated then options.allocated(factory,{job[1],job[2],job[3],job[4],angle,job[8]},o)end
end
local function flush(factory)
    for _,job in ipairs(factory.jobs)do
        local angle=(job[5]-floor((job[6]-1)*job[7]/2))%65536
        for _=1,job[6]do allocate(factory,job,angle);angle=(angle+job[7])%65536 end
    end
    factory.jobs={}
end
local function step(factory)
    if factory.closed or factory.serial==factory.run.serial then return end
    factory.serial=factory.run.serial;factory.rows={}
    flush(factory)
    local o=factory.run.boss5BulletHead
    while o do
        local next=rawget(o,'nextBullet')
        bullets.step(o)
        -- 已提交的图形属于本步队列；后续出界或碰撞回收不得抹掉它。
        bullets.draw(o,function(...)factory.rows[#factory.rows+1]={...}end)
        if not o.closed and bullets.outside(o)then bullets.retire(o)end
        o=next
    end
end
local Factory=Class(object,{
    init=function(o,run,options)
        assert(not run.boss5BulletFactory,'第五面不能重复建立敌弹队列')
        o.run,o.options,o.jobs,o.rows=run,options or{},{},{}
        run.boss5BulletCount=run.boss5BulletCount or 0
        o.baseSpeed=assert(o.options.baseSpeed or run.roadBulletBase,'第五面敌弹队列缺少场景入口基速')
        o.serial,o.closed=run.serial,false
        o.group,o.layer,o.bound,o.colli=GROUP.GHOST,LAYER.ENEMY_BULLET,false,false
        run.boss5BulletFactory=o
    end,
    frame=function()end,
    render=function(o)
        for _,r in ipairs(o.rows)do
            local image=texture..r[1]
            SetImageState(image,r[6]<0 and''or'mul+add',r[6]<0 and 255 or r[6],255,255,255)
            Render(image,floor(r[2]/65536)-120,floor(r[3]/65536)-160,0,
                r[5]%2==1 and -1 or 1,floor(r[5]/2)%2==1 and -1 or 1)
        end
    end,
})
return{bullets=bullets,enqueue=enqueue,flush=flush,step=step,
    -- c06d830 在场景入口锁存；后续 rank 增长只进入单弹合成速度。
    initializeScene=function(run,rankAtEntry)run.roadBulletBase=42+floor(rankAtEntry/8);return run.roadBulletBase end,
    create=function(run,options)return New(Factory,run,options)end,
    close=function(factory)
        if not factory or rawget(factory,'closed')then return end
        factory.closed=true;factory.jobs={};factory.rows={};bullets.close(factory.run)
        if factory.run.boss5BulletFactory==factory then factory.run.boss5BulletFactory=nil end
        object.RawDel(factory)
    end,
}
