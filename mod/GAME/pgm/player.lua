-- 街机练习共用受击、自弹和炸弹对象。机体可以接入按原程序步进的控制逻辑。
local abs, min, max, floor = math.abs, math.min, math.max, math.floor

return function(source, bullets, machine)
    local halfWidth,halfHeight=source.halfWidth or 112,source.halfHeight or 224
    local blinkFrame=source.cvTiles and 1 or 0
    local pilot = machine.pilot
    -- 地面敌机的原版 flags=0：自弹和光束能命中，本体不参与撞机。
    local enemyGroups={GROUP.ENEMY}
    if GROUP.NONTJT then enemyGroups[#enemyGroups+1]=GROUP.NONTJT end
    local Shot = Class(object, {
        init = function(o, run, x, y, vx, damage, image)
            o.run, o.serial, o.x, o.y = run, run.serial, x, y
            o.vxShot, o.dmg, o.image = vx, damage, image
            o.group, o.layer = GROUP.PLAYER_BULLET, LAYER.PLAYER_BULLET
            o.a, o.b, o.rect, o.mute = 2, 6, true, true
            o.bound, o.colli = false, true
        end,
        frame = function(o)
            if o.serial == o.run.serial then return end
            o.serial = o.run.serial
            o.x, o.y = o.x+o.vxShot, o.y+machine.shotSpeed
            if abs(o.x)>halfWidth+16 or o.y>halfHeight+20 then object.RawDel(o) end
        end,
        render = function(o)
            Render(o.image,o.x,o.y,Angle(0,0,o.vxShot,machine.shotSpeed)-90)
        end,
    })

    local function beam(x, y, top, width, color, alpha)
        SetImageState('white','mul+add',alpha,color[1],color[2],color[3])
        RenderRect('white',x-width,x+width,y,top)
        SetImageState('white','',255,255,255,255)
    end

    local Bomb = Class(object, {
        init = function(o, p, duration)
            o.run, o.x, o.y = p.run, p.x, p.y
            o.group, o.layer, o.bound, o.colli = GROUP.GHOST, LAYER.PLAYER_BULLET, false, false
            o.age, o.serial, o.duration = 0, p.run.serial, duration
        end,
        frame = function(o)
            if o.serial == o.run.serial then return end
            o.serial, o.age = o.run.serial, o.age+1
            if o.age >= o.duration then object.RawDel(o); return end
            bullets.clear(o.run)
            if o.age%6 == 0 then
                for _, group in ipairs(enemyGroups) do
                    for _, target in ObjList(group) do
                        if target.run==o.run and target.colli and abs(target.x-o.x)<machine.bombWidth+target.a then
                            local host=target.host
                            if not host or host.lastBomb~=o.run.serial then
                                if host then host.lastBomb=o.run.serial end
                                target.damage(target,machine.bombDamage)
                            end
                        end
                    end
                end
            end
        end,
        render = function(o)
            local fade = min(1,o.age/8,(o.duration-o.age)/12)
            beam(o.x,o.y,halfHeight,machine.bombWidth,machine.color,floor(136*fade))
            beam(o.x,o.y,halfHeight,machine.bombWidth*.28,{255,255,255},floor(148*fade))
        end,
    })

    local Player = Class(player_class, {})

    local function setSpawn(p, protection)
        if pilot then pilot.spawn(p)
        else p.x, p.y = source.world(machine.spawnY or 0x1000,machine.spawnX or 0x1c00) end
        p.protect, p.colli, p.hide = protection, true, false
    end

    function Player:init(run)
        player_class.init(self)
        self.run, self.serial, self.held, self.respawn = run, -1, 0, 0
        self.name, self.a, self.b, self.rect = machine.name, 2, 2, true
        self.grazer.colli, self.grazer.a, self.grazer.b = false, 0, 0
        setSpawn(self, 120)
    end

    local function fire(p)
        local run = p.run
        if p.laser then
            local nearest, top = nil, halfHeight
            for _, group in ipairs(enemyGroups) do
                for _, target in ObjList(group) do
                    local edge = target.y-target.b
                    if target.run==run and target.colli and target.hp>0 and target.y>p.y
                        and edge<top and abs(target.x-p.x)<target.a+machine.laserWidth then
                        nearest, top = target, max(p.y+8,edge)
                    end
                end
            end
            if nearest and run.serial%2==0 then nearest.damage(nearest,machine.laserDamage) end
            p.laserTop = top
        elseif run.serial%machine.interval==0 then
            local image = source.image[source.player[#source.player][1]][1]
            for _, emitter in ipairs(machine.shot) do
                New(Shot,run,p.x+emitter[1],p.y+12,emitter[2],machine.shotDamage,image)
            end
        end
    end

    local function move(self, key)
        self.held = key.shoot and self.held+1 or 0
        self.laser = key.shoot and (key.slow or self.held>=machine.hold)
        self.slow = self.laser and 1 or 0
        local dx = (key.right and 1 or 0)-(key.left and 1 or 0)
        local dy = (key.up and 1 or 0)-(key.down and 1 or 0)
        local v = self.laser and machine.focus or machine.speed
        if dx~=0 and dy~=0 then v=floor(v*.70710678) end
        self.x = max(-halfWidth+11,min(halfWidth-11,self.x+dx*v/64))
        self.y = max(-halfHeight+(machine.bottom or 33),min(halfHeight-28,self.y+dy*v/64))
        if machine.turn then
            local tilt = self.tilt or 0
            local change = dx~=0 and dx or tilt>0 and -1 or tilt<0 and 1 or 0
            self.tilt=max(-machine.turn,min(machine.turn,tilt+change))
        end
    end

    function Player:frame()
        local run = self.run
        if (self.serial==run.serial and not run.done) or self.lock or self.realrealreal_lock then return end
        self.serial = run.serial
        self.protect = max(0,self.protect-1)
        if self.respawn>0 then
            self.respawn=self.respawn-1
            if self.respawn==0 then setSpawn(self, pilot and pilot.recoveryProtection or 120)
            elseif pilot then pilot.fall(self) end
            return
        end
        local key, state = self.key or KeyState, NativePlayers.state()
        if pilot then pilot.move(self, key) else move(self, key) end
        if run.done then self.laser=false; return end
        if key.spell and not self.spellHeld and state.bombs>0 and not self.splock then
            state.bombs=state.bombs-1
            lstg.var.bomb_used=(lstg.var.bomb_used or 0)+1
            local duration = self.laser and machine.focusBomb or machine.bomb
            self.protect=max(self.protect,duration+10)
            New(Bomb,self,duration)
        end
        self.spellHeld=key.spell
        if key.shoot then fire(self) end
    end

    function Player:render()
        if self.respawn>0 or self.protect>0 and self.timer%4==blinkFrame then return end
        local frame = self.tilt and machine.turn+1+self.tilt
            or floor(self.run.serial/3)%(#source.player-1)+1
        Render(source.image[source.player[frame][1]][1],self.x,self.y)
        if self.laser and self.laserTop then
            beam(self.x,self.y+9,self.laserTop,machine.laserWidth,machine.color,146)
            beam(self.x,self.y+9,self.laserTop,machine.laserWidth*.4,{255,255,255},185)
        end
    end

    function Player:colli(other)
        if self.respawn>0 or self.lock or cheat or other.fade then return end
        if self.protect>0 and not other.cancelOnContact then return end
        if other.hitPilot and not other.hitPilot(other,self) then return end
        if other.cancelOnContact then other.cancelOnContact(other) end
        if self.protect>0 then return end
        local state = NativePlayers.state()
        lstg.var.dead=lstg.var.dead+1
        state.life,state.bombs=state.life-1,machine.bombs
        self.respawn,self.colli,self.hide=pilot and pilot.recoveryFrames or 48,false,true
        if pilot then
            self.laser,self.slow=false,0
            if pilot.onHit then pilot.onHit(self) end
        end
        bullets.clear(self.run,false,pilot~=nil)
        New(player_death_ef,self.x,self.y)
        PlaySound('pldead00',.5)
    end

    return Player
end
