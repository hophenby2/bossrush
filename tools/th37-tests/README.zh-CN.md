# TH37：东方幕华祭·春雪篇原生对象移植初版

入口为 `mod/GAME/th37.lua`，实际level为35。34继续保留给完整版地灵殿，原有卡号和练习索引不移动。

主菜单的顺序模式新增：

- 幕华祭春雪篇 · Lunatic：通常六面。
- 幕华祭春雪篇 · Extra。
- 幕华祭春雪篇 · Phantasm。

符卡练习新增幕华祭分类，可以选择93个战斗阶段和28个道中窗口；关卡练习提供八面完整流程。保留原版Lunatic、Extra、Phantasm各自数据，没有混入Easy/Normal/Hard行。

## 数据和实现

本地来源：`/Users/happyelements/crack/THMHJ.PartII.Restored`。`sources.json`记录资源及20份相关C#源码的SHA-256。原工程保持只读，发行目录不依赖该绝对路径。

| 项目 | 数量 |
| --- | ---: |
| 符卡阶段 | 56 |
| 非符阶段 | 37 |
| 独立道中练习窗口 | 28 |
| 完整关卡轴 | 8 |
| 弹幕源文件 | 214 |
| 点弹发射器 | 3320 |
| 激光发射器 | 51 |
| 区域、反弹板、力场 | 91 / 12 / 3 |
| 编译的局部及中心事件 | 14352 |
| 展开的道中命令 | 2695 |

`export.py`离线解出本地XNA资源，将For循环和事件文字转换成Lua条件、函数和直接调用。游戏内不运行C#、XNA或CrazyStorm文本解释器。弹体、激光、敌机分别由LuaSTG的bullet、laser、enemy对象承载，Boss使用项目的boss/card系统。

原场地为384×448，坐标保持1:1：敌机 `(x-224,240-y)`，CrazyStorm弹体 `(x-317,227-y)`。条数、周期、速度、原始HP及时限保留源值；括号次数限制按原EventRead共享状态跨Totalframe循环保留。`CONTINUE`的8个时间/血量阈值留在原有最终攻击内，不额外注册成新符卡。

完整关卡在Boss存活时冻结原关卡轴，现存道中敌机和弹体继续更新；道中窗口单独练习时先无对象预滚建立CopyEnemy模板。后半段不会因缺少前半模板而漏怪。

动态弹图和敌机图放在全局资源池，保证练习重试清理关卡池后，模块缓存仍指向有效精灵。

## 已知适配差异

这是可运行的初版，尚未完成原作逐帧等价核对。

1. 自机、伤害、Bomb、掉落和生命规则沿用本项目；背景/BGM使用现有妖妖梦资源，Boss使用项目行走图。未移植原版资源经济、对白、3D场景、XACT声库及全部演出。
2. HP保留原始值，尚未按原版与项目自机DPS标定。击破时间和原版不能直接等同。
3. 激光使用原生直线laser近似。原版射线形态、贴图宽度、出生/消散、拖影、边缘碰撞和擦弹仍有差异；点弹使用原生椭圆判定，没有重建原版完整扫掠碰撞算法。
4. 原版跨对象缓时目前只作用于该弹幕控制器的弹体运动，没有完整同步原版自机、中心、敌机和声音时钟。深绑定、区域触发、反弹和力场仍须对照原版复杂组合。
5. Lua使用double数值和本项目随机源，未逐条复现C# float32与原作随机序列。

没有为了密度、难度评分追加底帘或修改原始发弹参数。语法全部展开不表示上述语义已经等价。

## 复现

在游戏根目录运行，需要LuaJIT 5.1和Python的pycryptodome：

```sh
python3 tools/th37-tests/export.py --source /Users/happyelements/crack/THMHJ.PartII.Restored
STAGE_STRICT_NEW=1 luajit tools/th37-tests/check_motion.lua
STAGE_STRICT_NEW=1 luajit tools/th37-tests/check_flow.lua
STAGE_STRICT_NEW=1 luajit tools/th37-tests/check_leaks.lua /tmp/th37-leaks.json
STAGE_STRICT_NEW=1 luajit tools/th37-tests/check_full.lua /tmp/th37-full.json
luajit tools/check_sequence_mode.lua
luajit tools/check_slim.lua
luajit tools/check_fields.lua mod/GAME/th37.lua mod/GAME/th37/runtime.lua
```

Mac资源更新及真实引擎检查：

```sh
python3 macos/build.py --update-assets
python3 tools/th37-tests/native.py --sequence thmhj2_lunatic --damage --frames 1000 --out /tmp/th37-native
python3 tools/th37-tests/native.py --card 37004 --repeat --frames 600 --out /tmp/th37-retry
python3 tools/th37-tests/native.py --card 37006 --frames 1000 --out /tmp/th37-laser
```

检查使用临时数据目录，不接触玩家的User或replay。不要把短道中窗口选为长时间原生检查，否则练习自然结束的暂停菜单会使目标逻辑帧无法到达。

## 2026-11-12验证记录

- 一面首波位移回归：b191在60帧首次生成两发；15帧出生期之后，首个有效帧位移3.5像素，十个有效帧累计35像素。另核对透明装饰弹无伤害判定及清场；b367跨三个循环只创建两个持久宿主；另核对Barrage的零基类型编号到原生弹图表的一基换算。
- 修复过的实际问题：发射器积分缓存被复制给弹体，静止发射器使原始子弹速度失效；现已独立初始化弹体速度/加速度缓存。此前“无运行错误”的扫描未能发现该问题，因此不能代替位移断言。长时扫描另发现并修复了一次事件计数在循环时重置、导致绑定宿主反复创建的问题。
- 121段完整时限LuaJIT模拟共356511帧，无运行错误，每段结束后的幕华祭对象残留为0。
- 两个随机种子下对普通弹、激光、绑定弹和最终攻击做3600/7200帧扫描；绑定卡峰值均为1001/1001，其余三张无持续线性增长，结束清场均为0。
- 八面流程核对93个战斗的顺序、Boss等待和关末清场；8个CONTINUE阈值检查通过。
- 顺序入口/录像回归1574项、练习注册/来源/排序回归21833项、精简内容边界599项通过；字段审计通过。
- Mac真实引擎验证Lunatic开场、Extra开场、Phantasm开场各1000逻辑帧；记录弹体实际位移。Lunatic还用实际自机弹碰撞验证道中敌机100→70HP及命中弹消耗。
- Mac真实引擎验证一面激光符1000帧，以及眠符600帧后重试再跑600帧；重试前后同种子对象状态哈希相同，动态精灵资源仍有效。

这些原生样本不是八面全部通关、全部碰撞边界或Windows Sub实测。机器可读记录见本目录的verification JSON。
