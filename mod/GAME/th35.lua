---=====================================
---TH35  东方风神录（TH10）六面 BOSS 八坂神奈子 —— 最后一张符卡
---  原作 = `[th10] 东方风神录/data/stage06.ecl`（本机在 thtkGUI-th20tr 包里）。
---  子程序链：BossCard5（主循环）→ BossCard5_atN / BossCard5_at2（枪）
---  → BossCirR2/G2/B2/R4/G4/B4（6 颗装饰卫星）→ BossDead（击破演出）。
---
---数据从哪来（本文件每个数字的出处）
---  · thtk 的 ECL 解释器 thecl，**带上 TH10 的名字表**：
---        thecl -d 10 -m "MAP/th10.eclm" stage06.ecl out.txt
---    不带 -m 时 thecl 只输出 `ins_NNN` 编号；带上 eclmap 就直接给出 `moveCircle` /
---    `moveCircleRel` / `moveAdd` / `wait` / `etEx` / `spell` 这些真名 —— 本文件按真名读。
---    eclmap 同时给出全局量表（-9985 I0、-9984 I1、-9983 I2、-9982 I3、-9981 F0、
---    -9979 F2、-9978 F3、-9963 BOSS_X、-9998 RANDRAD…），原文里的 `$I0` / `%F0`
---    就是它们，下面按 `I0` / `F0` 引用。
---  · 运动学按 TH10 1.00a 复原源码核对：
---      `src/EnemyEclDispatcher.cpp` 0x118~0x12B（位置/速度/圆）、0x199（etEx 参数顺序）、
---      `src/Enemy.cpp` 的 EnemyRuntimeUpdate（每帧先解两路 motion、再跑 ECL）、
---      `src/BulletTransform.cpp` + `src/BulletManager.hpp`（etEx 的 kind 表）。
---  · 变量语义同样按复原源码核对：`$I0~$I3` / `%F0~%F3` 是**每敌机**的 8 个变量
---    （`src/Enemy.hpp` 的 EnemyEclVariableView，Enemy+0x1138/0x1148）；
---    `enmCreate` 造子机时把创建者这 8 个变量整块拷给子机（`src/Enemy.cpp` EnemySpawn 的
---    memcpy(request->eclVariables)），之后子机各持副本 ⇒ 5 把枪的 `$I2` 互不影响，
---    本文件「每把枪各自一个 wait 计数」才是对的（不是全波共用一个 $I2）。
---    ★ 关键（整张卡的位置模型都靠它）：进圆运动时引擎把**当前 position 存进 velocity
---      字段当圆心**（`if ((selectedMotion->flags & 1) == 0) selectedMotion->velocity =
---      selectedMotion->position;`），之后每帧 `半径 += 半径速度；角 += 角速度`，
---      `pos = 圆心 + 半径·(cos角, sin角)`；`moveAdd` / `moveAddRel` 改的就是这个**圆心**。
---      两路 motion（offset + base）**位置相加**才是世界坐标。
---    ⇒ 原文的 `moveCircle`(偏移圆) / `moveCircleRel`(基准圆) 都是「以某点为圆心画圆」，
---      不是「绕着出生点转」；写成后者整张卡的位置就全错。
---
---这张卡在干什么（自然语言版）
---  · 开场 90 帧：BOSS 从上一张卡的高度降到本卡高度（原作 movePosTime(90, 4, 0, 160)）。
---    t=90 亮符卡（setChapter(47) + spell(93,…)），t=150 开始出弹 ⇒ 本文件 init 从原作
---    t=90 起算，init 内 t=60 = 原作 t=150。
---  · t=150：生成 6 颗**装饰卫星**。每颗 = 两路圆运动叠加（偏移圆 + 基准圆），两个圆心
---    都跟着 BOSS（卫星线程每帧 `moveAdd(BOSS_X, BOSS_Y)` 把偏移圆的圆心钉在 BOSS 上），
---    半径从 0 每帧 +2（4 号那三颗 +1），角速度 0.0052359877 / 0.05235988 弧度/帧
---    （4 号那三颗取负）。第 62 帧把两路半径速度清零（半径冻结、角继续转），挂到卡结束。
---  · 主循环（原作 BossCard5_1408 … 末尾 JUMP 回来）每轮两拍，每拍：
---        5 把 atN 枪（彼此隔 72°）→ 停 60 帧
---        → 5 把 at2 枪（%F0 先 +π）→ 停 40 帧
---        → 5 把 at2 枪（F2 ×= 1.397、%F0 再 +π）→ 停 40 帧 → 再停 $B 帧
---      每拍收尾：%F0 = 随机角、%F3 取反、I3 += 2（< 25 才加）。
---      第 1 拍色号 2 / 4 / 6，第 2 拍 9 / 10 / 8（原作 $I0 = 2,4,6 / 9,10,8）。
---  · 枪 = 圆上的一个点：圆心在 BOSS 外（atN 48 px；at2 0.809×F2），圆半径就是出弹半径
---    （atN 48；at2 0.588×F2）。每帧在圆上打 1 发，方向 = 圆角（每帧 +圆角速度×5/8）
---    再 −π（原文 `%D -= π`）⇒ 朝圆心方向打；atN 每第 4 发再多转 3 倍角速度。
---    发数：atN 60 发、at2 40 发，挂起帧数都是 160 起、每发 −1。
---  · 弹：出膛 0.001（几乎不动），先挂 I2 帧，挂满后按 etEx kind=0x20（ACCELERATE_POLAR）
---    每帧 +F 持续 120 帧（F = 难度基值 + I3×0.00023，Lunatic：atN 0.017 / at2 0.019，
---    I3 从 12 每拍 +2、到 26 封顶）。⇒ 画面上是「一圈几乎不动的弹，等两秒多一起射出去」。
---
---坐标（两边场地都是 384×448，长度 1:1 不缩放）
---  原作 ECL 的敌机坐标：x 以场地中心为 0（±192 = 左右边）、y 从上边往下量（0..448）；
---  我们原点在中心、y 朝上（lstg.world.l/r/b/t = −192/192/−224/224）：
---        x_我们 = x_原作            y_我们 = 224 − y_原作          角度取反（θ → −θ）
---  本文件内部一律用**原作弧度**（y 朝下）记账；只有写进引擎时才换算：
---  位置 `m.y − r·sin θ`，方向 `−θ × RAD`（引擎的 rot / SetV 是角度制、y 朝上）。
---
---与原作的不同（代码里按「差异 N」引用）
---  1  BOSS 入场用 task.MoveTo + VALUE_SET.DECEL 代理原作 movePosTime(90, 4, 0, 160)：
---     原作 mode 4 的曲线本仓库没有反编译（EnemyEvaluatePositionInterpolation 未复原），
---     DECEL 是同类入场曲线里最接近的（th30/th32 的 BOSS 入场也用 DECEL）。
---     起点 = 上一张卡把 BOSS 留在的高度（原作 y=144 ⇒ 我们 80），终点 = 原作 y=160 ⇒ 我们 64。
---  2  弹样式是代理：原作 `etSprite(0, 6, $I0)` = TH10 精灵表第 6 号弹、色号 $I0；
---     本仓库没有 TH10 的弹精灵表 ⇒ 取 `ball_mid`，色号 2/4/6/8/9/10 原样沿用。
---  3  弹池上限不建模：原作 TH10 全游戏共用 2000 个弹槽（BulletManager.cpp 的
---     SpawnSingleBullet 从指针起环形扫 2000 槽；满槽 ⇒ 整波不生、生到一半见底 ⇒ 丢剩下的）。
---     本卡一轮要往外挤近 2000 发，真机上会顶到上限 —— 移植版交给引擎自己按边界回收。
---  4  出膛动画（flags 带 SPAWN_FAST/SLOW 的 10/15/30 帧定格）不建模：本卡出膛速度 0.001，
---     那几帧的位移可以忽略，弹在出膛帧就能被看见。
---  5  弹的 etEx 程序里 slot0（kind=2，TH10 复原源码的 kind 表里没有这一项）与 slot1
---     （kind=0x1000 SET_CANCEL_BEHAVIOR=10000）都只影响消弹表现，本文件按无效果处理；
---     真正决定画面的是 slot2（WAIT=I2，每发重新装填）与 slot3（ACCELERATE_POLAR）。
---  6  卫星是代理：原作是 TH10 的 anm 15/16/17 圆环（红/绿/蓝）+ flagSet(7)，无判定；
---     这里用一颗小光球（ball_light 2/7/5）画，bound/colli 都关掉。
---  7  BossDead 的演出（gameSpeed 0.5 → 0.25、etClearAll、贴图切换、之后 40 帧 flagSet(16)）
---     由本仓库的击破/换卡流程接管；这里只补一次震屏。原作 setScreenShake(30, 12, 0)，
---     幅度 12 的原作单位与本仓库 misc.ShakeScreen 的 size 不是一套 ⇒ 取 1.5。
---  8  道具掉落（原作 t=0 的 dropClear / dropExtra(1,46) / dropExtra(2,20) /
---     dropArea(48,48) / dropItems）不建模，沿用引擎默认。
---  9  符卡计时：t1 = t2 = 2.5 s = 原作 150 帧的无敌窗口（setInvuln(90) + setInvuln(60)）；
---     t3 = 151.5 s = 原作 150 s 时限 + 入场的 1.5 s。注意本仓库 t1/t2/t3 从 init 起算，
---     而入场（90 帧）在 before 里，这里按「从 BOSS 开始下降算起」计时。
--- 10  难度：原作用 spell / spell3（难度掩码 !EN / !HL）把 E/N/H/L 四行串在同一个子程序里
---     （F = 0.007/0.013/0.014/0.017 与 0.007/0.014/0.016/0.019；$B = 140/120/100/50；
---     I3 = 0/4/8/12；Easy 另有分支（只在 at2：$G 减半、每发多等 1 帧、$I2 每发多减 1、
---     且 $G%2==1 时 %D += %E×31，而非非 Easy 的 $G%4==3 时 %D += %E×3）。
---     第 1 拍收尾 $B>60 判据不分难度；第 2 拍收尾 Easy/Normal 用 >60、Hard/Lunatic 用 >10）。
---     本仓库没有难度系统（th32.lua / th34.lua 同一约定）⇒ **固定取 Lunatic 行**。
---=====================================

_editor_class["TH35"] = {}
local class = _editor_class["TH35"]

local RAD = 180 / math.pi           -- 弧度 → 角度（引擎的 rot / SetV 是角度制）
local PI = math.pi

---===== 原作常量（stage06.ecl BossCard5，Lunatic 行）=====
local CARD_NAME = "「風神様の神徳」"
local LEVEL = 33                    -- = core.lua 的 STAGE_COUNT + 1，见文件末尾的注册清单
---符卡历史槽位（spell_card_data 的键，也是符卡练习的解锁 id），跨关卡唯一。
---选址实测（`luajit tools/check_stage.lua --all`）：th34 占 3400..3407、th31 占
---3409/3410（它的 id 写在 LIST 表第 3 项里，光扫 `boss.card.add` 末参会漏掉），
---3408/3411/3480 都已被占 —— 本关取 3600。改这个数一定要重跑 --all。
local CARD_ID = 3600
local MAX_LIFE = 8200               -- 原作 lifeSet(8200)（差异 9）

---弹（BossCard5_atN / at2 共用）
local BULLET_STYLE = ball_mid       -- 差异 2
local BULLET_INIT_SPEED = 0.001     -- etSpeed(0, 0.001, 1.5)：count2 == 1 ⇒ 出膛速度 = speed1
local BULLET_ACCEL_FRAMES = 120     -- etEx(…, kind=0x20, int0=120, float0=F, float1=0)
local F_ATN_BASE = 0.017            -- atN 的每帧加速度基值（Lunatic 行）
local F_AT2_BASE = 0.019            -- at2 的每帧加速度基值（Lunatic 行）
local F_I3_STEP = 0.00023           -- 两条都要再加 I3 × 0.00023

---枪（BossCard5_atN / BossCard5_at2）
local ATN_BULLETS = 60              -- 原作 $G = 60
local ATN_CENTER = 48               -- moveAddRel(circlePos(…, %F0, −48))：圆心离 BOSS 48
local ATN_RADIUS = 48               -- moveCircleRel(%D, %E, 48, 0)
local ATN_ANGVEL = 5.026548 / 60    -- %E = 5.026548 × %F3 / 60（圆角速度，弧度/帧）
local AT2_BULLETS = 40              -- 原作 $G = $I1 = 40（Lunatic / 非 Easy）
local AT2_CENTER_K = 0.809          -- moveAddRel(…, %F2 × −0.809)
local AT2_RADIUS_K = 0.588          -- moveCircleRel(…, %F2 × 0.588, 0)
local DIR_ANGVEL_K = 5 / 8          -- 开火角的推进 = 圆角速度 × 5/8（两条收尾都这么算）

---6 颗装饰卫星（BossCirR2/G2/B2/R4/G4/B4）
---{ 起始角, 偏移圆角速度, 偏移圆半径速度, 基准圆角速度, 基准圆半径速度, 光球色号 }
local SAT_FREEZE = 62               -- 原作 +60 那一支：两路半径速度清零
local SATS = {
    { "R2", -PI / 2,     0.0052359877, 2,  0.05235988, 2, 2 },
    { "G2",  PI / 6,     0.0052359877, 2,  0.05235988, 2, 7 },
    { "B2",  5 * PI / 6, 0.0052359877, 2,  0.05235988, 2, 5 },
    { "R4", -PI / 2,    -0.0052359877, 1, -0.05235988, 1, 2 },
    { "G4",  PI / 6,    -0.0052359877, 1, -0.05235988, 1, 7 },
    { "B4",  5 * PI / 6,-0.0052359877, 1, -0.05235988, 1, 5 },
}
---原作 B2/B4 在 moveCircle 前还有一条 moveVel(1.5707964, 2.0)：它会先写偏移圆的
---（角, 速度），紧接着被 moveCircle 的（角, 角速度, 半径, 半径速度）整组覆盖，净效果为零，
---所以上面表里没有它（这也是 B2/B4 与 R2/G2/R4/G4 唯一的不对称处）。

---主循环初值（原作 t=150 末尾那几行）
local F0_INIT = 1.570796            -- %F0 = 1.570796f
local F3_INIT = 1.0                 -- %F3 = 1.0f
local I3_INIT = 12                  -- diffI($I3, 0, 4, 8, 12) 的 Lunatic 行
local I2_INIT = 160                 -- $I2 = 160
local F2_INIT = 96                  -- %F2 = _f(96)
local B_INIT = 50                   -- diffI($B, 140, 120, 100, 50) 的 Lunatic 行
local GUN_SPREAD = 2 * PI / 5       -- 原作 1.256637f：5 把枪彼此隔 72°

local function rngrad()
    return ran:Float(-PI, PI)       -- %RANDRAD（-9998）
end

---一颗弹（原作 atN / at2 共用那一套弹参数）
---  用本仓库的 NewSimpleBullet 造（这样弹会进引擎与自检工具的弹表），额外行为挂在 frame 钩子上：
---    th_wait  = $I2：先挂多少帧不动（etEx kind=0x8000）
---    th_delta = F  ：挂完之后每帧加多少速度、持续 BULLET_ACCEL_FRAMES 帧（etEx kind=0x20）
local function th35_bullet_frame(self)
    ---引擎每帧「先跑 frame、再按 vx/vy 积分」，所以这里改速度 == 原作的
    ---「先 velocity += 加速度、再 pos += velocity」。
    if self.th_wait > 0 then
        self.th_wait = self.th_wait - 1
    elseif self.th_left > 0 then
        self.th_left = self.th_left - 1
        self.th_speed = self.th_speed + self.th_delta
        object.SetV(self, self.th_speed, self.rot, true)
    end
end

local function spawn_bullet(x, y, angle_deg, delta, wait, color)
    local b = NewSimpleBullet(BULLET_STYLE, color, x, y,
            BULLET_INIT_SPEED, angle_deg, false, 0, false, true, nil, nil,
            th35_bullet_frame)
    b.th_wait = wait
    b.th_delta = delta
    b.th_left = BULLET_ACCEL_FRAMES
    b.th_speed = BULLET_INIT_SPEED
    return b
end

---一把枪（原作 sub BossCard5_atN / BossCard5_at2）
---  枪本身没有贴图（原作只有 flagSet(20)，没有 anm 脚本），所以直接用协程，不建对象。
---  圆心 = BOSS 位置 + 圆心偏移（原作靠 moveAddRel 把基准圆的圆心从 (0,0) 移到
---  circlePos(…, %F0, ∓偏移量)）；出弹半径 = 圆半径；每帧在圆上打 1 发。
---  kind = "N"（atN：圆心偏移 48、半径 48、60 发）
---  kind = "2"（at2：圆心偏移 0.809×F2、半径 0.588×F2、40 发）
local function th35_gun(boss, kind, color, f0, f3, i1, i2, i3, f2)
    local ang, center_r, radius, count, delta, theta
    if kind == "N" then
        ang = ATN_ANGVEL * f3
        center_r = ATN_CENTER
        radius = ATN_RADIUS
        count = ATN_BULLETS
        delta = F_ATN_BASE + i3 * F_I3_STEP
        theta = f0 + 2 * PI / 10            -- moveCircleRel 的起始角 = %F0 + 2π/10
    else
        ang = (PI / i1) * f3                -- %E = π / $I1 × %F3
        center_r = AT2_CENTER_K * f2
        radius = AT2_RADIUS_K * f2
        count = i1                          -- 原作 $G = $I1
        delta = F_AT2_BASE + i3 * F_I3_STEP
        theta = f0 + f3 * PI / 2            -- moveCircleRel 的起始角 = %F0 + %F3×π/2
    end
    local dir = ang * DIR_ANGVEL_K          -- 开火角每帧的推进量
    ---圆心（相对 BOSS）：原作 y 朝下，circlePos 给的是 −半径·(cos %F0, sin %F0)；
    ---换到我们 y 朝上 ⇒ y 分量取反。
    local cx = boss.x - center_r * math.cos(f0)
    local cy = boss.y + center_r * math.sin(f0)

    task.New(boss, function()
        local psi = theta - PI              -- 循环前的 %D = %D − π（朝圆心打）
        local wait = i2                     -- 每发一个 $I2（第一发 = 160，之后每发 −1）
        for k = 1, count do
            ---圆运动：引擎在帧首推进「角 += 角速度」（半径速度 0 ⇒ 半径不变）
            theta = theta + ang
            ---开火角：原作循环里「%D += %E」；atN / 非 Easy at2 再判 $G % 4 == 3
            psi = psi + dir
            local g = count - k             -- 原作 $G 在进入循环体时的值（后缀自减之后）
            if g % 4 == 3 then
                psi = psi + 3 * dir         -- 原作 %D += %E × 3
            end
            local bx = cx + radius * math.cos(theta)
            local by = cy - radius * math.sin(theta)
            spawn_bullet(bx, by, -psi * RAD, delta, wait, color)
            wait = wait - 1                 -- 原作 $I2 = $I2 − 1
            task.Wait(1)                    -- 原作循环开头 wait(1)
        end
    end)
end

---一波 5 把枪（原作连着 5 条 enmCreate，每条之间 %F0 += 1.256637 并 validRad）
---返回推进后的 %F0（5 × 2π/5 = 2π，等价于不变）。
local function gun_wave(boss, kind, color, f0, f3, i1, i2, i3, f2)
    for _ = 1, 5 do
        th35_gun(boss, kind, color, f0, f3, i1, i2, i3, f2)
        f0 = f0 + GUN_SPREAD
    end
    return f0
end

---装饰卫星（原作 BossCirR2/G2/B2/R4/G4/B4）
---  两路圆运动叠加，圆心都在 BOSS 身上（原作每条都挂着 BossCirR2_cir_cpos 线程：
---  每帧 moveAdd(BOSS_X, BOSS_Y) 把偏移圆的圆心钉在 BOSS 上）。
---  每帧：两路各自「半径 += 半径速度、角 += 角速度」，第 62 帧把两路半径速度清零。
class["th35_sat"] = Class(object, {
    init = function(self, master, theta0, off_av, off_rv, base_av, base_rv, color)
        self.master = master
        self.th_off_a, self.th_off_av = theta0, off_av          -- 偏移圆（moveCircle）
        self.th_base_a, self.th_base_av = theta0, base_av       -- 基准圆（moveCircleRel）
        self.th_off_r, self.th_off_rv = 0, off_rv
        self.th_base_r, self.th_base_rv = 0, base_rv
        self.th_t = 0
        self.th_color = color
        self.x, self.y = master.x, master.y
        self.group, self.layer = GROUP.GHOST, LAYER.ENEMY_BULLET - 12
        self.bound, self.colli = false, false
    end,
    frame = function(self)
        self.th_t = self.th_t + 1
        self.th_off_r = self.th_off_r + self.th_off_rv
        self.th_base_r = self.th_base_r + self.th_base_rv
        self.th_off_a = self.th_off_a + self.th_off_av
        self.th_base_a = self.th_base_a + self.th_base_av
        if self.th_t == SAT_FREEZE then      -- 原作 +60：在本帧推进之后再清零
            self.th_off_rv, self.th_base_rv = 0, 0
        end
        local m = self.master
        if IsValid(m) then
            self.x = m.x + self.th_off_r * math.cos(self.th_off_a)
                         + self.th_base_r * math.cos(self.th_base_a)
            self.y = m.y - self.th_off_r * math.sin(self.th_off_a)
                         - self.th_base_r * math.sin(self.th_base_a)
        end
    end,
    render = function(self)
        ---差异 6：原作是 TH10 的 anm 15/16/17（红/绿/蓝圆环），这里用一颗小光球代理
        local img = "ball_light" .. self.th_color
        SetImageState(img, "mul+add", 170, 255, 255, 255)
        Render(img, self.x, self.y, 0, 0.55, 0.55)
    end,
}, true)

---=====================================
---关卡注册（第 33 关 = TH35）
---  ① core.lua:54            STAGE_COUNT 32 → 33
---  ② mod/_editor_output.lua:47   StageID 列表加 "35"（顺序决定载入顺序）
---  ③ mod/_editor_output.lua:49   不建自己的 BG 目录（复用 TH10_bg）
---  ④ mod/_editor_output.lua:1213 stage_pic 纹理循环 32 → 33
---  ⑤ THlib/UI/UI.lua:77     difftext 列表按 level 下标加第 33 项 = "风神录"
---  ⑥ THlib/UI/UI.lua:101    sntext 加 TH35 = "风神录"
---  ⑦ mod/main_stage.lua     NewStage("TH35", …) + self:Next(168)
---  ⑧ mod/defachievement.lua DefineAchievement(168, …)
---  ⑨ 素材                   mod/GAME/stage_pic33.png
---     （**占位图**：先拷的 stage_pic10.png；要换成真立绘直接覆盖这个文件即可）
---  ⑩ 符卡槽位 CARD_ID 取 3600（th34 占 3400..3407、th31 占 3409/3410，
---     3408/3411/3480 也已被占）—— 注册完必须跑 `check_stage.lua --all` 确认不撞号。
---  ⚠ 前提是 STAGE_COUNT 一起改：th16AEX 占着 `STAGE_COUNT + 1`、editname 也是 "1a"，
---    只把 "35" 塞进 StageID 而不动 STAGE_COUNT 的话 `_editor_boss["1a33"]` 会被它盖掉。
---=====================================
boss.Define("1a", "八坂神奈子", "TH10_2", TH10_bg, { 0, 80 }, nil, "Kanako", LEVEL)

local card = boss.card.New(CARD_NAME, 2.5, 2.5, 151.5, MAX_LIFE)  -- 差异 9

function card:before()
    ---原作 t=0 的 movePosTime(90, 4, 0, 160)：BOSS 从上一张卡留下的高度再降到本卡高度。
    ---原作 ECL 的 y 从上边往下量：144 → 160；换算到我们坐标系（224 − y）= 80 → 64。
    ---本仓库 boss.Define 的 y 只是"出生点"（doCard 跑到 before 时 BOSS 在屏幕上方 y=300），
    ---所以这里先把 BOSS 摆到上一张卡留下的高度 80（原作是"本来就在那儿"，不出现位移），
    ---再走那 90 帧降到 64。
    self.y = 80
    task.MoveTo(self.x, 64, 90, VALUE_SET.DECEL)              -- 差异 1
end

function card:init()
    local boss_obj = self
    task.New(self, function()
        ---原作 t=90 → t=150：亮符卡（setChapter(47) + spell(93,…) + anmPlay(0,409)）
        ---与 setInvuln(60) 由本仓库的符卡流程 / 差异 9 的计时参数接管，这里只等 60 帧。
        task.Wait(60)

        ---6 颗装饰卫星（原作 t=150 连着的 6 条 enmCreate，顺序 R2 G2 B2 R4 G4 B4）
        for _, s in ipairs(SATS) do
            New(class["th35_sat"], boss_obj, s[2], s[3], s[4], s[5], s[6], s[7])
        end

        ---主循环初值（原作 %F0 = 1.570796、%F3 = 1.0、$I2 = 160、%F2 = 96、$B/$I3 见差异 10）
        local f0 = F0_INIT
        local f3 = F3_INIT
        local i3 = I3_INIT
        local b = B_INIT

        while true do
            ---──────────── 第 1 拍 ────────────
            local i2 = I2_INIT                                   -- $I2 = 160
            f0 = gun_wave(boss_obj, "N", 2, f0, f3, AT2_BULLETS, i2, i3, F2_INIT)
            task.Wait(60)
            local f2 = F2_INIT                                   -- %F2 = 96
            f0 = f0 + PI                                         -- %F0 += π
            f0 = gun_wave(boss_obj, "2", 4, f0, f3, AT2_BULLETS, i2, i3, f2)
            task.Wait(40)
            f2 = f2 * 0.809 + f2 * 0.588                         -- %F2 = 0.809·F2 + 0.588·F2
            f0 = f0 + PI
            f0 = gun_wave(boss_obj, "2", 6, f0, f3, AT2_BULLETS, i2, i3, f2)
            task.Wait(40)
            task.Wait(b)                                         -- 收尾的 $B 帧
            if b > 60 then b = b - 10 end                        -- 第 1 拍：$B > 60 才减
            f0 = rngrad()                                        -- %F0 = %RANDRAD
            if i3 < 25 then i3 = i3 + 2 end                      -- unless (I3 < 25) I3 += 2
            f3 = -f3                                             -- %F3 *= −1

            ---──────────── 第 2 拍 ────────────
            i2 = I2_INIT                                         -- $I2 = 160
            f0 = gun_wave(boss_obj, "N", 9, f0, f3, AT2_BULLETS, i2, i3, F2_INIT)
            task.Wait(60)
            f2 = F2_INIT                                         -- %F2 = 96
            f0 = f0 + PI
            f0 = gun_wave(boss_obj, "2", 10, f0, f3, AT2_BULLETS, i2, i3, f2)
            task.Wait(40)
            f2 = f2 * 0.809 + f2 * 0.588
            f0 = f0 + PI
            f0 = gun_wave(boss_obj, "2", 8, f0, f3, AT2_BULLETS, i2, i3, f2)
            task.Wait(40)
            task.Wait(b)
            if b > 10 then b = b - 10 end                        -- Hard/Lunatic 行：$B > 10 才减
            f0 = rngrad()
            if i3 < 25 then i3 = i3 + 2 end
            f3 = -f3
        end
    end)
end

function card:frame() end
function card:render() end

function card:del()
    ---差异 7：原作 BossDead 的演出（gameSpeed、etClearAll、贴图切换、震屏、之后 40 帧
    ---flagSet(16)）大部分由本仓库的击破/换卡流程接管，这里只补一次震屏。
    misc.ShakeScreen(30, 1.5)
end

boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
