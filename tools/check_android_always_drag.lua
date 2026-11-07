-- 执行实际自机frame及输入位移函数，覆盖死亡、锁定、硬锁与单帧限速；不读写玩家数据。
local function section(file,first,last)
    local f=assert(io.open(file,'rb'));local source=f:read('*a');f:close()
    local start=assert(source:find(first,1,true))
    local stop=last and assert(source:find(last,start+#first,true)) or #source+1
    assert(loadstring(source:sub(start,stop-1),'@'..file))()
end
lstg={var={__touch_always_version=1,__touch_unlimited=true},world={pl=-192,pr=192,pb=-224,pt=224}}
KeyState={touch_x=80,touch_y=100,touch_unlimited=true}
section('THlib/lib/Linput.lua','function TouchInputMovement')
player_class={};task={Do=function() end}
section('THlib/player/player.lua','function player_class:frame()','function player_class:render()')
local function player(death,lock,hard,normal)
    local p={x=0,y=0,death=death,lock=lock,realrealreal_lock=hard,hspeed=4,lspeed=2,slow=1,protect=120,graysmear={}}
    p._playersys={doFrameBeforeEvent=function() end,doFrameAfterEvent=function() end,frame=function()
        if normal and not p.lock then
            local dx,dy=TouchInputMovement(p,KeyState,2)
            if dx then p.x,p.y=p.x+dx,p.y+dy end
        end
    end}
    return p
end
for _,death in ipairs({100,90,84,50,49,1,0}) do
    for _,mode in ipairs({{false,false,true},{true,false,false},{false,true,false},{false,false,false}}) do
        local p=player(death,unpack(mode));player_class.frame(p)
        assert(p.x==80 and p.y==100,'死亡/锁定/拍照等停止普通移动时仍应拖动')
    end
end
KeyState.touch_unlimited=false
for _,normal in ipairs({true,false}) do
    local p=player(90,not normal,false,normal)
    for _=1,5 do
        local x,y=p.x,p.y;player_class.frame(p)
        local distance=math.sqrt((p.x-x)^2+(p.y-y)^2)
        assert(math.abs(distance-2)<1e-8,'限速拖动每逻辑帧只能移动一次')
    end
end
KeyState={};local p=player(90,true,false,false);player_class.frame(p)
assert(p.x==0 and p.y==0,'松手后不保留拖动')
KeyState={touch_x=80,touch_y=100,touch_unlimited=true}
lstg.var.__touch_always_version=nil
p=player(90,true,false,false);player_class.frame(p)
assert(p.x==0 and p.y==0,'旧录像保持原锁定规则')
print('死亡全阶段/锁定/硬锁拖动、单帧限速、松手及旧录像兼容检查通过')
