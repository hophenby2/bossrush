# 世界终结「轮回寂灭」的运动接入

对应练习卡号38064，弹幕目录为`L/stage6/boss1/8`。行为来源为雪莲华发行包`THasl_Data/Managed/Assembly-CSharp.dll`中的`Sincos.Zidan_fuzhi`、`Sincos.Yundong_delete`和`Bulletmove.FixedUpdate`；弹幕参数来自同一发行目录的`xuelianhua/danmaku/L/stage6/boss1/8/*.txt`。来源保持只读。

`dam1.txt`和`dam2.txt`的子发射器在发射期间更新全局变量a/b及c/d；原作在每颗子弹出生时将四个变量复制到`Bulletmove.bianliang_a/b/c/d`。子弹在全局541tick开始，用自己的变量快照作为目标坐标，在600tick内按正弦插值移动。移植此前把每颗子弹的变量全部初始化为零，导致这些子弹汇向错误坐标。现改为在出生时复制控制器变量，不与后续发射共享同一个表。

`core0.txt`和`core1.txt`承载两组运动绑定子弹。原作`Sincos.Yundong_delete`在宿主回收时保留普通子弹的世界位置，解除绑定，并将宿主的速度方向加到子弹方向上，使其继续推进自身事件和剩余寿命；非普通弹的子对象销毁。移植此前把宿主消失直接当作子弹死亡，丢失了这段后续运动。现保留宿主最后一次平移和旋转后再按原规则解绑。

以上修正在雪莲华共用后端生效，不用特定卡号覆盖原始发弹参数。按用户要求未运行测试或启动游戏，本文只记录来源与修改。
