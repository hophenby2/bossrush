-- 栖霞园敌机与 Boss 共享本项目的命中、血量和阶段状态机。
local R=...
local E,noop=R.env,R.noop
local function valid(o) return o and IsValid(o) end
local foe=Class(enemy)
local lily=E.EISlib.Enemy.Style.FAIRY_LILY_WHITE
local function lilyRender(o)
    local age=math.floor(o.ani/8)
    local frame
    if o.th43_throw then
        local elapsed=o.timer-o.th43_throw
        frame=elapsed<24 and 10+math.min(3,math.floor(elapsed/6)) or 14+age%4
    else frame=1+age%4 end
    local direction=o.dx<0 and -1 or 1
    E.Render('lily_enemy'..frame,o.x,o.y,0,direction,1)
end
E.enemy=foe
local function hostStyle(style)
    style=style or 1
    if style<=12 then return style end
    if style<=24 then return 12+(style-1)%4+1 end
    return (style-1)%12+1
end
function foe:init(x,y,style,hp,bar,drop,_,death,large)
    enemy.init(self,hostStyle(style),hp,false,false,false)
    self.x,self.y=x,y
    self._original_death_effect=function(o) enemy.death_ef(o.x,o.y,math.min(o.maxhp,150),o.death_ef) end
    self.bound_time=360
    self.shooters={}
    self._stylemgr={setStyle=function(_,nextStyle) foe.change_style(self,nextStyle) end}
    self._drop,self.death,self.type=drop,death,large or bar
    self.drop_blood=self.type
    if style==lily then
        E.LoadImageGroupFromFile('lily_enemy','res/enemy/LilyWhite.png',false,13,2)
        self.th43_lily=true
        self.dropBomb=function(o) o.th43_throw=o.timer end
    end
    self.taunt_rank=bar and foe.BIG_TAUNT or 0
    self.group=GROUP.ENEMY
end
function foe:frame()
    enemy.frame(self)
    if self.bound_time>0 then self.bound_time=self.bound_time-1 else self.bound=true end
end
function foe:render()
    if self.th43_lily then lilyRender(self) else enemy.render(self) end
end
local function drops(o,drop)
    if not drop then return end
    if R.dropItems then R.dropItems(o.x,o.y,drop[1] or 0,drop[2] or 0) end
end
function foe:del() enemybase.del(self) end
function foe:kill()
    drops(self,self._drop)
    if self.drop_blood then E.item.Blood.create(self.x,self.y,E.item.Blood.Small) end
    if self.death and not self.no_death_attack then self.death(self) end
    enemy.kill(self)
end
function foe.createShooter(o,start,total,fn)
    local shooter=E.New(E.EISlib.Bullet.Shooter.shooter,o,start,total,fn)
    o.shooters[#o.shooters+1]=shooter
    return shooter
end
function foe.createDeath(total,fn) return E.New(E.EISlib.Bullet.Shooter.shooter,nil,0,total,fn) end
function foe.setBoundTime(o,t) o.bound_time=t or 360;o.bound=false end
function foe.setTauntRank(o,rank) o.taunt_rank=rank end
function foe.changeDrop(o,drop) o._drop=drop end
function foe.changeDeathFunc(o,fn) o.death=fn end
function foe.changeDropBlood(o,flag) o.drop_blood=flag end
function foe.setClashRate(o,rate) o.clash_rate=rate end
function foe.cancelClashColli(o) o.group=GROUP.NONTJT end
function foe.change_style(o,style) o._wisys=EnemyWalkImageSystem(o,hostStyle(style),8) end
foe.changeAura,foe.cancelAura=noop,noop
foe.canRemove=valid
foe.BIG_TAUNT,foe.SERVANT_TAUNT=2,1
E.other_enemy=Class(foe,{
    init=function(o,x,y,img,hp,bar,drop,noCount,death)
        foe.init(o,x,y,1,hp,bar,drop,noCount,death)
        o.img=img
        o.a,o.b=16,16
        o.group=GROUP.NONTJT
        o._original_death_effect=noop
    end,
    frame=enemybase.frame,
    render=noop,
})
function foe:take_damage(dmg)
    enemy.take_damage(self,dmg*(self.dmgrate or 1))
end
local tasker=Class(object,{
    init=function(o,master,x,y,fn)
        o.master,o.x,o.y=master,x,y
        o.bound=false
        task.New(o,function()
            fn(o)
            if valid(o) then Del(o) end
        end)
    end,
    frame=function(o)
        if o.master and not valid(o.master) then Del(o) else task.Do(o) end
    end,
})
E.tasker=function(fn) return E.New(tasker,nil,0,0,fn) end
E.boss=setmetatable({utility={cacheResource=noop},class={TAUNT_RANK=3}},{__index=boss})
function E.boss.createTasker(o,x,y,fn,wait)
    local actor=E.New(tasker,o,x,y,fn)
    o.taskers[#o.taskers+1]=actor
    if wait then while valid(actor) do task.Wait() end end
    return actor
end
function E.boss.class.changeAuraImg(o,name)
    o.th43_aura_image=name
end
function E.boss.class.changeRenderAuraFunc(o,fn) o.th43_render_aura=fn end
function E.boss.setBossExplode(o,fn)
    o.th43_explode=fn
end
function E.boss.setUInameDisplay(o,show) if o.ui then o.ui.hide=not show end end
function E.boss.show_aura(o,show)
    o.aura_alpha_d=show and 1 or 0
    o.aura_alpha=show and 255 or 0
    if o._bosssys then boss.show_aura(o,show) end
end
function E.boss.defaultScOpenEffect() task.Wait(120) end
function E.boss.defaultAbsorbEffect(_,t) if t then task.Wait(t) end end
E.boss.defaultAbsorbAction=E.boss.defaultAbsorbEffect
E.boss.defaultBreakEffect=E.boss.defaultAbsorbEffect
E.boss.defaultScBreakEffect=noop
function R.renderAura(o)
    if o.th43_render_aura then o.th43_render_aura(o)
    elseif o.th43_aura_image and o.aura_alpha>0 then
        local name=o.th43_aura_image
        E.SetImageState(name,'mul+add',o.aura_alpha*.65,255,255,255)
        E.Render(name,o.x,o.y,o.ani*.8,.8)
    end
end

local Card={}
E.EGGlib.BossCard=Card
function Card.createFullCard(name,kind,times,hp,drop,prepare,practice,main,finish,_,_,hidden)
    local spelling=kind~='normal'
    local extra=kind=='extra' or kind=='extrafinal'
    local t1,t2,t3=unpack(times)
    if kind=='timespell' then t1,t2=t3,t3 end
    local title=R.translate(name)
    local card=boss.card.New(spelling and title or '',t1,t2,t3,hp,nil,extra)
    card.phase_name=title
    function card:before()
        R.scope=self
        self.protect=true
        if R.practice then practice(self) else prepare(self) end
        if valid(self) then self.protect=false end
    end
    function card:init()
        self.taskers={}
        self.th43_card=true
        if card.inTheFrontOfInit then card.inTheFrontOfInit(self) end
        task.New(self,function()
            if self.no_scOpenEffect then self.no_scOpenEffect=false
            elseif spelling then self.scOpenEffect(self)
            else task.Wait(60) end
            main(self)
        end)
    end
    function card:frame()
        if spelling and (extra or self.timer<=card.t1 or self.th43_open_bomb) then
            self.th43_open_bomb=E.player_class.isInBomb(player)
            self.protect=self.th43_open_bomb
        end
    end
    function card:del()
        self.spell_timeout=self.timeout
        finish(self)
        if self.hp<=0 and not self.timeout then drops(self,drop) end
        R.clear(self)
        self.th43_card,self.th43_open_bomb,self.protect=nil,nil,false
        if lstg.tmpvar.th43_hide_hud==self then lstg.tmpvar.th43_hide_hud=nil end
        R.scope=R.chapterScope
    end
    return {main=card,no_practice=hidden}
end
function Card.getFullCardMain(card) return card.main end
function Card.setNextCardNoScOpenEffect(o) o.no_scOpenEffect=true end
function Card.createEscape(fn)
    local function escape(o)
        if fn then fn(o) end
        E.task.MoveTo(o,o.x,384,60,E.MOVE_ACCEL)
        Del(o)
    end
    local card=Card.createFullCard('逃跑','normal',{0,0,20},600,nil,escape,noop,noop,noop,nil,nil,true)
    card.main.is_combat=false
    return card
end
