---=====================================
---TH02  重写版 TH00：同一套宇宙/星空主题，
---  但弹幕全部交给「继承 bullet / object / laser 的类」去做：
---    · 子弹的路径写在自己的 frame 里——弧线、椭圆轨道、对数螺线、
---      被引力拽着走、停下再倒着飞……不再是清一色的匀速/匀变速直线
---    · 发弹点、观测装置、彗星、星云卵都是 object 子类，可以挂在 boss 上
---    · 光束是 laser 子类，用 _TurnHalfOn / _TurnOn / _TurnOff 控制开合
---  每张卡的常量都放在各自 do 块的开头，改手感只动那里。
---=====================================

local class = {}
_editor_class["TH02"] = class

local Class = Class
local boss = boss
local task = task
local object = object
local laser = laser
local bullet = bullet
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
local cos, sin, max, min, abs, int, sqrt, sign = cos, sin, max, min, abs, int, sqrt, sign

class["SCBG1"] = Class(_SC_BG)
class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th02_0", true, 0, 0, 0, 0, -0.05, 0, "", 1, 1, function(l)
        --符卡背景：一层偏紫的深空
        l.r, l.g, l.b = 132, 116, 208
    end)
end

boss.Define("1a", "未命名Boss", "TH02_0", TH02_bg, { 0, 300 }, class["SCBG1"], "Rumia", 22)

--============================
--公用小工具
--============================
local D2R = math.pi / 180

---3x3 行主序矩阵
local function mat_unit()
    return { 1, 0, 0, 0, 1, 0, 0, 0, 1 }
end

local function mat_mul(A, B)
    local C = {}
    for i = 0, 2 do
        local a1, a2, a3 = A[i * 3 + 1], A[i * 3 + 2], A[i * 3 + 3]
        for j = 1, 3 do
            C[i * 3 + j] = a1 * B[j] + a2 * B[j + 3] + a3 * B[j + 6]
        end
    end
    return C
end

---绕任意轴旋转 deg 度（罗德里格斯公式）
local function mat_axis(ax, ay, az, deg)
    local n = sqrt(ax * ax + ay * ay + az * az)
    if n < 1e-6 then
        return mat_unit()
    end
    ax, ay, az = ax / n, ay / n, az / n
    local c, s = math.cos(deg * D2R), math.sin(deg * D2R)
    local t = 1 - c
    return {
        t * ax * ax + c,      t * ax * ay - s * az, t * ax * az + s * ay,
        t * ax * ay + s * az, t * ay * ay + c,      t * ay * az - s * ax,
        t * ax * az - s * ay, t * ay * az + s * ax, t * az * az + c,
    }
end

local function mat_apply(M, x, y, z)
    return M[1] * x + M[2] * y + M[3] * z,
            M[4] * x + M[5] * y + M[6] * z,
            M[7] * x + M[8] * y + M[9] * z
end

---加算细线（自绘，不生成对象）
local function thin_line(x1, y1, x2, y2, a, r, g, b, w)
    local len = Dist(x1, y1, x2, y2)
    if a <= 0 or len < 1 then
        return
    end
    SetImageState("white", "mul+add", a, r, g, b)
    Render("white", (x1 + x2) * 0.5, (y1 + y2) * 0.5, Angle(x1, y1, x2, y2), len / 16, w or 0.2)
end

---画一颗装饰星（无判定）
local function draw_star(x, y, rot, scale, col, a)
    local img = "star_big" .. int(Forbid(col or 6, 1, 16))
    SetImageState(img, "mul+add", a or 255, 255, 255, 255)
    Render(img, x, y, rot, scale, scale)
end

---离屏回收：飞出 r 之外就删
local function retire(o, r)
    if o.x * o.x + o.y * o.y > r * r then
        object.RawDel(o)
        return true
    end
    return false
end

---通用「路径弹」：位置由每帧调用的 path(self, t) 决定，不用协程。
---兜底回收：寿命超上限或飞出很远的范围一律删掉，避免路径写漏了漏对象。
local path_bullet = Class(bullet, {
    init = function(self, style, col, x, y, v, a, path)
        bullet.init(self, style, col, false, true)
        self.x, self.y, self.rot = x, y, a or 0
        self.path = path
        self.bound = false
        self.spin = 0
        self.max_life = 900
        self.max_r2 = 600 * 600
        if v then
            SetV(self, v, a, false)
        end
    end,
    frame = function(self)
        bullet.frame(self)
        local t = self.timer
        if t > self.max_life or self.x * self.x + self.y * self.y > self.max_r2 then
            object.RawDel(self)
            return
        end
        self.path(self, t)
    end,
    render = function(self)
        bullet.render(self)
    end,
})

--============================
--[符卡1] 星空之匣
--  三维匣子的 12 条棱用粗线画投影；匣子里嵌着一撮星弹——它们的坐标
--  固定在匣内的三维空间里，所以匣子一转，星星就沿着椭圆轨迹在屏幕上
--  滑动（每帧重算投影，绝不是直线）。每隔一段时间匣子会绕一条随机轴
--  转一段时间，转的时候棱线变半亮。自机全程待在匣子里躲。
--============================
do
    local R = 168             --匣子半棱长
    local EDGE_FOCAL = R * 20 --棱线用长焦：保证任何角度下棱看起来都平行
    local STAR_FOCAL = R * 2.4--星弹用短焦：专门做近大远小
    local STAR_R = 0.72       --星弹在匣内的分布半径（相对 R）
    local STAR_N = 34         --星弹数量
    local SPIN = 0.55         --平时缓慢自转（度/帧）
    local INNER_SPIN = -0.22  --星云自身的自转（度/帧）
    local TURN_GAP = 170      --每隔多少帧来一次随机轴旋转
    local TURN_TIME = 76      --一次随机轴旋转持续多少帧
    local BOSS_X, BOSS_Y = 0, 150
    local BOX_CX, BOX_CY = 0, -6

    local BOX_VERT = {
        { -1, -1, -1 }, { 1, -1, -1 }, { 1, 1, -1 }, { -1, 1, -1 },
        { -1, -1, 1 }, { 1, -1, 1 }, { 1, 1, 1 }, { -1, 1, 1 },
    }
    local BOX_EDGES = {
        { 1, 2 }, { 2, 3 }, { 3, 4 }, { 4, 1 },
        { 5, 6 }, { 6, 7 }, { 7, 8 }, { 8, 5 },
        { 1, 5 }, { 2, 6 }, { 3, 7 }, { 4, 8 },
    }

    --星弹：嵌在匣子里的三维点
    class["th02_shard"] = Class(path_bullet, {
        init = function(self, x, y, z)
            path_bullet.init(self, star_small, 8, BOX_CX, BOX_CY, nil, 0, class["th02_shard"].path)
            self.px, self.py, self.pz = x, y, z
            self.spin = ran:Float(0, 360)
            self.omiga = ran:Float(-2.2, 2.2)
        end,
        path = function(self, t)
            local box = self.box
            if not IsValid(box) then
                object.RawDel(self)
                return
            end
            --匣内三维点先随星云自转，再被匣子的姿态矩阵投影
            local x1, y1, z1 = mat_apply(box.Mi, self.px, self.py, self.pz)
            local x2, y2, z2 = mat_apply(box.M, x1, y1, z1)
            local k = STAR_FOCAL / (STAR_FOCAL - z2)
            self.x = BOX_CX + x2 * k
            self.y = BOX_CY + y2 * k
            --近大远小：贴图和判定都跟着 k 走
            self.hscale = 0.55 * k
            self.vscale = 0.55 * k
            self.a, self.b = 5.5 * k, 5.5 * k
            self.rot = self.spin + t * 2
            --远近明暗只用在自绘的光晕上；星弹本体不做透明度变化
            self.depth = Forbid((k - 0.55) / 0.9, 0.35, 1)
        end,
        render = function(self)
            --远处的星星光晕更暗，近处的更亮（本体始终不透明）
            draw_star(self.x, self.y, self.rot, 5.5 * self.hscale, 8, 120 * self.depth)
            bullet.render(self)
        end,
    })

    --匣子：姿态矩阵 + 棱线投影 + 定时随机轴旋转
    class["th02_casket"] = Class(object, {
        init = function(self, n)
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
            self.M = mat_unit()
            self.Mi = mat_unit()
            self.turn = nil
            self.t = 0
            self.bright = 1
            self.shards = {}
            for i = 1, n do
                --球内均匀撒点
                local a = ran:Float(0, 360)
                local z = ran:Float(-1, 1)
                local r = sqrt(max(0, 1 - z * z)) * STAR_R * R
                local o = New(class["th02_shard"], cos(a) * r, sin(a) * r, z * STAR_R * R)
                o.box = self
                self.shards[#self.shards + 1] = o
            end
        end,
        frame = function(self)
            self.t = self.t + 1
            --定时切换成「随机轴旋转」
            if not self.turn and self.t % TURN_GAP == 0 then
                self.turn = {
                    t = 0,
                    ax = ran:Float(-1, 1), ay = ran:Float(-1, 1), az = ran:Float(-1, 1),
                    deg = ran:Float(80, 210) * (ran:Sign() or 1),
                    spin = ran:Float(2.5, 5.5) * (ran:Sign() or 1),
                }
                PlaySound("kira00", 0.05, 0, false)
            end
            local step_deg, step_in = SPIN, INNER_SPIN
            if self.turn then
                local T = self.turn
                T.t = T.t + 1
                --缓入缓出：前 25% 加速，后 25% 减速
                local k = T.t / TURN_TIME
                local w = min(1, k / 0.25) * min(1, (1 - k) / 0.25)
                step_deg = T.spin * w
                T.ax = T.ax + ran:Float(-0.06, 0.06)
                T.ay = T.ay + ran:Float(-0.06, 0.06)
                T.az = T.az + ran:Float(-0.06, 0.06)
                self.bright = 0.55 + 0.45 * abs(sin(k * 180))
                if T.t >= TURN_TIME then
                    self.turn = nil
                    self.bright = 1
                end
            end
            self.M = mat_mul(mat_axis(0.13, 0.91, 0.38, step_deg), self.M)
            self.Mi = mat_mul(mat_axis(0.4, -0.2, 0.9, step_in), self.Mi)
        end,
        render = function(self)
            local M = self.M
            --8 个顶点投影（长焦，透视极弱）
            local sx, sy, sz = {}, {}, {}
            for i = 1, 8 do
                local v = BOX_VERT[i]
                local x, y, z = mat_apply(M, v[1] * R, v[2] * R, v[3] * R)
                local k = EDGE_FOCAL / (EDGE_FOCAL - z)
                sx[i], sy[i], sz[i] = BOX_CX + x * k, BOX_CY + y * k, k
            end
            --12 条棱：按深度排序，近的画得更亮更粗
            local order = {}
            for i = 1, #BOX_EDGES do order[i] = i end
            table.sort(order, function(a, b)
                local ea, eb = BOX_EDGES[a], BOX_EDGES[b]
                local da = sz[ea[1]] + sz[ea[2]]
                local db = sz[eb[1]] + sz[eb[2]]
                return da < db
            end)
            for _, i in ipairs(order) do
                local e = BOX_EDGES[i]
                local k = (sz[e[1]] + sz[e[2]]) * 0.5
                local a = (40 + 110 * (k - 0.9) * 10) * self.bright
                thin_line(sx[e[1]], sy[e[1]], sx[e[2]], sy[e[2]], a, 170, 200, 255, 0.16 + 0.1 * k)
            end
            --棱上的节点
            for i = 1, 8 do
                SetImageState("ball_light5", "mul+add", 90 * self.bright, 210, 230, 255)
                Render("ball_light5", sx[i], sy[i], 0, 3.4, 3.4)
            end
        end,
        del = function(self)
            for i = 1, #self.shards do
                if IsValid(self.shards[i]) then
                    object.RawDel(self.shards[i])
                end
            end
            self.shards = {}
        end,
    })

    do
        local card = boss.card.New("星空之匣", 1, 2, 60, 1500)
        boss.card.add({ { card, "1a" } }, 22, "星空之匣", 256)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, 2)
        end

        function card:init()
            self.__box = New(class["th02_casket"], STAR_N)
        end

        function card:del()
            if IsValid(self.__box) then
                object.RawDel(self.__box)
            end
            self.__box = nil
        end
    end
end

--============================
--[符卡2] 星屑回廊
--  一扇扇「门」从屏幕上方沿正弦轨迹飘下来，门沿上不断甩出星屑。
--  星屑是走圆弧的弹：自己的朝向每帧转一点，速度慢慢衰减，
--  所以它们甩出来以后会拐弯、打旋，而不是直着飞。
--============================
do
    local GATE_PER = 2        --每批生成几扇门
    local GATE_X = { -140, 140 }  --门的横坐标（按顺序取）
    local GATE_GAP = 92       --生成间隔
    local GATE_VY = 1.25      --门下落速度
    local GATE_AMP = 74       --门横向摆动幅度
    local GATE_R = 34         --门的半径
    local GATE_EMIT = 20      --门每多少帧甩一次星屑
    local GATE_ARM = 2        --一次甩几束
    local ARC_V = 2.6         --星屑初速
    local ARC_TURN = 3.1      --星屑每帧转向（度）
    local ARC_DRAG = 0.004    --星屑速度衰减
    local ARC_LIFE = 300      --星屑寿命（不用兜底，自己会到寿）
    local BOSS_X, BOSS_Y = 0, 160

    ---星屑：圆弧弹
    local function arc_path(self, t)
        if t > ARC_LIFE then
            object.RawDel(self)
            return
        end
        self.rot = self.rot + self.turn
        self.spd = self.spd * (1 - ARC_DRAG)
        SetV(self, self.spd, self.rot, false)
        --朝速度方向的自转，看起来在打旋
        if self.img then
            self.hscale = 0.7 + 0.25 * sin(t * 7)
            self.vscale = self.hscale
        end
    end

    ---门：一个会掉下来的圆环，沿上不断甩星屑
    class["th02_gate"] = Class(object, {
        init = function(self, x, delay, dir)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 40
            self.bound, self.colli = false, false
            self.dir = dir or 1
            self.base_x = x
            self.phase = ran:Float(0, 360)
            self.y = 300
            self.rot0 = ran:Float(0, 360)
            self.wait = delay or 0
            self.fired = 0
        end,
        frame = function(self)
            if self.wait > 0 then
                self.wait = self.wait - 1
                return
            end
            self.y = self.y - GATE_VY
            self.phase = self.phase + 1.6
            self.x = self.base_x + sin(self.phase) * GATE_AMP
            if self.y < -300 then
                object.RawDel(self)
                return
            end
            --沿环甩星屑：出口自己也在绕环转
            self.fired = self.fired + 1
            if self.fired % GATE_EMIT == 0 then
                local spin = self.fired * 7.5 * self.dir
                for k = 1, GATE_ARM do
                    local a = spin + k * 180 + self.rot0
                    local ox, oy = self.x + cos(a) * GATE_R, self.y + sin(a) * GATE_R
                    local o = New(path_bullet, star_small, 8, ox, oy, nil, 0, arc_path)
                    o.rot = a
                    o.spd = ARC_V * ran:Float(0.82, 1.1)
                    o.turn = ARC_TURN * self.dir
                    o.bound = false
                end
            end
        end,
        render = function(self)
            if self.wait > 0 then
                return
            end
            --门：两圈加算细线拼出来的圆
            for ring = 1, 2 do
                local rr = GATE_R * (ring == 1 and 1 or 0.62)
                local seg = 20 + ring * 6
                for i = 1, seg do
                    local a1 = self.rot0 + (i - 1) * 360 / seg
                    local a2 = self.rot0 + i * 360 / seg
                    local k = 0.6 + 0.4 * sin(self.fired * 6 + i * 30)
                    thin_line(self.x + cos(a1) * rr, self.y + sin(a1) * rr,
                            self.x + cos(a2) * rr, self.y + sin(a2) * rr,
                            (70 + 90 * k) * ring, 150 + 60 * ring, 190, 255, 0.14)
                end
            end
            SetImageState("ball_light6", "mul+add", 60, 190, 220, 255)
            Render("ball_light6", self.x, self.y, 0, 9, 9)
        end,
    })

    do
        local card = boss.card.New("星屑回廊", 1, 2, 50, 1300)
        boss.card.add({ { card, "1a" } }, 22, "星屑回廊", 257)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, 2)
        end

        function card:init()
            local b = self
            local gates = {}
            b.__gates = gates
            --发弹任务挂在 boss 上：引擎在每个符卡结束时 task.Clear(b)，
            --所以卡一结束就不会再生成新的门了
            task.New(b, function()
                local dir = 1
                while true do
                    for i = 1, GATE_PER do
                        local g = New(class["th02_gate"], GATE_X[i] or ran:Float(-140, 140), 0, dir)
                        gates[#gates + 1] = g
                    end
                    dir = -dir
                    task.Wait(GATE_GAP)
                end
            end)
        end

        function card:del()
            --把还活着的门收掉（子弹由引擎的消弹和自身寿命处理）
            local gs = self.__gates or {}
            for i = 1, #gs do
                if IsValid(gs[i]) then
                    object.RawDel(gs[i])
                end
            end
            self.__gates = nil
        end
    end
end

--============================
--[符卡3] 星座の糸
--  几颗「星」悬在场上，彼此用细线连成星座；每隔一会儿，某颗星会
--  沿自己连出去的那条线放出一道光束（laser 子类，半开→全开→收束），
--  放光束的同时沿光束方向撒一把星弹。星与星之间会缓慢换位，
--  所以星座的形状一直在变形。
--============================
do
    local NODE_N = 5
    local NODE_R = 150        --节点到中心的距离
    local NODE_ROT = 0.24     --节点绕中心公转（度/帧）
    local CHARGE = 46         --蓄力帧数
    local BEAM_ON = 42        --光束全开帧数
    local BEAM_OFF = 26       --收束帧数
    local CYCLE = 96          --一轮的总节拍
    local BEAM_W = 13         --光束宽度
    local BEAM_LEN = 230      --光束长度
    local BOSS_X, BOSS_Y = 0, 120

    ---光束：laser 子类，锚在星上、朝星座的连线下手
    class["th02_beam"] = Class(laser, {
        init = function(self, x, y, a, col)
            laser.init(self, col, x, y, a, 0, 0, 0, BEAM_W, 0, 0)
            self.bound = false
            self.col = col
            task.New(self, function()
                laser._TurnHalfOn(self, CHARGE, true)
                laser._TurnOn(self, 8, true)
                task.Wait(BEAM_ON)
                laser._TurnOff(self, BEAM_OFF, true)
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            --跟着宿主星走
            local n = self.node
            if n and IsValid(n) then
                self.x, self.y = n.x, n.y
            else
                object.RawDel(self)
            end
        end,
        render = function(self)
            if self.alpha <= 0.01 then
                return
            end
            local a, w = self.alpha, self.w
            for i = 1, 3 do
                local k = i == 1 and 1 or (i == 2 and 0.55 or 0.28)
                SetImageState("white", "mul+add", 120 * a * k, 190, 214, 255)
                Render("white", self.x + cos(self.rot) * BEAM_LEN * 0.5,
                        self.y + sin(self.rot) * BEAM_LEN * 0.5,
                        self.rot, BEAM_LEN / 16, w * k / 16)
            end
        end,
    })

    ---星座的星：绕中心公转 + 缓慢换位，按节拍放光束
    class["th02_node"] = Class(object, {
        init = function(self, i, n)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 10
            self.bound, self.colli = false, false
            self.index = i
            self.count = n
            self.ty = ran:Float(0.72, 1.35)   --各自的半径倍率
            self.rot0 = i * 360 / n + ran:Float(-14, 14)
            self.spin = ran:Float(0.6, 1.4)
            self.tick = ran:Int(0, CYCLE - 1)
            self.pulse = 0
        end,
        frame = function(self)
            local t = self.timer
            self.rot0 = self.rot0 + NODE_ROT
            local r = NODE_R * (self.ty + 0.16 * sin(t * 0.9 + self.index * 40))
            self.x = cos(self.rot0) * r
            self.y = sin(self.rot0) * r * 0.78 + 22
            self.tick = (self.tick + 1) % CYCLE
            if self.tick == 0 then
                --朝下一颗星连线，沿这条线放光束
                local mate = self.mate
                if mate and IsValid(mate) then
                    local a = Angle(self.x, self.y, mate.x, mate.y)
                    local beam = New(class["th02_beam"], self.x, self.y, a, 6)
                    beam.node = self
                    self.beam = beam
                    --沿线撒星弹
                    for k = 1, 5 do
                        local o = New(path_bullet, star_small, 8,
                                self.x + cos(a) * 20, self.y + sin(a) * 20, nil, 0,
                                function(s, tt)
                                    s.spd = s.spd + 0.012
                                    SetV(s, s.spd, a + sin(tt * 4) * 12, false)
                                end)
                        o.spd = 1.6 + k * 0.55
                        o.bound = false
                    end
                    PlaySound("tan00", 0.05, 0, false)
                end
            end
            if self.tick == CHARGE then
                self.pulse = 1
            end
            self.pulse = max(0, self.pulse - 0.02)
        end,
        render = function(self)
            --和同伴的连线（星座的糸）
            local mate = self.mate
            if mate and IsValid(mate) then
                local a = Angle(self.x, self.y, mate.x, mate.y)
                local d = Dist(self.x, self.y, mate.x, mate.y)
                thin_line(self.x, self.y, mate.x, mate.y, 34, 140, 160, 230, 0.1)
                --线上流动的点
                for k = 1, 3 do
                    local f = ((self.timer * 0.012 + k * 0.33) % 1)
                    draw_star(self.x + cos(a) * d * f, self.y + sin(a) * d * f,
                            self.timer * 4, 0.42, 6, 150)
                end
            end
            local s = 3.2 + 1.6 * self.pulse
            SetImageState("ball_light5", "mul+add", 200, 210, 230, 255)
            Render("ball_light5", self.x, self.y, 0, s, s)
            draw_star(self.x, self.y, self.timer * self.spin, 1.5 + 0.5 * self.pulse, 8, 235)
        end,
    })

    do
        local card = boss.card.New("星座の糸", 1, 2, 50, 1300)
        boss.card.add({ { card, "1a" } }, 22, "星座の糸", 258)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, 2)
        end

        function card:init()
            local nodes = {}
            for i = 1, NODE_N do
                nodes[i] = New(class["th02_node"], i, NODE_N)
            end
            for i = 1, NODE_N do
                nodes[i].mate = nodes[i % NODE_N + 1]
            end
            self.__nodes = nodes
        end

        function card:del()
            local ns = self.__nodes or {}
            for i = 1, #ns do
                if IsValid(ns[i]) then
                    object.RawDel(ns[i])
                end
                local beam = ns[i] and ns[i].beam
                if beam and IsValid(beam) then
                    object.RawDel(beam)
                end
            end
            self.__nodes = nil
        end
    end
end

--============================
--[符卡4] 銀河の腕
--  中心一个星系，4 条旋臂各自旋转；星弹从臂尖甩出去以后并不直飞，
--  而是保持自己的角速度绕中心公转、同时半径慢慢变大——在屏幕上
--  画出的是一条对数螺线。旋臂偶尔会减速、反向，螺线的旋向就跟着翻。
--============================
do
    local CX, CY = 0, 40          --星系中心
    local ARM_N = 4               --旋臂数
    local ARM_LEN = 205           --臂长
    local ARM_ROT = 3.2           --臂的公转速度（度/帧）
    local ARM_EMIT = 5            --每多少帧发一批
    local STAR_W = 0.85           --星弹绕中心的角速度（度/帧）
    local STAR_VR = 0.95          --星弹径向速度
    local STAR_RMAX = 330         --到这个半径就回收
    local REVERSE_CYCLE = 620     --隔多久反向一次
    local BOSS_X, BOSS_Y = 0, 165

    ---旋臂上的星弹：极坐标下的对数螺线
    local function arm_star_path(self, t)
        self.r = self.r + self.vr
        self.a = self.a + self.w
        self.x = CX + cos(self.a) * self.r
        self.y = CY + sin(self.a) * self.r * 0.86
        self.rot = self.a + (self.w > 0 and 90 or -90)
        local k = Forbid(1.35 - self.r / STAR_RMAX * 0.7, 0.5, 1.35)
        self.hscale, self.vscale = k, k
        self.a_rad = k
        if self.r > STAR_RMAX then
            object.RawDel(self)
        end
    end

    ---星系：旋臂的骨架 + 发弹节奏
    class["th02_galaxy"] = Class(object, {
        init = function(self)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 30
            self.bound, self.colli = false, false
            self.a0 = ran:Float(0, 360)
            self.dir = 1
            self.vel = ARM_ROT
            self.t = 0
            self.flash = 0
        end,
        frame = function(self)
            self.t = self.t + 1
            --每隔一段时间减速->反向->再加速
            local k = self.t % REVERSE_CYCLE
            if k > REVERSE_CYCLE - 90 then
                local f = (k - (REVERSE_CYCLE - 90)) / 90
                self.vel = ARM_ROT * abs(cos(f * 180))
                if k == REVERSE_CYCLE - 46 then
                    self.dir = -self.dir
                    self.flash = 1
                    PlaySound("tan00", 0.05, 0, false)
                end
            else
                self.vel = ARM_ROT
            end
            self.a0 = self.a0 + self.vel * self.dir
            self.flash = max(0, self.flash - 0.02)
            --从臂尖甩出星弹
            if self.t % ARM_EMIT == 0 then
                local r0 = ARM_LEN * ran:Float(0.72, 0.95)
                for arm = 0, ARM_N - 1 do
                    local a = self.a0 + arm * 360 / ARM_N
                    for k2 = 1, 2 do
                        local rr = r0 * (1 - (k2 - 1) * 0.22)
                        local o = New(path_bullet, star_small, 8,
                                CX + cos(a) * rr, CY + sin(a) * rr * 0.86, nil, 0, arm_star_path)
                        o.a = Angle(CX, CY, o.x, o.y)
                        o.r = Dist(CX, CY, o.x, o.y * 0.86)
                        o.w = STAR_W * self.dir * ran:Float(0.85, 1.18)
                        o.vr = STAR_VR * ran:Float(0.85, 1.2)
                        o.bound = false
                        o.spin = ran:Float(0, 360)
                    end
                end
            end
        end,
        render = function(self)
            --旋臂：一串沿螺线排布的光点
            for arm = 0, ARM_N - 1 do
                local a0 = self.a0 + arm * 360 / ARM_N
                for i = 0, 26 do
                    local f = i / 26
                    local r = f * ARM_LEN
                    local a = a0 + f * 46 * self.dir
                    local x, y = CX + cos(a) * r, CY + sin(a) * r * 0.86
                    local k = (1 - f) * 0.8 + 0.2
                    SetImageState("ball_light5", "mul+add", (90 + 120 * self.flash) * k, 180, 200, 255)
                    Render("ball_light5", x, y, 0, 2.2 + 3 * k, 2.2 + 3 * k)
                    if i % 5 == 0 then
                        draw_star(x, y, self.t * 3 + i * 20, 0.5 * k, 8, 200 * k)
                    end
                end
            end
            --星系核
            SetImageState("ball_huge6", "mul+add", 60 + 90 * self.flash, 210, 200, 255)
            Render("ball_huge6", CX, CY, 0, 5.5, 4.6)
            SetImageState("ball_light6", "mul+add", 200, 255, 250, 240)
            Render("ball_light6", CX, CY, 0, 4.2, 3.6)
        end,
    })

    do
        local card = boss.card.New("銀河の腕", 1, 2, 50, 1300)
        boss.card.add({ { card, "1a" } }, 22, "銀河の腕", 259)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, 2)
        end

        function card:init()
            self.__galaxy = New(class["th02_galaxy"])
        end

        function card:del()
            if IsValid(self.__galaxy) then
                object.RawDel(self.__galaxy)
            end
            self.__galaxy = nil
        end
    end
end

--============================
--[符卡5] 彗星の尾
--  彗星本体是 object，横着划过屏幕时一路掉星屑；星屑离体后不是直着
--  飞，而是被自己的"引力"拽出下坠弧线，边转边淡。彗星掠过中线时会
--  闪一下并炸开一小把星弹。彗星本体和星屑都由本卡的控制器持有。
--============================
do
    local COMET_V = 2.35          --彗星横掠速度
    local COMET_AMP = 58          --蛇行幅度
    local TRAIL_GAP = 3           --每隔几帧掉一颗星屑
    local TRAIL_V = 1.5           --星屑初速
    local TRAIL_G = 0.016         --星屑"重力"
    local TRAIL_TURN = 0.7        --星屑每帧转向
    local FLARE_AT = 150          --飞出多少帧后炸开
    local WAVE = { 0, 34, 68, 102 }  --一波彗星的起飞延迟
    local CYCLE = 300
    local BOSS_X, BOSS_Y = 0, 170

    ---星屑：下坠弧线
    local function tail_path(self, t)
        self.vy = self.vy - TRAIL_G
        self.vx = self.vx * 0.994
        self.rot = self.rot + TRAIL_TURN * self.dir
        self.hscale = max(0.25, 0.85 * (1 - t / 260))
        self.vscale = self.hscale
        if t > 260 then
            object.RawDel(self)
        end
    end

    ---彗星：横掠 + 掉星屑 + 打闪光
    class["th02_comet"] = Class(object, {
        init = function(self, dir, y0, delay)
            self.dir = dir
            self.y0 = y0
            self.wait = delay or 0
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 20
            self.bound, self.colli = false, false
            self.x = 250 * -dir
            self.y = y0
            self.flared = false
            self.t = 0
        end,
        frame = function(self)
            if self.wait > 0 then
                self.wait = self.wait - 1
                return
            end
            self.t = self.t + 1
            self.x = self.x + COMET_V * self.dir
            self.y = self.y0 + sin(self.t * 2.1) * COMET_AMP
            if abs(self.x) > 300 then
                object.RawDel(self)
                return
            end
            if self.t % TRAIL_GAP == 0 then
                local o = New(path_bullet, star_small, 8, self.x, self.y, nil, 0, tail_path)
                o.vx = -COMET_V * self.dir * 0.5 + ran:Float(-0.4, 0.4)
                o.vy = ran:Float(-0.5, 0.9)
                o.dir = self.dir * ran:Float(0.6, 1.4)
                o.bound = false
            end
            if not self.flared and self.t == FLARE_AT then
                self.flared = true
                PlaySound("kira00", 0.09, 0, false)
                for a in sp.math.AngleIterator(ran:Float(0, 360), 9) do
                    NewSimpleBullet(star_small, 8, self.x, self.y, 2.1, a, false, 3.4).bound = false
                end
            end
        end,
        render = function(self)
            if self.wait > 0 then
                return
            end
            local k = self.flared and 1 or 0.75
            SetImageState("ball_light6", "mul+add", 210 * k, 255, 240, 210)
            Render("ball_light6", self.x, self.y, 0, 6.2 * k, 6.2 * k)
            draw_star(self.x, self.y, self.t * 9, 2.1, 7, 255)
            draw_star(self.x, self.y, -self.t * 6, 1.3, 8, 220)
        end,
    })

    ---彗星群：按节奏一波波放彗星
    class["th02_comet_sys"] = Class(object, {
        init = function(self)
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
            self.comets = {}
            self.n = 0
        end,
        frame = function(self)
            self.n = self.n + 1
            if self.n % CYCLE == 1 then
                local dir = ran:Sign()
                local y0 = ran:Float(-130, 150)
                for i = 1, #WAVE do
                    local c = New(class["th02_comet"], dir, y0 + ran:Float(-24, 24), WAVE[i])
                    c.sys = self
                    self.comets[#self.comets + 1] = c
                end
            end
            local cs = self.comets
            for i = #cs, 1, -1 do
                if not IsValid(cs[i]) then
                    table.remove(cs, i)
                end
            end
        end,
        render = function(self) end,
        del = function(self)
            for i = 1, #self.comets do
                if IsValid(self.comets[i]) then
                    object.RawDel(self.comets[i])
                end
            end
            self.comets = {}
        end,
    })

    do
        local card = boss.card.New("彗星の尾", 1, 2, 45, 1200)
        boss.card.add({ { card, "1a" } }, 22, "彗星の尾", 260)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, 2)
        end

        function card:init()
            self.__sys = New(class["th02_comet_sys"])
        end

        function card:del()
            if IsValid(self.__sys) then
                object.RawDel(self.__sys)
            end
            self.__sys = nil
        end
    end
end

--============================
--[符卡6] 超新星
--  核先吸气一样地涨大（顺手把场上的星弹往中心拽一点），然后塌缩、
--  炸出一圈「冲击星」。冲击星不是匀速外飞：外扩->刹住->悬停->
--  倒着飞回来，是它自己的类在按阶段算速度。
--============================
do
    local CHARGE = 78             --蓄力帧数
    local RING_N = 12             --每次炸几波
    local RING_GAP = 12           --波间隔
    local SHOCK_V0 = 5.4          --冲击星初速
    local SHOCK_OUT = 46          --外扩帧数
    local SHOCK_HOLD = 34         --悬停帧数
    local SHOCK_BACK = 40         --回收帧数
    local PULL = 0.05             --蓄力时把场上子弹往中心拽的力度
    local CYCLE = 280
    local BOSS_X, BOSS_Y = 0, 130

    ---冲击星：外扩 -> 停 -> 倒飞
    class["th02_shock"] = Class(bullet, {
        init = function(self, x, y, a, col, v0)
            bullet.init(self, ball_big, col, false, true)
            self.x, self.y, self.rot = x, y, a
            self.spd = v0 or SHOCK_V0
            self.ang = a
            self.bound = false
            SetV(self, self.spd, self.ang, false)
        end,
        frame = function(self)
            bullet.frame(self)
            local t = self.timer
            local spd
            if t <= SHOCK_OUT then
                spd = SHOCK_V0 * (1 - t / SHOCK_OUT)
            elseif t <= SHOCK_OUT + SHOCK_HOLD then
                spd = 0
            elseif t <= SHOCK_OUT + SHOCK_HOLD + SHOCK_BACK then
                local f = (t - SHOCK_OUT - SHOCK_HOLD) / SHOCK_BACK
                spd = -SHOCK_V0 * 0.85 * f
            else
                object.RawDel(self)
                return
            end
            SetV(self, spd, self.ang, false)
            self.hscale = 0.9 + 0.35 * sin(t * 12)
            self.vscale = self.hscale
            self.depth = Forbid(1 - t / 200, 0.25, 1)
        end,
        render = function(self)
            SetImageState("ball_light5", "mul+add", 127.5 * self.depth, 255, 220, 170)
            Render("ball_light5", self.x, self.y, 0, 6.5, 6.5)
            bullet.render(self)
        end,
    })

    ---核：蓄力 -> 塌缩 -> 爆发
    class["th02_core"] = Class(object, {
        init = function(self)
            self.group, self.layer = GROUP.GHOST, LAYER.TOP
            self.bound, self.colli = false, false
            self.t = 0
            self.size = 1
            self.flash = 0
        end,
        frame = function(self)
            self.t = self.t + 1
            local k = self.t % CYCLE
            if k < CHARGE then
                --蓄力：涨大 + 把场上的星弹往中心拖
                self.size = 1 + 2.6 * (k / CHARGE)
                local cx, cy = 0, 0
                object.BulletDo(function(o)
                    local dx, dy = cx - o.x, cy - o.y
                    local d = max(24, sqrt(dx * dx + dy * dy))
                    o.vx = o.vx + dx / d * PULL
                    o.vy = o.vy + dy / d * PULL
                end)
            else
                local e = k - CHARGE
                if e == 0 then
                    self.flash = 1
                    PlaySound("kira00", 0.13, 0, true)
                    for ring = 1, RING_N do
                        local n = 8 + ring
                        local delay = (ring - 1) * RING_GAP
                        local col = (ring % 2 == 0) and 6 or 4
                        task.New(self, function()
                            task.Wait(delay)
                            if not IsValid(self) then
                                return
                            end
                            local a0 = ran:Float(0, 360)
                            for a in sp.math.AngleIterator(a0, n) do
                                New(class["th02_shock"], self.x, self.y, a, col,
                                        SHOCK_V0 * (0.85 + ring * 0.03))
                            end
                        end)
                    end
                end
                self.size = 1 + 1.2 * (1 - min(1, e / 60))
            end
            self.flash = max(0, self.flash - 0.02)
        end,
        render = function(self)
            local s = self.size
            SetImageState("ball_huge6", "mul+add", 40 + 120 * self.flash, 255, 200, 150)
            Render("ball_huge6", self.x, self.y, 0, 3.2 * s, 3.2 * s)
            SetImageState("ball_light6", "mul+add", 200, 255, 250, 235)
            Render("ball_light6", self.x, self.y, 0, 2.4 * s, 2.4 * s)
            SetImageState("ball_light5", "mul+add", 255, 255, 255, 255)
            Render("ball_light5", self.x, self.y, 0, 1.1 * s, 1.1 * s)
        end,
    })

    do
        local card = boss.card.New("超新星", 1, 2, 50, 1300)
        boss.card.add({ { card, "1a" } }, 22, "超新星", 261)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, 2)
        end

        function card:init()
            local b = self
            self.__core = New(class["th02_core"])
            --核始终待在 boss 身上
            task.New(b, function()
                while true do
                    if IsValid(b.__core) then
                        b.__core.x, b.__core.y = b.x, b.y
                    end
                    task.Wait()
                end
            end)
        end

        function card:del()
            if IsValid(self.__core) then
                object.RawDel(self.__core)
            end
            self.__core = nil
        end
    end
end

--============================
--[符卡7] 黒洞の引力
--  中心挂一个黑洞：它按周期甩出一圈「绕行弹」，绕行弹的加速度每帧
--  都指向黑洞（a = G * 单位方向），所以它们走的是被拉扁的椭圆轨道，
--  越靠近就越快。掉进视界、或者被甩出很远的会被回收。
--============================
do
    local G = 0.42                --引力强度
    local LAUNCH_R = 190          --甩出半径
    local LAUNCH_V = 2.05         --甩出的切向速度
    local BURST_GAP = 74          --多久甩一圈
    local BURST_N0 = 5            --第一圈几颗
    local BURST_DN = 1            --每圈多几颗
    local HOLE_R = 26             --视界半径
    local ESCAPE_R = 430          --飞出这个半径就回收
    local MAX_N = 34              --一圈最多几颗
    local BOSS_X, BOSS_Y = 0, 70

    ---绕行弹：加速度始终指向黑洞
    class["th02_orbiter"] = Class(bullet, {
        init = function(self, x, y, a, col, v)
            bullet.init(self, ball_mid, col, false, true)
            self.x, self.y, self.rot = x, y, a
            self.bound = false
            self.omiga = 6
            SetV(self, v, a, false)
        end,
        frame = function(self)
            bullet.frame(self)
            local h = self.hole
            if not (h and IsValid(h)) then
                --黑洞没了就顺着现在的速度飞走（兜底回收）
                if self.x * self.x + self.y * self.y > ESCAPE_R * ESCAPE_R then
                    object.RawDel(self)
                end
                return
            end
            local dx, dy = h.x - self.x, h.y - self.y
            local d = sqrt(dx * dx + dy * dy)
            if d < HOLE_R then
                object.RawDel(self)
                return
            end
            if d > ESCAPE_R then
                object.RawDel(self)
                return
            end
            --向心加速度（离得越远越弱，避免把远端的弹直接拉飞）
            local g = G * Forbid(150 / d, 0.25, 1.6)
            self.ax = dx / d * g
            self.ay = dy / d * g
            self._a = 255
        end,
        render = function(self)
            SetImageState("ball_light5", "mul+add", 120, 190, 210, 255)
            Render("ball_light5", self.x, self.y, 0, 4.4, 4.4)
            bullet.render(self)
        end,
    })

    ---黑洞本体
    class["th02_hole"] = Class(object, {
        init = function(self)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 20
            self.bound, self.colli = false, false
            self.t = 0
            self.n = BURST_N0
            self.orbiters = {}
        end,
        frame = function(self)
            self.t = self.t + 1
            if self.t % BURST_GAP == 1 then
                local a0 = ran:Float(0, 360)
                local spin = ran:Sign()
                local n = min(MAX_N, self.n)
                self.n = self.n + BURST_DN
                for a in sp.math.AngleIterator(a0, n) do
                    local ox = self.x + cos(a) * LAUNCH_R
                    local oy = self.y + sin(a) * LAUNCH_R
                    local o = New(class["th02_orbiter"],
                            ox, oy,
                            a + 90 * spin - 90,
                            (n % 2 == 0) and 4 or 3,
                            LAUNCH_V * ran:Float(0.92, 1.1))
                    o.hole = self
                    self.orbiters[#self.orbiters + 1] = o
                end
                PlaySound("tan00", 0.06, 0, false)
            end
            local os = self.orbiters
            for i = #os, 1, -1 do
                if not IsValid(os[i]) then
                    table.remove(os, i)
                end
            end
        end,
        render = function(self)
            local t = self.timer
            --吸积盘：一圈绕转的细线
            for i = 1, 34 do
                local a1 = t * 4 + i * 360 / 34
                local a2 = a1 + 360 / 34
                local r1 = 34 + 5 * sin(t * 0.08 + i)
                thin_line(self.x + cos(a1) * r1, self.y + sin(a1) * r1,
                        self.x + cos(a2) * r1, self.y + sin(a2) * r1,
                        90 + 80 * sin(t * 0.15 + i), 200, 170, 255, 0.16)
            end
            SetImageState("ball_huge6", "mul+add", 110, 150, 120, 235)
            Render("ball_huge6", self.x, self.y, 0, 3.4, 3.4)
            --视界（涂黑）
            SetImageState("ball_huge6", "", 255, 6, 4, 14)
            Render("ball_huge6", self.x, self.y, 0, 2.1, 2.1)
        end,
        del = function(self)
            for i = 1, #self.orbiters do
                if IsValid(self.orbiters[i]) then
                    object.RawDel(self.orbiters[i])
                end
            end
            self.orbiters = {}
        end,
    })

    do
        local card = boss.card.New("黒洞の引力", 1, 2, 50, 1300)
        boss.card.add({ { card, "1a" } }, 22, "黒洞の引力", 262)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, 2)
        end

        function card:init()
            local b = self
            self.__hole = New(class["th02_hole"])
            task.New(b, function()
                while true do
                    if IsValid(b.__hole) then
                        b.__hole.x, b.__hole.y = b.x, b.y
                    end
                    task.Wait()
                end
            end)
        end

        function card:del()
            if IsValid(self.__hole) then
                object.RawDel(self.__hole)
            end
            self.__hole = nil
        end
    end
end

--============================
--[符卡8] 流星群
--  不再是「从天顶匀速砸下来的直线雨」：
--    · 每颗流星都在摆尾——横向速度按正弦来回甩、纵向速度一路加速，
--      飞出来是一条条抖动的曲线；
--    · 流星用 object.smear_* 自己拖出长长的加算尾巴（不是引擎的弹幕拖影）；
--    · 落到屏幕下缘或到寿时炸开，碎片沿螺旋线旋出去，线速度与角速度
--      都慢慢衰减，所以是一圈花环而不是直线放射；
--    · 放流星的「云」在屏幕上方走李萨如曲线，云本身也在飘。
--  boss 另外每隔一会儿把一撮星弹按螺旋甩出来（螺旋越飞越直）。
--============================
do
    local CLOUD_Y = 232           --云悬浮的高度（y+ 是上方）
    local CLOUD_AX, CLOUD_AY = 154, 34
    local CLOUD_W1, CLOUD_W2 = 0.011, 0.019
    local WAVE_GAP = 78           --云喷发的间隔
    local WAVE_N = 5              --一次喷几颗流星
    local STRAY_N = 3             --另外从天顶随机位置掉几颗
    local M_V0, M_ACC, M_VMAX = 1.1, 0.05, 7.4
    local M_SWIRL, M_SWF = 50, 0.05
    local M_LIFE = 250            --流星寿命
    local M_BURST = 7             --炸开的碎片数
    local SHARD_LIFE = 170
    local SWARM_GAP = 30          --boss 甩星弹的间隔
    local SWARM_V = 2.4
    local BOSS_X, BOSS_Y = 0, 196

    ---炸开后的碎片：向外旋出，越转越慢
    local function shard_path(s, t)
        s.dr = s.dr * 0.972
        s.dw = s.dw * 0.986
        s.rad = s.rad + s.dr
        s.ang = s.ang + s.dw
        s.x = s.cx + cos(s.ang) * s.rad
        s.y = s.cy + sin(s.ang) * s.rad
        s.rot = s.ang + 90
    end

    ---boss 甩出来的星弹：绕一圈螺旋，越飞越直
    local function swarm_path(s, t)
        s.dr = s.dr * 0.996
        s.dw = s.dw * 0.994
        s.rad = s.rad + s.dr
        s.ang = s.ang + s.dw
        s.x = s.ox + cos(s.ang) * s.rad
        s.y = s.oy + sin(s.ang) * s.rad
        s.rot = s.ang + 90
    end

    ---炸开的处理：写成局部函数而不是类方法，因为引擎里
    ---self.xxx 是对对象的 rawget，类上定义的方法取不到
    local function meteor_burst(self)
        local cx, cy = self.x, self.y
        for i in sp.math.AngleIterator(ran:Float(0, 360), M_BURST) do
            local o = New(path_bullet, star_small, 8, cx, cy, nil, 0, shard_path)
            o.cx, o.cy = cx, cy
            o.rad = 5
            o.dr = ran:Float(2.0, 4.2)
            o.ang = i
            o.dw = ran:Float(-3.4, 3.4)
            o.max_life = SHARD_LIFE
            o.bound = false
        end
        PlaySound("tan00", 0.05, self.x / 256, false)
        object.RawDel(self)
    end

    ---流星本体：摆尾 + 加速 + 拖影，落地炸开
    class["th02_meteor"] = Class(bullet, {
        init = function(self, x, y, a0, col)
            bullet.init(self, star_big, col, false, true)
            --⚠ 这一行是**必需的**：`bullet.init` 只设 `self.class` / `self.imgclass`，
            --  `self.img` 是**弹样式自己的 init** 设的（bulletStyle.lua:67
            --  `self.img = img .. int(index)`）。这个类是直接继承 `bullet`、
            --  绕过样式 init 的，所以不补这一行 `self.img` 就是 nil，
            --  下面 `smear_render` 里的 `SetImageState(nil, ...)` 会崩。
            self.img = "star_big" .. int(col)
            self.x, self.y = x, y
            self.a0 = a0
            self.ph = ran:Float(0, 360)
            self.sw = M_SWIRL * ran:Float(0.35, 1)
            self.w = M_SWF * ran:Float(0.65, 1.45)
            self.v0 = M_V0 * ran:Float(0.75, 1.3)
            self.acc = M_ACC * ran:Float(0.65, 1.4)
            self.spin = ran:Float(-11, 11)
            self.life = M_LIFE * ran:Float(0.8, 1.15)
            self.bound = false
        end,
        frame = function(self)
            bullet.frame(self)
            local t = self.timer
            --横向来回甩、纵向一路加速：轨道是弯的
            local a = self.a0 + self.sw * sin(t * self.w + self.ph)
            SetV(self, min(M_VMAX, self.v0 + t * self.acc), a, false)
            self.rot = self.rot + self.spin
            object.smear_add(self, 190)
            object.smear_frame(self, 15)
            if t > self.life or self.y < -276 then
                meteor_burst(self)
            end
        end,
        render = function(self)
            object.smear_render(self, "add+alpha", { 168, 148, 255 })
            bullet.render(self)
        end,
    })

    ---云：在屏幕上方走李萨如曲线，一路吐流星
    class["th02_meteor_cloud"] = Class(object, {
        init = function(self)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 16
            self.bound, self.colli = false, false
            self.pulse = 0
        end,
        frame = function(self)
            local t = self.timer
            self.x = CLOUD_AX * sin(t * CLOUD_W1)
            self.y = CLOUD_Y + CLOUD_AY * sin(t * CLOUD_W2 + 1.2)
            if t % WAVE_GAP == 40 then
                self.pulse = 1
                for i = 1, WAVE_N do
                    New(class["th02_meteor"], self.x + ran:Float(-76, 76),
                            self.y + ran:Float(-26, 26),
                            -90 + ran:Float(-34, 34),
                            (i % 2 == 0) and 8 or 6)
                end
                for _ = 1, STRAY_N do
                    New(class["th02_meteor"], ran:Float(-190, 190), 292 + ran:Float(0, 40),
                            -90 + ran:Float(-16, 16), 8)
                end
                PlaySound("kira00", 0.07, 0, false)
            end
            self.pulse = max(0, self.pulse - 0.03)
        end,
        render = function(self)
            local s = 3.6 + 1.3 * self.pulse
            SetImageState("ball_huge6", "mul+add", 60 + 70 * self.pulse, 150, 112, 226)
            Render("ball_huge6", self.x, self.y, 0, s, s * 0.55)
            for i = 1, 5 do
                local a = self.timer * 2.4 + i * 72
                draw_star(self.x + cos(a) * 46, self.y + sin(a) * 24,
                        self.timer * 6 + i * 30, 0.7, 8, 170)
            end
        end,
    })

    do
        local card = boss.card.New("流星群", 1, 2, 50, 1300)
        boss.card.add({ { card, "1a" } }, 22, "流星群", 263)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, 2)
        end

        function card:init()
            local b = self
            self.__cloud = New(class["th02_meteor_cloud"])
            --boss 自己的螺旋星弹
            task.New(b, function()
                while true do
                    local a0 = ran:Float(0, 360)
                    for i in sp.math.AngleIterator(a0, 3) do
                        local o = New(path_bullet, star_small, 8, b.x, b.y, nil, 0, swarm_path)
                        o.ox, o.oy = b.x, b.y
                        o.rad, o.ang = 14, i
                        o.dr, o.dw = SWARM_V * ran:Float(0.85, 1.15), ran:Float(2.4, 4.2) * ran:Sign()
                        o.max_life = 260
                        o.bound = false
                    end
                    PlaySound("tan00", 0.05, 0, false)
                    task.Wait(SWARM_GAP)
                end
            end)
        end

        function card:del()
            if IsValid(self.__cloud) then
                object.RawDel(self.__cloud)
            end
            self.__cloud = nil
        end
    end
end

--============================
--[符卡9] 星雲のゆりかご
--  三口「摇篮」绕着中心在椭圆轨道上转，一边转一边呼吸；
--  每口摇篮身边挂着一圈星尘，星尘先绕着摇篮打转（椭圆轨道），
--  到寿以后脱开摇篮、被自己的切向速度带着拐弯飘走。
--  摇篮每隔一段时间孵化一次：甩出一圈螺旋外扩的星弹，
--  同时和旁边的摇篮拉一条发光的细线（摇篮之间连成摇篮网）。
--  boss 自己则一圈圈吐出「摇篮曲」——螺旋呼吸着往外飘的星弹。
--============================
do
    local CRADLE_N = 3
    local CRADLE_R = 122          --摇篮绕中心公转半径
    local CRADLE_SPIN = 0.34      --公转角速度（度/帧）
    local CRADLE_Y0 = 26
    local HATCH_GAP = 196         --孵化间隔
    local HATCH_N = 11            --孵化时甩出的星弹数
    local SHELL_LIFE = 200
    local DUST_EVERY = 13         --每几帧挂一颗星尘
    local DUST_R = 30
    local LULLABY_GAP = 66
    local BOSS_X, BOSS_Y = 0, 122

    ---孵化甩出的星弹：螺旋外扩，线速度衰减
    local function shell_path(s, t)
        s.dr = max(0.35, s.dr * 0.988)
        s.dw = s.dw * 0.992
        s.rad = s.rad + s.dr
        s.ang = s.ang + s.dw
        s.x = s.cx + cos(s.ang) * s.rad
        s.y = s.cy + sin(s.ang) * s.rad
        s.rot = s.ang + 90
    end

    ---摇篮曲：螺旋半径一路涨、角速度一路衰减
    local function lullaby_path(s, t)
        s.rad = s.rad + s.dr
        s.dr = max(0.45, s.dr * 0.99)
        s.ang = s.ang + s.dw * Forbid(1 - t / 230, 0.22, 1)
        s.x = s.ox + cos(s.ang) * s.rad
        s.y = s.oy + sin(s.ang) * s.rad
        s.rot = s.ang + 90
    end

    ---星尘：先绕着摇篮转，到寿后拐着弯飘走
    class["th02_dust"] = Class(bullet, {
        init = function(self, cradle, a0)
            bullet.init(self, ball_light, 3, false, true)
            self.cradle = cradle
            self.orbA = a0
            self.orbR = DUST_R * ran:Float(0.55, 1)
            self.ow = ran:Float(1.5, 3.1) * ran:Sign()
            self.life = ran:Int(80, 150)
            self.bound = false
            self.x, self.y = cradle.x, cradle.y
            self.a, self.b = 3.6, 3.6
            self.hscale, self.vscale = 0.72, 0.72
        end,
        frame = function(self)
            bullet.frame(self)
            local c = self.cradle
            if not IsValid(c) then
                object.RawDel(self)
                return
            end
            local t = self.timer
            if t < self.life then
                --挂在摇篮上的椭圆轨道
                self.orbA = self.orbA + self.ow
                self.orbR = self.orbR + 0.42 * sin(t * 0.09)
                self.x = c.x + cos(self.orbA) * self.orbR
                self.y = c.y + sin(self.orbA) * self.orbR * 0.7
                self.rot = self.orbA + 90
            else
                local k = t - self.life
                if k == 0 then
                    self.ow = self.ow * 0.5
                    SetV(self, 1.1, self.orbA, false)
                end
                --切向速度拖着它拐弯，慢慢飘淡
                self.ow = self.ow * 0.985
                local v, a = GetV(self)
                SetV(self, min(4.4, v + 0.022), a + self.ow, false)
                self.hscale, self.vscale = 0.55, 0.55
                self.a, self.b = 2.9, 2.9
                if k > 230 then
                    object.RawDel(self)
                end
            end
        end,
    })

    ---摇篮：椭圆轨道公转 + 呼吸，按时孵化
    class["th02_cradle"] = Class(object, {
        init = function(self, i, n)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET + 10
            self.bound, self.colli = false, false
            self.index = i
            self.count = n
            self.ang = i * 360 / n
            self.spin = ran:Float(0.5, 1.1) * ((i % 2 == 0) and 1 or -1)
            self.rot = ran:Float(0, 360)
            self.scale = 0.6
            self.flash = 0
            self.dust = {}
            self.tick = ran:Int(0, 40)
        end,
        frame = function(self)
            local t = self.timer
            self.ang = self.ang + CRADLE_SPIN
            self.x = cos(self.ang) * CRADLE_R
            self.y = sin(self.ang) * CRADLE_R * 0.62 + CRADLE_Y0
            self.rot = self.rot + self.spin
            --呼吸
            self.scale = 0.72 + 0.28 * sin(t * 0.06 + self.index * 50)
            --挂星尘
            self.tick = self.tick + 1
            if self.tick >= DUST_EVERY then
                self.tick = 0
                local d = New(class["th02_dust"], self, ran:Float(0, 360))
                self.dust[#self.dust + 1] = d
            end
            local ds = self.dust
            for i = #ds, 1, -1 do
                if not IsValid(ds[i]) then
                    table.remove(ds, i)
                end
            end
            --孵化
            if t % HATCH_GAP == self.index * 30 then
                self.flash = 1
                for i in sp.math.AngleIterator(ran:Float(0, 360), HATCH_N) do
                    local o = New(path_bullet, star_small, 8, self.x, self.y, nil, 0, shell_path)
                    o.cx, o.cy = self.x, self.y
                    o.rad = 6
                    o.dr = ran:Float(1.8, 3.4)
                    o.ang = i
                    o.dw = ran:Float(-2.2, 2.2)
                    o.max_life = SHELL_LIFE
                    o.bound = false
                end
                PlaySound("tan00", 0.06, self.x / 256, false)
            end
            self.flash = max(0, self.flash - 0.02)
        end,
        render = function(self)
            local t = self.timer
            local s = self.scale
            --和旁边摇篮的连线（摇篮网）
            local mate = self.mate
            if mate and IsValid(mate) then
                thin_line(self.x, self.y, mate.x, mate.y, 30 + 30 * self.flash, 150, 190, 255, 0.09)
            end
            --发光的核
            SetImageState("ball_light6", "mul+add", 130 + 90 * self.flash, 200, 190, 255)
            Render("ball_light6", self.x, self.y, 0, 4.6 * s, 4.6 * s)
            --两层转动的细圆
            for ring = 1, 2 do
                local rr = DUST_R * (ring == 1 and 1.15 or 0.7) * s
                local seg = 16 + ring * 4
                local dir = (ring == 1) and 1 or -1
                for i = 1, seg do
                    local a1 = self.rot * dir * 1.4 + (i - 1) * 360 / seg
                    local a2 = a1 + 360 / seg
                    thin_line(self.x + cos(a1) * rr, self.y + sin(a1) * rr * 0.72,
                            self.x + cos(a2) * rr, self.y + sin(a2) * rr * 0.72,
                            (60 + 60 * self.flash) * (3 - ring), 176, 196, 255, 0.13)
                end
            end
        end,
        del = function(self)
            local ds = self.dust or {}
            for i = 1, #ds do
                if IsValid(ds[i]) then
                    object.RawDel(ds[i])
                end
            end
            self.dust = {}
        end,
    })

    do
        local card = boss.card.New("星雲のゆりかご", 1, 2, 55, 1350)
        boss.card.add({ { card, "1a" } }, 22, "星雲のゆりかご", 264)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, 2)
        end

        function card:init()
            local b = self
            local cradles = {}
            for i = 1, CRADLE_N do
                cradles[i] = New(class["th02_cradle"], i, CRADLE_N)
            end
            for i = 1, CRADLE_N do
                cradles[i].mate = cradles[i % CRADLE_N + 1]
            end
            self.__cradles = cradles
            --摇篮曲
            task.New(b, function()
                while true do
                    local a0 = ran:Float(0, 360)
                    local dw = ran:Float(1.4, 2.2) * ran:Sign()
                    for i in sp.math.AngleIterator(a0, 12) do
                        local o = New(path_bullet, star_small, 6, b.x, b.y, nil, 0, lullaby_path)
                        o.ox, o.oy = b.x, b.y
                        o.rad, o.ang = 14, i
                        o.dr, o.dw = 2.2, dw
                        o.max_life = 290
                        o.bound = false
                    end
                    PlaySound("tan00", 0.05, 0, false)
                    task.Wait(LULLABY_GAP)
                end
            end)
        end

        function card:del()
            local cs = self.__cradles or {}
            for i = 1, #cs do
                if IsValid(cs[i]) then
                    object.RawDel(cs[i])
                end
            end
            self.__cradles = nil
        end
    end
end

--============================
--[符卡10] 終焉の星図（终符）
--  一张巨大的「星图」悬在场上：三层转动的圆环 + 十二根辐条 +
--  七颗节点星，节点之间用细线连成星座。
--    · 节点星在椭圆轨道上公转，各自按自己的节拍射出一颗会拐弯的
--      星弹（角速度一路上涨、速度略微加速，所以是弧线）；
--    · 每隔一段时间，某颗节点星会沿随机方向甩出一道扫动的裂光
--      （laser 子类：半开 → 全开 → 收束，全程一边扫一边转）；
--    · 星图每隔一阵会「合拢」一次：半径收缩到一点、辐条加速旋转，
--      然后在中心炸开一大圈星弹，再慢慢回弹张开。
--  boss 自己放四条臂的螺旋星弹，和星图的节奏错开。
--============================
do
    local R0 = 168                --星图半径
    local SPIN = 0.30             --整体旋转（度/帧）
    local NODE_N = 7
    local FIRE_GAP = 46           --节点开火间隔
    local SHOT_W = 3.2            --星弹每帧转角
    local SWEEP_GAP = 168         --裂光间隔
    local COLLAPSE_LEN = 130      --合拢用时
    local REBOUND_LEN = 210       --回弹用时
    local CYCLE = 1500            --合拢周期
    local ARM_GAP = 11
    local ARM_V = 3.0
    local BOSS_X, BOSS_Y = 0, 176
    local CX, CY = 0, 28          --星图圆心

    ---boss 的四条臂：螺旋外扩，越飞越直
    local function arm_path(s, t)
        s.dr = s.dr * 0.994
        s.rad = s.rad + s.dr
        s.ang = s.ang + s.dw
        s.x = s.ox + cos(s.ang) * s.rad
        s.y = s.oy + sin(s.ang) * s.rad
        s.rot = s.ang + 90
    end

    ---节点射出的星弹：一边加速一边打弯
    class["th02_chart_shot"] = Class(bullet, {
        init = function(self, x, y, a0, v0)
            bullet.init(self, star_small, 8, false, true)
            self.x, self.y = x, y
            self.ang = a0
            self.v = v0
            self.rot = a0
            self.dv = 0.014
            self.dw = 0
            self.bound = false
        end,
        frame = function(self)
            bullet.frame(self)
            local t = self.timer
            self.v = max(0.45, self.v + self.dv - (t > 120 and 0.02 or 0))
            self.ang = self.ang + self.dw
            SetV(self, self.v, self.ang, false)
            self.rot = self.ang + 90
            if t > 280 or self.x * self.x + self.y * self.y > 560 * 560 then
                object.RawDel(self)
            end
        end,
    })

    ---节点星：在椭圆轨道上公转，按节拍开火
    class["th02_chart_node"] = Class(object, {
        init = function(self, chart, i, n)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 20
            self.bound, self.colli = false, false
            self.chart = chart
            self.index = i
            self.count = n
            self.phase0 = i * 360 / n
            self.er = ran:Float(0.55, 1.0)
            self.spin = ran:Float(0.8, 1.8) * (((i % 2 == 0)) and 1 or -1)
            self.tick = ran:Int(0, FIRE_GAP - 1)
            self.flash = 0
        end,
        frame = function(self)
            local c = self.chart
            if not IsValid(c) then
                object.RawDel(self)
                return
            end
            local a = c.rot + self.phase0
            local r = c.rad * self.er
            self.x = c.x + cos(a) * r
            self.y = c.y + sin(a) * r * 0.68
            self.rot = self.rot + self.spin
            self.tick = self.tick + 1
            if self.tick >= FIRE_GAP then
                self.tick = 0
                self.flash = 1
                local o = New(class["th02_chart_shot"], self.x, self.y,
                        ran:Float(0, 360), ran:Float(1.5, 2.5))
                o.dw = SHOT_W * ran:Sign() * ran:Float(0.6, 1.35)
                o.dv = 0.014 * ran:Float(0.5, 1.6)
            end
            self.flash = max(0, self.flash - 0.05)
        end,
        render = function(self)
            local s = 2.6 + 1.8 * self.flash
            SetImageState("ball_light5", "mul+add", 200, 220, 236, 255)
            Render("ball_light5", self.x, self.y, 0, s, s)
            draw_star(self.x, self.y, self.rot, 1.2 + 0.6 * self.flash, 8, 240)
        end,
    })

    ---裂光：laser 子类，锚在节点上一边转一边扫
    class["th02_rift"] = Class(laser, {
        init = function(self, node, a0, dir)
            laser.init(self, 4, node.x, node.y, a0, 0, 0, 0, 12, 0, 0)
            self.bound = false
            self.node = node
            self.a0 = a0
            self.dir = dir
            self.spd = ran:Float(4.2, 7.0)
            task.New(self, function()
                laser._TurnHalfOn(self, 34, true)
                laser._TurnOn(self, 10, true)
                task.Wait(34)
                laser._TurnOff(self, 24, true)
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            self.class.base.frame(self)
            local n = self.node
            if n and IsValid(n) then
                self.x, self.y = n.x, n.y
                self.rot = self.a0 + self.dir * self.timer * self.spd
            else
                object.RawDel(self)
            end
        end,
        render = function(self)
            if self.alpha <= 0.01 then
                return
            end
            local a, w = self.alpha, self.w
            for i = 1, 3 do
                local k = (i == 1) and 1 or ((i == 2) and 0.55 or 0.28)
                SetImageState("white", "mul+add", 130 * a * k, 186, 170, 255)
                Render("white", self.x + cos(self.rot) * 108,
                        self.y + sin(self.rot) * 108,
                        self.rot, 216 / 16, w * k / 16)
            end
        end,
    })

    ---星图本体
    class["th02_chart"] = Class(object, {
        init = function(self)
            self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 24
            self.bound, self.colli = false, false
            self.x, self.y = CX, CY
            self.rot = ran:Float(0, 360)
            self.rad = R0
            self.burst_done = false
            self.rifts = {}
            self.nodes = {}
            for i = 1, NODE_N do
                self.nodes[i] = New(class["th02_chart_node"], self, i, NODE_N)
            end
        end,
        frame = function(self)
            local t = self.timer
            local tt = (t - 900) % CYCLE
            if t >= 900 then
                if self.tt_prev and tt < self.tt_prev then
                    --星图合拢
                    self.burst_done = false
                    PlaySound("kira00", 0.1, 0, false)
                end
                self.tt_prev = tt
            end
            local k = Forbid(tt / COLLAPSE_LEN, 0, 1)
            local back = Forbid((tt - COLLAPSE_LEN) / REBOUND_LEN, 0, 1)
            self.rad = R0 * ((1 - 0.94 * k) * (1 - back) + back)
            self.rot = self.rot + SPIN * (1 + 4 * k)
            if t >= 900 and k >= 1 and not self.burst_done then
                self.burst_done = true
                Newcharge_out(self.x, self.y, 210, 190, 255)
                for i in sp.math.AngleIterator(ran:Float(0, 360), 26) do
                    NewSimpleBullet(star_big, 4, self.x, self.y, 2.1, i, false, 2.6).bound = false
                end
                PlaySound("kira00", 0.12, 0, false)
            end
            --裂光：自己收着，符卡结束时一并撤掉
            if t % SWEEP_GAP == 60 then
                local n = self.nodes[ran:Int(1, #self.nodes)]
                if IsValid(n) then
                    self.rifts[#self.rifts + 1] = New(class["th02_rift"], n,
                            ran:Float(0, 360), ran:Sign())
                end
            end
            local rs = self.rifts
            for i = #rs, 1, -1 do
                if not IsValid(rs[i]) then
                    table.remove(rs, i)
                end
            end
        end,
        render = function(self)
            local R = self.rad
            --三层转动的圆环
            for ring = 1, 3 do
                local rr = R * (0.45 + 0.28 * ring)
                local seg = 26 + ring * 4
                local dir = (ring % 2 == 0) and -1 or 1
                for i = 1, seg do
                    local a1 = self.rot * dir + (i - 1) * 360 / seg
                    local a2 = a1 + 360 / seg
                    thin_line(self.x + cos(a1) * rr, self.y + sin(a1) * rr * 0.68,
                            self.x + cos(a2) * rr, self.y + sin(a2) * rr * 0.68,
                            34 + 16 * ring, 138, 132, 238, 0.1)
                end
            end
            --十二根辐条
            for i = 1, 12 do
                local a = self.rot * 0.5 + i * 30
                local r0, r1 = R * 0.26, R * 1.02
                thin_line(self.x + cos(a) * r0, self.y + sin(a) * r0 * 0.68,
                        self.x + cos(a) * r1, self.y + sin(a) * r1 * 0.68,
                        24, 118, 150, 238, 0.08)
            end
            --节点之间连成星座
            local ns = self.nodes
            for i = 1, #ns do
                local a = ns[i]
                local b = ns[i % #ns + 1]
                if IsValid(a) and IsValid(b) then
                    thin_line(a.x, a.y, b.x, b.y, 46, 176, 186, 255, 0.1)
                end
            end
        end,
        del = function(self)
            local ns = self.nodes or {}
            for i = 1, #ns do
                if IsValid(ns[i]) then
                    object.RawDel(ns[i])
                end
            end
            local rs = self.rifts or {}
            for i = 1, #rs do
                if IsValid(rs[i]) then
                    object.RawDel(rs[i])
                end
            end
            self.nodes = {}
            self.rifts = {}
        end,
    })

    do
        local card = boss.card.New("終焉の星図", 1, 2, 60, 1600)
        boss.card.add({ { card, "1a" } }, 22, "終焉の星図", 265)

        function card:before()
            task.MoveTo(BOSS_X, BOSS_Y, 60, 2)
        end

        function card:init()
            local b = self
            self.__chart = New(class["th02_chart"])
            --boss 的四条臂，节奏和星图错开
            task.New(b, function()
                task.Wait(40)
                local a0 = ran:Float(0, 360)
                while true do
                    a0 = a0 + 14
                    for arm = 0, 3 do
                        local o = New(path_bullet, star_small, 8, b.x, b.y, nil, 0, arm_path)
                        o.ox, o.oy = b.x, b.y
                        o.rad, o.ang = 18, a0 + arm * 90
                        o.dr, o.dw = ARM_V * ran:Float(0.85, 1.15), ran:Float(1.5, 2.3) * ran:Sign()
                        o.max_life = 250
                        o.bound = false
                    end
                    PlaySound("tan00", 0.04, 0, false)
                    task.Wait(ARM_GAP)
                end
            end)
        end

        function card:del()
            if IsValid(self.__chart) then
                object.RawDel(self.__chart)
            end
            self.__chart = nil
        end
    end
end
