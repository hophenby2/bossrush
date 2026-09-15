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

## 10. 速查

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
