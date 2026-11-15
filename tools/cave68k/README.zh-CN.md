# Atlus Cave 基板采样

ShmupMAME 5.4 的 `src/mame/atlus/cave.cpp` 里，`ddonpach_map` 将工作 RAM 映射到 `0x100000`，`guwange_map` 将它映射到 `0x200000`。两作的精灵 RAM、图层 RAM 和调色板使用同样的地址。`cave_v.cpp` 的 `get_sprite_info` 从视频寄存器第 4 字选择精灵库。`init_ddonpach` 使用无缩放记录，Guwange 使用缩放记录。

```powershell
$mame = 'E:/Downloads/shmupmame_5.4_win64'
$capture = (Resolve-Path tools/cave68k/capture.lua).Path
$out = 'D:/bossrush-pgm-probes/guwange-states/2'
New-Item -ItemType Directory -Force -Path $out | Out-Null
$env:CAVE_STATE = "$mame/sta/guwange/2.sta"
$env:CAVE_FIRST = '25'
$env:CAVE_LAST = '110'
$env:CAVE_TRACE = "$out/cave.bin"
Push-Location $out
try {
    & "$mame/shmupmame_5.4.exe" guwange -noreadconfig -rompath "$mame/roms" -video none -sound none -nothrottle -skip_gameinfo -autoboot_delay 0 -autoboot_script $capture -seconds_to_run 100
} finally {
    Pop-Location
}
python tools/cave68k/analyze.py "$out/cave.bin" guwange --frame 100
```

实测从 Guwange 本地第 2 号存档取得 86 帧，包含带缩放的精灵记录、三层图块和滚动寄存器。`CAVE_COIN`、`CAVE_START`、`CAVE_SHOT` 可以分别指定冷启动的投币、开始和确认输入帧。怒首领蜂使用 2900、2980、5450，至第 5750 帧可见开场起飞演出。敌机和敌弹还要与工作 RAM 中的记录逐帧对应。
