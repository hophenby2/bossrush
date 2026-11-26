-- 正式发弹入口检查事件增删字段、当前值快照与每颗弹独立状态。
arg={'th39-emission-copy'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th39/runtime.lua')
local c=R.controller({_live=true,x=0,y=100},'146')
local emitter=c.emitters[1]
emitter.bindid,emitter.tiao,emitter.type=-1,1,52
emitter.sonspeed,emitter.alpha,emitter.wscale=3,100,1
local objects={}
local original=New
New=function(cls,s,...)
    local b=original(cls,s,...);objects[#objects+1]=b;return b
end
local function shot()
    R.fire(emitter)
    return assert(objects[#objects].mhj)
end
local first=shot()
emitter.sonspeed,emitter.alpha,emitter.wscale=7,87,1.7
emitter.eventMarker=739
local second=shot()
assert(first.sonspeed==3 and first.alpha==100 and first.wscale==1,'后续发射器事件污染旧弹体')
assert(second.sonspeed==7 and second.alpha==87 and second.wscale==1.7 and second.eventMarker==739,'当前状态或事件新增字段未复制')
assert(first.changes~=second.changes and first.limits~=second.limits,'弹体共享插值或次数限制表')
emitter.eventMarker=nil
local third=shot()
assert(third.eventMarker==nil,'已删除的事件字段仍被复制')
emitter.eventMarker=940
emitter.sharedSpec={739}
local fourth=shot()
assert(fourth.eventMarker==940 and fourth.sharedSpec==emitter.sharedSpec,'字段重新加入或浅拷贝语义错误')
emitter[1]='numeric'
local fifth=shot()
assert(fifth[1]=='numeric','非字符串字段回退复制遗漏')
New=original
R.clear(c)
print('PASS 永夜正式发弹：当前值快照、动态增删/重新加入字段、独立插值/限制表、浅拷贝与通用回退')
