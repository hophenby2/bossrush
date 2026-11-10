-- 使用正式适配代码核对桌面贴图别名、枚举和原生字体/存档路径。
local original=dofile
dofile=function(path)
    if path=='windows/asset_aliases.lua' then return {['Resources/Copy.png']='Resources/Real.png'} end
    return original(path)
end
local calls={}
local files={['Resources/Real.png']=true,['User/menu.png']=true}
local function enum(path) return path:lower():find('resources') and {{'Resources/Real.png',false}} or {{'User/menu.png',false}} end
lstg={FileManager={EnumFiles=enum,EnumFilesEx=enum,FileExist=function(path) return files[path]==true end},FindFiles=enum,
    LoadTexture=function(name,path,...) calls[#calls+1]={name,path,...};return 'loaded' end}
local M=original('windows/assets.lua')
assert(LoadTexture('first','resources\\COPY.png',true)=='loaded')
assert(calls[1][1]=='first' and calls[1][2]=='Resources/Real.png' and calls[1][3]==true)
assert(lstg.LoadTexture('second','Resources/Copy.png')=='loaded' and calls[2][1]=='second','资源名必须独立传给原生接口')
assert(lstg.FileManager.FileExist('Resources/Copy.png'))
assert(lstg.FileManager.FileExist('User/menu.png'),'不能改变用户覆盖图路径')
assert(#FindFiles('Resources','png','')==2,'PNG枚举包含逻辑副本')
assert(#lstg.FileManager.EnumFiles('Resources','png',true)==2)
assert(#lstg.FileManager.EnumFiles('Resources','wav',true)==1,'不能注入不匹配的别名扩展名')
assert(#FindFiles('Resources','png','other.dat')==1,'不能把磁盘别名注入指定资源包')
assert(#FindFiles('User','png','')==1,'用户目录不能注入游戏资源')
assert(M.resolve('THlib/UI/font/replay.png')=='THlib/UI/font/replay.png')
assert(M.resolve('replay/test.rpy')=='replay/test.rpy')
dofile=original
print('Windows逻辑贴图、原生参数、PNG枚举、资源包筛选和用户路径检查通过')
