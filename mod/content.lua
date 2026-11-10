-- 精简分支的内容边界；保留实际level和符卡ID，不把旧录像误放进缺失关卡。
local C={stages={'31','32','33','34','35'},levels={[29]=true,[30]=true,[31]=true,[32]=true,[33]=true}}
local names={}
for _,id in ipairs(C.stages) do names['TH'..id..'@BossRush']=true end
local randomStages={['RogueTen@RogueTen']=true,['RogueDuo@RogueDuo']=true,['RogueChain@RogueChain']=true}
function C.supportsRecord(record)
    if type(record)~='table' or type(record.stageName)~='string' then return false end
    local ok,v=pcall(DeSerialize,record.stageExtendInfo)
    if not ok or type(v)~='table' then return false end
    if v.current_system and v.current_system~='' then return false end
    if names[record.stageName] then return true end
    if record.stageName=='Spell Practice@Spell Practice' then
        local group=v.sc_group
        return type(group)=='table' and C.levels[group[1]]==true
            and _sc_pr_table[group[1]] and _sc_pr_table[group[1]][group[2]]~=nil
    end
    if randomStages[record.stageName] then
        -- 第4版允许地灵殿加入随机池；该历史范围不属于精简分支。
        if v.__rogue_pool_version==4 then return false end
        for _,card in ipairs(v.rogue_run and v.rogue_run.cards or {}) do
            if not C.levels[card.level] then return false end
        end
        return true
    end
    return false
end
function C.supportsReplay(info)
    if type(info)~='table' or type(info.stages)~='table' or #info.stages==0 then return false end
    for _,record in ipairs(info.stages) do if not C.supportsRecord(record) then return false end end
    return true
end
C.replayMessage='该录像包含精简版未保留的关卡或历史卡池。\n请使用完整版本播放，原录像文件未作修改。'
return C
