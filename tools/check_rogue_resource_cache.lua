-- 真实 encounter 作用域：相邻同作复用、跨作先释放、退出回收、超预算退回卸载。
arg={'rogue-resource-cache'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local resources={};for k=1,9 do resources[k]={}end
lstg.EnumRes=function(kind)local names={};for name in pairs(resources[kind])do names[#names+1]=name end;return {},names end
lstg.RemoveResource=function(_,kind,name)resources[kind][name]=nil end
GetTextureSize=function(name)return name=='huge' and 16384 or 64,name=='huge' and 8192 or 64 end
GameContent={ports={[39]={},[41]={}}};_editor_class={};lstg.var.rogue_run={poolVersion=10};setting={}
local M=dofile('mod/rogue_encounter.lua')
local scene={};local a={level=39,source='TH41'};local b={level=41,source='TH43'}
resources[1].host=true
M.begin(scene,a)
local prepared=false
M.prepare(scene,a,{sc_group={{boss={},card={prepareRogue=function()prepared=true end}}}})
assert(not prepared and not M.preloading(),'无标记旧录像插入了预载等待')
resources[1].atlas=true;resources[2].alias=true;M.stop(scene)
assert(resources[1].atlas and resources[2].alias,'同作素材被逐卡卸载')
M.begin(scene,a);M.stop(scene)
assert(resources[1].atlas and resources[2].alias,'重复入场没有保留共享素材')
M.begin(scene,b)
assert(not resources[1].atlas and not resources[2].alias,'跨作资源别名未隔离')
resources[1].other=true;M.stop(scene);M.release()
assert(not resources[1].other and resources[1].host,'退出未释放本局素材或误删了宿主素材')
M.begin(scene,b);resources[1].huge=true;resources[2].largeAlias=true;M.stop(scene)
assert(not resources[1].huge and not resources[2].largeAlias,'超过192MiB仍继续保留素材')
M.release();assert(resources[1].host,'退出破坏了宿主资源')
print('随机模式资源：同作复用、跨作别名隔离、退出回收与192MiB预算全部通过。')
