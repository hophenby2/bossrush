-- 数值取自四套 C# 控制器及两套 Lua player.move；覆盖相反键优先级与对角速度。
lstg={world={pl=-192,pr=192,pb=-224,pt=224}}
local move=dofile('THlib/native_player_movement.lua')
local cases={
    {35,4.5,2,{right=true,left=true,up=true,down=true},4.5/math.sqrt(2),-4.5/math.sqrt(2)},
    {36,4.32,1.92,{right=true,left=true,up=true,down=true},-4.32*.7071,-4.32*.7071},
    {37,25/6,2,{right=true,up=true},25/6/math.sqrt(2),25/6/math.sqrt(2)},
    {38,4.5,2,{right=true,up=true},3.195,3.195},
    {38,4.5,2,{right=true,left=true,up=true},0,4.5},
    {39,4.5,2,{right=true,up=true},4.5/math.sqrt(2),4.5/math.sqrt(2)},
    {41,4.4,2.1,{right=true,up=true},4.4/math.sqrt(2),4.4/math.sqrt(2)},
}
for _,c in ipairs(cases) do
    local p={native_level=c[1],hspeed=c[2],lspeed=c[3],_playersys={keyState=c[4]},x=0,y=0,slow=0}
    move.step(p,{})
    assert(math.abs(p.x-c[5])<1e-8 and math.abs(p.y-c[6])<1e-8,tostring(c[1]))
    p.lock=true;move.step(p,{})
    assert(p.__move_dx==0 and p.__move_dy==0)
end
print('六作方向键优先级、对角速度与移动锁通过')
