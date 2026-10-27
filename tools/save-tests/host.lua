-- 两个独立进程模拟两个游戏实例；API、传输与存储均使用正式实现。
local R=dofile(assert(arg[1])..'/tools/save-tests/runtime.lua');local C,P,N=R.C,R.P,R.N
P.init(); local S=R.load('service');S.start(tonumber(arg[3]));S.visible=true;S.heartbeat=N.now();S.pairRaw=C.random(16);S.pairToken=C.base64(S.pairRaw);S.pairExpires=N.now()+600
local f=assert(io.open('host.json','w'));f:write(Serialize({port=S.server.port,token=S.localToken,code=S.code('127.0.0.1',S.server.port,S.pairRaw)}));f:close()
print('测试存档服务已就绪，端口 '..S.server.port);io.stdout:flush()
if R.ffi.os=='Windows' then R.ffi.cdef[[void Sleep(unsigned long);]] else R.ffi.cdef[[int usleep(unsigned int);]] end
while true do S.poll();if R.ffi.os=='Windows' then R.ffi.C.Sleep(1) else R.ffi.C.usleep(1000) end end
