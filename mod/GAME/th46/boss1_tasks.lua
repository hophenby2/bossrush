-- 第一面关底的二十槽演出任务：入场、受伤叠加、中央及双侧关节动画、抬头与摆动。
-- 任务仍是 LuaSTG 对象；共享管理器按原槽位扫描，父任务以 closed 查询真实结束状态。
-- 图形分配、声音和画面效果交给具名原生接口；未移植的特效不能偷偷以等待若干帧替代。
local object=object
local unit=65536
local vector=dofile('mod/GAME/th46/direction.lua').vector
local source={enter_init=0xc154a10,enter=0xc1548a0,flash_init=0xc154c80,
    flash_resume=0xc154ce0,flash=0xc1569e0,tilt_init=0xc156130,tilt=0xc157b00,
    arm_left=0xc155060,arm_right=0xc1550d0,arm_extend=0xc154ff0,
    arm_left_reset=0xc1551c0,arm_right_reset=0xc155230,arm_retract=0xc155140,
    reset_init=0xc154ee0,reset=0xc154e40,central_init=0xc154dc0,central=0xc154d30,
    expand_init=0xc155660,expand=0xc1555c0,relax_init=0xc155750,relax=0xc1556d0,
    pose_init=0xc1558e0,pose_down=0xc1557b0,pose_up=0xc155850,
    leap_smoke_init=0xc155ea0,leap_smoke=0xc157150}
local handlers={}
local Slot,Manager
local function closeSlot(o)
    if o.closed then return end
    o.closed=true
    if o.manager.slots[o.index]==o then o.manager.slots[o.index]=nil end
    object.RawDel(o)
end
local function add(manager,mode,config)
    assert(source[mode],'关底演出任务入口未移植：'..tostring(mode))
    for i=1,20 do
        if not manager.slots[i]then
            local o=New(Slot,manager,mode,config,i);manager.slots[i]=o;return o
        end
    end
    return 0
end
local function invoke(o,kind,...)
    local args={...}
    local result
    if kind=='spawn'then result=add(o.manager,args[1],args[2])
    else result=assert(o.manager.api.invoke,'关底演出缺少原生效果接口')(o.host,kind,args,o)end
    if o.manager.api.observe then o.manager.api.observe(o.host,kind,args,result,o)end
    return result
end
local function spawn(o,mode,config)return invoke(o,'spawn',mode,config or {})end
local function switch(o,mode)o.mode=mode end
local function depth(o)
    local value=assert(o.host.renderDepth,'关底演出缺少绘制深度')
    return value
end

handlers.leap_smoke_init=function(o,v)
    v[0],v[12],v[16]=0,0,1
    switch(o,'leap_smoke')
end
handlers.leap_smoke=function(o,v,b)
    if v[0]==0 then v[0],v[4]=1,0 end
    if v[0]~=1 and v[0]~=2 then return end
    if v[0]==1 then
        v[12]=v[12]-1
        if v[12]<0 then
            v[12]=v[16]
            -- 两份烟粒子及两份 3 类地面飞沫由效果工厂分配，共用原版随机序列。
            invoke(o,'leap_dust',b[0x1b7c],b[0x1b80],depth(o))
        end
    end
    local angle=v[4]>288 and 704-v[4]or v[4]+128
    local _,y=vector(0x4000,angle)
    b[0x18e4]=y
    v[4]=v[4]+(v[4]<=128 and 2 or v[4]<=288 and 24 or 1)
    if v[0]==1 and v[4]>176 then v[0]=2;invoke(o,'sound',5)end
    if v[4]>288 then closeSlot(o)end
end

handlers.enter_init=function(o,v,b)
    v[0],v[4]=0,1
    b[8],b[12],b[28],b[32]=120*unit,372*unit,0,0
    b[48],b[52],b[88]=64,256,15
    spawn(o,'pose_init',{0})
    invoke(o,'strip','enter_small',4,120*unit,192*unit,depth(o)+9)
    invoke(o,'sound',4)
    b[76],b[80]=320,1
    if b[0x1ac0]==0 or b[0x1ac0]==2 then spawn(o,'central_init')end
    switch(o,'enter')
end
handlers.enter=function(o,v,b)
    if v[0]==0 then
        v[4]=v[4]-1
        if v[4]>=0 then return end
        v[0],v[4],v[8]=1,20,0
        invoke(o,'screen_begin',0,0,0x0a000000)
        invoke(o,'screen_ramp',0,256,80)
        invoke(o,'strip','enter_large',12,120*unit,192*unit,depth(o)+8)
        invoke(o,'scatter','enter_dust',29,120*unit,192*unit,depth(o)+7)
    elseif v[0]==1 then
        v[4]=v[4]-1
        if v[4]>=0 then return end
        invoke(o,'footprints',0,1)
        v[0],v[4]=10,12
        b[48],b[52]=80,256
    elseif v[0]==10 then
        v[4]=v[4]-1
        if v[4]>=0 then return end
        spawn(o,'reset_init');closeSlot(o)
    end
end

local function flashInit(o,_,b,resume)
    b[0x22e0]=255
    if not resume then b[0x22e4]=0xffffff end
    invoke(o,'overlay',resume and'enable'or'create')
    switch(o,'flash')
end
handlers.flash_init=function(o,v,b)flashInit(o,v,b,false)end
handlers.flash_resume=function(o,v,b)flashInit(o,v,b,true)end
handlers.flash=function(o,_,b)
    b[0x22e0]=b[0x22e0]-8
    if b[0x22e0]>0 then return end
    b[0x22e0]=0;invoke(o,'overlay','disable');closeSlot(o)
end

handlers.tilt_init=function(o,v,b)
    v[0],v[4],v[8],v[12]=0,o.config[2],1,o.config[1]
    b[0x354]=0
    switch(o,'tilt')
end
handlers.tilt=function(o,v,b)
    if v[0]==0 then
        if v[4]~=0 then
            v[4]=v[4]-1;if v[4]<=0 then v[4]=0 end;return
        end
        v[8]=v[8]-1;if v[8]>=0 then return end
        v[8]=1;b[0x354]=b[0x354]+1
        if b[0x354]>8 then v[0]=1 end
    elseif v[0]==1 then
        v[8]=v[8]-1;if v[8]>=0 then return end
        v[8]=1;b[0x354]=b[0x354]-1
        if b[0x354]>0 then return end
        b[0x354]=0;v[12]=v[12]-1
        if v[12]>0 then v[0]=0 else closeSlot(o)end
    end
end

local function armInit(o,v,b,part,retract)
    v[4],v[8],v[12]=part,2,2
    b[part+64]=retract and 2 or 1
    switch(o,retract and'arm_retract'or'arm_extend')
end
handlers.arm_left=function(o,v,b)armInit(o,v,b,0x1ad0,false)end
handlers.arm_right=function(o,v,b)armInit(o,v,b,0x1b20,false)end
handlers.arm_left_reset=function(o,v,b)armInit(o,v,b,0x1ad0,true)end
handlers.arm_right_reset=function(o,v,b)armInit(o,v,b,0x1b20,true)end
handlers.arm_extend=function(o,v,b)
    local at=v[4]
    if b[at+64]~=1 then closeSlot(o);return end
    v[8]=v[8]-1;if v[8]>0 then return end
    v[8]=v[12];b[at]=b[at]+1
    if b[at]>23 then b[at]=23;closeSlot(o)end
end
handlers.arm_retract=function(o,v,b)
    local at=v[4]
    if b[at+64]~=2 then closeSlot(o);return end
    v[8]=v[8]-1;if v[8]>0 then return end
    v[8]=v[12];b[at]=b[at]-1
    if b[at]<=0 then b[at],b[at+64]=0,0;closeSlot(o)end
end

handlers.central_init=function(o,v,b)
    v[4],v[8],v[12]=0x1a80,3,3
    b[0x1ac0]=1
    spawn(o,'expand_init');switch(o,'central')
end
handlers.central=function(o,v,b)
    local at=v[4]
    if b[at+64]~=1 then closeSlot(o);return end
    v[8]=v[8]-1;if v[8]>0 then return end
    v[8]=v[12];b[at]=b[at]+1
    if b[at]<=7 then return end
    b[at],b[at+64],b[at+48],b[at+70]=7,3,256,1
    closeSlot(o)
end
handlers.reset_init=function(o,v,b)
    v[4],v[8],v[12]=0x1a80,5,5
    b[0x1ac0]=b[0x1ab0]==256 and 2 or 3
    b[76],b[80]=256,2
    spawn(o,'relax_init');switch(o,'reset')
end
handlers.reset=function(o,v,b)
    local at=v[4]
    if b[at+64]==3 then
        if b[at+48]~=256 then return end
        b[at+64]=2
    end
    if b[at+64]~=2 then closeSlot(o);return end
    v[8]=v[8]-1;if v[8]>0 then return end
    v[8]=v[12];b[at]=b[at]-1
    if b[at]<=0 then b[at],b[at+64]=0,0;closeSlot(o)end
end
handlers.expand_init=function(o,v,b)
    b[0x16ac]=1;v[4],v[8]=0,0;switch(o,'expand')
end
handlers.expand=function(o,v,b)
    if b[0x16ac]~=1 then closeSlot(o);return end
    v[4]=v[4]-1;if v[4]>0 then return end
    v[4]=v[8]
    b[0x169c]=b[0x169c]+(b[0x169c]>127 and 7 or 5)
    if b[0x169c]>239 then b[0x169c]=240;closeSlot(o)end
end
handlers.relax_init=function(o,v,b)
    b[0x16ac]=0;v[4],v[8]=0,0;switch(o,'relax')
end
handlers.relax=function(o,v,b)
    if b[0x16ac]~=0 then closeSlot(o);return end
    v[4]=v[4]-1;if v[4]>0 then return end
    v[4]=v[8];b[0x169c]=b[0x169c]-4
    if b[0x169c]<=0 then b[0x169c]=0;closeSlot(o)end
end

handlers.pose_init=function(o,v,b)
    v[4],v[8],v[12]=o.config[1],o.config[1],b[88]
    switch(o,b[84]<b[88]and'pose_up'or'pose_down')
end
local function poseStep(o,v,b,up)
    if v[12]~=b[88]then closeSlot(o);return end
    v[4]=v[4]-1;if v[4]>0 then return end
    v[4]=v[8]
    if up then
        b[84]=b[84]+1
        if b[84]>=b[88]then b[84]=b[88];closeSlot(o)
        elseif b[84]>14 then b[84]=15;closeSlot(o)end
    else
        b[84]=b[84]-1
        if b[84]<=b[88]then b[84]=b[88];closeSlot(o)
        elseif b[84]<=0 then b[84]=0;closeSlot(o)end
    end
end
handlers.pose_up=function(o,v,b)poseStep(o,v,b,true)end
handlers.pose_down=function(o,v,b)poseStep(o,v,b,false)end

local function stepSlot(o)
    if o.closed or o.serial==o.run.serial then return end
    o.serial=o.run.serial
    if o.manager.api.beforeSlot then o.manager.api.beforeSlot(o.host,o)end
    handlers[o.mode](o,o.vars,o.host.raw)
    o.host.boardX,o.host.boardY=o.host.raw[8],o.host.raw[12]
    o.host.x,o.host.y=o.host.boardX/unit-120,o.host.boardY/unit-160
    if o.manager.api.afterSlot then o.manager.api.afterSlot(o.host,o)end
end
Slot=Class(object,{
    init=function(o,manager,mode,config,index)
        o.manager,o.host,o.run,o.mode,o.index=manager,manager.host,manager.run,mode,index
        o.config,o.vars={},{}
        for i,value in ipairs(config or {})do o.config[i]=value end
        for at=0,124,4 do o.vars[at]=0 end
        o.closed,o.serial=false,-1
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
    end,
    frame=function()end,
})
local function step(manager)
    if manager.closed or manager.serial==manager.run.serial then return end
    manager.serial=manager.run.serial
    for i=1,20 do if manager.slots[i]then stepSlot(manager.slots[i])end end
end
Manager=Class(object,{
    init=function(o,host,api)
        assert(not host.taskGroup,'关底只能有一份二十槽演出管理器')
        o.host,o.run,o.api,o.slots=host,host.run,api or {},{}
        o.closed,o.serial=false,host.run.serial
        o.group,o.bound,o.colli,o.hide=GROUP.GHOST,false,false,true
        host.taskGroup=o
    end,
    frame=step,
})
return {
    source=source,
    fields={{8,4},{12,4},{28,4},{32,4},{48,4},{52,4},{76,4},{80,4},{84,4},{88,4},
        {0x354,4},{0x169c,4},{0x16ac,4},{0x18e4,4},{0x1a80,4},{0x1ab0,4},{0x1ac0,4},{0x1ac6,2},
        {0x1ad0,4},{0x1b10,4},{0x1b20,4},{0x1b60,4},{0x1b7c,4},{0x1b80,4},{0x22e0,4},{0x22e4,4}},
    create=function(host,api)return New(Manager,host,api)end,
    spawn=add,step=step,stepSlot=stepSlot,
    alive=function(o)return o~=nil and o~=0 and not o.closed end,
    close=function(o)
        if not o or o.closed then return end
        o.closed=true
        for i=1,20 do if o.slots[i]then closeSlot(o.slots[i])end end
        if o.api.close then o.api.close(o.host)end
        if o.host.taskGroup==o then o.host.taskGroup=nil end
        object.RawDel(o)
    end,
}
