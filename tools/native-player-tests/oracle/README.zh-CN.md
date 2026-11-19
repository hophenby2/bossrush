# 原始 C# 发弹对照

`spring.tsv` 来自未修改的春雪篇 `EquipShoot.cs` 和 `Equipment.cs`。覆盖灵梦、魔理沙、早苗的四档火力，各运行 120 帧；第 40–80 帧低速，第 100 帧松开射击。记录全部 2332 次主炮／副武器生成的切片、坐标、伤害、速度、角度与缩放。妖梦的 CrazyStorm 武器另外由原生场景和 Bomb 测试覆盖，不包含在这份 TSV 中。

`Program.cs` 提供只记录发弹的 XNA 接口。复现时把它和原始两份 C# 文件放入 .NET 控制台工程运行；原始输入的 SHA-256 见 `mod/GAME/ports/mhj/native_players/sources.json`。

```sh
python3 tools/native-player-tests/check_csharp_source.py
luajit tools/native-player-tests/check_movement.lua
```
