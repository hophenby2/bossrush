Include("THlib\\UI\\loading.lua")

stage_menu = stage.New('menu', false, true)

function stage_menu:init()
    local menu_title, menu_replay_loader, menu_replay_saver, menu_setting
    local menu_key, menu_music, menu_player_system_select
    local menu_stage_practice,menu_spell_practice,menu_sequence_select
    local menu_sequence_player
    --
    --
    mask_fader:Do("open")
    local function MaskFader()
        task.Wait(30)
        mask_fader:Do("close")
        task.Wait(30)
    end
    -- 这个旧标志也控制 IncludeLuaFile 的载入时机，停用成就后仍须保留。
    GlobalAddAchievement = true
    if GameFeatures.achievements then
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

    local function startPractice(source,start)
        menu.FadeOut(source);menu.FadeOut(menu_music)
        task.New(stage_menu,function()
            for i=1,60 do SetBGMVolume(menu_music.now,1-i/60);task.Wait() end
            StopMusic(menu_music.now);scoredata.music_bar_time=menu_music.music_timer
        end)
        task.New(stage_menu,function()
            MaskFader()
            lstg.var.rogue_run=nil;lstg.var.timeslow=nil
            start()
        end)
    end
    local dreamerEquipment={
        dream={{'Wide Form','Homing Form'},{'Lock-On Form','Focus Form'},{'Carrot Blaster','Vivid Grenade'}},
        cute={{'Front Form','Slide Form'},{'Focus Form','Homing Form'},{'Stinging Words','Dark Rampage'}},
        cool={{'Slide Form','Front Form'},{'Fixed Form','Standby Form'},{'Flaming Hack','Cheat Barrier'}},
    }
    local function selectDreamerEquipment(source,machine,start)
        local selector
        local function back() menu.FadeOut(selector);menu.FadeIn(source) end
        local equipment=dreamerEquipment[machine.id]
        local choices={equipment[1],equipment[2],equipment[3],
            {'Shield Enhance','Shot Enhance','Missile Enhance','Double Enhance'},
            {'Auto Fever','Manual Fever'},{'反击弹关闭','反击弹开启'}}
        local labels={'主射击','副射击','Bomb','强化','Fever','反击弹'}
        local loadout,rows={0,0,0,0,0,0},{}
        for i,options in ipairs(choices) do
            rows[i]={labels[i]..'　'..options[1],function()
                loadout[i]=(loadout[i]+1)%#options
                selector.text[i]=labels[i]..'　'..options[loadout[i]+1]
            end,''}
        end
        rows[#rows+1]={'开始',function()
            startPractice(selector,function() start(machine.id,loadout) end)
        end,'Start'}
        rows[#rows+1]={'返回',back,'Back'}
        selector=New(main_menu,machine.name,rows,back)
        menu.FadeOut(source);menu.FadeIn(selector)
    end
    local function launchNative(source,level,machine,start)
        if level==40 then selectDreamerEquipment(source,machine,start)
        else startPractice(source,function() start(machine.id) end) end
    end
    local function selectNativePractice(source,level,start)
        local machines=NativePlayers and NativePlayers.machines(level)
        if not machines then startPractice(source,start);return end
        local selector
        local function back() menu.FadeOut(selector);menu.FadeIn(source) end
        local rows={}
        for _,machine in ipairs(machines) do
            local id=machine.id
            rows[#rows+1]={machine.name,function()
                launchNative(selector,level,machine,start)
            end,'',key=id}
        end
        rows[#rows+1]={'返回',back,'Back',key='back'}
        selector=New(main_menu,'选择原作机体',rows,back)
        menu.FadeOut(source);menu.FadeIn(selector)
    end
    local function createPracticeMenus()
        if menu_stage_practice then return end
        menu_stage_practice=New(stage_select,function()
            menu.FadeOut(menu_stage_practice);menu.FadeIn(menu_player_system_select)
        end,function(pos)
            local entry=menu_stage_practice.stage_selects[pos]
            local name=type(entry.stage)~='function' and entry.stage.name
            selectNativePractice(menu_stage_practice,NativePlayers and NativePlayers.practiceLevel(name),function(id,loadout)
                lstg.var.sc_index,lstg.var.sc_group=nil,nil
                if name then stage.group.PracticeStart(name,false,id,loadout) else entry.stage() end
            end)
        end)
        menu_spell_practice=New(sc_pr_menu,function(index,group)
            if not index then
                menu.FadeOut(menu_spell_practice);menu.FadeIn(menu_player_system_select);return
            end
            selectNativePractice(menu_spell_practice,group[1],function(id,loadout)
                lstg.var.sc_index,lstg.var.sc_group=index,group
                stage.group.PracticeStart('Spell Practice@Spell Practice',true,id,loadout)
            end)
        end)
    end
    local function openPractice(mode)
        createPracticeMenus()
        menu_player_system_select:fresh('practice')
        menu_player_system_select.state=mode
        menu.FadeIn(menu_player_system_select);menu.FadeOut(menu_title)
    end
    local function openSequence()
        if not menu_sequence_select then
            local function back() menu.FadeOut(menu_sequence_select);menu.FadeIn(menu_title) end
            local entries={}
            for _,entry in ipairs(OriginalSequence.catalog.entries) do
                local key=entry.key
                entries[#entries+1]={entry.title,function()
                    local function backPlayer() menu.FadeOut(menu_sequence_player);menu.FadeIn(menu_sequence_select) end
                    local machines={}
                    for _,machine in ipairs(OriginalSequence.machines(entry)) do
                        local id=machine.id
                        machines[#machines+1]={machine.name,function()
                            launchNative(menu_sequence_player,entry.level,machine,function(selected,loadout)
                                OriginalSequence.start(key,selected,loadout)
                            end)
                        end,'',key=id}
                    end
                    machines[#machines+1]={'返回',backPlayer,'Back',key='back'}
                    menu_sequence_player=New(main_menu,'选择原作机体',machines,backPlayer)
                    menu.FadeOut(menu_sequence_select);menu.FadeIn(menu_sequence_player)
                end,'Original Order',key=key}
            end
            entries[#entries+1]={'返回',back,'Back',key='back'}
            menu_sequence_select=New(main_menu,'选择原作关卡',entries,back)
        end
        menu.FadeOut(menu_title);menu.FadeIn(menu_sequence_select)
    end
    local function titleContent()
        local content={
        { "roguelike模式", function()
            menu_player_system_select:fresh('roguelike')
            menu_player_system_select.state = "stage"
            menu.FadeIn(menu_player_system_select)
            menu.FadeOut(menu_title)
        end, "Roguelike" },
        { "顺序模式", openSequence, "Original Order" },
        { "查看录像", function()
            replay_loader.Refresh(menu_replay_loader)
            menu.FadeIn(menu_replay_loader, "left")
            menu.FadeOut(menu_title, "left")
        end, "Replay" },
        { "按键设置", function()
            menu.FadeIn(menu_key)
            menu.FadeOut(menu_title, "left")
        end, "Key Settings" },
        { "其他设置", function()
            menu.FadeIn(menu_setting)
            menu.FadeOut(menu_title)
            menu_setting.pos = 1
        end, "Options" },
        { "退出游戏", ExitGame, "Quit Game" }
        }
        if GameDebug.enabled then
            table.insert(content,2,{'关卡练习',function() openPractice('stage_practice') end,'Stage Practice'})
            table.insert(content,3,{'符卡练习',function() openPractice('spell_practice') end,'Spell Practice'})
        end
        return content
    end
    menu_title = New(main_menu, '', titleContent(), function()
        if menu_title.pos == #menu_title.text then
            ExitGame()
        else
            menu_title.pos = #menu_title.text
        end
    end)
    menu_title.on_debug_unlocked=function()
        -- 原地更新菜单，保留当前选中项；下一次返回标题时直接按会话状态建立两个入口。
        local selected=menu_title.text[menu_title.pos]
        menu_title.content=titleContent()
        menu_title.text,menu_title.func,menu_title.sub_title,menu_title.nopos={},{},{},{}
        for i,entry in ipairs(menu_title.content) do
            menu_title.text[i],menu_title.func[i],menu_title.sub_title[i]=entry[1],entry[2],entry[3]
            if entry[1]==selected then menu_title.pos=i end
        end
        menu_title._pos,menu_title.pos_pre=menu_title.pos,menu_title.pos
    end
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
                RogueTen.start('single', menu_player_system_select.pool_options)
            end)
        elseif start=='original_sequence' then
            if not menu_sequence_select then
                local function back() menu.FadeOut(menu_sequence_select);menu.FadeIn(menu_player_system_select) end
                local entries={}
                for _,entry in ipairs(OriginalSequence.catalog.entries) do
                    local key=entry.key
                    entries[#entries+1]={entry.title,function()
                        startPractice(menu_sequence_select,function() OriginalSequence.start(key) end)
                    end,'Original Order',key=key}
                end
                entries[#entries+1]={'返回',back,'Back',key='back'}
                menu_sequence_select=New(main_menu,'选择原作关卡',entries,back)
            end
            menu.FadeOut(menu_player_system_select);menu.FadeIn(menu_sequence_select)
        elseif start=='stage_practice' then
            stage_select.fresh(menu_stage_practice)
            menu.FadeOut(menu_player_system_select);menu.FadeIn(menu_stage_practice)
        elseif start=='spell_practice' then
            menu.FadeOut(menu_player_system_select);menu.FadeIn(menu_spell_practice)
        else
            menu.FadeOut(menu_player_system_select)
            menu.FadeIn(menu_title)
        end
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
    menu_setting = New(game_setting, function()
        menu.FadeIn(menu_title)
        menu.FadeOut(menu_setting)
        save_setting()
    end)

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
            if GameFeatures.resume and FileExist(SaveProfiles.path("saving1.file")) then
                os.remove(SaveProfiles.path("saving1.file"))
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
    if AndroidPortrait and AndroidPortrait.enabled() then return end
    SetViewMode("ui")

    local time = scoredata["Duration"]
    ui:RenderText("title", string.format("%s：%d%s%d%s%d%s%d%s",
            "你玩了", time[5], "天", time[4], "时", time[3], "分", time[2], "秒"),
            675, 14, 1,
            Color(255, 160, 160, 160), "centerpoint")

    SetViewMode("world")
end

