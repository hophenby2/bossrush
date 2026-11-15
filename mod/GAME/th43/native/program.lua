-- ROM 数据和 68000 定点运算供 LuaSTG 对象的回调共用。
local bit = require('bit')
local band, bor, rshift = bit.band, bit.bor, bit.rshift
local floor, byte = math.floor, string.byte
local path = 'mod/GAME/th43/native/'
local M = dofile(path .. 'rom_objects.lua')
M.stages = dofile(path .. 'rom_stages.lua')
M.spawnTypes = dofile(path .. 'rom_spawn_types.lua')
M.tiles = dofile(path .. 'rom_tiles.lua')
local vectors = assert(lstg.LoadTextFile(path .. 'rom_vectors.bin'))
assert(#vectors == 0x74400, '绊地狱速度表长度错误')

local function s16(n)
    n = band(n, 0xffff)
    return n < 0x8000 and n or n - 0x10000
end

local function word(data, pos)
    if type(data) == 'string' then
        local hi, lo = byte(data, pos, pos + 1)
        return hi * 256 + lo
    end
    return data[pos] * 256 + data[pos + 1]
end

local function unpackPosition(value)
    return s16(rshift(value, 16)), s16(value)
end

local function packPosition(h, l)
    return bor(bit.lshift(h, 16), band(l, 0xffff))
end

M.s16, M.word, M.pack, M.unpack = s16, word, packPosition, unpackPosition

function M.add(h, l, dh, dl)
    return unpackPosition(packPosition(h, l) + packPosition(dh, dl))
end

function M.world(h, l)
    return l / 64 - 112, h / 64 - 224
end

function M.fixed(x, y)
    return floor((y + 224) * 64 + .5), floor((x + 112) * 64 + .5)
end

function M.overlap(part, h, l, front, back, right, left)
    local ph, pl = part.h + 0x2800, part.l + 0x2800
    h, l = h + 0x2800, l + 0x2800
    return band(h + front, 0xffff) >= band(ph - part.back, 0xffff)
       and band(h - back, 0xffff) <= band(ph + part.front, 0xffff)
       and band(l + right, 0xffff) >= band(pl - part.left, 0xffff)
       and band(l - left, 0xffff) <= band(pl + part.right, 0xffff)
end

-- 0xb058e 先算自机弹前沿和右沿，再从各自的边沿退回。横轴退两次左侧尺寸。
function M.shotOverlap(part, h, l, shot, bias)
    local ph, pl = part.h + bias, part.l + bias
    local hi, ri = h + bias + shot.front, l + bias + shot.right
    return band(hi, 0xffff) >= band(ph - part.back, 0xffff)
       and band(hi - shot.back, 0xffff) <= band(ph + part.front, 0xffff)
       and band(ri, 0xffff) >= band(pl - part.left, 0xffff)
       and band(ri - shot.left * 2, 0xffff) <= band(pl + part.right, 0xffff)
end

function M.vector(speed, angle)
    local address = band(speed, 0xff) * 1024 + band(angle, 0xff) * 4 + 1
    return s16(word(vectors, address)), s16(word(vectors, address + 2))
end

function M.optionVector(speed, angle)
    local address = 0x40001 + speed * 1024 + band(angle, 0xff) * 4
    return s16(word(vectors, address)), s16(word(vectors, address + 2))
end

local origin = {0x80, 0x100, 0x80, 0, 0x180, 0x100, 0x180, 0}
local turn = {1, -1, -1, 1, -1, 1, 1, -1}

local function aimSector(h, l, targetH, targetL, wide)
    local dh, dl
    if wide then
        dh, dl = s16(h) - s16(targetH), s16(l) - s16(targetL)
    else
        dh = band(h + 0x2800, 0xffff) - band(targetH + 0x2800, 0xffff)
        dl = band(l + 0x2800, 0xffff) - band(targetL + 0x2800, 0xffff)
    end
    local sector = dl < 0 and 1 or 5
    if dl < 0 then dl = -dl end
    if dh < 0 then dh, sector = -dh, sector + 2 end
    dl = dl + floor(dl / 2)
    if dl < dh then dh, dl, sector = dl, dh, sector + 1 end
    return dh, dl, sector
end

-- 0xadb48、0xade16、0xade8e 的 bcc 在余数等于半除数时保持原索引。
local function aimIndex(numerator, denominator)
    local remainder = numerator % denominator
    return 2 * floor(numerator / denominator) + (remainder > floor(denominator / 2) and 1 or 0)
end

-- 0x0adb08 的八区间和查表舍入，保留炮口量化边界。
function M.angle(h, l, targetH, targetL, current)
    local dh, dl, sector = aimSector(h, l, targetH, targetL)
    if dl == 0 then return current or 0 end
    local index = aimIndex(dh * 64, dl)
    local angle = byte(M.aim, index + 1)
    return band(floor((origin[sector] + turn[sector] * angle + 4) / 8), 0x3f)
end

function M.aimByte(h, l, targetH, targetL, current, playerShot)
    local dh, dl, sector = aimSector(h, l, targetH, targetL, playerShot)
    if dl == 0 then return current end
    local index = aimIndex(dh * 32, dl)
    return band(origin[sector] / 2 + turn[sector] * byte(M.player.aim, index + 1), 0xff)
end

function M.turnToward(current, target)
    local difference = band(target - current, 0x3f)
    if difference == 0 then return current end
    return band(current + (difference < 0x20 and 1 or -1), 0x3f)
end

-- 0xaefe6、0xaf36c 和 0xaf870 在取各自的 ROM 表之前递增同一个低字节。
function M.random(run, values)
    run.randomByte = (run.randomByte + 1) % 256
    local index = run.randomByte % #values + 1
    if type(values) == 'string' then return values:byte(index) end
    return values[index]
end

function M.canFire(number, route, h, l)
    local limits = M.aimLimits[route.loop + 1][number]
    return band(h - limits[2], 0xffff) + limits[1] < 0x10000
       and band(l - limits[4], 0xffff) + limits[3] < 0x10000
end

M.routes = {
    first = {loop=0, ura=false},
    omote = {loop=1, ura=false},
    ura = {loop=1, ura=true},
}

function M.rank(run)
    -- 0xca3ae–0xca446。二周目强制取 0xe8。一周目的输入是实时增量和武装等级。
    if run.route.loop == 1 then return 0xe8 end
    return math.min(0xe0, run.rankBase + floor(run.rankTime / 512) + run.weaponRank)
end

function M.smallRank(run)
    local rank = M.rank(run)
    return floor(rank / 4) + floor(rank / 16), floor(rank / 4) - floor(rank / 8)
end

function M.groundRank(run)
    local rank = M.rank(run)
    return floor(rank / 4), floor(rank / 2) + floor(rank / 16),
        floor(rank / 4) - floor(rank / 8) + floor(rank / 16)
end

local fireDistance = {0x1c00,0x1c00,0x1800,0x1400,0x1000}
function M.distance(h, l, targetH, targetL)
    local dh, dl = math.abs(s16(h - targetH)), math.abs(s16(l - targetL))
    dh = dh - floor(dh / 4)
    return math.max(dh, dl) + floor(math.min(dh, dl) / 2)
end

function M.groundFireDistance(run, h, l)
    return run.pilotH ~= nil and M.distance(h, l, run.pilotH, run.pilotL) >= fireDistance[run.stageNumber]
end

function M.groundCanFire(run, h, l)
    return M.canFire(run.stageNumber, run.route, h, l) and M.groundFireDistance(run, h, l)
end

function M.bulletSpeed(run, kind, modifier, adjusted)
    -- 0xf6cc8 在二周目提高该发射入口的速度，分配器另加路线和难度的修正。
    local base = M.bullet[kind + 1][3] + modifier + run.difficultySpeed
    if run.route.loop == 1 then
        base = base + (adjusted and 5 or 1)
        if run.route.ura then base = base + (run.uraBoss and 3 or 2) end
    end
    return band(base, 0xff)
end

function M.spawnRows(run, spawn)
    local rows = run.stage.spawns
    local index = run.spawnIndex
    local row = rows[index]
    while row and row[1] == run.major and row[2] == run.minor do
        spawn(run, row)
        index = index + 1
        row = rows[index]
    end
    run.spawnIndex = index
end

return M
