-- 原生对象的独立逐帧采样；复用公共桩件，输出供C#参考结果核对。
local pattern,frames,seed=arg[1],tonumber(arg[2]) or 300,tonumber(arg[3]) or 1
arg[1]='th38-native-snapshot'
local f=assert(io.open('tools/check_stage.lua','rb'));local s=f:read('*a');f:close()
assert(loadstring(s:sub(1,assert(s:find('if path == "--all" then',1,true))-1)))()
local N=dofile('mod/GAME/th40/native.lua');N.load()
lstg.var.th38_seed=seed;player.x,player.y=0,-160
local owner={x=0,y=100,hp=10000};local run=N.new(owner,{hp=10000})
N.controller(run.host,pattern,false)
for _=1,frames do N.step(run) end
local out={}
for _,b in ipairs(run.objects) do
    if IsValid(b) and not b.th38_removed and not b.emitter then
        out[#out+1]=string.format('{"id":%d,"age":%d,"x":%.9f,"y":%.9f,"speed":%.9f,"direction":%.9f,"width":%.9f,"height":%.9f,"alpha":%.9f}',b.id or 0,b.age,b.cx,b.cy,b.speed,b.direction,b.width,b.height,b.alpha)
    end
end
print('['..table.concat(out,',')..']')
N.stop(owner)
for _,o in ipairs(run.objects) do assert(o.th38_removed,'阶段结束必须回收原生对象') end
