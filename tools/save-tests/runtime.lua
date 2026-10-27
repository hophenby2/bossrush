-- 测试专用宿主：所有写入均限制在调用者提供的空临时目录，不读取桌面玩家数据。
local root,sandbox=assert(arg[1]),assert(arg[2])
local ffi=require('ffi')
if ffi.os=='Windows' then
    ffi.cdef[[int SetCurrentDirectoryA(const char*); int CreateDirectoryA(const char*,void*); unsigned long GetFileAttributesA(const char*);]]
    assert(ffi.C.SetCurrentDirectoryA(sandbox)~=0,'测试目录不存在')
    package.cpath=root..'/android/build/save-tests/LuaJIT-win/src/?.dll;'..package.cpath
else
    ffi.cdef[[int chdir(const char*); int mkdir(const char*,unsigned int); void* opendir(const char*); int closedir(void*);]]
    assert(ffi.C.chdir(sandbox)==0,'测试目录不存在')
    package.cpath=root..'/android/build/save-tests/?.so;'..package.cpath
end
local json=require('cjson'); Serialize,DeSerialize=json.encode,json.decode
plus={}
function plus.DirectoryExists(path)
    if ffi.os=='Windows' then local value=tonumber(ffi.C.GetFileAttributesA(path));return value~=4294967295 and require('bit').band(value,16)~=0 end
    local d=ffi.C.opendir(path);if d==nil then return false end;ffi.C.closedir(d);return true
end
function plus.CreateDirectory(path)
    if ffi.os=='Windows' then assert(ffi.C.CreateDirectoryA(path,nil)~=0,'创建测试目录失败：'..path)
    else assert(ffi.C.mkdir(path,448)==0,'创建测试目录失败：'..path) end
end
local function load(name) return dofile(root..'/THlib/save/'..name..'.lua') end
local C=load('codec'); local P=load('profiles');local N=load('transport')
local originalOpen=io.open
-- 将静态页面映射至源码；用户数据始终使用临时目录。
io.open=function(path,mode)
    if path:sub(1,15)=='THlib/save/web/' then path=root..'/'..path end
    return originalOpen(path,mode)
end
return {root=root,load=load,C=C,P=P,N=N,ffi=ffi}
