# 春雪篇、雪莲华和永夜篇的原作自机

顺序模式、关卡练习和符卡练习共享原生自机。录像初态保存机体和版本号，早期录像根据原有的项目机体播放。符卡练习沿用项目的无敌规则。

- 春雪篇 4 台。根据 `Characters.cs`、`Character.cs`、`EquipShoot.cs`、`ItemManager.cs` 接入高速/低速、主炮、子机、决死、火力与残机。掉落取自关卡脚本，Boss 扣血取自 `BossCard.DeHp`。
- 雪莲华 6 台。根据 Unity 工程的角色预制件、`Centeryidong.cs`、`Damage_zhuqiang.cs`、`Jiemian_system.cs` 接入机体、切换、蓄力、结界、碎片和决死。每帧调度两次 120 Hz 的射击计数，弹体交由 60 Hz 的 LuaSTG 碰撞流程处理。
- 永夜篇 8 台。根据 `Data/10.xna`、`EquipShoot.cs`、`Character.cs` 接入 A/B 装备、决死、库存与妹红复活。Boss 按原脚本掉落，并按 `BossCard.DeHp` 的开场时间和斜率扣血。

春雪篇的部分子机轨迹、雪莲华的变身派生攻击、永夜篇的部分副武器使用近似表现。主动 Bomb 和结界释放仍有宿主实现；春雪篇樱花系统、雪莲华回流、永夜篇灯笼完整状态机与原作分数体系仍待移植。机体素材用 `export_art.py` 从两作 XNA Content 和雪莲华 Assets 离线切出。

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

这不表示整个移植已经逐像素等价：Unity 粒子／材质与夏夜祭 3D 特效仍由当前引擎表达；上文列出的完整玩法系统也不在本轮移植范围内。

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
