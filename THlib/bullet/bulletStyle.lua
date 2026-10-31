---@class bulletStyle
bulletStyle = Class(object)
function bulletStyle:frame()
    if not self.stay then
        if not (self._forbid_ref) then
            --by OLC，修正了defaul action死循环的问题
            self._forbid_ref = true
            self.logclass.frame(self)
            self._forbid_ref = nil
        end
    else
        self.x = self.x - self.vx
        self.y = self.y - self.vy
        self.rot = self.rot - self.omiga
    end
    if self.timer == self.fogtime then
        self.class = self.logclass
        self.layer = self._layer - self.imgclass.size * 0.001 + self._index * 0.00001
        if self.stay then
            self.timer = -1
        end
    end
end
function bulletStyle:del()
    New(bubble2, 'preimg' .. self._index, self.x, self.y, self.dx, self.dy, 11, self.imgclass.size, 0,
            Color(0xFFFFFFFF), Color(0xFFFFFFFF), self.layer, 'mul+add')
end
function bulletStyle:kill()
    bulletStyle.del(self)
    BulletBreak_Table:New(self.x, self.y, self._index)
    New(item.obj.faith_minor, self.x, self.y)
end
function bulletStyle:render()
    SetImageState('preimg' .. self._index, self._blend, 255 * self.timer / self.fogtime, 255, 255, 255)
    Render('preimg' .. self._index, self.x, self.y, bullet.GetRenderRotation(self), ((self.fogtime - self.timer) / self.fogtime * 3 + 1) * self.imgclass.size)
end

local path = "THlib\\bullet\\img\\"
LoadTexture("bullet2", path .. "bullet2.png", true)
LoadTexture("bullet3", path .. "bullet3.png", true)
LoadTexture("bullet4", path .. "bullet4.png", true)
LoadTexture("bullet5", path .. "bullet5.png", true)

-- 旧版图集的坐标和原生像素尺寸按 v3.10 注册；扩展弹型继续使用原有高清图集。
-- 部分旧版弹型只有八色，同一色的深浅编号共用原图，避免把后半色号切到空白区域。
local classic_path = path .. "v3_10\\"
for _, name in ipairs({ "bullet1", "bullet2", "bullet3", "bullet4", "bullet5", "bullet6",
        "bullet_ball_huge", "bullet_music", "bullet_water_drop" }) do
    LoadTexture("v310_" .. name, classic_path .. name .. ".png", true)
end
local function LoadImageGroup16(prefix, tex, x, y, w, h, cols, rows, a, b)
    for i = 0, 15 do
        local index = int(i * cols * rows / 16)
        LoadImage(prefix .. (i + 1), tex, x + w * (index % cols), y + h * int(index / cols),
                w, h, a, b)
    end
end

do
    local other_class = {}
    function other_class.render(blend)
        return function(self)
            SetImageState('fade_' .. self.img, blend, 255 * self.timer / 11, 255, 255, 255)
            Render('fade_' .. self.img, self.x, self.y, self.rot, (11 - self.timer) / 11 + 1)
        end
    end
    function other_class.del(blend)
        return function(self)
            New(bubble2, 'fade_' .. self.img, self.x, self.y, self.dx, self.dy, 11, 1, 0, Color(0xFFFFFFFF), Color(0x00FFFFFF), self.layer, blend)
        end
    end
    function other_class.kill(blend)
        return function(self)
            New(bubble2, 'fade_' .. self.img, self.x, self.y, self.dx, self.dy, 11, 1, 0, Color(0xFFFFFFFF), Color(0x00FFFFFF), self.layer, blend)
            BulletBreak_Table:New(self.x, self.y, self._index)
            New(item.obj.faith_minor, self.x, self.y)
        end
    end
    local function init(img, colorful, blend)
        return function(self, index)
            self.img = img .. (colorful and int(index) or math.ceil(index / 2))
            self._blend = blend or self._blend
        end
    end

    local function DeFineBulletStyle(size, is_ani, DIY_init, used_img, colorful, blend, set_other)
        local u = Class(bulletStyle)
        u.size = size
        u.init = DIY_init or init(used_img, colorful, blend)
        if is_ani then
            u.RenderFunc = function(img, x, y, rot, hscale, vscale, _, ani)
                RenderAnimation(img, ani, x, y, rot, hscale, vscale)
            end
            u.SetColorFunc = SetAnimationState
        else
            u.RenderFunc = Render
            u.SetColorFunc = SetImageState
        end
        if set_other then
            u.render = other_class.render(blend)
            u.del = other_class.del(blend)
            u.kill = other_class.kill(blend)
        end
        return u
    end
    sakura = DeFineBulletStyle(0.4, false, function(self)
        self.img = 'cherry_bullet'
        self.a = 2
        self.b = 2
        self.hscale = 0.6
        self.vscale = 0.6
        self._blend = "mul+add"
    end)
    flower2 = DeFineBulletStyle(1.6, false, function(self)
        self.img = 'cherry_bullet2'
        self.a = 2
        self.b = 2
        self.hscale = 0.6
        self.vscale = 0.6
        self._blend = "mul+add"
    end)

    local FormerImg = EnumRes2("img")
    LoadImageGroup16('preimg', 'v310_bullet1', 80, 0, 32, 32, 1, 8)
    LoadImageGroup('arrow_big', 'v310_bullet1', 0, 0, 16, 16, 1, 16, 2.5, 2.5)
    LoadImageGroup('arrow_big_b', 'bullet2', 192, 0, 32, 32, 1, 16, 2.5, 2.5)
    LoadImageGroup('arrow_big_c', 'bullet3', 0, 0, 50, 36, 1, 16, 2.5, 2.5)
    for i = 1, 16 do
        SetImageCenter('arrow_big_c' .. i, 20, 18)
    end
    arrow_big = DeFineBulletStyle(0.6, false, nil, "arrow_big", true)
    arrow_big_b = DeFineBulletStyle(0.61, false, nil, "arrow_big_b", true)
    arrow_big_c = DeFineBulletStyle(0.59, false, nil, "arrow_big_c", true)

    LoadImageGroup16('arrow_mid', 'v310_bullet4', 96, 0, 32, 32, 1, 8, 2.5, 2.5)
    for i = 1, 16 do
        SetImageCenter('arrow_mid' .. i, 24, 16)
    end
    arrow_mid = DeFineBulletStyle(0.61, false, nil, "arrow_mid", true)

    LoadImageGroup('arrow_small', 'v310_bullet3', 80, 0, 16, 16, 1, 16, 2.5, 2.5)
    LoadImageGroup('arrow_small_b', 'bullet3', 133, 0, 56, 36, 1, 16, 2.5, 2.5)
    for i = 1, 16 do
        SetImageCenter('arrow_small_b' .. i, 32, 18)
    end
    arrow_small = DeFineBulletStyle(0.407, false, nil, "arrow_small", true)
    arrow_small_b = DeFineBulletStyle(0.406, false, nil, "arrow_small_b", true)

    for i = 1, 16 do
        -- 保留动画资源类型，灰色拖影仍走 RenderAnimation；旧版铳弹本身只有一帧。
        LoadAnimation("gun_bullet" .. i, "v310_bullet1", 24, (i - 1) * 16, 16, 16, 1, 1, 4, 2.5, 2.5)
        SetAnimationScale("gun_bullet" .. i, 1)
    end
    gun_bullet = DeFineBulletStyle(0.4, true, nil, "gun_bullet", true)

    LoadImageGroup('butterfly', 'v310_bullet1', 112, 0, 32, 32, 1, 8, 4, 4)
    butterfly = DeFineBulletStyle(0.7, false, nil, "butterfly")

    LoadImageGroup('square', 'v310_bullet1', 152, 0, 16, 16, 1, 16, 3, 3)
    square = DeFineBulletStyle(0.8, false, nil, "square", true)

    LoadImageGroup('mildew', 'v310_bullet1', 208, 0, 16, 16, 1, 16, 2, 2)
    mildew = DeFineBulletStyle(0.401, false, nil, "mildew", true)

    LoadImageGroup16('ellipse', 'v310_bullet1', 224, 0, 32, 32, 1, 8, 4.5, 4.5)
    ellipse = DeFineBulletStyle(0.701, false, nil, "ellipse", true)

    LoadImageGroup('star_small', 'v310_bullet2', 96, 0, 16, 16, 1, 16, 3, 3)
    star_small = DeFineBulletStyle(0.5, false, nil, "star_small", true)
    LoadImageGroup16('star_big', 'v310_bullet2', 224, 0, 32, 32, 1, 8, 5.5, 5.5)
    for i = 1, 16 do SetImageCenter('star_big' .. i, 15.5, 16) end
    star_big = DeFineBulletStyle(0.998, false, nil, "star_big", true)

    LoadImageGroup('ball_small', 'v310_bullet2', 176, 0, 16, 16, 1, 16, 2, 2)
    ball_small = DeFineBulletStyle(0.402, false, nil, "ball_small", true)

    LoadImageGroup('ball_mid', 'v310_bullet1', 184, 0, 16, 16, 1, 16, 4, 4)
    LoadImageGroup('ball_mid_c', 'v310_bullet4', 232, 0, 16, 16, 1, 16, 4, 4)
    ball_mid = DeFineBulletStyle(0.75, false, nil, "ball_mid", true)
    ball_mid_c = DeFineBulletStyle(0.752, false, nil, "ball_mid_c", true)

    LoadImageGroup16('ball_big', 'v310_bullet2', 192, 0, 32, 32, 1, 8, 8, 8)
    for i = 1, 16 do SetImageCenter('ball_big' .. i, 16, 16.5) end
    ball_big = DeFineBulletStyle(1, false, nil, "ball_big", true)

    LoadImageGroup16('ball_huge', 'v310_bullet_ball_huge', 0, 0, 64, 64, 4, 2, 13.5, 13.5)
    for i = 1, 16 do
        CopyImage("fade_ball_huge" .. i, "ball_huge" .. i)
    end
    ball_huge = DeFineBulletStyle(2, false, nil, "ball_huge", true, "mul+add", true)

    LoadImageGroup16('ball_light', 'v310_bullet5', 0, 0, 64, 64, 4, 2, 11.5, 11.5)
    for i = 1, 16 do
        CopyImage("fade_ball_light" .. i, "ball_light" .. i)
    end
    ball_light = DeFineBulletStyle(2, false, nil, "ball_light", true, "mul+add", true)

    LoadImageGroup('grain_a', 'v310_bullet2', 160, 0, 16, 16, 1, 16, 2.5, 2.5)
    LoadImageGroup('grain_b', 'v310_bullet2', 128, 0, 16, 16, 1, 16, 2.5, 2.5)
    LoadImageGroup('grain_c', 'v310_bullet3', 48, 0, 16, 16, 1, 16, 2.5, 2.5)
    LoadImageGroup('grain_d', 'bullet2', 64, 0, 32, 32, 1, 16, 2.5, 2.5)
    grain_a = DeFineBulletStyle(0.403, false, nil, "grain_a", true)
    grain_b = DeFineBulletStyle(0.404, false, nil, "grain_b", true)
    grain_c = DeFineBulletStyle(0.405, false, nil, "grain_c", true)
    grain_d = DeFineBulletStyle(0.406, false, nil, "grain_d", true)

    LoadImageGroup16('knife', 'v310_bullet3', 0, 0, 32, 32, 1, 8, 4, 4)
    LoadImageGroup16('knife_b', 'v310_bullet4', 192, 0, 32, 32, 1, 8, 3.5, 3.5)
    knife = DeFineBulletStyle(0.754, false, nil, "knife", true)
    knife_b = DeFineBulletStyle(0.755, false, nil, "knife_b", true)

    for i = 1, 8 do
        LoadAnimation("music" .. i, "v310_bullet_music", (i - 1) * 60, 0,
                60, 32, 1, 3, 8, 4, 4)
        SetAnimationScale("music" .. i, 1)
    end
    music = DeFineBulletStyle(0.8, true, nil, "music")

    for i = 1, 8 do
        LoadAnimation("water_drop" .. (-1 + i * 2), "v310_bullet_water_drop", (i - 1) * 48, 0,
                48, 32, 1, 4, 4, 4, 4)
        SetAnimationScale("water_drop" .. (-1 + i * 2), 1)
        LoadAnimation("water_drop" .. (i * 2), "v310_bullet_water_drop", (i - 1) * 48, 0,
                48, 32, 1, 4, 4, 4, 4)
        SetAnimationScale("water_drop" .. (i * 2), 1)
    end
    water_drop = DeFineBulletStyle(0.702, true, nil, "water_drop", true, "mul+add")

    LoadImageGroup('diamond', 'bullet5', 1056, 0, 45, 30, 16, 1, 2.5, 2.5)
    diamond = DeFineBulletStyle(0.406, false, nil, "diamond", true)

    LoadImageGroup16('silence', 'v310_bullet6', 192, 0, 32, 32, 1, 8, 4.5, 4.5)
    silence = DeFineBulletStyle(0.8, false, nil, "silence", true)

    LoadImageGroup16('heart', 'v310_bullet4', 128, 0, 32, 32, 1, 8, 9, 9)
    heart = DeFineBulletStyle(1, false, nil, "heart", true)

    LoadImageGroup16('money', 'v310_bullet4', 168, 0, 16, 16, 1, 8, 4, 4)
    LoadImage("money_big11", "bullet4", 7, 679, 86, 86, 8, 8)
    LoadImage("money_big15", "bullet4", 7 + 100, 679, 86, 86, 8, 8)
    LoadImage("money_big13", "bullet4", 7 + 200, 679, 86, 86, 8, 8)
    LoadImage("money_big12", "bullet4", 7, 679 + 100, 86, 86, 8, 8)
    LoadImage("money_big16", "bullet4", 7 + 100, 679 + 100, 86, 86, 8, 8)
    LoadImage("money_big14", "bullet4", 7 + 200, 679 + 100, 86, 86, 8, 8)

    money = DeFineBulletStyle(0.753, false, nil, "money", true)
    ---注意有些颜色是不存在的
    money_big = DeFineBulletStyle(0.743, false, nil, "money_big", true)

    local NowImg = EnumRes2("img")
    for _, img in ipairs(NowImg) do
        SetImageScale(img, 0.5)
    end
    for i = 1, 8 do
        SetImageScale("butterfly" .. i, 1)
    end
    for _, img in ipairs(FormerImg) do
        SetImageScale(img, 1)
    end
    -- 旧版资源已经是游戏内使用的像素尺寸，不能再次套用高清图集的 0.5 倍缩放。
    for _, prefix in ipairs({ 'preimg', 'arrow_big', 'arrow_mid', 'arrow_small', 'square', 'mildew',
            'ellipse', 'star_small', 'star_big', 'ball_small', 'ball_mid', 'ball_mid_c', 'ball_big',
            'ball_huge', 'fade_ball_huge', 'ball_light', 'fade_ball_light', 'grain_a', 'grain_b',
            'grain_c', 'knife', 'knife_b', 'silence', 'heart', 'money' }) do
        for i = 1, 16 do SetImageScale(prefix .. i, 1) end
    end
end
---bullet_style
--------------------------------------------------------------
COLOR = {
    DEEP_RED = 1,
    RED = 2,
    DEEP_PURPLE = 3,
    PURPLE = 4,
    DEEP_BLUE = 5,
    BLUE = 6,
    ROYAL_BLUE = 7,
    CYAN = 8,
    DEEP_GREEN = 9,
    GREEN = 10,
    CHARTREUSE = 11,
    YELLOW = 12,
    GOLDEN_YELLOW = 13,
    ORANGE = 14,
    DEEP_GRAY = 15,
    GRAY = 16
}
