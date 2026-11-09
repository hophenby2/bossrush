-- 使用实际 profiler，核对递归、逐帧百分位和原生 ANM 绘制覆盖。
local now,logs=0,{}
local function noop() end
lstg={AndroidClock=function() return now end,SystemLog=function(s) logs[#logs+1]=s end}
AndroidRenderSprite=function() now=now+.001 end
lstg.AndroidRenderSprite=AndroidRenderSprite
ObjFrame=function() return 1,nil,3 end
OriginalCollision={begin=noop,shots=noop,secondary=noop,finish=noop}
OriginalANM={step=function(n) now=now+.001;if n>0 then OriginalANM.step(n-1) end end,draw=noop}
local P=dofile('android/lua/profiler.lua')
local a,b,c=ObjFrame();assert(a==1 and b==nil and c==3)
OriginalANM.step(2);lstg.AndroidRenderSprite();P.frame(.004,0)
for i=2,100 do P.frame(.001,(i-1)*.01) end
P.report(100)
local text=table.concat(logs,'\n')
assert(text:find('anm.step=0.030/0.000/0.000ms,0.0calls',1,true),text)
assert(text:find('native.AndroidRenderSprite=0.010/0.000/0.000ms',1,true),text)
assert(text:find('frame.cpu=1.030/1.000/1.000ms',1,true),text)
assert(text:find('frame.interval=9.900/10.000/10.000ms',1,true),text)
for i=1,3 do OriginalANM.step(0);P.frame(.001) end
P.report(3)
assert(P.samples['anm.step'].depth==0 and #P.samples['anm.step'].frames==0)
print('安卓性能计时通过：递归去重、逐帧百分位、原生精灵与窗口重置。')
