# 新作接入 roguelike

`RogueTen` 从卡池版本10加入 TH37–TH43；版本11排除祈华梦 Lily White 的退场占位阶段。双 Boss 随机十战和接续模式继续使用原有来源，版本1–10的录像保持原集合和抽取顺序，升级保留版本10的筛选勾选。

## 卡池

`rogue_ports.lua` 从正式注册的来源元数据建立标签，再由 `rogue_pool.lua` 进行交集筛选。新增内容不写入旧 ECL 导出器生成的 `rogue_pool_sources.lua`。

- 春雪：原章节难度 4/5/6，分别为 Lunatic / Extra / Phantasm。
- 雪莲华：来源键 `L/` 和 `EXA/`；L 分支和 L Last Spell 仍属于 Lunatic。
- 永夜篇：原章节难度 4/5/6；独立难度 9 的 Last Word 不入新作池。
- 夏夜祭：当前后端导出的 L / EX，包括对应难度的 FSC。
- 祈华梦：`:Lunatic` 类和原七面 Extra；排除 Lily White 不可达的空占位阶段「非符6」。耐久判断读取内部原卡的时间，不能读取入口包装卡的 9999 秒。
- Like Dreamer：固定原始难度 3（Nightmare），归入 Lunatic，排除 Chaos。只加入单攻击和道中入口，排除重复的整场关底入口。原作没有命名符卡，攻击归为非符。
- 栖霞园：只收登记难度 4/5，排除 Easy / Normal / Hard。

新版默认开启新增作品、只选 Lunatic；Extra / Phantasm 共用开关。旧设置升级保留既有难度和类型勾选，并启用新增作品。Last Word 选项仍仅作用于此前已支持的原作内容。

## 血量

七作内部都有直接使用原始 HP 的阶段判断；祈华梦和 Like Dreamer 还会自行重设真实 Boss 血槽。随机模式不修改这些数值或共享卡表，而把本次输入伤害换算为：

`宿主伤害 × 原作伤害单位 ÷ 当前阶段累计 HP 倍率`

继承方法和部件转伤链只换算一次；每个对象保留出生阶段的倍率。来源中的零 HP、不可受击、耐久、部件同步和原始阶段阈值继续由原后端处理。旧作品继续使用原有的实际 HP 缩放。

伤害单位采用原作灵梦基准主炮相对于宿主双发主炮的 DPS 比例。宿主双发每四帧各 2 点，即 60 DPS；这不是所有机体、子机及移动命中率的完整 TTK 标定。

| 作品 | 主炮来源 | 换算 |
| --- | --- | ---: |
| 春雪 | `spring.lua` 的 `EquipShoot.NORMAL`，双发 13，每 3 帧 | 26/3 |
| 雪莲华 | 灵梦 prefab 两个 `jitifashezidan_zhuqiang`，周期 5、伤害 8，每秒 120 tick | 32/5 |
| 永夜篇 | `night.lua` 的 `NORMAL_A`，每帧四发 8；关闭灯笼的共享 Boss 每帧上限 22 | 敌机 32、Boss/部件 22 |
| 夏夜祭 | `source.lua` 的 `MyPlane_Reimu.Shoot`，每 3 帧双发 14 | 28/3 |
| 祈华梦 | 原 `fire_shot`，每 6 帧双发 5 | 5/3 |
| Like Dreamer | 原主炮双发 130，每 5 帧 | 后端已经乘 52，额外为 1 |
| 栖霞园 | 基准普通装备高速主炮 60 DPS | 1 |

## 连续切换与资源

`rogue_encounter.lua` 记录本场新建对象和关卡资源。切卡或退出先隔离旧对象的碰撞与回调，取消协程，再调用作品清理。仅设 `status='del'` 不足以阻止同帧碰撞访问已释放的音效。带 `_drop_owner` 的宿主自机弹和 Bomb 保持自身寿命，宿主自机、整局强化及关卡面板保留。

新对局开局遍历本局实际选中的卡池，预加载攻击脚本、贴图、立绘、音效和符卡背景。无限模式的一轮包含筛选后的全部候选，后续重新洗牌复用同一批资源。资源存入 global 池，与旧作一样在进程内复用；跨作品切卡和原作资源集的 Unload 不再卸载这批素材。单卡产生的其他 stage 素材仍使用最近一作、最多192 MiB的回退缓存，退出对局释放。移植资源表记录实际命中的池，避免同名 global 遮住 stage 副本时反复载入。

新对局记录 `__rogue_preload_version=1`。开局预加载由 `rogue_preload.lua` 分摊到显示帧，每帧约8ms预算，并显示卡池准备进度；后续切卡直接复用资源，不再逐卡启动加载协程。单次 GPU 上传不能进一步切分。准备期间仍绘制画面，但不读取录像键帧、不更新关卡、自机或弹幕时钟。没有标记的旧录像和旧续玩继续同步入口。原生平台在线程中解码纹理，主线程创建纹理；小图最多轮询1ms，避免每张小图强制等待一个完整显示帧，没有该接口的平台使用同步回退。

随机模式只创建首张卡对应的真实关卡背景，并让它整局继续运行。其主对象、捕获器、资源和后续生成的背景粒子独立于单卡回收范围，粒子仍按原寿命结束。后续卡只叠加各自的符卡背景、立绘和攻击演出，跳过关卡场景构造、网格准备、时间轴预演及道中背景替换。永夜和夏夜祭使用独立符卡覆盖层，祈华梦、Like Dreamer与栖霞园跳过后续关卡背景构造器。关卡/符卡练习与顺序模式继续使用原有场景入口。

`tools/verification-rogue-entry-optimized-2026-11-20.json`记录的是此前包含关卡背景预演的实现，不能用其数据代表当前只加载符卡背景的切卡耗时。本次按用户要求未运行测试，也未采集新的性能数字。

栖霞园独立初始化原始难度和激光更新器。祈华梦和 Like Dreamer 由各自入口先加载攻击资源、再播放音乐；回到旧作品继续原有随机曲袋。

Like Dreamer 在随机模式保留原作 Boss 血条，侧栏使用宿主的残机、强化、阶段号和 HP 倍率，避免显示另一套自机库存或遮住随机模式信息。练习和顺序入口继续使用原作侧栏。

随机模式底部统一绘制项目原生血条与 Boss 位置指示器，忽略各作关闭宿主血条/箭头的显示标记，耐久阶段也保留显示。祈华梦读取内部 Boss 列表，Like Dreamer 读取其 Boss HUD 的真实阶段快照，不使用练习入口包装对象的占位血量；位置箭头在最后绘制并限制在场地横向边界内。

## 运行回归

```sh
luajit tools/check_rogue_hp.lua
luajit tools/check_roguelike.lua
luajit tools/check_rogue_music.lua
luajit tools/check_dual_rogue.lua
python3 macos/build.py --update-assets
python3 tools/check_rogue_ports.py --out /tmp/bossrush-rogue-ports
```

原生专项通过真实 RogueTen 入口，检查新七作、L / EX / PH、道中、跨作交替、Like Dreamer 后期与最终攻击、真实 Boss/部件受伤倍率、返回标题重开和 `stage.Restart`。在隔离数据目录输出 JSON 与各作截图。超实时运行默认不向音频设备播放高频音效，但仍检查实际音效资源存在；没有覆盖全部卡片的完整击破，也不代表 Android 设备实测。

## 入场性能复测

```sh
STAGE_STRICT_NEW=1 luajit tools/check_rogue_preload.lua
STAGE_STRICT_NEW=1 luajit tools/check_rogue_resource_cache.lua
luajit tools/check_port_resource_reuse.lua
python3 macos/build.py --update-assets
python3 tools/profile_rogue_entry.py --out /tmp/bossrush-rogue-entry --frames 360
python3 tools/profile_rogue_entry.py --out /tmp/bossrush-rogue-moving --source TH39 --move-during-entry --frames 180
python3 tools/check_rogue_ports.py --out /tmp/bossrush-rogue-regression
```

采集包含全部准备显示帧及360个非准备帧，使用正常速度和垂直同步，屏蔽物理键鼠。峰值取同一显示帧的逻辑加绘制耗时，不把异步等待计为资源函数的CPU耗时。首次指本进程首次进入该作，没有清除系统文件缓存。`--move-during-entry` 专项在准备完成后、场景实际创建前强制改变自机位置，覆盖失效快照的重算路径。Lua 对照逐字段比较永夜593个背景粒子的完整可变状态与引用，资源专项检查同作复用、跨作别名隔离和退出回收。原生采样只证明这些入口窗口，不代替全部卡片的长时间帧率检查或 Android 实测。

运行中的移植符卡性能采集、批量弹体同步和行为对照见 `tools/runtime-tests/README.zh-CN.md`。这部分作用于共用后端，也覆盖其练习入口。
