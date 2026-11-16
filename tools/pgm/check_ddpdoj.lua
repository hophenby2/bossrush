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
    GROUP = {GHOST=0, ENEMY=1, ENEMY_BULLET=2, PLAYER=3, PLAYER_BULLET=4}
    LAYER = {BG=0, ENEMY=1, ENEMY_BULLET=2, PLAYER=3, PLAYER_BULLET=4}
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
equal(#program.boss1.tailMuzzles,15)
equal(#program.boss1.tail[22],120)
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
    equal(program.inAimBounds({stageNumber=2,loop=0},0x2a00,0x0e00),false)
    equal(program.inAimBounds({stageNumber=2,loop=1},0x2a00,0x0e00),true)
    equal(program.inAimBounds({stageNumber=2,loop=2},0x2a00,0x0e00),true)
end

-- 原版受控断点测试直接给定对应帧的 Rank 字段。
local function fixture(stage,state,withArt)
    state = state or {}
    state.staticRank = true
    if state.difficulty == nil then state.difficulty = 0 end
    return runtime.init(stage,state,withArt)
end

local function verify(withArt, afterFrame)
    -- 原程序第 1462、7400 和 11200 帧的 Rank 工作区，含面间保留的时间计数。
    for _,sample in ipairs({
        {1,0x159,{0x35,0x30,0x2d,0x2a,0x27,0x24,0x21,0x1d,0x1a,0x16,0x13,0x10,0x0d,0x0a,7,3}},
        {1,0x95f,{0x3d,0x37,0x34,0x30,0x2d,0x29,0x26,0x21,0x1e,0x19,0x16,0x12,0x0f,0x0b,8,3}},
        {2,0x95f,{0x4d,0x46,0x42,0x3d,0x39,0x34,0x30,0x2a,0x26,0x20,0x1c,0x17,0x13,0x0e,0x0a,4}},
    }) do
        local rankRun = runtime.init(sample[1],{rankTime=sample[2]})
        for i,expected in ipairs(sample[3]) do equal(rankRun.ranks[2*i],expected) end
        rankRun.freeze = true
        runtime.step(rankRun)
        equal(rankRun.rankTime,sample[2])
        runtime.close(rankRun)
    end
    -- 原版在 1462 帧进入 0x60 前的随机索引为 0x0c。
    local run = fixture(1,{randomByte=0xc, enemyRank=0x13, fireRank=0x21, trackRank=3, lateRank=7},withArt)
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
    equal(enemy.hp, -0x18)
    step()
    equal(enemy.damaged, true)
    equal(enemy.hp, 0x70)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 连续向右时先按位移累加。触及右界后，向左一帧按画面中心重新计算。
    local pan = {right=true}
    run = fixture(1,nil,withArt)
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
    run = fixture(1,{largeRank=0x10,tankRank=7,trackRank=3,carrierRank=0xd},withArt)
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
    equal(upper.hp, 0x600)
    step()
    equal(carrier.hp, 0x600)
    equal(upper.hp, 0x600)

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
    local partShot = {h=turret.h,l=turret.l,front=0,back=0x40,right=0x40,left=0x40,damage=0x401}
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
    equal(run.player.score - priorScore, 1 + 353 + 23 * cleared)
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
    run = fixture(1,{major=0x79,largeRank=0x10,salvoRank=0xa,trackRank=3},withArt)
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
        run = fixture(1,{major=0xa8,tankRank=7,salvoRank=0xa},withArt)
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
        run = fixture(1,nil,withArt)
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

    -- 1518 帧按下 A，1520 帧按下右。各机体与人形采用同一组原版输入。
    local focusCases = {
        {1,1,0,17,0x1a0a,21,0x20d9,0x94,0x15}, {1,2,0x27,11,0x1a0a,14,0x1c64,0x9c,0x16},
        {1,3,0,12,0x1aa7,15,0x1d07,0x9e,0x16}, {2,1,0,17,0x1a58,24,0x2019,0x8e,0x11},
        {2,2,0x26,12,0x1a58,15,0x1b81,0x9c,0x12}, {2,3,0,12,0x1af5,15,0x1b81,0xa0,0x12},
    }
    local optionCases = {
        {{1,0x1639,0x1ce2,0x44,0x01,0x1c,0x1931,0x1cea},{8,0x1639,0x0c9d,0x44,0xff,0x1c,0x1931,0x0c95}},
        {{1,0x18f9,0x0f40,0x48,0x00,0x20,0x1c1e,0x0f40},{24,0x1cf9,0x1a40,0x48,0,0x20,0x201e,0x1a40}},
        {{1,0x0f11,0x0d5e,0x4a,0xfe,0x1e,0x124c,0x0d47},{2,0x0f11,0x1c22,0x4a,2,0x1e,0x124c,0x1c39}},
        {{1,0x1639,0x1d2c,0x40,0x10,0x1f,0x18cd,0x1ddc},{8,0x1639,0x0c53,0x40,0xf0,0x1f,0x18cd,0x0ba3}},
        {{1,0x18b9,0x1000,0x48,0xf8,0x23,0x1bc8,0x0f9d},{24,0x1d39,0x1980,0x48,8,0x23,0x2048,0x19e3}},
        {{1,0x0edb,0x0d1f,0x46,0xf4,0x21,0x11c2,0x0c8b},{2,0x0edb,0x1c61,0x46,0x0c,0x21,0x11c2,0x1cf5}},
    }
    for case, c in ipairs(focusCases) do
        local model,doll,orbit,mergeFrame,optionH,birthFrame,beamL,damage,speed = unpack(c)
        run = fixture(1,nil,withArt)
        run.spawnIndex = #run.stage.spawns + 1
        local hold = {shoot=true}
        pilot = runtime.addPlayer(run,model,doll,{h=0x1179,l=0x14c0,keys=hold,life=2,protect=0xff})
        local s = pilot.laserState
        s.orbit = orbit
        for frame = 1,mergeFrame - 1 do
            hold.right = frame >= 3
            step()
            equal(s.merged,false)
            if frame <= 3 then
                for _, r in ipairs(optionCases[case]) do
                    local o = assert(pilot.shots[r[1]])
                    equal(o.isOption,true)
                    equal(o.h,frame == 3 and r[7] or r[2])
                    equal(o.l,frame == 3 and r[8] or r[3])
                    equal(o.speed,r[4])
                    equal(o.angle,r[5])
                    equal(o.damage,r[6])
                end
            end
        end
        step()
        equal(s.merged,true)
        equal(s.options[1].h,optionH)
        equal(s.options[1].l,s.options[2].l)
        equal(s.head.cursor,0)
        for _ = mergeFrame + 1,birthFrame - 1 do
            step()
            equal(s.beam,nil)
        end
        step()
        local beam = assert(s.beam)
        equal(beam.h,0x1979)
        equal(beam.l,beamL)
        equal(beam.length,0)
        equal(beam.right,0x180)
        equal(beam.damage,damage)
        equal(pilot.speed,speed)
        step()
        equal(beam.length,0x800)
        step()
        equal(beam.length,0x1000)

        hold.right = false
        for _ = 1,13 do step() end
        local function target(h,slot)
            local o = {h=h,l=pilot.l,hp=0x7fff,front=0x100,back=0x100,right=0x100,left=0x100,flags=0xa000}
            function o.damage(part,amount,flags)
                part.hp,part.lastFlags = part.hp - amount,flags
            end
            run.partSlots[1][slot] = o
            return o
        end
        local nearer,farther = target(0x3400,1),target(0x3a00,2)
        -- 0x171314 占用部件槽。炮口扫描跳过只登记路径调度的槽。
        run.partSlots[1][3] = {h=pilot.h,l=pilot.l,flags=0x8000}
        repeat step() until run.frame % 2 == 1
        equal(nearer.hp,0x7fff - damage)
        equal(nearer.lastFlags,0x1400)
        equal(farther.hp,0x7fff)
        equal(beam.hit,true)
        equal(beam.endH,0x3300)
        step()
        equal(beam.length,0x3300 - 0x1979)
        equal(nearer.hp,0x7fff - damage)
        step()
        equal(nearer.hp,0x7fff - damage * 2)

        local lockedSpeed = pilot.speed
        hold.shoot = false
        step()
        equal(s.beam,nil)
        equal(s.angle,2)
        equal(next(s.segments),nil)
        equal(pilot.speed,lockedSpeed + 1)
        runtime.close(run)
        if afterFrame then afterFrame() end
    end

    -- V101 第 1847 至 1890 帧由补给机消费连续的激光受击位。
    run = fixture(1,{major=0x94},withArt)
    run.spawnIndex = #run.stage.spawns + 1
    run.scrollIndex = {math.huge,math.huge}
    pilot = runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2,protect=0xff})
    local function spawnForCheck(callback)
        for _,row in ipairs(run.stage.spawns) do
            if row[7] == callback then return assert(runtime.spawn(run,row)) end
        end
        error('缺少待验证的生成记录')
    end
    local supplyCarrier = spawnForCheck(0x17417c)
    local laserSamples = {
        [1]={9,0,30,30,0,0}, [31]={9,0,0,0,0,0}, [32]={9,1,30,8,16,1},
        [41]={9,1,21,8,32,1}, [44]={29,2,30,5,32,27},
    }
    for i=1,44 do
        supplyCarrier.damage(supplyCarrier,i == 44 and 0x701 or 0,0x1400)
        step()
        local expected = laserSamples[i]
        if expected then
            equal(pilot.comboClock,expected[1])
            equal(pilot.comboHits,expected[2])
            equal(pilot.laserHitWait,expected[3])
            equal(pilot.hyperHitWait,expected[4])
            equal(pilot.hyperGauge,expected[5])
            equal(pilot.score,expected[6])
        end
    end
    equal(run.enemies[supplyCarrier.slot],nil)
    equal(assert(run.airSupply[1]).kind,0)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 一面 Boss 的激光入口用另一套 HIT 和分值，每批充能改为 4。
    run = fixture(1,{major=0x1e8},withArt)
    run.spawnIndex = #run.stage.spawns + 1
    run.scrollIndex = {math.huge,math.huge}
    pilot = runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2,protect=0xff})
    pilot.laserLevel,pilot.hyperHitWait,pilot.hyperGauge = 2,5,32
    local bossCharge = spawnForCheck(0x190b0a)
    local bossSamples = {[1]={14,0,5,32},[7]={8,0,8,36},[16]={14,1,8,40},[41]={4,2,1,48}}
    for i=1,41 do
        bossCharge.damage(bossCharge,0,0x1400)
        step()
        local expected = bossSamples[i]
        if expected then
            equal(pilot.bossComboClock,9)
            equal(pilot.laserHitWait,expected[1])
            equal(pilot.bossHits,expected[2])
            equal(pilot.hyperHitWait,expected[3])
            equal(pilot.hyperGauge,expected[4])
            equal(pilot.score,i - 1)
        end
    end
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 0x17d816 的道具在原版 1522 帧开始下落，拾取后由 0x15231a 写入库存计时。
    run = fixture(1,{major=0x14},withArt)
    run.spawnIndex = #run.stage.spawns + 1
    run.scrollIndex = {math.huge,math.huge}
    local hyperKeys = {}
    pilot = runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys=hyperKeys,life=2,protect=0xff})
    runtime.hyper.gain(pilot,0x95f)
    equal(run.hyperItems[1],nil)
    runtime.hyper.gain(pilot,1)
    local reward = assert(run.hyperItems[1])
    equal(reward.h,0x7000)
    equal(pilot.hyperGauge,0)
    for _,position in ipairs({{0x6fb4,0x141f},{0x6f68,0x143e},{0x6f1c,0x145d},{0x6edc,0x147d}}) do
        step()
        equal(reward.h,position[1])
        equal(reward.l,position[2])
    end
    pilot.h,pilot.l = reward.h,reward.l
    step()
    equal(reward.taken,true)
    equal(pilot.hyperStock,0)
    step()
    equal(pilot.hyperStock,1)
    equal(pilot.hyperClock,0x95f)
    equal(reward.textFrame,1)
    pilot.h,pilot.l = 0x1600,0x1c00
    hyperKeys.spell = true
    step()
    equal(pilot.hyperPower,1)
    equal(pilot.hyperRank,1)
    equal(pilot.hyperClock,0x95d)
    equal(pilot.protect,0x50)
    equal(run.hyperBulletRank,0)
    equal(pilot.bombs,3)
    hyperKeys.spell,hyperKeys.shoot = false,true
    step()
    equal(run.hyperBulletRank,1)
    local body,option = assert(pilot.shots[15]),assert(pilot.shots[1])
    equal(body.h,0x1dc0)
    equal(body.l,0x1880)
    equal(body.speed,0xe8)
    equal(body.damage,0x35)
    equal(option.h,0x1bc0)
    equal(option.l,0x262a)
    equal(option.speed,0xa8)
    equal(option.damage,0x22)
    for _=1,18 do step() end
    local hyperBeam = assert(pilot.laserState.beam)
    equal(hyperBeam.right,0x680)
    equal(hyperBeam.damage,0x96)
    runtime.hyper.gain(pilot,0x960)
    equal(pilot.hyperQueued,1)
    hyperKeys.shoot = false
    while pilot.hyperClock > 1 do step() end
    equal(pilot.hyperPower,1)
    step()
    equal(pilot.hyperPower,nil)
    equal(pilot.hyperClock,0)
    equal(pilot.hyperQueued,0)
    equal(assert(run.hyperItems[1]).h,0x7000)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- V101 在 1556 帧消费库存。普通炸弹来自 0x155720，激光炸弹来自 0x155e8e。
    for model = 1,2 do
        for _, mode in ipairs({'shot','laser'}) do
            run = fixture(1,{major=0x14},withArt)
            run.spawnIndex = #run.stage.spawns + 1
            run.scrollIndex = {math.huge,math.huge}
            local keys = {shoot=mode == 'laser'}
            local l = (mode == 'laser' and {0x2626,0x22e2} or {0x2694,0x234c})[model]
            pilot = runtime.addPlayer(run,model,1,{h=0x1179,l=l,keys=keys,life=2,protect=0xff})
            for _ = 1,37 do step() end
            if mode == 'shot' then
                local projectile = runtime.bullets.emit(run,0xd,0,0x20,0x4000,0xe00)
                assert(projectile)
            end
            keys.spell = true
            step()
            keys.spell,keys.shoot = false,false
            local bomb = assert(pilot.bomb)
            equal(bomb.mode,mode)
            equal(pilot.bombs,2)
            equal(pilot.bombsUsed,1)
            equal(pilot.protect,0xff)
            equal(bomb.l,l)
            local endFrame
            if mode == 'shot' then
                equal(bomb.h,0x4400)
                equal(bomb.front,0x1800)
                equal(next(run.bullets),nil)
                equal(runtime.bullets.emit(run,0xd,0,0x20,0x4000,0xe00),nil)
                equal(pilot.speed,pilot.baseSpeed + 6)
                for _ = 1,5 do step() end
                equal(bomb.phase,0)
                step()
                equal(bomb.phase,1)
                equal(bomb.cycles,6)
                endFrame = 146
            else
                equal(pilot.laserState.beam,nil)
                equal(bomb.h,0x1179)
                equal(bomb.front,0x1200)
                equal(bomb.clock,0x77)
                equal(bomb.trail[1].h,0x1779)
                local function makePart(h,bank,slot)
                    local part = {h=h,l=l,hp=0x7fff,front=0x100,back=0x100,right=0x100,left=0x100,flags=0xa000}
                    function part.damage(o,amount,flags)
                        o.hp,o.hit = o.hp - amount,flags
                    end
                    run.partSlots[bank][slot] = part
                    return part
                end
                local close,far = makePart(0x2000,1,99),makePart(0x5000,1,100)
                local ground = makePart(0x3300,2,49)
                step()
                equal(bomb.clock,0x76)
                equal(bomb.trail[1].h,0x1b79)
                equal(bomb.trail[2].h,0x1779)
                equal(close.hp,0x7a5f)
                equal(close.hit,0x1400)
                for _ = 1,5 do step() end
                equal(ground.hp,0x7fff)
                step()
                equal(ground.hp,0x7df7)
                equal(bomb.endH,0x3200)
                equal(far.hp,0x7fff)
                step()
                equal(pilot.h,0x1131)
                equal(ground.hp,0x7df7)
                run.partSlots[1][99],run.partSlots[1][100],run.partSlots[2][49] = nil,nil,nil
                endFrame = 169
            end
            for _ = run.frame + 1,endFrame - 1 do step() end
            equal(pilot.bomb,bomb)
            step()
            equal(pilot.bomb,nil)
            equal(pilot.protect,0x28)
            step()
            equal(pilot.protect,0x27)
            runtime.close(run)
            if afterFrame then afterFrame() end
        end
    end

    -- 0x17d394 从初速和角度推出空中 P 的每帧位置。拾取标志在下一帧才升级武器。
    run = fixture(1,{randomByte=23,major=0x14},withArt)
    run.spawnIndex = #run.stage.spawns + 1
    run.scrollIndex = {math.huge,math.huge}
    pilot = runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2,bombs=1,protect=0xff})
    local power = assert(runtime.supply.emit({run=run,h=0x4000,l=0x1c00},0))
    for index,position in ipairs({{0x3f8f,0x1c1e},{0x3f1e,0x1c3c},{0x3ead,0x1c5a},{0x3e3c,0x1c78}}) do
        step()
        equal(power.h,position[1])
        equal(power.l,position[2])
        equal(power.angle,0x1c)
        equal(power.remaining,0x700 - index)
    end
    equal(power.front,0x600)
    equal(power.right,0x500)
    pilot.h,pilot.l = power.h,power.l
    step()
    equal(power.taken,true)
    equal(pilot.laserLevel,1)
    step()
    equal(pilot.shotLevel,2)
    equal(pilot.laserLevel,2)
    equal(pilot.score,10)
    equal(power.text,true)
    for _,reward in ipairs({{4,9},{8,11},{0x10,25}}) do
        local pickup = assert(runtime.supply.emit(pilot,reward[1]))
        equal(pickup.slot,reward[2])
    end
    step()
    step()
    equal(pilot.shotLevel,5)
    equal(pilot.laserLevel,5)
    equal(pilot.bombs,2)
    equal(pilot.life,3)
    equal(pilot.score,40)
    local surplus = assert(runtime.supply.emit(pilot,0))
    step()
    step()
    equal(surplus.text,true)
    equal(#surplus.images,17)
    equal(pilot.score,1040)
    for _ = 1,60 do step() end
    equal(next(run.airSupply),nil)
    for i,threshold in ipairs({1000000,3000000}) do
        pilot.score,pilot.shotLevel,pilot.laserLevel = threshold - 10,1,1
        local pickup = assert(runtime.supply.emit(pilot,0))
        for _ = 1,3 do step() end
        equal(pickup.text,true)
        equal(pilot.score,threshold)
        equal(pilot.life,3 + i)
        equal(pilot.scoreExtends,i)
    end
    runtime.close(run)
    if afterFrame then afterFrame() end

    run = fixture(1,nil,withArt)
    pilot = runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2,protect=0})
    pilot.shotLevel,pilot.laserLevel = 3,2
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
    equal(run.airSupply[1].kind,0)
    equal(run.airSupply[2].kind,0)
    equal(run.airSupply[3].kind,0)
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
    equal(pilot.shotLevel,2)
    equal(pilot.laserLevel,2)
    equal(pilot.maxBombs,4)
    equal(pilot.bombs,4)
    equal(pilot.h, 0x1000)
    equal(pilot.l, 0x0e00)
    equal(pilot.protect, 0xf0)
    step()
    equal(pilot.protect, 0xef)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 0x82 的两侧固定管在 3164 帧开火，炮塔在 3184 帧独立开火。
    run = fixture(1,{major=0xe3,rapidRank=0x15,largeRank=0x11,salvoRank=0xa},withArt)
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
    run = fixture(1,{largeRank=0x10,tankRank=7,trackRank=3,carrierRank=0xd,salvoRank=0xa},withArt)
    runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2,protect=0xff})
    reachBossEntry()
    local seen = {}
    for _ = 1, 3000 do
        step()
        local boss = run.boss1
        if boss and boss.phase then
            seen[boss.phase] = true
            if seen[8] and boss.phase == 2 then break end
        end
    end
    for _, phase in ipairs({0,2,3,4,5,6,7,8}) do equal(seen[phase],true) end
    local lateBoss = assert(run.boss1)
    lateBoss.health = 1
    lateBoss.damage(lateBoss,4,0x1000)
    for _ = 1,620 do
        if run.stageCleared then break end
        step()
    end
    equal(run.stageCleared, true)
    equal(run.boss1, nil)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 关底从生成表挂载流程任务，直到原版 7878 帧才推进入场座标。
    run = fixture(1,{major=0x1e8,randomByte=0x9f},withArt)
    pilot = runtime.addPlayer(run,1,1,{h=0x1179,l=0x14c0,keys={},life=2,protect=0xff})
    run.scrollIndex = {math.huge,math.huge}
    step()
    local boss = assert(run.boss1)
    equal(boss.callback, 0x190b0a)
    equal(boss.timeout, 0x2a2f)
    equal(boss.health, 0x16c00)
    equal(boss.wings[1].health, 0x9000)
    equal(boss.wings[2].health, 0x9000)
    equal(boss.flags, 0x8000)
    equal(boss.h, program.s16(0x97ff))
    for _ = 1,191 do step() end
    equal(boss.phase, nil)
    step()
    equal(boss.phase, 0)
    equal(boss.h, program.s16(0x96b4))
    equal(boss.l, program.s16(0xfe14))
    equal(boss.wings[1].l, 0x0dac)
    equal(boss.wings[2].l, program.s16(0xee7c))
    for _ = 193,271 do step() end
    equal(boss.flags, 0x8000)
    step()
    equal(boss.h, 0x5174)
    equal(boss.l, 0x1ebb)
    equal(boss.flags, 0xa001)
    equal(boss.wings[1].flags, 0xa001)
    step()
    equal(boss.phase, 5)
    for _ = 274,294 do step() end
    equal(run.bullets[1], nil)
    step()
    local mainShell = assert(run.bullets[1])
    equal(mainShell.h, 0x5e03)
    equal(mainShell.l, 0x213d)
    equal(mainShell.angle, 0x98)
    equal(mainShell.speed, 0x18)
    equal(mainShell.callback, 0x1810ec)
    for _ = 296,332 do step() end
    step()
    equal(boss.phase, 2)
    equal(boss.h, 0x5b0b)
    equal(boss.l, 0x1c39)
    for _ = 334,559 do step() end
    equal(boss.h, 0x58cb)
    equal(boss.l, 0x14c4)
    local leftShell
    for _, shell in pairs(run.bullets) do
        if shell.kind == 7 and shell.h == 0x4bfd and shell.l == 0x25f6 then leftShell = shell; break end
    end
    equal(assert(leftShell).angle, 0x7d)
    equal(leftShell.speed, 0x12)
    equal(leftShell.callback, 0x180ee0)
    -- 只命中左侧盒。0x192f80 在处理右翼时读取左翼击破位。
    local wing = boss.wings[1]
    local wingH,wingL = wing.h,wing.l
    wing.health = 1
    local wingHit = {h=wing.h,l=wing.l,front=0,back=0x40,right=0x40,left=0x40,damage=4}
    runtime.collision.shots(run,{wingHit},0x1000)
    equal(wingHit.pendingHit, true)
    step()
    equal(boss.wings[1].broken, true)
    equal(boss.wings[2].broken, true)
    equal(boss.health, 0x16c00)
    equal(boss.clearClock, 0x6d)
    local wingDrop = assert(run.hyperItems[1])
    equal(wingDrop.h,wingH - 0x4c)
    equal(wingDrop.l,wingL + 0x1f - run.cameraStep)
    boss.health = 1
    boss.damage(boss,4,0x1000)
    step()
    equal(boss.dying, true)
    equal(boss.phase, 1)
    equal(pilot.protect, 0xff)
    assert(not run.stageCleared)
    for _ = 1,620 do
        if run.stageCleared then break end
        step()
    end
    equal(run.stageCleared, true)
    equal(run.boss1, nil)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 第二面 9501 帧生成 0x95，9659 帧舱门打开后两个炮口各发两弹。
    run = fixture(2,{salvoRank=0x12,cannonRank=0xc,tankRank=6},withArt)
    runtime.addPlayer(run,1,1,{h=0xc00,l=0xe00,keys={},life=2,protect=0xff})
    local airframe
    for _ = 1,400 do
        step()
        if run.major == 0xc then
            for _, enemy in pairs(run.enemies) do
                if enemy.kind == 0x95 then airframe = enemy; break end
            end
        end
        if airframe then break end
    end
    equal(assert(airframe).h,program.s16(0x97b2))
    equal(airframe.l,0x1000)
    equal(airframe.hp,0x980)
    equal(airframe.fixedGap,0x14)
    run.spawnIndex = math.huge
    for _ = 9502,9659 do step() end
    equal(airframe.hatch,2)
    equal(airframe.hatchFrame,7)
    for _, expect in ipairs({{0x16df,0x17,0x86},{0x169f,0x1a,0x8c},
                             {0x08ff,0x17,0x7c},{0x08ff,0x1a,0x82}}) do
        local shell
        for _, bullet in pairs(run.bullets) do
            if bullet.kind == 11 and bullet.h == 0x668e and bullet.l == expect[1] and bullet.angle == expect[3] then
                shell = bullet
                break
            end
        end
        equal(assert(shell).speed,expect[2])
        equal(shell.callback,0x181092)
    end
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 第二面的开场生成表经过浮炮、地炮。
    run = fixture(2,{groundRank=0x19,largeRank=0x1f,tankRank=6},withArt)
    runtime.addPlayer(run,1,1,{h=0x1000,l=0x0e00,keys={},life=2,protect=0xff})
    local floating
    for _ = 1,600 do
        step()
        if run.major == 0x1e then
            for _, enemy in pairs(run.enemies) do
                if enemy.kind == 0x8d then floating = enemy; break end
            end
        end
        if floating then break end
    end
    equal(assert(floating).h,0x78c0)
    equal(floating.l,0x3ac0)
    equal(floating.hp,0x140)
    floating.damage(floating,0x141,0x1000)
    step()
    equal(floating.debris,true)
    equal(floating.hp,0x140)
    floating.damage(floating,0x141,0x1000)
    step()
    equal(run.enemies[floating.slot],nil)
    local ground
    for _ = 1,950 do
        if run.major == 0x53 then break end
        step()
        for _, enemy in pairs(run.enemies) do
            if enemy.kind == 0x8f then ground = enemy end
        end
    end
    assert(ground)
    equal(run.major,0x53)
    equal(run.stage.spawns[run.spawnIndex][1],0x54)
    equal(run.stage.spawns[run.spawnIndex][7],0x173b18)
    for _ = run.frame,9000 do
        if run.major == 0x1db then break end
        step()
    end
    equal(run.major,0x1db)
    equal(run.stage.spawns[run.spawnIndex][1],0x1dc)
    equal(run.stage.spawns[run.spawnIndex][7],0x1955ea)
    runtime.close(run)
    if afterFrame then afterFrame() end

    local function reachStage2Ship(kind, major, state)
        run = fixture(2,state or {gunRank=0x34,groundRank=0x1a,tankRank=6},withArt)
        local pilot = runtime.addPlayer(run,1,1,{h=0xc00,l=0xe00,keys={},life=2,protect=0xff})
        for _ = 1,9000 do
            if run.major == major then break end
            pilot.protect = 0xff
            step()
        end
        equal(run.major,major)
        for _, actor in pairs(run.enemies) do
            if actor.kind == kind then return actor, pilot end
        end
        error(('第二面缺少敌机 0x%x'):format(kind))
    end
    local function checkShot(kind, h, l, angle, speed, callback)
        for _, shot in pairs(run.bullets) do
            if shot.kind == kind and shot.h == h and shot.l == l and shot.angle == angle and shot.speed == speed then
                equal(shot.callback,callback)
                return shot
            end
        end
        error(('缺少敌弹 0x%x，坐标 0x%x、0x%x，角度 0x%x，速度 0x%x'):format(kind,h,l,angle,speed))
    end

    local ship, pilot = reachStage2Ship(0x84,0x54)
    equal(ship.h,0x516c)
    equal(ship.l,0x680)
    equal(ship.back,-0x1000)
    equal(ship.flags,0x8000)
    for _ = 1,166 do pilot.protect=0xff; step() end
    equal(ship.phase,2)
    equal(ship.flags,0xa000)
    -- 原程序运行到首发前，其他敌机已推进共用的随机字节到 0x95。
    run.randomByte = 0x95
    step()
    for _, angle in ipairs({0x82,0x92}) do
        checkShot(0x13,0x63e0,0xa80,angle,0x17,0x18130c)
    end
    ship.damage(ship,ship.hp + 1,pilot.hitFlags)
    step()
    equal(run.enemies[ship.slot],nil)
    local stars = 0
    for _, item in pairs(run.items) do if item.kind == 8 then stars = stars + 1 end end
    equal(stars,7)
    runtime.close(run)
    if afterFrame then afterFrame() end

    local supply
    supply,pilot = reachStage2Ship(0x90,0x85)
    equal(supply.h,0x7bc0)
    equal(supply.l,0x3500)
    equal(supply.hp,0x7fff)
    supply.damage(supply,0x8000,pilot.hitFlags)
    step()
    equal(supply.hp,0x7fff)
    equal(supply.dropCount,2)
    for _ = 1,550 do
        if not supply.highGate then break end
        pilot.protect=0xff
        step()
    end
    equal(supply.highGate,false)
    equal(supply.hp,0x400)
    assert(run.enemies[supply.slot] == supply)
    -- 原版在屏幕右侧极限之外拒绝部分掉落，向同一机体路径补入横移后再验证。
    supply.l = 0x2600
    supply.damage(supply,0x101,pilot.hitFlags)
    step()
    equal(supply.dropThreshold,0x200)
    local chips = 0
    for _, item in pairs(run.items) do if item.kind == 0x10 then chips = chips + 1 end end
    equal(chips,3)
    supply.damage(supply,supply.hp + 1,pilot.hitFlags)
    step()
    equal(supply.flags,0x8080)
    for _ = 1,5 do step() end
    equal(run.enemies[supply.slot],nil)
    runtime.close(run)
    if afterFrame then afterFrame() end

    local battle
    battle,pilot = reachStage2Ship(0x96,0xb8)
    equal(battle.h,program.s16(0x89c0))
    equal(battle.l,0x1c00)
    equal(battle.right,0x600)
    for _ = 1,280 do pilot.protect=0xff; step() end
    equal(battle.phase,2)
    equal(battle.right,0x9c0)
    for _, row in ipairs({{0x6dce,0x1eeb,0x59},{0x6c68,0x1e0b,0x69},{0x6bac,0x1ca3,0x79},
                         {0x6bac,0x1b5b,0x89},{0x6c68,0x19f3,0x99},{0x6dce,0x1913,0xa9},
                         {0x6fba,0x1887,0xb9}}) do
        checkShot(11,row[1],row[2],row[3],0x14,0x181092)
    end
    for _ = 1,0x213 do
        if battle.protectionClock < 0 then break end
        pilot.protect=0xff
        step()
    end
    assert(battle.protectionClock < 0)
    assert(run.enemies[battle.slot] == battle)
    equal(battle.hp,0x600)
    battle.damage(battle,0x601,pilot.hitFlags)
    step()
    equal(battle.flags,0x8080)
    equal(battle.clearClock,100)
    for _ = 1,24 do step() end
    equal(battle.sinking,25)
    equal(battle.clearClock,76)
    runtime.close(run)
    if afterFrame then afterFrame() end

    local mid
    mid,pilot = reachStage2Ship(0x8c,0x118,{largeRank=0x20,tankRank=7})
    equal(mid.h,program.s16(0xe08f))
    equal(mid.l,0x1c80)
    local midPart = mid.extraParts[1]
    equal(midPart.right,0x900)
    for _ = 1,197 do pilot.protect=0xff; step() end
    run.randomByte = 0x1d
    step()
    equal(mid.mainPhase,2)
    equal(midPart.right,0xd80)
    for _, row in ipairs({{0x5317,0x1624,0xbb},{0x4f17,0x23a4,0xbb},{0x4fa3,0x16cc,0x8b},
                         {0x5415,0x247a,0x83},{0x4c10,0x21e0,0x53},{0x5091,0x202e,0xb3},
                         {0x50e3,0x134c,0x8b},{0x4bd4,0x17c6,0x5b},{0x5191,0x23c0,0xab},
                         {0x543e,0x1400,0x6b},{0x4dff,0x1320,0x93},{0x5291,0x2040,0xab}}) do
        checkShot(0x13,row[1],row[2],row[3],0x12,0x18130c)
    end
    for _ = 199,452 do pilot.protect=0xff; step() end
    equal(mid.wingPhase,1)
    equal(midPart.right,0x900)
    for _, row in ipairs({{0x6436,0x2527,0x90},{0x6456,0x2607,0x66},
                         {0x63f6,0x16e7,0x86},{0x6496,0x1647,0xb0}}) do
        checkShot(7,row[1],row[2],row[3],0x2c,0x180ee0)
    end
    for _ = 453,535 do pilot.protect=0xff; step() end
    run.randomByte = 0x95
    step()
    equal(mid.wingPhase,2)
    checkShot(3,0x553d,0x2bc2,0xd2,0x16,0x180bc8)
    checkShot(4,0x553d,0x2bc2,0xd2,0x10,0x180c84)
    -- 两块盒按 0x1775a0 以损伤较大的一块扣共同耐久。
    mid.damage(mid,6,pilot.hitFlags)
    midPart.damage(midPart,10,pilot.hitFlags)
    step()
    equal(mid.health,0xb000 - 10)
    equal(midPart.hp,0x7fff)
    midPart.damage(midPart,mid.health + 1,pilot.hitFlags)
    step()
    equal(mid.flags,0x8080)
    equal(midPart.flags,0x8080)
    equal(mid.deathClock,0x6f)
    for _ = 1,0x6f do pilot.protect=0xff; step() end
    equal(run.mid2,nil)
    equal(run.enemies[mid.slot],nil)
    runtime.close(run)
    if afterFrame then afterFrame() end

    local cruiser
    cruiser,pilot = reachStage2Ship(0x97,0x162,{gunRank=0x3c,tankRank=7})
    equal(cruiser.h,0x6d80)
    equal(cruiser.l,0x485b)
    equal(cruiser.palette,10)
    for _ = 1,68 do pilot.protect=0xff; step() end
    checkShot(12,0x6600,0x3e86,0x9c,0x16,0x1810ec)
    runtime.close(run)
    if afterFrame then afterFrame() end

    local turret
    turret,pilot = reachStage2Ship(0x94,0x16b,{rapidRank=0x2d,tankRank=7})
    equal(turret.h,0x77c0)
    equal(turret.left,0x600)
    for _ = 1,97 do pilot.protect=0xff; step() end
    equal(turret.phase,2)
    equal(turret.left,0x9c0)
    checkShot(12,0x6dc0,0x1f,0x77,0x15,0x1810ec)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 四门炮台分别使用部件槽。机身变形后由 0x19655a 结算共同耐久。
    local boss
    boss,pilot = reachStage2Ship(0x30,0x1dc,{})
    equal(boss.callback,0x1955ea)
    equal(boss.h,program.s16(0x9bc0))
    equal(boss.l,0x1c00)
    equal(boss.health,0x2bdc0)
    equal(boss.timeout,0x2a2f)
    equal(boss.boxes[3].h,program.s16(0x8a00))
    equal(boss.boxes[3].l,0x22c0)
    equal(boss.boxes[3].hp,0x5000)
    equal(boss.protected,true)
    run.randomByte = 0xec
    local function bossStep()
        pilot.protect = 0xff
        step()
    end
    for _ = 1,640 do bossStep() end
    equal(boss.phase,2)
    equal(boss.attacks[1].index,6)
    equal(boss.boxes[5].flags,0x8000)
    equal(boss.boxes[9].flags,0xa000)
    for _, row in ipairs({{0x5635,0x3391,0x50,0x10},{0x55f5,0x3371,0x58,0x11},{0x55d5,0x3351,0x60,0x12},
                         {0x54f5,0x1931,0x58,0x10},{0x54d5,0x1911,0x60,0x11},{0x54b5,0x1911,0x68,0x12}}) do
        checkShot(7,row[1],row[2],row[3],row[4],0x180ee0)
    end
    for _, index in ipairs({3,5,4,6}) do
        local part = boss.boxes[index]
        part.damage(part,part.hp + 1,pilot.hitFlags)
        bossStep()
        equal(part.flags,0x8000)
        equal(part.broken,true)
        equal(boss.health,0x2bdc0)
    end
    assert(boss.assembled)
    equal(boss.phase,3)
    equal(boss.boxes[9].flags,0x8000)
    for _ = 1,400 do
        if not boss.protected then break end
        bossStep()
    end
    equal(boss.protected,false)
    local shared = boss.boxes[2]
    boss.damage(boss,0x100,pilot.hitFlags)
    shared.damage(shared,0x200,pilot.hitFlags)
    bossStep()
    -- 0x196644 也读取两块外侧盒。首次结算时原模板留下了 0x5000。
    equal(boss.health,0x2bdc0 - 0x2fff)
    boss.damage(boss,0x100,pilot.hitFlags)
    shared.damage(shared,0x200,pilot.hitFlags)
    bossStep()
    equal(boss.health,0x2bdc0 - 0x2fff - 0x200)
    equal(shared.hp,0x7fff)
    boss.health = 0x7701
    local shot = {h=boss.h,l=boss.l,front=0,back=0x40,right=0x40,left=0x40,damage=4}
    runtime.collision.shots(run,{shot},pilot.hitFlags)
    equal(shot.pendingHit,true)
    bossStep()
    equal(boss.final,true)
    equal(boss.attacks[1].index,15)
    bossStep()
    local shell
    for _, shot in pairs(run.bullets) do if shot.kind == 0x16 then shell = shot; break end end
    equal(assert(shell).callback,0x18151e)
    equal(shell.dh,0)
    bossStep()
    local dh,dl = program.vector(shell.speed,shell.angle)
    equal(shell.dh,dh)
    equal(shell.dl,dl)
    boss.health = 1
    boss.damage(boss,2,pilot.hitFlags)
    bossStep()
    equal(boss.phase,1)
    equal(boss.dying,true)
    assert(not run.stageCleared)
    local departure = 0
    while not run.stageCleared and departure < 500 do
        bossStep()
        departure = departure + 1
    end
    equal(departure,437)
    equal(run.stageCleared,true)
    equal(run.boss2,nil)
    runtime.close(run)
    if afterFrame then afterFrame() end

    run = fixture(3,{salvoRank=0x1d,tankRank=9,groundRank=10},withArt)
    pilot = runtime.addPlayer(run,1,1,{h=0xc00,l=0xe00,keys={},life=2,protect=0xff})
    for _ = 1,96 do bossStep() end
    local scout
    for _, o in pairs(run.enemies) do if o.kind == 0x3e then scout=o; break end end
    equal(assert(scout).h,0x798d)
    equal(scout.l,0x1480)
    equal(scout.extraParts[1].h,scout.h)
    for _ = 1,12 do bossStep() end
    equal(scout.face,0x21)
    checkShot(12,0x6c17,0x13af,0x84,0x16,0x1810ec)
    checkShot(12,0x6c17,0x136f,0x8c,0x16,0x1810ec)
    checkShot(12,0x6c17,0x13cf,0x7c,0x16,0x1810ec)
    scout.damage(scout,0x60,pilot.hitFlags)
    scout.extraParts[1].damage(scout.extraParts[1],0x80,pilot.hitFlags)
    bossStep()
    equal(scout.health,0x80)
    pilot.comboClock = 0x34
    scout.damage(scout,0x81,pilot.hitFlags)
    bossStep()
    equal(run.enemies[scout.slot],nil)
    equal(pilot.comboClock,0x37)
    equal(pilot.hyperGauge,6)
    for _ = run.frame + 1,160 do bossStep() end
    local fleet
    for _, o in pairs(run.enemies) do if o.kind == 0x36 then fleet=o; break end end
    equal(assert(fleet).h,program.s16(0x96ff))
    equal(fleet.l,0x2f38)
    equal(fleet.extraParts[2].h,program.s16(0xa0ff))
    equal(fleet.extraParts[2].l,0x2938)
    for _ = 1,39 do bossStep() end
    checkShot(5,0x7898,0x2dc0,0x90,0x15,0x180d40)
    checkShot(5,0x7998,0x2b80,0x90,0x15,0x180d40)
    fleet.damage(fleet,0x100,pilot.hitFlags)
    local fleetRear = fleet.extraParts[1]
    fleetRear.damage(fleetRear,0x200,pilot.hitFlags)
    bossStep()
    equal(fleet.health,0x2d00)
    fleet.damage(fleet,0x400,pilot.hitFlags)
    bossStep()
    equal(fleet.extraParts[5].broken,true)
    assert(not fleet.extraParts[4].broken)
    fleet.damage(fleet,0x900,pilot.hitFlags)
    bossStep()
    equal(fleet.extraParts[4].broken,true)
    fleet.damage(fleet,0x1000,pilot.hitFlags)
    bossStep()
    equal(fleet.extraParts[2].broken,true)
    equal(fleet.extraParts[3].broken,true)
    fleet.damage(fleet,0x1001,pilot.hitFlags)
    bossStep()
    equal(fleet.deathClock,0x10)
    for _ = 1,16 do bossStep() end
    equal(run.enemies[fleet.slot],nil)

    local function reachThird(kind, limit)
        for _ = run.frame + 1,limit do
            bossStep()
            for _, o in pairs(run.enemies) do
                if o.kind == kind then return o end
            end
        end
        error(('第三面未生成敌机 0x%x'):format(kind))
    end

    local bunker = reachThird(0x37,1000)
    equal(run.major,0x3b)
    equal(bunker.h,0x7bc0)
    local hatch
    for _, o in pairs(run.enemies) do if o.kind == 0x3c then hatch=o; break end end
    equal(assert(hatch).h,0x7ffa)
    hatch.damage(hatch,0xc01,pilot.hitFlags)
    bossStep()
    equal(hatch.hp,0xc00)
    for _ = 2,79 do bossStep() end
    equal(hatch.phase,2)
    equal(hatch.right,0xb80)
    for _, row in ipairs({
        {0x6383,0x255f,0xa8},{0x6384,0x2f9f,0x58},{0x6003,0x261f,0xa4},
        {0x5fe4,0x2ebf,0x5c},{0x5c63,0x27bf,0xa0},{0x5c64,0x2d3f,0x60},
    }) do checkShot(0xb,row[1],row[2],row[3],0x1a,0x181092) end
    hatch.damage(hatch,0xc01,pilot.hitFlags)
    bossStep()
    equal(run.enemies[hatch.slot],nil)
    for _ = 81,100 do bossStep() end
    local bunkerShell = checkShot(0x16,0x6140,0x10c0,0x80,0x1e,0x18151e)
    checkShot(0x16,0x6140,0x10c0,0x82,0x1e,0x18151e)
    checkShot(0x16,0x6140,0x10c0,0x7e,0x1e,0x18151e)
    equal(bunkerShell.dh,0)
    bunker.damage(bunker,bunker.hp + 1,pilot.hitFlags)
    bossStep()
    equal(bunker.flags,0x8000)
    equal(run.enemies[bunker.slot],bunker)
    local expectedH,expectedL = program.vector(0x1e,0x80)
    equal(bunkerShell.h,0x6140)
    equal(bunkerShell.dh,expectedH)
    equal(bunkerShell.dl,expectedL)
    bossStep()
    equal(bunkerShell.h,0x6140 + expectedH)

    -- 0x142e60 在第一座旋转炮初始化时消费随机索引 0x9f。
    while run.frame < 0x47f do bossStep() end
    run.randomByte = 0x9e
    local spinner = reachThird(0x3b,0x480)
    equal(spinner.h,program.s16(0xa240))
    equal(spinner.rotation,-2)
    for _ = 1,140 do bossStep() end
    for _, row in ipairs({{0x78b0,0x1b70,0xe6},{0x86b0,0x16c0,0xa6},
                          {0x8dd0,0x2010,0x66},{0x7fd0,0x24c0,0x26}}) do
        local h = program.s16(row[1])
        checkShot(4,h,row[2],row[3],0x16,0x180c84)
        checkShot(4,h,row[2],(row[3] - 0x40) % 0x100,0x14,0x180c84)
    end
    spinner.damage(spinner,0x7fff,pilot.hitFlags)
    bossStep()
    equal(spinner.hp,0x7fff)
    for _ = 142,192 do bossStep() end
    equal(spinner.hp,0x1c00)
    spinner.damage(spinner,spinner.hp + 1,pilot.hitFlags)
    bossStep()
    equal(run.spinnerGate[0x48],nil)

    local mid = reachThird(0x12,4200)
    equal(run.major,0xe0)
    equal(mid.health,0x7800)
    equal(mid.timeout,0x707)
    for _ = 1,117 do bossStep() end
    run.randomByte = 0x54
    bossStep()
    local child = reachThird(0x13,run.frame + 1)
    equal(child.h,0x592a)
    equal(child.l,0x2061)
    equal(child.speed,1)
    equal(child.angle,0x8e)
    for _ = 1,13 do bossStep() end
    checkShot(0x16,0x57cf,0x200f,0x8e,0x14,0x18151e)
    for _ = 133,243 do bossStep() end
    equal(run.major,0xe4)
    equal(mid.h,0x63e2)
    equal(mid.l,0x1bdc)
    equal(mid.hatchFrame,7)
    for _, row in ipairs({
        {0x49ed,0x11be,0x54},{0x4915,0x114a,0x64},{0x4891,0x10a6,0x74},
        {0x4876,0x0ff2,0x84},{0x48ca,0x0f3e,0x94},{0x4976,0x0eb2,0xa4},
        {0x4a6e,0x0e5a,0xb4},{0x48c8,0x2cfe,0x6c},{0x4874,0x2c4a,0x7c},
        {0x4891,0x2b96,0x8c},{0x4915,0x2af2,0x9c},{0x49ed,0x2a7e,0xac},
        {0x4af9,0x2a46,0xbc},{0x4c05,0x2a5a,0xcc},
    }) do checkShot(4,row[1],row[2],row[3],0x10,0x180c84) end
    local left,right = unpack(mid.wings)
    left.damage(left,left.hp + 1,pilot.hitFlags)
    bossStep()
    equal(left.flags,0x8000)
    equal(right.flags,0xa001)
    equal(mid.health,0x7800)
    mid.health = 0x2801
    mid.damage(mid,2,pilot.hitFlags)
    bossStep()
    equal(right.flags,0x8000)
    bossStep()
    equal(mid.phase,5)
    mid.damage(mid,mid.health + 1,pilot.hitFlags)
    bossStep()
    equal(mid.dying,true)
    equal(run.mid3Children,false)
    for _ = 1,150 do
        if not run.mid3 then break end
        bossStep()
    end
    equal(run.mid3,nil)
    equal(run.holdMajor,false)
    bossStep()

    run.groundRank,run.tankRank = 11,11
    local flypast = reachThird(0x15,7200)
    equal(run.major,0x10d)
    equal(flypast.h,program.s16(0xbf1b))
    equal(flypast.l,program.s16(0xed10))
    local gate
    for _, o in pairs(run.enemies) do if o.kind == 0x17 then gate=o; break end end
    equal(assert(gate).callback,0x164710)
    equal(gate.h,program.s16(0xcf1b))
    equal(gate.l,program.s16(0xf110))
    gate.damage(gate,0x2401,pilot.hitFlags)
    bossStep()
    equal(gate.hp,0x2400)
    local airship = reachThird(0x83,7400)
    equal(run.major,0x11d)
    equal(airship.h,program.s16(0x8751))
    equal(airship.l,0x2dc0)
    for _ = 1,65 do bossStep() end
    for _, row in ipairs({{0x67a8,0x2dbf,0x7f},{0x67bc,0x2d47,0x89},{0x6804,0x2c7f,0x93},
                          {0x6890,0x2c13,0x9d},{0x6948,0x2b97,0xa7}}) do
        checkShot(0xb,row[1],row[2],row[3],0x11,0x181092)
    end
    local turret
    for _, o in pairs(run.enemies) do if o.kind == 0x16 then turret=o; break end end
    equal(assert(turret).h,0x6d91)
    equal(turret.l,program.s16(0xf33a))
    local flank = airship.extraParts[1]
    local hullShot = {h=flank.h - 0x600,l=flank.l + 0xa00,front=0,back=0x40,right=0x40,left=0x40,damage=0x80}
    runtime.collision.shots(run,{hullShot},pilot.hitFlags)
    equal(hullShot.pendingHit,true)
    equal(flank.hp,0x1700 - 0x80)
    equal(airship.hp,0x1700)
    for _ = 1,9 do bossStep() end
    equal(airship.hp,0x1700 - 0x80)
    checkShot(0xc,0x6804,program.s16(0xf723),0x70,0x18,0x1810ec)
    checkShot(0xd,0x6804,program.s16(0xf723),0x70,0x12,0x181146)
    local wideGate = reachThird(0x18,10500)
    equal(wideGate.callback,0x164c6c)
    equal(run.major,0x168)
    for _ = 1,625 do bossStep() end
    equal(wideGate.phase,2)
    equal(wideGate.h,0x5e68)
    checkShot(5,0x48e8,0x21c0,0x80,0x14,0x180d40)
    for _ = 1,16 do bossStep() end
    for _, row in ipairs({{0x6de7,0x18df},{0x6de8,0x1edf},{0x6de8,0x221f},{0x6de7,0x159f}}) do
        checkShot(7,row[1],row[2],0x8a,0x18,0x180ee0)
    end
    for _ = run.frame + 1,11000 do
        if run.major == 0x1a6 then break end
        bossStep()
    end
    equal(run.major,0x1a6)
    local entry = run.stage.spawns[run.spawnIndex]
    equal(entry[1],0x1a7)
    equal(entry[7],0x19a11e)

    -- 0x19a69a 首次选航向前，V101 的随机游标为 0x53。
    while run.major == 0x1a6 do run.randomByte = 0x53; bossStep() end
    local thirdBoss = assert(run.boss3)
    local entryFrame = run.frame
    equal(thirdBoss.phase,0)
    equal(thirdBoss.h,0x4418)
    equal(thirdBoss.l,program.s16(0xec57))
    equal(thirdBoss.timeout,0x383f)
    equal(thirdBoss.health,0x40c00)
    equal(thirdBoss.flags,0x8000)
    equal(#thirdBoss.boxes,10)
    for _ = 1,250 do bossStep() end
    equal(thirdBoss.phase,1)
    equal(thirdBoss.h,0x52c8)
    equal(thirdBoss.l,0x214a)
    equal(thirdBoss.wings[1].flags,0xa001)
    equal(thirdBoss.attacks[1].index,6)
    equal(thirdBoss.attacks[2].index,7)
    for _ = 251,298 do bossStep() end
    for i, row in ipairs({{0x3b47,0x222f},{0x3c1d,0x2249},{0x3cee,0x2271},{0x3dca,0x2271}}) do
        if i > 1 then for _ = 1,5 do bossStep() end end
        checkShot(11,row[1],row[2],0x97,0x11 + (i - 1) * 2,0x181092)
    end
    for _ = 314,346 do bossStep() end
    for i = 0,10 do
        local a = 0x74 + i * 4
        if i % 2 == 0 then
            checkShot(4,0x6857,0x16f2,a,0x17,0x180c84)
            local fast
            for _, shot in pairs(run.bullets) do
                if shot.kind == 4 and shot.h == 0x6857 and shot.l == 0x16f2 and shot.angle == a and shot.speed == 0x1a then
                    fast = shot
                    break
                end
            end
            equal(assert(fast).callback,0x180c84)
        else checkShot(5,0x6857,0x16f2,a,0x14,0x180d40) end
    end
    for _ = 347,549 do bossStep() end
    equal(thirdBoss.phase,2)
    equal(thirdBoss.h,0x6570)
    equal(thirdBoss.l,0x1c1f)
    for _ = 550,1100 do bossStep() end
    equal(thirdBoss.phase,3)
    thirdBoss.health = 0x11801
    thirdBoss.damage(thirdBoss,4,pilot.hitFlags)
    thirdBoss.damage(thirdBoss.wings[1],8,pilot.hitFlags)
    bossStep()
    equal(thirdBoss.health,0x117f9)
    equal(thirdBoss.final,true)
    equal(thirdBoss.protected,true)
    thirdBoss.damage(thirdBoss,0x100,pilot.hitFlags)
    bossStep()
    equal(thirdBoss.health,0x117f9)
    local pod = reachThird(0x99,entryFrame + 1650)
    equal(pod.callback,0x19c9c8)
    equal(thirdBoss.phase,1)
    equal(thirdBoss.protected,false)
    local podBox = pod.extraParts[1]
    podBox.damage(podBox,0x100,pilot.hitFlags)
    bossStep()
    equal(pod.hp,0x580)
    podBox.damage(podBox,podBox.hp + 1,pilot.hitFlags)
    bossStep()
    equal(run.enemies[pod.slot],nil)
    for _ = run.frame + 1,entryFrame + 2200 do bossStep() end
    thirdBoss.health = 1
    thirdBoss.damage(thirdBoss,16,pilot.hitFlags)
    bossStep()
    equal(thirdBoss.dying,true)
    equal(thirdBoss.flags,0x8000)
    local deathFrame = run.frame
    for _ = 1,470 do
        if run.stageCleared then break end
        bossStep()
    end
    equal(run.stageCleared,true)
    equal(run.boss3,nil)
    equal(run.frame - deathFrame,436)
    runtime.close(run)
    if afterFrame then afterFrame() end

    run = fixture(4,{hatchOpenRank=0x2b,salvoRank=0x39},withArt)
    pilot = runtime.addPlayer(run,1,1,{h=0xc00,l=0xe00,keys={},life=2,protect=0xff})
    local function reachKind(kind, limit)
        for _ = run.frame + 1,limit do
            bossStep()
            for _, o in pairs(run.enemies) do
                if o.kind == kind then return o end
            end
        end
        error(('第 %d 面未生成敌机 0x%x'):format(run.stageNumber,kind))
    end

    local pulse = reachKind(0xa6,20)
    equal(pulse.clock,6)
    for _ = 1,7 do bossStep() end
    equal(run.stage4Pulse,1)
    local openingTurret = reachKind(0xa5,200)
    equal(openingTurret.callback,0x176d7a)
    local bridge = reachKind(0x9b,450)
    equal(run.major,0x19)
    equal(bridge.h,program.s16(0x8fc0))
    equal(bridge.l,0x3200)
    equal(bridge.hp,0x7fff)
    equal(bridge.extraParts[1].hp,0x7fff)
    local openingHatch = reachKind(0xa2,900)
    equal(run.major,0x36)
    equal(openingHatch.h,program.s16(0x8bc0))
    equal(openingHatch.l,0x3700)
    equal(openingHatch.mirrored,true)
    for _ = 1,209 do bossStep() end
    local firstShots = {
        {0x62c0,0x3240,0xc0},{0x6480,0x3400,0xc0},{0x6240,0x3240,0xc0},
        {0x6400,0x3400,0xc0},{0x61c0,0x3240,0xc0},{0x6380,0x3400,0xc0},
        {0x60c0,0x3240,0xc8},{0x6280,0x3400,0xb8},
    }
    for i, row in ipairs(firstShots) do
        if i > 1 then for _ = 1,(i == 7 and 5 or 2) do bossStep() end end
        checkShot(5,row[1],row[2],row[3],0x18,0x180d40)
    end
    openingHatch.damage(openingHatch,0x1601,pilot.hitFlags)
    bossStep()
    equal(openingHatch.flags,0x8080)
    for _ = 1,17 do bossStep() end
    equal(run.enemies[openingHatch.slot],nil)
    for _ = run.frame + 1,4000 do
        if run.major == 0xe4 then break end
        bossStep()
    end
    equal(run.major,0xe4)
    local nextEntry = run.stage.spawns[run.spawnIndex]
    equal(nextEntry[1],0xe5)
    equal(nextEntry[7],0x179792)
    local fleet = reachKind(0x9c,3800)
    equal(fleet.h,0x55a4)
    equal(fleet.l,program.s16(0xe2f4))
    equal(fleet.flags,0x8000)
    equal(#fleet.crafts,5)
    for _ = 1,36 do bossStep() end
    for i, row in ipairs({{0x5944,0xf610,0x7f},{0x595d,0xf6b4,0x82},{0x596d,0xf784,0x85}}) do
        if i > 1 then for _ = 1,4 do bossStep() end end
        local shot = checkShot(0x13,row[1],program.s16(row[2]),row[3],0x14,0x18130c)
        equal(shot.dh,0)
    end
    for _, craft in ipairs(fleet.crafts) do craft.damage(craft,craft.hp + 1,pilot.hitFlags) end
    bossStep()
    for _, craft in ipairs(fleet.crafts) do
        equal(craft.burning,true)
        equal(craft.hp,0x70)
        craft.damage(craft,craft.hp + 1,pilot.hitFlags)
    end
    equal(fleet.flags,0x8000)
    bossStep()
    for _, craft in ipairs(fleet.crafts) do
        equal(craft.wreck,true)
        equal(craft.flags,0x8080)
    end
    equal(fleet.flags,0xa000)
    fleet.damage(fleet,fleet.hp + 1,pilot.hitFlags)
    bossStep()
    equal(fleet.flags,0x8080)
    for _ = 1,25 do bossStep() end
    equal(run.enemies[fleet.slot],nil)
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 中 Boss 的 V101 对照使用完成道中时的原始 Rank 和未击破的队列状态。
    run = fixture(4,{hatchOpenRank=0x5a,salvoRank=0x39},withArt)
    pilot = runtime.addPlayer(run,1,1,{h=0xc00,l=0xe00,keys={},life=2,protect=0xff})
    for _ = run.frame + 1,7800 do
        if run.major == 0x1d7 then break end
        bossStep()
    end
    equal(run.major,0x1d7)
    nextEntry = run.stage.spawns[run.spawnIndex]
    equal(nextEntry[1],0x1d8)
    equal(nextEntry[7],0x17a030)
    local fourthMid = reachKind(0x9d,7800)
    local fourthFrame = run.frame
    equal(fourthMid.h,program.s16(0xa9c0))
    equal(fourthMid.l,0x1c00)
    equal(fourthMid.wings[1].l,0x800)
    equal(fourthMid.wings[2].l,0x3000)
    equal(fourthMid.protection,0x77)
    for _ = 1,32 do bossStep() end
    checkShot(11,program.s16(0x87c0),0x480,0,0x1a,0x181092)
    for _ = 33,144 do bossStep() end
    equal(fourthMid.phase,1)
    for _ = 145,161 do bossStep() end
    equal(fourthMid.phase,2)
    equal(fourthMid.hatch,9)
    for i, row in ipairs({{0x679a,0x1c42},{0x678e,0x1c00},{0x679a,0x1bbe},{0x67ac,0x1b7c},
                         {0x67c4,0x1b34},{0x67e2,0x1af8},{0x6818,0x1ab0}}) do
        local angle = 0x7d + (i - 1) * 4
        checkShot(4,row[1],row[2],angle,0x0a,0x180c84)
        checkShot(4,row[1],row[2],angle,0x12,0x180c84)
        if i < 7 then
            checkShot(4,row[1],row[2],angle + 2,0x0e,0x180c84)
            checkShot(4,row[1],row[2],angle + 2,0x16,0x180c84)
        end
    end
    for _ = 162,163 do bossStep() end
    run.randomByte = 0xc8
    local daughter = reachKind(0x9e,fourthFrame + 164)
    equal(daughter.callback,0x17aba2)
    equal(daughter.h,program.s16(0xb380))
    equal(daughter.dl,-0x18)
    for _ = 165,168 do bossStep() end
    equal(daughter.h,program.s16(0xcb80))
    equal(daughter.pose,32)
    for _ = 169,184 do bossStep() end
    equal(fourthMid.phase,2)
    for _, row in ipairs({{0x67fa,0x1eb8,0x48,0x10},{0x678e,0x1ea6,0x4c,0x12},
                         {0x648e,0x1c00,0x80,0x10}}) do
        checkShot(3,row[1],row[2],row[3],row[4],0x180bc8)
    end
    local leftWing,rightWing = unpack(fourthMid.wings)
    local wingDeathFrame = run.frame
    leftWing.damage(leftWing,0x2201,pilot.hitFlags)
    bossStep()
    equal(leftWing.flags,0x8080)
    equal(rightWing.hp,0x2200)
    equal(fourthMid.hp,0x7000)
    for _ = 1,42 do bossStep() end
    equal(leftWing.wreckClock,0)
    rightWing.damage(rightWing,0x2201,pilot.hitFlags)
    bossStep()
    equal(rightWing.flags,0x8080)
    fourthMid.damage(fourthMid,0x7001,pilot.hitFlags)
    bossStep()
    equal(fourthMid.flags,0x8080)
    equal(fourthMid.dying,true)
    equal(run.frame,wingDeathFrame + 45)
    for _ = 1,192 do bossStep() end
    equal(fourthMid.deathClock,0)
    equal(fourthMid.rewardClock,0x40)
    for _ = run.frame + 1,9200 do
        if run.major == 0x233 then break end
        bossStep()
    end
    equal(run.major,0x233)
    equal(run.stage.spawns[run.spawnIndex][7],0x17bf2e)
    while run.major == 0x233 do run.randomByte = 0x4b; bossStep() end
    local tower
    for _, o in pairs(run.enemies) do
        if o.kind == 0xa3 then tower = o; break end
    end
    assert(tower)
    equal(tower.h,0x7a91)
    equal(tower.l,0x1c00)
    equal(tower.gun.l,0x1880)
    equal(tower.gun.hp,0x1e00)
    for _ = 1,16 do bossStep() end
    for _, angle in ipairs({0x75,0x77,0x79,0x7b,0x87,0x89,0x8b,0x8d}) do
        checkShot(0x13,0x73b7,0x1f00,angle,0x11,0x18130c)
    end
    for _ = 17,50 do bossStep() end
    equal(tower.gun.l,0x2900)
    equal(tower.pose,7)
    equal(tower.phase,2)
    for _, row in ipairs({{0x71ab,0x2480,0x83},{0x71ab,0x2b80,0x9b},{0x6fab,0x2b80,0xaa},{0x6fab,0x2480,0x74}}) do
        checkShot(0x16,row[1],row[2],row[3],0x1c,0x18151e)
    end
    tower.gun.damage(tower.gun,tower.gun.hp + 1,pilot.hitFlags)
    bossStep()
    equal(tower.flags,0x8080)
    equal(tower.gun.flags,0x8000)

    local facility = reachKind(0x9f,9900)
    equal(facility.h,program.s16(0xb7c0))
    equal(facility.l,0x1c00)
    equal(facility.flags,0x8000)
    for _ = 1,574 do bossStep() end
    equal(facility.h,0x7000)
    equal(facility.phase,1)
    for _ = 575,830 do bossStep() end
    equal(facility.h,0x5000)
    equal(facility.phase,2)
    for _ = 831,895 do bossStep() end
    equal(facility.heightAdjustment,0x1000)
    equal(facility.h,0x5800)
    equal(facility.flags,0xa000)
    for _ = 896,1094 do bossStep() end
    local door,body = unpack(facility.extraParts)
    equal(facility.h,0x3f00)
    equal(facility.phase,5)
    equal(door.flags,0xa001)
    facility.damage(facility,0x100,pilot.hitFlags)
    body.damage(body,0x200,pilot.hitFlags)
    bossStep()
    equal(facility.hp,0x7600)
    equal(body.hp,0x7600)
    body.damage(body,body.hp + 1,pilot.hitFlags)
    bossStep()
    equal(facility.flags,0x8080)
    equal(door.flags,0x8000)
    for _ = run.frame + 1,11900 do
        if run.major == 0x2e7 then break end
        bossStep()
    end
    equal(run.major,0x2e7)
    nextEntry = run.stage.spawns[run.spawnIndex]
    equal(nextEntry[1],0x2e8)
    equal(nextEntry[7],0x19d21c)
    while run.major == 0x2e7 do run.randomByte = 0x73; bossStep() end
    local fourthBoss = assert(run.boss4)
    local bossFrame = run.frame
    equal(#fourthBoss.boxes,13)
    equal(fourthBoss.h,program.s16(0xca80))
    equal(fourthBoss.l,0x1d90)
    equal(fourthBoss.timeout,0x1c1f)
    equal(fourthBoss.health,0x46000)
    equal(fourthBoss.phase,0)
    for _ = 1,142 do bossStep() end
    equal(fourthBoss.h,0x6940)
    equal(fourthBoss.l,0x1c00)
    equal(fourthBoss.boxes[2].flags,0xa001)
    bossStep()
    equal(fourthBoss.phase,1)
    equal(fourthBoss.h,0x6935)
    equal(fourthBoss.l,0x1c00)
    for _ = 144,195 do bossStep() end
    for _, row in ipairs({{0x5935,0x185d,0x30},{0x5175,0x11dd,0x8e},{0x5a75,0xf1d,0xe0}}) do
        for _, shift in ipairs({0,3,6,-3,-6}) do
            checkShot(4,row[1],row[2],(row[3] + shift) % 0x100,0x14,0x180c84)
            checkShot(4,row[1],row[2],(row[3] + 0x20 + shift) % 0x100,0x13,0x180c84)
        end
    end
    for _ = 196,208 do bossStep() end
    for _, row in ipairs({{0x5d9a,0x2b3e,0x20},{0x53da,0x28fe,0x72},{0x599a,0x227e,0xd0}}) do
        checkShot(4,row[1],row[2],row[3],0x14,0x180c84)
        checkShot(4,row[1],row[2],row[3] + 0x20,0x13,0x180c84)
    end
    for _ = 209,690 do bossStep() end
    equal(fourthBoss.h,0x738b)
    equal(fourthBoss.l,0x1c71)
    local hull,armor,cover,left,right = unpack(fourthBoss.boxes,2,6)
    fourthBoss.health = 0x23001
    hull.damage(hull,4,pilot.hitFlags)
    armor.damage(armor,8,pilot.hitFlags)
    bossStep()
    equal(fourthBoss.health,0x22ff9)
    equal(fourthBoss.transformed,true)
    bossStep()
    equal(fourthBoss.protected,true)
    equal(fourthBoss.phase,2)
    equal(cover.flags,0x8000)
    equal(armor.flags,0x8000)
    hull.damage(hull,0x200,pilot.hitFlags)
    bossStep()
    equal(fourthBoss.health,0x22ff9)
    for _ = 694,865 do bossStep() end
    equal(fourthBoss.h,0x5d91)
    equal(fourthBoss.l,0x1c19)
    equal(fourthBoss.phase,4)
    equal(left.flags,0xa001)
    equal(right.flags,0xa001)
    equal(fourthBoss.protected,false)
    left.damage(left,12,pilot.hitFlags)
    right.damage(right,16,pilot.hitFlags)
    bossStep()
    equal(fourthBoss.health,0x22ff9)
    bossStep()
    equal(fourthBoss.health,0x22ff1)
    for _ = 868,1100 do bossStep() end
    fourthBoss.health = 0xc401
    hull.damage(hull,4,pilot.hitFlags)
    bossStep()
    equal(fourthBoss.health,0xc3fd)
    equal(fourthBoss.final,true)
    equal(left.hp,-1)
    equal(right.hp,-1)
    equal(left.flags,0x8000)
    equal(right.flags,0x8000)
    bossStep()
    equal(fourthBoss.phase,8)
    for _ = 1103,1550 do bossStep() end
    fourthBoss.health = 1
    hull.damage(hull,16,pilot.hitFlags)
    bossStep()
    equal(fourthBoss.dying,true)
    equal(fourthBoss.health,-1)
    equal(hull.flags,0x8000)
    equal(run.frame,bossFrame + 1551)
    for _ = 1,480 do
        if run.stageCleared then break end
        bossStep()
    end
    equal(run.stageCleared,true)
    equal(run.boss4,nil)
    equal(run.frame - bossFrame - 1551,439)
    runtime.close(run)

    run = fixture(5,{tankRank=0x69,hatchOpenRank=0x5a,largeRank=0x3c},withArt)
    pilot = runtime.addPlayer(run,1,1,{h=0xc00,l=0xe00,keys={},life=2,protect=0xff})
    local fifthShip = reachKind(0x81,1300)
    equal(fifthShip.h,program.s16(0x8c7d))
    equal(fifthShip.l,0xc00)
    equal(fifthShip.clock,0x17)
    for _ = 1,96 do bossStep() end
    for _, row in ipairs({
        {0x7337,0x17a3,0x57},{0x7295,0x1743,0x66},{0x7249,0x16a3,0x75},{0x723c,0x1609,0x84},
        {0x7266,0x156f,0x93},{0x72fc,0x1509,0xa2},{0x73b8,0x14a3,0xb1},
        {0x7437,0x461,0x4b},{0x735b,0x415,0x5a},{0x72d5,0x3c3,0x69},{0x7281,0x30b,0x78},
        {0x7282,0x273,0x87},{0x72d6,0x1bb,0x96},{0x735c,0x169,0xa5},
    }) do
        checkShot(7,row[1],row[2],row[3],0x18,0x180ee0)
    end
    bossStep()
    bossStep()
    equal(fifthShip.h,0x72d7)
    for _, dl in ipairs({0xf80,0x880}) do
        for _, a in ipairs({0x88,0x74}) do checkShot(5,0x6a57,dl,a,0x11,0x180d40) end
    end

    local sweeper = reachKind(0x1b,1700)
    equal(sweeper.h,program.s16(0x8900))
    equal(sweeper.l,0x280)
    equal(sweeper.hp,0xe00)
    local entry = reachKind(0x43,2600)
    equal(entry.h,0x3152)
    equal(entry.l,0x1c00)
    bossStep()
    equal(entry.h,0x32e4)
    equal(entry.speed,0x23)
    for _ = 2,111 do bossStep() end
    equal(entry.h,0x6992)
    equal(entry.pose,16)
    equal(run.spawnQueue[1][3],0x44)
    -- 将随机游标和敌弹槽固定在发射前，分别核对路线选择与完整弹型。
    run.randomByte = 0xf0
    bossStep()
    local fifthMid = assert(run.mid5)
    equal(fifthMid.h,0x6989)
    equal(fifthMid.l,0x1c04)
    equal(fifthMid.health,0x15000)
    equal(fifthMid.extraParts[1].h,0x6089)
    equal(fifthMid.extraParts[1].l,0x1404)
    runtime.bullets.close(run)
    bossStep()
    equal(fifthMid.h,0x6977)
    equal(fifthMid.l,0x1c0c)
    for i, row in ipairs({
        {0x6e8b,0x1cb0},{0x6e1f,0x1dbc},{0x6d6d,0x1e4e},{0x6c69,0x1ef8},{0x6b09,0x1f72},{0x6977,0x1f96},
        {0x6871,0x1f83},{0x66e5,0x1f1b},{0x65c9,0x1e83},{0x64ef,0x1ddb},{0x647b,0x1cf7},{0x6445,0x1c0b},
        {0x647b,0x1b1f},{0x651f,0x19ff},{0x65c9,0x1993},{0x6725,0x18db},{0x6871,0x1893},{0x69d7,0x1888},
        {0x6b09,0x18a6},{0x6c69,0x1920},{0x6d6d,0x19ca},{0x6e55,0x1aa4},{0x6e8b,0x1b68},
    }) do
        checkShot(11,row[1],row[2],0x7 + (i - 1) * 0xb,0x13,0x181092)
    end
    for _, row in ipairs({{0x66bf,0x1bb4,0x89},{0x66e3,0x1b5c,0x8f},{0x6707,0x1b2c,0x95},
                         {0x66b3,0x1be0,0x83},{0x66b3,0x1c38,0x7d}}) do
        checkShot(4,row[1],row[2],row[3],0x17,0x180c84)
    end
    local flame = reachKind(0x53,3050)
    equal(flame.host,fifthMid)
    equal(flame.flags,0x8000)
    for _ = 1,23 do bossStep() end
    equal(flame.flags,0x8001)
    equal(flame.ignite,true)
    local wing = fifthMid.extraParts[1]
    fifthMid.damage(fifthMid,4,pilot.hitFlags)
    wing.damage(wing,8,pilot.hitFlags)
    bossStep()
    equal(fifthMid.health,0x14ff8)
    fifthMid.health = 1
    wing.damage(wing,4,pilot.hitFlags)
    bossStep()
    equal(fifthMid.dying,true)
    equal(wing.flags,0x8000)
    for _ = 1,130 do
        if not run.mid5 then break end
        bossStep()
    end
    equal(run.mid5,nil)
    local groundDoor = reachKind(0x45,3900)
    equal(groundDoor.hp,0x600)
    equal(groundDoor.flags,0xa000)
    local platform = reachKind(0x55,4500)
    equal(platform.flags,0x8000)
    for _ = 1,60 do bossStep() end
    equal(platform.front,0x1200)
    equal(platform.back,0)
    equal(platform.flags,0xa001)
    equal(platform.hp,0x1100)
    platform.damage(platform,0x1101,pilot.hitFlags)
    bossStep()
    equal(run.enemies[platform.slot],nil)
    local trackGun = reachKind(0x8e,6260)
    equal(trackGun.hp,0x500)
    for _ = run.frame,6400 do
        if run.major == 0x15f then break end
        bossStep()
    end
    equal(run.major,0x15f)
    nextEntry = run.stage.spawns[run.spawnIndex]
    equal(nextEntry[1],0x160)
    equal(nextEntry[7],0x16c038)
    local fort = reachKind(0x47,6500)
    equal(fort.h,program.s16(0x9640))
    equal(fort.l,0x1c00)
    equal(fort.health,0x1c000)
    for _ = 1,600 do bossStep() end
    run.randomByte = 0x4c
    bossStep()
    runtime.bullets.close(run)
    bossStep()
    equal(fort.attack,2)
    equal(fort.h,0x5b80)
    for _, a in ipairs({0x73,0xf3,0x7f,0xff,0x8b,0xb,0x97,0x17}) do
        checkShot(3,0x6b80,0x1c00,a,0x19,0x180bc8)
    end
    for _ = 603,900 do bossStep() end
    fort.health = 1
    fort.damage(fort,4,pilot.hitFlags)
    bossStep()
    equal(fort.dying,true)
    equal(fort.flags,0x8000)
    equal(run.fifthFort,nil)
    for _ = 902,996 do bossStep() end
    equal(run.enemies[fort.slot],fort)
    bossStep()
    equal(run.enemies[fort.slot],nil)

    local secondMid = reachKind(0x4c,8600)
    equal(secondMid.h,program.s16(0xf4f6))
    equal(secondMid.l,0x1c00)
    equal(secondMid.health,0x12000)
    for _ = 1,111 do bossStep() end
    equal(secondMid.h,0x404a)
    equal(secondMid.flags,0xa001)
    local firstPod = reachKind(0x4e,run.frame + 2)
    equal(firstPod.h,0x3c47)
    equal(firstPod.l,0x2f82)
    equal(firstPod.clock,0x27)
    -- 两侧炮各次装载之前固定随机游标，核对原版首次后炮位置。
    for _ = 114,136 do bossStep() end
    run.randomByte = 0xa1
    bossStep()
    local rear
    for _, o in pairs(run.enemies) do if o.kind == 0x50 then rear = o; break end end
    assert(rear)
    equal(rear.h,0x3744)
    equal(rear.l,0x19f5)
    local detached = reachKind(0x4f,run.frame + 16)
    equal(detached.h,0x3611)
    equal(detached.l,0x282)
    equal(detached.speed,0xf)
    local largePod = reachKind(0x51,run.frame + 32)
    equal(largePod.h,0x27f9)
    equal(largePod.l,0x19f5)
    equal(largePod.flags,0x8000)
    local mines = reachKind(0x52,run.frame + 340)
    equal(mines.h,0x3952)
    equal(mines.l,0x27d0)
    equal(mines.hp,0x200)
    mines.damage(mines,0x201,pilot.hitFlags)
    bossStep()
    assert(run.enemies[mines.slot] ~= mines)
    secondMid.health = 1
    secondMid.damage(secondMid,4,pilot.hitFlags)
    bossStep()
    equal(secondMid.dying,true)
    equal(secondMid.flags,0x8000)
    equal(run.fifthMid2Projectiles,false)
    for _ = 1,130 do
        if run.enemies[secondMid.slot] ~= secondMid then break end
        bossStep()
    end
    assert(run.enemies[secondMid.slot] ~= secondMid)

    local tower = reachKind(0x49,10800)
    equal(tower.hp,0x2200)
    for _ = run.frame,15500 do
        if run.major == 0x319 then break end
        bossStep()
    end
    equal(run.major,0x319)
    nextEntry = run.stage.spawns[run.spawnIndex]
    equal(nextEntry[1],0x31a)
    equal(nextEntry[7],0x1a2938)
    pilot.h,pilot.l = 0xc00,0xe00
    for _ = 1,40 do
        run.randomByte = 0x32
        bossStep()
        if run.boss5 then break end
    end
    local finalBoss = assert(run.boss5)
    equal(finalBoss.h,program.s16(0xafc0))
    equal(finalBoss.l,0x1c00)
    equal(finalBoss.health,0x3f000)
    equal(finalBoss.timeout,0x626f)
    equal(finalBoss.front,0x1413)
    equal(finalBoss.boxes[2].h,program.s16(0xc480))
    equal(finalBoss.boxes[14].front,-0x21ed)
    equal(finalBoss.flags,0x8000)
    local finalEntry = run.frame
    for _ = 1,350 do bossStep() end
    equal(finalBoss.health,0x3f000)
    bossStep()
    equal(finalBoss.health,0x69000)
    for _ = 352,606 do bossStep() end
    equal(finalBoss.flags,0x8000)
    run.randomByte = 0x9b
    bossStep()
    equal(finalBoss.flags,0xa001)
    equal(finalBoss.attacks[1].index,0)
    equal(run.randomByte,0xa1)
    for _ = 1,32 do bossStep() end
    runtime.bullets.close(run)
    bossStep()
    for _, row in ipairs({
        {0x6740,0x0d9f,0x7a},{0x6740,0x0d1f,0x92},{0x6780,0x0dff,0x62},
        {0x4dc0,0x0b3f,0x7c},{0x3b40,0x0bbf,0x7d},{0x5b21,0x27bf,0x9a},
        {0x5ba1,0x277f,0xb2},{0x5b01,0x283f,0x82},{0x4be1,0x2b7f,0x94},{0x3a81,0x263f,0xa3},
    }) do
        checkShot(7,row[1],row[2],row[3],0xf,0x180ee0)
    end
    for _ = 1,9 do bossStep() end
    runtime.bullets.close(run)
    bossStep()
    local thirdVolley = 0
    for _ in pairs(run.bullets) do thirdVolley = thirdVolley + 1 end
    equal(thirdVolley,52)
    checkShot(5,0x6c20,0xa2c,0x44,0xb,0x180d40)
    checkShot(5,0x6419,0x223c,0x98,9,0x180d40)

    -- 分别从前一个挂载任务自然返回，再取下一轮的第一帧。
    for _ = run.frame + 1,finalEntry + 1309 do bossStep() end
    equal(finalBoss.attacks[1].index,1)
    runtime.bullets.close(run)
    bossStep()
    for _, row in ipairs({
        {4,0x1800,0x80,0x13,0x180c84},{5,0x1800,0xa0,0x12,0x180d40},
        {6,0x1800,0x00,0x0d,0x180dfc},{3,0x1800,0x20,0x1d,0x180bc8},
        {4,0x2000,0x00,0x13,0x180c84},{5,0x2000,0x20,0x12,0x180d40},
        {6,0x2000,0x80,0x0d,0x180dfc},{3,0x2000,0x80,0x1d,0x180bc8},
    }) do
        checkShot(row[1],0x4a80,row[2],row[3],row[4],row[5])
    end
    for _ = 1,43 do bossStep() end
    runtime.bullets.close(run)
    bossStep()
    checkShot(11,0x4780,0x1bdf,0x87,0xe,0x181092)
    checkShot(11,0x4780,0x1b9f,0x90,0x10,0x181092)
    for _ = run.frame + 1,finalEntry + 1994 do bossStep() end
    equal(finalBoss.attacks[1].index,2)
    runtime.bullets.close(run)
    bossStep()
    for _, row in ipairs({
        {0x6040,0x0d80,0x69,0xb9},{0x46c0,0x0b40,0x81,0xbd},{0x3440,0x0bc0,0x94,0xac},
        {0x5401,0x2840,0x8c,0x3c},{0x4581,0x2b40,0x80,0x44},{0x3401,0x2600,0x62,0x4a},
    }) do
        checkShot(0x13,row[1],row[2],row[3],0x17,0x18130c)
        checkShot(0x13,row[1],row[2],row[4],0x24,0x18130c)
    end
    for _ = 1,9 do bossStep() end
    runtime.bullets.close(run)
    bossStep()
    checkShot(5,0x4880,0x1c00,0x8e,0xb,0x180d40)
    for _ = run.frame + 1,finalEntry + 3034 do bossStep() end
    equal(finalBoss.attacks[1].index,3)
    runtime.bullets.close(run)
    bossStep()
    checkShot(11,0x5d80,0x159f,0x71,0x13,0x181092)
    checkShot(11,0x5dc0,0x223f,0xa2,0x13,0x181092)
    bossStep()
    checkShot(11,0x5ec0,0x125f,0x79,0x14,0x181092)
    checkShot(11,0x5ee0,0x253f,0x9a,0x14,0x181092)
    for _ = run.frame + 1,finalEntry + 3391 do bossStep() end
    equal(finalBoss.attacks[1].index,0)
    equal(finalBoss.arrowRank,1)
    runtime.bullets.close(run)
    bossStep()
    checkShot(7,0x5f40,0xd7f,0x7d,0x10,0x180ee0)
    checkShot(7,0x3341,0x257f,0xa0,0x10,0x180ee0)

    equal(finalBoss.h,0x57c0)
    finalBoss.health = 0x2a001
    finalBoss.damage(finalBoss,2,pilot.hitFlags)
    local turret = finalBoss.boxes[2]
    turret.damage(turret,4,pilot.hitFlags)
    bossStep()
    equal(finalBoss.health,0x29ffd)
    equal(finalBoss.protected,true)
    equal(finalBoss.attacks[1],nil)
    turret.damage(turret,16,pilot.hitFlags)
    bossStep()
    equal(finalBoss.health,0x29ffd)
    for _ = 2,62 do bossStep() end
    equal(finalBoss.protected,true)
    bossStep()
    equal(finalBoss.protected,false)
    equal(finalBoss.attacks[1].index,4)
    for _ = 1,32 do bossStep() end
    runtime.bullets.close(run)
    bossStep()
    for _, row in ipairs({
        {0x4880,0x1cee,0x40},{0x47fa,0x1cdc,0x50},{0x471a,0x1c00,0x80},{0x4736,0x1ba8,0x90},
        {0x4880,0x1b12,0xc0},{0x4906,0x1b24,0xd0},{0x49e6,0x1c00,0x00},{0x49ca,0x1c58,0x10},
    }) do
        checkShot(0x19,row[1],row[2],row[3],0xe,0x181746)
    end
    local reflected = checkShot(0x19,0x4880,0x1cee,0x40,0xe,0x181746)
    for _ = 1,600 do
        if not reflected.canBounce then break end
        bossStep()
    end
    equal(reflected.angle,0xc0)
    equal(reflected.canBounce,false)

    finalBoss.health = 1
    turret.damage(turret,2,pilot.hitFlags)
    bossStep()
    equal(finalBoss.dying,true)
    equal(turret.flags,0x8000)
    equal(finalBoss.boxes[14].flags,0x8000)
    local finalDeath = run.frame
    for _ = 1,340 do
        if run.stageCleared then break end
        bossStep()
    end
    equal(run.stageCleared,true)
    equal(run.boss5,nil)
    equal(run.frame - finalDeath,319)
    runtime.close(run)

    -- 复现 0x45 舱口地炮初次开火时的卷轴速度。
    run = fixture(5,{major=0xd0,scrollSpeed={0x10,0x10}},withArt)
    run.spawnIndex = #run.stage.spawns + 1
    pilot = runtime.addPlayer(run,1,1,{h=0xc00,l=0xe00,keys={},life=2,protect=0xff})
    local gun = assert(runtime.spawn(run,{0xd0,0,0x45,1,0x1393a4,0x16f638,0x16f69e}))
    for _ = 0,67 do bossStep() end
    equal(gun.h,0x7840)
    equal(gun.l,0x1c00)
    checkShot(6,0x7840,0x1c00,0x90,0x12,0x180dfc)
    for _ = 1,4 do bossStep() end
    checkShot(6,0x7800,0x1c00,0x90,0x12,0x180dfc)
    for _ = 1,4 do bossStep() end
    checkShot(6,0x77c0,0x1c00,0x90,0x12,0x180dfc)
    gun.damage(gun,0x601,pilot.hitFlags)
    bossStep()
    equal(run.enemies[gun.slot],nil)
    runtime.close(run)

    run = fixture(5,{major=0xe0},withArt)
    run.spawnIndex = #run.stage.spawns + 1
    pilot = runtime.addPlayer(run,1,1,{h=0xc00,l=0xe00,keys={},life=2,protect=0xff})
    platform = assert(runtime.spawn(run,{0xe0,0,0x55,0,0,0x170bf8,0x170c8c,h=0x6c80,l=0x1c00}))
    for _ = 0,31 do bossStep() end
    equal(platform.h,0x6c3f)
    equal(platform.front,0xc40)
    equal(platform.back,0x5c0)
    equal(platform.flags,0xa001)
    equal(platform.hp,0x7fff)
    for _ = 32,60 do bossStep() end
    equal(platform.h,0x673e)
    equal(platform.hp,0x1100)
    for _ = 61,74 do bossStep() end
    for i, row in ipairs({
        {0x64d3,0x1d88},{0x649b,0x1d6c},{0x646b,0x1d50},{0x63cb,0x1cb0},{0x63b7,0x1c88},
        {0x63a7,0x1c58},{0x63a7,0x1ba8},{0x63b7,0x1b78},{0x63cb,0x1b50},{0x646b,0x1ab0},
        {0x649b,0x1a94},{0x64d3,0x1a78},{0x65db,0x1a30},{0x661f,0x1a28},{0x665f,0x1a24},
    }) do
        local angle = 0x56 + 0x18 * math.floor((i - 1) / 3) + 4 * ((i - 1) % 3)
        checkShot(5,row[1],row[2],angle,0x13,0x180d40)
    end
    runtime.close(run)

    -- 同一局串行走两周目。关底使用受控的原版时限退出分支。
    run = runtime.init(1,nil,withArt)
    local controls = {}
    pilot = runtime.addPlayer(run,2,2,{h=0x1000,l=0xe00,keys=controls,life=2,bombs=1,protect=0xff})
    pilot.maxBombs = 3
    pilot.shotLevel,pilot.laserLevel,pilot.hyperStock = 3,2,1
    for chapter = 1,10 do
        local stage = (chapter - 1) % 5 + 1
        local loop = math.floor((chapter - 1) / 5)
        equal(run.stageNumber,stage)
        equal(run.loop,loop)
        equal(run.difficulty,stage - 1)
        if loop == 1 then equal(run.ranks[2],0xf8) end
        equal(pilot.model,2)
        equal(pilot.doll,2)
        equal(pilot.maxBombs,loop == 0 and 3 or 2)
        equal(pilot.bombs,loop == 0 and 1 or pilot.maxBombs)
        equal(pilot.life,2)
        equal(pilot.key,controls)
        equal(pilot.shotLevel,3)
        equal(pilot.laserLevel,2)
        equal(pilot.hyperStock,1)
        pilot.protect = 0xff
        local bossKey = 'boss' .. stage
        for _ = 1,20000 do
            if run[bossKey] then break end
            step()
        end
        local boss = assert(run[bossKey],('第 %d 面未生成关底，卷轴 %x，生成游标 %d'):format(
            stage,run.major,run.spawnIndex))
        for _ = 1,0x270 do step() end
        boss.timeout = 1
        local form = boss.form
        for _ = 1,3400 do
            if boss.transformed then boss.finalTimeout = 1 end
            step()
            if run.stageCleared then break end
            if boss.form ~= form then form,boss.timeout = boss.form,1 end
        end
        equal(run.stageCleared,true)
        local nextRun = runtime.advance(run)
        if chapter < 10 then
            assert(nextRun)
            equal(nextRun.player.score,pilot.score)
            equal(nextRun.randomByte,run.randomByte)
            equal(nextRun.rankTime,run.rankTime)
            equal(nextRun.player.h,0xc00)
            equal(nextRun.player.l,0xe00)
            equal(runtime.advance(run),nil)
            run,pilot = nextRun,nextRun.player
        else
            equal(nextRun,nil)
            runtime.close(run)
        end
        if afterFrame then afterFrame() end
    end

    -- V101 二周目首轮 12 发箭弹。射击前的机体、炮口角和随机游标来自同一攻击入口。
    local bossJobs = dofile('mod/GAME/th44/native/boss_tasks.lua')
    local bossRow
    for _,row in ipairs(program.stages[5].spawns) do
        if row[7] == 0x1a2938 then bossRow = row; break end
    end
    run = fixture(5,{loop=1,major=0x31a,bulletRank=5},withArt)
    run.spawnIndex = #run.stage.spawns + 1
    run.scrollIndex,run.scrollSpeed = {math.huge,math.huge},{0,0}
    pilot = runtime.addPlayer(run,1,1,{h=0xc00,l=0xe00,keys={},life=2,protect=0xff})
    local lastBoss = assert(runtime.spawn(run,assert(bossRow)))
    step()
    lastBoss.h,lastBoss.l,run.randomByte = 0x5fc0,0x1c00,0x9b
    for i,angle in ipairs({32,31,31,37,38,39}) do lastBoss.boxes[i + 1].angle = angle end
    bossJobs.clear(lastBoss.directors)
    bossJobs.attach(lastBoss.attacks,0)
    for _=1,33 do step() end
    equal(next(run.bullets),nil)
    step()
    for i,shot in ipairs({
        {0x6740,0xd9f,0x7a},{0x6740,0xd1f,0x92},{0x6780,0xdff,0x62},{0x4dc0,0xb1f,0x88},
        {0x4dc0,0xb9f,0x70},{0x3b40,0xbbf,0x7d},{0x5b21,0x27bf,0x9a},{0x5ba1,0x277f,0xb2},
        {0x5b01,0x283f,0x82},{0x4c01,0x2b7f,0xa0},{0x4bc1,0x2bdf,0x88},{0x3a81,0x263f,0xa3},
    }) do
        local o = assert(run.bullets[i])
        equal(o.kind,7)
        equal(o.h,shot[1])
        equal(o.l,shot[2])
        equal(o.angle,shot[3])
        equal(o.speed,0x12)
        equal(o.callback,0x180ee0)
    end
    equal(run.bullets[13],nil)

    local function verifyVolley(index,h,l,seed,waiting,expected)
        runtime.bullets.close(run)
        bossJobs.clear(lastBoss.attacks)
        lastBoss.h,lastBoss.l,run.randomByte = h,l,seed
        bossJobs.attach(lastBoss.attacks,index)
        for _=1,waiting + 1 do step() end
        equal(next(run.bullets),nil)
        step()
        for i,row in ipairs(expected) do
            local o = assert(run.bullets[i])
            equal(o.kind,row[1])
            equal(o.h,row[2])
            equal(o.l,row[3])
            equal(o.speed,row[4])
            equal(o.angle,row[5])
            equal(o.callback,row[6])
        end
    end
    verifyVolley(7,0x5ed7,0x1687,0,0x60,{
        {3,0x6597,0xfc7,0x1e,0x7a,0x180bc8},{4,0x6597,0xfc7,0x20,0x8e,0x180c84},
        {3,0x6597,0x1d47,0x1e,0x92,0x180bc8},{4,0x6597,0x1d47,0x20,0x7f,0x180c84},
    })
    verifyVolley(8,0x7d60,0x1dac,0x40,0x60,{
        {0x17,0x54de,0x1c03,0x23,0xb8,0x1815f2},{0x18,0x551e,0x1cc4,0x21,0x38,0x181698},
        {0x17,0x55e2,0x1c04,0x21,0xc7,0x1815f2},{0x18,0x55a2,0x1cc4,0x1f,0x47,0x181698},
    })
    local sliding,paused = run.bullets[1],run.bullets[2]
    local h,l = sliding.h,sliding.l
    local dh,dl = program.vector(sliding.speed,sliding.angle)
    step()
    equal(sliding.h,h + dh)
    equal(sliding.l,l + dl)
    equal(paused.h,0x551e)
    dh,dl = program.vector(paused.speed,paused.angle)
    step()
    equal(paused.h,0x551e + dh)
    equal(paused.l,0x1cc4 + dl)

    verifyVolley(11,0x5aad,0x1a18,0,0x10,{
        {3,0x54ad,0x1a18,0x2c,0x84,0x180bc8},{4,0x54ad,0x1a18,0x2f,0x6e,0x180c84},
        {5,0x54ad,0x1a18,0x32,0x58,0x180d40},{6,0x54ad,0x1a18,0x35,0x42,0x180dfc},
    })
    runtime.close(run)
    if afterFrame then afterFrame() end

    -- 0x1a4e7e -> 0x1a51e8 -> 0x1a538a。形态切换和判定来自同一关底实体。
    run = fixture(5,{loop=1,major=0x31a,bulletRank=5},withArt)
    run.spawnIndex = #run.stage.spawns + 1
    run.scrollIndex,run.scrollSpeed = {math.huge,math.huge},{0,0x20}
    pilot = runtime.addPlayer(run,1,1,{h=0xc00,l=0xe00,keys={},life=2,protect=0xff})
    lastBoss = assert(runtime.spawn(run,bossRow))
    local function reachAttack(index,maxFrames)
        for _=1,maxFrames do
            if lastBoss.form == 0 and lastBoss.h == 0x57c0 then run.scrollSpeed[2] = 0 end
            step()
            if bossJobs.contains(lastBoss.attacks,index) then return end
        end
        error(('二周目关底未登记攻击 %d，形态 %d，帧 %d'):format(index,lastBoss.form,run.frame))
    end
    reachAttack(3,5000)
    equal(lastBoss.health,0x3f000)
    lastBoss.health = 1
    lastBoss.damage(lastBoss.boxes[2],16,pilot.hitFlags)
    step()
    equal(lastBoss.transforming,true)
    equal(lastBoss.boxes[2].flags,0x8000)
    reachAttack(8,5000)
    equal(lastBoss.form,1)
    equal(lastBoss.health,0x23000)
    local first,second = lastBoss.boxes[11],lastBoss.boxes[12]
    equal(first.flags,0xa001)
    equal(second.flags,0xa001)
    lastBoss.damage(first,16,pilot.hitFlags)
    lastBoss.damage(second,32,pilot.hitFlags)
    step()
    equal(lastBoss.health,0x23000 - 32)
    lastBoss.health = 1
    lastBoss.damage(first,16,pilot.hitFlags)
    reachAttack(10,5000)
    equal(lastBoss.form,2)
    equal(lastBoss.health,0x4d000)
    equal(first.flags,0x8000)
    equal(second.flags,0x8000)
    local core = lastBoss.boxes[13]
    equal(core.flags,0xa001)
    run.bombMode = 'shot'
    lastBoss.damage(core,16,pilot.hitFlags)
    step()
    equal(lastBoss.health,0x4d000)
    equal(core.right,0x800)
    run.bombMode = nil
    for _=1,0x29 do step() end
    equal(core.right,0x500)
    lastBoss.health = 0x23001
    lastBoss.damage(core,16,pilot.hitFlags)
    step()
    equal(lastBoss.protected,true)
    equal(lastBoss.finalDefense,true)
    reachAttack(13,140)
    equal(lastBoss.protected,false)
    for _=1,600 do step() end
    lastBoss.health = 1
    lastBoss.damage(core,16,pilot.hitFlags)
    step()
    equal(lastBoss.dying,true)
    equal(core.flags,0x8000)
    local death = assert(lastBoss.directors[1])
    equal(death.index,5)
    for _=2,32 do step() end
    equal(death.phase,1)
    for _=33,298 do step() end
    equal(death.phase,2)
    for _=299,307 do step() end
    equal(death.phase,3)
    equal(lastBoss.drawHull,true)
    step()
    equal(death.phase,4)
    equal(lastBoss.drawHull,false)
    for _=309,436 do step() end
    equal(lastBoss.finished,true)
    step()
    equal(run.stageCleared,true)
    equal(run.boss5,nil)
    runtime.close(run)
end

-- 只用方向键和射击键走完实时时长。测试保护位持续开启，Boss 不写入测试伤害和时限。
local function verifyInputRoute()
    local keys = {shoot=true}
    local run = runtime.init(1)
    local pilot = runtime.addPlayer(run,2,2,{h=0x1000,l=0xe00,keys=keys,life=2,protect=0xff})
    for chapter=1,10 do
        equal(run.stageNumber,(chapter - 1) % 5 + 1)
        equal(run.loop,math.floor((chapter - 1) / 5))
        for _=1,40000 do
            local enemy = run['boss' .. run.stageNumber] or run.mid3 or run.mid4 or run.mid1 or run.mid2
            local target = enemy and enemy.l or 0x1c00
            keys.left,keys.right = pilot.l > target + 0x100,pilot.l < target - 0x100
            runtime.step(run)
            if run.stageCleared then break end
        end
        assert(run.stageCleared,('第 %d 周目第 %d 面在持续射击下未完成'):format(run.loop + 1,run.stageNumber))
        local nextRun = runtime.advance(run)
        if chapter == 10 then
            equal(nextRun,nil)
        else
            run = assert(nextRun)
            pilot = run.player
            pilot.protect = 0xff
        end
    end
    runtime.close(run)
end

if arg and arg[1] == '--luastg' then return verify end
verify(false)
verifyInputRoute()
print('大往生两周目十面流程、末关三形态、自机和持续射击回归通过。')
