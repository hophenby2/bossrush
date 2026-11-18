---=====================================
--- Xiliusha
--- 游戏内UI，主要UI
---=====================================

---@type ui.game
local M = ui.game
---@type interpolation
local inter = require("etc.interpolation")

local random = lstg.Rand()

----------------------------------------
--region 系统信息板

---@class ui.PowerRankInfo : luaclass
local powerrank_info = luaclass()
function powerrank_info:ctor()
    self.timer = 0

    self.broken_timer = { 1, 1, 1, 1, 1 }
    self.rankup_timer = { 1, 1, 1, 1, 1 }
    self.last_system_rank = 0
    self.last_system_chip = 0
    self.last_system_value = 0

    -- 系统数值
    self.last_chip_count = { 0, 0, 0, 0, 0 }
    self.chip_count = { 0, 0, 0, 0, 0 }
    self.hit_count = 0
    self.last_is_hyper = false
    self.is_hyper = false
    self.is_hyper_t = 0
    -- 碎片槽位置
    self.coffset = {
        { 0,  0, 0,  0, 56 }, -- x
        { 5, -5, 5, -5,  0 }, -- y
    }
    for i = 1, 4 do
        self.coffset[1][i] = -64 + (i - 1) * 29
    end
    -- hyper碎片裂开效果的旋转角
    self.crotate = { 0, -60, -120, -180, -240, -300 }
    -- hyper碎片裂开效果的索引
    self.ceffidx = { 1, 1, 1, 1, 1, 1 }
end
function powerrank_info:updateData()
    self.last_system_rank = self.system_rank
    self.last_system_chip = self.system_chip
    self.last_system_value = self.system_value
    self.system_rank = system.PowerRank.getRank()
    self.system_rank_max = system.PowerRank.getMaxRank()
    self.system_chip = system.PowerRank.getChip()
    self.system_value = system.PowerRank.getValue()
    self.system_value_max = system.PowerRank.getMaxValue()
    self.system_hyper = system.PowerRank.getHyperTime()
    self.system_hyper_max = system.PowerRank.getHyperMaxTime()
    self.system_hyper_chip_left = system.PowerRank.getHyperChipLeft()
    self.system_hyper_max_chip_left = system.PowerRank.getMaxHyperChipLeft()

    self.last_is_hyper = self.is_hyper
    self.is_hyper = system.PowerRank.isInHyper()

    -- 储存
    for i = 1, 5 do
        self.last_chip_count[i] = self.chip_count[i]
    end
    -- 对于满足rank的置为6碎片
    for i = 1, self.system_rank do
        self.chip_count[i] = 6
    end
    -- 对于还在攒碎片的，填充为对应的碎片值
    if self.system_rank < 4 then
        self.chip_count[self.system_rank + 1] = self.system_chip
    end
    -- 剩下的清零
    for i = (self.system_rank + 2), 4 do
        self.chip_count[i] = 0
    end

    -- hyper碎片和破碎数量
    if self.is_hyper then
        self.chip_count[5] = self.system_hyper_chip_left
        self.hit_count = system.PowerRank.getHitedCount()
    else
        self.chip_count[5] = 0
        self.hit_count = 0
    end
end
function powerrank_info:update()
    -- 更新
    self:updateData()

    for i = 1, 4 do
        -- 有碎片破了
        --if self.chip_count[i] < 6 and self.last_chip_count[i] == 6 then
        --    self.broken_timer[i] = 0
        --    -- 一般来说一级的碎片破了的时候下一级的也清空了
        --    if i < 4 then
        --        if self.chip_count[i + 1] < self.last_chip_count[i + 1] then
        --            self.broken_timer[i + 1] = 0
        --        end
        --    end
        --end
        if self.chip_count[i] < self.last_chip_count[i] then
            self.broken_timer[i] = 0
        end
        -- 有碎片满了
        if self.last_chip_count[i] < 6 and self.chip_count[i] == 6 then
            self.rankup_timer[i] = 0
        end
    end
    if self.last_is_hyper and not self.is_hyper then
        -- hyper结束了
        self.broken_timer[5] = 0
    end
    -- 更新破碎动画计时器
    for i = 1, 5 do
        self.broken_timer[i] = inter.balance(self.broken_timer[i], 0, 1, 1 / 56, true)
    end
    -- 更新满碎片动画计时器
    for i = 1, 5 do
        self.rankup_timer[i] = inter.balance(self.rankup_timer[i], 0, 1, 1 / 20, true)
    end

    -- Hyper碎片槽装饰物
    self.is_hyper_t = inter.balance(self.is_hyper_t, 0, 1, 0.1, self.is_hyper)
    -- 随机刷新一下破碎特效索引
    if not self.last_is_hyper and self.is_hyper then
        for i = 1, 6 do
            self.ceffidx[i] = random:Int(1, 4)
        end
    end

    -- 更新计时器
    self.timer = self.timer + 1
end
function powerrank_info:draw(x, y)
    local offset = self.coffset
    local cx, cy, cc = 0, 0, 0

    -- 绘制碎片槽和碎片
    for i = 1, 4 do
        cx, cy, cc = x + offset[1][i], y + offset[2][i], self.chip_count[i]
        -- 碎片槽
        lstg.Render("ui.systemchip.bg", cx, cy, 0, 0.25)
        -- 满碎片
        if cc >= 6 and self.rankup_timer[i] < 0.9999 then
            lstg.Render("ui.systemchip.top", cx, cy, 0,
                    0.2 + 0.1 * lstg.sin(self.rankup_timer[i] * 180))
        end
        -- 碎片
        if cc >= 1 and cc <= 6 then
            lstg.Render("ui.systemchip.v" .. tostring(cc), cx, cy, 0, 0.25)
        end
        -- 火焰特效
        lstg.Render(string.format("ui.systemchip.effect.fire.%d",
                inter.integer_loop(math.floor(self.timer / 6 - i), 1,  6)),
                cx, cy, 0, 0.8 * self.is_hyper_t)
        -- 破碎动画
        lstg.Render(string.format("ui.systemchip.effect.broken.%d",
                math.floor(self.broken_timer[i] * 13 + 1)),
                cx, cy, 0, 0.25)
    end

    cx, cy, cc = x + offset[1][5], y + offset[2][5], self.chip_count[5]
    -- hyper碎片槽
    lstg.Render("ui.hyperchip.bg", cx, cy, 0, 0.25)
    -- hyper碎片
    if cc >= 1 and cc <= 6 then
        lstg.Render("ui.hyperchip.v" .. tostring(cc), cx, cy, 0, 0.25)
    end
    -- 裂开效果
    for i = 1, math.min(self.hit_count, cc) do
        lstg.Render("ui.hyperchip.ef" .. tostring(self.ceffidx[i]), cx, cy, self.crotate[i], 0.25)
    end
    -- 装饰物
    lstg.Render("ui.hyperchip.chip", cx, cy, 0, inter.square_convex(0, 0.25, self.is_hyper_t))
    -- 破碎动画
    lstg.Render(string.format("ui.systemchip.effect.broken.%d",
            math.floor(self.broken_timer[5] * 13 + 1)), cx, cy, 0, 0.28)
end

--endregion
----------------------------------------
--region UI主体

local timer = 0

local high_score = 0
local cur_score = 0

local life_left = 0
local bomb_left = 0
local life_chip_bar = 0
local bomb_chip_bar = 0

local power_rank = 0

local last_spell = 0

local _group_index = {
    ["Easy"] = 1,
    ["Normal"] = 2,
    ["Hard"] = 3,
    ["Lunatic"] = 4,
    ["Ultra"] = 5,
    ["Extra"] = 6,
    ["Practice Easy"] = 1,
    ["Practice Normal"] = 2,
    ["Practice Hard"] = 3,
    ["Practice Lunatic"] = 4,
    ["Practice Ultra"] = 5,
    ["Practice Extra"] = 6,
    ["Boss Easy"] = 1,
    ["Boss Normal"] = 2,
    ["Boss Hard"] = 3,
    ["Boss Lunatic"] = 4,
    ["Boss Ultra"] = 5,
    ["Boss Extra"] = 6,
}

local _powerrank_info = powerrank_info.create()

--- 切换为固定的数字显示
local __test_mode__ = false
--- 总数是靠右对齐
local __right_total__ = true

local C_DGRAY = lstg.Color(160, 128, 128, 128)
local C_WHITE = lstg.Color(255, 255, 255, 255)
local C_ALPHA = lstg.Color(255, 255, 255, 255)
local C_HGRAY = lstg.Color(255, 180, 180, 180)
local C_YELLO = lstg.Color(255, 255, 255, 128)

--- 根据分数值计算缩放（防止太大显示不下）
local function make_score_font_scale(score)
    if score >= 100000000000.0 then
        -- 100,0000,0000 ~ 1000,0000,0000
        return 0.22
    elseif score >= 10000000000.0 then
        --  10,0000,0000 ~  100,0000,0000
        return 0.234
    else
        --             0 ~   10,0000,0000
        return 0.25
    end
end
--- 显示分数栏，最高分、当前分
local function draw_infobar_score(dx, dy)
    lstg.Render("ui.game.system.value1", dx - 74, dy, 0, 0.25)
    lstg.Render("ui.game.system.value2", dx - 74, dy - 20, 0, 0.25)

    local score = system.getScore()
    local hiscore_ = math.max(system.record.getHighScore(), score)

    ui.drawSpriteText(ui.game.font1, string.format_number(hiscore_),
            dx + 74, dy + 4, 0, make_score_font_scale(hiscore_), 0.25, "right")
    ui.drawSpriteText(ui.game.font1, string.format_number(score),
            dx + 74, dy + 4 - 20, 0, make_score_font_scale(score), 0.25, "right")
end

--- 绘制残机、符卡槽（这些函数不能通用，因为改了缩放）
local function draw_infobar_quantity(idx, dx, dy, img0, img1, sep, num)
    lstg.Render("ui.game.system.value" .. idx, dx - 74, dy, 0, 0.25)
    for i = 8, 1, -1 do
        lstg.Render(img0, dx - 32 + (i - 1) * sep, dy + 4, 0, 0.234, 0.25)
        if i <= num then
            lstg.Render(img1, dx - 32 + (i - 1) * sep, dy + 4, 0, 0.234, 0.25)
        end
    end
end
local function draw_infobar_life(dx, dy)
    draw_infobar_quantity(
            3,
            dx, dy,
            "ui.game.player.life0", "ui.game.player.life1",
            14,
            system.getLife())

    local cur_ = "0"
    if lstg.var.dyeitem then
        cur_ = string.format_number(lstg.var.dyeitem.blue)
    end
    local target_ = "9,999"
    if system.getNextLifeBonusPointItemN() > 0 then
        target_ = string.format_number(system.getNextLifeBonusPointItemN())
    end
    local x_, y_ = ui.drawSpriteText(ui.game.font1, string.format("%s/%s", cur_, target_),
        dx + 74, dy - 7, 0, 0.14, 0.14, "right")
    lstg.Render("item_point_ui", x_ - 6, y_, 0, 0.16)
end
local function draw_infobar_quantity2(dx, dy, img0, img1, himg0, himg1, sep1, sep2, num, k)
    local _tex, _htex = "", ""
    local _x1, _y1 = 0, 0
    local _x2, _y2 = 0, 0
    local _s1, _s2 = 0.25, 0.125
    local _k = k
    C_ALPHA.a = 255 * k
    lstg.SetImageState(himg0, "", C_ALPHA)
    lstg.SetImageState(himg1, "", C_ALPHA)
    for i = 8, 1, -1 do
        if i <= num then
            _tex = img1
            _htex = himg1
        else
            _tex = img0
            _htex = himg0
        end
        _x1, _y1 = dx - 32 + (i - 1) * sep1, dy + 4
        _x2, _y2 = dx + 22 + (i - 1) * sep2, dy - 8
        if k < 0.9999 then
            lstg.Render(_tex, inter.sin_smooth(_x1, _x2, _k), inter.sin_smooth(_y1, _y2, _k), 0, inter.sin_smooth(_s1, _s2, _k))
        end
        if k > 0.0001 then
            lstg.Render(_htex, inter.sin_smooth(_x1, _x2, _k), inter.sin_smooth(_y1, _y2, _k), 0, inter.sin_smooth(_s1, _s2, _k))
        end
    end
    lstg.SetImageState(himg0, "", C_WHITE)
    lstg.SetImageState(himg1, "", C_WHITE)
end
local _bomb_hyper_lerp = 0
local function draw_infobar_bomb(dx, dy)
    local __hstate = system.PowerRank.canHyper() or system.PowerRank.isInHyper()
    if not __hstate then
        lstg.Render("ui.game.system.value4", dx - 74, dy, 0, 0.25)
    end
    _bomb_hyper_lerp = inter.balance(_bomb_hyper_lerp, 0, 1, 1 / 15, __hstate)
    draw_infobar_quantity2(
            dx, dy,
            "ui.game.player.bomb0", "ui.game.player.bomb1",
            "ui.game.player.hbomb0", "ui.game.player.hbomb1",
            14, 7,
            system.getBomb(),
            _bomb_hyper_lerp)
end

--- Hyper的粒子特效
local _hyper_bar_par_pool = {}
local function _update_hyper_bar_par(fire)
    -- remove old
    for i = #_hyper_bar_par_pool, 1, -1 do
        if _hyper_bar_par_pool[i].t >= 60 then
            table.remove(_hyper_bar_par_pool, i)
        end
    end
    -- update
    for _, v in ipairs(_hyper_bar_par_pool) do
        v.t = v.t + 1
    end
    -- add new
    if fire then
        if timer % 2 == 0 then
            for _ = 1, 1 do
                local _ins = {
                    x = random:Float(-70, 70),
                    y = random:Float(-8, 4),
                    h = random:Float(8, 32),
                    t = 0,
                }
                table.insert(_hyper_bar_par_pool, _ins)
            end
        end
    end
end
local function _draw_hyper_bar_par(dx, dy)
    for _, v in ipairs(_hyper_bar_par_pool) do
        C_ALPHA.a = 255 * inter.trapezium(v.t / 60, 0, 0.2, 0.8, 1)
        lstg.SetImageState("ui.game.system.hyperbar.par", "mul+add", C_ALPHA)
        lstg.Render("ui.game.system.hyperbar.par",
                dx + v.x,
                dy + v.y + v.h * inter.sin_concave(0, 1, v.t / 60),
                0, 0.25)
    end
end

--- 绘制hyper条
local function draw_hyperbar(dx, dy)
    local __hstate = system.PowerRank.canHyper() or system.PowerRank.isInHyper()
    local __s = 0.24
    local __k = 0
    local __v = 0
    if system.PowerRank.isInHyper() then
        -- 120帧充能（无敌时间），剩下的匀速流逝
        local __dt = system.PowerRank.getHyperMaxTime() - system.PowerRank.getHyperTime()
        if __dt <= 120 then
            __k = inter.sin_convex(0, 1, __dt / 120)
            __v = math.floor(inter.sin_convex(0, system.PowerRank.getHyperMaxTime() - 120, __dt / 120))
        else
            __k = math.clamp(system.PowerRank.getHyperTime() / (system.PowerRank.getHyperMaxTime() - 120), 0, 1)
            __v = system.PowerRank.getHyperTime()
        end
    end
    -- hyper条
    if __hstate then
        -- hyper时间条
        ui.drawProgressBar(ui.game.hyper_bar,
                dx, dy,
                0,
                __s * (606 / 642), __s * (606 / 642), -- 魔法数值
                "",
                C_HGRAY,
                "left",
                __k)
        -- 火焰效果
        ui.drawProgressBar(
                ui.game.hyper_bar_effects[inter.integer_loop(math.floor(timer / 4), 1, 19)],
                dx, dy,
                0,
                __s, __s,
                "mul+add",
                C_WHITE,
                "left",
                __k)
    end
    -- 粒子特效
    _draw_hyper_bar_par(dx, dy)
    -- hyper状态
    local __sk = 0.25 -- + 0.01 * lstg.sin(timer * 4)
    if __hstate then
        if not system.PowerRank.isInHyper() then
            lstg.SetImageState("ui.game.system.hyperbar.ready", "", C_WHITE)
            lstg.Render("ui.game.system.hyperbar.ready", dx, dy, 0, __sk)
        else
            lstg.Render("ui.game.system.hyperbar.enable", dx, dy, 0, __sk)
        end
    end
    -- hyper数值
    if __hstate then
        if system.PowerRank.isInHyper() then
            local _text1 = string.format("%.0f%%", math.floor(__k * 100.0))
            local _text2 = string.format_number(__v)
            if __test_mode__ then
                _text1 = "100%"
                _text2 = "9,999"
            end
            ui.setSpriteTextColor(ui.game.font1, _text1 .. _text2, "", C_YELLO)
            ui.drawSpriteText(ui.game.font1, _text1,
                    dx - 54, dy - 11, 0, 0.14, 0.14, "right")
            ui.drawSpriteText(ui.game.font1, _text2,
                    dx - 30, dy - 11, 0, 0.14, 0.14, "right")
            ui.setSpriteTextColor(ui.game.font1, _text1 .. _text2, "", C_WHITE)
        else
            --local _text = string.format("%d", system.getBomb())
            --if __test_mode__ then
            --    _text = "8"
            --end
            --ui.setSpriteTextColor(ui.game.font1, _text, "", C_GREEN)
            --ui.drawSpriteText(ui.game.font1, _text,
            --        dx - 54, dy - 11, 0, 0.14, 0.14, "right")
            --ui.setSpriteTextColor(ui.game.font1, _text, "", C_WHITE)
        end
    end
end

--- 绘制火力等级
local _last_power_rank = 0
local function draw_infobar_powerrank(dx, dy)
    lstg.Render("ui.game.system.value7", dx - 74, dy, 0, 0.25)

    -- 槽值条
    local __k = system.PowerRank.getValue() / system.PowerRank.getMaxValue()
    local __v = system.PowerRank.getValue()
    ui.drawProgressBarS(ui.game.power_chip_bar,
            dx - 18, dy - 5,
            0, 0.26, 1, "left",
            __k)
    -- 槽值数值
    local _text1, _text2 = string.format("%.0f%%", __k * 100.0), string.format_number(__v)
    if __test_mode__ then
        _text1 = "100%"
        _text2 = "9,999"
    end
    ui.drawSpriteText(ui.game.font1, _text1,
            dx - 54, dy - 10, 0, 0.14, 0.14, "right")
    ui.drawSpriteText(ui.game.font1, _text2,
            dx - 30, dy - 10, 0, 0.14, 0.14, "right")

    -- 火力等级
    local X, Y = dx + 53, dy
    -- 火力等级背景
    lstg.Render("ui.game.system.powerrank.value.bg", X, Y, 0, 0.25)
    -- 火力等级托盘上的动画
    local img = "ui.game.system.powerrank.value.ef" .. inter.integer_loop(math.floor(timer / 6), 1, 10)
    lstg.Render(img, X, Y, 0, 0.25)
    -- 各个火力等级
    _last_power_rank = inter.pow(_last_power_rank, system.PowerRank.getRank(), 0.9)
    local R, A, idx, rimg = 32, 150, 0, ""
    for i = 0, 4 do
        rimg = "ui.game.system.powerrank.value." .. i
        idx = i - _last_power_rank
        -- 透明度，仅显示原点处，其他的则透明度淡入淡出
        C_ALPHA.a = 255 * inter.trapezium(idx, -1, 0, 0, 1)
        lstg.SetImageState(rimg, "", C_ALPHA)
        -- 从原点向左上角绘制高等级，当rank提升后整体向右下角移动
        lstg.Render(
                rimg,
                X     + idx * R * lstg.cos(A),
                Y + 4 + idx * R * lstg.sin(A),
                0, 0.22)
    end
end

--- 绘制最大得点
local function draw_infobar_hipoint(dx, dy)
    lstg.Render("ui.game.system.value5", dx - 74, dy, 0, 0.25)
    local text1 = "0,000,000"
    local text2 = "x9,999"
    if not __test_mode__ then
        text1 = string.format_number(system.getBonus() - system.getBonus()%10) --最大得点整数位取零
        text2 = "x" .. string.format("%0.2f", system.getBounsRateFromPointRate())
    end
    ui.drawSpriteText(ui.game.font1, text1,
            dx + 74, dy + 4, 0, 0.25, 0.25, "right")
    ui.drawSpriteText(ui.game.font1, text2,
            dx + 74, dy - 6, 0, 0.16, 0.16, "right")
end
--- 绘制连击数
local function draw_infobar_combo(dx, dy)
    lstg.Render("ui.game.system.value6", dx - 74, dy, 0, 0.25)
    local _text2 = "00,000"
    local text1 = "0,000/"
    local text2 = _text2
    if not __test_mode__ then
        text1 = string.format_number(system.getChain()) .. "/"
        text2 = string.format_number(system.getTotalChain())
    end
    ui.drawSpriteText(ui.game.font1, text1,
            dx + 52, dy + 4, 0, 0.25, 0.25, "right")

    local _len2, len2 = string.len(_text2), string.len(text2)
    if _len2 > len2 then
        local __text2 = string.sub(_text2, 1, _len2 - len2)
        __text2 = __text2 .. string.gsub(string.sub(_text2, _len2 - len2 + 1), "0", " ")
        ui.setSpriteTextColor(ui.game.font1, __text2, "", C_DGRAY)
        if __right_total__ then
            ui.drawSpriteText(ui.game.font1, __text2,
                    dx + 74, dy - 1, 0, 0.14, 0.14, "right")
        else
            ui.drawSpriteText(ui.game.font1, __text2,
                    dx + 50, dy - 1, 0, 0.14, 0.14, "left")
        end
        ui.setSpriteTextColor(ui.game.font1, __text2, "", C_WHITE)
    end

    if __right_total__ then
        ui.drawSpriteText(ui.game.font1, text2,
                dx + 74, dy - 1, 0, 0.14, 0.14, "right")
    else
        ui.drawSpriteText(ui.game.font1, text2,
                dx + 50, dy - 1, 0, 0.14, 0.14, "left")
    end
end

--- 绘制小统计栏，当前关，位数5位 / 总计，位数6位
local function draw_infobar_number_small_L(dx, dy, idx, v1, v2)
    lstg.Render("ui.game.system.value.small" .. idx, dx, dy, 0, 0.25)

    local _text1 = "00,000"
    local _text2 = "000,000"
    local text1 = _text1
    local text2 = _text2
    if not __test_mode__ then
        text1 = string.format_number(v1)
        text2 = string.format_number(v2)
    end

    local _len1, len1 = string.len(_text1), string.len(text1)
    if _len1 > len1 then
        --local __text1 = string.sub(_text1, 1, _len1 - len1)
        --__text1 = __text1 .. string.gsub(string.sub(_text1, _len1 - len1 + 1), "0", " ") .. "/"
        --ui.setSpriteTextColor(ui.game.font1, __text1, "", C_DGRAY)
        --ui.drawSpriteText(ui.game.font1, __text1,
        --        dx + 44, dy + 1, 0, 0.18, 0.18, "right")
        --ui.setSpriteTextColor(ui.game.font1, __text1, "", C_WHITE)
    end

    text1 = text1 .. "/"
    ui.drawSpriteText(ui.game.font1, text1,
            dx + 44, dy + 1, 0, 0.18, 0.18, "right")

    local _len2, len2 = string.len(_text2), string.len(text2)
    if _len2 > len2 then
        local __text2 = string.sub(_text2, 1, _len2 - len2)
        __text2 = __text2 .. string.gsub(string.sub(_text2, _len2 - len2 + 1), "0", " ")
        ui.setSpriteTextColor(ui.game.font1, __text2, "", C_DGRAY)
        if __right_total__ then
            ui.drawSpriteText(ui.game.font1, __text2,
                    dx + 72, dy - 1, 0, 0.14, 0.14, "right")
        else
            ui.drawSpriteText(ui.game.font1, __text2,
                    dx + 44, dy - 1, 0, 0.14, 0.14, "left")
        end
        ui.setSpriteTextColor(ui.game.font1, __text2, "", C_WHITE)
    end

    if __right_total__ then
        ui.drawSpriteText(ui.game.font1, text2,
                dx + 72, dy - 1, 0, 0.14, 0.14, "right")
    else
        ui.drawSpriteText(ui.game.font1, text2,
                dx + 44, dy - 1, 0, 0.14, 0.14, "left")
    end
end
--- 绘制小统计栏，当前关，位数4位 / 总计，位数5位
local function draw_infobar_number_small_S(dx, dy, idx, v1, v2)
    lstg.Render("ui.game.system.value.small" .. idx, dx, dy, 0, 0.25)

    local _text1 = "0,000"
    local _text2 = "0,000"
    local text1 = _text1
    local text2 = _text2
    if not __test_mode__ then
        text1 = string.format_number(v1)
        text2 = string.format_number(v2)
    end

    local _len1, len1 = string.len(_text1), string.len(text1)
    if _len1 > len1 then
        --local __text1 = string.sub(_text1, 1, _len1 - len1)
        --__text1 = __text1 .. string.gsub(string.sub(_text1, _len1 - len1 + 1), "0", " ") .. "/"
        --ui.setSpriteTextColor(ui.game.font1, __text1, "", C_DGRAY)
        --ui.drawSpriteText(ui.game.font1, __text1,
        --        dx + 38, dy + 1, 0, 0.18, 0.18, "right")
        --ui.setSpriteTextColor(ui.game.font1, __text1, "", C_WHITE)
    end

    text1 = text1 .. "/"
    ui.drawSpriteText(ui.game.font1, text1,
            dx + 42, dy + 1, 0, 0.18, 0.18, "right")

    local _len2, len2 = string.len(_text2), string.len(text2)
    if _len2 > len2 then
        local __text2 = string.sub(_text2, 1, _len2 - len2)
        __text2 = __text2 .. string.gsub(string.sub(_text2, _len2 - len2 + 1), "0", " ")
        ui.setSpriteTextColor(ui.game.font1, __text2, "", C_DGRAY)
        if __right_total__ then
            ui.drawSpriteText(ui.game.font1, __text2,
                    dx + 62, dy - 1, 0, 0.14, 0.14, "right")
        else
            ui.drawSpriteText(ui.game.font1, __text2,
                    dx + 42, dy - 1, 0, 0.14, 0.14, "left")
        end
        ui.setSpriteTextColor(ui.game.font1, __text2, "", C_WHITE)
    end

    if __right_total__ then
        ui.drawSpriteText(ui.game.font1, text2,
                dx + 62, dy - 1, 0, 0.14, 0.14, "right")
    else
        ui.drawSpriteText(ui.game.font1, text2,
                dx + 42, dy - 1, 0, 0.14, 0.14, "left")
    end
end
--- 绘制小统计栏，消弹数、擦弹数、蓝点数、火力道具数
local function draw_infobar_small4(dx, dy)

    local small, total_small = 0, 0
    local dodge, total_dodge = system.player.getGraze(), system.player.getTotalGraze()
    local point, total_point = 0, 0
    local power, total_power = 0, 0
    if lstg.tmpvar._system_items then
        small = lstg.tmpvar._system_items.small
        point = lstg.tmpvar._system_items.blue
        power = lstg.tmpvar._system_items.red
    end
    if lstg.var.dyeitem then
        total_small = lstg.var.dyeitem.small
        total_point = lstg.var.dyeitem.blue
        total_power = lstg.var.dyeitem.red
    end
    draw_infobar_number_small_L(dx - 68, dy + 8, 3, small, total_small)
    draw_infobar_number_small_L(dx - 68, dy - 8, 4, dodge, total_dodge)
    draw_infobar_number_small_S(dx + 12, dy + 8, 1, point, total_point)
    draw_infobar_number_small_S(dx + 12, dy - 8, 2, power, total_power)
end

---@class ui.game.main : lstg.GameObject
local ui_obj = lstg.Class(object)
function ui_obj:init()
    ui.game.resource_set:load()
    self.layer = LAYER_BG - 1000
    self.bound = false
    self.colli = false
end
function ui_obj:frame()
    cur_score = system.getScore()
    high_score = math.max(system.record.getHighScore(), cur_score)

    life_left = system.getLife()
    bomb_left = system.getBomb()
    life_chip_bar = system.getLifeChip() / 100
    bomb_chip_bar = system.getBombChip() / 100

    power_rank = system.PowerRank.getRank()

    if lstg.IsValid(lstg.tmpvar._last_spell_host_instance) then
        last_spell = math.min(last_spell + 1, 24)
    else
        last_spell = math.max(0, last_spell - 1)
    end

    timer = timer + 1

    _powerrank_info:update()


    _update_hyper_bar_par(system.PowerRank.canHyper() or system.PowerRank.isInHyper())
end
function ui_obj:background()
    ui.setCamera("extend")
    local ui_canvas = ui.camera

    -- 背景
    lstg.Render("ui.game.background1", ui_canvas.width - 512 * 0.25, ui_canvas.height, 0, 0.25)
    lstg.Render("ui.game.background2", ui_canvas.width, ui_canvas.height, -90, 0.25)

    -- 版面框架和LOGO
    if ui_canvas.mode == "16:9" then
        lstg.Render("ui.game.logo.large1", ui_canvas.width / 2 - 230, ui_canvas.height / 2 - 8, 0, 0.25)
        lstg.Render("ui.game.logo.large2", ui_canvas.width / 2 - 230, ui_canvas.height / 2 - 8, 0, 0.25)
        ui.drawSprite9(ui.game.frame1,
                ui_canvas.width * 0.5, ui_canvas.height * 0.5 - 6,
                288, 336,
                0.25, 1, "cc")
    elseif ui_canvas.mode == "4:3" then
        lstg.Render("ui.game.logo.small", ui_canvas.width / 2 + 80, ui_canvas.height / 2 - 124, 0, 0.2)
        ui.drawSprite9(ui.game.frame1,
                24 + (288 / 2), ui_canvas.height * 0.5 - 6,
                288, 336,
                0.25, 1, "cc")
    end

end
function ui_obj:render()
    local ui_canvas=ui.camera
    -- 偏移量

    local dx = 0
    if ui_canvas.mode == "16:9" then
        dx = ui_canvas.width
    elseif ui_canvas.mode == "4:3" then
        dx = ui_canvas.width + 4
    end

    -- 关卡组

    local image_index=difficultyIndex()
    lstg.Render("_ui_16_9_rank" .. image_index, dx - 88, ui_canvas.height - 26, 0, 0.25)

    -- 游戏模式

    if lstg.var.is_practice then
        lstg.Render("ui.game.gamemode.practice", dx - 88 - 64, ui_canvas.height - 26, 0, 0.25)
    end
    if ext.replay.IsReplay() then
        lstg.Render("ui.game.gamemode.replay", dx - 88 + 64, ui_canvas.height - 26, 0, 0.25)
    end

    -- 信息板

    draw_infobar_score(dx - 88, 304)

    draw_infobar_life(dx - 88, 260)
    draw_infobar_bomb(dx - 88, 236)
    draw_hyperbar(dx - 88, 236 + 4)

    draw_infobar_powerrank(dx - 88, 208)

    if ui_canvas.mode == "16:9" then
        _powerrank_info:draw(dx - 86, 170)
    elseif ui_canvas.mode == "4:3" then
        _powerrank_info:draw(dx - 86, 170)
    end

    draw_infobar_hipoint(dx - 88, 136)

    draw_infobar_combo(dx - 88, 112)

    draw_infobar_small4(dx - 88, 86)

    -- 测试中心点
    --lstg.SetImageState("white", "", lstg.Color(255, 255, 0, 255))
    --lstg.Render("white", dx - 88, 88, 0, 0.5)

    ui.updateCamera() -- 恢复坐标系
    SetViewMode("world") -- 恢复摄像机
end

return ui_obj

--endregion
----------------------------------------
