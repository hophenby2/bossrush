-- 源脚本对象在绑定图像前解析作品命名空间，避免为对象赋img再创建全局裸名别名。
local M=PortObjectResources
if M then return M end
M={objects=setmetatable({},{__mode='k'}),metatables=setmetatable({},{__mode='k'}),wrapped=setmetatable({},{__mode='k'})};PortObjectResources=M
local rawSetAttr=SetAttr
local abs=math.abs
function M.set(o,key,value)
    local resolve=M.objects[o]
    if resolve then
        if key=='img' then value=resolve(value)
        -- Sub 接受随镜像缩放带符号的半轴；x 的判定尺寸只接受非负数。
        elseif AndroidPlatform and (key=='a' or key=='b') then value=abs(value) end
    end
    return rawSetAttr(o,key,value)
end
SetAttr,lstg.SetAttr=M.set,M.set
function M.bind(o,resolve)
    M.objects[o]=resolve
    local original=getmetatable(o) or false
    if M.wrapped[original]==resolve then return end
    local mappings=M.metatables[resolve]
    if not mappings then mappings=setmetatable({},{__mode='k'});M.metatables[resolve]=mappings end
    local existing=mappings[original]
    if existing then setmetatable(o,existing);return end
    local mt={}
    for key,value in pairs(original or {})do mt[key]=value end
    local setter=mt.__newindex or rawSetAttr
    mt.__newindex=function(t,key,value)
        if key=='img' then value=resolve(value) end
        if AndroidPlatform and (key=='a' or key=='b') then value=abs(value) end
        return setter(t,key,value)
    end
    mappings[original]=mt;M.wrapped[mt]=resolve
    setmetatable(o,mt)
end
function M.factory(resolve)
    local owned,wrapped=setmetatable({},{__mode='k'}),setmetatable({},{__mode='k'})
    local function class(base,definition,sort)
        local c=Class(base,definition,sort);owned[c]=true;return c
    end
    local function prepare(c)
        if not owned[c] or wrapped[c]==c.init then return end
        local init=c.init or c[1] or empty
        c.init=function(o,...)
            M.bind(o,resolve)
            return init(o,...)
        end
        c[1]=c.init;wrapped[c]=c.init
        if AndroidRegisterClass then AndroidRegisterClass(c) end
    end
    return class,prepare
end
return M
