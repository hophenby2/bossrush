# 雪莲华出生弹雾

`mod/GAME/th38/mist.lua`独立绘制原作`Wuhua`，不修改弹体的速度、缩放、透明度和判定。使用发行包实际加载的8张图集精灵、PixelsPerUnit与pivot，按原120Hz逐tick收缩；首用/复用寿命与500容量来自发行包DLL中的`Wuhua`和`Sincos`。没有使用宿主子弹自带的出生雾化或无敌期。

生成数据及素材：

```sh
python3 tools/th38-tests/export_mist.py --data /Users/happyelements/asl/THasl/THasl_Data
```

导出依赖 UnityPy 和 ilspycmd（默认从 PATH 或 `~/.dotnet/tools/ilspycmd` 查找，也可用 `--ilspycmd` 指定）。发行包保持只读，源文件哈希、资源键、精灵ID、切片区域与中心点记录在`mod/GAME/th38/mist_sources.json`。普通/子发射器的收缩参数分别从同一发行包DLL反编译的`Basic`、`Basic_zi`读取。

发行版`Sincos`调用`Resources.LoadAll<Sprite>("xuelianhua/image/Bullet/wuhua")`。导出器按该资源键筛选并保留精灵顺序，实际切片约为72～74×72像素、PPU为100。重建工程的`Bullet/雾化/wuhua0.png`等128×128散图属于另一套资源，上一版误用了它们，导致外观和显示大小不一致；不能再按同名文件直接复制。

雾化生成位置沿原发射分支处理：半径为零时每次扇形发射只在中心生成一个雾化对象；半径非零时在各发射点生成。使用独立表现列表和单个渲染对象，保留对象池容量；不为每个粒子创建引擎弹体。结束关卡时释放，阶段转换仍沿当前控制器推进。

本次按用户要求未运行测试；这里只记录实现及来源，不作为已验证报告。
