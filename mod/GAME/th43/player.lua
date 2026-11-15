-- A 型 Tiger Schwert。方向速度走 ROM 的 64 方向向量表。
local M = {}
local abs, min, max = math.abs, math.min, math.max

function M.create(source, bullets)
    local Shot = Class(object, {
        init = function(o, run, x, y, dx, dy, damage, image, target)
            o.run, o.serial, o.x, o.y = run, run.serial, x, y
            o.stepX, o.stepY, o.dmg, o.image, o.target = dx, dy, damage, image, target
            o.group, o.layer = GROUP.PLAYER_BULLET, LAYER.PLAYER_BULLET
            o.a, o.b, o.rect, o.mute = 2, 6, true, true
            o.bound, o.colli = false, true
        end,
        frame = function(o)
            if o.serial == o.run.serial then return end
            o.serial = o.run.serial
            if IsValid(o.target) and o.target.colli then
                local angle = Angle(o.x,o.y,o.target.x,o.target.y)
                o.stepX, o.stepY = 12*cos(angle), 12*sin(angle)
            end
            o.x, o.y = o.x+o.stepX, o.y+o.stepY
            if abs(o.x)>160 or abs(o.y)>270 then object.RawDel(o) end
        end,
        render = function(o)
            Render(o.image, o.x, o.y, Angle(0,0,o.stepX,o.stepY)-90)
        end,
    })
    local Bomb = Class(object, {
        init = function(o, p)
            o.run, o.x, o.y = p.run, p.x, p.y
            o.group, o.layer, o.bound, o.colli = GROUP.GHOST, LAYER.PLAYER_BULLET, false, false
            o.age, o.serial = 0, p.run.serial
        end,
        frame = function(o)
            if o.serial == o.run.serial then return end
            o.serial, o.age = o.run.serial, o.age+1
            if o.age == 80 then object.RawDel(o); return end
            bullets.clear(o.run)
            if o.age%8 == 0 then
                for _, enemy in ObjList(GROUP.ENEMY) do
                    if enemy.run == o.run and enemy.colli and abs(enemy.x-o.x)<64 then
                        local host=enemy.host
                        if not host or host.lastBomb~=o.run.serial then
                            if host then host.lastBomb=o.run.serial end
                            enemy.damage(enemy,72)
                        end
                    end
                end
            end
        end,
        render = function(o)
            SetImageState('white', 'mul+add', (80-o.age)*2, 108, 196, 255)
            RenderRect('white',o.x-32,o.x+32,o.y,224)
            SetImageState('white', '', 255, 255, 255, 255)
        end,
    })
    local Player = Class(player_class, {})
    local function nearest(p)
        local target, best
        for _, o in ObjList(GROUP.ENEMY) do
            local dy, dx = o.y-p.y, abs(o.x-p.x)
            if o.run==p.run and o.colli and dy>0 and dx<dy*.85+14 then
                local distance = dy+dx*2
                if not best or distance<best then target,best=o,distance end
            end
        end
        return target
    end
    local function fire(p, key)
        local image = source.image[source.player[18][1]][1]
        if p.laser then
            if not IsValid(p.target) or not p.target.colli then p.target=nearest(p) end
            if p.run.serial%2==0 then
                local target = p.target
                for d=-1,1,2 do
                    New(Shot,p.run,p.x+d*14,p.y+5,0,13.59375,18,image,target)
                end
            end
        elseif key.shoot and not p.shotHeld or key.special and p.run.serial%3==0 then
            -- 2674–2677 帧的 A 型双炮口发射和首段速度。
            New(Shot,p.run,p.x-20,p.y+14,-110/64,870/64,57,image)
            New(Shot,p.run,p.x+19,p.y+14,110/64,870/64,57,image)
        end
    end

    function Player:init(run)
        player_class.init(self)
        self.run, self.serial, self.held, self.turn = run, -1, 0, 0
        self.name, self.protect, self.respawn = 'Tiger Schwert', 240, 0
        self.x, self.y = source.world(0x0DE4, 0x0F80)
        self.a, self.b, self.rect, self.colli = 2, 2, true, true
        self.grazer.colli, self.grazer.a, self.grazer.b = false, 0, 0
        self.img = source.image[source.player[9][1]][1]
    end

    function Player:frame()
        local run = self.run
        if (self.serial==run.serial and not run.done) or self.lock or self.realrealreal_lock then return end
        self.serial = run.serial
        local key = self.key or KeyState
        local state = NativePlayers.state()
        self.protect = max(0,self.protect-1)
        if self.respawn>0 then
            self.respawn = self.respawn-1
            if self.respawn==0 then
                self.x,self.y = source.world(0x1000,0x1C00)
                self.colli,self.hide = true,false
            end
            return
        end
        self.held = key.shoot and self.held+1 or 0
        self.laser = self.held>=25 or key.shoot and key.slow
        self.slow = self.laser and 1 or 0
        if not self.laser then self.target=nil end
        local dx = (key.right and 1 or 0)-(key.left and 1 or 0)
        local dy = (key.up and 1 or 0)-(key.down and 1 or 0)
        local v = source.velocity[self.laser and 2 or 1]
        if dx~=0 and dy~=0 then
            self.x,self.y = self.x+dx*v[4]/64,self.y+dy*v[3]/64
        else
            self.x,self.y = self.x+dx*v[6]/64,self.y+dy*v[1]/64
        end
        self.x = max(-100,min(100,self.x))
        self.y = max(-188,min(180,self.y))
        self.turn = max(-8,min(8,self.turn+(dx~=0 and dx or self.turn<0 and 1 or self.turn>0 and -1 or 0)))
        if run.done then return end
        if key.spell and not self.spellHeld and state.bombs>0 and not self.splock then
            state.bombs = state.bombs-1
            lstg.var.bomb_used = (lstg.var.bomb_used or 0)+1
            self.protect = max(self.protect,96)
            New(Bomb,self)
        end
        self.spellHeld = key.spell
        if key.shoot or key.special then fire(self,key) end
        self.shotHeld = key.shoot
    end

    function Player:render()
        if self.respawn>0 or self.protect>0 and self.timer%4==0 then return end
        local sprite = source.image[source.player[9+self.turn][1]][1]
        local option = source.image[source.player[18][2]][1]
        Render(option,self.x-14,self.y-4)
        Render(option,self.x+14,self.y-4)
        Render(sprite,self.x,self.y)
        if self.laser and IsValid(self.target) then
            local target = self.target
            local d = Dist(self,target)
            SetImageState('white','mul+add',150,130,204,255)
            for side=-1,1,2 do
                local x = self.x+14*side
                Render('white',(x+target.x)/2,(self.y+target.y)/2,
                    Angle(x,self.y,target.x,target.y),d/16,.14)
            end
            SetImageState('white','',255,255,255,255)
        end
    end

    function Player:colli(other)
        if self.protect>0 or self.respawn>0 or self.lock or cheat or other.fade then return end
        local state = NativePlayers.state()
        lstg.var.dead = lstg.var.dead+1
        state.life,state.bombs = state.life-1,3
        self.protect,self.respawn,self.colli,self.hide = 240,48,false,true
        bullets.clear(self.run)
        New(player_death_ef,self.x,self.y)
        PlaySound('pldead00',.5)
    end

    return Player
end

return M
