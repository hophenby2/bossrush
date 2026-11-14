-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
local curpath = EISlib.stage.path.."sence1/spellcard/mid_normal_1.lua" --当前存放目录
local defaultRenderImg = EGGlib.RenderEffect.defaultRenderImg
local alphaAndSizeChange = EGGlib.ObjectEvent.alphaAndSizeChange
local velchTask = EGGlib.ObjectEvent.velocityChangeTask
local argbChangeTask = EGGlib.ObjectEvent.argbChangeTask

local fog = Class(object)
function fog:init(x, y, a)
    self.x, self.y = x, y
    self.bound = false
    self.layer = LAYER_ENEMY_BULLET + 10
    self.hscale, self.vscale = 0.75, 0.75
    self.rot = ran:Float(0, 360)
    self.omiga = 0.1*ran:Sign()
    self.img = "fog"
    --EISlib.BossDefinition.Cirno.snow_img
    self.group = GROUP_GHOST
    self.colli = false
    robject.set_color(self, "", 0, 255, 255, 255)
    task.New(self, function()
        velchTask(self, 4, 2, a, 60)
        alphaAndSizeChange(self, 200, 0.75, 60)
        alphaAndSizeChange(self, -200, 0.75, 60)
        _del(self, false)
    end)
end
function fog:frame()
    if self.status == "normal" then
        task.Do(self)
    end
end
function fog:render()
    defaultRenderImg(self)
end

local function createCard(difficulty)
    --region 自定义子弹
    local B = {}
    --
    function B.bullet1(x, y, v, a, style, color)
        local obj = stg.newSimpleBullet(x, y, style, color)
        task.New(obj, function()

        end)
    end
    --endregion
    --region 子弹发射器定义
    local sect = EGGlib.BulletGroup.Sector.sectorLayer3
    local switch = EGGlib.Math.spSwitch
    local switch1 = EGGlib.Math.spSwitch1
    local A = {}
    --常用生成发弹点函数模版
    function A.createShooter1()
        local diff = difficulty --全局难度系数获取
        local rank = system.PowerRank.getRank()
        --case：way数
        local way0 = switch1(diff, {
            1, 1, 1, 1
        })
        local way1 = switch1(diff, {
            2, 3, 3, 3
        })
        local da = switch1(diff, {
            4, 4, 4, 4
        }) --每way间的间隔
        --case：层数
        local layer = switch1(diff, {
            2, 2, 3, 4
        })
        --case：初始弹速
        local v0 = switch1(diff, {
            1.5, 1.75, 2.25, 2.5
        }) + switch(rank, {
            0, 0.15, 0.3, 0.45, 1
        })
        --case：每层弹速差
        local dv_l = switch1(diff, {
            0.15, 0.175, 0.2, 0.2
        })
        local style, color = stg.grain_b, COLOR_BLUE
        function A.shooter1(x, y, a, sp_w)
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false,
                    function()
                        sect(x, y, v0, a, way0 + layer - 1, da, --base
                                way1, sp_w, --way, sp
                                layer, dv_l, 0, -1, --layer, dv, da, dway
                                function(x, y, v, a)
                                    stg.newSimpleStrChV(x, y, v+2, v, a, 60, 0, style, color)
                                end)
                    end)
        end
    end
    --自机狙
    local circle_layer1 = EGGlib.BulletGroup.Circle.layer1
    function A.createShooter2()
        local rank = system.PowerRank.getRank()
        --case：决定最外层way数
        local way = switch1(difficulty, {
            6, 9, 12, 15
        })
        --case:决定一共有多少层
        local layer = switch1(difficulty, {
            1, 1, 2, 3, 3
        }) + switch(rank, {
            0, 0, 0, 0, 1
        })
        local da = switch1(difficulty, {
            0, 0, 1, 2
        })
        --case:决定最慢层的弹速
        local v0 = switch1(difficulty, {
            1.25, 1.35, 1.5, 1.75
        }) + switch(rank, {
            0, 0.15, 0.3, 0.45, 0.9
        })
        local dv = switch1(difficulty, {
            0, 0.2, 0.225, 0.25
        }) + switch(rank, {
            0, 0.01, 0.02, 0.03, 0.05
        })
        local style, color = stg.grain_a, COLOR_BLUE
        function A.shooter2(x, y, a, dv0, u)
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false,
                    function()
                        circle_layer1(x, y, v0 + dv0, a, way, --base
                                layer, dv, da*u, 0, --layer, dv, da, 0,
                        function(x, y, v, a)
                            stg.newSimpleStrChV(x, y, v+2, v, a, 60, 0, style, color)
                        end)
                    end)
        end
    end
    --多层开花弹
    function A.createShooter3()
        local rank = system.PowerRank.getRank()
        --case：决定最小层way数
        local way = switch1(difficulty, {
            0, 24, 36, 48
        })
        local dway = switch1(difficulty, {
            0, 2, 3, 4
        })
        --case:决定一共有多少层
        local layer = switch1(difficulty, {
            0, 2, 3, 6
        })
        --case:决定最慢层的弹速
        local v0 = switch1(difficulty, {
            0, 1, 1, 1
        }) + switch(rank, {
            0, 0.1, 0.2, 0.3, 0.75
        })
        local dv = switch1(difficulty, {
            0, 0.25, 0.35, 0.45
        }) + switch(rank, {
            0, 0.05, 0.075, 0.1, 0.15
        })
        local style, color = stg.ball_mid, COLOR_BLUE
        function A.shooter3(x, y, a)
            PlaySound("tan00")
            stg.newFadeEffect(x, y, style, color, false,
                    function()
                        circle_layer1(x, y, v0, a, way, --base
                                layer, dv, 0, -dway, --layer, dv, da, dway,
                                function(x, y, v, a)
                                    stg.newSimpleStrChV(x, y, v+1, v, a, 60, 0, style, color)
                                end)
                    end)
        end
    end
    --endregion
    --region Tasker 任务执行器
    local T = {}
    --常用生成任务执行器模版
    function T.createTasker1()
        local diff = difficulty
        --case：攻击次数
        local count = switch1(diff, {
            6, 9, 12, 15
        })
        --case：最小时的扩散角
        local sp0 = switch1(diff, {
            120, 80, 60, 90
        })
        local dsp = (360 - sp0)/(count - 1)
        local da = 360/count
        local wt = 60/count
        function T.tasker1(b, a0, u)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    for i = count - 1, 0, -1 do
                        A.shooter1(b.x, b.y, a0 + da*i*u, sp0 + dsp*i)
                        task.Wait(wt)
                    end
                    Del(obj)
                end)
            end, true)
        end
    end
    --自机狙
    function T.createTasker2()
        --case：决定发多少次
        local atkcount = switch1(difficulty, {
            6, 8, 12, 12
        })
        --case：决定发几层
        local layer = switch1(difficulty, {
            1, 1, 1, 2
        })
        local wait = 120/atkcount
        function T.tasker2(b, u)
            boss.createTasker(b, b.x, b.y, function(obj)
                task.New(obj, function()
                    for _ = 1, atkcount do
                        for i = 0, layer - 1 do
                            A.shooter2(b.x, b.y, Angle(b, player), i, u)
                        end
                        task.Wait(wait)
                    end
                    Del(obj)
                end)
            end, true)
        end
    end
    --endregion
    --region 组合攻击
    local C = {} --combination
    local move = EGGlib.ObjectEvent.moveToPlayerDefault
    function C.createFIRST()
        local rank = system.PowerRank.getRank()
        local wait = 60
        function C.FIRST(b, u)
            task.New(b, function()
                task.MoveTo(b, 0, 120, 120, MOVE_ACC_DEC)
            end)
            T.tasker1(b, -90 - 150*u + ran:Float(-5, 5), u)
            A.shooter3(b.x, b.y, -90)
            task.Wait(wait)
        end
    end
    function C.createSECOND()
        function C.SECOND(b, u)
            task.New(b, function()
                task.MoveTo(b, 60*u, 120, 120, MOVE_ACC_DEC)
            end)
            T.tasker2(b, -u)
            task.Wait(60)
        end
    end
    --endregion

    --若rank有变化，则必须更新一次
    local rank = -1
    local function reFresh()
        if rank ~= system.PowerRank.getRank() then --以下两个会受rank影响，需要更新
            A.createShooter1()
            A.createShooter2()
            A.createShooter3()
            T.createTasker1()
            T.createTasker2()
            C.createFIRST()
            C.createSECOND()
            rank = system.PowerRank.getRank()
        end
    end

    local function bgChangePr()
        local bg = lstg.tmpvar.bg
        if IsValid(bg) and  bg.class.Sence3And4 then
            bg.class.Sence3And4(bg, true, true)
        end
    end
    
    local card_name = {
        "name-boss1-normal1-E",
        "name-boss1-normal1-N",
        "name-boss1-normal1-H",
        "name-boss1-normal1-L",
    }
    local card = EGGlib.BossCard.createFullCard(
            card_name[difficulty], --非/符卡名
            "normal", --类型
            {0, 0, 19}, --时间
            1200, --耐久
            system.DROP_NORMAL, --掉落
            function(b) --普通模式攻击前动作
                local way = 8
                local da = 180/(way - 1)
                way = (way - 1)/2
                for i = -way, way do
                    New(fog, 0, 250, da*i - 90)
                end
                argbChangeTask(b, 0, 0, 0, 0, 60)
                task.MoveTo(b, 0, 120, 60, MOVE_ACC_DEC)
                system.record.unlockPerformer("Cirno")
                boss.show_aura(b, true)
            end,
            function(b) --练习模式攻击前动作
                bgChangePr()
                b.x, b.y = 0, 120
                boss.show_aura(b, true)
            end,
            function(b) --main
                while true do
                    for u = 1, -1, -2 do
                        reFresh()
                        C.FIRST(b, u)
                        C.SECOND(b, u)
                        b.cast("revolve")
                    end
                end
            end,
            function(b) --finish

            end,
            4, --difficulty
            system.card.DEFAULT_ATTRIBUTE --五边形等级
    )
    return card
end

return createCard