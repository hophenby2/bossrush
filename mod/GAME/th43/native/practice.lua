-- 练习沿用原生遭遇战和阶段切换，菜单顺序与存档 ID 独立于整关流程。
local P = {}
local routes = {{'first','一周目'}, {'omote','表二周目'}, {'ura','里二周目'}}
local stages = {'一','二','三','四','五'}
local bosses = {
    {key='boss',  spawn=0x10cefe, cuts={{1,0x15f00}}},
    {key='boss2', spawn=0x112cd6, cuts={{2,0xd000}}},
    {key='boss3', spawn=0x119a06, cuts={{1,0x1ad00},{12,0xf700}}},
    {key='boss4', spawn=0x11fa18, cuts={{1,0x51400},{2,0x1a000}}},
    {key='boss5', spawn=0x125a4c, cuts={{1,0x3e900},{2,0x14500},nil,{4,0x4ed00},{5,0x2be00}}},
}
local mids = {
    {key='mid1', spawn=0x12ec6c},
    {key='mid2', spawn=0x130fea, release=0x130},
    {key='mid3', spawn=0x133262},
    {key='mid4', spawn=0x138cbc, release=0x114, cuts={{1,0x17900}}},
    {key='mid5', spawn=0x13b168, release=0x1bc, cuts={{1,0x15200}}},
}

P.entries = {}
for routeIndex, route in ipairs(routes) do
    for stage, boss in ipairs(bosses) do
        for kind, encounter in ipairs({mids[stage],boss}) do
            local phases
            if kind == 1 then phases = encounter.cuts and {0,1} or {0}
            elseif stage == 5 and route[1] == 'ura' then phases = {0,1,3,4,5}
            elseif stage <= 2 then phases = {0,1}
            else phases = {0,1,2} end
            for index, phase in ipairs(phases) do
                local name = kind == 1 and '中 Boss' or stage == 5 and route[1] == 'ura' and 'Doom' or '关底'
                local title = route[2]..' · '..stages[stage]..'面 '..name
                if #phases > 1 then title = title..' Phase '..phase end
                P.entries[#P.entries+1] = {
                    code='TH43', id=73000 + (routeIndex-1)*1000 + stage*100 + kind*10 + phase,
                    title=title, route=route[1], stage=stage, encounter=encounter,
                    phase=phase, phases=phases, index=index,
                }
            end
        end
    end
end

function P.seek(run, program, scroll)
    local stage, entry = run.stageNumber, run.practice
    local target
    local function seekRow(current, row)
        if row[10] == entry.encounter.spawn then target = row end
        if not target and row[10] == mids[stage].spawn and mids[stage].release then
            scroll.release(current, mids[stage].release)
        end
    end
    -- 仅推进地图指令到该遭遇战生成点。此前的敌机、道具和自机状态没有带入练习。
    for _ = 1, 36000 do
        scroll.advance(run)
        program.spawnRows(run, seekRow)
        if target then return target end
        run.frame = run.frame + 1
    end
    error('未找到绊地狱练习的生成点：'..entry.title)
end

local function currentPhase(o, entry)
    if entry.encounter.key == 'mid4' then return o.coverGone and 1 or 0 end
    return o.phase
end

local function started(o, entry, phase)
    if #entry.phases == 1 then return true end
    if entry.encounter.key == 'mid4' and (o.h < 0x3000 or o.run.major < 0x100) then return false end
    return currentPhase(o, entry) == phase and not (o.locked or o.damageLocked or o.hpReveal)
        and not o.dead
end

local function ended(o, entry, phase)
    if not IsValid(o) or o.dead or o.retreating then return true end
    if #entry.phases == 1 then return false end
    if currentPhase(o, entry) > phase then return true end
    local key = entry.encounter.key
    return key == 'boss3' and o.damageLocked
        or key == 'boss4' and o.timerPhase > phase + 1
        or key == 'boss5' and o.transitionPhase == phase
end

function P.preparing(run, o, step, program)
    local entry = run.practice
    if entry.index == 1 then return end
    local x, y = program.world(0x1000,0x1c00)
    local pilot = {x=x,y=y,respawn=0,protect=0xff}
    run.practicePreparing = true
    for index = 1, entry.index - 1 do
        local phase = entry.phases[index]
        local limit = run.frame + 9000
        while not started(o, entry, phase) do
            assert(IsValid(o) and run.frame < limit, '未能初始化绊地狱练习阶段：'..entry.title)
            step(run, pilot)
        end
        local part, cutoff = unpack(entry.encounter.cuts[phase+1])
        local health = o.hp
        if entry.encounter.key == 'boss5' then
            if phase >= 3 then health = o.reserve
            elseif run.route.ura then cutoff = phase == 0 and 0x2a400 or 0 end
        end
        o.parts[part].damage(o.parts[part], math.max(1, health-cutoff))
        step(run, pilot)
        assert(ended(o, entry, phase), '未能切换绊地狱练习阶段：'..entry.title)
    end
    run.practicePreparing = nil
end

function P.finished(run, o)
    local entry = run.practice
    if not IsValid(o) then return true end
    if not run.practiceStarted then run.practiceStarted = started(o, entry, entry.phase) end
    return run.practiceStarted and ended(o, entry, entry.phase)
end

return P
