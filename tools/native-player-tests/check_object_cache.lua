local cache,prune,clear=dofile('mod/GAME/ports/object_cache.lua')(function(o) return o.live end,128)
local alive={}
for i=1,1000 do local o={live=true};alive[i]=o;cache[o]={object=o,index=i} end
for i=1,3000 do local o={live=false};cache[o]={object=o} end
collectgarbage('collect');collectgarbage('collect')
local count=0;for _ in pairs(cache) do count=count+1 end
assert(count==4000,'该夹具未覆盖 LuaJIT 弱键反向引用环')
for i=1,100 do
    -- 扫描游标跨帧期间插入新键，覆盖重哈希，不得把已删除键传回 next。
    local o={live=false};cache[o]={object=o};prune()
end
for i=1,40 do prune() end
count=0;for o,v in pairs(cache) do count=count+1;assert(o.live and v.index and alive[v.index]==o) end
assert(count==1000,'存活代理被清理或失效代理仍滞留')
for _,o in ipairs(alive) do assert(cache[o].object==o) end
for _,o in ipairs(alive) do o.live=false end
for i=1,20 do prune() end
assert(next(cache)==nil,'全释放后缓存未清空')
clear();prune();assert(next(cache)==nil)
print('对象代理缓存反向引用环、存活身份、分帧清理和插入重哈希检查通过。')
