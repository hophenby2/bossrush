---=====================================
---stage group
---=====================================

----------------------------------------
---关卡组
local stage = stage
local stg = {}
stage.group = stg
stage.groups = {}

---新建关卡组
function stg.New(title, stages, name, allow_practice, difficulty)
    local sg = { title = title, number = #stages, _name = name }
    for i = 1, #stages do
        sg[i] = stages[i]
        local s = stage.New(stages[i])
        s.frame = stage.group.frame
        s.render = stage.group.render
        s.number = i
        s.group = sg
        sg[stages[i]] = s
        s.x, s.y = 0, 0
        s.name = stages[i]
    end
    if name then
        if stage.groups[name] then
            return stage.groups[name]
        end
        stage.groups[name] = sg
        local flag
        for _, c in ipairs(stage.groups) do
            if c == name then
                flag = true
                break
            end
        end
        if not flag then
            table.insert(stage.groups, name)
        end
    end
    sg.allow_practice = allow_practice or false
    sg.difficulty = difficulty or 1
    return sg
end

---为关卡组添加关卡
function stg.AddStage(groupname, stagename, allow_practice, sc_pr)
    if stage.stages[stagename] then
        return stage.stages[stagename]
    end
    if stage.groups[groupname] then
        local sg = stage.groups[groupname]
        sg.number = sg.number + 1
        table.insert(sg, stagename)
        local s = stage.New(stagename)
        if sc_pr then
            s.frame = stage.group.frame_sc_pr
        else
            s.frame = stage.group.frame
        end
        s.render = stage.group.render
        s.number = sg.number
        s.group = sg
        sg[stagename] = s
        s.x, s.y = 0, 0
        s.name = stagename
        s.allow_practice = allow_practice or false
        return s
    end
end

---为关卡的对应key赋值
function stg.DefStageValue(stagename, key, value)
    stage.stages[stagename][key] = value
end
local RetryCountToUnlockAchievement = 0

local ExecuteFlag
function stg.frame(self)
    ext.sc_pr = false
    if not lstg.var.init_player_data then
        error('玩家数据加载失败')
    end
    if self.AllowMissCount then
        if self.AllowMissCount < lstg.var.dead and not ExecuteFlag then
            PlaySound("pldead01")
           --lstg.tmpvar.lost = true
           lstg.var.lost = true
            ExecuteFlag = true
            lstg.tmpvar.noPause = true
            player.colli = false
            player.lock = true
            object.EnemyNontjtDo(function(b)
                task.Clear(b)
            end)
            object.BulletIndesDo(function(b)
                task.Clear(b)
            end)
            task.Clear(stage.current_stage)
            task.New(stage.current_stage, function()
                Failed_Show:Do(175)
                for i = 1, 160 do
                    for _, v in pairs(EnumRes2('bgm')) do
                        if GetMusicState(v) == "playing" then
                            SetBGMVolume(v, 1 - i / 160)
                        end
                    end
                    task.Wait()
                end
                for _, v in pairs(EnumRes2('bgm')) do
                    if GetMusicState(v) == "playing" then
                        StopMusic(v)
                    end
                end
                mask_fader:Do("close")
                task.Wait(30)
                stg.FinishStage()
                self.AllowMissCount = self.AllowMissCount + 1--防止再检测
                ExecuteFlag = false
            end)
        end

    end
    --
    local order = ext.GetPauseMenuOrder()
    if order == "返回标题菜单" then
        lstg.var.timeslow = nil
        stage.group.ReturnToTitle(false, 0)
    end
    if order == "再放送" then
        lstg.var.timeslow = nil
        stage.Restart()
    end
    if order == "推把" then
        RetryCountToUnlockAchievement = RetryCountToUnlockAchievement + 1
        if RetryCountToUnlockAchievement >= 10 then
            ext.achievement:get(47)
        end
        lstg.var.timeslow = nil
        if lstg.var.is_practice then
            stage.group.PracticeStart(self.name)
        else
            if ContinueGame then
                stage.group.StartSaving()
            else
                stage.group.Start(self.group)
            end
        end
    end
    if order == "退出并保存录像" then
        stage.group.ReturnToTitle(true, 0)
        lstg.tmpvar.pause_menu_text = nil
        lstg.tmpvar.death = true
        lstg.var.timeslow = nil
    end
    if order == "重新开始" then
        if lstg.var.is_practice then
            stage.group.PracticeStart(self.name)
        else
            if ContinueGame then
                stage.group.StartSaving()
            else
                stage.group.Start(self.group)
            end
        end
        lstg.tmpvar.pause_menu_text = nil
        lstg.var.timeslow = nil
    end
end
function stg.frame_sc_pr()
    ext.sc_pr = true
    if not lstg.var.init_player_data then
        error('玩家数据加载失败')
    end

    if lstg.var.dead >= 1 then
        if ext.replay.IsReplay() then
            ext.pop_pause_menu = true
            ext.rep_over = true
            lstg.tmpvar.pause_menu_text = { "再放送", "返回标题菜单" }
        else
            if cur_setting.SCAutoRetry then
                stage.Restart()
                lstg.var.timeslow = nil
            else
                ext.pop_pause_menu = true
                lstg.tmpvar.death = true
                lstg.tmpvar.pause_menu_text = { "重新开始", "退出并保存录像", "返回标题菜单" }
            end
        end
        lstg.var.dead = 0
    end
    local order = ext.GetPauseMenuOrder()
    if order == "推把" or order == "重新开始" then
        stage.Restart()
        lstg.tmpvar.pause_menu_text = nil
        lstg.var.timeslow = nil
    end
    if order == "返回标题菜单" then
        stage.group.ReturnToTitle(false, 0)
        lstg.var.timeslow = nil
    end
    if order == "再放送" then
        stage.Restart()
        lstg.var.timeslow = nil
    end
    if order == "重新开始" then
        stage.Restart()
        lstg.var.timeslow = nil
    end
    if order == "退出并保存录像" then
        stage.group.ReturnToTitle(true, 0)
        lstg.tmpvar.pause_menu_text = nil
        lstg.tmpvar.death = true
        lstg.var.timeslow = nil
    end
end

function stg.render()
    SetViewMode 'world'
    RenderClearViewMode(Color(255, 0, 0, 0))
end

function stg.Start(group)
    lstg.var.is_practice = false
    stage.Set('save', group[1])
    stage.stages[group.title].save_replay = { group[1] }
end

function stg.StartSaving()
    lstg.var.is_practice = false
    stage.Set('load to save')
    stage.stages[stage.groups["BossRush"].title].save_replay = {  }
    ext.saving.SaveManager:Refresh()
    local slot = ext.saving.SaveManager:GetRecord(1)
    for i = 1, #slot.stages do
        table.insert(stage.stages[stage.groups["BossRush"].title].save_replay, stage.groups["BossRush"][i])
    end
end

function stg.PracticeStart(stagename)
    lstg.var.is_practice = true
    stage.Set('save', stagename)
    stage.stages[stage.stages[stagename].group.title].save_replay = { stagename }
end

function stg.FinishStage()
    local self = stage.current_stage
    local group = self.group
    if self.number == group.number or lstg.var.is_practice then
        if ext.replay.IsReplay() then
            ext.rep_over = true
            ext.pop_pause_menu = true
            lstg.tmpvar.pause_menu_text = { "再放送", "返回标题菜单" }
        else
            if lstg.var.is_practice then
                stage.group.ReturnToTitle(true, 0)
            else
                stage.group.ReturnToTitle(true, 1)
            end
        end
    else
        if ext.replay.IsReplay() then
            -- 载入关卡并执行录像
            stage.Set('load', ext.replay.GetReplayFilename(), ext.replay.GetReplayStageName(ext.replay.GetCurrentReplayIdx() + 1))
        else
            -- 载入关卡并开始保存录像
            stage.Set('save', group[self.number + 1], nil)
            if stage.stages[group.title].save_replay then
                table.insert(stage.stages[group.title].save_replay, group[self.number + 1])
            end
            if group == stage.groups["BossRush"] then
                ext.saving.Save(stage.stages[group.title].save_replay)
            end
        end
    end
end

function stg.FinishReplay()
    local self = stage.current_stage
    local group = self.group
    if ext.replay.IsReplay() then
        if self.number == group.number or lstg.var.is_practice then
            ext.rep_over = true
            ext.pop_pause_menu = true
            lstg.tmpvar.pause_menu_text = { "再放送", "返回标题菜单" }
        else
            -- 载入关卡并执行录像
            stage.Set('load', ext.replay.GetReplayFilename(), ext.replay.GetReplayStageName(ext.replay.GetCurrentReplayIdx() + 1))
        end
    end
end

function stg.GoToStage(number)
    local self = stage.current_stage
    local group = self.group
    number = number or self.number + 1
    if number > group.number or lstg.var.is_practice then
        if lstg.var.is_practice then
            stage.group.ReturnToTitle(true, 0)
        else
            stage.group.ReturnToTitle(true, 1)
        end
    else
        if ext.replay.IsReplay() then
            stage.Set('load', ext.replay.GetReplayFilename(), group[number])
        else
            stage.Set('save', group[number])
            if stage.stages[group.title].save_replay then
                table.insert(stage.stages[group.title].save_replay, group[number])
            end
        end
    end
end

function stg.FinishGroup()
    stage.group.ReturnToTitle(true, 1)
end

function stg.ReturnToTitle(save_rep, finish)
    for _, v in pairs(EnumRes2('bgm')) do
        if GetMusicState(v) == "playing" then
            StopMusic(v)
        end
    end
    local title = stage.stages[stage.current_stage.group.title]
    title.finish = finish or 0
    if ext.replay.IsReplay() then
        title.save_replay = nil
    elseif not save_rep then
        title.save_replay = nil
        moveoverflag = true
    end
    stage.Set('none', stage.current_stage.group.title)
end






