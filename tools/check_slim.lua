-- 精简范围、共享背景、音乐资源与录像入口契约，不接触玩家目录。
dofile('tools/check_original_practice.lua')
local C=dofile('mod/content.lua')
local n=0
local function check(v,label) assert(v,label);n=n+1 end
local function exists(path) local f=io.open(path,'rb');if f then f:close();return true end;return false end
for _,id in ipairs(C.stages) do check(exists('mod/GAME/th'..id..'.lua'),'保留五作脚本') end
for _,id in ipairs({'00','06','07','08','09','10','11','36'}) do check(not exists('mod/GAME/th'..id..'.lua'),'删除旧关卡脚本：'..id) end
for _,id in ipairs({'06','07','08'}) do
    local shared='mod/GAME/original/shared_th'..id..'_background.lua'
    check(exists(shared),'独立保留共享符卡背景')
    dofile(shared)
    check(_editor_class['TH'..id].SCBG1,'背景类可实际登记')
end
local music={}
AddMusic=function(id) music[id]=true;check(exists('music/'..id..'.ogg'),'配乐文件存在：'..id) end
dofile('mod/music.lua')
for level=29,33 do
    for _,unit in ipairs(_sc_pr_table[level]) do
        for _,part in ipairs(unit.sc_group) do check(music[part.boss.bgm],'所有保留Boss配乐均在精简曲库中：'..tostring(part.boss.bgm)) end
    end
end
local old=DeSerialize;DeSerialize=function(v) return v end
local function record(name,v) return {stageName=name,stageExtendInfo=v or {current_system=''}} end
for _,id in ipairs(C.stages) do check(C.supportsRecord(record('TH'..id..'@BossRush')),'保留关卡录像可播放') end
for level=29,33 do check(C.supportsRecord(record('Spell Practice@Spell Practice',{sc_group={level,1}})),'保留符卡练习录像可播放') end
check(C.supportsRecord(record('RogueTen@RogueTen',{__rogue_pool_version=9,current_system=''})),'当前随机模式录像可播放')
check(not C.supportsRecord(record('RogueTen@RogueTen',{__rogue_pool_version=4})),'不放行依赖已删关卡的历史随机池')
check(not C.supportsRecord(record('TH36@BossRush')),'不放行已删整关')
check(not C.supportsRecord(record('Spell Practice@Spell Practice',{sc_group={34,1}})),'不放行已删符卡练习')
check(not C.supportsRecord(record('TH31@BossRush',{current_system='A'})),'不放行不可开局的历史系统组合')
check(not C.supportsReplay{stages={record('TH31@BossRush'),record('TH06@BossRush')}},'播放前检查整份录像')
check(C.supportsReplay{stages={record('TH31@BossRush'),record('TH35@BossRush')}},'保留关卡可组成多阶段录像')
DeSerialize=old
print(('精简内容与录像边界检查通过：%d 项。'):format(n))
