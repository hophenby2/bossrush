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

---=====================================
---TH10 stage03（河城荷取 / 中 BOSS 键山雏）与 stage04（射命丸文）符卡移植
---  仅移植 Lunatic 行（本仓库没有难度系统，th32/th34/th35 同一约定）。
---  数据来源：thtk 的 thecl 原始反汇编
---        thecl -d 10 -r -m "MAP/th10.eclm" stage03.ecl out.txt
---    ＋ TH10 1.00a 复原源码逐条核对：
---     · src/EclVm.cpp              指令时序。**关键**：每条指令有绝对 time，VM 循环
---                                  `while (time <= currentTime)`；jmp / jne 会把
---                                  currentTime **拨到目标时间**（所以回跳会重跑从目标
---                                  time 起的全部指令），wait(n) 是 currentTime -= n。
---                                  下面每张卡都按这个时序还原（`task.Wait` 的帧数 = 时间差）。
---     · src/BulletManager.cpp      SpawnSingleBullet（aim 模式 0..8 的角度公式）/
---                                  SpawnBulletPattern（index2 外层、index1 内层）
---     · src/BulletTransform.cpp    AdvanceTransformProgram（子弹 transform 程序，
---                                  最多 18 条记录，kind 表见下）
---     · src/BulletRuntime.cpp      BulletUpdateRuntime（每帧：AdvanceProgram →
---                                  各 transform 更新 → pos += vel）
---     · src/EnemyEclDispatcher.cpp etNew/etOn/etEx/etAngle/... / movePos/movePosTime/
---                                  moveRand/moveCircle/moveAdd / circlePos / laserOnA
---     · src/Enemy.cpp              EnemyRuntimeUpdate（offset/base 两路 motion；
---                                  世界位置 = base + offset；moveLimit 夹取世界位置）
---  坐标：本文件内部一律用**原作坐标**（x 以场地中心为 0、±192 = 左右边；
---  y 从上往下 0..448）；只有写进引擎时才换：
---        engine.x = x        engine.y = 224 - y        引擎速度角度 = -原作角度
---  与 1a（stage06 神奈子）那张卡共用 `class["TH35"]` 命名空间。
---=====================================
local TH10_PI = PI

---原作 EnemyWrapAngle / AddNormalizeAngle：把角度收进 [-π, π]
local function t10_wrap(a)
    while a > PI do a = a - 2 * PI end
    while a < -PI do a = a + 2 * PI end
    return a
end

---原作 y（上→下）→ 本仓库 y（中心为原点、上为正）
local function t10_oy(y) return 224 - y end

---子弹/敌机「朝向玩家」的角度（原作坐标系，y 向下）
local function t10_aim(px, py)
    local dx = player.x - px
    local dy = (224 - player.y) - py
    if dx == 0 and dy == 0 then return 1.5707964 end
    return math.atan2(dy, dx)
end

---BulletAngleDifference（BulletManager.cpp:283）
local function t10_angdiff(a, r)
    local d = a - r
    if d > PI then return a - (r + 2 * PI) end
    if r - a > PI then return a - (r - 2 * PI) end
    return d
end

local function t10_rand01() return ran:Float(0, 1) end

---=====================================
--- 一、子弹 transform 程序（BulletTransform.cpp / BulletManager.hpp 的 kind 表）
---=====================================
---kind 值（0x40000000 是 etNew 写进 transformFlags 的初值，不是 kind）
local TK_DECEL   = 0x1
local TK_VECTOR  = 0x10
local TK_POLAR   = 0x20
local TK_REL     = 0x40
local TK_AIMED   = 0x80
local TK_ABS     = 0x100
local TK_CANCEL  = 0x1000
local TK_CULL    = 0x2000
local TK_SPRITE  = 0x4000
local TK_WAIT    = 0x8000
local TK_DESPAWN = 0x10000
local TK_STATE8  = 0x4000000
local TK_SKIP    = 0x80000000
---边界反弹（BulletManager.hpp 的 BOUNCE_ALL_EDGES / _EXCEPT_BOTTOM / _VARIANT）
local TK_BOUNCE_ALL = 0x400
local TK_BOUNCE_NB  = 0x800          -- 除下边界都反弹
local TK_BOUNCE_VAR = 0x8000000
---其余 kind（2/4/8/0x100000/0x200000/0x400000/0x2000000/0x20000…）
---在复原源码的 switch 里落到 default（空操作），本文件按空操作处理。

---子弹 transform 程序最多 18 条（BulletTransform.cpp:44 `transformIndex >= 18`）
local TP_LIMIT = 18

---一条 etEx 记录：{ a=allow(0/1), k=kind, i0=int0, i1=int1, f0=float0, f1=float1 }
---kind 归一化成无符号 32 位：SKIP = 0x80000000 在 Lua 里是正数（2147483648），
---但若哪天写成负数，`k == TK_SKIP` 就会漏判（Lua 5.1 的位运算语义靠 % 2^32 兜底）。
local function tp_record(allow, kind, i0, i1, f0, f1)
    return { a = allow, k = kind % 4294967296, i0 = i0, i1 = i1, f0 = f0, f1 = f1 }
end

---把子弹自己的 transform 更新推进一条记录。
---返回 true 表示消化了一条（调用方继续），false 表示停在这里。
---（AdvanceTransformProgram 的语义：kind==0 停；allow==0 且已有激活 transform 时停）
local function t10_tp_advance(b)
    local stopped = false
    while b.ti < TP_LIMIT do
        local r = b.tp[b.ti + 1]
        if r == nil or r.k == 0 then
            stopped = true
            break
        end
        if r.a == 0 and next(b.af) ~= nil then
            stopped = true
            break
        end
        b.ti = b.ti + 1
        local k = r.k
        if k == TK_SKIP then
            -- BULLET_TRANSFORM_SKIP：本记录不下发动作，直接读下一条
            -- （BulletTransform.cpp:44-50 `++transformIndex; goto nextRecord;`）
        elseif k == TK_DECEL then
            b.af.decel = true
            b.st.decel = { t = 0 }
        elseif k == TK_VECTOR then
            b.af.vec = true
            local a = (r.f1 <= -990) and b.angle or ((r.f1 < 990) and r.f1 or t10_aim(b.px, b.py))
            b.st.vec = { t = 0, i0 = r.i0, v0 = r.f0,
                         vx = math.cos(a) * r.f0, vy = math.sin(a) * r.f0 }
        elseif k == TK_POLAR then
            b.af.polar = true
            b.st.polar = { t = 0, i0 = r.i0, v0 = r.f0, v1 = r.f1 }
        elseif k == TK_REL or k == TK_AIMED or k == TK_ABS then
            b.af.dir = k
            b.st.dir = { t = 0, i0 = r.i0, i1 = r.i1, i2 = 0,
                         v1 = (r.f0 <= -990) and b.angle or ((r.f0 < 990) and r.f0 or t10_aim(b.px, b.py)),
                         v0 = (r.f1 > -999) and r.f1 or b.speed }
        elseif k == TK_CANCEL then
            b.cancel = r.i0
        elseif k == TK_CULL then
            b.cull = r.i0
        elseif k == TK_SPRITE then
            -- 视觉代理：TH10 换弹贴图，本仓库统一 ball_mid ⇒ 只记颜色
            b.color = r.i1
            if b.eb then b.eb.th10_color = r.i1 end
        elseif k == TK_WAIT then
            b.af.wait = true
            b.st.wait = { t = r.i0 }
        elseif k == TK_DESPAWN then
            b.dead = true
        elseif k == TK_STATE8 then
            b.af.state8 = true
            b.st.state8 = { t = 0, i0 = r.i0, v0 = r.f0, v1 = r.f1 }
        elseif k == TK_BOUNCE_ALL or k == TK_BOUNCE_NB or k == TK_BOUNCE_VAR then
            -- BulletTransform.cpp：value0 = float0（反弹后速度，-999999 = 不变）、
            -- int1 = int0（最多反弹几次）、int0 = 0（已反弹次数）
            b.af.bounce = k
            b.st.bounce = { n = 0, max = r.i0, v0 = r.f0 }
        end
    end
    return not stopped
end

---每帧的 transform 状态更新（顺序照 BulletRuntime.cpp:88-120）
local function t10_tp_tick(b)
    -- 1 DECELERATE
    if b.af.decel then
        local s = b.st.decel
        if s.t <= 16 then
            local m = (5.0 - s.t * 0.3125) + b.speed
            b.vx, b.vy = math.cos(b.angle) * m, math.sin(b.angle) * m
        else
            b.af.decel = nil
        end
        s.t = s.t + 1
    end
    -- 2 ACCELERATE_VECTOR
    if b.af.vec then
        local s = b.st.vec
        if s.t < s.i0 then
            b.speed = b.speed + s.v0
            b.vx = b.vx + s.vx
            b.vy = b.vy + s.vy
            if math.abs(b.vx) > 0.0001 or math.abs(b.vy) > 0.0001 then
                b.angle = math.atan2(b.vy, b.vx)
            end
        else
            b.af.vec = nil
        end
        s.t = s.t + 1
    end
    -- 3 ACCELERATE_POLAR
    if b.af.polar then
        local s = b.st.polar
        if s.t < s.i0 then
            b.angle = t10_wrap(b.angle + s.v1)
            b.speed = b.speed + s.v0
            b.vx, b.vy = math.cos(b.angle) * b.speed, math.sin(b.angle) * b.speed
        else
            b.af.polar = nil
        end
        s.t = s.t + 1
    end
    -- 4/5/6 CHANGE_DIRECTION（relative / absolute / aimed，共用同一个状态槽）
    if b.af.dir then
        local s = b.st.dir
        local mode = b.af.dir
        local spd
        if s.t >= s.i0 then
            s.i2 = s.i2 + 1
            if s.i2 >= s.i1 then b.af.dir = nil end
            if mode == TK_REL then
                b.angle = b.angle + s.v1
                b.speed = s.v0
            elseif mode == TK_ABS then
                b.angle = s.v1
                b.speed = s.v0
            else
                b.angle = t10_wrap(t10_aim(b.px, b.py) + s.v1)
                b.speed = s.v0
            end
            spd = b.speed
            s.t = 0
        else
            spd = b.speed - b.speed * s.t / s.i0
        end
        b.vx, b.vy = math.cos(b.angle) * spd, math.sin(b.angle) * spd
        s.t = s.t + 1
    end
    -- 7 BOUNDARY_BOUNCE（BulletManager.cpp:345 UpdateBoundaryBounce）
    --   判定用「本帧开始时的位置」；命中的边界：x 左右都反弹，y 只有上边界
    --   （ALL_EDGES 才连下边界），VARIANT 连上边界都不反弹。
    --   反射公式照原作：x: -384-x / 384-x，y: -y / 896-y（左右/上下场边各 ±192、0、448）。
    if b.af.bounce then
        local s = b.st.bounce
        local L, R, T, BOT = -192, 192, 0, 448
        local x, y = b.px, b.py
        if x <= L or x >= R or y <= T or y >= BOT then
            local bounced = 0
            if x < L or x >= R then
                b.angle = t10_wrap(-b.angle - PI)
                bounced = 1
                if x < L then b.px = -384 - x else b.px = 384 - x end
            end
            if b.af.bounce ~= TK_BOUNCE_VAR and
               (y < T or (y >= BOT and b.af.bounce == TK_BOUNCE_ALL)) then
                bounced = 1
                b.angle = -b.angle
                if y < T then b.py = -y else b.py = (BOT - y) + BOT end
            end
            if s.v0 > -990 then b.speed = s.v0 end
            b.vx, b.vy = math.cos(b.angle) * b.speed, math.sin(b.angle) * b.speed
            if bounced ~= 0 then s.n = s.n + 1 end
            if s.n >= s.max then b.af.bounce = nil end
            b.hit = true
        end
    end
    -- 8 STATE8（朝目标角缓转，BulletManager.cpp:481）
    if b.af.state8 then
        local s = b.st.state8
        if s.t >= s.i0 then
            b.af.state8 = nil
        else
            local want = t10_wrap(s.v1 + t10_aim(b.px, b.py))
            b.angle = t10_wrap(b.angle + t10_angdiff(want, b.angle) * s.v0)
            b.vx, b.vy = math.cos(b.angle) * b.speed, math.sin(b.angle) * b.speed
        end
        s.t = s.t + 1
    end
    -- 9 WAIT
    if b.af.wait then
        local s = b.st.wait
        if s.t <= 0 then b.af.wait = nil else s.t = s.t - 1 end
    end
end

---弹本体每帧钩子：跑 TH10 的 transform 程序，然后把速度写回引擎
---（引擎在本钩子之后做 pos += vel，与原作「先更新各 transform、再 pos += vel」一致）
local function t10_bullet_frame(self)
    local b = self.tb
    b.px, b.py = self.x, t10_oy(self.y)
    b.hit = false
    t10_tp_advance(b)
    if next(b.af) ~= nil then t10_tp_tick(b) end
    if b.hit then self.x, self.y = b.px, t10_oy(b.py) end
    if b.dead then object.RawDel(self) return end
    local mag = math.sqrt(b.vx * b.vx + b.vy * b.vy)
    if mag > 0.0001 then
        object.SetV(self, mag, -math.atan2(b.vy, b.vx) * RAD, true)
    else
        object.SetV(self, 0, 0, true)
    end
end

---=====================================
--- 二、弹幕 pattern（EnemyEclDispatcher 的 et* 指令）
---=====================================
---pattern 槽位：0..7；每槽 18 条 etEx 记录
local function pat_new()
    return {
        type = 1, color = 1,
        angle = 0, astep = 0, s1 = 1, s2 = 1,
        c1 = 1, c2 = 1, aim = 0,
        tf = 0x40000000, ox = 0, oy = 0,
        ex = {},
    }
end

---etNew：整套清零并写初值（EnemyEclDispatcher INITIALIZE_BULLET_PATTERN）
local function et_new(e, slot)
    e.pat[slot] = pat_new()
end

---etCopy(dst, src)：整槽复制（含 18 条记录）
local function et_copy(e, dst, src)
    local d, s = e.pat[dst], e.pat[src]
    d.type, d.color = s.type, s.color
    d.angle, d.astep = s.angle, s.astep
    d.s1, d.s2 = s.s1, s.s2
    d.c1, d.c2, d.aim = s.c1, s.c2, s.aim
    d.tf, d.ox, d.oy = s.tf, s.ox, s.oy
    d.ex = {}
    for i, r in pairs(s.ex) do
        d.ex[i] = { a = r.a, k = r.k, i0 = r.i0, i1 = r.i1, f0 = r.f0, f1 = r.f1 }
    end
end

local function et_sprite(e, slot, sp, col)
    e.pat[slot].type = sp
    e.pat[slot].color = col
end
local function et_offset(e, slot, x, y)
    e.pat[slot].ox, e.pat[slot].oy = x, y
end
local function et_angle(e, slot, a, step)
    e.pat[slot].angle, e.pat[slot].astep = a, step
end
local function et_speed(e, slot, s1, s2)
    e.pat[slot].s1, e.pat[slot].s2 = s1, s2
end
local function et_count(e, slot, c1, c2)
    e.pat[slot].c1, e.pat[slot].c2 = c1, c2
end
local function et_aim(e, slot, m)
    e.pat[slot].aim = m
end
local function et_ex(e, slot, rec, allow, kind, i0, i1, f0, f1)
    e.pat[slot].ex[rec] = tp_record(allow, kind, i0, i1, f0, f1)
end

---弹样式代理：本仓库没有 TH10 弹贴图 ⇒ 一律 ball_mid（差异：原作 etSprite 的第 1 参是
---精灵号，第 2 参是色号；这里只保留色号，色号 0 会被夹到 1）。
local function t10_color(c)
    if c == nil or c < 1 then return 1 end
    if c > 16 then return 16 end
    return c
end

---生成一发弹（SpawnSingleBullet）
local function t10_spawn_one(p, sx, sy, i1, i2, a2p)
    local speed
    if p.c2 > 1 then
        speed = p.s1 - (p.s1 - p.s2) * i2 / p.c2
    else
        speed = p.s1
    end
    local angle = 0
    local m = p.aim
    if m == 0 or m == 1 then
        if p.c1 % 2 ~= 0 then
            angle = angle + math.floor((i1 + 1) / 2) * p.astep
        else
            angle = angle + math.floor(i1 / 2) * p.astep + p.astep * 0.5
        end
        if i1 % 2 ~= 0 then angle = -angle end
        if m == 0 then angle = angle + a2p end
        angle = angle + p.angle
    elseif m == 2 or m == 3 then
        if m == 2 then angle = a2p end
        angle = angle + i1 * 2 * PI / p.c1
        angle = angle + i2 * p.astep + p.angle
    elseif m == 4 or m == 5 then
        if m == 4 then angle = a2p end
        angle = angle + PI / p.c1
        angle = angle + i1 * 2 * PI / p.c1
        angle = angle + p.angle
    elseif m == 6 then
        angle = ran:Float(p.angle - p.astep, 0) + p.astep
    elseif m == 7 then
        speed = ran:Float(p.s1 - p.s2, 0) + p.s2
        angle = angle + i1 * 2 * PI / p.c1 + i2 * p.astep + p.angle
    elseif m == 8 then
        angle = ran:Float(p.angle - p.astep, 0) + p.astep
        speed = ran:Float(p.s1 - p.s2, 0) + p.s2
    end
    local b = NewSimpleBullet(ball_mid, t10_color(p.color),
            sx, t10_oy(sy), 0, 0, false, 0, false, true, nil, nil, t10_bullet_frame)
    local tp = {}
    for k = 0, TP_LIMIT - 1 do
        local r = p.ex[k]
        if r then tp[k + 1] = { a = r.a, k = r.k, i0 = r.i0, i1 = r.i1, f0 = r.f0, f1 = r.f1 }
        else tp[k + 1] = nil end
    end
    b.tb = {
        px = sx, py = sy, angle = angle, speed = speed,
        vx = math.cos(angle) * speed, vy = math.sin(angle) * speed,
        tp = tp, ti = 0, af = {}, st = {}, cull = 10, cancel = 0,
        eb = b,
    }
    b.t10_color = p.color
    -- 原作在生成当帧就 AdvanceTransformProgram 一次（BulletManager.cpp:767）
    t10_tp_advance(b.tb)
    return true
end

---etOn：按当前 pattern 生成一波（index2 外层、index1 内层）
local function et_on(e, slot)
    local p = e.pat[slot]
    local sx, sy = e.ecs.wx + p.ox, e.ecs.wy + p.oy
    local a2p = t10_aim(sx, sy)
    for i2 = 0, p.c2 - 1 do
        for i1 = 0, p.c1 - 1 do
            t10_spawn_one(p, sx, sy, i1, i2, a2p)
        end
    end
end

---=====================================
--- 二·五、原生卡片接口（TH10 stage03/04 用）
---  一张「枪」就是一个普通 Lua 函数：用 task.Wait 计时、用 fire 出一波弹、
---  用 spawn_pod 叫子机。fire 的 cfg 就是原作某一组
---  `etNew/etAim/etSprite/etCount/etAngle/etSpeed/etOffset/etEx` + `etOn`
---  —— 用 Lua 表写，不再经过指令表/解释器。
---
---  cfg 字段（缺省即原作的初值）：
---    slot   0..7           pattern 槽（默认 0）
---    aim    0..8           瞄准模式（0 自机+扇形、1 固定角+扇形、2/3 圆环、4/5 环、
---                          6 随机角、7/8 随机角+随机速）
---    sprite {精灵号, 色号}  移植版只保留色号
---    count  {c1, c2}       内层发数 / 外层圈数
---    angle, astep          基准角（弧度，原作 y 向下） / 角步长
---    speed  {s1, s2}       初速 / 末速（c2>1 时按层插值）
---    off    {x, y}         相对敌机的出弹点
---    steps  {{allow, kind, i0, i1, f0, f1}, ...}   子弹 transform 程序
---=====================================
---fire_slot = 原作 etOn：按槽里**当前**配置打一波
local function fire_slot(o, slot)
    local p = o.pat[slot or 0]
    local sx, sy = o.ecs.wx + p.ox, o.ecs.wy + p.oy
    local a2p = t10_aim(sx, sy)
    for i2 = 0, p.c2 - 1 do
        for i1 = 0, p.c1 - 1 do
            t10_spawn_one(p, sx, sy, i1, i2, a2p)
        end
    end
end

---fire = 原作 etNew + 配置 + etOn：清空该槽、按 cfg 配置、打一波
local function fire(o, cfg)
    local slot = cfg.slot or 0
    local p = pat_new()
    o.pat[slot] = p
    if cfg.sprite then p.type, p.color = cfg.sprite[1], cfg.sprite[2] end
    if cfg.aim ~= nil then p.aim = cfg.aim end
    if cfg.count then p.c1, p.c2 = cfg.count[1], cfg.count[2] end
    if cfg.angle ~= nil then p.angle = cfg.angle end
    if cfg.astep ~= nil then p.astep = cfg.astep end
    if cfg.speed then p.s1, p.s2 = cfg.speed[1], cfg.speed[2] end
    if cfg.off then p.ox, p.oy = cfg.off[1], cfg.off[2] end
    if cfg.steps then
        for i, r in ipairs(cfg.steps) do
            p.ex[i - 1] = tp_record(r.allow or 0, r.kind or 0,
                    r.i0 or -999999, r.i1 or -999999, r.f0 or -999999, r.f1 or -999999)
        end
    end
    fire_slot(o, slot)
end

---=====================================
--- 三、敌机两路 motion（Enemy.cpp EnemyRuntimeUpdate + EnemyEclDispatcher move*）
---   · 世界位置 = base + offset；写出时 engine.y = 224 - world.y
---   · 通道 ch 的字段：位置 x/y、速度 (vx,vy)、极坐标 (ang,spd)、
---     圆运动 (circle, cx/cy 圆心, r 半径, rv 半径速, cav 角速)、
---     位置插值 interp、极坐标插值 scal
---=====================================
local function ch_new()
    return { x = 0, y = 0, vx = 0, vy = 0, ang = 0, spd = 0,
             circle = false, cx = 0, cy = 0, r = 0, rv = 0, cav = 0,
             interp = nil, scal = nil }
end

local function ch_step(ch)
    if ch.scal then
        local s = ch.scal
        local n = (s.dur <= 0) and 1 or math.min(1, s.t / s.dur)
        ---%s.a1 存在时角也一起插值（moveVelTime：原作对「角, 速度」两条都插值）
        if s.a1 ~= nil then ch.ang = s.a0 + (s.a1 - s.a0) * n else ch.ang = s.a0 end
        ch.spd = s.s0 + (s.s1 - s.s0) * n
        s.t = s.t + 1
        if s.t > s.dur then ch.scal = nil end
    end
    if ch.interp then
        local it = ch.interp
        local n = (it.dur <= 0) and 1 or math.min(1, it.t / it.dur)
        local tx = it.x0 + (it.x1 - it.x0) * n
        local ty = it.y0 + (it.y1 - it.y0) * n
        ch.vx, ch.vy = tx - ch.x, ty - ch.y
        it.t = it.t + 1
        if it.t > it.dur then ch.interp = nil end
    elseif ch.circle then
        ch.r = ch.r + ch.rv
        ch.ang = t10_wrap(ch.ang + ch.cav)
        ch.vx = (ch.cx + ch.r * math.cos(ch.ang)) - ch.x
        ch.vy = (ch.cy + ch.r * math.sin(ch.ang)) - ch.y
    else
        ch.vx, ch.vy = math.cos(ch.ang) * ch.spd, math.sin(ch.ang) * ch.spd
    end
    ch.x = ch.x + ch.vx
    ch.y = ch.y + ch.vy
end

local function ecs_attach(o, x, y)
    o.ecs = { base = ch_new(), off = ch_new(), wx = x, wy = y, lim = nil }
    ---★ 原作 EnemySpawn 把出生点写进 **offsetMotion.position**（Enemy.cpp:1402），
    ---base 保持 (0,0)；世界位置 = base + offset。之后 movePos/movePosTime
    ---（SET/INTERPOLATE_OFFSET_*）改的也是这一路，movePosRel* 才改 base。
    ---所以出生点必须落在 off；放进 base 会让「先 enmCreate 再有 movePos」的子机
    ---把出生点当成原点、位置整体平移（BossCard3_at2 这类就会错位）。
    o.ecs.off.x, o.ecs.off.y = x, y
    o.pat = {}
    for i = 0, 7 do o.pat[i] = pat_new() end
    o.I0, o.I1, o.I2, o.I3 = 0, 0, 0, 0
    o.F0, o.F1, o.F2, o.F3 = 0, 0, 0, 0
    o.tx, o.ty = x, y
end

local function ecs_sync(o)
    local w = o.ecs
    w.wx, w.wy = w.base.x + w.off.x, w.base.y + w.off.y
    o.tx, o.ty = w.wx, w.wy
    o.x, o.y = w.wx, t10_oy(w.wy)
end

local function ecs_step(o)
    local w = o.ecs
    ch_step(w.base)
    ch_step(w.off)
    local wx, wy = w.base.x + w.off.x, w.base.y + w.off.y
    local L = w.lim
    if L then
        local minx, maxx = L.cx - L.w * 0.5, L.cx + L.w * 0.5
        local miny, maxy = L.cy - L.h * 0.5, L.cy + L.h * 0.5
        if wx < minx then wx = minx elseif wx > maxx then wx = maxx end
        if wy < miny then wy = miny elseif wy > maxy then wy = maxy end
        w.off.x, w.off.y = wx - w.base.x, wy - w.base.y
    end
    w.wx, w.wy = wx, wy
    o.tx, o.ty = wx, wy
    o.x, o.y = wx, t10_oy(wy)
end

local function M(o, w) return w == "off" and o.ecs.off or o.ecs.base end

local function m_pos(o, w, x, y)
    local ch = M(o, w)
    if x > -999999 then ch.x = x end
    if y > -999999 then ch.y = y end
    ch.circle, ch.interp, ch.scal = false, nil, nil
    ecs_sync(o)
end

local function m_pos_time(o, w, dur, mode, x, y)
    local ch = M(o, w)
    ch.interp = { t = 0, dur = dur, mode = mode, x0 = ch.x, y0 = ch.y,
                  x1 = (x > -999999) and x or ch.x, y1 = (y > -999999) and y or ch.y }
    ch.circle, ch.scal = false, nil
end

---moveCircle / moveCircleRel：第一次调用时把当前位置存成圆心
local function m_circle(o, w, a, av, r, rv)
    local ch = M(o, w)
    if not ch.circle then ch.cx, ch.cy = ch.x, ch.y end
    ch.circle, ch.interp, ch.scal = true, nil, nil
    ch.ang, ch.cav, ch.r, ch.rv = a, av, r, rv
end

---moveVel / moveVelRel：SET_OFFSET_POLAR / SET_BASE_POLAR —— 只设（角, 速度），
---本帧不动位置，下一帧起按极速度前进（EnemyEclDispatcher.cpp:1713）。
---参数 > -999999 才写入，否则保持原值（原作 -999999 表示「不改」）。
local function m_vel(o, w, ang, spd)
    local ch = M(o, w)
    if ang > -999999 then ch.ang = ang end
    if spd > -999999 then ch.spd = spd end
    ch.circle, ch.interp, ch.scal = false, nil, nil
end

---moveVelTime / moveVelRelTime：INTERPOLATE_OFFSET_POLAR —— 对（角, 速度）插值
---（EnemyEclDispatcher.cpp:1735；角差先折进 ±π，与原作一致）。本仓库 mode 一律按线性近似。
local function m_vel_time(o, w, dur, mode, ang, spd)
    local ch = M(o, w)
    local a0, a1 = ch.ang, ch.ang
    if ang > -999999 then
        a1 = ang
        if math.abs(a0 - a1) >= PI then
            if a1 <= a0 then a1 = a1 + 2.0 * PI else a0 = a0 + 2.0 * PI end
        end
    end
    local s0 = ch.spd
    local s1 = (spd > -999999) and spd or ch.spd
    ch.scal = { t = 0, dur = dur, mode = mode, a0 = a0, a1 = a1, s0 = s0, s1 = s1 }
    ch.circle, ch.interp = false, nil
end

local function m_add(o, w, x, y, z)
    local ch = M(o, w)
    ch.x = ch.x + x
    ch.y = ch.y + y
    ecs_sync(o)
end

---moveRand：按「离边框远近」选随机方向，然后速度线性降到 0（EnemyEclDispatcher:1946）
local function m_rand(o, w, dur, mode, speed)
    local ch = M(o, w)
    local cx, cy, bw, bh = 0, 224, 384, 448
    local a
    if ch.x >= cx - bw * 0.25 and ch.x <= cx + bw * 0.25 then
        if ch.x < player.x then
            a = t10_rand01() * (PI / 2)
        else
            a = t10_wrap(t10_rand01() * (PI / 2) + PI)
        end
    elseif ch.x > cx + bw * 0.25 then
        a = t10_wrap(t10_rand01() * (PI / 3) + PI)
    else
        a = t10_rand01() * (PI / 3)
    end
    if ch.y >= cy - bh * 0.25 then
        if ch.y > cy + bh * 0.25 then a = -math.abs(a) end
    else
        a = math.abs(a)
    end
    ch.scal = { t = 0, dur = dur, a0 = a, s0 = speed, s1 = 0 }
    ch.circle, ch.interp = false, nil
    ch.ang, ch.spd = a, speed
end

local function m_limit(o, cx, cy, sx, sy)
    o.ecs.lim = { cx = cx, cy = cy, w = sx, h = sy }
end
local function m_limit_clear(o) o.ecs.lim = nil end

---circlePos(&x, &y, angle, radius)：极坐标 → 直角坐标（原作 y 向下）
local function circle_pos(angle, r) return math.cos(angle) * r, math.sin(angle) * r end

---=====================================
--- 四、敌机/子机载体（enmCreate / enmCreateA）
---   TH10 的 enmCreate 会把创建者那 8 个 $I0..$I3 / %F0..%F3 整块拷给子机。
---   ★ 原生版没有「名字 → 指令表」这一步：子机的协程体直接是 Lua 函数，
---     用 `spawn_pod`（enmCreateA，绝对坐标）/ `spawn_pod_rel`（enmCreate，相对坐标）创建。
---=====================================
---本关所有 ECL 子机（含每个 BOSS 的载体）。卡片结束时统一清掉，
---否则枪/使魔会跨卡残留（原作靠 killAllAsync/enmKillAll + 敌机系统回收）。
local T10_PODS = {}
local function t10_track(o) T10_PODS[#T10_PODS + 1] = o end

---停掉一个 ECL 载体：先清掉挂在它名下的协程，再删对象。
---★ 真引擎删对象时会连带停掉它的 task；自检工具的调度器不看对象死活，
---  只删对象的话子机 ECL 会继续跑（表现为「卡结束后还在造弹」——del 没清干净）。
local function t10_kill_pod(o)
    if o == nil then return end
    task.Clear(o)
    if IsValid(o) then object.RawDel(o) end
end

local function t10_clear_pods()
    for i = 1, #T10_PODS do
        t10_kill_pod(T10_PODS[i])
    end
    T10_PODS = {}
end

---enmKillAll：清掉当前所有 ECL 子机（可保留一个调用者）。
local function t10_enm_kill_all(keep)
    for i = 1, #T10_PODS do
        local o = T10_PODS[i]
        if o ~= keep then t10_kill_pod(o) end
    end
    T10_PODS = {}
    if keep ~= nil and IsValid(keep) then T10_PODS[1] = keep end
end

---spawn_pod / spawn_pod_rel：叫一个 ECL 子机（原名 enmCreateA / enmCreate）。
---参数是**原生 Lua 函数**（子机自己的协程体），不是指令表里的名字。
local function spawn_pod(o, x, y, fn)
    local p = New(class["th10_ecs_pod"], o, x, y, fn)
    t10_track(p)
    return p
end
local function spawn_pod_rel(o, dx, dy, fn)
    return spawn_pod(o, o.ecs.wx + dx, o.ecs.wy + dy, fn)
end

class["th10_ecs_pod"] = Class(object, {
    init = function(self, origin, x, y, sub)
        self.x, self.y = x, t10_oy(y)
        self.hide = true
        self.group, self.layer = GROUP.ENEMY, LAYER.ENEMY
        self.colli, self.bound, self.navi = false, false, false
        ---★ 绝不能写 self.vx/self.vy：引擎对**所有** object 每帧做 x += vx
        ---（LuaSTG-Sub GameObject.cpp:330）。位置只由 ecs_step 写。
        ecs_attach(self, x, y)
        if origin then
            self.I0, self.I1, self.I2, self.I3 = origin.I0, origin.I1, origin.I2, origin.I3
            self.F0, self.F1, self.F2, self.F3 = origin.F0, origin.F1, origin.F2, origin.F3
        end
        ---task.New 的协程体不带参数，必须用闭包捕获 self。
        task.New(self, function() sub(self) end)
    end,
    frame = function(self)
        ---★ 原作 EnemyRuntimeUpdate 的顺序是「先解两路 motion 得到世界位置，再跑 ECL」
        ---（Enemy.cpp:779-797 推进 motion → 862 EnemyRunEcl）。所以这里先 ecs_step 再
        --- task.Do；ECL 里的 etOn 才会用在**本帧已推进**的位置出弹。反过来做会整体
        --- 差一帧（子机刚 movePos 就出弹、以及 moveRand 的起始位置都会错）。
        ecs_step(self)
        task.Do(self)
        ---%TIME = runtime.updateTimer.current：原作在 EnemyRuntimeUpdate 的**末尾**自增
        ---（Enemy.cpp:1039），所以本帧 ECL 读到的还是上一帧末的值 ⇒ 计数器在 task.Do
        ---之后才加。stage07 的祟符「ミシャグジさま」用 %TIME 分阶段，必须照抄。
        self.__t10frames = (self.__t10frames or 0) + 1
        ---BOSS 载体：把 BOSS 本体钉在 ECL 位置上。
        ---（守卫直接写在 self.th10_boss 上：T10 载体是可选绑定，字段审计据此判定 init 无赋值也安全。）
        if self.th10_boss and IsValid(self.th10_boss) then
            self.th10_boss.x, self.th10_boss.y = self.x, self.y
        end
    end,
})

---=====================================
--- 五、ECL 运行时辅助
---   ★ 时钟语义（EclVm.cpp:695-800, 1218）——上面每张卡的 task.Wait 都是照着它写死的：
---     VM 每帧 `while (指令时间 <= clock) 执行`，帧尾 `clock += 1`；`jmp(L, T)` /
---     `jmpNeq(L, T)` **把 clock 直接赋成 T**（目标标签的绝对时间），`wait(n)` 是
---     `clock -= n`（SUBTRACT_TIME）。⇒ 同一时间组的指令在同一帧连续执行；只有
---     「下一条指令的时间 > clock」时才真正等待；向后回跳 + wait 的组合会因为
---      `while` 条件而被挡住，所以 `wait(n); jmp(...)` 的 n 帧一定是等满的。
---=====================================

---随机数辅助（对应原作的 %RANDF / %RANDF2 / %RANDRAD / %RAND）
local function rnd() return ran:Float(0, 1) end          -- %RANDF
local function rnd2() return ran:Float(-1, 1) end        -- %RANDF2
local function rndrad() return ran:Float(-PI, PI) end    -- %RANDRAD

---原作 `delete`：子机自毁
---delete：敌机自毁，连同它名下所有 ECL 线程一起停掉（原作 delete 就是销毁该敌机）。
local function t10_delete(o) t10_kill_pod(o) end

---原作 laserOnA(color, type, angle, speed, initLen, maxLen, term, width)
---（EnemyEclDispatcher FIRE_LASER_A 的字段布局：angle@0x0c / max@0x10 / init@0x14 /
---  term@0x18 / width@0x1c / speed@0x20）。用 THlib 的 laser 画一根逐渐变长的直线光柱。
local th10_laser = Class(laser, {
    init = function(self, x, y, ang, initlen, maxlen, speed, width)
        laser.init(self, 1, x, y, -ang * RAD, 0, 0, 1, width or 32, 0, 0)
        ---基准宽度：laser.init 已按第 8 参设好 w0（THlib/laser/laser.lua:51），
        ---这里显式再写一次——frame 每帧要用它还原 self.w，也让字段审计看到 init 顶层赋值。
        self.w0 = width or 32
        self.t10_len = initlen
        self.t10_max = maxlen
        self.t10_spd = speed
        self.t10_life = math.floor((maxlen - initlen) / (speed > 0 and speed or 1)) + 30
        self.colli = true
        self.bound = false
        self.alpha = 1
        self.w = width or 32
        self.logclass = nil
    end,
    frame = function(self)
        self.t10_len = math.min(self.t10_max, self.t10_len + self.t10_spd)
        self.l1, self.l2, self.l3 = 0, 0, self.t10_len
        self.w = self.w0
        laser.frame(self)
        if self.timer > self.t10_life then object.RawDel(self) end
    end,
})

---laserOnA：在敌机世界位置生成一根光柱（原作 y 向下 ⇒ 引擎角度取负）
local function t10_laser_on(o, color, kind, ang, speed, initlen, maxlen, term, width)
    local wx, wy = o.ecs.wx, o.ecs.wy
    New(th10_laser, wx, t10_oy(wy), ang, initlen, maxlen, speed, width)
end

---moveLimit：把世界位置夹进 [center ± size/2]（原作 moveLimit）
---（已有的 m_limit/m_limit_clear 即此）

---BOSS 载体：给 BOSS 挂 ecs 并起一个协程跑主 ECL。
local function t10_boss_start(b, main)
    local p = New(class["th10_ecs_pod"], nil, 0, 0, main)
    p.th10_boss = b
    ---BOSS 出生点 = 当前的屏幕位置（原作出生时也把位置写进 offsetMotion）。
    ---y 从本仓库坐标换回原作坐标（224 − engine.y）。
    p.ecs.off.x, p.ecs.off.y = b.x, 224 - b.y
    ecs_sync(p)
    b.th10carrier = p
    t10_track(p)
    return p
end

---callAsync：在**同一敌机**上另起一个线程（共享 pattern 与全局变量）。
---参数是**原生 Lua 函数**（跟 spawn_pod 一样，不是指令表里的名字）。
local function t10_call_async(o, fn)
    task.New(o, function() fn(o) end)
end

---killAllAsync：原作 ECL_VM_STOP_ALL_THREADS 停掉本敌机的其它线程（保留当前）。
---THlib 的 task.Clear(o, true) 正好是「除当前协程外全部丢掉」。
local function t10_kill_async(o) task.Clear(o, true) end

---%ANGLE_PLAYER：从 **offsetMotion.position** 到自机的角度（Enemy.cpp:620）。
local function t10_angle_player(o) return t10_aim(o.ecs.wx, o.ecs.wy) end

---%FINAL_ANGLE：本帧的**世界位移角**（Enemy.cpp:615 取 base.v + offset.v 的 atan2）。
---★ 不是极坐标速度角：movePos/moveCircle 走插值时两者会不同，stage07 BossCard9 用它定弹向。
local function t10_final_angle(o)
    local b, f = o.ecs.base, o.ecs.off
    return math.atan2(b.vy + f.vy, b.vx + f.vx)
end

---ECL 时钟辅助：对应 VM 的「if 指令时间 > clock then task.Wait(指令时间 - clock)」。
---原作 EclVm 里 wait(n) 是 clock -= n（不占帧），jmp/jmpNeq(L, T) 把 clock 直接设成 T；
---原生代码每一步都显式写 ct，才保证与逐条 VM（以及真引擎）的帧边界完全一致。
local function s_wait(ct, t)
    if t > ct then task.Wait(t - ct) end
    return t
end

---特殊敌机（= BOSS 本体）的世界 y：原作 %BOSS_Y（Enemy.cpp 的
---ENEMY_ECL_OPERAND_SPECIAL_ENEMY_Y = specialEnemySlots[0]->worldMotion.position.y）。
---BOSS 载体在注册时把 t10_bossref 指向自己，enmCreate 再传给子机。
local function s_boss_y(o)
    local b = o.t10_bossref
    if b == nil then return 0.0 end
    return b.ecs.wy
end

---callAsync：在同一敌机上另起线程并把实参投给它（原作 callAsync(name, a0, a4…)）
local function s_async(o, fn, a0, a4)
    task.New(o, function() fn(o, a0, a4) end)
end

---enmCreate（相对坐标）+ 把 BOSS 引用传给子机（%BOSS_X/%BOSS_Y 要用）
local function s_pod(origin, dx, dy, fn)
    local p = spawn_pod_rel(origin, dx, dy, fn)
    p.t10_bossref = origin.t10_bossref
    return p
end

---=====================================
---=====================================
---TH10 stage03 / stage04 符卡（原生 LuaSTG 实现，仅 Lunatic 行）
---  组 2a = stage03 中 BOSS 河城荷取（光学「ハイドロカモフラージュ」）
---  组 3a = stage03 BOSS    河城荷取（漂溺 / 水符 / 河童）
---  组 4a = stage04 BOSS    射命丸文（岐符 / 風神 / 無双風神 / 塞符）
---
---移植方法：**不用 ECL 字节码 VM**（旧版那种「指令表 + 栈式解释器」整个废弃），跟本文件
---  上面 stage06 的手写卡、以及 mod/GAME/th31.lua / th32「红色的幻想乡」同一套 —— 逐张读
---  thecl 的原始反汇编
---      thecl -d 10 -r -m "MAP/th10.eclm" stage03.ecl out.txt
---      thecl -d 10 -r -m "MAP/th10.eclm" stage04.ecl out.txt
---  ＋ TH10 1.00a 复原源码（src/EclVm.cpp / EnemyEclDispatcher.cpp / Enemy.cpp /
---    BulletManager.cpp / BulletTransform.cpp），把每条指令的语义翻成**原生 LuaSTG 代码**：
---    `task.Wait` 计时、`fire` / `fire_slot` 出一波弹、`spawn_pod` / `spawn_pod_rel` 叫子机、
---    `m_pos` / `m_pos_time` / `m_circle` / `m_rand` 走位、`t10_laser_on` 放光柱。
---  **本段不参考 mod/GAME/th10.lua**（那不是 ECL 实现）。
---
---几条贯穿全段的换算（每张卡都靠它们，改代码前先读）：
---  · 坐标：TH10 场地 384×448、左上原点、y 朝下；我们原点在场地中心、y 朝上。
---    换算是纯平移 + y 翻转、**没有缩放**：x_我们 = x_原作、y_我们 = 224 − y_原作、
---    角度整体取负。上面的 ecs 运行时（t10_oy / m_pos / et_*）内部一律用**原作坐标**，
---    所以下面所有 movePos / enmCreateA / circlePos 的数字都是**原作坐标**。
---  · 难度：原作每条指令带 rank 标记（!E !N !H !L，`!*` = 全难度执行）。本段**只搬
---    Lunatic 行**：`diffI/diffF` 取第 4 项、`diffWait` 取 L 的帧数、
---    `if ($DIFF …)` 一律按 $DIFF = 3（Lunatic）求值。
---  · 时间：`jmp(label, T)` 把 ECL 时钟**直接赋成目标标签的绝对时间**（可以回拨，回拨就是
---    「同一帧继续」）；`wait(n)` 是时钟 −n，`diffWait(…, L)` 同理。翻成原生代码后：
---      – 相邻两条指令的时间差 = 它们之间的 `task.Wait`；
---      – 「回跳到更早的时间」= 原生循环回到本轮开头（**同一帧**继续，不再等）；
---      – `diffWait(…, L)` = 在它**后面**那条指令之前补一个 `task.Wait(L)`。
---    每个循环里都标了原作的时间轴（`+7: //7` 这种），改速度 / 间隔前先读那几行。
---  · 随机：`%RAND` = (int)g_EnemyRandom.GetRandomU32()（可负）、`%RANDF` ∈ [0,1]、
---    `%RANDF2` ∈ [−1,1]、`%RANDRAD` = %RANDF2·π、`%ANGLE_PLAYER` = 世界位置→自机角。
---    ★ 原作的随机数**消耗顺序**也是行为的一部分（它决定每一发的角度 / 速度），
---      所以下面凡是「原作先算 A 再算 B」的地方都写成两条独立语句，不能交换、
---      也不要塞进同一个表构造器（Lua 不保证那里的求值顺序）。
---  · 弹样式：本仓库没有 TH10 的弹贴图 ⇒ 一律 ball_mid（原作 etSprite 的第 1 参是精灵号、
---    第 2 参是色号，这里只保留色号，见 `t10_color`）。
---  · 子机：`enmCreateA(name,x,y,life,score,item)` 用**绝对**坐标、`enmCreate(name,dx,dy,…)`
---    用相对坐标；两者都把创建者的 $I0..$I3 / %F0..%F3 整块拷给子机
---    （EnemyEclDispatcher.cpp:1353-1410）。原生版 = `spawn_pod` / `spawn_pod_rel`，
---    子机的协程体直接写成 Lua 函数（`fn(o)`，`o` 就是那只子机）。
---  · 原作 `life` 参数是子机的血量（能被打掉、掉道具），本移植版只把子机当「打不掉的
---    载体」，和上面 stage06 那张卡的处理一致。
---=====================================

---C 的 int % int：符号跟被除数（原作 `modi` 的语义，被除数为负时结果也是负的）
local function t10_imod(a, b)
    if b == 0 then return 0 end
    return math.fmod(a, b)
end

---%RAND = (int)g_EnemyRandom.GetRandomU32()：两个 16 位结果拼成 32 位、再按有符号解释
---（RandomMath.cpp:16 `GetRandomU16() << 16 | GetRandomU16()`；Enemy.cpp:435 就是 (int)）
local function t10_randmod()
    local hi = ran:Int(0, 65535)
    local lo = ran:Int(0, 65535)
    local u = hi * 65536 + lo
    if u >= 2147483648 then u = u - 4294967296 end
    return u
end

---`%RAND % 60`：卡 3605 拿它当 etEx 的等待帧数（+120 之后使用）。
---★ 照抄原作的 `pushi($RAND); pushi(60); modi()`，**不能**换成 ran:Int(0,59) ——
---  原作的 %RAND 可负、C 的 % 结果也可能为负，换成均匀分布会和原作对不上。
local function t10_rand_mod60() return t10_imod(t10_randmod(), 60) end

---=====================================
--- 七、逐张符卡
---=====================================

---卡 3601　光学「ハイドロカモフラージュ」（stage03 中 BOSS 河城荷取）
---  原作 MBossCard1 / MBossCard1_at / MBossCard1_at2h。
---  主循环从 t=80 起每 140 帧叫一次 at + at2h，并在 +100 帧处 moveRand(40, 4, 4.0)；
---  主循环本身是死循环，靠 2700 帧超时（MBossEscape）结束整张卡。
---    at   （槽 0）：12 轮，每轮 7 帧（+7: //7）—— 11 发扇形（基准角 −π/2、
---                  角步长 0.17453292、初速 3.0），两波同点、分裂角 ±0.05235988。
---    at2h （槽 1）：8 轮，每轮 20 帧（+20: //20）—— 20 发环（基准角 %RANDRAD、
---                  角步长 0.19634955、初速 2.0），两侧分裂角各按 %RANDF·π/64 抖动。
local function s3_MBossCard1_at(o)
    local cnt = 11                     -- diffI([4], …, 11)
    local astep = 0.17453292           -- diffF([8], …, 0.17453292)
    for _ = 1, 12 do                   -- [0] = 12（+7: //7）
        fire(o, { slot = 0, aim = 1, sprite = { 8, 6 }, count = { cnt, 1 },
                  angle = -1.5707964, astep = astep, speed = { 3.0, 1.0 },
                  steps = { { allow = 1, kind = 4 },
                            { allow = 0, kind = 32, i0 = 60, i1 = -999999,
                              f0 = -0.02, f1 = 0.05235988 } } })
        fire(o, { slot = 0, aim = 1, sprite = { 8, 6 }, count = { cnt, 1 },
                  angle = -1.5707964, astep = astep, speed = { 3.0, 1.0 },
                  steps = { { allow = 1, kind = 4 },
                            { allow = 0, kind = 32, i0 = 60, i1 = -999999,
                              f0 = -0.02, f1 = -0.05235988 } } })
        task.Wait(7)
    end
end

local function s3_MBossCard1_at2h(o)
    local speed = 2.0                  -- diffF([12], …, 2.0)
    local astep = 0.19634955
    local a = rndrad()                 -- [4] = %RANDRAD
    local b = a                        -- [8] = [4]
    for _ = 1, 8 do                    -- [0] = 8（+20: //20）
        fire(o, { slot = 1, aim = 3, sprite = { 18, 0 }, count = { 20, 1 },
                  angle = a, astep = astep, speed = { speed, 1.0 },
                  steps = { { allow = 1, kind = 4 },
                            ---★ 记录 1 = kind 0x20、记录 2 = kind 0x10 —— etEx 的 record
                            ---序号就是程序的执行顺序，不能按 kind 大小排。
                            { allow = 0, kind = 32, i0 = 60, i1 = -999999,
                              f0 = -0.035, f1 = 0.05235988 },
                            { allow = 0, kind = 16, i0 = 60, i1 = -999999,
                              f0 = 0.04, f1 = -999.0 } } })
        a = a + rnd() * 3.1415927 / 64 -- [4] += %RANDF·π/64（π 取原作 float32）
        fire(o, { slot = 1, aim = 3, sprite = { 18, 0 }, count = { 20, 1 },
                  angle = b, astep = astep, speed = { speed, 1.0 },
                  steps = { { allow = 1, kind = 4 },
                            ---★ 记录 1 = kind 0x20、记录 2 = kind 0x10 —— etEx 的 record
                            ---序号就是程序的执行顺序，不能按 kind 大小排。
                            { allow = 0, kind = 32, i0 = 60, i1 = -999999,
                              f0 = -0.035, f1 = -0.05235988 },
                            { allow = 0, kind = 16, i0 = 60, i1 = -999999,
                              f0 = 0.04, f1 = -999.0 } } })
        b = b - rnd() * 3.1415927 / 64 -- [8] -= %RANDF·π/64
        task.Wait(20)
    end
end

local function s3_MBossCard1(o)
    t10_enm_kill_all(o)                -- t=0：enmKillAll()（清掉上一张卡残留的子机）
    -- 原作同帧还 callAsync("MBossOP")：只轮询动画状态喂 anmPlay，纯视觉，不建线程。
    task.Wait(80)                      -- +80: //80（anmPlay(0, 409) 也是视觉）
    while true do                      -- 每轮 140 帧（//80 → //180 → //220 → 回 //80）
        t10_call_async(o, s3_MBossCard1_at2h)
        t10_call_async(o, s3_MBossCard1_at)
        task.Wait(100)
        m_rand(o, "off", 40, 4, 4.0)   -- moveRand(40, 4, 4.0)
        task.Wait(40)
    end
end

---卡 3602　漂溺「光り輝く水底のトラウマ」
---  原作 BossCard1 / BossCard1AtH / BossCard1AtH2。每轮 462 帧：
---    内层 8 轮 × 40 帧 —— t=0（x=+208）和 t=20（x=−208）各放一对使魔、y 每半轮 +32；
---    然后 moveRand + t=60..160 的 6 波自机狙扇形（每波 20 帧、9 发），$I0 += 1。
---  使魔 AtH / AtH2 只差 $I0 的奇偶：同一位置上一对镜像变换。15 轮 × 20 帧，打完 delete()。
local function s3_BossCard1AtH_(o, want)  -- 原作 BossCard1AtH(want=0) / BossCard1AtH2(want=1)
    local ang = o.F0                   -- %F0：+x 側 = π、−x 側 = 0（创建时拷过来）
    local steps = { { allow = 1, kind = 2 },
                    { allow = 0, kind = 8192, i0 = 320 } }
    if t10_imod(o.I0 or 0, 2) == want then
        steps[3] = { allow = 0, kind = 32, i0 = 60,  i1 = -999999, f0 = 0.0, f1 = 0.01308997 }
        steps[4] = { allow = 0, kind = 32, i0 = 120, i1 = -999999, f0 = 0.0, f1 = -0.01308997 }
        steps[5] = { allow = 0, kind = 32, i0 = 120, i1 = -999999, f0 = 0.0, f1 = 0.01308997 }
        steps[6] = { allow = 0, kind = 32, i0 = 60,  i1 = -999999, f0 = 0.0, f1 = -0.01308997 }
    else
        steps[3] = { allow = 0, kind = 32, i0 = 60,  i1 = -999999, f0 = 0.0, f1 = -0.01308997 }
        steps[4] = { allow = 0, kind = 32, i0 = 120, i1 = -999999, f0 = 0.0, f1 = 0.01308997 }
        steps[5] = { allow = 0, kind = 32, i0 = 120, i1 = -999999, f0 = 0.0, f1 = -0.01308997 }
        steps[6] = { allow = 0, kind = 32, i0 = 60,  i1 = -999999, f0 = 0.0, f1 = 0.01308997 }
    end
    for _ = 1, 15 do                   -- [4] = 15（+20: //20）
        fire(o, { slot = 0, aim = 3, sprite = { 18, 0 }, count = { 1, 1 },
                  angle = ang, astep = 0.0, speed = { 1.3, 1.0 }, steps = steps })
        task.Wait(20)
    end
    t10_delete(o)                      -- 原作 delete()
end
local function s3_BossCard1AtH(o)  return s3_BossCard1AtH_(o, 0) end
local function s3_BossCard1AtH2(o) return s3_BossCard1AtH_(o, 1) end

local function s3_BossCard1(o)
    t10_enm_kill_all(o)                        -- enmKillAll()
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)    -- movePosTime(60, 4, 0, 128)
    while true do                              -- +160: //2700 → 回 //668（每轮 462 帧）
        local y = rnd() * 32                   -- [0] = %RANDF·32（每轮重置）
        for _ = 1, 8 do                        -- [12] = 8
            o.F0 = PI                          -- %F0 = π
            spawn_pod(o, 208.0, y, s3_BossCard1AtH)
            spawn_pod(o, 208.0, y, s3_BossCard1AtH2)
            y = y + 32                         -- [0] += 32（t=0）
            task.Wait(20)                      -- +20: //20
            o.F0 = 0.0                         -- %F0 = 0
            spawn_pod(o, -208.0, y, s3_BossCard1AtH)
            spawn_pod(o, -208.0, y, s3_BossCard1AtH2)
            task.Wait(20)                      -- +40: //40
            y = y + 32                         -- [0] += 32（t=40）
        end
        m_rand(o, "off", 60, 4, 5.0)           -- moveRand(60, 4, 5.0)
        task.Wait(20)                          -- +60: //60：进入 6 波自机狙
        local p = o.pat[0]
        p.type, p.color = 12, 3                -- etSprite(0, 12, 3)
        p.aim, p.c1, p.c2 = 0, 9, 1            -- etAim(0, 0) / etCount(0, 9(L), 1)
        p.angle, p.astep = 0.0, 0.19634955     -- etAngle(0, 0, [4])
        p.s1, p.s2 = 2.0, 1.0                  -- etSpeed(0, 2, 1)
        p.ex[0] = tp_record(1, 8, -999999, -999999, -999999.0, -999999.0)
        for i = 1, 6 do                        -- +20 ×6：//60/80/100/120/140/160
            fire_slot(o, 0)
            if i < 6 then task.Wait(20) end
        end
        o.I0 = (o.I0 or 0) + 1                 -- $I0 += 1
    end
end

---卡 3603　水符「河童の幻想大瀑布」
---  原作 BossCard2 / Boss2Et_at2 / Boss2Et_at2h。t=90..95 在 y=0 摆 6 只使魔
---  （$DIFF≠0 的分支；Easy 只有 3 只），之后主线程只剩每 150 帧一次 moveRand(50, 0, 2.0)。
---  ★ 使魔入口 at2 里 `call("Boss2Et_at2h")` 的目标是**死循环**
---    （Boss2Et_at2h_1512 的 `pushi(1); jmpNeq` 永远跳），所以 at2 后半段是死代码 ——
---    使魔实际跑的就是 at2h：每 5 帧 1 发、角度在 0.7853982 ↔ 2.3561945 之间来回扫
---    0.02805、速度 4.4~4.8、出弹点 x 抖动 ±32·%RANDF2、y = −12。
local function s3_Boss2Et_at2h(o)
    local a = 2.356194                 -- [0]
    local dir = 0                      -- [4]：0 = 朝 0.7853982 扫、1 = 朝 2.3561945 扫
    local p = o.pat[0]
    p.type, p.color = 18, 0            -- etSprite(0, 18, 0)
    p.aim, p.c1, p.c2 = 1, 1, 1        -- etAim(0, 1) / etCount(0, 1, 1)
    p.angle, p.astep = 1.5707964, 0.3926991
    p.s1, p.s2 = 1.0, 1.0
    p.ex[0] = tp_record(0, 64, 60, 1, 0.0, 0.1)
    p.ex[1] = tp_record(0, 32768, 60, -999999, -999999.0, -999999.0)
    while true do                      -- +5: //5
        p.ex[2] = tp_record(0, 16, 60, -999999, rnd() * 0.03 + 0.018, -999.0)
        p.ox, p.oy = rnd2() * 32, -12.0
        p.s1, p.s2 = rnd() * 0.4 + 4.4, 0.0
        p.angle, p.astep = a, 0.0
        if dir == 0 then
            a = a - 0.02805
            if a < 0.7853982 then dir = 1 end
        else
            a = a + 0.02805
            if a > 2.3561945 then dir = 0 end
        end
        fire_slot(o, 0)
        task.Wait(5)
    end
end

local function s3_BossCard2(o)
    t10_enm_kill_all(o)                        -- enmKillAll()
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    task.Wait(90)                              -- +90: //90
    local xs = { 160.0, 96.0, 32.0, -160.0, -96.0, -32.0 }   -- $DIFF≠0 ⇒ 6 只
    for i = 1, 6 do                            -- //90/91/…/95
        spawn_pod(o, xs[i], 0.0, s3_Boss2Et_at2h)
        if i < 6 then task.Wait(1) end
    end
    while true do                              -- +247: //247 → 回 //1076（每轮 150 帧）
        task.Wait(100)
        m_rand(o, "off", 50, 0, 2.0)           -- moveRand(50, 0, 2.0)
        task.Wait(50)
    end
end

---卡 3604　河童「スピン・ザ・セファリックプレート」
---  原作 BossCard3L / BossCard3L_at / BossCard3L_at2。主循环 300 帧一轮：
---    t=120 叫一次 at2（一条常驻线程），之后 t=120 / t=270 各叫一次 at；
---    两次 at 之间夹 moveRand(70, 4, 3.0)（t=180 / t=330）。
---    at  ：槽 0 与槽 1（etCopy 出来的双胞胎）各 56 发、3 轮 × 10 帧，
---          速度 4.0 → 3.0（每轮 −0.5），基准角 %RANDRAD、分裂角带 %F0（±0.008727）。
---    at2 ：先等 100 帧，然后每 3 帧 1 发（槽 2），角度 %RANDRAD/16、速度 1.0~1.4。
local function s3_BossCard3L_at(o)
    local ang = rndrad()               -- etAngle(0, %RANDRAD, 0.0)（槽 1 由 etCopy 共享同角）
    local base = o.F0                  -- 记录 4 的 f1 = %F0（主线程给的 ±0.008727）
    local spd = 4.0                    -- [16] = 4.0
    for _ = 1, 3 do                    -- [12] = 3（+10: //10）
        fire(o, { slot = 0, aim = 3, sprite = { 26, 10 }, count = { 56, 1 },
                  angle = ang, astep = 0.0, speed = { spd, 0.0 }, off = { 0.0, 0.0 },
                  steps = { { allow = 1, kind = 2 },
                            { allow = 0, kind = 8192, i0 = 400 },
                            { allow = 0, kind = 64, i0 = 60, i1 = 1, f0 = 0.0, f1 = 0.0 },
                            { allow = 0, kind = 32768, i0 = 60 },
                            { allow = 0, kind = 32, i0 = 180, i1 = -999999,
                              f0 = 0.01, f1 = base } } })
        fire(o, { slot = 1, aim = 5, sprite = { 26, 10 }, count = { 56, 1 },
                  angle = ang, astep = 0.0, speed = { spd, 0.0 }, off = { 0.0, 0.0 },
                  steps = { { allow = 1, kind = 2 },
                            { allow = 0, kind = 8192, i0 = 400 },
                            { allow = 0, kind = 64, i0 = 60, i1 = 1, f0 = 0.0, f1 = 0.0 },
                            { allow = 0, kind = 32768, i0 = 60 },
                            { allow = 0, kind = 32, i0 = 180, i1 = -999999,
                              f0 = 0.009, f1 = base } } })
        spd = spd - 0.5                -- [16] -= 0.5
        task.Wait(10)
    end
end

local function s3_BossCard3L_at2(o)
    task.Wait(100)                     -- 原作 at2 的配置在 t=100
    local p = o.pat[2]
    p.aim, p.c1, p.c2 = 0, 1, 1        -- etAim(2, 0) / etCount(2, 1, 1)
    p.type, p.color = 24, 8            -- etSprite(2, 24, 8)
    p.angle, p.astep = rndrad(), 0.0   -- etAngle(2, %RANDRAD, 0.0)（下一轮就被重设）
    p.s1, p.s2 = 1.3, 1.0              -- etSpeed(2, 1.3, 1.0)（同上）
    while true do                      -- +3: //3
        p.angle, p.astep = rndrad() / 16, 0.0     -- etAngle(2, %RANDRAD/16, 0.0)
        p.s1, p.s2 = rnd() * 0.4 + 1.0, 0.0       -- etSpeed(2, 1.0 + %RANDF·0.4, 0.0)
        fire_slot(o, 2)
        task.Wait(3)
    end
end

local function s3_BossCard3L(o)
    t10_enm_kill_all(o)                        -- enmKillAll()
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    ---原作这一段的指令分两组（t=60 的 anmPlay 组、t=120 的配置组）；
    ---本仓库每个 task.Wait 都各计一帧，所以照原作的组数拆成两次 wait。
    task.Wait(60)                              -- +60: //60
    task.Wait(60)                              -- +60: //120
    o.F0, o.F1 = 0.0, 0.02618                  -- %F0 = 0、%F1 = 0.02618
    t10_call_async(o, s3_BossCard3L_at2)
    while true do                              -- +420: //980 → 回 //740（每轮 300 帧）
        o.F0 = 0.008727                        -- //740：%F0 = 0.008727
        t10_call_async(o, s3_BossCard3L_at)
        task.Wait(60)                          -- +60: //180
        m_rand(o, "off", 70, 4, 3.0)           -- moveRand(70, 4, 3.0)
        task.Wait(90)                          -- +90: //270
        o.F0 = -0.008727                       -- %F0 = −0.008727
        t10_call_async(o, s3_BossCard3L_at)
        task.Wait(60)                          -- +60: //330
        m_rand(o, "off", 70, 4, 3.0)           -- moveRand(70, 4, 3.0)
        task.Wait(90)                          -- +90: //420
    end
end

---卡 3605　岐符「サルタクロス」（stage04 BOSS 射命丸文）
---  原作 BossCard1 / BossCharge / BossChargeP / BossChargeP2。每 300 帧一轮：
---    t=0   叫一次 BossCharge —— 8 只只转不打的使魔（位置 (−16, +16)，半径 128 / 144，
---          60/2 = 30 次 × 2 帧后自毁）；
---    t=120 之后 48 轮 × 6 波自机狙（每波 1 发）**在同一帧**倾泻（原作这几条指令的
---          时间都是 120），再 wait(180) 等下一轮。
---    ★ 内层 6 波的速度从 1.0 起每波 +1.0，外层 48 轮的基准角每轮 +5.497787/47。
local function s4_BossChargeP(o)        -- 原作 BossChargeP / BossChargeP2（只转、不出弹）
    m_circle(o, "base", o.F0, o.F1, o.F2, o.F3)   -- moveCircleRel(%F0, %F1, %F2, %F3)
    for _ = 1, math.floor((o.I0 or 0) / 2) do     -- $I0/2 次、每次 2 帧
        task.Wait(2)
    end
    t10_delete(o)
end

---BossCharge：8 只「只转不打」的使魔（BossChargeP 在 (−16, +16) 处绕圈）。
---Lunatic 用的是 BossChargeL —— 逐条与它相同，**只有 enmCreate 的 x 偏移从 −16 改成 +16**，
---所以这里参数化一个 dx，两个名字共用一份实现。
local function s4_BossCharge(o, dx)
    dx = dx or -16.0
    o.F0, o.F1, o.F2, o.F3, o.I0 = -2.356194, 0.05236, 128.0, -2, 60
    for _ = 1, 4 do
        spawn_pod_rel(o, dx, 16.0, s4_BossChargeP)
        o.F0 = o.F0 + 1.570796
    end
    o.F0, o.F1, o.F2, o.F3, o.I0 = -1.570796, -0.05236, 144.0, -3, 60
    for _ = 1, 4 do
        spawn_pod_rel(o, dx, 16.0, s4_BossChargeP)
        o.F0 = o.F0 + 1.570796
    end
end

local function s4_BossCard1(o)
    t10_enm_kill_all(o)                        -- enmKillAll()
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    local p = o.pat[0]
    p.type, p.color = 1, 0             -- etSprite(0, 1, 0)
    p.aim, p.c1, p.c2 = 1, 1, 1        -- etAim(0, 1) / etCount(0, 1, 1)
    p.angle, p.astep = -1.5707964, 0.1308997
    p.s1, p.s2 = 1.0, 1.0
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    -- $DIFF>1（Lunatic）：记录 1 = (allow 1, kind 2048, i0 1)；
    -- $DIFF≤1 的 E/N 才是 (allow 0, kind −2147483648) —— 这里只搬 L 那一支。
    p.ex[1] = tp_record(1, 2048, 1, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 4096, 60, -999999, -999999.0, -999999.0)
    p.ex[3] = tp_record(0, 8192, 300, -999999, -999999.0, -999999.0)
    p.ex[4] = tp_record(1, 64, 60, 1, 0.0, 0.0)
    -- $DIFF<2 是 E 的分支（i1 = 6），L 用 i1 = 4
    p.ex[5] = tp_record(0, 16384, 1, 4, -999999.0, -999999.0)
    while true do                              -- //1256 → wait(180) → 回 //1256（300 帧/轮）
        t10_call_async(o, s4_BossCharge)
        local a = 1.963495                     -- [28] = 1.963495
        local astep = 5.497787 / (48 - 1)      -- [32] = 5.497787 / ([12] − 1)，[12] = 48(L)
        task.Wait(120)                         -- +120: //120
        for _ = 1, 48 do                       -- [12] = 48
            local spd = 1.0                    -- [24] = 1.0
            p.angle, p.astep = a, 0.0          -- etAngle(0, [28], 0)
            a = t10_wrap(a + astep)            -- [28] += [32]；validRad
            for _ = 1, 6 do                    -- [16] = 6（同一帧连打 6 波）
                p.s1, p.s2 = spd, 0.0          -- etSpeed(0, [24], 0)
                ---etEx(0, 6, 0, 16, [20], −999999, 0.01f, [-1.0f])：最后一个操作数是
                ---**栈顶**（thecl 记作 [-1.0f]）＝ etEx 前压进栈的 `π/2 + %RANDRAD/8`，
                ---是 vector 方向的基准角，不是速度。%RAND%60+120 先算、%RANDRAD 后算。
                local i0 = t10_rand_mod60() + 120
                local f1 = 1.5707964 + rndrad() / 8
                p.ex[6] = tp_record(0, 16, i0, -999999, 0.01, f1)
                fire_slot(o, 0)                -- etOn(0)
                spd = spd + 1.0                -- [24] += 1.0（L 是 1.0，E/N 是 1.6）
            end
        end
        task.Wait(180)                         -- wait(180)
    end
end

---卡 3606　風神「二百十日」
---  原作 BossCard2。每轮 220 帧：
---    t=0   叫一次 BossCharge（跟卡 3605 同一套 8 只使魔）；
---    t=120 起 30 轮 × 4 帧 —— 槽 0 / 槽 1 各 16 发、两条反向旋转的自机狙扇形
---          （初速 6.0、分裂角 ±0.025，旋转量随时间线性增大：每轮 +0.00003）；
---    t=184 再叫一次 BossCharge，等 60 + 40 帧。
local function s4_BossCard2(o)
    t10_enm_kill_all(o)                        -- enmKillAll()
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_call_async(o, s4_BossCharge)
    task.Wait(120)                             -- +120: //120（原作在这之前不动作）
    local p0, p1 = o.pat[0], o.pat[1]
    p0.type, p0.color = 3, 10          -- etSprite(0, 3, 10)
    p0.aim, p0.c1, p0.c2 = 3, 16, 1    -- etAim(0, 3) / etCount(0, 16(L), 1)
    p0.angle, p0.astep = -1.5707964, 0.1308997
    p0.s1, p0.s2 = 6.0, 1.0
    p0.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p0.ex[1] = tp_record(0, 32, 120, -999999, -0.025, 0.05235988)
    p0.ex[2] = tp_record(0, 8192, 120, -999999, -999999.0, -999999.0)
    et_copy(o, 1, 0)                   -- etCopy(1, 0)
    p1.ex[1] = tp_record(0, 32, 120, -999999, -0.025, -0.06283186)
    p1.type, p1.color = 3, 6           -- etSprite(1, 3, 8) 然后 (1, 3, 6)
    while true do                              -- //1048 → wait(60)+wait(40) → 220 帧/轮
        local a0 = rndrad()                    -- etAngle(0, %RANDRAD, 0)
        local a1 = rndrad()                    -- etAngle(1, %RANDRAD, 0)
        p0.angle, p0.astep = a0, 0.0
        p1.angle, p1.astep = a1, 0.0
        local t = 0.0                          -- [0] = 0.0
        for _ = 1, 30 do                       -- [4] = 30（+4: //4）
            local r0 = rndrad()                -- 槽 0 记录的旋转量
            local r1 = rndrad()                -- 槽 1 记录的旋转量
            ---$DIFF=3 ⇒ `$DIFF < 3` 为假 ⇒ jmpEq 跳到 _1664：f0 = −0.029166667
            ---（−0.0375 那支只有 E/N/H 走得到；+120 组的 −0.025 只是初值）
            p0.ex[1] = tp_record(0, 32, 120, -999999, -0.029166667, 3.1415927 / 60 + r0 * t)
            p1.ex[1] = tp_record(0, 32, 120, -999999, -0.029166667, -3.1415927 / 60 + r1 * t)
            fire_slot(o, 0)
            fire_slot(o, 1)
            task.Wait(4)
            t = t + 0.00002                    -- [0] += 2e-5
            t = t + 0.00001                    -- [0] += 1e-5
        end
        task.Wait(60)                          -- +60: //184
        t10_call_async(o, s4_BossCharge)
        task.Wait(40)                          -- wait(40)
    end
end

---卡 3607　「無双風神」（耐久符卡，1080 帧）
---  原作 BossCard3 / BossCard3_at / BossCard3_at2 / BossCard3_at3。
---    t=0   清场、入场（movePosTime(60, 4, 0, 128)）；
---    t=60  从 (−448, 320) 起步（movePosTime(40, 1, −448, 320)）；
---    t=150 配置槽 1、叫常驻线程 at（每帧 2 发，出弹点在 ±64 圆内随机），
---          然后开始左右横跳：间隔 50/45/40/35 帧，到 t=360 之后靠 diffWait
---          把间隔压到 35/22/18/15/12/10 帧；
---    t=360 起 stopAllThreads + 进入激光循环：每 10 帧一轮，
---          先 enmCreate(at2) + laserOnA、再 enmCreate(at3) + laserOnA，无限循环。
local function s4_BossCard3_at(o)
    local p = o.pat[1]
    while true do                      -- +1: //1
        -- 原作两发都是：%F0/%F1 = circlePos(%RANDRAD, %RANDF2·64)、
        -- etSpeed(1 + %RANDF2·0.3)、etOffset(%F0, %F1)、etOn(1)
        local r = rnd2() * 64
        local a = rndrad()
        local v = 1.0 + rnd2() * 0.3
        p.ox, p.oy = circle_pos(a, r)
        p.s1, p.s2 = v, 1.0
        fire_slot(o, 1)
        local r2 = rnd2() * 64
        local a2 = rndrad()
        local v2 = 1.0 + rnd2() * 0.3
        p.ox, p.oy = circle_pos(a2, r2)
        p.s1, p.s2 = v2, 1.0
        fire_slot(o, 1)
        task.Wait(1)
    end
end

---at2 / at3：从 ±192 飞到 ∓192（6 帧）的使魔，一边飞一边乱射（各自 6 轮 × 1 帧）。
local function s4_BossCard3_side(o, x0, x1)
    local p = o.pat[1]
    -- 原作顺序：先 movePos / movePosTime（各吃一个 %RANDF2），再 etAngle(%RANDRAD)、
    -- etSpeed(%RANDF2) —— 随机数消耗顺序不能换。
    m_pos(o, "off", x0, 128.0 + rnd2() * 128.0)
    m_pos_time(o, "off", 6, 0, x1, 128.0 + rnd2() * 128.0)
    p.aim, p.c1, p.c2 = 1, 1, 1        -- etAim(1, 1) / etCount(1, 1, 1)
    p.type, p.color = 3, 10            -- etSprite(1, 3, 10)
    local a = -1.5707964 + rndrad() * 0.3      -- etAngle(1, −π/2 + %RANDRAD·0.3, 0)
    p.angle, p.astep = a, 0.0
    local v = 1.0 + rnd2() * 0.3               -- etSpeed(1, 1 + %RANDF2·0.3, 1)
    p.s1, p.s2 = v, 1.0
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 16, 60, -999999, 0.05, 1.5707964)
    for _ = 1, 6 do                    -- [4] = 6（+1: //1）
        local r = rnd2() * 64
        local aa = rndrad()
        local vv = 1.0 + rnd2() * 0.3
        p.ox, p.oy = circle_pos(aa, r)
        p.s1, p.s2 = vv, 1.0
        fire_slot(o, 1)
        local r2 = rnd2() * 64
        local aa2 = rndrad()
        local vv2 = 1.0 + rnd2() * 0.3
        p.ox, p.oy = circle_pos(aa2, r2)
        p.s1, p.s2 = vv2, 1.0
        fire_slot(o, 1)
        task.Wait(1)
    end
    t10_delete(o)
end
local function s4_BossCard3_at2(o) return s4_BossCard3_side(o, 192.0, -192.0) end
local function s4_BossCard3_at3(o) return s4_BossCard3_side(o, -192.0, 192.0) end

---原作那对横跳：「movePos(x, 128+%RANDF2·128)；movePosTime(dur, 0, −x, 128+%RANDF2·128)」
---（先瞬移到一侧、再用 dur 帧滑到另一侧；两个 y 各消耗一个 %RANDF2，顺序照抄）
local function s4_BossCard3_hop(o, x, dur)
    local y1 = 128.0 + rnd2() * 128.0
    m_pos(o, "off", x, y1)
    m_pos_time(o, "off", dur, 0, -x, 128.0 + rnd2() * 128.0)
end

local function s4_BossCard3(o)
    t10_enm_kill_all(o)                        -- enmKillAll()
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)    -- 入场（同帧还有一条 90 帧的，被这条覆盖）
    m_limit_clear(o)                           -- moveLimitReset()
    task.Wait(60)                              -- +60: //60
    m_pos_time(o, "off", 40, 1, -448.0, 320.0) -- movePosTime(40, 1, −448, 320)
    task.Wait(90)                              -- +90: //150
    et_new(o, 1)                               -- etNew(1)
    local p = o.pat[1]                         -- ★ 必须在 etNew 之后取，否则拿到的是旧表
    p.aim, p.c1, p.c2 = 1, 1, 1                -- etAim(1, 1) / etCount(1, 1, 1)
    p.type, p.color = 3, 10                    -- etSprite(1, 3, 10)
    local a0 = -1.5707964 + rndrad() * 0.1     -- etAngle(1, −π/2 + %RANDRAD·0.1, 0)
    p.angle, p.astep = a0, 0.0
    local v0 = 1.0 + rnd2() * 0.3              -- etSpeed(1, 1 + %RANDF2·0.3, 1)
    p.s1, p.s2 = v0, 1.0
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 16, 60, -999999, 0.05, 1.5707964)
    t10_call_async(o, s4_BossCard3_at)         -- callAsyncId("BossCard3_at")
    s4_BossCard3_hop(o, -384.0, 50)            -- movePos(−384, y) + movePosTime(50, 0, 384, y)
    et_angle(o, 1, -1.2707963, 0.0)
    task.Wait(60)                              -- +60: //210
    s4_BossCard3_hop(o, 384.0, 45)
    et_angle(o, 1, -1.8707963, 0.0)
    task.Wait(55)                              -- +55: //265
    s4_BossCard3_hop(o, -384.0, 40)
    et_angle(o, 1, -1.2707963, 0.0)
    task.Wait(50)                              -- +50: //315
    s4_BossCard3_hop(o, 384.0, 35)
    et_angle(o, 1, -1.8707963, 0.0)
    task.Wait(45)                              -- +45: //360
    -- //360 起：间隔被 diffWait 一路压到 35/22/18/15/12/10 帧
    s4_BossCard3_hop(o, -384.0, 30)
    et_angle(o, 1, -1.2707963, 0.0)            -- 原作此处同样有 etAngle(−1.2707963, 0)
    task.Wait(35)                              -- diffWait(…, 35)
    s4_BossCard3_hop(o, 384.0, 35)
    et_angle(o, 1, -1.8707963, 0.0)
    task.Wait(22)
    s4_BossCard3_hop(o, -384.0, 20)
    et_angle(o, 1, -1.2707963, 0.0)
    task.Wait(18)
    s4_BossCard3_hop(o, 384.0, 15)
    et_angle(o, 1, -1.8707963, 0.0)
    task.Wait(15)
    s4_BossCard3_hop(o, -384.0, 15)
    et_angle(o, 1, -1.2707963, 0.0)
    task.Wait(12)
    s4_BossCard3_hop(o, 384.0, 10)
    et_angle(o, 1, -1.8707963, 0.0)
    task.Wait(10)                              -- diffWait(…, 10)
    et_offset(o, 0, 0.0, 0.0)                  -- etOffset(0, 0, 0)（原作写的是槽 0，空操作）
    t10_kill_async(o)                          -- killAllAsync()：停掉常驻线程 at
    while true do                              -- +5 / +5：每 10 帧一轮，无限循环
        spawn_pod_rel(o, 0.0, 0.0, s4_BossCard3_at2)   -- enmCreate("BossCard3_at2", 0, 0)
        m_pos(o, "off", -384.0, 96.0 + rnd2() * 96.0)
        local la = rndrad() / 16
        t10_laser_on(o, 3, 2, la, 60.0, 192.0, 800.0, 0, 32.0)
        task.Wait(5)                           -- diffWait(…, 5)
        spawn_pod_rel(o, 0.0, 0.0, s4_BossCard3_at3)
        m_pos(o, "off", 384.0, 96.0 + rnd2() * 96.0)
        local la2 = rndrad() / 16 + 3.1415927
        t10_laser_on(o, 3, 2, la2, 60.0, 192.0, 800.0, 0, 32.0)
        task.Wait(5)                           -- diffWait(…, 5)
    end
end

---卡 3608　塞符「天上天下の照國」
---  原作 BossCard4 / BossCard4_at / _at2 / _at3。入场分两拍：t=0 先 movePos(−216, 160)
---  再走 90 帧的 movePosTime(90, 4, 0, 128)、wait(90)；t=90 的 _476 组里又有一条
---  movePosTime(60, 4, 0, 128)（此时已在终点，等于空转），接着才是 `+120:` 标签。
---  ⇒ 三条线程在 **t=210** 同帧叫起（旧版漏了前面 90 帧，线程早开 90 帧）：
---    at  （槽 0）：64 发大环、角度完全随机；波间隔从 80 帧起每次 −5，
---                  减到 40 帧后固定（80, 75, 70, …, 45, 40, 40, 40, …）。
---    at2 （槽 1）、at3（槽 2）：16 发环，角度 = π/2 ± k·0.021817 反向旋转，每 9 帧一波
---                  （原作 diffWait(22, 13, 11, 9)）。
---  主线程之后只每 100 帧空转，整张卡靠 4200 帧超时结束。
local function s4_BossCard4_at(o)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 64, 1        -- etAim(0, 3) / etCountD(0, …, 64(L), …)
    p.type, p.color = 3, 13             -- etSprite(0, 0, 10) 再 (0, 3, 13) ⇒ 最终 3/13
    p.angle, p.astep = rndrad(), 0.1308997     -- etAngle(0, %RANDRAD, 0.1308997)
    p.s1, p.s2 = 2.0, 1.0               -- etSpeed(0, 1.0, 1.0) 再 (0, 2.0, 1.0)
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    local gap = 80                      -- diffI([0], …, 80)
    while true do                       -- //392
        p.angle, p.astep = rndrad(), 0.0       -- etAngle(0, %RANDRAD, 0)
        fire_slot(o, 0)                 -- etOn(0)
        task.Wait(gap)                  -- wait([0])
        if gap > 40 then gap = gap - 5 end     -- [0] > 40 时 [0] −= 5
    end
end

local function s4_BossCard4_spin(o, slot, dir)
    local p = o.pat[slot]
    local a = 1.570796                  -- [0] = 1.570796
    p.aim, p.c1, p.c2 = 5, 16, 1        -- etAim(·, 5) / etCountD(·, …, 16(L), …, 1)
    p.type, p.color = 7, 13             -- etSprite(·, 3, 6) 再 (·, 7, 13) ⇒ 最终 7/13
    p.angle, p.astep = a, 0.1308997     -- etAngle(·, [0], 0.1308997)
    p.s1, p.s2 = 4.0, 1.0               -- etSpeedD(·, …, 4.0(L), …, 1.0(L))
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    while true do                       -- //408
        a = t10_wrap(a + dir * 0.021817)       -- [0] ±= 0.021817；validRad
        p.angle, p.astep = a, 0.0              -- etAngle(·, [0], 0)
        fire_slot(o, slot)                     -- etOn(·)
        task.Wait(9)                           -- diffWait(22, 13, 11, 9)
    end
end
local function s4_BossCard4_at2(o) return s4_BossCard4_spin(o, 1, 1) end
local function s4_BossCard4_at3(o) return s4_BossCard4_spin(o, 2, -1) end

local function s4_BossCard4(o)
    t10_enm_kill_all(o)                        -- enmKillAll()
    -- 原作 $DIFF≥1 的分支：enmCreate("Ecl_EtBreak", …)（「清弹载体」，本版没有）。
    -- 入场：movePos(−216,160) → movePosTime(90,4,0,128) → wait(90)（90 帧滑到 (0,128)）；
    -- _476 组的 movePosTime(60,4,0,128) 起点已是终点，纯属重复。
    m_pos(o, "off", -216.0, 160.0)              -- movePos(−216, 160)：从左侧入场
    m_pos_time(o, "off", 90, 4, 0.0, 128.0)     -- movePosTime(90, 4, 0, 128)
    task.Wait(90)                              -- wait(90)（jmp 到 _476 时时钟才被设回 0）
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)    -- _476 组再插值一次（此时已在终点）
    task.Wait(120)                             -- +120: //120
    t10_call_async(o, s4_BossCard4_at)
    t10_call_async(o, s4_BossCard4_at2)
    t10_call_async(o, s4_BossCard4_at3)
    while true do                              -- //1008：每 100 帧空转
        task.Wait(100)
    end
end

---=====================================
---=====================================
---TH10 stage07（Extra = stageex）符卡（原生 LuaSTG 实现，仅 Lunatic 行）
---  组 1a 三张 = 中 BOSS（原作 stage07 开头的 MBoss 阶段；沿用已注册的「1a」神奈子）
---  组 5a 十张 = BOSS 洩矢諏訪子（開宴 / 土着神 / 神具 / 源符 / 蛙狩 / 祟符 …）
---
---移植方法与上面 stage03/04 完全一致：逐条读 thecl 反汇编
---    thecl -d 10 -r -m "MAP/th10.eclm" stage07.ecl out.txt
---＋ TH10 1.00a 复原源码，把每条 ECL 指令翻成原生 LuaSTG：
---    task.Wait 计时、fire_slot 出一波弹、spawn_pod(_rel) 叫子机、m_pos*/m_vel*/m_rand 走位、
---    t10_laser_on 放光柱。**不参考 mod/GAME/th10.lua**（那不是 ECL 实现）。
---
---stage07 **没有难度分级**（整关一条 rank != 0xFF 都没有）⇒ 所有指令都按原样执行。
---另外：原作 BOSS 的十张符卡之间各夹一段「非符」（Boss1()..Boss8() 那批 sub），本移植版
---  只做符卡，所以那几段不进表；唯 Boss1() 在开头 +20 帧记下的 `%F0 = %ANGLE_PLAYER`
---  会被后面的開宴「二拝二拍一拝」用到，故在那张卡开头补上（见 s7_BossCard1）。
---
---几条 ECL 读法（stage07 里反复出现，改代码前先读）：
---  · `%B = %RANDF2 * _f(192)` = 局部变量赋值；`$D--` 是 `deci`（**先压旧值再减**），
---    放在循环体末尾时等价于 `for _=1,N do … end`（N = 初值）。
---  · `jmp(label, T)` 把 ECL 时钟直接设成 T（可以回拨，回拨 = 同一帧继续）；
---    `jmpEq/jmpNeq` 只在栈顶为 0 / 非 0 时跳。⇒ 带 `wait` 的循环就是「每帧一轮」，
---    而循环体末尾那条「回拨到更早时间」的 jmp 不额外消耗帧。
---  · `enmCreateA(name, x, y)` 用**绝对**坐标、`enmCreate(name, dx, dy)` 用相对坐标；
---    两者都把创建者的 $I0..$I3 / %F0..%F3 整块拷给子机。
---  · et* 系列改的是「槽」；`etEx` 的记录号就是执行顺序，`etOn` 才真正出一波弹。
---  · 随机数**消耗顺序**是行为的一部分：凡「原作先算 A 再算 B」都写成两条独立语句。
---=====================================

---原作 default.ecl 的 et_ofs_r(slot, B)：radius = %RANDF·B、angle = %RANDRAD，
---再 etOffset(slot, circlePos(angle, radius))。★ 先 %RANDF 再 %RANDRAD，顺序不能换。
local function et_ofs_r(o, slot, b)
    local r = rnd() * b
    local a = rndrad()
    local x, y = circle_pos(a, r)
    et_offset(o, slot, x, y)
end

---stage07 的 44 个子程序统一挂在这张表上：主 chunk 顶层局部早已逼近 LuaJIT 的 200 上限
---（LuaJIT 的计数是「同一作用域内同时存活的局部」），塞进 table 只占 1 个 local。
local s7 = {}

---=====================================
---七·A、中 BOSS 三张（组 1a = 神奈子，原作 stage07 开场的 MBoss 阶段）
---=====================================

---卡 3609　神符「水眼の如き美しき源泉」
---  原作 MBossCard1 / MBossCard_at。主循环从 t=90 起每 220 帧叫一次 at（+160 帧处 moveRand）。
---    at（槽 0）：8 圈 × 1 发（角度自 %RANDRAD 起每轮 +3.883222），每帧一轮、共 160 轮；
---                两发分裂：一发 16 帧后按 0.02 甩出、一发 90 帧后按 −999（不改）。
function s7.MBossCard_at(o)
    local a = rndrad()
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 1, 8          -- etAim(0, 3) / etCount(0, 1, 8)
    p.type, p.color = 3, 6               -- etSprite(0, 3, 6)
    p.angle, p.astep = 1.5707964, 0.0    -- etAngle(0, π/2, 0)
    p.s1, p.s2 = 3.6, 0.6                -- etSpeed(0, 3.6, 0.6)
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 16, 90, -999999, 0.02, -999.0)
    for _ = 1, 160 do                    -- +1: //1（时钟 1 上的 deci 让每帧恰好一轮）
        et_angle(o, 0, a, 0.0)
        fire_slot(o, 0)
        a = t10_wrap(a + 3.883222)
        task.Wait(1)
    end
end

function s7.MBossCard1(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    task.Wait(90)
    while true do                        -- //90 → //310 = 220 帧一轮
        t10_call_async(o, s7.MBossCard_at)
        task.Wait(160)
        m_rand(o, "off", 60, 4, 1.0)
        task.Wait(60)
    end
end

---卡 3610　神符「杉で結ぶ古き縁」
---  原作 MBossCard2 / _at / _at2 / _at3。t=120 重新入场并换符卡；t=210 起三个线程；
---  主线程每 60 帧把 $I0 从 60 减到 44（做子弹的「等待帧数」）。
---    at   （槽 0）：8 速、基准角 π，每帧角在 π ± π/16 内抖；30 发后 wait $I0。
---    at2  （槽 1）：同 at 但精灵色 9、角在 0 ± π/16 内抖。
---    at3  （槽 2/3）：8 发扇形（角步长 0.19634955），两侧分裂角 ±0.05235988，每 10 帧一波。
function s7.MBossCard2_at(o)
    local _a = rndrad()
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 1, 1, 1
    p.type, p.color = 3, 10
    p.angle, p.astep = 3.1415927, 0.0   -- etAngle(0, 3.1415927, 0)：ECL 里是 float 常量
    p.s1, p.s2 = 8.0, 0.6
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 256, 45, 1, 1.5707964, 6.0)
    p.ex[2] = tp_record(0, 128, 60, 1, 0.0, 6.0)
    p.ex[3] = tp_record(0, 128, 50, 1, 0.0, 1.0)
    p.ex[4] = tp_record(0, 16384, 3, 0, -999999.0, -999999.0)
    while true do
        for _ = 1, 30 do
            et_angle(o, 0, 3.1415927 + rndrad() / 16, 0.0)
            fire_slot(o, 0)
            task.Wait(1)
        end
        task.Wait(o.I0)
    end
end

function s7.MBossCard2_at2(o)
    local _a = rndrad()
    et_new(o, 1)
    local p = o.pat[1]
    p.aim, p.c1, p.c2 = 1, 1, 1
    p.type, p.color = 3, 9
    p.angle, p.astep = 3.1415927, 0.0   -- etAngle(1, 3.1415927, 0)：同上
    p.s1, p.s2 = 8.0, 0.6
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 256, 45, 1, 1.5707964, 6.0)
    p.ex[2] = tp_record(0, 128, 60, 1, 0.0, 6.0)
    p.ex[3] = tp_record(0, 128, 50, 1, 0.0, 1.0)
    p.ex[4] = tp_record(0, 16384, 3, 0, -999999.0, -999999.0)
    while true do
        for _ = 1, 30 do
            et_angle(o, 1, 0.0 + rndrad() / 16, 0.0)
            fire_slot(o, 1)
            task.Wait(1)
        end
        task.Wait(o.I0)
    end
end

function s7.MBossCard2_at3(o)
    et_new(o, 2)
    local p = o.pat[2]
    p.aim, p.c1, p.c2 = 1, 8, 1
    p.type, p.color = 3, 6
    p.angle, p.astep = -1.5707964, 0.19634955
    p.s1, p.s2 = 4.0, 0.6
    p.ex[0] = tp_record(0, 32, 120, -999999, 0.0, 0.05235988)
    et_new(o, 3)
    local q = o.pat[3]
    q.aim, q.c1, q.c2 = 1, 8, 1
    q.type, q.color = 3, 6
    q.angle, q.astep = -1.5707964, 0.19634955
    q.s1, q.s2 = 4.0, 0.6
    q.ex[0] = tp_record(0, 32, 120, -999999, 0.0, -0.05235988)
    while true do
        fire_slot(o, 2)
        fire_slot(o, 3)
        task.Wait(10)
    end
end

function s7.MBossCard2(o)
    t10_kill_async(o)
    t10_enm_kill_all(o)
    m_limit_clear(o)
    task.Wait(120)                       -- +120: //120
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    task.Wait(90)                        -- //210
    t10_call_async(o, s7.MBossCard2_at)
    t10_call_async(o, s7.MBossCard2_at2)
    t10_call_async(o, s7.MBossCard2_at3)
    o.I0 = 60
    while true do                        -- //210 → //270 = 60 帧一轮
        if o.I0 > 44 then o.I0 = o.I0 - 2 end
        task.Wait(60)
    end
end

---卡 3611　神符「神が歩かれた御神渡り」
---  原作 MBossCard3 / _at2 / _at3。t=180 起每 220 帧放一只「拄杖」子机（相对 0,−128），
---  160 帧后 BOSS 自己横向插值到自机 x（movePosTime(60,4,%PLAYER_X2,%FINAL_Y)）。
---    at2（子机）：moveVel(π/2, 4) 往下走，世界 y ≥ 448 自毁；同时开 at3。
---    at3（子机槽 0/1）：单发 + 一子在 x 上按 sin 摆 24px（槽 1 = etCopy 槽 0，色 15）。
function s7.MBossCard3_at3(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 1, 1, 1
    p.type, p.color = 5, 6
    p.angle, p.astep = 3.1415927, 0.0   -- etAngle(0, 3.1415927, 0)
    p.s1, p.s2 = 0.0, 0.6
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 32768, 100, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 16, 90, -999999, 0.01, -999.0)
    et_copy(o, 1, 0)
    et_sprite(o, 1, 5, 15)
    local b = rndrad()
    local c = rndrad()
    while true do                        -- +1: //1
        et_angle(o, 0, rndrad(), 0.0)
        fire_slot(o, 0)
        et_offset(o, 1, math.sin(b) * 24.0, 0.0)
        et_angle(o, 1, c, 0.0)
        fire_slot(o, 1)
        b = t10_wrap(b + 0.10472)
        c = t10_wrap(c + 0.20944)
        task.Wait(1)
    end
end

function s7.MBossCard3_at2(o)
    m_vel(o, "off", 1.5707964, 4.0)      -- moveVel(π/2, 4)：往下走
    t10_call_async(o, s7.MBossCard3_at3)
    while true do
        if o.ecs.wy >= 448.0 then t10_delete(o) return end
        task.Wait(1)
    end
end

function s7.MBossCard3(o)
    t10_kill_async(o)
    t10_enm_kill_all(o)
    m_limit_clear(o)
    task.Wait(90)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    task.Wait(90)                        -- //180
    while true do                        -- //180 → //400 = 220 帧一轮
        spawn_pod_rel(o, 0.0, -128.0, s7.MBossCard3_at2)
        task.Wait(160)
        m_pos_time(o, "off", 60, 4, player.x, o.ecs.wy)
        task.Wait(60)
    end
end

---=====================================
---七·B、BOSS 十张（组 5a = 洩矢諏訪子）
---=====================================

---卡 3612　開宴「二拝二拍一拝」
---  原作 BossCard1 / _at / _at2 / _at2b / _at3。主循环 480 帧一轮：两条激光柱斜扫
---  （_at2 / _at2b 各 20 段）、两次自机狙散弹（_at，4 组 D = 4/8/16/32）、一次双臂对扫（_at3）。
---  ★ `%F0` 来自原作上一段 Boss1()：入场 +20 帧记下自机角。这里在卡开头补这一笔
---    （只影响激光柱的基准角，不影响任何弹）。
function s7.BossCard1_at(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 1, 1
    p.type, p.color = 5, 6
    p.angle, p.astep = 0.0, 0.0
    p.s1, p.s2 = 2.0, 1.0
    p.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 8192, 120, -999999, -999999.0, -999999.0)
    p.ex[3] = tp_record(0, 16, 60, -999999, 0.06, 999.0)
    -- 4 组：$D = 4 / 8 / 16 / 32，精灵 (17,1) / (12,3) / (1,6) / (0,6)
    local groups = { { 4, 17, 1 }, { 8, 12, 3 }, { 16, 1, 6 }, { 32, 0, 6 } }
    for g = 1, 4 do
        local d = groups[g]
        et_sprite(o, 0, d[2], d[3])
        for _ = 1, d[1] do                  -- ★ 每轮先 %RANDF2、再 %RANDF、再 %RANDRAD
            local b = rnd2() * 192.0
            local c = -128.0 * rnd()
            et_ex(o, 0, 2, 0, 16, 40, -999999, 0.04, 1.5707964)
            et_offset(o, 0, b, c)
            et_angle(o, 0, rndrad() / 16 - 1.5707964, 0.0)
            et_speed(o, 0, 2.0, 0.0)
            fire_slot(o, 0)
        end
    end
    et_ex(o, 0, 2, 0, 16, 120, -999999, 0.03, 1.5707964)
    et_offset(o, 0, 0.0, 0.0)
end

function s7.BossCard1_at2(o, kind)
    local b = 0.03927
    local c = o.F0 - 1.5707964
    for _ = 1, 20 do
        t10_laser_on(o, 3, kind, c, 6.0, 0, 128.0, 0, 14.0)
        c = t10_wrap(c + b)
        task.Wait(4)
        t10_laser_on(o, 3, 15, c, 6.0, 0.0, 128.0, 0, 14.0)
        c = t10_wrap(c + b)
        task.Wait(4)
    end
end

function s7.BossCard1_at2b(o, kind)
    local b = 0.03927
    local c = o.F0 + 1.5707964
    for _ = 1, 20 do
        t10_laser_on(o, 3, kind, c, 6.0, 0, 128.0, 0, 14.0)
        c = t10_wrap(c - b)
        task.Wait(4)
        t10_laser_on(o, 3, 15, c, 6.0, 0.0, 128.0, 0, 14.0)
        c = t10_wrap(c - b)
        task.Wait(4)
    end
end

function s7.BossCard1_at3(o)
    local a = 0.034907
    local b = o.F0 - 1.5707964
    local c = o.F0 + 1.5707964
    for _ = 1, 20 do
        t10_laser_on(o, 3, 2, b, 6.0, 0, 128.0, 0, 14.0)
        t10_laser_on(o, 3, 2, c, 6.0, 0, 128.0, 0, 14.0)
        b = t10_wrap(b + a)
        c = t10_wrap(c - a)
        task.Wait(4)
        t10_laser_on(o, 3, 15, b, 6.0, 0.0, 128.0, 0, 14.0)
        t10_laser_on(o, 3, 15, c, 6.0, 0.0, 128.0, 0, 14.0)
        b = t10_wrap(b + a)
        c = t10_wrap(c - a)
        task.Wait(4)
    end
end

function s7.BossCard1(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    ---原作 Boss1() 在 +20 帧记 `%F0 = %ANGLE_PLAYER`，但開宴的三个子程序
    ---（at/at2/at2b）都不读 %F0（at2 自己会覆盖它）⇒ 此处不插 wait 边界，
    ---保持与本卡 ECL 时间轴一致（多一个 wait 会整张卡晚 1 帧）。
    task.Wait(90)                        -- //90
    while true do                        -- //90 → //570 = 480 帧一轮
        t10_call_async(o, function(p) s7.BossCard1_at2(p, 2) end);  task.Wait(30)
        t10_call_async(o, function(p) s7.BossCard1_at2b(p, 8) end); task.Wait(30)
        s7.BossCard1_at(o); task.Wait(30)
        s7.BossCard1_at(o); task.Wait(30)
        t10_call_async(o, s7.BossCard1_at3); task.Wait(60)
        m_rand(o, "off", 60, 4, 1.0); task.Wait(60)
        t10_call_async(o, function(p) s7.BossCard1_at2b(p, 2) end); task.Wait(30)
        t10_call_async(o, function(p) s7.BossCard1_at2(p, 8) end);  task.Wait(30)
        s7.BossCard1_at(o); task.Wait(30)
        s7.BossCard1_at(o); task.Wait(30)
        t10_call_async(o, s7.BossCard1_at3); task.Wait(60)
        m_rand(o, "off", 60, 4, 1.0); task.Wait(60)
    end
end

---卡 3613　土着神「手長足長さま」
---  原作 BossCard2 / _at / _at2 / _at3 / _at4。t=90 起四把激光（两把 sin 摆、两把反相 sin
---  同时刻在 0.436332 幅度内扫）、一条 112 发慢速环（每 360 帧一波）、一条 144 发环（每 60 帧一波）。
function s7.BossCard2_at(o, kind, phase)
    et_new(o, 0)
    local c = 0.436332
    local e = 2.356194
    while true do
        local d = t10_wrap(e + c * math.sin(phase))
        t10_laser_on(o, 3, kind, d, 6.0, 0, 128.0, 0.0, 14.0)
        phase = t10_wrap(phase + 0.034907)
        task.Wait(4)
        d = t10_wrap(e + c * math.sin(phase))
        t10_laser_on(o, 3, 15, d, 6.0, 0, 128.0, 0.0, 14.0)
        phase = t10_wrap(phase + 0.034907)
        task.Wait(4)
    end
end

function s7.BossCard2_at2(o, kind, phase)
    et_new(o, 0)
    local c = 0.436332
    local e = 0.785398
    while true do
        local d = t10_wrap(e - c * math.sin(phase))
        t10_laser_on(o, 3, kind, d, 6.0, 0, 128.0, 0.0, 14.0)
        phase = t10_wrap(phase + 0.034907)
        task.Wait(4)
        d = t10_wrap(e - c * math.sin(phase))
        t10_laser_on(o, 3, 15, d, 6.0, 0, 128.0, 0.0, 14.0)
        phase = t10_wrap(phase + 0.034907)
        task.Wait(4)
    end
end

function s7.BossCard2_at3(o)
    local a = rndrad()
    et_new(o, 1)
    local p = o.pat[1]
    p.aim, p.c1, p.c2 = 3, 112, 1
    p.type, p.color = 3, 6
    p.angle, p.astep = rndrad(), 0.0
    p.s1, p.s2 = 0.52, 1.0
    p.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    task.Wait(60)
    while true do
        et_angle(o, 1, rndrad(), 0.0)
        fire_slot(o, 1)
        task.Wait(360)
    end
end

function s7.BossCard2_at4(o)
    et_new(o, 2)
    local p = o.pat[2]
    p.aim, p.c1, p.c2 = 1, 144, 1
    p.type, p.color = 3, 6
    p.angle, p.astep = -1.5707964 + rndrad() / 192, 0.032724924
    p.s1, p.s2 = 1.5, 1.0
    p.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    task.Wait(60)
    while true do
        fire_slot(o, 2)
        task.Wait(60)
    end
end

function s7.BossCard2(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    task.Wait(90)
    et_offset(o, 0, 0.0, -8.0)
    t10_call_async(o, function(p) s7.BossCard2_at(p, 2, 0.0) end)
    t10_call_async(o, function(p) s7.BossCard2_at2(p, 2, 0.0) end)
    t10_call_async(o, function(p) s7.BossCard2_at(p, 10, 3.1415927) end)
    t10_call_async(o, function(p) s7.BossCard2_at2(p, 10, 3.1415927) end)
    t10_call_async(o, s7.BossCard2_at3)
    t10_call_async(o, s7.BossCard2_at4)
    o.I0 = 0
    while true do                        -- //90 → //330 = 240 帧一轮
        task.Wait(240)
    end
end

---卡 3614　神具「洩矢の鉄の輪」
---  原作 BossCard3 / _at。三把 48 发环（速度 2.5 / 2.0 / 1.5，逐级变慢），
---  每轮 10 波、每波间隔 40 帧后再等 150 帧；每波的弹带自机狙分裂。
function s7.BossCard3_at(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 48, 1
    p.type, p.color = 3, 2
    p.angle, p.astep = rndrad(), 0.09817477
    p.s1, p.s2 = 2.4, 1.5
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 16, 40, -999999, 0.04, -999999.0)
    et_copy(o, 1, 0)
    et_ex(o, 1, 3, 1, 1024, 1, -999999, -999999.0, -999999.0)
    et_ex(o, 1, 4, 0, 16384, 3, 1, -999999.0, -999999.0)
    et_copy(o, 2, 1)
    et_ex(o, 2, 5, 1, 1024, 1, -999999, -999999.0, -999999.0)
    et_ex(o, 2, 6, 0, 16384, 3, 0, -999999.0, -999999.0)
    et_speed(o, 2, 1.5, 0.0)
    et_speed(o, 1, 2.0, 0.0)
    et_speed(o, 0, 2.5, 0.0)
    local c = -2.356194
    while true do
        for _ = 1, 10 do
            et_ex(o, 0, 1, 0, 256, 60, 1, t10_angle_player(o), 0.01)
            et_ex(o, 1, 1, 0, 256, 60, 1, t10_angle_player(o), 0.01)
            et_ex(o, 2, 1, 0, 256, 60, 1, t10_angle_player(o), 0.01)
            et_angle(o, 0, c, 0.09817477)
            et_angle(o, 1, c, 0.09817477)
            et_angle(o, 2, c, 0.09817477)
            c = t10_wrap(c + 0.943421)
            fire_slot(o, 0)
            fire_slot(o, 1)
            fire_slot(o, 2)
            task.Wait(40)
        end
        task.Wait(150)
    end
end

function s7.BossCard3(o)
    t10_kill_async(o)
    m_limit_clear(o)
    m_pos_time(o, "off", 60, 4, 0.0, 224.0)
    t10_enm_kill_all(o)
    task.Wait(80)
    t10_call_async(o, s7.BossCard3_at)
    while true do
        task.Wait(60)
    end
end

---卡 3615　源符「厭い川の翡翠」
---  原作 BossCard4 / _at。900 帧一轮、每轮三批共六个使魔（绝对 x = ±192、y = 0）：
---  每只使魔按自己的 %F0（初始角）/ %F1（初速）/ %F2（每 4 帧的加速度）连打 57 波后自毁，
---  使魔本体一边按极速度 π/2、2.0 往下飘。
function s7.BossCard4_at(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 1, 1
    p.type, p.color = 3, 10
    p.angle, p.astep = o.F0, 0.09817477
    p.s1, p.s2 = 4.0, 1.5
    p.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 64, 60, 1, -999999.0, 0.01)
    p.ex[2] = tp_record(0, 32768, 120, -999999, -999999.0, -999999.0)
    p.ex[3] = tp_record(0, 128, 35, 1, 0.0, 1.4)
    m_vel(o, "off", 1.5707964, 2.0)
    for _ = 1, 57 do                    -- +4: //4
        et_speed(o, 0, o.F1, 0.0)
        fire_slot(o, 0)
        o.F1 = o.F1 + o.F2
        task.Wait(4)
    end
    t10_delete(o)
end

function s7.BossCard4(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    task.Wait(80)
    while true do                        -- //80 → //980 = 900 帧一轮
        o.F0, o.F1, o.F2 = 0.0, 8.0, -0.1
        spawn_pod(o, -192.0, 0.0, s7.BossCard4_at)
        o.F0, o.F1, o.F2 = 3.141593, 1.0, 0.1
        spawn_pod(o, 192.0, 0.0, s7.BossCard4_at)
        task.Wait(240)
        m_rand(o, "off", 60, 4, 1.0)
        task.Wait(60)
        o.F0, o.F1, o.F2 = 0.0, 4.0, 0.0
        spawn_pod(o, -192.0, 0.0, s7.BossCard4_at)
        o.F0, o.F1, o.F2 = 3.141593, 4.0, 0.0
        spawn_pod(o, 192.0, 0.0, s7.BossCard4_at)
        task.Wait(240)
        m_rand(o, "off", 60, 4, 1.0)
        task.Wait(60)
        o.F0, o.F1, o.F2 = 0.0, 1.0, 0.1
        spawn_pod(o, -192.0, 0.0, s7.BossCard4_at)
        o.F0, o.F1, o.F2 = 3.141593, 8.0, -0.1
        spawn_pod(o, 192.0, 0.0, s7.BossCard4_at)
        task.Wait(240)
        m_rand(o, "off", 60, 4, 1.0)
        task.Wait(60)
    end
end

---卡 3616　蛙狩「蛙は口ゆえ蛇に呑まるる」
---  原作 BossCard5 / _at / _at2。840 帧一轮、每 420 帧换一只使魔（相对 0,0）。
---  使魔绕半径 0.8 的圆（半径随每帧 +0.8）慢慢转，同时按「剩余帧数」越接近末段越密地喷弹
---  （起点 480，<440 / <220 / <180 三段闸门；at2 只有后两段）。
function s7.BossCard5_at(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 6, 1
    p.type, p.color = 3, 10
    p.angle, p.astep = rndrad(), 0.09817477
    p.s1, p.s2 = 0.002, 1.5
    p.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 32768, 120, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 64, 1, 1, -999999.0, 4.0)
    p.ex[3] = tp_record(0, 64, 35, 1, -999999.0, 0.01)
    p.ex[4] = tp_record(0, 65536, -999999, -999999, -999999.0, -999999.0)
    m_circle(o, "off", -0.7853982, 0.05235988, 0.0, 0.8)
    local e = 480
    for _ = 1, 480 do                   -- +1: //1
        ---★ 原作循环头是 `BossCard5_at_1096: if ($E--) goto ..._548`：**先减后判**。
        ---  写成「先判后减」会让闸门整整晚一轮（2 帧）——at 的首发和 at2 的 220/180
        ---  闸门都会跟着错位。
        e = e - 1
        if e < 440 then
            et_angle(o, 0, rndrad(), 0.0)
            et_ofs_r(o, 0, 38.0)
            fire_slot(o, 0)
        end
        if e < 220 then
            et_angle(o, 0, rndrad(), 0.0)
            et_ofs_r(o, 0, 38.0)
            fire_slot(o, 0)
        end
        if e < 180 then
            et_angle(o, 0, rndrad(), 0.0)
            et_ofs_r(o, 0, 38.0)
            fire_slot(o, 0)
        end
        task.Wait(1)
    end
    t10_delete(o)
end

function s7.BossCard5_at2(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 6, 1
    p.type, p.color = 3, 8
    p.angle, p.astep = rndrad(), 0.09817477
    p.s1, p.s2 = 0.002, 1.5
    p.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 32768, 120, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 64, 1, 1, -999999.0, 4.0)
    p.ex[3] = tp_record(0, 64, 35, 1, -999999.0, 0.01)
    p.ex[4] = tp_record(0, 65536, -999999, -999999, -999999.0, -999999.0)
    m_circle(o, "off", -2.3561945, -0.05235988, 0.0, 0.8)
    local e = 480
    for _ = 1, 480 do
        e = e - 1                          -- ★ 同 at：原作 deci 在循环头（先减后判）
        et_angle(o, 0, rndrad(), 0.0)      -- at2 第一发**无闸门**（at 才有 $E<440）
        et_ofs_r(o, 0, 38.0)
        fire_slot(o, 0)
        if e < 220 then
            et_angle(o, 0, rndrad(), 0.0)
            et_ofs_r(o, 0, 38.0)
            fire_slot(o, 0)
        end
        if e < 180 then
            et_angle(o, 0, rndrad(), 0.0)
            et_ofs_r(o, 0, 38.0)
            fire_slot(o, 0)
        end
        task.Wait(1)
    end
    t10_delete(o)
end

function s7.BossCard5(o)
    t10_kill_async(o)
    m_limit_clear(o)
    m_pos_time(o, "off", 60, 4, 0.0, 224.0)
    t10_enm_kill_all(o)
    task.Wait(80)
    while true do                        -- //80 → //920 = 840 帧一轮
        spawn_pod_rel(o, 0.0, 0.0, s7.BossCard5_at)
        task.Wait(420)
        spawn_pod_rel(o, 0.0, 0.0, s7.BossCard5_at2)
        task.Wait(420)
    end
end

---卡 3617　土着神「七つの石と七つの木」
---  原作 BossCard6 / _at / _at2 / _at3 / _at3b。t=30 放七只固定使魔（绝对 x 依次
---  −168…168，各自的 $I0 = 2/14/13/10/8/6/4 = 放柱子的颜色号）；t=80 起一条主弹源
---  每 4 帧喷一次「七连」——at3 依次按 1,7,6,5,4,3,2 给七只使魔各派一发（精灵色 = $I0）。
function s7.BossCard6_at3b(o, a)
    et_sprite(o, 0, 13, a)
    et_angle(o, 0, o.F0, 0.0)
    fire_slot(o, 0)
    o.F0 = t10_wrap(o.F0 + 0.897598)
end

function s7.BossCard6_at3(o)
    s7.BossCard6_at3b(o, 1)
    s7.BossCard6_at3b(o, 7)
    s7.BossCard6_at3b(o, 6)
    s7.BossCard6_at3b(o, 5)
    s7.BossCard6_at3b(o, 4)
    s7.BossCard6_at3b(o, 3)
    s7.BossCard6_at3b(o, 2)
end

function s7.BossCard6_at2(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 1, 1
    p.type, p.color = 3, 10
    p.angle, p.astep = rndrad(), 0.09817477
    p.s1, p.s2 = 1.0, 1.5
    while true do                        -- 两段（+3.883222 / −3.883222）× 30 轮，段间等 120 帧
        o.F0 = rndrad()
        for _ = 1, 30 do
            et_ex(o, 0, 0, 0, 32, 90, -999999, 0.01, 0.015707964)
            s7.BossCard6_at3(o)
            task.Wait(4)
            o.F0 = t10_wrap(o.F0 + 3.883222)
            et_ex(o, 0, 0, 0, 32, 90, -999999, 0.01, -0.015707964)
            s7.BossCard6_at3(o)
            o.F0 = t10_wrap(o.F0 + 3.883222)
            task.Wait(4)
        end
        task.Wait(120)
        o.F0 = rndrad()
        for _ = 1, 30 do
            et_ex(o, 0, 0, 0, 32, 90, -999999, 0.01, 0.015707964)
            s7.BossCard6_at3(o)
            task.Wait(4)
            o.F0 = t10_wrap(o.F0 - 3.883222)
            et_ex(o, 0, 0, 0, 32, 90, -999999, 0.01, -0.015707964)
            s7.BossCard6_at3(o)
            o.F0 = t10_wrap(o.F0 - 3.883222)
            task.Wait(4)
        end
        task.Wait(120)
    end
end

function s7.BossCard6_at(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.ex[0] = tp_record(0, 64, 120, 1, 0.0, 0.01)
    p.ex[1] = tp_record(0, 32768, 120, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 16, 120, -999999, 0.03, -999999.0)
    local b = o.I0
    while true do                        -- +360: //360（60 + 300）
        task.Wait(60)
        t10_laser_on(o, 3, b, 1.5707964, 8.0, 0, 320.0, 0.0, 16.0)
        task.Wait(300)
    end
end

function s7.BossCard6(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    task.Wait(30)
    local xs = { -168.0, -112.0, -56.0, 0.0, 56.0, 112.0, 168.0 }
    local ks = { 2, 14, 13, 10, 8, 6, 4 }
    for i = 1, 7 do
        o.I0 = ks[i]
        spawn_pod(o, xs[i], 0.0, s7.BossCard6_at)
    end
    task.Wait(50)                        -- //80
    t10_call_async(o, s7.BossCard6_at2)
    while true do                        -- //80 → //440 = 360 帧一轮
        task.Wait(360)
    end
end

---卡 3618　土着神「ケロちゃん風雨に負けず」
---  原作 BossCard7 / _at / _at2。t=80 起一条波形弹源（角在 −π/2 ± 0.5235988 间摆、
---  角步长 0.3926991），配一条 8 发扇（基准角 = 未初始化的 %F0 = 0）与一子在 delay 后
---  每 4 帧发一发随机角、速度 1.0+%RANDF·0.8 的弹。主循环每 120 帧一次 moveRand。
function s7.BossCard7_at(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 1, 8, 1
    p.type, p.color = 18, 0
    p.angle, p.astep = o.F0, 0.09817477
    p.s1, p.s2 = 4.0, 1.5
    p.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 8192, 240, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 16, 120, -999999, 0.032, 1.5707964)
    et_copy(o, 1, 0)
    et_sprite(o, 1, 3, 8)
    local c = 0.0
    t10_call_async(o, s7.BossCard7_at2)
    while true do                        -- +4: //4
        local a = 0.5235988 * math.sin(c) - 1.5707964
        et_angle(o, 0, a, 0.3926991)
        et_speed(o, 0, 2.5, 0.0)
        fire_slot(o, 0)
        c = t10_wrap(c + 0.10472)
        task.Wait(4)
    end
end

function s7.BossCard7_at2(o)
    task.Wait(100)
    while true do                        -- +4: //4
        et_angle(o, 1, -1.5707964 + rndrad() / 8, 0.3926991)
        et_speed(o, 1, 1.0 + rnd() * 0.8, 0.0)
        fire_slot(o, 1)
        task.Wait(4)
    end
end

function s7.BossCard7(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    task.Wait(80)
    t10_call_async(o, s7.BossCard7_at)
    while true do                        -- //80 → //200 = 120 帧一轮
        task.Wait(60)
        m_rand(o, "off", 60, 4, 1.0)
        task.Wait(60)
    end
end

---卡 3619　土着神「宝永四年の赤蛙」（耐久）
---  原作 BossCard8 / _at / _at2。t=80 放第一只使魔，+1260 帧后再放第二只（原作 ECL 的
---  循环只回到 `wait(2400)` —— 那之后不再生成，本移植版照抄，不擅自改成「循环生成」）。
---  使魔：先绕半径 0→0.8 的圆转，再横移到自机 x、按极速度冲一段、速度衰减到 0，之后
---  每 80 帧重新朝自机冲一次（16.0 → 0 用 60 帧）。
function s7.BossCard8_at2(o)
    while true do                        -- +2: //2
        et_angle(o, 0, rndrad(), 0.0)
        et_ofs_r(o, 0, 4.0)
        fire_slot(o, 0)
        task.Wait(2)
    end
end

function s7.BossCard8_at(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 3, 1
    p.type, p.color = 3, 2
    p.angle, p.astep = rndrad(), 0.09817477
    p.s1, p.s2 = 0.002, 1.5
    p.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 32768, 340, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 16384, 3, 15, -999999.0, -999999.0)
    p.ex[3] = tp_record(0, 32768, 60, -999999, -999999.0, -999999.0)
    p.ex[4] = tp_record(0, 64, 1, 1, -999999.0, 5.0)
    p.ex[5] = tp_record(0, 16384, 3, 15, -999999.0, -999999.0)
    p.ex[6] = tp_record(0, 64, 35, 1, -999999.0, 0.01)
    p.ex[7] = tp_record(0, 65536, -999999, -999999, -999999.0, -999999.0)
    m_circle(o, "off", -0.7853982, 0.05235988, 0.0, 0.8)
    t10_call_async(o, s7.BossCard8_at2)
    m_pos_time(o, "off", 60, 4, o.ecs.wx, 128.0)   -- %FINAL_X = 生成时的世界 x
    task.Wait(60)                        -- //60：原作此处 anmPlay(0, 442)（纯视觉，但占一个时间组）
    task.Wait(20)                        -- //80
    m_vel(o, "off", t10_angle_player(o), 8.0)
    m_vel_time(o, "off", 100, 4, t10_angle_player(o), 0.0)
    task.Wait(100)                       -- //180：原作 anmPlay(0, 442)
    task.Wait(20)                        -- //200
    while true do                        -- //200 → //280 = 80 帧一轮
        m_vel(o, "off", t10_angle_player(o), 16.0)
        m_vel_time(o, "off", 60, 4, t10_angle_player(o), 0.0)
        task.Wait(60)                    -- //260：原作 anmPlay(0, 442)
        task.Wait(20)                    -- //280
    end
end

function s7.BossCard8(o)
    t10_kill_async(o)
    m_limit_clear(o)
    m_pos_time(o, "off", 60, 4, 0.0, 224.0)
    t10_enm_kill_all(o)
    task.Wait(80)
    spawn_pod_rel(o, 0.0, 0.0, s7.BossCard8_at)
    task.Wait(1200)
    task.Wait(60)                        -- //1340
    spawn_pod_rel(o, 0.0, 0.0, s7.BossCard8_at)
    while true do                        -- 原作此处只回到 wait(2400)，不再生成
        task.Wait(2400)
    end
end

---卡 3620　「諏訪大戦　～ 土着神話 vs 中央神話」（耐久）
---  原作 BossCard9 / _at / _at2 / _MoveSin。上半拍自下缘（y=448）升起六只「石」使魔
---  （x = −192,−128,−64,64,128,192，跳过 0；%F0 在两值间交替），下半拍自上缘（y=0）
---  落七只（中间那只在 $I1 ≥ 5 时不再生成）。两半拍之间各等 $C 帧，$C 从 460 每次 −50 到 60 为止。
function s7.BossCard9_MoveSin(o)
    local a = o.F0
    local c = 0.0
    task.Wait(math.floor(rnd() * 40 + 1))
    while true do                        -- +1: //1
        local b = c * math.sin(a)
        m_pos_time(o, "base", 1, 0, b, 0.0)
        if c < 80.0 then c = c + 0.3 end
        a = t10_wrap(a + 0.05236)
        task.Wait(1)
    end
end

function s7.BossCard9_at(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 1, 1
    p.type, p.color = 3, 10
    p.angle, p.astep = 0.0, 0.09817477
    p.s1, p.s2 = 0.001, 1.5
    p.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 32768, 60, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 16384, 3, 4, -999999.0, -999999.0)
    p.ex[5] = tp_record(0, 65536, -999999, -999999, -999999.0, -999999.0)
    task.Wait(60)
    t10_call_async(o, s7.BossCard9_MoveSin)
    m_vel(o, "off", -1.5707964, 2.0)
    local f = 526 - o.I1 * 20
    for _ = 1, 56 do                    -- +4: //4
        task.Wait(4)
        local d = t10_wrap(t10_final_angle(o) + 3.1415927)
        et_ex(o, 0, 4, 0, 32768, f, -999999, -999999.0, -999999.0)
        if f > 10 then f = f - 6 end
        et_ex(o, 0, 3, 0, 16, 60, -999999, 0.015, d)
        et_angle(o, 0, d, 0.0)
        fire_slot(o, 0)
    end
    t10_delete(o)
end

function s7.BossCard9_at2(o)
    task.Wait(60)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 13, 1
    p.type, p.color = 0, 1
    p.angle, p.astep = 0.0, 0.09817477
    p.s1, p.s2 = 4.0, 1.5
    p.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 8192, 200, -999999, -999999.0, -999999.0)
    et_new(o, 1)
    local q = o.pat[1]
    q.aim, q.c1, q.c2 = 3, 1, 1
    q.type, q.color = 12, 1
    q.angle, q.astep = 0.0, 0.09817477
    q.s1, q.s2 = 0.01, 1.5
    q.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    q.ex[1] = tp_record(0, 8192, 200, -999999, -999999.0, -999999.0)
    ---★ 原作的 `wait(($I2 % 80) + 10)`：%I2 可负、C 的 % 也为负 ⇒ wait 值可能是 0 或负数，
    ---  而 ECL 的 wait(n<=0) 根本不等待（`clock -= n` 只会让时钟前进，随后的 jmp 又把
    ---  时钟归零）。这里若老老实实写 task.Wait(负/0) 会白白多耗 1 帧 ⇒ 只在正数时才等。
    local w = t10_imod(o.I2, 80) + 10
    if w > 0 then task.Wait(w) end
    if o.I0 ~= 0 then et_sprite(o, 0, 24, 1) end
    local e = (o.I0 == 0) and 4 or 3
    for _ = 1, e do
        local d = t10_wrap(t10_final_angle(o) + 3.1415927)
        local rad = 32 * rnd()           -- ★ 先 %RANDF 再 %RANDRAD
        local a = rndrad()
        local bx, by = circle_pos(a, rad)
        et_offset(o, 0, bx, by)
        et_offset(o, 1, bx, by)
        et_angle(o, 0, rndrad(), 0.0)
        if o.I0 == 0 then
            d = 1.5707964 + rndrad() / 8
        else
            d = t10_angle_player(o)
        end
        et_ex(o, 0, 2, 0, 256, 8, 1, d, 2.5)
        et_ex(o, 1, 2, 0, 256, 8, 1, d, 2.5)
        fire_slot(o, 0)
        fire_slot(o, 1)
        if o.I0 == 0 then task.Wait(70) else task.Wait(90) end
    end
    t10_delete(o)
end

function s7.BossCard9(o)
    t10_kill_async(o)
    m_limit_clear(o)
    t10_enm_kill_all(o)
    m_pos_time(o, "off", 60, 4, 0.0, 224.0)
    task.Wait(80)                        -- //80：原作在此 setInterrupt/spellEx/spellTimeout
    task.Wait(20)                        -- //100
    local c = 460
    o.I0 = 0
    o.I1 = 0
    while true do
        -- 上半拍：六只「石」自下缘升起（x 跳过 0）
        local a = -192.0
        o.F0 = (o.I0 == 0) and 3.141593 or -3.141593
        spawn_pod(o, a, 448.0, s7.BossCard9_at); a = a + 64; o.F0 = o.F0 * (-1)
        spawn_pod(o, a, 448.0, s7.BossCard9_at); a = a + 64; o.F0 = o.F0 * (-1)
        spawn_pod(o, a, 448.0, s7.BossCard9_at); a = a + 128
        spawn_pod(o, a, 448.0, s7.BossCard9_at); a = a + 64; o.F0 = o.F0 * (-1)
        spawn_pod(o, a, 448.0, s7.BossCard9_at); a = a + 64; o.F0 = o.F0 * (-1)
        spawn_pod(o, a, 448.0, s7.BossCard9_at)
        task.Wait(c)
        -- 下半拍：七只自上缘落下（中间那只在 $I1 ≥ 5 时省掉）
        a = -192.0
        o.I2 = t10_rand_mod60()
        spawn_pod(o, a, 0.0, s7.BossCard9_at2); o.I2 = o.I2 + 25; a = a + 64
        spawn_pod(o, a, 0.0, s7.BossCard9_at2); o.I2 = o.I2 + 25; a = a + 64
        spawn_pod(o, a, 0.0, s7.BossCard9_at2); o.I2 = o.I2 + 25; a = a + 64
        if o.I1 < 5 then spawn_pod(o, a, 0.0, s7.BossCard9_at2) end
        o.I2 = o.I2 + 25; a = a + 64
        spawn_pod(o, a, 0.0, s7.BossCard9_at2); o.I2 = o.I2 + 25; a = a + 64
        spawn_pod(o, a, 0.0, s7.BossCard9_at2); o.I2 = o.I2 + 25; a = a + 64
        spawn_pod(o, a, 0.0, s7.BossCard9_at2)
        o.I0 = 1 - o.I0
        o.I1 = o.I1 + 1
        task.Wait(c)
        if c > 60 then c = c - 50 end
    end
end

---卡 3621　祟符「ミシャグジさま」（耐久）
---  原作 BossCard10 / _at / _tbl。主弹源每轮先取 %RANDRAD，两子（etCopy）分别以该角与
---  +0.05236 出 60 发环；_tbl 读 **BOSS 血量** 与 **本机计时 %TIME** 把 $I0 推到 0→5，
---  主弹源按 $I0 把波间隔从 100 帧一路压到 30 帧。
function s7.BossCard10_at(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 60, 1
    p.type, p.color = 3, 10
    p.angle, p.astep = 0.0, 0.09817477
    p.s1, p.s2 = 1.7, 1.5
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 8192, 180, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 4096, 10000, -999999, -999999.0, -999999.0)
    p.ex[3] = tp_record(0, 32768, 60, -999999, -999999.0, -999999.0)
    et_copy(o, 1, 0)
    et_ex(o, 0, 4, 0, 32, 90, -999999, -0.01, 0.017453292)
    et_ex(o, 1, 4, 0, 32, 90, -999999, -0.01, -0.017453292)
    while true do
        local a = rndrad()
        et_angle(o, 0, a, 0.0)
        a = a + 0.05236
        et_angle(o, 1, a, 0.0)
        fire_slot(o, 0)
        fire_slot(o, 1)
        if o.I0 == 0 then task.Wait(100)
        elseif o.I0 == 1 then task.Wait(80)
        elseif o.I0 == 2 then task.Wait(60)
        elseif o.I0 == 3 then task.Wait(50)
        elseif o.I0 == 4 then task.Wait(40)
        elseif o.I0 == 5 then task.Wait(30) end
    end
end

function s7.BossCard10_tbl(o)
    local a = 0
    o.I0 = 0
    while true do                        -- +1: //1
        local life = (o.th10_boss and o.th10_boss.hp) or 0
        if a == 0 then
            if life <= 8000 then o.I0 = o.I0 + 1; a = a + 1 end
        elseif a == 1 then
            if life <= 5500 then o.I0 = o.I0 + 1; a = a + 1 end
        elseif a == 2 then
            if life <= 3500 then o.I0 = o.I0 + 1; a = a + 1 end
        elseif a == 3 then
            if life <= 1700 then o.I0 = o.I0 + 1; a = a + 1 end
        end
        if a ~= 99 and (o.__t10frames or 0) > (160 * 60 - 20 * 60) then
            o.I0 = 5
            a = 99
        end
        task.Wait(1)
    end
end

function s7.BossCard10(o)
    t10_kill_async(o)
    m_limit_clear(o)
    t10_enm_kill_all(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    task.Wait(80)
    m_limit(o, 0.0, 96.0, 280.0, 64.0)
    task.Wait(20)                        -- //100
    o.I0 = 0
    o.I1 = 0
    t10_call_async(o, s7.BossCard10_tbl)
    t10_call_async(o, s7.BossCard10_at)
    while true do                        -- //100 → //420 = 320 帧一轮
        task.Wait(320)
    end
end

--=====================================
--七·B、stage07（Extra）中 BOSS / BOSS 的非符（原生 LuaSTG；stage07 不分难度）
--  原作时间轴逐条对照 thecl 反汇编（thecl -d 10 -r -m "MAP/th10.eclm" stage07.ecl out.txt）。
--  ★ stage07（Extra）的 ECL 里没有 rank 分支，所以这些相位在唯一一档难度下原样执行。
--  ★ 这些非符与符卡在原作里共用同一只敌机：Boss1() 在 +20 帧记下 `%F0 = %ANGLE_PLAYER`，
--    后被 BossCard1()（開宴）的子程序读走。本移植一张卡一个载体，%F0 从 0 起算
--    ——和本工程既有的 s7.BossCard1 处理一致（见那张卡的注释），这里只保证非符
--    自己的时间轴逐帧对齐。
--  ★ HP = 该相 lifeSet − setInterrupt 的收尾阈值，BOSS 链一律 8000；
--    t3 = setInterrupt 的时限 3600 帧 = 60 s；t1 = t2 = setInvuln 帧数 / 60。
--=====================================

---非符 3651　洩矢諏訪子（stage07 中 BOSS 非符一，原作 MBoss1）
---  原作 MBoss()：lifeSet(9300) 之后 call("MBoss1")；
---  MBoss1 = setInvuln(60) + setInterrupt(0, 2300, 3600, "MBossCard1") ⇒ HP = 9300 − 2300 = 7000。
---  时间轴：t=60 起叫一次 MBoss1_at（那是死循环，自己每 4 帧一轮），
---  之后主线程只按 60 帧节拍空转（jmp(_320,120) → jmpNeq(_304,60) 的时钟回拨）。
function s7.MBoss1(o)
    local ct = 0
    ct = s_wait(ct, 60)                     -- +60: //60
    t10_call_async(o, s7.MBoss1_at)         -- callAsync("MBoss1_at")
    while true do                           -- _320：pushi(1); jmpNeq(_304, 60)
        ct = s_wait(ct, 120)                -- jmp(_320, 120)
        ct = s_wait(ct, 60)                 -- jmpNeq(_304, 60) —— 时钟拨回 60
    end
end

---MBoss1_at：两段各 16 / 20 轮、每轮 4 帧，打满一段立刻接下一段（jmpNeq 回 _108 是死循环）。
---  段 1：[0] 从 −192 起每轮 +24；每轮 etOffset(0, [0]+%RANDF2·8, −128)、
---        etSpeed(0, 2+%RANDF, 0)、etOn（8 发扇：基准角 π/2、每发 +0.3926991）。
---  段 2：[0] 从 +192 起每轮 −24，扇形步长取负、RANDF2/RANDF 的消耗顺序完全相同。
function s7.MBoss1_at(o)
    local ct = 0
    local a0                                 -- [0]（每波 _108 都要重写 −192）
    et_ex(o, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    ct = 8                                  -- jmp(_1500, 8)
    while true do                            -- _1500：pushi(1); jmpNeq(_108, 0)
        ct = 0
        a0 = -192.0                          -- pushi(-192); setf([0])（_108 的波首重置）
        -- ── 段 1（_108 → _760 → _408）──
        et_new(o, 0)
        et_aim(o, 0, 3)
        et_sprite(o, 0, 12, 3)
        et_count(o, 0, 1, 8)
        et_angle(o, 0, 1.5707964, 0.3926991)
        et_speed(o, 0, 1.8, 1.5)
        local n1 = 16                        -- [12]
        local o1 = n1; n1 = n1 - 1
        while o1 ~= 0 do                     -- _760：deci([12]); jmpNeq(_408, 0)
            ct = 0
            et_offset(o, 0, a0 + rnd2() * 8.0, -128.0)
            et_speed(o, 0, 2.0 + rnd(), 0.0)
            fire_slot(o, 0)                  -- etOn(0)
            a0 = a0 + 24.0                   -- [0] += 24
            ct = s_wait(ct, 4)               -- 回 _760（t=4）
            o1 = n1; n1 = n1 - 1
        end
        -- ── 段 2（_1104 → _1456）──
        et_new(o, 0)
        et_aim(o, 0, 3)
        et_sprite(o, 0, 12, 3)
        et_count(o, 0, 1, 8)
        et_angle(o, 0, 1.5707964, -0.3926991)
        et_speed(o, 0, 1.8, 1.5)
        a0 = 192.0                           -- [0] = 192
        local n2 = 20                        -- [12] = 20
        ct = 8                               -- jmp(_1456, 8)
        local o2 = n2; n2 = n2 - 1
        while o2 ~= 0 do                     -- _1456：deci([12]); jmpNeq(_1104, 4)
            ct = 4
            et_offset(o, 0, a0 + rnd2() * 8.0, -128.0)
            et_speed(o, 0, 2.0 + rnd(), 0.0)
            fire_slot(o, 0)
            a0 = a0 - 24.0                   -- [0] −= 24
            ct = s_wait(ct, 8)               -- 回 _1456（t=8）
            o2 = n2; n2 = n2 - 1
        end
    end
end

---非符 3652　洩矢諏訪子（stage07 BOSS 非符一，原作 Boss1）
---  原作 Boss()：setInvuln(200) + lifeSet(10800) 之后 call("Boss1")；
---  Boss1 = setInterrupt(0, 2800, 3600, "BossCard1") ⇒ HP = 10800 − 2800 = 8000；
---  t1 = t2 = setInvuln(200)/60。
---  时间轴：t=20 记 %F0 = %ANGLE_PLAYER；t=80 起每 60 帧叫一次 Boss1_at、+30 帧处 moveRand。
function s7.Boss1(o)
    local ct = 0
    ct = s_wait(ct, 20)                     -- +20: //20
    o.F0 = t10_angle_player(o)              -- %F0 = %ANGLE_PLAYER
    while true do                           -- _360：pushi(1); jmpNeq(_264, 80)
        ct = s_wait(ct, 80)                 -- jmp(_360, 140) → jmpNeq(_264, 80)
        t10_call_async(o, s7.Boss1_at)      -- callAsync("Boss1_at")
        ct = s_wait(ct, 110)                -- //110
        m_rand(o, "off", 30, 0, 2.0)        -- moveRand(30, 0, 2.0)
        ct = s_wait(ct, 140)                -- //140
    end
end

---Boss1_at：一发 28 环（aim=4、速 3.5→1.5），间隔 30 帧再打一发反向扇。
function s7.Boss1_at(o)
    et_new(o, 0)
    et_aim(o, 0, 4)
    et_sprite(o, 0, 6, 6)
    et_count(o, 0, 28, 4)
    et_angle(o, 0, 0.0, 0.037399914)
    et_speed(o, 0, 3.5, 1.5)
    o.pat[0].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    fire_slot(o, 0)                          -- etOn(0)
    task.Wait(30)                            -- wait(30)
    et_new(o, 0)
    et_aim(o, 0, 4)
    et_sprite(o, 0, 6, 6)
    et_count(o, 0, 28, 4)
    et_angle(o, 0, 0.0, -0.037399914)
    et_speed(o, 0, 3.5, 1.5)
    o.pat[0].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    fire_slot(o, 0)
end

---非符 3653　洩矢諏訪子（stage07 BOSS 非符二，原作 Boss2）
---  原作 Boss2：lifeSet(11600) + setInvuln(90) + setInterrupt(0, 3600, 3600, "BossCard2")
---  ⇒ HP = 11600 − 3600 = 8000；t1 = t2 = 90/60。
---  时间轴：t=110 moveLimit 之后每 60 帧叫一次 Boss2_at（它是单发，必须反复叫）、
---  +30 帧处 moveRand。
function s7.Boss2(o)
    local ct = 0
    ct = s_wait(ct, 110)                    -- +110: //110
    m_limit(o, 0.0, 96.0, 280.0, 64.0)      -- moveLimit（只在首次进入执行）
    while true do                            -- _792：pushi(1); jmpNeq(_696, 110)
        ct = s_wait(ct, 110)
        t10_call_async(o, s7.Boss2_at)      -- callAsync("Boss2_at")
        ct = s_wait(ct, 140)                -- //140
        m_rand(o, "off", 30, 0, 2.0)        -- moveRand(30, 0, 2.0)
        ct = s_wait(ct, 170)                -- //170
    end
end

---Boss2_at：32 发环（基准角 %ANGLE_PLAYER、每发 +0.3926991，速 3.0→1.5），
---  带两条分裂与一条加速记录。
function s7.Boss2_at(o)
    et_new(o, 0)
    et_aim(o, 0, 3)
    et_sprite(o, 0, 6, 6)
    et_count(o, 0, 32, 2)
    et_angle(o, 0, 0.0, 0.3926991)
    et_speed(o, 0, 3.0, 1.5)
    et_ex(o, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 0, 1, 0, 2048, 1, -999999, 1.0, -999999.0)
    et_ex(o, 0, 2, 0, 16384, 6, 2, -999999.0, -999999.0)
    et_angle(o, 0, t10_angle_player(o), 0.0)
    fire_slot(o, 0)                          -- etOn(0)
end

---非符 3654　洩矢諏訪子（stage07 BOSS 非符三，原作 Boss3）
---  原作 Boss3：lifeSet(10800) + setInvuln(60) + setInterrupt(0, 2800, 3600, "BossCard3")
---  ⇒ HP = 10800 − 2800 = 8000；t1 = t2 = 60/60 = 1。
---  时间轴：t=120 起两把异线程 at / at2（都是死循环），主线程之后每 180 帧 moveRand 一次
---  （jmp(_832,300) → jmpNeq(_788,120) 把时钟拨回 120 ⇒ 下一拍在 240）。
function s7.Boss3(o)
    local ct = 0
    ct = s_wait(ct, 120)                    -- +120: //120
    m_limit(o, 0.0, 96.0, 280.0, 64.0)      -- moveLimit
    t10_call_async(o, s7.Boss3_at)          -- callAsync("Boss3_at")
    t10_call_async(o, s7.Boss3_at2)         -- callAsync("Boss3_at2")
    while true do                            -- _832：pushi(1); jmpNeq(_788, 120)
        ct = s_wait(ct, 240)                -- _788：//240（首轮等 120 帧）
        m_rand(o, "off", 40, 0, 1.0)        -- moveRand(40, 0, 1.0)
        ct = s_wait(ct, 300)                -- //300
        ct = 120                            -- jmpNeq(_788, 120)
    end
end

---Boss3_at / _at2：每 13 帧一波、一波 8 轮，每轮 8 发环；
---  at 槽 0（角步长 −0.016362462、速 2.3→1.9、色 6）、at2 槽 1（角步长 +0.016362462、速 3.0→2.4、色 2）。
---  一波打完立刻接下一波（jmpNeq(_128, 0) 把时钟拨回 0）⇒ 每波 104 帧。
---  [0] 跨波累加：每轮 ±0.19635（validRad 归一）。
function s7.Boss3_at(o)
    local ct = 0
    local a0 = 0.0                           -- [0]
    et_offset(o, 0, 0.0, 0.0)
    while true do                             -- _600：pushi(1); jmpNeq(_128, 0)
        et_new(o, 0)
        et_aim(o, 0, 3)
        et_sprite(o, 0, 5, 6)
        et_count(o, 0, 8, 8)
        et_angle(o, 0, 1.5707964, 0.0)
        et_speed(o, 0, 2.3, 1.9)
        o.pat[0].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
        local n4 = 8                          -- [4] = 8
        local old = n4; n4 = n4 - 1
        while old ~= 0 do                     -- _556：deci([4]); jmpNeq(_396, 0)
            ct = 0                            -- jmpNeq(_396, 0)：每轮把时钟拨回 0（nop@13 才等得到 13 帧）
            et_angle(o, 0, a0, -0.016362462)
            fire_slot(o, 0)                   -- etOn(0)
            a0 = t10_wrap(a0 + 0.19635)       -- [0] += 0.19635；validRad([0])
            ct = s_wait(ct, 13)               -- //13
            old = n4; n4 = n4 - 1
        end
    end
end

function s7.Boss3_at2(o)
    local ct = 0
    local a0 = 0.0                           -- [0]
    et_offset(o, 1, 0.0, 0.0)
    while true do                             -- _600：pushi(1); jmpNeq(_128, 0)
        et_new(o, 1)
        et_aim(o, 1, 3)
        et_sprite(o, 1, 5, 2)
        et_count(o, 1, 8, 8)
        et_angle(o, 1, 1.5707964, 0.0)
        et_speed(o, 1, 3.0, 2.4)
        o.pat[1].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
        local n4 = 8                          -- [4] = 8
        local old = n4; n4 = n4 - 1
        while old ~= 0 do                     -- _556：deci([4]); jmpNeq(_396, 0)
            ct = 0                            -- jmpNeq(_396, 0)：每轮把时钟拨回 0
            et_angle(o, 1, a0, 0.016362462)
            fire_slot(o, 1)                   -- etOn(1)
            a0 = t10_wrap(a0 - 0.19635)       -- [0] −= 0.19635；validRad([0])
            ct = s_wait(ct, 13)
            old = n4; n4 = n4 - 1
        end
    end
end

---非符 3655　洩矢諏訪子（stage07 BOSS 非符四，原作 Boss4）
---  原作 Boss4：lifeSet(11600) + setInvuln(60) + setInterrupt(0, 3600, 3600, "BossCard4")
---  ⇒ HP = 8000；t1 = t2 = 1。
---  时间轴：t=120 moveLimit 之后每 60 帧叫一次 Boss4_at、+30 帧处 moveRand。
function s7.Boss4(o)
    local ct = 0
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)  -- movePosTime(60, 4, 0, 128)（t=0）
    ct = s_wait(ct, 120)                    -- +120: //120
    m_limit(o, 0.0, 96.0, 280.0, 64.0)
    while true do                            -- _852：pushi(1); jmpNeq(_756, 120)
        ct = s_wait(ct, 120)
        t10_call_async(o, s7.Boss4_at)      -- callAsync("Boss4_at")
        ct = s_wait(ct, 150)                -- //150
        m_rand(o, "off", 30, 0, 2.0)
        ct = s_wait(ct, 180)                -- //180
    end
end

---Boss4_at：32 发环（速 5.0→1.5、角不递增），间隔 30 帧再打一模一样的一发。
function s7.Boss4_at(o)
    et_new(o, 0)
    et_aim(o, 0, 2)
    et_sprite(o, 0, 6, 6)
    et_count(o, 0, 32, 4)
    et_angle(o, 0, 0.0, 0.0)
    et_speed(o, 0, 5.0, 1.5)
    o.pat[0].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    fire_slot(o, 0)
    task.Wait(30)                            -- wait(30)
    et_new(o, 0)
    et_aim(o, 0, 2)
    et_sprite(o, 0, 6, 6)
    et_count(o, 0, 32, 4)
    et_angle(o, 0, 0.0, 0.0)
    et_speed(o, 0, 5.0, 1.5)
    o.pat[0].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    fire_slot(o, 0)
end

---非符 3656　洩矢諏訪子（stage07 BOSS 非符五，原作 Boss5）
---  原作 Boss5：lifeSet(11500) + setInvuln(90) + setInterrupt(0, 3500, 3600, "BossCard5")
---  ⇒ HP = 11500 − 3500 = 8000；t1 = t2 = 90/60。
---  时间轴：t=110 moveLimit 之后每 50 帧叫一次 Boss5_at（jmp(_872,160) → jmpNeq(_776,110)）、
---  +20 帧处 moveRand。
function s7.Boss5(o)
    local ct = 0
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)  -- movePosTime(60, 4, 0, 128)（t=0）
    ct = s_wait(ct, 110)                    -- +110: //110
    m_limit(o, 0.0, 96.0, 280.0, 64.0)
    while true do                            -- _872：pushi(1); jmpNeq(_776, 110)
        ct = s_wait(ct, 110)
        t10_call_async(o, s7.Boss5_at)      -- callAsync("Boss5_at")
        ct = s_wait(ct, 130)                -- //130
        m_rand(o, "off", 30, 0, 2.0)
        ct = s_wait(ct, 160)                -- //160
    end
end

---Boss5_at：与 Boss2_at 逐条相同（32 发环 + 两条分裂/加速记录、基准角 %ANGLE_PLAYER）。
function s7.Boss5_at(o)
    et_new(o, 0)
    et_aim(o, 0, 3)
    et_sprite(o, 0, 6, 6)
    et_count(o, 0, 32, 2)
    et_angle(o, 0, 0.0, 0.3926991)
    et_speed(o, 0, 3.0, 1.5)
    et_ex(o, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 0, 1, 0, 2048, 1, -999999, 1.0, -999999.0)
    et_ex(o, 0, 2, 0, 16384, 6, 2, -999999.0, -999999.0)
    et_angle(o, 0, t10_angle_player(o), 0.0)
    fire_slot(o, 0)
end

---非符 3657　洩矢諏訪子（stage07 BOSS 非符六，原作 Boss6）
---  原作 Boss6：lifeSet(11500) + setInvuln(60) + setInterrupt(0, 3500, 3600, "BossCard6")
---  ⇒ HP = 8000；t1 = t2 = 1。结构与 Boss3 相同：t=120 起两把异线程、之后每 180 帧 moveRand。
function s7.Boss6(o)
    local ct = 0
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)  -- movePosTime(60, 4, 0, 128)（t=0）
    ct = s_wait(ct, 120)                    -- +120: //120
    m_limit(o, 0.0, 96.0, 280.0, 64.0)
    t10_call_async(o, s7.Boss6_at)          -- callAsync("Boss6_at")
    t10_call_async(o, s7.Boss6_at2)         -- callAsync("Boss6_at2")
    while true do                            -- _864：pushi(1); jmpNeq(_820, 120)
        ct = s_wait(ct, 240)                -- _820：//240（首轮等 120 帧）
        m_rand(o, "off", 40, 0, 1.0)
        ct = s_wait(ct, 300)                -- //300
        ct = 120
    end
end

---Boss6_at / _at2：与 Boss3_at / Boss3_at2 逐条相同（槽 0 / 槽 1、角步长 ∓0.016362462）。
function s7.Boss6_at(o)
    local ct = 0
    local a0 = 0.0                           -- [0]
    et_offset(o, 0, 0.0, 0.0)
    while true do                             -- _600：pushi(1); jmpNeq(_128, 0)
        et_new(o, 0)
        et_aim(o, 0, 3)
        et_sprite(o, 0, 5, 6)
        et_count(o, 0, 8, 8)
        et_angle(o, 0, 1.5707964, 0.0)
        et_speed(o, 0, 2.3, 1.9)
        o.pat[0].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
        local n4 = 8                          -- [4] = 8
        local old = n4; n4 = n4 - 1
        while old ~= 0 do                     -- _556：deci([4]); jmpNeq(_396, 0)
            ct = 0                            -- jmpNeq(_396, 0)：每轮把时钟拨回 0（nop@13 才等得到 13 帧）
            et_angle(o, 0, a0, -0.016362462)
            fire_slot(o, 0)
            a0 = t10_wrap(a0 + 0.19635)
            ct = s_wait(ct, 13)
            old = n4; n4 = n4 - 1
        end
    end
end

function s7.Boss6_at2(o)
    local ct = 0
    local a0 = 0.0                           -- [0]
    et_offset(o, 1, 0.0, 0.0)
    while true do                             -- _600：pushi(1); jmpNeq(_128, 0)
        et_new(o, 1)
        et_aim(o, 1, 3)
        et_sprite(o, 1, 5, 2)
        et_count(o, 1, 8, 8)
        et_angle(o, 1, 1.5707964, 0.0)
        et_speed(o, 1, 3.0, 2.4)
        o.pat[1].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
        local n4 = 8                          -- [4] = 8
        local old = n4; n4 = n4 - 1
        while old ~= 0 do                     -- _556：deci([4]); jmpNeq(_396, 0)
            ct = 0                            -- jmpNeq(_396, 0)：每轮把时钟拨回 0
            et_angle(o, 1, a0, 0.016362462)
            fire_slot(o, 1)
            a0 = t10_wrap(a0 - 0.19635)
            ct = s_wait(ct, 13)
            old = n4; n4 = n4 - 1
        end
    end
end

---非符 3658　洩矢諏訪子（stage07 BOSS 非符七，原作 Boss7）
---  原作 Boss7：lifeSet(12500) + setInvuln(60) + setInterrupt(0, 4500, 3600, "BossCard7")
---  ⇒ HP = 12500 − 4500 = 8000；t1 = t2 = 1。结构与 Boss4 相同。
function s7.Boss7(o)
    local ct = 0
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)  -- movePosTime(60, 4, 0, 128)（t=0）
    ct = s_wait(ct, 120)                    -- +120: //120
    m_limit(o, 0.0, 96.0, 280.0, 64.0)
    while true do                            -- _852：pushi(1); jmpNeq(_756, 120)
        ct = s_wait(ct, 120)
        t10_call_async(o, s7.Boss7_at)      -- callAsync("Boss7_at")
        ct = s_wait(ct, 150)                -- //150
        m_rand(o, "off", 30, 0, 2.0)
        ct = s_wait(ct, 180)                -- //180
    end
end

---Boss7_at：与 Boss4_at 逐条相同（32 发环、间隔 30 帧再打一发）。
function s7.Boss7_at(o)
    et_new(o, 0)
    et_aim(o, 0, 2)
    et_sprite(o, 0, 6, 6)
    et_count(o, 0, 32, 4)
    et_angle(o, 0, 0.0, 0.0)
    et_speed(o, 0, 5.0, 1.5)
    o.pat[0].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    fire_slot(o, 0)
    task.Wait(30)                            -- wait(30)
    et_new(o, 0)
    et_aim(o, 0, 2)
    et_sprite(o, 0, 6, 6)
    et_count(o, 0, 32, 4)
    et_angle(o, 0, 0.0, 0.0)
    et_speed(o, 0, 5.0, 1.5)
    o.pat[0].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    fire_slot(o, 0)
end

---非符 3659　洩矢諏訪子（stage07 BOSS 非符八，原作 Boss8，最后一相非符）
---  原作 Boss8：lifeSet(8001) + setInvuln(90) + setInterrupt(0, 1, 3600, "BossCard8")
---  ⇒ HP = 8001 − 1 = 8000；t1 = t2 = 90/60。
---  时间轴：t=110 起只叫一次 Boss8_at（死循环），主线程之后每 50 帧 moveRand。
function s7.Boss8(o)
    local ct = 0
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)  -- movePosTime(60, 4, 0, 128)（t=0）
    ct = s_wait(ct, 110)                    -- +110: //110
    m_limit(o, 0.0, 96.0, 280.0, 64.0)
    t10_call_async(o, s7.Boss8_at)          -- callAsync("Boss8_at")
    while true do                            -- _824：pushi(1); jmpNeq(_760, 110)
        ct = 110                            -- jmpNeq(_760, 110)
        ct = s_wait(ct, 130)                -- //130
        m_rand(o, "off", 30, 0, 2.0)
        ct = s_wait(ct, 160)                -- //160（_824）
    end
end

---Boss8_at：56 发环（速 4.0→1.5、每发 +0.3926991），每 10 帧重瞄一次自机再打，
---  死循环（jmp(_332, 0) → jmpNeq(_264, 0) 恒真）。
function s7.Boss8_at(o)
    et_new(o, 0)
    et_aim(o, 0, 3)
    et_sprite(o, 0, 6, 10)
    et_count(o, 0, 56, 1)
    et_angle(o, 0, 0.0, 0.3926991)
    et_speed(o, 0, 4.0, 1.5)
    o.pat[0].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    while true do                            -- _332：pushi(1); jmpNeq(_264, 0)
        et_angle(o, 0, t10_angle_player(o), 0.0)
        fire_slot(o, 0)                      -- etOn(0)
        task.Wait(10)                        -- wait(10)
    end
end

--=====================================
--八·B、stage03 / stage04 非符（原生 LuaSTG；只做 Lunatic 难度行）
--  stage04 的中 BOSS（射命丸文）也是一张纯非符（原作 MBoss / MBossAt），
--  与 BOSS 同组「4a」注册在最前（原作里中 BOSS 先于 BOSS 出场）。
--  照例逐条读 thecl 反汇编
--      thecl -d 10 -r -m "MAP/th10.eclm" stage03.ecl out.txt
--  ＋ TH10 1.00a 复原源码，把每条 ECL 指令翻成原生 LuaSTG
--  （task.Wait 计时 / fire_slot 出弹 / spawn_pod 叫子机 / m_rand 走位）。
--
--  ★ 原作的非符与符卡共用同一只敌机（Boss() 里 setInterrupt 一路切到 BossCard1()…），
--    %F0/$I0 这些寄存器跨相保留；本移植版一张卡一个载体，所以凡「上一相设置、
--    下一相读取」的寄存器都在读的一方重建（见各卡注释）。
--  ★ stage03 的 Boss1/Boss2/Boss3 用 callAsyncId(name, 0) 起线程、killAsync(0) 停它
--    （EclVm.cpp:726-745：id = 名字后的第 1 个实参，只有 callAsyncId 出来的线程有 id；
--    主线程 id = −1 ⇒ killAsync(0) 命中的就是它）。这里用 o.t10_tid[id] 存协程，
--    killAsync 把它从 o.task 摘掉 —— THlib 停任务就是这个做法。
--  ★ 演出/流程指令（timerReset / lifeSet / lifeMarker / setInterrupt / setChapter /
--    stars / playSound / anm* / TIMEOUT 分支的 etClear·etCancel·drop*）在本移植里
--    按无效果处理或交给卡片框架；它们都不占帧，漏掉不影响弹幕时间轴。
--=====================================
local s3n = {}
local s4n = {}

---callAsyncId(name, id)：起一个带 id 的 ECL 线程（id 记在载体上）。
local function t10_async_id(o, id, fn)
    local co = task.New(o, function() fn(o) end)
    o.t10_tid = o.t10_tid or {}
    o.t10_tid[id] = co
    return co
end

---killAsync(id)：停掉 id 号线程（找不到就是 no-op）。
---★ 用「换一张 o.task 表」而不是表内 table.remove：真引擎 task:Do 用 pairs 遍历 o.task，
---  遍历中间挪数组是未定义行为（会漏跑挨着的线程）；换表与 task:Clear 同款写法。
---  自检桩件按「协程还在不在 o.task 里」判存活，两边语义一致。
local function t10_kill_id(o, id)
    local m = o.t10_tid
    local co = m and m[id]
    if co == nil then return end
    m[id] = nil
    local ts = o.task
    if ts then
        local keep = {}
        for i = 1, #ts do
            if ts[i] ~= co then keep[#keep + 1] = ts[i] end
        end
        o.task = keep
    end
end

---非符 3651　河城荷取（stage03 BOSS 非符一）
---  原作 Boss1：入场 120 帧后进入 120 帧一轮的循环——_368 把时钟拨回 0：
---    t=0   callAsyncId("Boss1_at", 0)（三槽螺旋，本身是死循环）
---    t=60  killAsync(0) 停掉 at → moveRand(40,0,2.0) → callAsyncId("Boss1_at2", 0)
---    t=120 killAsync(0) 停掉 at2 → 回 t=0
---  HP = Boss() 的 lifeSet 8800 − setInterrupt 阈值 2300 = 6500；
---  t1 = t2 = Boss() 的 setInvuln(60)/60 = 1（Boss1 自己不带 setInvuln）。
function s3n.Boss1(o)
    local ct = 0
    ct = 120                                    -- jmp(Boss1_368, 120)
    while true do                               -- _368：pushi(1); jmpNeq(Boss1_168, 0)
        ct = 0
        t10_async_id(o, 0, s3n.Boss1_at)        -- callAsyncId("Boss1_at", 0)
        ct = s_wait(ct, 60)                     -- //60
        t10_kill_id(o, 0)                       -- killAsync(0)
        m_rand(o, "off", 40, 0, 2.0)            -- moveRand(40, 0, 2.0)
        t10_async_id(o, 0, s3n.Boss1_at2)       -- callAsyncId("Boss1_at2", 0)
        ct = s_wait(ct, 120)                    -- //120
        t10_kill_id(o, 0)                       -- killAsync(0)
    end
end

---Boss1_at：三槽（初始角 π/2、−π/3、−2π/3）绕自身旋转的螺旋。
---  L：astep 0.11219974、速度 4.5、内层每轮 32 发（[0]）；每轮先 etCount 改内层发数、
---  2 帧后 etOn 三槽一起打。
---  ★ 外层 `pushi(1); jmpNeq(_928, 0)` 是死循环：每 32 轮把 [0] 复位、[4] 从 1 重新数。
function s3n.Boss1_at(o)
    local astep = 0.11219974                    -- diffF([8], 0.3926991,0.19634955,0.19634955,0.11219974)
    local spd = 4.5                             -- diffF([12], 2.5,2.5,3.5,4.5)
    et_new(o, 0); et_aim(o, 0, 1); et_sprite(o, 0, 8, 6); et_count(o, 0, 1, 1)
    et_angle(o, 0, 1.5707964, astep); et_speed(o, 0, spd, 1.0)
    et_new(o, 1); et_aim(o, 1, 1); et_sprite(o, 1, 8, 6); et_count(o, 1, 1, 1)
    et_angle(o, 1, -1.0471976, astep); et_speed(o, 1, spd, 1.0)
    et_new(o, 2); et_aim(o, 2, 1); et_sprite(o, 2, 8, 6); et_count(o, 2, 1, 1)
    et_angle(o, 2, -2.0943952, astep); et_speed(o, 2, spd, 1.0)
    for i = 0, 2 do
        o.pat[i].ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
        o.pat[i].ex[1] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    end
    local ct = 0
    ct = 2                                      -- jmp(Boss1_at_1292, 2)
    while true do                               -- _1292：pushi(1); jmpNeq(_928, 0)
        ct = 0
        local n0 = 32                           -- diffI([0], 8,16,16,32) L
        local n4 = 1                            -- [4] = 1
        ct = 2                                  -- jmp(_1248, 2)
        local old = n0; n0 = n0 - 1             -- _1248：deci([0])
        while old ~= 0 do                       -- jmpNeq(_1028, 0)
            ct = 0
            et_count(o, 0, n4, 1); et_count(o, 1, n4, 1); et_count(o, 2, n4, 1)
            ct = s_wait(ct, 2)                  -- +2：三槽 etOn
            fire_slot(o, 0); fire_slot(o, 1); fire_slot(o, 2)
            n4 = n4 + 1                         -- [4] += 1
            old = n0; n0 = n0 - 1               -- 落回 _1248
        end
    end
end

---Boss1_at2：单槽（槽 1）每 20 帧一波、每波 5 发 × 3 圈的自机狙。
---  L：c2 = 3（= etCount(1, 5, [12]) 的第 2 个计数，**不是外层循环次数**）、速度 4.6。
function s3n.Boss1_at2(o)
    local c2 = 3                                -- diffI([12], 1,1,3,3) L
    local spd = 4.6                             -- diffF([8], 1.6,1.6,3.0,4.6) L
    et_new(o, 1); et_aim(o, 1, 0); et_sprite(o, 1, 12, 3)
    et_count(o, 1, 5, c2); et_angle(o, 1, 0.0, 0.3926991); et_speed(o, 1, spd, 1.0)
    o.pat[1].ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    o.pat[1].ex[1] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    local ct = 0
    while true do                               -- _444：pushi(1); jmpNeq(_424, 0)
        ct = 0
        ct = s_wait(ct, 20)                     -- _424：etOn(1) 在 t=20
        fire_slot(o, 1)
    end
end

---非符 3652　河城荷取（stage03 BOSS 非符二）
---  原作 Boss2：lifeSet(8600) + setInterrupt(0, 2100, 3600, "BossCard2") ⇒ HP = 6500。
---  入场 560 帧（jmp(Boss2_1104, 560)）后进入 440 帧一轮的循环（_1104 把时钟拨回 120）：
---    t=120 %F0 = +0.004134 → callAsyncId("Boss2_at", 0)
---    t=280 killAsync(0) → moveRand(40,0,2.0) → callAsyncId("Boss2_at2", 0)
---    t=340 killAsync(0) → %F0 = −0.004134 → callAsyncId("Boss2_at", 0)
---    t=500 killAsync(0) → moveRand(40,0,2.0) → callAsyncId("Boss2_at2", 0)
---    t=560 killAsync(0) → 回 t=120
function s3n.Boss2(o)
    local ct = 0
    ct = s_wait(ct, 120)                        -- +120: //120（原作 nop 在 t=120）
    ct = 560                                    -- jmp(Boss2_1104, 560)
    while true do                               -- _1104：pushi(1); jmpNeq(Boss2_624, 120)
        ct = 120
        o.F0 = 0.004134                         -- %F0：Boss2_at 每轮的转角增量
        t10_async_id(o, 0, s3n.Boss2_at)
        ct = s_wait(ct, 280)                    -- //280
        t10_kill_id(o, 0)
        m_rand(o, "off", 40, 0, 2.0)
        t10_async_id(o, 0, s3n.Boss2_at2)
        ct = s_wait(ct, 340)                    -- //340
        t10_kill_id(o, 0)
        o.F0 = -0.004134
        t10_async_id(o, 0, s3n.Boss2_at)
        ct = s_wait(ct, 500)                    -- //500
        t10_kill_id(o, 0)
        m_rand(o, "off", 40, 0, 2.0)
        t10_async_id(o, 0, s3n.Boss2_at2)
        ct = s_wait(ct, 560)                    -- //560
        t10_kill_id(o, 0)
    end
end

---Boss2_at：三槽（π/2、−π/3、−2π/3）螺旋，每轮把三个角各 +%F0（%F0 由主线程给）。
---  L：astep 0.19634955、速度 3.5、内层每轮 20 发（[0]）。
---  ★ [8]/[12]/[16] 三个基准角在每轮外层（_928）重新写死 ⇒ 角度不会被上一轮带偏；
---    外层每跑完 20 轮把 %F0 取反（±0.004134 交替）。
function s3n.Boss2_at(o)
    local astep = 0.19634955                    -- diffF([24], 0.3926991,0.3926991,0.2617994,0.19634955)
    local spd = 3.5                             -- diffF([20], 2.0,2.5,3.5,3.5)
    et_new(o, 0); et_aim(o, 0, 1); et_sprite(o, 0, 8, 6); et_count(o, 0, 1, 1)
    et_angle(o, 0, 1.5707964, astep); et_speed(o, 0, spd, 1.0)
    et_new(o, 1); et_aim(o, 1, 1); et_sprite(o, 1, 8, 6); et_count(o, 1, 1, 1)
    et_angle(o, 1, -1.0471976, astep); et_speed(o, 1, spd, 1.0)
    et_new(o, 2); et_aim(o, 2, 1); et_sprite(o, 2, 8, 6); et_count(o, 2, 1, 1)
    et_angle(o, 2, -2.0943952, astep); et_speed(o, 2, spd, 1.0)
    for i = 0, 2 do
        o.pat[i].ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
        o.pat[i].ex[1] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    end
    local ct = 0
    ct = 2                                      -- jmp(Boss2_at_1860, 2)
    while true do                               -- _1860：pushi(1); jmpNeq(_928, 0)
        ct = 0
        local n0 = 20                           -- diffI([0], 10,10,15,20) L
        local n4 = 1                            -- [4] = 1
        local a8, a12, a16 = 1.570796, -1.047198, -2.094395
        ct = 2                                  -- jmp(_1740, 2)
        local old = n0; n0 = n0 - 1             -- _1740：deci([0])
        while old ~= 0 do                       -- jmpNeq(_1148, 0)
            ct = 0
            et_angle(o, 0, a8, astep)           -- _1148（t=0）
            et_angle(o, 1, a12, astep)
            et_angle(o, 2, a16, astep)
            et_count(o, 0, n4, 1)
            et_count(o, 1, n4, 1)
            et_count(o, 2, n4, 1)
            ct = s_wait(ct, 2)                  -- +2
            fire_slot(o, 0); fire_slot(o, 1); fire_slot(o, 2)
            a8 = a8 + o.F0                      -- [8] += %F0
            a12 = a12 + o.F0                    -- [12] += %F0
            a16 = a16 + o.F0                    -- [16] += %F0
            o.F0 = t10_wrap(o.F0)               -- validRad(%F0/%F1/%F2)
            o.F1 = t10_wrap(o.F1)
            o.F2 = t10_wrap(o.F2)
            n4 = n4 + 1                         -- [4] += 1
            old = n0; n0 = n0 - 1               -- 落回 _1740
        end
        o.F0 = -o.F0                            -- 20 轮后 %F0 = −%F0
    end
end

---Boss2_at2：单槽（槽 3）每 20 帧一波、每波 5 发 × 1 圈。
function s3n.Boss2_at2(o)
    et_new(o, 3); et_aim(o, 3, 0); et_sprite(o, 3, 12, 3)
    et_count(o, 3, 5, 1); et_angle(o, 3, 0.0, 0.3926991); et_speed(o, 3, 1.6, 1.0)
    o.pat[3].ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    o.pat[3].ex[1] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    local ct = 0
    while true do                               -- _372：pushi(1); jmpNeq(_352, 0)
        ct = 0
        ct = s_wait(ct, 20)                     -- _352：etOn(3) 在 t=20
        fire_slot(o, 3)
    end
end

---非符 3653　河城荷取（stage03 BOSS 非符三）
---  原作 Boss3：lifeSet(8800) + !L setInterrupt(0, 2300, 3600, "BossCard3L") ⇒ HP = 6500。
---  结构与 Boss2 完全一样（共用 Boss2_at / Boss2_at2），只有 %F0 按难度分档：
---  !E 0.004909 / !NH 0.008727 / !L 0.006283 —— 而且**两拍都是 +0.006283**
---  （不像 Boss2 第二拍取负）。
function s3n.Boss3(o)
    local ct = 0
    ct = s_wait(ct, 120)                        -- +120: //120（原作 nop 在 t=120）
    ct = 560                                    -- jmp(Boss3_1336, 560)
    while true do                               -- _1336：pushi(1); jmpNeq(Boss3_696, 120)
        ct = 120
        o.F0 = 0.006283                         -- !L
        t10_async_id(o, 0, s3n.Boss2_at)
        ct = s_wait(ct, 280)                    -- //280
        t10_kill_id(o, 0)
        m_rand(o, "off", 40, 0, 2.0)
        t10_async_id(o, 0, s3n.Boss2_at2)
        ct = s_wait(ct, 340)                    -- //340
        t10_kill_id(o, 0)
        o.F0 = 0.006283                         -- 第二拍也是 +0.006283（!L）
        t10_async_id(o, 0, s3n.Boss2_at)
        ct = s_wait(ct, 500)                    -- //500
        t10_kill_id(o, 0)
        m_rand(o, "off", 40, 0, 2.0)
        t10_async_id(o, 0, s3n.Boss2_at2)
        ct = s_wait(ct, 560)                    -- //560
        t10_kill_id(o, 0)
    end
end

---中BOSS 非符 3670　射命丸文（stage04 中 BOSS；原作 MBoss + MBossAt）
---  MBoss：入场 movePosTime(60, 4, 0, 128)；lifeSet(10000)、
---    setInterrupt(1, 0, 1800, "MBossDead") 的阈值是 0 ⇒ HP = 10000、时限 1800 帧 = 30 s；
---    setInvuln(200) ⇒ t1 = t2 = 200/60。
---  主循环（_684 的 deci([4])，[4] 初值 100）每轮真实 240 帧：
---    //60  %F0 = 2.019595 → 同步 call("MBossAt")（占 81 帧）→ moveRand(60, 4, 1.5)
---    //100 %F0 = 1.121997 → 同步 call("MBossAt")（占 81 帧）→ moveRand(60, 4, 1.5)
---    //140 回到 deci。deci 的第 0 次（old = 100）在同一帧里就跳到 //60。
function s4n.MBoss(o)
    local ct = 0
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)     -- movePosTime(60, 4, 0, 128)
    local n4 = 100                              -- seti([4], 100)
    ct = s_wait(ct, 60)                         -- +60: //60
    m_limit(o, 0.0, 96.0, 280.0, 64.0)          -- moveLimit(0, 96, 280, 64)
    ct = 140                                    -- jmp(MBoss_684, 140)
    while true do                               -- MBoss_684：deci([4]); jmpNeq(MBoss_460, 60)
        local old = n4; n4 = n4 - 1
        if old == 0 then break end
        ct = 60                                 -- jmpNeq(MBoss_460, 60)：时钟拨回 60
        o.F0 = 2.019595                         -- setf(%F0)
        s4n.MBossAt(o)                          -- call("MBossAt")（同步：占 81 真实帧）
        m_rand(o, "off", 60, 4, 1.5)            -- moveRand(60, 4, 1.5)
        ct = s_wait(ct, 100)                    -- +40: //100
        o.F0 = 1.121997                         -- setf(%F0)
        s4n.MBossAt(o)                          -- call("MBossAt")（同步：占 81 真实帧）
        m_rand(o, "off", 60, 4, 1.5)            -- moveRand(60, 4, 1.5)
        ct = s_wait(ct, 140)                    -- +40: //140
    end
end

---MBossAt（**同步子程序**，只由 MBoss 用 call 调用）：绕 BOSS 画螺旋，80 帧各出一排两发。
---  槽 0：角 [16] 每帧 += 0.15708（validRad），半径 [12] 每帧 += 1.5（从 1.0 起）；
---  槽 1：与槽 0 同角、半径取反（原作把 [12] 取负→circlePos→再取负）。
---  deci([0]) 从 80 递减：第 0 帧只跑 head（4 条指令的时间戳都是 0），
---  之后每帧「tail(t=1) → deci → head(t=0)」；81 帧后 ret，调用者的 clock 才恢复。
function s4n.MBossAt(o)
    local a12 = 1.0                             -- setf([12], 1.0)
    local n0 = 80                               -- seti([0], 80)
    et_new(o, 0); et_aim(o, 0, 3); et_sprite(o, 0, 3, 6)
    et_count(o, 0, 3, 1)
    et_angle(o, 0, 0.0, 0.7853982)
    et_speed(o, 0, 1.8, 1.0)
    et_ex(o, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 0, 2, 0, 8192, 100, -999999, -999999.0, -999999.0)
    et_copy(o, 1, 0)
    et_angle(o, 1, o.F0, 0.31415927)            -- etAngle(1, %F0, 0.31415927)
    et_count(o, 0, 5, 2)                        -- etCountD(0, 1,5,6,5, 1,1,1,2) 的 L 行
    et_sprite(o, 0, 3, 6); et_sprite(o, 1, 12, 3)
    et_speed(o, 0, 1.8, 1.0)                    -- etSpeedD(0, …) 的 L 行
    et_speed(o, 1, 1.2, 1.0)                    -- etSpeedD(1, …) 的 L 行
    local a16 = rndrad()                        -- setf([16], %RANDRAD)
    local function head()                       -- _744 的 t=0 段
        a12 = a12 + 1.5                         -- [12] += 1.5
        a16 = t10_wrap(a16 + 0.15708)           -- [16] += 0.15708；validRad([16])
        et_angle(o, 0, a16, 0.31415927)         -- etAngle(0, [16], 0.31415927)
        et_offset(o, 0, circle_pos(a16, a12))   -- circlePos([4],[8],[16],[12]); etOffset(0,…)
    end
    local function tail()                       -- _744 的 t=1 段
        fire_slot(o, 0)                         -- etOn(0)
        et_offset(o, 1, circle_pos(a16, -a12))  -- [12] 取负 → circlePos → 取回；etOffset(1,…)
        fire_slot(o, 1)                         -- etOn(1)
    end
    n0 = n0 - 1                                 -- 第 0 帧的 deci([0])（old = 80 ≠ 0 ⇒ 跳转）
    head()
    while true do
        task.Wait(1)
        tail()
        local old = n0; n0 = n0 - 1             -- 下一帧的 deci([0])
        if old == 0 then break end              -- jmpNeq(MBossAt_744, 0)
        head()
    end
end

---非符 3654　射命丸文（stage04 BOSS 非符一）
---  原作 Boss1：lifeSet 9500（Boss() 给的）− setInterrupt 阈值 2500 = HP 7000。
---  入场 280 帧（jmp(Boss1_504, 280)）后进入 280 帧一轮的循环（_504 把时钟拨回 0）：
---    t=0   callAsync("BossCharge")（8 只只转不打的使魔，偏移 −16）
---    t=60  callAsync("Boss1_at2")（8 轮 × 4 组圆环）
---    t=80  callAsync("BossChargeL")（与 BossCharge 同构，只有偏移取 +16）
---    t=140 callAsync("Boss1_at3")（同 at2，基准角不同、每轮 +0.314159）
---    t=220 moveRand(40, 0, 4.0)
---    t=280 回 t=0
function s4n.Boss1(o)
    local ct = 0
    ct = 280                                    -- jmp(Boss1_504, 280)
    while true do                               -- _504：pushi(1); jmpNeq(Boss1_168, 0)
        ct = 0
        t10_call_async(o, s4_BossCharge)        -- callAsync("BossCharge")
        ct = s_wait(ct, 60)                     -- //60
        t10_call_async(o, s4n.Boss1_at2)
        ct = s_wait(ct, 80)                     -- //80
        t10_call_async(o, s4n.BossChargeL)
        ct = s_wait(ct, 140)                    -- //140
        t10_call_async(o, s4n.Boss1_at3)
        ct = s_wait(ct, 220)                    -- //220
        m_rand(o, "off", 40, 0, 4.0)
        ct = s_wait(ct, 280)                    -- //280
    end
end

---BossChargeL = BossCharge 的 +16 版（Lunatic 行专用），逐条相同、只有偏移取正。
function s4n.BossChargeL(o)
    s4_BossCharge(o, 16.0)
end

---Boss1_at（**同步子程序**，被 at2/at3 用 call 调用）：一次调用 = 同一帧打出 [16] 发
---  （L = 16）圆环，出弹点 = circlePos([20], [8])，[20] 每发 +2π/[16]。
---  实参按 ECL 调用约定落 [0]/[4]/[8]/[12]：基准角 / 速度 / 半径 / 精灵色。
---  ★ 整段没有 wait ⇒ 16 发全在同一帧出（原作就是「一发指令打一圈」）。
function s4n.Boss1_at(o, a0, a4, a8, aC)
    local n16 = 16                              -- diffI([16], 12,12,12,16) L
    et_new(o, 0); et_aim(o, 0, 1); et_sprite(o, 0, 2, aC); et_count(o, 0, 1, 1)
    et_angle(o, 0, a0, 0.0); et_speed(o, 0, a4, 1.0)
    o.pat[0].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    o.pat[0].ex[1] = tp_record(0, 8192, 60, -999999, -999999.0, -999999.0)
    local a20 = a0                              -- [20] = [0]
    local a24 = 6.2831855 / n16                 -- [24] = 2π/[16]
    local old = n16; n16 = n16 - 1              -- jmp(_640, 0) → _640：deci([16])
    while old ~= 0 do
        local x, y = circle_pos(a20, a8)        -- circlePos(%F0, %F1, [20], [8])
        et_offset(o, 0, x, y)
        fire_slot(o, 0)                         -- etOn(0)
        a20 = t10_wrap(a20 + a24)               -- [20] += [24]；validRad([20])
        old = n16; n16 = n16 - 1
    end
    et_offset(o, 0, 0.0, 0.0)                   -- etOffset(0, 0, 0)
end

---Boss1_at2 / Boss1_at3：8 轮 × 4 组圆环，每轮 5 帧。
---  L：($DIFF≥1)、($DIFF≥2) 两个条件都恒真 ⇒ 每轮 4 次 call（色 6/2/4/4）。
---  at2：基准角 2.356194、每轮 −0.314159；at3：基准角 0.785398、每轮 +0.314159。
---  两者每轮都 [4] += 0.3、[8] += 16。
function s4n.Boss1_at2(o)
    local a0, a4, a8 = 2.356194, 0.8, 16.0
    local n12 = 8                               -- [12] = 8
    local ct = 0
    ct = 5                                      -- jmp(Boss1_at2_1160, 5)
    local old = n12; n12 = n12 - 1              -- _1160：deci([12])
    while old ~= 0 do
        ct = 0                                  -- jmpNeq(_240, 0)
        s4n.Boss1_at(o, a0, a4, a8, 6)          -- ($DIFF≥1) or ([12]%2==0)：L 恒真
        s4n.Boss1_at(o, a0 - PI, a4, a8, 2)
        s4n.Boss1_at(o, a0 - 1.5707964, a4, a8, 4)   -- $DIFF≥2：L 恒真
        s4n.Boss1_at(o, a0 + 1.5707964, a4, a8, 4)
        a4 = a4 + 0.3                           -- _932 组（t=0）
        a8 = a8 + 16.0
        ct = s_wait(ct, 5)
        a0 = a0 - 0.314159                      -- t=5
        old = n12; n12 = n12 - 1
    end
end

function s4n.Boss1_at3(o)
    local a0, a4, a8 = 0.785398, 0.8, 16.0
    local n12 = 8
    local ct = 0
    ct = 5                                      -- jmp(Boss1_at3_1160, 5)
    local old = n12; n12 = n12 - 1
    while old ~= 0 do
        ct = 0
        s4n.Boss1_at(o, a0, a4, a8, 6)
        s4n.Boss1_at(o, a0 - PI, a4, a8, 2)
        s4n.Boss1_at(o, a0 - 1.5707964, a4, a8, 4)
        s4n.Boss1_at(o, a0 + 1.5707964, a4, a8, 4)
        a4 = a4 + 0.3
        a8 = a8 + 16.0
        ct = s_wait(ct, 5)
        a0 = a0 + 0.314159                      -- t=5（at3 是加）
        old = n12; n12 = n12 - 1
    end
end

---非符 3655　射命丸文（stage04 BOSS 非符二）
---  原作 Boss2：lifeSet(9500) + setInterrupt(0, 2500, 3600, "BossCard2") ⇒ HP = 7000。
---  入场 240 帧（jmp(Boss2_932, 240)）后进入 120 帧一轮的循环（_932 把时钟拨回 120）：
---    t=120 callAsync("BossCharge")（此时在本仓库坐标里是 t=0 时间戳的指令）
---    t=180 callAsync("Boss2_at2") + callAsync("Boss2_at3") + diffWait(…,50) + moveRand
---    t=240 回 t=120
---  ★ diffWait(80,80,50,50) ⇒ L 时 clock 被减 50，把 //240 的等待从 60 帧拉到 110 帧。
function s4n.Boss2(o)
    local ct = 0
    ct = s_wait(ct, 120)                        -- +120: //120（原作 nop 在 t=120）
    ct = 240                                    -- jmp(Boss2_932, 240)
    while true do                               -- _932：pushi(1); jmpNeq(Boss2_668, 120)
        ct = 120
        t10_call_async(o, s4_BossCharge)        -- callAsync("BossCharge")
        ct = s_wait(ct, 180)                    -- //180
        t10_call_async(o, s4n.Boss2_at2)
        t10_call_async(o, s4n.Boss2_at3)
        ct = ct - 50                            -- diffWait(80,80,50,50) ⇒ L：时钟提前 50
        ct = s_wait(ct, 180)                    -- moveRand 在 t=180 ⇒ 再等 50 帧
        m_rand(o, "off", 40, 0, 4.0)            -- moveRand(40, 0, 4.0)
        ct = s_wait(ct, 240)                    -- //240
    end
end

---Boss2_at：单槽（槽 0）圆环，**与 Boss1_at 同构**但 [16] = 12、[20] 先 validRad；
---  [0] 每发 +2π/[16]，[16] = 12 发/圈。
function s4n.Boss2_at(o, a0, a4, a8, aC)
    local n16 = 12                              -- [16] = 12
    et_new(o, 0); et_aim(o, 0, 1); et_sprite(o, 0, 2, aC); et_count(o, 0, 1, 1)
    et_angle(o, 0, a0, 0.0); et_speed(o, 0, a4, 1.0)
    o.pat[0].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    o.pat[0].ex[1] = tp_record(0, 8192, 60, -999999, -999999.0, -999999.0)
    local a20 = t10_wrap(a0)                    -- [20] = [0]；validRad([20])
    local a24 = 6.2831855 / n16                 -- [24] = 2π/[16]
    local old = n16; n16 = n16 - 1              -- jmp(_664, 0) → _664：deci([16])
    while old ~= 0 do
        local x, y = circle_pos(a20, a8)
        et_offset(o, 0, x, y)
        fire_slot(o, 0)
        a20 = t10_wrap(a20 + a24)
        old = n16; n16 = n16 - 1
    end
    et_offset(o, 0, 0.0, 0.0)
end

---Boss2_at2：32 轮、每轮 2 帧，两列（角 ±π）各一发 12 环。
---  L：速度 diffF([4], 1.5,1.5,2.5,3.5) = 3.5；!L 的 [0] += 0.15708（再 validRad）在 L 执行。
function s4n.Boss2_at2(o)
    local a8 = 16.0
    local a0 = t10_wrap(2.356194 + 0.15708)  -- !L：pushf([0]); pushf(0.15708f); addf; validRad([0])
    local a4 = 3.5                              -- diffF([4], 1.5,1.5,2.5,3.5) L
    local n12 = 32                              -- [12] = 32
    local ct = 0
    local old = n12; n12 = n12 - 1              -- jmp(_624, 0) → _624：deci([12])
    while old ~= 0 do
        ct = 0                                  -- jmpNeq(_332, 0)
        s4n.Boss2_at(o, a0, a4, a8, 6)
        s4n.Boss2_at(o, a0 - PI, a4, a8, 6)     -- [!NHL]：L 执行
        ct = ct - 2                             -- diffWait(5,5,3,2) ⇒ L 等 2 帧
        ct = s_wait(ct, 0)
        a0 = a0 - 0.314159
        old = n12; n12 = n12 - 1
    end
end

---Boss2_at3：32 轮、每轮 2 帧，两列（角 ±π）各一发，速度 L = 6.0；[0] 每轮 +0.314159。
---  起手与 at2 一样有 !L 的 [0] += 0.15708。
function s4n.Boss2_at3(o)
    local a8 = 16.0
    local a0 = t10_wrap(0.628319 + 0.15708)  -- !L：pushf([0]); pushf(0.15708f); addf; validRad([0])
    local a4 = 6.0                              -- diffF([4], 3.0,3.0,4.0,6.0) L
    local n12 = 32
    local ct = 0
    local old = n12; n12 = n12 - 1
    while old ~= 0 do
        ct = 0
        s4n.Boss2_at(o, a0, a4, a8, 2)          -- [!NHL]：L 执行
        s4n.Boss2_at(o, a0 - PI, a4, a8, 2)
        ct = ct - 2                             -- diffWait(5,5,3,2) ⇒ L 等 2 帧
        ct = s_wait(ct, 0)
        a0 = a0 + 0.314159
        old = n12; n12 = n12 - 1
    end
end

---非符 3656　射命丸文（stage04 BOSS 非符三）
---  原作 Boss3：!NHL lifeSet(7000) + !NHL setInterrupt(0, 0, 3600, "BossCard3")
---  （阈值 0 ⇒ 整条血打完）⇒ HP = 7000；setInvuln(120) ⇒ t1 = t2 = 2。
---  入场 320 帧（jmp(Boss3_940, 320)）后进入 200 帧一轮的循环（_940 拨回 120）：
---    t=120 callAsync("BossCharge")
---    t=180 callAsync("Boss3_at2") + callAsync("Boss3_at3")
---    t=260 moveRand(40, 0, 4.0)
---    t=320 回 t=120
function s4n.Boss3(o)
    local ct = 0
    ct = s_wait(ct, 120)                        -- +120: //120（原作 nop 在 t=120）
    ct = 320                                    -- jmp(Boss3_940, 320)
    while true do                               -- _940：pushi(1); jmpNeq(Boss3_708, 120)
        ct = 120
        t10_call_async(o, s4_BossCharge)        -- callAsync("BossCharge")
        ct = s_wait(ct, 180)                    -- //180
        t10_call_async(o, s4n.Boss3_at2)
        t10_call_async(o, s4n.Boss3_at3)
        ct = s_wait(ct, 260)                    -- //260
        m_rand(o, "off", 40, 0, 4.0)
        ct = s_wait(ct, 320)                    -- //320
    end
end

---Boss3_at2：32 轮、每轮 5 帧，两列（角 ±π）各一发 12 环；L：半径 20、速度 2.0。
---  [!NHL] 的第二发 L 也执行。
function s4n.Boss3_at2(o)
    local a8 = 20.0
    local a0 = 2.356194
    local a4 = 2.0                              -- diffF([4], 1.0,1.0,1.5,2.0) L
    local n12 = 32
    local ct = 0
    ct = 5                                      -- jmp(Boss3_at2_496, 5)
    local old = n12; n12 = n12 - 1              -- _496：deci([12])
    while old ~= 0 do
        ct = 0
        s4n.Boss2_at(o, a0, a4, a8, 6)          -- call("Boss2_at", …) ← stage04 的 Boss2_at
        s4n.Boss2_at(o, a0 - PI, a4, a8, 6)     -- [!NHL]：L 执行
        ct = s_wait(ct, 5)
        a0 = a0 - 0.314159
        old = n12; n12 = n12 - 1
    end
end

---Boss3_at3：32 轮、每轮 10 帧；$DIFF==3（L）时每轮打 5 发：
---  [0]、[0]−2π/5、[0]−2.513274、[0]−3.769911、[0]−5.026548，然后 [0] += 0.20944。
---  （!EN 那支才是 +0.314159 的 5 帧节奏，L 不走。）
function s4n.Boss3_at3(o)
    local a8 = 16.0
    local a0 = 0.628319
    local a4 = 5.0                              -- diffF([4], 3.0,3.0,4.0,5.0) L
    local n12 = 32
    local ct = 0
    ct = s_wait(ct, 10)                         -- jmp(_2000, 0)：_2000 的 deci 在 t=10 ⇒ 首轮先等 10 帧
    local old = n12; n12 = n12 - 1              -- jmp(_2000, 0) → _2000：deci([12])
    while old ~= 0 do
        ct = 0                                  -- jmpNeq(_236, 0)
        s4n.Boss2_at(o, a0, a4, a8, 2)
        -- $DIFF==3（L）：再补 4 发
        s4n.Boss2_at(o, a0 - 6.2831855 / 5, a4, a8, 2)
        s4n.Boss2_at(o, a0 - 2.513274, a4, a8, 2)
        s4n.Boss2_at(o, a0 - 3.769911, a4, a8, 2)
        s4n.Boss2_at(o, a0 - 5.026548, a4, a8, 2)
        ct = s_wait(ct, 10)                     -- !HL 的 [0] += 0.20944 在 t=10
        a0 = a0 + 0.20944
        old = n12; n12 = n12 - 1
    end
end

---=====================================
---符卡注册（一个角色一个组；boss.Define 必须先于 boss.card.add）
---  boss.card.add 会当场按 "<字母><关卡号>" 查 _editor_boss，Define 晚一行就报
---  「找不到 boss」（踩过）。组 2 / 3 都是河城荷取，但原作里是**两次出场**
---  （中 BOSS 打完跑掉、随后 BOSS 再登场），所以拆成两组。
---BGM：原作 stage03 = 「芥川龍之介の河童 ～ Candid Friend」、stage04 = 「妖怪の山
---  ～ Mysterious Mountain」，本仓库音乐表（mod/music.lua）里都没有 ⇒ 近似沿用
---  TH10_2 / TH10_4。
---出生点 { 0, 80 }：本仓库 BOSS 从这里出现，各卡的 ECL 自己带 movePosTime 入场。
---=====================================
boss.Define("2a", "河城荷取（中ボス）", "TH10_2", TH10_bg, { 0, 80 }, nil, "Nitori", LEVEL)
boss.Define("3a", "河城荷取",           "TH10_2", TH10_bg, { 0, 80 }, nil, "Nitori", LEVEL)
boss.Define("4a", "射命丸文",           "TH10_4", TH10_bg, { 0, 80 }, nil, "Aya",    LEVEL)
--- 组 5a = stage07（Extra）BOSS 洩矢諏訪子（開宴 / 土着神 / 神具 / 源符 / 蛙狩 / 祟符）。
--- 原作 stage07 = 「ネイティブフェイス」，本仓库音乐表里没有 ⇒ 沿用 TH10_2。
boss.Define("5a", "洩矢諏訪子",         "TH10_2", TH10_bg, { 0, 80 }, nil, "Suwako", LEVEL)

---=====================================
---八张符卡：{ 主 ECL 子程序, 卡名（符卡练习菜单）, 组, CARD_ID, t1秒, t2秒, t3秒, HP }
---  t3 / HP 全部取自 ECL 本身：
---    · t3 = spell*(…, 时间, …) 的帧数 / 60（与同一张卡的 setInterrupt 第三个参数一致）
---    · HP = 该卡开始时 BOSS 的 lifeSet：
---        stage03  中 BOSS = MBoss() 的 2200；BOSS = Boss() 8800 → Boss2() 8600 → Boss3() 8800
---        stage04  BOSS      = Boss() 9500 → Boss2() 9500 → Boss3() 7000 → 卡内 lifeSet 2300
---    · t1 / t2 = setInvuln(n) 的 n / 60（t1 = t2 ⇒ 高防一结束就满伤害，和原作一致）
---  例外：「無双風神」原作 setInvuln(1080) 正好覆盖整张卡的 1080 帧（并且带 spellTimeout()）
---    ⇒ 是**耐久符卡**，t1 = t2 = t3（boss_system.lua:161 据此判成耐久卡、伤害恒 0）。
---  CARD_ID：符卡 3601..3608、非符 3660..3665、中 BOSS 非符 3670（th35 的 3600 是 stage06 那张；跑 check_stage.lua --all 核对）。
---=====================================
local T10_CARDS = {
    { s3_MBossCard1, "光学「ハイドロカモフラージュ」",           "2a", 3601, 80 / 60, 80 / 60, 2700 / 60, 2200 },
    ---stage03 BOSS 河城荷取（L 行的相序）：非符一 → 漂溺 → 非符二 → 水符 → 非符三 → 河童。
    ---  非符的 HP = 该相 lifeSet − setInterrupt 阈值（Boss1 8800−2300、Boss2 8600−2100、
    ---  Boss3 8800−2300，一律 6500）；非符的 t1/t2 = setInvuln/60（Boss1 走 Boss() 的 60 ⇒ 1）。
    { s3n.Boss1,     "",                                        "3a", 3660, 1,       1,       3600 / 60, 6500, "stage03 非符一" },
    { s3_BossCard1,  "漂溺「光り輝く水底のトラウマ」",           "3a", 3602, 1,       1,       3600 / 60, 8800 },
    { s3n.Boss2,     "",                                        "3a", 3661, 1,       1,       3600 / 60, 6500, "stage03 非符二" },
    { s3_BossCard2,  "水符「河童の幻想大瀑布」",                 "3a", 3603, 1,       1,       3600 / 60, 8600 },
    { s3n.Boss3,     "",                                        "3a", 3662, 1,       1,       3600 / 60, 6500, "stage03 非符三" },
    { s3_BossCard3L, "河童「スピン・ザ・セファリックプレート」", "3a", 3604, 1,       1,       3600 / 60, 8800 },
    ---stage04 中 BOSS 射命丸文（原作 MBoss / MBossAt，纯非符）：lifeSet(10000) −
    ---  setInterrupt 阈值 0 = HP 10000；setInvuln(200) ⇒ t1 = t2 = 200/60、时限 1800 帧 = 30 s。
    ---  原作里中 BOSS 先于 BOSS 出场 ⇒ 这张排在 4a 组最前。
    { s4n.MBoss,     "",                                        "4a", 3670, 200 / 60, 200 / 60, 1800 / 60, 10000, "stage04 中BOSS 非符" },
    ---stage04 BOSS 射命丸文（L 行的相序）：非符一 → 岐符 → 非符二 → 風神 → 非符三 → 無双風神 → 塞符。
    ---  非符的 HP = Boss() 的 lifeSet 9500 − setInterrupt 阈值 2500 = 7000（Boss3 是
    ---  lifeSet 7000 − 阈值 0 = 7000）；Boss3 的 setInvuln(120) ⇒ t1 = t2 = 2。
    { s4n.Boss1,     "",                                        "4a", 3663, 1,       1,       3600 / 60, 7000, "stage04 非符一" },
    { s4_BossCard1,  "岐符「サルタクロス」",                     "4a", 3605, 1,       1,       3600 / 60, 9500 },
    { s4n.Boss2,     "",                                        "4a", 3664, 1,       1,       3600 / 60, 7000, "stage04 非符二" },
    { s4_BossCard2,  "風神「二百十日」",                         "4a", 3606, 5,       5,       3600 / 60, 9500 },
    { s4n.Boss3,     "",                                        "4a", 3665, 2,       2,       3600 / 60, 7000, "stage04 非符三" },
    { s4_BossCard3,  "「無双風神」",                             "4a", 3607, 18,      18,      1080 / 60, 2301 },
    { s4_BossCard4,  "塞符「天上天下の照國」",                   "4a", 3608, 8,       8,       4200 / 60, 2300 },
}

---主协程跑在 BOSS 的载体（th10_ecs_pod）上：每帧把 BOSS 钉在原作 ECL 的位置上。
---`main` 就是上面那张卡的**原生 Lua 主函数**（不再是 TH10_SUB 里的指令表）。
---★ 第 9 项 = 菜单名：非符的卡名必须是 ""（is_sc=false，不亮卡名），但符卡练习
---  菜单里还得有个名字 ⇒ 这两个字符串在非符上不是同一个。
---★ 主 BOSS 的载体在这里登记 t10_bossref：s_pod 会把它复制给每只子机，
---  子机里的 %BOSS_X / %BOSS_Y 才取得到 BOSS 本体的世界坐标。
for _, e in ipairs(T10_CARDS) do
    local main, name, band, id, t1, t2, t3, hp = e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8]
    local menu = e[9] or name
    local c = boss.card.New(name, t1, t2, t3, hp)
    c.init = function(self)
        local p = t10_boss_start(self, main)
        p.t10_bossref = p
    end
    ---卡片结束时把本卡生成的枪/使魔载体一起清掉（原作靠 killAllAsync/enmKillAll + 敌机回收）。
    c.del = function(self) t10_clear_pods() end
    boss.card.add({ { c, band } }, LEVEL, menu, id)
end

---=====================================
---stage07（Extra）十三张：{ 主 ECL 子程序, 卡名, 组, CARD_ID, t1, t2, t3, HP }
---  组 1a = 神奈子（中 BOSS 三张）、组 5a = 洩矢諏訪子（BOSS 十张）——
---    中 BOSS 三张挂回 1a 是刻意的：原作 stage07 的中 BOSS 也是神奈子，
---    用 5a 会让它们顶着諏訪子的立绘出场（原作的 BOSS 是諏訪子，中 BOSS 不是）。
---  t1/t2 = setInvuln(n)/60；t3 = spell*(…, 时间, …) 的帧数 / 60。
---    但 3619「宝永四年の赤蛙」/ 3620「諏訪大戦」/ 3621「祟符」原作都带 spellTimeout()
---    ⇒ 是**耐久符卡**：按本工程的约定写 t1 = t2 = t3（boss_system.lua:161 据 t1==t3
---    判 time_sc ⇒ dmg_factor 恒 0、只靠 t3 计时结束），和 3607「無双風神」同一处理。
---  HP = 该卡开始时 BOSS 的 lifeSet（中 BOSS 三张 2300；3619/3620/3621 是 10000）。
---  CARD_ID：符卡 3609..3621、非符 3651..3659（注册完跑 check_stage.lua --all 核对不撞号）。
---=====================================
local T10_CARDS_EX = {
    ---中 BOSS 神奈子（原作 MBoss → MBoss1 非符 → 三张神符）。
    ---  非符的 HP = MBoss() 的 lifeSet 9300 − setInterrupt 阈值 2300 = 7000；t1 = t2 = 1。
    { s7.MBoss1,     "",                                          "1a", 3651, 60 / 60,  60 / 60,  3600 / 60, 7000, "stage07 中BOSS 非符" },
    { s7.MBossCard1, "神符「水眼の如き美しき源泉」",              "1a", 3609, 200 / 60, 200 / 60, 4200 / 60, 2300 },
    { s7.MBossCard2, "神符「杉で結ぶ古き縁」",                    "1a", 3610, 320 / 60, 320 / 60, 4200 / 60, 2300 },
    { s7.MBossCard3, "神符「神が歩かれた御神渡り」",              "1a", 3611, 150 / 60, 150 / 60, 4200 / 60, 2300 },
    ---stage07 BOSS 洩矢諏訪子（L 之外无难度分级）：非符与符卡逐相交错。
    ---  非符 HP 一律 8000（= 该相 lifeSet − setInterrupt 阈值）；t3 = 3600 帧 = 60 s。
    { s7.Boss1,      "",                                          "5a", 3652, 200 / 60, 200 / 60, 3600 / 60, 8000, "stage07 非符一" },
    { s7.BossCard1,  "開宴「二拝二拍一拝」",                      "5a", 3612, 90 / 60,  90 / 60,  6300 / 60, 2800 },
    { s7.Boss2,      "",                                          "5a", 3653, 90 / 60,  90 / 60,  3600 / 60, 8000, "stage07 非符二" },
    { s7.BossCard2,  "土着神「手長足長さま」",                    "5a", 3613, 90 / 60,  90 / 60,  6300 / 60, 3600 },
    { s7.Boss3,      "",                                          "5a", 3654, 60 / 60,  60 / 60,  3600 / 60, 8000, "stage07 非符三" },
    { s7.BossCard3,  "神具「洩矢の鉄の輪」",                      "5a", 3614, 60 / 60,  60 / 60,  6300 / 60, 2800 },
    { s7.Boss4,      "",                                          "5a", 3655, 60 / 60,  60 / 60,  3600 / 60, 8000, "stage07 非符四" },
    { s7.BossCard4,  "源符「厭い川の翡翠」",                      "5a", 3615, 60 / 60,  60 / 60,  6300 / 60, 3600 },
    { s7.Boss5,      "",                                          "5a", 3656, 90 / 60,  90 / 60,  3600 / 60, 8000, "stage07 非符五" },
    { s7.BossCard5,  "蛙狩「蛙は口ゆえ蛇に呑まるる」",            "5a", 3616, 60 / 60,  60 / 60,  6300 / 60, 3500 },
    { s7.Boss6,      "",                                          "5a", 3657, 60 / 60,  60 / 60,  3600 / 60, 8000, "stage07 非符六" },
    { s7.BossCard6,  "土着神「七つの石と七つの木」",              "5a", 3617, 60 / 60,  60 / 60,  6300 / 60, 3500 },
    { s7.Boss7,      "",                                          "5a", 3658, 60 / 60,  60 / 60,  3600 / 60, 8000, "stage07 非符七" },
    { s7.BossCard7,  "土着神「ケロちゃん風雨に負けず」",          "5a", 3618, 60 / 60,  60 / 60,  6300 / 60, 4500 },
    { s7.Boss8,      "",                                          "5a", 3659, 90 / 60,  90 / 60,  3600 / 60, 8000, "stage07 非符八" },
    { s7.BossCard8,  "土着神「宝永四年の赤蛙」",                  "5a", 3619, 2400 / 60, 2400 / 60, 2400 / 60, 10000 },
    { s7.BossCard9,  "「諏訪大戦　～ 土着神話 vs 中央神話」",     "5a", 3620, 5040 / 60, 5040 / 60, 5040 / 60, 10000 },
    { s7.BossCard10, "祟符「ミシャグジさま」",                    "5a", 3621, 9600 / 60, 9600 / 60, 9600 / 60, 10000 },
}

for _, e in ipairs(T10_CARDS_EX) do
    local main, name, band, id, t1, t2, t3, hp = e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8]
    local menu = e[9] or name
    local c = boss.card.New(name, t1, t2, t3, hp)
    c.init = function(self)
        local p = t10_boss_start(self, main)
        p.t10_bossref = p
    end
    c.del = function(self) t10_clear_pods() end
    boss.card.add({ { c, band } }, LEVEL, menu, id)
end


--=====================================
--九、stage06（八坂神奈子）非符（原生 LuaSTG；只做 Lunatic 行）
--  逐条对照 thecl 原始反汇编（thecl -d 10 -r -m "MAP/th10.eclm" stage06.ecl out.txt）。
--  沿用本工程统一约定：
--    · 内部一律原作坐标（y 上→下），写进引擎才由 m_* / et_* 换算；
--    · 时钟 ct 逐指令显式推进——jmp/jmpNeq(L,T) 把 ct 直接设成 T（可回拨），
--      wait(n)/diffWait(…,L) 把 ct 减 n，遇到「下一条指令的时间 > ct」才真正等待
--      （见 s_wait 与文件中部「ECL 时钟语义」的注解）；
--    · 演出/流程指令（anm*/playSound/setChapter/setInvuln/stars/spellEnd/drop*/
--      etCancel/etClear/laserCancel/enmKillAll 之类）在本移植里按无效果处理，
--      但它们占的 wait 边界按 ECL 时间戳原样补齐（漏一条会让整张卡偏移）。
--  HP = 该相 lifeSet − setInterrupt 的收尾阈值；t3 = setInterrupt 时限/60；
--    t1 = t2 = setInvuln/60。原作 Boss() 先 lifeSet(11500) 再 call("Boss1")。
--  子机是独立敌机：callAsync 出来的枪与本卡主线程共用 $I/%F，故 BOSS 载体登记
--    t10_bossref 后由 s_pod/spawn_pod_rel 拷给子机。
--=====================================
local s6 = {}

---非符 3666　八坂神奈子（stage06 非符一，原作 Boss1）
---  Boss1 自己不写 lifeSet ⇒ HP = Boss() 的 11500 − 阈值 2500 = 9000；
---  setInvuln(120) ⇒ t1 = t2 = 2；setInterrupt 时限 4200 帧 ⇒ t3 = 70 s。
---  时间轴：t=20 记 %F0 = %ANGLE_PLAYER；t=80 callAsync("Boss1_at") 之后主线程只在
---  「拨回 80 → 等 60 帧」的空转循环里（at 是死循环，卡片靠 4200 帧超时结束）。
function s6.Boss1(o)
    local ct = 0
    ct = s_wait(ct, 20)                 -- +20: //20
    o.F0 = t10_angle_player(o)          -- %F0 = %ANGLE_PLAYER
    ct = s_wait(ct, 80)                 -- +60: //80
    t10_call_async(o, s6.Boss1_at)      -- callAsync("Boss1_at")
    ct = 140                            -- jmp(Boss1_356, 140)
    while true do                       -- _356：pushi(1); jmpNeq(_340, 80)
        ct = s_wait(ct, 140)            -- _340：+60: //140（空转）
        ct = 80                         -- jmpNeq(_340, 80)：时钟拨回 80
    end
end

---Boss1_at：两把枪（槽 0/1）交替，每把 48 发（etCountD L 行）、速 3.2→1.5。
---  角度 = %RANDRAD、角步 0.028049935；两枪各隔 10 帧（diffWait L = 10）。
---  ★ %RANDRAD 在 etAngle 执行时才求值 ⇒ 原生必须把 rndrad() 写在参数位，
---    随机数消耗顺序才与原作一致。
function s6.Boss1_at(o)
    et_new(o, 0); et_aim(o, 0, 3); et_sprite(o, 0, 3, 2)
    et_count(o, 0, 48, 1)               -- etCountD(0, 24,48,48,48, 1,1,1,1) 的 L 行
    et_angle(o, 0, 0.0, 0.3926991)
    et_speed(o, 0, 3.2, 1.5)            -- etSpeedD(0, 2.2,2.2,2.2,3.2, 1.5,1.5,1.5,1.5) 的 L 行
    et_ex(o, 0, 0, 1, 8, -999999, -999999, -999999.0, -999999.0)
    et_copy(o, 1, 0)
    et_sprite(o, 1, 3, 4)
    et_offset(o, 0, 32.0, -24.0)
    et_offset(o, 1, -32.0, -24.0)
    while true do                       -- _620：pushi(1); jmpNeq(_460, 0)
        et_angle(o, 0, rndrad(), 0.028049935)
        fire_slot(o, 0)                 -- etOn(0)
        task.Wait(10)                   -- diffWait(15, 15, 10, 10)
        et_angle(o, 1, rndrad(), 0.028049935)
        fire_slot(o, 1)                 -- etOn(1)
        task.Wait(10)
    end
end

---装饰卫星 BossCirR/G/B（原作 moveCircleRel(θ, 0.15707964, 320, −5.3333335)：
---  以出生点（= BOSS 位置）为圆心、半径 320 起、每帧 −5.3333335 收束到 0，60 帧后自毁）。
---  颜色：R→15、G→16、B→17（与 stage06 BossCard5 的圆环卫星同一套贴图约定）。
function s6.boss_cir(o, theta)
    m_circle(o, "base", theta, 0.15707964, 320.0, -5.3333335)
    task.Wait(2)                        -- +2: //2
    task.Wait(60)                       -- wait(60)
    t10_kill_pod(o)                     -- delete()
end
function s6.BossCirR(o) s6.boss_cir(o, -1.5707964) end   -- −π/2
function s6.BossCirG(o) s6.boss_cir(o, 0.5235988) end    --  π/6
function s6.BossCirB(o) s6.boss_cir(o, 2.6179938) end    --  5π/6

---非符 3667　八坂神奈子（stage06 非符二，原作 Boss2）
---  lifeSet(11500) − 阈值 2500 = 9000；setInvuln(180) ⇒ t1 = t2 = 3。
---  时间轴：t=0 movePosTime(60,0,0,192)；t=60 moveLimit(0,128,64,96)；
---  t=120 三颗装饰卫星 BossCirR/G/B；t=180 起 callAsync("Boss2_at") 与 callAsync("Boss2_at2")；
---  之后每 180 帧 moveRand(40,0,2.0)（_1260 的时钟回拨）。
function s6.Boss2(o)
    local ct = 0
    m_pos_time(o, "off", 60, 0, 0.0, 192.0)     -- movePosTime(60, 0, 0, 192)
    ct = s_wait(ct, 60)                         -- +60: //60
    m_limit(o, 0.0, 128.0, 64.0, 96.0)          -- moveLimit(0, 128, 64, 96)
    ct = s_wait(ct, 120)                        -- +60: //120
    spawn_pod_rel(o, 0.0, 0.0, s6.BossCirR)     -- enmCreate("BossCirR", 0, 0)
    spawn_pod_rel(o, 0.0, 0.0, s6.BossCirG)
    spawn_pod_rel(o, 0.0, 0.0, s6.BossCirB)
    ct = s_wait(ct, 180)                        -- +60: //180
    t10_call_async(o, s6.Boss2_at)              -- callAsync("Boss2_at")
    t10_call_async(o, s6.Boss2_at2)             -- callAsync("Boss2_at2")
    -- jmp(Boss2_1304, 360) 后紧跟 _1304 的 pushi(1)+jmpNeq(_1260, 180)：
    -- 同一帧内时钟被改回 180（净效果 clock=180），因此首次 moveRand 落在 360。
    ct = 180                                    -- jmp(Boss2_1304, 360); jmpNeq(_1260, 180)
    while true do                               -- _1260：+60://240 nop → +120://360
        ct = s_wait(ct, 360)                    -- moveRand 的绝对时刻 360（每轮 +180）
        m_rand(o, "off", 40, 0, 2.0)            -- moveRand(40, 0, 2.0)
        ct = 180                                -- jmpNeq(_1260, 180)
    end
end

---Boss2_at：四把枪（槽 0..3，出弹点 ±48/−32、±56/−24）。
---  两段循环，各 10 轮：
---    前半（槽 0/1）_992：每轮 etEx(…,kind=128,int0=60,int1=1,[4],6.5)（L 行）、etOn(0/1)、
---                        [4] += 0.017453，隔 4 帧（+4: //4）；
---    后半（槽 2/3）_1772：每轮 etEx(…)、etOn(2/3)、[4] −= 0.017453，隔 4 帧（+4: //8）。
---  每半结束后 wait(10)（此时 ct=4 / 8 ⇒ 分别再等 6 / 2 帧）再进下一段；
---  外层 jmpNeq(_892, 0) 无限循环。%DIFF≥2 时跳过 E/N 的 etEx 分支、L 行照打。
function s6.Boss2_at(o)
    et_new(o, 0); et_aim(o, 0, 1); et_sprite(o, 0, 5, 6)
    et_count(o, 0, 16, 1)               -- etCountD(0, 4,4,8,16, 1,1,1,1) 的 L 行
    et_angle(o, 0, -2.3561945, 0.19634955)
    et_speed(o, 0, 3.5, 1.4)
    et_ex(o, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 0, 1, 0, 8192, 160, -999999, -999999.0, -999999.0)
    et_ex(o, 0, 2, 0, 128, 60, 1, 0.0, 6.5)     -- !L 行
    et_copy(o, 1, 0); et_copy(o, 2, 0); et_copy(o, 3, 0)
    et_offset(o, 0, -48.0, -32.0)
    et_offset(o, 1, 48.0, -32.0)
    et_offset(o, 2, -56.0, -24.0)
    et_offset(o, 3, 56.0, -24.0)
    et_angle(o, 1, -0.7853982, 0.19634955)
    et_angle(o, 2, -2.7488935, 0.19634955)
    et_angle(o, 3, -0.3926991, 0.19634955)
    et_sprite(o, 2, 5, 2); et_sprite(o, 3, 5, 2)
    local ct = 0
    local n8, a4
    ct = 8                              -- jmp(Boss2_at_2452, 8)：仅把时钟设成 8（t=0 的指令照跑）
    while true do                       -- _2452：pushi(1); jmpNeq(_892, 0)
        ct = 0                          -- jmpNeq(_892, 0)：时钟拨回 0
        n8 = 10                         -- diffI([8], 6, 10, 10, 10) 的 L 行
        a4 = 0.0                        -- setf([4])
        ct = 4                          -- jmp(Boss2_at_1588, 4)
        -- ── 前半：槽 0/1（_1588 的 deci + _992/_1456 的主体）──
        local old = n8; n8 = n8 - 1
        while old ~= 0 do               -- _1588 deci；jmpNeq(_992, 0)
            ct = 0                      -- jmpNeq(_992, 0)
            et_ex(o, 0, 2, 0, 128, 60, 1, a4, 6.5)  -- !L
            et_ex(o, 1, 2, 0, 128, 60, 1, a4, 6.5)  -- !L
            fire_slot(o, 0); fire_slot(o, 1)        -- etOn(0); etOn(1)
            a4 = a4 + 0.017453                      -- [4] += 0.017453
            ct = s_wait(ct, 4)                      -- +4: //4
            old = n8; n8 = n8 - 1
        end
        ct = ct - 10                    -- wait(10)：clock -= 10
        ct = s_wait(ct, 4)              -- 恢复条件＝下一条指令时间 4 ⇒ 实际停 10 帧
        n8 = 10                         -- diffI([8], 6, 10, 10, 10) 的 L 行
        a4 = 0.0                        -- setf([4])
        ct = 8                          -- jmp(Boss2_at_2368, 8)
        -- ── 后半：槽 2/3（_2368 的 deci + _1772/_2236 的主体）──
        local old2 = n8; n8 = n8 - 1
        while old2 ~= 0 do              -- _2368 deci；jmpNeq(_1772, 4)
            ct = 4                      -- jmpNeq(_1772, 4)
            et_ex(o, 2, 2, 0, 128, 60, 1, a4, 6.5)  -- !L
            et_ex(o, 3, 2, 0, 128, 60, 1, a4, 6.5)  -- !L
            fire_slot(o, 2); fire_slot(o, 3)        -- etOn(2); etOn(3)
            a4 = a4 - 0.017453                      -- [4] −= 0.017453
            ct = s_wait(ct, 8)                      -- +4: //8
            old2 = n8; n8 = n8 - 1
        end
        ct = ct - 10                    -- wait(10)：clock -= 10
        ct = s_wait(ct, 8)              -- 恢复条件＝下一条指令(_2452)时间 8 ⇒ 实际停 10 帧
    end
end

---Boss2_at2：第五把枪（槽 4）每 15 帧一轮、每轮 3 波（角步 1.5707964 → 1.3744467 → 1.1780972）。
---  每波 2 发（etCount(4, 2, 1)）、速 5.5→1.4。死循环。
function s6.Boss2_at2(o)
    et_new(o, 4); et_aim(o, 4, 1); et_sprite(o, 4, 5, 10)
    et_count(o, 4, 2, 1)
    et_angle(o, 4, 1.5707964, 1.5707964)
    et_speed(o, 4, 5.5, 1.4)
    et_ex(o, 4, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local ct = 0
    ct = 15                             -- jmp(Boss2_at2_464, 15)
    while true do                       -- _464：pushi(1); jmpNeq(_304, 0)
        ct = 0
        et_angle(o, 4, 1.5707964, 1.5707964); fire_slot(o, 4)   -- etOn(4)
        et_angle(o, 4, 1.5707964, 1.3744467); fire_slot(o, 4)
        et_angle(o, 4, 1.5707964, 1.1780972); fire_slot(o, 4)
        ct = s_wait(ct, 15)             -- +15: //15
    end
end

---非符 3668　八坂神奈子（stage06 非符三，原作 Boss3／Boss3H）
---  $DIFF≤1 用 "BossCard3"、否则 "BossCard3H"（L 走 H 支），lifeSet(12900) − 阈值 2900 = 10000；
---  setInvuln(60) ⇒ t1 = t2 = 1；时限 4200 帧。
---  时间轴：t=30 movePosTime(60,4,0,128)；t=90 moveLimit(0,96,280,64) + callAsync("Boss3_at")；
---  之后每 180 帧 moveRand(40,0,1.0)（_1168 的时钟回拨）。
function s6.Boss3(o)
    local ct = 0
    ct = s_wait(ct, 30)                         -- +30: //30
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)     -- movePosTime(60, 4, 0, 128)
    ct = s_wait(ct, 90)                         -- +60: //90
    m_limit(o, 0.0, 96.0, 280.0, 64.0)          -- moveLimit(0, 96, 280, 64)
    t10_call_async(o, s6.Boss3_at)              -- callAsync("Boss3_at")
    ct = 270                                    -- jmp(Boss3_1212, 270)
    while true do                               -- _1212：pushi(1); jmpNeq(_1168, 90)
        ct = 90                                 -- jmpNeq(_1168, 90)：时钟拨回 90
        ct = s_wait(ct, 210)                    -- _1168：+120://210
        m_rand(o, "off", 40, 0, 1.0)            -- moveRand(40, 0, 1.0)
        ct = s_wait(ct, 270)                    -- +60://270 nop
    end
end

---Boss3_at：单枪（槽 0）每 13 帧一发（diffWait L = 13）、8 发一轮；每发 32 弹
---  （etCount(0, 4, 8)＝内层 4 发 × 8 圈）。基准角 [0] 每发 +0.19635（validRad 归一），
---  角步 −0.018925257、速 2.5→1.8（etSpeedD L 行）、L 行加速度记录 f0=1.8。
function s6.Boss3_at(o)
    et_offset(o, 0, 0.0, 0.0)
    local a0 = 0.0                      -- [0] = 0
    local ct = 0
    while true do                       -- _880：pushi(1); jmpNeq(_128, 0)
        ct = 0
        et_new(o, 0); et_aim(o, 0, 3); et_sprite(o, 0, 5, 6)
        et_count(o, 0, 4, 8)
        et_angle(o, 0, 1.5707964, 0.0)
        et_speed(o, 0, 2.5, 1.8)        -- etSpeedD(0, 1.8,1.8,2.2,2.5, 1.4,1.4,1.4,1.8) 的 L 行
        et_ex(o, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
        et_ex(o, 0, 1, 0, 2048, 1, -999999, 1.8, -999999.0)     -- !L 行
        et_ex(o, 0, 2, 0, 16384, 5, 2, -999999.0, -999999.0)
        local n4 = 8                    -- pushi(8); seti([4])
        ct = 0                          -- jmp(Boss3_at_836, 0)
        local old = n4; n4 = n4 - 1
        while old ~= 0 do               -- _836：deci([4]); jmpNeq(_660, 0)
            ct = 0
            et_angle(o, 0, a0, -0.018925257)
            fire_slot(o, 0)             -- etOn(0)
            a0 = t10_wrap(a0 + 0.19635) -- [0] += 0.19635；validRad([0])
            ct = ct - 13                -- diffWait(40, 20, 15, 13)
            ct = s_wait(ct, 0)
            old = n4; n4 = n4 - 1
        end
    end
end

---装饰卫星 BossCirR4/G4/B4：复用 stage06 BossCard5 那套 th35_sat 类（双圆叠加、每帧把圆心
---  钉在 BOSS 上），并登记进 T10_PODS——这样原作的 enmKillAll（清屏）会把上一段留下的
---  卫星收掉，不会随三段循环越积越多。参数见文件顶部的 SATS 表（R4/G4/B4 三条）。
function s6.sat(master, e)
    local s = New(class["th35_sat"], master, e[2], e[3], e[4], e[5], e[6], e[7])
    t10_track(s)
    return s
end

---非符 3669　八坂神奈子（stage06 非符四，原作 Boss4）
---  lifeSet(12200) − 阈值 3200 = 9000；setInvuln(90) ⇒ t1 = t2 = 1.5；时限 5400 帧 = 90 s。
---  时间轴：t=30 movePosTime(60,4,0,128)；t=90 moveLimit(0,112,128,64)；
---  t=210/570/870 各起一颗三连卫星 + wait(60) 后 callAsync(at / at2 / at3)；
---  三段之间各 180 帧（moveRand(120,0,1.0) 的时钟回拨）；_2932 之外层死循环。
---  ★ 原作每段开头 enmKillAll：把上一段的卫星/残留子机清掉（保留自己）。
function s6.Boss4(o)
    local ct = 0
    ct = s_wait(ct, 30)                         -- +30: //30
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)     -- movePosTime(60, 4, 0, 128)
    ct = s_wait(ct, 90)                         -- +60: //90
    m_limit(o, 0.0, 112.0, 128.0, 64.0)         -- moveLimit(0, 112, 128, 64)
    ct = 1050                                   -- jmp(Boss4_2932, 1050)
    while true do                               -- _2932：pushi(1); jmpNeq(_920, 90)
        ct = 90                                 -- jmpNeq(_920, 90)：时钟拨回 90
        ct = s_wait(ct, 150)                    -- +60: //150（空转）
        ct = s_wait(ct, 210)                    -- +60: //210
        t10_enm_kill_all(o)                     -- enmKillAll()
        s6.sat(o, SATS[4]); s6.sat(o, SATS[5]); s6.sat(o, SATS[6])   -- BossCirR4/G4/B4
        ct = ct - 60                            -- wait(60)
        ct = s_wait(ct, 210)                    -- callAsync("Boss4_at")（等满 60）
        t10_call_async(o, s6.Boss4_at)
        ct = s_wait(ct, 330)                    -- +120: //330
        m_rand(o, "off", 120, 0, 1.0)           -- moveRand(120, 0, 1.0)
        ct = s_wait(ct, 450)                    -- +120: //450
        t10_enm_kill_all(o)                     -- enmKillAll()
        ct = s_wait(ct, 510)                    -- +60: //510（空转）
        ct = s_wait(ct, 570)                    -- +60: //570
        s6.sat(o, SATS[4]); s6.sat(o, SATS[5]); s6.sat(o, SATS[6])
        ct = ct - 60                            -- wait(60)
        ct = s_wait(ct, 570)                    -- callAsync("Boss4_at2")（等满 60）
        t10_call_async(o, s6.Boss4_at2)
        ct = s_wait(ct, 630)                    -- +60: //630
        m_rand(o, "off", 120, 0, 1.0)           -- moveRand(120, 0, 1.0)
        ct = s_wait(ct, 750)                    -- +120: //750
        t10_enm_kill_all(o)                     -- enmKillAll()
        ct = s_wait(ct, 810)                    -- +60: //810（空转）
        ct = s_wait(ct, 870)                    -- +60: //870
        s6.sat(o, SATS[4]); s6.sat(o, SATS[5]); s6.sat(o, SATS[6])
        ct = ct - 60                            -- wait(60)
        ct = s_wait(ct, 870)                    -- callAsync("Boss4_at3")（等满 60）
        t10_call_async(o, s6.Boss4_at3)
        ct = s_wait(ct, 930)                    -- +60: //930
        m_rand(o, "off", 120, 0, 1.0)           -- moveRand(120, 0, 1.0)
        ct = s_wait(ct, 1050)                   -- +120: //1050
    end
end

---Boss4_at：两把旋转枪（槽 0/1）。t=0 etOn(0)；隔 60 帧 etCopy(1,0) 后把两把枪的角步改成
---  !HL 行的 −0.2617994 / 0.19634955，接「50/40/30/20/10/5 帧交替 etOn(0)/etOn(1)」。
---  槽 0：etCountD(0, …) L 行 c1=3,c2=12、etSprite(0,17,1)、速 7.8→1.4。
function s6.Boss4_at(o)
    et_offset(o, 0, 0.0, 0.0)
    et_new(o, 0); et_aim(o, 0, 2); et_sprite(o, 0, 17, 1)
    et_count(o, 0, 3, 12)               -- etCountD(0, 1,1,3,3, 6,10,12,12) 的 L 行
    et_angle(o, 0, 1.5707964, -0.31415927)
    et_speed(o, 0, 7.8, 1.4)            -- etSpeedD(0, 6.8,6.8,6.8,7.8, 1.4,…) 的 L 行
    et_ex(o, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    fire_slot(o, 0)                     -- etOn(0)
    task.Wait(60)                       -- wait(60)
    et_copy(o, 1, 0)                    -- etCopy(1, 0)
    et_angle(o, 1, -1.5707964, 0.31415927)
    et_angle(o, 0, 1.5707964, -0.2617994)   -- !HL 行
    et_angle(o, 1, -1.5707964, 0.19634955)  -- !HL 行
    fire_slot(o, 1)                     -- etOn(1)
    task.Wait(50); fire_slot(o, 0)      -- wait(50); etOn(0)
    task.Wait(40); fire_slot(o, 1)      -- wait(40); etOn(1)
    task.Wait(30); fire_slot(o, 0)      -- wait(30); etOn(0)
    task.Wait(20); fire_slot(o, 1)      -- wait(20); etOn(1)
    task.Wait(10); fire_slot(o, 0)      -- wait(10); etOn(0)
    task.Wait(5);  fire_slot(o, 1)      -- wait(5);  etOn(1)
end

---Boss4_at2：四把枪（槽 0..3）各 10 发环、每 10 帧一发（etOn 0→1→2→3），共 4 轮（每轮 40 帧）。
---  槽 0/1：etSprite(·,14,1)、角步 ∓0.31415927、速 8.0→1.4、L 行加速度记录 f1=6.0；
---  槽 2/3：etSprite(·,14,2)、etCountD(·, …, 8,16,16,24) 的 L 行 c2=24、速 4/…/8→1.4，
---          角步 [4] = ∓0.19634955（diffF 的 L 行）。
---  ★ 原作在槽 2/3 的 etEx 写的是槽 0/1（int0=1、kind=4）；这里照抄，不「修正」。
function s6.Boss4_at2(o)
    et_new(o, 0); et_aim(o, 0, 2); et_sprite(o, 0, 14, 1)
    et_count(o, 0, 1, 10)               -- etCountD(0, 1,1,1,1, 10,10,10,10)（各难度同）
    et_angle(o, 0, 1.5707964, -0.31415927)
    et_speed(o, 0, 8.0, 1.4)
    et_ex(o, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 0, 1, 0, 128, 60, 1, 0.0, 6.0)     -- !L 行
    et_new(o, 1); et_aim(o, 1, 2); et_sprite(o, 1, 14, 1)
    et_count(o, 1, 1, 10)
    et_angle(o, 1, -1.5707964, 0.31415927)
    et_speed(o, 1, 8.0, 1.4)
    et_ex(o, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 1, 1, 0, 128, 60, 1, 0.0, 6.0)     -- !L 行
    et_new(o, 2); et_aim(o, 2, 2); et_sprite(o, 2, 14, 2)
    et_count(o, 2, 1, 24)               -- etCountD(2, 1,1,1,1, 8,16,16,24) 的 L 行
    et_angle(o, 2, 1.5707964, -0.19634955)      -- diffF([4], …) 的 L 行
    et_speed(o, 2, 8.0, 1.4)            -- etSpeedD(2, 4,4,6,8, 1.4,…) 的 L 行
    et_ex(o, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)    -- 原作写槽 0
    et_new(o, 3); et_aim(o, 3, 2); et_sprite(o, 3, 14, 2)
    et_count(o, 3, 1, 24)
    et_angle(o, 3, -1.5707964, 0.19634955)      -- diffF([4], …) 的 L 行
    et_speed(o, 3, 8.0, 1.4)
    et_ex(o, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)    -- 原作写槽 1
    local ct = 0
    local n0 = 4                        -- pushi(4); seti([0])
    ct = 40                             -- jmp(Boss4_at2_1644, 40)
    local old = n0; n0 = n0 - 1
    while old ~= 0 do                   -- _1644：deci([0]); jmpNeq(_1564, 0)
        ct = 0                          -- jmpNeq(_1564, 0)
        ct = s_wait(ct, 10); fire_slot(o, 0)    -- +10: //10
        ct = s_wait(ct, 20); fire_slot(o, 1)    -- +10: //20
        ct = s_wait(ct, 30); fire_slot(o, 2)    -- +10: //30
        ct = s_wait(ct, 40); fire_slot(o, 3)    -- +10: //40
        old = n0; n0 = n0 - 1
    end
end

---Boss4_at3：单枪（槽 0）自 160 帧、每帧一发环（etCountD L 行 c2=10）、速 7.6→0.6。
---  基准角 [0] 从 π/2 起每帧 +3.883222（validRad 归一）、角步 0；L 行加速度记录 f1=6.0。
function s6.Boss4_at3(o)
    et_new(o, 0); et_aim(o, 0, 3); et_sprite(o, 0, 12, 5)
    et_count(o, 0, 1, 10)               -- etCountD(0, 1,1,1,1, 1,4,6,10) 的 L 行
    et_angle(o, 0, 1.5707964, 0.0)
    et_speed(o, 0, 7.6, 0.6)            -- etSpeedD(0, 4.6,4.6,6.6,7.6, 0.6,…) 的 L 行
    et_ex(o, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 0, 1, 0, 64, 60, 1, 0.0, 6.0)      -- !L 行（覆盖同一条 0.01 记录）
    local a0 = 1.570796                 -- [0] = 1.570796
    local n4 = 160                      -- pushi(160); seti([4])
    local ct = 0
    ct = 1                              -- jmp(Boss4_at3_792, 1)：仅设时钟（首轮不等）
    local old = n4; n4 = n4 - 1
    while old ~= 0 do                   -- _792：deci([4]); jmpNeq(_632, 0)
        ct = 0
        et_angle(o, 0, a0, 0.0)
        fire_slot(o, 0)                 -- etOn(0)
        a0 = t10_wrap(a0 + 3.883222)    -- [0] += 3.883222；validRad([0])
        ct = s_wait(ct, 1)              -- +1: //1
        old = n4; n4 = n4 - 1
    end
end

---stage06 四张非符：{ 主 ECL 子程序, 卡名（非符为 ""）, 组, CARD_ID, t1秒, t2秒, t3秒, HP, 菜单名 }
---  组 1a = 八坂神奈子（与 stage06 BossCard5、stage05 神奈子共用）。
---  CARD_ID 3666..3669（跑 `luajit tools/check_stage.lua --all` 核对：3600 是本关手写卡、
---    3601..3621 是 03/04/07、3630..3665 是 01/02/05 + 03/04/07 非符）。
s6.cards = {
    { s6.Boss1, "", "1a", 3666, 2,   2,   4200 / 60, 9000,  "stage06 非符一" },
    { s6.Boss2, "", "1a", 3667, 3,   3,   4200 / 60, 9000,  "stage06 非符二" },
    { s6.Boss3, "", "1a", 3668, 1,   1,   4200 / 60, 10000, "stage06 非符三" },
    { s6.Boss4, "", "1a", 3669, 1.5, 1.5, 5400 / 60, 9000,  "stage06 非符四" },
}

for _, e in ipairs(s6.cards) do
    local main, name, band, id, t1, t2, t3, hp = e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8]
    local menu = e[9] or name
    local c = boss.card.New(name, t1, t2, t3, hp)
    c.init = function(self)
        local p = t10_boss_start(self, main)
        p.t10_bossref = p
    end
    c.del = function(self) t10_clear_pods() end
    boss.card.add({ { c, band } }, LEVEL, menu, id)
end
--=====================================
-- 八、stage01 / stage02 / stage05 符卡（原生 LuaSTG；只做 Lunatic 难度行）
--   逐张对齐原作 ECL（thecl -d 10 -m th10.eclm -r -x 反汇编）。
--   演出/流程指令（spell*/anm*/playSound/setChapter/flagSet/drop*/bombShield/
--   etClear/etCancel/laser*/dialogWait/…）在本移植里按无效果处理或由符卡框架接管，
--   但它们占的 wait 边界按 ECL 时间戳原样补齐（漏一条会让整张卡偏移一帧）。
--   「下一张卡」不移植：setInterrupt/setTimeout 指向的后续子程序交给本仓库符卡框架。
--   ★ 三个命名空间用 table 字段而不是 40 个 local function：主 chunk 的局部早已逼近
--     LuaJIT 的 200 上限（`do … end` 不顶用，只有表字段不占 local）。
--=====================================

--=====================================
local s1 = {}
local s2 = {}
local s5 = {}

--=====================================
--八·A、stage01（秋静葉 中 BOSS 一张 + 秋穣子 BOSS 两张）
--=====================================

---卡 3630　葉符「狂いの落葉」（中 BOSS 秋静葉）
---  原作 MBossCard1 / MBossCard1_at。
---  主线程 t=150 起只叫一次 at，之后进入「每 120 帧 moveRand(60,4,2.0)」的死循环
---  （原作靠 2160 帧 setInterrupt→MBossDead 结束整张卡）。
---    at（槽 0）：每 3 帧一轮，t=1/2/3 各出一枪；t=3 那一轮出两枪（色 2 / 色 1）。
---      每枪先取 %RANDRAD/6 做「正负分流」，再按分支写 ex[3] 的 f1（0 或 π）——
---      t=1 分支 a>0 时 [0] -= π，t=2 分支 a>0 时 [0] = ([0] − 5π)/6，
---      t=3 分支两枪都是 [0] = %RANDRAD/6 − π/2。随机消耗顺序必须照抄。
function s1.MBossCard1_at(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 1, 1, 1
    p.type, p.color = 3, 2
    p.angle, p.astep = 0.0, 0.0
    p.s1, p.s2 = 1.0, 2.0
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 8192, 180, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 16, 120, -999999, 0.018, 1.5707964)
    while true do
        task.Wait(1)                       -- //1 → //2 → //3 → 回 //1
        local a = rndrad() / 6
        if a > 0 then
            a = a - 3.1415927
            p.ex[3] = tp_record(0, 16, 120, -999999, 0.01, 0.0)
        else
            p.ex[3] = tp_record(0, 16, 120, -999999, 0.01, 3.1415927)
        end
        et_sprite(o, 0, 3, 12)
        et_angle(o, 0, a, 0.0)
        et_speed(o, 0, rnd() * 1.5 + 0.4, 0.0)
        fire_slot(o, 0)
        task.Wait(1)                       -- //2
        local b = rndrad() / 6
        if b > 0 then
            b = (b - 3.1415927 * 5) / 6
            p.ex[3] = tp_record(0, 16, 120, -999999, 0.01, 0.0)
        else
            b = b - 3.1415927 / 6
            p.ex[3] = tp_record(0, 16, 120, -999999, 0.01, 3.1415927)
        end
        et_angle(o, 0, b, 0.0)
        et_sprite(o, 0, 3, 13)
        et_speed(o, 0, rnd() * 1.5 + 0.4, 0.0)
        fire_slot(o, 0)
        task.Wait(1)                       -- //3
        local c = rndrad() / 6 - 3.1415927 / 2
        et_angle(o, 0, c, 0.0)
        p.ex[3] = tp_record(0, -2147483648, -999999, -999999, -999999.0, -999999.0)
        et_speed(o, 0, rnd() * 1.5 + 0.4, 0.0)
        et_sprite(o, 0, 3, 2)
        fire_slot(o, 0)
        local d = rndrad() / 6 - 3.1415927 / 2
        et_angle(o, 0, d, 0.0)
        p.ex[3] = tp_record(0, -2147483648, -999999, -999999, -999999.0, -999999.0)
        et_speed(o, 0, rnd() * 1.5 + 0.4, 0.0)
        et_sprite(o, 0, 3, 1)
        fire_slot(o, 0)
    end
end

function s1.MBossCard1(o)
    t10_kill_async(o)
    m_limit(o, 0.0, 80.0, 280.0, 64.0)     -- moveLimit(0, 80, 280, 64)
    m_pos_time(o, "off", 60, 4, 0.0, 112.0)
    task.Wait(60)                          -- //60：anmPlay(0, 409)（纯视觉，但占一个时间边界）
    task.Wait(90)                          -- //150
    t10_call_async(o, s1.MBossCard1_at)
    task.Wait(120)                         -- //150 → //270
    while true do                          -- 每 120 帧一轮
        m_rand(o, "off", 60, 4, 2.0)
        task.Wait(120)
    end
end

---卡 3631　秋符「秋の空と乙女の心」（BOSS 秋穣子 - 1；L/H 行名）
---  原作 BossCard1 / BossCard1_at。E/N 的名字是「秋符「オータムスカイ」」（spell(2)），
---  Lunatic 走 spell3(4) 这条（!HL）——这里只做 L 行。
---  主循环 360 帧一轮，分上下两个「四边形枪阵」：
---    4448 = 槽 0..3，5788 = 槽 4..7；每半段 180 帧（三个 60 帧的 moveRand+at 段）。
---    每半段开头 %RANDRAD 定基准角、etOn 打一波，然后内层 2 次循环
---      （deci $I4=2 ⇒ 共 3 波：f1 = 1.2 → 1.4 → 1.6，[0]/[8]/[12]/[16] 是四支的基准角），
---      循环结束再补一波 f1 = 1.2 的定角弹。
---    ★ 第二半段内层的 etEx 写的是 **槽 4..7**、而 etOn 打的是 **槽 0..3**
---      —— ECL 原文如此（thecl 反汇编逐条核对过），照抄，不改「逻辑上更顺」的写法。
---    at（槽 4）：10 发一组（aim 2 = 自机狙 + 扇形），每 10 帧一波共 3 波后返回
---      （$I0 由 diffI 定：L 行 = 3）。
function s1.BossCard1_at(o)
    local n = 3                            -- diffI([0], 1,1,1,3) → L = 3
    et_new(o, 4)
    local p = o.pat[4]
    p.aim, p.c1, p.c2 = 2, 10, 1
    p.type, p.color = 12, 6
    p.angle, p.astep = 0.0, 0.0
    p.s1, p.s2 = 3.0, 2.0
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    while n > 0 do
        n = n - 1
        fire_slot(o, 4)
        task.Wait(10)
    end
end

function s1.BossCard1(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    -- ★ 入场必须按 ECL 的**每个时间戳边界**各写一个 task.Wait：探针的 task.Wait(n)
    --   实际吃掉 n+1 帧，把 //60 / //120 / //150 三个边界并成一条 Wait(150) 会少 2 帧
    --   （真机引擎里只有总帧数有意义，但探针对拍必须逐边界对齐）。
    task.Wait(60)                          -- //60：anmPlay(0, 409)
    task.Wait(60)                          -- //120：anmSelectedPlay(0)
    task.Wait(30)                          -- //150：nop
    -- t=150 入场：8 个槽位整套建好。每槽 c1 = $I24 = 38（L 行）、初速 2.0/2.0、
    -- 基准角 = 本卡开头的 %RANDRAD（存在 [0]）。7 条 ex 记录逐槽照抄反汇编：
    --   ex1/ex3 = 一对 ±π/2 的 60 帧延迟分裂（f1 = -999 不改速）
    --   ex2/ex4 = kind 2 / 6 的 3 帧 × N 次延迟分裂（两种 kind 按槽交替）
    --   ex5     = 60 帧延迟后按 [0]/[8]/[12]/[16] 定角的「生长环」
    --   ex6     = 与 ex2 同 kind
    local base = rndrad()
    local n = 38                           -- diffI([24], 28,38,38,38)
    local SET = {
        {  1.5707964, 2, -1.5707964, 6,  1.5707964 },
        { -1.5707964, 6,  1.5707964, 2, -1.0471976 },
        {  1.5707964, 2, -1.5707964, 6,  0.8975979 },
        { -1.5707964, 6,  1.5707964, 2, -1.2566371 },
        { -1.5707964, 2,  1.5707964, 6, -1.5707964 },
        {  1.5707964, 6, -1.5707964, 2,  1.0471976 },
        { -1.5707964, 2,  1.5707964, 6, -0.8975979 },
        {  1.5707964, 6, -1.5707964, 2,  1.2566371 },
    }
    for i = 0, 7 do
        et_new(o, i)
        local p = o.pat[i]
        local d = SET[i + 1]
        p.aim, p.c1, p.c2 = 3, n, 1
        p.type, p.color = 3, 6
        p.angle, p.astep = base, 0.0
        p.s1, p.s2 = 2.0, 2.0
        p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
        p.ex[1] = tp_record(0, 64, 60, 1, d[1], -999.0)
        p.ex[2] = tp_record(0, 16384, 3, d[2], -999999.0, -999999.0)
        p.ex[3] = tp_record(0, 64, 60, 1, d[3], -999.0)
        p.ex[4] = tp_record(0, 16384, 3, d[4], -999999.0, -999999.0)
        p.ex[5] = tp_record(0, 64, 60, 1, d[5], 1.2)
        p.ex[6] = tp_record(0, 16384, 3, d[2], -999999.0, -999999.0)
    end
    -- 两半段内层循环用的四支基准角（ECL 里的 [0]/[8]/[12]/[16]）
    local quad1 = { 1.570796, -1.047198, 0.897598, -1.256637 }
    -- 第二半段收尾（etEx 4..7）用的四支基准角
    local quad2 = { -1.5707964, 1.0471976, -0.8975979, 1.2566371 }
    while true do                          -- //150 → … → //510，共 360 帧一轮
        -- 4448：槽 0..3
        base = rndrad()
        for i = 0, 3 do
            et_angle(o, i, base, 0.0)
            fire_slot(o, i)
        end
        local v = 1.2
        for _ = 1, 2 do
            v = v + 0.2
            for i = 0, 3 do et_ex(o, i, 5, 0, 64, 60, 1, quad1[i + 1], v) end
            for i = 0, 3 do fire_slot(o, i) end
        end
        for i = 0, 3 do et_ex(o, i, 5, 0, 64, 60, 1, quad1[i + 1], 1.2) end
        task.Wait(60)                      -- //150 → //210
        m_rand(o, "off", 60, 4, 2.0)
        t10_call_async(o, s1.BossCard1_at)
        task.Wait(60)                      -- //210 → //270
        m_rand(o, "off", 60, 4, 2.0)
        t10_call_async(o, s1.BossCard1_at)
        task.Wait(60)                      -- //270 → //330
        t10_call_async(o, s1.BossCard1_at)
        -- 5788：槽 4..7（内层 etEx 写 4..7、etOn 打 0..3 —— 见函数头注释）
        base = rndrad()
        for i = 4, 7 do
            et_angle(o, i, base, 0.0)
            fire_slot(o, i)
        end
        v = 1.2
        for _ = 1, 2 do
            v = v + 0.2
            for i = 4, 7 do et_ex(o, i, 5, 0, 64, 60, 1, quad1[i - 3], v) end
            for i = 0, 3 do fire_slot(o, i) end
        end
        for i = 4, 7 do et_ex(o, i, 5, 0, 64, 60, 1, quad2[i - 3], 1.2) end
        task.Wait(60)                      -- //330 → //390
        m_rand(o, "off", 60, 4, 2.0)
        t10_call_async(o, s1.BossCard1_at)
        task.Wait(60)                      -- //390 → //450
        m_rand(o, "off", 60, 4, 2.0)
        t10_call_async(o, s1.BossCard1_at)
        task.Wait(60)                      -- //450 → //510
        t10_call_async(o, s1.BossCard1_at)
        -- //510 之后 pushi/jmpNeq 把 clock 直接拨回 //150，**没有**等待：
        -- 下一轮的 //150 组（槽 0..3 的第一波）与 t=510 同帧执行。
    end
end

---卡 3632　豊作「穀物神の約束」（BOSS 秋穣子 - 2）
---  原作 BossCard2 / BossCard2At1 / BossCard2At1b / BossCard2At2。E/N 名是
---  「豊符「オヲトシハーベスター」」；L 走 spell3(8)。
---  主循环 180 帧一轮：At1（64 根圆排激光，一帧内跑完）、At2（1 帧 1 轮的螺旋枪）、
---  At1b（48 根直排激光）各叫一次，t=150/210/250 处按 ECL 的 ±40 帧边界推进。
---    At1 ：[4] = %RANDRAD（角度），$I0 = 64，$F16 = 2π/64；
---          每轮取 %RANDF2·64 当半径、%RANDRAD 当角度做 circlePos 定激光位置，
---          再 [4] += 2π/64 —— **一帧内跑完 64 轮**（循环里没有 wait）。
---    At2 ：螺旋枪。$F12 = 1（半径，每轮 +1）、$I0 = 110；两张弹都自机狙（aim 3/4），
---          每轮先 [16] -= 0.15708、[20] += 0.15708 各定一条的极坐标位置。
---    At1b：[4] = %RANDRAD，$I0 = 48，$F16 = 2π/48；48 根激光都用同一个 [4]（视觉）。
function s1.BossCard2At1(o)
    local ang = rndrad()
    local cnt = 64                         -- diffI([0], 8,32,32,64)
    local step = 6.2831855 / cnt           -- [16]
    for _ = 1, cnt do
        local r = rnd2() * 64              -- 先 %RANDF2（半径）
        local a = rndrad()                 -- 再 %RANDRAD（角度）
        local x, y = circle_pos(a, r)
        et_offset(o, 0, x, y)
        t10_laser_on(o, 3, 13, ang, 2.0, 0.0, 512.0, 60.0, 16.0)   -- laserStOn（视觉近似）
        ang = t10_wrap(ang + step)
    end
end

function s1.BossCard2At1b(o)
    local ang = rndrad()
    local cnt = 48                         -- diffI([0], 16,32,32,48)
    local step = 6.2831855 / cnt
    for _ = 1, cnt do
        et_offset(o, 0, 0.0, 0.0)
        t10_laser_on(o, 3, 2, ang, 2.5, 0.0, 180.0, 0.0, 14.0)     -- laserOnA（视觉近似）
        ang = t10_wrap(ang + step)
    end
end

function s1.BossCard2At2(o)
    et_new(o, 0)
    local p0 = o.pat[0]
    p0.aim, p0.c1, p0.c2 = 3, 1, 1
    p0.type, p0.color = 3, 2
    p0.angle, p0.astep = 0.0, 1.0471976
    p0.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p0.ex[1] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    p0.ex[2] = tp_record(0, 8192, 100, -999999, -999999.0, -999999.0)
    et_copy(o, 1, 0)
    et_sprite(o, 1, 3, 1)
    et_aim(o, 1, 4)
    local r = 1.0                          -- [12]
    local a = rndrad()                     -- [16]
    local b = a                            -- [20]
    local n = 110                          -- diffI([0], 60,110,110,110)
    for _ = 1, n do
        r = r + 1.0
        a = t10_wrap(a - 0.15708)
        local x, y = circle_pos(a, r)
        et_speed(o, 0, rnd() * 0.7 + 1.0, 1.0)
        et_angle(o, 0, rndrad(), 1.0471976)
        et_offset(o, 0, x, y)
        task.Wait(1)                       -- +1: //1：etOn(0) 与 body 的 t=0 段之间差一帧
        fire_slot(o, 0)                    -- etOn(0)
        b = t10_wrap(b + 0.15708)          -- etOn(1) 与 etOn(0) **同帧**（都是 t=1）
        local x2, y2 = circle_pos(b, r)
        et_speed(o, 1, rnd() * 0.7 + 1.0, 1.0)
        et_angle(o, 1, rndrad(), 1.0471976)
        et_offset(o, 1, x2, y2)
        fire_slot(o, 1)
    end
end

function s1.BossCard2(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    task.Wait(60)                          -- //60：anmPlay(0, 409)
    task.Wait(60)                          -- //120：anmSelectedPlay(0)
    task.Wait(30)                          -- //150：nop
    while true do                          -- 180 帧一轮（帧消耗 60+40+40+40）
        t10_call_async(o, s1.BossCard2At1)
        task.Wait(60)                      -- //150 → //210
        t10_call_async(o, s1.BossCard2At2)
        task.Wait(40)                      -- wait(40)：只把 clock 拨回 //170（不占帧）；
                                           --   下一条指令仍标在 //210，所以这里要等满 40 帧
        t10_call_async(o, s1.BossCard2At1b)
        task.Wait(40)                      -- 第二个 wait(40)（same：先回拨、再等回 //210）
        m_rand(o, "off", 40, 4, 3.0)       -- moveRand 的指令时间仍是 //210，本帧执行
        task.Wait(40)                      -- //210 → //250（jmpNeq 的时间戳）
        -- //250 之后 jmp/jmpNeq 把 clock 拨回 //150，**没有**等待
    end
end

--=====================================
--八·A-2、stage01 非符（秋静葉 中 BOSS 一张 + 秋穣子 BOSS 两张；只做 Lunatic 难度行）
--  ECL 源：r01raw.txt 的 MBoss / Boss1 / Boss2 及其子线程。
--  ★ 原作非符 = 「有血量、有时限、不亮卡名」的阶段 ⇒ 注册时 name 必须是 ""
--    （boss.card.New("", …) 会让 is_sc=false），菜单名另用第 9 项给。
--  ★ call(name) 是**同步**子调用（EclVm.cpp ECL_VM_CALL/ECL_VM_RETURN）：调用者的
--    clock 在 CALL 时入栈、RETURN 才恢复；被调子程序占掉的真实帧数会叠加在调用者身上。
--    这里直接写同名的 Lua 函数调用，调用者的 ct 在调用期间不动。
--  ★ 血量按原作「进场 life − 收尾阈值」算（Enemy.cpp Fn004127A0：life 掉到阈值就
--    夹回阈值再切下一相，所以一相实打实的伤害 = 进场 life − 阈值）。
--=====================================

---非符 3642　静葉（中 BOSS 非符）
---  MBoss：入场 movePosTime(60,4,64,96)；之后 480 帧一轮（时钟看起来是 260 帧，
---  但两次同步 call 各占 80 / 60 帧，真实周期是 60+80+80+60+60+80+60 = 480）：
---    t=60  同步 MBoss_at1（80 帧，出弹在真实 60/100/140）
---    t=140 同步 MBoss_at2（60 帧，出弹在真实 +20/+40/+60）
---    t=200 同步 MBoss_at1 + 异线程 MBoss_at2
---    t=260 movePosTime(60,4,64,96)
---  血量：lifeSet(5850) → 阈值 1650 ⇒ 4200；时限 = 1560 帧 = 26 秒。
function s1.MBoss(o)
    local ct = 0
    m_pos_time(o, "off", 60, 4, 64.0, 96.0)   -- movePosTime(60, 4, 64, 96)
    ct = 260                                   -- jmp(MBoss_764, 260)
    ct = 0                                     -- jmpNeq(MBoss_476, 0)
    while true do
        ct = s_wait(ct, 60)                    -- //60
        s1.MBoss_at1(o)                        -- call("MBoss_at1")（同步）
        m_pos_time(o, "off", 60, 4, 0.0, 128.0)
        ct = s_wait(ct, 140)                   -- //140
        s1.MBoss_at2(o)                        -- call("MBoss_at2")（同步）
        m_pos_time(o, "off", 60, 4, -64.0, 96.0)
        ct = s_wait(ct, 200)                   -- //200
        s1.MBoss_at1(o)
        s_async(o, s1.MBoss_at2)               -- callAsync("MBoss_at2")
        m_pos_time(o, "off", 60, 4, 64.0, 96.0)
        ct = s_wait(ct, 260)                   -- //260
        m_pos_time(o, "off", 60, 4, 64.0, 96.0)
        ct = 0                                 -- jmpNeq(MBoss_476, 0)
    end
end

---MBoss_at1：三连发（真实 t=0/40/80 各一波，精灵号 13→14→2），80 帧后 ret。
---  L 行：14 发、角速 0.22439948、速度 4.0/1.3。
function s1.MBoss_at1(o)
    et_new(o, 0)
    et_sprite(o, 0, 1, 13)
    et_aim(o, 0, 1)
    et_angle(o, 0, 1.5707964, 0.22439948)     -- L
    et_count(o, 0, 14, 4)                     -- L
    et_speed(o, 0, 4.0, 1.3)                  -- L
    local p = o.pat[0]
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    fire_slot(o, 0)
    task.Wait(40)                             -- //40
    et_sprite(o, 0, 1, 14)
    fire_slot(o, 0)
    task.Wait(40)                             -- //80
    et_sprite(o, 0, 1, 2)
    fire_slot(o, 0)
end

---MBoss_at2：单发环（L 行 24 发、角速 0.09817477、速度 3.0/1.0）。
---  三枪之间用 wait([4])（[4]=20）把 clock 拉到 −20，再由「下一条指令时间 0」自然补回
---  ⇒ 真实出弹落在 t=20/40/60，60 帧后 ret。
function s1.MBoss_at2(o)
    et_new(o, 0)
    et_sprite(o, 0, 0, 2)
    et_aim(o, 0, 3)
    et_angle(o, 0, 0.0, 0.09817477)           -- L
    et_count(o, 0, 24, 6)                     -- L
    et_speed(o, 0, 3.0, 1.0)                  -- L
    local p = o.pat[0]
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    local ct = 0
    ct = ct - 20                              -- wait([4])（[4] = 20，diffI 四行同值）
    ct = s_wait(ct, 0)
    fire_slot(o, 0)
    et_angle(o, 0, 0.0, -0.09817477)
    ct = ct - 20
    ct = s_wait(ct, 0)
    fire_slot(o, 0)
    et_angle(o, 0, 0.0, 0.09817477)
    ct = ct - 20
    ct = s_wait(ct, 0)
    fire_slot(o, 0)
end

---非符 3643　穣子（BOSS 非符 1）
---  Boss1：240 帧一轮。指令时间戳（绝对）：moveRand#1=0、At1=40、wait(40)、
---    moveRand#2=40、At2=80、nop=120、At3=160、nop=200。`wait([0])`（[0]=40）把
---    clock 从 40 拨回 0，所以 moveRand#2 要再等 40 帧（不是等到 80）。
---  ★ moveRand#1 的时间戳是 0 —— 它在 jmpNeq 落回 224 的**同一帧**执行，必须写在
---    第一次 s_wait 之前，否则老板位置会整体晚 40 帧（出弹起点坐标随之漂移）。
---  血量：lifeSet(8200) → 阈值 2200 ⇒ 6000；时限 2700 帧 = 45 秒。
function s1.Boss1(o)
    local ct = 0
    ct = 200                                  -- jmp(Boss1_428, 200)
    ct = 0                                    -- jmpNeq(Boss1_224, 0)（同时把 clock 设为 0）
    while true do
        m_rand(o, "off", 40, 4, 6.0)          -- moveRand(40, 4, 6.0f)（t=0，先动）
        ct = s_wait(ct, 40)                   -- //40
        s_async(o, s1.Boss1At1)
        ct = ct - 40                          -- wait([0])（[0] = 40，L 行）
        ct = s_wait(ct, 40)                   -- moveRand#2 的时间戳也是 40（clock 已回 0）
        m_rand(o, "off", 40, 4, 6.0)
        ct = s_wait(ct, 80)                   -- //80
        s_async(o, s1.Boss1At2)
        ct = s_wait(ct, 120)                  -- //120
        ct = s_wait(ct, 160)                  -- //160
        s_async(o, s1.Boss1At3)
        ct = s_wait(ct, 200)                  -- //200
        ct = 0                                -- jmpNeq(Boss1_224, 0)
    end
end

---Boss1At1：60 帧外扩螺旋。每帧半径 +1.5、角 +0.15708，
---  先按 polar(角, 半径) 打精灵 2 的一发，再按 polar(角, −半径) 打精灵 1 的一发。
---  （原作把半径取负、算完坐标后又取负还原 —— 两次取负等价于不变，这里直接写负半径。）
---  L 行：5 发、角速 0.31415927、速度 2.5/1.0。
function s1.Boss1At1(o)
    et_new(o, 0)
    et_aim(o, 0, 0)
    et_angle(o, 0, 0.0, 0.31415927)           -- L
    et_count(o, 0, 5, 1)                      -- L
    et_speed(o, 0, 2.5, 1.0)                  -- L
    local p = o.pat[0]
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 8192, 100, -999999, -999999.0, -999999.0)
    local r   = 1.0                           -- [12] = 1.0f
    local ang = rndrad()                      -- [16] = %RANDRAD
    local ct  = 1                             -- jmp(Boss1At1_1152, 1)
    ---★ ECL 的 deci 是「后减」：它压回的是**减之前**的值（EclVm.cpp
    ---  ECL_VM_POST_DECREMENT_INT），jmpNeq 判的是旧值。所以 [0]=60 时
    ---  循环要跑满 60 轮（不是 59）。
    local n   = 60                            -- pushi(60)
    ct = 0                                    -- jmpNeq(Boss1At1_612, 0)
    while true do
        r = r + 1.5
        ang = t10_wrap(ang + 0.15708)         -- validRad([16])
        et_sprite(o, 0, 3, 2)
        et_offset(o, 0, circle_pos(ang, r))   -- circlePos([4],[8],[16],[12])
        ct = s_wait(ct, 1)                    -- //1
        fire_slot(o, 0)
        et_sprite(o, 0, 3, 1)
        et_offset(o, 0, circle_pos(ang, -r))  -- 半径取负的另一侧
        fire_slot(o, 0)
        n = n - 1                             -- deci([0])
        if n == 0 then break end              -- jmpNeq(Boss1At1_612, 0)
        ct = 0
    end
end

---Boss1At2 / Boss1At3：一次性环（L 行 32 发、角速 0.09817477、速度 2.8/1.0，
---  精灵 2 色 6，第 3 条 transform 记录带 ±0.03926991 的自转）。两者只差自转符号。
function s1.Boss1At2(o) return s1.Boss1At2_(o, 0.03926991) end
function s1.Boss1At3(o) return s1.Boss1At2_(o, -0.03926991) end
function s1.Boss1At2_(o, spin)
    et_new(o, 0)
    et_aim(o, 0, 2)
    et_angle(o, 0, 0.0, 0.09817477)
    et_count(o, 0, 32, 5)                     -- L
    et_speed(o, 0, 2.8, 1.0)                  -- L
    et_sprite(o, 0, 2, 6)
    local p = o.pat[0]
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 32, 40, -999999, 0.0, spin)
    p.ex[1] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)  -- 原作重复写一次
    fire_slot(o, 0)
end

---非符 3644　穣子（BOSS 非符 2）
---  Boss2：290 帧一轮（t=100/180/260/350 各出一只子机、t=220/350 各 moveRand 一次）。
---  血量：lifeSet(8200) → 阈值 2200 ⇒ 6000；时限 2700 帧 = 45 秒。
function s1.Boss2(o)
    local ct = 0
    t10_kill_async(o)                         -- killAllAsync
    ct = s_wait(ct, 60)                       -- //60：playSound(15) 之后的 nop
    ct = 350                                  -- jmp(Boss2_808, 350)
    ct = 60                                   -- jmpNeq(Boss2_608, 60)
    while true do
        ct = s_wait(ct, 100)                  -- //100
        s_async(o, s1.Boss2At2)               -- callAsync("Boss2At2")
        ct = s_wait(ct, 140)                  -- //140
        ct = s_wait(ct, 180)                  -- //180
        s_async(o, s1.Boss2At3)
        ct = s_wait(ct, 220)                  -- //220
        m_rand(o, "off", 40, 4, 6.0)
        ct = s_wait(ct, 260)                  -- //260
        s_async(o, s1.Boss2At1)
        ct = s_wait(ct, 350)                  -- //350
        m_rand(o, "off", 40, 4, 6.0)
        ct = 60                               -- jmpNeq(Boss2_608, 60)
    end
end

---Boss2At1：双槽交错螺旋，109 帧。每帧半径 +1.0：
---  槽 0 = 角 [16]（每帧 −0.15708、折进 ±π）、精灵 3 色 2；
---  槽 1 = 槽 0 的副本、精灵 3 色 1、aim 4，角 [20]（每帧 +0.15708）。
---  ★ 原作在槽 1 那里写的是 `validRad([16])`（折的是槽 0 的角、不是 [20]），
---    照抄；[20] 因此不折、直接进 cos/sin。
---  L 行：槽 0 6 发、速度 4.0/1.0、角速 1.0471976。
function s1.Boss2At1(o)
    et_new(o, 0)
    et_aim(o, 0, 2)
    et_angle(o, 0, 0.0, 1.0471976)
    et_count(o, 0, 6, 1)                      -- L
    et_speed(o, 0, 4.0, 1.0)                  -- L
    local p = o.pat[0]
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 8192, 100, -999999, -999999.0, -999999.0)
    et_sprite(o, 0, 3, 2)
    et_copy(o, 1, 0)                          -- etCopy(1, 0)
    et_sprite(o, 1, 3, 1)
    et_aim(o, 1, 4)
    local r  = 1.0                            -- [12] = 1.0f
    local a0 = rndrad()                       -- [16] = %RANDRAD
    local a1 = a0                             -- [20] = [16]
    local ct = 1                              -- jmp(Boss2At1_1100, 1)
    local n  = 110                            -- pushi(110)；deci 压回旧值 ⇒ 110 轮
    ct = 0                                    -- jmpNeq(Boss2At1_672, 0)
    while true do
        r = r + 1.0
        a0 = t10_wrap(a0 - 0.15708)           -- validRad([16])
        et_offset(o, 0, circle_pos(a0, r))    -- circlePos([4],[8],[16],[12])
        ct = s_wait(ct, 1)                    -- //1
        fire_slot(o, 0)
        a1 = a1 + 0.15708
        a0 = t10_wrap(a0)                     -- validRad([16])（原作如此，作用在槽 0 的角上）
        et_offset(o, 1, circle_pos(a1, r))    -- circlePos([4],[8],[20],[12])
        fire_slot(o, 1)                       -- !NHL ⇒ L 行也打
        n = n - 1                             -- deci([0])
        if n == 0 then break end              -- jmpNeq(Boss2At1_672, 0)
        ct = 0
    end
end

---Boss2At2 / Boss2At3：一次性环（L 行 32 发、角速 0.19634955、速度 3.2/1.0，
---  精灵 2 色 6，第 4 条 transform 记录带 ±0.05235988 的自转）。
---  ★ Boss2At2 的第 4 条记录 i1 = 9（L 行 count 32/9），Boss2At3 是 32/5。
function s1.Boss2At2(o) return s1.Boss2At2_(o, 9,  -0.05235988) end
function s1.Boss2At3(o) return s1.Boss2At2_(o, 5,   0.05235988) end
function s1.Boss2At2_(o, c2, spin)
    et_new(o, 0)
    et_aim(o, 0, 2)
    et_angle(o, 0, 0.0, 0.19634955)
    et_count(o, 0, 32, c2)                    -- L 行
    et_speed(o, 0, 3.2, 1.0)                  -- L 行
    et_sprite(o, 0, 2, 6)
    local p = o.pat[0]
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 8192, 200, -999999, -999999.0, -999999.0)
    p.ex[3] = tp_record(0, 32, 50, -999999, 0.0, spin)
    p.ex[1] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    fire_slot(o, 0)
end
--=====================================
--八·B、stage02（犬走椛 中 BOSS 一张 + BOSS 三张）
--=====================================


---MBossDummyShadow / BossDummyShadow：t=0 起每帧 anmPlay 的死循环。
---（原作 jmp(L,1) → L: anmPlay → jmpNeq 回跳；anmPlay 是纯视觉，这里只占帧。）
function s2.MBossDummyShadow(o) while true do task.Wait(1) end end
function s2.BossDummyShadow(o)  while true do task.Wait(1) end end

---BossTrace：每帧把 offsetMotion 设成自机坐标（原作 moveBoss = COPY_PLAYER_TO_OFFSET）。
---★ 第一帧不执行（ECL 是 jmp 到 jmpNeq 再回跳到 t=1 的组），所以 Wait 在前。
function s2.BossTrace(o)
    while true do
        task.Wait(1)
        m_pos(o, "off", player.x, t10_oy(player.y))
    end
end

---卡 3633　厄符「厄神様のバイオリズム」（中 BOSS 犬走椛）
---  原作 MBossCard1 / MBossAtEnemy / MBossAtEnemy2 / MBossAtEnemyAt / MBossDummyShadow。
---  主线程：入场 60 帧后进死循环 —— 每 180 帧一对子机（t=60 出 AtEnemy、t=150 出 AtEnemy2、
---  t=240 同帧 moveRand(40,0,1.0)+wait(40)，随后 jmpNeq 立刻回到 L412 再出一只 AtEnemy）。
---  ★ t=240 那一帧里 moveRand、wait(40)、jmpNeq、下一次 enmCreate 全部同帧执行（clock 被
---    wait 拨到 200 又被 jmp 设回 60），所以 AtEnemy 的出机帧是 60/240/420…
function s2.MBossCard1(o)
    local ct = 0
    t10_kill_async(o)                             -- killAllAsync
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)                           -- enmKillAll
    ct = s_wait(ct, 60)                           -- //60：anmPlay(0, 409)（视觉）
    ct = 240                                      -- jmp(MBossCard1_572, 240)
    ct = 60                                       -- jmpNeq(MBossCard1_412, 60)
    while true do                                 -- L412
        s_pod(o, 0.0, 0.0, s2.MBossAtEnemy)
        ct = s_wait(ct, 150)                      -- //150
        s_pod(o, 0.0, 0.0, s2.MBossAtEnemy2)
        ct = s_wait(ct, 240)                      -- //240
        m_rand(o, "off", 40, 0, 1.0)
        ct = ct - 40                              -- wait(40) → clock 240→200（不占帧）
        ct = s_wait(ct, 240)                      -- ★ pushi/jmpNeq 的时间戳仍是 //240：
                                                  --   wait 把 clock 拨到 200 后，要等回 240
                                                  --   才能执行（漏这条会让下一只子机早出 41 帧）
        ct = 60                                   -- jmpNeq(L412, 60)
    end
end

---MBossAtEnemy：绕 BOSS 逆时针外扩的子机（base 圆运动），t=120 起改成「朝自机偏 +π/6」
---  的 60 帧极坐标插值（角 π/2 → ANGLE_PLAYER+π/6、速度 0 → 5），t=240 自毁。
function s2.MBossAtEnemy(o)
    local ct = 0
    s_async(o, s2.MBossDummyShadow)               -- callAsync("MBossDummyShadow")
    s_async(o, s2.MBossAtEnemyAt, 0.0, 0.15707964)
    m_circle(o, "base", 0.0, 0.05235988, 0.0, 0.53333336)
    ct = s_wait(ct, 120)                          -- //120
    m_vel(o, "base", 1.5707964, 0.0)
    m_vel_time(o, "base", 60, 0, t10_angle_player(o) + 3.1415927 / 6, 5.0)
    ct = s_wait(ct, 180)                          -- //180：etProtectRange（视觉）
    ct = s_wait(ct, 240)                          -- //240
    t10_delete(o)
end

---MBossAtEnemy2：与 MBossAtEnemy 同构、符号相反（起始角 π、角速度 −π/100、
---  插值角 = ANGLE_PLAYER − π/6）。
function s2.MBossAtEnemy2(o)
    local ct = 0
    s_async(o, s2.MBossDummyShadow)
    s_async(o, s2.MBossAtEnemyAt, 3.1415927, -0.15707964)
    m_circle(o, "base", 3.1415927, -0.05235988, 0.0, 0.53333336)
    ct = s_wait(ct, 120)
    m_vel(o, "base", 1.5707964, 0.0)
    m_vel_time(o, "base", 60, 0, t10_angle_player(o) - 3.1415927 / 6, 5.0)
    ct = s_wait(ct, 180)
    ct = s_wait(ct, 240)
    t10_delete(o)
end

---MBossAtEnemyAt 參數：a0（起始角）、a4（每 5 帧的角增量）。
---  槽 0：3 发（L）自机狙 + 每 5 帧一根「外甩」弹（记录 2，f1 = 本帧角）；
---  槽 1：槽 0 的复制（每 5 帧用 [8] 的角再打一枪）。两槽的角每 5 帧各 +a4 并折进 ±π。
function s2.MBossAtEnemyAt(o, a0, a4)
    local b = a0 + a4 / 2.5
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 3, 1
    p.type, p.color = 5, 2
    p.angle, p.astep = rndrad(), 0.0
    p.s1, p.s2 = 0.0, 1.0
    p.ex[0] = tp_record(1, 8, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 32768, 120, -999999, -999999.0, -999999.0)
    et_copy(o, 1, 0)
    while true do
        task.Wait(5)                              -- //5（首轮也在 t=5）
        et_angle(o, 0, a0, 0.0)
        et_angle(o, 1, b, 0.0)
        -- ★ 难度链是 if (DIFF<=1) {0.01, f1=[0]} else if (DIFF==2) {…} else if (DIFF==3)
        --   {speed 0.01/0.01; 0.016, f1=-999}（jmpEq = 弹栈为 0 才跳）。L 走最后一条。
        et_speed(o, 0, 0.01, 0.01)
        et_speed(o, 1, 0.01, 0.01)
        p.ex[2] = tp_record(1, 16, 100, -999999, 0.016, -999.0)
        et_ex(o, 1, 2, 1, 16, 100, -999999, 0.016, -999.0)
        fire_slot(o, 0)
        fire_slot(o, 1)
        a0 = t10_wrap(a0 + a4)
        b = t10_wrap(b + a4)
    end
end

---卡 3634　疵痕「壊されたお守り」（BOSS 犬走椛 - 1）
---  原作 BossCard1 / Boss1CardAtEnemy / Boss1CardAtEnemyAt / BossTrace / BossDummyShadow。
---  主循环 360 帧一轮：t=150 一帧内连出 14 只子机（%F0 每只 +0.523599），
---  之后 t=210 / t=310 各 moveRand 一次，t=360 回跳。
---  ★ 14 只子机是**同一帧**建出来的（clock 在这一帧被反复拨回 150），每只拿到自己的 %F0。
function s2.BossCard1(o)
    local ct = 0
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    ct = 360                                      -- jmp(BossCard1_1148, 360)
    ct = 0                                        -- jmpNeq(BossCard1_396, 0)
    while true do                                 -- L396
        ct = s_wait(ct, 60)                       -- //60：anmPlay(0, 409)
        ct = s_wait(ct, 120)                      -- //120：anmSelectedPlay(0)
        ct = s_wait(ct, 150)                      -- //150
        local _a = rndrad()                       -- [0] = %RANDRAD（后续没用，但要消耗随机数）
        local n = 14                              -- diffI([4], 6, 8, 10, 14)
        o.F0 = rndrad()                           -- %F0 = %RANDRAD
        o.F1 = 0.0                                -- %F1 = 0
        -- L1020: deci([4]); jmpNeq(L636, 150) —— 先减后判，体在标签之前
        while true do
            local old = n
            n = n - 1
            if old == 0 then break end
            s_pod(o, 0.0, 0.0, s2.Boss1CardAtEnemy)
            o.F0 = t10_wrap(o.F0 + 0.523599)      -- [!L] %F0 += 0.523599
        end
        ct = s_wait(ct, 210)                      -- //210：anmSetMain(0, 5)
        ct = s_wait(ct, 310)                      -- //310
        m_rand(o, "off", 50, 0, 2.0)
        ct = s_wait(ct, 360)                      -- //360
        ct = 0                                    -- jmpNeq(L396, 0)
    end
end

---Boss1CardAtEnemy：子机本体。offset 被 BossTrace 钉在自机身上，
---  base 走圆：t=0 起 半径 0→（60 帧）、角 %F0、角速度 %F1；
---  t=120 换成「起始角 %F0−π、半径 60、半径速度 0」（即停在自机外 60px 处）后自毁。
function s2.Boss1CardAtEnemy(o)
    local ct = 0
    s_async(o, s2.BossTrace)
    s_async(o, s2.BossDummyShadow)
    s_async(o, s2.Boss1CardAtEnemyAt)
    m_circle(o, "base", o.F0, o.F1, 0.0, 1.0)
    ct = s_wait(ct, 120)                          -- //120
    m_circle(o, "base", o.F0 - 3.1415927, o.F1, 60.0, 0.0)
    t10_delete(o)
end

---Boss1CardAtEnemyAt：槽 0 每 10 帧打 5 发（速度 1.1、角 %RANDRAD），共 30 发；
---  每发的记录 3 按 ([0] % 5) 更新（4 个固定分裂角 + 1 个 kind 0 的「停」），
---  出弹角用 %REL_ANGLE（= base 极坐标当前角，Enemy.cpp value1C）。
function s2.Boss1CardAtEnemyAt(o)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 5, 1
    p.type, p.color = 5, 2
    p.angle, p.astep = rndrad(), 0.0
    p.s1, p.s2 = 1.1, 1.0                       -- [!L] etSpeed(0, 1.1f, 1.0f)
    p.ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 8, -999999, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 32768, 50, -999999, -999999.0, -999999.0)
    et_copy(o, 1, 0)
    local n = 30
    while true do
        local old = n
        n = n - 1
        if old == 0 then break end
        task.Wait(10)                             -- //10
        local m = n % 5
        if m == 0 then
            p.ex[3] = tp_record(0, -2147483648, -999999, -999999, -999999.0, -999999.0)
        elseif m == 1 then
            p.ex[3] = tp_record(0, 64, 1, 1, 1.5707964, -999.0)
        elseif m == 2 then
            p.ex[3] = tp_record(0, 64, 1, 1, -1.5707964, -999.0)
        elseif m == 3 then
            p.ex[3] = tp_record(0, 64, 1, 1, 4.712389, -999.0)
        else
            p.ex[3] = tp_record(0, 64, 1, 1, -4.712389, -999.0)
        end
        et_angle(o, 0, o.ecs.base.ang, 0.0)       -- etAngle(0, %REL_ANGLE, 0)
        fire_slot(o, 0)
    end
end

---卡 3635　悲運「大鐘婆の火」（BOSS 犬走椛 - 2）
---  原作 BossCard2 / Boss2CardAtEnemy / Boss2CardAtEnemyAt / BossTrace / BossDummyShadow。
---  主循环每轮两批子机（各 8 只，同帧连出）：第一批角速度 %F1 = +0.017453、
---  第二批 −0.017453（%F0 每只 +0.785398）。两批之间与之后各有一条 wait(60)
---  （clock 回到 150，靠下一条指令的绝对时间补满 60 帧）。
function s2.BossCard2(o)
    local ct = 0
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    -- 原作 t=0 还有 etCancel(640)/etClear(640) 的二选一（按 %TIMEOUT）——两者在本移植里
    -- 都是「清上一张卡的残余弹」，由符卡框架接管，不写。
    ct = 300                                      -- jmp(BossCard2_1668, 300)
    ct = 0                                        -- jmpNeq(BossCard2_492, 0)
    while true do                                 -- L492
        ct = s_wait(ct, 60)                       -- //60：anmPlay(0, 409)
        ct = s_wait(ct, 120)                      -- //120：anmSelectedPlay(0)
        ct = s_wait(ct, 150)                      -- //150
        local _a = rndrad()                       -- [0] = %RANDRAD
        local n = 8                               -- diffI([4], 6, 8, 8, 8)
        o.F0 = 0.0                                -- %F0 = 0
        o.F1 = 0.017453                           -- %F1 = +0.017453
        o.I0 = 4                                  -- $I0 = 4（弹精灵色号）
        while true do                             -- L772 / L1004
            local old = n
            n = n - 1
            if old == 0 then break end
            s_pod(o, 0.0, 0.0, s2.Boss2CardAtEnemy)
            o.F0 = t10_wrap(o.F0 + 0.785398)      -- [!NHL]
        end
        ct = ct - 60                              -- [!HL] wait(60)
        ct = s_wait(ct, 150)                      -- 下一条指令的绝对时间是 150
        n = 8
        o.F0 = 0.0
        o.F1 = -0.017453
        o.I0 = 4
        while true do                             -- L1268 / L1500
            local old = n
            n = n - 1
            if old == 0 then break end
            s_pod(o, 0.0, 0.0, s2.Boss2CardAtEnemy)
            o.F0 = t10_wrap(o.F0 + 0.785398)
        end
        ct = ct - 60                              -- [!HL] wait(60)
        ct = s_wait(ct, 150)
        ct = s_wait(ct, 250)                      -- //250：anmSetMain(0, 5) 之后的 moveRand
        m_rand(o, "off", 50, 0, 2.0)
        ct = s_wait(ct, 300)                      -- //300
        ct = 0                                    -- jmpNeq(L492, 0)
    end
end

---Boss2CardAtEnemy：base 圆运动（角 %F0、角速度 %F1、半径 0→1/帧），t=280 自毁。
---  自己带 BossTrace（offset = 自机）+ 一个打弹线程，弹的第二个参数是 %F1×2（原作
---  `pushf(%F1); pushf(2.0f); mulf()` 的结果被 callAsync 的 [-1.0f] 操作数弹出来）。
function s2.Boss2CardAtEnemy(o)
    local ct = 0
    s_async(o, s2.BossTrace)
    s_async(o, s2.BossDummyShadow)
    s_async(o, s2.Boss2CardAtEnemyAt, o.F0, o.F1 * 2.0)
    m_circle(o, "base", o.F0, o.F1, 0.0, 1.0)
    ct = s_wait(ct, 60)                           -- //60：etProtectRange(32)（视觉）
    ct = s_wait(ct, 280)                          -- //280
    t10_delete(o)
end

---Boss2CardAtEnemyAt：a0 = 起始角、a4 = 每 8 帧的角增量（这里是 %F1×2 = ±0.034906）。
---  槽 0：精灵 (25,0)（H/L 覆盖）、2 列（L 行 count(0,1,2)），speed 0→0.3，每 8 帧打一枪；
---        L 行 ex 记录 2 的 f0 = 0.01（DIFF>1 的分支），f1 = 当前角。
function s2.Boss2CardAtEnemyAt(o, a0, a4)
    local b = a0 + a4 / 3.0
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 1, 1, 2
    p.type, p.color = 25, 0
    p.angle, p.astep = rndrad(), 0.0
    p.s1, p.s2 = 0.0, 0.3
    p.ex[0] = tp_record(1, 8, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 32768, 120, -999999, -999999.0, -999999.0)
    et_copy(o, 1, 0)
    while true do
        task.Wait(8)                              -- //8（首轮也在 t=8）
        -- DIFF>1（L 一定）走 else：f0 = 0.013
        p.ex[2] = tp_record(1, 16, 100, -999999, 0.013, a0)
        fire_slot(o, 0)
        a0 = t10_wrap(a0 + a4)
        b = t10_wrap(b + a4)
    end
end

---卡 3636　創符「流刑人形」（BOSS 犬走椛 - 3）
---  原作 BossCard3 / BossAtEnemy3 / BossTrace / BossDummyShadow。
---  t=120 一帧内出 4 只子机（起始角 0、π/2、π、−π/2，角速度都是 0.02618）；
---  主线程之后每 2 帧在半径 %RANDF×[12]（从 0 起、每帧 +0.1、上限 64）的随机角上
---  打一枪 9 发扇形，基准角 [0] 每轮 −0.1309，色号 [20] 在 1..4 循环。
function s2.BossCard3(o)
    local ct = 0
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    ct = s_wait(ct, 60)                           -- //60：anmPlay(0, 409)
    ct = s_wait(ct, 120)                          -- //120：anmSelectedPlay(0)
    o.F0, o.F1 = 0.0, 0.02618
    s_pod(o, 0.0, 0.0, s2.BossAtEnemy3)
    o.F0, o.F1 = 1.570796, 0.02618
    s_pod(o, 0.0, 0.0, s2.BossAtEnemy3)
    o.F0, o.F1 = 3.141593, 0.02618
    s_pod(o, 0.0, 0.0, s2.BossAtEnemy3)
    o.F0, o.F1 = -1.570796, 0.02618
    s_pod(o, 0.0, 0.0, s2.BossAtEnemy3)
    local a0    = 3.141593                        -- [0]
    local n     = 9                               -- [24] = diffI([24], 3, 5, 5, 9)
    local spd   = 2.0                             -- [28] = diffF([28], 1.0, 1.5, 1.5, 2.0)
    local fc    = 0                               -- [16]（帧计数）
    local scale = 0.0                             -- [12]（弹环半径系数）
    local col   = 1                               -- [20]（精灵色号）
    ct = 122                                      -- jmp(BossCard3_2232, 122)
    ct = 120                                      -- jmpNeq(BossCard3_1224, 120)
    while true do                                 -- L1224（每 2 帧一轮）
        local r = rnd() * scale                   -- %RANDF × [12]（先取随机）
        local ang = rndrad()                      -- %RANDRAD（后取随机）
        local x, y = circle_pos(ang, r)           -- circlePos([4], [8], %RANDRAD, [-1.0f])
        if fc > 60 and scale < 64 then scale = scale + 0.1 end
        et_new(o, 0)
        local p = o.pat[0]
        p.aim, p.c1, p.c2 = 1, n, 1
        p.type, p.color = 5, col
        p.angle, p.astep = a0, 0.3926991
        p.s1, p.s2 = spd, 1.0
        p.ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
        p.ex[1] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
        et_offset(o, 0, x, y)
        fire_slot(o, 0)
        a0 = t10_wrap(a0 - 0.1309)
        fc = fc + 1
        col = col + 1
        if col > 4 then col = 1 end
        ct = s_wait(ct, 122)                      -- +2: //122
        ct = 120                                  -- jmpNeq(L1224, 120)
    end
end

---BossAtEnemy3：子机。offset 被 BossTrace 钉在自机身上，base 走圆：
---  t=0 起半径 0→（1/帧）、角 %F0、角速度 %F1；t=80 换成「起始角 %F0−π、半径 80、半径速度 0」。
---  之后每 7 帧两枪：
---    ① 只有自机在 BOSS 下方（%PLAYER_Y2 ≥ %BOSS_Y）时打：角 %RANDRAD/6（视觉用）；
---    ② L 难度无条件打：角按 [4] % 7 从 %RANDRAD/8 ± {0, π/4, π/2} 里选一个。
---  [8] 每打一枪 +1、每满 10 枪 [4] +1（[4] 决定②的角度档位）。
function s2.BossAtEnemy3(o)
    local ct = 0
    local r4, r8 = 0, 0                           -- [4] / [8]
    s_async(o, s2.BossTrace)
    s_async(o, s2.BossDummyShadow)
    m_circle(o, "base", o.F0, o.F1, 0.0, 1.0)
    ct = s_wait(ct, 80)                           -- //80
    m_circle(o, "base", o.F0 - 3.1415927, o.F1, 80.0, 0.0)
    ct = 87                                       -- jmp(BossAtEnemy3_4364, 87)
    ct = 80                                       -- jmpNeq(BossAtEnemy3_368, 80)
    while true do                                 -- L368（每 7 帧一轮）
        if t10_oy(player.y) < s_boss_y(o) then    -- %PLAYER_Y2 < %BOSS_Y（jmpEq = 假才跳）
            et_new(o, 0)
            local p = o.pat[0]
            p.aim, p.c1, p.c2 = 0, 1, 1
            p.type, p.color = 24, 6
            p.angle, p.astep = rndrad() / 6, 0.3926991
            p.s1, p.s2 = 0.8, 1.0
            p.ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
            p.ex[1] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
            fire_slot(o, 0)
        end
        -- L776：DIFF >= 2 才打第二枪（本仓库固定 L ⇒ 一定打）
        local m = r4 % 7
        local q = rndrad() / 8
        if     m == 0 then q = q - 3.1415927 / 2
        elseif m == 1 then q = q - 3.1415927 / 4
        elseif m == 2 then q = q
        elseif m == 3 then q = q + 3.1415927 / 4
        elseif m == 4 then q = q + 3.1415927 / 2
        elseif m == 5 then q = q + 3.1415927 / 4
        else                q = q                    -- [4]%7 == 6：不偏移
        end
        et_new(o, 0)
        local p = o.pat[0]
        p.aim, p.c1, p.c2 = 0, 1, 1
        p.type, p.color = 24, 6
        p.angle, p.astep = q, 0.3926991
        p.s1, p.s2 = 0.8, 1.0
        p.ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
        p.ex[1] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
        fire_slot(o, 0)
        r8 = r8 + 1
        if r8 % 10 == 0 then r4 = r4 + 1 end
        ct = s_wait(ct, 87)                       -- +7: //87
        ct = 80                                   -- jmpNeq(L368, 80)
    end
end

--=====================================
--八·B-2、stage02 非符（犬走椛 BOSS 两张；只做 Lunatic 难度行）
--  ECL 源：r02raw.txt 的 Boss1 / Boss2 及其子线程。
--  ★ 中 BOSS **没有**非符：MBoss() 里 lifeSet(2300) 之后直接 call("MBossCard1")（= 厄符）。
--  ★ 血量按「进场 life − 收尾阈值」：Boss1 = 9000−2700 = 6300；Boss2 = 13400−5400 = 8000。
--    （所以原来的符卡血量 13400 是错的，见注册表注释。）
--=====================================

---Boss1/Boss2 主线程共用的「环」：etNew(slot) + 两条 ex 记录 + 5 个 etOn
---  （t=0/10/20/30/40，每个 etOn 前重取一次 %RANDRAD 作基准角）。
---  返回最后一个 etOn 的绝对时间（= 传入 ct + 40）。
function s2.ring(o, slot, cnt, spd, ct)
    et_new(o, slot)
    et_aim(o, slot, 3)
    et_sprite(o, slot, 5, 2)
    et_count(o, slot, cnt, 1)
    et_angle(o, slot, rndrad(), 0.0)
    et_speed(o, slot, spd, 1.0)
    local p = o.pat[slot]
    p.ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    fire_slot(o, slot)
    for _ = 1, 4 do
        ct = s_wait(ct, ct + 10)
        et_angle(o, slot, rndrad(), 0.0)
        fire_slot(o, slot)
    end
    return ct
end

---卡 3645　犬走椛（BOSS 非符 1）
---  Boss1 主循环 720 帧一轮：t=0 左右各出一只绕身子机（%F0=0/π）；
---  t=280 与 t=640 各来一串 5×32 的环（角每 10 帧重取 %RANDRAD）；
---  t=320 / t=680 各 moveRand(40,0,2.0) 一次。起手 jmp(720)+jmpNeq 把 clock 归 0。
---  另起一条 Boss1At 线程（[!NHL]，L 也跑）。
function s2.Boss1(o)
    local ct = 0
    s_async(o, s2.Boss1At)                    -- [!NHL] callAsync("Boss1At")
    ct = 720                                   -- jmp(Boss1_2172, 720)
    ct = 0                                     -- jmpNeq(Boss1_196, 0)（同时把 clock 设为 0）
    while true do
        o.F0, o.F1, o.I0 = 0.0, 0.05236, 2
        s_pod(o, 0.0, 0.0, s2.BossAtEnemy)
        o.F0, o.I0 = 3.141593, 6
        s_pod(o, 0.0, 0.0, s2.BossAtEnemy)
        ct = s_wait(ct, 60)                    -- //60：anmSetMain（视觉）
        ct = s_wait(ct, 280)                   -- //280
        ct = s2.ring(o, 2, 32, 2.0, ct)        -- DIFF>=2：环（5 个 etOn，280→320）
        m_rand(o, "off", 40, 0, 2.0)           -- jmp(Boss1_1148, 320) 后的 moveRand(40,0,2.0)
        ct = s_wait(ct, 360)
        o.F0, o.F1, o.I0 = 0.0, -0.05236, 2
        s_pod(o, 0.0, 0.0, s2.BossAtEnemy)
        o.F0, o.I0 = -3.141593, 6
        s_pod(o, 0.0, 0.0, s2.BossAtEnemy)
        ct = s_wait(ct, 420)                   -- //420：anmSetMain（视觉）
        ct = s_wait(ct, 640)                   -- //640
        ct = s2.ring(o, 2, 32, 2.0, ct)        -- 环（640→680）
        m_rand(o, "off", 40, 0, 2.0)           -- jmp(Boss1_2128, 680) 后的 moveRand
        ct = s_wait(ct, 720)                   -- //720
        ct = 0                                 -- jmpNeq(Boss1_196, 0)
    end
end

---Boss1At：槽 1 每 60 帧打一波（L：[!L] etCount(1,48,1) 覆盖 8；速度 diffF L=2.2）。
function s2.Boss1At(o)
    et_new(o, 1)
    et_aim(o, 1, 2)
    et_sprite(o, 1, 12, 2)
    et_count(o, 1, 48, 1)                     -- [!L] L 行覆盖前面的 8
    et_angle(o, 1, 0.0, 0.0)
    et_speed(o, 1, 2.2, 1.0)                  -- diffF([0], 1.5, 2.2, 2.2, 2.2) ⇒ L = 2.2
    local p = o.pat[1]
    p.ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    local ct = 0
    while true do
        ct = s_wait(ct, 60)                   -- 起手 jmp(412,60)+jmpNeq 回到 t=60 的 etOn
        fire_slot(o, 1)
        ct = 0                                -- jmpNeq(Boss1At_96, 0)
    end
end

---BossAtEnemy / BossAtEnemy2L：绕 BOSS 转的子机（base 极坐标圆，圆心=出生点）。
---  t=60 换成「角 %F0−π、半径 60、半径速 0」（即停在 BOSS 外 60px）后到 t=360 自毁。
function s2.BossAtEnemy(o)
    local ct = 0
    s_async(o, s2.BossTrace)
    s_async(o, s2.BossDummyShadow)
    s_async(o, s2.BossAtEnemyAt)
    m_circle(o, "base", o.F0, o.F1, 0.0, 1.0)
    ct = s_wait(ct, 60)
    m_circle(o, "base", o.F0 - 3.1415927, o.F1, 60.0, 0.0)
    ct = s_wait(ct, 360)
    t10_delete(o)
end
function s2.BossAtEnemy2L(o)
    local ct = 0
    s_async(o, s2.BossTrace)
    s_async(o, s2.BossDummyShadow)
    s_async(o, s2.BossAtEnemy2LAt)
    m_circle(o, "base", o.F0, o.F1, 0.0, 1.0)
    ct = s_wait(ct, 60)
    m_circle(o, "base", o.F0 - 3.1415927, o.F1, 60.0, 0.0)
    ct = s_wait(ct, 360)
    t10_delete(o)
end

---BossAtEnemyAt / BossAtEnemy2LAt：槽 0 每 5 帧打 7×2 发、基准角取 %REL_ANGLE
---  （= base 极坐标当前角），共 60 轮。两者只差速度（L：3.3 / 4.0）。
---  ★ 循环体是「先 deci 后等 5 帧再出弹」——deci 压回的是旧值，所以正好打 60 轮。
function s2.at_enemy_at(o, spd)
    et_new(o, 0)
    et_aim(o, 0, 3)
    et_sprite(o, 0, 6, o.I0)
    et_count(o, 0, 7, 2)                      -- [!L] etCount(0, [4]=7, 2)
    et_angle(o, 0, rndrad(), 0.0)
    et_speed(o, 0, spd, 1.5)
    local p = o.pat[0]
    p.ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 8, -999999, -999999, -999999.0, -999999.0)
    et_copy(o, 1, 0)
    local n = 60
    local ct = 0
    while true do
        local old = n
        n = n - 1
        if old == 0 then break end            -- jmpNeq（判旧值）
        ct = ct - 5                           -- wait(5)：clock −5
        ct = s_wait(ct, 0)
        et_angle(o, 0, o.ecs.base.ang, 0.0)   -- etAngle(0, %REL_ANGLE, 0)
        fire_slot(o, 0)
        ct = 0                                -- jmpNeq(BossAtEnemy*At_516, 0)
    end
end
function s2.BossAtEnemyAt(o)   return s2.at_enemy_at(o, 3.3) end
function s2.BossAtEnemy2LAt(o) return s2.at_enemy_at(o, 4.0) end

---卡 3646　犬走椛（BOSS 非符 2）
---  Boss2 主循环 760 帧一轮（clock 120→880）：t=120 起一对 2L 子机（%F0=0/π）；
---  t=420 / t=800 各一串 5×32 的环；t=460 / t=840 各 moveRand(40,0,2.0) 一次。
---  另起一条 Boss2_atL 线程（[!L]）：槽 1 每 20 帧打 16 发，无限循环。
function s2.Boss2(o)
    local ct = 0
    t10_enm_kill_all(o)                        -- enmKillAll
    t10_kill_async(o)                          -- killAllAsync
    ct = s_wait(ct, 120)                       -- //120
    s_async(o, s2.Boss2_atL)                   -- [!L] callAsync("Boss2_atL")
    ct = 880                                   -- jmp(Boss2_2752, 880)
    ct = 120                                   -- jmpNeq(Boss2_720, 120)
    while true do
        o.F0, o.F1, o.I0 = 0.0, 0.05236, 2     -- [!L] %F1 = 0.05236
        s_pod(o, 0.0, 0.0, s2.BossAtEnemy2L)   -- [!L]
        o.F0, o.I0 = 3.141593, 6
        s_pod(o, 0.0, 0.0, s2.BossAtEnemy2L)   -- [!L]
        ct = s_wait(ct, 180)                   -- //180：anmSetMain（视觉）
        ct = s_wait(ct, 420)                   -- //420
        ct = s2.ring(o, 0, 32, 1.5, ct)        -- 环（420→460，L：etCount(0,[0]=32,1)）
        m_rand(o, "off", 40, 0, 2.0)           -- 同帧 moveRand(40,0,2.0)
        ct = s_wait(ct, 500)
        o.F0, o.F1, o.I0 = 0.0, 0.05236, 2     -- [!L] %F1 = 0.05236（基值 −0.02618 被覆盖）
        s_pod(o, 0.0, 0.0, s2.BossAtEnemy2L)
        o.F0, o.I0 = -3.141593, 6
        s_pod(o, 0.0, 0.0, s2.BossAtEnemy2L)
        ct = s_wait(ct, 560)                   -- //560：anmSetMain（视觉）
        ct = s_wait(ct, 800)                   -- //800
        ct = s2.ring(o, 0, 32, 1.5, ct)        -- 环（800→840）
        m_rand(o, "off", 40, 0, 2.0)
        ct = s_wait(ct, 880)                   -- //880
        ct = 120                               -- jmpNeq(Boss2_720, 120)
    end
end

---Boss2_atL：槽 1 每 20 帧打 16 发（自机狙、速度 3.0）的死循环。
function s2.Boss2_atL(o)
    et_new(o, 1)
    et_aim(o, 1, 2)
    et_sprite(o, 1, 6, 4)
    et_count(o, 1, 16, 1)
    et_angle(o, 1, 0.0, 0.0)
    et_speed(o, 1, 3.0, 1.0)
    local p = o.pat[1]
    p.ex[0] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    local ct = 0
    while true do
        ct = s_wait(ct, 20)                    -- 起手 jmp(332,20)+jmpNeq 后 t=20 的 etOn
        fire_slot(o, 1)
        ct = 0                                 -- jmpNeq(Boss2_atL_312, 0)
    end
end

--=====================================
--八·C、stage05（早苗 中 BOSS 一张 + 神奈子 BOSS 四张；只做 Lunatic 难度行）
--  ECL 源：stage05.ecl（thecl -d 10 -m th10.eclm -j -r -x 反汇编 → r05raw.txt）。
--  卡：MBossCard1（spellEx 60）、BossCard1（spell3 63）、BossCard2（spellEx 68）、
--      BossCard3（spell3 71）、BossCard4（spell3 75）。
--  ★ 原作 BossCard1/at3/at4 是 `!N`（Normal 专属）——L 行**不**调它们，这里也不写。
--  ★ BossCard3_at / BossCard3_at2 / BossCard2_at2 在原作 ECL 里没有任何调用点
--    （grep callAsync 确认），属死代码，不移植。
--=====================================

---%BOSS_X：specialEnemySlots[0]（= BOSS 本体）的世界坐标 x（与 s_boss_y 一对）。
local function s_boss_x(o)
    local b = o.t10_bossref
    if b == nil then return 0.0 end
    return b.ecs.wx
end

---enmCreateA（绝对坐标）+ 把 BOSS 引用传给子机（%BOSS_X/%BOSS_Y 要用）
local function s_pod_a(origin, x, y, fn)
    local p = spawn_pod(origin, x, y, fn)
    p.t10_bossref = origin.t10_bossref
    return p
end

---callAsync(name, a0, a4, a8, aC)：带 4 个实参起一个同敌机线程（BossCard4_at 用）。
local function s5_async4(o, fn, a, b, c, d)
    task.New(o, function() fn(o, a, b, c, d) end)
end

---=====================================
---卡 3637　秘術「一子相伝の弾幕」（中 BOSS 東風谷早苗）
---  原作 MBossCard1 / MBossCard1Dummy / Dummy2 / Dummy3。
---  t=90 起 420 帧一轮：先取 %F0 = ANGLE_PLAYER，出一只 Dummy；%F0 += π、validRad，
---  再出 Dummy2；[HL] 再出 Dummy3（L 也出）。之后 120/90/30/180 四段 wait。
---  ★ 主循环的 jmp/jmpNeq 组合把 clock 从 510 直接拨回 90（不等待），所以下一轮的
---    三只子机与 t=510 的 nop 同帧出生。
function s5.MBossCard1(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    task.Wait(90)                                -- //90：anmPlay/anmSetMain/anmSelected…（视觉）
    while true do                                -- L588（t=90）
        o.F0 = t10_angle_player(o)
        s_pod(o, 0.0, 0.0, s5.MBossCard1Dummy)
        o.F0 = t10_wrap(o.F0 + 3.141593)
        s_pod(o, 0.0, 0.0, s5.MBossCard1Dummy2)
        s_pod(o, 0.0, 0.0, s5.MBossCard1Dummy3)  -- [!HL]
        task.Wait(120)                           -- //210（anmSetSprite，视觉但占帧）
        task.Wait(90)                            -- //300（anmSelectedPlay）
        task.Wait(30)                            -- //330（moveRand）
        m_rand(o, "off", 60, 4, 1.0)
        task.Wait(180)                           -- //510
    end
end

---MBossCard1Dummy：绕 BOSS 半径 96 的旋臂，三层波（%F0 每轮 +2.513274）。
---  槽 0：5 发扇形（etCountD → L=5/1）、angle = ANGLE_PLAYER（出生时的）；
---  内层 20 次循环每次往前打一发：ex5 = 90 帧延迟、f1 = 当前角（$LUNATIC 两个分支相同），
---  ex3 = [12] 帧延迟（[12] 从 120 递减）、f1 = 3.0。
function s5.MBossCard1Dummy(o)
    local ang = o.F0
    local r = 96.0
    local x, y = circle_pos(ang, r)
    m_pos(o, "off", s_boss_x(o) + x, s_boss_y(o) + y)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 5, 1
    p.type, p.color = 3, 6
    p.angle, p.astep = 0.0, 0.7853982
    p.s1, p.s2 = 0.001, 1.0
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 8192, 100, -999999, -999999.0, -999999.0)
    p.ex[2] = tp_record(0, 4096, 100, -999999, -999999.0, -999999.0)
    p.ex[4] = tp_record(0, 64, 90, 1, 0.0, 0.0)
    et_angle(o, 0, t10_angle_player(o), 0.0)
    local n12 = 120
    local n8  = 5
    local ct  = 0
    while true do                                -- L1548（先判 [8]）
        local old8 = n8; n8 = n8 - 1
        if old8 == 0 then break end
        ct = 0                                   -- jmpNeq(L728, 0)
        ang = ang + 2.513274           -- L728
        local x2, y2 = circle_pos(ang, r)
        m_pos_time(o, "off", 20, 0, s_boss_x(o) + x2, s_boss_y(o) + y2)
        local n4 = 20
        local a24 = ang
        while true do                            -- L1504（先判 [4]）
            local old4 = n4; n4 = n4 - 1
            if old4 == 0 then break end
            ct = 0                               -- jmpNeq(L1084, 0)
            ct = s_wait(ct, 1)                   -- +1: //1（L1084 的 nop 在 t=0、下一段在 t=1）
            p.ex[5] = tp_record(0, 16, 90, -999999, 0.01, a24)
            a24 = t10_wrap(a24 + 0.1309)
            p.ex[3] = tp_record(0, 64, n12, 1, 0.0, 3.0)
            fire_slot(o, 0)
            n12 = n12 - 1
        end
    end
    t10_delete(o)
end

---MBossCard1Dummy2：同上、半径 64、精灵 (0,2)、旋臂反向；每轮 ex4 的 f1 = 0.007（L 行，
---  原作用 `pushi($LUNATIC); jmpEq(...)` —— LUNATIC==1 时 jmpEq 不跳、走 0.007 分支）。
function s5.MBossCard1Dummy2(o)
    local ang = o.F0
    local r = 64.0
    local x, y = circle_pos(ang, r)
    m_pos(o, "off", s_boss_x(o) + x, s_boss_y(o) + y)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 5, 1
    p.type, p.color = 0, 2
    p.angle, p.astep = 0.0, 0.7853982
    p.s1, p.s2 = 0.001, 1.0
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 8192, 100, -999999, -999999.0, -999999.0)
    p.ex[3] = tp_record(0, 64, 90, 1, 0.0, 0.0)
    et_angle(o, 0, ang, 0.0)
    local n12 = 120
    local n8  = 5
    local ct  = 0
    while true do
        local old8 = n8; n8 = n8 - 1
        if old8 == 0 then break end
        ct = 0
        ang = ang - 2.513274
        local x2, y2 = circle_pos(ang, r)
        m_pos_time(o, "off", 20, 0, s_boss_x(o) + x2, s_boss_y(o) + y2)
        local n4 = 20
        local a24 = ang
        while true do
            local old4 = n4; n4 = n4 - 1
            if old4 == 0 then break end
            ct = 0
            ct = s_wait(ct, 1)
            p.ex[4] = tp_record(0, 16, 90, -999999, 0.007, a24)
            a24 = t10_wrap(a24 - 0.1309)
            p.ex[2] = tp_record(0, 64, n12, 1, 0.0, 2.0)
            fire_slot(o, 0)
            n12 = n12 - 1
        end
    end
    t10_delete(o)
end

---MBossCard1Dummy3：半径 128、精灵 (0,6)、ex2 的 f1 = 4.0；打弹前多一个
---  `($LUNATIC) or ([4]%2==0)` 条件 —— LUNATIC=1 ⇒ 恒真 ⇒ 每轮都 etOn（与 Dummy2 同）。
function s5.MBossCard1Dummy3(o)
    local ang = o.F0
    local r = 128.0
    local x, y = circle_pos(ang, r)
    m_pos(o, "off", s_boss_x(o) + x, s_boss_y(o) + y)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 5, 1
    p.type, p.color = 0, 6
    p.angle, p.astep = 0.0, 0.7853982
    p.s1, p.s2 = 0.001, 1.0
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 8192, 100, -999999, -999999.0, -999999.0)
    p.ex[3] = tp_record(0, 64, 90, 1, 0.0, 0.0)
    et_angle(o, 0, ang, 0.0)
    local n12 = 120
    local n8  = 5
    local ct  = 0
    while true do
        local old8 = n8; n8 = n8 - 1
        if old8 == 0 then break end
        ct = 0
        ang = ang - 2.513274
        local x2, y2 = circle_pos(ang, r)
        m_pos_time(o, "off", 20, 0, s_boss_x(o) + x2, s_boss_y(o) + y2)
        local n4 = 20
        local a24 = ang
        while true do
            local old4 = n4; n4 = n4 - 1
            if old4 == 0 then break end
            ct = 0
            ct = s_wait(ct, 1)
            p.ex[4] = tp_record(0, 16, 90, -999999, 0.007, a24)
            a24 = t10_wrap(a24 - 0.1309)
            p.ex[2] = tp_record(0, 64, n12, 1, 0.0, 4.0)
            fire_slot(o, 0)                      -- $LUNATIC or [4]%2==0 ⇒ L 恒真
            n12 = n12 - 1
        end
    end
    t10_delete(o)
end

---=====================================
---卡 3638　奇跡「客星の明るすぎる夜」（BOSS 八坂神奈子 - 1）
---  原作 BossCard1 / _at / _at2 / _at5（_at3/_at4 是 !N，L 不跑）。
---  t=90 起三线程：at（右侧光柱臂）、at2（左侧光柱臂）、at5（两列弹），主线程随后 1 帧死循环。
function s5.BossCard1(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    task.Wait(90)                                -- //90
    t10_call_async(o, s5.BossCard1_at)
    t10_call_async(o, s5.BossCard1_at2)
    t10_call_async(o, s5.BossCard1_at5)
    while true do task.Wait(1) end               -- L788/L804：clock 91↔90 的 1 帧死循环
end

---BossCard1_at：右侧（offset +128）旋转光柱，每 4 帧一根，角度 [4] 每帧 +0.106272。
function s5.BossCard1_at(o)
    local a4 = -3.043418
    et_new(o, 0)
    o.pat[0].ex[0] = tp_record(1, 134217728, 1, -999999, -999999.0, -999999.0)
    local ct = 0
    while true do                                -- L168（t=0）
        et_offset(o, 0, 128.0, 0.0)
        t10_laser_on(o, 3, 6, a4, 2.0, 0.0, 128.0, 0.0, 16.0, 128.0, 0.0)
        a4 = t10_wrap(a4 + 0.106272)
        ct = s_wait(ct, 4)                       -- //4
        ct = 0                                   -- jmpNeq(L168, 0)
    end
end

---BossCard1_at2：左侧（offset −128）同构、角度每帧 −0.106272。
function s5.BossCard1_at2(o)
    local a4 = -3.043418                         -- diffF([4], 0.09817477, 0.09817477, -3.043418, -3.043418)
    local ct = 0
    while true do                                -- L96（t=0）
        et_offset(o, 0, -128.0, 0.0)
        t10_laser_on(o, 3, 6, a4, 2.0, 0.0, 128.0, 0.0, 16.0, -128.0, 0.0)
        a4 = t10_wrap(a4 - 0.106272)
        ct = s_wait(ct, 4)
        ct = 0
    end
end

---BossCard1_at5：槽 3/4 各一列弹（speed 2.5 / 1.0），每轮同时 etOn，然后 diffWait(…,20)。
function s5.BossCard1_at5(o)
    et_new(o, 3)
    local p3 = o.pat[3]
    p3.aim, p3.c1, p3.c2 = 0, 1, 1
    p3.type, p3.color = 25, 0
    p3.angle, p3.astep = 0.0052359877, 0.0
    p3.s1, p3.s2 = 2.5, 1.0
    p3.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    et_offset(o, 3, 0.0, 0.0)
    et_new(o, 4)
    local p4 = o.pat[4]
    p4.aim, p4.c1, p4.c2 = 0, 1, 1
    p4.type, p4.color = 18, 0
    p4.angle, p4.astep = -0.0052359877, 0.0
    p4.s1, p4.s2 = 2.5, 1.0
    p4.ex[0] = tp_record(1, 2, -999999, -999999, -999999.0, -999999.0)
    et_offset(o, 4, 0.0, 0.0)
    local ct = 0
    while true do                                -- L652
        fire_slot(o, 3)
        fire_slot(o, 4)
        ct = ct - 20                             -- diffWait(60, 60, 120, 20)
        ct = s_wait(ct, 0)                       -- 下一条（jmpNeq 组）在 t=0
    end
end

---=====================================
---卡 3639　開海「モーゼの奇跡」（BOSS 八坂神奈子 - 2；L 行是 spellEx）
---  原作 BossCard2 / _at / _atEt / Boss2Et_at。
---  t=90 起：先叫 _at 线程（不断刷 BossCard2_atEt 子机），主线程每轮在 t=90 与 t=120
---  各出一只 Boss2Et_at（enmCreateA），%F0 每只 +0.523599，%F2 从 16 起每次 <128 就 +16。
function s5.BossCard2(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    task.Wait(90)                                -- //90
    t10_call_async(o, s5.BossCard2_at)
    o.F0 = rndrad()                              -- %F0
    o.F2 = 16.0                                  -- %F2
    while true do                                -- L576（t=90）
        s_pod_a(o, 0.0, 0.0, s5.Boss2Et_at)
        o.F0 = t10_wrap(o.F0 + 0.523599)
        if o.F2 < 128 then o.F2 = o.F2 + 16 end
        task.Wait(30)                            -- //120
        m_rand(o, "off", 50, 0, 3.0)
        s_pod_a(o, 0.0, 0.0, s5.Boss2Et_at)
        o.F0 = t10_wrap(o.F0 + 0.523599)
        if o.F2 < 128 then o.F2 = o.F2 + 16 end
        task.Wait(30)                            -- //150
    end
end

---BossCard2_at：[8] = 64 起（每轮 +1，到 112 封顶）；每轮两次在随机半径（%RANDF×80）
---  的随机角上出 BossCard2_atEt 子机，$I0 = [8]/8（8→14），%F1 = ±0.10472。
---  ★ 开头的 `wait(120)` 把 clock 拨到 −120，下一条指令要等回 0 ⇒ 起手先空转 121 帧。
function s5.BossCard2_at(o)
    local n8 = 64                                -- [8]
    local ct = 0
    ct = ct - 120                                -- wait(120)（不占帧）
    ct = s_wait(ct, 0)                           -- 下一条（jmp）在 t=0 ⇒ 等回 0
    while true do                                -- L120（t=0）
        local r = rnd() * 80.0                   -- %RANDF×80（先取）
        local x, y = circle_pos(rndrad(), r)     -- %RANDRAD（后取）
        o.I0 = math.floor(n8 / 8)                -- $I0
        o.F1 = 0.10472
        s_pod(o, x, y, s5.BossCard2_atEt)
        ct = s_wait(ct, 30)                      -- //30
        n8 = n8 + 1
        local r2 = rnd() * 80.0
        local x2, y2 = circle_pos(rndrad(), r2)
        o.I0 = math.floor(n8 / 8)
        o.F1 = t10_wrap(-0.10472)
        s_pod(o, x2, y2, s5.BossCard2_atEt)
        ct = s_wait(ct, 60)                      -- //60
        if n8 < 112 then n8 = n8 + 1 end
        ct = 0                                   -- jmpNeq(L120, 0)
    end
end

---BossCard2_atEt：[4] = $I0（从父线程拿），每轮 4 次 etOn（0/2 同帧、1/3 同帧、间隔 1+3 帧）：
---  槽 0 = 主弹（自机狙 + 延迟分裂 0.08），槽 1 = 槽 0 的复制（精灵 25,0），
---  槽 2/3 = [HL] 三向扇形（精灵 5,6 / 18,0）。
function s5.BossCard2_atEt(o)
    local n4 = o.I0
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 1, 1, 1
    p.type, p.color = 5, 2
    p.angle, p.astep = t10_angle_player(o), 0.0
    p.s1, p.s2 = 1.0, 1.4
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 32, 60, -999999, 0.08, 0.0)      -- L 行
    et_copy(o, 1, 0)
    et_copy(o, 2, 0)
    et_sprite(o, 1, 25, 0)
    et_copy(o, 3, 1)
    et_count(o, 2, 3, 1)                                    -- [L]
    et_angle(o, 2, 1.5707964, 0.5235988)
    et_sprite(o, 2, 5, 6)
    et_count(o, 3, 3, 1)                                    -- [L]
    et_angle(o, 3, 1.5707964, 0.5235988)
    et_sprite(o, 3, 18, 0)
    local ct = 0
    while true do                                -- L900（jmp(900,4) → deci 立即执行）
        local old = n4; n4 = n4 - 1
        if old == 0 then break end
        ct = 0                                   -- jmpNeq(L804, 0)
        fire_slot(o, 0)
        fire_slot(o, 2)                          -- [!HL]
        ct = s_wait(ct, 1)                       -- +1: //1
        fire_slot(o, 1)
        fire_slot(o, 3)                          -- [!HL]
        ct = s_wait(ct, 4)                       -- +3: //4
    end
    t10_delete(o)
end

---Boss2Et_at：enmCreateA 出来的「分海」子机。[4] 从 %RANDF×8 起每轮 +12，到 448 为止；
---  每轮在 ±224 处各放一根竖直长条激光（长度 = %F2 ± sin([24])×64，>0 才放），
---  [24] 每轮 −0.1309。激光是本移植的视觉近似（原作 laserStOn 的几何没搬）。
function s5.Boss2Et_at(o)
    local v4  = rnd() * 8.0                      -- [4]
    local a24 = o.F0                             -- [24]
    m_pos(o, "off", 0.0, 0.0)
    local ct = 1                                 -- jmp(L1288, 1)
    while true do                                -- L1288
        if not (v4 < 448.0) then break end
        ct = 0                                   -- jmpNeq(L380, 0)
        ct = s_wait(ct, 1)                       -- +1: //1
        local s8 = math.sin(a24)
        a24 = t10_wrap(a24 - 0.1309)
        et_offset(o, 0, -224.0, v4)
        local w12 = o.F2 + s8 * 64.0
        if w12 > 0 then
            t10_laser_on(o, 8, 6, 0.0, 0.0, w12, w12, 0.0, 32.0, -224.0, v4)
        end
        et_offset(o, 0, 224.0, v4)
        w12 = o.F2 - s8 * 64.0
        if w12 > 0 then
            t10_laser_on(o, 8, 6, 3.1415927, 0.0, w12, w12, 0.0, 32.0, 224.0, v4)
        end
        v4 = v4 + 12.0
    end
    t10_delete(o)
end

---=====================================
---卡 3640　準備「サモンタケミナカタ」（BOSS 八坂神奈子 - 3）
---  原作 BossCard3 / BossCard3Dummy×4。360 帧一轮，每轮 4+4 只子机（两批）。
function s5.BossCard3(o)
    t10_kill_async(o)
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)
    task.Wait(80)                                -- //80
    while true do                                -- L416（t=80）
        o.F0 = t10_angle_player(o)
        s_pod(o, 0.0, 0.0, s5.BossCard3Dummy3)
        s_pod(o, 0.0, 0.0, s5.BossCard3Dummy4)
        s_pod(o, 0.0, 0.0, s5.BossCard3Dummy)    -- [!HL]
        s_pod(o, 0.0, 0.0, s5.BossCard3Dummy2)   -- [!HL]
        task.Wait(60)                            -- //140（anmSetSprite）
        task.Wait(90)                            -- //230
        s_pod(o, 0.0, 0.0, s5.BossCard3Dummy)
        s_pod(o, 0.0, 0.0, s5.BossCard3Dummy2)
        s_pod(o, 0.0, 0.0, s5.BossCard3Dummy3)   -- [!HL]
        s_pod(o, 0.0, 0.0, s5.BossCard3Dummy4)   -- [!HL]
        task.Wait(60)                            -- //290（anmSetSprite）
        task.Wait(90)                            -- //380
        m_rand(o, "off", 40, 0, 2.0)
        task.Wait(60)                            -- //440
    end
end

---BossCard3Dummy×4：绕 BOSS 的旋臂子机，5 轮 × 10 次内层循环。
---  参数（L 行列）：radius/[32] 环长、aim、精灵色、%F0 旋向、[24] 每轮增量。
---  内层每轮打一发：ex4（90 帧延迟、f1 = 当前角、f0 = 0.015 —— LUNATIC 走 `noti` 分支）、
---  ex2（[12] 帧延迟的圆环，f1 = [32]）。
local function s5_boss3_dummy(o, aim, sp, col, radius, cnt, f0dir, d24)
    local ang = o.F0
    local x, y = circle_pos(ang, radius)
    m_pos(o, "off", s_boss_x(o) + x, s_boss_y(o) + y)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = aim, 5, 1
    p.type, p.color = sp, col
    p.angle, p.astep = 0.0, 0.7853982
    p.s1, p.s2 = 0.001, 1.0
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 8192, 100, -999999, -999999.0, -999999.0)
    p.ex[3] = tp_record(0, 64, 90, 1, 0.0, 0.0)
    et_angle(o, 0, t10_angle_player(o), 0.0)
    local n12 = 60
    local n8  = 5
    local ct  = 0
    while true do                                -- L1752
        local old8 = n8; n8 = n8 - 1
        if old8 == 0 then break end
        ct = 0                                   -- jmpNeq(L728, 0)
        ang = ang + f0dir * 2.513274   -- L728
        local x2, y2 = circle_pos(ang, radius)
        m_pos_time(o, "off", 10, 0, s_boss_x(o) + x2, s_boss_y(o) + y2)
        local n4 = 10
        local a24 = ang
        while true do                            -- L1708
            local old4 = n4; n4 = n4 - 1
            if old4 == 0 then break end
            ct = 0                               -- jmpNeq(L1084, 0)
            ct = s_wait(ct, 1)                   -- +1: //1
            p.ex[4] = tp_record(0, 16, 90, -999999, 0.015, a24)
            a24 = t10_wrap(a24 + d24)
            p.ex[2] = tp_record(0, 64, n12, 1, 0.0, cnt)
            fire_slot(o, 0)                      -- ($DIFF>=1) or ([4]%2==0) ⇒ L 恒真
            n12 = n12 - 1
        end
    end
    t10_delete(o)
end

function s5.BossCard3Dummy(o)  s5_boss3_dummy(o, 3, 2, 6, 64.0, 4, 1, 0.024544) end
function s5.BossCard3Dummy2(o) s5_boss3_dummy(o, 5, 2, 6, 64.0, 4, -1, -0.024544) end
function s5.BossCard3Dummy3(o) s5_boss3_dummy(o, 3, 2, 2, 48.0, 3, 1, -0.1309) end
function s5.BossCard3Dummy4(o) s5_boss3_dummy(o, 5, 2, 2, 48.0, 3, -1, 0.1309) end

---=====================================
---卡 3641　大奇跡「八坂の神風」（BOSS 八坂神奈子 - 4；卡内 lifeSet(3000)）
---  原作 BossCard4 / _at / _at2。t=150 起：一只 at2 常态弹幕 + 每轮两发 at 旋臂。
function s5.BossCard4(o)
    t10_kill_async(o)
    t10_enm_kill_all(o)
    m_limit_clear(o)
    m_pos_time(o, "off", 90, 4, 0.0, 224.0)
    task.Wait(90)                                -- //90（setChapter/spell3/setInvuln 在 t=90）
    task.Wait(60)                                -- //150
    local a0 = 3.141593                          -- [0] = π
    t10_call_async(o, s5.BossCard4_at2)
    while true do                                -- L732（jmpNeq 把 clock 拨回 150）
        local ct = 150                           -- 「jmpNeq(L732, 150)」：每轮重新起算
        a0 = rndrad()                            -- [0] = %RANDRAD
        -- ★ 两处都是裸加减：原作 7d9c..7de8 / 7ec8..7f4c **没有** validRad。
        --   （实参顺序：[0]/[8] 两个弹栈值里，后压栈的给 a0，见 StartSubroutine 的弹栈顺序）
        s5_async4(o, s5.BossCard4_at, a0, 3.883222, a0 - 3.1415927 / 2, 6)
        ct = ct - 170                            -- diffWait(284, 284, 160, 170)
        ct = s_wait(ct, 166)                     -- +16: //166
        a0 = rndrad()
        s5_async4(o, s5.BossCard4_at,
                  a0 + 3.1415927 / 2, -3.883222,
                  a0 + 3.1415927, 10)
        ct = ct - 180                            -- diffWait(284, 284, 160, 180)
        ct = s_wait(ct, 182)                     -- +16: //182
        a0 = t10_wrap(a0 + 0.392699)
    end
end

---BossCard4_at：一圈向外扩的旋臂子机（[0]/[8] 两个角同向转、半径 32 起每轮 +0.5）。
---  [32]（L=340）每轮 −1；每轮 ex1 = [32] 帧延迟弹、ex2 = 16 帧延迟（L 行 f0 = 0.02）；
---  只有 [32] 为偶数的那一轮才 wait(1)（`($DIFF<=2) or ([32]%2==0)` ⇒ L 看奇偶）。
function s5.BossCard4_at(o, a0, a4, a8, aC)
    et_new(o, 0)
    local p = o.pat[0]
    p.aim, p.c1, p.c2 = 3, 1, 1
    p.type, p.color = 3, aC
    p.angle, p.astep = 0.0, 0.3926991
    p.s1, p.s2 = 0.1, 1.5
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    local r24 = 32.0                             -- [24] = 32.0
    local n32 = 340                              -- diffI([32], 284, 284, 320, 340)
    local ct  = 0
    while true do                                -- L340
        local old = n32; n32 = n32 - 1
        if old == 0 then break end
        ct = 0                                   -- jmpNeq(L340, 0)
        local x, y = circle_pos(a0, r24)
        a0 = t10_wrap(a0 + a4)
        a8 = t10_wrap(a8 + a4)
        r24 = r24 + 0.5
        p.ex[1] = tp_record(0, 32768, n32, -999999, -999999.0, -999999.0)
        p.ex[2] = tp_record(0, 16, 90, -999999, 0.02, -999.0)   -- L 行
        et_offset(o, 0, x, y)
        et_angle(o, 0, a8, 0.028049935)
        fire_slot(o, 0)
        if n32 % 2 == 0 then                     -- ([32]%2==0) ⇒ 等 1 帧
            ct = ct - 1                          -- wait(1)
            ct = s_wait(ct, 0)
        end
    end
end

---BossCard4_at2：常态弹幕（槽 1，16 发/列），先 diffWait(300,300,176,186) 再每 diffWait(…,50) 一轮。
function s5.BossCard4_at2(o)
    et_new(o, 1)
    local p = o.pat[1]
    p.aim, p.c1, p.c2 = 2, 16, 1
    p.type, p.color = 12, 3
    p.angle, p.astep = 0.0, 0.3926991
    p.s1, p.s2 = 1.5, 1.5
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    -- diffWait(300, 300, 176, 186)：clock -= 186。紧跟的 `jmp(L372, 0)` 指令
    --   自身时间字段是 0 > clock，所以引擎会在**执行 jmp 之前**等满 186 帧
    --   （EclVm.cpp 的 `while (指令.time <= currentTime)`；clock 此时是 −186）。
    local ct = 0
    ct = ct - 186
    ct = s_wait(ct, 0)
    while true do                                -- L320
        fire_slot(o, 1)
        ct = ct - 50                             -- diffWait(284, 50, 50, 50)
        ct = s_wait(ct, 0)
    end
end

--=====================================
--八·C-2、stage05 非符（早苗 中 BOSS 一张 + 神奈子 BOSS 三张；只做 Lunatic 难度行）
--  ECL 源：r05raw.txt 的 MBoss / Boss1 / Boss2 / Boss3 及其子线程。
--  ★ 血量 = 一相「进场 life − 收尾阈值」（Enemy.cpp 掉到阈值就夹回、切下一相）：
--      MBoss = 12900 − 2900 = 10000（时限 setInterrupt(1, 0, 2400, "MBossEscape") = 40 秒）；
--      Boss1 = 沿用 Boss() 的 life 12400 − 阈值 2400 = 10000；
--      Boss2 / Boss3 = lifeSet(10400) − 阈值 2400 = 8000。
--  ★ killAsync(0) 是 **no-op**：EclVm.cpp 的 ECL_VM_STOP_THREAD 用 FindThread(0) 找 id 为 0
--    的线程，而主线程与 callAsync 出来的线程 id 都是 −1（Enemy.cpp 构造里 unknown1010 = −1；
--    ECL_VM_SPAWN_THREAD 走 SpawnThread(−1, 0)），只有 callAsyncId(0, …) 才注册 id 0。
--    Boss1 循环尾那条 killAsync(0) 因此什么都不杀，这里也不写。
--  ★ 三个 Boss 的 moveLimit(0,96,280,64) 写在 Boss() 里（原作的「上一相残留状态」），
--    ECL 反汇编里看不到、也不属于任何一张卡的子程序 ⇒ 与 stage01/02 非符同样不搬。
--=====================================

---非符 3647　早苗（中 BOSS 非符）
---  MBoss：入场按自机左右选 x = −96 / +96（`pushf(%PLAYER_X2); pushi(0); lessf();
---  jmpEq(MBoss_636, 0)`：jmpEq「假才跳」⇒ %PLAYER_X2 ≥ 0 时跳去 −96 那一支），
---  再 movePosTime(60,4,0,128) 降到屏幕高度 128。
---  t=60 moveLimit(0,96,280,100)；t=80 取 %F0 = ANGLE_PLAYER 并出一只 MBossDummy；
---  t=550 起 180 帧一轮（jmp(MBoss_1148,730) 会立刻被 jmpNeq(…,550) 拨回 550）：
---    550 起异线程 MBossAt；610 moveRand(60,4,2.0)；670 异线程 MBossAt2 + moveRand；730 nop。
function s5.MBoss(o)
    local ct = 0
    if player.x < 0 then
        m_pos(o, "off", 96.0, -96.0)
    else
        m_pos(o, "off", -96.0, -96.0)
    end
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)
    t10_enm_kill_all(o)                           -- enmKillAll()
    ct = s_wait(ct, 60)                           -- //60
    m_limit(o, 0.0, 96.0, 280.0, 100.0)
    ct = s_wait(ct, 80)                           -- //80
    o.F0 = t10_angle_player(o)
    s_pod(o, 0.0, 0.0, s5.MBossDummy)             -- enmCreate("MBossDummy")
    ct = s_wait(ct, 200)                          -- //200
    ct = s_wait(ct, 290)                          -- //290
    ct = s_wait(ct, 550)                          -- //550
    ct = 550                                      -- jmp(MBoss_1148,730) ⇒ jmpNeq(…,550)
    while true do
        s_async(o, s5.MBossAt)                    -- callAsync("MBossAt")
        o.F0 = 2.019595
        ct = s_wait(ct, 610)                      -- //610
        m_rand(o, "off", 60, 4, 2.0)
        ct = s_wait(ct, 670)                      -- //670
        s_async(o, s5.MBossAt2)
        o.F0 = 1.121997
        m_rand(o, "off", 60, 4, 2.0)
        ct = s_wait(ct, 730)                      -- //730
        ct = 550
    end
end

---MBossDummy：绕 BOSS（世界坐标 + 极坐标偏移）半径 96 的旋臂子机。槽 0 主弹 + 槽 1 复制
---  （[!HL] 精灵 0 色 6）。外层 5 轮（[8]，%F0 每轮 +2.513274、movePosTime 20 帧），
---  内层 20 轮（[4]，1 帧一轮；[24] 每帧 −0.1309、[12] 每帧 −1）。
---  ★ noti($LUNATIC)：`pushi($LUNATIC); noti(); jmpEq(MBossDummy_1308,1)` ⇒ L 走 0.015 分支。
---  ★ ($DIFF≥1) or ([4]%2==0)：L 恒真 ⇒ 每帧都 etOn。
function s5.MBossDummy(o)
    local r28 = 96.0                              -- circlePos(…, 96.0f)
    local ang = o.F0
    local x, y = circle_pos(ang, r28)
    m_pos(o, "off", s_boss_x(o) + x, s_boss_y(o) + y)
    et_new(o, 0)
    et_aim(o, 0, 3)
    et_sprite(o, 0, 2, 6)
    et_count(o, 0, 5, 1)
    et_angle(o, 0, 0.0, 0.7853982)
    et_speed(o, 0, 0.001, 1.0)
    local p0 = o.pat[0]
    p0.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p0.ex[1] = tp_record(0, 8192, 100, -999999, -999999.0, -999999.0)
    p0.ex[2] = tp_record(0, 4096, 100, -999999, -999999.0, -999999.0)
    p0.ex[4] = tp_record(0, 64, 90, 1, 0.0, 0.0)
    et_angle(o, 0, t10_angle_player(o), 0.0)
    et_copy(o, 1, 0)                              -- etCopy(1, 0)
    et_sprite(o, 1, 0, 6)                         -- [!HL]
    local p1 = o.pat[1]
    local n12 = 120                               -- [12]
    local n8  = 5                                 -- [8]
    local ct  = 0
    n8 = n8 - 1                                   -- jmp(MBossDummy_1944,1) → deci([8])
    while true do
        ang = o.F0 + 2.513274                     -- MBossDummy_756（t=0）
        o.F0 = ang
        local x2, y2 = circle_pos(ang, r28)
        m_pos_time(o, "off", 20, 0, s_boss_x(o) + x2, s_boss_y(o) + y2)
        local n4  = 20                            -- [4]
        local a24 = ang                           -- [24] = %F0
        n4 = n4 - 1                               -- jmp(MBossDummy_1900,1) → deci([4])
        ct = 0
        while true do
            ct = s_wait(ct, 1)                    -- +1: //1
            p0.ex[5] = tp_record(0, 16, 90, -999999, 0.015, a24)   -- L 行
            p1.ex[5] = tp_record(0, 16, 60, -999999, 0.015, a24)
            a24 = t10_wrap(a24 - 0.1309)          -- validRad([24])
            p0.ex[3] = tp_record(0, 64, n12, 1, 0.0, 3.0)
            p1.ex[3] = tp_record(0, 64, n12, 1, 0.0, 3.0)
            fire_slot(o, 0)                       -- etOn(0)
            fire_slot(o, 1)                       -- etOn(1) [!HL]
            n12 = n12 - 1
            local old4 = n4; n4 = n4 - 1
            if old4 == 0 then break end           -- deci([4]) + jmpNeq(…,0)
            ct = 0
        end
        local old8 = n8; n8 = n8 - 1
        if old8 == 0 then break end               -- deci([8]) + jmpNeq(…,0)
        ct = 0
    end
    t10_delete(o)
end

---MBossAt / MBossAt2：每帧一发环绕弹，共 60 发（1 帧一发）。槽 0：5 发一圈、角速 0.7853982。
---  [4] 从 ANGLE_PLAYER 起每帧 ±0.019635（validRad）；[8] 从 1.0 起每帧 +0.1，
---  超过 2.0 就 −1.0（锯齿）。两处只差 [4] 的符号。
function s5.mboss_at(o, dir)
    et_new(o, 0)
    et_aim(o, 0, 3)
    et_sprite(o, 0, 3, 4)
    et_count(o, 0, 5, 1)
    et_angle(o, 0, 0.0, 0.7853982)
    et_speed(o, 0, 0.001, 1.0)
    local p = o.pat[0]
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(1, 1, -999999, -999999, -999999.0, -999999.0)
    local a4  = t10_angle_player(o)               -- [4] = %ANGLE_PLAYER
    local s8  = 1.0                               -- [8] = 1.0f
    local n0  = 60                                -- [0] = 60
    local ct  = 0
    n0 = n0 - 1                                   -- jmp(MBossAt_1040,1) → deci([0])
    ct = 0
    while true do                                 -- MBossAt_432（t=0）
        et_angle(o, 0, a4, 0.0)
        et_speed(o, 0, s8, 0.0)
        s8 = s8 + 0.1
        if s8 > 2.0 then s8 = s8 - 1.0 end
        a4 = t10_wrap(a4 + dir * 0.019635)        -- validRad([4])
        fire_slot(o, 0)                           -- ($DIFF≥1) or (%2==0) ⇒ L 每帧
        ct = s_wait(ct, 1)                        -- +1: //1
        local old = n0; n0 = n0 - 1
        if old == 0 then break end                -- deci([0]) + jmpNeq(…,0)
        ct = 0
    end
end
function s5.MBossAt(o)  return s5.mboss_at(o, 1) end
function s5.MBossAt2(o) return s5.mboss_at(o, -1) end

---非符 3648　神奈子（BOSS 非符 1）
---  Boss1：t=20 取 %F0 = ANGLE_PLAYER 并出 Boss1Dummy / Boss1Dummy2；
---  t=170 起 120 帧一轮：170 叫 at/at2 两个异线程（之后 diffWait(60,60,20,10) ⇒ L 等 10 帧），
---  230 moveRand(40,0,2.0)，290 nop（`killAsync(0)` 是 no-op，见本节开头）。
function s5.Boss1(o)
    local ct = 0
    ct = s_wait(ct, 20)                           -- //20
    o.F0 = t10_angle_player(o)
    s_pod(o, 0.0, 0.0, s5.Boss1Dummy)
    s_pod(o, 0.0, 0.0, s5.Boss1Dummy2)
    ct = s_wait(ct, 80)                           -- //80
    ct = s_wait(ct, 170)                          -- //170
    ct = ct - 10                                  -- diffWait(60,60,20,10) ⇒ L = 10
    ct = s_wait(ct, 170)                          -- jmp(Boss1_692,290) ⇒ jmpNeq(…,170)
    while true do
        s_async(o, s5.Boss1_at)                   -- callAsync("Boss1_at")
        s_async(o, s5.Boss1_at2)
        ct = s_wait(ct, 230)                      -- //230
        m_rand(o, "off", 40, 0, 2.0)
        ct = s_wait(ct, 290)                      -- //290
        ct = 170                                  -- jmpNeq(Boss1_520, 170)
    end
end

---Boss1Dummy / Boss1Dummy2：绕 BOSS（世界坐标 + 极坐标偏移）半径 64（L 行；E/N/H = 24/48/48）
---  的旋臂子机。外层 5 轮（[8]，%F0 每轮 ∓2.513274、movePosTime 10 帧），
---  内层 10 轮（[4]，1 帧一轮；[24] 每帧 ±0.06545、[12] 每帧 −1）。
---  ★ 外层第 k 轮与内层第 10k 帧同帧（内层 deci 不跳后直接落进 deci([8])，jmpNeq 把
---    clock 拨回 0、692 在 t=0 ⇒ 同帧执行）——所以 5 轮共占 50 帧。
function s5.boss1_dummy(o, aim, dir)
    local r28 = 64.0                              -- diffF([28], 24,48,48,64) ⇒ L
    local ang = o.F0
    local x, y = circle_pos(ang, r28)
    m_pos(o, "off", s_boss_x(o) + x, s_boss_y(o) + y)
    et_new(o, 0)
    et_aim(o, 0, aim)
    et_sprite(o, 0, 2, 6)
    et_count(o, 0, 5, 1)
    et_angle(o, 0, 0.0, 0.7853982)
    et_speed(o, 0, 0.001, 1.0)
    local p = o.pat[0]
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    p.ex[1] = tp_record(0, 8192, 100, -999999, -999999.0, -999999.0)
    p.ex[3] = tp_record(0, 64, 90, 1, 0.0, 0.0)
    et_angle(o, 0, t10_angle_player(o), 0.0)
    local n12 = 60                                -- [12]
    local n8  = 5                                 -- [8]
    local ct  = 0
    n8 = n8 - 1                                   -- jmp(Boss1Dummy_1540,1) → deci([8])
    while true do                                 -- Boss1Dummy_692（t=0）
        ang = o.F0 + dir * 2.513274
        o.F0 = ang
        local x2, y2 = circle_pos(ang, r28)
        m_pos_time(o, "off", 10, 0, s_boss_x(o) + x2, s_boss_y(o) + y2)
        local n4  = 10                            -- [4]
        local a24 = ang                           -- [24] = %F0
        n4 = n4 - 1                               -- jmp(Boss1Dummy_1496,1) → deci([4])
        ct = 0
        while true do                             -- Boss1Dummy_1048（t=1）
            ct = s_wait(ct, 1)                    -- +1: //1
            p.ex[4] = tp_record(0, 16, 90, -999999, 0.025, a24)    -- L 行
            a24 = t10_wrap(a24 + dir * 0.06545)   -- validRad([24])
            p.ex[2] = tp_record(0, 64, n12, 1, 0.0, 3.0)
            fire_slot(o, 0)                       -- etOn(0)
            n12 = n12 - 1
            local old4 = n4; n4 = n4 - 1
            if old4 == 0 then break end           -- deci([4]) + jmpNeq(…,0)
            ct = 0
        end
        local old8 = n8; n8 = n8 - 1
        if old8 == 0 then break end               -- deci([8]) + jmpNeq(…,0)
        ct = 0
    end
    t10_delete(o)
end
function s5.Boss1Dummy(o)  return s5.boss1_dummy(o, 3, 1) end
function s5.Boss1Dummy2(o) return s5.boss1_dummy(o, 5, -1) end

---Boss1_at / Boss1_at2：两支 600 帧的旋转环（20 轮 × 30 帧）。槽 0：L 行 10 发/轮。
---  at：角速 0.3926991、速度 3.2/2.5、[8] = π 起每轮 −0.261799；
---  at2：角速 −0.3926991、速度 3.5/2.5、[8] = 0 起每轮 +0.261799，且起手先 wait(15)。
---  两轮都在半径 64 的随机角（%RANDRAD）上写 etOffset（at2 是「先写角与 [8] 再 circlePos」）。
function s5.Boss1_at(o)
    et_new(o, 0)
    et_aim(o, 0, 3)
    et_sprite(o, 0, 2, 6)
    et_count(o, 0, 1, 10)                         -- etCountD(0,1,1,1,1,8,8,10,10) ⇒ L：c1=1、c2=10
    et_angle(o, 0, 0.0, 0.3926991)
    et_speed(o, 0, 3.2, 2.5)                      -- etSpeedD(…,1.5,1.5,1.5,2.5) ⇒ L
    local p = o.pat[0]
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    local a8  = 3.141593                          -- [8] = π
    local n12 = 20                                -- [12]
    local ct  = 0
    n12 = n12 - 1                                 -- jmp(Boss1_at_696,30) → deci([12])
    ct = 0
    while true do                                 -- Boss1_at_392（t=0）
        local x, y = circle_pos(rndrad(), 64.0)   -- circlePos([0],[4],%RANDRAD,64)
        et_offset(o, 0, x, y)
        et_angle(o, 0, a8, 0.028049935)           -- L 行
        a8 = t10_wrap(a8 - 0.261799)              -- validRad([8])
        fire_slot(o, 0)                           -- etOn(0)
        ct = s_wait(ct, 30)                       -- +30: //30
        local old = n12; n12 = n12 - 1
        if old == 0 then break end                -- deci([12]) + jmpNeq(…,0)
        ct = 0
    end
end

function s5.Boss1_at2(o)
    et_new(o, 0)
    et_aim(o, 0, 3)
    et_sprite(o, 0, 2, 6)
    et_count(o, 0, 1, 10)                         -- etCountD(0,1,1,1,1,8,8,10,10) ⇒ L：c1=1、c2=10
    et_angle(o, 0, 0.0, -0.3926991)
    et_speed(o, 0, 3.5, 2.5)                      -- etSpeedD(…,1.5,1.5,1.5,2.5) ⇒ L
    local p = o.pat[0]
    p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
    local a8  = 0.0                               -- [8] = 0.0f
    local n12 = 20                                -- [12]
    local ct  = 0
    ct = ct - 15                                  -- wait(15)
    ct = s_wait(ct, 0)                            -- 下一条在 t=0 ⇒ 等回 0
    n12 = n12 - 1                                 -- jmp(Boss1_at2_716,30) → deci([12])
    ct = 0
    while true do                                 -- Boss1_at2_412（t=0）
        et_angle(o, 0, a8, -0.028049935)          -- L 行
        a8 = t10_wrap(a8 + 0.261799)              -- validRad([8])
        local x, y = circle_pos(rndrad(), 64.0)
        et_offset(o, 0, x, y)
        fire_slot(o, 0)                           -- etOn(0)
        ct = s_wait(ct, 30)                       -- +30: //30
        local old = n12; n12 = n12 - 1
        if old == 0 then break end                -- deci([12]) + jmpNeq(…,0)
        ct = 0
    end
end

---非符 3649　神奈子（BOSS 非符 2）
---  Boss2：lifeSet(10400)；t=0 killAllAsync（停掉上一相留下的线程）；
---  t=120 叫 Boss2_at / Boss2_at2 两个异线程，之后 180 帧一轮：
---    「240 的 moveRand」被 jmpNeq(…,120) 拨回 120 ⇒ 每轮先等 120 帧再 moveRand、再等 60 帧。
function s5.Boss2(o)
    local ct = 0
    t10_kill_async(o)                             -- killAllAsync()
    ct = s_wait(ct, 120)                          -- //120
    s_async(o, s5.Boss2_at)                       -- callAsync("Boss2_at")
    s_async(o, s5.Boss2_at2)
    ct = 120                                      -- jmp(Boss2_748,300) ⇒ jmpNeq(…,120)
    while true do
        ct = s_wait(ct, 240)                      -- Boss2_704
        m_rand(o, "off", 40, 0, 2.0)
        ct = s_wait(ct, 300)                      -- //300
        ct = 120                                  -- jmpNeq(Boss2_704, 120)
    end
end

---Boss2_at：槽 0 的 8 连发环，每轮 140 帧（内含 8 × diffWait(…,10) 加收尾 diffWait(…,60)）。
---  [0] 每发 +0.19635、[8] 每轮 +1；L 行：8 发、角速 0.018925257、速度 2.8/2.4。
function s5.Boss2_at(o)
    local a0 = 0.0                                -- [0]
    et_offset(o, 0, 0.0, 0.0)
    local ct = 0
    while true do                                 -- Boss2_at_168（t=0）
        et_new(o, 0)
        et_aim(o, 0, 3)
        et_sprite(o, 0, 5, 6)
        et_count(o, 0, 8, 8)
        et_angle(o, 0, 1.5707964, 0.0)
        et_speed(o, 0, 2.8, 2.4)                  -- etSpeedD(…,1.4,1.4,1.4,2.4) ⇒ L
        local p = o.pat[0]
        p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
        local n4 = 8                              -- [4]
        n4 = n4 - 1                               -- jmp(Boss2_at_712,0) → deci([4])
        ct = 0
        while true do                             -- Boss2_at_536（t=0）
            et_angle(o, 0, a0, 0.018925257)
            fire_slot(o, 0)                       -- etOn(0)
            a0 = t10_wrap(a0 + 0.19635)           -- validRad([0])
            ct = ct - 10                          -- diffWait(30,20,10,10) ⇒ L = 10
            ct = s_wait(ct, 0)
            local old = n4; n4 = n4 - 1
            if old == 0 then break end            -- deci([4]) + jmpNeq(…,0)
            ct = 0
        end
        ct = ct - 60                              -- diffWait(120,120,90,60) ⇒ L = 60
        ct = s_wait(ct, 0)
    end
end

---Boss2_at2：槽 1 的同构环（精灵 5 色 2，反向）。★ diffWait 在**外层开头**（每轮先等 60 帧），
---  内层结束直接落回外层；L 行：8 发、角速 −0.018925257、速度 3.4/2.9。
function s5.Boss2_at2(o)
    local a0 = 0.0                                -- [0]
    et_offset(o, 1, 0.0, 0.0)
    local ct = 0
    while true do                                 -- Boss2_at2_168（t=0）
        ct = ct - 60                              -- diffWait(120,120,90,60) ⇒ L = 60
        ct = s_wait(ct, 0)
        et_new(o, 1)
        et_aim(o, 1, 3)
        et_sprite(o, 1, 5, 2)
        et_count(o, 1, 8, 8)
        et_angle(o, 1, 1.5707964, 0.0)
        et_speed(o, 1, 3.4, 2.9)                  -- etSpeedD(…,1.9,1.9,1.9,2.9) ⇒ L
        local p = o.pat[1]
        p.ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
        local n4 = 8                              -- [4]
        n4 = n4 - 1                               -- jmp(Boss2_at2_744,0) → deci([4])
        ct = 0
        while true do                             -- Boss2_at2_568（t=0）
            et_angle(o, 1, a0, -0.018925257)
            fire_slot(o, 1)                       -- etOn(1)
            a0 = t10_wrap(a0 - 0.19635)           -- validRad([0])
            ct = ct - 10                          -- diffWait(30,20,10,10) ⇒ L = 10
            ct = s_wait(ct, 0)
            local old = n4; n4 = n4 - 1
            if old == 0 then break end            -- deci([4]) + jmpNeq(…,0)
            ct = 0
        end
    end
end

---非符 3650　神奈子（BOSS 非符 3）
---  Boss3：lifeSet(10400)；t=0 killAllAsync；t=100 叫 Boss3_at / Boss3_at2，
---  之后 180 帧一轮（220 的 moveRand 被 jmpNeq(…,100) 拨回 100）。
function s5.Boss3(o)
    local ct = 0
    t10_kill_async(o)                             -- killAllAsync()
    ct = s_wait(ct, 100)                          -- //100
    s_async(o, s5.Boss3_at)                       -- callAsync("Boss3_at")
    s_async(o, s5.Boss3_at2)
    ct = 100                                      -- jmp(Boss3_748,280) ⇒ jmpNeq(…,100)
    while true do
        ct = s_wait(ct, 220)                      -- Boss3_704
        m_rand(o, "off", 40, 0, 1.0)
        ct = s_wait(ct, 280)                      -- //280
        ct = 100                                  -- jmpNeq(Boss3_704, 100)
    end
end

---Boss3_at / Boss3_at2：两支永不结束的 8 连发环，每发间隔 diffWait(30,20,15,11) ⇒ L = 11。
---  L 行：8 发、角速 ∓0.018925257、[0] 每发 ±0.19635、速度 at = 3.0/2.6、at2 = 3.6/3.1。
function s5.boss3_at(o, slot, dir, sp1, sp2, sprite_col)
    local a0 = 0.0                                -- [0]
    et_offset(o, slot, 0.0, 0.0)
    local ct = 0
    while true do                                 -- Boss3_at_128 / Boss3_at2_128（t=0）
        et_new(o, slot)
        et_aim(o, slot, 3)
        et_sprite(o, slot, 5, sprite_col)
        et_count(o, slot, 8, 8)                   -- etCountD(…, 8,8,8,8,8,8,8,8)
        et_angle(o, slot, 1.5707964, 0.0)
        et_speed(o, slot, sp1, sp2)               -- etSpeedD 的 L 行
        o.pat[slot].ex[0] = tp_record(1, 4, -999999, -999999, -999999.0, -999999.0)
        local n4 = 8                              -- [4]
        n4 = n4 - 1                               -- jmp(Boss3_at_620,0) → deci([4])
        ct = 0
        while true do                             -- Boss3_at_444（t=0）
            et_angle(o, slot, a0, dir * 0.018925257)
            fire_slot(o, slot)                    -- etOn(slot)
            a0 = t10_wrap(a0 - dir * 0.19635)     -- validRad([0])：at 是 +、at2 是 −（与 astep 反号）
            ct = ct - 11                          -- diffWait(30,20,15,11) ⇒ L = 11
            ct = s_wait(ct, 0)
            local old = n4; n4 = n4 - 1
            if old == 0 then break end            -- deci([4]) + jmpNeq(…,0)
            ct = 0
        end
    end
end
function s5.Boss3_at(o)  return s5.boss3_at(o, 0, -1, 3.0, 2.6, 6) end
function s5.Boss3_at2(o) return s5.boss3_at(o, 1,  1, 3.6, 3.1, 2) end
--=====================================
--八·H、stage01 / stage02 / stage05 的符卡注册（boss.card.add 必须晚于 boss.Define）
boss.Define("6a", "秋静葉", "TH10_2", TH10_bg, { 0, 80 }, nil, "Sizuha", LEVEL)
boss.Define("7a", "秋穣子", "TH10_2", TH10_bg, { 0, 80 }, nil, "Minoriko", LEVEL)
boss.Define("8a", "犬走椛", "TH10_2", TH10_bg, { 0, 80 }, nil, "Momizi", LEVEL)
boss.Define("9a", "東風谷早苗", "TH10_2", TH10_bg, { 0, 80 }, nil, "Sanae", LEVEL)

---stage01/02/05 十二张：{ 主 ECL 子程序, 卡名, 组, CARD_ID, t1秒, t2秒, t3秒, HP }
---  t3 = spell*(…, 时间, …) 的帧数 / 60（与 setInterrupt 的第三个参数一致）；
---  HP = 该卡开始时 BOSS 的 lifeSet：
---    stage01 中 BOSS 静葉 5850、穣子 8200；
---    stage02 中 BOSS 椛 2300、椛（BOSS）三张 13400（lifeSet(13400)）。
---  t1/t2 取该卡 ECL 里 setInvuln 的值（都是入场 60 帧 → 1/1）。
---  原作「厄符「バッドフォーチュン」」「疵符…」等 E/N 行不移植，只做 Lunatic。
local T10_CARDS_S125 = {
    ---stage01：静葉中 BOSS = 非符(4200)→葉符(1650)；穣子 = 非符1(6000)→秋符(2200)→
    ---  非符2(6000)→豊作(2200)。血量一律按原作「进场 life − 收尾阈值」。
    { s1.MBoss,      "",                              "6a", 3642, 1, 1, 1560 / 60, 4200, "stage01 中BOSS 非符" },
    { s1.MBossCard1, "葉符「狂いの落葉」",            "6a", 3630, 1, 1, 2160 / 60, 1650 },
    { s1.Boss1,      "",                              "7a", 3643, 1, 1, 2700 / 60, 6000, "stage01 非符一" },
    { s1.BossCard1,  "秋符「秋の空と乙女の心」",      "7a", 3631, 1, 1, 2700 / 60, 2200 },
    { s1.Boss2,      "",                              "7a", 3644, 1, 1, 2700 / 60, 6000, "stage01 非符二" },
    { s1.BossCard2,  "豊作「穀物神の約束」",          "7a", 3632, 1, 1, 2700 / 60, 2200 },
    { s2.MBossCard1, "厄符「厄神様のバイオリズム」", "8a", 3633, 1, 1, 2400 / 60, 2300 },
    ---Boss1 非符：进场 life 9000（Boss() 的 lifeSet）− 收尾阈值 2700 = 6300。
    { s2.Boss1,      "",                              "8a", 3645, 1, 1, 2700 / 60, 6300, "stage02 非符一" },
    ---疵痕、悲運、創符三张符卡的血量原写成 13400（= Boss2 的 lifeSet），按换卡规则
    ---  「进场 life − 收尾阈值」应为 2700 / 2700 / 2700。
    { s2.BossCard1,  "疵痕「壊されたお守り」",       "8a", 3634, 1, 1, 2700 / 60, 2700 },
    ---Boss2 非符：lifeSet(13400) − 收尾阈值 5400 = 8000。
    { s2.Boss2,      "",                              "8a", 3646, 1, 1, 2700 / 60, 8000, "stage02 非符二" },
    { s2.BossCard2,  "悲運「大鐘婆の火」",           "8a", 3635, 1, 1, 2700 / 60, 2700 },
    { s2.BossCard3,  "創符「流刑人形」",             "8a", 3636, 1, 1, 2700 / 60, 2700 },

    -- stage05（早苗 中BOSS 非符+符卡 / 神奈子 BOSS 三张非符 + 四张符卡）。
    --   符卡的 HP = 卡开始时 BOSS 的 lifeSet；非符的 HP = 一相「进场 life − 收尾阈值」：
    --     早苗 MBoss 12900 − 2900 = 10000；神奈子 Boss1 12400 − 2400 = 10000（沿用 Boss() 的 life）、
    --     Boss2 / Boss3 = 10400 − 2400 = 8000。t3 = setInterrupt 时限/60、t1/t2 = setInvuln/60。
    { s5.MBoss,      "",                              "9a", 3647, 200 / 60, 200 / 60, 2400 / 60, 10000, "stage05 中BOSS 非符" },
    { s5.MBossCard1, "秘術「一子相伝の弾幕」",       "9a", 3637, 200 / 60, 200 / 60, 2400 / 60, 12900 },
    { s5.Boss1,      "",                              "1a", 3648, 200 / 60, 200 / 60, 4200 / 60, 10000, "stage05 非符一" },
    { s5.BossCard1,  "奇跡「客星の明るすぎる夜」",   "1a", 3638, 90 / 60,  90 / 60,  4200 / 60, 12400 },
    { s5.Boss2,      "",                              "1a", 3649, 1,        1,        4200 / 60, 8000,  "stage05 非符二" },
    { s5.BossCard2,  "開海「モーゼの奇跡」",         "1a", 3639, 60 / 60,  60 / 60,  4200 / 60, 10400 },
    { s5.Boss3,      "",                              "1a", 3650, 100 / 60, 100 / 60, 4200 / 60, 8000,  "stage05 非符三" },
    { s5.BossCard3,  "準備「サモンタケミナカタ」",   "1a", 3640, 60 / 60,  60 / 60,  4200 / 60, 10400 },
    { s5.BossCard4,  "大奇跡「八坂の神風」",         "1a", 3641, 90 / 60,  90 / 60,  4200 / 60, 3000 },}

---★ 子机的 %BOSS_X / %BOSS_Y（原作 specialEnemySlots[0] 的世界坐标）走 t10_bossref：
---  主 BOSS 的载体在这里登记，s_pod 再把它复制给每一只子机。
for _, e in ipairs(T10_CARDS_S125) do
    local main, name, band, id, t1, t2, t3, hp = e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8]
    ---第 9 项 = 菜单名：非符的卡名必须是 ""（is_sc=false，不亮卡名），
    ---  但符卡练习菜单里还得有个名字 ⇒ 这两个字符串在非符上不是同一个。
    local menu = e[9] or name
    local c = boss.card.New(name, t1, t2, t3, hp)
    c.init = function(self)
        local p = t10_boss_start(self, main)
        p.t10_bossref = p
    end
    c.del = function(self) t10_clear_pods() end
    boss.card.add({ { c, band } }, LEVEL, menu, id)
end
