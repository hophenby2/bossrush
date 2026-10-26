-- APK 资源只读；存档、录像和截图写入内部存储，路径行为保持 Lua 5.1。
local P = {}
local fu = cc.FileUtils:getInstance()
local originalOpen, originalRemove, originalRename = io.open, os.remove, os.rename
local writable = fu:getWritablePath() .. 'bossrush/'
fu:createDirectory(writable)
local files = assert(loadstring(fu:getStringFromFile('game/asset_index.lua')))()
local canonical, directories = {}, { [''] = true }
for _, path in ipairs(files) do
    canonical[path:lower()] = path
    local parent = path:match('^(.*)/')
    while parent do
        directories[parent:lower()] = true
        parent = parent:match('^(.*)/')
    end
end

function P.normalize(path)
    assert(type(path) == 'string', '文件名必须为字符串')
    local result = path:gsub('\\', '/'):gsub('/+', '/')
    result = result:gsub('^%./', ''):gsub('/$', '')
    for part in result:gmatch('[^/]+') do
        assert(part ~= '..', '不允许父目录路径：' .. path)
    end
    return result
end

local function isWritable(path)
    local head = path:match('^([^/]+)')
    return head == 'User' or head == 'replay' or head == 'snapshot'
end

function P.resolve(path)
    path = P.normalize(path)
    if path:sub(1, 1) == '/' then return path end
    if isWritable(path) then return writable .. path end
    if path:sub(1, 8) == 'android/' then return 'game/' .. path end
    return 'game/' .. (canonical[path:lower()] or path)
end

function P.exists(path)
    return fu:isFileExist(P.resolve(path))
end

function P.enumerate(path, extension)
    path = P.normalize(path or '')
    local result = {}
    if isWritable(path) then
        local absolute = P.resolve(path)
        if not fu:isDirectoryExist(absolute) then return result end
        for _, entry in ipairs(fu:listFiles(absolute .. '/')) do
            local name = entry:gsub('/$', ''):match('([^/]+)$')
            if name ~= '.' and name ~= '..' then
                local full = absolute .. '/' .. name
                local attr = lfs and lfs.attributes(full) or {}
                local directory = fu:isDirectoryExist(full)
                if not extension or (not directory and name:lower():match('%.([^%.]+)$') == extension:lower()) then
                    result[#result + 1] = { path .. '/' .. name, directory,
                        size = attr.size or (not directory and fu:getFileSize(full) or 0), time = attr.modification or 0 }
                end
            end
        end
    else
        local prefix = path == '' and '' or path .. '/'
        local seen = {}
        for _, entry in ipairs(files) do
            if entry:sub(1, #prefix):lower() == prefix:lower() then
                local rest = entry:sub(#prefix + 1)
                local name = rest:match('^([^/]+)/')
                local directory = name ~= nil
                local full = directory and prefix .. name or entry
                if not seen[full] and (not extension or (not directory and entry:lower():match('%.([^%.]+)$') == extension:lower())) then
                    result[#result + 1] = { full, directory }
                    seen[full] = true
                end
            end
        end
    end
    table.sort(result, function(a, b) return a[1] < b[1] end)
    return result
end

local MemoryFile = {}
MemoryFile.__index = MemoryFile
function MemoryFile:close() self.closed = true; return true end
function MemoryFile:flush() return true end
function MemoryFile:seek(whence, offset)
    assert(not self.closed, '文件已关闭')
    local bases = { set = 0, cur = self.position, ['end'] = #self.data }
    self.position = assert(bases[whence or 'cur']) + (offset or 0)
    assert(self.position >= 0, '文件偏移不能小于零')
    return self.position
end
function MemoryFile:read(...)
    assert(not self.closed, '文件已关闭')
    local formats, results = { ... }, {}
    if #formats == 0 then formats[1] = '*l' end
    for i, format in ipairs(formats) do
        local start, value = self.position + 1
        if format == '*a' or format == 'a' then
            value = self.data:sub(start); self.position = #self.data
        elseif start > #self.data then
            value = nil
        elseif type(format) == 'number' then
            value = self.data:sub(start, self.position + format)
            self.position = self.position + #value
        elseif format == '*l' or format == 'l' or format == '*L' or format == 'L' then
            local ending = self.data:find('\n', start, true)
            value = self.data:sub(start, ending and ending - 1 or #self.data):gsub('\r$', '')
            self.position = ending or #self.data
            if (format == '*L' or format == 'L') and ending then value = value .. '\n' end
        else
            error('不支持的资源读取格式：' .. tostring(format))
        end
        results[i] = value
        if value == nil then return unpack(results, 1, i) end
    end
    return unpack(results, 1, #formats)
end
function MemoryFile:lines()
    return function() return self:read('*l') end
end

function io.open(path, mode)
    mode = mode or 'r'
    local absolute = P.resolve(path)
    if mode:find('[wa+]') then
        assert(absolute:sub(1, #writable) == writable, '游戏资源目录不可写：' .. path)
        fu:createDirectory(absolute:match('^(.*)/'))
        return originalOpen(absolute, mode)
    end
    if absolute:sub(1, 1) == '/' then return originalOpen(absolute, mode) end
    if not fu:isFileExist(absolute) then return nil, '找不到资源：' .. path end
    return setmetatable({ data = fu:getStringFromFile(absolute), position = 0 }, MemoryFile)
end
function io.lines(path, ...)
    local f = assert(io.open(path, 'r'))
    local formats = { ... }
    return function()
        local value = f:read(unpack(formats))
        if value == nil then f:close() end
        return value
    end
end
function os.remove(path) return originalRemove(P.resolve(path)) end
function os.rename(source, destination) return originalRename(P.resolve(source), P.resolve(destination)) end
function P.installNativeAPI()
    function plus.DirectoryExists(path)
        path = P.normalize(path)
        return directories[path:lower()] or fu:isDirectoryExist(P.resolve(path))
    end
    function plus.CreateDirectory(path)
        assert(isWritable(P.normalize(path)), '只允许创建存档、录像、截图目录')
        assert(fu:createDirectory(P.resolve(path)), '无法创建目录：' .. path)
    end
    function plus.EnumFiles(path)
        local result = {}
        for _, entry in ipairs(P.enumerate(path)) do
            local name = entry[1]:match('([^/]+)$')
            result[#result + 1] = {
                isDirectory = entry[2], name = entry[2] and name or entry[1],
                real_name = name, size = entry.size or 0, lastAccessTime = entry.time or 0,
            }
        end
        return result
    end
end
P.writable = writable
return P
