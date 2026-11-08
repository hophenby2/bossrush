-- 当前版本只开放 roguelike 模式；保留旧模块，方便后续恢复功能。
-- 关闭续玩点后仍保留录像所需的随机数与逻辑时钟规则，不再收集续玩输入或读写检查点。
GameFeatures = {
    achievements = false,
    coop = false,
    saveSync = false,
    resume = false,
}
