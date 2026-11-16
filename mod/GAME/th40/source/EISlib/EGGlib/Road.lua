---=====================================
---与道中设计相关
---author:S7UPID
---email:962131487@qq.com
---=====================================
local M = {}
EGGlib.Road = M
local newSimpleClass = EGGlib.Class.newSimpleClass

--存放小怪组合的类
M.EnemyGroup = newSimpleClass()
do
    local this = M.EnemyGroup
    function this.constructor(self)
        self.enemy_list = {} --敌人表
        self.group_list = {} --敌人组表
    end
    --把一系列的小怪组合起来
    ---@param part_index number 填首次出现的道中片段数
    ---@param key string 识别这种敌人组合的键
    function this.defineCreateGroupFunc(self, part_index, key, func)
        if not self.group_list[part_index] then
            self.group_list[part_index] = {}
        end
        self.group_list[part_index][key] = func
    end
    --定义某一种包含所有特殊行为的小怪
    ---@param part_index number 填首次出现的道中片段数
    ---@param key string 识别这种敌人组合的键
    function this.defineCreateEnemyFunc(self, part_index, key, func)
        if not self.enemy_list[part_index] then
            self.enemy_list[part_index] = {}
        end
        self.enemy_list[part_index][key] = func
    end
    --获取某种特定的敌人
    function this.getCreateEnemyFunc(self, part_index, key)
        if not self.enemy_list[part_index] then
            error("未定义道中第"..part_index.."段的敌人")
        elseif not self.enemy_list[part_index][key] then
            error("无法找到道中第"..part_index.."段的敌人："..key)
        end
        return self.enemy_list[part_index][key]
    end
    --获取某种特定的敌人组合
    function this.getCreateGroupFunc(self, part_index, key)
        if not self.group_list[part_index] then
            error("未定义道中第"..part_index.."段的敌人组合")
        elseif not self.group_list[part_index][key] then
            error("无法找到道中第"..part_index.."段的敌人组合："..key)
        end
        return self.group_list[part_index][key]
    end
    --使用数据表的方法来初始化敌人表
    function this.initEnemyListByTable(self, list)
        for index, t in pairs(list) do
            self.enemy_list[index] = {}
            for key, func in pairs(t) do
                self:defineCreateEnemyFunc(index, key, func)
            end
        end
    end
    --使用数据表的方法来初始化敌人组合表
    function this.initGroupListByTable(self, list)
        for index, t in pairs(list) do
            self.group_list[index] = {}
            for key, func in pairs(t) do
                self:defineCreateGroupFunc(index, key, func)
            end
        end
    end
end

--region demo
--[[
--开始定义每段的敌人及组合
local s7_enemy_manager = M.EnemyGroup.new()
do
    s7_enemy_manager:initEnemyListByTable({
        --region part1 enemy
        {},
        --endregion
        --region part2 enemy
        {},
        --endregion
        --region part3 enemy
        {},
        --endregion
        --region part4 enemy
        {},
        --endregion
        --region part5 enemy
        {},
        --endregion
        --region part6 enemy
        {},
        --endregion
        --region part7 enemy
        {}
        --endregion
    })
    s7_enemy_manager:initGroupListByTable({
        --region part1 group
        {},
        --endregion
        --region part2 group
        {},
        --endregion
        --region part3 group
        {},
        --endregion
        --region part4 group
        {},
        --endregion
        --region part5 group
        {},
        --endregion
        --region part6 group
        {},
        --endregion
        --region part7 group
        {}
        --endregion
    })
end]]
--endregion

