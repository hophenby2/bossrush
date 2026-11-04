# TH31–TH35 使魔运动、发弹与激光：运动角及附着顺序补查

基线 `88ecced`。接续前五份专项报告，本轮确认并修复5组差异，关联79个注册条目。只做原始ECL/复原源码和文本结构核对，按要求未运行测试、游戏、模拟、探针、Lua、编译或构建。

## 具体问题

| 编号 | 卡号 | 原差异 | 修复 |
| --- | --- | --- | --- |
| E01 | TH31：共66卡，逐卡表列全；正时长移动的movementAngle写入时点及字段 | 59个Boss运动实现把安装时的目标角当成movementAngle，或按整段delta而非本帧未夹框目标计算。贴边后下一次右边界折返及读取MOVEMENT_ANGLE的发弹方向会不同。龙颈之玉还把角写在c.mang、从owner.lw154_mang读；夜雀之歌另存了安装角供扇形使用。 | 安装插值不改运动角；每个活动运动出口在夹框前以本帧目标减当前位置计算角，包含终点吸附与零位移。龙颈之玉统一读写状态表mang；夜雀之歌扇形直接读取同一原生角。59个实现关联66张卡，妹红八段非符共用一个实现。 |
| E02 | TH31：365、366、406、407、437、438、439、444、448、451、470、471、472、473、474、475、476；Boss沿用普通敌机的32px近身停火 | 本体生成助手已SET_BOSS清零minimumPlayerDistanceSquared，私有出弹口仍硬编码32px；带shootOffset的枪还在部分路径用枪口位置判断距离。 | 18个too_close入口改为接收发射对象；猩红命运、西行寺无余涅槃的两个私有发射口同步按can_shoot读取该对象限制。Boss恢复近身发弹，使魔保留出生默认32px及ins_82覆盖值。18个入口中3个仅用于普通使魔，属于语义保持的同类收口，不计为新修复卡。 |
| E03 | TH31：366；西行寺无余涅槃独立激光发射器出生顺序 | 第一、第二个发射器均把出生RunEcl推迟到首次frame连跑两遍，激光创建晚于父机后续点弹和其他发射器。 | 在对象init内当场执行emitter_pass(0)，普通frame每次执行一遍。第一发射器的t0激光先于第二发射器创建，父机继续执行时已完成两个出生ECL。 |
| E04 | TH31：427、430；慧音两张非符的附着使魔提前刷新父位置 | Sub37、Sub40/Sub42在本帧枪运行前把世界坐标刷新到父机当前位置，Boss移动期间会从提前一帧的位置发弹。 | 枪先读上一帧世界坐标；枪及本帧ECL结束后再刷新父机偏移。生成时点、60帧挂枪和发弹周期保持原文。其他已核对公转使魔本来就在枪后更新位置，不重复移动。 |
| E05 | TH34：4400、4401；墨染之樱、反魂蝶在移动结束后丢失旧角 | 两份独立GET_EXIT_ANGLE通过当前_mv.dx/dy反推旧角；运动结束_mv被清空便回退0，且坐标口径转换不正确。右侧边界分支读取旧角时方向不符。 | 与已有ins_52出口共用NativeVisual.exit_angle，读取bstep每帧保存的TH07运动角，结束后仍保留。保存上下界与夹框开关分离，并随同一Boss连续阶段继承。EX/PH的ins_155保留自己的左右选向规则。 |

## 逐卡修正索引

| 文件 | ID | 符卡/非符 | 本轮修正 |
| --- | ---: | --- | --- |
| TH31 | 354 | 「幻胧月睨」 | E01 |
| TH31 | 355 | 「天网蛛网捕蝶之法」 | E01 |
| TH31 | 357 | 「不死鸟再诞」 | E01 |
| TH31 | 358 | 「远古的欺骗者」 | E01 |
| TH31 | 359 | 「无何有净化」 | E01 |
| TH31 | 360 | 「梦想天生」 | E01 |
| TH31 | 362 | 「紧缩世界」 | E01 |
| TH31 | 364 | 「格兰吉纽尔剧场的怪人」 | E01 |
| TH31 | 365 | 「猩红命运」 | E01 / E02 |
| TH31 | 366 | 「西行寺无余涅槃」 | E01 / E02 / E03 |
| TH31 | 427 | 非符一 | E01 / E04 |
| TH31 | 428 | 始符「エフェメラリティ137」 | E01 |
| TH31 | 430 | 非符二 | E01 / E04 |
| TH31 | 431 | 国体「三種の神器　郷」 | E01 |
| TH31 | 371 | 转世「一条归桥」 | E01 |
| TH31 | 384 | 非符一 | E01 |
| TH31 | 385 | 非符二 | E01 |
| TH31 | 374 | 不死「火之鸟 -凤翼天翔-」 | E01 |
| TH31 | 386 | 非符三 | E01 |
| TH31 | 375 | 藤原「灭罪寺院伤」 | E01 |
| TH31 | 387 | 非符四 | E01 |
| TH31 | 388 | 非符五 | E01 |
| TH31 | 389 | 非符六 | E01 |
| TH31 | 390 | 非符七 | E01 |
| TH31 | 391 | 非符八 | E01 |
| TH31 | 380 | 蓬莱「凯风快晴 -富士山火山-」 | E01 |
| TH31 | 406 | 非符一 | E01 / E02 |
| TH31 | 402 | 薬符「壶中之大银河」 | E01 |
| TH31 | 405 | 非符一 | E01 |
| TH31 | 401 | 神宝「龙颈之玉」 | E01 |
| TH31 | 407 | 非符三 | E01 / E02 |
| TH31 | 398 | 神宝「ライフスプリングインフィニティ」 | E01 |
| TH31 | 422 | 非符一 | E01 |
| TH31 | 421 | 天丸「壺中の天地」 | E01 |
| TH31 | 420 | 神符「天人の系譜」 | E01 |
| TH31 | 423 | 非符二 | E01 |
| TH31 | 419 | 蘇生「ライジングゲーム」 | E01 |
| TH31 | 424 | 非符三 | E01 |
| TH31 | 417 | 天呪「アポロ１３」 | E01 |
| TH31 | 409 | 秘術「天文密葬法」 | E01 |
| TH31 | 433 | 非符一 | E01 |
| TH31 | 436 | 散霊「夢想封印　寂」 | E01 |
| TH31 | 437 | 非符三 | E02 |
| TH31 | 438 | 神技「八方龍殺陣」 | E02 |
| TH31 | 439 | 非符四 | E02 |
| TH31 | 440 | 回霊「夢想封印　侘」 | E01 |
| TH31 | 441 | 大結界「博麗弾幕結界」 | E01 |
| TH31 | 443 | 非符一 | E01 |
| TH31 | 444 | 魔空「アステロイドベルト」 | E02 |
| TH31 | 445 | 非符二 | E01 |
| TH31 | 447 | 非符三 | E01 |
| TH31 | 448 | 恋風「スターライトタイフーン」 | E02 |
| TH31 | 449 | 非符四 | E01 |
| TH31 | 450 | 恋心「ダブルスパーク」 | E01 |
| TH31 | 451 | 光撃「シュート・ザ・ムーン」 | E01 / E02 |
| TH31 | 452 | 魔砲「ファイナルマスタースパーク」 | E01 |
| TH31 | 453 | 非符一 | E01 |
| TH31 | 455 | 非符二 | E01 |
| TH31 | 456 | 狂視「狂視調律(イリュージョンシーカー)」 | E01 |
| TH31 | 457 | 非符三 | E01 |
| TH31 | 458 | 懶惰「生神停止(マインドストッパー)」 | E01 |
| TH31 | 460 | 月眼「月兎遠隔催眠術(テレメスメリズム)」 | E01 |
| TH31 | 461 | 非符一 | E01 |
| TH31 | 462 | 声符「木菟咆哮」 | E01 |
| TH31 | 463 | 非符二 | E01 |
| TH31 | 464 | 猛毒「毒蛾の暗闇演舞」 | E01 |
| TH31 | 465 | 非符三 | E01 |
| TH31 | 466 | 鷹符「イルスタードダイブ」 | E01 |
| TH31 | 468 | 夜盲「夜雀の歌」 | E01 |
| TH31 | 469 | 夜雀「真夜中のコーラスマスター」 | E01 |
| TH31 | 470 | 非符一 | E02 |
| TH31 | 471 | 蛍符「地上の彗星」 | E01 / E02 |
| TH31 | 472 | 非符二 | E02 |
| TH31 | 473 | 非符三 | E02 |
| TH31 | 474 | 灯符「ファイヤフライフェノメノン」 | E02 |
| TH31 | 475 | 蠢符「ナイトバグトルネード」 | E02 |
| TH31 | 476 | 隠蟲「永夜蟄居」 | E02 |
| TH34 | 4400 | 桜符「完全なる墨染の桜 -開花-」 | E05 |
| TH34 | 4401 | 「反魂蝶 -八分咲-」 | E05 |

## 原始证据与关键顺序

### E01 正时长移动的movementAngle写入时点及字段

- th08/src/EclDependencies.cpp:StartTimedPolarDisplacement / BeginBoundaryAwareMove（duration>0分支不写movementAngle）
- th08/src/EnemyManager.cpp:Enemy::UpdateMovement INTERPOLATED（先velocity=target-position、再movementAngle；最后一帧仍写角）
- th08/src/EnemyManagerUpdate.cpp:RunEcl后夹框/积分/再夹框
- ecldata2/Sub52 @0x7ae0、0x7bb4、0x7cec、0x7dc0：ins_96角操作数[10069]
- ecldata4a/Sub41 @0x7660 t210：ins_67(120,0,0.5)，frame内环读取movementAngle

### E02 Boss沿用普通敌机的32px近身停火

- th08/src/EclRunHigh.inl:ECL_OPCODE_SET_BOSS，slot>=0时minimumPlayerDistanceSquared=0
- th08/src/EclDependencies.cpp:DispatchShotInstruction，距离使用enemy->worldPosition而非shootOffset
- ecldata_rm/Sub8 @0x14a4 t0、@0x162c t43：SET_BOSS(0)
- ecldata_yy/Sub11 @0x2300 t0、@0x2488 t43：SET_BOSS(0)
- 所有已注册TH31根程序中ins_82只有392..396在t130设0，无正值覆盖

### E03 西行寺无余涅槃独立激光发射器出生顺序

- ecldata_yy/Sub5 @0x106c t0、Sub6 @0x12fc t0：ins_114创建激光
- th08/src/EnemyTimeline.cpp:SpawnEnemy2内立即RunEcl，然后才返回父机
- mod/GAME/th31.lua:make_emitter / emitter_pass

### E04 慧音两张非符的附着使魔提前刷新父位置

- ecldata3/Sub35 @0x3f74..0x40dc t60：ins_92(Sub37)
- ecldata3/Sub38 @0x47e8..0x4950 t130、@0x49b0..0x4b18 t140：ins_92(Sub40/Sub42)
- th08/src/EclRunLow.inl:ECL_OPCODE_SPAWN_FAMILIAR_INHERITING_POSITION（op92）
- th08/src/EnemyManagerUpdate.cpp:RunEcl → Clamp/Integrate/Clamp → positionOffset=parent.position → worldPosition

### E05 墨染之樱、反魂蝶在移动结束后丢失旧角

- ecldata6/Sub58 @0xaee8 t880：ins_52，随后@0xaf00 ins_54
- ecldata6/Sub62 @0xc90c t920：ins_52，随后@0xc924 ins_54
- th07/src/th07/EclManager.cpp:ECL_GET_EXIT_ANGLE（op52），右侧正角分支π-enemy->angle
- 同文件ECL_DISABLE_MOVEMENT_BOUNDS（op63）只关useMoveLimit、不清上下界；ECL_RAND_EXIT_ANGLE（op155）是另一种判据

## 同类出口及未改动项

- 妖妖梦EX/PH实际使用ins_155，条件为(自机在左且x>96)||x>288；与ins_52的四边折返不同。该规则保留；不能把二者统一。
- TH31慧音之外的已核对公转使魔在枪后提交世界坐标；辉夜404、400、399的ins_92使魔生成后Boss静止，不因缺少后续父机平移而另作改动。
- TH31三个仅用于普通使魔的too_close（409、422、423）仍读取默认32px，属于语义保持，不计为新增问题。妖梦LW的sat_fire发射源是独立卫星，保留默认32px。
- TH32接续294个直接展开子程序的原始文本对应证据及既有共用运动/激光出口；本轮无新增代码修改。
- TH33核对直线/旋转激光STARTING→GROWING→ACTIVE→FADE的原生switch及回收顺序，未确认新增差异。85幕静态候选均未使用op93，不把未使用的随机速度模式当现役卡缺陷。
- TH35继续核对3613、3617、3638等移动激光槽式速度/反弹程序与三个固定激光创建点，未确认新增差异；不用未出现的aim模式6/7/8来虚报逐卡问题。

## 记录范围

- 本轮59个TH08运动实现的字段、函数名、66张卡映射及修复条目的根程序运动地址见同名JSON；妹红八段非符共用一段代码，不重复报为八处实现。
- 同名JSON保留521个注册条目的来源、当前修复关联及静态候选。生成助手单独记录，避免只看根Sub遗漏SET_BOSS。源码SHA-256和当前代码锚点也在JSON中。
- 前批记录：[MOTION_LASER_REVIEW_2026-11-03](MOTION_LASER_REVIEW_2026-11-03.md)、[MOTION_LASER_REVIEW_BATCH2_2026-11-03](MOTION_LASER_REVIEW_BATCH2_2026-11-03.md)、[MOTION_LASER_REVIEW_2026-11-04](MOTION_LASER_REVIEW_2026-11-04.md)、[MOTION_LASER_REVIEW_REMAINING_2026-11-04](MOTION_LASER_REVIEW_REMAINING_2026-11-04.md)、[MOTION_LASER_REVIEW_PRIVATE_PATHS_2026-11-04](MOTION_LASER_REVIEW_PRIVATE_PATHS_2026-11-04.md)。

## 证据边界

- 521项登记中有520项原作条目、1项仓库自制；登记、静态闭包和模板相符不等于全指令逐帧语义通过。
- instruction_candidate_counts及changed_root_motion_candidates沿用现有静态调用边和Lunatic位筛选；不求解控制流、变量目标、Boss中断可达性或道中窗口，不把候选当执行轨迹。EX/PH op155证据直接从对应原始子程序另查。
- 本轮完成上述明确机制的源码核对及修复；未运行实机，未证明所有输入、随机流、死亡/超时中断及碰撞下全游戏逐帧一致。
