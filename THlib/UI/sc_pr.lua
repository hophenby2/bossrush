local name = 'Spell Practice'
stage.group.New('menu', {}, name, false)
stage.group.AddStage(name, name .. '@' .. name, false, true)
stage.group.DefStageValue(name .. '@' .. name, 'init', function(self)
    item._init_item(self)
    mask_fader:Do("open")
    local group, index = lstg.var.sc_group[1], lstg.var.sc_group[2]
    local class = _sc_pr_table[group][index].sc_group[1].boss
    self.level = class.StageLevel or 1
    New(_G[lstg.var.player_name])
    if class._bg ~= nil then
        background.Create(class._bg)
    end
    task.New(self, function()
        task.Wait(10)
        if GetMusicState(class.bgm) ~= "playing" then
            PlayMusic(class.bgm, nil, nil, true)
        end
        local _ref = {}
        local t = 0
        for i, n in ipairs(_sc_pr_table[group][index].sc_group) do
            _ref[i] = New(n.boss, { n.card })
            t = t + 1
        end
        for i = 1, t do
            for j = 1, t do
                if j ~= i then
                    table.insert(_ref[i].otherboss, _ref[j])
                end
            end
        end
        for i = 1, t do
            while IsValid(_ref[i]) do
                task.Wait()
            end
        end
        task.Wait(150)
        if ext.replay.IsReplay() then
            ext.pop_pause_menu = true
            ext.rep_over = true
            lstg.tmpvar.pause_menu_text = { "再放送", "返回标题菜单", nil }
        else
            ext.pop_pause_menu = true
            lstg.tmpvar.death = false
            lstg.tmpvar.pause_menu_text = { '重新开始', "退出并保存录像", "返回标题菜单" }
            lstg.tmpvar.pause_menu_pos = 3
        end
        task.Wait(60)
    end)
    task.New(self, function()
        while coroutine.status(self.task[1]) ~= 'dead' do
            task.Wait()
        end
        mask_fader:Do("close")
        for _, v in pairs(EnumRes2('bgm')) do
            StopMusic(v)
        end
        task.Wait(30)
        stage.group.FinishStage()
    end)
end)
