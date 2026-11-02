-- 按真实卡片入口采集已知原作对齐差异；这是审计快照，不是通过即表示已修复的回归测试。
-- 游戏根目录：luajit tools/audit_th3x_card_alignment.lua [输出.json]
-- 复用现有检查器的对象/资源桩；卡片、协程、子弹与 ANM 状态机使用游戏代码。
local output = arg[1]
local f = assert(io.open('tools/check_th35_patterns.lua', 'rb'))
local source = f:read('*a'); f:close()
local prefix = source:sub(1, assert(source:find('local function lasers(', 1, true)) - 1)
-- LObjectEvents.RawDel直接写status='del'，不调用class.del；本次需要观察这一区别。
local removed
prefix, removed = prefix:gsub('                if o.class.del then o.class.del%(o%) end\n', '')
assert(removed == 1, '检查器的回收桩已变化，请重新核对RawDel语义')
local probe = [=[
local result = { clock = 'card.init后，第一次task.Do记作卡内t=0；age是弹体frame调用次数', cards = {} }
local now, births, despawns = 0, {}, {}
local original_new, original_del = New, object.RawDel
New = function(c, ...)
    local o = original_new(c, ...)
    births[o] = now
    return o
end
object.RawDel = function(o)
    local b = o.tb
    if b and b.dead and not despawns[o] then
        despawns[o] = { card_frame = now, age = o.timer + 1, x = o.x, y = o.y,
            speed = b.speed, transform_index = b.ti, type = b.type, color = b.color,
            in_playfield = o.x > -184 and o.x < 184 and o.y > -216 and o.y < 216,
            despawning = o._original_despawning or false,
            native_death_effect = o._native_death_effect or false }
    end
    original_del(o)
end
local function reset()
    objects, shots, births, despawns = {}, {}, {}, {}
    _editor_class.TH35.t10_bullet_slots = {}
    _editor_class.TH35.t10_bullet_cursor = 1
    player.x, player.y = 0, -176
end
local function host(id)
    return New({
        init = function(o)
            o.bound = false; o.hp, o.maxhp = 100000000, 100000000
            o.current_card = assert(cards[id]); o.current_card.init(o)
        end,
        frame = function(o) task.Do(o); o.current_card.frame(o) end,
    })
end
-- 只运行真实的卡3600，不用手工构造弹或替代枪。
reset()
local kanako = host(3600)
local first, trace, before = nil, {}, nil
for t = 0, 340 do
    now = t; step(1)
    if not first and #shots > 0 then
        first = shots[1]; first.audit_initial_wait = first.th_wait
    end
    if first and IsValid(first) then
        if first.timer >= 166 and first.timer <= 170 then
            trace[#trace + 1] = { card_frame = t, age = first.timer,
                wait = first.th_wait, speed = first.th_speed,
                -- 原作先Advance，再清WAIT位；下一帧Advance才挂入加速。
                expected_speed = .001 + math.max(0, first.timer - 8 - first.audit_initial_wait) * first.th_delta }
        end
        if first.timer == 8 then
            before = { card_frame = t, age = first.timer,
                can_cancel = OriginalBulletVisual.can_cancel(first, false),
                has_tb = first.tb ~= nil, wait = first.th_wait,
                speed = first.th_speed, delta = first.th_delta }
        end
    end
end
assert(first and before and #trace == 5, '神德首发或等待观测窗口未命中')
local cancel_called = false
local kill = object.Kill
object.Kill = function(o) if o == first then cancel_called = true else kill(o) end end
OriginalBulletVisual.cancel_bullet(first, 'Kill', false)
object.Kill = kill
result.cards[#result.cards + 1] = { id = 3600, first_bullet_birth = births[first],
    initial_wait = first.audit_initial_wait, active = before,
    wait_trace = trace, ordinary_cancel_reaches_Kill = cancel_called,
    cancel_probe_age = first.timer }
-- 三张诹访子符卡：捕获真实程序运行到0x10000的场内弹，而非构造带该命令的假弹。
for _, id in ipairs({3616, 3619, 3620}) do
    reset(); now = 0
    local b = host(id)
    local sample, sample_object
    for t = 0, 1600 do
        now = t; step(1)
        for o, record in pairs(despawns) do
            if record.in_playfield and (not sample or record.card_frame < sample.card_frame
                or record.card_frame == sample.card_frame and record.x < sample.x) then
                sample, sample_object = record, o
            end
        end
        if sample then
            sample.alive_at_frame_end = IsValid(sample_object)
            sample.pool_slot_reusable = not IsValid(sample_object)
            for slot, o in pairs(_editor_class.TH35.t10_bullet_slots) do
                if o == sample_object then sample.pool_slot = slot; break end
            end
            break
        end
    end
    assert(sample, '没有观测到场内退场弹：' .. id)
    result.cards[#result.cards + 1] = { id = id, first_infield_despawn = sample }
end
-- 梅露兰第一非符：运行真实主任务、子机和原生姿态选择器，记录ANM设置调用。
reset(); now = 0
dofile('mod/GAME/th34.lua')
local b = host(4442)
b.class.StageLevel = 32
b._wisys = { obj = b, original = true }
OriginalStageVisual.bind_boss(b._wisys, 'Merlin')
local A, seen, set_calls, waves = OriginalANM.load(7, 'stg4enm'), {}, {}, {}
local old_set = OriginalStageVisual.set_script
OriginalStageVisual.set_script = function(o, id, ...)
    if o == b then set_calls[#set_calls + 1] = { card_frame = now, script = id } end
    return old_set(o, id, ...)
end
local checkpoints = {}
for t = 0, 500 do
    now = t; local x = b.x; step(1)
    OriginalStageVisual.tick(b, b.x - x)
    seen[b._original_actor.vm.id] = true
    if t == 85 or t == 205 or t == 235 then
        checkpoints[#checkpoints + 1] = { card_frame = t, vm = b._original_actor.vm.id }
    end
end
OriginalStageVisual.set_script = old_set
for o, t in pairs(births) do
    local s = rawget(o, '_original_source')
    if s and s.key == 'ecldata4:77' then waves[#waves + 1] = t end
end
table.sort(waves)
local ids = {}; for id in pairs(seen) do ids[#ids + 1] = id end; table.sort(ids)
result.cards[#result.cards + 1] = { id = 4442, expected_script = 135,
    expected_vm = A.ids[135], seen_vm_ids = ids, set_script_calls = set_calls,
    checkpoints = checkpoints, child_birth_frames = waves }
local function json(v)
    if type(v) == 'table' then
        if v[1] ~= nil then
            local a = {}; for _, n in ipairs(v) do a[#a + 1] = json(n) end
            return '[' .. table.concat(a, ',') .. ']'
        end
        local a = {}; for k, n in pairs(v) do a[#a + 1] = json(tostring(k)) .. ':' .. json(n) end
        table.sort(a); return '{' .. table.concat(a, ',') .. '}'
    elseif type(v) == 'string' then
        return '"' .. v:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n') .. '"'
    else return tostring(v) end
end
return json(result)
]=]
local data = assert(loadstring(prefix .. '\n' .. probe, '@audit_th3x_card_alignment'))()
if output then
    local out = assert(io.open(output, 'wb')); out:write(data, '\n'); out:close()
end
print(data)
