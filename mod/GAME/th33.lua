---=====================================
---TH33  文花帖（TH095）Stage 7/8/EX/9/6 —— 原作 47 张符卡（47 幕逐幕移植）
---
---本关把原作 world08 的 7 张符卡 + Stage EX 的 8 张符卡 + Stage 9（world10）的 8 张
---+ Stage 8（world09）的 8 张 + Stage 7（world07）的 8 张 + Stage 6（world06）的 8 张
---逐幕移植成一条 Boss Rush。
---world08 的 7 幕数据来源是
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
---Stage EX（scene group 10）的 8 幕在文件后半（"Stage EX —— 两件公共工具" 往下），
---数据来源是 th095/src/SceneSelect.cpp:165-172 的同一张 TH095_SCENE 表（scene 100..107）：
---  100 ecl22_a 芙兰 禁忌「フォービドゥンフルーツ」   101 ecl22_b 芙兰 禁忌「禁じられた遊び」
---  102 ecl23_a 紫   境符「色と空の境界」             103 ecl23_b 紫   境符「波と粒の境界」
---  104 ecl24_a 妹红 貴人「サンジェルマンの忠告」     105 ecl24_b 妹红 蓬莱「瑞江浦嶋子と五色の瑞亀」
---  106 ecl25_a 萃香 鬼気「濛々迷霧」                 107 ecl25_b 萃香 「百万鬼夜行」
---八张也是**自由选关**、共用场景资源（world05/06/09/10.std + enm22..25.anm + bgm th095_03.wav），
---所以四人共用 BGM = "TH09_5_1"（東の国の眠らない夜）、背景 = TH095_bg。
---每个数值都标了它在反汇编里的出处：`/tmp/E_ecl2{2,3,4,5}_{a,b}.txt`
---（脚本 /tmp/d95v2.py 不入库；数据在 `[th095] …/data/ecl2{2,3,4,5}_{a,b}.ecl`）。
---
---Stage 9（scene group 9 = world10）的 8 幕在文件**最后一段**（"Stage 9（scene group 9
---= world10）—— 公共工具" 往下），数据来源同样是 SceneSelect.cpp:150-157 的 TH095_SCENE
---表（scene 90..97；同表里这一组的第 1 幕是**非符**，按原作不亮卡名）：
---  90 ecl20_a 小町 非符                    91 ecl21_a 映姬 嘘言「タン・オブ・ウルフ」
---  92 ecl20_b 小町 死歌「八重霧の渡し」      93 ecl21_b 映姬 審判「十王裁判」
---  94 ecl20_c 小町 古雨「黄泉中有の旅の雨」  95 ecl21_c 映姬 審判「ギルティ・オワ・ノットギルティ」
---  96 ecl20_d 小町 死価「プライス・オブ・ライフ」
---  97 ecl21_d 映姬 審判「浄頗梨審判　-射命丸文-」
---八幕共用 world10（三途の川 / 彼岸）与 enm20/21.anm；整组 BGM 沿用 "TH07_1"、
---背景 TH095_bg（scene 97 原作另用 bgm/th09_08_2.wav，本仓库没有这首）。
---每个数值都标了它在反汇编里的出处：`/tmp/S9_ecl2{0,1}_{a..d}.txt`
---（脚本 /tmp/d95v3.py 不入库；数据在 `[th095] …/data/ecl2{0,1}_{a..d}.ecl`）。
---
---Stage 8（scene group 8 = world09）的 8 幕在文件**最后一段**（"Stage 8（scene group 8
---= world09）—— 公共工具" 往下），数据来源同样是 SceneSelect.cpp:144-151 的 TH095_SCENE
---表（scene 80..87；同表里这一组的第 1 幕是**非符**，按原作不亮卡名）：
---  80 ecl18_a 永琳 非符                   81 ecl19_a 辉夜 新難題「月のイルメナイト」
---  82 ecl18_b 永琳 薬符「胡蝶夢丸ナイトメア」 83 ecl19_b 辉夜 新難題「エイジャの赤石」
---  84 ecl18_c 永琳 錬丹「水銀の海」         85 ecl19_c 辉夜 新難題「金閣寺の一枚天井」
---  86 ecl18_d 永琳 秘薬「仙香玉兎」         87 ecl19_d 辉夜 新難題「ミステリウム」
---八幕共用 world09（永遠亭）与 enm18/19.anm；整组 BGM 沿用 "TH07_1"、背景 TH095_bg。
---每个数值都标了它在反汇编里的出处：`/tmp/S8_ecl1{8,9}_{a..d}.txt`
---（脚本 /tmp/d95.py 不入库；数据在 `[th095] …/data/ecl1{8,9}_{a..d}.ecl`）。
---
---Stage 7（scene group 6 = world07）的 8 幕在文件**最后一段**（"Stage 7（scene group 6
---= world07）—— 公共工具" 往下），数据来源同样是 SceneSelect.cpp:126-133 的 TH095_SCENE
---表（scene 60..67；同表里这一组第 1 幕（咲夜）是**非符**，按原作不亮卡名）：
---  60 ecl14_a 咲夜 非符                       61 ecl15_a レミリア 魔符「全世界ナイトメア」
---  62 ecl14_b 咲夜 時符「トンネルエフェクト」   63 ecl15_b レミリア 紅符「ブラッディマジックスクウェア」
---  64 ecl14_c 咲夜 空虚「インフレーションスクウェア」 65 ecl15_c レミリア 紅蝙蝠「ヴァンパイリッシュナイト」
---  66 ecl14_d 咲夜 銀符「パーフェクトメイド」   67 ecl15_d レミリア 神鬼「レミリアストーカー」
---八幕共用 world07（紅魔館）与 enm14/15.anm；整组 BGM 沿用 "TH07_1"、背景 TH095_bg。
---每个数值都标了它在反汇编里的出处：`/tmp/N_ecl1{4,5}_{a..d}.txt`
---（脚本 /tmp/d95c.py 不入库；数据在 `[th095] …/data/ecl1{4,5}_{a..d}.ecl`）。
---
---Stage 6（scene group 5 = world06）的 8 幕在文件**最后一段**（"Stage 6（scene group 5
---= world06）—— 公共工具" 往下），数据来源同样是 SceneSelect.cpp:120-127 的 TH095_SCENE
---表（scene 50..57；同表里这一组第 1 幕（橙）是**非符**，按原作不亮卡名 ——
---它的 t=130 是 id=0，opcode 0 在 EclRunLow.inl 的 switch 里没有分支 ⇒ NOP）：
---  50 ecl12_a 橙 非符（不亮卡名）              51 ecl13_a 八云蓝 人智剣「天女返し」
---  52 ecl12_b 橙 星符「飛び重ね鱗」             53 ecl13_b 八云蓝 妄執剣「修羅の血」
---  54 ecl12_c 橙 鬼神「鳴動持国天」             55 ecl13_c 八云蓝 天星剣「涅槃寂静の如し」
---  56 ecl12_d 橙 化猫「橙」                     57 ecl13_d 八云蓝 四生剣「衆生無情の響き」
---八幕共用 world06 与 enm12/13.anm；整组 BGM 沿用 "TH07_1"、背景 TH095_bg。
---每个数值都标了它在反汇编里的出处：`/tmp/W6d_ecl1{2,3}_{a..d}.txt`
---（脚本 /tmp/d95d.py 不入库；数据在 `[th095] …/data/ecl1{2,3}_{a..d}.ecl`）。
---
---十四个 boss 组怎么排
---  原作 47 幕全是**自由选关**、本来没有先后；这里按角色归成十四个 boss 组
---  （AGENTS.md §8 与 th31.lua 的教训：**一个角色一个组**，boss.CreateGroup 一次建一组）：
---      world08：组 1 = 西行寺幽幽子：71 → 73 → 75 → 77（4 张）
---              组 2 = 魂魄妖梦：  72 → 74 → 76（3 张）
---      Stage EX：组 3 = 芙兰朵露：100 → 101（2 张）
---                组 4 = 八云紫：  102 → 103（2 张）
---                组 5 = 藤原妹红：104 → 105（2 张）
---                组 6 = 伊吹萃香：106 → 107（2 张）
---      Stage 9： 组 7 = 小町：    90 → 92 → 94 → 96（4 张）
---                组 8 = 映姬：    91 → 93 → 95 → 97（4 张）
---      Stage 8： 组 9 = 八意永琳：80 → 82 → 84 → 86（4 张）
---                组 10 = 蓬莱山辉夜：81 → 83 → 85 → 87（4 张）
---      Stage 7： 组 11 = 十六夜咲夜：60 → 62 → 64 → 66（4 张）
---                组 12 = レミリア・スカーレット：61 → 63 → 65 → 67（4 张）
---      Stage 6： 组 13 = 橙：50 → 52 → 54 → 56（4 张）
---                组 14 = 八云蓝：51 → 53 → 55 → 57（4 张）
---  main_stage.lua 的 TH33 里连着调 boss.CreateGroup(1..14, 39)，就会依次打完这十四班的 47 张。
---  ★ 别把两个角色塞进同一个组的 a、b：CreateGroup 会把 a、b、c… 一次全建出来（两人同时上场）。
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
---与原作的差异（47 张卡共有；Stage EX / Stage 9 / Stage 8 / Stage 7 / Stage 6 若某一条的落点不同，写在那张卡自己的注释里）
---  1) 拍照关的相机 / 计分系统：**相机本身不实现** —— 本仓库有自己的拍照自机
---     射命丸文（THlib/player/aya/aya.lua:191 给 player 挂了 player.camera，快门由玩家
---     自己按）。原作那套 opcode —— ins_141（快门上限）、ins_143（拍照标记）、
---     ins_144（快门脉冲）、ins_149（分数倍率）、ins_114（卡计时）、ins_104/105
---     （亮卡名 / 收会话）、ins_150（装饰 ANM）—— 只保留**影响弹幕数值**的那一头：
---     卡里用 photo_index()（见文件中部）去读「本卡内**拍中本体**的张数」当
---     camera.photoIndex，快门音 / 上限 / 计分一概不做；卡名与计时交给符卡系统
---     （CARD_NAME / CARD_TIME）。
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
---     ⇒ 本关按作者要求把拍照那一口伤害换成**固定 1/N 血**，而且按「拍中的第几张」
---     重算剩余血量、第 N 张硬取 0（拍够 N 张**正好**清空血条，见文件中部
---     「拍照扣血」那一节）—— 逐张累减会在 N 张后留下 1e-13 级的残血。
---     子弹照旧能打（差异 4/7 的一贯口径：本体是 HP Boss）⇒ N 张照够打完，
---     边打边拍更快。
--- 10) 原作每一发的弹数 = ins_86..94 的 `count1 × count2`（th095/src/BulletManager.cpp
---     的 SpawnBulletPattern :699-726），速度公式是 count2 > 1 时
---     speed1 − (speed1−speed2)×index2/count2、否则 speed1（同文件 :340-346）。
---     本文件**不再打折**：各卡一律按操作数里的 count1/count2 原样发，装饰（子机 /
---     蛾 / 蝶）才做数量与寿命上的近似；原作靠全游戏 640 弹槽 + 拍照清屏兜底，
---     我们两条都没有，同屏弹数会落在原作的量级上（实测见文末）。
---     另一处刻意不做的近似：原作的 SPAWN_FAST / SPAWN_SLOW（flags 的 0x2 / 0x8）会把弹
---     先退到 velocity×4 的位置、再用几帧滑回出膛点（BulletManager.cpp:445-478）；
---     本文件没有这层出场滑动，弹一出生就按最终速度飞 —— 弹数、角度、速度曲线都不变，
---     只是每颗弹在它自己那条轨迹上比原作早几帧到位。
--- 11) 全局游戏速度（慢放）：Stage 6 的 51/53/55/57（scene 51..57 的八云蓝四张，
---     以及 495 的橙）在 Sub3 里用 `ins_119(11)` 触发扩展回调 11（EclExtended.cpp 的
---     PublishGameSpeed：把 g_AnmGameSpeed 设成 floatV7，卡里写 0.25 或 0.5），
---     再配 `ins_118(12)/(13)` 切背景 VM 状态，做出「慢镜头 + 换色」的演出；
---     ins_119(-1) 收掉。本仓库没有「把整个游戏减速」的接口（改了会连自机、自机弹、
---     背景一起慢下来，和本仓库的帧驱动不符）⇒ **这四张一律不实现慢放**，
---     弹幕本身的时间轴仍按原作帧数跑。**屏幕上的弹幕形状不变**，只是少了那层慢镜。
---     同理 ins_118(12)/(13)/(15)/(16)（背景 VM 状态）也不实现。
---=====================================

---实测（2026-09-28，本机 luajit；自检是**逐卡**跑的 —— 每张卡都清场、从 0 帧起，
---所以下面每一列都是「这一张单独打」的数，不是整关同时在场。
---★ 自检桩件里没有相机（`player.camera == nil`）⇒ take_damage2 不会被调、photo_hits
---恒为 0，所以下面这些读数都是**原作 photoIndex = 0**（一张照都没拍）那一档；
---真机用射命丸文拍中本体之后，看 photoIndex 的那几张（world08：卡 1 的狙间隔、
---卡 3 的每圈弹数、卡 5 的小圈圈数、卡 6 的俯冲速度、卡 7 的光翼；Stage EX：卡 8 的
---每轮弹数、卡 11 的弹速、卡 12 的每圈弹数、卡 13 的基角、卡 15 的躲闪/密度）
---会再往上抬。）
---  卡                             峰值同屏弹(7200f)  威胁度(1800f)
---  1 幽雅「死出の誘蛾灯」                704             14.64
---  2 蝶符「鳳蝶紋の死槍」                283              4.68
---  3 死符「醉人之生、死之梦幻」           527              2.21
---  4 「死蝶浮月」                       709              2.76
---  5 密符「御大師様の秘鍵」              371              0.00
---  6 行符「八千万枚護摩」                888              2.19
---  7 超人「飛翔役小角」                  186              0.24
---  ── Stage EX（scene group 10；背景 TH095_bg / BGM TH09_5_1）──
---  8 禁忌「フォービドゥンフルーツ」        679              0.78
---  9 禁忌「禁じられた遊び」                 12              0.34
--- 10 境符「色と空の境界」                1100              2.60
--- 11 境符「波と粒の境界」                 277              2.28
--- 12 貴人「サンジェルマンの忠告」          650              4.64
--- 13 蓬莱「瑞江浦嶋子と五色の瑞亀」        913              2.71
--- 14 鬼気「濛々迷霧」                   2161（见下）        10.69
--- 15 「百万鬼夜行」                       575              2.32
---  ── Stage 9（scene group 9 = world10；背景 TH095_bg / BGM TH07_1）──
--- 16 小町 非符（不亮卡名）               512              4.35
--- 17 嘘言「タン・オブ・ウルフ」            332              5.61
--- 18 死歌「八重霧の渡し」                139              4.31
--- 19 審判「十王裁判」                   139              2.19
--- 20 古雨「黄泉中有の旅の雨」             152              3.62
--- 21 審判「ギルティ・オワ・ノットギルティ」   0              0.00
--- 22 死価「プライス・オブ・ライフ」         134              3.32
--- 23 審判「浄頗梨審判　-射命丸文-」        450              3.05
---  ── Stage 8（scene group 8 = world09；背景 TH095_bg / BGM TH07_1）──
--- 24 永琳 非符（不亮卡名）               451              8.93
--- 25 新難題「月のイルメナイト」            364              1.41
--- 26 薬符「胡蝶夢丸ナイトメア」            412              0.18
--- 27 新難題「エイジャの赤石」               7              1.38
--- 28 錬丹「水銀の海」                    303              0.75
--- 29 新難題「金閣寺の一枚天井」            346              1.11
--- 30 秘薬「仙香玉兎」                    308              2.22
--- 31 新難題「ミステリウム」               968              2.04
---  ── Stage 7（scene group 6 = world07；背景 TH095_bg / BGM TH07_1）──
--- 32 咲夜 非符（不亮卡名）               649              0.59
--- 33 魔符「全世界ナイトメア」               0              0.00
--- 34 時符「トンネルエフェクト」            135              1.68
--- 35 紅符「ブラッディマジックスクウェア」   356              0.28
--- 36 空虚「インフレーションスクウェア」    123              1.93
--- 37 紅蝙蝠「ヴァンパイリッシュナイト」      10              0.00
--- 38 銀符「パーフェクトメイド」            264              0.71
--- 39 神鬼「レミリアストーカー」              2              0.00
---  （8 张 Stage 9 的峰值在 1800/3600/14400 帧同样持平：500/500/517、332 平、139 平、
---  139 平、150/152/152、0 平、134 平、450 平 —— 卡 16 的末位浮动是发弹相位，不是泄漏。
---  卡 21「ギルティ・オワ・ノットギルティ」的 0 是**桩件口径**：它的弹全挂在
---  photoIndex ≥ 2 上（Sub5 的 intV0 = photoIndex − 2），photoIndex = 0 时一颗不发，
---  场上只有 18 条激光（表里的「对象」列）；卡 16 的卡名是空的，因为原作这一幕本来就
---  不亮卡名（非符）。Stage 9 这一批的发射量与常量同样按 ECL 原样，没打折。）
---  （8 张 EX 的 7200f 峰值都在 14400/28800/57600 帧保持不变或只差个位数，
---  不是泄漏；唯一的例外是卡 14 濛々迷霧：Sub4 的雾滴速度只有 0.05 px/帧、
---  平均要在场里飘几千帧才出边界，所以它的同屏数是很长的暂态
---  —— 1800/3600/7200/14400/28800/57600 帧 = 798/1461/2161/2171/2178/2188，
---  7200 帧以后基本不再涨；而且本卡 CARD_TIME = 50s = 3000 帧，
---  **真机一局活不到 7200 帧** —— 按卡时限量到 3000 帧时峰值 1272
---  （1800/2400/3000 帧 = 798/988/1272），只有表里那个 2161 的六成。
---  EX 这一批的发射量与各卡常量一律按 ECL 原样，没打折。卡 9「禁じられた遊び」同屏
---  只有 12 颗弹、出膛总数也少，是因为原作弹幕全在**激光**里（4 组 × 4 根 type 12、
---  第 4 波再加 8 根朝自机的），唯一的 NewSimpleBullet 是每波 4 颗大玉（type 17
---  → ball_huge）—— 激光在本仓库是独立对象、不计进这里的弹数，详见那张卡的注释。）
---  （威胁度那一列是 `tools/threat.lua mod/GAME/th33.lua 1800` 的默认种子读数。
---  这一列对发弹相位极敏感：卡 1 只把蝶弹两组的相位从「闸门多等一帧」改回原作的
---  4+4 帧（见那一卡 ring_t 的注释）、自机狙间隔改 1 帧（121→120），读数就从
---  13.54 一路跳到 14.64 —— 躲避机器人的轨迹是混沌的，**不能拿 1~5% 的差当回归**。）
---  卡 5 那一档 0.00 是**桩件口径**，不是卡坏了：这一档 photoIndex = 0 ⇒ 只在
---  photoIndex ≥ 3 之后才打的单发自机狙（Sub4 的 ins_44 闸）**一颗都没发**，
---  场上只剩钥匙的定角三连（上/左/右）；威胁工具那个躲避机器人只要不往那三条线上站
---  就不会被判到（真机里钥匙本体有判定、会撞人，桩件量不到；见各卡的 §7.4 C 类说明）。
---  · ① 泄漏扫描 ✅ —— 1800 / 3600 / 14400 帧三档，7 张卡的峰值同屏弹是平的：
---    700/702/704、281/283/283、527/527/529、706/708/712、282/308/371、
---    885/888/890、183/183/187 —— 不会随时间线性爬（末位浮动是发弹相位，不是泄漏；
---    卡 5 的 282→371 是「钥匙边掉边发」的长暂态，14400 帧以后不再涨，见 7200/14400/28800
---    = 371/371/379）。8 张 EX 同样扫了四档，除了卡 14 濛々迷霧的长暂态（见上表
---    下面那段）以外全部持平：678/679/679/680、12 平、1100 平、277 平、
---    633/642/650/664、913 平、798/1461/2161/2171、574/574/575/581。
---    Stage 9 八张同样扫了 1800 / 3600 / 14400 三档，全部持平：
---    500/500/517、332 平、139 平、139 平、150/152/152、0 平、134 平、450 平。
---    Stage 7 八张同样扫了 1800 / 3600 / 7200 / 14400 四档，全部持平：
---    639/640/649/649、0 平、134/134/135/135、350/356/356/370、116/123/123/123、
---    10 平、264 平、2 平。
---    ★ Stage 7 落卡时修了四处「context slot 没建」的移植错：原作的 ins_117(slot,子程序)
---    是**占位替换**（EclRunTargetHigh.inl:206 先 Free 掉同 slot 的旧块再建新的），而本仓库
---    的 task.New 是新建一条协程、不会顶掉旧的。卡 65/66 的两条发生器在 ins_4 跳回目标
---    **之前**，本该只起一次，却被放进了每轮循环（7200 帧量到 3767 个 object / 11135 颗
---    弹）；卡 64 的 ② 段本应在 t=180 被 ins_117(0,-1) 收掉；卡 67 的 Sub8 每轮被 slot 3
---    顶掉。四处都按「换一次就掐掉上一条」补上，修完峰值见上表（10 / 264 / 123 / 2）。
---  · ② 字段审计 ✅ —— `luajit tools/check_fields.lua mod/GAME/th33.lua`：通过。
---  · ③ 整项目扫描 ⚠ —— `luajit tools/check_stage.lua --all`：76 个 lua 语法全过，
---    但报 8 处「card_id 跨组重复：453..460」。那是 th31.lua 的 `local LIST = {` 表
---    （另一条正在改的线，2026-09-29 起把 453..460 整段划进了它自己的 Stage 5）
---    与本关 Stage EX 的 453..460 撞号 —— **不是本关 Stage 9 的问题**（470..477 无重复）。
---    按 §8 不动别人的文件，这里只记录、不改 th31；等 th31 那批自己挪号、或本关
---    Stage EX 挪号之后自然消。
---  · ④ `luajit tools/threat.lua mod/GAME/th33.lua 1800`：39 张全部「有限位」、
---    威胁度 0.00 ~ 14.64（Stage 8 的八张是 8.93 / 1.41 / 0.18 / 1.38 / 0.75 / 1.11 / 2.22 / 2.04，
---    其中卡 87「ミステリウム」2.04 与本关卡 84 的 2.22 一样是「整圈密弹」的原作形状，不要压）。文档的 0.5~1.5 是同工具量**自制卡**定的；拿它量原作移植卡
---    本来就是超区间读数（本仓库 th20.lua 的 35 张：中位 1.15、8 张 > 1.5、最高 3.99），
---    硬压到 1.5 就成了「把原作改松」，不是移植。卡 1 的 14.64 最高，那是「两组蝶弹
---    一起压」的原作形状，**不要压**（卡 5 的 0.00 见上）；真嫌挤就调各卡常量段里的
---    RING_SPEED / CYCLE / SPEAR_SPEED —— 改前先想清楚那还是不是原作。
---  · ⑤ 拍照扣血（差异 9）**自检看不见**：桩件里没有相机，拍照这条路径根本不会
---    被走到（`player.camera == nil`）。验证方式是从本文件里把 photo_index /
---    photo_damage_on / photo_damage_off / take_damage2 包装**原地抽出来**、配桩件跑断言：
---    「第 k 张后 hp = maxhp×(1−k/N)」「第 N 张恰好 == 0（不是 1e-13 级残血）」
---    「拍空枪不加计数」「photo_index 截断到 N」「未标记的 boss 仍走原函数」
---    「子弹已经打得更狠时不回血」共 14 条全过（脚本 /tmp/th33_photo_test.lua，不入库）。
---    逐卡的 N：world08 七张是 7/7/10/4/6/7/8，Stage EX 八张是
---    6/6/5/6/10/5/3/10，Stage 9 八张是 8/6/6/10/7/6/6/9，Stage 8 八张是
---    6/6/7/6/6/7/8/7（scene 80..87，与 SceneSelect.cpp 表末那一列一一对上），
---    Stage 7 八张是 9/3/5/7/6/7/5/7（scene 60..67，同表）
---    （各卡 PHOTO_LIMIT 就是那一张的 ins_141，见各卡常量段）。
---
---符卡历史槽位（CARD_ID，跨关唯一）：world08 七张占 410..415 与 416（409 被 th31 占）、
---Stage EX 八张占 453..460、Stage 9 八张占 **470..477**、Stage 8 八张占 **478..485**。⚠ 只扫 `boss.card.add` 的末参
---会漏号 —— th31.lua 的 `local LIST = {` 表里还有一批带 id 的行，所以 453 起要留意。
---★ 本关的 453..460 与 th31.lua Stage 5 的 LIST 段**撞号**，是 th31 那边的遗留问题
---（本关 Stage EX 整段 453..460 都归 th33）—— 见 `check_stage.lua --all`。
---th34.lua 现在用自己独立的一段 464..469（2026-09-29 从 426/461..463 挪过来）；
---461..463 与 470 以上本来空着，本关 Stage 9 因此从 470 起（不与别人抢号）。
---Stage 8 接在 Stage 9 之后，占 478..485（470..477 之后的连续空号；th34 在 464..469，
---不撞）。Stage 7 接在 Stage 8 之后，占 **486..493**（同样是 485 之后的连续空号）。
---Stage 6 接在 Stage 7 之后，占 **494..501**（同样是 493 之后的连续空号，跨关唯一）。
---注意 Stage 6 的两班是**交错**的（494 橙 → 495 蓝 → 496 橙 → 497 蓝 → …），
---和 Stage 7/8 一样按 scene 顺序追加即可。
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

do  -- Stage EX：芙兰的符卡背景（红 / 深红）
    ---Stage EX（scene 100/101 = world05）四张卡各一个背景，配色跟着角色的主题色走，
    ---理由同上面两套：换人了一眼就看得出来（§7.6）。
    ---贴图只用 Resources/BossBackGround 里**已存在**的 th*.png（§2 硬约束：不新增素材）。
    class.scbg3 = Class(_SC_BG)
    function class.scbg3:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th06_4", false, 0, 0, 0, 0, 0, 0.28, "mul+add", 2.2, 2.2,
                function(l) l.a = 170; l.r, l.g, l.b = 255, 96, 120 end)
        _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 200, 0, 0, -0.18, "mul+rev", 2.8, 2.8,
                function(l) l.r, l.g, l.b = 255, 160, 180 end)
        _SC_BG.AddLayer(self, "th06_2", false, 0, 0, 0, 0, 0, 0, "", 1.6, 1.6,
                function(l) l.a = 140 end)
    end
end

do  -- Stage EX：紫的符卡背景（紫 / 青）
    class.scbg4 = Class(_SC_BG)
    function class.scbg4:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_3", false, 0, 0, 40, 0, 0, 0.4, "mul+add", 2.4, 2.4,
                function(l) l.a = 160; l.r, l.g, l.b = 226, 150, 255 end)
        _SC_BG.AddLayer(self, "th07_9", false, 0, 0, 0, 0.25, 0.25, -0.3, "mul+rev", 2.0, 2.0,
                function(l) l.r, l.g, l.b = 120, 210, 235 end)
        _SC_BG.AddLayer(self, "th07_10", false, 0, 0, 120, 0, 0, 0, "", 1.9, 1.9,
                function(l) l.a = 150 end)
    end
end

do  -- Stage EX：妹红的符卡背景（火红 / 金）
    class.scbg5 = Class(_SC_BG)
    function class.scbg5:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_2", false, 0, 0, 0, 0, 0, -0.34, "mul+add", 2.6, 2.6,
                function(l) l.a = 165; l.r, l.g, l.b = 255, 140, 90 end)
        _SC_BG.AddLayer(self, "th08_9", false, 0, 0, 160, 0, 0, 0.22, "mul+rev", 2.0, 2.0,
                function(l) l.r, l.g, l.b = 255, 210, 140 end)
        _SC_BG.AddLayer(self, "th08_1", false, 0, 0, 0, 0, 0, 0, "", 2.2, 2.2,
                function(l) l.a = 130 end)
    end
end

do  -- Stage EX：萃香的符卡背景（雾 / 灰紫）
    class.scbg6 = Class(_SC_BG)
    function class.scbg6:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th10_3", false, 0, 0, 0, 0, 0, 0.3, "mul+add", 3.0, 3.0,
                function(l) l.a = 175; l.r, l.g, l.b = 210, 190, 220 end)
        _SC_BG.AddLayer(self, "th10_9", false, 0, 0, 260, 0, 0, -0.24, "mul+rev", 2.4, 2.4,
                function(l) l.r, l.g, l.b = 170, 150, 200 end)
        _SC_BG.AddLayer(self, "th10_4", false, 0, 0, 90, 0, 0, 0, "", 2.0, 2.0,
                function(l) l.a = 120 end)
    end
end

do  -- Stage 9：小町的符卡背景（彼岸 / 朱与紫）
    ---TH095 的 world10 是「彼岸 / 三途の川」那一幕（映姬与小町），所以贴图改用
    ---TH09（东方花映塚）那两套彼岸系的 th09_*.png；配色压在朱红与紫上。
    class.scbg7 = Class(_SC_BG)
    function class.scbg7:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th09_3", false, 0, 0, 0, 0, 0, 0.26, "mul+add", 2.6, 2.6,
                function(l) l.a = 165; l.r, l.g, l.b = 255, 120, 120 end)
        _SC_BG.AddLayer(self, "th09_7", false, 0, 0, 220, 0, 0, -0.2, "mul+rev", 2.2, 2.2,
                function(l) l.r, l.g, l.b = 200, 140, 230 end)
        _SC_BG.AddLayer(self, "th09_0", false, 0, 0, 0, 0, 0, 0, "", 1.9, 1.9,
                function(l) l.a = 135 end)
    end
end

do  -- Stage 9：映姬的符卡背景（审判 / 白金与青）
    class.scbg8 = Class(_SC_BG)
    function class.scbg8:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th09_0", false, 0, 0, 30, 0, 0, -0.3, "mul+add", 2.4, 2.4,
                function(l) l.a = 170; l.r, l.g, l.b = 255, 250, 200 end)
        _SC_BG.AddLayer(self, "th09_2", false, 0, 0, 0, 0.2, 0.2, 0.24, "mul+rev", 2.8, 2.8,
                function(l) l.r, l.g, l.b = 150, 210, 240 end)
        _SC_BG.AddLayer(self, "th09_5", false, 0, 0, 120, 0, 0, 0, "", 2.1, 2.1,
                function(l) l.a = 120 end)
    end
end

do  -- Stage 8：永琳的符卡背景（竹林 / 药与月）
    ---TH095 的 world09 是「永遠亭」那一幕（永琳与辉夜）。原作那张 world09.std 的贴图
    ---本仓库没有，改用 TH08（永夜抄）6B 那套永遠亭/竹林贴图（th08_16 = 竹林、
    ---th08_20 = 夜空、th08_15 = 云层，见 mod/GAME/th08.lua:89-95 的 SCBG7）。
    ---配色压在青绿（药）上，与辉夜那套（紫银）区分开。
    class.scbg9 = Class(_SC_BG)
    function class.scbg9:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_16", false, 0, 0, 0, 0, 0, 0.2, "mul+add", 2.2, 2.2,
                function(l) l.a = 150; l.r, l.g, l.b = 150, 240, 200 end)
        _SC_BG.AddLayer(self, "th08_20", true, 0, 0, 0, 0, 2, 0, "mul+rev", 2.8, 2.8,
                function(l) l.r, l.g, l.b = 130, 200, 190 end)
        _SC_BG.AddLayer(self, "th08_15", false, 0, 0, 90, 0, 0, 0, "", 2.0, 2.0,
                function(l) l.a = 110 end)
    end
end

do  -- Stage 8：辉夜的符卡背景（月 / 紫银）
    ---同一幕的另一位主角：底色换成 TH08 6B 的月面贴图（th08_21 + th08_19），
    ---配色压成紫银 —— 与永琳那套一眼分得开（§7.6 的换人换背景）。
    class.scbg10 = Class(_SC_BG)
    function class.scbg10:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th08_21", false, 0, 0, 0, 0, 0, -0.28, "mul+add", 3.2, 3.2,
                function(l) l.a = 175; l.r, l.g, l.b = 235, 200, 255 end)
        _SC_BG.AddLayer(self, "th08_19", true, 0, 0, 0, 0, 2, 0, "mul+rev", 2.6, 2.6,
                function(l) l.r, l.g, l.b = 190, 165, 245 end)
        _SC_BG.AddLayer(self, "th08_15", false, 0, 0, 140, 0, 40, 0, "", 2.1, 2.1,
                function(l) l.a = 120 end)
    end
end

do  -- Stage 7：咲夜的符卡背景（银白 / 时停）
    ---TH095 的 world07 是「红魔馆」那一幕（咲夜与レミリア）。原作那张 world07.std 的贴图
    ---本仓库没有，改用 TH07（妖妖梦）与 TH09 的银白/冰蓝系贴图（th07_9 / th09_5 /
    ---th08_15 都已在上面几套背景里用过），配色压成月白。理由同上面几套：换人换背景（§7.6）。
    class.scbg11 = Class(_SC_BG)
    function class.scbg11:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_9", false, 0, 0, 0, 0, 0, -0.3, "mul+add", 2.6, 2.6,
                function(l) l.a = 165; l.r, l.g, l.b = 225, 235, 255 end)
        _SC_BG.AddLayer(self, "th09_5", false, 0, 0, 200, 0, 0, 0.2, "mul+rev", 2.2, 2.2,
                function(l) l.r, l.g, l.b = 190, 205, 235 end)
        _SC_BG.AddLayer(self, "th08_15", false, 0, 0, 90, 0, 0, 0, "", 1.9, 1.9,
                function(l) l.a = 120 end)
    end
end

do  -- Stage 7：レミリア的符卡背景（血红 / 夜）
    ---同一幕的另一位主角：底换成 TH06（红魔乡）的两张血色贴图，配色压成深红 —— 与咲夜
    ---那一套月白一眼分得开。
    class.scbg12 = Class(_SC_BG)
    function class.scbg12:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 0, 0, 0, 0.26, "mul+add", 2.8, 2.8,
                function(l) l.a = 175; l.r, l.g, l.b = 255, 70, 90 end)
        _SC_BG.AddLayer(self, "th06_4", false, 0, 0, 220, 0, 0, -0.22, "mul+rev", 2.4, 2.4,
                function(l) l.r, l.g, l.b = 255, 140, 150 end)
        _SC_BG.AddLayer(self, "th10_3", false, 0, 0, 0, 0, 0, 0, "", 2.0, 2.0,
                function(l) l.a = 130 end)
    end
end

do  -- Stage 6：橙的符卡背景（橙黄 / 猫）
    ---换人换背景（§7.6）：TH095 的 world06 贴图本仓库没有，沿用上面几套已经在用的
    ---TH06/TH07 贴图，只换层数 / 转速 / 配色 —— 压成橙黄，和下面藍那一套靛蓝一眼分得开。
    class.scbg13 = Class(_SC_BG)
    function class.scbg13:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th06_6", false, 0, 0, 0, 0, 0, 0.3, "mul+add", 2.5, 2.5,
                function(l) l.a = 170; l.r, l.g, l.b = 255, 190, 90 end)
        _SC_BG.AddLayer(self, "th07_1", false, 0, 0, 200, 0, 0, -0.24, "mul+rev", 2.1, 2.1,
                function(l) l.r, l.g, l.b = 255, 175, 110 end)
        _SC_BG.AddLayer(self, "th07_6", false, 0, 0, 110, 0, 0, 0, "", 1.9, 1.9,
                function(l) l.a = 140; l.r, l.g, l.b = 255, 215, 150 end)
    end
end

do  -- Stage 6：八云蓝的符卡背景（靛蓝 / 星）
    ---同一幕的另一位主角：底换成 TH07 的星纹贴图（th07_6 + th07_9），配色压成靛蓝。
    ---和 th095.lua:29-39 的 ran_bg 是同一套贴图的不同配法（那张是她 Stage 2 的背景）。
    class.scbg14 = Class(_SC_BG)
    function class.scbg14:init()
        _SC_BG.init(self)
        _SC_BG.AddLayer(self, "th07_6", false, 0, 0, 0, 0, 0, 0.26, "mul+add", 2.6, 2.6,
                function(l) l.a = 165; l.r, l.g, l.b = 130, 150, 255 end)
        _SC_BG.AddLayer(self, "th07_9", false, 0, 0, 180, 0, 0, -0.22, "mul+rev", 2.3, 2.3,
                function(l) l.r, l.g, l.b = 105, 120, 235 end)
        _SC_BG.AddLayer(self, "th08_15", false, 0, 0, 90, 0, 0, 0, "", 1.9, 1.9,
                function(l) l.a = 130 end)
    end
end

---──────────────────── 「已拍张数」（原作 camera.photoIndex） ────────────────────
---原作有四处读 camera.photoIndex（th095/src/EclOperandsInt.cpp:186 的 0x2761）来定弹数 /
---间隔：卡 71 的自机狙大圈间隔、卡 75 的每圈弹数、卡 74 的小圈圈数、卡 76 的俯冲速度。
---本仓库**不实现拍照** —— 项目自带拍照自机射命丸文：THlib/player/aya/aya.lua:191 给
---player 挂了 player.camera，快门由玩家自己按（aya.lua:59-62 → aya_system.lua 的
---TenguCamera:GetPhoto）。
---原作的 photoIndex 是**这一关里按过快门的张数**（按了就加、拍空也算，见
---PhotoCamera.cpp:503 附近的计数）；按作者要求这里换成**拍中本体的张数**：只有先过
---取景框判定、真的打到本体的那一下才算（记在下面 take_damage2 的包装里），按空枪不加。
---⇒ 每波弹的密度只跟着「打中本体几次」涨，拍空的快门不该让下一波更密。
---⚠ 一处口径差异：原作 photoIndex 是**关卡内累计**的；这里改成「本卡内、拍中本体才加」，
---  老存档的 scoredata.total_photocount 不再影响密度。每张卡在自己的 init
---  （photo_damage_on）里把计数清零 —— 原作 7 幕本来就是各自独立的选关、各自从 0 开始。
---  各卡按自己的 ins_141 上限截断（例如卡 71 的 0..7）。
local photo_hits = 0

---本卡（原作的「这一关」）拍中本体的张数，按各卡的 ins_141 上限截断。
local function photo_index(limit)
    return min(photo_hits, limit)
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
---于是本关卡把血条换成「拍照计数」：卡在 init 里写 self.photo_damage_limit = N、
---在 del 里清掉；被拍到就按「这是拍中的第几张」**重算**剩余血量
---    remain = maxhp × (1 − 第几张/N)
---第 N 张硬取 0 ⇒ 拍够 N 张**正好**清空，和原作等价。
---★ 为什么不逐张扣 maxhp/N：maxhp/N 是除不尽的浮点数，N 次相加与 maxhp 差一个 ulp
---  —— 实测 950/7 连扣 7 次后 hp 还剩 1e-13 级的正数，血条上就是「一丝血」。
---  remain 在第 N 张直接落 0，没有累加误差。
---★ 顺便：这个包装也是「拍中本体」的唯一入口 ⇒ photo_hits 在这里 +1（见上面那一节）。
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
        local limit = self.photo_damage_limit
        if not limit then
            ---本关卡没标记过的 boss：原样交给原函数（THlib/enemy/boss.lua:66）。
            return boss_take_damage2(self, dmg)
        end
        ---拍中本体：本卡计数 +1（photo_index 靠它；见上面那一节）。
        self.photo_hit_count = (self.photo_hit_count or 0) + 1
        photo_hits = photo_hits + 1
        local hits = min(self.photo_hit_count, limit)
        ---「拍中第 hits 张」之后本体应该剩的血；第 N 张直接 0（不靠累减，见上）。
        local remain = hits >= limit and 0 or self.maxhp * (1 - hits / limit)
        if remain > self.hp then
            remain = self.hp            -- 子弹已经打掉更多时不要把血加回来
        end
        ---enemybase.take_damage 是「计分 / 掉落 / 受击音」那一半
        ---（THlib/enemy/enemy.lua:94），原函数也是先调它再扣血（boss.lua:66-74）；
        ---照抄，让拍的这一下该响的响、该掉的掉（伤害值用名义上的 maxhp/N）。
        enemybase.take_damage(self, self.maxhp / limit)
        if self.dmgmaxt then
            self.dmgt = self.dmgmaxt        -- 受击闪烁（原函数 boss.lua:68-69）
        end
        if not self.protect then
            local dmg0 = self.hp - remain
            self.spell_damage = self.spell_damage + dmg0
            self.hp = remain
        end
    end
end

---给「这一张卡」的本体挂上拍照扣血：limit = 本卡的 ins_141（拍够这么多张 = 清空血条）。
---顺便把「拍中本体的张数」清零（photo_index 的能量来源）。
---init 里调（setStatus 设 maxhp 与 card.init 在同一帧，boss_system.lua:952/955），
---del 里用 photo_damage_off 收掉，免得别的 boss 沾到。
local function photo_damage_on(boss_obj, limit)
    boss_obj.photo_damage_limit = limit
    boss_obj.photo_hit_count = 0
    photo_hits = 0
end

local function photo_damage_off(boss_obj)
    boss_obj.photo_damage_limit = nil
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

---──────────────────── Stage EX（scene group 10）的四个 boss 组 ────────────────────
---TH095 的 Stage EX 是 scene group 10 = scene 100..107（SceneSelect.cpp:165-172），
---八个 scene 分属四位角色、四张场地（world05/06/09/10），八张符卡：
---  100 ecl22_a 芙兰 禁忌「フォービドゥンフルーツ」   101 ecl22_b 芙兰 禁忌「禁じられた遊び」
---  102 ecl23_a 紫   境符「色と空の境界」             103 ecl23_b 紫   境符「波と粒の境界」
---  104 ecl24_a 妹红 貴人「サンジェルマンの忠告」     105 ecl24_b 妹红 蓬莱「瑞江浦嶋子と五色の瑞亀」
---  106 ecl25_a 萃香 鬼気「濛々迷霧」                 107 ecl25_b 萃香 「百万鬼夜行」
---原作是八张**各自独立选关**的卡；这里按角色归成四个组（§8：一个角色一个组）：
---  组 3a = 芙兰（100/101）、组 4a = 紫（102/103）、组 5a = 妹红（104/105）、组 6a = 萃香（106/107）。
---main_stage.lua 的 TH33 里连着调 boss.CreateGroup(3..6, 31) 就会依次打完这八张。
---★ 同样别把两个角色塞进同一组的 a、b：CreateGroup 会把 a、b 一起建出来（两人同时上场）。
---四人共用同一首 BGM：八个 scene 都是 bgm/th095_03.wav（SceneSelect.cpp:165-172），
---也就是 music.lua 里的 "TH09_5_1"（東の国の眠らない夜）——**不要用 TH07_1**，
---那是上一批 world08 七幕的曲子。场景背景沿用本关的 TH095_bg。
---出生点同样都在左上角外 (-128, 288)：每一幕的本体都是从这里进场。
boss.Define("3a", "芙兰朵露·斯卡雷特", "TH09_5_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg3, "Flandre", LEVEL)
boss.Define("4a", "八云紫", "TH09_5_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg4, "Yukari", LEVEL)
boss.Define("5a", "藤原妹红", "TH09_5_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg5, "Mokou", LEVEL)
boss.Define("6a", "伊吹萃香", "TH09_5_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg6, "Suika", LEVEL)

---──────────────────── Stage 9（scene group 9 = world10）的两个 boss 组 ────────────────────
---TH095 的 scene group 9 是 scene 90..97（SceneSelect.cpp:156-163），八幕分属两位角色、
---同一张场地 world10（三途の川 / 彼岸）：
---  90 ecl20_a 小町 非符（这一关的第 1 张**没有** ins_104，不显示卡名）
---  91 ecl21_a 映姬 嘘言「タン・オブ・ウルフ」
---  92 ecl20_b 小町 死歌「八重霧の渡し」
---  93 ecl21_b 映姬 審判「十王裁判」
---  94 ecl20_c 小町 古雨「黄泉中有の旅の雨」
---  95 ecl21_c 映姬 審判「ギルティ・オワ・ノットギルティ」
---  96 ecl20_d 小町 死価「プライス・オブ・ライフ」
---  97 ecl21_d 映姬 審判「浄頗梨審判　-射命丸文-」
---八幕共用 world10.std 与 enm20/21.anm；BGM 七幕是 bgm/th095_04.wav（= music.lua 的
---"TH07_1"），只有 scene 97 原作换了 bgm/th09_08_2.wav（小町的主题曲）—— 那份素材本仓库
---没有，所以整组沿用 "TH07_1"（SceneSelect.cpp:163 是唯一一处例外，见文件头）。
---按「一个角色一个组」（§8）拆成两组：组 7 = 小町（90/92/94/96）、组 8 = 映姬（91/93/95/97）。
---★ 别把两人塞进同一个组的 a、b：CreateGroup 会把 a、b 一起建出来（两人同时上场）。
---出生点同样都在左上角外 (-128, 288)：每一幕的本体都从那里进场。
boss.Define("7a", "小町", "TH07_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg7, "Komachi", LEVEL)
boss.Define("8a", "映姬", "TH07_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg8, "Shikieiki", LEVEL)

---──────────────────── Stage 8（scene group 8 = world09）的两个 boss 组 ────────────────────
---TH095 的 scene group 8 是 scene 80..87（SceneSelect.cpp:150-158），八幕分属两位角色、
---同一张场地 world09（永遠亭），BGM 全部是 bgm/th095_04.wav（= music.lua 的 "TH07_1"，
---和 world08/world10 同一首；SceneSelect.cpp:150-158）：
---  80 ecl18_a 永琳 非符（这一关第 1 张；**没有** ins_104，不亮卡名）
---  81 ecl19_a 辉夜 新難題「月のイルメナイト」
---  82 ecl18_b 永琳 薬符「胡蝶夢丸ナイトメア」
---  83 ecl19_b 辉夜 新難題「エイジャの赤石」
---  84 ecl18_c 永琳 錬丹「水銀の海」
---  85 ecl19_c 辉夜 新難題「金閣寺の一枚天井」
---  86 ecl18_d 永琳 秘薬「仙香玉兎」
---  87 ecl19_d 辉夜 新難題「ミステリウム」
---按「一个角色一个组」（§8）拆成两组：组 9 = 永琳（80/82/84/86）、组 10 = 辉夜（81/83/85/87）。
---★ 别把两人塞进同一个组的 a、b：CreateGroup 会把 a、b 一起建出来（两人同时上场）。
---出生点同样都在左上角外 (-128, 288)：每一幕的本体都从那里进场。
---立绘：永琳 "Yagokoro"、辉夜 "Neet"（BossImageList.lua:44-45 里两个都登记过，
---和 mod/GAME/th08-boss1.lua:1394-1395 用的是同一对 —— 就是这两位）。
boss.Define("9a", "八意永琳", "TH07_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg9, "Yagokoro", LEVEL)
boss.Define("10a", "蓬莱山辉夜", "TH07_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg10, "Neet", LEVEL)

---──────────────────── Stage 7（scene group 6 = world07）的两个 boss 组 ────────────────────
---TH095 的 scene group 6 是 scene 60..67（SceneSelect.cpp:126-133），八幕分属两位角色、
---同一张场地 world07（红魔馆），BGM 全部是 bgm/th095_03.wav（= music.lua 的 "TH07_1"）：
---  60 ecl14_a 咲夜 非符                     61 ecl15_a レミリア 魔符「全世界ナイトメア」
---  62 ecl14_b 咲夜 時符「トンネルエフェクト」 63 ecl15_b レミリア 紅符「ブラッディマジックスクウェア」
---  64 ecl14_c 咲夜 空虚「インフレーションスクウェア」 65 ecl15_c レミリア 紅蝙蝠「ヴァンパイリッシュナイト」
---  66 ecl14_d 咲夜 銀符「パーフェクトメイド」 67 ecl15_d レミリア 神鬼「レミリアストーカー」
---按「一个角色一个组」拆：组 11 = 咲夜（60/62/64/66）、组 12 = レミリア（61/63/65/67）。
---★ 别把两人塞进同一个组的 a、b：CreateGroup 会把 a、b 一起建出来（两人同时上场）。
---出生点同样都在左上角外 (-128, 288)：每一幕的本体都从那里进场。
---立绘：咲夜 "Sakuya"、レミリア "Remilia"（BossImageList.lua:17-18 都登记过）。
boss.Define("11a", "十六夜咲夜", "TH07_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg11, "Sakuya", LEVEL)
boss.Define("12a", "レミリア・スカーレット", "TH07_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg12, "Remilia", LEVEL)

---──────────────────── Stage 6（scene group 5 = world06）的两个 boss 组 ────────────────────
---TH095 的 scene group 5 是 scene 50..57（SceneSelect.cpp:120-127），八幕分属两位角色、
---同一张场地 world06，BGM 全部是 bgm/th095_03.wav（= music.lua 的 "TH07_1"）：
---  50 ecl12_a 橙 非符                     51 ecl13_a 八云蓝 人智剣「天女返し」
---  52 ecl12_b 橙 星符「飛び重ね鱗」          53 ecl13_b 八云蓝 妄執剣「修羅の血」
---  54 ecl12_c 橙 鬼神「鳴動持国天」          55 ecl13_c 八云蓝 天星剣「涅槃寂静の如し」
---  56 ecl12_d 橙 化猫「橙」                 57 ecl13_d 八云蓝 四生剣「衆生無情の響き」
---按「一个角色一个组」拆：组 13 = 橙（50/52/54/56）、组 14 = 八云蓝（51/53/55/57）。
---★ 别把两人塞进同一个组的 a、b：CreateGroup 会把 a、b 一起建出来（两人同时上场）。
---出生点（ins_63 的第一个参数）：50/51/53/55 是 (-128, 288)、52 是 (128, 288)、
---56/57 是 (-2, 288)；Define 里只能给一个，所以八张卡各自的 init 会照 Sub2 的 ins_63
---把本体摆回原位（和 Stage 7 的 ins_63 一样）。
---立绘：橙 "Chen"、八云蓝 "Ran"（BossImageList.lua:24/32 都登记过，
---和 mod/GAME/th07.lua:223/833/1018 用的是同一对）。
boss.Define("13a", "橙", "TH07_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg13, "Chen", LEVEL)
boss.Define("14a", "八云蓝", "TH07_1", TH095_bg,
        { -128, field_y(-64) }, class.scbg14, "Ran", LEVEL)

do  -- 71 幽雅「死出の誘蛾灯」（ecl17_a，幽幽子，组 1a 第 1 张）
    ---原作是「蛾扑向灯」：本体从场外落到中轴，**一条**发弹上下文每 8 帧甩出**两组**
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

    ---主弹幕（Sub4，dump 的 @860-1180）：**一条**上下文、**一轮 8 帧**、一轮发**两组** 16 发。
    ---  @920  t=0  ins_101(0, 0x20, 0, 120, -1, -0.025,  0.019635)  ← 写 slot0（被下面那行覆盖）
    ---  @960  t=0  ins_89(15, 4, 16, 1, 4.0, 1.5, floatV0, 0.0327249, 546)  ← 第 1 组：色号 4
    ---  @1004 t=0  ins_101(0, 0x20, 0, 120, -1, -0.025, -0.019635)  ← 同一个 slot 再写一遍
    ---  @1044 t=4  ins_89(15, 5, 16, 1, 4.0, 1.5, floatV1, 0.0327249, 546)  ← 第 2 组：色号 5
    ---  @1088/1124 t=4  ins_15 / ins_16(floatV0 / floatV1, 0.01309)  ← floatV0 +0.75°、floatV1 −0.75°
    ---  @1108/1144 t=4  ins_37(floatV0 / floatV1)                    ← 归一化到 (−π,π]
    ---  @1160 t=8       ins_4(0, -240) → time 设回 0、跳回 @920
    ---四条**对着源码核过**的读数（旧版注释在这几条上写错过，别再照抄）：
    ---  · ins_89 的 aimMode = opcode − 0x56 = 3 = CIRCLE（EnemyShotDispatch.cpp:145、
    ---    BulletManager.hpp:167）：angle = angle + index1×2π/count1 + index2×angleStep，
    ---    而 count2 = 1 ⇒ 操作数里那个 0.0327249 rad（1.875°）**根本没参与**
    ---    （BulletManager.cpp:368-372 的 CIRCLE 分支）。
    ---  · 一轮是 **8 帧**：ins_4(0,-240) 在 t=8 把 ctx->time 拨回 0 并跳回 @920，而解释器
    ---    跳转后会**在同一帧**继续派发 time 与新值相等的指令（EclRunLow.inl:242-246 的
    ---    `goto low_redispatch_instruction`；th31.lua:2758 记着同一条）⇒ t=0 那一组在
    ---    跳跃的**那一帧**就再放一次。于是稳态下一轮 = 8 帧：第 1 组在跳回的那一帧、
    ---    第 2 组在 4 帧后（t=8 与 t=4 的 frame 相隔 4 帧，t=0 与 t=4 同理）。
    ---  · ins_37 **不是取反**、是归一化（EclRunLow.inl:357-363 调 AddNormalizeAngle，
    ---    RuntimeMath.cpp:7 把角折进 (−π,π]）⇒ 两个基准角各自**单调**转，不是来回翻。
    ---  · ins_101 是「往第 N 号 transform 槽里写一条记录」（EclRunTargetHigh.inl:45-63）。
    ---    slot0 被写了**两遍**（@920 的 +0.019635 与 @1004 的 −0.019635）：descriptor 是
    ---    被后来的那条覆盖，但**两组弹各在发弹那一刻抄一份**（BulletManager.cpp:484）
    ---    ⇒ 色号 4 抄到 +0.019635、色号 5 抄到 −0.019635，两组**反向**自转（不是同向）。
    ---    speedDelta 两遍都是 −0.025/帧，所以两组一起在 120 帧里从 4.0 减到 1.0。
    local CYCLE, SPLIT = 8, 4
    local RING_COUNT = 16                   -- ins_89 的 count1 ⇒ 16 等分 22.5°
    local RING_SPEED = 4.0                  -- ins_89 的 speed1（count2 = 1 ⇒ speed2 不参与）
    ---两个基准角**不是同一个**：t=4 的 ins_15(floatV0, 0.01309) 加、ins_16(floatV1, 0.01309)
    ---减（case 15 = 加、case 16 = 减；EclRunLow.inl:269/273）⇒ 两组基准角每轮**反向**各转
    ---0.75°，越拉越开 —— 这就是「两组蝶弹」在屏幕上分成两圈的原因。换算到我们这边
    ---（TH095 正角 = 顺时针 ⇒ 取反）：floatV0 那组每轮 −BASE_STEP、floatV1 那组 +BASE_STEP。
    local BASE_STEP = 0.75
    local RING_STYLE = butterfly
    ---色号照原作：两组分别是 color 4 与 color 5。butterfly 不是 colorful 样式 ⇒
    ---贴图下标 = ceil(色号/2)（Lresources.lua:208 的 LoadImageGroup + bulletStyle.lua:64
    ---的 init），于是两组正好落在 butterfly2 / butterfly3 **两张不同的贴图**上。
    local RING_COLOR_A, RING_COLOR_B = COLOR.PURPLE, COLOR.DEEP_BLUE

    ---圈里每一颗自己会**一边转一边减速**（Sub4 的 ins_101 slot0，kind = 0x20 = 极坐标加速，
    ---PhotoBulletSpawnDescriptor.hpp:100；实现在 BulletManager.cpp:822-841 的
    ---UpdatePolarAcceleration）：每帧 angle += angleDelta、speed += speedDelta，
    ---持续 int0 = 120 帧，之后整条 transform 失效、弹保持最后的速度与方向直飞。
    ---  angleDelta = ∓0.019635 rad/帧 = ∓1.125°/帧 —— TH095 是「顺时针为正」，换算到
    ---  我们「逆时针为正」的坐标系要**取反**。RING_SPIN 只记大小，两组在 fire_ring 里
    ---  一个拿 −RING_SPIN、一个拿 +RING_SPIN（见下面 fire_ring 的注释）；
    ---  speedDelta = −0.025/帧 ⇒ 4.0 在 120 帧里线性掉到 1.0。
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
    ---    ins_21(extraIntV0, 120, extraIntV0) → 120 − 它、ins_2 等这么多帧。
    ---    ins_2 = SET_SECONDARY_TIME：**设它的那一帧就已经算掉 1 帧** —— dispatch 顶部
    ---    看到 secondaryTime > 0 就 secondaryTime-- 与 time-- 相抵、本帧到此为止
    ---    （EclRun.cpp:296-303），帧末再统一 time++（同文件 :422）⇒ 冻结 N 帧之后
    ---    下一发**正好隔 N 帧**，不是 N+1（th31.lua:15230-15235 对同一条指令也是这么算的；
    ---    旧版这里按 N+1 写成 121，自机狙每圈慢 1 帧）。
    ---    ⇒ 每 (120 − 10×photoIndex) 帧一圈，拍得越多压得越密；
    ---    photoIndex ≤ 7（ins_141(7)）⇒ 最密 50 帧，正好是 AIM_GAP_MIN。
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
    ---★ Sub3 的时间基准：它是 Sub2 在 t=130 用 ins_52(3) **同步调用**进来的
    ---（CallSubOnEnemy → EclRunTargetHigh.inl:147 的 enter_subroutine），而 CallEclSub
    --- 会把子上下文的 time 清零（EnemyManagerUpdate.cpp:172-186）⇒ **Sub3 的 t=N 是
    ---「入场结束（第 130 帧）之后再过 N 帧」**，不是第 N 帧。
    ---  所以 Sub3 的 t=600 = 第 730 帧。旧版写成 `MOTH_WAIT - ENTRY_WAIT - ENTRY_TIME`
    ---（= 第 600 帧）早了 130 帧，这里按原文改成「入场之后再等 600 帧」。
    local MOTH_WAIT = 600                   -- Sub3 的 t=600（第 730 帧）
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
---自转方向存在弹自己身上（unit.ring_spin）：原作是**发弹前**把 ins_101 写进 descriptor、
---发弹时整份抄给弹（BulletManager.cpp:484 memcpy）—— 两组色号之间 @1004 又改写过一次，
---所以两组抄到的 angleDelta 符号相反（见 fire_ring）。
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
        object.SetV(unit, unit.ring_v, unit.rot + unit.ring_spin, true)
    end

---一整圈 16 发（圈里每一颗自己还要转 + 减速，见 ring_frame）；
---spin = 这一圈的自转角速度（度/帧），两组取相反符号。
    local function fire_ring(owner, base, color, spin)
        for i = 0, RING_COUNT - 1 do
            local b = NewSimpleBullet(RING_STYLE, color, owner.x, owner.y, RING_SPEED,
                    base + i * 360 / RING_COUNT, false, 0, false,
                    nil, nil, nil, ring_frame)
            b.ring_spin = spin
        end
        -- transformFlags 的 0x200 = PLAY_SPAWN_SOUND：一整圈只响一声（BulletManager.cpp:717-723）。
        PlaySound("tan00", 0.1, owner.x / 256, false)
    end

    ---主弹幕（Sub4 = ins_117(0,4) 的**子 ECL 上下文**，不是子敌机）：一条上下文、一轮两组。
    ---两条基准角 floatV0/floatV1 从同一个 playerAngle 起，但每轮**反向**转 0.75°（见常量段的
    ---BASE_STEP 注释）⇒ 两组各转各的，这里跟着存两个 base。
    ---★ 两组的自转**方向相反**：slot0 在 @920 先写 angleDelta = +0.019635、@1004 又改成
    ---  −0.019635，而弹是**发弹那一刻**把 descriptor 整份抄走的（BulletManager.cpp:484）
    ---  ⇒ 色号 4 那一组抄到 +0.019635、色号 5 那一组抄到 −0.019635，换算到我们这边
    ---  就是 −RING_SPIN 与 +RING_SPIN（两组反向卷，不是同向）。
    ---★ 两组必须**各卷各的**：自转方向与基准角只要有一处跟着对方走，第二组就会贴着第一
    ---  组的弹道飞（同向 + 同 base ⇒ 第二组只是延迟 4 帧的复制品）—— 16 条弹道上叠两组，
    ---  屏幕上只数得出 16 条臂，正是作者报的「子弹少一半」。原件是**反向自转 + 两组基准角
    ---  每轮各背向 0.75°**，臂越拉越开 ⇒ 32 条臂。这里照原件分开存 base_a / base_b。
    ---★ 节拍照抄那个循环本身：t=0 发 A、t=4 发 B、t=8 跳回 t=0 —— 用**逐帧计数器**
    ---  实现，而不是 task.Wait(4)。理由：真机与桩件对「等一帧」的记账差一帧
    ---  （THlib/lib/Ltask.lua:68-77 的 task.Wait(t) = yield t 次，真机每次 resume 推进一帧
    ---  ⇒ Wait(4) 正好 4 帧；tools/check_stage.lua 的等待计数每帧减一，同一句变成 5 帧），
    ---  而这条弹幕的相位很敏感 —— 用计数器两边就是同一把尺子，自检读数 = 真机读数。
    ---  计数器由 card.frame 驱动：boss_system.lua:133 每帧调一次 `b.current_card.frame(b)`，
    ---  所以「过了几帧」就是帧号，t ≡ 0 / 4 (mod 8) 与原作逐条对齐。
    local ring_t = nil                      -- 开始发弹之后的帧数（nil = 还没开始）
    local ring_base_a, ring_base_b = 0, 0   -- 两组基准角（原作的 floatV0 / floatV1）

    local function ring_begin(owner)
        ring_base_a = Angle(owner, player)
        ring_base_b = ring_base_a
        ring_t = 0
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
            ring_begin(self)
            ---Sub3 的 t=600（第 730 帧）：亮卡名 → 起自机狙大圈 + 放出蛾。
            ---（我们这边卡名由符卡系统在开场就亮，所以这里只做后两件。）
            ---MOTH_WAIT 是 Sub3 自己的时间（见常量段的说明）⇒ 入场之后直接等它。
            task.Wait(MOTH_WAIT)
            for i = 1, MOTH_COUNT do
                moths[i] = New(class.moth, self, (i - 1) * 180)
            end
            aim_stream(self)
        end)
    end

    ---本体的逐帧逻辑：原作里移动与发弹都挂在 ECL 上下文上，这里只驱动 Sub4 那个
    ---8 帧循环的计数器（见上面 ring_t 的注释）。计数器就绪之后每帧进一次，
    ---相位 0 发第 1 组、相位 SPLIT 发第 2 组并在同一拍推进两组基准角
    ---（原作 @1088/1124 的 ins_15/ins_16 紧跟在 @1044 的第二组之后）。
    function card:frame()
        if not ring_t then
            return
        end
        ---卡结束时本体会先被打死（hp 落 0，checkHP 立刻走 object.Kill，boss_system.lua:351-361），
        ---之后 current_card 还指着这张卡、frame 仍会被调上几帧 —— 自己停手，别在死后接着发弹。
        ---★ 判据只能用 hp，**不能**用 `self.is_combat`：真机上 is_combat 由 setStatus
        ---  （boss_system.lua:874）置 true，可自检桩件的 boss_obj（tools/check_stage.lua:1789）
        ---  根本没这个字段 ⇒ `not self.is_combat` 恒真、蝶弹一帧都发不出来（自检读数全假）。
        ---  hp 两边都有：真机 = 卡结束落 0，桩件 = 9999（永不触发），行为一致。
        ---  `self.hp and` 这一层只是「万一是 nil 也当停手」，顺便满足
        ---  tools/check_fields.lua 对 frame 内读字段必须带守卫的要求。
        if self.hp and self.hp <= 0 then
            ring_t = nil
            return
        end
        local phase = ring_t % CYCLE
        if phase == 0 then
            fire_ring(self, ring_base_a, RING_COLOR_A, -RING_SPIN)   -- @960 t=0：色号 4
        elseif phase == SPLIT then
            fire_ring(self, ring_base_b, RING_COLOR_B, RING_SPIN)    -- @1044 t=4：色号 5
            ---@1088/1124 的 ins_15 / ins_16（@1108/1144 的 ins_37 只是归一化）：
            ---两组基准角反向各转 0.75°，下一轮生效 —— 两组越拉越开。
            ring_base_a = (ring_base_a - BASE_STEP) % 360
            ring_base_b = (ring_base_b + BASE_STEP) % 360
        end
        ring_t = ring_t + 1
    end

    function card:del()
        ---卡结束（kill -> current_card.del(b)，boss_system.lua:241）时把发弹计数器也收掉：
        ---超时结束（hp 没到 0）时 frame 里那条 hp 判据不会触发，这里兜住不多吐一轮。
        ring_t = nil
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
---每档带自己的 (intV6, intV7)。ins_94/ins_87 的操作数顺序是
---(type, color, count1, count2, speed1, speed2, angle, angleStep, flags)
---（ShotArgs, EnemyShotDispatch.cpp:83-95 的字段顺序）⇒
---  · **intV6 = Sub5 乱枪的色号**（count1 是字面量 64，不是 intV6）；
---  · **intV7 = Sub4 死槍的色号**（count1 是字面量 1）—— 三档的区别只有颜色。
---(intV6, intV7) = (6,3) / (8,4) / (10,5)（Sub3 的 ins_6 逐档改）。
    local WAVES = {
        { delay = 60, x = 128, y = 16, volley_color = 6, spear_color = 3 },
        { delay = 120, x = 96, y = -32, volley_color = 8, spear_color = 4 },
        { delay = 90, x = 64, y = -64, volley_color = 10, spear_color = 5 },
    }

---子机（Sub5）在 t=60 那一帧一次做四件事：
---  ins_145(12, intV7, 8, playerAngle, 256, 24) —— 直激光（色号 = intV7）
---  ins_94(1, intV6, **64**, 4.0, 0.5, playerAngle+80°/+280°, 512) —— 64 发的 RANDOM 乱枪
---  ins_117(0,4) —— 起 Sub4 子上下文（下面那个每 2 帧一发单发直弹的「死槍」）
---  ins_65(playerAngle, 8) —— 子机自己朝自机冲（8 px/帧）
    local DRONE_FIRE_DELAY = 60
    local DRONE_DASH = 8
    local LASER_SPEED = 8                   -- ins_145 第 3 个操作数
    local LASER_LEN = 256                   -- 第 5 个：最大长度
    local LASER_GROW = LASER_LEN / LASER_SPEED  -- 32 帧长满
    local LASER_W = 10                      -- 我们 laser 的 w（命中半宽 = w/2，见 laser.lua）
    local LASER_SUSTAIN, LASER_FADE = 40, 20

---Sub4（子上下文）：ins_87(15, intV7, 1, 1, 0.02, 1.5, playerAngle, 0.0327249, 536)。
---★ 对着 ShotArgs 读一遍：**count1 = 1**、intV7 是**色号**（旧注释把它当成发数，错）。
---所以「死槍」是**一帧一发单发直弹**、朝自机，不是 3~5 发的窄扇；节拍每 **2 帧**一发
---（Sub4 的 ins_4(0,-116) 在 t=2 跳回 @1404）。三档子机的区别只有色号 3/4/5。
---出膛点每发重抽：@1404 的 ins_27(·, 24, randF32) + ins_38 把「半径 ≤24 px 的随机点」
---算成二维偏移、ins_100 写进 shootOffset ⇒ 死槍围着子机散开，不是一条精确的线。
---536 = 0x218 = 0x200 出场音 + 0x10 矢量加速 + 0x8 慢出；ins_101(0, 0x10, 0, 120, -1,
---1/120, -999.99) 再给弹挂上「沿自身方向 120 帧、每帧 +1/120 px/帧」的加速
---（0x10 = ACCELERATE_VECTOR，BulletManager.cpp 的 UpdateVectorAcceleration），
---于是 0.02 一路加到 ~1.02 之后常速飞出去。
    local FAN_INTERVAL = 2
    local FAN_OFFSET_R = 24                 -- ins_27 的第 2 个操作数：出膛点随机半径
    local FAN_STEP = 1.875                  -- angleStep：count1 = 1 ⇒ 本卡不参与，留着备查
    local FAN_SPEED = 0.02
    local FAN_ACCEL = 1 / 120
    local FAN_ACCEL_FRAMES = 120
    local FAN_STYLE = butterfly
    local FAN_COLOR = COLOR.PURPLE

---乱枪（ins_94，aimMode 8 = RANDOM）：angle = random(angle ∓ angleStep)、
---speed = random(speed2, speed1)（BulletManager.cpp:383-395）。
---ins_94 的参数 = (type 1, color intV6, **count1 = 64**, count2 = 1, speed1 = 4, speed2 = 0.5,
---angle = floatV0, angleStep = floatV1, flags = 512) ⇒ 一发就是 **64 颗**（不是 intV6×64）。
---floatV0/floatV1 的算法（Sub5 的 ins_25/ins_7/ins_16/ins_15，EclRunLow.inl:296/251/273/269）：
---  floatV0 = playerAngle + π → floatV1 = floatV0 → floatV0 −= 100°、floatV1 += 100°
---  ⇒ 操作数里 floatV0 = playerAngle + 80°、floatV1 = playerAngle + 280°。
---RANDOM 分支算的是 GetRandomF32InRange(angle − angleStep) + angleStep；range 为负
---（80−280 = −200°）时落在 [angleStep − 200°, angleStep] = [playerAngle+80°, playerAngle+280°]
---⇒ **以背对自机方向（playerAngle+180°）为中心、宽 200° 的扇**。
---速度同样随机：RANDOM 分支 speed = random(speed2, speed1) = random(0.5, 4.0)。
    local VOLLEY_ARC = 100
    local VOLLEY_COUNT = 64                 -- ins_94 的 count1
    local VOLLEY_SPEED1, VOLLEY_SPEED2 = 4.0, 0.5
    local VOLLEY_STYLE = water_drop

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
    ---★ ins_87 的 flags 536 里还有 0x8 = SPAWN_SLOW（出场时先退到 velocity×4 再滑回来，
    ---BulletManager.cpp:445-478）；本文件统一不做这层出场滑动（见文件头差异 10），
    ---速度曲线与弹数不变，只是这发「死槍」早几帧到位。
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

---Sub4 的一发「死槍」：**单发**朝自机；出膛点每发在子机周围 24 px 内重抽。
---color = intV7（三档 3/4/5）。
    local function fire_fan(x, y, color)
        local base = Angle(x, y, player.x, player.y)
        local pa = ran:Float(0, 360)
        local pr = FAN_OFFSET_R * ran:Float(0, 1)
        NewSimpleBullet(FAN_STYLE, color,
                x + cos(pa) * pr, y + sin(pa) * pr,
                FAN_SPEED, base, false, 0, false,
                nil, nil, nil, spear_frame)
    end

---Sub5 的一片乱枪：64 颗、整片背对自机（±100°）、随机角度、随机速度。
---color = intV6（三档 6/8/10）。
    local function fire_volley(x, y, color)
        local center = Angle(x, y, player.x, player.y) + 180
        for _ = 1, VOLLEY_COUNT do
            NewSimpleBullet(VOLLEY_STYLE, color, x, y,
                    ran:Float(VOLLEY_SPEED2, VOLLEY_SPEED1),
                    center + ran:Float(-VOLLEY_ARC, VOLLEY_ARC), false, 0, false)
        end
        PlaySound("tan00", 0.1, x / 256, false)
    end

---蝶形子机（Sub5 的本体）。自己做自己的回收：起飞后活 DRONE_LIFE 帧就淡出，
---淡出期间先把自己的激光收掉（激光比子机活得久一点）。
    class.spear_drone = Class(object, {
        init = function(self, owner, x, y, spear_color, volley_color)
            self.owner = owner
            self.spear_color, self.volley_color = spear_color, volley_color
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
                fire_spear_laser(self, self.x, self.y, a, self.spear_color)
                fire_volley(self.x, self.y, self.volley_color)
                object.SetV(self, DRONE_DASH, a, true)
                ---Sub4 的死槍：每 FAN_INTERVAL 帧一发单发直弹，直到自己飞出场地为止
                ---（原作靠敌人的 offscreen 检查收掉，这里照做；原作没有「贴脸停火」，
                ---这里也不加 —— 距离由子机自己冲过来决定，玩家有 20 帧按快门）。
                local w = lstg.world
                while self.x > w.l - 64 and self.x < w.r + 64
                        and self.y > w.b - 64 and self.y < w.t + 64 do
                    fire_fan(self.x, self.y, self.spear_color)
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
                for _, w in ipairs(WAVES) do
                    task.Wait(w.delay)
                    for _, sx in ipairs({ -1, 1 }) do
                        drones[#drones + 1] = New(class.spear_drone, self,
                                sx * w.x, field_y(w.y), w.spear_color, w.volley_color)
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
---★ 激光扇**不打折**：48 根、角距 7.5°、前摇 120 帧、长度 512、扇面不自转
---（原作 angularVelocity = 0，靠「本体在晃」+「每轮换随机基准角」两种运动），
---全部照 ins_153 的操作数（见下面常量段）。48 根 16 px 宽的光柱在 r < 122 px 内
---确实是实心的（角距 0.131 rad × r < 16）—— 那是原作的形状，不再压。
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
    ---@1240（也就是 t=0 那两条 ins_101）⇒ **40 帧一轮、一轮两圈**
    ---（t=0 → t=40 = 40 帧；跳转同帧派发，见卡 71 的注释）。
    ---半径 = v/ω = 1.0 / 0.02618 = 38 px ⇒ 一圈蝶会绕着出发点卷成一个小旋涡（母题正中）。
---★ 转向时长照原作 600 帧（ins_101 slot1 的 int0 = 600）：这 10 秒里蝶一直绕着出发点
---卷（半径 = v/ω = 38 px），10 秒后放它们直线飞出去（见 swirl_frame 的注释）。
    local RING_PERIOD = 40
    local RING_PHASE = 20                    -- 两圈相隔 20 帧（t=0 与 t=20）
    local RING_COUNT = 16
    local RING_SPEED = 1.0
    local RING_SPIN = 1.5                    -- ±1.5°/帧
    local RING_SPIN_FRAMES = 600
    local RING_STYLE_A, RING_STYLE_B = butterfly, butterfly
    ---颜色下标是照贴图挑的（LoadImageGroup('butterfly','bullet4',832,0,32,32,1,8) 的
    ---8 行；非 colorful ⇒ 贴图号 = ceil(色号/2)）：
    ---色号 4 → butterfly2 = (228,201,237) 淡紫；色号 5 → butterfly3 = (190,190,242) 蓝紫。
    ---两个都在紫系里、又一眼分得开（§7.6）。
    local RING_COLOR_A, RING_COLOR_B = COLOR.PURPLE, COLOR.DEEP_BLUE

    ---小环（Sub7）：ins_88(17, 1, 12, 1, 2.5, 1.5, 0, 0.0327249, 514) = CIRCLE_AIMED、
    ---type17（半径 14 的大玉）12 发、整圈、速 2.5；ins_4(0,-44) 跳回 t=0（t=30）⇒ 每 30 帧。
    ---type 17 = 原作的**大玉**，按文件头差异 2 用本仓库最大的一档 **ball_huge**
    ---（同卡 71 的自机狙大圈，那边也是 type 17）。ball_huge 是 colorful 样式 ⇒
    ---贴图名 = "ball_huge"..色号，原作的色号 1 直接可用。
    ---★ 这三条时间（TICK_FIRST / FAN_FIRST / MOTH_MORE）都是 **Sub3 自己的 t**：
    ---Sub3 是 Sub2 在 t=130 用 ins_52(3) 同步调用的，CallEclSub 把子上下文 time 清零
    ---（EnemyManagerUpdate.cpp:172-186）⇒ 「Sub3 的 t=N」= 入场结束（第 130 帧）之后
    ---再过 N 帧。旧版把这三个数又减了一次 ENTRY_WAIT+ENTRY_TIME，整体早了 130 帧
    ---（第一组死蝶那条（t=0）没减，所以旧版自己也是前后不一致的）。
    local TICK_FIRST = 470                  -- Sub3 的 t=470 ⇒ 第 600 帧
    local TICK_PERIOD = 30
    local TICK_COUNT = 12
    local TICK_SPEED = 2.5
    local TICK_STYLE = ball_huge
    local TICK_COLOR = 1                    -- ins_88 的 color（ball_huge 是 colorful：1..16）
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
---前摇照原作 120 帧；「张开」用我们的 laser:_TurnOn(GROW) 做
---（alpha 与 w 一起涨 ⇒ 视觉上就是一根细线亮起来）。
---★ 四个时长/根数都照 ins_153 的操作数：前摇 120、张开 20、维持 60、收 20、48 根。
    local FAN_FIRST = 320                    -- Sub3 的 t=320 ⇒ 第 450 帧（第一轮扇）
    ---第二轮在 Sub3 的 t=910（320 + 60 + 530），之后每 530 帧一轮：Sub3 的 t=1000
    ---ins_4(470,-20) 把 time 拨回 470、跳回 t=910 的 @964（跳转后同帧派发），
    ---所以从那一轮起周期才是 530。
    local FAN_INTERVAL = 530
    local FAN_COUNT = 48                     -- ins_5(0,-84,extraIntV0=48)：48 根、每根 7.5°
    local FAN_WARN = 120
    local FAN_GROW = 20
    local FAN_HOLD = 60
    local FAN_FADE = 20
    local FAN_SPIN = 0                       -- 原作 angularVelocity = 0（扇面不自转）
    local LASER_INDEX = 3                    -- 原作的 color 3（laser 的颜色下标 1..16）
    local LASER_W = 16                       -- 命中半宽 = 8
    local LASER_LEN = 512                    -- ins_153 的最大长度
    ---laser1 的贴图是 64+128+64 = 256 px 三段，按 LASER_LEN 的比例切 ⇒ 拉长 1.56 倍。
    local LASER_SEG1, LASER_SEG2 = LASER_LEN * 0.25, LASER_LEN * 0.5

    ---死蝶（Sub3 的 ins_83(4) + t=380 的 ins_83(8)）：原作放出来的是敌机
    ---（ins_83 的 TH095 分支见 EclRunTargetHigh.inl:271-281），这里按 §7.4 的 C 类
    ---做成**不出判定的蝶形装饰**绕本体飞 —— 正好接住「死蝶」这层意思。
    ---第一组 4 只在 Sub3 的 t=0（= 出场后的第 130 帧）立刻放，第二组 8 只在 t=380。
    local MOTH_MORE = 380                   -- Sub3 的 t=380 ⇒ 第 510 帧
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
---★ 两圈的自转方向**固定**（原作 slot1 在发弹前写一次 +0.0261799、另一圈写 −0.0261799，
---弹在发弹那一刻抄走、之后每轮都是同一份）——旧版每轮把 spin 翻一次符号是错的。
---换算到我们这边（TH095 的正角 = 顺时针 ⇒ 取反）：色号 4 那圈用 −RING_SPIN、
---色号 5 那圈用 +RING_SPIN。
    local function swirl_stream(owner)
        task.New(owner, function()
            while true do
                fire_ring(owner, 0, RING_COLOR_A, -RING_SPIN)
                task.Wait(RING_PHASE)
                fire_ring(owner, 0, RING_COLOR_B, RING_SPIN)
                task.Wait(RING_PERIOD - RING_PHASE)
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
            ---Sub3 的 t=320（第 450 帧）：起 Sub6，第一轮 48 根激光扇。
            ---（Sub6 的 t=0 就摆好 ins_153、开始 120 帧前摇 ⇒ 「起扇」就是这一帧。）
            task.Wait(FAN_FIRST)
            fire_fan(self)
            ---Sub3 的 t=380（第 510 帧）：亮卡名 + 再放 8 只死蝶（ins_83(8)）。
            task.Wait(MOTH_MORE - FAN_FIRST)
            for i = 1, MOTH_COUNT2 do
                moths[#moths + 1] = New(class.dead_moth, self, (i - 1) * 360 / MOTH_COUNT2,
                        64 + i * 5)
            end
            ---下一轮激光扇在 Sub3 的 t=910（= 这里再等 FAN_INTERVAL 帧），之后每 530 帧一轮。
            task.Wait(FAN_INTERVAL)
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
    ---  · Sub3：Sub2 在 t=130 用 ins_52(3) **同步调**进来（子上下文 time 从 0 起）。
    ---    t=60 起三件事各自开工：
    ---      Sub4 = 每 45 帧一发「自机狙小弹」，**photoIndex ≥ 3 才开火**
    ---      （ins_44(photoIndex,3,0,72) = 小于就跳过后面的发弹，EclRunLow.inl:409 的比较分支），
    ---      Sub5 = 每 60 帧往**绝对 (±128, -32)** 各放一把「钥匙」（t=0 与 t=30 各一把）
    ---      （ins_26 先把偏移算成 (-128−pos.x)/(-32−pos.y)，ins_84 再加父坐标，
    ---       所以落点是绝对的场地外左上/右上角），
    ---      Sub6 = 每 45 帧一次边界感知挪位（ins_52(6) 是同步调用：Sub6 跑 45 帧、
    ---      调用者的 time 冻着；Sub6 的 ins_53 返回后 ins_4 又把 time 拨回 60、跳回
    ---      ins_52 ⇒ 立刻再来一次）。
    ---  · Sub7 = 钥匙的炮口（Sub8 在 t=0 用 ins_117(1,7) 起它）：t=10 抽 n = 12 + rand(0..15)，
    ---    再**每 2 帧**甩一发**定角**三连（ins_87 九个操作数全是字面量 ⇒ 上/左/右三个死方向，
    ---    floatV0 那条 +5.625° 是没人读的死指令），一共 n 发；n ≤ 15 时 30 帧一轮、
    ---    n ≥ 16 时越过外层 t=40 就此停摆（理由见 burst_cycle）。
---我们这边的一处差异 / 两条形状上的照抄：
---  ① 「钥匙」做成**不出判定的法器装饰**（§7.4 的 C 类）—— 原作的子敌机本体能撞死人，
---     跟卡 71 的蛾 / 卡 73 的蝶子机一样，威胁全交给弹。
---  ② 三连的**节拍与发数照原作**：每 2 帧一发、n = 12..27 发（不再截断到 15，
---     见 burst_cycle）；方向**不旋转**（旧版按那条死指令转了 5.625°/轮，是从没发生过的形状）。
---     **不做距离闸** —— 原作这张卡没有 ins_82，贴着也照发（见常量段）。
---  ③ 钥匙飞出场地就淡出收掉（原作挂到 t=2000 才退役）。
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
    ---  每 KEY_BURST_PERIOD 帧甩一次定角三连（上/左/右，见下面「不旋转」那一段）。
    local KEY_SPAWN_X = 128
    local KEY_SPAWN_Y = field_y(-32)                    -- 256（场地上沿之外）
    local KEY_GAP = 30
    local KEY_SPEED = 2
    local KEY_DOWN = -90
    ---淡入 10 帧：原作的 key 在 Sub8 的 t=0 定完速度就开工，Sub7 的 t=10 甩第一轮三连
    ---⇒ 淡入只占这 10 帧（§7.8：不许突然出现 / 突然消失，所以留着这一段）。
    local KEY_FADE_IN, KEY_FADE_OUT = 10, 25
    local KEY_ALPHA = 170                   -- §7.6：装饰层 alpha 压在 120~180
    ---Sub7 的 ins_4(10,-152)：t=40 跳回 t=10 ⇒ **一轮 30 帧**（跳转同帧派发，见卡 71）。
    local KEY_BURST_PERIOD = 30
    local KEY_BURST_GAP = 2                 -- ins_5(10,-64,n) 每轮占 2 帧 ⇒ 2 帧一发三连
    local KEY_BURST_HOLD = KEY_BURST_PERIOD / KEY_BURST_GAP  -- 30 帧里塞得下的三连发数 = 15
    local KEY_BURST_BASE = 12               -- ins_6(extraIntV0, 12)
    local KEY_BURST_RAND = 16               -- ins_24(extraIntV1, randU31, 16) ⇒ 0..15
    ---★ 不要在这里加「贴脸停火」：TH095 的 minimumPlayerDistanceSquared 出生默认是 **0**
    ---（EnemyManagerUpdate.cpp:457 的 `nSquared = 0`），只有卡里调 ins_82 才有距离闸
    ---（EclRunHigh.inl:951-958 把它平方写进去；EnemyShotDispatch.cpp:131-140 才是那个
    ---early return）—— 这张卡**没有** ins_82 ⇒ 原作就是贴着也照甩。加了距离闸等于少发弹。
    ---★ 三连**不旋转**：dump 里 Sub7 的 ins_87 九个操作数 pm=0000（全是字面量）
    ---  ⇒ 基准角写死 −π/2，扇面每轮都是「上/左/右」三个定方向；同帧那条
    ---  ins_15(floatV0, 0.0981748)（floatV0 += 5.625°）**没有任何指令读它**
    ---  （整份 ecl16_b 里 10008 只在这一条被写）⇒ 原作没有「旋转三连」这回事，
    ---  旧版按 5.625°/轮 转是照着那条死指令猜的（画蛇添足）。
    ---  换算：TH095 的 −π/2（朝上）在「逆时针为正」的我们这边是 +90°；
    ---  angleStep = π/2 的两个旁瓣落在 0°（右）与 180°（左）。
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

---一次三连（原作 Sub7 循环体 @1364 的 ins_87）：3 发定角（KEY_AIM0、±90°；
---FAN 的奇数 count1 分支，和卡 74 的 fan_angle 同一条公式），不旋转（理由见常量段）。
    local function fire_burst(key)
        for _, off in ipairs({ 0, KEY_STEP, -KEY_STEP }) do
            NewSimpleBullet(KEY_STYLE, KEY_COLOR, key.x, key.y, KEY_BULLET_SPEED,
                    KEY_AIM0 + off, false, 0, false)
        end
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：一次只响一声（BulletManager.cpp:717-723）。
        PlaySound("tan00", 0.1, key.x / 256, false)
    end

---Sub7 的一轮：t=10 先抽 n = 12 + rand(0..15)（@1300 ins_6 → @1320 ins_24(randU31,16)
---→ @1344 ins_10 累加），然后**每 2 帧**一发三连、一共 n 发（@1428 的 ins_5(10,-64,n)
---把 time 拨回 10 再跳回 @1364 的 ins_87 ⇒ 一圈占 t=10→t=12 这 2 帧，计数器减到 0 才继续）。
---★ 这一轮占用 2n 帧的 ECL 时间，而外层的 @1452 ins_4 只在 **t=40** 才把 time 拨回 10：
---  · n ≤ 15（2n ≤ 30）⇒ 循环结束时 t ≤ 40，外循环照常重开、重抽 n；
---  · n ≥ 16（2n > 40）⇒ 循环结束时 ctx->time 已经越过 40，那条 ins_4 再也不会匹配
---    （EclRun.cpp:302 只在 `time == instruction->time` 时派发）⇒ **Sub7 就此停摆**，
---    这把钥匙发完这 n 轮三连之后不再发弹（这是原作本身的行为，不是我们加的闸；
---    旧版把 n 截断到 15 再重开，反而比原作多发了弹）。
---返回 true = 这一轮按时收工、等满 30 帧重抽；false = 已经停摆。
    local function burst_cycle(key)
        local n = KEY_BURST_BASE + ran:Int(0, KEY_BURST_RAND - 1)   -- 12..27
        for k = 1, n do
            fire_burst(key)
            if k < n then
                task.Wait(KEY_BURST_GAP)
            end
        end
        if n > KEY_BURST_HOLD then
            return false
        end
        task.Wait(KEY_BURST_PERIOD - KEY_BURST_GAP * (n - 1))
        return true
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
            task.New(self, function()
                for _ = 1, KEY_FADE_IN do
                    self._a = min(KEY_ALPHA, self._a + KEY_ALPHA / KEY_FADE_IN)
                    task.Wait()
                end
                object.SetV(self, KEY_SPEED, KEY_DOWN, true)
                local w = lstg.world
                ---firing 变 false = Sub7 停摆（n ≥ 16）⇒ 之后只往下飘，不再发弹。
                local firing = true
                while self.y > w.b - 64 do
                    if firing then
                        firing = burst_cycle(self)
                    else
                        task.Wait()
                    end
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

    ---★ Sub3 的时间基准：它是 Sub2 在 t=130 用 ins_52(3) **同步调用**进来的、而
    ---CallEclSub 把子上下文的 time 清零（EnemyManagerUpdate.cpp:172-186）⇒
    ---**Sub3 的 t=N = 入场结束（第 130 帧）之后再过 N 帧**。Sub3 的 t=60 起
    ---Sub4（自机狙）/ Sub5（钥匙）/ Sub6（挪位）三件事，所以三条流都先等 SUB3_START。
    local SUB3_START = 60

    ---本体横着挪一格（Sub6）：朝自机方向 ±60° 挑一个角度走 30 帧、一共 120 px。
    ---带子是凸的 ⇒ 把目标点夹进带里就等价于引擎的 CLAMP_TO_MOVEMENT_BOUNDS。
    local function scoot(owner)
        task.New(owner, function()
            task.Wait(SUB3_START)
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
            task.Wait(SUB3_START)
            while true do
                keys[#keys + 1] = New(class.key, -KEY_SPAWN_X, KEY_SPAWN_Y)
                task.Wait(KEY_GAP)
                keys[#keys + 1] = New(class.key, KEY_SPAWN_X, KEY_SPAWN_Y)
                task.Wait(SCOOT_PERIOD - KEY_GAP)
            end
        end)
    end

    ---自机狙小弹（Sub4）：photoIndex ≥ AIM_FROM_PHOTO 之后，每 45 帧一发正对自机。
    ---★ Sub4 的 t=0 就是「先判 ins_44 的闸、再发那发」⇒ 第一发机会在它被起的那一帧
    ---（不是等 45 帧之后）；跳回的是 @892（t=0）所以每 45 帧一次。
    local function aim_stream(owner)
        task.New(owner, function()
            task.Wait(SUB3_START)
            while true do
                if photo_index(PHOTO_LIMIT) >= AIM_FROM_PHOTO then
                    local a = Angle(owner.x, owner.y, player.x, player.y)
                    NewSimpleBullet(AIM_STYLE, AIM_COLOR, owner.x, owner.y, AIM_SPEED, a,
                            false, 0, false)
                end
                task.Wait(AIM_PERIOD)
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
    ---    以自机方向为中心铺开 ±119°），t=15 的 ins_5(0,-44,4) 把它**每 15 帧再放一次**
    ---    （一共 4 次：t=0/15/30/45；ins_5 把 time 拨回 0 ⇒ 一圈 15 帧），
    ---    t=85 调 Sub4（ins_67(20,4,4) 边界感知走位 20 帧 / 4 px/帧），然后 ins_4(0,-140)
    ---    跳回 t=0 ⇒ **一轮 165 帧**（4 次整扇占 45 帧 + 从最后一次回到 t=85 的 85 帧
    ---    + Sub4 的 35 帧）。
    ---  · Sub6：每 3 帧一小圈（ins_89(18, 1, intV0, 1, 2.0, ...)），
    ---    intV0 = photoIndex/3 + 1（ins_23 整除、ins_30 自增）⇒ 拍得越多圈越大（1~3 发）。
    ---    ins_4(100,-84) 跳回 @1172（t=100）⇒ 周期 3 帧（跳到 t=100 后同帧接着跑）。
    ---    角度是 rand(-π,π) ⇒ 每圈换个相位（§7.7 第 1 条）。
---我们这边的一处差异：
---  · type 6（半径 2）→ butterfly（半径 4）：本关只有 butterfly / water_drop 两种贴图。
---    **发数/速度都不打折**：ins_5(0,-44,4) 的「4 次整扇」照抄 ⇒ 4×128 颗一颗不少；
---    4 次之间隔 15 帧、共用同一个基准角（理由见 fire_fan / fan_stream 的注释）。
    ---──────────────────────── 常量（改手感只动这一段） ────────────────────────
    ---入场：Sub2 t=0 的 ins_63(-128,-64)、t=100 的 ins_64(30,4,0,224)。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_Y = field_y(224)                    -- 0（场地正中）
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---Sub4 的走位框：ins_75(-128,192,128,256) ⇒ x∈[-128,128]、y∈[192,256]（TH095）
    ---⇒ 我们的 y∈[-32, 32]。ins_67(20,4,4)：第 1 个操作数 = 20 帧、第 2 个 = 缓动 4
    ---（4 = 1−(1−t)²，EclRun.cpp:374-378 ⇒ 我们的 VALUE_SET.DECEL）、第 3 个 = 4 px/帧。
    local BAND_L, BAND_R = -128, 128
    local BAND_B, BAND_T = field_y(256), field_y(192)   -- -32 / 32
    local SCOOT_TIME, SCOOT_SPEED = 20, 4

    ---整扇（Sub5）：ins_87(6, 4, 128, 1, 1.4, 1.5, floatV0, 0.0327249, 514)。
    ---count2 = 1 ⇒ speed2 = 1.5 不参与（BulletManager.cpp 的速度公式），速 1.4；
    ---angleStep = 0.0327249 rad = 1.875°；count1 = 128 是**偶数** ⇒ 走偶数分支
    ---（k = index1/2 + 0.5，奇数 index1 取负）⇒ ±0.5、±1.5、…、±63.5 格
    ---= 以自机方向为中心、一口气铺开 ±119.06°。
    ---整扇的节拍：**一共 4 次**（t=0 直落的那次 + ins_5(0,-44,4) 循环出来的 3 次）。
    ---★ 不是「同帧连放 4 次」：ins_5 把 time 拨回 0、跳回 @1008 的 ins_87，而循环体里
    ---  最后一条 ins_5 自己的 time 是 15 ⇒ 每圈要过 15 帧才再派发到它（EclRunLow.inl:419-422
    ---  + 跳转同帧派发）⇒ 4 次整扇落在 t=0/15/30/45。
    ---之后的 85 帧：t=60 那次派发把计数减到 0（退出循环）→ t=85 的 ins_52(4) 是**同步调用**
    ---Sub4（CallSubOnEnemy 把调用者的上下文压栈，EclRunLow.inl:419-420；Sub4 的 ins_53
    ---才返回）—— 调用者的 time 在子程序跑的时候**冻着**，Sub4 自己占 35 帧
    ---（t=15 起步走 20 帧 + 收尾）⇒ 一轮 = 45 + 85 + 35 = 165 帧。
    local FAN_WAIT = 15                     -- 两次整扇之间隔 15 帧（ins_5 的一圈）
    local FAN_REPEAT = 4                    -- ins_5(0,-44,4)：整个扇组一共 4 次
    local FAN_CALL = 85                     -- 最后一次整扇之后 85 帧到 t=85（每次循环都把 time 拨回 0）
    local SCOOT_DELAY = 15                  -- Sub4 的 t=15 才起步
    local SCOOT_TIME = 20                   -- Sub4 的 ins_67(20,4,4) 走 20 帧
    local FAN_COUNT = 128
    local FAN_STEP = 1.875
    local FAN_SPEED = 1.4
    local FAN_STYLE = butterfly
    ---butterfly 非 colorful ⇒ 贴图号 = ceil(色号/2)；色号 8 → butterfly4 = (193,216,235) 冰蓝。
    local FAN_COLOR = COLOR.CYAN

    ---小圈（Sub6）：ins_89(18, 1, intV0, 1, 2.0, 1.5, rand(-π,π), 0.1848, 514)。
    ---type18（半径 3）、color 1、每 3 帧一圈、圈数 = photoIndex/3 + 1（1~3）。
    ---周期是 ins_4(100,-84) 跳回 @1172（t=100）⇒ 100→103 共 3 帧（跳转把 time 拨回 100）。
    local RING_PERIOD = 3
    ---★ Sub6 的第一条指令在 t=100（不是 t=0）：Sub3 在 t=0 起 Sub6，而 CallEclSub 把
    ---子上下文 time 清零（EnemyManagerUpdate.cpp:172-186）⇒ 「Sub6 的 t=100」= 入场
    ---结束（第 130 帧）之后再过 100 帧 = 第 230 帧。旧版入场一结束就开圈，早了 100 帧。
    local RING_DELAY = 100
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
    ---base 由调用方传进来：原作只在**外圈**开头读一次自机方向（@988 的 ins_7 在 ins_5 的
    ---循环体外，ins_5 跳回的是 @1008 的 ins_87）⇒ 同一轮的 4 次整扇共用同一个基准角。
    local function fire_fan(owner, base)
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

    ---主体脚本（Sub5）：t=0/15/30/45 各放一扇（共 4 次）→ t=85 调 Sub4（同步 35 帧）
    ---→ 回头（一轮 165 帧）。
    ---★ 4 次循环**不是同帧连放**：ins_5 把 time 拨回 0 再跳回 @1008 的 ins_87，
    ---  而跳转后 time（0）≠ 循环体那条 ins_5 自己的 time（15）⇒ 一圈占 15 帧
    ---  （EclRunLow.inl:419-422 + 跳转同帧派发）。基准角由 @988 的 ins_7 写、@988 在循环体外
    ---  ⇒ 同一轮 4 次整扇用**同一个**基准角，下一轮开头才重读自机方向。
    local function fan_stream(owner)
        task.New(owner, function()
            while true do
                ---@988 ins_7：本轮的自机方向，只在**这里**读一次（4 次整扇共用）。
                local base = Angle(owner.x, owner.y, player.x, player.y)
                ---t=0/15/30/45：4 次整扇，每次之间隔 15 帧（ins_5 的一圈）。
                for k = 1, FAN_REPEAT do
                    fire_fan(owner, base)
                    if k < FAN_REPEAT then
                        task.Wait(FAN_WAIT)
                    end
                end
                task.Wait(FAN_CALL)             -- 到 t=85（调 Sub4 的那一帧）
                task.Wait(SCOOT_DELAY)          -- Sub4 自己的 t=15 才起步
                ---Sub4：朝自机方向 ±60° 挑一个角度、4 px/帧 走 20 帧（= 80 px），夹进框里。
                local a = Angle(owner.x, owner.y, player.x, player.y) + ran:Float(-60, 60)
                local step = SCOOT_SPEED * SCOOT_TIME
                task.MoveTo(max(BAND_L, min(BAND_R, owner.x + step * cos(a))),
                        max(BAND_B, min(BAND_T, owner.y + step * sin(a))),
                        SCOOT_TIME, VALUE_SET.DECEL)
            end
        end)
    end

    ---小圈（Sub6）：t=100 起每 3 帧一圈。
    local function ring_stream(owner)
        task.New(owner, function()
            task.Wait(RING_DELAY)
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
---我们这边的一处差异 / 两条只影响自检的说明：
---  ① 俯冲速度照原作：photoIndex × 2（photoIndex 上限 8 ⇒ 最多 16 px/帧），**不封顶**。
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
    local DIVE_SPEED_MUL = 2                -- 俯冲速度 = photoIndex × 2（原作，photoIndex 上限 8）
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
    local CLOUD_BURST = 4                   -- 一轮 4 发（= 4 帧）
    local CLOUD_RADIUS = 24
    local CLOUD_SPEED0 = 0.02
    local CLOUD_WAIT = 60
    local CLOUD_ACCEL = 1 / 60
    local CLOUD_ACCEL_FRAMES = 60
    local CLOUD_STYLE = butterfly
    ---原作四发轮着用 color 3/4/5/6（t=0..3 各一发）；butterfly 非 colorful ⇒
    ---贴图号 = ceil(色号/2)，3/4 都是 butterfly2、5/6 都是 butterfly3 —— 两种贴图。
    ---照抄原作四个色号（不再自己挑两个色）。
    local CLOUD_COLORS = { 3, 4, 5, 6 }

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

    ---蝶云（Sub4）：每帧 1 发、4 帧一轮（ins_4(0,-756) 在 t=4 跳回 t=0 ⇒ 一轮 4 帧）；
    ---每发在出膛点 24 px 内重抽位置、方向各自随机，颜色按 CLOUD_COLORS 逐发轮换。
    local function cloud_stream(owner)
        task.New(owner, function()
            while true do
                for k = 1, CLOUD_BURST do
                    local pa = ran:Float(0, 360)
                    local pr = CLOUD_RADIUS * ran:Float(0, 1)
                    NewSimpleBullet(CLOUD_STYLE, CLOUD_COLORS[k],
                            owner.x + cos(pa) * pr, owner.y + sin(pa) * pr,
                            CLOUD_SPEED0, ran:Float(0, 360), false, 0, false,
                            nil, nil, nil, cloud_frame)
                    task.Wait()
                end
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
                    speed = photo_index(PHOTO_LIMIT) * DIVE_SPEED_MUL
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

---──────────────────── Stage EX ── 两件公共工具 ────────────────────
---下面八张卡（scene 100..107）都要用到的两样东西：
---  ① TH095 的 16 色表 → 本仓库弹贴图的行号；
---  ② 原作的「旋转激光」（ins_147/148/153..157）→ 本仓库 laser 的四段驱动。

---TH095 的弹色是**调色板下标**（BulletManager.cpp:128-133 的 g_PhotoBulletColors16）：
---  0 灰 / 1,2 红 / 3,4 紫 / 5,6 蓝 / 7,8 青 / 9,10,11 绿 / 12,13,14 黄 / 15 灰。
---本仓库的弹样式（ball_small / ball_mid / ball_huge / butterfly / water_drop）都用
---COLOR.* 选行号，所以按色相挑最近的一行（灰 = 16，红 = 2，紫 = 4，蓝 = 6，
---青 = 8，绿 = 10，黄 = 12）。同一张卡的注释里只写原作色号，换算走这张表。
local EX_COLOR = {
    COLOR.GRAY,                    -- 0  0x808080 灰
    COLOR.RED,                     -- 1  0xff1010 红
    COLOR.RED,                     -- 2
    COLOR.PURPLE,                  -- 3  0x801080 紫
    COLOR.PURPLE,                  -- 4
    COLOR.BLUE,                    -- 5  0x1010ff 蓝
    COLOR.BLUE,                    -- 6
    COLOR.CYAN,                    -- 7  0x108080 青
    COLOR.CYAN,                    -- 8
    COLOR.GREEN,                   -- 9  0x10ff10 绿
    COLOR.GREEN,                   -- 10
    COLOR.GREEN,                   -- 11
    COLOR.YELLOW,                  -- 12 0x808010 黄
    COLOR.YELLOW,                  -- 13
    COLOR.YELLOW,                  -- 14
    COLOR.GRAY,                    -- 15
}
local function ex_color(i)
    return EX_COLOR[i] or COLOR.GRAY
end

---一把整圈（原作 ins_89，aimMode = CIRCLE）：基准角 + index1×2π/count1 + index2×angleStep。
---count2 = 1 时 speed2/angleStep 都不参与（BulletManager.cpp:369-372）；整圈是对称的，
---所以 TH095 的「顺时针为正」取反之后方向集合不变，直接用 base + i×360/count。
local function ex_ring(style, color, x, y, count, speed, base, frame)
    for i = 0, count - 1 do
        NewSimpleBullet(style, color, x, y, speed,
                base + i * 360 / count, false, 0, false, nil, nil, nil, frame)
    end
end

---一排扇（原作 ins_86 FAN_AIMED / 87 FAN）：第 index1 发的偏移量 =
---（count1 奇数 ? (index1+1)÷2 : index1÷2 + 0.5）× angleStep，index1 奇数取负
---（BulletManager.cpp:352-365）。FAN_AIMED 还要再加一次自机角（86 号）。
---返回的偏移量是**TH095 坐标系**下的度数；调用方按需要取反。
local function ex_fan_offsets(count, step_deg)
    local t = {}
    local odd = (count % 2) ~= 0
    for i = 0, count - 1 do
        ---★ 原作这两项都是**整数除法**（C 里 index1 是 i32，BulletManager.cpp:352-365）：
        ---    奇数：(index1+1)÷2 向下取整 ⇒ 0, 1, 1, 2, 2, 3…
        ---    偶数：index1÷2 向下取整再 +0.5 ⇒ 0.5, 0.5, 1.5, 1.5…
        ---  （旧写法 (i+1)*0.5 / i*0.5+0.5 从第 3 发起就偏了。）
        local k = odd and math.floor((i + 1) / 2) or (math.floor(i / 2) + 0.5)
        local a = k * step_deg
        if i % 2 ~= 0 then
            a = -a
        end
        t[i + 1] = a
    end
    return t
end

---──────────────────── Stage EX 的旋转激光 ────────────────────
---TH095 的 PhotoRotatingLaserView（PhotoEffect.cpp:348-460）：
---  · 长度每帧 += speed 直到 maximumLength（153/154 从 0 起，147/148/155/156/157 从满长起）；
---  · angle 每帧 += angularVelocity；position 每帧 += velocity（只有 155/156/157 带 vx/vy）；
---  · 四段：STARTUP（宽度恒 2 的细预警线、**无判定**）→ GROWING（宽度 0→maximumWidth）
---    → ACTIVE（maximumWidth 维持）→ FADING（→0、无判定）；宽度是**全宽**。
---  · 判定只在 GROWING/ACTIVE 且 length > 16 时存在（PhotoEffect.cpp:437-451）。
---  · followPhotoTarget 的激光每帧把位置拉回拍照目标（原作 ins_109 指的 boss），
---    我们这边就是本体（见各卡注释）。
---  · 原作的 g_AnmGameSpeed = 1；同时最多 256 条（PhotoEffect.cpp:1165），移植不设上限。
---★ 本仓库 laser 的命中半宽 = w/2（laser.lua:81-110 的 dist = 2），和上面的 width/2 一致；
---  长度放 l2、l1 = l3 = 0 ⇒ 判定盒是直矩形，不是本仓库默认两头收窄的六边形。
---★ 四段计时必须**挂在 owner（boss）的 task 上**：check_stage.lua 的 laser 桩件里
---  _TurnOn/_TurnOff 是空函数、laser:frame 也不跑 task.Do ⇒ 挂在 laser 自己身上，
---  自检里永远不收（th33 的 fan_laser 踩过同一个坑，见 :1310-1400）。
local EX_LASER_WARN_W = 2                 -- STARTUP 的预警线宽（原作初始 width = 2.0）

---把一根 EX 激光跑完四段，到点自己 RawDel。len0 已在 l.l2 里。
local function run_ex_laser(owner, l, max_len, width, speed, startup, grow, sustain, fade,
        ang_vel, vx, vy, follow)
    task.New(owner, function()
        local len = l.l2
        local phase, timer = 1, 0
        while IsValid(l) do
            if len < max_len then
                len = min(max_len, len + speed)
            end
            l.rot = l.rot + ang_vel
            if follow then
                l.x, l.y = owner.x, owner.y
            end
            l.x, l.y = l.x + vx, l.y + vy
            timer = timer + 1
            if phase == 1 then                     -- STARTUP：细线、无判定
                l.w = EX_LASER_WARN_W
                l.colli = false
                if timer >= startup then phase, timer = 2, 0 end
            elseif phase == 2 then                 -- GROWING：宽度线性长到 width
                l.w = width * timer / grow
                l.colli = len > 16
                if timer >= grow then phase, timer = 3, 0 end
            elseif phase == 3 then                 -- ACTIVE
                l.w = width
                l.colli = len > 16
                if timer >= sustain then phase, timer = 4, 0 end
            else                                   -- FADING：无判定
                l.w = width - width * timer / fade
                l.colli = false
                if timer >= fade then break end
            end
            l.l1, l.l2, l.l3 = 0, len, 0
            l.alpha = 1
            task.Wait()
        end
        if IsValid(l) then
            object.RawDel(l)
        end
    end)
end

---生成一根 EX 激光。index = 贴图行（1..16，见各卡注释里挑行的理由）；
---start_full = true ⇒ 初始就是 max_len（147/148/155/156/157），false ⇒ 从 0 长（153/154）。
local function spawn_ex_laser(owner, lasers, index, x, y, angle, max_len, width, speed,
        startup, grow, sustain, fade, ang_vel, vx, vy, follow, start_full)
    local len0 = start_full and max_len or 0
    local l = New(laser, index, x, y, angle, 0, len0, 0, 0, 0, 0)
    l.colli = false
    lasers[#lasers + 1] = l
    run_ex_laser(owner, l, max_len, width, speed, startup, grow, sustain, fade,
            ang_vel, vx, vy, follow)
    return l
end

do  -- 100 禁忌「フォービドゥンフルーツ」（ecl22_a，芙兰，组 3a 第 1 张）
    ---原作是「禁果从场地的四个角长出来」：本体停在**中轴 (0,192)** 不动，只把 shootOffset
    ---依次挪到四个角落，在每个角原地甩出一整圈小玉、再回本体甩一圈 —— 一共五圈一起炸开。
    ---数据源 /tmp/E_ecl22_a.txt（脚本 /tmp/d95v2.py 反汇编，ECL 在
    ---[th095] …/data/ecl22_a.ecl）。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 用 30 帧落到 (0,192)，
    ---    同时 ins_141(6) 把「要拍够几张」设成 6；t=130 亮卡名 + ins_75 设移动框
    ---    (-140,128,140,192) + ins_52(3) 起主脚本。
    ---  · Sub3（主脚本）一轮 480 帧：t=0 起 Sub8（装饰），t=60 把 slot0 换成 Sub6（**发弹**），
    ---    t=60 的 ins_2(180) 把 Sub3 自己冻结 180 帧，醒来后重开 Sub8；t=120 处其实是
    ---    被 t=60 的冻结推迟到第 300 帧才执行的第二块 —— 换成 Sub7（另一色发弹），
    ---    再冻结 180 帧，然后 ins_4(0,-272) 跳回 t=0。⇒ 一轮 480 帧、两种颜色交替。
    ---  · Sub6 / Sub7 是发弹上下文，进入时立刻发一轮，之后 t=60 / t=120 各**有条件**再发一轮：
    ---    @2964 / @3472 的 `ins_44(photoIndex, 3)` 是 **CMPlt（< 才跳）**（EclRunLow.inl:420 附近
    ---    的比较表；跳转目标 @3460/@3968 正是「跳过这一轮」）⇒ **photoIndex ≥ 3 才有后两轮**，
    ---    拍得越多这一张越密（旧注释把这条读反过，别再照抄）。
    ---  · 每轮 = 四个角各一整圈（Sub6 96 发 / Sub7 88 发、速 1.0）+ 本体一圈
    ---    （两色都是 68 发、速 0.8）。四个角是 ins_26(extraFloat, 角坐标, pos) + ins_100 得到的
    ---    **世界坐标** (-192,0)/(192,0)/(-192,448)/(192,448)（TH095 坐标），
    ---    换算到我们这边 y = 224 − y ⇒ 四个角就是场地的四角。
    ---  · 弹型 18 = 直径 6 ⇒ 用 ball_small（半径 2，最接近）；ins_89 的 aimMode = CIRCLE
    ---    （angle = 操作数 angle + index1×2π/count1 + index2×angleStep，而 count2 = 1 ⇒
    ---    angleStep = 0.1848 不参与，BulletManager.cpp:369-372）。
    ---    flags 514 = 0x202 = PLAY_SPAWN_SOUND + SPAWN_FAST；出场滑动我们统一不做（文件头差异 3），
    ---    出膛音每条弹幕响一次（原作也是整波响一次，BulletManager.cpp:717-723）。
    ---  · 色号：原作两色是 1 与 0。TH095 的 16 色表 g_PhotoBulletColors16 下标 0 = 灰、
    ---    1 = 红（见文件头「色表」一节）⇒ 我们取 ball_small1（红）与 COLOR.GRAY（16，灰）。
    ---  · Sub8（106(5)+150(10) 每帧）是整屏装饰 ANM，Sub4/Sub5 在 Sub3 里从来没被调用过
    ---    （旧摘要把 4/5 当成主发弹是读错了），Sub9 也没被调用 —— 一律不实现。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local BOSS_HOME_X, BOSS_HOME_Y = 0, field_y(192)    -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    ---Sub2 的 ins_141(6)：原作要求拍中的张数（也就是本卡的拍照血量分母）。
    local PHOTO_LIMIT = 6

    local CARD_NAME = "禁忌「フォービドゥンフルーツ」"
    ---原作卡计时 ins_114(7208) ≈ 120 秒；沿用本仓库的 50 秒（同前七张）。
    local CARD_TIME = 50
    ---原作 Timeline0 给的生命是 150；这里按本仓库的量级抬到 900。
    local CARD_HP = 900
    ---符卡历史槽位：410..416 已被上一批七张占掉；th31 的 LIST 实际用到 452
    ---（mod/GAME/th31.lua 的 `local LIST = {`，末行「魔砲「ファイナルマスタースパーク」」
    ---占 452 —— **别只扫 boss.card.add 的 CARD_ID=、也别只看 LIST 第 3 项之外的行**），
    ---所以 Stage EX 从 453 起（见文件头「符卡历史槽位」）。
    local CARD_ID = 453

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---四个角（我们的坐标；TH095 的 (-192,0)/(192,0)/(-192,448)/(192,448) 各翻一次 y）。
    local CORNERS = { { -192, 224 }, { 192, 224 }, { -192, -224 }, { 192, -224 } }

    local STYLE = ball_small
    local CORNER_SPEED = 1.0                -- 四角那几圈 ins_89 的 speed1（count2 = 1）
    local BODY_SPEED = 0.8                  -- 本体那圈 ins_89 的 speed1
    local COLOR_A = ex_color(1)             -- Sub6 的 color 1（红）
    local COLOR_B = ex_color(0)             -- Sub7 的 color 0（灰）

    ---时间轴（单位：帧，全部从 Sub3 的 t=0 起算）：60 → Sub6 发第一轮；
    ---Sub6 自己会在 +60 / +120 再各发一轮（photoIndex ≥ 3 才发）；Sub3 冻结到 240 才醒；
    ---再 60 帧（= 300）换 Sub7；再冻结 180 → 480 回到 t=0。
    local FIRST_DELAY = 60
    local REPEAT_GAP = 60
    local REPEAT_LIMIT = 3                  -- Sub6/Sub7 最多 3 轮（t=0/60/120）
    local DENSITY_MIN_PHOTOS = 3            -- ins_44(photoIndex, 3)：< 3 就跳过后续轮
    local PAUSE = 180                       -- Sub3 的 ins_2(180)（冻结 180 帧）

    ---从 (x,y) 甩出一整圈 count 发：基准角每圈重抽（原作的 ins_7(floatV0, rand(-π,π))）。
    ---整圈是对称的，TH095 的「顺时针为正」取反后方向集合不变 ⇒ 直接用 base + i*360/count。
    local function fire_ring(x, y, color, count, speed)
        local base = ran:Float(0, 360)
        for i = 0, count - 1 do
            NewSimpleBullet(STYLE, color, x, y, speed,
                    base + i * 360 / count, false, 0, false)
        end
    end

    ---Sub6 / Sub7 的一轮：四个角各一圈 + 本体一圈（顺序、发数、速度全照 dump）。
    local function fire_volley(owner, color, corner_count, body_count)
        for i = 1, #CORNERS do
            fire_ring(CORNERS[i][1], CORNERS[i][2], color, corner_count, CORNER_SPEED)
        end
        fire_ring(owner.x, owner.y, color, body_count, BODY_SPEED)
        -- flags 的 0x200 = PLAY_SPAWN_SOUND：整波只响一声。
        PlaySound("tan00", 0.1, owner.x / 256, false)
    end

    ---一个发弹上下文（= Sub6 / Sub7）：立刻一轮，然后 t=60 / t=120 各再看一次
    ---「photoIndex ≥ 3 才补一轮」（ins_44 的 CMPlt 意思就是 < 3 时跳过）。
    ---★ 它必须**独立于 Sub3**跑：Sub3 在 t=60 之后被 ins_2 冻住，两个上下文是各跑各的。
    local function volley_context(owner, color, corner_count, body_count)
        task.New(owner, function()
            fire_volley(owner, color, corner_count, body_count)
            for _ = 2, REPEAT_LIMIT do
                task.Wait(REPEAT_GAP)
                if photo_index(PHOTO_LIMIT) >= DENSITY_MIN_PHOTOS then
                    fire_volley(owner, color, corner_count, body_count)
                end
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
            ---到这里是原作 Sub2 的 t=130：亮卡名 + 起 Sub3（那两条演出我们交给符卡系统）。
            while true do
                task.Wait(FIRST_DELAY)
                volley_context(self, COLOR_A, 96, 68)   -- Sub6（红）
                task.Wait(PAUSE)
                task.Wait(FIRST_DELAY)
                volley_context(self, COLOR_B, 88, 68)   -- Sub7（灰）
                task.Wait(PAUSE)
            end
        end)
    end

    ---本体的逐帧逻辑：原作没有（发弹全在 ECL 上下文里）。留空是刻意的。
    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "3a" } }, LEVEL, CARD_NAME, CARD_ID)
end--禁忌「フォービドゥンフルーツ」

do  -- 101 禁忌「禁じられた遊び」（ecl22_b，芙兰，组 3a 第 2 张）
    ---原作是「不许玩的游戏」：本体贴着中轴 y=0 在 ±48 的窄框里**左右躲**（自机的反方向），
    ---同时只有**一层**弹幕 —— 每 120 帧换一组朝向的**飞棍激光**（外加每波一颗大玉圈）。
---数据源 /tmp/E_ecl22_b.txt。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → **t=40** 就 ins_64(30,4,0,224) 落到 (0,224)（TH095
    ---    坐标 y 朝下 ⇒ 我们的 y = 0，正中央）；t=70 亮卡名 + ins_75(-48,224,48,224)
    ---    ⇒ 移动框就一条横线 x∈[-48,48]、y = 0（原作的 CLAMP_TO_MOVEMENT_BOUNDS 会夹住它）。
    ---  · Sub3（主脚本）：t=0 起 Sub7（装饰）与 Sub4（激光）、t=30 一声演出、
    ---    t=60 的 ins_51(pos.x, player.x) 是**浮点 ≥**（CMPfge，条件成立才跳，EclRunLow.inl
    ---    的比较表）：本体在自机右边就往左走（π），否则往右走（0），ins_66(60,0,角,0.5)
    ---    = 60 帧直线走 30 px；t=120 的 ins_4(0,-132) 跳回 t=30 ⇒ 一轮 **90 帧**
    ---    （走 60 帧 + 歇 30 帧）。x 轴不受坐标翻转影响，判据可以照抄。
    ---  · Sub4（激光，480 帧一轮）：t=0/120/240/360 各放 16 根 **type 12** 的旋转激光
    ---    （4 组 × 4 根；每组先 ins_38 设一个「漂移方向」（155 的最后两参 = 每帧位移），
    ---    组内 4 根的指向是十字 {π, 0, −π/2, π/2}、角速度 ±1.5°/帧）。第 4 波额外再放
    ---    8 根 type 12（长 96、维持 600 帧、角速度 −2°/+3°、漂移 = 朝自机 0.5 px/帧）。
    ---    每波还各甩 4 颗 type 17 大玉（`89(17,0,4,1,1,1.5,基准角,…)`，基准角 π/2 与 π/4 交替）。
    ---  · Sub5（每 10 帧一轮的 ins_87 = FAN 双扇）**在文件里从来没被调用**：
    ---    Sub3 只有 ins_117(0,7) 与 ins_117(1,4) 两条（= 装饰 Sub7 + 激光 Sub4），
    ---    Sub2 的 ins_52(3) 起的是 Sub3 —— 全文件再没有第三条指向 Sub5。
    ---    ⇒ 原作这里不发弹，移植版不实现（见下面「Sub5 是死代码」那段）。
    ---  · Sub6（54(2)+80(8)+81(16)）只动标志位、Sub7（106(5)+150(10)）是整屏装饰 ANM，
    ---    都跟弹幕无关，不实现。
    ---  · 弹型：type 3 → ball_small（半径 2）、type 13 → ball_mid（半径 4）、
    ---    type 17 → ball_huge（半径 13.5）。色号走文件头 ex_color()。
    ---  · 角度换算：TH095 顺时针为正、我们逆时针为正 ⇒ 指向角取反、角速度取反、
    ---    漂移向量按 (cos(−θ), sin(−θ)) 算；x 轴不变。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local HOME_X, HOME_Y = 0, field_y(224)              -- 0 / 0
    local ENTRY_WAIT, ENTRY_TIME = 40, 30
    local EASE_OUT = VALUE_SET.DECEL
    local BOX_L, BOX_R = -48, 48                        -- ins_75(-48,224,48,224)
    local MOVE_DELAY = 60                               -- Sub3 t=60 的第一次走位
    local MOVE_FRAMES = 60                              -- ins_66 的 N
    local MOVE_STEP = 30                                -- ins_66 的 speed × N = 0.5 × 60
    local MOVE_IDLE = 30                                -- 一轮 90 帧 = 走 60 + 歇 30

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "禁忌「禁じられた遊び」"
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 454

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    ---本卡放出的激光（卡结束时统一 RawDel，§7.9 第 9 条）。
    local lasers = {}

    ---type 12 的激光参数（155：满长起步、每帧长 8、宽 16、四段 20/20/220/10）。
    local LASER_INDEX = 12
    local LASER_LEN = 108
    local LASER_W = 16
    local LASER_SPEED = 8
    local LASER_STARTUP, LASER_GROW, LASER_SUSTAIN, LASER_FADE = 20, 20, 220, 10
    ---第 4 波那 8 根（长 96、维持 600）。
    local LASER2_LEN = 96
    local LASER2_SUSTAIN = 600
    local LASER2_AV = { -2, 3 }                         -- 度/帧（TH095 顺时针为正）
    ---四组基准漂移方向与角速度（单位：度/帧，TH095 坐标；见卡头注释的 dump 行号）。
    ---@type table<{dir:number, av:number}>
    local WAVES = {
        { { 90, 1.5 }, { -90, 1.5 }, { 0, -1.5 }, { 180, -1.5 } },
        { { 45, 1.5 }, { -135, 1.5 }, { -45, -1.5 }, { 135, -1.5 } },
        { { 90, -1.5 }, { -90, -1.5 }, { 0, 1.5 }, { 180, 1.5 } },
        { { 45, -1.5 }, { -135, -1.5 }, { -45, 1.5 }, { 135, 1.5 } },
    }
    local WAVE_GAP = 120
    local RING_BASE = { 90, 45, 90, 45 }                -- 每波大玉圈的基准角（TH095 度）
    local BIG_STYLE = ball_huge
    local BIG_COLOR = ex_color(0)                       -- 89(17, 0, …)
    local BIG_COUNT, BIG_SPEED = 4, 1.0
    ---组内 4 根的指向角（TH095 度）：十字。
    local CROSS = { 180, 0, -90, 90 }

    ---一波激光 + 一颗大玉圈。
    local function fire_wave(owner, w, ring_base)
        for _, g in ipairs(w) do
            local vx = cos(-g[1])                            -- 漂移 = ins_38(dir, 1)
            local vy = sin(-g[1])
            local av = -g[2]                                 -- 角速度取反
            for i = 1, #CROSS do
                spawn_ex_laser(owner, lasers, LASER_INDEX, owner.x, owner.y, -CROSS[i],
                        LASER_LEN, LASER_W, LASER_SPEED,
                        LASER_STARTUP, LASER_GROW, LASER_SUSTAIN, LASER_FADE,
                        av, vx, vy, false, true)
            end
        end
        ex_ring(BIG_STYLE, BIG_COLOR, owner.x, owner.y, BIG_COUNT, BIG_SPEED, -ring_base)
        PlaySound("tan00", 0.1, owner.x / 256, false)
    end

    ---第 4 波额外的 8 根：漂移 = 朝自机 0.5 px/帧（ins_38(playerAngle, 0.5)）。
    local function fire_player_lasers(owner)
        local a = Angle(owner.x, owner.y, player.x, player.y)
        local vx, vy = 0.5 * cos(a), 0.5 * sin(a)
        for i = 1, #LASER2_AV do
            local av = -LASER2_AV[i]
            for k = 1, #CROSS do
                spawn_ex_laser(owner, lasers, LASER_INDEX, owner.x, owner.y, -CROSS[k],
                        LASER2_LEN, LASER_W, LASER_SPEED,
                        LASER_STARTUP, LASER_GROW, LASER2_SUSTAIN, LASER_FADE,
                        av, vx, vy, false, true)
            end
        end
    end

    ---Sub4：480 帧一轮，第 4 波多一组朝自机的 8 根。
    local function laser_context(owner)
        task.New(owner, function()
            while true do
                for i = 1, #WAVES do
                    if i > 1 then
                        task.Wait(WAVE_GAP)
                    end
                    fire_wave(owner, WAVES[i], RING_BASE[i])
                    if i == #WAVES then
                        fire_player_lasers(owner)
                    end
                end
                task.Wait(WAVE_GAP)
            end
        end)
    end

    ---Sub5（原文件里的「对自机 7 发 / 背自机 21 发」双扇）是**死代码**：Sub3 只调
    ---ins_117(0,7) 与 ins_117(1,4)（= 装饰 Sub7 + 激光 Sub4），全文件再没有第二条
    ---ins_117/ins_52 指向 Sub5（`grep id=117 /tmp/E_ecl22_b.txt` 只有 @760/@780 两行）
    ---⇒ 原作里这一层根本不会执行，移植时删掉（旧注释把它当成真发弹，已改正）。

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=70：亮卡名 + 起 Sub3。
            laser_context(self)
            task.Wait(MOVE_DELAY)
            while true do
                ---ins_51：本体在自机右边就往左走，否则往右走（总是躲开自机）。
                local dir = (self.x >= player.x) and 180 or 0
                local tx = max(BOX_L, min(BOX_R, self.x + MOVE_STEP * cos(dir)))
                task.MoveTo(tx, HOME_Y, MOVE_FRAMES, VALUE_SET.NORMAL)
                task.Wait(MOVE_IDLE)
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = #lasers, 1, -1 do
            if IsValid(lasers[i]) then
                object.RawDel(lasers[i])
            end
        end
    end

    boss.card.add({ { card, "3a" } }, LEVEL, CARD_NAME, CARD_ID)
end--禁忌「禁じられた遊び」

do  -- 102 境符「色と空の境界」（ecl23_a，紫，组 4a 第 1 张）
    ---原作分前后两段，各由「128 根旋转激光」+「4 条扇弹上下文」组成；两段之间把角色
    ---在场上清一次再换一套（激光的旋向、扇的转法都反过来）。
---数据源 /tmp/E_ecl23_a.txt。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 落到 (0,192)（我们的 (0,32)）、
    ---    ins_141(5) ⇒ 本卡要拍中 5 张；t=130 亮卡名 + ins_75 + ins_52(3) 起 Sub3。
    ---  · Sub3 全在 t=0、靠 ins_2 一节一节往下走，一轮 **980 帧**：
    ---      117(0,4) Sub4 → 等 150 → 117(0,6) Sub6 → 等 120
    ---      → 4 条 Sub7（扇）→ 等 110 → 演出 → 等 50 → 把 4 条全删 → 等 60
    ---      → 117(0,5) Sub5 → 等 150 → 117(0,6) Sub6 → 等 120
    ---      → 4 条 Sub8（随机扇）→ 等 110 → 演出 → 等 50 → 全删 → 等 60 → 跳回开头。
    ---  · Sub4 / Sub5 是同一套的镜像（角速度符号相反）：128 根 ins_147 旋转激光，
    ---    分两批各 64 根 —— 批量 1（type 7、色 5、四段 30/30/30/10、角速度 ±0.1758°/帧）
    ---    在角度 k×11.25°；批量 2（type 12、色 0、四段 60/30/30/10、角速度 ∓0.1758°/帧）
    ---    在 (k+0.5)×11.25°（Sub4 的 @1836 ins_5 回到 @1708；@2024 回到 @1896）。
    ---    参数照 ins_147：最大长 512、宽 16、followPhotoTarget = 1 ⇒ 每帧钉在本体上。
    ---  · Sub6 换成 ins_157（四段 50/10/10/4、最大长 512、角速度 ∓0.3516°/帧），
    ---    每轮两根：A 在 (k+0.5)×11.25°、B 在 (k+1)×11.25°；64 轮 ⇒ 128 根。
    ---    ★ 两段调的**是同一个 Sub6**（@788 与 @1196 都是 ins_117(0,6)）⇒ 旋向不翻。
    ---  · Sub7（每 2 帧一轮）：先 ins_38(floatV0, 32) 把出膛点挪到本体 32 px 外、ins_100 写进去，
    ---    floatV2 = floatV0 + floatV1，再 ins_87 = FAN 8 发（步进 10°、速 2.5）；
    ---    收尾 floatV0 += 6°、floatV1 −= 3.6°（所以扇角 = floatV0 + floatV1 每轮净转 +2.4°）。
    ---  · Sub8 同构，只是把扇换成 ins_94 = RANDOM：3 发、角度均匀落 [floatV2−22.5°, floatV2+22.5°]、
    ---    速度均匀 [1.5, 3.1]；收尾 floatV0 −= 6°、floatV1 −= 3.6°（净 −9.6°/轮）。
    ---  · ★ 四条子上下文**不是同一个上下文**：Sub3 在每次 ins_117 之前把 floatV0 设成
    ---    π/2、−π/2、0、π，而 ins_117 会把父上下文的**整份变量区**（PhotoEnemy.hpp:25-34 的
    ---    intVariables/floatVariables/extra*/callParameter* 正好 0x80 字节）memcpy 给子上下文
    ---    （EclRunTargetHigh.inl:206-240）⇒ 四条各自从不同的初值出发、之后互不影响。
    ---    （旧摘要把这条读成「float 不复制、从 0 起」，那是把 0x80 当成了 intVariables[8] 的大小。）
    ---  · 弹型 0 → ball_small（半径 2）。色 6 走 ex_color()。
    ---  · 原作的弹槽上限 640（BulletManager.cpp:310-345）：这张卡在原作里是**打满弹槽**的。
    ---    本仓库没有弹槽上限 ⇒ 稳态同屏弹数比原作高（实测里能看到），图案不变，见文件头差异 3。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 5                               -- ins_141(5)
    local CARD_NAME = "境符「色と空の境界」"
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 455

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    local lasers = {}

    ---激光（ins_147 / ins_157）的公共参数。
    local LASER_ROT = 11.25                              -- 每根之间的角距（0.19635 rad）
    local LASER_LEN, LASER_W = 512, 16
    local LASER_SPEED_147 = 8                            -- ins_147 每帧长 8
    local LASER_SPEED_157 = 5                            -- ins_157 每帧长 5
    local AV_147 = -0.1758                               -- 0.00306796 rad/帧（TH095 顺时针为正）
    local AV_157 = -0.3516                               -- 0.00613592 rad/帧

    ---一批 ins_147：count 根、从角度 (k + phase)×LASER_ROT 起、角速度 av。
    ---startup 要单独传：同一批里 type 7 是 30 帧、type 12 是 60 帧（见 lasers_4）。
    local function burst_147(owner, count, phase, index, av, startup)
        for k = 0, count - 1 do
            local a = (k + phase) * LASER_ROT
            spawn_ex_laser(owner, lasers, index, owner.x, owner.y, -a,
                    LASER_LEN, LASER_W, LASER_SPEED_147, startup, 30, 30, 10,
                    av, 0, 0, true, true)
        end
    end

    ---Sub4 / Sub5：两批 64 根（先 type 7 色 5 四段 30/30/30/10、再 type 12 色 0 四段 60/30/30/10）。
    ---角速度按「TH095 顺时针为正 ⇒ 我们取反」：
    ---  Sub4（sign = +1）原值 +0.1758 / −0.1758（type 7 / type 12）
    ---  Sub5（sign = −1）原值 −0.1758 / +0.1758  ⇒ 用 AV_147 = −0.1758 表达就是下表。
    local function lasers_4(owner, sign)
        burst_147(owner, 64, 0, 7, AV_147 * sign, 30)
        burst_147(owner, 64, 0.5, 12, -AV_147 * sign, 60)
    end

    ---Sub6：64 轮 × 2 根 ins_157（A 在 (k+0.5)×11.25°、B 在 (k+1)×11.25°）。
    ---★ 两段用的是**同一个 Sub6**（Sub3 两次都 ins_117(0,6)）⇒ 没有 sign，两段一模一样。
    ---原值：type 12 是 −0.3516°/帧、type 7 是 +0.3516°/帧 ⇒ 我们这边正负互换。
    local function lasers_6(owner)
        for k = 0, 63 do
            local a = (k + 0.5) * LASER_ROT
            spawn_ex_laser(owner, lasers, 12, owner.x, owner.y, -a,
                    LASER_LEN, LASER_W, LASER_SPEED_157, 50, 10, 10, 4,
                    -AV_157, 0, 0, true, true)
            a = (k + 1) * LASER_ROT
            spawn_ex_laser(owner, lasers, 7, owner.x, owner.y, -a,
                    LASER_LEN, LASER_W, LASER_SPEED_157, 50, 10, 10, 4,
                    AV_157, 0, 0, true, true)
        end
    end

    ---Sub7 / Sub8：4 条子上下文，初值 floatV0 = π/2、−π/2、0、π（见卡头注释）。
    local SPAWN_R = 32                                   -- ins_38 的 magnitude
    local FAN_STYLE, FAN_COLOR = ball_small, ex_color(6)
    local FAN_COUNT, FAN_SPEED, FAN_STEP_DEG = 8, 2.5, 10
    local FAN_OFFSETS = ex_fan_offsets(FAN_COUNT, FAN_STEP_DEG)
    local RND_STYLE, RND_COLOR = FAN_STYLE, FAN_COLOR
    local RND_COUNT, RND_SPEED1, RND_SPEED2 = 3, 3.1, 1.5
    local RND_HALF = 22.5                                -- 0.392699 rad
    local FAN_STEP = 6                                   -- 0.10472 rad
    local FAN_STEP1 = 3.6                                -- 0.0628319 rad
    local FAN_INTERVAL = 2                               -- ins_4(0,-156) 在 t=2
    ---四条子上下文的初值（TH095 弧度；见 Sub3 的 ins_7 序列）。
    local CHILD_INIT = { math.pi * 0.5, -math.pi * 0.5, 0, math.pi }

    local function start_fan_children(owner, random)
        local toks = {}
        for i = 1, #CHILD_INIT do
            local tok = { alive = true }
            toks[i] = tok
            task.New(owner, function()
                local fv0 = CHILD_INIT[i]                -- 相对角度（TH095 弧度）
                local fv1 = 0
                while tok.alive do
                    local fv2 = fv0 + fv1
                    ---ins_38 的 (cos,sin) 用**弧度**（fv0 是弧度）⇒ 换算成度再交给本仓库
                    ---角度制的 cos/sin（tools/check_stage.lua:324：sin/cos 是角度制）。
                    local ox = cos(-math.deg(fv0)) * SPAWN_R
                    local oy = sin(-math.deg(fv0)) * SPAWN_R
                    if random then
                        for _ = 1, RND_COUNT do
                            local r = ran:Float(0, 1)
                            local a_th = (fv2 - math.rad(RND_HALF))
                                    + math.rad(RND_HALF * 2) * r
                            local v = RND_SPEED2 + (RND_SPEED1 - RND_SPEED2) * ran:Float(0, 1)
                            NewSimpleBullet(RND_STYLE, RND_COLOR,
                                    owner.x + ox, owner.y + oy, v, -math.deg(a_th), false, 0, false)
                        end
                        fv0 = fv0 - math.rad(FAN_STEP)
                    else
                        for k = 1, #FAN_OFFSETS do
                            NewSimpleBullet(FAN_STYLE, FAN_COLOR,
                                    owner.x + ox, owner.y + oy, FAN_SPEED,
                                    -math.deg(fv2) - FAN_OFFSETS[k], false, 0, false)
                        end
                        fv0 = fv0 + math.rad(FAN_STEP)
                    end
                    fv1 = fv1 - math.rad(FAN_STEP1)
                    PlaySound("tan00", 0.1, owner.x / 256, false)
                    task.Wait(FAN_INTERVAL)
                end
            end)
        end
        return toks
    end

    local function stop_children(toks)
        for i = 1, #toks do
            toks[i].alive = false
        end
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=130，起 Sub3。
            while true do
                lasers_4(self, 1)                     -- 第一批的旋向
                task.Wait(150)
                lasers_6(self)                        -- 两段共用、不翻
                task.Wait(120)
                local toks = start_fan_children(self, false)
                task.Wait(110)
                PlaySound("tan00", 0.1, self.x / 256, false)
                task.Wait(50)
                stop_children(toks)
                task.Wait(60)

                lasers_4(self, -1)                    -- 旋向反过来
                task.Wait(150)
                lasers_6(self)                        -- 同一份 Sub6
                task.Wait(120)
                toks = start_fan_children(self, true)
                task.Wait(110)
                PlaySound("tan00", 0.1, self.x / 256, false)
                task.Wait(50)
                stop_children(toks)
                task.Wait(60)
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = #lasers, 1, -1 do
            if IsValid(lasers[i]) then
                object.RawDel(lasers[i])
            end
        end
    end

    boss.card.add({ { card, "4a" } }, LEVEL, CARD_NAME, CARD_ID)
end--境符「色と空の境界」

do  -- 103 境符「波と粒の境界」（ecl23_b，紫，组 4a 第 2 张）
    ---原作只有一件事：本体停在 (0,192)（我们的 (0,32)）不动，一条发弹上下文**每帧**甩
    ---一圈 **5 发**（半径 2 的小玉）。圈本身每帧被转过一个角度、而这个「每帧转角」又
    ---**每帧再加一点点** ⇒ 子弹被一层层铺成弯的「波」，也就是卡名的「波」与「粒」。
---数据源 /tmp/E_ecl23_b.txt。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 落地、ins_141(6)；
    ---    t=130 亮卡名 + ins_75(-140,128,140,192) + ins_52(3) 起 Sub3。
    ---  · Sub3：t=0 设 floatV2 = 0.000654498 rad（= π/4800）并起 Sub4；之后只有两段
    ---    ins_2(180) 的空转（t=60 → t=120 → 跳回 t=60），**Sub4 只起这一次**、永远跑下去。
    ---  · Sub4（每帧一轮，ins_4(0,-160) 在 t=1 跳回 @916）：
    ---      floatV3 = photoIndex × 0.1 + 2.6          ← 弹速：拍得越多越快（2.6 → 3.2）
    ---      ins_91 = OFFSET_CIRCLE：5 发，角度 = π/5 + index1×2π/5 + floatV0
    ---      floatV0 += floatV1；floatV1 += floatV2     ← 圈每帧转 floatV1，floatV1 自己每帧涨
    ---    所以第 t 帧的「每帧转角」= t×π/4800，转角是**二次加速**的（4 分钟才到 180°/帧）。
    ---  · Sub5（102 清屏 + 把 floatV2 改成负的 + 重起 Sub4）在整份 ECL 里**没有任何
    ---    ins_117(·,5)** —— 是死代码，原作里从来没跑过（自己在文件里搜过一遍字节确认），
    ---    所以「加速度反向」这件事不会发生，不实现。
    ---  · 弹型 3 → ball_small（半径 2）；色 4 走 ex_color()。flags 514 = 0x202（出场音 + SPAWN_FAST，
    ---    出场滑动我们统一不做，见文件头差异 3）。
    ---  · 角度：OFFSET_CIRCLE 的一圈是对称的，但整圈的**相位** floatV0 会被取反，
    ---    所以照常按 −(π/5 + i×2π/5 + floatV0) 发。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "境符「波と粒の境界」"
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 456

    ---──────────────────────── 演出 / 弹幕 ────────────────────────

    local RING_COUNT = 5                                -- ins_91 的 count1
    local RING_STYLE = ball_small
    local RING_COLOR = ex_color(4)                      -- ins_91 的 color 4
    local SPEED_BASE, SPEED_PER_PHOTO = 2.6, 0.1        -- floatV3 = photoIndex×0.1 + 2.6
    local ACCEL = math.pi / 4800                        -- floatV2 = 0.000654498 rad/帧
    local STEP0 = math.pi * 0.5                         -- floatV0 的初值 π/2

    ---Sub4：每帧一圈，圈在转、转速自己还在涨。
    local function ring_stream(owner)
        task.New(owner, function()
            local fv0, fv1 = STEP0, 0
            local step = 2 * math.pi / RING_COUNT
            while true do
                local speed = SPEED_BASE + photo_index(PHOTO_LIMIT) * SPEED_PER_PHOTO
                for i = 0, RING_COUNT - 1 do
                    local a = math.pi / RING_COUNT + i * step + fv0
                    ---原作的 a 是 TH095 弧度（floatV0 初值 π/2、每帧 += π/4800）
                    ---⇒ 取反并转度后再交给角度制的 NewSimpleBullet。
                    NewSimpleBullet(RING_STYLE, RING_COLOR, owner.x, owner.y,
                            speed, -math.deg(a), false, 0, false)
                end
                PlaySound("tan00", 0.1, owner.x / 256, false)
                fv0 = fv0 + fv1
                fv1 = fv1 + ACCEL
                task.Wait(1)
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=130：起 Sub3 → 起 Sub4（只起这一次）。
            ring_stream(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "4a" } }, LEVEL, CARD_NAME, CARD_ID)
end--境符「波と粒の境界」

do  -- 104 貴人「サンジェルマンの忠告」（ecl24_a，妹红，组 5a 第 1 张）
    ---原作：本体在一条**浅横带**里来回瞬移，同时每 2 帧朝四周甩一圈「快慢双弹」。
    ---数据源 /tmp/E_ecl24_a.txt（ECL …/data/ecl24_a.ecl）。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 用 30 帧落到 (0,192)
    ---    （我们的 (0,32)）；ins_141(10) ⇒ 要拍中 10 张；t=130 亮卡名 +
    ---    ins_75(-140,128,140,192) 把活动框设成 x∈[-140,140]、y∈[128,192]（我们的
    ---    y∈[32,96]）+ ins_52(3) 起 Sub3。
    ---  · Sub3（主脚本）一轮 180 帧：
    ---      t=0 起 Sub4（发弹上下文）；t=75 演出；t=90 先瞬移再**重开 Sub4**
    ---      （ins_117(0,4) 会把旧上下文删掉重建）；t=165 演出；t=180 再瞬移一次，
    ---      然后 ins_4(0,-592) 跳回 **t=0 的 ins_62**（@784）—— 跳回点在那两条 ins_7 之后，
    ---      所以 playerAngle 只在第一轮读一次（旧摘要读成「每轮重读」）。⇒ 每 90 帧
    ---      瞬移一次、并把 Sub4 重开一次（重开时才重读 photoIndex → 圈数每 90 帧才变）。
    ---  · 瞬移（ins_63 = SetPosition，带 ins_75 的活动框 clamp）：
    ---      t=90：x = rand×64 + (intV0 ? 124 : -188)、y = rand×64+128
    ---            ⇒ clamp 后 x 落在 ±140 两侧、y∈[128,192]；
    ---      t=180：x = randSigned×32、y = rand×64+128 ⇒ 回到中线附近。
    ---  · Sub4：**每 2 帧**一轮：
    ---      intV1 = photoIndex/2 + 11（拍得越多圈越密，11..16）；
    ---      ins_89(type 18、color 1、count1 = intV1、count2 = 2、speed1 = 4、speed2 = 1.5、
    ---             angleStep = 0) ⇒ 一圈 intV1 个方向，每个方向**两颗**（速 4.0 与 2.75）。
    ---      基角是 floatV0/floatV1 二选一（intV0 = randU31 % 2，进上下文时抽一次、定死），
    ---      两者每轮分别 −0.5°/+0.5°（TH095）⇒ 环在慢慢转；变量本身由 Sub3 在 t=90/t=180
    ---      加减 45°、甚至被位置量覆盖后再复用（见 main_script / teleport_mid 的注释）。
    ---      ★ Sub4 在 t=2 处有一条 ins_4(0,-224) 跳回自己的 t=0 —— 这条跳转**先**执行、
    ---        且把上下文时间重置为 0，所以 @1740 之后那一段（四角 96 发 + 本体 64 发）
    ---        是**死代码**，原作里从来不会执行（旧摘要把它当成了第二段发弹）。
    ---  · Sub5/Sub6/Sub7：ins_83(5)/83(6) 生出来的**装饰**敌人（ANM 8/9，Sub7 每帧跟随
    ---    photoTarget0），不发弹也不吃判定，按文件头差异 3 的口径不实现。
    ---  · 弹型 18 = 直径 6 ⇒ ball_small；color 1 = 红。flags 514 的出场滑动同差异 3。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL
    local BOX_L, BOX_R = -140, 140                      -- ins_75 的 x 范围
    local BAND_LO, BAND_HI = 128, 192                   -- ins_75 的 y 范围（TH095）

    local PHOTO_LIMIT = 10                              -- ins_141(10)
    local CARD_NAME = "貴人「サンジェルマンの忠告」"
    ---原作卡计时 ins_114(10808)；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 457

    ---──────────────────────── 弹幕 ────────────────────────

    local RING_STYLE, RING_COLOR = ball_small, ex_color(1)
    local RING_COUNT0 = 11                              -- intV1 = photoIndex/2 + 11
    local RING_SPEED1, RING_SPEED2 = 4, 1.5             -- count2 = 2 ⇒ 4.0 与 2.75
    local RING_GAP = 2                                  -- Sub4 的 ins_4(0,-224)
    local BLOCK = 90                                    -- Sub3 每 90 帧重开一次 Sub4

    ---一圈：count1 个方向 × 2 个速度（angleStep = 0 ⇒ 同一方向两颗），基准角 base。
    local function fire_ring(owner, count, base)
        local step = 360 / count
        local v2 = RING_SPEED1 - (RING_SPEED1 - RING_SPEED2) / 2
        for i = 0, count - 1 do
            local a = base + i * step
            NewSimpleBullet(RING_STYLE, RING_COLOR, owner.x, owner.y,
                    RING_SPEED1, a, false, 0, false)
            NewSimpleBullet(RING_STYLE, RING_COLOR, owner.x, owner.y,
                    v2, a, false, 0, false)
        end
    end

    ---t=90 的瞬移：随机选左右一侧（clamp 之后落到 ±140）。
    ---原作顺序是先抽 intV0 = randU31 % 2 决定方向、再抽两个 randF32 当坐标，照抄。
    local function teleport_side(owner)
        local side = (ran:Int(0, 1) == 0)
        local x = ran:Float(0, 64) + (side and -188 or 124)
        owner.x = max(BOX_L, min(BOX_R, x))
        owner.y = field_y(ran:Float(BAND_LO, BAND_HI))
    end

    ---t=180 的瞬移：中线附近。★ 原作的 floatV0/floatV1 在这里**被位置量覆盖**
    ---（randF32S×32 与 randF32×64+128，本来是 x/y 坐标），瞬移之后又拿它们 ±45° 当
    ---**下一轮的基角**用（EclRun 里 floatV0 就是普通 f32，没有类型）——所以把这两个
    ---残值原样返回给 main_script，别当成普通坐标丢掉。
    local function teleport_mid(owner)
        local px = ran:Float(-32, 32)           -- floatV0 = randF32S × 32（TH095 x）
        local py = ran:Float(BAND_LO, BAND_HI)  -- floatV1 = randF32 × 64 + 128（TH095 y）
        owner.x = max(BOX_L, min(BOX_R, px))
        owner.y = field_y(py)
        return px, py
    end

    ---一轮发弹上下文（= Sub3 两次 ins_117(0,4) 之间那 90 帧）：
    ---  · 圈数 intV1 = int(photoIndex / 2) + 11，**重开时才重读**；
    ---  · 基角在 floatV0 / floatV1 里二选一（intV0 = randU31 % 2，进上下文时抽一次、定死）；
    ---  · 每轮（2 帧）floatV0 −0.5°、floatV1 +0.5°（TH095 弧度 0.00872665）⇒ 环慢慢转。
    ---我们这边基角 = −(TH095 角)：floatV0 那一支每轮 +0.5°、floatV1 那一支 −0.5°。
    local RING_DRIFT = 0.5
    local function ring_block(owner, base0, base1)
        local count = math.floor(photo_index(PHOTO_LIMIT) / 2) + RING_COUNT0
        local use0 = (ran:Int(0, 1) == 0)
        local b0, b1 = base0, base1
        for _ = 1, BLOCK / RING_GAP do
            fire_ring(owner, count, use0 and b0 or b1)
            b0 = b0 + RING_DRIFT
            b1 = b1 - RING_DRIFT
            task.Wait(RING_GAP)
        end
    end

    ---Sub3：一轮 180 帧，t=0 / t=90 各起一次发弹上下文（后一次先瞬移、再把两个「角度变量」
    ---±45°，见 Sub3 @1108/@1144），t=180 瞬移 + 覆盖变量后 ins_4 跳回 t=0（@784，
    ---**跳过**开头那两句 floatV0 = floatV1 = playerAngle ⇒ 自机角只在第一轮读一次）。
    local function main_script(owner)
        task.New(owner, function()
            local f0 = Angle(owner.x, owner.y, player.x, player.y)   -- = −deg(floatV0)
            local f1 = f0                                            -- = −deg(floatV1)
            while true do
                ring_block(owner, f0, f1)            -- @784/@796：起 Sub4
                teleport_side(owner)                 -- @1056：t=90 瞬移
                f0, f1 = f0 + 45, f1 - 45            -- @1108/@1144：floatV0 −= 45°、floatV1 += 45°
                ring_block(owner, f0, f1)            -- @1180：重开 Sub4
                local px, py = teleport_mid(owner)   -- @1284：t=180 瞬移
                ---@1304/@1340：残值当角度再 ±45°（TH095 侧 −45/+45 ⇒ 我们 +45/−45）。
                f0 = -math.deg(px) + 45
                f1 = -math.deg(py) - 45
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub2 的 t=130：亮卡名 + 起 Sub3。
            PlaySound("tan00", 0.1, self.x / 256, false)
            main_script(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "5a" } }, LEVEL, CARD_NAME, CARD_ID)
end--貴人「サンジェルマンの忠告」

do  -- 105 蓬莱「瑞江浦嶋子と五色の瑞亀」（ecl24_b，妹红，组 5a 第 2 张）
    ---原作：本体在一条浅带里慢慢挪，同时每 30 帧在「上移 32 px 的位置」上向**五**个方向
    ---抛出五色亀（Sub4 = 15 发 24° 等分环、Sub5 = 10 发 36° 等分环，各 5 种颜色）。
    ---数据源 /tmp/E_ecl24_b.txt（ECL …/data/ecl24_b.ecl）。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,144) 落 (0,144)（我们的 (0,80)）；
    ---    ins_141(5) ⇒ 拍 5 张；t=130 亮卡名 + ins_75(-140,112,140,144)
    ---    （我们的活动框 x∈[-140,140]、y∈[80,112]）+ ins_52(3) 起 Sub3。
    ---  · Sub3 一轮 360 帧：起 Sub6（子上下文 slot 0）→ ins_2(120) → 演出 →
    ---    ins_2(200) → 杀掉 slot 0（ins_117(0,-1)）→ ins_67(40,4,1) 躲 40 帧 →
    ---    ins_4(0,-124) 跳回 t=0 的 ins_117(0,6)。⇒ 每轮 320 帧齐射 + 40 帧移动。
    ---  · Sub6 是 30 帧一轮的**子上下文**：
    ---      t=0：ins_26(floatV0, pos.y, 32) + ins_63(pos.x, floatV0) ⇒ floatV0 = pos.y − 32
    ---           再写回 pos.y（TH095 y 下正 ⇒ 屏幕上**上移** 32 px；我们坐标就是 +32）；
    ---           一轮结束时（@2884）用 ins_25 加回来。发弹用的 worldPosition 就是**移位后**的位置。
    ---      floatV0 = playerAngle；然后 **5 轮**（每轮末 floatV0 += 72°、ins_37 归一化）：
    ---        ins_38(eF0,eF1, floatV0, 40) + ins_100 ⇒ shootOffset = 40 px 外
    ---        ins_52(4) ⇒ 调 Sub4（15 发）；40→32 px + ins_52(5) ⇒ Sub5（10 发）；
    ---        32→72 px + ins_52(5) ⇒ Sub5 再来一次。5 轮 × 35 = **175 发 / 30 帧**。
    ---      ins_4(0,-1232) 跳回 @1716（t=0），一轮正好 30 帧。
    ---  · Sub4 / Sub5 的基角：**都是同一个 playerAngle**（floatV1 = playerAngle，5 次调用
    ---      之间只把 floatV1 **加 24°/36°**，见 @1048 起的 ins_15）—— 不是「每个方向换个基角」。
    ---      由于 ins_89 的 count2 = 1（angleStep 不参与），Sub4 的 5 次调用得到
    ---      {pa + 24×(photoIndex+k) + 120i}，k=0..4、i=0..2 恰好铺满 15 个连续的 24° 网格
    ---      （k+5i = 0..14）⇒ 整体就是「以自机角为 0° 的 15 发 24° 环」；Sub5 同理是
    ---      10 发 36° 环。photoIndex 只改起点、不改集合（15×24 = 10×36 = 360）。
    ---  · Sub7/Sub8/Sub9：ins_83(7)/83(8) 生出来的装饰敌人（Sub9 每帧跟随 photoTarget0），
    ---    不发弹 ⇒ 按文件头差异 3 不实现。
    ---  · 弹型：Sub4 的 (19,6)(12,0)(19,1)(19,3)(12,7) → 半径 3/5/3/3/5（19→ball_small、
    ---    12→ball_mid）；Sub5 全是型 1（半径 3 → ball_small），色 13,0,2,6,15。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(144)              -- 0 / 80
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local BOX_L, BOX_R = -140, 140                      -- ins_75 的 x 范围
    local BOX_LO, BOX_HI = 112, 144                     -- ins_75 的 y 范围（TH095）

    local PHOTO_LIMIT = 5                               -- ins_141(5)
    local CARD_NAME = "蓬莱「瑞江浦嶋子と五色の瑞亀」"
    ---原作卡计时 ins_114(7208)；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 458

    ---──────────────────────── 弹幕 ────────────────────────

    ---Sub4 的 5 次 ins_89：(弹型, 色)。半径 5 的型 12 用 ball_mid，其余（半径 3）用 ball_small。
    local TURTLE4 = { { 19, 6 }, { 12, 0 }, { 19, 1 }, { 19, 3 }, { 12, 7 } }
    local TURTLE5_COLOR = { 13, 0, 2, 6, 15 }
    local SUB4_SPEED, SUB5_SPEED = 1.5, 2               -- count2 = 1 ⇒ speed1
    local SUB4_STEP, SUB5_STEP = 24, 36                 -- 0.418879 / 0.628319 rad
    local DISPLACE = 32                                 -- ins_26 的 32

    ---Sub4：5 次（每次 24° 基角步进）× 3 发（120° 等分）= 15 发。
    local function fire_sub4(x, y, pa, pi)
        for k = 0, 4 do
            local st, co = TURTLE4[k + 1][1], TURTLE4[k + 1][2]
            local style = (st == 12) and ball_mid or ball_small
            local b = pa - SUB4_STEP * (pi + k)
            for i = 0, 2 do
                NewSimpleBullet(style, ex_color(co), x, y, SUB4_SPEED,
                        b - 120 * i, false, 0, false)
            end
        end
    end

    ---Sub5：5 次（每次 36° 基角步进）× 2 发（180° 对射）= 10 发。
    local function fire_sub5(x, y, pa, pi)
        for k = 0, 4 do
            local b = pa - SUB5_STEP * (pi + k)
            for i = 0, 1 do
                NewSimpleBullet(ball_small, ex_color(TURTLE5_COLOR[k + 1]), x, y,
                        SUB5_SPEED, b - 180 * i, false, 0, false)
            end
        end
    end

    ---Sub6：30 帧一轮，从本体上方 32 px 处向 3 个方向各甩 Sub4 + 2×Sub5。
    local function sub6(owner, tok)
        task.New(owner, function()
            while tok.alive do
                local ox, oy = owner.x, owner.y + DISPLACE
                local pa = Angle(ox, oy, player.x, player.y)
                local pi = photo_index(PHOTO_LIMIT)
                ---★ 原作是 **5 轮**（@1972/@2200/@2428/@2656 各一次 floatV0 += 72°，
                ---第 5 轮 @2692 之后就直接收尾了）⇒ j = 0..4，一圈 5 × 72° = 360°。
                for j = 0, 4 do
                    local dir = pa - 72 * j
                    local cx, cy = cos(dir), sin(dir)
                    fire_sub4(ox + 40 * cx, oy + 40 * cy, pa, pi)
                    fire_sub5(ox + 32 * cx, oy + 32 * cy, pa, pi)
                    fire_sub5(ox + 72 * cx, oy + 72 * cy, pa, pi)
                end
                PlaySound("tan00", 0.1, owner.x / 256, false)
                task.Wait(30)
            end
        end)
    end

    ---ins_67(40,4,1) = BeginBoundaryAwareMove（EclDependencies.cpp:108）：
    ---先随机挑一个「背离自机」的方向（TH095 弧度、顺时针为正），再按活动框的四条边界
    ---规则修正，最后 40 帧走 speed×duration = 40 px、缓动 4（= 我们的 DECEL）。
    ---活动框只有 32 px 高 ⇒ 两条 y 规则**恒成立**，净效果是把角度强制成负的（朝屏幕上方）。
    local function boundary_move(owner)
        local a
        if player.x < owner.x then
            a = ran:Float(0, math.pi / 2) + 3 * math.pi / 4
        else
            a = ran:Float(0, math.pi / 2) - math.pi / 4
        end
        ---原代码在 x 右边界那一条里用的是 enemy->movementAngle（不是 angle）——照抄。
        local ma = owner.ex_move_angle or 0
        if owner.x < BOX_L + 96 then
            if a > math.pi / 2 then
                a = math.pi - a
            elseif a < -math.pi / 2 then
                a = -math.pi - a
            end
        end
        if owner.x > BOX_R - 96 then
            if a < math.pi / 2 and a >= 0 then
                a = math.pi - ma
            elseif a > -math.pi / 2 and a <= 0 then
                a = -math.pi - a
            end
        end
        local yth = field_y(owner.y)
        if yth < BOX_LO + 48 and a < 0 then
            a = -a
        end
        if yth > BOX_HI - 48 and a > 0 then
            a = -a
        end
        owner.ex_move_angle = a
        local deg = -math.deg(a)                        -- 我们坐标的角度（度）
        task.MoveTo(owner.x + 40 * cos(deg), owner.y + 40 * sin(deg), 40, VALUE_SET.DECEL)
    end

    ---Sub3：每 320 帧齐射 + 40 帧移动，一轮 360 帧。
    local function main_script(owner)
        task.New(owner, function()
            while true do
                local tok = { alive = true }
                sub6(owner, tok)
                task.Wait(320)
                tok.alive = false
                boundary_move(owner)
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub2 的 t=130：亮卡名 + 起 Sub3。
            PlaySound("tan00", 0.1, self.x / 256, false)
            main_script(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
    end

    boss.card.add({ { card, "5a" } }, LEVEL, CARD_NAME, CARD_ID)
end--蓬莱「瑞江浦嶋子と五色の瑞亀」

do  -- 106 鬼気「濛々迷霧」（ecl25_a，萃香，组 6a 第 1 张）
    ---原作：萃香连续朝自机突进（每 60 帧一次、一次 120 px），沿途撒「雾滴」（几乎不动的小弹），
    ---并把 12 颗会**沿途加速**的大玉一圈圈甩出去。
    ---数据源 /tmp/E_ecl25_a.txt（ECL …/data/ecl25_a.ecl）。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 落 (0,192)（我们的 (0,32)）；
    ---    ins_141(3) ⇒ 拍 3 张；t=130 亮卡名 + ins_52(3) 起 Sub3。**没有 ins_75**（不设活动框）。
    ---  · Sub3（主脚本）：
    ---      t=0 起 Sub5（装饰脉冲，子槽 7）；t=40 演出；
    ---      t=70 起 Sub4（子槽 0，发雾滴）+ ins_143 + extraIntV0=30；
    ---      然后 ins_5 循环 **30 次**：`66(60,1,playerAngle,2)` = 60 帧内朝自机走
    ---        speed×duration = 120 px（缓动 1 = 线性）。
    ---      循环退出后（@888，t=130）起 Sub6（子槽 1，每帧一声脉冲音）+ 再突进一次（@908）；
    ---      t=190（即 60 帧后）把 Sub4 **换成 Sub7**（ins_117(0,7) 删旧建新）并杀掉 Sub6；
    ---      t=370 / t=410 演出；t=440 重新起 Sub4 + extraIntV0=15，
    ---      再 ins_5 循环 15 次突进（900 帧）；
    ---      ins_4(130,-276) 跳回 **@888**（那一次突进），t=130 —— 这就是外层循环。
    ---      ⇒ 首轮 30 次突进（1800 帧）只为开场；此后一轮 = 1 次突进 + 60 + 180 + 40 + 30
    ---        + 15 次突进 = **1210 帧**。
    ---  · Sub4（子槽 0，每帧一轮）：eF0 = 64×randSigned、方向 rand(−π,π) ⇒ 出膛点落在
    ---    离本体 ≤64 px 的圆里；弹角又一次 rand(−π,π)，速 0.05、型 3 色 6（半径 2 → ball_small、蓝）。
    ---    ins_100(0,0) 收尾，ins_4(0,-136) 每帧跳回。flags 520 的出场滑动同差异 3。
    ---  · Sub7（子槽 0，每 60 帧一轮）：先 ins_101(0,16,0,120,-1,0.025,-999) 往变换槽 0 装一条
    ---    ACCEL_VECTOR；然后 ins_89(型 17、色 1、count1=12、count2=1、速 1）甩一圈 12 颗大玉
    ---    （半径 14 → ball_huge）。子弹 flags 536 = 0x218 命中这条变换 ⇒ 之后 120 帧里
    ---    每帧 speed += 0.025（BulletManager.cpp:803-815 的 UpdateVectorAcceleration），
    ---    方向取弹自己的 angle ⇒ 沿原方向一路加速（速 1 → 4）。
    ---  · Sub5/Sub6（子槽 7/1）只做 ANM 脉冲与音效 ⇒ 不实现（文件头差异 3）。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 3                               -- ins_141(3)
    local CARD_NAME = "鬼気「濛々迷霧」"
    ---原作卡计时 ins_114(12608)；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 459

    ---──────────────────────── 弹幕 ────────────────────────

    local SUB3_LEAD = 70                                -- Sub3 t=0 → t=70 才起 Sub4 / 第一次突进
    local DASH_FRAMES, DASH_SPEED = 60, 2               -- ins_66(60,1,pa,2) ⇒ 120 px
    local MIST_R, MIST_SPEED = 64, 0.05                 -- Sub4：偏移半径 / 弹速
    local MIST_STYLE, MIST_COLOR = ball_small, ex_color(6)
    local BIG_STYLE, BIG_COLOR = ball_huge, ex_color(1)
    local BIG_COUNT, BIG_SPEED = 12, 1                  -- Sub7 的 ins_89
    local BIG_GAP = 60                                  -- Sub7 的 ins_4(0,-80)
    local ACCEL_STEP, ACCEL_FRAMES = 0.025, 120         -- ins_101 的 f0 / int0

    ---Sub4：每帧一颗雾滴（出膛点随机、方向随机、几乎不动）。
    local function sub4(owner, tok)
        task.New(owner, function()
            while tok.alive do
                local m = ran:Float(-MIST_R, MIST_R)
                local th = ran:Float(-math.pi, math.pi)
                local ba = ran:Float(-math.pi, math.pi)
                NewSimpleBullet(MIST_STYLE, MIST_COLOR,
                        owner.x + m * math.cos(th), owner.y - m * math.sin(th),
                        MIST_SPEED, -math.deg(ba), false, 0, false)
                task.Wait(1)
            end
        end)
    end

    ---Sub7 的子弹加速：前 120 帧每帧 +0.025（沿弹自己的 angle）。
    local function big_accel_frame(self)
        local n = self.ex_accel or 0
        if n < ACCEL_FRAMES then
            self.ex_accel = n + 1
            local v = (self.ex_vel or BIG_SPEED) + ACCEL_STEP
            self.ex_vel = v
            object.SetV(self, v, self.rot, true)
        end
    end

    ---Sub7：每 60 帧一圈 12 颗加速大玉（基角 rand(−π,π) ⇒ 30° 网格的随机朝向）。
    local function sub7(owner, tok)
        task.New(owner, function()
            while tok.alive do
                local base = ran:Float(0, 360)
                for i = 0, BIG_COUNT - 1 do
                    NewSimpleBullet(BIG_STYLE, BIG_COLOR, owner.x, owner.y, BIG_SPEED,
                            base + i * 360 / BIG_COUNT, false, 0, false,
                            nil, nil, nil, big_accel_frame)
                end
                PlaySound("tan00", 0.1, owner.x / 256, false)
                task.Wait(BIG_GAP)
            end
        end)
    end

    ---一次突进：60 帧、直线 120 px、朝当时的自机角。
    local function dash(owner)
        local a = Angle(owner.x, owner.y, player.x, player.y)
        task.MoveTo(owner.x + DASH_FRAMES * DASH_SPEED * cos(a),
                owner.y + DASH_FRAMES * DASH_SPEED * sin(a), DASH_FRAMES, VALUE_SET.NORMAL)
    end

    ---Sub3：首轮 30 次突进；之后进入 1210 帧的外层循环。
    local tok4, tok7
    local function main_script(owner)
        task.New(owner, function()
            ---Sub3 自己的时间轴：t=0 起 Sub5（装饰）、t=40 演出、t=70 才起 Sub4 与第一次突进。
            task.Wait(SUB3_LEAD)
            tok4 = { alive = true }
            sub4(owner, tok4)
            for _ = 1, 30 do
                dash(owner)
            end
            while true do
                dash(owner)                             -- @908：循环开头那次突进（60 帧）
                ---@948：Sub4 换成 Sub7（在突进结束的同一刻）。
                tok4.alive = false
                tok7 = { alive = true }
                sub7(owner, tok7)
                ---t=190 → t=440：180 + 40 + 30 帧的空档。
                task.Wait(250)
                ---@1060/@1080：Sub4 重新起、Sub7 收掉，然后是 15 次突进。
                tok7.alive = false
                tok4 = { alive = true }
                sub4(owner, tok4)
                for _ = 1, 15 do
                    dash(owner)
                end
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub2 的 t=130：亮卡名 + 起 Sub3。
            PlaySound("tan00", 0.1, self.x / 256, false)
            main_script(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        if tok4 then tok4.alive = false end
        if tok7 then tok7.alive = false end
    end

    boss.card.add({ { card, "6a" } }, LEVEL, CARD_NAME, CARD_ID)
end--鬼気「濛々迷霧」

do  -- 107 「百万鬼夜行」（ecl25_b，萃香，组 6a 第 2 张）
    ---原作：本体每隔 120 帧躲一次（拍中 2 张以上才躲），同时六条子上下文按**拍照进度**
    ---逐条解锁的弹幕（拍得越多越密）。
    ---数据源 /tmp/E_ecl25_b.txt（ECL …/data/ecl25_b.ecl）。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 落 (0,192)（我们的 (0,32)）；
    ---    ins_141(10) ⇒ 拍 10 张；t=130 亮卡名 + ins_75(-140,128,140,192)
    ---    （我们的活动框 x∈[-140,140]、y∈[32,96]）+ ins_52(3) 起 Sub3。
    ---  · Sub3：t=0 起 Sub11（每帧一声脉冲音，装饰）；t=60 起 Sub4..Sub9（六条发弹上下文，
    ---    只起这一次、之后一直跑）；t=60 的 `ins_44(photoIndex,2,60,52)` 是 **CMPlt**：
    ---    photoIndex < 2 就跳过这一轮的 ins_67(60,4,0.8)；ins_4(60,-228) 每 120 帧跳回
    ---    那句 ins_44（t=60）。⇒ 一轮 120 帧、只有「拍中 ≥2 张」才会躲
    ---    （ins_67 的 60 帧走位就占这一轮的头 60 帧，task.MoveTo 是阻塞的）。
    ---  · Sub4（每 24 帧一轮）：**没有闸**，一上来就发（@1012 之后直接是 @1032 的随机半径，
    ---    全段没有 ins_44）；每轮 6 次「随机出膛点（半径 16×rand）+ ins_89(型 19、色 3、
    ---    count1=3、count2=1、速 1)」= 18 发；收尾 floatV0 += 18°（跳回点是 @1032、
    ---    **跳过**开头的 ins_7 rand ⇒ 基角持续累加）。
    ---  · Sub7 同构，只是色 1、速 2；**它有闸**（@2048 的 `ins_44(photoIndex,6,0,744)`）——
    ---    跳转目标 @2792 正是收尾的 `ins_15(floatV0, 0.314159)`，所以 photoIndex < 6 时
    ---    整轮发弹被跳过、但 18° 照样累加。
    ---  · Sub6（每 20 帧）：ins_91 = OFFSET_CIRCLE、型 3、色 6、count1=32、速 2。
    ---  · Sub8（t=10 起每 20 帧）：`ins_44(photoIndex,4,…)` 闸 ⇒ photoIndex ≥ 4 才有
    ---    ins_91（型 3、色 2、速 2、32 发）。
    ---  · Sub9（t=120 起每 20 帧）：`ins_44(photoIndex,8,…)` 闸 ⇒ photoIndex ≥ 8 才有
    ---    ins_88 = CIRCLE_AIMED（型 19、色 1、速 2、32 发）。
    ---  · Sub5（t=90 起每 60 帧）：ins_88 = CIRCLE_AIMED（型 12、色 3、速 1、32 发）。
    ---  · 32 发的整圈（360/32 = 11.25°）在取反后**方向集合不变**；OFFSET_CIRCLE 多出的
    ---    π/count1 = 5.625° 相位也正好落在同一网格上（−5.625 ≡ 5.625 + 11.25×31）。
    ---  · 弹型：12（半径 5）→ ball_mid；3/19（半径 2/3）→ ball_small。
    ---  · Sub10/Sub11 的 150(17)/150(18) 是 ANM 脉冲 ⇒ 不实现（文件头差异 3）。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local BOX_L, BOX_R = -140, 140                      -- ins_75 的 x 范围
    local BOX_LO, BOX_HI = 128, 192                     -- ins_75 的 y 范围（TH095）

    local PHOTO_LIMIT = 10                              -- ins_141(10)
    local CARD_NAME = "「百万鬼夜行」"
    ---原作卡计时 ins_114(12008)；沿用本仓库的 50 秒。
    local CARD_TIME = 50
    local CARD_HP = 900
    local CARD_ID = 460

    ---──────────────────────── 弹幕 ────────────────────────

    local MOVE_GAP = 120                                -- Sub3 的 ins_4(60,-228)
    local MOVE_MIN_PHOTOS = 2                           -- ins_44(photoIndex, 2)
    local MOVE_FRAMES, MOVE_SPEED = 60, 0.8             -- ins_67(60,4,0.8) ⇒ 48 px

    local BURST_N = 6                                   -- Sub4/Sub7 每轮的出膛点数
    local BURST_R = 16                                  -- eF0 = 16 × randF32
    local BURST_GAP = 24                                -- Sub4/Sub7 的 ins_4(0,-xxx)
    local BURST_STEP = 18                               -- 收尾 floatV0 += 0.314159（18°）
    local DENSITY_A = 6                                 -- ins_44(photoIndex, 6)：Sub4/Sub7
    local DENSITY_B = 4                                 -- ins_44(photoIndex, 4)：Sub8
    local DENSITY_C = 8                                 -- ins_44(photoIndex, 8)：Sub9

    local RING_N = 32                                   -- ins_88/91 的 count1
    local RING_STEP = 360 / RING_N                      -- 11.25°
    local OFFSET_PHASE = 180 / RING_N                   -- OFFSET_CIRCLE 的 π/count1

    ---一次 ins_89「count1=3、count2=1」：3 发 120° 等分环。
    local function fire_three(style, color, speed, x, y, base_deg)
        for i = 0, 2 do
            NewSimpleBullet(style, color, x, y, speed, base_deg - 120 * i, false, 0, false)
        end
    end

    ---Sub4 / Sub7：每 24 帧一轮，6 个随机出膛点各甩一个 3 发环。
    ---gate = nil ⇒ 无闸（Sub4），否则 photoIndex ≥ gate 才发（Sub7 = 6）。
    local function burst_stream(owner, tok, style, color, speed, gate)
        task.New(owner, function()
            local fv0 = ran:Float(-math.pi, math.pi)    -- 只在最开始抽一次
            while tok.alive do
                if not gate or photo_index(PHOTO_LIMIT) >= gate then
                    local b = -math.deg(fv0)
                    for _ = 1, BURST_N do
                        local m = ran:Float(0, BURST_R)
                        local th = ran:Float(-math.pi, math.pi)
                        fire_three(style, color, speed,
                                owner.x + m * math.cos(th), owner.y - m * math.sin(th), b)
                    end
                end
                fv0 = fv0 + math.rad(BURST_STEP)
                task.Wait(BURST_GAP)
            end
        end)
    end

    ---ins_88/91 的 32 发整圈：aimed = true 走 CIRCLE_AIMED（基角 = 自机角），
    ---false 走 OFFSET_CIRCLE（多 5.625° 相位）。
    local function ring_stream(owner, tok, style, color, speed, gap, first, aimed, gate)
        task.New(owner, function()
            if first > 0 then
                task.Wait(first)
            end
            while tok.alive do
                if not gate or photo_index(PHOTO_LIMIT) >= gate then
                    local base = aimed and Angle(owner.x, owner.y, player.x, player.y) or 0
                    for i = 0, RING_N - 1 do
                        local ph = aimed and 0 or OFFSET_PHASE
                        NewSimpleBullet(style, color, owner.x, owner.y, speed,
                                base + ph + i * RING_STEP, false, 0, false)
                    end
                    PlaySound("tan00", 0.1, owner.x / 256, false)
                end
                task.Wait(gap)
            end
        end)
    end

    ---ins_67(60,4,0.8) = BeginBoundaryAwareMove（EclDependencies.cpp:108）：
    ---先挑「背离自机」的随机方向（TH095 弧度），再按活动框边界修正，60 帧走 48 px、缓动 4。
    local function boundary_move(owner)
        local a
        if player.x < owner.x then
            a = ran:Float(0, math.pi / 2) + 3 * math.pi / 4
        else
            a = ran:Float(0, math.pi / 2) - math.pi / 4
        end
        ---原代码在 x 右边界那一条里用的是 enemy->movementAngle（不是 angle）——照抄。
        local ma = owner.ex_move_angle or 0
        if owner.x < BOX_L + 96 then
            if a > math.pi / 2 then
                a = math.pi - a
            elseif a < -math.pi / 2 then
                a = -math.pi - a
            end
        end
        if owner.x > BOX_R - 96 then
            if a < math.pi / 2 and a >= 0 then
                a = math.pi - ma
            elseif a > -math.pi / 2 and a <= 0 then
                a = -math.pi - a
            end
        end
        local yth = field_y(owner.y)
        if yth < BOX_LO + 48 and a < 0 then
            a = -a
        end
        if yth > BOX_HI - 48 and a > 0 then
            a = -a
        end
        owner.ex_move_angle = a
        local deg = -math.deg(a)
        task.MoveTo(owner.x + MOVE_FRAMES * MOVE_SPEED * cos(deg),
                owner.y + MOVE_FRAMES * MOVE_SPEED * sin(deg), MOVE_FRAMES, VALUE_SET.DECEL)
    end

    ---Sub3：起六条上下文；每 120 帧按拍照进度躲一次。
    local toks = {}
    local function main_script(owner)
        task.New(owner, function()
            ---t=60：Sub4..Sub9。
            ---Sub4 **没有闸**（它的 @1032 之后没有 ins_44）⇒ 一直发，不传 gate。
            toks[1] = { alive = true }; burst_stream(owner, toks[1], ball_small, ex_color(3), 1, nil)
            toks[2] = { alive = true }; ring_stream(owner, toks[2], ball_mid, ex_color(3), 1, 60, 90, true, nil)
            toks[3] = { alive = true }; ring_stream(owner, toks[3], ball_small, ex_color(6), 2, 20, 0, false, nil)
            toks[4] = { alive = true }; burst_stream(owner, toks[4], ball_small, ex_color(1), 2, DENSITY_A)
            toks[5] = { alive = true }; ring_stream(owner, toks[5], ball_small, ex_color(2), 2, 20, 10, false, DENSITY_B)
            toks[6] = { alive = true }; ring_stream(owner, toks[6], ball_small, ex_color(1), 2, 20, 120, true, DENSITY_C)
            while true do
                if photo_index(PHOTO_LIMIT) >= MOVE_MIN_PHOTOS then
                    ---ins_67 的移动占一轮的头 60 帧（ins_4 在 t=180 才跳回）。
                    boundary_move(owner)
                    task.Wait(MOVE_GAP / 2)
                else
                    task.Wait(MOVE_GAP)
                end
            end
        end)
    end

    ---──────────────────────── 符卡本体 ────────────────────────

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub2 的 t=130：亮卡名 + 起 Sub3。
            PlaySound("tan00", 0.1, self.x / 256, false)
            main_script(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        for i = 1, #toks do
            toks[i].alive = false
        end
    end

    boss.card.add({ { card, "6a" } }, LEVEL, CARD_NAME, CARD_ID)
end--「百万鬼夜行」
---──────────────────── Stage 9（scene group 9 = world10）── 公共工具 ────────────────────
---下面八张卡（scene 90..97）共用 world10（三途の川 / 彼岸）与 enm20/21.anm。
---数据源是 /tmp/S9_ecl20_{a..d}.txt 与 /tmp/S9_ecl21_{a..d}.txt（脚本 /tmp/d95v3.py 反汇编；
---ECL 在 `[th095] …/data/ecl2{0,1}_*.ecl`），各卡注释里的「@地址」都指这几份 dump。
---色表 ex_color / ins_145/147 的激光工具见上面「Stage EX」那一段（同一套）。

---ins_86..94 的一发。th_deg 是 TH095 空间的**度**（顺时针为正、y 朝下）；
---本仓库的角度 = −th_deg（见文件头「坐标系与角度」）。
local function sg_bullet(style, color, x, y, speed, th_deg, frame)
    NewSimpleBullet(style, color, x, y, speed, -th_deg, false, 0, false,
            nil, nil, nil, frame)
end

---自机在 TH095 空间的角度（度）：本仓库 Angle 返回我们的角度（度、逆时针为正）⇒ 取反。
local function sg_aim(x, y)
    return -Angle(x, y, player.x, player.y)
end

---TH095 的弹型 → 本仓库贴图。碰撞直径见 g_PhotoBulletCollisionSizes
---（th095/src/BulletManager.cpp:113-133）：1/3/7/18/23 = 6、4/12 = 10、14/15/16 = 8、
---17 = 28。既有卡的映射是 6→ball_small（半径 2）、10→ball_mid、28→ball_huge；
---直径 8 的 14/15/16 夹在中间，按「观感更接近中玉」一律给 ball_mid（Stage 7 大量用它）。
local function sg_style(t)
    if t == 17 then return ball_huge end
    if t == 1 or t == 3 or t == 7 or t == 18 or t == 23 then return ball_small end
    return ball_mid
end

---flags 的 0x200 = PLAY_SPAWN_SOUND：整条 ins_86..94 响一次（BulletManager.cpp:717-723）。
local function sg_snd(x, flags)
    if flags and math.floor(flags / 0x200) % 2 == 1 then
        PlaySound("tan00", 0.1, x / 256, false)
    end
end

---ins_86..94 的统一出口（SpawnBulletPattern / SpawnSingleBullet，BulletManager.cpp:340-405）。
---mode：86 FAN_AIMED / 87 FAN / 88 CIRCLE_AIMED / 89 CIRCLE / 90 OFFSET_CIRCLE_AIMED /
---      91 OFFSET_CIRCLE / 92 RANDOM_ANGLE / 93 RANDOM_SPEED / 94 RANDOM。
---base / step 都是 TH095 空间的度；aim = true 时把自机角加进去（86/88/90 用）。
---frame（可选）是逐帧钩子，直接透传给 NewSimpleBullet 的第 13 个参数
---（Stage 8 的 ins_101 弹变换就是这么挂上去的，见下面的 sg_tr_hook）。
---速度：count2 > 1 时 sp1 − (sp1−sp2)·index2/count2，否则 sp1（同文件:340-346）。
local function sg_shot(mode, style, color, x, y, c1, c2, sp1, sp2, base, step, aim, flags, frame)
    local ad = aim and sg_aim(x, y) or 0
    local off
    if mode == 86 or mode == 87 then
        off = ex_fan_offsets(c1, step)
    end
    for i2 = 0, c2 - 1 do
        local sp = c2 > 1 and (sp1 - (sp1 - sp2) * i2 / c2) or sp1
        for i1 = 0, c1 - 1 do
            local a
            if mode == 86 or mode == 87 then
                a = ad + base + off[i1 + 1]
            elseif mode == 88 or mode == 89 then
                a = ad + base + i1 * 360 / c1 + i2 * step
            elseif mode == 90 or mode == 91 then
                a = ad + 180 / c1 + base + i1 * 360 / c1
            elseif mode == 92 then
                a = step + ran:Float(0, 1) * (base - step)
            elseif mode == 93 then
                a = ad + base + i2 * step
                sp = sp2 + ran:Float(0, 1) * (sp1 - sp2)
            else
                a = step + ran:Float(0, 1) * (base - step)
                sp = sp2 + ran:Float(0, 1) * (sp1 - sp2)
            end
            sg_bullet(style, color, x, y, sp, a, frame)
        end
    end
    sg_snd(x, flags)
end

---原作的 easing 编号 1..6（EnemyMovement.cpp:112-126）：
---  1 = n²、2 = n³、3 = n⁴、4 = 1−(1−n)²、5 = 1−(1−n)³、6 = 1−(1−n)⁴。
---本仓库 task.MoveTo 的 mode 允许直接给函数（Ltask.lua:163 的 __index）⇒ 原样构造，
---对 ins_64/66/67 的缓动就与原作逐帧一致（原作 progress = 1 − timer/duration = s/n）。
local function sg_ease(k)
    if k == 1 then return function(n) return n * n end end
    if k == 2 then return function(n) return n * n * n end end
    if k == 3 then return function(n) return n * n * n * n end end
    if k == 4 then return function(n) return 1 - (1 - n) * (1 - n) end end
    if k == 5 then
        return function(n) local m = 1 - n; return 1 - m * m * m end
    end
    if k == 6 then
        return function(n) local m = 1 - n; return 1 - m * m * m * m end
    end
    return function(n) return n end
end

---非阻塞的插值移动（ins_64/66/67 都是逐帧积分、不阻塞 ECL）。同一时间只留一条，
---新的会打断旧的（原作里 movementMode = 2 会被后一条指令整个覆盖）。
local function sg_move(owner, st, tx, ty, n, easing)
    if st.mv then st.mv.alive = false end
    local t = { alive = true }
    st.mv = t
    local x0, y0 = owner.x, owner.y
    local dx, dy = tx - x0, ty - y0
    local f = sg_ease(easing)
    task.New(owner, function()
        for s = 1, n do
            if not t.alive or st.dead then return end
            local p = f(s / n)
            owner.x, owner.y = x0 + p * dx, y0 + p * dy
            task.Wait(1)
        end
    end)
end

---ins_67（BeginBoundaryAwareMove，EclDependencies.cpp:108-158）：先按自机位置随机取一个
---「背离自机」的方向，再按活动框（ins_75）反射，最后插值移动 speed×n px。
---TH095 是 y 朝下、顺时针为正 ⇒ 方向在 TH095 空间算完后再交给 sg_move（它按我们的
---坐标取目标点）。box = { x0, y0, x1, y1 }（TH095 坐标，y0 < y1 表示 y0 在上方）。
local function sg_bmove(owner, st, n, easing, speed, box)
    local x = owner.x
    local y = FIELD_HALF_H - owner.y                 -- 本体位置的 TH095 y
    local a
    if player.x < x then
        a = ran:Float(0, math.pi / 2) + 2.3561945     -- rand[0,π/2) + 3π/4
    else
        a = ran:Float(0, math.pi / 2) - 0.78539819    -- rand[0,π/2) − π/4
    end
    if x < box[1] + 96 then
        if a > 1.5707964 then a = 3.1415927 - a
        elseif a < -1.5707964 then a = -3.1415927 - a end
    end
    if x > box[3] - 96 then
        ---★ 原作右边界这一支用的是**上一次的** movementAngle（不是刚算出的 angle）——
        ---EclDependencies.cpp:139 的 `3.1415927 - enemy->movementAngle`。照抄。
        if a < 1.5707964 and a >= 0 then a = 3.1415927 - (st.mv_angle or a)
        elseif a > -1.5707964 and a <= 0 then a = -3.1415927 - a end
    end
    if y < box[2] + 48 and a < 0 then a = -a end
    if y > box[4] - 48 and a > 0 then a = -a end
    st.mv_angle = a
    local d = speed * n
    sg_move(owner, st, x + d * math.cos(a), owner.y - d * math.sin(a), max(1, n), easing)
end

---ins_145 直线激光（PhotoStraightLaserView::Update，PhotoEffect.cpp:208-230）：
---从长度 0 起、每帧 +speed 长到 max_len；长满后每帧沿自己的方向前进 speed。
---初始化时 state 直接是 ACTIVE、宽度恒定（同文件:290-325），所以没有 147 的四段。
---★ 原作 145 的判定还多一道 width > 40 的闸（同文件:252 的 `length > 16 && width > 40`）；
---  world10 的 145 全是 width 16 —— 照搬的话这些激光一颗都打不到自机、这张符卡只剩背景。
---  本仓库的激光本来就是独立判定对象（见上面 run_ex_laser 的口径），这里让 145 和 147
---  一样在 length > 16 时判定。这是本卡组唯一一处对原作的刻意偏离，记在各卡注释里。
local function run_ex_laser_straight(owner, l, max_len, width, speed)
    task.New(owner, function()
        local len, full = 0, false
        while IsValid(l) do
            if not full then
                len = min(max_len, len + speed)
                full = len >= max_len
            else
                l.x = l.x + speed * cos(l.rot)
                l.y = l.y + speed * sin(l.rot)
            end
            l.colli = len > 16
            l.l1, l.l2, l.l3 = 0, len, 0
            l.alpha = 1
            task.Wait()
        end
        if IsValid(l) then
            object.RawDel(l)
        end
    end)
end

---生成一根 ins_145 直线激光。
local function spawn_ex_laser_straight(owner, lasers, index, x, y, angle, max_len, width, speed)
    local l = New(laser, index, x, y, angle, 0, 0, 0, 0, 0, 0)
    l.colli = false
    lasers[#lasers + 1] = l
    run_ex_laser_straight(owner, l, max_len, width, speed)
    return l
end

---ins_102（清屏）：DespawnAllBullets + 清掉本卡自己放出的激光（EclRunTargetHigh.inl:470）。
local function sg_clear(lasers)
    object.BulletDo(function(b) object.RawDel(b) end)
    for i = #lasers, 1, -1 do
        if IsValid(lasers[i]) then
            object.RawDel(lasers[i])
        end
        lasers[i] = nil
    end
end



do  -- 90 小町 非符（ecl20_a，组 7a 第 1 张）
    ---原作这一关的第 1 幕**没有** ins_104（不亮卡名），是一个「前哨」：小町在活动框里
    ---随机游走，一边撒两组对称扇（Sub4）；拍到第 3 张后换成更密的整圈（Sub7），
    ---拍到第 6 张后再换成「只游走、不再放弹」（Sub8）。
    ---数据源 /tmp/S9_ecl20_a.txt（ECL …/data/ecl20_a.ecl）。骨架：
    ---  · Sub2：ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,128) 用 30 帧落到 (0,128)
    ---    （我们的 (0,96)）；ins_141(8) ⇒ 拍 8 张；t=130 的 `id=0`（**不是** ins_104 ——
    ---    它把当前 ANM 脚本停掉）+ ins_75(-140,128,140,192) 设活动框 + ins_149(4.5)
    ---    + ins_132(1) + ins_52(3) 起主脚本。t=0 的两条 ins_115 见下面「按张切换」。
    ---  · Sub3（默认主控，300 帧一轮）：t=0 起 Sub5（装饰）→ t=60 换成 Sub4（发弹）→
    ---    t=180 ins_67(120,4,0.5)：沿「背离自机」的随机方向插值 60 px（120 帧、缓动 4）→
    ---    t=240 收掉 Sub4 → t=300 跳回 t=0。
    ---  · Sub4：两段各 24 帧的连发扇，每帧发两组 ins_87 FAN(type 23 → ball_small，
    ---    count1 = 4 / 3、速 = floatV0、基角 = floatV1、步长 0.392699)。floatV0 每帧 +0.2、
    ---    floatV1 每帧 −0.0448799 rad；第二段（t=31）把两个初值重置（各取当时的 playerAngle）。
    ---  · Sub6（拍中第 3 张起接管主脚本）：ins_102 清屏 → 起 Sub5 → t=60 换成 Sub7 →
    ---    t=180 再一次 ins_67(60,4,1.5) → t=240 收掉 Sub7 → 跳回 t=0（240 帧一轮）。
    ---  · Sub7（真发弹，302 帧一轮）：floatV0 = 0.5、floatV1 = playerAngle、
    ---    intV0 = photoIndex − 2；两段各 24 帧的连发整圈 ins_89 CIRCLE(type 23、色 0/1、
    ---    count1 = 8、count2 = intV0、速 = floatV0、基角 floatV1、步长 0.392699)。
    ---    floatV0 每帧 +0.15；floatV1 第一段每帧 +0.0981748、第二段 −0.0981748（反着转）。
    ---    **count2 = photoIndex − 2 ⇒ 拍不够 3 张时一发都不发**（0 / 负数 = 空循环）。
    ---  · Sub8（拍中第 6 张起）：ins_102 清屏 → 起 Sub5 → t=60 换成 Sub9 →
    ---    此后每 120 帧一次 ins_67(120,4,0.5) 的随机游走。
    ---  · Sub9：每帧把出膛点挪到离本体 ≤32 px 的随机点，再发 3 组 ins_89 CIRCLE
    ---    (type 23、色 0/1/2、count1 = 2、速 = 0.8 + rand×1.2、基角 rand(−π,π))。
    ---  · Sub5（装饰）与 Sub0/Sub1（死亡/退场）不实现（文件头差异 3/5）。
    ---★ 原作 ins_115(slot, frame, sub) 的 frame 比的是 camera.photoIndex
    ---  （EnemyManagerUpdate.cpp:1280-1330 的 UpdateScheduledEclCalls；g_PhotoEnemyGame->
    ---  frameCounter 就在 player 的 camera.photoIndex 偏移 0x29E4 上）。本仓库用「拍中本体
    ---  的张数」（photo_hits）来替代，所以这里是「拍中第 k 张时把主脚本换成 sub」。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 8                               -- ins_141(8)
    local CARD_NAME = ""                                -- 非符：原作没有 ins_104
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 470

    local BOX = { -140, 128, 140, 192 }                 -- ins_75 的活动框（TH095 空间）

    ---Sub4（ins_87 FAN）：{ count1, 原作色号 }。
    local FAN_SEG = 24
    local FAN_SPEED0, FAN_SPEED_STEP = 0.5, 0.2
    local FAN_STEP_DEG = 22.5                           -- 0.392699 rad
    local FAN_SPIN = 0.0448799                          -- floatV1 每帧的增量（rad）
    local FAN_GROUP = { { 4, 0 }, { 3, 1 } }
    ---Sub7（ins_89 CIRCLE）。
    local RING_SEG = 24
    local RING_COUNT = 8
    local RING_SPEED0, RING_SPEED_STEP = 0.5, 0.15
    local RING_SPIN = 0.0981748                         -- rad/帧
    ---Sub9（ins_89 CIRCLE，随机点随机角）。
    local SPRAY_R = 32
    local SPRAY_SPEED0, SPRAY_SPEED1 = 0.8, 1.2

    local lasers = {}
    local st = { dead = false }
    local gen = 0                                       -- 当前主脚本代号（ins_115 会 +1）
    local fired = { false, false }

    local function alive(g, sub)
        return g == gen and not st.dead and (sub == nil or sub.alive)
    end

    ---Sub4：两段各 24 帧的连发扇（每帧两组）。
    local function sub4(owner, g, tok)
        task.New(owner, function()
            while alive(g, tok) do
                for _ = 0, 1 do
                    local sp = FAN_SPEED0
                    local ang = -math.rad(Angle(owner.x, owner.y, player.x, player.y))
                    for _ = 1, FAN_SEG do
                        if not alive(g, tok) then return end
                        for k = 1, #FAN_GROUP do
                            sg_shot(87, ball_small, ex_color(FAN_GROUP[k][2]),
                                    owner.x, owner.y, FAN_GROUP[k][1], 1, sp, 1.5,
                                    math.deg(ang), FAN_STEP_DEG, false, 514)
                        end
                        sp = sp + FAN_SPEED_STEP
                        ang = ang + FAN_SPIN
                        task.Wait(1)
                    end
                    task.Wait(7)                        -- t=24 → t=31（或 t=55 → t=62）
                end
            end
        end)
    end

    ---Sub7：两段各 24 帧、每帧一圈（count2 = photoIndex − 2）。
    local function sub7(owner, g, tok)
        task.New(owner, function()
            while alive(g, tok) do
                local n2 = photo_index(PHOTO_LIMIT) - 2
                for pass = 0, 1 do
                    local sp = RING_SPEED0
                    local ang = -math.rad(Angle(owner.x, owner.y, player.x, player.y))
                    for _ = 1, RING_SEG do
                        if not alive(g, tok) then return end
                        sg_shot(89, ball_small, ex_color(pass), owner.x, owner.y,
                                RING_COUNT, n2, sp, 0.5, math.deg(ang), 22.5, false, 514)
                        sp = sp + RING_SPEED_STEP
                        ang = ang + (pass == 0 and RING_SPIN or -RING_SPIN)
                        task.Wait(1)
                    end
                end
                task.Wait(254)                          -- 一轮 302 帧（前 48 帧在发弹）
            end
        end)
    end

    ---Sub9：每帧一组随机点 + 3 组整圈。
    local function sub9(owner, g, tok)
        task.New(owner, function()
            while alive(g, tok) do
                local r = ran:Float(0, 1) * SPRAY_R
                local a = ran:Float(-math.pi, math.pi)
                local ox, oy = math.cos(a) * r, -math.sin(a) * r
                for c = 0, 2 do
                    local sp = SPRAY_SPEED0 + ran:Float(0, 1) * SPRAY_SPEED1
                    local base = math.deg(ran:Float(-math.pi, math.pi))
                    sg_shot(89, ball_small, ex_color(c), owner.x + ox, owner.y + oy,
                            2, 1, sp, 0.5, base, 22.5, false, 514)
                end
                task.Wait(1)
            end
        end)
    end

    ---Sub3：默认主控（300 帧一轮）。
    local function run_default(owner)
        local g = gen
        task.New(owner, function()
            while alive(g) do
                local tok = { alive = true }
                task.Wait(60)                           -- t=0..59（Sub5 装饰期）
                if not alive(g) then return end
                sub4(owner, g, tok)                     -- t=60
                task.Wait(120)                          -- t=60..179
                if alive(g) then
                    sg_bmove(owner, st, 120, 4, 0.5, BOX)   -- t=180（120 帧、60 px）
                end
                task.Wait(60)                           -- t=180..239
                tok.alive = false                       -- t=240
                task.Wait(60)                           -- t=240..299
            end
        end)
    end

    ---Sub6：拍中第 3 张起的循环（240 帧一轮，含一次清屏）。
    local function run_b(owner)
        local g = gen
        task.New(owner, function()
            sg_clear(lasers)
            while alive(g) do
                local tok = { alive = true }
                task.Wait(60)
                if not alive(g) then return end
                sub7(owner, g, tok)
                task.Wait(120)
                if alive(g) then
                    sg_bmove(owner, st, 60, 4, 1.5, BOX)
                end
                task.Wait(60)
                tok.alive = false
            end
        end)
    end

    ---Sub8：拍中第 6 张起（清屏一次，然后只游走）。
    local function run_c(owner)
        local g = gen
        task.New(owner, function()
            sg_clear(lasers)
            local tok = { alive = true }
            task.Wait(60)
            if not alive(g) then return end
            sub9(owner, g, tok)
            task.Wait(120)
            while alive(g) do
                sg_bmove(owner, st, 120, 4, 0.5, BOX)
                task.Wait(120)
            end
        end)
    end

    ---ins_115 的「拍中第 k 张」监视器。
    local function watcher(owner)
        task.New(owner, function()
            while not st.dead do
                local hits = photo_index(PHOTO_LIMIT)
                if hits >= 3 and not fired[1] then
                    fired[1] = true
                    gen = gen + 1
                    run_b(owner)
                elseif hits >= 6 and not fired[2] then
                    fired[2] = true
                    gen = gen + 1
                    run_c(owner)
                end
                task.Wait(1)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        gen = gen + 1
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            run_default(self)                           -- Sub3
            watcher(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        sg_clear(lasers)
    end

    boss.card.add({ { card, "7a" } }, LEVEL, CARD_NAME, CARD_ID)
end--小町 非符（ecl20_a）

do  -- 91 嘘言「タン・オブ・ウルフ」（ecl21_a，映姬，组 8a 第 1 张）
    ---原作是一张「每拍一张就换一次密度」的符卡：本体停在 (0,192) 不动，两条子上下文
    ---交替出手 —— 一段每 4 帧甩一整圈（圈上弹数随拍照进度涨），一段每 20 帧朝自机打六连。
    ---每拍中一张，原作都用 ins_115 触发的 Sub7 把整屏清掉、主循环从头重来。
    ---数据源 /tmp/S9_ecl21_a.txt（ECL …/data/ecl21_a.ecl）。骨架：
    ---  · Sub2：ins_55(2)（ANM 组 2..7）+ ins_81(3) + ins_109(0)（拍照目标 0 = 本体）
    ---    + ins_77(24,24) + ins_141(6)（拍 6 张）+ ins_108(0,31)/ins_108(1,30)（子机）
    ---    + ins_143(1,130) + ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,192) 落到 (0,192)
    ---    （我们的 (0,32)）→ t=130 亮卡名 + ins_75(-140,128,140,192)（活动框）+ ins_149(1.2)
    ---    + ins_132(1) + ins_52(3) 起 Sub3。t=0 的六条 ins_115 见下面「按张重开」。
    ---  · Sub3（主控，240 帧一轮）：t=0 响一声 + ins_117(0,6)（装饰子上下文）→ t=60 换成
    ---    Sub4（**发弹**）→ t=120 ins_67(120,4,0)（speed = 0 ⇒ 只在原地重取移动方向、不位移）
    ---    → t=180 换成 Sub5（**发弹**）→ t=240 ins_4(0,-112) 跳回 t=0。
    ---  · Sub4（每 4 帧一次，ins_4(0,-148)）：进上下文时 intV0 = photoIndex×4 + 24
    ---    （**只在进入时算一次**，@1072）、floatV0 = 4（速）、floatV1 = 0；循环体
    ---    @1136：floatV2 = playerAngle + rand(-π,π)×floatV1（@1156 乘 + @1180 加），
    ---    ins_89 CIRCLE（型 18、色 0、count1 = intV0、count2 = 1、速 4、基角 floatV2、
    ---    步长 0.1848）⇒ **一圈 24 + 4×拍中张数 发**；每轮 floatV1 += 0.001（基角慢慢散开）。
    ---  · Sub5（每 20 帧一次，ins_4(0,-128)）：进上下文时 floatV0 = 4、floatV1 = 0；
    ---    ins_88 CIRCLE_AIMED（型 18、色 1、count1 = 1、count2 = 6、sp1 = 4、sp2 = 1）
    ---    ⇒ 6 发**全朝自机**、速 = 4 − (4−1)×i2/6 = 4, 3.5, 3, 2.5, 2, 1.5。
    ---  · Sub6（每帧 ins_106(5) + ins_150(8)）是装饰 ANM；Sub0/Sub1 是死亡/退场 ⇒ 不实现。
    ---  · Sub7 = Sub3 前面加一句 ins_102（清屏）、时间轴整体 +50 ⇒ 就是「清屏后重开主循环」。
    ---★ ins_115(slot, frame, sub) 的 frame 比的是 camera.photoIndex（见文件头「已拍张数」
    ---  与卡 90 的说明）⇒ 本卡写「拍中第 k 张时清屏并把主循环从头重来」。
    ---  Sub2 里 slot 2 是空的，其余六条 (0,1,7)(1,2,7)(3,3,7)(4,4,7)(5,5,7)(6,6,7)
    ---  正好覆盖第 1..6 张。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "嘘言「タン・オブ・ウルフ」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 471

    local RING_WAIT = 4                                 -- Sub4 的 ins_4(0,-148)
    local RING_BASE, RING_PER_PHOTO = 24, 4             -- intV0 = photoIndex×4 + 24
    local RING_SPEED = 4                                -- floatV0（c2 = 1 ⇒ 只用 sp1）
    local RING_STEP = math.deg(0.1848)                  -- c2 = 1 ⇒ 不参与，照抄
    local RING_SPREAD = 0.001                           -- floatV1 每轮的增量（rad）
    local AIM_WAIT = 20                                 -- Sub5 的 ins_4(0,-128)
    local AIM_COUNT = 6
    local AIM_SPEED0, AIM_SPEED1 = 4, 1

    local lasers = {}
    local fired = {}

    ---Sub4：每 4 帧一整圈，弹数 = 24 + 4×photoIndex（进上下文时算一次）。
    local function sub4(owner, tok)
        task.New(owner, function()
            local count = RING_BASE + RING_PER_PHOTO * photo_index(PHOTO_LIMIT)
            local spread = 0                            -- floatV1
            while tok.alive do
                local base = sg_aim(owner.x, owner.y)
                        + math.deg(ran:Float(-math.pi, math.pi) * spread)
                sg_shot(89, ball_small, ex_color(0), owner.x, owner.y,
                        count, 1, RING_SPEED, 1.5, base, RING_STEP, false, 514)
                spread = spread + RING_SPREAD
                task.Wait(RING_WAIT)
            end
        end)
    end

    ---Sub5：每 20 帧六连自机狙（型 18、色 1、速 4..1.5）。
    local function sub5(owner, tok)
        task.New(owner, function()
            while tok.alive do
                sg_shot(88, ball_small, ex_color(1), owner.x, owner.y,
                        1, AIM_COUNT, AIM_SPEED0, AIM_SPEED1, 0, 0, true, 514)
                task.Wait(AIM_WAIT)
            end
        end)
    end

    ---Sub3（clear = false）/ Sub7（clear = true）：240 帧一轮。
    local function cycle(owner, clear)
        task.New(owner, function()
            if clear then
                sg_clear(lasers)
            end
            local tok
            local function drop()
                if tok then tok.alive = false; tok = nil end
            end
            while true do
                PlaySound("tan00", 0.1, owner.x / 256, false)   -- t=0 的 ins_106(5)
                task.Wait(60)                                    -- t=0 → 60（Sub6 装饰不实现）
                drop(); tok = { alive = true }; sub4(owner, tok)  -- t=60：ins_117(0,4)
                task.Wait(120)                                   -- t=60 → 180
                ---t=120 的 ins_67(120,4,0)：speed = 0 ⇒ 没有位移，只重取一次移动方向。
                drop(); tok = { alive = true }; sub5(owner, tok)  -- t=180：ins_117(0,5)
                task.Wait(60)                                    -- t=180 → 240
                drop()
            end
        end)
    end

    ---ins_115：拍中第 1..6 张各触发一次（清屏 + 主循环从 t=0 重开）。
    local function watcher(owner)
        task.New(owner, function()
            while true do
                local hits = photo_index(PHOTO_LIMIT)
                for k = 1, PHOTO_LIMIT do
                    if hits >= k and not fired[k] then
                        fired[k] = true
                        cycle(owner, true)                  -- Sub7
                    end
                end
                task.Wait(1)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        fired = {}
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            cycle(self, false)                              -- Sub3
            watcher(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        sg_clear(lasers)
    end

    boss.card.add({ { card, "8a" } }, LEVEL, CARD_NAME, CARD_ID)
end--嘘言「タン・オブ・ウルフ」

do  -- 92 死歌「八重霧の渡し」（ecl20_b，小町，组 7a 第 2 张）
    ---原作：本体**一直朝自机走**（ins_65 把 movementAngle 设成自机方向、speed 0.5/帧，
    ---再每 2 帧重取一次方向），同时两条子上下文各管一头 —— Sub4 每 180 帧放两批
    ---各 8 根**反向旋转**的 147 激光，Sub5 每 14−2×拍中张数 帧甩两组 9 发扇。
    ---数据源 /tmp/S9_ecl20_b.txt（ECL …/data/ecl20_b.ecl）。骨架：
    ---  · Sub2：ins_55(2) + ins_81(3) + ins_109(0) + ins_77(24,24) + ins_141(6)（拍 6 张）
    ---    + ins_108(0,31)/ins_108(1,30) + ins_143(1,130) + ins_63(-128,-64) 进场
    ---    → t=100 ins_64(30,4,0,128) 落到 (0,128)（我们的 (0,96)）→ t=130 亮卡名
    ---    + ins_149(4) + ins_132(1) + ins_52(3) 起 Sub3。**Sub2 里没有 ins_115** ——
    ---    这一张不像 91 那样按拍照进度换脚本。
    ---  · Sub3（不发弹，只管走位）：t=0 ins_106(5) + 117(1,6)（装饰）+ 117(0,4)（激光）
    ---    + 117(2,5)（扇）；extraIntV0 = 65；@808 t=0 的 ins_65(playerAngle, 0.5)
    ---    配 @828 t=2 的 ins_5(0,-12,extraIntV0) ⇒ **每 2 帧重取一次方向、走到第 130 帧**。
    ---    随后 @852 起：extraIntV0 = 30、floatV0 = 0.5 → 循环 30 次
    ---    「ins_65(playerAngle, floatV0) → floatV0 += 0.04」（@892/@912，每次 2 帧）；
    ---    再 extraIntV0 = 60、floatV0 = 0.5 → 循环 60 次 @976/@996；
    ---    @1020 t=6 的 ins_4(2,-168) 跳回 @852 ⇒ **之后永远在 30 步 + 60 步这两段之间循环**。
    ---    ins_65 设的是「持续直线运动」（EclRunLow.inl case 65 把 movementMode 置 1），
    ---    方向每 2 帧才刷新一次、中间两帧仍按旧方向走，所以位移是逐帧连续的。
    ---  · Sub4（@1052，一轮 180 帧）：t=60 起两批各 8 根 ins_147（型 1、色 2/色 4、
    ---    长 160、宽 16、四段 70/60/30/10、角速度 ±0.0785398 rad/帧、followPhotoTarget = 1），
    ---    每批的起始角是**各取一次** rand(-π,π)、然后每根 +π/4；
    ---    t=150 的 ins_144(15) 是快门脉冲；t=180 跳回 @1092（t=60）——
    ---    跳转把 time 设成 0，所以要等 60 帧才走到 @1092 ⇒ 两轮之间正好 180 帧。
    ---  · Sub5（@1464，一轮 = 14−2×photoIndex 帧）：t=0 里 floatV0 = photoIndex×0.1 + 2.6
    ---    （@1540 乘、@1564 加；@1484 那句 rand 立刻被覆盖，照抄即可），
    ---    ins_86 FAN_AIMED 两组各 9 发（型 23、色 0 / 色 1、基角 0 / π、步长 0.285599）；
    ---    收尾 extraIntV1 = photoIndex×2（ins_22）、再 extraIntV1 = 14 − extraIntV1（ins_21 是
    ---    **op0 = op1 − op2**，所以是 14 − 2×photoIndex）、ins_2 冻结这么多帧。
    ---    ins_141(6) ⇒ photoIndex ≤ 6 ⇒ 冻结 14 → 2 帧，不会出现「0 帧连转」的卡死。
    ---  · Sub6（每 2 帧 ins_106(5) + ins_150(10)）是装饰 ANM；Sub0/Sub1 死亡/退场 ⇒ 不实现。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "死歌「八重霧の渡し」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 472

    ---Sub3 的三段位移（步数, 初始速, 每步增速, 每步帧数）。
    local DRIFT = { { 65, 0.5, 0 }, { 30, 0.5, 0.04 }, { 60, 0.5, 0 } }

    ---Sub4 的 ins_147。
    local LASER_LEN, LASER_W = 160, 16
    local LASER_STARTUP, LASER_GROW, LASER_SUSTAIN, LASER_FADE = 70, 60, 30, 10
    local LASER_AV = math.deg(0.0785398)                -- TH095 顺时针为正 ⇒ 我们取负
    local LASER_WAIT = 180                              -- 两轮之间 180 帧
    local LASER_FIRST = 60                              -- 第一轮在 t=60

    ---Sub5 的 ins_86 FAN_AIMED。
    local FAN_COUNT = 9
    local FAN_STEP = math.deg(0.285599)
    local FAN_SPEED0, FAN_SPEED_STEP = 2.6, 0.1         -- 2.6 + photoIndex×0.1
    local FAN_FREEZE0, FAN_FREEZE_STEP = 14, 2          -- 14 − photoIndex×2

    local lasers = {}

    ---ins_65：把本体设成「每帧朝自机 speed 像素」，方向每 2 帧重取一次（见注释）。
    ---★ 这一步是 Sub3 **自己**的顺序流程（原作里 ins_5 循环就在同一个上下文里跑），
    ---  所以这里不能再开 task.New —— 直接在主任务的协程里 task.Wait 才有「等到走完」的语义。
    local function drift(owner, tok, steps, speed0, step)
        local sp = speed0
        for _ = 1, steps do
            if not tok.alive then return end
            local a = Angle(owner.x, owner.y, player.x, player.y)
            owner.x = owner.x + sp * cos(a)
            owner.y = owner.y + sp * sin(a)
            task.Wait(1)
            if not tok.alive then return end
            owner.x = owner.x + sp * cos(a)
            owner.y = owner.y + sp * sin(a)
            task.Wait(1)
            sp = sp + step
        end
    end

    ---Sub4：每 180 帧一批（60 帧预热 + 两批 8 根反向旋转的 147）。
    local function sub4(owner, tok)
        task.New(owner, function()
            while tok.alive do
                task.Wait(LASER_FIRST)
                if not tok.alive then return end
                for _, cfg in ipairs({ { 2, LASER_AV }, { 4, -LASER_AV } }) do
                    local a0 = ran:Float(-math.pi, math.pi)
                    for k = 0, 7 do
                        spawn_ex_laser(owner, lasers, cfg[1], owner.x, owner.y,
                                -math.deg(a0 + k * math.pi / 4), LASER_LEN, LASER_W, 8,
                                LASER_STARTUP, LASER_GROW, LASER_SUSTAIN, LASER_FADE,
                                cfg[2], 0, 0, true, true)
                    end
                end
                task.Wait(LASER_WAIT - LASER_FIRST)
            end
        end)
    end

    ---Sub5：每 (14 − 2×photoIndex) 帧两组 9 发扇（一组朝自机、一组背对）。
    local function sub5(owner, tok)
        task.New(owner, function()
            while tok.alive do
                local sp = FAN_SPEED0 + photo_index(PHOTO_LIMIT) * FAN_SPEED_STEP
                sg_shot(86, ball_small, ex_color(0), owner.x, owner.y,
                        FAN_COUNT, 1, sp, 1.5, 0, FAN_STEP, true, 2)
                sg_shot(86, ball_small, ex_color(1), owner.x, owner.y,
                        FAN_COUNT, 1, sp, 1.5, 180, FAN_STEP, true, 2)
                task.Wait(max(1, FAN_FREEZE0 - FAN_FREEZE_STEP * photo_index(PHOTO_LIMIT)))
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub3 的 t=0。
            PlaySound("tan00", 0.1, self.x / 256, false)
            local tok = { alive = true }                -- slot0/slot2 共用一个取消开关
            sub4(self, tok)
            sub5(self, tok)
            drift(self, tok, DRIFT[1][1], DRIFT[1][2], DRIFT[1][3])
            while tok.alive do                         -- ins_4(2,-168) 跳回 @852
                drift(self, tok, DRIFT[2][1], DRIFT[2][2], DRIFT[2][3])
                drift(self, tok, DRIFT[3][1], DRIFT[3][2], DRIFT[3][3])
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        photo_damage_off(self)
        sg_clear(lasers)
    end

    boss.card.add({ { card, "7a" } }, LEVEL, CARD_NAME, CARD_ID)
end--死歌「八重霧の渡し」

do  -- 93 審判「十王裁判」（ecl21_b，映姬，组 8a 第 2 张）
    ---原作是一张「拍得越多、判词换得越狠」的符卡：本体只有一条主循环
    ---（默认一对弹幕 → 180 帧躲一次），另挂**九条 ins_115 监视器**，拍中第 k 张就把
    ---主循环掐掉、换成第 k 号「波」——每号波都是「清屏 + 每 180 帧放一对新的弹幕」。
    ---数据源 /tmp/S9_ecl21_b.txt（ECL …/data/ecl21_b.ecl）。骨架：
    ---  · Sub2：ins_55(2) + ins_81(3) + ins_109(0) + ins_77(24,24) + ins_141(10)（拍 10 张）
    ---    + ins_108(0,31)/ins_108(1,30) + ins_143(1,130) + ins_63(-128,-64) 进场
    ---    → t=40 ins_64(30,4,0,128) 落到 (0,128)（我们的 (0,96)）→ t=70 亮卡名
    ---    + ins_75(-140,128,140,192) + ins_132(1) + ins_52(3) 起 Sub3。
    ---    t=0 的九条 ins_115 是 (0,1,6)(1,2,12)(2,3,9)(3,4,15)(4,5,19)(5,6,22)
    ---    (6,7,25)(7,8,28)(8,9,31) ⇒ 第 k 张 → 第 k 号波（见下表）。
    ---  · Sub3（默认主控）：t=0 响一声 + 117(0,18)（装饰）+ slot1 = Sub4（激光）、
    ---    slot2 = Sub5（扇）→ t=100 ins_144(15)（快门脉冲）→ t=120 ins_67(60,0,1)
    ---    （缓动 0 = 线性、60 帧走 60 px）+ 收掉 slot1/slot2 → t=180 ins_4(0,-120)
    ---    跳回 @1084（那是 **t=0 的 117(1,4)**，不重放 t=0 的响指与装饰）⇒ 一轮 180 帧。
    ---  · 九号波 Sub6/9/12/15/19/22/25/28/31 结构完全一样，只是换 (A, B) 两个子上下文：
    ---      t=0 ins_102（清屏）→ t=30 响一声 + 117(0,18) + 117(1,A) + 117(2,B)
    ---      → t=130 ins_144(15) → t=150 ins_67(60,0,1) + 收掉 slot1/slot2
    ---      → t=210 ins_4(30,-120) 跳回 @(t=30 的 117(1,A))。
    ---    注意跳转把 time 设成 30 ⇒ 清屏与装饰只在第一遍跑，之后每 180 帧只换一对弹幕。
    ---  · (A, B) 清单（帧号 = 拍中第几张；数值全部照抄 dump）：
    ---      1 (Sub4,  Sub5)   4: 145(型12,色3,速4,角=自机,长96,宽16) 每 30 帧一根
    ---                        5: FAN(型3, 色6, 7发,速5,自机,步0.101342)
    ---                           + FAN(型13,色3,21发,速6,自机+π,步0.241661) 每 10 帧
    ---      2 (Sub13, Sub14) 13: 145(型12,色4,速5,角=自机−22.5°+rand×45°) 每 4 帧
    ---                       14: 同 Sub5 但色 8 / 色 4
    ---      3 (Sub10, Sub11) 10: 五根 145（型12, 色2, 角=自机−22.5°…+22.5° 每根 +11.25°,
    ---                            速 4/6/8/6/4）每 15 帧
    ---                       11: 同 Sub5 但色 4 / 色 2
    ---      4 (Sub16, Sub17) 16: 32 根 ins_147（型12, 色1, 角=自机+k×11.25°, 长512, 宽12,
    ---                            四段 20/10/30/10, 角速度 0, 不跟随）每 30 帧
    ---                       17: **只有** FAN(型3, 色2, 7发, 速5, 自机, 步0.101342) 每 10 帧
    ---      5 (Sub20, Sub21) 20: 同 Sub13 但色6、速4
    ---                       21: 3×[FAN(型3, 色13, 1发, 速=3.5+rand×1.5,
    ---                            角=自机−22.5°+rand×45°, 步0.392699)] + FAN(型13,色6,24发,速6,
    ---                            自机+π, 步0.241661) 每 10 帧
    ---      6 (Sub23, Sub24) 23: 同 Sub13 但色7、速5
    ---                       24: 4×[FAN(型3, 色15, 1发, 速=3.5+rand×2.5, 角同上)] + 上面那组 24 发
    ---      7 (Sub26, Sub27) 26: 只算一个随机角、**不发弹**，每 4 帧
    ---                       27: floatV0 从 45° 起每轮 +6°，FAN(型3, 色2, 8发, 速3,
    ---                            角=floatV0, 步0.1309) + FAN(型18, 色0, 24发, 速6, 自机+π,
    ---                            步0.241661) 每 4 帧
    ---      8 (Sub29, Sub30) 29: 同 Sub26（不发弹）
    ---                       30: floatV0 从 135° 起每轮 −6°，FAN(型3, 色6, 8发, 速3.5,
    ---                            角=floatV0, 步0.136591) + FAN(型18, 色1, 24发, 速6, 自机+π,
    ---                            步0.241661) 每 4 帧
    ---      9 (Sub32, Sub33) 32: 同 Sub26（不发弹）
    ---                       33: floatV0 从 67.5° 起每轮 +6°，FAN(型3, 色2, 16发, 速3.5,
    ---                            角=floatV0, 步0.136591) + FAN(型18, 色1, 24发, 速6, 自机+π,
    ---                            步0.241661) 每 4 帧
    ---  · 型 3/18 半径 2/3 → ball_small；型 12/13 半径 5/6 → ball_mid。
    ---  · Sub4 的 @1292 是 `ins_26(floatV2, floatV0, 0.392699)` 再 `+= 0.19635`×2
    ---    ⇒ 相减相加后就是自机角本身（float32 上差 1e-6）；照抄会得到同样的角。
    ---  · Sub26/29/32 的角算完就丢（后面没有 ins_145/147），是原作留的空壳 ——
    ---    这里保留「每 4 帧空转」算子的位置，但不发弹。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 40, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 10                              -- ins_141(10)
    local CARD_NAME = "審判「十王裁判」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 473

    local BOX = { -140, 128, 140, 192 }                 -- ins_75 的活动框（TH095 空间）
    local ROUND = 180                                   -- Sub3 与九号波共用的一轮

    local SPREAD = math.deg(0.392699)                   -- 22.5°，1 发扇的随机半宽
    local FAN_STEP_A = math.deg(0.101342)               -- 7 发扇的步长
    local FAN_STEP_B = math.deg(0.241661)               -- 21/24 发扇的步长
    local FAN_STEP_C = math.deg(0.1309)                 -- 8 发扇的步长（7 号波）
    local FAN_STEP_D = math.deg(0.136591)               -- 8/16 发扇的步长（8/9 号波）
    local ROT_STEP = math.deg(0.10472)                  -- 6°/轮

    local lasers = {}
    local st = { dead = false }
    local fired = {}

    local function alive(tok)
        return not st.dead and (tok == nil or tok.alive)
    end

    ---Sub4：每 30 帧一根自机方向 145（型 12、色 3、速 4、长 96、宽 16）。
    local function laser_single(owner, tok, index, speed, jitter, period)
        task.New(owner, function()
            while alive(tok) do
                local a = sg_aim(owner.x, owner.y) + (jitter or 0)
                spawn_ex_laser_straight(owner, lasers, index, owner.x, owner.y,
                        -a, 96, 16, speed)
                task.Wait(period)
            end
        end)
    end

    ---五根 145：角 = 自机 −22.5° + k×11.25°、速 4/6/8/6/4（3 号波的 Sub10）。
    local function laser_five(owner, tok)
        local speeds = { 4, 6, 8, 6, 4 }
        task.New(owner, function()
            while alive(tok) do
                for k = 0, 4 do
                    local a = sg_aim(owner.x, owner.y) - SPREAD + k * SPREAD / 2
                    spawn_ex_laser_straight(owner, lasers, 2, owner.x, owner.y,
                            -a, 96, 16, speeds[k + 1])
                end
                task.Wait(15)
            end
        end)
    end

    ---32 根 147（4 号波的 Sub16，型 12、色 1、长 512、宽 12、四段 20/10/30/10）。
    local function laser_ring_147(owner, tok)
        task.New(owner, function()
            while alive(tok) do
                local base = sg_aim(owner.x, owner.y)
                for k = 0, 31 do
                    spawn_ex_laser(owner, lasers, 12, owner.x, owner.y,
                            -math.rad(base + k * 11.25), 512, 12, 8, 20, 10, 30, 10,
                            0, 0, 0, false, true)
                end
                task.Wait(30)
            end
        end)
    end

    ---ins_87 FAN 的一发（base_off 是以自机角为 0 的偏移，度）。
    local function fan(owner, tok, style, color, count, speed, base_off, step, period)
        task.New(owner, function()
            while alive(tok) do
                sg_shot(87, style, ex_color(color), owner.x, owner.y,
                        count, 1, speed, 1.5, sg_aim(owner.x, owner.y) + base_off,
                        step, false, 514)
                task.Wait(period)
            end
        end)
    end

    ---「小扇 + 大扇」组合：FAN(type3, 7 发) + FAN(type13, 21 发, 反方向)。
    local function fan_pair(owner, tok, small_color, big_color)
        task.New(owner, function()
            while alive(tok) do
                local a = sg_aim(owner.x, owner.y)
                sg_shot(87, ball_small, ex_color(small_color), owner.x, owner.y,
                        7, 1, 5, 1.5, a, FAN_STEP_A, false, 514)
                sg_shot(87, ball_mid, ex_color(big_color), owner.x, owner.y,
                        21, 1, 6, 1.5, a + 180, FAN_STEP_B, false, 514)
                task.Wait(10)
            end
        end)
    end

    ---「n 发 1 弹随机扇 + 24 发大扇」组合（5/6 号波的 B）。
    local function fan_random(owner, tok, n, dcolor, dspread, big_color)
        task.New(owner, function()
            while alive(tok) do
                local a = sg_aim(owner.x, owner.y)
                for _ = 1, n do
                    local sp = 3.5 + ran:Float(0, 1) * dspread
                    local ang = a - SPREAD + ran:Float(0, 1) * SPREAD * 2
                    sg_shot(87, ball_small, ex_color(dcolor), owner.x, owner.y,
                            1, 1, sp, 1.5, ang, SPREAD, false, 514)
                end
                sg_shot(87, ball_mid, ex_color(big_color), owner.x, owner.y,
                        24, 1, 6, 1.5, a + 180, FAN_STEP_B, false, 514)
                task.Wait(10)
            end
        end)
    end

    ---「旋转扇 + 24 发大扇」组合（7/8/9 号波的 B）。
    ---start 是 floatV0 的初值（度），drift 是每轮的增量（度，可正可负）。
    local function fan_spin(owner, tok, color, count, sp, step, start, drift, big_color)
        task.New(owner, function()
            local ang = start
            while alive(tok) do
                sg_shot(87, ball_small, ex_color(color), owner.x, owner.y,
                        count, 1, sp, 1.5, ang, step, false, 514)
                sg_shot(87, ball_small, ex_color(big_color), owner.x, owner.y,
                        24, 1, 6, 1.5, sg_aim(owner.x, owner.y) + 180, FAN_STEP_B, false, 514)
                ang = ang + drift
                task.Wait(4)
            end
        end)
    end

    ---7 号波的 A（Sub26）/ 8 号波的 A（Sub29）/ 9 号波的 A（Sub32）：只空转。
    local function noop_stream(owner, tok)
        task.New(owner, function()
            while alive(tok) do
                task.Wait(4)
            end
        end)
    end

    ---九号波的包装：清屏 → t=30 起一对弹幕 → t=150 走位 + 收尾 → 每 180 帧重来。
    local function wave(owner, a, b)
        task.New(owner, function()
            sg_clear(lasers)
            local ta, tb
            local function spawn()
                ta, tb = { alive = true }, { alive = true }
                a(owner, ta)
                b(owner, tb)
            end
            local function drop()
                if ta then ta.alive = false; ta = nil end
                if tb then tb.alive = false; tb = nil end
            end
            task.Wait(30)
            spawn()
            while true do
                task.Wait(120)                          -- t=30 → 150
                sg_bmove(owner, st, 60, 0, 1, BOX)      -- t=150（60 帧、60 px）
                drop()
                task.Wait(60)                           -- t=150 → 210
                spawn()                                 -- 跳回 t=30
            end
        end)
    end

    ---Sub3：默认主控（180 帧一轮，默认只用 Sub4/Sub5）。
    local function main_script(owner)
        task.New(owner, function()
            PlaySound("tan00", 0.1, owner.x / 256, false)   -- t=0 的 ins_106(5)
            local ta, tb = { alive = true }, { alive = true }
            laser_single(owner, ta, 3, 4, 0, 30)            -- Sub4
            fan_pair(owner, tb, 6, 3)                       -- Sub5
            while true do
                task.Wait(120)                              -- t=0 → 120
                sg_bmove(owner, st, 60, 0, 1, BOX)
                ta.alive = false; tb.alive = false
                task.Wait(60)                               -- t=120 → 180
                ta, tb = { alive = true }, { alive = true }
                laser_single(owner, ta, 3, 4, 0, 30)
                fan_pair(owner, tb, 6, 3)
            end
        end)
    end

    ---九条 ins_115：第 k 张 → 第 k 号波（A, B 见文件头清单）。
    local WAVES = {
        { function(o, t) laser_single(o, t, 3, 4, 0, 30) end,
          function(o, t) fan_pair(o, t, 6, 3) end },
        { function(o, t) laser_single(o, t, 4, 5, ran:Float(-SPREAD, SPREAD), 4) end,
          function(o, t) fan_pair(o, t, 8, 4) end },
        { laser_five,
          function(o, t) fan_pair(o, t, 4, 2) end },
        { laser_ring_147,
          function(o, t) fan(o, t, ball_small, 2, 7, 5, 0, FAN_STEP_A, 10) end },
        { function(o, t) laser_single(o, t, 6, 4, ran:Float(-SPREAD, SPREAD), 4) end,
          function(o, t) fan_random(o, t, 3, 13, 1.5, 6) end },
        { function(o, t) laser_single(o, t, 7, 5, ran:Float(-SPREAD, SPREAD), 4) end,
          function(o, t) fan_random(o, t, 4, 15, 2.5, 7) end },
        { noop_stream,
          function(o, t) fan_spin(o, t, 2, 8, 3, FAN_STEP_C, 45, ROT_STEP, 0) end },
        { noop_stream,
          function(o, t) fan_spin(o, t, 6, 8, 3.5, FAN_STEP_D, 135, -ROT_STEP, 1) end },
        { noop_stream,
          function(o, t) fan_spin(o, t, 2, 16, 3.5, FAN_STEP_D, 67.5, ROT_STEP, 1) end },
    }

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        fired = {}
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            main_script(self)
            task.New(self, function()                       -- ins_115 监视器
                while not st.dead do
                    local hits = photo_index(PHOTO_LIMIT)
                    for k = 1, #WAVES do
                        if hits >= k and not fired[k] then
                            fired[k] = true
                            wave(self, WAVES[k][1], WAVES[k][2])
                        end
                    end
                    task.Wait(1)
                end
            end)
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        sg_clear(lasers)
    end

    boss.card.add({ { card, "8a" } }, LEVEL, CARD_NAME, CARD_ID)
end--審判「十王裁判」

do  -- 94 古雨「黄泉中有の旅の雨」（ecl20_c，小町，组 7a 第 3 张）
    ---原作是「场地上缘下起黄泉之雨」：本体在**顶边那条窄带里**左右挪，所有雨点都从
    ---上缘随机位置（x∈[-192,192]、TH095 y∈[0,32]）往下飘；拍得越多雨越密。
    ---数据源 /tmp/S9_ecl20_c.txt（ECL …/data/ecl20_c.ecl）。骨架：
    ---  · Sub2：ins_55(2) + ins_81(3) + ins_109(0) + ins_77(24,24) + ins_141(7)（拍 7 张）
    ---    + ins_108(0,31)/ins_108(1,30) + ins_143(1,130) + ins_63(-128,-64) 进场
    ---    → t=100 ins_64(30,4,0,128) 落到 (0,128)（我们的 (0,96)）→ t=130 亮卡名
    ---    + ins_75(-128,128,128,128)（顶边窄带）+ ins_149(8) + ins_132(1) + ins_52(3)。
    ---  · Sub3（主控，128 帧一轮）：t=0 ins_106(5) + 117(7,8)（装饰）+ slot1 = Sub5
    ---    （自机狙雨点）+ slot0 = Sub4（斜落雨点）+ slot2 = Sub6 + slot3 = Sub7；
    ---    @884 起 ins_144(15) + ins_67(128,0,0.5)（128 帧、缓动 0、走 64 px）
    ---    → t=128 ins_4(0,-40) 跳回 @884。⇒ 一轮 128 帧、每轮只在顶边挪一段。
    ---  · Sub4（每 2 帧，ins_4(0,-576)）：先算出膛点 —— floatV0 = randS×192、
    ---    floatV1 = randF32×32，再用 ins_26/ins_100 得到世界坐标 (randS×192, randF32×32)
    ---    ——就是场地上缘；然后 ins_87 FAN(型3、色6、1 发、速 = 1+randF32、角 = 1.1781
    ---    + randF32×0.785398)。t=1 的 `ins_44(photoIndex, 6, 1, 296)` 是 **CMPlt**：
    ---    photoIndex < 6 就跳过第二块 ⇒ **拍到第 6 张起**每 2 帧再多一颗（色 4、速 1..2.5）。
    ---  · Sub5（每 4 帧）：同样从顶边随机点出发，ins_86 FAN_AIMED(型3、色8、1 发、
    ---    速 = 2 + randF32×2、ang = 0) ⇒ 每 4 帧一颗**朝自机**的雨点。
    ---    （@1712 的 floatV0 = rand×0.314159 算完没人用，是原作的死代码，照抄不算。）
    ---  · Sub6（一轮 121 帧）：每帧一颗 ins_89 CIRCLE（型23、色0、1 发、速 = floatV0 +
    ---    0.15×i、基角 playerAngle、出膛点 = 本体），共 24 颗（ins_5(0,-144,24)）；
    ---    @1972 的 `ins_44(photoIndex, 3, 0, 72)` 闸 ⇒ **拍到第 3 张起才有**。
    ---    发完到 t=121 才跳回 t=0 ⇒ 每轮 24 颗 + 97 帧空档。
    ---  · Sub7（一轮 61 帧）：每帧一组 ins_87 FAN(型23、色1、3 发、速 = floatV0 +
    ---    0.15×i、基角 playerAngle、步长 0.392699)，共 12 组；@2236 的闸是
    ---    `ins_44(photoIndex, 5, 0, 72)` ⇒ **拍到第 5 张起才有**。
    ---  · Sub8（slot 7：t=120..135 把 shootOffset 摆到屏幕外三角 + ins_150(10)）是装饰
    ---    ANM；Sub0/Sub1 死亡/退场 ⇒ 不实现。
    ---  · 型 3/23 都是直径 6/4 ⇒ ball_small。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 7                               -- ins_141(7)
    local CARD_NAME = "古雨「黄泉中有の旅の雨」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 474

    local BOX = { -128, 128, 128, 128 }                 -- ins_75 的顶边窄带（TH095 空间）
    local MOVE_FRAMES, MOVE_SPEED = 128, 0.5            -- ins_67(128,0,0.5) ⇒ 64 px

    local RAIN_X, RAIN_Y = 192, 32                      -- 上缘：x∈[-192,192]、y∈[0,32]
    local DROP_ANGLE0 = 1.1781                          -- 67.5°（TH095，y 朝下）
    local DROP_ANGLE_RND = 0.785398                     -- ±22.5°
    local DROP_SPEED0, DROP_SPEED_RND = 1, 1            -- 色 6：1 + rand×1
    local DROP2_SPEED_RND = 1.5                         -- 色 4（第 6 张起）：1 + rand×1.5
    local AIM_SPEED0, AIM_SPEED_RND = 2, 2              -- 色 8：2 + rand×2
    local RING_COUNT, RING_SPEED_STEP = 24, 0.15        -- Sub6
    local RING_PERIOD = 121
    local FAN_BURST, FAN_COUNT, FAN_PERIOD = 12, 3, 61  -- Sub7
    local GATE_RING, GATE_FAN, GATE_DROP2 = 3, 5, 6     -- 各闸的 photoIndex 门槛

    local lasers = {}
    local st = { dead = false }

    ---顶边的随机出膛点（TH095 坐标 → 我们的坐标）。
    local function rain_point()
        return ran:Float(-1, 1) * RAIN_X, field_y(ran:Float(0, 1) * RAIN_Y)
    end

    ---Sub4：每 2 帧一颗斜落雨点；第 6 张起每轮再多一颗（色 4）。
    local function sub4(owner, tok)
        task.New(owner, function()
            while not st.dead and tok.alive do
                local x, y = rain_point()
                sg_shot(87, ball_small, ex_color(6), x, y, 1, 1,
                        DROP_SPEED0 + ran:Float(0, 1) * DROP_SPEED_RND, 0.5,
                        math.deg(DROP_ANGLE0 + ran:Float(0, 1) * DROP_ANGLE_RND), 0, false, 514)
                if photo_index(PHOTO_LIMIT) >= GATE_DROP2 then
                    local x2, y2 = rain_point()
                    sg_shot(87, ball_small, ex_color(4), x2, y2, 1, 1,
                            DROP_SPEED0 + ran:Float(0, 1) * DROP2_SPEED_RND, 0.5,
                            math.deg(DROP_ANGLE0 + ran:Float(0, 1) * DROP_ANGLE_RND), 0, false, 514)
                end
                task.Wait(2)
            end
        end)
    end

    ---Sub5：每 4 帧一颗朝自机的雨点（色 8）。
    local function sub5(owner, tok)
        task.New(owner, function()
            while not st.dead and tok.alive do
                local x, y = rain_point()
                sg_shot(86, ball_small, ex_color(8), x, y, 1, 1,
                        AIM_SPEED0 + ran:Float(0, 1) * AIM_SPEED_RND, 0.5, 0, 0, true, 514)
                task.Wait(4)
            end
        end)
    end

    ---Sub6：每帧一颗自机方向小玉、共 24 颗，然后空转 97 帧（一轮 121）。
    local function sub6(owner, tok)
        task.New(owner, function()
            while not st.dead and tok.alive do
                local sp = 0.5
                for _ = 1, RING_COUNT do
                    if not tok.alive or st.dead then return end
                    if photo_index(PHOTO_LIMIT) >= GATE_RING then
                        sg_shot(89, ball_small, ex_color(0), owner.x, owner.y, 1, 1,
                                sp, 0.5, sg_aim(owner.x, owner.y), 0, false, 514)
                    end
                    sp = sp + RING_SPEED_STEP
                    task.Wait(1)
                end
                task.Wait(RING_PERIOD - RING_COUNT)
            end
        end)
    end

    ---Sub7：每帧一组 3 发扇、共 12 组，然后空转 49 帧（一轮 61）。
    local function sub7(owner, tok)
        task.New(owner, function()
            while not st.dead and tok.alive do
                local sp = 1
                for _ = 1, FAN_BURST do
                    if not tok.alive or st.dead then return end
                    if photo_index(PHOTO_LIMIT) >= GATE_FAN then
                        sg_shot(87, ball_small, ex_color(1), owner.x, owner.y,
                                FAN_COUNT, 1, sp, 0.5, sg_aim(owner.x, owner.y),
                                math.deg(0.392699), false, 514)
                    end
                    sp = sp + RING_SPEED_STEP
                    task.Wait(1)
                end
                task.Wait(FAN_PERIOD - FAN_BURST)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub3 的 t=0。
            PlaySound("tan00", 0.1, self.x / 256, false)
            local tok = { alive = true }
            sub4(self, tok)
            sub5(self, tok)
            sub6(self, tok)
            sub7(self, tok)
            while tok.alive and not st.dead do
                sg_bmove(self, st, MOVE_FRAMES, 0, MOVE_SPEED, BOX)    -- @884
                task.Wait(MOVE_FRAMES)                                  -- t=128 跳回 @884
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        sg_clear(lasers)
    end

    boss.card.add({ { card, "7a" } }, LEVEL, CARD_NAME, CARD_ID)
end--古雨「黄泉中有の旅の雨」

do  -- 95 審判「ギルティ・オワ・ノットギルティ」（ecl21_c，映姬，组 8a 第 3 张）
    ---原作是「宣判」：本体的主循环每 180 帧交替「装饰 → 一束激光齐射」，另有一条
    ---**一直挂着**的子上下文，每 20 帧按拍照进度扇形甩出大玉。
    ---数据源 /tmp/S9_ecl21_c.txt（ECL …/data/ecl21_c.ecl）。骨架：
    ---  · Sub2：ins_55(2) + ins_81(3) + ins_109(0) + ins_77(24,24) + ins_141(6)（拍 6 张）
    ---    + ins_108(0,31)/ins_108(1,30) + ins_143(1,130) + ins_63(-128,-64) 进场
    ---    → t=100 ins_64(30,4,0,128) 落到 (0,128)（我们的 (0,96)）→ t=130 亮卡名
    ---    + ins_75(-128,128,192,128) + ins_149(3) + ins_132(1) + ins_52(3) 起 Sub3。
    ---  · Sub3（180 帧一轮）：t=0 117(1,5)（slot1 = Sub5，**只建这一次**）+ 117(0,6)
    ---    （装饰，不实现）→ t=60 把 slot0 换成 Sub4（激光）→ t=180 ins_4(0,-56) 跳回
    ---    @780（那是 t=0 的 117(0,6)）⇒ 之后每轮 t=0 只重建装饰、t=60 再放一次激光。
    ---  · Sub4（@868，20 帧后自灭：最后一句是 ins_53）：t=0 取 extraFloatV2 = playerAngle、
    ---    floatV0 = 自机角 + 67.5°、floatV1 = 自机角 − 67.5°，各放一根 ins_147
    ---    （型1、色 2 / 色 6、长 512、宽 16、四段 40/20/60/10、角速度 0、follow = 1）；
    ---    t=4/8/12 各把 floatV0 再 +22.5°、floatV1 再 −22.5°、各再放一根
    ---    ⇒ 共 8 根细激光，角度是 自机角 ± {67.5°, 90°, 112.5°, 135°}；
    ---    t=20 再放一根**宽 96** 的粗激光（色 4），角度是 t=0 时的自机角（@1520/1532/1556/
    ---    1604/1632 那一串比较只在归一化 floatV2，结果没人用 —— 原作死代码，照抄不算）。
    ---  · Sub5（@1732，每 20 帧一轮）：t=180 先把 extraFloatV2 置 −90°；循环体在 t=180：
    ---    intV0 = photoIndex − 2，然后 4 组 ins_86 FAN_AIMED（型 17 = 直径 28 的大玉、
    ---    count1 = intV0、速 3、步长 0.418879），基角依次是
    ---      A、−A、A+3.6°+180°、−(A+3.6°+180°)，颜色 1/0/1/0；
    ---    每轮 A 累加 7.2°（@1888 与 @2044 各 +3.6°、@2064 ins_37 归一化）。
    ---    intV0 = photoIndex − 2 ⇒ **拍不满 2 张时一发不出**（PHOTO_LIMIT = 6 ⇒ 最多 4 发/组）。
    ---  · Sub6（每帧 106(5) + 150(8)）是装饰 ANM；Sub0/Sub1 死亡/退场 ⇒ 不实现。
    ---    （本卡 Sub3 的 t=0 没有 ins_106(5)，响指音在装饰上下文里 ⇒ 本卡刻意不放音效。）
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "審判「ギルティ・オワ・ノットギルティ」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 475

    local CYCLE = 180                                   -- Sub3 的 ins_4(0,-56)
    local BEAM_AT = 60                                  -- Sub3 的 t=60
    local BEAM_LEN, BEAM_W, BEAM_WIDE = 512, 16, 96
    local BEAM_STARTUP, BEAM_GROW, BEAM_SUSTAIN, BEAM_FADE = 40, 20, 60, 10
    local BEAM_OFF0, BEAM_OFF_STEP = math.deg(1.1781), math.deg(0.392699)  -- 67.5° / 22.5°

    local FAN_START = -90                               -- Sub5 的 extraFloatV2 初值（TH095 度）
    local FAN_STEP = math.deg(0.418879)                 -- 24°
    local FAN_SPIN = math.deg(0.0628319)                -- 3.6°/次（每轮两次）
    local FAN_SPEED = 3
    local FAN_WAIT = 20
    local FAN_FIRST = 180                               -- 第一条在 t=180

    local lasers = {}
    local st = { dead = false }

    ---Sub4：一次 8 根细 147 + 1 根宽 96 的齐射（20 帧后自己结束）。
    local function sub4(owner)
        task.New(owner, function()
            local base = sg_aim(owner.x, owner.y)       -- extraFloatV2 = playerAngle
            for k = 0, 3 do
                local off = BEAM_OFF0 + k * BEAM_OFF_STEP
                spawn_ex_laser(owner, lasers, 2, owner.x, owner.y, -(base + off),
                        BEAM_LEN, BEAM_W, 8, BEAM_STARTUP, BEAM_GROW, BEAM_SUSTAIN,
                        BEAM_FADE, 0, 0, 0, true, true)
                spawn_ex_laser(owner, lasers, 6, owner.x, owner.y, -(base - off),
                        BEAM_LEN, BEAM_W, 8, BEAM_STARTUP, BEAM_GROW, BEAM_SUSTAIN,
                        BEAM_FADE, 0, 0, 0, true, true)
                if k < 3 then
                    task.Wait(4)
                end
            end
            task.Wait(8)                                -- t=12 → t=20
            spawn_ex_laser(owner, lasers, 4, owner.x, owner.y, -base,
                    BEAM_LEN, BEAM_WIDE, 8, BEAM_STARTUP, BEAM_GROW, BEAM_SUSTAIN,
                    BEAM_FADE, 0, 0, 0, true, true)
        end)
    end

    ---Sub5：每 20 帧四组大玉扇（组数 = photoIndex − 2）。
    local function sub5(owner, tok)
        task.New(owner, function()
            local a = FAN_START
            task.Wait(FAN_FIRST)
            while tok.alive and not st.dead do
                local n = photo_index(PHOTO_LIMIT) - 2
                if n > 0 then
                    sg_shot(86, ball_huge, ex_color(1), owner.x, owner.y,
                            n, 1, FAN_SPEED, 1.5, a, FAN_STEP, true, 514)
                    sg_shot(86, ball_huge, ex_color(0), owner.x, owner.y,
                            n, 1, FAN_SPEED, 1.5, -a, FAN_STEP, true, 514)
                    local b = a + FAN_SPIN
                    sg_shot(86, ball_huge, ex_color(1), owner.x, owner.y,
                            n, 1, FAN_SPEED, 1.5, b + 180, FAN_STEP, true, 514)
                    sg_shot(86, ball_huge, ex_color(0), owner.x, owner.y,
                            n, 1, FAN_SPEED, 1.5, -(b + 180), FAN_STEP, true, 514)
                    a = b + FAN_SPIN
                else
                    a = a + FAN_SPIN * 2                    -- 空转也要累加（原作先算后判）
                end
                task.Wait(FAN_WAIT)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub3 的 t=0：slot1 = Sub5 只建这一次。
            local tok = { alive = true }
            sub5(self, tok)
            while tok.alive and not st.dead do
                -- t=0：slot0 = Sub6（装饰，不实现）
                task.Wait(BEAM_AT)                          -- t=0 → 60
                if not tok.alive or st.dead then return end
                sub4(self)                                  -- t=60：slot0 = Sub4
                task.Wait(CYCLE - BEAM_AT)                  -- t=60 → 180（跳回 t=0）
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        sg_clear(lasers)
    end

    boss.card.add({ { card, "8a" } }, LEVEL, CARD_NAME, CARD_ID)
end--審判「ギルティ・オワ・ノットギルティ」

do  -- 96 死価「プライス・オブ・ライフ」（ecl20_d，小町，组 7a 第 4 张）
    ---原作是「标价」：本体先不动，拍满 2 张之后才开始**慢慢朝自机走**（0.3 px/帧、
    ---方向每 2 帧重取）；两条一样的子上下文在**自机上下各 80 px 处**吐「先停再倒着飘」
    ---的慢弹，另一条每 100 帧甩一圈会**撞墙反弹**的弹。
    ---数据源 /tmp/S9_ecl20_d.txt（ECL …/data/ecl20_d.ecl）。骨架：
    ---  · Sub2：ins_55(2) + ins_81(3) + ins_109(0) + ins_77(24,24) + ins_141(6)（拍 6 张）
    ---    + ins_108(0,31)/ins_108(1,30) + ins_143(1,130) + ins_63(-128,-64) 进场
    ---    → t=100 ins_64(30,4,0,192) 落到 (0,192)（我们的 (0,32)）→ t=130 亮卡名
    ---    + ins_149(6) + ins_132(1) + ins_52(3)。**没有 ins_75**（这一张没有活动框）。
    ---  · Sub3（@696）：t=0 ins_106 装饰句不实现 + 117(0,5)（装饰）→ t=60 先把
    ---    extraFloatV2 = −90°、floatV2 = 3°、intV0 = 1 写进父变量区，再 117(0,4)
    ---    ⇒ slot0 的 Sub4 拿到「−90° / 色 1」；然后 extraFloatV2 = +90°、intV0 = 2、
    ---    117(1,4) ⇒ slot1 的 Sub4 拿到「+90° / 色 2」；再 117(2,6)。
    ---    （ins_117 会把父上下文整份变量区 memcpy 给子上下文 —— 同卡 102 的注释。）
    ---    @928 的 `ins_44(photoIndex, 2, 60, 48)` 是 CMPlt：photoIndex < 2 就绕回 @928
    ---    **每帧只重查一次、原地空转**；够 2 张才 @956 跳到 t=61 开始
    ---    ins_65(playerAngle, 0.3) + @1016 每 2 帧回跳 ⇒ 一直慢慢追着自机走。
    ---  · Sub4（每 2 帧一轮，@1068/@1500）：出膛点 = **自机位置** + 80 px（方向 extraFloatV2）
    ---    —— @1148 的 ins_38 是 (cos,sin)×80，@1176/@1196 再加 player.x/y，@1216/@1240
    ---    再减本体位置当 shootOffset ⇒ 世界坐标就是「自机 ± 上下 80 px」；
    ---    然后 ins_89 CIRCLE（型23、色 intV0、1 发、速 0.2、基角 extraFloatV2、步长 π/2）。
    ---    弹上挂着两条 ins_101（@1068 是 slot0 kind 0x8000 = WAIT、i0 = 20；
    ---    @1108 是 slot1 kind 0x10 = VEC_ACCEL、i0 = 60、f0 = −0.05、f1 = −999）
    ---    ⇒ 前 20 帧不动，随后 60 帧每帧 speed −= 0.05（0.2 → −2.8），弹会**先停住再倒着飘**。
    ---    flags 33298 = 0x8212 = 0x8000 + 0x200(出场音) + 0x10 + 0x2。
    ---    @1328/@1356 两个 CMPlt 闸：photoIndex ≥ 4 且 intV1 ≥ 50（即每 100 帧一次）时，
    ---    在同一个出膛点再甩一圈 10 发（型23、色1、速0.8、基角 rand(−π,π)、步长 π/2）
    ---    并把 intV1 清零；否则 intV1 每轮 +1。
    ---    收尾 extraFloatV2 += 3°（@1464）再 ins_37 归一化（@1484）。
    ---  · Sub6（每 100 帧一轮，@1700/@1836）：弹上挂 ins_101(0, 0x400 BOUNCE_ALL, 999 次,
    ---    速取当前值) ⇒ 会从场地左右/上沿弹回来；@1764 的闸是 `photoIndex ≥ 2`，
    ---    够 2 张才甩一圈 16 发（型23、色0、速1、基角 rand(−π,π)）。
    ---  · Sub5（每帧 106(5) + 150(8)）是装饰 ANM；Sub0/Sub1 死亡/退场 ⇒ 不实现。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "死価「プライス・オブ・ライフ」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 476

    local CHASE_AT = 2                                  -- ins_44(photoIndex, 2)
    local CHASE_SPEED = 0.3                             -- ins_65(playerAngle, 0.3)

    local RING_SPAWN_GAP = 80                           -- ins_38 的半径
    local BULLET_WAIT, BULLET_ACCEL_FRAMES = 20, 60     -- 两条 ins_101 的 int0
    local BULLET_SPEED0, BULLET_ACCEL_STEP = 0.2, 0.05  -- sp1 / f0（原作是 −0.05）

    local BIG_AT, BIG_COUNT, BIG_SPEED = 4, 10, 0.8     -- 第二个 CMPlt / 10 发圈 / 速
    local BIG_EVERY = 50                                -- intV1 ≥ 50（每 100 帧）

    local BOUNCE_AT, BOUNCE_COUNT, BOUNCE_SPEED = 2, 16, 1
    local BOUNCE_PERIOD = 100

    local lasers = {}
    local st = { dead = false }

    ---Sub4 的逐帧钩子：前 20 帧不动，之后 60 帧每帧 speed −= 0.05（方向仍取弹自己的 rot）。
    local function accel_hook(self)
        local n = (self.ex_wait or 0) + 1
        self.ex_wait = n
        if n <= BULLET_WAIT then return end
        if (self.ex_accel or 0) >= BULLET_ACCEL_FRAMES then return end
        self.ex_accel = (self.ex_accel or 0) + 1
        local v = (self.ex_v or BULLET_SPEED0) - BULLET_ACCEL_STEP
        self.ex_v = v
        object.SetV(self, v, self.rot, true)
    end

    ---Sub4：每 2 帧从「自机 ± 方向 base 上 80 px」处吐一颗倒着飘的慢弹。
    ---base0 是 TH095 空间的度（slot0 = −90°、slot1 = +90°）。
    local function sub4(owner, tok, base0)
        task.New(owner, function()
            local base = base0
            local n = 0
            while tok.alive and not st.dead do
                local sx = player.x + RING_SPAWN_GAP * cos(-base)
                local sy = player.y + RING_SPAWN_GAP * sin(-base)
                local color = (base0 > 0) and 2 or 1
                NewSimpleBullet(ball_small, ex_color(color), sx, sy, BULLET_SPEED0,
                        -base, false, 0, false, nil, nil, nil, accel_hook)
                PlaySound("tan00", 0.1, sx / 256, false)     -- flags 的 0x200
                if photo_index(PHOTO_LIMIT) >= BIG_AT and n >= BIG_EVERY then
                    local a0 = ran:Float(-math.pi, math.pi)
                    for i = 0, BIG_COUNT - 1 do
                        NewSimpleBullet(ball_small, ex_color(1), sx, sy, BIG_SPEED,
                                -math.deg(a0 + i * math.pi / 5), false, 0, false)
                    end
                    PlaySound("tan00", 0.1, sx / 256, false)
                    n = 0
                end
                n = n + 1
                base = base + 3                              -- floatV2 = 0.0523599 rad
                task.Wait(2)
            end
        end)
    end

    ---Sub6：每 100 帧（photoIndex ≥ 2 起）一圈 16 发**会撞墙**的弹。
    local function sub6(owner, tok)
        task.New(owner, function()
            while tok.alive and not st.dead do
                task.Wait(BOUNCE_PERIOD)
                if not tok.alive or st.dead then return end
                if photo_index(PHOTO_LIMIT) >= BOUNCE_AT then
                    local a0 = ran:Float(-math.pi, math.pi)
                    for i = 0, BOUNCE_COUNT - 1 do
                        NewSimpleBullet(ball_small, ex_color(0), owner.x, owner.y,
                                BOUNCE_SPEED, -math.deg(a0 + i * math.pi / 8),
                                false, 0, false, nil, true)      -- rebound = BOUNCE_ALL
                    end
                    PlaySound("tan00", 0.1, owner.x / 256, false)
                end
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            local tok = { alive = true }
            task.Wait(60)                                   -- Sub3 的 t=0 → t=60
            sub4(self, tok, -90)                            -- slot0
            sub4(self, tok, 90)                             -- slot1
            sub6(self, tok)                                 -- slot2
            while tok.alive and not st.dead do
                if photo_index(PHOTO_LIMIT) >= CHASE_AT then
                    for _ = 1, 2 do                         -- ins_65 每 2 帧重取一次方向
                        local a = Angle(self.x, self.y, player.x, player.y)
                        self.x = self.x + CHASE_SPEED * cos(a)
                        self.y = self.y + CHASE_SPEED * sin(a)
                        task.Wait(1)
                        if not tok.alive or st.dead then return end
                    end
                else
                    task.Wait(1)
                end
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        sg_clear(lasers)
    end

    boss.card.add({ { card, "7a" } }, LEVEL, CARD_NAME, CARD_ID)
end--死価「プライス・オブ・ライフ」

do  -- 97 審判「浄頗梨審判　-射命丸文-」（ecl21_d，映姬，组 8a 第 4 张）
    ---映姬这张符卡是「本体在活动框里打点射」+「拍够照片后本体改成沿左右边缘上下扫」的两段式。
    ---数据源 /tmp/S9_ecl21_d.txt（ECL …/data/ecl21_d.ecl）。骨架：
    ---  · Sub2：ins_55(2) + ins_81(3) + ins_109(0) + ins_77(24,24) + ins_141(9)（拍 9 张）
    ---    + ins_108(0,31)/ins_108(1,30) + ins_143(1,9000) + ins_63(-128,-64) 进场；
    ---    **ins_115(0,3,7)** / **ins_115(1,6,8)** 是整张卡的分段开关。ins_115 在
    ---    EnemyManagerUpdate.cpp:1283-1300 里做的是
    ---    `TH095_PHOTO_ECL_INIT(..., &enemy->mainEclContext, subId)`，
    ---    即**把本体的主 ECL 整个重启到另一个 sub**（不是新开并行上下文）；比较的帧号是
    ---    g_PhotoEnemyGame->frameCounter = camera.photoIndex ⇒「拍中第 3 张时本体切成 Sub7、
    ---    拍中第 6 张时切成 Sub8」，Sub3 随之被丢弃。
    ---    t=100 ins_64(30,4,0,128) 落到 (0,128)（我们的 (0,96)）；t=130 停 ANM + ins_132(1)
    ---    + ins_52(3)（同步调用 Sub3；Sub3 自带 ins_4(90,-1168) 死循环 ⇒ 本体此后一直跑 Sub3）。
    ---  · Sub3（@708 起，跳回 @1036 的 t=90 ⇒ **742 帧一轮**）：
    ---      t=90  ins_75(-128,96,128,144) 设活动框 + ins_143(0,0) + 起装饰上下文 Sub6
    ---      t=150/200/250 各起一次 Sub4，每次只活 30 帧（t=180/230/280 被 ins_117(0,-1) 杀掉）；
    ---            同一刻 ins_67(30,4,5) 让本体在框里「背离自机」随机走 30 帧 × 5 px
    ---      t=340/380/420 三次：ins_76 清框 → ins_88 CIRCLE_AIMED 48 发自机狙整圈（速 2）
    ---            → ins_64(40,4,player.x,player.y) 用 40 帧贴向自机（非阻塞，每 40 帧重取目标）
    ---      t=520 起 Sub5（活到 t=610，共 90 帧）
    ---      t=670/710/750 三次：ins_86 FAN_AIMED 4 组 × 8 颗自机狙扇（速 6→1、步长 5.625°）
    ---            → 继续贴向自机
    ---      t=790 ins_64(40,4,0,144) 回场中 → t=830 重新设框 → t=832 跳回 t=90
    ---  · Sub4（@2236，每 2 帧一轮、**一直转**直到被 ins_117 杀掉）：
    ---      a) ins_89 CIRCLE(型 7=ball_small、色 2、count1=1、count2=10、速 8→1、
    ---         角 = **Sub4 启动那一刻**的 playerAngle —— 操作数 pm=0040 是 float 变量，
    ---         循环里不再重取）⇒ 每 2 帧沿一条固定射线吐 10 颗「同向不同速」的弹。
    ---      b) ins_88 CIRCLE_AIMED(型 7、色 2、count1=6、count2=1、速 2、基准 π、
    ---         步长 11.25°)⇒ 6 颗**背对自机**的弹（自机角 + 180° + k·60°）。
    ---      c) 夹在 a) 与 b) 之间的 ins_101(0, 0x80 CHDIR_AIMED, allow=0, i0=30, i1=1,
    ---         f0=rand(−π,π)·16, f1=6)：弹是**发弹那一刻**把 transform 槽整份抄走的
    ---         （BulletManager.cpp:484 的 memcpy），所以只有后面那组 b) 抄到了它；
    ---         而 b) 的 flags=642=0x282 里含 0x80、a) 的 flags=514=0x202 里没有 ⇒
    ---         只有 b) 会真的吃这条变换（BulletManager.cpp:523 的
    ---         `(transformFlags & record->kind) == 0` 闸）。效果见
    ---         BulletManager.cpp:929-965 UpdateAimedDirectionChange：此后 30 帧速度从 2 线性
    ---         降到 0（方向不变），第 31 帧把角改成 playerAngle(弹的位置)+f0、速度改成 6
    ---         再飞出去。
    ---  · Sub5（@2452，每 4 帧一轮、活 90 帧）：ins_89 CIRCLE(型 15=ball_mid、色 1、
    ---      count1=32、速 4、角 = floatV0)。floatV0 在 **Sub5 启动那一刻**取 playerAngle，
    ---      之后每轮 +5.625°（ins_15 后接 ins_37）⇒ 32 发整圈每 4 帧转 5.625°。
    ---      （Sub5 自己的 ins_101 写的也是 0x80，但 89 的 flags 里没有 0x80 ⇒ 不生效。原作死数据。）
    ---  · Sub7（@2732，拍中第 3 张后接管本体）：ins_102 清屏 → 40 帧落到 (0,144) →
    ---      循环（t=60..142，82 帧）：floatV0 += rand·floatV1，出 [64,448] 就翻向；
    ---      ins_64(30,4,∓192,floatV0) 30 帧横移到左/右边缘；ins_94 RANDOM(型 7、色 2、
    ---      count1=32、速 0.5..2、角 ∈ [90°,270°]) 撒 32 颗。
    ---      ⇒ 本体贴着左右边缘上下扫，每次到边撒一把（第一把在 (0,144)）。
    ---  · Sub8（@3500，拍中第 6 张后接管本体）：ins_102 → 40 帧落到 (0,144) →
    ---      循环（t=60..310，250 帧）：t=120 起 Sub5 90 帧 → t=270 ins_64(40,4,自机) 贴向
    ---      自机 40 帧 → 回 t=60。
    ---  · Sub6/Sub9 是装饰 ANM 与进场子机；Sub0/Sub1 是死亡/退场 ⇒ 不实现（见文件头差异 3）。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- (0,128) → (0,96)
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 9                               -- ins_141(9)
    local CARD_NAME = "審判「浄頗梨審判　-射命丸文-」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 477

    local LOOP_AT = 90                                  -- Sub3 的 ins_4 跳回处（t=90）
    local BOX = { -128, 96, 128, 144 }                  -- ins_75(-128,96,128,144)
    local WALK_FRAMES, WALK_SPEED = 30, 5               -- ins_67(30,4,5)
    local DASH_FRAMES = 40                              -- ins_64(40,4,...)
    local EASE_INOUT = 4                                -- ins_64/67 的缓动编号

    local RUSH_COUNT, RUSH_SPEED = 48, 2                -- ins_88(…48,1,2,1,0,0,514)
    local FAN_GROUP, FAN_SPEED1, FAN_SPEED2 = 4, 6, 1   -- ins_86(…4,8,6,1,0,0.0981748,514)
    local FAN_STEP_DEG = 5.625                          -- 0.0981748 rad

    local RING_COUNT, RING_SPEED = 32, 4                -- Sub5 的 ins_89
    local RING_STEP_DEG = 5.625                         -- Sub5 每轮 +0.0981748 rad

    local SUB4_RAY_COUNT, SUB4_RAY_SPEED0, SUB4_RAY_SPEED1 = 10, 8, 1
    local SUB4_BACK_COUNT, SUB4_BACK_SPEED = 6, 2       -- Sub4 b) 的 ins_88
    local SUB4_BACK_STEP_DEG = 11.25                    -- 0.19635 rad
    local CHDIR_FRAMES, CHDIR_SPEED = 30, 6             -- ins_101 的 i0 / f1
    local SUB4_GAP = 2                                  -- Sub4 的 ins_4(0,-152)

    local BURST_COUNT, BURST_SPEED1, BURST_SPEED2 = 32, 2, 0.5   -- Sub7 的 ins_94
    local SPRAY_A = { 90, 270 }                         -- 到左边缘那一下：角 ∈ [90°,270°]
    local SPRAY_B = { -90, 90 }                         -- 到右边缘那一下：角 ∈ [−90°,90°]
    local SWEEP_SPEED_FRAMES = 30                       -- ins_64(30,4,∓192,…)
    local SWEEP_MIN, SWEEP_MAX, SWEEP_DELTA = 64, 448, 64

    local lasers = {}
    local st = { dead = false }
    local gen = 0                                       -- 本体当前主脚本代号（ins_115 会 +1）
    local fired = { false, false }

    local function alive(g, tok)
        return g == gen and not st.dead and (tok == nil or tok.alive)
    end

    local function kill_move()
        if st.mv then
            st.mv.alive = false
            st.mv = nil
        end
    end

    ---ins_64 的逐帧插值（非阻塞；这里和调用者在同一条协程里顺序走完）。
    local function glide(owner, g, tx, ty, n)
        local x0, y0 = owner.x, owner.y
        local f = sg_ease(EASE_INOUT)
        for s = 1, n do
            if not alive(g) then return false end
            local p = f(s / n)
            owner.x, owner.y = x0 + p * (tx - x0), y0 + p * (ty - y0)
            task.Wait(1)
        end
        return true
    end

    ---Sub4 c)：CHDIR_AIMED 的逐帧钩子。f0_deg 是 TH095 空间的角度（度）。
    ---第 1..30 帧速度从 2 线性降到 0（方向不变），第 31 帧重新瞄准自机 + f0、速度 6。
    local function chdir_hook(f0_deg)
        return function(self)
            local n = (self.ex_chdir or 0) + 1
            self.ex_chdir = n
            if n <= CHDIR_FRAMES then
                local v = SUB4_BACK_SPEED * (1 - (n - 1) / CHDIR_FRAMES)
                object.SetV(self, v, self.rot, true)
            elseif n == CHDIR_FRAMES + 1 then
                local a = Angle(self.x, self.y, player.x, player.y) - f0_deg
                object.SetV(self, CHDIR_SPEED, a, true)
            end
        end
    end

    ---Sub4：每 2 帧一轮的两组点射（见块顶注释 a/b/c）。
    local function sub4(owner, g, tok)
        task.New(owner, function()
            local aim = sg_aim(owner.x, owner.y)
            while alive(g, tok) do
                sg_shot(89, ball_small, ex_color(2), owner.x, owner.y,
                        1, SUB4_RAY_COUNT, SUB4_RAY_SPEED0, SUB4_RAY_SPEED1,
                        aim, 0, false, 514)
                local f0 = math.deg(ran:Float(-math.pi, math.pi) * 16)
                local a0 = sg_aim(owner.x, owner.y) + 180
                for i = 0, SUB4_BACK_COUNT - 1 do
                    NewSimpleBullet(ball_small, ex_color(2), owner.x, owner.y,
                            SUB4_BACK_SPEED, -(a0 + i * (360 / SUB4_BACK_COUNT)),
                            false, 0, false, nil, nil, nil, chdir_hook(f0))
                end
                PlaySound("tan00", 0.1, owner.x / 256, false)   -- flags 642 的 0x200
                task.Wait(SUB4_GAP)
            end
        end)
    end

    ---Sub5：每 4 帧一圈 32 发，基准角每轮 +5.625°。
    local function sub5(owner, g, tok)
        task.New(owner, function()
            local base = sg_aim(owner.x, owner.y)
            while alive(g, tok) do
                sg_shot(89, ball_mid, ex_color(1), owner.x, owner.y,
                        RING_COUNT, 1, RING_SPEED, 1, base, 0, false, 514)
                base = base + RING_STEP_DEG
                task.Wait(4)
            end
        end)
    end

    ---Sub7 的一把 32 发 RANDOM：base/step 就是原作的 angle/angleStep（TH095 度）。
    local function burst(owner, base_deg, step_deg)
        sg_shot(94, ball_small, ex_color(2), owner.x, owner.y,
                BURST_COUNT, 1, BURST_SPEED1, BURST_SPEED2, base_deg, step_deg,
                false, 514)
    end

    ---Sub7：接管本体后贴左右边缘上下扫，到边撒一把（见块顶注释）。
    local function run_sub7(owner, g)
        task.New(owner, function()
            sg_clear(lasers)
            if not glide(owner, g, 0, field_y(144), DASH_FRAMES) then return end
            task.Wait(20)                                   -- t=40 → t=60
            local v0, v1 = 144, SWEEP_DELTA
            while alive(g) do
                v0 = v0 + ran:Float(0, 1) * v1
                if v0 > SWEEP_MAX then v1 = -SWEEP_DELTA end
                if v0 < SWEEP_MIN then v1 = SWEEP_DELTA end
                PlaySound("tan00", 0.1, owner.x / 256, false)   -- ins_106(15)
                burst(owner, SPRAY_A[1], SPRAY_A[2])
                if not glide(owner, g, -192, field_y(v0), SWEEP_SPEED_FRAMES) then return end
                task.Wait(10)                                   -- t=60 → t=100
                if not alive(g) then return end
                v0 = v0 + v1
                v0 = v0 + ran:Float(0, 1) * v1
                if v0 > SWEEP_MAX then v1 = -SWEEP_DELTA end
                if v0 < SWEEP_MIN then v1 = SWEEP_DELTA end
                PlaySound("tan00", 0.1, owner.x / 256, false)
                burst(owner, SPRAY_B[1], SPRAY_B[2])
                if not glide(owner, g, 192, field_y(v0), SWEEP_SPEED_FRAMES) then return end
                task.Wait(12)                                   -- t=100 → t=142 → 回 t=60
            end
        end)
    end

    ---Sub8：接管本体后循环「Sub5 90 帧 → 贴向自机 40 帧」（见块顶注释）。
    local function run_sub8(owner, g)
        task.New(owner, function()
            sg_clear(lasers)
            if not glide(owner, g, 0, field_y(144), DASH_FRAMES) then return end
            task.Wait(20)                                   -- t=40 → t=60
            while alive(g) do
                local tok = { alive = true }
                task.Wait(60)                               -- t=60 → t=120
                if not alive(g) then tok.alive = false; return end
                sub5(owner, g, tok)
                task.Wait(90)                               -- t=120 → t=210
                tok.alive = false
                if not alive(g) then return end
                task.Wait(60)                               -- t=210 → t=270
                if not alive(g) then return end
                PlaySound("tan00", 0.1, owner.x / 256, false)   -- ins_106(15)
                glide(owner, g, player.x, player.y, DASH_FRAMES)     -- t=270 → t=310
            end
        end)
    end

    ---Sub3：默认主循环（742 帧一轮，见块顶注释）。
    local function run_sub3(owner, g)
        task.Wait(LOOP_AT)                                  -- Sub3 t=0 → t=90
        while alive(g) do
            local tok = { alive = true }
            task.Wait(60)                                   -- t=90 → t=150
            for k = 1, 3 do
                if not alive(g) then return end
                sub4(owner, g, tok)                         -- ins_117(0,4)
                sg_bmove(owner, st, WALK_FRAMES, EASE_INOUT, WALK_SPEED, BOX)
                task.Wait(WALK_FRAMES)                      -- → t=180 / 230 / 280
                tok.alive = false                           -- ins_117(0,-1)
                if k == 3 then break end
                task.Wait(20)                               -- → t=200 / 250
                tok = { alive = true }
            end
            if not alive(g) then return end
            task.Wait(60)                                   -- t=280 → t=340
            for _ = 1, 3 do                                 -- t=340 / 380 / 420
                if not alive(g) then return end
                sg_move(owner, st, player.x, player.y, DASH_FRAMES, sg_ease(EASE_INOUT))
                PlaySound("tan00", 0.1, owner.x / 256, false)   -- ins_106(15)
                sg_shot(88, ball_small, ex_color(6), owner.x, owner.y,
                        RUSH_COUNT, 1, RUSH_SPEED, 1, 0, 0, true, 514)
                task.Wait(DASH_FRAMES)
            end
            if not alive(g) then return end
            task.Wait(60)                                   -- t=460 → t=520
            local tok5 = { alive = true }
            sub5(owner, g, tok5)                            -- ins_117(0,5)
            task.Wait(90)                                   -- t=520 → t=610
            tok5.alive = false
            if not alive(g) then return end
            task.Wait(60)                                   -- t=610 → t=670
            for _ = 1, 3 do                                 -- t=670 / 710 / 750
                if not alive(g) then return end
                sg_move(owner, st, player.x, player.y, DASH_FRAMES, sg_ease(EASE_INOUT))
                PlaySound("tan00", 0.1, owner.x / 256, false)
                sg_shot(86, ball_small, ex_color(6), owner.x, owner.y,
                        FAN_GROUP, 8, FAN_SPEED1, FAN_SPEED2, 0, FAN_STEP_DEG, true, 514)
                task.Wait(DASH_FRAMES)
            end
            if not alive(g) then return end
            sg_move(owner, st, 0, field_y(144), DASH_FRAMES, sg_ease(EASE_INOUT))  -- t=790
            PlaySound("tan00", 0.1, owner.x / 256, false)
            task.Wait(DASH_FRAMES)                          -- → t=830
            task.Wait(2)                                    -- → t=832，回 t=90
        end
    end

    ---ins_115 的两条定时调用 → 主脚本切换（见块顶注释）。
    local function watch(owner)
        task.New(owner, function()
            while not st.dead do
                local hits = photo_index(PHOTO_LIMIT)
                if hits >= 3 and not fired[1] then
                    fired[1] = true
                    kill_move()
                    gen = gen + 1
                    run_sub7(owner, gen)
                elseif hits >= 6 and not fired[2] then
                    fired[2] = true
                    kill_move()
                    gen = gen + 1
                    run_sub8(owner, gen)
                end
                task.Wait(1)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        gen = gen + 1
        st.dead = false
        watch(self)
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            run_sub3(self, gen)
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        kill_move()
        photo_damage_off(self)
        sg_clear(lasers)
    end

    boss.card.add({ { card, "8a" } }, LEVEL, CARD_NAME, CARD_ID)
end--審判「浄頗梨審判　-射命丸文-」

---──────────────────── Stage 8（scene group 8 = world09）── 公共工具 ────────────────────
---下面八张卡（scene 80..87）共用 world09（永遠亭）与 enm18/19.anm。
---数据源是 /tmp/S8_ecl18_{a..d}.txt 与 /tmp/S8_ecl19_{a..d}.txt（ECL 在
---`[th095] …/data/ecl1{8,9}_*.ecl`，与 th095/src 对照着读），各卡注释里的「@地址」
---都指这几份 dump。色表 ex_color、ins_145/147 的激光工具、sg_shot / sg_move /
---sg_bmove 都在上面 Stage EX 与 Stage 9 两段里（同一套），这一段新加的只有
---ins_101 的「弹变换」。

---ins_101 的一条记录，对应 TH095 的 BulletTransformRecord
---（th095/src/BulletManager.hpp:15-60 的 payload 布局：float0/float1/int0/int1
---依次叠放，含义随 kind 变）。world09 用到的那几种：
---  0x10  ACCEL_VEC   f0 = 每帧加速度大小、f1 = 加速度方向（度；≤ −990 ⇒ 用弹当前角，原作用 −999.99）、i0 = 持续帧
---  0x20  ACCEL_POLAR f0 = 每帧速度增量、f1 = 每帧角度增量（弧度）、i0 = 持续帧
---  0x100 CHDIR_ABS   f0 = 到点后的角（弧度）、f1 = 到点后的速（−999 ⇒ 用当前速）、
---                    i0 = 间隔帧、i1 = 重复次数
---  0x400 BOUNCE_ALL  f0 = 反弹后速度（<0 ⇒ 用当前值）、i0 = 反弹次数上限
---  0x8000 WAIT       i0 = 原地等待的帧数（等完才轮到下一条记录）
---★ dump 工具会把 f0/f1 的语义标反（ecl18_a 的 @880 被标成 f0=−0.0614286 是「角度」）：
---  上面这张表是照 Payload union 的叠放 + BulletManager.cpp 的 Update* 读出来的。
---
---★★ 一个必须记住的坑：文件里有两套**不一样**的「变换 kind 编号」，别抄错：
---  · `src/PhotoBulletSpawnDescriptor.hpp:85` 的 PhotoBulletTransformKind —— **这才是真机
---    编译进 BulletManager.cpp 的那一套**（BulletManager.cpp:3 include 的是
---    PhotoBulletManager.hpp → PhotoBulletSpawnDescriptor.hpp）。WAIT = 0x8000、
---    SET_SPRITE = 0x4000、WRAP_X = 0x100000、SPAWN_CHILD_PATTERN = 0x400000、
---    JUMP = 0x2000000。**ECL 里的 operand 就是按这一套写的**（ecl14_a 的 @2540 写
---    「kind=32768、int0=20」＝等 20 帧，只有 0x8000 说得通）。
---  · `src/BulletManager.hpp:155` 的 BulletTransformKind 是**TH08 那边的**命名表
---    （多插了 ONLY_WHEN_PLAYER_YOUKAI/HUMAN 两位），WAIT 被写成 0x20000、
---    SPAWN_CHILD 写成 0x1000000 —— 和 ECL 数据对不上，**不要照它写**。
---    （EclRunTargetHigh.inl 只是 WriteInt 把 operand 存进 slot->kind，不解释它，
---    所以那份表命不命名都无所谓。）
---下面新增的五个都按 PhotoBulletSpawnDescriptor.hpp 的编号。
local SG_VEC, SG_POLAR, SG_CHDIR_A, SG_BOUNCE, SG_WAIT =
        0x10, 0x20, 0x100, 0x400, 0x8000
local SG_CHDIR_R, SG_BOUNCE_EB, SG_SET_SPRITE, SG_CHILD, SG_JUMP =
        0x40, 0x800, 0x4000, 0x400000, 0x2000000

---@param kind number 位掩码（同时也是「这条记录能不能被这颗弹吃」的判据，见 sg_tr_hook）
---@param allow number 操作数 2（allowWhileActive），world09 全是 0
local function sg_rec(kind, allow, i0, i1, f0, f1)
    return { kind = kind, allow = allow, i0 = i0, i1 = i1, f0 = f0, f1 = f1 }
end

---flags & kind ~= 0。flags 一直是 32 位掩码里的小值，整数除比拉 bit 库省事，
---也和上面 sg_snd 的写法一致（那里是 math.floor(flags / 0x200) % 2）。
local function sg_has(flags, kind)
    return math.floor(flags / kind) % 2 == 1
end

---TH095 的弧度角（或角增量）→ 我们的度，取反（见文件头「坐标系与角度」）。
local function sg_deg(th_rad)
    return -math.deg(th_rad)
end

---TH095 的弹变换程序（PhotoBulletView::AdvanceTransformProgram + 每帧 Update*，
---BulletManager.cpp:512-693 与 :1447-1470）。三条要点：
---  ① 发弹那一刻整份记录表被**抄给弹**（同文件 :486），所以「先 ins_101 写表、
---     紧接着 ins_86..94 发弹」是一对，写卡的顺序不能动；
---  ② flags 里没有的 kind 会被跳过（:525）；`kind == 0` 的记录（表尾的空槽）直接结束；
---  ③ 每应用一条就 transformIndex++（:694），而记录还在生效（active != 0）时
---     allow == 0 的后续记录会被挡住（:523）⇒ 表里的记录是**严格按顺序逐条生效**的。
---     0x8000 WAIT 就是靠这一条「先等 i0 帧、再走后面的记录」。
---recs 里的角度/角增量一律用**我们的口径**（度、逆时针为正），由 sg_deg / sg_rec 换算好。
local function sg_tr_hook(recs, flags, start)
    local n = #recs
    return function(self)
        local st = self.sg_tr
        if not st then
            ---start = 第几条记录起跑（0-based 的 transformStartIndex + 1）。生下来的
            ---子弹只吃「父弹记录表里从 transformStartIndex 起」的那一段（见 SG_CHILD）,
            ---所以这里必须能指定起点；不传就是 1（整张表从头跑）。
            st = { i = start or 1, active = 0, timer = 0 }
            self.sg_tr = st
        end
        ---① AdvanceTransformProgram：找下一条能吃的记录。
        ---★ 应用一条就要把索引 +1（C 里是 BulletManager.cpp:694 的
        ---  PhotoBulletAdvanceTransformPhase）—— 不然这条记录走完的下一帧会被**重新应用**
        ---  一遍，一张 70 帧的减速会被无限叠下去（弹速一路减到 0 卡在原地）。
        if st.active == 0 then
            while st.i <= n do
                local r = recs[st.i]
                if r.kind == 0 then
                    st.i = n + 1               -- kind == NONE ⇒ 程序到此结束（:521）
                    break
                end
                if not sg_has(flags, r.kind) then
                    st.i = st.i + 1
                elseif r.kind == SG_SET_SPRITE then
                    ---0x4000 SET_SPRITE：把弹的贴图/色号换成 payload.int0/int1
                    ---（BulletManager.cpp:617-622）。**立即执行、不占 active**，执行完
                    ---接着找下一条（C 里的 `goto nextRecord`）。本仓库的弹在 New 出来之后
                    ---没有「半路换贴图」的接口，ecl14_a 的 Sub9 又只是把型 14 的色 3 换成
                    ---色 5（同型同尺寸，只有颜色差），所以这里**不实现**，只按原样跳过。
                    st.i = st.i + 1
                elseif r.kind == SG_JUMP then
                    ---0x2000000 JUMP：把 transformIndex 直接设成 payload.int0，重新取那条
                    ---（BulletManager.cpp:676-678）。ecl15_b 用它做「发一颗子弹 → 极坐标加速
                    ---duration 帧 → 跳回第 0 条」的循环（int0=0）。
                    st.i = r.i0 + 1
                elseif r.kind == SG_CHILD then
                    ---0x400000 SPAWN_CHILD_PATTERN（BulletManager.cpp:639-675）：**这一条
                    ---要连着吃掉后面一条**（第二条的 payload 是 secondary：count2 /
                    ---transformFlags / angle / angleStep）。第一条的 packedPattern 位域：
                    ---   bit31    fadeParent（本卡用不到）
                    ---   bit30..24 aimMode（0..8，就是 ins_86..94 的 86+aimMode）
                    ---   bit23..16 bulletType
                    ---   bit15..8  color
                    ---   bit7..0   transformStartIndex（子弹从第几条记录起跑）
                    ---子弹表整个 memcpy 给子弹，所以子弹的 recs 就是父弹这张表。
                    local sec = recs[st.i + 1]
                    local u = r.i0 % 0x100000000
                    local aim = math.floor(u / 0x1000000) % 0x80
                    local btype = math.floor(u / 0x10000) % 0x100
                    local bcolor = math.floor(u / 0x100) % 0x100
                    local sidx = u % 0x100
                    local c1 = r.i1
                    local c2 = sec and sec.i0 or 1
                    local cflags = sec and sec.i1 or 0
                    local base = sec and sec.f0 or 0
                    local step = sec and sec.f1 or 0
                    local hook = sg_tr_hook(recs, cflags, sidx + 1)
                    sg_shot(86 + aim, sg_style(btype), ex_color(bcolor), self.x, self.y,
                            c1, c2, r.f0, r.f1, math.deg(base), math.deg(step),
                            false, cflags, hook)
                    st.i = st.i + 2
                else
                    st.active, st.rec, st.timer, st.i = r.kind, r, 0, st.i + 1
                    if r.kind == SG_WAIT then
                        st.timer = r.i0
                    elseif r.kind == SG_CHDIR_A or r.kind == SG_CHDIR_R then
                        st.left = r.i1
                        ---★ C 的减速基准是**弹当前的速度**（UpdateAbsoluteDirectionChange
                        ---  BulletManager.cpp:908-914 的 this->speed），f1 只决定「到点之后」
                        ---  把速度设成多少 ⇒ 应用这条时先存当前速、到点那一帧才用 f1 覆盖。
                        ---  （旧写法把 st.spd 直接设成 f1，等于把 8 的初速当 1 去减，
                        ---  整条减速轨迹会缩成 1/8。）
                        st.spd = GetV(self)
                    elseif r.kind == SG_POLAR then
                        st.spd = GetV(self)
                    elseif r.kind == SG_VEC then
                        ---★ 0x10 的加速度方向取**这条记录被应用那一刻**的弹角
                        ---  （BulletManager.cpp:543-546：accelerationAngle ≤ −990 时存下当时的
                        ---  this->angle，之后这个矢量就固定不动）。必须在这里存一次：
                        ---  原作 C 里 accelerationAngle 是 exStates 里的常量，弹被减到速度
                        ---  过零、开始倒退时它不会跟着弹角翻向；若每帧现读 self.rot，弹一
                        ---  倒退就把加速度也翻 180°，会在原地来回抖（卡 494 的 −1/24×120
                        ---  正好让 4→−1，第一次踩到这个坑）。
                        st.vecA = (r.f1 > -990) and r.f1 or self.rot
                    elseif r.kind == SG_BOUNCE or r.kind == SG_BOUNCE_EB then
                        st.hits = 0
                    end
                    break
                end
            end
        end
        ---② 跑当前生效的那一条（和 C 一样：应用的同帧就跑一次）
        local r = st.rec
        if r == nil then return end
        if st.active == SG_POLAR then
            if st.timer >= r.i0 then
                st.active, st.rec = 0, nil
            else
                st.a = (st.a or self.rot) + r.f1
                st.spd = st.spd + r.f0
                object.SetV(self, st.spd, st.a, true)
            end
            st.timer = st.timer + 1
        elseif st.active == SG_VEC then
            if st.timer >= r.i0 then
                st.active, st.rec = 0, nil
            else
                ---BulletManager.cpp:543-546：f1 ≤ −990 时用**这条记录被应用那一刻**的弹角
                ---（原作写 −999.99）⇒ 弹沿自己出生方向加速，各自成一条直线。
                local aa = st.vecA
                self.vx = self.vx + r.f0 * cos(aa)
                self.vy = self.vy + r.f0 * sin(aa)
                self.rot = Angle(0, 0, self.vx, self.vy)
            end
            st.timer = st.timer + 1
        elseif st.active == SG_CHDIR_A or st.active == SG_CHDIR_R then
            if st.timer >= r.i0 then
                st.left = st.left - 1
                if st.left <= 0 then st.active, st.rec = 0, nil end
                st.spd = (r.f1 > -999) and r.f1 or st.spd
                ---0x100 CHDIR_ABS 把角**设成** f0；0x40 CHDIR_REL 则是**加上** f0
                ---（UpdateAbsoluteDirectionChange :895 / UpdateRelativeDirectionChange :849）。
                ---f0 已经是我们的度数（sg_rec 的调用方用 sg_deg 换过，取反了）。
                self.rot = (st.active == SG_CHDIR_R) and (self.rot + r.f0) or r.f0
                object.SetV(self, st.spd, self.rot, true)
                st.timer = 0
            else
                ---BulletManager.cpp:864-869 / :908-914：间隔内速度从当前值线性减到 0
                ---（方向不变，所以看起来像「滑到几乎停住、再拐弯重新加速」）。
                object.SetV(self, st.spd * (1 - st.timer / r.i0), self.rot, true)
            end
            st.timer = st.timer + 1
        elseif st.active == SG_WAIT then
            ---BulletManager.cpp:1468-1473：timer ≤ 0 才收掉这个变换，否则每帧 −1
            if st.timer <= 0 then
                st.active, st.rec = 0, nil
            else
                st.timer = st.timer - 1
            end
        elseif st.active == SG_BOUNCE or st.active == SG_BOUNCE_EB then
            ---BulletManager.cpp:959-1001：四条边都反射（x < −192 / x ≥ 192 / y < 0 /
            ---y ≥ 448），反弹满 bounceLimit 次就把这个变换收掉。
            ---★ 本仓库的 straight_bullet 自带一条 rebound（bullet.lua:236-248，
            ---  只反弹左/右/上三面、且次数无限），只能表达原作的 0x800
            ---  （BOUNCE_EXCEPT_BOTTOM）；0x400 多出来的下边界与次数上限在这里自己写，
            ---  所以吃 BOUNCE 的弹一律**不传** rebound 参数。
            if st.hits >= r.i0 then
                st.active, st.rec = 0, nil
            else
                local w = lstg.world
                local hit = false
                if self.x < w.l or self.x > w.r then
                    self.vx = -self.vx
                    self.x = (self.x < w.l) and (2 * w.l - self.x) or (2 * w.r - self.x)
                    hit = true
                end
                ---0x400 四条边都反射；0x800 BOUNCE_EXCEPT_BOTTOM 少了「下边界那一条」
                ---（BulletManager.cpp:963-978 里 y 那支会检查 activeTransformFlags 是否含
                --- BOUNCE_ALL_EDGES）。TH095 的「下边界」= 我们的 y ≤ −224（y 轴翻过来），
                ---跳过的正是这一条。
                if (st.active == SG_BOUNCE or self.y > w.b) and
                        (self.y > w.t or self.y < w.b) then
                    self.vy = -self.vy
                    self.y = (self.y > w.t) and (2 * w.t - self.y) or (2 * w.b - self.y)
                    hit = true
                end
                if hit then
                    self.rot = Angle(0, 0, self.vx, self.vy)
                    st.hits = st.hits + 1
                end
            end
        end
    end
end

do  -- 80 永琳 非符（ecl18_a，永琳，组 9a 第 1 张）
    ---原作这一关的第 1 幕**没有** ins_104（不亮卡名）：永琳进场后站定不动，从第 60 帧起
    ---每 10 帧抛出**两整圈** 15 发中玉 —— 两圈同一基准角、同一初速 5，但分别在
    ---70 帧里以 +0.6°/帧 与 −0.6°/帧 自转，同时速度一起从 5 线性减到 0.7。
    ---数据源 /tmp/S8_ecl18_a.txt（ECL …/data/ecl18_a.ecl）。骨架：
    ---  · Sub2：ins_55(2) + ins_81(3) + ins_109(0) + ins_77(24,24) + ins_141(6)（拍 6 张）
    ---    + ins_108(0,31)/ins_108(1,30)（子机槽）+ ins_143(1,130) + ins_63(-128,-64) 进场
    ---    → t=100 ins_64(30,4,0,128) 落到 (0,128)（我们的 (0,96)）→ t=130 的 `id=0`
    ---    （opcode 0 在 EclRunLow.inl 的 switch 里没有分支 ⇒ **NOP**；这一张就是不亮
    ---    卡名的非符）+ ins_75(-140,128,140,192)（这一张**没有任何移动指令**，框用不上）
    ---    + ins_149(4.5) + ins_132(1) + ins_52(3)。
    ---  · Sub3（@692）：t=0 ins_106(5)（音效）+ 起两条装饰上下文（Sub5/Sub6 都是
    ---    ins_150 的 ANM 装饰，不实现）；t=60 起 slot0 的 Sub4（发弹体）；t=180 的
    ---    ins_4(60,0) 跳回 @768（就是 t=60 那句）⇒ 每 120 帧把 Sub4 重新起一遍。
    ---    Sub4 自己是死循环、周期 10 帧，而 120 = 12 个周期 ⇒ 重起不改变相位，
    ---    这里就写成一条 while（少绕一层）。
    ---  · Sub4（@800）：每 10 帧一轮 ——
    ---      ① floatV0 = rand(−π,π)（@840，跳回点）；floatV1 = floatV0（@860）
    ---      ② 写 slot0 的 ins_101(0, 0x20 ACCEL_POLAR, 0, 70, −1, −0.0614286, +0.010472)
    ---         → 紧接着 ins_89 CIRCLE(型13、色2、15 发、速 5、基角 floatV0、步长 0.1848、
    ---         flags 546) ⇒ 这一圈吃**刚写的那条**记录
    ---      ③ floatV0 += 1.875°、归一化；再把 slot0 改写成角度增量 −0.010472 的那条
    ---         → t=5 的一圈（色 3）吃**第二条**记录
    ---    ⇒ 两圈同起点、反向自旋着减速，像一对缓缓收拢又拧开的伞。
    ---★ 记录的原始字节核过（ecl18_a.ecl 偏移 880 与 1000）：op5 = −0.0614286（速度增量）、
    ---  op6 = ±0.010472（角度增量），0.010472 rad = 0.6°、0.1848 rad = 2π/34。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = ""                                -- 非符：原作没有 ins_104
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 478

    local RING_COUNT, RING_SPEED = 15, 5                -- ins_89 的 c1 / sp1
    local FIRE_GAP = 5                                  -- 两圈相隔 5 帧（@920 t=0 / @1040 t=5）
    local START_AT = 60                                 -- Sub3 的 t=60
    local SPEED_DELTA, DUR = -0.0614286, 70             -- ins_101 的 f0 / i0
    local ANGLE_DELTA = 0.6                             -- = 0.010472 rad（我们的度/帧）

    local hook_ccw = sg_tr_hook(
            { sg_rec(SG_POLAR, 0, DUR, -1, SPEED_DELTA, ANGLE_DELTA) }, SG_POLAR)
    local hook_cw = sg_tr_hook(
            { sg_rec(SG_POLAR, 0, DUR, -1, SPEED_DELTA, -ANGLE_DELTA) }, SG_POLAR)

    local st = { dead = false }

    ---Sub4：每 10 帧两整圈（色 2 逆时针自旋、色 3 顺时针自旋）。
    ---基准角在 TH095 空间里是 rand(−π,π)；整圈取反后方向集合不变，所以直接抽我们的度。
    local function run_sub4(owner)
        task.New(owner, function()
            while not st.dead do
                local base = sg_deg(ran:Float(-math.pi, math.pi))
                sg_shot(89, ball_mid, ex_color(2), owner.x, owner.y,
                        RING_COUNT, 1, RING_SPEED, 1.5, base, 0, false, 546, hook_ccw)
                task.Wait(FIRE_GAP)
                if st.dead then return end
                sg_shot(89, ball_mid, ex_color(3), owner.x, owner.y,
                        RING_COUNT, 1, RING_SPEED, 1.5, base, 0, false, 546, hook_cw)
                task.Wait(FIRE_GAP)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：Sub3 的 t=0 是 ins_106(5)（定位置的音效）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            task.Wait(START_AT)
            run_sub4(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
    end

    boss.card.add({ { card, "9a" } }, LEVEL, CARD_NAME, CARD_ID)
end--永琳 非符（ecl18_a）

do  -- 81 新難題「月のイルメナイト」（ecl19_a，辉夜，组 10a 第 1 张）
    ---原作是辉夜的第一张难题：本体每 120 帧在活动框里换一个位置（走得比相机还慢），
    ---同时每 5 帧从**本体周围 80 px 内的随机一点**甩出一整圈小玉；这一圈不瞄准，
    ---但每颗弹都吃到一条「朝发弹那一瞬间的自机方向加速 1/120 每帧、共 240 帧」的记录
    ---（ins_101 的 ACCEL_VEC）—— 于是整圈弹先各飞各的，再被同一股力慢慢掰成
    ---同一族抛物线。每圈弹数 = photoIndex + 7，颜色是 1..14 里的随机一档。
    ---数据源 /tmp/S8_ecl19_a.txt（ECL …/data/ecl19_a.ecl）。骨架：
    ---  · Sub2：与 ecl18_a 同一套骨架（ins_55/81/109/77/141(6)/108/143/63 → t=100 落到
    ---    (0,128)（我们的 (0,96)）→ t=130 **亮卡名**（有 ins_104，这一张是符卡）
    ---    + ins_75(-140,128,140,192) + ins_149(4.5) + ins_132(1) + ins_52(3)）。
    ---  · Sub3（@732）：t=0 ins_106(5) + 117(0,4)（起发弹体 Sub4）；t=120 ins_67(120,4,0.5)
    ---    ⇒ 用 120 帧、缓动 4、总位移 0.5×120 = 60 px 的「远离自机」游走；
    ---    t=240 的 ins_4(0,-24) 跳回 @768（就是 t=120 那句）⇒ 每 120 帧换一次位置，
    ---    而且 ins_67 一走就是 120 帧 ⇒ 本体其实一直在慢慢挪。
    ---  · Sub4（@824）：每 5 帧一轮（t=5 的 ins_4 跳回 @864）——
    ---      extraFloatV0 = 80×rand[0,1)（@864，跳回点）
    ---      extraFloatV1/…由 ins_38 变成极坐标 (x,y) = (cos·m, sin·m)（随机方向 + 半径 m）
    ---      ins_100 把这对写成 shootOffset ⇒ 出膛点 = 本体 + 那个偏移
    ---      floatV0 = rand(−π,π)（这一圈的基准角）
    ---      ins_101(0, 0x10 ACCEL_VEC, 0, 240, −1, 0.00833333, playerAngle)
    ---        —— f0 = 每帧加速度大小 1/120、f1 = 加速度方向 = **出膛那一刻**的自机角
    ---        （0x2730 = Enemy::ResolveFloat 的 playerAngle，EclOperandsFloat.cpp:175）
    ---      intV0 = photoIndex + 7（这一圈的发数）
    ---      intV1 = randU31 % 14 + 1（颜色 1..14）
    ---      ins_89 CIRCLE(型0 = 直径 4、色 intV1、c1 = intV0、c2 = 1、速 1、基角 floatV0、
    ---      步长 0.1848 = 2π/34、flags 530) ⇒ 这一圈吃上面那条记录
    ---      ins_37 归一化 floatV0，t=5 跳回。
    ---★ randU31 % 14 用的是**整数**随机（EclOperandsFloat.cpp:118 的 0x2720）；
    ---  这里用 ran:Int(0,13)+1（同一分布、另一个实现），数值行为一致。
    ---★ flags 530 = 0x212 = 0x200（出场音）+ 0x10（VEC）+ 0x2（出场滑动，不实现）；
    ---  记录要能被吃，flags 里必须有 0x10 —— 这是写 ins_101 时必须核的一步。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "新難題「月のイルメナイト」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 479

    local BOX = { -140, 128, 140, 192 }                 -- ins_75(-140,128,140,192)
    local MOVE_FRAMES, MOVE_EASE, MOVE_SPEED = 120, 4, 0.5   -- ins_67(120,4,0.5)
    local FIRE_GAP = 5                                  -- Sub4 的周期
    local RING_EXTRA, RING_SPEED = 7, 1                 -- ins_89 的 c1 偏移 / sp1
    local SPAWN_R = 80                                  -- ins_27 的半径
    local ACCEL_FRAMES, ACCEL_MAG = 240, 0.00833333     -- ins_101 的 i0 / f0
    local COLOR_SPAN = 14                               -- intV1 = randU31 % 14

    local st = { dead = false }

    ---Sub4：每 5 帧一整圈。
    local function run_sub4(owner)
        task.New(owner, function()
            while not st.dead do
                ---shootOffset：本体周围 80 px 内的随机一点（ins_27 + ins_38 + ins_100）。
                local m = SPAWN_R * ran:Float(0, 1)
                local oa = sg_deg(ran:Float(-math.pi, math.pi))
                local sx, sy = owner.x + m * cos(oa), owner.y + m * sin(oa)
                ---这条记录在**出膛那一刻**取值：加速度方向 = 本体→自机的角
                ---（0x2730 用的是 worldPosition，不含 shootOffset）。
                local acc = Angle(owner.x, owner.y, player.x, player.y)
                local hook = sg_tr_hook(
                        { sg_rec(SG_VEC, 0, ACCEL_FRAMES, -1, ACCEL_MAG, acc) }, SG_VEC)
                local base = sg_deg(ran:Float(-math.pi, math.pi))
                local count = photo_index(PHOTO_LIMIT) + RING_EXTRA
                local color = ex_color(ran:Int(0, COLOR_SPAN - 1) + 1)
                sg_shot(89, ball_small, color, sx, sy, count, 1, RING_SPEED, 1.5,
                        base, 0, false, 530, hook)
                task.Wait(FIRE_GAP)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：亮卡名 + Sub3 的 t=0（ins_106(5) 音效 + 起 Sub4）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            run_sub4(self)
            while not st.dead do
                ---Sub3 的 t=120 / t=240 循环：每 120 帧一次 60 px 的「远离自机」游走。
                task.Wait(MOVE_FRAMES)
                if st.dead then return end
                sg_bmove(self, st, MOVE_FRAMES, MOVE_EASE, MOVE_SPEED, BOX)
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
    end

    boss.card.add({ { card, "10a" } }, LEVEL, CARD_NAME, CARD_ID)
end--新難題「月のイルメナイト」

do  -- 82 薬符「胡蝶夢丸ナイトメア」（ecl18_b，永琳，组 9a 第 2 张）
    ---原作这一张是两层的「蝴蝶梦丸」：本体每 190 帧做一轮 ——
    ---  · 第 60 帧一次性叠出 **11 层同心圆**：每层 24 发中玉、初速 0，吃一条
    ---    ACCEL_VEC 记录（加速度 = 1/60、2/60 … 11/60 每帧，方向取**弹自己出生时**的角，
    ---    持续 60 帧）⇒ 60 帧后各层速度正好是 1、2 … 11，整叠像一朵被吹开的花。
    ---  · 第 120 帧放出 **9 只蝴蝶子机**：朝「本体→自机」的方向 ±22.5° 起、每只间隔
    ---    45°；每只自己朝那个方向直线飞（速 4）并一路撒「本体周围 48 px 内随机一点、
    ---    随机方向、速 1」的小玉。撒得多快、什么颜色看**拍中本体的张数**：
    ---    <3 ⇒ 绿 10 每 5 帧；3~4 ⇒ 紫 4 每 4 帧；≥5 ⇒ 红 2 每 3 帧。
    ---  · 第 130 帧本体自己挪一次（60 帧走 1.6×60 = 96 px）。
    ---数据源 /tmp/S8_ecl18_b.txt（ECL …/data/ecl18_b.ecl）。骨架：
    ---  · Sub2：ins_141(7)（拍 7 张）+ t=100 ins_64(30,4,0,160) 落到 (0,160)
    ---    （我们的 (0,64)）→ t=130 亮卡名 + ins_75(-160,128,160,144) + ins_149(1.5)
    ---    + ins_132(1) + ins_52(3)。
    ---  · Sub3（@760）：t=0 ins_106(5) + 两条装饰子上下文（Sub6/Sub7 都是 ins_150）；
    ---    t=60 起 slot0 的 Sub4（叠层）与 slot1 的 Sub5（放子机）；t=110 ins_144(15)
    ---    （快门脉冲，不实现）；t=130 ins_67(60,0,1.6)（缓动 0 = 线性）；t=190 的
    ---    ins_4(0,?) 跳回 @780（t=0 那句 ins_106(5)）⇒ 整轮 190 帧、音效每轮响一次。
    ---  · Sub4（@948）：floatV0 = 1/60；extraIntV0 = 10；ins_106(16)；
    ---    @1004 写 slot0 的 ins_101(0, 0x10 ACCEL_VEC, 0, 60, −1, floatV0, −999.99)
    ---    → @1044 ins_90 OFFSET_CIRCLE_AIMED(型15、色3、24 发、速 0、步长 0.03272、
    ---    flags 536) ⇒ 这一层吃刚写的记录；@1088 floatV0 += 1/60；
    ---    @1108 ins_5(0, −104, extraIntV0) 回跳 —— ins_5 是「先 −−n 再判 >0」
    ---    ⇒ 循环体走 **11** 遍（n 从 10 到 0）。@1132 ins_53 自灭。
    ---    ★ 原始字节核过（ecl18_b.ecl 偏移 1004 与 1108）：op5 是 0x2724 = extraIntV0、
    ---      回跳偏移 −104（落回 @1004）。
    ---  · Sub5（@1156，全部指令带 t=60 ⇒ 上下文建好后第 60 帧才动）：
    ---    extraFloatV2 = playerAngle + 22.5°；extraFloatV3 = 4（子机速度）；
    ---    @1256 循环体 = ins_83(11)（**生成子敌机**）+ extraFloatV2 += 45°；
    ---    @1292 ins_5(60, −36, extraIntV0 = 8) ⇒ 9 只（第 1 只与第 9 只方向重合，
    ---    原作就是这样）；@1316 ins_53 自灭。
    ---  · Sub11（@2040，每个子机的脚本）：ins_55(2)/80(8)/81(16) 换 ANM；
    ---    ins_65(extraFloatV2, extraFloatV3) 把自己设成「朝那个方向、速 4」；
    ---    然后按 photoIndex 分三档：ins_50(photoIndex,3,…) ≥3 再判
    ---    ins_50(photoIndex,5,…) —— ≥5 ⇒ ins_117(0,10)，否则 ins_117(0,9)；
    ---    <3 ⇒ ins_117(0,8)。三档就是 Sub8/9/10 三个撒弹器。
    ---  · Sub8/9/10：ins_103(24)（设出场音，**只在进入循环前响一次的那句**）；
    ---    循环体 = extraFloatV0 = 48×rand[0,1) → ins_38 极坐标 → ins_100 shootOffset
    ---    → ins_89 CIRCLE(型3 = 直径 4、色 10/4/2、1 发、速 1、基角 rand(−π,π)、
    ---    flags 536)（flags 的 0x200 让**每一发**都响一次出场音）；周期 5/4/3 帧。
    ---    ★ 子机在本仓库按文件头差异 5 的做法：**数量受限的自绘 object** ——
    ---      直线飞、飞出场地就淡出回收（原作的子敌机是靠 offscreen 检查回收的）。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(160)              -- 0 / 64
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 7                               -- ins_141(7)
    local CARD_NAME = "薬符「胡蝶夢丸ナイトメア」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 480

    local BOX = { -160, 128, 160, 144 }                 -- ins_75(-160,128,160,144)
    local CYCLE = 190                                   -- Sub3 一轮
    local BURST_AT = 60                                 -- Sub4 的 t=60 → 本轮第 60 帧
    local DRONE_AT = 120                                -- Sub5 的 t=60（上下文建于第 60 帧）
    local MOVE_AT = 130                                 -- Sub3 的 ins_67
    local MOVE_FRAMES, MOVE_EASE, MOVE_SPEED = 60, 0, 1.6

    local BURST_LAYERS = 11                             -- ins_5 的 n = 10 ⇒ 11 层
    local BURST_COUNT = 24                              -- ins_90 的 c1
    local BURST_STEP, BURST_FRAMES = 1 / 60, 60         -- floatV0 的初值 / 步长、ins_101 的 i0

    local DRONE_N, DRONE_SPEED = 9, 4                   -- ins_83 的遍数 / extraFloatV3
    local DRONE_A0, DRONE_DA = 22.5, 45                 -- 0.392699 rad / 0.785398 rad
    local EMIT_R, EMIT_SPEED = 48, 1                    -- ins_27 的半径 / ins_89 的 sp1
    ---三档撒弹器（Sub8/9/10）：色号与周期（5/4/3 帧）
    local EMIT_MODES = { { color = 10, gap = 5 }, { color = 4, gap = 4 }, { color = 2, gap = 3 } }
    local DRONE_FADE_IN, DRONE_FADE_OUT, DRONE_ALPHA = 8, 12, 200

    local st = { dead = false }
    local drones = {}

    ---蝴蝶子机。方向 angle_deg 是**我们的度**（逆时针为正）；发射器周期/色号由生成那一刻的
    ---photoIndex 决定（原作 Sub11 只在开场判一次）。
    class.nightmare_drone = Class(object, {
        init = function(self, owner, angle_deg, color, gap)
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false               -- 自己管回收（下面那条协程）
            self.x, self.y = owner.x, owner.y
            self.rot = 0
            self._a = 0
            object.SetV(self, DRONE_SPEED, angle_deg, true)
            local w = lstg.world
            task.New(self, function()
                for _ = 1, DRONE_FADE_IN do
                    self._a = min(DRONE_ALPHA, self._a + DRONE_ALPHA / DRONE_FADE_IN)
                    task.Wait()
                end
                ---Sub8/9/10 的循环：每 gap 帧一发（出膛点在 48 px 内随机、方向随机）。
                while self.x > w.l - 64 and self.x < w.r + 64
                        and self.y > w.b - 64 and self.y < w.t + 64 do
                    local m = EMIT_R * ran:Float(0, 1)
                    local oa = sg_deg(ran:Float(-math.pi, math.pi))
                    local sx, sy = self.x + m * cos(oa), self.y + m * sin(oa)
                    NewSimpleBullet(ball_small, ex_color(color), sx, sy, EMIT_SPEED,
                            sg_deg(ran:Float(-math.pi, math.pi)), false, 0, false)
                    PlaySound("tan00", 0.1, sx / 256, false)   -- flags 536 的 0x200
                    task.Wait(gap)
                end
                for _ = 1, DRONE_FADE_OUT do
                    self._a = max(0, self._a - DRONE_ALPHA / DRONE_FADE_OUT)
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end,
        frame = function(self)
        end,
        render = function(self)
            SetImageState("butterfly4", "mul+add", self._a, 210, 170, 250)
            Render("butterfly4", self.x, self.y, self.rot, 0.8)
            SetImageState("butterfly6", "mul+add", self._a * 0.7, 180, 140, 240)
            Render("butterfly6", self.x - cos(self.rot) * 9, self.y - sin(self.rot) * 9,
                    self.rot + 40, 0.6)
        end,
    })

    ---Sub4：11 层同心圆叠在一帧里放完（原作也是一次性走完这个循环）。
    local function run_burst(owner)
        for k = 1, BURST_LAYERS do
            local hook = sg_tr_hook({ sg_rec(SG_VEC, 0, BURST_FRAMES, -1,
                    BURST_STEP * k, -999.99) }, SG_VEC)
            sg_shot(90, ball_mid, ex_color(3), owner.x, owner.y,
                    BURST_COUNT, 1, 0, 0, 0, 0.0327249, true, 536, hook)
        end
    end

    ---Sub5 + Sub11：9 只蝴蝶子机朝「本体→自机」±22.5° 起、每只差 45°。
    ---★ TH095 的角度是顺时针为正，我们的取反 ⇒ 起始角是「我们的自机角 − 22.5°」，
    ---  且每只**减** 45°（原作的 +45° 取反）；整组方向集合不变（差 45° 的九分之八圈）。
    local function spawn_drones(owner)
        local n = photo_index(PHOTO_LIMIT)
        local mode = (n >= 5) and EMIT_MODES[3] or (n >= 3) and EMIT_MODES[2] or EMIT_MODES[1]
        local a = Angle(owner.x, owner.y, player.x, player.y) - DRONE_A0
        for _ = 1, DRONE_N do
            drones[#drones + 1] = New(class.nightmare_drone, owner, a, mode.color, mode.gap)
            a = a - DRONE_DA
        end
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
        drones = {}
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作第 130 帧：亮卡名 + Sub3 的 t=0（ins_106(5)）。
            while not st.dead do
                PlaySound("tan00", 0.1, self.x / 256, false)
                task.Wait(BURST_AT)
                if st.dead then return end
                run_burst(self)
                task.Wait(DRONE_AT - BURST_AT)
                if st.dead then return end
                spawn_drones(self)
                task.Wait(MOVE_AT - DRONE_AT)
                if st.dead then return end
                sg_bmove(self, st, MOVE_FRAMES, MOVE_EASE, MOVE_SPEED, BOX)
                task.Wait(CYCLE - MOVE_AT)
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        for i = #drones, 1, -1 do
            if IsValid(drones[i]) then
                task.Clear(drones[i])
                object.RawDel(drones[i])
            end
        end
        drones = {}
    end

    boss.card.add({ { card, "9a" } }, LEVEL, CARD_NAME, CARD_ID)
end--薬符「胡蝶夢丸ナイトメア」

do  -- 83 新難題「エイジャの赤石」（ecl19_b，辉夜，组 10a 第 2 张）
    ---原作这一张是「红石」：辉夜每 124 帧做一轮 ——
    ---  · 先朝自机放一根 **type 12 的直线激光**（长 320、宽 32、速 12）；
    ---  · 同帧再放四组 **FAN_AIMED 大玉**（type 17 = 直径 28 ⇒ ball_huge），以自机方向
    ---    为轴：1 发（速 12）+ 2 发（速 8，±5.29°）+ 2 发（速 6，±10.6°）+ 2 发（速 4，
    ---    ±15.9°），一共 7 发；
    ---  · 另有 5 条并行上下文每 (32 − 4×拍照数) 帧各放一根**随机方向的细直线激光**
    ---    （type 1、长 128、宽 10、速 2）—— 拍中本体越多、激光越密；
    ---  · 本体每 240 帧沿活动框 (x∈[−140,140], TH095 y∈[128,192]) 做一次「边界感知」挪位。
    ---数据源 /tmp/S8_ecl19_b.txt（ECL …/data/ecl19_b.ecl）。骨架：
    ---  · Sub2（@384）：ins_55(2)+ins_81(3)+ins_109(0)+ins_77(24,24)+ins_141(6)（拍 6 张）
    ---    + ins_108(0,31)/ins_108(1,30)+ins_143(1,130)+ins_63(-128,-64) 进场
    ---    → t=100 ins_64(30,4,0,128) 落到 (0,128)（我们的 (0,96)）→ t=130 亮卡名
    ---    + ins_75(-140,128,140,192) + ins_149(4) + ins_132(1) + ins_52(3)。
    ---  · Sub3（@740）：t=0 起 slot0 的 Sub4（发弹体）与 slot2..6 的 5 份 Sub5（每条错开
    ---    10 帧，见 @756/@776/@796/@816/@836 的 ins_117(2..6,5)）；t=160 的
    ---    ins_67(120,4,0.5) 与 t=280 的 ins_4(40,−24) 组成一个 240 帧的外层环 ——
    ---    跳转目标是 @876 的 ins_67 **本身**（900−24=876），所以这个环**只重复挪位**；
    ---    t=0..40 那五条 ins_117 在环外、只跑一次，Sub4/Sub5 各自在内部死循环。
    ---  · Sub4（@932，124 帧一轮）：t=0 起一条装饰子上下文（Sub6，不实现）；t=60 先
    ---    ins_146(12,1,12,0,320,32)（**146 的角度 = 原始角 + 自机角**，见
    ---    EclRunTargetPhoto.inl:21-36）再四组 ins_86 FAN_AIMED；t=64 ins_144(15)（快门
    ---    脉冲，不实现）+ ins_106(16)；t=124 的 ins_4(0,−284) 跳回 @972 ⇒ 124 帧一轮。
    ---    ★ 四组 ins_86 的原始字节核过（ecl19_b.ecl @1028..1160）：op0 都是 0x11
    ---      （type 17、color 0）、count2 全是 1 ⇒ 速度 = speed1 不作插值；四组的
    ---      (count1, speed1, angleStep) = (1,12,0.1848)/(2,8,0.1848)/(2,6,0.3696)/
    ---      (2,4,0.5544)，共 **7** 发。色号 0 按 g_PhotoBulletColors16 = 灰
    ---      （BulletManager.cpp:128-133）⇒ 走 ex_color(0) = 灰 16。
    ---  · Sub5（@1300）：t=0 ins_145(1,2,2,rand(−π,π),128,10) 放一根随机直线激光；
    ---    接着 extraIntV1 = photoIndex×4（ins_22）、extraIntV1 = 30 − 它（ins_21）、
    ---    ins_2 冻结这么多帧；t=2 的 ins_4(0,−156) 跳回 @1320。
    ---    ★ ins_2 的冻结只作用在**执行它的那条上下文**（EclRun.cpp:299-303 减的是
    ---      activeEclContext 的 secondaryTime 与 time），5 份 Sub5 各冻各的 ⇒
    ---      每份的周期 = (30 − 4×photoIndex) + 2 —— 多出来的 2 帧是冻结结束后 time 停在
    ---      0、还要过 t=2 的那条 ins_4（ins_2 把 time 也按帧抵消，见 478 的注释）。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "新難題「エイジャの赤石」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 481

    local BOX = { -140, 128, 140, 192 }                 -- ins_75(-140,128,140,192)
    local MOVE_AT = 160                                 -- Sub3 的 ins_67
    local MOVE_FRAMES, MOVE_EASE, MOVE_SPEED = 120, 4, 0.5

    local SUB4_CYCLE, SUB4_FIRE = 124, 60               -- Sub4 一轮 / 开火点（t=60）
    local BEAM_LEN, BEAM_W, BEAM_SPEED = 320, 32, 12    -- ins_146 的后四参
    local BEAM_INDEX = 1                                -- 原作 color 1（laser 贴图行 = color）
    local BIG_COLOR = 0                                 -- 原作色号 0（灰）
    ---四组 FAN_AIMED 的 (count1, speed1, angleStep)，见上面的字节核对。
    local BIG = {
        { 1, 12, 0.1848 },
        { 2, 8, 0.1848 },
        { 2, 6, 0.369599 },
        { 2, 4, 0.554399 },
    }

    local SUB5_N = 5                                    -- slot 2..6，共 5 份
    local SUB5_STAGGER = 10                             -- 每条错开 10 帧
    local SUB5_GAP_BASE, SUB5_GAP_STEP = 30, 4          -- ins_2 的 30 − 4×photoIndex
    local SUB5_GAP_EXTRA = 2                            -- t=2 的 ins_4 之前的 2 帧
    local SUB5_INDEX = 2                                -- 原作 color 2
    local SUB5_LEN, SUB5_W, SUB5_SPEED = 128, 10, 2

    local lasers = {}
    local st = { dead = false }

    ---Sub4：每 124 帧 —— 一根自机方向直线激光 + 四组自机方向大玉扇。
    local function run_sub4(owner)
        task.New(owner, function()
            while not st.dead do
                task.Wait(SUB4_FIRE)
                if st.dead then return end
                spawn_ex_laser_straight(owner, lasers, BEAM_INDEX, owner.x, owner.y,
                        -sg_aim(owner.x, owner.y), BEAM_LEN, BEAM_W, BEAM_SPEED)
                for i = 1, #BIG do
                    local b = BIG[i]
                    sg_shot(86, ball_huge, ex_color(BIG_COLOR), owner.x, owner.y,
                            b[1], 1, b[2], 1.5, 0, b[3], true, 514)
                end
                PlaySound("tan00", 0.1, owner.x / 256, false)   -- t=64 的 ins_106(16)
                task.Wait(SUB4_CYCLE - SUB4_FIRE)
            end
        end)
    end

    ---Sub5：每 (32 − 4×拍照数) 帧一根随机方向的细直线激光（5 份错开 10 帧）。
    local function run_sub5(owner)
        task.New(owner, function()
            while not st.dead do
                spawn_ex_laser_straight(owner, lasers, SUB5_INDEX, owner.x, owner.y,
                        -math.deg(ran:Float(-math.pi, math.pi)),
                        SUB5_LEN, SUB5_W, SUB5_SPEED)
                PlaySound("tan00", 0.1, owner.x / 256, false)   -- ins_106(24)
                local gap = SUB5_GAP_BASE - SUB5_GAP_STEP * photo_index(PHOTO_LIMIT)
                if gap < 1 then gap = 1 end
                task.Wait(gap + SUB5_GAP_EXTRA)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=130 = Sub3 的 t=0：
            ---ins_106(5) 一声 + 起 Sub4 与 5 份 Sub5（每 10 帧一条）。
            PlaySound("tan00", 0.1, self.x / 256, false)
            run_sub4(self)
            run_sub5(self)
            for _ = 1, SUB5_N - 1 do
                task.Wait(SUB5_STAGGER)
                run_sub5(self)
            end
            ---Sub3 的 time 到这里是 40；ins_67 在 t=160。
            task.Wait(MOVE_AT - (SUB5_N - 1) * SUB5_STAGGER)
            while not st.dead do
                sg_bmove(self, st, MOVE_FRAMES, MOVE_EASE, MOVE_SPEED, BOX)
                task.Wait(MOVE_FRAMES)      -- t=160 → 280（ins_4 跳回 t=160）
                task.Wait(MOVE_FRAMES)      -- t=40 → 160
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        sg_clear(lasers)
    end

    boss.card.add({ { card, "10a" } }, LEVEL, CARD_NAME, CARD_ID)
end--新難題「エイジャの赤石」

do  -- 84 錬丹「水銀の海」（ecl18_c，永琳，组 9a 第 3 张）
    ---原作是「水银之海」：永琳在场地里**竖直往返**，同时一条并行上下文每 2 帧往
    ---「本体周围 32 px 内的随机一点」丢一颗小玉 —— 出膛方向是两个固定的出发角
    --- −135° / −45°（TH095 度），每 2 帧各向外扩 0.45°，而且吃 BOUNCE 变换、
    --- 最多在四壁反弹 4 次；拍中本体 ≥5 张后**再补一路**（−45° 那一色）。
    ---数据源 /tmp/S8_ecl18_c.txt（ECL …/data/ecl18_c.ecl）。骨架：
    ---  · Sub2（@384）：ins_55(2)+ins_81(3)+ins_109(0)+ins_77(24,24)+ins_141(6)（拍 6 张）
    ---    + ins_108(0,31)/ins_108(1,30)+ins_143(1,130)+ins_63(-128,-64) 进场
    ---    → t=100 ins_64(30,4,0,128) 落到 (0,128)（我们的 (0,96)）→ t=130 亮卡名
    ---    + ins_149(6)+ins_132(1)+ins_52(3)。★ **没有 ins_75**（竖直往返不用活动框）。
    ---  · Sub3（@712）：t=0 extraIntV1=60（给装饰子上下文用）+ ins_117(0,4)（Sub4，装饰）
    ---    + ins_117(2,5)（Sub5，装饰）+ ins_106(5)；t=60 ins_117(0,6) 起 **Sub6**（发弹体，
    ---    一次性、之后自己死循环）+ ins_144(15)（快门脉冲，不实现）+ ins_64(120,1,0,224)。
    ---    之后 t=180/300/420 各一条 ins_64（ease 4/1/4、目标 y=352/224/96），t=540 的
    ---    ins_4(60,−144) 跳回 @808 —— 那一句是 t=60 的 ins_144，**不在**环里的 ins_117(0,6)
    ---    之前，所以整段是一轮 480 帧的竖直往返（我们 y = 0/−128/0/+128）。
    ---  · Sub6（@1120，全部指令带 t=14 ⇒ 子上下文建好后第 14 帧才动；自环 2 帧）：
    ---    extraIntV0=4；floatV0=−2.35619（−135°）、floatV1=−0.785398（−45°）；
    ---    ins_101(0, 0x400 BOUNCE_ALL, allow=0, i0=4（反弹上限）, f0=−999⇒用当前速, f1=0)；
    ---    循环体（@1220..@1480，ins_4(14,−260) 跳回 @1220）每 2 帧一次：
    ---      ① extraFloatV0 = 32×randF32（@1220 的 ins_27），ins_38 把它化成极坐标
    ---         （角度 rand(−π,π)）⇒ 出膛点 = 本体 + 半径 ≤32 的随机点；ins_100 设偏移；
    ---      ② ins_87 FAN(型1、色8、1 发、速 2、基准角 floatV0、步长 π/2、flags 1538)
    ---      ③ ins_44(photoIndex,5,…) —— photoIndex < 5 就跳到 @1408，跳过下面一发；
    ---      ④ ins_87 FAN(型1、色10、1 发、速 2、基准角 floatV1、同上)；
    ---      ⑤ floatV0 −= 0.00785398、floatV1 += 0.00785398（ins_16 / ins_15），再归一化。
    ---    ★ 1538 = 0x602 = 0x400 BOUNCE_ALL + 0x200 出场音 + 0x2 SPAWN_FAST；
    ---      本仓库 straight_bullet 自带的 rebound 只能表 0x800、没有反弹上限，所以这
    ---      一类弹**不传 rebound**、四壁反射交给 sg_tr_hook 的 SG_BOUNCE（见上面 :5728）。
    ---    ★ floatV0/floatV1 在 TH095 里是**弧度**，步子 0.00785398 rad = 0.45°/2 帧。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "錬丹「水銀の海」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 482

    ---Sub3 的竖直往返：目标 TH095 y = 224 / 352 / 224 / 96，各 120 帧（缓动 1/4/1/4）。
    local RAFT_FRAMES = 120
    local RAFT = {
        { field_y(224), 1 },
        { field_y(352), 4 },
        { field_y(224), 1 },
        { field_y(96), 4 },
    }

    ---Sub6 的参数。
    local EMIT_WAIT = 14                                -- 全部指令的 t=14
    local EMIT_GAP = 2                                  -- ins_4(14,−260) ⇒ 每 2 帧一轮
    local EMIT_R = 32                                   -- ins_27 的 32
    local EMIT_SPEED = 2                                -- ins_87 的 speed1（count2=1）
    local EMIT_A0, EMIT_A1 = -2.35619, -0.785398        -- floatV0 / floatV1（弧度）
    local EMIT_STEP = 0.00785398                        -- 每次 +/−0.45°（弧度）
    local EMIT_SECOND_AT = 5                            -- ins_44 的闸（photoIndex ≥ 5）
    local EMIT_FLAGS = 1538                             -- 0x400 BOUNCE + 0x200 音 + 0x2 FAST

    local st = { dead = false }
    local hook_bounce = sg_tr_hook({ sg_rec(SG_BOUNCE, 0, 4, -1, -999, 0) }, SG_BOUNCE)

    ---Sub6：每 2 帧一发「随机出膛点、固定出发角、四壁反弹」的小玉。
    local function run_sub6(owner)
        task.New(owner, function()
            task.Wait(EMIT_WAIT)
            local a0, a1 = EMIT_A0, EMIT_A1
            while not st.dead do
                local m = EMIT_R * ran:Float(0, 1)
                local oa = sg_deg(ran:Float(-math.pi, math.pi))
                local sx, sy = owner.x + m * cos(oa), owner.y + m * sin(oa)
                sg_shot(87, ball_small, ex_color(8), sx, sy,
                        1, 1, EMIT_SPEED, 0.5, math.deg(a0), 90, false,
                        EMIT_FLAGS, hook_bounce)
                if photo_index(PHOTO_LIMIT) >= EMIT_SECOND_AT then
                    sg_shot(87, ball_small, ex_color(10), sx, sy,
                            1, 1, EMIT_SPEED, 0.5, math.deg(a1), 90, false,
                            EMIT_FLAGS, hook_bounce)
                end
                a0 = a0 - EMIT_STEP
                a1 = a1 + EMIT_STEP
                task.Wait(EMIT_GAP)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=130 = Sub3 的 t=0。
            PlaySound("tan00", 0.1, self.x / 256, false)   -- Sub3 t=0 的 ins_106(5)
            task.Wait(60)
            if st.dead then return end
            run_sub6(self)                                  -- ins_117(0,6)
            ---竖直往返：每段 120 帧，逐段 ins_64；ins_4 到点即回、不留停顿。
            while not st.dead do
                for i = 1, #RAFT do
                    local r = RAFT[i]
                    sg_move(self, st, HOME_X, r[1], RAFT_FRAMES, r[2])
                    task.Wait(RAFT_FRAMES)
                    if st.dead then return end
                end
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
    end

    boss.card.add({ { card, "9a" } }, LEVEL, CARD_NAME, CARD_ID)
end--錬丹「水銀の海」

do  -- 85 新難題「金閣寺の一枚天井」（ecl19_c，辉夜，组 10a 第 3 张）
    ---原作是「一块天花板」：辉夜站着不动，两股弹并排走 ——
    ---  · 一股每 60 帧放**两波共 32 发沿同一条射线排开的小玉**：从本体出发朝 +x
    ---    （TH095 0°）与 −x（180°），16 发的初速从 8 递减到 0.97（speed1 8 → speed2 0.5，
    ---    count2=16 做线性插值），随后吃 `0x100 CHDIR_ABS` 变换 —— 60 帧里减速到 0、
    ---    到点瞬间把方向**绝对**改成 ±90°、速度改成 1。±90° 取哪一边由「自机在世界 y 的
    ---    哪一侧」现场决定（ins_51 player.y ≥ 本体 worldPosition.y）。于是 16 发小玉被拉成
    ---    一条线、再一起横着滑走，正是一块「天井」。
    ---  · 另一股每 3 帧放四组「十字」（4 发 90° 等分的小玉），基准角各自以 1.5°/2°/3°/4.5°
    ---    每轮的速率自转；后三组要**拍中本体**到 3/5/6 张才解锁（ins_44 的 CMPlt 闸）。
    ---数据源 /tmp/S8_ecl19_c.txt（ECL …/data/ecl19_c.ecl）。骨架：
    ---  · Sub2（@384）：ins_141(7)（拍 7 张）+ t=100 ins_64(30,4,0,128) 落到 (0,128)
    ---    （我们的 (0,96)）→ t=130 亮卡名 + ins_149(4) + ins_132(1) + ins_52(3)。**没有 ins_75**。
    ---  · Sub3（@712）：t=0 extraIntV1=60 + ins_117(0,6)（Sub6，装饰）+ ins_106(5)；
    ---    t=60 ins_117(0,4)=Sub4 + ins_117(1,5)=Sub5；t=180 的 ins_4(60,0) 跳回**自己**
    ---    （偏移 0）⇒ 之后只是把 time 在 60↔180 之间来回拨、什么都不做，Sub4/Sub5 各自死循环。
    ---  · Sub4（@840，60 帧一轮）：t=0 一次 ins_51 比较选方向（成立→@988 的 +π/2、
    ---    否则@928 的 −π/2）→ ins_101(0, 0x100 CHDIR_ABS, allow=0, i0=60, i1=1, f0=±π/2, f1=1)
    ---    → ins_89 CIRCLE；t=30 再一发 ins_89（基准角 π）；t=60 ins_4(0,−216) 跳回 @900。
    ---    ★ 原始字节核过（ecl19_c.ecl @1028/@1072）：op0 = 0xD0001（type 1、color 13）、
    ---      (count1, count2) = (1,16)、speed1 8 / speed2 0.5、angleStep 0、flags 770 ——
    ---      **count1=1 是「每圈 1 发」、count2=16 是「16 圈」**（BulletManager.cpp:706 的
    ---      外层 index2/内层 index1），所以 16 发的角度全相同、速度按 index2 插值。
    ---  · Sub5（@1160，3 帧一轮）：t=14 起每次先在 32 px 内随机取出膛点，再按 photoIndex
    ---    逐级放 1~4 组 ins_89 CIRCLE(count1=4, count2=1)（色 10/8/6/4、速 2/3/1.8/2.3）；
    ---    每出现一次就把那一组的基准角按 ins_16/ins_15 拨 2°/3°/4.5°，总基准角每轮 +1.5°。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 7                               -- ins_141(7)
    local CARD_NAME = "新難題「金閣寺の一枚天井」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 483

    ---Sub4：CHDIR_ABS 那一波。
    local CEIL_COUNT = 16                               -- count2
    local CEIL_SP1, CEIL_SP2 = 8, 0.5
    local CEIL_FLAGS = 770                              -- 0x100 CHDIR + 0x200 音 + 0x2 FAST
    local CEIL_WAIT = 60                                -- CHDIR 的 i0（也是两次齐射的间隔×2）
    local CEIL_DELTA = 30                               -- t=30 的第二发
    local CEIL_TURN = 90                                -- f0 的绝对值（度）

    ---Sub5：自转十字那一波。
    local CROSS_GAP = 3
    local CROSS_R = 32
    local CROSS_FLAGS = 514
    ---(色号, 速, 解锁张数, 自转步长 rad, 初始基准角 rad) —— 基准角 4 组都是 π/4。
    local CROSS = {
        { 10, 2, 0, 0.0261799, 0.785398 },              -- 1.5°/轮（永远解锁）
        { 8, 3, 3, -0.0349066, 0.785398 },              -- −2°
        { 6, 1.8, 5, 0.0523599, 0.785398 },             -- +3°
        { 4, 2.3, 6, -0.0785398, 0.785398 },            -- −4.5°
    }

    local st = { dead = false }

    ---Sub4：每 60 帧两波「同射线 16 连・减速转向」。
    local function run_sub4(owner)
        task.New(owner, function()
            while not st.dead do
                ---ins_51(player.y, enemy.worldPosition.y)：自机在**下方**（TH095 y 更大）成立
                ---⇒ @988 用 +π/2（下）、否则 @928 用 −π/2（上）。换算到我们这边：
                ---自机在下（我们的 y 更小）⇒ 转向下（−90°），否则转向上（+90°）。
                local f0 = (player.y <= owner.y) and -CEIL_TURN or CEIL_TURN
                local hook = sg_tr_hook(
                        { sg_rec(SG_CHDIR_A, 0, CEIL_WAIT, 1, f0, 1) }, SG_CHDIR_A)
                sg_shot(89, ball_small, ex_color(13), owner.x, owner.y,
                        1, CEIL_COUNT, CEIL_SP1, CEIL_SP2, 0, 0, false, CEIL_FLAGS, hook)
                task.Wait(CEIL_DELTA)
                if st.dead then return end
                sg_shot(89, ball_small, ex_color(13), owner.x, owner.y,
                        1, CEIL_COUNT, CEIL_SP1, CEIL_SP2, 180, 0, false, CEIL_FLAGS, hook)
                task.Wait(CEIL_WAIT - CEIL_DELTA)
            end
        end)
    end

    ---Sub5：每 3 帧一组「随机出膛点 + 自转十字」。
    local function run_sub5(owner)
        task.New(owner, function()
            local a = {}
            for i = 1, #CROSS do
                a[i] = CROSS[i][5]
            end
            while not st.dead do
                local m = CROSS_R * ran:Float(0, 1)
                local oa = sg_deg(ran:Float(-math.pi, math.pi))
                local sx, sy = owner.x + m * cos(oa), owner.y + m * sin(oa)
                local n = photo_index(PHOTO_LIMIT)
                for i = 1, #CROSS do
                    local c = CROSS[i]
                    if n >= c[3] then
                        sg_shot(89, ball_small, ex_color(c[1]), sx, sy,
                                4, 1, c[2], 0.5, math.deg(a[i]), 0, false, CROSS_FLAGS)
                        a[i] = a[i] + c[4]
                    end
                end
                task.Wait(CROSS_GAP)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=130 = Sub3 的 t=0。
            PlaySound("tan00", 0.1, self.x / 256, false)   -- Sub3 t=0 的 ins_106(5)
            task.Wait(60)
            if st.dead then return end
            run_sub4(self)
            run_sub5(self)
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
    end

    boss.card.add({ { card, "10a" } }, LEVEL, CARD_NAME, CARD_ID)
end--新難題「金閣寺の一枚天井」

do  -- 86 秘薬「仙香玉兎」（ecl18_d，永琳，组 9a 第 4 张）
    ---原作是「仙香玉兔」：永琳落到场地偏**下**（TH095 y=192 ⇒ 我们的 y=32）后 ——
    ---  · **一帧里一次性**在半径 32 的圆上摆 25 个发射点（每点差 15°），每点同时甩出
    ---    两根 147 旋转激光（type 12、色 6、满长 384 起步、宽 16、启动 40 帧、张开 20、
    ---    维持 12000、收 10、不自转）—— 一共 **50 根**，方向绕 ±67.5° 一路转满一圈；
    ---  · 60 帧之后开始每 90 帧放 4 颗**反弹大玉**（type 17 ⇒ ball_huge、色 2 红），
    ---    4 发 90° 等分、整组转向自机（ins_88 CIRCLE_AIMED），速度 1 + 0.05×拍照数
    ---    （拍中越多越快）；这些大玉吃 `0x400 BOUNCE_ALL`（反弹上限 999）在四壁弹。
    ---数据源 /tmp/S8_ecl18_d.txt（ECL …/data/ecl18_d.ecl）。骨架：
    ---  · Sub2（@388）：ins_141(8)（拍 8 张）+ **没有 ins_104** —— t=130 的卡名那一句位置
    ---    是一条 `id=0`（opcode 0 在 switch 里没有分支 ⇒ NOP）；t=100 ins_64(30,4,0,192)
    ---    落到 (0,192)（我们的 (0,32)）+ ins_149(6) + ins_132(1) + ins_52(3)。
    ---    **没有 ins_75**。卡名我们按 SceneSelect.cpp 的场景表照给（符卡系统需要 CARD_NAME）。
    ---  · Sub3（@652）：t=0 extraIntV1=60 + ins_106(5) + ins_62（special anm，不实现）
    ---    + ins_117(1,5)/ins_117(2,6)（都是 ins_150 装饰，不实现）+ ins_117(0,4)=Sub4；
    ---    t=60 ins_104（亮卡名）+ ins_117(2,7) 把 slot2 换成 **Sub7**；t=61 的 ins_4(60,0)
    ---    跳回自己 ⇒ 只在 60↔61 之间空转（Sub4 一次性、Sub7 自己死循环）。
    ---  · Sub4（@872，全在 t=0）：floatV0=0、floatV1=−1.1781（−67.5°）、floatV2=+1.1781；
    ---    循环体 @952..@1204 —— ins_38 把 floatV0 化成半径 32 的偏移、ins_100 设 shootOffset、
    ---    两根 ins_147(type12, 6, floatV1 / floatV2, 384, 16, 40, 20, 12000, 10, 0, 0)，
    ---    三个浮点各 +0.261799（15°）再归一化；@1220 的 ins_5(0,−268,extraIntV0=24)
    ---    先把计数 −1 再判 ⇒ 循环体走 **25** 遍，然后 ins_100(0,0) + ins_53 自灭。
    ---    ★ 全部指令的 time 都是 0、跳转又把 time 拨回 0 ⇒ 这 25 遍**在同一帧内**跑完。
    ---  · Sub7（@1424）：t=0 ins_101(0, 0x400, allow=0, i0=999（反弹上限）, f0=−999⇒当前速)
    ---    + floatV0 = photoIndex×0.05 + 1；ins_88 CIRCLE_AIMED(type17、色2、4 发、
    ---    speed1=floatV0、angleStep=π/2、flags 1538)；t=90 的 ins_4(0,−88) 跳回 @1464。
    ---    （@1424 那条 ins_101 在跳回点 @1464 之前 ⇒ 只写一次，参数本来也一样。）
    ---  · 147 用 `spawn_ex_laser(..., start_full=true)`；147 的速度固定 8（EclRunTargetPhoto.inl:
    ---    48-70 的 args.speed = 8.0f），angle **不加**自机角（那是 148）。
    ---  · ★ 这些大玉在原作里是**永久留存**的：bounceLimit 999、四壁反射发生在 384×448 的
    ---    场地边上（BulletManager.cpp:959-1001 的 PhotoBulletIsOutsidePlayfield(…,0,0)），
    ---    比「出屏回收」的判据更靠内 ⇒ 弹心永远出不了屏、不会被回收；原作靠全局 640 个弹槽
    ---    封顶。本仓库没有这个槽位上限，所以这张卡的峰值会随时长线性爬到卡结束
    ---    （每 90 帧 4 颗）—— 这是**原作行为**，不是移植泄漏，泄漏扫描里单独记一笔。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 8                               -- ins_141(8)
    local CARD_NAME = "秘薬「仙香玉兎」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 484

    ---Sub4 的 25 点 × 2 根 147。
    local BURST_N = 25                                  -- ins_5 的 n = 24 ⇒ 25 遍
    local BURST_R = 32                                  -- ins_38 的半径
    local BURST_STEP = 0.261799                         -- 15°（弧度）
    local BURST_A0 = 0                                  -- floatV0 初值（偏移角）
    local BURST_A1, BURST_A2 = -1.1781, 1.1781          -- floatV1 / floatV2（±67.5°）
    local LASER_INDEX = 6                               -- 原作 color 6（laser 贴图行 = color）
    local LASER_LEN, LASER_W, LASER_SPEED = 384, 16, 8  -- 147 的 maximumLength/Width/固定速
    local LASER_STARTUP, LASER_GROW, LASER_SUSTAIN, LASER_FADE = 40, 20, 12000, 10

    ---Sub7 的反弹大玉。
    local BALL_GAP = 90
    local BALL_COUNT = 4
    local BALL_SPEED_BASE, BALL_SPEED_STEP = 1, 0.05    -- 1 + 0.05×photoIndex
    local BALL_FLAGS = 1538                             -- 0x400 BOUNCE + 0x200 音 + 0x2 FAST

    local lasers = {}
    local st = { dead = false }
    local hook_bounce = sg_tr_hook(
            { sg_rec(SG_BOUNCE, 0, 999, -1, -999, 0) }, SG_BOUNCE)

    ---Sub4：一帧甩完 25 点 × 2 根 147。偏移角/束角都从 TH095 弧度换成我们的度。
    local function run_sub4(owner)
        task.New(owner, function()
            local o = BURST_A0
            local a = BURST_A1
            local b = BURST_A2
            for _ = 1, BURST_N do
                local oa = sg_deg(o)
                local sx = owner.x + BURST_R * cos(oa)
                local sy = owner.y + BURST_R * sin(oa)
                spawn_ex_laser(owner, lasers, LASER_INDEX, sx, sy, sg_deg(a),
                        LASER_LEN, LASER_W, LASER_SPEED, LASER_STARTUP, LASER_GROW,
                        LASER_SUSTAIN, LASER_FADE, 0, 0, 0, false, true)
                spawn_ex_laser(owner, lasers, LASER_INDEX, sx, sy, sg_deg(b),
                        LASER_LEN, LASER_W, LASER_SPEED, LASER_STARTUP, LASER_GROW,
                        LASER_SUSTAIN, LASER_FADE, 0, 0, 0, false, true)
                o = o + BURST_STEP
                a = a + BURST_STEP
                b = b + BURST_STEP
            end
        end)
    end

    ---Sub7：每 90 帧 4 颗自机狙反弹大玉，速度随拍照数增长。
    local function run_sub7(owner)
        task.New(owner, function()
            while not st.dead do
                local sp = BALL_SPEED_BASE
                        + BALL_SPEED_STEP * photo_index(PHOTO_LIMIT)
                sg_shot(88, ball_huge, ex_color(2), owner.x, owner.y,
                        BALL_COUNT, 1, sp, 0.5, 0, 90, true, BALL_FLAGS, hook_bounce)
                task.Wait(BALL_GAP)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=130 = Sub3 的 t=0。
            PlaySound("tan00", 0.1, self.x / 256, false)   -- Sub3 t=0 的 ins_106(5)
            run_sub4(self)                                  -- ins_117(0,4)
            task.Wait(60)
            if st.dead then return end
            run_sub7(self)                                  -- ins_117(2,7)（t=60 的 ins_104 由符卡系统代劳）
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        sg_clear(lasers)
    end

    boss.card.add({ { card, "9a" } }, LEVEL, CARD_NAME, CARD_ID)
end--秘薬「仙香玉兎」

do  -- 87 新難題「ミステリウム」（ecl19_d，辉夜，组 10a 第 4 张）
    ---原作是辉夜的最后一道难题「Mysterium」：本体落到场地**偏上**处不再移动，之后每 16 帧
    ---朝一对随机基准角发**两整圈**小玉（色 6 与色 8 各一圈、相隔 8 帧），每圈弹数 =
    ---32 + 2×(拍中本体的张数)（越拍越密）。这些弹起手先沿自己的方向直飞 60 帧，
    ---然后按五段「自转 + 加减速」程序走完 —— 两条色的程序互为镜像：色 6 先减速再加速、
    ---色 8 反过来，每段的自转方向也相反 ⇒ 两圈同源却朝相反方向拧开，像一呼一吸。
    ---数据源 /tmp/S8_ecl19_d.txt（ECL …/data/ecl19_d.ecl，与 th095/src 对照着读），
    ---下面注释里的「@地址」都指这份 dump。骨架：
    ---  · Sub2（@384）：ins_55(2)+ins_81(3)+ins_109(0)+ins_77(24,24)+**ins_141(7)**（拍 7 张）
    ---    + ins_108(0,31)/ins_108(1,30)（子机槽，不实现）
    ---    + ins_143(1,130)（拍照标记，不实现）+ ins_63(-128,-64) 进场
    ---    → t=100 ins_64(30,4,0,192) 落到 (0,192)（我们的 (0, field_y(192)) = (0,32)）
    ---    → t=100 ins_114(7208)（卡计时，不实现）→ t=130 亮卡名 + ins_149(3)/ins_132(1)
    ---    （都不实现）+ ins_52(3) 起 Sub3。
    ---  · Sub3（@696）：t=0 ins_6(extraIntV1,60)（给装饰用）+ ins_106(5)（音效）
    ---    + ins_117(0,5)（Sub5，装饰）；t=60 ins_117(0,6) 起 **Sub6**（发弹体）；
    ---    t=61 的 ins_4(60,0) —— 目标时间 60、位移 0 ⇒ 跳回**它自己**，之后每帧都在
    ---    60↔61 之间空转（原作拿它当 `while(true){}` 的停车位；Sub6 是独立上下文，
    ---    一旦起了就自己跑）。
    ---  · ★ Sub4（@804）在 ecl19_d 里**没有任何 ins_117 引用它**（对比 ecl18_d 的 Sub3
    ---    里有 ins_117(0,4)）—— 是一段死代码：跟 ecl18_d 的「一帧摆 25 个发射点」同构，
    ---    但没有那两句 ins_147，只 ins_100 设完偏移又 ins_100(0,0) 复位、ins_53 自灭，
    ---    净效果为零。照原作**不实现**（本体 shootOffset 全程是 (0,0)，两圈从本体出膛）。
    ---  · Sub5（@1108）：每帧两句 ins_150(8)（在 worldPosition+shootOffset 生成 ANM 装饰），
    ---    t=1 的 ins_4(0,−32) 跳回自己 ⇒ 无限刷装饰。不实现（本仓库不做这种装饰）。
    ---  · Sub6（@1184，一轮 16 帧，@1960 的 ins_4(0,−696) 跳回 @1264）：
    ---      · **进 Sub6 时只做一次**（都在 @1264 的跳回点之前）：
    ---          ins_101(0, 0x400 BOUNCE_ALL, allow=0, i0=999, f0=−999⇒用当前速)；
    ---          floatV0 = rand(−π,π)、floatV1 = rand(−π,π)（这对基准角只抽一次，
    ---          循环里不再重抽，只按下面的步长慢慢转）。
    ---        ★ @1184 的 BOUNCE 记录紧接着被 @1308 的 WAIT 记录**覆盖**（两句的 slot 都
    ---          是 0，ins_101 是按下标写表、不是追加）⇒ 这一圈弹其实**不反弹**，flags 里的
    ---          0x400 因此空转。这是原作的写法，照抄（不像卡 484 那样留永久反弹弹）。
    ---      · 每轮（第一帧 = @1264）：
    ---          extraIntV1 = 32 + 2×photoIndex（ins_22 乘 + ins_10 加）—— 两圈各自的发数；
    ---          写 slot0..5（表 A）→ ins_89 CIRCLE(型3 ball_small、色6、c1=extraIntV1、c2=1、
    ---                              速 1.2、基角 floatV0、步长 π/2、flags 0x8222) ⇒ 色 6 一圈；
    ---        t=8：把 slot0..5 再写一遍（表 B，f0/f1 全部取反）→
    ---             ins_89 CIRCLE(色8、基角 floatV1、其余同上) ⇒ 色 8 一圈；
    ---             floatV0 += 1.5°、floatV1 −= 2°（都走 ins_37 归一化）；
    ---        t=16：跳回。
    ---      · 6 条记录（TH095 口径；kind / allow / i0 / f0 / f1）：
    ---          slot0 WAIT (0x8000) i0=60                                     ← 先直飞 60 帧
    ---          slot1 POLAR(0x20)   i0=60  f0=−1/60   f1=+0.45°/帧
    ---          slot2 POLAR         i0=60  f0=+1/60   f1=−0.45°/帧
    ---          slot3 POLAR         i0=30  f0=0       f1=+0.45°/帧
    ---          slot4 POLAR         i0=30  f0=+1/60   f1=−0.45°/帧
    ---          slot5 POLAR         i0=30  f0=−1/60   f1=0
    ---        （色 8 那一路 = 表 B：把上表 slot1..5 的 f0、f1 全部取反。）
    ---      · 换算：我们的角 = −TH095 角（文件头「坐标系与角度」）⇒ TH095 的
    ---        +0.00785398 rad（=0.45°）在我们这里就是 −0.45°。SG_POLAR 的 f0 是
    ---        「每帧速度增量」（世界单位）、f1 是「每帧角增量（我们的度）」
    ---        —— hook 口径见上面 sg_tr_hook（:5777 起）。
    ---      · 一颗弹的总行程：60 帧直飞 → 再 60+60+30+30+30 = 210 帧程序，速度
    ---        1.2→0.2→1.2（前两段）→1.2（slot3，只自转 13.5°）→1.7→1.2。
    ---        ★ 这些弹不反弹，出屏（x+宽≤−192 / x−宽≥192 / y+高≤0 / y−高≥448）
    ---          就被原作回收（BulletManager.cpp:1506-1512 的 offscreen 判定）——
    ---          不像卡 484 那样无限累积；峰值仍是本组最高的一张（每 8 帧一圈、
    ---          每圈最多 46 发、寿命约 270 帧）。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(192)              -- 0 / 32
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL

    local PHOTO_LIMIT = 7                               -- ins_141(7)
    local CARD_NAME = "新難題「ミステリウム」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 485

    ---Sub6 的一轮 16 帧：色 6 在 t=0、色 8 在 t=8，然后 t=16 跳回。
    local RING_GAP = 8                                  -- 两圈的间隔（也是半轮长）
    local RING_SPEED = 1.2                              -- ins_89 的 speed1（c2=1 ⇒ 全部用它）
    local RING_BASE, RING_STEP = 32, 2                  -- extraIntV1 = RING_BASE + RING_STEP×拍照数
    local RING_DRIFT_A = 1.5                            -- floatV0 每轮 +1.5°（TH095）⇒ 我们 −1.5°
    local RING_DRIFT_B = 2.0                            -- floatV1 每轮 −2.0°（TH095）⇒ 我们 +2.0°
    local ROT = 0.45                                    -- 0.00785398 rad = 0.45°/帧
    local UP, DN = 0.0166667, -0.0166667                -- ±1/60 世界单位/帧
    local RING_FLAGS = 0x8222                           -- 0x8000 WAIT + 0x200 音 + 0x20 POLAR + 0x2 FAST

    ---表 A（色 6）：先等 60 帧，再减速 60 → 加速 60 → 只自转 30 → 加速 30 → 减速 30。
    local TR_A = {
        sg_rec(SG_WAIT,  0, 60, -1, -1,  -1),
        sg_rec(SG_POLAR, 0, 60, -1, DN,  -ROT),
        sg_rec(SG_POLAR, 0, 60, -1, UP,  ROT),
        sg_rec(SG_POLAR, 0, 30, -1, 0,   -ROT),
        sg_rec(SG_POLAR, 0, 30, -1, UP,  ROT),
        sg_rec(SG_POLAR, 0, 30, -1, DN,  0),
    }
    ---表 B（色 8）：与 A 逐项镜像（f0、f1 同时取反）。
    local TR_B = {
        sg_rec(SG_WAIT,  0, 60, -1, -1,  -1),
        sg_rec(SG_POLAR, 0, 60, -1, DN,  ROT),
        sg_rec(SG_POLAR, 0, 60, -1, UP,  -ROT),
        sg_rec(SG_POLAR, 0, 30, -1, 0,   ROT),
        sg_rec(SG_POLAR, 0, 30, -1, UP,  -ROT),
        sg_rec(SG_POLAR, 0, 30, -1, DN,  0),
    }

    local st = { dead = false }
    local hook_a = sg_tr_hook(TR_A, RING_FLAGS)
    local hook_b = sg_tr_hook(TR_B, RING_FLAGS)

    ---Sub6：每 16 帧两整圈。基准角在 TH095 空间是 rand(−π,π)，整圈取反后方向集合不变，
    ---但每轮的漂移方向要跟着取反 ⇒ a6 每轮 −1.5°、a8 每轮 +2°。
    local function run_sub6(owner)
        task.New(owner, function()
            local a6 = sg_deg(ran:Float(-math.pi, math.pi))     -- floatV0（只抽一次）
            local a8 = sg_deg(ran:Float(-math.pi, math.pi))     -- floatV1（只抽一次）
            while not st.dead do
                local n = RING_BASE + RING_STEP * photo_index(PHOTO_LIMIT)
                sg_shot(89, ball_small, ex_color(6), owner.x, owner.y,
                        n, 1, RING_SPEED, 0, a6, 90, false, RING_FLAGS, hook_a)
                task.Wait(RING_GAP)
                if st.dead then return end
                sg_shot(89, ball_small, ex_color(8), owner.x, owner.y,
                        n, 1, RING_SPEED, 0, a8, 90, false, RING_FLAGS, hook_b)
                task.Wait(RING_GAP)
                a6 = a6 - RING_DRIFT_A
                a8 = a8 + RING_DRIFT_B
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---到这里是原作 Sub2 的 t=130 = Sub3 的 t=0。
            PlaySound("tan00", 0.1, self.x / 256, false)   -- Sub3 t=0 的 ins_106(5)
            task.Wait(60)
            if st.dead then return end
            run_sub6(self)                                  -- t=60 的 ins_117(0,6)
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
    end

    boss.card.add({ { card, "10a" } }, LEVEL, CARD_NAME, CARD_ID)
end--新難題「ミステリウム」

---──────────────────── Stage 7（scene group 6 = world07）── 公共工具 ────────────────────
---原作 scene group 6 是 scene 60..67（th095/src/SceneSelect.cpp:126-133）：
---  60 ecl14_a 咲夜 非符                       61 ecl15_a レミリア 魔符「全世界ナイトメア」
---  62 ecl14_b 咲夜 時符「トンネルエフェクト」   63 ecl15_b レミリア 紅符「ブラッディマジックスクウェア」
---  64 ecl14_c 咲夜 空虚「インフレーションスクウェア」 65 ecl15_c レミリア 紅蝙蝠「ヴァンパイリッシュナイト」
---  66 ecl14_d 咲夜 銀符「パーフェクトメイド」   67 ecl15_d レミリア 神鬼「レミリアストーカー」
---八幕共用 world07.std / enm14,15.anm / bgm th095_03.wav（= music.lua 的 "TH07_1"）。
---数据源是 /tmp/N_ecl14_{a..d}.txt 与 /tmp/N_ecl15_{a..d}.txt（脚本 /tmp/d95c.py 不入库；
---ECL 在 `[th095] …/data/ecl1{4,5}_*.ecl`），各卡注释里的「@地址」都指这几份 dump。
---按「一个角色一个组」（文件头 §8）拆：组 11 = 咲夜（60/62/64/66）、组 12 = レミリア（61/63/65/67）。
---
---★ 八张卡的 Sub2 骨架**完全一样**（只有 ins_64 的目标 y 与 ins_75 的框不同）：
---   ins_55(2)/81(3)/109(0)/77(24,24)/141(N)/108(0,31)/108(1,30)/143(1,130)
---   + ins_63(-128,-64) 进场 → t=100 ins_64(30,4,0,Y) → t=130（咲夜 60 是 id=0 的 NOP，
---   其余七张是 ins_104 亮卡名）+ ins_75(box) + ins_149(分数倍率) + ins_52(3)。
---   世界坐标换算：我们的 y = field_y(TH095 的 y) = 224 − y。
---
---★ 立绘：咲夜 "Sakuya"、レミリア "Remilia"（BossImageList.lua:17-18 都登记过）。
---★ Sub2 里的 ins_115（只有 ecl14_a 用）见卡 60 注释：它把主上下文在第 3/6 帧整个
---   重启到 Sub7/Sub11，所以 ecl14_a 的实际主脚本是 Sub11。

---──────────────────── Stage 7 咲夜 非符（ecl14_a，组 11a 第 1 张） ────────────────────
do  -- 60 咲夜 非符（ecl14_a，组 11a 第 1 张）
    ---原作这一关**没有** ins_104（t=130 的 id=0 在 EclRunLow.inl 的 switch 里没有分支
    ---⇒ NOP），是一个前哨：本体站定不动，每隔一段放 4 只「小刀妖精」子机；子机朝四个
    ---方向飞出去，各自每 4 帧甩一圈 8 发小刀，小刀飞 20 帧后拐一次弯、再飞 20 拐一次。
    ---骨架（/tmp/N_ecl14_a.txt）：
    ---  · Sub2 @416：… ins_115(0,3,7) + ins_115(1,6,11)（见文件头 §ins_115）⇒ 实际进
    ---    Sub11（Sub7 只活 3 帧）。
    ---  · Sub11 @2052 周期 155：t=30 ins_102（清屏）+ ins_149(0.6) + ins_117(0,12)
    ---    （放 4 只子机）；t=125 ins_67(60,4,1.4)（在活动框里漂）；t=185 ins_4(30,-60)
    ---    跳回 t=30 ⇒ 一輪 155 帧。
    ---  · Sub12 @2192（子机发生器）：連写 extraFloatV2/V3/floatV1 后 ins_83(14) 生 4 只
    ---    子敌机（ins_83 把父上下文的 0x80 字节变量块整个拷进子，EclRunTargetHigh.inl:271）。
    ---    (V2, V1) = (π, +π/16) / (0, −π/16) / (3π/4, −π/8) / (π/4, +π/8)，速度 V3 = 0.4。
    ---  · Sub14 @2868（子机）：ins_65(extraFloatV2, extraFloatV3) 定移动方向/速度，
    ---    ins_117(1,13) 起发弹器，160 帧后收掉，t=174 ins_1 结束（= 子机寿命 174 帧）。
    ---  · Sub13 @2460（发弹器）：t=30 写 6 条 ins_101（WAIT20 / CHDIR_REL floatV2 / WAIT20 /
    ---    CHDIR_REL / WAIT20 / CHDIR_REL），再 ins_89 CIRCLE(型 14 色 2、8 发、速 4、
    ---    基角 π/2+floatV1、步长 0.1848、flags 33346)；t=34 ins_4(30,-44) 跳回 ⇒ 每 4 帧一圈。
    ---    0.1848 rad = 10.588°（CIRCLE 的 count2=1 ⇒ 这个步长不参与，8 发均匀 45°）。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)     -- 288（场地外）
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL
    local PHOTO_LIMIT = 9                               -- ins_141(9)
    local CARD_NAME = ""                                -- 非符：没有 ins_104
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 486

    local BOX = { -160, 96, 160, 192 }                  -- ins_75（TH095 坐标）
    local DRONE_SPEED = 0.4                             -- extraFloatV3
    local DRONE_FLAGS = 0x8242                          -- flags 33346（WAIT|音|CHDIR_REL|FAST）
    local DRONE_STEP = 10.5880                          -- 0.1848 rad（CIRCLE 的 angleStep）
    local DRONE_BASE = 90                               -- floatV0 = π/2 的底（TH095 空间）
    ---{ 我们的移动方向, 我们的转角(f0), TH095 基准角 } —— 原始 operand 见 Sub12/Sub14。
    ---我方角度 = −TH095 角度：V2=π→180、V2=0→0、V2=3π/4→−135、V2=π/4→−45；
    ---CHDIR_REL 的 f0 = −floatV1；基准角 = π/2 + floatV1（TH095）。
    local DRONE_THREAD = {
        {  180, -11.25, 101.25 },                       -- V2=π,    V1=+π/16
        {    0,  11.25,  78.75 },                       -- V2=0,    V1=−π/16
        { -135,  22.5,   67.5  },                       -- V2=3π/4, V1=−π/8
        {  -45, -22.5,  112.5  },                       -- V2=π/4,  V1=+π/8
    }

    local st = { dead = false }
    local drones = {}

    ---一条记录表给所有小刀共用（sg_tr_hook 的状态挂在**每颗弹自己**身上，闭包可以复用）。
    local function zigzag(turn)
        return sg_tr_hook({
            sg_rec(SG_WAIT,    0, 20, -1, -1, -1),
            sg_rec(SG_CHDIR_R, 0, 1, 1, turn, -999),
            sg_rec(SG_WAIT,    0, 20, -1, -1, -1),
            sg_rec(SG_CHDIR_R, 0, 1, 1, turn, -999),
            sg_rec(SG_WAIT,    0, 20, -1, -1, -1),
            sg_rec(SG_CHDIR_R, 0, 1, 1, turn, -999),
        }, DRONE_FLAGS)
    end

    ---小刀子机（原作是真子敌机；这里按文件头差异 5 改成**有寿命的自绘 object**）。
    class.s7a_drone = Class(object, {
        init = function(self, owner, dir, turn, base_th)
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false                           -- 自己管回收
            self.x, self.y = owner.x, owner.y
            self.rot, self._a = 0, 0
            object.SetV(self, DRONE_SPEED, dir, true)
            local hook = zigzag(turn)
            ---★ frame 里必须自己 task.Do(self)：真机只有 `_object`（misc.lua:13）和
            ---  bullet 才带 task.Do，`Class(object, {...})` 的子类没有 —— 漏了协程就永远
            ---  不 resume（卡 71 的 moth / 卡 80 的 nightmare_drone 就踩过这个坑）。
            task.New(self, function()
                for _ = 1, 8 do
                    self._a = min(200, self._a + 25)
                    task.Wait()
                end
                ---Sub13：每 4 帧 8 发，共 40 轮（160 帧，与子机 174 帧寿命对齐）。
                for _ = 1, 40 do
                    sg_shot(89, ball_mid, ex_color(2), self.x, self.y,
                            8, 1, 4, 1.5, base_th, DRONE_STEP, false, DRONE_FLAGS, hook)
                    task.Wait(4)
                end
                for _ = 1, 14 do
                    self._a = max(0, self._a - 200 / 14)
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            task.Do(self)
            self.rot = self.rot + 6                      -- 小刀自转
        end,
        render = function(self)
            SetImageState("servant", "mul+add", self._a, 220, 228, 255)
            Render("servant", self.x, self.y, self.rot, 0.9)
        end,
    })

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
        drones = {}
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            while not st.dead do
                task.Wait(30)                            -- Sub11 t=30
                if st.dead then return end
                sg_clear({})                             -- ins_102
                for _, d in ipairs(DRONE_THREAD) do
                    drones[#drones + 1] = New(class.s7a_drone, self, d[1], d[2], d[3])
                end
                task.Wait(95)                            -- t=125
                if st.dead then return end
                sg_bmove(self, st, 60, 4, 1.4, BOX)      -- ins_67(60,4,1.4)
                task.Wait(60)                            -- t=185 → 回 t=30
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        for i = #drones, 1, -1 do
            if IsValid(drones[i]) then
                task.Clear(drones[i])
                object.RawDel(drones[i])
            end
        end
        drones = {}
    end

    boss.card.add({ { card, "11a" } }, LEVEL, CARD_NAME, CARD_ID)
end--咲夜 非符（ecl14_a）

---──────────────────── Stage 7 魔符「全世界ナイトメア」（ecl15_a，组 12a 第 1 张） ────────────────────
do  -- 61 レミリア 魔符「全世界ナイトメア」（ecl15_a，组 12a 第 1 张）
    ---原作是「满世界的蝙蝠」：本体在框里漂，**每 96 帧**放一只蝙蝠（子机）到处飞，
    ---蝙蝠越飞越快；另外两条发弹上下文（Sub5 窄扇 / Sub6 整圈）的弹数都写成
    ---`int(photosTaken/7)` 与 `int(photosTaken/15)` —— 这一关的快门上限只有 3（ins_141(3)），
    ---**永远算得出 0 发**，所以这一张的威胁全在蝙蝠身上（这正是原作的样子）。
    ---骨架（/tmp/N_ecl15_a.txt）：
    ---  · Sub2：t=130 ins_104 亮卡名 + ins_75(-160,96,160,192) + ins_149(2)。
    ---  · Sub3 @684：t=0 起装饰 Sub7；t=60 起 Sub4（蝙蝠发生器）+ 音效；t=90 起 Sub5（slot1）/
    ---    Sub6（slot2）+ ins_67；t=210 亮卡名 + 起 Sub7（slot3）；t=270 再起一轮并重复。
    ---  · Sub4 @1164：extraIntV0=96，`ins_83(8)` 每 96 帧生一只 Sub8；V2 = rand[0,π)、V3 = rand[0,2)。
    ---  · Sub8 @2080（蝙蝠）：ins_65(V2,V3)（随机方向、随机初速）+ ins_71(0.0666667)
    ---    （加速度 = 1/15 世界单位/帧）；t=300 ins_1 结束。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL
    local PHOTO_LIMIT = 3                               -- ins_141(3)
    local CARD_NAME = "魔符「全世界ナイトメア」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 487

    local BOX = { -160, 96, 160, 192 }
    local BAT_GAP, BAT_LIFE, BAT_ACC = 96, 300, 1 / 15

    local st = { dead = false }
    local bats = {}

    class.s7b_bat = Class(object, {
        init = function(self, owner)
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false
            self.x, self.y = owner.x, owner.y
            self.rot, self._a = 0, 0
            ---Sub8 的 ins_65(extraFloatV2, extraFloatV3)：方向 rand[0,π)（TH095）、速 rand[0,2)。
            self._dir = sg_deg(ran:Float(0, math.pi))    -- 我们的角度（度）
            self._sp = ran:Float(0, 2)
            object.SetV(self, self._sp, self._dir, true)
            task.New(self, function()
                for _ = 1, 8 do
                    self._a = min(210, self._a + 26)
                    task.Wait()
                end
                ---ins_71(0.0666667)：每帧 speed += 1/15，方向不变（加速直线）。
                for _ = 1, BAT_LIFE do
                    self._sp = self._sp + BAT_ACC
                    object.SetV(self, self._sp, self._dir, true)
                    task.Wait()
                end
                for _ = 1, 15 do
                    self._a = max(0, self._a - 210 / 15)
                    task.Wait()
                end
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            task.Do(self)
            self.rot = self.rot + 8
        end,
        render = function(self)
            SetImageState("butterfly6", "mul+add", self._a, 255, 120, 150)
            Render("butterfly6", self.x, self.y, self.rot, 1.0)
            SetImageState("butterfly4", "mul+add", self._a * 0.6, 220, 90, 130)
            Render("butterfly4", self.x - cos(self.rot) * 10, self.y - sin(self.rot) * 10,
                    self.rot + 40, 0.7)
        end,
    })

    ---Sub5（slot1）：每 4 帧一轮、一轮 3 把窄扇（每把再 +120°）；弹数 = int(photosTaken/7)。
    ---本移植用每卡拍中数（photo_index）替代全关卡累计的 photosTaken ⇒ PHOTO_LIMIT=3 时恒 0 发。
    local function run_fan5(owner)
        task.New(owner, function()
            while not st.dead do
                local n = math.floor(photo_index(PHOTO_LIMIT) / 7)
                local a = sg_aim(owner.x, owner.y)
                for _ = 1, 3 do
                    sg_shot(87, sg_style(4), ex_color(2), owner.x, owner.y,
                            n, 1, 4, 1.5, a, 5.625, false, 514, nil)
                    a = a + 120
                end
                task.Wait(4)
            end
        end)
    end

    ---Sub6（slot2）：每 60 帧一圈；弹数 = int(photosTaken/15)（同样是 0）。
    local function run_fan6(owner)
        task.New(owner, function()
            while not st.dead do
                local n = math.floor(photo_index(PHOTO_LIMIT) / 15)
                sg_shot(88, sg_style(12), ex_color(1), owner.x, owner.y,
                        n, 1, 1, 1.5, sg_aim(owner.x, owner.y), 5.625, false, 514, nil)
                task.Wait(60)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
        bats = {}
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---t=60 起蝙蝠发生器；t=90 起两条发弹上下文（都是 0 发，忠实保留公式）。
            run_fan5(self)
            run_fan6(self)
            task.Wait(60)
            if st.dead then return end
            PlaySound("tan00", 0.1, self.x / 256, false)
            local n = 0
            while not st.dead do
                if n % BAT_GAP == 0 then
                    bats[#bats + 1] = New(class.s7b_bat, self)
                end
                n = n + 1
                ---Sub3 的两把 ins_67（60,1,0.5）/（60,4,0.5）。
                if n % 120 == 1 then
                    sg_bmove(self, st, 60, 1, 0.5, BOX)
                elseif n % 120 == 61 then
                    sg_bmove(self, st, 60, 4, 0.5, BOX)
                end
                task.Wait()
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        for i = #bats, 1, -1 do
            if IsValid(bats[i]) then
                task.Clear(bats[i])
                object.RawDel(bats[i])
            end
        end
        bats = {}
    end

    boss.card.add({ { card, "12a" } }, LEVEL, CARD_NAME, CARD_ID)
end--魔符「全世界ナイトメア」

---──────────────────── Stage 7 時符「トンネルエフェクト」（ecl14_b，组 11a 第 2 张） ────────────────────
do  -- 62 咲夜 時符「トンネルエフェクト」（ecl14_b，组 11a 第 2 张）
    ---原作是「一条穿过自己的隧道」：本体停在 (0,160)（我们的 (0,64)），一圈一圈地放：
    ---  · Sub5 @1128：进每轮 t=0 时**一圈** type14/色1 的整圈弹，弹数 = 16 + 8×photoIndex；
    ---  · Sub6..9 @1300/1792/2304/2796：四条并行上下文，把发弹点放在**离本体 160 px、
    ---    角度 extraFloatV2 的点**上，每轮转 2π/(8+4×photoIndex)，每次发 3 发（c1=1、c2=3）
    ---    速度 4 / 3.167 / 2.333、方向 = 环上角度 − π。四条只在「上/下」与「顺时针/逆时针」
    ---    上两两不同 ⇒ 看起来像四股沿着隧道内壁扫过去的弹流。
    ---  · Sub4 @980 在每轮 t=120 接管 slot0：每 15 帧一把 3 发**大玉**（型 17，直径 28
    ---    ⇒ ball_huge）、加了自机角的 FAN_AIMED、散布 72°。
    ---骨架（/tmp/N_ecl14_b.txt）：
    ---  · Sub2：t=130 亮卡名 + ins_75(-160,144,160,224) + ins_149(2) + ins_52(3)。
    ---  · Sub3 @736：t=0 ins_117(0,5)…(4,9)（五条上下文）+ extraIntV1=60；t=60 音/ins_67(60,4,1)；
    ---    t=120 ins_117(0,4)（slot0 换成大玉）+ ins_118(19)；t=150 ins_144(15)；
    ---    t=195 ins_4(0,-192) 回 t=0 ⇒ 一輪 195 帧。
    ---  · Sub6 的运算（@1396-1744）**逐条核过**：extraIntV0 = (16+8×photoIndex)/2；
    ---    floatV7 = 2π/extraIntV0；38(floatV2,floatV3, ±π/2, 160) → 环上一点；再
    ---    26/26 把自己（world.x/y）减掉，得到相对本体的 shootOffset（0, ∓160）；
    ---    floatV4 = extraFloatV2 + (−π)（ins_25）；87 FAN(型14色3, 1, 3, 4, 1.5, floatV4,
    ---    0.1848, 512)；floatV7 每轮加/减后归一化（Sub6/8 加、Sub7/9 减）。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(160)              -- 0 / 64
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL
    local PHOTO_LIMIT = 5                               -- ins_141(5)
    local CARD_NAME = "時符「トンネルエフェクト」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 488

    local BOX = { -160, 144, 160, 224 }
    local CYCLE = 195
    local RING_R = 160                                  -- extraFloatV3
    local st = { dead = false }

    ---Sub5：进每轮 t=0 时一圈（一次，不重复）。
    local function ring_burst(owner)
        local n = 16 + 8 * photo_index(PHOTO_LIMIT)
        sg_shot(89, sg_style(14), ex_color(1), owner.x, owner.y,
                n, 1, 2, 1.5, 0, 5.625, false, 514, nil)
    end

    ---Sub6..9：一条「隧道内壁」弹流。sign = +1 表示环角每轮 +2π/n（Sub6/8），−1 = Sub7/9；
    ---up = +1 表示环点在 −π/2（本体上方，Sub6/7），−1 = +π/2（下方，Sub8/9）。
    local function tunnel_stream(owner, sign)
        task.New(owner, function()
            local n = 8 + 4 * photo_index(PHOTO_LIMIT)   -- extraIntV0 = (16+8p)/2
            local step = 360 / n                          -- floatV7 = 2π/extraIntV0（度）
            local ang = -90                               -- extraFloatV2 = −π/2（TH095，度）
            for _ = 1, n do
                ---环上一点（TH095 空间）→ 我们 = (x, −y) 的偏移。
                local px = owner.x + RING_R * math.cos(math.rad(ang))
                local py = owner.y - RING_R * math.sin(math.rad(ang))
                ---方向 = 环上角度 − π（TH095）⇒ base 直接给 TH095 度数（sg_shot 内部取反）。
                sg_shot(87, sg_style(14), ex_color(3), px, py,
                        1, 3, 4, 1.5, ang - 180, 5.625, false, 512, nil)
                ang = ang + sign * step
                if st.dead then return end
                task.Wait()
            end
        end)
    end

    ---Sub4：每 15 帧一把 3 发大玉（型 17 = ball_huge）、FAN_AIMED、散布 72°。
    local function huge_fan(owner)
        task.New(owner, function()
            for _ = 1, 5 do                              -- t=120..195 只有 5 个周期
                sg_shot(86, sg_style(17), ex_color(0), owner.x, owner.y,
                        3, 1, 3.5, 1.5, 0, 36, true, 514, nil)
                if st.dead then return end
                task.Wait(15)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            while not st.dead do
                ring_burst(self)                         -- Sub5 @ t=0
                tunnel_stream(self,  1)                  -- Sub6：上方、+step
                tunnel_stream(self, -1)                  -- Sub7：上方、−step
                tunnel_stream(self,  1)                  -- Sub8：下方、+step
                tunnel_stream(self, -1)                  -- Sub9：下方、−step
                task.Wait(60)                            -- t=60
                if st.dead then return end
                sg_bmove(self, st, 60, 4, 1, BOX)        -- ins_67(60,4,1)
                task.Wait(60)                            -- t=120
                if st.dead then return end
                huge_fan(self)                           -- Sub4 接管 slot0
                task.Wait(CYCLE - 120)
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
    end

    boss.card.add({ { card, "11a" } }, LEVEL, CARD_NAME, CARD_ID)
end--時符「トンネルエフェクト」

---──────────────────── Stage 7 紅符「ブラッディマジックスクウェア」（ecl15_b，组 12a 第 2 张） ────────────────────
do  -- 63 レミリア 紅符「ブラッディマジックスクウェア」（ecl15_b，组 12a 第 2 张）
    ---原作是「血色的魔法阵」：本体停在 (0,160)（我们的 (0,64)），每轮甩出**一圈 12 颗**
    ---慢速方块（型 14 色 1，速 0.3，每颗差 30°）；每颗方块自己**不断**再炸出朝某方向
    ---漂走的子弹 —— 方块上挂的 ins_101 表（@932-1132）逐条核过：
    ---  slot0 0x400000 SPAWN_CHILD_PATTERN：packed=0x01010208 ⇒ aim=FAN(1)、型 1、色 2、
    ---        子弹出厂就从**第 8 条记录**起跑；count1=1、speed1=speed2=0；子表 flags=0x8212。
    ---  slot1 是 slot0 的 secondary（count2=1、angle=floatV0、angleStep=0）——它的 kind
    ---        字段（0x800000）是**填充值**，运行时不会读。
    ---  slot2 0x20 ACCEL_POLAR：0.033333/帧 的加速 + ±1°/帧 的自转，持续 extraIntV1 帧。
    ---  slot3 0x2000000 JUMP 到第 0 条 ⇒ 方块每（extraIntV1+1）帧再炸一颗、无限循环。
    ---  slot8 0x8000 WAIT 120、slot9 0x10 ACCEL_VEC(240 帧、0.008333/帧、用出厂角) ⇒
    ---        子弹（从 slot8 起跑）先**定住 120 帧**，再沿自己出厂的方向慢慢加速出去。
    ---  extraIntV1 = 9 − photoIndex（ins_21 是 op1 − op2，@908）⇒ 拍得越多炸得越密。
    ---骨架（/tmp/N_ecl15_b.txt）：
    ---  · Sub2：t=130 ins_104 + ins_75(-160,144,160,224) + ins_149(2.7) + ins_52(3)。
    ---  · Sub3 @716：t=60 ins_117(0,4)；t=180 ins_67(60,4,2)；t=240 ins_144(15) + ins_117(0,4)；
    ---    t=240 ins_4(60,-60) 跳回 t=60 ⇒ 一輪 180 帧（且每轮把方块的基准角再转 30°）。
    ---  · Sub4 @848：floatV1=−π、floatV0=rand(−π,π)、extraIntV0=12；写 6 条 ins_101 后
    ---    ins_89 CIRCLE(型14色1, c1=1, c2=1, sp1=0.3, base=floatV1, 步长 0.1848, flags
    ---    0x02400222)；floatV1 += 30°、floatV0 −= 5.625°；ins_5(0,-324,12) 把整段跑 12 次。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(160)              -- 0 / 64
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL
    local PHOTO_LIMIT = 7                               -- ins_141(7)
    local CARD_NAME = "紅符「ブラッディマジックスクウェア」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 489

    local BOX = { -160, 144, 160, 224 }
    local CYCLE = 180
    local SQ_FLAGS = 0x02400222                         -- CHILD | JUMP | 音 | POLAR | FAST
    local CHILD_FLAGS = 0x8212                          -- WAIT | 音 | ACCEL_VEC | FAST
    local st = { dead = false }

    ---方块的表：前半跑「炸子弹」，后半（slot8/9）是给子弹跑的那一段。
    local function square_recs(dur, ang_delta)
        return {
            sg_rec(SG_CHILD, 0, 0x01010208, 1, 0, 0),    -- slot0：packed/angleStep 已算好
            sg_rec(0,       0, 1, CHILD_FLAGS, 0, 0),    -- slot1：secondary 占位（kind 不重要）
            sg_rec(SG_POLAR, 0, dur, -1, 0.0333333, ang_delta),
            sg_rec(SG_JUMP,  0, 0, -1, -1, -1),          -- slot3：跳回 slot0
            sg_rec(0, 0, 0, 0, 0, 0), sg_rec(0, 0, 0, 0, 0, 0),
            sg_rec(0, 0, 0, 0, 0, 0), sg_rec(0, 0, 0, 0, 0, 0),
            sg_rec(SG_WAIT,  0, 120, -1, -1, -1),        -- slot8：子弹先定住 120 帧
            sg_rec(SG_VEC,   0, 240, -1, 0.0083333, -999.99),
        }
    end

    ---Sub4：一圈 12 颗方块（全部在同一帧里发出来；floatV1 每颗 +30°）。
    local function square_ring(owner)
        local dur = 9 - photo_index(PHOTO_LIMIT)         -- extraIntV1
        local a = -180                                   -- floatV1 起手 −π（TH095 度）
        for _ = 1, 12 do
            local hook = sg_tr_hook(square_recs(dur, 1), SQ_FLAGS)
            sg_shot(89, sg_style(14), ex_color(1), owner.x, owner.y,
                    1, 1, 0.3, 1.5, a, 10.5880, false, SQ_FLAGS, hook)
            a = a + 30
            if a >= 180 then a = a - 360 end
        end
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            while not st.dead do
                square_ring(self)
                task.Wait(120)                            -- t=120（Sub3 的 t=180 相位）
                if st.dead then return end
                sg_bmove(self, st, 60, 4, 2, BOX)         -- ins_67(60,4,2)
                task.Wait(CYCLE - 120)
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
    end

    boss.card.add({ { card, "12a" } }, LEVEL, CARD_NAME, CARD_ID)
end--紅符「ブラッディマジックスクウェア」

---──────────────────── Stage 7 空虚「インフレーションスクウェア」（ecl14_c，组 11a 第 3 张） ────────────────────
do  -- 64 咲夜 空虚「インフレーションスクウェア」（ecl14_c，组 11a 第 3 张）
    ---原作是「不断膨胀的方块」：本体停在 (0,224)（我们的 (0,0)），一条上下文分两段：
    ---  ① @944-1404：30 轮、每轮 2 发 —— 绕着**自机前方 96 px 的那个点**（38/15/15/26/26/100）
    ---     发 type4/色2 的单发（86 FAN_AIMED、速 2），每轮把基准角 +6°；
    ---  ② @1428-1832（本卡核心）：每轮在场地里随机抽一个点（x∈±192、y∈[0,448] TH095），
    ---     离自机 < 64 px 就**重抽**（ins_45 float< 跳回），否则在那个点发一颗 type14/色3、
    ---     速度 = 1 + 0.2×photoIndex、方向 = rand(−π,π) + 自机角（86 FAN_AIMED）。
    ---骨架（/tmp/N_ecl14_c.txt）：
    ---  · Sub2：t=130 ins_104 + ins_75(-160,96,160,256) + ins_149(2.1) + ins_52(3)。
    ---  · Sub3 @716：t=60 ins_117(0,4)；t=180 ins_117(0,-1) 收掉；t=315 ins_67(60,4,1)；
    ---    t=375 ins_4(0,-136) ⇒ 一輪 375 帧（只有前 120 帧在发弹）。
    ---  · Sub4 @904：floatV1=−π（随后被 world.y 覆盖）、extraIntV0=30、extraFloatV2=π。
    ---    ins_5(0,-400,30)（t=1）⇒ ① 段跑 30 次；② 段的 ins_5(1,-296,4) + ins_4(1,-384)
    ---    是「每 4 次重抽一轮」的写法，等价于连续循环。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(224)              -- 0 / 0
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL
    local PHOTO_LIMIT = 6                               -- ins_141(6)
    local CARD_NAME = "空虚「インフレーションスクウェア」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 490

    local BOX = { -160, 96, 160, 256 }
    local CYCLE = 375
    local R = 96                                        -- ① 段的半径（extraFloatV3）
    local st = { dead = false }

    ---① 段：30 轮 × 2 发，绕着自机前方 96 px 的点。
    local function phase1(owner)
        task.New(owner, function()
            local ang = 180                             -- extraFloatV2 = π（TH095 度）
            for _ = 1, 30 do
                local px = player.x + R * math.cos(math.rad(ang))
                local py = player.y - R * math.sin(math.rad(ang))
                for k = 1, 2 do
                    sg_shot(86, sg_style(4), ex_color(2), px, py,
                            1, 1, 2, 1.5, 0, 36, true, 514, nil)
                    ang = ang + 6                       -- extraFloatV2 += 6°
                    px = player.x + R * math.cos(math.rad(ang))
                    py = player.y - R * math.sin(math.rad(ang))
                end
                if st.dead then return end
                task.Wait(1)
            end
        end)
    end

    ---② 段：随机点撒弹（速度 1 + 0.2×photoIndex），离自机太近就重抽。
    ---Sub3 在 t=180 用 ins_117(0,-1) 把 Sub4 整个收掉 ⇒ ② 段不是永生任务；
    ---stop 由主循环在 Sub4 的 120 帧窗口结束时置上，否则每轮都会多留一条常驻发弹线。
    local function phase2(owner, stop)
        task.New(owner, function()
            while not st.dead and not stop.on do
                local thx = ran:Float(-1, 1) * 192       -- randF32s × 192
                local thy = ran:Float(0, 1) * 448        -- randF32 × 448
                local px, py = thx, field_y(thy)         -- 我们的坐标
                local dx, dy = player.x - px, player.y - py
                if dx * dx + dy * dy >= 64 * 64 then
                    sg_shot(86, sg_style(14), ex_color(3), px, py,
                            1, 1, 1 + 0.2 * photo_index(PHOTO_LIMIT), 1.5,
                            sg_deg(ran:Float(-math.pi, math.pi)), 36, true, 514, nil)
                end
                task.Wait(1)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            while not st.dead do
                phase1(self)
                task.Wait(1)
                if st.dead then return end
                local stop = { on = false }
                phase2(self, stop)                       -- Sub4：t=60 起
                task.Wait(120)                           -- t=180 ins_117(0,-1) 收掉 Sub4
                stop.on = true
                if st.dead then return end
                task.Wait(CYCLE - 120)                   -- t=375 ins_4(0,-136) 跳回 t=60
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
    end

    boss.card.add({ { card, "11a" } }, LEVEL, CARD_NAME, CARD_ID)
end--空虚「インフレーションスクウェア」

---──────────────────── Stage 7 紅蝙蝠「ヴァンパイリッシュナイト」（ecl15_c，组 12a 第 3 张） ────────────────────
do  -- 65 レミリア 紅蝙蝠「ヴァンパイリッシュナイト」（ecl15_c，组 12a 第 3 张）
    ---原作是「成群的吸血蝙蝠」：本体在 (0,224)（我们的 (0,0)），每 10 帧在**自机周围 ±64**
    ---放一只蝙蝠；蝙蝠用 120 帧飞到那个点，落地时**清一次屏**（ins_112），然后按
    ---（60 − int(photoIndex/7)）帧的间隔发单发（速 1 + 0.1×photoIndex、方向 rand(−π,π)+自机角），
    ---坚持 600 帧。拍得越多，蝙蝠发得越快（间隔越短），子弹也越快。
    ---骨架（/tmp/N_ecl15_c.txt）：
    ---  · Sub2：t=130 ins_104 + ins_75(-160,96,160,256) + ins_149(4) + ins_52(3)。
    ---  · Sub3 @728：t=0 起装饰 Sub5；t=60 起 Sub4（蝙蝠发生器）；t=120 ins_67(60,4,1.5)；
    ---    t=180 ins_4(60,-24) ⇒ 一輪 120 帧。
    ---  · Sub4 @844：V0 = randF32s×64 + player.x、V1 = randF32s×64 + player.y；ins_83(6)；
    ---    t=10 ins_4(0,-104) ⇒ 每 10 帧一只。
    ---  · Sub6 @1084：ins_64(120,4,V0,V1)（120 帧飞过去）+ ins_112(7)（清屏）；
    ---    intV1 = photoIndex/7；intV1 = 60 − intV1；intV0 = 600/intV1；
    ---    floatV0 = 1 + photoIndex×0.1；86 FAN_AIMED(型14色1, c1=1, base=rand(−π,π), flags 514)；
    ---    ins_2(intV1)（冻结）；ins_5(120,-152,intV0) 循环；ins_1 结束。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(224)              -- 0 / 0
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL
    local PHOTO_LIMIT = 7                               -- ins_141(7)
    local CARD_NAME = "紅蝙蝠「ヴァンパイリッシュナイト」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 491

    local BOX = { -160, 96, 160, 256 }
    local BAT_GAP, BAT_ARRIVE, BAT_FIRE_LIFE = 10, 120, 600
    local st = { dead = false }
    local bats = {}

    class.s7c_bat = Class(object, {
        init = function(self, owner, tx, ty)
            self.group = GROUP.GHOST
            self.layer = LAYER.ENEMY_BULLET_EF
            self.colli = false
            self.bound = false
            self.x, self.y = owner.x, owner.y
            self.rot, self._a = 0, 0
            ---ins_64(120,4,tx,ty)：120 帧、缓动 4（1−(1−n)²）飞到那个点。
            sg_move(self, st, tx, ty, BAT_ARRIVE, 4)
            task.New(self, function()
                for _ = 1, 8 do
                    self._a = min(220, self._a + 28)
                    task.Wait()
                end
                task.Wait(BAT_ARRIVE)
                if not IsValid(self) then return end
                sg_clear({})                             -- ins_112(7)：落地清屏
                local gap = 60 - math.floor(photo_index(PHOTO_LIMIT) / 7)
                local n = math.floor(BAT_FIRE_LIFE / max(1, gap))
                local sp = 1 + 0.1 * photo_index(PHOTO_LIMIT)
                for _ = 1, n do
                    sg_shot(86, sg_style(14), ex_color(1), self.x, self.y,
                            1, 1, sp, 1.5,
                            sg_deg(ran:Float(-math.pi, math.pi)), 36, true, 514, nil)
                    if st.dead then return end
                    task.Wait(gap)                       -- ins_2(gap) + ins_5 的组合节拍
                end
                object.RawDel(self)
            end)
        end,
        frame = function(self)
            task.Do(self)
            self.rot = self.rot + 9
        end,
        render = function(self)
            SetImageState("butterfly6", "mul+add", self._a, 255, 110, 140)
            Render("butterfly6", self.x, self.y, self.rot, 1.1)
            SetImageState("butterfly2", "mul+add", self._a * 0.6, 230, 80, 120)
            Render("butterfly2", self.x - cos(self.rot) * 11, self.y - sin(self.rot) * 11,
                    self.rot + 50, 0.75)
        end,
    })

    ---Sub4：每 10 帧一只蝙蝠，落点 = 自机 ±64。
    local function run_spawner(owner)
        task.New(owner, function()
            while not st.dead do
                local tx = ran:Float(-1, 1) * 64 + player.x
                local ty = ran:Float(-1, 1) * 64 + player.y
                bats[#bats + 1] = New(class.s7c_bat, owner, tx, ty)
                task.Wait(BAT_GAP)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
        bats = {}
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub3 的 ins_4(60,-24) 跳回目标是 ins_67（@788），而起 Sub4 的 ins_117(@768)
            ---在跳回目标**之前** ⇒ 蝙蝠发生器只起一次。放进循环里重起会让发生器一帧多个
            ---（自检里 7200 帧堆到 3767 个 object），那是移植错误、不是原作行为。
            run_spawner(self)
            while not st.dead do
                task.Wait(60)
                if st.dead then return end
                sg_bmove(self, st, 60, 4, 1.5, BOX)      -- ins_67(60,4,1.5)
                task.Wait(60)
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        for i = #bats, 1, -1 do
            if IsValid(bats[i]) then
                task.Clear(bats[i])
                object.RawDel(bats[i])
            end
        end
        bats = {}
    end

    boss.card.add({ { card, "12a" } }, LEVEL, CARD_NAME, CARD_ID)
end--紅蝙蝠「ヴァンパイリッシュナイト」

---──────────────────── Stage 7 銀符「パーフェクトメイド」（ecl14_d，组 11a 第 4 张） ────────────────────
do  -- 66 咲夜 銀符「パーフェクトメイド」（ecl14_d，组 11a 第 4 张）
    ---原作是「两把相对旋转的银刀」：本体停在 (0,128)（我们的 (0,96)），两条上下文
    ---（Sub4 @940 / Sub5 @1192）每 8 帧各放一整圈小刀（型 14 色 3、速 2），
    ---圈数 = 8 + photoIndex（ins_6 复制 + ins_10 加 8）；两圈的基准角每轮一个 +6°、一个 −9°，
    ---所以两条反向的刀圈互相穿过。
    ---骨架（/tmp/N_ecl14_d.txt）：
    ---  · Sub2：t=130 ins_104 + ins_75(-160,96,160,192) + ins_149(3) + ins_52(3)。
    ---  · Sub3 @720：t=0 ins_119(20)（相机扫屏，不实现）+ ins_117(0,4)+ins_117(1,5)；
    ---    t=120 ins_0（NOP）+ ins_42(extraIntV2,0,…)（extraIntV2 从未写过非 0 ⇒ 恒假）
    ---    + ins_119(-1) + ins_144(30) + ins_67(40,4,2.6)；t=160 ins_119(20) + ins_4(0,-112)。
    ---  · Sub4/Sub5：floatV0 = π/2；ins_43(world.x, floatV1, …)（恒假，NOP）；
    ---    intV0 = photoIndex + 8；ins_89 CIRCLE(型14色3, c1=intV0, sp1=2, 步长 0.1848,
    ---    flags 514)；Sub4 每轮 floatV0 += 6°、Sub5 每轮 −9°。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL
    local PHOTO_LIMIT = 5                               -- ins_141(5)
    local CARD_NAME = "銀符「パーフェクトメイド」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 492

    local BOX = { -160, 96, 160, 192 }
    local GAP = 8
    local st = { dead = false }

    ---drift = 每轮基准角的变化（TH095 度）：Sub4 = +6、Sub5 = −9。
    local function ring(owner, drift)
        task.New(owner, function()
            local a = 90                                  -- floatV0 = π/2（TH095 度）
            while not st.dead do
                local n = 8 + photo_index(PHOTO_LIMIT)
                sg_shot(89, sg_style(14), ex_color(3), owner.x, owner.y,
                        n, 1, 2, 1.5, a, 10.5880, false, 514, nil)
                a = a + drift
                if a >= 180 then a = a - 360 elseif a < -180 then a = a + 360 end
                task.Wait(GAP)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            ---Sub3 的 ins_4(0,-112) 跳回目标是 @796（ins_0 NOP），而起 Sub4/Sub5 的两条
            ---ins_117(@756/@776) 在目标**之前** ⇒ 两条刀圈只起一次；循环里只有 ins_67 位移。
            ring(self, 6)                             -- Sub4
            ring(self, -9)                            -- Sub5
            while not st.dead do
                task.Wait(120)                            -- t=120
                if st.dead then return end
                sg_bmove(self, st, 40, 4, 2.6, BOX)       -- ins_67(40,4,2.6)
                task.Wait(40)                             -- t=160
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
    end

    boss.card.add({ { card, "11a" } }, LEVEL, CARD_NAME, CARD_ID)
end--銀符「パーフェクトメイド」

---──────────────────── Stage 7 神鬼「レミリアストーカー」（ecl15_d，组 12a 第 4 张） ────────────────────
do  -- 67 レミリア 神鬼「レミリアストーカー」（ecl15_d，组 12a 第 4 张）
    ---原作是「レミリア追着你跑」：本体在**很窄的框** (-128,96,128,144) 里漂，一轮 240 帧：
    ---  · Sub4 @1064：从 t=0 起每 24 帧一根**旋转激光**（ins_153：型1色2、最大长 512、宽 16、
    ---    四段 90/20/30/10、角速 0、follow=1 每帧拉回本体），角度 = playerAngle + 15°/根，
    ---    共 24 根（扫满一圈）。
    ---  · Sub5 @1284：t=90 接管 slot0 —— 每 24 帧一根**直线激光**（ins_145：型12色1、速 12、
    ---    长 144、宽 64），角度同样 +15°/根，共 24 根。
    ---  · Sub8 @1744：t=150 起，每 2400 帧，在**离本体 60×rand 的一个随机方向点**上发一圈
    ---    type4/色2：弹数 = 1 + int(photoIndex/2)、速 1、方向 rand(−π,π)、步长 0.1848。
    ---  · Sub7 @1592：t=30 起本体抖 ±4 px；t=90 用 ins_63(V0,V1) 回位。
    ---骨架（/tmp/N_ecl15_d.txt）：Sub2 t=130 ins_104 + ins_75(-128,96,128,144) + ins_149(3.1)；
    ---Sub3 t=0 记 extraFloatV0/V1 = world.x/y、extraFloatV2 = playerAngle、起 Sub4/Sub6；
    ---t=30 起 Sub7；t=90 停 Sub6/Sub7、回位、起 Sub5；t=94 ins_144(20)；t=150 ins_67 + 起 Sub8；
    ---t=240 ins_4(0,-280) ⇒ 一輪 240 帧。
    ---★ ins_153/145 的「角」在 TH095 里不加自机角（EclRunTargetPhoto.inl:85/1），
    ---  所以这里的自机角是 Sub3 在 t=0 抽好、逐根 +15° 的那个 extraFloatV2。
    local BOSS_X, BOSS_START_Y = -128, field_y(-64)
    local HOME_X, HOME_Y = 0, field_y(128)              -- 0 / 96
    local ENTRY_WAIT, ENTRY_TIME = 100, 30
    local EASE_OUT = VALUE_SET.DECEL
    local PHOTO_LIMIT = 7                               -- ins_141(7)
    local CARD_NAME = "神鬼「レミリアストーカー」"
    local CARD_TIME, CARD_HP = 50, 900
    local CARD_ID = 493

    local BOX = { -128, 96, 128, 144 }                  -- ins_75（很窄）
    local CYCLE = 240
    local LASER_ROT, LASER_STR = 2, 12                  -- 贴图行（旋转 / 直线）
    local st = { dead = false }
    local lasers = {}

    ---Sub4：24 根旋转激光（ins_153）。四段 90/20/30/10、角速 0、follow=1。
    local function rot_laser(owner)
        task.New(owner, function()
            local a_th = sg_aim(owner.x, owner.y)        -- 自机角（TH095 空间的度）
            for _ = 1, 24 do
                spawn_ex_laser(owner, lasers, LASER_ROT, owner.x, owner.y,
                        math.rad(-a_th), 512, 16, 8, 90, 20, 30, 10, 0, 0, 0,
                        true, false)
                a_th = a_th + 15
                if a_th >= 180 then a_th = a_th - 360 end
                if st.dead then return end
                task.Wait(24)
            end
        end)
    end

    ---Sub5：24 根直线激光（ins_145）。型12色1、速 12、长 144、宽 64。
    local function str_laser(owner)
        task.New(owner, function()
            local a_th = sg_aim(owner.x, owner.y)
            for _ = 1, 24 do
                spawn_ex_laser_straight(owner, lasers, LASER_STR, owner.x, owner.y,
                        math.rad(-a_th), 144, 64, 12)
                a_th = a_th + 15
                if a_th >= 180 then a_th = a_th - 360 end
                if st.dead then return end
                task.Wait(24)
            end
        end)
    end

    ---Sub8：每 2400 帧在随机点发一圈 type4/色2（弹数 = 1 + photoIndex/2）。
    ---Sub3 每轮都用 ins_117(3,8) 重起它 ⇒ 旧的 Sub8 被它占用的 slot 3 顶掉；
    ---本仓库没有 context slot，只能自己在重起前掐掉上一条，否则每轮多留一条常驻发弹线。
    local star_task = nil
    local function star_ring(owner)
        if star_task then star_task.alive = false end
        local t = { alive = true }
        star_task = t
        task.New(owner, function()
            while not st.dead and t.alive do
                local d = 60 * ran:Float(0, 1)
                local a = ran:Float(-math.pi, math.pi)   -- TH095 空间的方向
                local px = owner.x + d * math.cos(a)
                local py = owner.y - d * math.sin(a)     -- TH095 y 轴翻过来
                local n = 1 + math.floor(photo_index(PHOTO_LIMIT) / 2)
                sg_shot(89, sg_style(4), ex_color(2), px, py,
                        n, 1, 1, 1.5, math.deg(ran:Float(-math.pi, math.pi)), 10.5880,
                        false, 514, nil)
                task.Wait(2400)
            end
        end)
    end

    local card = boss.card.New(CARD_NAME, 1, 3, CARD_TIME, CARD_HP)

    function card:before()
        lasers = {}
        star_task = nil
    end

    function card:init()
        photo_damage_on(self, PHOTO_LIMIT)
        self.x, self.y = BOSS_X, BOSS_START_Y
        st.dead = false
        task.New(self, function()
            task.Wait(ENTRY_WAIT)
            task.MoveTo(HOME_X, HOME_Y, ENTRY_TIME, EASE_OUT)
            while not st.dead do
                local bx, by = self.x, self.y
                rot_laser(self)
                task.Wait(90)                             -- t=90：Sub5 接管 slot0
                if st.dead then return end
                self.x, self.y = bx, by                   -- ins_63(extraFloatV0, extraFloatV1)
                str_laser(self)
                task.Wait(60)                             -- t=150
                if st.dead then return end
                sg_bmove(self, st, 60, 4, 0.5, BOX)       -- ins_67(60,4,0.5)
                star_ring(self)                           -- Sub8
                task.Wait(CYCLE - 150)
            end
        end)
    end

    function card:frame()
    end

    function card:del()
        st.dead = true
        photo_damage_off(self)
        sg_clear(lasers)
    end

    boss.card.add({ { card, "12a" } }, LEVEL, CARD_NAME, CARD_ID)
end--神鬼「レミリアストーカー」
