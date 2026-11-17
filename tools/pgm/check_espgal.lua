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

    -- 点射释放 A 后，0x122c74 仍在原定的第 4、7 帧挂上相邻两组。
    run = runtime.init(1,nil,withArt)
    keys = {shoot=true}
    player = runtime.addPlayer(run,0x2bec,0x225e,keys,0xfe)
    step()
    keys.shoot = false
    step()
    step()
    equal(player.shots[3],nil)
    step()
    equal(assert(player.shots[3]).h,0x2f7e)
    for _ = 1,3 do step() end
    equal(assert(player.shots[5]).h,0x2f7e)
    equal(player.burst,0)
    runtime.close(run)

    -- 3025 帧的两束激光先保持 0x200 长度五帧，再逐帧加 0x800。
    run = runtime.init(1,nil,withArt)
    keys = {shoot=true}
    player = runtime.addPlayer(run,0x2bec,0x225e,keys,0xfe)
    for _ = 1,24 do step() end
    equal(#player.rays,0)
    step()
    equal(player.pose,14)
    equal(#player.rays,2)
    local ray,other = unpack(player.rays)
    equal(ray.h,0x2eec)
    equal(ray.l,0x251e)
    equal(other.l,0x1f9e)
    equal(ray.width,0x80)
    equal(ray.length,0x200)
    for _ = 1,4 do step() end
    equal(ray.length,0x200)
    step()
    equal(ray.length,0xa00)
    local block = {h=ray.h + 0xb00,l=ray.l,front=0x80,back=0x200,right=0x80,left=0x80,flags=0xa000,hp=300}
    run.partSlots[2][1] = block
    runtime.collision.lasers(run,player)
    equal(ray.hitStop,block.h - block.back)
    equal(block.hp,250)
    step()
    equal(ray.length,0x900)
    keys.shoot = false
    step()
    equal(player.pose,15)
    equal(#player.rays,0)
    runtime.close(run)

    -- 3214 帧切到觉圣形态，3216、3222、3228 帧耗掉 3 颗精灵石并进入觉圣死界。
    run = runtime.init(1,{initialGems=3},withArt)
    keys = {spell=true}
    player = runtime.addPlayer(run,0x2bec,0x225e,keys,0xfe)
    step()
    keys.spell = false
    equal(player.awakeClock,0x108)
    for _ = 2,13 do step() end
    equal(player.form,1)
    step()
    equal(player.form,2)
    equal(player.awakeClock,0x6c)
    equal(run.slowVectors,true)
    equal(run.awakeningMode,2)
    equal(player.front,0x100)
    for _ = 15,27 do step() end
    equal(player.gems,1)
    step()
    equal(player.gems,0)
    equal(run.awakeningMode,1)
    equal(run.slowVectors,false)
    keys.shoot = true
    step()
    equal(assert(player.shots[1]).h,0x2fd8)
    equal(assert(player.shots[1]).l,0x235e)
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
    local gem = assert(run.rewards[1])
    equal(gem.value,2)
    equal(gem.images,runtime.program.rewards[0x28].images)
    equal(assert(run.rewards[2]).value,1)
    -- 第 2982 帧的道具槽，0x801166 在下一帧归零。奇帧继续使用上一帧速度。
    gem.h,gem.l,gem.speed,gem.dh,gem.dl = 0x52c4,0x6be,0xf,0,0
    run.frame = 0x229
    player.protect,keys.shoot = 0xfe,false
    step()
    equal(gem.h,0x5306)
    equal(gem.speed,0x11)
    step()
    equal(gem.h,0x5348)
    equal(gem.speed,0x11)
    player.h,player.l = gem.h,gem.l
    for _ = 1,3 do step() end
    equal(run.rewards[1],nil)
    equal(run.rewards[2],nil)
    equal(player.gems,103)
    for _ = 6,24 do step() end
    equal(run.effects[1],nil)
    runtime.close(run)

    -- 2982 帧觉圣击破地炮。0x170160 第 24 次推进前把敌弹的位置交给金块槽。
    run = runtime.init(1,{spawnIndex=2},withArt)
    keys = {}
    player = runtime.addPlayer(run,0x2bec,0x225e,keys,0xfe)
    for _,lane in ipairs(run.scroll) do
        lane.major,lane.hPixels,lane.hRest,lane.hBlock = 9,79,0x30,9
    end
    for _ = 1,36 do step() end
    tank = assert(run.enemies[11])
    local converted = assert(run.bullets[1])
    equal(converted.origin,tank)
    keys.spell = true
    step()
    keys.spell = false
    for _ = 2,14 do step() end
    player.h,player.l,keys.shoot = tank.h - 0x600,tank.l - 0x100,true
    step()
    equal(tank.rewardMode,2)
    equal(tank.hp,-8)
    keys.shoot = false
    player.gems,player.gemClock = 0x60,4
    converted.h,converted.l,converted.dh,converted.dl = 0x27b2,0x1f97,-0x70,0x28
    run.randomIndex = 0x83
    step()
    equal(run.enemies[11],nil)
    equal(converted.callback,0x170160)
    equal(converted.origin,player)
    equal(converted.h,0x2757)
    equal(converted.l,0x1fb5)
    equal(player.gems,0x5b)
    equal(player.score,4)
    for _ = 1,22 do step() end
    equal(run.rewards[1],nil)
    step()
    local gold = assert(run.rewards[1])
    equal(gold.firstUpdate,run.frame+1)
    equal(gold.h,0x1f85)
    equal(gold.l,0x2249)
    equal(gold.score,10)
    player.h,player.l = gold.h,gold.l
    for _ = 1,4 do step() end
    equal(run.rewards[1],nil)
    equal(player.goldStock,1)
    equal(player.score,14)
    runtime.close(run)

    -- 第 3141 帧点按 C，54 帧后发射，护罩在第 3268 帧收完。
    run = runtime.init(1,{spawnIndex=#runtime.program.stages[1].spawns+1},withArt)
    keys = {special=true}
    player = runtime.addPlayer(run,0x2bec,0x225e,keys,0xfe)
    local target = {h=player.h+0x800,l=player.l,front=0x80,back=0x80,right=0x80,left=0x80,flags=0xa000,hp=40}
    run.partSlots[1][1] = target
    step()
    local guard = assert(player.guard)
    equal(player.pose,18)
    equal(player.guardEnergy,0xba0)
    equal(player.protect,0xfe)
    equal(guard.segments[1].length,0x980)
    equal(guard.segments[1].back,0x500)
    equal(target.hp,0)
    run.partSlots[1][1] = nil
    keys.special = false
    for _ = 2,54 do step() end
    equal(guard.phase,'opening')
    step()
    equal(guard.phase,'beam')
    equal(#guard.segments,2)
    equal(guard.segments[1].h,0x2d6c)
    equal(guard.segments[1].l,0x255e)
    equal(guard.segments[2].l,0x1f5e)
    equal(guard.segments[1].damage,0x90)
    for _ = 1,12 do step() end
    equal(player.guardCharge,0x200)
    step()
    equal(player.guardCharge,0x1d8)
    for _ = 1,12 do step() end
    equal(player.guardCharge,0)
    equal(guard.phase,'fade')
    for _ = 1,47 do step() end
    equal(player.guard,guard)
    step()
    equal(player.guard,nil)
    equal(player.protect,0x5a)
    runtime.close(run)

    -- 原版第 3425 帧的蓄力为 0xdbb。下一帧释放时挂四束，炮口按原表排列。
    run = runtime.init(1,{spawnIndex=#runtime.program.stages[1].spawns+1},withArt)
    keys = {special=true}
    player = runtime.addPlayer(run,0x2bec,0x225e,keys,0xfe)
    for _ = 3141,3425 do step() end
    equal(player.guardEnergy,0x804)
    equal(player.guardCharge,0xdbb)
    keys.special = false
    step()
    equal(#player.guard.segments,4)
    equal(player.guard.segments[1].h,0x2aec)
    equal(player.guard.segments[1].l,0x2c5e)
    equal(player.guard.segments[4].h,0x31ec)
    equal(player.guard.segments[4].l,0x1f5e)
    runtime.close(run)

    -- 觉圣受击走自动防护槽。同一帧不消耗自机库存。
    run = runtime.init(1,{spawnIndex=#runtime.program.stages[1].spawns+1},withArt)
    keys = {spell=true}
    player = runtime.addPlayer(run,0x2bec,0x225e,keys,0)
    step()
    keys.spell = false
    for _ = 2,14 do step() end
    player.pendingHit = true
    step()
    equal(player.form,2)
    equal(player.reserveLives,2)
    equal(player.guardEnergy,0x7d0)
    equal(player.protect,0xfe)
    equal(player.guard.phase,'opening')
    runtime.close(run)

    -- 整关练习切面需保留同一自机和局内库存，并回收出自上一面的武器槽。
    run = runtime.init(1,{spawnIndex=#runtime.program.stages[1].spawns+1},withArt)
    keys = {shoot=true}
    player = runtime.addPlayer(run,0x2bec,0x225e,keys,0xfe)
    step()
    assert(player.shots[1])
    player.gems,player.guardEnergy,player.score = 120,0xba0,2500
    run.stageCleared = true
    local nextRun = assert(runtime.advance(run))
    equal(nextRun.stageNumber,2)
    equal(nextRun.player,player)
    equal(player.run,nextRun)
    equal(player.gems,120)
    equal(player.guardEnergy,0xba0)
    equal(player.score,2500)
    equal(next(player.shots),nil)
    equal(runtime.advance(run),nil)
    runtime.close(nextRun)

    -- 第 3907 帧的生成记录给双炮塔地炮连续分配两个部件槽。
    run = runtime.init(1,{player={active=true,h=0xfec,l=0x1c00},lateFireRank=9,volleyRank=3},withArt)
    local twin
    for _ = 1,1190 do step() end
    for _,enemy in pairs(run.enemies) do
        if enemy.callback == 0x1649f2 then twin = enemy; break end
    end
    assert(twin,'原版计数 0x52 未登记双炮塔地炮')
    equal(run.major,0x52)
    equal(twin.h % 0x10000,0x81c0)
    equal(twin.l,0x3000)
    local bank = run.partSlots[twin.partPool]
    local firstPart = twin.firstPart
    equal(bank[firstPart],twin)
    equal(bank[firstPart + 1],twin.secondPart)
    equal(twin.health,0x800)

    -- 第 3960、3966、3972 帧，两炮各发三颗。第三轮的同侧三颗重合。
    local volleys = {
        {{0x6202,0x3162,0x8e,0xff1b,0xffc9},{0x61ee,0x318a,0x8c,0xff17,0xffd2},
         {0x61ee,0x31ca,0x8a,0xff13,0xffda},{0x61ae,0x240a,0x8a,0xff13,0xffda},
         {0x61ae,0x23ca,0x8c,0xff17,0xffd2},{0x61c2,0x23a2,0x8e,0xff1b,0xffc9}},
        {{0x5fda,0x306c,0x8f,0xff1c,0xffc7},{0x5fda,0x306c,0x8e,0xff1b,0xffc9},
         {0x5fc6,0x3094,0x8d,0xff18,0xffce},{0x5f76,0x2344,0x89,0xff13,0xffdd},
         {0x5f86,0x2314,0x8a,0xff13,0xffda},{0x5f86,0x2314,0x8b,0xff14,0xffd6}},
        {{0x5dc0,0x2f6b,0x90,0xff1e,0xffc4},{0x5dc0,0x2f6b,0x90,0xff1e,0xffc4},
         {0x5dc0,0x2f6b,0x90,0xff1e,0xffc4},{0x5d5c,0x2243,0x88,0xff11,0xffe2},
         {0x5d5c,0x2243,0x88,0xff11,0xffe2},{0x5d5c,0x2243,0x88,0xff11,0xffe2}},
    }
    for elapsed = 1,133 do
        step()
        local count = 0
        local volley = elapsed >= 53 and elapsed <= 65 and (elapsed - 53) % 6 == 0
            and volleys[(elapsed - 53) / 6 + 1]
        for slot = 1,run.bulletCapacity do
            local b = run.bullets[slot]
            if b and b.origin == twin and b.flash then
                count = count + 1
                if elapsed <= 65 then
                    local row = assert(volley and volley[count],'双炮塔在预期外的帧发弹')
                    equal(b.h,row[1])
                    equal(b.l,row[2])
                    equal(b.angle,row[3])
                    equal(b.dh % 0x10000,row[4])
                    equal(b.dl % 0x10000,row[5])
                    equal(b.callback,0x1749c4)
                    equal(b.speed,0x16)
                end
            end
        end
        if volley then equal(count,#volley) end
    end
    equal(twin.h,0x5c78)
    equal(twin.l,0x1f5f)
    -- 两发无偏移的夹具弹分别穿过上下判定框，伤害经通常自弹入口写入。
    local fixture = {shots={
        {h=twin.h,l=twin.l,front=0,back=0,right=0,left=0,damage=0xc00},
        {h=twin.h - 0x800,l=twin.l,front=0,back=0,right=0,left=0,damage=0x155},
    }}
    runtime.collision.shots(run,fixture)
    equal(twin.damage,0x900)
    equal(twin.secondPart.damage,0x100)
    step()
    equal(run.enemies[twin.slot],nil)
    equal(bank[firstPart],nil)
    equal(bank[firstPart + 1],nil)
    local explosion
    local staged = {}
    for _,effect in pairs(run.effects) do
        if effect.frames == runtime.program.effects[0x84] then explosion = effect end
        if effect.frames == runtime.program.effects[0x89] then staged[1] = effect end
        if effect.frames == runtime.program.effects[0x88] then staged[2] = effect end
    end
    equal(assert(explosion).h,0x5285)
    equal(explosion.l,0x1b4d)
    equal(assert(staged[1]).delay,5)
    equal(assert(staged[2]).delay,2)
    local hover
    for _ = 1,122 do
        step()
        for _,enemy in pairs(run.enemies) do
            if enemy.callback == 0x150818 then hover = enemy; break end
        end
        if hover then break end
    end
    assert(hover,'双炮塔退场后未推进到 0x6a 的飞行敌机')
    equal(run.major,0x6a)
    equal(hover.h,0x7e00)
    equal(hover.l,0x1400)
    while run.frame < 2298 do step() end
    equal(run.major,0xb9)
    local upcoming = run.stage.spawns[run.spawnIndex]
    equal(upcoming[1],0xba)
    equal(upcoming[10],0x1af618)
    step()
    equal(assert(run.midBoss).row,upcoming)
    equal(run.midBoss.partCount,13)
    step()
    equal(run.midBoss.h,0x16a6)
    equal(run.midBoss.l,0x43de)
    runtime.close(run)

    -- 单独重放第 4163 帧的 0x09 敌机。原版夹具保持自机无敌，锁定首个航点的随机游标。
    run = runtime.init(1,{player={active=true,h=0xfec,l=0x1c00},volleyRank=3,randomIndex=0x41},withArt)
    local row
    for _,entry in ipairs(run.stage.spawns) do
        if entry[10] == 0x150818 then row = entry; break end
    end
    run.stage = setmetatable({spawns={assert(row)}},{__index=run.stage})
    for _,lane in ipairs(run.scroll) do
        lane.major,lane.hPixels,lane.hRest,lane.hBlock = 0x69,0x34f,0x10,0x69
        lane.pendingH = 0x30
    end
    step()
    hover = assert(run.enemies[11])
    equal(hover.targetH,0x5c00)
    equal(hover.targetL,0x2400)
    equal(hover.direction,0x1a)
    step()
    equal(hover.h,0x7dad)
    equal(hover.l,0x1425)
    for _ = 4165,4237 do step() end
    equal(hover.mode,0)
    step()
    equal(hover.mode,1)
    equal(hover.h,0x5d8b)
    equal(hover.l,0x233a)
    for _ = 4239,4292 do
        step()
        equal(next(run.bullets),nil)
    end
    step()
    equal(hover.mode,0)
    local speeds = {{0xff52,0xffea},{0xff3d,0xffe8},{0xff27,0xffe5},{0xff11,0xffe2}}
    for slot,velocity in ipairs(speeds) do
        local b = assert(run.bullets[slot])
        equal(b.origin,hover)
        equal(b.h,0x4e58)
        equal(b.l,0x256e)
        equal(b.angle,0x88)
        equal(b.speed,0xe + slot * 2)
        equal(b.dh % 0x10000,velocity[1])
        equal(b.dl % 0x10000,velocity[2])
        equal(b.callback,0x174578)
    end
    equal(run.bullets[5],nil)
    runtime.close(run)
end

local function verifyGunship(withArt,flushFrame)
    local run = runtime.init(1,{player={active=true,h=0xfec,l=0x1c00},randomIndex=0x50},withArt)
    local function step()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    for _,entry in ipairs(run.stage.spawns) do
        if entry[10] == 0x16c36a then
            run.stage = setmetatable({spawns={entry}},{__index=run.stage})
            break
        end
    end
    -- V100 第 4184 帧的卷轴状态，下一帧 0x6c 把炮舰装入第二部件池。
    for _,lane in ipairs(run.scroll) do
        lane.major,lane.hPixels,lane.hRest,lane.hBlock = 0x6b,0x35f,0x30,0x6b
        lane.pendingH = 0x30
    end
    step()
    local ship = assert(run.enemies[11])
    local partSlot = ship.firstPart
    equal(run.partSlots[2][partSlot],ship)
    equal(ship.h % 0x10000,0x8800)
    equal(ship.l,0x1000)
    equal(ship.hp,0x1800)
    step()
    equal(ship.h % 0x10000,0x87c0)
    equal(ship.hp,0x7fff)

    for _ = 4187,4316 do
        step()
        equal(next(run.bullets),nil)
    end
    local function checkVolley(rows,callback,speed)
        local count = 0
        for slot = 1,run.bulletCapacity do
            local b = run.bullets[slot]
            if b and b.flash then
                count = count + 1
                local row = assert(rows[count],'炮舰发射的弹数多于原程序')
                equal(b.h,row[1])
                equal(b.l,row[2])
                equal(b.angle,row[3])
                equal(b.dh % 0x10000,row[4])
                equal(b.dl % 0x10000,row[5])
                equal(b.speed,speed)
                equal(b.callback,callback)
            end
        end
        equal(count,#rows)
    end

    -- 第 4317 帧，炮舰取第 0x9b 个随机字节后从同一炮口发三颗。
    run.randomIndex = 0x9a
    step()
    equal(ship.h,0x6f40)
    checkVolley({{0x5b64,0x12cb,0x78,0xfefb,0x21},{0x5b64,0x124b,0x90,0xff09,0xffbe},
        {0x5ba4,0x132b,0x60,0xff45,0x7e}},0x1743b8,0x18)
    for _ = 4318,4345 do step() end
    equal(ship.hp,0x7fff)
    step()
    equal(ship.hp,0x1800)
    for _ = 4347,4396 do step() end
    step()
    -- 第 4397 帧，第二门翼炮的五颗弹在首帧回调中越界。
    checkVolley({{0x6c40,0x08df,0x70,0xff1e,0x3c},{0x6c40,0x087f,0x80,0xff0a,0},
        {0x6c40,0x081f,0x90,0xff1e,0xffc4},{0x6c80,0x08ff,0x60,0xff55,0x73},
        {0x6ce0,0x093f,0x50,0xffa4,0x97}},0x175446,0x16)
    for _ = 4398,4404 do step() end
    checkVolley({{0x6b00,0x08df,0x70,0xff1e,0x3c},{0x6b00,0x087f,0x80,0xff0a,0},
        {0x6b00,0x081f,0x90,0xff1e,0xffc4},{0x6b40,0x08ff,0x60,0xff55,0x73},
        {0x6ba0,0x093f,0x50,0xffa4,0x97},{0x6e80,0x161f,0x78,0xff11,0x1e},
        {0x6e80,0x15df,0x88,0xff11,0xffe2},{0x6ea0,0x157f,0x98,0xff35,0xffa6},
        {0x6ea0,0x167f,0x68,0xff35,0x5a},{0x6ee0,0x169f,0x58,0xff78,0x86}},0x175446,0x16)

    for _ = 4405,4530 do step() end
    local shot = {h=ship.h,l=ship.l,front=0,back=0,right=0,left=0,damage=0x2140}
    runtime.collision.shots(run,{shots={shot}})
    equal(ship.hp,-0xf0)
    step()
    equal(ship.h,0x4700)
    equal(ship.flags,0x8080)
    equal(ship.dying,true)
    run.randomIndex = 0xf6
    step()
    local fragment = assert(run.effects[1])
    equal(fragment.frames,runtime.program.effects[8])
    equal(fragment.h,0x4646)
    equal(fragment.l,0x1bfe)
    step()
    equal(fragment.h,0x463e)
    equal(fragment.l,0x1bfc)
    for _ = 4534,4595 do step() end
    equal(ship.deathClock,20)
    local explosion
    for _,effect in pairs(run.effects) do
        if effect.frames == runtime.program.effects[0x8c] then explosion = effect; break end
    end
    equal(assert(explosion).h,0x44c0)
    equal(explosion.l,0x1000)
    for _ = 4596,4614 do step() end
    equal(run.enemies[11],ship)
    step()
    equal(run.enemies[11],nil)
    equal(run.partSlots[2][partSlot],nil)
    runtime.close(run)
end

local function verifyPilotLoss(withArt,flushFrame)
    local run = runtime.init(1,nil,withArt)
    run.stage = setmetatable({spawns={}},{__index=run.stage})
    local player = runtime.addPlayer(run,0x2bec,0x1c00,{},1)
    local function step()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    -- 0x12284e 先消费保护期接触，0x122866 的下一次有效接触才消耗备用机。
    player.pendingHit = true
    step()
    equal(player.active,true)
    equal(player.reserveLives,2)
    equal(player.protect,0)
    player.pendingHit = true
    step()
    equal(player.active,false)
    equal(player.reserveLives,1)
    equal(player.h,0x2bec)
    step()
    equal(player.h,0x2b2c)
    equal(player.loss.pose,runtime.program.agehaLoss[1])
    for _ = 3083,3100 do step() end
    equal(player.h,0x1f6c)
    for _ = 3101,3108 do step() end
    equal(player.h,0x1dec)
    for _ = 3109,3168 do step() end
    equal(player.active,false)
    equal(player.loss.waiting,true)
    step()
    equal(player.active,false)
    step()
    equal(player.active,true)
    equal(player.h,0x1dec)
    equal(player.l,0x1c00)
    equal(player.protect,0xef)

    -- 备用数为 0 时还能补进当前机，最后一架坠毁才进入结束流程。
    player.protect,player.pendingHit = 0,true
    step()
    equal(player.reserveLives,0)
    for _ = 1,89 do step() end
    equal(player.active,true)
    equal(player.h,0xfec)
    player.protect,player.pendingHit = 0,true
    step()
    equal(player.reserveLives,-1)
    for _ = 1,63 do step() end
    equal(run.gameOver,nil)
    step()
    equal(run.gameOver,true)
    equal(player.active,false)
    runtime.close(run)
end

local function verifyMidBoss(withArt,flushFrame,breakWings)
    local run = runtime.init(1,{player={active=true,h=0xfec,l=0x1c00}},withArt)
    local row
    for _,entry in ipairs(run.stage.spawns) do
        if entry[10] == 0x1af618 then row = entry; break end
    end
    run.stage = setmetatable({spawns={assert(row)}},{__index=run.stage})
    for _,lane in ipairs(run.scroll) do
        lane.major,lane.hPixels,lane.hRest,lane.hBlock = 0xb9,0x5cf,0x20,0xb9
    end
    local frame = 5016
    local function advance(target)
        while frame < target do
            frame = frame+1
            runtime.step(run)
            if flushFrame then flushFrame() end
        end
    end
    advance(5017)
    local boss = assert(run.midBoss)
    local bank = run.partSlots[boss.partPool]
    local parts = boss.extraParts
    local hitSlots = {1,2,3,4,8,9,10}
    equal(run.bulletCapacity,110)
    equal(run.stageFlags[0],true)
    for i,part in ipairs(parts) do equal(bank[boss.firstPart+i],part) end
    for _,i in ipairs(hitSlots) do equal(parts[i].flags,0x8000) end
    advance(5114)
    equal(boss.phase,7)
    equal(boss.h,0x7ab5)
    equal(boss.l,0xc14)
    advance(5168)
    equal(boss.h,0x4fcb)
    equal(boss.l,0x2708)
    for _,i in ipairs(hitSlots) do equal(parts[i].flags,0xa001) end
    equal(parts[3].h,0x45cb)
    equal(parts[3].l,0x3808)
    local contact = {h=parts[3].h,l=parts[3].l,front=0,back=0,right=0,left=0}
    equal(runtime.collision.body(run,contact),parts[3])
    equal(contact.pendingHit,true)
    advance(5169)
    equal(boss.phase,2)

    local function volley(expected,callback,speed)
        local count = 0
        for slot = 1,run.bulletCapacity do
            local b = run.bullets[slot]
            if b and b.origin == boss and b.flash then
                count = count+1
                local bullet = assert(expected[count],'中 Boss 在单次发射中生成了额外敌弹')
                equal(b.callback,callback)
                equal(b.speed,speed)
                equal(b.h-boss.h,bullet[1])
                equal(b.l-boss.l,bullet[2])
                equal(b.angle,bullet[3])
                equal(b.dh % 0x10000,bullet[4])
                equal(b.dl % 0x10000,bullet[5])
            end
        end
        equal(count,#expected)
    end

    -- 这三种原版弹的初始位置以下面的机身坐标为基准。道中随机游标独立于此夹具。
    advance(5249)
    boss.cannonAim = {0x21,0x1f}
    advance(5250)
    volley({{-0x14a,0x5b7,0x6f,0xff49,0x34},{-0x162,0x515,0x7d,0xff37,9},
        {-0x153,0x49b,0x8b,0xff3f,0xffde},{-0x107,0x3fb,0x99,0xff5d,0xffb4},
        {-0x109,-0x37d,0x67,0xff5d,0x4c},{-0x155,-0x41d,0x75,0xff3f,0x22},
        {-0x162,-0x497,0x83,0xff37,0xfff7},{-0x14a,-0x539,0x91,0xff49,0xffcc}},0x174236,0x12)
    advance(5282)
    boss.cannonAim = {0x20,0x1e}
    advance(5283)
    volley({{-0xf2,0x615,0x64,0xff66,0x54},{-0x154,0x5a3,0x72,0xff45,0x2d},
        {-0x166,0x4ff,0x80,0xff37,0},{-0x149,0x447,0x8e,0xff45,0xffd3},
        {-0xd1,0x3e9,0x9c,0xff66,0xffac},{-0xa3,-0x34b,0x5c,0xff81,0x66},
        {-0x119,-0x391,0x6a,0xff55,0x43},{-0x15d,-0x435,0x78,0xff3d,0x18},
        {-0x15c,-0x4cd,0x86,0xff3a,0xffee},{-0x118,-0x571,0x94,0xff51,0xffc1}},0x1740b4,0x12)
    advance(5350)
    equal(boss.phase,1)
    if not breakWings then
        advance(5423)
        equal(boss.hatch[1],0x1c)
        volley({{-0x1060,0x1404,0x42,0xfff8,0x77},{-0x13ae,0x12f7,0x60,0xff83,0x54},
            {-0x1532,0x107f,0x7e,0xff4d,5}},0x1749c4,0x10)
        advance(5615)
        equal(boss.phase,3)
        equal(boss.hatch[1],0)
        advance(5660)
        equal(boss.hatch[2],0x1c)
        run.randomIndex = 0xda
        advance(5661)
        volley({{0xdc6,-0x2c2,0xda,0x6a,0xffa1},{0xf94,-0xa4,0xf6,0xad,0xffe4},
            {0xf28,0x1b0,0x12,0xa0,0x32},{0xc72,0x354,0x2e,0x4b,0x6b},
            {0x90e,0x365,0x4a,0xffd5,0x73},{0x628,0x20b,0x66,0xff72,0x46},
            {0x55a,-0x43,0x82,0xff4d,0xfffb},{0x6d2,-0x279,0x9e,0xff7d,0xffb1},
            {0x9e0,-0x385,0xba,0xffe7,0xff8b}},0x1765a4,0x10)
        advance(5864)
        equal(boss.phase,2)
        advance(6817)
        equal(boss.phase,5)
        equal(boss.protected,true)
        equal(run.stageFlags[0],false)
        while run.midBoss and frame < 7067 do advance(frame+1) end
    else
        local function hit(part,damage,dh)
            return {h=part.h+(dh or 0),l=part.l,front=0,back=0,right=0,left=0,damage=damage}
        end
        advance(5390)
        runtime.collision.shots(run,{shots={hit(parts[3],0x4001)}})
        equal(parts[3].damage,0x3001)
        advance(5391)
        equal(boss.health[1],0xb400)
        equal(boss.wingLost[1],true)
        equal(parts[1].flags,0x8000)
        equal(parts[3].flags,0x8000)
        equal(run.bulletClearClock,0x1f)
        equal(boss.drawParts[4],true)
        advance(5402)
        equal(boss.drawParts[4],nil)
        equal(boss.drawParts[8],true)
        advance(5550)
        runtime.collision.shots(run,{shots={hit(parts[4],0x4001)}})
        equal(parts[4].damage,0x3001)
        advance(5551)
        equal(boss.health[1],0x8700)
        equal(boss.wingCount,2)
        equal(boss.phase,3)
        advance(5562)
        equal(boss.drawParts[5],nil)
        equal(boss.drawParts[9],true)
        advance(5800)
        runtime.collision.shots(run,{shots={hit(parts[8],0x6000,0x2000),hit(parts[8],0x6000,0x2000)}})
        equal(parts[8].damage,0x9000)
        advance(5801)
        equal(boss.phase,6)
        equal(boss.health[1],-1)
        equal(boss.dying,true)
        equal(boss.speed,2)
        for _,i in ipairs(hitSlots) do equal(parts[i].flags,0x8000) end
        equal(run.bulletClearClock,0xaf)
        local fragment = false
        for _,effect in pairs(run.effects) do
            if effect.frames == runtime.program.effects[4] then fragment = true end
        end
        equal(fragment,true)
        advance(5915)
        equal(next(boss.drawParts),nil)
        while run.midBoss and frame < 6120 do advance(frame+1) end
    end
    equal(run.midBoss,nil)
    equal(run.stageFlags[0],false)
    equal(run.enemies[boss.slot],nil)
    for i = 0,boss.partCount-1 do equal(bank[boss.firstPart+i],nil) end
    runtime.close(run)
end

local function verifyDualCannon(withArt,flushFrame)
    local run = runtime.init(1,{player={active=true,h=0xfec,l=0x1c00},airFireRank=13,lateFireRank=7},withArt)
    local row
    for _,entry in ipairs(run.stage.spawns) do
        if entry[1] == 0x149 and entry[10] == 0x163378 then row = entry; break end
    end
    run.stage = setmetatable({spawns={assert(row)}},{__index=run.stage})
    for _,lane in ipairs(run.scroll) do
        lane.major,lane.hPixels,lane.hRest,lane.hBlock,lane.pendingH = 0x148,0xa47,0,0x148,0x40
    end
    run.randomIndex = 0x7a
    local function step()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    step()
    local aircraft = assert(run.enemies[11])
    equal(aircraft.h,0x7fc0)
    equal(aircraft.l,0x22c0)
    equal(aircraft.shotClock,0x56)
    step()
    equal(aircraft.h,0x7f62)
    equal(aircraft.l,0x22b8)
    for _ = 6531,6614 do step() end
    equal(aircraft.aims[1],0x21)
    equal(aircraft.aims[2],0x21)
    equal(next(run.bullets),nil)
    step()
    equal(run.major,0x153)
    equal(aircraft.h,0x602c)
    equal(aircraft.l,0x2010)
    local expected = {{0x5cfd,0x208f,0x6c,0xff3d,0x46},{0x5ca9,0x1f03,0x84,0xff23,0xfff3},
        {0x5d89,0x1da3,0x9c,0xff55,0xffa3},{0x6338,0x231f,0x60,0xff74,0x5e},
        {0x6234,0x21c7,0x78,0xff3d,0x18},{0x6259,0x203f,0x90,0xff47,0xffcf},
        {0x63c0,0x1f27,0xa8,0xff91,0xff92}}
    for index,shot in ipairs(expected) do
        local b = assert(run.bullets[index])
        equal(b.origin,aircraft)
        equal(b.callback,index <= 3 and 0x176400 or 0x17625c)
        equal(b.speed,index <= 3 and 0x14 or 0x12)
        equal(b.h,shot[1])
        equal(b.l,shot[2])
        equal(b.angle,shot[3])
        equal(b.dh % 0x10000,shot[4])
        equal(b.dl % 0x10000,shot[5])
    end
    equal(run.bullets[8],nil)
    step()
    equal(run.bullets[1].h,0x5c3a)
    equal(run.bullets[1].l,0x20d5)
    runtime.collision.shots(run,{shots={{h=aircraft.h,l=aircraft.l,front=0,back=0,right=0,left=0,damage=0x1001}}})
    equal(aircraft.hp,-1)
    step()
    equal(run.enemies[aircraft.slot],nil)
    equal(run.partSlots[aircraft.partPool][aircraft.firstPart],nil)
    equal(run.effects[1].frames,runtime.program.effects[0x89])
    equal(run.effects[1].delay,11)
    equal(run.effects[4].frames,runtime.program.effects[0x84])
    equal(run.effects[4].delay,7)
    runtime.close(run)
end

local function verifyFormation(withArt,flushFrame)
    local run = runtime.init(1,{player={active=true,h=0xfec,l=0x1c00}},withArt)
    local spawns = {}
    for _,row in ipairs(run.stage.spawns) do
        if row[10] == 0x14fcc2 then spawns[#spawns+1] = row end
    end
    equal(#spawns,2)
    run.stage = setmetatable({spawns=spawns},{__index=run.stage})
    for _,lane in ipairs(run.scroll) do
        lane.major,lane.hPixels,lane.hRest,lane.hBlock,lane.pendingH = 0x190,0xc87,0,0x190,0x40
    end
    local born = {
        [7106]={0,0xac40,0xf080,0x10,6}, [7169]={1,0x9c80,0xf080,0x10,6},
        [7194]={0,0x82c0,0x4640,0x30,5}, [7232]={2,0x8cc0,0xf080,0x10,6},
        [7263]={1,0x7180,0x4640,0x30,5}, [7295]={3,0x7d00,0xf080,0x10,6},
        [7358]={4,0x6d40,0xf080,0x10,6}, [7421]={5,0x5d80,0xf080,0x10,6},
        [7484]={6,0x4dc0,0xf080,0x10,6}, [7547]={7,0x3e00,0xf080,0x10,6},
    }
    local count = 0
    for frame = 7105,7547 do
        runtime.step(run)
        if flushFrame then flushFrame() end
        for slot = 11,58 do
            local child = run.enemies[slot]
            if child and child.elapsed == 0 then
                local expected = assert(born[frame],'编队在预期外的帧生成子机')
                equal(child.row.index,expected[1])
                equal(child.h % 0x10000,expected[2])
                equal(child.l % 0x10000,expected[3])
                equal(child.direction,expected[4])
                equal(child.speed,expected[5])
                equal(child.callback,0x15bd6a)
                count = count+1
            end
        end
        equal(#run.spawnQueue,0)
    end
    equal(count,10)
    equal(run.enemies[3],nil)
    equal(run.enemies[4],nil)
    equal(runtime.program.towards(0x60,0x20),0x20)
    runtime.close(run)
end

local function verifyBoss1(withArt,flushFrame,natural)
    local run = runtime.init(1,{player={active=true,h=0xfec,l=0x1c00}},withArt)
    -- V100 第 8025 帧与连续推进的 Lua 更新对应。实机开场少了一次逻辑推进，
    -- 所以这里用对应的逻辑更新核对发弹。
    local frame = 2718
    local function advance(target)
        while frame < target do
            frame = frame+1
            runtime.step(run)
            if flushFrame then flushFrame() end
        end
    end
    advance(8025)
    local boss = assert(run.boss,'关底生成记录未分配原生物件')
    equal(boss.callback,0x188a56)
    equal(run.major,0x204)
    equal(boss.partCount,9)
    equal(boss.partPool,2)
    equal(boss.slot>10,true)
    equal(boss.h,0xa00)
    equal(boss.l,0x4600)
    equal(boss.health,0x32600)
    equal(boss.flags,0x8000)
    run.randomIndex = 0xa6
    advance(8026)
    equal(boss.phase,3)
    equal(boss.h,0xa19)
    equal(boss.l,0x45f2)
    advance(8134)
    equal(boss.phase,0)
    equal(boss.h,0x46e0)
    equal(boss.l,0x24c3)
    equal(boss.flags,0xa001)
    equal(boss.extraParts[1].flags,0xa001)
    equal(boss.extraParts[2].flags,0xa001)
    advance(8167)
    equal(run.major,0x264)
    local arm1,arm2 = assert(boss.mounts[1].arm),assert(boss.mounts[2].arm)
    equal(arm2.slot<arm1.slot,true)
    equal(arm1.callback,0x18ab18)
    equal(arm1.h,0x5097)
    equal(arm1.l,0x1e43)
    equal(arm1.mode,4)
    equal(arm1.second.flags,0xa000)
    equal(arm1.second.front,0x700)
    advance(8252)
    run.randomIndex = 0xb0
    local function volley(expected,callback,speed)
        local count = 0
        for slot = 1,run.bulletCapacity do
            local b = run.bullets[slot]
            if b and b.origin==boss and b.callback==callback and b.flash then
                count = count+1
                local shot = assert(expected[count],'一面关底在单次发射中生成了额外敌弹')
                equal(b.speed,speed or shot[6])
                equal(b.h,shot[1])
                equal(b.l,shot[2])
                equal(b.angle,shot[3])
                equal(b.dh % 0x10000,shot[4])
                equal(b.dl % 0x10000,shot[5])
            end
        end
        equal(count,#expected)
    end
    advance(8253)
    equal(boss.phase,2)
    equal(boss.h,0x5e13)
    equal(boss.l,0x1539)
    equal(arm1.mode,8)
    volley({{0x5b4f,0x1e30,0x82,0xff2c,0xfffb},{0x5ebc,0x0c4d,0x74,0xff37,0x28}},0x175446,0x13)
    advance(8254)
    equal(boss.phase,8)
    volley({{0x5636,0x1576,0x7a,0xff19,0x15},{0x5636,0x14de,0x85,0xff18,0xffee},
        {0x5666,0x141a,0x90,0xff28,0xffc7},{0x5666,0x163a,0x6f,0xff2b,0x3d},
        {0x56f6,0x16d6,0x64,0xff4d,0x62}},0x1743b8,0x15)
    advance(8283)
    volley({{0x546c,0x1499,0x7a,0xff19,0x15},{0x546c,0x1401,0x85,0xff18,0xffee},
        {0x549c,0x133d,0x90,0xff28,0xffc7},{0x552c,0x12a1,0x9b,0xff4a,0xffa2},
        {0x549c,0x155d,0x6f,0xff2b,0x3d},{0x552c,0x15f9,0x64,0xff4d,0x62},
        {0x5604,0x1675,0x59,0xff7b,0x7f}},0x1743b8,0x15)
    advance(8452)
    run.randomIndex = 0xb8
    advance(8453)
    volley({{0x4f70,0x24e7,0x35,0x20,0x4e,0xb},{0x4e9e,0x2505,0x3a,0x15,0x66,0xe},
        {0x4f70,0x24e7,0x35,0x31,0x79,0x11},{0x4e9e,0x2505,0x3a,0x1f,0x92,0x14}},0x175f2e)
    if natural then
        local function actor(callback)
            for _,o in pairs(run.enemies) do
                if o.callback == callback then return o end
            end
        end
        advance(8489)
        local carrier = assert(actor(0x18b25e),'机臂载体未登记到敌机槽')
        equal(carrier.flags,0x8000)
        equal(carrier.h,0x54dd)
        equal(carrier.l,0x21c7)
        equal(carrier.ramp,0x17)
        advance(8490)
        equal(carrier.h,0x54d2)
        equal(carrier.l,0x21c6)
        equal(carrier.spin,0xd0)
        volley({{0x577b,0x23e1,0x87,0xff2f,0xffea},{0x5a27,0x21d5,0xb5,0xffc9,0xff79},
            {0x4aa8,0x1efc,0x83,0xff2c,0xfff7},{0x4c80,0x2168,0x55,0xff98,0x7a}},0x1749c4,0x13)
        advance(8549)
        equal(carrier.reversed,true)
        equal(carrier.h,0x344b)
        equal(carrier.l,0x1ed1)
        equal(carrier.speed,4)
        advance(8615)
        volley({{0x337f,0x20c0,0x80,0xff42,0,0x11},{0x337f,0x20c0,0x80,0xff4d,0,0x10},
            {0x337f,0x20c0,0x80,0xff59,0,0xf},{0x419f,0x1dbe,0x8c,0xff4c,0xffdc,0x11},
            {0x419f,0x1dbe,0x8c,0xff56,0xffde,0x10},{0x419f,0x1dbe,0x8c,0xff61,0xffe1,0xf}},0x17566c)
        advance(8664)
        equal(run.enemies[arm1.slot],nil)
        equal(run.enemies[arm2.slot],nil)
        equal(run.enemies[carrier.slot],nil)
        local seen = {}
        while frame < 10200 and not seen.returned do
            advance(frame+1)
            for _,b in pairs(run.bullets) do
                if b.origin == boss and b.flash then seen[b.callback] = true end
            end
            local event = boss.events[1]
            if event and event.index == 4 then seen.turn = true end
            if seen.turn and event and event.index == 3 then seen.returned = true end
        end
        equal(seen[0x175892],true)
        equal(seen[0x174f0c],true)
        equal(seen.returned,true)
        -- 两段计时各自跑完。每次核心分离必须发完规定批次，然后才能进入下一轮。
        local births,appearances,charges,wingModes = {},{},{},{}
        local firstRing,firstVessel,firstDispenser
        local dispenserH
        local firstRelease
        local firstRingFrames = {}
        local armorClock = boss.clock
        local firstTimeout = frame+armorClock
        while frame < firstTimeout+runtime.program.boss1.timeout+400 and not run.stageCleared do
            advance(frame+1)
            for _,o in pairs(run.enemies) do
                if o.boss == boss and o.kind>=0x63 and o.kind<=0x68 and o.kind~=0x64 and not appearances[o] then
                    appearances[o] = true
                    births[o.kind] = (births[o.kind] or 0)+1
                    if o.kind == 0x67 and not firstVessel then
                        firstRingFrames[#firstRingFrames+1] = frame
                        if not firstRing then firstRing = o end
                        equal(o.radius,0x80+4*(#firstRingFrames-1))
                        equal(o.spinStep,#firstRingFrames%2==1 and 4 or -4)
                    elseif o.kind == 0x66 and not firstVessel then
                        firstVessel = o
                        equal(o.health,0x100)
                        equal(o.speed,0x20)
                        equal(o.flags,0xa601)
                        equal(o.second.flags,0xa200)
                        equal(#firstRingFrames,6)
                        for index = 2,6 do equal(firstRingFrames[index]-firstRingFrames[index-1],9) end
                    elseif o.kind == 0x65 and not firstDispenser then
                        firstDispenser,dispenserH = o,o.h
                    elseif o.kind == 0x63 and not firstRelease then
                        firstRelease = frame
                    end
                end
            end
            if firstDispenser and run.enemies[firstDispenser.slot] == firstDispenser and firstDispenser.clock == 1 then
                equal(firstDispenser.h,dispenserH-0x219)
            end
            if frame == firstRelease then equal(births[0x63],16) end
            if boss.core.flags == 0xa001 then
                charges[boss.coreExposed and 2 or 1] = true
            end
            for _,mount in ipairs(boss.escorts) do
                if mount.escort and mount.escort.mode then wingModes[mount.escort.mode] = true end
            end
            if frame == firstTimeout then
                equal(boss.armDestroyed,true)
                equal(boss.clock,runtime.program.boss1.timeout)
                equal(boss.health,0x32600)
            end
        end
        assert(firstRing and firstVessel and firstDispenser and firstRelease and births[0x68]>0,
            '超时路线未执行完整的两轮核心炮击')
        equal(charges[1],true)
        equal(charges[2],true)
        equal(wingModes[8],true)
        equal(wingModes[16],true)
        equal(wingModes[20],true)
        equal(run.stageCleared,true)
        equal(boss.finalThreshold,0x32600)
        equal(run.enemies[boss.slot],nil)
        equal(next(run.enemies),nil)
        runtime.close(run)
        return
    end
    for hit = 1,3 do
        runtime.collision.shots(run,{shots={{h=boss.h-0x500,l=boss.l,front=0,back=0,right=0,left=0,damage=0xa000}}})
        equal(boss.damage,0x7800)
        advance(frame+1)
        equal(boss.health,0x32600-hit*0x7800)
    end
    equal(boss.threshold,-1)
    equal(boss.protected,true)
    equal(boss.armDestroyed,true)
    equal(run.bulletClearClock,0xf)
    advance(frame+2)
    equal(arm1.flags,0x8000)
    equal(arm2.flags,0x8000)
    equal(boss.drawParts[6],true)
    assert(next(run.effects),'护甲击破未登记爆炸')
    advance(frame+34)
    equal(run.enemies[arm1.slot],nil)
    equal(run.enemies[arm2.slot],nil)
    equal(boss.mounts[1].arm,nil)
    equal(boss.mounts[2].arm,nil)
    while frame < 8700 and not (boss.events[1] and boss.events[1].index == 8
        and boss.events[1].stage == 2) do
        advance(frame+1)
    end
    equal(boss.events[1].index,8)
    equal(boss.events[1].stage,2)
    equal(boss.protected,false)
    advance(frame+1)
    local escorts = {}
    for index,mount in ipairs(boss.escorts) do
        local escort = assert(mount.escort,'护航机未从关底事件队列生成')
        equal(escort.callback,0x189e80)
        equal(escort.mode,12)
        equal(escort.flags,0xa001)
        equal(escort.second.flags,0xa000)
        escorts[index] = escort
    end
    local escortShots = 0
    for _,b in pairs(run.bullets) do
        if b.origin.boss == boss and b.callback == 0x17566c and b.flash then
            equal(b.angle%2,0)
            equal(b.speed==0xf or b.speed==0xe,true)
            escortShots = escortShots+1
        end
    end
    assert(escortShots>0,'护航机未按八位角发射双向弹')

    -- 从独立核心的下侧命中，避免同时碰到护航机和母机判定。
    local core = boss.core
    while frame < 9410 and (core.flags ~= 0xa001 or not core.charging) do advance(frame+1) end
    equal(core.flags,0xa001)
    local threshold = boss.finalThreshold
    for hit = 1,6 do
        runtime.collision.shots(run,{shots={{h=core.h-0x900,l=core.l,front=0,back=0,right=0,left=0,damage=0x7000}}})
        equal(core.damage,0x5400)
        advance(frame+1)
        equal(boss.finalThreshold,threshold-hit*0x5400)
    end
    equal(boss.dying,true)
    equal(boss.health,-1)
    equal(boss.flags,0x8000)
    for index = 1,3 do equal(boss.extraParts[index].flags,0x8000) end
    local defeatFrame = frame
    while frame < defeatFrame+400 and not run.stageCleared do advance(frame+1) end
    equal(run.stageCleared,true)
    equal(run.enemies[boss.slot],nil)
    for _,escort in ipairs(escorts) do
        equal(run.enemies[escort.slot],nil)
        equal(escort.mount.escort,nil)
    end
    for index = boss.firstPart,boss.firstPart+boss.partCount-1 do
        equal(run.partSlots[boss.partPool][index],nil)
    end
    runtime.close(run)
end

local function verifyStage2Turret(withArt,flushFrame)
    local run = runtime.init(2,{player={active=true,h=0x1000,l=0xe00},lateFireRank=13,cameraOffset=-0x480},withArt)
    local function tick()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    for _ = 1,48 do tick() end
    local turret
    for _,o in pairs(run.enemies) do if o.kind==0x8e then turret = o end end
    assert(turret,'二面卷轴 0x03 未生成炮台')
    equal(run.major,3)
    equal(turret.callback,0x166596)
    equal(turret.h,0x7ac0)
    equal(turret.l,0x1b40)
    equal(turret.hp,0x300)
    equal(turret.part[0x1f],2)
    -- 第一组圆弹对照 V100 第 10080、10085、10090 帧。
    local rows = {{108,0x15,0x6dc0,0x8b,0xff29,0xffda},{113,0x17,0x6d40,0x88,0xff27,0xffe5},
        {118,0x18,0x6c80,0x84,0xff23,0xfff3}}
    for _,row in ipairs(rows) do
        while run.frame<row[1]-1 do tick() end
        run.randomIndex = row[2]
        tick()
        local shot
        for _,b in pairs(run.bullets) do
            if b.origin==turret and b.flash then shot = b end
        end
        assert(shot,'二面开场炮台未发弹')
        equal(shot.callback,0x174f0c)
        equal(shot.h,row[3])
        equal(shot.l,0x1a1f)
        equal(shot.angle,row[4])
        equal(shot.speed,0x14)
        equal(shot.dh%0x10000,row[5])
        equal(shot.dl%0x10000,row[6])
    end
    while turret.h>=0x6e00 do tick() end
    for hit = 1,2 do
        runtime.collision.shots(run,{shots={{h=turret.h,l=turret.l,damage=0x500,
            front=0,back=0,right=0,left=0}}})
        equal(turret.hp<0,true)
        tick()
        if hit==1 then
            equal(run.enemies[turret.slot],turret)
            equal(turret.wreck,true)
            equal(turret.hp,0x300)
        end
        local boom
        for _,effect in pairs(run.effects) do
            if effect.frames==runtime.program.effects[hit==1 and 0x84 or 0x88] then boom = effect end
        end
        assert(boom,'炮台爆破未登记原版动画')
    end
    equal(run.enemies[turret.slot],nil)
    equal(run.partSlots[turret.partPool][turret.firstPart],nil)
    runtime.close(run)
end

local function verifyStage2Carriers(withArt,flushFrame)
    local run = runtime.init(2,{player={active=true,h=0x1000,l=0xe00},lateFireRank=13,cameraOffset=-0x480,
        gunshipMainRank=0x12,patrolTrackRank=0x16},withArt)
    local function advance(target)
        while run.frame<target do
            runtime.step(run)
            if flushFrame then flushFrame() end
        end
    end
    local function find(callback)
        for _,o in pairs(run.enemies) do if o.callback==callback then return o end end
        error(('二面载具 %06x 未挂载'):format(callback))
    end
    local function volley(o,callback,rows)
        local count = 0
        for slot = 1,run.bulletCapacity do
            local shot = run.bullets[slot]
            if shot and shot.origin==o and shot.callback==callback and shot.flash then
                count = count+1
                local row = assert(rows[count],'二面载具多发了一颗弹')
                equal(shot.h,row[1])
                equal(shot.l,row[2])
                equal(shot.angle,row[3])
                equal(shot.speed,row[4])
                equal(shot.dh%0x10000,row[5])
                equal(shot.dl%0x10000,row[6])
            end
        end
        equal(count,#rows)
    end
    local function shot(h,l,damage)
        return {h=h,l=l,front=0,back=0,right=0,left=0,damage=damage}
    end
    local function destroyed(o,rows)
        equal(run.enemies[o.slot],nil)
        equal(run.partSlots[o.partPool][o.firstPart],nil)
        equal(run.partSlots[o.partPool][o.firstPart+1],nil)
        local actual = {}
        for _,effect in pairs(run.effects) do
            actual[effect.offset] = effect.frames
        end
        for _,row in ipairs(rows) do
            local kind,dh,dl = unpack(row)
            equal(actual[dh*0x10000+dl%0x10000],runtime.program.effects[kind])
        end
    end

    advance(255)
    run.randomIndex = 0x27
    advance(256)
    local large = find(0x1658c0)
    equal(run.major,0x10)
    equal(large.h%0x10000,0x8a00)
    equal(large.l,0x2780)
    equal(large.health,0x1600)
    equal(large.protection,0x1e)
    equal(large.back,0x1200)
    equal(large.base.front,0xe00)
    advance(325)
    -- 原版第 10297 帧两门侧炮分别发三颗箭弹。
    volley(large,0x175446,{{0x6c9a,0x2be9,0x82,0x15,0xff16,0xfffa},{0x6ce4,0x2b0f,0x94,0x15,0xff34,0xffb7},
        {0x6d96,0x2a9b,0xa6,0x15,0xff75,0xff84},{0x6c59,0x21f5,0x7a,0x15,0xff19,0x15},
        {0x6c68,0x211b,0x8c,0x15,0xff21,0xffd4},{0x6d02,0x2097,0x9e,0x15,0xff55,0xff99}})
    advance(375)
    equal(large.hatch,1)
    advance(395)
    equal(large.hatch,2)
    equal(large.hatchFrame,0x20)
    advance(399)
    run.randomIndex = 0x35
    advance(400)
    -- 第 10372 帧中炮发八颗圆弹，有两颗在出膛时越界。
    volley(large,0x1743b8,{{0x6af4,0x26af,0x90,0x13,0xff3d,0xffcc},{0x6d1c,0x2547,0xb0,0x13,0xffb1,0xff7e},
        {0x6ff4,0x2548,0xd0,0x13,0x4f,0xff7e},{0x6ff4,0x2a38,0x30,0x13,0x4f,0x82},
        {0x6d1c,0x2a37,0x50,0x13,0xffb1,0x82},{0x6af4,0x28cf,0x70,0x13,0xff3d,0x34}})
    advance(430)
    equal(large.hatch,3)
    advance(450)
    equal(large.hatch,0)
    runtime.collision.shots(run,{shots={shot(large.h-0x800,large.l,0x800),shot(large.h+0x600,large.l+0x900,0x800)}})
    equal(large.damage,0x600)
    equal(large.base.damage,0x600)
    advance(451)
    equal(large.health,0xa00)
    equal(large.hp,0x7fff)
    equal(large.base.hp,0x7fff)
    runtime.collision.shots(run,{shots={shot(large.h-0x800,large.l,0x1000)}})
    advance(452)
    destroyed(large,runtime.program.stage2Carriers.large.destruction)

    advance(464)
    local small = find(0x1660f4)
    equal(run.major,0x1d)
    equal(small.h%0x10000,0x82c0)
    equal(small.l,0x1680)
    equal(small.health,0x400)
    advance(505)
    volley(small,0x1749c4,{{0x6976,0x167f,0x81,0x15,0xff16,0xfffe},{0x6994,0x15db,0x87,0x15,0xff19,0xffe8},
        {0x6982,0x161d,0x84,0x19,0xfeec,0xffef}})
    advance(511)
    volley(small,0x1749c4,{{0x6760,0x167f,0x81,0x15,0xff16,0xfffe},{0x677e,0x15db,0x87,0x15,0xff19,0xffe8},
        {0x676c,0x161d,0x84,0x19,0xfeec,0xffef}})
    runtime.collision.shots(run,{shots={shot(small.h-0x600,small.l,0x600)}})
    equal(small.base.damage,0x480)
    advance(512)
    destroyed(small,runtime.program.stage2Carriers.small.destruction)
    runtime.close(run)
end

local function verifyStage2Forts(withArt,flushFrame)
    local run = runtime.init(2,{player={active=true,h=0x1000,l=0xe00},lateFireRank=13,cameraOffset=-0x480,
        gunshipMainRank=0x12,patrolTrackRank=0x16},withArt)
    local function advance(target)
        while run.frame<target do
            runtime.step(run)
            if flushFrame then flushFrame() end
        end
    end
    local function find(callback)
        for _,o in pairs(run.enemies) do if o.callback==callback then return o end end
        error(('二面设施 %06x 未挂载'):format(callback))
    end
    local function hit(o,damage,dh,dl)
        runtime.collision.shots(run,{shots={{h=o.h+dh,l=o.l+dl,front=0,back=0,right=0,left=0,damage=damage}}})
        equal(o.hp<0,true)
    end

    advance(1040)
    local shed = find(0x1668a8)
    equal(run.major,0x41)
    equal(shed.h,0x70c0)
    equal(shed.l,0x2040)
    equal(shed.flags,0xa000)
    advance(1152)
    equal(shed.hp,0x7fff)
    advance(1153)
    equal(shed.hp,0xa00)
    advance(1174)
    equal(shed.h,0x6000)
    hit(shed,0x1000,0,0)
    advance(1175)
    equal(shed.flags,0x8080)
    equal(shed.destroyClock,0x20)
    local effects = {}
    for _,effect in pairs(run.effects) do effects[effect.offset] = effect.frames end
    for _,row in ipairs(runtime.program.stage2Forts.shed.destruction) do
        local kind,dh,dl = unpack(row)
        equal(effects[dh*0x10000+dl%0x10000],runtime.program.effects[kind])
    end
    advance(1206)
    equal(run.enemies[shed.slot],shed)
    equal(shed.destroyClock,1)
    advance(1207)
    equal(run.enemies[shed.slot],nil)

    advance(1232)
    local cannons = find(0x167038)
    equal(run.major,0x4d)
    equal(cannons.h,0x7e80)
    equal(cannons.l,0x22c0)
    equal(cannons.protection,0x30)
    equal(cannons.partCount,2)
    equal(run.stageFlags[0],true)
    advance(1414)
    equal(cannons.hp,0x2800)
    -- V100 第 11386 帧，两个炮口各发一颗大弹和四颗圆弹。
    local rows = {{0x175f2e,0x68c1,0x1fb7,0x8c,0xff2c,0xffd6},{0x175c2a,0x6921,0x1f77,0xa8,0xff85,0xff86},
        {0x175c2a,0x68c1,0x2077,0x70,0xff32,0x37},{0x175c2a,0x6961,0x20d7,0x4c,0xffc1,0x8d},
        {0x175c2a,0x6a21,0x1f58,0xcc,0x3f,0xff73},{0x175f2e,0x68c0,0x1277,0x84,0xff23,0xfff3},
        {0x175c2a,0x6900,0x1217,0xa0,0xff64,0xff97},{0x175c2a,0x68e0,0x1317,0x68,0xff47,0x52},
        {0x175c2a,0x6980,0x1357,0x44,0xffec,0x93},{0x175c2a,0x6a00,0x11d8,0xc4,0x14,0xff6d}}
    local count = 0
    for slot = 1,run.bulletCapacity do
        local b = run.bullets[slot]
        if b and b.origin==cannons and b.flash then
            count = count+1
            local row = assert(rows[count],'二面双炮设施多发炮弹')
            equal(b.callback,row[1])
            equal(b.h,row[2])
            equal(b.l,row[3])
            equal(b.angle,row[4])
            equal(b.speed,0x14)
            equal(b.dh%0x10000,row[5])
            equal(b.dl%0x10000,row[6])
        end
    end
    equal(count,#rows)
    advance(1424)
    equal(cannons.burst,3)
    equal(cannons.shotClock,8)
    hit(cannons,0x4000,-0x500,0x600)
    advance(1425)
    equal(run.enemies[cannons.slot],nil)
    equal(run.partSlots[cannons.partPool][cannons.firstPart],nil)
    equal(run.partSlots[cannons.partPool][cannons.firstPart+1],nil)
    equal(run.stageFlags[0],false)
    advance(3295)
    equal(run.major,0xcd)
    local nextRow = run.stage.spawns[run.spawnIndex]
    equal(nextRow[1],0xce)
    equal(nextRow[10],0x1b1e90)
    runtime.close(run)
end

local function verifyStage2Tail(run,flushFrame)
    local function step()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    local function advance(frame)
        while run.frame<frame do step() end
    end
    local function untilMajor(major)
        while run.major<major do step() end
    end
    local function find(callback)
        for slot=1,58 do
            local o = run.enemies[slot]
            if o and o.callback==callback then return o end
        end
        error(('二面后段 %06x 未挂载'):format(callback))
    end
    local function position(o,h,l)
        equal(o.h%0x10000,h)
        equal(o.l%0x10000,l)
    end
    local function volley(origin,callback,speed,rows)
        local count = 0
        for slot=1,run.bulletCapacity do
            local b = run.bullets[slot]
            if b and b.origin==origin and b.callback==callback and b.flash then
                count = count+1
                local row = assert(rows[count],'二面后段多发炮弹')
                position(b,row[1],row[2])
                equal(b.speed,speed)
                equal(b.angle,row[3])
                equal(b.dh%0x10000,row[4])
                equal(b.dl%0x10000,row[5])
            end
        end
        equal(count,#rows)
    end
    local function shoot(o,damage)
        runtime.collision.shots(run,{shots={{h=o.h,l=o.l,front=0,back=0,right=0,left=0,damage=damage}}})
        equal(o.impact,true)
        equal(o.hp<0,true)
    end

    untilMajor(0x10c)
    step()
    local first = find(0x167e7e)
    local waveStart = run.frame
    position(first,0xa100,0xee80)
    equal(first.hp,0x200)
    equal(first.aims[1],0x1c)
    equal(first.elapsed,0)
    step()
    position(first,0xa100,0xee9d)
    equal(first.elapsed,1)
    untilMajor(0x11a)
    local lead = find(0x16778a)
    local leadStart = run.frame
    position(lead,0x8280,0x1cc0)
    equal(lead.hp,0xf00)
    equal(lead.shotClock,0x31)
    advance(leadStart+117)
    position(lead,0x6cb0,0x2917)
    -- V100 第 14922 帧。五颗圆弹从同一个炮口依次登记。
    volley(lead,0x174236,0x14,{{0x69b1,0x25f6,0x90,0xff32,0xffc9},
        {0x69b1,0x2636,0x84,0xff23,0xfff3},{0x69b1,0x2676,0x78,0xff27,0x1b},
        {0x69f1,0x25d6,0x9c,0xff55,0xffa3},{0x6a11,0x25b6,0xa8,0xff85,0xff86}})
    advance(waveStart+398)
    position(first,0x74a0,0x1b82)
    -- V100 第 14927 帧。双炮发射，其中一颗在首帧越界。
    volley(first,0x174578,0x12,{{0x6ee1,0x1c61,0x88,0xff3d,0xffe8}})

    advance(waveStart+452)
    local wave,limit = {first},5
    for _,o in pairs(run.enemies) do
        if o.callback==0x167e7e and o.part[0x1e]==3 then wave[o.index+1]=o end
    end
    for i=1,limit do equal(wave[i].index,i-1) end
    position(wave[5],0x6f00,0xee80)
    shoot(first,0xc00)
    step()
    equal(first.wreck,true)
    equal(first.flags,0x8080)
    equal(first.hp,0x800)
    advance(leadStart+195)
    shoot(lead,0x2000)
    step()
    equal(run.enemies[lead.slot],nil)
    equal(run.stageFlags[3],false)
    step()
    local release = run.frame
    for i=1,limit do equal(wave[i].releaseClock,4*i) end
    for i=1,limit do
        local o = wave[i]
        advance(release+4*i-1)
        equal(run.enemies[o.slot],o)
        step()
        equal(run.enemies[o.slot]~=o,true)
    end
    advance(waveStart+565)
    for _,o in pairs(run.enemies) do
        assert(o.callback~=0x167e7e or o.part[0x1e]~=3,'战斗结束的编队仍在登记子机')
    end

    untilMajor(0x16c)
    local tank = find(0x15a73e)
    local tankStart = run.frame
    position(tank,0x7a00,0x2880)
    equal(tank.speed,0x1e)
    equal(tank.hp,0x20)
    advance(tankStart+32)
    position(tank,0x5752,0x2880)
    volley(tank,0x1740b4,0x14,{{0x54f2,0x26ff,0x94,0xff3d,0xffba}})
    advance(tankStart+89)
    position(tank,0x3e83,0x2880)
    equal(tank.speed,0)
    equal(tank.direction,0x24)
    for age=90,102,4 do
        advance(tankStart+age)
        position(tank,0x3e83,0x2880)
        volley(tank,0x1740b4,0x14,{{0x3cc3,0x26bf,0x9c,0xff55,0xffa3}})
    end
    advance(tankStart+104)
    position(tank,0x3e79,0x287e)
    equal(tank.speed,1)
    shoot(tank,0x1000)
    step()
    equal(run.enemies[tank.slot],nil)
    untilMajor(0x1d1)
    equal(run.stage.spawns[run.spawnIndex][1],0x1d2)
    equal(run.stage.spawns[run.spawnIndex][10],0x18f0ac)
end

local function verifyStage2Boss(run,flushFrame)
    local function step()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    while run.major < 0x1d2 do step() end
    local o = assert(run.boss2)
    local start = run.frame
    local function advance(age)
        while run.frame < start + age do step() end
    end
    local function position(part,h,l)
        equal(part.h % 0x10000,h)
        equal(part.l % 0x10000,l)
    end
    local function volley(callback,speed,rows,earlier)
        local count = 0
        earlier = earlier or 0
        for i = 1,run.bulletCapacity do
            local b = run.bullets[i]
            if b and b.origin == o and b.callback == callback and b.flash then
                count = count + 1
                if count > earlier then
                    local row = assert(rows[count-earlier],'二面关底多发炮弹')
                    position(b,row[1],row[2])
                    equal(b.angle,row[3])
                    equal(b.speed,speed)
                    equal(b.dh % 0x10000,row[4])
                    equal(b.dl % 0x10000,row[5])
                end
            end
        end
        equal(count,#rows+earlier)
    end
    equal(o.callback,0x18f0ac)
    equal(o.partCount,10)
    equal(o.health,0x49bc0)
    position(o,0x49ff,0xe480)
    advance(1)
    position(o,0x4a25,0xe4d4)
    -- 原机第 17845 帧的卷轴推进了，Boss 移动与计数均停一帧。
    advance(205)
    equal(o.flags,0x8000)
    advance(206)
    position(o,0x6599,0x21ab)
    for _,index in ipairs({1,3,4,5,6}) do equal(o.extraParts[index].flags,0xa001) end
    equal(o.extraParts[2].flags,0x8000)
    run.randomIndex = 0x5f
    advance(207)
    position(o,0x659b,0x21b2)
    position(o.target,0x5b00,0x1d00)
    advance(255)
    position(o,0x6431,0x2194)
    volley(0x1749c4,0x17,{{0x4a31,0x1153,0x83,0xfeff,0xfff5}})
    advance(320)
    volley(0x175dac,0x16,{{0x4968,0x21df,0x6a,0xff2f,0x52},{0x48ec,0x207f,0x7e,0xff0a,0x06},
        {0x4948,0x1f3f,0x92,0xff24,0xffbc},{0x4a8c,0x1e57,0xa6,0xff6f,0xff7e},
        {0x4c38,0x1de7,0xba,0xffde,0xff60}})
    advance(424)
    volley(0x17566c,0x18,{{0x5eb8,0x241b,0x8c,0xff01,0xffcd},{0x6138,0x269b,0x78,0xfefb,0x21},
        {0x63d8,0x27fb,0x64,0xff33,0x70},{0x6758,0x293b,0x50,0xff9c,0xa5},
        {0x5eb7,0x181b,0x8c,0xff01,0xffcd},{0x6177,0x15fb,0xa0,0xff45,0xff82},
        {0x6477,0x14bb,0xb4,0xffb4,0xff57},{0x67f7,0x13bc,0xc8,0x31,0xff52}})
    local p = {h=o.h,l=o.l,front=0,back=0,right=0,left=0}
    equal(runtime.collision.body(run,p),o)
    equal(p.pendingHit,true)
    local function hit(age,health,dh,dl)
        advance(age)
        -- 原机探针提交了 0xc100 伤害。两个原生自弹命中合并成相同的伤害字。
        local dual = run.dual
        local h,l = o.h+(dh or 0),o.l+(dl or 0)
        run.dual = true
        runtime.collision.shots(run,{shots={
            {h=h,l=l,front=0,back=0,right=0,left=0,damage=0x6000},
            {h=h,l=l,front=0,back=0,right=0,left=0,damage=0x6100},
        }})
        run.dual = dual
        equal(o.impact,true)
        step()
        equal(o.health,health)
    end
    hit(460,0x3dac0)
    hit(464,0x319c0)
    hit(468,0x258c0)
    advance(796)
    -- V100 第 18546 帧的首轮十二方向大弹。
    volley(0x176400,0x15,{{0x5059,0x103f,0x24,0x94,0x77},{0x4e19,0x10f5,0x39,0x26,0x99},
        {0x4b21,0x10d0,0x4e,0xffb2,0x93},{0x491d,0xfbe,0x63,0xff51,0x65},
        {0x47ff,0xe20,0x78,0xff1c,0x1c},{0x4817,0xc50,0x8d,0xff23,0xffd0},
        {0x49ad,0xada,0xa2,0xff66,0xff8e},{0x4c0d,0xa04,0xb7,0xffcd,0xff6a},
        {0x4ea5,0xa17,0xcc,0x42,0xff6c},{0x50c1,0xb05,0xe1,0xa8,0xff95},
        {0x5227,0xcd9,0xf6,0xe3,0xffdc},{0x520f,0xe69,0xb,0xe1,0x28}})
    hit(930,0x197c0)
    hit(934,0xd6c0)
    position(o,0x58d8,0x1c1c)
    equal(run.randomIndex,0xa7)
    equal(o.phase,1)
    equal(o.protected,true)
    equal(o.extraParts[1].flags,0x8000)
    advance(953)
    equal(o.extraParts[5].flags,0xa001)
    step()
    equal(o.damaged,true)
    equal(run.randomIndex,0xdc)
    for _,index in ipairs({3,4,5,6}) do equal(o.extraParts[index].broken,true) end
    for _,index in ipairs({5,6}) do equal(o.extraParts[index].flags,0x8000) end
    for _,index in ipairs({3,4}) do equal(o.extraParts[index].flags,0xa001) end
    advance(1059)
    equal(o.wingExtension,14)
    equal(o.protected,true)
    step()
    equal(o.wingExtension,15)
    equal(o.protected,false)
    position(o,0x5f12,0x1c46)
    advance(1107)
    local right,left = run.enemies[11],run.enemies[12]
    equal(right.callback,0x192e3c)
    equal(left.callback,0x192e3c)
    position(o,0x6cb2,0x1c5e)
    position(right,0x4eb2,0x27de)
    position(left,0x4eb2,0x10de)
    step()
    position(right,0x4d50,0x27c2)
    position(left,0x5014,0x10fa)
    equal(right.angle,0x85)
    equal(left.angle,0x05)
    advance(1139)
    -- V100 第 18889 帧。原生路线的 Boss 槽靠前，因此另有五颗绕行球在这一帧已经射击。
    volley(0x17508e,0x18,{{0x4e6a,0x24e7,0x97,0xff1e,0xffa2},{0x4b61,0x15b6,0x83,0xfef4,0xfff4},
        {0x4e9d,0x23c4,0x96,0xff1c,0xffa6},{0x4b56,0x172f,0x86,0xfef8,0xffe8},
        {0x4eae,0x2295,0x95,0xff18,0xffa9},{0x4b57,0x18da,0x88,0xfefb,0xffdf},
        {0x4e7f,0x215a,0x93,0xff12,0xffb1},{0x4b7f,0x1a92,0x8a,0xfefd,0xffd6},
        {0x4e65,0x1ff6,0x92,0xff10,0xffb5},{0x4bab,0x1c1e,0x8d,0xff03,0xffc9},
        {0x4e13,0x1e6a,0x90,0xff09,0xffbe},{0x4bc8,0x1dec,0x90,0xff09,0xffbe},
        {0x4dc8,0x1cca,0x8d,0xff03,0xffc9},{0x4bef,0x1fba,0x92,0xff10,0xffb5},
        {0x4d6b,0x1b5e,0x8b,0xfefe,0xffd2},{0x4c34,0x2170,0x94,0xff16,0xffac},
        {0x4cf4,0x1994,0x89,0xfefd,0xffd9},{0x4c45,0x2350,0x97,0xff1e,0xffa2},
        {0x4c99,0x17d0,0x86,0xfef8,0xffe8},{0x4c4f,0x160e,0x84,0xfef7,0xfff0}},5)
    advance(1200)
    equal(run.enemies[right.slot] ~= right,true)
    equal(run.enemies[left.slot] ~= left,true)

    -- 原机第 18989 帧还有一次逻辑停顿。第 19091 帧受击后清空绕行球的发射许可。
    hit(1339,0x15c0)
    position(o,0x71aa,0x2551)
    equal(o.phase,2)
    equal(o.protected,true)
    equal(o.orbsFire,false)
    equal(run.randomIndex,0x0f)
    advance(1389)
    equal(o.protected,true)
    equal(run.randomIndex,0x69)
    step()
    position(o,0x6fbf,0x21c3)
    equal(o.protected,false)
    equal(run.randomIndex,0x76)
    local mines = {run.enemies[11],run.enemies[12],run.enemies[13]}
    for i,mine in ipairs(mines) do
        equal(mine.callback,0x192c58)
        equal(mine.boss,o)
        equal(mine.angle,(3-i)*0x55)
        equal(mine.hp,0x180)
        position(mine,0x67bf,0x21c3)
    end
    step()
    position(mines[1],0x6765,0x215e)
    position(mines[2],0x6767,0x222a)
    position(mines[3],0x6872,0x21c3)
    equal(mines[1].hp,0x7fff)
    advance(1422)
    position(mines[1],0x5c7f,0x1523)
    equal(mines[1].hp,0x180)

    -- V100 第 19237 帧，末段首组大弹过滤后留下八个方向。
    advance(1486)
    position(o,0x67f0,0x2081)
    volley(0x176400,0x0e,{{0x6398,0x1e74,0x99,0xff82,0xffc5},{0x64fe,0x1d94,0xa9,0xffad,0xffa9},
        {0x66ea,0x1d08,0xb9,0xffe7,0xff9a},{0x66ea,0x23f8,0x49,0xffde,0x64},
        {0x64fe,0x236c,0x59,0xffa7,0x54},{0x6398,0x228c,0x69,0xff7c,0x37},
        {0x62dc,0x2124,0x79,0xff66,0x10},{0x62dc,0x1fdc,0x89,0xff69,0xffea}})

    -- 选择未被分离雷挡住的机体受击点，命中后按逻辑更新次数对照 V100。
    hit(1559,-0xab40,-0x900,-0xa00)
    position(o,0x62e4,0x1e66)
    equal(o.dying,true)
    equal(o.flags,0x8000)
    for _,index in ipairs({3,4}) do equal(o.extraParts[index].flags,0x8000) end
    step()
    position(o,0x62c3,0x1e66)
    for _,enemy in pairs(run.enemies) do
        assert(enemy.callback~=0x192c58,'击破后仍有分离雷占用槽位')
    end
    advance(1560+183)
    equal(o.hidden,nil)
    step()
    equal(o.hidden,true)
    position(o,0x572c,0x1e66)
    local effectCount = 0
    for _ in pairs(run.effects) do effectCount=effectCount+1 end
    equal(effectCount,#runtime.program.boss2.defeatBlast)
    advance(1560+312)
    position(o,0x46ac,0x1e66)
    equal(run.stageCleared,nil)
    step()
    equal(run.stageCleared,true)
    equal(run.boss2,nil)
    equal(run.enemies[o.slot],nil)
    for i=o.firstPart,o.firstPart+o.partCount-1 do equal(run.partSlots[o.partPool][i],nil) end
end

local function verifyStage2MidBoss(withArt,flushFrame,defeat)
    local run = runtime.init(2,{player={active=true,h=0x1000,l=0xe00},lateFireRank=13,cameraOffset=-0x480,
        gunshipMainRank=0x12,patrolTrackRank=0x16},withArt)
    local function step()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    while run.major<0xce do step() end
    local boss = assert(run.midBoss)
    local start = run.frame
    local function advance(age)
        while run.frame<start+age do step() end
    end
    local function checkPosition(o,h,l)
        equal(o.h%0x10000,h)
        equal(o.l%0x10000,l)
    end

    equal(boss.callback,0x1b1e90)
    equal(boss.partCount,10)
    equal(boss.health,0x16800)
    run.randomIndex = 0x5e
    advance(1)
    checkPosition(boss,0x7f4d,0x2080)
    equal(boss.extraParts[1].flags,0x8000)
    advance(82)
    checkPosition(boss,0x674b,0x26b3)
    checkPosition(boss.extraParts[1],0x2a82,0x5321)
    advance(176)
    checkPosition(boss,0x626b,0x21f8)
    checkPosition(boss.extraParts[1],0x61e1,0x1eec)
    advance(177)
    checkPosition(boss,0x6271,0x21f2)
    local hitParts = {1,2,3,6,7}
    for _,i in ipairs(hitParts) do equal(boss.extraParts[i].flags,0xa001) end
    equal(run.stageFlags[2],true)
    local part = boss.extraParts[1]
    local function volley(callback,speed,rows)
        local count = 0
        for slot=1,run.bulletCapacity do
            local b = run.bullets[slot]
            if b and b.origin==part and b.callback==callback and b.flash then
                count = count+1
                local row = assert(rows[count],'二面中 Boss 多发炮弹')
                checkPosition(b,row[1],row[2])
                equal(b.angle,row[3])
                equal(b.speed,speed)
                equal(b.dh%0x10000,row[4])
                equal(b.dl%0x10000,row[5])
            end
        end
        equal(count,#rows)
    end
    -- 卷轴上还有其他敌机。分机炮口回归从原版发射前一次更新的位置和朝向起算。
    advance(192)
    run.randomIndex = 0x12
    advance(319)
    equal(boss.attackOrder,6)
    equal(boss.events[1].clock,0x50)
    advance(399)
    part.h,part.l,part.dir,part.speed = 0x4979,0x1c09,0x23,6
    run.randomIndex = 0xd9
    step()
    checkPosition(part,0x493a,0x1bfd)
    volley(0x17508e,0x14,{{0x409e,0x1bb0,0x87,0xff24,0xffe9},{0x40a6,0x1b98,0x8a,0xff28,0xffdd},
        {0x40a6,0x1b58,0x8d,0xff2d,0xffd2},{0x40b0,0x1b44,0x90,0xff32,0xffc9},
        {0x40c2,0x1b2c,0x93,0xff3a,0xffbe},{0x40f2,0x1af8,0x96,0xff42,0xffb5},
        {0x40f2,0x1af8,0x99,0xff4b,0xffab}})

    advance(431)
    part.h,part.l,part.dir,part.speed = 0x49f7,0x1844,0x3e,6
    step()
    checkPosition(part,0x4a38,0x183c)
    volley(0x174236,0x15,{{0x542e,0x1cf3,0x71,0xff27,0x37},{0x5416,0x1c71,0x7a,0xff19,0x15},
        {0x5417,0x1c25,0x83,0xff16,0xfff6},{0x5425,0x1b97,0x8c,0xff21,0xffd4},
        {0x5461,0x1b4b,0x95,0xff35,0xffb4},{0x54bf,0x1b13,0x9e,0xff55,0xff99},
        {0x5513,0x1ad7,0xa7,0xff7b,0xff81},{0x5460,0x152b,0x6b,0xff35,0x4c},
        {0x5424,0x149f,0x74,0xff21,0x2c},{0x5416,0x1451,0x7d,0xff16,0xa},
        {0x541d,0x13ef,0x86,0xff19,0xffeb},{0x542f,0x1383,0x8f,0xff27,0xffc9},
        {0x5471,0x1337,0x98,0xff3e,0xffaa},{0x54bf,0x1313,0xa1,0xff5f,0xff91}})

    if defeat then
        local function shoot(part,damage)
            runtime.collision.shots(run,{shots={{h=part.h,l=part.l,front=0,back=0,right=0,left=0,damage=damage}}})
            step()
        end
        advance(450)
        shoot(part,0x7fff)
        equal(boss.health,0x10800)
        shoot(part,0x7fff)
        equal(boss.health,0xa800)
        shoot(part,0xaaa)
        equal(boss.health,0xa000)
        equal(boss.phase2,true)
        equal(boss.protection,0x6f)
        shoot(boss.extraParts[6],0x7fff)
        equal(boss.health,0xa000)
        advance(564)
        equal(boss.protection,0)
        equal(boss.protected,false)
        advance(731)
        shoot(boss.extraParts[6],0x7fff)
        equal(boss.health,0x4000)
        shoot(boss.extraParts[6],0x7fff)
        equal(boss.health,-1)
        equal(boss.dying,true)
        for _,i in ipairs(hitParts) do equal(boss.extraParts[i].flags,0x8000) end
        local death = run.frame-start
        for wing,time in ipairs({26,58,90}) do
            advance(death+time-1)
            equal(boss.broken[wing],nil)
            step()
            equal(boss.broken[wing],true)
        end
    else
        while run.major<0x128 and run.midBoss do step() end
        equal(boss.motion,5)
        equal(boss.health,0x16800)
    end
    local deadline = run.frame+400
    while run.midBoss and run.frame<deadline do step() end
    equal(run.midBoss,nil)
    equal(run.stageFlags[0],false)
    for slot=boss.firstPart,boss.firstPart+boss.partCount-1 do
        equal(run.partSlots[boss.partPool][slot],nil)
    end
    if defeat then
        verifyStage2Tail(run,flushFrame)
        verifyStage2Boss(run,flushFrame)
    end
    runtime.close(run)
end

local function verifyStage3Road(withArt,flushFrame)
    local run = runtime.init(3,{player={active=true,h=0x1000,l=0xe00},cameraOffset=-0x480,randomIndex=0xa2,
        tankFireRank=0x13,volleyRank=6,patrolTrackRank=0x13,airFireRank=0x13,lateFireRank=0x13,
        sweepFireRank=0xd},withArt)
    local function step()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    local function advance(frame)
        while run.frame < frame do step() end
    end
    local function through(major)
        while run.major < major do step() end
    end
    local function find(callback,major)
        for _,o in pairs(run.enemies) do
            if o.callback == callback and o.row[1] == major then return o end
        end
        error(('三面卷轴 %x 缺少回调 %06x'):format(major,callback))
    end
    local function position(o,h,l)
        equal(o.h%0x10000,h)
        equal(o.l%0x10000,l)
    end
    local function volley(origin,callback,speed,rows)
        local count = 0
        for i=1,run.bulletCapacity do
            local b = run.bullets[i]
            if b and b.origin == origin and b.callback == callback and b.flash then
                count = count+1
                local row = assert(rows[count],'三面舰载炮多发弹')
                position(b,row[1],row[2])
                equal(b.angle,row[3])
                equal(b.dh%0x10000,row[4])
                equal(b.dl%0x10000,row[5])
                equal(b.speed,speed)
            end
        end
        equal(count,#rows)
    end

    through(0x16)
    local left,leftStart = find(0x151ca4,0x16),run.frame
    position(left,0x8000,0x2000)
    equal(left.health,0xc00)
    equal(left.angle,0x75)
    step()
    position(left,0x7ff4,0x1fec)
    position(left.otherSide,0x7ff4,0x1fec)
    through(0x1a)
    local guns,gunStart = find(0x154306,0x1a),run.frame
    equal(guns.health,0x1400)
    position(guns,0x8240,0x3500)
    advance(leftStart+102)
    position(left,0x6e78,0x1808)
    -- V100 第 20517 帧的三颗圆弹及第 20551 帧存活的两颗四向箭弹。
    volley(left,0x174f0c,0xc,{{0x6ef8,0x1e87,0x80,0xff7a,0},{0x6d78,0x1c87,0x80,0xff7a,0},
        {0x6bf8,0x1a47,0x80,0xff7a,0}})
    advance(leftStart+136)
    volley(left,0x175446,0x10,{{0x6f6e,0x1ab3,0x4f,0xffc0,0x6f},{0x6c83,0x15f7,0x8f,0xff5a,0xffd6}})
    advance(gunStart+143)
    position(guns,0x69cc,0x29d4)
    volley(guns,0x1749c4,0x15,{{0x674c,0x2173,0x8c,0xff21,0xffd4}})
    through(0x28)
    local right,rightStart = find(0x152a86,0x28),run.frame
    position(right,0x7b00,0x5680)
    equal(right.angle,0x4e)
    advance(rightStart+326)
    position(right,0x42f8,0x3d08)
    volley(right,0x174f0c,0x16,{{0x4b37,0x3648,0,0xf6,0}})

    local target = find(0x152a86,0x2a)
    position(target,0x55f6,0x1b56)
    local function shot(dl,damage)
        return {h=target.h,l=target.l+dl,front=0,back=0,right=0,left=0,damage=damage}
    end
    runtime.collision.shots(run,{shots={shot(-0x800,0x100),shot(0x800,0x200)}})
    equal(target.impact,true)
    equal(target.otherSide.impact,true)
    step()
    equal(target.health,0x9c0)
    runtime.collision.shots(run,{shots={shot(0x800,0x1200)}})
    step()
    equal(run.enemies[target.slot],nil)
    equal(run.partSlots[target.partPool][target.firstPart],nil)
    equal(run.partSlots[target.partPool][target.firstPart+1],nil)
    through(0x57)
    local platform,platformStart = find(0x166be8,0x57),run.frame
    position(platform,0x7980,0x2f00)
    equal(platform.hp,0x300)
    equal(platform.shotClock,0x35)
    advance(platformStart+54)
    position(platform,0x72c0,0x2f00)
    -- V100 第 21509 帧开始的两组三连发，第三组重新瞄准。
    volley(platform,0x1740b4,0x14,{{0x6bc0,0x2c5f,0x90,0xff32,0xffc9}})
    advance(platformStart+59)
    volley(platform,0x1740b4,0x14,{{0x6b40,0x2c5f,0x90,0xff32,0xffc9}})
    advance(platformStart+64)
    volley(platform,0x1740b4,0x14,{{0x6a80,0x2c5f,0x90,0xff32,0xffc9}})
    advance(platformStart+89)
    volley(platform,0x1740b4,0x14,{{0x6780,0x2c5f,0x90,0xff32,0xffc9}})
    advance(platformStart+161)
    position(platform,0x6580,0x2f00)
    volley(platform,0x1740b4,0x14,{{0x5f20,0x2b3f,0x98,0xff47,0xffae}})
    local function fireOnPlatform()
        runtime.collision.shots(run,{shots={
            {h=platform.h,l=platform.l,front=0,back=0,right=0,left=0,damage=0x500},
        }})
        equal(platform.impact,true)
        step()
    end
    fireOnPlatform()
    equal(platform.wreck,true)
    equal(platform.flags,0xa280)
    equal(platform.hp,0x300)
    equal(run.partSlots[platform.partPool][platform.firstPart],platform)
    fireOnPlatform()
    equal(run.enemies[platform.slot],nil)
    equal(run.partSlots[platform.partPool][platform.firstPart],nil)
    through(0x61)
    equal(run.stage.spawns[run.spawnIndex][1],0x62)
    equal(run.stage.spawns[run.spawnIndex+1][10],0x152384)

    through(0x62)
    local mirror,mirrorStart = find(0x152384,0x62),run.frame
    position(mirror,0x6e00,0x54c0)
    equal(mirror.angle,0xd9)
    step()
    position(mirror,0x6e1d,0x5490)
    through(0x6b)
    local sweep,sweepStart = find(0x1530fa,0x6b),run.frame
    position(sweep,0x5bc0,0x55c0)
    advance(mirrorStart+186)
    position(mirror,0x6bd2,0x31e0)
    volley(mirror,0x174f0c,0xc,{{0x6a11,0x301f,0x80,0xff7a,0},{0x68d2,0x321f,0x80,0xff7a,0},
        {0x6752,0x341f,0x80,0xff7a,0}})
    -- V100 第 21907、21914 帧，单炮在同一炮口交错发出八路和九路。
    advance(sweepStart+132)
    volley(sweep,0x1743b8,0x13,{{0x5b14,0x36df,0xa4,0xff7a,0xff94},{0x5b74,0x36bf,0xb4,0xffc4,0xff7a},
        {0x5bf4,0x36c0,0xc4,0x13,0xff74},{0x5c54,0x36e0,0xd4,0x62,0xff85},
        {0x5ad4,0x36ff,0x94,0xff47,0xffbe},{0x5ab4,0x375f,0x84,0xff2e,0xfff3},
        {0x5ab4,0x379f,0x74,0xff37,0x28},{0x5ad4,0x37ff,0x64,0xff5e,0x59}})
    advance(sweepStart+139)
    volley(sweep,0x1743b8,0x13,{{0x5aff,0x35af,0x9c,0xff5e,0xffa7},{0x5b5f,0x356f,0xac,0xff9e,0xff85},
        {0x5bbf,0x3570,0xbc,0xffed,0xff74},{0x5c1f,0x3570,0xcc,0x3c,0xff7a},{0x5c7f,0x35b0,0xdc,0x86,0xff94},
        {0x5abf,0x35cf,0x8c,0xff37,0xffd8},{0x5abf,0x362f,0x7c,0xff2e,0x0d},
        {0x5abf,0x368f,0x6c,0xff47,0x42},{0x5aff,0x36af,0x5c,0xff7a,0x6c}})
    through(0x74)
    local twins,twinsStart = find(0x153cd6,0x74),run.frame
    position(twins,0x4b00,0x5400)
    advance(twinsStart+94)
    position(twins,0x49e6,0x4260)
    volley(twins,0x1749c4,0x15,{{0x52e6,0x355f,0xa0,0xff5c,0xff92}})

    run.tankStartRank = 0x1a
    through(0x7c)
    local leftMirror = find(0x151568,0x7c)
    position(leftMirror,0x3b80,0x5680)
    equal(leftMirror.angle,0x9b)
    local raider,raiderStart = find(0x155514,0x7c),run.frame
    position(raider,0x7a81,0x980)
    equal(raider.health,0x800)
    step()
    position(raider,0x7a37,0x9c9)
    position(raider.otherSide,0x7a37,0x9c9)
    -- V100 第 22078、22108 帧，先从两翼发箭弹，随后从中央发五路圆弹。
    advance(raiderStart+31)
    volley(raider,0x175446,0x13,{{0x6e6e,0x15a0,0x85,0xff2e,0xfff0},{0x6e6d,0xdc0,0x80,0xff2c,0}})
    advance(raiderStart+61)
    volley(raider,0x174236,0x17,{{0x6127,0x15ad,0x80,0xfeff,0},{0x6127,0x154d,0x90,0xff13,0xffc1},
        {0x6167,0x152d,0xa0,0xff4d,0xff88},{0x6127,0x160d,0x70,0xff13,0x3f},{0x6167,0x162d,0x60,0xff4d,0x78}})
    advance(raiderStart+81)
    equal(raider.phase,3)
    equal(raider.remaining,1)
    local function hitRaider(dl,damage)
        runtime.collision.shots(run,{shots={
            {h=raider.h,l=raider.l+dl,front=0,back=0,right=0,left=0,damage=damage},
        }})
    end
    hitRaider(0,0x100)
    hitRaider(0x700,0x200)
    equal(raider.impact,true)
    equal(raider.otherSide.impact,true)
    step()
    equal(raider.health,0x5c0)
    hitRaider(0x700,0x800)
    step()
    equal(run.enemies[raider.slot],nil)
    equal(run.partSlots[raider.partPool][raider.firstPart],nil)
    equal(run.partSlots[raider.partPool][raider.firstPart+1],nil)
    advance(2560)
    -- V100 第 22624 帧的难度项，供后续敌机读取。
    run.tankStartRank = 0x1b
    run.tankFireRank = 0x14
    run.sweepFireRank = 0xe
    through(0xc4)
    local sweepMirror,sweepMirrorStart = find(0x15373e,0xc4),run.frame
    position(sweepMirror,0x87c0,0x5180)
    step()
    position(sweepMirror,0x87ac,0x515e)
    advance(sweepMirrorStart+168)
    -- 第 23367 帧 V100 分配八发，LuaSTG 当帧还有七个空槽。
    volley(sweepMirror,0x1743b8,0x13,{{0x6680,0x370f,0xa4,0xff7a,0xff94},{0x66e0,0x36ef,0xb4,0xffc4,0xff7a},
        {0x6760,0x36f0,0xc4,0x13,0xff74},{0x67c0,0x3710,0xd4,0x62,0xff85},
        {0x6640,0x372f,0x94,0xff47,0xffbe},{0x6620,0x378f,0x84,0xff2e,0xfff3},
        {0x6620,0x37cf,0x74,0xff37,0x28}})
    advance(sweepMirrorStart+239)
    volley(sweepMirror,0x1743b8,0x13,{{0x57f4,0x2dc1,0x98,0xff51,0xffb2},{0x5834,0x2da1,0xa8,0xff8b,0xff8c},
        {0x5894,0x2d81,0xb8,0xffd9,0xff77},{0x5914,0x2d82,0xc8,0x27,0xff77},{0x5974,0x2da2,0xd8,0x75,0xff8c},
        {0x57d4,0x2e21,0x88,0xff32,0xffe6},{0x57d4,0x2e61,0x78,0xff32,0x1a},
        {0x57f4,0x2ec1,0x68,0xff51,0x4e},{0x5834,0x2ee1,0x58,0xff8b,0x74}})
    advance(sweepMirrorStart+246)
    volley(sweepMirror,0x1743b8,0x13,{{0x5688,0x2cd3,0xa0,0xff6c,0xff9d},{0x56e8,0x2c93,0xb0,0xffb1,0xff7e},
        {0x5748,0x2c94,0xc0,0,0xff73},{0x57a8,0x2c94,0xd0,0x4f,0xff7e},
        {0x5648,0x2cf3,0x90,0xff3d,0xffcc},{0x5648,0x2d53,0x80,0xff2c,0},
        {0x5648,0x2db3,0x70,0xff3d,0x34},{0x5688,0x2dd3,0x60,0xff6c,0x63}})
    through(0x11c)
    equal(run.stage.spawns[run.spawnIndex][1],0x11d)
    equal(run.stage.spawns[run.spawnIndex][10],0x1b56c0)

    through(0x11d)
    local boss,bossStart = find(0x1b56c0,0x11d),run.frame
    local function age(n) advance(bossStart+n) end
    local function bossShots()
        local shots = {}
        for i=1,run.bulletCapacity do
            local b = run.bullets[i]
            if b and b.origin==boss and b.flash then shots[#shots+1]=b end
        end
        return shots
    end
    equal(boss.health,0x13600)
    equal(boss.partCount,8)
    equal(run.bulletCapacity,150)
    run.randomIndex = 0x10
    age(1)
    position(boss,0xa2dc,0x54e9)
    age(100)
    position(boss,0x5572,0x2a5a)
    equal(boss.hit[1].flags,0x8000)
    age(107)
    for _,p in ipairs(boss.hit) do
        equal(p.flags,0xa001)
        position(p,0x5626,0x252d)
    end
    age(189)
    position(boss,0x618a,0x1cee)
    local arrows = bossShots()
    local positions = {{0x5981,0x1ca5},{0x5969,0x1c23},{0x596f,0x1ba1},
        {0x5993,0x1b1d},{0x5a11,0x1ac5},{0x5a85,0x1a7d}}
    equal(#arrows,30)
    for i,b in ipairs(arrows) do
        local ray = math.floor((i-1)/5)+1
        position(b,unpack(positions[ray]))
        equal(b.callback,0x1749c4)
        equal(b.angle,0x6e+(ray-1)*12)
        equal(b.speed,0x12+(i-1)%5*2)
    end

    -- 用第 38597 帧状态核对开舱炮口。此前 V100 在第 38494 帧暂停了一次逻辑更新。
    age(368)
    boss.h,boss.l,run.randomIndex = 0x7025,0x158e,0x19
    step()
    position(boss,0x6fe4,0x1586)
    local opening = bossShots()
    equal(#opening,56)
    local round = opening[1]
    equal(round.callback,0x174f0c)
    position(round,0x5662,0x16db)
    equal(round.angle,0x5a)
    equal(round.speed,0x14)
    local drones = {}
    for _,o in pairs(run.enemies) do
        if o.callback==0x1b79ba then drones[o.direction] = o end
    end
    for _,angle in ipairs({0x67,0x78,0x8c,0x99}) do
        local o = assert(drones[angle],'三面中 Boss 缺少子机')
        equal(o.speed,0x13)
        equal(run.partSlots[o.partPool][o.firstPart+1],o.second)
    end

    age(500)
    local function impact(damage)
        boss.hit[1].impact,boss.hit[1].damage = true,damage
        step()
    end
    impact(0xc100)
    equal(boss.health,0x7500)
    equal(boss.protected,true)
    equal(run.stageFlags[1],false)
    impact(0x100)
    equal(boss.health,0x7500)
    age(533)
    equal((boss.broken[1] and 1 or 0)+(boss.broken[2] and 1 or 0),1)
    age(549)
    equal(boss.broken[1],true)
    equal(boss.broken[2],true)
    age(595)
    equal(boss.protected,false)
    -- 采样中第二阶段炮口从第 38855 帧的机身位置推进一帧后发射。
    age(626)
    boss.h,boss.l,boss.direction = 0x5e1b,0x1abf,0x2a
    step()
    position(boss,0x5df6,0x1a9b)
    local aimed = bossShots()
    equal(#aimed,16)
    equal(aimed[1].callback,0x17508e)
    position(aimed[1],0x4db6,0x21ba)
    equal(aimed[1].angle,0x92)
    equal(aimed[1].speed,0x1e)
    position(aimed[16],0x4456,0x12db)
    equal(aimed[16].angle,0xe8)
    equal(aimed[16].speed,0x10)

    age(820)
    local p = boss.hit[1]
    runtime.collision.shots(run,{shots={{h=p.h-0x800,l=p.l,front=0,back=0,right=0,left=0,damage=0x100}}})
    equal(p.impact,true)
    step()
    equal(boss.health,0x7440)
    impact(0x8000)
    local defeated = run.frame
    equal(boss.defeated,true)
    for _,part in ipairs(boss.hit) do equal(part.flags,0x8000) end
    advance(defeated+107)
    equal(boss.hidden,true)
    advance(defeated+267)
    equal(run.midBoss,boss)
    step()
    equal(run.midBoss,nil)
    for i=boss.firstPart,boss.firstPart+boss.partCount-1 do equal(run.partSlots[boss.partPool][i],nil) end
    through(0x169)
    equal(run.stage.spawns[run.spawnIndex][1],0x16a)

    through(0x16a)
    step()
    local escort,escortStart = find(0x15b34c,0x16a),run.frame
    position(escort,0x4c40,0xf400)
    equal(escort.hp,0x20)
    step()
    position(escort,0x4cd6,0xf4f7)
    -- V100 第 39467 帧是这个夹具中的第一个公共发弹时点。
    run.escortClockOffset = (-escortStart-29)%32
    advance(escortStart+29)
    volley(escort,0x175446,0x14,{{0x5c02,0x1540,0x80,0xff21,0}})

    through(0x194)
    local deck = find(0x1628b2,0x194)
    position(deck,0xa940,0x2080)
    equal(deck.flags,0x8000)
    equal(run.scroll[1].hSpeed,0x40)
    equal(run.scroll[2].hSpeed,0x80)
    step()
    position(deck,0xa8c0,0x2080)
    through(0x203)
    equal(run.enemies[deck.slot],nil)

    run.volleyRank,run.sweepFireRank,run.tankFireRank,run.tankStartRank = 8,0x12,0x1a,0x23
    through(0x24b)
    local hull = find(0x160a9e,0x24b)
    position(hull,0x9b80,0xfc80)
    equal(hull.health,0x1000)
    equal(hull.armed,false)
    step()
    position(hull,0x9b00,0xfc80)

    through(0x276)
    local twin,twinStart = find(0x1618bc,0x276),run.frame
    position(twin,0x80c0,0x1080)
    advance(twinStart+24)
    position(twin,0x7dc0,0x1080)
    volley(twin,0x17566c,0x17,{{0x6b1a,0x13bf,0x80,0xfeff,0},{0x6b1a,0xd3f,0x80,0xfeff,0}})

    through(0x282)
    run.randomIndex = 0x4c
    through(0x283)
    local craft,craftStart = find(0x1559d6,0x283),run.frame
    position(craft,0x7a40,0x2080)
    advance(craftStart+39)
    volley(craft,0x1749c4,0x13,{{0x6f79,0x2540,0x3c,0x13,0x8c},{0x6f19,0x253f,0x4c,0xffc4,0x86},
        {0x6f78,0x1d40,0x3c,0x13,0x8c},{0x6fd8,0x1d40,0x2c,0x62,0x7b}})

    run.volleyRank,run.tankFireRank,run.tankStartRank = 9,0x1b,0x24
    through(0x295)
    local gun,gunStart = find(0x16137a,0x295),run.frame
    position(gun,0x7c80,0xf40)
    advance(gunStart+30)
    volley(gun,0x17566c,0x16,{{0x6e5a,0xf3f,0x80,0xff0a,0}})

    through(0x2bb)
    local armed,armedStart = find(0x160a9e,0x2bb),run.frame
    position(armed,0x9b80,0x2080)
    equal(armed.armed,true)
    equal(armed.health,0x3800)
    advance(armedStart+247)
    -- 对照 V100 第 42179 帧这一颗旋转炮口弹的出膛状态。
    volley(armed,0x17508e,0x19,{{0x5cc0,0x1dbf,0x8c,0xfef7,0xffcb}})

    through(0x2ea)
    local heavy,heavyStart = find(0x154a62,0x2ea),run.frame
    position(heavy,0x8800,0x1280)
    equal(heavy.partCount,4)
    equal(heavy.health,0x2100)
    advance(heavyStart+77)
    position(heavy,0x68a7,0x1ad8)
    volley(heavy,0x175446,0x19,{
        {0x545e,0x1f1f,0x90,0xfeff,0xffbc},{0x54ee,0x1eaf,0xa0,0xff3d,0xff7d},{0x55c2,0x1e3b,0xb0,0xff98,0xff55},
        {0x5441,0x1fd7,0x80,0xfee9,0},{0x545d,0x208f,0x70,0xfeff,0x44},{0x544b,0x158b,0x88,0xfef1,0xffde},
        {0x549f,0x14d3,0x98,0xff19,0xff99},{0x5541,0x1473,0xa8,0xff66,0xff67},{0x544a,0x1623,0x78,0xfef1,0x22},
        {0x549e,0x16db,0x68,0xff19,0x67},
    })
    local function hit(o,damage)
        runtime.collision.shots(run,{shots={{h=o.h,l=o.l,front=0,back=0,right=0,left=0,damage=damage}}})
    end
    hit(heavy.extraParts[2],0x2000)
    equal(heavy.extraParts[2].impact,true)
    step()
    equal(heavy.health,0x900)
    equal(heavy.broken,true)
    equal(heavy.extraParts[2].flags,0x8000)
    equal(heavy.extraParts[3].flags,0x8000)
    advance(heavyStart+100)
    local centerShots = 0
    for _,b in pairs(run.bullets) do
        if b.origin==heavy and b.flash and b.callback==0x174f0c then centerShots=centerShots+1 end
    end
    equal(centerShots,10)
    hit(heavy,0x1000)
    equal(heavy.impact,true)
    step()
    equal(run.enemies[heavy.slot],nil)
    equal(run.partSlots[heavy.partPool][heavy.firstPart+3],nil)

    run.broadGunRank = 0x37
    through(0x310)
    local wide,wideStart = find(0x161eb4,0x310),run.frame
    position(wide,0x8a00,0x3080)
    advance(wideStart+93)
    volley(wide,0x1743b8,0x14,{{0x6be0,0x247f,0x94,0xff3d,0xffba},{0x6c20,0x245f,0xa4,0xff73,0xff8f},
        {0x6c80,0x243f,0xb4,0xffc1,0xff73},{0x65a0,0x2eff,0x94,0xff3d,0xffba},
        {0x6580,0x2f5f,0x84,0xff23,0xfff3},{0x6580,0x2f9f,0x74,0xff2c,0x2a}})

    through(0x3a1)
    local cover,coverStart = find(0x16bd8e,0x3a1),run.frame
    position(cover,0x73c0,0x2080)
    equal(cover.flags,0x8400)
    step()
    position(cover,0x7380,0x2080)
    equal(cover.hp,0x7fff)
    advance(coverStart+0x71)
    equal(cover.hp,0x2000)
    run.awakeningMode = 2
    step()
    equal(cover.flags,0xa400)
    hit(cover,0x100)
    equal(cover.impact,true)
    step()
    equal(cover.hp,0x1f40)
    equal(cover.visible,true)
    hit(cover,0x4000)
    step()
    equal(run.enemies[cover.slot],nil)
    equal(run.partSlots[cover.partPool][cover.firstPart],nil)
    run.awakeningMode = nil
    through(0x3ef)
    equal(run.stage.spawns[run.spawnIndex][1],0x3f0)
    equal(run.stage.spawns[run.spawnIndex][10],0x19319e)
    through(0x3f0)
    local boss,bossStart = assert(run.boss3),run.frame
    position(boss,0,0x2080)
    equal(boss.partCount,10)
    equal(boss.health,0x5acc0)
    equal(boss.flags,0x8000)
    step()
    position(boss,0x122,0x2080)
    equal(boss.speed,0x1a)
    -- V100 的第 45591、45599 帧卷轴照常推进，本体各停一次更新。
    for _,age in ipairs({21,29}) do
        advance(bossStart+age-1)
        run.stopPathClock = true
        step()
        run.stopPathClock = nil
    end
    advance(bossStart+68)
    position(boss,0x3bf7,0x2080)
    equal(boss.speed,0xf)
    step()
    equal(assert(boss.chain).callback,0x195426)
    equal(#boss.chain.links,12)
    advance(bossStart+145)
    position(boss,0x59d4,0x2080)
    equal(boss.flags,0x8000)
    step()
    position(boss,0x59ea,0x2080)
    equal(boss.flags,0xa001)
    equal(boss.extraParts[1].flags,0xa001)
    equal(boss.extraParts[2].flags,0xa001)
    advance(bossStart+275)
    position(boss,0x66e9,0x1e98)
    volley(boss,0x17566c,0x14,{{0x34f0,0x2386,0x6c,0xff3d,0x46},{0x349c,0x21fa,0x84,0xff23,0xfff3},
        {0x357c,0x209a,0x9c,0xff55,0xffa3},{0x3754,0x1fc2,0xb4,0xffc1,0xff73},{0x398c,0x1fc3,0xcc,0x3f,0xff73}})
    advance(bossStart+283)
    volley(boss,0x17625c,0x11,{{0x3d71,0x23ea,0x44,0xffef,0x7d},{0x39fb,0x22a8,0x64,0xff6f,0x4f},
        {0x38eb,0x2004,0x84,0xff44,0xfff5},{0x3acb,0x1da4,0xa4,0xff88,0xffa0}})
    equal(boss.chain.flags,0xa000)
    -- 探针从原版受击槽输入同一伤害，LuaSTG 侧经自弹判定写入等量伤害。
    run.dual = true
    for _,age in ipairs({1100,1104,1108,1112}) do
        advance(bossStart+age)
        hit(boss,0xc100)
        equal(boss.impact,true)
        step()
    end
    equal(boss.phase,1)
    equal(boss.health,0x2a8c0)
    equal(boss.extraParts[2].flags,0x8000)
    equal(boss.protected,true)
    local chain = assert(boss.chain)
    advance(bossStart+1210)
    equal(run.enemies[chain.slot],nil)
    equal(boss.chain,nil)
    advance(bossStart+1370)
    equal(boss.doorFrame,15)
    equal(boss.protected,false)
    for _,age in ipairs({2700,2704}) do
        advance(bossStart+age)
        hit(boss,0xc100)
        equal(boss.impact,true)
        step()
    end
    equal(boss.phase,2)
    equal(boss.health,0x126c0)
    equal(boss.extraParts[1].flags,0x8000)
    equal(boss.protected,true)
    local finalAttack
    while run.frame<bossStart+2910 and not finalAttack do
        step()
        for i=1,boss.attacks.limit do
            local task = boss.attacks[i]
            if task and task.index==11 and task.clock==0 then finalAttack=task; break end
        end
    end
    assert(finalAttack,'三面关底未挂载最终炮口轮射')
    equal(boss.protected,false)
    -- 后半段位置依赖前序随机游标。以 V100 第 48403 帧的机身位置核对这一轮炮口。
    local h,l,move,camera = boss.h,boss.l,boss.move,run.cameraOffset
    boss.h,boss.l,boss.move,run.cameraOffset = 0x56c8,0x1bfc,nil,0
    step()
    volley(boss,0x1765a4,0x14,{{0x6690,0x1bdb,0x8a,0xff28,0xffdd},{0x6638,0x1f9b,0x94,0xff3d,0xffba},
        {0x6580,0x23bb,0x9f,0xff60,0xff9a},{0x6408,0x27bb,0xaa,0xff90,0xff82},{0x6240,0x2afb,0xb4,0xffc1,0xff73},
        {0x6010,0x2d9c,0xbe,0xfff6,0xff6c},{0x59e0,0x06fc,0x41,0xfffb,0x94},{0x5cd0,0x081b,0x4a,0xffcb,0x8f},
        {0x5f70,0x0a3b,0x54,0xff99,0x82},{0x61c0,0x0cbb,0x5e,0xff6d,0x6c},{0x63c8,0x101b,0x69,0xff44,0x4e},
        {0x6540,0x13db,0x74,0xff2c,0x2a},{0x6618,0x17db,0x7f,0xff21,2}})
    boss.h,boss.l,boss.move,run.cameraOffset = h,l,move,camera
    for _,age in ipairs({4600,4604}) do
        advance(bossStart+age)
        hit(boss,0xc100)
        equal(boss.impact,true)
        step()
    end
    equal(boss.dying,true)
    equal(boss.flags,0x8000)
    for _=1,440 do
        if run.stageCleared then break end
        step()
    end
    equal(run.stageCleared,true)
    equal(run.boss3,nil)
    for i=boss.firstPart,boss.firstPart+boss.partCount-1 do equal(run.partSlots[boss.partPool][i],nil) end
    runtime.close(run)
end

local function verifyStage3MidBossRetreat(withArt,flushFrame)
    local run = runtime.init(3,{player={active=true,h=0x1000,l=0xe00},cameraOffset=-0x480,
        randomIndex=0x10},withArt)
    -- 保留本面的原版卷轴指令，只选择中 Boss，单独覆盖超时撤退分支。
    for _,row in ipairs(run.stage.spawns) do
        if row[10]==0x1b56c0 then
            run.stage = setmetatable({spawns={row}},{__index=run.stage})
            break
        end
    end
    local function step()
        runtime.step(run)
        if flushFrame and run.midBoss then flushFrame() end
    end
    while run.major<0x171 do step() end
    local boss = assert(run.midBoss,'未到超时卷轴，中 Boss 已退场')
    equal(boss.retreatQueued,true)
    step()
    equal(boss.move.index,5)
    equal(boss.speed,10)
    equal(boss.direction,0)
    equal(run.stageFlags[0],false)
    equal(run.stageFlags[1],false)
    for _=1,240 do
        if not run.midBoss then break end
        step()
    end
    equal(run.midBoss,nil)
    assert(boss.h%0x10000>=0x8e00,'中 Boss 未越过原版撤退边界')
    for i=boss.firstPart,boss.firstPart+boss.partCount-1 do equal(run.partSlots[boss.partPool][i],nil) end
    runtime.close(run)
end

local function verifyStage4Boss(run,step)
    while run.major<0x262 do step() end
    local boss,start=assert(run.boss4),run.frame
    local function age(n)
        while run.frame<start+n do step() end
    end
    local function position(part,h,l)
        equal(part.h%0x10000,h)
        equal(part.l%0x10000,l)
    end
    local function volley(callback,expected)
        local n=0
        for slot=1,run.bulletCapacity do
            local b=run.bullets[slot]
            if b and b.origin==boss and b.callback==callback and b.flash then
                n=n+1
                local row=assert(expected[n],'四面关底多发弹')
                position(b,row[1],row[2])
                equal(b.speed*256+b.angle,row[3])
                equal(b.dh%0x10000,row[4])
                equal(b.dl%0x10000,row[5])
            end
        end
        equal(n,#expected)
    end
    local cover
    for _,enemy in pairs(run.enemies) do
        if enemy.callback==0x19ec24 then cover=enemy; break end
    end
    equal(assert(cover).owner,boss)
    equal(boss.partCount,12)
    equal(boss.health,0x64c00)
    equal(boss.counters[1],0x34000)
    equal(boss.counters[2],0x20800)
    equal(boss.counters[3],0x10400)
    position(boss,0xb200,0x2080)
    position(boss.rear,0xc200,0x1c00)
    for index=0,7 do equal((index==0 and boss or boss.extraParts[index]).flags,0x8000) end
    age(364)
    -- V100 61090 帧的移动时钟暂停一次，位移继续推进。
    run.freeze=true
    step()
    run.freeze=false
    age(531)
    equal(boss.flags,0x8000)
    age(532)
    for index=0,7 do equal((index==0 and boss or boss.extraParts[index]).flags,0xa000) end
    equal(boss.protected,false)
    age(610)
    -- 取 V100 第 61335 帧的卷轴后位置和随机游标，再核对炮口与后舱跟随。
    boss.h,boss.l,boss.rear.h,boss.rear.l=0x7e98,0x2080,-0x7173,0x2080
    boss.prevH,boss.prevL,boss.deltaH,boss.deltaL=0x7e98,0x2080,0xb,0
    run.randomIndex=6
    age(611)
    position(boss,0x7e98,0x2079)
    position(boss.rear,0x8e98,0x2080)
    age(674)
    position(boss,0x7e4b,0x1f29)
    volley(0x175446,{{0x6c0b,0x23a8,0x1480,0xff21,0},{0x6c0b,0x2408,0x1070,0xff5b,0x2c},
        {0x6c0a,0x1aa8,0x1480,0xff21,0},{0x6c0a,0x1a48,0x1090,0xff5b,0xffd4}})
    volley(0x175892,{{0x544b,0x1ec8,0x168e,0xff1b,0xffc9}})
    age(738)
    position(boss,0x7b8b,0x1c20)
    volley(0x1749c4,{{0x618b,0x23bf,0x1077,0xff53,0x1a},{0x618a,0x147f,0x1089,0xff53,0xffe6}})
    age(739)
    volley(0x1749c4,{{0x6180,0x23b1,0x1075,0xff54,0x1f},{0x617f,0x1471,0x108b,0xff54,0xffe1}})

    run.dual=true
    for _,n in ipairs({952,960,968,976,984}) do
        age(n)
        local shot={h=boss.h,l=boss.l,front=0,back=0,right=0,left=0,damage=0xc100}
        runtime.collision.shots(run,{shots={shot}})
        equal(boss.impact,true)
        equal(boss.rear.impact,nil)
        step()
    end
    position(boss,0x7b49,0x1ece)
    equal(boss.counters[1],-1)
    equal(boss.health,0x28700)
    equal(boss.phase,1)
    equal(boss.protected,true)
    equal(run.bulletClearClock,0xf)
    equal(boss.flags,0x8000)
    for index=1,4 do
        equal(boss.extraParts[index].flags,0x8000)
        equal(boss.broken[index],true)
    end
    for index=5,7 do equal(boss.extraParts[index].flags,0xa000) end
    age(1167)
    equal(boss.frontVisible,false)
    local drone
    for _=1,300 do
        -- V100 62043 帧的游标用于下一帧落下的游机。
        if boss.rearSpan==0x3e0 then run.randomIndex=0x51 end
        step()
        for _,enemy in pairs(run.enemies) do
            if enemy.callback==0x19f156 then drone=enemy; break end
        end
        if drone then break end
    end
    equal(boss.rearSpan,0x400)
    equal(boss.protected,false)
    equal(assert(drone).owner,boss)
    local h,l=runtime.program.addPacked(boss.rear.h,boss.rear.l,-0x1000)
    equal(drone.h,h)
    equal(drone.l,l)
    equal(drone.delay,0xd)
    equal(drone.count,8)
    step()
    equal(drone.h,runtime.program.s16(h-0xc0))
    equal(drone.flags,0xa600)
    for _=1,13 do step() end
    local arrow
    for _,b in pairs(run.bullets) do
        if b.origin==drone and b.flash then arrow=b; break end
    end
    assert(arrow,'后舱游机未发射 V100 第 62058 帧的第一支箭弹')
    equal(arrow.callback,0x175446)
    equal(arrow.speed*256+arrow.angle,0xc0d)
    equal(arrow.dh,0x7e)
    equal(arrow.dl,0x1b)
    equal(arrow.h,runtime.program.s16(drone.h+0x100))
    equal(arrow.l,runtime.program.s16(drone.l+0x60))

    local function waitTask(bank,index,ready,maxFrames)
        for _=1,maxFrames or 600 do
            for slot=1,bank.limit do
                local task=bank[slot]
                if task and task.index==index and ready(task) then return end
            end
            step()
        end
        error(('四面关底任务 %02x 未到实测发弹前的状态'):format(index))
    end
    local function restoreRear(h,l,previousL,sideSpeed,sideDirection,sideClock)
        boss.h,boss.l,boss.prevH,boss.prevL=h,l,h,previousL
        boss.rear.h,boss.rear.l=h+0x1000,previousL
        boss.deltaH,boss.deltaL,boss.speed,boss.direction=0xb,l-previousL,1,0
        boss.sideMode,boss.sideSpeed=1,sideSpeed
        boss.sideMotion={index=1,phase=3,clock=sideClock,period=0x20,direction=sideDirection}
        boss.move.phase,boss.move.clock,boss.move.travel,boss.move.limit=1,0x1c,0x200,0x6600
    end
    waitTask(boss.events,9,function(t) return t.phase==0 and t.delay==1 end)
    -- V100 62170 帧的后舱位置与横移时钟。
    restoreRear(0x4956,0x19fb,0x1a09,2,0x10,0x17)
    step()
    position(boss.rear,0x5961,0x19fb)
    volley(0x1749c4,{{0x5860,0xdfa,0x1480,0xff21,0}})
    waitTask(boss.attacks,21,function(t) return t.clock==0 end)
    equal(boss.rearHatch,7)
    equal(boss.rearCoreOffset,0xc00)
    -- V100 62360 帧的后舱位置与横移时钟。
    restoreRear(0x5180,0x1ce8,0x1ce1,1,0x30,0x1c)
    step()
    position(boss.rear,0x618b,0x1ce8)
    volley(0x17508e,{{0x5f8b,0x1da8,0x843,0xfffa,0x3b},{0x5f8b,0x1da8,0xb43,0xfff8,0x51},
        {0x5f8b,0x1da8,0xe43,0xfff6,0x68},{0x5f8b,0x1da8,0x1143,0xfff4,0x7e},
        {0x5f8b,0x1da8,0x1443,0xfff1,0x94}})

    waitTask(boss.events,10,function(t) return t.phase==0 and t.delay==1 end)
    equal(boss.rearHatch,0)
    equal(boss.rearSpan,0)
    -- V100 第 62784 帧的俯冲状态。下一帧登记十六点弹环。
    boss.h,boss.l,boss.prevH,boss.prevL=0x3ad7,0x1c0f,0x3ad7,0x1c1d
    boss.rear.h,boss.rear.l=0x4b19,0x1c1d
    boss.deltaH,boss.deltaL,boss.speed,boss.direction=-0x37,-0xe,5,0x20
    boss.sideMode,boss.sideSpeed,boss.sideTarget=1,2,0x1900
    boss.sideMotion={index=1,phase=2,clock=0x20,period=0x20,direction=0x10,aim=0x10}
    boss.move.phase,boss.move.clock,run.randomIndex=2,0,0x79
    step()
    position(boss.rear,0x4ae2,0x1c0f)
    local ring
    for _,enemy in pairs(run.enemies) do
        if enemy.callback==0x19de96 then ring=enemy; break end
    end
    assert(ring,'四面关底未登记十六点弹环')
    equal(ring.partCount,17)
    equal(ring.angle,0x8f)
    equal(ring.radius,0x20)
    position(ring,0x6662,0x1c0f)
    step()
    position(ring,0x6569,0x1bd0)
    local nodes={{0x678a,0x1435},{0x653f,0x14cd},{0x62eb,0x1677},{0x60fb,0x18f5},
        {0x5fd3,0x1bd0},{0x5f62,0x1eaa},{0x5fec,0x2128},{0x6152,0x22d2},{0x6350,0x234c},
        {0x6593,0x22d2},{0x67e6,0x2128},{0x69d7,0x1eaa},{0x6afe,0x1bd0},{0x6b70,0x18f5},
        {0x6ae5,0x1677},{0x6980,0x14cd}}
    local bound={}
    for _,b in pairs(run.bullets) do
        if b.origin==ring then bound[b.anchor]=b end
    end
    for i,p in ipairs(ring.extraParts) do
        position(p,unpack(nodes[i]))
        local b=assert(bound[p],'原版弹环点没有关联敌弹槽')
        position(b,unpack(nodes[i]))
        equal(b.callback,0x177590)
    end
    for _=1,133 do step() end
    position(ring,0xe40c,0xfb15)
    equal(run.enemies[ring.slot],ring)
    step()
    assert(run.enemies[ring.slot]~=ring,'离场弹环仍占用敌机槽')
    for _,b in pairs(run.bullets) do assert(b.origin~=ring,'离场弹环仍占用敌弹槽') end

    waitTask(boss.attacks,24,function(t) return t.wait==0 end)
    restoreRear(0x3e52,0x1f34,0x1f2d,0,0x10,0x17)
    boss.rear.h=0x4e5d
    boss.sideTarget,boss.sideMotion.phase,boss.sideMotion.aim=0x2100,2,0x10
    step()
    local pulse
    for _,b in pairs(run.bullets) do
        if b.origin==boss and b.flash and b.callback==0x17508e then pulse=b; break end
    end
    assert(pulse,'后舱开门后未发出第 63075 帧的首弹')
    position(pulse,0x4b68,0x1ed3)
    equal(pulse.speed*256+pulse.angle,0x1191)
    equal(pulse.dh,-0xad)
    equal(pulse.dl,-0x31)

    waitTask(boss.attacks,18,function(t) return t.clock==0 end)
    restoreRear(0x4062,0x1e54,0x1e5b,1,0x30,0x17)
    boss.rear.h=0x506d
    step()
    local seed
    for _,enemy in pairs(run.enemies) do
        if enemy.callback==0x19edb8 then seed=enemy; break end
    end
    assert(seed,'四面后舱未登记第 63123 帧的游机')
    position(seed,0x5078,0xe54)
    step()
    position(seed,0x4fb8,0xe4d)
    for _=1,23 do step() end
    equal(seed.h,0x3e78)
    seed.l,boss.deltaL,boss.prevL=0xe2a,-7,boss.l+7
    step()
    position(seed,0x3db8,0xe23)
    local sparks={}
    for _,enemy in pairs(run.enemies) do
        if enemy.callback==0x19ef3a then sparks[enemy.shotSpeed]=enemy end
    end
    step()
    local positions={{0x3de9,0xe54},{0x3e0e,0xe78},{0x3e33,0xe9d},{0x3e58,0xec2},{0x3e7e,0xee7}}
    for i,point in ipairs(positions) do
        local spark=assert(sparks[(i-1)*2],'后舱游机未放出原版的五个子机')
        position(spark,unpack(point))
        equal(spark.angle,0x28)
    end
    for _=1,16 do step() end
    local emitted={}
    for _,b in pairs(run.bullets) do
        if b.flash and sparks[b.origin.shotSpeed]==b.origin then
            emitted[b.origin.shotSpeed]=b
        end
    end
    for speed in pairs(sparks) do
        local b=assert(emitted[speed],'后舱光点未向下发射箭弹')
        equal(b.callback,0x175446)
        equal(b.speed*256+b.angle,(0x14+speed)*256+0x80)
    end
    waitTask(boss.events,9,function() return true end,800)

    local function impact(damage)
        local rear=boss.rear
        local shot={h=rear.h,l=rear.l,front=0,back=0,right=0,left=0,damage=damage}
        runtime.collision.shots(run,{shots={shot}})
        equal(rear.impact,true)
        step()
    end
    for _=1,3 do impact(0xc100) end
    equal(boss.phase,2)
    equal(boss.health,0x4400)
    equal(boss.counters[2],-1)
    equal(boss.extraParts[6].flags,0x8000)
    equal(boss.extraParts[7].flags,0x8000)
    equal(boss.rear.flags,0xa000)
    waitTask(boss.events,12,function(t) return t.delay==1 end)
    -- 第 63909 帧的后舱位置用于验证终段炮组的挂点。
    restoreRear(0x5221,0x1b6e,0x1b60,2,0x10,0x17)
    boss.rear.h=0x622c
    step()
    local core
    for _,enemy in pairs(run.enemies) do
        if enemy.callback==0x19ea9e then core=enemy; break end
    end
    assert(core,'四面最终阶段缺少浮动炮组')
    equal(core.partCount,9)
    position(core,0x6237,0x1b60)
    step()
    position(core,0x7a37,0x1b6e)
    local guns={{0x789f,0x20c8},{0x7639,0x1f40},{0x7632,0x1b82},{0x7876,0x17b9},
        {0x7bc9,0x1628},{0x7e36,0x179b},{0x7e3d,0x1b58},{0x7bf8,0x1f21}}
    for i,point in ipairs(guns) do position(core.extraParts[i],unpack(point)) end

    waitTask(boss.attacks,23,function(t) return t.wait==0 end)
    -- 第 64005 帧后舱下降，第一颗横移母弹即将出膛。
    restoreRear(0x3d5f,0x1f26,0x1f2d,1,0x30,0x17)
    boss.rear.h,boss.deltaH,boss.speed,boss.direction=0x4db8,-0x43,6,0x20
    boss.move={index=13,phase=1,clock=2}
    step()
    local parent
    for _,b in pairs(run.bullets) do
        if b.origin==boss and b.callback==0x17740e then parent=b; break end
    end
    assert(parent,'四面最终阶段未登记横移母弹')
    position(parent,0x5575,0x1e66)
    equal(parent.speed*256+parent.angle,0xc0)
    equal(parent.shots,0x10)
    for _=1,13 do step() end
    position(parent,0x5581,0x1c28)
    equal(parent.shots,0xf)
    local child
    for _,b in pairs(run.bullets) do if b.origin==parent then child=b; break end end
    assert(child,'四面最终阶段母弹未朝自机放出子弹')
    equal(child.speed*256+child.angle,0x158c)

    impact(0x5000)
    equal(boss.phase,3)
    equal(boss.rear.flags,0x8000)
    equal(boss.counters[3],-1)
    local killed=run.frame
    for _=1,202 do step() end
    assert(run.enemies[core.slot]~=core,'击破后浮动炮组未退出')
    equal(boss.rearVisible,false)
    while not run.stageCleared and run.frame-killed<480 do step() end
    equal(run.stageCleared,true)
    equal(run.boss4,nil)
    equal(run.frame-killed,348)
    for i=boss.firstPart,boss.firstPart+boss.partCount-1 do equal(run.partSlots[boss.partPool][i],nil) end
end

local function verifyStage4Armor(withArt,flushFrame)
    local run = runtime.init(4,{stageMode=3,cameraOffset=-0x480,player={h=0x1000,l=0xe00,active=true},
        randomIndex=0x18,tankStartRank=0x28,tankFireRank=0x1e,volleyRank=0xa,sweepFireRank=0x14},withArt)
    local function step()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    local function through(major)
        while run.major<major do step() end
    end
    local function advance(frame)
        while run.frame<frame do step() end
    end
    local function find(callback)
        for _,o in pairs(run.enemies) do if o.callback==callback then return o,run.frame end end
        error(('四面缺少回调 %06x'):format(callback))
    end
    local function position(o,h,l)
        equal(o.h%0x10000,h)
        equal(o.l%0x10000,l)
    end
    local function volley(o,callback,expected)
        local index = 0
        for i=1,run.bulletCapacity do
            local b = run.bullets[i]
            if b and b.origin==o and b.callback==callback and b.flash then
                index = index+1
                local row = assert(expected[index],'四面装甲敌机多发弹')
                position(b,row[1],row[2])
                equal(b.speed*256+b.angle,row[3])
                equal(b.dh%0x10000,row[4])
                equal(b.dl%0x10000,row[5])
            end
        end
        equal(index,#expected)
    end
    local function shot(h,l,damage)
        return {h=h,l=l,front=0,back=0,right=0,left=0,damage=damage}
    end

    through(0x7)
    local air,airStart = find(0x168b56)
    position(air,0x4940,0x55c0)
    equal(air.health,0x1600)
    step()
    position(air,0x4961,0x554c)
    runtime.collision.shots(run,{shots={shot(air.h,air.l,0x100)}})
    equal(air.impact,true)
    step()
    equal(air.health,0x1600)
    advance(airStart+103)
    -- V100 第 51133 帧，机首两束各四发圆弹。
    position(air,0x5ed2,0x3180)
    volley(air,0x175dac,{{0x5962,0x3607,0x1569,0xff3a,0x52},{0x58ea,0x3527,0x1575,0xff1f,0x28},
        {0x58c6,0x347f,0x1581,0xff16,0xfffe},{0x58eb,0x3397,0x158d,0xff23,0xffd0},
        {0x5d57,0x2c30,0x15c9,0x33,0xff6a},{0x5c53,0x2c28,0x15bd,0xfff1,0xff64},
        {0x5b27,0x2c47,0x15b1,0xffac,0xff6f},{0x5a2f,0x2cb3,0x15a5,0xff71,0xff86}})
    advance(airStart+168)
    -- V100 第 51198 帧，左右开舱后锁定方向发六颗箭弹。
    equal(air.flapOpen,true)
    volley(air,0x175446,{{0x50fd,0x348b,0x1a91,0xfef8,0xffb4},{0x51ad,0x33ef,0x1a9d,0xff27,0xff83},
        {0x5265,0x3373,0x1aa9,0xff66,0xff5e},{0x50e9,0x2b33,0x1a8c,0xfeec,0xffc9},
        {0x5161,0x2a93,0x1a98,0xff10,0xff95},{0x522d,0x2a0f,0x1aa4,0xff49,0xff6d}})
    runtime.collision.shots(run,{shots={shot(air.h,air.l,0x1000),shot(air.h+0x700,air.l,0x1000)}})
    equal(air.impact,true)
    equal(air.extraParts[1].impact,true)
    step()
    equal(run.partSlots[air.partPool][air.firstPart],nil)
    equal(run.partSlots[air.partPool][air.firstPart+1],nil)
    equal(run.enemies[air.slot],nil)

    through(0x1a)
    local mirror,mirrorStart = find(0x169f38)
    position(mirror,0x8740,0x140)
    equal(mirror.partCount,3)
    equal(mirror.flags,0x8000)
    advance(mirrorStart+130)
    position(mirror,0x6742,0xbea)
    equal(mirror.flags,0xa000)
    equal(mirror.extraParts[1].flags,0xa000)
    equal(mirror.extraParts[1].front,0x1ee)
    equal(mirror.extraParts[1].left,0x574)
    equal(mirror.extraParts[2].flags,0x8000)
    volley(mirror,0x174f0c,{{0x5e3e,0x1155,0x1164,0xff6f,0x4f},{0x5d9a,0x1091,0x1172,0xff4f,0x2a},
        {0x5d76,0xfa9,0x1180,0xff42,0},{0x5daf,0xe99,0x118e,0xff4f,0xffd6},{0x5e5f,0xdfd,0x119c,0xff6f,0xffb1}})

    through(0x34)
    local tank,tankStart = find(0x169214)
    position(tank,0x7280,0x3080)
    equal(tank.hp,0xa00)
    advance(tankStart+97)
    position(tank,0x55d4,0x3080)
    volley(tank,0x1749c4,{{0x4f9d,0x2cc7,0x1288,0xff3d,0xffe8},{0x4f9d,0x2cc7,0x1488,0xff27,0xffe5},
        {0x5025,0x2bb7,0x1298,0xff5a,0xffb6},{0x5025,0x2bb7,0x1498,0xff47,0xffae},
        {0x5129,0x2b17,0x12a8,0xff91,0xff92},{0x5129,0x2b17,0x14a8,0xff85,0xff86}})
    runtime.collision.shots(run,{shots={shot(tank.h,tank.l,0x1000)}})
    equal(tank.impact,true)
    step()
    equal(run.enemies[tank.slot],nil)

    through(0x6e)
    local carrier,carrierStart = find(0x169876)
    position(carrier,0x8040,0x2240)
    advance(carrierStart+56)
    position(carrier,0x7278,0x1da8)
    volley(carrier,0x174f0c,{{0x6949,0x1aa7,0x116c,0xff5b,0x3b},{0x68f5,0x19b3,0x117a,0xff45,0x11},
        {0x6902,0x18ef,0x1188,0xff48,0xffe9},{0x698a,0x17df,0x1196,0xff5f,0xffc1},{0x6a56,0x175b,0x11a4,0xff88,0xffa0}})

    through(0x101)
    equal(run.stage.spawns[run.spawnIndex][1],0x102)
    equal(run.stage.spawns[run.spawnIndex][10],0x1b8026)
    through(0x102)
    equal(find(0x1b8026),run.midBoss)
    through(0x255)
    assert(run.stage4Gunship,'后段炮舰在补位坦克登记时仍在场')
    for _,enemy in pairs(run.enemies) do assert(enemy.callback~=0x159e88) end
    through(0x261)
    equal(run.midBoss,nil)
    equal(run.stage4Gunship,nil)
    equal(run.stage.spawns[run.spawnIndex][1],0x262)
    equal(run.stage.spawns[run.spawnIndex][10],0x197d7e)
    verifyStage4Boss(run,step)
    runtime.close(run)
end

local function verifyStage4MidBoss(withArt,flushFrame,defeat)
    local run = runtime.init(4,{stageMode=3,cameraOffset=-0x480,player={h=0x1000,l=0xe00,active=true},
        randomIndex=0x83,tankFireRank=0x1e,volleyRank=0xa},withArt)
    for _,row in ipairs(run.stage.spawns) do
        if row[10]==0x1b8026 then
            run.stage=setmetatable({spawns={row}},{__index=run.stage})
            break
        end
    end
    local function step()
        runtime.step(run)
        if flushFrame and run.midBoss then flushFrame() end
    end
    while run.major<0x102 do step() end
    local boss,start = assert(run.midBoss),run.frame
    local function age(n)
        while run.frame<start+n do step() end
    end
    local function position(o,h,l)
        equal(o.h%0x10000,h)
        equal(o.l%0x10000,l)
    end
    local function volley(callback,expected)
        local n=0
        for slot=1,run.bulletCapacity do
            local b=run.bullets[slot]
            if b and b.origin==boss and b.callback==callback and b.flash then
                n=n+1
                local row=assert(expected[n],'四面中 Boss 多发弹')
                position(b,row[1],row[2])
                equal(b.speed*256+b.angle,row[3])
                equal(b.dh%0x10000,row[4])
                equal(b.dl%0x10000,row[5])
            end
        end
        equal(n,#expected)
    end
    equal(boss.health,0x26c00)
    equal(boss.partCount,12)
    age(1)
    position(boss,0x8ef7,0x490)
    age(2)
    position(boss,0x8df2,0x4b1)
    age(87)
    equal(boss.hit[1].flags,0x8000)
    age(88)
    position(boss,0x49cc,0x1e2a)
    for _,part in ipairs(boss.hit) do equal(part.flags,0xa001) end
    age(138)
    -- V100 55219 帧，单翼四发箭弹。
    position(boss,0x4831,0x1c94)
    volley(0x17566c,{{0x3e50,0xc93,0x179a,0xff34,0xff9c},{0x3e30,0xd73,0x1586,0xff19,0xffeb},
        {0x3e30,0xe73,0x1372,0xff3a,0x2f},{0x3e70,0xf13,0x115e,0xff83,0x5c}})
    age(170)
    -- V100 55251 帧，两侧转炮各四发圆弹。
    position(boss,0x4aed,0x1c92)
    volley(0x175dac,{{0x4748,0x23d1,0x1181,0xff42,0xfffe},{0x4765,0x2319,0x118e,0xff4f,0xffd6},
        {0x47bd,0x22bb,0x119b,0xff6d,0xffb4},{0x4849,0x226d,0x11a8,0xff97,0xff98},
        {0x46e2,0x1449,0x1171,0xff50,0x2c},{0x46c6,0x1391,0x117e,0xff42,5},
        {0x46d9,0x132d,0x118b,0xff4a,0xffe0},{0x4725,0x128d,0x1198,0xff63,0xffba}})
    age(431)
    equal(boss.wingHatch,15)
    age(448)
    position(boss,0x5c88,0x14bd)
    volley(0x1765a4,{{0x55e0,0x23ac,0x136c,0xff47,0x42},{0x5556,0x21fc,0x1380,0xff2c,0},
        {0x5601,0x202c,0x1394,0xff47,0xffbe},{0x5797,0x1f10,0x13a8,0xff8b,0xff8c},
        {0x5a29,0x1e79,0x13bc,0xffed,0xff74},{0x5c7b,0x1ea9,0x13d0,0x4f,0xff7e},
        {0x5e9f,0x1fbb,0x13e4,0xa2,0xffa7},{0x5795,0x9ad,0x1356,0xff96,0x77},
        {0x55ff,0x891,0x136a,0xff4c,0x47},{0x5555,0x6c1,0x137e,0xff2c,5},
        {0x55e0,0x511,0x1392,0xff42,0xffc5},{0x5796,0x3d5,0x13a6,0xff83,0xff90},
        {0x59e8,0x33d,0x13ba,0xffe3,0xff76},{0x5c7a,0x36e,0x13ce,0x47,0xff7b}})
    if defeat then
        local function hit(amount)
            -- 第一处判定右缘以内，第二与第三处的上下边界以外。
            local shot={h=boss.h+0x1000,l=boss.l,front=0,back=0,right=0,left=0,damage=amount}
            runtime.collision.shots(run,{shots={shot}})
            equal(boss.hit[1].impact,true)
            equal(boss.hit[2].impact,nil)
            equal(boss.hit[3].impact,nil)
            step()
        end
        run.dual=true
        age(500)
        hit(0xc100)
        equal(boss.health,0x1ab00)
        age(504)
        hit(0xc100)
        equal(boss.health,0xea00)
        equal(boss.phaseTwo,true)
        equal(boss.protected,true)
        age(585)
        equal(boss.protected,false)
        age(598)
        -- 全局受击演出也会消耗随机字节，开舱时取原版的游标。
        run.randomIndex=0xf0
        age(599)
        equal(boss.coreHatch,7)
        age(614)
        -- 55695 帧的移动状态。下一帧的弹靠近回收边界，要用绝对坐标核对。
        boss.h,boss.l,boss.speed,boss.direction=0x5ce9,0x1c71,2,0x20
        boss.move.angle,boss.move.clock,run.randomIndex=0x20,2,2
        age(615)
        position(boss,0x5cd3,0x1c71)
        volley(0x175f2e,{{0x6f33,0x1ff4,0x1e44,0xffe2,0xdd},{0x6ce1,0x1f5c,0x1e59,0xff41,0xb5},
            {0x6af5,0x1dd8,0x1e6e,0xfed4,0x5d},{0x6aad,0x1c2e,0x1e83,0xfeb1,0xfff1},
            {0x6b7b,0x1a64,0x1e98,0xfeeb,0xff85},{0x6d81,0x1940,0x1ead,0xff6c,0xff3a}})
        age(618)
        position(boss,0x5c92,0x1c6e)
        volley(0x175446,{{0x534c,0x1f2f,0x175a,0xff68,0x88},{0x51b4,0x1dd5,0x176f,0xff16,0x43},
            {0x516c,0x1c0b,0x1784,0xff02,0xfff1},{0x523a,0x1a61,0x1799,0xff30,0xff9f},
            {0x54a0,0x1919,0x17ae,0xff95,0xff67}})
        age(870)
        hit(0xc100)
        equal(boss.health,0x2900)
        age(874)
        hit(0xc100)
        equal(boss.defeated,true)
        equal(boss.move.index,6)
        for _,part in ipairs(boss.hit) do equal(part.flags,0x8000) end
        age(990)
        equal(next(boss.drawParts),nil)
        age(1100)
    else
        while run.major<0x198 do step() end
        equal(boss.retreating,true)
        equal(boss.move.index,5)
        for _=1,300 do
            if not run.midBoss then break end
            step()
        end
        assert(boss.h%0x10000>=0x8e00,'四面中 Boss 未越过原版撤退边界')
    end
    equal(run.midBoss,nil)
    for slot=boss.firstPart,boss.firstPart+boss.partCount-1 do equal(run.partSlots[boss.partPool][slot],nil) end
    runtime.close(run)
end

local function verifyStage4Gunship(withArt,flushFrame)
    local run=runtime.init(4,{stageMode=3,cameraOffset=-0x480,player={h=0x1000,l=0xe00,active=true},
        randomIndex=0xab,tankFireRank=0x16,tankReloadRank=0x38,bulletCapacity=150},withArt)
    local spawns={}
    for _,row in ipairs(run.stage.spawns) do
        if row[10]==0x155d5a or row[10]==0x159e88 then spawns[#spawns+1]=row end
    end
    run.stage=setmetatable({spawns=spawns},{__index=run.stage})
    local function step()
        runtime.step(run)
        if flushFrame and next(run.enemies) then flushFrame() end
    end
    local function through(major)
        while run.major<major do step() end
    end
    local function age(start,elapsed)
        while run.frame<start+elapsed do step() end
    end
    local function position(o,h,l)
        equal(o.h%0x10000,h)
        equal(o.l%0x10000,l)
    end
    local function volley(o,callback,rows)
        local n=0
        for slot=1,run.bulletCapacity do
            local b=run.bullets[slot]
            if b and b.origin==o and b.callback==callback and b.flash then
                n=n+1
                local row=assert(rows[n],'四面后段炮舰多发弹')
                position(b,row[1],row[2])
                equal(b.speed*256+b.angle,row[3])
                equal(b.dh%0x10000,row[4])
                equal(b.dl%0x10000,row[5])
            end
        end
        equal(n,#rows)
    end
    through(0x1a3)
    local _,ship=next(run.enemies)
    local start=run.frame
    equal(ship.health,0xb000)
    equal(ship.partCount,4)
    position(ship,0x3640,0xef80)
    age(start,1)
    position(ship,0x366d,0xf01f)
    age(start,93)
    position(ship,0x5e22,0xc48)
    volley(ship,0x175446,{{0x5796,0x110,0x10c0,0,0xff89},{0x56d6,0x14f,0x10a0,0xff83,0xffac},
        {0x4997,0xe50,0x10c0,0,0xff89},{0x48d7,0xe8f,0x10a0,0xff83,0xffac},
        {0x56d6,0x177f,0x1160,0xff7c,0x59},{0x5796,0x17c0,0x1140,0,0x7e},
        {0x48d5,0x9ff,0x1160,0xff7c,0x59},{0x4995,0xa40,0x1140,0,0x7e}})
    age(start,345)
    position(ship,0x5e2c,0x2f8a)
    volley(ship,0x176400,{{0x4a98,0x2e79,0xd90,0xff7a,0xffdd},{0x4a68,0x2f3d,0xd84,0xff71,0xfff8},
        {0x4a74,0x3001,0xd78,0xff73,0x11},{0x4abc,0x30c9,0xd6c,0xff82,0x2d},
        {0x4b78,0x3159,0xd60,0xff9b,0x44},{0x4c40,0x31c9,0xd54,0xffbd,0x54},
        {0x4c00,0x2d61,0xda8,0xffb0,0xffb1},{0x4d20,0x2d05,0xdb4,0xffd7,0xffa5},
        {0x4e2c,0x2cee,0xdc0,0,0xffa0},{0x4f58,0x2d06,0xdcc,0x29,0xffa5},
        {0x5058,0x2d62,0xdd8,0x50,0xffb1},{0x5130,0x2dde,0xde4,0x6f,0xffc4}})
    age(start,377)
    volley(ship,0x1743b8,{{0x4992,0x2e9a,0x197e,0xfee9,7},{0x499e,0x2e38,0x1985,0xfeec,0xffeb},
        {0x49c8,0x2d6e,0x198c,0xfef7,0xffcb},{0x4a1c,0x2cea,0x1993,0xff08,0xffae},
        {0x4aae,0x2c58,0x199a,0xff23,0xff93},{0x4b16,0x2c22,0x19a1,0xff40,0xff7c},
        {0x4bd2,0x2bae,0x19a8,0xff66,0xff67},{0x4cd2,0x2b46,0x19af,0xff92,0xff56},
        {0x4dbe,0x2b22,0x19b6,0xffbd,0xff4d}})
    local function shoot(target,amount)
        local shot={h=target.h,l=target.l,front=0,back=0,right=0,left=0,damage=amount}
        runtime.collision.shots(run,{shots={shot}})
        equal(target.impact,true)
        step()
    end
    run.dual=true
    shoot(ship,0x7000)
    equal(ship.health,0x4000)
    shoot(ship,0x7000)
    equal(ship.dying,1)
    equal(ship.flags,0x8000)
    equal(ship.extraParts[1].flags,0x8000)
    equal(ship.extraParts[2].flags,0x8000)
    age(run.frame,100)
    equal(run.enemies[ship.slot],nil)
    through(0x213)
    local _,mirrored=next(run.enemies)
    start=run.frame
    position(mirrored,0x3640,0x51c0)
    age(start,1)
    position(mirrored,0x366d,0x5121)
    age(start,93)
    position(mirrored,0x5e22,0x34f8)
    volley(mirrored,0x175446,{{0x5796,0x29c0,0x10c0,0,0xff89},{0x56d6,0x29ff,0x10a0,0xff83,0xffac},
        {0x4997,0x3700,0x10c0,0,0xff89},{0x48d7,0x373f,0x10a0,0xff83,0xffac},
        {0x48d5,0x32af,0x1160,0xff7c,0x59},{0x4995,0x32f0,0x1140,0,0x7e}})
    age(start,400)
    shoot(mirrored,0x6000)
    age(start,404)
    shoot(mirrored,0x6000)
    equal(mirrored.dying,1)
    run.tankFireRank=0x17
    through(0x253)
    equal(run.stage4Gunship,nil)
    local tank
    for _,enemy in pairs(run.enemies) do
        if enemy.callback==0x159e88 and enemy.l==0x1e80 then tank=enemy; break end
    end
    assert(tank,'炮舰击破后未登记补位坦克')
    start=run.frame
    position(tank,0x7b80,0x1e80)
    equal(tank.shotClock,0x11)
    age(start,1)
    position(tank,0x7a8a,0x1e80)
    age(start,18)
    position(tank,0x6c75,0x1e80)
    volley(tank,0x1740b4,{{0x69b5,0x1d9f,0x178c,0xff0c,0xffd0}})
    age(start,53)
    volley(tank,0x1740b4,{{0x59f4,0x1d9f,0x178c,0xff0c,0xffd0}})
    age(start,122)
    position(tank,0x2d1e,0x1cc4)
    equal(tank.direction,0x25)
    runtime.close(run)
end

local function startStage4Boss(withArt,flushFrame)
    local run=runtime.init(4,{stageMode=3,cameraOffset=-0x480,player={h=0x1000,l=0xe00,active=true},
        randomIndex=0xff},withArt)
    for _,row in ipairs(run.stage.spawns) do
        if row[10]==0x197d7e then
            run.stage=setmetatable({spawns={row}},{__index=run.stage})
            break
        end
    end
    local function step()
        runtime.step(run)
        if flushFrame and run.boss4 then flushFrame() end
    end
    while not run.boss4 do step() end
    return run,step
end

local function verifyStage4BossSweep(withArt,flushFrame)
    local run,step=startStage4Boss(withArt,flushFrame)
    local boss=run.boss4
    local opening
    for _=1,1800 do
        step()
        if boss.hatchFrame==6 then
            for slot=1,boss.aux.limit do
                local t=boss.aux[slot]
                if t and t.index==4 and t.clock==0 then opening=t; break end
            end
        end
        if opening then break end
    end
    assert(opening,'无伤害分支未等到船首舱门全部打开')
    -- V100 第 62134 帧以原版横移终点和随机游标进入事件 05。
    boss.h,boss.l,boss.rear.h,boss.rear.l=0x7d38,0xa50,-0x72c8,0xa50
    boss.prevH,boss.prevL,boss.deltaH,boss.deltaL=0x7d38,0xa50,0,0
    boss.sideMode,boss.speed,boss.direction=0,0,0x20
    run.randomIndex=0x13
    step()
    equal(boss.hatchFrame,7)
    equal(boss.h,0x7d2d)
    equal(boss.l,0xa50)
    equal(boss.move.index,9)
    local expected={
        {0x175446,0x5fcd,0x1670,0x1226,0x77,0x6a},{0x175446,0x5d2d,0x1690,0x1236,0x30,0x81},
        {0x175446,0x5a0d,0x166f,0x1256,0xff9b,0x71},{0x175446,0x578d,0x164f,0x1266,0xff61,0x4e},
        {0x175892,0x632d,0x11af,0x148b,0xff29,0xffda},{0x175892,0x632c,0x2cf,0x1482,0xff21,0xfffa},
        {0x175892,0x6aed,0xeaf,0x1486,0xff24,0xffec},{0x175892,0x6aec,0x5af,0x1484,0xff23,0xfff3},
    }
    local index=0
    for slot=1,run.bulletCapacity do
        local b=run.bullets[slot]
        if b and b.origin==boss and b.flash then
            index=index+1
            local row=assert(expected[index],'四面关底俯冲首轮多发弹')
            equal(b.callback,row[1])
            equal(b.h%0x10000,row[2])
            equal(b.l%0x10000,row[3])
            equal(b.speed*256+b.angle,row[4])
            equal(b.dh%0x10000,row[5])
            equal(b.dl%0x10000,row[6])
        end
    end
    equal(index,#expected)

    local crossing
    for _=1,480 do
        step()
        for slot=1,boss.events.limit do
            local t=boss.events[slot]
            if t and t.index==8 then crossing=t; break end
        end
        if crossing then break end
    end
    assert(crossing,'四面关底俯冲后未挂载横贯')
    -- V100 第 62511 帧由返回位移进入横贯。这个分支交替使用两套攻击。
    boss.h,boss.l,boss.prevH,boss.prevL=0xa04,0xa50,0xa04,0xa50
    boss.deltaH,boss.deltaL,boss.speed,boss.direction=0xb,0,1,0
    boss.rear.h,boss.rear.l=0x660e,0xa50
    boss.sideMode,boss.sideSpeed,boss.sideMotion,boss.crossingVariant=0,0,nil,1
    boss.move.phase,boss.move.clock,boss.move.travel,boss.move.limit=1,0x1c,0x100,0x1900
    run.randomIndex=0x15
    step()
    equal(boss.sideTarget,0x2a00)
    equal(boss.crossingVariant,0)
    equal(boss.h,0xa0f)
    equal(boss.rear.h,0x6619)
    -- 第四个生成槽在 0xff50，首帧超出 0x3800 的边界便回收。
    local volley={
        {0x17566c,0x98f,0x13cf,0x2c80,0xfe14,0},{0x17566c,0x98e,0xcf,0x2c80,0xfe14,0},
        {0x17566c,0x5c19,0x1550,0x2c00,0x1ec,0},{0x175dac,0x6319,0xa2f,0xc84,0xff7c,0xfff8},
        {0x175dac,0x6339,0x9cf,0xc98,0xff91,0xffcf},{0x175dac,0x63b9,0x98f,0xcac,0xffc2,0xffb2},
        {0x175dac,0x6319,0xaaf,0xc70,0xff85,0x21},{0x175dac,0x6359,0xacf,0xc5c,0xffac,0x44},
    }
    index=0
    for slot=1,run.bulletCapacity do
        local b=run.bullets[slot]
        if b and b.origin==boss and b.flash then
            index=index+1
            local row=assert(volley[index],'四面关底横贯首轮多发弹')
            equal(b.callback,row[1])
            equal(b.h%0x10000,row[2])
            equal(b.l%0x10000,row[3])
            equal(b.speed*256+b.angle,row[4])
            equal(b.dh%0x10000,row[5])
            equal(b.dl%0x10000,row[6])
        end
    end
    equal(index,#volley)

    -- 下一轮横贯走 V100 第 64505 帧的另一侧入口。
    for slot=1,boss.attacks.limit do boss.attacks[slot]=nil end
    boss.events[crossing.slot]={index=8,slot=crossing.slot}
    boss.h,boss.l,boss.prevH,boss.prevL=0xa25,0x2daf,0xa25,0x2daf
    boss.deltaH,boss.deltaL=0xb,0
    boss.rear.h,boss.rear.l=0x5f10,0x2daf
    boss.sideMode,boss.sideSpeed,boss.sideMotion=0,0,nil
    run.randomIndex=0x50
    step()
    equal(boss.sideTarget,0xe00)
    equal(boss.crossingVariant,1)
    local drone
    for _,enemy in pairs(run.enemies) do
        if enemy.callback==0x19d312 then drone=enemy; break end
    end
    assert(drone,'另一侧横贯未生成游机')
    equal(drone.h,0x530)
    equal(drone.l,0x2daf)
    equal(drone.partCount,2)
    equal(drone.direction,-8)
    equal(drone.turn,-2)
    step()
    step()
    local shot
    for _,b in pairs(run.bullets) do
        if b.origin==drone then shot=b; break end
    end
    assert(shot,'横贯游机未发首轮箭弹')
    equal(shot.callback,0x175446)
    equal(shot.speed*256+shot.angle,0x2480)

    -- V100 第 62891 帧横移结束，两侧回程炮同时准备射击。
    for slot=1,boss.attacks.limit do boss.attacks[slot]=nil end
    boss.events[crossing.slot]={index=7,slot=crossing.slot}
    boss.h,boss.l,boss.prevH,boss.prevL=0x1a37,0x2db4,0x1a37,0x2db4
    boss.rear.h,boss.rear.l,boss.deltaH,boss.deltaL=0x764c,0x2db4,0,0
    boss.sideMode,boss.sideSpeed,boss.speed,boss.sideMotion=0,0,0,nil
    run.randomIndex=0x2d
    step()
    equal(boss.move.index,10)
    equal(boss.h,0x1a42)
    equal(boss.rear.h,0x764c)
    local returnVolley={{0x5c2,0x2e14,0x340f,0x21b,0x88},{0x5c2,0x2e14,0x3410,0x218,0x8f},
        {0x3c2,0x2db3,0x1b7f,0xfed2,3},{0x3c2,0x2db3,0x1b81,0xfed2,0xfffd}}
    index=0
    for slot=1,run.bulletCapacity do
        local b=run.bullets[slot]
        if b and b.origin==boss and b.flash then
            index=index+1
            local row=assert(returnVolley[index],'四面关底回程首轮多发弹')
            equal(b.callback,0x1749c4)
            equal(b.h%65536,row[1])
            equal(b.l%65536,row[2])
            equal(b.speed*256+b.angle,row[3])
            equal(b.dh%65536,row[4])
            equal(b.dl%65536,row[5])
        end
    end
    equal(index,#returnVolley)
    for _=1,32 do step() end
    local waitingDrone
    for _,o in pairs(run.enemies) do if o.callback==0x19cf9e then waitingDrone=o; break end end
    assert(waitingDrone,'回程未生成等待放行的翼侧子机')
    equal(waitingDrone.h%65536,0xf3cb)
    equal(waitingDrone.l,0x2db4)
    equal(waitingDrone.flags,0x8000)
    for _=1,64 do step() end
    local ring
    for _,o in pairs(run.enemies) do if o.callback==0x19da78 then ring=o; break end end
    assert(ring,'回程未生成十六点弹环')
    equal(ring.h,0x168b)
    equal(ring.l,0x2db4)
    equal(ring.partCount,17)
    step()
    equal(ring.h,0x1661)
    equal(ring.l,0x2cef)
    equal(ring.extraParts[1].h,0x1737)
    equal(ring.extraParts[1].l,0x352b)
    local launched
    for _,b in pairs(run.bullets) do
        if b.origin==ring and b.callback==0x175446 and b.angle==0 then launched=b; break end
    end
    assert(launched,'回程弹环没有从第一个节点发射箭弹')
    equal(launched.h,0x178b)
    equal(launched.l,0x35f4)
    equal(launched.speed,0x16)
    for _=1,500 do
        step()
        if waitingDrone.flags==0xa601 then break end
    end
    equal(waitingDrone.flags,0xa601)
    assert(boss.returnDroneDirection,'回程结束后没有放行翼侧子机')
    runtime.close(run)
end

local function verifyStage4Timeout(withArt,flushFrame)
    local run,step=startStage4Boss(withArt,flushFrame)
    local boss=run.boss4
    local start,phases=run.frame,{}
    for _=1,23000 do
        step()
        if boss.phase>0 and not phases[boss.phase] then phases[boss.phase]=run.frame-start end
        if run.stageCleared then break end
    end
    equal(phases[1],0x1c21)
    equal(phases[2]-phases[1],0x1c20)
    equal(phases[3]-phases[2],0x1c20)
    equal(boss.health,0x64c00)
    equal(run.stageCleared,true)
    equal(run.frame-start-phases[3],348)
    for i=boss.firstPart,boss.firstPart+boss.partCount-1 do equal(run.partSlots[boss.partPool][i],nil) end
    runtime.close(run)
end

local function verifyStage5(withArt,flushFrame)
    local run=runtime.init(5,{stageMode=3,cameraOffset=-0x480,player={h=0x1000,l=0xe00,active=true},
        randomIndex=0xd3,volleyRank=0xd,sweepFireRank=0x1b,tankStartRank=0x28,tankFireRank=0x28},withArt)
    local function step()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    local function through(major)
        for _=1,3000 do
            if run.major>=major then return end
            step()
        end
        error(('五面卷轴未到 %04x'):format(major))
    end
    local function find(callback)
        for _,o in pairs(run.enemies) do if o.callback==callback then return o end end
        error(('五面未登记敌机 %06x'):format(callback))
    end
    local function position(o,h,l)
        equal(o.h%0x10000,h)
        equal(o.l%0x10000,l)
    end
    local function volley(origin,callback,rows)
        local index=0
        for slot=1,run.bulletCapacity do
            local b=run.bullets[slot]
            if b and b.origin==origin and b.callback==callback and b.flash then
                index=index+1
                local row=assert(rows[index],'五面炮舰多发弹')
                position(b,row[1],row[2])
                equal(b.speed*256+b.angle,row[3])
                equal(b.dh%0x10000,row[4])
                equal(b.dl%0x10000,row[5])
            end
        end
        equal(index,#rows)
    end
    through(0xe)
    position(find(0x159b3a),0x7800,0x1c80)
    through(0x17)
    position(find(0x164fd8),0x8b80,0x1d00)
    through(0x26)
    local ship=find(0x16b26c)
    position(ship,0x82c0,0x2e00)
    equal(ship.health,0x1800)
    equal(ship.partCount,2)
    step()
    position(ship,0x820d,0x2e00)
    for _=2,47 do step() end
    position(ship,0x678d,0x2e00)
    equal(ship.wingFrame,15)
    volley(ship,0x175446,{
        {0x62a5,0x33a7,0x1673,0xff18,0x32},{0x628a,0x3273,0x1685,0xff0d,0xffed},
        {0x631e,0x3137,0x1697,0xff31,0xffaa},{0x6422,0x3097,0x16a9,0xff7e,0xff77},
        {0x65ce,0x3027,0x16bb,0xffe5,0xff5e},{0x658a,0x266f,0x16b6,0xffc5,0xff62},
        {0x63ea,0x26f3,0x16a4,0xff65,0xff83},{0x62de,0x27bf,0x1692,0xff24,0xffbc},
        {0x6281,0x28ff,0x1680,0xff0a,0},{0x62b9,0x2a0f,0x166e,0xff24,0x44},
    })
    for _=1,68 do step() end
    equal(ship.phase,6)
    run.randomIndex=0xd3
    step()
    position(ship,0x5936,0x2e00)
    volley(ship,0x174f0c,{
        {0x4d36,0x3098,0x103a,0x19,0x75},{0x4a52,0x300b,0x105a,0xff96,0x5f},
        {0x48f2,0x2e4b,0x107a,0xff50,0x10},{0x49b2,0x2c53,0x109a,0xff72,0xffba},
        {0x4c36,0x2b67,0x10ba,0xffe7,0xff8b},
    })
    run.dual=true
    local shots={}
    for i,offset in ipairs({0,0x800}) do
        shots[i]={h=ship.h+offset,l=ship.l,front=0,back=0,right=0,left=0,damage=0x1000}
    end
    runtime.collision.shots(run,{shots=shots})
    equal(ship.impact,true)
    equal(ship.extraParts[1].impact,true)
    step()
    assert(run.enemies[ship.slot]~=ship,'五面炮舰双部件受击后未退出')
    for i=ship.firstPart,ship.firstPart+ship.partCount-1 do equal(run.partSlots[ship.partPool][i],nil) end
    through(0x8c)
    local turretShip=find(0x16ac34)
    position(turretShip,0x6b00,0xc80)
    equal(turretShip.flags,0x8000)
    equal(turretShip.aim,0x1f)
    for _=1,73 do step() end
    position(turretShip,0x5574,0xc80)
    equal(turretShip.flags,0xa000)
    volley(turretShip,0x176400,{{0x51e0,0xccf,0x1670,0xff1e,0x3c},
        {0x51a8,0xbbf,0x1680,0xff0a,0},{0x51e1,0xaaf,0x1690,0xff1e,0xffc4}})
    for _=1,6 do step() end
    volley(turretShip,0x176400,{{0x5018,0xccf,0x1870,0xff09,0x42},
        {0x4fe0,0xbbf,0x1880,0xfef4,0},{0x5019,0xaaf,0x1890,0xff09,0xffbe}})
    through(0xb2)
    local ark=find(0x164166)
    position(ark,0x8940,0x4300)
    equal(ark.partCount,2)
    equal(run.stageFlags[0],true)
    step()
    position(ark,0x88f6,0x42b7)
    for _=2,69 do step() end
    position(ark,0x758f,0x2f8f)
    volley(ark,0x1743b8,{{0x63ad,0x2ea4,0x167c,0xff0d,0xf},{0x63b4,0x2e42,0x1687,0xff0e,0xffe6},
        {0x63d8,0x2dbe,0x1692,0xff24,0xffbc},{0x643e,0x2d78,0x169d,0xff48,0xff97},
        {0x64aa,0x2d2a,0x16a8,0xff78,0xff7a}})
    for _=1,65 do step() end
    volley(ark,0x175446,{
        {0x58ba,0x2e6f,0x1073,0xff57,0x25},{0x5896,0x2d87,0x107f,0xff4d,2},
        {0x58bb,0x2cdf,0x108b,0xff54,0xffe1},{0x5933,0x2bff,0x1097,0xff69,0xffc1},
        {0x59df,0x2b9b,0x10a3,0xff8c,0xffa7},{0x5af7,0x2b0f,0x10af,0xffb9,0xff93},
        {0x5be3,0x2aef,0x10bb,0xffec,0xff8a},{0x5932,0x1d0f,0x1067,0xff6f,0x44},
        {0x58ba,0x1c6f,0x1073,0xff57,0x25},{0x5896,0x1b87,0x107f,0xff4d,2},
        {0x58bb,0x1adf,0x108b,0xff54,0xffe1},{0x5933,0x19ff,0x1097,0xff69,0xffc1},
        {0x59df,0x199b,0x10a3,0xff8c,0xffa7},{0x5af7,0x190f,0x10af,0xffb9,0xff93},
    })
    through(0xec)
    assert(run.enemies[ark.slot]~=ark,'五面前一艘战舰未自然撤离')
    equal(run.stageFlags[0],false)
    through(0xfe)
    local second=find(0x164166)
    equal(run.stageFlags[0],true)
    through(0x10f)
    for _=1,300 do
        if run.major>0x11a then break end
        for _,o in pairs(run.enemies) do
            assert(o.callback~=0x159216 or o.row[1]<0x10f or o.row[1]>0x11a,'战舰在场时登记了补位地炮')
        end
        step()
    end
    assert(run.major>0x11a,'五面战舰占用期间卷轴未通过补位范围')
    through(0x12e)
    assert(run.enemies[second.slot]~=second,'五面后一艘战舰未自然撤离')
    equal(run.stageFlags[0],false)
    through(0x1b7)
    through(0x1b8)
    local boss=find(0x1ba6e2)
    position(boss,0x0a00,0x4a80)
    equal(boss.partCount,12)
    equal(boss.health,0x6b400)
    equal(boss.counters[1],0x41000)
    equal(boss.counters[2],0x2a400)
    step()
    position(boss,0x7200,0x2080)
    equal(boss.extraParts[1].flags,0x8000)
    local function untilBoss(check,limit)
        for _=1,limit do
            if check() then return end
            step()
        end
        assert(check(),'五面关底未执行预期任务')
    end
    untilBoss(function() return boss.vulnerable end,300)
    equal(boss.move.index,2)
    for i=1,3 do equal(boss.extraParts[i].flags,0xa001) end
    assert(boss.draws[0] and boss.draws[1])
    untilBoss(function() return boss.attacks[1] and boss.attacks[1].clock==0 end,180)
    -- V100 第 78486 帧快照固定炮舰和移动槽，核对下一帧六处炮口的 18 发。
    boss.h,boss.l,boss.speed,boss.heading=0x56cb,0x169f,6,0x1f
    boss.move.clock,boss.move.target,run.randomIndex=2,0x11,0x94
    step()
    position(boss,0x5689,0x16a3)
    volley(boss,0x175446,{
        {0x6582,0x069e,0x0e98,0xff7f,0xffc7},{0x6624,0x063e,0x0ea8,0xffaa,0xffab},
        {0x6708,0x05fa,0x0eb8,0xffe4,0xff9b},{0x602e,0x0c56,0x0e88,0xff68,0xffed},
        {0x6082,0x0b9e,0x0e98,0xff7f,0xffc7},{0x6124,0x0b3e,0x0ea8,0xffaa,0xffab},
        {0x54ed,0x126e,0x0e78,0xff68,0x0013},{0x54ee,0x11d6,0x0e88,0xff68,0xffed},
        {0x5542,0x111e,0x0e98,0xff7f,0xffc7},{0x5541,0x1c26,0x0e68,0xff7f,0x0039},
        {0x54ed,0x1b6e,0x0e78,0xff68,0x0013},{0x54ee,0x1ad6,0x0e88,0xff68,0xffed},
        {0x6123,0x2206,0x0e58,0xffaa,0x0055},{0x6081,0x21a6,0x0e68,0xff7f,0x0039},
        {0x602d,0x20ee,0x0e78,0xff68,0x0013},{0x6707,0x274a,0x0e48,0xffe4,0x0065},
        {0x6623,0x2706,0x0e58,0xffaa,0x0055},{0x6581,0x26a6,0x0e68,0xff7f,0x0039},
    })
    local function taskIndex(bank,index)
        for slot=1,bank.limit do
            local t=bank[slot]
            if t and t.index==index and t.running then return t end
        end
    end
    local function waitAttack(index,limit)
        untilBoss(function() return taskIndex(boss.attacks,index) end,limit)
        return taskIndex(boss.attacks,index)
    end
    local function snapshot(t,h,l,speed,heading,target)
        untilBoss(function() return t.clock==0 end,100)
        boss.h,boss.l,boss.speed,boss.heading=h,l,speed,heading
        boss.move.clock,boss.move.target=2,target
    end
    -- 第 79009、79093 帧的偏转炮各使用不同的角增量与逐发速度增量。
    local arc=waitAttack(1,450)
    snapshot(arc,0x605b,0x1b8c,4,0)
    arc.angle=0xc5
    step()
    volley(boss,0x176400,{
        {0x6188,0x1544,0x12c5,0x0016,0xff7c},{0x620e,0x1554,0x15ce,0x004e,0xff6d},
        {0x628e,0x158c,0x18d7,0x008e,0xff6a},{0x62e2,0x15c8,0x1be0,0x00d2,0xff73},
        {0x6330,0x15ec,0x1ee9,0x011b,0xff8a},{0x637c,0x164c,0x21f2,0x0158,0xffae},
    })
    arc=waitAttack(2,160)
    snapshot(arc,0x5fe0,0x1d41,4,0x11)
    arc.angle=0x45
    step()
    volley(boss,0x1765a4,{
        {0x5edc,0x23a5,0x1645,0xffe5,0x00a2},{0x5fbe,0x23a2,0x1a37,0x003f,0x00ba},
        {0x60a2,0x235e,0x1e29,0x00b2,0x00bb},{0x612e,0x2310,0x221b,0x0127,0x0099},
        {0x6190,0x229e,0x260d,0x0191,0x0057},{0x61a2,0x21fa,0x2aff,0x01d5,0xfffb},
        {0x6187,0x2142,0x2ef1,0x01dd,0xff88},{0x610f,0x20e4,0x32e3,0x01a2,0xff10},
    })
    local detached=waitAttack(3,260)
    assert(boss.draws[5] and boss.detached)
    equal(boss.detachedHealth,0x10400)
    equal(boss.extraParts[4].flags,0xa401)
    equal(boss.extraParts[11].flags,0xa400)
    snapshot(detached,0x5f70,0x1baa,2,0x3a)
    boss.trail[boss.trailIndex]={0x5ef2,0x1be2}
    boss.partWave,boss.partAngle,boss.partDrop=0x39,0x56,-0x13c0
    step()
    position(boss.extraParts[4],0x49b7,0x1be2)
    for slot=1,4 do
        local b=assert(run.bullets[slot],'五面分离舱缺首发')
        equal(b.origin,boss)
        equal(b.callback,0x17566c)
        equal(b.speed*256+b.angle,0x2200)
        position(b,0x564f,0x1be2)
    end
    local hatch=waitAttack(4,2800)
    equal(boss.extraParts[4].flags,0x8000)
    equal(boss.extraParts[11].flags,0x8000)
    assert(boss.draws[3] and not boss.draws[5])
    snapshot(hatch,0x5ada,0x2106,2,0x19)
    step()
    volley(boss,0x175446,{
        {0x539d,0x2392,0x184c,0xffb4,0x00a9},{0x5245,0x22fa,0x185d,0xff52,0x0085},
        {0x5135,0x221e,0x186e,0xff10,0x004b},{0x50fd,0x210e,0x187f,0xfef4,0x0003},
        {0x5135,0x1ffe,0x1890,0xff09,0xffbe},{0x5215,0x1f3e,0x18a1,0xff48,0xff81},
        {0x539d,0x1e8a,0x18b2,0xffa6,0xff58},{0x5509,0x1e77,0x18c3,0x0012,0xff4e},
        {0x56b5,0x1ecf,0x18d4,0x007c,0xff64},
    })
    waitAttack(5,2400)
    waitAttack(6,40)
    equal(boss.counters[1],-1)
    equal(boss.counters[2],0x6b400)
    untilBoss(function() return boss.phase==2 end,5400)
    equal(boss.health,-1)
    for i=1,3 do equal(boss.extraParts[i].flags,0x8000) end
    untilBoss(function() return boss.draws[6] end,100)
    equal(boss.move.index,7)
    untilBoss(function()
        for _,o in pairs(run.enemies) do
            if o.callback==0x16a95c then return true end
        end
    end,180)
    assert(not boss.draws[6])
    untilBoss(function() return run.stageCleared end,170)
    assert(run.enemies[boss.slot]~=boss)
    for i=boss.firstPart,boss.firstPart+boss.partCount-1 do equal(run.partSlots[boss.partPool][i],nil) end
    local gate=boss.row
    runtime.close(run)

    -- 从同一条原生成记录重开五面关底，走自弹破坏分离舱和本体的分支。
    run=runtime.init(5,{stageMode=3,cameraOffset=-0x480,player={h=0x1000,l=0xe00,active=true},
        randomIndex=0xfa,dual=true},withArt)
    run.stage={spawns={gate},scroll=run.stage.scroll,tiles=run.stage.tiles}
    run.scroll[2].major,run.scroll[2].release=gate[1],gate[1]
    step()
    boss=find(0x1ba6e2)
    waitAttack(3,1300)
    local function fireAt(part,damage)
        runtime.collision.shots(run,{shots={{h=part.h,l=part.l,front=0,back=0,right=0,left=0,damage=damage}}})
        assert(part.impact,'五面自弹未命中指定部件')
        step()
    end
    local pod=boss.extraParts[4]
    fireAt(pod,0x7000)
    fireAt(pod,0x7000)
    equal(boss.detachedHealth,0x2400)
    fireAt(pod,0x7000)
    equal(boss.detachedHealth,-1)
    equal(boss.health,0x6b400)
    assert(not boss.draws[5])
    local body=boss.extraParts[1]
    for _=1,6 do fireAt(body,0xc100) end
    equal(boss.phase,1)
    equal(boss.counters[2],0x2a400)
    step()
    fireAt(body,0xc100)
    equal(boss.counters[2],0x2a400)
    local last=waitAttack(6,155)
    snapshot(last,0x5f85,0x1cbd,2,0x20,0x1e)
    step()
    volley(boss,0x17678e,{
        {0x5803,0x1f34,0x1350,0xffb1,0x0082},{0x570b,0x1ec8,0x135a,0xff83,0x0070},
        {0x566b,0x1e68,0x1364,0xff5e,0x0059},{0x55db,0x1dcc,0x136e,0xff42,0x003b},
        {0x55b7,0x1d34,0x1378,0xff32,0x001a},{0x55ab,0x1c90,0x1382,0xff2c,0xfffb},
        {0x55c7,0x1bd4,0x138c,0xff37,0xffd8},{0x563f,0x1b34,0x1396,0xff4c,0xffb9},
        {0x56bb,0x1aec,0x13a0,0xff6c,0xff9d},{0x5783,0x1a7c,0x13aa,0xff96,0xff89},
        {0x5863,0x1a38,0x13b4,0xffc4,0xff7a},{0x596f,0x1a21,0x13be,0xfff7,0xff73},
        {0x5a33,0x1a2d,0x13c8,0x0027,0xff77},
    })
    local sweep=taskIndex(boss.attacks,5)
    snapshot(sweep,0x5ed5,0x1cbf,2,0x1e,0x1e)
    sweep.a,sweep.b,sweep.ports,sweep.modifier=0x92,0x68,0,0
    step()
    volley(boss,0x175892,{{0x6ec0,0x0ce0,0x1478,0xff27,0x001b}})
    for _=1,4 do fireAt(body,0xc100) end
    equal(boss.phase,2)
    untilBoss(function() return run.stageCleared end,400)
    assert(run.enemies[boss.slot]~=boss)
    runtime.close(run)
end

local function verifyStage6Opening(withArt,flushFrame)
    local run=runtime.init(6,{stageMode=5,cameraOffset=-0x480,player={h=0xf4d,l=0xe00,active=true},
        randomIndex=0xe3,patrolFireRank=0xe},withArt)
    local function step()
        runtime.step(run)
        if flushFrame then flushFrame() end
    end
    local function through(major)
        for _=1,4800 do
            if run.major>=major then return end
            step()
        end
        error(('六面卷轴未到 %04x'):format(major))
    end
    local function find(callback,pathAddress)
        for _,o in pairs(run.enemies) do
            if o.callback==callback and o.row[6]==pathAddress then return o end
        end
        error(('六面未登记敌机 %06x/%06x'):format(callback,pathAddress))
    end
    local function position(o,h,l)
        equal(o.h%0x10000,h)
        equal(o.l%0x10000,l)
    end
    through(1)
    local first=find(0x15734e,0xdff30)
    local gunner=find(0x15734e,0xdff98)
    position(first,0x3e40,0x3d80)
    position(gunner,0x7840,0x1700)
    equal(first.flags,0x8200)
    equal(gunner.hp,0x120)
    step()
    position(first,0x3e00,0x3d54)
    position(gunner,0x77bd,0x1700)
    for _=1,120 do
        step()
        for _,b in pairs(run.bullets) do
            if b.origin==gunner and b.flash then
                position(b,0x4ef8,0x165f)
                equal(b.callback,0x175220)
                equal(b.speed*256+b.angle,0x0e88)
                equal(b.dh%0x10000,0xff68)
                equal(b.dl%0x10000,0xffed)
                gunner.fired=true
                break
            end
        end
        if gunner.fired then break end
    end
    assert(gunner.fired,'六面开场步兵没有原版首发')
    runtime.collision.shots(run,{shots={{h=gunner.h,l=gunner.l,front=0,back=0,right=0,left=0,damage=0x400}}})
    assert(gunner.impact)
    step()
    equal(run.enemies[gunner.slot]~=gunner,true)
    through(0xe5)
    local sweep=find(0x157bcc,0xe06be)
    position(sweep,0x7500,0x4a00)
    equal(sweep.fireClock,8)
    step()
    position(sweep,0x74c0,0x49d4)
    for _=2,108 do step() end
    -- 第 83349 帧快照固定扫射槽，下一帧两颗弹共享炮口但方向相反。
    sweep.h,sweep.l,sweep.fireClock,sweep.sweepAngle,sweep.sweepDirection=0x6248,0x3798,0,0x78,6
    step()
    position(sweep,0x6221,0x376f)
    local shots={}
    for _,b in pairs(run.bullets) do
        if b.origin==sweep and b.flash then shots[b.angle]=b end
    end
    local a,b=assert(shots[0xbe]),assert(shots[0x3e])
    position(a,0x6221,0x372f)
    position(b,0x6221,0x38af)
    equal(a.speed,0x0f)
    equal(b.speed,0x17)
    through(0x11c)
    local hop=find(0x158ba8,0xe0690)
    position(hop,0x8100,0x04c0)
    equal(hop.flags,0xa201)
    hop.direction=0x18
    step()
    position(hop,0x80c2,0x096a)
    equal(hop.verticalSpeed,0x100)
    equal(hop.landings,2)
    through(0x129)
    local glide=find(0x1585b6,0xe0690)
    position(glide,0x8100,0x10c0)
    step()
    position(glide,0x82c0,0x1540)
    equal(glide.speed,0x23)
    through(0x227)
    equal(run.stage.spawns[run.spawnIndex][10],0x1a7e60)
    through(0x229)
    local boss=assert(run.boss6)
    local escort
    for _,o in pairs(run.enemies) do if o.callback==0x1adc4e then escort=o end end
    assert(escort,'六面关底没有登记伴飞机')
    position(boss,0xa400,0x2080)
    position(escort,0xbc00,0x2080)
    equal(boss.partCount,13)
    equal(boss.health,0x34000)
    equal(boss.counters[1],0x1ee00)
    equal(boss.counters[2],0x15200)
    step()
    position(boss,0xa100,0x2080)
    position(escort,0xb900,0x2080)
    equal(boss.flags,0x8000)
    assert(boss.draws[0] and boss.draws[4])
    for _=1,500 do
        if boss.flags==0xa000 then break end
        step()
    end
    equal(boss.flags,0xa000)
    position(boss,0x4800,0x2080)
    position(boss.extraParts[1],0x5ec0,0x10c0)
    position(boss.extraParts[2],0x5ec0,0x3040)
    position(boss.extraParts[3],0x6c40,0x15c0)
    position(boss.extraParts[4],0x6c40,0x2b40)
    assert(boss.draws[3] and not boss.draws[4])
    -- 第 85594 帧的随机游标决定两组翼炮的初始延迟和转向。
    run.randomIndex=0xd6
    step()
    equal(boss.attacks[1].clock,5)
    equal(boss.attacks[2].clock,0)
    local function bossVolley(callback,rows,waitFrames,sector)
        for _=0,waitFrames do
            local index=0
            for slot=1,run.bulletCapacity do
                local shot=run.bullets[slot]
                if shot and shot.origin==boss and shot.callback==callback and shot.flash
                    and (not sector or shot.l<sector) then
                    index=index+1
                    local sample=assert(rows[index],'六面关底发弹数量超出 V100 采样')
                    position(shot,sample[1],sample[2])
                    equal(shot.speed*256+shot.angle,sample[3])
                    equal(shot.dh%0x10000,sample[4])
                    equal(shot.dl%0x10000,sample[5])
                end
            end
            if index>0 then equal(index,#rows); return end
            if waitFrames>0 then step() end
        end
        error(('六面关底未发弹 %06x'):format(callback))
    end
    for _=1,64 do step() end
    bossVolley(0x175446,{
        {0x5580,0x3580,0x1d20,0x00e2,0x0098},{0x5400,0x347f,0x11a0,0xff7c,0xffa7},
        {0x52e0,0x3140,0x1d30,0x0079,0x00c7},{0x5220,0x2fbf,0x11b0,0xffb9,0xff8c},
        {0x5080,0x2c80,0x1140,0x0000,0x007e},{0x5080,0x2b00,0x1dc0,0x0000,0xff29},
    },0)
    for _=1,32 do step() end
    bossVolley(0x175892,{{0x583f,0x1b5f,0x0f8b,0xff5f,0xffe3},{0x5840,0x251f,0x0f92,0xff6a,0xffd2}},0)
    bossVolley(0x175f2e,{
        {0x5e3f,0x0440,0x24c0,0,0xfef5},{0x57bf,0x083f,0x1880,0xfef4,0},
        {0x54bf,0x0cc0,0x1840,0,0x00b2},{0x537f,0x1080,0x2400,0x0192,0},
        {0x507f,0x1480,0x24c0,0,0xfef5},{0x54c0,0x3440,0x24c0,0,0xfef5},
        {0x5380,0x3080,0x2400,0x0192,0},{0x5080,0x2c80,0x1840,0,0x00b2},
    },340)
    bossVolley(0x174f0c,{
        {0x4f7f,0x151f,0x1487,0xff24,0xffe9},{0x503f,0x147f,0x14b7,0xffd0,0xff71},
        {0x4fdf,0x15df,0x1457,0xff8a,0x007d},{0x4fa0,0x2b3f,0x1498,0xff47,0xffae},
        {0x50c0,0x2b00,0x14c8,0x0029,0xff6f},{0x4fa0,0x2c3f,0x1468,0xff47,0x0052},
    },160)
    for _=1,360 do
        step()
        if boss.attacks[1] and boss.attacks[1].index==0 then break end
    end
    assert(boss.attacks[1] and boss.attacks[1].index==0,'六面关底未回到第一轮翼炮')
    local function hit(part,h,l,amount)
        runtime.collision.shots(run,{shots={{h=h,l=l,front=0,back=0,right=0,left=0,damage=amount}}})
        assert(part.impact,'六面关底命中未进入预期部件槽')
        step()
    end
    local function hitWing(index,amount)
        local part=boss.extraParts[index]
        hit(part,part.h+(index<=2 and -0x600 or 0x500),part.l,amount)
    end
    run.dual=true
    hitWing(1,0x100)
    equal(boss.armor[1],0x4f00)
    equal(boss.armor[2],0x5000)
    equal(boss.health,0x34000)
    hitWing(1,0x5000)
    equal(boss.extraParts[1].flags,0x8000)
    equal(boss.extraParts[2].flags,0xa000)
    equal(boss.attackPause,0x40)
    equal(run.bulletClearClock,0x3f)
    assert(next(run.effects),'翼侧爆破未登记碎片')
    for _=1,63 do step() end
    equal(boss.attackPause,1)
    step()
    step()
    local rearCannon
    for i=1,boss.attacks.limit do
        local t=boss.attacks[i]
        if t and t.index==6 and t.side==1 then rearCannon=t; break end
    end
    assert(rearCannon,'拆翼后同侧后炮未接替')
    -- V100 第 85839 帧，左后炮的第一波用了四个炮口。
    bossVolley(0x175f2e,{
        {0x5cbf,0x1440,0x28c0,0,0xfed7},{0x603f,0x12bf,0x1c80,0xfec7,0},
        {0x66ff,0x0e80,0x1c40,0,0x00d0},{0x6e3f,0x0c00,0x2800,0x01bf,0},
    },70,0x1c00)
    for _,index in ipairs({3,2,4}) do hitWing(index,0x5100) end
    equal(boss.brokenCount,4)
    equal(boss.phase,1)
    equal(boss.counters[1],-1)
    equal(boss.counters[2],0x34000)
    equal(boss.clocks[2],0x1c1f)

    local function active(callback)
        for _,o in pairs(run.enemies) do if o.callback==callback then return o end end
    end
    local ring
    for age=1,150 do
        -- 90350 帧的游标配置第一圈的转向、子机次序和摆动相位。
        if age==150 then run.randomIndex=0xfb end
        step()
        ring=active(0x1aa65a)
        if age<150 then equal(ring,nil) end
    end
    assert(ring,'第二段未放出旋转环')
    equal(boss.protected,false)
    equal(ring.partCount,13)
    equal(ring.ring.mode,1)
    equal(ring.ring.wave,0x6f)
    position(ring,0x4000,0x2080)
    position(ring.extraParts[1],0x4000,0x32c0)
    step()
    position(ring,0x4016,0x2080)
    position(ring.extraParts[1],0x3e9d,0x322f)
    equal(ring.extraParts[1].depth%0x10000,0xfeb0)
    local node=assert(active(0x1ab12a),'旋转环未分配首架子机')
    equal(node.point,ring.extraParts[12])
    position(node,0x3a01,0x1680)
    step()
    position(node,0x3a3f,0x16aa)
    equal(node.angle,0x35)
    equal(node.speed,0x24)
    for _=1,103 do step() end
    position(node,0x4418,0x0e34)
    local needle
    for _,b in pairs(run.bullets) do if b.origin==node and b.flash then needle=b; break end end
    assert(needle,'旋转环首架子机未在 90456 对应帧发弹')
    position(needle,0x4418,0x0d74)
    equal(needle.speed*256+needle.angle,0x1cbe)
    equal(needle.dh%0x10000,0xfff2)
    equal(needle.dl%0x10000,0xff30)
    equal(node.flags,0xa601)
    local firstRing=ring.ring
    hit(node,node.h,node.l,0x1000)
    assert(run.enemies[node.slot]~=node,'旋转环子机被击破后仍占槽')
    local secondSpeed,detached
    for _=1,760 do
        step()
        for _,o in pairs(run.enemies) do
            if o.callback==0x1aa65a and o.ring.mode==0 then secondSpeed=secondSpeed or o.speed end
            if o.callback==0x1ab12a and o.ring==firstRing and o.phase==2 then detached=true end
        end
        if secondSpeed and detached and firstRing.finished then break end
    end
    assert(secondSpeed and detached and firstRing.finished,'未走完旋转环换型和离环分支')
    equal(secondSpeed,5)
    equal(boss.phase,1)
    for _=1,7 do hit(boss,boss.h,boss.l,0x7fff) end
    equal(boss.phase,2)
    equal(boss.flags,0x8000)
    equal(boss.counters[2],-1)
    equal(run.bulletClearClock,0xf)
    assert(boss.coversHidden and run.boss6Defeated)
    local wreckage,bossSlot,escortSlot=false,boss.slot,escort.slot
    local final
    for _=1,720 do
        step()
        wreckage=wreckage or active(0x1af1b2)
        final=active(0x19f6be)
        if final then break end
    end
    assert(wreckage,'船体爆破未登记碎片对象')
    assert(run.boss6EscortDepart)
    equal(run.boss6,nil)
    assert(run.enemies[bossSlot]~=boss,'首舰的部件槽未释放')
    equal(escort.posePhase,3)
    equal(escort.anim,0x57)
    assert(not run.stageCleared,'伴飞机离舰时六面尚未结算')
    assert(final,'伴飞机抵达交接姿态后未挂载最终 Boss')
    equal(final.h,escort.h)
    equal(final.l,escort.l)
    equal(final.partCount,18)
    equal(final.health,0x54800)
    equal(final.secondHealth,0x98f40)
    equal(final.counters[1],0x13800)
    equal(final.flags,0x8000)
    -- 固定第 91573 帧的交接位置和游标，检查最终 Boss 的入场轨迹。
    final.h,final.l,run.randomIndex=0x57aa,0x1f7e,0x33
    step()
    position(final,0x57aa,0x1f7e)
    equal(final.heading,0x20)
    position(final.extraParts[2],0x792a,0x0afe)
    step()
    position(final,0x57ac,0x1f85)
    equal(final.heading,0x0e)
    equal(run.enemies[escortSlot],nil)
    for _=3,258 do step() end
    equal(final.flags,0xa001)
    equal(final.extraParts[1].flags,0xa001)
    equal(final.protected,false)
    local first
    for age=259,290 do
        step()
        for _,b in pairs(run.bullets) do
            if b.origin==final and b.callback==0x17566c and b.flash then first=b; break end
        end
        if age<290 then equal(first,nil) end
    end
    assert(first,'最终 Boss 未从 E6 挂载第一组扫射')
    position(first,0x5f91,0x1c08)
    equal(first.speed*256+first.angle,0x18e0)
    equal(first.dh%0x10000,0xbb)
    equal(first.dl%0x10000,0xff82)
    local function launched(origin,callback)
        local found={}
        for slot=1,run.bulletCapacity do
            local b=run.bullets[slot]
            if b and b.origin==origin and b.flash and b.callback==callback then found[#found+1]=b end
        end
        return found
    end
    for _=91864,91911 do step() end
    local aimed=launched(final,0x175dac)
    equal(#aimed,3)
    position(aimed[1],0x5b8b,0x11f0)
    equal(aimed[1].speed*256+aimed[1].angle,0x1484)
    equal(aimed[2].angle,0x88)
    equal(aimed[3].angle,0x80)
    for _=91912,92303 do step() end
    local mothers=launched(final,0x177692)
    equal(#mothers,1)
    local mother=mothers[1]
    position(mother,0x5ada,0x30a5)
    equal(mother.angle,0xb6)
    equal(mother.speed,0)
    step()
    local children=launched(mother,0x175446)
    equal(#children,1)
    position(children[1],0x5b1a,0x3165)
    equal(children[1].speed*256+children[1].angle,0x1136)
    equal(children[1].dh%0x10000,0x2d)
    equal(children[1].dl%0x10000,0x7a)

    for _=92305,92424 do step() end
    position(final,0x5840,0x2000)
    -- 第 92425 帧的击杀奖励还会读随机表。固定奖励结束时的游标以继续核对攻击。
    final.health,final.counters[1]=0x3c700,0xff
    hit(final,final.h,final.l,0x100)
    equal(final.phase,1)
    equal(final.health,0x3c600)
    equal(final.counters[1],-1)
    equal(final.counters[2],0x1a000)
    equal(run.bulletClearClock,0xf)
    equal(final.protected,true)
    run.randomIndex=0x4a
    for _=92426,92557 do step() end
    position(final,0x585e,0x1ba8)
    equal(final.protected,false)
    local center,outer=launched(final,0x17508e),launched(final,0x17625c)
    equal(#center,6)
    equal(#outer,33)
    position(center[1],0x5362,0x1abb)
    equal(center[1].speed*256+center[1].angle,0x168b)
    position(outer[1],0x566c,0x1efb)
    equal(outer[1].speed*256+outer[1].angle,0x0b50)
    for _=92558,93018 do step() end
    equal(active(0x1a74aa),nil)
    step()
    local fightRing=assert(active(0x1a74aa),'四轮充能炮结束后未挂载十二点弹环')
    position(final,0x5937,0x2236)
    position(fightRing,0x5937,0x2236)
    position(fightRing.extraParts[1],0x5ecf,0x2236)
    step()
    position(fightRing,0x59b2,0x2237)
    position(fightRing.extraParts[1],0x5fa2,0x2237)
    for _=93021,93048 do step() end
    position(fightRing,0x5d89,0x237b)
    local ringShot=launched(fightRing.extraParts[1],0x175f2e)
    equal(#ringShot,1)
    position(ringShot[1],0x6873,0x293c)
    equal(ringShot[1].speed*256+ringShot[1].angle,0x1a92)
    for _=93049,93123 do step() end
    equal(fightRing.phase,2)
    equal(fightRing.radius,0x74)
    local releaseShot=launched(fightRing.extraParts[1],0x175446)
    equal(#releaseShot,1)
    position(releaseShot[1],0x3c01,0x3726)
    equal(releaseShot[1].speed*256+releaseShot[1].angle,0x18a7)
    for _=93124,94344 do step() end
    position(final,0x5a8d,0x21aa)
    final.health,final.counters[2]=0x18400,0xff
    hit(final,final.h,final.l,0x100)
    position(final,0x5a8b,0x21b8)
    equal(final.phase,2)
    equal(final.counters[2],-1)
    equal(final.counters[3],0x27000)
    equal(final.health,0x18300)
    equal(final.protected,true)
    run.randomIndex=0x8c
    for _=94346,94518 do step() end
    equal(final.protected,false)
    local spiral=launched(final,0x176400)
    equal(#spiral,2)
    position(spiral[1],0x4cf5,0x1cea)
    equal(spiral[1].speed*256+spiral[1].angle,0x1512)
    equal(spiral[1].dh%0x10000,0xd2)
    equal(spiral[1].dl%0x10000,0x41)

    -- V100 的 E10 尾段箭弹、E11 接触屏边后的槽位和 E7 轮转炮。
    for _=94519,94579 do step() end
    local spiralTail=launched(final,0x17479e)
    equal(#spiralTail,1)
    position(spiralTail[1],0x49c6,0x1f62)
    equal(spiralTail[1].speed*256+spiralTail[1].angle,0x1092)
    for _=94580,95139 do step() end
    local edgeShot=launched(final,0x1777fc)
    equal(#edgeShot,1)
    position(edgeShot[1],0x6014,0x19b7)
    equal(edgeShot[1].speed*256+edgeShot[1].angle,0x1470)
    equal(edgeShot[1].dh%0x10000,0xff32)
    equal(edgeShot[1].dl%0x10000,0x37)
    for _=95140,95189 do step() end
    equal(active(0x1a6dd4),nil)
    step()
    local edge=assert(active(0x1a6dd4),'E11 触边后未登记边缘单位')
    position(edge,0x6c33,0x214e)
    equal(edge.flags,0x8000)
    for _=95191,95233 do step() end
    position(edge,0x6864,0x214e)
    equal(edge.flags,0xa201)
    for _=95234,95666 do step() end
    local wheel=launched(final,0x175446)
    equal(#wheel,18)
    position(wheel[1],0x5f05,0x1f41)
    equal(wheel[1].speed*256+wheel[1].angle,0x1000)
    position(wheel[18],0x59d3,0x1bb7)
    equal(wheel[18].speed*256+wheel[18].angle,0x10c0)

    for _=95667,95720 do step() end
    position(final,0x56fa,0x21af)
    final.counters[3]=0xff
    hit(final,final.h,final.l,0x100)
    equal(final.phase,3)
    equal(final.counters[3],-1)
    equal(final.health,-1)
    equal(final.protected,true)
    equal(active(0x1a6dd4),nil)
    step()
    equal(final.flags,0x8000)
    equal(final.extraParts[1].flags,0x8000)
    for _=95723,95773 do step() end
    local shard=assert(active(0x1a7ac0),'E3 未分配重组碎片')
    position(shard,0x7800,0x1000)
    equal(shard.flags,0x8000)
    for _=95774,96121 do step() end
    position(final,0x599b,0x246a)
    equal(final.protected,false)
    equal(final.armorFrame,40)
    for i=2,13 do equal(final.extraParts[i].flags,0xa001) end

    for _=96122,96220 do step() end
    local portShot=launched(final,0x1740b4)
    equal(#portShot,1)
    position(portShot[1],0x6aef,0x0882)
    equal(portShot[1].speed*256+portShot[1].angle,0x1285)
    for _=96221,96314 do step() end
    local centerSweep=launched(final,0x175446)
    equal(#centerSweep,5)
    position(centerSweep[1],0x5478,0x2000)
    equal(centerSweep[1].speed*256+centerSweep[1].angle,0x168e)
    for _=96315,97106 do step() end
    local centerFan=launched(final,0x17508e)
    equal(#centerFan,14)
    position(centerFan[1],0x53b3,0x2495)
    equal(centerFan[1].speed*256+centerFan[1].angle,0x0c94)
    for _=97107,97152 do step() end
    local wing=final.extraParts[7]
    local durability=final.secondHealth
    final.counters[4]=0xff
    hit(wing,wing.h,wing.l,0x100)
    equal(final.phase,4)
    equal(final.secondHealth,durability-0x100)
    equal(final.counters[4],-1)
    equal(final.protected,true)
    for _,i in ipairs({2,7,8,13}) do
        equal(final.extraParts[i].flags,0x8000)
        equal(final.extraParts[i].broken,true)
    end
    for _=97154,97261 do step() end
    equal(final.protected,false)
    local port=assert(active(0x1a7774),'E13 未登记脱离炮口')
    position(port,0x5b01,0x1251)
    equal(port.row.bullet,0x23)
    for _=97262,97307 do step() end
    local sideShots=launched(port,0x1779e2)
    equal(#sideShots,2)
    position(sideShots[1],0x501b,0x1a61)
    equal(sideShots[1].speed*256+sideShots[1].angle,0x1440)
    position(sideShots[2],0x501b,0x18e1)
    equal(sideShots[2].speed*256+sideShots[2].angle,0x14c0)
    for _=97308,97530 do step() end
    local fixed=assert(active(0x1a7774),'E13 未登记第二种脱离炮口')
    equal(fixed.row.fixed,true)
    for _=97531,97570 do step() end
    local returnShots=launched(fixed,0x177b8e)
    equal(#returnShots,2)
    position(returnShots[1],0xd5,0x3417)
    equal(returnShots[1].speed*256+returnShots[1].angle,0x0c40)

    for _=97571,98672 do step() end
    position(final,0x5612,0x23d8)
    -- V100 在后两次转形的 0x178742 奖励分支中已满 500 颗精灵石。
    run.player.gems=0x1f4
    final.counters[5]=0xff
    hit(final,final.h,final.l,0x100)
    equal(final.phase,5)
    for _,i in ipairs({3,6,9,12}) do
        equal(final.extraParts[i].flags,0x8000)
        equal(final.extraParts[i].broken,true)
    end
    for _=98674,98781 do step() end
    equal(final.protected,false)
    local wingStar=launched(final,0x176400)
    equal(#wingStar,12)
    position(wingStar[1],0x4e50,0x0d45)
    equal(wingStar[1].speed*256+wingStar[1].angle,0x0faa)
    for _=98782,98797 do step() end
    local spindle=launched(final,0x175892)
    equal(#spindle,6)
    position(spindle[1],0x5431,0x12bc)
    equal(spindle[1].speed*256+spindle[1].angle,0x0e84)
    for _=98798,99196 do step() end
    equal(final.finalSweep,true)
    local wall=launched(final,0x17566c)
    equal(#wall,8)
    position(final,0x4913,0x26ef)

    for _=99197,99904 do step() end
    position(final,0x49ed,0x23be)
    final.counters[6]=0xff
    hit(final,final.h,final.l,0x100)
    equal(final.phase,6)
    equal(final.protected,true)
    for i=2,13 do equal(final.extraParts[i].flags,0x8000) end
    for _=99906,100081 do step() end
    equal(final.protected,false)
    equal(run.cameraOffset,0)
    position(final,0x5a37,0x1d2d)
    local shards=0
    for _,enemy in pairs(run.enemies) do
        if enemy.callback==0x1a78ac then shards=shards+1 end
    end
    equal(shards,16)
    for _=100082,100176 do step() end
    local crossing=launched(final,0x176920)
    equal(#crossing,16)
    position(crossing[1],0x0b00,0x3700)
    equal(crossing[1].speed*256+crossing[1].angle,0x08c0)
    position(crossing[16],0x5f00,0x00c0)
    equal(crossing[16].speed*256+crossing[16].angle,0x0f40)
    local hullContact={h=final.h,l=final.l,front=0,back=0,right=0,left=0}
    local coreHealth=final.counters[7]
    equal(runtime.collision.body(run,hullContact),final)
    equal(hullContact.pendingHit,true)
    step()
    equal(final.counters[7],coreHealth+0x800)
    for _=100178,100936 do step() end
    final.counters[7]=0xff
    hit(final,final.h,final.l,0x100)
    equal(final.defeated,true)
    position(final,0x587e,0x18ea)
    for _=100938,101800 do step() end
    position(final,0x3a88,0x1bf2)
    equal(run.stageCleared,nil)
    step()
    equal(run.stageCleared,true)
    equal(active(0x19f6be),nil)
    equal(active(0x1a78ac),nil)
    runtime.close(run)
end

local function verifyStage6Timeout()
    local player={h=0xf4d,l=0xe00,active=false}
    local run=runtime.init(6,{stageMode=5,cameraOffset=-0x480,player=player})
    for index,row in ipairs(run.stage.spawns) do
        if row[10]==0x1a7e60 then
            run.spawnIndex,run.scroll[2].major,run.scroll[2].minor=index,row[1],row[2]
            break
        end
    end
    runtime.step(run)
    local boss=assert(run.boss6)
    for _=1,500 do
        if boss.flags==0xa000 then break end
        runtime.step(run)
    end
    equal(boss.flags,0xa000)
    -- 0x1ac120 在自机暂时不在场时延长计时，重新入场后才拆翼转段。
    boss.clocks[1]=1
    runtime.step(run)
    equal(boss.clocks[1],0x78)
    equal(boss.phase,0)
    player.active=true
    for _=1,0x78 do runtime.step(run) end
    equal(boss.phase,1)
    equal(boss.brokenCount,4)
    equal(boss.counters[2],0x34000)
    equal(boss.clocks[2],0x1c20)
    boss.clocks[2]=1
    runtime.step(run)
    equal(boss.phase,2)
    equal(boss.flags,0x8000)
    runtime.close(run)
end

local function verifyAll(withArt,flushFrame)
    verify(withArt,flushFrame)
    verifyGunship(withArt,flushFrame)
    verifyPilotLoss(withArt,flushFrame)
    verifyMidBoss(withArt,flushFrame,false)
    verifyMidBoss(withArt,flushFrame,true)
    verifyDualCannon(withArt,flushFrame)
    verifyFormation(withArt,flushFrame)
    verifyBoss1(withArt,flushFrame)
    verifyBoss1(withArt,flushFrame,true)
    verifyStage2Turret(withArt,flushFrame)
    verifyStage2Carriers(withArt,flushFrame)
    verifyStage2Forts(withArt,flushFrame)
    verifyStage2MidBoss(withArt,flushFrame,false)
    verifyStage2MidBoss(withArt,flushFrame,true)
    verifyStage3Road(withArt,flushFrame)
    verifyStage3MidBossRetreat(withArt,flushFrame)
    verifyStage4Armor(withArt,flushFrame)
    verifyStage4MidBoss(withArt,flushFrame,false)
    verifyStage4MidBoss(withArt,flushFrame,true)
    verifyStage4Gunship(withArt,flushFrame)
    verifyStage4BossSweep(withArt,flushFrame)
    verifyStage4Timeout(withArt,flushFrame)
    verifyStage5(withArt,flushFrame)
    verifyStage6Opening(withArt,flushFrame)
    if not withArt then verifyStage6Timeout() end
end

if arg and arg[1] == '--luastg' then return verifyAll end
verifyAll(false)
print('Espgaluda 原生关卡回归通过，一至六面均触发通关。')
