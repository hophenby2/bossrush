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

local function s4_BossCharge(o)
    o.F0, o.F1, o.F2, o.F3, o.I0 = -2.356194, 0.05236, 128.0, -2, 60
    for _ = 1, 4 do
        spawn_pod_rel(o, -16.0, 16.0, s4_BossChargeP)
        o.F0 = o.F0 + 1.570796
    end
    o.F0, o.F1, o.F2, o.F3, o.I0 = -1.570796, -0.05236, 144.0, -3, 60
    for _ = 1, 4 do
        spawn_pod_rel(o, -16.0, 16.0, s4_BossChargeP)
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
---  CARD_ID 3601..3608（th35 的 3600 是 stage06 那张；注册完跑 check_stage.lua --all 核对）。
---=====================================
local T10_CARDS = {
    { s3_MBossCard1, "光学「ハイドロカモフラージュ」",           "2a", 3601, 80 / 60, 80 / 60, 2700 / 60, 2200 },
    { s3_BossCard1,  "漂溺「光り輝く水底のトラウマ」",           "3a", 3602, 1,       1,       3600 / 60, 8800 },
    { s3_BossCard2,  "水符「河童の幻想大瀑布」",                 "3a", 3603, 1,       1,       3600 / 60, 8600 },
    { s3_BossCard3L, "河童「スピン・ザ・セファリックプレート」", "3a", 3604, 1,       1,       3600 / 60, 8800 },
    { s4_BossCard1,  "岐符「サルタクロス」",                     "4a", 3605, 1,       1,       3600 / 60, 9500 },
    { s4_BossCard2,  "風神「二百十日」",                         "4a", 3606, 5,       5,       3600 / 60, 9500 },
    { s4_BossCard3,  "「無双風神」",                             "4a", 3607, 18,      18,      1080 / 60, 2301 },
    { s4_BossCard4,  "塞符「天上天下の照國」",                   "4a", 3608, 8,       8,       4200 / 60, 2300 },
}

for _, e in ipairs(T10_CARDS) do
    local main, name, band, id, t1, t2, t3, hp = e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8]
    local c = boss.card.New(name, t1, t2, t3, hp)
    ---主协程跑在 BOSS 的载体（th10_ecs_pod）上：每帧把 BOSS 钉在原作 ECL 的位置上。
    ---`main` 就是上面那张卡的**原生 Lua 主函数**（不再是 TH10_SUB 里的指令表）。
    c.init = function(self) t10_boss_start(self, main) end
    ---卡片结束时把本卡生成的枪/使魔载体一起清掉（原作靠 killAllAsync/enmKillAll + 敌机回收）。
    c.del = function(self) t10_clear_pods() end
    boss.card.add({ { c, band } }, LEVEL, name, id)
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
---  CARD_ID 3609..3621（th35 现有 3600..3608；注册完跑 check_stage.lua --all 核对不撞号）。
---=====================================
local T10_CARDS_EX = {
    { s7.MBossCard1, "神符「水眼の如き美しき源泉」",              "1a", 3609, 200 / 60, 200 / 60, 4200 / 60, 2300 },
    { s7.MBossCard2, "神符「杉で結ぶ古き縁」",                    "1a", 3610, 320 / 60, 320 / 60, 4200 / 60, 2300 },
    { s7.MBossCard3, "神符「神が歩かれた御神渡り」",              "1a", 3611, 150 / 60, 150 / 60, 4200 / 60, 2300 },
    { s7.BossCard1,  "開宴「二拝二拍一拝」",                      "5a", 3612, 90 / 60,  90 / 60,  6300 / 60, 2800 },
    { s7.BossCard2,  "土着神「手長足長さま」",                    "5a", 3613, 90 / 60,  90 / 60,  6300 / 60, 3600 },
    { s7.BossCard3,  "神具「洩矢の鉄の輪」",                      "5a", 3614, 60 / 60,  60 / 60,  6300 / 60, 2800 },
    { s7.BossCard4,  "源符「厭い川の翡翠」",                      "5a", 3615, 60 / 60,  60 / 60,  6300 / 60, 3600 },
    { s7.BossCard5,  "蛙狩「蛙は口ゆえ蛇に呑まるる」",            "5a", 3616, 60 / 60,  60 / 60,  6300 / 60, 3500 },
    { s7.BossCard6,  "土着神「七つの石と七つの木」",              "5a", 3617, 60 / 60,  60 / 60,  6300 / 60, 3500 },
    { s7.BossCard7,  "土着神「ケロちゃん風雨に負けず」",          "5a", 3618, 60 / 60,  60 / 60,  6300 / 60, 4500 },
    { s7.BossCard8,  "土着神「宝永四年の赤蛙」",                  "5a", 3619, 2400 / 60, 2400 / 60, 2400 / 60, 10000 },
    { s7.BossCard9,  "「諏訪大戦　～ 土着神話 vs 中央神話」",     "5a", 3620, 5040 / 60, 5040 / 60, 5040 / 60, 10000 },
    { s7.BossCard10, "祟符「ミシャグジさま」",                    "5a", 3621, 9600 / 60, 9600 / 60, 9600 / 60, 10000 },
}

for _, e in ipairs(T10_CARDS_EX) do
    local main, name, band, id, t1, t2, t3, hp = e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8]
    local c = boss.card.New(name, t1, t2, t3, hp)
    c.init = function(self) t10_boss_start(self, main) end
    c.del = function(self) t10_clear_pods() end
    boss.card.add({ { c, band } }, LEVEL, name, id)
end
