-- 三姐妹的共享血槽：原作Sub42先生成控制器，随后才生成三位演奏者。
-- EnemyManager按槽顺序更新，所以Sub44..51读取的是三姐妹上一帧的lastDamage。
-- 汇总开始前的伤害不会积攒；每位演奏者的142减伤先作用一次，再交给共享血槽。
local P = {}
P.phases = {
    [5480]={controller=45, start=240, guard=180},
    [5481]={controller=45, start=240, guard=180},
    [5482]={controller=45, start=240, guard=0},
    [5483]={controller=47, start=240, guard=180},
    [5484]={controller=47, start=240, guard=180},
    [5485]={controller=47, start=240, guard=180},

    [4440]={controller=44, start=240, guard=0},
    [4442]={controller=44, start=240, guard=0},
    [4444]={controller=44, start=240, guard=0},
    [4441]={controller=46, start=240, guard=240, companion_guard=360},
    [4443]={controller=48, start=300, guard=240},
    [4445]={controller=48, start=300, guard=240},
    [4446]={controller=48, start=300, guard=480},
    [4475]={controller=48, start=300, guard=480},
    [4447]={controller=49, start=360, guard=240, companion_guard=240},
    [4476]={controller=49, start=360, guard=240, companion_guard=240},
    [4448]={controller=51, start=360, guard=240, companion_guard=240},
}

P.controller = Class(object, {
    init = function(self, owner, phase)
        self.group, self.bound, self.colli = GROUP.GHOST, false, false
        self.owner, self.phase, self.clock, self.pending = owner, phase, 0, 0
    end,
    frame = function(self)
        if not IsValid(self.owner) or self.owner.th07_shared_damage ~= self then object.RawDel(self) end
    end,
    receive = function(self, actor, damage)
        local owner = self.owner
        if not IsValid(owner) or owner.th07_shared_damage ~= self or actor.protect or self.clock < 0 then return end
        local guard = actor == owner and self.phase.guard or self.phase.companion_guard or 0
        local factor = self.clock < guard and 1/9 or 1
        self.pending = self.pending + damage * factor * (owner.DMG_factor or 1) * (owner.astral_dmg_factor or 1)
    end,
    advance = function(self)
        self.clock = self.clock + 1
        local owner = self.owner
        if self.clock >= self.phase.start and self.pending > 0 then
            local damage = math.min(owner.hp, self.pending)
            owner.hp = owner.hp - damage
            owner.spell_damage = (owner.spell_damage or 0) + damage
        end
        self.pending = 0
    end,
})

function P.begin(owner, id)
    P.finish(owner)
    local phase = P.phases[id]
    if phase then owner.th07_shared_damage = New(P.controller, owner, phase) end
end
function P.step(owner)
    local controller = owner.th07_shared_damage
    if controller and IsValid(controller) then P.controller.advance(controller) end
end
function P.finish(owner)
    local controller = owner.th07_shared_damage
    owner.th07_shared_damage = nil
    if controller and IsValid(controller) then object.RawDel(controller) end
end
function P.receive(actor, damage)
    local controller = actor.th07_shared_damage
    if controller and IsValid(controller) then
        P.controller.receive(controller, actor, damage)
        return true
    end
    return false
end
return P
