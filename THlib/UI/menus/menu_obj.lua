---@class Notice
local SimpleNotice = Class(object)
_G.SimpleNotice = SimpleNotice
function SimpleNotice:init(cur_menu, title, text, w, h)
    self.bound = false
    self.colli = false
    object.init(self, screen.width / 2, screen.height * 1.5, GROUP.GHOST, LAYER.TOP)
    self.cur_menu = cur_menu
    self.title = title
    self.text = text
    self.lock = true
    self.width = w or 350
    self.height = h or 160
    self.pheight = 50
    self.select_col = 0
    self.max_select_col = 0
    task.New(self, function()
        task.SmoothSetValueTo("y", 270, 35, 2)
        self.lock = false
    end)
    self.ty = 0
    self._ty = 0
    self.texts = sp:SplitText(text, "\n")
    self.lines = #self.texts
end
function SimpleNotice:frame()
    task.Do(self)
    if not self.dk then
        if self.cur_menu then
            self.cur_menu.locked = true
        end
        if not self.lock then
            local line_h = 32 * 0.8 * 0.61
            local x = self.x
            local y = self.y
            local w = self.width
            local h = self.height
            local ph = self.pheight
            self._ty = self._ty + (-self._ty + Forbid(self._ty, 0, max(line_h * self.lines - h * 2, 0))) * 0.3
            self.ty = self.ty + (-self.ty + self._ty) * 0.3
            self.select_col = self.select_col + (-self.select_col + self.max_select_col) * 0.2
            menu:Updatekey()
            if menu:keyYes() or menu:keyNo() then
                Del(self)
                PlaySound("ok00")
            end
            if menu:keyDown() then
                self._ty = self._ty + line_h * 4
                PlaySound("select00")
            end
            if menu:keyUp() then
                self._ty = self._ty - line_h * 4
                PlaySound("select00")
            end
            local mouse = ext.mouse
            if sp.math.PointBoundCheck(mouse.x, mouse.y, x - w, x + w, y - h, y - h - ph) then
                self.max_select_col = 100
                if mouse:isDown(1) then
                    Del(self)
                    PlaySound("ok00")
                end
            else
                self.max_select_col = 0
            end
            if mouse._wheel ~= 0 then
                self._ty = self._ty - sign(mouse._wheel) * line_h * 4
                PlaySound("select00")
            end
        end
    end

end
function SimpleNotice:render()
    SetViewMode("ui")
    local scrh = screen.height
    local line_h = 32 * 0.8 * 0.61
    local x = self.x
    local y = self.y
    local w = self.width
    local h = self.height
    local ph = self.pheight
    local alpha = (scrh * 1.5 - y) / scrh
    local pulse = self.select_col
    SetImageState("white", "", alpha * 150, 0, 0, 0)
    RenderRect("white", 0, screen.width, 0, scrh)
    SetImageState("white", "", alpha * 150, 70, 40, 40)
    RenderRect("white", x - w, x + w, y + h, y + h + ph)
    SetImageState("white", "", alpha * 150, 20, 20, 20)
    RenderRect("white", x - w, x + w, y + h, y - h)
    SetImageState("white", "", alpha * 150, 20 + pulse, 30 + pulse * 2, 30 + pulse)
    RenderRect("white", x - w, x + w, y - h, y - h - ph)
    SetImageState("white", "", alpha * 255, 255, 255, 255)
    misc.RenderOutLine("white", x - w, x + w, y - h - ph, y + h + ph, 0, 2)
    RenderRect("white", x - w, x + w, y - h, y - h - 2)
    RenderRect("white", x - w, x + w, y + h, y + h + 2)
    ui:RenderText("big_text", self.title, x, y + h + ph / 2,
            0.7, Color(255, 255, 255, 255), "centerpoint")
    ui:RenderText("big_text", "确认", x, y - h - ph / 2,
            0.5 + pulse / 100 * 0.3, Color(255, 255, 255, 255), "centerpoint")
    local ty = Forbid(y + h, 0, scrh)
    local by = Forbid(y - h, 0, scrh)
    if (-w) ~= w and (by - y) ~= (ty - y) and (x - w) ~= (x + w) and by ~= ty then
        SetRenderRect(-w, w, by - y, ty - y, x - w, x + w, by, ty)
        local Y = self.ty + h
        for _, str in ipairs(self.texts) do
            if Y > -h - line_h and Y < h + line_h then
                ui:RenderText("title", str, -w + 10, Y, 0.8, Color(255, 255, 255, 255), "left", "top")
            end
            Y = Y - line_h
        end
    end
    SetViewMode("ui")


end
function SimpleNotice:del()
    if self.cur_menu then
        self.cur_menu.locked = false
    end
    object.Preserve(self)
    self.dk = true
    task.New(self, function()
        task.SmoothSetValueTo("y", 720, 35, 1)
        object.RawDel(self)
    end)
end

local SimpleChoose = Class(object)
_G.SimpleChoose = SimpleChoose
function SimpleChoose:init(cur_menu, yes, no, title, text, w, h)
    self.bound = false
    self.colli = false
    object.init(self, screen.width / 2, screen.height * 1.5, GROUP.GHOST, LAYER.TOP)
    self.cur_menu = cur_menu
    self.title = title
    self.text = text
    self.lock = true
    self.width = w or 350
    self.height = h or 160
    self.pheight = 50
    self.pos = 1
    self.yes_func = yes
    self.no_func = no
    task.New(self, function()
        task.SmoothSetValueTo("y", 270, 35, 2)
        self.lock = false
    end)
    self.ty = 0
    self._ty = 0
    self.texts = sp:SplitText(text, "\n")
    self.lines = #self.texts
end
function SimpleChoose:frame()
    task.Do(self)
    if not self.dk then
        if self.cur_menu then
            self.cur_menu.locked = true
        end
        if not self.lock then
            local line_h = 32 * 0.8 * 0.61
            local x = self.x
            local y = self.y
            local w = self.width
            local h = self.height
            local ph = self.pheight
            self._ty = self._ty + (-self._ty + Forbid(self._ty, 0, max(line_h * self.lines - h * 2, 0))) * 0.3
            self.ty = self.ty + (-self.ty + self._ty) * 0.3
            menu:Updatekey()
            if menu:keyYes() then
                if self.pos == 1 then
                    Del(self)
                    self.yes_func()
                    PlaySound("ok00")
                else
                    Del(self)
                    self.no_func()
                    PlaySound("cancel00")
                end
            end
            if menu:keyNo() then
                Del(self)
                self.no_func()

                PlaySound("cancel00")
            end
            if menu:keyDown() then
                self._ty = self._ty + line_h * 4
                PlaySound("select00")
            end
            if menu:keyUp() then
                self._ty = self._ty - line_h * 4
                PlaySound("select00")
            end
            if menu:keyLeft() or menu:keyRight() then
                self.pos = self.pos % 2 + 1
                PlaySound("select00")
            end
            local mouse = ext.mouse
            if sp.math.PointBoundCheck(mouse.x, mouse.y, x - w, x, y - h, y - h - ph) then
                if mouse:isDown(1) then
                    Del(self)
                    self.pos=1
                    self.yes_func()

                    PlaySound("ok00")
                end
            end
            if sp.math.PointBoundCheck(mouse.x, mouse.y, x + w, x, y - h, y - h - ph) then
                if mouse:isDown(1) then
                    Del(self)
                    self.pos=2
                    self.no_func()

                    PlaySound("cancel00")
                end
            end
            if mouse._wheel ~= 0 then
                self._ty = self._ty - sign(mouse._wheel) * line_h * 4
                PlaySound("select00")
            end
        end
    end

end
function SimpleChoose:render()
    SetViewMode("ui")
    local scrh = screen.height
    local line_h = 32 * 0.8 * 0.61
    local x = self.x
    local y = self.y
    local w = self.width
    local h = self.height
    local ph = self.pheight
    local alpha = (scrh * 1.5 - y) / scrh
    SetImageState("white", "", alpha * 150, 0, 0, 0)
    RenderRect("white", 0, screen.width, 0, scrh)
    SetImageState("white", "", alpha * 150, 70, 40, 40)
    RenderRect("white", x - w, x + w, y + h, y + h + ph)
    SetImageState("white", "", alpha * 150, 20, 20, 20)
    RenderRect("white", x - w, x + w, y + h, y - h)
    SetImageState("white", "", alpha * 150, 20, (self.pos == 1) and 150 or 30, 30)
    RenderRect("white", x - w, x, y - h, y - h - ph)
    SetImageState("white", "", alpha * 150, 20, (self.pos == 2) and 150 or 30, 30)
    RenderRect("white", x + w, x, y - h, y - h - ph)

    SetImageState("white", "", alpha * 255, 255, 255, 255)
    RenderRect("white", x-1, x+1, y - h, y - h - ph)
    misc.RenderOutLine("white", x - w, x + w, y - h - ph, y + h + ph, 0, 2)
    RenderRect("white", x - w, x + w, y - h, y - h - 2)
    RenderRect("white", x - w, x + w, y + h, y + h + 2)
    ui:RenderText("big_text", self.title, x, y + h + ph / 2,
            0.7, Color(255, 255, 255, 255), "centerpoint")
    ui:RenderText("big_text", "确定", x - w / 2, y - h - ph / 2,
            0.7, Color(255, 255, 255, 255), "centerpoint")
    ui:RenderText("big_text", "取消", x + w / 2, y - h - ph / 2,
            0.7, Color(255, 255, 255, 255), "centerpoint")
    local ty = Forbid(y + h, 0, scrh)
    local by = Forbid(y - h, 0, scrh)
    if (-w) ~= w and (by - y) ~= (ty - y) and (x - w) ~= (x + w) and by ~= ty then
        SetRenderRect(-w, w, by - y, ty - y, x - w, x + w, by, ty)
        local Y = self.ty + h
        for _, str in ipairs(self.texts) do
            if Y > -h - line_h and Y < h + line_h then
                ui:RenderText("title", str, -w + 10, Y, 0.8, Color(255, 255, 255, 255), "left", "top")
            end
            Y = Y - line_h
        end
    end
    SetViewMode("ui")


end
function SimpleChoose:del()
    if self.cur_menu then
        self.cur_menu.locked = false
    end
    object.Preserve(self)
    self.dk = true
    task.New(self, function()
        task.SmoothSetValueTo("y", 720, 35, 1)
        object.RawDel(self)
    end)
end