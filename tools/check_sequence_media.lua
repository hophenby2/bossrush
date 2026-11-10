-- 五作路线的背景/原曲覆盖、循环点，以及反魂蝶原始淡出和480帧换曲。
dofile('tools/check_sequence_mode.lua')
local M=OriginalSequenceMedia
local n=0
local function check(v,label) assert(v,label);n=n+1 end
local function exists(path) local f=io.open(path,'rb');if f then f:close();return true end;return false end
for _,entry in ipairs(OriginalSequence.catalog.entries) do
    for _,chapter in ipairs(OriginalSequence.catalog.chapters(entry.key,'reimu_player')) do
        for _,row in ipairs(chapter.units) do
            local game,key,road,boss=M.location(chapter,row)
            check(exists('mod/GAME/original/std/'..game..'_'..key..'.lua'),'每个保留阶段都有原作STD')
            check(M.music[road] and M.music[boss],'每个保留阶段都有原作道中曲与Boss曲')
        end
    end
end
local tracks=0
for name,info in pairs(M.music) do
    tracks=tracks+1
    local f=assert(io.open('music/ORIG_'..name..'.ogg','rb'));check(f:read(4)=='OggS','压缩曲目是Ogg容器');f:close()
    check(info.loop_start>=0 and info.loop_end>info.loop_start and info.rate==44100 and info.channels==2,'循环点保留原作PCM样本单位')
    local registered=musicList['ORIG_'..name]
    check(registered[1]==info.loop_end/info.rate and registered[2]==(info.loop_end-info.loop_start)/info.rate,'播放参数是终点和循环长度')
end
check(tracks==67,'67首实际使用的原曲，含文花帖10-8独有曲')
local played,signals={},{}
PlayMusic=function(id) played[#played+1]=id end
StopMusic=function() end;SetBGMVolume=function() end
M.background.signal=function(_,id) signals[#signals+1]=id end
stage.current_stage={sequence_music='ORIG_th07_13',sequence_background={}}
local state={game=7,key='ecldata6:62'};local owner={}
M.advance(owner,0,state)
check(signals[1]==5 and #played==0 and stage.current_stage.sequence_music_fade.duration==180,'反魂蝶先跳STD标签5，原曲淡出180帧')
M.advance(owner,479,state);check(#played==0,'479帧前不提前播放反魂蝶曲')
M.advance(owner,480,state);check(played[1]=='ORIG_th07_13b','480帧按原ECL开始反魂蝶曲')
M.advance(owner,600,state);check(#played==1,'同一原始信号只触发一次')
print('原作背景/原曲覆盖、循环参数与换曲检查通过：'..n)
