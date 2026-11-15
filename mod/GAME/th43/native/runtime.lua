-- 原程序在 0x101cd2 更新敌机，0x101d3e 更新敌弹，随后进入碰撞例程。
local directory = 'mod/GAME/th43/native/'
local program = dofile(directory .. 'program.lua')
local scroll = dofile(directory .. 'scroll.lua')
local path = dofile(directory .. 'path.lua')(program)
local bullets = dofile(directory .. 'enemy_bullet.lua')(program)
local chips = dofile(directory .. 'chip.lua')(program)
local score = dofile(directory .. 'score.lua')(program, chips, bullets)
local effects = dofile(directory .. 'effect.lua')(program, score)
local items = dofile(directory .. 'item.lua')(program, score)
local enemies = dofile(directory .. 'enemy.lua')(program, path, bullets, effects, items, score)
local boss1 = dofile(directory .. 'boss1.lua')(program, bullets, effects, score)
local boss2 = dofile(directory .. 'boss2.lua')(program, bullets, effects, score)
local boss3 = dofile(directory .. 'boss3.lua')(program, bullets, effects, score)
local boss4 = dofile(directory .. 'boss4.lua')(program, bullets, effects, score)
local boss5 = dofile(directory .. 'boss5.lua')(program, bullets, effects, score)
local mid1 = dofile(directory .. 'mid1.lua')(program, path, bullets, effects, score)
local mid2 = dofile(directory .. 'mid2.lua')(program, bullets, effects, scroll, enemies, score)
local mid3 = dofile(directory .. 'mid3.lua')(program, path, bullets, effects, items, score)
local mid4 = dofile(directory .. 'mid4.lua')(program, bullets, effects, scroll, score)
local mid5 = dofile(directory .. 'mid5.lua')(program, bullets, effects, scroll, score)
local players = dofile(directory .. 'player.lua')(program, bullets, items)
local warning = dofile(directory .. 'warning.lua')(program)
local floor = math.floor
local band = require('bit').band

local M = {program=program, bullets=bullets, enemies=enemies, boss1=boss1, boss2=boss2, boss3=boss3, mid1=mid1, mid2=mid2, mid3=mid3, mid4=mid4,
    boss4=boss4, mid5=mid5, players=players, items=items, score=score, chips=chips}
local art

local function encounter(run)
    return run.boss or run.boss2 or run.boss3 or run.boss4 or run.boss5 or run.mid1 or run.mid2 or run.mid3 or run.mid4 or run.mid5
end

-- 0xb052c 与 0xb07c0 先按敌机部件，再按自机弹槽迭代。同一颗弹可在本帧穿过多个部件。
local function playerHits(run, shots, count, player)
    local first
    local hMax, hMin, lMax, lMin = 0, 0x7000, 0, 0x3800
    local hasShot = false
    -- 0xb0488 先用所有有效自机弹的外缘作粗筛，射击穿透在后面的逐部件扫描中结算。
    for slot = 1, count do
        local shot = shots[slot]
        if shot and shot.damage >= 0 then
            local h, l = shot.h + shot.front, shot.l + shot.right
            hMax, hMin = math.max(hMax, h), math.min(hMin, h - shot.back)
            lMax, lMin = math.max(lMax, l), math.min(lMin, l - shot.left)
            hasShot = true
        end
    end
    if not hasShot then return end
    local function hitPart(part, bias, limit, maxH, minH, maxL, minL)
        local h, l = part.h + bias, part.l + bias
        local back = band(h - part.back, 0xffff)
        if back >= limit or back > maxH or band(h + part.front, 0xffff) < minH
            or band(l - part.left, 0xffff) > maxL or band(l + part.right, 0xffff) < minL then return end
        for slot = 1, count do
            local shot = shots[slot]
            if shot and shot.damage >= 0
                and program.shotOverlap(part, shot.h, shot.l, shot, bias) then
                local value = shot.damage - (run.fullDamage and 0 or floor(shot.damage / 4))
                local hardness = (part.hitPool == 2 and part.host and 0x7fff or part.hp) - (part.damagePending or 0)
                if hardness < 0 then return end
                shot.pendingHit, shot.damage = true, shot.damage - hardness
                first = first or part
                if part.hitPool == 2 or band(part.h, 0xffff) < 0x6f00 then
                    if player then
                        if part.scoreStamp ~= run.frame then part.scoreHit = nil end
                        part.scoreStamp = run.frame
                        if player.locked and shot.scoreLock then part.scoreHit = 'lock'
                        elseif part.scoreHit ~= 'lock' then part.scoreHit = 'shot' end
                    end
                    part.damage(part, value, 'shot')
                    if hardness < value then return end
                    if player and player.locked and shot.mode == 'lock' and part.h < 0x8000 and part.lockable ~= false then
                        players.lockOn(player, part)
                    end
                end
            end
        end
    end
    local function hitEnemy(part, pool, bias, limit, maxH, minH, maxL, minL)
        if part and part.hitPool == pool and band(part.flags, 0xa000) == 0xa000 then
            hitPart(part, bias, limit, maxH, minH, maxL, minL)
        end
    end
    for pool = 1, 2 do
        local bias, limit = pool == 1 and 0x2800 or 0x1800, pool == 1 and 0x9700 or 0x8800
        local maxH, minH = band(hMax + bias, 0xffff), band(hMin + bias, 0xffff)
        local maxL, minL = band(lMax + bias, 0xffff), band(lMin + bias, 0xffff)
        local majorEnemy = encounter(run)
        if pool == 2 and majorEnemy then
            for _, part in ipairs(majorEnemy.parts) do
                if part.colli then hitPart(part, bias, limit, maxH, minH, maxL, minL) end
            end
        end
        local children = majorEnemy and (majorEnemy.children or majorEnemy.pods)
        if pool == 1 and children then
            for slot = 1, 48 do
                local part = children[slot]
                if part and part.colli then hitPart(part, bias, limit, maxH, minH, maxL, minL) end
            end
        end
        for slot = 11, 58 do
            local part = run.enemies[slot]
            hitEnemy(part, pool, bias, limit, maxH, minH, maxL, minL)
            if part and part.attachments then
                for _, attachment in ipairs(part.attachments) do
                    hitEnemy(attachment, pool, bias, limit, maxH, minH, maxL, minL)
                end
            end
        end
    end
    return first
end
local function loadAtlas(kind, rects)
    local images, pages = {}, {}
    for i, rect in ipairs(rects) do
        local page, x, y, w, h = unpack(rect)
        local texture = 'th43_rom_' .. kind .. page
        if not pages[page] then
            LoadTexture(texture, 'Resources/th43/native/' .. kind .. page .. '.png')
            SetTextureSamplerState(texture, 'point+clamp')
            pages[page] = true
        end
        local name = 'th43_rom_' .. kind .. '_' .. i
        LoadImage(name, texture, x, y, w, h)
        images[i] = {name, w, h}
    end
    return images
end

local function loadArt()
    if not art or not lstg.CheckRes(2, art.sprites[1][1]) then
        art = {sprites=loadAtlas('sprites', program.sprites), tiles=loadAtlas('tiles', program.tiles),
            transport=loadAtlas('transport', program.transportSprites)}
    end
    return art
end

local Spawner = Class(object, {
    init = function(o, run, row)
        o.run, o.row = run, row
        o.group, o.layer, o.colli, o.bound = GROUP.GHOST, LAYER.BG, false, false
        local cursor = row[6] - run.stage.pathBase + 1
        local p = run.stage.paths
        local function read(index) return program.word(p, index) % 256 end
        o.h, o.l = program.add(program.word(p, cursor), program.word(p, cursor + 2), row[7], row[8])
        cursor = cursor + 4
        o.grounded = read(cursor) ~= 2
        if not o.grounded then cursor = cursor + 2 end
        o.kind, o.remaining, o.interval = read(cursor), read(cursor + 2), read(cursor + 4)
        o.pathAddress, o.clock = run.stage.pathBase + cursor + 5, o.interval
    end,
})

local function spawn(run, row)
    if row[10] == 0x10cefe then
        boss1.spawn(run)
    elseif row[10] == 0x112cd6 then
        boss2.spawn(run)
    elseif row[10] == 0x119a06 then
        boss3.spawn(run)
    elseif row[10] == 0x11fa18 then
        boss4.spawn(run)
    elseif row[10] == 0x125a4c then
        boss5.spawn(run)
    elseif row[10] == 0x12ec6c then
        mid1.spawn(run, row)
    elseif row[10] == 0x130fea then
        mid2.spawn(run, row)
    elseif row[10] == 0x133262 then
        mid3.spawn(run, row)
    elseif row[10] == 0x138cbc then
        mid4.spawn(run)
    elseif row[10] == 0x13b168 then
        mid5.spawn(run)
    elseif row[10] == 0x0e8f36 then
        warning.spawn(run)
    elseif enemies.supports(row) then
        if run.mid1 and (row[10] == 0x0d7cdc or row[10] == 0x0d3cd4 and run.major >= 0x1e0) then return end
        if run.mid1 and row[9] == 0x0daad4 and run.major >= 0x210 then return end
        -- 0xd7bb2 检查战舰的占位字。0xe1010 还检查飞行甲板写入的同一阶段占位字。
        if run.mid3 and row[10] == 0x0d7cdc then return end
        if run.stageNumber == 3 and (run.mid3 or run.patrol42Block) and row[10] == 0x0e1168 then return end
        enemies.spawn(run, row)
    elseif row[10] == 0x0d0630 then
        local o = New(Spawner, run, row)
        run.spawners[#run.spawners + 1] = o
    elseif row[3] ~= 0 then
        run.firstUnsupported = run.firstUnsupported or row
    end
end

local function spawnPending(run)
    local pending = run.pendingSpawns
    for i = #pending, 1, -1 do
        local row = pending[i]
        pending[i] = nil
        spawn(run, row)
    end
end

local function stepSpawners(run)
    local i = 1
    while i <= #run.spawners do
        local o = run.spawners[i]
        if o.grounded then o.h = program.s16(o.h - run.scrollStep * 64) end
        local h, l = o.h, band(o.l + 0x1c00 + run.cameraOffset, 0xffff)
        local visible = h > -0x800 and h < 0x7800 and l < 0x7000
        local expired = o.entered and not visible
        if not expired then
            o.entered = o.entered or visible
            if not run.freeze then
                o.clock = o.clock - 1
                if o.clock < 0 then
                    o.clock = o.interval
                    local definition = program.spawnTypes[o.kind]
                    local row = {run.major, run.minor, o.kind, o.row[4], 0, o.pathAddress, 0, 0,
                        definition[1], definition[2], h=o.h, l=o.l}
                    if #run.pendingSpawns < 40 then run.pendingSpawns[#run.pendingSpawns + 1] = row end
                    if o.remaining > 0 then
                        o.remaining = o.remaining - 1
                        expired = o.remaining == 0
                    end
                end
            end
        end
        if expired then
            table.remove(run.spawners, i)
            object.RawDel(o)
        else
            i = i + 1
        end
    end
end

local function contact(run, player)
    if not player or not run.pilotH then return end
    local h, l = run.pilotH, run.pilotL
    local front, back, right, left = player.front or 0xc0, player.back or 0xc0,
        player.right or 0x80, player.left or 0x80
    local bullet = bullets.hit(run, h, l, front, back, right, left, player.clearHitbox)
    if bullet and not player.clearHitbox then
        if player.protect == 0 then run.playerHit = bullet end
        return
    end
    -- 0xb0322 仅在帧计数低字节的 bit 1 置位时扫描本体，沿用 0xb109c 的自机盒。
    if band(run.frame, 2) == 0 then return end
    if player.clearHitbox then
        front, back, right, left = front + 0x800, back + 0x800, right + 0x600, left + 0x600
    end
    if player == run.player then
        items.contact(run, player, h, l, front, back, right, left)
        chips.contact(run, h, l, front, back, right, left)
    end
    local majorEnemy = encounter(run)
    local children = majorEnemy and (majorEnemy.children or majorEnemy.pods)
    if children then
        for slot = 1, 48 do
            local pod = children[slot]
            if pod and (pod.bodyContact or pod.bodyContact == nil and pod.colli)
                and program.overlap(pod, h, l, front, back, right, left) then
                pod.damage(pod, 1)
                if player.protect == 0 then run.playerHit = pod end
                return
            end
        end
    end
    local body = enemies.touch(run, h, l, front, back, right, left, 1)
        or (run.boss and boss1.touch(run.boss, h, l, front, back, right, left))
        or (run.mid1 and mid1.touch(run.mid1, h, l, front, back, right, left))
        or (run.boss3 and boss3.touch(run.boss3, h, l, front, back, right, left))
        or (run.boss5 and boss5.touch(run.boss5, h, l, front, back, right, left))
        or enemies.touch(run, h, l, front, back, right, left, 2)
    if body and player.protect == 0 then
        run.playerHit = body
    end
end

local Background = Class(object, {
    init = function(o, run)
        o.run, o.group, o.layer, o.bound, o.colli = run, GROUP.GHOST, LAYER.BG, false, false
    end,
    render = function(o)
        local run, images = o.run, o.run.art.tiles
        local stage = run.stage
        local firstX = floor(run.scrollX / 32)
        local firstY = floor(run.mapMajor / 4)
        local x = -112 + 16 - run.scrollX % 32
        local y = -224 + 16 - run.scrollY % 32
        for column = 0, 7 do
            local tileX = (firstX + column) % stage.across
            for row = 0, 14 do
                local tileY = (firstY + row) % stage.forward
                local image = images[stage.tiles[tileY * stage.across + tileX + 1]]
                Render(image[1], x + column * 32, y + row * 32)
            end
        end
    end,
})

local function bombHit(run, bomb)
    local majorEnemy = encounter(run)
    if majorEnemy then
        for _, part in ipairs(majorEnemy.parts) do
            if part.colli and program.overlap(part, bomb.h, bomb.l, bomb.front, bomb.back, bomb.right, bomb.left) then
                part.scoreHit, part.scoreStamp = 'bomb', run.frame
                part.damage(part, bomb.damage)
            end
        end
    end
    local children = majorEnemy and (majorEnemy.children or majorEnemy.pods)
    if children then
        for _, pod in pairs(children) do
            if pod.colli and program.overlap(pod, bomb.h, bomb.l, bomb.front, bomb.back, bomb.right, bomb.left) then
                pod.scoreHit, pod.scoreStamp = 'bomb', run.frame
                pod.damage(pod, bomb.damage)
            end
        end
    end
    local function hitEnemy(o)
        if o and band(o.flags, 0xa000) == 0xa000
            and program.overlap(o, bomb.h, bomb.l, bomb.front, bomb.back, bomb.right, bomb.left) then
            o.scoreHit, o.scoreStamp = 'bomb', run.frame
            o.damage(o, bomb.damage, 'bomb')
        end
    end
    for slot = 11, 58 do
        local o = run.enemies[slot]
        hitEnemy(o)
        if o and o.attachments then
            for _, attachment in ipairs(o.attachments) do hitEnemy(attachment) end
        end
    end
end

function M.init(number, route, withArt)
    local stage = assert(program.stages[number], '没有该面的 ROM 关卡表')
    local run = {stageNumber=number, routeName=route, route=assert(program.routes[route], '未知绊地狱路线'),
        frame=0, rankBase=({0x34,0x44,0x54,0x64,0x64})[number], rankTime=0,
        weaponRank=0, difficulty=1, difficultySpeed=0, enemies={}, spawners={},
        effects={}, itemSlots={}, chips={}, chipCount=0, chipTime=0, chipKind=0,
        stageMultiplier=1, bossMultiplier=1, randomByte=0, pendingSpawns={}, bombHit=bombHit}
    scroll.init(run, stage)
    bullets.init(run)
    if withArt then
        run.art = loadArt()
        run.background = New(Background, run)
    end
    return run
end

function M.step(run, player)
    if run.stageCleared then return end
    local suppressShots = run.suppressShots
    if run.missShotDelay then
        run.suppressShots = true
        run.missShotDelay = run.missShotDelay-1
        if run.missShotDelay == 0 then run.missShotDelay = nil end
    end
    player = player or run.player
    -- 0xb109c 留下受击标志，0xb578c 在下一次自机更新时消费。
    local pendingHit = player and player == run.player and M.consumePlayerHit(run)
    if player and player.respawn == 0 and not player.defeated and not pendingHit then
        if player == run.player then
            run.pilotH, run.pilotL = player.h, player.l
        else
            run.pilotH, run.pilotL = program.fixed(player.x, player.y)
        end
    else
        run.pilotH, run.pilotL = nil, nil
    end
    local playerDx = run.previousPilotL and run.pilotL and run.pilotL - run.previousPilotL
    run.frame = run.frame + 1
    run.rankTime = run.rankTime + 1
    scroll.advance(run, run.pilotL, playerDx)
    run.previousPilotL = run.pilotL
    if run.boss then boss1.step(run.boss) end
    if run.boss2 then boss2.step(run.boss2) end
    if run.boss3 then boss3.step(run.boss3) end
    if run.boss4 then boss4.step(run.boss4) end
    if run.boss5 then boss5.step(run.boss5) end
    if run.mid1 then mid1.step(run.mid1) end
    if run.mid2 then mid2.step(run.mid2) end
    if run.mid3 then mid3.step(run.mid3) end
    if run.mid4 then mid4.step(run.mid4) end
    if run.mid5 then mid5.step(run.mid5) end
    if run.warning then warning.step(run.warning) end
    enemies.step(run)
    stepSpawners(run)
    program.spawnRows(run, spawn)
    spawnPending(run)
    chips.step(run)
    score.tickCombo(run)
    effects.step(run)
    items.step(run)
    if player == run.player and player then players.weaponsStep(player) end
    bullets.step(run)
    contact(run, player)
    if player == run.player and player then playerHits(run, player.shots, 42, player) end
    if player == run.player and player then
        if pendingHit and player.protect == 0 then score.miss(run) end
        players.step(player, pendingHit)
        if not player.defeated then score.step(player) end
    end
    if run.stageCleared then
        score.stageBonus(run)
        if run.player and run.stageNumber == #program.stages and run.route.loop == 0 then
            local route = score.secondLoop(run.player)
            if route then
                run.nextRoute,run.nextStageNumber,run.campaignCleared = route,1,false
            end
        end
    end
    run.suppressShots = suppressShots
end

function M.consumePlayerHit(run)
    local hit = run.playerHit
    run.playerHit = nil
    return hit
end

function M.releaseScroll(run, major)
    scroll.release(run, major)
end

-- 测试入口可注入指定伤害。单人实战由 0xc99a2 设置单人标志，绕过双打的伤害折扣。
function M.playerShot(run, shot)
    if not shot.h then shot.h, shot.l = program.fixed(shot.x, shot.y) end
    return playerHits(run, {shot}, 1)
end

function M.addPlayer(run, model, options)
    assert(not run.player, '本地关卡已经有自机')
    run.fullDamage = true
    run.player = players.spawn(run, model, options)
    return run.player
end

function M.playerStock(run)
    local p = assert(run.player)
    return {life=p.life,bombs=p.bombs,level=p.level,misses=p.misses,bombsUsed=p.bombsUsed,
        score=p.score,extends=p.extends,extendSetting=p.extendSetting,autofireEnabled=p.autofireEnabled}
end

function M.advance(run)
    if not run.stageCleared or run.stageAdvanced or not run.nextStageNumber then return end
    local pilot = assert(run.player)
    local stock = M.playerStock(run)
    stock.keys = pilot.key
    local nextRun = M.init(run.nextStageNumber,run.nextRoute or run.routeName,run.art ~= nil)
    M.addPlayer(nextRun,pilot.model,stock)
    run.stageAdvanced = true
    M.close(run)
    return nextRun
end

function M.close(run)
    if run.player then players.close(run.player) end
    for _, o in ipairs(run.spawners) do if IsValid(o) then object.RawDel(o) end end
    if run.boss then boss1.close(run.boss) end
    if run.boss2 then boss2.close(run.boss2) end
    if run.boss3 then boss3.close(run.boss3) end
    if run.boss4 then boss4.close(run.boss4) end
    if run.boss5 then boss5.close(run.boss5) end
    if run.mid1 then mid1.close(run.mid1) end
    if run.mid2 then mid2.close(run.mid2) end
    if run.mid3 then mid3.close(run.mid3) end
    if run.mid4 then mid4.close(run.mid4) end
    if run.mid5 then mid5.close(run.mid5) end
    if run.warning then warning.close(run.warning) end
    enemies.clear(run)
    items.clear(run)
    chips.clear(run)
    effects.clear(run)
    bullets.clear(run, true)
    if IsValid(run.background) then object.RawDel(run.background) end
end

return M
