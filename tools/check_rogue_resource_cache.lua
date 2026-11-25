-- 真实encounter：同作/跨作驻留，只按总预算淘汰已结束且有明确作品前缀的资源。
arg={'rogue-resource-cache'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local resources={};for k=1,9 do resources[k]={}end
local removals=0
lstg.EnumRes=function(kind)local names={};for name in pairs(resources[kind])do names[#names+1]=name end;return {},names end
lstg.RemoveResource=function(_,kind,name)resources[kind][name]=nil;removals=removals+1 end
GetTextureSize=function(name)return name:find('huge',1,true) and 8192 or name:find('medium',1,true) and 6144 or 64,4096 end
GameContent={ports={[39]={},[41]={}}};_editor_class={};lstg.var.rogue_run={};setting={}
local M=dofile('mod/rogue_encounter.lua')
local scene={};local a={level=39,source='TH41'};local b={level=41,source='TH43'}
resources[1].host=true
M.begin(scene,a);M.residentReady=true
local prepared=false
M.prepare(scene,a,{sc_group={{boss={},card={enterRogue=function()prepared=true end}}}})
assert(prepared and not M.preloading(),'驻留资源直接准备当前卡')
resources[1]['theis/atlas']=true;resources[2]['theis/sprite']=true;M.stop(scene)
M.begin(scene,b)
assert(removals==0 and resources[1]['theis/atlas'],'跨作不应触发卸载')
resources[1]['th43/atlas']=true;resources[2]['th43/sprite']=true
resources[1]['original/8/enemy']=true;resources[2]['original/8/sprite']=true
M.stop(scene);M.begin(scene,a);M.stop(scene)
assert(removals==0 and resources[1]['th43/atlas'],'多作预算内应共同驻留')
M.begin(scene,a);resources[1]['theis/medium']=true;M.stop(scene)
M.begin(scene,b);resources[1]['th43/huge']=true;M.stop(scene)
assert(not resources[1]['theis/medium'] and resources[1]['th43/huge'],'超总预算应先淘汰较早使用的作品')
assert(resources[1].host and resources[1]['original/8/enemy'] and resources[2]['original/8/sprite'],'预算淘汰接管了宿主或跨卡ANM资源')
-- 原生复现：春雪切红魔乡后，Boss击破再次震屏曾写入已RawDel的单例。
dofile('THlib/misc/misc.lua');lstg.worldoffset={dx=0,dy=0}
M.begin(scene,a);misc.ShakeScreen(20,1)
local shaker=assert(lstg.tmpvar.shaker);lstg.worldoffset.dx,lstg.worldoffset.dy=3,-2
M.stop(scene)
assert(not IsValid(shaker) and not lstg.tmpvar.shaker,'切卡残留已删除的震屏单例')
assert(lstg.worldoffset.dx==0 and lstg.worldoffset.dy==0,'切卡残留震屏偏移')
misc.ShakeScreen(20,2);local nextShaker=assert(lstg.tmpvar.shaker)
assert(nextShaker~=shaker and IsValid(nextShaker),'下一张卡未创建新的震屏对象')
M.background={objects={[nextShaker]=true}}
M.release();assert(resources[1]['th43/huge'],'退出的统一stage释放不应由局部缓存重复处理')
assert(not lstg.tmpvar.shaker and lstg.worldoffset.dx==0 and lstg.worldoffset.dy==0,'返回标题未清理背景震屏状态')
print('多作整局驻留、总预算LRU淘汰、宿主/ANM归属隔离与统一退出释放通过')
