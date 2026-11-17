-- 0x1181c6 的敌机速度方向每档 16 字节，弹体则读取四分之一档。
local M = dofile('mod/GAME/th45/native/rom_data.lua')
local band = require('bit').band
local byte, floor = string.byte, math.floor
local path = 'mod/GAME/th45/native/rom_vectors.bin'
local vectors = assert(lstg.LoadTextFile(path), '无法加载 Espgaluda 定点速度表')
assert(#vectors == 2 * 256 * 0x400, 'Espgaluda 定点速度表长度错误')

function M.word(data, cursor)
    local hi,lo = byte(data,cursor,cursor + 1)
    return hi * 256 + lo
end

function M.s16(value)
    value = band(value,0xffff)
    return value >= 0x8000 and value - 0x10000 or value
end

function M.s8(value)
    return band(value+128,255)-128
end

function M.addPacked(h,l,value)
    local low = band(l,0xffff) + band(value,0xffff)
    return M.s16(h + floor(value / 0x10000) + floor(low / 0x10000)),M.s16(low)
end

function M.world(h,l) return l / 64 - 112,h / 64 - 224 end

function M.nextRandom(run,mask)
    run.randomIndex = band(run.randomIndex + 1,255)
    return band(run.randomIndex,mask or 255) + 1
end

function M.random(run,values,mask)
    return byte(values,M.nextRandom(run,mask))
end

function M.towards(current,target)
    current = band(current,63)
    local delta = band(target - current,63)
    if delta == 0 then return current end
    return band(current + (delta < 32 and 1 or -1),63)
end

-- 0x1191c6 的表按无符号差相加后的进位判断屏幕边缘。
function M.fireBand(o)
    local ht,h0,lt,l0 = unpack(M.fireBounds[o.run.stageNumber])
    return band(o.h - h0,0xffff) + ht < 0x10000 and band(o.l - l0,0xffff) + lt < 0x10000
end

function M.atPatrolDistance(o)
    local target = o.run.player
    if not target or not target.active then return false end
    local h,l = math.abs(o.h - target.h),math.abs(o.l - target.l)
    h = h - floor(h / 4)
    return math.max(h,l) + floor(math.min(h,l) / 2) >= M.patrolFireDistance[o.run.stageNumber]
end

function M.patrolFireBand(o)
    return M.fireBand(o) and M.atPatrolDistance(o)
end

function M.vector(speed,angle,slow)
    local column = ((slow and 256 or 0) + band(speed,255)) * 0x400 + band(angle,255) * 4 + 1
    return M.s16(M.word(vectors,column)),M.s16(M.word(vectors,column + 2))
end

-- 0x118b52 以无符号坐标差分八象限，横向差在查表前乘 1.5。
local aimSign = {1,-1,-1,1,-1,1,1,-1}
local function aim(h,l,target,current,lookup,precision)
    if not target or not target.active then return current end
    local dh = band(h + 0x2800,0xffff) - band(target.h + 0x2800,0xffff)
    local dl = band(l + 0x2800,0xffff) - band(target.l + 0x2800,0xffff)
    local octant = dl < 0 and 1 or 5
    dl = math.abs(dl)
    if dh < 0 then dh,octant = -dh,octant + 2 end
    dl = dl + floor(dl / 2)
    if dl < dh then dh,dl,octant = dl,dh,octant + 1 end
    if dl == 0 then return current end
    local scaled = dh * precision
    local index = floor(scaled / dl) * 2
    if (scaled % dl) * 2 > dl then index = index + 1 end
    return octant,aimSign[octant] * byte(lookup,index + 1)
end

local aimOffset = {0x80,0x100,0x80,0,0x180,0x100,0x180,0}
function M.angle(h,l,target,current)
    local sector,delta = aim(h,l,target,current,M.aim,64)
    if not delta then return sector end
    return band(floor((aimOffset[sector]+delta+4)/8),63)
end

-- 0x118e28 的查表输出直接用作八位弹角。
local aimOffset8 = {0x40,0x80,0x40,0,0xc0,0x80,0xc0,0}
function M.angle8(h,l,target,current)
    local sector,delta = aim(h,l,target,current,M.aim8,32)
    if not delta then return sector end
    return band(aimOffset8[sector]+delta,255)
end

return M
