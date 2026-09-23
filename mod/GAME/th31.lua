---=====================================
---TH31  永夜 Last Word
---  TH08（东方永夜抄）官方 17 张 Last Word（卡 205..221）的移植。
---
---移植方法：**不用 ECL 字节码 VM**，跟 th32「红色的幻想乡」同一套 —— 逐张读 th08full
---  （reccmp 复原的 TH08 1.00d 反编译源码）+ data/ecldata*.ecl 的原始字节，把每条指令
---  的语义翻成原生 LuaSTG 对象（Class(bullet, ...)、task、卡片自己的弹池登记表）。
---  下面每处「文件:行号」都能在本机复查。旧版（5537 行的字节码 VM + L.RAW 数据表）整个废弃。
---
---贯穿全关的几条事实（每张卡都靠它们）：
---  · 坐标：TH08 是 384×448、左上原点、y 朝下（GameManager.hpp:44-45）；我们原点在场地
---    中心、y 朝上（Lscreen.lua 的 SetWorld(288,46,384,448) → l=−192,r=192,b=−224,t=224）。
---    两边尺寸相同，所以换算是纯平移 + y 翻转、**没有比例缩放**：
---        x_我们 = x_原作 − 192        y_我们 = 224 − y_原作        角度整体取反
---  · rank 固定取 32（移植版没有难度系统）。原作 Last Word 全程是符卡，出弹的 rank 缩放
---    整段被 `if (!g_Spellcard.IsActive())` 挡住（EclDependencies.cpp:735-761），
---    所以 rank 取多少都不进算式 —— 记一笔备查。
---  · 同屏弹幕上限：全游戏共用 1536 个弹槽（BulletManager.hpp:455 `Bullet bullets[0x601]`）。
---    activeBulletCount >= 0x600 时**整波不生**；波中间某一颗生不出来就放弃整波剩下的，
---    音效照响（BulletManager.cpp:686-712）。移植版没有全局弹池，卡片自己维护一张登记表。
---  · 出生动画：flags 带 SPAWN_FAST(2)/NORMAL(4)/SLOW(8) 的弹进入 SPAWNING_* 状态：
---    出生瞬间位置先减去 velocity*4，之后每帧只走 velocity/2、/2.5、/3，
---    动画播完那一帧再补一次完整的 FIRED 更新（BulletManager.cpp:820-1013）。
---    etama.anm 的 script 21/22/23 长度 = 10/15/30 帧（末尾 ins_0/Delete 的 time）。
---  · 敌方每帧顺序（EnemyManagerUpdate.cpp:159-192）：RunEcl（主 context → 子 context）
---    → ClampPosition → IntegrateVelocity → ClampPosition → worldPosition = position + offset。
---    也就是**子程序（枪）先跑、位移后跑**；而且 RunEcl 里用到的世界坐标是**上一帧末**的
---    位置（position 只在 UpdateMovement 里变）。移植版把这条顺序抄进对象自己的 frame。
---  · 占位贴图：娃娃 = "servant"，小弹 = ball_small（TH08 色号 2/4 → COLOR.RED/PURPLE）。
---    ★ 17 张全部实现完之后再统一换素材。
---
---实现进度（每张都在 CARD 表里登记；没登记的走文件末尾的占位实现）：
---  · 205「季节外调的蝴蝶风暴」（莉格露）  —— 平均 9.6 / 死局 9.1% / 峰值 1537 发有判定 1185
---  · 206「盲夜鸟」（米斯蒂娅）          —— 平均 15.6 / 死局 0.2% / 峰值 1436 发有判定 1043
---  · 207「日出之国的天子」（慧音）      —— 平均 4.0 / 死局 0.0% / 峰值 326 发有判定 98
---  · 218「格兰吉纽尔剧场的怪人」（爱丽丝）—— 平均 14.1 / 死局 1.4% / 峰值 1136 发有判定 677
---  · 208「幻胧月睨」（铃仙）            —— 平均 4.8 / 死局 1.7% / 峰值 784 发有判定 321
---  · 209「天网蛛网捕蝶之法」（永琳）    —— 平均 2.8 / 死局 0.0% / 峰值 1445 发有判定 81
---  · 210「蓬莱之树海」（辉夜）          —— 平均 17.6 / 死局 7.5% / 峰值 679 发有判定 477
---      ★ 7 棵树在移植版里打不掉（原作有 life 1000..4000），密度比原作高一档；
---        安全角度 10.4/24（同屏最密的卡 205 是 6.8/24）。
---（读数 = tools/check_stage.lua 5940 --threat；「平均」= 自机 60px 内弹数）。
---=====================================

local class = {}
_editor_class["TH31"] = class

---卡号（TH08 的 205..221）→ 原生实现 { before, init, frame, render, del }。
---没登记的卡 = 还没移植。
local CARD = {}

---------------------------------------------------------------
---卡 218「格兰吉纽尔剧场的怪人」（爱丽丝·玛格特洛依德）
---  ecldata_al.ecl：Sub1 = BOSS 根、Sub2 = 娃娃（使魔）、Sub3 = 娃娃的枪·环、
---  Sub4 = 娃娃的枪·自机狙扇形。
---  内容：16 个娃娃在半径 96 的圆上绕 BOSS 摊开、边公转边放弹。每 900 帧里，
---  娃娃的枪有 300 帧切成 Sub4（速度 8 的 3 路自机狙），其余 600 帧是 Sub3
---  （「直飞弹」和「2 秒后停住、再拐 144° 加速到 2.9 的弹」各一半）。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（见文件头）：x' = x−192、y' = 224−y、角度取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---Sub1（BOSS 根）的节拍，全部来自 ecldata_al.ecl Sub1 的裸字节。
local BOSS_END_Y = 96                       -- ins_64(110, 4, 192, 128)：TH08 y=128 → 我们 96
local BOSS_MOVE_FRAMES = 110                -- ... 的时长
local DOLL_SPAWN_FRAME = 110                -- 16 个 ins_92 全在这一帧
local WANDER_FIRST = 710                    -- 第一条 ins_67（710/770/830/890/950/1010…）
local WANDER_PERIOD = 60                    -- 之后每 60 帧一条
local WANDER_FRAMES = 60                    -- 每条 ins_67 的时长（参数 0）
local WANDER_SPEED = 1.0                    -- ... 的速度（参数 2）

---Sub2（娃娃）的节拍。
local ORBIT_RADIAL = 1.6                    -- op72 的 radialVelocity（Sub2 t=0）
local ORBIT_GROW_FRAMES = 60                -- op72 的 duration → 半径长到 96 就冻结
local ORBIT_ANGLE_SPEED = PI / 640          -- v10017 = 0.004908738658 rad/帧
local ORBIT_SPEEDUP = 1.03                  -- t=660+900k 的 `v10017 *= 1.03`
local GUN_SWITCH_FIRST = 660                -- t=660+900k → 枪切 Sub4；t=960+900k → 切回 Sub3
local GUN_CYCLE = 900

---两批娃娃的差别（Sub1 t=110 的两段循环体，裸字节实测）：
---  第一批 8 个：v10000 = 2（弹色 2）、v10018 = +0.104719758、v10017 = +0.004908738658
---  第二批 8 个：v10000 = 4、v10018 = −0.104719758、v10017 = −0.004908738658
---v10017 = 公转角速度、v10018 = 每发弹的偏角增量，两个都是 TH08 坐标系里的量，
---我们整体取反（见文件头），所以这里写的是**已经在「我们」坐标系里的值**。
---转弯角同理：op51 判 `v10018 >= 0` 跳去 −2.5132742 那条（Sub3 偏移 0x88），
---所以第一批（v10018 > 0）用 −2.5132742、第二批用 +2.5132742；取反后就是下表。
local DOLL_BATCHES = {
    { color = COLOR.RED,    angle_speed = -ORBIT_ANGLE_SPEED,
      shot_step = -0.10471975803375244,  turn_angle =  2.5132741928100586 },
    { color = COLOR.PURPLE, angle_speed =  ORBIT_ANGLE_SPEED,
      shot_step =  0.10471975803375244,  turn_angle = -2.5132741928100586 },
}
local DOLLS_PER_BATCH = 8                   -- v10036 = 8
local DOLL_ANGLE_STEP = PI / 4              -- v10016 每轮 += π/4

---Sub3/Sub4 的弹参数（op99 / op96 的 ShotArgs 裸字节）。
local GUN_SHOT_SPEED = 1.0                  -- op99 的 speed1
local FAN_STEP = 0.2617993950843811         -- op96 的 angleStep（15°）
local FAN_SPEED = 8.0                       -- op96 的 speed1
local FAN_OFFSETS = { 0, FAN_STEP, -FAN_STEP }  -- FAN_AIMED 的三路（BulletManager.cpp:118-127）
local SPAWN_FAST_FRAMES = 10                -- etama.anm script21（末尾 Delete 在 t=10）
local WAIT_FRAMES = 120                     -- op111 slot0 的 WAIT frames
local TURN_INTERVAL = 60                    -- op111 slot1 的 intervalFrames
local TURN_SPEED = 2.9                      -- ... 的 directionChange.speed
local POOL_SIZE = 1536                      -- BulletManager.hpp:455

---本卡自己的池子（= 原作那 1536 个弹槽）与娃娃登记表。
local dolls = {}
local pool = {}

---这颗弹还占着槽位吗。原作是「弹整体出屏那一帧回收」（BulletManager.cpp:885-900 的
---IsInBounds 带半个精灵宽高）；移植版用引擎的回收边界判，时机一致。
local function in_bound(unit)
    return IsValid(unit)
            and unit.x >= lstg.world.boundl and unit.x <= lstg.world.boundr
            and unit.y >= lstg.world.boundb and unit.y <= lstg.world.boundt
end

local function pool_used()
    for i = #pool, 1, -1 do
        if not in_bound(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---本卡的弹类（定义在下面，先在这里声明：spawn_bullet 里要用到它）。
local bullet_218

---一次出弹。池满 → 整波不生（SpawnBulletPattern 的 BulletManager.cpp:686-690）。
local function spawn_bullet(x, y, angle, speed, color, turn)
    if pool_used() >= POOL_SIZE then
        return false
    end
    local unit = New(bullet_218, x, y, angle, speed, color, turn)
    pool[#pool + 1] = unit
    return true
end

---Sub3/Sub4 的弹（bulletType 2 / 6，都是 14×16 的小弹，占位用 ball_small）。
---  op99 = SHOOT_CIRCLE（EclManager.hpp:308）：count1=count2=1、speed1=1.0、
---  angle=v10020、color=v10000、flags=514（SPAWN_FAST|PLAY_SPAWN_SOUND）。
---  同一条 op99 在 Sub3 的 t=64 用的是 flags=131650 —— 多带 WAIT(0x20000) 与
---  CHANGE_DIRECTION_RELATIVE(0x40)，于是那颗弹会等 120 帧、再按 60 帧线性减速到 0、
---  然后 `angle += ±144°`、速度跳到 2.9 继续直飞（BulletManager.cpp:1255-1291）。
---  判据是 `(transformFlags & record->kind) == 0 → 跳过这条 record`（:328-332），
---  所以 flags=514 的弹两条 record 都不跑，纯直线。
---  两种弹都是 SPAWN_FAST：出生位置先减 velocity*4，之后 10 帧每帧 +velocity/2，
---  动画播完那一帧再照常走一遍 FIRED 的更新（BulletManager.cpp:250、953-957、:831）。
bullet_218 = Class(bullet, {
    init = function(self, x, y, angle, speed, color, turn)
        bullet.init(self, ball_small, color, false, true)
        self.alice_angle = angle
        self.alice_speed = speed
        self.alice_turn = turn
        self.alice_turn_timer = 0
        self.alice_turn_armed = false
        self.alice_wait = turn and WAIT_FRAMES or 0
        self.alice_spawn_left = SPAWN_FAST_FRAMES
        self.vx, self.vy = 0, 0             -- 位移全部自己在 frame 里算
        self.x = x - math.cos(angle) * speed * 4
        self.y = y - math.sin(angle) * speed * 4
    end,
    frame = function(self)
        local speed = self.alice_speed
        if self.alice_wait > 0 then
            -- WAIT 的 timer 每帧 -1，减到 <= 0 才把位清掉（BulletManager.cpp:848-854）
            self.alice_wait = self.alice_wait - 1
        elseif not self.alice_turn_armed then
            -- 清位那一帧不会激活下一条 record：AdvanceTransformProgram 在每帧**最前面**跑
            -- （:820），清位发生在同一帧的后面（:848），所以转向要等下一帧。
            self.alice_turn_armed = true
        elseif self.alice_turn then
            if self.alice_turn_timer >= TURN_INTERVAL then
                -- 拐弯：角度 += record.angle、速度 = record.speed，然后把位清掉
                self.alice_angle = self.alice_angle + self.alice_turn
                self.alice_speed = TURN_SPEED
                self.alice_turn = nil
                self.alice_turn_timer = 0
                speed = TURN_SPEED
            else
                -- 拐弯前先按 interval 线性减速到 0：magnitude = speed − timer*speed/interval
                speed = self.alice_speed
                        - self.alice_turn_timer * self.alice_speed / TURN_INTERVAL
                self.alice_turn_timer = self.alice_turn_timer + 1
            end
        end
        local vx = math.cos(self.alice_angle) * speed
        local vy = math.sin(self.alice_angle) * speed
        if self.alice_spawn_left > 0 then
            self.x = self.x + vx * 0.5
            self.y = self.y + vy * 0.5
            self.alice_spawn_left = self.alice_spawn_left - 1
            if self.alice_spawn_left == 0 then
                self.x = self.x + vx
                self.y = self.y + vy
            end
        else
            self.x = self.x + vx
            self.y = self.y + vy
        end
        bullet.frame(self)
    end,
})

---Sub3 t=60 / t=64 的那一发：角度 = 轨道角 + 逐发累积的偏角。
---op25 是 v10020 = v10077 + v10019，其中 v10077 = ECL_OPERAND_ORBIT_ANGLE
---（EclManager.hpp:478）—— 也就是娃娃当前的轨道角，用的是**上一帧末**的值。
---发完才 `v10019 += v10018`（op15）。
local function gun_shot(owner, turn)
    local angle = owner.alice_angle + owner.alice_gun_offset
    spawn_bullet(owner.x, owner.y, angle, GUN_SHOT_SPEED, owner.alice_color,
            turn and owner.alice_turn_angle or nil)
    owner.alice_gun_offset = owner.alice_gun_offset + owner.alice_shot_step
end

---Sub4 的 3 路自机狙（op96 = SHOOT_FAN_AIMED，EclManager.hpp:306）：
---count1=3、count2=1、speed1=8.0、angle=0、angleStep=0.261799395、bulletType=6、flags=514。
---FAN_AIMED 的角 = 自机方向 + 扇形偏移（BulletManager.cpp:118-127）。
local function gun_fan(owner)
    local aim = math.atan2(player.y - owner.y, player.x - owner.x)
    for i = 1, #FAN_OFFSETS do
        -- 生不出来 → 放弃整波剩下的（BulletManager.cpp:700-703）
        if not spawn_bullet(owner.x, owner.y, aim + FAN_OFFSETS[i], FAN_SPEED,
                owner.alice_color, nil) then
            return
        end
    end
end

---娃娃的枪（原作的子 ECL 槽 0，Sub2 用 op135 挂上/换掉）。
---  Sub3：t=60 发一发直飞弹、t=64 发一发「2 秒后拐弯」的弹，t=68 那条 `ins_4(60, −240)`
---  把 time 拨回 60 并**同帧**回到 t=60 的尾段（EclManager.cpp:239-243 的 JUMP 语义），
---  于是 t=60..68 这 8 帧一轮、每 4 帧一发，两种弹交替。
---  Sub4：t=120 发一轮 3 路自机狙，t=128 的 `ins_4(120, −44)` 每 8 帧跳回 t=120 那条。
local function gun_step(owner)
    local t = owner.alice_gun_time
    if owner.alice_gun_mode == 3 then
        if t == 60 or t == 68 then
            gun_shot(owner, false)
            if t == 68 then
                t = 60
            end
        elseif t == 64 then
            gun_shot(owner, true)
        end
    elseif t >= 120 and (t - 120) % 8 == 0 then
        gun_fan(owner)
    end
    owner.alice_gun_time = t + 1
end

---娃娃（Sub2）。占位贴图 "servant"；原作它有 24×24 判定与 life=9000，
---这里不给判定（99 秒内本来就打不死，给判定的意义只有干扰玩家）。
---（要改成可击破的实体就换 Class(enemy, ...) + object.Connect，见 AGENTS §7.4。）
local alice_doll = Class(object, {
    init = function(self, x, y, angle, info)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        if info.color == COLOR.RED then
            self._r, self._g, self._b = 255, 150, 150
        else
            self._r, self._g, self._b = 190, 150, 255
        end
        -- 公转圆心 = BOSS 生成娃娃时的位置（原作的 positionOffset 就写这一次，
        -- 之后 BOSS 乱走跟娃娃无关：EnemyManagerUpdate.cpp:170-176 只在
        -- inheritParentPosition 置位时才刷新，而这个位在 spawnTemplate 里是 0）
        self.alice_center_x, self.alice_center_y = x, y
        self.alice_angle = angle
        self.alice_radius = 0
        self.alice_radial = ORBIT_RADIAL
        self.alice_angle_speed = info.angle_speed
        self.alice_color = info.color
        self.alice_shot_step = info.shot_step
        self.alice_turn_angle = info.turn_angle
        self.alice_gun_offset = 0
        self.alice_gun_mode = 3             -- op135(0, 3)
        self.alice_gun_time = 0
        self.alice_t = 0                    -- 主 context 的 time
    end,
    frame = function(self)
        local t = self.alice_t
        -- ① 主 context（Sub2）的定时动作。
        --   原作 EclRun.cpp:181-209 的顺序是「主 context → 子 context → UpdateMovement」，
        --   所以 t=660+900k 那一帧是**先把枪换成 Sub4、再跑枪**（换枪那一帧不会再多打一发 Sub3）。
        if t == 60 then
            -- ins_74(12000, v10017, 0)：半径冻结在 96，角速度不变
            self.alice_radial = 0
        elseif t >= GUN_SWITCH_FIRST and (t - GUN_SWITCH_FIRST) % GUN_CYCLE == 0 then
            -- ins_135(0, 4) + ins_17(v10017 *= 1.03) + ins_74(12000, v10017, 0)
            self.alice_gun_mode = 4
            self.alice_gun_time = 0
            self.alice_angle_speed = self.alice_angle_speed * ORBIT_SPEEDUP
        elseif t >= GUN_SWITCH_FIRST + 300 and (t - GUN_SWITCH_FIRST - 300) % GUN_CYCLE == 0 then
            -- ins_135(0, 3)：切回 Sub3
            self.alice_gun_mode = 3
            self.alice_gun_time = 0
        end
        -- ② 子 context（枪）跟着跑；它用的世界坐标 / 轨道角都是**上一帧末**的值
        gun_step(self)
        -- ③ 最后才是 UpdateMovement 的 ORBIT 分支（EnemyManager.cpp:36-58）：
        --    orbitAngle += ω；orbitRadius += radial；position = origin + polar(angle, radius)
        self.alice_angle = self.alice_angle + self.alice_angle_speed
        if self.alice_angle > PI then
            self.alice_angle = self.alice_angle - 2 * PI
        elseif self.alice_angle < -PI then
            self.alice_angle = self.alice_angle + 2 * PI
        end
        if self.alice_radial ~= 0 and self.alice_radius > 96 - ORBIT_RADIAL * 0.5 then
            -- 半径按 op72 的 radialVelocity 长到 96 就停（op74 也会在 t=60 把它归零）
            self.alice_radial = 0
        end
        self.alice_radius = self.alice_radius + self.alice_radial
        self.x = self.alice_center_x + math.cos(self.alice_angle) * self.alice_radius
        self.y = self.alice_center_y + math.sin(self.alice_angle) * self.alice_radius
        self.rot = -self.alice_angle * RAD     -- 观感近似：娃娃朝自己前进的方向
        self.alice_t = t + 1
    end,
})

---Sub1 t=110 的两段循环：各 8 个 ins_92（SPAWN_FAMILIAR_INHERITING_POSITION），
---positionOffset = BOSS 当时的 position → 公转圆心 = BOSS 生成时的位置。
---v10016 从 −π 起每轮 += π/4，两批的起始角一模一样（第二批时 v10016 被重新赋 −π）。
local function spawn_dolls(owner)
    for batch = 1, #DOLL_BATCHES do
        local info = DOLL_BATCHES[batch]
        for k = 0, DOLLS_PER_BATCH - 1 do
            local th08_angle = -PI + k * DOLL_ANGLE_STEP
            local doll = New(alice_doll, owner.x, owner.y, -th08_angle, info)
            dolls[#dolls + 1] = doll
        end
    end
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：
---每帧 movementTimer-- → progress = 1 − timer/duration → 套缓动 → position = origin + delta·progress；
---timer 到 0 时直接落在终点。本卡用的缓动都写 4 = OUT_QUADRATIC（EclManager.hpp:519-530），
---也就是 LuaSTG 的 VALUE_SET.DECEL 那条曲线（2n − n²）。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS（EclDependencies.cpp:128-191）。抽角度 + 四条边界修正，
---然后 StartTimedPolarDisplacement（:105-126）：delta = (cos,sin)(angle)·speed·duration、
---origin = 当前 worldPosition、缓动 4、时长 60。
---★ 边界修正那段是**原作自己的怪癖**，照抄：movementBounds 本卡从没设过（没有 ins_78），
---  所以四条判据都是拿 (0,0,0,0) 比 —— `x < 0+96` 偶尔真、`x > 0−96` 恒真、
---  `y < 0+48` 假、`y > 0−48` 恒真。其中「x > upper.x−96」那条把角度改写成
---  `π − enemy->movementAngle`（用的是**上一段的移动方向**，不是刚抽到的 angle）。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = ran:Float(0, PI / 2) + 3 * PI / 4
    else
        angle = ran:Float(0, PI / 2) - PI / 4
    end
    if bx < 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > -96 then
        if angle < PI / 2 and angle >= 0 then
            angle = PI - (owner.alice_movement_angle or 0)
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < 48 and angle < 0 then
        angle = -angle
    end
    if by > -48 and angle > 0 then
        angle = -angle
    end
    return angle
end

local function begin_wander(owner)
    local angle = wander_angle(owner)
    owner.alice_movement_angle = angle
    owner.alice_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * WANDER_FRAMES,
        dy = math.sin(-angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0,
    }
end

---BOSS 的每帧（原作是 enemy 的 interpolated movement，在 RunEcl 之后跑）。
---娃娃的生成排在位移**之前**：原作 RunEcl 里用的 worldPosition 就是上一帧末的位置。
local function boss_frame(owner)
    if not owner.alice_frame then return end
    local f = owner.alice_frame
    if f == DOLL_SPAWN_FRAME then
        spawn_dolls(owner)
    end
    local move = owner.alice_move
    if move == nil and f >= WANDER_FIRST and (f - WANDER_FIRST) % WANDER_PERIOD == 0 then
        begin_wander(owner)
        move = owner.alice_move
    end
    if move then
        local x, y, done = move_step(move)
        owner.x, owner.y = x, y
        if done then
            owner.alice_move = nil
        end
    end
    owner.alice_frame = f + 1
end

local function card_init(owner)
    -- 这张卡自己的帧计数器（boss 的 self.timer 是从出生算起的总帧数，不能用）
    owner.alice_frame = 0
    owner.alice_movement_angle = PI / 2   -- = 上一段（从出生点直着下来）的方向
    -- ins_64(110, 4, 192, 128)：从出生点插值到 (0,96)，缓动 4 = OUT_QUADRATIC
    owner.alice_move = {
        x0 = owner.x, y0 = owner.y,
        dx = 0 - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0,
    }
    -- 原作 Sub1 t=0 还有一堆「关掉射击、关判定、登记符卡」的指令：
    --   ins_105(0) 关自动射击、ins_110(0,0) 射击偏移归零、ins_113(-1,-1) 弹音效、
    --   ins_80(4) 关可伤害、ins_134(5940, 6) 设 99 秒时限、ins_122 START_SPELL、
    --   ins_95 清掉场上非 BOSS 敌机。
    --   移植版这些都由 boss 系统管（这张卡 t1 = t2 = t3，本来就打不动），
    --   t=110 的 ins_81(4) 开可伤害同理 —— 不另写。
end

local function card_del(owner)
    owner.alice_frame = nil
    owner.alice_move = nil
    for i = #dolls, 1, -1 do
        if IsValid(dolls[i]) then
            object.RawDel(dolls[i])
        end
        dolls[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[218] = {
    init = function(owner)
        dolls = {}
        pool = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 205「季节外调的蝴蝶风暴」（莉格露·奈特巴格）
---  ecldata1sp.ecl：Sub36 = BOSS 根、Sub37 = BOSS 的枪（CALL 进来的子程序）、
---  Sub38 = 子机（ins_94 生出来的独立敌机）。
---  下面每个节拍都用 /tmp/lw35/sim.py（照 EclRun.cpp 写的 ECL 解释器）逐帧模拟核对过：
---  执行条件是 `time == 指令.time`，JUMP/JUMP_DEC 会把 context 的 time **改写成目标的 time**，
---  CALL 压栈时父 context 的 time 冻结、帧末只给活动 context 的 time++（EclRun.cpp:96-209）。
---    · 一轮 302 帧：第 110 帧 CALL 37（Sub37 自己走 113 帧）→ 第 352 帧跑 t=240 那组
---      → 第 412 帧 t=300 的 JUMP 跳回 t=110。也就是 CALL 之间正好隔 302 帧，
---      5940 帧（99 秒）里 20 轮。
---    · t=240 那组**每轮只跑一次**（它的 JMP_INT_LT 目标不是自己那组，而是 t=300 的 JUMP）：
---      xi2++；xi2<3 就跳过「xi2=0、xi3++」直接去 JUMP；满 3 轮才 xi3++。
---      xi3 就是 ins_99 的 count1 → **每环弹数 6、6、6、7、7、7、8…**（每 3 轮 +1）。
---      同组还把 lf7/lf6/lf4 取反（cf0 = lf4 只影响本轮的旋转方向与槽 2 往哪边拐）。
---    · Sub37 一轮 48 个出弹帧：前 24 帧按「7 帧一组、组内偏移 0/3/5」，
---      后 24 帧同样 7 帧一组但组内偏移 0/2/5，两组之间换个符号做 lf2 的累加方向。
---      每个出弹帧：lf7 -= 0.006、lf0 += lf2（每组的第 3 块再 lf2 ± lf1）。
---    · 子机 Sub38：t=0 起什么都不做，t=300 开始**每 5 帧**打一发 24 颗的环
---      （speed1 = 4.5、angleStep = 15°）；13 发换一次极坐标加速方向（±0.4°/帧、120 帧），
---      **26 发重算一次自机方向**（= 130 帧）。
---  ins_99 = SHOOT_CIRCLE（EclManager.hpp:307，aimMode 3）：
---    args = (bulletType/color 打包, count1 = xi3, count2, speed1 = lf7, speed2 = 0.5,
---            angle = lf0, angleStep = 15°, transformFlags = 0xA6244)。
---    角度 = angle + i*(2π/count1) + j*angleStep（BulletManager.cpp:139-145），
---    速度 = count2 > 1 时 speed1 − (speed1−speed2)*j/count2（:83-92）。
---  ★ 难度掩码：判据是 `(mask & (difficultyMask|override)) == (difficultyMask|override)`
---    （EclRun.cpp:69-73），difficultyMask = 1 << difficulty（Lunatic = 8，GameManager.cpp:709），
---    override = 32（人类）/64（妖怪）（EnemyManager.cpp:903）。这张卡按 **Lunatic** 移植：
---    每个出弹帧的 3 条 ins_99 里 mask 0xff 与 mask 0xf8 的执行、mask 0xf4 的跳过
---    （那是 Hard 专用的重复波）。所以每帧 2 条：count2=1 一圈 + count2=2 两圈。
---  ★ 出生动画：transformFlags 带 SPAWN_NORMAL(4) → etama.anm 的 script22（15 帧，
---    etama8.decl script22 末尾 `+15:`）：出生瞬间位置先减 velocity*4，之后 15 帧每帧只走
---    velocity/2.5，第 16 帧（脚本走完那帧）再补一次完整位移并激活变换程序
---    （BulletManager.cpp:228-236、979-993 → :964 activateBullet）。子机的弹 flags = 544
---    没有 SPAWN_* → 出生当帧就是 FIRED（直接开始走变换程序）。
---  ★ 贴图占位：TH08 这张卡用 bulletType 0（初始）/ 3 / 8（蝴蝶）三种外观在飞行途中换，
---    这里拿 ball_small / ellipse / butterfly 顶替，TH08 的色号 c 对应我们的 1..16 号里的
---    c+1。17 张全实现完之后再统一换素材。
---  ★ 子机占位贴图 "servant"；它没有判定、不移动、也不参与碰撞。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（换算见文件头）：x' = x−192、y' = 224−y、角度整体取反。
local function to_th08_y(y) return 224 - y end

---节拍（裸字节 + 模拟核对）。
local BOSS_END_X, BOSS_END_Y = 0, 96        -- ins_64(110, 4, 192, 128) 的终点
local BOSS_MOVE_FRAMES = 110                -- ... 的时长
local FIRST_FRAME = 110                     -- 子机出生 + 第 1 次 CALL 37
local PERIOD = 302                          -- 一轮 302 帧（见上面那段）
local FAM_FIRST = 300                       -- 子机自己的 t=300 开始出弹
local FAM_PERIOD = 5                        -- 每 5 帧一发
local FAM_SWAP = 13                         -- 13 发换一次加速方向
local FAM_CYCLE = 26                        -- 26 发重算一次自机方向（=130 帧）

---同屏弹幕上限：全游戏共用 1536 个弹槽（BulletManager.hpp:455），
---activeBulletCount >= 0x600 时**整波不生**，波中间生不出来就放弃整波剩下的
---（BulletManager.cpp:686-712）。移植版没有全局弹池，本卡自己维护一张登记表。
local POOL_SIZE = 1536

---TH08 的场地（GameManager.cpp:132-155 的 IsWithinPlayfield：0..384 / 0..448）。
---弹飞出这里、且槽 0 的 400 帧回收延迟跑完之后才会被回收，所以这条边界必须自己判，
---不能让引擎按 bound 自动回收（那样弹一出屏就没了）。原作判据还带半个精灵宽高，
---这里从简（本卡的弹要么在场内、要么早就飞出很远，差这 16 px 不改变结论）。
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224

---ins_111 的 kind 位（BulletManager.hpp:429-455）。本卡 transformFlags = 680516 = 0xA6244
---把用到的几种全点亮了，所以程序里没有「按位与不上被跳过」的记录 —— 移植版直接把
---槽号顺序编成程序，运行时不用再按位与。
local K_ACCEL_POLAR = 0x20
local K_DIR_RELATIVE = 0x40
local K_CULL_DELAY = 0x2000
local K_SPRITE = 0x4000
local K_WAIT = 0x20000
local K_PLAY_SOUND = 0x80000

local SPAWN_NORMAL_FRAMES = 15              -- etama.anm script22 的长度（帧）

---Sub37 的 ins_99 参数。
local SHOT_SPEED2 = 0.5
local SHOT_STEP = 0.2617993950843811        -- angleStep = 15°
local SHOT_COLOR = 1                        -- TH08 色号 0 → 我们的 1 号色
local CULL_DELAY = 400                      -- 槽 0 的 frames
local WAIT_LONG = 60                        -- 槽 1
local WAIT_SHORT = 10                       -- 槽 6
local DIR_TURN_FRAMES = 30                  -- 槽 2 的 intervalFrames
local DIR_STOP_FRAMES = 60                  -- 槽 4 的 intervalFrames
local DIR_LAST_FRAMES = 10                  -- 槽 7 的 intervalFrames
local SOUND_INDEX = 27                      -- 槽 9（占位：不打音效）
local SPEED_DECAY = 0.006                   -- 每个出弹帧 lf7 -= 0.006

---子机 Sub38 的 ins_111(0, 32, 0, 120, -1, 0, ±0.006981317)：120 帧里每帧角度 ±0.4°、
---速度不变（4.5），于是弹画一条半径 4.5/0.006981317 ≈ 645 px 的圆弧。
local FAM_ANGLE_DELTA = 0.006981317
local FAM_SPEED = 4.5
local FAM_COUNT = 24
local FAM_COLOR_PLUS = 2                    -- TH08 色号 1 → 我们的 2 号色（+0.4°/帧）
local FAM_COLOR_MINUS = 4                   -- TH08 色号 3 → 我们的 4 号色（−0.4°/帧）

---本卡自己的池子（= 原作那 1536 个弹槽）。
local pool = {}

---池子里还活着几颗。原作是 BulletManager::OnUpdate 每帧边扫边数（BulletManager.cpp:814-818），
---这里只在出弹帧扫一次 —— 出弹帧之外池子不会变，少扫几千次。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---Sub37 的变换程序：10 条记录，**按槽号顺序**走（AdvanceTransformProgram 是
---`transformIndex++` 顺序扫，不是按 ECL 写的先后，BulletManager.cpp:310-333）。
---块（= 一轮里 7 帧周期的第几个出弹帧）决定槽 7/8；part 1 是块的第 1 发、
---part 2 是第 2·3 发（第 2 发在 Lunatic 上被掩码跳过，但它的槽 7 写在第 3 发之前，
---所以两发用同一份 part 2 程序）；sign = cf0 的符号，只影响槽 2 往哪边拐 90°。
local BLOCK = {
    { a_turn = 120,  a_speed = 2.8, b_turn = 120,  b_speed = 2.4, sprite = 7 },
    { a_turn = 180,  a_speed = 1.9, b_turn = 180,  b_speed = 2.4, sprite = 6 },
    { a_turn = -120, a_speed = 2.0, b_turn = -120, b_speed = 2.6, sprite = 5 },
}

local program_cache = {}

local function storm_program(block, part, sign)
    local key = ((block * 2 + part - 2) * 2) + (sign > 0 and 1 or 2)
    local p = program_cache[key]
    if p then return p end
    local blk = BLOCK[block]
    local turn, speed = blk.a_turn, blk.a_speed
    if part == 2 then turn, speed = blk.b_turn, blk.b_speed end
    ---槽 2 的 ±90°：TH08 里 cf0>=0 写的是 −1.5708（0x800c），取反之后我们要 +π/2。
    p = {
        { kind = K_CULL_DELAY,   allow = 1, frames = CULL_DELAY },                -- 槽 0
        { kind = K_WAIT,         allow = 1, frames = WAIT_LONG },                 -- 槽 1
        { kind = K_DIR_RELATIVE, allow = 0, angle = sign * PI / 2,                -- 槽 2
          keep_speed = true, interval = DIR_TURN_FRAMES, repeats = 1 },
        { kind = K_SPRITE,       allow = 0, style = ellipse, color = 2 },         -- 槽 3（type 3）
        { kind = K_DIR_RELATIVE, allow = 0, angle = -PI, speed = 0,               -- 槽 4
          interval = DIR_STOP_FRAMES, repeats = 1 },
        { kind = K_SPRITE,       allow = 0, style = ball_small, color = 14 },     -- 槽 5（type 0）
        { kind = K_WAIT,         allow = 1, frames = WAIT_SHORT },                -- 槽 6
        { kind = K_DIR_RELATIVE, allow = 0, angle = -turn * PI / 180,             -- 槽 7
          speed = speed, interval = DIR_LAST_FRAMES, repeats = 1 },
        { kind = K_SPRITE,       allow = 0, style = butterfly, color = blk.sprite }, -- 槽 8（type 8）
        { kind = K_PLAY_SOUND,   allow = 0, index = SOUND_INDEX },                -- 槽 9
    }
    program_cache[key] = p
    return p
end

---子机的弹：只有槽 0（极坐标加速 120 帧）。TH08 的 float1 是 angleDelta（±0.4°/帧）、
---float0 是 speedDelta（0），取反之后角度增量的符号翻过来。
local FAM_PROGRAM = {
    [FAM_COLOR_PLUS]  = { { kind = K_ACCEL_POLAR, allow = 0, frames = 120,
                            angle_delta = -FAM_ANGLE_DELTA, speed_delta = 0 } },
    [FAM_COLOR_MINUS] = { { kind = K_ACCEL_POLAR, allow = 0, frames = 120,
                            angle_delta = FAM_ANGLE_DELTA, speed_delta = 0 } },
}

local storm_bullet

---小弹（Sub37 和子机共用）。★ 位移全部自己在 frame 里算：LuaSTG 引擎每帧会替所有对象
---积分 x += vx（所以 vx/vy 必须留 0，否则每个位移都算两遍），速度矢量存在 bvx/bvy。
storm_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, program, color, spawn_frames)
        bullet.init(self, ball_small, color, false, true)
        self.bound = false                  -- 出屏回收自己判（槽 0 的 400 帧延迟）
        self.angle = angle                  -- 极坐标里的角
        self.speed = speed
        self.bvx = math.cos(angle) * speed  -- 真正用来位移的矢量
        self.bvy = math.sin(angle) * speed
        self.vx, self.vy = 0, 0             -- 引擎的自动积分必须保持 0
        ---出生动画：位置先退 velocity*4（BulletManager.cpp:228-236）。
        self.x = x - self.bvx * 4
        self.y = y - self.bvy * 4
        self.tf_program = program
        self.tf_index = 1
        self.tf_busy = 0                    -- 正在跑的变换数（原作的 activeTransformFlags != 0）
        self.tf_cull = 0                    -- 回收延迟
        self.tf_off = 0                     -- 出屏帧数
        self.tf_spawn = spawn_frames
    end,
    frame = function(self)
        ---① 出生动画：每帧只走 velocity/2.5；脚本走完那帧（第 16 次调用）再走一次完整位移
        ---并接着跑变换程序（BulletManager.cpp:979-993 → :964 activateBullet）。
        if self.tf_spawn then
            self.x = self.x + self.bvx * 0.4
            self.y = self.y + self.bvy * 0.4
            if self.tf_spawn > 0 then
                self.tf_spawn = self.tf_spawn - 1
                bullet.frame(self)
                return
            end
            self.tf_spawn = nil
        end
        ---② 变换程序：每帧至多应用一条会占位的记录；「即时记录」在同一次调用里继续往下走
        ---（BulletManager.cpp:310-482）。
        local program = self.tf_program
        while self.tf_index <= #program do
            local r = program[self.tf_index]
            if r.allow == 0 and self.tf_busy > 0 then break end
            local kind = r.kind
            self.tf_index = self.tf_index + 1
            if kind == K_CULL_DELAY then
                self.tf_cull = r.frames
            elseif kind == K_SPRITE then
                self:ChangeImage(r.style, r.color)
            elseif kind == K_PLAY_SOUND then
                -- 原作是 PlaySoundPositionedByIdx(27, x)，占位：不出声
            elseif kind == K_WAIT then
                self.tf_wait = r.frames
                self.tf_busy = self.tf_busy + 1
                break
            elseif kind == K_DIR_RELATIVE then
                self.tf_dir_angle = r.angle
                ---方向变换记录里 speed < -999（这里是 keep_speed）= 应用那一刻的当前速度
                ---（BulletManager.cpp:379-381）。
                self.tf_dir_speed = r.keep_speed and self.speed or r.speed
                self.tf_dir_interval = r.interval
                self.tf_dir_repeats = r.repeats
                self.tf_dir_timer = 0
                self.tf_dir_done = 0
                self.tf_dir = true
                self.tf_busy = self.tf_busy + 1
                break
            elseif kind == K_ACCEL_POLAR then
                self.tf_pol_angle = r.angle_delta
                self.tf_pol_speed = r.speed_delta
                self.tf_pol_end = r.frames
                self.tf_pol_timer = 0
                self.tf_pol = true
                self.tf_busy = self.tf_busy + 1
                break
            end
        end
        ---③ 各 Update —— 顺序照 BulletManager.cpp:824-857（极坐标加速 → 方向变换 → WAIT）。
        if self.tf_pol then
            if self.tf_pol_timer >= self.tf_pol_end then
                self.tf_pol = false
                self.tf_busy = self.tf_busy - 1
            else
                self.angle = self.angle + self.tf_pol_angle
                self.speed = self.speed + self.tf_pol_speed
                self.bvx = math.cos(self.angle) * self.speed
                self.bvy = math.sin(self.angle) * self.speed
            end
            self.tf_pol_timer = self.tf_pol_timer + 1   -- 最后那帧也 ++（:1250）
        end
        if self.tf_dir then
            local timer = self.tf_dir_timer
            local magnitude
            if timer >= self.tf_dir_interval then
                ---拐弯：角度 += record.angle、速度 = record.speed；拐够 repeat 次才清位
                ---（BulletManager.cpp:1255-1291）。
                self.tf_dir_done = self.tf_dir_done + 1
                if self.tf_dir_done >= self.tf_dir_repeats then
                    self.tf_dir = false
                    self.tf_busy = self.tf_busy - 1
                end
                self.angle = self.angle + self.tf_dir_angle
                self.speed = self.tf_dir_speed
                magnitude = self.speed
                self.tf_dir_timer = 1       -- 拐弯分支里 timer 归 0，函数末尾还要 ++
            else
                ---拐弯前按 interval 线性减速到 0：speed − timer*speed/interval（:1284-1289）。
                magnitude = self.speed - timer * self.speed / self.tf_dir_interval
                self.tf_dir_timer = timer + 1
            end
            self.bvx = math.cos(self.angle) * magnitude
            self.bvy = math.sin(self.angle) * magnitude
        end
        if self.tf_wait then
            if self.tf_wait > 0 then
                self.tf_wait = self.tf_wait - 1
            else
                ---清位那一帧不会激活下一条记录（AdvanceTransformProgram 在每帧最前面跑）。
                self.tf_wait = false
                self.tf_busy = self.tf_busy - 1
            end
        end
        ---④ 位移（BulletManager.cpp:859-860）。
        self.x = self.x + self.bvx
        self.y = self.y + self.bvy
        ---⑤ 出界回收（:862-893）：回收延迟跑完才判；正在转向的弹多给 128 帧机会。
        if self.tf_cull > 0 then
            self.tf_cull = self.tf_cull - 1
        end
        if self.tf_cull == 0 then
            if self.x < FIELD_L or self.x > FIELD_R
                    or self.y < FIELD_B or self.y > FIELD_T then
                if self.tf_dir then
                    self.tf_off = self.tf_off + 1
                    if self.tf_off >= 128 then
                        object.RawDel(self)
                        return
                    end
                else
                    if self.tf_off == 0 then
                        object.RawDel(self)       -- 原作的 Deactivate()：静默回收，不给碎片
                        return
                    end
                    self.tf_off = self.tf_off - 1
                end
            else
                self.tf_off = 0
            end
        end
        bullet.frame(self)
    end,
})

---一条 ins_99。生不出来就放弃整波剩下的（BulletManager.cpp:700-703）。
local function storm_shot(owner, base_angle, speed1, block, part, count1, count2, used)
    if used >= POOL_SIZE then return used end
    local program = storm_program(block, part, owner.lw205_sign)
    for j = 0, count2 - 1 do
        local speed = speed1
        if count2 > 1 then
            speed = speed1 - (speed1 - SHOT_SPEED2) * j / count2
        end
        for i = 0, count1 - 1 do
            if used >= POOL_SIZE then return used end
            ---TH08 的角度是 base + i*(2π/count1) + j*angleStep，我们整体取反。
            local angle = base_angle - i * (2 * PI / count1) - j * SHOT_STEP
            pool[#pool + 1] = New(storm_bullet, owner.x, owner.y, angle, speed,
                    program, SHOT_COLOR, SPAWN_NORMAL_FRAMES)
            used = used + 1
        end
    end
    return used
end

---Sub37 的 48 个出弹帧（相对 CALL 那一帧），逐字节 + 模拟核对：
---第 1 段 8 组 × 7 帧、组内偏移 0/3/5；第 2 段（起点 56）同样 7 帧一组、组内偏移 0/2/5。
---inc = 该帧收尾时 lf2 怎么变（第 1 段 +lf1、第 2 段 −lf1，只发生在每组的第 3 块）。
local SUB37_SHOTS = {}
do
    local n = 0
    local function push(base, off, inc)
        n = n + 1
        SUB37_SHOTS[n] = { frame = base + off, block = ((n - 1) % 3) + 1, inc = inc }
    end
    for i = 0, 7 do
        local base = 7 * i
        push(base, 0, 0)
        push(base, 3, 0)
        push(base, 5, 1)
    end
    for i = 0, 7 do
        local base = 56 + 7 * i
        push(base, 0, 0)
        push(base, 2, 0)
        push(base, 5, -1)
    end
end

---子机（Sub38）。占位贴图 "servant"；不移动、不给判定。
local familiar = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        self._r, self._g, self._b = 190, 255, 175
        self.fam_t = 0
        self.fam_aim = 0
    end,
    frame = function(self)
        local t = self.fam_t
        if t >= FAM_FIRST and (t - FAM_FIRST) % FAM_PERIOD == 0 then
            local k = (t - FAM_FIRST) / FAM_PERIOD          -- 第几发（0 起）
            if k % FAM_CYCLE == 0 then
                ---ins_7(lf0, AIM_TO_PL)：这一发之后 130 帧都用这个方向。
                ---（y 翻转之后用我们自己的坐标直接算 atan2 就是同一个角。）
                self.fam_aim = math.atan2(player.y - self.y, player.x - self.x)
            end
            if pool_used() < POOL_SIZE then
                local first = (k % FAM_CYCLE) < FAM_SWAP     -- 前 13 发一个方向、后 13 发反过来
                local color = first and FAM_COLOR_PLUS or FAM_COLOR_MINUS
                local program = FAM_PROGRAM[color]
                for i = 0, FAM_COUNT - 1 do
                    if pool_used() >= POOL_SIZE then break end
                    local angle = self.fam_aim - i * (2 * PI / FAM_COUNT)
                    pool[#pool + 1] = New(storm_bullet, self.x, self.y, angle, FAM_SPEED,
                            program, color, nil)
                end
            end
        end
        self.fam_t = t + 1
    end,
})

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：movementTimer-- →
---progress = 1 − timer/duration → 缓动 → position = origin + delta·progress。
---ins_64 的缓动 4 = OUT_QUADRATIC（EclManager.hpp:519-530）= 1−(1−u)²。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---BOSS（Sub36）每帧。原作顺序是 RunEcl（出弹）→ UpdateMovement（位移），
---所以出弹用的是**上一帧末**的位置（EnemyManagerUpdate.cpp:159-192）。
local function boss_frame(owner)
    ---★ boss 系统在 card.init 之前就会先跑一段 card.before（tools/check_stage.lua:1660-1680
    ---  也照抄了这个顺序），那几帧 frame 里 alice/lw205_frame 还是 nil；卡 218 同款守卫。
    if not owner.lw205_frame then return end
    local f = owner.lw205_frame
    if f == FIRST_FRAME then
        ---ins_94(38, 0, 0, 0, 9000, -2, 10)：子机的出生点 = BOSS 当时的 worldPosition。
        owner.lw205_fam = New(familiar, owner.x, owner.y)
    end
    ---t=110 那组的循环体（每 302 帧一次）：PLAY_SPECIAL_ANM + scf0 = lf4 + CALL 37。
    if f >= FIRST_FRAME and (f - FIRST_FRAME) % PERIOD == 0 then
        local i = (f - FIRST_FRAME) / PERIOD + 1            -- 第几轮（1 起）
        ---cf0 每轮在 t=240 取反一次 → 第 1 轮 +、第 2 轮 − ……
        owner.lw205_sign = (i % 2 == 1) and 1 or -1
        ---xi3：每 3 轮 +1（t=240 的 xi2<3 分支），是 ins_99 的 count1。
        owner.lw205_count1 = 6 + math.floor((i - 1) / 3)
        owner.lw205_angle = ran:Float(-PI, PI)              -- ins_7(lf0, RANDOM_ANGLE)
        owner.lw205_step = -owner.lw205_sign * 0.0392699093 -- lf2 = cf0（取反）
        owner.lw205_inc = -owner.lw205_sign * 0.00392699093 -- lf1 = cf0*0.1（取反）
        owner.lw205_speed1 = 2.2                            -- lf7 = 1.2 + 1
        owner.lw205_base = f
        owner.lw205_cursor = 1
    end
    local shots = SUB37_SHOTS
    local used = -1
    while owner.lw205_cursor <= #shots do
        local e = shots[owner.lw205_cursor]
        if owner.lw205_base + e.frame > f then break end
        if owner.lw205_base + e.frame == f then
            if used < 0 then used = pool_used() end
            local c1 = owner.lw205_count1
            local sp = owner.lw205_speed1
            local ang = owner.lw205_angle
            ---Lunatic：mask 0xff（count2=1）与 mask 0xf8（count2=2）执行，mask 0xf4 跳过。
            used = storm_shot(owner, ang, sp, e.block, 1, c1, 1, used)
            used = storm_shot(owner, ang, sp, e.block, 2, c1, 2, used)
            ---ins_16(lf7, 0.006) / ins_15(lf0, lf2) /（每组的第 3 块）lf2 ± lf1
            owner.lw205_speed1 = sp - SPEED_DECAY
            owner.lw205_angle = ang + owner.lw205_step
            if e.inc > 0 then
                owner.lw205_step = owner.lw205_step + owner.lw205_inc
            elseif e.inc < 0 then
                owner.lw205_step = owner.lw205_step - owner.lw205_inc
            end
        end
        owner.lw205_cursor = owner.lw205_cursor + 1
    end
    ---ins_64(110, 4, 192, 128)：从出生点插值到 (0,96)。
    local move = owner.lw205_move
    if move then
        local x, y, done = move_step(move)
        owner.x, owner.y = x, y
        if done then
            owner.lw205_move = nil
        end
    end
    ---t=240 的 ins_67(60, 4, 0)：速度参数是 0 → 位移恒 0（只有那条没人用的随机角被算出来
    ---又丢掉），所以 BOSS 从第 110 帧起就停在 (0,96)，不另写。
    owner.lw205_frame = f + 1
end

local function card_init(owner)
    owner.lw205_frame = 0
    owner.lw205_sign = 1
    owner.lw205_count1 = 6
    owner.lw205_angle = 0
    owner.lw205_step = 0
    owner.lw205_inc = 0
    owner.lw205_speed1 = 2.2
    owner.lw205_base = -1000000
    owner.lw205_cursor = 1
    owner.lw205_fam = nil
    owner.lw205_move = {
        x0 = owner.x, y0 = owner.y,
        dx = BOSS_END_X - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0,
    }
    ---原作 Sub36 t=0 还有一堆关射击、关判定、登记符卡、清场的指令
    ---（ins_105/95/113/80/110/134/153/132/122）—— 都由 boss 系统与 lw_before 管，不另写。
end

local function card_del(owner)
    ---★ 必须把帧计数器一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑，
    ---  留着 lw205_frame 它就会继续按 302 帧的周期出弹（踩过：卡结束后 180 帧还在新建
    ---  864 个对象）。卡 218 的 card_del 也是这么清的。
    owner.lw205_frame = nil
    owner.lw205_move = nil
    ---★ 子机是普通 object，del 里必须自己回收 —— 它内部每 5 帧打一发环、不会自己停，
    ---  漏掉的话卡结束后它还在无限出弹（踩过：卡结束后 180 帧还在新建对象）。
    if owner.lw205_fam and IsValid(owner.lw205_fam) then
        object.RawDel(owner.lw205_fam)
    end
    owner.lw205_fam = nil
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
    pool = {}
end

CARD[205] = {
    init = function(owner)
        pool = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 206「盲夜鸟」（米斯蒂娅·萝蕾拉）
---  ecldata2sp.ecl：Sub46 = BOSS 根、Sub47 = 子 context 3、Sub48 = 子 context 0。
---  这张卡**没有独立敌机**：两条子 context 都用 ins_135(SET_CHILD_ECL) 挂在 BOSS 自己
---  身上，弹全部从 BOSS 的位置出。下面的节拍用 /tmp/lw206/sim206.py（照 EclRun.cpp 写的
---  ECL 解释器：`time == 指令.time` 才执行、JUMP/JUMP_DEC 把 context 的 time 改写成目标的
---  time、帧末只给活动 context 的 time++）逐帧核对过。
---
---  · 根 Sub46：110 帧插值移动到 (0,96)；t=140 装 Sub47、t=170 装 Sub48；t=370 起空转。
---  · Sub47 是**夜盲症画面效果**：CALL_EX_INSTRUCTION(0,0) = g_EclExInsn[0]
---    = ConfigureNightBlindness（EclGlobals.cpp:65、EclExIns.cpp:30-34），把 li0/lf0
---    写进 g_AsciiManager 的 alpha / 半径，画成「以自机为中心的洞 + 洞外一片黑」
---    （AsciiManager.cpp:1627-1691）。半径 320→96（120 帧）、再 96→64（1800 帧），
---    alpha 0→255（10 帧）。移植成下面 lw206_blind 那个自绘 object。
---  · Sub48 是真正的出弹程序，一轮 396 帧：
---      t=0..95   每帧一发 ins_97（SHOOT_FAN）：count1=1、count2=8 → **同一角度、速度从
---                8 递减到 2.75 的 8 颗「虚线流」**；角度以自机方向 ±90° 起步、每帧转 7.5°，
---                4 段各 24 帧（第 1/3 段同向、第 2/4 段反向；色 6 / 8 交替）。
---      t=96      先跑 ins_67(60,4,1.0)：BOSS 沿「边界感知随机方向」漂 60 px（60 帧缓动），
---                紧接着 ins_99（SHOOT_CIRCLE）：count1 = xi3 的一圈速度 1.3 + 一圈速度 0.5、
---                随机基准角；之后每 20 帧一发、共 15 发。
---      一轮结束时 xi3 += 6（32 → … → 68 封顶）→ 环越打越密。
---  ★ 自机方向**整个卡只算一次**：Sub48 末尾的 JUMP 目标落在 `xi3 = 32` **之后**
---    （反汇编核对：rel=1048 的 ins_4(0,−1028) 指向 rel=20，不是 rel=0），所以
---    `lf3 = AIM_TO_PL` 从挂上来那一帧就冻住了。
---  ★ 出生动画：ins_97 的 transformFlags = 0x202 带 SPAWN_FAST(0x2) → 出生瞬间位置先退
---    velocity*4，之后每帧只走 velocity/2；etama8.decl script21 是 `+10: ins_1`
---    （脚本要 11 次调用才结束），走完那帧再补一次完整位移
---    （BulletManager.cpp:228-236、950-968）。ins_99 的 flags = 0x200 只有
---    PLAY_SPAWN_SOUND → 出生当帧就是 FIRED，立刻按全速走。
---  ★ 贴图占位：ins_97 的 bulletType 6、ins_99 的 bulletType 1 都先拿 ball_small 顶，
---    TH08 色号 c → 我们的 c+1；夜盲症用 Resources/Special/Blindness.png。
---    17 张全实现完之后再统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---TH08 世界坐标 → 我们坐标（换算见文件头）：x' = x−192、y' = 224−y、角度整体取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---节拍（Sub46/47/48 的裸字节）。
local BOSS_END_X, BOSS_END_Y = 0, 96
local BOSS_MOVE_FRAMES = 110
local BLIND_FRAME = 140                 -- ins_135(3, 47)
local SHOT_FRAME = 170                  -- ins_135(0, 48)
local ROUND = 396                       -- 一轮 396 帧
local STREAM_FRAMES = 96                -- 前 96 帧：每帧一发 8 连虚线流
local RING_FIRST = 96                   -- 从 t=96 起每 20 帧一发环
local RING_PERIOD = 20
local RING_SHOTS = 15
local MOVE_FRAMES = 60                  -- ins_67(60, 4, 1.0)
local MOVE_SPEED = 1.0

local FAN_COUNT = 8                     -- count2
local FAN_SPEED = 8.0                   -- lf0 初值（每个 24 帧段开头重置成 8）
local FAN_SPEED_DECAY = 0.25            -- 每帧 lf0 -= 0.25
local FAN_SPEED2_RATIO = 0.25           -- speed2 = lf0/4（ins_28(lf2, lf0, 4)）
local FAN_ANGLE0 = 1.5707963705062866   -- ±π/2（ins_25/26 的 1.5708）
local FAN_ANGLE_STEP = 0.13089969754219055  -- 每帧 ±7.5°
local FAN_BLOCK = 24

local RING_SPEED1 = 1.2999999523162842
local RING_SPEED2 = 0.5
---xi3（ins_99 的 count1）：初值 32，每轮收尾 `JMP_INT_GE(xi3, 64)` 不成立就 +6，
---所以是 32,38,44,50,56,62,68,68,…（判的是「加之前到没到 64」，于是跳过 64 直接到 68）。
local RING_COUNT0, RING_COUNT_STEP, RING_COUNT_MAX = 32, 6, 68
local RING_COLOR = 11                   -- TH08 色号 10 → 我们的 11

---出生动画：SPAWN_FAST 的脚本（etama8.decl script21）里 `+10: ins_1` → 一共 11 次调用，
---所以前 11 帧每帧只走 velocity/2，脚本走完那一帧再补一次完整位移。
local SPAWN_FAST_FRAMES = 10

---同屏弹幕上限：全游戏共用 1536 个弹槽（BulletManager.hpp:455 `Bullet bullets[0x601]`），
---activeBulletCount >= 0x600 时**整波不生**、波中间生不出来就放弃整波剩下的
---（BulletManager.cpp:686-712）。移植版没有全局弹池，本卡自己维护一张登记表。
local POOL_SIZE = 1536

---TH08 的场地（GameManager.cpp:132-155 的 IsWithinPlayfield：0..384 / 0..448）。
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224

---夜盲症的三条 ins_36。INSTALL_INTERPOLATION 的操作数是
---[目标 float 变量, 时长, 回调号, 缓动, p0, p1, p2, p3]（EclDependencies.cpp:356-383），
---回调 0..6 全是 InterpolateLinear（EclGlobals.cpp:16-25），缓动 0 = 线性。
local BLIND_R0, BLIND_R1, BLIND_R_FRAMES = 320, 96, 120
local BLIND_R2, BLIND_R2_FRAMES = 64, 1800
local BLIND_A_FRAMES = 10
local BLIND_LOOP = 125                  -- 循环 125 次之后换第二条半径插值

---本卡自己的池子（= 原作那 1536 个弹槽）。
local pool = {}

---池子里还活着几颗。原作是 BulletManager::OnUpdate 每帧边扫边数
---（BulletManager.cpp:810-818），这里只在出弹帧扫一次 —— 出弹帧之外池子不会变。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

local lw206_bullet

---本卡的弹。★ 位移全部自己在 frame 里算：LuaSTG 引擎每帧会替所有对象积分 x += vx
---（所以 vx/vy 必须留 0，否则每个位移都算两遍），速度矢量存在 bvx/bvy。
lw206_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, style, color, spawn_frames)
        bullet.init(self, style, color, false, true)
        self.bound = false                  -- 出屏回收自己判
        self.angle = angle                  -- 我们坐标下的方向
        self.speed = speed
        self.bvx = math.cos(angle) * speed
        self.bvy = math.sin(angle) * speed
        self.vx, self.vy = 0, 0             -- 引擎的自动积分必须保持 0
        self.spawn = spawn_frames
        if spawn_frames then
            ---出生动画：位置先退 velocity*4（BulletManager.cpp:228-236）。
            self.x = x - self.bvx * 4
            self.y = y - self.bvy * 4
        else
            self.x, self.y = x, y
        end
    end,
    frame = function(self)
        ---① 出生动画（BulletManager.cpp:950-968）：每帧只走 velocity/2；脚本走完那帧
        ---   `goto activateBullet` → 同一帧再走一次完整位移。
        if self.spawn then
            self.x = self.x + self.bvx * 0.5
            self.y = self.y + self.bvy * 0.5
            if self.spawn > 0 then
                self.spawn = self.spawn - 1
                bullet.frame(self)
                return
            end
            self.spawn = nil
        end
        ---② 本卡的弹没有任何变换程序（Sub48 里没有 ins_111），直接匀速直线。
        self.x = self.x + self.bvx
        self.y = self.y + self.bvy
        ---③ 出界回收（BulletManager.cpp:862-893）：原作判的是「中心出屏超过半个精灵」，
        ---   这里从简用场地本身（本卡的弹要么在场内、要么早就飞远了）。
        if self.x < FIELD_L or self.x > FIELD_R
                or self.y < FIELD_B or self.y > FIELD_T then
            object.RawDel(self)
            return
        end
        bullet.frame(self)
    end,
})

---Sub47 的夜盲症。原作是纯画面效果（写在 AsciiManager 里），这里做成一个跟着自机走的
---object：洞内画 Blindness 贴图、洞外补四块黑。alpha/半径的插值口径照抄 Sub47。
local lw206_blind = Class(object, {
    init = function(self)
        self.img = "Blindness"
        self.layer = LAYER.ENEMY_BULLET_EF + 1
        self.group = GROUP.INDES
        self.hide, self.bound, self.navi, self.colli = false, false, false, false
        self._blend, self._a, self._r, self._g, self._b = "", 255, 255, 255, 255
        self.bl = 0
        self.alpha = 0
        self.radius = BLIND_R0
    end,
    frame = function(self)
        local bl = self.bl
        self.bl = bl + 1
        self.x, self.y = player.x, player.y
        ---alpha：lf1 的 10 帧插值。li0 = (int)lf1 只在头 10 帧里被读，之后固定 255。
        local a = bl * 255 / BLIND_A_FRAMES
        if a > 255 then a = 255 end
        self.alpha = a
        ---半径：LF0 的 320→96（120 帧），第 125 帧换成 96→64（1800 帧）。
        if bl < BLIND_LOOP then
            local u = bl
            if u > BLIND_R_FRAMES then u = BLIND_R_FRAMES end
            self.radius = BLIND_R0 + (BLIND_R1 - BLIND_R0) * u / BLIND_R_FRAMES
        else
            local u = bl - (BLIND_LOOP - 1)
            if u > BLIND_R2_FRAMES then u = BLIND_R2_FRAMES end
            self.radius = BLIND_R1 - (BLIND_R1 - BLIND_R2) * u / BLIND_R2_FRAMES
        end
    end,
    render = function(self)
        local a = self.alpha
        if a <= 0 then return end
        local r = self.radius
        local w = lstg.world
        ---洞外四块黑（AsciiManager.cpp:1630-1676 的四个 DrawSquare；参数序是 l, r, b, t）。
        SetImageState("white", "", a, 0, 0, 0)
        if self.x - r > w.l then RenderRect("white", w.l, self.x - r, w.b, w.t) end
        if self.x + r < w.r then RenderRect("white", self.x + r, w.r, w.b, w.t) end
        if self.y - r > w.b then RenderRect("white", w.l, w.r, w.b, self.y - r) end
        if self.y + r < w.t then RenderRect("white", w.l, w.r, self.y + r, w.t) end
        ---洞本身：原作把 128×128 的贴图缩放成半径/63（≈ 直径 2r）。
        SetImageState("Blindness", "", a, 255, 255, 255)
        Render("Blindness", self.x, self.y, 0, r / 64, r / 64)
    end,
})

---一条 ins_97（SHOOT_FAN）：count1 = 1、count2 = 8。
---角度只跟 index1 走（count1=1 → 偏移 0），index2 只改速度：
---speed_j = speed1 − (speed1−speed2)·j/count2（BulletManager.cpp:83-92、139-145）。
local function lw206_shot_fan(owner, angle, speed1, color)
    local used = pool_used()
    if used >= POOL_SIZE then return end
    local speed2 = speed1 * FAN_SPEED2_RATIO
    for j = 0, FAN_COUNT - 1 do
        if used >= POOL_SIZE then return end
        local speed = speed1 - (speed1 - speed2) * j / FAN_COUNT
        pool[#pool + 1] = New(lw206_bullet, owner.x, owner.y, angle, speed,
                ball_small, color, SPAWN_FAST_FRAMES)
        used = used + 1
    end
end

---一条 ins_99（SHOOT_CIRCLE）：count1 = xi3、count2 = 2、speed1 = 1.3、speed2 = 0.5、
---angle = RANDOM_ANGLE（一次指令只抽一个基准角，两圈共用）。
---角度 = angle + i·(2π/count1) + j·angleStep，我们整体取反。
local function lw206_shot_circle(owner, count1)
    local used = pool_used()
    if used >= POOL_SIZE then return end
    local base = ran:Float(-PI, PI)
    for j = 0, 2 - 1 do
        local speed = RING_SPEED1 - (RING_SPEED1 - RING_SPEED2) * j / 2
        for i = 0, count1 - 1 do
            if used >= POOL_SIZE then return end
            local angle = base - i * (2 * PI / count1)
            pool[#pool + 1] = New(lw206_bullet, owner.x, owner.y, angle, speed,
                    ball_small, RING_COLOR, nil)
            used = used + 1
        end
    end
end

---ins_67 = BeginBoundaryAwareMove（EclDependencies.cpp:128-191）。本卡从没跑过 ins_75，
---movementBounds 一直是 (0,0,0,0)，于是四条判据退化成：
---  · x < 96（TH08）才左反射；
---  · x > −96 **恒真** → 这一段里的 `π − enemy->movementAngle` 用的是**上一段位移的方向**
---    （原作这里就是这么写的，照抄，不要「修」成 angle）；
---  · y > 176（我们坐标）且角度朝上才翻；
---  · y < 272 **恒真** → 正角度一律翻成负（TH08 里就是永远往上飞）。
---返回的是 **TH08 角度**（和原作的比较口径一致），调用处再取反成我们的角度。
local function lw206_move_angle(owner)
    local ex8 = to_th08_x(owner.x)
    local ey8 = to_th08_y(owner.y)
    local px8 = to_th08_x(player.x)
    local angle
    if px8 < ex8 then
        ---AddNormalizeAngle(..., 0)（Global.cpp:1239-1252）把结果卷进 [−π, π]；
        ---后面的符号判据靠这个，必须照做。
        angle = ran:Float(0, PI / 2) + 2.3561945
        if angle > PI then angle = angle - 2 * PI end
    else
        angle = ran:Float(0, PI / 2) - 0.78539819
    end
    if ex8 < 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if ex8 > -96 then
        if angle >= 0 and angle < PI / 2 then
            angle = PI - owner.lw206_mangle
        elseif angle <= 0 and angle > -PI / 2 then
            angle = -PI - angle
        end
    end
    if ey8 < 48 and angle < 0 then
        angle = -angle
    end
    if ey8 > -48 and angle > 0 then
        angle = -angle
    end
    return angle
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：movementTimer-- →
---progress = 1 − timer/duration → 缓动 → position = origin + delta·progress。
---ins_67 的缓动 4 = OUT_QUADRATIC（EclManager.hpp:519-530）= 1−(1−u)²。
local function lw206_move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---BOSS（Sub46 + 两条子 context）每帧。原作顺序是 RunEcl（主 context → 子 context 3 →
---子 context 0）→ UpdateMovement，所以出弹用的是**上一帧末**的位置
---（EnemyManagerUpdate.cpp:159-192）。
local function boss_frame(owner)
    ---★ boss 系统在 card.init 之前就会先跑一段 card.before（tools/check_stage.lua 也照抄了
    ---  这个顺序），那几帧 frame 里 lw206_t 还是 nil；卡 205/218 同款守卫。
    if not owner.lw206_t then return end
    local f = owner.lw206_t
    if f == BLIND_FRAME then
        ---ins_135(3, 47)：子 context 3 = 夜盲症。
        owner.lw206_blind = New(lw206_blind)
    end
    if f >= SHOT_FRAME then
        ---子 context 0（Sub48）的 time：挂上来那一帧是 0。
        local ct = (f - SHOT_FRAME) % ROUND
        if f == SHOT_FRAME then
            ---ins_7(lf3, AIM_TO_PL)：整个卡只算这一次（见文件头）。
            owner.lw206_aim = math.atan2(player.y - owner.y, player.x - owner.x)
        end
        if ct < STREAM_FRAMES then
            ---t=0..95：4 段 × 24 帧。第 1/3 段从「自机方向 +90°」起步、每帧 −7.5°；
            ---第 2/4 段从 −90° 起步、每帧 +7.5°（色 6 / 8 交替）。
            local block = math.floor(ct / FAN_BLOCK)
            local i = ct % FAN_BLOCK
            local speed1 = FAN_SPEED - FAN_SPEED_DECAY * i
            local angle
            if block % 2 == 0 then
                angle = owner.lw206_aim - FAN_ANGLE0 + FAN_ANGLE_STEP * i
            else
                angle = owner.lw206_aim + FAN_ANGLE0 - FAN_ANGLE_STEP * i
            end
            ---TH08 色号 6 / 8 → 我们的 7 / 9。
            local color = (block % 2 == 0) and 7 or 9
            lw206_shot_fan(owner, angle, speed1, color)
        elseif (ct - RING_FIRST) % RING_PERIOD == 0 then
            local k = (ct - RING_FIRST) / RING_PERIOD
            if k < RING_SHOTS then
                if k == 0 then
                    ---ins_67(60, 4, 1.0)：同一帧、且在 ins_99 之前。
                    local round = math.floor((f - SHOT_FRAME) / ROUND)
                    local count1 = RING_COUNT0 + RING_COUNT_STEP * round
                    if count1 > RING_COUNT_MAX then count1 = RING_COUNT_MAX end
                    owner.lw206_round_count = count1
                    local a = lw206_move_angle(owner)
                    local len = MOVE_FRAMES * MOVE_SPEED
                    owner.lw206_mangle = a
                    owner.lw206_move = {
                        x0 = owner.x, y0 = owner.y,
                        dx = math.cos(a) * len,         -- TH08 的 (dx, dy) 取 y 反
                        dy = -math.sin(a) * len,
                        n = MOVE_FRAMES, t = 0,
                    }
                end
                lw206_shot_circle(owner, owner.lw206_round_count or RING_COUNT0)
            end
        end
    end
    ---ins_64(110, 4, 192, 128)：根的入场插值（TH08 y=128 → 我们 96）。
    local move = owner.lw206_move
    if move then
        local x, y, done = lw206_move_step(move)
        ---位移方向（TH08 角）在整段里不变；原作每帧用 VectorAngle 重算一次，等价。
        owner.lw206_mangle = math.atan2(-(y - owner.y), x - owner.x)
        owner.x, owner.y = x, y
        if done then
            owner.lw206_move = nil
        end
    end
    owner.lw206_t = f + 1
end

local function card_init(owner)
    owner.lw206_t = 0
    owner.lw206_aim = 0
    owner.lw206_mangle = PI / 2          -- 入场那一段是垂直向下（TH08 y+）
    owner.lw206_round_count = RING_COUNT0
    owner.lw206_blind = nil
    owner.lw206_move = {
        x0 = owner.x, y0 = owner.y,
        dx = BOSS_END_X - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0,
    }
    ---原作 Sub46 t=0 还有一堆关射击、关判定、登记符卡、清场的指令
    ---（ins_105/95/113/80/110/134/153/132/122）—— 都由 boss 系统与 lw_before 管，不另写。
end

local function card_del(owner)
    ---★ 必须把帧计数器一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑，
    ---  留着 lw206_t 它就会继续按 396 帧的周期出弹（卡 205 踩过同款坑）。
    owner.lw206_t = nil
    owner.lw206_move = nil
    if owner.lw206_blind and IsValid(owner.lw206_blind) then
        object.RawDel(owner.lw206_blind)
    end
    owner.lw206_blind = nil
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
    pool = {}
end

CARD[206] = {
    init = function(owner)
        pool = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 207「日出之国的天子」（上白泽慧音）
---  ecldata3sp.ecl：Sub56 = BOSS 根、Sub57 = 子 context 0（BOSS 自己的激光）、
---  Sub58 = 使魔、Sub59 = 使魔的枪（挂在使魔的子 context 0 上）。
---
---  · Sub56：110 帧插值入场到 TH08 (192,128) = 我们 (0,96)；t=110 一次生成 10 只
---    使魔、并把 Sub57 挂到自己身上；t=290 的 `ins_4(110, −16)` 跳回的是**紧邻的
---    `INT_INC(xi3)`**（裸字节 rel 1204 − 16 = 1188 = INT_INC，用 jt.py 复核过），
---    所以循环体里只有 `xi3++`（本卡没人读 xi3）—— 使魔和 Sub57 都只建一次。
---  · Sub58（使魔）：`ins_72(41, selfX, selfY, lf0, lf1, 0, lf2)` = 绕**生成点**
---    公转：半径每帧 +0.8、角度每帧 +lf1（±4.5°），到 t=40（ins_72 的 duration 41
---    正好走完）用 `ins_74(3600, 0, 0)` 把两个速度归零 → 停在半径 32 处
---    （角度一共扫过 ±180°）；t=100 起 `ins_74(3600, lf1/16, 0)` 以 ±0.28125°/帧
---    慢慢公转；t=3700 的 `ins_1` TERMINATE → 使魔消失。
---  · Sub59（使魔的枪；挂上时它自己的 time 从 0 起算）：t=300 / 320 / 340 各一发，
---    t=360 的 `ins_4(300, −272)` 跳回 t=300 —— 因为 JUMP 会把 time 直接拨回去、
---    同一帧接着跑 t=300 的头，所以实际就是「每 20 帧一发、3 发一轮」：
---    每个 60 帧周期的第 1 拍是 `ins_96`(FAN_AIMED，自机狙、速度 0.9、色 1)，
---    第 2/3 拍是 `ins_97`(FAN，角度 = `ins_34` 算出的「从自己指向公转圆心」
---    = **朝里**、速度 1.1、色 3)。
---  · Sub57（BOSS 的激光）：t=120 起 60 帧每帧一发 `ins_114` CREATE_LASER，
---    角度从 `AIM_TO_PL − 90°` 起每帧 −6°；紧接着（t=179 那一帧接上）再 60 发，
---    角度 +183° 起步、每帧 +6°；t=322 跳回 t=120 → 周期 202 帧。
---    激光是**静止**的 ray：长 640、宽 12，生成后 startTime 帧才成实体
---    （startTime = 190, 188, …, 72 逐发递减），实体 30 帧 + 消散 20 帧。
---  ★ 参数怎么传给使魔：`SpawnChildAtScriptPosition`（EclRunLow.inl:52-77）把父
---    context 的**整块变量** memcpy 给子敌机（SpawnEnemy2 的第 6 个参数就是那块），
---    所以 ins_90 之前设的 lf0/lf1/lf2 就是使魔 Sub58 的初值；同样地 `ins_135`
---    SET_CHILD_ECL 会把当前 context 的变量复制给子 context
---    （EclRunHigh.inl:646-671），使魔 t=0 存进 xf0/xf1 的「生成点」就这样传给了枪。
---  ★ 公转圆心不漂：`ins_90` 不给 positionOffset 赋值（只有 ins_92 那类
---    inheritParentPosition 才会在每帧刷 positionOffset，EnemyManagerUpdate.cpp:169-176），
---    所以 worldPosition = position，ORBIT 分支的
---    velocity = (圆心 + 极坐标) − position 就是「一步走到极坐标点」（EnemyManager.cpp:36-58）。
---  ★ 贴图占位：使魔 "servant"（跟卡 218 的娃娃一样）、弹 ball_small、
---    激光用 THlib 的 laser 类。17 张全部实现完之后再统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（换算见文件头）：x' = x−192、y' = 224−y、角度整体取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---TH08 口径的「从 BOSS 指向自机」角。ECL_OPERAND_ANGLE_TO_PLAYER 就是
---`Player::AngleToPoint`（Player.cpp:967-980）= atan2(pl.y − self.y, pl.x − self.x)，
---换成我们的坐标读就是 atan2(self.y − pl.y, pl.x − self.x)（= −aim_我们）。
---本卡凡是要跟原作算式对齐的量（下面激光的 lf0）都保持 TH08 口径，落笔给 LuaSTG 时再取反。
local function aim_to_player_th08(owner)
    return math.atan2(to_th08_y(player.y) - to_th08_y(owner.y),
                      to_th08_x(player.x) - to_th08_x(owner.x))
end

---根 Sub56 的节拍。
local BOSS_END_X, BOSS_END_Y = 0, 96
local BOSS_MOVE_FRAMES = 110
local SPAWN_FRAME = 110                 -- ins_90 ×10 + ins_135(0, 57)

---使魔 Sub58 的节拍。
local FAM_RADIAL = 0.8                  -- lf2：半径每帧 +0.8
local FAM_SPIRAL_OMEGA = 0.0785398185   -- lf1 = 4.5°/帧
local FAM_HOVER_FRAME = 40              -- ins_74(3600, 0, 0)
local FAM_SLOW_FRAME = 100              -- ins_74(3600, lf1/16, 0)
local FAM_SLOW_DIV = 16
local FAM_END_FRAME = 3700              -- ins_1 TERMINATE

---使魔的枪 Sub59 的节拍。
local GUN_FIRST = 300
local GUN_PERIOD = 20
local GUN_AIM_SPEED = 0.9               -- ins_96 的 speed1（speed2 用不上：count2=1）
local GUN_IN_SPEED = 1.1                -- ins_97 的 speed1

---BOSS 的激光 Sub57。
local LASER_FIRST = 120
local LASER_STEP = 0.10471975803375244  -- 每帧 ∓6°
local LASER_TURN = 3.1939525604248047   -- 两块之间 +183°
local LASER_WRAP = LASER_FIRST + 202    -- t=322 的 ins_4(120, −444) → 周期 202 帧
local LASER_START0 = 190                -- li0 初值
local LASER_START_STEP = -2             -- 每发 li0 −= 2
local LASER_COUNT = 60                  -- 每块 60 发（xi0 = 60 的 JUMP_DEC 循环）
local LASER_WIDTH = 12
local LASER_LENGTH = 640                -- startOffset 0 → endOffset 640，speed = 0
local LASER_DURATION = 30
local LASER_DESPAWN = 20
local LASER_RAMP = 30                   -- startTime > 30 时最后 30 帧才开始变粗
local LASER_COLOR1 = 7                  -- TH08 色号 6 → 我们的 7
local LASER_COLOR2 = 3                  -- TH08 色号 2 → 我们的 3
local LASER_HITBOX_START = 190
local LASER_HITBOX_DELAY = 20

---10 只使魔（ins_90 的裸字节：subId=58, x, y, life, itemDropType=-2, score=100）。
---x/y 是 TH08 的**绝对**坐标；lf0（初始公转角）/lf1（公转角速度）/lf2（径向速度）
---由 ins_90 前那段 SET_FLOAT / FLOAT_ADD_ASSIGN 给出，随变量块一起被子使魔继承。
---下面写的是**已经换算到我们坐标系**的值（角度 = −TH08 角、角速度 = −TH08 角速度）：
---  · 组 1：TH08 (96,128) → 我们 (−96,96)，lf0 = −90°/30°/150°（每只 +120°）、lf1 = +4.5°/帧
---  · 组 2：TH08 (288,128) → 我们 (96,96)，同角度、lf1 = −4.5°/帧
---  · 组 3：TH08 (192,224) → 我们 (0,0)，lf0 = 0°/180°/180°/360°，
---         前两只 lf1 = −4.5°/帧、后两只 +4.5°/帧
---{我们x, 我们y, 我们初始角, 我们角速度, 组号（占位贴图配色）}
local FAMILIARS = {
    { -96, 96, PI / 2,          -FAM_SPIRAL_OMEGA, 1 },
    { -96, 96, -PI / 6,         -FAM_SPIRAL_OMEGA, 1 },
    { -96, 96, -5 * PI / 6,     -FAM_SPIRAL_OMEGA, 1 },
    { 96,  96, PI / 2,           FAM_SPIRAL_OMEGA, 2 },
    { 96,  96, -PI / 6,          FAM_SPIRAL_OMEGA, 2 },
    { 96,  96, -5 * PI / 6,      FAM_SPIRAL_OMEGA, 2 },
    { 0,   0,  0,                FAM_SPIRAL_OMEGA, 3 },
    { 0,   0, -PI,               FAM_SPIRAL_OMEGA, 3 },
    { 0,   0, -PI,              -FAM_SPIRAL_OMEGA, 3 },
    { 0,   0, -2 * PI,          -FAM_SPIRAL_OMEGA, 3 },
}

---同屏弹幕上限：全游戏共用 1536 个弹槽（BulletManager.hpp:455），
---activeBulletCount >= 0x600 时整波不生（BulletManager.cpp:686-690）。移植版本卡自建登记表。
local POOL_SIZE = 1536

local familiars = {}
local pool = {}

local function in_bound(unit)
    return IsValid(unit)
            and unit.x >= lstg.world.boundl and unit.x <= lstg.world.boundr
            and unit.y >= lstg.world.boundb and unit.y <= lstg.world.boundt
end

local function pool_used()
    for i = #pool, 1, -1 do
        if not in_bound(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

local lw207_bullet

---本卡的弹。ins_96/ins_97 的 transformFlags = 16912 = 0x4210
---（SET_SPRITE|PLAY_SPAWN_SOUND|ACCELERATE_VECTOR），**没有** SPAWN_FAST/NORMAL/SLOW，
---所以出生当帧就是 FIRED、按全速走（BulletManager.cpp:208-236）。
---ACCELERATE_VECTOR/SET_SPRITE 要有 ins_111 写进 descriptor->transforms 才生效，
---而本卡从没写过 → transforms 全 0 → `record->kind == BULLET_TRANSFORM_NONE`
---直接返回（BulletManager.cpp:310-320），弹是纯直线。所以这里把速度交给引擎积分。
lw207_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color)
        ---bullet:init(imgclass, index, stay, destroyable, fogtime)（THlib/bullet/bullet.lua:75）
        bullet.init(self, ball_small, color, false, true)
        self.angle = angle
        self.speed = speed
        self.vx = math.cos(angle) * speed
        self.vy = math.sin(angle) * speed
    end,
})

---一次出弹。池满 → 整波不生（BulletManager.cpp:686-690）。
local function spawn_bullet(x, y, angle, speed, color)
    if pool_used() >= POOL_SIZE then
        return false
    end
    pool[#pool + 1] = New(lw207_bullet, x, y, angle, speed, color)
    return true
end

local lw207_familiar
local lw207_laser

---使魔的枪（Sub59）。第 1 拍两发（自机狙 + 朝里），第 2/3 拍各一发（朝里）。
---gt = 枪自己的 time：它是在使魔 t=40 那一帧被 `ins_135(0, 59)` 挂上的，
---挂上时从 0 起算，所以 gt = 使魔 t − 40。
---朝里的角度 = ins_34 POINT_ANGLE(lf0, selfX, selfY, xf0, xf1)
---= atan2(xf1 − selfY, xf0 − selfX)（EclRunLow.inl:342-351）—— 注意是**从自己指向圆心**。
---用的坐标是**上一帧末**的位置（RunEcl 在 UpdateMovement 之前，EnemyManagerUpdate.cpp:159-192）。
local function gun_step(owner, gt)
    if gt >= GUN_FIRST and (gt - GUN_FIRST) % GUN_PERIOD == 0 then
        local phase = math.floor((gt - GUN_FIRST) / GUN_PERIOD) % 3
        if phase == 0 then
            ---ins_96 SHOOT_FAN_AIMED：count1 = count2 = 1 → 一发自机狙
            ---（angle = angleToPlayer + descriptor->angle(0)，BulletManager.cpp:118-127）。
            local aim = math.atan2(player.y - owner.y, player.x - owner.x)
            if not spawn_bullet(owner.x, owner.y, aim, GUN_AIM_SPEED, COLOR.RED) then
                return
            end
        end
        ---ins_97 SHOOT_FAN：count1 = count2 = 1 → 一发，角度 = lf0（朝圆心）。
        local inward = math.atan2(owner.lw207_center_y - owner.y,
                                  owner.lw207_center_x - owner.x)
        spawn_bullet(owner.x, owner.y, inward, GUN_IN_SPEED, COLOR.PURPLE)
    end
end

---使魔（Sub58）。占位贴图 "servant"。
---原作它有 24×24 判定、life 1200（中间那 4 只是 500）、可被击破；移植版不给判定、
---也不做击破（跟卡 218 的娃娃一个处理口径：这只是占位实现，判定交给后面的统一收敛）。
lw207_familiar = Class(object, {
    init = function(self, x, y, angle, omega, group)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        if group == 1 then
            self._r, self._g, self._b = 255, 160, 160
        elseif group == 2 then
            self._r, self._g, self._b = 180, 160, 255
        else
            self._r, self._g, self._b = 255, 235, 150
        end
        ---公转圆心 = 生成位置（= 原作 t=0 存进 xf0/xf1 的 selfX/selfY）。
        self.lw207_center_x, self.lw207_center_y = x, y
        self.lw207_angle = angle          -- 我们坐标
        self.lw207_radius = 0
        self.lw207_radial = FAM_RADIAL
        self.lw207_omega = omega
        self.lw207_omega0 = omega
        self.lw207_t = 0                  -- Sub58 的 time
    end,
    frame = function(self)
        local t = self.lw207_t
        ---① 主 context Sub58（RunEcl 先跑主 context，再跑子 context）。
        if t == FAM_HOVER_FRAME then
            ---ins_74(3600, 0, 0)：公转角速度和径向速度都归零（同时把 duration 续成 3600）
            self.lw207_omega, self.lw207_radial = 0, 0
        elseif t == FAM_SLOW_FRAME then
            ---ins_74(3600, lf1/16, 0)：lf1 在 t=40 已经被 `ins_18(lf1, 16)` 除过 16
            self.lw207_omega = self.lw207_omega0 / FAM_SLOW_DIV
        elseif t >= FAM_END_FRAME then
            ---ins_1 TERMINATE → 敌机消失
            object.RawDel(self)
            return
        end
        ---② 子 context Sub59（枪）：t=40 才挂上，它自己的 time 从 0 起算；
        ---   用的是**上一帧末**的位置
        if t >= FAM_HOVER_FRAME then
            gun_step(self, t - FAM_HOVER_FRAME)
        end
        ---③ ORBIT 位移（EnemyManager.cpp:36-58）：orbitAngle += ω、orbitRadius += radial、
        ---   position = 圆心 + polar(angle, radius)
        self.lw207_angle = self.lw207_angle + self.lw207_omega
        if self.lw207_angle > PI then
            self.lw207_angle = self.lw207_angle - 2 * PI
        elseif self.lw207_angle < -PI then
            self.lw207_angle = self.lw207_angle + 2 * PI
        end
        self.lw207_radius = self.lw207_radius + self.lw207_radial
        self.x = self.lw207_center_x + math.cos(self.lw207_angle) * self.lw207_radius
        self.y = self.lw207_center_y + math.sin(self.lw207_angle) * self.lw207_radius
        self.rot = -self.lw207_angle * RAD   -- 观感近似：朝向自己所在的方向
        self.lw207_t = t + 1
    end,
})

---BOSS 的激光（Sub57 的 ins_114 = CREATE_LASER）。原作这段激光是**静止**的：
---speed = 0 → endOffset 一直 640、startOffset 一直 0，判定盒就是「从生成点沿 angle
---长 640、宽 12」的矩形（Player::CalcLaserHitbox 里是 `position ± size/2`、
---size[0] = endOffset − startOffset、size[1] = width/2，Player.cpp:396-424）。
---状态机照抄 BulletManager.cpp:1049-1150：
---  STARTING（startTime 帧）：startTime > 30 时前 (startTime−30) 帧画 1.2px 细线、
---    最后 30 帧按 timer·width/startTime 变粗；判定要 timer >= hitboxStartTime；
---    timer 到 startTime → 转 ACTIVE、timer 归零、宽度取满。
---  ACTIVE（duration 帧）：满宽、每帧判定。
---  DESPAWNING（despawnDuration 帧）：宽度线性收到 0，判定留到 hitboxEndDelay。
lw207_laser = Class(laser, {
    init = function(self, x, y, angle, color, start_time)
        ---laser:init(index, x, y, rot, l1, l2, l3, w, node, head)（THlib/laser/laser.lua:35）
        ---l1/l2/l3 = 尾/身/头三段长度；这里只要一段 640 的身部。
        laser.init(self, color, x, y, angle, 0, LASER_LENGTH, 0, 1.2, 0, 0)
        self.lw207_state = 1
        self.lw207_timer = 0
        self.lw207_start_time = start_time
        self.alpha = 1
        self.colli = false        -- STARTING 段的判定要 hitboxStartTime 之后才开
    end,
    frame = function(self)
        local t = self.lw207_timer
        if self.lw207_state == 1 then
            local ramp = self.lw207_start_time > LASER_RAMP and LASER_RAMP
                    or self.lw207_start_time
            if self.lw207_start_time - ramp < t then
                self.w = t * LASER_WIDTH / self.lw207_start_time
            else
                self.w = 1.2
            end
            self.colli = t >= LASER_HITBOX_START
            if t >= self.lw207_start_time then
                ---原作这里不 break，直接落到 ACTIVE 那一支
                self.lw207_state = 2
                self.lw207_timer = 0
                t = 0
            end
        end
        if self.lw207_state == 2 then
            self.w = LASER_WIDTH
            self.colli = true
            if t >= LASER_DURATION then
                self.lw207_state = 3
                self.lw207_timer = 0
                t = 0
            end
        end
        if self.lw207_state == 3 then
            self.w = LASER_WIDTH - t * LASER_WIDTH / LASER_DESPAWN
            self.colli = t < LASER_HITBOX_DELAY
            if t >= LASER_DESPAWN then
                object.RawDel(self)
                return
            end
        end
        self.lw207_timer = t + 1
        laser.frame(self)
    end,
})

---Sub57 的一帧。lt = 子 context 的 time（挂上那一帧 = 0）。
---ins_4(120, −444) 会把 time 直接拨回 120、**同一帧**接着跑 t=120 的头，
---所以这里读到 322 就先把 lt 归到 120 再执行。
local function laser_step(owner, lt)
    if lt == LASER_WRAP then
        lt = LASER_FIRST
    end
    if lt == LASER_FIRST then
        ---t=120 的头：li0 = 190、lf0 = AIM_TO_PL − π/2（FLOAT_SUB 是 op1 − op2，
        ---EclRunLow.inl:301-307；AIM_TO_PL 是「从 BOSS 指向自机」的角）
        owner.lw207_lf0 = aim_to_player_th08(owner) - PI / 2
        owner.lw207_li0 = LASER_START0
    end
    ---块 1：t=120..179，每帧一发，角度每帧 −6°、起始延迟每帧 −2。
    ---（t=179 那一帧打完结 1 的第 60 发之后，会同帧接着跑块 2 的头。）
    if lt >= LASER_FIRST and lt < LASER_FIRST + LASER_COUNT then
        New(lw207_laser, owner.x, owner.y, -owner.lw207_lf0, LASER_COLOR1, owner.lw207_li0)
        owner.lw207_lf0 = owner.lw207_lf0 - LASER_STEP
        owner.lw207_li0 = owner.lw207_li0 + LASER_START_STEP
    end
    ---块 2：t=179..238，与块 1 共享 t=179 那一帧（FLOAT_ADD_ASSIGN lf0 += 183°）
    if lt >= LASER_FIRST + LASER_COUNT - 1 and lt < LASER_FIRST + 2 * LASER_COUNT - 1 then
        if lt == LASER_FIRST + LASER_COUNT - 1 then
            owner.lw207_lf0 = owner.lw207_lf0 + LASER_TURN
            owner.lw207_li0 = LASER_START0
        end
        New(lw207_laser, owner.x, owner.y, -owner.lw207_lf0, LASER_COLOR2, owner.lw207_li0)
        owner.lw207_lf0 = owner.lw207_lf0 + LASER_STEP
        owner.lw207_li0 = owner.lw207_li0 + LASER_START_STEP
    end
    return lt + 1
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）。
---ins_64 的缓动 4 = OUT_QUADRATIC = 1−(1−u)²。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---Sub56 每帧（RunEcl 主 context → 子 context，然后才是 UpdateMovement）。
local function boss_frame(owner)
    ---★ card.before 阶段 frame 先跑（tools/check_stage.lua 也照抄了这个顺序），
    ---  那几帧 lw207_t 还是 nil；卡 205/206/218 同款守卫。
    if not owner.lw207_t then return end
    local f = owner.lw207_t
    if f == SPAWN_FRAME then
        ---ins_90 ×10（绝对坐标 → 换算成我们的） + ins_135(0, 57)
        for i = 1, #FAMILIARS do
            local e = FAMILIARS[i]
            familiars[#familiars + 1] = New(lw207_familiar, e[1], e[2], e[3], e[4], e[5])
        end
        owner.lw207_laser_t = 0
    end
    if owner.lw207_laser_t then
        owner.lw207_laser_t = laser_step(owner, owner.lw207_laser_t)
    end
    local move = owner.lw207_move
    if move then
        local x, y, done = move_step(move)
        owner.x, owner.y = x, y
        if done then
            owner.lw207_move = nil
        end
    end
    owner.lw207_t = f + 1
end

local function card_init(owner)
    owner.lw207_t = 0
    owner.lw207_laser_t = nil       -- 挂上 Sub57 的那一帧才是 0
    owner.lw207_lf0, owner.lw207_li0 = 0, LASER_START0
    owner.lw207_move = {
        x0 = owner.x, y0 = owner.y,
        dx = BOSS_END_X - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0,
    }
    ---原作 Sub56 t=0 还有一堆关射击、关判定、登记符卡、清场的指令
    ---（ins_105/95/113/80/110/134/153/132/122）—— 都由 boss 系统与 lw_before 管，不另写。
end

local function card_del(owner)
    ---★ 必须把帧计数器一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑，
    ---  留着 lw207_t 它会继续按周期出激光（卡 205/206 都踩过同款坑）。
    owner.lw207_t = nil
    owner.lw207_laser_t = nil
    owner.lw207_move = nil
    for i = #familiars, 1, -1 do
        if IsValid(familiars[i]) then
            object.RawDel(familiars[i])
        end
        familiars[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
    pool = {}
end

CARD[207] = {
    init = function(owner)
        familiars = {}
        pool = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 208「幻胧月睨」（铃仙·优昙华院·因幡）
---  ecldata5sp.ecl：Sub40 = BOSS 根、Sub38 = BOSS 的子 context 0（月亮 + 红光）、
---  Sub39 = 月亮本体、Sub42 = 使魔、Sub41 = 使魔的枪（挂在使魔的子 context 0 上）。
---
---  · Sub40 是个 180 帧的循环：t=290 的 `ins_4(110, −1032)` 把 time 拨回 t=110，
---    落点 = 裸字节 21892 − 1032 = 20860 = `ins_7(lf0, RANDOM_ANGLE)` 那条（复核过），
---    所以每个周期的动作是：
---      +0   t=110  一发 144 发的大圆环（速度 5.0、掩码 0x100200）
---      +30  t=140  两组掩码各推进一次相位（lf1 = 0.1）+ `ins_135(0, 38)` 重建子 context
---      +120 t=230  两组各推一次
---      +150 t=260  两组各推一次
---      +160 t=270  两发 44×2 的小圆环（速度 5.4→2.8、色 2、两掩码，第二发基准角 +3.75°）
---      +170 t=280  两发 44×2 的小圆环（速度 5.2→2.6、色 6）→ ins_67 乱走 → 24 只使魔
---      +180 t=290  跳回 +0
---    （那 4 条难度掩码的 `ins_6(li7, …)` 紧跟在跳转落点**后面**，所以每个周期都会
---    把 li7 重写成 144 —— 不是「只有第一轮是 144」。）
---  · 相位机 = ex 指令 14（`ins_136(14, 0)`）AdvanceReisenBulletPhase（EclExIns.cpp:669-717）。
---    它对**全池**扫一遍，把 `(transformFlags & li0) != 0` 的弹推一格（li0 就是掩码）：
---      type1 → type0：换 +16 号精灵、附加混合、alpha 归 0、关判定，速度换成
---                     `FromAngleMagnitude(bullet->angle, lf1)` —— 沿自己原朝向、速度 0.1
---      type0 → type2：alpha 从 0 线性插到 255（15 帧），仍然关判定
---      type2 → type1：换回普通精灵、开判定、速度回到弹自己的原速
---    于是每颗弹是「30 帧可见（5.0 飞）→ 90 帧隐身（0.1 爬）→ 15 帧淡入 →
---    之后每 180 帧里可见 60 帧」。两组掩码（0x100000 / 0x200000）在**同一帧**被推进
---    —— 照抄原作，不做偏置。
---  · 使魔 Sub42：`ins_65(lf0, lf1)` 直着飞（速度 4.0、无边界、无角速度），
---    朝向 = AIM_TO_PL + k·15°（0..23）；原作 life 200、判定 24×24。
---  · 枪 Sub41：t=0 三条 `ins_111` 写 transform 记录 + 一条 `ins_97`，t=10 的
---    `ins_4(0, −44)` 跳回的是**那条 ins_97**（裸字节 164 − 44 = 120，复核过），
---    所以记录只写一次、每 10 帧出一发：速度 0.6、角度恒 0.09817477（5.625°、
---    FAN 不加自机方向）、弹型 7、色 3。三条记录：
---      WAIT(180) → SET_SPRITE(7/1) → ACCELERATE_VECTOR(60 帧、每帧沿原方向 +1/30)
---    （BulletManager.cpp:311-420 记记录、:816-855 跑状态机、:1205-1228 跑加速）。
---  ★ 贴图占位：使魔 "servant"、月亮 "eyeL"、弹 ball_small。17 张全部实现完再统一换。
---  ★ 没移植的纯画面效果：Sub38 每帧的 `ins_137(13, 0)` = ex 13 ApplyRedBackgroundTint
---    （EclExIns.cpp:719-722：给**背景层**逐帧叠 0xffc03030 的乘算色，52 帧）。
---    配音效一样，等统一换素材时再补。
---------------------------------------------------------------
do
local PI = 3.141592653589793
local RAD = 57.29577951308232

---TH08 世界坐标 → 我们坐标（换算见文件头）：x' = x−192、y' = 224−y、角度整体取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---AddNormalizeAngle(a, 0)（Global.cpp:1239-1258）：归一到 [−π, π]。
local function norm(angle)
    while angle > PI do angle = angle - 2 * PI end
    while angle < -PI do angle = angle + 2 * PI end
    return angle
end

---TH08 口径的「从 BOSS 指向自机」角（ECL_OPERAND_ANGLE_TO_PLAYER =
--- Player::AngleToPoint）：atan2(pl.y − self.y, pl.x − self.x)。
---本卡凡是要跟原作算式对齐的量都保持 TH08 口径，落笔给 LuaSTG 时再取反。
local function aim_to_player_th08(owner)
    return math.atan2(to_th08_y(player.y) - to_th08_y(owner.y),
                      to_th08_x(player.x) - to_th08_x(owner.x))
end

---BOSS 根 Sub40 的节拍（全部来自 ecldata5sp.ecl Sub40 的裸字节）。
local BOSS_END_X, BOSS_END_Y = 0, 96
local BOSS_MOVE_FRAMES = 110            -- ins_64(110, 4, 192, 128)：TH08 (192,128) → 我们 (0,96)
local CYCLE_FIRST = 110                 -- ins_4 的落点 = 每个周期的第 0 帧
local CYCLE_PERIOD = 180                -- t=290 − t=110
local PHASE_S1, PHASE_S2, PHASE_S3 = 30, 120, 150
local PHASE_RING_A, PHASE_RING_B = 160, 170
local MASK_A = 0x100000                 -- BULLET_TRANSFORM_ECL_EX_TRIGGER_MARKER（BulletManager.hpp:152）
local MASK_B = 0x200000                 -- 枚举里没有名字的另一位（0x400000 才是 WRAP_X）
local SPAWN_SOUND_BIT = 0x200           -- BULLET_TRANSFORM_PLAY_SPAWN_SOUND（本卡只影响音效）
local HIDDEN_SPEED = 0.1                -- lf1（t=140 写死；三个推进点都用它）
local FADE_FRAMES = 15                  -- StartColor1AlphaInterpolation(15, ·, 0, 255)
local GHOST_BLEND = "add+alpha"         -- 原作 type0/2 是 AnmBlendMode_Additive

---圆环的弹参数（op99 = SHOOT_CIRCLE，EclManager.hpp:308）。
---  aimMode = opcode − 96 = 3 = BULLET_AIM_CIRCLE：
---    angle = i·2π/count1 + j·angleStep + angle、count2 > 1 时
---    speed_j = speed1 − (speed1−speed2)·j/count2（BulletManager.cpp:83-92、129-133）。
local RING_STEP = 0.09817477315664291    -- angleStep（2π/64 = 5.625°）
local RING_OFFSET = 0.06544985           -- 第二发圆环的基准角 +3.75°
local BIG_COUNT = 144                    -- t=110：li7 在 Lunatic 下的值
local BIG_SPEED = 5.0                    -- speed1（count2 = 1）
local SMALL_COUNT = 44                   -- t=270 / t=280 的 count1
local SMALL_A = { s1 = 5.4, s2 = 2.8, color = COLOR.RED }   -- t=270（TH08 色 2）
local SMALL_B = { s1 = 5.2, s2 = 2.6, color = COLOR.BLUE }  -- t=280（TH08 色 6）
local POOL_SIZE = 1536                   -- BulletManager.hpp:455

---ins_67(120, 0, 0.5)：120 帧走 0.5·120 = 60 px（缓动 0 = 线性）。
local WANDER_FRAMES = 120
local WANDER_SPEED = 0.5

---使魔（Sub42）与它的枪（Sub41）。
local FAM_COUNT = 24                    -- xi0 = 24 的 JUMP_DEC 循环
local FAM_SPEED = 4.0                   -- lf1
local FAM_STEP = 0.2617994              -- lf0 每轮 +15°
local EYE_X, EYE_Y = 0, -20             -- Sub39 的绝对坐标（TH08 192, 244）
local EYE_FRAMES = 60                   -- Sub39 的 ins_1
local GUN_PERIOD = 10                   -- t=10 的 ins_4(0, −44) → 每 10 帧一发
local GUN_SPEED = 0.6                   -- ins_97 的 speed1（count2 = 1）
local GUN_ANGLE = 0.09817477315664291   -- ins_97 的 angle（固定值，TH08 口径）
local GUN_COLOR = COLOR.DEEP_PURPLE     -- TH08 色 3
local GUN_WAIT = 180                    -- 记录 0 WAIT 的帧数
local GUN_ACCEL_FRAMES = 60             -- 记录 2 的 durationFrames
local GUN_ACCEL = 0.03333333507180214   -- 记录 2 的 magnitude（1/30）
---ins_97 的 transformFlags = 147984 = 0x24210（WAIT|SET_SPRITE|PLAY_SPAWN_SOUND|
---ACCELERATE_VECTOR）。相位机按 `transformFlags & li0` 挑弹，这几位跟两个掩码都不沾
---（0x24210 & 0x100000 = 0），所以枪弹不会被相位机推走 —— 照抄。
local GUN_FLAGS = 0x24210

---本卡自己的弹池（= 原作那 1536 个弹槽）与使魔 / 月亮登记表。
local pool = {}
local familiars = {}
local eyes = {}

local function in_bound(unit)
    return IsValid(unit)
            and unit.x >= lstg.world.boundl and unit.x <= lstg.world.boundr
            and unit.y >= lstg.world.boundb and unit.y <= lstg.world.boundt
end

local function pool_used()
    for i = #pool, 1, -1 do
        if not in_bound(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

local lw208_bullet

---本卡的圆环弹。掩码位只用来分组，运动全部自己算（vx/vy 交给引擎积分，同卡 218/207）。
---相位改速度的口径照 EclExIns.cpp:669-717：type1→0 用 lf1 沿**当前朝向**，
---type2→1 用弹自己的 speed。
lw208_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color, mask)
        bullet.init(self, ball_small, color, false, true)
        self.lw208_angle = angle           -- 我们坐标
        self.lw208_speed = speed           -- 原速（type2→1 时回到它）
        self.lw208_flags = mask            -- = 原作的 transformFlags 字
        self.lw208_type = 1                -- 1 可见 / 0 隐身 / 2 淡入
        self.lw208_fade = 0
        self.vx = math.cos(angle) * speed
        self.vy = math.sin(angle) * speed
    end,
    frame = function(self)
        ---type0 → type2 之后的淡入：15 帧线性 0 → 255（原作是 ANM 的
        ---StartColor1AlphaInterpolation，判定仍然关着）。
        if self.lw208_type == 2 and self.lw208_fade < FADE_FRAMES then
            self.lw208_fade = self.lw208_fade + 1
            local a = math.floor(self.lw208_fade * 255 / FADE_FRAMES)
            if a > 255 then a = 255 end
            self._a = a
        end
        bullet.frame(self)
    end,
})

---一次圆环出弹（SpawnBulletPattern：BulletManager.cpp:685-712）。
---池满（activeBulletCount >= 0x600）→ **整波不生**；波中间生不出来就放弃整波剩下的。
---base 是 TH08 口径的基准角（= RANDOM_ANGLE 或它 +3.75°）。
local function fire_ring(owner, count1, count2, s1, s2, color, mask, base)
    local used = pool_used()
    for j = 0, count2 - 1 do
        local speed = s1
        if count2 > 1 then
            speed = s1 - (s1 - s2) * j / count2
        end
        for i = 0, count1 - 1 do
            if used >= POOL_SIZE then return end
            local th08 = base + i * 2 * PI / count1 + j * RING_STEP
            pool[#pool + 1] = New(lw208_bullet, owner.x, owner.y, -th08, speed,
                    color, mask + SPAWN_SOUND_BIT)
            used = used + 1
        end
    end
end

---推进一格相位（EclExIns.cpp:669-717 的三分支）。原作扫的是**全 1536 个槽**，
---只按 `(transformFlags & li0) != 0` 挑；移植版扫本卡自己的登记表，判据等价。
local function advance_phase(mask)
    for i = 1, #pool do
        local b = pool[i]
        if IsValid(b) and (b.lw208_flags & mask) ~= 0 then
            if b.lw208_type == 1 then
                ---type1 → type0：换 +16 号精灵（占位贴图看不出差别）、附加混合、
                ---alpha 归 0、关判定、速度 = 沿当前朝向的 lf1
                b.lw208_type = 0
                b._blend = GHOST_BLEND
                b._a = 0
                b.colli = false
                b.vx = math.cos(b.lw208_angle) * HIDDEN_SPEED
                b.vy = math.sin(b.lw208_angle) * HIDDEN_SPEED
            elseif b.lw208_type == 0 then
                ---type0 → type2：alpha 从 0 开始插值（判定还关着）
                b.lw208_type = 2
                b.lw208_fade = 0
                b._a = 0
            else
                ---type2 → type1：换回普通精灵、开判定、速度回原速
                b.lw208_type = 1
                b._blend = ""
                b._a = 255
                b.colli = true
                b.vx = math.cos(b.lw208_angle) * b.lw208_speed
                b.vy = math.sin(b.lw208_angle) * b.lw208_speed
            end
        end
    end
end

local lw208_familiar
local lw208_eye

---使魔枪弹（Sub41 的 ins_97：弹型 7、色 3、flags = 0x24210）。
---三条 transform 记录（t=0 的三条 ins_111）：
---  · WAIT(180)：激活后 activeTransformFlags ≠ 0 → AdvanceTransformProgram 立刻返回
---    （BulletManager.cpp:313-316），所以后两条要等它走完
---  · SET_SPRITE(7/1)：占位实现保持同一张贴图（换素材时再区分）
---  · ACCELERATE_VECTOR(60 帧, magnitude 1/30, angle −999 → 取弹自己的 angle)：
---    之后 60 帧每帧 velocity += 沿该角的 1/30，angle 跟着重算（:1205-1228）
local lw208_gun_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color)
        bullet.init(self, ball_small, color, false, true)
        self.lw208_angle = angle
        self.lw208_flags = GUN_FLAGS
        self.vx = math.cos(angle) * speed
        self.vy = math.sin(angle) * speed
        ---记录 0 在出生那一刻就激活（SpawnSingleBullet 末尾会调一次
        ---AdvanceTransformProgram，BulletManager.cpp:233）
        self.lw208_wait = GUN_WAIT
        self.lw208_accel = false
        self.lw208_accel_timer = 0
        self.lw208_accel_vx = 0
        self.lw208_accel_vy = 0
    end,
    frame = function(self)
        if self.lw208_wait > 0 then
            self.lw208_wait = self.lw208_wait - 1
        elseif not self.lw208_accel then
            ---WAIT 归零那一帧不会立刻接上下一条：AdvanceTransformProgram 在每帧最前面跑，
            ---清位发生在同一帧的后面（:848-854），所以加速要等下一帧。
            self.lw208_accel = true
            self.lw208_accel_vx = math.cos(self.lw208_angle) * GUN_ACCEL
            self.lw208_accel_vy = math.sin(self.lw208_angle) * GUN_ACCEL
        elseif self.lw208_accel_timer < GUN_ACCEL_FRAMES then
            self.vx = self.vx + self.lw208_accel_vx
            self.vy = self.vy + self.lw208_accel_vy
            if math.abs(self.vx) > 0.0001 or math.abs(self.vy) > 0.0001 then
                self.lw208_angle = math.atan2(self.vy, self.vx)
            end
            self.lw208_accel_timer = self.lw208_accel_timer + 1
        end
        bullet.frame(self)
    end,
})

local function fire_gun(owner)
    pool[#pool + 1] = New(lw208_gun_bullet, owner.x, owner.y, -GUN_ANGLE, GUN_SPEED, GUN_COLOR)
end

---使魔（Sub42）。24 只一批，朝向 = AIM_TO_PL + k·15°、速度 4.0（ins_65）。
---占位贴图 "servant"；原作 life 200、判定 24×24，移植版不给判定
---（跟卡 218 的娃娃、卡 207 的使魔同一个口径）。飞出场地就回收（EnemyManagerUpdate.cpp:240-262）。
lw208_familiar = Class(object, {
    init = function(self, x, y, angle)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.75, 0.75
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        self._r, self._g, self._b = 255, 160, 255
        ---ins_65(lf0, lf1)：ENEMY_MOVEMENT_MODE_POLAR、无角速度 / 加速度 / 时长
        self.vx = math.cos(angle) * FAM_SPEED
        self.vy = math.sin(angle) * FAM_SPEED
        self.lw208_t = 0
    end,
    frame = function(self)
        local t = self.lw208_t
        ---枪 Sub41：挂上的那一帧（t=0）就出第一发，之后每 10 帧一发
        if t % GUN_PERIOD == 0 then
            fire_gun(self)
        end
        self.rot = -math.atan2(self.vy, self.vx) * RAD   -- 观感近似：朝自己飞的方向
        self.lw208_t = t + 1
        if not in_bound(self) then
            object.RawDel(self)
        end
    end,
})

---Sub39 的「月亮」：Sub38 的 t=0 用 `ins_93(39, xf0, xf1, 0, 10, −2, 10)` 生成，
---绝对坐标 TH08 (192, 244) = 我们 (0, −20)，`ins_1` 在 t=60 收掉。占位贴图 "eyeL"。
lw208_eye = Class(object, {
    init = function(self, x, y)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "eyeL"
        self.hscale, self.vscale = 2, 2
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        self._r, self._g, self._b = 255, 255, 255
        self.lw208_t = 0
    end,
    frame = function(self)
        self.lw208_t = self.lw208_t + 1
        if self.lw208_t > EYE_FRAMES then
            object.RawDel(self)
        end
    end,
})

---24 只使魔（Sub40 t=280 的 JUMP_DEC 循环：`ins_91(42, 0, 0, 200, −2, 100)` 24 次）。
---循环体是「先 ins_91 再 lf0 += 15° 再 NORMALIZE_ANGLE」，所以第一只取 AIM_TO_PL、
---第 24 只取 AIM_TO_PL + 345°（都在 TH08 口径下；给 LuaSTG 时取反）。
local function spawn_familiars(owner)
    local angle = aim_to_player_th08(owner)
    for _ = 1, FAM_COUNT do
        familiars[#familiars + 1] = New(lw208_familiar, owner.x, owner.y, -angle)
        angle = norm(angle + FAM_STEP)
    end
end

---插值位移的一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支）：
---movementTimer-- → progress = 1 − timer/duration → 套缓动 → position = origin + delta·progress；
---timer 归 0 那一帧直接落在终点。ins_64 的缓动 4 = OUT_QUADRATIC、ins_67 的 0 = LINEAR。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = u
    if move.easing == 4 then
        e = 1 - (1 - u) * (1 - u)
    end
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:160-235）。
---movementBounds 本卡从没设过（没有 ins_75），所以四条边界判据都是拿 (0,0,0,0) 比 ——
---跟卡 218 一模一样的怪癖，照抄：`x < 96` 偶尔真、`x > −96` 恒真（于是会拿
---**上一段的 movementAngle** 改写角度）、`y < 48` 假、`y > −48` 恒真。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = ran:Float(0, PI / 2) + 3 * PI / 4
    else
        angle = ran:Float(0, PI / 2) - PI / 4
    end
    if bx < 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > -96 then
        if angle < PI / 2 and angle >= 0 then
            angle = PI - owner.lw208_movement_angle
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < 48 and angle < 0 then
        angle = -angle
    end
    if by > -48 and angle > 0 then
        angle = -angle
    end
    return angle
end

---StartTimedPolarDisplacement（EclDependencies.cpp:106-126）：ins_67 的 operand0 = 120 > 0，
---所以是「120 帧走完 (cos,sin)(angle)·0.5·120 px」的插值，不是匀速极坐标。
local function begin_wander(owner)
    local angle = wander_angle(owner)
    owner.lw208_movement_angle = angle
    owner.lw208_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * WANDER_FRAMES,
        dy = math.sin(-angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0, easing = 0,
    }
end

---Sub40 每帧（原作 RunEcl 主 context → 子 context，然后才是 UpdateMovement，:159-192）。
local function boss_frame(owner)
    ---★ card.before 阶段 frame 先跑（tools/check_stage.lua 也照抄了这个顺序），
    ---  那几帧 lw208_t 还是 nil；卡 205/206/207/218 同款守卫。
    if not owner.lw208_t then return end
    local f = owner.lw208_t
    if f >= CYCLE_FIRST then
        local ph = (f - CYCLE_FIRST) % CYCLE_PERIOD
        if ph == 0 then
            ---t=110：`ins_7(lf0, RANDOM_ANGLE)` + 难度掩码写 li7 = 144 + 大圆环
            fire_ring(owner, BIG_COUNT, 1, BIG_SPEED, BIG_SPEED, COLOR.RED, MASK_A,
                    ran:Float(-PI, PI))
        elseif ph == PHASE_S1 then
            ---t=140：lf1 = 0.1；li0 = 0x100000 推一次、li0 = 0x200000 再推一次；
            ---然后 `ins_135(0, 38)` 重建子 context 0（月亮 + 红光）
            advance_phase(MASK_A)
            advance_phase(MASK_B)
            eyes[#eyes + 1] = New(lw208_eye, EYE_X, EYE_Y)
        elseif ph == PHASE_S2 or ph == PHASE_S3 then
            ---t=230 / t=260：两组各推一次（t=260 那条还写了 li1 = 1，ex14 不读它）
            advance_phase(MASK_A)
            advance_phase(MASK_B)
        elseif ph == PHASE_RING_A then
            ---t=270：lf0 = RANDOM_ANGLE、li7 = 44，两发 44×2（第二发基准角 +3.75°）
            local base = ran:Float(-PI, PI)
            fire_ring(owner, SMALL_COUNT, 2, SMALL_A.s1, SMALL_A.s2, SMALL_A.color,
                    MASK_A, base)
            fire_ring(owner, SMALL_COUNT, 2, SMALL_A.s1, SMALL_A.s2, SMALL_A.color,
                    MASK_B, base + RING_OFFSET)
        elseif ph == PHASE_RING_B then
            ---t=280：同上，色 6 + 速度更低；尾部还有 ins_67 乱走 + 24 只使魔
            local base = ran:Float(-PI, PI)
            fire_ring(owner, SMALL_COUNT, 2, SMALL_B.s1, SMALL_B.s2, SMALL_B.color,
                    MASK_A, base)
            fire_ring(owner, SMALL_COUNT, 2, SMALL_B.s1, SMALL_B.s2, SMALL_B.color,
                    MASK_B, base + RING_OFFSET)
            begin_wander(owner)
            spawn_familiars(owner)
        end
    end
    local move = owner.lw208_move
    if move then
        local x, y, done = move_step(move)
        owner.x, owner.y = x, y
        if done then
            owner.lw208_move = nil
        end
    end
    owner.lw208_t = f + 1
end

local function card_init(owner)
    owner.lw208_t = 0
    ---上一段（从出生点插值进场）的方向：TH08 口径的 π/2 = 朝下 = 我们坐标朝上。
    ---BeginBoundaryAwareMove 的 `bx > −96` 那条会拿它改写角度。
    owner.lw208_movement_angle = PI / 2
    ---ins_64(110, 4, 192, 128)：从出生点插值到 (0,96)，缓动 4 = OUT_QUADRATIC
    owner.lw208_move = {
        x0 = owner.x, y0 = owner.y,
        dx = BOSS_END_X - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0, easing = 4,
    }
    ---原作 Sub40 t=0 还有一堆关射击、关判定、登记符卡、清场的指令
    ---（ins_105/95/113/80/110/134/153/132/122）—— 都由 boss 系统与 lw_before 管，不另写。
end

local function card_del(owner)
    ---★ 必须把帧计数器一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑，
    ---  留着 lw208_t 它会继续按周期出弹（卡 205/206/207 都踩过同款坑）。
    owner.lw208_t = nil
    owner.lw208_move = nil
    for i = #familiars, 1, -1 do
        if IsValid(familiars[i]) then
            object.RawDel(familiars[i])
        end
        familiars[i] = nil
    end
    for i = #eyes, 1, -1 do
        if IsValid(eyes[i]) then
            object.RawDel(eyes[i])
        end
        eyes[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[208] = {
    init = function(owner)
        pool = {}
        familiars = {}
        eyes = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end

---------------------------------------------------------------
---卡 209「天网蛛网捕蝶之法」（八意永琳）
---  ecldata6sp.ecl：Sub76 = BOSS 根、Sub79 = 蛛网节点（敌机）。整张卡只有这两个子程序。
---
---  · Sub76（根）：110 帧插值入场到 TH08 (192,128) = 我们 (0,96)；之后每 240 帧一轮：
---      t=110  `ins_7(lf0, AIM_TO_PL)` 记下「从 BOSS 指向自机」的角、`xi0 = 0`、
---             `lf7 = rndUnit·(−π/8) + 2π/5`（rndUnit ∈ [0,1) → lf7 ∈ (50°, 72°]）、
---             再 `ins_94(79, 0,0,0, 10, −2, 10)` 在**当前位置**生成一个蛛网节点；
---      t=290  `ins_67(60, 4, 1.0)` = MOVE_RANDOM_IN_BOUNDS；
---      t=350  `ins_4(110, −180)` 跳回 t=110 的头 —— 周期 240 帧，节拍是「先出网、后乱走」。
---      ★ lf7 整棵树**共用**（子节点不重抽），所以每一轮只有一个随机偏角。
---  · Sub79（蛛网节点）：不可见（`ins_80(8)` NO_SPRITE）+ 允许出屏（`ins_80(16)`）。
---      t=0    `ins_114` CREATE_LASER：从自己的位置朝 lf0 生成一条**静止**光柱。
---      t=0,2,…12 每 2 帧一发 `ins_99` SHOOT_CIRCLE（xi1 = 7 的 JUMP_DEC 循环）。
---      t=0    `ins_64(14, 0, selfX + 70·cos(lf0), selfY + 70·sin(lf0))`：14 帧沿 lf0 走 70 px。
---      t=12   `xi0++`；`xi0 < 8` 就 `lf0 = lf1 ± lf7`（lf1 = 本节点的 lf0）生成 2 个子节点
---             ——子节点**继承整块变量**（含 lf7 / li5，EnemyTimeline.cpp:64-108 的
---             EnemyContextCopy 0x78 字节 = int + float 变量块）——且生成在**父节点当前位置**，
---             父节点这时已走完 12/14 步 = 60 px，所以每条枝长 60 px；
---             `xi0 >= 8` 就直接 `ins_1` TERMINATE。树深 8 代、每代翻倍：
---             1+2+…+256 = **511 个节点**，最深那 256 个只活 12 帧。
---      t=102  `li5 >= 1`（第 2 轮起的网）时补一发 `ins_99`(3, 6, 1, 1, 1, 1, π/2, 0, 514)
---             → 朝**正下方**（TH08 π/2）、速度 1、transformFlags 514 = 0x202（SPAWN_FAST），
---             然后 TERMINATE。第 1 轮的网 li5 = 0，那一帧直接跳去 TERMINATE（只活 12 帧）。
---  · 光柱参数（ins_114 的裸字节）：bulletType 0、color li7 = 6、speed 0、startOffset 0、
---    endOffset 600、startLength 600、width 10、startTime 110、duration 50、despawnDuration 20、
---    hitboxStartTime 110、hitboxEndDelay 20、transformFlags 4（SPAWN_NORMAL）。
---    判定盒 = 「从生成点沿 angle 长 600、高 width/2 = 5」的矩形：Player::CalcLaserHitbox
---    拿 `position ± size/2` 比，size[0] = endOffset − startOffset、size[1] = width/2
---    （Player.cpp:396-424）→ 半宽 2.5。★ 所以给 THlib 的 laser 类要填 w = width/2 = 5
---    （laser:frame 的判定是 `dy < self.w / 2`，THlib/laser/laser.lua:91）——
---    填 10 的话判定会宽一倍。
---    状态机照抄 BulletManager.cpp:1049-1150：STARTING 的 110 帧里前 80 帧只画 1.2 px 细线、
---    最后 30 帧按 timer·width/startTime 变粗，`timer >= hitboxStartTime` 才有判定 ——
---    本卡 hitboxStartTime == startTime == 110，所以**从第 110 帧起**才成实体；ACTIVE 50 帧满宽
---    判定；之后 DESPAWNING 20 帧。★ 消散段原作把 laserSize[0]（= 判定盒的**长度**）
---    改写成 currentWidth/2，而盒心还钉在 position + 300 —— 于是那 20 帧的判定只剩
---    「光柱中点附近一个 5 px 的小方块」，等于没有；移植版据此在消散段关掉判定，
---    只保留宽度收细的观感（照抄反而更不忠实）。
---  · 同屏上限：光柱槽只有 256 个（`Laser lasers[0x100]`，BulletManager.hpp:313-339），
---    SpawnLaserPattern（BulletManager.cpp:712-760）只是**从头找第一个空槽**，槽满就整发不生成。
---    节点按代生成、每代相隔 12 帧 → 第 1..8 代的 255 条光柱都拿得到槽，第 9 代只有第 1 条
---    拿得到，其余全被丢掉。移植版照抄这个「先到先得」。
---  ★ 敌机槽（480 个，EnemyManagerUpdate.cpp:119）没有移植：LuaSTG 没有敌机池，而被丢掉的
---    那 31 个节点本来也抢不到光柱槽（对蛛网形状零影响），只差它们第 102 帧那一发慢弹。
---  ★ 火花：`ins_111(0, 0x40000, …)` 把 0 号 transform 记录写成 DESPAWN，配上
---    transformFlags 0x40204 → 出生当帧 `AdvanceTransformProgram` 就把 state 打到
---    DESPAWNING（BulletManager.cpp:310-323、432-434）→ **纯观感、永远不伤人**，
---    播完 etama.anm script 16（12 帧）就消失。它们照旧占 1536 个弹槽
---    （BulletManager.hpp:455；整波生不出来就丢掉，BulletManager.cpp:686-712）。
---  ★ 贴图占位：节点不可见（原作就是 NO_SPRITE）、光柱用 THlib 的 laser 类、
---    火花与慢弹用 ball_small（TH08 色号 6 → 我们的 7 号色）。最后统一换素材。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---TH08 世界坐标 → 我们坐标（换算见文件头）：x' = x−192、y' = 224−y、角度整体取反。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---根 Sub76 的节拍。
local CYCLE_FIRST = 110                 -- ins_4 的落点 = 每个周期的第 0 帧
local CYCLE_PERIOD = 240                -- t=290 + 60 帧 → t=350 跳回 t=110
local WANDER_PHASE = 180                -- t=290 − t=110
local BOSS_END_X, BOSS_END_Y = 0, 96    -- ins_64(110, 4, 192, 128)
local BOSS_MOVE_FRAMES = 110
local WANDER_FRAMES = 60                -- ins_67(60, 4, 1.0)
local WANDER_SPEED = 1.0
local BRANCH_BASE = 1.2566371           -- lf7 的常量项 = 2π/5 = 72°
local BRANCH_JITTER = 0.3926991         -- lf7 的随机系数 = π/8 = 22.5°

---蛛网节点 Sub79 的节拍。
local WEB_DEPTH_MAX = 8                 -- ins_44(xi0, 8, …)
local WEB_SPARKS = 7                    -- xi1 = 7 的 JUMP_DEC 循环
local SPARK_INTERVAL = 2                -- 那条 JUMP_DEC 的 time = 2
local CHILD_FRAME = 12                  -- 7 发火花走完那一帧（0,2,…,12）
local MOVE_FRAMES = 14                  -- ins_64(14, 0, …)
local MOVE_DIST = 70
local EXTRA_FRAME = 102                 -- 子节点生成后 context time 到 92 → 本节点第 102 帧
local EXTRA_SPEED = 1.0                 -- ins_99 的 speed1
local EXTRA_ANGLE = -PI / 2             -- TH08 π/2 = 朝下 → 我们也是 −π/2
local SPARK_SPEED = 0.1                 -- 火花的 speed1
local SPARK_LIFE = 12                   -- etama.anm script 16 = 12 帧
local SPAWN_FAST_FRAMES = 10            -- etama.anm script 21 = 10 帧

---光柱（ins_114 CREATE_LASER）。
local LASER_LEN = 600                   -- endOffset − startOffset
local LASER_W = 5                       -- THlib 的 w：判定半宽 = w/2 = 2.5
local LASER_W0 = 1.2                    -- STARTING 段的细线宽度（BulletManager.cpp:1081）
local LASER_START_TIME = 110
local LASER_RAMP = 30
local LASER_DURATION = 50
local LASER_DESPAWN = 20
local LASER_SLOTS = 256                 -- `Laser lasers[0x100]`（BulletManager.hpp:313-339）
local POOL_SIZE = 1536                  -- `Bullet bullets[0x601]`（BulletManager.hpp:455）
local COLOR209 = COLOR.ROYAL_BLUE       -- TH08 色号 6 → 我们的 7 号色

---本卡的弹池（= 原作 1536 个弹槽）与光柱槽（= 原作 256 个激光槽）。
local pool = {}
local lasers = {}
---蛛网节点登记表（原作那 480 个敌机槽里被本卡占用的部分）。
local webs = {}

local function in_bound(unit)
    return IsValid(unit)
            and unit.x >= lstg.world.boundl and unit.x <= lstg.world.boundr
            and unit.y >= lstg.world.boundb and unit.y <= lstg.world.boundt
end

local function pool_used()
    for i = #pool, 1, -1 do
        if not in_bound(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

local function laser_used()
    for i = #lasers, 1, -1 do
        if not IsValid(lasers[i]) then
            table.remove(lasers, i)
        end
    end
    return #lasers
end

local lw209_spark
local lw209_bullet
local lw209_laser
local lw209_web

---火花（Sub79 t=0..12 的 7 发 ins_99）。出生当帧就在 DESPAWNING（见头部注释），
---每帧 `position += velocity/2`（BulletManager.cpp:1005-1013），12 帧后消失，判定全程关着。
---是 `object` 而不是 `bullet`：它永远打不到自机，也不该进 tools 的威胁统计。
lw209_spark = Class(object, {
    init = function(self, x, y, angle)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY_BULLET
        self.img = "ball_small7"
        self.hscale, self.vscale = 0.5, 0.5
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 255
        self.lw209_vx = math.cos(angle) * SPARK_SPEED
        self.lw209_vy = math.sin(angle) * SPARK_SPEED
        self.lw209_life = SPARK_LIFE
    end,
    render = function() end,
    frame = function(self)
        self.x = self.x + self.lw209_vx / 2
        self.y = self.y + self.lw209_vy / 2
        self.lw209_life = self.lw209_life - 1
        if self.lw209_life <= 0 then
            object.RawDel(self)
        end
    end,
})

---Sub79 t=102 的那发慢弹。transformFlags = 514 = 0x202（SPAWN_FAST|PLAY_SPAWN_SOUND）：
---出生瞬间先把位置往回退 velocity·4，之后每帧只走 velocity/2，动画（10 帧）播完那一帧
---才转 FIRED、补一次完整速度（BulletManager.cpp:936-945 的 BULLET_STATE_SPAWNING_FAST）。
---出生动画期间**没有判定**（判定在 FIRED 分支里），所以 colli 要到那时才开。
lw209_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed)
        bullet.init(self, ball_small, COLOR209, false, true)
        self.lw209_angle = angle
        self.lw209_speed = speed
        self.lw209_vx = math.cos(angle) * speed
        self.lw209_vy = math.sin(angle) * speed
        self.x = x - self.lw209_vx * 4
        self.y = y - self.lw209_vy * 4
        self.vx, self.vy = self.lw209_vx / 2, self.lw209_vy / 2
        self.lw209_spawn = SPAWN_FAST_FRAMES
        self.colli = false
    end,
    frame = function(self)
        if self.lw209_spawn > 0 then
            self.lw209_spawn = self.lw209_spawn - 1
            if self.lw209_spawn == 0 then
                self.vx, self.vy = self.lw209_vx, self.lw209_vy
                self.colli = true
            end
        end
        bullet.frame(self)
    end,
})

---光柱（ins_114）。状态机见头部注释；`alpha = 1` 是 THlib laser:frame 开判定的条件。
lw209_laser = Class(laser, {
    init = function(self, x, y, angle)
        ---laser:init(index, x, y, rot, l1, l2, l3, w, node, head)（THlib/laser/laser.lua:35）
        ---l1/l2/l3 = 尾/身/头三段长度；这里只要一段 600 的身部。
        laser.init(self, COLOR209, x, y, angle, 0, LASER_LEN, 0, LASER_W0, 0, 0)
        self.lw209_state = 1
        self.lw209_timer = 0
        self.alpha = 1
        self.colli = false        -- STARTING 段还没有判定（hitboxStartTime == startTime）
        ---★ 光柱的寿命只由它自己的状态机决定：原作把这 256 条光柱存在固定槽位里，
        ---  槽位要到状态机跑完才释放（BulletManager.cpp:1049-1150），光柱**不会**因为
        ---  起点离开场地就被回收 —— 深几代的蛛网节点本来就在场外（一棵 8 代的树半径能
        ---  到 480 px），而起点在场外的光柱照样能横扫过场地打人。
        ---  不关 bound 的话，起点出界的那些会被引擎立刻回收，槽位也提前空出来。
        self.bound = false
    end,
    frame = function(self)
        local t = self.lw209_timer
        if self.lw209_state == 1 then
            local ramp = LASER_START_TIME > LASER_RAMP and LASER_RAMP or LASER_START_TIME
            if LASER_START_TIME - ramp < t then
                self.w = t * LASER_W / LASER_START_TIME
            else
                self.w = LASER_W0
            end
            if t >= LASER_START_TIME then
                ---原作这里不 break，直接落到 ACTIVE 那一支
                self.lw209_state = 2
                self.lw209_timer = 0
                t = 0
            end
        end
        if self.lw209_state == 2 then
            self.w = LASER_W
            self.colli = true
            if t >= LASER_DURATION then
                self.lw209_state = 3
                self.lw209_timer = 0
                t = 0
            end
        end
        if self.lw209_state == 3 then
            ---消散段关判定：原作那 20 帧把判定盒的长度改写成 currentWidth/2、盒心却还钉在
            ---position + 300，只剩「光柱中点附近一个 5 px 的小方块」（见头部注释），
            ---照抄一个 600 px 长的盒子反而更危险、更不忠实。
            self.colli = false
            self.w = LASER_W - t * LASER_W / LASER_DESPAWN
            if t >= LASER_DESPAWN then
                object.RawDel(self)
                return
            end
        end
        self.lw209_timer = t + 1
        laser.frame(self)
    end,
})

---一次出弹（SpawnBulletPattern：BulletManager.cpp:685-712）。池满 → 整波不生。
local function spawn_by_pool(factory)
    if pool_used() >= POOL_SIZE then
        return
    end
    pool[#pool + 1] = factory()
end

---蛛网节点（Sub79）。
---dir/depth/li5/jitter 都是「上一帧那条 ins_94 时变量块里的值」：
---  dir    = 本节点的 lf0（TH08 口径换成**我们口径**存：−TH08 角）
---  depth  = xi0（生成了几个后代）
---  li5    = 根的循环计数（0 = 第 1 轮，>= 1 = 第 2 轮起才有第 102 帧那发慢弹）
---  jitter = lf7（整棵树共用）
lw209_web = Class(object, {
    init = function(self, x, y, dir, depth, li5, jitter)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        ---原作 NO_SPRITE：拿 0 透明度的 "white" 顶替，视觉上不存在。
        self.img = "white"
        self.hscale, self.vscale = 0.01, 0.01
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend, self._a = "", 0
        self.lw209_t = 0
        self.lw209_dir = dir
        self.lw209_depth = depth
        self.lw209_li5 = li5
        self.lw209_jitter = jitter
        self.lw209_x0, self.lw209_y0 = x, y
        self.lw209_dx = math.cos(dir) * MOVE_DIST
        self.lw209_dy = math.sin(dir) * MOVE_DIST
        self.lw209_extra = false
    end,
    render = function() end,
    frame = function(self)
        local t = self.lw209_t
        if t == 0 then
            ---ins_114：光柱生成在**移动前**的位置（RunEcl 先跑、UpdateMovement 后跑）。
            ---槽满就整发不生成（SpawnLaserPattern 从头找第一个空槽）。
            if laser_used() < LASER_SLOTS then
                lasers[#lasers + 1] = New(lw209_laser, self.x, self.y, self.lw209_dir)
            end
        end
        ---7 发火花：t = 0,2,4,…,12 各一发（RANDOM_ANGLE 在 TH08 口径下均匀，
        ---取反后仍均匀，直接把我们的角写成就行）。
        if t <= CHILD_FRAME and t % SPARK_INTERVAL == 0 then
            spawn_by_pool(function()
                return New(lw209_spark, self.x, self.y, ran:Float(-PI, PI))
            end)
        end
        if t == CHILD_FRAME then
            local nd = self.lw209_depth + 1
            if nd < WEB_DEPTH_MAX then
                ---子节点生成在**父节点当前位置**（已走完 12/14 步 = 60 px），
                ---方向 = 本节点的 lf0 ± lf7，lf7 与 li5 原样继承。
                local d = self.lw209_dir
                local j = self.lw209_jitter
                webs[#webs + 1] = New(lw209_web, self.x, self.y, d + j, nd,
                        self.lw209_li5, j)
                webs[#webs + 1] = New(lw209_web, self.x, self.y, d - j, nd,
                        self.lw209_li5, j)
                ---`ins_44(li5, 1, …)` 不跳（li5 >= 1）时才等 92 帧补那一发慢弹。
                self.lw209_extra = self.lw209_li5 >= 1
            else
                ---`xi0 >= 8` → ins_1 TERMINATE（第 1 轮的网只活到这一帧）。
                object.RawDel(self)
                return
            end
        end
        if t == EXTRA_FRAME then
            if self.lw209_extra then
                spawn_by_pool(function()
                    return New(lw209_bullet, self.x, self.y, EXTRA_ANGLE, EXTRA_SPEED)
                end)
            end
            ---ins_1 TERMINATE（跑完那一发就消失）
            object.RawDel(self)
            return
        end
        ---插值位移一步（EnemyManager.cpp:80-121 的 INTERPOLATED 分支，缓动 0 = 线性）。
        if t < MOVE_FRAMES then
            local u = (t + 1) / MOVE_FRAMES
            self.x = self.lw209_x0 + self.lw209_dx * u
            self.y = self.lw209_y0 + self.lw209_dy * u
        end
        self.lw209_t = t + 1
    end,
})

---ins_67 = MOVE_RANDOM_IN_BOUNDS → BeginBoundaryAwareMove（EclDependencies.cpp:160-235）。
---本卡从没设过 movementBounds（没有 ins_75），所以四条边界判据都是拿 (0,0,0,0) 比 ——
---跟卡 208 一模一样的怪癖，照抄：`x < 96` 偶尔真、`x > −96` 恒真（于是会拿
---**上一段的 movementAngle** 改写角度）、`y < 48` 假、`y > −48` 恒真。
---返回值是 TH08 口径的角。
local function wander_angle(owner)
    local bx = to_th08_x(owner.x)
    local by = to_th08_y(owner.y)
    local angle
    if to_th08_x(player.x) < bx then
        angle = ran:Float(0, PI / 2) + 3 * PI / 4
    else
        angle = ran:Float(0, PI / 2) - PI / 4
    end
    if bx < 96 then
        if angle > PI / 2 then
            angle = PI - angle
        elseif angle < -PI / 2 then
            angle = -PI - angle
        end
    end
    if bx > -96 then
        if angle < PI / 2 and angle >= 0 then
            angle = PI - owner.lw209_movement_angle
        elseif angle > -PI / 2 and angle <= 0 then
            angle = -PI - angle
        end
    end
    if by < 48 and angle < 0 then
        angle = -angle
    end
    if by > -48 and angle > 0 then
        angle = -angle
    end
    return angle
end

---StartTimedPolarDisplacement（EclDependencies.cpp:106-126）：operand0 = 60 > 0 →
---「60 帧走完 (cos,sin)(angle)·1.0·60 = 60 px」的插值，缓动 4 = OUT_QUADRATIC。
local function begin_wander(owner)
    local angle = wander_angle(owner)
    owner.lw209_movement_angle = angle
    owner.lw209_move = {
        x0 = owner.x, y0 = owner.y,
        dx = math.cos(-angle) * WANDER_SPEED * WANDER_FRAMES,
        dy = math.sin(-angle) * WANDER_SPEED * WANDER_FRAMES,
        n = WANDER_FRAMES, t = 0,
    }
end

---插值位移的一步（EnemyManager.cpp:80-121）。缓动 4 = OUT_QUADRATIC = 1−(1−u)²。
local function move_step(move)
    move.t = move.t + 1
    local u = move.t / move.n
    if u > 1 then u = 1 end
    local e = 1 - (1 - u) * (1 - u)
    return move.x0 + move.dx * e, move.y0 + move.dy * e, move.t >= move.n
end

---Sub76 每帧（原作 RunEcl 主 context → 子 context，然后才是 UpdateMovement）。
local function boss_frame(owner)
    ---★ card.before 阶段 frame 先跑（tools/check_stage.lua 也照抄了这个顺序），
    ---  那几帧 lw209_t 还是 nil；卡 205/206/207/208/218 同款守卫。
    if not owner.lw209_t then return end
    local f = owner.lw209_t
    if f >= CYCLE_FIRST then
        local ph = (f - CYCLE_FIRST) % CYCLE_PERIOD
        if ph == 0 then
            ---t=110：lf0 = AIM_TO_PL、xi0 = 0、lf7 = rndUnit·(−π/8) + 2π/5、生成 1 个节点。
            ---AIM_TO_PL 是 TH08 口径「从 BOSS 指向自机」的角；我们坐标里取反即可。
            local aim = math.atan2(to_th08_y(player.y) - to_th08_y(owner.y),
                                   to_th08_x(player.x) - to_th08_x(owner.x))
            local jitter = BRANCH_BASE - BRANCH_JITTER * ran:Float(0, 1)
            webs[#webs + 1] = New(lw209_web, owner.x, owner.y, -aim, 0, owner.lw209_li5,
                    jitter)
        elseif ph == WANDER_PHASE then
            ---t=290：ins_67 随机走 60 px（缓动 4），同帧 li5++。
            begin_wander(owner)
            owner.lw209_li5 = owner.lw209_li5 + 1
        end
    end
    local move = owner.lw209_move
    if move then
        local x, y, done = move_step(move)
        owner.x, owner.y = x, y
        if done then
            owner.lw209_move = nil
        end
    end
    owner.lw209_t = f + 1
end

local function card_init(owner)
    owner.lw209_t = 0
    owner.lw209_li5 = 0
    ---上一段（从出生点插值进场）的方向：TH08 口径的 π/2 = 朝下 = 我们坐标朝上。
    ---BeginBoundaryAwareMove 的 `bx > −96` 那条会拿它改写角度。
    owner.lw209_movement_angle = PI / 2
    ---ins_64(110, 4, 192, 128)：从出生点插值到 (0,96)，缓动 4 = OUT_QUADRATIC
    owner.lw209_move = {
        x0 = owner.x, y0 = owner.y,
        dx = BOSS_END_X - owner.x, dy = BOSS_END_Y - owner.y,
        n = BOSS_MOVE_FRAMES, t = 0,
    }
    ---原作 Sub76 t=0 还有一堆关射击、关判定、登记符卡、清场的指令
    ---（ins_129/130/105/95/113/80/110/134/153/132/122）—— 都由 boss 系统与 lw_before 管，不另写。
end

local function card_del(owner)
    ---★ 必须把帧计数器一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑，
    ---  留着 lw209_t 它会继续按周期出网（卡 205/206/207/208 都踩过同款坑）。
    owner.lw209_t = nil
    owner.lw209_move = nil
    owner.lw209_li5 = nil
    for i = #webs, 1, -1 do
        if IsValid(webs[i]) then
            object.RawDel(webs[i])
        end
        webs[i] = nil
    end
    for i = #lasers, 1, -1 do
        if IsValid(lasers[i]) then
            object.RawDel(lasers[i])
        end
        lasers[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[209] = {
    init = function(owner)
        pool = {}
        lasers = {}
        webs = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---卡 210「蓬莱之树海」（蓬莱山辉夜）
---  ecldata7sp.ecl：Sub79 = BOSS 根、Sub80 = 樹（使魔）、Sub81 = BOSS 的并行子 ECL（环）、
---  Sub82 = 樹的枪。整张卡只有这四处，下面每条「文件:行号」都能在本机复查。
---
---  · Sub79（根）：
---      t=0    入场 `ins_64(110, 4, 192, 128)` 插值到 TH08 (192,128) = 我们 (0,96)。
---      t=110  `ins_81(4)`/`ins_160(180)`/`ins_62()`/`ins_52(33)`：开判定、伤害减免 180 帧、
---             特殊动画、循环放特效（Sub33 纯观感）—— 由 boss 系统与 lw_before 管，不另写。
---      t=130  一次性做完三件事：
---             ① `ins_64(240, 0, selfX, 64)`：240 帧**线性**从 (192,128) 移到 (192,64)
---                = 我们 (0,96) → (0,160)（往上飞 64 px）。缓动 0 = LINEAR。
---             ② 7 个 `ins_91(80, 0, 0, life, −2, 100)`（SPAWN_FAMILIAR_AT_OFFSET）：
---                ★ 偏移是**字面量 0,0**（operandFlags = 0，裸字节复核过），7 棵树全长在
---                  BOSS 身上，靠继承过去的 `li0` = 2/4/6/8/10/13/14 与
---                  life = 4000/2100/1000/1000/1000/2100/4000 区分。
---                  子 context 整块拷父的 int+float 变量（EnemyTimeline.cpp:64-108 的
---                  EnemyContextCopy 0x78 字节）→ 每棵树拿到自己的 lf0/lf1/lf2/lf3。
---                  树的出生位置 = 父 worldPosition + 偏移 = BOSS 的位置（**移动前**的
---                  (192,128)：SpawnEnemy2 在 RunEcl 里跑，而 UpdateMovement 在后面）。
---             ③ `ins_135(0, 81)`：给 BOSS 挂上并行子 ECL（Sub81 = 环）。
---      t=290  `ins_4(130, 0)`：位移 0 = **跳到自己**（把时间拨回 130、指令指针原地不动，
---             EclRunLow.inl:239-243）→ t=130 那一整块**只跑一次**；之后 context 的时间在
---             130..290 之间空转（真要循环的块写负位移：Sub82 是 −80、Sub81 是 −1848）。
---  · Sub80（樹）：给 position.x / position.y 各装一个 120 帧的 Hermite 插值
---      （op36 INSTALL_INTERPOLATION，callback 7 = InterpolateHermite，
---      EclDependencies.cpp:325-350）。op36 的操作数是
---      [目标 float 变量, 时长, 回调号, 缓动, p0, p1, p2, p3]，本卡是：
---        x：p0 = xf0 = 自己的 x、p1 = lf0 = 192 + 32·cos φ、p2 = cf2 = lf3·cos ψ、p3 = ±400
---        y：p0 = xf1 = 自己的 y、p1 = lf1 = 288 + 32·sin φ、p2 = cf3 = lf3·sin ψ、p3 = ±400
---      其中 φ = lf4 = −π/2 + k·2π/7、ψ = lf2 = −k·2π/7、lf3 = 400；
---      p3 的两个符号是**两次独立随机抽**（op9 SET_FLOAT_RANDOM_SIGN，先 x 后 y，
---      EclRunLow.inl:257-260），所以每根树枝甩出的弧线都不一样。
---      Hermite 是控制点的仿射组合（权重和 = 1），所以整体平移/翻转不改形状 ——
---      移植版把 4 个控制点**留在 TH08 口径**算完，再把结果换算回我们的坐标（最不容易错）。
---      ★ 插值的计时器在**每帧尾部**先 +1 再算进度（EclRun.cpp:133-146），
---        所以出生当帧进度就是 1/120、第 120 帧到 1.0；t=1 的权重是 w1 = 1，
---        终点的 x/y 分量恰好 = p1 → 7 棵树最后停在以 (192,288) 为心、半径 32 的圆上
---        （TH08 口径），= 我们坐标里以 (0,−64) 为心、半径 32 的圆上。
---      t=120  `ins_65(0, 0)` 停住 + `ins_81(3)` 开判定 + 三条 `ins_111`（见下）；
---      t=150  `ins_135(0, 82)` 挂上自己的枪；t=30150 又是那个「跳到自己」→ 枪只挂一次。
---  · Sub82（樹的枪）：每 8 帧一对**相反方向**的弹。
---      `ins_99(type 17, color li0, count1 = 2, count2 = 1, speed1 = 2.1, speed2 = 0.5,
---       angle = π + n·π/40, angleStep = π/32, flags = 0x4A82)`：CIRCLE 的角是
---      `index1·2π/count1 + index2·angleStep + angle`（BulletManager.cpp:143-149），
---      count1 = 2 且 count2 = 1 → 就是角度相差 π 的两发、速度都取 speed1。
---      flags 0x4A82 = SPAWN_FAST(2) | DIR_AIMED(0x80) | PLAY_SPAWN_SOUND(0x200) |
---      BOUNCE_EXCEPT_BOTTOM(0x800) | SET_SPRITE(0x4000)（BulletManager.hpp:129-156）。
---  · 三条 op111（Sub80 t=120 写进**樹的** bulletSpawnDescriptor，所有树弹共用）：
---      slot0 `[0, 0x800, allow 0, int0 = 0, int1 = −1, float0 = −999.9, float1 = 0]`
---        = 弹墙：bounceLimit = payload.int0 = **0**、bounceSpeed = 当前速度
---          （float0 < 0 → 取 this->speed，BulletManager.cpp:369-376）；
---          撞一次就 `bouncesCompleted(1) >= bounceLimit(0)` 把状态清掉（:1397-1406）。
---      slot1 `[1, 0x80, allow 0, int0 = 1, int1 = 1, float0 = 0, float1 = 2.4]`
---        = 自机狙：intervalFrames = 1、repeatCount = 1、angle = 0、speed = 2.4。
---      slot2 `[2, 0x4000, allow 0, int0 = 2, int1 = li0, float0 = −1, float1 = −1]`
---        = 换精灵：bulletType = 2、color = li0（operandFlags = 0x10 → 只有 int1 是变量）。
---      ★ 三条的 allowWhileActive 都是 0，而 AdvanceTransformProgram 在
---        `allowWhileActive == 0 && activeTransformFlags != 0` 时直接 return（:321-323）
---        → 必须等前一条的状态结束才会轮到下一条。这张卡的节奏就是
---        「弹出去撞一次墙 → 拐过来直冲自机 → 换贴图」。
---  · 出屏回收（:857-899）：判据是**整颗精灵**出没出场地（IsWithinPlayfield 要加半个
---      精灵宽高，GameManager.cpp:132-150），而弹墙的翻轴判据用的是**中心的裸坐标**
---      （`x < 0 || x >= 384`、上边 `y < 0`，下边因为 BOUNCE_EXCEPT_BOTTOM 不翻）。
---      于是「撞墙那一帧」的位置一定是刚越过 (场地 + 半精灵) 的那一帧，而反弹后的位移
---      正好把它带回来 → **同帧的出屏判定放行**，弹活下来；下一帧才轮到自机狙记录。
---      只有往下飞的那半圈（下边不反弹、也不满足任何翻轴条件）会在这一帧直接消失。
---  · Sub81（环）：`ins_2(15)`（SET_SECONDARY_TIME → 把 context 暂停 15 帧）+ `ins_99`
---      ×14（color 依次 2/4/6/8/10/13/14 循环两轮），每发 count1 = 16、count2 = 1、
---      speed1 = lf7 = 2.5、angle 交替 lf0/lf1，lf0 每发 +0.0122718、lf1 每发 −0.0122718。
---      14 × 15 = 210 帧一轮，块尾 `ins_4(600, −1848)` 回到块首（JUMP 会把 time 拨回 600，
---      于是同帧重跑整个块 → 下一轮的 shot1 与这一轮的 shot14 相隔仍是 15 帧）。
---      **第一条指令在 t=600** → 从挂上（BOSS t=130）起数 600 帧才开火 = BOSS t=730。
---      flags 0x202 = SPAWN_FAST | PLAY_SPAWN_SOUND；BOSS 自己没写过 blueprint
---      （records 全 0 = BULLET_TRANSFORM_NONE）→ 环的弹是普通直飞弹。
---  · 时间：`ins_134(5940, 21)` = 5940 帧后结束（99 秒，和 LIST 里的秒数一致）。
---  · 占位贴图：樹 = "servant"、弹 = ball_small（TH08 色号 2/4/6/8/10/13/14 →
---    我们的 3/5/7/9/11/14/15，见文件头）。17 张全部实现完之后再统一换素材。
---  ★ 已知差异：原作这 7 棵树**可以打掉**（`ins_81(3)` 开 ACCEPTS_DAMAGE|COLLISION、
---    life 1000..4000），打掉就不再放弹；移植版跟其它卡一样不给使魔判定
---    （占位做法，见卡 218 的娃娃），所以 7 棵树会一直在场上。
---  ★ 换精灵那条记录（slot2）只改观感：移植版占位不改贴图，见「统一换素材」。
---------------------------------------------------------------
do
local PI = 3.141592653589793

---TH08 世界坐标 → 我们坐标（见文件头）：x_我们 = x_原作 − 192、y_我们 = 224 − y_原作。
local function to_th08_x(x) return x + 192 end
local function to_th08_y(y) return 224 - y end

---Sub79（BOSS 根）的节拍。
local FIRST_Y = 96                      -- ins_64(110, 4, 192, 128)：TH08 y=128 → 我们 96
local FIRST_FRAMES = 110
local SPAWN_FRAME = 130                 -- t=130：7 棵树 + 挂上环 + 开始上移
local BOSS_END_Y = 160                  -- ins_64(240, 0, selfX, 64)：TH08 y=64 → 我们 160
local BOSS_MOVE_FRAMES = 240

---Sub80（樹）的节拍。
local TREE_COUNT = 7                    -- 7 次 ins_91（li0 = 2/4/6/8/10/13/14）
local TREE_FLIGHT = 120                 -- INSTALL_INTERPOLATION 的 duration
local TREE_ARM = 400                    -- lf3
local TREE_RADIUS = 32                  -- lf0/lf1 里围着 (192,288) 的那个半径
local TREE_CENTER_Y_TH08 = 288          -- lf1 的常量项（TH08 口径）
local TREE_GUN_FRAME = 150              -- Sub80 t=150 → ins_135(0, 82)
local TREE_FIRE_PERIOD = 8              -- Sub82 尾部的 JUMP（位移 −80，落点 t=0）
local TREE_SHOT_SPEED = 2.1             -- Sub82 的 speed1 = lf0
local TREE_TURN_SPEED = 2.4             -- op111 slot1 的 directionChange.speed
local TREE_TURN_INTERVAL = 1            -- op111 slot1 的 intervalFrames
local TREE_ANGLE_STEP = PI / 40         -- Sub82 的 lf2（每发 +4.5°）

---Sub81（BOSS 的环）的节拍。
local RING_FIRST = 600                  -- 子 ECL 的第一条指令在 t=600
local RING_GAP = 15                     -- ins_2(15) 的暂停帧数
local RING_SHOTS = 14                   -- 一轮 14 发
local RING_CYCLE = RING_SHOTS * RING_GAP
local RING_COUNT = 16                   -- count1
local RING_SPEED = 2.5                  -- speed1 = lf7
local RING_STEP = 0.012271847           -- lf0/lf1 每发的增量

---弹的公共参数。
local SPAWN_FAST_FRAMES = 10            -- etama.anm script21（+10 那条 ins_1）
local POOL_SIZE = 1536                  -- BulletManager.hpp:455（0x600 个弹槽）
local SPRITE_HALF = 8                   -- bulletType 17 的贴图 sprite302 = 16×16（etama.decl）
local BOUNCE_LIMIT = 0                  -- op111 slot0 的 bounceLimit = intPayload0
local OUTSIDE_KEEP = 0x80               -- 带活动状态的弹最多在外面拖 128 帧
local FIELD_L, FIELD_R, FIELD_B, FIELD_T = -192, 192, -224, 224

---TH08 色 2/4/6/8/10/13/14 → 我们的 3/5/7/9/11/14/15（同色名 +1）。
local TREE_COLORS = {
    COLOR.DEEP_PURPLE, COLOR.DEEP_BLUE, COLOR.ROYAL_BLUE,
    COLOR.DEEP_GREEN, COLOR.CHARTREUSE, COLOR.ORANGE, COLOR.DEEP_GRAY,
}

---本卡的弹池（= 原作那 1536 个弹槽）与树登记表。
local pool = {}
local trees = {}

---弹 / 樹 的类（先声明：下面的 spawn_bullet 要引用这个 upvalue）。
local lw210_bullet
local lw210_tree

---IsWithinPlayfield（GameManager.cpp:132-150）：加半个精灵宽高之后还在不在场地里。
local function outside_field(x, y)
    return x + SPRITE_HALF < FIELD_L or x - SPRITE_HALF > FIELD_R
            or y + SPRITE_HALF < FIELD_B or y - SPRITE_HALF > FIELD_T
end

---本卡的弹池计数：原作 activeBulletCount 数是**所有非空弹槽**（不看位置，
---BulletManager.cpp:810-816 每帧先清零再数一遍），所以这里只按「对象还活着」清表。
local function pool_used()
    for i = #pool, 1, -1 do
        if not IsValid(pool[i]) then
            table.remove(pool, i)
        end
    end
    return #pool
end

---一次出弹（SpawnBulletPattern：BulletManager.cpp:685-712）。池满 → 整波不生。
local function spawn_by_pool(factory)
    if pool_used() >= POOL_SIZE then
        return
    end
    pool[#pool + 1] = factory()
end

local function spawn_bullet(x, y, angle, speed, color, is_tree)
    spawn_by_pool(function()
        return New(lw210_bullet, x, y, angle, speed, color, is_tree)
    end)
end

---AdvanceTransformProgram 的移植（BulletManager.cpp:310-332 的推进规则）。
---只有樹的弹带记录：0 = 弹墙（出生当帧就生效，这里用 lw210_state = "bounce" 表示）、
---1 = 自机狙、2 = 换精灵。`allowWhileActive == 0` 的记录必须等状态清掉才轮到。
local function bullet_advance(self)
    if self.lw210_state or self.lw210_prog >= 3 then
        return
    end
    if self.lw210_prog == 1 then
        ---记录 1 生效：timer = 0、directionChangesCompleted = 0
        self.lw210_prog = 2
        self.lw210_state = "dir"
        self.lw210_dir_timer = 0
        self.lw210_dir_done = 0
    else
        ---记录 2（SET_SPRITE）：换完立刻继续往下，程序到此结束（下一条是 NONE）。
        ---占位实现不改贴图（见文件头）。
        self.lw210_prog = 3
    end
end

---UpdateBoundaryBounce（BulletManager.cpp:1374-1418）。
---   · 先看整颗精灵出没出场地；
---   · 再按**中心的裸坐标**决定翻哪条轴（我们坐标：x < l || x >= r、上边 y > t）；
---     本卡是 BOUNCE_EXCEPT_BOTTOM → 下边永远不翻（只有 ALL_EDGES 才翻）；
---   · 速度回到 bounceSpeed（本卡 = 出生速度，因为 payload.speed = −999.9 < 0）；
---   · bouncesCompleted(1) >= bounceLimit(0) → **当帧**把弹墙状态清掉。
local function bullet_bounce(self)
    if not outside_field(self.x, self.y) then
        return
    end
    if self.x < FIELD_L or self.x >= FIELD_R then
        self.lw210_bvx = -self.lw210_bvx        -- 原作 angle = −angle − π
    end
    if self.y > FIELD_T then
        self.lw210_bvy = -self.lw210_bvy        -- 原作 angle = −angle
    end
    self.lw210_bounces = self.lw210_bounces + 1
    if self.lw210_bounces >= BOUNCE_LIMIT then
        self.lw210_state = nil
    end
end

---UpdateAimedDirectionChange（BulletManager.cpp:1332-1372）。
---intervalFrames = 1、repeatCount = 1：生效后的第 1 帧只把 timer 往前推
---（magnitude = speed − timer·speed/interval = 原速度、角度不动），**第 2 帧**才把角度
---改成「朝自机」、速度跳到 2.4，并把状态清掉 —— 所以只瞄一次、之后直线飞出去。
local function bullet_dir(self)
    if self.lw210_dir_timer >= TREE_TURN_INTERVAL then
        self.lw210_dir_done = self.lw210_dir_done + 1
        if self.lw210_dir_done >= 1 then
            self.lw210_state = nil
        end
        self.lw210_dir_timer = 0
        local dx, dy = player.x - self.x, player.y - self.y
        local d = math.sqrt(dx * dx + dy * dy)
        if d > 1e-4 then
            self.lw210_bvx = dx / d * TREE_TURN_SPEED
            self.lw210_bvy = dy / d * TREE_TURN_SPEED
        end
    else
        self.lw210_dir_timer = self.lw210_dir_timer + 1
    end
end

---樹 / 环的弹。is_tree = true 时带 op111 那三条记录；环的弹没有任何变换程序。
---出生（SPAWN_FAST）：位置先退 velocity·4，之后每帧只走 velocity/2，
---动画（10 帧）播完那一帧落到 FIRED 分支：同帧再走一遍完整位移（BulletManager.cpp:950-968）。
lw210_bullet = Class(bullet, {
    init = function(self, x, y, angle, speed, color, is_tree)
        ---bullet:init(imgclass, index, stay, destroyable)（THlib/bullet/bullet.lua:75）
        bullet.init(self, ball_small, color, false, true)
        self.bound = false                  -- 出屏回收自己判（卡 206/209 同款）
        self.lw210_bvx = math.cos(angle) * speed
        self.lw210_bvy = math.sin(angle) * speed
        self.vx, self.vy = 0, 0             -- 引擎的自动积分必须保持 0，位移全在 frame 里算
        self.x = x - self.lw210_bvx * 4
        self.y = y - self.lw210_bvy * 4
        self.lw210_spawn = SPAWN_FAST_FRAMES
        self.colli = false                  -- 出生动画期间没有判定
        ---变换程序：is_tree 的弹出生当帧就已经吃下记录 0（弹墙状态生效）。
        self.lw210_prog = is_tree and 1 or 3
        self.lw210_state = is_tree and "bounce" or nil
        self.lw210_bounces = 0
        self.lw210_dir_timer = 0
        self.lw210_dir_done = 0
        self.lw210_off = 0
    end,
    frame = function(self)
        local bvx, bvy = self.lw210_bvx, self.lw210_bvy
        ---① 出生动画：每帧只走 velocity/2；跑完那一帧不 return，继续往下走完整流程。
        if self.lw210_spawn > 0 then
            self.x = self.x + bvx * 0.5
            self.y = self.y + bvy * 0.5
            self.lw210_spawn = self.lw210_spawn - 1
            if self.lw210_spawn > 0 then
                bullet.frame(self)
                return
            end
            self.colli = true
        end
        ---② 推进变换程序（每帧最前面跑，BulletManager.cpp:820）
        bullet_advance(self)
        ---③ 活动状态的更新（同 :825-854 的顺序）
        if self.lw210_state == "bounce" then
            bullet_bounce(self)
        elseif self.lw210_state == "dir" then
            bullet_dir(self)
        end
        ---④ 位移，然后出屏回收（:857-899）
        self.x = self.x + self.lw210_bvx
        self.y = self.y + self.lw210_bvy
        if not outside_field(self.x, self.y) then
            self.lw210_off = 0
        elseif self.lw210_state then
            ---还有活动状态的弹出屏不立刻死，最多拖 128 帧
            self.lw210_off = self.lw210_off + 1
            if self.lw210_off >= OUTSIDE_KEEP then
                object.RawDel(self)
                return
            end
        else
            if self.lw210_off == 0 then
                object.RawDel(self)
                return
            end
            self.lw210_off = self.lw210_off - 1
        end
        bullet.frame(self)
    end,
})

---Hermite 插值（InterpolateHermite，EclDependencies.cpp:325-350）：
---w0 = (t−1)²(2t+1)、w1 = t²(3−2t)、w2 = (1−t)²t、w3 = (t−1)t²。
local function hermite(p0, p1, p2, p3, t)
    local m = t - 1
    return m * m * (2 * t + 1) * p0
            + t * t * (3 - 2 * t) * p1
            + (1 - t) * (1 - t) * t * p2
            + m * t * t * p3
end

---Sub82（樹的枪）：每 8 帧一对相反方向的弹，角度每发 +π/40（TH08 口径）。
---发弹位置用**上一帧末**的位置（RunEcl 在 UpdateMovement 之前）。
local function tree_gun(owner, t)
    if t < TREE_GUN_FRAME or (t - TREE_GUN_FRAME) % TREE_FIRE_PERIOD ~= 0 then
        return
    end
    local n = (t - TREE_GUN_FRAME) / TREE_FIRE_PERIOD
    local a = PI + n * TREE_ANGLE_STEP       -- TH08 口径；我们坐标整体取反
    local x, y, color = owner.x, owner.y, owner.lw210_color
    spawn_bullet(x, y, -a, TREE_SHOT_SPEED, color, true)
    spawn_bullet(x, y, -a - PI, TREE_SHOT_SPEED, color, true)
end

---樹（Sub80）。占位贴图 "servant"；原作它有 24×24 判定与 life（1000..4000），可被击破，
---移植版不给判定（占位口径，见文件头）。
lw210_tree = Class(object, {
    init = function(self, x, y, k)
        self.x, self.y = x, y
        self.group, self.layer = GROUP.INDES, LAYER.ENEMY
        self.img = "servant"
        self.hscale, self.vscale = 0.6, 0.6
        self.colli = false
        self.navi = false
        self.bound = false
        self.rot = 0
        self._blend = ""
        self._a = 255
        self.lw210_t = 0
        self.lw210_color = TREE_COLORS[k + 1]
        ---φ = lf4、ψ = lf2（都是 TH08 口径）。控制点留在 TH08 口径算，算完再换算回我们坐标。
        local phi = -PI / 2 + k * (2 * PI / TREE_COUNT)
        local psi = -k * (2 * PI / TREE_COUNT)
        ---★ 两个 p3 的符号是两次独立随机抽，顺序是先 x 后 y（op9 在两条 op36 之前各一条）。
        self.lw210_cx = {
            to_th08_x(x),                                       -- p0 = xf0 = 自己的 x
            192 + TREE_RADIUS * math.cos(phi),                  -- p1 = lf0
            TREE_ARM * math.cos(psi),                           -- p2 = cf2 = lf3·cos ψ
            ran:Sign() * TREE_ARM,                              -- p3 = ±lf3
        }
        self.lw210_cy = {
            to_th08_y(y),                                       -- p0 = xf1 = 自己的 y
            TREE_CENTER_Y_TH08 + TREE_RADIUS * math.sin(phi),   -- p1 = lf1
            TREE_ARM * math.sin(psi),                           -- p2 = cf3 = lf3·sin ψ
            ran:Sign() * TREE_ARM,                              -- p3 = ±lf3
        }
    end,
    frame = function(self)
        local t = self.lw210_t
        ---枪先跑（EnemyManagerUpdate.cpp:159-192：RunEcl → UpdateMovement）。
        tree_gun(self, t)
        ---两个 120 帧 Hermite：计时器从 1 数到 120（EclRun.cpp:133-146 在尾部先 ++ 再算进度）。
        if t <= TREE_FLIGHT then
            local n = t + 1
            if n > TREE_FLIGHT then n = TREE_FLIGHT end
            local u = n / TREE_FLIGHT
            local cx, cy = self.lw210_cx, self.lw210_cy
            self.x = hermite(cx[1], cx[2], cx[3], cx[4], u) - 192
            self.y = 224 - hermite(cy[1], cy[2], cy[3], cy[4], u)
        end
        self.lw210_t = t + 1
    end,
})

---Sub81（BOSS 的环）：从挂上那一刻数 600 帧开火，之后每 15 帧一发、14 发一轮。
---第 k 发（k = 0..13）的角度偏移：偶数发取 lf0 = (k/2)·step、奇数发取 lf1 = −((k+1)/2)·step。
local function ring_shot(owner, rt)
    local k = math.floor(((rt - RING_FIRST) % RING_CYCLE) / RING_GAP)
    local off
    if k % 2 == 0 then
        off = (k / 2) * RING_STEP
    else
        off = -((k + 1) / 2) * RING_STEP
    end
    local x, y, color = owner.x, owner.y, TREE_COLORS[(k % TREE_COUNT) + 1]
    for i = 0, RING_COUNT - 1 do
        ---ANGLE = index1·2π/count1 + angle（BulletManager.cpp:143-149），我们整体取反。
        spawn_bullet(x, y, -(i * (2 * PI / RING_COUNT) + off), RING_SPEED, color, false)
    end
end

---Sub79 每帧（原作 RunEcl 主 context → 子 context，然后才是 UpdateMovement）。
local function boss_frame(owner)
    ---★ card.before 阶段 frame 先跑，那几帧 lw210_t 还是 nil（卡 205..209 同款守卫）。
    if not owner.lw210_t then return end
    local f = owner.lw210_t
    if f == SPAWN_FRAME then
        ---① 7 棵树都生成在 BOSS **移动前**的位置（偏移是字面量 0,0）。
        for k = 0, TREE_COUNT - 1 do
            trees[#trees + 1] = New(lw210_tree, owner.x, owner.y, k)
        end
        ---② ins_135(0, 81)：挂上环（它自己再数 600 帧才开火）。
        owner.lw210_ring_t = 0
    end
    ---子 context（环）先跑，用的是**上一帧末**的位置。
    if owner.lw210_ring_t then
        local rt = owner.lw210_ring_t
        if rt >= RING_FIRST and (rt - RING_FIRST) % RING_GAP == 0 then
            ring_shot(owner, rt)
        end
        owner.lw210_ring_t = rt + 1
    end
    ---③ 位移：t<130 是入场插值（缓动 4 = OUT_QUADRATIC），t>=130 是线性上移 64 px。
    if f < SPAWN_FRAME then
        local mv = owner.lw210_move
        if mv then
            mv.t = mv.t + 1
            local u = mv.t / mv.n
            if u > 1 then u = 1 end
            local e = 1 - (1 - u) * (1 - u)
            owner.x = mv.x0 + mv.dx * e
            owner.y = mv.y0 + mv.dy * e
            if mv.t >= mv.n then
                owner.lw210_move = nil
            end
        end
    else
        local n = f - SPAWN_FRAME + 1
        if n > BOSS_MOVE_FRAMES then n = BOSS_MOVE_FRAMES end
        owner.y = FIRST_Y + (BOSS_END_Y - FIRST_Y) * (n / BOSS_MOVE_FRAMES)
    end
    owner.lw210_t = f + 1
end

local function card_init(owner)
    owner.lw210_t = 0
    owner.lw210_ring_t = nil
    ---ins_64(110, 4, 192, 128)：TH08 (192,128) = 我们 (0,96)，缓动 4 = OUT_QUADRATIC。
    owner.lw210_move = {
        x0 = owner.x, y0 = owner.y,
        dx = 0 - owner.x, dy = FIRST_Y - owner.y,
        n = FIRST_FRAMES, t = 0,
    }
    ---原作 t=0 还有一串关射击、关判定、登记符卡、清场的指令 —— boss 系统与 lw_before 管。
end

local function card_del(owner)
    ---★ 帧计数器必须一起清掉：boss 对象在 del 之后还活着、frame 还每帧在跑。
    owner.lw210_t = nil
    owner.lw210_ring_t = nil
    owner.lw210_move = nil
    for i = #trees, 1, -1 do
        if IsValid(trees[i]) then
            object.RawDel(trees[i])
        end
        trees[i] = nil
    end
    for i = #pool, 1, -1 do
        if IsValid(pool[i]) then
            object.RawDel(pool[i])
        end
        pool[i] = nil
    end
end

CARD[210] = {
    init = function(owner)
        pool = {}
        trees = {}
        card_init(owner)
    end,
    frame = boss_frame,
    del = card_del,
}
end
---------------------------------------------------------------
---还没移植的卡：占位实现。实现一张就在上面的 CARD 表里登记一张
---（key = TH08 卡号 205..221）。
---------------------------------------------------------------
local function placeholder_init() end
local function placeholder_frame() end
local function placeholder_del() end

---------------------------------------------------------------
---注册。跟旧版一样：SCBG 类、17 个角色、17 张卡，等级 29、卡 id 351..367。
---------------------------------------------------------------
do
local _SC_BG = _SC_BG
local TH08_bg = TH08_bg
local TH08_SC = _editor_class["TH08"] or {}
local TH07_SC = _editor_class["TH07"] or {}

class["SCBG1"] = Class(_SC_BG)
class["SCBG2"] = Class(_SC_BG)

---SCBG 的取自：多数是 TH08_SC["SCBG-LWn"]；灵梦/魔理沙用本文件自定义的
---SCBG1/SCBG2（TH08_SC 里没有她俩对应的 LW 背景），紫借 TH07 的 SCBG8。
local function scbg_of(key)
    if key == "SCBG1" or key == "SCBG2" then return class[key] end
    if key == "SCBG8" then return TH07_SC[key] end
    return TH08_SC[key]
end

---17 个角色。**顺序 = 组号 = 下面 LIST 的顺序**（第 k 条 = 组 k = boss id "ka"）。
---{角色名, 立绘, SCBG, 角色图名, 缩放}
local CHARS = {
    { "莉格露·奈特巴格",     "TH08_NEW_0", "SCBG-LW1",  "Nightbug" },
    { "米斯蒂娅·萝蕾拉",     "TH08_NEW_0", "SCBG-LW1",  "Lorelei" },
    { "上白泽慧音",          "TH08_NEW_0", "SCBG-LW3",  "Kamishirasawa" },
    { "铃仙·优昙华院·因幡",  "TH08_NEW_1", "SCBG-LW4",  "Reisen" },
    { "八意永琳",            "TH08_NEW_1", "SCBG-LW5",  "Yagokoro" },
    { "蓬莱山辉夜",          "TH08_NEW_1", "SCBG-LW6",  "Neet" },
    { "藤原妹红",            "TH08_NEW_1", "SCBG-LW6",  "Mokou" },
    { "因幡帝",              "TH08_NEW_2", "SCBG-LW8",  "Tewi" },
    { "上白泽慧音",          "TH08_NEW_2", "SCBG-LW9",  "Kamishirasawa2" },
    { "博丽灵梦",            "TH08_NEW_3", "SCBG1",     "Reimu" },
    { "雾雨魔理沙",          "TH08_NEW_3", "SCBG2",     "Marisa" },
    { "十六夜咲夜",          "TH08_NEW_3", "SCBG-LW10", "Sakuya" },
    { "魂魄妖梦",            "TH08_NEW_3", "SCBG-LW11", "Youmu", 0.6 },
    { "爱丽丝·玛格特洛依德", "TH08_NEW_3", "SCBG-LW12", "Alice" },
    { "蕾米莉亚·斯卡蕾特",   "TH08_NEW_3", "SCBG-LW13", "Remilia" },
    { "西行寺幽幽子",        "TH08_NEW_3", "SCBG-LW14", "Yuyuko" },
    { "八云紫",              "TH08_NEW_3", "SCBG8",     "Yukari" },
}

---{卡号, 中文卡名, 卡 id, 秒数}。顺序必须和 CHARS 一一对应。
---秒数 = ins_134 的 threshold/60：5940/60=99、2220/60=37、2160/60=36、7860/60=131。
local LIST = {
    { 205, "「季节外调的蝴蝶风暴」",   351,  99 },
    { 206, "「盲夜鸟」",               352,  99 },
    { 207, "「日出之国的天子」",       353,  99 },
    { 208, "「幻胧月睨」",             354,  99 },
    { 209, "「天网蛛网捕蝶之法」",     355,  99 },
    { 210, "「蓬莱之树海」",           356,  99 },
    { 211, "「不死鸟再诞」",           357,  99 },
    { 212, "「远古的欺骗者」",         358,  99 },
    { 213, "「无何有净化」",           359,  99 },
    { 214, "「梦想天生」",             360,  37 },
    { 215, "「炽热之星」",             361,  36 },
    { 216, "「紧缩世界」",             362,  99 },
    { 217, "「待宵反射卫星斩」",       363,  99 },
    { 218, "「格兰吉纽尔剧场的怪人」", 364,  99 },
    { 219, "「猩红命运」",             365,  99 },
    { 220, "「西行寺无余涅槃」",       366,  99 },
    { 221, "「深弹幕结界 -梦幻泡影-」", 367, 131 },
}

---每张卡共用的 before：不打超时音、关掉 BOSS 的判定与血量条渲染。
---Last Word 全是耐久卡（t1 = t2 = t3，伤害恒 0），所以判定本来也没用。
local function lw_before(self)
    self.NotPlayTimeOutSound = true
    self.colli = false
    self.no_hp_render = true
end

---组号 k 的 boss id = k.."a"：Define 和 card.add 必须用同一个 key。
---⚠ boss.Define 必须**先于** boss.card.add：add 会当场按 "<字母><关卡号>" 查 _editor_boss，
---  Define 晚一行就报「找不到 boss」（踩过）。**每个角色一个组**（旧版把 17 个全塞进
---  组 1 的 a..q，于是 boss.CreateGroup(1, level) 一次就把 17 个全建出来了）。
for k, c in ipairs(CHARS) do
    boss.Define(k .. "a", c[1], c[2], TH08_bg, { 0, 420 },
            scbg_of(c[3]), c[4], 29, c[5])
end

for k, e in ipairs(LIST) do
    local cardnum, name, id, seconds = e[1], e[2], e[3], e[4]
    local band = k .. "a"
    local card = boss.card.New(name, seconds, seconds, seconds, 10000000)
    ---boss.card.add(sc_group, level, CardName, data_id)：level 29 = TH31 的关卡号。
    boss.card.add({ { card, band } }, 29, name, id)
    local impl = CARD[cardnum]
    card.before = function(self)
        lw_before(self)
        if impl and impl.before then
            impl.before(self)
        end
    end
    ---⚠ 只能**逐个** `if impl.xxx` 覆盖：`boss.card.New`（boss_card.lua:66）给的默认值
    ---  是五个空函数，写 `card.render = impl.render` 在 impl 没实现 render 时
    ---  会把它**覆盖成 nil**，下一帧 `boss_system.lua:197` 无条件调
    ---  `current_card.render(self.boss)` → `attempt to call field 'render' (a nil value)`（踩过）。
    if impl then
        if impl.init then card.init = impl.init end
        if impl.frame then card.frame = impl.frame end
        if impl.render then card.render = impl.render end
        if impl.del then card.del = impl.del end
    else
        ---TODO：这张卡还没移植（init/frame/del 走 boss_card.lua:66 的空函数）。
        card.init = placeholder_init
        card.frame = placeholder_frame
        card.del = placeholder_del
    end
end

class["SCBG1"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th08_0", true, 0, 0, 0, 0, 0.3, 0, "", 1, 1)
    _SC_BG.AddLayer(self, "th08_3", true, 0, 0, 0, -0.2, 0, 0, "mul+add", 1, 1)
end

class["SCBG2"].init = function(self)
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th08_16", false, 0, 0, 0, 0, 0, 0, "mul+sub", 1, 1)
    _SC_BG.AddLayer(self, "th08_15", false, 0, 0, 0, 0, 0, 0, "", 1, 1)
    _SC_BG.AddLayer(self, "th08_20", true, 0, 0, 0, 0, 1.5, 0, "", 1, 1)
end
end
