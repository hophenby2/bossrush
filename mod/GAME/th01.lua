---=====================================
---TH01
---=====================================

local class = {}
_editor_class["TH01"] = class

local Class = Class
local boss = boss
local task = task
local object = object
local laser = laser
local sp = sp
local New = New
local NewSimpleBullet = NewSimpleBullet
local PlaySound = PlaySound
local Angle = Angle
local Dist = Dist
local IsValid = IsValid
local GROUP, LAYER = GROUP, LAYER
local SetImageState = SetImageState
local Render = Render
local ran = ran
local cos, sin, min = cos, sin, min

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th01_0", true, 0, 0, 0, 0, -0.06, 0, "", 1, 1, function(l)
        --符卡背景：一层偏蓝的夜色
        l.r, l.g, l.b = 110, 148, 214
    end)
end

boss.Define("1a", "未命名Boss", "TH01_0", TH01_bg, { 0, 300 }, class["SCBG1"], "Rumia", 21)

--============================
--[符卡] 水中月天上月
--
--  · 两颗蓝色光玉（月亮）绕着屏幕中心顺时针旋转，极坐标恒差 180°。
--  · 水中月：每 15 帧放出一圈低密度小玉，并沿着这一圈画一个圆
--    （小玉本来就落在同一个圆上，线圈纯绘制，没有判定）。
--  · 天上月：每 20 帧沿月亮的一条半径「发射」一条细激光，激光会
--    自己向外飞（不再挂在月亮上）；每放一条，下一条激光的角度
--    就逆时针转 30°。
--============================
do
    ------------------------------------------------------------------
    --绘制工具
    ------------------------------------------------------------------
    --加算细线（自绘，不生成任何对象，所以没有判定）
    local function thin_line(x1, y1, x2, y2, a, r, g, b, w)
        local len = Dist(x1, y1, x2, y2)
        if a <= 0 or len < 1 then
            return
        end
        SetImageState("white", "mul+add", a, r, g, b)
        Render("white", (x1 + x2) * 0.5, (y1 + y2) * 0.5, Angle(x1, y1, x2, y2), len / 16, w or 0.2)
    end

    ---画一颗蓝色光玉当月亮
    ---@param s number @1.0 时主体约 58px
    ---@param a number @0~1 整体透明度
    local function draw_orb(x, y, s, a)
        SetImageState("ball_huge6", "mul+add", 105 * a, 122, 176, 255)
        Render("ball_huge6", x, y, 0, s * 0.80, s * 0.80)
        SetImageState("ball_big6", "mul+add", 245 * a, 198, 220, 255)
        Render("ball_big6", x, y, 0, s * 0.90, s * 0.90)
        SetImageState("ball_big6", "mul+add", 215 * a, 255, 255, 255)
        Render("ball_big6", x, y, 0, s * 0.40, s * 0.40)
    end

    ------------------------------------------------------------------
    --数值
    ------------------------------------------------------------------
    local ORBIT = 150              --两轮月亮的轨道半径
    local SPIN = -0.7              --角速度（度/帧，负 = 顺时针）
    local RING_GAP = 15            --水中月放圈间隔
    local RING_N = 8               --每圈小玉数量（低密度）
    local RING_V = 1.4             --小玉初速
    local RING_LIFE = 110          --一圈小玉的存活帧数（到点整圈回收，不做淡出）
    local RING_LINE_A = 150        --线圈亮度（固定值，不做淡出）
    local RING_SEG = 36            --线圈细分段数（连起来就是一个圆）
    local LASER_GAP = 20           --天上月放激光间隔
    local LASER_LEN = 118          --细激光长度
    local LASER_W = 4              --细激光宽度（细）
    local LASER_CORE = 0.125       --自绘白芯的粗细（th12 用的就是 0.125）
    local LASER_V = 7.2            --发射出去的速度
    local LASER_LIFE = 52          --飞这么多帧之后收束
    local LASER_HEAD = 4           --激光头大小（和 th12 一样，尖端挂一颗光玉）
    local LASER_STEP = 30          --每条激光逆时针推进的角度

    ------------------------------------------------------------------
    --天上月的细激光（参考 th12 的激光：细白芯 + 激光头 + laser 本体）
    --  发射出去以后自己沿着半径方向飞，不再挂在月亮上。
    --  注意别调 laser.ChangeImage！它会把激光头的贴图换成 ball_mid_b*，
    --  而 ball_mid_b* 是引擎内置预载的、没进游戏侧 ImageColor 缓存，
    --  一 SetImageState 就崩；th12 的 Create.laser_line 也是用默认贴图。
    ------------------------------------------------------------------
    class["th01_ray"] = Class(laser, {
        init = function(self, x, y, a, v)
            --最后的 LASER_HEAD 就是激光头：laser.render 会在尖端画一颗光玉
            laser.init(self, 6, x, y, a, 0, LASER_LEN, 0, LASER_W, 0, LASER_HEAD)
            self.bound = false
            self.colli = true
            self.layer = LAYER.ENEMY_BULLET + 6
            self._blend, self._a = "mul+add", 255
            self._r, self._g, self._b = 140, 200, 255
            object.SetV(self, v, a, false)                --飞出去
            task.New(self, function()
                laser._TurnOn(self, 6, true, true)
                task.Wait(LASER_LIFE)
                laser._TurnOff(self, 8, true)
                object.RawDel(self)
            end)
        end,
        render = function(self)
            if self.alpha <= 0.01 then
                return
            end
            --th12 那种细白芯：撑在激光中轴上的细线
            SetImageState("white", "mul+add", self.alpha * 170, 160, 210, 255)
            Render("white", self.x + cos(self.rot) * LASER_LEN * 0.5,
                    self.y + sin(self.rot) * LASER_LEN * 0.5,
                    self.rot, LASER_LEN / 16, LASER_CORE)
            laser.render(self)
        end,
    })

    ------------------------------------------------------------------
    --两颗月亮 + 它们的弹幕
    ------------------------------------------------------------------
    class["th01_moons"] = Class(object, {
        init = function(self, orbit)
            self.cx, self.cy = 0, 0
            self.orbit = orbit or ORBIT
            self.ang = -90                 --水中月的极角（-90 = 屏幕正下方）
            self.spin = SPIN
            self.bound = false
            self.colli = false
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET - 30

            self.wx, self.wy = 0, -self.orbit
            self.sx, self.sy = 0, self.orbit

            self.rings = {}                --水中月放出的圈
            self.lasers = {}               --天上月放出的激光
            self.ring_t = 0
            self.laser_t = 0
            self.laser_ang = 0
        end,
        frame = function(self)
            --两轮月亮：同角速度旋转，极坐标差恒为 180°
            self.ang = (self.ang + self.spin) % 360
            local wa = self.ang
            local sa = self.ang + 180
            self.wx = self.cx + cos(wa) * self.orbit
            self.wy = self.cy + sin(wa) * self.orbit
            self.sx = self.cx + cos(sa) * self.orbit
            self.sy = self.cy + sin(sa) * self.orbit

            --========== 水中月：每 15 帧一圈低密度小玉 ==========
            self.ring_t = self.ring_t + 1
            if self.ring_t >= RING_GAP then
                self.ring_t = 0
                local ct = {}
                for a in sp.math.AngleIterator(ran:Float(0, 360), RING_N) do
                    local o = NewSimpleBullet(ball_small, 6, self.wx, self.wy, RING_V, a, false, 0)
                    --自己管理生命周期，不让世界边界把它单独回收，
                    --否则线圈会在半途缺角
                    o.bound = false
                    o._blend = "mul+add"
                    ct[#ct + 1] = o
                end
                --记下圆心：一圈小玉是同一时刻、同一点、同一速度甩出去的，
                --所以它们永远落在以这个点为心、半径 RING_V * age 的圆上
                self.rings[#self.rings + 1] = { ct = ct, age = 0, ox = self.wx, oy = self.wy }
                PlaySound("tan00", 0.02, self.wx / 200, true)
            end

            --圈的老化：不淡出、不关判定，到点整圈回收
            --（整张卡里只有四阶段的装饰水光弹才动透明度）
            local rings = self.rings
            for i = #rings, 1, -1 do
                local rg = rings[i]
                rg.age = rg.age + 1
                local ct = rg.ct
                if rg.age >= RING_LIFE then
                    for j = 1, #ct do
                        if IsValid(ct[j]) then
                            object.RawDel(ct[j])
                        end
                    end
                    table.remove(rings, i)
                end
            end

            --========== 天上月：每 20 帧沿一条半径发射一条细激光 ==========
            self.laser_t = self.laser_t + 1
            if self.laser_t >= LASER_GAP then
                self.laser_t = 0
                local a = self.laser_ang
                self.laser_ang = (self.laser_ang + LASER_STEP) % 360   --逆时针
                --激光自己会飞，不跟着月亮走
                self.lasers[#self.lasers + 1] =
                        New(class["th01_ray"], self.sx, self.sy, a, LASER_V)
            end
            local lasers = self.lasers
            for i = #lasers, 1, -1 do
                if not IsValid(lasers[i]) then
                    table.remove(lasers, i)
                end
            end
        end,
        render = function(self)
            --水中月：每一圈小玉正好落在同一个圆上，所以直接把这个圆画出来，
            --而不是把相邻的小玉用直线连成多边形
            local rings = self.rings
            for i = 1, #rings do
                local rg = rings[i]
                local ct = rg.ct
                --圆心就是当初甩出这一圈的位置，半径取小玉到圆心的平均距离
                local m, sr = 0, 0
                for j = 1, #ct do
                    local o = ct[j]
                    if IsValid(o) then
                        m = m + 1
                        sr = sr + Dist(o.x, o.y, rg.ox, rg.oy)
                    end
                end
                if m >= 3 then
                    local r = sr / m
                    local a = RING_LINE_A
                    for j = 1, RING_SEG do
                        local a1 = (j - 1) * 360 / RING_SEG
                        local a2 = j * 360 / RING_SEG
                        thin_line(rg.ox + cos(a1) * r, rg.oy + sin(a1) * r,
                                rg.ox + cos(a2) * r, rg.oy + sin(a2) * r,
                                a, 132, 190, 255, 0.16)
                    end
                end
            end
            --两颗月亮（水中月稍暗，像映在水里）
            draw_orb(self.wx, self.wy, 0.95, 0.85)
            draw_orb(self.sx, self.sy, 1.12, 1)
        end,
        del = function(self)
            local rings = self.rings
            for i = 1, #rings do
                local ct = rings[i].ct
                for j = 1, #ct do
                    if IsValid(ct[j]) then
                        object.RawDel(ct[j])
                    end
                end
            end
            for i = 1, #self.lasers do
                if IsValid(self.lasers[i]) then
                    object.RawDel(self.lasers[i])
                end
            end
            self.rings, self.lasers = {}, {}
        end,
    }, true)

    do
        local card = boss.card.New("水中月天上月", 1, 2, 50, 1400)
        boss.card.add({ { card, "1a" } }, 21, "水中月天上月", 254)

        function card:before()
            task.MoveTo(0, 176, 60, 2)
        end

        function card:init()
            self.__moons = New(class["th01_moons"], ORBIT)
        end

        function card:del()
            if IsValid(self.__moons) then
                object.RawDel(self.__moons)
            end
            self.__moons = nil
        end
    end
end

--============================
--[符卡] 镜花水月
--
--  阶段推进是「血量狂暴」：打掉的血量够了就追加下一个阶段，
--  同时也留了兜底时间，打不动也会推进（和 th16AEX 终符一样用
--  boss 的阶段点 addAutoSPPoint，血条上会显示这几个点）。
--  一阶段：boss 放出「开花水光弹」——每一朵就是一圈均匀分布的水光弹，
--          一圈一圈错开着放，层层打开。
--  二阶段：追加镜子。镜面横在屏幕顶部，撞上镜面的子弹原速弹回。
--  三阶段：追加花。莲花从屏幕下方笔直上浮，沿途留下曲线激光；
--          升到屏幕上方后不再生成激光，摇着摆着坠下。
--  四阶段：追加月亮与潮汐。th15 的月亮悬在屏幕上方，用阴影表现圆缺，
--          并周期性地推动全屏子弹的 y 速度；这时才追加低透明度、
--          无判定的装饰性水光弹。
--  越往后越狂暴：开花与莲花的节奏随阶段加快。
--============================
do
    ------------------------------------------------------------------
    --阶段：血量驱动 + 兜底时间
    --  掉够 HP_xxx 的血就吃掉一个阶段点（boss 系统 checkAutoSPPoint），
    --  拖到 PH_xxx 帧也会吃掉；两者谁先到算谁
    ------------------------------------------------------------------
    local HP_MIRROR = 550          --掉 550 血：追加镜子
    local HP_FLOWER = 1100         --掉 1100 血：追加花
    local HP_MOON = 1650           --掉 1650 血：追加月亮与潮汐
    local PH_MIRROR = 12 * 60      --兜底：12s
    local PH_FLOWER = 24 * 60      --兜底：24s
    local PH_MOON = 34 * 60        --兜底：34s

    ------------------------------------------------------------------
    --版面
    ------------------------------------------------------------------
    local BOSS_X, BOSS_Y = 0, 130
    local MIRROR_Y = 206           --镜面高度（贴着屏幕上沿）
    local MOON_Y = 224             --月亮中心（悬在屏幕上沿，与 th15 的月亮同高）
    local MOON_S = 0.9             --月亮贴图的缩放（原图 128px，与 th15 一致）
    local MOON_SHADOW = 64 * MOON_S * 1.6   --阴影扫过月面的最大距离
    local TOP_Y = 182              --花升到这个高度就算到顶
    local FLOOR_Y = -246           --花从屏幕下方多低出发

    ------------------------------------------------------------------
    --数值
    ------------------------------------------------------------------
    local BLOOM_GAP = { 46, 40, 34, 30 }   --各阶段再次开花的间隔（越往后越狂暴）
    local BLOOM_WAY = { 2, 3, 3, 4 }       --各阶段一次开几圈（错开时间放，层层打开）
    local BLOOM_STEP = 8           --同一轮里两圈之间错开的帧数
    local BLOOM_N = 10             --一圈几瓣（均匀分布）
    local PETAL_V = 1.8            --一圈水光弹的初速
    local LOTUS_GAP = { 100, 100, 76, 58 }  --各阶段莲花的生成间隔
    local LOTUS_RISE = 2.0         --莲花上浮速度
    local LOTUS_FALL = 1.6         --莲花下坠速度
    local LOTUS_SWAY = 26          --莲花摇摆的幅度
    local LASER_FADE = 14          --到顶后曲线激光的收束帧数
    local LASER_LEN = 220          --曲线激光的长度（帧）
    local LASER_W = 7              --曲线激光的宽度
    local MOON_PERIOD = 240        --月相（潮汐）周期
    local TIDE_ACC = 0.8           --潮汐每帧推给子弹的 y 位移
    local DECO_PER = 2             --每帧生成的装饰水光弹数量
    local DECO_LIFE = 84           --装饰水光弹存活帧数
    local DECO_FADE = 26           --装饰水光弹淡入淡出的帧数

    ------------------------------------------------------------------
    --共用
    ------------------------------------------------------------------
    local moon_ph = 0              --本帧月相：-1 ~ 1（0 = 新月，±1 = 满月）
    local tide_dv = 0              --本帧潮汐推给子弹的 y 位移
    local mirror_on = false        --镜面是否已经出现

    --一团水光（自绘，不生成对象）
    local function draw_water(x, y, size, k)
        if k <= 0 then
            return
        end
        SetImageState("ball_light5", "mul+add", 70 * k, 96, 150, 255)
        Render("ball_light5", x, y, 0, size * 1.6, size * 1.6)
        SetImageState("ball_light6", "mul+add", 200 * k, 186, 226, 255)
        Render("ball_light6", x, y, 0, size, size)
        SetImageState("ball_light6", "mul+add", 170 * k, 255, 255, 255)
        Render("ball_light6", x, y, 0, size * 0.42, size * 0.42)
    end

    --潮汐：只推敌方子弹（花的花瓣位置由花自己摆，不接受潮汐）
    local function tide_push(o)
        if not o.no_tide then
            o.y = o.y + tide_dv
        end
    end

    --镜面反弹：撞上镜面的子弹原速弹回
    local function mirror_hit(o)
        local vy = o.vy
        if vy and vy > 0 and o.y > MIRROR_Y then
            o.y = MIRROR_Y * 2 - o.y
            o.vy = -vy
            o.rot = Angle(0, 0, o.vx, o.vy)
        end
    end

    ------------------------------------------------------------------
    --装饰性水光弹：低透明度、高密度、无判定，纯气氛
    ------------------------------------------------------------------
    class["th01_mote"] = Class(object, {
        init = function(self, x, y)
            self.x, self.y = x, y
            local a = ran:Float(0, 360)
            local v = ran:Float(0.7, 2.2)
            self.vx, self.vy = cos(a) * v, sin(a) * v
            self.omiga = ran:Float(-1.5, 1.5)
            self.size = ran:Float(0.45, 1.05)
            self.a0 = ran:Int(45, 115)     --低透明度，带一点随机
            self.life = DECO_LIFE
            self.k = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 20
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.life = self.life - 1
            if self.life <= 0 then
                object.RawDel(self)
                return
            end
            local k = min(1, self.life / DECO_FADE)
            if self.timer < DECO_FADE then
                k = min(k, self.timer / DECO_FADE)
            end
            self.k = k
            --装饰水光弹也照镜子、也跟着潮汐漂
            if mirror_on and self.vy > 0 and self.y > MIRROR_Y then
                self.y = MIRROR_Y * 2 - self.y
                self.vy = -self.vy
            end
            self.y = self.y + tide_dv
        end,
        render = function(self)
            draw_water(self.x, self.y, self.size * 0.85, self.a0 / 255 * self.k)
        end,
    }, true)

    ------------------------------------------------------------------
    --镜子：二阶段起，横在屏幕顶部
    ------------------------------------------------------------------
    class["th01_mirror"] = Class(object, {
        init = function(self)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 110
            self.bound, self.colli = false, false
        end,
        frame = function() end,
        render = function(self)
            local k = 0.75 + 0.25 * sin(self.timer * 3)
            SetImageState("white", "mul+add", 34 * k, 110, 165, 255)
            Render("white", 0, MIRROR_Y, 0, 25, 15 / 16)
            SetImageState("white", "mul+add", 120 * k, 170, 215, 255)
            Render("white", 0, MIRROR_Y, 0, 25, 2 / 16)
            SetImageState("white", "mul+add", 235 * k, 235, 250, 255)
            Render("white", 0, MIRROR_Y + 2, 0, 25, 0.6 / 16)
            SetImageState("white", "mul+add", 90 * k, 200, 235, 255)
            Render("white", 0, MIRROR_Y - 3, 0, 25, 0.8 / 16)
        end,
    }, true)

    ------------------------------------------------------------------
    --月亮：四阶段起，悬在屏幕上方，阴影扫过就是圆缺
    ------------------------------------------------------------------
    class["th01_moon"] = Class(object, {
        init = function(self)
            self.group, self.layer = GROUP.GHOST, LAYER.BG + 100
            self.bound, self.colli = false, false
        end,
        frame = function() end,
        render = function()
            --月晕
            SetImageState("ball_light6", "mul+add", 34, 96, 150, 255)
            Render("ball_light6", 0, MOON_Y, 0, 7.5 * MOON_S, 7.5 * MOON_S)
            --月亮本体（th15 用的月亮贴图）
            SetImageState("moon", "", 255, 236, 240, 255)
            Render("moon", 0, MOON_Y, 0, MOON_S, MOON_S)
            --阴影：把月亮贴图再画一遍并涂成近黑色，横向偏移就是圆缺
            --偏移量取正数，月亮只会从满月缩成细月牙，不会整个黑掉
            SetImageState("moon", "", 255, 5, 8, 22)
            Render("moon", MOON_SHADOW * (1 + 0.5 * moon_ph), MOON_Y, 0, MOON_S, MOON_S)
        end,
    }, true)

    ------------------------------------------------------------------
    --莲花：屏幕下方笔直上浮、沿路留曲线激光；到顶后摇摆坠下
    ------------------------------------------------------------------
    class["th01_lotus"] = Class(object, {
        init = function(self, x, y)
            self.x, self.y = x, y
            self.base_x = x
            self.sway = ran:Float(0, 360)
            self.up = true
            self.fade_t = 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 14
            self.bound, self.colli = false, false

            local col = ran:Int(5, 8)
            local ps = {}
            --五片花瓣：米弹
            for i = 1, 5 do
                local b = NewSimpleBullet(knife, col, x, y, 0, 0, false, 0)
                b.bound = false
                b.no_tide = true
                b.group = GROUP.INDES
                b.colli = true
                b._blend = "mul+add"
                b._r, b._g, b._b = 170, 215, 255
                ps[#ps + 1] = b
            end
            --花心：小玉
            local c = NewSimpleBullet(ball_small, col, x, y, 0, 0, false, 0)
            c.bound = false
            c.no_tide = true
            c.group = GROUP.INDES
            c.colli = true
            c._blend = "mul+add"
            c._r, c._g, c._b = 255, 255, 250
            ps[#ps + 1] = c
            self.petals = ps

            --沿路的曲线激光
            local l = New(bent_laser, col, x, y, LASER_LEN, LASER_W, 4, 0)
            l.bound = false
            l.alpha = 1
            l._blend = "mul+add"
            l._r, l._g, l._b = 130, 200, 255
            bent_laser.setWidth(l, LASER_W)
            self.laser = l
        end,
        frame = function(self)
            if self.up then
                self.y = self.y + LOTUS_RISE
                self.sway = self.sway + 0.9
                self.x = self.base_x + sin(self.sway) * LOTUS_SWAY * 0.5
                if IsValid(self.laser) then
                    self.laser.x, self.laser.y = self.x, self.y
                end
                if self.y >= TOP_Y then
                    --到顶：不再生成激光，只把已有的收掉
                    self.up = false
                    self.fade_t = LASER_FADE
                    local l = self.laser
                    if IsValid(l) then
                        l.counter = LASER_FADE
                        l.da = -l.alpha / LASER_FADE
                        l.dw = -l.w / LASER_FADE
                    end
                end
            else
                self.y = self.y - LOTUS_FALL
                self.sway = self.sway + 2.4
                self.x = self.base_x + sin(self.sway) * LOTUS_SWAY
                if IsValid(self.laser) then
                    self.fade_t = self.fade_t - 1
                    if self.fade_t <= 0 then
                        object.RawDel(self.laser)
                        self.laser = nil
                    end
                end
                if self.y < FLOOR_Y - 30 then
                    object.RawDel(self)
                    return
                end
            end

            --摆花瓣
            local ps = self.petals
            for i = 1, 5 do
                local b = ps[i]
                if IsValid(b) then
                    local a = self.sway + (i - 1) * 72
                    b.x = self.x + cos(a) * 17
                    b.y = self.y + sin(a) * 17
                    b.rot = a - 90
                end
            end
            local c = ps[6]
            if IsValid(c) then
                c.x, c.y = self.x, self.y
            end
        end,
        render = function(self)
            draw_water(self.x, self.y, 0.9, 0.55)
        end,
        del = function(self)
            local ps = self.petals
            for i = 1, #ps do
                if IsValid(ps[i]) then
                    object.RawDel(ps[i])
                end
            end
            if IsValid(self.laser) then
                object.RawDel(self.laser)
            end
            self.petals, self.laser = {}, nil
        end,
    }, true)

    ------------------------------------------------------------------
    --符卡控制器：只追加、不替换，一镜到底
    ------------------------------------------------------------------
    class["th01_kikyo"] = Class(object, {
        init = function(self, master)
            self.master = master
            self.mtime = 0
            self.phase = 1
            --共享状态是文件级 upvalue：同一次游戏里重进本关时脚本不会重新
            --加载，所以必须在这里归零，否则一阶段就会带着上次的镜面与潮汐
            mirror_on = false
            moon_ph = 0
            tide_dv = 0
            self.bloom_t = 0
            self.bloom_q = 0        --本轮还剩几圈没放
            self.bloom_cd = 0
            self.lotus_t = 0
            self.moon_t = 0
            self.lotuses = {}
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
        end,
        frame = function(self)
            self.mtime = self.mtime + 1

            --========== 阶段推进：血量（或兜底时间）驱动 ==========
            --boss 系统每吃掉一个阶段点，这里就追加一个阶段；
            --一次吃掉多个也能一次追上，不会漏阶段
            local m = self.master
            local left = 0
            if m and m._sp_point_auto then
                left = #m._sp_point_auto
            end
            local done = 3 - left          --已经吃掉的阶段点数 0~3
            if done >= 1 and self.phase < 2 then
                self.phase = 2
                mirror_on = true
                self.mv = New(class["th01_mirror"])
            end
            if done >= 2 and self.phase < 3 then
                self.phase = 3
            end
            if done >= 3 and self.phase < 4 then
                self.phase = 4
                self.mo = New(class["th01_moon"])
            end

            local bx, by = BOSS_X, BOSS_Y
            if IsValid(m) then
                bx, by = m.x, m.y
            end
            local ph = self.phase

            --========== 开花水光弹（一阶段起，全程；越往后越狂暴） ==========
            --一朵花 = 一圈均匀分布的水光弹，直接从 boss 身上开出来；
            --同一轮的几圈错开几帧放，看上去就是一层一层往外打开。
            --水光弹本身不做透明度，判定照常（四阶段的装饰弹才无判定）。
            if self.bloom_q > 0 then
                self.bloom_cd = self.bloom_cd - 1
                if self.bloom_cd <= 0 then
                    self.bloom_cd = BLOOM_STEP
                    self.bloom_q = self.bloom_q - 1
                    local col = ran:Int(5, 8)
                    for a in sp.math.AngleIterator(ran:Float(0, 360), BLOOM_N) do
                        local b = NewSimpleBullet(ball_light, col, bx, by,
                                PETAL_V, a, false, 0)
                        b._blend = "mul+add"
                    end
                    PlaySound("tan00", 0.05, bx / 256, true)
                end
            else
                self.bloom_t = self.bloom_t + 1
                if self.bloom_t >= BLOOM_GAP[ph] then
                    self.bloom_t = 0
                    self.bloom_q = BLOOM_WAY[ph]
                    self.bloom_cd = 0
                end
            end

            --========== 装饰性水光弹（四阶段起：低透明度、无判定，纯气氛） ==========
            if ph >= 4 then
                for _ = 1, DECO_PER do
                    New(class["th01_mote"], bx + ran:Float(-34, 34), by + ran:Float(-26, 26))
                end
            end

            --========== 镜子（二阶段起） ==========
            if self.phase >= 2 then
                object.BulletDo(mirror_hit)
                object.IndesDo(mirror_hit)
            end

            --========== 花（三阶段起） ==========
            if self.phase >= 3 then
                self.lotus_t = self.lotus_t + 1
                if self.lotus_t >= LOTUS_GAP[ph] then
                    self.lotus_t = 0
                    self.lotuses[#self.lotuses + 1] =
                            New(class["th01_lotus"], ran:Float(-150, 150), FLOOR_Y)
                end
                local ls = self.lotuses
                for i = #ls, 1, -1 do
                    if not IsValid(ls[i]) then
                        table.remove(ls, i)
                    end
                end
            end

            --========== 月亮与潮汐（四阶段起） ==========
            if self.phase >= 4 then
                self.moon_t = self.moon_t + 1
                moon_ph = sin(self.moon_t * 360 / MOON_PERIOD)
                tide_dv = TIDE_ACC * moon_ph
                object.BulletDo(tide_push)
                object.IndesDo(tide_push)
            end
        end,
        render = function() end,
        del = function(self)
            local ls = self.lotuses
            for i = 1, #ls do
                if IsValid(ls[i]) then
                    object.RawDel(ls[i])
                end
            end
            if IsValid(self.mv) then
                object.RawDel(self.mv)
            end
            if IsValid(self.mo) then
                object.RawDel(self.mo)
            end
            self.lotuses = {}
        end,
    }, true)

    do
        local card = boss.card.New("镜花水月", 2, 4, 38, 2200)
        boss.card.add({ { card, "1a" } }, 21, "镜花水月", 255)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, 2)
        end

        function card:init()
            --血量狂暴：打掉 HP_xxx 血（或拖到兜底时间）就追加一个阶段。
            --用的是 boss 自己的阶段点，所以血条上也能看到这几个位置
            --最后一个 true = 用「本张符卡」的计时器做兜底，
            --否则会拿 boss 开打以来的总时间，一进场就直接跳到四阶段
            self._bosssys:addAutoSPPoint(HP_MIRROR, PH_MIRROR, true)
            self._bosssys:addAutoSPPoint(HP_FLOWER, PH_FLOWER, true)
            self._bosssys:addAutoSPPoint(HP_MOON, PH_MOON, true)
            self.__kikyo = New(class["th01_kikyo"], self)
        end

        function card:del()
            if IsValid(self.__kikyo) then
                object.RawDel(self.__kikyo)
            end
            self.__kikyo = nil
        end
    end
end
