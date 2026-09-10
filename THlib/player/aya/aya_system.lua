LoadFX("fx:lilyBlur", "shader\\gaussian_blur.hlsl")

local cos, sin, int = cos, sin, int
local Dist, Angle = Dist, Angle
local task, object = task, object
TenguCamera = plus.Class()

function TenguCamera:init(player, VV, HH, preok, RR3, photob, photoPRE, photoOK, decay, speed)
    --三个照片机的素材
    self.player = player
    self.photob = photob
    self.photoPRE = photoPRE
    self.photoOK = photoOK
    --
    self.spell_rot = 0
    self.timer = 0
    self.decay = decay --拍照时取景框大小衰减系数
    self.moveSpeed = speed --相机移动速度
    self.centerx = player.x
    self.centery = player.y
    self.rot = 0
    self.VV = VV--67.5*0.3  --取景框宽
    self.HH = HH--90*0.3    --取景框长
    self.preok = preok--600  --蓄力量
    self.RR = sqrt(self.VV * self.VV + self.HH * self.HH)
    self.RRR = self.RR * 0.9
    self.RR3 = RR3
    self.ata = atan(self.HH / self.VV)
    self.photoing = false
    self.writing = false
    self.numofphoto = 0
    self.photodata = {}
    self.obj = nil

    self.target = nil
    self.target_select = nil
    self.have_photo = nil
    self.photo_hscore = 0
    for _, p in ipairs({ "A", "B", "C", "D" }) do
        self[p] = { x = 0, y = 0, fx = 0, fy = 0 }
    end
    self:Refresh()
    self._rot = 0
end

function TenguCamera:Refresh()
    local x, y, rot, ata = self.centerx, self.centery, self.rot + self.spell_rot, self.ata
    local r = self.RR * 1.3
    local r2 = self.RR * 1.3 + sin(8 * self.timer) * 3
    local a = { cos(rot + ata), sin(rot + ata), cos(rot - ata), sin(rot - ata) }
    self.A.x = x + r * a[1]
    self.A.y = y + r * a[2]
    self.B.x = x + r * a[3]
    self.B.y = y + r * a[4]
    self.C.x = x - r * a[1]
    self.C.y = y - r * a[2]
    self.D.x = x - r * a[3]
    self.D.y = y - r * a[4]
    self.A.fx = x + r2 * a[1]
    self.A.fy = y + r2 * a[2]
    self.B.fx = x + r2 * a[3]
    self.B.fy = y + r2 * a[4]
    self.C.fx = x - r2 * a[1]
    self.C.fy = y - r2 * a[2]
    self.D.fx = x - r2 * a[3]
    self.D.fy = y - r2 * a[4]

    if self.player._playersys:keyIsPressed("spell") then
        self.spell_rot = (self.spell_rot + 90) % 180
        PlaySound("focusfix2", 1)
    end

end

function TenguCamera:UpdateTarget()
    if #boss_group > 0 then
        if not self.target_select then
            self.target_select = 1
        end
        if self.player._playersys:keyIsPressed("slow") then
            self.target_select = self.target_select % #boss_group + 1
        end
        self.target = boss_group[self.target_select]
    else
        self.target = nil
        self.target_select = nil
    end
    if not IsValid(self.target) then
        self.target = nil
    end
end

function TenguCamera:SetAngle()
    local p = self.player
    local dx, dy = p.dx, p.dy
    local rot = math.deg(math.atan2(dy, dx))
    local range = (p.slow > 0) and 0.4 or 0.1
    if dx == dy and dx == 0 or p.slow > 0 then
        rot = IsValid(self.target) and Angle(p, self.target) or 90
    end
    local da = (rot - self.rot) % 360
    if da > 180 then
        da = da - 360
    end
    self.rot = self.rot + da * range
    --self._rot = rot
    --self.rot = self.rot + (-self.rot + self._rot) * range
end

function TenguCamera:UpdatePos()
    local p = self.player
    p.posR = 0.9 * p.posR + 0.1 * p.Rpos
    if not self.photoing then
        self:SetAngle()
        self.centerx = p.x + p.posR * cos(self.rot)
        self.centery = p.y + p.posR * sin(self.rot)
    end
end

function TenguCamera:frame()
    task.Do(self)
    self.timer = self.timer + 1
    self:Refresh()
    self:UpdateTarget()
    self:UpdatePos()
end

function TenguCamera:render()
    SetViewMode "world"
    if not self.photoing then
        Render4V(self.photob, self.A.fx, self.A.fy, 0.5, self.B.fx, self.B.fy, 0.5, self.C.fx, self.C.fy, 0.5, self.D.fx, self.D.fy, 0.5)
        if self.player.photopre < self.preok then
            SetImageState("photoPRE", "mul+add", 155, 255, 255, 255)
            Render(self.photoPRE, self.centerx, self.centery, -self.timer * 3 ^ (self.player.slow + 1), 0.6)
            local a = 70 * sin(self.timer * 2.5)
            SetFontState('Score', '', 120, 155 + a, 155 + a, 155 + a)
            RenderText("Score", "Disabled", self.centerx, self.centery, 0.25, 'left', 'top')
        else
            SetImageState("photoPRE", "mul+add", 195, unpack(IsValid(self.target) and self.target.self_color2 or { 200, 200, 200 }))
            Render(self.photoPRE, self.centerx, self.centery, -self.timer * 3 ^ (self.player.slow + 1), 1)
            local a = -100 * (int(self.timer / 60) % 2)
            SetFontState('Score', '', 120, 255, 255 + a, 255 + a)
            RenderText("Score", "Enabled", self.centerx, self.centery, 0.25, 'left', 'top')
        end
        SetFontState('Score', '', 150, 255, 255, 255)
        RenderText("Score", string.format('%d%%', min(self.player.photopre / self.preok * 100, 100)),
                self.centerx, self.centery, 0.3, 'right', 'bottom')
    end
    SetViewMode "ui"
    if self.texture then
        local pic = self.texture
        local color = Color(pic.alpha * 0.9, 255, 255, 255)
        SetImageState("white", "", color)
        Render4V("white", pic.oA.x, pic.oA.y, 0.5, pic.oB.x, pic.oB.y, 0.5, pic.oC.x, pic.oC.y, 0.5, pic.oD.x, pic.oD.y, 0.5)
        pic.uv1[6], pic.uv2[6], pic.uv3[6], pic.uv4[6] = color, color, color, color
        RenderTexture("PhotoTexture", '', pic.uv1, pic.uv2, pic.uv3, pic.uv4)
        pic.alpha = min(255, pic.alpha + 255 / 60)
    end

    SetViewMode 'world'
end

function TenguCamera:NewShotBonus(bonus, ...)
    table.insert(self.temptext, (New(shot_bonus[bonus], self.have_photo, self.nnn, ...)).text)
    self.nnn = self.nnn + 1
end

function TenguCamera:GetPhoto()
    local base_score = 6000
    local RR = self.RR
    local RR3 = self.RR3--self.RR*3.7 --拍摄时取景框对角线长度
    local decay = self.decay --拍照时取景框衰减系数
    local speed = self.moveSpeed
    self.fps = 20
    self.circleR = 1.2
    self.fpsing = true
    self.photoing = true
    task.New(self, function()
        PlaySound("focus")
        local data = scoredata
        for i = 1, 60 do
            self.fps = 20 + i / 1.5--ext里的fps设置
            self.circleR = 2 - i / 35--ext里的大circle半径
            if not self.player.__aya_shoot and not self.writing then
                if not ext.replay.IsReplay() then
                    data.total_photocount = data.total_photocount + 1
                    if data.total_photocount >= 500 then
                        ext.achievement:get(142)
                    elseif data.total_photocount >= 100 then
                        ext.achievement:get(141)
                    end
                end
                PlaySound("shutter")
                StopSound("focus")

                self.temptext = {}
                self.nnn = 0--奖励事件个数
                self.have_photo = New(self.NowPhoto, self, "PhotoTexture", self.A, self.B, self.C, self.D, self.centerx, self.centery, self.RR, RR * 2, self.ata)

                self:NewShotBonus("base score", base_score)

                self.player.photopre = 0
                local Math = sp.geom
                local bullet_counter = 0
                local enemy_counter = 0
                local people_counter = 0
                local color_list = {}
                local riskflag = false
                local getboss
                local getlaser, cx, cy
                local rect = Math.NewRectangle(Math.NewPoint(self.A), Math.NewPoint(self.B), Math.NewPoint(self.C), Math.NewPoint(self.D))
                local aya_player = aya_player
                local BulletBreak_Table = BulletBreak_Table
                if not sp.math.PointBoundCheck(self.centerx, self.centery, lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t) then
                    ext.achievement:get(27)
                end--拍到屏幕外

                for _, b in ipairs(boss_group) do
                    if Math.PointInRectangle(Math.NewPoint(b), rect) then
                        people_counter = people_counter + 1

                        if b.WALKIMGID == "Aya" then
                            ext.achievement:get(30)
                        end--文文拍文文
                        getboss = true
                    end
                end--拍boss检测

                object.BulletDo(function(o)
                    if o.colli and Math.PointInRectangle(Math.NewPoint(o), rect) then
                        if o.onPhotoFunc then
                            o:onPhotoFunc()
                        end
                        if o._index then
                            color_list[o._index] = o._index
                            bullet_counter = bullet_counter + 1
                        end
                        object.Del(o)
                        aya_player.NewSp(self.player, o.x, o.y, getboss)
                        if not riskflag and Dist(o, self.player) < 20 then
                            riskflag = true
                        end
                    end
                end)
                object.IndesDo(function(o)
                    if o.colli and Math.PointInRectangle(Math.NewPoint(o), rect) then
                        if o.onPhotoFunc then
                            o:onPhotoFunc()
                        end
                        if o._index then
                            color_list[o._index] = o._index
                            BulletBreak_Table:New(o.x, o.y, o._index)
                            bullet_counter = bullet_counter + 1
                        end --不会消除INDES，但是会有消弹动画
                        aya_player.NewSp(self.player, o.x, o.y, getboss)
                        if not riskflag and Dist(o, self.player) < 20 then
                            riskflag = true
                        end
                    end
                end)
                object.EnemyNontjtDo(function(o)
                    if o.onPhotoFunc then
                        o:onPhotoFunc()
                    end
                    if o.colli and Math.PointInRectangle(Math.NewPoint(o), rect) then
                        local take_dmgFunc = o.class.base.take_damage2 or o.class.base.take_damage
                        if take_dmgFunc then
                            take_dmgFunc(o, 400 - Dist(self.centerx, self.centery, o.x, o.y))
                            if o.IsBoss and (o.hp > 0) and (o.hp < 10) then
                                ext.achievement:get(36)
                            end--极限控血
                            enemy_counter = enemy_counter + 1
                        end
                    end
                end)
                object.LaserDo(function(o)
                    if o.IsBentLaser then

                        --无药可救的拍曲线激光检测，拍到激光头就可以消掉
                        if Math.PointInRectangle(Math.NewPoint(o), rect) then
                            object.Kill(o)
                        end
                    elseif o.colli and o.alpha > 0.999 and o.protect == 0 then
                        if o.onPhotoFunc then
                            o:onPhotoFunc()
                        end
                        getlaser = self.GetLaser(rect, o)
                        if getlaser and #getlaser == 2 then
                            cx, cy = cos(o.rot), sin(o.rot)
                            for l = getlaser[1], getlaser[2], 24 do
                                if o.index then
                                    color_list[o.index] = o.index
                                    aya_player.NewSp(self.player, o.x + l * cx, o.y + l * cy, getboss)
                                    BulletBreak_Table:New(o.x + l * cx, o.y + l * cy, o.index)
                                end
                            end
                            laser.CutOnRadius(o, unpack(getlaser))
                        end
                    end
                end)

                if getboss then
                    self:NewShotBonus("BOSS SHOT")
                    for _, b in ipairs(boss_group) do
                        if self.player.y < b.y and self.player.y > b.y - 50 and abs(self.player.x - b.x) < 30 then
                            self:NewShotBonus("SKIRT SHOT")
                            break
                        end
                    end
                end
                if enemy_counter > 0 then
                    self:NewShotBonus("enemy bonus", enemy_counter)
                end
                if bullet_counter == 0 then
                    if getboss then
                        self:NewShotBonus("SOLO SHOT")
                    end
                else
                    self:NewShotBonus("bullet bonus", bullet_counter)
                    if riskflag then
                        self:NewShotBonus("RISK SHOT")
                    end
                end
                if Math.PointInRectangle(Math.NewPoint(player), rect) and self.RR > RR then
                    self:NewShotBonus("SELF SHOT")
                    people_counter = people_counter + 1
                    if people_counter == 1 then
                        ext.achievement:get(26)
                    end--单人拍照成就
                end
                if getboss then
                    local num = { "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN" }
                    self:NewShotBonus(num[people_counter] .. " SHOT")
                    if base_score <= 1200 then
                        ext.achievement:get(31)
                    end--极限拍照
                end

                local color_num = sp:GetHashLength(color_list)
                if color_num >= 3 and color_num <= 6 then
                    self:NewShotBonus("COLORFUL SHOT")
                elseif color_num >= 7 then
                    self:NewShotBonus("RAINBOW SHOT")
                end
                local score = item.TweakScore(self.have_photo.score * self.have_photo.plus)
                lstg.var.score = lstg.var.score + score
                self:NewShotBonus("Total Score", score)
                self.writing = true
                break
            end
            if self.photoing and not self.writing then
                if self.player.__up_flag then
                    self.centery = self.centery + speed
                end
                if self.player.__down_flag then
                    self.centery = self.centery - speed
                end
                if self.player.__left_flag then
                    self.centerx = self.centerx - speed
                end
                if self.player.__right_flag then
                    self.centerx = self.centerx + speed
                end
            end
            self.RR = RR3 * cos(decay * i)
            if self.player.death > 80 then
                ext.achievement:get(29)
            end
            task.Wait()
            base_score = base_score - 100
        end
        StopSound("focus")
        self.RR = RR
        self.photoing = false
        self.writing = false
        task.SmoothSetValueTo("fps", 60, 60, 0)
        self.fpsing = false
        task.Clear(self)
    end)
end

function TenguCamera.GetLaser(rect, self)
    local len = self.l1 + self.l2 + self.l3
    local Math = sp.geom
    local point = Math.RectanglePointLine(rect,
            Math.NewLine(Math.NewPoint(self.x, self.y),
                    Math.NewPoint(self.x + cos(self.rot) * len, self.y + sin(self.rot) * len)))
    local l = {}
    if #point > 0 then
        for _, p in ipairs(point) do
            p[1] = p[1] - self.x
            p[2] = p[2] - self.y
            p[1] = p[1] * cos(self.rot) + p[2] * sin(self.rot)
            table.insert(l, Forbid(p[1], 0, len))
        end
    else
        return false
    end
    table.sort(l)
    if l[2] == 0 then
        return false
    else
        return l
    end
end
local WorldToScreen = WorldToScreen
local NowPhoto = Class(object, { frame = task.Do })
function NowPhoto:init(master, texture, A, B, C, D, centerx, centery)
    self.master = master
    self.layer = LAYER.TOP + 5
    self.group = GROUP.GHOST
    self.bound = false
    self.x = centerx + 480
    self.y = centery + 270
    self.A = { A.x - centerx, A.y - centery }
    self.B = { B.x - centerx, B.y - centery }
    self.C = { C.x - centerx, C.y - centery }
    self.D = { D.x - centerx, D.y - centery }
    self.alpha = 1
    self.texture = texture

    self.rot = 0
    self.flashalpha = 1
    self.score = 0
    self.plus = 1
    self.allscore = 0
    self.finalpos = nil

    local cosr, sinr = cos(self.rot), sin(self.rot)
    local R11, R12 = self.A[1] * cosr - self.A[2] * sinr, self.A[2] * cosr + self.A[1] * sinr
    local R21, R22 = self.B[1] * cosr - self.B[2] * sinr, self.B[2] * cosr + self.B[1] * sinr
    local R31, R32 = self.C[1] * cosr - self.C[2] * sinr, self.C[2] * cosr + self.C[1] * sinr
    local R41, R42 = self.D[1] * cosr - self.D[2] * sinr, self.D[2] * cosr + self.D[1] * sinr

    self.oA = { x = self.x + R11 * 1.05, y = self.y + R12 * 1.05 }
    self.oB = { x = self.x + R21 * 1.05, y = self.y + R22 * 1.05 }
    self.oC = { x = self.x + R31 * 1.05, y = self.y + R32 * 1.05 }
    self.oD = { x = self.x + R41 * 1.05, y = self.y + R42 * 1.05 }

    self.uv1, self.uv2, self.uv3, self.uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }

    self.uv1[1], self.uv1[2] = self.x + R11, self.y + R12
    self.uv2[1], self.uv2[2] = self.x + R21, self.y + R22
    self.uv3[1], self.uv3[2] = self.x + R31, self.y + R32
    self.uv4[1], self.uv4[2] = self.x + R41, self.y + R42

    self.uv1[4], self.uv1[5] = WorldToScreen(centerx + self.A[1], centery + self.A[2])
    self.uv2[4], self.uv2[5] = WorldToScreen(centerx + self.B[1], centery + self.B[2])
    self.uv3[4], self.uv3[5] = WorldToScreen(centerx + self.C[1], centery + self.C[2])
    self.uv4[4], self.uv4[5] = WorldToScreen(centerx + self.D[1], centery + self.D[2])

    local x, y = 870, 220
    self.master.texture = {
        alpha = 0,
        uv1 = { x + R11 * 0.3, y + R12 * 0.3, 0.5, self.uv1[4], self.uv1[5] },
        uv2 = { x + R21 * 0.3, y + R22 * 0.3, 0.5, self.uv2[4], self.uv2[5] },
        uv3 = { x + R31 * 0.3, y + R32 * 0.3, 0.5, self.uv3[4], self.uv3[5] },
        uv4 = { x + R41 * 0.3, y + R42 * 0.3, 0.5, self.uv4[4], self.uv4[5] },
        oA = { x = x + R11 * 0.31, y = y + R12 * 0.31 },
        oB = { x = x + R21 * 0.31, y = y + R22 * 0.31 },
        oC = { x = x + R31 * 0.31, y = y + R32 * 0.31 },
        oD = { x = x + R41 * 0.31, y = y + R42 * 0.31 },
    }
    x, y = 480, 270
    ext.Aya_texture = {
        uv1 = { x + R11, y + R12, 0.5, self.uv1[4], self.uv1[5] },
        uv2 = { x + R21, y + R22, 0.5, self.uv2[4], self.uv2[5] },
        uv3 = { x + R31, y + R32, 0.5, self.uv3[4], self.uv3[5] },
        uv4 = { x + R41, y + R42, 0.5, self.uv4[4], self.uv4[5] },
        oA = { x = x + R11 * 1.025, y = y + R12 * 1.025 },
        oB = { x = x + R21 * 1.025, y = y + R22 * 1.025 },
        oC = { x = x + R31 * 1.025, y = y + R32 * 1.025 },
        oD = { x = x + R41 * 1.025, y = y + R42 * 1.025 },
    }
    local scale = 1
    task.New(self, function()
        local ro = 360
        local rot = self.rot
        for i = 1, 30 do
            i = task.SetMode[2](i / 30)
            scale = 1 - i
            self.rot = rot + i * ro
            task.Wait()
        end
        self.master.writing = false
    end)
    task.New(self, function()

        while true do
            cosr, sinr = cos(self.rot), sin(self.rot)
            R11, R12 = (self.A[1] * cosr - self.A[2] * sinr) * scale, (self.A[2] * cosr + self.A[1] * sinr) * scale
            R21, R22 = (self.B[1] * cosr - self.B[2] * sinr) * scale, (self.B[2] * cosr + self.B[1] * sinr) * scale
            R31, R32 = (self.C[1] * cosr - self.C[2] * sinr) * scale, (self.C[2] * cosr + self.C[1] * sinr) * scale
            R41, R42 = (self.D[1] * cosr - self.D[2] * sinr) * scale, (self.D[2] * cosr + self.D[1] * sinr) * scale

            self.uv1[1], self.uv1[2] = self.x + R11, self.y + R12
            self.uv2[1], self.uv2[2] = self.x + R21, self.y + R22
            self.uv3[1], self.uv3[2] = self.x + R31, self.y + R32
            self.uv4[1], self.uv4[2] = self.x + R41, self.y + R42

            self.oA.x = self.x + R11 * 1.025
            self.oA.y = self.y + R12 * 1.025
            self.oB.x = self.x + R21 * 1.025
            self.oB.y = self.y + R22 * 1.025
            self.oC.x = self.x + R31 * 1.025
            self.oC.y = self.y + R32 * 1.025
            self.oD.x = self.x + R41 * 1.025
            self.oD.y = self.y + R42 * 1.025

            task.Wait()
        end
    end)

    task.New(self, function()
        task.MoveToEx(-50, -400, 30, 1)
    end)
    task.New(self, function()
        for i = 29, 0, -1 do
            self.alpha = i / 30
            task.Wait()
        end
        object.Del(self)
    end)
end
function NowPhoto:render()
    SetViewMode 'ui'

    SetImageState("white", "", self.alpha * 255, 255, 255, 255)
    Render4V("white", self.oA.x, self.oA.y, 0.5, self.oB.x, self.oB.y, 0.5, self.oC.x, self.oC.y, 0.5, self.oD.x, self.oD.y, 0.5)
    local color = Color(self.alpha * 255, 255, 255, 255)
    self.uv1[6], self.uv2[6], self.uv3[6], self.uv4[6] = color, color, color, color
    RenderTexture(self.texture, '', self.uv1, self.uv2, self.uv3, self.uv4)
    SetViewMode 'world'
end
TenguCamera.NowPhoto = NowPhoto
