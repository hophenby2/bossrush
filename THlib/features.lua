-- 安卓默认关闭调试入口，标题版本号连点五次开启；桌面沿用默认开启。
-- 关闭续玩点后仍保留录像所需的随机数与逻辑时钟规则，不再收集续玩输入或读写检查点。
GameFeatures = {
    achievements = false,
    coop = false,
    saveSync = false,
    resume = false,
    updateNotice = false,
}
GameDebug=GameDebug or dofile('THlib/UI/debug_mode.lua')
