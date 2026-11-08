# TH36：地灵殿整关移植与验证

入口是 `mod/GAME/th36.lua`，关卡号34。Windows散装Lua直接生效，无需构建。

## 收录范围

- 六个通常关卡采用原版 **Lunatic** 难度掩码，另含Extra；没有把其他难度的某一行混入。
- 86个独立战斗阶段：54个符卡入口、32个非符入口，ID为11000–11085。
- 觉的六种自机／支援组合、18个回忆符卡均能单独练习。
- 七个整关入口，ID为11101–11107，从各面的 `main` 驱动道中、中Boss、主Boss及换卡。正常关卡菜单依次执行这七面。整关的觉路线固定为灵梦／紫，其他路线列在符卡练习中。
- 七个独立道中入口，ID为11201–11207，沿main的原始出生／等待时钟，剥离Boss与中Boss演员。它们与86个阶段一同接入Roguelike版本4；完整整关入口不重复入池，主线的七条完整流程保持原入口。
- 阶段分布：一面7、二面7、三面9、四面22、五面10、六面10、Extra21。整关入口另计。

血量按用户要求换算到原作六种自机低速满火力活跃TTK中位数，目标为移植灵梦115.5 DPS。ECL仍读取累计血槽的原始life与阈值；弹幕参数保持原ECL口径。完整口径、机体采样限制和86项血量表见 `mod/GAME/th31_th34_th35_original_player_ttk_hp_calibration.md` 末尾TH36节。

## 来源与实现

使用用户指定的原版日文1.00a资源与 `E:\workspace\th11` 重建工程。原版exe的SHA-256：

`2978b17f6184d100d249d4311348dd30c5c32ec75c014b667a525b797d3d8813`

`source.py` 在解析时逐条核对二进制地址、长度、时间、引用位及难度掩码；20份ECL的哈希见 `mod/GAME/th36/sources.json`。`expand.py` 离线生成七份普通Lua函数，分支成为Lua基本块跳转，同步／异步调用成为独立协程。发行版不需要ECL、thtk或重建工程，也不保存ECL指令数组。

对象后端拆为：

| 文件 | 职责与证据 |
|---|---|
| `mod/GAME/th36/runtime.lua` | 原作寄存器、float32、随机数、独立线程时钟、双路运动、血量中断、敌机生命周期；对照重建工程的SecondaryScript、SecondaryActor系列 |
| `mod/GAME/th36/projectiles.lua` | 枪槽、九种发射方式、弹变换、直线激光；原PE的0x408f20、0x409700、0x40a1f0等 |
| `mod/GAME/th36/bullet_profiles.lua` | 原PE 0x4a3ec0，29项×0xd0的弹型、判定和调色板表 |
| `mod/GAME/th36/callbacks.lua` | 原PE 0x4a3d64的专用回调，以及0x417ef0／0x418050的勇仪弧形受击／体术采样 |
| `mod/GAME/th36/catalogue.lua` | 独立二进制探针提取的阶段血量、时限、中文显示名和来源子程序 |
| `mod/GAME/th36/hp.lua` | 参照TH32的原始life／框架HP边界；整关、逐卡、普通敌机和从属实体共用，耐久与占位血量不缩放 |
| `mod/GAME/original/th11_low_speed_hp.lua` | 六自机活跃TTK中位数生成的分段HP表；逐机体数据和源文件哈希见 `tools/th36-tests/low_speed_hp.json` |
| `THlib/anm/original.lua` | 增加TH11的色号解析、子动画、Hermite位置插值及弧形带绘制；旧作品保持各自编号表 |
| `mod/GAME/th36/animation_layers.lua` | ANM68的12／14层跨敌机绘制，保留回归虚无的红色普通透明本体与白色加算辉光的原作顺序 |

敌机、子弹、激光、弧形受击节点和演出物件均为LuaSTG对象。原作出生保护在极坐标偏移后逐颗判定；没有额外增加自制底帘、密度修正或保护缺口。

## 明确的适配差异

1. 道具接入本项目power／faith体系，未重建原版计分、残机与资源经济。
2. 省略MSG对白及等待对白的墙钟时间；保留ECL自己的等待、Boss生死等待和攻击时钟。
3. 符卡背景使用原作stgenm ANM的两层脚本、60帧淡入、UV、旋转、颜色与混合，并按原生符卡号区分六面／Extra中Boss。场景背景、BGM、音效与界面仍沿用项目TH11，未移植STD、原版音轨切换及全部原作枪音。
4. 使用本项目自机、伤害入口及LuaSTG碰撞后端。勇仪弧形实体采用原版采样点加普通敌机节点；激光由LuaSTG直线激光对象承载。跨引擎的边缘碰撞、反射激光及GPU输出仍需原版逐帧轨迹／像素对照，不能由“无运行错误”推定完全一致。

前两项在runtime中也有「差异」注释，后两项在关卡入口注明。**本次验证证明的是下面列出的范围，不是逐帧、逐像素全量等价的证明。**

## 重现生成

以下命令在仓库根目录运行。Python工具的源码、缓存和引擎验证均不读写玩家的 `User/`、`replay/`。

```powershell
$dat = 'E:\workspace\原作\[th11]+东方地灵殿+(汉化版+日文版)\[th11] 东方地灵殿 (汉化版+日文版)\th11.dat'
$src = 'E:\workspace\.bossrush-validation\th36-source'
python tools/th36-tests/prepare.py $dat --output $src
python tools/th36-tests/expand.py $src --check
python tools/th36-tests/catalogue.py $src
python tools/th3x-tests/export_original_anm.py --games 11
```

`prepare.py`通过二进制管道保存thecl的CP932与UTF-8输出，避免PowerShell重定向改变日文声明的编码。ANM导出器单独追加11，不重写其他作品的资源记录。

## 验证口径

0.13.8受弹修复：`enemybase`把`colli`赋值缓存为`_colli`，由其frame写入引擎；TH36的演员和怪轮节点跳过该frame，必须显式`SetAttr(...,'colli',...)`。修复前六面Crow00、Crow01、BPhantom00的真实自机弹碰撞均未命中，实际引擎colli为false，尽管缓存为true。原有直接扣HP／自然结束检查不覆盖这条路径。新增`native_enemy_damage.py`将测试自机弹放入实际碰撞分组，经过OriginalCollision和enemybase.colli核对扣血与子弹消耗；怪轮还验证节点收集到原回调的伤害传递。该检查为Windows Sub真引擎，不等于Android设备实测。

Roguelike接入检查：`python tools/th36-tests/run_lua.py tools/check_roguelike.lua`覆盖五作503项筛选、TH36的93项分类、版本2/3原种子路线、无限单候选跨轮及历史接续阈值。`python tools/th36-tests/check_rogue.py`检查七个独立道中的自然结束、Boss剥离、整关Boss保留、九个筛选项与键盘／点击输入；传入`--native 验证目录`另核对真实引擎七条道中、入口集合、无Boss符卡及清场结果。记录为`verification-rogue-2026-11-08.json`。

2026-11-08血量校准同时修正了两处会破坏击破时间的旧问题：三面中Boss第二非符的负阈值注销不能覆盖9000的进场life，逐卡入口须继承中Boss槽1；362指令仅设置spell状态8位，不能直接把可击破的墨迹测验设为全程无敌。妖怪测谎机与被厌恶者的哲学根据ECL持续无敌／隐藏判定为耐久，保留原始HP。

重新生成血量表并检查：

```powershell
$hp='E:\workspace\.bossrush-validation\th36-hp-sht'
python tools/th36-tests/calibrate_low_speed_hp.py --assets $hp --ecl $src --archive $dat
python tools/th36-tests/check_hp.py
```

`check_hp.py`在LuaJIT中以115.5 DPS逐帧扣血核对84个可击破阶段，另外核对2个耐久、原始life阈值、道中残血与最低1 HP、符卡期间普通敌机比例、以及怪轮从属演员31节点的单次伤害换算。检查关闭发弹；真引擎生命周期另由下面两批检查覆盖。

本次血量版的Windows真引擎验收见 `verification-native-hp-2026-11-08.json`：86个阶段完整时限共286,206帧，七条整关击破流程共96,041帧；均无运行错误，清场后敌机／子弹／激光均为0。核对52份运行时文件指纹，包含新增HP表与桥接代码。该结果验证生命周期与流程，不把强制击破流程当作115.5 DPS实测；扣血总量由上述LuaJIT检查独立核对。

本机未安装独立luajit命令，使用私有目录内的Lupa LuaJIT 2.1执行5.1语义检查；没有使用Lua 5.4。

```powershell
$env:PYTHONPATH='E:\workspace\.bossrush-validation\python-libs'
$env:PYTHONUTF8='1'
$env:PYTHONDONTWRITEBYTECODE='1'
python tools/th36-tests/check_semantics.py $src
python tools/th36-tests/check_projectiles.py
python tools/th36-tests/run_lua.py tools/check_original_anm.lua
python tools/th36-tests/run_lua.py tools/check_spell_backgrounds.lua
python tools/th36-tests/run_lua.py tools/check_fields.lua mod/GAME/th36.lua mod/GAME/th36/runtime.lua mod/GAME/th36/projectiles.lua mod/GAME/th36/callbacks.lua
```

- 独立标量ECL探针对比217个叶子发弹子程序、20,833次完整枪槽事件；另核对1,000个原版随机数输出。它不验证父子调用、全部运动或碰撞。
- 发弹数学契约检查九种枪的54颗样本、层间相位、逐颗出生保护、8帧出生过程与出生分裂的递归占槽；另检查全场缓时／清理恢复、超时结果、零血保留、幻影闪烁和原版引力的带符号位移及1/128坐标量化。它不是全部弹变换的轨迹证明。
- 原作ANM资源回归438项、70个作品／角色组合；符卡背景回归7项。与本次修改前的ANM源码逐帧比较旧作品状态和绘制参数，46,675次对照通过（使用`check_anm_optimization.lua`的状态／绘制部分，未把其旧版Color分配基准当成本次性能断言）。
- Windows原生验证使用隔离的LuaSTG Sub 0.21.129发行目录，冻结本次Lua副本，共享只读素材；分别跑86个阶段完整时限及七个整关击破流程。`check_native.py`核对源码指纹、入口集合、整关默认路线的全部符卡ID和清场残留。机器可读结果见本目录的验收JSON。
- 全项目注册检查目前仍有原有ID453–460、470–476的15处重复；TH36的新ID不与其重叠。

真引擎批次顺序执行，避免多个D3D设备同时加载全项目纹理。验证目录必须是新的目录：

```powershell
$tag=Get-Date -Format yyyyMMdd-HHmmss
$battle="E:\workspace\.bossrush-validation\th36-battle-$tag"
$flow="E:\workspace\.bossrush-validation\th36-flow-$tag"
$cards=(11000..11085)-join ','
python tools/th3x-tests/native_engine.py --output $battle --games 36 --cases $cards --frames 0 --speed 6000 --mode timeout
python tools/th3x-tests/native_engine.py --output $flow --games 36 --cases 11101,11102,11103,11104,11105,11106,11107 --frames 0 --speed 6000 --mode defeat
python tools/th36-tests/check_native.py $battle $flow --source $src --output tools/th36-tests/verification-native-hp-2026-11-08.json
```

```powershell
$env:STAGE_STRICT_NEW='1'
# 长测只省略空绘制的ANM调用，仍执行真实ANM状态和精灵尺寸；GPU绘制由真引擎批次验证。
$env:STAGE_NO_ANM_DRAW='1'
python tools/th36-tests/run_lua.py tools/check_stage.lua mod/GAME/th36.lua 3600
python tools/th36-tests/run_lua.py tools/check_stage.lua mod/GAME/th36.lua 7200
foreach ($seed in 20260916,11111,98765,55555,31415,777) {
    $env:STAGE_SEED=[string]$seed
    python tools/th36-tests/run_lua.py tools/check_stage.lua mod/GAME/th36.lua 1200 --threat
}
```

这些密度读数只记录，不据此调整移植参数。检查工具已把TH36的自定义子弹对象纳入弹统计，每帧只推进一次；此前把它们列为普通对象会得到错误的“弹数0”。

2026-11-08后续调整：roguelike新局使用卡池版本5，关闭TH36选择。准备界面移除TH36，旧设置中的TH36勾选也会被清除；新池为四作410项。版本4的旧录像仍保留五作503项，版本2／3的既有种子路线保持不变。TH36的主线、整关和逐卡练习继续保留。`tools/check_roguelike.lua`与本目录`check_rogue.py`分别验证卡池／旧路线和八项准备面板的键盘／触屏行为。
