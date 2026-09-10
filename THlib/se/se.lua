--======================================
--THlib se
--======================================

----------------------------------------
---音效
local sounds = {}
for _, v in ipairs(FindFiles("THlib\\se\\", "wav", "")) do
    table.insert(sounds, v[1]:sub(13, -5))
end

for _, v in ipairs(sounds) do
    LoadSound(v, 'THlib\\se\\se_' .. v .. '.wav')
end
--修正的音量系统
--！警告：该修正方法有问题

local soundVolume = {
    bonus = 0.6, bonus2 = 0.6, boon00 = 0.9, boon01 = 0.7,
    cancel00 = 0.4, cardget = 0.8, cat00 = 0.55,
    ch00 = 0.9, ch02 = 1,
    don00 = 0.85, damage00 = 0.35, damage01 = 0.5,
    enep00 = 0.35, enep02 = 0.45, enep01 = 0.6, explode = 0.4, extend = 0.6,
    graze = 0.4, gun00 = 0.6, invalid = 0.8, item00 = 0.32,
    kira00 = 0.2, kira01 = 0.3, kira02 = 0.4,
    lazer00 = 0.13, lazer01 = 0.13, lazer02 = 0.15,
    lgods1 = 0.6, lgods2 = 0.3, lgods3 = 0.6, lgods4 = 0.6, lgodsget = 0.2,
    msl = 0.37, msl2 = 0.37, nep00 = 0.5, nodamage = 0.5,
    ok00 = 0.4, option = 0.7, pause = 0.5, pldead00 = 0.7, plst00 = 0.27,
    power0 = 0.7, power02 = 0.7, power1 = 0.6,
    powerup = 0.6, powerup1 = 0.55,
    select00 = 0.4, slash = 0.75,
    tan00 = 0.1, tan01 = 0.1, tan02 = 0.1,
    timeout = 0.6, timeout2 = 0.7, water = 0.6,
    piyo = 0.6, ufo = 0.8, ufoalert = 0.5, changeitem = 0.2,
}

---@param name string
---@param vol number
---@param pan number
---@param sndflag boolean
function PlaySound(name, vol, pan, sndflag)
    local v
    if not (sndflag) then
        v = soundVolume[name]
        if v == nil then
            v = vol
        end
    else
        v = vol
    end
    lstg.PlaySound(name, v or 1, (pan or 0) / 1024)
end

----------------------------------------
---钢琴音
sounds = {}
local PianoKey = {}--用来取琴键
local key = { ["C"] = 1, ["C#"] = 1.5,
              ["D"] = 2, ["D#"] = 2.5,
              ["E"] = 3,
              ["F"] = 4, ["F#"] = 4.5,
              ["G"] = 5, ["G#"] = 5.5,
              ["A"] = 6, ["A#"] = 6.5,
              ["B"] = 7 }
for _, v in ipairs(FindFiles("THlib\\se\\Piano\\", "ogg", "")) do
    table.insert(sounds, v[1]:sub(16, -5))
end
local m, n
for _, v in ipairs(sounds) do
    m, n = string.sub(v, 1, -2), string.sub(v, -1, -1)
    PianoKey[n] = PianoKey[n] or {}
    PianoKey[n][key[m]] = "Piano_" .. v
    LoadSound("Piano_" .. v, 'THlib\\se\\Piano\\' .. v .. ".ogg")
end

---输入速度与键位数据，弹钢琴
---必须在task里执行
---keys的格式为{{八度,键,时值},...}
---速度作为8分音符时值
---8分音符为v，4分音符为v*2，16分音符为v/2，以此类推
---@param v number|"8分音符时值"|
---@param keys table|"{{八度,键,时值},...}"
---@param off number|"偏八度"
---@param event function|"func(v[1],v[2],v[3])"
function PlayPiano(v, keys, off, event)
    local wait_c = 0
    off = off or 0
    event = event or (function()
    end)
    for _, k in ipairs(keys) do
        PlaySound(PianoKey[tostring(k[1] + off)][k[2]])
        event(k[1] + off, k[2], k[3] * v)
        task.Wait(k[3] * v)
        wait_c = wait_c + (k[3] * v - int(k[3] * v))
        for _ = 1, int(wait_c) do
            task.Wait()
            wait_c = wait_c - 1
        end
    end
end

