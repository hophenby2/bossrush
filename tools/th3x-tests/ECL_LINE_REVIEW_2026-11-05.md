# TH31–TH35 ECL逐卡逐行核对

这份清单取代历史报告中的笼统“类别完成”结论。历史静态扫描、调用闭包和源点数量均不自动计为逐卡完成。

勾选条件：人工读完该卡在目标难度下的根程序、同步调用、并行context、生成实体及相关共享运行逻辑；记录源地址、逐段对应关系、修复和阶段接口。未完成的卡保持空框。这里只声明静态源码核对，不声明实机等价。

保留Boss Rush的阶段入口/结束、HP换算和自机接口；原作过场、计分与道具系统不属于攻击窗口。例如独立练习缺少上一段历史时的初始化映射必须单独记载，不能冒充原作历史。

**按用户要求未运行测试、游戏、Lua、ECL模拟或构建。**

当前：15/521张原作条目逐行核对完成；506张未完成；另1张为自制条目。

## TH31

- [x] TH31/351 「季节外调的蝴蝶风暴」 — `ecldata1sp.ecl:Sub36`；[核对记录](#31-351)
- [x] TH31/352 「盲夜鸟」 — `ecldata2sp.ecl:Sub46`；[核对记录](#31-352)
- [x] TH31/353 「日出之国的天子」 — `ecldata3sp.ecl:Sub56`；[核对记录](#31-353)
- [x] TH31/354 「幻胧月睨」 — `ecldata5sp.ecl:Sub40`；[核对记录](#31-354)
- [x] TH31/355 「天网蛛网捕蝶之法」 — `ecldata6sp.ecl:Sub76`；[核对记录](#31-355)
- [x] TH31/356 「蓬莱之树海」 — `ecldata7sp.ecl:Sub79`；[核对记录](#31-356)
- [x] TH31/357 「不死鸟再诞」 — `ecldata8sp.ecl:Sub110`；[核对记录](#31-357)
- [x] TH31/358 「远古的欺骗者」 — `ecldata5sp.ecl:Sub43`；[核对记录](#31-358)
- [x] TH31/359 「无何有净化」 — `ecldata8sp.ecl:Sub113`；[核对记录](#31-359)
- [x] TH31/360 「梦想天生」 — `ecldata4asp.ecl:Sub43`；[核对记录](#31-360)
- [x] TH31/361 「炽热之星」 — `ecldata4bsp.ecl:Sub60`；[核对记录](#31-361)
- [ ] TH31/362 「紧缩世界」 — `ecldata_sk.ecl:Sub1`
- [ ] TH31/363 「待宵反射卫星斩」 — `ecldata_ym.ecl:Sub1`
- [ ] TH31/364 「格兰吉纽尔剧场的怪人」 — `ecldata_al.ecl:Sub1`
- [ ] TH31/365 「猩红命运」 — `ecldata_rm.ecl:Sub1`
- [ ] TH31/366 「西行寺无余涅槃」 — `ecldata_yy.ecl:Sub1`
- [ ] TH31/367 「深弹幕结界 -梦幻泡影-」 — `ecldata_yk.ecl:Sub4`
- [ ] TH31/3428 三面道中「迷途竹林」 — `ecldata3.ecl:时间轴窗口待逐行核对`
- [ ] TH31/3436 三面中BOSS 非符 — `ecldata3.ecl:Sub20`
- [ ] TH31/3426 产灵「最初的金字塔」 — `ecldata3.ecl:Sub30`
- [ ] TH31/3437 三面道中後段「迷途竹林」 — `ecldata3.ecl:时间轴窗口待逐行核对`
- [ ] TH31/427 非符一 — `ecldata3.ecl:Sub35`
- [ ] TH31/428 始符「エフェメラリティ137」 — `ecldata3.ecl:Sub44`
- [ ] TH31/429 野符「GHQクライシス」 — `ecldata3.ecl:Sub47`
- [ ] TH31/430 非符二 — `ecldata3.ecl:Sub38`
- [ ] TH31/431 国体「三種の神器　郷」 — `ecldata3.ecl:Sub62`
- [ ] TH31/432 虚史「幻想郷伝説」 — `ecldata3.ecl:Sub67`
- [ ] TH31/3427 未来「高天原」 — `ecldata3.ecl:Sub71`
- [ ] TH31/3438 EX道中「永夜の竹林」 — `ecldata8.ecl:时间轴窗口待逐行核对`
- [ ] TH31/370 旧史「旧秘境史 -旧日秘史-」 — `ecldata8.ecl:Sub51`
- [ ] TH31/371 转世「一条归桥」 — `ecldata8.ecl:Sub56`
- [ ] TH31/372 新史「新幻想史 -未来秘史-」 — `ecldata8.ecl:Sub60`
- [ ] TH31/3439 EX道中後段「永夜の竹林」 — `ecldata8.ecl:时间轴窗口待逐行核对`
- [ ] TH31/384 非符一 — `ecldata8.ecl:Sub66`
- [ ] TH31/373 时效「月之岩笠的诅咒」 — `ecldata8.ecl:Sub93`
- [ ] TH31/385 非符二 — `ecldata8.ecl:Sub68`
- [ ] TH31/374 不死「火之鸟 -凤翼天翔-」 — `ecldata8.ecl:Sub97`
- [ ] TH31/386 非符三 — `ecldata8.ecl:Sub70`
- [ ] TH31/375 藤原「灭罪寺院伤」 — `ecldata8.ecl:Sub100`
- [ ] TH31/387 非符四 — `ecldata8.ecl:Sub72`
- [ ] TH31/376 不死「徐福时空」 — `ecldata8.ecl:Sub103`
- [ ] TH31/388 非符五 — `ecldata8.ecl:Sub74`
- [ ] TH31/377 灭罪「正直者之死」 — `ecldata8.ecl:Sub108`
- [ ] TH31/389 非符六 — `ecldata8.ecl:Sub76`
- [ ] TH31/378 虚人「乌」 — `ecldata8.ecl:Sub113`
- [ ] TH31/390 非符七 — `ecldata8.ecl:Sub78`
- [ ] TH31/379 不灭「不死鸟之尾」 — `ecldata8.ecl:Sub118`
- [ ] TH31/391 非符八 — `ecldata8.ecl:Sub80`
- [ ] TH31/380 蓬莱「凯风快晴 -富士山火山-」 — `ecldata8.ecl:Sub126`
- [ ] TH31/381 「被不死鸟附身」 — `ecldata8.ecl:Sub131`
- [ ] TH31/382 「蓬莱人形」 — `ecldata8.ecl:Sub143`
- [ ] TH31/383 「不灭之射击」 — `ecldata8.ecl:Sub149`
- [ ] TH31/406 非符一 — `ecldata7.ecl:Sub15`
- [ ] TH31/402 薬符「壶中之大银河」 — `ecldata7.ecl:Sub19`
- [ ] TH31/3431 六面道中B「月都回廊」 — `ecldata7.ecl:时间轴窗口待逐行核对`
- [ ] TH31/405 非符一 — `ecldata7.ecl:Sub27`
- [ ] TH31/401 神宝「龙颈之玉」 — `ecldata7.ecl:Sub50`
- [ ] TH31/404 非符二 — `ecldata7.ecl:Sub31`
- [ ] TH31/400 神宝「布迪斯特钻石」 — `ecldata7.ecl:Sub55`
- [ ] TH31/407 非符三 — `ecldata7.ecl:Sub34`
- [ ] TH31/399 神宝「萨拉曼达之盾」 — `ecldata7.ecl:Sub61`
- [ ] TH31/403 非符四 — `ecldata7.ecl:Sub38`
- [ ] TH31/398 神宝「ライフスプリングインフィニティ」 — `ecldata7.ecl:Sub67`
- [ ] TH31/397 神宝「蓬莱之玉之枝 -梦色之乡-」 — `ecldata7.ecl:Sub71`
- [ ] TH31/392 永夜归返「-待宵-」 — `ecldata7.ecl:Sub77`
- [ ] TH31/393 永夜归返「-子之四-」 — `ecldata7.ecl:Sub80`
- [ ] TH31/394 永夜归返「-丑之四-」 — `ecldata7.ecl:Sub82`
- [ ] TH31/395 永夜归返「-寅之四-」 — `ecldata7.ecl:Sub84`
- [ ] TH31/396 永夜归返「-天明-」 — `ecldata7.ecl:Sub87`
- [ ] TH31/3430 六面道中A「永远亭参道」 — `ecldata6.ecl:时间轴窗口待逐行核对`
- [ ] TH31/422 非符一 — `ecldata6.ecl:Sub16`
- [ ] TH31/421 天丸「壺中の天地」 — `ecldata6.ecl:Sub21`
- [ ] TH31/420 神符「天人の系譜」 — `ecldata6.ecl:Sub52`
- [ ] TH31/423 非符二 — `ecldata6.ecl:Sub36`
- [ ] TH31/419 蘇生「ライジングゲーム」 — `ecldata6.ecl:Sub56`
- [ ] TH31/424 非符三 — `ecldata6.ecl:Sub40`
- [ ] TH31/418 神脳「オモイカネブレイン」 — `ecldata6.ecl:Sub63`
- [ ] TH31/425 非符四 — `ecldata6.ecl:Sub44`
- [ ] TH31/417 天呪「アポロ１３」 — `ecldata6.ecl:Sub68`
- [ ] TH31/409 秘術「天文密葬法」 — `ecldata6.ecl:Sub73`
- [ ] TH31/408 禁薬「蓬莱の薬」 — `ecldata6.ecl:Sub78`
- [ ] TH31/3412 四面道中「虚実の境界」 — `ecldata4a.ecl:时间轴窗口待逐行核对`
- [ ] TH31/3414 四面道中「虚実の境界」 — `ecldata4b.ecl:时间轴窗口待逐行核对`
- [ ] TH31/433 非符一 — `ecldata4a.ecl:Sub17`
- [ ] TH31/434 夢境「二重大結界」 — `ecldata4a.ecl:Sub28`
- [ ] TH31/435 非符二 — `ecldata4a.ecl:Sub19`
- [ ] TH31/436 散霊「夢想封印　寂」 — `ecldata4a.ecl:Sub30`
- [ ] TH31/3416 四面道中後段「虚実の境界」 — `ecldata4a.ecl:时间轴窗口待逐行核对`
- [ ] TH31/437 非符三 — `ecldata4a.ecl:Sub25`
- [ ] TH31/438 神技「八方龍殺陣」 — `ecldata4a.ecl:Sub33`
- [ ] TH31/439 非符四 — `ecldata4a.ecl:Sub26`
- [ ] TH31/440 回霊「夢想封印　侘」 — `ecldata4a.ecl:Sub41`
- [ ] TH31/441 大結界「博麗弾幕結界」 — `ecldata4a.ecl:Sub46`
- [ ] TH31/442 神霊「夢想封印　瞬」 — `ecldata4a.ecl:Sub54`
- [ ] TH31/443 非符一 — `ecldata4b.ecl:Sub17`
- [ ] TH31/444 魔空「アステロイドベルト」 — `ecldata4b.ecl:Sub36`
- [ ] TH31/445 非符二 — `ecldata4b.ecl:Sub22`
- [ ] TH31/446 黒魔「イベントホライズン」 — `ecldata4b.ecl:Sub41`
- [ ] TH31/3418 四面道中後段「虚実の境界」 — `ecldata4b.ecl:时间轴窗口待逐行核对`
- [ ] TH31/447 非符三 — `ecldata4b.ecl:Sub28`
- [ ] TH31/448 恋風「スターライトタイフーン」 — `ecldata4b.ecl:Sub47`
- [ ] TH31/449 非符四 — `ecldata4b.ecl:Sub31`
- [ ] TH31/450 恋心「ダブルスパーク」 — `ecldata4b.ecl:Sub55`
- [ ] TH31/451 光撃「シュート・ザ・ムーン」 — `ecldata4b.ecl:Sub62`
- [ ] TH31/452 魔砲「ファイナルマスタースパーク」 — `ecldata4b.ecl:Sub67`
- [ ] TH31/3432 五面道中「幻想乡上空」 — `ecldata5.ecl:时间轴窗口待逐行核对`
- [ ] TH31/3433 五面中BOSS 非符一 — `ecldata5.ecl:Sub38`
- [ ] TH31/3434 五面中BOSS 非符二 — `ecldata5.ecl:Sub45`
- [ ] TH31/3435 五面道中後段「幻想乡上空」 — `ecldata5.ecl:时间轴窗口待逐行核对`
- [ ] TH31/453 非符一 — `ecldata5.ecl:Sub51`
- [ ] TH31/454 幻波「赤眼催眠(マインドブローイング)」 — `ecldata5.ecl:Sub62`
- [ ] TH31/455 非符二 — `ecldata5.ecl:Sub53`
- [ ] TH31/456 狂視「狂視調律(イリュージョンシーカー)」 — `ecldata5.ecl:Sub66`
- [ ] TH31/457 非符三 — `ecldata5.ecl:Sub56`
- [ ] TH31/458 懶惰「生神停止(マインドストッパー)」 — `ecldata5.ecl:Sub63`
- [ ] TH31/459 散符「真実の月(インビジブルフルムーン)」 — `ecldata5.ecl:Sub75`
- [ ] TH31/460 月眼「月兎遠隔催眠術(テレメスメリズム)」 — `ecldata5.ecl:Sub78`
- [ ] TH31/3429 二面道中「夜雀小径」 — `ecldata2.ecl:时间轴窗口待逐行核对`
- [ ] TH31/461 非符一 — `ecldata2.ecl:Sub17`
- [ ] TH31/462 声符「木菟咆哮」 — `ecldata2.ecl:Sub23`
- [ ] TH31/463 非符二 — `ecldata2.ecl:Sub27`
- [ ] TH31/464 猛毒「毒蛾の暗闇演舞」 — `ecldata2.ecl:Sub38`
- [ ] TH31/465 非符三 — `ecldata2.ecl:Sub29`
- [ ] TH31/466 鷹符「イルスタードダイブ」 — `ecldata2.ecl:Sub44`
- [ ] TH31/467 非符四 — `ecldata2.ecl:Sub51`
- [ ] TH31/468 夜盲「夜雀の歌」 — `ecldata2.ecl:Sub52`
- [ ] TH31/469 夜雀「真夜中のコーラスマスター」 — `ecldata2.ecl:Sub58`
- [ ] TH31/3409 一面道中「萤火小径」 — `ecldata1.ecl:时间轴窗口待逐行核对`
- [ ] TH31/470 非符一 — `ecldata1.ecl:Sub15`
- [ ] TH31/471 蛍符「地上の彗星」 — `ecldata1.ecl:Sub22`
- [ ] TH31/3410 一面道中後段「萤火小径」 — `ecldata1.ecl:时间轴窗口待逐行核对`
- [ ] TH31/472 非符二 — `ecldata1.ecl:Sub26`
- [ ] TH31/473 非符三 — `ecldata1.ecl:Sub33`
- [ ] TH31/474 灯符「ファイヤフライフェノメノン」 — `ecldata1.ecl:Sub38`
- [ ] TH31/475 蠢符「ナイトバグトルネード」 — `ecldata1.ecl:Sub44`
- [ ] TH31/476 隠蟲「永夜蟄居」 — `ecldata1.ecl:Sub48`

## TH32

- [ ] TH32/3802 神罚「年幼的恶魔之王」（Lunatic） — `ecldata6.ecl:Sub31`
- [ ] TH32/3805 狱符「千根针的针山」（Lunatic） — `ecldata6.ecl:Sub33`
- [ ] TH32/3808 神术「吸血鬼幻想」（Lunatic） — `ecldata6.ecl:Sub35`
- [ ] TH32/3811 红符「绯红之主」（Lunatic） — `ecldata6.ecl:Sub39`
- [ ] TH32/369 「红色的幻想乡」（Lunatic） — `ecldata6.ecl:Sub44`
- [ ] TH32/3900 一面中 Boss 非符（Lunatic） — `ecldata1.ecl:Sub8`
- [ ] TH32/3901 月符「月光」（Lunatic） — `ecldata1.ecl:Sub9`
- [ ] TH32/3902 露米娅 非符一（Lunatic） — `ecldata1.ecl:Sub11`
- [ ] TH32/3903 夜符「夜雀」（Lunatic） — `ecldata1.ecl:Sub22`
- [ ] TH32/3904 露米娅 非符二（Lunatic） — `ecldata1.ecl:Sub16`
- [ ] TH32/3905 暗符「境界线」（Lunatic） — `ecldata1.ecl:Sub23`
- [ ] TH32/3906 大妖精 非符（Lunatic） — `ecldata2.ecl:Sub20`
- [ ] TH32/3907 琪露诺 非符一（Lunatic） — `ecldata2.ecl:Sub22`
- [ ] TH32/3908 雹符「冰雹暴风」（Lunatic） — `ecldata2.ecl:Sub30`
- [ ] TH32/3909 琪露诺 非符二（Lunatic） — `ecldata2.ecl:Sub25`
- [ ] TH32/3910 冻符「完美冻结」（Lunatic） — `ecldata2.ecl:Sub31`
- [ ] TH32/3911 雪符「钻石风暴」（Lunatic） — `ecldata2.ecl:Sub32`
- [ ] TH32/3912 三面中 Boss 非符（Lunatic） — `ecldata3.ecl:Sub9`
- [ ] TH32/3913 华符「绚烂华灵」（Lunatic） — `ecldata3.ecl:Sub14`
- [ ] TH32/3914 红美铃 非符一（Lunatic） — `ecldata3.ecl:Sub18`
- [ ] TH32/3915 虹符「彩虹的风铃」（Lunatic） — `ecldata3.ecl:Sub29`
- [ ] TH32/3916 红美铃 非符二（Lunatic） — `ecldata3.ecl:Sub20`
- [ ] TH32/3917 幻符「华想梦葛」（Lunatic） — `ecldata3.ecl:Sub30`
- [ ] TH32/3918 红美铃 非符三（Lunatic） — `ecldata3.ecl:Sub26`
- [ ] TH32/3919 彩符「彩光乱舞」（Lunatic） — `ecldata3.ecl:Sub32`
- [ ] TH32/3920 彩符「极彩台风」（Lunatic） — `ecldata3.ecl:Sub33`
- [ ] TH32/3921 小恶魔 非符（Lunatic） — `ecldata4.ecl:Sub21`
- [ ] TH32/3922 帕秋莉 非符一（Lunatic·灵梦Ａ） — `ecldata4.ecl:Sub27`
- [ ] TH32/3923 火符「火神之光上级」（Lunatic·灵梦Ａ） — `ecldata4.ecl:Sub43`
- [ ] TH32/3924 帕秋莉 非符二（Lunatic·灵梦Ａ） — `ecldata4.ecl:Sub37`
- [ ] TH32/3925 土符「三石塔的震动」（Lunatic·灵梦Ａ） — `ecldata4.ecl:Sub52`
- [ ] TH32/3926 火＆土符「熔岩巨石」（Lunatic·灵梦Ａ） — `ecldata4.ecl:Sub55`
- [ ] TH32/3927 金＆水符「水银之毒」（Lunatic·灵梦Ａ） — `ecldata4.ecl:Sub58`
- [ ] TH32/3928 木＆火符「森林大火」（Lunatic·灵梦Ａ） — `ecldata4.ecl:Sub56`
- [ ] TH32/3929 帕秋莉 非符一（Lunatic·灵梦Ｂ） — `ecldata4.ecl:Sub27`
- [ ] TH32/3930 水符「湖葬」（Lunatic·灵梦Ｂ） — `ecldata4.ecl:Sub46`
- [ ] TH32/3931 帕秋莉 非符二（Lunatic·灵梦Ｂ） — `ecldata4.ecl:Sub37`
- [ ] TH32/3932 木符「翠绿风暴」（Lunatic·灵梦Ｂ） — `ecldata4.ecl:Sub49`
- [ ] TH32/3933 水＆木符「水精灵」（Lunatic·灵梦Ｂ） — `ecldata4.ecl:Sub57`
- [ ] TH32/3934 金＆水符「水银之毒」（Lunatic·灵梦Ｂ） — `ecldata4.ecl:Sub58`
- [ ] TH32/3935 土＆金符「翡翠巨石」（Lunatic·灵梦Ｂ） — `ecldata4.ecl:Sub59`
- [ ] TH32/3936 帕秋莉 非符一（Lunatic·魔理沙Ａ） — `ecldata4.ecl:Sub27`
- [ ] TH32/3937 木符「风灵角笛上级」（Lunatic·魔理沙Ａ） — `ecldata4.ecl:Sub48`
- [ ] TH32/3938 帕秋莉 非符二（Lunatic·魔理沙Ａ） — `ecldata4.ecl:Sub37`
- [ ] TH32/3939 火符「火神之光辉」（Lunatic·魔理沙Ａ） — `ecldata4.ecl:Sub44`
- [ ] TH32/3940 木＆火符「森林大火」（Lunatic·魔理沙Ａ） — `ecldata4.ecl:Sub56`
- [ ] TH32/3941 土＆金符「翡翠巨石」（Lunatic·魔理沙Ａ） — `ecldata4.ecl:Sub59`
- [ ] TH32/3942 火＆土符「熔岩巨石」（Lunatic·魔理沙Ａ） — `ecldata4.ecl:Sub55`
- [ ] TH32/3943 帕秋莉 非符一（Lunatic·魔理沙Ｂ） — `ecldata4.ecl:Sub27`
- [ ] TH32/3944 土符「三石塔上级」（Lunatic·魔理沙Ｂ） — `ecldata4.ecl:Sub51`
- [ ] TH32/3945 帕秋莉 非符二（Lunatic·魔理沙Ｂ） — `ecldata4.ecl:Sub37`
- [ ] TH32/3946 金符「银龙」（Lunatic·魔理沙Ｂ） — `ecldata4.ecl:Sub54`
- [ ] TH32/3947 土＆金符「翡翠巨石」（Lunatic·魔理沙Ｂ） — `ecldata4.ecl:Sub59`
- [ ] TH32/3948 水＆木符「水精灵」（Lunatic·魔理沙Ｂ） — `ecldata4.ecl:Sub57`
- [ ] TH32/3949 金＆水符「水银之毒」（Lunatic·魔理沙Ｂ） — `ecldata4.ecl:Sub58`
- [ ] TH32/3950 五面中 Boss 非符（Lunatic） — `ecldata5.ecl:Sub13`
- [ ] TH32/3951 奇术「迷惑误导」（Lunatic） — `ecldata5.ecl:Sub18`
- [ ] TH32/3952 咲夜 非符一（Lunatic） — `ecldata5.ecl:Sub22`
- [ ] TH32/3953 幻幽「夜雾幻影杀人鬼」（Lunatic） — `ecldata5.ecl:Sub45`
- [ ] TH32/3954 咲夜 非符二（Lunatic） — `ecldata5.ecl:Sub34`
- [ ] TH32/3955 幻世「世界」（Lunatic） — `ecldata5.ecl:Sub47`
- [ ] TH32/3956 咲夜 非符三（Lunatic） — `ecldata5.ecl:Sub41`
- [ ] TH32/3957 女仆秘技「杀人玩偶」（Lunatic） — `ecldata5.ecl:Sub50`
- [ ] TH32/3958 六面中 Boss 非符（Lunatic） — `ecldata6.ecl:Sub9`
- [ ] TH32/3959 奇术「永恒的温柔」（Lunatic） — `ecldata6.ecl:Sub14`
- [ ] TH32/3960 蕾米莉亚 非符一（Lunatic） — `ecldata6.ecl:Sub17`
- [ ] TH32/3961 蕾米莉亚 非符二（Lunatic） — `ecldata6.ecl:Sub19`
- [ ] TH32/3962 蕾米莉亚 非符三（Lunatic） — `ecldata6.ecl:Sub23`
- [ ] TH32/3963 蕾米莉亚 非符四（Lunatic） — `ecldata6.ecl:Sub26`
- [ ] TH32/3964 月符「沉默的月神」（Extra） — `ecldata7.ecl:Sub22`
- [ ] TH32/3965 日符「皇家烈焰」（Extra） — `ecldata7.ecl:Sub23`
- [ ] TH32/3966 火水木金土符「贤者之石」（Extra） — `ecldata7.ecl:Sub24`
- [ ] TH32/3967 芙兰朵露 非符一（Extra） — `ecldata7.ecl:Sub32`
- [ ] TH32/3968 禁忌「红莓陷阱」（Extra） — `ecldata7.ecl:Sub33`
- [ ] TH32/3969 芙兰朵露 非符二（Extra） — `ecldata7.ecl:Sub35`
- [ ] TH32/3970 禁忌「莱瓦汀」（Extra） — `ecldata7.ecl:Sub36`
- [ ] TH32/3971 芙兰朵露 非符三（Extra） — `ecldata7.ecl:Sub38`
- [ ] TH32/3972 禁忌「四重存在」（Extra） — `ecldata7.ecl:Sub39`
- [ ] TH32/3973 芙兰朵露 非符四（Extra） — `ecldata7.ecl:Sub43`
- [ ] TH32/3974 禁忌「笼中鸟」（Extra） — `ecldata7.ecl:Sub44`
- [ ] TH32/3975 芙兰朵露 非符五（Extra） — `ecldata7.ecl:Sub47`
- [ ] TH32/3976 禁忌「恋之迷宫」（Extra） — `ecldata7.ecl:Sub48`
- [ ] TH32/3977 芙兰朵露 非符六（Extra） — `ecldata7.ecl:Sub49`
- [ ] TH32/3978 禁弹「星弧破碎」（Extra） — `ecldata7.ecl:Sub50`
- [ ] TH32/3979 芙兰朵露 非符七（Extra） — `ecldata7.ecl:Sub53`
- [ ] TH32/3980 禁弹「折反射」（Extra） — `ecldata7.ecl:Sub54`
- [ ] TH32/3981 芙兰朵露 非符八（Extra） — `ecldata7.ecl:Sub56`
- [ ] TH32/3982 禁弹「刻着过去的钟表」（Extra） — `ecldata7.ecl:Sub57`
- [ ] TH32/3983 芙兰朵露 非符九（Extra） — `ecldata7.ecl:Sub59`
- [ ] TH32/3984 秘弹「之后就一个人都没有了吗？」（Extra） — `ecldata7.ecl:Sub60`
- [ ] TH32/3985 ＱＥＤ「４９５年的波纹」（Extra） — `ecldata7.ecl:Sub68`
- [ ] TH32/4000 一面道中·前半 — `ecldata1.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4001 一面道中·后半 — `ecldata1.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4002 二面道中·前半 — `ecldata2.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4003 二面道中·后半 — `ecldata2.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4004 三面道中·前半 — `ecldata3.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4005 三面道中·后半 — `ecldata3.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4006 四面道中·前半 — `ecldata4.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4007 四面道中·后半 — `ecldata4.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4008 五面道中·前半 — `ecldata5.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4009 五面道中·后半 — `ecldata5.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4010 六面道中·前半 — `ecldata6.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4011 六面道中·后半（入场等待） — `ecldata6.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4012 Extra道中·前半 — `ecldata7.ecl:时间轴窗口待逐行核对`
- [ ] TH32/4013 Extra道中·后半 — `ecldata7.ecl:时间轴窗口待逐行核对`
- 自制：TH32/368 「克罗里·尤斯福德」（无原作ECL，不计入完成数）

## TH33

- [ ] TH33/4480 八云蓝 非符（场景70） — `ecl16_a.ecl:Sub2`
- [ ] TH33/410 幽雅「死出の誘蛾灯」 — `ecl17_a.ecl:Sub2`
- [ ] TH33/411 蝶符「鳳蝶紋の死槍」 — `ecl17_b.ecl:Sub2`
- [ ] TH33/416 死符「酔人の生、死の夢幻」 — `ecl17_c.ecl:Sub2`
- [ ] TH33/412 「死蝶浮月」 — `ecl17_d.ecl:Sub2`
- [ ] TH33/413 密符「御大師様の秘鍵」 — `ecl16_b.ecl:Sub2`
- [ ] TH33/414 行符「八千万枚護摩」 — `ecl16_c.ecl:Sub2`
- [ ] TH33/415 超人「飛翔役小角」 — `ecl16_d.ecl:Sub2`
- [ ] TH33/453 禁忌「フォービドゥンフルーツ」 — `ecl22_a.ecl:Sub2`
- [ ] TH33/454 禁忌「禁じられた遊び」 — `ecl22_b.ecl:Sub2`
- [ ] TH33/455 境符「色と空の境界」 — `ecl23_a.ecl:Sub2`
- [ ] TH33/456 境符「波と粒の境界」 — `ecl23_b.ecl:Sub2`
- [ ] TH33/457 貴人「サンジェルマンの忠告」 — `ecl24_a.ecl:Sub2`
- [ ] TH33/458 蓬莱「瑞江浦嶋子と五色の瑞亀」 — `ecl24_b.ecl:Sub2`
- [ ] TH33/459 鬼気「濛々迷霧」 — `ecl25_a.ecl:Sub2`
- [ ] TH33/460 「百万鬼夜行」 — `ecl25_b.ecl:Sub2`
- [ ] TH33/470  — `ecl20_a.ecl:Sub2`
- [ ] TH33/471 嘘言「タン・オブ・ウルフ」 — `ecl21_a.ecl:Sub2`
- [ ] TH33/472 死歌「八重霧の渡し」 — `ecl20_b.ecl:Sub2`
- [ ] TH33/473 審判「十王裁判」 — `ecl21_b.ecl:Sub2`
- [ ] TH33/474 古雨「黄泉中有の旅の雨」 — `ecl20_c.ecl:Sub2`
- [ ] TH33/475 審判「ギルティ・オワ・ノットギルティ」 — `ecl21_c.ecl:Sub2`
- [ ] TH33/476 死価「プライス・オブ・ライフ」 — `ecl20_d.ecl:Sub2`
- [ ] TH33/477 審判「浄頗梨審判　-射命丸文-」 — `ecl21_d.ecl:Sub2`
- [ ] TH33/478  — `ecl18_a.ecl:Sub2`
- [ ] TH33/479 新難題「月のイルメナイト」 — `ecl19_a.ecl:Sub2`
- [ ] TH33/480 薬符「胡蝶夢丸ナイトメア」 — `ecl18_b.ecl:Sub2`
- [ ] TH33/481 新難題「エイジャの赤石」 — `ecl19_b.ecl:Sub2`
- [ ] TH33/482 錬丹「水銀の海」 — `ecl18_c.ecl:Sub2`
- [ ] TH33/483 新難題「金閣寺の一枚天井」 — `ecl19_c.ecl:Sub2`
- [ ] TH33/484 秘薬「仙香玉兎」 — `ecl18_d.ecl:Sub2`
- [ ] TH33/485 新難題「ミステリウム」 — `ecl19_d.ecl:Sub2`
- [ ] TH33/486  — `ecl14_a.ecl:Sub2`
- [ ] TH33/487 魔符「全世界ナイトメア」 — `ecl15_a.ecl:Sub2`
- [ ] TH33/488 時符「トンネルエフェクト」 — `ecl14_b.ecl:Sub2`
- [ ] TH33/489 紅符「ブラッディマジックスクウェア」 — `ecl15_b.ecl:Sub2`
- [ ] TH33/490 空虚「インフレーションスクウェア」 — `ecl14_c.ecl:Sub2`
- [ ] TH33/491 紅蝙蝠「ヴァンピリッシュナイト」 — `ecl15_c.ecl:Sub2`
- [ ] TH33/492 銀符「パーフェクトメイド」 — `ecl14_d.ecl:Sub2`
- [ ] TH33/493 神鬼「レミリアストーカー」 — `ecl15_d.ecl:Sub2`
- [ ] TH33/494  — `ecl12_a.ecl:Sub2`
- [ ] TH33/495 人智剣「天女返し」 — `ecl13_a.ecl:Sub2`
- [ ] TH33/496 星符「飛び重ね鱗」 — `ecl12_b.ecl:Sub2`
- [ ] TH33/497 妄執剣「修羅の血」 — `ecl13_b.ecl:Sub2`
- [ ] TH33/498 鬼神「鳴動持国天」 — `ecl12_c.ecl:Sub2`
- [ ] TH33/499 天星剣「涅槃寂静の如し」 — `ecl13_c.ecl:Sub2`
- [ ] TH33/500 化猫「橙」 — `ecl12_d.ecl:Sub2`
- [ ] TH33/501 四生剣「衆生無情の響き」 — `ecl13_d.ecl:Sub2`
- [ ] TH33/502  — `ecl10_a.ecl:Sub2`
- [ ] TH33/503 日＆水符「ハイドロジェナスプロミネンス」 — `ecl11_a.ecl:Sub2`
- [ ] TH33/504 華符「彩光蓮華掌」 — `ecl10_b.ecl:Sub2`
- [ ] TH33/505 水＆火符「フロギスティックレイン」 — `ecl11_b.ecl:Sub2`
- [ ] TH33/506 彩翔「飛花落葉」 — `ecl10_c.ecl:Sub2`
- [ ] TH33/507 月＆木符「サテライトヒマワリ」 — `ecl11_c.ecl:Sub2`
- [ ] TH33/508 彩華「虹色太極拳」 — `ecl10_d.ecl:Sub2`
- [ ] TH33/509 日＆月符「ロイヤルダイアモンドリング」 — `ecl11_d.ecl:Sub2`
- [ ] TH33/510  — `ecl7_a.ecl:Sub2`
- [ ] TH33/514 霧符「ガシングガーデン」 — `ecl9_a.ecl:Sub2`
- [ ] TH33/517 脱兎「フラスターエスケープ」 — `ecl8_a.ecl:Sub2`
- [ ] TH33/511 散符「朧月花栞（ロケット・イン・ミスト）」 — `ecl7_b.ecl:Sub2`
- [ ] TH33/515 毒符「ポイズンブレス」 — `ecl9_b.ecl:Sub2`
- [ ] TH33/512 波符「幻の月（インビジブルハーフムーン）」 — `ecl7_c.ecl:Sub2`
- [ ] TH33/516 譫妄「イントゥデリリウム」 — `ecl9_c.ecl:Sub2`
- [ ] TH33/518 借符「大穴牟遅様の薬」 — `ecl8_b.ecl:Sub2`
- [ ] TH33/513 狂夢「風狂の夢（ドリームワールド）」 — `ecl7_d.ecl:Sub2`
- [ ] TH33/519  — `ecl6_a.ecl:Sub2`
- [ ] TH33/520 操符「ドールズインシー」 — `ecl6_b.ecl:Sub2`
- [ ] TH33/521 呪符「ストロードールカミカゼ」 — `ecl6_c.ecl:Sub2`
- [ ] TH33/522 赤符「ドールミラセティ」 — `ecl6_d.ecl:Sub2`
- [ ] TH33/523 光符「アマテラス」 — `ecl5_a.ecl:Sub2`
- [ ] TH33/524 包符「昭和の雨」 — `ecl5_b.ecl:Sub2`
- [ ] TH33/525 葵符「水戸の光圀」 — `ecl5_c.ecl:Sub2`
- [ ] TH33/526 倭符「邪馬台の国」 — `ecl5_d.ecl:Sub2`
- [ ] TH33/527  — `ecl3_a.ecl:Sub2`
- [ ] TH33/528 雪符「ダイアモンドブリザード」 — `ecl3_b.ecl:Sub2`
- [ ] TH33/529 凍符「マイナスＫ」 — `ecl3_c.ecl:Sub2`
- [ ] TH33/530  — `ecl4_a.ecl:Sub2`
- [ ] TH33/531 寒符「コールドスナップ」 — `ecl4_b.ecl:Sub2`
- [ ] TH33/532 冬符「ノーザンウイナー」 — `ecl4_c.ecl:Sub3`
- [ ] TH33/533  — `ecl1_a.ecl:Sub2`
- [ ] TH33/534 蛍符「地上の恒星」 — `ecl1_b.ecl:Sub2`
- [ ] TH33/535 蝶符「バタフライストーム」 — `ecl1_c.ecl:Sub2`
- [ ] TH33/536  — `ecl2_a.ecl:Sub2`
- [ ] TH33/537 闇符「ダークサイドオブザムーン」 — `ecl2_b.ecl:Sub2`
- [ ] TH33/538 夜符「ミッドナイトバード」 — `ecl2_c.ecl:Sub2`

## TH34

- [ ] TH34/3405 六面道中「成群的亡灵」 — `ecldata6.ecl:时间轴窗口待逐行核对`
- [ ] TH34/3403 四面道中「骚灵们的合奏」 — `ecldata4.ecl:时间轴窗口待逐行核对`
- [ ] TH34/3402 三道中「青之骚灵」 — `ecldata3.ecl:时间轴窗口待逐行核对`
- [ ] TH34/3404 五道中「幽明之径」 — `ecldata5.ecl:时间轴窗口待逐行核对`
- [ ] TH34/3400 一道中「初雪之妖精」 — `ecldata1.ecl:时间轴窗口待逐行核对`
- [ ] TH34/3401 二道中「雪之回廊」 — `ecldata2.ecl:时间轴窗口待逐行核对`
- [ ] TH34/3406 EX 道中「妖妖梦・Extra」 — `ecldata7.ecl:时间轴窗口待逐行核对`
- [ ] TH34/3407 PH 道中「妖妖梦・Phantasm」 — `ecldata8.ecl:时间轴窗口待逐行核对`
- [ ] TH34/3408 藍 非符 0 — `ecldata8.ecl:Sub57`
- [ ] TH34/3411 紫 非符 1 — `ecldata8.ecl:Sub70`
- [ ] TH34/3413 紫 非符 2 — `ecldata8.ecl:Sub72`
- [ ] TH34/3415 紫 非符 3 — `ecldata8.ecl:Sub73`
- [ ] TH34/3417 紫 非符 4 — `ecldata8.ecl:Sub75`
- [ ] TH34/3419 紫 非符 5 — `ecldata8.ecl:Sub77`
- [ ] TH34/3421 紫 非符 6 — `ecldata8.ecl:Sub79`
- [ ] TH34/3423 紫 非符 7 — `ecldata8.ecl:Sub81`
- [ ] TH34/3425 紫 非符 8 — `ecldata8.ecl:Sub83`
- [ ] TH34/3440 紫奥義「弾幕結界」 — `ecldata8.ecl:Sub129`
- [ ] TH34/3441 結界「生と死の境界」 — `ecldata8.ecl:Sub127`
- [ ] TH34/3442 「人間と妖怪の境界」 — `ecldata8.ecl:Sub119`
- [ ] TH34/3443 式神「八雲藍」 — `ecldata8.ecl:Sub114`
- [ ] TH34/3444 魍魎「二重黒死蝶」 — `ecldata8.ecl:Sub109`
- [ ] TH34/3445 罔両「禅寺に棲む妖蝶」 — `ecldata8.ecl:Sub104`
- [ ] TH34/3446 罔両「八雲紫の神隠し」 — `ecldata8.ecl:Sub102`
- [ ] TH34/3447 罔両「ストレートとカーブの夢郷」 — `ecldata8.ecl:Sub100`
- [ ] TH34/3448 結界「光と闇の網目」 — `ecldata8.ecl:Sub97`
- [ ] TH34/3449 結界「動と静の均衡」 — `ecldata8.ecl:Sub93`
- [ ] TH34/3450 結界「夢と現の呪」 — `ecldata8.ecl:Sub88`
- [ ] TH34/3451 式神「憑依荼吉尼天」 — `ecldata8.ecl:Sub63`
- [ ] TH34/3452 式神「前鬼後鬼の守護」 — `ecldata8.ecl:Sub60`
- [ ] TH34/3471 幻神「飯綱権現降臨」 — `ecldata7.ecl:Sub123`
- [ ] TH34/3470 「狐狗狸さんの契約」 — `ecldata7.ecl:Sub115`
- [ ] TH34/3469 式神「橙」 — `ecldata7.ecl:Sub110`
- [ ] TH34/3468 式弾「ユーニラタルコンタクト」 — `ecldata7.ecl:Sub106`
- [ ] TH34/3467 式弾「アルティメットブディスト」 — `ecldata7.ecl:Sub101`
- [ ] TH34/3466 式輝「プリンセス天狐　-Illusion-」 — `ecldata7.ecl:Sub99`
- [ ] TH34/3465 式輝「四面楚歌チャーミング」 — `ecldata7.ecl:Sub97`
- [ ] TH34/3464 式輝「狐狸妖怪レーザー」 — `ecldata7.ecl:Sub94`
- [ ] TH34/3463 式神「十二神将の宴」 — `ecldata7.ecl:Sub88`
- [ ] TH34/3462 式神「仙狐思念」 — `ecldata7.ecl:Sub85`
- [ ] TH34/3461 鬼神「飛翔毘沙門天」 — `ecldata7.ecl:Sub61`
- [ ] TH34/3460 鬼符「青鬼赤鬼」 — `ecldata7.ecl:Sub58`
- [ ] TH34/3480 EX 非符 1 — `ecldata7.ecl:Sub68`
- [ ] TH34/3481 EX 非符 2 — `ecldata7.ecl:Sub70`
- [ ] TH34/3482 EX 非符 3 — `ecldata7.ecl:Sub71`
- [ ] TH34/3483 EX 非符 4 — `ecldata7.ecl:Sub73`
- [ ] TH34/3484 EX 非符 5 — `ecldata7.ecl:Sub75`
- [ ] TH34/3485 EX 非符 6 — `ecldata7.ecl:Sub77`
- [ ] TH34/3486 EX 非符 7 — `ecldata7.ecl:Sub79`
- [ ] TH34/3487 EX 非符 8 — `ecldata7.ecl:Sub81`
- [ ] TH34/3488 EX 橙 非符 0 — `ecldata7.ecl:Sub55`
- [ ] TH34/4390 幽々子 非符 1 — `ecldata6.ecl:Sub19`
- [ ] TH34/4391 六道剣「一念無量劫 -Lunatic-」 — `ecldata6.ecl:Sub23`
- [ ] TH34/4392 幽々子 非符 2 — `ecldata6.ecl:Sub29`
- [ ] TH34/4393 亡郷「亡我郷 -自尽-」 — `ecldata6.ecl:Sub43`
- [ ] TH34/4394 幽々子 非符 3 — `ecldata6.ecl:Sub34`
- [ ] TH34/4395 幽々子 非符 4 — `ecldata6.ecl:Sub36`
- [ ] TH34/4396 亡舞「生者必滅の理 -魔境-」 — `ecldata6.ecl:Sub50`
- [ ] TH34/4397 華霊「バタフライディルージョン」 — `ecldata6.ecl:Sub52`
- [ ] TH34/4398 幽々子 非符 5 — `ecldata6.ecl:Sub38`
- [ ] TH34/4399 幽曲「リポジトリ・オブ・ヒロカワ -神霊-」 — `ecldata6.ecl:Sub55`
- [ ] TH34/4400 桜符「完全なる墨染の桜 -開花-」 — `ecldata6.ecl:Sub58`
- [ ] TH34/4401 「反魂蝶 -八分咲-」 — `ecldata6.ecl:Sub62`
- [ ] TH34/4402 妖夢 非符 1 — `ecldata5.ecl:Sub38`
- [ ] TH34/4403 餓王剣「餓鬼十王の報い」 — `ecldata5.ecl:Sub42`
- [ ] TH34/4404 妖夢 非符 2 — `ecldata5.ecl:Sub48`
- [ ] TH34/4405 獄神剣「業風神閃斬」 — `ecldata5.ecl:Sub57`
- [ ] TH34/4406 妖夢 非符 3 — `ecldata5.ecl:Sub52`
- [ ] TH34/4407 修羅剣「現世妄執 -Lunatic-」 — `ecldata5.ecl:Sub62`
- [ ] TH34/4408 畜趣剣「無為無策の冥罰」 — `ecldata5.ecl:Sub66`
- [ ] TH34/4409 人神剣「俗諦常住」 — `ecldata5.ecl:Sub70`
- [ ] TH34/4410 天神剣「三魂七魄」 — `ecldata5.ecl:Sub75`
- [ ] TH34/4430 アリス 非符 1 — `ecldata3.ecl:Sub22`
- [ ] TH34/4431 操符「乙女文楽　-Lunatic-」 — `ecldata3.ecl:Sub27`
- [ ] TH34/4432 アリス 非符 1 — `ecldata3.ecl:Sub32`
- [ ] TH34/4433 蒼符「博愛のオルレアン人形」 — `ecldata3.ecl:Sub42`
- [ ] TH34/4434 アリス 非符 2 — `ecldata3.ecl:Sub36`
- [ ] TH34/4435 白符「白亜の露西亜人形 -Lunatic-」 — `ecldata3.ecl:Sub48`
- [ ] TH34/4436 アリス 非符 3 — `ecldata3.ecl:Sub37`
- [ ] TH34/4437 雅符「春の京人形」 — `ecldata3.ecl:Sub54`
- [ ] TH34/4438 咒詛「首吊り蓬莱人形」 — `ecldata3.ecl:Sub56`
- [ ] TH34/4440 露娜萨 非符 1 — `ecldata4.ecl:Sub58`
- [ ] TH34/5480 露娜萨 非符 2 — `ecldata4.ecl:Sub64`
- [ ] TH34/5483 露娜萨 非符 3 — `ecldata4.ecl:Sub68`
- [x] TH34/4441 騒符「ライブポルターガイスト -Lunatic-」 — `ecldata4.ecl:Sub121`；[核对记录](#34-4441)
- [ ] TH34/4442 梅露兰 非符 1 — `ecldata4.ecl:Sub76`
- [ ] TH34/5481 梅露兰 非符 2 — `ecldata4.ecl:Sub80`
- [ ] TH34/5484 梅露兰 非符 3 — `ecldata4.ecl:Sub83`
- [ ] TH34/4443 管霊「ゴーストクリフォード -Lunatic-」 — `ecldata4.ecl:Sub138`
- [ ] TH34/4444 莉莉卡 非符 1 — `ecldata4.ecl:Sub95`
- [ ] TH34/5482 莉莉卡 非符 2 — `ecldata4.ecl:Sub98`
- [ ] TH34/5485 莉莉卡 非符 3 — `ecldata4.ecl:Sub103`
- [ ] TH34/4445 鍵霊「ベーゼンドルファー神奏 -Lunatic-」 — `ecldata4.ecl:Sub145`
- [ ] TH34/4446 偽弦「スードストラディヴァリウス」 — `ecldata4.ecl:Sub128`
- [ ] TH34/4447 騒葬「スティジャンリバーサイド -Lunatic-」 — `ecldata4.ecl:Sub133`
- [ ] TH34/4448 大合葬「霊車コンチェルトグロッソ怪」 — `ecldata4.ecl:Sub135`
- [ ] TH34/4450 レティ 非符 1 — `ecldata1.ecl:Sub20`
- [ ] TH34/4451 霜符「フロストコラムス -Lunatic-」 — `ecldata1.ecl:Sub29`
- [ ] TH34/4452 レティ 非符 2 — `ecldata1.ecl:Sub38`
- [ ] TH34/4453 寒符「リンガリングコールド -Lunatic-」 — `ecldata1.ecl:Sub42`
- [ ] TH34/4454 レティ 非符 3 — `ecldata1.ecl:Sub39`
- [ ] TH34/4455 白符「アンデュレイションレイ」 — `ecldata1.ecl:Sub52`
- [ ] TH34/4456 怪符「テーブルターニング」 — `ecldata1.ecl:Sub55`
- [ ] TH34/4460 橙 非符 1 — `ecldata2.ecl:Sub40`
- [ ] TH34/4461 仙符「鳳凰展翅　-Lunatic-」 — `ecldata2.ecl:Sub45`
- [ ] TH34/4462 橙 非符 2 — `ecldata2.ecl:Sub49`
- [ ] TH34/4463 式符「飛翔晴明」 — `ecldata2.ecl:Sub56`
- [ ] TH34/4464 陰陽「晴明大紋」 — `ecldata2.ecl:Sub58`
- [ ] TH34/4465 橙 非符 3 — `ecldata2.ecl:Sub53`
- [ ] TH34/4466 天符「天仙鳴動」 — `ecldata2.ecl:Sub64`
- [ ] TH34/4467 童符「護法天童乱舞」 — `ecldata2.ecl:Sub66`
- [ ] TH34/4468 仙符「屍解永遠」 — `ecldata2.ecl:Sub68`
- [ ] TH34/4469 方符「奇門遁甲」 — `ecldata2.ecl:Sub75`
- [ ] TH34/4457 冬符「フラワーウィザラウェイ」 — `ecldata1.ecl:Sub48`
- [ ] TH34/4439 紅符「紅毛の和蘭人形」 — `ecldata3.ecl:Sub46`
- [ ] TH34/4472 闇符「霧の倫敦人形」 — `ecldata3.ecl:Sub50`
- [ ] TH34/4473 廻符「輪廻の西蔵人形」 — `ecldata3.ecl:Sub52`
- [ ] TH34/4470 仙符「鳳凰卵」 — `ecldata2.ecl:Sub44`
- [ ] TH34/4471 鬼符「鬼門金神」 — `ecldata2.ecl:Sub70`
- [ ] TH34/4475 弦奏「グァルネリ・デル・ジェス」 — `ecldata4.ecl:Sub127`
- [ ] TH34/4476 合葬「プリズムコンチェルト」 — `ecldata4.ecl:Sub132`

## TH35

- [ ] TH35/3600 「風神様の神徳」 — `stage06.ecl:BossCard5`
- [ ] TH35/3601 光学「ハイドロカモフラージュ」 — `stage03.ecl:MBossCard1`
- [ ] TH35/3660 stage03 非符一 — `stage03.ecl:Boss1`
- [ ] TH35/3602 漂溺「光り輝く水底のトラウマ」 — `stage03.ecl:BossCard1`
- [ ] TH35/3661 stage03 非符二 — `stage03.ecl:Boss2`
- [ ] TH35/3603 水符「河童の幻想大瀑布」 — `stage03.ecl:BossCard2`
- [ ] TH35/3662 stage03 非符三 — `stage03.ecl:Boss3`
- [ ] TH35/3604 河童「スピン・ザ・セファリックプレート」 — `stage03.ecl:BossCard3L`
- [ ] TH35/3670 stage04 中BOSS 非符 — `stage04.ecl:MBoss`
- [ ] TH35/3663 stage04 非符一 — `stage04.ecl:Boss1`
- [ ] TH35/3605 岐符「サルタクロス」 — `stage04.ecl:BossCard1`
- [ ] TH35/3664 stage04 非符二 — `stage04.ecl:Boss2`
- [ ] TH35/3606 風神「二百十日」 — `stage04.ecl:BossCard2`
- [ ] TH35/3665 stage04 非符三 — `stage04.ecl:Boss3`
- [ ] TH35/3607 「無双風神」 — `stage04.ecl:BossCard3`
- [ ] TH35/3608 塞符「天上天下の照國」 — `stage04.ecl:BossCard4`
- [ ] TH35/3651 stage07 中BOSS 非符 — `stage07.ecl:MBoss1`
- [ ] TH35/3609 神符「水眼の如き美しき源泉」 — `stage07.ecl:MBossCard1`
- [ ] TH35/3610 神符「杉で結ぶ古き縁」 — `stage07.ecl:MBossCard2`
- [ ] TH35/3611 神符「神が歩かれた御神渡り」 — `stage07.ecl:MBossCard3`
- [x] TH35/3652 stage07 非符一 — `stage07.ecl:Boss1`；[核对记录](#35-3652)
- [x] TH35/3612 開宴「二拝二拍一拝」 — `stage07.ecl:BossCard1`；[核对记录](#35-3612)
- [ ] TH35/3653 stage07 非符二 — `stage07.ecl:Boss2`
- [ ] TH35/3613 土着神「手長足長さま」 — `stage07.ecl:BossCard2`
- [ ] TH35/3654 stage07 非符三 — `stage07.ecl:Boss3`
- [ ] TH35/3614 神具「洩矢の鉄の輪」 — `stage07.ecl:BossCard3`
- [ ] TH35/3655 stage07 非符四 — `stage07.ecl:Boss4`
- [ ] TH35/3615 源符「厭い川の翡翠」 — `stage07.ecl:BossCard4`
- [ ] TH35/3656 stage07 非符五 — `stage07.ecl:Boss5`
- [ ] TH35/3616 蛙狩「蛙は口ゆえ蛇に呑まるる」 — `stage07.ecl:BossCard5`
- [ ] TH35/3657 stage07 非符六 — `stage07.ecl:Boss6`
- [ ] TH35/3617 土着神「七つの石と七つの木」 — `stage07.ecl:BossCard6`
- [ ] TH35/3658 stage07 非符七 — `stage07.ecl:Boss7`
- [ ] TH35/3618 土着神「ケロちゃん風雨に負けず」 — `stage07.ecl:BossCard7`
- [ ] TH35/3659 stage07 非符八 — `stage07.ecl:Boss8`
- [ ] TH35/3619 土着神「宝永四年の赤蛙」 — `stage07.ecl:BossCard8`
- [ ] TH35/3620 「諏訪大戦　～ 土着神話 vs 中央神話」 — `stage07.ecl:BossCard9`
- [ ] TH35/3621 祟符「ミシャグジさま」 — `stage07.ecl:BossCard10`
- [ ] TH35/3666 stage06 非符一 — `stage06.ecl:Boss1`
- [ ] TH35/3667 stage06 非符二 — `stage06.ecl:Boss2`
- [ ] TH35/3668 stage06 非符三 — `stage06.ecl:Boss3`
- [ ] TH35/3669 stage06 非符四 — `stage06.ecl:Boss4`
- [ ] TH35/3622 stage06 符卡一 — `stage06.ecl:BossCard1`
- [ ] TH35/3623 stage06 符卡二 — `stage06.ecl:BossCard2`
- [ ] TH35/3624 stage06 符卡三 — `stage06.ecl:BossCard3H`
- [ ] TH35/3625 stage06 符卡四 — `stage06.ecl:BossCard4`
- [ ] TH35/3671 六面道中「妖怪之山的妖精」 — `stage06.ecl:main`
- [ ] TH35/3680 一道中「初雪之妖精」 — `stage01.ecl:main`
- [ ] TH35/3681 二道中「人里の妖精」 — `stage02.ecl:main`
- [ ] TH35/3682 三道中「河童の渓谷」 — `stage03.ecl:main`
- [ ] TH35/3683 四道中「妖怪の山」 — `stage04.ecl:main`
- [ ] TH35/3684 五道中「洩矢の王国跡」 — `stage05.ecl:main`
- [ ] TH35/3685 EX道中「ネイティブフェイス」 — `stage07.ecl:main`
- [ ] TH35/3642 stage01 中BOSS 非符 — `stage01.ecl:MBoss`
- [ ] TH35/3630 葉符「狂いの落葉」 — `stage01.ecl:MBossCard1`
- [ ] TH35/3643 stage01 非符一 — `stage01.ecl:Boss1`
- [ ] TH35/3631 秋符「秋の空と乙女の心」 — `stage01.ecl:BossCard1`
- [ ] TH35/3644 stage01 非符二 — `stage01.ecl:Boss2`
- [ ] TH35/3632 豊作「穀物神の約束」 — `stage01.ecl:BossCard2`
- [x] TH35/3633 厄符「厄神様のバイオリズム」 — `stage02.ecl:MBossCard1`；[核对记录](#35-3633)
- [ ] TH35/3645 stage02 非符一 — `stage02.ecl:Boss1`
- [ ] TH35/3634 疵痕「壊されたお守り」 — `stage02.ecl:BossCard1`
- [ ] TH35/3646 stage02 非符二 — `stage02.ecl:Boss2`
- [ ] TH35/3635 悲運「大鐘婆の火」 — `stage02.ecl:BossCard2`
- [ ] TH35/3636 創符「流刑人形」 — `stage02.ecl:BossCard3`
- [ ] TH35/3647 stage05 中BOSS 非符 — `stage05.ecl:MBoss`
- [ ] TH35/3637 秘術「一子相伝の弾幕」 — `stage05.ecl:MBossCard1`
- [ ] TH35/3648 stage05 非符一 — `stage05.ecl:Boss1`
- [ ] TH35/3638 奇跡「客星の明るすぎる夜」 — `stage05.ecl:BossCard1`
- [ ] TH35/3649 stage05 非符二 — `stage05.ecl:Boss2`
- [ ] TH35/3639 開海「モーゼの奇跡」 — `stage05.ecl:BossCard2`
- [ ] TH35/3650 stage05 非符三 — `stage05.ecl:Boss3`
- [ ] TH35/3640 準備「サモンタケミナカタ」 — `stage05.ecl:BossCard3`
- [ ] TH35/3641 大奇跡「八坂の神風」 — `stage05.ecl:BossCard4`

<a id="31-351"></a>
## TH31/351 「季节外调的蝴蝶风暴」

- 修复Sub36@0x7df4速度0的随机移动被省略后少抽一次随机数：CALL Sub37耗112帧，因此在卡内352+n×302补上原随机消费。
- 恢复Sub37第9槽SoundIdx27的原始se_kira02；共享EX变换执行器的PLAY_SOUND也使用原逻辑编号和音量。
- 核对110入场、48个发弹时点、两段8×7帧CALL、302帧周期、每三轮加一列、使魔13+13组及WAIT/换图/折向的先后。

阶段接口：登记符卡、开卡清场、5940帧超时及死亡跳转接入现有Boss Rush阶段接口；未重放原作剧情和计分。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata1sp.ecl:Sub36` | `0x7b6c`, `0x7b7c`, `0x7b88`, `0x7b9c`, `0x7bac`, `0x7bc0`, `0x7bd4`, `0x7be0`, `0x7bf0`, `0x7c04`, `0x7c20`, `0x7d14`, `0x7d24`, `0x7d34`, `0x7d48`, `0x7d5c`, `0x7d70`, `0x7d84`, `0x7d9c`, `0x7dc4`, `0x7dd0`, `0x7de4`, `0x7df4`, `0x7e0c`, `0x7e20`, `0x7e34`, `0x7e4c`, `0x7e60`, `0x7e6c`, `0x7e84`, `0x7e9c`, `0x7eb4`, `0x7ec4`, `0x7ee0`, `0x7ef4`, `0x7f04` | CARD[205]/boss_frame：110初始化和生成Sub38，CALL112帧；父时钟240/300，周期302；符号每轮翻转、列数每三轮加1；0速随机移动保留随机消费。 |
| `ecldata1sp.ecl:Sub37` | `0x7f24`, `0x7f38`, `0x7f4c`, `0x7f60`, `0x7f78`, `0x7f8c`, `0x7fa0`, `0x7fc8`, `0x7ff0`, `0x800c`, `0x8034`, `0x8048`, `0x8070`, `0x8098`, `0x80c0`, `0x80e8`, `0x8110`, `0x8138`, `0x8160`, `0x8188`, `0x81b4`, `0x81dc`, `0x8208`, `0x8234`, `0x8248`, `0x825c`, `0x8284`, `0x82ac`, `0x82d8`, `0x8300`, `0x832c`, `0x8358`, `0x836c`, `0x8380`, `0x83a8`, `0x83d0`, `0x83fc`, `0x8424`, `0x8450`, `0x847c`, `0x8490`, `0x84a4`, `0x84b8`, `0x84d0`, `0x84e4`, `0x850c`, `0x8534`, `0x8560`, `0x8588`, `0x85b4`, `0x85e0`, `0x85f4`, `0x8608`, `0x8630`, `0x8658`, `0x8684`, `0x86ac`, `0x86d8`, `0x8704`, `0x8718`, `0x872c`, `0x8754`, `0x877c`, `0x87a8`, `0x87d0`, `0x87fc`, `0x8828`, `0x883c`, `0x8850`, `0x8864`, `0x887c` | SUB37_SHOTS/storm_program/storm_bullet：首段0/3/5，次段0/2/5；每段8次；f4掩码排除、f8执行双层；按0..9槽依次等待60、减速转90°、换图、60帧停弹、换色、等10、转向启动并播27。 |
| `ecldata1sp.ecl:Sub38` | `0x8894`, `0x88a4`, `0x88b0`, `0x88c4`, `0x88d8`, `0x8900`, `0x892c`, `0x8944`, `0x8958`, `0x8980`, `0x89ac`, `0x89c4` | familiar.frame：自身300帧开始；每5帧一圈24发，两段各13圈，正负0.006981317极坐标角速度各120帧；26圈后重取自机角。 |

<a id="31-352"></a>
## TH31/352 「盲夜鸟」

- 逐行核对无独立使魔：根在140/170安装夜盲context3和发弹context0。
- 恢复110帧SoundIdx15及ExIns1的60帧白色场地脉冲；脉冲按原calc优先级从出生后的下一拍计算。
- Sub47的op36第三参4是插值回调号，第四参0才是线性缓动；保留正确的10帧alpha、120帧半径、125次后1800帧第二段。

阶段接口：登记符卡、开卡清场、5940帧超时及死亡跳转接入现有Boss Rush阶段接口；未重放原作剧情和计分。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata2sp.ecl:Sub46` | `0x7888`, `0x7898`, `0x78a4`, `0x78b8`, `0x78c8`, `0x78dc`, `0x78f0`, `0x78fc`, `0x790c`, `0x7920`, `0x793c`, `0x7a30`, `0x7a40`, `0x7a50`, `0x7a64`, `0x7a74`, `0x7a88`, `0x7a9c` | CARD[206]/boss_frame及演出调度：110帧开判定/脉冲/声音，140/170挂两个context；370回跳只空转，不重复安装。 |
| `ecldata2sp.ecl:Sub47` | `0x7abc`, `0x7ae8`, `0x7b14`, `0x7b28`, `0x7b3c`, `0x7b50`, `0x7b68`, `0x7b94`, `0x7ba8`, `0x7bbc` | th31_nightblind.effect：alpha0→255/10拍、半径320→96/120拍；125次循环后96→64/1800拍；没有把回调4误作缓动4。 |
| `ecldata2sp.ecl:Sub48` | `0x7bdc`, `0x7bf0`, `0x7c04`, `0x7c18`, `0x7c30`, `0x7c44`, `0x7c5c`, `0x7c88`, `0x7c9c`, `0x7cb0`, `0x7cc0`, `0x7cd8`, `0x7cec`, `0x7d04`, `0x7d18`, `0x7d30`, `0x7d5c`, `0x7d70`, `0x7d84`, `0x7d94`, `0x7dac`, `0x7dc0`, `0x7dd8`, `0x7dec`, `0x7e04`, `0x7e30`, `0x7e44`, `0x7e58`, `0x7e68`, `0x7e80`, `0x7e94`, `0x7eac`, `0x7ec0`, `0x7ed8`, `0x7f04`, `0x7f18`, `0x7f2c`, `0x7f3c`, `0x7f54`, `0x7f6c`, `0x7f80`, `0x7fac`, `0x7fc4`, `0x7fe0`, `0x7ff4` | lw206_shot_fan/circle、lw206_move_angle：4×24拍单角8速流，交替旋向；第96拍先随机移动后发15圈、圈间20拍；396周期，列数32起每轮+6直到68。 |

<a id="31-353"></a>
## TH31/353 「日出之国的天子」

- 逐行核对十只使魔的出生坐标/继承角/正负角速度；40帧停在半径32，100帧改1/16角速度，3700帧终止。
- 逐行核对激光两组各60发、延迟190递减到72、第二组+183°、320帧周期；补回两组开始的原始SoundIdx16。
- 核对Sub59每60帧的0/20/40三拍，第一拍同时自机狙0.9与朝内1.1，其余拍只朝内；根290回跳只加xi3。

阶段接口：登记符卡、开卡清场、5940帧超时及死亡跳转接入现有Boss Rush阶段接口；未重放原作剧情和计分。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata3sp.ecl:Sub56` | `0x84d0`, `0x84e0`, `0x84ec`, `0x8500`, `0x8510`, `0x8524`, `0x8538`, `0x8544`, `0x8554`, `0x8568`, `0x8584`, `0x8678`, `0x8688`, `0x8698`, `0x86a4`, `0x86b8`, `0x86cc`, `0x86e0`, `0x8704`, `0x8718`, `0x873c`, `0x8750`, `0x8774`, `0x8788`, `0x879c`, `0x87b0`, `0x87d4`, `0x87e8`, `0x880c`, `0x8820`, `0x8844`, `0x8858`, `0x886c`, `0x8880`, `0x88a4`, `0x88b8`, `0x88dc`, `0x88f0`, `0x8904`, `0x8928`, `0x893c`, `0x8960`, `0x8974`, `0x8984` | CARD[207]/FAMILIARS：110帧一次生成3+3+4只使魔并挂Sub57；290跳转落在INT_INC，没有重建使魔。 |
| `ecldata3sp.ecl:Sub57` | `0x89a4`, `0x89b0`, `0x89c4`, `0x89d4`, `0x89ec`, `0x8a00`, `0x8a10`, `0x8a50`, `0x8a64`, `0x8a78`, `0x8a90`, `0x8aa4`, `0x8ab4`, `0x8ac8`, `0x8adc`, `0x8aec`, `0x8b2c`, `0x8b40`, `0x8b54`, `0x8b6c` | laser_step/lw207_laser：120开始两段60次逐帧生成，间隔1拍；两次JUMP_DEC各延长59拍，322→120得到320拍周期；190预告、30实体、20消散。 |
| `ecldata3sp.ecl:Sub58` | `0x8b8c`, `0x8b9c`, `0x8bac`, `0x8bbc`, `0x8bd0`, `0x8be0`, `0x8bf0`, `0x8c04`, `0x8c18`, `0x8c40`, `0x8c54`, `0x8c6c`, `0x8c80`, `0x8c98` | lw207_familiar及th08_combat.birth_step：出生ECL计算轨道不提交位移；正常更新主context先于枪；40停、100慢转、3700终止，保留原交互表。 |
| `ecldata3sp.ecl:Sub59` | `0x8cb0`, `0x8cbc`, `0x8ce8`, `0x8d08`, `0x8d34`, `0x8d54`, `0x8d80`, `0x8da0`, `0x8dcc`, `0x8de0` | gun_step：300同拍发96和97，320/340只发97，360回跳300；使用使魔当前位置到公转圆心的角。 |

<a id="31-354"></a>
## TH31/354 「幻胧月睨」

- 修复Sub38生成实体的次数：50先减25，随后25次、间隔2拍；当前一只眼状实体改为25只，每只各活60拍。
- 补回137(13)设置、137(-1)清除的52拍背景染色；颜色按原MixColors的乘/128及饱和截断，仅用于背景ANM。
- 补回Sub38的SoundIdx42与25；核对两组标记弹在140/230/260的隐身、淡入、恢复运动顺序和使魔枪WAIT180后的换图加速。

阶段接口：登记符卡、开卡清场、5940帧超时及死亡跳转接入现有Boss Rush阶段接口；未重放原作剧情和计分。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata5sp.ecl:Sub40` | `0x4fb4`, `0x4fc4`, `0x4fd0`, `0x4fe4`, `0x4ff4`, `0x5008`, `0x501c`, `0x5028`, `0x5038`, `0x504c`, `0x5068`, `0x515c`, `0x516c`, `0x517c`, `0x5190`, `0x51a4`, `0x51b8`, `0x51cc`, `0x51e0`, `0x520c`, `0x5218`, `0x522c`, `0x5240`, `0x5254`, `0x5268`, `0x527c`, `0x5290`, `0x52a4`, `0x52b8`, `0x52cc`, `0x52e0`, `0x52f4`, `0x5308`, `0x531c`, `0x5330`, `0x5344`, `0x5358`, `0x536c`, `0x5380`, `0x5394`, `0x53a8`, `0x53bc`, `0x53d0`, `0x53e4`, `0x5410`, `0x5424`, `0x5450`, `0x5464`, `0x5490`, `0x54a4`, `0x54d0`, `0x54e8`, `0x54fc`, `0x5510`, `0x5524`, `0x5548`, `0x555c`, `0x556c`, `0x5584` | CARD[208]/boss_frame：180拍周期；110大环144发；140/230/260按A/B掩码推进；270/280两组44×2，280先随机移动再同拍放24使魔。 |
| `ecldata5sp.ecl:Sub38` | `0x4ec8`, `0x4edc`, `0x4eec`, `0x4f00`, `0x4f28`, `0x4f40`, `0x4f54`, `0x4f64` | boss_frame眼状实体窗口为140..188每2拍；演出调度保留137(13)回调至192清除，SoundIdx42/25；25次循环不暂停父context。 |
| `ecldata5sp.ecl:Sub39` | `0x4f7c`, `0x4f8c`, `0x4f9c` | lw208_eye及原ANM绑定：80(3)、58(5)采用原stg5enm备用ANM；每只自身60拍终止，互不共用寿命。 |
| `ecldata5sp.ecl:Sub41` | `0x55a4`, `0x55cc`, `0x55f4`, `0x561c`, `0x5648` | lw208_gun_bullet：每10拍一发初速0；180拍WAIT清位后下一拍换type7/色1并开始60拍向量加速0.033333335。 |
| `ecldata5sp.ecl:Sub42` | `0x5668`, `0x5678`, `0x5688`, `0x5698`, `0x56ac`, `0x56bc`, `0x56d0`, `0x56e4` | lw208_familiar：继承父角度，出生即挂枪并发首弹，以4速直线运动，按原ANM可视框出界回收。 |

<a id="31-355"></a>
## TH31/355 「天网蛛网捕蝶之法」

- 逐行核对八代蛛网递归、14拍节点分裂、末代终止、li5首轮/后续轮分支及104拍补弹。
- 恢复被空render完全隐藏的Sub79出生消散火花：原etama脚本16、小型消散色表第2项、半速位移、12拍寿命。
- 补回每轮110帧SoundIdx16；核对240拍周期、共用随机枝角、256激光槽和1536弹槽及光柱110/50/20状态机。
- 修复Sub79@0xbfb8的104拍补弹数量：count1=2，恢复相反方向两颗；补回子机的出生SoundIdx7。

阶段接口：登记符卡、开卡清场、5940帧超时及死亡跳转接入现有Boss Rush阶段接口；未重放原作剧情和计分。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata6sp.ecl:Sub76` | `0xb978`, `0xb988`, `0xb998`, `0xb9a8`, `0xb9b4`, `0xb9c8`, `0xb9d8`, `0xb9ec`, `0xba00`, `0xba0c`, `0xba1c`, `0xba30`, `0xba4c`, `0xbb40`, `0xbb50`, `0xbb60`, `0xbb74`, `0xbb84`, `0xbb98`, `0xbbac`, `0xbbc4`, `0xbbd8`, `0xbc00`, `0xbc18`, `0xbc28` | CARD[209]/boss_frame：110读自机角/抽一次枝角生成根，290先边界随机运动再li5++，350跳110；240拍周期。 |
| `ecldata6sp.ecl:Sub79` | `0xbd2c`, `0xbd3c`, `0xbd4c`, `0xbd5c`, `0xbd70`, `0xbdb0`, `0xbdc4`, `0xbdd8`, `0xbdec`, `0xbe00`, `0xbe14`, `0xbe28`, `0xbe3c`, `0xbe58`, `0xbe80`, `0xbe94`, `0xbec0`, `0xbed8`, `0xbee8`, `0xbf04`, `0xbf10`, `0xbf28`, `0xbf50`, `0xbf68`, `0xbf90`, `0xbfac`, `0xbfb8`, `0xbfe4` | lw209_web/lw209_laser/spark：0拍静止光柱；0..12每2拍出生即消散火花；14拍深度+1，小于8才分裂两支；li5<1同拍终止，其余等到实际104拍补两发慢弹后终止。 |

<a id="31-356"></a>
## TH31/356 「蓬莱之树海」

- 修复Boss环弹和树弹混用type17：Sub81为type3，Sub82才是type17；判定和ANM随原类型一起选择。
- 修复第七棵树的Hermite轨迹：Sub79@0x100cc将lf2单独重置0，其p2切向量不能继续前六棵的递推。
- 补回弹墙/自机狙转折的SoundIdx25及树枪SoundIdx7，并让反射/转向后的贴图读取本拍逻辑角。
- 逐行核对Sub33同步CALL耗32拍；七棵树和Boss上移的真实开始帧162；环弹14拍组的角度跨轮累计。

阶段接口：沿用Boss Rush的符卡登记、HP换算与阶段清场接口；树使魔的生命/形态/120拍交互切换由原作交互表控制。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata7sp.ecl:Sub79` | `0xf79c`, `0xf7ac`, `0xf7bc`, `0xf7cc`, `0xf7d8`, `0xf7ec`, `0xf7fc`, `0xf810`, `0xf824`, `0xf830`, `0xf840`, `0xf854`, `0xf870`, `0xf964`, `0xf974`, `0xf984`, `0xf990`, `0xf9a0`, `0xf9b4`, `0xf9d0`, `0xf9e4`, `0xf9f8`, `0xfa0c`, `0xfa20`, `0xfa34`, `0xfa48`, `0xfa5c`, `0xfa70`, `0xfa84`, `0xfa98`, `0xfaac`, `0xfad0`, `0xfae4`, `0xfaf4`, `0xfb08`, `0xfb18`, `0xfb2c`, `0xfb40`, `0xfb54`, `0xfb68`, `0xfb7c`, `0xfb90`, `0xfba4`, `0xfbb8`, `0xfbdc`, `0xfbf0`, `0xfc00`, `0xfc14`, `0xfc24`, `0xfc38`, `0xfc4c`, `0xfc60`, `0xfc74`, `0xfc88`, `0xfc9c`, `0xfcb0`, `0xfcc4`, `0xfce8`, `0xfcfc`, `0xfd0c`, `0xfd20`, `0xfd30`, `0xfd44`, `0xfd58`, `0xfd6c`, `0xfd80`, `0xfd94`, `0xfda8`, `0xfdbc`, `0xfdd0`, `0xfdf4`, `0xfe08`, `0xfe18`, `0xfe2c`, `0xfe3c`, `0xfe50`, `0xfe64`, `0xfe78`, `0xfe8c`, `0xfea0`, `0xfeb4`, `0xfec8`, `0xfedc`, `0xff00`, `0xff14`, `0xff24`, `0xff38`, `0xff48`, `0xff5c`, `0xff70`, `0xff84`, `0xff98`, `0xffac`, `0xffc0`, `0xffd4`, `0xffe8`, `0x1000c`, `0x10020`, `0x10030`, `0x10044`, `0x10054`, `0x10068`, `0x1007c`, `0x10090`, `0x100a4`, `0x100b8`, `0x100cc`, `0x100e0`, `0x100f4`, `0x10108`, `0x1012c`, `0x10140` | CARD[210]/boss_frame：110同步Sub33耗32拍，故130组实际162拍；7棵树同拍出生，life4000/2100/1000/1000/1000/2100/4000；第七棵psi=0；之后290回跳指向自身，不重复放树。 |
| `ecldata7sp.ecl:Sub33` | `0x4f98`, `0x4fac`, `0x4fc4`, `0x4fdc` | 32次、每拍粒子17×4；同步CALL冻结父时钟，演出调度输出原ANM与收拢轨迹。 |
| `ecldata7sp.ecl:Sub80` | `0x10160`, `0x10170`, `0x10184`, `0x10194`, `0x101a4`, `0x101b4`, `0x101c4`, `0x101d8`, `0x101ec`, `0x10200`, `0x10214`, `0x10228`, `0x1023c`, `0x10250`, `0x1027c`, `0x10290`, `0x102bc`, `0x102d0`, `0x102e4`, `0x102f8`, `0x10308`, `0x10318`, `0x10328`, `0x10350`, `0x10378`, `0x103a0`, `0x103b4` | lw210_tree：120拍x/y独立Hermite、按x后y各抽p3正负400；120归零速度/清无敌，150挂枪；82(0)关闭近身禁射；弹墙→自机狙→type2换图保留槽序。 |
| `ecldata7sp.ecl:Sub81` | `0x103d4`, `0x103e0`, `0x103f4`, `0x10408`, `0x1041c`, `0x10430`, `0x1045c`, `0x10470`, `0x10484`, `0x10494`, `0x104a4`, `0x104b4`, `0x104e0`, `0x104f4`, `0x10508`, `0x10518`, `0x10528`, `0x10538`, `0x10564`, `0x10578`, `0x1058c`, `0x1059c`, `0x105ac`, `0x105bc`, `0x105e8`, `0x105fc`, `0x10610`, `0x10620`, `0x10630`, `0x10640`, `0x1066c`, `0x10680`, `0x10694`, `0x106a4`, `0x106b4`, `0x106c4`, `0x106f0`, `0x10704`, `0x10718`, `0x10728`, `0x10738`, `0x10748`, `0x10774`, `0x10788`, `0x1079c`, `0x107ac`, `0x107bc`, `0x107cc`, `0x107f8`, `0x1080c`, `0x10820`, `0x10830`, `0x10840`, `0x10850`, `0x1087c`, `0x10890`, `0x108a4`, `0x108b4`, `0x108c4`, `0x108d4`, `0x10900`, `0x10914`, `0x10928`, `0x10938`, `0x10948`, `0x10958`, `0x10984`, `0x10998`, `0x109ac`, `0x109bc`, `0x109cc`, `0x109dc`, `0x10a08`, `0x10a1c`, `0x10a30`, `0x10a40`, `0x10a50`, `0x10a60`, `0x10a8c`, `0x10aa0`, `0x10ab4`, `0x10ac4`, `0x10ad4`, `0x10ae4`, `0x10b10`, `0x10b24`, `0x10b38`, `0x10b48`, `0x10b58`, `0x10b68` | ring_shot：子context600拍起；type3、16发、2.5速、每15拍一圈，7色重复两遍；lf0/lf1逐发±0.012271847且跨14发组保留。 |
| `ecldata7sp.ecl:Sub82` | `0x10b88`, `0x10b94`, `0x10ba8`, `0x10bbc`, `0x10bd0`, `0x10bfc`, `0x10c10`, `0x10c20` | tree_gun：每8拍一对反向type17、2.1速，初角π、每发加π/40；JUMP落在发弹而非初始化；原slot0反弹、slot1自机狙、slot2换type2。 |

<a id="31-357"></a>
## TH31/357 「不死鸟再诞」

- 修复Sub112按字面t51提前销毁：50处150次回跳，真实寿命200拍；恢复50..199逐拍的150次RANDRAD与32→64枪口半径变化。该实体NO_SPRITE且没有发弹指令，不擅自增加子弹。
- 修复190..230五次凤凰CALL每次重瞄：原作只有190读取自机角，后四次保持同一快照；其余CALL按源点分别瞄准。
- 恢复170及850回跳同拍的未使用RANDF2消费，保留700处5拍暂停，实际周期685拍；修正被截断的凤凰轮廓角与0.14166666567325592加速度。
- 修复type19/7/10统一按半宽8回收：现在按原ANM半宽16/16/32，type5仍为8，并保留type19/7出生30拍、type10出生24拍、type5出生10拍及回收延迟120。

阶段接口：沿用符卡登记、5940拍超时、HP换算与阶段出口；Sub112保持原NO_SPRITE，不生成原ECL没有的子弹。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata8sp.ecl:Sub110` | `0xf8d8`, `0xf8e8`, `0xf8f8`, `0xf908`, `0xf914`, `0xf928`, `0xf938`, `0xf94c`, `0xf960`, `0xf96c`, `0xf97c`, `0xf990`, `0xf9ac`, `0xfaa0`, `0xfab0`, `0xfac0`, `0xfad0`, `0xfae0`, `0xfaf4`, `0xfb08`, `0xfb1c`, `0xfb30`, `0xfb44`, `0xfb58`, `0xfb70`, `0xfb7c`, `0xfb90`, `0xfba4`, `0xfbb8`, `0xfbc8`, `0xfbd8`, `0xfbe8`, `0xfbf8`, `0xfc08`, `0xfc24`, `0xfc38`, `0xfc50`, `0xfc5c`, `0xfc70`, `0xfc80`, `0xfc94`, `0xfca4`, `0xfcb8`, `0xfcc8`, `0xfcdc`, `0xfcec`, `0xfd00`, `0xfd10`, `0xfd2c`, `0xfd40`, `0xfd58`, `0xfd64`, `0xfd7c`, `0xfd8c`, `0xfda4`, `0xfdb4`, `0xfdcc`, `0xfddc`, `0xfdf0`, `0xfe00`, `0xfe18`, `0xfe28`, `0xfe40`, `0xfe50`, `0xfe68`, `0xfe78`, `0xfe8c`, `0xfea0`, `0xfeb8`, `0xfec8`, `0xfee0`, `0xfef0`, `0xff08`, `0xff18`, `0xff2c`, `0xff3c`, `0xff54`, `0xff64`, `0xff7c`, `0xff8c`, `0xffa4`, `0xffb4`, `0xffc8`, `0xffdc`, `0xfff4`, `0x10004`, `0x1001c`, `0x1002c`, `0x10044`, `0x10054`, `0x10068`, `0x10078`, `0x10090`, `0x100a0`, `0x100b8`, `0x100c8`, `0x100e0`, `0x100f0`, `0x1010c`, `0x10120`, `0x1013c`, `0x1014c`, `0x1015c` | CARD[211]/boss_frame：110交互标志/附属ANM，170的3速仅初始化一次；190锁角后五CALL，340..380各重瞄，500..700三段扇面；230/380/700逐次+0.2至≥4，700等5拍，850回170跳过一次性初始化，实际685周期。 |
| `ecldata8sp.ecl:Sub111` | `0x1017c`, `0x101a4`, `0x101cc`, `0x101f4`, `0x10210`, `0x10224`, `0x10250`, `0x10268`, `0x10284`, `0x10298`, `0x102c4`, `0x102dc`, `0x102f8`, `0x1030c`, `0x10338`, `0x10350`, `0x1036c`, `0x10380`, `0x103ac`, `0x103c8`, `0x103dc`, `0x10408`, `0x10420`, `0x1043c`, `0x10450`, `0x1047c`, `0x10494`, `0x104b0`, `0x104c4`, `0x104f0`, `0x10508`, `0x10524`, `0x10538`, `0x10564`, `0x1057c`, `0x10598`, `0x105ac`, `0x105d8`, `0x105f0`, `0x1060c`, `0x10620`, `0x1064c`, `0x10664`, `0x10680`, `0x10694`, `0x106c0`, `0x106d8`, `0x106f4`, `0x10708`, `0x10734`, `0x1074c`, `0x10768`, `0x1077c`, `0x107a8`, `0x107c0`, `0x107dc`, `0x107f0`, `0x1081c`, `0x10834`, `0x10850`, `0x10864`, `0x10890`, `0x108a8`, `0x108c4`, `0x108d8`, `0x10904`, `0x1091c`, `0x10938`, `0x1094c`, `0x10978`, `0x10990`, `0x109ac`, `0x109c0`, `0x109ec`, `0x10a04`, `0x10a20`, `0x10a34`, `0x10a60`, `0x10a78`, `0x10a94`, `0x10aa8`, `0x10ad4`, `0x10aec`, `0x10b08`, `0x10b1c`, `0x10b48`, `0x10b60`, `0x10b7c`, `0x10b90`, `0x10bbc`, `0x10bd4`, `0x10bf0`, `0x10c04`, `0x10c30`, `0x10c48`, `0x10c64`, `0x10c78`, `0x10ca4`, `0x10cb8`, `0x10ce4`, `0x10d10`, `0x10d3c`, `0x10d68` | call_111：原序生成Sub112，再按24个原float32极坐标偏移生成type19、中心type7/10；两条type5×23环各抽一次基准角；records0回收120、1向量加速120，枪口偏移最终归0。 |
| `ecldata8sp.ecl:Sub112` | `0x10d80`, `0x10d90`, `0x10da4`, `0x10db4`, `0x10ddc`, `0x10e04`, `0x10e2c`, `0x10e40`, `0x10e54`, `0x10e68`, `0x10e84`, `0x10e98`, `0x10eb4`, `0x10ec8`, `0x10ee0` | lw211_phoenix：出生速度0.3，20拍加速度0.025；50开始150次逐拍随机枪口，半径32至64保持；200拍终止；原脚本设置的变换记录没有实际发弹，不把隐藏体臆造成额外枪。 |

<a id="31-358"></a>
## TH31/358 「远古的欺骗者」

- 修复500处wait后续指令被提前执行：原作等待xi2拍后才更新参数、重取自机角、重建激光/环线程；等待期间旧ei0=1必须保留。
- 修复把Sub45取消激光误判为死代码：0x6194回跳到0x6164比较，而非0x6150清零；500拍四条激光正常取消并消散60拍，不无限累积。
- 修复根程序分支层级：0x5ae8只跳过xi3--，wait每轮都会执行；xi3下限16，xi2从60每轮减3至27，lf6独立增加到至少6。
- 停留弹显式保留出生MOVE_ANGLE以按原方向绘制，补回激光提示16、子机发弹7；旋转步长、环弹步长及加速度恢复原float32常量。

阶段接口：沿用阶段登记、HP/超时与阶段结束清场；四条光柱的取消、消散和下一轮重建由本卡ECL时间轴执行。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata5sp.ecl:Sub43` | `0x56fc`, `0x570c`, `0x5718`, `0x572c`, `0x573c`, `0x5750`, `0x5764`, `0x5770`, `0x5780`, `0x5794`, `0x57b0`, `0x58a4`, `0x58b4`, `0x58c4`, `0x58e0`, `0x58f4`, `0x5908`, `0x591c`, `0x5930`, `0x5944`, `0x5958`, `0x596c`, `0x5980`, `0x5994`, `0x59a0`, `0x59b8`, `0x59cc`, `0x59dc`, `0x59f4`, `0x5a08`, `0x5a18`, `0x5a24`, `0x5a3c`, `0x5a50`, `0x5a60`, `0x5a78`, `0x5a8c`, `0x5a9c`, `0x5aa8`, `0x5abc`, `0x5ad0`, `0x5ae8`, `0x5b04`, `0x5b18`, `0x5b28`, `0x5b44`, `0x5b58`, `0x5b74`, `0x5b88` | CARD[212]/boss_frame：110开4光/双向环，170/200/230/260各CALL四使魔；500先ei0=1、停环、移动，再wait；xi3仅减至16，wait后xi2减至27、lf6增至≥6，随后跳110。新增after_wait续执行状态，首个wait拍在设置当帧消耗。 |
| `ecldata5sp.ecl:Sub44` | `0x5ba8`, `0x5bc0`, `0x5bd4`, `0x5be8`, `0x5c04`, `0x5c1c`, `0x5c2c`, `0x5c48`, `0x5c60`, `0x5c70`, `0x5c84`, `0x5ca8`, `0x5cbc`, `0x5cd4`, `0x5ce4`, `0x5d00`, `0x5d14`, `0x5d38`, `0x5d50`, `0x5d64`, `0x5d78`, `0x5d94`, `0x5dac`, `0x5dbc`, `0x5dd8`, `0x5df0`, `0x5e00`, `0x5e14`, `0x5e38`, `0x5e4c`, `0x5e64`, `0x5e74`, `0x5e90`, `0x5ea4`, `0x5ec8` | call_44：两组各独立抽半径[64,80)，组内两只共享；父角快照cf0控制圆心偏移，初始轨道角/角速度正负按四个生成点逐一对应；CALL不污染父局部寄存器。 |
| `ecldata5sp.ecl:Sub45` | `0x5ee0`, `0x5ef8`, `0x5f10`, `0x5f20`, `0x5f3c`, `0x5f50`, `0x5f60`, `0x5fa0`, `0x5fb0`, `0x5ff0`, `0x600c`, `0x6020`, `0x6030`, `0x6070`, `0x6080`, `0x60c0`, `0x60d4`, `0x60e8`, `0x60fc`, `0x6110`, `0x6124`, `0x6138`, `0x6150`, `0x6164`, `0x6180`, `0x6194`, `0x61a8`, `0x61b8`, `0x61c8`, `0x61d8`, `0x61e8` | spawn_lasers/s45_step：0拍4根512×32光，60起20次±π/40旋转；0x6150仅清零一次，等待比较0x6164，0x6194回跳比较；500读到ei0=1，121×4进入60拍消散，RETURN结束子context。 |
| `ecldata5sp.ecl:Sub46` | `0x6200`, `0x6214`, `0x623c`, `0x6264`, `0x628c`, `0x62b8`, `0x62d4`, `0x62e8` | lw212_familiar/lw212_bullet：2拍起每2拍留一颗；xi2只初始化200一次，逐发减2至2；每发快照WAIT→type2/色2→60拍加速0.06666667014360428；停留弹保持出生运动方向。 |
| `ecldata5sp.ecl:Sub47` | `0x6308`, `0x6314`, `0x632c`, `0x6358`, `0x6368`, `0x6394`, `0x63a4` | s47_step/volley_s47：子context60起两枪15×5交替，每半枪之间等待当轮xi3；初速lf6、末速0.7×lf6，各半枪重新读自机角，父500停止此context。 |
| `ecldata5sp.ecl:Sub48` | `0x63c4`, `0x63d4`, `0x63e4`, `0x63f4`, `0x6408`, `0x6418`, `0x6428`, `0x6438`, `0x6450`, `0x6468`, `0x6490`, `0x64a4`, `0x64b4`, `0x64c0`, `0x64d4`, `0x64e8`, `0x64fc`, `0x6510`, `0x6538`, `0x6544`, `0x6558`, `0x656c`, `0x6580`, `0x6594`, `0x65bc`, `0x65c8`, `0x65dc`, `0x65f0`, `0x6604`, `0x6618`, `0x6640`, `0x664c`, `0x6660`, `0x6674`, `0x6688`, `0x669c`, `0x66c4` | lw212_familiar：出生ORBIT预计算不提交位置；1拍交互，60/120/180圆心各外移2×offset并重设轨道；主程序先于枪，240终止前不再发弹或位移。 |

<a id="31-359"></a>
## TH31/359 「无何有净化」

- 逐行核对8只独立隐藏源实体：110拍一次创建，正负轨道角速度、径向3、120拍重设380半径与初始角。
- 核对每2拍留弹、每16拍重置角偏移并将WAIT寿命50逐步加6至150；WAIT清位后下一拍消散，原对象继续占槽且半速退出。
- 核对Boss从510拍起180拍周期，570锁角后1/2/3/4发扇形，690同拍开始下一次随机移动；补回570的SoundIdx15及独立源实体的发弹SoundIdx7。

阶段接口：独立隐藏源实体的轨道持续6000拍，超过本卡5940拍窗口；阶段结束按现有接口统一删除，不擅自在攻击内缩短寿命。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata8sp.ecl:Sub113` | `0x10ef8`, `0x10f08`, `0x10f18`, `0x10f28`, `0x10f34`, `0x10f48`, `0x10f58`, `0x10f6c`, `0x10f80`, `0x10f8c`, `0x10f9c`, `0x10fb0`, `0x10fcc`, `0x110c0`, `0x110d0`, `0x110e0`, `0x110f4`, `0x11108`, `0x1111c`, `0x11130`, `0x11158`, `0x1116c`, `0x11180`, `0x111a8`, `0x111bc`, `0x111cc`, `0x111e0`, `0x111f4`, `0x1121c`, `0x11230`, `0x11244`, `0x1126c`, `0x11280`, `0x11290`, `0x112a4`, `0x112b8`, `0x112e0`, `0x112f4`, `0x11308`, `0x11330`, `0x11344`, `0x11354`, `0x11368`, `0x1137c`, `0x113a4`, `0x113b8`, `0x113cc`, `0x113f4`, `0x11400`, `0x11418`, `0x1142c`, `0x1143c`, `0x11468`, `0x11494`, `0x114c0`, `0x114ec` | CARD[213]：110只抽一次初始角，四组各2只，角依次+π/2、颜色6/4；510移60拍，570锁角并播15，590/610/630共享角，690跳510。 |
| `ecldata8sp.ecl:Sub114` | `0x1150c`, `0x1151c`, `0x11530`, `0x11544`, `0x1156c`, `0x11580`, `0x11594`, `0x115a8`, `0x115bc`, `0x115d0`, `0x115f8`, `0x11620`, `0x11648`, `0x11660`, `0x11674`, `0x11684`, `0x116b0`, `0x116c4`, `0x116dc`, `0x116f0`, `0x1170c`, `0x11720` | lw213_minion：出生ORBIT和首枪先计算不提交位移；独立源实体NoSprite，初始li6=50；0..14每2拍一枪，16拍尾块增加寿命并同拍开始下一组；上限150，op111依次CULL/WAIT/DESPAWN。 |
| `ecldata8sp.ecl:Sub115` | `0x11740`, `0x11768` | 主context先发弹、再更新轨道；子context120拍重装ORBIT，半径380、径向0并恢复出生初始角，之后继续公转。 |

<a id="31-360"></a>
## TH31/360 「梦想天生」

- 补回17槽停弹程序中第6/13槽PLAY_SOUND25，并保留减速/停住/换色/等待/朝自机恢复的原槽序；自机狙完成时按原默认音效25提示。
- 停住后换向立即将本拍逻辑角交给原ANM，避免速度0时仍沿旧方向绘制；出界按移动后位置静默回收，释放原弹槽。
- 补回Sub43@0x840c的flags5残影：历史90拍、从89倒序每6拍采样、当前主VM淡出，判定长度0；不复制附属VM，不增加残影碰撞。
- 补回90拍SoundIdx13和使魔枪SoundIdx7；公转径向/角速、摆动增量、弹速与角步恢复原始float32值。

阶段接口：本卡耐久2220拍，阶段登记与退出交给Boss Rush；使魔的6099拍终止超出本卡窗口，按原逻辑保留。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata4asp.ecl:Sub43` | `0x81c0`, `0x81cc`, `0x81dc`, `0x81ec`, `0x81f8`, `0x820c`, `0x821c`, `0x8230`, `0x8244`, `0x8250`, `0x8260`, `0x8274`, `0x8290`, `0x8384`, `0x8394`, `0x83a4`, `0x83b4`, `0x83d0`, `0x83e0`, `0x83f0`, `0x8400`, `0x840c`, `0x8428`, `0x843c`, `0x8450`, `0x8464`, `0x8488`, `0x849c`, `0x84b0`, `0x84c4`, `0x84d8`, `0x84ec`, `0x8500`, `0x8514`, `0x8538`, `0x854c`, `0x8560`, `0x8574`, `0x8598`, `0x85ac`, `0x85c0`, `0x85d4`, `0x85f8`, `0x860c`, `0x8620`, `0x8634`, `0x8658`, `0x866c`, `0x8680`, `0x8694`, `0x86b8`, `0x86cc`, `0x86e0`, `0x86f4`, `0x8718`, `0x872c`, `0x8740`, `0x8754`, `0x8778`, `0x8790` | CARD[214]：90拍开交互并CALL Sub16耗32拍，120换ANM实际152，170组实际202；只创建一次8只使魔并启用90/0/6残影；230回跳只重复moveRand120拍，每60拍重设。 |
| `ecldata4asp.ecl:Sub16` | `0x3fa8`, `0x3fbc`, `0x3fd4`, `0x3fec` | 演出调度：粒子17每拍4只、共32拍；同步CALL冻结父时钟，原入场/使魔出生时点包含此阻塞。 |
| `ecldata4asp.ecl:Sub44` | `0x87b0`, `0x87c0`, `0x87d4`, `0x87e4`, `0x87f4`, `0x8804`, `0x8820`, `0x8838`, `0x884c`, `0x8860` | lw214_familiar：8个原ANM61/65/64/68/63/67/62/62与life500/300交替；100拍径向0.64、99拍停止外扩并挂摆动/枪；轨道只在所有context结束后更新一次。 |
| `ecldata4asp.ecl:Sub45` | `0x8878`, `0x888c`, `0x88a0`, `0x88b4`, `0x88cc`, `0x88e0`, `0x88f0` | 99拍起每拍写圆运动角速=cos(phi)×-0.07853981852531433，phi逐拍+0.013089969754219055；Lua转为y向上正号，保留相位更新顺序。 |
| `ecldata4asp.ecl:Sub46` | `0x8910`, `0x8924`, `0x8934`, `0x895c`, `0x8984`, `0x89ac`, `0x89d4`, `0x89fc`, `0x8a24`, `0x8a4c`, `0x8a74`, `0x8a9c`, `0x8ac4`, `0x8aec`, `0x8b14`, `0x8b3c`, `0x8b64`, `0x8b8c`, `0x8bb4`, `0x8bdc`, `0x8bf0`, `0x8c1c`, `0x8c2c`, `0x8c48`, `0x8c5c` | sub46_step：8只首次各等20/40/...160拍，之后初始200、逐次减10至60，回跳跳过SET200；每枪type11/色15、2×16、9至3.8速；17槽在运行时按allow/active约束逐项推进，全部音效/换图/转向均保留。 |

<a id="31-361"></a>
## TH31/361 「炽热之星」

- 补回Sub60出生时flags5/历史15/判定0/stride1残影；主VM按原alpha淡出，瞬移两侧时仍保留旧位置轨迹。
- 补回每次150/340蓄力的原SoundIdx16/19及ExIns10：30拍脉冲重复5次、峰值alpha64；震动幅度4、120拍升/190拍持平/60拍降，按原顺序每拍抽x/y离散轴。ScreenEffect推进先于敌机。
- 移除把Ex25敌机回调当可消弹激光的代理：直接在Sub63主context内判定60..179拍，先读跟随前头位置减295偏移，再运行Sub62跟随；擦弹按原bossTimer=t-1每12拍判断，实体终止后不残留判定。借激光绘制的同类TH07敌机矩形也不再被Bullet/LaserManager消除或掉道具。
- 大星弹按type14/15原ANM尺寸、移动后位置静默回收，保留停弹/WAIT180/向量加速200的槽序；逻辑角交给ANM，关键常量使用原始float32。

阶段接口：耐久2160拍、阶段结束和HP接口沿用Boss Rush；屏幕偏移桥接到worldoffset，未声称D3D逐像素或原RNG位流等价。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata4bsp.ecl:Sub60` | `0xa450`, `0xa46c`, `0xa478`, `0xa488`, `0xa498`, `0xa4a4`, `0xa4b8`, `0xa4c8`, `0xa4dc`, `0xa4f0`, `0xa4fc`, `0xa50c`, `0xa520`, `0xa53c`, `0xa630`, `0xa640`, `0xa650`, `0xa660`, `0xa67c`, `0xa688`, `0xa69c`, `0xa6b0`, `0xa6c0`, `0xa6d0`, `0xa6e4`, `0xa704`, `0xa718`, `0xa72c`, `0xa740`, `0xa754`, `0xa77c`, `0xa7a4`, `0xa7cc`, `0xa7f4`, `0xa808`, `0xa81c`, `0xa838`, `0xa850`, `0xa864`, `0xa878`, `0xa888`, `0xa898`, `0xa8ac`, `0xa8cc`, `0xa8e0`, `0xa8f4`, `0xa908`, `0xa91c`, `0xa944`, `0xa96c`, `0xa994`, `0xa9bc`, `0xa9d0`, `0xa9e4`, `0xaa00`, `0xaa18`, `0xaa2c`, `0xaa40`, `0xaa54`, `0xaa68` | CARD[215]：出生15拍残影；90再上移60至-64；150/340锁自机X并放4火花，210/400下冲60；330/520分别瞬移左右半场并增加速度，520列数+3，530回150跳过一次性初始化；380拍周期。 |
| `ecldata4bsp.ecl:Sub61` | `0xaa88`, `0xaa9c`, `0xaab0`, `0xaad8`, `0xab00`, `0xab28`, `0xab54`, `0xab68`, `0xab94`, `0xaba8`, `0xabc0` | attach_gun/gun_frame：子context60起，type14/色1及type15/色3交替隔8拍；18次计数，但下一次蓄力会重建context；列数/加速度取挂上时快照；REL60停到0、WAIT180、VEC200。 |
| `ecldata4bsp.ecl:Sub62` | `0xabd8`, `0xabe4`, `0xabfc`, `0xac14`, `0xac2c`, `0xac44` | 火花60拍起逐拍读取Boss0位置，加继承lf0/lf1偏移；不误用自机位置，跟随Boss本拍世界位置。 |
| `ecldata4bsp.ecl:Sub63` | `0xac64`, `0xac74`, `0xac84`, `0xac98`, `0xaca8`, `0xacb8`, `0xacc8`, `0xacd8`, `0xacf0`, `0xad08`, `0xad24`, `0xad38`, `0xad4c`, `0xad60` | lw215_head脚本22：60拍插值至295偏移；60安装Ex25、180清除、240终止；直接在主context判定590×288/590×224，使用跟随前坐标及bossTimer=t-1，随后子context刷新跟随。没有可消弹的激光代理。 |
| `ecldata4bsp.ecl:Sub64` | `0xad78`, `0xad88`, `0xad98`, `0xadac`, `0xadbc`, `0xadcc`, `0xaddc`, `0xadec`, `0xae04`, `0xae1c`, `0xae38`, `0xae4c` | lw215_head脚本23：同偏移与60拍跟随，但没有Ex25回调；370拍终止，不额外创建判定。 |
| `ecldata4bsp.ecl:Sub65` | `0xae64`, `0xae74`, `0xae84`, `0xae98`, `0xaea8`, `0xaeb8`, `0xaec8`, `0xaed8`, `0xaef0`, `0xaf08`, `0xaf24`, `0xaf38` | lw215_head脚本24：同运动，独立ANM第三层，370拍终止，不重复宽判定。 |
| `ecldata4bsp.ecl:Sub66` | `0xaf50`, `0xaf60`, `0xaf70`, `0xaf84`, `0xaf94`, `0xafa4`, `0xafb4`, `0xafc4`, `0xafdc`, `0xaff4`, `0xb010`, `0xb024` | lw215_head脚本25：同运动，独立ANM第四层，370拍终止；保留各层原ANM170拍动画结束。 |

<a id="34-4441"></a>
## TH34/4441 騒符「ライブポルターガイスト -Lunatic-」

- 修复伴奏生成次数：Sub122/123第一组CALL掩码0x03，L只执行第二次CALL；每侧每拍六只，原来错误执行两次并首拍4+6。
- 修复音符被Bomb/无敌自机普通消弹提前删除；Sub126是EnemyManager管理的isProjectile敌机，应活到自身120拍发弹后终止。
- 补入旧调用闭包遗漏的两个姐妹Sub122/123及Sub125；核对主奏512拍周期、伴奏280拍周期，120拍发弹、60拍开始曲线运动及ANM149..156。

阶段接口：三姐妹共享受击/阶段结束仍接现有Boss Rush接口；音符是敌机弹，阶段结束由spell_live清理；普通BulletManager消弹不提前终止其ECL。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `ecldata4.ecl:Sub121` | `0x12638`, `0x12648`, `0x12658`, `0x12668`, `0x12678`, `0x12688`, `0x12698`, `0x126a8`, `0x126e8`, `0x12728`, `0x12768`, `0x127a8`, `0x127c8`, `0x127e4`, `0x127f8`, `0x1280c`, `0x12820`, `0x12834`, `0x12848`, `0x1285c`, `0x12870`, `0x12880`, `0x1288c`, `0x128a8`, `0x128b8`, `0x128cc`, `0x128e8`, `0x128f8`, `0x1290c`, `0x1291c`, `0x12930`, `0x12944`, `0x12958`, `0x1296c`, `0x12980`, `0x12994`, `0x129a8`, `0x129bc`, `0x129d0`, `0x129e4`, `0x129f8`, `0x12a0c`, `0x12a20`, `0x12a34`, `0x12a48`, `0x12a5c`, `0x12a70`, `0x12a80`, `0x12a94`, `0x12aa8`, `0x12abc`, `0x12ad0`, `0x12ae4`, `0x12af8`, `0x12b0c`, `0x12b20`, `0x12b34`, `0x12b48`, `0x12b5c`, `0x12b70`, `0x12b84`, `0x12b98`, `0x12bac`, `0x12bc0`, `0x12bd4`, `0x12be4`, `0x12bf8`, `0x12c0c`, `0x12c20`, `0x12c34`, `0x12c48`, `0x12c5c`, `0x12c70`, `0x12c84`, `0x12c98`, `0x12cac`, `0x12cc0`, `0x12cd4`, `0x12ce8`, `0x12cfc`, `0x12d10`, `0x12d24`, `0x12d38`, `0x12d48`, `0x12d5c`, `0x12d70`, `0x12d84`, `0x12d98`, `0x12dac`, `0x12dc0`, `0x12dd4`, `0x12de8`, `0x12dfc`, `0x12e10`, `0x12e24`, `0x12e38`, `0x12e4c`, `0x12e60`, `0x12e74`, `0x12e88`, `0x12e9c`, `0x12eac`, `0x12ebc` | TH34_poltergeist：120设置边界、广播姐妹中断；Sub2阻塞16拍，故166换ANM、206主奏；四组36只、间隔3拍，40拍等待后512拍循环。 |
| `ecldata4.ecl:Sub122` | `0x12edc`, `0x12eec`, `0x12efc`, `0x12f0c`, `0x12f1c`, `0x12f2c`, `0x12f4c`, `0x12f68`, `0x12f7c`, `0x12f90`, `0x12fa4`, `0x12fb4`, `0x12fc8`, `0x12fdc`, `0x12ff0`, `0x13004`, `0x13020`, `0x13030`, `0x13044`, `0x13060`, `0x13070`, `0x13084`, `0x13094`, `0x130a8`, `0x130bc`, `0x130d0`, `0x130e4`, `0x130f4`, `0x13108`, `0x1311c`, `0x1312c`, `0x13140`, `0x13154`, `0x13164`, `0x13178`, `0x1318c`, `0x1319c`, `0x131b0`, `0x131c4`, `0x131d8`, `0x131ec`, `0x131fc`, `0x13210`, `0x13224`, `0x13234`, `0x13248`, `0x1325c`, `0x1326c`, `0x13280`, `0x13294`, `0x132a4` | 左伴奏：120+Sub2共16拍，338实际354；L只执行mask0x0c的一次Sub125，每次6只；0/60/120/180四拍、周期280。 |
| `ecldata4.ecl:Sub123` | `0x132c4`, `0x132d4`, `0x132e4`, `0x132f4`, `0x13304`, `0x13314`, `0x13334`, `0x13350`, `0x13364`, `0x13378`, `0x1338c`, `0x1339c`, `0x133b0`, `0x133c4`, `0x133d8`, `0x133ec`, `0x13408`, `0x13418`, `0x1342c`, `0x13448`, `0x13458`, `0x1346c`, `0x1347c`, `0x13490`, `0x134a4`, `0x134b8`, `0x134cc`, `0x134dc`, `0x134f0`, `0x13504`, `0x13514`, `0x13528`, `0x1353c`, `0x1354c`, `0x13560`, `0x13574`, `0x13584`, `0x13598`, `0x135ac`, `0x135c0`, `0x135d4`, `0x135e4`, `0x135f8`, `0x1360c`, `0x1361c`, `0x13630`, `0x13644`, `0x13654`, `0x13668`, `0x1367c`, `0x1368c` | 右伴奏：与左侧独立context；L一次六只，不共享一个被错误递增的4→6计数。 |
| `ecldata4.ecl:Sub124` | `0x136ac`, `0x136c4`, `0x136dc`, `0x136f0`, `0x13708`, `0x1371c`, `0x13734`, `0x1374c`, `0x1375c`, `0x13784`, `0x1379c`, `0x137b4` | 主奏每组36只；随机初始角±0.049087387、共享扫角/36；每只随机曲率±幅度/2；3拍一次，108拍后返回恢复父时钟。 |
| `ecldata4.ecl:Sub125` | `0x137cc`, `0x137e0`, `0x137f4`, `0x13808`, `0x1381c`, `0x13830`, `0x13844`, `0x13858`, `0x1386c`, `0x13880`, `0x13894`, `0x138a8`, `0x138bc`, `0x138d0`, `0x138e4`, `0x138f8`, `0x1390c`, `0x13924`, `0x13938`, `0x13950`, `0x13968`, `0x13978`, `0x13990`, `0x139a0`, `0x139c8`, `0x139e0` | 伴奏一次只抽一个初始角，六只出生在半径64，角步π/4；variant4、speed0.2、i3=1；没有混入E/N的第二次CALL。 |
| `ecldata4.ecl:Sub126` | `0x139f8`, `0x13a08`, `0x13a20`, `0x13a30`, `0x13a40`, `0x13a50`, `0x13a60`, `0x13a70`, `0x13a80`, `0x13a9c`, `0x13aac`, `0x13ac0`, `0x13ad4`, `0x13af0`, `0x13b00`, `0x13b14`, `0x13b28`, `0x13b44`, `0x13b54`, `0x13b68`, `0x13b7c`, `0x13b98`, `0x13ba8`, `0x13bbc`, `0x13bd0`, `0x13bec`, `0x13bfc`, `0x13c10`, `0x13c24`, `0x13c40`, `0x13c50`, `0x13c64`, `0x13c78`, `0x13c94`, `0x13ca4`, `0x13cb8`, `0x13ccc`, `0x13ce8`, `0x13cf8`, `0x13d0c`, `0x13d28`, `0x13d38`, `0x13d44`, `0x13d5c`, `0x13d74`, `0x13d90`, `0x13dbc`, `0x13de8`, `0x13dfc`, `0x13e28`, `0x13e54`, `0x13e80` | TH34_poltergeist_ghost：主ANM149..156、12×12接触框、isProjectile/允许出界；60拍开始角速度，120拍按i3选择主奏自机狙/伴奏9发绝对环并立即结束，普通消弹不代替终止。 |
| `ecldata4.ecl:Sub2` | `0x4dc`, `0x4f0`, `0x500`, `0x518`, `0x530` | TH34_poltergeist_charge：count4、每4拍粒子17，主32/伴16；调用各耗16拍，并将兄弟context共享量更新为原值。 |

<a id="35-3652"></a>
## TH35/3652 stage07 非符一

- 核对Boss1的20帧自机角快照，80拍首次异步发弹，110随机移动，140回跳80；两次枪相隔30拍。
- 修复阶段交接丢失I0..I3/F0..F3及枪槽；F0供下一张開宴读取。

阶段接口：原作宿主是同一敌机，寄存器、两路运动、枪槽和近身禁射距离跨卡保留；开卡Ecl_EtBreak/全敌清理与结尾回调映射到现有阶段清场接口。独立练习没有上一段时另记初始化映射。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `stage07.ecl:Boss1` | `0xd18`, `0xd2c`, `0xd3c`, `0xd68`, `0xd84`, `0xd98`, `0xdac`, `0xdc0`, `0xdd4`, `0xde8`, `0xdf8`, `0xe10`, `0xe24`, `0xe44`, `0xe60`, `0xe70`, `0xe84`, `0xe9c` | s7.Boss1：20读取-9989→F0；80创建Boss1_at，110移动30拍，140回80；200拍保护与HP交给阶段接口。 |
| `stage07.ecl:Boss1_at` | `0xebc`, `0xed0`, `0xee4`, `0xefc`, `0xf18`, `0xf34`, `0xf50`, `0xf6c`, `0xf9c`, `0xfb0`, `0xfc4`, `0xfd8`, `0xff0`, `0x100c`, `0x1028`, `0x1044`, `0x1060`, `0x1090`, `0x10a4` | s7.Boss1_at：槽0 aim4、28×4、type6/色6、3.5→1.5；30拍后反向angleStep再打一枪，返回。 |

<a id="35-3612"></a>
## TH35/3612 開宴「二拝二拍一拝」

- 修复初始锁定角缺失：原Boss1@0xdc0/0xdd4保存F0，三个激光线程读取F0；原实现换卡清零且错误注释称“不读取”。
- 相邻阶段继承真实F0；独立练习以入卡自机角补齐缺失历史，不新增本卡等待。90拍保留原I0=0写入。
- 核对480拍主周期和三个激光线程：20轮、两次发射间4拍、40段扫射；不能为412臆加瞄准。原构造函数0x41c8c0直接复制角度，flags低位改ANM混合。

阶段接口：原作宿主是同一敌机，寄存器、两路运动、枪槽和近身禁射距离跨卡保留；开卡Ecl_EtBreak/全敌清理与结尾回调映射到现有阶段清场接口。独立练习没有上一段时另记初始化映射。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `stage07.ecl:BossCard1` | `0x3c70`, `0x3c84`, `0x3c98`, `0x3cc0`, `0x3cf8`, `0x3d08`, `0x3d28`, `0x3d3c`, `0x3d50`, `0x3d68`, `0x3d9c`, `0x3dac`, `0x3dc4`, `0x3ddc`, `0x3df4`, `0x3e08`, `0x3e1c`, `0x3e30`, `0x3e48`, `0x3e74`, `0x3ea0`, `0x3ec4`, `0x3ee8`, `0x3f0c`, `0x3f1c`, `0x3f38`, `0x3f48`, `0x3f74`, `0x3fa0`, `0x3fc4`, `0x3fe8`, `0x400c`, `0x401c`, `0x4038`, `0x4048`, `0x405c`, `0x4074` | s7.BossCard1：90/120开单臂、150/180同步散弹、210双臂、270移动；330起对调；570回90；寄存器交接由t10_boss_start/end处理。 |
| `stage07.ecl:BossCard1_at` | `0x5248`, `0x525c`, `0x5270`, `0x5288`, `0x52a4`, `0x52c0`, `0x52dc`, `0x52f8`, `0x5328`, `0x5358`, `0x5388`, `0x539c`, `0x53b4`, `0x53c8`, `0x53dc`, `0x53f8`, `0x5410`, `0x5424`, `0x5438`, `0x5448`, `0x545c`, `0x5470`, `0x5484`, `0x5494`, `0x54a8`, `0x54d8`, `0x54f4`, `0x5508`, `0x551c`, `0x552c`, `0x5540`, `0x5550`, `0x556c`, `0x5588`, `0x559c`, `0x55b0`, `0x55c8`, `0x55dc`, `0x55f0`, `0x560c`, `0x5624`, `0x5638`, `0x564c`, `0x565c`, `0x5670`, `0x5684`, `0x5698`, `0x56a8`, `0x56bc`, `0x56ec`, `0x5708`, `0x571c`, `0x5730`, `0x5740`, `0x5754`, `0x5764`, `0x5780`, `0x579c`, `0x57b0`, `0x57c4`, `0x57dc`, `0x57f0`, `0x5804`, `0x5820`, `0x5838`, `0x584c`, `0x5860`, `0x5870`, `0x5884`, `0x5898`, `0x58ac`, `0x58bc`, `0x58d0`, `0x5900`, `0x591c`, `0x5930`, `0x5944`, `0x5954`, `0x5968`, `0x5978`, `0x5994`, `0x59b0`, `0x59c4`, `0x59d8`, `0x59f0`, `0x5a04`, `0x5a18`, `0x5a34`, `0x5a4c`, `0x5a60`, `0x5a74`, `0x5a84`, `0x5a98`, `0x5aac`, `0x5ac0`, `0x5ad0`, `0x5ae4`, `0x5b14`, `0x5b30`, `0x5b44`, `0x5b58`, `0x5b68`, `0x5b7c`, `0x5b8c`, `0x5ba8`, `0x5bc4`, `0x5bd8`, `0x5bec`, `0x5c04`, `0x5c34`, `0x5c50` | s7.BossCard1_at：4/8/16/32组，同拍随机偏移与角度；槽序2/8192/向下加速40/再加速60；重置槽2和出弹偏移后返回。 |
| `stage07.ecl:BossCard1_at2` | `0x5c70`, `0x5c84`, `0x5c98`, `0x5cac`, `0x5cc0`, `0x5cd4`, `0x5ce4`, `0x5cf8`, `0x5d0c`, `0x5d20`, `0x5d34`, `0x5d4c`, `0x5d7c`, `0x5d90`, `0x5da4`, `0x5db4`, `0x5dc8`, `0x5ddc`, `0x5df0`, `0x5e20`, `0x5e34`, `0x5e48`, `0x5e58`, `0x5e6c`, `0x5e80`, `0x5e94`, `0x5ea8`, `0x5ec0` | s7.BossCard1_at2：基准F0-π/2，0.03927增量，彩色428/灰色412交替，各隔4拍，20次。 |
| `stage07.ecl:BossCard1_at2b` | `0x5ee0`, `0x5ef4`, `0x5f08`, `0x5f1c`, `0x5f30`, `0x5f44`, `0x5f54`, `0x5f68`, `0x5f7c`, `0x5f90`, `0x5fa4`, `0x5fbc`, `0x5fec`, `0x6000`, `0x6014`, `0x6024`, `0x6038`, `0x604c`, `0x6060`, `0x6090`, `0x60a4`, `0x60b8`, `0x60c8`, `0x60dc`, `0x60f0`, `0x6104`, `0x6118`, `0x6130` | s7.BossCard1_at2b：基准F0+π/2，角步负号，其余与at2相同。 |
| `stage07.ecl:BossCard1_at3` | `0x6150`, `0x6164`, `0x6178`, `0x618c`, `0x61a0`, `0x61b4`, `0x61c4`, `0x61d8`, `0x61ec`, `0x6200`, `0x6210`, `0x6224`, `0x6238`, `0x624c`, `0x6260`, `0x6278`, `0x62a8`, `0x62d8`, `0x62ec`, `0x6300`, `0x6310`, `0x6324`, `0x6338`, `0x634c`, `0x635c`, `0x6370`, `0x6384`, `0x6398`, `0x63ac`, `0x63dc`, `0x640c`, `0x6420`, `0x6434`, `0x6444`, `0x6458`, `0x646c`, `0x6480`, `0x6490`, `0x64a4`, `0x64b8`, `0x64cc`, `0x64e0`, `0x64f4`, `0x650c` | s7.BossCard1_at3：F0±π/2双臂，0.034907对向步进，彩色双根/灰色双根每4拍交替，20次。 |
| `default.ecl:Ecl_EtBreak` | `0xb0`, `0xc4`, `0xd8`, `0xec`, `0x100`, `0x118`, `0x12c`, `0x140`, `0x154`, `0x164`, `0x178`, `0x18c`, `0x1a0`, `0x1b0`, `0x1c8` | 阶段清场接口：原helper由16半径逐拍+10至640，入口攻击前的过渡清场由Boss Rush统一清理；本卡首枪90拍后，不把helper候选当作本卡发弹。 |

<a id="35-3633"></a>
## TH35/3633 厄符「厄神様のバイオリズム」

- 修复-9989自机角读取错误：Enemy::ReadFloatOperand使用worldMotion.position，原实现却只用offset；绕圈使魔在120拍的转向因此偏离原作。共享读取函数统一修复。
- 补回两只使魔180拍的etProtectRange(32)，近身不足32像素时整枪不发；同类Boss2CardAtEnemy的60拍设置也已修复。
- 逐行确认首批60/150，240的wait将clock拨回200、再等40后回60；周期220，未按旧注释误改为180。射手每5拍两枪，WAIT120后0.016向量加速100拍。

阶段接口：原作宿主是同一敌机，寄存器、两路运动、枪槽和近身禁射距离跨卡保留；开卡Ecl_EtBreak/全敌清理与结尾回调映射到现有阶段清场接口。独立练习没有上一段时另记初始化映射。

| 原作子程序 | 原始指令地址（含掩码排除行） | 对应实现与人工核对结论 |
| --- | --- | --- |
| `stage02.ecl:MBossCard1` | `0x8a84`, `0x8a98`, `0x8aac`, `0x8abc`, `0x8adc`, `0x8af0`, `0x8b04`, `0x8b38`, `0x8b74`, `0x8bb4`, `0x8bd0`, `0x8be0`, `0x8bf8`, `0x8c10`, `0x8c48`, `0x8c80`, `0x8c9c`, `0x8cb0`, `0x8cc4`, `0x8cdc` | s2.MBossCard1：60开第一只、150第二只、240随机移动并回拨40，再等到240跳60。 |
| `stage02.ecl:MBossAtEnemy` | `0x8150`, `0x8164`, `0x8178`, `0x818c`, `0x81b4`, `0x81e8`, `0x8208`, `0x8220`, `0x8234`, `0x8248`, `0x825c`, `0x826c`, `0x827c`, `0x829c`, `0x82b0`, `0x82c0` | s2.MBossAtEnemy：base圆运动角步0.052359879、径向0.53333336；120取使魔世界位置自机角+π/6，60拍极坐标插值到5；180禁射距离32，240终止。 |
| `stage02.ecl:MBossAtEnemy2` | `0x82e0`, `0x82f4`, `0x8308`, `0x831c`, `0x8344`, `0x8378`, `0x8398`, `0x83b0`, `0x83c4`, `0x83d8`, `0x83ec`, `0x83fc`, `0x840c`, `0x842c`, `0x8440`, `0x8450` | s2.MBossAtEnemy2：初始π、角步负号，自机角-π/6，其余同上一只。 |
| `stage02.ecl:MBossAtEnemyAt` | `0x8470`, `0x8484`, `0x8498`, `0x84ac`, `0x84c0`, `0x84d0`, `0x84e0`, `0x84f4`, `0x8508`, `0x8520`, `0x853c`, `0x8558`, `0x8574`, `0x8590`, `0x85c0`, `0x85f0`, `0x860c`, `0x8628`, `0x8640`, `0x8658`, `0x8668`, `0x8684`, `0x86a0`, `0x86b4`, `0x86c8`, `0x86d8`, `0x86f0`, `0x8720`, `0x8750`, `0x8768`, `0x877c`, `0x8790`, `0x87a0`, `0x87b8`, `0x87d4`, `0x87f0`, `0x8820`, `0x8850`, `0x8868`, `0x887c`, `0x8890`, `0x88a0`, `0x88b8`, `0x88d4`, `0x88f0`, `0x8920`, `0x8950`, `0x8964`, `0x8978`, `0x898c`, `0x89a0`, `0x89b0`, `0x89c4`, `0x89d8`, `0x89ec`, `0x8a00`, `0x8a10`, `0x8a24`, `0x8a38`, `0x8a4c`, `0x8a64` | s2.MBossAtEnemyAt：槽0/1两个3发绝对环，角分别arg0及arg0+arg4/2.5，每5拍各加arg4；L分支设置初速0.01和加速度0.016，-999取当前弹角。初始化随机角会被首枪的etAngle覆盖，没有误删原随机消费。 |
| `stage02.ecl:MBossDummyShadow` | `0x9884`, `0x9898`, `0x98b0`, `0x98c8`, `0x98d8`, `0x98ec`, `0x9904` | s2.MBossDummyShadow/独立ANM：t1循环播放2号资源槽脚本0，异步线程与发弹线程共用敌机位置。 |
| `default.ecl:Ecl_EtBreak` | `0xb0`, `0xc4`, `0xd8`, `0xec`, `0x100`, `0x118`, `0x12c`, `0x140`, `0x154`, `0x164`, `0x178`, `0x18c`, `0x1a0`, `0x1b0`, `0x1c8` | 原开场清屏helper映射阶段清场，保留攻击计时；不会把default候选误认作一个射手。 |
