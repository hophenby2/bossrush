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
---  2  弹样式用本仓库最接近的原生贴图代理：原作 `etSprite(0, 6, $I0)` 的 type 6
---     对应 `square`。轮廓与颜色组对齐，但不是逐像素相同（见 `T10_STYLE`）。
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
local bullet = bullet

---TH10 `etSprite(type, color)` → 本项目原生弹样式。type 是原作 bullet type，
---color 是在该 type 的连续精灵帧里的色号。依据是 bullet.anm 的脚本起点
---`g_BulletSpriteScriptBase` 与各脚本主弹 `ins_3(spriteN)` 的轮廓/尺寸。
local T10_STYLE = {
    [0]  = ball_small,  [1]  = ball_mid_c, [2]  = ball_mid_c,
    [3]  = OriginalBulletVisual.style(ellipse, grain_a),     [4]  = arrow_small, [5] = grain_b,
    [6]  = square,      [7]  = arrow_big_c, [8] = grain_d,
    [9]  = grain_a,     [10] = OriginalBulletVisual.style(ellipse, grain_c),     [11] = star_small,
    [12] = ball_big,    [13] = ellipse,     [14] = OriginalBulletVisual.style(ellipse, knife),
    [15] = butterfly,   [16] = star_big,    [17] = ball_huge,
    [18] = OriginalBulletVisual.style(ball_light, water_drop),  [19] = ball_big,    [20] = ellipse,
    [21] = OriginalBulletVisual.style(ellipse, knife),     [22] = butterfly,   [23] = square,
    [24] = ball_small,  [25] = OriginalBulletVisual.style(ball_light, water_drop),  [26] = OriginalBulletVisual.style(ellipse, grain_a),
}

---本项目贴图统一是 16 行；这三张表把原作各色组的色号换成本项目行号。
local T10_C16 = { 16, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 11, 13, 16 }
local T10_C8  = { 16, 1, 3, 5, 7, 9, 11, 15 }
local T10_C4  = { 2, 3, 10, 12 } -- type17 原图：红、紫、绿、黄
local T10_C3  = { 16, 1, 2 }
---色号上限来自连续脚本数：type 12–16/19–22 为 8 色，17 为 4 色，23 为 3 色；
---18/25 是单帧固定色（蓝/红），其余为 16 色。
local T10_COLOR_COUNT = {
    [0]=16, [1]=16, [2]=16, [3]=16, [4]=16, [5]=16, [6]=16, [7]=16,
    [8]=16, [9]=16, [10]=16, [11]=16, [12]=8, [13]=8, [14]=8, [15]=8,
    [16]=8, [17]=4, [18]=1, [19]=8, [20]=8, [21]=8, [22]=8, [23]=3,
    [24]=16, [25]=1, [26]=16,
}
local T10_FIXED_COLOR = { [18] = 6, [25] = 2 } -- type18 原图蓝、type25 原图红

local function t10_style(t)
    t = math.floor(tonumber(t) or 0)
    return T10_STYLE[t] or ball_small
end

local function t10_color(i, t)
    t = math.floor(tonumber(t) or 0)
    local fixed = T10_FIXED_COLOR[t]
    if fixed then return fixed end
    i = math.floor(tonumber(i) or 0)
    if i < 0 then i = 0 end
    local n = T10_COLOR_COUNT[t] or 16
    if i >= n then i = n - 1 end
    local map = T10_C16
    if n == 8 then map = T10_C8
    elseif n == 4 then map = T10_C4
    elseif n == 3 then map = T10_C3 end
    return map[i + 1]
end

---===== 原作常量（stage06.ecl BossCard5，Lunatic 行）=====
local CARD_NAME = "「風神様の神徳」"
local LEVEL = 33                    -- = core.lua 的 STAGE_COUNT + 1，见文件末尾的注册清单
---符卡历史槽位（spell_card_data 的键，也是符卡练习的解锁 id），跨关卡唯一。
---选址实测（`luajit tools/check_stage.lua --all`）：th34 占 3400..3407、th31 占
---3409/3410（它的 id 写在 LIST 表第 3 项里，光扫 `boss.card.add` 末参会漏掉），
---3408/3411/3480 都已被占 —— 本关取 3600。改这个数一定要重跑 --all。
local CARD_ID = 3600
local MAX_LIFE = 8200               -- 原作 lifeSet(8200)（差异 9）

--- 有限血量卡按“原作所有自机形态中最快的活跃 TTK × 移植版灵梦 DPS(115.5)”重算；
--- 保护窗口仍由 t1/t2 单独实现，不重复扣进 HP。耐久卡不在此表。
local TH35_REIMU_HP = {
    [ 3601] =  941, [ 3660] =  549, [ 3602] =  984, [ 3661] =  549,
    [ 3603] =  898, [ 3662] =  549, [ 3604] =  984, [ 3670] =  844,
    [ 3663] =  591, [ 3605] = 1069, [ 3664] =  591, [ 3606] = 1069,
    [ 3665] =  591, [ 3608] =  984, [ 3651] =  591, [ 3609] =  984,
    [ 3610] =  984, [ 3611] =  984, [ 3652] =  675, [ 3612] = 1198,
    [ 3653] =  675, [ 3613] = 1540, [ 3654] =  675, [ 3614] = 1198,
    [ 3655] =  675, [ 3615] = 1540, [ 3656] =  675, [ 3616] = 1497,
    [ 3657] =  675, [ 3617] = 1497, [ 3658] =  675, [ 3618] = 1925,
    [ 3659] =  675, [ 3666] =  760, [ 3667] =  760, [ 3668] =  844,
    [ 3669] =  760, [ 3622] = 1069, [ 3623] = 1069, [ 3624] = 1241,
    [ 3625] = 1369, [ 3642] =  355, [ 3630] =  706, [ 3643] =  507,
    [ 3631] =  941, [ 3644] =  507, [ 3632] =  941, [ 3633] =  984,
    [ 3645] =  532, [ 3634] = 1155, [ 3646] =  675, [ 3635] = 1155,
    [ 3636] = 1155, [ 3647] =  844, [ 3637] = 1241, [ 3648] =  844,
    [ 3638] = 1027, [ 3649] =  675, [ 3639] = 1027, [ 3650] =  675,
    [ 3640] = 1027, [ 3641] = 1283, [ 3619] = 4278, [ 3620] = 4278,
    [ 3621] = 4278, [ 3600] = 3508,
}

---弹（BossCard5_atN / at2 共用）
local BULLET_TYPE = 6               -- 原作 etSprite(0, 6, $I0) 的 type 6 → `square`
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
    local b = NewSimpleBullet(t10_style(BULLET_TYPE), t10_color(color, BULLET_TYPE), x, y,
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

local card = boss.card.New(CARD_NAME, 2.5, 2.5, 151.5,
                           TH35_REIMU_HP[CARD_ID] or MAX_LIFE)

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
---TH10 stage03（中 BOSS / BOSS 河城荷取）与 stage04（中 BOSS 犬走椛 / BOSS 射命丸文）符卡移植
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
            -- 原作飞行中 etSprite 换 type/color：形状和颜色都要跟随。
            b.color = r.i1
            b.type = r.i0
            local style = t10_style(r.i0)
            local color = t10_color(r.i1, r.i0)
            if b.eb then
                b.eb.th10_color = color
                bullet.ChangeImage(b.eb, style, color)
            end
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
            if not b.is_laser or r.i0 > 0 then
                b.af.bounce = k
                b.st.bounce = { n = 0, max = r.i0, v0 = r.f0 }
                ---激光 RunCommands 在启用反射时直接 --command.int0（原版 0x41CECB）。
                ---反射段复制的是扣过次数的程序；点弹则在反弹时累计次数，不能混用。
                if b.is_laser then r.i0 = r.i0 - 1 end
            end
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
        object.SetV(self, mag, -math.atan2(b.vy, b.vx) * RAD, bullet.GetNavi(self))
    else
        object.SetV(self, 0, 0, false)
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
    local b = NewSimpleBullet(t10_style(p.type), t10_color(p.color, p.type),
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
    b.t10_color = t10_color(p.color, p.type)
    b.t10_type = p.type
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
    if w=='off' and x>-999999 and RogueInitialTarget then x=RogueInitialTarget(o,x,true) end
    local ch = M(o, w)
    if x > -999999 then ch.x = x end
    if y > -999999 then ch.y = y end
    ch.circle, ch.interp, ch.scal = false, nil, nil
    ecs_sync(o)
end

local function m_pos_time(o, w, dur, mode, x, y)
    if w=='off' and x>-999999 and RogueInitialTarget then x=RogueInitialTarget(o,x) end
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
local function t10_track(o, owner)
    if owner then o.t10_root = owner.t10_root or owner end
    T10_PODS[#T10_PODS + 1] = o
end

---停掉一个 ECL 载体：先清掉挂在它名下的协程，再删对象。
---★ 真引擎删对象时会连带停掉它的 task；自检工具的调度器不看对象死活，
---  只删对象的话子机 ECL 会继续跑（表现为「卡结束后还在造弹」——del 没清干净）。
local function t10_kill_pod(o)
    ---task.Clear 会写 self.task；句柄回收后，这次写入本身就会抛 invalid lstg object。
    if o == nil or not IsValid(o) then return end
    task.Clear(o)
    object.RawDel(o)
end

local function t10_clear_pods(root)
    for i = #T10_PODS, 1, -1 do
        local o = T10_PODS[i]
        if not IsValid(o) then
            table.remove(T10_PODS, i)
        elseif o.t10_root == root then
            t10_kill_pod(o)
            table.remove(T10_PODS, i)
        end
    end
end

---原作只有一个阶段；接续战会让两个阶段重叠，清场只能作用于调用者所属的卡。
---否则旧卡 del / enmKillAll 会删除新卡载体，「一子相传」连 t=90 的枪都启动不了。
local function t10_enm_kill_all(keep)
    for i = #T10_PODS, 1, -1 do
        local o = T10_PODS[i]
        if not IsValid(o) then
            table.remove(T10_PODS, i)
        elseif o ~= keep and o.t10_root == keep.t10_root and not o.IsLaser then
            t10_kill_pod(o)
            table.remove(T10_PODS, i)
        end
    end
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
        self.t10_root = origin and origin.t10_root or self
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

---激光几何沿用 th31 的做法：对象放在光柱尾端，THlib 只负责画线和玩家判定。
---TH10 LaserLine.cpp:Update 先增长到 maximumLength，下一帧才开始 position += velocity；
---terminalDistance 是总行程，0 表示飞出边界才回收，不能用「长满后 30 帧」当寿命。
---原版 bullet.anm 的主弹精灵（interrupt 2）：type3=64..79、type8=144..159、
---type13=264..271。两张 PNG 直接从二进制 ANM 提取，透明边缘与亮芯不再用代理贴图。
local T10_LASER_SPRITES = {
    [3] = { tex = 'th35_laser_etama', x = 0, y = 65, w = 16, h = 14, step = 16, count = 16 },
    [8] = { tex = 'th35_laser_etama', x = 1, y = 129, w = 14, h = 14, step = 16, count = 16 },
    [13] = { tex = 'th35_laser_etama6', x = 1, y = 129, w = 30, h = 30, step = 32, count = 8 },
}
do
    if not CheckRes('img', 'th35_laser_3_0') then
        LoadTexture('th35_laser_etama', 'mod\\GAME\\th35\\etama.png')
        LoadTexture('th35_laser_etama6', 'mod\\GAME\\th35\\etama6.png')
        for kind, p in pairs(T10_LASER_SPRITES) do
            for color = 0, p.count - 1 do
                local name = 'th35_laser_' .. kind .. '_' .. color
                LoadImage(name, p.tex, p.x + color * p.step, p.y, p.w, p.h)
                ---原版 flags 0x600000：横向居中、纵向底部为锚点。
                SetImageCenter(name, p.w / 2, p.h)
            end
        end
    end
end

local function t10_laser_sprite(kind, color)
    local p = T10_LASER_SPRITES[kind]
    color = math.max(0, math.min(p.count - 1, math.floor(color)))
    return 'th35_laser_' .. kind .. '_' .. color, p.w, p.h
end

local function t10_laser_render(self)
    local len = self.l1 + self.l2 + self.l3
    if self.w <= 0 or len <= 0 then return end
    SetImageState(self.t10_sprite, self._blend, self._a * self.alpha, self._r, self._g, self._b)
    ---LaserLine/Type1 的缩放就是 width/sprite.width、length/sprite.height。
    ---THlib 的 w/7 会把原作 16px 的贴图矩形放大到 36.57px，不能用于 TH10。
    Render(self.t10_sprite, self.x, self.y, self.rot - 90,
        self.w / self.t10_sprite_w, len / self.t10_sprite_h)
end

local th10_laser_fade = Class(laser, {
    frame = task.Do,
    render = t10_laser_render,
    del = function() end,
    kill = function() end,
})
local function t10_laser_kill(self)
    laser.kill(self)
    self.class = th10_laser_fade
end

local function t10_new_laser(owner, cls, ...)
    ---EnemyFireLaser（0x41C510）只有 256 槽，满槽时整根不生成。
    ---与 th31 一样每个卡片实例独立计数；尤其不能让客星的反射分支无限分配对象。
    local root, count = owner.t10_root or owner, 0
    for i = #T10_PODS, 1, -1 do
        local o = T10_PODS[i]
        if not IsValid(o) then table.remove(T10_PODS, i)
        elseif o.t10_root == root and o.IsLaser and o.group == GROUP.LASER then count = count + 1 end
    end
    if count >= 256 then return end
    local l = New(cls, ...)
    t10_track(l, owner)
    return l
end

local function t10_laser_geometry(self, width, active, straight)
    local x, y, len = self.x, self.y, self.t10_len
    local dx, dy = math.cos(-self.t10_ang), math.sin(-self.t10_ang)
    local hitwidth = width * 0.5
    if width >= 32 then hitwidth = width - (width + 16) * (straight and (1 / 3) or 0.5) end
    ---LaserLine / LaserType1 都只判中间 80%；画面仍画整段矩形。
    self.x, self.y = x + dx * len * 0.1, y + dy * len * 0.1
    self.l1, self.l2, self.l3 = 0, len * 0.8, 0
    self.w, self.colli = hitwidth, active and len > 16 and (straight or width > 3)
    laser.frame(self)
    self.x, self.y = x, y
    self.l2, self.w = len, width
end

local th10_laser = Class(laser, {
    init = function(self, x, y, kind, color, ang, initlen, maxlen, speed, term, width, program)
        laser.init(self, t10_color(color, kind), x, y, -ang * RAD, 0, initlen, 0, width, 0, 0)
        self.w0 = width
        self.t10_len, self.t10_max, self.t10_initial = initlen, maxlen, initlen
        self.t10_ang, self.t10_spd, self.t10_term = ang, speed, term
        self.t10_kind, self.t10_color = kind, color
        self.t10_sprite, self.t10_sprite_w, self.t10_sprite_h = t10_laser_sprite(kind, color)
        self.t10_traveled = initlen > 0 and 0.01 or 0
        self.t10_age = 0
        ---每根激光持有可变程序副本；反射次数会被消耗，不能共用父段/枪的表。
        self.t10_program = {}
        for i, r in pairs(program or {}) do
            self.t10_program[i] = tp_record(r.a, r.k, r.i0, r.i1, r.f0, r.f1)
        end
        self.t10_motion = { px = x, py = t10_oy(y), angle = ang, speed = speed,
            vx = math.cos(ang) * speed, vy = math.sin(ang) * speed,
            tp = self.t10_program, ti = 0, af = {}, st = {}, cull = 10, cancel = 0, is_laser = true }
        self.colli, self.bound, self.alpha, self.w = true, false, 1, width
    end,
    frame = function(self)
        local m = self.t10_motion
        m.px, m.py = self.x, t10_oy(self.y)
        t10_tp_advance(m)
        ---激光的反弹是从「头」另生一段，不能套用点弹的整弹镜像。
        local bounce = m.af.bounce
        m.af.bounce = nil
        t10_tp_tick(m)
        m.af.bounce = bounce
        self.t10_ang, self.t10_spd, self.rot = m.angle, m.speed, -m.angle * RAD
        if m.dead then object.RawDel(self) return end
        if bounce then
            local hx = m.px + math.cos(m.angle) * self.t10_len
            local hy = m.py + math.sin(m.angle) * self.t10_len
            local reflected
            if hx < -192 or hx >= 192 then reflected = t10_wrap(-m.angle - PI)
            elseif bounce ~= TK_BOUNCE_VAR and (hy < 0 or (hy >= 448 and bounce == TK_BOUNCE_ALL)) then
                reflected = -m.angle
            end
            if reflected then
                local spd = m.st.bounce.v0 >= 0 and m.st.bounce.v0 or m.speed
                t10_new_laser(self, self.class, hx, t10_oy(hy), self.t10_kind, self.t10_color,
                    reflected, self.t10_initial, self.t10_max, spd, self.t10_term, self.w0, self.t10_program)
                m.af.bounce = nil
            end
        end
        if self.t10_len < self.t10_max then
            self.t10_len = math.min(self.t10_max, self.t10_len + self.t10_spd)
        else
            self.t10_traveled = self.t10_traveled + self.t10_spd
            self.x, self.y = self.x + m.vx, self.y - m.vy
            if self.t10_term > 0 and self.t10_traveled + self.t10_len > self.t10_term then
                self.t10_len = self.t10_term - self.t10_traveled
                self.t10_max = self.t10_len
                if self.t10_len <= 0 then object.RawDel(self) return end
            end
        end
        ---只要尾或头仍在场内就保留，长光柱不能按原点的 bound 回收。
        local hx = self.x + math.cos(self.t10_ang) * self.t10_len
        local hy = self.y - math.sin(self.t10_ang) * self.t10_len
        local w = self.w0
        local tail_out = self.x + w <= -192 or self.x - w >= 192 or self.y + w <= -224 or self.y - w >= 224
        local head_out = hx + w <= -192 or hx - w >= 192 or hy + w <= -224 or hy - w >= 224
        if self.t10_age >= 30 and tail_out and head_out then object.RawDel(self) return end
        self.t10_age = self.t10_age + 1
        t10_laser_geometry(self, self.w0, true, false)
    end,
    render = t10_laser_render,
    kill = t10_laser_kill,
    ---原版出界直接释放槽位，不套用 THlib del 的 30 帧保留光柱。
    del = function() end,
})

---laserOnA / laserOn 的发射点都读取 etOffset 的槽 0；带 Ex 的指令复制槽 0 的程序。
local function t10_laser_on(o, kind, color, ang, speed, initlen, maxlen, term, width, with_pattern)
    local p = o.pat[0]
    local program
    if with_pattern then
        program = {}
        for i, r in pairs(p.ex) do
            program[i + 1] = tp_record(r.a, r.k, r.i0, r.i1, r.f0, r.f1)
        end
    end
    return t10_new_laser(o, th10_laser, o.ecs.wx + p.ox, t10_oy(o.ecs.wy + p.oy),
        kind, color, ang, initlen, maxlen, speed, term, width, program)
end

---laserStOn 是另一类激光：位置固定，以 wait/grow/hold/shrink 四段控制粗细与判定。
---参数直接对应二进制 op413；它的默认长度增长速度是 8，与移动激光的 speed 无关。
local th10_st_laser = Class(laser, {
    init = function(self, x, y, kind, color, ang, initlen, maxlen, wait, grow, hold, shrink, width)
        laser.init(self, t10_color(color, kind), x, y, -ang * RAD, 0, initlen, 0, width, 0, 0)
        self.t10_sprite, self.t10_sprite_w, self.t10_sprite_h = t10_laser_sprite(kind, color)
        self.t10_ang, self.t10_len, self.t10_max = ang, initlen, maxlen
        self.t10_wait, self.t10_grow, self.t10_hold, self.t10_shrink = wait, grow, hold, shrink
        self.t10_state, self.t10_age = 3, 0
        self.w, self.alpha, self.colli, self.bound = 2, 1, false, false
    end,
    frame = function(self)
        self.t10_len = math.min(self.t10_max, self.t10_len + 8)
        local state, t, w = self.t10_state, self.t10_age, self.w
        if state == 3 then
            if t >= self.t10_wait then state, t = 4, 0 end
        elseif state == 4 then
            if t >= self.t10_grow then state, t, w = 2, 0, self.w0
            else w = self.w0 * t / self.t10_grow end
        end
        if state == 2 and t >= self.t10_hold then state, t = 5, 0 end
        if state == 5 then
            if t >= self.t10_shrink then object.RawDel(self) return end
            w = self.w0 * (1 - t / self.t10_shrink)
        end
        self.t10_state, self.t10_age = state, t + 1
        t10_laser_geometry(self, w, state == 4 or state == 2, true)
    end,
    render = t10_laser_render,
    kill = t10_laser_kill,
    del = function() end,
})

local function t10_laser_st_on(o, kind, color, ang, initlen, maxlen, wait, grow, hold, shrink, width)
    local p = o.pat[0]
    return t10_new_laser(o, th10_st_laser, o.ecs.wx + p.ox, t10_oy(o.ecs.wy + p.oy),
        kind, color, ang, initlen, maxlen, wait, grow, hold, shrink, width)
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
    if RogueInitialCarrier then RogueInitialCarrier(p) end
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
---  组 4b = stage04 中 BOSS 犬走椛（MBoss 非符）
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
---  · 弹样式：`etSprite(type, color)` 的第 1 参按 `T10_STYLE` 换成最接近的原生弹型，
---    第 2 参按该 type 的 16/8/4/3/1 色组换成本项目贴图行（见 `t10_color`）。
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
        t10_laser_on(o, 3, kind, d, 6.0, 0, 128.0, 0.0, 14.0, true)
        phase = t10_wrap(phase + 0.034907)
        task.Wait(4)
        d = t10_wrap(e + c * math.sin(phase))
        t10_laser_on(o, 3, 15, d, 6.0, 0, 128.0, 0.0, 14.0, true)
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
        t10_laser_on(o, 3, kind, d, 6.0, 0, 128.0, 0.0, 14.0, true)
        phase = t10_wrap(phase + 0.034907)
        task.Wait(4)
        d = t10_wrap(e - c * math.sin(phase))
        t10_laser_on(o, 3, 15, d, 6.0, 0, 128.0, 0.0, 14.0, true)
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
        t10_laser_on(o, 3, b, 1.5707964, 8.0, 0, 320.0, 0.0, 16.0, true)
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

---卡 3619　土着神「宝永四年の赤蛙」（可击破；spellTimeout 不是无敌）
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

---卡 3620　「諏訪大戦　～ 土着神話 vs 中央神話」（可击破；spellTimeout 不是无敌）
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

---卡 3621　祟符「ミシャグジさま」（可击破）
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
    ---原作阈值是对 lifeSet(10000) 的绝对值；运行时 HP 已按灵梦口径缩放，
    ---所以这里必须按同一比例比较，不能继续写 8000/5500/3500/1700。
    local maxlife = TH35_REIMU_HP[3621]
    o.I0 = 0
    while true do                        -- +1: //1
        local life = (o.th10_boss and o.th10_boss.hp) or 0
        if a == 0 then
            if life <= maxlife * 0.8000 then o.I0 = o.I0 + 1; a = a + 1 end
        elseif a == 1 then
            if life <= maxlife * 0.5500 then o.I0 = o.I0 + 1; a = a + 1 end
        elseif a == 2 then
            if life <= maxlife * 0.3500 then o.I0 = o.I0 + 1; a = a + 1 end
        elseif a == 3 then
            if life <= maxlife * 0.1700 then o.I0 = o.I0 + 1; a = a + 1 end
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

---非符 3651　八坂神奈子（stage07 中 BOSS 非符一，原作 MBoss1）
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
--  stage04 的中 BOSS（犬走椛）也是一张纯非符（原作 MBoss / MBossAt），
--  单独用「4b」注册在最前；「4a」留给 BOSS 射命丸文。
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

---中BOSS 非符 3670　犬走椛（stage04 中 BOSS；原作 MBoss + MBossAt）
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
boss.Define("4b", "犬走椛",             "TH10_4", TH10_bg, { 0, 80 }, nil, "Momizi", LEVEL)
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
    ---stage04 中 BOSS 犬走椛（原作 MBoss / MBossAt，纯非符）：lifeSet(10000) −
    ---  setInterrupt 阈值 0 = HP 10000；setInvuln(200) ⇒ t1 = t2 = 200/60、时限 1800 帧 = 30 s。
    ---  原作里中 BOSS 先于 BOSS 出场 ⇒ 这张排在 4b 组最前。
    { s4n.MBoss,     "",                                        "4b", 3670, 200 / 60, 200 / 60, 1800 / 60, 10000, "stage04 中BOSS 非符" },
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
    hp = TH35_REIMU_HP[id] or hp
    local menu = e[9] or name
    local c = boss.card.New(name, t1, t2, t3, hp)
    c.init = function(self)
        local p = t10_boss_start(self, main)
        p.t10_bossref = p
    end
    ---卡片结束时把本卡生成的枪/使魔载体一起清掉（原作靠 killAllAsync/enmKillAll + 敌机回收）。
    c.del = function(self) t10_clear_pods(self.th10carrier) end
    boss.card.add({ { c, band } }, LEVEL, menu, id)
end

---=====================================
---stage07（Extra）二十二张：{ 主 ECL 子程序, 卡名, 组, CARD_ID, t1, t2, t3, HP }
---  组 1a = 神奈子（中 BOSS 三张）、组 5a = 洩矢諏訪子（BOSS 十张）——
---    中 BOSS 三张挂回 1a 是刻意的：原作 stage07 的中 BOSS 也是神奈子，
---    用 5a 会让它们顶着諏訪子的立绘出场（原作的 BOSS 是諏訪子，中 BOSS 不是）。
---  t1/t2 = setInvuln(n)/60；t3 = spell*(…, 时间, …) 的帧数 / 60。
---    3619「宝永四年の赤蛙」/ 3620「諏訪大戦」/ 3621「祟符」虽然带 spellTimeout()，
---    但 spellTimeout 只影响超时表现，**不是无敌**；它们各有 10,000 可伤 HP。
---    真正挡伤害的只有 setInvuln(90/180/120)，所以 t1 = t2 = 1.5/3/2 秒。
---    3607「無双風神」则被 setInvuln(1080) 覆盖整张卡，仍按耐久卡处理。
---  HP = 该卡开始时 BOSS 的 lifeSet（中 BOSS 三张 2300；3619/3620/3621 是 10000），
---    再由 TH35_REIMU_HP 换算成移植版灵梦口径。
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
    { s7.BossCard8,  "土着神「宝永四年の赤蛙」",                  "5a", 3619, 90 / 60,  90 / 60,  2400 / 60, 10000 },
    { s7.BossCard9,  "「諏訪大戦　～ 土着神話 vs 中央神話」",     "5a", 3620, 180 / 60, 180 / 60, 5040 / 60, 10000 },
    { s7.BossCard10, "祟符「ミシャグジさま」",                    "5a", 3621, 120 / 60, 120 / 60, 9600 / 60, 10000 },
}

for _, e in ipairs(T10_CARDS_EX) do
    local main, name, band, id, t1, t2, t3, hp = e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8]
    hp = TH35_REIMU_HP[id] or hp
    local menu = e[9] or name
    local c = boss.card.New(name, t1, t2, t3, hp)
    c.init = function(self)
        local p = t10_boss_start(self, main)
        p.t10_bossref = p
    end
    c.del = function(self) t10_clear_pods(self.th10carrier) end
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
    t10_track(s, master)
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

---=====================================
---stage06 符卡（正统 ECL 移植；只做 Lunatic 难度行）
---  原作卡片：BossCard1（spellEx 80）、BossCard2（spellEx 84）、
---            BossCard3H（spellEx 88，L 走 3H 分支，BossCard3/Dummy 是给 E/N 的）、
---            BossCard4（spell3 91，L 也走这一支）。
---  HP = 卡前 lifeSet − 卡内 setInterrupt(0,0,T,…) 的收尾阈值 0 ⇒ 直接用上台 lifeSet：
---    BossCard1/2 沿用 Boss1/Boss2 的 11500、BossCard3H 沿用 Boss3 的 12900、
---    BossCard4 沿用 Boss4 的 12200。
---  t1 = t2 = setInvuln 帧数/60；t3 = setInterrupt 时限/60（70 / 70 / 60 / 100 秒）。
---  ★ etOffset 的实参弹栈顺序 ≠ thtk 反汇编的显示顺序：源码 ReadFloatArgument(1)→X 先弹栈顶，
---    所以「先 push 的那条」其实是 Y。本段按真实语义写 et_offset(o, slot, X, Y)。
---=====================================

---符卡 3622　奇祭「目処梃子乱舞」（八坂神奈子）
---  原作 BossCard1（spellEx 80 / 4200 帧）。时间轴：
---    t=0 起手（movePosTime(60,4,0,128)、setInvuln(90)、清 5 个槽的出弹点）；
---    t=90 moveLimit(0,96,280,32)，随后 jmp→490→jmpNeq 把时钟拨回 90：
---    「每 400 帧」跑一次 _772：enmCreate("BossCard1_atH",0,0)（相对坐标、0 只在 !HL）
---    + callAsync("BossCard1_at2") + moveRand(50,0,3.0)（首轮与 t=90 同帧，之后 490、890…）。
function s6.BossCard1(o)
    local ct = 0
    t10_kill_async(o)                               -- killAllAsync()
    m_pos_time(o, "off", 60, 4, 0.0, 128.0)         -- movePosTime(60, 4, 0, 128)
    t10_enm_kill_all(o)                             -- enmKillAll()
    for s = 0, 4 do et_offset(o, s, 0.0, 0.0) end   -- etOffset(0..4, 0, 0)
    ct = s_wait(ct, 90)                             -- +90: //90
    m_limit(o, 0.0, 96.0, 280.0, 32.0)              -- moveLimit(0, 96, 280, 32)
    ct = 490                                        -- jmp(BossCard1_984, 490)
    while true do                                   -- _984：pushi(1); jmpNeq(_772, 90)
        ct = 90                                     -- jmpNeq(_772, 90)：时钟拨回 90
        s_pod(o, 0.0, 0.0, s6.BossCard1_atH)        -- enmCreate("BossCard1_atH", 0, 0)
        t10_call_async(o, s6.BossCard1_at2)         -- callAsync("BossCard1_at2")
        m_rand(o, "off", 50, 0, 3.0)                -- moveRand(50, 0, 3.0)
        ct = s_wait(ct, 490)                        -- +400: //490 nop（等 400 帧）
    end
end

---BossCard1_at2：单枪（槽 1）8 轮，每轮 etOn 后隔 40 帧（diffWait 的 L 行）。
---  8 弹圆环（etAim(1,3)、etCountD L 行 c1=16）、角步 0、速 4.0→1.4；
---  循环是「先 deci 再打」⇒ 每轮首帧就打、共 8 发。
function s6.BossCard1_at2(o)
    local n8 = 8                                    -- pushi(8); seti([8])
    et_new(o, 1); et_aim(o, 1, 3); et_sprite(o, 1, 6, 6)
    et_count(o, 1, 16, 1)                           -- etCountD(1, 3,8,8,16, 1,1,1,1) 的 L 行
    et_angle(o, 1, 1.5707964, 0.0)
    et_speed(o, 1, 4.0, 1.4)                        -- etSpeedD(1, 4.0,…, 1.4,…) 的 L 行
    et_ex(o, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 1, 1, 0, 128, 40, 3, 0.0, 1.0)         -- 各难度同
    while true do                                   -- _676：deci([8]); jmpNeq(_624, 0)
        local old = n8; n8 = n8 - 1
        if old == 0 then break end
        fire_slot(o, 1)                             -- _624：etOn(1)
        task.Wait(40)                               -- diffWait(80, 60, 60, 40)
    end
end

---BossCard1_atH：竖直光柱使魔（槽 2 的环弹 + 两根 512 长的光柱）。
---  11 轮：BOSS 子机先 movePosRel(−[4],0) 在左位放一根柱并 callAsync(atH2,[0]=−[4],[4]=[8])，
---  再 movePosRel(+[4],0) 在右位放一根并 callAsync(atH2,[0]=+[4],[4]=[8])，
---  隔 15 帧；[4] −= 16.4、[8] −= 2 ⇒ 柱位每轮向中心收 16.4。
---  出生时 movePos(0,−64)：子机世界 y = −64，光柱正好自屏幕上方贯到下方
---  （etOffset 靠 %FINAL_X/%FINAL_Y 反算，让弹恰好落在世界坐标 (±[0], 448) 上）。
function s6.BossCard1_atH(o)
    local n12 = 11                                  -- pushi(11); seti([12])
    local a4 = 192.0                                -- pushi(192); setf([4])
    local a8 = 24.0                                 -- pushi(24); setf([8])
    et_new(o, 2); et_aim(o, 2, 3); et_sprite(o, 2, 1, 2)
    et_count(o, 2, 8, 1)                            -- etCountD(2, 3,8,8,8, 1,1,1,1) 的 L 行
    et_angle(o, 2, 1.5707964, 0.0)
    et_speed(o, 2, 0.6, 1.4)                        -- etSpeedD(2, 0.6,…, 1.4,…) 的 L 行
    m_pos(o, "off", 0.0, -64.0)                     -- movePos(0, −64)
    -- ★ 原作这两条 etEx 写的是**槽 0**（与 etOn(2) 的槽不同 ⇒ 对出弹没有作用），照抄。
    et_ex(o, 0, 0, 0, 32768, 20, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 0, 1, 0, 1024, 1, -999999, -999999, -999999.0, -999999.0)
    while true do                                   -- _1096：deci([12]); jmpNeq(_524, 0)
        local old = n12; n12 = n12 - 1
        if old == 0 then break end
        m_pos(o, "base", 0.0 - a4, 0.0)             -- _524：movePosRel(−[4], 0)
        t10_laser_on(o, 13, 1, 1.5707964, a8, 0, 512.0, 0, 46.0)
        s_async(o, s6.BossCard1_atH2, 0.0 - a4, a8) -- callAsync("BossCard1_atH2", −[4], [8])
        m_pos(o, "base", a4, 0.0)                   -- movePosRel([4], 0)
        t10_laser_on(o, 13, 1, 1.5707964, a8, 0, 512.0, 0, 46.0)
        s_async(o, s6.BossCard1_atH2, a4, a8)       -- callAsync("BossCard1_atH2", [4], [8])
        task.Wait(15)                               -- wait(15)
        a4 = a4 - 16.4                              -- [4] −= 16.4
        a8 = a8 - 2.0                               -- [8] −= 2
    end
    t10_delete(o)                                   -- delete()
end

---BossCard1_atH2：callAsync 带两个实参（[0] = ±a4、[4] = a8）。
---  [8] = int(448 / [4]) ⇒ wait([8])；然后把槽 2 的出弹点设成
---  「世界坐标 ([0], 448) − 本敌机世界位置」——etOn 时弹就正好从 ([0], 448) 出来。
---  线程一次性：etOn 之后 ret。
function s6.BossCard1_atH2(o, l0, l4)
    task.Wait(math.floor(448 / l4))                 -- seti([8]); wait([8])
    et_offset(o, 2, l0 - o.ecs.wx, 448.0 - o.ecs.wy)
    fire_slot(o, 2)                                 -- etOn(2)
end

---符卡 3623　神穀「ディバイニングクロップ」（八坂神奈子）
---  原作 BossCard2（spellEx 84 / 4200 帧 / 沿用 Boss2 的 lifeSet 11500）。时间轴：
---    t=0 moveLimitReset() + movePosTime(60,4,0,192)；
---    t=90 三颗 BossCir*2（相对坐标 0,0）+ callAsync("BossCard2_at")；
---    随后 _888 每 100 帧空转一轮（wait(100) + jmpNeq 拨回 90）。
function s6.BossCard2(o)
    local ct = 0
    t10_kill_async(o)                               -- killAllAsync()
    m_limit_clear(o)                                -- moveLimitReset()
    m_pos_time(o, "off", 60, 4, 0.0, 192.0)         -- movePosTime(60, 4, 0, 192)
    t10_enm_kill_all(o)                             -- enmKillAll()
    for s = 0, 4 do et_offset(o, s, 0.0, 0.0) end   -- etOffset(0..4, 0, 0)
    ct = s_wait(ct, 90)                             -- +90: //90
    s6.sat(o, SATS[1]); s6.sat(o, SATS[2]); s6.sat(o, SATS[3])   -- BossCirR2/G2/B2
    t10_call_async(o, s6.BossCard2_at)              -- callAsync("BossCard2_at")
    ct = 90                                         -- jmp(BossCard2_908, 90)
    while true do                                   -- _888：wait(100); _908：jmpNeq(_888, 90)
        task.Wait(100)                              -- wait(100)
    end
end

---BossCard2_at：三把枪（槽 0/1/2），每 50 帧一轮：
---  轮首立刻打槽 0（出弹点 +32,−24）与槽 1（−32,−24），隔 25 帧刷新随机角后打槽 2（0,−48）。
---  三把都是 50 弹圆环（etCountD L 行 c1=50）、速 6.4→1.5、角步 0.028049935；
---  L 行把槽 1 的色号改成 5、etEx(1,2,…) 的 i1 改成 10，并复制出槽 2（色号 3、i1=6）。
---  ★ 槽 2 的角度 = int(([12]+[16])/2)：原作此处用 divi（整数除法）⇒ 结果被截断成整数。
function s6.BossCard2_at(o)
    et_new(o, 0); et_aim(o, 0, 3); et_sprite(o, 0, 13, 1)
    et_count(o, 0, 50, 1)               -- etCountD(0, 34,50,50,50, 1,1,1,1) 的 L 行
    et_angle(o, 0, 0.0, 0.3926991)
    et_speed(o, 0, 6.4, 1.5)            -- etSpeedD(0, 6.4,…, 1.5,…) 的 L 行
    et_ex(o, 0, 0, 1, 8, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 0, 1, 0, 16, 60, -999999, -0.093333334, -999.0)
    et_ex(o, 0, 2, 0, 16384, 3, 2, -999999.0, -999999.0)
    et_copy(o, 1, 0)
    et_offset(o, 0, 32.0, -24.0)
    et_sprite(o, 1, 13, 2)
    et_offset(o, 1, -32.0, -24.0)
    et_ex(o, 1, 2, 0, 16384, 3, 4, -999999.0, -999999.0)
    et_sprite(o, 1, 13, 5)              -- $DIFF ≥ 2（L 也成立）
    et_ex(o, 1, 2, 0, 16384, 3, 10, -999999.0, -999999.0)
    et_copy(o, 2, 0)                    -- $LUNATIC（L 独有）
    et_offset(o, 2, 0.0, -48.0)
    et_sprite(o, 2, 13, 3)
    et_ex(o, 2, 2, 0, 16384, 3, 6, -999999.0, -999999.0)
    et_ex(o, 2, 1, 0, 16, 60, -999999, -0.08833333, -999.0)
    et_count(o, 2, 50, 1)
    local a12 = rndrad()                -- [12] = %RANDRAD
    local a16 = rndrad()                -- [16] = %RANDRAD
    while true do                       -- _1456：pushi(1); jmpNeq(_1088, 0)
        et_angle(o, 0, a12, 0.028049935)
        fire_slot(o, 0)                 -- etOn(0)
        et_angle(o, 1, a16, 0.028049935)
        fire_slot(o, 1)                 -- etOn(1)
        task.Wait(25)                   -- wait(25)
        a12 = rndrad()                  -- [12] = %RANDRAD（等满 25 帧后才刷新）
        a16 = rndrad()                  -- [16] = %RANDRAD
        -- 原作 `pushf([12]); pushf([16]); addf(); pushi(2); divi();`：
        -- divi 是 ECL_VM_DIVIDE_INT ⇒ 两个 float 操作数各按 C 的 (int) **向零截断**
        -- 取整，随后 int/int 也是**向零截断**的整数除法（不是 Lua 的向负无穷）。
        -- 负角度时 math.floor 会比原作少 1（实测差 −1.0），必须手动截断；
        -- 另外 (int)(−0.0)=0 ⇒ 结果要归一成 +0.0，否则日志里出现 −0.000000。
        local sum = a12 + a16
        local ti = (sum >= 0) and math.floor(sum) or math.ceil(sum)     -- (int)sum
        local half = (ti >= 0) and math.floor(ti / 2) or math.ceil(ti / 2)  -- ti / 2（整数除法）
        if half == 0 then half = 0 end                                  -- −0.0 → +0.0
        et_angle(o, 2, half, 0.028049935)
        fire_slot(o, 2)                 -- etOn(2)（!L 行，L 也打）
        task.Wait(25)                   -- diffWait(25, 25, 10, 25)
    end
end

---符卡 3624　神秘「ヤマトトーラス」（八坂神奈子）
---  原作 BossCard3H（spellEx 88 / 3600 帧 / 沿用 Boss3 的 lifeSet 12900）。
---  ★ L 行不走 BossCard3（那条只给 E/N），也不召唤 BossCard3Dummy。
---  时间轴：t=80 moveLimit(0,96,64,64) + 三颗 BossCir*2 + callAsync("BossCard3H_at")；
---  之后 _868 的 wait(60) 之后每 180 帧 moveRand(40,0,2.0)（首轮 t=140）。
function s6.BossCard3H(o)
    local ct = 0
    t10_kill_async(o)                               -- killAllAsync()
    m_pos_time(o, "off", 60, 4, 0.0, 144.0)         -- movePosTime(60, 4, 0, 144)
    t10_enm_kill_all(o)                             -- enmKillAll()
    for s = 0, 4 do et_offset(o, s, 0.0, 0.0) end   -- etOffset(0..4, 0, 0)
    ct = s_wait(ct, 80)                             -- +80: //80
    m_limit(o, 0.0, 96.0, 64.0, 64.0)               -- moveLimit(0, 96, 64, 64)
    s6.sat(o, SATS[1]); s6.sat(o, SATS[2]); s6.sat(o, SATS[3])   -- BossCirR2/G2/B2
    t10_call_async(o, s6.BossCard3H_at)             -- callAsync("BossCard3H_at")
    -- jmp(BossCard3H_916, 200) 先把 clock 设成 200，但 _916 的 jmpNeq 在同一帧内
    -- 立刻把 clock 拨回 80（所以下面那行 200 是瞬时的），随后 _868 的 wait(60) ⇒
    -- clock=20；于是「下一条 moveRand@200」要等 clock 从 20 涨到 200，即等满 180 帧 ——
    -- 首个 moveRand 在 clock=200（起手后第 260 帧）执行，之后每轮间隔固定 180 帧。
    ct = 200                                        -- jmp(BossCard3H_916, 200)：clock = 200
    ct = 80                                         -- _916：pushi(1); jmpNeq(_868, 80)（同帧执行）
    ct = ct - 60                                    -- _868：wait(60) ⇒ 时钟 20
    while true do
        ct = s_wait(ct, 200)                        -- +120: //200
        m_rand(o, "off", 40, 0, 2.0)                -- moveRand(40, 0, 2.0)
        ct = 80                                     -- jmpNeq(_868, 80)
        ct = ct - 60                                -- _868：wait(60) ⇒ 时钟 20
    end
end

---BossCard3H_at：单枪（槽 0）两段半圆扫，无限循环：
---  第一段 50 发（精灵 5）、基准角自 2.356194 每发 +0.034907（validRad 归一）、
---  第二段 50 发（精灵 4）、自 0.785398 每发 −0.034907；每发隔 4 帧、2 弹（c1=2、aim=1 扇形）、
---  角步 = %RANDRAD/10（每发新随机）。
---  ★ $HARD 在 L 上为 0 ⇒ jmpEq(_420,0) 成立（跳）⇒ i0 = 4（H 才是 3）。
function s6.BossCard3H_at(o)
    local a0 = 2.356194                             -- pushf(2.356194); setf([0])
    et_new(o, 0); et_aim(o, 0, 1); et_sprite(o, 0, 14, 1)
    et_count(o, 0, 2, 1)                            -- etCountD(0, 2,2,2,2, 1,1,1,1) 的 L 行
    et_angle(o, 0, 3.1415927, 0.7853982)
    et_speed(o, 0, 3.9, 1.0)
    et_ex(o, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(o, 0, 1, 1, 1048576, 4, -999999, -999999, -999999.0, -999999.0)   -- L 走 _420
    while true do                                   -- _1284：pushi(1); jmpNeq(_492, 0)
        a0 = 2.356194                               -- _492
        local n4 = 50                               -- pushi(50); seti([4])
        et_sprite(o, 0, 14, 5)
        while true do                               -- _844：deci([4]); jmpNeq(_624, 0)
            local old = n4; n4 = n4 - 1
            if old == 0 then break end
            a0 = t10_wrap(a0 + 0.034907)            -- _624：[0] += 0.034907；validRad([0])
            et_angle(o, 0, a0, rndrad() / 10)       -- %RANDRAD/10
            fire_slot(o, 0)                         -- etOn(0)
            task.Wait(4)                            -- wait(4)
        end
        a0 = 0.785398                               -- pushf(0.785398); setf([0])
        n4 = 50                                     -- pushi(50); seti([4])
        while true do                               -- _1240：deci([4]); jmpNeq(_992, 0)
            local old = n4; n4 = n4 - 1
            if old == 0 then break end
            et_sprite(o, 0, 14, 4)                  -- _992
            a0 = t10_wrap(a0 - 0.034907)            -- [0] −= 0.034907；validRad([0])
            et_angle(o, 0, a0, rndrad() / 10)
            fire_slot(o, 0)
            task.Wait(4)
        end
    end
end

---符卡 3625　天竜「雨の源泉」（八坂神奈子）
---  原作 BossCard4（spell3 91 / 6000 帧 / 沿用 Boss4 的 lifeSet 12200）。
---  ★ `pushi($DIFF); pushi(1); geqi(); jmpEq(_2232, 290)`：$DIFF ≥ 1 成立时压 1，
---    jmpEq 见非 0 **不跳** ⇒ N/H/L 走的是 thtk 里没标 !E/!N 的那段 fall-through
---    （−160/−96/−32/32/96/160 六只使魔）；只有 Easy（$DIFF=0）才去 _2232（4 只）。
---  时间轴：t=80 三颗 BossCir*2；t=140 moveLimit(0,112,128,64) 并起第一只使魔；
---  其后每 30 帧一只（t=170…290）；再 jmp→380 起 moveRand(120,0,1.0) 的 120 帧循环。
function s6.BossCard4(o)
    local ct = 0
    local p
    t10_kill_async(o)                               -- killAllAsync()
    m_pos_time(o, "off", 60, 4, 0.0, 144.0)         -- movePosTime(60, 4, 0, 144)
    t10_enm_kill_all(o)                             -- enmKillAll()
    for s = 0, 4 do et_offset(o, s, 0.0, 0.0) end   -- etOffset(0..4, 0, 0)
    ct = s_wait(ct, 80)                             -- +80: //80
    s6.sat(o, SATS[1]); s6.sat(o, SATS[2]); s6.sat(o, SATS[3])   -- BossCirR2/G2/B2
    ct = s_wait(ct, 140)                            -- +60: //140
    m_limit(o, 0.0, 112.0, 128.0, 64.0)             -- moveLimit(0, 112, 128, 64)
    -- 下面 6 只（N/H/L）用 enmCreateA ⇒ 绝对坐标
    -- ★ 这里必须是反汇编里的 float 字面量 3.141593（= 0x40490FDB ≈ 3.14159274），
    --   不能写 math.pi：后者略小，BossCard4Dummy 的 validRad([4]) 收不进 −π，
    --   会让首帧的 etEx f0 变成 +3.1416（实测差 1 行）。float 3.141593 > π ⇒ wrap 成 −π。
    o.F0 = 0.03927;  o.F1 = 3.141593; o.I0 = 2
    p = spawn_pod(o, -160.0, 0.0, s6.BossCard4Dummy);  p.t10_bossref = o.t10_bossref
    ct = s_wait(ct, 170)
    o.F0 = -0.03927; o.F1 = 0.0;      o.I0 = 13
    p = spawn_pod(o, -96.0, 0.0, s6.BossCard4Dummy2); p.t10_bossref = o.t10_bossref
    ct = s_wait(ct, 200)
    o.F0 = 0.03927;  o.F1 = 1.570796; o.I0 = 10
    p = spawn_pod(o, -32.0, 0.0, s6.BossCard4Dummy2); p.t10_bossref = o.t10_bossref
    ct = s_wait(ct, 230)
    o.F0 = -0.03927; o.F1 = 0.0;      o.I0 = 8
    p = spawn_pod(o, 32.0, 0.0, s6.BossCard4Dummy2); p.t10_bossref = o.t10_bossref
    ct = s_wait(ct, 260)
    o.F0 = 0.03927;  o.F1 = 0.0;      o.I0 = 6
    p = spawn_pod(o, 96.0, 0.0, s6.BossCard4Dummy2); p.t10_bossref = o.t10_bossref
    ct = s_wait(ct, 290)
    o.F0 = -0.03927; o.F1 = 1.570796; o.I0 = 4
    p = spawn_pod(o, 160.0, 0.0, s6.BossCard4Dummy);  p.t10_bossref = o.t10_bossref
    -- jmp(BossCard4_2984, 380) → _3008：moveRand；t=500 的 nop 把时钟卡住 120 帧
    ct = 380                                        -- jmp(BossCard4_2984, 380)
    while true do                                   -- _3052：pushi(1); jmpNeq(_3008, 380)
        m_rand(o, "off", 120, 0, 1.0)               -- _3008：moveRand(120, 0, 1.0)
        ct = s_wait(ct, 500)                        -- +120: //500 nop
        ct = 380                                    -- jmpNeq(_3008, 380)
    end
end

---BossCard4Dummy：使魔（$I0 = 2 / 4，站最外侧）。每 3 帧（diffWait L 行）打一发：
---  etEx(0, 0, 0, 64, 60, 1, [4], 1.6 + %RANDF2×0.2)、出弹点 (±%RANDF2×16, −12 − %RANDF×6)，
---  [4] 每发 −%F0（validRad 归一）。etEx 的 kind 由 $I0 选：2/4 用 7、其余用 3。
---  ★ 随机消耗顺序照原作 ECL：%RANDF2（etEx 的 f1）→ %RANDF → %RANDF2（etOffset）。
function s6.BossCard4Dummy(o)
    local a4 = o.F1                                 -- pushf(%F1); setf([4])
    et_new(o, 0); et_aim(o, 0, 1); et_sprite(o, 0, 18, 0)
    et_count(o, 0, 1, 1)
    et_angle(o, 0, 1.5707964, 0.7853982)
    et_speed(o, 0, 10.0, 1.0)
    if o.I0 == 2 or o.I0 == 4 then                  -- neqi($I0,2) && neqi($I0,4) == 0
        et_ex(o, 0, 1, 0, 16384, 7, o.I0, -999999, -999999.0, -999999.0)
    else
        et_ex(o, 0, 1, 0, 16384, 3, o.I0, -999999, -999999.0, -999999.0)
    end
    a4 = t10_wrap(a4)                               -- validRad([4])
    while true do                                   -- _1532：pushi(1); jmpNeq(_648, 0)
        et_ex(o, 0, 0, 0, 64, 60, 1, a4, 1.6 + rnd2() * 0.2)   -- _648（!L 行）
        local rf = rnd()                            -- %RANDF（先）
        local r2 = rnd2()                           -- %RANDF2（后）
        et_offset(o, 0, r2 * 16.0, -12.0 - rf * 6.0)
        fire_slot(o, 0)                             -- etOn(0)
        a4 = t10_wrap(a4 - o.F0)                    -- [4] −= %F0；validRad([4])
        task.Wait(3)                                -- diffWait(5, 5, 3, 3) 的 L 行
    end
end

---BossCard4Dummy2：使魔（$I0 = 13 / 10 / 8 / 6，站内侧）。每 8 帧（diffWait L 行）打一发：
---  etEx(0, 0, 0, 128, 60, 1, 0.0, 1.8)、出弹点 (±%RANDF2×16, −12 − %RANDF×6)、[4] −= %F0。
---  ★ 随机顺序：%RANDF → %RANDF2（比 Dummy 少一次 %RANDF2）。
function s6.BossCard4Dummy2(o)
    local a4 = o.F1                                 -- pushf(%F1); setf([4])
    et_new(o, 0); et_aim(o, 0, 1); et_sprite(o, 0, 18, 0)
    et_count(o, 0, 1, 1)
    et_angle(o, 0, 1.5707964, 0.7853982)
    et_speed(o, 0, 10.0, 1.0)
    et_ex(o, 0, 1, 0, 16384, 3, o.I0, -999999, -999999.0, -999999.0)
    while true do                                   -- _1012：pushi(1); jmpNeq(_404, 0)
        et_ex(o, 0, 0, 0, 128, 60, 1, 0.0, 1.8)     -- _404（!L 行）
        local rf = rnd()                            -- %RANDF（先）
        local r2 = rnd2()                           -- %RANDF2（后）
        et_offset(o, 0, r2 * 16.0, -12.0 - rf * 6.0)
        fire_slot(o, 0)                             -- etOn(0)
        a4 = t10_wrap(a4 - o.F0)                    -- [4] −= %F0；validRad([4])
        task.Wait(8)                                -- diffWait(5, 8, 8, 8) 的 L 行
    end
end

---stage06 四张符卡：{ 主 ECL 子程序, 卡名, 组, CARD_ID, t1秒, t2秒, t3秒, HP, 菜单名 }
---  CARD_ID 3622..3625（3600 是本关手写卡、3601..3621 是 03/04/07、3666..3669 是本关非符）。
---stage06 四张非符：{ 主 ECL 子程序, 卡名（非符为 ""）, 组, CARD_ID, t1秒, t2秒, t3秒, HP, 菜单名 }
---  组 1a = 八坂神奈子（与 stage06 BossCard5、stage07 中 BOSS 共用）。
---  CARD_ID 3666..3669（跑 `luajit tools/check_stage.lua --all` 核对：3600 是本关手写卡、
---    3601..3621 是 03/04/07、3630..3665 是 01/02/05 + 03/04/07 非符）。
s6.cards = {
    { s6.Boss1, "", "1a", 3666, 2,   2,   4200 / 60, 9000,  "stage06 非符一" },
    { s6.Boss2, "", "1a", 3667, 3,   3,   4200 / 60, 9000,  "stage06 非符二" },
    { s6.Boss3, "", "1a", 3668, 1,   1,   4200 / 60, 10000, "stage06 非符三" },
    { s6.Boss4, "", "1a", 3669, 1.5, 1.5, 5400 / 60, 9000,  "stage06 非符四" },
    { s6.BossCard1,  "奇祭「目処梃子乱舞」",           "1a", 3622, 1.5, 1.5, 4200 / 60, 11500, "stage06 符卡一" },
    { s6.BossCard2,  "神穀「ディバイニングクロップ」",   "1a", 3623, 1,   1,   4200 / 60, 11500, "stage06 符卡二" },
    { s6.BossCard3H, "神秘「ヤマトトーラス」",           "1a", 3624, 1,   1,   3600 / 60, 12900, "stage06 符卡三" },
    { s6.BossCard4,  "天竜「雨の源泉」",                 "1a", 3625, 1,   1,   6000 / 60, 12200, "stage06 符卡四" },
}

for _, e in ipairs(s6.cards) do
    local main, name, band, id, t1, t2, t3, hp = e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8]
    hp = TH35_REIMU_HP[id] or hp
    local menu = e[9] or name
    local c = boss.card.New(name, t1, t2, t3, hp)
    c.init = function(self)
        local p = t10_boss_start(self, main)
        p.t10_bossref = p
    end
    c.del = function(self) t10_clear_pods(self.th10carrier) end
    boss.card.add({ { c, band } }, LEVEL, menu, id)
end
--=====================================
-- 道中妖精框架（stage01..07 的「道中搬运卡」共用；stage06 那张也走它）
--   一个「道中妖精」= 一只普通敌机：能被打掉、掉道具；位置 / 出弹走本文件上面的
--   ecs 运行时（两路 motion + 8 个 pattern 槽 + $I/%F）。各 stage 只需写两样：
--     · 时间轴：谁、在第几帧、在哪个**绝对**坐标出生、是否镜像（enmCreateA/M/AM/F）
--     · 行为子程序：moveVel / moveVelTime / moveCircle(Rel) + et* / etOn
--   本框架由 stage06（九、）那张卡抽出，二者同一套口径。
--=====================================
t10mid = {}
t10mid.units = {}
t10mid.ax, t10mid.ay = 0, 0        -- 道中锚点（enmCreate 相对创建用；见 stage06 段）

---卡结束 / 重开（符卡练习）时统一收拾本卡造出来的妖精。
function t10mid.clear()
    for i = 1, #t10mid.units do t10_kill_pod(t10mid.units[i]) end
    t10mid.units = {}
end

---当前世界位置（原作坐标系）；子程序与 frame 都用它。
function t10mid.pos(f) return f.ecs.wx, f.ecs.wy end

---镜像角：enmCreateM 只翻 SET/INTERPOLATE POLAR 的目标角：
---  a' = wrap(π/2 − wrap(a − π/2)) ≡ wrap(π − a)。
function t10mid.mirror(a) return t10_wrap(TH10_PI - a) end

---moveVel（SET OFFSET POLAR）/ moveVelTime（INTERPOLATE OFFSET POLAR）。
---mirror=true（子机带 0x800 标志）时先折角。
function t10mid.vel(f, ang, spd)
    if f.t10_mir and ang > -999999 then ang = t10mid.mirror(ang) end
    m_vel(f, "off", ang, spd)
end
function t10mid.vel_time(f, dur, mode, ang, spd)
    if f.t10_mir and ang > -999999 then ang = t10mid.mirror(ang) end
    m_vel_time(f, "off", dur, mode, ang, spd)
end

---moveCircle / moveCircleRel：第一次调用把当前位置存成圆心；−999999 = 保持原值。
---圆运动**不**受镜像影响（原作只镜像极坐标运动的角）。
function t10mid.circle(f, w, a, av, r, rv)
    local ch = (w == "base") and f.ecs.base or f.ecs.off
    if not ch.circle then ch.cx, ch.cy = ch.x, ch.y end
    ch.circle, ch.interp, ch.scal = true, nil, nil
    if a  > -999999 then ch.ang = a  end
    if av > -999999 then ch.cav = av end
    if r  > -999999 then ch.r   = r  end
    if rv > -999999 then ch.rv  = rv end
end

class["th10_midfairy"] = Class(enemy, {
    init = function(self, hp, x, y, mirror, drop, beh, src, inv)
        enemybase.init(self, hp, true)          -- nontaijutsu ⇒ GROUP.NONTJT：能打、撞自机不掉血
        self.img = "servant"
        self.hscale, self.vscale = 0.6, 0.6
        self.colli = true
        self.navi, self.bound = false, false
        self.rot = 0
        self._blend, self._a = "", 255
        self.A, self.B = 8, 8                   -- setHitbox(16,16) 的一半
        self.invuln = inv or 0
        self.protect = self.invuln > 0          -- setInvuln：前 invuln 帧无敌
        self.drop_tbl = drop
        self.t10_mir = mirror and true or false
        ecs_attach(self, x, y)                  -- 建 ecs + 8 个 pattern 槽 + $I/%F
        if src then
            self.I0, self.I1, self.I2, self.I3 = src.I0, src.I1, src.I2, src.I3
            self.F0, self.F1, self.F2, self.F3 = src.F0, src.F1, src.F2, src.F3
        end
        self.seen = false
        ecs_sync(self)
        task.New(self, function() beh(self) end)
    end,
    frame = function(self)
        ecs_step(self)                          -- 原作 EnemyRuntimeUpdate：先解两路 motion
        if self.invuln > 0 then                 -- setInvuln 计时
            self.invuln = self.invuln - 1
            if self.invuln <= 0 then self.protect = false end
        end
        local wx, wy = t10mid.pos(self)
        if not self.seen then                   -- 进过场才算「出屏」基准
            if wx > -192 and wx < 192 and wy > -224 and wy < 224 then self.seen = true end
        elseif wx < -240 or wx > 240 or wy < -280 or wy > 280 then
            t10_kill_pod(self)                  -- 出屏回收（原作 EnemyManagerUpdate）
            return
        end
        enemybase.frame(self)                   -- 判定箱 + hp<=0→Kill + task.Do（跑行为协程）
    end,
    render = function(self) DefaultRenderFunc(self) end,
    kill = function(self)
        if self.drop_tbl then item.Dropitem_PFP(self.x, self.y, self.drop_tbl) end
    end,
    del = function(self) task.Clear(self) end,
})

---造一只妖精。`beh` = 行为子程序（函数）；`src`（可选）把创建者的 $I/%F 拷给子机。
function t10mid.spawn(hp, x, y, mirror, drop, beh, src, inv)
    local f = New(class["th10_midfairy"], hp, x, y, mirror, drop, beh, src, inv)
    t10mid.units[#t10mid.units + 1] = f
    return f
end
--=====================================
-- 九、stage06 道中（妖精群 + 两只大妖精）—— 原生 LuaSTG「道中搬运卡」
--   把原作 `data/stage06.ecl` 的**道中段**（`main` 派生的 MainSub1..5：成群的
--   小妖精 + 两次大妖精 Girl01/Girl02）复刻成**一张**符卡，挂在一个空的
--   `img_void` boss 上（与 mod/GAME/th34.lua 的「道中搬运卡」同一套做法）。
--   **不用 ECL 字节码 VM**：时间轴、出弹、走位全部翻成原生 LuaSTG
--   （`task.Wait` / `enemy` / `enmCreate` 的等价物）。
--
--   数据来源（本段每个数字的出处）
--     · thecl 的原始反汇编（带 TH10 名字表）：
--         thecl -d 10 -r -x -m MAP/th10.eclm stage06.ecl out.txt
--       `main` → callAsync MainSub1 / MainSubBoss；MainSub1..5 是**同一条 ECL
--       敌机上的线程**：`movePos` 改的就是这条敌机，`enmCreate`（相对创建）
--       与 `%FINAL_X/%FINAL_Y` 读的也是它的 `worldMotion.position` —— 下面把它
--       叫「道中锚点」。
--     · TH10 1.00a 复原源码：EnemyEclDispatcher.cpp（enmCreate/A/M/AM、
--       moveVel/moveVelTime/moveCircle、et*）、Enemy.cpp（每敌机 8 个 $I/%F）、
--       EclVm.cpp（jmp 把时钟赋成目标标签的绝对时间、wait 是时钟 −n）。
--
--   只做 Lunatic 行：`diffI/diffF` 取第 4 项、`etCountD/etSpeedD` 取第 4/8 项、
--   `diffWait(a,b,c,d)`（0x170 SUBTRACT_DIFFICULTY_VALUE）取第 4 项 `d`。
--   道中这段没有 rank 缩放（全是 `!*`），逐条照搬即可。
--
--   跳过 / 近似（都写在对应位置）
--     · `MapleEnemy`（main 里一只纯观感敌机，无弹幕）——跳过；
--     · `MainSubBoss`（t≈3669 才出场的 BOSS 本体）——本卡不移植 BOSS；
--     · `setHurtbox/setHitbox/setInvuln/unknown361/flagSet/anm*/playSound/
--       drop*/setChapter` —— 判定/演出类指令：能折成物理量的照做（hitbox→A/B、
--       invuln→protect 计时），其余按无效果处理，但占的 wait 边界原样保留；
--     · 妖精贴图一律 `servant`（本仓库没有 TH10 妖精贴图》；原作 anmSetSprite
--       的两个色号只决定敌人外形，弹幕用不到 ⇒ 只保留 etSprite 的**弹**色号）。
--
--   ★ 三条关键语义（都照复原源码，改代码前先读）
--     · 世界位置 = base + offset；`enmCreate`/`enmCreateA` 都把出生点写进
--       **offsetMotion**（本仓库 `ecs.off`），之后 moveVel/moveVelTime
--       （SET/INTERPOLATE OFFSET POLAR）也只动这一路。
--     · `enmCreateM`（镜像）：给子机置 0x800 标志，只把之后 SET/INTERPOLATE
--       POLAR 的**目标角**过一遍 `a' = wrap(π/2 − wrap(a − π/2))`
--       （EnemyEclDispatcher.cpp:1723/1770），化简即横轴镜像 `a' = wrap(π − a)`；
--       它**不**影响出弹角、圆运动、出生位置。
--     · `moveVelTime(dur, mode, ang, spd)` 对（角, 速度）一起插值，`−999999`
--       表示「不改」；首次进入圆运动时把当前位置存成圆心（照 m_circle）。
--=====================================
do
local s6mid = {}

---镜像角：wrap(π/2 − wrap(a − π/2)) ≡ wrap(π − a)。
local function s6_mirror(a) return t10_wrap(TH10_PI - a) end

---道中锚点（原作 MainSub1..5 共用的那条 ECL 敌机的位置）。
s6mid.ax, s6mid.ay = 0, 0

---击破掉道具（近似：原作 dropMain/dropExtra 是「类型+个数」，本仓库
---`Dropitem_PFP` 用 {信仰, P 个数, 点个数}；这里按原作的大致数量折算）。
s6mid.DROP_CIR = { 0, 0, 1 }        -- Cir 系：dropMain 1/2/3
s6mid.DROP_G1  = { 0, 4, 3 }        -- Girl01：dropExtra(1,4)+dropExtra(2,3)
s6mid.DROP_G2  = { 0, 6, 3 }        -- Girl02：dropExtra(4,2)+dropExtra(1,4)+dropExtra(2,3)
s6mid.DROP_G0  = { 0, 2, 2 }        -- BGirl00：dropExtra(2,2)

---本卡造出来的妖精：卡结束 / 重开（符卡练习）时统一收拾。
s6mid.units = {}
function s6mid.clear()
    for i = 1, #s6mid.units do t10_kill_pod(s6mid.units[i]) end
    s6mid.units = {}
end

---moveVel：SET OFFSET POLAR（镜像时先折角）。
function s6mid.vel(f, ang, spd)
    if f.t10_mir and ang > -999999 then ang = s6_mirror(ang) end
    m_vel(f, "off", ang, spd)
end

---moveVelTime：INTERPOLATE OFFSET POLAR（−999999 = 不改；mode 照本仓库线性近似）。
function s6mid.vel_time(f, dur, mode, ang, spd)
    if f.t10_mir and ang > -999999 then ang = s6_mirror(ang) end
    m_vel_time(f, "off", dur, mode, ang, spd)
end

---moveCircleRel：第一次调用把当前位置存成圆心；−999999 = 保持原值。
---圆运动**不**受镜像影响（原作只镜像极坐标运动的角）。
function s6mid.circle(f, a, av, r, rv)
    local ch = f.ecs.off
    if not ch.circle then ch.cx, ch.cy = ch.x, ch.y end
    ch.circle, ch.interp, ch.scal = true, nil, nil
    if a  > -999999 then ch.ang = a  end
    if av > -999999 then ch.cav = av end
    if r  > -999999 then ch.r   = r  end
    if rv > -999999 then ch.rv  = rv end
end

---当前世界位置（原作坐标系）：frame 与子程序都用它，避免静态字段审计把
---`self.ecs` 判成「init 顶层没赋值」。
function s6mid.pos(f) return f.ecs.wx, f.ecs.wy end

---造一只妖精。`src`（可选）把创建者的 $I/%F 整块拷给子机（原作 enmCreate 的行为）。
function s6mid.spawn(hp, x, y, mirror, drop, sub, src)
    local f = New(class["th10_s6fairy"], hp, x, y, mirror, drop, sub, src)
    s6mid.units[#s6mid.units + 1] = f
    return f
end

---一波 7 只、每隔 16 帧一只（MainSub1a/1b/2a/2b/2c/2d 都是这个形状；
---1a/2a/2c 的第一只在 t0=0、1b/2b/2d 在 t0=8）。位置用**波开始时**的锚点算一次。
function s6mid.wave(card, sub, t0, wx, wy, mirror)
    if t0 > 0 then task.Wait(t0) end
    for i = 1, 7 do
        s6mid.spawn(20, wx, wy, mirror, s6mid.DROP_CIR, sub)
        if i < 7 then task.Wait(16) end
    end
end

---六种波次：子程序 × 相对偏移 × 是否镜像（对照 EnmCreate 的四种变体）。
function s6mid.W1(card)                    -- MainSub1a：enmCreate  BCir00…   y=−24，非镜像
    local x, y = s6mid.ax, s6mid.ay - 24
    task.New(card, function() s6mid.wave(card, "cir00", 0, x, y, false) end)
end
function s6mid.W1b(card)                   -- MainSub1b：enmCreateM BCir00…   y=−24，镜像
    local x, y = s6mid.ax, s6mid.ay - 24
    task.New(card, function() s6mid.wave(card, "cir00", 8, x, y, true) end)
end
function s6mid.W2(card)                    -- MainSub2a：enmCreate  BCir01…     y=0，非镜像
    local x, y = s6mid.ax, s6mid.ay
    task.New(card, function() s6mid.wave(card, "cir01", 0, x, y, false) end)
end
function s6mid.W2b(card)                   -- MainSub2b：enmCreate  BCir01b…    y=0，非镜像
    local x, y = s6mid.ax, s6mid.ay
    task.New(card, function() s6mid.wave(card, "cir01b", 0, x, y, false) end)
end
function s6mid.W2c(card)                   -- MainSub2c：enmCreateAM 落锚点，镜像
    local x, y = s6mid.ax, s6mid.ay
    task.New(card, function() s6mid.wave(card, "cir01", 0, x, y, true) end)
end
function s6mid.W2d(card)                   -- MainSub2d：enmCreateM 落锚点，镜像
    local x, y = s6mid.ax, s6mid.ay
    task.New(card, function() s6mid.wave(card, "cir01b", 8, x, y, true) end)
end

---道中妖精：一个普通敌机（能被打掉、掉道具），位置/出弹都走本文件上面的 ecs 运行时。
---本仓库没有 TH10 妖精贴图 ⇒ 占位 `servant`，直接 `enemybase.init`，不用 `enemy`
---的行走图系统，所以自己写 frame/render（对照 th31.lua 的「道中搬运卡」）。
class["th10_s6fairy"] = Class(enemy, {
    init = function(self, hp, x, y, mirror, drop, sub, src)
        enemybase.init(self, hp, true)          -- nontaijutsu ⇒ GROUP.NONTJT：能打、撞自机不掉血
        self.img = "servant"
        self.hscale, self.vscale = 0.6, 0.6
        self.colli = true
        self.navi, self.bound = false, false
        self.rot = 0
        self._blend, self._a = "", 255
        self.A, self.B = 8, 8                   -- setHitbox(16,16) 的一半
        self.invuln = (sub == "girl01" and 120) or (sub == "girl02" and 600) or 0
        self.protect = self.invuln > 0          -- setInvuln：前 invuln 帧无敌
        self.drop_tbl = drop
        self.t10_mir = mirror and true or false
        ecs_attach(self, x, y)                  -- 建 ecs + 8 个 pattern 槽 + $I/%F
        if src then
            self.I0, self.I1, self.I2, self.I3 = src.I0, src.I1, src.I2, src.I3
            self.F0, self.F1, self.F2, self.F3 = src.F0, src.F1, src.F2, src.F3
        end
        self.seen = false
        ecs_sync(self)
        task.New(self, function() s6mid.BEH[sub](self) end)
    end,
    frame = function(self)
        ecs_step(self)                          -- 原作 EnemyRuntimeUpdate：先解两路 motion
        if self.invuln > 0 then                 -- setInvuln 计时
            self.invuln = self.invuln - 1
            if self.invuln <= 0 then self.protect = false end
        end
        local wx, wy = s6mid.pos(self)
        if not self.seen then                   -- 进过场才算「出屏」基准
            if wx > -192 and wx < 192 and wy > -224 and wy < 224 then self.seen = true end
        elseif wx < -240 or wx > 240 or wy < -280 or wy > 280 then
            t10_kill_pod(self)                  -- 出屏回收（原作 EnemyManagerUpdate）
            return
        end
        enemybase.frame(self)                   -- 判定箱 + hp<=0→Kill + task.Do（跑行为协程）
    end,
    render = function(self) DefaultRenderFunc(self) end,
    kill = function(self)
        if self.drop_tbl then item.Dropitem_PFP(self.x, self.y, self.drop_tbl) end
    end,
    del = function(self) task.Clear(self) end,
})

---=====================================
--- 妖精行为（每个 subtask 一条协程；对照同名 ECL 子程序，只取 Lunatic 行）
---=====================================
s6mid.BEH = {}

---Cir00：MainSub1a/1b 的妖精。BCir/RCir/GCir 只差敌人贴图，弹幕一模一样。
s6mid.BEH.cir00 = function(f)
    s6mid.vel(f, 1.5707964, 3.0)                    -- moveVel(π/2, 3.0)
    task.New(f, function() s6mid.cir00_at(f) end)   -- callAsync("Cir00_at")
    task.Wait(60)                                   -- +60
    s6mid.vel_time(f, 40, 0, -0.7853982, 1.5)       -- moveVelTime(40, 0, −π/4, 1.5)
    -- +6000 delete：原作在此自毁，实际早被出屏回收，不再等。
end

s6mid.cir00_at = function(f)
    et_new(f, 0); et_aim(f, 0, 2); et_sprite(f, 0, 1, 6)
    et_count(f, 0, 11, 1)                           -- etCountD(0, 3,3,7,11, 1,1,1,1) 的 L 行
    et_angle(f, 0, 0.0, 0.06544985)
    et_speed(f, 0, 6.0, 1.0)                        -- etSpeedD(0, 2.4,4.0,5.0,6.0, 1,1,1,1) 的 L 行
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)   -- 记录 0（随即被下一条覆盖）
    et_ex(f, 0, 0, 1, 1, -999999, -999999, -999999.0, -999999.0)   -- 记录 0 = DECEL
    local w = t10_rand_mod60() + 30                 -- wait(($RAND%60)+30)
    if w > 0 then task.Wait(w) end
    while true do
        fire_slot(f, 0)                             -- etOn(0)
        t10_rand_mod60()                            -- diffWait 第 1 参：L 行用不到，但原作要消耗
        task.Wait(20)                               -- diffWait(…, 60, 30, 20) 的 L 行
    end
end

---Cir01：MainSub2a/2c 的妖精（2c 镜像）。
s6mid.BEH.cir01 = function(f)
    s6mid.vel(f, 0.0, 4.0)
    task.New(f, function() s6mid.cir01_at(f) end)
    task.Wait(60)
    s6mid.vel_time(f, 40, 0, -0.3926991, -999999)   -- 角 → −0.3926991，速度保持 4.0
end

---Cir01b：MainSub2b/2d 的妖精（2d 镜像）。出弹与 Cir01 相同，只差 +60 那条 moveVelTime。
s6mid.BEH.cir01b = function(f)
    s6mid.vel(f, 0.0, 4.0)
    task.New(f, function() s6mid.cir01_at(f) end)
    task.Wait(60)
    s6mid.vel_time(f, 40, 0, 0.3926991, 1.5)        -- 角 → +0.3926991，速度 → 1.5
end

s6mid.cir01_at = function(f)
    et_new(f, 0); et_aim(f, 0, 2); et_sprite(f, 0, 3, 6)
    et_count(f, 0, 48, 3)                           -- etCountD(0, 24,48,48,48, 1,1,2,3) 的 L 行
    et_angle(f, 0, 0.0, 0.0)
    et_speed(f, 0, 3.0, 1.0)                        -- etSpeedD(0, 1.0,1.0,2.0,3.0, 1,1,1,1) 的 L 行
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 0, 1, 1, -999999, -999999, -999999.0, -999999.0)
    task.Wait(60 + t10_rand_mod60())                -- wait(60 + %RAND%60)
    while true do
        fire_slot(f, 0)
        task.Wait(60)
    end
end

---Girl01：MainSub3 在锚点 (0,0) 处 enmCreate ⇒ 落点 (0,−24)。
---时间轴：t=60 起枪、t=120/180 再各撒一次、t=240 减速下移并 killAllAsync。
s6mid.BEH.girl01 = function(f)
    s6mid.vel(f, 1.5707964, 5.0)
    s6mid.vel_time(f, 60, 4, -999999, 0.0)          -- 60 帧内 5→0（悬停）
    task.Wait(60)
    f.F0 = rndrad(); f.F1 = 0.05236
    task.New(f, function() s6mid.girl01_at(f) end)
    task.New(f, function() s6mid.girl01_at2(f, 6, 0.0, 0.049087387) end)
    task.New(f, function() s6mid.girl01_at2(f, 2, TH10_PI, -0.049087387) end)
    task.Wait(60)                                   -- +60 → //120
    f.F0 = rndrad(); f.F1 = -0.05236
    task.New(f, function() s6mid.girl01_at(f) end)
    task.Wait(60)                                   -- +60 → //180
    f.F0 = rndrad(); f.F1 = 0.05236
    task.New(f, function() s6mid.girl01_at(f) end)
    task.Wait(60)                                   -- +60 → //240
    s6mid.vel_time(f, 40, 4, 1.5707964, 2.0)
    t10_kill_async(f)                               -- killAllAsync：停掉这只妖精的其它线程
end

---Girl01_at：原地撒 4 只 BGirl00（占位妖精、不出弹），每撒一只 %F0 += π/2。
s6mid.girl01_at = function(f)
    for _ = 1, 4 do
        s6mid.spawn(120, f.ecs.wx, f.ecs.wy, false, s6mid.DROP_G0, "girl00", f)
        f.F0 = f.F0 + 1.570796
    end
end

---Girl01_at2(A, B, C)：固定扇（aim=5）×8 发 ×2 圈，每轮角 += C。
---A 只当弹色号（原作 etSprite(0, 5, $A)）；B 每轮都 validRad 归一。
s6mid.girl01_at2 = function(f, A, B, C)
    et_new(f, 0); et_aim(f, 0, 5); et_sprite(f, 0, 5, A)
    et_count(f, 0, 8, 2)                            -- etCountD(0, 8,8,8,8, 1,1,2,2) 的 L 行
    et_angle(f, 0, B, 0.0)
    et_speed(f, 0, 5.0, 2.8)                        -- etSpeedD(0, 1.5,2.8,3.5,5.0, 0.8,0.8,2.8,2.8) 的 L 行
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    while true do
        et_angle(f, 0, B, 0.0)
        fire_slot(f, 0)                             -- etOn(0)
        B = t10_wrap(B + C)                         -- $B += $C; validRad($B)
        task.Wait(8)
    end
end

---Girl00 / BGirl00：纯占位妖精（**不出弹**）。
---moveCircleRel(%F0, %F1, 0, 1.5) 起旋 → +40 半径冻结 → +100 朝自机 → +160 减速到 2。
s6mid.BEH.girl00 = function(f)
    s6mid.circle(f, f.F0, f.F1, 0.0, 1.5)
    task.Wait(40)                                   -- +40
    s6mid.circle(f, -999999, f.F1, -999999, 0.0)    -- 半径冻结（角速度继续）
    task.Wait(60)                                   -- +60 → //100
    s6mid.vel(f, t10_angle_player(f), 0.0)          -- moveVel(%ABS_ANGLE_PLAYER, 0)
    s6mid.vel_time(f, 60, 0, -999999, 2.0)
    -- +60 flagClear(4)：无效果。
end

---Girl02：MainSub5 末尾在锚点 (0,0) 处 enmCreate ⇒ 落点 (0,−24)。
---t=60 起 Girl02_at（6 轮 × 120 帧），t=760 开始上飘。
s6mid.BEH.girl02 = function(f)
    s6mid.vel(f, 1.5707964, 5.0)
    s6mid.vel_time(f, 60, 4, -999999, 0.0)
    task.Wait(60)                                   -- +60
    task.New(f, function() s6mid.girl02_at(f) end)
    task.Wait(700)                                  -- +700 → //760
    s6mid.vel_time(f, 40, 4, -1.5707964, 1.0)       -- moveVelTime(40, 4, −π/2, 1.0)
end

---Girl02_at：槽 1 的双环。6 轮，每轮先「角 += RANDRAD/80 + π/80」的 AB 段 60 帧、
---再「角 −= RANDRAD/80 + π/80」的 CD 段 60 帧；每帧两拍、每拍 2 发。
---★ 随机数**消耗顺序**是行为的一部分（每帧 2×%RANDRAD + 4×%RANDF2），不能交换。
s6mid.girl02_at = function(f)
    et_new(f, 1); et_aim(f, 1, 3); et_sprite(f, 1, 0, 2)
    et_count(f, 1, 2, 1)                            -- etCountD(1, 1,1,2,2, 1,1,1,1) 的 L 行
    et_angle(f, 1, 0.0, TH10_PI)
    et_speed(f, 1, 3.2, 1.0)                        -- etSpeedD(1, 1.2,1.2,2.2,3.2, 1,1,1,1) 的 L 行
    et_ex(f, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 1, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    for _ = 1, 6 do
        local c = rndrad()                          -- %C = %RANDRAD
        et_sprite(f, 1, 0, 4)
        for _ = 1, 60 do                            -- AB 段（$A=60 次 deci）
            task.Wait(1)
            c = c + (rndrad() / 80 + TH10_PI / 80)
            et_angle(f, 1, c, 0.0)
            local ox = rnd2() * 32
            local oy = rnd2() * 32
            et_offset(f, 1, ox, oy)
            fire_slot(f, 1)
            c = c + (rndrad() / 80 + TH10_PI / 80)
            et_angle(f, 1, c, 0.0)
            ox = rnd2() * 32
            oy = rnd2() * 32
            et_offset(f, 1, ox, oy)
            fire_slot(f, 1)
        end
        c = rndrad()
        et_sprite(f, 1, 0, 6)
        for _ = 1, 60 do                            -- CD 段
            task.Wait(1)
            c = c - (rndrad() / 80 + TH10_PI / 80)
            et_angle(f, 1, c, 0.0)
            local ox = rnd2() * 32
            local oy = rnd2() * 32
            et_offset(f, 1, ox, oy)
            fire_slot(f, 1)
            c = c - (rndrad() / 80 + TH10_PI / 80)
            et_angle(f, 1, c, 0.0)
            ox = rnd2() * 32
            oy = rnd2() * 32
            et_offset(f, 1, ox, oy)
            fire_slot(f, 1)
        end
    end
    et_offset(f, 1, 0.0, 0.0)
end

---=====================================
--- 道中时间轴（MainSub1..5，锚点每 115 帧左右跳一次）
---   相对 MainSub1 的 t=0：160/275/390 三波 → 505 交 MainSub2
---   → +300/+415/+530/+645 → 交 MainSub3 → +200 出 Girl01、交 MainSub4
---   → +200/+315/+430/+545 → 交 MainSub5 → +160/+275/+390/+505、+40 出 Girl02。
---=====================================
s6mid.sub1 = function(card)
    s6mid.ax, s6mid.ay = 0, 0
    task.Wait(160)                                  -- //160
    s6mid.W1(card); s6mid.W1b(card)
    task.Wait(115)                                  -- //275
    s6mid.ax = -140
    s6mid.W1(card); s6mid.W1b(card)
    task.Wait(115)                                  -- //390
    s6mid.ax = 140
    s6mid.W1(card); s6mid.W1b(card)
    task.Wait(115)                                  -- //505
    s6mid.ax = 0
    task.New(card, function() s6mid.sub2(card) end) -- callAsync("MainSub2")
end

s6mid.sub2 = function(card)
    task.Wait(300)                                  -- //300
    s6mid.ax, s6mid.ay = -224, 64
    s6mid.W2(card); s6mid.W2b(card)
    task.Wait(115)                                  -- //415
    s6mid.ax, s6mid.ay = 224, 96
    s6mid.W2c(card); s6mid.W2d(card)                -- 2c/2d 落点 = 当时锚点
    task.Wait(115)                                  -- //530
    s6mid.ax, s6mid.ay = -224, 128
    s6mid.W2(card); s6mid.W2b(card)
    task.Wait(115)                                  -- //645
    s6mid.ax, s6mid.ay = 224, 32
    s6mid.W2c(card); s6mid.W2d(card)
    task.New(card, function() s6mid.sub3(card) end) -- callAsync("MainSub3")
end

s6mid.sub3 = function(card)
    task.Wait(200)                                  -- //200
    s6mid.ax, s6mid.ay = 0, 0
    s6mid.spawn(400, 0, -24, false, s6mid.DROP_G1, "girl01")   -- enmCreate("Girl01", 0, −24)
    task.New(card, function() s6mid.sub4(card) end) -- callAsync("MainSub4")
end

s6mid.sub4 = function(card)
    task.Wait(200)                                  -- //200
    s6mid.ax = -96; s6mid.ay = 0
    s6mid.W1(card); s6mid.W1b(card)
    task.Wait(115)                                  -- //315
    s6mid.ax = 96
    s6mid.W1(card); s6mid.W1b(card)
    task.Wait(115)                                  -- //430
    s6mid.ax = -128
    s6mid.W1(card); s6mid.W1b(card)
    task.Wait(115)                                  -- //545
    s6mid.ax = 0
    task.New(card, function() s6mid.sub5(card) end) -- callAsync("MainSub5")
end

s6mid.sub5 = function(card)
    task.Wait(160)                                  -- //160
    s6mid.ax, s6mid.ay = -224, 64
    s6mid.W2(card); s6mid.W2b(card)
    task.Wait(115)                                  -- //275
    s6mid.ax, s6mid.ay = 224, 96
    s6mid.W2c(card); s6mid.W2d(card)
    task.Wait(115)                                  -- //390
    s6mid.ax, s6mid.ay = -224, 128
    s6mid.W2(card); s6mid.W2b(card)
    task.Wait(115)                                  -- //505
    s6mid.ax, s6mid.ay = 224, 32
    s6mid.W2c(card); s6mid.W2d(card)
    task.Wait(40)                                   -- //545
    s6mid.ax, s6mid.ay = 0, 0
    s6mid.spawn(1500, 0, -24, false, s6mid.DROP_G2, "girl02")  -- enmCreate("Girl02", 0, −24)
end

---main：原作的 MainSubBoss（t≈3669 才登场的 BOSS 本体）不移植。
s6mid.main = function(card)
    task.New(card, function() s6mid.sub1(card) end)
end

---=========================== 挂到空 boss 的一张符卡 ===========================
local BOSS_NAME = "道中"
local CARD_NAME = "六面道中「妖怪之山的妖精」"
---时长：最后一发弹（Girl02 的双环）在道中开始后约 3220 帧收尾 ⇒ 56 秒留余量。
local CARD_TIME = 56
---符卡历史槽位（spell_card_data 的键 + 练习解锁号）：跨关卡唯一，取 3671
---（见 th35.lua 文件头的注册清单；已用 3500/3600/3601..3625/3630..3670）。
local CARD_ID = 3671

---BGM/背景沿用 TH10 六面（同本文件其它 stage06 卡）；空 boss 用 `img_void` 不显形。
boss.Define("aa", BOSS_NAME, "TH10_2", TH10_bg, { 0, 400 }, nil, "img_void", LEVEL)

local card = boss.card.New(CARD_NAME, CARD_TIME, CARD_TIME, CARD_TIME, 10000000)
function card:before()
    ---耐久卡（t1=t2=t3 ⇒ time_sc、伤害恒 0）：不打超时音、关掉本体判定与血条。
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
end
function card:init()
    s6mid.clear()                                   -- 重开（符卡练习）时先清上一局残留
    s6mid.ax, s6mid.ay = 0, 0
    s6mid.main(self)
end
function card:frame() end
function card:render() end
function card:del() s6mid.clear() end

boss.card.add({ { card, "aa" } }, LEVEL, CARD_NAME, CARD_ID)
end
--=====================================
-- 十、stage01 道中（妖精群）—— 原生 LuaSTG「道中搬运卡」
--   把 `stage01.ecl` 的 main 道中段复刻成一张符卡（跳过 MapleEnemy / 中 BOSS 静葉 /
--   Boss 本体 —— 中 BOSS 与 BOSS 已有各自的卡）。走共用的 t10mid 妖精框架。
--   数据：thecl -d 10 -r -x -j -m th10.eclm stage01.ecl 反汇编。
--   只做 Lunatic：`diffI/diffF` 取第 4 项、`!L` 块。
--   妖精贴图一律 servant（本仓库无 TH10 妖精贴图）；弹色号照抄 etSprite 第 2 参。
--   近似：原作 e/n/h 的 etCount/etSpeed 分支不写；drop* 折算成 Dropitem_PFP 表。
--=====================================
t10mid.s01 = {}

---Ecl_Girl00（Ecl_R/B/G 三种色共用）：朝自机冲 7 帧速 60 帧抬到 0，60 帧后起枪。
t10mid.s01.eclg_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 3, 6)
    et_count(f, 0, 3, 1); et_angle(f, 0, 0.0, 0.09817477); et_speed(f, 0, 4.5, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    while true do fire_slot(f, 0); task.Wait(10) end
end
t10mid.s01.eclg = function(f)
    t10mid.vel(f, t10_angle_player(f), 7.0)
    t10mid.vel_time(f, 60, 4, t10_angle_player(f), 0.0)
    task.Wait(60)
    task.New(f, function() t10mid.s01.eclg_at(f) end)
    task.Wait(200)
    t10mid.vel(f, t10_angle_player(f) + TH10_PI, 0.0)
    t10mid.vel_time(f, -1, 7, 0.0, 0.03)
    while true do task.Wait(60) end
end

---RGirl00_at：固定扇形（aim=0）×1 发，每 4 帧一轮、20 轮。
t10mid.s01.ga = function(f)
    et_new(f, 0); et_sprite(f, 0, 2, 6); et_aim(f, 0, 0); et_angle(f, 0, 0.0, 0.19634955)
    et_count(f, 0, 1, 1); et_speed(f, 0, 4.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    for _ = 1, 20 do task.Wait(4); fire_slot(f, 0) end
end
---Girl00 基型：直下 2.7，60 帧抬到 0；RGirl00B/GGirl00 同型（色不同）。
t10mid.s01.g0 = function(f)
    task.New(f, function() t10mid.s01.ga(f) end)
    t10mid.vel(f, 1.5707964, 2.7)
    task.Wait(60)
    t10mid.vel_time(f, 60, 0, 0.0, -999999)
end

---Girl00B_at：先等 $RAND%10，再 15 轮（等 I4=8 帧、开火）。
t10mid.s01.gb_at = function(f)
    et_new(f, 0); et_sprite(f, 0, 2, 6); et_aim(f, 0, 0); et_angle(f, 0, 0.0, 0.19634955)
    et_count(f, 0, 1, 1); et_speed(f, 0, 3.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    local w = t10_imod(t10_randmod(), 10)
    if w > 0 then task.Wait(w) end
    for _ = 1, 15 do task.Wait(8); fire_slot(f, 0) end
end
t10mid.s01.g0b = function(f)
    t10mid.vel(f, 1.5707964, 2.7)
    task.New(f, function() t10mid.s01.gb_at(f) end)
    task.Wait(60)
    t10mid.vel_time(f, 60, 0, 0.0, -999999)
end

---Girl00C：直下 7.0 → 60 帧减速到 0；60 帧后打一梭 9 发环，180 帧转向、慢飘。
t10mid.s01.g0c = function(f)
    t10mid.vel(f, 1.5707964, 7.0)
    t10mid.vel_time(f, 60, 4, -999999, 0.0)
    task.Wait(60)
    et_new(f, 0); et_sprite(f, 0, 1, 6); et_aim(f, 0, 0); et_angle(f, 0, 0.0, 0.19634955)
    et_count(f, 0, 9, 1); et_speed(f, 0, 2.5, 2.5)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    fire_slot(f, 0)
    task.Wait(120)
    t10mid.vel(f, t10_angle_player(f) + TH10_PI, 0.0)
    t10mid.vel_time(f, -1, 7, 0.0, 0.03)
    while true do task.Wait(60) end
end

---RGirl00D_at：60 帧后打 2 梭（aim=2 环 ×20 发）。
t10mid.s01.gd_at = function(f)
    et_new(f, 0); et_sprite(f, 0, 0, 6); et_aim(f, 0, 2); et_angle(f, 0, 0.0, 0.19634955)
    et_count(f, 0, 20, 1); et_speed(f, 0, 1.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    for _ = 1, 2 do task.Wait(60); fire_slot(f, 0) end
end
---Girl00D：直下 6.0、60 帧减速停；60 帧后改 -π/2 慢速 0.5。
t10mid.s01.g0d = function(f)
    t10mid.vel(f, 1.5707964, 6.0)
    t10mid.vel_time(f, 60, 0, 0.0, 0.0)
    task.New(f, function() t10mid.s01.gd_at(f) end)
    task.Wait(60)
    t10mid.vel(f, -1.5707964, 0.5)
    while true do task.Wait(6000) end
end

---RGirl00E_at：9 轮（等 10 帧、开火），每轮 1 发环。
t10mid.s01.ge_at = function(f)
    et_new(f, 0); et_sprite(f, 0, 2, 6); et_aim(f, 0, 0); et_angle(f, 0, 0.0, 0.19634955)
    et_count(f, 0, 1, 1); et_speed(f, 0, 1.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    for _ = 1, 9 do task.Wait(10); fire_slot(f, 0) end
end
t10mid.s01.g0e = function(f)
    task.New(f, function() t10mid.s01.ge_at(f) end)
    t10mid.vel(f, 1.5707964, 1.8)
    task.Wait(60)
    t10mid.vel_time(f, 60, 0, -999999, -999999)
    while true do task.Wait(6000) end
end

---Girl01_at：一梭 11 次「发数递增」的固定扇（发数 I0 从 1 起），每次隔 4 帧；循环。
t10mid.s01.g1_at = function(f)
    while true do
        et_new(f, 0); et_aim(f, 0, 1); et_sprite(f, 0, 3, 4)
        et_angle(f, 0, t10_angle_player(f), 0.049087387)
        et_speed(f, 0, 4.0, 0.0)
        et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
        et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
        local i0 = 1
        for _ = 1, 11 do
            et_count(f, 0, i0, 1); fire_slot(f, 0)
            i0 = i0 + 1
            task.Wait(4)
        end
        task.Wait(20)
    end
end
---Girl01：入场直下 5.0、60 帧停；起枪后转向 2.7488935 用 180 帧降到 0.005。
t10mid.s01.g1 = function(f)
    t10mid.vel(f, 1.5707964, 5.0)
    t10mid.vel_time(f, 60, 4, -999999, 0.0)
    task.Wait(60)
    task.New(f, function() t10mid.s01.g1_at(f) end)
    t10mid.vel(f, 2.7488935, 0.0)
    t10mid.vel_time(f, 180, 7, 0.0, 0.005)
    task.Wait(180)
    while true do task.Wait(6000) end
end

---道中时间轴（wallframe = 各 +N 之和；镜像 = enmCreate*M）。
t10mid.s01.run = function(card)
    local B, D = t10mid.s01, t10mid.D1
    local x
    task.Wait(160)
    -- 9 只 Ecl_*（x=-144 起、步 32）+ 末尾 1 只 Ecl_G（x=144）
    x = -144
    for i = 0, 9 do
        t10mid.spawn(20, x, -16, false, D, B.eclg)
        x = x + 32
        if i < 9 then task.Wait(20) end
    end
    -- 左右两波 Girl00 系（右半镜像）
    task.Wait(300)
    t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(20); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(20); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(20); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(80); t10mid.spawn(20,  144, -64, true,  D, B.g0)
    task.Wait(20); t10mid.spawn(20,  144, -64, true,  D, B.g0)
    task.Wait(20); t10mid.spawn(20,  144, -64, true,  D, B.g0)
    task.Wait(20); t10mid.spawn(20,  144, -64, true,  D, B.g0)
    task.Wait(20); t10mid.spawn(20,  144, -64, true,  D, B.g0)
    task.Wait(60); t10mid.spawn(300,  64, -16, false, t10mid.D2, B.g1)
    task.Wait(100); t10mid.spawn(20,  144, -64, true,  D, B.g0)
    task.Wait(10); t10mid.spawn(20,  144, -64, true,  D, B.g0)
    task.Wait(10); t10mid.spawn(20,  144, -64, true,  D, B.g0)
    task.Wait(10); t10mid.spawn(20,  144, -64, true,  D, B.g0)
    task.Wait(10); t10mid.spawn(20,  144, -64, true,  D, B.g0)
    task.Wait(60); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(60); t10mid.spawn(300, -64, -16, true, t10mid.D2, B.g1)
    task.Wait(120)
    -- 第二段斜列（x=144 起、步 -32）+ 末尾 Ecl_G（x=-144）
    x = 144
    for i = 0, 9 do
        t10mid.spawn(20, x, -16, false, D, B.eclg)
        x = x - 32
        if i < 9 then task.Wait(20) end
    end
    task.Wait(80); t10mid.spawn(20, 144, -64, true, D, B.g0)      -- AM GGirl00 + 起 MainSub
    task.Wait(20); t10mid.spawn(20,  84, -64, true, D, B.g0b)
    task.Wait(20); t10mid.spawn(20,  84, -64, true, D, B.g0b)
    task.Wait(20); t10mid.spawn(20,  84, -64, true, D, B.g0b)
    task.Wait(20); t10mid.spawn(20,  84, -64, true, D, B.g0b)
    task.Wait(20); t10mid.spawn(20,  84, -64, true, D, B.g0b)
    task.Wait(20); t10mid.spawn(20,  24, -64, true, D, B.g0)
    task.Wait(20); t10mid.spawn(20,  24, -64, true, D, B.g0)
    task.Wait(20); t10mid.spawn(20,  24, -64, true, D, B.g0)
    task.Wait(20); t10mid.spawn(20,  24, -64, true, D, B.g0)
    task.Wait(20); t10mid.spawn(20,  24, -64, true, D, B.g0)
    task.Wait(200); t10mid.spawn(300, 64, -16, false, t10mid.D2, B.g1)
    task.Wait(10); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20, -144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20,  144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20,  144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20,  144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20,  144, -64, false, D, B.g0)
    task.Wait(10); t10mid.spawn(20,  144, -64, false, D, B.g0)
    task.Wait(80)
    for _, px in ipairs({ -48, 0, 48 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    task.Wait(20)
    for _, px in ipairs({ -72, -24, 24, 72 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    task.Wait(20)
    for _, px in ipairs({ -96, -48, 48, 96 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    task.Wait(20)
    for _, px in ipairs({ -120, -72, 72, 120 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    task.Wait(20)
    for _, px in ipairs({ -144, -96, 96, 144 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    task.Wait(20)
    for _, px in ipairs({ -168, -120, 120, 168 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    task.Wait(160)                                   -- MapleEnemy + 中 BOSS 静葉：跳过
    -- RGirl00D 波（每 80 帧一波、左右交替，后两波多掉 1）
    local dx, dm = -144, false
    task.Wait(400)
    for i = 1, 10 do
        t10mid.spawn(160, dx, -16, dm, (i >= 9) and t10mid.D2 or D, B.g0d)
        dx, dm = -dx, not dm
        if i < 10 then task.Wait(80) end
    end
    task.Wait(100); t10mid.spawn(300,  64, -16, false, t10mid.D2, B.g1)
                    t10mid.spawn(300, -64, -16, true,  t10mid.D2, B.g1)
    task.Wait(160)
    -- 20 只 Ecl_*E：x 每只随机 %RANDF2×128
    for i = 0, 19 do
        t10mid.spawn(20, rnd2() * 128, -16, false, D, B.g0e)
        task.Wait(10)
    end
    task.Wait(60); t10mid.spawn(300,  128, -16, false, t10mid.D2, B.g1)
                    t10mid.spawn(300, -128, -16, true,  t10mid.D2, B.g1)
    task.Wait(80); t10mid.spawn(20,  84, -64, true, D, B.g0b)
    task.Wait(10); t10mid.spawn(20,  84, -64, true, D, B.g0b)
    task.Wait(10); t10mid.spawn(20,  84, -64, true, D, B.g0b)
    task.Wait(10); t10mid.spawn(20,  84, -64, true, D, B.g0b)
    task.Wait(10); t10mid.spawn(20,  84, -64, true, D, B.g0b)
    task.Wait(100)
    for _, px in ipairs({ -48, 0, 48 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    task.Wait(20)
    for _, px in ipairs({ -72, -24, 24, 72 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    task.Wait(20)
    for _, px in ipairs({ -96, -48, 48, 96 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    task.Wait(20)
    for _, px in ipairs({ -120, -72, 72, 120 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    task.Wait(20)
    for _, px in ipairs({ -144, -96, 96, 144 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    task.Wait(20)
    for _, px in ipairs({ -168, -120, 120, 168 }) do t10mid.spawn(20, px, -16, false, D, B.g0c) end
    -- +400 后 Boss 本体：不移植 ⇒ 本卡到此结束
end

---挂到空 boss「ba」上的一张耐久符卡（与 stage06 道中同一套注册方式）。
boss.Define("ba", "道中", "TH10_1", TH10_bg, { 0, 400 }, nil, "img_void", LEVEL)
t10mid.s01card = boss.card.New("一道中「初雪之妖精」", 84, 84, 84, 10000000)
function t10mid.s01card:before()
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
end
function t10mid.s01card:init()
    t10mid.clear(); t10mid.ax, t10mid.ay = 0, 0
    task.New(self, function() t10mid.s01.run(self) end)
end
function t10mid.s01card:frame() end
function t10mid.s01card:render() end
function t10mid.s01card:del() t10mid.clear() end
boss.card.add({ { t10mid.s01card, "ba" } }, LEVEL, "一道中「初雪之妖精」", 3680)

--=====================================
-- 十一、stage02 道中（妖精群）—— 原生 LuaSTG「道中搬运卡」
--   把 `stage02.ecl` 的 main 道中段复刻成一张符卡（跳过 MapleEnemy / MBossDummy /
--   Boss 本体 —— 中 BOSS 与 BOSS 已有各自的卡）。走共用的 t10mid 妖精框架。
--   数据：thecl -d 10 -r -x -j -m th10.eclm stage02.ecl 反汇编。
--   只做 Lunatic：`diffI/diffF` 取第 4 项、`!L` 块；`!HL`（H/L 共有）也照做。
--   近似：妖精贴图一律 servant；dropMain(1/2/3) 折成 D1/D2；anm* 只当纯视觉。
--   `enmCreateF/AF/MF/AMF` = 「无 BOSS 时才创建」；本卡不建 BOSS ⇒ 条件恒真。
--=====================================
t10mid.s02 = {}

---RGirl00_at：12 轮×4 帧的自机狙螺旋。基准角初值 %RANDRAD、每轮 +π/10；
---出弹点在半径 [16] 的圆上（每轮 +6，从 0 起）、速度每轮 +0.4（从 3.0 起）；
---每轮 3 发（L）、扇形步长 π/4。
t10mid.s02.rg00_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 2, 6); et_count(f, 0, 1, 1)
    et_angle(f, 0, 0.0, 0.7853982); et_speed(f, 0, 2.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    local a, r, sp = rndrad(), 0.0, 3.0
    for _ = 1, 12 do
        et_count(f, 0, 3, 1)
        et_speed(f, 0, sp, sp)
        et_offset(f, 0, math.cos(a) * r, math.sin(a) * r)
        task.Wait(4); fire_slot(f, 0)
        a = t10_wrap(a + 0.314159); r = r + 6.0; sp = sp + 0.4
    end
end

---RGirl00D_at：同型螺旋，但 16 轮、每轮 1 发（角步长 0，纯半径螺旋）、
---半径每轮 +4（从 0 起）、速度 1.5 起每轮 +0.1；基准角仍每轮 +π/10。
t10mid.s02.rg00d_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 2, 6); et_count(f, 0, 1, 1)
    et_angle(f, 0, 0.0, 0.0); et_speed(f, 0, 2.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    local a, r, sp = rndrad(), 0.0, 1.5
    for _ = 1, 16 do
        et_speed(f, 0, sp, sp)
        et_offset(f, 0, math.cos(a) * r, math.sin(a) * r)
        task.Wait(4); fire_slot(f, 0)
        a = t10_wrap(a + 0.314159); r = r + 4.0; sp = sp + 0.1
    end
end

---Girl00 / Girl00D：直下（初速 %RANDF·2+5.5）、40 帧减速到 0；同时起 _at 螺旋；
---100 帧后把角拉到 π/8+%RANDF2·0.4、40 帧加速到 2.7。两者只差 _at 子程序。
t10mid.s02.dive = function(f, atfn)
    t10mid.vel(f, 1.5707964, rnd() * 2.0 + 5.5)
    t10mid.vel_time(f, 40, 4, -999999, 0.0)
    task.New(f, function() atfn(f) end)
    task.Wait(100)
    t10mid.vel_time(f, 40, 4, 0.3926991 + rnd2() * 0.4, 2.7)
    while true do task.Wait(6000) end
end
t10mid.s02.g00  = function(f) t10mid.s02.dive(f, t10mid.s02.rg00_at)  end
t10mid.s02.g00d = function(f) t10mid.s02.dive(f, t10mid.s02.rg00d_at) end

---Girl00B_at：5 发扇形（L：速度 4、扇形步长 π/8、aim=0 自机狙）；
---第 0/10/20/30/40/50 帧各一梭（`!L etOn` 是 L 多出来的那一梭）。
t10mid.s02.g00b_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 1, 6); et_count(f, 0, 5, 1)
    et_angle(f, 0, 0.0, 0.3926991); et_speed(f, 0, 4.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    fire_slot(f, 0)
    for _ = 1, 5 do task.Wait(10); fire_slot(f, 0) end
end

---Girl00B：直下 4.7；60 帧内把角拉到 π/8+%RANDF2·0.4（速度降到 0）；
---再过 60 帧加速到 4.0，并起 Girl00B_at。
t10mid.s02.g00b = function(f)
    t10mid.vel(f, 1.5707964, 4.7)
    t10mid.vel_time(f, 60, 0, 0.3926991 + rnd2() * 0.4, 0.0)
    task.Wait(60)
    t10mid.vel_time(f, 60, 0, -999999, 4.0)
    task.New(f, function() t10mid.s02.g00b_at(f) end)
    while true do task.Wait(6000) end
end

---RGirl00C_at：60 帧后两梭。槽 0（H/L）：9 层、每层 1 发自机狙，速度 4.0→1.0；
---槽 1：L 行 3 层×12 发（角步长 0.24166097、速度 3.5）。两槽都只打一帧。
t10mid.s02.rg00c_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 24, 6); et_count(f, 0, 1, 9)
    et_angle(f, 0, 0.0, 0.0); et_speed(f, 0, 4.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    et_new(f, 1); et_aim(f, 1, 0); et_sprite(f, 1, 2, 6); et_count(f, 1, 12, 3)
    et_angle(f, 1, 0.0, 0.24166097); et_speed(f, 1, 3.5, 1.0)
    et_ex(f, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 1, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    task.Wait(60)
    fire_slot(f, 0)
    fire_slot(f, 1)
end

---Girl00C：直下 4.7 → 60 帧内把角拉到 π/4（速度 →0）→ 再 60 帧加速到 2.0；
---160 帧起 moveVel(π/8, 2.7)；同时起 RGirl00C_at。
t10mid.s02.g00c = function(f)
    task.New(f, function() t10mid.s02.rg00c_at(f) end)
    t10mid.vel(f, 1.5707964, 4.7)
    t10mid.vel_time(f, 60, 0, 0.7853982, 0.0)
    task.Wait(60)
    t10mid.vel_time(f, 60, 0, -999999, 2.0)
    task.Wait(100)
    t10mid.vel(f, 0.3926991, 2.7)
    while true do task.Wait(6000) end
end

---Girl01_at：每 7 帧一梭「对称扇形」——第 k 轮 k 发（k=1..9），第 j 发角为
---ANGLE_PLAYER−(k−1)·0.098175+j·0.19635（同一帧内打完）；弹在 90 帧后按 rec2
---折角（角增量 [8]=0.19635·(k−1)−j·0.392699）、速度恒 2.8。整轮无限循环。
t10mid.s02.g01_at = function(f)
    while true do
        if f.s02_g01_stop then return end
        local a0 = t10_angle_player(f)
        et_new(f, 0); et_aim(f, 0, 1); et_sprite(f, 0, 3, 3); et_count(f, 0, 1, 1)
        et_angle(f, 0, a0, 0.09817477); et_speed(f, 0, 3.0, 0.0)
        et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
        et_ex(f, 0, 1, 0, -2147483648, -999999, -999999, -999999.0, -999999.0)
        et_ex(f, 0, 3, 0, 16384, 3, 13, -999999.0, -999999.0)
        for k = 1, 9 do
            local a = a0 - 0.098175 * (k - 1)
            local b = 0.19635 * (k - 1)
            for _ = 1, k do
                et_ex(f, 0, 2, 0, 64, 90, 1, b, 2.8)
                et_angle(f, 0, a, 0.0)
                fire_slot(f, 0)
                a = t10_wrap(a + 0.19635)
                b = b - 0.392699
            end
            task.Wait(7)
        end
    end
end

---Girl01：从 (±224, 32) 斜插（7π/8、5.0 → 60 帧降到 1.0）；60 帧起 Girl01_at；
---340 帧 killAsync(0) 停火，本体留到约 6340 帧。
t10mid.s02.g01 = function(f)
    t10mid.vel(f, 2.7488935, 5.0)
    t10mid.vel_time(f, 60, 4, -999999, 1.0)
    task.Wait(60)
    f.s02_g01_stop = false
    task.New(f, function() t10mid.s02.g01_at(f) end)
    task.Wait(280)
    f.s02_g01_stop = true
    while true do task.Wait(6000) end
end

---Girl02_at：双槽（基准角 ±1.570796 对称）每 2 帧一梭；每梭 [8]=4 层×1 发、
---角步长 0.09817477、速度 5.0→1.0；两槽基准角每梭分别 +/−0.1309。
t10mid.s02.g02_at = function(f)
    et_new(f, 0); et_aim(f, 0, 1); et_sprite(f, 0, 6, 4); et_count(f, 0, 1, 4)
    et_angle(f, 0, -1.570796, 0.09817477); et_speed(f, 0, 5.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_new(f, 1); et_aim(f, 1, 1); et_sprite(f, 1, 6, 4); et_count(f, 1, 1, 4)
    et_angle(f, 1, -1.570796, 0.09817477); et_speed(f, 1, 5.0, 1.0)
    et_ex(f, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local a0, a1 = -1.570796, -1.570796
    while true do
        if f.s02_g02_stop then return end
        et_angle(f, 0, a0, 0.09817477); fire_slot(f, 0)
        et_angle(f, 1, a1, 0.09817477); fire_slot(f, 1)
        a0 = t10_wrap(a0 + 0.1309)
        a1 = t10_wrap(a1 - 0.1309)
        task.Wait(2)
    end
end

---Girl02：从 (0,−32)/(±96/112) 直下 10.0、40 帧降到 0；40 帧起 Girl02_at；
---320 帧 killAsync(0)，本体留到约 6320 帧。
t10mid.s02.g02 = function(f)
    t10mid.vel(f, 1.5707964, 10.0)
    t10mid.vel_time(f, 40, 4, -999999, 0.0)
    task.Wait(40)
    f.s02_g02_stop = false
    task.New(f, function() t10mid.s02.g02_at(f) end)
    task.Wait(280)
    f.s02_g02_stop = true
    while true do task.Wait(6000) end
end

---MainSub01（主时间轴 //830 起）：x=−128..−112 步 10，每 10 帧一只 BGirl00B。
t10mid.s02.ms01 = function(card)
    for _, x in ipairs({ -128, -112, -96, -80, -64, -48, -64, -80, -96, -112 }) do
        t10mid.spawn(30, x, -16, false, t10mid.D1, t10mid.s02.g00b)
        task.Wait(10)
    end
end
---MainSub02（//5164、//5534 各起一次）：同上，但每 30 帧一只。
t10mid.s02.ms02 = function(card)
    for _, x in ipairs({ -128, -112, -96, -80, -64, -48, -64, -80, -96, -112 }) do
        t10mid.spawn(30, x, -16, false, t10mid.D1, t10mid.s02.g00b)
        task.Wait(30)
    end
end

---道中时间轴（`+N:` = 相对上一事件帧数；镜像 = enmCreate*M）。
t10mid.s02.run = function(card)
    local B, D, D2 = t10mid.s02, t10mid.D1, t10mid.D2
    local xs9 = { 112, 96, 80, 64, 48, 64, 80, 96, 112 }
    task.Wait(160)
    -- BGirl00 ×5（非镜像，x=−144,−126,−112,−160,−100）
    for _, x in ipairs({ -144, -126, -112, -160 }) do
        t10mid.spawn(60, x, -16, false, D, B.g00); task.Wait(10)
    end
    t10mid.spawn(60, -100, -16, false, D, B.g00)            -- //200
    -- BGirl00B ×10（镜像，x=128→112 折返；第一只与上面同帧）
    for _, x in ipairs({ 128, 112, 96, 80, 64, 48, 64, 80, 96 }) do
        t10mid.spawn(30, x, -16, true, D, B.g00b); task.Wait(10)
    end
    t10mid.spawn(30, 112, -16, true, D, B.g00b)             -- //290
    task.Wait(270)                                          -- //560
    -- xxxGirl00C 成对（左镜像 / 右非镜像），每 30 帧一对，共 8 对
    for _, xc in ipairs({ 16, 16, 16, 16, 96, 96, 96, 96 }) do
        t10mid.spawn(60, -xc, -16, true, D, B.g00c)
        t10mid.spawn(60,  xc, -16, false, D, B.g00c)
        task.Wait(30)
    end
    task.Wait(30)                                           -- //830
    -- AM BGirl00B(128) + MainSub01 并行
    task.New(card, function() B.ms01(card) end)
    t10mid.spawn(30, 128, -16, true, D, B.g00b)
    for _, x in ipairs({ 112, 96, 80, 64, 48, 64, 80, 96, 112 }) do
        task.Wait(10); t10mid.spawn(30, x, -16, true, D, B.g00b)
    end
    task.Wait(54 + 2000)                                    -- 跳过 MBossDummy → //2974
    -- xxxGirl00D 波 ×11：左右交替，每波 5 只（间隔 10）、波间隔 60
    local dxs = { -144, -126, -112, -160, -100 }
    for wi = 1, 11 do
        local mir = (wi % 2 == 0)
        local sx = mir and 1 or -1
        for i = 1, 5 do
            t10mid.spawn(60, sx * dxs[i], -16, mir, D, B.g00d)
            if i < 5 then task.Wait(10) end
        end
        if wi < 11 then task.Wait(60) end
    end
    task.Wait(100)                                          -- //4114
    -- Girl01 ×4（AF, 224,32）+ ×4（AMF, −224,32），各隔 60 帧
    for _ = 1, 4 do t10mid.spawn(400,  224, 32, false, D2, B.g01, nil, 30); task.Wait(60) end
    for _ = 1, 4 do t10mid.spawn(400, -224, 32, true,  D2, B.g01, nil, 30); task.Wait(60) end
    task.Wait(60)                                           -- //4654
    -- Girl01 ×6（±224, 64，AF/AMF 交替，隔 30 帧）
    for i = 1, 6 do
        if i % 2 == 1 then t10mid.spawn(300,  224, 64, false, D2, B.g01, nil, 30)
        else               t10mid.spawn(300, -224, 64, true,  D2, B.g01, nil, 30) end
        task.Wait(30)
    end
    task.Wait(130)                                          -- //4964
    t10mid.spawn(4000, 0, -32, false, D2, B.g02, nil, 40)   -- L 行
    task.Wait(200)                                          -- //5164
    -- MainSub02 + AM BGirl00B ×9（隔 30）两轮
    task.New(card, function() B.ms02(card) end)
    task.Wait(30)                                           -- //5194
    for i = 1, 9 do
        t10mid.spawn(30, xs9[i], -16, true, D, B.g00b)
        task.Wait(i < 9 and 30 or 100)
    end
    task.New(card, function() B.ms02(card) end)             -- //5534
    task.Wait(30)                                           -- //5564
    for i = 1, 9 do
        t10mid.spawn(30, xs9[i], -16, true, D, B.g00b)
        task.Wait(i < 9 and 30 or 60)
    end
    -- +60 后 Boss 本体：不移植 ⇒ 本卡到此结束
end

---挂到空 boss「ca」上的一张耐久符卡（与 stage01/06 道中同一套注册方式）。
boss.Define("ca", "道中", "TH10_1", TH10_bg, { 0, 400 }, nil, "img_void", LEVEL)
t10mid.s02card = boss.card.New("二道中「人里の妖精」", 100, 100, 100, 10000000)
function t10mid.s02card:before()
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
end
function t10mid.s02card:init()
    t10mid.clear(); t10mid.ax, t10mid.ay = 0, 0
    task.New(self, function() t10mid.s02.run(self) end)
end
function t10mid.s02card:frame() end
function t10mid.s02card:render() end
function t10mid.s02card:del() t10mid.clear() end
boss.card.add({ { t10mid.s02card, "ca" } }, LEVEL, "二道中「人里の妖精」", 3681)

--=====================================
-- 十二、stage03 道中（妖精群 + 环状妖精）—— 原生 LuaSTG「道中搬运卡」
--   把 `stage03.ecl` 的 main 道中段复刻成一张符卡（跳过 MapleEnemy / MBossDummy /
--   MBoss / Boss 本体 —— 中 BOSS 与 BOSS 已有各自的卡）。走共用的 t10mid 妖精框架。
--   数据：thecl -d 10 -r -x -j -m th10.eclm stage03.ecl 反汇编。
--   只做 Lunatic：`diffI/diffF` 取第 4 项、`!HL`（H/L 共有，L 也生效）块照做。
--   近似：妖精贴图一律 servant；颜色变体（R/B/G/YGirl00* 之类）只差敌人外形与
--         掉落 ⇒ 行为共用同一子程序；dropMain(1/2/3) 折成 D1/D2；anm* 只当纯视觉。
--   ★ 踩坑（照复原源码 EclVm.cpp:780）：`wait(n)` = 时钟 −n；ECL 的循环写成
--     `wait(…) + jmp(L, 0)`，回跳时把时钟**重置回 0** ⇒ 循环入口那条
--     `wait(%RAND…)` 的效果被丢掉，但 `%RAND/%RANDRAD` 照样被消耗
--     （随机序列要对齐，所以每种都照抄一次消耗）。
--   ★ `call("MainSubNN")` 是**同步**子程序（EclVm.cpp:503 StartSubroutine 把父时钟
--     压栈、子程序时钟归零）⇒ 父时序在子程序跑完前冻结；本文件按同一口径写成
--     直接函数调用（子程序里的 task.Wait 就是墙钟）。
--=====================================
t10mid.s03 = {}

---RGirl00_at：7 发自机狙扇形（角步长 π/8、速度 3.5→1.0），每 18 帧一梭、无限循环；
---主人 Girl00 在 +340 帧 killAsync(0) 停它（原作的 `[0]=420/[4]`、`[16]=%RANDRAD`
---两处都是死代码，但 %RANDRAD 的消耗要保留）。
t10mid.s03.rg00_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 8, f.I0)
    et_count(f, 0, 7, 1); et_angle(f, 0, 0.0, 0.3926991); et_speed(f, 0, 3.5, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    rndrad()                                    -- [16] = %RANDRAD：值被丢弃
    while true do
        if f.s03_stop then return end
        task.Wait(18); fire_slot(f, 0)
    end
end

---Girl00：直下（初速 %RANDF·2+5.5）、40 帧减速到 0；+40 起 RGirl00_at；
---+340 把角拉到 π/8+%RANDF2·0.2、120 帧加速到 1.5，并 killAsync(0)。
t10mid.s03.g00 = function(f)
    t10mid.vel(f, 1.5707964, rnd() * 2.0 + 5.5)
    t10mid.vel_time(f, 40, 4, -999999, 0.0)
    task.Wait(40)
    task.New(f, function() t10mid.s03.rg00_at(f) end)
    task.Wait(300)
    t10mid.vel_time(f, 120, 4, 0.3926991 + rnd2() * 0.2, 1.5)
    f.s03_stop = true
    while true do task.Wait(6000) end
end

---Girl00B_at：1 发自机狙（角步长 π/8、速度 3.2），每 20 帧一梭、无限循环。
t10mid.s03.g00b_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 2, 6); et_count(f, 0, 1, 1)
    et_angle(f, 0, 0.0, 0.3926991); et_speed(f, 0, 3.2, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    t10_imod(t10_randmod(), 30)                 -- wait(%RAND % 30)：消耗保留
    while true do task.Wait(20); fire_slot(f, 0) end
end

---Girl00B：斜下（角 1.8+%RANDF·1.2、速度 0.3927+%RANDF2·0.1）；入场 15 帧无敌；
---!HL（H/L 都有）起 Girl00B_at。
t10mid.s03.g00b = function(f)
    t10mid.vel(f, 1.8 + rnd() * 1.2, 0.3926991 + rnd2() * 0.1)
    task.New(f, function() t10mid.s03.g00b_at(f) end)
    while true do task.Wait(6000) end
end

---RGirl00C_at：等 100 帧 → 16 梭、每 4 帧一梭；基准角每梭 +%F0、速度 2.0 起每梭 +0.2。
t10mid.s03.rg00c_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 1, 6); et_count(f, 0, 1, 2)
    et_angle(f, 0, 0.0, 0.0); et_speed(f, 0, 2.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    task.Wait(100)
    local a, sp = 0.0, 2.0
    for _ = 1, 16 do
        et_angle(f, 0, a, 0.0); et_speed(f, 0, sp, 0.0)
        task.Wait(4); fire_slot(f, 0)
        sp = sp + 0.2; a = t10_wrap(a + f.F0)
    end
end

---Girl00C：−3π/8 方向斜插、速度 8；+20 起 120 帧转到正下方、同时起 RGirl00C_at；
---+140 起 60 帧（ease-in）转到 π/4、速度 1.0。入场 100 帧无敌。
t10mid.s03.g00c = function(f)
    t10mid.vel(f, -1.1780972, 8.0)
    task.Wait(20)
    t10mid.vel_time(f, 120, 4, 1.5707964, 0.0)
    task.New(f, function() t10mid.s03.rg00c_at(f) end)
    task.Wait(120)
    t10mid.vel_time(f, 60, 1, 0.7853982, 1.0)
    while true do task.Wait(6000) end
end

---RGirl00D_at：12 梭、每 4 帧一梭的半径螺旋（角每梭 +π/10、半径 0 起每梭 +4、
---速度 1.5 起每梭 +0.1、出弹点在半径 [16] 的圆上）。
t10mid.s03.rg00d_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 2, 6); et_count(f, 0, 1, 1)
    et_angle(f, 0, 0.0, 0.0); et_speed(f, 0, 2.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    local a, r, sp = rndrad(), 0.0, 1.5
    for _ = 1, 12 do
        et_speed(f, 0, sp, sp)
        et_offset(f, 0, math.cos(a) * r, math.sin(a) * r)
        task.Wait(4); fire_slot(f, 0)
        a = t10_wrap(a + 0.314159); r = r + 4.0; sp = sp + 0.1
    end
end

---Girl00D：直下（%RANDF·2+5.5）、40 帧减速到 0；同时起 RGirl00D_at；
---+100 起 40 帧把角拉到 π/8+%RANDF2·0.4、速度 2.7。
t10mid.s03.g00d = function(f)
    t10mid.vel(f, 1.5707964, rnd() * 2.0 + 5.5)
    t10mid.vel_time(f, 40, 4, -999999, 0.0)
    task.New(f, function() t10mid.s03.rg00d_at(f) end)
    task.Wait(100)
    t10mid.vel_time(f, 40, 4, 0.3926991 + rnd2() * 0.4, 2.7)
    while true do task.Wait(6000) end
end

---Girl01_at：双槽、每 5 帧一梭、共 64 梭。槽 0：6 发（L）× 角步长 0.44879895、
---基准角 −π/2 每梭 +%F0、速度 3.0；槽 1：3 层 × 6 发（纯环）、基准角同、速度 4.0。
t10mid.s03.g01_at = function(f)
    et_new(f, 0); et_aim(f, 0, 1); et_sprite(f, 0, 7, 5); et_count(f, 0, 6, 1)
    et_angle(f, 0, -1.570796, 0.44879895); et_speed(f, 0, 3.0, 0.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_new(f, 1); et_aim(f, 1, 3); et_sprite(f, 1, 8, 3); et_count(f, 1, 3, 6)
    et_angle(f, 1, -1.570796, 0.0); et_speed(f, 1, 4.0, 1.0)
    et_ex(f, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local a = -1.570796
    for _ = 1, 64 do
        if f.s03_g01_stop then return end
        et_angle(f, 0, a, 0.3926991); fire_slot(f, 0)
        et_angle(f, 1, a, 0.0);      fire_slot(f, 1)
        task.Wait(5)
        a = t10_wrap(a + f.F0)
    end
end

---Girl01：直下 5.0、60 帧减速到 0；+60 起 Girl01_at；+180 起 60 帧转到 π/4、速度 1.0；
---+360 killAsync(0)。入场 30 帧无敌。
t10mid.s03.g01 = function(f)
    t10mid.vel(f, 1.5707964, 5.0)
    t10mid.vel_time(f, 60, 4, -999999, 0.0)
    task.Wait(60)
    task.New(f, function() t10mid.s03.g01_at(f) end)
    task.Wait(120)
    t10mid.vel_time(f, 60, 4, 0.7853982, 1.0)
    task.Wait(180)
    f.s03_g01_stop = true
    while true do task.Wait(6000) end
end

---Girl02_at：槽 0：14 层 × 10 发（L；随机基准角、角步长 %F0）、速度 3.0→+1.0；
---入场即一梭，然后每 30 帧一梭、共 4 梭（角步长符号 +,−,+,−；
---每梭各消耗一次 %RANDRAD）。
t10mid.s03.g02_at = function(f)
    et_new(f, 0); et_aim(f, 0, 3); et_sprite(f, 0, 8, 2); et_count(f, 0, 14, 10)
    et_angle(f, 0, rndrad(), f.F0); et_speed(f, 0, 3.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 0, 64, 60, 1, 0.0, 1.5)
    fire_slot(f, 0)
    task.Wait(30); et_angle(f, 0, rndrad(), -f.F0); fire_slot(f, 0)
    task.Wait(30); et_angle(f, 0, rndrad(),  f.F0); fire_slot(f, 0)
    task.Wait(30); et_angle(f, 0, rndrad(), -f.F0); fire_slot(f, 0)
end

---Girl02：直下 10.0、40 帧减速到 0；+40 起 Girl02_at；+360 起 70 帧转到 −π/2、速度 6.0。
---入场 40 帧无敌。
t10mid.s03.g02 = function(f)
    t10mid.vel(f, 1.5707964, 10.0)
    t10mid.vel_time(f, 40, 4, -999999, 0.0)
    task.Wait(40)
    task.New(f, function() t10mid.s03.g02_at(f) end)
    task.Wait(320)
    t10mid.vel_time(f, 70, 4, -1.5707964, 6.0)
    while true do task.Wait(6000) end
end

---SpCir00_at：7 层 × 1 发（自机狙、角步长 π/32、速度 2.4）；先消耗一次
---`$RAND%20`（原作的 `wait(%RAND%20+10)` 被回跳重置掉，只留消耗），
---之后每 30 帧一梭。弹色号 = SpCir00 的第 3 个实参（B=6 / R=2 / G=10）。
t10mid.s03.sp00_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 3, f.s03_spc)
    et_count(f, 0, 7, 1); et_angle(f, 0, 0.0, 0.09817477); et_speed(f, 0, 2.4, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    t10_imod(t10_randmod(), 20)                 -- wait(%RAND % 20 + 10)：消耗保留
    while true do
        task.Wait(10); fire_slot(f, 0)
        task.Wait(20)
    end
end

---SpCir00：直下 3.0；+60 起 40 帧转到 0；+100 起 40 帧转到 −π/2。
t10mid.s03.sp00 = function(f)
    task.New(f, function() t10mid.s03.sp00_at(f) end)
    t10mid.vel(f, 1.5707964, 3.0)
    task.Wait(60)
    t10mid.vel_time(f, 40, 0, 0.0, 3.0)
    task.Wait(40)
    t10mid.vel_time(f, 40, 0, -1.5707964, 3.0)
    while true do task.Wait(6000) end
end

---三个色号入口（对应原作的 BSpCir00 / RSpCir00 / GSpCir00 三条 call 包装）。
t10mid.s03.bsp = function(f) f.s03_spc = 6;  t10mid.s03.sp00(f) end
t10mid.s03.rsp = function(f) f.s03_spc = 2;  t10mid.s03.sp00(f) end
t10mid.s03.gsp = function(f) f.s03_spc = 10; t10mid.s03.sp00(f) end

---MainSub01：x=−224 固定、每 10 帧一只 Girl00B（32 只，y 每 8 只一轮）。
t10mid.s03.ms01 = function(card)
    local y8 = { -16, 32, 96, 64, 96, 32, 96, 16 }
    for i = 1, 32 do
        t10mid.spawn(20, -224, y8[(i - 1) % 8 + 1], false, t10mid.D1, t10mid.s03.g00b)
        if i < 32 then task.Wait(10) end
    end
end

---MainSub02 / MainSub02r：x=∓224、每 10 帧一只 Girl00B（各 8 只）。
t10mid.s03.ms02 = function(card, x, mir)
    local y8 = { -16, 32, 96, 64, 96, 32, 96, 16 }
    for i = 1, 8 do
        t10mid.spawn(20, x, y8[i], mir, t10mid.D1, t10mid.s03.g00b)
        if i < 8 then task.Wait(10) end
    end
end

---MainSub03 / MainSub03b：16 只 Girl00C（前半靠左、后半镜像靠右），每 20 帧一只，
---%F0 逐只 ±0.082673 交替（原作的两种配色只差敌人外形 ⇒ 合成一个函数）。
t10mid.s03.ms03 = function(card)
    local seq = {
        { -216, 256, false }, { -256, 224, false }, { -224, 256, false }, { -216, 224, false },
        { -284, 256, false }, { -216, 224, false }, { -224, 256, false }, { -256, 224, false },
        {  216, 256, true  }, {  256, 224, true  }, {  224, 256, true  }, {  216, 224, true  },
        {  284, 256, true  }, {  216, 224, true  }, {  224, 256, true  }, {  256, 224, true  },
    }
    for i = 1, 16 do
        local s = seq[i]
        t10mid.spawn(110, s[1], s[2], s[3], t10mid.D2, t10mid.s03.g00c,
                     { F0 = (i % 2 == 1) and 0.082673 or -0.082673 })
        if i ~= 8 and i < 16 then task.Wait(20) end
    end
end

---MainSub04 / MainSub04r：x=∓224、每 10 帧一只 Girl00B（各 8 只）。
t10mid.s03.ms04 = function(card, x, mir)
    local y8 = { -16, 32, 96, 64, 96, 32, 96, 16 }
    for i = 1, 8 do
        t10mid.spawn(20, x, y8[i], mir, t10mid.D1, t10mid.s03.g00b)
        if i < 8 then task.Wait(10) end
    end
end

---SpCir 群：同一 x 上 7 只、每 20 帧一只；`s` 是 "BRBRBRG" 这种颜色串。
t10mid.s03.spgroup = function(card, x, mir, s)
    for i = 1, #s do
        local c = s:sub(i, i)
        local beh = t10mid.s03.gsp
        if c == "B" then beh = t10mid.s03.bsp
        elseif c == "R" then beh = t10mid.s03.rsp end
        t10mid.spawn(20, x, -16, mir, t10mid.D1, beh)
        if i < #s then task.Wait(20) end
    end
end

---道中时间轴（`//N` = 原作 main 的绝对帧；`+N:` = 相对上一事件帧数）。
t10mid.s03.run = function(card)
    local B, D, D2 = t10mid.s03, t10mid.D1, t10mid.D2
    task.Wait(160)                                          -- //160
    task.New(card, function() B.ms01(card) end)
    task.Wait(60)                                           -- //220
    t10mid.spawn(240,  96, -16, true, D2, B.g00, { I0 = 6 })
    task.Wait(30)                                           -- //250
    t10mid.spawn(240, 128, -16, true, D, B.g00b)
    task.Wait(30)                                           -- //280
    t10mid.spawn(240, 144, -16, true, D, B.g00b)
    task.Wait(800)                                          -- //1080
    t10mid.spawn(360,  128, -16, false, D2, B.g01, { F0 = 0.1309 }, 30)
    t10mid.spawn(360, -128, -16, true,  D2, B.g01, { F0 = -0.1309 }, 30)
    task.Wait(200)                                          -- //1280
    t10mid.spawn(150, -96, -16, false, D2, B.g00, { I0 = 6 })
    task.Wait(30)                                           -- //1310
    t10mid.spawn(150, -128, -16, false, D, B.g00b)
    task.Wait(60)                                           -- //1370
    t10mid.spawn(150,  96, -16, true, D2, B.g00, { I0 = 4 })
    task.Wait(30)                                           -- //1400
    t10mid.spawn(150, 128, -16, true, D, B.g00b)
    task.Wait(60)                                           -- //1460
    t10mid.spawn(150, -96, -16, false, D2, B.g00, { I0 = 13 })
    task.Wait(30)                                           -- //1490
    t10mid.spawn(150, -128, -16, false, D, B.g00b)
    task.Wait(60)                                           -- //1550
    t10mid.spawn(150,  96, -16, true, D2, B.g00, { I0 = 10 })
    task.New(card, function() B.ms02(card, 224, true) end)  -- MainSub02r
    task.Wait(30)                                           -- //1580
    t10mid.spawn(150, 128, -16, true, D, B.g00b)
    task.Wait(60)                                           -- //1640
    t10mid.spawn(150, -96, -16, false, D2, B.g00, { I0 = 2 })
    task.New(card, function() B.ms02(card, -224, false) end)-- MainSub02
    task.Wait(30)                                           -- //1670
    t10mid.spawn(150, -128, -16, false, D, B.g00b)
    task.Wait(60)                                           -- //1730
    t10mid.spawn(150,  96, -16, true, D2, B.g00, { I0 = 8 })
    task.Wait(30)                                           -- //1760
    t10mid.spawn(150, 128, -16, true, D, B.g00b)
    task.Wait(300)                                          -- //2060
    B.ms03(card)                                            -- call MainSub03（同步）
    task.Wait(60); B.ms03(card)                             -- //2120 call MainSub03b
    task.Wait(60); B.ms03(card)                             -- //2180 call MainSub03
    task.Wait(300)                                          -- //2480
    t10mid.spawn(360,  128, -16, true,  D2, B.g01, { F0 = 0.1309 }, 30)
    t10mid.spawn(360, -128, -16, false, D2, B.g01, { F0 = -0.1309 }, 30)
    task.Wait(120)                                          -- //2600
    t10mid.spawn(360,  96, -16, true,  D2, B.g01, { F0 = 0.1309 }, 30)
    t10mid.spawn(360, -96, -16, false, D2, B.g01, { F0 = -0.1309 }, 30)
    task.Wait(260)                                          -- //2860（MBossDummy 跳过）
    task.Wait(60)                                           -- //2920（dialog 跳过）
    task.New(card, function() B.ms04(card, -224, false) end)
    task.New(card, function() B.ms04(card,  224, true)  end)
    task.Wait(120)                                          -- //3040
    task.New(card, function() B.ms04(card, -224, false) end)
    task.New(card, function() B.ms04(card,  224, true)  end)
    task.Wait(120)                                          -- //3160
    task.New(card, function() B.ms04(card, -224, false) end)
    task.New(card, function() B.ms04(card,  224, true)  end)
    task.New(card, function() B.ms04(card, -224, false) end)
    task.New(card, function() B.ms04(card,  224, true)  end)
    task.Wait(120)                                          -- //3280（MBoss 跳过）
    t10mid.spawn(640, -96, -16, true, D2, B.g02, { F0 = 0.024544 }, 40)
    task.New(card, function() B.ms04(card, -224, false) end)
    task.New(card, function() B.ms04(card,  224, true)  end)
    task.Wait(175)                                          -- //3455
    t10mid.spawn(640,  96, -16, true, D2, B.g02, { F0 = 0.024544 }, 40)
    task.New(card, function() B.ms04(card, -224, false) end)
    task.New(card, function() B.ms04(card,  224, true)  end)
    task.Wait(175)                                          -- //3630
    t10mid.spawn(640, -112, -16, true, D2, B.g02, { F0 = 0.024544 }, 40)
    task.New(card, function() B.ms04(card, -224, false) end)
    task.New(card, function() B.ms04(card,  224, true)  end)
    task.Wait(175)                                          -- //3805
    t10mid.spawn(640, 0, -16, true, D2, B.g02, { F0 = 0.024544 }, 40)
    task.New(card, function() B.ms04(card, -224, false) end)
    task.New(card, function() B.ms04(card,  224, true)  end)
    task.Wait(200)                                          -- //4005
    B.spgroup(card,  128, true,  "BRBRBRG")
    task.Wait(40); B.spgroup(card,  -32, false, "BRBRBRG")  -- //4165
    task.Wait(40); B.spgroup(card, -112, false, "BRBRBRG")  -- //4325
    task.Wait(40); B.spgroup(card,   48, true,  "BRBRBRG")  -- //4485
    task.Wait(20); B.spgroup(card, -128, false, "BRBRBRG")  -- //4625
    task.Wait(20); B.spgroup(card,  -32, true,  "BRBBBRG")  -- //4765
    task.Wait(20); B.spgroup(card,  112, false, "BRBRBRG")  -- //4905
    task.Wait(20); B.spgroup(card,  -96, true,  "BRBRBRG")  -- //5045
    task.Wait(120)                                          -- //5285
    t10mid.spawn(640, -32, -16, false, D2, B.g02, { F0 = -0.016362 }, 40)
    t10mid.spawn(640,  32, -16, true,  D2, B.g02, { F0 = 0.019635 }, 40)
    task.Wait(200)                                          -- //5485
    t10mid.spawn(640, -64, -16, false, D2, B.g02, { F0 = 0.016362 }, 40)
    t10mid.spawn(640,  64, -16, true,  D2, B.g02, { F0 = -0.024544 }, 40)
    -- +400 后 Boss 本体：不移植 ⇒ 本卡到此结束
end

---挂到空 boss「da」上的一张耐久符卡（与 stage01/02/06 道中同一套注册方式）。
boss.Define("da", "道中", "TH10_1", TH10_bg, { 0, 400 }, nil, "img_void", LEVEL)
t10mid.s03card = boss.card.New("三道中「河童の渓谷」", 120, 120, 120, 10000000)
function t10mid.s03card:before()
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
end
function t10mid.s03card:init()
    t10mid.clear(); t10mid.ax, t10mid.ay = 0, 0
    task.New(self, function() t10mid.s03.run(self) end)
end
function t10mid.s03card:frame() end
function t10mid.s03card:render() end
function t10mid.s03card:del() t10mid.clear() end
boss.card.add({ { t10mid.s03card, "da" } }, LEVEL, "三道中「河童の渓谷」", 3682)

--=====================================
-- 十三、stage04 道中（妖怪の山：乌鸦 / 潜行妖精 / 大妖精）—— 原生 LuaSTG「道中搬运卡」
--   把 `stage04.ecl` 的 main 道中段复刻成一张符卡（跳过 MapleEnemy / MBoss 中 BOSS /
--   Boss 本体 —— 中 BOSS 与 BOSS 已有各自的卡）。走共用的 t10mid 妖精框架。
--   数据：thecl -d 10 -r -x -j -m th10.eclm stage04.ecl 反汇编。
--   只做 Lunatic：`diffI/diffF` 取第 4 项、`!L`/`!NHL` 块在 L 下生效、`$DIFF`=3。
--   近似：妖精/乌鸦贴图一律 servant；色系（R/B/G/Y）只差敌人外形与掉落 ⇒ 行为共用；
--         dropMain(N) 折成 D1/D2；anm*/playSound/setHurtbox/movePos3d 只当视觉。
--   ★ 同一条敌机的所有 ECL 线程共用它的 $I/%F（EclVm 的 eclVariables 挂在**敌机**上）
--     ⇒ main/MainSub1..8 里的寄存器是同一个池子；本文件把需要传给子机的值显式塞进
--     `src`（spawn 的第 7 参）。子机出生点写进 offsetMotion（原作 EnemySpawn 的口径）。
--   ★ `callAsync` 起线程时时钟归零（相对父程序**当前帧**）；`call` 是同步子程序。
--   ★ ECL 的 `deci(v); jmpNeq(loop, t)` 是「先减再判」：入口先 deci 一次 ⇒ 初值 N
--     只跑 N−1 圈；jmp 目标时间 < 当前时间时，圈与圈之间才真的过帧。
--=====================================
t10mid.s04 = {}

---掉落近似（原作 dropMain：R→1、B→2、G→3、Y→0；本仓库 Dropitem_PFP 用 {信仰,P,点}）。
t10mid.s04.D1 = { 0, 1, 1 }
t10mid.s04.D2 = { 0, 3, 3 }

---生成一只 Girl 子机（相对创建 ⇒ 落在父敌机的当前位置）；src 拷父的 $I/%F。
---`behs` = 四个色系共用的行为入口（色系只影响掉落）。
t10mid.s04.mkgirl = function(f, hp, behs, inv)
    local i0 = f.I0 or 0
    local x, y = t10mid.pos(f)
    local drop = (i0 == 1 or i0 == 2) and t10mid.s04.D2 or t10mid.s04.D1
    return t10mid.spawn(hp, x, y, false, drop, behs[i0 % 4 + 1],
                        { I0 = i0, I1 = f.I1 or 0, F0 = f.F0 or 0, F1 = f.F1 or 0 }, inv)
end

---========================= 乌鸦（Crow 系） =========================
---Crow00L / Crow00R：从右上 / 左上斜插的乌鸦（不射击）；setInvuln(8)、life 20。
t10mid.s04.crow00l = function(f) t10mid.vel(f, 2.8797932, 1.0 + rnd() * 2.0) end
t10mid.s04.crow00r = function(f) t10mid.vel(f, 0.2617994, 1.0 + rnd() * 2.0) end

---Crow01At：每 20 帧一发（L）、共 9 发；角 %RANDRAD/2−π/2、速 %RANDF·0.4+0.1。
t10mid.s04.crow01_at = function(f)
    et_new(f, 0); et_aim(f, 0, 1); et_sprite(f, 0, 1, 14)
    et_count(f, 0, 1, 1); et_angle(f, 0, 3.1415927, 0.7853982); et_speed(f, 0, 2.5, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 2, 1, 16, 90, -999999, 0.027, 1.5707964)
    local w = t10_imod(t10_randmod(), 60)   -- wait($RAND % 60)：首发的随机延迟
    if w > 0 then task.Wait(w) end
    local n = 10 - 1
    while n ~= 0 do
        et_angle(f, 0, rndrad() / 2 - 1.5707964, 0.0)
        et_speed(f, 0, rnd() * 0.4 + 0.1, 0.0)
        fire_slot(f, 0)
        task.Wait(20)
        n = n - 1
    end
end

---Crow01L / Crow01R：同 Crow00 的入场 + 起枪线程。
t10mid.s04.crow01l = function(f)
    t10mid.vel(f, 2.8797932, 1.0 + rnd() * 2.0)
    task.New(f, function() t10mid.s04.crow01_at(f) end)
end
t10mid.s04.crow01r = function(f)
    t10mid.vel(f, 0.2617994, 1.0 + rnd() * 2.0)
    task.New(f, function() t10mid.s04.crow01_at(f) end)
end

---========================= Girl00 系 =========================
---RGirl00_at（Girl00 的枪）：10 帧延迟 → 9 发扇形 + 1 发 → 30 帧后 9 发（同角）。
t10mid.s04.rg00_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 12, 3)
    et_count(f, 0, 9, 1); et_angle(f, 0, 0.0, 0.2617994); et_speed(f, 0, 3.5, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    task.Wait(10)                           -- diffWait(40,40,10,10) 的 L 行
    fire_slot(f, 0)
    et_count(f, 0, 1, 1); fire_slot(f, 0)
    task.Wait(30)
    et_count(f, 0, 9, 1); fire_slot(f, 0)
end

---Girl00：−π/2（向上）冲 4.0、40 帧减速停；+60 转向自机（+%RANDF2·0.2）再加速到 1.5。
t10mid.s04.g00 = function(f)
    t10mid.vel(f, -1.5707964, 4.0)
    t10mid.vel_time(f, 40, 4, -999999, 0.0)
    task.New(f, function() t10mid.s04.rg00_at(f) end)
    task.Wait(60)
    t10mid.vel(f, t10_angle_player(f) + rnd2() * 0.2, 0.0)
    t10mid.vel_time(f, 120, 4, -999999, 1.5)
end

---========================= Girl01 系 =========================
---Girl01_at：外层 2 轮（diffI=3 先减一次）；每轮 9 拍 × (等 5 帧、3 连发)，轮间等 40 帧。
t10mid.s04.g01_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 3, f.I1 or 1)
    et_count(f, 0, 3, 1); et_angle(f, 0, 0.0, 0.3926991); et_speed(f, 0, 5.5, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    local outer = 3 - 1
    while outer ~= 0 do
        local n = 10 - 1
        while n ~= 0 do
            task.Wait(5)
            fire_slot(f, 0)
            n = n - 1
        end
        task.Wait(40)
        outer = outer - 1
    end
end

---Girl01：+π/2（向下）入 2.0、40 帧停；同时起 Girl01_at；+40 起 40 帧转向 %F0、加速到 1.0。
t10mid.s04.g01 = function(f)
    t10mid.vel(f, 1.5707964, 2.0)
    task.New(f, function() t10mid.s04.g01_at(f) end)
    t10mid.vel_time(f, 40, 4, -999999, 0.0)
    task.Wait(40)
    t10mid.vel_time(f, 40, 4, f.F0, 1.0)
end

---========================= Girl02 系（大妖精） =========================
---Girl02_at：槽 1 双旋。外层 5 轮；每轮 A 段 59 帧（角 += %RANDRAD/40+π/40）、
---B 段 59 帧（角 −= 同量）。L 行（$DIFF>=3）每帧 3 发、每发重掷角增与位移。
t10mid.s04.g02_at = function(f)
    et_new(f, 1); et_aim(f, 1, 3); et_sprite(f, 1, 24, 2)
    et_count(f, 1, 1, 1); et_angle(f, 1, 0.0, 0.049087387); et_speed(f, 1, 2.0, 1.0)
    et_ex(f, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 1, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    local outer = 6 - 1
    while outer ~= 0 do
        local a = rndrad()
        et_sprite(f, 1, 24, 4)
        local n = 60 - 1
        while n ~= 0 do
            task.Wait(1)
            a = a + rndrad() / 40 + 3.1415927 / 40
            et_angle(f, 1, a, 0.0); et_offset(f, 1, rnd2() * 32, rnd2() * 32)
            fire_slot(f, 1)
            a = a + rndrad() / 40 + 3.1415927 / 40
            et_angle(f, 1, a, 0.0); et_offset(f, 1, rnd2() * 32, rnd2() * 32)
            fire_slot(f, 1)
            et_angle(f, 1, a, 0.0); et_offset(f, 1, rnd2() * 32, rnd2() * 32)
            fire_slot(f, 1)
            n = n - 1
        end
        a = rndrad()
        et_sprite(f, 1, 24, 6)
        local m = 60 - 1
        while m ~= 0 do
            task.Wait(1)
            a = a - rndrad() / 40 - 3.1415927 / 40
            et_angle(f, 1, a, 0.0); et_offset(f, 1, rnd2() * 32, rnd2() * 32)
            fire_slot(f, 1)
            a = a - rndrad() / 40 - 3.1415927 / 40
            et_angle(f, 1, a, 0.0); et_offset(f, 1, rnd2() * 32, rnd2() * 32)
            fire_slot(f, 1)
            et_angle(f, 1, a, 0.0); et_offset(f, 1, rnd2() * 32, rnd2() * 32)
            fire_slot(f, 1)
            m = m - 1
        end
        et_offset(f, 1, 0.0, 0.0)
        outer = outer - 1
    end
end

---Girl02_at2：槽 0 双环（10×8）无限循环：等 100 帧打一次、再等 60 帧反向打一次。
t10mid.s04.g02_at2 = function(f)
    et_new(f, 0); et_aim(f, 0, 3); et_sprite(f, 0, 2, 2)
    et_count(f, 0, 10, 8); et_angle(f, 0, 0.0, 0.049087387); et_speed(f, 0, 2.0, 0.8)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    while true do
        task.Wait(100)
        et_sprite(f, 0, 2, 2); et_angle(f, 0, 0.0, 0.049087387); fire_slot(f, 0)
        task.Wait(60)
        et_sprite(f, 0, 2, 2); et_angle(f, 0, 0.0, -0.049087387); fire_slot(f, 0)
    end
end

---Girl02：+π/2 入 2.0、40 帧停；起两条枪线程；+440 起 40 帧转向 %F0、加速到 1.0。
t10mid.s04.g02 = function(f)
    t10mid.vel(f, 1.5707964, 2.0)
    task.New(f, function() t10mid.s04.g02_at(f) end)
    task.New(f, function() t10mid.s04.g02_at2(f) end)
    t10mid.vel_time(f, 40, 4, -999999, 0.0)
    task.Wait(440)
    t10mid.vel_time(f, 40, 4, f.F0, 1.0)
end

---========================= Girl03 系 =========================
---Girl03_at2：槽 2 独弹无限循环（L：速 5.6、每 40 帧一发）。
t10mid.s04.g03_at2 = function(f)
    et_new(f, 2); et_aim(f, 2, 2); et_sprite(f, 2, 12, 3)
    et_count(f, 2, 1, 1); et_angle(f, 2, 0.0, 0.3926991); et_speed(f, 2, 5.6, 1.0)
    while true do
        fire_slot(f, 2)
        task.Wait(40)                       -- diffWait(300,300,60,40) 的 L 行
    end
end

---Girl03_at：槽 0（4 发扇形自机狙）+ 槽 1（复制后改 3 环）；外层 2 轮、内层 9 拍。
---每拍等 5 帧，两槽各带一次 ±8 的随机位移（%RANDF2 消耗顺序照抄）。
t10mid.s04.g03_at = function(f)
    et_new(f, 0); et_aim(f, 0, 5); et_sprite(f, 0, 3, 6)
    et_count(f, 0, 4, 1); et_angle(f, 0, 0.0, 0.3926991); et_speed(f, 0, 2.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    et_copy(f, 1, 0); et_aim(f, 1, 3); et_speed(f, 1, 1.5, 1.0); et_sprite(f, 1, 3, 8)
    task.New(f, function() t10mid.s04.g03_at2(f) end)     -- !NHL（L 生效）
    local outer = 3 - 1
    while outer ~= 0 do
        local n = 10 - 1
        while n ~= 0 do
            task.Wait(5)
            et_offset(f, 0, rnd2() * 8, rnd2() * 8); fire_slot(f, 0)
            et_offset(f, 1, rnd2() * 8, rnd2() * 8); fire_slot(f, 1)
            n = n - 1
        end
        task.Wait(60)
        outer = outer - 1
    end
end

---Girl03：+π/2 入 8.0；同时起 Girl03_at；40 帧内转向 0.0、减速到 2.0。
t10mid.s04.g03 = function(f)
    t10mid.vel(f, 1.5707964, 8.0)
    task.New(f, function() t10mid.s04.g03_at(f) end)
    t10mid.vel_time(f, 40, 4, 0.0, 2.0)
end

---========================= Girl04 系 =========================
---Girl04_at2：槽 1（3 发 × 2 环，L 速 5.5）；先减一次 ⇒ 打 2 发、间隔 20 帧。
t10mid.s04.g04_at2 = function(f)
    et_new(f, 1); et_aim(f, 1, 2); et_sprite(f, 1, 12, 3)
    et_count(f, 1, 3, 2); et_angle(f, 1, 0.0, 0.7853982); et_speed(f, 1, 5.5, 1.0)
    local n = 3 - 1
    while n ~= 0 do
        task.Wait(20)                       -- diffWait(50,50,30,20) 的 L 行
        fire_slot(f, 1)
        n = n - 1
    end
end

---Girl04_at：槽 0（2 发扇形自机狙，基准角 π、步长 π/4、速 2.5）9 拍；起 Girl04_at2。
t10mid.s04.g04_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 3, f.I1 or 0)
    et_count(f, 0, 2, 1); et_angle(f, 0, 3.1415927, 0.7853982); et_speed(f, 0, 2.5, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    task.New(f, function() t10mid.s04.g04_at2(f) end)     -- !NHL（L 生效）
    local n = 10 - 1
    while n ~= 0 do
        task.Wait(5)
        fire_slot(f, 0)
        n = n - 1
    end
end

---Girl04：+π/2 入 2.0、40 帧停；+40 转向自机、160 帧加速到 6.0。
t10mid.s04.g04 = function(f)
    t10mid.vel(f, 1.5707964, 2.0)
    task.New(f, function() t10mid.s04.g04_at(f) end)
    t10mid.vel_time(f, 40, 4, -999999, 0.0)
    task.Wait(40)
    t10mid.vel(f, t10_angle_player(f), 0.0)
    t10mid.vel_time(f, 160, 4, -999999, 6.0)
end

---========================= Dive 系（下潜标记，到点生成 Girl 后自毁） =========================
---DiveEnemy00：−π/2 入 −4.8、40 帧减速；+80 生成 Girl00 系（$I0 选色）。
t10mid.s04.de00 = function(f)
    t10mid.vel(f, -1.5707964, -4.8)
    task.Wait(40); t10mid.vel_time(f, 40, 4, -999999, 0.0)
    task.Wait(40)
    t10mid.s04.mkgirl(f, 80, { t10mid.s04.g00, t10mid.s04.g00, t10mid.s04.g00, t10mid.s04.g00 }, 0)
    t10_kill_pod(f)
end

---DiveEnemy00B：同 00，减速改在 +80（40 帧）、+120 生成。
t10mid.s04.de00b = function(f)
    t10mid.vel(f, -1.5707964, -4.8)
    task.Wait(80); t10mid.vel_time(f, 40, 4, -999999, 0.0)
    task.Wait(40)
    t10mid.s04.mkgirl(f, 80, { t10mid.s04.g00, t10mid.s04.g00, t10mid.s04.g00, t10mid.s04.g00 }, 0)
    t10_kill_pod(f)
end

---DiveEnemy01：−π/2 入 −4.8、+40 起 70 帧减速；+110 生成 Girl01 系（入场 40 帧无敌）。
t10mid.s04.de01 = function(f)
    t10mid.vel(f, -1.5707964, -4.8)
    task.Wait(40); t10mid.vel_time(f, 70, 4, -999999, 0.0)
    task.Wait(70)
    t10mid.s04.mkgirl(f, 80, { t10mid.s04.g01, t10mid.s04.g01, t10mid.s04.g01, t10mid.s04.g01 }, 40)
    t10_kill_pod(f)
end

---DiveEnemy01B：入场角 −π/2+%F1、速 −6.2；+100 起 70 帧减速；+170 生成 Girl01。
t10mid.s04.de01b = function(f)
    t10mid.vel(f, -1.5707964 + (f.F1 or 0), -6.2)
    task.Wait(100); t10mid.vel_time(f, 70, 4, -999999, 0.0)
    task.Wait(70)
    t10mid.s04.mkgirl(f, 80, { t10mid.s04.g01, t10mid.s04.g01, t10mid.s04.g01, t10mid.s04.g01 }, 40)
    t10_kill_pod(f)
end

---DiveEnemy02：−π/2 入 −1.8、+160 起 70 帧减速；+230 生成 Girl02（入场 160 帧无敌）。
t10mid.s04.de02 = function(f)
    t10mid.vel(f, -1.5707964, -1.8)
    task.Wait(160); t10mid.vel_time(f, 70, 4, -999999, 0.0)
    task.Wait(70)
    t10mid.s04.mkgirl(f, 1500, { t10mid.s04.g02, t10mid.s04.g02, t10mid.s04.g02, t10mid.s04.g02 }, 160)
    t10_kill_pod(f)
end

---DiveEnemy02B：−π/2 入 −3.4、+240 起 70 帧减速；+310 生成 Girl02。
t10mid.s04.de02b = function(f)
    t10mid.vel(f, -1.5707964, -3.4)
    task.Wait(240); t10mid.vel_time(f, 70, 4, -999999, 0.0)
    task.Wait(70)
    t10mid.s04.mkgirl(f, 1500, { t10mid.s04.g02, t10mid.s04.g02, t10mid.s04.g02, t10mid.s04.g02 }, 160)
    t10_kill_pod(f)
end

---DiveEnemy04：入场角 −π/2+%RANDRAD/16、速 −(3+%RANDF·0.5)（%RANDF 先、%RANDRAD 后）；
---+100 起 70 帧减速；+170 生成 Girl04 系（入场 20 帧无敌）。
t10mid.s04.de04 = function(f)
    local sp = -3.0 + rnd() * 0.5
    local a  = -1.5707964 + rndrad() / 16
    t10mid.vel(f, a, sp)
    task.Wait(100); t10mid.vel_time(f, 70, 4, -999999, 0.0)
    task.Wait(70)
    t10mid.s04.mkgirl(f, 100, { t10mid.s04.g04, t10mid.s04.g04, t10mid.s04.g04, t10mid.s04.g04 }, 20)
    t10_kill_pod(f)
end

---DiveEnemy04B：入场角 −π/2+%RANDRAD/16、速 −3.8，300 帧内插到 (角 −π/2, 速 −3.8)，然后自毁。
t10mid.s04.de04b = function(f)
    t10mid.vel(f, -1.5707964 + rndrad() / 16, -3.8)
    t10mid.vel_time(f, 300, 0, -1.5707964, -3.8)
    task.Wait(300)
    t10_kill_pod(f)
end

---========================= MainSub1..8（散兵时间轴） =========================
---MainSub1（t=0 起，main 的 callAsync）：5 只 DiveEnemy00 + 15 只 DiveEnemy01 + 1 只 DiveEnemy02。
t10mid.s04.ms1 = function(card)
    local S = t10mid.s04
    task.Wait(30)                                                   -- //30
    for i = 1, 5 do
        if i > 1 then task.Wait(20) end
        t10mid.spawn(60, -128 + (i - 1) * 64, 160, false, S.D1, S.de00, { I0 = 0, I1 = 2, F0 = 0.0 })
    end
    local q = {   -- { x, $I0, $I1, %F0, 距上一只帧数 }
        {  128, 0, 2,  3.1415927, 300 },
        {  -64, 1, 2,  0.3926991,  20 },
        {   64, 0, 2,  0.3926991,  20 },
        { -128, 1, 2,  0.0,        20 },
        {    0, 0, 2,  3.1415927,  20 },
        {  -96, 1, 2,  0.3926991,  60 },
        {   96, 0, 2,  0.3926991,  20 },
        {  -32, 1, 2,  3.1415927,  20 },
        {  160, 0, 2,  1.5707964,  20 },
        {   32, 0, 2,  3.1415927,  20 },
        {   96, 1, 2,  0.3926991,  60 },
        {  -96, 0, 2,  0.3926991,  20 },
        {   32, 1, 2,  0.0,        20 },
        { -160, 0, 2,  1.5707964,  20 },
        {  -32, 0, 2,  1.5707964,  20 },
    }
    for _, e in ipairs(q) do
        task.Wait(e[5])
        t10mid.spawn(60, e[1], -512, false, S.D1, S.de01, { I0 = e[2], I1 = e[3], F0 = e[4] })
    end
    task.Wait(50)                                                   -- //820
    t10mid.spawn(60, 0, -512, false, S.D1, S.de02, { I0 = 0, I1 = 2, F0 = -1.5707964 })
    task.Wait(600)                                                  -- //1420
    task.New(card, function() S.ms2(card) end)                      -- callAsync("MainSub2")
end

---MainSub2（t=0 相对 abs 1420）：BGirl03 两波（±两侧）+ 15 只 DiveEnemy00 + DiveEnemy02。
---★ 原作的「右侧组」并不与左侧同时起步：先左 5 只（0/30/60/90/120），右 5 只紧接
---  在左第 5 只之后（120/150/180/210/240）；第二波（左 8+右 8）更是**无等待**接在
---  右第 5 只（240）后面。逐个 spawn 的帧号照反汇编标出来。
t10mid.s04.ms2 = function(card)
    local S = t10mid.s04
    ---第一波：左 5（非镜像，$I1=6）t=0..120；右 5（镜像，$I1=8）t=120..240。
    local waveA_l = {
        { -192, -24 }, { -160, -24 }, { -128, -24 }, { -216, 16 }, { -220, 32 },
    }
    local waveA_r = {
        {  192, -24 }, {  160, -24 }, {  128, -24 }, {  216, 16 }, {  220, 32 },
    }
    for i = 1, 5 do
        local e = waveA_l[i]
        t10mid.spawn(120, e[1], e[2], false, S.D2, S.g03, { I1 = 6 }, 40)
        if i < 5 then task.Wait(30) end
    end
    for i = 1, 5 do
        local e = waveA_r[i]
        t10mid.spawn(120, e[1], e[2], true, S.D2, S.g03, { I1 = 8 }, 40)
        if i < 5 then task.Wait(30) end
    end
    ---第二波（紧接）：左 8（t=240..310）再右 8（t=310..380），每只间隔 10 帧。
    local waveB_l = {
        { -192, -24 }, { -160, -24 }, { -128, -24 }, { -216, 16 },
        { -220,  32 }, { -220,  64 }, { -220,  96 }, { -220, 128 },
    }
    local waveB_r = {
        {  192, -24 }, {  160, -24 }, {  128, -24 }, {  216, 16 },
        {  220,  32 }, {  220,  64 }, {  220,  96 }, {  220, 128 },
    }
    for j = 1, 8 do
        local e = waveB_l[j]
        t10mid.spawn(120, e[1], e[2], false, S.D2, S.g03, { I1 = 6 }, 40)
        if j < 8 then task.Wait(10) end
    end
    for j = 1, 8 do
        local e = waveB_r[j]
        t10mid.spawn(120, e[1], e[2], true, S.D2, S.g03, { I1 = 8 }, 40)
        if j < 8 then task.Wait(10) end
    end
    ---DiveEnemy00 三排 ×5（x 128→−128，y −512/−576/−640）+ DiveEnemy02。
    task.Wait(120)                                                  -- //500
    task.Wait(30)                                                   -- //530 第一只
    local dz = { { -512, 2 }, { -576, 1 }, { -640, 0 } }
    for rz, row in ipairs(dz) do
        for i = 1, 5 do
            t10mid.spawn(60, 128 - (i - 1) * 64, row[1], false, S.D1, S.de00,
                         { I0 = row[2], I1 = 8, F0 = 0.0 })
            if not (rz == 3 and i == 5) then task.Wait(20) end
        end
    end
    task.Wait(50)                                                   -- //860
    t10mid.spawn(60, 64, -512, false, S.D1, S.de02, { I0 = 0, I1 = 8, F0 = -1.5707964 })
    task.Wait(600)                                                  -- //1460
    task.New(card, function() S.ms3(card) end)                      -- callAsync("MainSub3")
    task.New(card, function() S.ms3b(card) end)                     -- callAsync("MainSub3B")
end

---MainSub3：第一段 5 只 DiveEnemy04（x −48 起每只 +32，40 帧一只）；
---第二段 23 只（x 144 起每只 −7，10 帧一只，x 再叠 %RANDF2·32）。$I0=1 ⇒ BGirl04。
---★ 这条子程序用「回跳 + 时间戳回退」的循环：`jmp(L,70)` 把时钟设到 70、
---  `jmpNeq(L,30)` 又设回 30 ⇒ 每圈固定耗 40 帧（实测帧号见注释）。
t10mid.s04.ms3 = function(card)
    local S = t10mid.s04
    task.Wait(30)                                                   -- //30  第一只
    local x = -48.0
    for i = 1, 5 do
        if i > 1 then
            task.Wait(40)
            x = x + 32.0
        end
        t10mid.spawn(60, x, -512, false, S.D1, S.de04, { I0 = 1, I1 = 8, F0 = 0.0 })
    end
    ---5 只在 t=30/70/110/150/190；圈末的 deci 落在 t=230。
    task.Wait(40)                                                   -- //230
    task.Wait(30)                                                   -- //260（+30 后 nop 与 [0]+=32）
    x = x + 32.0                                                    -- → 144
    for i = 1, 23 do
        if i > 1 then x = x - 7.0 end
        t10mid.spawn(60, x + rnd2() * 32.0, -512, false, S.D1, S.de04,
                     { I0 = 1, I1 = 8, F0 = 0.0 })
        if i < 23 then task.Wait(10) end
    end                                                             -- t=260..480
end

---MainSub3B：DiveEnemy04B 9 圈 ×2 只（每圈 A 在 x、B 在 x+%RANDF·128+32），
---每只间隔 20 帧（t=30/50/70/…/370，共 18 只）；每圈 x += 32。
t10mid.s04.ms3b = function(card)
    local S = t10mid.s04
    task.Wait(30)                                                   -- //30  A#1
    local x = -128.0
    for k = 1, 9 do
        t10mid.spawn(60, x, -512, false, S.D1, S.de04b, { I0 = 0, I1 = 8, F0 = 0.0 })
        task.Wait(20)
        t10mid.spawn(60, x + rnd() * 128.0 + 32.0, -512, false, S.D1, S.de04b,
                     { I0 = 0, I1 = 8, F0 = 0.0 })
        if k < 9 then task.Wait(20) end
        x = x + 32.0
    end
end

---MainSub4：t=3600 出中 BOSS（跳过）；t=4100 同步调 MainSub5。
t10mid.s04.ms4 = function(card)
    task.Wait(3600)
    task.Wait(500)
    t10mid.s04.ms5(card)                                            -- call("MainSub5")
end

---MainSub5（t=0 相对 abs 4100）：BGirl03 四波（1×5+5、3×8+8）+ 乌鸦 + DiveEnemy00B 六排
---+ MainSub7。第一波用 enmCreateF/MF（原作是 "if no boss" 变体：中 BOSS 在 t=3600 出场、
---  t≈4100 时可能还没走；本移植跳过了中 BOSS ⇒ 无 boss ⇒ F 变体照常生效，按 enmCreate 处理）。
t10mid.s04.ms5 = function(card)
    local S = t10mid.s04
    ---各波共用的两排位置（左列为非镜像版、右列为镜像版）。
    local left8 = {
        { -192, -24 }, { -160, -24 }, { -128, -24 }, { -216, 16 },
        { -220,  32 }, { -220,  64 }, { -220,  96 }, { -220, 128 },
    }
    local right8 = {
        {  192, -24 }, {  160, -24 }, {  128, -24 }, {  216, 16 },
        {  220,  32 }, {  220,  64 }, {  220,  96 }, {  220, 128 },
    }
    ---第一波：左 5（非镜像）t=0/30/60/90/120；右 5（镜像）紧接在左第 5 只后 t=120..240。
    local waveA = {
        { -192, -24 }, { -160, -24 }, { -128, -24 }, { -216, 16 }, { -220, 32 },
    }
    local waveAm = {
        {  192, -24 }, {  160, -24 }, {  128, -24 }, {  216, 16 }, {  220, 32 },
    }
    for i = 1, 5 do
        local e = waveA[i]
        t10mid.spawn(120, e[1], e[2], false, S.D2, S.g03, { I1 = 6 }, 40)
        if i < 5 then task.Wait(30) end
    end
    for i = 1, 5 do
        local f = waveAm[i]
        t10mid.spawn(120, f[1], f[2], true, S.D2, S.g03, { I1 = 8 }, 40)
        if i < 5 then task.Wait(30) end
    end
    ---第二..四波：每波「等 60 → 左 8（10 帧一只）→ 右 8（10 帧一只，紧接左第 8 只）」。
    ---  t=300..440 / 500..640 / 700..840。
    for _ = 1, 3 do
        task.Wait(60)
        for j = 1, 8 do
            local e = left8[j]
            t10mid.spawn(120, e[1], e[2], false, S.D2, S.g03, { I1 = 6 }, 40)
            if j < 8 then task.Wait(10) end
        end
        for j = 1, 8 do
            local f = right8[j]
            t10mid.spawn(120, f[1], f[2], true, S.D2, S.g03, { I1 = 8 }, 40)
            if j < 8 then task.Wait(10) end
        end
    end
    task.Wait(200)                                                  -- //1040
    task.New(card, function() S.ms6l(card) end)                     -- callAsync("MainSub6L")
    task.Wait(30)                                                   -- //1070
    task.New(card, function() S.ms6r(card) end)                     -- callAsync("MainSub6R")
    task.Wait(120)                                                  -- //1190
    task.Wait(10)                                                   -- //1200 第一只
    ---DiveEnemy00B 六排 ×5（y 循环 −512/−576/−640；x 逐排交替 192→−64 / −64→192；
    ---$I0 循环 2/1/0）。t=1200..1490，每 10 帧一只，共 30 只。
    local dz = {
        { -512, 2 }, { -576, 1 }, { -640, 0 },
        { -512, 2 }, { -576, 1 }, { -640, 0 },
    }
    for k, row in ipairs(dz) do
        for i = 1, 5 do
            local x = (k % 2 == 1) and (192 - (i - 1) * 64) or (-64 + (i - 1) * 64)
            t10mid.spawn(60, x, row[1], false, S.D1, S.de00b, { I0 = row[2], I1 = 8, F0 = 0.0 })
            if not (k == 6 and i == 5) then task.Wait(10) end
        end
    end
    task.Wait(200)                                                  -- //1690
    task.New(card, function() S.ms7(card) end)                      -- callAsync("MainSub7")
end

---MainSub6L / MainSub6R：各 25 只 Crow00，x=±216、y=−%RANDF·128，每 6 帧一只。
t10mid.s04.ms6l = function(card)
    local S = t10mid.s04
    for i = 1, 25 do
        t10mid.spawn(20, 216, -rnd() * 128.0, false, S.D1, S.crow00l, nil, 8)
        if i < 25 then task.Wait(6) end
    end
end
t10mid.s04.ms6r = function(card)
    local S = t10mid.s04
    for i = 1, 25 do
        t10mid.spawn(20, -216, -rnd() * 128.0, false, S.D1, S.crow00r, nil, 8)
        if i < 25 then task.Wait(6) end
    end
end

---MainSub7：15 只 DiveEnemy01B（$I0/$I1/%F0/%F1 逐只换）+ 3 只 DiveEnemy02B + 三波 Crow01。
t10mid.s04.ms7 = function(card)
    local S = t10mid.s04
    ---每只用的寄存器（原作「先 enmCreate、再 set 下一只的寄存器」，即出生时用的
    ---就是上一条 set 的值；本表已按「本只使用值」写好）：
    local use = {   -- { x, $I0, $I1, %F0, %F1, 距上一只帧数 }
        {   96, 2, 2, 3.1415927, 0.19635,   0 },
        {  -48, 2, 2, 0.3926991, 0.19635,  20 },
        {   48, 2, 2, 0.3926991, -0.19635, 20 },
        {  -98, 2, 2, 0.0,       -0.19635, 20 },
        {    0, 2, 2, 1.5707964, 0.0,      20 },
        {  -64, 0, 2, 3.1415927, -0.19635, 60 },
        {   80, 1, 2, 0.3926991, -0.19635, 20 },
        {  -16, 0, 2, 0.3926991, 0.19635,  20 },
        {  130, 1, 2, 3.1415927, 0.19635,  20 },
        {   32, 0, 2, 1.5707964, 0.0,      20 },
        {   64, 0, 2, 3.1415927, 0.0,      60 },
        {  -80, 1, 2, 0.3926991, 0.0,      20 },
        {   16, 0, 2, 0.3926991, 0.0,      20 },
        { -128, 1, 2, 0.0,       0.0,      20 },
        {  -32, 0, 2, 1.5707964, 0.0,      20 },
    }
    for _, e in ipairs(use) do
        task.Wait(e[6])
        t10mid.spawn(60, e[1], -640, false, S.D1, S.de01b,
                     { I0 = e[2], I1 = e[3], F0 = e[4], F1 = e[5] })
    end
    task.Wait(50)                                                   -- //410
    t10mid.spawn(60, -96, -512, false, S.D1, S.de02b, { I0 = 0, I1 = 2, F0 = -1.5707964, F1 = 0.0 })
    task.Wait(300)                                                  -- //710
    t10mid.spawn(60,  96, -512, false, S.D1, S.de02b, { I0 = 0, I1 = 2, F0 = -1.5707964, F1 = 0.0 })
    task.Wait(300)                                                  -- //1010
    t10mid.spawn(60,   0, -512, false, S.D1, S.de02b, { I0 = 0, I1 = 2, F0 = -1.5707964, F1 = 0.0 })
    task.Wait(660)                                                  -- //1670
    task.New(card, function() S.ms8l(card) end)
    task.Wait(60)                                                   -- //1730
    task.New(card, function() S.ms8r(card) end)
    task.Wait(200)                                                  -- //1930
    task.New(card, function() S.ms8l(card) end)
    task.Wait(60)                                                   -- //1990
    task.New(card, function() S.ms8r(card) end)
    task.Wait(200)                                                  -- //2190
    task.New(card, function() S.ms8l(card) end)
    task.Wait(60)                                                   -- //2250
    task.New(card, function() S.ms8r(card) end)
end

---MainSub8L / MainSub8R：各 25 只 Crow01，x=±216、y=−%RANDF·128，每 12 帧一只。
t10mid.s04.ms8l = function(card)
    local S = t10mid.s04
    for i = 1, 25 do
        t10mid.spawn(20, 216, -rnd() * 128.0, false, S.D1, S.crow01l, nil, 8)
        if i < 25 then task.Wait(12) end
    end
end
t10mid.s04.ms8r = function(card)
    local S = t10mid.s04
    for i = 1, 25 do
        t10mid.spawn(20, -216, -rnd() * 128.0, false, S.D1, S.crow01r, nil, 8)
        if i < 25 then task.Wait(12) end
    end
end

---道中总时间轴（main 的 callAsync MainSub1 / MainSub4）。
t10mid.s04.run = function(card)
    local S = t10mid.s04
    task.New(card, function() S.ms1(card) end)                      -- callAsync("MainSub1")
    task.New(card, function() S.ms4(card) end)                      -- callAsync("MainSub4")
end

---挂到空 boss「ea」上的一张耐久符卡（与 stage01/02/03/06 道中同一套注册方式）。
---时长：最后一批 Crow01 在道中开始后约 8328 帧 ⇒ 150 秒留余量。
boss.Define("ea", "道中", "TH10_1", TH10_bg, { 0, 400 }, nil, "img_void", LEVEL)
t10mid.s04card = boss.card.New("四道中「妖怪の山」", 150, 150, 150, 10000000)
function t10mid.s04card:before()
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
end
function t10mid.s04card:init()
    t10mid.clear(); t10mid.ax, t10mid.ay = 0, 0
    task.New(self, function() t10mid.s04.run(self) end)
end
function t10mid.s04card:frame() end
function t10mid.s04card:render() end
function t10mid.s04card:del() t10mid.clear() end
boss.card.add({ { t10mid.s04card, "ea" } }, LEVEL, "四道中「妖怪の山」", 3683)
--=====================================
-- 十、stage05 道中（河童の渓谷：Cir 妖精群 + Girl 妖精群）—— 原生 LuaSTG「道中搬运卡」
--   原作 `data/stage05.ecl` 的 main 派生段：callAsync MainSub1 / MainSubMBoss。
--   MainSub1→2→3→(4/5/6/7)，MainSub7 再叫一次 MainSub5；MainSubMBoss 等 3800 帧出
--   中 BOSS，中 BOSS 死后再 callAsync MainSub8→(9/10/11)。本仓库把中 BOSS 单独做成
--   另一张卡（组 9），所以这里跳过 MBoss 本体，只在 3800 帧后用固定等待接 MainSub8
--   （近似：原作是 `deathWait`，等中 BOSS 死；见 t10mid.s05.MBOSS_WAIT）。
--
--   只做 Lunatic 行：etCountD/etSpeedD 取第 4/8 项、diffI/diffF 取第 4 项、
--   diffWait(a,b,c,d) 取第 4 项；`!L`/`!HL` 块生效，`!E`/`!EN`/`!H` 块跳过。
--   stage05 的道中**没有**章节 rank 缩放。
--
--   跳过 / 近似（都写在对应位置）
--     · `MapleEnemy`（main 里一只纯观感敌机，无弹幕）——跳过；
--     · `MBoss`/`MainSubMBoss`（t≈3800 才出场的中 BOSS）——本卡不移植 BOSS；
--     · `setHurtbox/setHitbox/setInvuln/unknown361/flagSet/anm*/playSound/drop*/
--       计时），其余按无效果处理，但占的 wait 边界原样保留；
--     · 妖精贴图一律 `servant`（原作 anmSetSprite 的色号只决定敌人外形）；
--     · 掉落：原作 `dropMain(N)` + enmCreate 第 6 参 `itemDropType`；这里按敌人名的
--       色前缀折成 {信仰,P,点} 近似表（D 表），未着色的一律按 R。
--
--   ★ 关键语义（照复原源码；改代码前先读）
--     · 世界位置 = base + offset；enmCreate/enmCreateA/M 都把出生点写进 offsetMotion。
--     · `xxxL` 后缀（如 Girl00L）是原作**手工镜像**的右侧版（入场角不同）——它不用
--       enmCreateM，`%ANGLE_PLAYER` 也不该被折角，所以必须单独一套行为；
--       而 MainSub5/10/11 的右侧用 `enmCreateM`（镜像标志），走 `t10mid.mirror`。
--     · `%RAND` 是**有符号** 32 位随机（可负），`%RAND%n` 照 C 的 `%` 语义。
--     · `etAngle(slot,a,step)` 同时写基准角与角步长 ⇒ 只改基准角时 step 要照抄。
--     · `etOn` = fire_slot；本框架 pattern 槽/transform 记录全在上面的 et_* 运行时里。
--=====================================
t10mid.s05 = {}

---掉落近似（原作 dropMain：R→1、B→2、G→3、Y→0；Dropitem_PFP 用 {信仰,P,点}）。
t10mid.s05.DROP = {
    R = { 0, 1, 1 },
    B = { 0, 2, 2 },
    G = { 0, 3, 3 },
    Y = { 0, 0, 1 },
}

---血量（原作 enmCreate 第 4 参）与入场无敌帧（setInvuln）。
t10mid.s05.HP = {
    Cir00 = 20, Cir01 = 20, Cir02 = 20,
    Girl00 = 60, Girl00L = 60, Girl01 = 600, Girl02 = 20, Girl03 = 3000, Girl04 = 20,
}
t10mid.s05.INV = { Girl01 = 120, Girl03 = 120 }

---跳过中 BOSS 后接 MainSub8 的等待（原作：3800 帧后出中 BOSS，再等它死）。
t10mid.s05.MBOSS_WAIT = 3800

---========================= Cir 系（入场圆周妖精） =========================
---Cir00_at：每 (30 ~ 89) 帧一发（L：7 发自机扇形、基准角自机向、角步长 π/48、速 5.0→1.0）。
t10mid.s05.cir00_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 4, f.I0 or 6)
    et_count(f, 0, 7, 1)                        -- etCountD(0, 1,3,5,7, 1,1,1,1) 的 L 行
    et_angle(f, 0, 0.0, 0.06544985)
    et_speed(f, 0, 5.0, 1.0)                    -- etSpeedD(0, 1.4,2.0,4.0,5.0, 1,1,1,1) 的 L 行
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)   -- 记录 0（随即被下一条覆盖）
    et_ex(f, 0, 0, 1, 1, -999999, -999999, -999999.0, -999999.0)   -- 记录 0 = DECEL
    while true do
        local w = t10_rand_mod60() + 30         -- wait(($RAND%60)+30)
        if w > 0 then task.Wait(w) end
        fire_slot(f, 0)
    end
end

---Cir00：入场 moveVel(3π/8, 4.0)，+40 帧后 80 帧内把角转到 −3π/8（速度保持）。
t10mid.s05.cir00 = function(f)
    t10mid.vel(f, 1.1780972, 4.0)
    task.New(f, function() t10mid.s05.cir00_at(f) end)
    task.Wait(40)
    t10mid.vel_time(f, 80, 0, -1.1780972, -999999)
end

---Cir01_at：每 (10 ~ 49) 帧一发（L：5 发环、角步长 π/48、速 4.0→1.0）。
t10mid.s05.cir01_at = function(f)
    et_new(f, 0); et_aim(f, 0, 2); et_sprite(f, 0, 3, f.I0 or 2)
    et_count(f, 0, 5, 1)                        -- etCountD(0, 5,5,5,5, 1,1,1,1) 的 L 行
    et_angle(f, 0, 0.0, 0.06544985)
    et_speed(f, 0, 4.0, 1.0)                    -- etSpeedD(0, 1.5,3.0,3.5,4.0, 1,1,1,1) 的 L 行
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 0, 1, 1, -999999, -999999, -999999.0, -999999.0)
    while true do
        local w = t10_imod(t10_randmod(), 40) + 10   -- !L: wait(%RAND%40+10)
        if w > 0 then task.Wait(w) end
        fire_slot(f, 0)
    end
end

---Cir01：与 Cir00 同一条入场运动（原作两份代码逐条相同）。
t10mid.s05.cir01 = function(f)
    t10mid.vel(f, 1.1780972, 4.0)
    task.New(f, function() t10mid.s05.cir01_at(f) end)
    task.Wait(40)
    t10mid.vel_time(f, 80, 0, -1.1780972, -999999)
end

---Cir02_at：等 $I1 帧后**只打一发**（L：4 发 × 6 环、基准角 π/2、速 5.0→1.0）。
---   $I1 在同排内逐只 +5 ⇒ 15 只排成一条由 0 递增到 70 的错峰。
t10mid.s05.cir02_at = function(f)
    et_new(f, 0); et_aim(f, 0, 3); et_sprite(f, 0, 4, f.I0 or 13)
    et_count(f, 0, 4, 6)
    et_angle(f, 0, 1.5707964, 0.0)
    et_speed(f, 0, 5.0, 1.0)                    -- !HL: etSpeed(0, 5.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 0, 1, 1, -999999, -999999, -999999.0, -999999.0)
    if (f.I1 or 0) > 0 then task.Wait(f.I1) end
    fire_slot(f, 0)
end

---Cir02：入场运动与 Cir00 相同。
t10mid.s05.cir02 = function(f)
    t10mid.vel(f, 1.1780972, 4.0)
    task.New(f, function() t10mid.s05.cir02_at(f) end)
    task.Wait(40)
    t10mid.vel_time(f, 80, 0, -1.1780972, -999999)
end

---========================= Girl 系（俯冲妖精） =========================
---Girl00_at：一次性环形弹（L：16 发 × 3 环、基准角自机向、速 3.3→0.3，
---   外加「记录 2 = kind 128、i0 60、i1 1、f0 0.0、f1 2.5」的变换程序）。
t10mid.s05.g00_at = function(f)
    et_new(f, 0); et_aim(f, 0, 2); et_sprite(f, 0, 4, 2)
    et_count(f, 0, 16, 3)                       -- etCountD(0, 3,16,16,16, 1,1,2,3) 的 L 行
    et_angle(f, 0, 0.0, 0.0)
    et_speed(f, 0, 3.3, 0.3)                    -- etSpeedD(0, 0.3,0.3,1.3,3.3, 0.3,0.3,0.3,0.3) 的 L 行
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 1, 1, 1, -999999, -999999, -999999.0, -999999.0)
    et_ex(f, 0, 2, 0, 128, 60, 1, 0.0, 2.5)     -- !L：记录 2
    fire_slot(f, 0)
end

---Girl00：45° 入场、$I0 帧内减速停下、再等 $I0 帧、朝自机 40 帧加速到 2.0，出弹一次。
t10mid.s05.g00 = function(f)
    t10mid.vel(f, 0.7853982, f.F0 or 5.0)
    t10mid.vel_time(f, f.I0 or 40, 0, -999999, 0.0)
    task.Wait(f.I0 or 40)
    t10mid.vel(f, t10_angle_player(f), 0.0)
    t10mid.vel_time(f, 40, 0, -999999, 2.0)
    task.New(f, function() t10mid.s05.g00_at(f) end)
end

---Girl00L：Girl00 的手工镜像版（135° 入场）。
t10mid.s05.g00l = function(f)
    t10mid.vel(f, 2.3561945, f.F0 or 5.0)
    t10mid.vel_time(f, f.I0 or 40, 0, -999999, 0.0)
    task.Wait(f.I0 or 40)
    t10mid.vel(f, t10_angle_player(f), 0.0)
    t10mid.vel_time(f, 40, 0, -999999, 2.0)
    task.New(f, function() t10mid.s05.g00_at(f) end)
end

---Girl01_at：槽 1（16 发扇形、基准角 %F0+π、角步长 π/12、速 3.0）；每 8 帧把基准角
---   +4.0 弧度（validRad 折回），转 39 拍。%F0/%F1 由 Girl01 用 callAsync 参数传给本线程。
t10mid.s05.g01_at = function(f)
    local a = t10_wrap((f.F0 or 0.0) + TH10_PI)
    et_new(f, 1); et_aim(f, 1, 1); et_sprite(f, 1, 5, 2)
    et_count(f, 1, 16, 1)
    et_angle(f, 1, a, 0.2617994)
    et_speed(f, 1, 3.0, 1.0)
    et_ex(f, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 40 - 1
    while n ~= 0 do
        et_angle(f, 1, a, 0.2617994)
        fire_slot(f, 1)
        a = t10_wrap(a + 4.0)
        task.Wait(8)
        n = n - 1
    end
end

---Girl01_at2：槽 0（单发、基准角 %F0、速 3.5）；每 4 帧一发、基准角 +4.0 弧度；
---   内层 10→9 拍、圈间等 8 帧（L）、外层 4→3 圈。
t10mid.s05.g01_at2 = function(f)
    local a = t10_wrap(f.F0 or 0.0)
    et_new(f, 0); et_aim(f, 0, 3); et_sprite(f, 0, 5, 6)
    et_count(f, 0, 1, 1)
    et_angle(f, 0, a, 0.0)
    et_speed(f, 0, 3.5, 0.8)                    -- etSpeedD(0, 1.5,1.5,2.5,3.5, 0.8,0.8,0.8,0.8) 的 L 行
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local outer = 4 - 1
    while outer ~= 0 do
        local n = 10 - 1
        while n ~= 0 do
            et_angle(f, 0, a, 0.0)
            fire_slot(f, 0)
            a = t10_wrap(a + 4.0)
            task.Wait(4)
            n = n - 1
        end
        task.Wait(8)                            -- diffWait(32,32,16,8) 的 L 行
        outer = outer - 1
    end
end

---Girl01：直下入场（π/2、速 5.0）60 帧内停下；+60 起两条 _at 线程；+380 转向 π/2、
---   加速到 2.0。setInvuln(120) ⇒ 入场 120 帧无敌。
t10mid.s05.g01 = function(f)
    t10mid.vel(f, 1.5707964, 5.0)
    t10mid.vel_time(f, 60, 4, -999999, 0.0)
    task.Wait(60)
    task.New(f, function() t10mid.s05.g01_at(f) end)
    task.New(f, function() t10mid.s05.g01_at2(f) end)
    task.Wait(320)
    t10mid.vel_time(f, 40, 4, 1.5707964, 2.0)
end

---Girl02_at：单发自机狙（基准角自机向、速 5.0）；L：立即首发，之后每 20~69 帧一发，
---   共 59 发（计数器 60 → deci/jmpNeq ⇒ 跑 59 圈）。
t10mid.s05.g02_at = function(f)
    et_new(f, 0); et_aim(f, 0, 2); et_sprite(f, 0, 12, 6)
    et_count(f, 0, 1, 1)
    et_angle(f, 0, 0.0, 0.06544985)
    et_speed(f, 0, 5.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 60 - 1
    while n ~= 0 do
        local w = t10_imod(t10_randmod(), 50) + 20   -- !L: wait(%RAND%50+20)
        if w > 0 then task.Wait(w) end
        fire_slot(f, 0)
        n = n - 1
    end
end

---Girl02：45° 入场速 6.0；+30 转向 π、减速到 1.0；+90 转向 −π/4、加速到 5.0。
t10mid.s05.g02 = function(f)
    task.New(f, function() t10mid.s05.g02_at(f) end)
    t10mid.vel(f, 0.7853982, 6.0)
    task.Wait(30)
    t10mid.vel_time(f, 60, 0, 3.1415927, 1.0)
    task.Wait(60)
    t10mid.vel_time(f, 60, 0, -0.7853982, 5.0)
end

---Girl03_at：槽 1（16 发扇形、基准角**每拍重算** %ANGLE_PLAYER+π、角步长 π/10、速 3.0）；
---   每 8 帧一拍，共 39 拍。
t10mid.s05.g03_at = function(f)
    et_new(f, 1); et_aim(f, 1, 1); et_sprite(f, 1, 5, 2)
    et_count(f, 1, 16, 1)
    et_angle(f, 1, 0.0, 0.2617994)
    et_speed(f, 1, 3.0, 1.0)
    et_ex(f, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 40 - 1
    while n ~= 0 do
        et_angle(f, 1, t10_wrap(t10_angle_player(f) + TH10_PI), 0.31415927)
        fire_slot(f, 1)
        task.Wait(8)
        n = n - 1
    end
end

---Girl03_at2：槽 0（8 发同心不同速的「直线流」、基准角 %RANDRAD、速 3.5→0.8）；
---   每 1 帧一发，内层 80→79 拍、圈间等 32 帧（L）、外层 4→3 圈。
t10mid.s05.g03_at2 = function(f)
    et_new(f, 0); et_aim(f, 0, 3); et_sprite(f, 0, 5, 6)
    et_count(f, 0, 1, 8)                        -- etCountD(0, 1,1,1,1, 3,3,5,8) 的 L 行
    et_angle(f, 0, 0.0, 0.0)
    et_speed(f, 0, 3.5, 0.8)                    -- etSpeedD(0, 1.5,1.5,2.5,3.5, 0.8,0.8,0.8,0.8) 的 L 行
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local outer = 4 - 1
    while outer ~= 0 do
        local n = 80 - 1                        -- diffI([8], 30,80,80,80) 的 L 行
        while n ~= 0 do
            et_angle(f, 0, rndrad(), 0.0)       -- etAngle(0, %RANDRAD, 0.0)
            fire_slot(f, 0)
            task.Wait(1)
            n = n - 1
        end
        task.Wait(32)                           -- diffWait(80,32,32,32) 的 L 行
        outer = outer - 1
    end
end

---Girl03：与 Girl01 同一条入场运动 + setInvuln(120)。
t10mid.s05.g03 = function(f)
    t10mid.vel(f, 1.5707964, 5.0)
    t10mid.vel_time(f, 60, 4, -999999, 0.0)
    task.Wait(60)
    task.New(f, function() t10mid.s05.g03_at(f) end)
    task.New(f, function() t10mid.s05.g03_at2(f) end)
    task.Wait(320)
    t10mid.vel_time(f, 40, 4, 1.5707964, 2.0)
end

---Girl04_at：L：5 发散形自机狙（角步长 π/8、速 3.5）；首发等 60~179 帧，共 59 发。
t10mid.s05.g04_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 12, 6)
    et_count(f, 0, 5, 1)                        -- etCountD(0, 1,1,3,5, 1,1,1,1) 的 L 行
    et_angle(f, 0, 0.0, 0.3926991)
    et_speed(f, 0, 3.5, 1.0)                    -- etSpeedD(0, 1.5,2.5,3.0,3.5, 1,1,1,1) 的 L 行
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 60 - 1
    while n ~= 0 do
        local w = t10_imod(t10_randmod(), 120) + 60  -- wait(%RAND%120+60)
        if w > 0 then task.Wait(w) end
        fire_slot(f, 0)
        n = n - 1
    end
end

---Girl04：与 Girl02 同一条运动。
t10mid.s05.g04 = function(f)
    task.New(f, function() t10mid.s05.g04_at(f) end)
    t10mid.vel(f, 0.7853982, 6.0)
    task.Wait(30)
    t10mid.vel_time(f, 60, 0, 3.1415927, 1.0)
    task.Wait(60)
    t10mid.vel_time(f, 60, 0, -0.7853982, 5.0)
end


---========================= 时间轴 =========================
---道中锚点在 (0,0)（原作 main 那条 ECL 敌机不移动），所以 enmCreate 的 x/y 即绝对坐标。
t10mid.s05.BEH = {
    Cir00 = t10mid.s05.cir00, Cir01 = t10mid.s05.cir01, Cir02 = t10mid.s05.cir02,
    Girl00 = t10mid.s05.g00, Girl00L = t10mid.s05.g00l,
    Girl01 = t10mid.s05.g01, Girl02 = t10mid.s05.g02,
    Girl03 = t10mid.s05.g03, Girl04 = t10mid.s05.g04,
}

---名字 = 色前缀（B/R/G/Y，决定掉落表）+ 基础名（决定行为/血量）。
---「xxxL」后缀是原作**手工镜像**的右侧版（别和 enmCreateM 的镜像标志搞混）。
t10mid.s05.one = function(name, x, y, mirror, src)
    local S = t10mid.s05
    local base, col = name, "R"
    if not S.BEH[name] then col = name:sub(1, 1); base = name:sub(2) end
    t10mid.spawn(S.HP[base], x, y, mirror, S.DROP[col], S.BEH[base], src, S.INV[base] or 0)
end

---色序串 → 敌人名表：S.n("BBBRR", "Girl02") = { "BGirl02","BGirl02","BGirl02","RGirl02","RGirl02" }。
t10mid.s05.n = function(seq, base)
    local t = {}
    for i = 1, #seq do t[i] = seq:sub(i, i) .. base end
    return t
end
---按「下标 → src」取值的辅助（配对排里两只的 $I/%F 不同）。
t10mid.s05.idx = function(t) return function(i) return t[i] end end
---Girl01 两只一对的 %F0/%F1（原作逐只 setf；Girl01_at / _at2 拿它当栈参数）。
t10mid.s05.G01 = { { F0 = 1.178097, F1 = 0.024544 }, { F0 = 1.963495, F1 = -0.024544 } }
t10mid.s05.g01src = t10mid.s05.idx(t10mid.s05.G01)
---Cir02 每排内 $I1 逐只 +5（= wait($I1) 的错峰帧数）。
t10mid.s05.cir2src = function(i) return { I0 = 13, I1 = (i - 1) * 5 } end
t10mid.s05.CIR0SRC = { I0 = 6 }
t10mid.s05.CIR1SRC = { I0 = 2 }
t10mid.s05.G00SRC = { { F0 = 5, I0 = 40 }, { F0 = 5, I0 = 60 }, { F0 = 5, I0 = 80 } }
t10mid.s05.G00S10 = t10mid.s05.G00SRC[1]
t10mid.s05.G00S20 = t10mid.s05.G00SRC[2]
t10mid.s05.G00S30 = t10mid.s05.G00SRC[3]
t10mid.s05.G00R = { F0 = 5, I0 = 60 }

---一把「排」：{ 距上一排的帧数, x, y, mirror, 排内帧距, 名字表, src }。
---  x 可是数字（整排同 x）或数组（逐只不同 x）；src 可是表、表数组或函数。
t10mid.s05.row = function(dt, x, y, mirror, gap, names, src)
    if dt > 0 then task.Wait(dt) end
    for i = 1, #names do
        local sx = (type(x) == "table") and x[i] or x
        local ss = src
        if type(src) == "function" then ss = src(i)
        elseif type(src) == "table" and type(src[1]) == "table" then ss = src[i] end
        t10mid.s05.one(names[i], sx, y, mirror, ss)
        if i < #names and gap > 0 then task.Wait(gap) end
    end
end

---MainSub1：t=160 起 4 排 Cir00（左 −192 / 右镜像 192 / 左 −144 / 右镜像 144），每 8 帧一只。
t10mid.s05.ms1 = function(card)
    local S = t10mid.s05
    S.row(160, -192.0, -24.0, false, 8, S.n("BBBBRRBBBBRRGG", "Cir00"), { I0 = 6 })
    S.row(48, 192.0, -24.0, true, 8, S.n("BBBBBRRBBRRRRRR", "Cir00"), { I0 = 6 })
    S.row(40, -144.0, -24.0, false, 8, S.n("BBBBRRBBBBRRGG", "Cir00"), { I0 = 6 })
    S.row(48, 144.0, -24.0, true, 8, S.n("BBBBBRRBBRRRRGG", "Cir00"), { I0 = 6 })
    task.New(card, function() S.ms2(card) end)
end

---MainSub2：t=240 起 Girl00 三批（$I0 = 40/60/80 决定减速时长），左 −216 + 右 216L。
t10mid.s05.ms2 = function(card)
    local S = t10mid.s05
    S.row(240, { -216.0, 216.0 }, 64.0, false, 15, { "BGirl00", "BGirl00L" }, { F0 = 5, I0 = 40 })
    S.row(30, { -216.0, 216.0 }, 96.0, false, 15, { "BGirl00", "BGirl00L" }, { F0 = 5, I0 = 40 })
    S.row(30, { -216.0, 216.0 }, 48.0, false, 15, { "BGirl00", "BGirl00L" }, { F0 = 5, I0 = 40 })
    S.row(30, { -216.0, 216.0 }, 64.0, false, 15, { "RGirl00", "RGirl00L" }, { F0 = 5, I0 = 60 })
    S.row(30, { -216.0, 216.0 }, 96.0, false, 15, { "RGirl00", "RGirl00L" }, { F0 = 5, I0 = 60 })
    S.row(30, { -216.0, 216.0 }, 48.0, false, 15, { "RGirl00", "RGirl00L" }, { F0 = 5, I0 = 60 })
    S.row(30, { -216.0, 216.0 }, 64.0, false, 15, { "BGirl00", "BGirl00L" }, { F0 = 5, I0 = 80 })
    S.row(30, { -216.0, 216.0 }, 96.0, false, 15, { "BGirl00", "BGirl00L" }, { F0 = 5, I0 = 80 })
    S.row(30, { -216.0, 216.0 }, 48.0, false, 15, { "GGirl00", "GGirl00L" }, { F0 = 5, I0 = 80 })
    task.New(card, function() S.ms3(card) end)
end

---MainSub3：t=120 起 4 对 Girl01（$F0/$F1 逐对换），并在 t=720/1040/1180/1500 排 4/5/6/7。
t10mid.s05.ms3 = function(card)
    local S = t10mid.s05
    S.row(120, { -64.0, 64.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
    S.row(120, { -96.0, 96.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
    S.row(120, { -64.0, 64.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
    S.row(120, { -48.0, 48.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
    task.New(card, function() S.ms4(card) end)
    task.Wait(320)
    task.New(card, function() S.ms5(card) end)
    task.Wait(140)
    task.New(card, function() S.ms6(card) end)
    task.Wait(320)
    task.New(card, function() S.ms7(card) end)
end

---MainSub4：t=30 起 3 对 RGirl00 / RGirl00L（$F0=5.0、$I0=60）。
t10mid.s05.ms4 = function(card)
    local S = t10mid.s05
    S.row(30, { -216.0, 216.0 }, 64.0, false, 15, { "RGirl00", "RGirl00L" }, { F0 = 5, I0 = 60 })
    S.row(30, { -216.0, 216.0 }, 96.0, false, 15, { "RGirl00", "RGirl00L" }, { F0 = 5, I0 = 60 })
    S.row(30, { -216.0, 216.0 }, 48.0, false, 15, { "RGirl00", "RGirl00L" }, { F0 = 5, I0 = 60 })
end

---MainSub5：4 排 Girl02（每排左 5 + 右镜像 5，排内 10 帧一只、排间 0 帧）。
t10mid.s05.ms5 = function(card)
    local S = t10mid.s05
    S.row(0, { -216.0, -168.0, -96.0, -128.0, -192.0 }, -24.0, false, 10, S.n("BBBRR", "Girl02"), nil)
    S.row(0, { 216.0, 168.0, 96.0, 128.0, 192.0 }, -24.0, true, 10, S.n("BBBRR", "Girl02"), nil)
    S.row(0, { -216.0, -168.0, -96.0, -128.0, -192.0 }, -24.0, false, 10, S.n("BBBBB", "Girl02"), nil)
    S.row(0, { 216.0, 168.0, 96.0, 128.0, 192.0 }, -24.0, true, 10, S.n("BBBBB", "Girl02"), nil)
    S.row(0, { -216.0, -168.0, -96.0, -128.0, -192.0 }, -24.0, false, 10, S.n("BBBRR", "Girl02"), nil)
    S.row(0, { 216.0, 168.0, 96.0, 128.0, 192.0 }, -24.0, true, 10, S.n("BBBRR", "Girl02"), nil)
    S.row(0, { -216.0, -168.0, -96.0, -128.0, -192.0 }, -24.0, false, 10, S.n("BBBGG", "Girl02"), nil)
    S.row(0, { 216.0, 168.0, 96.0, 128.0, 192.0 }, -24.0, true, 10, S.n("BBBGG", "Girl02"), nil)
end

---MainSub6：同 MainSub4（再来一遍）。
t10mid.s05.ms6 = function(card)
    local S = t10mid.s05
    S.row(30, { -216.0, 216.0 }, 64.0, false, 15, { "RGirl00", "RGirl00L" }, { F0 = 5, I0 = 60 })
    S.row(30, { -216.0, 216.0 }, 96.0, false, 15, { "RGirl00", "RGirl00L" }, { F0 = 5, I0 = 60 })
    S.row(30, { -216.0, 216.0 }, 48.0, false, 15, { "RGirl00", "RGirl00L" }, { F0 = 5, I0 = 60 })
end

---MainSub7：t=120 起 4 对 Girl01，并在 t=360 再喊一次 MainSub5。
t10mid.s05.ms7 = function(card)
    local S = t10mid.s05
    S.row(120, { -64.0, 64.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
    S.row(120, { -96.0, 96.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
    task.New(card, function() S.ms5(card) end)
    S.row(120, { -64.0, 64.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
    S.row(120, { -48.0, 48.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
end

---MainSub8：t=120 起 4 对 Girl01、t=1020 一只 Girl03，并在 t=360/1420/1620 排 MainSub9/10/11。
t10mid.s05.ms8 = function(card)
    local S = t10mid.s05
    S.row(120, { -64.0, 64.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
    S.row(120, { -96.0, 96.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
    task.New(card, function() S.ms9(card) end)
    S.row(120, { -64.0, 64.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
    S.row(120, { -48.0, 48.0 }, -32.0, false, 60, { "Girl01", "Girl01" }, S.g01src)
    S.row(300, 0.0, -32.0, false, 0, { "Girl03" }, nil)
    task.Wait(400)
    task.New(card, function() S.ms10(card) end)
    task.Wait(200)
    task.New(card, function() S.ms11(card) end)
end

---MainSub9：t=0 起 4 排 Cir01（y=−64），每 8 帧一只。
t10mid.s05.ms9 = function(card)
    local S = t10mid.s05
    S.row(0, -192.0, -64.0, false, 8, S.n("BBBBRRBBBBRRGG", "Cir01"), { I0 = 2 })
    S.row(48, 192.0, -64.0, true, 8, S.n("BBBBBRRBBRRRRRR", "Cir01"), { I0 = 2 })
    S.row(40, -144.0, -64.0, false, 8, S.n("BBBBRRBBBBRRGG", "Cir01"), { I0 = 2 })
    S.row(48, 144.0, -64.0, true, 8, S.n("BBBBBRRBBRRRRGG", "Cir01"), { I0 = 2 })
end

---MainSub10：t=0 起 5 排 Cir02（y=−24）；$I1 在这一排内 0,5,10,… 递增（错峰开火）。
t10mid.s05.ms10 = function(card)
    local S = t10mid.s05
    S.row(0, -192.0, -24.0, false, 8, S.n("BBBBRRBBBBRRGG", "Cir02"), S.cir2src)
    S.row(48, 192.0, -24.0, true, 8, S.n("BBBBBRRBBRRRRRR", "Cir02"), S.cir2src)
    S.row(40, -144.0, -24.0, false, 8, S.n("BBBBRRBBBBRRGG", "Cir02"), S.cir2src)
    S.row(48, 144.0, -24.0, true, 8, S.n("BBBBBRRBBRRRRGG", "Cir02"), S.cir2src)
    S.row(40, -192.0, -24.0, false, 8, S.n("BBBBRRBBBBRRGG", "Cir02"), S.cir2src)
end

---MainSub11：4 排 Girl04（每排左 5 + 右镜像 5）。
t10mid.s05.ms11 = function(card)
    local S = t10mid.s05
    S.row(0, { -216.0, -168.0, -96.0, -128.0, -192.0 }, -24.0, false, 10, S.n("BBBBB", "Girl04"), nil)
    S.row(0, { 216.0, 168.0, 96.0, 128.0, 192.0 }, -24.0, true, 10, S.n("BBBBB", "Girl04"), nil)
    S.row(0, { -216.0, -168.0, -96.0, -128.0, -192.0 }, -24.0, false, 10, S.n("BBBBB", "Girl04"), nil)
    S.row(0, { 216.0, 168.0, 96.0, 128.0, 192.0 }, -24.0, true, 10, S.n("BBBBB", "Girl04"), nil)
    S.row(0, { -216.0, -168.0, -96.0, -128.0, -192.0 }, -24.0, false, 10, S.n("BBBBB", "Girl04"), nil)
    S.row(0, { 216.0, 168.0, 96.0, 128.0, 192.0 }, -24.0, true, 10, S.n("BBBBB", "Girl04"), nil)
    S.row(0, { -216.0, -168.0, -96.0, -128.0, -192.0 }, -24.0, false, 10, S.n("BBBGG", "Girl04"), nil)
    S.row(0, { 216.0, 168.0, 96.0, 128.0, 192.0 }, -24.0, true, 10, S.n("BBBGG", "Girl04"), nil)
end

---MainSubMBoss：原作等 3800 帧出中 BOSS，等它死后才叫 MainSub8。
---本卡的「中 BOSS」是另一张卡（组 9），所以跳过 MBoss 本体，只用 MBOSS_WAIT 近似
---「开打前的等待」。要更贴近原作节奏就调大它。
t10mid.s05.msMBoss = function(card)
    local S = t10mid.s05
    task.Wait(S.MBOSS_WAIT)
    task.New(card, function() S.ms8(card) end)
end

---道中总时间轴（main 的 callAsync MainSub1 / MainSubMBoss）。
t10mid.s05.run = function(card)
    local S = t10mid.s05
    task.New(card, function() S.ms1(card) end)        -- callAsync("MainSub1")
    task.New(card, function() S.msMBoss(card) end)    -- callAsync("MainSubMBoss")
end

---挂到空 boss「fa」上的一张耐久符卡（与 stage01/02/03/04/06 道中同一套注册方式）。
---时长：最后一批妖精（MainSub11，约 t=5740 帧）⇒ 120 秒留余量。
boss.Define("fa", "道中", "TH10_1", TH10_bg, { 0, 400 }, nil, "img_void", LEVEL)
t10mid.s05card = boss.card.New("五道中「洩矢の王国跡」", 120, 120, 120, 10000000)
function t10mid.s05card:before()
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
end
function t10mid.s05card:init()
    t10mid.clear(); t10mid.ax, t10mid.ay = 0, 0
    task.New(self, function() t10mid.s05.run(self) end)
end
function t10mid.s05card:frame() end
function t10mid.s05card:render() end
function t10mid.s05card:del() t10mid.clear() end
boss.card.add({ { t10mid.s05card, "fa" } }, LEVEL, "五道中「洩矢の王国跡」", 3684)
--=====================================
-- 十四、stage07（Extra）道中（妖精群 + 大妖精）—— 原生 LuaSTG「道中搬运卡」
--   把原作 `data/stage07.ecl` 的**道中段**（`main` 派生的 MainSub1..10：成群的
--   小妖精 + 三只大妖精 Girl01/Girl03/Girl04 + 六只 Girl02）复刻成**一张**符卡，
--   挂在一个空的 `img_void` boss 上（与本文件其它道中卡同一套做法）。
--   **不用 ECL 字节码 VM**：时间轴、出弹、走位全部翻成原生 LuaSTG。
--
--   数据来源
--     · thecl 的原始反汇编（带 TH10 名字表，见本文件顶部）：
--         thecl -d 10 -r -x -m MAP/th10.eclm stage07.ecl out.txt
--     · `main` → t=0 `callAsync MainSub1`；t=10000 再叫一次 MainSub1；t=20000 `delete()`。
--       MainSub1→2→3→4→5→6→7→8→9→10 是**同一条 ECL 敌机上的线程**（callAsync 会把
--       该线程的时钟归零、坐标仍用同一「道中锚点」）。本关锚点不移动（0,0）⇒
--       enmCreate 的 x/y 即**绝对坐标**（y 从上往下量，472 = 从下边入场）。
--
--   跳过 / 近似（都写在对应位置）
--     · `MapleEnemy`（main 里一只纯观感敌机）——跳过；
--     · `MainSub7`：原作在这里 `enmCreateA("MBoss", …)` + dialogRead/dialogWait 后
--       `deathWait` 等中 BOSS 死。本仓库的中 BOSS 是另一张卡（组 1a = 神奈子），
--       所以这里只按固定帧数近似「等中 BOSS 打完」，再 callAsync MainSub8。
--     · `MainSubBoss`（道中末尾出 BOSS 本体）——不移植（本仓库另一张卡）。
--     · 演出/流程指令（anm*/flagSet/setHurtbox/setHitbox/dropClear/dropExtra/dropArea/
--       dialog*/playSound/计时）按无效果处理，但它们占的 wait 边界原样保留。
--     · 妖精贴图一律 `servant`（原作 anmSetSprite 的色号只决定敌人外形）；
--       弹样式按原作 etSprite 的 type/color 查 `T10_STYLE` / `t10_color`。
--     · 掉落：原作 `dropMain(N)` 的 N 就是名字的色前缀（R→1/B→2/G→3/Y→0），
--       这里折成 {信仰,P,点} 近似表（D 表）。唯一例外：原作 `YGirl06b` 的
--       包装子程序没有 dropMain（近似按 Y 处理）。
--     · `wait(%RAND % 10)`（Girl05/06 的开火错峰）：原作 `%RAND` 有符号、C 的 `%`
--       结果也可能为负，而 VM 的 wait 是 `clock -= n` ⇒ 负值会让线程的时钟**前跳**。
--       本文件按其它道中卡同款写法只处理「> 0 才等」，负值当 0（最多影响 Girl05/06
--       三发弹的几帧错峰，见 t10mid.s07.go05_at / go06_at）。
--
--   ★ 关键语义（照复原源码；改代码前先读）
--     · 世界位置 = base + offset；enmCreate/enmCreateA/M 都把出生点写进 offsetMotion。
--     · 本关**没有难度分级**（整关一条 rank 判据都没有）⇒ 所有指令按原样执行。
--     · `etAngle(slot,a,step)` 同时写基准角与角步长 ⇒ 只改基准角时 step 要照抄。
--     · `etEx(0,0,1,4,…)` 的记录 kind=4 在复原源码里落到 default（空操作）⇒
--       本关道中的弹一律**匀速直线**（对照 stage05 的 Cir00_at 是 kind=1 DECEL）。
--     · `deci(v); jmpNeq(L,0)` = 先减再判 ⇒ 初值 N 跑 N−1 圈。
--     · `killAllAsync` = THlib 的 `task.Clear(o, true)`（停掉本敌机除当前外的线程）。
--     · 随机数**消耗顺序是行为的一部分**：`%RAND`（有符号 32 位 = 两个 16 位拼）
--       与 `%RANDF`（[0,1)）/`%RANDRAD`（[−π,π)）按原作顺序调用。
--=====================================
t10mid.s07 = {}

---掉落近似（原作 dropMain：R→1、B→2、G→3、Y→0；Dropitem_PFP 用 {信仰,P,点}）。
t10mid.s07.DROP = {
    R = { 0, 1, 1 },
    B = { 0, 2, 2 },
    G = { 0, 3, 3 },
    Y = { 0, 0, 1 },
}

---血量（原作 enmCreate 第 4 参）与入场无敌帧（setInvuln）。
t10mid.s07.HP = {
    Cir00 = 20, Cir00b = 20, Cir00c = 20,
    Girl00 = 200, Girl01 = 2000, Girl02 = 1400, Girl03 = 2000,
    Girl04 = 600, Girl05 = 20, Girl06 = 20, Girl06b = 200,
}
t10mid.s07.INV = {
    Cir00 = 8, Cir00b = 30, Cir00c = 30,
    Girl00 = 8, Girl01 = 80, Girl02 = 120, Girl03 = 60, Girl04 = 60,
    Girl05 = 8, Girl06 = 8, Girl06b = 8,
}

---跳过中 BOSS 后接 MainSub8 的等待（原作：MainSub7 等 MBoss 死；本卡用固定帧近似）。
t10mid.s07.MBOSS_WAIT = 3800

---========================= Cir 系（入场圆周妖精） =========================
---Cir00_at：每 15 帧一发（单发、自机狙、角步长 π/48、速 5.0→1.0）。
t10mid.s07.cir00_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 1, 6)
    et_count(f, 0, 1, 1)
    et_angle(f, 0, 0.0, 0.06544985)
    et_speed(f, 0, 5.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    while true do
        task.Wait(15)
        fire_slot(f, 0)
    end
end

---Cir00：t=30 朝下速 4.0；t=60 起 60 帧内把角转到 0（速度保持 4.0）。
t10mid.s07.cir00 = function(f)
    task.New(f, function() t10mid.s07.cir00_at(f) end)
    task.Wait(30)
    t10mid.vel(f, 1.5707964, 4.0)
    task.Wait(30)
    t10mid.vel_time(f, 60, 0, 0.0, 4.0)
    task.Wait(60)
end

---Cir00b_at：先等 10 帧（整个 pattern 都在这一刻配好）；之后每 15 帧一发：
---   基准角 = 随机角、速 = 1.0 + %RANDF×0.6。
t10mid.s07.cir00b_at = function(f)
    task.Wait(10)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 3, 10)
    et_count(f, 0, 1, 1)
    et_angle(f, 0, 0.0, 0.06544985)
    et_speed(f, 0, 2.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    while true do
        task.Wait(15)
        et_angle(f, 0, rndrad(), 0.0)
        et_speed(f, 0, 1.0 + rnd() * 0.6, 0.0)
        fire_slot(f, 0)
    end
end

---Cir00b：朝左速 2.0；+120 起 60 帧内把角转到 0。
t10mid.s07.cir00b = function(f)
    task.New(f, function() t10mid.s07.cir00b_at(f) end)
    t10mid.vel(f, -1.5707964, 2.0)
    task.Wait(120)
    t10mid.vel_time(f, 60, 0, 0.0, 2.0)
    task.Wait(60)
end

---Cir00c_at：与 Cir00b_at 同一条，唯每发间隔 20 帧。
t10mid.s07.cir00c_at = function(f)
    task.Wait(10)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 3, 10)
    et_count(f, 0, 1, 1)
    et_angle(f, 0, 0.0, 0.06544985)
    et_speed(f, 0, 2.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    while true do
        task.Wait(20)
        et_angle(f, 0, rndrad(), 0.0)
        et_speed(f, 0, 1.0 + rnd() * 0.6, 0.0)
        fire_slot(f, 0)
    end
end

---Cir00c：朝左速 2.0；+120 起 60 帧内把角转到 −π/4。
t10mid.s07.cir00c = function(f)
    task.New(f, function() t10mid.s07.cir00c_at(f) end)
    t10mid.vel(f, -1.5707964, 2.0)
    task.Wait(120)
    t10mid.vel_time(f, 60, 0, -0.7853982, 2.0)
    task.Wait(60)
end

---========================= Girl 系（俯冲妖精） =========================
---Girl00_at：一共 3 拍（$I0=4 → 3 圈），每拍等 30 帧后打一发 5 连扇形
---   （自机狙、角步长 π/8、速 5.0→4.0）。
t10mid.s07.go00_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 1, 10)
    et_count(f, 0, 5, 1)
    et_angle(f, 0, 0.0, 0.3926991)
    et_speed(f, 0, 5.0, 4.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 4 - 1
    while n ~= 0 do
        task.Wait(30)
        fire_slot(f, 0)
        n = n - 1
    end
end

---Girl00：朝下速 6.0、30 帧内减速停下；+160 朝自机、60 帧加速到 2.0。
t10mid.s07.go00 = function(f)
    task.New(f, function() t10mid.s07.go00_at(f) end)
    t10mid.vel(f, 1.5707964, 6.0)
    t10mid.vel_time(f, 30, 0, -999999, 0.0)
    task.Wait(160)
    t10mid.vel(f, t10_angle_player(f), 0.0)
    t10mid.vel_time(f, 60, 0, -999999, 2.0)
end

---Girl01_at：39 拍（$I0=40 → 39 圈），每拍等 10 帧后打一发 8 连扇
---   （自机狙、角步长每次重算 = π/8 + %RANDRAD/32、速 3.0→4.0）。
t10mid.s07.go01_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 3, 2)
    et_count(f, 0, 8, 1)
    et_angle(f, 0, 0.0, 0.3926991)
    et_speed(f, 0, 3.0, 4.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 40 - 1
    while n ~= 0 do
        task.Wait(10)
        et_angle(f, 0, 0.0, TH10_PI / 8 + rndrad() / 32)
        fire_slot(f, 0)
        n = n - 1
    end
end

---Girl01_at2：槽 1；9 拍（$I0=10 → 9 圈），每拍等 40 帧后打单发（速 6.0→4.0）。
t10mid.s07.go01_at2 = function(f)
    et_new(f, 1); et_aim(f, 1, 0); et_sprite(f, 1, 17, 1)
    et_count(f, 1, 1, 1)
    et_angle(f, 1, 0.0, 0.3926991)
    et_speed(f, 1, 6.0, 4.0)
    et_ex(f, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 10 - 1
    while n ~= 0 do
        task.Wait(40)
        fire_slot(f, 1)
        n = n - 1
    end
end

---Girl01：朝下速 6.0、40 帧内停下；+40 起两条 _at 线程；+400 朝上、60 帧加速到 2.0。
t10mid.s07.go01 = function(f)
    t10mid.vel(f, 1.5707964, 6.0)
    t10mid.vel_time(f, 40, 0, -999999, 0.0)
    task.Wait(40)
    task.New(f, function() t10mid.s07.go01_at(f) end)
    task.New(f, function() t10mid.s07.go01_at2(f) end)
    task.Wait(400)
    t10mid.vel(f, -1.5707964, 0.0)
    t10mid.vel_time(f, 60, 0, -999999, 2.0)
end

---Girl02 的四条 _at：都是「重算基准角/角步长 → 打一发 → 等 N 帧」的循环
---   （速度每发 = 基值 + %RANDF）。$I0=40 ⇒ 各 39 圈。
---   at：速 3.0+%RANDF、步长 %RANDRAD/14、等 5 帧；at2：速 3.5、步长 /22、等 15 帧；
---   at3：速 4.0、步长 /40、等 30 帧；at4：速 5.0、**基准角固定 0**、步长 π/8+%RANDRAD/32、等 60 帧。
t10mid.s07.go02_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 1, 2)
    et_count(f, 0, 1, 1)
    et_angle(f, 0, 0.0, 0.3926991)
    et_speed(f, 0, 3.0, 4.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 40 - 1
    while n ~= 0 do
        local sp = rnd() * 1.0 + 3.0                -- %RANDF
        local ab = TH10_PI / 8 + rndrad() / 32      -- %RANDRAD（先）
        local st = rndrad() / 14                    -- %RANDRAD（后）
        et_speed(f, 0, sp, 0.0)
        et_angle(f, 0, ab, st)
        fire_slot(f, 0)
        task.Wait(5)
        n = n - 1
    end
end

t10mid.s07.go02_at2 = function(f)
    et_new(f, 1); et_aim(f, 1, 0); et_sprite(f, 1, 0, 2)
    et_count(f, 1, 1, 1)
    et_angle(f, 1, 0.0, 0.3926991)
    et_speed(f, 1, 3.0, 4.0)
    et_ex(f, 1, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 40 - 1
    while n ~= 0 do
        local sp = rnd() * 1.0 + 3.5                -- %RANDF
        local ab = TH10_PI / 8 + rndrad() / 32      -- %RANDRAD（先）
        local st = rndrad() / 22                    -- %RANDRAD（后）
        et_speed(f, 1, sp, 0.0)
        et_angle(f, 1, ab, st)
        fire_slot(f, 1)
        task.Wait(15)
        n = n - 1
    end
end

t10mid.s07.go02_at3 = function(f)
    et_new(f, 2); et_aim(f, 2, 0); et_sprite(f, 2, 12, 1)
    et_count(f, 2, 1, 1)
    et_angle(f, 2, 0.0, 0.3926991)
    et_speed(f, 2, 3.0, 4.0)
    et_ex(f, 2, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 40 - 1
    while n ~= 0 do
        local sp = rnd() * 1.0 + 4.0                -- %RANDF
        local ab = TH10_PI / 8 + rndrad() / 32      -- %RANDRAD（先）
        local st = rndrad() / 40                    -- %RANDRAD（后）
        et_speed(f, 2, sp, 0.0)
        et_angle(f, 2, ab, st)
        fire_slot(f, 2)
        task.Wait(30)
        n = n - 1
    end
end

t10mid.s07.go02_at4 = function(f)
    et_new(f, 3); et_aim(f, 3, 0); et_sprite(f, 3, 17, 0)
    et_count(f, 3, 1, 1)
    et_angle(f, 3, 0.0, 0.3926991)
    et_speed(f, 3, 3.0, 4.0)
    et_ex(f, 3, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 40 - 1
    while n ~= 0 do
        et_speed(f, 3, rnd() * 1.0 + 5.0, 0.0)
        et_angle(f, 3, 0.0, TH10_PI / 8 + rndrad() / 32)
        fire_slot(f, 3)
        task.Wait(60)
        n = n - 1
    end
end

---Girl02：朝下速 3.0、120 帧内停下；+120 起四条 _at；+600 停火、转向下、60 帧加速到 2.0。
t10mid.s07.go02 = function(f)
    t10mid.vel(f, 1.5707964, 3.0)
    t10mid.vel_time(f, 120, 0, -999999, 0.0)
    task.Wait(120)
    task.New(f, function() t10mid.s07.go02_at(f) end)
    task.New(f, function() t10mid.s07.go02_at2(f) end)
    task.New(f, function() t10mid.s07.go02_at3(f) end)
    task.New(f, function() t10mid.s07.go02_at4(f) end)
    task.Wait(600)
    t10mid.vel(f, 1.5707964, 0.0)
    t10_kill_async(f)                               -- killAllAsync()
    t10mid.vel_time(f, 60, 0, -999999, 2.0)
end

---Girl03_at（传入 −π/2）：无限循环，每帧打 3 发（角依次 +2π/3，色 2/4/6；
---   速 = sin($8)×1.6 + 2.2；$0 每帧 +2π/3+0.1632、$8（初值 π）每帧 +0.206006）。
t10mid.s07.go03_at = function(f, a0)
    et_new(f, 0); et_aim(f, 0, 3); et_sprite(f, 0, 3, 2)
    et_count(f, 0, 1, 1)
    et_angle(f, 0, 0.0, 0.3926991)
    et_speed(f, 0, 3.0, 4.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local a = a0 or 0.0                    -- $0：初值 = 传入的 −π/2
    local ph = TH10_PI                     -- $8：初值 π
    while true do
        et_speed(f, 0, math.sin(ph) * 1.6 + 2.2, 1.0)
        et_sprite(f, 0, 3, 2); et_angle(f, 0, a, 0.0); fire_slot(f, 0)
        a = t10_wrap(a + 2.094395)
        et_sprite(f, 0, 3, 4); et_angle(f, 0, a, 0.0); fire_slot(f, 0)
        a = t10_wrap(a + 2.094395)
        et_sprite(f, 0, 3, 6); et_angle(f, 0, a, 0.0); fire_slot(f, 0)
        a = t10_wrap(a + 2.094395 + 0.1632)
        ph = t10_wrap(ph + 0.206006)
        task.Wait(1)
    end
end

---Girl03：朝下速 5.0、60 帧内停下；+60 起 Girl03_at；+200 停火、转向下、60 帧加速到 2.0。
t10mid.s07.go03 = function(f)
    t10mid.vel(f, 1.5707964, 5.0)
    t10mid.vel_time(f, 60, 0, -999999, 0.0)
    task.Wait(60)
    task.New(f, function() t10mid.s07.go03_at(f, -1.5707964) end)
    task.Wait(200)
    t10mid.vel(f, 1.5707964, 0.0)
    t10_kill_async(f)                               -- killAllAsync()
    t10mid.vel_time(f, 60, 0, -999999, 2.0)
end

---Girl04_at：无限循环，每拍把基准角设为自机向、4→3 次「打一发、等 4 帧」，圈间等 20 帧。
t10mid.s07.go04_at = function(f)
    et_new(f, 0); et_aim(f, 0, 3); et_sprite(f, 0, 6, 2)
    et_count(f, 0, 1, 1)
    et_angle(f, 0, 0.0, 0.3926991)
    et_speed(f, 0, 3.0, 4.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    while true do
        et_angle(f, 0, t10_angle_player(f), 0.0)
        local n = 4 - 1                             -- pushi(4) + deci/jmpNeq ⇒ 3 圈
        while n ~= 0 do
            fire_slot(f, 0)
            task.Wait(4)
            n = n - 1
        end
        task.Wait(20)
    end
end

---Girl04：与 Girl03 同形（速 5.0/60 帧停；+60 起 _at；+300 停火转向下加速 2.0）。
t10mid.s07.go04 = function(f)
    t10mid.vel(f, 1.5707964, 5.0)
    t10mid.vel_time(f, 60, 0, -999999, 0.0)
    task.Wait(60)
    task.New(f, function() t10mid.s07.go04_at(f) end)
    task.Wait(300)
    t10mid.vel(f, 1.5707964, 0.0)
    t10_kill_async(f)                               -- killAllAsync()
    t10mid.vel_time(f, 60, 0, -999999, 2.0)
end

---Girl05_at：3 拍（$I0=4），每拍「等 %RAND%10 帧 → 打一发 5 连扇形 → 等 30 帧」
---   （自机狙、角步长 π/64、速 5.0→4.0）。
t10mid.s07.go05_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 1, 10)
    et_count(f, 0, 5, 1)
    et_angle(f, 0, 0.0, 0.049087387)
    et_speed(f, 0, 5.0, 4.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local n = 4 - 1
    while n ~= 0 do
        local w = t10_imod(t10_randmod(), 10)       -- pushi($RAND)%10
        if w > 0 then task.Wait(w) end
        fire_slot(f, 0)
        task.Wait(30)
        n = n - 1
    end
end

---Girl05：朝右（镜像则朝左）速 4.0；+70 起 60 帧内把角转到 3.043418。
t10mid.s07.go05 = function(f)
    task.New(f, function() t10mid.s07.go05_at(f) end)
    t10mid.vel(f, 0.0, 4.0)
    task.Wait(70)
    t10mid.vel_time(f, 60, 0, 3.043418, 4.0)
end

---Girl06_at：先等 %RAND%10 帧，然后 3 拍「打一发 5 连扇形（自机狙、步长 0.03926991）、等 30 帧」。
t10mid.s07.go06_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 0, 2)
    et_count(f, 0, 5, 1)
    et_angle(f, 0, 0.0, 0.03926991)
    et_speed(f, 0, 1.5, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local w = t10_imod(t10_randmod(), 10)
    if w > 0 then task.Wait(w) end
    local n = 4 - 1
    while n ~= 0 do
        fire_slot(f, 0)
        task.Wait(30)
        n = n - 1
    end
end

---Girl06：朝右速 3.0（镜像则朝左）。@go06_at 一样。
t10mid.s07.go06 = function(f)
    task.New(f, function() t10mid.s07.go06_at(f) end)
    t10mid.vel(f, 0.0, 3.0)
end

---Girl06b_at：与 Girl06_at 同，唯速 1.0→1.0。
t10mid.s07.go06b_at = function(f)
    et_new(f, 0); et_aim(f, 0, 0); et_sprite(f, 0, 0, 2)
    et_count(f, 0, 5, 1)
    et_angle(f, 0, 0.0, 0.03926991)
    et_speed(f, 0, 1.0, 1.0)
    et_ex(f, 0, 0, 1, 4, -999999, -999999, -999999.0, -999999.0)
    local w = t10_imod(t10_randmod(), 10)
    if w > 0 then task.Wait(w) end
    local n = 4 - 1
    while n ~= 0 do
        fire_slot(f, 0)
        task.Wait(30)
        n = n - 1
    end
end

---Girl06b：朝右速 1.0（镜像则朝左）。
t10mid.s07.go06b = function(f)
    task.New(f, function() t10mid.s07.go06b_at(f) end)
    t10mid.vel(f, 0.0, 1.0)
end

---========================= 时间轴 =========================
---道中锚点在 (0,0)（原作 main 那条 ECL 敌机不移动），所以 enmCreate 的 x/y 即绝对坐标。
t10mid.s07.BEH = {
    Cir00 = t10mid.s07.cir00, Cir00b = t10mid.s07.cir00b, Cir00c = t10mid.s07.cir00c,
    Girl00 = t10mid.s07.go00, Girl01 = t10mid.s07.go01, Girl02 = t10mid.s07.go02,
    Girl03 = t10mid.s07.go03, Girl04 = t10mid.s07.go04, Girl05 = t10mid.s07.go05,
    Girl06 = t10mid.s07.go06, Girl06b = t10mid.s07.go06b,
}

---名字 = 色前缀（B/R/G/Y，决定掉落表）+ 基础名（决定行为/血量）；
---   无前缀的（Girl01..06b）按 R。
t10mid.s07.one = function(name, x, y, mirror, src)
    local S = t10mid.s07
    local base, col = name, "R"
    if not S.BEH[name] then col = name:sub(1, 1); base = name:sub(2) end
    t10mid.spawn(S.HP[base], x, y, mirror, S.DROP[col], S.BEH[base], src, S.INV[base] or 0)
end

---第 1 只立即出、以后每 gap 帧一只，共 n 只（对应原作里「+10:」连排的 enmCreate）。
t10mid.s07.rep = function(n, name, x, y, mirror, gap)
    local S = t10mid.s07
    for i = 1, n do
        S.one(name, x, y, mirror)
        if i < n then task.Wait(gap) end
    end
end
t10mid.s07.ms1 = function(card)
    local S = t10mid.s07
    task.Wait(300)
    S.one("BCir00", -128.0, -24.0, false)
    task.Wait(10)
    S.rep(5, "BCir00", -128.0, -24.0, false, 10)
    task.Wait(10)
    S.rep(3, "GCir00", -128.0, -24.0, false, 10)
    task.Wait(10)
    S.rep(6, "BCir00", 128.0, -24.0, true, 10)
    task.Wait(10)
    S.rep(3, "GCir00", 128.0, -24.0, true, 10)
    task.Wait(60)
    S.one("BCir00", -128.0, -24.0, false)
    task.Wait(10)
    S.rep(5, "BCir00", -128.0, -24.0, false, 10)
    task.Wait(10)
    S.rep(3, "GCir00", -128.0, -24.0, false, 10)
    task.Wait(10)
    S.rep(6, "BCir00", 128.0, -24.0, true, 10)
    task.Wait(10)
    S.rep(3, "GCir00", 128.0, -24.0, true, 10)
    task.New(card, function() S.ms2(card) end)
end

t10mid.s07.ms2 = function(card)
    local S = t10mid.s07
    task.Wait(130)
    S.one("GCir00b", -128.0, 472.0, false)
    task.Wait(10)
    S.rep(8, "GCir00b", -128.0, 472.0, false, 10)
    task.Wait(10)
    S.rep(9, "GCir00b", 128.0, 472.0, true, 10)
    task.Wait(150)
    S.one("BCir00", 128.0, -24.0, true)
    task.Wait(10)
    S.rep(4, "BCir00", 128.0, -24.0, true, 10)
    task.Wait(60)
    S.one("BCir00", -128.0, -24.0, false)
    task.Wait(10)
    S.rep(4, "BCir00", -128.0, -24.0, false, 10)
    task.New(card, function() S.ms3(card) end)
end

t10mid.s07.ms3 = function(card)
    local S = t10mid.s07
    task.Wait(160)
    S.one("RGirl00", -160.0, -24.0, false)
    task.Wait(30)
    S.one("RGirl00", -80.0, -24.0, false)
    task.Wait(30)
    S.one("RGirl00", 0.0, -24.0, false)
    task.Wait(30)
    S.one("RGirl00", 80.0, -24.0, false)
    task.Wait(30)
    S.one("RGirl00", 160.0, -24.0, false)
    task.Wait(30)
    S.one("RGirl00", -160.0, -24.0, false)
    task.Wait(30)
    S.one("RGirl00", -80.0, -24.0, false)
    task.Wait(30)
    S.one("RGirl00", 0.0, -24.0, false)
    task.Wait(30)
    S.one("RGirl00", 80.0, -24.0, false)
    task.Wait(30)
    S.one("RGirl00", 160.0, -24.0, false)
    task.Wait(30)
    S.one("BGirl00", -160.0, -24.0, false)
    task.Wait(30)
    S.one("BGirl00", -80.0, -24.0, false)
    task.Wait(30)
    S.one("BGirl00", 0.0, -24.0, false)
    task.Wait(30)
    S.one("BGirl00", 80.0, -24.0, false)
    task.Wait(30)
    S.one("BGirl00", 160.0, -24.0, false)
    task.Wait(30)
    S.one("BGirl00", -160.0, -24.0, false)
    task.Wait(30)
    S.one("BGirl00", -80.0, -24.0, false)
    task.Wait(30)
    S.one("BGirl00", 0.0, -24.0, false)
    task.Wait(30)
    S.one("BGirl00", 80.0, -24.0, false)
    task.Wait(30)
    S.one("BGirl00", 160.0, -24.0, false)
    task.New(card, function() S.ms4(card) end)
end

t10mid.s07.ms4 = function(card)
    local S = t10mid.s07
    task.Wait(200)
    S.one("Girl01", 0.0, -24.0, false)
    task.Wait(200)
    S.one("BCir00", -128.0, -24.0, false)
    task.Wait(10)
    S.rep(5, "BCir00", -128.0, -24.0, false, 10)
    task.Wait(10)
    S.rep(3, "GCir00", -128.0, -24.0, false, 10)
    task.Wait(100)
    S.one("Girl01", 0.0, -24.0, false)
    task.Wait(200)
    S.one("BCir00", 128.0, -24.0, true)
    task.Wait(10)
    S.rep(5, "BCir00", 128.0, -24.0, true, 10)
    task.Wait(10)
    S.rep(3, "GCir00", 128.0, -24.0, true, 10)
    task.New(card, function() S.ms5(card) end)
end

t10mid.s07.ms5 = function(card)
    local S = t10mid.s07
    task.Wait(110)
    S.one("BCir00c", -144.0, 472.0, false)
    task.Wait(10)
    S.rep(8, "BCir00c", -144.0, 472.0, false, 10)
    task.Wait(10)
    S.rep(9, "BCir00c", 144.0, 472.0, true, 10)
    task.Wait(10)
    S.rep(9, "BCir00b", -144.0, 472.0, false, 10)
    task.Wait(10)
    S.rep(9, "BCir00b", 144.0, 472.0, true, 10)
    task.Wait(10)
    S.rep(9, "RCir00b", -144.0, 472.0, false, 10)
    task.Wait(10)
    S.rep(9, "RCir00b", 144.0, 472.0, true, 10)
    task.New(card, function() S.ms6(card) end)
end

t10mid.s07.ms6 = function(card)
    local S = t10mid.s07
    task.Wait(200)
    S.one("Girl02", 64.0, -24.0, false)
    task.Wait(180)
    S.one("Girl02", -64.0, -24.0, false)
    task.Wait(180)
    S.one("Girl02", 96.0, -24.0, false)
    task.Wait(180)
    S.one("Girl02", -96.0, -24.0, false)
    task.Wait(180)
    S.one("Girl02", 128.0, -24.0, false)
    task.Wait(180)
    S.one("Girl02", -128.0, -24.0, false)
    task.Wait(420)
    task.New(card, function() S.ms7(card) end)
end

t10mid.s07.ms8 = function(card)
    local S = t10mid.s07
    task.Wait(200)
    S.one("GCir00", -128.0, -24.0, false)
    task.Wait(10)
    S.rep(8, "GCir00", -128.0, -24.0, false, 10)
    task.Wait(10)
    S.rep(9, "GCir00", 128.0, -24.0, true, 10)
    task.Wait(100)
    S.one("Girl03", 0.0, -24.0, false)
    task.Wait(60)
    S.one("Girl04", -128.0, -24.0, false)
    S.one("Girl04", 128.0, -24.0, false)
    task.Wait(220)
    task.New(card, function() S.ms9(card) end)
end

t10mid.s07.ms9 = function(card)
    local S = t10mid.s07
    task.Wait(120)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(60)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(40)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(40)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(30)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(30)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(30)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("RGirl05", -224.0, 32.0, false)
    task.Wait(10)
    S.one("BGirl05", -224.0, 32.0, false)
    task.Wait(30)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("RGirl05", 224.0, 32.0, true)
    task.Wait(10)
    S.one("BGirl05", 224.0, 32.0, true)
    task.Wait(100)
    S.one("Girl03", 0.0, -24.0, false)
    task.Wait(60)
    S.one("Girl04", -128.0, -24.0, false)
    S.one("Girl04", 128.0, -24.0, false)
    task.New(card, function() S.ms10(card) end)
end

t10mid.s07.ms10 = function(card)
    local S = t10mid.s07
    task.Wait(300)
    S.one("BGirl06", -224.0, 224.0, false)
    task.Wait(10)
    S.rep(5, "BGirl06", -224.0, 224.0, false, 10)
    S.one("BGirl06", 224.0, 224.0, true)
    task.Wait(10)
    S.rep(5, "BGirl06", 224.0, 224.0, true, 10)
    S.one("BGirl06", -224.0, 192.0, false)
    task.Wait(10)
    S.rep(5, "BGirl06", -224.0, 192.0, false, 10)
    S.one("BGirl06", 224.0, 192.0, true)
    task.Wait(10)
    S.rep(5, "BGirl06", 224.0, 192.0, true, 10)
    S.one("BGirl06", -224.0, 32.0, false)
    task.Wait(10)
    S.rep(5, "BGirl06", -224.0, 32.0, false, 10)
    S.one("BGirl06", 224.0, 32.0, true)
    task.Wait(10)
    S.rep(5, "BGirl06", 224.0, 32.0, true, 10)
    S.one("BGirl06", -224.0, 224.0, false)
    task.Wait(10)
    S.rep(5, "BGirl06", -224.0, 224.0, false, 10)
    S.one("BGirl06", 224.0, 224.0, true)
    task.Wait(10)
    S.rep(5, "BGirl06", 224.0, 224.0, true, 10)
    S.one("BGirl06", -224.0, 128.0, false)
    task.Wait(10)
    S.rep(5, "BGirl06", -224.0, 128.0, false, 10)
    S.one("BGirl06", 224.0, 128.0, true)
    task.Wait(10)
    S.rep(5, "BGirl06", 224.0, 128.0, true, 10)
    S.one("BGirl06", -224.0, 32.0, false)
    task.Wait(10)
    S.rep(5, "BGirl06", -224.0, 32.0, false, 10)
    S.one("BGirl06", 224.0, 32.0, true)
    task.Wait(10)
    S.rep(5, "BGirl06", 224.0, 32.0, true, 10)
    S.one("BGirl06", -224.0, 224.0, false)
    task.Wait(10)
    S.rep(5, "BGirl06", -224.0, 224.0, false, 10)
    S.one("BGirl06", 224.0, 224.0, true)
    task.Wait(10)
    S.rep(5, "BGirl06", 224.0, 224.0, true, 10)
    task.Wait(120)
    task.New(card, function() S.ms10b(card, 128.0) end)
    task.New(card, function() S.ms10a(card, 192.0) end)
    task.New(card, function() S.ms10b(card, 256.0) end)
    S.one("BGirl06b", -224.0, 64.0, false)
    task.Wait(30)
    S.rep(5, "BGirl06b", -224.0, 64.0, false, 30)
    S.one("BGirl06b", 224.0, 64.0, true)
    task.Wait(30)
    S.rep(2, "BGirl06b", 224.0, 64.0, true, 30)
    task.Wait(30)
    S.rep(3, "YGirl06b", 224.0, 64.0, true, 30)
    task.Wait(360)
    ---callAsync("MainSubBoss")：BOSS 本体不移植（本仓库另一张卡）。
end

t10mid.s07.ms10a = function(card, y)
    local S = t10mid.s07
    S.one("BGirl06b", -224.0, y, false)
    task.Wait(30)
    S.rep(5, "BGirl06b", -224.0, y, false, 30)
    S.one("BGirl06b", 224.0, y, true)
    task.Wait(30)
    S.rep(5, "BGirl06b", 224.0, y, true, 30)
end

t10mid.s07.ms10b = function(card, y)
    local S = t10mid.s07
    S.one("BGirl06b", 224.0, y, true)
    task.Wait(30)
    S.rep(5, "BGirl06b", 224.0, y, true, 30)
    S.one("BGirl06b", -224.0, y, false)
    task.Wait(30)
    S.rep(5, "BGirl06b", -224.0, y, false, 30)
end

---MainSub7：原作 enmCreateA("MBoss") + dialogRead(0)/dialogWait/deathWait 后叫 MainSub8。
---中 BOSS 在本仓库是另一张卡（组 1a），所以这里只用 MBOSS_WAIT 帧近似「等它打完」。
t10mid.s07.ms7 = function(card)
    local S = t10mid.s07
    task.Wait(S.MBOSS_WAIT)
    task.New(card, function() S.ms8(card) end)
end

---道中总时间轴（main：t=0 叫 MainSub1、t=10000 再叫一次、t=20000 delete）。
t10mid.s07.run = function(card)
    local S = t10mid.s07
    task.New(card, function() S.ms1(card) end)        -- callAsync("MainSub1")
    task.Wait(10000)
    task.New(card, function() S.ms1(card) end)        -- 第二次 callAsync("MainSub1")
    task.Wait(10000)                                  -- 原作此处 delete()
end

---挂到空 boss「ga」上的一张耐久符卡（与 stage01..06 道中同一套注册方式）。
---时长：原作 main 到 20000 帧 delete ⇒ 340 秒留余量。
boss.Define("ga", "道中", "TH10_1", TH10_bg, { 0, 400 }, nil, "img_void", LEVEL)
t10mid.s07card = boss.card.New("EX道中「ネイティブフェイス」", 340, 340, 340, 10000000)
function t10mid.s07card:before()
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
end
function t10mid.s07card:init()
    t10mid.clear(); t10mid.ax, t10mid.ay = 0, 0
    task.New(self, function() t10mid.s07.run(self) end)
end
function t10mid.s07card:frame() end
function t10mid.s07card:render() end
function t10mid.s07card:del() t10mid.clear() end
boss.card.add({ { t10mid.s07card, "ga" } }, LEVEL, "EX道中「ネイティブフェイス」", 3685)
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
        t10_laser_st_on(o, 3, 13, ang, 0.0, 512.0, 60, 20, 60, 20, 16.0)
        ang = t10_wrap(ang + step)
    end
end

function s1.BossCard2At1b(o)
    local ang = rndrad()
    local cnt = 48                         -- diffI([0], 16,32,32,48)
    local step = 6.2831855 / cnt
    for _ = 1, cnt do
        et_offset(o, 0, 0.0, 0.0)
        t10_laser_on(o, 3, 2, ang, 20.0, 0.0, 180.0, 0.0, 14.0)
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
---八·B、stage02（鍵山雛 中 BOSS 一张 + BOSS 三张）
--=====================================


---MBossDummyShadow / BossDummyShadow：t=0 起每帧 anmPlay 的死循环。
---（原作 jmp(L,1) → L: anmPlay → jmpNeq 回跳；anmPlay 是纯视觉，这里只占帧。）
function s2.MBossDummyShadow(o) while true do task.Wait(1) end end
function s2.BossDummyShadow(o)  while true do task.Wait(1) end end

---BossTrace：op294 / moveBoss 复制 specialEnemySlots[0] 的世界坐标。
---复原源码把这个 opcode 命名为 COPY_PLAYER_TO_OFFSET，但其实际读的是 EnemyManager
---+0x10 的 Boss 槽（EnemyEclDispatcher.cpp 的 dispatch_copy_player_to_motion）。
---★ 第一帧不执行（ECL 是 jmp 到 jmpNeq 再回跳到 t=1 的组），所以 Wait 在前。
function s2.BossTrace(o)
    while true do
        task.Wait(1)
        local b = o.t10_bossref
        if b and IsValid(b) then m_pos(o, "off", b.ecs.wx, b.ecs.wy) end
    end
end

---卡 3633　厄符「厄神様のバイオリズム」（中 BOSS 鍵山雛）
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

---卡 3634　疵痕「壊されたお守り」（BOSS 鍵山雛 - 1）
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

---卡 3635　悲運「大鐘婆の火」（BOSS 鍵山雛 - 2）
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

---卡 3636　創符「流刑人形」（BOSS 鍵山雛 - 3）
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

---BossAtEnemy3：子机。offset 被 BossTrace 钉在 Boss 身上，base 走圆：
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
--八·B-2、stage02 非符（鍵山雛 BOSS 两张；只做 Lunatic 难度行）
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

---卡 3645　鍵山雛（BOSS 非符 1）
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

---卡 3646　鍵山雛（BOSS 非符 2）
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
--八·C、stage05（早苗 中 BOSS 一张 + 早苗 BOSS 四张；只做 Lunatic 难度行）
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
---卡 3638　奇跡「客星の明るすぎる夜」（BOSS 東風谷早苗 - 1）
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
        t10_laser_on(o, 3, 6, a4, 2.0, 0.0, 128.0, 0.0, 16.0, true)
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
        t10_laser_on(o, 3, 6, a4, 2.0, 0.0, 128.0, 0.0, 16.0, true)
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
---卡 3639　開海「モーゼの奇跡」（BOSS 東風谷早苗 - 2；L 行是 spellEx）
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
---  [24] 每轮 −0.1309。激光按原作 laserStOn 的 1/10/30/1 帧四段状态机运行。
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
            t10_laser_st_on(o, 8, 6, 0.0, w12, w12, 1, 10, 30, 1, 32.0)
        end
        et_offset(o, 0, 224.0, v4)
        w12 = o.F2 - s8 * 64.0
        if w12 > 0 then
            t10_laser_st_on(o, 8, 6, 3.1415927, w12, w12, 1, 10, 30, 1, 32.0)
        end
        v4 = v4 + 12.0
    end
    t10_delete(o)
end

---=====================================
---卡 3640　準備「サモンタケミナカタ」（BOSS 東風谷早苗 - 3）
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
---卡 3641　大奇跡「八坂の神風」（BOSS 東風谷早苗 - 4；卡内 lifeSet(3000)）
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
--八·C-2、stage05 非符（早苗 中 BOSS 一张 + 早苗 BOSS 三张；只做 Lunatic 难度行）
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

---非符 3648　早苗（BOSS 非符 1）
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

---非符 3649　早苗（BOSS 非符 2）
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

---非符 3650　早苗（BOSS 非符 3）
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
boss.Define("8a", "鍵山雛", "TH10_2", TH10_bg, { 0, 80 }, nil, "Hina", LEVEL)
boss.Define("9a", "東風谷早苗", "TH10_2", TH10_bg, { 0, 80 }, nil, "Sanae", LEVEL)

---stage01/02/05 十二张：{ 主 ECL 子程序, 卡名, 组, CARD_ID, t1秒, t2秒, t3秒, HP }
---  t3 = spell*(…, 时间, …) 的帧数 / 60（与 setInterrupt 的第三个参数一致）；
---  HP = 该卡开始时 BOSS 的 lifeSet：
---    stage01 中 BOSS 静葉 5850、穣子 8200；
---    stage02 中 BOSS 雛 2300、雛（BOSS）三张 13400（lifeSet(13400)）。
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

    -- stage05（早苗 中BOSS 非符+符卡 / 早苗 BOSS 三张非符 + 四张符卡）。
    --   非符的 HP = 一相「进场 life − 收尾阈值」：
    --     早苗 MBoss 12900 − 2900 = 10000；早苗 Boss1 12400 − 2400 = 10000（沿用 Boss() 的 life）、
    --     Boss2 / Boss3 = 10400 − 2400 = 8000。t3 = setInterrupt 时限/60、t1/t2 = setInvuln/60。
    --   符卡没有 SET_LIFE 时继承上一非符的收尾阈值，而不是上一相的初始 lifeSet：
    --     3637 从 2900 开始；3638 从 2400 开始；3639 / 3640 从 2400 开始。
    --     12400 是 Boss1 非符的初始 life，不是「客星」的血量。
    { s5.MBoss,      "",                              "9a", 3647, 200 / 60, 200 / 60, 2400 / 60, 10000, "stage05 中BOSS 非符" },
    { s5.MBossCard1, "秘術「一子相伝の弾幕」",       "9a", 3637, 200 / 60, 200 / 60, 2400 / 60, 2900 },
    { s5.Boss1,      "",                              "9a", 3648, 200 / 60, 200 / 60, 4200 / 60, 10000, "stage05 非符一" },
    { s5.BossCard1,  "奇跡「客星の明るすぎる夜」",   "9a", 3638, 90 / 60,  90 / 60,  4200 / 60, 2400 },
    { s5.Boss2,      "",                              "9a", 3649, 1,        1,        4200 / 60, 8000,  "stage05 非符二" },
    { s5.BossCard2,  "開海「モーゼの奇跡」",         "9a", 3639, 60 / 60,  60 / 60,  4200 / 60, 2400 },
    { s5.Boss3,      "",                              "9a", 3650, 100 / 60, 100 / 60, 4200 / 60, 8000,  "stage05 非符三" },
    { s5.BossCard3,  "準備「サモンタケミナカタ」",   "9a", 3640, 60 / 60,  60 / 60,  4200 / 60, 2400 },
    { s5.BossCard4,  "大奇跡「八坂の神風」",         "9a", 3641, 90 / 60,  90 / 60,  4200 / 60, 3000 },}

---★ 子机的 %BOSS_X / %BOSS_Y（原作 specialEnemySlots[0] 的世界坐标）走 t10_bossref：
---  主 BOSS 的载体在这里登记，s_pod 再把它复制给每一只子机。
for _, e in ipairs(T10_CARDS_S125) do
    local main, name, band, id, t1, t2, t3, hp = e[1], e[2], e[3], e[4], e[5], e[6], e[7], e[8]
    hp = TH35_REIMU_HP[id] or hp
    ---第 9 项 = 菜单名：非符的卡名必须是 ""（is_sc=false，不亮卡名），
    ---  但符卡练习菜单里还得有个名字 ⇒ 这两个字符串在非符上不是同一个。
    local menu = e[9] or name
    local c = boss.card.New(name, t1, t2, t3, hp)
    c.init = function(self)
        local p = t10_boss_start(self, main)
        p.t10_bossref = p
    end
    c.del = function(self) t10_clear_pods(self.th10carrier) end
    boss.card.add({ { c, band } }, LEVEL, menu, id)
end
