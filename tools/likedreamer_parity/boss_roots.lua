-- 根对象诊断：固定发射原点，单独测试每个发弹子状态；第六关包含根移动。
local fixture = dofile("tools/likedreamer_parity/boss_fixture.lua")
local functions = fixture.findFunctions()
local stage, state, difficulty, children = tonumber(arg[1]), tonumber(arg[2]), tonumber(arg[3]), tonumber(arg[4])
local rt = {stage = stage, difficulty = difficulty, frame = 1000, spawnChild = fixture.spawnChild, _ldAuditIsolated = true}
local self = {
    spawnType = 311 + stage, entityId = 1, state = state, helperTimer = 0,
    ldX = 360, ldY = 200, liveChildCount = children, hp = 100000, maxhp = 100000,
    countdown = 5000, _bmInit = true, _bmCombat = true,
    angle16 = 0, secondaryAngle16 = 0, targetAngle16 = 0,
}
local names = {[1] = "emitBoss138", [2] = "emitBoss139", [3] = "emitBoss13a",
    [4] = "emitBoss13b", [5] = "stage05BossFire"}
for t = 0, (tonumber(arg[5]) or 2400) - 1 do
    fixture.frame, rt.frame, self.helperTimer = t, 1000 + t, t
    player.ldX, player.ldY = 200 + t % 200, 500 + t % 100
    if stage == 5 or stage == 8 or stage == 9 then
        LikeDreamer.Recovered.call(("emitStage%02dBossProjectiles"):format(stage), self, rt)
    elseif stage == 6 then
        fixture.update(self, rt)
    elseif stage == 10 then
        LikeDreamer.Recovered.call('emitRecoveredFinalRootPattern', self, rt)
    elseif stage == 11 then
        functions["scenePattern" .. state](self, rt)
    elseif names[stage] then
        assert(functions[names[stage]], names[stage])(self, rt)
    else
        local name
        if stage == 8 then
            name = state == 1 and "stage8Pattern1" or state == 2 and "stage8Pattern2" or
                state == 11 and "stage8Pattern11" or state == 21 and "stage8Pattern21" or
                state == 41 and "stage8Pattern41" or "stage8FinalPattern"
        else
            name = state == 1 and "stage9PatternPhase1" or state == 6 and "stage9PatternPhase2" or
                (state >= 111 and state <= 117) and "stage9PatternLunaticLong" or
                (state == 61 or state == 62 or state == 161) and "stage9PatternPhase4" or "stage9PatternNormalLong"
        end
        assert(functions[name], name)(self, rt)
    end
end
