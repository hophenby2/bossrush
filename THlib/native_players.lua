-- The native fan-game stages store a separate player version in the replay initial state.
local P={VERSION=1,adapters={}}
local lifeThresholds={9,12,15,20,25,30,35,40,40,99}
local respawnY={[35]=-180,[36]=-176,[37]=-400/3,[38]=-194,[39]=-176,[41]=-176}
local profiles={
    [35]={
        {'reimu','博丽灵梦',4.5,2,13,'reimu',10,{20,6}},
        {'marisa','雾雨魔理沙',5,2.25,7,'marisa',10,{20,6}},
        {'sanae','东风谷早苗',4.5,2,13,'sanae',10,{20,6}},
        {'youmu','魂魄妖梦',5,2,17,'youmu',10,{20,6}},
    },
    [36]={
        {'reimu','博丽灵梦',4.32,1.92,8,'reimu',24},
        {'yukari','八云紫',4.32,1.92,8,'yukari',24},
        {'marisa','雾雨魔理沙 A',4.8,1.92,8,'marisa',12},
        {'marisa_b','雾雨魔理沙 B',4.8,1.92,8,'marisa',12},
        {'byakuren','圣白莲',4.8,1.92,11,'byakuren',24},
        {'miko','丰聪耳神子',4.8,1.92,11,'miko',24},
    },
    [37]={
        {'reimu','博丽灵梦 A',25/6,2,8,'reimu',nil,{20,7,60,20},48},
        {'reimu_b','博丽灵梦 B',25/6,2,8.5,'reimu',nil,{20,7,60,20},48},
        {'marisa','雾雨魔理沙 A',14/3,6.8/3,12,'marisa',nil,{80,33,60,20},40},
        {'marisa_b','雾雨魔理沙 B',14/3,6.8/3,10,'marisa',nil,{80,33,60,20},40},
        {'sanae','东风谷早苗 A',14/3,2.5,32,'sanae',nil,{60,35,60,22},48},
        {'sanae_b','东风谷早苗 B',14/3,2.5,28,'sanae',nil,{60,35,60,22},48},
        {'mokou','藤原妹红 A',13/3,2,15,'mokou',nil,{80,29,70,25},52},
        {'mokou_b','藤原妹红 B',13/3,2,22,'mokou',nil,{80,29,70,25},52},
    },
}
profiles[38]={
    {'A','博丽灵梦',4.5,2,14,'reimu',8,{18,6}},
    {'B','雾雨魔理沙',5,2,15,'marisa',8,{24,8}},
    {'C','东风谷早苗',4.5,2,10,'sanae',8,{16,6}},
    {'D','古明地恋',5,2,13,'koishi',8,{14,5}},
}
profiles[39]={
    {'reimu','灵梦 / 紫',4.5,2,5,'reimu',42,{8,3}},
    {'marisa','魔理沙 / 幽幽子',5,2,8,'marisa',32,{12,4}},
    {'mokou','妹红 / 慧音',5,2,1,'mokou',32,{10,3}},
}
profiles[40]={
    {'dream','Vanilla Alice',0,0,0,'dream',character=0},
    {'cute','Yuri Cocoa',0,0,0,'cute',character=1},
    {'cool','UJAKO',0,0,0,'cool',character=2},
}
profiles[41]={
    {'reimu','博丽灵梦',4.4,2.1,1.8,'reimu',20,{1.3,1.3}},
    {'marisa','雾雨魔理沙',4.8,2.2,.9,'marisa',20,{3.37,3.37}},
    {'sakuya','十六夜咲夜',4,2,1.8,'sakuya',20,{.685,.685}},
}
local stages={['TH40@BossRush']=38,['TH41@BossRush']=39,['TH42@BossRush']=40,['TH43@BossRush']=41,['TH37@BossRush']=35,['TH38@BossRush']=36,['TH39@BossRush']=37}
for _,list in pairs(profiles) do
    for _,m in ipairs(list) do
        m.id,m.name,m.fast,m.slow,m.damage,m.art,m.window,m.bomb,m.velocity=unpack(m,1,9)
    end
end
function P.machines(level) return profiles[level] end
function P.machine(level,id)
    local list=profiles[level]
    if not list then return end
    for _,m in ipairs(list) do if m.id==id then return m end end
end
function P.practiceLevel(stageName,group)
    local level=stageName=='Spell Practice@Spell Practice' and type(group)=='table' and group[1] or stages[stageName]
    return profiles[level] and level or nil
end
function P.enabled(v,level)
    v=v or lstg.var
    return v.__native_player_version==P.VERSION and (not level or level==v.native_player_level)
        and P.machine(v.native_player_level,v.native_player_id)~=nil
end
function P.configure(level,id,loadout)
    local v=lstg.var
    v.__native_player_version,v.native_player_level,v.native_player_id,v.native_player_state=nil,nil,nil,nil
    v.like_dreamer_loadout=nil
    if not profiles[level] then return end
    local m=P.machine(level,id) or (not id and profiles[level][1])
    assert(m,'未知原作机体 '..tostring(id))
    v.__native_player_version,v.native_player_level,v.native_player_id=P.VERSION,level,m.id
    v.__drops_version=0
    v.current_system=''
    v.player_name=m.art=='marisa' and 'marisa_player' or 'reimu_player'
    v.rep_player=m.name
    v.th38_route=level==38 and m.id or nil
    v.theis_route=level==39 and m.id or nil
    if level==40 then
        local fields=type(loadout)=='table' and loadout or {}
        local result={}
        for i,limit in ipairs({1,1,1,3,1,1}) do
            result[i]=math.max(0,math.min(limit,math.floor(tonumber(fields[i]) or 0)))
        end
        v.like_dreamer_loadout=result
    end
    return m
end
function P.state()
    return P.enabled() and lstg.var.native_player_state or nil
end
function P.reset()
    if not P.enabled() then return end
    local v=lstg.var
    local level=v.native_player_level
    local spell=v.is_practice and v.stage_name=='Spell Practice@Spell Practice'
    local s={level=level,life=10,bombs=level==35 and 10 or 15,power=400,rebirth=false}
    local adapter=P.adapters[level]
    if adapter and adapter.reset then
        adapter.reset(s,v,spell)
    elseif level>=38 then
        v.bomb_used=0
        s.life,s.bombs=2,2
        if v.is_practice then
            s.life=spell and 0 or 8
            s.bombs=level==40 and 0 or spell and 0 or level==39 and 5 or 2
        end
        s.power=level==38 and not v.is_practice and v.sequence_key~='thsss_extra' and 100 or 400
        s.lifeChip,s.bombChip,s.star,s.dyeChain=0,0,0,0
        if level==39 then
            v.dyeitem={red=0,blue=0,green=0,night=0}
            s.pointrate=spell and 5000000 or v.sequence_key=='theis_extra' and 100000 or 50000
            v.coun_num=0
        elseif level==40 then
            v.lifeleft,v.bomb=s.life,s.bombs
            v.graze,v.like_dreamer_special_gauge=0,0
            v.like_dreamer_counter_mode=v.like_dreamer_loadout and v.like_dreamer_loadout[6] or 0
            v.like_dreamer_score_item_base,v.like_dreamer_stock_progress,v.like_dreamer_extend_index=nil,nil,nil
        end
    elseif level==36 then
        s.life=spell and 1 or v.is_practice and 9 or 3
        s.barrier,s.barrierStart=0,50
        s.fragments,s.lifeThreshold,s.barrierReward=0,1,0
    elseif v.is_practice and not spell then
        s.life=40
    end
    v.native_player_state=s
end
function P.out()
    local s=P.state()
    return s and (s.level==36 and s.life==0 or s.level~=36 and s.life<0 and not s.recover)
end
function P.barriers(s)
    return s.barrier==299999 and 3 or math.floor(s.barrier/100000)
end
local ResourceItem=Class(item)
local SourceVisual=dofile('THlib/native_player_visual.lua')
local ActorCollision=NativeActorCollision or dofile('THlib/native_actor_collision.lua')
local SourceMovement=dofile('THlib/native_player_movement.lua')
local SourceDeath=dofile('THlib/native_player_death.lua')
P.visual,P.death=SourceVisual,SourceDeath
function ResourceItem:init(x,y,kind,amount)
    local images={life=7,bombs=9,power=1,fragments=7,red=7,green=9,blue=2,night=2,star=2,points=3,bombFragments=9,rankPower=1}
    item.init(self,x,y,images[kind] or 2)
    self.native_pickup,self.kind,self.amount=true,kind,amount
    local s=P.state()
    local adapter=s and P.adapters[s.level]
    if adapter and adapter.item then adapter.item(self,kind) end
    if s then SourceVisual.item(self,s.level,kind,amount) end
end
function ResourceItem:frame()
    local s=P.state();local adapter=s and P.adapters[s.level]
    if adapter and adapter.itemFrame and adapter.itemFrame(self) then return end
    if not self.native_item_visual then item.frame(self);return end
    -- XNA道具上抛时每帧旋转1弧度，下落后立即归零；不走宿主24帧缩放。
    local p=self.target or lstg.player
    if self.attract>0 and IsValid(p) then
        SetV(self,self.attract,Angle(self,p))
    else
        self.vx=0
        self.native_fall=(self.native_fall or 3.5)-.07
        self.vy=math.max(-1.5,self.native_fall)
        self.native_item_rotation=self.vy>=0 and (self.native_item_rotation or 0)-180/math.pi or 0
    end
    if self.y<lstg.world.b-24 then object.RawDel(self) end
end
function ResourceItem:render()
    local s=P.state();local adapter=s and P.adapters[s.level]
    if adapter and adapter.itemRender and adapter.itemRender(self) then return end
    if not SourceVisual.itemRender(self) then item.render(self) end
end
function ResourceItem:colli(other)
    local r=self.native_pickup_rect
    if r and (math.abs(self.x-other.x)>r[1] or math.abs(self.y-other.y)>r[2]) then return end
    local s=P.state();local adapter=s and P.adapters[s.level]
    if other==player and adapter and adapter.collectSound then
        local kind,amount,power=self.kind,self.amount,s.power
        self.class.collect(self,other);object.Kill(self)
        adapter.collectSound(s,kind,amount,power)
    else item.colli(self,other) end
end
function ResourceItem:collect()
    local s=P.state()
    if not s then return end
    local adapter=P.adapters[s.level]
    if adapter and adapter.collect and adapter.collect(s,self.kind,self.amount) then return end
    if self.kind=='fragments' then
        s.fragments=s.fragments+self.amount
        local need=P.lifeThreshold(s)
        if s.fragments>=need then
            s.fragments=s.fragments-need
            s.lifeThreshold=math.min(#lifeThresholds,s.lifeThreshold+1)
            s.life=math.min(9,s.life+1)
        end
    elseif self.kind=='power' then s.power=math.min(400,s.power+self.amount)
    else s[self.kind]=math.min(50,s[self.kind]+self.amount) end
end
function P.pickup(x,y,kind,amount) return New(ResourceItem,x,y,kind,amount or 1) end
function P.lifeThreshold(s)
    if s.lifeThreshold==9 and lstg.var.sequence_key=='thasl_extra_a' then return 99 end
    return lifeThresholds[s.lifeThreshold]
end
local function barrierAdd(s,n)
    s.barrier=math.min(299999,s.barrier+n)
    local layers=P.barriers(s)
    while s.barrierReward<layers do
        s.barrierReward=s.barrierReward+1
        local p=lstg.player
        if p and IsValid(p) then New(ResourceItem,p.x,p.y+28.8,'fragments',1) end
    end
end
function P.drop(level,x,y,items,boss,nonspell,sourceSize)
    if not items or not P.enabled(nil,level) then return end
    local function value(i) return tonumber(items[i]) or 0 end
    local scale=level==37 and 2/3 or 1
    local size=(sourceSize or (boss and 70 or 0))*scale
    local function drop(kind,amount,count,spread)
        for _=1,math.ceil(count) do
            local dx,dy=0,0
            if spread~=0 then dx,dy=ran:Float(-spread,spread),ran:Float(-spread,spread) end
            New(ResourceItem,x+dx,y-dy,kind,amount)
        end
    end
    local up,bomb=value(boss and 7 or 5),value(boss and 9 or 6)
    local bigUp,bigBomb=0,0
    local difficulty=stage.current_stage.group.difficulty
    local springLimited=level==35 and difficulty~=1 and difficulty~=5 and difficulty~=6
    if springLimited then up,bomb=0,0 end
    if boss then
        bigUp,bigBomb=value(6),value(8)
        if nonspell then
            bomb,up=bomb+up,0
            if level==37 then bigUp,bigBomb=0,0 end
        end
    end
    -- 保留 ItemManager / ItemMass 的随机调用与生成顺序，大点和大 P 分别判定。
    if value(1)>0 and ran:Float(0,100)<=value(1) then drop('bigPoints',1,1,level==37 and size/4 or size) end
    drop('points',1,value(2)+(level==37 and value(4) or 0),level==37 and size or size/2)
    if level==35 then
        local full=P.state().power>=400
        if value(3)>0 and ran:Float(0,100)<=value(3) then drop(full and 'bigPoints' or 'power',full and 1 or 100,1,size) end
        drop(full and 'points' or 'power',full and 1 or 5,value(4),size/2)
        if boss and not springLimited then drop('power',400,value(5),size/2) end
        if bigUp>0 and ran:Float(0,100)<=bigUp then drop('life',5,1,size) end
        drop('life',1,up,size/2)
        if bigBomb>0 and ran:Float(0,100)<=bigBomb then drop('bombs',5,1,size) end
        drop('bombs',1,bomb,size/2)
    else
        -- 永夜的库存道具按原作在半径 44 的圆周散布，和点道具的矩形散布分开。
        local function ring(kind,amount,count)
            if count<=0 then return end
            local angle=270+ran:Float(0,360)
            for i=0,math.ceil(count)-1 do
                local a=angle+i*360/count
                New(ResourceItem,x+44*scale*cos(a),y-44*scale*sin(a),kind,amount)
            end
        end
        if bigUp>0 and ran:Float(0,100)<=bigUp then ring('life',5,1) end
        ring('life',1,up)
        if bigBomb>0 and ran:Float(0,100)<=bigBomb then ring('bombs',5,1) end
        ring('bombs',1,bomb)
    end
    local adapter=P.adapters[level]
    if boss and adapter and adapter.dropSound then adapter.dropSound(x) end
end
function P.hitShot(target)
    if not target.protect and target.dmg_factor~=0 then
        local s=P.state()
        if s and s.level==36 then barrierAdd(s,50) end
    end
end

local projectScale=2/3
local shotImages={
    [35]={{'reimu',8,0,28,59,14,26},{'marisa',43,7,23,38,11,15},{'sanae',78,6,22,40,11,19},
        {'youmu',108,9,25,44,12,17},{'amulet',22,111,13,42,6,20},{'seed',101,115,25,27,13,14}},
    [36]={{'reimu',0,0,128,128,64,64},{'yukari',128,0,128,128,64,64},
        {'marisa',256,0,128,128,64,64},{'byakuren',384,0,128,128,64,64},
        {'miko',512,0,128,128,64,64}},
    [37]={{'reimu',0,0,47,144,23,80},{'marisa',48,0,53,161,27,46},
        {'sanae',102,0,256,177,128,36},{'mokou',358,0,68,157,34,50}},
}
shotImages[41]={}
for row,name in ipairs({'reimu','marisa','sakuya'}) do
    for col,part in ipairs({'main','straight','trail','spread'}) do
        shotImages[41][#shotImages[41]+1]={name..'_'..part,(col-1)*128,(row-1)*128,128,128,64,64}
    end
end
local artLoaded={}
local function art(level,name)
    local key='native_player_'..level..'_'..name
    if artLoaded[key] then return key end
    local pool=GetResourceStatus()
    SetResourceStatus('global')
    LoadTexture(key,'Resources/native_players/'..(level+2)..'_'..name..'.png')
    LoadImageGroup(key,key,0,0,128,128,8,3)
    SetResourceStatus(pool)
    artLoaded[key]=true
    return key
end
local function shots(level)
    local key='native_shot_'..level..'_'
    if not artLoaded[key] and shotImages[level] then
        local pool=GetResourceStatus()
        SetResourceStatus('global')
        LoadTexture(key,'Resources/native_players/'..(level+2)..'_shots.png')
        for _,i in ipairs(shotImages[level]) do
            local img=key..i[1]
            LoadImage(img,key,i[2],i[3],i[4],i[5])
            SetImageCenter(img,i[6],i[7])
            SetImageState(img,'',190,255,255,255)
        end
        SetResourceStatus(pool)
        artLoaded[key]=true
    end
    return key
end
local Player=Class(player_class)
local Shot=Class(player_bullet_straight)
local function emit(p,img,x,y,v,dir,dmg,r,scale,homing,main)
    local adapter=P.adapters[p.native_level]
    local class=adapter and adapter.shotClass or Shot
    local o=New(class,img,p.x+x,p.y+y,v,dir,dmg~=0 and dmg or nil)
    o.dir,o.rot=dir,dir-90
    o.a,o.b,o.rect=r,r,false
    o.v,o.homing,o.native_main=v,homing,main
    if v<=2 then o.maxAge=25 end
    o.hscale,o.vscale=scale or 1,scale or 1
    local a,b,rect=o.a,o.b,o.rect
    SourceVisual.shot(p,o,img,scale)
    o.a,o.b,o.rect=a,b,rect
    return o
end
function Shot:render()
    local factor=GameDrops and GameDrops.bulletScale(self) or 1
    SetImageState(self.img,'',self.native_alpha or 255,255,255,255)
    Render(self.img,self.x,self.y,self.rot,self.hscale*factor,self.vscale*factor)
end
function Shot:kill() SourceVisual.shotKill(self) end
function Shot:frame()
    if self.maxAge and self.timer>=self.maxAge then object.Del(self);return end
    if not self.homing then return end
    local p=lstg.player
    local target=IsValid(p) and p.target
    if not (target and IsValid(target) and target.colli) then return end
    local delta=(Angle(self,target)-self.dir+180)%360-180
    self.dir=self.dir+math.max(-self.homing,math.min(self.homing,delta))
    self.rot=self.dir+(self.native_rotation_offset or -90)
    self.vx,self.vy=self.v*cos(self.dir),self.v*sin(self.dir)
end
local function ray(p,x,y,dir,width,enemyDamage,bossDamage,visible)
    if visible then p.beams[#p.beams+1]={x,y,dir,width} end
    local co,si=cos(dir),sin(dir)
    object.EnemyNontjtDo(function(o)
        if not o.colli or o.protect then return end
        local dx,dy=o.x-x,o.y-y
        if dx*co+dy*si>=0 and math.abs(dx*si-dy*co)<width+math.max(o.a or 0,o.b or 0) then
            Damage(o,(o.IsBoss or o.owner and o.owner.IsBoss) and bossDamage or enemyDamage)
        end
    end)
end
local aslOther={reimu='yukari',yukari='reimu',byakuren='miko',miko='byakuren',marisa='marisa_b',marisa_b='marisa'}
function Player:shoot()
    local level=self.native_level
    local adapter=P.adapters[level]
    if adapter and adapter.lateControl and not self.native_controls_running then self.native_shoot_pending=true;return end
    if self.hit or SourceDeath.locked(self) or self.death>=50 or P.out() or P.state().recover then return end
    if adapter and adapter.shoot then
        self.shotClock=self.shotClock+1
        return adapter.shoot(self,self.shotClock,P.state())
    end
    error('原作机体缺少射击适配：'..tostring(level))
end

local function bomb(p,s)
    if p.dialog or p.death>=50 or p.bombTime or s.recover or P.out() then return end
    local adapter=P.adapters[s.level]
    if adapter and adapter.bomb then
        if not (adapter and adapter.bomb and adapter.bomb(p,s)) then return end
    elseif s.level==36 then
        if P.barriers(s)<3 then return end
        s.barrier,s.barrierReward=0,0
        TH38.visual.release(p)
    else
        local cost=s.level==37 and p.hit and p.hitWindow==60 and 10 or 5
        if s.bombs<cost then return end
        s.bombs=s.bombs-cost
        p.strongBomb=cost==10
    end
    p.hit=nil
    SourceDeath.cancel(p)
    p.bombTime=p.bombTime or 90
    if not (adapter and adapter.ownBomb) then
        p.nextspell=p.bombTime
        p.protect=math.max(p.protect,p.bombTime)
    end
    for _,b in ipairs(boss_group) do
        if IsValid(b) and b.is_combat then b._bosssys:clearBonus('spell') end
    end
    if not (adapter and adapter.ownBomb) then
        New(bomb_bullet_killer,p.x,p.y,240,240,false)
        if s.level~=36 then PlaySound('nep00',.5) end
    end
end
function P.miss(p)
    local s=P.state()
    if not s then return end
    if SourceDeath.defer(p) then return end
    local adapter=P.adapters[s.level]
    if s.level<38 and adapter and adapter.miss then adapter.miss(p,s) end
    if s.level>=38 then
        if adapter and adapter.clearBonus then adapter.clearBonus() end
        if adapter and adapter.miss and adapter.miss(p,s) then return end
        lstg.var.dead=(lstg.var.dead or 0)+1
        s.life=s.life-1
        if s.level==39 then s.bombs=math.max(s.bombs,2) end
        if s.level==38 then
            s.power=math.max(0,s.power-16)
            s.star,s.enchantment,s.enchantmentTime=0,nil,nil
        end
        p.protect,p.death=s.level==39 and 360 or s.level==38 and 300 or 150,90
        SourceDeath.miss(p)
        PlaySound('pldead00',.5)
        return
    end
    if s.level==36 and P.barriers(s)>0 then
        s.barrier=s.barrier-(s.barrier==299999 and 99999 or 100000)
        p.protect=60
        for _,b in ipairs(boss_group) do
            if IsValid(b) and b.is_combat then b._bosssys:clearBonus('hit') end
        end
        -- 破一层结界不会调用Death_xiaodan，消弹属于各Bomb_break prefab。
        return
    end
    lstg.var.dead=lstg.var.dead+1
    s.life=s.life-(s.level==36 and 1 or 5)
    if s.level~=36 then s.bombs=(s.level==35 and 10 or 15)+s.bombs%5 end
    if s.level==35 and s.power>=100 then
        if s.life>=5 then
            for i=1,8 do
                local a=180+i*20
                New(ResourceItem,p.x+80*cos(a),p.y-60*sin(a),'power',5)
            end
        elseif s.power>300 then New(ResourceItem,0,20,'power',400) end
        s.power=s.power-60
    end
    if s.level==36 then
        s.barrierStart=50
        p.altForm=false
        p.imgs=p.baseImages
    end
    if s.level==37 and s.life<0 then
        s.bombs=0
        if p.machine.art=='mokou' and not s.rebirth then
            s.rebirth,s.recover=true,240
        end
    end
    p.protect=150
    p.death=90
    if s.level==36 then
        if s.hudClock then s.hudClock=math.max(0,s.hudClock-4800) end
        TH38.visual.miss(p)
    end
    SourceDeath.miss(p)
end
local function tick(p)
    local s=P.state()
    if s.recover then
        s.recover=s.recover-1
        p.protect=math.max(p.protect,2)
        if s.recover==0 then s.recover,s.life,s.bombs=nil,10,15;p.protect=150 end
    end
    if s.barrierStart and s.barrierStart>0 then
        barrierAdd(s,4002)
        s.barrierStart=s.barrierStart-1
    end
    local key=p._playersys.keyState
    local adapter=P.adapters[s.level]
    -- 原作逐帧读取射击键，不沿用宿主松键后最长 15 帧的射击保持。
    p.__shoot_flag,p.__shoot_count=key.shoot,0
    p.slow=adapter and adapter.updateSlow and adapter.updateSlow(p,key.slow) or (key.slow and 1 or 0)
    if adapter and adapter.frame and not adapter.lateFrame then adapter.frame(p,s) end
    if p.death==50 and not P.out() and not p.native_death_clock then p.x,p.y=0,respawnY[s.level] end
    SourceDeath.frame(p)
    local pressed=key.spell and not p.spellHeld
    p.spellHeld=key.spell
    if not key.shoot then p.charge,p.laserStart=0,math.max(0,(p.laserStart or 0)-2) end
    p.beams={}
    if s.level==36 then
        if s.hudClock==nil then
            s.extraClock=ui and ui.NativeHUD and ui.NativeHUD.isExtra() or lstg.var.sequence_key=='thasl_extra_a'
            s.hudClock=s.extraClock and 86400 or 172800
        end
        if stage.current_stage.timer>=195 and not p.dialog then
            s.hudClock=math.max(0,s.hudClock-(s.extraClock and 1 or 2))
        end
        p.switchDelay=math.max(0,(p.switchDelay or 0)-1)
        if key.special and not p.specialHeld and p.switchDelay==0 and not p.hit and p.death<50 and not p.dialog then
            p.altForm=not p.altForm
            p.imgs=p.altForm and p.altImages or p.baseImages
            p.switchDelay=30
            p.charge=0
        end
        p.specialHeld=key.special
    end
    if not key.slow then
        p.turn=p.turn*.75
        if key.left then p.turn=math.max(-1,p.turn-.25)
        elseif key.right then p.turn=math.min(1,p.turn+.25) end
    end
    local useBomb=pressed or adapter and adapter.heldBomb and key.spell
    if adapter and adapter.lateControl then p.native_bomb_pending=useBomb
    elseif useBomb then bomb(p,s) end
    if p.hit then
        p.hit=p.hit-1
        if p.hit<=0 then
            p.hit=nil
            item.PlayerMiss(p)
        end
    end
    if p.bombTime then
        p.bombTime=p.bombTime-1
        if p.machine.bomb and not p.cancelOnlyBomb then
            local d=p.machine.bomb
            object.EnemyNontjtDo(function(o)
                if o.colli and Dist(p,o)<240 then
                    local isBoss=o.IsBoss or o.owner and o.owner.IsBoss
                    local index=(p.strongBomb and 2 or 0)+(isBoss and 2 or 1)
                    local b=o.IsBoss and o or o.owner
                    local card=b and b.current_card
                    local factor=card and card.nativeBombFactor or 1
                    if factor>0 then Damage(o,(d[index] or 0)*factor) end
                end
            end)
        end
        if p.bombTime==0 then p.bombTime,p.cancelOnlyBomb=nil,nil end
    end
    if s.level==36 then TH38.visual.update(p,s) end
end
function Player:init()
    player_class.init(self)
    local s=assert(P.state())
    local m=P.machine(s.level,lstg.var.native_player_id)
    self.native_level,self.machine=s.level,m
    self.name=m.name
    self.shotImage=shots(s.level)
    self.hspeed,self.lspeed=m.fast,m.slow
    self.y=respawnY[s.level]
    self.A=s.level==36 and (m.id=='reimu' or m.id=='yukari') and .48 or .72
    if s.level>=38 then self.A=1 end
    self.B=self.A
    self.a,self.b=self.A,self.B
    self.grazeRadius=s.level==36 and (m.art=='marisa' and 38.4 or 26.4) or 24
    local adapter=P.adapters[s.level]
    if adapter and adapter.init then adapter.init(self,s) end
    self.grazer.a,self.grazer.b=self.grazeRadius,self.grazeRadius
    self.altForm=false
    self.beams={}
    self.ani_intv=s.level==35 and 5 or 6
    local function frames(name)
        local key=art(s.level,name)
        local imgs={}
        for i=1,24 do imgs[i]=key..i end
        return imgs
    end
    self.baseImages=adapter and adapter.images and adapter.images(self,m) or frames(m.art)
    self.imgs=self.baseImages
    self.img=self.imgs[1]
    if s.level==36 then
        local other=P.machine(36,aslOther[m.id])
        self.altImages=other.art~=m.art and frames(other.art) or self.baseImages
    end
    self.turn,self.shotClock=0,0
    SourceVisual.bind(self)
    if adapter and adapter.bind then adapter.bind(self) end
    self.a,self.b=self.A,self.B
    self._playersys:addFrameEvent('native_player',1000,tick)
    self._playersys:addFrameEvent('frame.updateSlow',99,function(p)
        local slow=p._playersys.keyState.slow
        p.slow=adapter and adapter.updateSlow and adapter.updateSlow(p,slow) or (slow and 1 or 0)
    end)
    self._playersys:addFrameEvent('native_player.late',93,function(p)
        if adapter and adapter.lateControl then
            p.native_controls_running=true
            if p.native_shoot_pending then p.native_shoot_pending=nil;Player.shoot(p) end
            if p.native_bomb_pending then p.native_bomb_pending=nil;bomb(p,s) end
            p.native_controls_running=nil
        end
        if adapter and adapter.lateFrame and adapter.frame then adapter.frame(p,s) end
    end)
    self._playersys:addFrameEvent('frame.move',97,function(p)
        if not p.hit and not SourceDeath.locked(p) and p.death<50 and not s.recover and not P.out() then
            if not (adapter and adapter.move and adapter.move(p,s)) then SourceMovement.step(p,s,adapter) end
        else p.__move_dx,p.__move_dy=0,0 end
    end)
end
function Player:colli(other)
    if not ActorCollision.contact(self,other) then return end
    if self.hit or SourceDeath.locked(self) or self.death~=0 or self.dialog or self.lock or cheat or self.protect>0
        or other.IsBoss and not other.is_combat then return end
    local s=P.state()
    if P.out() then return end
    local adapter=P.adapters[s.level]
    if adapter and adapter.beforeHit and adapter.beforeHit(self,other,s) then return true end
    self.hitWindow=self.machine.window or (s.bombs>=10 and 60 or 18)
    if s.level==37 then
        if (tonumber(s.chapter) or 0)>=6 then self.hitWindow=30 end
    end
    if adapter and adapter.hitWindow then self.hitWindow=adapter.hitWindow(self,s) end
    self.hit=self.hitWindow
    SourceDeath.hit(self)
    if adapter and adapter.hit then adapter.hit(self,s) end
    if s.level==36 then TH38.visual.hit(self,s) end
    local group=other.group
    if group==GROUP.ENEMY_BULLET or group==GROUP.ENEMY_BULLET2 then
        OriginalBulletVisual.cancel_bullet(other,'Del',false)
    end
    return true
end

function Player:render()
    if self.realrealreal_lock or self.hide or self.native_body_hidden or self.death>=50 and not self.native_death_clock then return end
    local adapter=P.adapters[self.native_level]
    if adapter and adapter.beforeRender then adapter.beforeRender(self,P.state()) end
    player_class.render(self)
    if self.native_level==36 then TH38.visual.player(self) end
    if adapter and adapter.render then adapter.render(self,P.state()) end
    for _,beam in ipairs(self.beams) do
        if not SourceVisual.beam(self,beam) then
        local x,y,dir,width=unpack(beam)
        local length=math.max(0,(lstg.world.t-y)/math.max(.25,sin(dir)))
        SetImageState('white','mul+add',120,115,165,255)
        Render('white',x+length*cos(dir)/2,y+length*sin(dir)/2,dir,length/16,width/8)
        SetImageState('white','',255,255,255,255)
        end
    end
    SourceVisual.focus(self)
end
CopyImage('native_asl_sub','reimu_bullet_blue')
function P.spawn()
    local adapter=P.adapters[lstg.var.native_player_level]
    if adapter and adapter.spawn then return adapter.spawn(P.state()) end
    return New(Player)
end
P.emit,P.ray=emit,ray
P.Shot=Shot
NativePlayers=P
return P
