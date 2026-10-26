-- 菜单无需占用全部 Boss 贴图显存；尺寸从 PNG 清单读取，首次使用才上传纹理。
local P = AndroidPlatform
local fu = cc.FileUtils:getInstance()
local dimensions = assert(loadstring(fu:getStringFromFile('game/asset_dimensions.lua')))()
local pending = {}
local old = {}
for _, name in ipairs({ 'LoadTexture', 'GetTextureSize', 'LoadImage', 'LoadAnimation',
    'RenderTexture', 'SetTextureSamplerState', 'CheckRes', 'EnumRes', 'RemoveResource' }) do old[name] = lstg[name] end
local function expose(name, fn) lstg[name] = fn; _G[name] = fn end
local function ensure(name)
    local item = pending[name]
    if not item or item.loaded then return end
    local pool = GetResourceStatus()
    SetResourceStatus(item.pool)
    old.LoadTexture(name, item.path, unpack(item.options))
    item.loaded = true
    if item.sampler then old.SetTextureSamplerState(name, item.sampler) end
    SetResourceStatus(pool)
end
expose('LoadTexture', function(name, path, ...)
    local normalized = P.normalize(path)
    local background = normalized:lower():match('^resources/bossbackground/') ~= nil
    local boss = normalized:lower():match('^resources/bossimage/') ~= nil
    local size = dimensions[P.resolve(path):gsub('^game/', '')]
    if (background or boss) and size then
        pending[name] = pending[name] or { path=path, size=size, pool=GetResourceStatus(), options={...}, background=background }
        return
    end
    return old.LoadTexture(name, path, ...)
end)
expose('GetTextureSize', function(name)
    if pending[name] then return unpack(pending[name].size) end
    return old.GetTextureSize(name)
end)
expose('SetTextureSamplerState', function(name, sampler)
    if pending[name] then
        pending[name].sampler = sampler
        if not pending[name].loaded then return end
    end
    return old.SetTextureSamplerState(name, sampler)
end)
for _, name in ipairs({ 'LoadImage', 'LoadAnimation' }) do
    local fn = old[name]
    expose(name, function(resource, texture, ...) ensure(texture); return fn(resource, texture, ...) end)
end
expose('RenderTexture', function(name, ...) ensure(name); return old.RenderTexture(name, ...) end)
expose('CheckRes', function(kind, name)
    if kind == 1 and pending[name] then return pending[name].pool end
    return old.CheckRes(kind, name)
end)
expose('EnumRes', function(kind)
    local global, stage = old.EnumRes(kind)
    if kind == 1 then
        local seen = {}
        for _, list in ipairs({global, stage}) do for _, name in ipairs(list) do seen[name] = true end end
        for name, item in pairs(pending) do
            if not seen[name] then table.insert(item.pool == 'global' and global or stage, name) end
        end
    end
    return global, stage
end)
expose('RemoveResource', function(pool, kind, name)
    if kind == nil then
        for key, item in pairs(pending) do if item.pool == pool then pending[key] = nil end end
    elseif kind == 1 then pending[name] = nil end
    return old.RemoveResource(pool, kind, name)
end)
local findForObject = FindResForObject
FindResForObject = function(name) ensure(name); return findForObject(name) end
local M = {}
function M.releaseBackgrounds()
    for name, item in pairs(pending) do
        if item.background and item.loaded then
            old.RemoveResource(item.pool, 1, name)
            item.loaded = false
        end
    end
end
local resetPool = lstg.ResetPool
expose('ResetPool', function(...)
    M.releaseBackgrounds()
    return resetPool(...)
end)
return M
