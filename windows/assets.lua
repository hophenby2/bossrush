-- Windows精简包只对重复贴图做路径别名；保留逻辑文件名、枚举及独立纹理状态。
local aliases=dofile('windows/asset_aliases.lua')
local lookup={}
local function normalize(path)
    return path:gsub('\\','/'):gsub('/+','/'):gsub('^%./',''):gsub('/$','')
end
for source,target in pairs(aliases) do lookup[normalize(source):lower()]=target end
local function resolve(path)
    return type(path)=='string' and (lookup[normalize(path):lower()] or path) or path
end
local native=lstg.LoadTexture
lstg.LoadTexture=function(name,path,...) return native(name,resolve(path),...) end
_G.LoadTexture=lstg.LoadTexture
local function enumerator(fn,find)
    return function(path,extension,pack)
        local result=fn(path,extension,pack)
        if find and pack and pack~='' then return result end
        local directory=normalize(path):lower()
        if directory~='' then directory=directory..'/' end
        local suffix=extension and extension~='' and '.'..extension or nil
        local seen={}
        for _,row in ipairs(result) do seen[normalize(row[1]):lower()]=true end
        local added={}
        for source in pairs(aliases) do
            local parent=source:match('^(.*)/') or ''
            if parent~='' then parent=parent..'/' end
            if parent:lower()==directory and (not suffix or source:sub(-#suffix)==suffix) and not seen[source:lower()] then
                added[#added+1]=source
            end
        end
        table.sort(added)
        for _,source in ipairs(added) do result[#result+1]={source,false} end
        return result
    end
end
for _,name in ipairs({'EnumFiles','EnumFilesEx'}) do
    if lstg.FileManager[name] then lstg.FileManager[name]=enumerator(lstg.FileManager[name],false) end
end
for _,name in ipairs({'FileExist','FileExistEx'}) do
    local fn=lstg.FileManager[name]
    if fn then lstg.FileManager[name]=function(path,...) return fn(resolve(path),...) end end
end
if lstg.FindFiles then lstg.FindFiles=enumerator(lstg.FindFiles,true);_G.FindFiles=lstg.FindFiles end
return {resolve=resolve,aliases=aliases}
