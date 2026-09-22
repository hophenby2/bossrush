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
---实现进度：目前只有卡 218「格兰吉纽尔剧场的怪人」（爱丽丝）。其余 16 张在 CARD 表里
---没有登记 → 走文件末尾的占位实现（站着不动、不打弹）。
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
    if impl then
        card.init = impl.init
        card.frame = impl.frame
        card.render = impl.render
        card.del = impl.del
    else
        ---TODO：这张卡还没移植。
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
