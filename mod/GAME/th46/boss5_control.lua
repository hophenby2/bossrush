-- 第五面 Original 入场、三段攻击、两次换段与最终击破调度。
-- 五个主任务槽沿用 c077d30 的下标顺序；新任务落在后槽时本步初始化。
-- 等待条件来自移动槽、发弹槽、演出槽和身体动画，不能用采样帧号替代。
-- 炮台、演出和零件工厂必须通过 api.invoke 提供；缺少接口立即报错，不伪造完成。
-- spawn 返回原管理器语义的 16 位句柄（失败为 0），工厂以句柄索引原生对象。
-- 参数与移动槽共用原生 400×64 字节池，释放保留旧字节；初始化只写原程序写过的项。
local object=object
local parameters=dofile('mod/GAME/th46/parameters.lua')
local handles=dofile('mod/GAME/th46/boss5_handles.lua')
local unit=65536
local source={entry_init=0xc1b6990,entry=0xc1b6750,pattern_init=0xc1b95f0,pattern=0xc1b9650,
    second_init=0xc1ba520,second=0xc1ba580,third_init=0xc1bae60,third=0xc1baeb0,
    change1_init=0xc1b6df0,change1=0xc1b69f0,change2_init=0xc1b7400,change2=0xc1b6e80}
local handlers,Slot,Manager={}
local firstGunWait,secondGunWait,retractWait,resetWait=16,48,32,192
local transitionModes={'change1_init','change2_init','defeat_init'}
local function closeSlot(o)
    if o.closed then return end
    o.closed=true
    parameters.release(o.block)
    if o.manager.slots[o.index]==o then o.manager.slots[o.index]=nil end
    object.RawDel(o)
end
local function add(manager,mode)
    assert(source[mode],'第五面主任务入口未移植：'..tostring(mode))
    for i=1,5 do
        if not manager.slots[i]then
            local o=New(Slot,manager,mode,i)
            o.handle=handles.next(manager.host)
            manager.slots[i]=o;return o
        end
    end
    return 0
end
local function call(manager,o,kind,args)
    local value
    if kind=='control'then value=add(manager,args[1])
    elseif kind=='remove'then closeSlot(o)
    elseif kind=='clear_control'then
        for i=1,5 do if manager.slots[i]then closeSlot(manager.slots[i])end end
    elseif kind=='switch'then -- 函数切换已经在当前原生槽内完成。
    else value=assert(manager.api.invoke,'第五面主任务缺少原生挂载接口')(manager.host,kind,args,o)end
    if manager.api.observe then manager.api.observe(manager.host,kind,args,value,o)end
    return value
end
local function invoke(o,kind,...)return call(o.manager,o,kind,{...})end
local function spawn(o,pool,entry,...)
    local result=invoke(o,'spawn',pool,entry,...)
    assert(type(result)=='number'and result>=0 and result<65536 and result==math.floor(result),
        '第五面子任务必须返回 16 位句柄，分配失败返回 0')
    return result
end
local function alive(o,pool,handle)
    local value=invoke(o,'alive',pool,handle)
    assert(type(value)=='boolean','第五面存活查询必须返回布尔值')
    return value
end
local function moving(o)
    local value=invoke(o,'motion_is','wander')
    assert(type(value)=='boolean','第五面移动入口查询必须返回布尔值')
    return value
end
local function motion(o,mode,... )invoke(o,'motion','ensure',mode,...)end
local function allocate(o,size)
    assert(not o.block,'第五面主任务重复分配私有参数')
    o.block=assert(parameters.allocate(o.manager.pool,size),'第五面主任务参数池已满')
end
local function switch(o,mode)
    o.mode=mode
    invoke(o,'switch',mode)
end
local function finish(o,mode)
    invoke(o,'control',mode)
    invoke(o,'remove')
end
local function tick(v)v[4]=v[4]-1;return v[4]end
local function arms(b,enabled,kind)
    b[0x2788]=enabled
    if kind then b[0x278c]=kind end
end
local function moveTo(o,b,speed,tune,y,bounds)
    b[16],b[20]=speed,0
    bounds=bounds or 4
    motion(o,'move_init',tune,120*unit,y*unit,bounds*unit,bounds*unit)
end
handlers.entry_init=function(o,v)
    allocate(o,12)
    v[0],v[4],v[8]=0,0,0
    switch(o,'entry')
end
handlers.entry=function(o,v,b)
    local state=v[0]
    if state==0 then
        if tick(v)>=0 then return end
        invoke(o,'signal','boss_scene',1)
        invoke(o,'signal','open_view')
        v[8]=0
        b[16],b[20]=0,256
        v[8]=spawn(o,'task',0xc1bc410)
        motion(o,'simple_init')
        -- 原指令写半字；这四项在本体中是长字的高半部分。
        for _,a in ipairs({0x1d10,0x1d64,0x1c68,0x1cbc})do
            b[a]=65536+(b[a]or 0)%65536
        end
        invoke(o,'signal','opening_parts')
        v[0],v[4]=1,0
    elseif state==1 then
        if alive(o,'task',v[8])then return end
        invoke(o,'signal','stage_scroll',1)
        v[8]=spawn(o,'task',0xc1bc4f0)
        invoke(o,'collision',true)
        v[0],v[4]=10,0
    elseif state==10 then
        if tick(v)>=0 then return end
        invoke(o,'signal','boss_scene',2)
        invoke(o,'signal','activate_boss',1)
        v[0],v[4]=20,0
    elseif state==20 then
        assert(b[28]==0,'第五面主任务目前只支持 Original')
        finish(o,'pattern_init')
    end
end
handlers.pattern_init=function(o,v)
    allocate(o,24)
    v[0],v[4]=0,firstGunWait
    switch(o,'pattern')
end
handlers.pattern=function(o,v,b)
    local state=v[0]
    if state==0 then
        moveTo(o,b,6,4,220);v[0]=5
    elseif state==5 then
        if not moving(o)then return end
        arms(b,1,4);v[0],v[4]=8,0
    elseif state==8 then
        if tick(v)>0 then return end
        v[8]=spawn(o,'gun',0xc1bf540)
        v[0],v[4]=10,firstGunWait
    elseif state==10 then
        if tick(v)<=0 then v[0],v[4]=20,firstGunWait end
    elseif state==20 then
        if alive(o,'gun',v[8])then return end
        arms(b,0)
        if b[0x2790]~=0 then return end
        v[0],v[4]=25,retractWait
    elseif state==25 then
        if tick(v)>0 then return end
        arms(b,1,5);spawn(o,'task',0xc1bcea0)
        v[0],v[4]=30,secondGunWait
    elseif state==30 then
        if tick(v)>0 then return end
        v[12]=spawn(o,'gun',0xc1bf610)
        v[0],v[4]=40,firstGunWait
    elseif state==40 then
        if tick(v)<=0 then v[0],v[4]=50,firstGunWait end
    elseif state==50 then
        if alive(o,'gun',v[12])then return end
        arms(b,0)
        if b[0x2790]~=0 then return end
        moveTo(o,b,2,1,290)
        v[0],v[4]=55,retractWait
    elseif state==55 then
        if tick(v)>0 then return end
        spawn(o,'task',0xc1bcea0)
        v[0],v[4]=60,firstGunWait
    elseif state==60 then
        if tick(v)>0 then return end
        b[64]=spawn(o,'task',0xc1bc5a0);v[0]=65
    elseif state==65 then
        if alive(o,'task',b[64])then return end
        arms(b,1,6);v[16]=spawn(o,'gun',0xc1bf6c0)
        v[0],v[4]=70,firstGunWait
    elseif state==70 then
        if tick(v)<=0 then v[0],v[4]=80,firstGunWait end
    elseif state==80 then
        if alive(o,'gun',v[16])then return end
        arms(b,0);b[68]=spawn(o,'task',0xc1bc620);v[0]=85
    elseif state==85 then
        if alive(o,'task',b[68])then return end
        if b[0x2790]~=0 then v[0],v[4]=90,64;return end
        moveTo(o,b,2,1,270);v[0],v[4]=90,64
    elseif state==90 then
        if not moving(o)then return end
        arms(b,1,7);v[0]=95
    elseif state==95 then
        if tick(v)>0 then return end
        v[20]=spawn(o,'gun',0xc1bf760)
        v[0],v[4]=100,firstGunWait
    elseif state==100 then
        if tick(v)<=0 then v[0],v[4]=110,firstGunWait end
    elseif state==110 then
        if alive(o,'gun',v[20])then return end
        arms(b,0)
        if b[0x2790]~=0 then return end
        v[0],v[4]=0,resetWait
    end
end
-- 第二段以 64 步开场、256 步复位；两组发弹器之间等身体收回，再移动到 y=240。
do
    local initialWait,cycleWait=64,256
    handlers.second_init=function(o,v)
        allocate(o,16);v[0],v[4]=0,initialWait;switch(o,'second')
    end
    handlers.second=function(o,v,b)
        local state=v[0]
        if state==0 then
            if tick(v)>0 then return end
            moveTo(o,b,6,4,220,8);v[0]=10
        elseif state==10 then
            if not moving(o)then return end
            arms(b,1,8);v[0],v[4]=20,0
        elseif state==20 then
            if tick(v)>0 then return end
            v[8]=spawn(o,'gun',0xc1c0b40);v[0],v[4]=30,firstGunWait
        elseif state==30 then
            if tick(v)<=0 then v[0],v[4]=40,firstGunWait end
        elseif state==40 then
            if alive(o,'gun',v[8])then return end
            arms(b,0)
            if b[0x2790]~=0 then return end
            v[0],v[4]=50,retractWait
        elseif state==50 then
            if tick(v)>0 then return end
            arms(b,1,9);spawn(o,'task',0xc1bcea0)
            moveTo(o,b,2,1,240);v[0],v[4]=60,firstGunWait
        elseif state==60 then
            if moving(o)then v[0]=70 end
        elseif state==70 then
            if tick(v)>0 then return end
            v[12]=spawn(o,'gun',0xc1c0c00);v[0],v[4]=80,firstGunWait
        elseif state==80 then
            if alive(o,'gun',v[12])then return end
            arms(b,0)
            if b[0x2790]~=0 then return end
            v[0],v[4]=0,cycleWait
        end
    end
end
-- 第三段终点 140 是原程序的等待状态，最后一组发弹器独立运行到击破，不能擅加循环。
do
    local moveWait=64
    handlers.third_init=function(o,v)
        allocate(o,20);v[0],v[4]=0,0;switch(o,'third')
    end
    handlers.third=function(o,v,b)
        local state=v[0]
        if state==0 then
            moveTo(o,b,6,4,220,8);v[0]=10
        elseif state==10 then
            if moving(o)then v[0],v[4]=20,moveWait end
        elseif state==20 then
            moveTo(o,b,4,4,280,8);v[0]=30
        elseif state==30 then
            if not moving(o)then return end
            arms(b,1,2);v[0],v[4]=40,0
        elseif state==40 then
            if tick(v)>0 then return end
            v[8]=spawn(o,'gun',0xc1c13f0);v[0],v[4]=50,firstGunWait
        elseif state==50 then
            if tick(v)<=0 then v[0],v[4]=60,firstGunWait end
        elseif state==60 then
            if alive(o,'gun',v[8])then return end
            arms(b,0)
            if b[0x2790]~=0 then return end
            v[0],v[4]=70,retractWait
        elseif state==70 then
            if tick(v)>0 then return end
            spawn(o,'task',0xc1bcea0)
            moveTo(o,b,6,6,380)
            arms(b,1,1);invoke(o,'box',3,true)
            v[0],v[4]=80,firstGunWait
        elseif state==80 then
            v[0]=90
        elseif state==90 then
            if tick(v)>0 then return end
            v[12]=spawn(o,'gun',0xc1c14e0);v[0],v[4]=100,firstGunWait
        elseif state==100 then
            if alive(o,'gun',v[12])then return end
            arms(b,0)
            if b[0x2790]~=0 then return end
            invoke(o,'box',3,false);v[0],v[4]=110,firstGunWait
        elseif state==110 then
            if tick(v)>0 then return end
            v[16]=spawn(o,'gun',0xc1c1570);v[0],v[4]=120,firstGunWait
        elseif state==120 then
            v[0]=125
        elseif state==125 then
            if tick(v)<=0 then v[0]=130 end
        elseif state==130 then
            v[0],v[4]=140,firstGunWait
        end
    end
end
-- 两次换段的倒数是并行的，某项归零时爆掉对应零件；同一步允许多项依次归零。
-- 爆件/掉落的公共工厂仍由挂载接口提供，这里保留其原始参数与来源字段。
do
    local firstMeta,secondMeta=0x2694,0x26a8
    local firstSettleWait=60
    local debris,bodyPieces,armPieces,headPieces=0xc31cb64,0xc31c9b4,0xc31ca8c,0xc31cc60
    local function random(o,n)
        local value=invoke(o,'random',n)
        assert(type(value)=='number'and value>=0 and value<=n and value==math.floor(value),'第五面换段随机数越界')
        return value
    end
    local function parts(o,b,kind,meta,tableId,count,x,y,depth)
        invoke(o,'parts',kind,meta,tableId,count,x,y,depth,b[32])
    end
    local function burst(o,b,kind,meta,tableId,count,at,depth)
        parts(o,b,kind,meta,tableId,count,b[at],b[at+4],depth)
    end
    local function rewards(o,b,meta)
        if b[meta]~=1 then return end
        if b[meta+4]==0 then
            local index=invoke(o,'root_field12')
            invoke(o,'reward','create',b[8],b[12],140,index,b[meta+8])
        elseif invoke(o,'player_field80')==1 then
            invoke(o,'reward','resolve',b[meta+8],0,0)
        end
    end
    local function resume(o,b,mode)
        invoke(o,'control',mode)
        b[0x2636],b[0x263c]=0,0
        o.host.request=nil
        invoke(o,'remove')
    end
    handlers.change1_init=function(o,v)
        allocate(o,44);v[0]=0
        invoke(o,'collision',false)
        invoke(o,'hit_effect',1,37)
        invoke(o,'signal','phase_one',1)
        switch(o,'change1')
    end
    handlers.change1=function(o,v,b)
        local depth=assert(o.host.renderDepth,'第五面换段缺少根对象绘图深度')+9
        local state=v[0]
        if state==0 then
            invoke(o,'command',5,95,50,35,0)
            burst(o,b,'scatter',firstMeta,debris,7,8,depth+3)
            burst(o,b,'scatter',firstMeta,bodyPieces,6,8,depth+2)
            burst(o,b,'scatter',firstMeta,armPieces,6,8,depth+2)
            b[36],b[40]=48,(random(o,32)-16)%512
            invoke(o,'command',6,218,125,254,2)
            spawn(o,'task',0xc1bcf20)
            v[4],v[8],v[12]=random(o,4)+4,random(o,4)+7,random(o,4)+10
            v[0]=1
            rewards(o,b,firstMeta)
        elseif state==1 then
            local definitions={{4,0x1dd0,0xc1bd400},{8,0x20c4,0xc1bd0a0},{12,0x2118,0xc1bd130}}
            for _,spec in ipairs(definitions)do
                local a=spec[1]
                if v[a]>0 then
                    v[a]=v[a]-1
                    if v[a]<=0 then
                        burst(o,b,'burst',firstMeta,debris,7,spec[2],depth+1)
                        spawn(o,'task',spec[3],0)
                        if a==4 then
                            b[0x1c68],b[0x1cbc]=b[0x1c68]%65536,b[0x1cbc]%65536
                        elseif a==8 then
                            b[0x1d10]=b[0x1d10]%65536
                            spawn(o,'task',0xc1bcb80)
                        else
                            b[0x1d64]=b[0x1d64]%65536
                            spawn(o,'task',0xc1bcbe0)
                        end
                    end
                end
            end
            if v[4]+v[8]+v[12]~=0 then return end
            v[0],v[4]=2,16
            b[16],b[20]=4,0
            invoke(o,'motion','replace','move_init',4,120*unit,200*unit,24*unit,24*unit)
            v[4]=firstSettleWait
        elseif state==2 then
            if tick(v)>0 then return end
            v[36]=0
            v[36]=spawn(o,'task',0xc1bc6a0)
            spawn(o,'task',0xc1bc710)
            v[0],v[4]=3,0
        elseif state==3 then
            if alive(o,'task',v[36])or tick(v)>0 then return end
            resume(o,b,'second_init')
        end
    end
    handlers.change2_init=function(o,v)
        allocate(o,44);v[0],v[36]=0,0
        invoke(o,'collision',false)
        switch(o,'change2')
        invoke(o,'signal','phase_two',1)
    end
    local function reposition(o,v)
        v[32]=1
        invoke(o,'motion','replace','move_init',2,120*unit,220*unit,24*unit,24*unit)
    end
    handlers.change2=function(o,v,b)
        local depth=assert(o.host.renderDepth,'第五面换段缺少根对象绘图深度')+9
        local state=v[0]
        if state==0 then
            invoke(o,'command',5,95,50,35,0)
            invoke(o,'command',6,217,125,254,2)
            parts(o,b,'burst',secondMeta,debris,7,b[8],b[12]-32*unit,depth+1)
            parts(o,b,'burst',secondMeta,bodyPieces,6,b[8],b[12]-32*unit,depth)
            parts(o,b,'burst',secondMeta,armPieces,6,b[8],b[12]-32*unit,depth)
            invoke(o,'parts_control',0xc1bbbc0)
            invoke(o,'parts_control',0xc1bbd30)
            invoke(o,'parts_control',0xc1bbda0)
            spawn(o,'task',0xc1bcf20)
            v[4],v[8],v[12]=random(o,4)+4,random(o,4)+10,random(o,4)+16
            v[16],v[20],v[0]=0,0,1
            b[36],b[40]=64,random(o,32)+496
            v[32]=0
            v[40]=spawn(o,'task',0xc1bc490)
            parts(o,b,'scatter',secondMeta,headPieces,7,b[8]+b[0x128],b[12]+b[0x12c],depth+1)
            rewards(o,b,secondMeta)
        elseif state==1 then
            if b[36]==0 and v[32]==0 then reposition(o,v)end
            for _,spec in ipairs({{4,0x1f74,0xc1bd1c0,2},{8,0x1fc8,0xc1bd250,2},{12,0x1dd0,0xc1bd4a0,1}})do
                local a=spec[1]
                if v[a]>0 then
                    v[a]=v[a]-1
                    if v[a]<=0 then
                        burst(o,b,'scatter',secondMeta,debris,7,spec[2],depth+spec[4])
                        spawn(o,'task',spec[3],1)
                    end
                end
            end
            if v[4]+v[8]+v[12]+v[16]+v[20]==0 then v[0],v[4]=2,10 end
        elseif state==2 then
            if b[36]==0 and v[32]==0 then reposition(o,v)end
            if tick(v)<=0 then v[0],v[4]=3,16 end
        elseif state==3 then
            if b[36]==0 and v[32]==0 then reposition(o,v)end
            if alive(o,'task',v[40])or tick(v)>0 then return end
            v[36]=0
            v[36]=spawn(o,'task',0xc1bca80)
            spawn(o,'task',0xc1bc980);spawn(o,'task',0xc1bca00)
            b[0x1d0c]=2
            v[0],v[4]=4,0
        elseif state==4 then
            if alive(o,'task',v[36])or b[0x21f8]~=2 or tick(v)>0 then return end
            resume(o,b,'third_init')
        end
    end
end
dofile('mod/GAME/th46/boss5_defeat.lua'){
    handlers=handlers,source=source,invoke=invoke,spawn=spawn,allocate=allocate,switch=switch,
}
Slot=Class(object,{
    init=function(o,manager,mode,index)
        o.manager,o.host,o.run,o.index=manager,manager.host,manager.run,index
        o.mode,o.closed=mode,false
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
        o.vars=setmetatable({},{
            __index=function(_,a)return parameters.read(assert(o.block),a,4)end,
            __newindex=function(_,a,n)parameters.write(assert(o.block),a,4,n)end,
        })
    end,
    frame=function()end,
})
local function step(manager)
    if manager.closed or manager.serial==manager.run.serial then return end
    manager.serial=manager.run.serial
    for i=1,5 do
        local o=manager.slots[i]
        if o then
            if manager.api.beforeSlot then manager.api.beforeSlot(o.host,o)end
            handlers[o.mode](o,o.vars,o.host.raw)
            if manager.api.afterSlot then manager.api.afterSlot(o.host,o)end
        end
    end
end
Manager=Class(object,{
    init=function(o,host,api)
        assert(not host.controlGroup,'第五面只能有一份主任务管理器')
        assert(host.raw and host.raw[28]==0,'第五面主任务目前只支持 Original')
        o.host,o.run,o.api,o.slots=host,host.run,api or {},{}
        o.pool=host.nativeParameters or parameters.create();host.nativeParameters=o.pool
        o.serial,o.closed=host.run.serial,false
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
        host.controlGroup=o
    end,
    -- 协调对象在移动后执行主任务；引擎对象遍历不得自行抢跑。
    frame=function()end,
})
return {
    source=source,parameters=parameters,
    fields={8,12,16,20,28,32,36,40,64,68,0x128,0x12c,0x1d10,0x1d64,0x1c68,0x1cbc,
        0x1dd0,0x1dd4,0x20c4,0x20c8,0x2118,0x211c,0x1f74,0x1f78,0x1fc8,0x1fcc,
        0x1d0c,0x21f8,0x2634,0x2636,0x263c,0x2788,0x278c,0x2790},
    create=function(host,api,mode)
        local manager=New(Manager,host,api);add(manager,mode or'entry_init');return manager
    end,
    add=add,step=step,
    transition=function(manager,phase)
        assert(not manager.closed and phase>=1 and phase<=3,'第五面换段/击破请求无效')
        local b=manager.host.raw
        local meta=0x2694+(phase-1)*20
        if phase==3 then call(manager,nil,'collision',{false})end
        -- c1b01a0 在撤销任务前提交消弹窗口；超时和射击来源走不同入口。
        if b[meta]==2 then
            call(manager,nil,'bullet_cancel',{0xc06d5d0,96})
        else
            local a,c,d=0,0,0
            if b[meta+4]~=0 and call(manager,nil,'player_field80',{})==1 then
                a,c,d=b[meta+8],b[meta+4],b[meta+16]
            end
            call(manager,nil,'bullet_cancel',{0xc06d6a0,96,a,c,d})
        end
        if phase==3 then call(manager,nil,'service',{0xc078a50})end
        -- c078020 清的是 30 个发弹槽；移动槽保留，不能把当前姿态和移动历史一起销毁。
        call(manager,nil,'clear',{'gun'})
        call(manager,nil,'clear_control',{})
        call(manager,nil,'clear',{'task'})
        return call(manager,nil,'control',{transitionModes[phase]})
    end,
    close=function(manager)
        if not manager or manager.closed then return end
        manager.closed=true
        for i=1,5 do if manager.slots[i]then closeSlot(manager.slots[i])end end
        if manager.api.close then manager.api.close(manager.host)end
        if manager.host.controlGroup==manager then manager.host.controlGroup=nil end
        object.RawDel(manager)
    end,
}
