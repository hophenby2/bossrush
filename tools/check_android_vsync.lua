-- 使用实际适配器与设置回调，核对开关传到EGL接口和Java调度器，不读写玩家设置。
local nativeCalls,javaCalls={},{}
local env=setmetatable({native={AndroidSetVsync=function(v) nativeCalls[#nativeCalls+1]={v} end,
    SystemLog=function() error('设置接口不应报错') end}}, {__index=_G})
env.expose=function(name,fn) env[name]=fn end
env.require=function(name)
    assert(name=='cocos.cocos2d.luaj')
    return {callStaticMethod=function(class,method,values,signature)
        assert(class=='org/bossrush/hd/BossRushActivity' and method=='configureVsync' and signature=='(Z)V')
        javaCalls[#javaCalls+1]={values[1]};return true
    end}
end
local f=assert(io.open('android/lua/compat.lua','rb'));local source=f:read('*a');f:close()
local start=assert(source:find("expose('SetVsync',",1,true))
local stop=assert(source:find("expose('ChangeVideoMode',",start,true))
local code=assert(loadstring(source:sub(start,stop-1)));setfenv(code,env);code()
env.SetVsync(false);env.SetVsync(true);env.SetVsync(false)
for i,expected in ipairs({false,true,false}) do
    assert(nativeCalls[i][1]==expected and javaCalls[i][1]==expected,'同步开关必须同时传到EGL与帧调度')
end
f=assert(io.open('android/lua/main.lua','rb'));source=f:read('*a');f:close()
start=assert(source:find('function ChangeVideoMode2(s)',1,true))
stop=assert(source:find('function setting_keys_default()',start,true))
code=assert(loadstring(source:sub(start,stop-1)));setfenv(code,env);code()
env.cur_setting={vsync=false};assert(env.ChangeVideoMode2())
assert(nativeCalls[4][1]==false and javaCalls[4][1]==false,'设置面板回调必须立即应用关闭值')
env.cur_setting.vsync=true;assert(env.ChangeVideoMode2())
assert(nativeCalls[5][1]==true and javaCalls[5][1]==true)
print('垂直同步开关→EGL接口/Java调度器、设置面板即时应用检查通过')
