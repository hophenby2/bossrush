# TH31–TH35 全条目停弹／换色／转向／恢复时序源码核对

接 `c73378b` 的44条批次继续，现已为全部521个注册条目补齐本专项的逐卡源码核对记录：520个原作条目，1个仓库自制条目单列。核对范围为实际发弹flags、写入后的槽表、WAIT活动位清除、即时换图、折向间隔／重复次数／恢复速度及相关特殊回调。

按用户要求，没有运行游戏、Lua探针、弹幕模拟、测试、编译或打包。本报告是源码核对，不是实机逐帧验收，也不扩大为所有ECL指令、随机流、碰撞与全部演出的完整验证。

逐卡原始指令、时间、掩码、操作数、文件SHA-256和本次实现SHA-256见 [JSON记录](TIMING_REVIEW_FULL_2026-11-03.json)。其中保存132个原文件的哈希、2698条去重后的候选指令。

## 覆盖范围

| 文件 | 对应原作 | 注册条目 | 本轮范围 |
| --- | --- | ---: | --- |
| TH31 | 永夜抄 | 135 | 共用EX、私有Last Word弹类、铃仙特殊相位、道中派生枪 |
| TH32 | 红魔乡 | 106 | 105个原作条目及1个自制条目；原生EX与特殊停弹／唤醒回调 |
| TH33 | 文花帖 | 85 | 全85幕的槽式变换、私有枪、拍摄阶段及捕获／恢复回调 |
| TH34 | 妖妖梦 | 121 | 普通／并发／串行命令、妖梦特殊接管、六段三姐妹非符及道中 |
| TH35 | 风神录 | 74 | 共用18槽变换、神德专用枪、各符／非符和道中 |

红魔乡另将294个已展开的原生函数与原始二进制的离线展开结果作文本对应：3488行等待、发弹、EX参数及跳转目标语句一致。这里只生成并读取文本，没有执行Lua；共用弹体与五张手写蕾米莉亚卡的目标逻辑单独按复原源码复核。

## 本轮修正

| 编号 | 具体条目 | 差异和修复 | 原作依据 |
| --- | --- | --- | --- |
| F01 | TH31/408 | 半速时按ZunTimer余量推进DECEL/VEC/POLAR/折向/WAIT/WRAP；出生和消散以原生ANM完成标志交接，不再用真帧硬倒数。 | th08 Supervisor.hpp::ZunTimer；Supervisor.cpp:1187/1218；BulletManager.cpp::Update*、SPAWNING与DESPAWNING |
| F02 | TH31/363 | 1/3速的弹体各自保存ZunTimer余量，逐步按float32舍入；补回主弹变白，恢复倍率时复原颜色。 | th08 EclExIns.cpp::EnterScaledBulletTime/ExitScaledBulletTime；Supervisor.cpp::ZunTimer::Decrement |
| F03 | TH31/360 | 梦想天生的6条SET_SPRITE原来只登记字段，现于原即时记录处真正换型换色，再同帧认领WAIT或AIMED。 | ecldata4asp/Sub46的slot2/4/7/10/12/15；BulletManager.cpp::AdvanceTransformProgram |
| F04 | TH31/367 | 深弹幕结界的REL减速读当前逻辑speed，到折向帧才写恢复速度0；修正提前一帧停住。 | ecldata_yk/Sub4..Sub15的slot2 REL(1,1,0,0)；BulletManager.cpp::UpdateRelativeDirectionChange |
| F05 | TH31/454、TH31/456、TH31/458、TH31/459、TH31/460 | 按主弹ANM的ins25初始化相位；真月从1→0开始，恢复隐形/显形/运动的原顺序；冻结和解冻切换±16精灵、混合模式，0→2使用15帧淡入。出生VM与主弹VM分别保留。 | etama.anm/script111的t=0 ins25(1)；EclExIns.cpp::ReisenFreezeBullets/AdvanceReisenBulletPhase |
| F06 | TH31/406 | 永琳6B一非来源由错误的ecldata6/Sub15改成ecldata7/Sub15，宿主Sub14；与下一卡使用同一携带键。 | ecldata7/Sub14注册Sub15；Sub15的SHOOT/REL/SET_SPRITE；ecldata6/Sub15仅是演出循环 |
| F07 | TH33/476 | 死価的WAIT增加清活动位这一帧；VEC使用认领时冻结的向量方向，穿过零速度后继续沿原向量加速，不来回翻转。 | ecl20_d/Sub4 @0x42c WAIT20，@0x454 VEC60/-0.05/-999 |
| F08 | TH33/521 | ストロードールカミカゼ发弹前slot0的WAIT60已被VEC覆盖，删去移植额外插入的等待；保留两档120帧加速。 | ecl6_c/Sub7 @0x784、0x7c8、0x804均写slot0 |
| F09 | TH33/511、TH33/512、TH33/513 | 补齐ExIns2/4捕获、ExIns5淡入与ExIns3全池恢复。逻辑angle/speed与临时velocity分开；半月本轮拍摄计数改变时跳过捕获。 | ecl7_b/Sub3/5/7/8；ecl7_c/Sub3/6/8/9；ecl7_d/Sub3/5/7/8；th095 EclExtended.cpp::Callback02/03/04与FadeOwnedCapturedBullets |
| F10 | TH34/4407 | 现世妄执的重定向先排队，旧POLAR在各弹自身160帧结束并清位后才接VEC90；旋向按原始循环弹槽号奇偶，速率取逻辑speed。 | th07 EnemyEclInstr.cpp::ExInsYoumuCurveBulletsBelow/ExInsYoumuRedirectBulletsToPlayer；Bullet::AddCommand/RunCommands |
| F11 | TH33/486、TH33/529、TH33/535、TH35/3605、TH35/3610、TH35/3653、TH35/3614、TH35/3656、TH35/3619、TH35/3620、TH35/3668、TH35/3623、TH35/3625、TH35/3631 | TH095/TH10的SET_SPRITE只InitializeVm，不发送interrupt2跳过显现；保留新脚本的显现时序，触发帧推进原生VM，不重启运动变换计数。 | th095 BulletManager.cpp::AdvanceTransformProgram SET_SPRITE；th10 BulletTransform.cpp SET_SPRITE；原始bullet.anm脚本 |
| F12 | TH31/362 | 紧缩世界的冻结由t=260/360的ExIns26显式开关，不在Boss帧尾提前倒数到0；弹体在t=360与自机同时恢复，修正t=359早一帧启动。 | ecldata_sk/Sub1 t=260 ExIns26(1)、t=360 ExIns26(0)；BulletManager.cpp的scriptedUpdateFreeze位移门控 |

上述12组修正明确列出31个符／非符条目。共用出生／消散时钟、逻辑angle/speed和换图入口也覆盖使用同一路径的派生弹；这不是把全部共用调用者都报成独立缺陷。

### 关键时序

- TH31/408「蓬莱之药」：`SetFrameRateDivisor(2)`后，ZunTimer按0.5推进，整数比较读取current、减速插值读取current+subFrame。WAIT先清位，再由下一次Advance接换色／加速。出生与消散读取原生ANM完成标志，保留模板已执行t=0的偏移。
- TH31/363「待宵反射卫星斩」：各弹的WAIT/VEC/POLAR分别保存余量；不能共用Boss全局tick的相位。进入／退出慢动作时，箭头主弹按原sprite111临时变白／复原。
- TH31/459「真実の月」：主弹type16使用的script111在t=0执行ins25(1)。第一轮应为`1→0`关判定并减速，再`0→2`用15帧显现，最后`2→1`恢复运动。构造函数清零不等于执行ANM后的初始相位。
- TH33/476「プライス・オブ・ライフ」：WAIT20保留初速0.2，随后一帧清活动位，下一次更新接VEC；负加速度方向在认领时冻结，速度穿过零后继续倒飞。
- TH33/521「ストロードールカミカゼ」：`Sub7 @0x784`的WAIT60、`@0x7c8/0x804`的VEC120都写slot0。SHOOT前WAIT已不存在，不能把它们拼成两个顺序段。
- TH33/511：Sub3的t=115捕获、t=175恢复；切入Sub8时t=0先恢复，t=30才清屏／开枪，t=105捕获、t=165恢复。
- TH33/512：t=80按本轮拍摄计数是否改变决定捕获，t=140淡入，t=170全池恢复。TH33/513：t=80捕获后先执行原脚本的冻结，再等t=100淡入、t=130恢复。这里的t是相应攻击上下文时间。
- TH34/4407「現世妄執」：ExIns14写入VEC不会清掉尚在运行的POLAR。各弹等自己的旧活动段结束，在清位的下一次RunCommands才认领新段。
- TH33/486、529、535以及列出的TH35换图条目：etSprite只重开VM，没有interrupt2；新脚本的显现阶段仍须执行，运动变换继续按原先的计数推进。

## 排除的伪差异及入口修正

- TH33/476的另一批直线弹虽写BOUNCE，SHOOT的flags514未启用它；本次修的是Sub4实际启用的WAIT/VEC。TH33/485的BOUNCE被同槽WAIT覆盖，flags也未启用反弹。
- TH35/3615的`BossCard4_at2`在原文件中只有声明及本函数内跳转，没有调用它的指令；不把其中DESPAWN算成当前卡漏实现。此前的“未证实可达”在本轮按调用来源排除。
- TH07/ecldata3的Sub25/26含反弹命令，但没有从本次道中窗口或相应卡入口调用它们；不为未使用脚本增添弹幕。
- TH31/406的Lua枪实际对应ecldata7/Sub15。原元数据却指向ecldata6/Sub15（演出循环），现一并修正来源、宿主和连续阶段携带键。
- 静态入口检索补入TH08的126号子程序槽注册，以及TH095的108/112/115/116号中断、拍摄和定时回调。静态闭包仍只是候选；候选中的其他难度、覆盖前记录和后续阶段没有被当作本卡实际执行。
- TH32/368「克罗里·尤斯福德」为仓库自制，单独记录为无原作ECL。

## 逐卡登记

下表覆盖全部注册项；“候选”数量是JSON中保留的原始变换记录数，不是弹数或实际执行次数。时间轴候选保留同文件范围，实际解释按道中窗口和派生入口。F编号对应本轮修正；其他条目本轮未新增修改，前批修复保留。

| 文件 | ID | 符卡／非符 | 原始入口 | 候选记录 | 本轮处理 |
| --- | ---: | --- | --- | ---: | --- |
| TH31 | 351 | 「季节外调的蝴蝶风暴」 | `ecldata1sp.ecl:Sub36` | 29 | 专项源码核对 |
| TH31 | 352 | 「盲夜鸟」 | `ecldata2sp.ecl:Sub46` | 0 | 专项源码核对 |
| TH31 | 353 | 「日出之国的天子」 | `ecldata3sp.ecl:Sub56` | 0 | 专项源码核对 |
| TH31 | 354 | 「幻胧月睨」 | `ecldata5sp.ecl:Sub40` | 3 | 专项源码核对 |
| TH31 | 355 | 「天网蛛网捕蝶之法」 | `ecldata6sp.ecl:Sub76` | 1 | 专项源码核对 |
| TH31 | 356 | 「蓬莱之树海」 | `ecldata7sp.ecl:Sub79` | 3 | 专项源码核对 |
| TH31 | 357 | 「不死鸟再诞」 | `ecldata8sp.ecl:Sub110` | 5 | 专项源码核对 |
| TH31 | 358 | 「远古的欺骗者」 | `ecldata5sp.ecl:Sub43` | 3 | 专项源码核对 |
| TH31 | 359 | 「无何有净化」 | `ecldata8sp.ecl:Sub113` | 3 | 专项源码核对 |
| TH31 | 360 | 「梦想天生」 | `ecldata4asp.ecl:Sub43` | 17 | F03 |
| TH31 | 361 | 「炽热之星」 | `ecldata4bsp.ecl:Sub60` | 3 | 专项源码核对 |
| TH31 | 362 | 「紧缩世界」 | `ecldata_sk.ecl:Sub1` | 2 | F12 |
| TH31 | 363 | 「待宵反射卫星斩」 | `ecldata_ym.ecl:Sub1` | 4 | F02 |
| TH31 | 364 | 「格兰吉纽尔剧场的怪人」 | `ecldata_al.ecl:Sub1` | 3 | 专项源码核对 |
| TH31 | 365 | 「猩红命运」 | `ecldata_rm.ecl:Sub1` | 0 | 专项源码核对 |
| TH31 | 366 | 「西行寺无余涅槃」 | `ecldata_yy.ecl:Sub1` | 12 | 专项源码核对 |
| TH31 | 367 | 「深弹幕结界 -梦幻泡影-」 | `ecldata_yk.ecl:Sub4` | 60 | F04 |
| TH31 | 3428 | 三面道中「迷途竹林」 | `ecldata3.ecl` | 14 | 专项源码核对 |
| TH31 | 3436 | 三面中BOSS 非符 | `ecldata3.ecl:Sub20` | 0 | 专项源码核对 |
| TH31 | 3426 | 产灵「最初的金字塔」 | `ecldata3.ecl:Sub30` | 0 | 专项源码核对 |
| TH31 | 3437 | 三面道中後段「迷途竹林」 | `ecldata3.ecl` | 14 | 专项源码核对 |
| TH31 | 427 | 非符一 | `ecldata3.ecl:Sub35` | 0 | 专项源码核对 |
| TH31 | 428 | 始符「エフェメラリティ137」 | `ecldata3.ecl:Sub44` | 2 | 专项源码核对 |
| TH31 | 429 | 野符「GHQクライシス」 | `ecldata3.ecl:Sub47` | 4 | 专项源码核对 |
| TH31 | 430 | 非符二 | `ecldata3.ecl:Sub38` | 0 | 专项源码核对 |
| TH31 | 431 | 国体「三種の神器　郷」 | `ecldata3.ecl:Sub62` | 0 | 专项源码核对 |
| TH31 | 432 | 虚史「幻想郷伝説」 | `ecldata3.ecl:Sub67` | 0 | 专项源码核对 |
| TH31 | 3427 | 未来「高天原」 | `ecldata3.ecl:Sub71` | 0 | 专项源码核对 |
| TH31 | 3438 | EX道中「永夜の竹林」 | `ecldata8.ecl` | 143 | 专项源码核对 |
| TH31 | 370 | 旧史「旧秘境史 -旧日秘史-」 | `ecldata8.ecl:Sub51` | 10 | 专项源码核对 |
| TH31 | 371 | 转世「一条归桥」 | `ecldata8.ecl:Sub56` | 3 | 专项源码核对 |
| TH31 | 372 | 新史「新幻想史 -未来秘史-」 | `ecldata8.ecl:Sub60` | 10 | 专项源码核对 |
| TH31 | 384 | 非符一 | `ecldata8.ecl:Sub66` | 0 | 专项源码核对 |
| TH31 | 373 | 时效「月之岩笠的诅咒」 | `ecldata8.ecl:Sub93` | 2 | 专项源码核对 |
| TH31 | 385 | 非符二 | `ecldata8.ecl:Sub68` | 0 | 专项源码核对 |
| TH31 | 374 | 不死「火之鸟 -凤翼天翔-」 | `ecldata8.ecl:Sub97` | 5 | 专项源码核对 |
| TH31 | 386 | 非符三 | `ecldata8.ecl:Sub70` | 0 | 专项源码核对 |
| TH31 | 375 | 藤原「灭罪寺院伤」 | `ecldata8.ecl:Sub100` | 2 | 专项源码核对 |
| TH31 | 387 | 非符四 | `ecldata8.ecl:Sub72` | 0 | 专项源码核对 |
| TH31 | 376 | 不死「徐福时空」 | `ecldata8.ecl:Sub103` | 3 | 专项源码核对 |
| TH31 | 388 | 非符五 | `ecldata8.ecl:Sub74` | 0 | 专项源码核对 |
| TH31 | 377 | 灭罪「正直者之死」 | `ecldata8.ecl:Sub108` | 0 | 专项源码核对 |
| TH31 | 389 | 非符六 | `ecldata8.ecl:Sub76` | 0 | 专项源码核对 |
| TH31 | 378 | 虚人「乌」 | `ecldata8.ecl:Sub113` | 2 | 专项源码核对 |
| TH31 | 390 | 非符七 | `ecldata8.ecl:Sub78` | 0 | 专项源码核对 |
| TH31 | 379 | 不灭「不死鸟之尾」 | `ecldata8.ecl:Sub118` | 4 | 专项源码核对 |
| TH31 | 391 | 非符八 | `ecldata8.ecl:Sub80` | 1 | 专项源码核对 |
| TH31 | 380 | 蓬莱「凯风快晴 -富士山火山-」 | `ecldata8.ecl:Sub126` | 11 | 专项源码核对 |
| TH31 | 381 | 「被不死鸟附身」 | `ecldata8.ecl:Sub131` | 11 | 专项源码核对 |
| TH31 | 382 | 「蓬莱人形」 | `ecldata8.ecl:Sub143` | 2 | 专项源码核对 |
| TH31 | 383 | 「不灭之射击」 | `ecldata8.ecl:Sub149` | 70 | 专项源码核对 |
| TH31 | 406 | 非符一 | `ecldata7.ecl:Sub15` | 5 | F06 |
| TH31 | 402 | 薬符「壶中之大银河」 | `ecldata7.ecl:Sub19` | 0 | 专项源码核对 |
| TH31 | 3431 | 六面道中B「月都回廊」 | `ecldata7.ecl` | 54 | 专项源码核对 |
| TH31 | 405 | 非符一 | `ecldata7.ecl:Sub27` | 6 | 专项源码核对 |
| TH31 | 401 | 神宝「龙颈之玉」 | `ecldata7.ecl:Sub50` | 1 | 专项源码核对 |
| TH31 | 404 | 非符二 | `ecldata7.ecl:Sub31` | 2 | 专项源码核对 |
| TH31 | 400 | 神宝「布迪斯特钻石」 | `ecldata7.ecl:Sub55` | 4 | 专项源码核对 |
| TH31 | 407 | 非符三 | `ecldata7.ecl:Sub34` | 4 | 专项源码核对 |
| TH31 | 399 | 神宝「萨拉曼达之盾」 | `ecldata7.ecl:Sub61` | 8 | 专项源码核对 |
| TH31 | 403 | 非符四 | `ecldata7.ecl:Sub38` | 2 | 专项源码核对 |
| TH31 | 398 | 神宝「ライフスプリングインフィニティ」 | `ecldata7.ecl:Sub67` | 2 | 专项源码核对 |
| TH31 | 397 | 神宝「蓬莱之玉之枝 -梦色之乡-」 | `ecldata7.ecl:Sub71` | 3 | 专项源码核对 |
| TH31 | 392 | 永夜归返「-待宵-」 | `ecldata7.ecl:Sub77` | 1 | 专项源码核对 |
| TH31 | 393 | 永夜归返「-子之四-」 | `ecldata7.ecl:Sub80` | 2 | 专项源码核对 |
| TH31 | 394 | 永夜归返「-丑之四-」 | `ecldata7.ecl:Sub82` | 2 | 专项源码核对 |
| TH31 | 395 | 永夜归返「-寅之四-」 | `ecldata7.ecl:Sub84` | 4 | 专项源码核对 |
| TH31 | 396 | 永夜归返「-天明-」 | `ecldata7.ecl:Sub87` | 5 | 专项源码核对 |
| TH31 | 3430 | 六面道中A「永远亭参道」 | `ecldata6.ecl` | 66 | 专项源码核对 |
| TH31 | 422 | 非符一 | `ecldata6.ecl:Sub16` | 5 | 专项源码核对 |
| TH31 | 421 | 天丸「壺中の天地」 | `ecldata6.ecl:Sub21` | 0 | 专项源码核对 |
| TH31 | 420 | 神符「天人の系譜」 | `ecldata6.ecl:Sub52` | 1 | 专项源码核对 |
| TH31 | 423 | 非符二 | `ecldata6.ecl:Sub36` | 3 | 专项源码核对 |
| TH31 | 419 | 蘇生「ライジングゲーム」 | `ecldata6.ecl:Sub56` | 2 | 专项源码核对 |
| TH31 | 424 | 非符三 | `ecldata6.ecl:Sub40` | 3 | 专项源码核对 |
| TH31 | 418 | 神脳「オモイカネブレイン」 | `ecldata6.ecl:Sub63` | 0 | 专项源码核对 |
| TH31 | 425 | 非符四 | `ecldata6.ecl:Sub44` | 4 | 专项源码核对 |
| TH31 | 417 | 天呪「アポロ１３」 | `ecldata6.ecl:Sub68` | 14 | 专项源码核对 |
| TH31 | 409 | 秘術「天文密葬法」 | `ecldata6.ecl:Sub73` | 1 | 专项源码核对 |
| TH31 | 408 | 禁薬「蓬莱の薬」 | `ecldata6.ecl:Sub78` | 14 | F01 |
| TH31 | 3412 | 四面道中「虚実の境界」 | `ecldata4a.ecl` | 76 | 专项源码核对 |
| TH31 | 3414 | 四面道中「虚実の境界」 | `ecldata4b.ecl` | 17 | 专项源码核对 |
| TH31 | 433 | 非符一 | `ecldata4a.ecl:Sub17` | 0 | 专项源码核对 |
| TH31 | 434 | 夢境「二重大結界」 | `ecldata4a.ecl:Sub28` | 0 | 专项源码核对 |
| TH31 | 435 | 非符二 | `ecldata4a.ecl:Sub19` | 0 | 专项源码核对 |
| TH31 | 436 | 散霊「夢想封印　寂」 | `ecldata4a.ecl:Sub30` | 0 | 专项源码核对 |
| TH31 | 3416 | 四面道中後段「虚実の境界」 | `ecldata4a.ecl` | 76 | 专项源码核对 |
| TH31 | 437 | 非符三 | `ecldata4a.ecl:Sub25` | 0 | 专项源码核对 |
| TH31 | 438 | 神技「八方龍殺陣」 | `ecldata4a.ecl:Sub33` | 28 | 专项源码核对 |
| TH31 | 439 | 非符四 | `ecldata4a.ecl:Sub26` | 0 | 专项源码核对 |
| TH31 | 440 | 回霊「夢想封印　侘」 | `ecldata4a.ecl:Sub41` | 17 | 专项源码核对 |
| TH31 | 441 | 大結界「博麗弾幕結界」 | `ecldata4a.ecl:Sub46` | 4 | 专项源码核对 |
| TH31 | 442 | 神霊「夢想封印　瞬」 | `ecldata4a.ecl:Sub54` | 5 | 专项源码核对 |
| TH31 | 443 | 非符一 | `ecldata4b.ecl:Sub17` | 0 | 专项源码核对 |
| TH31 | 444 | 魔空「アステロイドベルト」 | `ecldata4b.ecl:Sub36` | 0 | 专项源码核对 |
| TH31 | 445 | 非符二 | `ecldata4b.ecl:Sub22` | 0 | 专项源码核对 |
| TH31 | 446 | 黒魔「イベントホライズン」 | `ecldata4b.ecl:Sub41` | 6 | 专项源码核对 |
| TH31 | 3418 | 四面道中後段「虚実の境界」 | `ecldata4b.ecl` | 17 | 专项源码核对 |
| TH31 | 447 | 非符三 | `ecldata4b.ecl:Sub28` | 2 | 专项源码核对 |
| TH31 | 448 | 恋風「スターライトタイフーン」 | `ecldata4b.ecl:Sub47` | 1 | 专项源码核对 |
| TH31 | 449 | 非符四 | `ecldata4b.ecl:Sub31` | 0 | 专项源码核对 |
| TH31 | 450 | 恋心「ダブルスパーク」 | `ecldata4b.ecl:Sub55` | 1 | 专项源码核对 |
| TH31 | 451 | 光撃「シュート・ザ・ムーン」 | `ecldata4b.ecl:Sub62` | 0 | 专项源码核对 |
| TH31 | 452 | 魔砲「ファイナルマスタースパーク」 | `ecldata4b.ecl:Sub67` | 6 | 专项源码核对 |
| TH31 | 3432 | 五面道中「幻想乡上空」 | `ecldata5.ecl` | 35 | 专项源码核对 |
| TH31 | 3433 | 五面中BOSS 非符一 | `ecldata5.ecl:Sub38` | 8 | 专项源码核对 |
| TH31 | 3434 | 五面中BOSS 非符二 | `ecldata5.ecl:Sub45` | 10 | 专项源码核对 |
| TH31 | 3435 | 五面道中後段「幻想乡上空」 | `ecldata5.ecl` | 35 | 专项源码核对 |
| TH31 | 453 | 非符一 | `ecldata5.ecl:Sub51` | 2 | 专项源码核对 |
| TH31 | 454 | 幻波「赤眼催眠(マインドブローイング)」 | `ecldata5.ecl:Sub62` | 0 | F05 |
| TH31 | 455 | 非符二 | `ecldata5.ecl:Sub53` | 2 | 专项源码核对 |
| TH31 | 456 | 狂視「狂視調律(イリュージョンシーカー)」 | `ecldata5.ecl:Sub66` | 3 | F05 |
| TH31 | 457 | 非符三 | `ecldata5.ecl:Sub56` | 1 | 专项源码核对 |
| TH31 | 458 | 懶惰「生神停止(マインドストッパー)」 | `ecldata5.ecl:Sub63` | 0 | F05 |
| TH31 | 459 | 散符「真実の月(インビジブルフルムーン)」 | `ecldata5.ecl:Sub75` | 3 | F05 |
| TH31 | 460 | 月眼「月兎遠隔催眠術(テレメスメリズム)」 | `ecldata5.ecl:Sub78` | 2 | F05 |
| TH31 | 3429 | 二面道中「夜雀小径」 | `ecldata2.ecl` | 60 | 专项源码核对 |
| TH31 | 461 | 非符一 | `ecldata2.ecl:Sub17` | 5 | 专项源码核对 |
| TH31 | 462 | 声符「木菟咆哮」 | `ecldata2.ecl:Sub23` | 7 | 专项源码核对 |
| TH31 | 463 | 非符二 | `ecldata2.ecl:Sub27` | 7 | 专项源码核对 |
| TH31 | 464 | 猛毒「毒蛾の暗闇演舞」 | `ecldata2.ecl:Sub38` | 8 | 专项源码核对 |
| TH31 | 465 | 非符三 | `ecldata2.ecl:Sub29` | 7 | 专项源码核对 |
| TH31 | 466 | 鷹符「イルスタードダイブ」 | `ecldata2.ecl:Sub44` | 8 | 专项源码核对 |
| TH31 | 467 | 非符四 | `ecldata2.ecl:Sub51` | 9 | 专项源码核对 |
| TH31 | 468 | 夜盲「夜雀の歌」 | `ecldata2.ecl:Sub52` | 9 | 专项源码核对 |
| TH31 | 469 | 夜雀「真夜中のコーラスマスター」 | `ecldata2.ecl:Sub58` | 7 | 专项源码核对 |
| TH31 | 3409 | 一面道中「萤火小径」 | `ecldata1.ecl` | 117 | 专项源码核对 |
| TH31 | 470 | 非符一 | `ecldata1.ecl:Sub15` | 38 | 专项源码核对 |
| TH31 | 471 | 蛍符「地上の彗星」 | `ecldata1.ecl:Sub22` | 6 | 专项源码核对 |
| TH31 | 3410 | 一面道中後段「萤火小径」 | `ecldata1.ecl` | 117 | 专项源码核对 |
| TH31 | 472 | 非符二 | `ecldata1.ecl:Sub26` | 13 | 专项源码核对 |
| TH31 | 473 | 非符三 | `ecldata1.ecl:Sub33` | 0 | 专项源码核对 |
| TH31 | 474 | 灯符「ファイヤフライフェノメノン」 | `ecldata1.ecl:Sub38` | 6 | 专项源码核对 |
| TH31 | 475 | 蠢符「ナイトバグトルネード」 | `ecldata1.ecl:Sub44` | 27 | 专项源码核对 |
| TH31 | 476 | 隠蟲「永夜蟄居」 | `ecldata1.ecl:Sub48` | 27 | 专项源码核对 |
| TH32 | 3802 | 神罚「年幼的恶魔之王」（Lunatic） | `ecldata6.ecl:Sub31` | 2 | 专项源码核对 |
| TH32 | 3805 | 狱符「千根针的针山」（Lunatic） | `ecldata6.ecl:Sub33` | 4 | 专项源码核对 |
| TH32 | 3808 | 神术「吸血鬼幻想」（Lunatic） | `ecldata6.ecl:Sub35` | 0 | 专项源码核对 |
| TH32 | 3811 | 红符「绯红之主」（Lunatic） | `ecldata6.ecl:Sub39` | 0 | 专项源码核对 |
| TH32 | 369 | 「红色的幻想乡」（Lunatic） | `ecldata6.ecl:Sub44` | 4 | 专项源码核对 |
| TH32 | 3900 | 一面中 Boss 非符（Lunatic） | `ecldata1.ecl:Sub8` | 1 | 专项源码核对 |
| TH32 | 3901 | 月符「月光」（Lunatic） | `ecldata1.ecl:Sub9` | 0 | 专项源码核对 |
| TH32 | 3902 | 露米娅 非符一（Lunatic） | `ecldata1.ecl:Sub11` | 0 | 专项源码核对 |
| TH32 | 3903 | 夜符「夜雀」（Lunatic） | `ecldata1.ecl:Sub22` | 0 | 专项源码核对 |
| TH32 | 3904 | 露米娅 非符二（Lunatic） | `ecldata1.ecl:Sub16` | 0 | 专项源码核对 |
| TH32 | 3905 | 暗符「境界线」（Lunatic） | `ecldata1.ecl:Sub23` | 8 | 专项源码核对 |
| TH32 | 3906 | 大妖精 非符（Lunatic） | `ecldata2.ecl:Sub20` | 1 | 专项源码核对 |
| TH32 | 3907 | 琪露诺 非符一（Lunatic） | `ecldata2.ecl:Sub22` | 1 | 专项源码核对 |
| TH32 | 3908 | 雹符「冰雹暴风」（Lunatic） | `ecldata2.ecl:Sub30` | 1 | 专项源码核对 |
| TH32 | 3909 | 琪露诺 非符二（Lunatic） | `ecldata2.ecl:Sub25` | 0 | 专项源码核对 |
| TH32 | 3910 | 冻符「完美冻结」（Lunatic） | `ecldata2.ecl:Sub31` | 0 | 专项源码核对 |
| TH32 | 3911 | 雪符「钻石风暴」（Lunatic） | `ecldata2.ecl:Sub32` | 0 | 专项源码核对 |
| TH32 | 3912 | 三面中 Boss 非符（Lunatic） | `ecldata3.ecl:Sub9` | 0 | 专项源码核对 |
| TH32 | 3913 | 华符「绚烂华灵」（Lunatic） | `ecldata3.ecl:Sub14` | 2 | 专项源码核对 |
| TH32 | 3914 | 红美铃 非符一（Lunatic） | `ecldata3.ecl:Sub18` | 0 | 专项源码核对 |
| TH32 | 3915 | 虹符「彩虹的风铃」（Lunatic） | `ecldata3.ecl:Sub29` | 0 | 专项源码核对 |
| TH32 | 3916 | 红美铃 非符二（Lunatic） | `ecldata3.ecl:Sub20` | 1 | 专项源码核对 |
| TH32 | 3917 | 幻符「华想梦葛」（Lunatic） | `ecldata3.ecl:Sub30` | 0 | 专项源码核对 |
| TH32 | 3918 | 红美铃 非符三（Lunatic） | `ecldata3.ecl:Sub26` | 3 | 专项源码核对 |
| TH32 | 3919 | 彩符「彩光乱舞」（Lunatic） | `ecldata3.ecl:Sub32` | 5 | 专项源码核对 |
| TH32 | 3920 | 彩符「极彩台风」（Lunatic） | `ecldata3.ecl:Sub33` | 8 | 专项源码核对 |
| TH32 | 3921 | 小恶魔 非符（Lunatic） | `ecldata4.ecl:Sub21` | 1 | 专项源码核对 |
| TH32 | 3922 | 帕秋莉 非符一（Lunatic·灵梦Ａ） | `ecldata4.ecl:Sub27` | 0 | 专项源码核对 |
| TH32 | 3923 | 火符「火神之光上级」（Lunatic·灵梦Ａ） | `ecldata4.ecl:Sub43` | 2 | 专项源码核对 |
| TH32 | 3924 | 帕秋莉 非符二（Lunatic·灵梦Ａ） | `ecldata4.ecl:Sub37` | 0 | 专项源码核对 |
| TH32 | 3925 | 土符「三石塔的震动」（Lunatic·灵梦Ａ） | `ecldata4.ecl:Sub52` | 1 | 专项源码核对 |
| TH32 | 3926 | 火＆土符「熔岩巨石」（Lunatic·灵梦Ａ） | `ecldata4.ecl:Sub55` | 1 | 专项源码核对 |
| TH32 | 3927 | 金＆水符「水银之毒」（Lunatic·灵梦Ａ） | `ecldata4.ecl:Sub58` | 2 | 专项源码核对 |
| TH32 | 3928 | 木＆火符「森林大火」（Lunatic·灵梦Ａ） | `ecldata4.ecl:Sub56` | 2 | 专项源码核对 |
| TH32 | 3929 | 帕秋莉 非符一（Lunatic·灵梦Ｂ） | `ecldata4.ecl:Sub27` | 0 | 专项源码核对 |
| TH32 | 3930 | 水符「湖葬」（Lunatic·灵梦Ｂ） | `ecldata4.ecl:Sub46` | 0 | 专项源码核对 |
| TH32 | 3931 | 帕秋莉 非符二（Lunatic·灵梦Ｂ） | `ecldata4.ecl:Sub37` | 0 | 专项源码核对 |
| TH32 | 3932 | 木符「翠绿风暴」（Lunatic·灵梦Ｂ） | `ecldata4.ecl:Sub49` | 3 | 专项源码核对 |
| TH32 | 3933 | 水＆木符「水精灵」（Lunatic·灵梦Ｂ） | `ecldata4.ecl:Sub57` | 0 | 专项源码核对 |
| TH32 | 3934 | 金＆水符「水银之毒」（Lunatic·灵梦Ｂ） | `ecldata4.ecl:Sub58` | 2 | 专项源码核对 |
| TH32 | 3935 | 土＆金符「翡翠巨石」（Lunatic·灵梦Ｂ） | `ecldata4.ecl:Sub59` | 1 | 专项源码核对 |
| TH32 | 3936 | 帕秋莉 非符一（Lunatic·魔理沙Ａ） | `ecldata4.ecl:Sub27` | 0 | 专项源码核对 |
| TH32 | 3937 | 木符「风灵角笛上级」（Lunatic·魔理沙Ａ） | `ecldata4.ecl:Sub48` | 2 | 专项源码核对 |
| TH32 | 3938 | 帕秋莉 非符二（Lunatic·魔理沙Ａ） | `ecldata4.ecl:Sub37` | 0 | 专项源码核对 |
| TH32 | 3939 | 火符「火神之光辉」（Lunatic·魔理沙Ａ） | `ecldata4.ecl:Sub44` | 2 | 专项源码核对 |
| TH32 | 3940 | 木＆火符「森林大火」（Lunatic·魔理沙Ａ） | `ecldata4.ecl:Sub56` | 2 | 专项源码核对 |
| TH32 | 3941 | 土＆金符「翡翠巨石」（Lunatic·魔理沙Ａ） | `ecldata4.ecl:Sub59` | 1 | 专项源码核对 |
| TH32 | 3942 | 火＆土符「熔岩巨石」（Lunatic·魔理沙Ａ） | `ecldata4.ecl:Sub55` | 1 | 专项源码核对 |
| TH32 | 3943 | 帕秋莉 非符一（Lunatic·魔理沙Ｂ） | `ecldata4.ecl:Sub27` | 0 | 专项源码核对 |
| TH32 | 3944 | 土符「三石塔上级」（Lunatic·魔理沙Ｂ） | `ecldata4.ecl:Sub51` | 1 | 专项源码核对 |
| TH32 | 3945 | 帕秋莉 非符二（Lunatic·魔理沙Ｂ） | `ecldata4.ecl:Sub37` | 0 | 专项源码核对 |
| TH32 | 3946 | 金符「银龙」（Lunatic·魔理沙Ｂ） | `ecldata4.ecl:Sub54` | 1 | 专项源码核对 |
| TH32 | 3947 | 土＆金符「翡翠巨石」（Lunatic·魔理沙Ｂ） | `ecldata4.ecl:Sub59` | 1 | 专项源码核对 |
| TH32 | 3948 | 水＆木符「水精灵」（Lunatic·魔理沙Ｂ） | `ecldata4.ecl:Sub57` | 0 | 专项源码核对 |
| TH32 | 3949 | 金＆水符「水银之毒」（Lunatic·魔理沙Ｂ） | `ecldata4.ecl:Sub58` | 2 | 专项源码核对 |
| TH32 | 3950 | 五面中 Boss 非符（Lunatic） | `ecldata5.ecl:Sub13` | 0 | 专项源码核对 |
| TH32 | 3951 | 奇术「迷惑误导」（Lunatic） | `ecldata5.ecl:Sub18` | 2 | 专项源码核对 |
| TH32 | 3952 | 咲夜 非符一（Lunatic） | `ecldata5.ecl:Sub22` | 0 | 专项源码核对 |
| TH32 | 3953 | 幻幽「夜雾幻影杀人鬼」（Lunatic） | `ecldata5.ecl:Sub45` | 0 | 专项源码核对 |
| TH32 | 3954 | 咲夜 非符二（Lunatic） | `ecldata5.ecl:Sub34` | 4 | 专项源码核对 |
| TH32 | 3955 | 幻世「世界」（Lunatic） | `ecldata5.ecl:Sub47` | 0 | 专项源码核对 |
| TH32 | 3956 | 咲夜 非符三（Lunatic） | `ecldata5.ecl:Sub41` | 2 | 专项源码核对 |
| TH32 | 3957 | 女仆秘技「杀人玩偶」（Lunatic） | `ecldata5.ecl:Sub50` | 2 | 专项源码核对 |
| TH32 | 3958 | 六面中 Boss 非符（Lunatic） | `ecldata6.ecl:Sub9` | 1 | 专项源码核对 |
| TH32 | 3959 | 奇术「永恒的温柔」（Lunatic） | `ecldata6.ecl:Sub14` | 1 | 专项源码核对 |
| TH32 | 3960 | 蕾米莉亚 非符一（Lunatic） | `ecldata6.ecl:Sub17` | 0 | 专项源码核对 |
| TH32 | 3961 | 蕾米莉亚 非符二（Lunatic） | `ecldata6.ecl:Sub19` | 0 | 专项源码核对 |
| TH32 | 3962 | 蕾米莉亚 非符三（Lunatic） | `ecldata6.ecl:Sub23` | 2 | 专项源码核对 |
| TH32 | 3963 | 蕾米莉亚 非符四（Lunatic） | `ecldata6.ecl:Sub26` | 3 | 专项源码核对 |
| TH32 | 3964 | 月符「沉默的月神」（Extra） | `ecldata7.ecl:Sub22` | 1 | 专项源码核对 |
| TH32 | 3965 | 日符「皇家烈焰」（Extra） | `ecldata7.ecl:Sub23` | 5 | 专项源码核对 |
| TH32 | 3966 | 火水木金土符「贤者之石」（Extra） | `ecldata7.ecl:Sub24` | 3 | 专项源码核对 |
| TH32 | 3967 | 芙兰朵露 非符一（Extra） | `ecldata7.ecl:Sub32` | 0 | 专项源码核对 |
| TH32 | 3968 | 禁忌「红莓陷阱」（Extra） | `ecldata7.ecl:Sub33` | 0 | 专项源码核对 |
| TH32 | 3969 | 芙兰朵露 非符二（Extra） | `ecldata7.ecl:Sub35` | 0 | 专项源码核对 |
| TH32 | 3970 | 禁忌「莱瓦汀」（Extra） | `ecldata7.ecl:Sub36` | 1 | 专项源码核对 |
| TH32 | 3971 | 芙兰朵露 非符三（Extra） | `ecldata7.ecl:Sub38` | 0 | 专项源码核对 |
| TH32 | 3972 | 禁忌「四重存在」（Extra） | `ecldata7.ecl:Sub39` | 0 | 专项源码核对 |
| TH32 | 3973 | 芙兰朵露 非符四（Extra） | `ecldata7.ecl:Sub43` | 0 | 专项源码核对 |
| TH32 | 3974 | 禁忌「笼中鸟」（Extra） | `ecldata7.ecl:Sub44` | 0 | 专项源码核对 |
| TH32 | 3975 | 芙兰朵露 非符五（Extra） | `ecldata7.ecl:Sub47` | 0 | 专项源码核对 |
| TH32 | 3976 | 禁忌「恋之迷宫」（Extra） | `ecldata7.ecl:Sub48` | 0 | 专项源码核对 |
| TH32 | 3977 | 芙兰朵露 非符六（Extra） | `ecldata7.ecl:Sub49` | 0 | 专项源码核对 |
| TH32 | 3978 | 禁弹「星弧破碎」（Extra） | `ecldata7.ecl:Sub50` | 2 | 专项源码核对 |
| TH32 | 3979 | 芙兰朵露 非符七（Extra） | `ecldata7.ecl:Sub53` | 0 | 专项源码核对 |
| TH32 | 3980 | 禁弹「折反射」（Extra） | `ecldata7.ecl:Sub54` | 5 | 专项源码核对 |
| TH32 | 3981 | 芙兰朵露 非符八（Extra） | `ecldata7.ecl:Sub56` | 0 | 专项源码核对 |
| TH32 | 3982 | 禁弹「刻着过去的钟表」（Extra） | `ecldata7.ecl:Sub57` | 0 | 专项源码核对 |
| TH32 | 3983 | 芙兰朵露 非符九（Extra） | `ecldata7.ecl:Sub59` | 2 | 专项源码核对 |
| TH32 | 3984 | 秘弹「之后就一个人都没有了吗？」（Extra） | `ecldata7.ecl:Sub60` | 2 | 专项源码核对 |
| TH32 | 3985 | ＱＥＤ「４９５年的波纹」（Extra） | `ecldata7.ecl:Sub68` | 1 | 专项源码核对 |
| TH32 | 4000 | 一面道中·前半 | `ecldata1.ecl` | 9 | 专项源码核对 |
| TH32 | 4001 | 一面道中·后半 | `ecldata1.ecl` | 9 | 专项源码核对 |
| TH32 | 4002 | 二面道中·前半 | `ecldata2.ecl` | 5 | 专项源码核对 |
| TH32 | 4003 | 二面道中·后半 | `ecldata2.ecl` | 5 | 专项源码核对 |
| TH32 | 4004 | 三面道中·前半 | `ecldata3.ecl` | 23 | 专项源码核对 |
| TH32 | 4005 | 三面道中·后半 | `ecldata3.ecl` | 23 | 专项源码核对 |
| TH32 | 4006 | 四面道中·前半 | `ecldata4.ecl` | 26 | 专项源码核对 |
| TH32 | 4007 | 四面道中·后半 | `ecldata4.ecl` | 26 | 专项源码核对 |
| TH32 | 4008 | 五面道中·前半 | `ecldata5.ecl` | 10 | 专项源码核对 |
| TH32 | 4009 | 五面道中·后半 | `ecldata5.ecl` | 10 | 专项源码核对 |
| TH32 | 4010 | 六面道中·前半 | `ecldata6.ecl` | 28 | 专项源码核对 |
| TH32 | 4011 | 六面道中·后半（入场等待） | `ecldata6.ecl` | 28 | 专项源码核对 |
| TH32 | 4012 | Extra道中·前半 | `ecldata7.ecl` | 20 | 专项源码核对 |
| TH32 | 4013 | Extra道中·后半 | `ecldata7.ecl` | 20 | 专项源码核对 |
| TH32 | 368 | 「克罗里·尤斯福德」 | `无原作ECL` | 0 | 自制单列 |
| TH33 | 4480 | 八云蓝 非符（场景70） | `ecl16_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 410 | 幽雅「死出の誘蛾灯」 | `ecl17_a.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 411 | 蝶符「鳳蝶紋の死槍」 | `ecl17_b.ecl:Sub2` | 1 | 专项源码核对 |
| TH33 | 416 | 死符「酔人の生、死の夢幻」 | `ecl17_c.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 412 | 「死蝶浮月」 | `ecl17_d.ecl:Sub2` | 4 | 专项源码核对 |
| TH33 | 413 | 密符「御大師様の秘鍵」 | `ecl16_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 414 | 行符「八千万枚護摩」 | `ecl16_c.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 415 | 超人「飛翔役小角」 | `ecl16_d.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 453 | 禁忌「フォービドゥンフルーツ」 | `ecl22_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 454 | 禁忌「禁じられた遊び」 | `ecl22_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 455 | 境符「色と空の境界」 | `ecl23_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 456 | 境符「波と粒の境界」 | `ecl23_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 457 | 貴人「サンジェルマンの忠告」 | `ecl24_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 458 | 蓬莱「瑞江浦嶋子と五色の瑞亀」 | `ecl24_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 459 | 鬼気「濛々迷霧」 | `ecl25_a.ecl:Sub2` | 1 | 专项源码核对 |
| TH33 | 460 | 「百万鬼夜行」 | `ecl25_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 470 | 非符 | `ecl20_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 471 | 嘘言「タン・オブ・ウルフ」 | `ecl21_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 472 | 死歌「八重霧の渡し」 | `ecl20_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 473 | 審判「十王裁判」 | `ecl21_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 474 | 古雨「黄泉中有の旅の雨」 | `ecl20_c.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 475 | 審判「ギルティ・オワ・ノットギルティ」 | `ecl21_c.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 476 | 死価「プライス・オブ・ライフ」 | `ecl20_d.ecl:Sub2` | 3 | F07 |
| TH33 | 477 | 審判「浄頗梨審判　-射命丸文-」 | `ecl21_d.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 478 | 永琳 非符（scene80） | `ecl18_a.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 479 | 新難題「月のイルメナイト」 | `ecl19_a.ecl:Sub2` | 1 | 专项源码核对 |
| TH33 | 480 | 薬符「胡蝶夢丸ナイトメア」 | `ecl18_b.ecl:Sub2` | 1 | 专项源码核对 |
| TH33 | 481 | 新難題「エイジャの赤石」 | `ecl19_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 482 | 錬丹「水銀の海」 | `ecl18_c.ecl:Sub2` | 1 | 专项源码核对 |
| TH33 | 483 | 新難題「金閣寺の一枚天井」 | `ecl19_c.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 484 | 秘薬「仙香玉兎」 | `ecl18_d.ecl:Sub2` | 1 | 专项源码核对 |
| TH33 | 485 | 新難題「ミステリウム」 | `ecl19_d.ecl:Sub2` | 13 | 专项源码核对 |
| TH33 | 486 | 咲夜 非符（scene60） | `ecl14_a.ecl:Sub2` | 8 | F11 |
| TH33 | 487 | 魔符「全世界ナイトメア」 | `ecl15_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 488 | 時符「トンネルエフェクト」 | `ecl14_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 489 | 紅符「ブラッディマジックスクウェア」 | `ecl15_b.ecl:Sub2` | 12 | 专项源码核对 |
| TH33 | 490 | 空虚「インフレーションスクウェア」 | `ecl14_c.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 491 | 紅蝙蝠「ヴァンピリッシュナイト」 | `ecl15_c.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 492 | 銀符「パーフェクトメイド」 | `ecl14_d.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 493 | 神鬼「レミリアストーカー」 | `ecl15_d.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 494 | 妖梦 非符（scene50） | `ecl12_a.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 495 | 人智剣「天女返し」 | `ecl13_a.ecl:Sub2` | 1 | 专项源码核对 |
| TH33 | 496 | 星符「飛び重ね鱗」 | `ecl12_b.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 497 | 妄執剣「修羅の血」 | `ecl13_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 498 | 鬼神「鳴動持国天」 | `ecl12_c.ecl:Sub2` | 5 | 专项源码核对 |
| TH33 | 499 | 天星剣「涅槃寂静の如し」 | `ecl13_c.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 500 | 化猫「橙」 | `ecl12_d.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 501 | 四生剣「衆生無情の響き」 | `ecl13_d.ecl:Sub2` | 1 | 专项源码核对 |
| TH33 | 502 | 美铃 非符（scene40） | `ecl10_a.ecl:Sub2` | 1 | 专项源码核对 |
| TH33 | 503 | 日＆水符「ハイドロジェナスプロミネンス」 | `ecl11_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 504 | 華符「彩光蓮華掌」 | `ecl10_b.ecl:Sub2` | 7 | 专项源码核对 |
| TH33 | 505 | 水＆火符「フロギスティックレイン」 | `ecl11_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 506 | 彩翔「飛花落葉」 | `ecl10_c.ecl:Sub2` | 4 | 专项源码核对 |
| TH33 | 507 | 月＆木符「サテライトヒマワリ」 | `ecl11_c.ecl:Sub2` | 6 | 专项源码核对 |
| TH33 | 508 | 彩華「虹色太極拳」 | `ecl10_d.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 509 | 日＆月符「ロイヤルダイアモンドリング」 | `ecl11_d.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 510 | 铃仙 非符（scene30） | `ecl7_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 514 | 霧符「ガシングガーデン」 | `ecl9_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 517 | 脱兎「フラスターエスケープ」 | `ecl8_a.ecl:Sub2` | 4 | 专项源码核对 |
| TH33 | 511 | 散符「朧月花栞（ロケット・イン・ミスト）」 | `ecl7_b.ecl:Sub2` | 5 | F09 |
| TH33 | 515 | 毒符「ポイズンブレス」 | `ecl9_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 512 | 波符「幻の月（インビジブルハーフムーン）」 | `ecl7_c.ecl:Sub2` | 3 | F09 |
| TH33 | 516 | 譫妄「イントゥデリリウム」 | `ecl9_c.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 518 | 借符「大穴牟遅様の薬」 | `ecl8_b.ecl:Sub2` | 4 | 专项源码核对 |
| TH33 | 513 | 狂夢「風狂の夢（ドリームワールド）」 | `ecl7_d.ecl:Sub2` | 4 | F09 |
| TH33 | 519 | 爱丽丝 非符（scene20） | `ecl6_a.ecl:Sub2` | 1 | 专项源码核对 |
| TH33 | 520 | 操符「ドールズインシー」 | `ecl6_b.ecl:Sub2` | 1 | 专项源码核对 |
| TH33 | 521 | 呪符「ストロードールカミカゼ」 | `ecl6_c.ecl:Sub2` | 5 | F08 |
| TH33 | 522 | 赤符「ドールミラセティ」 | `ecl6_d.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 523 | 光符「アマテラス」 | `ecl5_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 524 | 包符「昭和の雨」 | `ecl5_b.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 525 | 葵符「水戸の光圀」 | `ecl5_c.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 526 | 倭符「邪馬台の国」 | `ecl5_d.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 527 | 琪露诺 非符（scene10） | `ecl3_a.ecl:Sub2` | 3 | 专项源码核对 |
| TH33 | 528 | 雪符「ダイアモンドブリザード」 | `ecl3_b.ecl:Sub2` | 8 | 专项源码核对 |
| TH33 | 529 | 凍符「マイナスＫ」 | `ecl3_c.ecl:Sub2` | 18 | F11 |
| TH33 | 530 | 蕾蒂 非符（scene11） | `ecl4_a.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 531 | 寒符「コールドスナップ」 | `ecl4_b.ecl:Sub2` | 2 | 专项源码核对 |
| TH33 | 532 | 冬符「ノーザンウイナー」 | `ecl4_c.ecl:Sub3` | 0 | 专项源码核对 |
| TH33 | 533 | 莉格露 非符（scene00） | `ecl1_a.ecl:Sub2` | 13 | 专项源码核对 |
| TH33 | 534 | 蛍符「地上の恒星」 | `ecl1_b.ecl:Sub2` | 10 | 专项源码核对 |
| TH33 | 535 | 蝶符「バタフライストーム」 | `ecl1_c.ecl:Sub2` | 25 | F11 |
| TH33 | 536 | 露米娅 非符（scene01） | `ecl2_a.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 537 | 闇符「ダークサイドオブザムーン」 | `ecl2_b.ecl:Sub2` | 0 | 专项源码核对 |
| TH33 | 538 | 夜符「ミッドナイトバード」 | `ecl2_c.ecl:Sub2` | 0 | 专项源码核对 |
| TH34 | 3405 | 六面道中「成群的亡灵」 | `ecldata6.ecl` | 107 | 专项源码核对 |
| TH34 | 3403 | 四面道中「骚灵们的合奏」 | `ecldata4.ecl` | 68 | 专项源码核对 |
| TH34 | 3402 | 三道中「青之骚灵」 | `ecldata3.ecl` | 59 | 专项源码核对 |
| TH34 | 3404 | 五道中「幽明之径」 | `ecldata5.ecl` | 34 | 专项源码核对 |
| TH34 | 3400 | 一道中「初雪之妖精」 | `ecldata1.ecl` | 45 | 专项源码核对 |
| TH34 | 3401 | 二道中「雪之回廊」 | `ecldata2.ecl` | 76 | 专项源码核对 |
| TH34 | 3406 | EX 道中「妖妖梦・Extra」 | `ecldata7.ecl` | 38 | 专项源码核对 |
| TH34 | 3407 | PH 道中「妖妖梦・Phantasm」 | `ecldata8.ecl` | 85 | 专项源码核对 |
| TH34 | 3408 | 藍 非符 0 | `ecldata8.ecl:Sub57` | 0 | 专项源码核对 |
| TH34 | 3411 | 紫 非符 1 | `ecldata8.ecl:Sub70` | 0 | 专项源码核对 |
| TH34 | 3413 | 紫 非符 2 | `ecldata8.ecl:Sub72` | 0 | 专项源码核对 |
| TH34 | 3415 | 紫 非符 3 | `ecldata8.ecl:Sub73` | 0 | 专项源码核对 |
| TH34 | 3417 | 紫 非符 4 | `ecldata8.ecl:Sub75` | 0 | 专项源码核对 |
| TH34 | 3419 | 紫 非符 5 | `ecldata8.ecl:Sub77` | 0 | 专项源码核对 |
| TH34 | 3421 | 紫 非符 6 | `ecldata8.ecl:Sub79` | 0 | 专项源码核对 |
| TH34 | 3423 | 紫 非符 7 | `ecldata8.ecl:Sub81` | 0 | 专项源码核对 |
| TH34 | 3425 | 紫 非符 8 | `ecldata8.ecl:Sub83` | 0 | 专项源码核对 |
| TH34 | 3440 | 紫奥義「弾幕結界」 | `ecldata8.ecl:Sub129` | 25 | 专项源码核对 |
| TH34 | 3441 | 結界「生と死の境界」 | `ecldata8.ecl:Sub127` | 0 | 专项源码核对 |
| TH34 | 3442 | 「人間と妖怪の境界」 | `ecldata8.ecl:Sub119` | 0 | 专项源码核对 |
| TH34 | 3443 | 式神「八雲藍」 | `ecldata8.ecl:Sub114` | 1 | 专项源码核对 |
| TH34 | 3444 | 魍魎「二重黒死蝶」 | `ecldata8.ecl:Sub109` | 20 | 专项源码核对 |
| TH34 | 3445 | 罔両「禅寺に棲む妖蝶」 | `ecldata8.ecl:Sub104` | 7 | 专项源码核对 |
| TH34 | 3446 | 罔両「八雲紫の神隠し」 | `ecldata8.ecl:Sub102` | 0 | 专项源码核对 |
| TH34 | 3447 | 罔両「ストレートとカーブの夢郷」 | `ecldata8.ecl:Sub100` | 5 | 专项源码核对 |
| TH34 | 3448 | 結界「光と闇の網目」 | `ecldata8.ecl:Sub97` | 0 | 专项源码核对 |
| TH34 | 3449 | 結界「動と静の均衡」 | `ecldata8.ecl:Sub93` | 0 | 专项源码核对 |
| TH34 | 3450 | 結界「夢と現の呪」 | `ecldata8.ecl:Sub88` | 4 | 专项源码核对 |
| TH34 | 3451 | 式神「憑依荼吉尼天」 | `ecldata8.ecl:Sub63` | 0 | 专项源码核对 |
| TH34 | 3452 | 式神「前鬼後鬼の守護」 | `ecldata8.ecl:Sub60` | 2 | 专项源码核对 |
| TH34 | 3471 | 幻神「飯綱権現降臨」 | `ecldata7.ecl:Sub123` | 0 | 专项源码核对 |
| TH34 | 3470 | 「狐狗狸さんの契約」 | `ecldata7.ecl:Sub115` | 0 | 专项源码核对 |
| TH34 | 3469 | 式神「橙」 | `ecldata7.ecl:Sub110` | 1 | 专项源码核对 |
| TH34 | 3468 | 式弾「ユーニラタルコンタクト」 | `ecldata7.ecl:Sub106` | 10 | 专项源码核对 |
| TH34 | 3467 | 式弾「アルティメットブディスト」 | `ecldata7.ecl:Sub101` | 1 | 专项源码核对 |
| TH34 | 3466 | 式輝「プリンセス天狐　-Illusion-」 | `ecldata7.ecl:Sub99` | 0 | 专项源码核对 |
| TH34 | 3465 | 式輝「四面楚歌チャーミング」 | `ecldata7.ecl:Sub97` | 5 | 专项源码核对 |
| TH34 | 3464 | 式輝「狐狸妖怪レーザー」 | `ecldata7.ecl:Sub94` | 0 | 专项源码核对 |
| TH34 | 3463 | 式神「十二神将の宴」 | `ecldata7.ecl:Sub88` | 0 | 专项源码核对 |
| TH34 | 3462 | 式神「仙狐思念」 | `ecldata7.ecl:Sub85` | 2 | 专项源码核对 |
| TH34 | 3461 | 鬼神「飛翔毘沙門天」 | `ecldata7.ecl:Sub61` | 0 | 专项源码核对 |
| TH34 | 3460 | 鬼符「青鬼赤鬼」 | `ecldata7.ecl:Sub58` | 2 | 专项源码核对 |
| TH34 | 3480 | EX 非符 1 | `ecldata7.ecl:Sub68` | 0 | 专项源码核对 |
| TH34 | 3481 | EX 非符 2 | `ecldata7.ecl:Sub70` | 0 | 专项源码核对 |
| TH34 | 3482 | EX 非符 3 | `ecldata7.ecl:Sub71` | 0 | 专项源码核对 |
| TH34 | 3483 | EX 非符 4 | `ecldata7.ecl:Sub73` | 0 | 专项源码核对 |
| TH34 | 3484 | EX 非符 5 | `ecldata7.ecl:Sub75` | 0 | 专项源码核对 |
| TH34 | 3485 | EX 非符 6 | `ecldata7.ecl:Sub77` | 0 | 专项源码核对 |
| TH34 | 3486 | EX 非符 7 | `ecldata7.ecl:Sub79` | 0 | 专项源码核对 |
| TH34 | 3487 | EX 非符 8 | `ecldata7.ecl:Sub81` | 0 | 专项源码核对 |
| TH34 | 3488 | EX 橙 非符 0 | `ecldata7.ecl:Sub55` | 0 | 专项源码核对 |
| TH34 | 4390 | 幽々子 非符 1 | `ecldata6.ecl:Sub19` | 1 | 专项源码核对 |
| TH34 | 4391 | 六道剣「一念無量劫 -Lunatic-」 | `ecldata6.ecl:Sub23` | 0 | 专项源码核对 |
| TH34 | 4392 | 幽々子 非符 2 | `ecldata6.ecl:Sub29` | 0 | 专项源码核对 |
| TH34 | 4393 | 亡郷「亡我郷 -自尽-」 | `ecldata6.ecl:Sub43` | 16 | 专项源码核对 |
| TH34 | 4394 | 幽々子 非符 3 | `ecldata6.ecl:Sub34` | 3 | 专项源码核对 |
| TH34 | 4395 | 幽々子 非符 4 | `ecldata6.ecl:Sub36` | 8 | 专项源码核对 |
| TH34 | 4396 | 亡舞「生者必滅の理 -魔境-」 | `ecldata6.ecl:Sub50` | 6 | 专项源码核对 |
| TH34 | 4397 | 華霊「バタフライディルージョン」 | `ecldata6.ecl:Sub52` | 1 | 专项源码核对 |
| TH34 | 4398 | 幽々子 非符 5 | `ecldata6.ecl:Sub38` | 20 | 专项源码核对 |
| TH34 | 4399 | 幽曲「リポジトリ・オブ・ヒロカワ -神霊-」 | `ecldata6.ecl:Sub55` | 9 | 专项源码核对 |
| TH34 | 4400 | 桜符「完全なる墨染の桜 -開花-」 | `ecldata6.ecl:Sub58` | 19 | 专项源码核对 |
| TH34 | 4401 | 「反魂蝶 -八分咲-」 | `ecldata6.ecl:Sub62` | 12 | 专项源码核对 |
| TH34 | 4402 | 妖夢 非符 1 | `ecldata5.ecl:Sub38` | 1 | 专项源码核对 |
| TH34 | 4403 | 餓王剣「餓鬼十王の報い」 | `ecldata5.ecl:Sub42` | 12 | 专项源码核对 |
| TH34 | 4404 | 妖夢 非符 2 | `ecldata5.ecl:Sub48` | 1 | 专项源码核对 |
| TH34 | 4405 | 獄神剣「業風神閃斬」 | `ecldata5.ecl:Sub57` | 0 | 专项源码核对 |
| TH34 | 4406 | 妖夢 非符 3 | `ecldata5.ecl:Sub52` | 0 | 专项源码核对 |
| TH34 | 4407 | 修羅剣「現世妄執 -Lunatic-」 | `ecldata5.ecl:Sub62` | 0 | F10 |
| TH34 | 4408 | 畜趣剣「無為無策の冥罰」 | `ecldata5.ecl:Sub66` | 0 | 专项源码核对 |
| TH34 | 4409 | 人神剣「俗諦常住」 | `ecldata5.ecl:Sub70` | 0 | 专项源码核对 |
| TH34 | 4410 | 天神剣「三魂七魄」 | `ecldata5.ecl:Sub75` | 2 | 专项源码核对 |
| TH34 | 4430 | アリス 非符 1 | `ecldata3.ecl:Sub22` | 2 | 专项源码核对 |
| TH34 | 4431 | 操符「乙女文楽　-Lunatic-」 | `ecldata3.ecl:Sub27` | 3 | 专项源码核对 |
| TH34 | 4432 | アリス 非符 1 | `ecldata3.ecl:Sub32` | 9 | 专项源码核对 |
| TH34 | 4433 | 蒼符「博愛のオルレアン人形」 | `ecldata3.ecl:Sub42` | 1 | 专项源码核对 |
| TH34 | 4434 | アリス 非符 2 | `ecldata3.ecl:Sub36` | 9 | 专项源码核对 |
| TH34 | 4435 | 白符「白亜の露西亜人形 -Lunatic-」 | `ecldata3.ecl:Sub48` | 0 | 专项源码核对 |
| TH34 | 4436 | アリス 非符 3 | `ecldata3.ecl:Sub37` | 24 | 专项源码核对 |
| TH34 | 4437 | 雅符「春の京人形」 | `ecldata3.ecl:Sub54` | 4 | 专项源码核对 |
| TH34 | 4438 | 咒詛「首吊り蓬莱人形」 | `ecldata3.ecl:Sub56` | 6 | 专项源码核对 |
| TH34 | 4440 | 露娜萨 非符 1 | `ecldata4.ecl:Sub58` | 3 | 专项源码核对 |
| TH34 | 5480 | 露娜萨 非符 2 | `ecldata4.ecl:Sub64` | 1 | 专项源码核对 |
| TH34 | 5483 | 露娜萨 非符 3 | `ecldata4.ecl:Sub68` | 1 | 专项源码核对 |
| TH34 | 4441 | 騒符「ライブポルターガイスト -Lunatic-」 | `ecldata4.ecl:Sub121` | 0 | 专项源码核对 |
| TH34 | 4442 | 梅露兰 非符 1 | `ecldata4.ecl:Sub76` | 0 | 专项源码核对 |
| TH34 | 5481 | 梅露兰 非符 2 | `ecldata4.ecl:Sub80` | 4 | 专项源码核对 |
| TH34 | 5484 | 梅露兰 非符 3 | `ecldata4.ecl:Sub83` | 4 | 专项源码核对 |
| TH34 | 4443 | 管霊「ゴーストクリフォード -Lunatic-」 | `ecldata4.ecl:Sub138` | 1 | 专项源码核对 |
| TH34 | 4444 | 莉莉卡 非符 1 | `ecldata4.ecl:Sub95` | 4 | 专项源码核对 |
| TH34 | 5482 | 莉莉卡 非符 2 | `ecldata4.ecl:Sub98` | 8 | 专项源码核对 |
| TH34 | 5485 | 莉莉卡 非符 3 | `ecldata4.ecl:Sub103` | 5 | 专项源码核对 |
| TH34 | 4445 | 鍵霊「ベーゼンドルファー神奏 -Lunatic-」 | `ecldata4.ecl:Sub145` | 8 | 专项源码核对 |
| TH34 | 4446 | 偽弦「スードストラディヴァリウス」 | `ecldata4.ecl:Sub128` | 1 | 专项源码核对 |
| TH34 | 4447 | 騒葬「スティジャンリバーサイド -Lunatic-」 | `ecldata4.ecl:Sub133` | 0 | 专项源码核对 |
| TH34 | 4448 | 大合葬「霊車コンチェルトグロッソ怪」 | `ecldata4.ecl:Sub135` | 0 | 专项源码核对 |
| TH34 | 4450 | レティ 非符 1 | `ecldata1.ecl:Sub20` | 13 | 专项源码核对 |
| TH34 | 4451 | 霜符「フロストコラムス -Lunatic-」 | `ecldata1.ecl:Sub29` | 0 | 专项源码核对 |
| TH34 | 4452 | レティ 非符 2 | `ecldata1.ecl:Sub38` | 4 | 专项源码核对 |
| TH34 | 4453 | 寒符「リンガリングコールド -Lunatic-」 | `ecldata1.ecl:Sub42` | 12 | 专项源码核对 |
| TH34 | 4454 | レティ 非符 3 | `ecldata1.ecl:Sub39` | 4 | 专项源码核对 |
| TH34 | 4455 | 白符「アンデュレイションレイ」 | `ecldata1.ecl:Sub52` | 0 | 专项源码核对 |
| TH34 | 4456 | 怪符「テーブルターニング」 | `ecldata1.ecl:Sub55` | 2 | 专项源码核对 |
| TH34 | 4460 | 橙 非符 1 | `ecldata2.ecl:Sub40` | 7 | 专项源码核对 |
| TH34 | 4461 | 仙符「鳳凰展翅　-Lunatic-」 | `ecldata2.ecl:Sub45` | 10 | 专项源码核对 |
| TH34 | 4462 | 橙 非符 2 | `ecldata2.ecl:Sub49` | 23 | 专项源码核对 |
| TH34 | 4463 | 式符「飛翔晴明」 | `ecldata2.ecl:Sub56` | 1 | 专项源码核对 |
| TH34 | 4464 | 陰陽「晴明大紋」 | `ecldata2.ecl:Sub58` | 4 | 专项源码核对 |
| TH34 | 4465 | 橙 非符 3 | `ecldata2.ecl:Sub53` | 9 | 专项源码核对 |
| TH34 | 4466 | 天符「天仙鳴動」 | `ecldata2.ecl:Sub64` | 0 | 专项源码核对 |
| TH34 | 4467 | 童符「護法天童乱舞」 | `ecldata2.ecl:Sub66` | 16 | 专项源码核对 |
| TH34 | 4468 | 仙符「屍解永遠」 | `ecldata2.ecl:Sub68` | 0 | 专项源码核对 |
| TH34 | 4469 | 方符「奇門遁甲」 | `ecldata2.ecl:Sub75` | 1 | 专项源码核对 |
| TH34 | 4457 | 冬符「フラワーウィザラウェイ」 | `ecldata1.ecl:Sub48` | 2 | 专项源码核对 |
| TH34 | 4439 | 紅符「紅毛の和蘭人形」 | `ecldata3.ecl:Sub46` | 0 | 专项源码核对 |
| TH34 | 4472 | 闇符「霧の倫敦人形」 | `ecldata3.ecl:Sub50` | 1 | 专项源码核对 |
| TH34 | 4473 | 廻符「輪廻の西蔵人形」 | `ecldata3.ecl:Sub52` | 4 | 专项源码核对 |
| TH34 | 4470 | 仙符「鳳凰卵」 | `ecldata2.ecl:Sub44` | 4 | 专项源码核对 |
| TH34 | 4471 | 鬼符「鬼門金神」 | `ecldata2.ecl:Sub70` | 0 | 专项源码核对 |
| TH34 | 4475 | 弦奏「グァルネリ・デル・ジェス」 | `ecldata4.ecl:Sub127` | 1 | 专项源码核对 |
| TH34 | 4476 | 合葬「プリズムコンチェルト」 | `ecldata4.ecl:Sub132` | 0 | 专项源码核对 |
| TH35 | 3600 | 「風神様の神徳」 | `stage06.ecl:BossCard5` | 8 | 专项源码核对 |
| TH35 | 3601 | 光学「ハイドロカモフラージュ」 | `stage03.ecl:MBossCard1` | 7 | 专项源码核对 |
| TH35 | 3660 | stage03 非符一 | `stage03.ecl:Boss1` | 8 | 专项源码核对 |
| TH35 | 3602 | 漂溺「光り輝く水底のトラウマ」 | `stage03.ecl:BossCard1` | 23 | 专项源码核对 |
| TH35 | 3661 | stage03 非符二 | `stage03.ecl:Boss2` | 8 | 专项源码核对 |
| TH35 | 3603 | 水符「河童の幻想大瀑布」 | `stage03.ecl:BossCard2` | 3 | 专项源码核对 |
| TH35 | 3662 | stage03 非符三 | `stage03.ecl:Boss3` | 8 | 专项源码核对 |
| TH35 | 3604 | 河童「スピン・ザ・セファリックプレート」 | `stage03.ecl:BossCard3L` | 6 | 专项源码核对 |
| TH35 | 3670 | stage04 中BOSS 非符 | `stage04.ecl:MBoss` | 3 | 专项源码核对 |
| TH35 | 3663 | stage04 非符一 | `stage04.ecl:Boss1` | 2 | 专项源码核对 |
| TH35 | 3605 | 岐符「サルタクロス」 | `stage04.ecl:BossCard1` | 9 | F11 |
| TH35 | 3664 | stage04 非符二 | `stage04.ecl:Boss2` | 2 | 专项源码核对 |
| TH35 | 3606 | 風神「二百十日」 | `stage04.ecl:BossCard2` | 8 | 专项源码核对 |
| TH35 | 3665 | stage04 非符三 | `stage04.ecl:Boss3` | 2 | 专项源码核对 |
| TH35 | 3607 | 「無双風神」 | `stage04.ecl:BossCard3` | 6 | 专项源码核对 |
| TH35 | 3608 | 塞符「天上天下の照國」 | `stage04.ecl:BossCard4` | 3 | 专项源码核对 |
| TH35 | 3651 | stage07 中BOSS 非符 | `stage07.ecl:MBoss1` | 1 | 专项源码核对 |
| TH35 | 3609 | 神符「水眼の如き美しき源泉」 | `stage07.ecl:MBossCard1` | 2 | 专项源码核对 |
| TH35 | 3610 | 神符「杉で結ぶ古き縁」 | `stage07.ecl:MBossCard2` | 12 | F11 |
| TH35 | 3611 | 神符「神が歩かれた御神渡り」 | `stage07.ecl:MBossCard3` | 3 | 专项源码核对 |
| TH35 | 3652 | stage07 非符一 | `stage07.ecl:Boss1` | 2 | 专项源码核对 |
| TH35 | 3612 | 開宴「二拝二拍一拝」 | `stage07.ecl:BossCard1` | 8 | 专项源码核对 |
| TH35 | 3653 | stage07 非符二 | `stage07.ecl:Boss2` | 3 | F11 |
| TH35 | 3613 | 土着神「手長足長さま」 | `stage07.ecl:BossCard2` | 4 | 专项源码核对 |
| TH35 | 3654 | stage07 非符三 | `stage07.ecl:Boss3` | 2 | 专项源码核对 |
| TH35 | 3614 | 神具「洩矢の鉄の輪」 | `stage07.ecl:BossCard3` | 9 | F11 |
| TH35 | 3655 | stage07 非符四 | `stage07.ecl:Boss4` | 2 | 专项源码核对 |
| TH35 | 3615 | 源符「厭い川の翡翠」 | `stage07.ecl:BossCard4` | 4 | 专项源码核对 |
| TH35 | 3656 | stage07 非符五 | `stage07.ecl:Boss5` | 3 | F11 |
| TH35 | 3616 | 蛙狩「蛙は口ゆえ蛇に呑まるる」 | `stage07.ecl:BossCard5` | 10 | 专项源码核对 |
| TH35 | 3657 | stage07 非符六 | `stage07.ecl:Boss6` | 2 | 专项源码核对 |
| TH35 | 3617 | 土着神「七つの石と七つの木」 | `stage07.ecl:BossCard6` | 7 | 专项源码核对 |
| TH35 | 3658 | stage07 非符七 | `stage07.ecl:Boss7` | 2 | 专项源码核对 |
| TH35 | 3618 | 土着神「ケロちゃん風雨に負けず」 | `stage07.ecl:BossCard7` | 3 | 专项源码核对 |
| TH35 | 3659 | stage07 非符八 | `stage07.ecl:Boss8` | 1 | 专项源码核对 |
| TH35 | 3619 | 土着神「宝永四年の赤蛙」 | `stage07.ecl:BossCard8` | 8 | F11 |
| TH35 | 3620 | 「諏訪大戦　～ 土着神話 vs 中央神話」 | `stage07.ecl:BossCard9` | 12 | F11 |
| TH35 | 3621 | 祟符「ミシャグジさま」 | `stage07.ecl:BossCard10` | 6 | 专项源码核对 |
| TH35 | 3666 | stage06 非符一 | `stage06.ecl:Boss1` | 1 | 专项源码核对 |
| TH35 | 3667 | stage06 非符二 | `stage06.ecl:Boss2` | 8 | 专项源码核对 |
| TH35 | 3668 | stage06 非符三 | `stage06.ecl:Boss3` | 3 | F11 |
| TH35 | 3669 | stage06 非符四 | `stage06.ecl:Boss4` | 10 | 专项源码核对 |
| TH35 | 3622 | stage06 符卡一 | `stage06.ecl:BossCard1` | 4 | 专项源码核对 |
| TH35 | 3623 | stage06 符卡二 | `stage06.ecl:BossCard2` | 7 | F11 |
| TH35 | 3624 | stage06 符卡三 | `stage06.ecl:BossCard3H` | 3 | 专项源码核对 |
| TH35 | 3625 | stage06 符卡四 | `stage06.ecl:BossCard4` | 5 | F11 |
| TH35 | 3671 | 六面道中「妖怪之山的妖精」 | `stage06.ecl:main` | 8 | 专项源码核对 |
| TH35 | 3680 | 一道中「初雪之妖精」 | `stage01.ecl:main` | 29 | 专项源码核对 |
| TH35 | 3681 | 二道中「人里の妖精」 | `stage02.ecl:main` | 36 | 专项源码核对 |
| TH35 | 3682 | 三道中「河童の渓谷」 | `stage03.ecl:main` | 26 | 专项源码核对 |
| TH35 | 3683 | 四道中「妖怪の山」 | `stage04.ecl:main` | 20 | 专项源码核对 |
| TH35 | 3684 | 五道中「洩矢の王国跡」 | `stage05.ecl:main` | 41 | 专项源码核对 |
| TH35 | 3685 | EX道中「ネイティブフェイス」 | `stage07.ecl:main` | 18 | 专项源码核对 |
| TH35 | 3642 | stage01 中BOSS 非符 | `stage01.ecl:MBoss` | 4 | 专项源码核对 |
| TH35 | 3630 | 葉符「狂いの落葉」 | `stage01.ecl:MBossCard1` | 11 | 专项源码核对 |
| TH35 | 3643 | stage01 非符一 | `stage01.ecl:Boss1` | 11 | 专项源码核对 |
| TH35 | 3631 | 秋符「秋の空と乙女の心」 | `stage01.ecl:BossCard1` | 73 | F11 |
| TH35 | 3644 | stage01 非符二 | `stage01.ecl:Boss2` | 13 | 专项源码核对 |
| TH35 | 3632 | 豊作「穀物神の約束」 | `stage01.ecl:BossCard2` | 3 | 专项源码核对 |
| TH35 | 3633 | 厄符「厄神様のバイオリズム」 | `stage02.ecl:MBossCard1` | 8 | 专项源码核对 |
| TH35 | 3645 | stage02 非符一 | `stage02.ecl:Boss1` | 8 | 专项源码核对 |
| TH35 | 3634 | 疵痕「壊されたお守り」 | `stage02.ecl:BossCard1` | 8 | 专项源码核对 |
| TH35 | 3646 | stage02 非符二 | `stage02.ecl:Boss2` | 8 | 专项源码核对 |
| TH35 | 3635 | 悲運「大鐘婆の火」 | `stage02.ecl:BossCard2` | 4 | 专项源码核对 |
| TH35 | 3636 | 創符「流刑人形」 | `stage02.ecl:BossCard3` | 6 | 专项源码核对 |
| TH35 | 3647 | stage05 中BOSS 非符 | `stage05.ecl:MBoss` | 14 | 专项源码核对 |
| TH35 | 3637 | 秘術「一子相伝の弾幕」 | `stage05.ecl:MBossCard1` | 19 | 专项源码核对 |
| TH35 | 3648 | stage05 非符一 | `stage05.ecl:Boss1` | 12 | 专项源码核对 |
| TH35 | 3638 | 奇跡「客星の明るすぎる夜」 | `stage05.ecl:BossCard1` | 3 | 专项源码核对 |
| TH35 | 3649 | stage05 非符二 | `stage05.ecl:Boss2` | 2 | 专项源码核对 |
| TH35 | 3639 | 開海「モーゼの奇跡」 | `stage05.ecl:BossCard2` | 2 | 专项源码核对 |
| TH35 | 3650 | stage05 非符三 | `stage05.ecl:Boss3` | 2 | 专项源码核对 |
| TH35 | 3640 | 準備「サモンタケミナカタ」 | `stage05.ecl:BossCard3` | 24 | 专项源码核对 |
| TH35 | 3641 | 大奇跡「八坂の神風」 | `stage05.ecl:BossCard4` | 6 | 专项源码核对 |

历史批次：[停弹与恢复修正](STOP_TIMING_FIXES_2026-11-03.md)、[44条继续核对批次](TIMING_REVIEW_BATCH_2026-11-03.md)。本报告不改变历史记录中的“未运行测试”或“仅核对目标字段”等限定。
