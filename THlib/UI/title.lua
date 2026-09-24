Include("THlib\\UI\\loading.lua")

stage_menu = stage.New('menu', false, true)

function stage_menu:init()
    local practice
    local last_menu
    local menu_title, menu_replay_loader, menu_replay_saver, menu_sc_pr, menu_practice, menu_setting
    local menu_achievement, menu_manual, menu_key, menu_music, menu_store
    local menu_player_system_select, menu_playdata
    --
    --
    mask_fader:Do("open")
    local function MaskFader()
        task.Wait(30)
        mask_fader:Do("close")
        task.Wait(30)
    end
    do
        GlobalAddAchievement = true
        local achi = ext.achievement
        achi:get(1)
        if scoredata["Alt+F4"] then
            achi:get(2)
        end
        if scoredata.UnlockAya then
            achi:get(11)
        end
        local d = os.date("*t")
        local date = os.time({ day = d.day, month = d.month, year = d.year })
        if date - scoredata.LastLoginDate >= 172800 then
            scoredata.ContinuousLogin = 1
        elseif date - scoredata.LastLoginDate >= 86400 then
            scoredata.ContinuousLogin = scoredata.ContinuousLogin + 1
        end
        scoredata.LastLoginDate = date
        if scoredata.ContinuousLogin >= 7 then
            achi:get(35)
        end
        if achi.getcount == #AchievementInfo - 1 then
            achi:get(76)
        end
        if achi.getcount >= 50 then
            achi:get(75)
        end
        if achi.getcount >= 25 then
            achi:get(74)
        end
        if achi.getcount >= 10 then
            achi:get(73)
        end
    end--成就的获得
    --

    local function ExitGame()
        task.New(stage_menu, function()
            menu.FadeOut(menu_title, 'right')
            mask_fader:Do("close")
            for i = 1, 30 do
                SetBGMVolume(menu_music.now, 1 - i / 30)
                task.Wait()
            end
            StopMusic(menu_music.now)
            scoredata["music_bar_time"] = menu_music.music_timer
            stage.QuitGame()
        end)
    end
    menu_music = New(music_bar)

    ext.saving.SaveManager:Refresh()
    menu_title = New(main_menu, '', {
        { "开始新的游戏", function()
            practice = nil
            last_menu = menu_title
            ext.saving.SaveManager:Refresh()
            if ext.saving.SaveManager:GetRecord(1) then
                New(SimpleChoose, menu_title, function()
                    menu_player_system_select.state = "stage"
                    menu_player_system_select:fresh()
                    menu.FadeIn(menu_player_system_select)
                    menu.FadeOut(menu_title, "left")
                end, load(""), "Warning!!", "检测到存档，\n如果开始新游戏\n将会被覆盖。\n是否继续？", 200, 70)
            else
                menu_player_system_select.state = "stage"
                menu_player_system_select:fresh()
                menu.FadeIn(menu_player_system_select)
                menu.FadeOut(menu_title, "left")
            end
        end, "New Game" },
        { "继续游戏", function()
            practice = nil
            ext.saving.SaveManager:Refresh()
            local slot = ext.saving.SaveManager:GetRecord(1)
            if slot then
                local var = DeSerialize(slot.stages[#slot.stages].stageExtendInfo)
                local nowstage = slot.stages[#slot.stages].stageName:match('^(.+)@.+$')
                local systems = {}
                for i = 1, SYSTEM_COUNT do
                    if var.current_system:find(tostring(i + 64):char()) then
                        table.insert(systems, SystemList[i].title)
                    end
                end
                local text = table.concat({
                    ("接着玩：%s"):format(ui.menu.sntext[nowstage] or nowstage),
                    ("使用自机：%s"):format(ui.menu.pname[var.rep_player] or var.rep_player),
                    ("分数：%s"):format(var.score),
                    ("死亡数：%s"):format(var.dead),
                    ("收卡数：%s"):format(var.getsc),
                    ("擦弹点：%s"):format(var.graze),
                    ("读档次数：%s"):format(var.saving),
                    "",
                    ("携带系统：\n%s"):format(table.concat(systems, "\n"))
                }, "\n")
                New(SimpleChoose, menu_title, function()
                    menu.FadeOut(menu_title)
                    menu.FadeOut(menu_music)
                    task.New(stage_menu, function()
                        for i = 1, 60 do
                            SetBGMVolume(menu_music.now, 1 - i / 60)
                            task.Wait()
                        end
                        StopMusic(menu_music.now)
                        scoredata["music_bar_time"] = menu_music.music_timer
                    end)
                    task.New(stage_menu, function()
                        MaskFader()
                        stage.group.StartSaving()
                    end)
                end, load(""), "存档数据", text, 230, 110)
            else
                PlaySound("invalid")
            end
        end, "Continue Game" },
        { "单篇章游玩", function()
            practice = 'stage'
            stage_select.fresh(menu_practice)
            menu.FadeIn(menu_practice, "left")
            --menu.FadeIn(menu_difficulty_select_pr,"left")
            menu.FadeOut(menu_title, "left")
        end, "Chapter Start" },
        { "单符卡游玩", function()
            practice = 'spell'
            last_menu = menu_title
            menu_player_system_select:fresh()
            menu_player_system_select.state = "spell"
            menu.FadeIn(menu_player_system_select)
            menu.FadeOut(menu_title)
        end, "Spell Start" },
        { "查看录像", function()
            replay_loader.Refresh(menu_replay_loader)
            menu.FadeIn(menu_replay_loader, "left")
            menu.FadeOut(menu_title, "left")
        end, "Replay" },
        { "商店", function()
            menu.FadeIn(menu_store)
            menu.FadeOut(menu_title, "left")
        end, "Store" },
        { "游玩说明", function()
            manual.refresh(menu_manual)
            menu.FadeIn(menu_manual)
            menu.FadeOut(menu_title, "left")
        end, "Manual" },
        { "成就", function()
            Achievement.Refresh(menu_achievement)
            menu.FadeIn(menu_achievement)
            menu.FadeOut(menu_title, "left")
        end, "Achievement" },
        { "游玩数据", function()
            playdata_menu.refresh(menu_achievement)
            menu.FadeIn(menu_playdata)
            menu.FadeOut(menu_title)
        end, "Player Data" },
        { "按键设置", function()
            menu.FadeIn(menu_key)
            menu.FadeOut(menu_title, "left")
        end, "Key Settings" },
        { "其他设置", function()
            menu.FadeIn(menu_setting)
            menu.FadeOut(menu_title)
            menu_setting.pos = 1
        end, "Options" },
        { "更新日志", function()
            local file = io.open("Update.txt", "r")
            New(SimpleNotice, menu_title, "更新日志", file:read("*a"))
            file:close()
        end, "Update Infomation" },
        { "退出游戏", ExitGame, "Quit Game" }
    }, function()
        if menu_title.pos == #menu_title.text then
            ExitGame()
        else
            menu_title.pos = #menu_title.text
        end
    end, { [2] = not ext.saving.SaveManager:GetRecord(1) })
    menu_player_system_select = New(player_system_select, function(start)
        if start == "stage" then
            menu.FadeOut(menu_player_system_select)
            menu.FadeOut(menu_music)
            task.New(stage_menu, function()
                for i = 1, 60 do
                    SetBGMVolume(menu_music.now, 1 - i / 60)
                    task.Wait()
                end
                StopMusic(menu_music.now)
                scoredata["music_bar_time"] = menu_music.music_timer
            end)
            task.New(stage_menu, function()
                MaskFader()
                if last_menu and last_menu.level then
                    stage.group.Start(stage.groups[last_menu.level])
                else
                    if practice == 'stage' then
                        local select = menu_practice.stage_selects[menu_practice.pos]
                        if type(select.stage) == "function" then
                            select.stage()
                        else
                            stage.group.PracticeStart(select.stage.name)
                        end
                    else
                        stage.group.Start(stage.groups["BossRush"])
                    end
                end
            end)
        elseif start == "spell" then
            menu.FadeIn(menu_sc_pr)
            sc_pr_menu.TweakCard(menu_sc_pr)
            menu.FadeOut(menu_player_system_select)
        else
            menu.FadeOut(menu_player_system_select)
            menu.FadeIn(last_menu or menu_title)
        end
    end)
    menu_practice = New(stage_select, function()
        menu.FadeIn(menu_title)
        menu.FadeOut(menu_practice)
    end, function()
        menu.FadeOut(menu_practice)
        last_menu = menu_practice
        menu_player_system_select.state = "stage"
        menu_player_system_select:fresh()
        menu.FadeIn(menu_player_system_select)
    end)

    menu_key = New(key_setting_menu, {
        { "keys", "up", "上" },
        { "keys", "down", "下" },
        { "keys", "left", "左" },
        { "keys", "right", "右" },
        { "keys", "slow", "低速" },
        { "keys", "shoot", "射击" },
        { "keys", "spell", "特殊1" },
        { "keys", "special", "特殊2" },
        { "keysys", "repfast", "录像加速" },
        { "keysys", "repslow", "录像减速" },
        { "keysys", "menu", "暂停" },
        { "keysys", "snapshot", "截图" },
    }, function()
        if menu_key.pos ~= menu_key.count then
            menu_key.pos = menu_key.count
        else
            menu.FadeIn(menu_title)
            menu.FadeOut(menu_key)
            save_setting()
            loadConfigure()
        end
    end)
    menu_manual = New(manual, function()
        menu.FadeIn(menu_title)
        menu.FadeOut(menu_manual)
    end)
    menu_achievement = New(Achievement, function()
        menu.FadeIn(menu_title)
        menu.FadeOut(menu_achievement)
    end)
    menu_store = New(system_store, function()
        menu.FadeIn(menu_title)
        menu.FadeOut(menu_store)
    end)
    menu_playdata = New(playdata_menu, function()
        menu.FadeIn(menu_title)
        menu.FadeOut(menu_playdata)
    end)
    menu_setting = New(game_setting, function()
        menu.FadeIn(menu_title)
        menu.FadeOut(menu_setting)
        save_setting()
    end)
    --
    menu_sc_pr = New(sc_pr_menu, function(index, index_group)
        if index then
            last_menu = menu_sc_pr
            lstg.var.sc_index = index--给_sc_table用的
            lstg.var.sc_group = index_group--给_sc_pr_table用的
            menu.FadeOut(menu_sc_pr)
            menu.FadeOut(menu_music)
            task.New(stage_menu, function()
                for i = 1, 30 do
                    SetBGMVolume(menu_music.now, 1 - i / 30)
                    task.Wait()
                end
                StopMusic(menu_music.now)
                scoredata["music_bar_time"] = menu_music.music_timer
            end)
            task.New(stage_menu, function()
                mask_fader:Do("close")
                task.Wait(30)
                stage.IsSCpractice = true
                stage.group.PracticeStart('Spell Practice@Spell Practice', true)--true = 符卡练习，开启自机无敌
            end)
        else
            menu.FadeIn(menu_player_system_select)
            menu.FadeOut(menu_sc_pr)
        end
    end)
    if scoredata.menu_sc_pr then
        menu_sc_pr.pos = scoredata.menu_sc_pr.pos or 1
        menu_sc_pr.diffpos = scoredata.menu_sc_pr.diffpos or 1
        menu_sc_pr.spell = menu_sc_pr.spells[menu_sc_pr.diffpos]
    end
    --

    menu_replay_loader = New(replay_loader, function(filename, stageName)
        if not filename then
            menu.FadeIn(menu_title, 'left')
            menu.FadeOut(menu_replay_loader, 'right')
        else
            task.New(stage_menu, function()
                for i = 1, 60 do
                    SetBGMVolume(menu_music.now, 1 - i / 60)
                    task.Wait()
                end
                StopMusic(menu_music.now)
                scoredata["music_bar_time"] = menu_music.music_timer
            end)
            task.New(stage_menu, function()
                menu.FadeOut(menu_replay_loader, 'left')
                MaskFader()
                Print(filename, stageName)
                stage.IsReplay = true--判定进入rep播放的flag add by OLC
                stage.Set('load', filename, stageName)
            end)
        end
    end)
    local task_menu_init = function()
        PlaySound("se_notice", 1)
        menu.FadeIn(menu_title, 'right')
    end
    task.New(self, function()

        task.Wait(20)
        menu.FadeIn(menu_music)

    end)
    local sc_init = function()
        if scoredata.menu_sc_pr then
            menu_player_system_select.pos1 = scoredata.player_select
            menu_player_system_select.last_menu = menu_title
            menu_player_system_select.state = "spell"
            lstg.var.player_name = player_list[scoredata.player_select][2]
            menu_sc_pr.diffpos = scoredata.menu_sc_pr.diffpos or 1
            sc_pr_menu.TweakCard(menu_sc_pr)
            menu_sc_pr.spell = menu_sc_pr.spells[menu_sc_pr.diffpos]
            menu_sc_pr.pos = scoredata.menu_sc_pr.pos or 1
        end
    end
    ---★ 隐藏秘技：在**主菜单**连按 5 次数字 9 ⇒ 金钱补到 99999（不足才补）。
    ---写在这里用 task、而不是 stage_menu:frame()：menu_title 是 init 的局部变量，而
    ---「主菜单是不是在前台」要看它自己那套 alpha / locked，frame 方法里读不到。
    ---  · 前台判据 = menu_title.alpha > 0 且 not menu_title.locked，就是 main_menu:frame
    ---    决定要不要接输入的那两个条件（THlib/UI/menu.lua:232）；simple_menu:init 把
    ---    alpha 初始化成 0、locked 初始化成 true（同文件 :108,:113），淡入 30 帧走完才
    ---    locked = false（menu:FadeIn，同文件 :2-12）。子菜单会把主菜单 menu:FadeOut 到
    ---    alpha == 0 ⇒ 这个秘技只在主菜单这一屏生效。
    ---  · 用 GetKeyState 的**边沿**（按下那一刻）而不是 GetLastKey：GetLastKey 一帧只报
    ---    最后按下的那个键（引擎 AppFrame::GetLastKey ⇒ Keyboard::State::LastKeyDown），
    ---    而且按住不放时 Windows 会重复发 KEYDOWN，会被误算成「连按」；GetKeyState 是
    ---    「当前是否按住」（Keyboard::State::IsKeyDown，include_history 默认 false），
    ---    自己存上一帧的状态做边沿，和 THlib/lib/Linput.lua:18-31 的 KeyState/KeyStatePre 同理。
    ---  · 「连按」= 相邻两次间隔不超过 CHEAT_GAP 帧；超时、或主菜单不在前台就清零。
    ---    不是整个会话累计 5 次 —— 那样迟早会误触发。
    ---  · 加钱走 AddMoney()：它会同步 CurrentMoney 与 CurrentVerifiableOffset，绕过它直接
    ---    改 scoredata.money 会在 THlib/ext/ext.lua:303 的 CheckMoney() 里报 "Invalid value"
    ---    （core.lua:98-105）再强改回来。副作用：>=1万/4万/8万 那三个成就（core.lua:87-93）
    ---    会顺带解锁 —— 它们本来就是「存到多少钱」。
    ---  · 只补不足（已经 >= 99999 就不动），免得把攒得更多的存档改小。
    task.New(self, function()
        local CHEAT_KEY = KEY['9']      -- 只认主键盘区的 9（0x39）：NUMPAD9 是菜单的「右」。
        local CHEAT_TIMES = 5           -- 连按几下
        local CHEAT_GAP = 30            -- 「连按」窗口：30 帧 = 0.5 秒
        local CHEAT_MONEY = 99999       -- 目标金额
        local count, since, down_pre = 0, nil, false  -- since = 距上一次按下过了几帧（nil = 还没按过）
        while true do
            if menu_title.alpha > 0 and not menu_title.locked then
                local down = GetKeyState(CHEAT_KEY)
                if down and not down_pre then
                    if since and since <= CHEAT_GAP then
                        count = count + 1
                    else
                        count = 1
                    end
                    since = 0
                    if count >= CHEAT_TIMES then
                        count = 0
                        if scoredata.money < CHEAT_MONEY then
                            AddMoney(CHEAT_MONEY - scoredata.money)
                        end
                        PlaySound("extend")
                    end
                end
                down_pre = down
                if since then since = since + 1 end
            else
                count, since, down_pre = 0, nil, false
            end
            task.Wait()
        end
    end)
    if scoredata.version ~= ui.version then
        if scoredata.version and scoredata.version:sub(2, 2) and tonumber(scoredata.version:sub(2, 2)) >= 5 then
        else
            if FileExist("User\\saving1.file") then
                os.remove("User\\saving1.file")
            end
        end
        --更新版本初始化
        scoredata.version = ui.version
        --Include("mod\\update_init.lua")
        local file = io.open("Update.txt", "r")
        New(SimpleNotice, menu_title, "更新日志", file:read("*a"))
        file:close()
    end
    if stage.IsReplay then
        --rep播放后返回rep菜单 add by OLC
        stage.IsReplay = nil
        menu.FadeIn(menu_replay_loader, 'left')
    elseif stage.IsSCpractice then
        --符卡练习后返回符卡练习菜单 add by OLC
        stage.IsSCpractice = nil
        if self.save_replay then
            menu_replay_saver = New(replay_saver, self.save_replay, self.finish, function()
                menu.FadeOut(menu_replay_saver, 'right')
                menu.FadeIn(menu_sc_pr, 'left')
                task.New(menu_sc_pr, sc_init)
            end)
            menu.FadeIn(menu_replay_saver, 'left')
        else
            menu.FadeIn(menu_sc_pr, 'left')
            task.New(menu_sc_pr, sc_init)
        end
    else
        if self.save_replay then
            menu_replay_saver = New(replay_saver, self.save_replay, self.finish, function()
                menu.FadeOut(menu_replay_saver, 'right')
                task.New(stage_menu, function()
                    task.Wait(30)
                    task.New(stage_menu, task_menu_init)
                end)
            end)
            menu.FadeIn(menu_replay_saver, 'left')
        else
            task.New(stage_menu, task_menu_init)
        end
    end
end
function stage_menu:render()
    ui.DrawMenuBG()
    SetViewMode("ui")

    local time = scoredata["Duration"]
    ui:RenderText("title", string.format("%s：%d%s%d%s%d%s%d%s",
            "你玩了", time[5], "天", time[4], "时", time[3], "分", time[2], "秒"),
            675, 14, 1,
            Color(255, 160, 160, 160), "centerpoint")

    SetViewMode("world")
end

