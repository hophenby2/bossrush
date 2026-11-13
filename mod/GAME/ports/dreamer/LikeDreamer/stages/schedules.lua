-- Like Dreamer original stage spawn schedules.
-- Coordinates and frame numbers intentionally remain in the original 600x720
-- logical space. Conversion to LuaSTG world space belongs to the runtime.

local S = {}
LikeDreamer = LikeDreamer or {}
LikeDreamer.Schedules = S

local function window(f, start, duration, step)
    local n = f - start
    return n >= 0 and n < duration and n % step == 0
end

local function spawn(rt, f, type_id, hp, x, y, note)
    rt:spawn(type_id, hp, x, y, note)
end

local function rand_coord(rt, f, modulus, base)
    return rt:randomCoord(f, modulus, base)
end

local function reverse_rand_coord(rt, f, modulus, base)
    return base - rt:randomCoord(f, modulus, 0)
end

local function trunc(n)
    if n < 0 then return math.ceil(n) end
    return math.floor(n)
end

local function each_point(points, fn)
    for i = 1, #points do
        fn(points[i][1], points[i][2], i)
    end
end

local stage02_early_1d = {
    {510, -135}, {605, -212}, {385, -220}, {265, -445},
    {130, -475}, {220, -545}, {530, -580}, {610, -685},
    {465, -695}, {260, -2805}, {100, -2840}, {365, -2880},
    {220, -2930}, {345, -3000}, {140, -3040}, {350, -3390},
    {590, -3390}, {350, -3660}, {615, -3660},
}

local stage02_early_1e = {
    {485, -305}, {175, -310}, {345, -410},
    {165, -630}, {444, -795}, {620, -795},
}

local stage02_late_1d = {
    {95, -210}, {230, -185}, {390, -195}, {535, -240},
    {650, -330}, {222, -595}, {477, -660}, {80, -760},
    {420, -790}, {430, -1245}, {320, -1655}, {565, -1245},
    {356, -1320}, {630, -1320}, {200, -1625}, {100, -1685},
    {380, -1740},
}

local stage02_late_1e = {
    {360, -590}, {110, -620}, {540, -760}, {110, -895}, {420, -895},
}

local stage03_early_2c = {
    {385, -190}, {600, -190}, {490, -280}, {350, -390},
    {630, -390}, {350, -630}, {630, -630},
}

local stage03_middle_2c = {
    {70, -155}, {350, -155}, {95, -345},
    {330, -345}, {95, -495}, {145, -660},
}

local stage03_late_2c = {
    {100, -155}, {235, -155}, {490, -155}, {635, -155},
    {550, -280}, {620, -400}, {485, -440}, {65, -470},
    {190, -530}, {130, -635}, {240, -635},
}

local stage06_formation1_small = {
    {305, -185}, {545, -195}, {210, -300}, {395, -290}, {515, -340},
    {650, -315}, {430, -470}, {80, -945}, {200, -935}, {333, -935},
    {470, -950}, {650, -1035}, {55, -1080}, {395, -1085}, {540, -1120},
    {120, -4520}, {600, -4520}, {80, -4670}, {395, -4715}, {505, -4660},
    {640, -4675},
}

local stage06_formation1_medium = {
    {300, -430}, {560, -465}, {615, -1240}, {465, -1285},
    {120, -3030}, {285, -3165}, {435, -3285}, {590, -3390},
    {100, -4350}, {265, -4315}, {455, -4315}, {620, -4350},
}

local stage06_formation1_large = {
    {235, -1100}, {550, -1470}, {465, -3845}, {230, -4005}, {240, -4735},
}

local stage06_formation2_small = {
    {100, -220}, {215, -225}, {660, -220}, {60, -360}, {175, -360},
    {375, -370}, {505, -370}, {620, -355}, {290, -465}, {410, -520},
    {285, -740}, {395, -810}, {290, -900}, {430, -930}, {500, -1255},
    {630, -1230}, {75, -3020}, {514, -3010}, {634, -2990}, {128, -3175},
    {260, -3160}, {80, -3310}, {385, -3360}, {515, -3380}, {645, -3370},
}

local stage06_formation2_medium = {
    {350, -235}, {520, -235}, {380, -660}, {215, -3000}, {375, -3000},
}

local stage06_formation2_large = {
    {605, -770}, {520, -2745}, {230, -3350},
}

local stage08_opening_97 = {
    {160, -1810}, {360, -1810}, {560, -1810},
    {90, -4570}, {530, -4570}, {640, -4570},
}

local stage08_early_99 = {
    {-180, 240}, {-250, 120}, {-180, 0},
    {900, 240}, {970, 120}, {900, 0},
}

local stage08_early_96 = {
    {125, 40}, {140, 140}, {205, 20}, {220, 120},
    {300, 0}, {300, 140}, {360, 70}, {595, 40},
    {580, 140}, {515, 20}, {500, 120}, {420, 0},
    {420, 140}, {360, 190}, {180, 240}, {540, 240},
    {270, 445}, {450, 445}, {200, 465}, {520, 465},
    {130, 480}, {590, 480}, {180, 570}, {540, 570},
    {110, 595}, {610, 595},
}

local stage08_late_96 = {
    {360, 40}, {275, 70}, {445, 70}, {120, 335}, {205, 290},
    {310, 300}, {590, 350}, {550, 450}, {440, 470}, {145, 450},
}

local stage08_type_1d = {
    {310, -430}, {415, -470}, {512, -430},
    {600, -4520}, {660, -4600}, {80, -4640},
}

local stage08_type_2c = {
    {60, -1790}, {265, -1790}, {465, -1790},
    {660, -1790}, {85, -4030}, {635, -4030},
}

local stage08_type_5a = {
    {108, -470}, {215, -500}, {610, -500},
    {110, -4540}, {495, -4540}, {565, -4650},
}

local stage08_type_1e = {{400, -2795}, {640, -2795}}
local stage08_type_2d = {{230, -4065}, {490, -4065}}
local stage08_type_5d = {
    {160, -1850}, {360, -1850}, {560, -1850}, {245, -2280},
    {140, -2440}, {240, -2600}, {225, -4580}, {380, -4580},
}
local stage08_type_97 = {
    {120, -5480}, {600, -5480}, {185, -5590}, {535, -5590},
}

local function stage01(rt, f)
    local function sp(type_id, hp, x, y, note)
        spawn(rt, f, type_id, hp, x, y, note)
    end
    local function spawn_0b_top(hp, modulus, base, note)
        sp(0x0b, hp, rand_coord(rt, f, modulus, base), -20, note)
    end
    local function spawn_0b_left(hp, modulus, base, note)
        sp(0x0b, hp, -20, rand_coord(rt, f, modulus, base), note)
    end
    local function spawn_0b_right(hp, modulus, base, note)
        sp(0x0b, hp, 0x2e4, rand_coord(rt, f, modulus, base), note)
    end
    local function spawn_0c_top(note)
        sp(0x0c, 400, rand_coord(rt, f, 0x191, 0xa0), -20, note)
    end
    local function spawn_0d_left(hp, modulus, base, note)
        sp(0x0d, hp, -20, rand_coord(rt, f, modulus, base), note)
    end
    local function spawn_0d_right(hp, modulus, base, note)
        sp(0x0d, hp, 0x2e4, rand_coord(rt, f, modulus, base), note)
    end

    if f == 200 then sp(0x0a, 0x960, 0x1e0, 0x96, "S01 original line 27: 0x0a fixed early entry") end
    if f == 0x104 then sp(0x0a, 0x960, 0x0f0, 200, "S01 original line 30: 0x0a fixed follow-up") end
    if f == 0x15e then sp(0x0a, 2000, 0x208, 100, "S01 original line 33: 0x0a fixed lane") end
    if f == 0x16d then sp(0x0a, 2000, 0x168, 100, "S01 original line 36: 0x0a fixed lane") end
    if f == 0x17c then sp(0x0a, 2000, 200, 100, "S01 original line 39: 0x0a fixed lane") end

    if window(f, 600, 0x50, 0x14) then
        spawn_0b_top(400, 0x12d, 0x3c, "S01 original line 50: 0x0b top random entry")
    end
    if f == 700 then sp(0x06, 5000, 0x1cc, 0, "S01 original line 54: common marker/emitter") end
    if f == 900 then sp(0x0e, 10000, 0x118, 0, "S01 original line 58: 0x0e long setpiece") end
    if f == 0x44c then sp(0x0e, 10000, 0x1cc, 0, "S01 original line 62: 0x0e long setpiece") end

    if window(f, 0x514, 0x96, 0x14) then
        spawn_0c_top("S01 original line 73: 0x0c top random entry")
    end
    if window(f, 0x60e, 300, 0x1e) then
        spawn_0d_right(700, 0x65, 0xfa, "S01 original line 84: 0x0d right random entry")
    end
    if window(f, 0x78a, 0x78, 0x14) then
        spawn_0b_left(500, 0xc9, 100, "S01 original line 95: 0x0b left random entry")
    end
    if window(f, 0x834, 0x50, 0x14) then
        spawn_0b_right(500, 0xc9, 100, "S01 original line 106: 0x0b right random entry")
    end
    if f == 0x898 then sp(0x0f, 8000, 0x348, 0x96, "S01 original line 110: 0x0f side setpiece") end
    if window(f, 0x8ca, 200, 0x1e) then
        spawn_0d_left(700, 0x65, 0xfa, "S01 original line 121: 0x0d left random entry")
    end
    if window(f, 0x9f6, 100, 10) then
        spawn_0b_top(400, 0x191, 0xa0, "S01 original line 132: 0x0b top burst")
    end
    if f == 0xabe then
        sp(0x10, 40000, 0x168, 0x50, "S01 original line 137: 0x10 long setpiece; sets DAT_140e418cc")
        rt.gate = true
    end

    if not rt.gate and f >= 0xaf0 and f < 0xdde then
        local n = (f - 0xaf0) % 0x96
        if n < 100 and n % 0x0c == 0 then
            spawn_0c_top("S01 original line 155: gated 0x0c top burst")
        end
    end
    if not rt.gate and f == 0xe10 then
        sp(0x0e, 7000, 0x168, 0, "S01 original line 159: gate-open 0x0e setpiece")
    end
    if window(f, 0xed8, 0xa0, 0x14) then
        spawn_0b_right(500, 0xc9, 100, "S01 original line 173: later 0x0b right random entry")
    end
    if window(f, 0xf3c, 200, 0x1e) then
        spawn_0d_left(500, 0x65, 300, "S01 original line 185: later 0x0d left low entry")
    end
    if f == 0x1068 then sp(0x0e, 7000, 0x1cc, 0, "S01 original line 189: later 0x0e setpiece") end
    if f == 0x1108 then sp(0x0f, 8000, -120, 100, "S01 original line 193: later 0x0f side setpiece; original x 0xffffff88") end
    if f >= 0x1194 and f < 0x1194 + 200 then
        local n = (f - 0x1194) % 0x96
        if n < 100 and n % 0x10 == 0 then
            spawn_0c_top("S01 original line 209: later gated 0x0c top burst")
        end
    end
    if window(f, 0x122a, 200, 0x1e) then
        spawn_0d_left(500, 0x65, 0xfa, "S01 original line 221: later 0x0d left random entry")
    end
    if window(f, 0x1324, 0x96, 0x14) then
        spawn_0b_top(400, 0xc9, 0x168, "S01 original line 233: final 0x0b top random entry")
    end
    if f == 0x13ec then sp(0x08, 5000, 0x104, 0, "S01 original line 237: ending marker/emitter") end

    if f == 5760 then
        sp(0x138, 100000, 360, 200, "S01 boss handoff: endFrame + 0x3c entity 0x138")
        rt.gate = true
    end
end

local function stage02(rt, f)
    local function sp(type_id, hp, x, y, note)
        spawn(rt, f, type_id, hp, x, y, note)
    end

    if window(f, 0x10e, 0x78, 0x1e) then
        sp(0x19, 800, f * 4 - 0x398, -20, "S02 original line 53: 0x19 linear top wave")
    end
    if window(f, 0x1cc, 0xbe, 0x0e) then
        sp(0x1a, 300, rand_coord(rt, f, 0xfb, 0x104), -20, "S02 original line 64: 0x1a random top wave")
    end
    if f == 700 then sp(0x07, 5000, 0x104, 0, "S02 original line 68: common marker") end
    if f == 800 then
        each_point(stage02_early_1d, function(x, y)
            sp(0x1d, 0x6a4, x, y, "S02 original line 99: early 0x1d path point")
        end)
        each_point(stage02_early_1e, function(x, y)
            sp(0x1e, 0x834, x, y, "S02 original line 105: early 0x1e path point")
        end)
        sp(0x1f, 11000, 0x1e4, -0xdbe, "S02 original line 109: early 0x1f controller")
    end
    if window(f, 0x546, 100, 0x12) then
        sp(0x0b, 400, 0x2e4, rand_coord(rt, f, 0xc9, 100), "S02 original line 120: common right wave")
    end
    if f == 0x6a4 then sp(0x1b, 0x1130, 0x104, 0, "S02 original line 124: 0x1b anchor") end
    if f == 0x708 then sp(0x1b, 0x1130, 0x1cc, 0, "S02 original line 128: 0x1b anchor") end
    if window(f, 0x708, 200, 0x19) then
        sp(0x0d, 400, -20, rand_coord(rt, f, 0x65, 0x96), "S02 original line 139: common left wave")
    end
    if window(f, 0x7ee, 100, 0x14) then
        sp(0x19, 500, rand_coord(rt, f, 0xc9, 0x168), -20, "S02 original line 150: 0x19 random top wave")
    end
    if window(f, 0x898, 0x32, 10) then
        sp(0x1a, 300, rand_coord(rt, f, 0x12d, 0xa0), -20, "S02 original line 161: 0x1a random top wave")
    end
    if f == 0x8ca then sp(0x1b, 0x1130, 0xf0, 0, "S02 original line 165: 0x1b anchor") end
    if window(f, 0x92e, 100, 0x12) then
        sp(0x0b, 400, 0x2e4, rand_coord(rt, f, 0x97, 100), "S02 original line 176: common right wave")
    end
    if window(f, 0x992, 100, 0x12) then
        sp(0x0b, 400, -20, rand_coord(rt, f, 0x97, 100), "S02 original line 187: common left wave")
    end
    if f == 0xa28 then sp(0x1c, 6000, 0x348, 0x32, "S02 original line 191: right 0x1c setpiece") end
    if window(f, 0xaa0, 0xa0, 0x0f) then
        sp(0x1a, 300, rand_coord(rt, f, 0x12d, 0xd2), -20, "S02 original line 202: 0x1a random top wave")
    end
    if f == 0xb54 then sp(0x1c, 6000, -120, 100, "S02 original line 206: left 0x1c setpiece") end
    if window(f, 3000, 100, 0x0f) then
        sp(0x0b, 400, rand_coord(rt, f, 0x191, 0xa0), -20, "S02 original line 217: common top wave")
    end
    if window(f, 0xc4e, 100, 0x14) then
        sp(0x19, 700, rand_coord(rt, f, 0x191, 0xa0), -20, "S02 original line 228: 0x19 random top wave")
    end
    if f == 0xce4 then sp(0x1b, 4000, 0x168, 0, "S02 original line 232: 0x1b anchor") end
    if f == 0xd34 then sp(0x1b, 4000, 0x1fe, 0, "S02 original line 236: 0x1b anchor") end
    if window(f, 0xd7a, 100, 0x0f) then
        sp(0x1a, 300, rand_coord(rt, f, 0x12d, 0xd2), -20, "S02 original line 247: 0x1a random top wave")
    end
    if f == 0xe74 then sp(0x1c, 5000, 0x348, 0x50, "S02 original line 251: right 0x1c setpiece") end
    if window(f, 0xf64, 0x8c, 0x14) then
        sp(0x19, 700, rand_coord(rt, f, 0x191, 0xa0), -20, "S02 original line 262: 0x19 random top wave")
    end
    if window(f, 0x11bc, 0x6e, 0x0f) then
        sp(0x0b, 400, -20, rand_coord(rt, f, 0x97, 100), "S02 original line 273: common left wave")
    end
    if f == 0x1248 then sp(0x1b, 0xe10, 0x1e0, 0, "S02 original line 277: 0x1b anchor") end
    if f == 0x1298 then sp(0x1b, 0xe10, 0xf0, 0, "S02 original line 281: 0x1b anchor") end
    if window(f, 0x12d4, 0x28, 10) then
        sp(0x1a, 300, rand_coord(rt, f, 0x12d, 0xd2), -20, "S02 original line 292: 0x1a random top wave")
    end
    if f == 0x1306 then sp(0x1c, 0x1068, 0x348, 0x50, "S02 original line 296: right 0x1c setpiece") end
    if f == 0x136a then sp(0x1c, 0x1068, -120, 0x50, "S02 original line 300: left 0x1c setpiece") end
    if f == 0x13ce then sp(0x1c, 0x1068, 0x348, 0x50, "S02 original line 304: right 0x1c setpiece") end
    if window(f, 0x1482, 0x96, 8) then
        sp(0x1a, 300, rand_coord(rt, f, 0x259, 0x3c), 0, "S02 original line 320: 0x1a wide random wave")
    end
    if f == 0x14b4 then
        sp(0x20, 0x2b5c, 0x168, -500, "S02 original line 326: 0x20 gated controller")
        rt.gate = true
    end

    if not rt.gate and f >= 0x157c and f < 0x157c + 900 then
        if window(f, 0x1748, 0x154, 0x50) then
            sp(0x0a, 1000, rand_coord(rt, f, 0x1f5, 0x6e), 0x32, "S02 original line 339: gate-open common wave")
        end
        if (f - 0x157c) % 0x10 == 0 then
            sp(0x1a, 300, rand_coord(rt, f, 0x259, 0x3c), 0, "S02 original line 355: gate-open 0x1a wave")
        end
    end

    if f == 0x1978 or f == 0x19dc or f == 0x1a40 or f == 0x1a68 or f == 0x1a90 then
        sp(0x19, 500, 0x6e, -20, "S02 original line 362: six-lane 0x19 wall")
        sp(0x19, 500, 0xd2, -20, "S02 original line 363: six-lane 0x19 wall")
        sp(0x19, 500, 0x136, -20, "S02 original line 364: six-lane 0x19 wall")
        sp(0x19, 500, 0x19a, -20, "S02 original line 365: six-lane 0x19 wall")
        sp(0x19, 500, 0x1fe, -20, "S02 original line 366: six-lane 0x19 wall")
        sp(0x19, 500, 0x262, -20, "S02 original line 367: six-lane 0x19 wall")
    end
    if window(f, 0x1b1c, 0x3c, 0x0c) then
        sp(0x0b, 400, rand_coord(rt, f, 0xfb, 0x6e), -20, "S02 original line 378: common top wave")
    end
    if window(f, 7000, 0x3c, 0x0c) then
        sp(0x0b, 400, 0x2e4, rand_coord(rt, f, 0x97, 100), "S02 original line 389: common right wave")
    end
    if f == 0x1bbc then sp(0x1b, 0xc80, 0x230, 0, "S02 original line 393: 0x1b anchor") end
    if f == 0x1bee then sp(0x1b, 0xc80, 0x168, 0, "S02 original line 397: 0x1b anchor") end
    if f == 0x1c20 then
        sp(0x1b, 0xc80, 0xa0, 0, "S02 original line 401: 0x1b anchor")
        each_point(stage02_late_1d, function(x, y)
            sp(0x1d, 0x5dc, x, y, "S02 original line 427: late 0x1d path point")
        end)
        each_point(stage02_late_1e, function(x, y)
            sp(0x1e, 2000, x, y, "S02 original line 432: late 0x1e path point")
        end)
        sp(0x1f, 8000, 0x104, -810, "S02 original line 436: late 0x1f controller")
        sp(0x1f, 8000, 0x1f9, -1425, "S02 original line 437: late 0x1f controller")
        sp(0x1f, 8000, 0xe6, -1820, "S02 original line 438: late 0x1f controller")
    end
    if window(f, 0x1d88, 0x8c, 0x10) then
        sp(0x19, 500, rand_coord(rt, f, 0x15f, 0xa0), -20, "S02 original line 455: 0x19 random top wave")
    end
    if f == 0x2080 then sp(0x1c, 6000, -120, 100, "S02 original line 460: left 0x1c setpiece") end
    if window(f, 0x21de, 0x82, 0x0c) then
        sp(0x0b, 300, rand_coord(rt, f, 0x12d, 0x6e), -20, "S02 original line 472: common top wave")
    end
    if f == 0x238c then sp(0x08, 5000, 0x1cc, 0, "S02 original line 476: ending marker") end

    if f == 9760 then sp(0x139, 100000, 360, 180, "S02 boss handoff: endFrame + 0x3c entity 0x139") end
end

local function stage03(rt, f)
    local function sp(type_id, hp, x, y, note)
        spawn(rt, f, type_id, hp, x, y, note)
    end

    if window(f, 0x10e, 200, 0x23) then
        sp(0x25, 700, rand_coord(rt, f, 0x1e1, 0x78), -20, "S03 original line 43: 0x25 early random top wave")
    end
    if f == 500 then sp(0x26, 5000, 0x208, -20, "S03 original line 47: 0x26 fixed top anchor") end
    if f == 600 then sp(0x26, 5000, 200, -20, "S03 original line 51: 0x26 fixed top anchor") end
    if window(f, 700, 0x96, 0x18) then
        sp(0x25, 600, rand_coord(rt, f, 0x1a5, 0xb4), -20, "S03 original line 62: 0x25 random top wave")
    end
    if f == 0x3ac then sp(0x27, 7000, 0x21c, 300, "S03 original line 66: 0x27 right setpiece") end
    if f == 0x47e then sp(0x29, 7000, 0xb4, 0xfa, "S03 original line 70: 0x29 left setpiece") end
    if f == 0x546 then sp(0x07, 5000, 0x1cc, 0, "S03 original line 74: common marker") end
    if f == 0x5dc then
        each_point(stage03_early_2c, function(x, y)
            sp(0x2c, 0x640, x, y, "S03 original line 86: early 0x2c path point")
        end)
        sp(0x2d, 6000, 0x1ea, -600, "S03 original line 90: early 0x2d controller")
    end
    if window(f, 0x5dc, 500, 0x30) then
        sp(0x25, 500, rand_coord(rt, f, 0xc9, 0xa0), -20, "S03 original line 101: 0x25 path-overlap top wave")
    end
    if window(f, 0x8fc, 0x96, 0x10) then
        sp(0x0b, 300, -20, rand_coord(rt, f, 0x97, 0x96), "S03 original line 117: common left wave")
    end
    if f == 0x992 then sp(0x29, 6000, 0x1e0, 300, "S03 original line 122: 0x29 center setpiece") end
    if window(f, 0xa8c, 0x96, 10) then
        sp(0x0b, 300, rand_coord(rt, f, 0x191, 0xa0), -20, "S03 original line 133: common top wave")
    end
    if f == 0xb40 then
        sp(0x2e, 65000, 0x168, -120, "S03 original line 138: gated 0x2e controller")
        rt.gate = true
    end
    if not rt.gate and window(f, 3000, 0x514, 0x2d) then
        sp(0x25, 500, rand_coord(rt, f, 0x141, 200), -20, "S03 original line 150: gate-open 0x25 top wave")
    end
    if not rt.gate and window(f, 3000, 0x514, 0x15) then
        sp(0x0b, 300, rand_coord(rt, f, 0x191, 0xa0), -20, "S03 original line 161: gate-open common top wave")
    end

    if f == 0x1130 then
        each_point(stage03_middle_2c, function(x, y)
            sp(0x2c, 0x5dc, x, y, "S03 original line 173: middle 0x2c path point")
        end)
        sp(0x2d, 0x1518, 0xd2, -225, "S03 original line 177: middle 0x2d controller")
        sp(0x2d, 0x1518, 0x113, -580, "S03 original line 178: middle 0x2d controller")
        sp(0x26, 5000, 0x21c, -20, "S03 original line 181: middle 0x26 anchor")
    end
    if window(f, 0x12c0, 0x78, 0x0c) then
        sp(0x0b, 300, 0x2e4, rand_coord(rt, f, 0x97, 0x96), "S03 original line 193: common right wave")
    end
    if window(f, 0x141e, 200, 0x1e) then
        sp(0x25, 500, rand_coord(rt, f, 0x12d, 0x104), -20, "S03 original line 204: 0x25 random top wave")
    end
    if f == 0x14a0 then sp(0x26, 4000, 0xd2, -20, "S03 original line 208: 0x26 fixed top anchor") end
    if f == 0x1518 then sp(0x27, 7000, 0x21c, 300, "S03 original line 212: 0x27 right setpiece") end
    if f == 0x15e0 then sp(0x2b, 12000, 0x1b8, 0, "S03 original line 216: 0x2b center setpiece") end
    if window(f, 0x1676, 100, 0x0c) then
        sp(0x0b, 300, rand_coord(rt, f, 0x15f, 0x6e), -20, "S03 original line 227: common top wave")
    end
    if f == 0x170c then sp(0x26, 5000, 0x168, -20, "S03 original line 231: 0x26 center anchor") end
    if window(f, 0x173e, 0x82, 0x19) then
        sp(0x25, 500, rand_coord(rt, f, 0x191, 0xa0), -20, "S03 original line 242: 0x25 random top wave")
    end
    if f == 0x17d4 then sp(0x26, 5000, 200, -20, "S03 original line 246: 0x26 fixed top anchor") end
    if window(f, 0x1806, 0x82, 0x14) then
        sp(0x0b, 300, rand_coord(rt, f, 0x12d, 0x104), -20, "S03 original line 257: common top wave")
    end
    if f == 0x189c then sp(0x26, 5000, 0x208, -20, "S03 original line 261: 0x26 fixed top anchor") end
    if window(f, 0x18ce, 0x82, 0x14) then
        sp(0x0b, 300, rand_coord(rt, f, 0x12d, 0xa0), -20, "S03 original line 272: common top wave")
    end
    if f == 0x1946 then sp(0x26, 4000, 0xf0, -20, "S03 original line 276: 0x26 left anchor") end
    if f == 0x1964 then sp(0x26, 4000, 0x1e0, -20, "S03 original line 280: 0x26 right anchor") end
    if f == 0x19f0 then sp(0x29, 4000, 0xf0, 300, "S03 original line 284: 0x29 left setpiece") end
    if f == 0x1a2c then sp(0x29, 4000, 0x1e0, 0xfa, "S03 original line 288: 0x29 right setpiece") end
    if window(f, 0x1acc, 0x5a, 0x0f) then
        sp(0x25, 400, rand_coord(rt, f, 0x191, 0xa0), -20, "S03 original line 299: 0x25 random top wave")
    end
    if f == 7000 then sp(0x2b, 12000, 0x118, 0, "S03 original line 303: 0x2b left setpiece") end
    if window(f, 0x1bf8, 0xf0, 0x1e) then
        sp(0x25, 500, rand_coord(rt, f, 0x191, 0xa0), -20, "S03 original line 314: 0x25 random top wave")
    end
    if f == 0x1c84 then
        each_point(stage03_late_2c, function(x, y)
            sp(0x2c, 0x578, x, y, "S03 original line 330: late 0x2c path point")
        end)
        sp(0x2d, 0x1068, 0xa5, -350, "S03 original line 334: late 0x2d controller")
        sp(0x2d, 0x1068, 0x235, -605, "S03 original line 335: late 0x2d controller")
    end
    if window(f, 0x1dec, 0x186, 0x32) then
        sp(0x25, 500, rand_coord(rt, f, 0x191, 0xa0), -20, "S03 original line 346: 0x25 random top wave")
    end
    if window(f, 0x1fa4, 100, 0x14) then
        sp(0x25, 400, rand_coord(rt, f, 0xc9, 0x104), -20, "S03 original line 357: 0x25 narrow top wave")
    end
    if f == 0x2008 then sp(0x26, 6000, 0x168, -20, "S03 original line 361: 0x26 center anchor") end
    if f == 0x209e then sp(0x27, 6000, 0x1e0, 300, "S03 original line 365: 0x27 center setpiece") end
    if f == 0x20d0 then sp(0x29, 5000, 0xf0, 0xfa, "S03 original line 369: 0x29 left setpiece") end
    if window(f, 0x2198, 100, 0x10) then
        sp(0x0b, 300, rand_coord(rt, f, 0x191, 0xa0), -20, "S03 original line 385: common top wave")
    end
    if f == 0x21fc then sp(0x2b, 12000, 0x1b8, 0, "S03 original line 390: 0x2b center setpiece") end
    if f == 0x22f6 then sp(0x08, 5000, 0x104, 0, "S03 original line 394: ending marker") end

    if f == 9560 then sp(0x13a, 100000, 360, 200, "S03 boss handoff: endFrame + 0x3c entity 0x13a") end
end

local function stage04(rt, f)
    local function sp(type_id, hp, x, y, note)
        spawn(rt, f, type_id, hp, x, y, note)
    end
    local function spawn_every(start, duration, step, type_id, hp, x, y, note)
        if window(f, start, duration, step) then sp(type_id, hp, x, y, note) end
    end
    local function rc(modulus, base)
        return rand_coord(rt, f, modulus, base)
    end
    local function spawn_37(modulus_x, base_x, note)
        sp(0x37, 500, rc(modulus_x, base_x), rc(0x97, 400), note)
    end
    local function spawn_36_left(note)
        sp(0x36, 400, -20, rc(0xc9, 300), note)
    end
    local function spawn_36_right(note)
        sp(0x36, 400, 0x2e4, rc(0xc9, 300), note)
    end
    local function spawn_0b_top(hp, modulus, base, note)
        sp(0x0b, hp, rc(modulus, base), -20, note)
    end
    local function spawn_0b_left(hp, modulus, base, note)
        sp(0x0b, hp, -20, rc(modulus, base), note)
    end
    local function spawn_0b_right(hp, modulus, base, note)
        sp(0x0b, hp, 0x2e4, rc(modulus, base), note)
    end

    if window(f, 0x96, 0x15e, 0x14) then spawn_37(0x191, 0xa0, "S04 original row 33: 0x37 random drifter") end
    spawn_every(700, 100, 8, 0x35, 0xfa, 0x2e4, 0x96, "S04 original row 45: 0x35 right wave")
    if f == 800 then sp(0x38, 5000, 0x1e0, 0, "S04 original row 50: 0x38 center heavy") end
    spawn_every(900, 100, 8, 0x35, 0xfa, -20, 0x96, "S04 original row 60: 0x35 left wave")
    if f == 1000 then sp(0x38, 5000, 0xf0, 0, "S04 original row 65: 0x38 left heavy") end
    spawn_every(0x44c, 100, 8, 0x35, 0xfa, 0x2e4, 400, "S04 original row 75: 0x35 right lower wave")
    spawn_every(0x4d8, 100, 8, 0x35, 0xfa, -20, 400, "S04 original row 86: 0x35 left lower wave")
    if window(f, 0x4d8, 0x50, 0x10) then spawn_37(0x191, 0xa0, "S04 original row 104: 0x37 drifter refresh") end
    if f == 0x578 then sp(7, 5000, 0x1cc, 0, "S04 original row 111: common marker") end
    if f == 0x60e then sp(0x3d, 9000, -200, 0x96, "S04 original row 115: 0x3d left anchor") end
    if window(f, 0x6d6, 0x226, 0x78) then spawn_36_left("S04 original row 126: 0x36 left timed") end
    if window(f, 0x712, 0x1ea, 0x78) then spawn_36_right("S04 original row 137: 0x36 right timed") end
    if f == 0x708 then sp(0x38, 4000, 500, 0, "S04 original row 141: 0x38 heavy slot") end
    if f == 0x76c then sp(0x38, 4000, 0xdc, 0, "S04 original row 145: 0x38 heavy slot") end
    if f == 0x834 then sp(0x3d, 7000, 0x398, 0x96, "S04 original row 149: 0x3d right anchor") end
    if f == 0x8fc then sp(0x38, 0x1194, 0xf0, 0, "S04 original row 153: 0x38 long left") end
    if f == 0x960 then sp(0x38, 0x1194, 0x1e0, 0, "S04 original row 157: 0x38 long center") end
    spawn_every(0x99c, 0x50, 8, 0x35, 0xfa, -20, 0x78, "S04 original row 167: 0x35 left high wave")
    if f == 0xa5a then sp(0x3a, 10000, -80, 200, "S04 original row 172: 0x3a carrier") end
    if f == 0xb22 then sp(0x39, 8000, 0x262, -80, "S04 original row 176: 0x39 carrier") end
    if f == 0xbea then sp(0x39, 8000, 0x6e, -80, "S04 original row 180: 0x39 carrier") end
    if f == 0xcb2 then sp(0x3a, 8000, 800, 200, "S04 original row 184: 0x3a carrier") end
    for base = 0xaf0, 0xaf0 + 599, 200 do
        if window(f, base, 0x3c, 0x1e) then
            spawn_0b_top(400, 0xf1, 0x168, "S04 original row 196: common top burst A")
        end
    end
    for base = 0xb54, 0xb54 + 499, 200 do
        if window(f, base, 0x3c, 0x1e) then
            spawn_0b_top(400, 0xf1, 0x78, "S04 original row 208: common top burst B")
        end
    end
    if window(f, 0xd34, 0x46, 0x14) then spawn_36_left("S04 original row 219: 0x36 late left") end
    if window(f, 0xd3e, 0x3c, 0x14) then spawn_36_right("S04 original row 230: 0x36 late right") end
    if f == 0xe10 then
        sp(0x3f, 48000, 0x167, 0, "S04 original row 235: 0x3f controller")
        rt.gate = true
    end
    if not rt.gate and (window(f, 0xe74, 0x1158 - 0xe74, 8) or window(f, 0x1194, 0x96, 8)) then
        sp(0x35, 200, 0x2e4, 0x8c, "S04 original row 256: gated boss-side right")
        sp(0x35, 200, -20, 0x8c, "S04 original row 257: gated boss-side left")
    end
    if f == 0x125c then sp(0x3d, 9000, -200, 0x96, "S04 original row 262: 0x3d refresh") end
    if window(f, 0x12f2, 100, 0x0c) then spawn_0b_top(0xfa, 0xf1, 0x168, "S04 original row 273: 0x0b short top") end
    if window(f, 5000, 300, 0x12) then spawn_37(0x1e1, 0x78, "S04 original row 285: 0x37 late drifter") end
    if f == 0x157c then sp(0x38, 6000, 0x1cc, 0, "S04 original row 291: 0x38 late") end
    if f == 0x15ae then sp(0x38, 6000, 0x104, 0, "S04 original row 295: 0x38 late") end
    spawn_every(0x1644, 100, 8, 0x35, 0xfa, 0x2e4, 400, "S04 original row 305: 0x35 right lower")
    if f == 0x16a8 then sp(0x38, 5000, 0x1fe, 0, "S04 original row 310: 0x38 late heavy") end
    spawn_every(0x16f8, 100, 8, 0x35, 0xfa, -20, 400, "S04 original row 320: 0x35 left lower")
    if f == 0x175c then sp(0x38, 5000, 0xd2, 0, "S04 original row 325: 0x38 late heavy") end
    spawn_every(0x17ac, 0x6e, 8, 0x35, 0xfa, 0x2e4, 0x96, "S04 original row 335: 0x35 right mid")
    spawn_every(0x1824, 0x6e, 8, 0x35, 0xfa, -20, 0x96, "S04 original row 346: 0x35 left mid")
    spawn_every(0x189c, 100, 8, 0x35, 0xfa, 0x2e4, 0x15e, "S04 original row 357: 0x35 right low")
    if f == 0x1900 then
        sp(0x38, 4000, 0x1e0, 0, "S04 original row 362: 0x38 pair center")
        sp(0x38, 4000, 0xf0, 0, "S04 original row 363: 0x38 pair left")
    end
    if f == 0x1964 or f == 0x1bbc then sp(0x39, 6000, 0x6e, -80, "S04 original row 367: 0x39 repeated carrier") end
    if f == 0x19fa or f == 0x1c52 then sp(0x39, 6000, 0x262, -80, "S04 original row 371: 0x39 repeated carrier") end
    if f == 0x1a90 or f == 0x1ce8 then sp(0x3a, 6000, -80, 200, "S04 original row 375: 0x3a repeated carrier") end
    if f == 0x1b26 or f == 0x1d7e then sp(0x3a, 6000, 800, 200, "S04 original row 379: 0x3a repeated carrier") end
    if window(f, 0x1996, 0x47e, 0x4b) then spawn_37(0x1e1, 0x78, "S04 original row 391: 0x37 long wave") end
    if window(f, 0x1e78, 0x3c, 0x10) then spawn_36_left("S04 original row 409: 0x36 left burst") end
    if window(f, 0x1eb4, 0x3c, 10) then spawn_0b_left(0xfa, 0x97, 0x96, "S04 original row 421: 0x0b left burst") end
    if window(f, 0x1f18, 0x3c, 0x10) then spawn_36_right("S04 original row 437: 0x36 right burst") end
    if window(f, 0x1f54, 0x3c, 10) then spawn_0b_right(0xfa, 0x97, 0x96, "S04 original row 449: 0x0b right burst") end
    if f == 0x2008 then sp(0x38, 5000, 0xdc, 0, "S04 original row 453: 0x38 final block") end
    if f == 0x203a then sp(0x38, 5000, 500, 0, "S04 original row 457: 0x38 final block") end
    spawn_every(0x20d0, 0x96, 8, 0x35, 200, 0x2e4, 0x96, "S04 original row 467: 0x35 paired right")
    spawn_every(0x20d0, 0x96, 8, 0x35, 200, -20, 0x96, "S04 original row 468: 0x35 paired left")
    if f == 0x2198 then sp(0x3d, 7000, 0x398, 0x78, "S04 original row 473: 0x3d right high") end
    if window(f, 0x21e8, 0x50, 10) then spawn_0b_left(0xfa, 0x97, 100, "S04 original row 484: 0x0b left top") end
    if f == 0x2260 then sp(0x3d, 7000, -200, 0x96, "S04 original row 488: 0x3d left") end
    if window(f, 0x22b0, 0x50, 10) then spawn_0b_right(0xfa, 0x97, 100, "S04 original row 499: 0x0b right top") end
    if f == 9000 then sp(0x3d, 7000, 0x398, 0xb4, "S04 original row 503: 0x3d right low") end
    if f == 0x238c then sp(0x38, 5000, 200, 0, "S04 original row 507: 0x38 final source") end
    spawn_every(0x23dc, 100, 8, 0x35, 0xfa, 0x2e4, 0xb4, "S04 original row 517: 0x35 right final")
    if f == 0x2454 then sp(0x3d, 7000, 0x398, 0x96, "S04 original row 522: 0x3d right final") end
    spawn_every(0x24a4, 100, 8, 0x35, 0xfa, -20, 0x15e, "S04 original row 532: 0x35 left final")
    if f == 0x251c then sp(0x3d, 7000, -200, 0x78, "S04 original row 537: 0x3d left high") end
    if f == 0x2580 then sp(0x39, 6000, 0x262, -80, "S04 original row 541: 0x39 final carrier") end
    if window(f, 0x25d0, 0x50, 10) then spawn_0b_top(0xfa, 0x259, 0x3c, "S04 original row 552: 0x0b wide top") end
    if f == 0x2648 then
        sp(0x3f, 44000, 0x169, 0, "S04 original row 556: 0x3f second controller")
        rt.gate = true
    end
    if window(f, 0x28a0, 300, 0x28) then spawn_0b_top(300, 0x1e1, 0x78, "S04 original row 568: 0x0b late wide") end
    if not rt.gate and window(f, 0x2648, 0x385, 100) then
        sp(0x38, 5000, rc(0x169, 0xb4), 0, "S04 original row 580: gated random late")
    end
    if f == 0x2a30 then
        sp(0x38, 4000, 0x1e0, 0, "S04 original row 584: 0x38 end pair")
        sp(0x38, 4000, 0xf0, 0, "S04 original row 585: 0x38 end pair")
    end
    spawn_every(0x2a94, 0x5a, 8, 0x35, 200, 0x2e4, 0x78, "S04 original row 594: 0x35 ending right")
    spawn_every(0x2aee, 0x5a, 8, 0x35, 200, -20, 0x96, "S04 original row 604: 0x35 ending left")
    if f == 0x2b5c then sp(8, 5000, 0x104, 0, "S04 original row 609: ending marker") end

    if f == 11760 then sp(0x13b, 100000, 360, 120, "S04 boss handoff: endFrame + 0x3c entity 0x13b") end
end

local function stage05(rt, f)
    local function sp(type_id, hp, x, y, note)
        spawn(rt, f, type_id, hp, x, y, note)
    end
    local function rc(modulus, base)
        return rand_coord(rt, f, modulus, base)
    end

    if window(f, 0xfa, 100, 0xf) then sp(0x44, 0xfa, rc(0x15f, 0x168), -20, "S05 original line 31") end
    if f == 0x15e then sp(0x46, 3000, 0x42e, 0x32, "S05 original line 35") end
    if f == 0x17c then sp(0x46, 3000, 0x366, 0, "S05 original line 39") end
    if window(f, 0x1c2, 100, 0xf) then sp(0x44, 0xfa, rc(0x15f, 10), -20, "S05 original line 50") end
    if f == 0x226 then sp(0x46, 3000, -350, 0x32, "S05 original line 54") end
    if f == 0x244 then sp(0x46, 3000, -150, 0, "S05 original line 58") end
    if window(f, 0x294, 100, 0x13) then sp(0x45, 500, 0x2e4, rc(0x97, 0x78), "S05 original line 69") end
    if f == 800 then sp(7, 5000, 0x1cc, 0, "S05 original line 73") end
    if f == 900 then sp(0x47, 3000, 0x104, 0x96, "S05 original line 77") end
    if window(f, 0x410, 0x50, 0x1f) then sp(0x45, 400, rc(0x97, 0x19a), -20, "S05 original line 88") end
    if window(f, 0x492, 100, 0x18) then sp(0x45, 400, -20, rc(0x97, 0x96), "S05 original line 99") end
    if f == 0x4f6 then sp(0x46, 3000, 0x3fc, 0x32, "S05 original line 103") end
    if f == 0x51e then sp(0x46, 3000, -300, 0x32, "S05 original line 107") end
    if window(f, 0x564, 200, 0xe) then sp(0x44, 0xfa, rc(0x191, 0xa0), -20, "S05 original line 118") end
    if f == 0x640 then sp(0x46, 0x960, -400, 0x32, "S05 original line 122") end
    if f == 0x65e then sp(0x46, 0x960, -250, 0x4b, "S05 original line 126") end
    if f == 0x67c then sp(0x46, 0x960, -100, 100, "S05 original line 130") end
    if f == 0x6b8 then sp(0x46, 0x960, 0x398, 0x1e, "S05 original line 134") end
    if f == 0x708 then sp(0x4a, 11000, 0x1cc, 0, "S05 original line 138") end
    if f == 0x7f8 then sp(0x4a, 9000, 0x104, 0, "S05 original line 142") end
    if window(f, 0x884, 100, 0x14) then sp(0x0b, 300, rc(0x12d, 0x104), -20, "S05 original line 153") end
    if f == 0x8e8 then sp(0x4a, 9000, 0x19a, 0, "S05 original line 157") end
    if window(f, 0x974, 0x50, 0xf) then sp(0x45, 300, rc(0x12d, 0xa0), -20, "S05 original line 168") end
    if f == 0x9c4 then sp(0x4a, 9000, 0x136, 0, "S05 original line 172") end
    if f == 0xa8c then sp(0x29, 7000, 0xf0, 300, "S05 original line 176") end
    if window(f, 0xabe, 0x32, 10) then sp(0x44, 0xfa, rc(0x1c3, 0x104), -20, "S05 original line 187") end
    if window(f, 0xb22, 0x32, 10) then sp(0x44, 0xfa, rc(0x1c3, 10), -20, "S05 original line 198") end
    if f == 0xb54 then sp(0x48, 0x960, 0x1cc, 0x96, "S05 original line 202") end
    if window(f, 0xbea, 0x50, 0x14) then sp(0x0b, 300, -20, rc(0x97, 100), "S05 original line 213") end
    if f == 0xc6c then sp(0x46, 0x960, 0x3fc, 100, "S05 original line 217") end
    if f == 0xc80 then sp(0x46, 0x960, -300, 100, "S05 original line 221") end
    if f == 0xcbc then sp(0x46, 0x960, 0x42e, 0x14, "S05 original line 225") end
    if f == 0xcd0 then sp(0x46, 0x960, -350, 0x14, "S05 original line 229") end
    if window(f, 0xd7a, 100, 10) then sp(0x44, 0xfa, rc(0x2bd, 10), -20, "S05 original line 240") end
    if f == 0xe10 then sp(0x4d, 6000, -150, 0, "S05 original line 244") end
    if f == 0xf6e then sp(0x29, 7000, 0x1e0, 0xfa, "S05 original line 248") end
    if window(f, 0xfd2, 0x50, 0x3c) then
        sp(0x45, 300, 0xb4, -20, "S05 original line 253")
        sp(0x45, 300, 0x168, -20, "S05 original line 254")
        sp(0x45, 300, 0x21c, -20, "S05 original line 255")
    end
    if f == 0x1068 then sp(0x4d, 6000, 0x366, 0, "S05 original line 259") end
    if window(f, 0x1162, 0x82, 10) then sp(0x44, 0xfa, rc(0x2bd, 10), -20, "S05 original line 270") end
    if window(f, 0x1220, 0x32a, 0x60) then sp(0x45, 300, 0x2e4, rc(0xc9, 0x32), "S05 original line 281") end
    if window(f, 0x1250, 0x2fa, 0x60) then sp(0x45, 300, -20, rc(0xc9, 0x32), "S05 original line 292") end
    if f == 0x12c0 then sp(0x4a, 7000, 0x104, 0, "S05 original line 296") end
    if f == 5000 then sp(0x4a, 7000, 0x1cc, 0, "S05 original line 300") end
    if f == 0x14c8 then sp(0x46, 0x960, -100, 0x32, "S05 original line 304") end
    if f == 0x14e6 then sp(0x46, 0x960, -250, 0x4b, "S05 original line 308") end
    if f == 0x1504 then sp(0x46, 0x960, -400, 100, "S05 original line 312") end
    if f == 0x157c then sp(0x47, 0x960, 0xf0, 0x96, "S05 original line 316") end
    if window(f, 0x1608, 0x82, 0x20) then sp(0x0b, 300, rc(0xf1, 0x168), -20, "S05 original line 332") end
    if f == 0x16a8 then sp(0x48, 0x960, 0x1e0, 0x96, "S05 original line 337") end
    if window(f, 0x1734, 0x82, 0x20) then sp(0x0b, 300, rc(0xf1, 0x78), -20, "S05 original line 353") end
    if f == 0x17d4 then sp(0x47, 0x960, 0xf0, 0x96, "S05 original line 358") end

    if f == 0x18ce then
        sp(0x4f, 60000, 0x168, 200, "S05 original line 363: midboss")
        rt.gate = true
    end
    if not rt.gate then
        if window(f, 0x1900, 0x4e2, 0x96) then sp(0x46, 2000, rc(0x65, -350), rc(0x65, 0), "S05 original line 376") end
        if window(f, 0x194b, 0x497, 0x96) then sp(0x46, 2000, rc(0x65, 0x3ca), rc(0x65, 0), "S05 original line 389") end
        if window(f, 0x1900, 0x514, 0x11) then sp(0x45, 300, rc(0x259, 0x3c), -20, "S05 original line 401") end
    end

    if f == 0x1e3c then sp(0x46, 0x898, -100, 100, "S05 original line 406") end
    if f == 0x1e50 then sp(0x46, 0x898, -250, 0x4b, "S05 original line 410") end
    if f == 0x1e64 then sp(0x46, 0x898, -400, 0x32, "S05 original line 414") end
    if f == 0x1eaa then sp(0x46, 0x898, 0x334, 0x4b, "S05 original line 418") end
    if f == 0x1ebe then sp(0x46, 0x898, 0x3ca, 0x32, "S05 original line 422") end
    if f == 0x1ed2 then sp(0x46, 0x898, 0x460, 0x19, "S05 original line 426") end
    if f == 8000 then
        sp(0x46, 0x640, -400, 100, "S05 original line 430")
        sp(0x46, 0x640, 0x460, 0x78, "S05 original line 431")
    end
    if f == 0x1f72 then
        sp(0x46, 0x640, -250, 100, "S05 original line 435")
        sp(0x46, 0x640, 0x3ca, 0x3c, "S05 original line 436")
    end
    if f == 0x1fa4 then
        sp(0x46, 0x640, -100, 100, "S05 original line 440")
        sp(0x46, 0x640, 0x334, 0, "S05 original line 441")
    end
    if f == 0x203a then sp(0x47, 0x960, 0xf0, 200, "S05 original line 445") end
    if f == 0x20d0 then sp(0x48, 0x960, 0x1e0, 0x96, "S05 original line 449") end
    if window(f, 0x2166, 100, 10) then sp(0x44, 0xfa, rc(0xfb, 0xa0), -20, "S05 original line 460") end
    if window(f, 0x21fc, 100, 10) then sp(0x44, 0xfa, rc(0x15f, 0x136), -20, "S05 original line 471") end
    if f == 0x2260 then sp(0x4a, 8000, 0x136, 0, "S05 original line 475") end
    if window(f, 9000, 0x8c, 8) then sp(0x44, 0xfa, rc(0x259, 0x3c), -20, "S05 original line 491") end
    if f == 0x23f0 then sp(0x4d, 6000, 0x366, 0, "S05 original line 496") end
    if f == 0x24ea then sp(0x46, 0x898, -250, 100, "S05 original line 500") end
    if f == 0x2508 then sp(0x46, 0x898, -400, 0x32, "S05 original line 504") end
    if f == 0x254e then sp(0x46, 0x898, 0x3ca, 100, "S05 original line 508") end
    if f == 0x256c then sp(0x46, 0x898, 0x460, 0x32, "S05 original line 512") end
    if window(f, 0x25d0, 100, 0x11) then sp(0x45, 300, -20, rc(0x97, 100), "S05 original line 523") end
    if window(f, 0x2648, 0x78, 0x13) then sp(0x45, 300, rc(0x12d, 0x104), -20, "S05 original line 534") end
    if f == 0x26ac then sp(0x4a, 10000, 0x136, 0, "S05 original line 538") end
    if f == 0x27a6 then sp(0x4d, 6000, -150, 0, "S05 original line 542") end
    if window(f, 0x28a0, 0x96, 0x13) then sp(0x45, 300, 0x2e4, rc(0x97, 100), "S05 original line 553") end
    if window(f, 0x2954, 0xa0, 10) then sp(0x44, 0xfa, rc(0x259, 0x3c), -20, "S05 original line 564") end
    if f == 0x29fe then sp(0x46, 0x898, -400, 100, "S05 original line 568") end
    if f == 0x2a1c then sp(0x46, 0x898, -250, 0x32, "S05 original line 572") end
    if f == 0x2a3a then sp(0x46, 0x898, -100, 0, "S05 original line 576") end
    if window(f, 0x2a94, 200, 0x11) then sp(0x45, 300, rc(0x1e1, 0x78), -20, "S05 original line 588") end
    if f == 0x2b5c then sp(8, 5000, 0x104, 0, "S05 original line 592") end

    if f == 11860 then sp(0x13c, 100000, 360, 200, "S05 boss handoff: endFrame + 0x3c entity 0x13c") end
end

local function stage06(rt, f)
    local function sp(type_id, hp, x, y, note)
        spawn(rt, f, type_id, hp, x, y, note)
    end
    local function rc(modulus, base)
        return rand_coord(rt, f, modulus, base)
    end

    if f == 0xfa then sp(0x57, 0x960, 0x230, -150, "S06 original line 79") end
    if f == 0x118 then sp(0x57, 0x960, 0x2f8, -150, "S06 original line 82") end
    if window(f, 0x15e, 0x50, 0xe) then sp(0x1a, 300, rc(0x1c3, 0x6e), -20, "S06 original line 93") end
    if window(f, 0x1e0, 0x46, 0xc) then sp(0x0b, 300, -20, rc(0xc9, 100), "S06 original line 104") end
    if f == 0x24e then sp(0x58, 0x960, 0xa0, -150, "S06 original line 108") end
    if f == 0x262 then sp(0x58, 0x960, -40, -150, "S06 original line 112") end
    if window(f, 0x294, 0x8c, 0x14) then sp(0x0d, 300, 0x2e4, rc(0x65, 0xfa), "S06 original line 123") end
    if window(f, 800, 0x8c, 0x14) then sp(0x0d, 300, -20, rc(0x65, 300), "S06 original line 134") end
    if f == 900 then sp(7, 5000, 0x104, 0, "S06 original line 138") end
    if f == 1000 then sp(0x57, 0x960, 0x294, -150, "S06 original line 142") end
    if f == 0x3fc then sp(0x57, 0x960, 0x348, -180, "S06 original line 146") end

    if f == 0x44c then
        each_point(stage06_formation1_small, function(x, y) sp(0x5a, 0x44c, x, y, "S06 original lines 151-196: formation 1 small") end)
        each_point(stage06_formation1_medium, function(x, y) sp(0x5d, 0xc80, x, y, "S06 original lines 171-202: formation 1 medium") end)
        each_point(stage06_formation1_large, function(x, y) sp(0x5e, 0x15e0, x, y, "S06 original lines 183-207: formation 1 large") end)
        sp(0x5f, 0x2b5c, 0x168, -4490, "S06 original line 208: formation 1 core")
    end
    if window(f, 0x4b0, 800, 0x50) then sp(0x5c, 800, 0x302, f - 0x64a, "S06 original line 213") end
    if window(f, 0x4d8, 0x2f8, 0x50) then sp(0x5c, 800, 0x302, f - 0x6b8, "S06 original line 218") end
    if window(f, 0x898, 800, 0x50) then sp(0x5c, 800, -50, f - 0xa3c, "S06 original line 223") end
    if window(f, 0x8c0, 0x2f8, 0x50) then sp(0x5c, 800, -50, f - 0xaa5, "S06 original line 228") end
    if window(f, 0xd48, 800, 0x50) then sp(0x5b, 800, 0x302, f - 0xeec, "S06 original line 233") end
    if window(f, 0xd70, 0x2f8, 0x50) then sp(0x5b, 800, -50, f - 0xf5a, "S06 original line 238") end
    if window(f, 0x10cc, 800, 0x50) then sp(0x5b, 800, -50, f - 0x1252, "S06 original line 243") end
    if window(f, 0x10f4, 0x2f8, 0x50) then sp(0x5b, 800, 0x302, f - 0x12c0, "S06 original line 248") end
    if window(f, 0x488, 0xf0, 0x14) then sp(0x0b, 300, rc(0x1f5, 0x6e), -20, "S06 original line 259") end
    if f == 0x6a4 then
        sp(0x57, 0x898, 0x1ae, -120, "S06 original line 263")
        sp(0x57, 0x898, 0x244, -160, "S06 original line 264")
    end
    if window(f, 0xa28, 0x78, 0xf) then sp(0x0b, 300, -20, rc(0xc9, 100), "S06 original line 275") end
    if window(f, 0xabe, 100, 0xf) then sp(0x1a, 300, rc(0x15f, 0x136), -20, "S06 original line 286") end
    if f == 0xc80 then sp(0x59, 0x22b8, -100, 200, "S06 original line 290") end
    if window(f, 0xc80, 300, 0x2c) then sp(0x0c, 300, rc(0x191, 0xd2), -20, "S06 original line 301") end
    if f == 0xd70 then sp(0x59, 0x22b8, 0x334, 200, "S06 original line 305") end
    if window(f, 0xdac, 200, 0x14) then sp(0x0d, 300, 0x2e4, rc(0x65, 300), "S06 original line 316") end
    if window(f, 0xe42, 0x96, 0x14) then sp(0x0d, 300, -20, rc(0x65, 300), "S06 original line 327") end
    if f == 0x10cc then sp(0x58, 0x960, 0x168, -120, "S06 original line 331") end
    if f == 0x10fe then sp(0x58, 0x960, 0xd2, -150, "S06 original line 335") end
    if f == 0x1130 then sp(0x58, 0x960, 0x3c, -180, "S06 original line 339") end
    if window(f, 0x11f8, 100, 0x14) then sp(0x0b, 300, -20, rc(0xc9, 100), "S06 original line 350") end
    if window(f, 0x1482, 100, 10) then sp(0x0b, 300, rc(0x1f5, 0x6e), -20, "S06 original line 361") end
    if window(f, 0x17ac, 0xf0, 0xf) then sp(0x1a, 300, rc(0x1f5, 0x6e), -20, "S06 original line 372") end

    if f == 0x189c then
        sp(0x143, 100000, 400, 240, "S06 original line 380: midboss")
        rt.gate = true
    end
    if not rt.gate then
        if window(f, 0x1900, 0x76c, 0x27) then sp(0x0b, 400, rc(0x259, 0x3c), -20, "S06 original line 396") end
        if window(f, 0x1964, 0x6a4, 400) then
            sp(0x57, 2000, 0x1a4, -180, "S06 original line 401")
            sp(0x57, 2000, 0x262, -150, "S06 original line 402")
            sp(0x57, 2000, 800, -120, "S06 original line 403")
        end
        if window(f, 0x1a2c, 0x5dc, 400) then
            sp(0x58, 2000, 300, -120, "S06 original line 408")
            sp(0x58, 2000, 0x6e, -150, "S06 original line 409")
            sp(0x58, 2000, -80, -180, "S06 original line 410")
        end
    end

    if f == 0x2008 then
        each_point(stage06_formation2_small, function(x, y) sp(0x5a, 0x44c, x, y, "S06 original lines 415-456: formation 2 small") end)
        each_point(stage06_formation2_medium, function(x, y) sp(0x5d, 0xc80, x, y, "S06 original lines 437-461: formation 2 medium") end)
        each_point(stage06_formation2_large, function(x, y) sp(0x5e, 0x15e0, x, y, "S06 original lines 442-466: formation 2 large") end)
        sp(0x5f, 13000, 0xf0, -1250, "S06 original line 467: formation 2 core")
        sp(0x5f, 0x30d4, 500, -3175, "S06 original line 468: formation 2 core")
    end
    if window(f, 0x22c4, 800, 0x50) then sp(0x5b, 800, 0x302, f - 0x245e, "S06 original line 473") end
    if window(f, 0x23f0, 800, 0x50) then sp(0x5b, 800, -50, f - 0x25da, "S06 original line 478") end
    if f == 0x2260 then sp(0x59, 8000, 0x334, 200, "S06 original line 482") end
    if f == 0x23f0 then sp(0x0f, 5000, -120, 0x78, "S06 original line 486") end
    if window(f, 0x26ca, 0x32, 0xd) then sp(0x0b, 300, 0x2e4, rc(0xc9, 0x96), "S06 original line 497") end
    if window(f, 10000, 0x32, 0xd) then sp(0x0b, 300, -20, rc(0xc9, 100), "S06 original line 508") end
    if f == 0x2774 then
        sp(0x57, 0x640, 0x168, -100, "S06 original line 512")
        sp(0x57, 0x640, 0x230, -100, "S06 original line 513")
        sp(0x57, 0x640, 0x2f8, -100, "S06 original line 514")
        sp(0x57, 0x640, 0x1cc, -220, "S06 original line 515")
        sp(0x57, 0x640, 0x294, -220, "S06 original line 516")
    end
    if f == 0x283c or f == 0x288c or f == 0x28dc then
        sp(0x0c, 300, 0x3c, -20, "S06 original line 521")
        sp(0x0c, 300, 0xb4, -20, "S06 original line 522")
        sp(0x0c, 300, 300, -20, "S06 original line 523")
        sp(0x0c, 300, 0x1a4, -20, "S06 original line 524")
        sp(0x0c, 300, 0x21c, -20, "S06 original line 525")
        sp(0x0c, 300, 0x294, -20, "S06 original line 526")
    end
    if f == 0x2936 then sp(0x59, 7000, -100, 200, "S06 original line 530") end
    if f == 0x2968 then sp(0x59, 7000, 0x334, 200, "S06 original line 534") end
    if window(f, 0x2a94, 0xdc, 0x1e) then sp(0x0c, 300, rc(0x191, 0x50), -20, "S06 original line 546") end
    if f == 0x2e18 then sp(8, 5000, 0x1cc, 0, "S06 original line 550") end

    if f == 12560 then sp(0x13d, 100000, 480, 150, "S06 boss handoff: endFrame + 0x3c entity 0x13d") end
end

local function stage07(rt, f)
    local function sp(type_id, hp, x, y, note)
        spawn(rt, f, type_id, hp, x, y, note)
    end
    local function rc(modulus, base)
        return rand_coord(rt, f, modulus, base)
    end

    if window(f, 0x10e, 0x82, 0x13) then
        local n = f - 0x10e
        sp(0x74, 0x4b0, (n * 6) % 0x168 + 0xb4, 0x334, "S07 original line 27")
    end
    if f == 500 then sp(0x71, 0x1130, 0x1e0, 200, "S07 original line 31") end
    if f == 0x244 then sp(0x71, 0x1130, 0xd2, 0x10e, "S07 original line 35") end
    if window(f, 0x2ee, 100, 0x23) then sp(0x70, 700, 0x2e4, rc(0xc9, 100), "S07 original line 46") end
    if window(f, 0x366, 100, 0x23) then sp(0x70, 700, -20, rc(0xc9, 100), "S07 original line 57") end
    if window(f, 0x3ac, 0x82, 0x13) then
        local n = f - 0x3ac
        sp(0x74, 0x4b0, (n * 6) % 0x168 + 0xb4, 0x334, "S07 original line 62")
    end
    if window(f, 0x49c, 0x5a, 0x19) then sp(0x70, 0x4b0, rc(0x259, 0x3c), 0x30c, "S07 original line 73") end
    if f == 0x514 then sp(7, 5000, 0x168, 0, "S07 original line 77") end
    if f == 0x5b4 then sp(0x73, 7000, 0xf0, 0, "S07 original line 81") end
    if f == 0x6a4 then sp(0x73, 6000, 0x1e0, 0, "S07 original line 85") end
    if window(f, 0x60e, 200, 0x2b) then
        local n = f - 0x60e
        sp(0x74, 0x4b0, 0x21c - (n * 3) % 0x168, 0x334, "S07 original line 90")
    end
    if f == 0x758 then sp(0x72, 0xce4, 0x1fe, 0xfa, "S07 original line 94") end
    if f == 0x794 then sp(0x72, 0xce4, 0x168, 200, "S07 original line 98") end
    if f == 2000 then sp(0x72, 0xce4, 0xd2, 0x96, "S07 original line 102") end
    if window(f, 0x834, 0x8c, 0x13) then
        sp(0x74, 1000, 0x21c - ((f - 0x60e) * 6) % 0x168, 0x334, "S07 original line 107")
    end
    if f == 0x960 then sp(0x26, 5000, 0x208, -20, "S07 original line 111") end
    if f == 0x9c4 then sp(0x26, 5000, 200, -20, "S07 original line 115") end
    if window(f, 0xa14, 0x3c, 0xc) then sp(0x70, 0x4b0, rc(0x259, 0x3c), 0x30c, "S07 original line 126") end
    if f == 0xaf0 then sp(0x76, 18000, 0x1ea, 0x348, "S07 original line 130") end
    if window(f, 0xb86, 100, 0x14) then sp(0x0b, 500, -20, rc(0xc9, 100), "S07 original line 141") end
    if window(f, 0xc80, 0xa0, 0x28) then sp(0x70, 0x4b0, rc(0xfb, 0xa0), 0x30c, "S07 original line 152") end
    if window(f, 0xd0c, 100, 0x14) then sp(0x0b, 500, 0x2e4, rc(0xc9, 100), "S07 original line 163") end
    if f == 0xd5c then sp(0x76, 15000, 0xe6, 0x348, "S07 original line 167") end
    if f == 0xd84 then sp(0x75, 0x960, 0x1ae, 0x302, "S07 original line 171") end
    if f == 0xdfc then sp(0x75, 0x960, 0x212, 0x366, "S07 original line 175") end
    if window(f, 0xeec, 0xaa, 10) then sp(0x0b, 300, rc(0x259, 0x3c), -20, "S07 original line 186") end

    if f == 0xfb4 then
        sp(0x144, 100000, 360, 900, "S07 original line 195: first midboss")
        rt.gate = true
    end
    if not rt.gate and f >= 0x1068 and f < 0x1900 then
        if window(f, 0x1068, 0x76c, 400) then sp(0x72, 0xaf0, 0xe6, 0xfa, "S07 original line 210") end
        if window(f, 0x10a4, 0x730, 400) then sp(0x72, 0xaf0, 0x1ea, 200, "S07 original line 215") end
        if window(f, 0x1130, 0x6a4, 400) then sp(0x71, 0xaf0, 0x1ea, 0xfa, "S07 original line 220") end
        if window(f, 0x116c, 0x668, 400) then sp(0x71, 0xaf0, 0xe6, 200, "S07 original line 225") end
        if window(f, 0x1068, 0x76c, 0x32) then sp(0x0b, 500, rc(0x1f5, 0x6e), -20, "S07 original line 236") end
        if f == 0x184c then sp(0x73, 9000, 0x19a, 0, "S07 original line 240") end
    end
    if window(f, 0x1900, 0x96, 0x13) then
        local n = f - 0x1900
        sp(0x74, 1000, (n * 5) % 0x168 + 0xb4, 0x334, "S07 original line 248")
    end
    if window(f, 0x1a04, 0x50, 0x14) then sp(0x70, 0x4b0, rc(0x17d, 0xaa), -60, "S07 original line 260") end
    if f == 0x1a5e then
        sp(0x77, 18000, 0xf0, 0x398, "S07 original line 264: gate owner")
        rt.gate = true
    end
    if window(f, 0x1bbc, 0xfa, 0x48) then sp(0x25, 700, rc(0xb5, 0x1a4), -20, "S07 original line 276") end
    if window(f, 0x1cfc, 0xb4, 0x27) then
        local n = f - 0x1cfc
        sp(0x74, 1000, (n * 2) % 200 + 0x186, 0x334, "S07 original line 281")
    end
    if not rt.gate and window(f, 0x1c20, 600, 0x78) then sp(0x72, 0xaf0, 0xf0, 0xf0, "S07 original line 286") end
    if window(f, 0x1eaa, 100, 0x15) then sp(0x70, 1000, rc(0x191, 0xa0), 0x30c, "S07 original line 297") end

    if f == 8000 then
        sp(0x145, 100000, 360, 900, "S07 original line 304: second midboss")
        rt.gate = true
    end
    if not rt.gate and f >= 0x2008 and f < 0x28a0 then
        if window(f, 0x2008, 0x5dc, 0x96) then
            local phase = (f - 8200) * 2 * math.pi / 600
            local x = 0x168 - trunc(math.sin(phase) * 180)
            sp(0x73, 6000, x, 0, "S07 original line 321: sine path")
        end
        if window(f, 0x2008, 0x60e, 0x2c) then sp(0x0b, 300, rc(0x1f5, 0x6e), -20, "S07 original line 332") end
        if f == 0x2648 then sp(0x76, 15000, 0x168, 0x348, "S07 original line 336") end
        if f == 0x2670 then
            sp(0x75, 0x960, 0x1cc, 1000, "S07 original line 340")
            sp(0x75, 0x960, 0x104, 1000, "S07 original line 341")
        end
        if f == 10000 then
            sp(0x75, 0x960, 0x21c, 0x366, "S07 original line 345")
            sp(0x75, 0x960, 0xb4, 0x366, "S07 original line 346")
        end
        if f == 0x2814 then
            sp(0x70, 0x4b0, 0x1b8, 0x30c, "S07 original line 350")
            sp(0x70, 0x4b0, 0x118, 0x30c, "S07 original line 351")
        end
        if f == 0x283c then
            sp(0x70, 0x4b0, 0x208, 0x30c, "S07 original line 355")
            sp(0x70, 0x4b0, 200, 0x30c, "S07 original line 356")
        end
    end
    if window(f, 0x28a0, 0xc8, 10) then sp(0x0b, 300, rc(0x259, 0x3c), -20, "S07 original line 370") end
    if f == 0x2968 then
        sp(0x77, 18000, 0x1e0, 0x398, "S07 original line 375: gate owner")
        rt.gate = true
    end
    if f >= 0x29fe and f < 0x29fe + 0x1c2 then
        local burst_frame = (f - 0x29fe) % 0x10e
        if burst_frame < 0x3c and burst_frame % 0x1e == 0 then
            sp(0x70, 700, -20, rc(0xc9, 100), "S07 original line 388")
        end
    end
    if f == 0x2c24 then sp(0x76, 15000, 0xe6, 0x348, "S07 original line 392") end
    if not rt.gate and window(f, 0x2cba, 0x78, 0x1e) then sp(0x70, 700, 0x2e4, rc(0xc9, 100), "S07 original line 404") end
    if window(f, 0x2db4, 100, 10) then sp(0x0b, 300, rc(0x1f5, 0x6e), -20, "S07 original line 417") end
    if f == 0x2e18 then sp(8, 5000, 0x1cc, 0, "S07 original line 421") end

    if f == 12560 then sp(0x13e, 100000, 360, 250, "S07 boss handoff: endFrame + 0x3c entity 0x13e") end
end

local function stage08(rt, f)
    local function sp(type_id, hp, x, y, note)
        spawn(rt, f, type_id, hp, x, y, note)
    end
    local function rc(modulus, base)
        return rand_coord(rt, f, modulus, base)
    end
    local function rrc(modulus, base)
        return reverse_rand_coord(rt, f, modulus, base)
    end

    if f == 400 then
        each_point(stage08_opening_97, function(x, y) sp(0x97, 0x5dc, x, y, "S08 original lines 90-101: opening 0x97 path") end)
        sp(0x9a, 15000, 0x200, -0xc82, "S08 original line 102: opening controller")
        sp(0x9a, 15000, 0x138, -0x1167, "S08 original line 103: opening controller")
    end
    if window(f, 400, 800, 0x5a) then sp(0x98, 1000, 0x302, f - 0x352, "S08 original line 108: right descending route") end
    if window(f, 700, 800, 0x5a) then sp(0x98, 1000, -50, f - 0x460, "S08 original line 113: left descending route") end
    if window(f, 2000, 800, 0x5a) then sp(0x98, 1000, 0x302, f - 0x992, "S08 original line 118: right descending route") end
    if window(f, 4000, 800, 0x5a) then sp(0x98, 1000, -50, f - 0x1158, "S08 original line 123: left descending route") end
    if window(f, 0x546, 0x226, 0x5a) then
        for _, x in ipairs({0x10e, 0x168, 0x1c2}) do sp(0x95, 1000, x, -50, "S08 original lines 128-130: early 0x95 wall") end
    end
    if window(f, 0xa8c, 500, 0x5a) then
        sp(0x95, 0x4b0, 0x1d6, -50, "S08 original lines 135-136: early 0x95 pair")
        sp(0x95, 0x4b0, 0x249, -50, "S08 original lines 135-136: early 0x95 pair")
    end
    if window(f, 0xf3c, 400, 0x5a) then
        sp(0x95, 0x4b0, 0xe6, -50, "S08 original lines 141-142: early 0x95 pair")
        sp(0x95, 0x4b0, 0x1ea, -50, "S08 original lines 141-142: early 0x95 pair")
    end
    for i = 1, #stage08_early_99 do
        local spawn_frame = 0x672 + (i - 1) * 0x0f
        if f == spawn_frame then
            local point = stage08_early_99[i]
            sp(0x99, 0x4b0, point[1], point[2] + f - 0x672, "S08 original lines 145-161: routed 0x99 path")
        end
    end
    if f == 0xce4 then sp(0x99, 0x5dc, -50, 0x50, "S08 original line 164: fixed 0x99") end
    if f == 0xd02 then sp(0x99, 0x5dc, -180, 0x50, "S08 original line 168: fixed 0x99") end
    for i = 1, #stage08_early_96 do
        local base_frame = 0x15b8 + (i - 1) * 0x0c
        local spawn_frame
        if i <= 7 then spawn_frame = base_frame - 0x3c
        elseif i >= 17 then spawn_frame = base_frame + 0xbe
        else spawn_frame = base_frame end
        if f == spawn_frame then
            local point = stage08_early_96[i]
            sp(0x96, 700, point[1], 100 - point[2] + f - 0x157c, "S08 original lines 172-219: routed 0x96 formation")
        end
    end

    if window(f, 0x186, 0xb4, 0x10) then sp(0x0b, 0xfa, rc(0x259, 0x3c), -20, "S08 original line 234: top wave") end
    if window(f, 0x18e, 0xac, 0x10) then sp(0x44, 0xfa, rc(0x259, 0x3c), -20, "S08 original line 251: top wave") end
    if f == 0x26c then sp(0x0e, 5000, 500, 0, "S08 original line 256: fixed setpiece") end
    if f == 0x28a then sp(0x0e, 5000, 0xdc, 0, "S08 original line 260: fixed setpiece") end
    if f == 1000 then sp(0x07, 5000, 0x1cc, 0, "S08 original line 264: common marker") end
    if window(f, 0x802, 0x96, 0x0c) then sp(0x0b, 0xfa, rc(0x259, 0x3c), -20, "S08 original line 275: top wave") end
    if window(f, 0x92e, 100, 0x0c) then sp(0x0b, 0xfa, rc(0x259, 0x3c), -20, "S08 original line 286: top wave") end
    if window(f, 0xa64, 100, 0x0f) then sp(0x45, 400, -20, rc(0x79, 0x96), "S08 original line 297: left wave") end
    if f == 0xb54 then sp(0x10, 14000, 0x10e, 0x50, "S08 original line 301: fixed controller") end
    if window(f, 0xe56, 0x50, 8) then sp(0x44, 0xfa, rc(0x155, 0x3c), -20, "S08 original line 317: narrow top wave") end
    if window(f, 0xece, 0x50, 8) then sp(0x44, 0xfa, rc(0x155, 0x140), -20, "S08 original line 334: narrow top wave") end
    if f == 0x1004 then sp(0x46, 0x960, -300, 0x32, "S08 original line 339: left sweep") end
    if f == 0x1022 then sp(0x46, 0x960, 0x3fc, 0x32, "S08 original line 343: right sweep") end
    if f == 0x109a then sp(0x46, 0x960, -300, 100, "S08 original line 347: left sweep") end
    if f == 0x10b8 then sp(0x46, 0x960, 0x3fc, 100, "S08 original line 351: right sweep") end
    if window(f, 0x11f8, 100, 0x0f) then sp(0x45, 400, 0x2e4, rc(0x83, 0x78), "S08 original line 362: right wave") end
    if window(f, 0x1432, 0xa0, 5) then sp(0x44, 200, rc(0x281, 0x28), -20, "S08 original line 373: dense top wave") end
    if window(f, 0x1518, 0x32, 0x1e) then
        for _, x in ipairs({0x50, 0xdc, 0x168, 500, 0x26c}) do sp(0x45, 400, x, -20, "S08 original lines 378-382: five-lane wall") end
    end
    if f == 0x16a8 then
        sp(0x46, 0x960, -300, 100, "S08 original lines 386-387: sweep pair")
        sp(0x46, 0x960, 0x3fc, 100, "S08 original lines 386-387: sweep pair")
    end
    if f == 0x186a then
        local setup_group = rt.setupGroup or rt.setup_group or 0
        if setup_group == 0 then sp(0x9c, 9000, 0x21c, 200, "S08 original line 392: route controller") end
        if setup_group == 1 then sp(0x9f, 7000, 0x21c, 200, "S08 original line 396: route controller") end
        if setup_group == 2 then sp(0xa2, 7000, 0x21c, 200, "S08 original line 400: route controller") end
    end
    if window(f, 0x18d8, 0x8c, 0x3c) then
        for _, x in ipairs({0x50, 0xdc, 0x168, 500, 0x26c}) do sp(0x0b, 300, x, -20, "S08 original lines 406-410: five-lane wall") end
    end
    if f == 0x19fa then sp(0x08, 5000, 0x136, 0, "S08 original line 414: common marker") end

    if window(f, 0x1af4, 0x3c, 10) then sp(0x70, 0x15e, 0x2e4, rc(0xc9, 100), "S08 original line 425: right wave") end
    if window(f, 7000, 0x3c, 10) then sp(0x70, 0x15e, -20, rc(0xc9, 100), "S08 original line 436: left wave") end
    if window(f, 0x1bbc, 0x3c, 0x10) then
        sp(0x70, 0x15e, rrc(0xc9, 0x136), -20, "S08 original line 452: mirrored top pair")
        sp(0x70, 0x15e, rc(0xc9, 0x19a), -20, "S08 original line 459: mirrored top pair")
    end
    if window(f, 0x1c52, 0x96, 0x14) then sp(0x37, 300, rc(0x1e1, 0x78), rc(0x97, 400), "S08 original lines 464-473: random drifter") end
    if f == 0x1c20 then sp(0x71, 5000, 0x1b8, 200, "S08 original line 477: fixed setpiece") end
    if f == 0x1cac then sp(0x72, 5000, 0x118, 200, "S08 original line 481: fixed setpiece") end
    if f == 0x1d38 then sp(0x71, 5000, 0x1e0, 0xfa, "S08 original line 485: fixed setpiece") end
    do
        local n = f - 0x1dec
        if n >= 0 and n < 0x1cc and n % 0x82 < 0x3c and (n % 0x82) % 8 == 0 then
            sp(0x44, 0xfa, rc(0x259, 0x3c), -20, "S08 original lines 488-501: cyclic top wave")
        end
    end
    if f == 0x1db0 then sp(0x1c, 0x1130, -120, 0, "S08 original line 506: fixed setpiece") end
    if f == 0x1e32 then sp(0x1c, 0x1130, 0x348, 0x1e, "S08 original line 510: fixed setpiece") end
    if f == 0x1eb4 then sp(0x1c, 0x1130, -120, 0x3c, "S08 original line 514: fixed setpiece") end
    if f == 0x1f36 then sp(0x1c, 0x1130, 0x348, 0x5a, "S08 original line 518: fixed setpiece") end
    if window(f, 0x2008, 100, 0x10) then
        sp(0x0b, 300, rrc(0xc9, 0x136), -20, "S08 original line 534: mirrored top pair")
        sp(0x0b, 300, rc(0xc9, 0x19a), -20, "S08 original line 541: mirrored top pair")
    end

    if f == 0x20a8 then
        sp(0xa4, 75000, 0x334, 0xb4, "S08 original line 547: first gate controller")
        rt.gate = true
    elseif not rt.gate and f >= 0x20d0 and f < 0x20d0 + 0x898 then
        if window(f, 0x2260, 0x44c, 0x1e) then sp(0x70, 0x15e, rrc(0x1f5, 0x262), -20, "S08 original line 561: first gate top wave") end
        if window(f, 0x2260, 0x44c, 0x10) then sp(0x0b, 300, rrc(0x1f5, 0x262), -20, "S08 original line 578: first gate dense top wave") end
        if window(f, 10000, 300, 0x16) then sp(0x1a, 300, rrc(0x1b9, 0x244), -20, "S08 original line 590: first gate top wave") end
        if window(f, 0x2738, 0x104, 100) then sp(0x38, 0xe10, rrc(0x1b9, 0x244), -20, "S08 original line 601: first gate heavy wave") end
    end
    if f == 0x28a0 then sp(0x26, 3000, 0x168, -20, "S08 original line 607: fixed top anchor") end
    if f == 0x28d2 then
        sp(0x26, 3000, 0x21c, -20, "S08 original lines 611-612: fixed top pair")
        sp(0x26, 3000, 0xb4, -20, "S08 original lines 611-612: fixed top pair")
    end

    if f == 0x2a30 then
        for i = 1, #stage08_type_1d do
            sp(0x1d, 0x640, stage08_type_1d[i][1], stage08_type_1d[i][2], "S08 original lines 651-652: 0x1d path")
            sp(0x2c, 0x640, stage08_type_2c[i][1], stage08_type_2c[i][2], "S08 original lines 653-654: 0x2c path")
            sp(0x5a, 0x640, stage08_type_5a[i][1], stage08_type_5a[i][2], "S08 original lines 655-656: 0x5a path")
        end
        for i = 1, #stage08_type_1e do
            sp(0x1e, 0x708, stage08_type_1e[i][1], stage08_type_1e[i][2], "S08 original lines 661-662: 0x1e path")
            sp(0x2d, 0x1194, stage08_type_2d[i][1], stage08_type_2d[i][2], "S08 original lines 663-664: 0x2d path")
        end
        each_point(stage08_type_5d, function(x, y) sp(0x5d, 0xc80, x, y, "S08 original lines 669-670: 0x5d path") end)
        each_point(stage08_type_97, function(x, y) sp(0x97, 0x708, x, y, "S08 original lines 675-676: 0x97 path") end)
        sp(0x20, 14000, 200, -0xb22, "S08 original line 679: path controller")
        sp(0x5e, 0x157c, 0x208, -0xb54, "S08 original line 680: path controller")
        sp(0x1f, 8000, 0x1c2, -0x139c, "S08 original line 681: path controller")
        sp(0x1f, 8000, 0x127, -0x143c, "S08 original line 682: path controller")
        sp(0x5f, 0x34bc, 0x168, -0x157c, "S08 original line 683: path controller")
    end
    if window(f, 0x2de6, 0x226, 0x5a) then
        for _, x in ipairs({0x10e, 0x168, 0x1c2}) do sp(0x95, 1000, x, -50, "S08 original lines 688-690: 0x95 wall") end
    end
    if window(f, 0x37dc, 400, 0x5a) then
        sp(0x95, 0x4b0, 0xe6, -50, "S08 original lines 695-696: 0x95 pair")
        sp(0x95, 0x4b0, 0x1ea, -50, "S08 original lines 695-696: 0x95 pair")
    end
    if window(f, 0x2b5c, 800, 0x5a) then
        sp(0x5b, 800, 0x302, f - 0x2d14, "S08 original line 701: routed 0x5b")
        sp(0x5b, 800, -50, f - 0x2d82, "S08 original line 702: routed 0x5b")
    end
    if window(f, 0x30d4, 900, 0x5a) then sp(0x5b, 1000, -50, f - 0x3264, "S08 original line 707: routed 0x5b") end
    if window(f, 0x3520, 800, 0x5a) then sp(0x98, 1000, 0x302, f - 0x3714, "S08 original line 712: routed 0x98") end
    for i = 1, #stage08_late_96 do
        local base_frame = 0x3e08 + (i - 1) * 0x0f
        local spawn_frame = i <= 3 and base_frame - 0x118 or base_frame
        if f == spawn_frame then
            local point = stage08_late_96[i]
            sp(0x96, 700, point[1], 100 - point[2] + f - 0x3cf0, "S08 original lines 715-739: late routed 0x96 formation")
        end
    end

    if window(f, 0x2a62, 100, 8) then sp(0x35, 0xfa, -20, 0x96, "S08 original line 748: left wave") end
    if f == 0x2ac6 then sp(0x1b, 3000, 0xf0, 0, "S08 original line 753: fixed anchor") end
    if window(f, 11000, 100, 8) then sp(0x35, 0xfa, 0x2e4, 0x96, "S08 original line 763: right wave") end
    if f == 0x2b5c then sp(0x1b, 3000, 0x1e0, 0, "S08 original line 768: fixed anchor") end
    if f == 0x2c56 then sp(0x4a, 9000, 0x168, 0, "S08 original line 772: fixed controller") end
    if window(f, 12000, 0x3c, 8) then sp(0x35, 200, 0x2e4, 0x96, "S08 original line 782: right wave") end
    if window(f, 0x2f58, 0x32, 8) then sp(0x35, 200, -20, 0xb4, "S08 original line 793: left wave") end
    if window(f, 0x3002, 0x32, 8) then sp(0x35, 200, 0x2e4, 0x15e, "S08 original line 804: right wave") end
    if window(f, 0x30ac, 0x32, 8) then sp(0x35, 200, -20, 0x15e, "S08 original line 815: left wave") end
    if window(f, 13000, 100, 8) then sp(0x35, 0xfa, 0x2e4, 0x78, "S08 original line 826: right wave") end
    if f == 0x3390 then sp(0x9b, 6000, 0x230, 0xb4, "S08 original line 831: fixed setpiece") end
    if f == 0x367e then sp(0x9e, 5000, 0xdc, 0x96, "S08 original line 835: fixed setpiece") end
    if f == 0x3840 then sp(0x3a, 10000, 800, 200, "S08 original line 839: fixed carrier") end
    if f == 0x3afc then sp(0xa1, 9000, 0x21c, 0x96, "S08 original line 843: fixed setpiece") end
    if window(f, 0x3b60, 100, 0x14) then sp(0x0b, 0xfa, rc(0x259, 0x3c), -20, "S08 original line 854: top wave") end
    if not rt.gate and window(f, 0x4010, 300, 0x0d) then sp(0x0b, 300, rc(0x259, 0x3c), -20, "S08 original line 866: gate-open top wave") end
    if window(f, 0x413c, 200, 0x10) then
        local n = f - 0x413c
        sp(0x0a, 1000, (n * 7) % 0x1e0 + 0x78, 0x4236 - f, "S08 original line 877: rising route")
    end
    if window(f, 0x4290, 0x6e, 0x0f) then sp(0x0c, 400, rc(0x259, 0x3c), -20, "S08 original line 889: top wave") end
    if window(f, 0x43a8, 0x28, 0x0f) then
        local n = f - 0x43a8
        sp(0x70, 500, 0x136 - (n * 6) % 0xf0, 0x30c, "S08 original lines 894-895: bottom pair")
        sp(0x70, 500, (n * 6) % 0xf0 + 0x19a, 0x30c, "S08 original lines 894-895: bottom pair")
    end
    if window(f, 0x440c, 0x28, 0x0f) then
        local n = f - 0x440c
        sp(0x70, 500, 0x136 - (n * 6) % 0xf0, 0x30c, "S08 original lines 900-901: bottom pair")
        sp(0x70, 500, (n * 6) % 0xf0 + 0x19a, 0x30c, "S08 original lines 900-901: bottom pair")
    end
    if f == 0x44c0 then sp(0x0f, 0x1194, -120, 0xfa, "S08 original line 905: fixed setpiece") end
    if f == 0x44f2 then sp(0x0f, 0x1194, 0x348, 200, "S08 original line 909: fixed setpiece") end
    if f == 0x4524 then sp(0x0f, 0x1194, -120, 0x96, "S08 original line 913: fixed setpiece") end
    if f == 0x4556 then sp(0x0f, 0x1194, 0x348, 100, "S08 original line 917: fixed setpiece") end
    if f == 18000 then sp(0x3d, 10000, 0x398, 0x96, "S08 original line 921: fixed anchor") end
    if window(f, 0x4696, 0x50, 8) then sp(0x35, 0xfa, 0x2e4, 0x78, "S08 original line 931: right wave") end
    if f == 0x474a then sp(0x73, 7000, 0x1cc, 0, "S08 original line 936: fixed setpiece") end
    if window(f, 0x475e, 0x50, 8) then sp(0x35, 0xfa, -20, 0xa0, "S08 original line 946: left wave") end
    if f == 0x4812 then sp(0x73, 7000, 0x104, 0, "S08 original line 951: fixed setpiece") end
    if f == 0x4876 then for _, x in ipairs({0xd2, 300, 0x186, 0x1e0}) do sp(0x25, 700, x, -20, "S08 original lines 955-958: four-lane wall") end end
    if f == 0x48a8 then for _, x in ipairs({0xf0, 0x14a, 0x1a4, 0x1fe}) do sp(0x25, 700, x, -20, "S08 original lines 962-965: four-lane wall") end end

    if f == 0x490c then
        sp(0x2e, 60000, 0x168, -120, "S08 original line 970: second gate controller")
        rt.gate = true
    elseif not rt.gate and f > 0x490c and f <= 0x490c + 0x577 then
        if window(f, 0x4970, 0x47e, 5) then sp(0x44, 0xfa, rc(0x259, 0x3c), -20, "S08 original line 983: second gate dense top wave") end
        if f == 20000 then sp(0x27, 4000, 0x1e0, 300, "S08 original line 987: second gate setpiece") end
        if f == 0x4e48 then sp(0x27, 4000, 0xf0, 200, "S08 original line 991: second gate setpiece") end
    end
    if f == 0x4e70 then sp(0x27, 4000, 0x1b8, 100, "S08 original line 996: fixed setpiece") end
    if f == 0x4f4c then sp(0x29, 4000, 0xf0, 300, "S08 original line 1000: fixed setpiece") end
    if f == 0x4fb0 then sp(0x29, 4000, 0x1e0, 0xfa, "S08 original line 1004: fixed setpiece") end
    if f == 0x5014 then sp(0x29, 4000, 0xf0, 200, "S08 original line 1008: fixed setpiece") end
    if not rt.gate and window(f, 0x4fb0, 400, 0x18) then sp(0x0b, 300, rc(0x259, 0x3c), -20, "S08 original line 1020: gate-open top wave") end
    if f == 0x50aa then sp(0x59, 5000, -100, 200, "S08 original line 1025: fixed setpiece") end
    if f == 0x50dc then sp(0x59, 5000, 0x334, 200, "S08 original line 1029: fixed setpiece") end
    if not rt.gate and window(f, 0x50dc, 100, 0x18) then sp(0x45, 300, rc(0x259, 0x3c), -20, "S08 original line 1041: gate-open top wave") end
    if f == 0x51a4 then sp(0x08, 5000, 0x104, 0, "S08 original line 1045: ending marker") end

    if f == 21480 then sp(0x13f, 100000, 360, 180, "S08 boss handoff: endFrame + 0x3c entity 0x13f") end
end

local function stage09(rt, f)
    local function sp(type_id, hp, x, y, note)
        spawn(rt, f, type_id, hp, x, y, note)
    end
    local function rc(modulus, base)
        return rand_coord(rt, f, modulus, base)
    end

    if window(f, 0x10e, 0x10e, 0x3c) then
        local offset = trunc(math.sin((f - 250) * math.pi / 40) * 50)
        sp(0x74, 700, offset + 0x82, 0x334, "S09 original line 31: opening formation")
        sp(0x74, 700, offset + 0x104, 0x334, "S09 original line 32: opening formation")
        sp(0x74, 700, offset + 0x186, 0x334, "S09 original line 33: opening formation")
        sp(0x74, 700, offset + 0x208, 0x334, "S09 original line 34: opening formation")
        sp(0x74, 700, offset + 0x28a, 0x334, "S09 original line 35: opening formation")
    end
    if f == 700 then
        sp(0x26, 3000, 0x230, -20, "S09 original line 39: fixed top anchor")
        sp(0x26, 3000, 0xa0, -20, "S09 original line 40: fixed top anchor")
    end
    if f == 800 then sp(0x26, 3000, 0x168, -20, "S09 original line 44: fixed top anchor") end
    if window(f, 0x398, 0x78, 0x14) then sp(0x19, 700, f * 4 - 0xdc0, -20, "S09 original line 49: linear top wave") end
    if window(f, 0x438, 0x78, 10) then sp(0x0d, 400, -20, rc(0x12d, 0x96), "S09 original line 60: random left wave") end
    if window(f, 0x43d, 0x73, 10) then sp(0x0d, 400, 0x2e4, rc(0x12d, 0x96), "S09 original line 71: random right wave") end
    if f == 0x4b0 then sp(0x07, 5000, 0x104, 0, "S09 original line 75: common marker") end

    if f == 0x546 then
        sp(0x146, 100000, 360, 200, "S09 original line 85: first mid-stage boss root")
        rt.gate = true
    elseif not rt.gate and f >= 0x640 and f < 0x640 + 2000 then
        local cycle = (f - 0x640) % 0x78
        if cycle < 0x60 and cycle % 0x18 == 0 then sp(0x0b, 400, rc(0x259, 0x3c), -20, "S09 original line 103: first gate top wave") end
        if window(f, 0x668, 0x6e0, 100) then sp(0x0e, 3000, rc(0x1b9, 0x8c), 0, "S09 original line 114: first gate setpiece wave") end
        if f == 0xdac then
            sp(0x38, 3000, 0x208, 0, "S09 original line 118: first gate fixed pair")
            sp(0x38, 3000, 0xb4, 0, "S09 original line 119: first gate fixed pair")
        end
    end

    if f == 0xe4c then sp(0x46, 2000, 0x460, 100, "S09 original line 124: right sweep") end
    if f == 0xe74 then sp(0x46, 2000, 0x3ca, 0x4b, "S09 original line 128: right sweep") end
    if f == 0xe92 then sp(0x46, 2000, 0x334, 0x32, "S09 original line 132: right sweep") end
    if f == 0xec4 then sp(0x46, 2000, -400, 0x50, "S09 original line 136: left sweep") end
    if f == 0xee2 then sp(0x46, 2000, -250, 0x37, "S09 original line 140: left sweep") end
    if f == 0xf00 then sp(0x46, 2000, -100, 0x1e, "S09 original line 144: left sweep") end
    if window(f, 0xf8c, 0x78, 0x28) then
        for x = 0x6e, 0x262, 100 do sp(0x19, 500, x, -20, "S09 original lines 149-154: six-lane wall") end
    end

    if f == 0x1004 then
        sp(0x147, 100000, 360, 270, "S09 original line 162: second mid-stage boss root")
        rt.gate = true
    elseif not rt.gate and f >= 0x10cc and f < 0x10cc + 0x6a4 then
        if f < 0x15e0 and window(f, 0x10cc, 0x514, 0x50) then sp(0x57, 0x708, rc(0x97, 0x262), rc(0x65, -200), "S09 original lines 180-181: second gate right wave") end
        if window(f, 0x10ea, 0x4f6, 0x50) then sp(0x58, 0x708, rc(0x97, -0x28), rc(0x65, -200), "S09 original lines 193-194: second gate left wave") end
        if f == 0x1644 then sp(0x2b, 12000, 0x168, 0, "S09 original line 198: second gate anchor") end
        if window(f, 0x16a8, 0x96, 0x32) then
            sp(0x0b, 400, 0x6e, -20, "S09 original line 203: second gate paired lanes")
            sp(0x0b, 400, 0x262, -20, "S09 original line 204: second gate paired lanes")
        end
    end

    if f >= 0x1798 and f < 0x1798 + 0xa0 then
        local cycle = (f - 0x1798) % 0x78
        if cycle < 0x60 and cycle % 0x0f == 0 then sp(0x0b, 0x168, rc(0x259, 0x3c), -20, "S09 original line 217: staggered top wave") end
    end
    if f >= 0x179d and f < 0x179d + 0x9b then
        local cycle = (f - 0x179d) % 0x78
        if cycle < 0x60 and cycle % 0x0f == 0 then sp(0x0b, 0x168, 0x2e4, rc(0xfb, 100), "S09 original line 229: staggered right wave") end
    end
    if f >= 0x17a2 and f < 0x17a2 + 0x96 then
        local cycle = (f - 0x17a2) % 0x78
        if cycle < 0x60 and cycle % 0x0f == 0 then sp(0x0b, 0x168, -20, rc(0xfb, 100), "S09 original line 241: staggered left wave") end
    end

    if f == 0x1838 then
        sp(0x148, 100000, 360, 200, "S09 original line 249: third mid-stage boss root")
        rt.gate = true
    elseif not rt.gate and f >= 0x1900 and f < 0x1900 + 2000 then
        local first_wall = f < 0x1bee and (f - 0x1900) % 8 == 0
        local second_wall = window(f, 0x1c52, 200, 8)
        local third_wall = window(f, 0x1d7e, 200, 8)
        if first_wall or second_wall or third_wall then
            sp(0x35, 0x96, 0x2e4, 100, "S09 original lines 266-269: alternating side wall")
            sp(0x35, 0x96, -20, 0xa0, "S09 original lines 266-269: alternating side wall")
            sp(0x35, 0x96, 0x2e4, 0xdc, "S09 original lines 266-269: alternating side wall")
            sp(0x35, 0x96, -20, 0x118, "S09 original lines 266-269: alternating side wall")
        end
        if f == 0x1e78 then sp(0x47, 2000, 0x1fe, 0xfa, "S09 original line 290: third gate fixed enemy") end
        if f == 0x1ec8 then sp(0x48, 2000, 0xd2, 0x96, "S09 original line 294: third gate fixed enemy") end
        if f == 0x1fd6 then
            sp(0x58, 0x640, 0x104, -100, "S09 original lines 298-300: third gate left trio")
            sp(0x58, 0x640, 0x6e, -150, "S09 original lines 298-300: third gate left trio")
            sp(0x58, 0x640, -40, -200, "S09 original lines 298-300: third gate left trio")
        end
        if f == 0x203a then
            sp(0x57, 0x640, 0x1cc, -200, "S09 original lines 304-306: third gate right trio")
            sp(0x57, 0x640, 0x262, -150, "S09 original lines 304-306: third gate right trio")
            sp(0x57, 0x640, 0x2f8, -100, "S09 original lines 304-306: third gate right trio")
        end
    end

    if f == 0x20d0 then sp(0x08, 5000, 0x1cc, 0, "S09 original line 311: common marker") end
    if f == 0x2166 then sp(0x4d, 6000, -150, 0, "S09 original line 315: fixed left entry") end
    if window(f, 0x2210, 0xe6, 0x14) then sp(0x36, 0x15e, 0x2e4, rc(0xc9, 300), "S09 original line 326: random right wave") end
    if window(f, 0x221a, 0xdc, 0x14) then sp(0x36, 0x15e, -20, rc(0xc9, 300), "S09 original line 337: random left wave") end

    if f == 9000 then
        sp(0x149, 100000, 360, 200, "S09 original line 345: fourth mid-stage boss root")
        rt.gate = true
    elseif not rt.gate and f >= 0x23f0 and f < 0x23f0 + 2000 then
        if f < 0x27c4 and window(f, 0x23f0, 0x3d4, 0x18) then sp(0x0b, 400, rc(0x259, 0x3c), -20, "S09 original line 362: fourth gate top wave") end
        if window(f, 0x2800, 0xf0, 10) then sp(0x0d, 400, -20, rc(0x12d, 0x96), "S09 original line 373: fourth gate left wave") end
        if window(f, 0x2805, 0xeb, 10) then sp(0x0d, 400, 0x2e4, rc(0x12d, 0x96), "S09 original line 384: fourth gate right wave") end
        if f == 0x2968 then sp(0x39, 7000, 0x262, -80, "S09 original line 388: fourth gate setpiece") end
        if window(f, 0x2990, 0x6e, 0x10) then sp(0x0b, 300, rc(0xf1, 0x50), -20, "S09 original line 404: fourth gate top burst") end
        if f == 0x29cc then sp(0x3a, 7000, -80, 200, "S09 original line 409: fourth gate setpiece") end
        if f == 0x2a30 then sp(0x39, 7000, 0x6e, -80, "S09 original line 413: fourth gate setpiece") end
        if window(f, 0x2a58, 0x6e, 0x10) then sp(0x0b, 300, rc(0xf1, 400), -20, "S09 original line 429: fourth gate top burst") end
        if f == 0x2a94 then sp(0x3a, 7000, 800, 200, "S09 original line 434: fourth gate setpiece") end
    end

    if f == 0x2bf2 then sp(0x76, 12000, 0xe6, 0x348, "S09 original line 439: fixed rising entry") end
    if f == 0x2c1a then sp(0x76, 12000, 0x1ea, 0x348, "S09 original line 443: fixed rising entry") end
    if window(f, 0x2da0, 0xb4, 5) then sp(0x44, 0xfa, rc(0x259, 0x3c), -20, "S09 original line 454: dense top wave") end

    if f == 0x2e54 then
        sp(0x14a, 100000, 360, 200, "S09 original line 461: fifth mid-stage boss root")
        rt.gate = true
    elseif not rt.gate and f >= 12000 and f < 12000 + 0x6a4 then
        if f < 0x3340 and window(f, 12000, 0x460, 0x12) then sp(0x0b, 300, rc(0x1f5, 0x6e), -20, "S09 original line 480: fifth gate common top wave") end
        if window(f, 12000, 0x460, 0x18) then sp(0x19, 500, rc(0x1f5, 0x6e), -20, "S09 original line 492: fifth gate type 0x19 wave") end
        if window(f, 0x3390, 300, 100) then sp(0x9b, 5000, rc(0x65, 0x1cc), rc(0x65, 0x96), "S09 original lines 504-505: fifth gate random setpiece") end
        if f >= 0x33e0 and f < 0x33e0 + 0x168 then
            local cycle = (f - 0x33e0) % 0x96
            if cycle < 0x3c and cycle % 0x0f == 0 then sp(0x45, 400, rc(0x1e1, 0x78), -20, "S09 original line 517: fifth gate clustered top wave") end
        end
    end

    if f == 0x3584 then sp(0x1b, 0x1130, 0x168, 0, "S09 original line 523: fixed anchor") end
    if f == 0x35b6 then sp(0x1b, 0x1130, 0x1fe, 0, "S09 original line 527: fixed anchor") end
    if f == 0x35e8 then sp(0x1b, 0x1130, 0xd2, 0, "S09 original line 531: fixed anchor") end

    if f == 0x364c then
        sp(0x14b, 100000, 360, 240, "S09 original line 539: sixth mid-stage boss root")
        rt.gate = true
    elseif not rt.gate and f >= 0x3714 and f < 0x3714 + 2000 then
        if f < 0x3bc4 and window(f, 0x3714, 1200, 0x13) then sp(0x1a, 400, rc(0x231, 0x50), -20, "S09 original line 555: sixth gate type 0x1a wave") end
        if window(f, 0x3714, 0x4b0, 0x1e) then sp(0x25, 600, rc(0x1f5, 0x6e), -20, "S09 original line 566: sixth gate type 0x25 wave") end
        if window(f, 0x3c28, 400, 100) then sp(0xa1, 5000, rc(0x65, 0xa0), rc(0x65, 0x96), "S09 original lines 578-579: sixth gate random setpiece") end
        if f == 0x3e1c then for x = 0x3c, 0x2d0 - 1, 0x3c do sp(0x44, 0xfa, x, -20, "S09 original line 585: eleven-lane wall") end end
        if f == 0x3e44 then
            sp(0x0f, 5000, -120, 0x96, "S09 original line 591: paired side setpiece")
            sp(0x0f, 5000, 0x348, 0x96, "S09 original line 592: paired side setpiece")
        end
    end

    if f == 0x3ee4 then
        sp(0xa4, 50000, -100, 0xb4, "S09 original line 598: final gated controller")
        rt.gate = true
    elseif not rt.gate and f >= 0x3f48 and f < 0x3f48 + 0x44c then
        if f < 0x4290 and window(f, 0x3f48, 0x348, 10) then sp(0xad, 300, rc(0x259, 0x3c), -10, "S09 original lines 611-612: final gate specialized wave") end
        if f == 0x42cc then sp(0x9e, 5000, 0x1cc, 0xfa, "S09 original line 616: final gate setpiece") end
        if f == 0x42fe then sp(0x9e, 5000, 0x104, 0xb4, "S09 original line 620: final gate setpiece") end
    end
    if f == 0x4394 then sp(0x08, 5000, 0x1cc, 0, "S09 original line 625: ending marker") end

    if f == 17960 then sp(0x140, 100000, 360, 190, "S09 boss handoff: endFrame + 0x3c entity 0x140") end
end

local function stage10(rt, f)
    local function sp(type_id, hp, x, y, note)
        spawn(rt, f, type_id, hp, x, y, note)
    end
    local function rc(modulus, base)
        return rand_coord(rt, f, modulus, base)
    end

    if f == 1 then rt.gate = true end
    if f == 350 then rt.gate = false end
    local raw_start = rt.rawStartFrame or 0
    if f == 0x4c4 or (raw_start > 0x4c4 and f == raw_start + 1) then
        sp(0x14c, 100000, 360, -2400, f == 0x4c4 and "S10 original line 68: scene boss root" or "S10 original line 70: late-start scene boss root")
        rt.gate = false
    end

    if window(f, 400, 0x78, 0x0c) then sp(0xfa, 300, 0x1e0, -20, "S10 original line 82: opening top wave") end
    if window(f, 0x196, 0x72, 0x0c) then sp(0xfa, 300, 0xf0, -20, "S10 original line 87: opening top wave") end
    if window(f, 0x21c, 100, 0x0d) then
        local n = f - 0x21c
        local x = (n < 0x32 and 0x3d - n or n - 0x27) * 10
        sp(0xfc, 800, x, -20, "S10 original line 99: folding top wave")
    end
    if window(f, 700, 0x3c, 0x0c) then sp(0xfa, 300, 0x2e4, 0x96, "S10 original line 104: right wave") end
    if window(f, 0x316, 0x3c, 0x0c) then sp(0xfa, 300, -20, 0xf0, "S10 original line 109: left wave") end
    if window(f, 0x370, 0x3c, 0x0c) then sp(0xfa, 300, 0x2e4, 0x140, "S10 original line 114: right wave") end
    if window(f, 0x3d4, 0x78, 10) then sp(0xfb, 400, rc(0x231, 0x50), 0, "S10 original line 125: random field wave") end
    if f == 0x44c then sp(0x06, 5000, 0x1cc, 0, "S10 original line 129: common marker") end
    if window(f, 0x4e2, 0x1c2, 0x1e) then sp(0xfc, 800, rc(0x1f5, 0x6e), -20, "S10 original line 140: random top wave") end
    if window(f, 0x578, 0x3c, 0x0c) then sp(0xfa, 300, 0xb4, -20, "S10 original line 145: top wave") end
    if window(f, 0x5dc, 0x3c, 0x0c) then sp(0xfa, 300, 0x2e4, 200, "S10 original line 150: right wave") end
    if window(f, 0x640, 0x3c, 0x0c) then sp(0xfa, 300, -20, 0x168, "S10 original line 155: left wave") end
    if window(f, 0x6a4, 0x3c, 0x0c) then sp(0xfa, 300, 0x21c, -20, "S10 original line 160: top wave") end
    if window(f, 2000, 1000, 0x1e) then sp(0xfb, 300, rc(0x231, 0x50), 0, "S10 original line 171: long random field wave") end
    if f == 0xbea then sp(0x103, 4000, 0x2c6, -200, "S10 original line 175: fixed entry") end
    if f == 0xc30 then sp(0x103, 4000, 0x35c, -150, "S10 original line 179: fixed entry") end
    if window(f, 0xcb2, 0x3c, 0x0c) then sp(0xfa, 300, 0x2e4, 0x96, "S10 original line 184: right wave") end
    if window(f, 0xd02, 0x3c, 0x0c) then sp(0xfa, 300, -20, 0xf0, "S10 original line 189: left wave") end
    if f == 0xd7a then sp(0x104, 4000, -40, -200, "S10 original line 193: fixed entry") end
    if f == 0xdd4 then sp(0xfe, 7000, 0x21c, 200, "S10 original line 197: fixed setpiece") end
    if window(f, 0x10fe, 100, 0x1e) then sp(0xfc, 800, rc(0x1f5, 0x6e), 0, "S10 original line 208: random field wave") end
    if window(f, 0x11e4, 100, 8) then sp(0xfb, 300, rc(0x231, 0x50), 0, "S10 original line 224: rapid random field wave") end
    if f == 0x12c0 then sp(0x102, 7000, 0x1e0, 0, "S10 original line 229: fixed anchor") end
    if window(f, 0x1324, 0x3c, 0x0c) then sp(0xfa, 300, 0x1cc, -20, "S10 original line 234: top wave") end
    if window(f, 5000, 0x78, 0x14) then sp(0xfd, 1000, rc(0x191, 0xd2), 0, "S10 original line 245: random field wave") end
    if window(f, 0x1400, 0x50, 10) then sp(0xfb, 300, rc(0xc9, 0x6e), 0, "S10 original line 256: narrow random wave") end
    if f == 0x146e then sp(0x100, 6000, 0xb4, 300, "S10 original line 260: fixed setpiece") end
    if f == 0x14c8 then sp(0x100, 6000, 0x21c, 200, "S10 original line 264: fixed setpiece") end
    if f == 0x159a then
        sp(0xfd, 1000, 0x78, 0, "S10 original lines 268-271: four-lane group")
        sp(0xfd, 1000, 0x10e, 0, "S10 original lines 268-271: four-lane group")
        sp(0xfd, 1000, 0x1c2, 0, "S10 original lines 268-271: four-lane group")
        sp(0xfd, 1000, 600, 0, "S10 original lines 268-271: four-lane group")
    end

    if not rt.gate then
        if window(f, 0x16a8, 700, 0x12) then sp(0xfb, 300, rc(0x17d, 0x50), 0, "S10 original line 283: scene-boss gate wave") end
        if window(f, 0x16a8, 700, 0x1e) then sp(0xfc, 800, rc(0x191, 0xd2), 0, "S10 original line 294: scene-boss gate wave") end
    end
    if window(f, 0x19dc, 0x3c, 0x0c) then sp(0xfa, 300, 0x1a4, -20, "S10 original line 300: top wave") end
    if f == 0x1a18 then sp(0x102, 7000, 0x168, 0, "S10 original line 304: fixed anchor") end
    if window(f, 0x1a7c, 0x3c, 0x0c) then sp(0xfa, 300, 300, -20, "S10 original line 309: top wave") end
    if window(f, 0x1af4, 800, 0x1e) then sp(0xfb, 300, rc(0x231, 0x50), -20, "S10 original line 320: long random top wave") end
    if f == 7000 then sp(0xfe, 0x157c, 0xb4, 0xfa, "S10 original line 324: fixed setpiece") end
    if f == 0x1bbc then sp(0xfe, 0x157c, 0xb4, 200, "S10 original line 328: fixed setpiece") end
    if f == 0x1c20 then sp(0xfe, 0x157c, 0xb4, 0x96, "S10 original line 332: fixed setpiece") end
    if f == 0x1d1a then sp(0x102, 5000, 0x208, 0, "S10 original line 336: fixed anchor") end
    if f == 0x1d7e then sp(0x102, 5000, 200, 0, "S10 original line 340: fixed anchor") end
    if f == 0x1de2 then sp(0x102, 5000, 0x168, 0, "S10 original line 344: fixed anchor") end

    if rt.gate and window(f, 8000, 700, 0x1e) then sp(0xfb, 300, rc(0x17d, 0x104), 0, "S10 original line 356: gate-closed random wave") end
    if not rt.gate then
        if window(f, 8000, 700, 0x12) then sp(0xfb, 300, rc(0x17d, 0x104), 0, "S10 original line 368: gate-open random wave") end
        if window(f, 8000, 700, 0x28) then sp(0xfd, 1000, rc(0x191, 0x6e), 0, "S10 original line 379: gate-open support wave") end
    end
    if window(f, 0x2292, 100, 0x0f) then sp(0xfc, 800, rc(0x1f5, 0x6e), 0, "S10 original line 392: random field wave") end
    if f == 9000 then sp(0x104, 4000, 0x3c, -100, "S10 original line 396: fixed entry") end
    if f == 0x235a then sp(0x104, 4000, -90, -150, "S10 original line 400: fixed entry") end
    if f == 0x238c then sp(0x104, 4000, -240, -200, "S10 original line 404: fixed entry") end
    if window(f, 0x2454, 0x3c, 0x0c) then sp(0xfa, 300, 0x2e4, 0x168, "S10 original line 409: right wave") end
    if window(f, 0x2490, 0x3c, 0x0c) then sp(0xfa, 300, -20, 0xf0, "S10 original line 414: left wave") end
    if window(f, 0x24cc, 0x3c, 0x0c) then sp(0xfa, 300, 0x2e4, 0xa0, "S10 original line 419: right wave") end
    if window(f, 0x2508, 0x3c, 0x0c) then sp(0xfa, 300, -20, 300, "S10 original line 424: left wave") end
    if f == 0x2544 then sp(0x100, 6000, 0xb4, 0xfa, "S10 original line 428: fixed setpiece") end
    if f == 0x26ac then sp(0x100, 6000, 0x21c, 0x96, "S10 original line 432: fixed setpiece") end
    if window(f, 0x25bc, 0x348, 0x1c) then sp(0xfb, 300, rc(0x17d, 0x104), 0, "S10 original line 443: long random field wave") end
    if f == 0x28a0 then sp(0x103, 4000, 0x35c, -120, "S10 original line 447: fixed entry") end

    if not rt.gate then
        if window(f, 0x2a30, 200, 7) then sp(0xfb, 300, rc(0x231, 0x50), 0, "S10 original line 460: final rapid random wave") end
        if window(f, 11000, 400, 0x0f) then sp(0xfb, 300, rc(0x231, 0x50), 0, "S10 original line 472: final random wave") end
        if f == 0x2b5c then sp(0x102, 5000, 0xf0, 0, "S10 original line 476: final anchor") end
        if f == 0x2c24 then sp(0x102, 5000, 0x1e0, 0, "S10 original line 480: final anchor") end
    end
    if f == 0x2cd8 or f == 0x2d14 or f == 0x2d50 then
        for x = 0x3c, 0x294, 0x78 do sp(0xfc, 800, x, 0, "S10 original lines 485-490: six-lane closing wall") end
    end
    if f == 0x2db4 then sp(0x07, 5000, 0x104, 0, "S10 original line 494: ending marker") end
end

local ScheduleBook = {}
ScheduleBook.__index = ScheduleBook
S.ScheduleBook = ScheduleBook

function ScheduleBook.new(entries)
    return setmetatable({ entries = entries }, ScheduleBook)
end

function ScheduleBook:run(stage, rt, frame)
    local schedule = self.entries[stage]
    if schedule then schedule(rt, frame) end
end

local scheduleBook = ScheduleBook.new({
    [1] = stage01,
    [2] = stage02,
    [3] = stage03,
    [4] = stage04,
    [5] = stage05,
    [6] = stage06,
    [7] = stage07,
    [8] = stage08,
    [9] = stage09,
    [10] = stage10,
})
S.book = scheduleBook

function S.run(stage, rt, f)
    scheduleBook:run(stage, rt, f)
end

return S
