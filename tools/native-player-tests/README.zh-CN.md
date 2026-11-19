# 六作原作自机校准

顺序模式、关卡练习和符卡练习共享原生自机。录像初态保存机体和版本号，早期录像根据原有的项目机体播放。符卡练习沿用项目的无敌规则。

- 春雪篇 4 台：原始 `EquipShoot`、`Equipment`、`SelfBarrage`、`SingleBomb` 与 `SpecialSystem`；原子机轨迹、射击节拍、火力、Bomb、樱花开花／破裂与收集范围。
- 雪莲华 6 台：原 Unity 射击组件、94 个可达预制件、120 Hz 更新；高速／低速、三次形态切换、蓄力、动态倍率、结界释放与回流。第二个魔理沙机体使用独立的 `Center_yinqinai`，不再倒置第一机体的武器。
- 永夜篇 8 台：原 A/B 装备、普通／决死 Bomb、灯笼／支援自机／暴走状态机、能量和收集范围；本体用原始 `Character.DrawSprite` 及分部动画参数绘制。石化、定身、强制移动、衰老状态接入原作方法，保持灯笼暂停／恢复与禁射。
- 夏夜祭 4 台：原 `Shoot`、`SubPlaneCtrl`、子机滞后、诱导转向、射击计数与图集中心点；五种 Bomb 形态、恋恋护盾、绿结界优先级与红附魔伤害。
- 祈华梦 3 组：执行原自机类的射击、切换和六种高速／低速 Bomb；恢复禁射、锁速、冷却与幽幽子护盾破裂。
- 栖霞园 3 组：执行用户提供的完整原作中的自机类、装备系统和 `PowerRank`；原 Hyper、自动发动、暂停保险、决死、收集范围与六种武器形态。

六作分别使用原移动边界、相反方向键优先级、斜移系数和收集范围。原作 Bomb 自行处理伤害、消弹、保护和库存，避免重复叠加宿主的全屏伤害。原作没有被修改，导出后的脚本、数据和贴图均包含在游戏中。

C# 逻辑由 `csharp_logic.py` 按语法树转换；遇到不支持的语法会停止。兼容层保留零基数组、值类型复制、float32 字段、整数除法和参数数目重载。春雪篇灵梦／魔理沙／早苗的 2332 次发弹已与未修改 C# 实际运行的结果逐字段对照，详见 `oracle/README.zh-CN.md`。这份对照只证明列出的发弹字段；六作其余系统由下面的真实引擎专项覆盖。

## 六作原图与死亡流程

本轮覆盖春雪篇、雪莲华、永夜篇、夏夜祭、祈华梦、栖霞园；不修改 TH31–TH35 和 Like Dreamer。

`export_source_visuals.py` 保留原始像素、Sprite pivot、PPU、分部动画、道具与激光切片，输出 `THlib/native_player_visual_data.lua`。`visual_sources.json` 记录输入素材 SHA-256；游戏运行不依赖原工程目录。原图更换后，自机、自机弹与掉落物的判定独立恢复，避免零半径图集覆盖判定。

| 作品 | 贴图、缩放与旋转 | 死亡与消弹 |
| --- | --- | --- |
| 春雪篇 | 原 15 列行走图、四帧转向、主炮透明度、鱼雷切片、大小道具 | 原 e14 演出；30 帧扣命、31 帧回场、95 帧恢复控制；原扩散范围，保留 Invincible 弹 |
| 雪莲华 | Unity 原 Sprite/AnimationClip；音符、炎弹、雪花动画；原敌机、主炮及激光贴图 | 120 Hz 死亡计时；死亡波延迟 100 tick；保留无敌弹，直线激光截短、曲线激光按段裁切；201 tick 复活位置 |
| 永夜篇 | 原 CharacterSet 分部动画、独立帧间隔、跟随延迟、旋转与偏移；原道具光晕和激光 | 原 e79–e82 演出；60 帧扣命、61 帧回场、125 帧恢复控制；保留 Invincible/indestructible 弹，敌机死亡后已发出的弹继续运行 |
| 夏夜祭 | 原行走图、低速特效、道具旋转；激光使用原图集颜色与 UV | 原 Emitter 粒子、20 帧决死、30 帧 BulletRemover；保留 UnRemoveable；绿结界使用 10 帧、半径 500 的小消弹器 |
| 祈华梦 | 动画渲染统一乘原 globalimagescale=0.5；原低速指针与道具动画 | 原 psi 粒子与延迟扩散圈；仅删除普通弹组，保留无敌弹和激光；40 帧后回场 |
| 栖霞园 | 原 12 帧待机、4+8 帧转向、自机弹、命中特效及激光；原 enemy/enemy2 样式表 | 原 psi 粒子与扩散圈；仅删除普通弹组，保留无敌弹和激光；原复活曲线与敌机死亡特效 |

跨引擎仍有表现差异：Unity 粒子／材质、夏夜祭 3D 装饰特效和部分界面演出仍由当前引擎表达；没有宣称整作的着色器、随机序列和分数体系逐位等价。Windows Sub 未执行本轮原生回归。

专项回归使用隔离存档，检查原图主炮、自机和道具判定、范围内普通弹删除、无敌弹和范围外子弹保留、扣命与复活：

```sh
python3 tools/native-player-tests/native_source_parity.py --out /tmp/source-parity
```

## macOS 真实引擎回归

```sh
python3 macos/build.py --update-assets
BOSSRUSH_MAC_TEST_MACHINE=youmu python3 tools/th37-tests/native.py --sequence thmhj2_lunatic --frames 350 --out /tmp/player-th37
BOSSRUSH_MAC_TEST_MACHINE=marisa_b python3 tools/th38-tests/native.py --sequence thasl_lunatic --frames 350 --out /tmp/player-th38
BOSSRUSH_MAC_TEST_MACHINE=mokou_b python3 tools/th38-tests/native.py --sequence thmhj3_lunatic --frames 350 --out /tmp/player-th39
BOSSRUSH_MAC_TEST_MACHINE=yukari python3 tools/th38-tests/native.py --card 38002 --repeat --frames 350 --out /tmp/player-practice
```

测试使用独立的临时存档。顺序模式用实际射击命中原生敌机，再通过接触碰撞触发决死、扣结界和扣命。练习检查机体资源在重开后仍可用，并对比同种子的场内状态。


## 敌机击破与3D道中（26.11.18-source-scenes）

延续上文六作范围。春雪篇接入六色e7–e12击破；永夜篇导出34套敌机/使魔击破配置，保留原拖曳速度和独立演出层；雪莲华导出九个击破prefab、27个Sprite与九段AnimationClip，按敌机配置选择八套实际使用的演出，空占位prefab保持无演出。夏夜祭使用原EndEnemy及十片40帧三维旋转碎片。祈华梦、栖霞园继续执行原始击破类。

春雪篇使用完整XNA模型，恢复阶段4的1920/3120/11100帧场景转换、模型预备/激活、UV、循环拼接、相机插值和Boss/BGM/模型到达等待。零值相机轴按原代码保留旧值；投影沿用原640×480到战斗区的裁切关系。夏夜祭恢复七个Environment场景、原阶梯/祭坛网格、雾效、云层、相机移动和黑幕转场。雪莲华停止使用LOD，按原Mesh、材质和纹理分别缓存批量顶点。

原生网格提交接口只在加载时解析Lua顶点，逐帧变换在C++完成；深度只读与透明材质的深度写入分别设置。原始数据与贴图均在仓库内，运行不依赖本地原工程。导出入口是`tools/th37-tests/export_scene.py`、`tools/th38-tests/export_enemy_death.py`、`tools/native-player-tests/export_enemy_death.py`与`tools/th40-tests/export_scene.py`，各目录的sources.json保留输入SHA-256。春雪篇导出器的`--unpacked-models`需提供已解压的XNB Model目录，保留模型顶点而不重采样。

这些修改恢复原数据和主要可见行为；不表示跨引擎逐像素等价。Unity的GrabPass特殊材质、粒子模拟以及原作float32/随机序列仍由兼容层表达，Windows Sub未执行本轮原生渲染回归。

```sh
luajit tools/native-player-tests/check_scene_state.lua
luajit tools/check_native_background_tracks.lua
luajit tools/th40-tests/sequence.lua
python3 tools/native-player-tests/native_scenes.py --out /tmp/source-scenes
python3 tools/native-player-tests/native_enemy_death.py --out /tmp/source-enemies
```

原生测试使用隔离存档，保存截图和日志；击破测试实际调用敌机Kill或原作击破类，检查演出被创建、没有碰撞及到期回收。背景测试验证真实Metal网格提交，LuaJIT测试覆盖八条春雪路线、七条雪莲华路线、永夜篇道中及62套符卡/8套Last Word背景，另检查七个夏夜祭场景的转换和对象回收。

## 自机与敌机判定修正（26.11.19-player-collision）

祈华梦三组机体改为执行原始 `reimu.lua`、`marisa.lua`、`mokou.lua`，资源名称加前缀隔离。灵梦/紫恢复八帧行走、六帧切换、原子机阵型和跟随、诱导锁定、主炮/副武器及命中特效；原作构造器决定缩放、中心点和自机弹判定。`export_theis_players.py --source <原作 code/data>` 同步脚本和 PNG，`native_players/sources.json` 记录原始输入 SHA-256。桥接层替换资源装载和宿主自机基类；后续校准进一步接入了原主动 Bomb、保护与锁速。

`THlib/native_actor_collision.lua` 分别在体术和自机弹命中阶段设置判定，恢复后保留精灵旋转。判定不再依赖贴图自带的零尺寸。LuaSTG-x 的 `rect=false` 是圆形，非等比椭圆显式选择 `ellipse`；Windows Sub 继续使用原布尔接口。

春雪篇和永夜篇原作将自机弹半径同时加到受弹矩形的横纵边界；碰撞阶段临时使用轴对齐弹框，保留矩形角落的命中，结算后恢复自机弹的绘制旋转和形状。耐久卡同时关闭体术与受弹，Boss 不吸收自机弹。

| 作品 | 原始依据与修正 |
| --- | --- |
| 春雪篇 | `Enemy.JudgeBody` 使用自机中心与 `judgeSize/7` 矩形；受弹使用 `judgeSize/2` 矩形。Boss 受弹半框 35×50，体术使用各 Boss 的 judgeSize/2；耐久卡关闭体术。 |
| 永夜篇 | 按原场地 2/3 比例恢复敌机受弹矩形与体术椭圆；Boss 受弹半框为 35×50 再乘 2/3。副 Boss 恢复体术组。使魔出现 20 帧后受弹，60 帧后开放体术；耐久卡关闭 Boss 体术。 |
| 雪莲华 | 分别读取 `a48_4/pdbj` 与 `a48_5/sdbj`，不再共用受弹半径；Boss/副 Boss 分别读取 `a51_1` 和 `a51_2`。 |
| 夏夜祭 | 普通敌机默认 Region 从 3 改回 4，特殊类型保留各自原值，随每帧缩放更新。保留 `BaseObject.HitCheck` 的非等比缩放分支、目标半径加减方向与出生前九帧无判定。 |
| 祈华梦、栖霞园 | 保留原始构造器及脚本设置的判定尺寸、旋转；避免行走图切换清零。栖霞园 Boss 的受弹框和独立体术代理继续分开。 |

```sh
luajit tools/native-player-tests/check_actor_collision.lua
python3 tools/native-player-tests/native_actor_collision.py --out /tmp/actor-boundaries
python3 tools/native-player-tests/native_theis_player.py --out /tmp/theis-player-render
python3 tools/native-player-tests/native_source_parity.py --out /tmp/source-parity
python3 tools/native-player-tests/native_source_parity.py --levels 39 --machine marisa --out /tmp/theis-marisa
python3 tools/native-player-tests/native_source_parity.py --levels 39 --machine mokou --out /tmp/theis-mokou
```

边界专项通过真实引擎的 `CollisionCheck` 检查矩形四角、横纵边界、椭圆角落以及贴图覆写；自机专项实际计数灵梦/紫本体及子机绘制，并覆盖高速/低速切换。以上记录该版本的判定修正和验证范围；后续逻辑校准见下文。

## 自机逻辑回归（26.11.19-player-logic）

`native_logic.py` 在实际 macOS 引擎中运行，每例使用独立存档；通常 700 帧，栖霞园为 1200 帧。断言覆盖库存、无敌、禁射、冷却、切换、自动发动与状态恢复；特效武器另核对敌机／Boss 命中顺序、镜像缩放和永夜篇每帧共享伤害上限。可使用 `--machine` 逐机运行，高／低速 Bomb 使用 `--variant high`／`slow`；永夜篇的 `slow` 指决死 Bomb。

```sh
python3 tools/native-player-tests/check_csharp_source.py
luajit tools/native-player-tests/check_movement.lua
python3 tools/native-player-tests/native_logic.py --levels 35,36,37,38,39,41 --out /tmp/player-logic
python3 tools/native-player-tests/native_logic.py --levels 35 --variant system --out /tmp/sakura
python3 tools/native-player-tests/native_logic.py --levels 37 --variant system --out /tmp/lantern
python3 tools/native-player-tests/native_logic.py --levels 37 --variant status --out /tmp/negative-status
python3 tools/native-player-tests/native_logic.py --levels 35,37 --variant damage --out /tmp/effect-damage
python3 tools/native-player-tests/native_logic.py --levels 41 --variant passive --out /tmp/hyper-insurance
python3 tools/native-player-tests/native_source_parity.py --out /tmp/player-source
```

通过的案例清单及覆盖边界保存在 `verification-26.11.19-player-logic.json`。

本轮另修复了 LuaSTG-x 碰撞回调改变对象组／类时迭代器失效的崩溃；栖霞园灵梦的原始慢速弹击破回调会触发这条路径。碰撞组在回调前建立对象快照，保持原遍历顺序。

离线导出入口及输入如下；所有目录的 `sources.json` 记录原始输入 SHA-256。`parser-lib` 目录需安装 `tree-sitter`、`tree-sitter-c-sharp`，导出还需 Pillow、PyYAML、pycryptodome；游戏运行无需这些 Python 依赖。

```sh
python3 tools/native-player-tests/export_mhj_players.py --spring <春雪篇C#目录> --night <永夜篇C#目录> --night-content <永夜篇Content> --parser-lib <解析器目录>
python3 tools/th37-tests/export.py --source <春雪篇恢复工程根目录> --player-only
python3 tools/th39-tests/export.py --source <永夜篇恢复工程根目录> --content <永夜篇Content> --player-only
python3 tools/native-player-tests/export_unity_players.py --assets <雪莲华Assets> --parser-lib <解析器目录>
python3 tools/native-player-tests/export_summer_players.py --source <夏夜祭Shooting源码目录> --game <夏夜祭完整游戏目录> --parser-lib <解析器目录>
python3 tools/native-player-tests/export_bdb.py --scripts <栖霞园解包脚本目录> --assets <栖霞园解包素材目录>
```

## 练习菜单与启动修正（26.11.19-practice-menu）

雪莲华的原 C# 武器会对 `Bossmove` 组件继续调用 `GetComponent`，目标适配组件现在与普通组件一样提供查询／添加接口。新增实际 Boss 符卡练习回归，不再只用没有 Boss 的道中验证自机。

关卡练习按十二作的原作阶段展开为 106 个入口，包含各面、Extra／Phantasm、永夜抄 4A／4B 和 Final A／B；选关后执行原顺序模式的完整单面流程，结束即返回标题。练习标记和章节名在录像初态前写入；完整顺序模式会清除该标记。特殊独立攻击仍可从符卡练习选择。

关卡练习记住作品、章节、原作机体与 Like Dreamer 装备；符卡练习恢复页签、过滤条件、稳定卡号与机体。选择保存在当前存档中，退出并重新启动后仍可恢复。没有移动原符卡注册数组或历史录像索引。

首次启动直接进入标题，用户名与玩家标签统一为 `AAAA`。调试入口默认开启；`88888` 只由真正的标题菜单计数，隐藏子菜单不再重置输入。自动更新公告由 `GameFeatures.updateNotice=false` 暂停，版本迁移仍执行。

```sh
luajit tools/check_debug_mode.lua
luajit tools/check_practice_options.lua
luajit tools/check_sequence_mode.lua
luajit tools/check_original_practice.lua
python3 tools/native-player-tests/native_logic.py --levels 36 --card 38002 --machine reimu --out /tmp/unity-boss-practice
python3 tools/native-player-tests/native_logic.py --levels 36 --chapter 4 --out /tmp/unity-stage4-practice
python3 tools/native-player-tests/native_practice_options.py --out /tmp/practice-options
python3 tools/native-player-tests/native_practice_options.py --restore --out /tmp/practice-options
```

菜单原生回归使用隔离存档，实际从标题进入雪莲华四面和符卡练习、返回标题并重建菜单，核对恢复位置；还检查空存档的默认用户名、未弹出公告、默认调试入口，以及存在隐藏子菜单时返回标题后连续五次按 8。第二次进程检查上次选项已写入磁盘。
