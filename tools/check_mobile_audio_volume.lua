-- 使用移动端兼容层，覆盖已播放菜单音乐、淡入、静音、音效以及同名资源重载。
local music,sounds,functions={},{},{}
local starts=0
local function resource()
    local s={volume=1,time=17,state='playing'}
    function s:setVolume(v) self.volume=v end
    local r={};function r:getSource() return s end
    return r
end
FindResMusic=function(n) return music[n] end
FindResSound=function(n) return sounds[n] end
music.menu,sounds.select00,sounds.loop=resource(),resource(),resource()
local native={SetBGMVolume=function()end,SetSEVolume=function()end,
    PlayMusic=function(n,v) starts=starts+1;music[n]:getSource():setVolume(v) end,
    PlaySound=function(n,v) sounds[n]:getSource():setVolume(v) end}
dofile('android/lua/audio_volume.lua')(native,function(k,v) functions[k]=v end)
local function near(a,b) assert(math.abs(a-b)<1e-9,a..' / '..b) end
functions.PlayMusic('menu',.8)
functions.SetBGMVolume(.25);near(music.menu:getSource().volume,.2)
assert(starts==1 and music.menu:getSource().time==17,'总音量改变了播放位置或重新播放')
functions.SetBGMVolume('menu',.5);near(music.menu:getSource().volume,.125)
functions.SetBGMVolume(0);near(music.menu:getSource().volume,0)
functions.SetBGMVolume('menu',1);near(music.menu:getSource().volume,0)
functions.SetBGMVolume(.6);near(music.menu:getSource().volume,.6)
functions.PlaySound('select00',.4);functions.SetSEVolume(.25)
near(sounds.select00:getSource().volume,.1)
functions.PlaySound('loop',.8);near(sounds.loop:getSource().volume,.2)
functions.SetSourceSoundVolume('loop',.3);near(sounds.loop:getSource().volume,.075)
functions.SetSEVolume(0);near(sounds.loop:getSource().volume,0)
functions.SetSEVolume(.5);near(sounds.loop:getSource().volume,.15)
local old=music.menu;music.menu=resource();functions.PlayMusic('menu',.3)
functions.SetBGMVolume(.2);near(music.menu:getSource().volume,.06)
assert(music.menu~=old)
print('PASS 移动端已播放菜单音乐/音效、曲目淡入、静音恢复、同名重载；不重播、不跳位置')
