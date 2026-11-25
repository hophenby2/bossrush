-- 运行实际触控、失焦与暂停音乐逻辑，覆盖两种暂停/失焦事件顺序。
package.preload.keycode=function()
    local n=0;return setmetatable({},{__index=function(t,k)n=n+1;t[k]=n;return n end})
end
lstg={GetKeyState=function()return false end,GetLastKey=function()return 0 end,var={}}
LoadFX,LoadImageFromFile=function()end,function()end
Color=function()return {}end
ext={music={},StageIsMenu=function()return false end}
task={New=function(_,f)f()end,Wait=function()end}
stage={current_stage={}}
player={}
AndroidInput=dofile('android/lua/input.lua')
dofile('THlib/ext/ext_pause_menu.lua')
local menu=ext.pause_menu
local states,pauses,resumes,clockResets={},0,0,0
EnumRes2=function()local out={};for name in pairs(states)do out[#out+1]=name end;return out end
GetMusicState=function(name)return states[name]end
PauseMusic=function(name)states[name]='paused';pauses=pauses+1 end
ResumeMusic=function(name)states[name]='playing';resumes=resumes+1 end
PlayMusic=function()error('继续游戏不应重播/重载BGM')end
SetBGMVolume=function()end
local focus
local function setup(slow,sc,paused)
    states={route=paused and 'paused' or 'playing'}
    ext.sc_pr,ext.pop_pause_menu=sc,nil
    menu:init();menu.kill=not paused
    if paused then menu.bgmlist.route=true end
    AndroidInput.beginFrame()
    AndroidInput.toggles={slow=slow,shoot=true}
    AndroidInput.keys={[88]=true};AndroidInput.pulses={[88]=2};AndroidInput.touches={{drag=true}}
    focus=dofile('android/lua/focus.lua')({invalidate=function()end},function()clockResets=clockResets+1 end)
end
local function preserved(slow)
    assert(AndroidInput.toggles.slow==slow and AndroidInput.toggles.shoot,'失焦改变触控开关')
    assert(not next(AndroidInput.keys) and not next(AndroidInput.touches) and not next(AndroidInput.pulses),'失焦没有释放触点/按键')
end
for _,slow in ipairs({false,true})do
    for _,openFirst in ipairs({false,true})do
        setup(slow,false,false)
        focus(false);local n=pauses;focus(false)
        assert(pauses==n,'重复失焦重做了暂停')
        preserved(slow)
        if openFirst then menu.kill=false;menu:PauseSound();ext.pop_pause_menu=nil end
        focus(true);assert(states.route=='paused','回前台时不应穿过暂停菜单开始播放')
        if not openFirst then assert(menu.focus_bgmlist.route);menu.kill=false;menu:PauseSound() end
        assert(menu.bgmlist.route,'暂停菜单漏记被失焦暂停的BGM')
        menu:ResumeSound();assert(states.route=='playing','继续游戏后BGM丢失')
        menu.kill=true;ext.pop_pause_menu=nil;AndroidInput.beginFrame()
        assert(GetKeyState(16)==slow,'继续游戏后低速开关没有恢复')
        n=resumes;focus(true);assert(resumes==n,'重复获焦重复恢复音乐')
    end
end
setup(true,false,false);focus(false);menu.kill=false;ext.pop_pause_menu=nil;focus(true)
menu:PauseSound();menu:ResumeSound()
assert(states.route=='playing','FlyIn和PauseSound之间获焦丢失音乐')
setup(true,false,true);focus(false);focus(true);menu:ResumeSound()
assert(states.route=='playing','先暂停再失焦未恢复音乐')
setup(false,true,false);focus(false);focus(true)
assert(states.route=='playing','符卡练习失焦后未恢复原BGM')
menu.kill=false;menu:PauseSound();menu:ResumeSound();assert(states.route=='playing')
setup(true,false,false);ext.StageIsMenu=function()return true end
focus(false);focus(true);assert(states.route=='playing','标题音乐没有恢复')
assert(clockResets==8,'获焦时钟重置次数错误')
print('Android focus: 8 event sequences passed')
