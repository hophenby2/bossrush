---=====================================
---TH00 关卡背景
---  一镜到底：同一套渲染里同时画“宇宙（TH08 的 stg6bg2）”和“大气层云层”，
---  用 self.space（0 = 大气层，1 = 宇宙）交叉淡化。
---  大气层段底色为纯黑（th00_0 只是极暗的灰罩层，不能让它把底色染蓝）。
---  中途不切场景、不换背景对象，只有一条连续的镜头；
---  self.opacity（0~255）就是大气层的不透明度，预设弹跟着它一起淡出。
---
---速度说明：
---  misc.RenderTexInRect 的 offy 与 world 坐标是 1:1 的，
---  所以 self.speed（单位：world 单位/帧）既是云层每帧下移的距离，
---  也是“预设子弹”每帧下移的距离，两者严格一致。
---=====================================

local SetViewMode = SetViewMode
local SetImageState = SetImageState
local RenderRect = RenderRect
local Render = Render
local LoadImageFromFile = LoadImageFromFile
local CheckRes = CheckRes
local Color = Color
local background = background
local misc = misc
local lstg = lstg
local sin, cos, max, min, int = sin, cos, max, min, int
local table = table

local WHITE = "white"
local CLOUD = "th00_0"

TH00_bg = Class(background)

---文件级“高度”：BOSS 出场时引擎会拿 _bg 再 New 一个背景，用它记住已经飞到宇宙
local cur_space = 0

---关卡开始时重置回大气层
function TH00_bg.ResetSpace()
    cur_space = 0
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

---冲破：不切场景，只是把“高度”连续推上去，云层淡出、星空淡入
---@param time number|nil @过渡帧数
function TH00_bg.Warp(time)
    local bg = TH00_bg.current
    if not bg or not IsValid(bg) or bg.space >= 1 then
        return
    end
    bg.space_accel = 1 / max(1, int(time or 90))
end

function TH00_bg:init()
    if not CheckRes("img", "stg6bg2") then
        LoadImageFromFile("stg6bg2", "mod\\BG\\TH08\\TH08_bg_stg6bg2.png")
    end
    background.init(self, false)

    self.space = cur_space     -- 0 = 大气层，1 = 宇宙
    self.space_accel = 0       -- 过渡中每帧推进多少
    self.opacity = 255 * (1 - cur_space)  -- 大气层的不透明度（0~255）
    self.speed = 1.2           -- 当前云层速度（world 单位/帧）
    self.speed_max = 1.2       -- 加速目标
    self.accel = 0             -- 每帧加速度
    self.scroll = 0            -- 主云层纹理偏移（= 累计下移距离）
    self.scroll2 = 0           -- 近景云层纹理偏移
    self.turb = 0              -- 乱流强度（横向抖动）
    self.streaks = {}          -- 速度线
    local w = lstg.world
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

function TH00_bg:frame()
    --高度推进：这就是“冲破”的过渡本身，一帧一帧地飞出去
    if self.space_accel ~= 0 then
        self.space = min(1, self.space + self.space_accel)
        if self.space >= 1 then
            self.space_accel = 0
            cur_space = 1
        end
    end
    --大气层的不透明度（0~255），子弹用它对齐
    self.opacity = 255 * (1 - self.space)
    if self.space >= 1 then
        return
    end
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
    local space = self.space

    -- 底色：纯黑
    SetImageState(WHITE, "", 255, 0, 0, 0)
    RenderRect(WHITE, w.l, w.r, w.b, w.t)

    -- 宇宙：TH08 六面的 stg6bg2，随高度渐显（关掉樱花瓣，只留背景本身）
    if space > 0 then
        SetImageState("stg6bg2", "", 255 * space, 255, 255, 255)
        Render("stg6bg2", sin(t / 9) * 50 * space, 0)
    end

    -- 大气层：云层与速度线随高度渐隐，飞到顶就自然没了
    if space < 1 then
        local a = 1 - space
        local turb = self.turb * 7 * sin(t / 19)
        misc.RenderTexInRect(CLOUD, w.l, w.r, w.b, w.t,
                turb, self.scroll, 0, 1, 1, "", Color(255 * a, 36, 36, 40))
        misc.RenderTexInRect(CLOUD, w.l, w.r, w.b, w.t,
                128 - turb, self.scroll2, 0, 1, 1, "", Color(150 * a, 16, 16, 20))
        local s
        for i = 1, #self.streaks do
            s = self.streaks[i]
            local k = a * s.a / 255
            SetImageState(WHITE, "mul+add", 255, 220 * k, 240 * k, 255 * k)
            RenderRect(WHITE, s.x - s.w * 0.5, s.x + s.w * 0.5,
                    s.y - s.len * 0.5, s.y + s.len * 0.5)
        end
    end
end
