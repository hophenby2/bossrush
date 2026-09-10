--======================================
--luastg stage
--======================================

----------------------------------------
--单关卡

---@class stage
stage = { stages = {} }

function stage:init()
end
function stage:frame()
end
function stage:render()
end
function stage:del()
end

---@return stage
function stage.New(stage_name, as_entrance, is_menu)
    local result = {
        init = stage.init,
        del = stage.del,
        render = stage.render,
        frame = stage.frame,
    }
    setmetatable(result, { __index = stage })
    if as_entrance then
        stage.next_stage = result
    end
    result.is_menu = is_menu
    result.stage_name = tostring(stage_name)
    stage.stages[stage_name] = result
    return result
end

function stage.Set(stage_name)
    --于ext中重载
    stage.next_stage = stage.stages[stage_name]
    KeyStatePre = {}
end

function stage.SetTimer(t)
    stage.current_stage.timer = t - 1
end

function stage.QuitGame()
    lstg.quit_flag = true
end

local SearchStageLevel = {}
function ResetCurSystem()
    for p in pairs(SearchStageLevel) do
        SearchStageLevel[p] = nil
    end
end
function SetCurSystem(code)
    ResetCurSystem()
    for i = 1, #code do
        SearchStageLevel[code:sub(i, i):byte() - 64] = true
    end
end
_G.SearchStageLevel = SearchStageLevel

local NoPass = Class(object)
function NoPass:init(count)
    self.count = count
    self.layer = 11
    self.group = GROUP.GHOST
    self.text = "你的死亡次数太多啦！ (" .. lstg.var.dead .. ")\n"
    self.text = self.text .. "死亡次数不超过" .. self.count .. "次才能进入下一关哦\n"
    self.text = self.text .. "请再接再厉吧！"
end
function NoPass:render()
    SetViewMode("ui")
    SetImageState("white", "", 255, 0, 0, 0)
    RenderRect("white", 0, 960, 0, 540)
    RenderTTF("title", self.text, 480, 270, Color(255, 255, 255, 255), "centerpoint")
end

local PassMissCount = {}
do
    -------------------------红,   妖,  永, 花, 文, 风,  地,  星,   DS,   大,   神,    城,    邪,    绀,   璋,    梦,   鬼,    虹,   市
    ---先输入每个关卡的允许miss数，然后自动换算成总miss数
    local StageMissCount = { 10, 12, 14, 12, 13, 20, 25, 25, 25, 12, 25, 30, 30, 35, 32, 10, 20, 20, 15 }

    local result = 0
    for i, k in ipairs(StageMissCount) do
        result = result + k
        PassMissCount[i + 1] = result
    end
end
stage.PassMissCount = PassMissCount
---miss数过多时不给进入下一关
---在task环境里
---采用while true方法阻止进入下一关）
function stage:CheckMiss()
    local count = PassMissCount[self.level]
    if lstg.var.is_practice or (not count) then
        return
    end
    if lstg.var.dead == count + 1 then
        ext.achievement:get(70)
    end--多1的成就
    if lstg.var.dead == count then
        ext.achievement:get(71)
    end--刚刚好的成就
    if lstg.var.dead > count then
        ext.achievement:get(34)
        if not IsValid(self.noPassOBJ) then
            if self.now_music and GetMusicState(self.now_music) == "playing" then
                StopMusic(self.now_music)
                PlayMusic("SCORE")
            end
            self.noPassOBJ = New(NoPass, count)
            player.realrealreal_lock = true
            player.hide = true
            ext.notUIdraw = true
            while true do
                menu:Updatekey()
                if menu:keyYes() then
                    ext.pause_menu:FlyIn()
                end
                task.Wait()
            end
        else
            while true do
                task.Wait()
            end
        end
    end
end

function stage:WaitOK(last)
    local flag = New(Class(object, {
        init = function(o)
            o.sign = -((sign(player.y) == 0) and 1 or sign(player.y))
            o.layer = LAYER.BG + 5
            o._a = 0
            o.text = last and "结束了！" or "下一关！"
            task.New(o, function()
                for i = 1, 20 do
                    o._a = sin(i * 4.5)
                    task.Wait()
                end
            end)
        end,
        frame = function(o)
            task.Do(o)
            if not o.d then
                local w = lstg.world
                if player.y * o.sign > (w.t - 70) then
                    object.Del(o)
                end
            end
        end,
        render = function(o)
            local w = lstg.world
            local y = (w.t - 70)
            SetImageState("white", "", o._a * 100, 135, 206, 235)
            RenderRect("white", w.l, w.r, o.sign * y - 2, o.sign * y + 2)
            RenderRect("white", w.l, w.r, o.sign * y - 4, o.sign * y + 4)
            ui:RenderText("big_text", o.text, 0, (y + 35) * o.sign,
                    1, Color(o._a * 255, 255, 227, 200), "centerpoint")
        end,
        del = function(o)
            object.Preserve(o)
            o.d = true
            task.New(o, function()
                for i = 19, 0, -1 do
                    o._a = sin(i * 4.5)
                    task.Wait()
                end
                object.RawDel(o)
            end)
        end
    }, true))
    while IsValid(flag) do
        task.Wait()
    end
end

function stage:Next(get_id)
    local task = task
    task.New(self, function()
        while coroutine.status(self.task[1]) ~= 'dead' do
            task.Wait()
        end
        if self.group._name == "BossRush" then
            self:ClearStage()
            lstg.tmpvar.stop_add_score = true
            self:WaitOK((self.number == STAGE_COUNT) or lstg.var.is_practice)
            task.New(self, function()
                while true do
                    if IsValid(UFO.big_ufo) then
                        Kill(UFO.big_ufo)
                    end
                    task.Wait()
                end
            end)
            if self.level then
                for i = 1, self.level do
                    scoredata.stage_practice[i] = true
                end--防止崩档
            end
            if get_id and lstg.var.dead <= self.init_death then
                ext.achievement:get(get_id)
            end
            sp:UnitListUpdate(UFO.valid)
            for _, p in pairs(UFO.valid) do
                object.RawDel(p)
            end--UFO的处理
            sp:UnitListUpdate(Beast.valid)
            for _, p in pairs(Beast.valid) do
                object.RawDel(p)
            end--动物灵的处理
            if self.number ~= STAGE_COUNT + 1 then
                lstg.var.elapsed = lstg.var.elapsed + self.stop_watch:GetElapsed()
            end
        end

        player._playersys:lock()
        mask_fader:Do("close")
        do
            local list = {}
            for _, v in pairs(EnumRes2('bgm')) do
                if GetMusicState(v) == 'playing' then
                    table.insert(list, v)
                end
            end
            for i = 1, 30 do
                for _, v in ipairs(list) do
                    SetBGMVolume(v, 1 - i / 30)
                end
                task.Wait()
            end
            for _, v in ipairs(list) do
                StopMusic(v)
            end
        end --音乐的淡出
        stage.group.FinishReplay()
        stage.group.FinishStage()
    end)
end

local stage_clear = Class(object)
stage.stage_clear_object=stage_clear
function stage_clear:init(score)
    self.score = score
    lstg.var.score = lstg.var.score + score
    self.alph = 0
end
function stage_clear:frame()
    if self.timer <= 30 then
        self.alph = self.timer / 30
    end
    if self.timer > 90 then
        self.alph = 1 - (self.timer - 90) / 30
    end
    if self.timer >= 120 then
        Del(self)
    end
end
function stage_clear:render()
    SetViewMode "world"
    local alpha = self.alph
    SetFontState("Score", "", alpha * 255, 255, 255, 255)
    RenderScore("Score", self.score, 0, 0, 0.5, "centerpoint")
    SetImageState("stage_clear", "", alpha * 255, 255, 255, 255)
    Render("stage_clear", 0, 0, 0, 0.5)

end

---切关奖励
---需要task环境
function stage:ClearStage()
    if self.level then
        AddMoney(self.level * 100)
        New(stage_clear, self.level * 600000)
        task.Wait(120)
    end
end

---三声nice改变音乐
---@param curbgm string
---@param newbgm string
---@param after number
function stage:ChangeMusicByNice(curbgm, newbgm, after, start_time)
    local task = task
    local SetBGMVolume = SetBGMVolume
    task.New(self, function()
        for i = 1, 30 do
            SetBGMVolume(curbgm, 1 - i / 30)
            task.Wait()
        end
        StopMusic(curbgm)
    end)
    for _, w in ipairs({ 60, 60, 0 }) do
        PlaySound("nice", 1, 0, true)
        task.Wait(w)
    end
    if after and after > 0 then
        task.New(self, function()
            task.Wait(after)
            PlayMusic(newbgm, 0, start_time or 0)
            task.New(self, function()
                for i = 1, 20 do
                    SetBGMVolume(newbgm, i / 20)
                    task.Wait()
                end
            end)
        end)
    else
        PlayMusic(newbgm, 0, start_time or 0)
        task.New(self, function()
            for i = 1, 20 do
                SetBGMVolume(newbgm, i / 20)
                task.Wait()
            end
        end)
    end
end

function stage:ChangeMusicByFade(curbgm, newbgm, time, bgm_start_time)
    if bgm_start_time and bgm_start_time < 0 then
        bgm_start_time = musicList[newbgm][1] + bgm_start_time
    end
    PlayMusic(newbgm, 0, bgm_start_time)
    for v = 1, time do
        SetBGMVolume(curbgm, 1 - v / time)
        SetBGMVolume(newbgm, v / time)
        coroutine.yield()
    end
    StopMusic(curbgm)
end

---@param event function
function stage:Task(event)
    task.New(self, function()
        self:CheckMiss()
        event()
    end)
end

function stage:Option(bg, music, full_screen)
    item._init_item(self)
    mask_fader:Do("open")
    New(_G[lstg.var.player_name])
    if bg then
        background.Create(bg)
    end
    if music then
        self.now_music = music
        PlayMusic(music)
    end
    if full_screen then
        ToBigScreen()
    end
    self.init_death = lstg.var.dead
    self.stop_watch = lstg.StopWatch()
end
