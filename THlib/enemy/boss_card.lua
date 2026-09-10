---boss 符卡
local boss = boss
local Card = {}
boss.card = Card

local default = function()
end
local task = task
---对二人非符的处理
local non = {}
boss.ns_group = non
function non:init()
    self.another = self.otherboss[1] or nil
end
function non:del()
    self.next = true
    if self.another then
        self.another.otherboss = {}
    end
end
function non:nextcard(x, y)
    local b
    if self.another then
        if not (self.another.next and self.next) then
            task.New(self, function()
                b = true
                boss.show_aura(self, false)
                boss.SetUIDisplay(self, false, false, false, false, false)
                task.Wait(60)
                task.MoveTo(x or 300, y or 100, 60, 2)
            end)
        end
        while not self.another.next do
            task.Wait()
        end
        if not self.otherboss[1] then
            self.otherboss[1] = self.another or nil
        end
    end
    task.Clear(self, true)
    if b then
        boss.SetUIDisplay(self, true, true, true, true, true)
        boss.show_aura(self, true)
    end
end

---创建一个符卡
---不填参数默认为60秒的时非
---@param name @符卡名
---@param t1 number @无敌时间
---@param t2 number @防御时间
---@param t3 number @总时间
---@param hp number @最大生命值
---@param drop table @掉落物
---@param is_extra boolean @是否免疫自机符卡
---@return boss.card|boss
function Card.New(name, t1, t2, t3, hp, drop, is_extra)
    name = name or ""
    t1 = t1 or 60
    t2 = t2 or 60
    t3 = t3 or 60
    if t1 > t2 or t2 > t3 then
        error('t1<=t2<=t3 must be satisfied.')
    end
    ---@class boss.card
    local c = { before = default, init = default, frame = default, render = default, del = default }
    c.name = tostring(name)

    c.t1 = int(t1 * 60)
    c.t2 = int(t2 * 60)
    c.t3 = int(t3 * 60)
    c.hp = hp or 600
    c.is_sc = (c.name ~= '')
    c.drop = drop or { 0, 0, 0 }
    c.is_extra = is_extra or false
    c.is_combat = true
    return c
end

---快速增加一个(逃跑)事件，在关卡中会体现
---@param bossID string
---@param level number
---@param func fun(self:boss)
function Card.addRunEvent(bossID, level, func)
    local BOSS = _editor_boss[bossID .. level]
    local sc = Card.New("", 60, 60, 60, 600)
    sc.before = function(self)
        self.colli = false
        self.ui.drawtime = false
        func(self)
        Del(self)
    end
    table.insert(BOSS.cards, sc)
end

---多boss血条联通
---用在frame里
function Card:PublicHP()
    local t = {}
    for _, b in ipairs(boss_group) do
        if b.is_combat then
            table.insert(t, b.hp)
        end
    end
    self.hp = min(math.huge, unpack(t))
end

---@param sc_group table<boss.card, string>@符卡组{{card单元, bossID } , ...}
---@param level string@所在的关卡级
---@param CardName string@显示的卡名
---@param OD number@只能在符卡练习中挑战，请写下对应的解锁id(请务必按顺序)
function Card.add(sc_group, level, CardName, data_id, OD, inotherstage)
    ---@type boss
    local BOSS
    ---@type boss.card
    local sc
    local insert_sc_group = {}
    for _, u in ipairs(sc_group) do
        BOSS = _editor_boss[u[2] .. level]
        sc = u[1]
        ---@class sc_group
        local s = { card = sc, boss = BOSS }
        table.insert(insert_sc_group, s)
        ---@class sc_unit
        local sc_unit = { boss = BOSS, CardName = CardName, card = sc }
        table.insert(_sc_table, sc_unit)
        if OD then
            scoredata["UnlockSC"][OD] = scoredata["UnlockSC"][OD] or false
            sc.locked_id = OD
            sc.is_od = true
        else
            table.insert(BOSS.cards, sc)
        end
        sc.inotherstage = inotherstage
        sc.card_id = data_id
        local hist = spell_card_data
        if not hist[sc.card_id] then
            hist[sc.card_id] = {}
            for _, v in ipairs(player_list) do
                hist[sc.card_id][v[2]] = { 0, 0 }
            end
        end
    end
    _sc_pr_table[level] = _sc_pr_table[level] or {}
    ---@class sc_pr_unit
    local sc_pr_unit = { sc_group = insert_sc_group, CardName = CardName, index = #_sc_table }
    table.insert(_sc_pr_table[level], sc_pr_unit)
end

function Card:UnlockOD(id, condition, other_action)
    self._transport = New(Class(object, {
        frame = task.Do,
        init = function(self)
            self.group = GROUP.GHOST
            self.id = id
            task.New(self, function()
                while not self.finish do
                    task.Wait()
                end
                if self[condition or "getcard"] then
                    scoredata["UnlockSC"][self.id] = true
                    if other_action then
                        other_action()
                    end
                end
                object.RawDel(self)
            end)
        end }, true))
end

---获取实战中可以挑战到的符卡数
function Card.GetCardNums()
    local t = 0
    ---@param p sc_unit
    for _, p in ipairs(_sc_table) do
        if not p.card.locked_id and not p.inotherstage then
            t = t + 1
        end
    end
    return t
end
