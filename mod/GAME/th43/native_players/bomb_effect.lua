local defaultRenderAni=EGGlib.RenderEffect.defaultRenderAni
local text_move_v = 1
local text_move_a = 90
local text_move_vx = text_move_v * cos(text_move_a)
local text_move_vy = text_move_v * sin(text_move_a)
local text_move_dv = 0.02
local text_move_da = 90
local text_move_ax = text_move_dv * cos(text_move_da)
local text_move_ay = text_move_dv * sin(text_move_da)
local text_life_time = 45
local float_dec_bomb = Class(object)
float_dec_bomb.img_list = {
    [1] = "-1bomb",
    [2] = "-2bomb"
}
function float_dec_bomb:init(x, y, value)
    self.layer = LAYER_TOP
    self.x = x
    self.y = y
    self.ax = text_move_ax
    self.ay = text_move_ay
    self.vx = text_move_vx
    self.vy = text_move_vy
    self.img = float_dec_bomb.img_list[value]
    robject.set_color(self, "", 255, 255, 255, 255)
end
function float_dec_bomb:frame()
    if self.timer > text_life_time - 15 and self.timer < text_life_time then
        self._a = (text_life_time - self.timer)/15*255
    elseif self.timer == text_life_time then
        self.status = "del"
        self.hide = true
    end
end
function float_dec_bomb:render()
    defaultRenderAni(self)
end

--漂浮bomb减少数
function effect.decBombEffect(dec_count)
    dec_count = max(1, min(2, dec_count))
    local xpos = player.x - 30
    if xpos < (lstg.world.l + 90) then
        New(float_dec_bomb, player.x + 30, player.y, dec_count)
    else
        New(float_dec_bomb, xpos, player.y, dec_count)
    end

end