-- 发行包全部自机粒子的实际参数、绘制数值和停止后的自然回收；不代替原生画面对照。
local function noop() end
GetResourceStatus=function() return 'global' end
SetResourceStatus,LoadTexture,LoadImage,SetImageState=noop,noop,noop,noop
local draws=0
Render4V=function(_,...) for _,v in ipairs({...}) do assert(v==v and math.abs(v)<1e12,'粒子顶点出现无效值') end;draws=draws+1 end
local P=dofile('mod/GAME/th38/particles.lua')
local t={position={x=4.5,y=-4.8,z=0},lossyScale={x=1,y=1,z=1},eulerAngles={z=0}}
local count=0
for _,rows in pairs(P.data.prefabs) do for path,cfg in pairs(rows) do
    local ps=P.new(cfg,t);ps:Play()
    for tick=1,240 do ps:FixedUpdate();ps:Render() end
    assert(#ps.particles<=cfg.InitialModule.maxNumParticles,path)
    if cfg.ShapeModule.type==6 then assert(#ps.particles==0,'空网格产生了原作没有的粒子') end
    ps:Stop()
    local maximum=0
    for _,p in ipairs(ps.particles) do maximum=math.max(maximum,p.life-p.age) end
    for tick=1,math.ceil(maximum*120/cfg.simulationSpeed)+1 do ps:FixedUpdate() end
    assert(#ps.particles==0,'停止后的粒子没有按寿命回收：'..path)
    ps:Play();ps:FixedUpdate();ps:Dispose();assert(not ps.isPlaying and #ps.particles==0)
    count=count+1
end end
assert(count==64 and draws>0)
print('PASS 雪莲华 '..count..' 个原作粒子组件，'..draws..' 次绘制数值及自然回收')
