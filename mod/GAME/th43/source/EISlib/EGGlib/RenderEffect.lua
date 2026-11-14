---=====================================
---一些与渲染有关的方法以及特效
---author:S7UPID
---email:962131487@qq.com
---=====================================

--defined
local M = {}
EGGlib.RenderEffect = M
local ran = lstg.Rand() --该脚本文件独立内建一个随机数发射器，防止在effcut改变时炸rep
local spSizeAndColliChangeTask = EGGlib.ObjectEvent.spSizeAndColliChangeTask
local alphaChange = EGGlib.ObjectEvent.alphaChange
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local setSize = EGGlib.ObjectEvent.setSize
local sin = EGGlib.Math.phaseToSin
local cos = EGGlib.Math.phaseToCos

--const
local COLOR_WHITE = Color(255, 255, 255, 255)

--region AbsorbEffect And BreakEffect 蓄力特效 和 爆炸特效
--蓄力内缩圈
M.AbsorbCircle = Class(object)
function M.AbsorbCircle:init(x, y, size, r, g, b, blend, Isbreak)
    blend = blend or "mul+add"
    self.group = GROUP_GHOST
    self.layer = LAYER_PLAYER_BULLET+1
    self.img = 'circle_eff'
    self.x, self.y = x, y
    robject.set_color(self, blend,255*cos(x),r,g,b)
    task.New(self, function()
        local x, dx
        if Isbreak then
            x, dx = 0, 90/89
        else
            x, dx = -90, 90/89
        end
        for _ = 1, 90 do
            self.hscale, self.vscale = size*sin(x), size*sin(x)
            self._a = 255*cos(x)
            x = x + dx
            task.Wait(1)
        end
        Del(self)
    end)
end
function M.AbsorbCircle:frame()
    task.Do(self)
end
function M.AbsorbCircle:render()
    robject.render(self)
end

--飞入的道具
M.ItemFlyIn = Class(object)
function M.ItemFlyIn:init(img, x, y, x0, y0, size, R, G, B, blend, t)
    t = t or 60
    blend = blend or "mul+add"
    self.group = GROUP_GHOST
    self.layer = LAYER_PLAYER-1
    self.img = img or "img_void"
    self.x, self.y = x, y
    size = size*1.25
    self.hscale, self.vscale = size, 0
    self.rot = ran:Float(0, 360)
    self.bound = false
    robject.set_color(self, blend, 255, R, G, B)
    task.New(self, function()
        EGGlib.ObjectEvent.accDecMoveToPoint(self, x0, y0, 1, 1, t - 2)
    end)
    task.New(self, function()
        local x, dx = 0, 90/t
        local phase = ran:Int(0, 360)
        local dphase = 3
        local ds = size/t
        size = 0
        for _ = 1, t do
            size = size + ds
            phase = phase + dphase
            x = x + dx
            self.hscale = size
            self.vscale = size*sin(phase)
            self._a = 255*cos(x)
            task.Wait(1)
        end
        Del(self)
    end)
end
function M.ItemFlyIn:frame()
    task.Do(self)
end
function M.ItemFlyIn:render()
    robject.render(self)
end

--蓄力特效(这个特效已经包括上面两个object了）
M.AbsorbEffect = Class(object)
function M.AbsorbEffect:init(x, y, img1, img2, R, G, B, blend)
    PlaySound("ch01")
    blend = blend or "mul+add"
    local imgs = {img1 or 'bamboo_leaf_white', img2 or 'tree_leaf_white'}
    self.bound = false
    task.New(self, function()
        New(M.AbsorbCircle, x, y, 3.1, R, G, B, blend)
        local a, r
        for _ = 1, 45 do
            for _ = 1, 2 do
                a, r = ran:Float(0, 360), 600
                New(M.ItemFlyIn, imgs[ran:Int(1, 2)], x + r*cos(a), y + r*sin(a), x, y, ran:Float(1.5, 2.25), R, G, B, blend, 60)
            end
            task.Wait(1)
        end
        Del(self)
    end)
end
function M.AbsorbEffect:frame()
    task.Do(self)
end

--自机蓄力特效
M.Player_AbsorbEffect = Class(object)
local function moveWithPlayerTask(obj, player)
    task.New(obj, function()
        while IsValid(player) do
            obj.x, obj.y = obj.x + player.dx, obj.y + player.dy
            task.Wait(1)
        end
    end)
end
function M.Player_AbsorbEffect:init(x, y, img1, img2, R, G, B, blend)
    PlaySound("ch01")
    blend = blend or "mul+add"
    local imgs = {img1 or 'bamboo_leaf_white', img2 or 'tree_leaf_white'}
    self.bound = false
    self.x, self.y = 0, 0
    --PlaySound("power02", 0.5)
    task.New(self, function()
        New(M.AbsorbCircle, x, y, 3.1, R, G, B, blend)
        local a, r
        for _ = 1, 60 do
            for _ = 1, 2 do
                a, r = ran:Float(0, 360), 600
                moveWithPlayerTask(New(M.ItemFlyIn, imgs[ran:Int(1, 2)], x + r*cos(a), y + r*sin(a), x, y, ran:Float(1.5, 2.25), R, G, B, blend,  60), player)
            end
            task.Wait(1)
        end
        Del(self)
    end)
end
function M.Player_AbsorbEffect:frame()
    task.Do(self)
end

--炸裂特效（与上相反）
M.BreakEffect = Class(object)
function M.BreakEffect:init(x, y, img1, img2, R, G, B, blend)
    blend = blend or "mul+add"
    local imgs = {img1 or 'bamboo_leaf_white', img2 or 'tree_leaf_white'}
    self.bound = false
    self.x, self.y = 0, 0
    PlaySound("power02")
    task.New(self, function()
        New(M.AbsorbCircle, x, y, 3.4, 150, 150, 150, blend, true)
        New(M.AbsorbCircle, x, y, 3.5, R, G, B, blend, true)
        local a, r
        for _ = 1, 60 do
            a, r = ran:Float(0, 360), ran:Float(50, 300)
            New(M.ItemFlyIn, imgs[ran:Int(1, 2)], x, y, x + r*cos(a), y + r*sin(a), ran:Float(1.5, 2.25), R, G, B, blend, 60)
        end
        Del(self)
    end)
end
function M.BreakEffect:frame()
    task.Do(self)
end
--endregion

--region 新蓄力特效
M.AbsorbEffect2 = Class(object)
do
    --环
    local ring = Class(object)
    function ring:init(x, y)
        self.x, self.y = x, y
        self.img = "absorb_ring"
        robject.set_color(self, "", 255, 255, 255, 255)
        setSize(self, 2.5, 2.5)
        task.New(self, function()
            alphaAndSizeChange(self, -255, -2.5, 30)
            Del(self)
        end)
    end
    function ring:frame()
        task.Do(self)
    end
    function ring:render()
        M.defaultRenderImg(self)
    end

    --生成中间的光圈
    local halation = Class(object)
    function halation:init(x, y, size, r, g, b, blend)
        blend = blend or "mul+add"
        self.group = GROUP_GHOST
        self.layer = LAYER_PLAYER_BULLET+1
        self.img = 'absorb_halation'
        self.x, self.y = x, y
        robject.set_color(self, blend, 0, r, g, b)
        task.New(self, function()
            local t = 60
            local x, dx = 0, 90/t
            spSizeAndColliChangeTask(self, 1, t, 150)
            alphaChange(self, 0, 255, t)
            --放大
            t = 30
            x, dx = 0, 90/t
            for _ = 1, t do
                x = x + dx
                self.hscale, self.vscale = 1 + 4*sin(x), 1 + 4*sin(x)
                self._a = 255*cos(x)
                task.Wait(1)
            end
            Del(self)
        end)
    end
    function halation:frame()
        task.Do(self)
    end
    function halation:render()
        robject.render(self)
    end

    --生成气旋
    local function createCyclone(x, y, r, a, da, R, G, B)
        local obj = New(M.bent_laser_effection, "absorb_cyclone", x + r*cos(a), y + r*sin(a), a, 20, 30)
        robject.set_color(obj, "mul+add", 255, R, G, B)
        obj.bound = false
        local alpha = 0
        laser_bent.setAlpha(obj, alpha)
        --一开始的透明度的变化
        task.New(obj, function()
            local t = 15
            local dalpha = 1/t
            for _ = 1, t do
                alpha = alpha + dalpha
                laser_bent.setAlpha(obj, alpha)
                task.Wait(1)
            end
        end)
        task.New(obj, function()
            local t = 20
            local dr = -r/t
            for _ = 1, t do
                a = a + da
                r = r + dr
                obj.x, obj.y = x + r*cos(a), y + r*sin(a)
                task.Wait(1)
            end
            --变短消失
            t = 20
            local len = laser_bent.getLength(obj)
            alpha = laser_bent.getAlpha(obj)
            local dlen, dalpha = (2 - len)/t, -alpha/t
            for _ = 1, t do
                alpha = alpha + dalpha
                len = len + dlen
                laser_bent.setLength(obj, len)
                laser_bent.setAlpha(obj, alpha)
                task.Wait(1)
            end
            _del(obj, false)
        end)
    end

    function M.AbsorbEffect2:init(x, y, R, G, B, blend)
        blend = blend or "mul+add"
        self.x, self.y = x, y
        robject.set_color(self, blend, 255, R, G, B)
        task.New(self, function()
            --task.Wait(30)
            New(halation, self.x, self.y, 6, R, G, B, blend)
        end)
        task.New(self, function()
            local a0 = ran:Float(0, 360)
            for i = 1, 6 do
                New(ring, x, y)
                for j = 1, 8 do
                    createCyclone(self.x, self.y, 500, a0 + 45*j, 5*tranU(i), R, G, B)
                end
                a0 = a0 + 11.25
                task.Wait(10)
            end
            Del(self)
        end)
    end
    function M.AbsorbEffect2:frame()
        task.Do(self)
    end
end
--endregion

--region SpellCardBreakEffect 符卡击碎特效
--炸裂的蓄力圈
M.ScBreakCircle = Class(object)
function M.ScBreakCircle:init(x, y, size, r, g, b)
    self.bound = false
    self.x, self.y = x, y
    self.img = 'circle_eff'
    self.group = GROUP_GHOST
    self.size = size or 1
    self._a = 0
    self._r, self._g, self._b = r or 0, g or 100, b or 255
    self.hscale = 0
end
function M.ScBreakCircle:frame()
    self.hscale = self.size*sin(self.timer*2)
    self._a = 255*cos(self.timer*2)
    if self.timer > 45 then Del(self) end
end
function M.ScBreakCircle:render()
    SetImageState(self.img, "mul+add", Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, 0, self.hscale)
end

--炸裂的零散小部件
M.ScBreakItem = Class(object)
function M.ScBreakItem:init(x, y, r,a,size,R,G,B,img1,img2, blend)
    self.imgs = {img1 or self.img, img2 or self.img}
    self.img = self.imgs[ran:Int(1, 2)]
    self.x, self.y = x, y
    self.hscale, self.vscale,self.rot=0,0,ran:Float(0,360)
    self._dx, self._dy = r*cos(a)/60, r*sin(a)/60
    self.hscale,self.vscale,self.rot,self.bound = 0, 0, ran:Float(0,360), false
    self._a = 255
    self.size = size or 1
    self._blend, self._r, self._g, self._b = blend or "mul+add", R or 0, G or 100, B or 255
    self.t = ran:Int(0, 360)
end
function M.ScBreakItem:frame()
    self.x, self.y = self.x + self._dx, self.y + self._dy
    self.hscale, self.vscale = self.size*sin(self.t + self.timer*1.5), self.size*sin(self.t + self.timer*4.5)
    self._a = 255*cos(self.timer*1.5)
    if self.timer > 60 then Del(self) end
end
function M.ScBreakItem:render()
    SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

--boss符卡击破效果
function M.scBreakEffect(x, y, r, g, b, img1, img2, rate, blend)
    rate = rate or 1
    blend = blend or "mul+add"
    PlaySound('enep02')
    New(M.ScBreakCircle, x, y, 3, 255*rate, 255*rate, 255*rate)
    New(M.ScBreakCircle, x, y, 3.1, r, g, b)
    for _ = 1, 30 do
        New(M.ScBreakItem, x, y, ran:Float(50,450),ran:Float(0,360),ran:Float(1,1.25),r,g,b, img1, img2, blend)
    end
    for _ = 1, 90 do
        New(M.ScBreakItem, x, y, ran:Float(50,450),ran:Float(0,360),ran:Float(0.2,0.3),r,g,b, img1, img2, blend)
    end
end
--endregion

--region hit change color 受击变色处理
--受攻击变色处理
local c_rate = 0.25 --反映变色程度的参数
function M.hitFlashBlue(obj)
    local dmgt, maxdmgt = obj.dmgt, obj.dmgmaxt
    local cani = 0
    if dmgt and maxdmgt then
        cani = dmgt / maxdmgt
    end
    local color = COLOR_WHITE
    local alpha = obj.alpha or 1
    if obj._blend then
        color = Color(alpha * obj._a, obj._r - obj._r * c_rate * cani, obj._g - obj._g * c_rate * cani, obj._b)
    elseif obj._a then
        color = Color(alpha * obj._a, 255 - 255 * c_rate * cani, 255 - 255 * c_rate * cani, 255)
    else
        color = Color(alpha * 255, 255 - 255 * c_rate * cani, 255 - 255 * c_rate * cani, 255)
    end
    return color
end

--endregion

--region LaserRender 直线激光渲染
--给出宽度、长度、角度渲染一个激光(不会有贴图动态效果）
---@param img string 贴图名
---@param blend string 混合模式
---@param color string Color对象
---@param x number 激光源x坐标
---@param y number 激光源y坐标
---@param w0 number 头宽度
---@param w1 number 尾宽度
---@param len number 长度
---@param rot number 角度
function M.createNewLaser1(img, blend, color, x, y, w0, w1, len, rot)
    SetImageState(img, blend, color)
    w0 = w0/2 --要先/2
    local wx, wy = -w0*sin(rot), w0*cos(rot)
    local wscale = w1/w0 --w1与w0的比例
    local lx, ly = len*cos(rot), len*sin(rot)
    Render4V(img,
            x + wx, y + wy, 0.5,
            x + wx*wscale + lx, y + wy*wscale + ly, 0.5,
            x - wx*wscale + lx, y - wy*wscale + ly, 0.5,
            x - wx, y - wy, 0.5
    )
end

--给出事先算好的宽度在x、y上的增量和长度在x、y上的增量渲染一个激光（某些情况能最大利用计算结果，计算量比上面那个小
function M.createNewLaser2(img, blend, color, x, y, wx, wy, lx, ly, wscale)
    SetImageState(img, blend, color)
    Render4V(img,
            x + wx, y + wy, 0.5,
            x + wx*wscale + lx, y + wy*wscale + ly, 0.5,
            x - wx*wscale + lx, y - wy*wscale + ly, 0.5,
            x - wx, y - wy, 0.5
    )
end

--endregion

--region 用tex创建一个移动的激光纹理(要放在对象的render函数里
---@param tex string 激光纹理名
---@param timer number 时间参数，控制激光纹理移动
---@param offset number 激光总长度
---@param length number 纹理长度
---@param width number 纹理宽度
---@param blend string 混合模式
---@param color table 颜色模式
function M.CreateLaser(tex, x, y, a, timer, offset, wide, length, width, blend, color)
    length, width = length or 256, width or 16
    blend = blend or "mul+add"
    color = color or Color(255, 255, 255, 255)
    local n = int(offset / length) --循环数
    local trail_len = timer % length   --激光尾长（从使魔中发出的长度
    local endl = int(offset - n * length) --激光头长(接近offset的那一段

    wide = wide/2 --激光宽度的一半
    local w_x = wide * cos(a)
    local w_y = wide * sin(a)

    local vx1, vy1, vx2, vy2, vx3, vy3
    --渲染循环的部分（激光尾部和激光身
    for i = 1, n do
        vx1 = x + (trail_len + length * (i - 1)) * cos(a)
        vy1 = y + (trail_len + length * (i - 1)) * sin(a)
        vx2 = x + length * i * cos(a)
        vy2 = y + length * i * sin(a)
        vx3 = x + length * (i - 1) * cos(a)
        vy3 = y + length * (i - 1) * sin(a)
        lstg.RenderTexture(
                tex, blend,
                { vx1 - w_y, vy1 + w_x, 0.5, 0, 0, color },
                { vx2 - w_y, vy2 + w_x, 0.5, length - trail_len, 0, color },
                { vx2 + w_y, vy2 - w_x, 0.5, length - trail_len, width, color },
                { vx1 + w_y, vy1 - w_x, 0.5, 0, width, color })
        lstg.RenderTexture(
                tex, blend,
                { vx3 - w_y, vy3 + w_x, 0.5, length - trail_len, 0, color },
                { vx1 - w_y, vy1 + w_x, 0.5, length, 0, color },
                { vx1 + w_y, vy1 - w_x, 0.5, length, width, color },
                { vx3 + w_y, vy3 - w_x, 0.5, length - trail_len, width, color })
    end

    --以下单独渲染头部（长度到达offset的那一段
    vx2 = x + (endl + length * n) * cos(a)
    vy2 = y + (endl + length * n) * sin(a)
    vx3 = x + length * n * cos(a)
    vy3 = y + length * n * sin(a)
    if trail_len <= endl then
        vx1 = x + (trail_len + length * n) * cos(a)
        vy1 = y + (trail_len + length * n) * sin(a)
        lstg.RenderTexture(
                tex, blend,
                { vx1 - w_y, vy1 + w_x, 0.5, 0, 0, color },
                { vx2 - w_y, vy2 + w_x, 0.5, endl - trail_len, 0, color },
                { vx2 + w_y, vy2 - w_x, 0.5, endl - trail_len, width, color },
                { vx1 + w_y, vy1 - w_x, 0.5, 0, width, color })
        lstg.RenderTexture(
                tex, blend,
                { vx3 - w_y, vy3 + w_x, 0.5, length - trail_len, 0, color },
                { vx1 - w_y, vy1 + w_x, 0.5, length, 0, color },
                { vx1 + w_y, vy1 - w_x, 0.5, length, width, color },
                { vx3 + w_y, vy3 - w_x, 0.5, length - trail_len, width, color })
    else
        lstg.RenderTexture(
                tex, blend,
                { vx3 - w_y, vy3 + w_x, 0.5, length - trail_len, 0, color },
                { vx2 - w_y, vy2 + w_x, 0.5, endl + length - trail_len, 0, color },
                { vx2 + w_y, vy2 - w_x, 0.5, endl + length - trail_len, width, color },
                { vx3 + w_y, vy3 - w_x, 0.5, length - trail_len, width, color })
    end
end
--endregion

--region trail 拖影
--拖影类(需要主人对象)
local trail = Class(object)
function trail:init(master, dlayer, maxnum, frame, img, size, blend, times, _a_rate, Isdsize, size_min, Isdalpah, co0, co1)
    self.bound = false
    self.master = master
    self.alpha = (master._a or 255) * 80 / 255
    self.real_img = img or master.img --如果img参数为nil则使用主人的img
    self.img = self.real_img or self.master.img
    self.layer = master.layer + dlayer
    self.size = size or 1
    self.trail = {} --拖影表
    self.max = maxnum or 10
    self.frame = frame or 3
    self.co0 = co0 or {255, 255, 255} --留一个可以外部操作的接口co
    self.co1 = co1 or {255, 255, 255}
    self.blend = blend or "mul+alpha"
    self.times = times or 99999
    self._a_rate = _a_rate or 1
    self.Isdsize = Isdsize
    self.size_min = size_min or 0
    self.Isdalpha = Isdalpah
    self.hscale, self.vscale = 1, 1
end
function trail:frame()
    if self.frame == 1 or self.timer % self.frame == 1 then
        if IsValid(self.master) and self.timer < self.times then
            local master = self.master
            self.x, self.y = master.x, master.y
            table.insert(self.trail, 1, { master.x, master.y, master.rot, master.hscale * self.size, master.vscale * self.size }) --更新主人当前图像状态
            if #self.trail > self.max then
                table.remove(self.trail)
            end
        else
            --即便主人不存在了，拖影也会保留一段时间渐渐消失
            self.vx, self.vy = self.dx, self.dy
            if #self.trail == 0 then
                Del(self)
            else
                table.remove(self.trail)
            end
        end
        --self.img = self.real_img or (IsValid(self.master) and self.master.img or self.img) --如果img参数为nil则使用主人的img
    end
    --好像可以和上面合并，不过先搁置着，以后再来优化
    if IsValid(self.master) then
        self.alpha = (self.master._a or 255) * self._a_rate
    elseif self.x > -384 and self.x < 384 and self.y < 448 and self.y > -448 then
        self.alpha = max(0, self.alpha - 2)
    end
end
function trail:render()
    local img = self.img
    local obj
    local size = 1
    local dsize
    if self.Isdsize then
        dsize = (self.size_min - 1) / self.max
    else
        dsize = 0
    end
    local hs, vs = self.hscale, self.vscale
    local alpha, d, n = self.alpha, nil, #self.trail
    if self.Isdalpha then
        d = -self.alpha / self.max
    else
        d = 0
    end

    --颜色过渡
    local co0, co1 = self.co0, self.co1
    local c0, c1, c2 = co0[1], co0[2], co0[3]
    local dc0, dc1, dc2 = (co1[1] - c0)/n, (co1[2] - c1)/n, (co1[3] - c2)/n

    for i = 1, n do
        obj = self.trail[i]
        SetImageState(img, self.blend, Color(alpha, c0, c1, c2))
        Render(img, obj[1], obj[2], obj[3], obj[4] * size * hs, obj[5] * size * vs)
        alpha = alpha + d
        size = size + dsize
        c0, c1, c2 = c0 + dc0, c1 + dc1, c2 + dc2
    end
    SetImageState(img, "", Color(255, 255, 255, 255)) --请设置回来
end

function M.simpleTrail(master, dlayer)
    local trail = New(trail, master, dlayer, 15, 1, master.img, 1, master._blend, 9999, 0.1, false, 0, true, {255, 255, 255}, {255, 255, 255})
    master.trail = trail
    return trail
end
function M.newTrail(master, dlayer, maxnum, frame, img, size, blend, times, _a_rate, Isdsize, size_min, Isdalpah, co0, co1)
    if Isdalpah == nil then --不填也是默认会透明度递减
        Isdalpah = true
    end
    local trail = New(trail, master, dlayer, maxnum, frame, img, size, blend, times, _a_rate, Isdsize, size_min, Isdalpah, co0, co1)
    master.trail = trail
    return trail
end

--拖影类(需要主人对象)
local aniTrail = Class(object)
function aniTrail:init(master, dlayer, maxnum, frame, img, size, blend, times, _a_rate, Isdsize)
    self.layer = master.layer + dlayer
    self.bound = false
    self.master = master
    self.alpha = (master._a or 255) * 80 / 255
    self.real_img = img or master.img --如果img参数为nil则使用主人的img
    self.img = self.real_img or self.master.img
    self.size = size or 1
    self.trail = {} --拖影表
    self.max = maxnum or 10
    self.frame = frame or 3
    self.co = { 255, 255, 255 } --留一个可以外部操作的接口co
    self.blend = blend or "mul+alpha"
    self.times = times or 99999
    self._a_rate = _a_rate or 1
    self.Isdsize = Isdsize
end
function aniTrail:frame()
    if self.frame == 1 or self.timer % self.frame == 1 then
        if IsValid(self.master) and self.timer < self.times then
            local master = self.master
            self.x, self.y = master.x, master.y
            table.insert(self.trail, 1, { master.x, master.y, master.rot,
                                          master.hscale * self.size, master.vscale * self.size,
                                          master.ani
            }) --更新主人当前图像状态
            if #self.trail > self.max then
                table.remove(self.trail)
            end
        else
            --即便主人不存在了，拖影也会保留一段时间渐渐消失
            self.vx, self.vy = self.dx, self.dy
            if #self.trail == 0 then
                Del(self)
            else
                table.remove(self.trail)
            end
        end
        self.img = self.real_img or (IsValid(self.master) and self.master.img or self.img) --如果img参数为nil则使用主人的img
    end
    --好像可以和上面合并，不过先搁置着，以后再来优化
    if IsValid(self.master) then
        self.alpha = (self.master._a or 255) * self._a_rate
    elseif self.x > -384 and self.x < 384 and self.y < 448 and self.y > -448 then
        self.alpha = max(0, self.alpha - 2)
    end
end
function aniTrail:render()
    local img = self.img
    local obj
    local co = self.co
    local size = 1
    local dsize
    if self.Isdsize then
        dsize = -1 / self.max
    else
        dsize = 0
    end
    local alpha, d, n = 0, self.alpha / self.max, #self.trail
    for i = n, 1, -1 do
        obj = self.trail[i]
        SetAnimationState(img, self.blend, Color(alpha, co[1], co[2], co[3]))
        RenderAnimation(img, obj[6], obj[1], obj[2], obj[3], obj[4] * size, obj[5] * size)
        alpha = alpha + d
        size = size + dsize
    end
    SetAnimationState(img, "", Color(255, 255, 255, 255)) --请设置回来
end

function M.newAniTrail(master, dlayer, maxnum, frame, img, size, blend, times, _a_rate, Isdsize)
    local trail = New(aniTrail, master, dlayer, maxnum, frame, img, size, blend, times, _a_rate, Isdsize)
    master.trail = trail
    return trail
end

--开卡立绘用的拖影类(需要主人对象)
local trail_pic_show = Class(object)
function trail_pic_show:init(master, dlayer, maxnum, frame, img, size, times, r, g, b)
    self.layer = master.layer + dlayer
    self.bound = false
    self.master = master
    self._a = 80/255
    self.real_img = img or master.img --如果img参数为nil则使用主人的img
    self.img = self.real_img or self.master.img
    self.size = size or 1
    self.trail = {} --拖影表
    self.max = maxnum or 10
    self.frame = frame or 3
    self.blend = "mul+add"
    self._r, self._g, self._b = r, g, b
    self.times = times or 99999
end
function trail_pic_show:frame()
    for _, v in pairs(self.trail) do
        v[6] = v[6] + 0.02
        v[7] = max(v[7] - 2.25, 0)
    end
    if self.frame == 1 or self.timer % self.frame == 1 then
        if IsValid(self.master) and self.timer < self.times then
            local master = self.master
            self.x, self.y = master.x, master.y
            table.insert(self.trail, 1, { master.x, master.y, master.rot, master.hscale * self.size, master.vscale * self.size, 1, 50 }) --更新主人当前图像状态
            if #self.trail > self.max then
                table.remove(self.trail)
            end
        else
            --即便主人不存在了，拖影也会保留一段时间渐渐消失
            self.vx, self.vy = self.dx, self.dy
            if #self.trail == 0 then
                Del(self)
            else
                table.remove(self.trail)
            end
        end
        self.img = self.real_img or (IsValid(self.master) and self.master.img or self.img) --如果img参数为nil则使用主人的img
    end
    --好像可以和上面合并，不过先搁置着，以后再来优化
    if IsValid(self.master) then
        self._a = (self.master._a or 255)
    elseif self.x > -384 and self.x < 384 and self.y < 448 and self.y > -448 then
        self._a = max(0, self._a - 2)
    end
end
function trail_pic_show:render()
    local img = self.img
    local obj
    local n = #self.trail
    for i = n, 1, -1 do
        obj = self.trail[i]
        SetImageState(img, self.blend, Color(obj[7], self._r, self._g, self._b))
        Render(img, obj[1], obj[2], obj[3], obj[4] * obj[6], obj[5] * obj[6])
    end
    SetImageState(img, "", Color(255, 255, 255, 255)) --请设置回来
end
function M.createBossPicShowTrail(master, dlayer, maxnum, frame, img, size, times, r, g, b)
    New(trail_pic_show, master, dlayer, maxnum, frame, img, size, times, r, g, b)
end
--endregion

--region common Render
function M.defaultRenderImg(self, alpha_rate)
    alpha_rate = alpha_rate or 1
    SetImageState(self.img, self._blend, Color(self._a*alpha_rate, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, self.rot, self.hscale, self.vscale)
end

function M.defaultRenderAni(self, alpha_rate)
    alpha_rate = alpha_rate or 1
    SetAnimationState(self.img, self._blend, Color(self._a*alpha_rate, self._r, self._g, self._b))
    RenderAnimation(self.img, self.ani, self.x, self.y, self.rot, self.hscale, self.vscale)
end

function M.renderImg(img, x, y, rot, h, v, blend, color)
    SetImageState(img, blend, color)
    Render(img, x, y, rot, h, v)
end

function M.renderAni(img, timer, x, y, rot, h, v, blend, color)
    SetAnimationState(img, blend, color)
    RenderAnimation(img, timer, x, y, rot, h, v)
end
--endregion

--region board_ch
--场景颜色效果
LoadImageFromFile("sc_open_show_circle", "res/effect/sc_open_show_circle.png")
local alphaChange = EGGlib.ObjectEvent.alphaChange --透明度变化事件
local sizeChange = EGGlib.ObjectEvent.sizeChange
local board_ch = Class(object)
function board_ch:init(blend, r, g, b, t0, t1, t2, layer)
    self.x, self.y = 0, 0
    self.hscale, self.vscale = 0, 0
    self.img = "sc_open_show_circle"
    robject.set_color(self, blend, 0, r, g, b)
    self.group = GROUP_GHOST
    self.layer = layer or LAYER_BG + 51
    task.New(self, function()
        alphaChange(self, 0, 200, t0)
        task.Wait(t1)
        alphaChange(self, 200, 0, t2)
        Del(self)
    end)
    task.New(self, function()
        sizeChange(self, 10, t0 + t1 + t2)
    end)
end
function board_ch:frame()
    task.Do(self)
end
function board_ch:render()
    SetImageState(self.img, self._blend, Color(self._a, self._r, self._g, self._b))
    Render(self.img, self.x, self.y, 0, self.hscale, self.vscale)
end

function M.createScOpenShowCircle(blend, r, g, b, t0, t1, t2, layer)
    New(board_ch, blend, r, g, b, t0, t1, t2, layer)
end
--endregion

--region 作为特效的曲光（如拖尾）
M.bent_laser_effection = Class(laser_bent)
function M.bent_laser_effection:init(laser_bent_tex, x, y, a, len, wide)
    laser_bent.init(self, 1, x, y, len, wide, laser_bent_tex, 0)
    self.rot = a
    self.colli = false
    self.group = GROUP_GHOST
    self.layer = LAYER_PLAYER - 1
    self.isDel = false
end
function M.bent_laser_effection:frame()
    laser_bent.frame(self)
end
function M.bent_laser_effection:disappear(t)
    task.New(self, function()
        local len = laser_bent.getLength(self)
        local alpha = laser_bent.getAlpha(self)
        local dlen, dalpha = (2 - len)/t, -alpha/t
        for _ = 1, t do
            PreserveObject(self)
            alpha = alpha + dalpha
            len = len + dlen
            laser_bent.setLength(self, len)
            laser_bent.setAlpha(self, alpha)
            task.Wait(1)
        end
        self.status = 'del'
    end)
end
function M.bent_laser_effection:kill()
    if not self.isDel then
        PreserveObject(self)
        self.isDel = true
        task.clear(self)
        M.bent_laser_effection.disappear(self, 10)
    end
end
function M.bent_laser_effection:del()
    M.bent_laser_effection.kill(self)
end

--endregion