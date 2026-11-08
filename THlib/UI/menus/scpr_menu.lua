---@class sc_pr_menu
sc_pr_menu = Class(object)
function sc_pr_menu.GetCardInfo(sc, player)
    return spell_card_data[sc.card_id][player]
end
function sc_pr_menu.IfInsertCard(sc)
    return true
end

function sc_pr_menu:TweakCard(onlyshowcard, onlyshowspecialcard)
    self.spells = {}
    local num = 1
    for t in ipairs(ui.menu.difftext) do
        self.spells[t] = {}
        for i, sc in ipairs(_sc_pr_table[t] or {}) do
            local card = sc.sc_group[1].card
            if not onlyshowcard or card.is_sc then
                if not onlyshowspecialcard or card.is_od then
                    table.insert(self.spells[t], { i, num, sc_pr_menu.IfInsertCard(card), t })

                end
            end
            num = num + 1
        end
    end
    local tmp = {}
    num = 1
    for t in ipairs(ui.menu.difftext) do
        for i, sc in ipairs(_sc_pr_table[t] or {}) do
            local card = sc.sc_group[1].card
            if not onlyshowcard or card.is_sc then
                if not onlyshowspecialcard or card.is_od then
                    table.insert(tmp, { i, num, sc_pr_menu.IfInsertCard(card), t })

                end
            end
            num = num + 1
        end
    end
    table.insert(self.spells, tmp)
    self.keyname = KeyCodeToName()
end

local function GetCardUnlock(sc)
    return true
end

function sc_pr_menu:init(exit_func)
    self.layer = LAYER.TOP
    self.group = GROUP.GHOST
    self.tri_alpha = 1
    self.tri_alpha2 = 1
    self.alpha = 0

    self.exit_func = exit_func
    self.onlyshowcard = scoredata.onlyshowcard or false
    self.onlyshowspecialcard = scoredata.onlyshowspecialcard or false
    self.x = screen.width * 0.5
    self.y = screen.height * 0.5
    self.bound = false
    self.locked = true
    self.npage = 1
    self.page = 0
    self.pos = 1
    self.pos_changed = 0
    self.state = 1
    self.difficulty = sp:CopyTable(ui.menu.difftext)
    table.insert(self.difficulty, "全部")
    setmetatable(self.difficulty, { __index = function(t, k)
        return rawget(t, (k - 1) % #t + 1)
    end })
    self.ox = 0
    self.diffpos = 1
    self.cardinfo = spell_card_data
    sc_pr_menu.TweakCard(self, self.onlyshowcard, self.onlyshowspecialcard)

    self.spell = self.spells[1]
    self._spell, self._pos = sp:GetListSection(self.spell, 14, self.pos, 7)
    self.tri = { 1, 1 }
    self.set_index = { 0, 0 }

    function self:settri()
        self.tri_alpha = 0
        task.New(self, function()
            for i = 1, 10 do
                self.tri_alpha = sin(i * 9)
                task.Wait()
            end
        end)
    end
    function self:setsomealpha(index)
        index = index or 1
        self.tri_alpha = 0
        self.tri[index] = 0
        self.tri_alpha2 = 0
        task.New(self, function()
            for i = 1, 10 do
                self.tri_alpha = sin(i * 9)
                self.tri[index] = sin(i * 9)
                self.tri_alpha2 = sin(i * 9)
                task.Wait()
            end
        end)
    end
    function self:adddiffpos(num, index)
        self.pos_changed = ui.menu.shake_time
        self.diffpos = sp:TweakValue(self.diffpos + num, #self.difficulty, 1)
        self.ox = self.ox + num * 130
        self.spell = self.spells[self.diffpos]
        self.pos = min(#self.spell, self.pos)
        self:setsomealpha(index)
        PlaySound('select00', 0.3)
    end
    function self:addpos(num)
        PlaySound('select00', 0.3)
        self.pos = self.pos + num
        self:settri()
        self.pos_changed = ui.menu.shake_time
    end
    function self:yes()
        if #self.spell > 0 then
            local group = self.spell[self.pos][4]
            local index = self.spell[self.pos][1]
            if _sc_pr_table[group][index] and (DEBUG or (GetCardUnlock(_sc_pr_table[group][index].sc_group[1].card) and self.spell[self.pos][3])) then
                if self.exit_func then
                    self.exit_func(_sc_pr_table[group][index].index, { group, index })
                end
                PlaySound('ok00', 0.3)
            else
                PlaySound('invalid', 0.5)
            end
        else
            PlaySound('invalid', 0.5)
        end
    end
end
function sc_pr_menu:frame()
    task.Do(self)
    scoredata.onlyshowcard = self.onlyshowcard
    scoredata.onlyshowspecialcard = self.onlyshowspecialcard
    scoredata.menu_sc_pr = { pos = self.pos, diffpos = self.diffpos }
    for i in ipairs(self.set_index) do
        self.set_index[i] = self.set_index[i] - self.set_index[i] * 0.1
    end
    self._spell, self._pos = sp:GetListSection(self.spell, 14, self.pos, 7)
    self.cur_nums = 0
    for _, t in ipairs(self.spell) do
        local group = t[4]
        local index = t[1]
        if _sc_pr_table[group] and _sc_pr_table[group][index] then
            self.cur_nums = self.cur_nums + #(_sc_pr_table[group][index].sc_group)
        end
    end
    if self.locked then
        return
    end
    local mouse = ext.mouse
    menu:Updatekey()
    menu:ControlExit(0, 30, 540, 510)
    if GetLastKey() == setting.keys.special then
        if GetKeyState(KEY.CTRL) then
            self.onlyshowspecialcard = not self.onlyshowspecialcard
            self.set_index[2] = 1
            sc_pr_menu.TweakCard(self, self.onlyshowcard, self.onlyshowspecialcard)
            self.spell = self.spells[self.diffpos]
            self:setsomealpha(1)
        else
            self.onlyshowcard = not self.onlyshowcard
            self.set_index[1] = 1
            sc_pr_menu.TweakCard(self, self.onlyshowcard, self.onlyshowspecialcard)
            self.spell = self.spells[self.diffpos]
            self:setsomealpha(1)
        end
        PlaySound("ok00")
    end
    if menu:keyYes() then
        self:yes()
    elseif menu:keyNo() then
        PlaySound('cancel00', 0.3)
        if self.exit_func then
            self.exit_func()
        end
    else
        if menu:keyUp() then
            self:addpos(-1)
        end
        if menu:keyDown() then
            self:addpos(1)
        end
        if menu:keyLeft() then
            self:adddiffpos(-1, 1)
        end
        if menu:keyRight() then
            self:adddiffpos(1, 2)
        end
        if sp.math.PointBoundCheck(mouse.x, mouse.y, 0, 960, 460, 440) then
            if mouse:isDown(1) then
                for i = -3, 3 do
                    if abs(mouse.x - 480 - i * 130) < 65 and i ~= 0 then
                        self:adddiffpos(i, sign(i) * 0.5 + 1.5)
                    end
                end
            end
            if mouse._wheel ~= 0 then
                self:adddiffpos(-sign(mouse._wheel), -sign(mouse._wheel) * 0.5 + 1.5)
            end
        else
            if mouse:isDown(1) then
                local height = ui.menu.sc_pr_line_height
                local selected = menu:mouseCheck(270 - 15 + (#self._spell + 1) * height * 0.5, 0, height, #self._spell)
                if selected then
                    if selected ~= self._pos then
                        self:addpos(selected - self._pos)
                    else
                        self:yes()
                    end
                elseif sp.math.PointBoundCheck(mouse.x, mouse.y, 700, 830, 55, 85) then
                    self.onlyshowcard = not self.onlyshowcard
                    self.set_index[1] = 1
                    sc_pr_menu.TweakCard(self, self.onlyshowcard, self.onlyshowspecialcard)
                    self.spell = self.spells[self.diffpos]
                    self:setsomealpha(1)
                    PlaySound("ok00")
                elseif sp.math.PointBoundCheck(mouse.x, mouse.y, 700, 830, 25, 55) then
                    self.onlyshowspecialcard = not self.onlyshowspecialcard
                    self.set_index[2] = 1
                    sc_pr_menu.TweakCard(self, self.onlyshowcard, self.onlyshowspecialcard)
                    self.spell = self.spells[self.diffpos]
                    self:setsomealpha(1)
                    PlaySound("ok00")
                end
            end
            if mouse._wheel ~= 0 then
                self:addpos(-sign(mouse._wheel))
            end
        end
    end

    self.ox = self.ox - self.ox * 0.08
    self.pos = sp:TweakValue(self.pos, max(1, #self.spell), 1)
    self.pos = max(1, self.pos)
    if self.pos_changed > 0 then
        self.pos_changed = self.pos_changed - 1
    end
end

function sc_pr_menu:render()
    if self.alpha == 0 then
        return
    end
    SetViewMode('ui')
    ui:DrawBack(self.alpha, self.timer)
    OriginalSetImageState("white", "",
            Color(0, 0, 0, 0),
            Color(200 * self.alpha, 0, 0, 0),
            Color(200 * self.alpha, 0, 0, 0),
            Color(0, 0, 0, 0))
    RenderRect("white", 76, 480, 460, 440)
    RenderRect("white", 884, 480, 460, 440)
    SetImageState("white", "", 255, 0, 0, 0)
    for i = -5, 5 do
        ui:RenderText("title", self.difficulty[self.diffpos + i], 480 + 130 * i + self.ox, 450, 1,
                Color((((i == 0) and 255) or 120) * self.alpha, 255, 255, 255), "centerpoint")
    end
    local float = sin(self.ani * 3) * 3
    local rgb = 255 - 127 * self.tri[1]
    SetImageState("white", "", 150 * self.alpha, rgb, rgb, rgb)
    Render4V("white",
            14 + float, 450, 0.5, 20 + float, 456, 0.5,
            20 + float, 444, 0.5, 14 + float, 450, 0.5)
    rgb = 255 - 127 * self.tri[2]
    SetImageState("white", "", 150 * self.alpha, rgb, rgb, rgb)
    Render4V("white",
            946 - float, 450, 0.5, 940 - float, 456, 0.5,
            940 - float, 444, 0.5, 946 - float, 450, 0.5)
    SetImageState("white", "", 150 * self.alpha * self.tri_alpha2, 0, 0, 0)
    local y = -15
    RenderRect('white',
            self.x - ui.menu.sc_pr_width * 0.5 - ui.menu.sc_pr_margin,
            self.x + ui.menu.sc_pr_width * 0.5 + ui.menu.sc_pr_margin,
            self.y - ui.menu.sc_pr_line_height * #self._spell * 0.5 - ui.menu.sc_pr_margin + y,
            self.y + ui.menu.sc_pr_line_height * #self._spell * 0.5 + ui.menu.sc_pr_margin + y)
    local text1, text2, text3 = {}, {}, {}
    local sc, name, card, nums
    for i, t in ipairs(self._spell) do
        local group = t[4]
        local index = t[1]
        if _sc_pr_table[group] and _sc_pr_table[group][index] then
            sc = _sc_pr_table[group][index]
            name = {}
            nums = 0
            for _, id in ipairs(sc.sc_group) do
                table.insert(name, id.boss.name)
                nums = nums + 1
            end
            card = sc.sc_group[1].card
            text2[i] = table.concat(name, "&")
            local str = sp.string(text2[i])
            if str:GetLength() > 36 then
                text2[i] = str:Sub(1, 16) .. "......" .. str:Sub(-16, -1)
            end
            text2[i] = "(" .. nums .. ") " .. text2[i]
            local cardname
            if GetCardUnlock(card) then
                if t[3] then
                    cardname = sc.CardName
                else
                    cardname = "-----未初见该符卡-----"
                end
            else
                cardname = "-----特殊符卡，未解锁-----"
            end
            text1[i] = ("%03d. %s"):format(t[2], cardname)
            if self.cardinfo[card.card_id] and self.cardinfo[card.card_id][lstg.var.player_name] then
                if card.is_sc then
                    text3[i] = ("%d / %d"):format(unpack(self.cardinfo[card.card_id][lstg.var.player_name]))
                else
                    text3[i] = ("%d / %d"):format(unpack(self.cardinfo[card.card_id][lstg.var.player_name]))
                end
            end
        end
    end

    local a = self.alpha * self.tri_alpha2
    ui:DrawMenuTTF(text1, self._pos, self.x - ui.menu.sc_pr_width * 0.5, self.y + y, a, self.timer, 'left', self.tri_alpha)
    ui:DrawMenuTTF(text2, self._pos, self.x + ui.menu.sc_pr_width * 0.5, self.y + y, a, self.timer, 'right', self.tri_alpha)
    ui:DrawMenuTTF(text3, self._pos, self.x, self.y + y, a, self.timer, 'center', self.tri_alpha)
    ui:RenderText("title", ("%s%s：%d"):format(self.difficulty[self.diffpos], "卡数", self.cur_nums),
            130, 70, 1, Color(a * 255, 255, 255, 255), "left", "vcenter")
    ui:RenderText("title", ("%s：%d (特殊：%d)"):format("总卡数", #_sc_table, #_sc_table - boss.card.GetCardNums()),
            130, 40, 1, Color(self.alpha * 255, 255, 255, 255), "left", "vcenter")
    local osc = self.onlyshowcard
    local ossc = self.onlyshowspecialcard
    local si = self.set_index
    ui:RenderText("title", ("仅显示符卡(%s)"):format(self.keyname[setting.keys.special]), 830, 70, 1 + si[1] * 0.1,
            Color(self.alpha * 255, 255, 255, 255 - (osc and 150 or 0)), "right", "vcenter")
    ui:RenderText("title", ("仅显示特殊符卡(Ctrl + %s)"):format(self.keyname[setting.keys.special]), 830, 40, 1 + si[2] * 0.1,
            Color(self.alpha * 255, 255, 255, 255 - (ossc and 150 or 0)), "right", "vcenter")

    menu:RenderExit(0, 30, 540, 510, self.alpha)
end
