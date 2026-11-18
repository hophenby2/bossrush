-- 第一面由 0x0c09bdaa 读入的飞虫。0x11 挂载 0x0c0a2940，0x13 和 0x23 共用 0x0c0a2cc0。
local direction = dofile('mod/GAME/th46/direction.lua')
local createWorm = dofile('mod/GAME/th46/worm1.lua')
local createMidBoss = dofile('mod/GAME/th46/midboss1.lua')
local gold = dofile('mod/GAME/th46/gold.lua')
local plants = dofile('mod/GAME/th46/plants.lua')
local flyDeath = dofile('mod/GAME/th46/fly_death.lua')
local createBeetle = dofile('mod/GAME/th46/beetle.lua')
local createSkimmer = dofile('mod/GAME/th46/skimmer.lua')
local createLongfly = dofile('mod/GAME/th46/longfly.lua')
local createGroundbug = dofile('mod/GAME/th46/groundbug.lua')
local groundscroll = dofile('mod/GAME/th46/groundscroll.lua')
local originalRank = dofile('mod/GAME/th46/rank.lua')
local unit, heading, vector = direction.unit, direction.heading, direction.vector
local floor, abs = math.floor, math.abs
-- 带速度的指令在入场后减速转向，0x23 还在初始化完成后镜像横坐标。
local spawns = {
    {55,50,352}, {114,180,352}, {130,220,352},
    {159,110,368,52,true}, {179,67,368,52,true}, {198,25,363,52,true},
    {409,136,368,52}, {425,199,368,52}, {441,162,368,52},
    {505,-12,393}, {505,76,401}, {505,21,352}, {537,45,352},
    -- 卷轴位置 181–208。0x0c0a27c0 在蜈蚣禁入期间跳过这些指令。
    {1225,83,368,52,gated=true}, {1241,132,368,52,gated=true}, {1257,179,368,52,gated=true},
    {1609,122,352,gated=true}, {1625,84,355,gated=true},
    {1641,203,368,52,gated=true}, {1657,155,368,52,gated=true},
    {1913,150,368,52}, {1929,176,368,52}, {1945,205,368,52}, {1945,146,407,52},
    {2329,151,352}, {2329,220,368,52}, {2345,180,352}, {2345,135,368,52},
    {2361,199,368,52}, {2377,145,368,52}, {2393,180,352},
    {2409,202,352}, {2425,223,352}, {2438,250,352},
    -- 0x0c1ee610 起的位置 378–391 和 396 都在中 Boss 提前击破后才挂载。
    {3436,192,382,52,gated=true}, {3436,129,368,52,gated=true},
    {3452,228,368,52,gated=true}, {3460,150,367,52,gated=true},
    {3516,49,368,52,gated=true}, {3524,113,368,52,gated=true},
    {3532,39,368,52,gated=true}, {3540,83,372,52,gated=true},
    {3580,147,368,56,gated=true},
    -- 参数表 1 的速度为 56。397–399 在自然超时分支也能挂载。
    {3588,202,368,56}, {3588,140,400,56},
    {3596,223,368,56}, {3604,171,368,56},
    -- 卷轴位置 440–443。第二只蜈蚣自然退场时跳过，提前击破后可挂载。
    {4126,140,368,52,gated=true},
    {4142,126,398,52,gated=true}, {4142,177,368,52,gated=true},
    {4158,214,368,52,gated=true}, {4174,146,368,52,gated=true},
    -- 原表卷轴位置 465–496。两处飞虫禁入状态自然解除后，这些指令均会挂载。
    {4526,81,368,52}, {4542,34,368,52}, {4590,220,368,52}, {4606,180,368,52}, {4622,136,368,52},
    {4782,36,397,52}, {4782,96,368,52}, {4798,77,386,52}, {4814,13,368,52},
    {4990,140,368,52}, {4990,204,391,52}, {5006,171,374,52}, {5022,218,368,52},
}
local cameraStep = 0x2c000
local muzzle = {
    {1,3},{1,3},{2,3},{2,2},{3,2},{4,2},{4,1},{4,0},
    {4,0},{4,-1},{4,-2},{4,-2},{3,-3},{3,-3},{2,-3},{1,-3},
    {1,-4},{0,-3},{-1,-3},{-2,-3},{-2,-2},{-3,-2},{-3,-2},{-3,-1},
    {-3,0},{-3,0},{-3,1},{-3,1},{-3,2},{-3,2},{-1,3},{0,3},
}
local wingPhase = {0,1,2,3,2,1}
-- stage1.bin 中确认属于两只蜈蚣的 0x093b 系列裁片，包括残影的分块。
local sampledWormShots = {
    {1132,1201,{17,18,19,20,21,22,23,24,29,30,32,41,42,43,44,45,47,48,52,53,
                54,61,62,63,67,68,73,74,76,77,80,84,85,88,89,91,92,93,94,97}},
    {3876,3924,{62,63,75,76,155,158,159,160,165,167,170,173,174}},
}
local function shotFacing(aim)
    local sector = floor(((aim+4)%512)/8)
    if sector<=16 then return sector,1,1 end
    if sector<=32 then return 32-sector,1,-1 end
    if sector<=48 then return sector-32,-1,-1 end
    return 64-sector,-1,1
end

local function camera(run, vx)
    -- 0x0c09b86a 与 0x0c09c00e 累加自机横向速度；跨过阈值时卷轴移动一像素。
    if run.roadCamera * vx > 0 and abs(run.roadCamera) == 40 then return 0 end
    local rest = run.roadCameraRest + vx
    local shift = rest >= cameraStep and 1 or rest <= -cameraStep and -1 or 0
    run.roadCameraRest, run.roadCamera = rest-shift*cameraStep, run.roadCamera+shift
    return -shift*unit
end

local function place(o)
    o.x, o.y = o.boardX/unit-120, o.boardY/unit-160
end

local function aimAt(o,p)
    local position = p.pilotPosition
    return p.respawn==0 and heading(o.boardX,o.boardY,position.x,position.y) or 256
end

local function rank(run)
    return originalRank.get(run)
end

local function turnTowards(current, aim)
    local change = (aim-current+256)%512-256
    return (current+math.max(-8,math.min(8,change)))%512
end

local function hitPilot(o, p)
    local s = p.pilotPosition
    -- 0x0c0656da 将双方定点坐标截成整数，再比较含边界的矩形。
    return abs(floor(o.boardX/unit)-floor(s.x/unit)) <= o.contactRadius+2
       and abs(floor(o.boardY/unit)-floor(s.y/unit-1)) <= o.contactRadius+2
end

local function offBoard(o)
    return o.boardX<0 or o.boardX>240*unit or o.boardY<0 or o.boardY>=320*unit
end

local function cancelOnContact(o)
    -- 0x0c06e6f0 解除判定，切到 16 格消弹动画。
    o.cancelFrame, o.colli = 0, false
end

return function()
    local Bullet = Class(object, {
        init = function(o, run, x, y, aim, offset, kind)
            o.run, o.serial, o.age = run, run.serial, 0
            -- 0x0c06e610 在关卡基速 43 上加指令速度和 rank >> 5。
            o.boardVX, o.boardVY = vector(43+(offset or 12)+floor(rank(run)/32),aim)
            o.bank = kind==0x19 and 'thin_shot' or kind==0x12 and 'beetle_shot' or offset and 'worm_shot' or 'shot'
            o.spriteColumn, o.flipX, o.flipY = shotFacing(aim)
            o.flash = run.roadFlash
            run.roadFlash = (o.flash+1)%4
            -- 0x0c06ecc0 在分配当步先走速度 64，之后 0x0c06f0a0 才使用记录的速度 55。
            local firstVX, firstVY = vector(64,aim)
            o.boardX, o.boardY = x+run.roadCameraDelta+firstVX, y+firstVY
            o.group, o.layer = GROUP.ENEMY_BULLET, LAYER.ENEMY_BULLET
            o.a, o.b, o.rect, o.bound, o.colli = 1, 2, true, false, true
            -- 原程序注册的是点判定，宽判定额外容纳定点取整的误差。
            o.contactRadius, o.hitPilot, o.keepOnHit = 0, hitPilot, true
            o.cancelOnClear=cancelOnContact
            if offset then o.cancelOnContact=cancelOnContact end
            place(o)
            if offset and offBoard(o) then
                o.hide, o.colli = true, false
                object.RawDel(o)
            end
        end,
        frame = function(o)
            if o.serial == o.run.serial then return end
            o.serial, o.age = o.run.serial, o.age+1
            if o.fade then
                o.fade = o.fade-1
                if o.fade == 0 then object.RawDel(o); return end
            end
            local vx,vy = o.boardVX,o.boardVY
            if o.cancelFrame then
                o.cancelFrame=o.cancelFrame+1
                if o.cancelFrame>=32 then object.RawDel(o); return end
                vx,vy=math.modf(vx/2),math.modf(vy/2)
            end
            o.boardX, o.boardY = o.boardX+o.run.roadCameraDelta+vx, o.boardY+vy
            if offBoard(o) then
                object.RawDel(o)
                return
            end
            place(o)
        end,
        render = function(o)
            if o.cancelFrame then
                local image='th46_road1_cancel_'..floor(o.cancelFrame/2)
                SetImageState(image,'',o.fade and o.fade*17 or 255,255,255,255)
                Render(image,floor(o.x),floor(o.y))
                return
            end
            local bank = o.age==0 and 'flash' or o.bank
            local col, phase = o.spriteColumn, o.flash
            if o.age>0 then
                if o.bank=='thin_shot' then
                    col,phase=floor(col/2),floor((o.age+2)/3)%3
                else
                    phase=floor((o.age+1)/2)%4
                end
            end
            local image = 'th46_road1_'..bank..'_'..col..'_'..phase
            local alpha = o.fade and o.fade*17 or 255
            SetImageState(image,'',alpha,255,255,255)
            Render(image,floor(o.x),floor(o.y),0,o.flipX,o.flipY)
            if o.age>0 and o.bank~='thin_shot' then
                -- 0x0c06f130 在弹体后画上一格的残影。以 LuaSTG 加色近似板上的 0x3aff 混色。
                SetImageState(image,'mul+add',floor(58*alpha/255),255,255,255)
                Render(image,floor(o.x-o.boardVX/unit),floor(o.y-o.boardVY/unit),0,o.flipX,o.flipY)
            end
            SetImageState(image,'',255,255,255,255)
        end,
    })

    local function emit(run,x,y,aim,offset,kind)
        if run.roadShotResume and run.roadFrame<run.roadShotResume then return end
        New(Bullet,run,x,y,aim,offset,kind)
    end
    local worm = createWorm(emit)
    local midBoss = createMidBoss(emit)
    local beetle = createBeetle(emit)
    local skimmer = createSkimmer(emit)
    local longfly = createLongfly(emit)
    local groundbug = createGroundbug(emit)

    local damage = flyDeath.damage

    local Shadows=Class(object,{
        init=function(o,run)
            o.run,o.group,o.layer,o.bound,o.colli=run,GROUP.GHOST,LAYER.ENEMY-1,false,false
        end,
        render=function(o)
            -- 原版投影深度比飞虫本体低一层；集中在独立对象绘制，避免盖住先画的其它飞虫。
            for _,bug in pairs(o.run.roadEnemies) do
                if IsValid(bug) then
                    local sector=floor(((bug.facing+8)%512)/16)
                    local flip=sector>15 and -1 or 1
                    local column=sector>15 and 32-sector or sector
                    local image='th46_road1_shadow_'..column
                    -- 差异 1：保留原投影图、锚点与 (+24,-88) 偏移，板上黑色混合用半透明黑近似。
                    SetImageState(image,'',128,0,0,0)
                    Render(image,floor(bug.x)+24,floor(bug.y)-88,0,flip,1)
                end
            end
        end,
    })

    local Enemy = Class(object, {
        init = function(o, run, spawn, p)
            -- 0x0c0758e4 从轨道横坐标扣掉卷轴当前位置，再交给飞虫构造器。
            o.run, o.boardX, o.boardY = run, (spawn[2]-run.roadCamera)*unit, spawn[3]*unit
            o.heading, o.facing = 256, 0
            o.turning, o.speed = spawn[4]~=nil, spawn[4] or 48
            o.hp, o.damage = 64, damage
            o.player = p
            o.aimClock, o.turnClock, o.turns = 36-floor(rank(run)/16), 2, 50
            o.wingClock, o.wing, o.entered = 0, 0, false
            o.group, o.layer = GROUP.ENEMY, LAYER.ENEMY
            o.a, o.b, o.rect, o.bound, o.colli = 19, 20, true, false, true
            o.contactRadius, o.hitPilot = 18, hitPilot
            if o.turning then
                -- 0x0c0a14c0 先按轨道坐标算初始朝向，0x0c0a1670 返回后才翻转横坐标。
                o.facing = floor(aimAt(o,p)/32)*32
                o.speedClock = 1
                if spawn[5] then o.boardX = 240*unit-o.boardX end
            end
            place(o)
        end,
        colli = function(o, shot)
            if not shot.dmg or not shot.colli or not o.colli then return end
            damage(o,shot.dmg,shot.damageFlags)
            shot.colli=false
            object.RawDel(shot)
        end,
        render = function(o)
            local sector = floor(((o.facing+8)%512)/16)
            local flip = sector>15 and -1 or 1
            local column = sector>15 and 32-sector or sector
            Render('th46_road1_bug_'..column..'_'..wingPhase[o.wing+1],floor(o.x),floor(o.y),0,flip,1)
        end,
    })

    local function fire(o,p,aim)
        o.aimClock = o.aimClock-1
        if o.aimClock >= 0 then return end
        o.aimClock = 38-floor(rank(o.run)/8)
        if p.respawn ~= 0 then return end
        local offset = muzzle[floor(aim/16)+1]
        local x,y = o.boardX+offset[1]*unit, o.boardY+offset[2]*unit
        if y>112*unit then emit(o.run,x,y,aim) end
    end

    local function turningFlight(o,p,aim)
        -- 0x0c0a2cc0 的移位先使用旧速度和朝向，从静止转入退场的那步也不发弹。
        if o.retreat then
            if o.speed < 56 then
                o.speedClock = o.speedClock-1
                if o.speedClock < 0 then o.speedClock,o.speed=3,o.speed+2 end
            end
            if not o.turnComplete then
                o.turnClock = o.turnClock-1
                if o.turnClock < 0 then
                    o.turnClock = 2
                    o.heading = floor(((o.heading+o.retreatTurn)%512)/32)*32
                    o.facing = o.heading
                    o.turnComplete = o.heading==0
                end
            end
            return
        end
        if o.speed > 0 then
            o.speedClock = o.speedClock-1
            if o.speedClock < 0 then
                o.speedClock,o.speed=2,o.speed-2
                if o.speed==0 then
                    o.heading,o.aimClock,o.turnClock,o.speedClock=o.facing,16,48,2
                    o.retreatTurn = o.heading>0 and -32 or 0
                end
            end
        end
        o.facing = turnTowards(o.facing,aim)
        if o.speed==0 then
            o.retreat = true
        else
            fire(o,p,aim)
        end
    end

    local function updateEnemy(o, p, dx)
        local visible = o.boardY > -16*unit and o.boardY < 336*unit and o.boardX > -56*unit and o.boardX < 296*unit
        if o.hp <= 0 or (o.entered and not visible) then
            object.RawDel(o)
            return false
        end
        o.entered = visible or o.entered
        if not o.turning then o.facing = o.heading end
        local vx, vy = vector(o.speed,o.heading)
        o.boardX, o.boardY = o.boardX+vx+dx, o.boardY+vy
        place(o)
        o.wingClock = o.wingClock-1
        if o.wingClock < 0 then o.wingClock,o.wing=2,(o.wing+1)%6 end
        local aim = aimAt(o,p)
        if o.turning then
            turningFlight(o,p,aim)
            return true
        end
        fire(o,p,aim)
        o.turnClock = o.turnClock-1
        if o.turnClock < 0 and o.turns > 0 then
            o.turnClock, o.turns = 2, o.turns-1
            o.heading = turnTowards(o.heading,aim)
        end
        return true
    end

    local function step(run, frame, p, previousVX)
        local dx = camera(run, previousVX)
        run.roadCameraDelta = dx
        groundscroll.step(run)
        worm.step(run,frame,p,dx)
        plants.step(run,frame,p)
        midBoss.step(run,frame,p,dx)
        beetle.step(run,frame,p)
        skimmer.step(run,frame,p)
        longfly.step(run,frame,p)
        groundbug.step(run,frame,p)
        for i = 1, run.nextRoadSpawn-1 do
            local o = run.roadEnemies[i]
            if IsValid(o) and not updateEnemy(o,p,dx) then run.roadEnemies[i]=nil end
        end
        local index = run.nextRoadSpawn
        while spawns[index] and spawns[index][1] == frame do
            local spawn = spawns[index]
            if not spawn.gated or not (run.wormGate or run.midGate) then
                run.roadEnemies[index] = New(Enemy,run,spawn,p)
            end
            index=index+1
        end
        run.nextRoadSpawn = index
        if run.wormClearUntil and frame<=run.wormClearUntil then run.wormClearShots()end
    end

    local Clock = Class(object, {
        init = function(o, run, player)
            o.run, o.player, o.serial, o.previousVX = run, player, run.serial, 0
            o.group, o.bound, o.colli = GROUP.GHOST, false, false
        end,
        frame = function(o)
            local run = o.run
            if run.stageNumber ~= 1 then
                worm.close(run)
                gold.close(run)
                plants.close(run)
                flyDeath.close(run)
                beetle.close(run)
                skimmer.close(run)
                longfly.close(run)
                groundbug.close(run)
                if IsValid(run.roadShadows) then object.RawDel(run.roadShadows) end
                run.goldStage=0
                object.RawDel(o)
                return
            end
            if not run.roadFrame or o.serial == run.serial then return end
            o.serial = run.serial
            -- 卷轴读取上一步的速度，0x0c076220 的寻向读取本步自机的新坐标。
            step(run,run.roadFrame,o.player,o.previousVX)
            o.previousVX = o.player.pilotPosition.vx
        end,
    })

    local function open(run)
        run.wormClearUntil=nil
        run.wormClearShots=function()
            for _,o in ObjList(GROUP.ENEMY_BULLET)do
                if o.run==run and o.cancelOnClear and not o.cancelFrame then o.cancelOnClear(o)end
            end
        end
        run.goldStage=0
        run.roadCamera, run.roadCameraRest, run.roadCameraDelta = 0, 0, 0
        run.roadShotResume=nil
        run.roadSlow=nil
        run.roadRank,run.roadRankTime=nil,nil
        run.roadEnemies, run.nextRoadSpawn, run.roadFlash = {}, 1, 0
        worm.open()
        midBoss.open()
        gold.open()
        plants.open(run)
        flyDeath.open(run)
        beetle.open(run)
        skimmer.open(run)
        longfly.open(run)
        groundscroll.open(run)
        groundbug.open(run)
        if not CheckRes('img','th46_road1_bug_0_0') then
            LoadTexture('th46_road1','Resources/th46/stage1/road1.png')
            SetTextureSamplerState('th46_road1','point+clamp')
            for direction = 0, 16 do
                LoadImage('th46_road1_shadow_'..direction,'th46_road1',direction*80,800,80,80)
                for phase = 0, 3 do
                    local suffix = direction..'_'..phase
                    LoadImage('th46_road1_bug_'..suffix,'th46_road1',direction*80,phase*80,80,80)
                    LoadImage('th46_road1_shot_'..suffix,'th46_road1',direction*32,320+phase*32,32,32)
                    LoadImage('th46_road1_flash_'..suffix,'th46_road1',direction*32,448+phase*32,32,32)
                    LoadImage('th46_road1_worm_shot_'..suffix,'th46_road1',direction*32,576+phase*32,32,32)
                end
            end
            for phase = 0, 15 do
                LoadImage('th46_road1_cancel_'..phase,'th46_road1',544+phase*16,576,16,16)
            end
            for direction=0,8 do
                for phase=0,2 do
                    LoadImage('th46_road1_thin_shot_'..direction..'_'..phase,'th46_road1',direction*32,704+phase*32,32,32)
                end
            end
        end
        run.roadShadows=New(Shadows,run)
        -- 删除已经由对应原生飞虫和首发敌弹重建的采样轨迹。
        for frame, id in pairs({[94]=16,[219]=21,[4684]=1298,[4947]=1395}) do
            local sampled = run.data.enemies[frame] or {}
            for i, entry in ipairs(sampled) do
                if entry.id==id then table.remove(sampled,i); break end
            end
        end
        -- 与原版裁片比对过的中 Boss 翅、爪、腹部，以及禁入段重复拆分的飞虫轨迹。
        local replaced={
            [927]=true,[940]=true,[941]=true,[972]=true,[973]=true,[981]=true,[982]=true,
            [1072]=true,[1074]=true,[1075]=true,[1091]=true,[1093]=true,[1098]=true,[1101]=true,[1102]=true,
        }
        for frame=2684,3735 do
            local sampled=run.data.enemies[frame] or {}
            for i=#sampled,1,-1 do
                if replaced[sampled[i].id] then table.remove(sampled,i) end
            end
        end
        for _, span in ipairs(sampledWormShots) do
            local images = {}
            for _, image in ipairs(span[3]) do images[image]=true end
            for frame = span[1], span[2] do
                local sampled = run.data.shots[frame]
                if sampled then
                    for i = #sampled, 1, -1 do
                        if images[sampled[i].image] then table.remove(sampled,i) end
                    end
                end
            end
        end
    end

    return {
        open = open,
        advance = function(run)
            local slow=run.roadSlow
            if not slow then originalRank.advance(run);return true end
            -- 原版第 8655、8657…8817 帧更新；8818 仍等待，8819 起每帧更新。
            slow.phase=1-slow.phase
            if slow.phase==1 then originalRank.advance(run);return true end
            if not slow.enabled then run.roadSlow=nil end
            return false
        end,
        attach = function(run, player) run.roadClock=New(Clock,run,player) end,
        close = function(run)
            run.wormClearUntil,run.wormClearShots=nil,nil
            run.roadSlow=nil
            if IsValid(run.roadClock) then object.RawDel(run.roadClock) end
            if IsValid(run.roadShadows) then object.RawDel(run.roadShadows) end
            worm.close(run)
            midBoss.close(run)
            gold.close(run)
            plants.close(run)
            flyDeath.close(run)
            beetle.close(run)
            skimmer.close(run)
            longfly.close(run)
            groundbug.close(run)
            for _, o in pairs(run.roadEnemies) do
                if IsValid(o) then o.hide=true; object.RawDel(o) end
            end
        end,
    }
end
