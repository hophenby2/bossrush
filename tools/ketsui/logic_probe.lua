-- ShmupMAME 5.4。导出解密程序，并记录首次道中的指令分派。
local machine = manager.machine
local rom = emu.romname()
assert(rom == 'ket' or rom == 'ketl2omote' or rom == 'ketl2ura', '请使用 ket 或 ShmupMAME 的二周目入口')
local cpu = machine.devices[':maincpu']
local mem = cpu.spaces.program
local state = cpu.state
local output = assert(io.open('logic.tsv', 'w'))
local frame, taps = 0, {}
local bossCallbacks = {}
local mode = os.getenv('KET_LOGIC_MODE') or 'idle'
local firstBullet = 0x81719e
local firstEnemy = 0x812a64
local limits = {boss=9800, mid2=22000, boss2=39000, boss3=63000, lateBosses=141000}
local lastFrame = assert(tonumber(os.getenv('KET_LOGIC_LAST') or limits[mode] or 3000))
local opening = os.getenv('KET_LOGIC_OPENING') == '1'
local pilotProbe = mode == 'pilot' or mode == 'lock' or mode == 'bomb'
local firstBoss, secondMid, secondMidParts, secondBoss, thirdBoss
local firstMid, firstMidFlags
local thirdPhase
local thirdEmitters = {}
local thirdMid, thirdMidState, thirdMidHp
local lateBoss, lateParts, lateUpdate, lateHealth, lateSecondary
local aircraftUpdates = {[0xdd34e]=true,[0xdeafc]=true,[0xdff92]=true,[0xe087a]=true}

local function reg(name)
    return state[name].value
end

local function log(name, ...)
    output:write(('%d\t%s'):format(frame, name))
    for index = 1, select('#', ...) do
        output:write(('\t%08x'):format(select(index, ...)))
    end
    output:write('\n')
end

local function hook(address, name, callback)
    -- 68000 的取指 tap 发生在该字执行前。当前指令的数据写入用 CURPC 核对。
    taps[#taps + 1] = mem:install_read_tap(address, address + 1, name, function()
        if reg('PC') == address then callback() end
    end)
end

local function watchWrite(address, name, callback)
    taps[#taps + 1] = mem:install_write_tap(address, address + 1, name, callback)
end

local function install()
    local aircraftSlots = {}
    hook(0x12ea22, '一面母舰初始化', function()
        firstMid, firstMidFlags = reg('A5'), nil
        log('一面母舰初始化', firstMid, mem:read_u32(firstMid + 0x12))
    end)
    hook(0x0cf75c, '生成记录', function()
        local row = reg('A2')
        log('生成记录', row, mem:read_u16(row), mem:read_u16(row + 2),
            reg('D0') & 0xff, reg('D1') & 0xffff, mem:read_u32(row + 8))
    end)
    hook(0x0cf884, '敌机调度', function()
        local enemy = reg('A5')
        local callback = mem:read_u32(enemy + 0x4c)
        if aircraftUpdates[callback] and aircraftSlots[enemy] ~= callback then
            local part = mem:read_u32(enemy + 6)
            local patrol = callback == 0xdd34e
            local hp = mem:read_u32(enemy + (patrol and 0x30 or 0x1a))
            local threshold = patrol and 0 or mem:read_u32(enemy + 0x3c)
            log('多段机身初始化', callback, mem:read_u32(part + 2), hp, threshold,
                mem:read_u16(0x81247c), mem:read_u16(0x81247e))
        end
        aircraftSlots[enemy] = aircraftUpdates[callback] and callback or nil
        if enemy == firstEnemy and frame <= 2581 then
            log('敌机调度', enemy, mem:read_u16(enemy + 12), mem:read_u32(enemy + 6),
                mem:read_u32(enemy + 18), mem:read_u32(enemy + 76))
        end
    end)
    hook(0x0d0a04, '敌机发弹', function()
        local enemy, part = reg('A5'), reg('A6')
        log('敌机发弹', enemy, part, mem:read_u32(part + 2), mem:read_u32(0x80fea4),
            reg('D0'), reg('D1') & 0xff, reg('D2'), reg('D3'))
    end)
    -- +0x22 是完整回调地址，高低字分别写入。取低字时高字已更新。
    watchWrite(firstBullet + 0x24, '绑定弹回调', function(_, value)
        local callback = mem:read_u16(firstBullet + 0x22) * 65536 + value
        if callback ~= 0 then log('绑定弹回调', reg('CURPC'), firstBullet, callback) end
    end)
    watchWrite(firstBullet + 2, '敌弹移动', function(_, value)
        if reg('CURPC') == 0x0f8d44 and frame <= 2590 then
            log('敌弹移动', firstBullet, mem:read_u32(firstBullet + 0x22),
                mem:read_u32(firstBullet + 2), reg('D0'), value, mem:read_u32(firstBullet + 0x1e),
                reg('D6') & 0xffff)
        end
    end)
    hook(0x0b111a, '自机命中', function()
        local bullet, pilot = reg('A6') - 4, reg('A4')
        log('自机命中', bullet, pilot, mem:read_u16(bullet), mem:read_u32(bullet + 2),
            mem:read_u32(pilot + 2), reg('D0') & 0xffff, reg('D1') & 0xffff,
            reg('D2') & 0xffff, reg('D3') & 0xffff)
    end)
    watchWrite(0x80fea2, '自机命中标志', function(_, value)
        if reg('CURPC') == 0x0b10fc then log('自机命中标志', 0x80fea2, value) end
    end)
    if lastFrame > 3000 then
        hook(0x10caec, '关底初始化', function()
            firstBoss = reg('A5')
            log('关底初始化', firstBoss, reg('A6'))
        end)
        taps[#taps + 1] = mem:install_write_tap(0x81203e, 0x8120dd, '关底事件登记', function(address, value)
            if firstBoss and reg('A5') == firstBoss and reg('CURPC') == 0x0c195e then
                bossCallbacks[address] = nil
                log('关底事件登记', firstBoss, address, mem:read_u32(0x81203a), value & 0xff)
            end
        end)
        hook(0x0c1842, '关底事件调用', function()
            local owner = reg('A5')
            if owner == firstBoss or owner == secondBoss or owner == thirdBoss or owner == lateBoss then
                local slot, callback = reg('A4'), reg('A0')
                if callback ~= bossCallbacks[slot] then
                    bossCallbacks[slot] = callback
                    log('关底事件调用', owner, slot, mem:read_u16(slot), callback)
                    if owner == secondBoss and callback == 0x114aaa then
                        log('二面关底换段', owner, mem:read_u32(owner + 0x16), mem:read_u8(reg('A6') + 0x49))
                    end
                end
            end
        end)
        watchWrite(0x8124a2, '关底换段', function()
            if reg('CURPC') ~= 0x10f82a then return end
            local boss, part = reg('A5'), reg('A6')
            log('关底换段', boss, mem:read_u32(boss + 0x16), mem:read_u8(part + 0x73),
                mem:read_u8(part + 0x9d), mem:read_u8(part + 0xc7), mem:read_u8(part + 0xf1),
                mem:read_u8(part + 0x11b), mem:read_u8(part + 0x145))
        end)
    end
    if mode == 'boss2' or mode == 'boss3' then
        hook(0x112962, '二面关底初始化', function()
            secondBoss = reg('A5')
            log('二面关底初始化', secondBoss, reg('A6'))
        end)
    end
    if mode == 'boss2' then
        hook(0x0c1912, '二面关底发射回调', function()
            local callback = reg('A0')
            if reg('A5') == secondBoss and callback >= 0x116616 and callback <= 0x118876 then
                local id = mem:read_u16(reg('A4')) & 0xff
                if callback == mem:read_u32(0x116560 + id * 8) then
                    log('二面关底发射槽', id, callback, mem:read_u32(reg('A6') + 2))
                end
            end
        end)
        for _, address in ipairs({0x116690, 0x1166d6, 0x116964, 0x11698c, 0x1169ba, 0x1169fc, 0x116a32,
            0x116dc2, 0x116f6e, 0x117494, 0x1177ce, 0x117c66, 0x118342, 0x11861e}) do
            hook(address, '二面关底发弹参数', function()
                local command = reg('D0')
                log('二面关底发弹参数', mem:read_u16(reg('A4')) & 0xff, command & 0x7f,
                    command >> 16 & 0xffff, reg('D1') & 0xff, reg('D2'), reg('D3'))
            end)
        end
    end
    if mode == 'boss3' then
        hook(0x132d7e, '三面战舰初始化', function()
            thirdMid, thirdMidState, thirdMidHp = reg('A5'), nil, nil
            log('三面战舰初始化', thirdMid, mem:read_u32(thirdMid + 0x12))
        end)
        hook(0x1196b4, '三面关底初始化', function()
            thirdBoss = reg('A5')
            log('三面关底初始化', thirdBoss, reg('A6'))
        end)
        hook(0x0c1912, '三面关底发射槽', function()
            if thirdBoss and reg('A5') == thirdBoss and reg('A0') >= 0x11ceac and reg('A0') < 0x11f000 then
                local part = reg('A6')
                local control = mem:read_u16(reg('A4'))
                local id = control & 0xff
                local slot = reg('A4')
                if control >> 8 == 0x81 and reg('A0') == mem:read_u32(0x11ce0c + id * 8)
                    and thirdEmitters[slot] ~= frame then
                    thirdEmitters[slot] = frame
                    log('三面关底发射槽', id, mem:read_u32(part + 2), mem:read_u16(part + 0x2ac))
                end
            end
        end)
    end
    if mode == 'lateBosses' then
        local earlyFrames, earlyPhase = {}, {}
        local earlyState = {[0xead90]=0x34,[0xde4a6]=0x1f,[0xe7fd6]=0,[0xe815a]=0,[0xe3434]=0x28}
        hook(0x0cf884,'一二面装甲载具调度',function()
            local o = reg('A5')
            local callback = mem:read_u32(o+0x4c)
            local field = earlyState[callback]
            if not field then earlyFrames[o],earlyPhase[o] = nil,nil; return end
            local phase = field ~= 0 and mem:read_u8(o+field) or 0
            if earlyFrames[o] == callback and earlyPhase[o] == phase then return end
            earlyFrames[o],earlyPhase[o] = callback,phase
            local body = mem:read_u32(o+6)
            log('一二面装甲载具状态',callback,o,phase,mem:read_u16(body+0x18),mem:read_u32(body+2),
                mem:read_u16(o+0x2e),mem:read_u16(0x81247c),mem:read_u16(0x81247e))
        end)
        for _, pc in ipairs({0xeaf90,0xeb298,0xde6c6,0xde7be,0xe35f6,0xe36d6}) do
            hook(pc,'一二面炮位分配',function()
                log('一二面炮位分配',pc,reg('A5'),reg('D0'),reg('D1'),reg('D2'),reg('D3'))
            end)
        end
        local hoverPhase = {}
        hook(0x0cf884, '浮空炮组调度', function()
            local owner = reg('A5')
            local callback = mem:read_u32(owner+0x4c)
            if callback ~= 0xf2638 and callback ~= 0xf32e8 then hoverPhase[owner] = nil; return end
            local phase = mem:read_u16(owner+0x1c)
            if phase == hoverPhase[owner] then return end
            hoverPhase[owner] = phase
            local body = mem:read_u32(owner+6)
            log('浮空炮组换段', callback, owner, phase, mem:read_u16(owner+0x24),
                mem:read_u32(owner+0x18), mem:read_u32(body+2), mem:read_u16(0x81248a))
        end)
        for _, pc in ipairs({0x0f2ec2,0x0f3c6e}) do
            hook(pc, '浮空炮组主炮分配', function()
                log('浮空炮组主炮分配', pc, reg('D0'), reg('D1'), reg('D2'), mem:read_u16(0x81248a))
            end)
        end
        hook(0x0eda20, '五面飞机编队发出', function()
            local owner = reg('A5')
            log('五面飞机编队发出', mem:read_u16(owner+0x1c), mem:read_u8(owner+0x1a),
                mem:read_u16(0x81247c), mem:read_u16(0x81247e))
        end)
        hook(0x0ecde0, '五面装甲炮占位检查', function()
            log('五面装甲炮占位检查', mem:read_u16(0x812488), mem:read_u16(0x81247c), mem:read_u16(0x81247e))
        end)
        watchWrite(0x812488, '五面载具占位变更', function(_, value)
            if mem:read_u16(0x812440) == 4 then
                log('五面载具占位变更', reg('PC'), value, mem:read_u16(0x81247c), mem:read_u16(0x81247e))
            end
        end)
        hook(0x0e4f94, '旋转炮组初始化完成', function()
            local owner, part = reg('A5'), reg('A6')
            log('旋转炮组初始化完成', owner, mem:read_u16(part + 0x18), mem:read_u16(owner + 0x1c),
                mem:read_u32(owner + 0x20), mem:read_u16(owner + 0x2e), mem:read_u32(part + 2))
        end)
        hook(0x0e5200, '旋转炮组舱盖发射', function()
            if reg('D1') & 0xff ~= 0 then return end
            log('旋转炮组舱盖发射', reg('A5'), reg('D0'), reg('D2'), reg('D3'), reg('D4') & 0xff)
        end)
        hook(0x0e86dc, '警告演出初始化', function()
            log('警告演出初始化', mem:read_u16(0x812440), reg('A5'))
        end)
        for _, row in ipairs({{0x11f800,0x11fa18},{0x1254fe,0x125a4c}}) do
            local address, update = table.unpack(row)
            hook(address, '后半关底初始化', function()
                lateBoss, lateParts, lateUpdate = reg('A5'), reg('A6'), update
                lateHealth, lateSecondary = nil, nil
                log('后半关底初始化', address, lateBoss, lateParts)
            end)
        end
        local calls = {}
        hook(0x0c1912, '后半关底发射槽', function()
            if reg('A5') ~= lateBoss or mem:read_u32(lateBoss + 0x4c) ~= lateUpdate then return end
            local slot, callback = reg('A4'), reg('A0')
            local control = mem:read_u16(slot)
            if calls[slot] ~= callback then
                calls[slot] = callback
                log('后半关底发射槽', lateUpdate, control, callback,
                    mem:read_u32(lateBoss + 0x16), mem:read_u32(lateParts + 2))
            end
        end)
    end
    if mode == 'mid2' or mode == 'boss2' or mode == 'boss3' then
        hook(0x130e06, '二面道中初始化', function()
            secondMid, secondMidParts = reg('A5'), reg('A6')
            log('二面道中初始化', secondMid, secondMidParts, mem:read_u16(secondMid + 0xc))
        end)
        watchWrite(0x8125d4, '二面道中解锁', function(_, value)
            if value == 0x130 and secondMidParts and reg('A5') == secondMid and reg('A6') == secondMidParts then
                log('二面道中解锁', mem:read_u16(0x81247c), mem:read_u8(secondMidParts + 0x1f),
                    mem:read_u8(secondMidParts + 0x49))
            end
        end)
        hook(0x0c1bec, '二面道中发射槽', function()
            if secondMid and reg('A5') == secondMid then
                log('二面道中发射槽', reg('D0') & 0xff, mem:read_u32(secondMidParts + 2),
                    mem:read_u32(secondMidParts + 0x2c))
            end
        end)
    end
end

local function press(port, name, from, to)
    machine.ioport.ports[port].fields[name]:set_value(frame >= from and frame < to and 1 or 0)
end

local program = assert(io.open('program.bin', 'wb'))
program:write(mem:read_range(0, 0x1fffff, 8))
program:close()

emu.register_frame_done(function()
    frame = frame + 1
    press(':Service', 'Coin 1', 1860, 1900)
    press(':P1P2', '1 Player Start', 1930, 1970)
    if (mode == 'boss' or mode == 'mid2' or mode == 'boss2' or mode == 'boss3' or mode == 'lateBosses') and frame >= 2700 then
        local shoot = frame % 4 < 2
        if (mode == 'boss2' or mode == 'boss3') and frame >= 16000 then shoot = not secondBoss or frame % 800 < 320 end
        if mode == 'boss2' and secondBoss and os.getenv('KET_LOGIC_BOSS2_IDLE') == '1' then shoot = false end
        if mode == 'boss3' and frame >= 31500 then shoot = not thirdBoss or frame % 720 < 400 end
        if mode == 'lateBosses' then shoot = not lateBoss or frame % 600 < 500 end
        machine.ioport.ports[':P1P2'].fields['P1 Button 1']:set_value(shoot and 1 or 0)
        -- 维持 0x80fedc 的受击保护计时，延长关底回调的观察时间。
        if mem:read_u16(0x80fea2) >= 0x8000 then mem:write_u8(0x80fedc, 0x70) end
    else
        press(':P1P2', 'P1 Button 1', 2100, 2140)
    end
    if mode == 'right' then press(':P1P2', 'P1 Right', 2548, 2588) end
    if pilotProbe then
        press(':P1P2', 'P1 Button 1', 2100, 2140)
        if mode == 'pilot' then
            machine.ioport.ports[':P1P2'].fields['P1 Button 1']:set_value(
                (frame >= 2100 and frame < 2140 or frame >= 2545 and frame % 4 < 2) and 1 or 0)
            press(':P1P2', 'P1 Right', 2548, 2588)
        elseif mode == 'lock' then
            machine.ioport.ports[':P1P2'].fields['P1 Button 1']:set_value(
                (frame >= 2100 and frame < 2140 or frame >= 2545 and frame < 2880) and 1 or 0)
        else
            press(':P1P2', 'P1 Button 2', 2560, 2562)
        end
        if frame >= 2500 then
            local p = 0x80fea2
            log('自机状态', mem:read_u16(p), mem:read_u32(p + 2), mem:read_u16(p + 0x18),
                mem:read_u16(p + 0x1a), mem:read_u16(p + 0x20), mem:read_u16(p + 0x22),
                mem:read_u16(p + 0x24), mem:read_u8(p + 0x3a), mem:read_u8(p + 0x3b),
                mem:read_u16(p + 0x44), mem:read_u8(p + 0x4e), mem:read_u16(p + 0x4c),
                mem:read_u16(p + 0x30), mem:read_u16(p + 0x32), mem:read_u32(p + 0x52))
            for i = 0, 41 do
                local s = 0x8101c2 + i * 0x34
                local flags = mem:read_u16(s)
                if flags >= 0x8000 then
                    log('自机弹状态', i, flags, mem:read_u32(s + 2), mem:read_u16(s + 0x14),
                        mem:read_u8(s + 0x1a), mem:read_u8(s + 0x1b), mem:read_u32(s + 0x2c))
                end
            end
            if mode == 'bomb' then
                local b = 0x8112d2
                log('炸弹状态', mem:read_u16(0x81137e), mem:read_u16(b), mem:read_u32(b + 2),
                    mem:read_u32(b + 0x10), mem:read_u32(b + 0x14), mem:read_u32(b + 0x1e))
            end
        end
    end
    if frame == 2420 then install() end
    if firstMid and mem:read_u32(firstMid + 0x4c) == 0x12ec6c then
        local body = mem:read_u32(firstMid + 6)
        local flags = mem:read_u16(body + 0x150) & 0x2000
        flags = flags | mem:read_u8(body + 0x49) | mem:read_u8(body + 0x73) << 1
        if firstMidFlags ~= flags then
            firstMidFlags = flags
            log('一面母舰判定', flags, mem:read_u32(body + 2), mem:read_u32(firstMid + 0x16),
                mem:read_u32(firstMid + 0x1a), mem:read_u32(firstMid + 0x1e))
        end
    end
    if lateBoss and mem:read_u32(lateBoss + 0x4c) == lateUpdate then
        local health, secondary = mem:read_u32(lateBoss + 0x16), mem:read_u32(lateBoss + 0x1a)
        if lateHealth ~= health or lateSecondary ~= secondary then
            lateHealth, lateSecondary = health, secondary
            log('后半关底血量', lateUpdate, health, secondary)
        end
    end
    if thirdBoss and mem:read_u32(thirdBoss + 0x4c) == 0x119a06 then
        local parts = mem:read_u32(thirdBoss + 6)
        local phase = mem:read_u16(parts + 0x2ac)
        if phase ~= thirdPhase then
            log('三面关底阶段', phase, mem:read_u32(thirdBoss + 0x16), mem:read_u32(parts + 2))
            thirdPhase = phase
        end
    end
    if thirdMid and mem:read_u32(thirdMid + 0x4c) == 0x133262 then
        -- 初始化的取指 tap 上 A6 可能仍属于上一个对象。分配后的指针从父槽读取。
        local body = mem:read_u32(thirdMid + 6)
        local phase = mem:read_u16(body + 0x406) << 16 | mem:read_u16(body + 0x48c)
        local hp = mem:read_u32(thirdMid + 0x16)
        if phase ~= thirdMidState or hp ~= thirdMidHp then
            thirdMidState, thirdMidHp = phase, hp
            log('三面战舰阶段', phase, hp, mem:read_u32(body + 2), mem:read_u16(body + 0x2a),
                mem:read_u16(body + 0x404), mem:read_u16(0x81247c), mem:read_u16(0x81247e))
        end
    end
    if secondMid and mem:read_u16(secondMid + 0x0c) & 0xff00 == 0x7400
        and mem:read_u32(secondMid + 0x4c) == 0x130fea and mem:read_u32(secondMid + 6) == secondMidParts then
        log('二面道中部件', mem:read_u32(secondMidParts + 2), mem:read_u32(secondMidParts + 0x2c),
            mem:read_u32(secondMid + 0x16), mem:read_u32(secondMid + 0x1a),
            mem:read_u8(secondMidParts + 0x1a), mem:read_u8(secondMidParts + 0x1b),
            mem:read_u8(secondMidParts + 0x44), mem:read_u8(secondMidParts + 0x45),
            mem:read_u16(0x81247c), mem:read_u16(0x812528), mem:read_u16(0x81252c))
    end
    if opening and frame >= 2415 and frame <= 2700 then
        log('道中状态', mem:read_u16(0x81247c), mem:read_u16(0x81247e),
            mem:read_u16(0x812446), mem:read_u16(0x81244e), mem:read_u16(0x812468),
            mem:read_u16(0x81246e), mem:read_u16(0x812512), mem:read_u16(0x812528),
            mem:read_u16(0x81252c), mem:read_u16(0x812576), mem:read_u16(0x812578),
            mem:read_u16(0x81253a), mem:read_u16(0x81253c), mem:read_u32(0x80fea4),
            mem:read_u16(0xb02000), mem:read_u16(0xb03000))
        local part = mem:read_u32(firstEnemy + 6)
        if part >= 0x813964 and part < 0x815aa2 and mem:read_u16(firstEnemy + 12) == 0x1000 then
            log('小型机状态', mem:read_u32(part + 2), mem:read_u16(part + 0x1a),
                mem:read_u8(firstEnemy + 0x18), mem:read_u16(part + 0x18))
        end
        if mem:read_u16(firstBullet) & 0x8000 ~= 0 then
            log('敌弹状态', mem:read_u32(firstBullet + 2), mem:read_u16(firstBullet + 0x1a),
                mem:read_u32(firstBullet + 0x1e), mem:read_u32(firstBullet + 0x22))
        end
    end
    if frame == lastFrame then
        output:close()
        machine:exit()
    end
end)
