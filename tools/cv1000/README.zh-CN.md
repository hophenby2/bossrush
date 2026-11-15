# CV1000 顺序模式、关卡练习与离线采样

| 练习入口 | 原作版本 | 主流程 |
|---|---|---|
| TH46 | 《虫姬二人》1.5 Original | 第一至五面 |
| TH47 | 《Espgaluda II》Ageha | 第一至六面 |
| TH48 | 《虫姬二人》Black Label 日版 Original | 第一至五面 |

自机、敌机、敌弹和自弹都使用 LuaSTG 对象。每一面的背景按 EP1C12 绘制指令加载和滚动图块，关底推进和击破由本局伤害触发。顺序模式和关卡练习均从第一面连续进入最终结算。

发弹和移动以实战采样重建。敌弹识别、发弹归属、瞄准、零件伤害与各档血量仍有推定值。各作还缺独立零件击破分支、原版计分和角色特技。两版 Futari 的其它难度、隐藏战、Black Label 国际版，以及《大复活》仍未接入。《大复活》需要父集 `ddpdfk.zip`。

## 导出整作

`campaign.py` 的 `LEVELS` 记录每面的起点、各场关底的区段和续采帧。冷启动轨迹使用 `CV1000_FIRST=5100`、`CV1000_FIRE=5450,95000`、`CV1000_KEEP_LIVES=1` 和 `CV1000_VISIBLE_ONLY=1`。三作依次在 72200、65300 和 65600 帧保存状态，从对应状态续采至末战结束，`CV1000_RESUME_FRAME` 和 `CV1000_FIRST` 分别填写保存帧及其后第二帧。重开模拟器时保持同样的按键与残机采样设置。

使用 `CV1000_EXTRA_VRAM` 记录道中和关底的显存。导出时用多个 `--vram` 传入 `cmd.bin.vram.<帧号>`，可用 `--stage` 重导其中一面。导出的数据包含每关的精灵和独立图集。

两版 Futari 第三面的地形素材会在同一显存地址滚动更新。冷启动后在 26500–43870 帧（1.5）或 24500–40850 帧（日版 Black Label）设置 `CV1000_UPLOADS` 为记录文件的绝对路径，可同时设 `CV1000_SNAPSHOT_ONLY=1`。将这次的文件交给 `campaign.py --stage 3 --uploads`，按原上传时序更新地形纹理。以第一面使用的资源生成器只提取通用自机图集和菜单预览。

```powershell
python tools/cv1000/campaign.py futari15 "$out/full/cmd.bin" "$out/end/cmd.bin" `
  --stage 2 --vram "$out/full/cmd.bin.vram.23000"
```

## 单面采样

使用 ShmupMAME 5.4 与 Python 3、NumPy、Pillow。以 `CV1000_KEEP_LIVES=1` 采集下表的范围，`CV1000_VRAM` 取主显存帧，`CV1000_EXTRA_VRAM` 取逗号分隔的额外帧。`CV1000_PREVIEW` 中指定任一实战帧生成菜单预览。每作在各自空目录运行，避免共用模拟器存档。

| ROM 集 | 连续采样 | 主显存帧 | 额外显存帧 |
|---|---:|---:|---:|
| `futari15` | 5100–18400 | 10300 | 7250、14000 |
| `espgal2` | 5100–18400 | 10300 | 6850、14000 |
| `futariblj` | 5050–17300 | 11200 | 7100、14000 |

`export.py` 可单独提取首面和自机资源。指定 `--output` 到采样目录可保留整作的首面数据。

## 采样工具

已在 ShmupMAME 5.4 跑通 `futari15` 和 `espgal2` 的 EP1C12 绘制命令及纹理提取。驱动 `src/mame/cave/cv1k.cpp` 定义 SH-3 工作 RAM 和 320×240 可视区，`src/mame/cave/ep1c12.cpp` 的 `gfx_exec` 定义绘制、上传和裁剪指令。采样从设备的命令副本中读取数据；查看工具可以从同次运行的显存裁出单张素材。

```powershell
$mame = 'E:/Downloads/shmupmame_5.4_win64'
$out = 'E:/fork/.cv1000-futari15'
New-Item -ItemType Directory -Path $out -Force | Out-Null
$env:CV1000_TRACE = "$out/cmd.bin"
$env:CV1000_FIRST = '5250'
$env:CV1000_LAST = '6600'
$env:CV1000_VRAM = '6500'
$script = (Resolve-Path tools/cv1000/capture.lua).Path
Push-Location $out
try {
    & "$mame/shmupmame_5.4.exe" futari15 -noreadconfig -rompath "$mame/roms" -video none -sound none -nothrottle -skip_gameinfo -autoboot_delay 0 -autoboot_script $script -seconds_to_run 120
} finally {
    Pop-Location
}
python tools/cv1000/analyze.py "$out/cmd.bin" --frame 6500 --sprite 5 --output "$out/sample.png"
```

- `futari15` 第 6500 帧读取 666 条绘制命令，`espgal2` 同帧读取 751 条。单次显存快照为 128 MiB。分析工具输出单张精灵并保留源、目标坐标。
- `espgal2.zip` 本次使用 `E:/fork/shmupmame_5.4_win64/roms` 的副本。两个提供的 ROM 目录均缺少 `ddpdfk.zip`，其中的 `ddpdfkl2.zip` 仅含 `placeholder`。
- 采样同时保存自机坐标。Futari 的横坐标在 `0x0c38aaf4`，Espgaluda II 在 `0x0c37d72c`，后一个 32 位字段为纵坐标。设 `CV1000_SHIFT=1` 时会在 5500 帧起输入右移。复测两作每个游戏步进分别移动 2.5 与 2.75 像素。
- 可用 `CV1000_SNAPSHOT_ONLY=1` 只写显存样本。可用 `CV1000_RAM_FRAMES='6500,6501,6600,6601'` 保存少量完整工作 RAM，文件名附加 `.ram.<帧号>`。用 `CV1000_STATE` 指定本地 ShmupMAME 存档的绝对路径时，采样从该存档继续，帧号以采样进程启动为起点。只读使用现有存档。
- 长时间采样可用 `CV1000_KEEP_LIVES=1`。普通采样中，Futari 的 `0x0c38aabc` 和 Espgaluda II 的 `0x0c37d6fc` 在自机坠落时依次从 `0x01000003` 降到 `0x01000002` 和 `0x01000001`。该选项只补回这个计数，游戏仍按原逻辑处理受击、清弹和复活。
- 在两个游戏的连续样本里确认了各有一组 128 项定点位置记录。Futari 在 `0x0c517ed8` 记录第一个横坐标，步长 `0x54`。Espgaluda II 在 `0x0c4b5028`，步长 `0x2c`。位置后的两个 32 位字段是每次更新的位移。还需要区分会产生伤害的敌弹、预备弹和绘制特效，并确认敌机、发弹归属及关底状态。
- Futari 日版 Black Label 的自机横坐标在 `0x0c383a68`，残机计数在 `0x0c383a1c`，实测横移 3 像素/游戏步进。自弹对照用 `CV1000_FIRE` 指定按键起止帧。查看器用 EP1C12 第 29 位判定带透明绘制时哪些像素可见。
