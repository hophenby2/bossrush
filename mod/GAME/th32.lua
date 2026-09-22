---=====================================
---TH32  猩红测试：蕾米莉亚符卡测试场
---复用 TH08 的立绘、背景与 BGM；红色幻想乡按 TH06 ECL 移植。
---=====================================
_editor_class["TH32"] = {}
local TH08 = _editor_class["TH08"] or {}
local class = _editor_class["TH32"]

local bullet_lw3_4 = TH08["bullet_lw3-4"]
local bullet_lw3_5 = TH08["bullet_lw3-5"]
local RAD_TO_DEG = 57.29577951308232
local PI = 3.141592653589793

local function red_magic_dist(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    return (dx * dx + dy * dy) ^ 0.5
end

local red_magic_huge = Class(bullet, {
    init = function(self, x, y, angle, speed, duration, speed_delta, angle_delta)
        bullet.init(self, ball_huge, COLOR.RED, false, true)
        self.x, self.y = x, y
        object.SetV(self, speed, angle, true)
        self.red_magic_speed = speed
        self.red_magic_speed_delta = speed_delta
        self.red_magic_angle_delta = angle_delta
        self.red_magic_change_frames = duration
    end,
    frame = function(self)
        bullet.frame(self)
        if self.red_magic_change_frames > 0 then
            self.red_magic_change_frames = self.red_magic_change_frames - 1
            self.red_magic_speed = self.red_magic_speed + self.red_magic_speed_delta
            object.SetV(self, self.red_magic_speed,
                    self.rot + self.red_magic_angle_delta * RAD_TO_DEG, true)
        end
    end,
})

local red_magic_huges = {}

-- 全池登记表：th06 的 Func9/Func11 扫的是整个 640 颗弹池，判据只有
-- 「state 活着 + 是小弹 + speed == 0」（EnemyEclInstr.cpp:600-604），
-- 任何来源的未醒小弹都会被叫醒。移植版没有全局弹池，
-- 就用本卡自己的 mid 登记表当池子。
local red_magic_mids = {}

-- th06 的小弹是 flags=8 → BULLET_STATE_SPAWNING_SLOW（BulletManager.cpp:247-282），
-- 出场动画播完前进不了 0x10 加速分支（BulletManager.cpp:697-706）。
-- 动画长度取自 data/etama3.anm 的 script19
-- （ANM_SCRIPT_BULLET3_SPAWN_BIG_BALL_SLOW = 0x200+19，末尾 ins_0 的 time = 32）。
-- Sub41 每 10 帧出一环（JUMPDEC 指令 time = 10），唤醒又是 Sub41 返回后一次做完的，
-- 所以最后几环被唤醒时动画还没播完，起速依次晚 32 帧以内。
local red_magic_spawn_frames = 32

local red_magic_mid = Class(bullet, {
    init = function(self, x, y, angle)
        bullet.init(self, ball_mid, COLOR.RED, false, true)
        self.x, self.y = x, y
        object.SetV(self, 0, angle, true)
        self.red_magic_accel = 0
        self.red_magic_ax = 0
        self.red_magic_ay = 0
        self.red_magic_awake = false
        self.red_magic_spawn_left = red_magic_spawn_frames
        red_magic_mids[#red_magic_mids + 1] = self
    end,
    frame = function(self)
        bullet.frame(self)
        if self.red_magic_spawn_left > 0 then
            -- 出场动画期间既不移动也不加速，等价于 SPAWNING_SLOW
            self.red_magic_spawn_left = self.red_magic_spawn_left - 1
        elseif self.red_magic_accel > 0 then
            self.vx = self.vx + self.red_magic_ax
            self.vy = self.vy + self.red_magic_ay
            self.red_magic_accel = self.red_magic_accel - 1
            if self.red_magic_accel == 0 then
                object.SetV(self, 1.2,
                        math.atan2(self.vy, self.vx) * RAD_TO_DEG, true)
            end
        end
    end,
})

local function red_magic_mid_activate(distance_mode)
    local owner = _boss
    if owner == nil then return function() end end
    local shared_angle = ran:Float(-180, 180)
    local function activate(unit)
        local angle
        if distance_mode then
            local distance = red_magic_dist(unit.x, unit.y, owner.x, owner.y)
            angle = distance * PI / 256 * RAD_TO_DEG + shared_angle
        else
            angle = ran:Float(-180, 180)
        end
        unit.red_magic_ax = cos(angle) * 0.01
        unit.red_magic_ay = sin(angle) * 0.01
        unit.red_magic_accel = 120
        unit.red_magic_awake = true
    end
    return activate
end

local function red_magic_spawn_mids()
    for round = 1, 20 do
        for index = #red_magic_huges, 1, -1 do
            local huge = red_magic_huges[index]
            if IsValid(huge) then
                New(red_magic_mid, huge.x, huge.y, ran:Float(-180, 180))
            else
                table.remove(red_magic_huges, index)
            end
        end
        if round < 20 then
            task.Wait(10)
        end
    end
end

local function red_magic_bullet(owner, angle, speed, duration, speed_delta, angle_delta, sound)
    local huge = New(red_magic_huge, owner.x, owner.y, angle, speed,
            duration or 0, speed_delta or 0, angle_delta or 0)
    red_magic_huges[#red_magic_huges + 1] = huge
    if sound then
        PlaySound("tan00", 0.1, owner.x / 256, false)
    end
end

local function red_magic_sub41()
    return red_magic_spawn_mids()
end

---原作坐标 → 我们坐标的换算。
---th06 的 ECL 坐标是「游戏区域坐标」：区域 384x448、原点在左上、y 轴朝下
---（GameManager.hpp:44-45 的 GAME_REGION_WIDTH/HEIGHT；BulletManager.cpp:832-838
--- 判越界用的就是 x∈[0,384)、y∈[0,448)），屏幕上的 (32,16) 偏移是画的时候才加的。
---我们场地也是 384x448，只是原点在场地中心、y 轴朝上
---（Lscreen.lua:180-190 的 SetWorld(288,46,384,448) → l=-192,r=192,b=-224,t=224）。
---两边尺寸完全相同，所以换算是纯平移 + y 翻转，**没有比例缩放**（K = 1）：
---    x_我们 = x_原作 - 192        y_我们 = 224 - y_原作
---于是 ins_65(32, 48, 352, 120) 这个框 = 我们坐标的 x∈[-160,160]、y∈[104,176]，
---ins_57(120, 192, 128, 0) 的落点 = (0, 96)，再被上面的框夹到 (0, 104)。
local red_magic_bound_l, red_magic_bound_r = -160, 160
local red_magic_bound_b, red_magic_bound_t = 104, 176

---ins_50(-π,π) 不是「均匀随机方向」：MOVERANDINBOUND 会看 BOSS 离框边多远，
---离哪边近就把朝那边的那个分量反射回场内（EclManager.cpp:623-659）：
---x 距左右框边 < 96 px、y 距上下框边 < 48 px 时改角。
---（y 的反射在两边语义一致：原作 y 朝下、我们 y 朝上，所以原作「别朝 y=48
---  那面飞」在我们这边就是「别朝 +y 飞」。）
---注意框只有 72 px 高：BOSS 停在距上下边都 < 48 px 的中间带（原作 y∈(72,96)
---= 我们 y∈(128,152)）时两个 y 反射互相抵消，这时漂移仍会撞上 y 框、
---被 ClampPos 截短 —— 原作本来就这样，不是移植误差。
---实测位移（/tmp/nest/bos3.csv，前四波）：75.0 / 53.1 / 75.0 / 55.4 px，
---第二、四波就是撞到 y=176 被夹住的。
local function red_magic_rand_angle_in_bound(owner)
    local angle = ran:Float(-180, 180)
    if owner.x < red_magic_bound_l + 96 then
        if angle > 90 then
            angle = 180 - angle
        elseif angle < -90 then
            angle = -180 - angle
        end
    end
    if owner.x > red_magic_bound_r - 96 then
        if angle >= 0 and angle < 90 then
            angle = 180 - angle
        elseif angle <= 0 and angle > -90 then
            angle = -180 - angle
        end
    end
    if owner.y > red_magic_bound_t - 48 and angle > 0 then
        angle = -angle
    end
    if owner.y < red_magic_bound_b + 48 and angle < 0 then
        angle = -angle
    end
    return angle
end

---每波开火之后、扫描之前，原作都会 ins_50(-π,π) + ins_47(2.5) + ins_61(60)：
---BOSS 朝随机方向漂 2.5 * 60 / 2 = 75 px 再停下（EclManager.cpp:623/344/593；
---ins_61 是 MOVETIMEDECELERATE，缓动就是 1-(1-t)²，
---和我们 task.SetMode[VALUE_SET.DECEL]（Ltask.lua:179）一模一样）。
---注意 ins_61 是**阻塞**的：脚本要等满 60 帧才走到 ins_35("Sub41")，
---这 60 帧里大玉照飞——所以第一环小弹是落在大玉飞了 60 帧的位置上
---（A 波最快那层半径 ≈ 4.0*60 = 240 px），不是环心。用 task.New 并发跑
---这个位移会让 Sub41 立刻开始，第一环全挤在环心，整套环都比原作小一圈。
---（原作 C/D 波是 Sub41 → 扫描 → 漂移，扫描时 BOSS 还没动；移植版四波
--- 统一「先漂后扫」，对 C/D 更宽容：距离抬到 75 px，方向几乎平行，不会撕开。）
---这一下不能省：Func9 量的是「弹 → BOSS」的距离（EnemyEclInstr.cpp:625），
---BOSS 站在环心上时内圈的 distance 就等于环半径，相邻环方向差 17~20°，
---到 |位移| = 256/π ≈ 82 px 内圈必然越出外圈；BOSS 离开环心后
---内圈的 distance 都被抬到 ≈75 px 左右，方向差降到 3~7°，剪切就压没了。
local function red_magic_boss_drift(owner)
    local angle = red_magic_rand_angle_in_bound(owner)
    local x, y = owner.x + cos(angle) * 75, owner.y + sin(angle) * 75
    task.MoveTo(x, y, 60, VALUE_SET.DECEL)
end

---全池唤醒：th06 侧的判据是 speed == 0（EnemyEclInstr.cpp:604），
---也就是「所有还没醒的小弹」，不只是本次刚生成的那批。
local function red_magic_activate_mids(distance_mode)
    local activate = red_magic_mid_activate(distance_mode)
    for index = #red_magic_mids, 1, -1 do
        local unit = red_magic_mids[index]
        if not IsValid(unit) then
            table.remove(red_magic_mids, index)
        elseif not unit.red_magic_awake then
            activate(unit)
        end
    end
end

local function red_magic_circle(owner, count, layers, speed, layer_speed, angle,
        layer_angle, duration, speed_delta, angle_delta)
    for layer = 0, layers - 1 do
        for i = 0, count - 1 do
            red_magic_bullet(owner,
                    angle + i * 360 / count + layer * layer_angle,
                    speed + (layer_speed - speed) * layer / layers,
                    duration, speed_delta, angle_delta, layer == 0 and i == 0)
        end
    end
end

local red_card = boss.card.New("「红色的幻想乡」", 140, 140, 140, 2000)
function red_card:before()
    red_magic_huges = {}
    red_magic_mids = {}
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
end

---ins_65(32, 48, 352, 120)：原作每帧把 BOSS 夹在这个框里
---（EclManager.cpp:617 MOVEBOUNDSSET / EnemyManager.cpp:468 ClampPos）。
---换算到我们坐标是 x∈[-160,160]、y∈[104,176]，落点 (0,96) 被下边框夹到 (0,104)。
function red_card:frame()
    self.x = min(max(self.x, red_magic_bound_l), red_magic_bound_r)
    self.y = min(max(self.y, red_magic_bound_b), red_magic_bound_t)
end

function red_card:init()
    task.New(self, function()
        -- ins_57(120, 192, 128, 0)：原作坐标 (192,128) → 我们坐标 (0,96)
        task.MoveTo(0, 96, 120, VALUE_SET.DECEL)
        while true do
            local phase = ran:Float(-180, 180)

            -- ins_82(120, ..., 0.023, 0.024543693) 只是把 ex5 曲线参数写进
            -- enemy->bulletProps，用不用由 ins_70 的 flags 决定：A 波 flags=512
            -- 只有 0x200（播音效），没有 0x20，所以 A 波大玉走直线、不拐弯
            -- （BulletManager.cpp:176 exFlags=flags、:336 只认 0x20）。
            red_magic_circle(self, 14, 4, 4.0, 1.8, phase, -18)
            red_magic_boss_drift(self)
            red_magic_sub41()
            red_magic_activate_mids(false)
            red_magic_circle(self, 10, 1, 2.0, 2.0, phase + 18, 0,
                    80, 0.023, -0.024543693)
            red_magic_boss_drift(self)
            red_magic_sub41()
            red_magic_activate_mids(true)
            task.Wait(60)

            red_magic_circle(self, 17, 1, 2.0, 2.0, phase + 18, 0,
                    60, 0.026, 0.024543693)
            red_magic_boss_drift(self)
            red_magic_sub41()
            -- C 波原作是 ins_121(9, 0) = Func9（量到 BOSS 的距离定方向），
            -- 不是 A 波那个 ins_121(11, 0) = Func11（每颗各抽一个随机角）。
            -- 写成 false 会让整波小弹各飞各的，环当场撕开。
            red_magic_activate_mids(true)
            task.Wait(50)
            red_magic_circle(self, 16, 1, 1.0, 1.0, phase + 18, 0,
                    80, 0.023, -0.024543693)
            red_magic_boss_drift(self)
            red_magic_sub41()
            red_magic_activate_mids(true)
            task.Wait(60)
        end
    end)
end

local function NewText(x, y, layer, text, alpha, color, lifetime, f, viewmode, ...)
    if _G.SimpleText == nil then return end
    return New(_G.SimpleText, x, y, layer, text, alpha, color, lifetime, f, viewmode, ...)
end

local function NewBulletLW34(...)
    if bullet_lw3_4 == nil then return end
    return New(bullet_lw3_4, ...)
end

local function NewBulletLW35(...)
    if bullet_lw3_5 == nil then return end
    return New(bullet_lw3_5, ...)
end


boss.Define("1a", "蕾米莉亚·斯卡蕾特", "TH08_NEW_3", TH08_bg,
        { 0, 384 }, TH08["SCBG-LW13"], "Remilia", 30)

boss.card.add({ { red_card, "1a" } }, 30, "「红色的幻想乡」", 369)

local card = boss.card.New("「克罗里·尤斯福德」", 11, 11, 11, 2000)
function card:before()
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
    task.MoveTo(0, 120, 60, 2)
end

function card:init()
    task.New(self, function()
        NewText(480, 550, nil,
                "克罗里·尤斯福德，漫画《终结的炽天使》及其衍生作品中人物",
                255, { 250, 128, 114 }, nil, function()
                    local self = task.GetSelf()
                    task.MoveTo(480, 330, 80, 2)
                    task.Wait(80)
                    NewText(480, 550, nil,
                            "实力强悍，与第十三始祖的排位不符",
                            255, { 250, 128, 194 }, nil, function()
                                task.MoveTo(480, 330, 110, 2)
                                task.Wait(100)
                                task.MoveTo(480, -100, 40, VALUE_SET.ACCEL)
                                object.RawDel(task.GetSelf())
                            end, "ui", "center")
                    task.MoveTo(480, -100, 40, VALUE_SET.ACCEL)
                    object.RawDel(self)
                end, "ui", "center")

    local a, old_x, old_y, x, y, angle, radius, v
    while true do
        self.t = false
        a = -90 + ran:Float(-20, 20)
        for _ = 1, 70 do
            NewBulletLW34(self.x, self.y, 150, a, self.x, self.y, 7)
                a = a + 360 / 75
            end

            old_x, old_y = self.x, self.y
            task.MoveToPlayer(60, -200, 200, 70, 120,
                    32, 64, 16, 32, 2, WANDER_MODE.RANDOM)
            task.Wait(40)

            Newcharge_in(self.x, self.y, 255, 30, 30)
            task.Wait(60)
            misc.ShakeScreen(30, 0.4)
            Newcharge_out(self.x, self.y, 255, 30, 30)
            self.t = true

            v = 6
            for _ = 1, 30 do
                for _ = 1, 30 do
                    a = ran:Float(0, 360)
                    radius = ran:Float(150, 300)
                    x = old_x + cos(a) * radius
                    y = old_y + sin(a) * radius
                    NewSimpleBullet(square, 1, x, y, 8 + v, a + ran:Float(-25, 25))
                end
                angle = ran:Float(0, 360)
                radius = ran:Float(150, 300)
                NewBulletLW35(
                        old_x + cos(angle) * radius, old_y + sin(angle) * radius,
                        2, ball_mid, 0, ran:Float(0.4, 0.8), ran:Float(0, 360))
                task.Wait()
                v = v + 2 / 29
            end
            task.Wait(20)
        end
    end)
end

boss.card.add({ { card, "1a" } }, 30, "「克罗里·尤斯福德」", 368)
