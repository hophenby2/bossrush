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

1. 自机、伤害、Bomb、掉落和生命规则沿用本项目；道中和符卡背景用原版贴图在 LuaSTG 中重组，战斗 BGM 从发行版 XACT 波形库导出。Boss 行走图、转向/回正、蓝与白莲旋转、幽幽子特殊动作均使用原图和原始参数；全部角色开符立绘及二维符卡背景从原数据离线展开。原版 3D 场景已导出完整48套模型、72张原尺寸纹理与312条时间轴命令；对白和完整音效演出仍有差异。
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

## 2026-11-19：灯笼与区域事件校准

对照原 `CrazyStorm.cs`、`Cover.cs`、`Barrage.cs`、`Force.cs` 和 `b652.xna`，修复共用区域后端：

- 重新导出92处覆盖区域的 `bindid/Deepbind`，包括21处对象绑定；绑定对象尚未出生或已经回收时，区域不生效。
- `controlid` 按原作一基编号选择零基弹源；非绑定区域使用 `(x-4,y+16)`，圆形半径为半宽/半高的最大值。
- 覆盖区域在进入时附加事件、离开时卸载，使用弹龄而非驻留时间；事件按附加顺序执行，区域结束和循环重置后停止生效。
- 力场使用相同的目标编号和坐标规则，保留弹体现有速度及横纵倍率。

`诱魂「彷徨的空蝉」` 中，灯笼存活时覆盖区域会抹掉Boss的扇弹；追踪球接触灯笼、灯笼结束消散后才放行。没有为这张卡另写固定延时发弹。

`check_fields.lua` 使用实际 b652/b843 数据，核对未追到灯笼0发有效弹、追到后21发、弹龄340触发、离开卸载及0.007吸引力。macOS真实引擎另运行900逻辑帧，实际追踪并验证等待和放行。区域涉及的21个战斗/道中练习阶段另做完整时限回归；记录见 `verification-mechanics-2026-11-19.json`。

```sh
STAGE_STRICT_NEW=1 luajit tools/th37-tests/check_fields.lua
python3 tools/native-player-tests/native_logic.py --levels 35 --card 37064 --variant mechanics --frames 900 --out /tmp/spring-mechanics
```

这些检查覆盖上述区域机制，不代表全部激光、随机序列或原作全局缓时已经等价。

## 2026-11-19：彷徨的空蝉的魂轨迹

上一轮灯笼触发检查没有逐帧比较魂的运动。本轮直接编译原始C#的弹幕、力场、覆盖区域和事件执行器，记录三种自机输入下的魂坐标，随后用相同输入对照移植版。

修正未绑定区域错误叠加Boss中心偏移、力场/区域晚于发射器执行、新生弹提前受到力场的问题。按 `BExecution` 立即写回速度分量，恢复魂追踪所依赖的单精度运动、三角函数及 `Main.Twopointangle` 的竖直线分支。固定上方减速区后，魂会依次进入原作的21、0.78和0.3速度阶段。

只对照本卡的灯笼、影子和追踪魂：静止、移动、按3.5像素/帧追灯，共3655个原始C#坐标，位置误差均小于0.05像素，速度阶段、生命和对象存在时间一致。来源、复现方法与原始记录见 `oracle/soul/`，运行 `STAGE_STRICT_NEW=1 luajit tools/th37-tests/check_soul.lua`。
