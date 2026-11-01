# 原作显示资源与验证记录

TH31、TH32、TH33、TH34、TH35 分别对应永夜抄、红魔乡、文花帖、妖妖梦、风神录。
本目录保存从本机原版 DAT 中导出的 ANM 精灵矩形、原始脚本编号与动画指令；
像素保存在 `Resources/Original/8、6、95、7、10`，没有重绘或放大。
`manifest.json` 记录每份源 ANM 的 SHA-256、所在 DAT、精灵数和脚本数。

## 当前接入

- `THlib/anm/original.lua` 播放原作 ANM 时间轴，包括精灵切换、旋转、缩放、颜色、
  透明度、UV 滚动、跳转和中断。旧作使用原始编号映射，不能直接当作数组下标。
- `THlib/anm/stage_visual.lua` 按作品选择 Boss、使魔、附属动画和符卡背景。
  同名角色不会再借用其他作品的素材；EX/PH 的橙、藍按所在关卡选择资源。
- `THlib/bullet/visual_match.lua` 按原作弹型和原始色号选择贴图，播放出生与主弹动画。
  原作角度在绘制时换算到本项目向上的 Y 轴；逻辑角不会被贴图旋转反写。
- TH31 的红眼、妹红分身与其他发弹对象读取对应 ECL 的动画指令；
  `NO_SPRITE` 禁止绘制本体，不能擅自补一个可见的占位使魔。
- TH32 的二进制 ECL 转译保留 98/99 号姿态、附加动画指令。
- TH33 的誘蛾灯使用原作的一个扇形对象，并在 Boss 下方绘制。
- TH34/TH35 的敌机按原子程序选择动画；TH35 子机有 ANM 指令时才显示本体。
- 风神录主机换卡继承 ANM 槽，新子机使用原作构造器的默认槽；负编号释放附属动画。
  主动画切换到另一份 ANM 时，独立的附属槽仍保留，不能连同法阵一起丢弃。
- 符卡背景使用原作 ANM 的图层、位置、旋转、UV 和淡入；不再叠加框架的通用淡入。

原脚本中仍有历史上的“占位贴图”注释、兼容字段和碰撞样式名。正式原作显示入口
优先读取上述 ANM，不能仅搜索 `img = "servant"` 就判断运行时仍绘制该占位图。

## 导出

本机使用 `E:\workspace\thtkGUI-th20tr\thtk\thtk-th20` 的 `thdat/thanm/thecl`。
原档案位于 `E:\workspace\原作`。导出工具只读取原作，不改动原作档案或存档。

```powershell
python tools/th3x-tests/export_original_anm.py
python tools/th3x-tests/export_visual_ecl.py
```

第二条命令读取 `E:\workspace\.bossrush-validation\original-anm\ecl\7、8、10`
和 `source-assets\th095` 下已由 `thecl -d <版本> -r -x` 得到的声明文件。
它抽取动画与可见性指令，供现有 Lua 弹幕实现使用，并不是完整 ECL 解释器。
原作 TH06 的外置 PNG 与独立 alpha 合并，其他原始 BGRA/16 位纹理转换为 RGBA PNG。

## 验证入口

```powershell
luajit tools/check_original_anm.lua
luajit tools/check_bullet_visuals.lua
luajit tools/check_spell_backgrounds.lua
python tools/th32-tests/program_conformance.py E:\workspace\原作\ECL\th06 --frames 12000
python tools/th3x-tests/native_engine.py --output E:\workspace\.bossrush-validation\visual-complete-timeout --mode timeout --speed 6000
```

原生验证在独立发行目录运行 Windows 引擎，隔离存档与录像；逐卡日志包含实际结束原因、
运行帧数、对象峰值、渲染次数和未映射占位对象。完整覆盖与短时冒烟分开计数。
加速检查与正常速度截图检查也分开记录，避免把逻辑执行通过误写成逐帧画面一致。
资源重载同时覆盖换关和重试：框架会复用 stage 表，不能只按表地址判断资源池是否清空。

全项目 `check_stage.lua --all` 仍报 15 处既存卡 ID 重复（453–460、470–476）。
用 HEAD 的 TH31–TH35 脚本重跑得到相同结果；此次未改动 ID，也没有迁移玩家存档。

2026-11-01 的最终 Windows 引擎记录见
[`verification-original-visual-2026-11-01.json`](../../../tools/th3x-tests/verification-original-visual-2026-11-01.json)：
513 张卡分别完成单卡击破、完整时限、同宿主连续换卡，文花帖 85 场另跑拍中分支；
另有 10 张常速样例、两组截图时点。六个完整批次与常速批次的代码和素材指纹均匹配当前文件，
报告同时保存引擎二进制 SHA-256。上述批次没有运行错误。

本次还通过了原作动画/资源 305 项、弹型/旋转/激光 1,238 项、背景 7 项、
坐标/活动框 354 项、永夜抄受击 84 项、切割等行为 407 项、Rank 49 项和
生命周期/跨卡清场 136 项检查；红魔乡二进制 ECL 对照覆盖 100 段、每段 12,000 帧。
599 张 PNG 的 CRC 与解压尺寸检查通过，战斗 ANM 的 11,030 处固定精灵引用无缺号。

## 尚不能据此宣称完全一致

这里已接入原作像素和主要二维 ANM 行为，但没有完成全量原作引擎复刻：

- 普通关卡的 STD 三维场景、相机和网格仍由现有背景实现；本次替换的是原作符卡背景。
- ANM 的完整三维投影、顶点模式及部分特殊插值尚未逐项实现；X/Y 旋转目前按二维投影处理。
- 动画 ECL 摘录只展开常量调用；条件分支、循环、动态参数与同步调用的完整时钟语义
  还需要和现有手写 Lua 时间轴逐项联接，不能把摘录当作完整 ECL 执行结果。
- 风神录部分旧道中入口只保留了共用工作者函数，原作颜色包装名已丢失；这些入口
  暂用原作蓝色包装。保留了原名的五面、EX 及四面分色子机按原包装取动画。
- 除红魔乡已有的 100 段二进制 ECL 事件对照外，其余四作尚无覆盖所有事件的逐帧轨迹对照。
- 原生引擎跑通证明所测种子、输入与分支下资源、执行和结算可达，不能证明所有随机轨迹
  或原版与移植版的每一帧画面、碰撞、发弹都相等。

这些差异需要继续处理；不能因为换用了原版贴图，便把整套行为标记为完全对齐。
