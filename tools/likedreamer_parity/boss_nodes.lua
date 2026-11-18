-- 子部件诊断：给两端相同的根状态、世界位置与子编号，不推进新建对象。
local fixture = dofile("tools/likedreamer_parity/boss_fixture.lua")
local stage, kind, state, difficulty = tonumber(arg[1]), tonumber(arg[2]), tonumber(arg[3]), tonumber(arg[4])
local rt = {stage = stage, difficulty = difficulty, frame = 1000, enemiesById = {}, spawnChild = fixture.spawnChild, _ldAuditIsolated = true}
local root = {
    spawnType = 311 + stage, entityId = 1, state = state, helperTimer = 0,
    ldX = 360, ldY = 200, hp = 100000, maxhp = 100000, active = true, liveChildCount = 4,
    _bmLiveArms = 4, _bmCombat = true, _bePhaseMode = 1, targetable = true,
    _blPhase = math.floor(state / 10) + 1, countdown = 5000,
}
local self = {
    spawnType = kind, entityId = 2, parent = root, parentSpawnType = root.spawnType, parentEntityId = 1,
    state = 0, helperTimer = 0, ldX = 460, ldY = 150, originX = 460, originY = 150,
    speed = 1, _bmSourceSpeed = 1, hp = 6000, maxhp = 6000, active = true,
    angle16 = 0x4000, secondaryAngle16 = 0, targetAngle16 = 0,
    _beOrbitRadius = 100, _beVerticalRadius = 100, _beHorizontalRadius = 200, _beTargetX = 100, _beTargetY = -50,
    _beOffsetX = 100, _beOffsetY = -50, _beIndex = 1,
    _bmOffsetX = 100, _bmOffsetY = -50, _bmIndex = 1,
    _blOffsetX = 100, _blOffsetY = -50, _blIndex = 1, _blOrbitRadius = 180,
}
if stage == 9 then
    root._blPhase = state == 1 and 1 or state == 6 and 2 or
        (state == 61 or state == 62 or state == 161) and 4 or 3
end
if stage == 4 and (kind == 66 or kind == 67) then self._beOrbitRadius = 180 end
self._blOwnerPhase = root._blPhase
local function apparatus(ownerKind)
    local owner = {
        spawnType = ownerKind, parent = root, entityId = 3, parentEntityId = 1, parentSpawnType = root.spawnType,
        active = true, ldX = 360, ldY = 200, hp = 100000, maxhp = 100000, helperTimer = 0, state = 1, targetable = true,
    }
    self.parent, self.parentEntityId, self.parentSpawnType = owner, 3, ownerKind
    rt.enemiesById[3] = owner
end
-- 第八关原版直接挂根，当前移植版经 b8 挂根；两端按各自实际父链配置。
if not LikeDreamer.Recovered and stage == 8 and (kind == 0xb9 or kind == 0xba) then apparatus(0xb8) end
if stage == 9 and kind >= 0xda then
    self.radius = 180
    self._ldExactData = {sourceSpeed = (kind == 0xda or kind == 0xdc) and 200 or -200}
end
if stage == 10 then
    local owner = kind == 0x114 and 0x113 or (kind >= 0x116 and kind <= 0x119) and 0x115 or
        (kind >= 0x11b and kind <= 0x11c) and 0x11a or (kind >= 0x11e and kind <= 0x122) and 0x11d or
        (kind >= 0x12e and kind <= 0x133) and 0x12d
    if owner then apparatus(owner) end
end
rt.enemiesById[1], rt.enemiesById[2] = root, self
LikeDreamer.runtime = rt
for t = 0, (tonumber(arg[5]) or 2400) - 1 do
    fixture.frame, rt.frame, root.helperTimer = t, 1000 + t, t
    if rt.enemiesById[3] then rt.enemiesById[3].helperTimer = t end
    player.ldX, player.ldY = 200 + t % 200, 500 + t % 100
    fixture.update(self, rt)
    self.helperTimer = self.helperTimer + 1
    if self.removeRequested then break end
end
