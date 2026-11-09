---clear_bullet
---用消弹圈切割直线激光
---@param drop object|fun(x:number, y:number)@掉落的道具
---@param targets table|nil@换卡时只处理已有弹幕；省略则持续清除新弹
local function cutLasersByCircle(x1, y1, r, drop, force, targets)
    local drop_func
    if type(drop) == "function" then
        drop_func = drop
    else
        drop_func = function(x, y)
            New(drop, x, y)
        end
    end
    object.LaserDo(function(self)
        if (not targets or targets[self]) and not self.IsBentLaser and IsValid(self) and self.status~='del' and self.status~='kill' then
            local native=self._native_laser_game or self._native_laser_managed or self.th06_width
            if (native or (self.colli and self.alpha > 0.999)) and self.protect == 0 then
                --用尽毕生所学
                local lx, ly = self.x, self.y
                local len = self.l1 + self.l2 + self.l3
                local dx, dy = x1 - lx, y1 - ly--向量
                local cosr, sinr = cos(self.rot), sin(self.rot)
                local a, b, c = sinr, -cosr, cosr * ly - sinr * lx
                local dist = abs(a * x1 + b * y1 + c) / sqrt(a * a + b * b)
                if dist < r then
                    if native then
                        -- 各作按自己的采样间隔消整条光，不复制缺少ECL寿命状态的THlib片段。
                        local along=dx*cosr+dy*sinr
                        local half=sqrt(r*r-dist*dist)
                        if along+half>=0 and along-half<=len and not self._native_cancelled then
                            if drop then
                                OriginalBulletVisual.laser_drops(self,drop_func,force)
                            end
                            OriginalBulletVisual.cancel_laser(self,nil,force)
                        end
                        return
                    end
                    local d = sqrt(r * r - dist * dist)
                    local l = sign(dx * cosr + dy * sinr) * sqrt(dx * dx + dy * dy - dist * dist)
                    local cut, _l1, _l2
                    if l >= d then
                        local l1, l2 = l - d, l + d
                        if l1 < len then
                            _l1, _l2 = laser.CutOnRadius(self, l1, l2, targets)
                            cut = true
                        end
                    elseif l >= -d then
                        local l1, l2 = 0, d + l
                        _l1, _l2 = laser.CutOnRadius(self, l1, l2, targets)
                        cut = true
                    end
                    if cut and drop and self.drop_CD == 0 then
                        --间隔4采样
                        for L = _l1, _l2, 4 do
                            local x, y = lx + cosr * L, ly + sinr * L
                            drop_func(x, y)
                            if self.index then
                                BulletBreak_Table:New(x, y, self.index)
                            end
                        end
                        self.drop_CD = 9--9帧冷却
                    end

                end
            end
        end
    end)
end
_G.cutLasersByCircle = cutLasersByCircle

bullet_cleaner = Class(object)
function bullet_cleaner:init(x, y, radius, time, time2, into, indes, vy, vx, native_force, existing_only)
    self.native_force=native_force
    self.x = x
    self.y = y
    if time == 0 then
        self.radius = radius
    else
        self.radius = 0
        self.delta = radius / time
    end
    self.time = time
    self.time2 = time2
    self.into = into and "Kill" or "Del"
    self.indes = indes
    self.bound = false
    self.group = GROUP.PLAYER
    self.a = self.radius
    self.b = self.radius
    self.vx = vx or 0
    self.vy = vy or 0.2
    self.colli = false
    if existing_only then
        -- 换卡圈持续40帧，死亡圈持续60帧；只清开始时已有的对象，保留下一相首波。
        -- Bomb不传此参数，仍持续消除效果期间新出现的弹幕。
        self.targets={}
        local function mark(o) self.targets[o]=true end
        object.BulletDo(mark);object.LaserDo(mark)
        if indes then object.IndesDo(mark) end
    end
end
function bullet_cleaner:frame()
    if self.timer < self.time then
        self.radius = self.radius + self.delta
        self.a = self.radius
        self.b = self.radius
    end
    if self.timer > self.time2 then
        object.RawDel(self)
    end
    local targets=self.targets
    cutLasersByCircle(self.x, self.y, self.a, (self.into == "Kill") and item.obj.faith_minor,self.indes,targets)
    object.BulletDo(function(o)
        if (not targets or targets[o]) and Dist(self, o) < self.a then
            OriginalBulletVisual.cancel_bullet(o,self.into,self.native_force)
        end
    end)
    object.LaserDo(function(o)
        if (not targets or targets[o]) and IsValid(o) and o.status~='del' and o.status~='kill' and Dist(self, o) < self.a then
            if self.indes or not (o.Isradial or o.Isgrowing) then
                if o._native_laser_game or o._native_laser_managed or o.th06_width then
                    OriginalBulletVisual.cancel_laser(o,self.into=='Kill',self.indes)
                else object[self.into](o) end
            end
        end
    end)
    if self.indes then
        object.IndesDo(function(o)
            if (not targets or targets[o]) and Dist(self, o) < self.a then
                OriginalBulletVisual.cancel_bullet(o,self.into,self.native_force)
            end
        end)
    end
end

bomb_bullet_killer = Class(object)
function bomb_bullet_killer:init(x, y, a, b, kill_indes)
    self.x = x
    self.y = y
    self.a = a
    self.b = b
    self.group = GROUP.PLAYER
    self.hide = true
    self.kill_indes = kill_indes
    self.colli = false
end
function bomb_bullet_killer:frame()
    if self.timer == 1 then
        Del(self)
    end
    cutLasersByCircle(self.x, self.y, self.a, item.obj.faith_minor,self.kill_indes)
    object.BulletDo(function(o)
        if Dist(self, o) < self.a then
            OriginalBulletVisual.cancel_bullet(o,'Kill',false)
        end
    end)
    object.LaserDo(function(o)
        if IsValid(o) and o.status~='del' and o.status~='kill' and Dist(self, o) < self.a then
            if self.kill_indes or not (o.Isradial or o.Isgrowing) then
                if o._native_laser_game or o._native_laser_managed or o.th06_width then
                    OriginalBulletVisual.cancel_laser(o,true,self.kill_indes)
                else object.Kill(o) end
            end
        end
    end)
    if self.kill_indes then
        object.IndesDo(function(o)
            if Dist(self, o) < self.a then
                OriginalBulletVisual.cancel_bullet(o,'Kill',false)
            end
        end)
    end
end

