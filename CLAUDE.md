# CLAUDE.md

**本仓库的开发说明以 [`AGENTS.md`](AGENTS.md) 为唯一事实来源，请先完整读一遍。**

那份文档覆盖：项目定位与硬约束、目录地图、载入顺序、Boss/符卡的编写接口、
房屋风格、踩过的坑、加新关卡的清单、以及验证方式。这里只重复三条最容易出事的：

1. **没有构建步骤**——Lua 由引擎解释执行，改完直接生效。
2. **本机跑不起游戏**（引擎是 Windows 的 `LuaSTGSub.exe`，macOS 上没有构建产物）。
   改完必须用静态自检代替：
   ```bash
   luajit tools/check_stage.lua mod/GAME/th04.lua     # 单关：注册检查 + 逐卡逐帧模拟
   luajit tools/check_stage.lua --all                 # 全项目：按引擎顺序载入检查
   ```
   用 `luajit`（5.1 语义），**别用 homebrew 的 `luac`**（那是 5.4，会把 5.1 风格的代码报成假错）。
3. **注释、卡名、文档一律用中文**，与现有代码一致。

改动 `core.lua` 的 `STAGE_COUNT`、`mod/_editor_output.lua` 的 `StageID`、
`THlib/UI/UI.lua` 的 `difftext` 之前，先看 `AGENTS.md` 第 7 节 ④⑤ 和第 8 节——
这几处是联动的，动一处要跟着动其余几处。
