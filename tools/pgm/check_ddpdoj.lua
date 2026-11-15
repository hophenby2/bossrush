-- 用原程序开场的坐标与回调核对 LuaSTG 对象更新。
if not lstg then
    lstg = {
        LoadTextFile = function(name)
            local file = assert(io.open(name, 'rb'))
            local data = file:read('*a')
            file:close()
            return data
        end,
    }
    object = {RawDel=function(o) o.deleted = true end}
    GROUP = {ENEMY=1, ENEMY_BULLET=2, PLAYER=3, PLAYER_BULLET=4}
    LAYER = {ENEMY=1, ENEMY_BULLET=2, PLAYER=3, PLAYER_BULLET=4}
    function Class(_, methods) return methods end
    function New(class, ...)
        local o = {}
        class.init(o, ...)
        return o
    end
end

local runtime = dofile('mod/GAME/th44/native/runtime.lua')
local program = runtime.program
local function equal(actual, expected)
    assert(actual == expected, ('实测 %s，预期 %s'):format(tostring(actual), tostring(expected)))
end

local counts = {339, 332, 414, 382, 770}
local mapRows = {248, 168, 28, 210, 252}
for number, count in ipairs(counts) do
    local stage = program.stages[number]
    equal(#stage.spawns, count)
    equal(#stage.tiles, mapRows[number])
    for _, row in ipairs(stage.tiles) do
        equal(#row, 9)
        for _, tile in ipairs(row) do assert(program.tileRects[tile]) end
    end
    for _, row in ipairs(stage.spawns) do
        assert(row[5] >= stage.pathBase and row[5] < stage.pathBase + #stage.paths)
    end
end

do
    local h, l = program.vector(22, 0x40)
    equal(h, 0)
    equal(l, 0xa3)
    h, l = program.vector(22, 0xc0)
    equal(h, 0)
    equal(l, -0xa3)
end

local function verify(withArt, afterFrame)
    -- 原版在 1462 帧进入 0x60 前的随机索引为 0x0c。
    local run = runtime.init(1,{randomByte=0xc, enemyRank=0x13, fireRank=0x21, trackRank=3, lateRank=7},withArt)
    local function step()
        runtime.step(run)
        if afterFrame then afterFrame() end
    end
    local function reachBossEntry()
        -- 保留原作生成表的游标，让道中一直运行到关底记录前。
        for _ = run.frame, 7000 do
            if run.major == 0x1e7 then break end
            step()
        end
        equal(run.major, 0x1e7)
        local boss = run.stage.spawns[run.spawnIndex]
        equal(boss[1], 0x1e8)
        equal(boss[7], 0x190b0a)
    end
    for _ = 1, 400 do
        step()
        if run.enemies[11] then break end
    end
    local enemy = assert(run.enemies[11])
    equal(run.major, 0x60)
    equal(enemy.callback, 0x167158)
    equal(enemy.h, 0x79b7)
    equal(enemy.l, 0xfeb)
    equal(enemy.attackClock, 0x50)
    for _ = 1, 4 do step() end
    local keys = {}
    local pilot = runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys=keys,life=2})
    for _ = 5, 81 do step() end
    equal(run.bullets[1], nil)
    step()
    equal(enemy.h, 0x5a55)
    equal(enemy.l, 0x931)
    equal(enemy.attackClock, 0x83)
    local bullet = assert(run.bullets[1])
    equal(bullet.callback, 0x181146)
    equal(bullet.h, 0x57d5)
    equal(bullet.l, 0x930)
    equal(bullet.dh, -0xdf)
    equal(bullet.dl, 0)
    step()
    equal(bullet.h, 0x56f6)
    equal(bullet.drawFrame, 2)

    -- 原版 1520 帧首次向右时，A 型以 0xa3 推进横轴。
    keys.right = true
    step()
    equal(pilot.h, 0x1179)
    equal(pilot.l, 0x1563)
    equal(pilot.turn, 1)
    equal(run.cameraOffset, 0)
    keys.right = false

    -- 0x14432c 使用原耐久减少弹攻击力，命中标志下一次敌机更新时消费。
    local shot = {h=enemy.h,l=enemy.l,front=0x80,back=0x100,right=0x80,left=0x80,damage=0x50}
    runtime.collision.shots(run, {shot}, pilot.hitFlags)
    equal(shot.pendingHit, true)
    equal(shot.damage, 0x18)
    equal(enemy.hp, -4)
    step()
    equal(enemy.damaged, true)
    equal(enemy.hp, 0x70)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 连续向右时先按位移累加。触及右界后，向左一帧按画面中心重新计算。
    local pan = {right=true}
    run = runtime.init(1,nil,withArt)
    pilot = runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys=pan,life=2,protect=0xff})
    step()
    equal(run.cameraFine, 0x3c)
    equal(run.cameraStep, 0)
    step()
    equal(run.cameraOffset, 0x40)
    equal(run.cameraStep, 0x40)
    for _ = 3, 20 do step() end
    equal(pilot.l, 0x217c)
    equal(run.cameraOffset, 0x480)
    for _ = 21, 51 do step() end
    equal(pilot.l, 0x3500)
    equal(run.cameraOffset, 0x800)
    equal(run.cameraRelative, false)
    pan.right, pan.left = false, true
    step()
    equal(pilot.l, 0x345d)
    equal(run.cameraOffset, 0x7c0)
    equal(run.cameraStep, -0x40)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 1606 帧的坦克由关卡指令生成。横轴在初始化时镜像到自机的另一侧。
    run = runtime.init(1,{largeRank=0x10,tankRank=7,trackRank=3,carrierRank=0xd},withArt)
    runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2,protect=0xff})
    local first, second
    for _ = 1, 552 do
        step()
        if run.frame == 486 or run.frame == 518 then
            local part
            for _, o in pairs(run.enemies) do
                if o.callback == 0x168b6e and o.attackClock == 0x20 then part = o; break end
            end
            assert(part)
            equal(part.h, 0x763c)
            equal(part.speed, 0x1d)
            equal(part.direction, 0x20)
            if run.frame == 486 then
                first = part
                equal(first.l, 0x3200)
            else
                second = part
                equal(second.l, 0x2600)
            end
        end
    end
    equal(run.major, 0x7e)
    equal(assert(first).l, 0x3200)
    equal(assert(second).attackClock, 0x49)
    local tankShot
    for _, o in pairs(run.bullets) do
        if o.h == 0x4efa and o.l == 0x2420 then tankShot = o; break end
    end
    equal(assert(tankShot).speed, 0x17)
    equal(tankShot.angle, 0x90)
    equal(tankShot.callback, 0x181146)
    -- 1691 帧改用撤退速度表。1820 帧驶离回收边界。
    for _ = 553, 571 do step() end
    equal(first.h, 0x3fe5)
    equal(first.speed, 0)
    equal(first.direction, 0x28)
    equal(first.departing, true)
    for _ = 572, 700 do step() end
    equal(first.h, 0x789c)
    equal(first.l, 0x230a)
    step()
    equal(run.enemies[first.slot], nil)

    -- 1846 帧装入双判定盒机体，1897、1904、1911 帧发出三连射。
    for _ = 702, 726 do step() end
    local carrier
    for _, o in pairs(run.enemies) do
        if o.callback == 0x17417c then carrier = o; break end
    end
    local upper = assert(carrier).extraParts[1]
    equal(run.partSlots[1][carrier.firstPart], carrier)
    equal(run.partSlots[1][carrier.firstPart + 1], upper)
    equal(carrier.h, 0x7f7a)
    equal(carrier.l, 0xa00)
    equal(carrier.attackClock, 0x32)
    equal(carrier.face, 0x1f)
    local function carrierShot(h, salvo)
        local shot
        for _, o in pairs(run.bullets) do
            if o.h == h and o.l == 0xadf and o.drawFrame == 1 then shot = o; break end
        end
        equal(assert(shot).speed, 0x13)
        equal(shot.angle, 0x78)
        equal(shot.dh, -0xce)
        equal(shot.dl, 0x1a)
        equal(carrier.salvoCount, salvo)
    end
    for _ = 727, 777 do step() end
    carrierShot(0x5aac, 1)
    for _ = 1, 7 do step() end
    carrierShot(0x583d, 0)
    for _ = 1, 7 do step() end
    carrierShot(0x55fa, 2)

    -- 只命中上侧判定盒，0x1741ec 在机体回调中同步两个部件的耐久。
    local upperShot = {h=carrier.h + 0x800,l=carrier.l,front=0,back=0x80,right=0x40,left=0x40,damage=0x100}
    runtime.collision.shots(run,{upperShot},0x1000)
    equal(upperShot.pendingHit, true)
    equal(carrier.hp, 0x700)
    equal(upper.hp, 0x640)
    step()
    equal(carrier.hp, 0x640)
    equal(upper.hp, 0x640)

    -- 0x05 坦克在 1958 帧入场，转动底盘后以底盘角度取炮口，以自机方向发射。
    for _ = 793, 838 do step() end
    local movingTank
    for _, o in pairs(run.enemies) do
        if o.callback == 0x168576 then movingTank = o; break end
    end
    equal(assert(movingTank).h, 0x768a)
    equal(movingTank.l, 0x2e00)
    equal(movingTank.direction, 0x20)
    equal(movingTank.attackClock, 0x20)
    step()
    step()
    equal(movingTank.direction, 0x21)
    equal(movingTank.state[0x29], 0x31)
    for _ = 841, 871 do step() end
    equal(movingTank.h, 0x58d1)
    equal(movingTank.l, 0x27c7)
    equal(movingTank.direction, 0x24)
    equal(movingTank.attackClock, 0x4a)
    local movingShot
    for _, o in pairs(run.bullets) do
        if o.h == 0x5412 and o.l == 0x2626 and o.drawFrame == 1 then movingShot = o; break end
    end
    equal(assert(movingShot).speed, 0x17)
    equal(movingShot.angle, 0x90)
    -- 2454 帧先登记增援，2455 帧才分配敌机槽并从父对象的位置运行子路径。
    for _ = 872, 1334 do step() end
    local spawner = assert(run.enemies[3])
    equal(spawner.callback, 0x171314)
    equal(spawner.h, 0x7400)
    equal(spawner.l, 0x4c40)
    equal(spawner.spawnClock, 0x34)
    equal(#run.spawnQueue, 1)
    step()
    local reinforcement
    for _, o in pairs(run.enemies) do
        if o.row.h then reinforcement = o; break end
    end
    equal(#run.spawnQueue, 0)
    equal(assert(reinforcement).kind, 0x11)
    equal(reinforcement.h, 0x73ec)
    equal(reinforcement.l, 0x441e)
    step()
    equal(reinforcement.h, 0x7398)
    equal(reinforcement.l, 0x43fc)

    -- 原版 2598 帧生成中型舰，随机表游标 0x3e 是该次入场前的值。
    for _ = 1337, 1477 do step() end
    run.randomByte = 0x3e
    step()
    local mid = assert(run.mid1)
    local turret = mid.turrets[3]
    equal(mid.partPool, 2)
    equal(mid.h, program.s16(0x8a00))
    equal(mid.l, 0x1c00)
    equal(turret.h, program.s16(0x8c0a))
    equal(turret.l, 0x2904)
    equal(turret.hp, 0x400)
    for _ = 1479, 1690 do step() end
    turret.damage(turret,0x401,0x1000)
    step()
    equal(turret.hp, 0x400)
    equal(turret.flags, 0xa000)
    for _ = 1692, 1798 do step() end
    equal(run.major, 0xd9)
    equal(mid.attackWindow, 1)
    equal(turret.h, 0x55c6)
    equal(turret.l, 0x1ebc)
    local turretShot
    for _, o in pairs(run.bullets) do
        if o.kind == 7 and o.h == 0x56c6 and o.l == 0x1edb then turretShot = o; break end
    end
    equal(assert(turretShot).callback, 0x180ee0)
    equal(turretShot.angle, 0x78)
    equal(turretShot.dh, -0xc3)
    equal(turretShot.dl, 0x18)
    for _ = 1799, 1831 do step() end
    local partShot = {h=turret.h,l=turret.l,front=0,back=0x40,right=0x40,left=0x40,damage=0x556}
    runtime.collision.shots(run,{partShot},0x1000)
    equal(partShot.pendingHit, true)
    equal(turret.hp, -1)
    step()
    equal(turret.flags, 0x8000)
    equal(mid.hp, 0x3500)
    equal(assert(run.effects[1]).kind, 0x85)
    equal(run.effects[1].h, 0x6699)
    equal(run.effects[1].l, 0x2827)
    for _ = 1833, 1889 do step() end
    equal(mid.hatchFrame, 31)
    equal(mid.hatchShots, 1)
    local mainShot
    for _, o in pairs(run.bullets) do
        if o.kind == 3 and o.h == 0x6a52 and o.l == 0x1e94 then mainShot = o; break end
    end
    equal(assert(mainShot).callback, 0x180bc8)
    equal(mainShot.angle, 0x2e)
    for _ = 1890, 1892 do step() end
    equal(mid.hatch, 3)
    local followShot
    for _, o in pairs(run.bullets) do
        if o.kind == 3 and o.h == 0x7d40 and o.l == 0x1c00 and o.angle == 0x80 then followShot = o; break end
    end
    equal(assert(followShot).dh, -0x101)
    for _ = 1893, 1910 do step() end
    -- 0x18048a 在中 Boss 击破帧从敌弹当前位置分配小道具，首帧保留坐标。
    local cleared, firstH, firstL = 0
    for slot = 1, run.bulletCapacity do
        local o = run.bullets[slot]
        if o then
            cleared = cleared + 1
            if not firstH and o.h >= -0x800 and o.h < 0x9800 and o.l >= -0xe00 and o.l < 0x4600 then
                firstH, firstL = o.h, o.l
            end
        end
    end
    local priorScore = run.player.score
    mid.damage(mid,0x3501,0x1000)
    step()
    equal(mid.deathTimer, 0x70)
    equal(run.mid1Defeated, true)
    equal(next(run.bullets), nil)
    equal(run.player.score - priorScore, 23 * cleared)
    local chip = assert(run.items[1])
    equal(chip.kind, 0)
    equal(chip.h, firstH)
    equal(chip.l, firstL)
    for _, part in ipairs(mid.turrets) do equal(part.flags, 0x8000) end
    equal(assert(run.effects[1]).kind, 12)
    equal(assert(run.effects[2]).kind, 13)
    equal(#run.spawnQueue, 1)
    equal(run.spawnQueue[1][3], 0x1c)
    equal(run.visibleTop, 0x30)
    assert(run.visibleRows[1] ~= program.mid1Wreck[2])
    step()
    equal(run.visibleRows[1], program.mid1Wreck[2])
    equal(run.visibleRows[15], program.mid1Wreck[16])
    for _ = 2, 0x40 do step() end
    equal(mid.released, true)
    equal(run.scrollSpeed[1], 0x20)
    for _ = 1, 0x30 do step() end
    equal(run.mid1, nil)
    equal(run.enemies[mid.slot], nil)
    reachBossEntry()
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 一面的首架大机在原版 1630 帧生成。用相同的三个 Rank 字段核对第一轮齐射。
    run = runtime.init(1,{major=0x79,largeRank=0x10,salvoRank=0xa,trackRank=3},withArt)
    run.scrollSpeed = {0x40,0x40}
    run.spawnIndex = #run.stage.spawns + 1
    run.scrollIndex = {#run.stage.scroll[1] + 1,#run.stage.scroll[2] + 1}
    for _, row in ipairs(run.stage.spawns) do
        if row[3] == 0x10 then
            enemy = assert(runtime.spawn(run,row))
            break
        end
    end
    runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2})
    step()
    equal(enemy.h, 0x7877)
    equal(enemy.l, 0x2eeb)
    equal(enemy.attackClock, 0x3f)
    equal(enemy.face, 0x2d)
    equal(enemy.salvoCount, 2)
    for _ = 1, 62 do step() end
    equal(run.bullets[1], nil)
    step()
    equal(enemy.h, 0x6680)
    equal(enemy.l, 0x29c0)
    equal(enemy.attackClock, 7)
    equal(enemy.face, 0x24)
    equal(enemy.salvoCount, 1)
    equal(assert(run.bullets[1]).callback, 0x1810ec)
    for _ = 1, 7 do step() end
    equal(enemy.h, 0x6481)
    equal(enemy.l, 0x292d)
    equal(enemy.attackClock, 7)
    equal(enemy.salvoCount, 0)
    for _ = 1, 7 do step() end
    equal(enemy.h, 0x6282)
    equal(enemy.l, 0x289a)
    equal(enemy.attackClock, 0x36)
    equal(enemy.salvoCount, 2)
    runtime.close(run)
    if afterFrame then afterFrame() end

    local function shipFixture()
        run = runtime.init(1,{major=0xa8,tankRank=7,salvoRank=0xa},withArt)
        run.scrollSpeed = {0x40,0x40}
        run.spawnIndex = #run.stage.spawns + 1
        run.scrollIndex = {#run.stage.scroll[1] + 1,#run.stage.scroll[2] + 1}
        runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2,protect=0xff})
        for _, row in ipairs(run.stage.spawns) do
            if row[3] == 0x80 then return assert(runtime.spawn(run,row)) end
        end
    end

    -- 2134 帧入场，2237 和 2254 帧先后使用两张炮口表。
    local ship = shipFixture()
    step()
    equal(ship.h, program.s16(0x8a27))
    equal(ship.l, 0x1bc0)
    equal(ship.mainClock, 0x49)
    for _ = 2135, 2237 do step() end
    equal(run.bullets[9], nil)
    local fan = assert(run.bullets[1])
    equal(fan.kind, 4)
    equal(fan.callback, 0x180c84)
    equal(fan.h, 0x6630)
    equal(fan.l, 0x1cc8)
    equal(fan.angle, 0x69)
    equal(fan.dh, -0xbc)
    equal(fan.dl, 0x4e)
    step()
    equal(fan.drawFrame, 2)
    step()
    equal(fan.drawFrame, 2)
    for _ = 2240, 2254 do step() end
    equal(ship.turretPhase, true)
    fan = assert(run.bullets[9])
    equal(fan.kind, 5)
    equal(fan.callback, 0x180d40)
    equal(fan.h, 0x62a6)
    equal(fan.l, 0x1db8)
    equal(fan.angle, 0x61)
    for _ = 2255, 2287 do step() end
    local firstTurret
    for _, o in pairs(run.bullets) do
        if o.kind == 0x13 and o.l == 0x1fc0 then firstTurret = o; break end
    end
    equal(assert(firstTurret).callback, 0x18130c)
    equal(firstTurret.h, 0x62e8)
    equal(firstTurret.dh, 0)
    step()
    equal(firstTurret.h, 0x62e8)
    equal(firstTurret.dh, -0xef)
    step()
    equal(firstTurret.h, 0x61f9)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 原版在 2249 帧由命中标志进入 0x172616，一次登记六个主爆炸和碎片对象。
    ship = shipFixture()
    for _ = 2134, 2248 do step() end
    local damaged = ship.extraParts[1]
    damaged.damage(damaged,damaged.hp + 1,0x1000)
    step()
    equal(run.enemies[ship.slot], nil)
    equal(run.partSlots[ship.partPool][ship.firstPart + 1], nil)
    equal(run.effects[1].h, 0x6e70)
    equal(run.effects[2].h, 0x684c)
    equal(run.effects[2].l, 0x21ed)
    equal(run.effects[3].h, 0x684d)
    equal(run.effects[4].delay, 1)
    equal(run.effects[6].delay, 3)
    for _ = 2250, 2253 do step() end
    equal(run.effects[4].h, 0x67b1)
    equal(run.effects[5].l, 0x1cdc)
    equal(run.effects[6].h, 0x69ea)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 1511 帧短按，1513 帧飞行。两个机型各自使用 0x152ce8 分发表里的回调。
    local flight = {{15,22,0x1539,0x1380,0x18b8,0x1376,0x2f}, {15,16,0x13f9,0x1680,0x16c5,0x1694,0x2d}}
    for model, record in ipairs(flight) do
        run = runtime.init(1,nil,withArt)
        local tap = {shoot=true}
        pilot = runtime.addPlayer(run,model,1,{h=0x1179,l=0x14c0,keys=tap,life=2,protect=0xff})
        step()
        local shot = assert(pilot.shots[record[1]])
        equal(shot.h, record[3])
        equal(shot.l, record[4])
        equal(shot.damage, record[7])
        assert(pilot.shots[record[2]])
        tap.shoot = false
        step()
        equal(shot.h, record[3])
        step()
        equal(shot.h, record[5])
        equal(shot.l, record[6])
        step()
        equal(pilot.shotBurst, 1)
        for _ = 1, 3 do step() end
        equal(pilot.shotBurst, 0)
        runtime.close(run)
        if afterFrame then afterFrame() end
    end

    run = runtime.init(1,nil,withArt)
    pilot = runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2,protect=0})
    -- 只把该敌弹放在受击盒内。命中、坠毁和扣残机均由正常回调处理。
    local birth = program.bulletOffsets[17]
    bullet = assert(runtime.bullets.emit(run,0x0d,0,0x20,pilot.h - birth[1],pilot.l - birth[2]))
    step()
    equal(pilot.pendingHit, bullet)
    equal(bullet.flags, 0x900d)
    step()
    equal(run.bullets[1], nil)
    equal(pilot.active, false)
    equal(pilot.misses, 1)
    equal(pilot.life, 2)
    for _ = 1, 69 do step() end
    equal(pilot.life, 2)
    step()
    equal(pilot.life, 1)
    equal(pilot.active, false)
    equal(run.enemyShotGrace, 0x78)
    equal(runtime.bullets.emit(run,0x0d,0,0x20,0x1200,0x1800), nil)
    step()
    equal(pilot.active, false)
    step()
    -- 1924 帧登记坠毁，1994 帧扣残机，1996 帧装入补机。
    equal(pilot.active, true)
    equal(pilot.h, 0x1000)
    equal(pilot.l, 0x0e00)
    equal(pilot.protect, 0xf0)
    step()
    equal(pilot.protect, 0xef)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 0x82 的两侧固定管在 3164 帧开火，炮塔在 3184 帧独立开火。
    run = runtime.init(1,{major=0xe3,rapidRank=0x15,largeRank=0x11,salvoRank=0xa},withArt)
    runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2,protect=0xff})
    run.scrollIndex = {math.huge,math.huge}
    local artillery
    while run.stage.spawns[run.spawnIndex][1] < 0xe3 do
        run.spawnIndex = run.spawnIndex + 1
    end
    step()
    for _, enemy in pairs(run.enemies) do
        if enemy.kind == 0x82 then artillery = enemy; break end
    end
    assert(artillery)
    equal(artillery.h, program.s16(0x8674))
    equal(artillery.l, 0x2000)
    equal(artillery.mainClock, 0x36)
    equal(artillery.turretClock, 0x4a)
    run.spawnIndex = math.huge
    for _ = 3104, 3163 do step() end
    equal(run.bullets[1], nil)
    step()
    for slot, x in ipairs({0x1a9f, 0x249f}) do
        local shell = assert(run.bullets[slot])
        equal(shell.h, 0x532a)
        equal(shell.l, x)
        equal(shell.angle, 0x86 + (slot - 1) * 8)
        equal(shell.speed, 0x19)
        equal(shell.callback, 0x1810ec)
    end
    for _ = 3165, 3184 do step() end
    local shell = assert(run.bullets[9])
    equal(shell.h, 0x542e)
    equal(shell.l, 0x1f1f)
    equal(shell.angle, 0x88)
    equal(shell.speed, 0x18)
    equal(shell.callback, 0x180ee0)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 中 Boss 未击破时也有独立的卷轴和敌机生成条件。
    run = runtime.init(1,{largeRank=0x10,tankRank=7,trackRank=3,carrierRank=0xd,salvoRank=0xa},withArt)
    runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2,protect=0xff})
    reachBossEntry()
    runtime.close(run)
end

if arg and arg[1] == '--luastg' then return verify end
verify(false)
print('大往生首面道中、中 Boss 炮台和舱门、部件击破、自机机体弹、受击及补机回归通过。')
