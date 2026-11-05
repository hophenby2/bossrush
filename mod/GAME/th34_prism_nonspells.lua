-- 三姐妹二非/三非：ecldata4 的64/68、80/83、98/103及各自发弹子程序。
-- 每段用普通Boss协程、子弹与直线激光对象执行；CALL中的等待会暂停主时间轴。
-- 差异1：Boss Rush逐项提供六个主奏分支；未接原作机体/上一张合奏伤害的选路。
-- 差异2：未传入th07_rank时取原作开局Rank=16；不把本项目Rogue Rank当作原作Rank。
local task, math = task, math
local PI, DEG = math.pi, 180/math.pi
return function(api)
    local shoot, move, drift = api.shoot, api.move, api.drift
    local function wait(n) if n>0 then task.Wait(n) end end
    local function turn(angle,speed,aim,loops)
        return {type=aim and 128 or 64,flag=0,dur=60,loop=loops or 1,
            angle=-angle*DEG,speed=speed}
    end
    local function charge(o,n,count)
        api.sound(o,5)
        for _=1,n do api.charge(o,count);task.Wait(4) end
    end
    local function rank(o,low,high)
        return low+((o.th07_rank or 16)/32)*(high-low)
    end
    -- flags既控制弹雾，也决定继承的命令是否激活；例如Sub105保留128命令但不启用它。
    local function fire(o,op,sprite,color,n,layers,v1,v2,a,da,cmd,flags,offset)
        offset=offset or 0
        shoot(o,0,0,op,sprite,color,n,layers,math.max(.3,v1+offset),math.max(.3,v2+offset/2),a,da,{list=cmd and {cmd} or {},flags=flags},math.floor(flags/512)%2==1)
    end
    -- Sub65/66：每圈在60帧刹停后按另一套角度/速率重新启动。
    -- Sub66的f1/f2从父上下文继承；返回时恢复，不能把上一圈累加值带回主程序。
    local function rings(o,total,n,color,step,rotation,speed,resume,span)
        local count=total/n
        local angle=api.random_angle()
        local delta=api.f32(api.f32(span)/(count-1))
        for _=1,count do
            fire(o,67,2,color,n,1,speed,.2,angle,0,turn(rotation,resume),66)
            angle=api.f32(angle+step);resume=api.f32(resume-delta)
        end
    end
    local LUNA2 = {
        {160,128,16,6, PI/64,0,3},
        {220,128,16,2,-PI/64,0,3},{220,128,16,2,PI/64,0,2.5},{220,128,16,2,-PI/64,0,2},
        {410,96,16,4,PI/48,-PI/2,3},{440,96,16,3,-PI/48,PI/2,3},
        {470,96,16,4,PI/48,-PI/2,3},{500,96,16,3,-PI/48,PI/2,3},
        {500,128,16,4,PI/64,PI/2,3},{500,128,16,4,-PI/64,-PI/2,2.5},{500,128,16,4,PI/64,0,2},
        {680,80,8,6,PI/40,PI,4.6},{710,80,8,6,-PI/40,-PI,4.6},
        {740,80,8,6,PI/40,PI/2,4.6},{770,80,8,6,-PI/40,-PI/2,4.6},
        {770,128,16,6,-PI/64,0,3.2},{770,128,16,6,-PI/64,0,2.2},{770,128,16,6,-PI/64,0,1.8},
        {830,60,6,2,PI/30,0,2},{840,60,6,2,-PI/30,0,2.5},
        {850,60,6,2,PI/30,PI,3},{860,60,6,2,-PI/30,PI,5.5},
    }
    local function luna2(o)
        task.Wait(60);move(o,100,4,0,112);task.Wait(100)
        while true do
            local i=1
            for t=160,979 do
                if t==280 or t==600 then drift(o,.8,100,4) end
                if t==380 or t==650 then charge(o,2,16) end
                if t==830 then move(o,100,4,0,112) end
                while LUNA2[i] and LUNA2[i][1]==t do
                    local p=LUNA2[i]
                    rings(o,p[2],p[3],p[4],api.f32(p[5]),api.f32(p[6]),api.f32(p[7]),3,api.f32(1.2))
                    i=i+1
                end
                task.Wait(1)
            end
        end
    end
    local TIMES={0,30,60,80,100,110,120,130,140,150,160,170,170,170}
    local SIGNS={
        {1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,-1,1},
        {1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1},
        {1,1,-1,-1,1,1,-1,-1,-1,-1,-1,-1,1,-1},
        {1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1},
    }
    local ROTATIONS={
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {-PI/2,PI/2,-PI/2,PI/2,-PI/2,PI/2,-PI/2,PI/2,-PI/2,PI/2,-PI/2,PI/2,-PI/2,PI/2},
        {PI,0,PI,0,PI,0,PI,0,PI,0,PI,0,PI,0},
        {-PI/8,PI/8,-PI/4,PI/4,-PI/2,PI/2,-PI,PI,-PI,PI,-PI,PI,-PI/4,PI/4},
    }
    local function luna3(o)
        task.Wait(60);move(o,100,4,0,112);task.Wait(100)
        while true do
            for group=1,4 do
                charge(o,2,16)
                local t=0
                for i,at in ipairs(TIMES) do
                    wait(at-t);t=at
                    local total=i<=6 and 64 or i<=12 and 56 or group==1 and 64 or 80
                    local step=({PI/40,PI/48,PI/40,PI/64})[group]*SIGNS[group][i]
                    rings(o,total,8,group%2==1 and 6 or 2,api.f32(step),api.f32(ROTATIONS[group][i]),
                        i<=12 and 2 or i==13 and 3 or 4,1.5,api.f32(.7))
                end
                if group<4 then drift(o,.8,60,4) end
                task.Wait(60)
            end
        end
    end
    local function curve(angle)
        return {type=32,flag=0,dur=30,loop=-1,speed=0,angle=-angle*DEG}
    end
    local function merlin_fan(o,step,stationary)
        charge(o,4,32)
        local a=api.f32(api.aim(o)+api.f32(step))
        local da=api.f32(api.f32(step)/-8)
        for _=1,8 do
            for side=1,2 do
                a=api.normalize(a)
                api.laser(o.x,o.y,-a,{
                    sprite=stationary and 2 or 3,color=stationary and side==2 and 2 or 6,
                    spd=stationary and 0 or 3.5,sOff=16,eOff=stationary and 512 or 16,
                    sLen=stationary and 512 or 224,w=10,tStart=stationary and 80 or 50,
                    dur=stationary and 60 or 252000,tEnd=stationary and 20 or 16,
                    hbStart=stationary and 70 or 16,hbEnd=stationary and 20 or 16,flags=0})
                local sign=side==1 and 1 or -1
                task.Wait(1)
                local c=stationary and side==2 and 6 or 2
                local offset=stationary and 0 or rank(o,-.5,0)
                fire(o,65,3,c,1,4,3,1,a,0,curve(api.f32(PI/200)*sign),546,offset)
                task.Wait(1)
                local cmd=curve(-api.f32(PI/200)*sign)
                fire(o,65,3,c,1,5,3.5,.5,a,0,cmd,34,offset)
                fire(o,65,3,2,5,1,2.5,1,a,0,cmd,2,offset)
                a=api.f32(a+da)
                task.Wait(2)
            end
        end
    end
    local function merlin2(o)
        task.Wait(100)
        while true do
            merlin_fan(o,PI*9/16,false)
            task.Wait(30);drift(o,.8,30,4)
            task.Wait(30);merlin_fan(o,-PI*9/16,false)
            task.Wait(30);drift(o,.8,30,4)
            task.Wait(100)
            merlin_fan(o,-PI*9/16,false);merlin_fan(o,PI*9/16,false);merlin_fan(o,-PI*9/16,false)
            task.Wait(50);drift(o,1.2,30,4);task.Wait(50)
        end
    end
    local function merlin3(o)
        task.Wait(120)
        while true do
            merlin_fan(o,PI*9/16,true)
            task.Wait(30);drift(o,1.2,30,4)
            task.Wait(30);merlin_fan(o,-PI*9/16,true)
            task.Wait(30);drift(o,1.2,30,4)
            task.Wait(100)
            merlin_fan(o,-PI*9/16,true);merlin_fan(o,PI*9/16,true)
            task.Wait(20)
            merlin_fan(o,-PI*9/16,true);merlin_fan(o,PI*9/16,true)
            task.Wait(50);drift(o,1.2,30,4)
        end
    end
    -- 子弹命令属于敌机，不随SUB_RET还原；Sub99的首环和Sub105要沿用上一发的命令。
    local function lyrica_aim(o,third)
        local offset=third and 0 or rank(o,0,.4)
        local speed,angle=third and 3 or 3.5,api.f32(third and PI/2 or PI)
        if not third then fire(o,66,6,6,32,1,2.2,1,0,angle,o.prism_command,578,offset) end
        local rotations={0,PI/4,-PI/4,PI/8,-PI/8}
        for _=1,8 do
            for _,r in ipairs(rotations) do
                o.prism_command=turn(api.f32(r),speed,true,third and 2 or 1)
                fire(o,64,6,2,3,1,3,1,0,angle,o.prism_command,642,offset)
                speed=api.f32(speed-api.f32(third and .03 or .0375))
                angle=api.f32(angle-api.f32(PI/40))
            end
        end
    end
    local function lyrica_turn(o,third)
        if third then
            fire(o,66,6,6,32,3,4.8,1.1,0,api.f32(PI/2),o.prism_command,578)
            fire(o,64,6,6,15,4,3,1.2,0,api.f32(PI/32),o.prism_command,578)
            return
        end
        local speed,angle=4,api.f32(PI/2)
        local offset=rank(o,0,.4)
        for _=1,8 do
            for i=1,3 do
                local v=i==1 and speed or api.f32(speed*api.f32(i==2 and .7 or .5))
                o.prism_command=turn(0,v)
                fire(o,64,6,6,2,1,3,1,0,angle,o.prism_command,578,offset)
                speed=api.f32(speed-.0625);angle=api.f32(angle-api.f32(PI/48))
            end
        end
    end
    local function lyrica2(o)
        task.Wait(90)
        while true do
            charge(o,4,32);lyrica_aim(o,false)
            task.Wait(60);lyrica_turn(o,false);drift(o,1.3,60,4)
            task.Wait(60);lyrica_aim(o,false)
            task.Wait(30);lyrica_turn(o,false)
            task.Wait(60);drift(o,1.3,60,4)
            task.Wait(60);lyrica_aim(o,false)
            task.Wait(16);lyrica_aim(o,false)
            task.Wait(16);lyrica_turn(o,false)
            task.Wait(16);lyrica_aim(o,false)
            task.Wait(16);lyrica_aim(o,false)
            task.Wait(16);lyrica_turn(o,false)
            task.Wait(60);drift(o,1.3,60,4);task.Wait(60)
        end
    end
    local function lyrica3(o)
        task.Wait(60);move(o,100,4,0,112);task.Wait(100)
        while true do
            charge(o,4,32);lyrica_aim(o,true)
            task.Wait(120);lyrica_turn(o,true);drift(o,.6,60,4)
            task.Wait(60);lyrica_aim(o,true)
            task.Wait(60);lyrica_turn(o,true)
            task.Wait(60);drift(o,.6,60,4)
            task.Wait(60);lyrica_aim(o,true)
            task.Wait(60);lyrica_aim(o,true)
            task.Wait(60);lyrica_aim(o,true)
            task.Wait(60);lyrica_turn(o,true)
            task.Wait(60);drift(o,.6,60,4);task.Wait(60)
        end
    end
    return {luna2=luna2,luna3=luna3,merlin2=merlin2,merlin3=merlin3,lyrica2=lyrica2,lyrica3=lyrica3}
end
