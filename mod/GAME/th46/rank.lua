-- 0x0c06c290：每 512 步的时间项、每枚 Bomb 的 4 点、每级火力的 2 点；Original 上限 208。
-- 第一面已核对的偏移为 12。其他事件对偏移及双人取最大值的影响尚待移植。
local floor,min=math.floor,math.min
local function calculate(run,time)
    local state=NativePlayers and NativePlayers.state()
    local bombs,power=state and state.bombs or 3,state and state.power or 0
    return min(208,12+4*bombs+2*power+floor(time/512))
end
return {
    get=function(run) return run.roadRank or calculate(run,run.roadRankTime or run.roadFrame+129) end,
    -- 在自机及碰撞之前锁存本步值；P 道具拾取的贡献从下一逻辑步生效。
    advance=function(run)
        local frame=(run.roadFrame or -1)+1
        run.roadRankTime=(run.roadRankTime or frame+128)+1
        run.roadRank=calculate(run,run.roadRankTime)
    end,
    hit=function(run)
        -- 0x0c06b5fa–0x0c06b608 先右移四位再乘 15，不能写成 floor(T*15/16)。
        run.roadRankTime=15*floor((run.roadRankTime or run.roadFrame+129)/16)
    end,
}
