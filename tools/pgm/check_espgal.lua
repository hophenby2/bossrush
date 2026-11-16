-- 核对 V100 原程序开场的生成时机、地炮逐帧位移和第一发弹体挂载。
if not lstg then
    lstg = {LoadTextFile=function(name)
        local file = assert(io.open(name,'rb'))
        local data = file:read('*a')
        file:close()
        return data
    end}
    function Class(_,methods) return methods end
    function New(class,...)
        local o = {}
        class.init(o,...)
        return o
    end
    object = {RawDel=function(o) o.deleted = true end}
    GROUP = {GHOST=0,ENEMY=1,ENEMY_BULLET=2,PLAYER=3,PLAYER_BULLET=4}
    LAYER = {BG=0,ENEMY=1,ENEMY_BULLET=2,PLAYER=3,PLAYER_BULLET=4}
end

local runtime = dofile('mod/GAME/th45/native/runtime.lua')
local function equal(actual,expected)
    assert(actual == expected,('实测 %s，预期 %s'):format(tostring(actual),tostring(expected)))
end
for i,count in ipairs({250,327,364,415,214,272}) do
    equal(#runtime.program.stages[i].spawns,count)
end
for i,count in ipairs({168,154,294,204,122,156}) do
    local stage = runtime.program.stages[i]
    equal(#stage.tiles,count)
    equal(#stage.tiles[1],9)
end
equal(#runtime.program.bulletTemplates,38)

-- 固定自机位置与卷轴状态来自原版第 2877 帧。此处以关卡记录继续生成地炮。
local function verify(withArt, flushFrame)
    local run = runtime.init(1,{spawnIndex=2,player={active=true,h=0x2bec,l=0x1c00}},withArt)
    local function step()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    for _,lane in ipairs(run.scroll) do
        lane.major,lane.hPixels,lane.hRest,lane.hBlock = 9,79,0x30,9
    end
    step()
    equal(run.major,10)
    equal(run.minor,0)
    equal(run.groundScroll,-64)
    local tank = assert(run.enemies[11])
    equal(tank.callback,0x159b3a)
    equal(tank.h,0x7800)
    equal(tank.l,0xc00)
    equal(tank.hp,0x20)
    equal(tank.speed,0x18)
    equal(tank.shotClock,0x22)
    equal(tank.aim,0x1d)
    step()
    equal(tank.h,0x76f4)
    equal(tank.shotClock,0x21)
    for _ = 2880,2912 do step() end
    equal(tank.h,0x5c93)
    equal(next(run.bullets),nil)
    step()
    equal(tank.h,0x5c02)
    local bullet = assert(run.bullets[1])
    equal(bullet.origin,tank)
    equal(bullet.callback,0x1740b4)
    equal(bullet.h,0x5a02)
    equal(bullet.l,0xd9f)
    equal(bullet.angle,0x6c)
    equal(bullet.speed,0x17)
    equal(bullet.dh,-0xe0)
    equal(bullet.dl,0x50)
    step()
    equal(bullet.h,0x5922)
    equal(bullet.l,0xdef)
    for _ = 2915,2926 do step() end
    local patrol = assert(run.enemies[13])
    equal(patrol.callback,0x15bd6a)
    equal(patrol.h,0x7840)
    equal(patrol.l,0x1800)
    equal(patrol.flags,0x8200)
    step()
    equal(patrol.h,0x7814)
    for _ = 2928,2958 do step() end
    local scout = assert(run.enemies[15])
    equal(scout.callback,0x150128)
    equal(scout.h,0x7540)
    equal(scout.l,0xd00)
    equal(scout.hp,0x10)
    step()
    equal(scout.h,0x7540)
    equal(scout.l,0xd25)
    step()
    equal(scout.h,0x7500)
    equal(scout.l,0xd4a)
    local collisionPilot = {active=true,h=bullet.h + 0x80,l=bullet.l - 0x80,front=0xc0,back=0x80,right=0x80,left=0x80}
    equal(runtime.collision.pilot(run,collisionPilot),bullet)
    equal(collisionPilot.pendingHit,true)
    equal(bullet.callback,0x16ffee)
    equal(runtime.collision.pilot(run,collisionPilot),nil)
    local dh,dl = bullet.dh,bullet.dl
    step()
    equal(bullet.callback,0x170020)
    equal(bullet.dh,math.floor(dh / 2))
    equal(bullet.dl,math.floor(dl / 2))
    for _ = 2962,3086 do step() end
    local smoke
    for _,enemy in pairs(run.enemies) do if enemy.kind == 0x85 then smoke = enemy; break end end
    assert(smoke,'原版计数 0x17 未登记烟尘生成器')
    equal(smoke.h,0x78c0)
    equal(smoke.l,0x3680)
    for _ = 3087,3103 do step() end
    equal(assert(run.effects[1]).frames,runtime.program.effects[14])
    runtime.close(run)
    equal(next(run.enemies),nil)
    equal(next(run.bullets),nil)

    -- 原版第 2923→2924 帧的横移和第 2993→2994 帧的斜移。
    run = runtime.init(1,nil,withArt)
    local keys = {right=true}
    local player = runtime.addPlayer(run,0x2bec,0x1de9,keys,0)
    step()
    equal(player.h,0x2bec)
    equal(player.l,0x1e8c)
    player.h,player.l,keys.up,keys.shoot = 0x4125,0x2a15,true,true
    step()
    equal(player.h,0x41d0)
    equal(player.l,0x2a88)
    for _ = 2,25 do step() end
    equal(player.focus,true)
    equal(player.speed,0x16)
    step()
    equal(player.speed,0x15)
    keys.shoot = false
    step()
    equal(player.focus,false)
    equal(player.speed,0x16)
    runtime.close(run)

    -- 第 2990 帧自机静止点射。第二次出膛跟随自机速度，随后由自弹自身推进。
    run = runtime.init(1,nil,withArt)
    keys = {shoot=true}
    player = runtime.addPlayer(run,0x3f24,0x28bc,keys,0)
    step()
    local right,left = assert(player.shots[1]),assert(player.shots[2])
    equal(right.h,0x42b6)
    equal(left.h,0x42b6)
    equal(right.l,0x2a3c)
    equal(left.l,0x273c)
    equal(right.damage,0x3b)
    keys.up,keys.right = true,true
    -- 夹具选择能复现原版两帧各移动一像素的摄像机余数。
    run.cameraFine,player.cameraMotion = 26,0xa3
    step()
    equal(right.h,0x44f3)
    equal(right.l,0x2a6f)
    step()
    equal(right.h,0x4818)
    equal(right.l,0x2a2f)
    equal(right.armed,true)
    runtime.close(run)

    -- 用一次点射击破已进入交战范围的地炮。由部件收血后登记独立爆炸槽。
    run = runtime.init(1,{spawnIndex=2},withArt)
    for _,lane in ipairs(run.scroll) do
        lane.major,lane.hPixels,lane.hRest,lane.hBlock = 9,79,0x30,9
    end
    for _ = 1,25 do step() end
    tank = assert(run.enemies[11])
    local contact = {h=tank.h,l=tank.l,front=0xc0,back=0x80,right=0x80,left=0x80}
    equal(runtime.collision.body(run,contact),tank)
    equal(contact.pendingHit,true)
    equal(tank.hp,0x20)
    keys = {shoot=true}
    player = runtime.addPlayer(run,tank.h - 0x600,tank.l - 0x180,keys,0)
    step()
    equal(tank.hp,-0xd)
    equal(tank.impact,true)
    equal(player.shots[1].damage,0x1b)
    step()
    equal(run.enemies[11],nil)
    local explosion = assert(run.effects[1])
    equal(explosion.frames,runtime.program.effects[2])
    equal(explosion.frameIndex,1)
    for _ = 1,24 do step() end
    equal(run.effects[1],nil)
    runtime.close(run)
end

if arg and arg[1] == '--luastg' then return verify end
verify(false)
print('Espgaluda 一面开场生成、自机和发弹、碰撞、地炮爆炸核对通过。')
