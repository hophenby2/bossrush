-- The native fan-game stages store a separate player version in the replay initial state.
local P={VERSION=1,adapters={}}
local lifeThresholds={9,12,15,20,25,30,35,40,40,99}
local respawnY={[35]=-180,[36]=-176,[37]=-400/3,[38]=-176,[39]=-176}
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
local stages={['TH40@BossRush']=38,['TH41@BossRush']=39,['TH42@BossRush']=40,['TH37@BossRush']=35,['TH38@BossRush']=36,['TH39@BossRush']=37}
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
    if level>=38 then
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
function ResourceItem:init(x,y,kind,amount)
    local images={life=7,bombs=9,power=1,fragments=7,red=7,green=9,blue=2,night=2,star=2}
    item.init(self,x,y,images[kind])
    self.native_pickup,self.kind,self.amount=true,kind,amount
    local s=P.state()
    local adapter=s and P.adapters[s.level]
    if adapter and adapter.item then adapter.item(self,kind) end
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
function P.drop(level,x,y,items,boss,nonspell)
    if not items or not P.enabled(nil,level) then return end
    local function value(i) return tonumber(items[i]) or 0 end
    local function drop(kind,amount,count)
        for _=1,count do
            New(ResourceItem,x+ran:Float(-16,16),y+ran:Float(-16,16),kind,amount)
        end
    end
    local up,bomb=value(boss and 7 or 5),value(boss and 9 or 6)
    local bigUp,bigBomb=0,0
    if boss then
        if level==35 and stage.current_stage.group.difficulty==4 then up,bomb=0,0 end
        bigUp,bigBomb=value(6),value(8)
        if nonspell then
            bomb,up=bomb+up,0
            if level==37 then bigUp,bigBomb=0,0 end
        end
    end
    drop('life',1,up)
    drop('bombs',1,bomb)
    if bigUp>0 and ran:Float(0,100)<=bigUp then drop('life',5,1) end
    if bigBomb>0 and ran:Float(0,100)<=bigBomb then drop('bombs',5,1) end
    if level==35 and P.state().power<400 then
        drop('power',5,value(4))
        if value(3)>0 and ran:Float(0,100)<=value(3) then drop('power',20,1) end
        if boss then drop('power',400,value(5)) end
    end
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
    local o=New(Shot,img,p.x+x,p.y+y,v,dir,dmg~=0 and dmg or nil)
    o.dir,o.rot=dir,dir-90
    o.a,o.b,o.rect=r,r,false
    o.v,o.homing,o.native_main=v,homing,main
    if v<=2 then o.maxAge=25 end
    o.hscale,o.vscale=scale or 1,scale or 1
    return o
end
function Shot:frame()
    if self.maxAge and self.timer>=self.maxAge then object.Del(self);return end
    if not self.homing then return end
    local p=lstg.player
    local target=IsValid(p) and p.target
    if not (target and IsValid(target) and target.colli) then return end
    local delta=(Angle(self,target)-self.dir+180)%360-180
    self.dir=self.dir+math.max(-self.homing,math.min(self.homing,delta))
    self.rot=self.dir-90
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
local part2Options={
    reimu={{-20,25},{20,25},{-35,0},{35,0}},
    marisa={{-12,28},{12,28},{-36,2},{36,2}},
    sanae={{-12,24},{12,24},{-32,4},{32,4}},
}
local part2Focus={{-15,25},{15,25},{-5,30},{5,30}}
local sanaeFast={93,103,87,77,110,120,70,60}
local sanaeSlow={88,76,92,104,90,88,90,92}
local function part2(p,t)
    local m,key,s=p.machine,p.shotImage,P.state()
    if t%3==0 then
        for _,x in ipairs({-10,10}) do emit(p,key..m.art,x,-10,22,90,m.damage,4,.9) end
    end
    local layout=part2Options[m.id]
    if not layout then return end
    local slow=p.slow==1
    for i=1,math.min(4,math.floor(s.power/100)) do
        local pt=(slow and part2Focus or layout)[i]
        local x,y=pt[1],pt[2]
        if m.id=='reimu' and t%7==0 then
            emit(p,key..'amulet',x,y,9,90,16,6,.45,8)
        elseif m.id=='marisa' then
            local dir=x>21 and 86 or x< -21 and 94 or 90
            ray(p,p.x+x,p.y+y,dir,1,slow and 5.2 or 7.8,slow and 4.4 or 6.6,true)
        elseif m.id=='sanae' and t%6==0 then
            local dirs=slow and sanaeSlow or sanaeFast
            -- The source seed itself has zero power. The main stream supplies direct damage.
            emit(p,key..'seed',x,y,9,dirs[2*i-1],0,10,.8)
            emit(p,key..'seed',x,y,9,dirs[2*i],0,10,.8)
        end
    end
end

local aslFast={-42,-31,-20,-18,-15,-9,-7,-4,4,7,9,15,18,20,31,42}
local aslSlow={-30,-15,15,30}
local aslCharge={45,83,123,163}
local byakurenCharge={{60,.035},{72,.044},{52,.053},{50,.062}}
local mikoCharge={36,12,8,8}
local mikoAlternate={16,14,22,18}
local byakurenAlternate={90,108,72,64}
local aslOther={reimu='yukari',yukari='reimu',byakuren='miko',miko='byakuren',
    marisa='marisa_b',marisa_b='marisa'}
local function asl(p,t)
    local m=p.machine
    local slow=p.slow==1
    local id=p.altForm and aslOther[m.id] or m.id
    local mode=P.machine(36,id)
    local img=p.shotImage..mode.art
    if t%5==0 then
        local x,y=7.2,19.2
        if m.damage==11 then x,y=8.16,7.2 end
        for _,side in ipairs({-1,1}) do
            emit(p,img,side*x,y,57.6,90,m.damage,19.2,1,nil,true)
        end
    end
    if id=='reimu' and not p.altForm and t%10==0 then
        for _,a in ipairs({-21,-9,9,21}) do emit(p,'native_asl_sub',0,0,7.2,90+a,12,3,1,8) end
    elseif m.art=='yukari' and t%7==0 then
        for _,x in ipairs({-4.8,4.8}) do
            emit(p,img,x,p.altForm and 24 or 14.4,p.altForm and 57.6 or 48,90,5,2,1)
        end
    elseif m.id=='marisa' and not p.altForm and t%(slow and 15 or 24)==0 then
        for _,a in ipairs(slow and aslSlow or aslFast) do
            emit(p,'native_asl_sub',0,0,slow and 4.8 or 11.52,90+a,slow and 15 or 22,4,1,slow and 8)
        end
    elseif m.art=='marisa' and (m.id=='marisa_b')~=p.altForm then
        p.laserStart=math.min(15,(p.laserStart or 0)+1)
        if p.laserStart>12 then
            for _,x in ipairs({-16,-6,6,16}) do
                ray(p,p.x+x,p.y,90,3,slow and 5 or 8,slow and 5 or 8,t%2==0)
            end
        end
        if p.altForm and not slow and t%20==0 then emit(p,'native_asl_sub',-4.32,-2.88,1.92,90,24,6,1) end
    elseif m.id=='marisa_b' and p.altForm and t%2==0 then
        emit(p,'native_asl_sub',0,0,slow and 7.2 or 4.8,90,4,4,1)
    elseif m.damage==11 then
        p.charge=(p.charge or 0)+1
        if p.charge>=163 then barrierAdd(P.state(),50) end
        if p.chargeSlow and not slow then
            local i=4
            while i>0 and p.charge<aslCharge[i] do i=i-1 end
            if i>0 then
                if m.id=='byakuren' and not p.altForm then
                    local b=byakurenCharge[i]
                    emit(p,'native_asl_sub',0,0,b[2]*96,90,b[1],12,2)
                elseif m.id=='byakuren' then
                    emit(p,'native_asl_sub',0,0,1.248,90,byakurenAlternate[i],12,2)
                else
                    local d=(p.altForm and mikoAlternate or mikoCharge)[i]
                    ray(p,p.x,p.y,90,5*i,d,d,true)
                end
            end
            p.charge=0
        end
        p.chargeSlow=slow
    end
end

local function part3(p,t)
    local m,key=p.machine,p.shotImage
    local v=m.velocity*projectScale
    local function fire(x,y,angle,r,scale,damage,speed)
        emit(p,key..m.art,x*projectScale,y*projectScale,speed and speed*projectScale or v,
            angle,damage or m.damage,r*projectScale,scale*projectScale)
    end
    local slow=p.slow==1
    if m.id=='reimu' then
        if t%7==0 then
            for i=1,4 do
                local a=(i-1)*(slow and 2 or 4)
                local speed=30-3*i
                fire(-30,0,90+a,25,.3,5,speed)
                fire(30,0,90-a,25,.3,5,speed)
            end
        end
        for _,x in ipairs({-30,-10,10,30}) do fire(x,-math.abs(x),90,15,.7) end
    elseif m.id=='reimu_b' then
        local a=p.turn*25
        for _,pos in ipairs({100,80,120,60,150,30}) do
            fire(38*cos(pos-a),38*sin(pos-a),90-a,25,.55)
        end
        local width=slow and 40 or 60
        for _,side in ipairs({-1,1}) do
            fire(side*width*cos(a),-side*width*sin(a),90-a,25,.35,6)
        end
    elseif m.art=='marisa' then
        local a=t*6
        local width=slow and 27 or 47
        local x=width*cos(a)*(a%360<180 and 1 or -1)
        fire(x,0,90,30,.6)
        if t>=30 then fire(-x,0,90,30,.6) end
        if t%3==0 then
            local width=slow and 45 or 60
            for _,side in ipairs({-1,1}) do
                fire(side*width,0,90,20,.35,m.id=='marisa' and 8 or 6,30)
            end
        end
    elseif m.art=='sanae' then
        fire(0,0,90,50,.5)
        if t%2==0 then
            local width=slow and 25 or 40
            local a=slow and 2 or 5
            fire(-width,0,90+a,25,.25,5,50)
            fire(width,0,90-a,25,.25,5,50)
        end
    elseif t%2==0 then
        fire(-18,10,90,25,.5)
        fire(18,10,90,25,.5)
    end
    if m.id=='mokou_b' and t%5==0 then
        for i=0,2 do
            fire(-90,0,90-10*i,5,.45,6,20)
            fire(90,0,90+10*i,5,.45,6,20)
        end
    elseif m.id=='mokou' and t%(slow and 2 or 3)==0 then
        local width=slow and 18 or 72
        fire(-width,0,slow and 140 or 180,50,.4,12,2)
        fire(width,0,slow and 40 or 0,50,.4,12,2)
    end
end

function Player:shoot()
    local level=self.native_level
    if self.hit or self.death>=50 or P.out() or P.state().recover then return end
    local adapter=P.adapters[level]
    if adapter and adapter.shoot then
        self.shotClock=self.shotClock+1
        return adapter.shoot(self,self.shotClock,P.state())
    end
    if level==36 then
        local tick=self.timer*2
        asl(self,tick)
        asl(self,tick+1)
    else
        self.shotClock=self.shotClock+1
        if level==35 then part2(self,self.shotClock)
        else part3(self,self.shotClock) end
    end
end

local function bomb(p,s)
    if p.dialog or p.death>=50 or p.bombTime or s.recover or P.out() then return end
    local adapter=P.adapters[s.level]
    if s.level>=38 then
        if not (adapter and adapter.bomb and adapter.bomb(p,s)) then return end
    elseif s.level==36 then
        if P.barriers(s)<3 then return end
        s.barrier,s.barrierReward=0,0
    else
        local cost=s.level==37 and p.hit and p.hitWindow==60 and 10 or 5
        if s.bombs<cost then return end
        s.bombs=s.bombs-cost
        p.strongBomb=cost==10
    end
    p.hit=nil
    p.bombTime=p.bombTime or 90
    p.nextspell=p.bombTime
    p.protect=math.max(p.protect,p.bombTime)
    for _,b in ipairs(boss_group) do
        if IsValid(b) and b.is_combat then b._bosssys:clearBonus('spell') end
    end
    New(bomb_bullet_killer,p.x,p.y,240,240,false)
    PlaySound('nep00',.5)
end
function P.miss(p)
    local s=P.state()
    if not s then return end
    local adapter=P.adapters[s.level]
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
        p.protect,p.death=150,90
        New(player_death_ef,p.x,p.y)
        New(bomb_bullet_killer,p.x,p.y,64,64,false)
        PlaySound('pldead00',.5)
        return
    end
    if s.level==36 and P.barriers(s)>0 then
        s.barrier=s.barrier-(s.barrier==299999 and 99999 or 100000)
        p.protect=60
        for _,b in ipairs(boss_group) do
            if IsValid(b) and b.is_combat then b._bosssys:clearBonus('hit') end
        end
        New(bomb_bullet_killer,p.x,p.y,60,60,false)
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
    New(player_death_ef,p.x,p.y)
    New(bomb_bullet_killer,p.x,p.y,64,64,false)
    PlaySound('pldead00',.5)
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
    if adapter and adapter.frame then adapter.frame(p,s) end
    if p.death==50 and not P.out() then p.x,p.y=0,respawnY[s.level] end
    local pressed=key.spell and not p.spellHeld
    p.spellHeld=key.spell
    if not key.shoot then p.charge,p.laserStart=0,math.max(0,(p.laserStart or 0)-2) end
    p.beams={}
    if s.level==36 then
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
    if pressed then bomb(p,s) end
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
    local adapter=P.adapters[s.level]
    self.baseImages=adapter and adapter.images and adapter.images(self,m) or frames(m.art)
    self.imgs=self.baseImages
    self.img=self.imgs[1]
    if s.level==36 then
        local other=P.machine(36,aslOther[m.id])
        self.altImages=other.art~=m.art and frames(other.art) or self.baseImages
    end
    self.turn,self.shotClock=0,0
    self._playersys:addFrameEvent('native_player',1000,tick)
    local move=player_lib.defaultFrameEvent['frame.move'][2]
    self._playersys:addFrameEvent('frame.move',97,function(p)
        if not p.hit and p.death<50 and not s.recover and not P.out() then move(p)
        else p.__move_dx,p.__move_dy=0,0 end
    end)
end
function Player:colli(other)
    if self.hit or self.death~=0 or self.dialog or self.lock or cheat or self.protect>0
        or other.IsBoss and not other.is_combat then return end
    local s=P.state()
    if P.out() then return end
    self.hitWindow=self.machine.window or (s.bombs>=10 and 60 or 18)
    if s.level==37 then
        if (tonumber(s.chapter) or 0)>=6 then self.hitWindow=30 end
    end
    self.hit=self.hitWindow
    local group=other.group
    if group==GROUP.ENEMY_BULLET or group==GROUP.ENEMY_BULLET2 then
        OriginalBulletVisual.cancel_bullet(other,'Del',false)
    end
    return true
end

function Player:render()
    if self.realrealreal_lock or self.hide or self.death>=50 then return end
    player_class.render(self)
    local adapter=P.adapters[self.native_level]
    if adapter and adapter.render then adapter.render(self,P.state()) end
    for _,beam in ipairs(self.beams) do
        local x,y,dir,width=unpack(beam)
        local length=math.max(0,(lstg.world.t-y)/math.max(.25,sin(dir)))
        SetImageState('white','mul+add',120,115,165,255)
        Render('white',x+length*cos(dir)/2,y+length*sin(dir)/2,dir,length/16,width/8)
        SetImageState('white','',255,255,255,255)
    end
    if self.slow==1 then
        SetImageState('white','',220,255,255,255)
        RenderRect('white',self.x-1,self.x+1,self.y-1,self.y+1)
        SetImageState('white','',255,255,255,255)
    end
end
CopyImage('native_asl_sub','reimu_bullet_blue')
function P.spawn()
    local adapter=P.adapters[lstg.var.native_player_level]
    if adapter and adapter.spawn then return adapter.spawn(P.state()) end
    return New(Player)
end
P.emit,P.ray=emit,ray
NativePlayers=P
return P
