# 原作练习目录的占位阶段与难度筛选

## 祈华梦 Lily White「非符6」

原作`EISlib/stage/stage5/Lily_boss.lua`中，`stage5mid_boss:Lunatic.cards`的第六项由`boss.card.New("",2,10,23,1000,...)`创建，注释为“防止boss自爆的非”，`init`和`del`均为空。实际攻击只有第二项「常规攻击1」和第四项「迎春之舞」；第一、三项为入场演出，第五项为退场对话。

第五项在奖励、飞离与对话结束后调用`Del(self)`，原作`boss_class:del()`只清理对象，不调用`BossSystem:next()`；推进卡片的是`boss_class:kill()`。因此正常流程不会运行第六项。末尾占位项使有效符卡不被当作最后一张攻击，避免触发自爆。原作独立符卡练习类也仅包含一非一符及各自入场。

移植此前枚举所有`is_combat`项，将该占位项按数组下标显示成「非符6」。现保留其底层注册、卡号与索引，但标记为`practice_hidden`，从练习目录和版本11的新随机池排除；版本10及更早的随机录像沿用原候选集合。

原作只读来源：`/Users/happyelements/crack/THEIS/code/data/EISlib/stage/stage5/Lily_boss.lua`与同目录树的`THlib/enemy/boss.lua`，对应仓库的`mod/GAME/ports/theis/`副本。原始阶段链不作修改。

## 栖霞园练习难度

原作一至六面的`StageMain.lua`和`road.lua`按难度1～4分别创建Boss定义；七面使用难度5。移植`Card.createFullCardBoss`会为这些定义逐一注册练习项，随机池和关卡练习虽已有难度筛选，符卡练习仍从`TH43.units()`取得全部难度，因而混入Easy、Normal与Hard。

现让`TH43.units()`仅返回难度4、5的目录视图，保留底层注册数组和原始索引。关卡、符卡练习共用该目录；随机池继续读取原始难度标签，原作Boss定义不变。

本次按用户要求未运行测试或启动游戏。以上是源码调用关系与修改说明，不是运行验证报告。
