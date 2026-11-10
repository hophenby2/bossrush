-- 使用正式路径适配代码，验证无损贴图别名不改变枚举、大小写和存档路径。
local rawOpen,rawLines,rawRemove,rawRename=io.open,io.lines,os.remove,os.rename
local assets={
 ['game/asset_index.lua']="return {'Resources/Test.PNG','mod/root.lua'}",
 ['game/asset_variants.lua']="return {['Resources/Test.PNG']='Resources/Test.webp'}",
 ['game/Resources/Test.webp']='RIFF test WEBP',
}
local f={getWritablePath=function() return '/private/test/' end,createDirectory=function() return true end,
    getStringFromFile=function(_,p) return assert(assets[p],p) end,isFileExist=function(_,p) return assets[p]~=nil end}
cc={FileUtils={getInstance=function() return f end}}
local P=dofile('android/lua/platform.lua')
plus={};P.installNativeAPI()
assert(__UTF8ToANSI('replay/测试录像.rpy')=='replay/测试录像.rpy','录像文件名保留UTF-8')
assert(P.resolve('resources\\TEST.png')=='game/Resources/Test.webp','大小写纠正后按别名加载')
assert(P.exists('Resources/Test.png'),'逻辑PNG在优化后仍能查询存在')
local files=P.enumerate('Resources','png');assert(#files==1 and files[1][1]=='Resources/Test.PNG','PNG枚举保持原始文件名')
assert(P.resolve('mod/root.lua')=='game/mod/root.lua','脚本路径保持原值')
assert(P.resolve('User/setting')=='/private/test/bossrush/User/setting','存档不能映射到只读资源')
io.open,io.lines,os.remove,os.rename=rawOpen,rawLines,rawRemove,rawRename
print('无损贴图别名、大小写、PNG枚举和存档路径检查通过')
