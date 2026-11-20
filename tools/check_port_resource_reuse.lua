-- 真实资源表加载：global 优先查找时，不能反复重载被遮住的 stage 同名资源。
local global,stage,calls={shared=true},{},0
lstg={CheckRes=function(_,name)if global[name]then return 'global' elseif stage[name]then return 'stage'end end}
LoadTexture=function(name)calls=calls+1;stage[name]=true end
GetResourceStatus=function()return 'stage'end
RemoveResource=function(pool,_,name)(pool=='global' and global or stage)[name]=nil end
local api=dofile('mod/GAME/ports/resources.lua')('Resources/test/')
local set=api.Create('shared');set:AddTexture('shared','shared.png')
set:Load();assert(calls==1 and set:IsLoaded())
set:Load();assert(calls==1,'同名 global 使有效资源永久失去缓存命中')
stage={};set:Load();assert(calls==1 and set:IsLoaded(),'资源池重置后有效 global 共享资源被重复载入')
global={};set:Load();assert(calls==2 and set:IsLoaded(),'资源实际释放后没有重新载入')
set:Unload();assert(not set:IsLoaded(),'卸载后仍报告资源有效')
print('移植资源表：global/stage 同名复用、资源池重置及真实卸载后的重载均通过。')
