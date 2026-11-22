-- 原 src/basic/audio.lua 的注册名、默认音量、usevol 和声像换算，调用正式移植接口。
arg={'th43-audio'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
dofile('THlib/lib/Ltask.lua')
bent_laser.RenderFunc,bent_laser.RenderFuncDeath={},{}
CheckRes=function() return nil end
dofile('tools/th43_registry.lua')
local E=TH43.runtime.env
local loaded,played,stopped={},{},{}
local loads=0
FileExist=function(path) local f=io.open(path,'rb');if f then f:close();return true end;return false end
CheckRes=function(kind,name) if kind=='snd' and loaded[name] then return 'global' end end
LoadSound=function(id,path) assert(FileExist(path),path);loaded[id]=path;loads=loads+1 end
PlaySound=function(id,volume,pan) assert(loaded[id]);played[#played+1]={id,volume,pan} end
StopSound=function(id) stopped[id]=true end
E.PlaySound('ch01',.1,384)
assert(played[1][1]=='th43/se/ch01' and played[1][2]==1 and played[1][3]==.5)
E.PlaySound('ch01',.3,-384,true)
assert(played[2][2]==.3 and played[2][3]==-.5 and loads==1)
E.PlaySound('power02')
assert(#played==2,'原作未注册的名称被错误替代为其他音效')
local data=dofile('mod/GAME/th43/release_sounds.lua');local count=0
for name,cue in pairs(data) do
    E.PlaySound(name,.01,192)
    local actual=played[#played]
    assert(actual[1]=='th43/se/'..name and actual[2]==cue.volume and actual[3]==.25)
    count=count+1
end
assert(count==85 and loads==85)
E.StopSound('ch01');assert(stopped['th43/se/ch01'])
TH43.runtime.stopSounds()
local countStopped=0;for _ in pairs(stopped) do countStopped=countStopped+1 end
assert(countStopped==85,'退出作品时没有停止所有独立音效')
print('PASS 栖霞园 85 个原音效的文件、独立资源名、注册音量、usevol、声像换算和缓存')
