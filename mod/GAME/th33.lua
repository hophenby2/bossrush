---=====================================
---TH33  文花帖（TH095）第 7 关 world08 —— 幽幽子 4 幕 + 妖梦 3 幕
---
---本关把原作 world08 的 7 张符卡逐幕移植成一条 Boss Rush。数据来源是
---th095/src/SceneSelect.cpp:138-145 的 TH095_SCENE 表（scoreIndex, 关卡组, 幕, ECL, BGM）：
---  71 ecl17_a 幽幽子 幽雅「死出の誘蛾灯」    75 ecl17_c 幽幽子 死符「醉人之生、死之梦幻」
---  72 ecl16_b 妖梦   密符「御大師様の秘鍵」  76 ecl16_d 妖梦   超人「飛翔役小角」
---  73 ecl17_b 幽幽子 蝶符「鳳蝶紋の死槍」    77 ecl17_d 幽幽子 「死蝶浮月」
---  74 ecl16_c 妖梦   行符「八千万枚護摩」
---（同表里的 scene 70 = ecl16_a 是**非符**、没有 ins_104 亮卡名，不在本关这 7 张里。）
---7 幕共用同一份场景资源（world08.std / enm16,17.anm / bgm th095_04.wav），所以两班人马
---共用 BGM 与背景：BGM = "TH07_1"（幽雅に咲かせ、墨染の桜）、背景 = TH095_bg。
---每个数值都标了它在反汇编里的出处：`/tmp/B_ecl16_{b,c,d}.txt` 与 `/tmp/B_ecl17_{a,b,c,d}.txt`
---是这次临时反汇编出来的（脚本 /tmp/p95b.py 不入库；数据在 `[th095] …/data/ecl1{6,7}_*.ecl`，
---换机器要重 dump 一遍）。各卡块里的「@地址」都指这几份 dump，改前先回去核对。
---
---两班人马怎么排
---  原作 7 幕是**自由选关**、本来没有先后；这里按角色分成两个 boss 组
---  （AGENTS.md §8 与 th31.lua 的教训：**一个角色一个组**，boss.CreateGroup 一次建一组）：
---      组 1 = 西行寺幽幽子：71 → 73 → 75 → 77（4 张）
---      组 2 = 魂魄妖梦：  72 → 74 → 76（3 张）
---  main_stage.lua 的 TH33 里连着调 boss.CreateGroup(1/2, 31)，就会依次打完两班人马。
---  ★ 别把两边塞进同一个组的 a、b：CreateGroup 会把 a、b、c… 一次全建出来（两人同时上场）。
---
---坐标系与角度（换算的理由）
---  TH095 的场地同样是 384x448，但原点在**左上**、y 轴**朝下**：世界坐标 (x,y) 画到
---  屏幕上要先加 (320,16)（th095/src/GameCoordinates.cpp 的 PhotoToScreen），也就是
---  x∈[-192,192]、y∈[0,448] 正好铺满场地。
---  我们的场地原点在中心、y 轴**朝上**（lstg.world.l/r/b/t = -192/192/-224/224）。
---  两边边长相同 ⇒ 换算是纯翻转：
---      我们的 x = TH095 的 x
---      我们的 y = 224 − TH095 的 y
---  TH095 的角度是弧度、顺时针为正；我们是 360 度制、逆时针为正。
---  换算规则：角度取反（θ → −θ）。整圈/整扇一起取反**方向集合不变**
---  （{a + 2πk/n} 取反 = {−a + 2πk/n}），所以对称图案直接抽 [0,360) 就等价，
---  不必逐个取反；只有**逐发自机狙**那种「每发各朝一个方向」才必须取反。
---  本文件里每一处用到角度的地方都写了它属于哪一种。
---
---与原作的差异（7 张卡共有，逐张卡的差异写在各卡块的注释里）
---  1) 拍照关的相机 / 计分系统：**相机本身不实现** —— 本仓库有自己的拍照自机
---     射命丸文（THlib/player/aya/aya.lua:191 给 player 挂了 player.camera，快门由玩家
---     自己按）。原作那套 opcode —— ins_141（快门上限）、ins_143（拍照标记）、
---     ins_144（快门脉冲）、ins_149（分数倍率）、ins_114（卡计时）、ins_104/105
---     （亮卡名 / 收会话）、ins_150（装饰 ANM）—— 只保留**影响弹幕数值**的那一头：
---     卡里用 photo_index()（见文件中部）去读真相机的「已拍张数」当 camera.photoIndex，
---     快门音 / 上限 / 计分一概不做；卡名与计时交给符卡系统（CARD_NAME / CARD_TIME）。
---     ★ 例外：拿到快门数之后**怎么算伤害**这一头按作者要求改了 —— 见差异 9。
---  2) 弹型：原作靠 g_PhotoBulletCollisionSizes（th095/src/BulletManager.cpp:118-122，
---     存的是**直径**、命中框取 ±size/2，见同文件 :1155）区分二十几种弹。本关按作者
---     指定把小玉换成 **butterfly（幽幽子系）与 water_drop（妖梦系）**两种贴图；
---     原作的大玉（type 17，直径 28 ⇒ 半径 14）用本仓库最大的一档 **ball_huge**。
---  3) 回收边界：原作是**弹心一越过场地边就回收**（PhotoBulletIsOutsidePlayfield，
---     th095/src/BulletManager.cpp:759-765，判据是「弹心 ± 半宽」出 384x448 的框），
---     而且全游戏共用 640 个弹槽、扫不到空槽就不发（同文件 :310-345）。
---     我们的回收边界是引擎全局的 ±224/±256（= 场地外 32 px，THlib/lib/Lscreen.lua:90-97，
---     bullet.lua:36 用的是 `lstg.world.bound*`，**弹不能单独设**）。后果：同一颗弹多活
---     ~10%，稳态同屏弹数比原作多一点。**屏幕上看不出区别** —— 两种回收都发生在屏幕外
---     （场地是 x±192 / y±224，边界都在它外面），差的只是场外那几十颗的寿命，
---     所以没有为它去改引擎的全局边界。
---  4) 判定框：Sub2 的 `ins_77(24,24)`（子机是 `77(8,8)`）设的是敌人判定框
---     （EclRunLow.inl:663-670 → hitboxDimensions）。TH095 没有自机子弹（th095/src 里
---     没有 PlayerBullet 一类文件，「射击键」就是快门），这个框在拍照关里读不出用处；
---     我们这边本体是要用子弹打掉的 HP Boss，判定框交给 boss_system 的默认值
---     —— 全仓库没有任何一张卡自己设过判定框，为一张卡破例反而不一致。
---  5) 子机：原作用 ins_83 / ins_84 生成**真的子敌机**（各自跑自己的 ECL 子程序、
---     有自己的生命），它们会一直累积、由 640 弹槽兜底。本仓库没有「无限累积的子机」
---     这种写法（§7.3 的装饰层都是自绘或真弹），所以每一幕都把它改成
---     **数量受限、有明确寿命、淡出离场**的自绘 object 或真弹（逐卡注释里写明）。
---
---──────────────────── 第 5 幕（死符「醉人之生、死之梦幻」） ────────────────────
---形状（三句话）
---  本体在**中轴 x=0** 上按 1600 帧一轮上下扫（256→448→256→64，每段 400 帧，
---  缓动 加速/减速/加速/减速），两条并行上下文**每 14 帧交替放一整圈**弹
---  （每条各每 28 帧一圈），每圈 32+拍照数 发、速度 1.3 定速直线、基准角每圈重抽。
---  圈与圈之间靠「发射点在动 + 基准角重抽」错开，玩家穿的是相邻两圈之间的径向缝。
---
---这一张与原作的差异（都交代在这，另外 6 张写在各卡块的注释里）
---  1) 原作是拍照关：玩家按快门，`camera.photoIndex`（已拍张数）决定每圈弹数，
---     即 Sub7/Sub8 的 `ins_20(intV0, 0x2761, 32)` —— 0x2761 = camera.photoIndex
---     （th095/src/EclOperandsInt.cpp:186），上限由 Sub2 的 ins_141(10) 设定
---     （同文件 EclRunTargetHigh.inl:448）。本仓库的相机挂在射命丸文自机上，卡里只读
---     它的快门数（photo_index(10)，见文件中部）⇒ 弹数曲线 32→42 与原作一致，
---     而且**卡里不需要自带任何拍照机制**。
---  2) 弹种 15 / 18：原作是两种**半径不同**的小玉 —— `g_PhotoBulletCollisionSizes`
---     （th095/src/BulletManager.cpp:118-122）存的是**直径**、命中框取 ±size/2
---     （同文件 :1155），15 号 = 8.0/2 = 半径 4.0、18 号 = 6.0/2 = 半径 3.0。
---     **贴图不照原作**：按作者要求两股分别换成 `butterfly` 与 `water_drop`
---     （§7.5 母题表里「蝶 → butterfly」正是幽幽子这一系的母题）。尺寸对得上：
---     butterfly 的判定半径 = 4（bulletStyle.lua:145 的 LoadImageGroup 末两参），
---     和原作的 15 号完全相等；water_drop 是动画样式（LoadAnimation，判定取引擎默认）。
---     颜色按贴图**实测**挑的两档紫：butterfly 第 2 行 (228,201,237) 淡紫、
---     water_drop3 (104,47,207) 深紫（见下面 RING_COLOR_* 的注释）。
---  3) transformFlags = 0x202：0x2 = SPAWN_FAST、0x200 = PLAY_SPAWN_SOUND
---     （th095/src/BulletManager.hpp:133,141）。原作弹出生时先播一小段出场动画、
---     并把位置往回退 4 帧的运动量（同文件 :445-457）；移植版让它出膛就飞
---     （NewSimpleBullet 的 stay=false）。音效原作也是整波响一次（:717-723），一致。
---  4) 原作 Sub4 是 ins_83 生成的**寄生敌机**：它的 ANM 12 是一张 512x255 的整屏叠图
---     （enm17.anm 的 entry3 = boss17b.png，script12 里在 `fsetDiv(128,4,0,±8,0)`
---     之间来回晃），Sub5 每帧把自己挪到拍照目标的位置（ins_63 + 自跳）。
---     我们拿不到那张图 ⇒ 整屏装饰交给符卡背景（不做额外的底帘 / 花瓣雨，作者要求）。
---  5) 原作的 104/105（拍照会话）、143（拍照标记）、118(0)（死亡照片 VM）、
---     149（分数倍率 1.9）、114（10208 帧的卡计时）都是 TH095 的相机 / 计分机制，
---     我们没有对应系统；卡时限改用本仓库的惯例秒数（见 CARD_TIME）。
---  6) 回收边界：原作是**弹心一越过场地边就回收**（PhotoBulletIsOutsidePlayfield，
---     th095/src/BulletManager.cpp:759-765，判据是「弹心 ± 半宽」出 384x448 的框），
---     而且全游戏共用 640 个弹槽、扫不到空槽就不发（同文件 :310-345）。
---     我们的回收边界是引擎全局的 ±224/±256（= 场地外 32 px，THlib/lib/Lscreen.lua:90-97，
---     bullet.lua:36 用的是 `lstg.world.bound*`，**弹不能单独设**）。后果：同一颗弹多活
---     ~10%，稳态同屏弹数比原作的 640 槽多一点（本关最挤的一张 = 死符，
---     7200 帧实测峰值 527）。**屏幕上看不出区别** ——
---     两种回收都发生在屏幕外（场地是 x±192 / y±224，边界都在它外面），差的只是场外
---     那几十颗的寿命，所以没有为它去改引擎的全局边界。
---  7) 判定框：Sub2 的 `ins_77(24,24)`（Sub4 的寄生敌机是 `77(8,8)`）设的是敌人判定框
---     （EclRunLow.inl:663-670 → hitboxDimensions）。TH095 没有自机子弹（th095/src 里
---     没有 PlayerBullet 一类文件，「射击键」就是快门），这个框在拍照关里读不出用处；
---     我们这边本体是要用子弹打掉的 HP Boss，判定框交给 boss_system 的默认值
---     —— 全仓库没有任何一张卡自己设过判定框，为一张卡破例反而不一致。
---  8) 自检报「贴脸狙」的只有第 4 张「死蝶浮月」一处（12 个种子实测 2~8 发、
---     最短 1~19 帧；第 6 张偶尔 1 发）：那是它 Sub7 的 ins_88 CIRCLE_AIMED 自机狙
---     大玉 —— 出膛点就是**本体所在点**，自机贴到本体身上时那一发是瞬发。那不是
---     「必中设计」：真机站到离本体 5 px 的地方会先被本体撞到，而且 6 个种子死局
---     全 0；照原作的形状留着，细节写在那张卡常量段尾的那段注释里。
---  9) 拍照扣血：原作是**拍照关** —— 本体不吃自机子弹，唯一的伤害来源就是快门，
---     拍够 N 张（N = 本卡的 ins_141，也就是相机在一关里能按的次数：
---     EclRunTargetHigh.inl:448 → EclRunHigh.inl:113 写 camera.photoLimit、
---     PhotoCamera.cpp:503 拍到上限就把相机锁死）这一关就结束。
---     我们这边相机挂在射命丸文自机上（aya.lua:191），拍照命中是
---     aya_system.lua:260-274 里 `o.class.base.take_damage2(o, 400 - Dist(...))` ——
---     400−距离 是**普通敌人**的口径（900 血的卡三张就拍死），与「拍 N 张过关」不符。
---     ⇒ 本关按作者要求把拍照那一口伤害换成**固定 1/N 血**（拍够 N 张正好清空血条，
---     见文件中部「拍照扣血」那一节）。子弹照旧能打（差异 4/7 的一贯口径：
---     本体是 HP Boss）⇒ N 张照够打完，边打边拍更快。
---=====================================

---实测（2026-09-24，本机 luajit；自检是**逐卡**跑的 —— 每张卡都清场、从 0 帧起，
---所以下面每一列都是「这一张单独打」的数，不是整关同时在场。
---★ 自检桩件里没有相机（`player.camera == nil`）⇒ photo_index() 恒返回 0，所以
---下面这些读数都是**原作 photoIndex = 0**（一张照都没拍）那一档；真机用射命丸文
---按过快门之后，弹数与密度会再往上抬。）
---  卡                             60px 内平均(1200f×6 种子)  峰值同屏弹(7200f)  威胁度
---  1 幽雅「死出の誘蛾灯」            16.4                      518             15.18
---  2 蝶符「鳳蝶紋の死槍」             6.0                      267             12.10
---  3 死符「醉人之生、死之梦幻」        6.6 ~  7.7                527              2.21
---  4 「死蝶浮月」                     5.0 ~  5.2                437              3.01
---  5 密符「御大師様の秘鍵」            3.1                      192              0.00
---  6 行符「八千万枚護摩」              6.8 ~  9.1                301              0.92
---  7 超人「飛翔役小角」                0.7 ~  1.2                151              0.23
---  （威胁度那一列是 `tools/threat.lua mod/GAME/th33.lua 1800` 的默认种子读数。）
---  · ① 泄漏扫描 ✅ —— 3600 / 7200 / 14400 帧三档，7 张卡的峰值同屏弹是平的
---    （518/518/518、266/267/268、527/527/529、147/151/151），不会随时间线性爬。
---  · ② 多种子 ✅ —— 1200 帧 × 6 个种子，最坏 `死局 2/1200 = 0.17%`（卡 6；> 3% 才要改）。
---    密度：卡 1 的 16.4 超过 §7.2 的「标准符卡 5~14」，落在「高压 13~25」一档 ——
---    那是照原版还原**两组蝶弹**之后的真实密度，不是在别处该抄的样板；卡 7 的 60px
---    栏只有 0.7~1.2，**那一栏在这张上量不准**（原因写在那张卡的注释里），照 §7.2
---    权威的那一栏看它是 151 ≥ 阈值 150（本来就是最低的一档）；其余 5 张 3.1~9.1。
---  · ③ 字段审计 ✅ —— `luajit tools/check_fields.lua mod/GAME/th33.lua`：通过。
---  · ④ `luajit tools/threat.lua mod/GAME/th33.lua 1800`：7 张全部「有限位」、
---    威胁度 0.00 ~ 15.18。文档的 0.5~1.5 是同工具量**自制卡**定的；拿它量原作移植卡
---    本来就是超区间读数（本仓库 th20.lua 的 35 张：中位 1.15、8 张 > 1.5、最高 3.99），
---    硬压到 1.5 就成了「把原作改松」，不是移植。卡 1 的 15.18 最高，那是「两组蝶弹
---    一起压」的原作形状，**不要压**；真嫌挤就调各卡常量段里的
---    RING_SPEED / CYCLE / SPEAR_SPEED —— 改前先想清楚那还是不是原作。
---  · ⑤ 拍照扣血（差异 9）**自检看不见**：桩件里没有相机，拍照这条路径根本不会
---    被走到（`player.camera == nil`）。验证方式是把三件套之外的这一条单独测：
---    照相机那两行的口径（`o.class.base.take_damage2(o, 400 - Dist(...))`）在本机
---    用真 boss.lua + 桩件跑一遍，断言「标记过的 boss：第 k 张照之后 hp = maxhp×(1−k/N)」
---    与「没标记的 boss：还是 400−距离」（25 条断言全过；脚本 /tmp/th33_photo_test.lua
---    不入库，换机器要重写一遍）。逐卡的 N 是 7/7/10/4/6/7/8（见各卡常量段）。
---=====================================

local object, boss = object, boss
local enemybase = enemybase
local task, ran = task, ran
local New, NewSimpleBullet = New, NewSimpleBullet
local PlaySound, IsValid = PlaySound, IsValid
local SetImageState, Render, RenderRect = SetImageState, Render, RenderRect
local Class = Class
local laser = laser
local sqrt = sqrt
local cos, sin, max, min = cos, sin, max, min
local lstg = lstg
local VALUE_SET = VALUE_SET
local Angle, Dist = Angle, Dist

local class = {}
_editor_class["TH33"] = class

---TH095 的世界 y → 我们的 y。理由见文件头「坐标系与角度」。
local FIELD_HALF_H = 224
local function field_y(y)
    return FIELD_HALF_H - y
end

do  -- 符卡背景
    ---和 th095.lua 的 ran_bg 用同一套白玉楼贴图（th07_8 / th07_10），但层数、
    ---转速、缩放都换一组 —— 两张卡共用一个背景会让人以为走进了同一张卡。
    ---两张同图反向自转 + 一层正片叠底是 §7.5 推荐的最省事做法。
    class.scbg = Class(_SC_BG)
    function class.scbg:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_8", false, 0, 0, 0, 0, 0, 0.35, "mul+add", 2.4, 2.4,
                function(l) l.a = 165; l.r, l.g, l.b = 255, 228, 255 end)
        _SC_BG.AddLayer(self, "th07_8", false, 0, 0, 180, 0, 0, -0.22, "mul+rev", 2.6, 2.6,
                function(l) l.r, l.g, l.b = 214, 178, 236 end)
        _SC_BG.AddLayer(self, "th07_10", false, 0, 0, 0, 0, 0, 0, "", 1.8, 1.8,
                function(l) l.a = 200 end)
    end
end

do  -- 妖梦的符卡背景
    ---同一套白玉楼贴图，但**层数、转速、缩放、配色**全换一组：幽幽子那套压在紫里，
    ---这一套压成青白（刀光 / 半灵），换人了一眼就看得出来（§7.6）。
    class.scbg2 = Class(_SC_BG)
    function class.scbg2:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_10", false, 0, 0, 90, 0, 0, -0.5, "mul+add", 3.4, 3.4,
                function(l) l.a = 150; l.r, l.g, l.b = 190, 240, 225 end)
        _SC_BG.AddLayer(self, "th07_8", false, 0, 0, 0, 0.3, 0.3, 0.8, "mul+rev", 1.6, 1.6,
                function(l) l.a = 120; l.r, l.g, l.b = 180, 215, 205 end)
        _SC_BG.AddLayer(self, "th07_10", false, 0, 0, 0, 0, 0, 0, "", 2.2, 2.2,
                function(l) l.a = 190 end)
    end
end

---──────────────────── 「已拍张数」（原作 camera.photoIndex） ────────────────────
---原作有四处读 camera.photoIndex（th095/src/EclOperandsInt.cpp:186 的 0x2761）来定弹数 /
---间隔：卡 71 的自机狙大圈间隔、卡 75 的每圈弹数、卡 74 的小圈圈数、卡 76 的俯冲速度。
---本仓库**不实现拍照** —— 项目自带拍照自机射命丸文：THlib/player/aya/aya.lua:191 给
---player 挂了 player.camera，快门由玩家自己按（aya.lua:59-62 → aya_system.lua 的
---TenguCamera:GetPhoto），每按一次 aya_system.lua:186 就给 scoredata.total_photocount +1。
---所以这里只读真相机的快门次数：
---  · 「是不是文文」= player.camera 是否存在（只有文文那个自机类挂了相机）；
---  · 张数 = scoredata.total_photocount。
---⚠ 两处偏差，都是本仓库没有对应数据造成的 —— 各卡按自己的 ins_141 上限截断，
---  所以取值范围与原作一致（例如卡 71 的 0..7），只是它会**一上来就顶到上限**：
---  · 原作的 photoIndex 是**关卡内累计**的（相机一直带在身上）；total_photocount 是
---    **整份存档**的累计值（只为成就服务，THlib/lib/Lscoredata.lua:68）
---    ⇒ 老存档上直接就是满档密度。
---  · 非文文自机没有相机（player.camera == nil）⇒ 恒为 0，也就是原作一张没拍时的数值。
---（想换判定口径只改这一个函数；各卡只给上限。）
local function photo_index(limit)
    if not (player and player.camera) then
        return 0
    end
    return min((scoredata and scoredata.total_photocount) or 0, limit)
end

---──────────────────── 拍照扣血：一张照固定扣 1/N 血 ────────────────────
---原作（TH095）是拍照关：本体不吃自机子弹，唯一的伤害来源就是快门，而且**每关的
---快门次数是有限的** —— ins_141 → EclRunTargetHigh.inl:448 的 AssignPhotoCameraLimit
---→ EclRunHigh.inl:113 写进 camera.photoLimit；PhotoCamera.cpp:503 拍到 photoLimit 张
---之后相机直接锁死（PHOTO_CAMERA_DISABLED）、这一关就结束了，PhotoStage.cpp:855 还
---按这个数生成照片格。所以「N = 本卡的 ins_141」就是原作要求拍中的张数。
---
---本仓库的相机挂在射命丸文自机上（THlib/player/aya/aya.lua:191），拍照命中走
---THlib/player/aya/aya_system.lua:260-274 的 object.EnemyNontjtDo 分支：先在取景框
---里 Math.PointInRectangle(Math.NewPoint(o), rect) 判一下，再调
---    o.class.base.take_damage2(o, 400 - Dist(框心, o))
---⇒ 「拍照拍中」这一个入口可以精确替换掉，两个前提都成立：
---  · take_damage2 在整个游戏目录里**只有这一处调用**（grep 全目录：只有
---    THlib/enemy/boss.lua:66 的定义与上面这一处调用）⇒ 包它 = 只改拍照伤害；
---  · o.class.base 对 boss 实例**就是 boss 类本身** —— 每个关卡的 boss 是
---    Class(boss, {...})（THlib/enemy/boss.lua:163 的 boss.Define），实例的 o.class
---    是那个子类、子类的 base 才是 boss，于是查到的正好是这里包过的这张表。
---于是本关卡把血条换成「拍照计数」：卡在 init 里写 self.photo_damage_rate = 1/N、
---在 del 里清掉，被拍到就固定扣 maxhp/N 血 ⇒ 拍够 N 张正好清空，和原作等价。
---没标记过的 boss（别的关卡、别的自机、卡与卡之间的空档）原样走原函数，一点不影响。
---为什么不改 aya_system.lua：THlib 是框架，改它会影响整个项目（§2 的硬约束）。
---为什么不用 onPhotoFunc：那个钩子在**取景框之外也会被调**（aya_system.lua:262 在
---PointInRectangle **之前**），要用它就得自己复刻取景框几何；take_damage2 这一层
---已经判过框了，借它的判定更准。
---⚠ 两个刻意保持原样的口径：
---  · 拍照伤害**不吃 dmg_factor**（系统的 t1 无敌 / t2 爬升）—— 原函数只乘
---    DMG_factor 与 astral_dmg_factor，这里沿用，只把伤害值换成 maxhp/N。
---  · 子弹照旧能打（本仓库对原作移植卡的一贯口径：本体是 HP Boss，见文件头差异 4）
---    ⇒ N 张照**够**打完这张卡，边打边拍会更快；「只能靠拍照打掉」是另一件事。
if not boss.photo_damage_patch then
    boss.photo_damage_patch = true
    local boss_take_damage2 = boss.take_damage2
    boss.take_damage2 = function(self, dmg)
        local rate = self.photo_damage_rate
        if not rate then
            ---本关卡没标记过的 boss：原样交给原函数（THlib/enemy/boss.lua:66）。
            return boss_take_damage2(self, dmg)
        end
        local hp_damage = self.maxhp * rate
        ---enemybase.take_damage 是「计分 / 掉落 / 受击音」那一半
        ---（THlib/enemy/enemy.lua:94），原函数也是先调它再扣血（boss.lua:66-74）；
        ---照抄，让拍的这一下该响的响、该掉的掉。
        enemybase.take_damage(self, hp_damage)
        if self.dmgmaxt then
            self.dmgt = self.dmgmaxt        -- 受击闪烁（原函数 boss.lua:68-69）
        end
        if not self.protect then
            local dmg0 = min(self.hp, hp_damage)
            self.spell_damage = self.spell_damage + dmg0
            self.hp = min(self.maxhp, self.hp - dmg0)
        end
    end
end

---给「这一张卡」的本体挂上固定的拍照扣血比例（1/limit，limit = 本卡的 ins_141）。
---init 里调（setStatus 设 maxhp 与 card.init 在同一帧，boss_system.lua:952/955），
---del 里用 photo_damage_off 收掉，免得别的 boss 沾到。
local function photo_damage_on(boss_obj, limit)
    boss_obj.photo_damage_rate = 1 / limit
end

local function photo_damage_off(boss_obj)
    boss_obj.photo_damage_rate = nil
end

---──────────────────── 两个 boss（必须先 Define、再 card.add） ────────────────────
---boss.Define(editname, name, BGM, BG, xy, SCBG, img, level)：
---  · editname = "1a" / "2a" ⇒ _editor_boss 的键是 "1a31" / "2a31"，而
---    boss.CreateGroup(1/2, 31) 按「组号 + 字母 + 关卡号」枚举，正好各建一个。
---  · ⚠ Define 必须**先于** card.add：add 会当场按 "<字母><关卡号>" 查 _editor_boss，
---    晚一行就报「找不到 boss」（boss_card.lua:119；th31.lua 那边踩过）。
---  · img = Resources/BossImage 下的行走图名，幽幽子 "Yuyuko"、妖梦 "Youmu"
---    （BossImageList.lua 里两个都登记过）。
---  · 两人共用 BGM 与背景：原作 world08 的 7 幕本来就是同一份场景资源
---    （SceneSelect.cpp:138-145 全是 world08.std + bgm/th095_04.wav）。
---  · 出生点都在左上角外（-128, 288）—— 原作每一幕的本体都从那里进场。
---
---关卡号 31（= STAGE_COUNT + 1）。2026-09-24 已按 AGENTS.md §8 注册完，一处都别漏：
---  core.lua:54              STAGE_COUNT 30 → 31
---  _editor_output.lua:47   StageID 加 "33"（顺便决定载入顺序：在 "32" 之后）
---  _editor_output.lua:49   不建自己的 BG 目录（和 TH30/31/32 一样复用别人的）
---  _editor_output.lua:1213 stage_pic 纹理循环 30 → 31
---  UI.lua:56 的 difftext   第 31 项 = "醉生梦死"（下标必须等于 level，AEX 顺延到 32）
---  UI.lua:77 的 sntext     TH33 = "醉生梦死"
---  main_stage.lua           NewStage("TH33", …) + self:Next(166)
---  defachievement.lua      成就 166
--- 素材 mod/GAME/stage_pic31.png 是**占位图**（用本关 SCBG 的 th07_8 / th07_10 拼的；
--- 顺便一提：23~30 关现在也共用同一张占位图，md5 都是 96ce7b2…），
--- 要换成真立绘直接覆盖这个文件就行。
local LEVEL = 31
boss.Define("1a", "西行寺幽幽子", "TH07_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg, "Yuyuko", LEVEL)
boss.Define("2a", "魂魄妖梦", "TH07_1", TH095_bg,
        { 128, field_y(-64) }, class.scbg2, "Youmu", LEVEL)

do  -- 71 幽雅「死出の誘蛾灯」（ecl17_a，幽幽子，组 1a 第 1 张）
    ---原作是「蛾扑向灯」：本体从场外落到中轴，**一条**发弹上下文每 9 帧甩出**两组**
    ---16 发的整圈蝶弹（像绕着灯打转的蛾群），第 10 秒再放出一只「蛾」（拍照目标）
    ---加一层自机狙大圈。骨架（/tmp/B_ecl17_a.txt）：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,128) 用 30 帧落到 (0,128)，
    ---    同时 ins_141(7) 把相机的快门上限设成 7 张。
    ---  · Sub3：t=0 起子 ECL 上下文 ins_117(0,4)（= Sub4）+ 一声 ins_106(5)；
    ---    t=600 才放拍照目标（ins_83(6) 的蛾）并起第二条上下文 ins_117(1,5)（= Sub5）。
    ---    两个 ins_117 用的都是**固定槽位**（会把上一个上下文 free 掉、不叠加，
    ---    EclRunTargetHigh.inl:206）⇒ 全场一共只有两条发弹上下文。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 t=0 的 ins_63(-128,-64)、t=100 的 ins_64(30,4,0,128)。
    ---（world08 七幕的本体都在左上角外生成，所以入场段是同一套。）
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_Y = field_y(128)                    -- 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---主弹幕（Sub4，dump 的 @860-1180）：**一条**上下文、**一轮 9 帧**、一轮发**两组** 16 发。
    ---  @920  t=0  ins_101(0, 0x20, 0, 120, -1, -0.025,  0.019635)  ← 写 slot0（被下面那行覆盖）
    ---  @960  t=0  ins_89(15, 4, 16, 1, 4.0, 1.5, floatV0, 0.0327249, 546)  ← 第 1 组：色号 4
    ---  @1004 t=0  ins_101(0, 0x20, 0, 120, -1, -0.025, -0.019635)  ← 同一个 slot 再写一遍
    ---  @1044 t=4  ins_89(15, 5, 16, 1, 4.0, 1.5, floatV1, 0.0327249, 546)  ← 第 2 组：色号 5
    ---  @1088/1124 t=4  ins_15 / ins_16(floatV0 / floatV1, 0.01309)  ← 两个基准角各 +0.75°
    ---  @1108/1144 t=4  ins_37(floatV0 / floatV1)                    ← 归一化到 (−π,π]
    ---  @1160 t=8       ins_4(0, -240) → time 设回 0、跳回 @920
    ---四条**对着源码核过**的读数（旧版注释在这四条上写错过，别再照抄）：
    ---  · ins_89 的 aimMode = opcode − 0x56 = 3 = CIRCLE（EnemyShotDispatch.cpp:145、
    ---    BulletManager.hpp:167）：angle = angle + index1×2π/count1 + index2×angleStep，
    ---    而 count2 = 1 ⇒ 操作数里那个 0.0327249 rad（1.875°）**根本没参与**
    ---    （BulletManager.cpp:368-372 的 CIRCLE 分支）。
    ---  · 一轮是 **9 帧**不是 8：ins_4 把 time 设回 0 再跳回 @920，循环体里最后一条的 time
    ---    是 8，而解释器只在 ctx->time == instruction->time 时执行（EclRun.cpp:305-320）
    ---    ⇒ time 走 0..8 共 9 帧（ins_4 本体在 EclRunLow.inl:242-246）。
    ---  · ins_37 **不是取反**、是归一化（EclRunLow.inl:357-363 调 AddNormalizeAngle，
    ---    RuntimeMath.cpp:7 把角折进 (−π,π]）⇒ 基准角是**单调 +0.75°/轮**地转，
    ---    不是来回翻（两个基准角 floatV0/floatV1 的值因此始终相同，这里只用一个 base）。
    ---  · ins_101 是「往第 N 号 transform 槽里写一条记录」（EclRunTargetHigh.inl:45-63），
    ---    同一个 slot 写两遍 = 后写的生效 ⇒ 角速度取 −0.019635 rad/帧、减速度取 −0.025/帧。
    local CYCLE, SPLIT = 9, 4               -- 一轮 9 帧；两组之间隔 4 帧（t=0 / t=4）
    local RING_COUNT = 16                   -- ins_89 的 count1 ⇒ 16 等分 22.5°
    local RING_SPEED = 4.0                  -- ins_89 的 speed1（count2 = 1 ⇒ speed2 不参与）
    local BASE_STEP = 0.75                  -- ins_15(floatV0, 0.01309 rad)
    local RING_STYLE = butterfly
    ---色号照原作：两组分别是 color 4 与 color 5。butterfly 不是 colorful 样式 ⇒
    ---贴图下标 = ceil(色号/2)（Lresources.lua:208 的 LoadImageGroup + bulletStyle.lua:64
    ---的 init），于是两组正好落在 butterfly2 / butterfly3 **两张不同的贴图**上。
    local RING_COLOR_A, RING_COLOR_B = COLOR.PURPLE, COLOR.DEEP_BLUE

    ---圈里每一颗自己会**一边转一边减速**（Sub4 的 ins_101 slot0，kind = 0x20 = 极坐标加速，
    ---PhotoBulletSpawnDescriptor.hpp:100；实现在 BulletManager.cpp:822-841 的
    ---UpdatePolarAcceleration）：每帧 angle += angleDelta、speed += speedDelta，
    ---持续 int0 = 120 帧，之后整条 transform 失效、弹保持最后的速度与方向直飞。
    ---  angleDelta = −0.019635 rad/帧 = −1.125°/帧 —— TH095 是「顺时针为正」，换算到
    ---  我们「逆时针为正」的坐标系要**取反** ⇒ +1.125°/帧（整张卡的镜像一起翻，
    ---  见文件头「坐标系与角度」）；speedDelta = −0.025/帧 ⇒ 4.0 在 120 帧里线性掉到 1.0。
    ---★ 「120 帧之后必须停」是硬要求：极坐标加速是有时长的 transform，过了就没了；
    ---  一直转下去就成了「1.0 px/帧 + 1.125°/帧」的半径 51 px 小圈 —— 子弹永远出不了
    ---  回收边界，同屏弹数会线性涨（旧版实测 1800 帧 1432 → 7200 帧 5548）。
    ---（frame 钩子只收一个参数，§5.2；「还剩几帧」存在弹自己身上。）
    local RING_SPIN = 1.125
    local RING_DRAG = -0.025
    local RING_MIN_SPEED = 1.0              -- 120 帧刚好减到 1.0，这个下限只是兜底
    local RING_FRAMES = 120

    ---自机狙大圈（Sub5，dump 的 @1204-1352）：ins_88(17, 0, 8, 1, 0.8, 1.5, 0, 0.0327249, 514)。
    ---  · opcode 88 ⇒ aimMode 2 = CIRCLE_AIMED：每一发的角度 = 自机角 + index1×2π/count1，
    ---    也就是**整圈一起转向自机**（BulletManager.cpp:367-372）。
    ---  · count1 = 8（8 等分 45°）、speed1 = 0.8（count2 = 1 ⇒ speed2 不参与）、
    ---    transformFlags 0x202 = 0x200 出场音 + 0x2 SPAWN_FAST（出场回退 4 帧的运动量，
    ---    BulletManager.cpp:445-457；我们出膛就飞）。
    ---  · 间隔由 Sub5 自己算：ins_22(extraIntV0, photoIndex, 10) → ×10、
    ---    ins_21(extraIntV0, 120, extraIntV0) → 120 − 它、ins_2 等这么多帧
    ---    ⇒ 每 max(50, 120 − 10×photoIndex) 帧一圈 —— 拍得越多压得越密。
    ---弹型 17 = 原作的**大玉**（g_PhotoBulletCollisionSizes[17] = 28，命中框取
    ---±28/2 ⇒ 半径 14；BulletManager.cpp:118-122 与 :1155），这里用本仓库最大的一档
    ---**ball_huge**（bulletStyle.lua:174-180）。原作这一发的色号是 0，但 ball_huge 是
    ---colorful 样式（贴图名 = "ball_huge"..色号），色号 0 会取到不存在的 ball_huge0
    ---（AGENTS §9 A2 会当场报错）⇒ 取同色系的紫 4，和上面两组蝶弹同一族。
    local AIM_COUNT = 8
    local AIM_SPEED = 0.8
    local AIM_STYLE = ball_huge
    local AIM_COLOR = COLOR.PURPLE
    local AIM_GAP_BASE, AIM_GAP_STEP, AIM_GAP_MIN = 120, 10, 50
    local AIM_LIMIT = 7                     -- Sub2 的 ins_141(7)：相机快门上限（photo_index 的截断值）

    ---蛾（Sub3 的 ins_83(6)，子程序 Sub6/Sub7）：原作是一只**真的子敌机** ——
    ---ins_55(12) 指 ANM、ins_143(1,99999) 挂拍照标记、ins_77(8,8) 给个小判定框，
    ---然后 Sub7 每帧 ins_63(photoTarget0.x, photoTarget0.y) 把自己挪到「拍照目标」身上；
    ---它自己**不发弹**（整份 ecl17_a 里只有 Sub4/Sub5 发弹）。
    ---我们这边没有「拍照目标」这个对象、也没有子敌机这一层（§7.3），所以按 §7.4 的 C 类
    ---做成 2 只**不出判定的蝶形装饰**绕自机飞 —— 位置含义从「拍照目标」换成「自机」，
    ---既点了「誘蛾灯」的题，也留下原作那只蛾的存在感。
    ---原作在 Sub3 的 t=600（第 10 秒）登场，这里同样是第 600 帧。
    local MOTH_WAIT = 600
    local MOTH_COUNT = 2
    local MOTH_RADIUS_X, MOTH_RADIUS_Y = 58, 30
    local MOTH_ALPHA = 170                  -- §7.6：装饰层 alpha 压在 120~180

    local CARD_NAME = "幽雅「死出の誘蛾灯」"
    local CARD_TIME = 60
    local CARD_HP = 950
    ---符卡历史槽位（跨关卡唯一）：本关 7 张取 410..415 与 416
    ---（409 被 th31.lua 的 LIST 表占走，详见死符那张的注释）。
    local CARD_ID = 410

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---一只蛾：绕自机转一个小椭圆、上下再摆一点，像绕着灯打转。
    ---纯装饰（§7.4 的 C 类无害实体）：不出判定、不撞自机，只在 render 里画贴图。
    class.moth = Class(object, {
        init = function(self, boss, phase)
            self.boss, self.phase, self.t = boss, phase, 0
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false
            self.rot = 0
            self._a = 0
            self.x, self.y = boss.x, boss.y
            task.New(self, function()
                while self._a < MOTH_ALPHA do
                    self._a = min(MOTH_ALPHA, self._a + 5)
                    task.Wait()
                end
            end)
        end,
        frame = function(self)
            self.t = self.t + 1
            local a = self.phase + self.t * 1.7
            local tx = player.x + cos(a) * MOTH_RADIUS_X
            local ty = player.y + sin(a) * MOTH_RADIUS_Y + sin(self.t * 2.3) * 10
            self.x = self.x + (tx - self.x) * 0.05
            self.y = self.y + (ty - self.y) * 0.05
            self.rot = self.rot + 2.5
        end,
        render = function(self)
            SetImageState("butterfly2", "mul+add", self._a, 235, 205, 255)
            Render("butterfly2", self.x, self.y, self.rot, 0.85)
        end,
    })

    ---圈弹每一颗的逐帧钩子：**只在前 RING_FRAMES 帧**自转 + 减速（ins_101 那条 transform
    ---的时长），之后保持最后的速度与方向直飞（理由见上面 RING_SPIN 的注释）。
    local function ring_frame(unit)
        if unit.spin_left == nil then
            unit.spin_left = RING_FRAMES
            unit.ring_v = RING_SPEED
        end
        if unit.spin_left <= 0 then
            return
        end
        unit.spin_left = unit.spin_left - 1
        unit.ring_v = max(RING_MIN_SPEED, unit.ring_v + RING_DRAG)
        object.SetV(unit, unit.ring_v, unit.rot + RING_SPIN, true)
    end

    ---一整圈 16 发的定速直线（圈里每一颗自己还要转 + 减速，见 ring_frame）。
    local function fire_ring(owner, base, color)
        for i = 0, RING_COUNT - 1 do
            NewSimpleBullet(RING_STYLE, color, owner.x, owner.y, RING_SPEED,
                    base + i * 360 / RING_COUNT, false, 0, false,
                    nil, nil, nil, ring_frame)
        end
        -- transformFlags 的 0x200 = PLAY_SPAWN_SOUND：一整圈只响一声（BulletManager.cpp:717-723）。
        PlaySound("tan00", 0.1, owner.x / 256, false)
    end

    ---主弹幕（Sub4 = ins_117(0,4) 的**子 ECL 上下文**，不是子敌机）：一条上下文、一轮两组。
    ---原作的两个基准角 floatV0/floatV1 值始终相同（都从 playerAngle 起、每轮各 +0.75°，
    ---ins_15/ins_16 各加一遍），所以这里只用一个 base，一轮里给两组共用；
    ---转的方向按坐标系换算取负（TH095 的 +0.75°/轮 ⇒ 我们的 −0.75°/轮）。
    local function ring_stream(owner)
        task.New(owner, function()
            local base = Angle(owner, player)
            while true do
                fire_ring(owner, base, RING_COLOR_A)    -- @960 t=0：色号 4
                task.Wait(SPLIT)
                fire_ring(owner, base, RING_COLOR_B)    -- @1044 t=4：色号 5
                task.Wait(CYCLE - SPLIT)
                base = (base - BASE_STEP) % 360         -- @1088/1124：ins_15/ins_16 + ins_37
            end
        end)
    end

    ---自机狙大圈（Sub5）：从原作第 600 帧起，每 max(50, 120 − 10×photoIndex) 帧一圈 8 发。
    ---aim = true ⇒ 整圈一起转到自机方向（CIRCLE_AIMED 就是把 angleToPlayer 加进每一发的角度）。
    local function aim_stream(owner)
        task.New(owner, function()
            while true do
                for i = 0, AIM_COUNT - 1 do
                    NewSimpleBullet(AIM_STYLE, AIM_COLOR, owner.x, owner.y, AIM_SPEED,
                            i * 360 / AIM_COUNT, true, 0, false)
                end
                PlaySound("tan00", 0.1, owner.x / 256, false)
                task.Wait(max(AIM_GAP_MIN,
                        AIM_GAP_BASE - AIM_GAP_STEP * photo_index(AIM_LIMIT)))
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)
    ---本卡放出的蛾；卡结束时统一收掉（§7.9 第 9 条）。
    local moths = {}

    function card:before()
        moths = {}
    end

    function card:init()
        photo_damage_on(self, AIM_LIMIT)    -- 拍照扣血：拍够 AIM_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧（Sub2 的 ins_52(3) 调用 Sub3），
            ---而 Sub3 的 t=0 同时起主弹幕上下文并响一声（ins_106(5)）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            ring_stream(self)
            ---Sub3 的 t=600：亮卡名 → 起自机狙大圈 + 放出蛾。
            ---（我们这边卡名由符卡系统在开场就亮，所以这里只做后两件。）
            task.Wait(MOTH_WAIT - ENTRY_WAIT - ENTRY_TIME)
            for i = 1, MOTH_COUNT do
                moths[i] = New(class.moth, self, (i - 1) * 180)
            end
            aim_stream(self)
        end)
    end

    ---本体的逐帧逻辑：**原作没有**（移动和发弹都在 ECL 上下文里）。frame 留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = #moths, 1, -1 do
            if IsValid(moths[i]) then
                object.RawDel(moths[i])
            end
        end
        moths = {}
    end

    local LEVEL = 31
    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end--幽雅「死出の誘蛾灯」

do  -- 73 蝶符「鳳蝶紋の死槍」（ecl17_b，幽幽子，组 1a 第 2 张）
    ---「鳳蝶紋」是凤蝶翅上的眼斑。本体站定，六只蝶形子机分三档从两侧扎进场地：
    ---起飞那一刻朝自机甩一条直激光、一片**背对自机**的乱枪，然后开始每 2 帧一发的
    ---「死槍」——0.02 px/帧 出膛、120 帧里一路加速到 ~1 px/帧 的窄扇；同时子机自己
    ---朝自机冲（原作 ins_65 把子机的 mvAngle/speed 直接设成 playerAngle / 8）。
    ---我们这边没有「敌机」这一层，子机做成不出判定的**自绘蝶**（GROUP.GHOST +
    ---colli = false），威胁全在弹与激光上（和卡 71 的蛾同一个做法）。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 的 ins_63(-128,-64) + t=100 的 ins_64(30,4,0,160) ⇒ 落点 (0,160)
    ---（TH095 坐标）⇒ 我们的 (0, field_y(160) = 64)。三张幽幽子卡的落点刻意不同。
    local BOSS_X = -128
    local BOSS_START_Y = field_y(-64)       -- 288（场地之外）
    local BOSS_HOME_Y = field_y(160)        -- 64
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---Sub3 的点位表：t=60 / t=180 / t=270 各放一对子机，t=270 的 ins_4(0,-504) 跳回
    ---循环头 ⇒ 一轮 270 帧。点位（TH095 坐标 → 我们的 y）：
    ---  (∓128, 16) → (∓128, 208)　(∓96, −32) → (∓96, 256)　(∓64, −64) → (∓64, 288)
    ---后两档在我们的场地上沿（y = 224）之外 —— 原作那四只就是从场外扎进来的。
    ---每档带自己的 (intV6, intV7)：intV6 给 Sub5 的乱枪当 count1、intV7 给 Sub4 的
    ---窄扇当 count1，(6,3) / (8,4) / (10,5)（Sub3 的 ins_6 逐档改）。
    local WAVE_PERIOD = 270
    local WAVES = {
        { delay = 60, x = 128, y = 16, fan = 3, volley = 6 },
        { delay = 120, x = 96, y = -32, fan = 4, volley = 8 },
        { delay = 90, x = 64, y = -64, fan = 5, volley = 10 },
    }

    ---子机（Sub5）在 t=60 那一帧一次做四件事：
    ---  ins_145(12, intV7, 8, playerAngle, 256, 24) —— 直激光（色号 = intV7）
    ---  ins_94(1, intV6, 64, 4.0, 0.5, playerAngle+π ± 100°, 512) —— RANDOM 乱枪
    ---  ins_117(0,4) —— 起 Sub4 子上下文（下面那个每 2 帧一发的窄扇）
    ---  ins_65(playerAngle, 8) —— 子机自己朝自机冲（8 px/帧）
    local DRONE_FIRE_DELAY = 60
    local DRONE_DASH = 8
    local LASER_COLORS = { 3, 4, 5 }        -- 三档的 intV7（3/4/5），原作拿它当色号
    local LASER_SPEED = 8                   -- ins_145 第 3 个操作数
    local LASER_LEN = 256                   -- 第 5 个：最大长度
    local LASER_GROW = LASER_LEN / LASER_SPEED  -- 32 帧长满
    local LASER_W = 10                      -- 我们 laser 的 w（命中半宽 = w/2，见 laser.lua）
    local LASER_SUSTAIN, LASER_FADE = 40, 20

    ---Sub4（子上下文）：ins_87(15, intV7, 1, 1, 0.02, 1.5, playerAngle,
    ---1.875°, 536) —— 朝自机的窄扇。FAN 且 count1 为奇数 ⇒ 角度是 0/±1.875°/±3.75°…，
    ---所以 3 发时就是「正对自机 + 左右各偏 1.875°」。
    ---536 = 0x218 = 0x200 出场音 + 0x10 矢量加速 + 0x8 慢出；ins_101(0, 0x10, 0, 120, -1,
    ---1/120, -999.99) 再给弹挂上「沿自身方向 120 帧、每帧 +1/120 px/帧」的加速
    ---（0x10 = ACCELERATE_VECTOR，BulletManager.cpp 的 UpdateVectorAcceleration），
    ---于是 0.02 一路加到 ~1.02 之后常速飞出去。
    ---★ 节拍**故意放慢 3 倍**（原作每 2 帧一发 ⇒ 这里每 6 帧）：这一手是 TH095 的核心
    ---机制在兜底 —— 拍照会把全屏弹清空（EclExtended 的 FadeOwnedCapturedBullets /
    ---ex_5），所以原作敢一次甩 640 发；我们没有这套，照原速同屏会堆到 1000+ 发
    ---（实测：峰值同屏 1003、60px 内平均 17）。圈/扇一发不少，只是变稀（同卡 71）。
    local FAN_INTERVAL = 6
    ---★ 贴脸停火：子机自己会以 8 px/帧 撞向自机（原作 ins_65），到 48 px 以内就不再发
    ---—— 否则「出膛点就在自机身上 + 0.02 px/帧」= 必中（实测最短出膛→命中 20 帧）。
    ---（原作不care这个：那 20 帧足够玩家按一次快门。）
    local FAN_STOP_DIST = 48
    local FAN_STEP = 1.875
    local FAN_SPEED = 0.02
    local FAN_ACCEL = 1 / 120
    local FAN_ACCEL_FRAMES = 120
    local FAN_STYLE = butterfly
    local FAN_COLOR = COLOR.PURPLE

    ---乱枪（ins_94，aimMode 8 = RANDOM）：angle = random(angle ∓ angleStep)、
    ---speed = random(speed2, speed1)（BulletManager.cpp 的 RANDOM 分支）。
    ---原作 angle = playerAngle + π、angleStep = ±100° ⇒ **背对自机**的 200° 扇；
    ---发数 = count1 × count2 = intV6 × 64（最多 640）—— 原作有 1600 个弹槽兜底
    ---（BulletManager.cpp 扫槽那一段），我们没有，所以 count2 从 64 砍到 12
    ---（一发 72~120 颗），扇面与速度区间照抄。
    local VOLLEY_ARC = 100
    local VOLLEY_COUNT2 = 12
    local VOLLEY_SPEED1, VOLLEY_SPEED2 = 4.0, 0.5
    local VOLLEY_STYLE = water_drop
    local VOLLEY_COLOR = COLOR.DEEP_PURPLE

    ---子机的淡入 / 淡出（它在原作里靠「飞出屏幕就回收」，我们照做）。
    local DRONE_FADE_IN = 15
    local DRONE_ALPHA = 175                  -- §7.6：装饰层 alpha 压在 120~180

    ---Sub2 的 ins_141(7)（dump 的 @464）：相机快门上限，也就是**原作要求拍中的张数**。
    ---这张卡的弹幕不读 photoIndex（原作的扇与乱枪都是定死的），所以它只用在
    ---「拍几张过关」上（见文件头「拍照扣血」那一节）。
    local PHOTO_LIMIT = 7

    local CARD_NAME = "蝶符「鳳蝶紋の死槍」"
    ---原作卡计时 ins_114(6608) ≈ 110 秒（拍照关留给玩家取景用）；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 900（同卡 71/75）。
    local CARD_HP = 900
    ---符卡历史槽位：卡 71 占了 410，这张往下取 411。
    local CARD_ID = 411

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---本卡放出的激光（卡结束时统一 RawDel，§7.9 第 9 条）。
    local lasers = {}

    ---一条「死槍」激光：CyGrow 以 8 px/帧 长到 256（32 帧）→ 维持 40 帧 → 收 20 帧。
    ---⚠ 计时**不能挂在 laser 自己身上**：laser:frame 只在真机里调 task.Do
    ---（THlib/laser/laser.lua:65），而 tools/check_stage.lua 的 laser 桩件不调 ——
    ---挂上去自检里永远不收，7200 帧会攒下上百条激光、看着像泄漏。
    ---所以计时挂在 boss 身上（boss_system 每帧 task.Do），换卡时被 task.Clear 清掉。
    local function fire_spear_laser(drone, x, y, a, color)
        local owner = drone.owner
        local l = New(laser, color, x, y, a, 0, 0, 0, LASER_W, LASER_W, 0)
        laser.CyGrow(l, LASER_SPEED, LASER_GROW, 3, a, true)
        lasers[#lasers + 1] = l
        drone.my_lasers[#drone.my_lasers + 1] = l
        task.New(owner, function()
            task.Wait(LASER_GROW + LASER_SUSTAIN)
            if IsValid(l) then
                laser._TurnOff(l, LASER_FADE, true)
                task.Wait(LASER_FADE)
                if IsValid(l) then
                    object.Del(l)
                end
            end
        end)
    end

    ---窄扇里每一颗的逐帧钩子：只在前 120 帧沿自身方向加速，之后保持末速直飞。
    ---（frame 钩子只收一个参数，§5.2；和卡 71 的 ring_frame 一样**必须停**，
    ---否则一直加速的弹永远出不了回收边界。）
    local function spear_frame(unit)
        if unit.accel_left == nil then
            unit.accel_left = FAN_ACCEL_FRAMES
            unit.cur_v = FAN_SPEED
        end
        if unit.accel_left <= 0 then
            return
        end
        unit.accel_left = unit.accel_left - 1
        unit.cur_v = unit.cur_v + FAN_ACCEL
        object.SetV(unit, unit.cur_v, unit.rot, true)
    end

    ---Sub4 的一发窄扇：count 发朝自机、左右对称展开（FAN 的奇数 count1 分支）。
    local function fire_fan(x, y, count)
        local base = Angle(x, y, player.x, player.y)
        for i = 0, count - 1 do
            local k = int((i + 1) / 2)
            if i % 2 ~= 0 then
                k = -k
            end
            NewSimpleBullet(FAN_STYLE, FAN_COLOR, x, y, FAN_SPEED,
                    base + k * FAN_STEP, false, 0, false,
                    nil, nil, nil, spear_frame)
        end
    end

    ---Sub5 的一片乱枪：整片背对自机、随机角度、随机速度。
    local function fire_volley(x, y, count)
        local center = Angle(x, y, player.x, player.y) + 180
        for _ = 1, count * VOLLEY_COUNT2 do
            NewSimpleBullet(VOLLEY_STYLE, VOLLEY_COLOR, x, y,
                    ran:Float(VOLLEY_SPEED2, VOLLEY_SPEED1),
                    center + ran:Float(-VOLLEY_ARC, VOLLEY_ARC), false, 0, false)
        end
        PlaySound("tan00", 0.1, x / 256, false)
    end

    ---蝶形子机（Sub5 的本体）。自己做自己的回收：起飞后活 DRONE_LIFE 帧就淡出，
    ---淡出期间先把自己的激光收掉（激光比子机活得久一点）。
    class.spear_drone = Class(object, {
        init = function(self, owner, x, y, fan, volley, wave)
            self.owner, self.fan, self.volley = owner, fan, volley
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false               -- 自己管回收（下面那个协程）
            self.x, self.y = x, y
            self.rot = 0
            self._a = 0
            self.my_lasers = {}
            ---一条协程干完整个 Sub5（★ 不要在里面再 task.New 一条常驻循环：
            ---tools/check_stage.lua 的协程表是全局摊平的，挂在对象名下的 while true
            ---在对象被 RawDel 之后照样会被 resume —— 自检会报「卡结束后还在发弹」。）
            task.New(self, function()
                ---fade in（§7.6：装饰层用淡入，不要凭空出现）
                for _ = 1, DRONE_FADE_IN do
                    self._a = min(DRONE_ALPHA, self._a + DRONE_ALPHA / DRONE_FADE_IN)
                    task.Wait()
                end
                ---Sub5 的 t=60：四条一起（激光 / 乱枪 / 窄扇子上下文 / 起飞）
                task.Wait(DRONE_FIRE_DELAY)
                local a = Angle(self.x, self.y, player.x, player.y)
                fire_spear_laser(self, self.x, self.y, a, LASER_COLORS[wave])
                fire_volley(self.x, self.y, volley)
                object.SetV(self, DRONE_DASH, a, true)
                ---Sub4 的窄扇：每 FAN_INTERVAL 帧一发，直到自己飞出场地为止
                ---（原作靠敌人的 offscreen 检查收掉，这里照做）。
                local w = lstg.world
                while self.x > w.l - 64 and self.x < w.r + 64
                        and self.y > w.b - 64 and self.y < w.t + 64
                        and Dist(self.x, self.y, player.x, player.y) > FAN_STOP_DIST do
                    fire_fan(self.x, self.y, fan)
                    task.Wait(FAN_INTERVAL)
                end
                ---冲出场地：淡出、把自己那几条激光一起收掉。
                for _ = 1, 20 do
                    self._a = max(0, self._a - DRONE_ALPHA / 20)
                    task.Wait()
                end
                for i = #self.my_lasers, 1, -1 do
                    if IsValid(self.my_lasers[i]) then
                        object.RawDel(self.my_lasers[i])
                    end
                end
                self.my_lasers = {}
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            task.Do(self)
            self.rot = self.rot + 4          -- 自转，让蝶看起来在扑翅
        end,
        render = function(self)
            SetImageState("butterfly2", "mul+add", self._a, 224, 186, 252)
            Render("butterfly2", self.x, self.y, self.rot, 1.15)
            SetImageState("butterfly6", "mul+add", self._a * 0.7, 196, 156, 244)
            Render("butterfly6", self.x - cos(self.rot) * 12, self.y - sin(self.rot) * 12,
                    self.rot + 40, 0.85)
        end,
    })

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)
    ---本卡放出的子机；卡结束时统一收掉（§7.9 第 9 条）。
    local drones = {}

    function card:before()
        drones = {}
        lasers = {}
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 的 ins_52(3) 调 Sub3，
            ---而 Sub3 的 t=0 就是 ins_106(5)（一个定位置的音效）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            while true do
                for wave, w in ipairs(WAVES) do
                    task.Wait(w.delay)
                    for _, sx in ipairs({ -1, 1 }) do
                        drones[#drones + 1] = New(class.spear_drone, self,
                                sx * w.x, field_y(w.y), w.fan, w.volley, wave)
                    end
                end
            end
        end)
    end

    ---本体的逐帧逻辑：**原作没有**（移动与发弹都在 ECL 上下文里）。frame 留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = #drones, 1, -1 do
            if IsValid(drones[i]) then
                ---★ 先 task.Clear 再 RawDel：协程是挂在子机名下的，
                ---自检的协程表不认「对象已死」这件事（见子机 init 里的注），
                ---不清的话那 180 帧里它还会接着发弹。
                task.Clear(drones[i])
                object.RawDel(drones[i])
            end
        end
        drones = {}
        for i = #lasers, 1, -1 do
            if IsValid(lasers[i]) then
                object.RawDel(lasers[i])
            end
        end
        lasers = {}
    end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end--蝶符「鳳蝶紋の死槍」

do  -- 75 死符「醉人之生、死之梦幻」（ecl17_c，幽幽子，组 1a 第 3 张）
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 第一帧是 ins_63(-128,-64)（绝对设位置，EclRunLow.inl 的 63 分支），
    ---t=100 的 ins_64(30,4,0,128) 用 30 帧走到 (0,128)。
    ---（ins_64 = ConfigureRelativeMotion，EclHelpers.cpp:43：以「插值到绝对目标点」
    ---的方式移动、顺带把速度清零；第 2 个操作数是缓动，1 = 二次加速、4 = 二次减速，
    ---见 th095/src/PhotoEnemyControl.hpp:18-24。）
    local BOSS_X = -128
    local BOSS_START_Y = field_y(-64)       -- 288：场地之外（上边界是 224）
    local BOSS_HOME_Y = field_y(128)        -- 96
    local ENTRY_WAIT = 100                  -- 原作 t=100 才动
    local ENTRY_TIME = 30

    ---扫动循环（Sub3）：四条腿、每条 400 帧、缓动 1/4/1/4、目标 y = 256/448/256/64，
    ---末尾 ins_4(0,-112) 跳回第一条腿（EclRunLow.inl:242-246：JUMP 把 time 设成
    ---第 1 个操作数、再按第 2 个操作数按字节跳转）。
    local LEG_TIME = 400
    local SWEEP_MID = field_y(256)          -- -32
    local SWEEP_BOTTOM = field_y(448)       -- -224（场地下沿）
    local SWEEP_TOP = field_y(64)           -- 160
    local EASE_IN = VALUE_SET.ACCEL         -- th095 缓动 1 = 二次加速（= n²）
    local EASE_OUT = VALUE_SET.DECEL        -- th095 缓动 4 = 二次减速（= 2n-n²）

    ---两股整圈弹（Sub7 / Sub8）：同一份循环体、循环头的 time 分别是 14 与 0，
    ---所以都是每 28 帧一圈、相位差 14 帧 ⇒ 合起来每 14 帧一圈。
    local RING_PERIOD = 28
    local RING_PHASE = 14
    ---ins_89 的 aimMode = opcode − 0x56 = 3 = CIRCLE（EnemyShotDispatch.cpp:145、
    ---BulletManager.hpp:165-174）：angle = index1*2π/count1 + index2*angleStep + angle，
    ---速度 = speed1（count2 = 1 时 speed2 不参与，BulletManager.cpp:345-350）。
    ---操作数里的 angleStep = 0.18479957（= 2π/34）在这张卡里**没用**：它乘的是 index2，
    ---而 count2 = 1 ⇒ index2 恒为 0。
    local RING_SPEED = 1.3
    local RING_BASE_COUNT = 32              -- ins_20：count1 = camera.photoIndex + 32
    local PHOTO_LIMIT = 10                  -- ins_141(10) ⇒ count1 上限 42（photo_index 的截断值）

    ---两股弹的样式/颜色。原作两股是 type18/color0 与 type15/color4 两道 ANM 脚本，
    ---贴图都是小玉；这里按作者要求换成**蝶与水**滴，两股一眼分得开（§7.6：一张卡
    ---只用一个色系，所以两个都压在紫里）。颜色下标是照贴图像素挑的，不是猜的：
    ---  · butterfly 有 8 行（bullet4.png 的 x=832..864），第 2 行平均 (228,201,237)
    ---    是淡紫；butterfly 的 DeFineBulletStyle 没给 colorful ⇒ 贴图下标 = ceil(色号/2)，
    ---    所以色号 4 落在第 2 行。
    ---  · water_drop 有 16 行，water_drop3 = (104,47,207) 深紫（colorful ⇒ 色号 = 下标）。
    local RING_STYLE_A = butterfly
    local RING_STYLE_B = water_drop
    local RING_COLOR_A = COLOR.PURPLE         -- Sub8 那圈：原作 type15（半径 4.0）→ butterfly（淡紫）
    local RING_COLOR_B = COLOR.DEEP_PURPLE    -- Sub7 那圈：原作 type18（半径 3.0）→ water_drop（深紫）

    local CARD_NAME = "死符「醉人之生、死之梦幻」"
    ---原作卡计时是 ins_114(10208) ≈ 170 秒 —— 那是拍照关留给玩家取景用的。
    ---我们按本仓库符卡惯例取 50 秒（th095.lua 的卡是 45~55 秒）。
    local CARD_TIME = 50
    ---原作 Timeline0 生成本体时给的生命是 150（life；我们这边的 HP 量级见 th095.lua
    ---的 550~900）。
    local CARD_HP = 900
    ---符卡历史的槽位号（spell_card_data 的键，也是符卡练习的解锁 id），跨关卡唯一。
    ---实测：把全项目的 boss.card.add 末参 **和 th31.lua 的 LIST 表第 3 项**一起数，
    ---th31 占 351..367 与 370..**409**（409 就是它 LIST 里「秘術「天文密葬法」」那行）、
    ---th32 占 368/369、本关另 6 张占 410..415，所以 1..415 全满、这张取 416。
    ---⚠ 409 这个坑说明：**只扫 boss.card.add 的末参会漏掉 th31 的 LIST**
    ---（它的 id 写在表里、由变量传进 add），照那种扫法挑的"空号"一注册就被
    ---  `check_stage.lua --all` 报「card_id 跨组重复：N（spell_card_data 会串）」。
    local CARD_ID = 416

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---Sub7 / Sub8 的一次发弹：一整圈、定速直线。
    ---count1 的操作数是变量（ins_20 把 camera.photoIndex + 32 写进 intV0），
    ---所以每圈都在发弹那一刻重读一次 —— 两条上下文读的是同一个值，永远一致。
    local function fire_ring(owner, style, color)
        local count = RING_BASE_COUNT + photo_index(PHOTO_LIMIT)
        local base = ran:Float(0, 360)      -- 原作 ins_89 的 angle = random(−π,π)
        local x, y = owner.x, owner.y
        for i = 0, count - 1 do
            NewSimpleBullet(style, color, x, y, RING_SPEED,
                    base + i * 360 / count, false, 0, false)
        end
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：整圈只响一声（BulletManager.cpp:717-723），
        -- 与逐发的出场音不同。
        PlaySound("tan00", 0.1, x / 256, false)
    end

    ---一条发弹上下文（Sub7 或 Sub8）：先等自己的相位，然后每 28 帧一圈。
    local function ring_stream(owner, phase, style, color)
        task.New(owner, function()
            task.Wait(phase)
            while true do
                fire_ring(owner, style, color)
                task.Wait(RING_PERIOD)
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        ---入场点：原作本体第一帧就把自己定到 (-128,-64)（场地外），第 100 帧才起步。
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 在 t=130 CALL Sub3，而 Sub3 的 t=0 同时
            ---起两股整圈弹、开扫动循环、响一声（ins_106(5)，一个定位置的音效）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            ring_stream(self, 0, RING_STYLE_A, RING_COLOR_A)
            ring_stream(self, RING_PHASE, RING_STYLE_B, RING_COLOR_B)
            while true do
                task.MoveTo(0, SWEEP_MID, LEG_TIME, EASE_IN)
                task.MoveTo(0, SWEEP_BOTTOM, LEG_TIME, EASE_OUT)
                task.MoveTo(0, SWEEP_MID, LEG_TIME, EASE_IN)
                task.MoveTo(0, SWEEP_TOP, LEG_TIME, EASE_OUT)
            end
        end)
    end

    ---本体的逐帧逻辑：**原作没有**。它的移动、发弹、位置跟随全在 ECL 上下文里
    ---（Sub3 的 ins_64、Sub7/Sub8 的 ins_89），我们照抄成协程；frame 留空是刻意的，
    ---不是漏写。（挂在本体上的协程由 boss_system 的 task.Clear 在换卡时统一清掉。）
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end--死符「醉人之生、死之梦幻」

do  -- 77 「死蝶浮月」（ecl17_d，幽幽子，组 1a 第 4 张）
    ---「死蝶浮月」= 一群死蝶绕着浮在空中的月亮打转。原作（/tmp/B_ecl17_d.txt）的骨架是四层：
    ---  · Sub4 + Sub3：本体在 320x64 的框里慢慢晃（ins_75 划框、ins_67 边界感知走位），
    ---  · Sub5：**两股反向自转的双色整圈**（ins_89 发弹 + ins_101 的 0x20 极坐标加速），
    ---  · Sub7：每 30 帧一圈 12 发的自机狙大玉（ins_88，type17 = 半径 14 的大玉），
    ---  · Sub6：48 根放射状激光（ins_153）—— 这张卡的招牌。
    ---激光为什么锚在本体上：ins_153 的第 11 个操作数 followPhotoTarget = 1
    ---（EclRunHigh.inl:729-750 原样照抄进 args.flags；PhotoEffect.cpp:362 的 Update
    ---把它当「每帧把 position 设到 photoTarget0 上」），而 Sub2 的 ins_109(0)
    ---把本体自己登记成了 photoTarget0（EclRunTargetHigh.inl:104-118 的 ins_109 分支）。
    ---⇒ 48 根光柱是**从「月亮」里射出来的**。我们没有相机这一层，激光直接锚在本体上。
    ---★ 两个刻意的折扣（写在这张卡的注释里，别在别的卡照抄）：
    ---  ① 激光 48 根 → **24 根**、角距 7.5° → 15°。原作有 640 个弹槽 + 拍照清屏
    ---     兜底，我们没有；48 根 16 px 宽的光柱在 r < 122 px 内是**实心**的
    ---     （角距 0.131 rad × r < 16），24 根把「实心半径」压到 61 px。
    ---  ② 自转不是原作属性（原作的 angularVelocity 是 0，靠「本体在晃」+「每轮换随机
    ---     基准角」两种运动）。我们给扇面一个慢自转（0.5°/帧），等价于原作「每轮换基准
    ---     角」的连续版，也更符合 §7.7 的「每轮至少改一个参数」。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 t=0 的 ins_63(-128,-64)、t=100 的 ins_64(30,4,0,256)。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_Y = field_y(256)                    -- -32（比中心略低）
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---扫动（Sub4）：ins_75(-160,192,160,256) 划出 x∈[-160,160]、y∈[192,256]（TH095 坐标）
    ---⇒ 我们的 y∈[field_y(256), field_y(192)] = [-32, 32]。
    ---ins_67(91,1,0.3) = 边界感知走位 91 帧、速度 0.3；t=90 的
    ---ins_66(91,4,mvAngle,0.3) 再沿**同一个方向**走 91 帧（缓动 4 = 二次减速）
    ---（BeginBoundaryAwareMove，EclDependencies.cpp:108：随机挑一个偏向自机的角度，
    ---靠墙时反射；ins_66 的 ConfigurePolarMotion 见 EclHelpers.cpp:28）。
    ---⇒ 一轮 181 帧、走 ~54 px。原作 0.3 px/帧 是真的慢，「浮月」本来就不该乱跑。
    local BOX_L, BOX_R = -160, 160
    local BOX_B, BOX_T = field_y(256), field_y(192)     -- -32 / 32
    local LEG_TIME = 91
    local SWEEP_SPEED = 0.3
    local SWEEP_SPREAD = 40                  -- 方向相对「自机方向」的散角（度）

    ---双色环（Sub5）：整圈 16 发（ins_89(22, 4, 16, 1, 1.0, 1.5, floatV0, 0.0327249)，
    ---type22 = 半径 4、color 4；t=20 再发一圈 color 5）、速 1.0；
    ---ins_101(1, 0x20, 0, 600, -1, 0, ±0.0261799) 给弹挂上
    ---「每帧 angle ± 1.5°、速度不变、持续 600 帧」的极坐标加速（BulletManager.cpp
    ---的 ACCELERATE_POLAR：exStates[2].angleDelta）。t=40 的 ins_4(0,-248) 跳回
    ---@1240（也就是 t=0 那两条 ins_101）⇒ **41 帧一轮、一轮两圈**。
    ---半径 = v/ω = 1.0 / 0.02618 = 38 px ⇒ 一圈蝶会绕着出发点卷成一个小旋涡（母题正中）。
    ---★ 6 → 4.0 帧的转向时长：原作 600 帧（10 秒）里蝶一直绕圈，全游戏靠拍照清屏兜底；
    ---我们的这张卡 55 秒，600 帧会攒到 400+ 发挤成一个实心团，所以 240 帧
    ---（3.6 秒、转 540°）之后放它们直线飞出去（见 swirl_frame 的注释）。
    local RING_PERIOD = 41
    local RING_PHASE = 20                    -- 两圈相隔 20 帧（t=0 与 t=20）
    local RING_COUNT = 16
    local RING_SPEED = 1.0
    local RING_SPIN = 1.5                    -- ±1.5°/帧
    local RING_SPIN_FRAMES = 240
    local RING_STYLE_A, RING_STYLE_B = butterfly, butterfly
    ---颜色下标是照贴图挑的（LoadImageGroup('butterfly','bullet4',832,0,32,32,1,8) 的
    ---8 行；非 colorful ⇒ 贴图号 = ceil(色号/2)）：
    ---色号 4 → butterfly2 = (228,201,237) 淡紫；色号 5 → butterfly3 = (190,190,242) 蓝紫。
    ---两个都在紫系里、又一眼分得开（§7.6）。
    local RING_COLOR_A, RING_COLOR_B = COLOR.PURPLE, COLOR.DEEP_BLUE

    ---小环（Sub7）：ins_88(17, 1, 12, 1, 2.5, 1.5, 0, 0.0327249, 514) = CIRCLE_AIMED、
    ---type17（半径 14 的大玉）12 发、整圈、速 2.5；ins_4(0,-44) 跳回 t=0 ⇒ 每 30 帧。
    ---原作那个大玉我们没贴图（本仓库最大的 ball_big 只有半径 8），按本关的约定
    ---借 water_drop 当「大而慢」的那一层（同卡 71 的自机狙大圈）。
    local TICK_FIRST = 470 - ENTRY_WAIT - ENTRY_TIME   -- 原作 t=470 起
    local TICK_PERIOD = 30
    local TICK_COUNT = 12
    local TICK_SPEED = 2.5
    local TICK_STYLE = water_drop
    local TICK_COLOR = COLOR.DEEP_PURPLE
    ---★ 自检偶尔会报这张「贴脸狙」（最多 8 发/1200 帧、最短 0 帧）：小环是 ins_88
    ---的 CIRCLE_AIMED、出膛点就是**本体所在点**，所以自机贴在本体身上时那颗是瞬发。
    ---那不是「必中设计」—— 自机站在离本体 5 px 的地方，真机上先被本体撞到；
    ---6 个种子死局全 0，所以照原作的形状留着。

    ---激光扇（Sub6）：ins_153(12, 3, floatV0, 512, 16, 120, 20, 60, 20, 0, 1)
    ---  type 12、color 3、基准角 = random(-π,π)、最大长度 512、最大宽度 16、
    ---  前摇 120 帧 → 张开 20 帧 → 维持 60 帧 → 收 20 帧，followPhotoTarget = 1。
    ---  ins_15(floatV0, 0.1309) + ins_5(0,-84,extraIntV0=48) ⇒ 48 根、每根差 7.5°。
    ---  命中半宽 = 宽度/2 = 8（PhotoEffect.cpp:436-440：width < 32 时取 width*0.5），
    ---  我们的 laser 命中半宽 = w/2 ⇒ LASER_W 也填 16。
    ---前摇我们压到 48 帧（原作 120 帧是留给玩家对焦按快门的）；「张开」用我们的
    ---laser:_TurnOn(GROW) 做（alpha 与 w 一起涨 ⇒ 视觉上就是一根细线亮起来）。
    local FAN_FIRST = 320 - ENTRY_WAIT - ENTRY_TIME     -- 原作 t=320 第一轮
    local FAN_INTERVAL = 530                 -- 一轮 530 帧（Sub3 的 ins_4(470,-20) 周期）
    local FAN_COUNT = 24
    local FAN_WARN = 48
    local FAN_GROW = 12
    local FAN_HOLD = 60
    local FAN_FADE = 20
    local FAN_SPIN = 0.5                     -- 扇面自转（度/帧）
    local LASER_INDEX = 3                    -- 原作的 color 3（laser 的颜色下标 1..16）
    local LASER_W = 16                       -- 命中半宽 = 8
    local LASER_LEN = 400                    -- 原作 512；我们的场地对角线 ~470 够用
    ---laser1 的贴图是 64+128+64 = 256 px 三段，按 LASER_LEN 的比例切 ⇒ 拉长 1.56 倍。
    local LASER_SEG1, LASER_SEG2 = LASER_LEN * 0.25, LASER_LEN * 0.5

    ---死蝶（Sub3 的 ins_83(4) + t=380 的 ins_83(8)）：原作放出来的是敌机
    ---（ins_83 的 TH095 分支见 EclRunTargetHigh.inl:271-281），这里按 §7.4 的 C 类
    ---做成**不出判定的蝶形装饰**绕本体飞 —— 正好接住「死蝶」这层意思。
    local MOTH_FIRST, MOTH_MORE = 0, 380 - ENTRY_WAIT - ENTRY_TIME
    local MOTH_COUNT1, MOTH_COUNT2 = 4, 8
    local MOTH_ALPHA = 165                   -- §7.6：装饰层 alpha 压在 120~180

    ---Sub2 的 ins_141(4)（dump 的 @468）：相机快门上限，也就是**原作要求拍中的张数**。
    ---这张卡的弹幕不读 photoIndex（原作四层都是定死的），所以它只用在「拍几张过关」上
    ---（见文件头「拍照扣血」那一节）。
    local PHOTO_LIMIT = 4

    local CARD_NAME = "「死蝶浮月」"
    ---原作卡计时 ins_114(8408) ≈ 140 秒（拍照关留给玩家取景用）；沿用本仓库的 55 秒。
    local CARD_TIME = 55
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 1000（本卡四层同时压）。
    local CARD_HP = 1000
    ---符卡历史槽位：410/411 已被卡 71/73 占掉、416 被卡 75 占掉，这张取 412。
    local CARD_ID = 412

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---本卡放出的激光与死蝶（卡结束时统一收掉，§7.9 第 9 条）。
    local lasers = {}
    local moths = {}

    ---双色环里每一颗的逐帧钩子：前 RING_SPIN_FRAMES 帧每帧把方向拧 ±RING_SPIN 度
    ---（速度不变 ⇒ 极坐标加速，跟原作 ins_101 的 0x20 一致），之后放开直线飞走。
    ---（frame 钩子只收一个参数，§5.2；**必须停**，否则弹永远绕在原地。）
    local function swirl_frame(unit)
        if unit.spin_left == nil then
            unit.spin_left = RING_SPIN_FRAMES
        end
        if unit.spin_left <= 0 then
            return
        end
        unit.spin_left = unit.spin_left - 1
        object.SetV(unit, RING_SPEED, unit.rot + unit.spin, true)
    end

    ---一整圈 RING_COUNT 发（原作 ins_89：CIRCLE，count2 = 1 ⇒ 操作数里的 angleStep 不参与）。
    ---spin = ±RING_SPIN，两圈反向自转 ⇒ 一眼看得出是两个旋涡错开转。
    local function fire_ring(owner, base, color, spin)
        local x, y = owner.x, owner.y
        for i = 0, RING_COUNT - 1 do
            local b = NewSimpleBullet(RING_STYLE_A, color, x, y, RING_SPEED,
                    base + i * 360 / RING_COUNT, false, 0, false,
                    nil, nil, nil, swirl_frame)
            b.spin = spin
        end
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：整圈只响一声（BulletManager.cpp:717-723）。
        PlaySound("tan00", 0.1, x / 256, false)
    end

    ---一股双色环（Sub5）：每 RING_PERIOD 帧两圈（相隔 RING_PHASE 帧），两圈反向自转。
    ---基准角只在 Sub5 进入时读一次自机角（原作 @1200/@1220 读进 floatV0/floatV1，
    ---而循环跳回的是 @1240、跳过了那两条）⇒ 之后每轮都用同一个基准角。
    ---整圈是对称的，基准角只决定相位，所以这里固定取 0 就等价。
    local function swirl_stream(owner)
        task.New(owner, function()
            local spin = RING_SPIN
            while true do
                fire_ring(owner, 0, RING_COLOR_A, spin)
                task.Wait(RING_PHASE)
                fire_ring(owner, 0, RING_COLOR_B, -spin)
                task.Wait(RING_PERIOD - RING_PHASE)
                spin = -spin                       -- §7.7：每轮换一个参数
            end
        end)
    end

    ---小环（Sub7）：每 30 帧一圈 12 发整圈大玉。原作是 CIRCLE_AIMED（基准角 = 自机角），
    ---我们把整圈的相位跟着自机走（对称图案看不出朝向，但相位会跟着转，和原作一致）。
    local function fire_tick(owner)
        local base = Angle(owner.x, owner.y, player.x, player.y)
        for i = 0, TICK_COUNT - 1 do
            NewSimpleBullet(TICK_STYLE, TICK_COLOR, owner.x, owner.y, TICK_SPEED,
                    base + i * 360 / TICK_COUNT, false, 0, false)
        end
        PlaySound("tan00", 0.1, owner.x / 256, false)
    end

    ---一根扇激光（原作 ins_153，PhotoEffect.cpp 的 PhotoRotatingLaserView）。
    ---生命周期四段：前摇（细白线预警）→ 张开（w 0→LASER_W）→ 维持 → 收。
    ---★ 计时**挂在 boss 身上**（见 fire_fan）：laser:frame 只在真机里被调，
    ---tools/check_stage.lua 的 laser 桩件既不调 task.Do、`_TurnOn` 也是空函数，
    ---挂 laser 自己的话自检里既不会亮也不会收 —— 卡 73 踩过这个坑。
    class.fan_laser = Class(laser, {
        init = function(self, x, y, a)
            laser.init(self, LASER_INDEX, x, y, a,
                    LASER_SEG1, LASER_SEG2, LASER_SEG1, LASER_W, 0, 0)
            self.warn = FAN_WARN
        end,
        frame = function(self)
            laser.frame(self)
            if self.warn > 0 then
                ---前摇期间把宽度和亮度按死在 0：**不能有判定**（§7.8 第 4 条：
                ---预警不是墙）。laser:frame 里 alpha > 0.999 才判命中，所以 w/alpha 归零即可。
                self.warn = self.warn - 1
                self.w, self.alpha = 0, 0
            end
        end,
        render = function(self)
            if self.warn > 0 then
                ---细白线：全长的预警，粗细按像素给（§C4）—— white 是 16x16，
                ---Render 的 hscale 是「倍数」⇒ LASER_LEN/16 才是全长，0.2 = 3.2 px 粗。
                ---亮度恒正（§C4）：120 + 60*sin(...) ∈ [60,180]。
                local k = 1 - self.warn / FAN_WARN
                SetImageState("white", "mul+add", 120 + 60 * sin(self.timer * 8), 255, 235, 255)
                Render("white", self.x + cos(self.rot) * LASER_LEN * 0.5,
                        self.y + sin(self.rot) * LASER_LEN * 0.5,
                        self.rot, LASER_LEN / 16, 0.2)
            else
                laser.render(self)
            end
        end,
    })

    ---一轮激光扇（Sub6）：FAN_COUNT 根、角距 360/FAN_COUNT，锚在本体上跟着本体走
    ---（原作 followPhotoTarget 的等价物），扇面自己慢转 FAN_SPIN 度/帧。
    local function fire_fan(owner)
        local base = ran:Float(0, 360)          -- 原作 ins_153 的 angle = random(-π,π)
        local fan = {}
        for i = 0, FAN_COUNT - 1 do
            local l = New(class.fan_laser, owner.x, owner.y, base + i * 360 / FAN_COUNT)
            fan[#fan + 1] = l
            lasers[#lasers + 1] = l
        end
        ---一条协程干完这一轮（★ 不要再在 laser 名下开 task：见 fan_laser 的注释）。
        task.New(owner, function()
            ---前摇：预警线跟着本体+扇面转
            for _ = 1, FAN_WARN do
                for i = 1, #fan do
                    local l = fan[i]
                    if IsValid(l) then
                        l.rot = l.rot + FAN_SPIN
                        l.x, l.y = owner.x, owner.y
                    end
                end
                task.Wait()
            end
            PlaySound("lazer00", 0.25, owner.x / 200)
            for i = 1, #fan do
                laser._TurnOn(fan[i], FAN_GROW, false)
            end
            for _ = 1, FAN_GROW + FAN_HOLD do
                for i = 1, #fan do
                    local l = fan[i]
                    if IsValid(l) then
                        l.rot = l.rot + FAN_SPIN
                        l.x, l.y = owner.x, owner.y
                    end
                end
                task.Wait()
            end
            for i = 1, #fan do
                laser._TurnOff(fan[i], FAN_FADE)
            end
            for _ = 1, FAN_FADE do
                task.Wait()
            end
            for i = #fan, 1, -1 do
                if IsValid(fan[i]) then
                    object.RawDel(fan[i])
                end
            end
        end)
    end

    ---本体在框里慢慢晃（Sub4）：先朝自机方向 ±SWEEP_SPREAD 度挑一个角度走 LEG_TIME 帧
    ---（缓动 1 = 二次加速），再沿同一方向走 LEG_TIME 帧（缓动 4 = 二次减速）。
    ---框是凸的 ⇒ 在框内的两点之间直线插值不会跑出框，所以直接把目标点夹进框里就行
    ---（原作的 ins_75 夹取是引擎行为：TH095_ECL_ENEMY_FLAG_CLAMP_TO_MOVEMENT_BOUNDS）。
    local function sweep(owner)
        task.New(owner, function()
            while true do
                local a = Angle(owner.x, owner.y, player.x, player.y)
                        + ran:Float(-SWEEP_SPREAD, SWEEP_SPREAD)
                local step = SWEEP_SPEED * LEG_TIME
                local tx = max(BOX_L, min(BOX_R, owner.x + step * cos(a)))
                local ty = max(BOX_B, min(BOX_T, owner.y + step * sin(a)))
                task.MoveTo(tx, ty, LEG_TIME, VALUE_SET.ACCEL)
                tx = max(BOX_L, min(BOX_R, tx + step * cos(a)))
                ty = max(BOX_B, min(BOX_T, ty + step * sin(a)))
                task.MoveTo(tx, ty, LEG_TIME, EASE_OUT)
            end
        end)
    end

    ---一只死蝶：绕本体转一个小椭圆（母题：绕着月亮飞的蝶），半径各有不同（§7.7 第 2 条）。
    ---纯装饰（§7.4 的 C 类无害实体）：不出判定、不撞自机，只在 render 里画贴图。
    class.dead_moth = Class(object, {
        init = function(self, owner, phase, radius)
            self.owner, self.phase, self.t = owner, phase, 0
            self.radius = radius
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false
            self.rot = 0
            self._a = 0
            self.x, self.y = owner.x, owner.y
            task.New(self, function()
                for _ = 1, 30 do
                    self._a = min(MOTH_ALPHA, self._a + MOTH_ALPHA / 30)
                    task.Wait()
                end
            end)
        end,
        frame = function(self)
            if not IsValid(self.owner) then
                object.RawDel(self)
                return
            end
            self.t = self.t + 1
            local a = self.phase + self.t * (1.1 + self.radius / 200)
            local tx = self.owner.x + cos(a) * self.radius
            local ty = self.owner.y + sin(a) * self.radius * 0.55
            self.x = self.x + (tx - self.x) * 0.06
            self.y = self.y + (ty - self.y) * 0.06
            self.rot = self.rot + 3
        end,
        render = function(self)
            SetImageState("butterfly2", "mul+add", self._a, 226, 200, 245)
            Render("butterfly2", self.x, self.y, self.rot, 0.9)
        end,
    })

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
        lasers = {}
        moths = {}
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 的 t=130 同时 ins_52(3)（Sub3 本体脚本，含
            ---ins_83(4) 放 4 只死蝶）和 Sub4（扫动 + Sub5 的双色环）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            for i = 1, MOTH_COUNT1 do
                moths[#moths + 1] = New(class.dead_moth, self, (i - 1) * 360 / MOTH_COUNT1,
                        46 + i * 6)
            end
            swirl_stream(self)
            sweep(self)
            ---Sub3 的 t=380：亮卡名 + 再放 8 只死蝶（ins_83(8)）。
            task.Wait(MOTH_MORE)
            for i = 1, MOTH_COUNT2 do
                moths[#moths + 1] = New(class.dead_moth, self, (i - 1) * 360 / MOTH_COUNT2,
                        64 + i * 5)
            end
            ---Sub3 的 t=320 起第一轮激光扇，之后每 FAN_INTERVAL 帧一轮。
            ---（原作的时间轴：t=320 第一轮、t=910 第二轮，之后每 530 帧一轮；
            ---这里从第一轮起就按 530 的周期走，差的一轮在 55 秒的卡里看不出来。）
            task.Wait(FAN_FIRST - MOTH_MORE)
            while true do
                fire_fan(self)
                task.Wait(FAN_INTERVAL)
            end
        end)
        ---Sub7 的小环：原作 t=470 起到卡结束。
        task.New(self, function()
            task.Wait(TICK_FIRST)
            while true do
                fire_tick(self)
                task.Wait(TICK_PERIOD)
            end
        end)
    end

    ---本体的逐帧逻辑：**原作没有**（移动、发弹都在 ECL 上下文里）。frame 留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = #lasers, 1, -1 do
            if IsValid(lasers[i]) then
                object.RawDel(lasers[i])
            end
        end
        lasers = {}
        for i = #moths, 1, -1 do
            if IsValid(moths[i]) then
                task.Clear(moths[i])
                object.RawDel(moths[i])
            end
        end
        moths = {}
    end

    boss.card.add({ { card, "1a" } }, LEVEL, CARD_NAME, CARD_ID)
end--「死蝶浮月」

do  -- 72 密符「御大師様の秘鍵」（ecl16_b，妖梦，组 2a 第 1 张）
    ---「御大師様の秘鍵」= 空海（御大師）传下来的密教法器。原作的骨架（/tmp/B_ecl16_b.txt）：
    ---  · Sub2/Sub6：本体在一条**很扁的横带**里（ins_75(-160,128,160,144) ⇒ 我们的 y∈[80,96]）
    ---    每 60 帧做一次 ins_67(30,4,4) 的边界感知走位（30 帧、4 px/帧 ⇒ 一次挪 120 px），
    ---  · Sub3：每 60 帧重启两个子上下文 ——
    ---      Sub4 = 每 45 帧一发「自机狙小弹」，**photoIndex ≥ 3 才开火**
    ---      （ins_44(photoIndex,3,0,72) = 小于则跳过，EclRunLow.inl:409 的比较分支），
    ---      Sub5 = 每 61 帧往**绝对 (±128, -32)** 各放一把「钥匙」
    ---      （ins_26 先把偏移算成 (-128−pos.x)/(-32−pos.y)，ins_84 再加父坐标，
    ---       所以落点是绝对的场地外左上/右上角），
    ---  · Sub8 = 钥匙本体：朝下飞（ins_65(π/2, 2)），并且每 31 帧甩一次
    ---    Sub7 的**旋转三连**（ins_87 的 FAN、count1=3 ⇒ 基准角 ±90°，每轮 +5.625°，
    ---    一轮甩 12+rand(0..15) 次 ⇒ 原作一发就是 36~81 发）。
    ---我们这边的三处折扣（都写在这张卡的注释里）：
    ---  ① 「钥匙」做成**不出判定的法器装饰**（§7.4 的 C 类）—— 原作的子敌机本体能撞死人，
    ---     跟卡 71 的蛾 / 卡 73 的蝶子机一样，威胁全交给弹。
    ---  ② 三连的**轮数** 12+rand(0..15) → 3 + photoIndex/3（3~5 轮 ⇒ 9~15 发）：
    ---     原作一次 36~81 发是全游戏 640 弹槽 + 拍照清屏兜底，我们没有。
    ---  ③ 一轮的间隔 31 → 45 帧；钥匙飞出场地就淡出收掉（原作挂到 t=2000 才退役）。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 t=0 的 ins_63(-128,-64)、t=100 的 ins_64(30,4,0,160)。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_Y = field_y(160)                    -- 64
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---横带与「挪一格」（Sub6 的 ins_67(30,4,4) + Sub3 每 60 帧的节奏）：
    ---ins_75 划的是 x∈[-160,160]、y∈[128,144]（TH095）⇒ 我们的 y∈[field_y(144), field_y(128)]。
    local BAND_L, BAND_R = -160, 160
    local BAND_B, BAND_T = field_y(144), field_y(128)   -- 80 / 96
    local SCOOT_PERIOD, SCOOT_TIME = 60, 30
    local SCOOT_SPEED = 4

    ---钥匙（Sub5 的 ins_84 + Sub8）：
    ---  落点 = 绝对 (±KEY_SPAWN_X, KEY_SPAWN_Y)、两次相隔 KEY_GAP 帧（t=0 与 t=30）；
    ---  朝下飞（TH095 的 π/2 是 +y ⇒ 我们的 -90°）、速度 2（ins_65 的第 2 个操作数）；
    ---  每 KEY_BURST_PERIOD 帧甩一次旋转三连。
    local KEY_SPAWN_X = 128
    local KEY_SPAWN_Y = field_y(-32)                    -- 256（场地上沿之外）
    local KEY_GAP = 30
    local KEY_SPEED = 2
    local KEY_DOWN = -90
    local KEY_FADE_IN, KEY_FADE_OUT = 20, 25
    local KEY_ALPHA = 170                   -- §7.6：装饰层 alpha 压在 120~180
    local KEY_BURST_PERIOD = 45
    local KEY_BURST_BASE = 3                -- 轮数 = KEY_BURST_BASE + photoIndex/3（原作 12+rand(0..15)）
    ---★ 贴脸停火（原作**没有**这一条，是本仓库的补丁）：钥匙是**不出判定的装饰**，
    ---要是它正好从自机身上碾过去还甩一轮三连，出膛到命中只有 2 帧 = 必中
    ---（实测：加这条之前自检报「贴脸狙 39 发、最短 2 帧」）。原作靠两件事绕开这个问题 ——
    ---钥匙本体是**敌机**（撞到就死，玩家自己会躲）和拍照清屏。
    ---这里借原作自己的机制做：ins_82 的 minimumPlayerDistanceSquared —— 距离小于阈值时
    ---那一发**整轮放弃**（EnemyShotDispatch.cpp:107-118 就是这个 early return），
    ---阈值取 72 px ⇒ 2 px/帧 的弹留 36 帧反应时间（>20 帧）。
    local KEY_STOP_DIST = 72
    local KEY_BURST_STEP = 5.625            -- ins_15(floatV0, 0.0981748) = 5.625°
    local KEY_STEP = 90                     -- ins_87 的 angleStep = π/2
    local KEY_AIM0 = 90                     -- ins_87 的 angle = -π/2（TH095 朝上）⇒ 我们的 +90°
    local KEY_BULLET_SPEED = 2.0
    local KEY_STYLE = butterfly
    ---颜色：butterfly 非 colorful ⇒ 贴图号 = ceil(色号/2)；色号 8 → butterfly4 = (193,216,235) 冰蓝。
    local KEY_COLOR = COLOR.CYAN

    ---自机狙小弹（Sub4）：ins_86(12, 1, 1, 1, 1.5, 1.5, 0, π/2, 514) = FAN_AIMED、
    ---count1 = 1 ⇒ 单发、正对自机；type12（半径 5）、速 1.5；每 45 帧一发。
    ---★ 原作只在 camera.photoIndex ≥ 3 之后才打（ins_44）—— 这是拍照关「拍够了才开始
    ---给你上强度」的设计，我们照抄：photo_index(PHOTO_LIMIT) < 3 时这一层不存在。
    local AIM_PERIOD = 45
    local AIM_FROM_PHOTO = 3
    local AIM_SPEED = 1.5
    local AIM_STYLE = water_drop
    local AIM_COLOR = COLOR.CYAN            -- water_drop 是 colorful ⇒ 色号 8 = 亮青 (70,204,207)

    local PHOTO_LIMIT = 6                   -- Sub2 的 ins_141(6)：相机快门上限（photo_index 的截断值）

    local CARD_NAME = "密符「御大師様の秘鍵」"
    ---原作卡计时 ins_114(6608) ≈ 110 秒（拍照关留给玩家取景用）；沿用本仓库的 55 秒。
    local CARD_TIME = 55
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 900。
    local CARD_HP = 900
    ---符卡历史槽位：410..412 已被卡 71/73/77 占掉、416 被卡 75 占掉，这张取 413。
    local CARD_ID = 413

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---本卡放出的钥匙（卡结束时统一收掉，§7.9 第 9 条）。
    local keys = {}

    ---一次「旋转三连」（原作 Sub7）：轮数随拍到的张数变多，每轮的基准角再 +5.625°，
    ---三发分别在 base、base±90°（FAN 的奇数 count1 分支，和卡 73 的 fire_fan 同一条公式）。
    ---基准角在轮与轮之间**累加**（原作 floatV0 的 ins_15 写在循环体里、跨轮不重置）。
    local function fire_burst(key)
        local n = KEY_BURST_BASE + int(photo_index(PHOTO_LIMIT) / 3)
        for k = 1, n do
            local base = key.aim + (k - 1) * KEY_BURST_STEP
            for _, off in ipairs({ 0, KEY_STEP, -KEY_STEP }) do
                NewSimpleBullet(KEY_STYLE, KEY_COLOR, key.x, key.y, KEY_BULLET_SPEED,
                        base + off, false, 0, false)
            end
        end
        key.aim = key.aim + n * KEY_BURST_STEP
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：一轮只响一声（BulletManager.cpp:717-723）。
        PlaySound("tan00", 0.1, key.x / 256, false)
    end

    ---一把「秘鍵」（原作 Sub8）：场地外飘进来 → 一边往下走一边甩三连 → 出场地淡出。
    ---纯装饰实体（§7.4 的 C 类无害实体）：不出判定、不撞自机，只在 render 里画贴图。
    ---★ 一条协程干完整个生命周期（不要在对象名下再开 `while true`）：
    ---  tools/check_stage.lua 的协程表不认「对象已死」，被 RawDel 之后还会接着被 resume
    ---  —— 卡 73 的蝶子机踩过，自检会报「卡结束后还在发弹」。
    class.key = Class(object, {
        init = function(self, x, y)
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false
            self.x, self.y = x, y
            self.rot, self._a = 0, 0
            self.aim = KEY_AIM0
            task.New(self, function()
                for _ = 1, KEY_FADE_IN do
                    self._a = min(KEY_ALPHA, self._a + KEY_ALPHA / KEY_FADE_IN)
                    task.Wait()
                end
                object.SetV(self, KEY_SPEED, KEY_DOWN, true)
                local w = lstg.world
                while self.y > w.b - 64 do
                    if Dist(self.x, self.y, player.x, player.y) > KEY_STOP_DIST then
                        fire_burst(self)
                    end
                    task.Wait(KEY_BURST_PERIOD)
                end
                ---冲出场地：淡出再收（§7.8 第 4 条：不许突然消失）。
                for _ = 1, KEY_FADE_OUT do
                    self._a = max(0, self._a - KEY_ALPHA / KEY_FADE_OUT)
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            task.Do(self)
            self.rot = self.rot - 2.5        -- 和卡 73 的蝶子机反着转（§7.7 第 2 条）
        end,
        render = function(self)
            SetImageState("servant", "mul+add", self._a, 175, 240, 240)
            Render("servant", self.x, self.y, self.rot, 1.05)
        end,
    })

    ---本体横着挪一格（Sub6）：朝自机方向 ±60° 挑一个角度走 30 帧、一共 120 px。
    ---带子是凸的 ⇒ 把目标点夹进带里就等价于引擎的 CLAMP_TO_MOVEMENT_BOUNDS。
    local function scoot(owner)
        task.New(owner, function()
            while true do
                local a = Angle(owner.x, owner.y, player.x, player.y)
                        + ran:Float(-60, 60)
                local step = SCOOT_SPEED * SCOOT_TIME
                local tx = max(BAND_L, min(BAND_R, owner.x + step * cos(a)))
                local ty = max(BAND_B, min(BAND_T, owner.y + step * sin(a)))
                task.MoveTo(tx, ty, SCOOT_TIME, VALUE_SET.NORMAL)
                task.Wait(SCOOT_PERIOD - SCOOT_TIME)
            end
        end)
    end

    ---两把钥匙（Sub5）：相隔 KEY_GAP 帧、一左一右落在场地外，然后各自往下飘。
    local function key_stream(owner)
        task.New(owner, function()
            while true do
                keys[#keys + 1] = New(class.key, -KEY_SPAWN_X, KEY_SPAWN_Y)
                task.Wait(KEY_GAP)
                keys[#keys + 1] = New(class.key, KEY_SPAWN_X, KEY_SPAWN_Y)
                task.Wait(SCOOT_PERIOD - KEY_GAP)
            end
        end)
    end

    ---自机狙小弹（Sub4）：photoIndex ≥ AIM_FROM_PHOTO 之后，每 45 帧一发正对自机。
    local function aim_stream(owner)
        task.New(owner, function()
            while true do
                task.Wait(AIM_PERIOD)
                if photo_index(PHOTO_LIMIT) >= AIM_FROM_PHOTO then
                    local a = Angle(owner.x, owner.y, player.x, player.y)
                    NewSimpleBullet(AIM_STYLE, AIM_COLOR, owner.x, owner.y, AIM_SPEED, a,
                            false, 0, false)
                end
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
        keys = {}
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 的 t=130 是 ins_104（亮卡名）+ ins_52(3)
            ---（Sub3 = 起点两个子上下文、每 60 帧一次挪位）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            aim_stream(self)
            key_stream(self)
            scoot(self)
        end)
    end

    ---本体的逐帧逻辑：**原作没有**（移动、发弹都在 ECL 上下文里）。frame 留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = #keys, 1, -1 do
            if IsValid(keys[i]) then
                ---★ 先 task.Clear 再 RawDel：协程挂在钥匙名下，自检的协程表不认「对象已死」
                ---（见 class.key 的注释），不清的话它还会接着发弹。
                task.Clear(keys[i])
                object.RawDel(keys[i])
            end
        end
        keys = {}
    end

    boss.card.add({ { card, "2a" } }, LEVEL, CARD_NAME, CARD_ID)
end--密符「御大師様の秘鍵」

do  -- 74 行符「八千万枚護摩」（ecl16_c，妖梦，组 2a 第 2 张）
    ---「護摩」是密教用火烧护摩木的修行，八千万枚 = 烧掉的木条数。原作的骨架
    ---（/tmp/B_ecl16_c.txt）：
    ---  · Sub5（主体脚本）：t=0 一记 **128 根的整扇**（ins_87，count1=128 ⇒ 每根差 1.875°、
    ---    以自机方向为中心铺开 ±119°），t=15 的 ins_5(0,-44,4) 又把这一扇**原地再放 4 次**，
    ---    t=85 调 Sub4（ins_67(20,4,4) 边界感知走位 20 帧 / 4 px/帧），然后 ins_4(0,-140)
    ---    跳回 t=0 ⇒ **一轮 120 帧**（85 + Sub4 的 35）。
    ---  · Sub6：每 4 帧一小圈（ins_89(18, 1, intV0, 1, 2.0, ...)），
    ---    intV0 = photoIndex/3 + 1（ins_23 整除、ins_30 自增）⇒ 拍得越多圈越大（1~3 发）。
    ---    ins_4(100,-84) 跳回 @1172 ⇒ 周期 4 帧。角度是 rand(-π,π) ⇒ 每圈换个相位（§7.7 第 1 条）。
    ---我们这边的折扣：
    ---  ① 「一轮 4 次整扇」只做 **1 次**：4 次的角度、速度、位置**完全相同**（循环体里只有
    ---     ins_87 一条），同一帧叠出来的图案和 1 次一模一样，只是白烧 384 发 —— 而原作
    ---     那 640 个弹槽有拍照清屏兜底，我们没有。观感不变的省法就这么省。
    ---  ② type 6（半径 2）→ butterfly（半径 4）：本关只有 butterfly / water_drop 两种贴图。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 t=0 的 ins_63(-128,-64)、t=100 的 ins_64(30,4,0,224)。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_Y = field_y(224)                    -- 0（场地正中）
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---Sub4 的走位框：ins_75(-128,192,128,256) ⇒ x∈[-128,128]、y∈[192,256]（TH095）
    ---⇒ 我们的 y∈[-32, 32]。ins_67(20,4,4) = 20 帧、4 px/帧、缓动 4。
    local BAND_L, BAND_R = -128, 128
    local BAND_B, BAND_T = field_y(256), field_y(192)   -- -32 / 32
    local SCOOT_TIME, SCOOT_SPEED = 20, 4

    ---整扇（Sub5）：ins_87(6, 4, 128, 1, 1.4, 1.5, floatV0, 0.0327249, 514)。
    ---count2 = 1 ⇒ speed2 = 1.5 不参与（BulletManager.cpp 的速度公式），速 1.4；
    ---angleStep = 0.0327249 rad = 1.875°；count1 = 128 是**偶数** ⇒ 走偶数分支
    ---（k = index1/2 + 0.5，奇数 index1 取负）⇒ ±0.5、±1.5、…、±63.5 格
    ---= 以自机方向为中心、一口气铺开 ±119.06°。
    local FAN_PERIOD = 120                  -- 一轮 85 + Sub4 的 35
    local FAN_WAIT = 15                     -- t=15 的那条 ins_5（原作在这里连放 4 次）
    local FAN_GAP = 85 - 15                 -- t=85 才调 Sub4
    local FAN_COUNT = 128
    local FAN_STEP = 1.875
    local FAN_SPEED = 1.4
    local FAN_STYLE = butterfly
    ---butterfly 非 colorful ⇒ 贴图号 = ceil(色号/2)；色号 8 → butterfly4 = (193,216,235) 冰蓝。
    local FAN_COLOR = COLOR.CYAN

    ---小圈（Sub6）：ins_89(18, 1, intV0, 1, 2.0, 1.5, rand(-π,π), 0.1848, 514)。
    ---type18（半径 3）、color 1、每 4 帧一圈、圈数 = photoIndex/3 + 1（1~3）。
    local RING_PERIOD = 4
    local RING_BASE_COUNT = 1               -- 1 + photoIndex/3
    local RING_SPEED = 2.0
    local RING_STYLE = water_drop
    local RING_COLOR = COLOR.CYAN           -- water_drop 是 colorful ⇒ 色号 8 = 亮青 (70,204,207)

    local PHOTO_LIMIT = 7                   -- Sub2 的 ins_141(7)：相机快门上限（photo_index 的截断值）

    local CARD_NAME = "行符「八千万枚護摩」"
    ---原作卡计时 ins_114(8408) ≈ 140 秒；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 900。
    local CARD_HP = 900
    ---符卡历史槽位：410..413 已被占、416 被卡 75 占掉，这张取 414。
    local CARD_ID = 414

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---FAN 的角度公式（aimMode = 1；BulletManager.hpp 的 PhotoBulletAimModeValue，
    ---实现在 BulletManager.cpp 的 FAN 分支）：
    ---  奇数 count1 ⇒ k = (index1+1)/2 的整数除；偶数 ⇒ k = index1/2 + 0.5；
    ---  index1 为奇数时 k 取负 ⇒ 偶数 count1 的扇面**没有正中间那一根**、两两对称成对。
    local function fan_angle(base, index1, count1, step)
        local k
        if count1 % 2 == 1 then
            k = int((index1 + 1) / 2)
        else
            k = index1 / 2 + 0.5
        end
        if index1 % 2 == 1 then
            k = -k
        end
        return base + k * step
    end

    ---一记整扇（Sub5）：128 根、以自机方向为中心铺开 ±119°（奇数/偶数公式见 fan_angle）。
    local function fire_fan(owner)
        local base = Angle(owner.x, owner.y, player.x, player.y)
        local x, y = owner.x, owner.y
        for i = 0, FAN_COUNT - 1 do
            NewSimpleBullet(FAN_STYLE, FAN_COLOR, x, y, FAN_SPEED,
                    fan_angle(base, i, FAN_COUNT, FAN_STEP), false, 0, false)
        end
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：整扇只响一声（BulletManager.cpp:717-723）。
        PlaySound("tan00", 0.1, x / 256, false)
    end

    ---一小圈（Sub6）：圈数 = 1 + photoIndex/3，相位每圈重抽（原作 angle = rand(-π,π)）。
    local function fire_ring(owner)
        local count = RING_BASE_COUNT + int(photo_index(PHOTO_LIMIT) / 3)
        local base = ran:Float(0, 360)
        for i = 0, count - 1 do
            NewSimpleBullet(RING_STYLE, RING_COLOR, owner.x, owner.y, RING_SPEED,
                    base + i * 360 / count, false, 0, false)
        end
    end

    ---主体脚本（Sub5）：放一扇 → 等 15 帧 → 等 70 帧 → 走 20 帧 → 回头（一轮 120）。
    local function fan_stream(owner)
        task.New(owner, function()
            while true do
                fire_fan(owner)
                task.Wait(FAN_WAIT + FAN_GAP)
                ---Sub4：朝自机方向 ±60° 挑一个角度、4 px/帧 走 20 帧（= 80 px），夹进框里。
                local a = Angle(owner.x, owner.y, player.x, player.y) + ran:Float(-60, 60)
                local step = SCOOT_SPEED * SCOOT_TIME
                task.MoveTo(max(BAND_L, min(BAND_R, owner.x + step * cos(a))),
                        max(BAND_B, min(BAND_T, owner.y + step * sin(a))),
                        SCOOT_TIME, VALUE_SET.NORMAL)
                task.Wait(FAN_PERIOD - FAN_WAIT - FAN_GAP - SCOOT_TIME)
            end
        end)
    end

    ---小圈（Sub6）：每 4 帧一圈。
    local function ring_stream(owner)
        task.New(owner, function()
            while true do
                fire_ring(owner)
                task.Wait(RING_PERIOD)
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(0, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 的 t=130 是 ins_104（亮卡名）+ ins_52(3)。
            PlaySound("tan00", 0.1, self.x / 256, false)
            fan_stream(self)
            ring_stream(self)
        end)
    end

    ---本体的逐帧逻辑：**原作没有**（移动、发弹都在 ECL 上下文里）。frame 留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "2a" } }, LEVEL, CARD_NAME, CARD_ID)
end--行符「八千万枚護摩」

do  -- 76 超人「飛翔役小角」（ecl16_d，妖梦，组 2a 第 3 张）
    ---「飛翔役小角」= 会飞的役小角（修验道的祖师，传说能在空中飞行）。原作的骨架
    ---（/tmp/B_ecl16_d.txt）不是「站在原地放弹」，而是**本体自己在飞**：
    ---  · Sub3 的 t=0：ins_65(playerAngle, 0.5) + ins_71(0.1) ⇒ 朝自机方向起步、
    ---    速度 0.5、**加速度 0.1**（引擎每帧 speed += acceleration 地飞，越飞越快）；
    ---    然后每帧只跑一段「守卫链」（@940 → @1236 → @1512 → @1788 无条件跳到底），
    ---    也就是**在场地内什么都不做**。
    ---  · 链上的三个分支块（@988 / @1264 / @1540）内容一模一样：把本体挪到
    ---    **(随机 x, -48)**（TH095 坐标 ⇒ 我们的 y = 272，场地上沿之外）、
    ---    换成「俯冲」：ins_65(playerAngle, photoIndex*2)、ins_71(2/60 + 0.1)
    ---    （ins_28 是浮点**除**，EclRunLow.inl:320；2/60 + 0.1 = 0.1333），
    ---    并且 ins_117(0,4) 重启蝶云上下文。
    ---    三个块分别由「出下沿 / 出右沿 / 出左沿」选中 ⇒ **飞出场地就回顶上重来**。
    ---  · Sub4（蝶云）：每帧 1 发、4 发一组（t=0..3，t=4 跳回 @1960），
    ---    出膛点 = 本体 + 半径 24 px 内随机（ins_27 乘随机数、ins_38 化成向量、ins_100 设偏移），
    ---    方向随机；速度 0.02（几乎不动）→ 悬停 60 帧 → 沿自身方向以 1/60 px/帧² 加速 60 帧
    ---    （ins_101 slot0 的 0x8000 = WAIT、slot1 的 0x10 = ACCELERATE_VECTOR，
    ---     见 PhotoBulletSpawnDescriptor.hpp:82-107 的位表）⇒ 最后 ~1.02 px/帧。
    ---    所以这是一片**先悬在半空、再慢慢飘走**的蝶云（母题：役小角身边的蝶）。
    ---我们这边的三处折扣 / 差异：
    ---  ① 俯冲速度**封顶 6 px/帧**（原作 photoIndex*2、photoIndex 上限 8 ⇒ 最多 16）。
    ---     16 px/帧 的撞击在没有拍照闪避的体系里躲不掉；6 px/帧 还能靠提前横移让开。
    ---  ② 蝶云只在入场后开一次（原作每次俯冲都重启上下文）。重启只是重置相位
    ---     （ins_117 用的是**固定槽位**、会把上一个上下文 free 掉，EclRunTargetHigh.inl:206，
    ---     不会叠加），图案完全一样，省掉一次协程抖动。
    ---  ③ **自检在这张上的读数偏低，不是卡里缺弹幕。** 桩件只对 `objects` 表里的对象
    ---     积分速度（tools/check_stage.lua 的 step_objects），而本体是它另外造的
    ---     boss_obj、不在那张表里 ⇒ **飞行在自检里是静止的**，蝶云全堆在出生点、
    ---     自机站在别处，所以 `60px 内平均` 只有 0.5。把同一段飞行在桩件里手动积分
    ---     一次（= 引擎真正干的事，LuaSTG-Sub/LuaSTG/LuaSTG/GameObject/GameObject.cpp:330
    ---     的 `x += vx`），同样 1800 帧的读数就是 4.0~4.7。
    ---     这张卡的压迫感本来也主要来自**本体撞人**（自检量不了碰撞），蝶云只是挂在
    ---     身后的软墙；按 §7.2 真正权威的那一栏 `峰值同屏 弹` = 205（阈值 150）⇒ 不空。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 t=0 的 ins_63(-128,-64)、t=100 的 ins_64(30,4,16,128)。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_X, BOSS_HOME_Y = 16, field_y(128)   -- 16 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---飞行 / 俯冲（Sub3，公式见卡头注释）。
    local DIVE_SPEED0 = 0.5                 -- ins_65 的第 2 个操作数
    local DIVE_ACCEL0 = 0.1                 -- ins_71 的第 1 个操作数
    local DIVE_ACCEL = 2 / 60 + 0.1         -- 俯冲档的 ins_71(ins_28(2,60) + 0.1)
    local DIVE_SPEED_MAX = 6                -- ★ 折扣 ①（原作是 photoIndex*2）
    local DIVE_X_RANGE = 192                -- ins_27(floatV0, randF32S, 192) ⇒ x ∈ [-192,192]
    local DIVE_SPAWN_Y = field_y(-48)       -- 272（原作的 ins_63(..., -48)）

    ---蝶云（Sub4）：4 发一组、每发 1 帧；出膛点在本体 24 px 内、方向随机；
    ---速度 0.02 → 悬停 60 帧 → 沿自身方向加速 1/60 px/帧² 共 60 帧。
    ---三个数都照原作 slot0/slot1 的 ins_101 抄：kind 0x8000(WAIT) 的 int0 = 60、
    ---kind 0x10(ACCELERATE_VECTOR) 的 int0 = 60 与 f0 = 0.0166667 = 1/60
    ---（B_ecl16_d.txt @1860 / @1900；加速度方向 f1 = -999.99 ⇒ 引擎取弹自己的 angle，
    ---BulletManager.cpp:545-556）。
    ---★ CLOUD_ACCEL 别再调大：实测 2/60 时弹更快飞出场地、云反而**更薄**
    ---（1800 帧的 `峰值同屏 弹` 从 205 掉到 139，`60px 内平均` 从 4.7 掉到 2.8）。
    ---1/60 那种慢慢飘的云才是原作「跟在役小角身后的蝶群」。
    local CLOUD_BURST = 4
    local CLOUD_PERIOD = 5                  -- 4 发 + 1 帧空档（原作 t=4 跳回 t=0）
    local CLOUD_RADIUS = 24
    local CLOUD_SPEED0 = 0.02
    local CLOUD_WAIT = 60
    local CLOUD_ACCEL = 1 / 60
    local CLOUD_ACCEL_FRAMES = 60
    local CLOUD_STYLE = butterfly
    ---原作四发轮着用 color 3/4/5/6；butterfly 非 colorful ⇒ 贴图号 = ceil(色号/2)，
    ---3/4 都是 butterfly2、5/6 都是 butterfly3 —— 也就是**两种贴图**。
    ---这里按本关「一个色系」的规矩取同族的两个：色号 6 → butterfly3 = (190,190,242) 蓝紫、
    ---色号 8 → butterfly4 = (193,216,235) 冰蓝。
    local CLOUD_COLOR_A, CLOUD_COLOR_B = COLOR.CYAN, COLOR.BLUE

    local PHOTO_LIMIT = 8                   -- Sub2 的 ins_141(8)：相机快门上限（photo_index 的截断值）

    local CARD_NAME = "超人「飛翔役小角」"
    ---原作卡计时 ins_114(7208) ≈ 120 秒；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 900。
    local CARD_HP = 900
    ---符卡历史槽位：410..414 已被占、416 被卡 75 占掉，这张取 415。
    local CARD_ID = 415

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---蝶云里每一颗的逐帧钩子：先悬停 CLOUD_WAIT 帧（原作 slot0 的 0x8000 WAIT），
    ---再沿自身方向加速 CLOUD_ACCEL_FRAMES 帧（slot1 的 0x10 矢量加速，每帧 +1/60）。
    ---（frame 钩子只收一个参数，§5.2；两次都**必须停**，否则弹会一直加速出不了回收边界。）
    local function cloud_frame(unit)
        if unit.wait_left == nil then
            unit.wait_left = CLOUD_WAIT
            unit.accel_left = CLOUD_ACCEL_FRAMES
            unit.cur_v = 0
        end
        if unit.wait_left > 0 then
            unit.wait_left = unit.wait_left - 1
            ---悬停期间原作也是拿 speed = 0.02 在飘（不是 0）：60 帧只挪 1.2 px，
            ---肉眼看不见，但照抄就是了。
            object.SetV(unit, CLOUD_SPEED0, unit.rot, true)
            return
        end
        if unit.accel_left <= 0 then
            return
        end
        unit.accel_left = unit.accel_left - 1
        unit.cur_v = unit.cur_v + CLOUD_ACCEL
        object.SetV(unit, unit.cur_v, unit.rot, true)
    end

    ---蝶云（Sub4）：4 发一组，出膛点在本体 24 px 内随机、方向各自随机。
    local function cloud_stream(owner)
        task.New(owner, function()
            while true do
                for _ = 1, CLOUD_BURST do
                    local pa = ran:Float(0, 360)
                    local pr = CLOUD_RADIUS * ran:Float(0, 1)
                    local color = ran:Float(0, 1) < 0.5 and CLOUD_COLOR_A or CLOUD_COLOR_B
                    NewSimpleBullet(CLOUD_STYLE, color,
                            owner.x + cos(pa) * pr, owner.y + sin(pa) * pr,
                            CLOUD_SPEED0, ran:Float(0, 360), false, 0, false,
                            nil, nil, nil, cloud_frame)
                    task.Wait()
                end
                task.Wait(CLOUD_PERIOD - CLOUD_BURST)
            end
        end)
    end

    ---主体脚本（Sub3）：起飞 → 每帧累加速度 → 出场地就回顶上改成「俯冲」。
    local function flight(owner)
        task.New(owner, function()
            local a = Angle(owner.x, owner.y, player.x, player.y)
            local speed, accel = DIVE_SPEED0, DIVE_ACCEL0
            object.SetV(owner, speed, a, true)
            local w = lstg.world
            while true do
                speed = speed + accel
                object.SetV(owner, speed, a, true)
                ---出界判据照抄原作（TH095 的 x = ±224、y = 480 ⇒ 我们的 boundl/r/b）。
                if owner.x > w.boundr or owner.x < w.boundl or owner.y < w.boundb then
                    local nx = ran:Float(-DIVE_X_RANGE, DIVE_X_RANGE)
                    owner.x, owner.y = nx, DIVE_SPAWN_Y
                    a = Angle(nx, DIVE_SPAWN_Y, player.x, player.y)
                    speed = min(DIVE_SPEED_MAX, photo_index(PHOTO_LIMIT) * 2)
                    accel = DIVE_ACCEL
                    object.SetV(owner, speed, a, true)
                    -- 定位置音效：原作的 ins_106(16)（一个与发弹无关的提示音）
                    PlaySound("tan00", 0.1, owner.x / 256, false)
                end
                task.Wait()
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)  -- 拍照扣血：拍够 PHOTO_LIMIT 张 = 清空血条
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(BOSS_HOME_X, BOSS_HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub2 的 t=130 是 ins_104（亮卡名）+ ins_52(3)。
            PlaySound("tan00", 0.1, self.x / 256, false)
            cloud_stream(self)
            flight(self)
        end)
    end

    ---本体的逐帧逻辑：**原作没有**（飞行与发弹都在 ECL 上下文里）。frame 留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "2a" } }, LEVEL, CARD_NAME, CARD_ID)
end--超人「飛翔役小角」
