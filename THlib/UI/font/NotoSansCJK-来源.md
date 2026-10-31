本目录的 `NotoSansCJKjp-Bold.otf` 为未修改的 Noto Sans CJK JP Bold 2.004。

来源：[Noto CJK 官方仓库](https://github.com/notofonts/noto-cjk/blob/f8d157532fbfaeda587e826d4cd5b21a49186f7c/Sans/OTF/Japanese/NotoSansCJKjp-Bold.otf)。
许可证为 SIL Open Font License 1.1，全文随包放在 `NotoSansCJK-LICENSE.txt`。

原有 `text.ttf` 是粗黑宋简体，缺少「剣、斬、閃、呪、鳳」等符卡名用字。
`font.lua` 在 Sub 0.21.24 及以上的0.21版本中使用原字体加本字体回退；
随游戏附带的 Sub 0.21.2 和 LuaSTG-x 兼容路径使用本字体直接显示中日文。
0.21.2 的字体组绑定使用 `fonts[i]` 越界，不能通过尝试调用再捕获Lua异常来探测；
修复见隔壁引擎仓库提交 `e1704a920b464ffd6fd715bb9d072110b1c779b4`。

校验：`python tools/check_font_coverage.py`；本机0.21.2引擎已实际渲染验证
「獄神剣『業風神閃斬』」「蝶符『鳳蝶紋の死槍』」等原先缺字的标题。
