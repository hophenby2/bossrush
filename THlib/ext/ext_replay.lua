---======================================
---luastg replay
---======================================

----------------------------------------
---replay
local replay = {}
ext.replay = replay

local REPLAY_DIR = "replay"
if not plus.DirectoryExists(REPLAY_DIR) then
    plus.CreateDirectory(REPLAY_DIR)
end
local replayManager = plus.ReplayManager(REPLAY_DIR) --replay管理器

local replayFilename--当前打开的Replay文件名称
local replayInfo    --当前打开的Replay文件信息
local replayStageIdx = 1  --当前正在播放的关卡
local replayStages = {}   --记录所有关卡的录像数据

---@type ReplayFrameWriter
replayWriter = nil--帧记录器

---@type ReplayFrameReader
replayReader = nil--帧读取器

ContinueGame = nil --是否为存档模式

function replay.IsReplay()
    return replayReader ~= nil
end

function replay.IsRecording()
    return replayWriter ~= nil
end

function replay.GetCurrentReplayIdx()
    return replayStageIdx
end

function replay.GetReplayFilename()
    return replayFilename
end

function replay.GetReplayStageName(idx)
    --Print('Index',idx)
    assert(replayInfo ~= nil)
    if not replayInfo.stages[idx] then
        return ''
    end
    return replayInfo.stages[idx].stageName
end

function replay.RefreshReplay()
    replayManager:Refresh()
end

function replay.GetSlotCount()
    return replayManager:GetSlotCount()
end

function replay.GetSlot(idx)
    return replayManager:GetRecord(idx)
end

function replay.SaveReplay(stageNames, slot, playerName, finish)
    local stages = {}
    finish = finish or 0
    for _, v in ipairs(stageNames) do
        Print(v)
        assert(replayStages[v])
        table.insert(stages, replayStages[v])
    end

    plus.ReplayManager.SaveReplayInfo(replayManager:MakeReplayFilename(slot), {
        gameName = setting.mod,
        gameVersion = 1,
        userName = playerName,
        group_finish = finish,
        stages = stages,
    })
end
local saving = {}
ext.saving = saving
local SAVE_DIR = "User"

function saving.Save(stageNames)
    local stages = {}
    for _, v in ipairs(stageNames) do
        assert(replayStages[v])
        table.insert(stages, replayStages[v])
    end
    plus.ReplayManager.SaveReplayInfo2({
        gameName = setting.mod,
        gameVersion = 1,
        userName = "User",
        group_finish = 0,
        stages = stages,
    })
end
saving.SaveManager = plus.ReplayManager(SAVE_DIR, "file", "saving")
----------------------------------------
---关卡切换增强功能
---用于支持replay

---设置场景
---当mode="none"时，参数stage用于表明下一个跳转的场景
---当mode="load"时，参数path有效，指明从path录像文件中加载场景stage的录像数据
---当mode="save"时，参数path无效，使用stage指定场景名称并开始录像
---@param mode string @none, load, save录像模式
---@param path string @录像文件路径（可选）
---@param stageName string @关卡名称
function stage.Set(mode, path, stageName)
    Print('Set', mode, path, stageName)
    if mode == "load" and stage.next_stage then
        return
    end --防止放replay时转场两次

    ext.pause_menu_order = nil

    -- 针对上一个可能的场景保存其数据
    if replayWriter ~= nil then
        local recordStage = replayStages[lstg.var.stage_name]
        recordStage.score = lstg.var.score
        recordStage.stageTime = os.time() - recordStage.stageTime
        --recordStage.stageExtendInfo = Serialize(lstg.var)--错误的保存位置
    end

    -- 关闭上一个场景的录像读写
    replayWriter = nil
    if replayReader then
        replayReader:Close()
        replayReader = nil
    end
    if mode ~= "load" then
        replayFilename = nil  -- 装载时使用缓存的数据
        replayInfo = nil
        replayStageIdx = 0
    end
    ext.ResetTicker()--重置计数器

    -- 刷新最高分
    if (not stage.current_stage.is_menu) and (not replay.IsReplay()) then
        local str = stage.current_stage.stage_name .. '@' .. tostring(lstg.var.player_name)
        if scoredata.hiscore[str] == nil then
            scoredata.hiscore[str] = 0
        end
        scoredata.hiscore[str] = max(scoredata.hiscore[str], lstg.var.score)
    end

    -- 转场
    if mode == "save" then
        assert(stageName == nil)
        ContinueGame = false
        stageName = path
        -- 设置随机数种子

        lstg.var.ran_seed = ((os.time() % 65536) * 877) % 65536
        --由OLC添加，用于录像和切关
        lstg.var.stage_name = stageName
        --lstg.var.FakeGameFPS = setting.FakeGameFPS
        lstg.var.UnlockAya = scoredata.UnlockAya
        lstg.var.UnlockChiruno = scoredata.UnlockChiruno
        -- 这里只能构造随机种子，因为当帧有可能会用随机数。在getinput转场里设置随机种子
        --ran:Seed(lstg.var.ran_seed)
        -- 开始执行录像
        local sg = string.match(stageName, '^.+@(.+)$')
        replayWriter = plus.ReplayFrameWriter()
        replayStages[stageName] = {
            stageName = stageName, score = 0, randomSeed = lstg.var.ran_seed,
            stageTime = os.time(), stageDate = os.time(), stagePlayer = lstg.var.rep_player,
            group_num = stage.groups[sg].number,
            cur_stage_num = (stage.current_stage.number or 100),
            frameData = replayWriter,
            stageExtendInfo = Serialize(lstg.var)--by OLC
        }
        --Print(Serialize(lstg.var))

        -- 转场
        --lstg.var.stage_name = stageName
        --stage.next_stage = stage.stages[stageName]
        --replayStages[stageName].stageExtendInfo = Serialize(lstg.var)
        stage.next_stage = stage.stages[stageName]--by OLC

    elseif mode == "load to save" then
        ContinueGame = true
        local saveinfo = plus.ReplayManager.ReadReplayInfo("User\\saving1.file")  -- 重新读取录像信息以保证准确性
        local save = {}
        assert(#saveinfo.stages > 0)
        for i = 1, #saveinfo.stages do
            stageName = stage.groups["BossRush"][i]
            --Print(stageName)
            lstg.var = DeSerialize(saveinfo.stages[i].stageExtendInfo)
            if i == #saveinfo.stages and i ~= STAGE_COUNT + 1 then
                local v = lstg.var
                v.saving = v.saving + 1
                if v.saving >= 50 then
                    ext.achievement:get(115)
                end
                if v.saving >= 25 then
                    ext.achievement:get(114)
                end
                if v.saving >= 10 then
                    ext.achievement:get(113)
                end
            end
            if i == STAGE_COUNT + 1 then
                lstg.nexttmpvar = {}
                lstg.nexttmpvar.InFinalStage = true
            end
            local sg = string.match(stageName, '^.+@(.+)$')
            replayWriter = plus.ReplayFrameWriter()
            replayReader = plus.ReplayFrameReader("User\\saving1.file", saveinfo.stages[i].frameDataPosition, saveinfo.stages[i].frameCount)
            for _ = 1, replayReader._count do
                replayWriter._count = replayWriter._count + 1
                replayWriter._data[replayWriter._count] = replayReader._fs:ReadByte()
            end
            replayReader:Close()
            replayReader = nil
            replayStages[stageName] = {
                stageName = stageName, score = saveinfo.stages[i].score, randomSeed = lstg.var.ran_seed,
                stageTime = os.time(), stageDate = os.time(), stagePlayer = lstg.var.rep_player,
                group_num = stage.groups[sg].number,
                cur_stage_num = (stage.current_stage.number or 100),
                frameData = replayWriter,
                stageExtendInfo = Serialize(lstg.var)--by OLC
            }
            table.insert(save, stage.groups["BossRush"][i])
        end
        ext.saving.Save(save)


        -- 转场
        --lstg.var.stage_name = stageName
        --stage.next_stage = stage.stages[stageName]
        --replayStages[stageName].stageExtendInfo = Serialize(lstg.var)
        stage.next_stage = stage.stages[stageName]--by OLC
    elseif mode == "load" then
        if path ~= replayFilename then
            replayFilename = path
            replayInfo = plus.ReplayManager.ReadReplayInfo(path)  -- 重新读取录像信息以保证准确性
            assert(#replayInfo.stages > 0)
        end

        -- 决定场景顺序
        if stageName then
            replayStageIdx = nil
            for i, _ in ipairs(replayInfo.stages) do
                if replayInfo.stages[i].stageName == stageName then
                    replayStageIdx = i
                    Print(stageName, replayStageIdx)
                    break
                end
            end
            assert(replayStageIdx ~= nil)
        else
            replayStageIdx = 1
        end

        --加载数据
        local nextRecordStage = replayInfo.stages[replayStageIdx]
        replayReader = plus.ReplayFrameReader(path, nextRecordStage.frameDataPosition, nextRecordStage.frameCount)

        --加载数据
        --lstg.var = DeSerialize(nextRecordStage.stageExtendInfo)--不能这么加载，因为场景里还有东西，在下一帧加载
        lstg.nextvar = DeSerialize(nextRecordStage.stageExtendInfo)
        --assert(lstg.var.ran_seed == nextRecordStage.randomSeed)  -- 这两个应该相等

        --初始化随机数
        --if lstg.var.ran_seed then
        --ran:Seed(lstg.var.ran_seed)
        --end

        --转场
        lstg.var.stage_name = nextRecordStage.stageName
        stage.next_stage = stage.stages[stageName]
    else
        assert(mode == "none")
        assert(stageName == nil)
        stageName = path

        -- 转场
        lstg.var.stage_name = stageName
        stage.next_stage = stage.stages[stageName]
    end
end

---重新开始场景
function stage.Restart()
    stage.preserve_res = true  -- 保留资源在转场时不清空
    if replay.IsReplay() then
        stage.Set("load", replay.GetReplayFilename(), lstg.var.stage_name)
        --stage.Set("load", replay.GetReplayStageName(1), lstg.var.stage_name)
    elseif replay.IsRecording() then
        if ContinueGame then
            stage.Set("load to save")
        else
            stage.Set("save", lstg.var.stage_name)
        end
    else
        stage.Set("none", lstg.var.stage_name)
    end
end
