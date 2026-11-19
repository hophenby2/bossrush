# 彷徨的空蝉原始轨迹

`generate.py` 从只读的春雪原工程复制 C# 到临时目录，直接编译 `CrazyStorm`、`Layer`、`Batch`、`Barrage`、`Force`、`Cover`、`Time` 及其事件执行器。它只去掉绘制和本卡未使用的激光更新；探针会拒绝带激光或反弹板的数据。没有另写一套魂的运动公式作为预期结果。

`Program.cs` 提供无图形接口，角色免伤，记录完整 b652 的三种自机输入：静止、连续移动、从560帧开始按3.5像素/帧追灯。每种运行880帧。`soul.tsv` 的 `P` 行是原作自机坐标；`B` 行是场景、帧、弹源、弹龄、坐标、速度分量、速度、方向、朝向和生命。弹源5/6为灯笼与影子，8为追踪魂。输入和原文件指纹保存在 `sources.json`。

```sh
python3 tools/th37-tests/oracle/soul/generate.py --source /Users/happyelements/crack/THMHJ.PartII.Restored
STAGE_STRICT_NEW=1 luajit tools/th37-tests/check_soul.lua
```

重新生成需要 .NET SDK 9或更高版本、Python和pycryptodome；普通对照检查只需要LuaJIT。检查重放同一组原作自机输入，比较全部3655个魂坐标，限制位置误差在0.05像素内，并核对速度阶段、生命和对象存在时间。该误差限容纳追踪魂在接近目标时对浮点微差的放大，不等于宣称整作逐位相同。
