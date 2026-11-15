-- 对照 ShmupMAME 原程序的首发与状态切换。LuaJIT 下运行对象回调。
local function readFile(name)
    local file = assert(io.open(name, 'rb'))
    local data = file:read('*a')
    file:close()
    return data
end

lstg = {LoadTextFile=readFile}
object = {RawDel=function(o) o.deleted=true end}
GROUP = {ENEMY=1, ENEMY_BULLET=2, GHOST=3, PLAYER=4, PLAYER_BULLET=5}
LAYER = {ENEMY=1, ENEMY_BULLET=2, BG=3, PLAYER=4, PLAYER_BULLET=5}
function Class(_, methods) return methods end
function New(class, ...)
    local o = {}
    class.init(o, ...)
    return o
end
function IsValid(o) return o and not o.deleted end

local runtime = dofile('mod/GAME/th43/native/runtime.lua')
local program = runtime.program
local equal = function(actual, expected)
    assert(actual == expected, ('实际 %s，预期 %s'):format(tostring(actual), tostring(expected)))
end

-- 固定自机保护以重复验证五面衔接。伤害由原生自机弹与敌机碰撞回调结算。
local function checkCampaign(route,run)
    local keys={shoot=true}
    if run then
        keys=run.player.key
    else
        run=runtime.init(1,route)
        runtime.addPlayer(run,1,{keys=keys,protect=0xff})
    end
    for expected=1,#program.stages do
        equal(run.stageNumber,expected)
        equal(run.routeName,route)
        local pilot=run.player
        pilot.protect=0xff
        for _=1,50000 do
            local enemy=run.boss or run.boss2 or run.boss3 or run.boss4 or run.boss5
                or run.mid1 or run.mid2 or run.mid3 or run.mid4 or run.mid5
            local target,priority
            for _,part in ipairs(enemy and enemy.parts or {}) do
                if part.colli and part.h and part.l and part.h>0x1600 and part.h<0x7200
                    and part.l>=0x300 and part.l<=0x3500 then
                    local distance=part.h+math.abs(part.l-pilot.l)/2
                    if not priority or distance<priority then target,priority=part,distance end
                end
            end
            local l=target and target.l or 0x1c00
            local h=target and math.max(0x1300,math.min(target.h-0x1000,0x3500)) or 0x1000
            keys.left,keys.right=l<pilot.l-0x70,l>pilot.l+0x70
            keys.up,keys.down=h>pilot.h+0x70,h<pilot.h-0x70
            runtime.step(run)
            if run.stageCleared then break end
        end
        assert(run.stageCleared,('%s 第 %d 面未触发退场'):format(route,expected))
        equal(run.firstUnsupported,nil)
        local stock=runtime.playerStock(run)
        print(('%s 第 %d 面退场通过（%d 帧，分数 %d）'):format(route,expected,run.frame,stock.score))
        if expected==#program.stages then
            if route=='first' then
                equal(run.nextRoute,'omote')
                equal(run.campaignCleared,false)
            else
                equal(run.nextStageNumber,nil)
                equal(run.campaignCleared,true)
                runtime.close(run)
                return
            end
        end
        run=assert(runtime.advance(run))
        equal(run.player.score,stock.score)
        equal(run.player.life,stock.life)
        equal(run.player.level,stock.level)
    end
    return run
end

if arg and arg[1]=='--campaign' then
    checkCampaign('omote',checkCampaign('first'))
    checkCampaign('ura')
    return
end

-- 0x1056fa 只在第五面结算后判定表里。核对临界分数、坠毁与耗弹数。
do
    local run=runtime.init(5,'first')
    local pilot=runtime.addPlayer(run,1,{keys={},score=119999999})
    equal(runtime.score.secondLoop(pilot),'omote')
    runtime.score.add(pilot,1)
    equal(runtime.score.secondLoop(pilot),'ura')
    pilot.misses,pilot.bombsUsed=2,4
    equal(runtime.score.secondLoop(pilot),'omote')
    pilot.bombsUsed=5
    equal(runtime.score.secondLoop(pilot),nil)
    pilot.misses,pilot.bombsUsed=7,0
    equal(runtime.score.secondLoop(pilot),nil)
    runtime.close(run)
end

-- 单人关底结算完成才发布下一面，进场使用新对象并继承本局状态。
do
    local run=runtime.init(5,'first')
    local pilot=runtime.addPlayer(run,1,{keys={},score=119999000,life=2,bombs=3,level=4})
    run.bossMultiplier=10
    equal(runtime.advance(run),nil)
    runtime.score.stageBonus(run)
    equal(run.stageBonus,16500)
    runtime.score.stageBonus(run)
    equal(pilot.score,120015500)
    equal(runtime.score.secondLoop(pilot),'ura')
    run.stageCleared,run.nextStageNumber,run.nextRoute=true,1,'ura'
    local nextRun=assert(runtime.advance(run))
    equal(IsValid(pilot),false)
    equal(runtime.advance(run),nil)
    equal(nextRun.stageNumber,1)
    equal(nextRun.routeName,'ura')
    equal(nextRun.player.level,4)
    equal(nextRun.player.score,120015500)
    runtime.close(nextRun)
end

local counts = {262, 261, 378, 309, 475}
local callbacks = {255, 250, 373, 302, 463}
local bosses = {0x70, 0x90, 0x76, 0x79, 0x64}
local releases = {[2]=304, [4]=279, [5]=444}
local scroll = dofile('mod/GAME/th43/native/scroll.lua')
for i, count in ipairs(counts) do
    local stage = program.stages[i]
    equal(#stage.spawns, count)
    equal(#stage.tiles, stage.across * stage.forward)
    local run, found, released = {}, false, false
    scroll.init(run, stage)
    for _ = 1, 18000 do
        if releases[i] and run.holdMajor and not released then
            local major = run.major
            for _ = 1, 128 do scroll.advance(run) end
            equal(run.major, major)
            runtime.releaseScroll(run, releases[i])
            released = true
        end
        scroll.advance(run)
        program.spawnRows(run, function(_, row)
            if row[3] == bosses[i] then found = true end
        end)
        if found then break end
    end
    equal(found, true)
end

-- 用原生受击回调触发遭遇战放行，逐帧走到五面的关底生成记录。
for i, stage in ipairs(program.stages) do
    local translated = 0
    for _, row in ipairs(stage.spawns) do
        if row[10]==0x0d0630 then
            local cursor=row[6]-stage.pathBase+5
            local kind=program.word(stage.paths,cursor)%256
            if kind==2 then kind=program.word(stage.paths,cursor+2)%256 end
            equal(runtime.enemies.supports({[10]=program.spawnTypes[kind][2]}),true)
        end
        if runtime.enemies.supports(row) or row[10] == 0x10cefe or row[10] == 0x112cd6 or row[10] == 0x119a06 or row[10] == 0x130fea
            or row[10] == 0x12ec6c
            or row[10] == 0x133262 or row[10] == 0x138cbc or row[10] == 0x13b168 or row[10] == 0x11fa18 or row[10] == 0x0d0630
            or row[10] == 0x0e8f36 or row[10] == 0x125a4c then
            translated = translated + 1
        end
    end
    equal(translated, callbacks[i])
    for _, route in ipairs({'first', 'omote', 'ura'}) do
        local run = runtime.init(i, route)
        local pilot = {respawn=0,protect=0}
        pilot.x, pilot.y = program.world(0x0de4, 0x0f80)
        local burstSeen, released, verifiedExplosion = false, false, false
        local mid5Brake, mid5Child, mid5Phase = false, false, false
        for _ = 1, 18000 do
            if i == 2 and run.mid2 and run.mid2.parts[1].colli and not released then
                local core = run.mid2.parts[1]
                local rear = run.mid2.parts[2]
                runtime.playerShot(run, {h=rear.h,l=rear.l,front=0x80,back=0x100,right=0x80,left=0x80,
                    damage=0x17000})
                runtime.step(run, pilot)
                equal(core.broken, nil)
                equal(rear.broken, true)
                equal(core.hp, 0x10e00)
                equal(run.releaseAt, nil)
                runtime.playerShot(run, {h=core.h,l=core.l,front=0x80,back=0x100,right=0x80,left=0x80,
                    damage=0x30000})
                runtime.step(run, pilot)
                equal(core.broken, true)
                equal(rear.broken, true)
                released = true
            elseif i == 4 and run.mid4 and run.mid4.cycles == 1 and not released then
                local encounter = run.mid4
                local hull, turret = unpack(encounter.parts)
                pilot.protect = 200
                hull.damage(hull, encounter.hp - 0x17900)
                turret.damage(turret, 0x200)
                runtime.step(run, pilot)
                equal(encounter.hp, 0x17900)
                equal(turret.broken, true)
                equal(turret.colli, false)
                equal(run.releaseAt, nil)
                local shot = {h=hull.h,l=hull.l,front=0x80,back=0x100,right=0x80,left=0x80,damage=0x20000}
                equal(runtime.playerShot(run, shot), hull)
                runtime.step(run, pilot)
                equal(encounter.dead, true)
                released = true
            elseif i == 5 and run.mid5 and not released then
                local encounter = run.mid5
                pilot.protect = 200
                for _, shot in pairs(run.bullets) do
                    if shot.kind == 0x34 and shot.redirected then mid5Brake = true end
                    if shot.kind == 0x25 then mid5Child = true end
                    if shot.kind == 0x39 and encounter.phase == 1 then mid5Phase = true end
                end
                if mid5Brake and mid5Child and encounter.phase == 0 then
                    for index = 5, 6 do
                        local gun = encounter.parts[index]
                        local shot = {h=gun.h,l=gun.l,front=0x80,back=0x100,right=0x80,left=0x80,damage=0xc000}
                        equal(runtime.playerShot(run, shot), gun)
                    end
                    runtime.step(run, pilot)
                    equal(encounter.phase, 1)
                    equal(encounter.parts[5].broken, true)
                    equal(encounter.parts[6].broken, true)
                    equal(encounter.hp, 0x3b500)
                    equal(run.releaseAt, nil)
                elseif mid5Phase then
                    local core = encounter.parts[1]
                    local shot = {h=core.h,l=core.l,front=0x80,back=0x100,right=0x80,left=0x80,damage=0x60000}
                    equal(runtime.playerShot(run, shot), core)
                    runtime.step(run, pilot)
                    equal(encounter.dead, true)
                    equal(encounter.parts[3].broken, true)
                    equal(encounter.parts[4].broken, true)
                    released = true
                end
            end
            runtime.step(run, pilot)
            if i == 2 and run.effects[1] and run.effects[1].sprite then verifiedExplosion = true end
            if not burstSeen and i >= 4 then
                for _, shot in pairs(run.bullets) do
                    if shot.kind == 0x19 then burstSeen = true; break end
                end
            end
            if run.spawnIndex > #stage.spawns then break end
        end
        equal(run.spawnIndex, #stage.spawns + 1)
        equal(burstSeen, i >= 4)
        equal(verifiedExplosion, i == 2)
        if i == 1 then equal(run.mid1, nil) end
        if i == 4 then
            equal(released, true)
            equal(run.mid4, nil)
        end
        if i == 3 then equal(run.mid3, nil) end
        if i == 5 then
            equal(released, true)
            equal(run.mid5, nil)
        end
        equal(run.firstUnsupported,nil)
        runtime.close(run)
    end
end
-- 0x80 从卷轴生成，开启本体判定后依次挂中炮和子机槽。
for _, route in ipairs({'first','omote','ura'}) do
    local run = runtime.init(1,route)
    local row
    for _, candidate in ipairs(run.stage.spawns) do
        if candidate[3] == 0x80 then row = candidate; break end
    end
    local ship = runtime.mid1.spawn(run,row)
    equal(ship.h,program.s16(0x8080))
    equal(ship.l,0x3040)
    equal(ship.hp,0xec00)
    equal(ship.parts[5].colli,false)
    run.pilotH,run.pilotL,run.fullDamage = 0x0de4,0x0f80,true
    local sawEffect = false
    local function step(frames)
        for _ = 1, frames do
            run.frame = run.frame+1
            run.scrollStep = run.frame%3 ~= 0 and 1 or 0
            if run.mid1 then runtime.mid1.step(ship) end
            runtime.bullets.step(run)
            sawEffect = sawEffect or next(run.effects) ~= nil
        end
    end
    step(1)
    equal(ship.h,0x7fc0)
    equal(ship.l,0x3000)
    local found = {}
    for _ = 1, 1800 do
        step(1)
        for _, bullet in pairs(run.bullets) do found[bullet.kind] = true end
        if ship.phase == 'bayVolley' and next(ship.drones) and found[0xb] and found[2] then break end
    end
    for _, kind in ipairs({0,1,2,0xb}) do equal(found[kind],true) end
    equal(ship.armed,true)
    assert(next(ship.drones))
    ship.h,ship.l = 0x6000,0x2800
    step(1)
    local parts = ship.parts
    parts[5].damage(parts[5],0x100)
    parts[6].damage(parts[6],0x200)
    step(1)
    equal(ship.hp,0xea00)
    if route ~= 'ura' then
        local side = parts[1]
        equal(runtime.playerShot(run,{h=side.h+0x900,l=side.l-0x600,front=0x40,back=0x80,right=0x40,left=0x40,
            damage=0x7601}),side)
        step(1)
        equal(ship.hp,0x7500)
        equal(ship.wings[1].broken,true)
        equal(parts[1].colli,false)
    end
    if route == 'first' then parts[2].damage(parts[2],0x7601)
    else parts[5].damage(parts[5],ship.hp+1) end
    step(1)
    equal(ship.dead,true)
    equal(ship.forcedWings,route == 'first' and 0 or route == 'omote' and 1 or 2)
    equal(ship.wings[2].broken,true)
    equal(parts[5].colli,false)
    equal(next(ship.drones),nil)
    step(100)
    equal(run.mid1,nil)
    equal(sawEffect,true)
    runtime.close(run)
end

equal(program.angle(0x5a35, 0x2b84, 0x0de4, 0x0f80), 0x25)
equal(program.angle(0x58de, 0x283d, 0x0de4, 0x2120), 0x22)
-- 筹码与自机只差一个定点单位时，正好会查到方向表末项。
equal(program.angle(0x1001, 0x1c01, 0x1000, 0x1c00), 0x28)
equal(program.aimByte(0x1001, 0x1c01, 0x1000, 0x1c00, 0x80), 0xa0)
equal(program.aimByte(0x1001, 0x1bff, 0x1000, 0x1c00, 0x80, true), 0x60)
equal(program.aimByte(0x1000, 0x1c00, 0x1000, 0x1c00, 0x80), 0x80)

-- 三面战舰复用关卡路径。核对入场指令、独立炮口、共享扣血、展开保护及退场。
for _, route in ipairs({'first', 'omote', 'ura'}) do
    local run = runtime.init(3, route)
    run.major, run.minor, run.pilotH, run.pilotL = 0x118, 0, 0x1000, 0x1c00
    local ship
    for _, row in ipairs(run.stage.spawns) do
        if row[3] == 0xa0 then ship = runtime.mid3.spawn(run, row); break end
    end
    local parts = ship.byIndex
    equal(program.s16(ship.h), program.s16(0xb640))
    equal(ship.l, program.s16(0xcbc0))
    equal(parts[1].colli, false)
    runtime.bullets.emitFasterInLoop(run, 6, -1, 0x80, 0x3000, 0x1c00)
    equal(run.bullets[1].speed, program.bulletSpeed(run, 6, -1 + run.route.loop * 4))
    equal(run.bullets[2], nil)
    runtime.bullets.clear(run, true)
    local function step(frames)
        for _ = 1, frames do
            if run.mid3 then runtime.mid3.step(ship) end
            runtime.bullets.step(run)
        end
    end
    step(2)
    equal(ship.h, program.s16(0xb63b))
    equal(ship.l, program.s16(0xcbc6))
    step(253)
    equal(parts[1].colli, false)
    step(1)
    equal(parts[1].colli, true)
    equal(parts[25].colli, true)
    equal(parts[27].colli, false)

    -- 暂停路径移动只用于隔离炮口和碰撞，关卡回归另走自然退场。
    ship.path, ship.cursor, ship.elapsed = string.char(0x40,0), 1, 0
    ship.h, ship.l = 0x5000, 0x500
    run.minor, run.fullDamage = 0x50, true
    step(1)
    local function fire(part, value)
        local hit = runtime.playerShot(run, {h=part.h,l=part.l,front=0x40,back=0x80,right=0x40,left=0x40,damage=value})
        equal(hit, part)
        step(1)
    end
    fire(parts[5], 0x600)
    equal(parts[5].life, 0)
    equal(parts[5].colli, true)
    fire(parts[5], 1)
    equal(parts[17].colli, false)
    fire(parts[6], 0x601)
    equal(parts[17].colli, true)
    equal(parts[18].colli, true)
    parts[17].damage(parts[17], 0x100)
    parts[18].damage(parts[18], 0x200)
    step(1)
    equal(ship.zones[1].hp, 0x1a00)

    local seen = {}
    for _ = 1, 430 do
        step(1)
        for _, bullet in pairs(run.bullets) do seen[bullet.kind] = true end
    end
    for _, kind in ipairs({6,7,8,0xc,0x16}) do equal(seen[kind], true) end

    fire(parts[25], 0x3c01)
    equal(parts[27].colli, false)
    if route == 'first' then run.minor = 0x2f end
    fire(parts[26], 0x3a01)
    equal(parts[27].colli, true)
    equal(parts[28].colli, true)
    parts[27].damage(parts[27], 0x100)
    step(1)
    equal(parts[1].broken, true)
    equal(parts[7].colli, true)
    equal(ship.zones[5].hp, 0x7000)
    local coreShot = false
    for _ = 1, 134 do
        step(1)
        for _, bullet in pairs(run.bullets) do
            if bullet.kind == 3 then coreShot = true end
        end
    end
    equal(coreShot, true)
    if route == 'first' then
        run.minor = 0x50
        for remaining = 0x46, 0, -1 do
            parts[27].damage(parts[27], 1)
            parts[28].damage(parts[28], 2)
            step(1)
            equal(ship.coreGate, remaining)
            equal(ship.zones[5].hp, 0x7000)
        end
    end
    parts[27].damage(parts[27], 0x1000)
    parts[28].damage(parts[28], 0x2000)
    step(1)
    equal(ship.zones[5].hp, 0x5000)
    parts[29].damage(parts[29], 0x5001)
    step(1)
    equal(ship.death.phase, 0)
    equal(parts[29].colli, false)
    step(1)
    equal(parts[7].broken, true)
    step(419)
    equal(run.mid3, nil)
    equal(IsValid(parts[1]), false)
    runtime.close(run)
end

-- 0xe8f36 在六个绘制槽到齐后循环机件，再等待六个槽退出。
for number, stage in ipairs(program.stages) do
    local run = runtime.init(number, 'first')
    for index, row in ipairs(stage.spawns) do
        if row[3] == 0x91 then
            run.major, run.minor, run.spawnIndex = row[1], row[2], index
            break
        end
    end
    run.freeze = true
    runtime.step(run)
    local scene = assert(run.warning)
    equal(#scene.parts, 6)
    equal(scene.colli, false)
    local phases = {}
    for _ = 1, 330 do
        if not run.warning then break end
        phases[scene.phase] = true
        runtime.step(run)
    end
    for phase = 0, 4 do equal(phases[phase], true) end
    equal(run.warning, nil)
    equal(IsValid(scene), false)
    runtime.close(run)
end

-- 0xf76f2 继续更新减容后的旧槽，它已离开 0xb10d8 的有效碰撞区。
do
    local run = runtime.init(1, 'first')
    for _ = 1, run.capacity do runtime.bullets.emitAngle(run, 9, 0, 0x80, 0x4800, 0x1c00) end
    local tail = run.bullets[run.capacity]
    tail.l = 0x2000
    runtime.bullets.step(run)
    local oldH = tail.h
    run.capacity = 10
    runtime.bullets.step(run)
    assert(tail.h ~= oldH)
    equal(runtime.bullets.hit(run, tail.h, tail.l, 0xc0, 0xc0, 0x80, 0x80), nil)
    runtime.bullets.clear(run)
    for _ = 1, 17 do runtime.bullets.step(run) end
    equal(next(run.bullets), nil)
    equal(run.bulletTail, nil)
    runtime.close(run)
end

-- 0xf72a8 会把清弹期间新占用的槽也切到消失回调。
do
    local run = runtime.init(1, 'first')
    runtime.bullets.clearFor(run, 2)
    for _ = 1, 2 do
        local shot = runtime.bullets.emitAngle(run, 9, 0, 0x80, 0x4800, 0x1c00)
        runtime.bullets.step(run)
        equal(shot.fade, 1)
    end
    local shot = runtime.bullets.emitAngle(run, 9, 0, 0x80, 0x4800, 0x1c00)
    runtime.bullets.step(run)
    equal(shot.fade, nil)
    runtime.close(run)
end

-- 0xddafc 的双炮口各一发，命中后对象原址进入坠毁回调。
for _, number in ipairs({2, 5}) do
    for _, route in ipairs({'first', 'omote', 'ura'}) do
        local run = runtime.init(number, route)
        run.pilotH, run.pilotL = 0x1000, 0x2000
        local plane
        for _, row in ipairs(run.stage.spawns) do
            if row[3] == 0x43 then
                run.major = row[1]
                plane = runtime.enemies.spawn(run, row)
                break
            end
        end
        assert(plane and plane.active)
        plane.h, plane.l, plane.state[0x2a] = 0x5000, 0x1800, 0
        runtime.enemies.step(run)
        local shots = 0
        for _, shot in pairs(run.bullets) do
            if shot.kind == 4 then shots = shots + 1 end
        end
        equal(shots, number == 2 and 2 or route == 'first' and 10 or 14)
        -- 固定到减速路径的可受击段，避免出生时的无敌窗口影响这一分支。
        plane.state[0x35] = 0
        plane.damage(plane, plane.hp + 1, 'shot')
        runtime.enemies.step(run)
        equal(plane.crashing, true)
        equal(plane.flags, 0x8000)
        local h, direction = plane.h, plane.aimDirection
        runtime.enemies.step(run)
        equal(plane.h, h - 0xc0)
        equal(plane.aimDirection, (direction - 2) % 64)
        for _ = 1, 48 do runtime.enemies.step(run) end
        equal(IsValid(plane), false)
        assert(next(run.effects))
        runtime.close(run)
    end
end

-- 四、五面旋转炮组的生成、舱盖和制导弹由同一个敌机回调推进。
for _, route in ipairs({'first', 'omote', 'ura'}) do
    for stage = 4, 5 do
        local run = runtime.init(stage, route)
        run.pilotH, run.pilotL = 0xde4, 0x0f80
        run.capacity = 190
        if stage == 4 and route == 'first' then run.rankBase = 0xd8 end
        local row
        for _, candidate in ipairs(run.stage.spawns) do
            if candidate[3] == 0x5a then row = candidate; break end
        end
        local enemy = assert(runtime.enemies.spawn(run, row))
        equal(enemy.kind, 0x5a)
        equal(enemy.hp, stage == 4 and 0x2200 or 0x1800)
        equal(enemy.state[0x1c], stage == 4 and 0x10 or 0x20)
        -- 原机第四面首个 0x5a 的舱盖延迟为 0x25，测试用 rank 0xd8 复现这个换算结果。
        equal(enemy.state[0x2e], route ~= 'first' and 0x23 or stage == 4 and 0x25 or 0x33)
        -- 用场内静止路径独立观察完整舱盖循环。
        enemy.h, enemy.l = 0x4900, 0x1c00
        enemy.path, enemy.cursor, enemy.elapsed = string.char(0x40, 0), 1, 0
        local redirected, closed, seen, checkedRing = false, false, {}, false
        for _ = 1, 620 do
            run.frame = run.frame + 1
            runtime.enemies.step(run)
            if not seen[0x2d] then
                local count, angles = 0, {}
                for _, shot in pairs(run.bullets) do
                    if shot.kind == 0x2d then
                        count = count + 1
                        angles[shot.angle] = true
                        local h, l = unpack(program.rail.hatchMuzzle[shot.angle / 4 + 1])
                        equal(shot.h, enemy.h + h + 0x700)
                        equal(shot.l, enemy.l + l)
                    end
                end
                if count > 0 then
                    equal(count, route == 'first' and 16 or 32)
                    for angle = 0, 0xf0, 0x10 do equal(angles[angle], true) end
                    checkedRing = true
                end
            end
            runtime.bullets.step(run)
            for _, shot in pairs(run.bullets) do
                seen[shot.kind] = true
                if shot.kind == 0x2d and shot.redirected then
                    assert(shot.speed <= 0x16)
                    if shot.speed == 0x16 then redirected = true end
                end
            end
            if enemy.hatch == 0 and seen[0x2d] then closed = true end
            if redirected and closed then break end
        end
        equal(seen[4], true)
        equal(seen[0x2d], true)
        equal(checkedRing, true)
        equal(redirected, true)
        equal(closed, true)
        equal(runtime.playerShot(run, {h=enemy.h,l=enemy.l,front=0x100,back=0x200,right=0x80,left=0x80,
            damage=0x4000}), enemy)
        runtime.enemies.step(run)
        equal(IsValid(enemy), false)
        assert(next(run.effects), '旋转炮组击破未登记爆炸')
        runtime.close(run)
    end
end

local gunshipRun = runtime.init(4, 'first')
local gunshipPilot = {x=0,y=-180,respawn=0,protect=200}
local gunship
for _ = 1, 720 do
    runtime.step(gunshipRun, gunshipPilot)
    for _, enemy in pairs(gunshipRun.enemies) do
        if enemy.kind == 0x96 and enemy.h >= 0x1800 and enemy.h < 0x6000
            and enemy.l >= 0x400 and enemy.l < 0x3400 then
            gunship = enemy
            break
        end
    end
    if gunship then break end
end
assert(gunship)
local wingShot = {h=gunship.h,l=gunship.l+0x500,damage=0x80,front=0x20,back=0x40,right=0x20,left=0x20}
equal(runtime.playerShot(gunshipRun, wingShot), gunship.second)
runtime.step(gunshipRun, gunshipPilot)
equal(gunship.hp, 0x7fff - 0x60)
equal(gunship.second.hp, gunship.hp)
runtime.close(gunshipRun)

-- 两段耐久由炮车自己的更新回调结算，第一段击破后残骸继续走同一路径。
local tankRun = runtime.init(3, 'first')
local tank
for _, row in ipairs(tankRun.stage.spawns) do
    if row[3] == 0x4c and row[4] == 1 then tank = runtime.enemies.spawn(tankRun, row); break end
end
assert(tank and tank.active)
local tankHP = tank.hp
local initialH, initialL = tank.h, tank.l
tank.damage(tank, tankHP + 1, 'shot')
runtime.enemies.step(tankRun)
equal(tank.damaged, true)
equal(tank.hp, 0x140)
assert(tank.h ~= initialH or tank.l ~= initialL)
tank.damage(tank, tank.hp + 1, 'shot')
runtime.enemies.step(tankRun)
equal(IsValid(tank), false)
runtime.close(tankRun)

-- 0xb0322 的 bit 1 窗口只影响敌机本体，点坐标敌弹每帧都可命中。
do
    local run = runtime.init(1, 'first')
    local pilot = {respawn=0,protect=0}
    pilot.x, pilot.y = program.world(0x3800, 0x1c00)
    local plane = runtime.enemies.spawn(run, run.stage.spawns[1])
    assert(plane and plane.active and plane.flags % 2 == 1)
    plane.h, plane.l, plane.speed, plane.update = 0x3800, 0x1c00, 0, function() end
    runtime.step(run, pilot)
    equal(runtime.consumePlayerHit(run), nil)
    runtime.step(run, pilot)
    equal(runtime.consumePlayerHit(run), plane)
    runtime.close(run)
end

local controlled = runtime.init(1, 'first')
local inputs = {}
local ship = runtime.addPlayer(controlled, 1, {keys=inputs})
equal(ship.level, 1)
equal(ship.optionCount, 2)
for _ = 1, 40 do runtime.step(controlled) end
equal(ship.options[1].h, 0x688)
equal(ship.options[1].l, 0xb90)
equal(ship.options[2].l, 0x1370)
inputs.shoot = true
runtime.step(controlled)
equal(ship.shots[1].h, 0xa48)
equal(ship.shots[1].l, 0xb10)
equal(ship.shots[8].l, 0x13f0)
equal(ship.shots[29].h, 0x11a4)
runtime.step(controlled)
equal(ship.shots[1].h, 0xdae)
equal(ship.shots[1].l, 0xaa2)
equal(ship.shots[1].dh, 0x366)
equal(ship.shots[1].dl, -0x6e)
equal(ship.shots[29].h, 0x11a4)
runtime.step(controlled)
equal(ship.shots[29].h, 0x1523)
runtime.step(controlled)
equal(ship.shots[30].mode, 'normal')
equal(ship.shots[30].h, 0x11a4)
equal(ship.shots[2].mode, 'option')
for _ = 5, 24 do runtime.step(controlled) end
equal(ship.locked, false)
runtime.step(controlled)
equal(ship.locked, true)
equal(ship.speed, 0x13)
runtime.step(controlled)
equal(ship.shots[32].chargeStep, 4)
runtime.step(controlled)
equal(ship.speed, 0x12)
runtime.step(controlled)
equal(ship.shots[32].dh, 0x4e5)
inputs.shoot, inputs.right = false, true
runtime.step(controlled)
equal(ship.locked, false)
equal(ship.speed, 0x13)
equal(ship.l, 0x0f80 + 0x85)
inputs.right, inputs.spell = false, true
runtime.step(controlled)
equal(ship.bombs, 2)
equal(ship.protect, 0xff)
equal(controlled.bombsUsed, 1)
assert(ship.bombObjects[1] and ship.bombObjects[2])
inputs.spell = false
for _ = 1, 180 do runtime.step(controlled) end
equal(next(ship.bombObjects), nil)
assert(ship.protect > 0 and ship.protect <= 0x5a)
runtime.close(controlled)

-- C 键每隔一帧测试一次弹槽，保持普通炮口和快移，松开后不补发。
do
    local run=runtime.init(1,'first')
    local keys={}
    local pilot=runtime.addPlayer(run,1,{keys=keys})
    for _=1,40 do runtime.step(run) end
    keys.special=true
    runtime.step(run)
    equal(pilot.shots[29].mode,'normal')
    equal(pilot.shots[1].mode,'option')
    runtime.step(run)
    equal(pilot.shots[30],nil)
    runtime.step(run)
    equal(pilot.shots[30].mode,'normal')
    for _=1,26 do runtime.step(run) end
    equal(pilot.held,0x19)
    equal(pilot.locked,false)
    equal(pilot.speed,pilot.baseSpeed)
    equal(pilot.options[1].deploy,0)
    keys.special=false
    local count=pilot.hullFlash
    for _=1,8 do runtime.step(run) end
    equal(pilot.hullFlash,count)
    runtime.close(run)
end

-- 一颗 0x180 普通弹在同帧依次命中两个共位的 0x20 小型机部件。
local penetration = runtime.init(1, 'first')
for slot = 11, 12 do
    penetration.enemies[slot] = {h=0x3000,l=0x1c00,hp=0x20,flags=0xa301,hitPool=1,
        front=0x500,back=0x400,right=0x480,left=0x480,
        damage=function(o, value) o.hp = o.hp - value end}
end
local penetrator = {h=0x3000,l=0x1c00,damage=0x180,front=0x480,back=0x900,right=0x180,left=0x180}
equal(runtime.playerShot(penetration, penetrator), penetration.enemies[11])
equal(penetration.enemies[11].hp, -0x100)
equal(penetration.enemies[12].hp, -0xe8)
equal(penetrator.damage, 0x140)
equal(penetrator.pendingHit, true)

local function opening(route)
    local run = runtime.init(1, route)
    local pilot = {respawn=0,protect=0}
    pilot.x, pilot.y = program.world(0x0de4, 0x0f80)
    for frame = 1, 160 do
        runtime.step(run, pilot)
        local bullet = run.bullets[1]
        if bullet then return run, pilot, bullet end
    end
    error('首架小型机没有发弹')
end

local first, pilot, bullet = opening('first')
local omote, _, shotOmote = opening('omote')
local ura, _, shotUra = opening('ura')
equal(first.frame - omote.frame, 22)
equal(omote.frame, ura.frame)
equal(bullet.speed, 0x17)
equal(shotOmote.speed, 0x1c)
equal(shotUra.speed, 0x1e)
equal(shotOmote.h, 0x669e)
equal(shotOmote.l, 0x30ae)
equal(shotUra.h, shotOmote.h)
equal(shotUra.l, shotOmote.l)
equal(bullet.angle, 0x94)
equal(bullet.h, 0x5456)
equal(bullet.l, 0x29c3)
runtime.step(first, pilot)
equal(bullet.h, 0x5377)
equal(bullet.l, 0x2973)
while first.frame < 218 do runtime.step(first, pilot) end
equal(bullet.h, 0x159e)
equal(bullet.l, 0x1343)
equal(runtime.consumePlayerHit(first), nil)
equal(runtime.bullets.hit(first, 0x0de4, 0x0f80, 0xc0, 0xc0, 0x80, 0x80, true), bullet)

local collision = runtime.init(1, 'first')
local b = runtime.bullets.emit(collision, 9, 3, 0x25, 0x0de4, 0x0f80)
runtime.bullets.step(collision)
equal(runtime.bullets.hit(collision, b.h - 0xc0, b.l + 0x80, 0xc0, 0xc0, 0x80, 0x80), b)
equal(runtime.bullets.hit(collision, b.h, b.l, 0xc0, 0xc0, 0x80, 0x80), nil)
local h, l = b.h, b.l
local dh, dl = math.floor(b.dh / 2), math.floor(b.dl / 2)
runtime.bullets.step(collision)
equal(b.h, h + dh)
equal(b.l, l + dl)
for _ = 2, 16 do runtime.bullets.step(collision) end
equal(collision.bullets[1], nil)

local function startBoss(route)
    local run = runtime.init(1, route)
    run.pilotH, run.pilotL = 0x0de4, 0x0f80
    run.scrollStep = 1
    local boss = runtime.boss1.spawn(run)
    for _ = 1, 500 do
        runtime.boss1.step(boss)
        if boss.ready then break end
    end
    assert(boss.ready)
    return run, boss
end

local run, boss = startBoss('first')
local parts = boss.parts
equal(boss.hp, 0x22200)
parts[4].damage(parts[4], 0x1381)
runtime.boss1.step(boss)
equal(parts[4].broken, true)
equal(boss.phase, 0)
parts[2].damage(parts[2], 0x1041)
runtime.boss1.step(boss)
equal(boss.phase, 1)
equal(boss.hp, 0x22200)
equal(boss.events[1].id, 1)
equal(boss.events[1].payload[1], true)
equal(boss.events[1].payload[3], true)
runtime.boss1.step(boss)
equal(boss.events[1].delay, 24)
for _ = 1, 56 do runtime.boss1.step(boss) end
equal(boss.damageLocked, false)
runtime.close(run)

run, boss = startBoss('ura')
parts = boss.parts
for i = 4, 7 do parts[i].damage(parts[i], 0x1381) end
parts[2].damage(parts[2], 0x1041)
runtime.boss1.step(boss)
equal(boss.phase, 0)
parts[3].damage(parts[3], 0x1041)
runtime.boss1.step(boss)
equal(boss.phase, 1)
runtime.close(run)

run, boss = startBoss('omote')
boss.parts[1].damage(boss.parts[1], 0x22200 - 0x15f00)
runtime.boss1.step(boss)
equal(boss.phase, 1)
equal(boss.hp, 0x15f00)
for _ = 1, 65 do runtime.boss1.step(boss) end
equal(boss.damageLocked, false)
local core = boss.parts[1]
local x, y = program.world(core.h, core.l)
equal(runtime.playerShot(run, {x=x,y=y,front=0x80,back=0x80,right=0x80,left=0x80,damage=0x1d401}), core)
runtime.boss1.step(boss)
equal(boss.phase, 2)
equal(boss.events[1].id, 2)
for _ = 1, 350 do
    if run.bossRetired then break end
    runtime.boss1.step(boss)
end
equal(run.bossRetired, true)
equal(run.stageCleared, true)
equal(run.nextStageNumber, 2)
equal(IsValid(core), false)
runtime.close(run)

for _, route in ipairs({'first', 'omote', 'ura'}) do
    local encounter, machine = startBoss(route)
    local sawRearGun, sawAttackDrone, sawEscortDrone = false, false, false
    for _ = 1, 2200 do
        runtime.boss1.step(machine)
        runtime.bullets.step(encounter)
        for _, shot in pairs(encounter.bullets) do
            if shot.kind == 8 then sawRearGun = true; break end
        end
        for _, pod in pairs(machine.pods) do
            if pod.kind == 0x72 then sawAttackDrone = true end
            if pod.kind == 0x73 then sawEscortDrone = true end
        end
        if sawRearGun and sawAttackDrone and sawEscortDrone then break end
    end
    equal(sawRearGun, true)
    equal(sawAttackDrone, true)
    equal(sawEscortDrone, true)
    runtime.close(encounter)
end

for _, route in ipairs({'first', 'omote', 'ura'}) do
    local run, boss = startBoss(route)
    boss.parts[1].damage(boss.parts[1], boss.hp - 0x15f00)
    local sawFormation, sawFormationFire = false, false
    for _ = 1, 4000 do
        runtime.boss1.step(boss)
        runtime.bullets.step(run)
        assert(not boss.untranslatedEvent)
        for _, child in pairs(boss.pods) do
            if child.kind == 0x71 and child.colli then
                sawFormation = true
                if child.mode == 0x1c and boss.formation.fire > 0 then sawFormationFire = true end
            end
        end
        if sawFormationFire then break end
    end
    equal(sawFormation, true)
    equal(sawFormationFire, true)
    runtime.close(run)
end

for _, route in ipairs({'first', 'omote', 'ura'}) do
    local run = runtime.init(4, route)
    local pilot = {x=0,y=-180,respawn=0,protect=200}
    local mid, seen = nil, {}
    for _ = 1, 16000 do
        runtime.step(run, pilot)
        if run.mid4 then
            mid = run.mid4
            for _, bullet in pairs(run.bullets) do seen[bullet.kind] = true end
        elseif mid and run.major >= 0x129 then
            break
        end
    end
    equal(mid.cycles, 3)
    equal(mid.retire, true)
    equal(run.major, 0x129)
    equal(seen[0x28], true)
    equal(seen[0x23], true)
    equal(seen[0x16], true)
    runtime.close(run)
end

-- 六个炮口共用舱门节拍，二周目从同一发射入口改变速度。
for _, route in ipairs({'first', 'omote', 'ura'}) do
    for _, kind in ipairs({0x27, 0x28, 0x29}) do
        local run = runtime.init(kind == 0x27 and 5 or 1,route)
        run.pilotH, run.pilotL = 0xde4, 0x0f80
        local row
        for _, candidate in ipairs(run.stage.spawns) do
            if candidate[3] == kind then row = candidate; break end
        end
        local o = assert(runtime.enemies.spawn(run, row))
        if kind == 0x27 then equal(o.hp,0x1000) end
        o.h, o.l, run.scrollStep = 0x4500, 0x1c00, 0
        o.path, o.cursor, o.elapsed = string.char(0x40, 0), 1, 0
        for _ = 1, 120 do
            runtime.enemies.step(run)
            if next(run.bullets) then break end
        end
        equal(o.hatch, 7)
        equal(#run.bullets, 6)
        for _, shot in pairs(run.bullets) do
            equal(shot.kind, 7)
            equal(shot.speed, program.bulletSpeed(run, 7, route == 'first' and 2 or 6))
        end
        local shot = {h=o.h, l=o.l, front=0, back=0, right=0, left=0, damage=o.hp + 0x800}
        equal(runtime.playerShot(run, shot), o)
        runtime.enemies.step(run)
        equal(IsValid(o), false)
        assert(next(run.effects))
        runtime.close(run)
    end
end

for _, route in ipairs({'first', 'omote', 'ura'}) do
    local run = runtime.init(5, route)
    local pilot = {x=0,y=-180,respawn=0,protect=200}
    local mid
    for _ = 1, 18000 do
        runtime.step(run, pilot)
        mid = run.mid5 or mid
        if mid and mid.retire then break end
    end
    assert(mid and mid.retreating and mid.retire)
    equal(run.mid5, nil)
    for _, part in ipairs(mid.parts) do equal(IsValid(part), false) end
    runtime.close(run)
end

for _, route in ipairs({'first', 'omote', 'ura'}) do
    local run = runtime.init(3, route)
    local input = {x=0,y=-180,respawn=0,protect=200}
    local transport
    for _, row in ipairs(run.stage.spawns) do
        if row[3] == (route == 'ura' and 0x2b or 0x2a) then
            transport = runtime.enemies.spawn(run, row)
            break
        end
    end
    assert(transport, '未从路径表生成运输机')
    run.spawnIndex = #run.stage.spawns + 1
    local first
    for _ = 1, 500 do
        runtime.step(run, input)
        if run.bullets[1] then first = run.bullets[1]; break end
    end
    assert(first, '运输机未调用三向发射')
    equal(first.kind, 6)
    equal(first.speed, route == 'first' and 20 or route == 'omote' and 25 or 27)
    transport.damage(transport, transport.hp + 1, 'shot')
    runtime.step(run, input)
    equal(IsValid(transport), false)
    assert(run.effects[1], '运输机应登记击破动画')
    runtime.close(run)
end

for _, route in ipairs({'first', 'omote', 'ura'}) do
    local run = runtime.init(2, route)
    local pilot = {x=0,y=-180,respawn=0,protect=200}
    for _ = 1, 18000 do
        runtime.step(run, pilot)
        if run.mid2 then
            for _, part in ipairs(run.mid2.parts) do
                if part.colli then part.damage(part, part.hp + 1) end
            end
        end
        if run.boss2 then break end
    end
    local boss = assert(run.boss2, '二面关底未按生成表登记')
    local seen, children = {}, {}
    local function step()
        runtime.step(run, pilot)
        for _, shot in pairs(run.bullets) do seen[shot.kind] = true end
        for _, child in pairs(boss.children) do children[child.kind] = true end
    end
    for _ = 1, 1100 do step() end
    equal(seen[3], true)
    equal(seen[9], true)
    equal(boss.parts[1].colli, false)
    assert(boss.parts[2].colli)
    local cover = boss.parts[2]
    local hp = boss.hp
    equal(runtime.playerShot(run, {h=cover.h,l=cover.l,front=0x80,back=0x100,right=0x80,left=0x80,
        damage=0x400}), cover)
    step()
    equal(boss.hp, hp - 0x300)
    equal(cover.hp, 0x11b00)
    local outer = boss.parts[3]
    outer.damage(outer, outer.hp + 1)
    step()
    equal(outer.broken, true)
    equal(boss.phase, 0)
    for _ = 1, 5000 do
        step()
        if seen[0xb] and seen[0x13] and seen[0x14] and children[0x93] then break end
    end
    equal(seen[0xb], true)
    equal(seen[0x13], true)
    equal(seen[0x14], true)
    equal(children[0x93], true)
    local sideCannon=boss.parts[5]
    equal(sideCannon.colli,true)
    sideCannon.damage(sideCannon,sideCannon.hp+1)
    step()
    equal(sideCannon.broken,true)
    equal(boss.phase,0)
    equal(boss.kickAngle,0x40)
    cover.damage(cover, cover.hp + 1)
    step()
    equal(boss.phase, 1)
    equal(cover.broken, true)
    equal(boss.parts[5].broken, true)
    equal(boss.parts[6].broken, true)
    equal(boss.parts[1].colli, false)
    for _ = 1, 4000 do
        step()
        if seen[0xd] and children[0x94] then break end
    end
    equal(boss.parts[1].colli, true)
    equal(seen[0xd], true)
    equal(children[0x94], true)
    hp = boss.hp
    boss.parts[1].damage(boss.parts[1], 0x2000)
    boss.parts[7].damage(boss.parts[7], 0x3000)
    step()
    equal(boss.hp, hp - 0x3000)
    boss.parts[7].damage(boss.parts[7], boss.hp + 1)
    step()
    equal(boss.dead, true)
    for _ = 1, 8000 do
        step()
        if run.stageCleared then break end
    end
    equal(run.stageCleared, true)
    equal(run.nextStageNumber, 3)
    equal(run.boss2, nil)
    for _, part in ipairs(boss.parts) do equal(IsValid(part), false) end
    runtime.close(run)
end

for _, route in ipairs({'first', 'omote', 'ura'}) do
    local run = runtime.init(3, route)
    local x, y = program.world(0xde4, 0xf80)
    local pilot = {x=x,y=y,respawn=0,protect=200}
    local seen = {}
    local function waitFor(predicate, limit)
        for _ = 1, limit do
            runtime.step(run, pilot)
            for _, shot in pairs(run.bullets) do seen[shot.kind] = true end
            if predicate() then return end
        end
        error('三面关底未推进到预期状态：' .. route)
    end
    waitFor(function() return run.boss3 ~= nil end, 15000)
    local boss = run.boss3
    waitFor(function()
        if not (seen[0x15] and seen[9] and seen[7] and seen[0x1c]) then return false end
        for _, shot in pairs(run.bullets) do
            if shot.kind == 0x1c and shot.bursts and shot.bursts < 2 then return true end
        end
    end, 3000)
    local cheek = boss.parts[4]
    local shot = {h=cheek.h+cheek.front-0x80,l=cheek.l+cheek.right-0x80,front=0,back=0,right=0,left=0,damage=0x7000}
    equal(runtime.playerShot(run, shot), cheek)
    local hp = boss.hp
    boss.parts[1].damage(boss.parts[1], 0x200)
    boss.parts[3].damage(boss.parts[3], 0x100)
    runtime.step(run, pilot)
    equal(cheek.broken, true)
    equal(boss.hp, hp - 0x200)
    boss.parts[1].damage(boss.parts[1], boss.hp - 0x1ad00)
    waitFor(function() return boss.phase == 1 end, 120)
    waitFor(function() return seen[0x1d] and seen[0x1f] and seen[0xf] end, 3000)
    local rightWing, leftWing = boss.parts[10], boss.parts[11]
    rightWing.damage(rightWing, rightWing.hp + 1)
    runtime.step(run, pilot)
    equal(rightWing.broken, true)
    equal(boss.parts[8].broken, true)
    equal(leftWing.broken, nil)
    leftWing.damage(leftWing, leftWing.hp + 1)
    waitFor(function() return boss.phase == 2 end, 120)
    waitFor(function() return seen[0x1a] and seen[0x18] and seen[0xb] end, 1200)
    local emitters = 0
    for _, slot in pairs(boss.emitters) do if slot.id == 13 then emitters = emitters + 1 end end
    equal(emitters, 16)
    boss.parts[14].damage(boss.parts[14], boss.hp + 1)
    waitFor(function() return run.stageCleared end, 500)
    equal(run.nextStageNumber, 4)
    equal(run.boss3, nil)
    for _, part in ipairs(boss.parts) do equal(IsValid(part), false) end
    runtime.close(run)
end

for _, route in ipairs({'first', 'omote', 'ura'}) do
    local run = runtime.init(4, route)
    local x, y = program.world(0xde4, 0xf80)
    local pilot = {x=x,y=y,respawn=0,protect=200}
    local seen, objects = {}, {}
    local function waitFor(predicate, limit, name)
        for _ = 1, limit do
            if run.mid4 and run.mid4.parts[1].colli then
                local part = run.mid4.parts[1]
                part.damage(part, 0x7fff)
            end
            runtime.step(run,pilot)
            for _, shot in pairs(run.bullets) do seen[shot.kind] = true end
            for _, child in pairs(run.boss4 and run.boss4.children or {}) do objects[child.kind] = true end
            if predicate() then return end
        end
        error('四面关底未到达' .. name .. '（' .. route .. '）')
    end
    waitFor(function() return run.boss4 ~= nil end, 16000, '生成点')
    local boss = run.boss4
    equal(boss.hp, 0x7df00)
    waitFor(function()
        return boss.parts[1].colli and seen[9] and seen[0xc] and seen[0x24] and seen[0x31]
    end, 4600, '第一阶段及母弹派生')
    equal(objects[0x62], true)
    equal(objects[0x7a], true)
    equal(objects[0x7b], true)
    local part = boss.parts[1]
    local shot = {h=part.h,l=part.l,front=0x100,back=0x200,right=0x80,left=0x80,damage=0x400}
    equal(runtime.playerShot(run, shot), part)
    runtime.step(run,pilot)
    equal(boss.hp, 0x7dc00)
    part.damage(part, boss.hp-0x51400)
    local shell
    waitFor(function()
        if boss.phase ~= 1 or not (seen[0xb] and seen[0x2b] and seen[0x2c]) then return false end
        for _, child in pairs(boss.children) do
            if child.kind == 0x60 and child.colli then shell = child; return true end
        end
    end, 4600, '第二阶段及贴边派生')
    equal(boss.parts[1].colli, false)
    equal(boss.parts[2].colli, true)
    equal(objects[0x7c], true)
    equal(objects[0x7d], true)
    shell.damage(shell, shell.hp + 1)
    runtime.step(run, pilot)
    equal(IsValid(shell), false)
    equal(boss.hp, 0x51400)
    boss.parts[2].damage(boss.parts[2],boss.hp-0x1a000)
    waitFor(function()
        return boss.phase == 2 and boss.orbitsReady and seen[0x17] and seen[0x2f] and seen[0x30]
    end, 2200, '第三阶段及回旋派生')
    equal(objects[0x61], true)
    equal(boss.parts[2].colli, false)
    equal(boss.parts[3].colli, true)
    boss.parts[3].damage(boss.parts[3],boss.hp+1)
    waitFor(function() return run.stageCleared end, 500, '退场')
    equal(run.nextStageNumber, 5)
    equal(run.boss4, nil)
    for _, part in ipairs(boss.parts) do equal(IsValid(part), false) end
    runtime.close(run)
end

for _, route in ipairs({'first', 'omote', 'ura'}) do
    local run = runtime.init(5, route)
    local x, y = program.world(0xde4, 0xf80)
    local pilot = {x=x, y=y, respawn=0, protect=200}
    local seen = {}
    local function waitFor(predicate, limit, name)
        for _ = 1, limit do
            local mid = run.mid5
            if mid and mid.parts[1].colli then mid.parts[1].damage(mid.parts[1], 0x60000) end
            runtime.step(run, pilot)
            for _, shot in pairs(run.bullets) do seen[shot.kind] = true end
            if predicate() then return end
        end
        error('五面关底未到达' .. name .. '（' .. route .. '）')
    end
    waitFor(function() return run.boss5 ~= nil end, 18000, '生成点')
    local boss = run.boss5
    equal(boss.hp, route == 'ura' and 0x61800 or 0x75d00)
    waitFor(function() return seen[1] and seen[0xb] and boss.parts[1].colli end, 1900, '第一阶段')
    local hull, cannon = boss.parts[1], boss.parts[7]
    local hp = boss.hp
    local hit = runtime.playerShot(run, {h=hull.h, l=hull.l, front=0, back=0, right=0, left=0, damage=0x400})
    assert(hit and hit.host == boss)
    runtime.step(run, pilot)
    equal(boss.hp, hp - 0x300)
    hp = boss.hp
    hull.damage(hull, 0x200)
    cannon.damage(cannon, 0x300)
    runtime.step(run, pilot)
    equal(boss.hp, hp - 0x300)
    hull.damage(hull, boss.hp - (route == 'ura' and 0x2a400 or 0x3e900))
    runtime.step(run, pilot)
    assert(cannon.broken and boss.parts[8].broken and boss.locked)
    waitFor(function()
        return boss.phase == 1 and boss.parts[2].colli and boss.arms and seen[0xc]
    end, 3300, '第二阶段的旋转炮')
    equal(#boss.arms, 2)
    local core = boss.parts[2]
    core.damage(core, boss.hp - (route == 'ura' and 0 or 0x14500))
    runtime.step(run, pilot)
    for i = 9, 12 do equal(boss.parts[i].broken, true) end
    if route ~= 'ura' then
        waitFor(function() return boss.phase == 2 and boss.parts[3].colli end, 1300, '第三阶段')
        waitFor(function()
            for _, child in pairs(boss.children) do
                if child.kind == 0x65 or child.kind == 0x66 then return true end
            end
        end, 2500, '旋转炮分出的子机')
        boss.parts[3].damage(boss.parts[3], boss.hp)
    else
        waitFor(function()
            return boss.phase == 3 and boss.parts[4].colli and not boss.locked and seen[0x40]
        end, 3900, '后半场与独立弹体')
        equal(boss.hp, -1)
        equal(boss.reserve, 0x83380)
        equal(boss.parts[3].colli, false)
        boss.parts[4].damage(boss.parts[4], boss.reserve - 0x4ed00)
        waitFor(function()
            return boss.phase == 4 and not boss.locked and boss.children[16]
                and boss.children[1] and boss.children[1].colli
        end, 4000, '子机编队')
        local drone = boss.children[1]
        equal(runtime.playerShot(run, {h=drone.h, l=drone.l, front=0, back=0, right=0, left=0, damage=0x400}), drone)
        drone.damage(drone, drone.hp + 1)
        runtime.step(run, pilot)
        equal(IsValid(drone), true)
        equal(drone.flash, true)
        equal(drone.hp, 0x7fff)
        equal(boss.reserve, 0x4ed00)
        boss.parts[5].damage(boss.parts[5], boss.reserve - 0x2be00)
        waitFor(function()
            return boss.phase == 5 and not boss.locked and not next(boss.children) and seen[0x48]
        end, 4000, '最终阶段')
        equal(IsValid(drone), false)
        boss.parts[6].damage(boss.parts[6], boss.reserve)
    end
    waitFor(function() return run.campaignCleared end, 1300, '退场')
    equal(run.boss5, nil)
    equal(run.nextStageNumber, nil)
    equal(IsValid(boss), false)
    for _, part in ipairs(boss.parts) do equal(IsValid(part), false) end
    runtime.close(run)
end

for _, route in ipairs({'first', 'omote', 'ura'}) do
    local run = runtime.init(5,route)
    run.pilotH, run.pilotL = 0xde4, 0x0f80
    local row
    for _, candidate in ipairs(run.stage.spawns) do
        if candidate[3] == 0x9d then row = candidate; break end
    end
    local o = assert(runtime.enemies.spawn(run,row))
    o.h, o.l, run.scrollStep = 0x4500, 0x1c00, 0
    o.path, o.cursor, o.elapsed = string.char(0x40,0), 1, 0
    local function hitAtCannon()
        local hit = runtime.playerShot(run, {h=o.h,l=o.l,front=0,back=0,right=0,left=0,damage=0xf000})
        equal(hit,o)
    end
    runtime.enemies.step(run)
    equal(o.hp,0x7fff)
    hitAtCannon()
    runtime.enemies.step(run)
    equal(o.hp,0x7fff)
    for _ = 3, 31 do
        runtime.enemies.step(run)
        if _ == 25 then equal(#run.bullets,4) end
        if _ == 28 then equal(#run.bullets,6) end
    end
    equal(o.hp,0x1400)
    equal(#run.bullets,10)
    for _, shot in pairs(run.bullets) do equal(shot.kind,0x17) end
    hitAtCannon()
    runtime.enemies.step(run)
    equal(IsValid(o),false)
    assert(next(run.effects))
    runtime.close(run)
end

-- 0xd7d52 取两门炮的最大一笔伤害。先拆炮，再由剩余血量结算车体。
for _, stage in ipairs({1,3}) do
    local row
    for _, candidate in ipairs(program.stages[stage].spawns) do
        if candidate[3] == 0x26 then row = candidate; break end
    end
    for _, route in ipairs({'first','omote','ura'}) do
        local run = runtime.init(stage,route)
        run.pilotH,run.pilotL = 0xde4,0xf80
        local tank = assert(runtime.enemies.spawn(run,row))
        tank.h,tank.l = 0x4600,0x1c00
        tank.path,tank.cursor,tank.elapsed = string.char(0x40,0),1,0
        local hullHp = stage == 3 and 0xa80 or 0x980
        local weak = stage == 3 and 0x600 or 0x500
        equal(tank.hp,hullHp)
        local hatch,left,right = unpack(tank.attachments)
        local fan,aimed = false,false
        for frame = 1,160 do
            run.frame = frame
            runtime.enemies.step(run)
            for _, shot in pairs(run.bullets) do
                if shot.kind == 2 then fan = true end
                if shot.kind == 0xc then aimed = true end
            end
            if fan and aimed then break end
        end
        assert(fan and aimed)
        equal(tank.hatch,7)
        equal(left.flags,0xa101)
        local hit = runtime.playerShot(run,{
            h=tank.h-0x600,l=tank.l-0x600,front=0,back=0,left=0,right=0,damage=0x400,
        })
        equal(hit,left)
        right.damage(right,0x400)
        runtime.enemies.step(run)
        equal(tank.hp,hullHp-0x400)
        equal(left.hp,0x7fff)
        equal(right.hp,0x7fff)
        right.damage(right,tank.hp-weak)
        runtime.enemies.step(run)
        equal(tank.hp,weak)
        assert(left.broken and right.broken and not tank.deleted)
        tank.damage(tank,weak+1)
        runtime.enemies.step(run)
        equal(IsValid(tank),false)
        equal(IsValid(hatch),false)
        equal(IsValid(left),false)
        equal(IsValid(right),false)
        runtime.close(run)
    end
end

for _, stage in ipairs({3,5}) do
    local row
    for _, candidate in ipairs(program.stages[stage].spawns) do
        if candidate[3] == 0x52 then row = candidate; break end
    end
    for _, route in ipairs({'first','omote','ura'}) do
        local run = runtime.init(stage,route)
        run.pilotH,run.pilotL = 0xde4,0xf80
        local plane = assert(runtime.enemies.spawn(run,row))
        plane.h,plane.l = 0x4600,0x1c00
        plane.path,plane.cursor,plane.elapsed = string.char(0x40,0),1,0
        local hullHp = stage == 5 and 0x1300 or 0x1000
        local weak = stage == 5 and 0x800 or 0x700
        equal(plane.aircraftHp,hullHp)
        local rear = plane.attachments[1]
        local belly,turret = false,false
        for frame = 1,60 do
            run.frame = frame
            runtime.enemies.step(run)
            for _, shot in pairs(run.bullets) do
                if shot.kind == 0x16 then belly = true end
                if shot.kind == 6 then turret = true end
            end
            if belly and turret then break end
        end
        assert(belly and turret)
        local function hitRear()
            equal(runtime.playerShot(run,{
                h=plane.h+0x600,l=plane.l,front=0,back=0,left=0,right=0,damage=0x400,
            }),rear)
        end
        assert(plane.armorClock > 0)
        hitRear()
        runtime.enemies.step(run)
        equal(plane.aircraftHp,hullHp)
        for _=1,plane.armorClock do runtime.enemies.step(run) end
        hitRear()
        plane.damage(plane,0x200)
        runtime.enemies.step(run)
        equal(plane.aircraftHp,hullHp-0x300)
        equal(rear.hp,0x7fff)
        rear.damage(rear,plane.aircraftHp-weak)
        runtime.enemies.step(run)
        equal(plane.aircraftHp,weak)
        equal(plane.brokenTurrets,true)
        runtime.bullets.clear(run,true)
        for _=1,100 do runtime.enemies.step(run) end
        assert(next(run.bullets))
        for _, shot in pairs(run.bullets) do equal(shot.kind,0x16) end
        rear.damage(rear,plane.aircraftHp+1)
        runtime.enemies.step(run)
        equal(IsValid(plane),false)
        equal(IsValid(rear),false)
        assert(next(run.effects))
        runtime.close(run)
    end
end

do
    local run = runtime.init(1,'first')
    local pilot = runtime.addPlayer(run,1,{keys={},life=2,level=5,protect=0})
    local descriptor = program.bullet[10]
    local flash = program.flash[descriptor[4]+1][1]
    local bullet = runtime.bullets.emitDirect(run,9,-descriptor[3],0,
        pilot.h-math.floor(flash[2]/2),pilot.l-math.floor(flash[1]/2))
    for _=1,10 do
        runtime.step(run)
        if run.playerHit then break end
    end
    equal(run.playerHit,bullet)
    equal(pilot.respawn,0)
    runtime.step(run)
    equal(pilot.respawn,66)
    equal(pilot.life,2)
    equal(pilot.level,1)
    for i=1,4 do equal(run.itemSlots[i].kind,0) end
    equal(run.itemSlots[5],nil)
    equal(#program.player.death,32)
    for _=1,63 do runtime.step(run) end
    equal(pilot.life,2)
    equal(pilot.respawn,3)
    runtime.step(run)
    equal(pilot.life,1)
    equal(pilot.respawn,2)
    equal(run.missShotDelay,0x78)
    runtime.step(run)
    runtime.step(run)
    equal(pilot.respawn,0)
    equal(pilot.h,0x1000)
    equal(pilot.l,0xe00)
    equal(pilot.protect,0xf0)
    equal(run.missShotDelay,0x76)
    runtime.close(run)
end

-- 三段机身的偏置判定、炮位换段和舱口弹的时钟由不同的 ROM 回调负责。
do
    local rows = {}
    for _, row in ipairs(program.stages[3].spawns) do
        if program.tripleAircraft[row[3]] then rows[row[3]] = rows[row[3]] or row end
    end
    local variants = {
        {kind=0x4e,hp=0x1c00,weak=0x1000,dh=-0x800,dl=0x800},
        {kind=0x50,hp=0x2e00,weak=0x1a00,dh=0,dl=0x1100},
        {kind=0x51,hp=0x4c00,weak=0x2200,dh=0x400,dl=0x1100},
    }
    for _, route in ipairs({'first','omote','ura'}) do
        for _, variant in ipairs(variants) do
            local kind = variant.kind
            local run = runtime.init(3,route)
            run.minor = kind == 0x51 and 0x6c or route == 'first' and 0 or 0x13
            run.pilotH,run.pilotL,run.fullDamage = 0x1000,0x1c00,true
            if kind == 0x4e then
                run.mid3,run.minor = {},0x48
                local suppressed = runtime.enemies.spawn(run,rows[kind])
                equal(suppressed.active,false)
                equal(run.enemies[suppressed.slot],nil)
                run.mid3,run.minor = nil,route == 'first' and 0 or 0x13
            end
            local plane = runtime.enemies.spawn(run,rows[kind])
            equal(plane.aircraftHp,variant.hp)
            equal(plane.damageAt,variant.weak)
            plane.h,plane.l = 0x4000,0x1c00
            plane.path,plane.cursor,plane.elapsed = string.char(0x40,0),1,0
            local function step(frames)
                for _ = 1, frames do
                    run.frame = run.frame + 1
                    runtime.enemies.step(run)
                end
            end
            step(28)
            local fan = {}
            for _, bullet in ipairs(run.bullets) do fan[#fan+1] = bullet end
            equal(#fan,route == 'first' and 5 or 10)
            for i, bullet in ipairs(fan) do
                local ray = math.floor((i-1)/(route == 'first' and 1 or 2))
                local modifier = ray%2 == 0 and -3 or -2
                equal(bullet.kind,7)
                equal(bullet.speed,program.bulletSpeed(run,7,modifier))
            end
            step(37)
            local direct = 0
            for _, bullet in ipairs(run.bullets) do
                if bullet.kind == 0xc then direct = direct+1 end
            end
            assert(direct >= 6)

            local side,tail = unpack(plane.attachments)
            local shot = {h=plane.h+variant.dh,l=plane.l+variant.dl,front=0x20,back=0x40,right=0x20,left=0x20,
                damage=0x300}
            equal(runtime.enemies.touch(run,shot.h,shot.l,shot.front,shot.back,shot.right,shot.left,1),nil)
            equal(runtime.playerShot(run,shot),side)
            tail.damage(tail,0x100)
            run.freeze = true
            step(1)
            run.freeze = false
            equal(plane.aircraftHp,variant.hp-0x300)
            equal(side.hp,0x7fff)
            equal(tail.hp,0x7fff)
            plane.damage(plane,plane.aircraftHp-plane.damageAt)
            step(1)
            equal(plane.brokenTurrets,true)
            runtime.bullets.clear(run,true)
            for _ = 1, 31 do
                step(1)
                if next(run.bullets) then break end
            end
            equal(plane.state[0x35],0x1c)
            equal(#run.bullets,kind == 0x4e and route ~= 'first' and 5 or 9)
            local projectile = run.bullets[1]
            equal(projectile.kind,0x12)
            equal(projectile.speedLimit,0x18)
            local expectedSpeed = projectile.speed
            for _ = 1, 9 do runtime.bullets.step(run) end
            equal(projectile.speed,expectedSpeed)
            runtime.bullets.step(run)
            equal(projectile.speed,expectedSpeed+1)
            tail.damage(tail,plane.aircraftHp+1)
            step(1)
            equal(IsValid(plane),false)
            equal(IsValid(side),false)
            equal(IsValid(tail),false)
            assert(next(run.effects))
            runtime.close(run)
        end
    end
end

-- 双舱飞机的中炮、两侧炮位与坠毁使用三个独立计数。
for _, route in ipairs({'first','omote','ura'}) do
    local run = runtime.init(2,route)
    run.major = 0x1d0
    run.pilotH,run.pilotL,run.fullDamage = 0x1000,0x1c00,true
    local row
    for _, candidate in ipairs(run.stage.spawns) do
        if candidate[3] == 0x42 then row = candidate; break end
    end
    local plane = runtime.enemies.spawn(run,row)
    local rejected = runtime.enemies.spawn(run,row)
    equal(plane.aircraftHp,0x2500)
    equal(rejected.active,false)
    equal(run.enemies[rejected.slot],nil)
    equal(plane.state[0x24],route == 'first' and 3 or 6)
    plane.h,plane.l = 0x4000,0x1c00
    plane.path,plane.cursor,plane.elapsed = string.char(0x40,0),1,0
    local function step(frames)
        for _ = 1, frames do
            run.frame = run.frame+1
            runtime.enemies.step(run)
        end
    end
    plane.state[0x28] = 0xf0
    step(plane.state[0x22]+1)
    equal(#run.bullets,7)
    for i, bullet in ipairs(run.bullets) do
        equal(bullet.kind,7)
        equal(bullet.angle,(plane.state[0x20]*4+(i-4)*12)%256)
        equal(bullet.speed,program.bulletSpeed(run,7,4))
    end
    runtime.bullets.clear(run,true)
    plane.state[0x28],plane.state[0x2a] = 0,0
    step(1)
    equal(#run.bullets,route == 'first' and 4 or 12)
    for _, bullet in ipairs(run.bullets) do equal(bullet.kind,0x18) end
    plane.part[0x1e] = 1
    step(16)
    equal(plane.state[0x1e],2)
    plane.part[0x1e] = 0
    step(12)
    equal(plane.state[0x1e],0)

    local wing = plane.attachments[1]
    local shot = {h=wing.h,l=wing.l+0x800,front=0x20,back=0x40,right=0x20,left=0x20,damage=0x200}
    equal(runtime.enemies.touch(run,shot.h,shot.l,shot.front,shot.back,shot.right,shot.left,1),wing)
    step(1)
    equal(plane.aircraftHp,0x24ff)
    equal(runtime.playerShot(run,shot),wing)
    plane.damage(plane,0x100)
    step(1)
    equal(plane.aircraftHp,0x22ff)
    wing.damage(wing,plane.aircraftHp)
    step(1)
    equal(plane.aircraftHp,0)
    equal(plane.crashing,nil)
    wing.damage(wing,1)
    step(1)
    equal(plane.crashing,true)
    equal(run.patrol42Block,nil)
    equal(plane.flags,0x8000)
    equal(wing.flags,0x8000)
    local h = plane.h
    step(15)
    equal(plane.h,h-15*0x20)
    equal(IsValid(plane),true)
    step(1)
    equal(IsValid(plane),false)
    equal(IsValid(wing),false)
    assert(next(run.effects))
    runtime.close(run)
end

-- 五面装甲炮的两个有符号外伸碰撞框不能从生成路径拆开。
for _, route in ipairs({'first','omote','ura'}) do
    local run = runtime.init(5, route)
    run.pilotH, run.pilotL, run.fullDamage = 0x1000, 0x1c00, true
    local row
    for _, candidate in ipairs(run.stage.spawns) do
        if candidate[3] == 0x98 then row = candidate; break end
    end
    local cannon = runtime.enemies.spawn(run, assert(row))
    cannon.h, cannon.l = 0x4000, 0x1c00
    cannon.path, cannon.cursor, cannon.elapsed = string.char(0,0), 1, 0
    cannon.speed, cannon.newVelocity = 0, true
    local wing, otherWing = cannon.attachments[1], cannon.attachments[2]
    local function step(frames)
        for _ = 1, frames do
            run.frame = run.frame + 1
            runtime.enemies.step(run)
        end
    end
    local function fire(amount)
        equal(runtime.playerShot(run,{h=wing.h,l=wing.l+0x900,front=0,back=0,right=0,left=0,damage=amount}),wing)
    end
    step(9)
    equal(cannon.lift, 12)
    equal(cannon.state[0x18],4)
    equal(cannon.armor,8)
    equal(cannon.vehicleHp,0x1400)
    equal(runtime.enemies.touch(run, wing.h, wing.l + 0x900, 0, 0, 0, 0, 1), wing)
    fire(0x100)
    step(1)
    equal(cannon.armor,8)
    equal(cannon.vehicleHp,0x7fff)
    equal(wing.hp,0x7fff)
    cannon.part[0x1e] = 1
    step(8)
    equal(cannon.lift,0)
    equal(cannon.state[0x26],4)
    for remaining = 7, 0, -1 do
        fire(0x100)
        step(1)
        equal(cannon.armor,remaining)
    end
    equal(cannon.vehicleHp,0x1400)
    equal(wing.hp,0x7eff)
    fire(0x100)
    otherWing.damage(otherWing,0x180)
    step(1)
    equal(cannon.vehicleHp,0x1200)
    equal(wing.hp,0x7fff)
    equal(otherWing.hp,0x7fff)

    step(14)
    equal(cannon.state[0x18],6)
    equal(#run.bullets,10)
    for i, bullet in ipairs(run.bullets) do
        local relative = (i - 1) % 5 + 1
        local muzzle = (i <= 5 and program.ground98.leftFire or program.ground98.rightFire)[relative]
        local modifier = relative <= 2 and 5 or 6
        local kind = relative <= 2 and 0xc or 0x16
        equal(bullet.kind,kind)
        equal(bullet.h,cannon.h+muzzle[1])
        equal(bullet.l,cannon.l+muzzle[2])
        equal(bullet.speed,program.bulletSpeed(run,kind,modifier+4*run.route.loop))
        if relative > 2 then equal(bullet.angle,0x80+(relative-4)*(i <= 5 and -16 or 16)) end
    end
    run.bulletHold = true
    local clock = cannon.state[0x26]
    step(5)
    equal(cannon.state[0x26],clock)
    run.bulletHold = nil
    runtime.bullets.clear(run,true)

    fire(cannon.vehicleHp-0x800)
    step(1)
    equal(cannon.vehicleHp,0x800)
    equal(wing.broken,nil)
    fire(1)
    step(1)
    equal(cannon.vehicleHp,0x7ff)
    equal(cannon.state[0x18],0)
    equal(wing.broken,true)
    equal(otherWing.broken,true)
    equal(#run.effects,4)
    equal(wing.flags,0xa101)
    for _ = 1, 32 do
        if #run.bullets == 5 then break end
        step(1)
    end
    equal(#run.bullets,5)
    for i, bullet in ipairs(run.bullets) do
        equal(bullet.kind,7)
        equal(bullet.angle,0x80+(i-3)*7)
        equal(bullet.speed,program.bulletSpeed(run,7,4))
    end
    fire(cannon.vehicleHp)
    step(1)
    equal(cannon.vehicleHp,0)
    equal(IsValid(cannon),true)
    fire(1)
    step(1)
    equal(IsValid(cannon),false)
    for _, part in ipairs(cannon.attachments) do equal(IsValid(part),false) end
    equal(#run.effects,10)
    runtime.close(run)
end

-- 四、五面大型载具的破损状态不变更车体判定，舱口换段后才切换两侧发射。
for _, route in ipairs({'first','omote','ura'}) do
    for stage = 4, 5 do
        local run = runtime.init(stage, route)
        local kind = stage == 4 and 0x2f or 0x40
        run.major, run.pilotH, run.pilotL, run.fullDamage = 0x16c, 0x1000, 0x1c00, true
        local row
        for _, candidate in ipairs(run.stage.spawns) do
            if candidate[3] == kind and (stage == 5 or candidate[1] == 0x16c) then row = candidate; break end
        end
        local vehicle = runtime.enemies.spawn(run, assert(row))
        vehicle.h, vehicle.l = 0x4000, 0x1c00
        vehicle.path, vehicle.cursor, vehicle.elapsed = string.char(0x40,0), 1, 0
        local function step()
            run.frame = run.frame + 1
            runtime.enemies.step(run)
        end
        local function fire(amount)
            equal(runtime.playerShot(run,{h=vehicle.h,l=vehicle.l,front=0,back=0,left=0,right=0,damage=amount}),vehicle)
            step()
        end
        equal(vehicle.vehicleHp,0x8c00)
        equal(vehicle.hp,0x7fff)
        equal(run.largeVehicleLock,vehicle)
        if stage == 5 then
            for _, candidate in ipairs(run.stage.spawns) do
                if candidate[3] == 0x98 then
                    local rejected = runtime.enemies.spawn(run, candidate)
                    equal(rejected.active,false)
                    equal(run.enemies[rejected.slot],nil)
                    break
                end
            end
        else
            equal(run.capacity,110)
            equal(program.word(vehicle.state,0x3c),9)
        end

        vehicle.state[0x24], vehicle.state[0x26] = 0, 0
        step()
        local firstWave = (stage == 4 and 5 or 9) * (run.route.loop + 1)
        equal(#run.bullets,firstWave)
        for i, bullet in ipairs(run.bullets) do
            equal(bullet.kind,3)
            local extra = run.route.loop == 1 and i % 2 == 0 and 6 or 0
            equal(bullet.speed,program.bulletSpeed(run,3,(stage == 4 and 4 or 1)+extra))
        end
        runtime.bullets.clear(run,true)
        vehicle.state[0x26] = 0
        step()
        equal(#run.bullets, stage == 4 and 8 or 12)
        for _, bullet in ipairs(run.bullets) do equal(bullet.kind,2) end
        runtime.bullets.clear(run,true)

        fire(vehicle.vehicleHp-0x3400)
        equal(vehicle.vehicleHp,0x3400)
        equal(vehicle.weakened,true)
        equal(vehicle.flags,0xa100)
        equal(#run.effects,3)
        for _ = 1, 64 do
            if #run.bullets > 0 then break end
            step()
        end
        equal(vehicle.hullFrame,7)
        equal(#run.bullets,stage == 4 and 10 or 14)
        equal(run.bullets[1].kind,8)
        equal(run.bullets[1].speed,program.bulletSpeed(run,8,-1+4*run.route.loop))
        fire(0x3400)
        equal(vehicle.vehicleHp,0)
        equal(IsValid(vehicle),true)
        fire(1)
        equal(IsValid(vehicle),false)
        equal(run.largeVehicleLock,nil)
        equal(#run.effects,9)
        runtime.close(run)
    end
end

-- 0xe3e52 的两处命中框、击破清弹和占位必须等同一艘载具退场才释放。
for _, route in ipairs({'first','omote','ura'}) do
    for stage = 4, 5 do
        local run = runtime.init(stage, route)
        run.pilotH, run.pilotL, run.fullDamage = 0x1000, 0x1c00, true
        local row
        for _, candidate in ipairs(run.stage.spawns) do
            if candidate[3] == 0x59 then row = candidate; break end
        end
        run.major = row[1]
        local vehicle = runtime.enemies.spawn(run, row)
        local side = vehicle.attachments[1]
        vehicle.h, vehicle.l = 0x4000, 0x1c00
        vehicle.path, vehicle.cursor, vehicle.elapsed = string.char(0x40,0), 1, 0
        local function step()
            run.frame = run.frame + 1
            runtime.enemies.step(run)
        end
        local function fire(amount)
            equal(runtime.playerShot(run,{h=side.h,l=side.l+0xa00,front=0,back=0,left=0,right=0,damage=amount}),side)
            step()
        end
        equal(vehicle.vehicleHp,0xb600)
        equal(vehicle.breakAt,0x6200)
        equal(run.capacity,150)
        equal(run.ground59Locks[1],vehicle)
        vehicle.state[0x28] = 0
        step()
        local firstVolley = stage == 4 and 2 or 4
        local sideVolley = stage == 4 and 16 or 48
        equal(#run.bullets,firstVolley+sideVolley*(run.route.loop+1))
        for i = 1, firstVolley do equal(run.bullets[i].kind,4) end
        equal(program.word(vehicle.state,0x2c),2)
        runtime.bullets.clear(run,true)

        vehicle.damage(vehicle,0x100)
        fire(0x200)
        equal(vehicle.vehicleHp,0xb400)
        equal(vehicle.hp,0x7fff)
        equal(side.hp,0x7fff)
        fire(vehicle.vehicleHp-vehicle.breakAt)
        equal(vehicle.weakened,true)
        equal(vehicle.state[0x23],0)
        equal(#run.effects,3)
        vehicle.state[0x26], vehicle.state[0x34], vehicle.state[0x36] = 0, 0xfe, 0
        for _ = 1, 16 do
            step()
            if #run.bullets > 0 then break end
        end
        equal(vehicle.state[0x22],1)
        equal(#run.bullets,stage == 4 and 15 or 11+30*(run.route.loop+1))
        equal(run.bullets[1].kind,3)
        fire(vehicle.vehicleHp)
        equal(vehicle.vehicleHp,0)
        equal(vehicle.crashing,nil)
        fire(1)
        equal(vehicle.crashing,true)
        equal(vehicle.flags,0x8000)
        equal(side.flags,0x8000)
        equal(run.bulletClearTime,0x200)
        equal(run.ground59Locks[1],vehicle)
        local h = vehicle.h
        local timer = stage == 4 and 0x20 or 0x50
        for _ = 1, timer-1 do step() end
        equal(IsValid(vehicle),true)
        step()
        equal(vehicle.h,h-0x20*timer)
        equal(IsValid(vehicle),false)
        equal(IsValid(side),false)
        equal(run.ground59Locks[1],nil)
        equal(run.capacity,stage == 4 and 150 or 110)
        equal(run.bulletClearTime,stage == 4 and 0x20 or 0x40)
        equal(#run.effects,17+#(stage == 4 and program.ground59.death4 or program.ground59.death5))
        runtime.close(run)
    end
end

-- 五面两种浮空炮组从同一类型的展开动作进入各自的发射循环。
for _, route in ipairs({'first','omote','ura'}) do
    local run = runtime.init(5, route)
    run.major, run.minor, run.fullDamage = 0x142, 0, true
    run.pilotH, run.pilotL = 0x1000, 0x1c00
    local rows = {}
    for _, row in ipairs(run.stage.spawns) do
        if row[2] == 0 and (row[3] == 0x9a or row[3] == 0x9b) then rows[row[3]] = row end
    end
    local scout = runtime.enemies.spawn(run, rows[0x9a])
    equal(scout.h,0x4280)
    equal(scout.l,program.s16(0xf2e5))
    equal(scout.vehicleHp,0x1600)
    equal(run.hoverGate,true)
    equal(run.capacity,150)
    local function step()
        run.frame=run.frame+1
        runtime.enemies.step(run)
    end
    local function open(gun)
        equal(gun.phase,0)
        equal(bit.band(gun.flags,0xa000),0x8000)
        for _=1,48 do step() end
        equal(gun.phase,0)
        step()
        equal(gun.phase,1)
        equal(gun.flags,0xa100)
        equal(gun.hatchFrame,31)
        for _=1,63 do step() end
        equal(gun.phase,1)
        step()
        equal(gun.phase,2)
        equal(gun.flags,0xa101)
        equal(gun.armor,8)
        equal(#gun.nozzles,4)
    end
    local function shoot(gun, damage)
        equal(runtime.playerShot(run,{h=gun.h,l=gun.l,front=0,back=0,left=0,right=0,damage=damage}),gun)
        step()
    end
    local function volley(gun, baseSpeed)
        runtime.bullets.clear(run,true)
        local positions = {}
        for i,p in ipairs(gun.nozzles) do positions[i] = {p.h,p.l,p.shot} end
        gun.h,gun.l,gun.speed,gun.direction,gun.turnDelay = 0x4000,0x1c00,0,0,0
        gun.aimClock,gun.state[0x20] = 4,0
        step()
        equal(#run.bullets,5)
        local speed = baseSpeed + (gun.kind == 0x9a and 4*run.route.loop or 0)
        for _, bullet in ipairs(run.bullets) do
            equal(bullet.kind,0xa)
            equal(bullet.speed,program.bulletSpeed(run,0xa,speed))
        end
        equal(run.bullets[1].h,0x3e00)
        equal(run.bullets[1].angle,gun.kind == 0x9a and 0x80 or gun.turret*4)
        for i, pos in ipairs(positions) do
            local b = run.bullets[i+1]
            equal(b.h,pos[1]); equal(b.l,pos[2]); equal(b.angle,pos[3]*4%256)
        end
    end

    open(scout)
    volley(scout,10)
    scout.h = 0x7800
    step()
    equal(IsValid(scout),false)
    equal(run.hoverGate,nil)
    for _, p in ipairs(scout.nozzles) do equal(IsValid(p),false) end
    scout = runtime.enemies.spawn(run, rows[0x9a])
    equal(run.hoverGate,true)
    local gun = runtime.enemies.spawn(run, rows[0x9b])
    equal(gun.h,0x3980)
    equal(gun.l,program.s16(0xf3e5))
    equal(gun.vehicleHp,0xe00)
    open(gun)
    scout.h,scout.l,scout.speed,scout.direction,scout.turnDelay = 0x5600,0x3000,0,0,0
    scout.state[0x20] = 0x40
    volley(gun,5)
    run.freeze = true
    for armor=7,0,-1 do
        shoot(gun,0x100)
        equal(gun.armor,armor)
        equal(gun.vehicleHp,0xe00)
    end
    shoot(gun,0xe00)
    equal(gun.vehicleHp,0)
    equal(IsValid(gun),true)
    equal(run.itemSlots[13],nil)
    shoot(gun,1)
    equal(IsValid(gun),false)
    equal(run.hoverGate,true)
    equal(#run.effects,3)
    local drop = assert(run.itemSlots[13])
    equal(drop.h,gun.h)
    equal(drop.l,gun.l)
    equal(runtime.items.spawn(run,12,drop.h,drop.l),nil)
    runtime.bullets.clear(run,true)
    run.spawnIndex = #run.stage.spawns+1
    local pilot = runtime.addPlayer(run,1,{keys={},life=7,h=drop.h,l=drop.l,protect=0})
    run.frame = 1
    runtime.step(run,pilot)
    equal(pilot.life,7)
    equal(drop.collector,pilot)
    runtime.step(run,pilot)
    equal(pilot.life,8)
    equal(pilot.bombs,3)
    equal(pilot.score,100)
    equal(drop.frames,program.lifeDrop.taken)
    for _=1,60 do runtime.items.step(run) end
    equal(IsValid(drop),false)
    equal(run.itemSlots[13],nil)
    drop=assert(runtime.items.spawn(run,12,pilot.h,pilot.l))
    runtime.items.step(run)
    runtime.items.contact(run,pilot,pilot.h,pilot.l,pilot.front,pilot.back,pilot.right,pilot.left)
    runtime.items.step(run)
    equal(pilot.life,8)
    equal(pilot.score,10100)
    equal(drop.frames,program.lifeDrop.full)
    runtime.close(run)
    equal(IsValid(drop),false)
end

-- 0xf4b30 的火力与炸弹各占自己的槽，0xfd048 的第二次增机门槛跨面保留。
do
    local run = runtime.init(1,'first')
    local pilot = runtime.addPlayer(run,1,{keys={},bombs=5,score=19999900})
    equal(pilot.life,2)
    run.freeze = true
    local function pickup(kind)
        local h, l = pilot.h, pilot.l
        local drop = assert(runtime.items.spawn(run,kind,h,l))
        runtime.items.step(run)
        runtime.items.contact(run,pilot,h,l,pilot.front,pilot.back,pilot.right,pilot.left)
        runtime.items.step(run)
        return drop
    end
    equal(pickup(0).slot,1)
    equal(pilot.level,2)
    equal(pilot.score,20000000)
    runtime.score.step(pilot)
    equal(pilot.life,3)
    equal(pilot.extends,1)
    equal(pickup(4).slot,9)
    equal(pilot.level,5)
    equal(pickup(8).slot,11)
    equal(pilot.bombs,6)
    equal(pickup(8).frames,program.lifeDrop.full)
    equal(pilot.score,20010200)
    local stock = runtime.playerStock(run)
    runtime.close(run)
    run = runtime.init(2,'first')
    pilot = runtime.addPlayer(run,1,stock)
    runtime.score.step(pilot)
    equal(pilot.life,3)
    runtime.score.add(pilot,45000000 - pilot.score)
    runtime.score.step(pilot)
    equal(pilot.extends,2)
    equal(pilot.life,4)
    runtime.close(run)
end

-- 0xd08fc 的速射击破通过自机弹相撞产生筹码，0xf5982 才把拾取结算进倍率。
do
    local run = runtime.init(1,'first')
    run.spawnIndex, run.freeze = #run.stage.spawns + 1, true
    local pilot = runtime.addPlayer(run,1,{keys={shoot=true},h=0x1000,l=0x1c00,protect=0})
    local target
    for _, row in ipairs(run.stage.spawns) do
        if row[10] == 0xd08d2 then target = runtime.enemies.spawn(run,row); break end
    end
    target.h, target.l = 0x1d00, pilot.l
    for _=1,20 do
        runtime.step(run)
        if not IsValid(target) then break end
    end
    equal(IsValid(target),false)
    equal(pilot.score,0xa0)
    local chip = assert(run.chips[1])
    equal(chip.kind,5)
    equal(run.stageMultiplier,1)
    runtime.chips.contact(run,chip.h,chip.l,pilot.front,pilot.back,pilot.right,pilot.left)
    runtime.chips.step(run)
    equal(run.stageMultiplier,6)
    equal(run.bossMultiplier,6)
    equal(run.chipCount,0)
    runtime.close(run)
end

-- 0xff15e 在表里两条路线登记不同间隔与弹种。反击弹进入原生敌弹池。
for _, route in ipairs({'omote','ura'}) do
    local run = runtime.init(1,route)
    runtime.addPlayer(run,1,{h=0x1000,l=0x1c00,keys={}})
    local explosion = {run=run,h=0x5000,l=0x1c00}
    runtime.score.fromEffect(explosion)
    local ura = route == 'ura'
    equal(explosion.returnCount,ura and 4 or 3)
    for _=1,ura and 5 or 7 do explosion.onFrame(explosion) end
    equal(next(run.bullets),nil)
    explosion.onFrame(explosion)
    equal(run.bullets[1].kind,ura and 1 or 6)
    equal(run.stageMultiplier,2)
    equal(run.bossMultiplier,2)
    runtime.close(run)
end

-- 0x13680c 检查全炮位与甲板的击破标志。被甲板牵连的主炮会取消增机。
for _, forced in ipairs({false,true}) do
    local run = runtime.init(3,'first')
    local pilot = runtime.addPlayer(run,1,{keys={}})
    run.pilotH,run.pilotL = pilot.h,pilot.l
    local ship
    for _, row in ipairs(run.stage.spawns) do
        if row[3] == 0xa0 then ship = runtime.mid3.spawn(run,row); break end
    end
    for index,p in ipairs(ship.guns) do p.broken = not forced or index ~= 1 end
    for i=1,4 do ship.zones[i].broken = true end
    ship.byIndex[25].broken,ship.byIndex[26].broken = true,true
    ship.coreOpenAt = 0
    ship.byIndex[27].damagePending = ship.zones[5].hp+1
    runtime.mid3.step(ship)
    assert(ship.death)
    equal(run.itemSlots[13] ~= nil,not forced)
    runtime.close(run)
end

-- 0xed9fa 只登记敌机，来袭飞机的减速、发射和击破由各自的回调结算。
for _, route in ipairs({'first','omote','ura'}) do
    local run = runtime.init(5, route)
    local row
    for _, candidate in ipairs(run.stage.spawns) do
        if candidate[3] == 0x9e then row = candidate; break end
    end
    run.major, run.minor = row[1], row[2]
    run.pilotH, run.pilotL, run.fullDamage = 0x1000, 0x1c00, true
    local group = runtime.enemies.spawn(run, row)
    local firstLane = program.raid.lanes[group.lane]
    for _=1,32 do runtime.enemies.step(run) end
    equal(#run.pendingSpawns,0)
    runtime.enemies.step(run)
    equal(#run.pendingSpawns,2)
    equal(run.pendingSpawns[1][3],0x1d)
    equal(run.pendingSpawns[1].h,0x7400)
    equal(run.pendingSpawns[1].l,firstLane)
    equal(run.pendingSpawns[2][3],0x1a)
    run.pendingSpawns = {}
    for _=1,8 do runtime.enemies.step(run) end
    equal(#run.pendingSpawns,0)
    runtime.enemies.step(run)
    equal(#run.pendingSpawns,3)
    equal(run.pendingSpawns[3][3],0x1c)
    local children = run.pendingSpawns
    run.pendingSpawns = {}
    run.largeVehicleLock = group
    for _, child in ipairs(children) do equal(runtime.enemies.spawn(run,child).active,false) end
    run.largeVehicleLock = nil
    for slot = 1, 3, 2 do
        local fighter = runtime.enemies.spawn(run,children[slot])
        assert(fighter.active)
        fighter.h,fighter.l,fighter.speed,fighter.state[0x24] = 0x4000,0x1c00,1,0
        runtime.bullets.clear(run,true)
        runtime.enemies.step(run)
        equal(fighter.leaving,true)
        equal(fighter.speed,0)
        equal(#run.bullets,1)
        equal(run.bullets[1].kind,0x17)
        equal(run.bullets[1].speed,program.bulletSpeed(run,0x17,-4+4*run.route.loop))
        local reload = fighter.kind == 0x1c and 4 or 3
        for _=1,reload do runtime.enemies.step(run) end
        equal(fighter.speed,fighter.kind == 0x1c and 1 or 2)
        runtime.bullets.clear(run,true)
        equal(runtime.playerShot(run,{h=fighter.h,l=fighter.l,front=0,back=0,right=0,left=0,damage=0x21}),fighter)
        runtime.enemies.step(run)
        equal(IsValid(fighter),false)
        equal(#run.bullets,run.route.loop+1)
        equal(run.bullets[1].kind,run.route.ura and 0xe or 0x25)
    end
    equal(#run.effects,2)
    run.major = 0x6f
    run.pendingSpawns = {}
    runtime.enemies.step(run)
    equal(IsValid(group),false)
    equal(#run.pendingSpawns,0)
    runtime.close(run)
end

-- 一面的四炮位飞行器先结算四盒装甲，舰体掉到阈值以下时整组炮位停火。
for _, route in ipairs({'first','omote','ura'}) do
    local rows = {}
    for _, row in ipairs(program.stages[1].spawns) do
        if row[3] == 0x84 then rows[#rows+1] = row end
    end
    equal(#rows,4)
    for _, index in ipairs({1,4}) do
        local run = runtime.init(1,route)
        run.major,run.fullDamage = rows[index][1],true
        run.pilotH,run.pilotL = 0x1000,0x1c00
        local aircraft = runtime.enemies.spawn(run,rows[index])
        equal(aircraft.armor,index == 1 and 0xa0 or 0x50)
        equal(aircraft.hp,index == 1 and 0x1500 or 0xe00)
        if index==1 then equal(aircraft.h,0x5800); equal(aircraft.l,0x5440) end
        aircraft.h,aircraft.l=0x4a00,0x1c00
        aircraft.path,aircraft.cursor,aircraft.elapsed=string.char(0x40,0),1,0
        local wing = aircraft.attachments[2]
        local function step()
            run.frame=run.frame+1
            runtime.enemies.step(run)
        end
        local function shoot(amount)
            equal(runtime.playerShot(run,{h=wing.h-0x700,l=wing.l+0x500,front=0,back=0,right=0,left=0,damage=amount}),wing)
            step()
        end
        run.bulletHold = true
        step()
        equal(aircraft.hp,0x7fff)
        shoot(0x200)
        equal(wing.hp,0x7fff)
        aircraft.armor=0
        step()
        equal(aircraft.hp,0x1500)
        equal(aircraft.armor,-1)
        run.bulletHold=nil
        aircraft.state[0x22]=0
        step()
        equal(#run.bullets,1)
        local bullet=run.bullets[1]
        equal(bullet.kind,0xb)
        equal(bullet.speed,program.bulletSpeed(run,0xb,5+run.route.loop*4))
        equal(bullet.angle,aircraft.headings[aircraft.activeMount]*4)
        runtime.bullets.clear(run,true)
        shoot(0x1500-aircraft.breakAt)
        equal(aircraft.hp,aircraft.breakAt)
        equal(aircraft.weakened,nil)
        equal(#run.smoke,2)
        shoot(1)
        equal(aircraft.weakened,true)
        equal(aircraft.firingSides,false)
        for _, part in ipairs(aircraft.attachments) do equal(part.hp,aircraft.hp) end
        local before = #run.effects
        equal(before,index==1 and 8 or 4)
        runtime.bullets.clear(run,true)
        aircraft.state[0x1e]=0
        step()
        equal(#run.bullets,9*(run.route.loop+1))
        for _, b in ipairs(run.bullets) do equal(b.kind,7) end
        shoot(aircraft.hp)
        equal(aircraft.hp,0)
        equal(IsValid(aircraft),true)
        shoot(1)
        equal(IsValid(aircraft),false)
        equal(IsValid(wing),false)
        equal(#run.effects,before+6)
        runtime.bullets.clear(run,true)
        runtime.close(run)
    end
end

-- 二面的独立炮位、双炮口与开舱坦克使用各自的发射指令。
for _, route in ipairs({'first','omote','ura'}) do
    local run = runtime.init(2,route)
    local rows, hatchRows, turretRows = {}, {}, {}
    for _, row in ipairs(run.stage.spawns) do
        if row[3]>=0x44 and row[3]<=0x47 or row[3]==0x4a or row[3]==0x4b or row[3]==0x55 then
            rows[row[3]]=rows[row[3]] or row
        end
        if row[3]==0x56 then hatchRows[#hatchRows+1]=row end
        if row[3]==0x48 then turretRows[#turretRows+1]=row end
    end
    run.pilotH,run.pilotL,run.fullDamage = 0x1000,0x1c00,true
    local function step()
        run.frame=run.frame+1
        runtime.enemies.step(run)
    end
    local function place(vehicle)
        vehicle.h,vehicle.l=0x4a00,0x1c00
        vehicle.path,vehicle.cursor,vehicle.elapsed=string.char(0x40,0),1,0
    end
    local function shoot(vehicle, amount)
        equal(runtime.playerShot(run,{h=vehicle.h,l=vehicle.l,front=0,back=0,right=0,left=0,damage=amount}),vehicle)
        step()
    end
    local vehicle=runtime.enemies.spawn(run,rows[0x44])
    place(vehicle)
    equal(vehicle.hp,0x2100)
    vehicle.state[0x22],vehicle.state[0x24]=0,0
    step()
    local extra=run.route.loop+1
    equal(#run.bullets,extra)
    equal(run.bullets[1].kind,0xc)
    equal(run.bullets[1].h,0x5500)
    equal(run.bullets[1].speed,program.bulletSpeed(run,0xc,6))
    runtime.bullets.clear(run,true)
    vehicle.state[0x26],vehicle.state[0x24],vehicle.state[0x28],vehicle.state[0x2a]=1,0,0,0
    step()
    equal(vehicle.state[0x1e],1)
    equal(#run.bullets,4*extra)
    equal(run.bullets[3*extra+1].h,0x4880)
    equal(run.bullets[3*extra+1].speed,program.bulletSpeed(run,0xc,0))
    runtime.bullets.clear(run,true)
    shoot(vehicle,0x2000)
    equal(vehicle.hp,0x100)
    equal(vehicle.weakened,true)
    equal(vehicle.flags,0xa100)
    equal(#run.effects,2)
    equal(#run.smoke,2)
    vehicle.state[0x2a]=0
    step()
    equal(#run.bullets,0)
    shoot(vehicle,0x101)
    equal(IsValid(vehicle),false)
    equal(#run.effects,2+#program.earlyVehicle[0x44].death)
    vehicle=runtime.enemies.spawn(run,rows[0x45])
    place(vehicle)
    local s = vehicle.state
    local twins = program.earlyVehicle[0x45]
    equal(vehicle.hp,0x500)
    equal(runtime.enemies.touch(run,vehicle.h,vehicle.l,0,0,0,0,vehicle.hitPool),nil)
    s[0x1c],s[0x1e],s[0x1a] = 0,0,0x80
    for wave=1,4 do
        step()
        equal(s[0x20],4-wave)
        equal(#run.bullets,2*extra)
        for index,port in ipairs({twins.leftMuzzle[17],twins.rightMuzzle[17]}) do
            local first = run.bullets[(index-1)*extra+1]
            equal(first.kind,9)
            equal(first.speed,program.bulletSpeed(run,9,5))
            equal(first.angle,extra==1 and 0x80 or 0x7c)
            equal(first.h,vehicle.h+port[1])
            equal(first.l,vehicle.l+port[2])
            if extra==2 then equal(run.bullets[index*extra].angle,0x84) end
        end
        runtime.bullets.clear(run,true)
        s[0x1e]=0
    end
    local oldEffects=#run.effects
    shoot(vehicle,vehicle.hp+1)
    equal(IsValid(vehicle),false)
    equal(#run.effects,oldEffects+3)
    equal(#turretRows,4)
    for index,row in ipairs(turretRows) do
        vehicle=runtime.enemies.spawn(run,row)
        place(vehicle)
        local state = vehicle.state
        local data = program.earlyVehicle[0x48]
        equal(vehicle.signal,index)
        equal(run.turret48Flags[index],false)
        equal(vehicle.hp,0xc00)
        equal(runtime.enemies.touch(run,vehicle.h,vehicle.l,0,0,0,0,vehicle.hitPool),nil)
        state[0x1a],state[0x1c] = 0x20,0
        local function checkCannon(port)
            equal(#run.bullets,extra)
            local b = run.bullets[1]
            equal(b.kind,0xb)
            equal(b.h,vehicle.h+port[1])
            equal(b.l,vehicle.l+port[2])
            equal(b.speed,program.bulletSpeed(run,0xb,7))
            equal(b.angle,0x81-extra)
            if extra==2 then equal(run.bullets[2].angle,0x81) end
            runtime.bullets.clear(run,true)
        end
        step()
        checkCannon(data.leftMuzzle[17])
        state[0x1a],state[0x26] = 0x1f,0
        step()
        equal(state[0x1a],0x20)
        equal(state[0x24],1)
        equal(#run.bullets,0)
        state[0x1c]=0
        step()
        checkCannon(data.rightMuzzle[17])
        local count=#run.effects
        shoot(vehicle,vehicle.hp+1)
        equal(vehicle.flags,0x8080)
        equal(#run.effects,count+#data.death)
        for _=1,31 do step() end
        equal(IsValid(vehicle),true)
        equal(run.turret48Flags[index],false)
        step()
        equal(IsValid(vehicle),false)
        equal(run.turret48Flags[index],true)
    end
    for _,kind in ipairs({0x46,0x47}) do
        vehicle=runtime.enemies.spawn(run,rows[kind])
        place(vehicle)
        step()
        equal(#vehicle.attachments,3)
        local l = vehicle.l+(kind==0x46 and -0xa00 or 0xa00)
        local shot = {h=vehicle.h,l=l,front=0,back=0,right=0,left=0,damage=0x100}
        equal(runtime.playerShot(run,shot),vehicle)
        vehicle.attachments[2].damage(vehicle.attachments[2],0x180,'shot')
        step()
        equal(vehicle.hp,0x7fff)
        equal(vehicle.attachments[2].hp,0x7fff)
        equal(vehicle.durability,kind==0x46 and 0x800 or 0x680)
        for _=3,150 do step() end
        equal(vehicle.state[0x26],0)
        step()
        equal(vehicle.state[0x26],1)
        for _,height in ipairs(vehicle.panelHeight) do equal(height,0xa00) end
        local count = #run.effects
        local part = vehicle.attachments[3]
        part.damage(part,vehicle.durability+1,'shot')
        step()
        equal(vehicle.breakDelay,0x30)
        equal(#run.effects,count+9)
        equal(#run.bullets,0)
        for _=1,0x2f do step() end
        equal(IsValid(part),true)
        step()
        equal(IsValid(part),false)
        equal(IsValid(vehicle),false)
    end
    for _, kind in ipairs({0x4a,0x4b}) do
        vehicle=runtime.enemies.spawn(run,rows[kind])
        place(vehicle)
        local hp = kind==0x4a and 0x800 or 0x1000
        equal(vehicle.hp,hp)
        equal(runtime.enemies.touch(run,vehicle.h,vehicle.l,0,0,0,0,1),nil)
        local count=#run.effects
        shoot(vehicle,hp)
        equal(IsValid(vehicle),true)
        shoot(vehicle,1)
        equal(IsValid(vehicle),false)
        equal(#run.effects,count+(kind==0x4a and 1 or 3))
    end
    equal(#run.bullets,0)
    equal(#hatchRows,4)
    for _, row in ipairs({rows[0x55],hatchRows[1],hatchRows[4]}) do
        run.major = row[1]
        vehicle=runtime.enemies.spawn(run,row)
        place(vehicle)
        local data = program.earlyVehicle[row[3]]
        equal(vehicle.hp,row[1]<0x130 and 0xb00 or 0xd00)
        equal(vehicle.flashAt,row[1]<0x130 and 0x1d5 or 0x22a)
        vehicle.state[0x28],vehicle.state[0x2a],vehicle.hatchFrame = 1,0,6
        vehicle.state[0x34]=0
        step()
        equal(vehicle.hatchFrame,7)
        equal(vehicle.state[0x28],2)
        equal(#run.bullets,7*extra)
        local first = run.bullets[1]
        local port = data.hatchMuzzle[1]
        equal(first.kind,2)
        equal(first.h,vehicle.h+port[1])
        equal(first.l,vehicle.l+port[2])
        equal(run.bullets[5*extra+1].kind,0xc)
        equal(run.bullets[5*extra+1].speed,program.bulletSpeed(run,0xc,1))
        local angle = first.angle
        for i=2,4 do
            runtime.bullets.clear(run,true)
            vehicle.state[0x30]=0
            step()
            equal(#run.bullets,5*extra)
            equal(run.bullets[1].angle,angle)
            equal(run.bullets[1].l,vehicle.l+data.hatchMuzzle[i][2])
        end
        equal(vehicle.state[0x28],3)
        for _=1,21 do step() end
        equal(vehicle.state[0x28],0)
        equal(vehicle.hatchFrame,0)
        runtime.bullets.clear(run,true)
        local effectsBefore=#run.effects
        shoot(vehicle,vehicle.hp+1)
        equal(IsValid(vehicle),false)
        equal(#run.effects,effectsBefore+#data.death)
    end
    runtime.close(run)
end

-- 五面三种装甲载具的舱口和外炮共用坐标，分别推进各自的发射计时。
for _, route in ipairs({'first','omote','ura'}) do
    local run = runtime.init(5,route)
    local rows = {}
    for _, row in ipairs(run.stage.spawns) do
        if row[3] == 0x5e or row[3] == 0x5f or row[3] == 0x0e then rows[#rows+1]=row end
    end
    equal(#rows,7)
    run.pilotH,run.pilotL,run.fullDamage = 0x1000,0x1c00,true
    local function step()
        run.frame=run.frame+1
        runtime.enemies.step(run)
    end
    local function shoot(vehicle, amount)
        equal(runtime.playerShot(run,{h=vehicle.h,l=vehicle.l,front=0,back=0,right=0,left=0,damage=amount}),vehicle)
        step()
    end
    for _, row in ipairs(rows) do
        run.major,run.minor = row[1],row[2]
        local vehicle = runtime.enemies.spawn(run,row)
        vehicle.h,vehicle.l,vehicle.speed,vehicle.direction = 0x4900,0x1c00,0,0x40
        vehicle.path,vehicle.cursor,vehicle.elapsed = string.char(0x40,0),1,0
        local kind,s = vehicle.kind,vehicle.state
        local data = program.heavyHatch[kind]
        local paired,wide = kind==0x0e,row[2]==0x48
        equal(vehicle.hp,(paired or wide) and 0x4c00 or 0x3400)
        equal(runtime.enemies.touch(run,vehicle.h,vehicle.l,0,0,0,0,vehicle.hitPool),nil)
        s[0x28],s[0x2a],s[0x2d] = 1,0,0x10
        step()
        equal(s[0x2d],0x14)
        if paired then
            local angle = run.bullets[1].angle
            local delta = s[0x3f]
            for wave=0,5 do
                local port = data.ports[wave%4+1]
                if wave>0 then
                    runtime.bullets.clear(run,true)
                    s[0x30]=0
                    step()
                end
                equal(#run.bullets,5)
                for ray=0,4 do
                    local b = run.bullets[ray+1]
                    equal(b.kind,3)
                    equal(b.angle,(angle+delta*wave+0x16*ray)%256)
                    equal(b.speed,program.bulletSpeed(run,3,5+wave))
                    equal(b.h,vehicle.h+port[1])
                    equal(b.l,vehicle.l+port[2])
                end
            end
            equal(s[0x3f],(-delta)%256)
        else
            local rays,spacing,layers = wide and 9 or 5,wide and 10 or 16,wide and 4 or 3
            equal(#run.bullets,(2*rays-1)*layers)
            local angle = run.bullets[1].angle
            local port = data.ports[6]
            for ray=0,rays-1 do
                local a = (angle+ray*spacing)%256
                local h,l = program.unpack(program.pack(port[1],port[2])+0xfd00fd40+
                    program.heavyHatch.radial[math.floor((a+2)%256/4)+1])
                for layer=0,layers-1 do
                    local index = 2*ray*layers+layer+1
                    local main = run.bullets[index]
                    equal(main.kind,3)
                    equal(main.angle,a)
                    equal(main.speed,program.bulletSpeed(run,3,-1+6*layer))
                    equal(main.h,vehicle.h+h)
                    equal(main.l,vehicle.l+l)
                    if ray<rays-1 then
                        local filler = run.bullets[index+layers]
                        equal(filler.kind,0x23)
                        equal(filler.angle,(a+spacing/2)%256)
                        equal(filler.speed,program.bulletSpeed(run,0x23,8+6*layer))
                        equal(filler.h,main.h)
                        equal(filler.l,main.l)
                    end
                end
            end
        end
        equal(s[0x28],3)
        runtime.bullets.clear(run,true)
        s[0x34],s[0x3d] = 0,1
        step()
        local loop = run.route.loop
        equal(#run.bullets,paired and 6*(loop+1) or 1+2*loop)
        equal(run.bullets[1].kind,paired and 0x18 or 2)
        local angle = 4*s[0x26]
        if paired then
            for i=0,2 do
                equal(run.bullets[i*(loop+1)+1].angle,(angle-5-i*16)%256)
                equal(run.bullets[(i+3)*(loop+1)+1].angle,(angle+5+i*16)%256)
            end
            if loop==1 then equal(run.bullets[2].speed,run.bullets[1].speed+6) end
        elseif loop==1 then
            equal(run.bullets[2].angle,(angle-8)%256)
            equal(run.bullets[3].angle,(angle+8)%256)
            equal(run.bullets[1].speed,run.bullets[2].speed+2)
        end
        run.bulletHold=true
        for _=1,12 do step() end
        equal(s[0x28],0)
        runtime.bullets.clear(run,true)
        shoot(vehicle,vehicle.hp)
        equal(vehicle.hp,0)
        equal(IsValid(vehicle),true)
        assert(run.smoke[1] and run.smoke[1].host == vehicle)
        local count = #run.effects
        shoot(vehicle,1)
        equal(IsValid(vehicle),false)
        equal(#run.effects,count+#data.death)
        run.bulletHold=false
        local effects = dofile('mod/GAME/th43/native/effect.lua')(program)
        effects.step(run)
        equal(next(run.smoke),nil)
    end
    runtime.close(run)
end

-- 三种舱炮坦克保留十轮开舱齐射和拆炮后的环射。
for _, route in ipairs({'first','omote','ura'}) do
    for _,stage in ipairs({1,3,5}) do
        local run = runtime.init(stage,route)
        run.pilotH,run.pilotL,run.fullDamage=0x1000,0x1c00,true
        local fifth = stage==5
        local loop = run.route.loop
        local function step()
            run.frame=run.frame+1
            runtime.enemies.step(run)
        end
        for _,row in ipairs(run.stage.spawns) do
            if row[3]>=0x2c and row[3]<=0x2e then
                run.major,run.minor=row[1],row[2]
                local o = runtime.enemies.spawn(run,row)
                o.h,o.l,o.speed,o.direction=0x4900,0x1c00,0,0x40
                o.path,o.cursor,o.elapsed=string.char(0x40,0),1,0
                local data = program.breakawayTank[o.kind]
                equal(o.hp,({0x2600,0,0x3200,0,0x5000})[stage])
                equal(o.breakAt,({0x1600,0,0x1c00,0,0x3000})[stage])
                equal(runtime.enemies.touch(run,o.h,o.l,0,0,0,0,o.hitPool),nil)
                o.state[0x28],o.state[0x2a],o.hatchFrame=1,0,6
                for wave=0,9 do
                    o.state[0x30]=0
                    step()
                    local copies = 1+loop+(fifth and 2 or 0)
                    equal(#run.bullets,2*copies)
                    for i=1,2 do
                        local port = data.ports[2*(wave%3)+i]
                        local b = run.bullets[(i-1)*copies+1]
                        local angle = 4*program.angle(o.h+port[1],o.l+port[2],run.pilotH,run.pilotL,0x20)
                        equal(b.kind,0xd)
                        equal(b.h,o.h+port[1])
                        equal(b.l,o.l+port[2])
                        equal(b.angle,(angle-8*loop)%256)
                        equal(b.speed,program.bulletSpeed(run,0xd,-20))
                        equal(b.speedClock,2)
                        equal(b.speedInterval,2)
                        equal(b.speedDelta,1)
                        if fifth then
                            local extra = run.bullets[(i-1)*copies+2+loop]
                            equal(extra.angle,(angle+24)%256)
                            equal(extra.speed,program.bulletSpeed(run,0xd,-20,true))
                        end
                    end
                    runtime.bullets.clear(run,true)
                end
                equal(o.state[0x28],3)
                o.state[0x34] = 0
                step()
                equal(#run.bullets,14+6*loop)
                equal(run.bullets[1].kind,0xb)
                if loop==1 then equal(run.bullets[2].speed,run.bullets[1].speed+6) end
                runtime.bullets.clear(run,true)
                local function shoot(amount)
                    equal(runtime.playerShot(run,{h=o.h,l=o.l,front=0,back=0,right=0,left=0,damage=amount}),o)
                    step()
                end
                shoot(o.hp-o.breakAt)
                equal(o.weakened,nil)
                run.frame=(fifth and 16 or 32)-1
                local heading = o.state[0x26]
                local count = #run.effects
                shoot(1)
                equal(o.weakened,true)
                equal(#run.effects,count+#data.breakup)
                equal(#run.bullets,fifth and 32 or 16)
                equal(run.bullets[1].angle,4*heading)
                equal(run.bullets[1].speed,program.bulletSpeed(run,2,0,true))
                if fifth then
                    equal(run.bullets[17].angle,((heading+2)*4)%256)
                    equal(run.bullets[17].speed,run.bullets[1].speed+2)
                end
                shoot(o.hp+1)
                equal(IsValid(o),false)
                equal(#run.effects,count+#data.breakup+#data.death)
                runtime.bullets.clear(run,true)
            end
        end
        runtime.close(run)
    end
end

-- 两个一面演出对象走卷轴路径，有独立延时、画面游标和回收条件。
do
    local run = runtime.init(1,'first')
    for _,row in ipairs(run.stage.spawns) do
        if row[3]==0x8d or row[3]==0x92 then
            run.major,run.minor = row[1],row[2]
            local o = runtime.enemies.spawn(run,row)
            o.h,o.l,o.speed,o.direction=0x4900,0x1c00,0,0x40
            o.path,o.cursor,o.elapsed=string.char(0x40,0),1,0
            equal(o.group,GROUP.GHOST)
            for _=1,0x120 do runtime.enemies.step(run) end
            equal(o.wait,0)
            runtime.enemies.step(run)
            if row[3]==0x8d then
                equal(o.offsetH,-17)
                equal(o.offsetL,25)
                run.major=0x176
            else
                equal(o.offsetL,0x1630)
                for _=1,7 do runtime.enemies.step(run) end
                equal(o.picture,14)
                o.h=-0x2401
            end
            runtime.enemies.step(run)
            equal(IsValid(o),false)
        end
    end
    runtime.close(run)
end

-- 飞行甲板的五个碰撞盒取最大伤害，内外炮口与开舱分别推进。
for _, route in ipairs({'first','omote','ura'}) do
    for _,stage in ipairs({3,5}) do
        local run = runtime.init(stage,route)
        local fifth = stage==5
        local body = program.deckCarrier.art[stage].body[1]
        equal(program.sprites[body[1]][5],fifth and 141 or 96)
        equal(program.sprites[body[2]][5],fifth and 118 or 80)
        run.pilotH,run.pilotL,run.fullDamage=0x1000,0x1c00,true
        local function step()
            run.frame=run.frame+1
            runtime.enemies.step(run)
        end
        for _,row in ipairs(run.stage.spawns) do
            if row[3]==0x53 then
                run.major,run.minor=row[1],row[2]
                local o=runtime.enemies.spawn(run,row)
                o.h,o.l,o.speed,o.direction=0x4900,0x1c00,0,0x40
                o.path,o.cursor,o.elapsed=string.char(0x40,0),1,0
                local s=o.state
                local loop=run.route.loop
                equal(#o.attachments,4)
                equal(o.armor,fifth and 0xa0 or 0x60)
                equal(o.durability,fifth and 0x7600 or 0x5600)
                if fifth then equal(run.capacity,120) else equal(run.patrol42Block,true) end
                step()
                o.attachments[1].damage(o.attachments[1],0x3800,'shot')
                step()
                equal(o.durability,fifth and 0x7600 or 0x5600)
                for _,part in ipairs(o.hpBoxes) do equal(part.hp,0x7fff) end
                local gun=o.guns[1]
                gun[1],gun[7]=0,0
                step()
                equal(#run.bullets,fifth and 3 or 1)
                equal(run.bullets[1].kind,fifth and 3 or 2)
                equal(run.bullets[1].speed,program.bulletSpeed(run,fifth and 3 or 2,fifth and 11 or 4,true))
                if fifth then
                    equal(run.bullets[2].angle,(run.bullets[1].angle-8-4*loop)%256)
                    equal(run.bullets[3].angle,(run.bullets[1].angle+8+4*loop)%256)
                end
                runtime.bullets.clear(run,true)
                s[0x27],s[0x2c],s[0x30],o.cover=1,0,0,0x27f
                step()
                equal(o.cover,0x280)
                equal(#run.bullets,fifth and 10 or 6)
                equal(run.bullets[1].kind,0xc)
                runtime.bullets.clear(run,true)
                o.armor=0
                o.attachments[1].damage(o.attachments[1],o.durability-0x2200,'shot')
                o.attachments[2].damage(o.attachments[2],0x200,'bomb')
                s[0x1a]=0
                local count=#run.effects
                step()
                equal(o.durability,0x2200)
                equal(o.weakened,true)
                equal(#run.effects,count+16)
                local rays=o.part[0x1f]~=0 and 9 or fifth and 13 or 7
                equal(#run.bullets,rays+loop*(rays+1)/2)
                o.damage(o,0x2201,'shot')
                step()
                equal(o.durability,-1)
                equal(o.crash,0x20)
                for _,part in ipairs(o.hpBoxes) do equal(part.flags,0x8000) end
                equal(#run.effects,count+16+#program.deckCarrier.death)
                for _=1,31 do step() end
                equal(IsValid(o),true)
                step()
                equal(IsValid(o),false)
                equal(run.patrol42Block,nil)
                equal(#run.effects,count+16+#program.deckCarrier.death+5)
                runtime.bullets.clear(run,true)
            end
        end
        runtime.close(run)
    end
end

-- 五面炮阵走完整的开盖、十六次发射、闭盖和残骸回收。
for _,route in ipairs({'first','omote','ura'}) do
    local run=runtime.init(5,route)
    run.pilotH,run.pilotL,run.fullDamage=0x1000,0x1c00,true
    local count=0
    for _,row in ipairs(run.stage.spawns) do
        if row[3]==0x99 then
            count=count+1
            run.major,run.minor=row[1],row[2]
            local o=runtime.enemies.spawn(run,row)
            o.h,o.l,o.speed,o.direction=0x4900,0x1c00,0,0x40
            o.path,o.cursor,o.elapsed=string.char(0x40,0),1,0
            local s=o.state
            local data=program.platformCannon
            equal(o.hp,0x6000)
            equal(o.right,count==1 and 0xc00 or 0x1200)
            equal(o.left,count==1 and 0x1200 or 0xc00)
            equal(runtime.enemies.touch(run,o.h,o.l,0,0,0,0,o.hitPool),nil)
            s[0x1c]=0
            runtime.enemies.step(run)
            equal(o.phase,1)
            for _=1,30 do runtime.enemies.step(run) end
            equal(o.phase,2)
            equal(o.cover,16)
            for wave=16,1,-1 do
                local port=data.ports[wave]
                local a=program.aimByte(o.h+port[1],o.l+port[2],run.pilotH,run.pilotL,0x80,true)
                s[0x1c]=0
                runtime.enemies.step(run)
                equal(#run.bullets,6)
                for ray=0,2 do
                    local b=run.bullets[2*ray+1]
                    local angle=(a-16+16*ray)%256
                    local p=program.breakawayTank.ring[math.floor((angle+2)%256/4)+1]
                    local h,l=program.add(p[1],p[2],port[1],port[2])
                    equal(b.kind,4)
                    equal(b.angle,angle)
                    equal(b.h,o.h+h)
                    equal(b.l,o.l+l)
                    equal(b.speed,program.bulletSpeed(run,4,1,true))
                    equal(run.bullets[2*ray+2].speed,b.speed+3)
                end
                runtime.bullets.clear(run,true)
            end
            equal(o.phase,3)
            for _=1,32 do runtime.enemies.step(run) end
            equal(o.cover,1)
            equal(o.phase,0)
            o.damage(o,o.hp+1,'shot')
            local effects=#run.effects
            runtime.enemies.step(run)
            equal(o.flags,0x8080)
            equal(o.wreck,0x20)
            equal(#run.effects,effects+#data.death)
            for _=1,32 do runtime.enemies.step(run) end
            equal(IsValid(o),false)
        end
    end
    equal(count,2)
    runtime.close(run)
end

-- 一面升降炮的平台先开，炮身升满才允许自机弹命中。
for _,route in ipairs({'first','omote','ura'}) do
    local run=runtime.init(1,route)
    run.pilotH,run.pilotL,run.fullDamage=0x1000,0x1c00,true
    for _,row in ipairs(run.stage.spawns) do
        if row[3]==0x88 or row[3]==0x89 then
            local o=runtime.enemies.spawn(run,row)
            o.h,o.l,o.speed,o.direction=0x4900,0x1c00,0,0x40
            o.path,o.cursor,o.elapsed=string.char(0x40,0),1,0
            local shot={h=o.h,l=o.l,front=0,back=0,right=0,left=0,damage=o.hp+1}
            equal(runtime.playerShot(run,shot),nil)
            local slideFrames=row[3]==0x88 and 128 or 112
            for _=1,slideFrames do runtime.enemies.step(run) end
            equal(o.doorH,-0x1180)
            equal(o.rise,0)
            equal(o.flags,0x8000)
            for _=1,31 do runtime.enemies.step(run) end
            equal(o.rise,0x5d0)
            equal(runtime.playerShot(run,shot),nil)
            runtime.enemies.step(run)
            equal(o.flags,0xa100)
            equal(o.rise,0x600)
            local s=o.state
            s[0x24],s[0x28]=0,2
            runtime.enemies.step(run)
            local count=run.route.loop+1
            equal(#run.bullets,4*count)
            equal(run.bullets[1].kind,9)
            equal(run.bullets[1].angle,0xb0)
            equal(run.bullets[count+1].angle,0xc6)
            equal(run.bullets[2*count+1].angle,0xb0)
            equal(run.bullets[3*count+1].angle,0x9a)
            equal(run.bullets[1].speed,program.bulletSpeed(run,9,row[3]==0x88 and 1 or 2))
            runtime.bullets.clear(run,true)
            s[0x24]=0
            runtime.enemies.step(run)
            equal(#run.bullets,2*count)
            equal(run.bullets[1].angle,0xa0)
            equal(run.bullets[count+1].angle,0xc0)
            runtime.bullets.clear(run,true)
            equal(runtime.playerShot(run,shot),o)
            local countEffects=#run.effects
            runtime.enemies.step(run)
            equal(o.wreck,0x12)
            equal(#run.effects,countEffects+5)
            for _=1,0x12 do runtime.enemies.step(run) end
            equal(IsValid(o),false)
        elseif row[3]==0x8a or row[3]==0x8b then
            local o=runtime.enemies.spawn(run,row)
            o.h,o.l,o.speed,o.direction=0x4900,0x1c00,0,0x40
            o.path,o.cursor,o.elapsed=string.char(0x40,0),1,0
            equal(o.cover,23)
            for _=1,65 do runtime.enemies.step(run) end
            equal(o.doorH,-0x1554)
            equal(o.doorPhase,2)
            runtime.enemies.step(run)
            equal(o.doorH,-0x1500)
            equal(o.doorPhase,0)
            for _=1,45 do runtime.enemies.step(run) end
            equal(o.flags,0x8000)
            equal(o.cover,1)
            runtime.enemies.step(run)
            equal(o.flags,0xa100)
            equal(o.cover,0)
            o.state[0x22]=0
            runtime.enemies.step(run)
            local spread=row[3]==0x8a and 2 or 4
            equal(#run.bullets,2)
            equal(run.bullets[1].angle,0x80-spread)
            equal(run.bullets[2].angle,0x80+spread)
            equal(run.bullets[1].speed,program.bulletSpeed(run,9,3,true))
            runtime.bullets.clear(run,true)
            o.state[0x22]=0
            runtime.enemies.step(run)
            equal(#run.bullets,4)
            equal(run.bullets[2].angle,0x84)
            equal(run.bullets[4].angle,0x7c)
            runtime.bullets.clear(run,true)
            o.damage(o,o.hp+1,'shot')
            local effects=#run.effects
            runtime.enemies.step(run)
            equal(o.destroyed,true)
            equal(o.flags,0x8080)
            equal(#run.effects,effects+5)
            for _=1,32 do runtime.enemies.step(run) end
            equal(IsValid(o),true)
            o.h=-0xc01
            runtime.enemies.step(run)
            equal(IsValid(o),false)
        end
    end
    runtime.close(run)
end

-- 一面的联动炮台各有一门主炮和两间舱室，只有 0x87 中炮击破时连带拆掉第三盒。
for _,route in ipairs({'first','omote','ura'}) do
    local run=runtime.init(1,route)
    run.pilotH,run.pilotL,run.fullDamage=0x1000,0x1c00,true
    for _,row in ipairs(run.stage.spawns) do
        if row[3]==0x86 or row[3]==0x87 then
            local o=runtime.enemies.spawn(run,row)
            o.h,o.l,o.speed,o.direction=0x4900,0x1c00,0,0x40
            o.path,o.cursor,o.elapsed=string.char(0x40,0),1,0
            local s=o.state
            equal(o.armor,0x1e)
            equal(o.remaining,3)
            local center,outer=unpack(o.attachments)
            local spawnOuterFlag=outer.flags
            o.damage(o,0x200,'shot')
            runtime.enemies.step(run)
            equal(o.hp,0x7fff)
            for _=1,30 do runtime.enemies.step(run) end
            equal(o.hp,0x600)
            equal(center.hp,row[3]==0x86 and 0xc00 or 0x600)
            equal(outer.hp,0x800)
            equal(spawnOuterFlag,row[3]==0x86 and 0xa100 or 0x8000)
            s[0x26],s[0x2a],o.heading=0,1,0x20
            runtime.enemies.step(run)
            local extra=run.route.loop+1
            equal(#run.bullets,4*extra)
            equal(run.bullets[1].kind,9)
            equal(run.bullets[1].angle,0x80)
            equal(run.bullets[extra+1].angle,0x96)
            if extra==2 then equal(run.bullets[2].speed,run.bullets[1].speed+6) end
            runtime.bullets.clear(run,true)
            local effects=#run.effects
            center.damage(center,center.hp+1,'shot')
            runtime.enemies.step(run)
            equal(center.broken,true)
            equal(o.left,0xc00)
            equal(outer.right,0xc00)
            equal(o.remaining,row[3]==0x86 and 2 or 1)
            equal(#run.effects,effects+(row[3]==0x86 and 5 or 10))
            equal(#run.bullets,0)
            outer.damage(outer,outer.hp+1,'shot')
            o.damage(o,o.hp+1,'shot')
            runtime.enemies.step(run)
            equal(o.remaining,0)
            equal(outer.broken,true)
            equal(#run.effects,effects+15)
            for _=1,24 do runtime.enemies.step(run) end
            equal(IsValid(o),false)
            equal(IsValid(center),false)
            equal(IsValid(outer),false)
        end
    end
    runtime.close(run)
end

-- 五面生成器的子机也有独立回调，沿路径发射并按卷轴区段选择击破反击。
for _,route in ipairs({'first','omote','ura'}) do
    local run=runtime.init(5,route)
    run.pilotH,run.pilotL,run.fullDamage=0x1000,0x1c00,true
    local def=program.spawnTypes[0x1f]
    local row={0,0,0x1f,0x40,0,0,0,0,def[1],def[2],h=0x4900,l=0x2400,path=string.char(0x20,0)}
    local o=runtime.enemies.spawn(run,row)
    o.speed=0
    run.major,run.minor,run.frame=0x1c0,0,8
    runtime.enemies.step(run)
    equal(#run.bullets,1)
    equal(run.bullets[1].kind,9)
    equal(run.bullets[1].speed,program.bulletSpeed(run,9,4,true))
    equal(run.bullets[1].angle,0x80)
    local port=program.raid.scoutMuzzles[17]
    local h,l=program.add(o.h,o.l,port[1],port[2])
    equal(run.bullets[1].h,h)
    equal(run.bullets[1].l,l)
    runtime.bullets.clear(run,true)
    run.major,run.frame=0x40,9
    equal(runtime.playerShot(run,{h=o.h,l=o.l,front=0,back=0,right=0,left=0,damage=o.hp+1}),o)
    runtime.enemies.step(run)
    equal(IsValid(o),false)
    equal(#run.bullets,run.route.loop+1)
    equal(run.bullets[1].kind,run.route.ura and 0xe or 0x25)
    equal(run.bullets[1].angle,0x80)
    equal(run.bullets[1].speedLimit,0x1c)
    if run.route.loop==1 then equal(run.bullets[2].speed,run.bullets[1].speed+6) end
    runtime.close(run)
end

print('绊地狱三路线的生成表、自机武装与坠毁、定点碰撞、敌弹减容、道中和各面关底通过隔离回归。')
