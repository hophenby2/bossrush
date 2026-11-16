-- 大往生 V101 使用 16 位定点坐标和 256 方向速度表。
local bit = require('bit')
local band, lshift = bit.band, bit.lshift
local byte, floor = string.byte, math.floor
local directory = 'mod/GAME/th44/native/'
local M = dofile(directory .. 'rom_data.lua')
local vectors = assert(lstg.LoadTextFile(directory .. 'rom_vectors.bin'))
assert(#vectors == 256 * 65 * 4, '大往生速度表长度错误')

local function s16(n)
    n = band(n, 0xffff)
    return n < 0x8000 and n or n - 0x10000
end

local function word(data, cursor)
    local hi, lo = byte(data, cursor, cursor + 1)
    return hi * 256 + lo
end

M.s16, M.word = s16, word

-- 0x15f43a。读取 0x813000 工作区中的原版字偏移。断点回归可以直接给定当时的字段值。
function M.rank(run,offset,fixture)
    if run.ranks then return run.ranks[offset] end
    return run[fixture]
end

function M.updateRank(run)
    if not run.ranks then return end
    local p = run.player
    local hyper = p and p.hyperPower
    local raw = run.loop == 0 and 0x34 + 0x10 * run.difficulty + floor(run.rankTime / 0x100) or 0xf8
    if hyper then raw = raw + 0x10 * p.hyperRank end
    raw = math.min(raw,hyper and 0xff or 0xf0 + (run.loop == 0 and 0 or 8))
    local half,quarter,eighth,sixteenth = floor(raw / 2),floor(raw / 4),floor(raw / 8),floor(raw / 16)
    local ranks = run.ranks
    ranks[0x02],ranks[0x20] = raw,sixteenth
    ranks[0x04],ranks[0x06] = half + quarter + eighth + sixteenth,half + quarter + eighth
    ranks[0x08],ranks[0x0a] = half + quarter + sixteenth,half + quarter
    ranks[0x0c],ranks[0x0e] = half + quarter - eighth + sixteenth,half + quarter - eighth
    ranks[0x10],ranks[0x12] = half + sixteenth,half
    ranks[0x14],ranks[0x16] = quarter + eighth + sixteenth,quarter + eighth
    ranks[0x18],ranks[0x1a] = quarter + sixteenth,quarter
    ranks[0x1c],ranks[0x1e] = quarter - eighth + sixteenth,quarter - eighth
end

-- 0x14179a、0x182602 使用同一张表。先右移取整，再按象限翻转两个轴。
function M.vector(speed, angle)
    local direction = band(angle, 0x3f)
    if band(angle, 0x40) ~= 0 then direction = 64 - direction end
    local slot = (band(speed, 0xff) * 65 + direction) * 4 + 1
    local h, l = s16(word(vectors, slot)), s16(word(vectors, slot + 2))
    if band(angle + 0x40, 0x80) ~= 0 then h = -h end
    if band(angle, 0x80) ~= 0 then l = -l end
    return h, l
end

function M.world(h, l)
    return l / 64 - 112, h / 64 - 224
end

local origins = {0x80, 0x100, 0x80, 0, 0x180, 0x100, 0x180, 0}
local signs = {1, -1, -1, 1, -1, 1, 1, -1}

local function angleOctant(h, l, targetH, targetL)
    local dh = band(h + 0x1800, 0xffff) - band(targetH + 0x1800, 0xffff)
    local dl = band(l + 0x1800, 0xffff) - band(targetL + 0x1800, 0xffff)
    local sector = dl < 0 and 1 or 5
    if dl < 0 then dl = -dl end
    if dh < 0 then dh, sector = -dh, sector + 2 end
    dl = dl + floor(dl / 2)
    if dl < dh then dh, dl, sector = dl, dh, sector + 1 end
    return sector, dh, dl
end

-- 0x141fc6 用两个无符号坐标的差确定象限。纵横比经 0x14207e 量化。
function M.angle(h, l, targetH, targetL, current)
    local sector, dh, dl = angleOctant(h, l, targetH, targetL)
    if dl == 0 then return current end
    local scaled = dh * 64
    local quotient, remainder = floor(scaled / dl), scaled % dl
    local index = quotient * 2 + (2 * remainder > dl and 1 or 0)
    return band(floor((origins[sector] + signs[sector] * byte(M.aim, index + 1) + 4) / 8), 0x3f)
end

-- 0x14222a 用独立量化表返回 256 档方向。
function M.angle256(h, l, targetH, targetL, current)
    local sector, dh, dl = angleOctant(h, l, targetH, targetL)
    if dl == 0 then return current end
    local scaled = dh * 32
    local quotient, remainder = floor(scaled / dl), scaled % dl
    local index = quotient * 2 + (2 * remainder > dl and 1 or 0)
    return band(origins[sector] / 2 + signs[sector] * byte(M.aim256, index + 1), 0xff)
end

function M.randomEnemy(run)
    run.randomByte = band(run.randomByte + 1, 0xff)
    return byte(M.random, band(run.randomByte, 0x7f) + 1)
end

function M.bossWideRandom(run)
    run.randomByte = band(run.randomByte + 1, 0xff)
    return byte(M.dropRandom, run.randomByte + 1)
end

function M.bossRandom(run)
    run.randomByte = band(run.randomByte + 1, 0xff)
    local value = byte(M.boss1Angle, run.randomByte + 1)
    return value >= 0x80 and value - 0x100 or value
end

function M.bossSmallRandom(run)
    run.randomByte = band(run.randomByte + 1, 0xff)
    local value = byte(M.dropAngle, run.randomByte + 1)
    return value >= 0x80 and value - 0x100 or value
end

-- 0x143192 与敌机共用递增游标，只以低六位查询掉落参数。
function M.dropSpeedRandom(run)
    run.randomByte = band(run.randomByte + 1, 0xff)
    return byte(M.dropSpeed, band(run.randomByte, 0x3f) + 1)
end

function M.bossJitter(run)
    run.randomByte = band(run.randomByte + 1, 0xff)
    return M.boss1Jitter[band(run.randomByte,0x7f) + 1]
end

function M.addPacked(h, l, offsetH, offsetL)
    local packed = lshift(h, 16) + band(l, 0xffff) + lshift(offsetH, 16) + band(offsetL, 0xffff)
    return s16(bit.rshift(packed, 16)), s16(packed)
end

function M.inInterval(value, start, extent)
    return band(value - start, 0xffff) + extent < 0x10000
end

-- 0x14253a 只以 0x812ffc 是否为零选择两张表。
function M.inAimBounds(run, h, l)
    local box = M.aimBounds[run.loop == 0 and 1 or 2][run.stageNumber]
    return M.inInterval(h, box[1], box[2]) and M.inInterval(l, box[3], box[4])
end

-- 0x142592 的纵向检查始终使用第一张表。
function M.inAimHeight(run, h)
    local box = M.aimBounds[1][run.stageNumber]
    return M.inInterval(h, box[1], box[2])
end

-- 0x142118 每次只沿最短方向转一档。
function M.turn64(from, target)
    local diff = band(target - from, 0x3f)
    if diff == 0 then return from end
    return band(from + (diff < 0x20 and 1 or -1), 0x3f)
end

-- 0x1668a4 折减纵向距离，再取长轴加半个短轴。
function M.pilotDistance(o, pilot)
    if not pilot or not pilot.active then return 0x7fff end
    local h, l = math.abs(s16(o.h - pilot.h)), math.abs(s16(o.l - pilot.l))
    h = h - floor(h / 4)
    return math.max(h, l) + floor(math.min(h, l) / 2)
end

-- 0x161c4c 匹配主计数。越过生成点或槽位用尽的记录都在原程序中消费。
function M.spawnRows(run, spawn)
    local rows = run.stage.spawns
    local cursor = run.spawnIndex
    while rows[cursor] and rows[cursor][1] <= run.major do
        local row = rows[cursor]
        cursor = cursor + 1
        if row[1] == run.major then spawn(run, row) end
    end
    run.spawnIndex = cursor
end

return M
