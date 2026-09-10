local int, max = int, max
local SearchStageLevel = SearchStageLevel

function item:PlayerMiss()
    local var = lstg.var
    var.dead = var.dead + 1
    self.protect = 90
    local b = var.man
    var.man = max(var.man - 30, 0)
    if var.man == 0 and b ~= 0 then
        ext.achievement:get(42)
    end
    if self.name == "Aya" and int(self.photopre / self.preok * 100) == 99 then
        ext.achievement:get(39)
    end--成就
end

function item:_init_item()
    --用于关卡开始时重置各个系统参数
    if lstg.var.is_practice then
        item.PlayerInit()
    else
        if self.number == 1 then
            item.PlayerInit()
        end
    end
end

function item.PlayerInit()
    local var = lstg.var
    -----------------时缓灰色
    var.gray = false
    -----------------死亡数，收卡数，读档数
    var.dead = 0
    var.getsc = 0
    var.saving = 0
    -----------------妖妖梦相关
    var.sakura = 0
    var.ON_sakura = false
    var.sakura_bonus = false
    -----------------永夜抄相关
    var.man = 0
    -----------------花映塚相关
    var.charge = 0
    var.charging = 0
    -----------------风神录相关
    var.faith = 0
    var.faith_maxcount = 0
    -----------------地灵殿相关
    var.grazetimes = 1
    var.grazerevp = 0
    -----------------星莲船相关
    var.UFO = {}
    var.UFO_charging = false
    var.UFO_next = ran:Int(1, 3)
    var.UFO_mode = ran:Int(1, 2)
    -----------------神灵庙相关
    var.astral = 0
    var.blue_combo = 0--连击数到达9时，掉落白灵
    var.blue_time = 60--时间为0时，连击数清空
    var.ON_astral = false
    -----------------辉针城相关
    var.itembar = { red = 0, blue = 0, green = 0 }
    -----------------天空璋相关
    var.season = 0
    var.seasonid = ({ reimu_player = 1, chiruno_player = 2, aya_player = 3, marisa_player = 4 })[GetGlobal("player_name")]
    var.seasoncd = 0
    -----------------鬼形兽相关
    var.beast = {}
    var.beast_charging = false
    var.get_beast_hyper = false
    var.beast_charging_time = 0
    var.max_beast_charging_time = 0
    var.hyper_mode = nil
    -----------------基础数据
    var.power = 400
    var.graze = 0
    var.pointrate = 10000
    -----------------分数数据
    var.score = 0
    var.score_tmp = 0
    var.score_draw = 0
    -----------------其他数据
    var.elapsed = 0
    var.off_getsc = 0--偏移获取符卡数，用于结算
    var.init_player_data = true
    -----------------单篇章游玩数据
    var.lost = false--失败flag
    var.get_part = 0--完成度
end

---对分数进行整十处理
---@return number
function item.TweakScore(s)
    return int(s / 10) * 10
end
local TweakScore = item.TweakScore

function item.PlayerGraze()
    local var = lstg.var
    var.graze = var.graze + 1
    if SearchStageLevel[9] then
    end
    if SearchStageLevel[5] then
        if var.grazetimes >= 3 then
            var.grazetimes = var.grazetimes + 0.0008
            var.grazerevp = -8
        else
            var.grazetimes = var.grazetimes + 0.03
            var.grazerevp = 0
        end
    end
    if SearchStageLevel[2] then
        if var.man < 100 then
            var.man = var.man + 1
        end
    end
    var.score = var.score + TweakScore((var.ON_sakura and 1200 or 200) * var.grazetimes)
end

function item.ClearBossBonus()
    object.EnemyNontjtDo(function(unit)
        if unit.chip_bonus then
            unit.chip_bonus = false
        end
        if unit.bombchip_bonus then
            unit.bombchip_bonus = false
        end
        if unit.sc_bonus then
            unit.sc_bonus = nil
        end
    end)
end