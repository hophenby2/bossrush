-- 只读的源码模块装载器。Class、New、碰撞、绘制均由本机 LuaSTG 执行。
return function(work)
    local scriptRoot = 'mod/GAME/ports/'..work..'/'
    local assetRoot = 'Resources/ports/'..work..'/'
    local assets = dofile('mod/GAME/ports/resources.lua')(assetRoot)
    local host = _G
    local api = setmetatable({ResourceSet=assets}, {__index=lstg})
    local env = {lstg=api}
    setmetatable(env, {__index=host})
    env._G = env
    env.math = setmetatable({}, {__index=math})
    env.rawget = function(t, key)
        if t==env then return t[key] end
        return rawget(t,key)
    end
    local included = {}
    local directories = {''}
    local function run(path)
        path = path:gsub('\\','/')
        if path:sub(1,1)=='~' then path=directories[#directories]..path:sub(2) end
        local sourcePath = scriptRoot..path
        local source = lstg.LoadTextFile and lstg.LoadTextFile(sourcePath)
        local chunk
        if source and source~='' then
            chunk = assert(loadstring(source:gsub('^\239\187\191',''),'@'..sourcePath))
        else
            chunk = assert(loadfile(sourcePath))
        end
        directories[#directories+1] = path:match('^(.*/)') or ''
        local result = setfenv(chunk,env)()
        directories[#directories] = nil
        return result
    end
    env.Include = function(path)
        if path:sub(1,1)=='~' then path=directories[#directories]..path:sub(2) end
        if included[path] then return end
        included[path]=true
        return run(path)
    end
    env.dofile, api.DoFile = run, run
    api.New, api.Class = New, Class
    api.LoadTextFile = function(path)
        local sourcePath=assetRoot..path:gsub('\\','/')
        if lstg.LoadTextFile then return lstg.LoadTextFile(sourcePath) end
        local handle=assert(io.open(sourcePath,'rb'))
        local source=handle:read('*a')
        handle:close()
        return source
    end
    return env, run, assetRoot
end
