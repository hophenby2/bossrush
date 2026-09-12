---=====================================
---TH00 关卡背景
---  TH00_bg       大气层：云层高速向下滚动（关卡的“地面~天空”部分）
---  TH00_bg_space 宇宙：星空 + 再入余晖（冲破大气层之后）
---
---速度说明：
---  misc.RenderTexInRect 的 offy 与 world 坐标是 1:1 的，
---  所以 self.speed（单位：world 单位/帧）既是云层每帧下移的距离，
---  也是“预设子弹”每帧下移的距离，两者严格一致。
---=====================================

local SetViewMode = SetViewMode
local SetImageState = SetImageState
local RenderRect = RenderRect
local Color = Color
local background = background
local misc = misc
local lstg = lstg
local sin, cos, max, min, int = sin, cos, max, min, int
local table = table

---==========================
---大气层
---==========================
TH00_bg = Class(background)

function TH00_bg:init()
    background.init(self, false)
    local w = lstg.world
    self.speed = 1.2        -- 当前云层速度（world 单位/帧）
    self.speed_max = 1.2    -- 加速目标
    self.accel = 0          -- 每帧加速度
    self.scroll = 0         -- 主云层纹理偏移（= 累计下移距离）
    self.scroll2 = 0        -- 近景云层纹理偏移
    self.turb = 0           -- 乱流强度（横向抖动）
    self.streaks = {}       -- 速度线
    for i = 1, 48 do
        table.insert(self.streaks, {
            x = background.RanFloat(self, w.boundl, w.boundr),
            y = background.RanFloat(self, w.boundb - 160, w.boundt + 240),
            len = background.RanFloat(self, 50, 190),
            w = background.RanFloat(self, 0.6, 2.0),
            a = background.RanInt(self, 26, 110),
            k = background.RanFloat(self, 0.85, 1.25),
        })
    end
    TH00_bg.current = self
end

---设置云层目标速度，在 time 帧内平滑过渡（供关卡脚本调用）
---@param target number @world 单位/帧
---@param time number @过渡帧数
function TH00_bg.SetSpeed(target, time)
    local bg = TH00_bg.current
    if not bg or not IsValid(bg) then
        return
    end
    time = max(1, int(time or 1))
    bg.speed_max = target
    bg.accel = (target - bg.speed) / time
end

function TH00_bg:frame()
    if self.accel ~= 0 then
        self.speed = self.speed + self.accel
        if (self.accel > 0 and self.speed >= self.speed_max)
                or (self.accel < 0 and self.speed <= self.speed_max) then
            self.speed = self.speed_max
            self.accel = 0
        end
    end
    --world 的 +y 朝屏幕上方，所以“背景向下运动”= offy 逐帧减小
    self.scroll = self.scroll - self.speed
    self.scroll2 = self.scroll2 - self.speed * 1.7
    self.turb = max(0, self.turb - 0.02)
    local w = lstg.world
    local s
    for i = 1, #self.streaks do
        s = self.streaks[i]
        s.y = s.y - self.speed * s.k
        if s.y < w.boundb - 60 then
            s.y = s.y + (w.boundt - w.boundb) + 240
            s.x = background.RanFloat(self, w.boundl, w.boundr)
        end
    end
end

function TH00_bg:render()
    SetViewMode 'world'
    local w = lstg.world
    local t = self.timer
    local turb = self.turb * 7 * sin(t / 19)
    -- 高空底色
    SetImageState("white", "", 255, 12, 26, 56)
    RenderRect("white", w.l, w.r, w.b, w.t)
    -- 主云层：高速向下
    misc.RenderTexInRect("th00_0", w.l, w.r, w.b, w.t,
            turb, self.scroll, 0, 1, 1, "", Color(255, 226, 238, 255))
    -- 近景云层：1.7 倍速，压暗后叠上去，拉开层次与速度感
    misc.RenderTexInRect("th00_0", w.l, w.r, w.b, w.t,
            128 - turb, self.scroll2, 0, 1, 1, "", Color(150, 118, 148, 190))
    -- 速度线（与云层同向、同量级下坠）
    local s
    for i = 1, #self.streaks do
        s = self.streaks[i]
        SetImageState("white", "mul+add", s.a, 220, 240, 255)
        RenderRect("white", s.x - s.w * 0.5, s.x + s.w * 0.5,
                s.y - s.len * 0.5, s.y + s.len * 0.5)
    end
end

---==========================
---宇宙
---==========================
TH00_bg_space = Class(background)

---再入余晖剩余帧数（类级：BOSS 重建背景时不会重置）
TH00_bg_space.reentry_time = 0
TH00_bg_space.reentry_max = 300

function TH00_bg_space:init()
    background.init(self, false)
    local w = lstg.world
    self.speed = 0.7        -- 星空下坠速度（world 单位/帧）
    self.scroll = 0
    self.reentry = TH00_bg_space.reentry_time / TH00_bg_space.reentry_max
    self.stars = {}
    for i = 1, 170 do
        table.insert(self.stars, {
            x = background.RanFloat(self, w.boundl, w.boundr),
            y = background.RanFloat(self, w.boundb - 240, w.boundt + 240),
            size = background.RanFloat(self, 0.8, 2.8),
            a = background.RanInt(self, 60, 240),
            k = background.RanFloat(self, 0.3, 1.9),
            p = background.RanFloat(self, 0, 360),
        })
    end
end

function TH00_bg_space:frame()
    local w = lstg.world
    self.scroll = self.scroll - self.speed * 0.2
    TH00_bg_space.reentry_time = max(0, TH00_bg_space.reentry_time - 1)
    self.reentry = TH00_bg_space.reentry_time / TH00_bg_space.reentry_max
    local s
    for i = 1, #self.stars do
        s = self.stars[i]
        s.y = s.y - self.speed * s.k
        if s.y < w.boundb - 40 then
            s.y = s.y + (w.boundt - w.boundb) + 80
            s.x = background.RanFloat(self, w.boundl, w.boundr)
        end
    end
end

function TH00_bg_space:render()
    SetViewMode 'world'
    local w = lstg.world
    local t = self.timer
    -- 深空底色
    SetImageState("white", "", 255, 4, 6, 16)
    RenderRect("white", w.l, w.r, w.b, w.t)
    -- 极淡的星云（复用云层贴图做加法混合）
    misc.RenderTexInRect("th00_0", w.l, w.r, w.b, w.t,
            0, self.scroll, 0, 1, 1, "mul+add", Color(26, 40, 88, 255))
    -- 星空（多层视差 + 闪烁）
    local s, a
    for i = 1, #self.stars do
        s = self.stars[i]
        a = s.a * (0.72 + 0.28 * sin(t / 26 + s.p))
        SetImageState("white", "mul+add", a, 255, 255, 255)
        RenderRect("white", s.x - s.size * 0.5, s.x + s.size * 0.5,
                s.y - s.size * 0.5, s.y + s.size * 0.5)
    end
    -- 再入余晖：屏幕底部的大气辉光，随脱离大气层而淡出
    if self.reentry > 0 then
        local r = self.reentry
        SetImageState("white", "mul+add", 150 * r, 110, 175, 255)
        RenderRect("white", w.l, w.r, w.b - 10, w.b + 60 + 140 * r)
        SetImageState("white", "mul+add", 90 * r * r, 200, 230, 255)
        RenderRect("white", w.l, w.r, w.b - 10, w.b + 26 + 60 * r)
    end
end
