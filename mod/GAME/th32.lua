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
            -- ins_82 写的 ex5 角度增量要取反才是同一个视觉方向：
            -- 原作 y 朝下、我们 y 朝上（换算见 red_magic_bound_* 上面那段）。
            object.SetV(self, self.red_magic_speed,
                    self.rot - self.red_magic_angle_delta * RAD_TO_DEG, true)
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
        -- 引擎每帧是「先跑 frame、再按 vx/vy 积分」：GameObjectPool.cpp:94-112 的
        -- updateMovementsLegacy 先 dispatchOnUpdate（:106）再 p->Update()（:111），
        -- 而 GameObject::Update 里才是 x += vx（GameObject.cpp:288-330）。
        -- 所以在这里累加速度，就等于原作的「先 velocity += ex4Acceleration、
        -- 再 pos += velocity」（BulletManager.cpp:722-733 与 :884）。
        if self.red_magic_spawn_left > 0 then
            -- 出场动画期间既不移动也不加速，等价于 SPAWNING_SLOW；
            -- 速度本来就是 0，「不移动」自动成立。
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
        bullet.frame(self)
    end,
})

local function red_magic_mid_activate(distance_mode)
    local owner = _boss
    if owner == nil then return function() end end
    -- Func9 的随机角整次调用只抽一次（EnemyEclInstr.cpp:593），
    -- Func11 是每颗各抽一次（EnemyEclInstr.cpp:643-662）。
    local shared_angle = ran:Float(-PI, PI)
    local function activate(unit)
        local angle
        if distance_mode then
            -- ins_121(9, 0) = Func9：角度 = 「弹到 BOSS 的距离」* π/256 + 本次调用的随机角
            -- （EnemyEclInstr.cpp:614-627）。同一环上的弹到 BOSS 的距离几乎相同、
            -- 方向就几乎相同，相邻两环也只差一点点 —— 所以它是「同心环整体往外滑」，
            -- 不是每颗各飞各的。取反的理由同 red_magic_huge（我们 y 朝上）。
            angle = -(red_magic_dist(unit.x, unit.y, owner.x, owner.y) * PI / 256
                    + shared_angle)
        else
            -- ins_121(11, 0) = Func11：每颗自己抽一个方向（EnemyEclInstr.cpp:631-662）
            angle = ran:Float(-PI, PI)
        end
        unit.red_magic_ax = math.cos(angle) * 0.01
        unit.red_magic_ay = math.sin(angle) * 0.01
        unit.red_magic_accel = 120
        unit.red_magic_awake = true
    end
    return activate
end

---ins_35("Sub41")：循环 20 轮，每轮 Func8 在**场上每一颗大玉**的当前位置生成一颗小弹
---（EnemyEclInstr.cpp:544-580，判据只有「槽位活着 + heightPx >= 30」，不区分来源）。
---原始 ECL 里 Sub41（ecldata6.ecl 偏移 0x5b1a..0x5b96）的 time 字段依次是
---0/0/0/0/0（循环体：ins_121(8,0) / CMPINT / JUMPNEQ / JUMP）、
---10（JUMPDEC ins_3(0, Sub41_20, -10009)）、10（RET）；JUMPDEC 跳回循环头时会把
---time 直接赋值成 0（EclManager.cpp:145-148 的 HANDLE_JUMP），所以「下一环」和
---JUMPDEC 落在同一帧上 —— 每环正好隔 10 帧：
---   第 1 环在 CALL 那一帧，第 k 环在第 10*(k-1) 帧，
---   第 20 环在第 190 帧，第 200 帧计数器减到 0 → 落到 time=10 的 RET → 返回。
---也就是「每环隔 10 帧、子程序 200 帧后返回」（不是 180）。
---移植版照抄这个节拍：THlib 的 task.Wait(t) 就是 yield t 次（Ltask.lua:68-77），
---而每个任务每帧只被 resume 一次（boss_system.lua:347-348 的 doTask 由 boss:frame
---每帧调一次），所以 Wait(10) = 正好 10 帧，20 轮 = 200 帧。
---（引擎自带的同款实现见 LuaSTG-Sub 的 data/example/scripts/task/init.lua：
---  task.wait(times) = for _ = 1, times do coroutine.yield() end。）
---⚠ tools/check_stage.lua 的 task 桩件把 Wait(n) 模拟成「n+1 帧」
---（check_stage.lua:604 的 yield(n) 配上 :1024-1035 每帧减一的等待计数），
---所以自检里读到的环间距是 11 帧 —— 那是桩件的偏差，**别照它把这里改回 9**。
local function red_magic_sub41()
    for round = 1, 20 do
        for index = #red_magic_huges, 1, -1 do
            local huge = red_magic_huges[index]
            if IsValid(huge) then
                New(red_magic_mid, huge.x, huge.y, ran:Float(-180, 180))
            else
                table.remove(red_magic_huges, index)
            end
        end
        task.Wait(10)
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

---ins_50(-π,π) + ins_47(2.5) + ins_61(60)：三条在**同一帧**执行 ——
---抽一个方向、把速度设成 2.5、再启动一段 60 帧的减速位移，
---总位移 = cos*2.5*60/2 = 75 px（MoveTime 里 moveInterp = dir*speed*time/2，
---EclManager.cpp:1082-1086），缓动 1-(1-u)²（movementEaseType=1，:942-946；
---和 task.SetMode[VALUE_SET.DECEL] 同式）。
---这三条**不阻塞**：A/B 波里紧跟其后的 ins_35("Sub41") 的 time 字段同样是 180，
---而 RunEcl 只在 time == instruction->time 时才执行（EclManager.cpp:112-120），
---所以 Sub41 和漂移是同一帧开始的；C/D 波把这三条排在 Sub41 与唤醒之后，
---于是漂移和**下一波**的 Sub41 同帧开始。
---（原作这段位移是挂在 enemy->flags.movementMode=2 上的状态，会被新的 ins_61
--- 直接覆盖，所以移植版按状态写而不是 task.MoveTo —— MoveTo 会阻塞 60 帧。）
local function red_magic_start_drift(owner)
    local angle = red_magic_rand_angle_in_bound(owner)
    owner.red_magic_drift = {
        x = owner.x, y = owner.y,
        dx = cos(angle) * 2.5 * 60 / 2,
        dy = sin(angle) * 2.5 * 60 / 2,
        t = 0, n = 60,
    }
end

---每帧推进一步（等价 enemy 的 movementMode=2 + movementEaseType=1）。
---放在 red_card:frame 里是因为引擎先调 card.frame 再跑任务，和原作
---「先 Move() 再 RunEcl」的顺序一致（EnemyManager.cpp:540/570）。
local function red_magic_drift_step(owner)
    local drift = owner.red_magic_drift
    if drift == nil then
        return
    end
    drift.t = drift.t + 1
    local u = min(drift.t / drift.n, 1)
    local e = 1 - (1 - u) * (1 - u)
    owner.x = drift.x + drift.dx * e
    owner.y = drift.y + drift.dy * e
    if drift.t >= drift.n then
        owner.red_magic_drift = nil
    end
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
            -- CIRCLE 分支：angle = angle1 + i*2π/count1 + layer*angle2
            -- （BulletManager.cpp:129-132）。layer_angle 取反的理由同 Func9。
            red_magic_bullet(owner,
                    angle + i * 360 / count - layer * layer_angle,
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
    red_magic_drift_step(self)
    self.x = min(max(self.x, red_magic_bound_l), red_magic_bound_r)
    self.y = min(max(self.y, red_magic_bound_b), red_magic_bound_t)
end

function red_card:init()
    task.New(self, function()
        -- ins_57(120, 192, 128, 0)：原作坐标 (192,128) → 我们坐标 (0,96)
        task.MoveTo(0, 96, 120, VALUE_SET.DECEL)
        -- 原作 Sub44 的循环体（Sub44_522）里每条指令的 time 字段：
        -- A/B 波全是 180、C/D 波全是 260、跳回循环头时把 time 改回 180、
        -- 循环体末尾那条跳转自己的 time 是 310。time 就是「这条指令在第几帧执行」
        -- （EclManager.cpp:112-120），而 CALL 期间调用方的 time 冻结、Sub41 要跑
        -- 200 帧（见 red_magic_sub41），所以以「A 波那一帧」为 0 的节拍是：
        --   第 0 帧：A 波发大玉 + 漂移开始 + 同帧 CALL Sub41
        --   第 200 帧：Sub41 返回 → 唤醒（Func11）+ 同帧发 B 波 + 漂移开始
        --   第 400 帧：B 波唤醒（Func9）
        --   第 480 帧：C 波发（调用方 time 180 → 260，空 80 帧）
        --   第 680 帧：C 波唤醒（Func11），之后才漂移；D 波与这次漂移同一帧发
        --   第 880 帧：D 波唤醒（Func9）+ 漂移开始
        --   第 930 帧：再等 50 帧，跳回循环头（time 改回 180）→ 下一轮 A 波同帧发
        while true do
            -- A 波：ins_9(-10005, 2π, -π) 每波重抽一次基准角。
            -- ins_82(120, ...) 只是把 ex5 曲线参数写进 enemy->bulletProps，
            -- 用不用由 ins_70 的 flags 决定：A 波 flags=512 只有 0x200（播音效），
            -- 没有 0x20，所以 A 波大玉走直线、不拐弯
            -- （BulletManager.cpp:550 播音效、:331-336 只认 0x20）。
            -- ins_70 的 angle2 = -0.31415927 rad = -18°。
            red_magic_circle(self, 14, 4, 4.0, 1.8, ran:Float(-180, 180), -18)
            red_magic_start_drift(self)
            red_magic_sub41()
            red_magic_activate_mids(false)          -- ins_121(11, 0) = Func11

            -- B 波：Hard 是 10 颗 1 层、Lunatic 是 12 颗 1 层，按 Lunatic。
            -- ins_82(80, ..., 0.023, -0.024543693)：ex5 曲线 80 帧，
            -- 每帧速度 +0.023、角度 -0.024543693 rad（= -2π/256）。
            red_magic_circle(self, 12, 1, 2.0, 1.0, ran:Float(-180, 180), 0,
                    80, 0.023, -0.024543693)
            red_magic_start_drift(self)
            red_magic_sub41()
            red_magic_activate_mids(true)           -- ins_121(9, 0) = Func9

            -- B 波唤醒（time 180）到 C 波 ins_70（time 260）之间空 80 帧
            task.Wait(80)

            -- C 波：Sub41 和唤醒都排在漂移**之前**
            red_magic_circle(self, 17, 1, 2.0, 1.0, ran:Float(-180, 180), 0,
                    60, 0.026, 0.024543693)
            red_magic_sub41()
            red_magic_activate_mids(false)          -- Func11
            red_magic_start_drift(self)

            -- D 波与 C 波的漂移同一帧发
            red_magic_circle(self, 16, 1, 1.0, 1.0, ran:Float(-180, 180), 0,
                    80, 0.023, -0.024543693)
            red_magic_sub41()
            red_magic_activate_mids(true)           -- Func9
            red_magic_start_drift(self)
            task.Wait(50)                           -- ins_2 的 time = 310
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
