# 雪莲华出生弹雾

`mod/GAME/th38/mist.lua`独立绘制原作`Wuhua`，不修改弹体的速度、缩放、透明度和判定。使用原8张贴图、PixelsPerUnit与pivot，按原120Hz逐tick收缩；首用/复用寿命与500容量来自`Wuhua.cs`和`Sincos.cs`。没有使用宿主子弹自带的出生雾化或无敌期。

生成数据及素材：

```sh
python3 tools/th38-tests/export_mist.py --source /Users/happyelements/asl
```

原图和元数据保持只读，哈希记录在`mod/GAME/th38/mist_sources.json`。普通/子发射器的收缩参数分别从`Basic.cs`、`Basic_zi.cs`读取。

雾化生成位置沿原发射分支处理：半径为零时每次扇形发射只在中心生成一个雾化对象；半径非零时在各发射点生成。使用独立表现列表和单个渲染对象，保留对象池容量；不为每个粒子创建引擎弹体。结束关卡时释放，阶段转换仍沿当前控制器推进。

本次按用户要求未运行测试；这里只记录实现及来源，不作为已验证报告。
