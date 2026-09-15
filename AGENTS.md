# AGENTS.md

给在这个仓库里写代码的 AI 助手看的说明书。人也可以看。

---

## 1. 这是什么

**Boss Rush HD** —— 基于 **LuaSTG Sub 0.21.129** 的中文东方同人弹幕游戏。
把官方各作的 Boss 战串成一整个长流程，每关一个 Boss 组，外加若干自制关卡。

- 本目录是**游戏发行目录**（引擎 exe + Lua 脚本 + 素材），不是引擎源码工程
- 引擎 C++ 源码在隔壁 **`../LuaSTG-Sub`**（同版本），查引擎行为/API 真相时去那里找，
  比如回收规则就在 `LuaSTG/LuaSTG/GameObject/GameObject.hpp`
- 远端：`github.com/hophenby2/bossrush`

**语言**：Lua 5.1 语义（引擎内嵌 LuaJIT）。**注释、卡名、文档一律用中文**，与现有代码一致。

---

## 2. 硬约束（先读这段）

| 事实 | 含义 |
|---|---|
| **没有构建步骤** | Lua 是引擎解释执行的，改完脚本直接生效，没有编译/打包 |
| **本机跑不起游戏** | `LuaSTGSub.exe` 是 Windows 的，macOS 上没有构建产物。**别假设你能"跑一下看看"** |
| **没有 `.dat` 资源包** | `launch` 会优先加载 `mod.dat`/`core.dat`/`res.dat`/`shader.dat`；当前都不存在，所以散装文件直接生效。**若哪天出现了 `.dat`，它会盖住散装文件**，改脚本前先确认 |
| **别动 `User/`、`replay/`** | 玩家存档与录像，已在 `.gitignore` 里忽略 |
| **改动要能被验证** | 见第 8 节。跑不起游戏不代表可以不验证 |

---

## 3. 目录地图

```
core.lua              入口回调：GameInit / GameExit，STAGE_COUNT / SYSTEM_COUNT 也在这
launch.lua            引擎启动 + 全局注入（把 lstg.* 全灌进 _G）+ 按键常量
launcher.lua          启动器的 UI（setting.mod == 'launcher' 时走这条路）
manual               游戏内说明书（纯文本）

mod/
  root.lua            载入 THlib 与 _editor_output
  _editor_output.lua  ★ 编辑器产物总汇：_editor_class/_editor_boss 的建立、
                        StageID 关卡载入列表、Create.* 弹幕工厂、WhiteScreen、stage_pic 纹理
  main_stage.lua      ★ 所有关卡组的注册（NewStage(...)）与关卡流程
  music.lua           AddMusic(...)（BGM 的循环点与曲名）
  defachievement.lua  DefineAchievement(id, ...)
  BG/TH<id>/TH<id>_bg.lua   关卡背景类（全局 TH<id>_bg）
  GAME/th<id>.lua     ★ 关卡内容：_editor_class["THxx"]、boss.Define、符卡
  th16AEX/            天空璋 AfterExtra，自成一套（关卡号 = STAGE_COUNT + 1）

THlib/                游戏框架（"Touhou style library"），一般不用改
  lib/      底层：Lobject(Class/object) LObjectEvents(对象方法) Ltask(协程/移动)
            Lresources(资源与 SetImageState) Lscreen(世界/摄像机) Lmath(全局数学) ...
  enemy/    ★ boss.lua(Define/Create/CreateGroup) boss_card.lua(New/add) boss_system.lua(状态机)
  bullet/   bullet.lua + bulletStyle.lua（全部弹样式与贴图名都在这）
  laser/    laser.lua（直线光）/ bent laser.lua（曲线光，别名 bent_laser）
  background/  background.lua(基类) spellcard.lua(_SC_BG 符卡背景基类)
  player/ item/ sp/ ext/ misc/ UI/

Resources/            引擎按目录自动扫的素材（见第 7 节）
music/*.ogg           BGM，文件名必须等于 AddMusic 的 id
tools/check_stage.lua 静态自检工具（不是游戏的一部分，引擎不会载入）
```

---

## 4. 载入顺序

```
core.lua: GameInit()
  └─ Include 'mod\root.lua'
       ├─ Include 'THlib\THlib.lua'        （全局框架、LoadRes = {}）
       └─ Include 'mod\_editor_output.lua'
            ├─ 立刻执行：建 _editor_class / _editor_boss、WhiteScreen、Create.*、
            │            读 StageID 列表……
            └─ 其余全部走 IncludeLuaFile → 塞进 LoadRes **延后执行**：
                 mod/BG/TH<id>/…_bg.lua → mod/GAME/th<id>.lua （每个 id 先 BG 后 GAME）
                 mod/main_stage.lua、mod/summary.lua、mod/th16AEX/root.lua

  STAGE_COUNT = 23、InitAllClass() …… （注意：在 Include 'mod\root.lua' **之后**）

稍后（进游戏、载入画面时）
  THlib/UI/loading.lua 的 LoadingImage() 才真正执行 LoadRes
```

两个容易踩的点：

- `IncludeLuaFile` 只在 `GlobalAddAchievement` 为真时立即执行（那个标志在
  `THlib/UI/title.lua:20` 才置真），所以正常情况下上面那些文件**都是延后载入的**。
  这也意味着「在文件顶层读 `STAGE_COUNT`」是安全的——等你被载入时它已经赋好值了。
- `LoadRes` 是用 `pairs` 遍历的。它是个稠密数组，实践中顺序稳定，所以
  「BG 先于 GAME」成立——这是**约定**，别依赖得更细。

---

## 5. 写一段新弹幕：两套接口

### 5.1 Boss / 符卡

```lua
-- 注册一个 boss（THlib/enemy/boss.lua）
boss.Define(editname, name, BGM, BG, {x, y}, SCBG, img, level[, scale])
--   editname  "1a"（字母后缀不能省）      name   "西行寺幽幽子"
--   BGM       "TH03_0"                  BG     TH03_bg（全局背景类）
--   SCBG      class["SCBG1"]（符卡背景，**允许为 nil**）
--   img       "Yuyuko"（行走图，必须是 THlib/BossImageList.lua 里的键）
--   level     23（= 关卡号；注册键是 editname..level，即 "1a23"）

-- 造一张符卡（THlib/enemy/boss_card.lua:57）
local card = boss.card.New(name, t1, t2, t3, hp[, drop, is_extra])
--   t1/t2/t3 单位是**秒**（内部 ×60 存成帧）：
--     t1 = 无敌时间（打不动）  t2 = 防御时间（伤害线性爬升）  t3 = 总时限
--   强制 t1 <= t2 <= t3；t1 == t3 就是「耐久符卡」（伤害恒 0）
--   name 传空串 "" → 这是**非符**（is_sc = false）

-- 挂到 boss 上（THlib/enemy/boss_card.lua:112）
boss.card.add({ { card, "1a" } }, level, CardName, data_id[, OD, inotherstage])
--   {card, bossID} 组：双 boss 同一张符卡就写两组
--   data_id  符卡历史的槽位号（spell_card_data 的键），**跨关卡全局唯一**
--   OD       填了就变成「只能在符卡练习里打」的隐藏卡，不进 BOSS.cards

-- 关卡里生成（mod/main_stage.lua 的关卡任务中）
boss.CreateGroup(group, level)   -- 依次 Create "…a"/"…b"/…，字母必须从 a 起连续
```

符卡的生命周期（`THlib/enemy/boss_system.lua:918`）：

```
before(boss) → castcard → setStatus(HP/计时) → init(boss) → frame(boss) × N → del(boss)
```

**卡里的 `self` 是 boss 本身，不是卡对象**（卡只是被挂到 boss 上的行为表）。
所以 `self.x/self.y/self.ani/self.timer/self.colli/self._wisys/_bosssys` 都是 boss 的。
写 `function card:init()` 就等于写 `function card.init(boss)`。

⚠️ `self.ani` / `self.timer` 是 **boss 从出生算起**的总帧数，不是"本张卡的第几帧"。
卡里要做随时间收窄/加速的效果，得自己在 `init` 里开个计数器，别用 `ani`。

### 5.2 弹 / 对象 / 激光

```lua
-- 最常见的直线弹（THlib/bullet/bullet.lua:287）
NewSimpleBullet(style, color, x, y, v, a[, aim, omiga, stay, destroyable])
--   style 必须是**弹样式对象**（ball_mid / knife / butterfly / ellipse …），不是字符串
--   color 1..16（COLOR.RED=2 等）；butterfly/music 只有 8 色
--   stay = false 表示"一出膛就走"；不传会先原地悬停约 11 帧（弹幕常见的"浮现"手感）

-- 自定义运动：继承 bullet，在自己的 frame 里算位置
local my_bullet = Class(bullet, {
    init = function(self, style, col, x, y, a, path)
        bullet.init(self, style, col, false, true)
        self.x, self.y, self.rot = x, y, a or 0
        self.path, self.bound = path, false      -- 关掉引擎回收 → 必须自己回收
    end,
    frame = function(self)
        bullet.frame(self)
        if self.timer > 300 then object.RawDel(self) return end
        self.path(self, self.timer)
    end,
    render = function(self) bullet.render(self) end,
})

-- 纯演出（无判定）：直接继承 object，自己在 frame 里动、自己 RawDel
-- 光束：laser（直线）/ bent_laser（曲线，别名 bent）
-- 自绘：SetImageState("white", "mul+add", a, r, g, b) + Render("white", x, y, rot, h, v)
```

---

## 6. 房屋风格（照 `mod/GAME/th01.lua` 写）

作者的自制关卡有一套很统一的写法，**新代码请沿用**：

- 文件头一段注释说明这一关/这张卡想做什么
- `local class = {}` + `_editor_class["THxx"] = class`，所有自定义类都放 `class["..."]`
- 文件顶部把要用的全局抓成本地（`local task, object, bullet = task, object, bullet`）——
  既能防手滑写错名，也快一点
- **每张符卡一个 `do … end` 块**，块的**最上面**集中放这一卡的常量（数值、节奏、速度），
  下面才是逻辑。改手感只动那一段
- 需要复杂运动的弹走「路径弹」子类，不用协程；演出控制器是挂在 boss 上的 object 子类，
  `card:del` 里 `object.RawDel` 掉
- **注释写"为什么"**，不写"是什么"。现有代码里大段中文注释解释设计意图，请保持

参数别用魔数随手写。`th01.lua` / `th02.lua` / `th03.lua` 是最好的模板。

想要**合乎第 10 节量化规范**的样板，看 **`mod/GAME/th04.lua`**：它每张卡块的注释里直接写了
`[限位/缺口/容错/预警]` 四个数，可以直接照抄这个格式。

---

## 7. 坑（都是踩过并验证过的）

**① `bound` 是「离开边界自动回收」，不是「限制在边界内」**
`GameObject.hpp:147`。`NewSimpleBullet` 造的弹保持默认 `true`，飞出屏幕引擎自己收；
任何你自己 `Class(object/bullet, …)` 造、又把 `bound` 设成 `false` 的东西，
**必须**在 `frame` 里判寿命/离屏自己 `object.RawDel`，否则会一直漏对象。

**② `SetImageState` 只能用在"登记过的图"上**
它内部查一张 `ImageColor` 表（`THlib/lib/Lresources.lua`），表项只由游戏侧的
`LoadImage`/`LoadImageGroup*`/`LoadImageFromFile` 建立。用了别处（比如激光内部换的
`ball_mid_b*`）的图名会直接崩。**安全来源**：
`THlib/bullet/bulletStyle.lua` 里的全部弹样式图、`Resources/Special/` 下的图、
以及 `white` / `moon` / `circle_charge` 这类已登记的引擎图。

**③ 素材目录是**按文件名自动扫的**（`THlib/UI/loading.lua:12-14`）

| 目录 | 加载方式 | 名字怎么来 |
|---|---|---|
| `Resources/BossBackGround/*.png` | 纹理 | 去掉扩展名的文件名，如 `th03_0` |
| `Resources/BossImage/*.png` | 纹理 | 同上 |
| `Resources/Special/*.png` | 图像（可 `SetImageState`/`Render`） | 同上，如 `fan`、`servant`、`moon` |
| `music/*.ogg` | BGM | 文件名必须等于 `AddMusic` 的 id |

所以**符卡背景**是这么来的：往 `Resources/BossBackGround/th03_0.png` 丢一张图，
然后在 `SCBG` 里 `_SC_BG.AddLayer(self, "th03_0", …)`。

**④ `STAGE_COUNT` 和天空璋AEX 是联动的**
`mod/th16AEX/class.lua:6` 与 `stage.lua:19` 用 `STAGE_COUNT + 1` 当自己的关卡号。
加一关就要 `STAGE_COUNT += 1`，AEX 整体平移一位。**两边都从同一个全局取值，所以是自洽的**——
但千万别在别处硬编码 AEX 的关卡号。

**⑤ 符卡练习菜单的下标 = 关卡号**
`THlib/UI/UI.lua` 的 `difftext` 被 `scpr_menu.lua:22,37` 按 `ipairs` 当下标去取
`_sc_pr_table[t]`。**下标必须等于 level**，否则会把某关的卡挂在别的标题下面。
新开一关记得同步补 `difftext`（和 `sntext` 的显示名）。

**⑥ `boss.CreateGroup` 的字母必须从 `a` 起连续**
它从 `"a"` 开始往后找 `_editor_boss[group..letter..level]`，遇到第一个不存在的就停。

**⑦ 别在 `object.BulletDo` 的遍历里删对象**
遍历中途 `RawDel` 会跳过一格。要删就攒到表里，遍历结束后统一删
（`mod/GAME/th03.lua` 的「樱吹雪」就是这么做的）。

---

## 8. 加一个新关卡（9 个地方，缺一个都不行）

以 `TH03`(level 23) 为例，照 `git show 5010471`（th01&th02 那次提交）的清单来：

1. `mod/GAME/th03.lua` —— 关卡内容
2. `mod/BG/TH03/TH03_bg.lua` —— 全局 `TH03_bg = Class(background)`
3. `Resources/BossBackGround/th03_0.png` —— 符卡背景贴图（256×256）
4. `mod/GAME/stage_pic23.png` —— 关卡选择缩略图（**文件名是 level，不是关卡名**）
5. `music/TH03_0.ogg` —— BGM（现有自制关卡都是复制 `SCORE.ogg` 占位）
6. `core.lua` —— `STAGE_COUNT = 23`
7. `mod/_editor_output.lua` —— `StageID` 列表加 `"03"`；`stage_pic` 加载循环上界改 23
8. `mod/main_stage.lua` —— `NewStage("TH03", "白玉楼", 23, …)`，别忘了 `self:Next(<成就 id>)`
9. `mod/music.lua` 的 `AddMusic` 与 `mod/defachievement.lua` 的 `DefineAchievement`

另外见第 7 节的 ④⑤：`STAGE_COUNT`、`difftext`/`sntext` 要一起动。

**当前的关卡号占用**（加新关时接着往后排，别插空）：

```
1..19   官方各作（TH06…TH185）
20..24  自制    TH00 未命名关卡 · TH01 水月 · TH02 星河 · TH03 白玉楼 · TH04 彼岸
25      天空璋AEX（= STAGE_COUNT + 1，永远跟在最后）
```

符卡 id（`boss.card.add` 第 4 参）同理：自制关卡占了 **244~285**，官方占 1~243，
新关从 **286** 往后排。`tools/check_stage.lua` 会检查有没有跨组重号。

---

## 9. 验证：跑不起游戏时怎么做

```bash
# 语法（用 luajit，它是 5.1 兼容；别用 homebrew 的 luac，那是 5.4，会报假错）
luajit -e 'assert(loadfile("mod/GAME/th03.lua"))'

# ★ 符卡自检：真跑一遍载入，并逐帧模拟每张卡
luajit tools/check_stage.lua mod/GAME/th03.lua          # 默认模拟 1800 帧
luajit tools/check_stage.lua mod/GAME/th03.lua 4000     # 想跑久一点
STAGE_DEBUG=1 luajit tools/check_stage.lua mod/GAME/th03.lua   # 打任务/弹数曲线

# ★ 全项目载入自检（有些文件依赖别的文件里的类，单跑会误报，用这个）
luajit tools/check_stage.lua --all
```

`tools/check_stage.lua` 会报告：boss/符卡的注册结果、`t1<=t2<=t3` 是否合法、
card_id 有没有跨组重复、以及**每张卡跑 N 帧有没有运行时错误 + 峰值同屏弹数/对象数**。
峰值弹数是判断"会不会太挤/漏对象"的主要依据（正常卡几百，超过 ~600 要警惕）。

**它查不出来、只能进游戏看的**：贴图名拼错（桩件不渲染）、手感与观感、
引擎侧的被弹/擦弹/结算、以及演出效果。改完请让作者实机过一遍。

---

## 10. 弹幕设计规范（从原版 th06–th185 反推）

把原版 **318 张符卡**量化之后归纳出来的「怎么写一张卡」。写新卡时逐条对照 10.9 的清单。

### 10.1 硬数字底座

先记住这几个数，否则算不出「这个缝够不够躲」：

| 量 | 值 | 出处 |
|---|---|---|
| 玩家速度（低封 / 高封） | **4 / 2 px/帧**（240 / 120 px/s） | `THlib/player/player_system.lua:286-287` |
| 普通场地 | x ∈ [-192,192]，y ∈ [-224,224]（384×448） | `THlib/lib/Lscreen.lua:206` |
| 大屏（`ToBigScreen`） | x ∈ [-320,320]，y ∈ [-240,240]（640×480） | `Lscreen.lua:210-223` |
| 子弹回收边界 | ±224 / ±256（比可视区各外扩 32） | `Lscreen.lua:90` |
| 锁死自机输入 | `player.lock = true`（`card:del` 记得清） | `player_system.lua:294,364` |
| 改写自机速度 | `player.hspeed / lspeed`（`del` 里必须还原） | th09:2155 / 2206 |

**移动预算表**——判断容错时间够不够的唯一尺子：

```
全屏横穿 384px → 96 帧 (1.6s)      半屏 192px → 48 帧 (0.8s)
70px 通道      → 17.5 帧           32px 缺口  → 8 帧
```

> **设计律**：`转换容错时间 ≥ 玩家要移动的距离 ÷ 4`，再留 2~3 倍余量。
> 推论：容错时间 < 96 帧的卡**不能**要求玩家跨全屏换位，只能要求就地微调。

> **⚠ 回收边界陷阱（写限位墙时必踩）**：引擎回收用的 `boundl/r = ±224`、`boundb/t = ±256`，
> **比可视区（±192 / ±224）各外扩 32**。任何从这之外生成、又没把 `bound` 关掉的东西，
> 会在**生成的那一帧**就被收掉。
> 典型翻车：想围一圈而把墙画在「以 boss 为圆心、半径 260」的圆上 —— 超出边界的
> 那一半当场消失，缺口逻辑全废，而同屏弹数看起来还很"轻"，看不出是坏了。
> 围场要用**四边内向墙**（半宽 ≤ 216、半高 ≤ 250，都在边界内侧），别用圆环：
> 场地 384×448 是竖长的，圆环本来就围不住它。

### 10.2 卡片参数惯例

| 项 | 惯例 |
|---|---|
| `t1` 无敌 | **几乎恒为 1 秒**（218/318）。`t1=60` 的 29 张是全程无敌的**纯演出卡** |
| `t2` 防御 | `1`（最常见）或 `2`（约 20 张）；`t2>t1` = 多给 1 秒伤害渐入 |
| `t3` 时限 | **60 秒**绝对主流（176 张），其次 80 / 45 / 70 / 30 |
| `hp` | 中位 **750**；道中 400~550，标准符卡 700~900，多 boss 公共血 1200~1500 |
| 最常用组合 | `(1,1,60)`×75 · `(1,2,60)`×33 · `(1,1,80)`×30 · `(60,60,60)`×29 · `(1,1,45)`×18 |
| 耐久卡 `t1==t3` | 57 张，伤害恒 0；结束靠脚本自己 `self.hp = 0` |

自制关卡（th00–th03）的 `hp 1400~2000` 属于偏高一档，新卡建议回到 700~900。

### 10.3 展开：层数与时间

- **并行层数**：一张卡的 `init` 里通常有 **2~4 个独立 `task.New` 循环**（中位 3、众数 2）。
  这就是「双展开」的基本形态——**限位一层、实弹一层**，两层只通过 boss 坐标隐式耦合。
- **展开时间**：`init` 第一个 `task.Wait` 通常是 **60 帧（1 秒）**（149/313）；长演出卡 120~180 帧。
- **`before()` 只做进场走位**：297 处 `task.MoveTo`，43 处 `show_aura`，15 处 `self.colli = false`。

### 10.4 限位（把玩家关起来）的五个强度层级

| 级 | 手法 | 项目里的例子 |
|---|---|---|
| 1 硬改坐标 | `player.x/y` 直接赋值或累加 | th095:657（切向甩动）、th125:449（下压推挤）、th08-boss_lastword:1552（夹框） |
| 2 改自机属性 | 速度腰斩 / `player.lock` | th09:2155（毒区 `hspeed 4→2`）、th14:267（冰冻锁输入） |
| 3 实体墙 | 激光列 / 幕布 / 扫描线铺满全屏 | th10:445（13 列激光）、th125:426（9 道下压幕布）、th125:319（16px 网格扫描） |
| 4 轨道定义判定区 | 只在某个圆环/区域里才有 `colli` | th12:1453（10 个旋转圆环）、th13:165（8px 厚反射板） |
| 5 借 boss 当基准 | 用 boss（或另一个 boss）的坐标当分界线 | th128:176（以另一个 boss 的 y 为明暗分界） |

**限位墙的标准做法 = 高密度环 + 挖掉一个扇区。** 原版里 `AngleIterator(a, 360)` 出现 **89 次**——
那是「铺满一整圈再删掉一格」的写法；也可以直接少扫一段弧（th11_2「井网」86 颗只扫 324°，留 36°）。
安全扇区再按固定节拍搬家（见下表）。

### 10.5 限位流程与转换容错时间（实测量）

| 卡 | 出处 | 限位几何 | 缺口 | **转换容错时间** |
|---|---|---|---|---|
| th11_2 井网「满布蛛网之天」 | `th11_2.lua:1184-1189` | 向心汇聚的辐条墙，10 个 36° 扇区 | **36°** | **70 帧**——缺口每 70 帧跳一格；整圈还以 0.6°/帧自转 |
| th10 「御柱祭-寒水豪血」 | `th10.lua:1339-1348, 1377-1383` | 13 根激光列 `x=i*32-192`，其中一根 `colli=false` | **32 px** | **360 帧**（前期，换安全列）；后期随机掩码缩到 100 帧 |
| th125 「乾坤…大地啊」 | `th125.lua:1026-1032, 426-451` | 9 道 480px 高幕布，间距 70px，每道吃 ±34px | **≈2 px**（等于没有） | **190 帧**——幕布静止期；之后以 5 px/帧下压，玩家只能跟着走 |
| th13 「合力「彩虹音爆」」 | `th13.lua:716-723` | 从屏幕边缘推进的 616 颗彩虹墙 | 无 | **352 帧**——墙铺满屏幕的耗时 |
| th095 「热浪「地狱之轮回」」 | `th095.lua:656-662` | 不做墙，直接给自机加切向速度 0.8·sin | 无 | **300 帧**——外力每 300 帧反向一次，反转瞬间是唯一自由窗口 |
| th12 「血バサミ女の観覧车」 | `th12.lua:1410-1420, 1448-1466` | 4+6 个旋转圆环，**只在环内才有 `colli`** | — | 圆环 0.6 / −0.3 °/帧自转；对齐线每 720 帧转一圈 |
| th125 「鬼符「鬼气上身」」 | `th125.lua:876-879, 319-345` | 两块 servant 以 16 px/帧横扫，沿途撒 16px 网格 | 保底安全泡 r=50 | **30 帧**——扫线用 30 帧走完全高 480px |
| th09 「毒风「夜中飘毒香」」 | `th09.lua:2146-2159` | 毒弹周围 70px 内自机速度腰斩 | 减速泡 r=70 | **20 帧**（狂暴档毒弹间隔） |

规律很干净：**容错时间 / (需移动距离÷4) ≈ 2~4 倍**。少于 100 帧的卡一定是「就地微调」而非「换位」。

### 10.6 限位区内的弹幕：速度与操作频率

**弹速**（`NewSimpleBullet` 的第 5 个参数，实测中位数）：

| 弹型 | 中位 v | 范围 |
|---|---|---|
| `ball_mid` / `ball_big` / `square` / `grain_a` | **2.0** | 0~8 |
| `knife` | 2.5 | 0.6~8 |
| `ball_huge` | 3.0 | 0.1~5 |
| `ball_light` / `ball_mid_c` | 1.0~1.8 | 0~6 |

**主区间 1.0~3.0**；4~5 只给收尾或单发噱头；≥6 的必须配硬限位，否则是纯运气。

**环的路数**（实测常用值）：`12 / 15 / 18 / 20 / 24 / 30 / 36 / 40`；
「墙」则用 120~360 路再挖缺口。

**操作频率**（= 相邻两波之间玩家必须做一次新决策的间隔）：

| 间隔 | 体感 |
|---|---|
| 2~6 帧 | 纯压迫，只适合做背景帘幕 |
| 10~20 帧 | 紧张（th165 的 OD 卡 120 帧走廊 / 狂暴档） |
| **20~100 帧** | **舒适区**，绝大多数卡的实弹层都在这里 |
| 100~360 帧 | 只用来做「限位换位」的窗口 |

> **⚠ 这一档最容易写坏**：把「背景帘幕」的间隔（2~6 帧）当成**主弹幕**用，
> 结果就是持续几十秒的噪声微操 —— 玩家读不出轨迹、没有决策点，只有纯消耗。
> 规则：**主弹幕的间隔不要低于 20 帧**；帘幕类如果要发得很密，就让它无判定
> （`GROUP.GHOST` / `colli = false`）当纯演出。
> 另外别给花瓣之类的东西加随机自转（`omiga`）——自转会毁掉轨迹的可读性。

**子弹样式频次**（318 张卡合计）：`ball_mid` 113 · `ball_big` 102 · `grain_a` 89 · `square` 58 ·
`ball_huge` 55 · `grain_b` 55 · `ball_mid_c` 47 · `ball_light` 45 · `ellipse` 36 · `arrow_*` 66。
即：**光玉 + 米弹打底，`knife`/`butterfly`/`arrow_*` 这类有方向感的留给大招收尾**。

### 10.7 预警层（硬性惯例，别省）

限位生效前**一定**有一段可见预告，实测 **90~360 帧**：

- th125：9 颗 `ball_light` 逐帧描出每道幕布的落点（90 帧，`th125.lua:1027-1032`）
- th10：8 条弯折激光先指向安全列，181 帧后 13 列才落下（`th10.lua:1339,1377`）
- th13：彩虹墙自己铺 352 帧，铺的过程就是预警
- th13 天平：`RenderRect` 在屏幕上下各画 84px 高的红带，标出「秤砣会荡到这里」

**做法**：把限位的第一层单独做成「只画不判」（`colli = false` 或纯 `Render`），持续 60~190 帧，
再让它变成实体。

### 10.8 光效词汇表

| 原语 | 用量 | 用在哪 |
|---|---|---|
| `Newcharge_in(x, y, r, g, b)` | **239** | 每轮展开前的聚气；几乎每张卡都有 |
| `boss.cast(self, 帧数)` | **199** | 符卡宣言姿态；展开点、阶段切换点 |
| `Newcharge_out(x, y, r, g, b)` | **149** | 展开完成的爆闪 |
| `_object.set_color(self, "", a, r, g, b)` | 79 | 灰化 = 无敌；染色 = 状态切换（th14 冰冻把**自机**染成天蓝） |
| `boss.show_aura(self, bool)` | 78 | 开关 boss 光环 |
| `NewText(...)` | 43 | 弹幕解说文字（th08 lastword 大量用） |
| `ToBigScreen(帧数)` | 21 | 推镜到 640×480；**只在大招/终符用** |
| `New(WhiteScreen, ...)` | 17 | 全屏白闪，配瞬移或阶段切换 |
| `bullet_cleaner(x, y, r, t1, t2)` | 7 | 清弹器，阶段切换时扫场 |

**惯例三件套**：`before()` 走位 → `init` 先 `Wait(60)` 再 `Newcharge_in` 起手 →
每个展开点 `boss.cast` + `Newcharge_out`。**灰化 + `self.colli = false` = 「这段是演出，别打」的通用信号。**

### 10.9 写卡自检清单

写一张新卡时逐条过：

1. 参数是 `(1,1,60)` 档吗？hp 在 700~900 吗？（演出卡才用 `(60,60,60)`）
2. `init` 里有 **2~4 个并行循环**吗？其中至少一层是限位、一层是实弹吗？
3. 限位用的是五级里的哪一级？**为什么不用更轻的那一级？**
4. **转换容错时间**是多少帧？它 ≥ 「要移动的距离 ÷ 4」×2 吗？
5. 窄缝有 **32 px** 以上吗？没有的话玩家凭什么过去？
6. 限位生效前有 **60~190 帧的可见预警**吗？
7. 实弹速度在 **1.0~3.0** 吗？操作频率落在 **20~100 帧**吗？
8. 光效三件套齐了吗？阶段变化有没有用灰化/染色说清楚？
9. 用 `luajit tools/check_stage.lua` 跑过吗？峰值同屏弹数没爆吗？
10. 收尾干净吗？`del` 里把挂上去的对象、改过的 `player` 属性都还原了吗？

---

## 11. 速查

| 想做的事 | 用什么 |
|---|---|
| 造直线弹 | `NewSimpleBullet(style, col, x, y, v, a[, aim, omiga, stay, destroyable])` |
| 造自定义轨迹弹 | `Class(bullet, {...})` + 自己的 `frame`，`bound=false` 并自己回收 |
| 造纯演出物件 | `Class(object, {...}, true)`，`card:del` 里清掉 |
| 弹样式名 / 颜色 | `THlib/bullet/bulletStyle.lua`；`COLOR.*` 1..16 |
| 挂机移动 | `task.MoveTo(x,y,t,mode)`、`task.MoveToPlayer(...)`、`task.CRMoveTo(t,mode,…)` |
| 并行发弹循环 | `task.New(self, function() while true do … task.Wait(n) end end)` |
| 血量驱动的多阶段 | `self._bosssys:addAutoSPPoint(掉血量, 兜底帧, true)` + 读 `self._sp_point_auto` |
| 圆形/星形/椭圆排布 | `sp.math.AngleIterator / EllipseIterator / PolygonIterator / HeartIterator` |
| 画出图形（无判定） | `SetImageState("white", "mul+add", a,r,g,b)` + `Render`/`RenderRect` |
| 自机坐标 | `player.x` / `player.y`（可以直接夹住它做"场地收缩"） |
| 世界边界 | `lstg.world.l/r/b/t`（可视区）、`boundl/r/b/t`（±32 的回收边界） |
