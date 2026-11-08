-- 真实曲库、音频计时入口、随机袋与暂停/退出回归；不读写玩家目录。
arg[1]='music-registry'
local f=assert(io.open('tools/check_roguelike.lua','rb'));local source=f:read('*a');f:close()
assert(loadstring(source:sub(1,assert(source:find('local function random()',1,true))-1)))()
musicList={}
AddMusic=function(id,ending,length,name) musicList[id]={ending,length,name} end
dofile('mod/music.lua')
local P=dofile('mod/rogue_pool.lua')
local options=P.defaults();options.cards.survival=true;options.encounters.road=true
local pool=P.build(options)
local M=dofile('mod/rogue_music.lua')
local count=0
local function check(v,label) assert(v,label);count=count+1 end
local function random()
    local g={v=1};function g:Seed(seed) self.v=seed%2147483646+1 end
    function g:Int(a,b) self.v=self.v*48271%2147483647;return a+math.floor(self.v/2147483647*(b-a+1)) end
    return g
end
Rand=random;ran=Rand();ran:Seed(20261108)
local randomBefore=ran.v
local tracks=M.tracks(pool);local known={}
for _,id in ipairs(tracks) do known[id]=true end
check(#tracks==9 and not known.SCORE and not known.TH11_0,'只使用本模式原有九首战斗BGM')
check(known.TH06_0 and known.TH06_1 and known.TH07_1 and known.TH10_2 and known.TH10_4 and known.TH08_NEW_3,'四作原有曲目均可用')
lstg={var={},tmpvar={}};stage={current_stage={is_menu=false,rogue_scene_ready=true}}
ext={music={}}
local playing,events,stops={}, {},0
PlayMusic=function(id)
    for other,state in pairs(playing) do check(state~='playing','切换前停止旧曲，不叠播：'..other) end
    check(known[id],'不得播放原有曲库以外的曲目')
    playing[id]='playing';ext.music[id]={timer=0,faketimer=0,paused=false};events[#events+1]=id
end
StopMusic=function(id) playing[id]=nil;ext.music[id]=nil;stops=stops+1 end
GetMusicState=function(id) return playing[id] or false end
f=assert(io.open('THlib/ext/ext_other.lua','rb'));source=f:read('*a');f:close()
local first=assert(source:find('function ext.MusicFrame(k, i)',1,true))
local last=assert(source:find('function ext.FastMusic()',first,true))
assert(loadstring(source:sub(first,last-1)))()
local function reset(seed)
    lstg.var={__rogue_music_version=1,rogue_run={seed=seed or 17}}
    stage.current_stage={is_menu=false,rogue_scene_ready=true};stage.next_stage=nil
    ext.music={};playing={};events={};stops=0
    M.init(lstg.var.rogue_run,pool)
    check(M.start(stage.current_stage,'TH07_1'),'首曲仍由第一个Boss决定')
    return lstg.var.rogue_run.music
end
local function finish(s)
    local current=s.current
    local left=math.ceil(musicList[current][1]*60)-s.elapsed
    ext.MusicFrame('timer',left-1)
    check(s.current==current,'完整播放一次前不换曲')
    ext.MusicFrame('timer')
    check(s.current~=current and stage.current_stage.now_music==s.current,'播完即换不同曲，并同步场景当前音乐')
end
local s=reset(17)
check(#s.remaining==8 and s.plays==1 and s.cycle==1,'首曲计入本轮已播放，不会在首轮重复')
ext.MusicFrame('faketimer',100000)
check(s.elapsed==0 and #events==1,'显示帧计时不触发额外切歌')
local duration=math.ceil(musicList[s.current][1]*60)
ext.MusicFrame('timer',100)
local elapsed=s.elapsed;local current=s.current
ext.music[current].paused=true;playing[current]='paused'
ext.MusicFrame('timer',duration*3)
check(s.elapsed==elapsed and s.current==current,'暂停期间不消耗歌曲播放时间')
ext.music[current].paused=false;playing[current]='playing';finish(s)
local countBefore=#events
stage.current_stage.is_menu=true;ext.MusicFrame('timer',100000)
check(#events==countBefore,'菜单不会继续随机换曲');stage.current_stage.is_menu=false
stage.next_stage={};ext.MusicFrame('timer',100000)
check(#events==countBefore,'转场已排队时不重新加载BGM');stage.next_stage=nil
lstg.var.rogue_run.finished=true;ext.MusicFrame('timer',100000)
check(#events==countBefore,'结算后停止自动切歌');lstg.var.rogue_run.finished=nil
M.stop(stage.current_stage);M.stop(stage.current_stage)
check(not s.active and stops==2 and not GetMusicState(s.current),'离开战斗停止当前BGM，重复清理安全')
s=reset(19);playing[s.current]='stopped';current=s.current;ext.MusicFrame('timer')
check(s.current~=current,'音频源自然停止时同样换曲')
local savedSequence
for seed=1,40 do
    s=reset(seed)
    for i=2,27 do finish(s) end
    local seen={}
    for i,id in ipairs(events) do
        if (i-1)%9==0 then seen={} end
        check(not seen[id],'每轮九首完整播放一次后才允许重复')
        check(i==1 or id~=events[i-1],'跨轮边界也不连续重复同曲')
        seen[id]=true
    end
    check(s.cycle==3 and s.plays==27,'完整三轮的计数正确')
    if seed==17 then savedSequence=table.concat(events,',') end
end
s=reset(17);for i=2,27 do finish(s) end
check(table.concat(events,',')==savedSequence,'相同种子与首曲重建相同播放顺序')
check(ran.v==randomBefore,'换曲不消耗弹幕或抽卡随机源')
lstg.var={__rogue_music_version=nil,rogue_run={seed=17}}
M.init(lstg.var.rogue_run,pool)
check(not lstg.var.rogue_run.music and not M.start(stage.current_stage,'TH07_1'),'旧录像保留原单曲循环行为')
local before=#events;ext.MusicFrame('timer',100000)
check(#events==before,'旧录像不会额外播放新曲')
print(('随机BGM回归通过：%d 项。'):format(count))
