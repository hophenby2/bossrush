# 大往生与 Espgaluda 第一至五面

## 大往生 V101 原程序

`probe_ddpdoj.lua` 可用 ShmupMAME 5.4 的 `-autoboot_script` 在独立目录执行，导出解密后的 `ddpdoj-program.bin` 并记录最初的回调挂载。运行以下命令可导出五面共 2237 条生成指令和 36 个敌弹模板。

```powershell
python tools/pgm/inspect_ddpdoj.py ddpdoj-program.bin --spawns spawn.csv --bullets bullet.csv
```

原程序的 `0x161c4c` 按主卷轴计数消费 8 字节生成指令。开场的 `0x11` 小机从各自的路径入口初始化，`0x161eba` 写入逐帧回调 `0x167158`。该敌机调用 `0x17fc9a` 发射 `0x0d` 弹，弹体首帧回调 `0x18110a` 再登记 `0x181146`。探针已在运行时读回小机与弹体的两种挂载。整关练习仍使用下面记录的旧数据。

### 原生移植的复现和验证

从解密后的 V101 程序和本地 ROM 图形数据重新导出五面的生成表、两路卷轴指令、地图图块、路径和定点速度表。

```powershell
python tools/pgm/export_ddpdoj.py ddpdoj-program.bin E:/Downloads/shmupmame_5.4_win64/roms/ddpdoj.zip --output mod/GAME/th44/native --resources Resources/th44/native
luajit tools/pgm/check_ddpdoj.lua
```

原生试运行入口为 `mod/GAME/th44/native/runtime.lua`。一面开场回归覆盖小机、大机、两组坦克和 `0x85` 双判定盒机体。主卷轴计数 `0xbc` 时，`0x171314` 登记小机增援，下一帧按队列分配敌机槽并挂载父对象给出的路径与坐标。

`0x172228` 战舰交替推进主炮扇射和双炮塔齐射。回归对照两次扇射与首次炮塔齐射的角度、坐标及定点速度，并检查击破后 `0x172616` 登记的六个主爆炸和碎片对象。自机短按射击时，两种机体的机身弹从 `0x148e3a` 所用的 ROM 表取参数，经 `0x152ce8` 分派出膛、飞行和命中回调。受击测试覆盖扣减残机及补机装载。

`0x169f86` 中 Boss 的舰身与八座炮台占用各自的原版部件槽。回归对照炮台转动与首发、舱门两轮发弹、单炮台受击及击破，以及主舰击破后的清弹掉落和卷轴恢复。`0x16aa82` 在下一次生成队列消费后，按原版硬件行替换背景残骸图块。

中 Boss 后的炮车 `0x17302e` 使用两侧固定炮管和独立炮塔。回归对照两类炮口的首发帧、角度和速度，并跑过后续坦克、地炮、飞机掠过和警告直到一面关底的生成记录。单人横向视野使用 `0x15fcfa` 的定点位移和画面边缘切换条件。

主卷轴计数 `0x1e8` 挂载的一面关底回调 `0x190b0a` 尚待移植，原生流程尚未通关或接入顺序模式。副机、激光、炸弹、Hyper、完整卷轴事件、全部爆炸效果与精确计分仍待补齐。

关底初始化 `0x1908e2` 调用 `0x15860a`，同时挂载本体阶段表 `0x19130c`、攻击表 `0x193ab6`、绘制表 `0x190b3a` 以及两组部件任务表 `0x19190a` 和 `0x1931d4`。攻击任务有 10 个执行槽，两组部件任务分别有 10 和 5 个，每槽记录初始化是否已执行。

## 旧版整关练习

关卡练习入口为「怒首领蜂大往生 · 第一至五面」（TH44，level 42）与「Espgaluda · 第一至五面」（TH45，level 43）。两作从第一面连续推进。机体分别为 Type A 与 Ageha。射击键发通常弹，按住切换激光，射击加低速键可直接发激光，符卡键使用炸弹。

运行时使用 LuaSTG 对象。离线导出读取 68000 的敌机控制器、敌弹池、精灵表、背景图块和滚动寄存器。每颗弹保存实测的出生坐标、逐帧速度变更、贴图和判定状态，包含同一弹池槽位内从预备到运动的变化。能用横移对照确认的自机狙会重新瞄准。关底的原生判定对象按每帧原作部件位置和非对称判定盒更新。

## 关底行为来源

- 大往生第一面关底 `0x0e80` 的机身与两侧部件分别使用控制器 `+0x16`、`+0x1a`、`+0x1e`。在 `0x192d44`、`0x192e14`、`0x192ef8` 分别累计伤害，部件初始化为 `0x9000`，机身为 `0x16c00`。左右两边先击破的路径分别实测采样。机身击破后播放原采样爆炸，再进入第二面。
- Espgaluda 第一面关底 `0x6080` 由 `0x18deda` 处理多判定盒的伤害。初始总量为 `0x32600`，两段累计伤害为 `0x15200` 和 `0x1d400`。第二面关底 `0x6a80` 的原程序 `0x190ccc` 在剩余血量降至 `0x19300` 时换段。两处都采了后续攻击与击破演出。
- 大往生第三面关底 `0xa080` 在 `0x19ad2e` 比较剩余血量和 `0x11800`。Espgaluda 第三面关底 `0x6d80` 在 `0x1934ce` 与 `0x1935fc` 依次比较 `0x33cc0` 和 `0x168c0`。第三面击破后进入第四面。
- 大往生第四面关底 `0x4080` 在 `0x19e10e`、`0x19e148` 比较 `0x23000` 和 `0xc400`。Espgaluda 第四面关底 `0x7181` 由 `0x1993e4` 处理多个计数器。采样时手动触发计数器越线，LuaSTG 使用对应伤害量进入各段。
- 大往生第五面关底在 `0x1a5036` 比较 `0x2a000`，击破后从 `0x1a506c` 进入清场。Espgaluda 第五面关底的 `0x1bc5b4` 先扣前段计数 `0x41000`，`0x1bc908` 处理后一段击破。导出将这两个攻击段和击破演出接在对应伤害入口。
- Windows LuaSTG Sub 隔离测试通过原生伤害入口加速击破，检查左右部件、阶段切换、关卡衔接及返回菜单。

## 复现导出

在游戏目录使用 Python 3、NumPy、Pillow 和 ShmupMAME 5.4。模拟器的 ROM 目录中，大往生需要 `ddpdoj.zip` 及其父集 `ddp3.zip`。

先准备以下采样。运行 `tools/pgm/capture.lua` 时用 `PGM_GAME` 指定游戏、`PGM_TRACE` 指定输出路径。使用不同的工作目录隔离模拟器存档。 `PGM_MODE` 使用 `primary` 或 `shift`，`PGM_BOSS_ROUTE` 只用于下表标注的伤害采样。

| 传给导出器 | 大往生采样帧与路线 | Espgaluda 采样帧与路线 |
|---|---|---|
| `--primary` | 1300–12500，`primary` | 1300–12500，`primary` |
| `--shift` | 1300–12500，`shift` | 1300–12500，`shift` |
| `--damage` | 7700–22000，路线 `left` | 8100–22400，路线 `phase` |
| `--right-damage` | 7900–9600，路线 `right` | |
| `--third` | 20000–29400，路线 `campaign` | 20000–29400，路线 `campaign` |
| `--third-tail` | 29399–35500，路线 `campaign` | 29399–35500，路线 `campaign` |
| `--fourth` | 35199–49900，路线 `later` | 35199–50500，路线 `later` |
| `--fifth` | 49749–67500，路线 `final` | 49749–67500，路线 `final` |
| `--fifth-tail` | 67499–81000，路线 `final` | 67499–81000，路线 `final` |
| `--clear` | 78299–83900，路线 `clear` | 78299–83900，路线 `clear` |

在 PowerShell 中可按下例采样。根据上表替换环境变量和游戏。

```powershell
$mame = 'E:/Downloads/shmupmame_5.4_win64'
$script = (Resolve-Path tools/pgm/capture.lua).Path
$env:PGM_GAME = 'ddpdoj'
$env:PGM_MODE = 'primary'
$env:PGM_BOSS_ROUTE = 'left'
$env:PGM_FIRST = '7700'
$env:PGM_LAST = '22000'
$env:PGM_TRACE = 'E:/fork/.pgm-probe/ddpdoj-left-compact/ram.bin'
& "$mame/shmupmame_5.4.exe" ddpdoj -noreadconfig -rompath "$mame/roms" -video none -sound none -nothrottle -skip_gameinfo -autoboot_delay 0 -autoboot_script $script -seconds_to_run 1390
```

将采样路径传给 `python tools/pgm/export.py ddpdoj --roms "$mame/roms" --traces E:/fork/.pgm-probe`。Espgaluda 用 `espgal`。导出更新 `Resources/th44`、`Resources/th45` 及对应的 `mod/GAME` 数据。

## 已知差异

- 发弹归属和自机狙仍有未识别项。逐帧弹幕与部件轨迹来自有限的参考输入，LuaSTG 阶段跳转后可能接到不同的原动作相位。
- 关底只覆盖已采到的状态，未击破的采样段用循环延长。两作第五面击破后结算。部分普通敌机的受击、击破、分支和资源系统，以及大往生的二周目尚未移植。
- TH44、TH45 此前的录像与第五面更新后的数据不兼容。
