-- 复现新作曲目被卸载后由通用播放器重载；只检查真实文件与资源池，不启动游戏或读写存档。
local function source(path)
    local f=assert(io.open(path,'rb'));local text=f:read('*a');f:close()
    return text:gsub('\r\n','\n')
end
local function section(text,first,last)
    local a=assert(text:find(first,1,true));local b=assert(text:find(last,a,true))
    return text:sub(a,b-1)
end
musicList,musicBarList={},{}
assert(loadstring(section(source('core.lua'),'local j = 1','function DefineAchievement')))()
local loaded,status,events={},'stage',{}
function CheckRes(_,name) return loaded[name] end
function GetResourceStatus() return status end
function SetResourceStatus(value) status=value end
function LoadMusic(name,path,ending,length)
    local f=assert(io.open(path:gsub('\\','/'),'rb'),'音乐路径不存在：'..path);f:close()
    assert(ending>0 and length>0 and ending>=length,name)
    loaded[name]=status;events[#events+1]={name,path,status}
end
function RemoveResource(pool,_,name) if loaded[name]==pool then loaded[name]=nil end end
PlayMusic=function(name) assert(loaded[name],name) end
StopMusic=function() end
GetMusicState=function(name) return loaded[name] and 'playing' or false end
SetBGMVolume=function() end
SetBGMSpeed=function() end
GetBGMSpeed=function() return 1 end
ResumeMusic=function() end
PauseMusic=function() end
int=math.floor
lstg={CheckRes=CheckRes};ext={}
assert(loadstring(section(source('THlib/ext/ext_other.lua'),'local CheckRes = CheckRes','function ext.SetMusicSpeed')))()
local checked=0
local function replay(name,path)
    for _,pool in ipairs({'global','stage'}) do
        status=pool
        PlayMusic(name)
        assert(status==pool,'播放后必须还原资源池')
        assert(events[#events][2]:gsub('\\','/')==path,'重载使用登记的原作文件：'..name)
        StopMusic(name);assert(not CheckRes(4,name))
        PlayMusic(name);assert(status==pool)
        StopMusic(name)
    end
    checked=checked+1
end
local info={}
setfenv(assert(loadstring(source('Resources/ports/theis/EISlib/lib/music.info'))),info)()
local registerTheis='local info=...;local function resourceInfo() return info end;local assets="Resources/ports/theis/"\n'
assert(loadstring(registerTheis..section(source('mod/GAME/th41.lua'),
    'local tracks, volumes = {},{}','local sounds=api.ResourceSet.Create')))(info.info)
for _,entry in ipairs(info.info) do if entry.name:match('^s[1-7]') then
    replay('THEIS_'..entry.name,'Resources/ports/theis/res/music/'..entry.filename)
end end
local sets=dofile('mod/GAME/ports/resources.lua')('Resources/ports/dreamer/')
local set=sets.Create('音乐重载回归')
for _,kind in ipairs({'Stage','Boss'}) do for i=1,kind=='Stage' and 10 or 5 do
    local name='ld_bgm_'..kind..i
    local path='res/likedreamer/bgm/'..kind..i..'.ogg'
    set:AddMusic(name,path,60,60);replay(name,'Resources/ports/dreamer/'..path)
end end
E={};has=CheckRes
local music=dofile('mod/GAME/th43/source/music.lua')
assert(loadstring('local music=...\n'..section(source('mod/GAME/th43/runtime.lua'),
    'function E.LoadMusicRecord','function R.playMusic')))(music)
for key in pairs(music) do if key:match('^s[1-7]') then
    status='global'
    local name=E.LoadMusicRecord(key);StopMusic(name)
    replay(name,'Resources/th43/music/bgm_'..key..'.ogg')
end end
AddMusic('TH06_1',122.02,122.02,'原有默认路径',true)
replay('TH06_1','music/TH06_1.ogg')
print(('音乐路径回归通过：%d首，覆盖首次播放、卸载重载与global/stage资源池还原。'):format(checked))
