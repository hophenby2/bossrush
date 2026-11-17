-- 冷启动原版第一面的按键和 SH-3 自机记录。各行是步进后的 X、Y、VX、VY、低速射击状态。
local reference = {
    [5501]={0x007a8000,0x00840000,0x28000,0,false},
    [5545]={0x00e80000,0x00840000,0,0,false},
    [5585]={0x00c28000,0x00840000,-0x28000,0,false},
    [5586]={0x00c00000,0x00840000,-0x28000,0,true},
    [5588]={0x00bb0000,0x00840000,-0x28000,0,true},
    [5589]={0x00b8a000,0x00840000,-0x26000,0,true},
    [5607]={0x00980000,0x00840000,-0x14000,0,true},
    [5665]={0x004f8000,0x00840000,-0x14000,0,false},
    [5666]={0x004e2000,0x00840000,-0x16000,0,false},
    [5675]={0x003c2000,0x00840000,-0x28000,0,false},
    [5802]={0x00282000,0x0118c000,0,0x14000,true},
    [5803]={0x00282000,0x01190000,0,0,true},
    [5811]={0x00273dc0,0x01190000,-0xe240,0,true},
    [5816]={0x002274c0,0x01190000,-0x14000,0,false},
    [5881]={0x002114c0,0x00818000,0,0,false},
}

local function after(frame, start, finish)
    return frame > start and frame <= finish
end

local function check(player, step)
    local p = player.pilotPosition
    assert(p.x == 120*65536 and p.y == 50*65536)
    p.y = 132*65536 -- 进入道中后的原版初始采样坐标。
    for frame = 5486, 5910 do
        local opposite = after(frame,5880,5895)
        step({
            right=opposite or after(frame,5500,5570),
            left=opposite or after(frame,5570,5683) or after(frame,5810,5817),
            up=opposite or after(frame,5710,5815),
            down=opposite or after(frame,5818,5880),
            shoot=after(frame,5570,5664) or after(frame,5710,5815),
        })
        local want = reference[frame]
        if want then
            assert(p.x==want[1] and p.y==want[2] and p.vx==want[3] and p.vy==want[4] and player.laser==want[5],
                ('第 %d 帧自机位移或射击状态不符'):format(frame))
            assert(player.x==want[1]/65536-120 and player.y==want[2]/65536-160)
        end
    end
    for _ = 1, 60 do step({down=true,left=true}) end
    assert(p.x == 8*65536 and p.y == 27*65536 and p.vx == 0 and p.vy == 0)
    step({left=true,right=true,up=true})
    assert(p.y == 27*65536 and p.vy == 0)
end

local function checkRecovery(player, step, hit)
    -- 第 5556 帧失去一命。第 5605 帧结束坠落，第 5636 帧重建自机。
    local p = player.pilotPosition
    p.x, p.y = 120*65536, 147*65536
    step({})
    hit()
    assert(player.respawn==80 and not player.colli and not player.laser)
    for _ = 1, 49 do step({up=true,shoot=true}) end
    assert(p.y==49*65536 and p.vy==-0x20000 and not player.colli)
    for _ = 1, 30 do step({up=true,shoot=true}) end
    assert(p.y==49*65536 and p.vy==0 and not player.colli)
    step({up=true,shoot=true})
    assert(player.x==0 and player.y==-110 and player.protect==255 and player.colli)
    step({})
    assert(player.protect==254)
end

if arg and arg[1] == '--luastg' then return check, checkRecovery end
local pilot = dofile('mod/GAME/th46/pilot.lua')
local player = {}
pilot.spawn(player)
check(player, function(key) pilot.move(player,key) end)
print('Futari 1.5 自机定点位移、边界和射击状态通过')
