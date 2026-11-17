-- 大往生的练习进入原生形态切换，各形态内仍由原来的调度器轮换攻击。
local P = {}
local band = require('bit').band
local stages = {'一','二','三','四','五'}
local mid = {
    {key='mid1', spawn=0x169f86},
    {key='mid2', spawn=0x1774c0},
    {key='mid3', spawn=0x16ac58, phase=function(o)
        return o.wings[1].broken and o.wings[2].broken and 2 or 1
    end, ready=function(o) return o.phase ~= 0 and o.phase ~= 6 end, cuts={function(o, pilot)
        o.health = 0x2800
        o.damage(o,1,pilot.hitFlags)
    end}},
    {key='mid4', spawn=0x17a030},
    {key='mid5', spawn=0x16c69a},
}
local mid5Second = {key='fifthMid2',spawn=0x16de5a}

local function healthBelow(health)
    return function(o) o.health = health - 1 end
end

local function endByTimer(o) o.timeout = 1 end
local function vulnerable(o) return not o.protected end
local function canHit(o, box) return vulnerable(o) and band(o.boxes[box].flags,0x2000) ~= 0 end
local finalBoxes = {[0]=2,11,13}

local bosses = {
    {key='boss1', spawn=0x190b0a, phase=function(o)
        return o.wings[1].broken and o.wings[2].broken and 2 or 1
    end, ready=function(o) return o.vulnerable end, cuts={function(o)
        o.wings[1].health = -1
    end}},
    {key='boss2', spawn=0x1955ea, phase=function(o)
        return o.final and 3 or (o.assembling or o.assembled) and 2 or 1
    end, ready=vulnerable, cuts={healthBelow(0xefc0),healthBelow(0x7701)}},
    {key='boss3', spawn=0x19a11e, phase=function(o) return o.final and 2 or 1 end,
        ready=vulnerable, cuts={healthBelow(0x11800)}},
    {key='boss4', spawn=0x19d21c, phase=function(o)
        return o.final and 3 or o.transformed and 2 or 1
    end, ready=function(o) return canHit(o,2) end, cuts={healthBelow(0x23000),healthBelow(0xc400)}},
    {key='boss5', spawn=0x1a2938, phase=function(o)
        if o.run.loop == 0 then return o.reflecting and 2 or 1 end
        return o.finalDefense and 4 or o.form + 1
    end, ready=function(o) return canHit(o,finalBoxes[o.form]) and not o.transforming end,
        cuts={healthBelow(0x2a000)}, secondCuts={endByTimer,endByTimer,healthBelow(0x23000)}},
}

P.entries = {}
local function register(loop, stage, kind, encounter, name, cuts)
    for phase = 1, #cuts + 1 do
        local route = loop == 0 and '一周目' or '二周目'
        local title = route..' · '..stages[stage]..'面 '..name
        if #cuts > 0 then title = title..' Phase '..phase end
        if loop == 1 and stage == 5 and kind == 3 then
            if phase == 2 then title = route..' · 五面 黄流（飞行形态）'
            elseif phase >= 3 then title = route..' · 五面 绯蜂 Phase '..(phase - 2) end
        end
        P.entries[#P.entries+1] = {
            code='TH44',id=76000 + loop*1000 + stage*100 + kind*10 + phase,
            title=title,loop=loop,stage=stage,encounter=encounter,phase=phase,cuts=cuts,
        }
    end
end

for loop = 0, 1 do
    for stage, boss in ipairs(bosses) do
        register(loop,stage,1,mid[stage],stage == 5 and '中 Boss 1' or '中 Boss',mid[stage].cuts or {})
        if stage == 5 then register(loop,stage,2,mid5Second,'中 Boss 2',{}) end
        register(loop,stage,3,boss,stage == 5 and '黄流' or '关底',loop == 1 and boss.secondCuts or boss.cuts)
    end
end

function P.seek(run, program, scroll)
    local entry = run.practice
    local target
    local function match(_, row)
        if row[7] == entry.encounter.spawn then target = row end
    end
    -- 三面道中由中 Boss 解锁生成计数，直接去关底时在同一卷轴段解除。
    for frame = 1, 36000 do
        run.frame, run.aimPhase = frame, (frame + 3) % 4
        scroll.step(run)
        if entry.encounter == bosses[3] and run.holdMajor then run.holdMajor = false end
        program.spawnRows(run, match)
        if target then return target end
    end
    error('找不到大往生练习的生成点：'..entry.title)
end

local function phaseOf(o, entry)
    return entry.encounter.phase and entry.encounter.phase(o) or 1
end

local function advanceTo(run, o, step, ready)
    for _ = 1, 9000 do
        if ready() then return end
        assert(run.enemies[o.slot] == o and not o.dying, run.practice.title)
        step(run)
    end
    error('未能到达大往生练习的阶段：'..run.practice.title)
end

function P.prepare(run, step)
    local entry = run.practice
    if entry.phase == 1 then return end
    local o, pilot = assert(run[entry.encounter.key]), run.player
    local keys, protect = pilot.key, pilot.protect
    pilot.key, pilot.protect = {}, 0xff
    run.practicePreparing = true
    for phase = 1, entry.phase - 1 do
        advanceTo(run,o,step,function()
            return phaseOf(o,entry) == phase and entry.encounter.ready(o)
        end)
        entry.cuts[phase](o,pilot)
        advanceTo(run,o,step,function() return phaseOf(o,entry) > phase or o.transforming end)
    end
    run.practicePreparing = nil
    pilot.key, pilot.protect = keys, protect
end

function P.finished(run)
    local entry = run.practice
    local o = run[entry.encounter.key]
    if o then run.practiceTarget = o end
    o = run.practiceTarget
    if not o then return false end
    if run.enemies[o.slot] ~= o or o.dying or o.deathTimer or o.escaping then return true end
    local phase = phaseOf(o,entry)
    if phase == entry.phase and (not entry.encounter.ready or entry.encounter.ready(o)) then
        run.practiceStarted = true
    end
    return phase > entry.phase or phase == entry.phase and o.transforming and run.practiceStarted
end

return P
