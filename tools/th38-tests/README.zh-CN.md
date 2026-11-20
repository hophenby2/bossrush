# TH38：东方雪莲华原生对象接入初版

## 2026-11-20：三连城的固定激光

`EXA/boss2/12` 的城墙方块是 `a54_1=1` 的 `Laser_move_line`，其移动速度参数为 0。此前将它与移动激光合并，并按 `age × speed` 计算长度，导致原图和判定段均为零长。`fixed_laser.lua` 现在单独维护该子类型：原 prefab 的 0.1 初始横向缩放、每 tick 0.28 的头部推进与 0.07 的纵向伸展、预警倒计时、按原宽度的 1/100 增宽、判定开启和寿命结束后的收束。生成长度保留原作以四为单位取整和最后一步超出的行为，不依赖普通弹速度。

绘制使用现有原图及 Sprite 中心，体术沿用原作两端内缩 0.16 单位的线段距离和各样式半径；判定与五 tick 擦弹节拍在 120Hz 关卡更新中执行。自机消弹缩短实际纵轴并回退头部，之后按原逻辑补回长度；本型不套用普通弹的出屏回收。来源为 `Basic.cs`、`Basic_zi.cs`、`Laser_move_line.cs` 与 `Resources/xuelianhua/prefab/laser_line.prefab`。按用户要求，此次未运行验证。

实际level为36，卡号38001–38091。五作与幕华祭原有卡号、注册索引和顺序入口不移动；AEX依照项目约定移至STAGE_COUNT+1（37）。新雪莲华练习录像在快照前写入`__th38_version=1`，防止旧AEX的level36录像误放到新来源。

## 入口和覆盖

- 顺序模式：`雪莲华 · Lunatic`，通常六面，四面采用场景默认的Boss A路线。
- 顺序模式：`雪莲华 · Extra A`，完整道中与21段中Boss/Boss攻击。
- 符卡练习：91项，包含71段主流程攻击、12段道中、四面Boss B的7段攻击及六面Last Spell。
- 关卡练习：雪莲华，依次运行六面和Extra A。

四面B与Last Spell目前只列入练习，不在通常顺序流程中强行追加。尚未实现原作的自机配对分支、Last Spell解锁和追加条件。E/N/H数据没有混入Lunatic入口，也没有注册对应模式。重建工程的Extra B场景仍指向测试Boss且发行目录没有EXB弹幕树，因此没有将测试内容冒充原版Extra B。

## 来源和实现

来源根目录为`/Users/happyelements/asl`，原工程保持只读。发行数据以`THasl/xuelianhua/danmaku`为准，场景、预制体及C#行为以重建工程为参考，使用前分别核对。`mod/GAME/th38/sources.json`保存输入SHA-256；游戏运行不依赖这些绝对路径。

离线导出99组、1784份弹幕文本和8248条事件，生成Lua数值表。游戏内不读取外部txt，不运行Unity、C#或其反编译程序集。`bullet`、`enemy`、`laser`、`bent_laser`承载实体，Boss与练习使用项目的`boss.card`。事件条件、插值与绑定由Lua代码推进。

- 原作TimeManager步长为0.00833，按120tick/秒适配，每个60Hz LuaSTG帧推进两tick；关卡轴逐tick检查，保留奇数时刻。
- Unity坐标按中心(4.5,-4.8)、每单位48px投影；原100px/单位的弹图缩放为0.48。
- 条数、间隔、速度、HP、时限来自原值。保留原作1500发普通弹池上限，池满丢弃该发；敌机和激光不占此池。
- 普通绑定保留共享发射器，深绑定为每个宿主复制状态；宿主消失、切卡、重试和退出均回收对象与发射器。
- 两张最终攻击保留各自三个时间/血量阈值及清弹/重置时钟标记，没有拆成额外符卡。
- 弹图和自定义贴图使用全局资源池，练习重试不会引用已释放的关卡精灵。

## 当前适配差异

这是可运行、可检查的初版，尚不是原作逐帧等价复刻。

1. 自机、伤害、Bomb、资源与生命规则沿用本项目；HP未作DPS标定。道中使用从 Unity 导出的镜头视角、位移和滚转。一至四面从场景导出背景平面及循环位移，五、六面和 Extra A 用原版纹理重建地形，特殊材质、粒子和部分转场仍有差异。符卡沿用分层背景，BGM 使用原版曲目与循环点。
2. 弹图使用原图，动画弹型暂用静态切片；敌机使用项目妖精行走图，主/副Boss使用原prefab、Sprite切片中心及Animator状态图，开符立绘和按符卡编号生成的背景也取自原prefab。副体伤害汇到本卡总HP，原版独立血条和死亡/复活联结尚未复现。
3. 点弹使用原生椭圆判定；敌机的体术/受弹半径、原作扫掠碰撞、各类激光的宽度、尾部离屏、出生/收束和擦弹是原生代理，仍须逐类与原版核对。
4. 通用数值事件、插值、自机狙、扇形/半径发射、绑定、深绑定、随机移动和常规变速已接入；特殊父子旋转组合、冻结/全局控制、原作自定义组件、HSV/反色着色器等尚未完整复现。原版纯蓄力、爆炸、震屏发射器不制造有判定的替代弹。
5. 使用项目随机源与Lua double，没有重建System.Random序列或float32舍入。数值表完整导出不等于每个Unity专用行为已经等价。

没有以密度评分为由增加底帘或改变原始发射参数。

## 复现检查

在游戏根目录运行，使用LuaJIT 5.1；导出器需要Python、PyYAML和Pillow：

```sh
python3 tools/th38-tests/export.py /Users/happyelements/asl
python3 tools/th38-tests/export_background.py /Users/happyelements/asl
luajit tools/th38-tests/check_background.lua
STAGE_STRICT_NEW=1 luajit tools/th38-tests/check_motion.lua
STAGE_STRICT_NEW=1 luajit tools/th38-tests/check_flow.lua
STAGE_STRICT_NEW=1 luajit tools/th38-tests/check_full.lua /tmp/th38-full.json
STAGE_STRICT_NEW=1 luajit tools/th38-tests/check_leaks.lua /tmp/th38-leaks.json
STAGE_STRICT_NEW=1 STAGE_SEED=11111 luajit tools/th38-tests/check_leaks.lua /tmp/th38-leaks-11111.json
luajit tools/check_fields.lua mod/GAME/th38.lua mod/GAME/th38/runtime.lua
luajit tools/check_sequence_mode.lua
luajit tools/check_slim.lua
python3 macos/build.py --update-assets
python3 tools/th38-tests/native.py --sequence thasl_lunatic --damage --frames 600 --out /tmp/asl-opening
python3 tools/th38-tests/native.py --sequence thasl_extra_a --frames 1000 --out /tmp/asl-extra
python3 tools/th38-tests/native.py --card 38004 --repeat --frames 700 --out /tmp/asl-retry
python3 tools/th38-tests/native.py --card 38066 --frames 9000 --out /tmp/asl-final
```

检查使用临时数据目录，不访问玩家User/replay。Lua模拟不能替代真实引擎的图像、输入、碰撞或Windows Sub引擎验证。真实引擎报告记录平台和当前源码哈希。

## 验证记录

2026-11-12：首只敌机在原作400tick出生，首个有效tick按280度移动2.4px；独立检查实际子弹坐标、变速、绑定出弹、私有变量及清场。七面关卡轴、71段主流程Boss顺序、两个最终攻击转阶段通过。完整时限、两种子长时扫描及Mac实机结果保存在本目录`verification-*.json`。

- 91项按原始HP运行完整时限，共279977帧，错误0、结束残留0；两张最终攻击各触发3次阈值。
- 两种子、五个代表阶段的3600/7200帧峰值一致，普通弹池始终不超过1500，结束归零。
- 练习22110项、顺序1770项、精简/录像边界603项断言通过；117份修改/新增Lua脚本通过LuaJIT语法检查，字段审计通过。
- Mac实机：L开场600帧并验证敌机通过真实自机弹碰撞100→70HP；Extra A开场1000帧；练习700帧重试两次状态哈希一致；双Boss1000帧、激光1200帧；六面最终攻击9000帧经过p2/p3/p4，约59FPS。另回归幕华祭开场600帧。

## 2026-11-19：霜寒亿万劫的时间流速

对照 `Enemy_chuliluo.cs`、`Timegame.cs`、`Basic.cs` 和空Sprite预制体 `enemy/emy42.prefab`，将敌机类型21恢复为隐藏的时间控制器。扫描全部99组弹幕，该类型只被 `L/stage6/boss1/9/slow0.txt` 使用；其原始事件以1440tick为周期，在180、780、1150tick触发，持续270、120、240tick，倍率0.33。

`THlib/native_time.lua` 在正常游戏、录像和练习的共用逻辑入口累积时间预算，同时减速自机移动、C#射击更新、敌弹、碰撞和符卡计时。持续时间结束后，按原C#单精度每tick加0.01恢复；切卡、清场、重试和切换场景复位。时间控制器不生成普通妖精，也没有敌机贴图和体术判定。渲染、音乐和暂停菜单继续运行。

`check_time.lua` 核对三次触发、持续时长、69tick恢复及时间预算。macOS真实引擎运行1100逻辑帧；减速窗口的100个渲染帧推进32个逻辑帧，自机位移32次，敌弹和自机射击时钟同步推进64tick，三轮均恢复正常。另在300逻辑帧、尚处减速时重试，两轮状态哈希一致；完整时限3690帧无运行错误、清场残留0。记录见 `verification-mechanics-2026-11-19.json`。

```sh
STAGE_STRICT_NEW=1 luajit tools/th38-tests/check_time.lua
python3 tools/native-player-tests/native_logic.py --levels 36 --card 38065 --variant mechanics --frames 1100 --out /tmp/asl-mechanics
python3 tools/th38-tests/native.py --card 38065 --repeat --frames 300 --out /tmp/asl-slow-retry
```

LuaSTG仍按60Hz宿主帧成对推进原作120Hz tick，存在一个宿主帧内的量化差异；上述检查不表示其他Unity专用组件或Windows Sub已完成等价验证。
