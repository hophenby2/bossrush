-----------------------------------------
---东方栖霞园符卡 模版
-----------------------------------------
--导入其他包
local expression = EISlib.Effect.expression
local moveWithTask = EGGlib.ObjectEvent.moveWithTask

local dialog = Class(object)
function dialog:init(x, y, index)
    self.x, self.y = x, y
    self.img = "s3_road_dialog"..index
    self.hscale, self.vscale = 0, 0.6
    robject.set_color(self, "", 0, 255, 255, 255)
    task.New(self, function()
        local d_a, dh = 255/15, 0.6/15
        for _ = 1, 15 do
            self._a = self._a + d_a
            self.hscale = self.hscale + dh
            task.Wait(1)
        end
        task.Wait(105)
        d_a, dh = -255/15, -0.6/15
        for _ = 1, 15 do
            self._a = self._a + d_a
            self.hscale = self.hscale + dh
            task.Wait(1)
        end
        Del(self)
    end)
end
function dialog:frame()
    task.Do(self)
end
function dialog:render()
    EGGlib.RenderEffect.defaultRenderImg(self)
end

local function createCard(difficulty)
    local card = EGGlib.BossCard.createEscape(
            function(b)
                player.dialog = true
                b.x, b.y = -224, 100
                task.MoveTo(b, 0, 100, 60, MOVE_ACC_DEC)
                --从这个地方开始判定成就
                local open = true
                task.New(b, function()
                    --以boss为中心，划分8块扇形区域，自机在对话期间只要把八块区域都走一遍即可达成成就
                    local angle_list = {false, false, false, false, false, false, false, false}
                    local a, d
                    local rmin, rmax = 16, 150
                    while open do
                        d = Dist(b, player)
                        if d > rmin and d < rmax then
                            a = Angle(b, player) + 180 --取值必定是0~360
                            if a == 0 then --取值必定是1~360
                                a = a + 1
                            end
                            a = math.ceil(a/45)
                            angle_list[a] = true --标记这块区域已走过
                            local flag = true
                            for _, v in pairs(angle_list) do
                                if not v then
                                    flag = false
                                end
                            end
                            if flag then
                                local e = New(expression, b.x, b.y + 20, "stun") --这人在干什么啊？
                                moveWithTask(e, b,  0, 40) --obj, mst, dx ,dy, t
                                expression.defaultShow(e, 30, 60, 30) --t0, t1, t2
                                local x, y = b.x, b.y
                                tasker(function()
                                    task.Wait(60)
                                    PlaySound("bonus2")
                                    item.Blood.create(x, y, item.Blood.Huge)
                                end)
                                achievement.unlock("s3_mid", true, true) -- AchievementReminder.unlock("s3_mid", "我的太阳", "围绕第3关的露妮旋转，表达你的爱意") --真的绕了一圈啦
                                break
                            end
                        end
                        task.Wait(1)
                    end
                end)
                New(dialog, 80, 169, 1)
                PlaySound("dialog")
                task.Wait(135)
                New(dialog, 80, 169, 2)
                PlaySound("dialog")
                task.Wait(135)
                PlaySound("bonus2")
                item.PlayerLife.create(b.x, b.y) --掉落大血灵碎片（？）
                task.Wait(30)
                --从这之后结束判定成就
                open = false
                --之后就是向上逃跑事件
                task.MoveTo(b, -224, 100, 90, MOVE_ACC_DEC)
                player.dialog = false
                --system.PowerRank.resumeHyper() --从这里计时
                Del(b)
            end)
    return card
end
return createCard
