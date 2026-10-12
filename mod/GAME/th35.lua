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
        ch.ang = s.a0
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
---   TH10 的 enmCreate 会把创建者那 8 个 $I0..$I3 / %F0..%F3 整块拷给子机
---=====================================
local TH10_SUB = {}     -- 名字 → 协程体（下面每张卡的枪/使魔注册进来）

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

local function t10_enm_create_a(origin, name, x, y)
    local sub = TH10_SUB[name]
    if sub == nil then return nil end
    local o = New(class["th10_ecs_pod"], origin, x, y, sub)
    t10_track(o)
    return o
end
local function t10_enm_create(origin, name, dx, dy)
    return t10_enm_create_a(origin, name, origin.ecs.wx + dx, origin.ecs.wy + dy)
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
        ---BOSS 载体：把 BOSS 本体钉在 ECL 位置上。
        ---（守卫直接写在 self.th10_boss 上：T10 载体是可选绑定，字段审计据此判定 init 无赋值也安全。）
        if self.th10_boss and IsValid(self.th10_boss) then
            self.th10_boss.x, self.th10_boss.y = self.x, self.y
        end
    end,
})

---=====================================
--- 五、ECL 运行时辅助（时钟 / 全局变量 / 杂项 opcode）
---   ★ 时间语义（EclVm.cpp:695-800, 1218）：VM 每帧 `while (time <= clock) 执行`，
---     帧尾 clock += 1；`jmp(L, T)` / `jmpNeq(L, T)` **把 clock 直接赋成 T**（目标标签的
---     绝对时间），`wait(n)` 是 `clock -= n`。⇒ 同一时间组的指令在同一帧连续执行；只有
---     「下一条指令的时间 > clock」时才真正等待。下面 to/jp/wt 就是这三条语义。
---=====================================
local function t10_ecl()
    local c = 0
    return {
        ---普通指令在绝对时间 t：时钟不到就等到 t。（VM: while (instr.time <= clock)）
        to = function(t) if t > c then task.Wait(t - c); c = t end end,
        ---jmp / 条件跳转：**先**等到这条跳转指令自己的时间 own（它本身也受 while 条件约束），
        ---**再**把时钟赋成目标时间 dst（EclVm.cpp:797 currentTime = OperandInt(jmp,1)）。
        ---dst 可以小于 own（向后回跳），这正是「同帧重跑目标时间起的全部指令」的来源；
        ---wt(n) 之后跟的跳转也会在这里正确地等满（VM 会先被 while 条件挡住）。
        jp = function(own, dst)
            if own > c then task.Wait(own - c); c = own end
            c = dst
        end,
        ---wait(n)：时钟回拨 n（EclVm.cpp:802 currentTime -= ReadInt(0)）
        wt = function(n) c = c - n end,
    }
end

---随机数辅助（对应原作的 %RANDF / %RANDF2 / %RANDRAD / %RAND）
local function rnd() return ran:Float(0, 1) end          -- %RANDF
local function rnd2() return ran:Float(-1, 1) end        -- %RANDF2
local function rndrad() return ran:Float(-PI, PI) end    -- %RANDRAD
local function rand60() return ran:Int(0, 59) end        -- %RAND % 60

---原作 `delete`：子机自毁
---delete：敌机自毁，连同它名下所有 ECL 线程一起停掉（原作 delete 就是销毁该敌机）。
local function t10_delete(o) t10_kill_pod(o) end

---原作 `setTimeout` / `MBossEscape` / 观感类 anm/flag opcode：本仓库由符卡流程接管或忽略。
local function t10_flagset(o, f) end
local function t10_flagclear(o, f) end

---diffI / diffF：本仓库无难度系统，固定取第 4 项（Lunatic）。
local function dI(e, n, h, l) return l end
local function dF(e, n, h, l) return l end

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

---callAsync：在**同一敌机**上另起一个线程（共享 pattern 与全局变量）
local function t10_call_async(o, name)
    local sub = TH10_SUB[name]
    if sub then task.New(o, function() sub(o) end) end
end

---killAllAsync：原作 ECL_VM_STOP_ALL_THREADS 停掉本敌机的其它线程（保留当前）。
---THlib 的 task.Clear(o, true) 正好是「除当前协程外全部丢掉」。
local function t10_kill_async(o) task.Clear(o, true) end

---%ANGLE_PLAYER：从 **offsetMotion.position** 到自机的角度（Enemy.cpp:620）。
local function t10_angle_player(o) return t10_aim(o.ecs.wx, o.ecs.wy) end

---circlePos(&a, &b, angle, radius)：ECL_VM_POLAR_TO_CARTESIAN，写两个 float 变量。
local function t10_polar(ang, r) return circle_pos(ang, r) end

---=====================================
---TH10 stage03 / stage04 符卡移植（仅 Lunatic 行）
---  组 2a = stage03 中 BOSS 河城荷取（光学「ハイドロカモフラージュ」）
---  组 3a = stage03 BOSS    河城荷取（漂溺 / 水符 / 河童）
---  组 4a = stage04 BOSS    射命丸文（岐符 / 風神 / 無双風神 / 塞符）
---
---数据来源：thtk 的 thecl 原始反汇编
---        thecl -d 10 -r -m "MAP/th10.eclm" stage03.ecl out.txt
---        thecl -d 10 -r -m "MAP/th10.eclm" stage04.ecl out.txt
---  ＋ TH10 1.00a 复原源码逐条核对（src/EclVm.cpp / EnemyEclDispatcher.cpp /
---     Enemy.cpp / BulletManager.cpp / BulletTransform.cpp / BulletRuntime.cpp）。
---
---**本段不参考 mod/GAME/th10.lua**（那不是 ECL 实现）：下面的每一张卡都是把 thecl 反汇编
---的**每一条指令**按原样登记成 `v.i(绝对时间, "指令名", 操作数…)`，交给下面那张微型 VM 在
---「真实 VM 时序」下执行（语义与上面手写卡的 `t10_ecl` 的 to/jp/wt 完全相同）：
---    · 每条指令带绝对时间 `time`；VM 每帧 `while (time <= clock) 执行`，帧尾 `clock += 1`
---      （src/EclVm.cpp:693-1219）
---    · `jmp(L, T)` / `jmpEq` / `jmpNeq` 把 clock **直接赋成目标标签的绝对时间**（可回拨）
---    · `wait(n)` / `diffWait(…, L)` 是 `clock -= n`
---    · `deci(v)` 先把**旧值**压栈再 `v -= 1`；`jmpNeq(L, 0)` 弹到非 0 才跳 ⇒ 重复 v 次
---    · `seti/setf` 从栈弹值写变量；`addi/addf/…` 弹两个压结果
---    · 难度：rank 为 `*` / `-` / 含 L 的指令才在 Lunatic 下执行（生成时已过滤）
---    · `call(name)`：同线程、clock 归零；本段唯一的 call（Boss2Et_at2 → Boss2Et_at2h）
---      目标是**永不返回**的死循环，所以直接同步调用即可
---这样就不用手工推 wait/jmp/deci 的帧数，也能对着反汇编逐行核对。
---
---坐标：本段内部一律用**原作坐标**（x 以场地中心为 0、±192 = 左右边；y 从上往下 0..448），
---与上面 stage06 手写卡共用同一套 ecs 运行时（t10_oy / m_pos / et_* / t10_boss_start…）。
---=====================================


---=====================================
--- 六、TH10 ECL 微型 VM（逐条搬运 thecl 反汇编）
---  上面 stage06 那张卡是手写的；stage03 / stage04 这 8 张卡改用**逐条搬运**：
---  每一条 ECL 指令都按原样登记成 `v.i(时间, "指令名", 操作数…)`，由下面这张表在
---  「真实 VM 时序」下执行。这样做的好处是不用人工推 `wait` / `jmp` / `deci` 的帧数，
---  改起来也直接对着反汇编逐行核对。
---
---  时序按 src/EclVm.cpp:693-1219 的 `EclVmContext::Run` 复刻：
---    · 每帧 `while (指令.time <= clock) 执行;`，帧末尾 `clock += 1`
---    · `jmp(L,t)` / `jmpEq` / `jmpNeq` 把 clock **直接赋成目标标签的绝对时间**（可回拨）
---    · `wait(n)` 是 `clock -= n`（可负，负了之后要等 clock 涨回来）
---    · `deci(v)` 先把**旧值**压栈再 `v -= 1`；`jmpNeq(L,0)` 弹出旧值 ≠0 才跳 ⇒ 重复 N 次
---    · 难度过滤：rank 为 `*`/`-`/含 L 的指令才在 Lunatic 下执行（生成器已过滤）
---    · `call(name)`：同一线程、clock 归零跑子程序，`ret` 恢复调用者 clock
---      ——本文件里唯一的 `call` 目标（Boss2Et_at2h）**永不返回**，所以直接函数调用即可。
---  操作数：
---    · `LV(4)` = 本线程栈帧局部 `[4]`；`PP()` = 弹出临时栈（`[-1]`）；
---      `GV("I0")` / `GV("F0")` = 敌机自身变量（跨线程共享）
---=====================================
local function LV(off) return { r = "l", o = off } end
local function PP() return { r = "p" } end
local function GV(n) return { r = "g", n = n } end

---向零截断（C 的 (int) 转换 / int 除法）
local function t10_trunc(x)
    if x >= 0 then return math.floor(x) end
    return math.ceil(x)
end
local function t10_idiv(a, b)
    if b == 0 then return 0 end
    return t10_trunc(a / b)
end
---C 的 int % int：符号跟被除数
local function t10_imod(a, b)
    if b == 0 then return 0 end
    return math.fmod(a, b)
end

---%RAND（ECL 全局 -10000）= (int)g_EnemyRandom.GetU32()：32 位有符号
---（RandomMath.cpp GetRandomU32 = 两个 16 位结果拼起来）
local function t10_randmod()
    local hi = ran:Int(0, 65535)
    local lo = ran:Int(0, 65535)
    local u = hi * 65536 + lo
    if u >= 2147483648 then u = u - 4294967296 end
    return u
end

---ECL 全局变量读取（Enemy.cpp:434-... ReadIntOperand / ReadFloatOperand）
local function t10_gv(o, n)
    if n == "RANDF" then return rnd() end              -- -9999 GetUnitFloat ∈ [0,1]
    if n == "RANDF2" then return rnd2() end            -- -9987 GetSignedUnitFloat ∈ [-1,1]
    if n == "RANDRAD" then return rndrad() end         -- -9998 GetSignedUnitFloat·π
    if n == "RAND" then return t10_randmod() end       -- -10000 (int)GetU32()
    if n == "DIFF" then return 3 end                   -- -9959 难度：本仓库固定 Lunatic
    if n == "ANGLE_PLAYER" then return t10_angle_player(o) end  -- -9989 世界位置→自机角
    if n == "FINAL_ANGLE" then return 0 end            -- -9958 速度角（只喂给观感 stub）
    if n == "UNKNOWN61" then return 0 end              -- MBossOP 的动画状态（只喂给 stub）
    local c = n:sub(1, 1)
    if c == "I" or c == "F" then
        local k = tonumber(n:sub(2))
        if k ~= nil then return o[n] or 0 end
    end
    return 0
end

---读操作数（数字 / 局部 / 弹栈 / 全局）
local function t10_val(o, v, x)
    if type(x) ~= "table" then return x end
    if x.r == "l" then return v.loc[x.o] or 0 end
    if x.r == "p" then
        local t = v.temp
        local y = t[#t]
        t[#t] = nil
        return y or 0
    end
    return t10_gv(o, x.n)
end

---写操作数（只可能是局部或敌机变量）
local function t10_st(o, v, x, val)
    if type(x) ~= "table" then error("bad store") end
    if x.r == "l" then v.loc[x.o] = val return end
    if x.r == "g" then o[x.n] = val return end
    error("bad store")
end

---========== 指令实现 ==========
---每个 handler 返回：nil=继续；number=跳转到的下标；-1=结束本线程。
---（jmp 会把 clock 设成目标指令的时间，与 EclVm.cpp:797 一致）
local T10_OP = {}

local function pop2(v)
    local b = v.temp[#v.temp]; v.temp[#v.temp] = nil
    local a = v.temp[#v.temp]; v.temp[#v.temp] = nil
    return a or 0, b or 0
end
local function push(v, x) v.temp[#v.temp + 1] = x end

function T10_OP.pushi(o, v, a) push(v, t10_trunc(t10_val(o, v, a[1]))) end
function T10_OP.pushf(o, v, a) push(v, t10_val(o, v, a[1]) + 0.0) end
---seti / setf：从临时栈弹一个值写进目标（EclVm.cpp ECL_VM_STORE_*）
function T10_OP.seti(o, v, a)
    local t = v.temp local x = t[#t] t[#t] = nil
    t10_st(o, v, a[1], t10_trunc(x or 0))
end
function T10_OP.setf(o, v, a)
    local t = v.temp local x = t[#t] t[#t] = nil
    t10_st(o, v, a[1], (x or 0) + 0.0)
end
function T10_OP.deci(o, v, a)
    local old = t10_trunc(t10_val(o, v, a[1]))
    t10_st(o, v, a[1], old - 1)
    push(v, old)
end
function T10_OP.diffI(o, v, a)
    -- diffI(dst, E, N, H, L)：本仓库固定 Lunatic ⇒ 取第 4 个（a[5]）
    t10_st(o, v, a[1], t10_trunc(t10_val(o, v, a[5])))
end
function T10_OP.diffF(o, v, a)
    t10_st(o, v, a[1], t10_val(o, v, a[5]) + 0.0)
end
function T10_OP.diffWait(o, v, a)
    -- diffWait(E, N, H, L)（ECL_VM_SUBTRACT_TIME）：clock -= L
    v.ct = v.ct - t10_val(o, v, a[4])
end
function T10_OP.validRad(o, v, a)
    t10_st(o, v, a[1], t10_wrap(t10_val(o, v, a[1]) + 0.0))
end

local function arith_i(f)
    return function(o, v, a) local x, y = pop2(v); push(v, f(x, y)) end
end
local function arith_f(f)
    return function(o, v, a) local x, y = pop2(v); push(v, f(x, y)) end
end
T10_OP.addi = arith_i(function(x, y) return x + y end)
T10_OP.subi = arith_i(function(x, y) return x - y end)
T10_OP.muli = arith_i(function(x, y) return x * y end)
T10_OP.divi = arith_i(t10_idiv)
T10_OP.modi = arith_i(t10_imod)
T10_OP.eqi = arith_i(function(x, y) if x == y then return 1 end return 0 end)
T10_OP.neqi = arith_i(function(x, y) if x ~= y then return 1 end return 0 end)
T10_OP.lessi = arith_i(function(x, y) if x < y then return 1 end return 0 end)
T10_OP.leqi = arith_i(function(x, y) if x <= y then return 1 end return 0 end)
T10_OP.greateri = arith_i(function(x, y) if x > y then return 1 end return 0 end)
T10_OP.geqi = arith_i(function(x, y) if x >= y then return 1 end return 0 end)
T10_OP["or"] = arith_i(function(x, y) if x ~= 0 or y ~= 0 then return 1 end return 0 end)
T10_OP.addf = arith_f(function(x, y) return x + y end)
T10_OP.subf = arith_f(function(x, y) return x - y end)
T10_OP.mulf = arith_f(function(x, y) return x * y end)
T10_OP.divf = arith_f(function(x, y) if y == 0 then return 0 end return x / y end)
T10_OP.lessf = arith_f(function(x, y) if x < y then return 1 end return 0 end)
T10_OP.greaterf = arith_f(function(x, y) if x > y then return 1 end return 0 end)

---jmp / jmpEq / jmpNeq(label, T)：把 clock 设成**指令里的时间操作数 T**
---（= 目标标签的绝对时间；src/EclVm.cpp:797 `currentTime = OperandInt(*cursor, 1)`）。
---★ 不能用「目标下标那条指令的 time」代替：标签与下一条指令之间可能夹着被难度过滤掉的
---  nop / stackAlloc（时间不同），用下一条指令的时间会把 clock 拨错 —— MBossOP 会死循环
---  （`jmpEq(MBossOP_292, 0)`：标签处是 nop@1，时间操作数是 0，用 1 就一直跳不出去）。
local function do_jump(o, v, a)
    local ip = v.labels[a[1]]
    if ip == nil then error("th10 vm: unknown label " .. tostring(a[1])) end
    v.ct = t10_val(o, v, a[2]) + 0.0
    return ip
end
function T10_OP.jmp(o, v, a) return do_jump(o, v, a) end
---jmpEq / jmpNeq：从临时栈弹一个值，按 ==0 / ~=0 决定是否跳
---（EclVm.cpp ECL_VM_JUMP_IF_FALSE / _TRUE；操作数 (label, time) 里 time 只是显示）
local function pop1(v)
    local t = v.temp local x = t[#t] t[#t] = nil
    return t10_trunc(x or 0)
end
function T10_OP.jmpEq(o, v, a)
    if pop1(v) == 0 then return do_jump(o, v, a) end
end
function T10_OP.jmpNeq(o, v, a)
    if pop1(v) ~= 0 then return do_jump(o, v, a) end
end
function T10_OP.wait(o, v, a) v.ct = v.ct - t10_val(o, v, a[1]) end
function T10_OP.ret(o, v, a) return -1 end

function T10_OP.callAsync(o, v, a) t10_call_async(o, a[1]) end
function T10_OP.callAsyncId(o, v, a) t10_call_async(o, a[1]) end
function T10_OP.call(o, v, a)
    --- 唯一的 call 目标是 Boss2Et_at2h（无限循环、永不 ret）⇒ 直接同步调用即可；
    --- 要是有会返回的 call，这里得再实现「调用者 clock/PC 入栈、ret 恢复」。
    local f = TH10_SUB[a[1]]
    if f then f(o) end
end
function T10_OP.killAllAsync(o, v, a) t10_kill_async(o) end
function T10_OP.delete(o, v, a) t10_delete(o) return -1 end

---pattern 指令
function T10_OP.etNew(o, v, a) et_new(o, t10_trunc(t10_val(o, v, a[1]))) end
function T10_OP.etCopy(o, v, a)
    et_copy(o, t10_trunc(t10_val(o, v, a[1])), t10_trunc(t10_val(o, v, a[2])))
end
function T10_OP.etAim(o, v, a) et_aim(o, t10_trunc(t10_val(o, v, a[1])), t10_trunc(t10_val(o, v, a[2]))) end
function T10_OP.etSprite(o, v, a)
    et_sprite(o, t10_trunc(t10_val(o, v, a[1])), t10_trunc(t10_val(o, v, a[2])), t10_trunc(t10_val(o, v, a[3])))
end
function T10_OP.etCount(o, v, a)
    et_count(o, t10_trunc(t10_val(o, v, a[1])), t10_trunc(t10_val(o, v, a[2])), t10_trunc(t10_val(o, v, a[3])))
end
function T10_OP.etCountD(o, v, a)
    -- etCountD(slot, c1E,c1N,c1H,c1L, c2E,c2N,c2H,c2L)：Lunatic 取 c1L / c2L
    et_count(o, t10_trunc(t10_val(o, v, a[1])), t10_trunc(t10_val(o, v, a[5])), t10_trunc(t10_val(o, v, a[9])))
end
function T10_OP.etAngle(o, v, a)
    et_angle(o, t10_trunc(t10_val(o, v, a[1])), t10_val(o, v, a[2]) + 0.0, t10_val(o, v, a[3]) + 0.0)
end
function T10_OP.etSpeed(o, v, a)
    et_speed(o, t10_trunc(t10_val(o, v, a[1])), t10_val(o, v, a[2]) + 0.0, t10_val(o, v, a[3]) + 0.0)
end
function T10_OP.etSpeedD(o, v, a)
    -- etSpeedD(slot, sE,sN,sH,sL, tE,tN,tH,tL)：Lunatic 取 sL / tL
    et_speed(o, t10_trunc(t10_val(o, v, a[1])), t10_val(o, v, a[5]) + 0.0, t10_val(o, v, a[9]) + 0.0)
end
function T10_OP.etOffset(o, v, a)
    et_offset(o, t10_trunc(t10_val(o, v, a[1])), t10_val(o, v, a[2]) + 0.0, t10_val(o, v, a[3]) + 0.0)
end
function T10_OP.etEx(o, v, a)
    -- etEx(slot, rec, allow, kind, i0, i1, f0, f1)
    et_ex(o, t10_trunc(t10_val(o, v, a[1])), t10_trunc(t10_val(o, v, a[2])),
          t10_trunc(t10_val(o, v, a[3])), t10_trunc(t10_val(o, v, a[4])),
          t10_val(o, v, a[5]), t10_val(o, v, a[6]),
          t10_val(o, v, a[7]) + 0.0, t10_val(o, v, a[8]) + 0.0)
end
function T10_OP.etOn(o, v, a) et_on(o, t10_trunc(t10_val(o, v, a[1]))) end

---运动指令（世界位置 = base + offset；见 Enemy.cpp EnemyRuntimeUpdate）
function T10_OP.movePos(o, v, a) m_pos(o, "off", t10_val(o, v, a[1]) + 0.0, t10_val(o, v, a[2]) + 0.0) end
function T10_OP.movePosRel(o, v, a) m_pos(o, "base", t10_val(o, v, a[1]) + 0.0, t10_val(o, v, a[2]) + 0.0) end
function T10_OP.movePosTime(o, v, a)
    m_pos_time(o, "off", t10_trunc(t10_val(o, v, a[1])), t10_trunc(t10_val(o, v, a[2])),
               t10_val(o, v, a[3]) + 0.0, t10_val(o, v, a[4]) + 0.0)
end
function T10_OP.moveRand(o, v, a)
    m_rand(o, "off", t10_trunc(t10_val(o, v, a[1])), t10_trunc(t10_val(o, v, a[2])), t10_val(o, v, a[3]) + 0.0)
end
function T10_OP.moveCircleRel(o, v, a)
    m_circle(o, "base", t10_val(o, v, a[1]) + 0.0, t10_val(o, v, a[2]) + 0.0,
             t10_val(o, v, a[3]) + 0.0, t10_val(o, v, a[4]) + 0.0)
end
function T10_OP.moveLimitReset(o, v, a) m_limit_clear(o) end
function T10_OP.moveLimit(o, v, a)
    m_limit(o, t10_val(o, v, a[1]) + 0.0, t10_val(o, v, a[2]) + 0.0,
            t10_val(o, v, a[3]) + 0.0, t10_val(o, v, a[4]) + 0.0)
end

---circlePos(&x, &y, angle, radius)：极坐标 → 直角坐标（原作 y 向下）
function T10_OP.circlePos(o, v, a)
    local ang = t10_wrap(t10_val(o, v, a[3]) + 0.0)
    local r = t10_val(o, v, a[4]) + 0.0
    local x, y = circle_pos(ang, r)
    t10_st(o, v, a[1], x)
    t10_st(o, v, a[2], y)
end

function T10_OP.laserOnA(o, v, a)
    t10_laser_on(o, t10_trunc(t10_val(o, v, a[1])), t10_trunc(t10_val(o, v, a[2])),
                 t10_val(o, v, a[3]) + 0.0, t10_val(o, v, a[4]) + 0.0,
                 t10_val(o, v, a[5]) + 0.0, t10_val(o, v, a[6]) + 0.0,
                 t10_val(o, v, a[7]), t10_val(o, v, a[8]) + 0.0)
end

---子机生成：enmCreate 用**相对**位置、enmCreateA 用**绝对**位置
function T10_OP.enmCreate(o, v, a)
    t10_enm_create(o, a[1], t10_val(o, v, a[2]) + 0.0, t10_val(o, v, a[3]) + 0.0)
end
function T10_OP.enmCreateA(o, v, a)
    t10_enm_create_a(o, a[1], t10_val(o, v, a[2]) + 0.0, t10_val(o, v, a[3]) + 0.0)
end
---原作 enmKillAll 清的是「场上的敌机」（残留子机/使魔），发起这条指令的敌机自己不受影响
---（否则每张卡开头那条 `enmCreate("Ecl_EtBreak",…); enmKillAll()` 会当场把自己删掉，
---整张卡只跑第一帧 —— 这正是 2/5/7 号卡 0 弹的根因）。所以必须保留调用者。
function T10_OP.enmKillAll(o, v, a) t10_enm_kill_all(o) end

---观感 / 演出 / 流程类：本仓库由符卡框架接管，或纯视觉，按无效果处理
---（stage06 那张卡的差异 5/7 里同样的处理）
local function t10_noop(o, v, a) end
for _, n in ipairs({
    "anmPlay", "anmSetMain", "anmSetSprite", "anmSelectedPlay", "anmPlayRotate",
    "anmSelect", "anmSetSpriteMain",
    "flagSet", "flagClear", "playSound",
    "setChapter", "setInterrupt", "setTimeout", "setInvuln",
    "spellEx", "spell3", "spell", "spellEnd", "spellTimeout",
    "lifeSet", "lifeMarker", "stars", "timerReset", "lifeMarkerReset",
    "unknown363", "unknown364", "unknown369", "unknown370",
    "etCancel", "laserCancel", "dialogWait", "setBoss", "setHurtbox", "setHitbox",
    "setScreenShake", "nop",
}) do
    T10_OP[n] = t10_noop
end

---VM 本体
local function t10_vm(o)
    local v = { code = {}, labels = {}, loc = {}, temp = {}, ct = 0 }
    function v.i(t, m, ...)
        v.code[#v.code + 1] = { t = t, m = m, a = { ... } }
    end
    function v.label(n) v.labels[n] = #v.code + 1 end
    function v.run()
        local ip = 1
        while ip <= #v.code do
            local c = v.code[ip]
            if c.t > v.ct then
                task.Wait(c.t - v.ct)
                v.ct = c.t
            end
            local h = T10_OP[c.m]
            if h == nil then error("th10 vm: unknown opcode " .. tostring(c.m)) end
            local nx = h(o, v, c.a)
            if nx == -1 then return end
            if nx ~= nil then
                ---跳转：clock 已由 handler 设成目标时间，这里**不能**再覆盖。
                if nx > #v.code then return end
                ip = nx
            else
                ip = ip + 1
            end
        end
    end
    return v
end

TH10_SUB["s3_MBossCard1"] = function(o)
    local v = t10_vm(o)
    v.i(0, "setChapter", 15)
    v.i(0, "flagClear", 3)
    v.i(0, "setInvuln", 80)
    v.i(0, "playSound", 7)
    v.i(0, "spell3", 28, 2700, 1000000, "光学「ハイドロカモフラージュ」")
    v.i(0, "lifeMarker", 0, 2200.0, -24448)
    v.i(0, "enmKillAll")
    v.i(0, "callAsync", "s3_MBossOP")
    v.i(0, "setInterrupt", 0, 0, 2700, "s3_MBossDead")
    v.i(0, "setTimeout", 0, "MBossEscape")
    v.i(80, "anmPlay", 0, 409)
    v.i(80, "jmp", "s3_MBossCard1_600", 220)
    v.label("s3_MBossCard1_448")
    v.i(80, "callAsync", "s3_MBossCard1_at2h")
    v.i(80, "callAsync", "s3_MBossCard1_at")
    v.i(180, "moveRand", 40, 4, 4.0)
    v.label("s3_MBossCard1_600")
    v.i(220, "pushi", 1)
    v.i(220, "jmpNeq", "s3_MBossCard1_448", 80)
    v.i(220, "ret")
    v.run()
end

TH10_SUB["s3_MBossOP"] = function(o)
    local v = t10_vm(o)
    v.i(0, "jmp", "s3_MBossOP_308", 1)
    v.label("s3_MBossOP_60")
    v.i(0, "pushi", GV("UNKNOWN61"))
    v.i(0, "pushi", 7)
    v.i(0, "eqi")
    v.i(0, "pushi", GV("UNKNOWN61"))
    v.i(0, "pushi", 8)
    v.i(0, "eqi")
    v.i(0, "or")
    v.i(0, "jmpEq", "s3_MBossOP_292", 0)
    v.i(0, "pushi", GV("UNKNOWN61"))
    v.i(0, "pushi", 6)
    v.i(0, "addi")
    v.i(0, "anmPlay", 2, PP())
    v.label("s3_MBossOP_292")
    v.label("s3_MBossOP_308")
    v.i(1, "pushi", 1)
    v.i(1, "jmpNeq", "s3_MBossOP_60", 0)
    v.i(1, "ret")
    v.run()
end

TH10_SUB["s3_MBossCard1_at"] = function(o)
    local v = t10_vm(o)
    v.i(0, "diffF", LV(8), 0.3926991, 0.19634955, 0.14279966, 0.17453292)
    v.i(0, "diffI", LV(4), 4, 5, 11, 11)
    v.i(0, "pushi", 12)
    v.i(0, "seti", LV(0))
    v.i(0, "etNew", 0)
    v.i(0, "etNew", 0)
    v.i(0, "etAim", 0, 1)
    v.i(0, "etSprite", 0, 8, 6)
    v.i(0, "etCount", 0, LV(4), 1)
    v.i(0, "etAngle", 0, -1.5707964, LV(8))
    v.i(0, "etSpeed", 0, 3.0, 1.0)
    v.i(0, "etEx", 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "jmp", "s3_MBossCard1_at_548", 7)
    v.label("s3_MBossCard1_at_396")
    v.i(0, "etEx", 0, 1, 0, 32, 60, -999999, -0.02, 0.05235988)
    v.i(0, "etOn", 0)
    v.i(0, "etEx", 0, 1, 0, 32, 60, -999999, -0.02, -0.05235988)
    v.i(0, "etOn", 0)
    v.label("s3_MBossCard1_at_548")
    v.i(7, "deci", LV(0))
    v.i(7, "jmpNeq", "s3_MBossCard1_at_396", 0)
    v.i(7, "ret")
    v.run()
end

TH10_SUB["s3_MBossCard1_at2h"] = function(o)
    local v = t10_vm(o)
    v.i(0, "diffF", LV(12), 3.0, 3.0, 3.0, 2.0)
    v.i(0, "pushf", GV("RANDRAD"))
    v.i(0, "setf", LV(4))
    v.i(0, "diffI", LV(0), 2, 4, 8, 8)
    v.i(0, "etNew", 1)
    v.i(0, "etNew", 1)
    v.i(0, "etAim", 1, 3)
    v.i(0, "etSprite", 1, 18, 0)
    v.i(0, "etCount", 1, 20, 1)
    v.i(0, "etAngle", 1, LV(4), 0.19634955)
    v.i(0, "etSpeed", 1, LV(12), 1.0)
    v.i(0, "etEx", 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 1, 2, 0, 16, 60, -999999, 0.04, -999.0)
    v.i(0, "pushf", LV(4))
    v.i(0, "setf", LV(8))
    v.i(0, "jmp", "s3_MBossCard1_at2h_1012", 0)
    v.label("s3_MBossCard1_at2h_484")
    v.i(0, "etAngle", 1, LV(4), 0.19634955)
    v.i(0, "pushf", LV(4))
    v.i(0, "pushf", GV("RANDF"))
    v.i(0, "pushf", 3.1415927)
    v.i(0, "mulf")
    v.i(0, "pushi", 64)
    v.i(0, "divf")
    v.i(0, "addf")
    v.i(0, "setf", LV(4))
    v.i(0, "etEx", 1, 1, 0, 32, 60, -999999, -0.035, 0.05235988)
    v.i(0, "etOn", 1)
    v.i(0, "etAngle", 1, LV(8), 0.19634955)
    v.i(0, "pushf", LV(8))
    v.i(0, "pushf", GV("RANDF"))
    v.i(0, "pushf", 3.1415927)
    v.i(0, "mulf")
    v.i(0, "pushi", 64)
    v.i(0, "divf")
    v.i(0, "subf")
    v.i(0, "setf", LV(8))
    v.i(0, "etEx", 1, 1, 0, 32, 60, -999999, -0.035, -0.05235988)
    v.i(0, "etOn", 1)
    v.i(0, "wait", 20)
    v.label("s3_MBossCard1_at2h_1012")
    v.i(0, "deci", LV(0))
    v.i(0, "jmpNeq", "s3_MBossCard1_at2h_484", 0)
    v.i(0, "ret")
    v.run()
end

TH10_SUB["s3_BossCard1"] = function(o)
    local v = t10_vm(o)
    v.i(0, "diffF", LV(4), 0.2617994, 0.19634955, 0.19634955, 0.19634955)
    v.i(0, "pushi", 0)
    v.i(0, "setf", LV(8))
    v.i(0, "diffI", LV(16), 1, 9, 9, 9)
    v.i(0, "setChapter", 43)
    v.i(0, "setInterrupt", 0, 0, 3600, "s3_Boss2")
    v.i(0, "spellEx", 33, 3600, 1000000, "漂溺「光り輝く水底のトラウマ」")
    v.i(0, "killAllAsync")
    v.i(0, "movePosTime", 60, 4, 0.0, 128.0)
    v.i(0, "setInvuln", 60)
    v.i(0, "playSound", 7)
    v.i(0, "enmCreate", "s3_Ecl_EtBreak", 0.0, 0.0, 9999, 0, 0)
    v.i(0, "enmKillAll")
    v.i(0, "anmPlay", 0, 409)
    v.i(0, "anmSetMain", 0, 0)
    v.i(0, "pushi", 0)
    v.i(0, "seti", GV("I0"))
    v.i(0, "jmp", "s3_BossCard1_2700", 160)
    v.label("s3_BossCard1_668")
    v.i(0, "pushf", GV("RANDF"))
    v.i(0, "pushi", 32)
    v.i(0, "mulf")
    v.i(0, "setf", LV(0))
    v.i(0, "pushi", 8)
    v.i(0, "seti", LV(12))
    v.i(0, "jmp", "s3_BossCard1_2212", 40)
    v.label("s3_BossCard1_964")
    v.i(0, "pushf", 3.141593)
    v.i(0, "setf", GV("F0"))
    v.i(0, "pushi", 192)
    v.i(0, "pushi", 16)
    v.i(0, "addi")
    v.i(0, "pushf", LV(8))
    v.i(0, "addf")
    v.i(0, "enmCreateA", "s3_BossCard1AtH", PP(), LV(0), 50, 1000, 1)
    v.i(0, "pushi", 192)
    v.i(0, "pushi", 16)
    v.i(0, "addi")
    v.i(0, "pushf", LV(8))
    v.i(0, "addf")
    v.i(0, "enmCreateA", "s3_BossCard1AtH2", PP(), LV(0), 50, 1000, 1)
    v.i(0, "pushf", LV(0))
    v.i(0, "pushi", 32)
    v.i(0, "addf")
    v.i(0, "setf", LV(0))
    v.i(20, "pushf", 0.0)
    v.i(20, "setf", GV("F0"))
    v.i(20, "pushf", LV(8))
    v.i(20, "pushi", 192)
    v.i(20, "subf")
    v.i(20, "pushi", 16)
    v.i(20, "subi")
    v.i(20, "enmCreateA", "s3_BossCard1AtH", PP(), LV(0), 50, 1000, 1)
    v.i(20, "pushf", LV(8))
    v.i(20, "pushi", 192)
    v.i(20, "subf")
    v.i(20, "pushi", 16)
    v.i(20, "subi")
    v.i(20, "enmCreateA", "s3_BossCard1AtH2", PP(), LV(0), 50, 1000, 1)
    v.i(40, "pushf", LV(0))
    v.i(40, "pushi", 32)
    v.i(40, "addf")
    v.i(40, "setf", LV(0))
    v.label("s3_BossCard1_2212")
    v.i(40, "deci", LV(12))
    v.i(40, "jmpNeq", "s3_BossCard1_964", 0)
    v.i(40, "moveRand", 60, 4, 5.0)
    v.i(60, "etNew", 0)
    v.i(60, "etAim", 0, 0)
    v.i(60, "etSprite", 0, 12, 3)
    v.i(60, "etCount", 0, LV(16), 1)
    v.i(60, "etAngle", 0, 0.0, LV(4))
    v.i(60, "etSpeed", 0, 2.0, 1.0)
    v.i(60, "etEx", 0, 0, 1, 8, -999999, -999999, -999999.0, -999999.0)
    v.i(60, "etOn", 0)
    v.i(80, "etOn", 0)
    v.i(100, "etOn", 0)
    v.i(120, "etOn", 0)
    v.i(140, "etOn", 0)
    v.i(160, "etOn", 0)
    v.i(160, "pushi", GV("I0"))
    v.i(160, "pushi", 1)
    v.i(160, "addi")
    v.i(160, "seti", GV("I0"))
    v.label("s3_BossCard1_2700")
    v.i(160, "pushi", 1)
    v.i(160, "jmpNeq", "s3_BossCard1_668", 0)
    v.i(160, "ret")
    v.run()
end

TH10_SUB["s3_BossCard1AtH"] = function(o)
    local v = t10_vm(o)
    v.i(0, "pushi", 15)
    v.i(0, "seti", LV(4))
    v.i(0, "flagSet", 16)
    v.i(0, "flagSet", 132)
    v.i(0, "etNew", 0)
    v.i(0, "etAim", 0, 3)
    v.i(0, "etSprite", 0, 18, 0)
    v.i(0, "etCount", 0, 1, 1)
    v.i(0, "etAngle", 0, GV("F0"), 0.0)
    v.i(0, "etSpeed", 0, 1.3, 1.0)
    v.i(0, "etEx", 0, 0, 1, 2, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "pushi", GV("I0"))
    v.i(0, "pushi", 2)
    v.i(0, "modi")
    v.i(0, "pushi", 0)
    v.i(0, "eqi")
    v.i(0, "jmpEq", "s3_BossCard1AtH_700", 0)
    v.i(0, "etEx", 0, 1, 0, 8192, 320, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 0, 2, 0, 32, 60, -999999, 0.0, 0.01308997)
    v.i(0, "etEx", 0, 3, 0, 32, 120, -999999, 0.0, -0.01308997)
    v.i(0, "etEx", 0, 4, 0, 32, 120, -999999, 0.0, 0.01308997)
    v.i(0, "etEx", 0, 5, 0, 32, 60, -999999, 0.0, -0.01308997)
    v.i(0, "jmp", "s3_BossCard1AtH_940", 0)
    v.label("s3_BossCard1AtH_700")
    v.i(0, "etEx", 0, 1, 0, 8192, 320, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 0, 2, 0, 32, 60, -999999, 0.0, -0.01308997)
    v.i(0, "etEx", 0, 3, 0, 32, 120, -999999, 0.0, 0.01308997)
    v.i(0, "etEx", 0, 4, 0, 32, 120, -999999, 0.0, -0.01308997)
    v.i(0, "etEx", 0, 5, 0, 32, 60, -999999, 0.0, 0.01308997)
    v.label("s3_BossCard1AtH_940")
    v.i(0, "jmp", "s3_BossCard1AtH_1000", 20)
    v.label("s3_BossCard1AtH_964")
    v.i(0, "etOn", 0)
    v.label("s3_BossCard1AtH_1000")
    v.i(20, "deci", LV(4))
    v.i(20, "jmpNeq", "s3_BossCard1AtH_964", 0)
    v.i(20, "delete")
    v.run()
end

TH10_SUB["s3_BossCard1AtH2"] = function(o)
    local v = t10_vm(o)
    v.i(0, "pushi", 15)
    v.i(0, "seti", LV(4))
    v.i(0, "flagSet", 16)
    v.i(0, "flagSet", 132)
    v.i(0, "etNew", 0)
    v.i(0, "etAim", 0, 3)
    v.i(0, "etSprite", 0, 18, 0)
    v.i(0, "etCount", 0, 1, 1)
    v.i(0, "etAngle", 0, GV("F0"), 0.0)
    v.i(0, "etSpeed", 0, 1.3, 1.0)
    v.i(0, "etEx", 0, 0, 1, 2, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "pushi", GV("I0"))
    v.i(0, "pushi", 2)
    v.i(0, "modi")
    v.i(0, "pushi", 1)
    v.i(0, "eqi")
    v.i(0, "jmpEq", "s3_BossCard1AtH2_700", 0)
    v.i(0, "etEx", 0, 1, 0, 8192, 320, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 0, 2, 0, 32, 60, -999999, 0.0, 0.01308997)
    v.i(0, "etEx", 0, 3, 0, 32, 120, -999999, 0.0, -0.01308997)
    v.i(0, "etEx", 0, 4, 0, 32, 120, -999999, 0.0, 0.01308997)
    v.i(0, "etEx", 0, 5, 0, 32, 60, -999999, 0.0, -0.01308997)
    v.i(0, "jmp", "s3_BossCard1AtH2_940", 0)
    v.label("s3_BossCard1AtH2_700")
    v.i(0, "etEx", 0, 1, 0, 8192, 320, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 0, 2, 0, 32, 60, -999999, 0.0, -0.01308997)
    v.i(0, "etEx", 0, 3, 0, 32, 120, -999999, 0.0, 0.01308997)
    v.i(0, "etEx", 0, 4, 0, 32, 120, -999999, 0.0, -0.01308997)
    v.i(0, "etEx", 0, 5, 0, 32, 60, -999999, 0.0, 0.01308997)
    v.label("s3_BossCard1AtH2_940")
    v.i(0, "jmp", "s3_BossCard1AtH2_1000", 20)
    v.label("s3_BossCard1AtH2_964")
    v.i(0, "etOn", 0)
    v.label("s3_BossCard1AtH2_1000")
    v.i(20, "deci", LV(4))
    v.i(20, "jmpNeq", "s3_BossCard1AtH2_964", 0)
    v.i(20, "delete")
    v.run()
end

TH10_SUB["s3_BossCard2"] = function(o)
    local v = t10_vm(o)
    v.i(0, "setChapter", 44)
    v.i(0, "setInterrupt", 0, 0, 3600, "s3_Boss3")
    v.i(0, "spellEx", 37, 3600, 1000000, "水符「河童の幻想大瀑布」")
    v.i(0, "killAllAsync")
    v.i(0, "movePosTime", 60, 4, 0.0, 128.0)
    v.i(0, "setInvuln", 60)
    v.i(0, "playSound", 7)
    v.i(0, "enmCreate", "s3_Ecl_EtBreak", 0.0, 0.0, 9999, 0, 0)
    v.i(0, "enmKillAll")
    v.i(0, "anmSetMain", 0, 0)
    v.i(90, "pushi", GV("DIFF"))
    v.i(90, "pushi", 0)
    v.i(90, "neqi")
    v.i(90, "jmpEq", "s3_BossCard2_896", 95)
    v.i(90, "enmCreateA", "s3_Boss2Et_at2", 160.0, 0.0, 240, 1000, 0)
    v.i(91, "enmCreateA", "s3_Boss2Et_at2", 96.0, 0.0, 240, 1000, 0)
    v.i(92, "enmCreateA", "s3_Boss2Et_at2", 32.0, 0.0, 240, 1000, 0)
    v.i(93, "enmCreateA", "s3_Boss2Et_at2", -160.0, 0.0, 240, 1000, 0)
    v.i(94, "enmCreateA", "s3_Boss2Et_at2", -96.0, 0.0, 240, 1000, 0)
    v.i(95, "enmCreateA", "s3_Boss2Et_at2", -32.0, 0.0, 240, 1000, 0)
    v.i(95, "jmp", "s3_BossCard2_1052", 97)
    v.label("s3_BossCard2_896")
    v.i(95, "enmCreateA", "s3_Boss2Et_at2", 128.0, 0.0, 240, 1000, 0)
    v.i(96, "enmCreateA", "s3_Boss2Et_at2", 0.0, 0.0, 240, 1000, 0)
    v.i(97, "enmCreateA", "s3_Boss2Et_at2", -128.0, 0.0, 240, 1000, 0)
    v.label("s3_BossCard2_1052")
    v.i(97, "jmp", "s3_BossCard2_1136", 247)
    v.label("s3_BossCard2_1076")
    v.i(197, "moveRand", 50, 0, 2.0)
    v.label("s3_BossCard2_1136")
    v.i(247, "pushi", 1)
    v.i(247, "jmpNeq", "s3_BossCard2_1076", 97)
    v.i(247, "ret")
    v.run()
end

TH10_SUB["s3_Boss2Et_at2"] = function(o)
    local v = t10_vm(o)
    v.i(0, "pushi", 0)
    v.i(0, "seti", LV(8))
    v.i(0, "pushf", 2.356194)
    v.i(0, "setf", LV(4))
    v.i(0, "call", "s3_Boss2Et_at2h")
    v.i(0, "flagSet", 16)
    v.i(0, "flagSet", 132)
    v.i(0, "etNew", 0)
    v.i(0, "etAim", 0, 1)
    v.i(0, "etSprite", 0, 18, 0)
    v.i(0, "etCount", 0, 1, 1)
    v.i(0, "etAngle", 0, 1.5707964, 0.3926991)
    v.i(0, "etSpeed", 0, 1.0, 1.0)
    v.i(0, "jmp", "s3_Boss2Et_at2_1392", 5)
    v.label("s3_Boss2Et_at2_372")
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushi", 32)
    v.i(0, "mulf")
    v.i(0, "etOffset", 0, PP(), -12.0)
    v.i(0, "etAngle", 0, LV(4), 0.0)
    v.i(0, "pushi", LV(8))
    v.i(0, "pushi", 0)
    v.i(0, "eqi")
    v.i(0, "jmpEq", "s3_Boss2Et_at2_1140", 0)
    v.i(0, "pushf", LV(4))
    v.i(0, "pushf", 0.049087)
    v.i(0, "subf")
    v.i(0, "setf", LV(4))
    v.i(0, "pushf", LV(4))
    v.i(0, "pushf", 0.7853982)
    v.i(0, "lessf")
    v.i(0, "jmpEq", "s3_Boss2Et_at2_1116", 0)
    v.i(0, "pushi", 1)
    v.i(0, "seti", LV(8))
    v.label("s3_Boss2Et_at2_1116")
    v.i(0, "jmp", "s3_Boss2Et_at2_1336", 0)
    v.label("s3_Boss2Et_at2_1140")
    v.i(0, "pushf", LV(4))
    v.i(0, "pushf", 0.049087)
    v.i(0, "addf")
    v.i(0, "setf", LV(4))
    v.i(0, "pushf", LV(4))
    v.i(0, "pushf", 2.3561945)
    v.i(0, "greaterf")
    v.i(0, "jmpEq", "s3_Boss2Et_at2_1336", 0)
    v.i(0, "pushi", 0)
    v.i(0, "seti", LV(8))
    v.label("s3_Boss2Et_at2_1336")
    v.i(0, "etOn", 0)
    v.label("s3_Boss2Et_at2_1392")
    v.i(5, "pushi", 1)
    v.i(5, "jmpNeq", "s3_Boss2Et_at2_372", 0)
    v.i(5, "delete")
    v.run()
end

TH10_SUB["s3_Boss2Et_at2h"] = function(o)
    local v = t10_vm(o)
    v.i(0, "pushi", 0)
    v.i(0, "seti", LV(4))
    v.i(0, "pushf", 2.356194)
    v.i(0, "setf", LV(0))
    v.i(0, "flagSet", 16)
    v.i(0, "flagSet", 132)
    v.i(0, "etNew", 0)
    v.i(0, "etAim", 0, 1)
    v.i(0, "etSprite", 0, 18, 0)
    v.i(0, "etCount", 0, 1, 1)
    v.i(0, "etAngle", 0, 1.5707964, 0.3926991)
    v.i(0, "etSpeed", 0, 1.0, 1.0)
    v.i(0, "etEx", 0, 0, 0, 64, 60, 1, 0.0, 0.1)
    v.i(0, "etEx", 0, 1, 0, 32768, 60, -999999, -999999.0, -999999.0)
    v.i(0, "jmp", "s3_Boss2Et_at2h_1512", 0)
    v.label("s3_Boss2Et_at2h_432")
    v.i(0, "pushf", GV("RANDF"))
    v.i(0, "pushf", 0.03)
    v.i(0, "mulf")
    v.i(0, "pushf", 0.018)
    v.i(0, "addf")
    v.i(0, "etEx", 0, 2, 0, 16, 60, -999999, PP(), -999.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushi", 32)
    v.i(0, "mulf")
    v.i(0, "etOffset", 0, PP(), -12.0)
    v.i(0, "pushf", GV("RANDF"))
    v.i(0, "pushf", 0.4)
    v.i(0, "mulf")
    v.i(0, "pushf", 4.4)
    v.i(0, "addf")
    v.i(0, "etSpeed", 0, PP(), 0.0)
    v.i(0, "etAngle", 0, LV(0), 0.0)
    v.i(0, "pushi", LV(4))
    v.i(0, "pushi", 0)
    v.i(0, "eqi")
    v.i(0, "jmpEq", "s3_Boss2Et_at2h_1180", 0)
    v.i(0, "pushf", LV(0))
    v.i(0, "pushf", 0.02805)
    v.i(0, "subf")
    v.i(0, "setf", LV(0))
    v.i(0, "pushf", LV(0))
    v.i(0, "pushf", 0.7853982)
    v.i(0, "lessf")
    v.i(0, "jmpEq", "s3_Boss2Et_at2h_1156", 0)
    v.i(0, "pushi", 1)
    v.i(0, "seti", LV(4))
    v.label("s3_Boss2Et_at2h_1156")
    v.i(0, "jmp", "s3_Boss2Et_at2h_1452", 0)
    v.label("s3_Boss2Et_at2h_1180")
    v.i(0, "pushf", LV(0))
    v.i(0, "pushf", 0.02805)
    v.i(0, "addf")
    v.i(0, "setf", LV(0))
    v.i(0, "pushf", LV(0))
    v.i(0, "pushf", 2.3561945)
    v.i(0, "greaterf")
    v.i(0, "jmpEq", "s3_Boss2Et_at2h_1452", 0)
    v.i(0, "pushi", 0)
    v.i(0, "seti", LV(4))
    v.label("s3_Boss2Et_at2h_1452")
    v.i(0, "etOn", 0)
    v.i(0, "wait", 5)
    v.label("s3_Boss2Et_at2h_1512")
    v.i(0, "pushi", 1)
    v.i(0, "jmpNeq", "s3_Boss2Et_at2h_432", 0)
    v.i(0, "ret")
    v.run()
end

TH10_SUB["s3_BossCard3L"] = function(o)
    local v = t10_vm(o)
    v.i(0, "diffI", LV(24), 16, 32, 32, 32)
    v.i(0, "setChapter", 45)
    v.i(0, "setInterrupt", 1, 0, 3600, "s3_BossDead")
    v.i(0, "spellEx", 41, 3600, 1000000, "河童「スピン・ザ・セファリックプレート」")
    v.i(0, "killAllAsync")
    v.i(0, "movePosTime", 60, 4, 0.0, 128.0)
    v.i(0, "setInvuln", 60)
    v.i(0, "playSound", 7)
    v.i(0, "enmCreate", "s3_Ecl_EtBreak", 0.0, 0.0, 9999, 0, 0)
    v.i(0, "enmKillAll")
    v.i(0, "anmSetMain", 0, 0)
    v.i(60, "anmPlay", 0, 409)
    v.i(120, "anmSetMain", 0, 0)
    v.i(120, "pushi", 0)
    v.i(120, "setf", GV("F0"))
    v.i(120, "pushf", 0.02618)
    v.i(120, "setf", GV("F1"))
    v.i(120, "pushf", 3.141593)
    v.i(120, "setf", LV(0))
    v.i(120, "pushi", 0)
    v.i(120, "seti", LV(16))
    v.i(120, "pushi", 0)
    v.i(120, "setf", LV(12))
    v.i(120, "pushi", 1)
    v.i(120, "seti", LV(20))
    v.i(120, "callAsync", "s3_BossCard3L_at2")
    v.i(120, "jmp", "s3_BossCard3L_980", 420)
    v.label("s3_BossCard3L_740")
    v.i(120, "pushf", 0.008727)
    v.i(120, "setf", GV("F0"))
    v.i(120, "callAsync", "s3_BossCard3L_at")
    v.i(180, "moveRand", 70, 4, 3.0)
    v.i(270, "pushf", -0.008727)
    v.i(270, "setf", GV("F0"))
    v.i(270, "callAsync", "s3_BossCard3L_at")
    v.i(330, "moveRand", 70, 4, 3.0)
    v.label("s3_BossCard3L_980")
    v.i(420, "pushi", 1)
    v.i(420, "jmpNeq", "s3_BossCard3L_740", 120)
    v.i(420, "ret")
    v.run()
end

TH10_SUB["s3_BossCard3L_at"] = function(o)
    local v = t10_vm(o)
    v.i(0, "pushf", 4.0)
    v.i(0, "setf", LV(16))
    v.i(0, "pushi", 3)
    v.i(0, "seti", LV(12))
    v.i(0, "pushf", GV("ANGLE_PLAYER"))
    v.i(0, "pushf", 3.1415927)
    v.i(0, "pushf", 2.0)
    v.i(0, "divf")
    v.i(0, "addf")
    v.i(0, "setf", LV(8))
    v.i(0, "etNew", 0)
    v.i(0, "etAim", 0, 3)
    v.i(0, "etSprite", 0, 26, 10)
    v.i(0, "etCount", 0, 56, 1)
    v.i(0, "etAngle", 0, GV("RANDRAD"), 0.0)
    v.i(0, "etSpeed", 0, 1.3, 1.0)
    v.i(0, "etOffset", 0, 0.0, 0.0)
    v.i(0, "etEx", 0, 0, 1, 2, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 0, 1, 0, 8192, 400, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 0, 2, 0, 64, 60, 1, 0.0, 0.0)
    v.i(0, "etEx", 0, 3, 0, 32768, 60, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 0, 4, 0, 32, 180, -999999, 0.01, GV("F0"))
    v.i(0, "etCopy", 1, 0)
    v.i(0, "etEx", 1, 4, 0, 32, 180, -999999, 0.009, GV("F0"))
    v.i(0, "etAim", 1, 5)
    v.i(0, "jmp", "s3_BossCard3L_at_964", 10)
    v.label("s3_BossCard3L_at_772")
    v.i(0, "etSpeed", 0, LV(16), 0.0)
    v.i(0, "etOn", 0)
    v.i(0, "etSpeed", 1, LV(16), 0.0)
    v.i(0, "etOn", 1)
    v.i(0, "pushf", LV(16))
    v.i(0, "pushf", 0.5)
    v.i(0, "subf")
    v.i(0, "setf", LV(16))
    v.i(10, "validRad", LV(8))
    v.label("s3_BossCard3L_at_964")
    v.i(10, "deci", LV(12))
    v.i(10, "jmpNeq", "s3_BossCard3L_at_772", 0)
    v.i(10, "ret")
    v.run()
end

TH10_SUB["s3_BossCard3L_at2"] = function(o)
    local v = t10_vm(o)
    v.i(0, "pushf", 4.0)
    v.i(0, "setf", LV(16))
    v.i(0, "pushi", 3)
    v.i(0, "seti", LV(12))
    v.i(100, "pushf", GV("ANGLE_PLAYER"))
    v.i(100, "pushf", 3.1415927)
    v.i(100, "pushf", 2.0)
    v.i(100, "divf")
    v.i(100, "addf")
    v.i(100, "setf", LV(8))
    v.i(100, "etNew", 2)
    v.i(100, "etAim", 2, 0)
    v.i(100, "etSprite", 2, 24, 8)
    v.i(100, "etCount", 2, 1, 1)
    v.i(100, "etAngle", 2, GV("RANDRAD"), 0.0)
    v.i(100, "etSpeed", 2, 1.3, 1.0)
    v.i(100, "jmp", "s3_BossCard3L_at2_652", 100)
    v.label("s3_BossCard3L_at2_408")
    v.i(100, "pushf", GV("RANDRAD"))
    v.i(100, "pushf", 16.0)
    v.i(100, "divf")
    v.i(100, "etAngle", 2, PP(), 0.0)
    v.i(100, "pushf", GV("RANDF"))
    v.i(100, "pushf", 0.4)
    v.i(100, "mulf")
    v.i(100, "pushf", 1.0)
    v.i(100, "addf")
    v.i(100, "etSpeed", 2, PP(), 0.0)
    v.i(100, "etOn", 2)
    v.i(100, "wait", 3)
    v.label("s3_BossCard3L_at2_652")
    v.i(100, "pushi", 1)
    v.i(100, "jmpNeq", "s3_BossCard3L_at2_408", 100)
    v.i(100, "ret")
    v.run()
end

TH10_SUB["s4_BossCard1"] = function(o)
    local v = t10_vm(o)
    v.i(0, "diffF", LV(4), 0.2617994, 0.19634955, 0.19634955, 0.19634955)
    v.i(0, "pushi", 0)
    v.i(0, "setf", LV(8))
    v.i(0, "setChapter", 43)
    v.i(0, "setInterrupt", 0, 0, 3600, "s4_Boss2")
    v.i(0, "spell3", 44, 3600, 1000000, "岐符「サルタクロス」")
    v.i(0, "killAllAsync")
    v.i(0, "movePosTime", 60, 4, 0.0, 128.0)
    v.i(0, "setInvuln", 60)
    v.i(0, "playSound", 7)
    v.i(0, "enmCreate", "s4_Ecl_EtBreak", 0.0, 0.0, 9999, 0, 0)
    v.i(0, "enmKillAll")
    v.i(0, "anmPlay", 0, 409)
    v.i(0, "anmSetMain", 0, 0)
    v.i(0, "etNew", 0)
    v.i(0, "etAim", 0, 1)
    v.i(0, "etSprite", 0, 1, 0)
    v.i(0, "etCount", 0, 1, 1)
    v.i(0, "etAngle", 0, -1.5707964, 0.1308997)
    v.i(0, "etSpeed", 0, 1.0, 1.0)
    v.i(0, "etEx", 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "pushi", GV("DIFF"))
    v.i(0, "pushi", 1)
    v.i(0, "leqi")
    v.i(0, "jmpEq", "s4_BossCard1_840", 0)
    v.i(0, "etEx", 0, 1, 0, -2147483648, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "jmp", "s4_BossCard1_888", 0)
    v.label("s4_BossCard1_840")
    v.i(0, "etEx", 0, 1, 1, 2048, 1, -999999, -999999.0, -999999.0)
    v.label("s4_BossCard1_888")
    v.i(0, "etEx", 0, 2, 0, 4096, 60, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 0, 3, 0, 8192, 300, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 0, 4, 1, 64, 60, 1, 0.0, 0.0)
    v.i(0, "pushi", GV("DIFF"))
    v.i(0, "pushi", 2)
    v.i(0, "lessi")
    v.i(0, "jmpEq", "s4_BossCard1_1184", 0)
    v.i(0, "etEx", 0, 5, 0, 16384, 1, 6, -999999.0, -999999.0)
    v.i(0, "jmp", "s4_BossCard1_1232", 0)
    v.label("s4_BossCard1_1184")
    v.i(0, "etEx", 0, 5, 0, 16384, 1, 4, -999999.0, -999999.0)
    v.label("s4_BossCard1_1232")
    v.i(0, "jmp", "s4_BossCard1_2460", 120)
    v.label("s4_BossCard1_1256")
    v.i(0, "callAsync", "s4_BossCharge")
    v.i(0, "anmSetMain", 0, 0)
    v.i(0, "anmSelectedPlay", 0)
    v.i(0, "anmSetSprite", 0, 7)
    v.i(120, "anmSetSprite", 0, 5)
    v.i(120, "diffI", LV(12), 12, 32, 36, 48)
    v.i(120, "pushf", 1.963495)
    v.i(120, "setf", LV(28))
    v.i(120, "pushf", 5.497787)
    v.i(120, "setf", LV(32))
    v.i(120, "pushf", LV(32))
    v.i(120, "pushi", LV(12))
    v.i(120, "pushi", 1)
    v.i(120, "subi")
    v.i(120, "divf")
    v.i(120, "setf", LV(32))
    v.i(120, "jmp", "s4_BossCard1_2396", 120)
    v.label("s4_BossCard1_1632")
    v.i(120, "pushi", 6)
    v.i(120, "seti", LV(16))
    v.i(120, "pushf", 1.0)
    v.i(120, "setf", LV(24))
    v.i(120, "etAngle", 0, LV(28), 0.0)
    v.i(120, "pushf", LV(28))
    v.i(120, "pushf", LV(32))
    v.i(120, "addf")
    v.i(120, "setf", LV(28))
    v.i(120, "validRad", LV(28))
    v.i(120, "jmp", "s4_BossCard1_2352", 120)
    v.label("s4_BossCard1_1860")
    v.i(120, "pushi", GV("RAND"))
    v.i(120, "pushi", 60)
    v.i(120, "modi")
    v.i(120, "seti", LV(20))
    v.i(120, "pushi", LV(20))
    v.i(120, "pushi", 120)
    v.i(120, "addi")
    v.i(120, "seti", LV(20))
    v.i(120, "etSpeed", 0, LV(24), 0.0)
    v.i(120, "pushf", 1.5707964)
    v.i(120, "pushf", GV("RANDRAD"))
    v.i(120, "pushi", 8)
    v.i(120, "divf")
    v.i(120, "addf")
    v.i(120, "etEx", 0, 6, 0, 16, LV(20), -999999, 0.01, PP())
    v.i(120, "etOn", 0)
    v.i(120, "pushf", LV(24))
    v.i(120, "pushf", 1.0)
    v.i(120, "addf")
    v.i(120, "setf", LV(24))
    v.label("s4_BossCard1_2352")
    v.i(120, "deci", LV(16))
    v.i(120, "jmpNeq", "s4_BossCard1_1860", 120)
    v.label("s4_BossCard1_2396")
    v.i(120, "deci", LV(12))
    v.i(120, "jmpNeq", "s4_BossCard1_1632", 120)
    v.i(120, "wait", 180)
    v.label("s4_BossCard1_2460")
    v.i(120, "pushi", 1)
    v.i(120, "jmpNeq", "s4_BossCard1_1256", 0)
    v.i(120, "ret")
    v.run()
end

TH10_SUB["s4_BossCharge"] = function(o)
    local v = t10_vm(o)
    v.i(0, "playSound", 41)
    v.i(0, "pushf", -2.356194)
    v.i(0, "setf", GV("F0"))
    v.i(0, "pushf", 0.05236)
    v.i(0, "setf", GV("F1"))
    v.i(0, "pushi", 128)
    v.i(0, "setf", GV("F2"))
    v.i(0, "pushi", -2)
    v.i(0, "setf", GV("F3"))
    v.i(0, "pushi", 60)
    v.i(0, "seti", GV("I0"))
    v.i(0, "enmCreate", "s4_BossChargeP", -16.0, 16.0, 40, 10000, 1)
    v.i(0, "pushf", GV("F0"))
    v.i(0, "pushf", 1.570796)
    v.i(0, "addf")
    v.i(0, "setf", GV("F0"))
    v.i(0, "enmCreate", "s4_BossChargeP", -16.0, 16.0, 40, 10000, 1)
    v.i(0, "pushf", GV("F0"))
    v.i(0, "pushf", 1.570796)
    v.i(0, "addf")
    v.i(0, "setf", GV("F0"))
    v.i(0, "enmCreate", "s4_BossChargeP", -16.0, 16.0, 40, 10000, 1)
    v.i(0, "pushf", GV("F0"))
    v.i(0, "pushf", 1.570796)
    v.i(0, "addf")
    v.i(0, "setf", GV("F0"))
    v.i(0, "enmCreate", "s4_BossChargeP", -16.0, 16.0, 40, 10000, 1)
    v.i(0, "playSound", 41)
    v.i(0, "pushf", -1.570796)
    v.i(0, "setf", GV("F0"))
    v.i(0, "pushf", -0.05236)
    v.i(0, "setf", GV("F1"))
    v.i(0, "pushi", 144)
    v.i(0, "setf", GV("F2"))
    v.i(0, "pushi", -3)
    v.i(0, "setf", GV("F3"))
    v.i(0, "pushi", 60)
    v.i(0, "seti", GV("I0"))
    v.i(0, "enmCreate", "s4_BossChargeP2", -16.0, 16.0, 40, 10000, 1)
    v.i(0, "pushf", GV("F0"))
    v.i(0, "pushf", 1.570796)
    v.i(0, "addf")
    v.i(0, "setf", GV("F0"))
    v.i(0, "enmCreate", "s4_BossChargeP2", -16.0, 16.0, 40, 10000, 1)
    v.i(0, "pushf", GV("F0"))
    v.i(0, "pushf", 1.570796)
    v.i(0, "addf")
    v.i(0, "setf", GV("F0"))
    v.i(0, "enmCreate", "s4_BossChargeP2", -16.0, 16.0, 40, 10000, 1)
    v.i(0, "pushf", GV("F0"))
    v.i(0, "pushf", 1.570796)
    v.i(0, "addf")
    v.i(0, "setf", GV("F0"))
    v.i(0, "enmCreate", "s4_BossChargeP2", -16.0, 16.0, 40, 10000, 1)
    v.i(0, "ret")
    v.run()
end

TH10_SUB["s4_BossChargeP"] = function(o)
    local v = t10_vm(o)
    v.i(0, "moveCircleRel", GV("F0"), GV("F1"), GV("F2"), GV("F3"))
    v.i(0, "flagSet", 20)
    v.i(0, "pushi", GV("I0"))
    v.i(0, "pushi", 2)
    v.i(0, "divi")
    v.i(0, "seti", LV(4))
    v.i(0, "jmp", "s4_BossChargeP_232", 2)
    v.label("s4_BossChargeP_188")
    v.i(2, "anmPlayRotate", 1, 61, GV("FINAL_ANGLE"))
    v.label("s4_BossChargeP_232")
    v.i(2, "deci", LV(4))
    v.i(2, "jmpNeq", "s4_BossChargeP_188", 0)
    v.i(2, "delete")
    v.run()
end

TH10_SUB["s4_BossChargeP2"] = function(o)
    local v = t10_vm(o)
    v.i(0, "moveCircleRel", GV("F0"), GV("F1"), GV("F2"), GV("F3"))
    v.i(0, "flagSet", 20)
    v.i(0, "pushi", GV("I0"))
    v.i(0, "pushi", 2)
    v.i(0, "divi")
    v.i(0, "seti", LV(4))
    v.i(0, "jmp", "s4_BossChargeP2_232", 2)
    v.label("s4_BossChargeP2_188")
    v.i(2, "anmPlayRotate", 1, 62, GV("FINAL_ANGLE"))
    v.label("s4_BossChargeP2_232")
    v.i(2, "deci", LV(4))
    v.i(2, "jmpNeq", "s4_BossChargeP2_188", 0)
    v.i(2, "delete")
    v.run()
end

TH10_SUB["s4_BossCard2"] = function(o)
    local v = t10_vm(o)
    v.i(0, "setChapter", 44)
    v.i(0, "setInterrupt", 0, 0, 3600, "s4_Boss3")
    v.i(0, "spellEx", 49, 3600, 1000000, "風神「二百十日」")
    v.i(0, "killAllAsync")
    v.i(0, "movePosTime", 60, 4, 0.0, 128.0)
    v.i(0, "setInvuln", 300)
    v.i(0, "playSound", 7)
    v.i(0, "enmCreate", "s4_Ecl_EtBreak", 0.0, 0.0, 9999, 0, 0)
    v.i(0, "enmKillAll")
    v.i(0, "callAsync", "s4_BossCharge")
    v.i(0, "anmSetMain", 0, 0)
    v.i(0, "anmSelectedPlay", 0)
    v.i(0, "anmSetSprite", 0, 7)
    v.i(120, "anmSetSprite", 0, 5)
    v.i(120, "diffI", LV(8), 10, 16, 16, 16)
    v.i(120, "etNew", 0)
    v.i(120, "etAim", 0, 3)
    v.i(120, "etSprite", 0, 3, 10)
    v.i(120, "etCount", 0, LV(8), 1)
    v.i(120, "etAngle", 0, -1.5707964, 0.1308997)
    v.i(120, "etSpeed", 0, 6.0, 1.0)
    v.i(120, "etEx", 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    v.i(120, "etEx", 0, 1, 0, 32, 120, -999999, -0.025, 0.05235988)
    v.i(120, "etEx", 0, 2, 0, 8192, 120, -999999, -999999.0, -999999.0)
    v.i(120, "etCopy", 1, 0)
    v.i(120, "etEx", 1, 1, 0, 32, 120, -999999, -0.025, -0.06283186)
    v.i(120, "etSprite", 1, 3, 8)
    v.i(120, "etSprite", 1, 3, 6)
    v.i(120, "jmp", "s4_BossCard2_2508", 184)
    v.label("s4_BossCard2_1048")
    v.i(120, "etAngle", 0, GV("RANDRAD"), 0.0)
    v.i(120, "etAngle", 1, GV("RANDRAD"), 0.0)
    v.i(120, "pushi", 30)
    v.i(120, "seti", LV(4))
    v.i(120, "pushi", 0)
    v.i(120, "setf", LV(0))
    v.i(120, "jmp", "s4_BossCard2_2300", 124)
    v.label("s4_BossCard2_1208")
    v.i(120, "pushi", GV("DIFF"))
    v.i(120, "pushi", 3)
    v.i(120, "lessi")
    v.i(120, "jmpEq", "s4_BossCard2_1664", 120)
    v.i(120, "pushf", 3.1415927)
    v.i(120, "pushi", 60)
    v.i(120, "divf")
    v.i(120, "pushf", GV("RANDRAD"))
    v.i(120, "pushf", LV(0))
    v.i(120, "mulf")
    v.i(120, "addf")
    v.i(120, "etEx", 0, 1, 0, 32, 120, -999999, -0.0375, PP())
    v.i(120, "pushf", -3.1415927)
    v.i(120, "pushi", 60)
    v.i(120, "divf")
    v.i(120, "pushf", GV("RANDRAD"))
    v.i(120, "pushf", LV(0))
    v.i(120, "mulf")
    v.i(120, "addf")
    v.i(120, "etEx", 1, 1, 0, 32, 120, -999999, -0.0375, PP())
    v.i(120, "jmp", "s4_BossCard2_2016", 120)
    v.label("s4_BossCard2_1664")
    v.i(120, "pushf", 3.1415927)
    v.i(120, "pushi", 60)
    v.i(120, "divf")
    v.i(120, "pushf", GV("RANDRAD"))
    v.i(120, "pushf", LV(0))
    v.i(120, "mulf")
    v.i(120, "addf")
    v.i(120, "etEx", 0, 1, 0, 32, 120, -999999, -0.029166667, PP())
    v.i(120, "pushf", -3.1415927)
    v.i(120, "pushi", 60)
    v.i(120, "divf")
    v.i(120, "pushf", GV("RANDRAD"))
    v.i(120, "pushf", LV(0))
    v.i(120, "mulf")
    v.i(120, "addf")
    v.i(120, "etEx", 1, 1, 0, 32, 120, -999999, -0.029166667, PP())
    v.label("s4_BossCard2_2016")
    v.i(120, "etOn", 0)
    v.i(120, "etOn", 1)
    v.i(124, "pushf", LV(0))
    v.i(124, "pushf", 2e-05)
    v.i(124, "addf")
    v.i(124, "setf", LV(0))
    v.i(124, "pushf", LV(0))
    v.i(124, "pushf", 1e-05)
    v.i(124, "addf")
    v.i(124, "setf", LV(0))
    v.label("s4_BossCard2_2300")
    v.i(124, "deci", LV(4))
    v.i(124, "jmpNeq", "s4_BossCard2_1208", 120)
    v.i(184, "callAsync", "s4_BossCharge")
    v.i(184, "anmSetMain", 0, 0)
    v.i(184, "anmSelectedPlay", 0)
    v.i(184, "anmSetSprite", 0, 7)
    v.i(184, "wait", 40)
    v.i(184, "anmSetSprite", 0, 5)
    v.label("s4_BossCard2_2508")
    v.i(184, "pushi", 1)
    v.i(184, "jmpNeq", "s4_BossCard2_1048", 120)
    v.i(184, "ret")
    v.run()
end

TH10_SUB["s4_BossCard3"] = function(o)
    local v = t10_vm(o)
    v.i(0, "diffI", LV(24), 16, 32, 32, 32)
    v.i(0, "lifeSet", 2301)
    v.i(0, "lifeMarker", 0, 2301.0, -24448)
    v.i(0, "stars", 0)
    v.i(0, "timerReset")
    v.i(0, "setChapter", 45)
    v.i(0, "setInterrupt", 0, 2300, 1080, "s4_BossCard4")
    v.i(0, "spellEx", 52, 1080, 1000000, "「無双風神」")
    v.i(0, "spellTimeout")
    v.i(0, "killAllAsync")
    v.i(0, "movePosTime", 60, 4, 0.0, 128.0)
    v.i(0, "setInvuln", 1080)
    v.i(0, "playSound", 7)
    v.i(0, "enmCreate", "s4_Ecl_EtBreak", 0.0, 0.0, 9999, 0, 0)
    v.i(0, "enmKillAll")
    v.i(0, "moveLimitReset")
    v.i(60, "anmPlay", 0, 409)
    v.i(60, "movePosTime", 40, 1, -448.0, 320.0)
    v.i(150, "unknown363")
    v.i(150, "etNew", 1)
    v.i(150, "etAim", 1, 1)
    v.i(150, "etSprite", 1, 3, 10)
    v.i(150, "etCount", 1, 1, 1)
    v.i(150, "pushf", -1.5707964)
    v.i(150, "pushf", GV("RANDRAD"))
    v.i(150, "pushf", 0.1)
    v.i(150, "mulf")
    v.i(150, "addf")
    v.i(150, "etAngle", 1, PP(), 0.0)
    v.i(150, "pushf", 1.0)
    v.i(150, "pushf", GV("RANDF2"))
    v.i(150, "pushf", 0.3)
    v.i(150, "mulf")
    v.i(150, "addf")
    v.i(150, "etSpeed", 1, PP(), 1.0)
    v.i(150, "etEx", 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    v.i(150, "etEx", 1, 1, 0, 16, 60, -999999, 0.05, 1.5707964)
    v.i(150, "callAsyncId", "s4_BossCard3_at", 0)
    v.i(150, "playSound", 7)
    v.i(150, "pushf", 128.0)
    v.i(150, "pushf", GV("RANDF2"))
    v.i(150, "pushf", 128.0)
    v.i(150, "mulf")
    v.i(150, "addf")
    v.i(150, "movePos", -384.0, PP())
    v.i(150, "pushf", 128.0)
    v.i(150, "pushf", GV("RANDF2"))
    v.i(150, "pushf", 128.0)
    v.i(150, "mulf")
    v.i(150, "addf")
    v.i(150, "movePosTime", 50, 0, 384.0, PP())
    v.i(150, "etAngle", 1, -1.2707963, 0.0)
    v.i(210, "pushf", 128.0)
    v.i(210, "pushf", GV("RANDF2"))
    v.i(210, "pushf", 128.0)
    v.i(210, "mulf")
    v.i(210, "addf")
    v.i(210, "movePos", 384.0, PP())
    v.i(210, "pushf", 128.0)
    v.i(210, "pushf", GV("RANDF2"))
    v.i(210, "pushf", 128.0)
    v.i(210, "mulf")
    v.i(210, "addf")
    v.i(210, "movePosTime", 45, 0, -384.0, PP())
    v.i(210, "playSound", 15)
    v.i(210, "etAngle", 1, -1.8707963, 0.0)
    v.i(265, "playSound", 15)
    v.i(265, "pushf", 128.0)
    v.i(265, "pushf", GV("RANDF2"))
    v.i(265, "pushf", 128.0)
    v.i(265, "mulf")
    v.i(265, "addf")
    v.i(265, "movePos", -384.0, PP())
    v.i(265, "pushf", 128.0)
    v.i(265, "pushf", GV("RANDF2"))
    v.i(265, "pushf", 128.0)
    v.i(265, "mulf")
    v.i(265, "addf")
    v.i(265, "movePosTime", 40, 0, 384.0, PP())
    v.i(265, "etAngle", 1, -1.2707963, 0.0)
    v.i(315, "pushf", 128.0)
    v.i(315, "pushf", GV("RANDF2"))
    v.i(315, "pushf", 128.0)
    v.i(315, "mulf")
    v.i(315, "addf")
    v.i(315, "movePos", 384.0, PP())
    v.i(315, "pushf", 128.0)
    v.i(315, "pushf", GV("RANDF2"))
    v.i(315, "pushf", 128.0)
    v.i(315, "mulf")
    v.i(315, "addf")
    v.i(315, "movePosTime", 35, 0, -384.0, PP())
    v.i(315, "playSound", 15)
    v.i(315, "etAngle", 1, -1.8707963, 0.0)
    v.i(360, "playSound", 15)
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePos", -384.0, PP())
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePosTime", 30, 0, 384.0, PP())
    v.i(360, "etAngle", 1, -1.2707963, 0.0)
    v.i(360, "diffWait", 40, 40, 35, 35)
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePos", 384.0, PP())
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePosTime", 35, 0, -384.0, PP())
    v.i(360, "playSound", 15)
    v.i(360, "etAngle", 1, -1.8707963, 0.0)
    v.i(360, "diffWait", 35, 35, 30, 22)
    v.i(360, "playSound", 15)
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePos", -384.0, PP())
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePosTime", 20, 0, 384.0, PP())
    v.i(360, "etAngle", 1, -1.2707963, 0.0)
    v.i(360, "diffWait", 30, 30, 25, 18)
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePos", 384.0, PP())
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePosTime", 15, 0, -384.0, PP())
    v.i(360, "playSound", 15)
    v.i(360, "etAngle", 1, -1.8707963, 0.0)
    v.i(360, "diffWait", 25, 25, 20, 15)
    v.i(360, "playSound", 15)
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePos", -384.0, PP())
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePosTime", 15, 0, 384.0, PP())
    v.i(360, "etAngle", 1, -1.2707963, 0.0)
    v.i(360, "diffWait", 20, 20, 18, 12)
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePos", 384.0, PP())
    v.i(360, "pushf", 128.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 128.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePosTime", 10, 0, -384.0, PP())
    v.i(360, "playSound", 15)
    v.i(360, "etAngle", 1, -1.8707963, 0.0)
    v.i(360, "unknown364", 1)
    v.i(360, "diffWait", 15, 15, 13, 10)
    v.i(360, "etOffset", 0, 0.0, 0.0)
    v.i(360, "killAllAsync")
    v.i(360, "jmp", "s4_BossCard3_5188", 360)
    v.label("s4_BossCard3_4496")
    v.i(360, "enmCreate", "s4_BossCard3_at2", 0.0, 0.0, 0, 0, 0)
    v.i(360, "pushf", 96.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 96.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePos", -384.0, PP())
    v.i(360, "pushf", GV("RANDRAD"))
    v.i(360, "pushi", 16)
    v.i(360, "divf")
    v.i(360, "laserOnA", 3, 2, PP(), 60.0, 192.0, 800.0, 0, 32.0)
    v.i(360, "playSound", 15)
    v.i(360, "diffWait", 10, 10, 10, 5)
    v.i(360, "enmCreate", "s4_BossCard3_at3", 0.0, 0.0, 0, 0, 0)
    v.i(360, "pushf", 96.0)
    v.i(360, "pushf", GV("RANDF2"))
    v.i(360, "pushf", 96.0)
    v.i(360, "mulf")
    v.i(360, "addf")
    v.i(360, "movePos", 384.0, PP())
    v.i(360, "pushf", GV("RANDRAD"))
    v.i(360, "pushi", 16)
    v.i(360, "divf")
    v.i(360, "pushf", 3.1415927)
    v.i(360, "addf")
    v.i(360, "laserOnA", 3, 2, PP(), 60.0, 192.0, 800.0, 0, 32.0)
    v.i(360, "playSound", 15)
    v.i(360, "diffWait", 10, 10, 7, 5)
    v.label("s4_BossCard3_5188")
    v.i(360, "pushi", 1)
    v.i(360, "jmpNeq", "s4_BossCard3_4496", 360)
    v.i(360, "ret")
    v.run()
end

TH10_SUB["s4_BossCard3_at"] = function(o)
    local v = t10_vm(o)
    v.i(0, "jmp", "s4_BossCard3_at_592", 0)
    v.label("s4_BossCard3_at_60")
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 64.0)
    v.i(0, "mulf")
    v.i(0, "circlePos", GV("F0"), GV("F1"), GV("RANDRAD"), PP())
    v.i(0, "etOffset", 1, GV("F0"), GV("F1"))
    v.i(0, "pushf", 1.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 0.3)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "etSpeed", 1, PP(), 1.0)
    v.i(0, "etOn", 1)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 64.0)
    v.i(0, "mulf")
    v.i(0, "circlePos", GV("F0"), GV("F1"), GV("RANDRAD"), PP())
    v.i(0, "etOffset", 1, GV("F0"), GV("F1"))
    v.i(0, "pushf", 1.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 0.3)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "etSpeed", 1, PP(), 1.0)
    v.i(0, "etOn", 1)
    v.i(0, "wait", 1)
    v.label("s4_BossCard3_at_592")
    v.i(0, "pushi", 1)
    v.i(0, "jmpNeq", "s4_BossCard3_at_60", 0)
    v.i(0, "etOffset", 1, 0.0, 0.0)
    v.i(0, "ret")
    v.run()
end

TH10_SUB["s4_BossCard3_at2"] = function(o)
    local v = t10_vm(o)
    v.i(0, "pushi", 6)
    v.i(0, "seti", LV(4))
    v.i(0, "flagSet", 144)
    v.i(0, "pushf", 128.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 128.0)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "movePos", 192.0, PP())
    v.i(0, "pushf", 128.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 128.0)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "movePosTime", LV(4), 0, -192.0, PP())
    v.i(0, "etNew", 1)
    v.i(0, "etAim", 1, 1)
    v.i(0, "etSprite", 1, 3, 10)
    v.i(0, "etCount", 1, 1, 1)
    v.i(0, "pushf", -1.5707964)
    v.i(0, "pushf", GV("RANDRAD"))
    v.i(0, "pushf", 0.3)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "etAngle", 1, PP(), 0.0)
    v.i(0, "pushf", 1.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 0.3)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "etSpeed", 1, PP(), 1.0)
    v.i(0, "etEx", 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 1, 1, 0, 16, 60, -999999, 0.05, 1.5707964)
    v.i(0, "jmp", "s4_BossCard3_at2_1564", 0)
    v.label("s4_BossCard3_at2_1032")
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 64.0)
    v.i(0, "mulf")
    v.i(0, "circlePos", GV("F0"), GV("F1"), GV("RANDRAD"), PP())
    v.i(0, "etOffset", 1, GV("F0"), GV("F1"))
    v.i(0, "pushf", 1.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 0.3)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "etSpeed", 1, PP(), 1.0)
    v.i(0, "etOn", 1)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 64.0)
    v.i(0, "mulf")
    v.i(0, "circlePos", GV("F0"), GV("F1"), GV("RANDRAD"), PP())
    v.i(0, "pushf", 1.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 0.3)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "etSpeed", 1, PP(), 1.0)
    v.i(0, "etOffset", 1, GV("F0"), GV("F1"))
    v.i(0, "etOn", 1)
    v.i(0, "wait", 1)
    v.label("s4_BossCard3_at2_1564")
    v.i(0, "deci", LV(4))
    v.i(0, "jmpNeq", "s4_BossCard3_at2_1032", 0)
    v.i(0, "delete")
    v.run()
end

TH10_SUB["s4_BossCard3_at3"] = function(o)
    local v = t10_vm(o)
    v.i(0, "pushi", 6)
    v.i(0, "seti", LV(4))
    v.i(0, "flagSet", 144)
    v.i(0, "pushf", 128.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 128.0)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "movePos", -192.0, PP())
    v.i(0, "pushf", 128.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 128.0)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "movePosTime", LV(4), 0, 192.0, PP())
    v.i(0, "etNew", 1)
    v.i(0, "etAim", 1, 1)
    v.i(0, "etSprite", 1, 3, 10)
    v.i(0, "etCount", 1, 1, 1)
    v.i(0, "pushf", -1.5707964)
    v.i(0, "pushf", GV("RANDRAD"))
    v.i(0, "pushf", 0.3)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "etAngle", 1, PP(), 0.0)
    v.i(0, "pushf", 1.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 0.3)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "etSpeed", 1, PP(), 1.0)
    v.i(0, "etEx", 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "etEx", 1, 1, 0, 16, 60, -999999, 0.05, 1.5707964)
    v.i(0, "jmp", "s4_BossCard3_at3_1564", 0)
    v.label("s4_BossCard3_at3_1032")
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 64.0)
    v.i(0, "mulf")
    v.i(0, "circlePos", GV("F0"), GV("F1"), GV("RANDRAD"), PP())
    v.i(0, "etOffset", 1, GV("F0"), GV("F1"))
    v.i(0, "pushf", 1.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 0.3)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "etSpeed", 1, PP(), 1.0)
    v.i(0, "etOn", 1)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 64.0)
    v.i(0, "mulf")
    v.i(0, "circlePos", GV("F0"), GV("F1"), GV("RANDRAD"), PP())
    v.i(0, "etOffset", 1, GV("F0"), GV("F1"))
    v.i(0, "pushf", 1.0)
    v.i(0, "pushf", GV("RANDF2"))
    v.i(0, "pushf", 0.3)
    v.i(0, "mulf")
    v.i(0, "addf")
    v.i(0, "etSpeed", 1, PP(), 1.0)
    v.i(0, "etOn", 1)
    v.i(0, "wait", 1)
    v.label("s4_BossCard3_at3_1564")
    v.i(0, "deci", LV(4))
    v.i(0, "jmpNeq", "s4_BossCard3_at3_1032", 0)
    v.i(0, "delete")
    v.run()
end

TH10_SUB["s4_BossCard4"] = function(o)
    local v = t10_vm(o)
    v.i(0, "lifeSet", 2300)
    v.i(0, "lifeMarker", 0, 2300.0, -24448)
    v.i(0, "killAllAsync")
    v.i(0, "enmKillAll")
    v.i(0, "pushi", GV("DIFF"))
    v.i(0, "pushi", 1)
    v.i(0, "geqi")
    v.i(0, "jmpEq", "s4_BossCard4_392", 0)
    v.i(0, "setInvuln", 90)
    v.i(0, "playSound", 7)
    v.i(0, "unknown364", 0)
    v.i(0, "spellEnd")
    v.i(0, "etCancel", 1024.0)
    v.i(0, "movePos", -216.0, 160.0)
    v.i(0, "movePosTime", 90, 4, 0.0, 128.0)
    v.i(0, "wait", 90)
    v.i(0, "jmp", "s4_BossCard4_476", 0)
    v.label("s4_BossCard4_392")
    v.i(0, "enmCreate", "s4_Ecl_EtBreak", 0.0, 0.0, 9999, 0, 0)
    v.i(0, "movePosTime", 90, 4, 0.0, 128.0)
    v.label("s4_BossCard4_476")
    v.i(0, "setChapter", 46)
    v.i(0, "setInterrupt", 0, 0, 4200, "s4_BossDead")
    v.i(0, "spellEx", 56, 4200, 1000000, "塞符「天上天下の照國」")
    v.i(0, "movePosTime", 60, 4, 0.0, 128.0)
    v.i(0, "setInvuln", 300)
    v.i(0, "callAsync", "s4_BossCharge")
    v.i(0, "anmSetMain", 0, 0)
    v.i(0, "anmSelectedPlay", 0)
    v.i(0, "anmSetSprite", 0, 7)
    v.i(120, "anmSetSprite", 0, 5)
    v.i(120, "callAsync", "s4_BossCard4_at")
    v.i(120, "callAsync", "s4_BossCard4_at2")
    v.i(120, "callAsync", "s4_BossCard4_at3")
    v.i(120, "jmp", "s4_BossCard4_1028", 120)
    v.label("s4_BossCard4_1008")
    v.i(120, "wait", 100)
    v.label("s4_BossCard4_1028")
    v.i(120, "pushi", 1)
    v.i(120, "jmpNeq", "s4_BossCard4_1008", 120)
    v.i(120, "ret")
    v.run()
end

TH10_SUB["s4_BossCard4_at"] = function(o)
    local v = t10_vm(o)
    v.i(0, "diffI", LV(4), 32, 64, 64, 64)
    v.i(0, "diffI", LV(0), 120, 120, 120, 80)
    v.i(0, "etNew", 0)
    v.i(0, "etAim", 0, 3)
    v.i(0, "etSprite", 0, 0, 10)
    v.i(0, "etCount", 0, LV(4), 1)
    v.i(0, "etAngle", 0, GV("RANDRAD"), 0.1308997)
    v.i(0, "etSpeed", 0, 1.0, 1.0)
    v.i(0, "etEx", 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "etSprite", 0, 3, 13)
    v.i(0, "etSpeed", 0, 2.0, 1.0)
    v.i(0, "jmp", "s4_BossCard4_at_616", 0)
    v.label("s4_BossCard4_at_392")
    v.i(0, "etAngle", 0, GV("RANDRAD"), 0.0)
    v.i(0, "etOn", 0)
    v.i(0, "wait", LV(0))
    v.i(0, "pushi", LV(0))
    v.i(0, "pushi", 40)
    v.i(0, "greateri")
    v.i(0, "jmpEq", "s4_BossCard4_at_616", 0)
    v.i(0, "pushi", LV(0))
    v.i(0, "pushi", 5)
    v.i(0, "subi")
    v.i(0, "seti", LV(0))
    v.label("s4_BossCard4_at_616")
    v.i(0, "pushi", 1)
    v.i(0, "jmpNeq", "s4_BossCard4_at_392", 0)
    v.i(0, "ret")
    v.run()
end

TH10_SUB["s4_BossCard4_at2"] = function(o)
    local v = t10_vm(o)
    v.i(0, "pushf", 1.570796)
    v.i(0, "setf", LV(0))
    v.i(0, "etNew", 1)
    v.i(0, "etAim", 1, 5)
    v.i(0, "etSprite", 1, 3, 6)
    v.i(0, "etCountD", 1, 8, 16, 16, 16, 1, 1, 1, 1)
    v.i(0, "etAngle", 1, LV(0), 0.1308997)
    v.i(0, "etSpeedD", 1, 2.0, 2.0, 3.0, 4.0, 1.0, 1.0, 1.0, 1.0)
    v.i(0, "etEx", 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "etSprite", 1, 7, 13)
    v.i(0, "jmp", "s4_BossCard4_at2_812", 0)
    v.label("s4_BossCard4_at2_408")
    v.i(0, "pushf", LV(0))
    v.i(0, "pushf", 0.021817)
    v.i(0, "addf")
    v.i(0, "setf", LV(0))
    v.i(0, "validRad", LV(0))
    v.i(0, "etAngle", 1, LV(0), 0.0)
    v.i(0, "etOn", 1)
    v.i(0, "diffWait", 22, 13, 11, 9)
    v.label("s4_BossCard4_at2_812")
    v.i(0, "pushi", 1)
    v.i(0, "jmpNeq", "s4_BossCard4_at2_408", 0)
    v.i(0, "ret")
    v.run()
end

TH10_SUB["s4_BossCard4_at3"] = function(o)
    local v = t10_vm(o)
    v.i(0, "pushf", 1.570796)
    v.i(0, "setf", LV(0))
    v.i(0, "etNew", 2)
    v.i(0, "etAim", 2, 5)
    v.i(0, "etSprite", 2, 3, 6)
    v.i(0, "etCountD", 2, 8, 16, 16, 16, 1, 1, 1, 1)
    v.i(0, "etAngle", 2, LV(0), 0.1308997)
    v.i(0, "etSpeedD", 2, 2.0, 2.0, 3.0, 4.0, 1.0, 1.0, 1.0, 1.0)
    v.i(0, "etEx", 2, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    v.i(0, "etSprite", 2, 7, 13)
    v.i(0, "jmp", "s4_BossCard4_at3_812", 0)
    v.label("s4_BossCard4_at3_408")
    v.i(0, "pushf", LV(0))
    v.i(0, "pushf", 0.021817)
    v.i(0, "subf")
    v.i(0, "setf", LV(0))
    v.i(0, "validRad", LV(0))
    v.i(0, "etAngle", 2, LV(0), 0.0)
    v.i(0, "etOn", 2)
    v.i(0, "diffWait", 22, 13, 11, 9)
    v.label("s4_BossCard4_at3_812")
    v.i(0, "pushi", 1)
    v.i(0, "jmpNeq", "s4_BossCard4_at3_408", 0)
    v.i(0, "ret")
    v.run()
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
---  CARD_ID 3601..3608（th35 的 3600 是 stage06 那张；注册完跑 check_stage.lua --all 核对）。
---=====================================
local T10_CARDS = {
    { "s3_MBossCard1", "光学「ハイドロカモフラージュ」",           "2a", 3601, 80 / 60, 80 / 60, 2700 / 60, 2200 },
    { "s3_BossCard1",  "漂溺「光り輝く水底のトラウマ」",           "3a", 3602, 1,       1,       3600 / 60, 8800 },
    { "s3_BossCard2",  "水符「河童の幻想大瀑布」",                 "3a", 3603, 1,       1,       3600 / 60, 8600 },
    { "s3_BossCard3L", "河童「スピン・ザ・セファリックプレート」", "3a", 3604, 1,       1,       3600 / 60, 8800 },
    { "s4_BossCard1",  "岐符「サルタクロス」",                     "4a", 3605, 1,       1,       3600 / 60, 9500 },
    { "s4_BossCard2",  "風神「二百十日」",                         "4a", 3606, 5,       5,       3600 / 60, 9500 },
    { "s4_BossCard3",  "「無双風神」",                             "4a", 3607, 18,      18,      1080 / 60, 2301 },
    { "s4_BossCard4",  "塞符「天上天下の照國」",                   "4a", 3608, 8,       8,       4200 / 60, 2300 },
}

for _, e in ipairs(T10_CARDS) do
    local subname, name, band, id, t1, t2, t3, hp = e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8]
    local c = boss.card.New(name, t1, t2, t3, hp)
    ---主 ECL 跑在 BOSS 的载体（th10_ecs_pod）上：每帧把 BOSS 钉在 ECL 位置上。
    ---（子程序表 TH10_SUB 在下面填好，运行时才查表。）
    c.init = function(self) t10_boss_start(self, TH10_SUB[subname]) end
    ---卡片结束时把本卡生成的枪/使魔载体一起清掉（原作靠 killAllAsync/enmKillAll + 敌机回收）。
    c.del = function(self) t10_clear_pods() end
    boss.card.add({ { c, band } }, LEVEL, name, id)
end
