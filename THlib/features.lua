-- 默认开启调试练习；标题口令保留，便于临时关闭后重新开启。
-- 关闭续玩点后仍保留录像所需的随机数与逻辑时钟规则，不再收集续玩输入或读写检查点。
GameFeatures = {
    achievements = false,
    coop = false,
    saveSync = false,
    resume = false,
    updateNotice = false,
}
GameDebug=GameDebug or dofile('THlib/UI/debug_mode.lua')
