# 新作接入 roguelike

`RogueTen` 的卡池版本为 10，加入 TH37–TH43。双 Boss 随机十战和接续模式继续使用原有来源，版本 1–9 的录像也保持原集合和抽取顺序。

## 卡池

`rogue_ports.lua` 从正式注册的来源元数据建立标签，再由 `rogue_pool.lua` 进行交集筛选。新增内容不写入旧 ECL 导出器生成的 `rogue_pool_sources.lua`。

- 春雪：原章节难度 4/5/6，分别为 Lunatic / Extra / Phantasm。
- 雪莲华：来源键 `L/` 和 `EXA/`；L 分支和 L Last Spell 仍属于 Lunatic。
- 永夜篇：原章节难度 4/5/6；独立难度 9 的 Last Word 不入新作池。
- 夏夜祭：当前后端导出的 L / EX，包括对应难度的 FSC。
- 祈华梦：`:Lunatic` 类和原七面 Extra；耐久判断读取内部原卡的时间，不能读取入口包装卡的 9999 秒。
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

`rogue_encounter.lua` 记录本场新建对象和关卡资源。切卡或退出先隔离旧对象的碰撞与回调，取消协程，调用作品清理，再卸载本场新增的 stage 资源。仅设 `status='del'` 不足以阻止同帧碰撞访问已释放的音效。带 `_drop_owner` 的宿主自机弹和 Bomb 保持自身寿命。全局缓存继续由各后端按 `CheckRes` 复用，宿主自机、整局强化及关卡面板保留。

春雪显式建立当前卡场景，栖霞园独立初始化原始难度和激光更新器。祈华梦和 Like Dreamer 由各自入口先加载资源、再播放音乐；回到旧作品继续原有随机曲袋。

Like Dreamer 在随机模式保留原作 Boss 血条，侧栏使用宿主的残机、强化、阶段号和 HP 倍率，避免显示另一套自机库存或遮住随机模式信息。练习和顺序入口继续使用原作侧栏。

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
