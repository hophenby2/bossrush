-- 默认只开放 roguelike 模式，标题菜单的调试口令可以临时开放两套练习。
-- 关闭续玩点后仍保留录像所需的随机数与逻辑时钟规则，不再收集续玩输入或读写检查点。
GameFeatures = {
    achievements = false,
    coop = false,
    saveSync = false,
    resume = false,
}
GameDebug=GameDebug or dofile('THlib/UI/debug_mode.lua')
