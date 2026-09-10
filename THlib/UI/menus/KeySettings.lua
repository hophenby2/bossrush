---@class key_setting_menu
local _key_code_to_name = KeyCodeToName()
key_setting_menu = Class(simple_menu)

function key_setting_menu:init(keys, exit_func)
    self.layer = LAYER.TOP
    self.group = GROUP.GHOST
    self.alpha = 0
    self.offx = 0
    self.x = 480
    self.y = 270
    self.bound = false
    self.locked = true
    self.tri_alpha = 1
    self.field = {}
    self.key = {}
    self.text = {}
    for i, k in ipairs(keys) do
        self.field[i] = k[1]
        self.key[i] = k[2]
        self.text[i] = k[3]
    end
    table.insert(self.text, "恢复默认设置")
    table.insert(self.text, "返回标题菜单")
    self.pos = 1
    self.pos_pre = 1
    self.pos_changed = 0
    self.no_pos_change = false
    self.exit_func = exit_func
    self.w = 20
    self.alpha = 0
    self.count = #self.text
end

function key_setting_menu:frame()
    task.Do(self)
    if self.locked then
        return
    end
    if self.pos_changed > 0 then
        self.pos_changed = self.pos_changed - 1
    end
    local last_key = GetLastKey()
    if last_key ~= KEY.NULL then
        self.pos_changed = ui.menu.shake_time
        if self.edit then
            cur_setting[self.field[self.pos]][self.key[self.pos]] = last_key
            self.edit = false
            --save_setting()
            return
        end
    end
    if not self.edit then
        menu:Updatekey()
        menu:ControlExit(0, 30, 540, 510, function()
            self.pos = self.count
            self.exit_func()
            PlaySound('cancel00', 0.3)
        end)

        if menu:keyYes() then
            if self.pos == self.count then
                self.exit_func()
                PlaySound('cancel00', 0.3)
            elseif self.pos == self.count - 1 then
                for i, p in ipairs(self.key) do
                    cur_setting[self.field[i]][p] = default_setting[self.field[i]][p]
                end
                PlaySound('ok00', 0.3)
            else
                self.edit = true
                PlaySound('ok00', 0.3)
            end
        elseif menu:keyNo() then
            self.exit_func()
            PlaySound('cancel00', 0.3)
        else
            if menu:keyUp() and (not self.no_pos_change) then
                self.pos = sp:TweakValue(self.pos - 1, self.count, 1)
                task.New(self, function()
                    for i = 1, 30 do
                        self.tri_alpha = sin(i * 3)
                        task.Wait()
                    end
                end)
                PlaySound('select00', 0.3)
            end
            if menu:keyDown() and (not self.no_pos_change) then
                self.pos = sp:TweakValue(self.pos + 1, self.count, 1)
                task.New(self, function()
                    for i = 1, 30 do
                        self.tri_alpha = sin(i * 3)
                        task.Wait()
                    end
                end)
                PlaySound('select00', 0.3)
            end
            local mouse = ext.mouse
            if mouse:isDown(1) then
                local height = ui.menu.line_height
                local selected = menu:mouseCheck(self.y - height + (#self.text + 1) * height * 0.5, 0, height, #self.text)
                if selected then
                    if selected ~= self.pos then
                        PlaySound("select00")
                        self.pos = selected
                        task.New(self, function()
                            for i = 1, 30 do
                                self.tri_alpha = sin(i * 3)
                                task.Wait()
                            end
                        end)
                    else
                        if self.pos == self.count then
                            self.exit_func()
                            PlaySound('cancel00', 0.3)
                        elseif self.pos == self.count - 1 then
                            for i, p in ipairs(self.key) do
                                cur_setting[self.field[i]][p] = default_setting[self.field[i]][p]
                            end
                            PlaySound('ok00', 0.3)
                        else
                            self.edit = true
                            PlaySound('ok00', 0.3)
                        end
                    end
                end
            end
            if mouse._wheel ~= 0 then
                self.pos = sp:TweakValue(self.pos - sign(mouse._wheel), #self.text, 1)
                PlaySound("select00")
                task.New(self, function()
                    for i = 1, 30 do
                        self.tri_alpha = sin(i * 3)
                        task.Wait()
                    end
                end)
            end
        end

    end
    if self.pos_changed > 0 then
        self.pos_changed = self.pos_changed - 1
    end
    if self.pos_pre ~= self.pos then
        self.pos_changed = ui.menu.shake_time
    end
    self.pos_pre = self.pos
end

function key_setting_menu:render()
    if self.alpha == 0 then
        return
    end
    ui:DrawBack(self.alpha, self.timer)
    ui:DrawMenu('', self.text, self.pos, self.x - 176, self.y - ui.menu.line_height, self.alpha, self.timer, self.pos_changed, 'left', self.tri_alpha)
    local key_name = {}
    if self.edit then
        if self.timer % 30 < 15 then
            RenderText("Score", '___', self.x + 176, self.y + ui.menu.line_height * (self.count / 2 - self.pos), ui.menu.font_size, 'right')
        end
    end
    for i = 1, self.count - 2 do
        --table.insert(key_name,_key_code_to_name[cur_setting.keys[key_func[i]]])
        table.insert(key_name, _key_code_to_name[cur_setting[self.field[i]][self.key[i]]])
    end
    table.insert(key_name, '')
    table.insert(key_name, '')
    ui:DrawMenu('', key_name, self.pos, self.x + 176, self.y - ui.menu.line_height, self.alpha, self.timer, self.pos_changed, 'right', self.tri_alpha)
    menu:RenderExit(0, 30, 540, 510, self.alpha)

end
