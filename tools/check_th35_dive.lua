-- 独立文件不继承调用者local：真实TH35装载及相机全曲线回归，禁止全局class兜底。
arg={'th35-dive'}
local f=assert(io.open('tools/check_stage.lua','rb'));local setup=f:read('*a');f:close()
assert(loadstring(setup:sub(1,assert(setup:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/anm/original.lua');dofile('mod/GAME/th35.lua')
local class=_editor_class.TH35
local checks=0
local function check(v,msg) assert(v,msg);checks=checks+1 end
check(_G.class==nil,'测试环境不能提供全局class掩盖作用域错误')
local root={__t10frames=0,t10_in_update=true}
local o={t10_root=root,ecs={off={x=0,y=160},base={x=0,y=0},wx=0,wy=160}}
local H=class.t10_dive
H.attach(o)
local c=root.t10_stage04_camera
check(c.age==0 and c.clock==1,'出生时相机必须实际执行第一拍')
check(c.p[2]==.5 and c.p[3]== -549.5,'STD首拍线性内插坐标改变')
local function finite(n) return n==n and n>-math.huge and n<math.huge end
for frame=1,9000 do
    root.__t10frames=frame
    H.step(o)
    H.sync(o)
    check(finite(o.x) and finite(o.y),'相机曲线或回环产生非法投影：'..frame)
end
check(c.age==9000 and c.clock==8745,'8944→8688的原作相机回环未执行')
check(not pcall(function() assert(loadfile('mod/GAME/th35_dive.lua'))() end),'缺少上下文应在模块加载时明确报错')
local calls=0
local isolated={t10_motion_f32=function(n) calls=calls+1;return class.t10_motion_f32(n) end,
    t10_motion_ease=class.t10_motion_ease}
local module=assert(loadfile('mod/GAME/th35_dive.lua'))(isolated)
module.attach({ecs={off={x=0,y=0}}})
check(calls>0,'模块必须使用显式传入的运动上下文')
check(_G.class==nil,'模块不能向全局写class')
print(('TH35下潜相机回归通过：%d项，覆盖出生、投影与STD回环。'):format(checks))
