-- 通过卡364「格兰吉纽尔剧场的怪人」的真实人偶，采集光环、受击、切换形态的差异。
-- 游戏根目录：luajit tools/audit_th31_familiar_alignment.lua [输出.json]
local output = arg[1]
local f = assert(io.open('tools/check_th31_combat.lua', 'rb'))
local source = f:read('*a'); f:close()
local prefix = source:sub(1, assert(source:find('local definition=', 1, true)) - 1)
-- 在载入卡片前截获音效，兼顾模块将PlaySound缓存为局部变量的情况。
local replaced
prefix, replaced = prefix:gsub("dofile%('mod/GAME/th31.lua'%)", [[
local audit_sounds, audit_record_sound = {}, false
local audit_old_sound = PlaySound
PlaySound = function(name, ...)
    if audit_record_sound then audit_sounds[#audit_sounds + 1] = tostring(name) end
    return audit_old_sound(name, ...)
end
dofile('mod/GAME/th31.lua')]], 1)
assert(replaced == 1, '找不到实际卡片载入入口')
local probe = [=[
local card, owner = assert(cards[364]), boss_owner(218)
stage = { current_stage = { timer = 0 } }; player.slow = 0
card.init(owner)
local function advance(t)
    stage.current_stage.timer = t
    card.frame(owner)
    local n = #objects
    for i = 1, n do
        local o = objects[i]
        if o ~= owner and IsValid(o) then
            o.class.frame(o)
            o.x, o.y = o.x + (o.vx or 0), o.y + (o.vy or 0)
            o.timer, o.ani = o.timer + 1, o.ani + 1
        end
    end
    owner.timer, owner.ani = owner.timer + 1, owner.ani + 1
end
for t = 0, 151 do advance(t) end
local dolls = {}
for _, o in ipairs(objects) do
    if IsValid(o) and o.th08_attached and o.alice_angle then dolls[#dolls + 1] = o end
end
assert(#dolls == 16, '卡364未生成预期的十六只真实人偶')
local rotations = {}
for _, o in ipairs(dolls) do
    rotations[#rotations + 1] = o._original_alignment.vm.omega[3]
end
local target, hp = dolls[1], dolls[1].hp
Damage(target, 10)
advance(152)
local vm = target._original_actor.vm
local flash = { damage = hp - target.hp, color2 = { vm.color2[1], vm.color2[2], vm.color2[3] },
    secondary = vm.secondary or false, guard = target.th08_guard_active }
-- 截获真实ANM的创建入口，观察切换到低速和恢复高速期间的59/60脚本与音效。
local created, form = {}, {}
local old_new = OriginalANM.new
OriginalANM.new = function(game, archive, id, ...)
    created[id] = (created[id] or 0) + 1
    return old_new(game, archive, id, ...)
end
audit_record_sound = true
local old_layer = target.layer
player.slow = 1
for t = 153, 168 do advance(t) end
form[#form + 1] = { slow = 1, youkai = target.th08_youkai, layer = target.layer,
    halo_youkai = target._original_alignment.youkai }
player.slow = 0
for t = 169, 184 do advance(t) end
form[#form + 1] = { slow = 0, youkai = target.th08_youkai, layer = target.layer,
    halo_youkai = target._original_alignment.youkai }
OriginalANM.new = old_new
audit_record_sound = false
local result = { id = 364, original_spell_number = 218, doll_count = #dolls,
    halo_omega_z = rotations, human_hit = flash, form_trace = form,
    layer_before = old_layer, hide_script_60 = created[60] or 0,
    unhide_script_59 = created[59] or 0, sounds_during_form_change = audit_sounds,
    sound_count_during_form_change = #audit_sounds }
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
local data = assert(loadstring(prefix .. '\n' .. probe, '@audit_th31_familiar_alignment'))()
if output then
    local out = assert(io.open(output, 'wb')); out:write(data, '\n'); out:close()
end
print(data)
