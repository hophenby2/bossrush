-- 顺序模式独立的原作资源账本。原始火力单位保留为 0..128 / 风神录 0..100，
-- 不经过随机模式百分比成长；所有逻辑状态放在 var，重试和录像从同一初态重建。
local P={VERSION=1,gameByLevel={[29]=8,[30]=6,[31]=95,[32]=7,[33]=10}}
SequenceResources=P
local floor,min,max=math.floor,math.min,math.max
local cache={}
local function var() return lstg.var end
function P.enabled() return var().__sequence_version==1 and var().__sequence_system_version==P.VERSION end
function P.state() return P.enabled() and var().original_resources end
function P.game() local s=P.state();return s and s.game end
local function machine(id,name,character,shot,route,primary,secondary)
    return {id=id,name=name,character=character,shot=shot,route=route,primary=primary,secondary=secondary or primary}
end
function P.machines(game)
    local out={}
    if game==95 then return {machine('aya','射命丸文 · 摄影',0,0,'aya_player')} end
    if game==8 then
        local names={'博丽灵梦','雾雨魔理沙','十六夜咲夜','魂魄妖梦','八云紫','爱丽丝','蕾米莉亚','西行寺幽幽子'}
        local teams={'结界组 · 灵梦 / 紫','咏唱组 · 魔理沙 / 爱丽丝','红魔组 · 咲夜 / 蕾米莉亚','幽冥组 · 妖梦 / 幽幽子'}
        for i=0,3 do
            out[#out+1]=machine('team'..i,teams[i+1],i,0,(i==1 or i==2) and 'marisa_player' or 'reimu_player',('ply%02da'):format(i),('ply%02das'):format(i))
        end
        for i=0,7 do
            local c=i%4;local file=('ply%02da%s'):format(c,i>=4 and 's' or '')
            out[#out+1]=machine('solo'..i,names[i+1]..' · 单人',c,i>=4 and 1 or 0,(c==1 or c==2) and 'marisa_player' or 'reimu_player',file)
        end
        return out
    end
    local count=game==7 and 3 or 2
    for c=0,count-1 do for a=0,(game==10 and 2 or 1) do
        local character=({'reimu','marisa','sakuya'})[c+1]
        local suffix=string.char(97+a);local id=character..suffix
        local file=game==6 and id or (game==10 and 'pl' or 'ply')..('%02d'):format(c)..suffix
        out[#out+1]=machine(id,({'博丽灵梦','雾雨魔理沙','十六夜咲夜'})[c+1]..' '..suffix:upper(),c,a,
            c==1 and 'marisa_player' or 'reimu_player',file,game==7 and file..'s' or file)
    end end
    return out
end
function P.machine(game,id)
    for _,m in ipairs(P.machines(game)) do if m.id==id then return m end end
end
function P.data(game,key)
    if not cache[game] then cache[game]=dofile('mod/GAME/original/players/'..game..'.lua') end
    return assert(cache[game][key],'缺少原作自机射击表：'..game..'/'..key)
end
function P.selection(key,id)
    local game=assert(P.gameByLevel[assert(OriginalSequence.catalog.get(key)).level])
    return assert(P.machine(game,id),'机体不属于当前原作：'..tostring(id)),game
end
function P.reset()
    if not P.enabled() then var().original_resources=nil;return end
    local m,game=P.selection(var().sequence_key,var().sequence_player)
    local extra=not var().sequence_key:find('lunatic',1,true)
    local d=game~=95 and P.data(game,m.primary) or {}
    local s={game=game,machine=m.id,lives=2,bombs=d.bombs or 3,power=extra and (game==10 and 80 or 128) or 0,
        points=0,stage_points=0,extends=0,power_chain=0,cherry=game==7 and extra and (var().sequence_key:find('phantasm',1,true) and 300000 or 200000) or 0,
        cherry_max=game==7 and (extra and 400000 or 300000) or 0,
        cherry_plus=0,border=0,faith=game==10 and 50000 or 0,faith_timer=0,faith_decay=90,time=0,clock=0,continues=0,
        continue_limit=var().sequence_continue_limit or 3,human=0,gauge=0,gauge_ramp=0,gauge_delay=0,bomb_count=0}
    if game==95 then s.power,s.bombs,s.lives=0,0,9 end
    var().original_resources=s
    var().power,var().faith,var().sakura,var().man=s.power,s.faith,s.cherry_plus,0
    var().pointrate=game==8 and 300000 or game==7 and 50000 or game==6 and (extra and 300000 or 200000) or s.faith
end
function P.sync()
    local s=P.state();if not s then return end
    local v=var();v.power,v.faith,v.sakura,v.man=s.power,s.faith,s.cherry_plus,s.human
    v.ON_sakura=s.border>0
end
function P.addScore(n)
    local s=assert(P.state());local v=var();v.score=min(9999999990,max(0,v.score+floor(n/10)*10))
    if s.game==6 or s.game==10 then
        local thresholds=s.game==6 and {10000000,20000000,40000000,60000000} or {20000000,40000000,80000000,150000000}
        if not v.sequence_key:find('lunatic',1,true) then thresholds=s.game==6 and {} or {100000000} end
        while thresholds[s.extends+1] and v.score>=thresholds[s.extends+1] do
            s.extends=s.extends+1;s.lives=min(8,s.lives+1);PlaySound('extend',.5)
        end
    end
end
function P.cherry(n,plus)
    local s=P.state();if not s or s.game~=7 then return end
    s.cherry=min(s.cherry_max,s.cherry+n)
    if plus and s.border==0 then s.cherry_plus=min(50000,s.cherry_plus+n) end
    P.sync()
end
local powerScore={10,20,30,40,50,60,70,80,90,100,200,300,400,500,600,700,800,900,1000,2000,3000,4000,5000,6000,7000,8000,9000,10000,11000,12000,51200}
local function pointExtend(s)
    local n=s.extends
    local extra=not var().sequence_key:find('lunatic',1,true)
    if s.game==7 then
        if extra then return n==0 and 200 or n==1 and 500 or 800+(n-2)*500 end
        return n<3 and 50+n*75 or n<5 and 300+(n-3)*150 or 800+(n-5)*200
    end
    -- 永夜抄 ItemManager::UpdatePointItemExtendThreshold。
    if extra then return ({200,666,9999})[n+1] or 99999 end
    return ({100,250,500,800,1100,9999})[n+1] or 9999+(n-5)*500
end
function P.collect(kind,y,full)
    local s=assert(P.state());local game=s.game
    local m=P.machine(game,s.machine);local d=game~=95 and P.data(game,m.primary) or {}
    local sourceY=224-y;local poc=d.poc or 128
    local high=full or sourceY<poc
    if kind=='power' or kind=='power_big' or kind=='full' then
        local limit=game==10 and 100 or 128
        local gain=kind=='full' and limit or kind=='power_big' and (game==10 and 20 or 8) or 1
        if s.power>=limit then
            if game==6 then s.power_chain=min(30,s.power_chain+gain);P.addScore(powerScore[s.power_chain+1])
            elseif game==7 then P.collect('cherry',y,full)
            elseif game==8 then P.collect('point_small',y,full)
            elseif game==10 then P.collect('faith_small',y,full) end
        else
            s.power_chain=0;s.power=min(limit,s.power+gain);if game~=10 then P.addScore(kind=='full' and 1000 or 10) end
            if s.power==limit and game<10 and P.clear then P.clear('power') end
        end
        if game==10 then s.faith_timer=min(130,s.faith_timer+(kind=='power_big' and 20 or 60)) end
    elseif kind=='point' or kind=='point_small' or kind=='point_full' then
        local value
        if game==6 then
            local extra=not var().sequence_key:find('lunatic',1,true)
            value=high and (extra and 300000 or 200000) or (extra and 200000-(floor(sourceY)-128)*400 or 150000-(floor(sourceY)-128)*270)
        elseif game==7 then
            value=high and max(50000,s.cherry) or 50000-floor(max(0,sourceY-poc))*100+max(0,s.cherry-50000)/5
        elseif game==8 then
            value=high and var().pointrate or var().pointrate/2-floor(sourceY-poc)*floor(var().pointrate/1000)
            if s.human<=P.humanThreshold() then value=value*2 end
            if kind=='point_small' then value=value/10 end
        elseif game==10 then
            sourceY=224-player.y
            value=(kind=='point_full' or sourceY<144) and s.faith or s.faith/2-floor((sourceY-144)*.003289473708719015*(s.faith*.05-5000))
        else return end
        P.addScore(max(0,value))
        if kind=='point' then
            s.points=s.points+1;s.stage_points=s.stage_points+1
            if game==7 or game==8 then
                while s.points>=pointExtend(s) do s.extends=s.extends+1;s.lives=min(8,s.lives+1);PlaySound('extend',.5) end
            end
        end
        if game==10 then s.faith_timer=min(130,s.faith_timer+100) end
    elseif kind=='cherry' then
        if s.cherry==s.cherry_max then P.addScore(high and 50000 or max(0,50000-floor(sourceY-poc)*100)) end
        P.cherry(1000+(var().getsc or 0)*100,true)
    elseif kind=='cherry_small' then P.cherry(70,false);P.cherry(30,true)
    elseif kind=='faith' or kind=='faith_minor' or kind=='faith_small' then
        if game==10 then
            s.faith=min(999990,s.faith+(kind=='faith' and 10000 or kind=='faith_small' and 100 or 10))
            s.faith_timer=min(130,s.faith_timer+(kind=='faith' and 120 or kind=='faith_small' and 60 or 3))
            if kind=='faith_minor' then P.addScore(10) end
        elseif game==8 then P.collect('time',y,full)
        elseif game==7 then P.collect('cherry',y,full)
        else P.collect('power',y,full) end
    elseif kind=='time' then
        s.time=s.time+1;s.total_time=(s.total_time or 0)+1
        if s.total_time%2==1 then var().pointrate=(var().pointrate or 300000)+10 end
        P.addScore(s.bomb and 100 or s.stage_points>=2000 and 10000 or max(100,floor(s.points/2)*10))
        if not s.time_gauge_suppression or s.time_gauge_suppression<=0 then P.addGauge(player and player.__slow_flag and 111 or -111) end
    elseif kind=='star' then
        P.addScore(s.bomb and 100 or 300+floor((var().graze or 0)/40)*10)
        if game==7 then P.cherry(s.bomb and 10 or 20,true) end
    elseif kind=='bomb' then s.bombs=min(8,s.bombs+1)
    elseif kind=='life' then s.lives=min(8,s.lives+1);PlaySound('extend',.5) end
    P.sync()
end
function P.graze()
    local s=assert(P.state())
    local n=s.game==8 and (s.human<=P.humanThreshold() and 3 or s.human<=-20 and 2 or 1) or 1
    if not s.bomb then var().graze=var().graze+n;s.stage_graze=(s.stage_graze or 0)+n end
    if s.game==6 then P.addScore(500)
    elseif s.game==7 then
        P.addScore(2000)
        if s.border>0 then local n=player.__slow_flag and 30 or 80;s.cherry_max=s.cherry_max+n;P.cherry(n,false) end
    elseif s.game==8 then
        P.addScore(s.human>=20 and 4000 or 2000)
        if P.isYoukai(player) then P.addGauge(100) end
        if s.human>=P.youkaiThreshold() then
            for _,b in ipairs(boss_group or {}) do
                if IsValid(b) and b.is_combat then
                    P.collect('time',player.y,true)
                    if b.is_sc then P.collect('time',player.y,true) end
                    break
                end
            end
        end
    end
end
function P.humanThreshold() local s=P.state();return s and (s.machine=='team3' or s.machine=='solo3') and -30 or -80 end
function P.youkaiThreshold() local s=P.state();return s and s.machine=='solo3' and 30 or 80 end
function P.isYoukai(p)
    if not p or p.original_game~=8 then return false end
    local m=p.original_machine
    return m.id:sub(1,4)=='solo' and m.shot==1 or m.id:sub(1,4)=='team' and p.__slow_flag==true
end
function P.addGauge(n,force)
    local s=P.state();if not s or s.game~=8 or s.bomb and not force then return end
    local m=P.machine(8,s.machine);local lo,hi=-10000,10000
    if m.id=='team3' then lo=-5000
    elseif m.id=='solo3' then lo,hi=-5000,5000
    elseif m.id:sub(1,4)=='solo' then if m.shot==0 then hi=2000 else lo=-2000 end end
    s.gauge=max(lo,min(hi,s.gauge+n));s.human=s.gauge/100
end
function P.gaugeStep(p)
    local s=P.state();if not s or s.game~=8 or s.bomb then return end
    if s.last_focus~=p.__slow_flag then s.last_focus=p.__slow_flag;s.focus_frames=0;s.gauge_ramp=0 end
    s.focus_frames=(s.focus_frames or 0)+1
    if s.focus_frames<30 then return end
    if p.__shoot_flag then
        if s.gauge_delay>0 then s.gauge_delay=s.gauge_delay-1
        else
            P.addGauge((P.isYoukai(p) and 1 or -1)*(s.gauge_ramp>300 and 21 or floor(s.gauge_ramp/15)))
            s.gauge_ramp=s.gauge_ramp+1
        end
    else
        if s.gauge_delay>=4 then s.gauge_ramp=0 end
        if s.gauge_delay>=30 then
            if math.abs(s.gauge)<=9 then s.gauge=0;s.human=0
            else P.addGauge(s.human>0 and (s.human>=P.youkaiThreshold() and -5 or s.human>=20 and -3 or -2)
                or (s.human<=P.humanThreshold() and 5 or s.human<=-20 and 3 or 2)) end
        else s.gauge_delay=s.gauge_delay+1 end
    end
end
function P.hitDamage(dmg,p,target)
    local s=P.state();if not s or s.bomb then return end
    if s.game==7 and (target.IsBoss or not p.__slow_flag) then
        local stage=tonumber(s.stage_name) or 7
        local factor=stage>=5 and 10 or stage*2
        local gain=min(70,floor(dmg/(target.IsBoss and not p.__slow_flag and (10-floor(factor/3)) or (30-factor)))*10)
        if gain==0 and (not p.__slow_flag or (target.timer or 0)%2~=0) then gain=10 end
        if s.machine=='reimua' and (gain==20 or gain==30) and (target.timer or 0)%2~=0 then gain=gain-10 end
        P.cherry(gain,true)
    end
end
function P.miss(p)
    local s=assert(P.state());s.lives=s.lives-1;var().dead=var().dead+1
    if s.game==95 then return end
    if s.game~=10 then s.power=s.lives<0 and 0 or max(0,s.power-16) end
    s.bombs=P.data(s.game,P.machine(s.game,s.machine).primary).bombs or 3
    -- TH07 UpdateDeath只扣Cherry，不动Cherry+；封顶和倍率来自本机体SHT。
    if s.game==7 and s.lives>=0 then
        local m=P.machine(7,s.machine);local d=P.data(7,m.primary)
        local penalty=min(m.character==2 and 60000 or 100000,floor(s.cherry*d.cherryPenalty))
        s.cherry=max(0,s.cherry-floor(penalty/10)*10)
    end
    s.power_chain=0;s.human=0;s.gauge=0
    if s.game==10 then s.faith=max(50000,s.faith-floor((s.faith-50000)/30)*10) end
    if s.game==10 then p.original_drop_delay=3;p.original_drop_origin={x=p.x,y=p.y}
    elseif P.deathDrops then P.deathDrops(p) end
    P.sync()
end
function P.beginChapter(chapter)
    local s=P.state();if s then
        s.stage_points=0;s.stage_graze=0;s.stage_frames=0;s.stage_name=chapter and chapter.name or '1'
        if s.game==8 then s.time=0 end
    end
end
function P.endChapter(index)
    local s=P.state();if not s or s.game==95 then return end
    local stage=tonumber((s.stage_name or ''):match('%d+')) or (s.stage_name=='PH' and 8 or 7)
    local extra=not var().sequence_key:find('lunatic',1,true)
    local last=extra or stage>=6
    local score=0
    if s.game==6 then
        score=(stage*1000+(s.stage_graze or 0)*10+s.power*100)*s.stage_points
        if last then score=score+s.lives*3000000+s.bombs*1000000 end
    elseif s.game==7 then
        score=stage*100000+(s.stage_graze or 0)*50+s.stage_points*5000+s.cherry_max
        if last then score=score+s.lives*2000000+s.bombs*400000 end
    elseif s.game==8 then
        local base=({['1']=1000000,['2']=1500000,['3']=2000000,['4A']=2500000,['4B']=2500000,['5']=3000000,['6A']=4000000,['6B']=6000000,EX=6660000})[s.stage_name] or 0
        score=base+(s.stage_graze or 0)*50+s.stage_points*5000+s.time*100
        if last then score=score+s.lives*2500000+s.bombs*500000 end
        if not extra and stage<6 then
            local requirement=({['1']=3000,['2']=7200,['3']=8800,['4A']=9999,['4B']=8500,['5']=9999})[s.stage_name]
            s.clock=min(12,(s.clock or 0)+(s.time>=(requirement or 99999) and 1 or 2))
        end
    end
    P.addScore(score*(extra and 2 or 1.5))
end
return P
