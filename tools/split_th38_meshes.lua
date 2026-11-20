-- 将既有导出数值按网格拆分；逐字段确认拆分前后完全相同，不重新取样或简化几何。
local path='mod/GAME/th38/scenes/'
local source=dofile(arg[1] or path..'meshes.lua')
local meta=getmetatable(source)
if meta and meta.__index then
    for i=1,100 do
        local name,files=debug.getupvalue(meta.__index,i)
        if not name then break end
        if name=='files' then for key in pairs(files) do local _=source[key] end;break end
    end
end
local keys={};for key in pairs(source) do keys[#keys+1]=key end;table.sort(keys)
local function literal(value)
    if type(value)=='number' then
        local short=('%.8g'):format(value)
        return tonumber(short)==value and short or ('%.17g'):format(value)
    end
    if type(value)=='string' then return ('%q'):format(value) end
    if type(value)=='boolean' then return tostring(value) end
    local count,array=0,true
    for key in pairs(value) do count=count+1;if type(key)~='number' or key<1 or key%1~=0 then array=false end end
    if array and count==#value then
        local out={};for i=1,count do out[i]=literal(value[i]) end
        return '{'..table.concat(out,',')..'}'
    end
    local k={};for key in pairs(value) do k[#k+1]=key end
    table.sort(k,function(a,b)return tostring(a)<tostring(b) end)
    local out={};for _,key in ipairs(k) do out[#out+1]='['..literal(key)..']='..literal(value[key]) end
    return '{'..table.concat(out,',')..'}'
end
local function equal(a,b)
    if type(a)~='table' then assert(a==b);return end
    for k,v in pairs(a) do equal(v,b[k]) end
    for k in pairs(b) do assert(a[k]~=nil) end
end
local index=assert(io.open(path..'meshes.lua','w'))
index:write('-- 按网格惰性解析；由 export_background.py 或 tools/split_th38_meshes.lua 生成。\nlocal files={\n')
for i,key in ipairs(keys) do
    local name=('%03d'):format(i)
    local out=assert(io.open(path..'meshes/'..name..'.lua','w'))
    out:write('return ',literal(source[key]),'\n');out:close()
    equal(source[key],dofile(path..'meshes/'..name..'.lua'))
    index:write('[',literal(key),']=',literal(name),',\n')
end
index:write("}\nreturn setmetatable({}, {__index=function(t,key)\n local name=files[key];if not name then return end\n local data=dofile('mod/GAME/th38/scenes/meshes/'..name..'.lua');rawset(t,key,data);return data\nend})\n");index:close()
print('雪莲华 '..#keys..' 个网格拆分完成，全部数值逐字段一致。')
