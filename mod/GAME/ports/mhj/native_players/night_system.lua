-- 永夜篇的灯笼、能量与结界由原始 SpecialSystem 推进。
local B,R=...
local CS,E=B.CS,B.CS.env
local S={}
E.Difficulty={EASY=1,NORMAL=2,HARD=3,LUNATIC=4,EXTRA=5,EXULTIMATE=6,ULTRA=7}
E.BreakSource={None=0,Barrage=1,Enemy=2,Familiar=3,Boss=4,Petrify=5,Jue=6,Control=7,Dialog=8}
E.CharacterCard={Bomb=0,JueBomb=1,Special=2}
E.NeedDeleteType={None=0}
E.AchievementBase={IntParams={[0]=0}}
E.RPYInfo={__static=true,VersionEnergyItemWhenLanternReleasing=function() return true end,VersionAutoSpecialItem=function() return true end}
E.Enum={__static=true,GetNames=function() return CS.array(7,function() return '' end) end}
E.SpecialSystemSet={__new=function() return {} end}
E.Main.Language=1
E.Main.scfont={MeasureString=function(_,s) return CS.Vector2(#s*8,24) end}
E.CrazyStorm.ToScreen=CS.Vector2(-145,0)
E.CardDisplay=dofile('mod/GAME/ports/mhj/native_players/night_carddisplay.lua')(CS).CardDisplay
E.CardDisplay.Draw=function() end
local character=dofile('mod/GAME/ports/mhj/native_players/night_character.lua')(CS).Character
local special=dofile('mod/GAME/ports/mhj/native_players/night_special.lua')(CS).SpecialSystem
E.SpecialSystem=special
local game=B.game
function game:LanternPause() S.system:Pause() end
function game:LanternRecover() S.system:Recover() end
function game:LanternBreak(motivated,source,lostAll) S.system:Break(B.character,motivated,source,lostAll,'39_bosslist') end
function game:HasEffect(id) return pcall(R.loadPattern,'e'..tostring(id)) end
R.sourceStatus=function(method,...)
    local c=B.character
    if not c or not S.system then return end
    B.input(B.player)
    if method=='Control' then
        local startup,x,y,duration,tail,effect=...
        c:Control(startup,CS.Vector2(x-145,y),duration,tail,effect)
    else c[method](c,...) end
end
R.sourceStatusClear=function()
    local c=B.character
    if c then c:FreeControl();c:ClearNegativeStatus() end
end
for _,k in ipairs({'CurrentCrystalChallenge','CurrentEnergyChallenge','CurrentHyperChallenge','CurrentResourceChallenge','LastStageMaxBlue','EndTime'}) do game[k]=0 end
local eventMeta={__add=function(o,f) o[f]=true;return o end,__sub=function(o,f) o[f]=nil;return o end}
game.DrawCardDisplay=setmetatable({},eventMeta)
E.Program.main.achivmanager={Check=function() end}
local dynamic={Score=true,MaxBlue=true,LanternStatus=true,LanternLighting=true,LanternSetting=true,ProtectChance=true,LanternStayTime=true,LanternItemProduced=true}
for k in pairs(dynamic) do game[k]=nil end
setmetatable(game,{
    __index=function(_,k)
        if k=='Score' then return lstg.var.score or 0 end
        if k=='MaxBlue' then local s=NativePlayers.state();return s and s.pointrate or 0 end
        local v=S.system;if not v then
            if k=='LanternStatus' or k=='ProtectChance' or k=='LanternStayTime' then return 0 end
            return false
        end
        if k=='LanternStatus' then return v.Status elseif k=='LanternLighting' then return v.Status~=0 and not v.Closing
        elseif k=='LanternSetting' then return v.setting elseif k=='ProtectChance' then return v.ProtectChance
        elseif k=='LanternStayTime' then return v.StayTime elseif k=='LanternItemProduced' then return v.ItemProduced end
    end,
    __newindex=function(t,k,v)
        if k=='Score' then lstg.var.score=v elseif k=='MaxBlue' then NativePlayers.state().pointrate=v else rawset(t,k,v) end
    end,
})
function game:LifeItem(v) return NativePlayers.pickup((v.X-336)*2/3,(360-v.Y)*2/3,'life',1) end
function game:BombItem(v) return NativePlayers.pickup((v.X-336)*2/3,(360-v.Y)*2/3,'bombs',1) end
function game:EnergyItem(v) return NativePlayers.pickup((v.X-336)*2/3,(360-v.Y)*2/3,'lanternEnergy',1) end
function game:BlueItem(v) return NativePlayers.pickup((v.X-336)*2/3,(360-v.Y)*2/3,'points',1) end
E.Character.SelfPowerAlpha,E.Character.SelfDisplayScale=.6,.875
E.Character.__new=function(...)
    if select('#',...)==1 then return {body=(...)} end
    local c=setmetatable({},character);character.defaults(c);c.SelfDisplaySizeType,c.SelfPowerDisplayType=2,2;c:ctor(...);return c
end
local function view()
    local csm={csc=CS.List()}
    local groups={}
    for o in pairs(R.objects) do
        local b=o.mhj
        if IsValid(o) and b and b.is_projectile and not b.controller.effectLayer and not b.familiar then
            local owner=groups[b.controller]
            if not owner then
                owner={highlightDispel=true,layerm={LayerArray=CS.List()}}
                owner.layerm.LayerArray:Add({Barrages=CS.List()});groups[b.controller]=owner;csm.csc:Add(owner)
            end
            local particle=setmetatable({}, {
                __index=function(_,k)
                    if k=='Dis' then return b.dis~=nil elseif k=='NeedDelete' then return 0 elseif k=='time' then return b.age
                    elseif k=='x' then return b.fx elseif k=='y' then return b.fy elseif k=='add' then return 0
                    elseif k=='centerMasked' then return false end
                    return b[k]
                end,
                __newindex=function(_,k,v)
                    if k=='Dis' then if v and not b.dis then Del(o) end
                    elseif k=='time' then b.age=v else b[k]=v end
                end,
            })
            owner.layerm.LayerArray[0].Barrages:Add(particle)
        end
    end
    return csm
end
function S.bind(p)
    E.Main.Character=p.mhj_source.type;E.Main.Level=stage.current_stage.group.difficulty or 4
    local raw=dofile('mod/GAME/ports/mhj/native_players/night_settings.lua');local settings=CS.List()
    for _,row in ipairs(raw) do local a=CS.List();for _,v in ipairs(row) do a:Add(v) end;settings:Add(a) end
    S.system=CS.new('SpecialSystem','39_spscore',settings);S.system:Reset(false)
    B.lantern=S.system
    local c=B.character
    local defaults={};character.defaults(defaults)
    for k,v in pairs(defaults) do if c[k]==nil then c[k]=v end end
    c.equip=B.equipment;setmetatable(c,character)
    c.SelectChaseTarget=nil
    c.SelfDisplaySizeType,c.SelfPowerDisplayType=2,2
    c.IsPositionInLight=character.IsPositionInLight
    c.CancelDis=function() p.hit=nil;NativePlayers.death.cancel(p);c.Dis=false end
    c.ChangeEquip=function()
        p.mhj_source.equipType=1-p.mhj_source.equipType
        c.equipType,c.EquipType=p.mhj_source.equipType,p.mhj_source.equipType
        B.equipment:Reinit()
    end
    p.mhj_source.lantern=S.system
    p.native_source_body_scale=.875
    p.native_source_render=function()
        local old=c.body.color;local color=CS.copy(old);local tint=p.native_tint
        if tint then color.a=color.a*tint[1]/255;color.r=color.r*tint[2]/255;color.g=color.g*tint[3]/255;color.b=color.b*tint[4]/255 end
        local offset=not c.controling and c.relieveOffset or CS.Vector4()
        c.body.color=color;c:DrawSprite(nil,CS.Vector2(offset.X,offset.Y),c.petrifying and not c.controling);c.body.color=old
    end
    game.CharacterSets=CS.List()
    for _,name in ipairs({'reimu','marisa','sanae','mokou'}) do game.CharacterSets:Add(B.makeConfig(name,true)) end
    game.SelfBarrage=B.equipment.tex
    p._playersys:addFrameEvent('frame.itemCollect',95,function(o)
        local auto=o.y> -40/3 or c.Auto
        for _,item in ObjList(GROUP.ITEM) do
            if auto or Dist(o,item)<(o.slow==1 and 225 or 120)*2/3 then item.target,item.attract=o,20*2/3 end
        end
    end)
end
function S.frame(p,s)
    local c=B.character
    c:NativeNegativeUpdate()
    if c.CBanShoot then p.x,p.y=(c.body.position.X-336)*2/3,(360-c.body.position.Y)*2/3 end
    c.IsControling,c.IsPetrifying=c.controling,c.petrifying
    c.jue=p.hit and (p.hitWindow-p.hit) or 0
    c.IsBombing=B.bomb~=nil
    c.slowingTime=p.slow==1 and (c.slowingTime or 0)+1 or 0
    c.noSlowTime=p.slow==0 and (c.noSlowTime or 0)+1 or 0
    game.StmStage=tonumber(s.chapter) or 1
    S.system:Update(view(),c)
    S.system:UpdateTeammate(c,{HasValue=false})
    if c.SWudi or c.PWudi then p.protect=math.max(p.protect,2) end
    s.lanternPower,s.lanternMax,s.lanternStatus,s.lanternEnergy=S.system.Power,S.system.setting.HiPower,S.system.Status,S.system.Energy
end
function S.beforeHit(p,other)
    local v=S.system;local c=B.character
    if game.LanternLighting then
        local source=other and (other.IsBoss and E.BreakSource.Boss or other.group==GROUP.ENEMY and E.BreakSource.Enemy or E.BreakSource.Barrage) or E.BreakSource.Barrage
        local lost=v.Status~=3
        v:Break(c,false,source,lost,'39_bosslist')
        return lost
    elseif v.ProtectChance>0 then v:BreakProtect(c,false);return true end
    return false
end
function S.onBomb(p)
    local v=S.system;local c=B.character
    if game.LanternLighting and v.Status~=2 and v.Status~=3 then
        v:Break(c,true,E.BreakSource.Jue,true)
        return true
    elseif v.ProtectChance>0 then v:BreakProtect(c,true);return true
    elseif v.Status==2 or v.Status==3 or v.Status==5 and v.StayTime<=30 then return true end
    return false
end
function S.graze()
    local v=S.system
    if game.LanternLighting then v.Graze=v.Graze+1 end
    v.Power=v.Power+v.setting.GrazePower
end
function S.collect(s,kind,amount)
    local v=S.system;local setting=v.setting
    if kind=='lanternEnergy' then
        if v.Energy>=3 then lstg.var.score=(lstg.var.score or 0)+1000000 else v.Energy=v.Energy+amount end
        return true
    elseif kind=='points' then
        local difficulty=stage.current_stage.group.difficulty or 4
        local base=({80000,100000,150000,200000,300000,300000,200000})[difficulty]
        local y=360-player.y*1.5
        local total=base+s.pointrate
        local score=y<380 and total or math.floor(total/(672-380))*math.max(10,672-math.floor(y))
        lstg.var.score=(lstg.var.score or 0)+(score-score%10)*amount
        s.points=(s.points or 0)+amount
        local gain
        if v.Status==0 then gain=v.ProtectChance>0 and setting.BluePowerOpened or setting.BluePowerClosed
        elseif v.Status==5 or v.Status==6 then gain=setting.BluePowerClosed
        elseif v.Status==1 or v.Status==4 then gain=setting.BluePowerOpened;v.ItemEnergy=v.ItemEnergy+gain*amount end
        v.Power=v.Power+(gain or 0)*amount
        if v.Status==5 or v.Status==6 then v.Power=math.min(v.Power,math.floor(setting.HiPower*.99)) end
        if game.LanternLighting then v.Blue=v.Blue+amount end
        return true
    elseif kind=='lanternGreen' then
        lstg.var.score=(lstg.var.score or 0)+100
        s.green=(s.green or 0)+1
        local gain=0
        if v.Status==0 then gain=setting.GreenPower[v.ProtectChance>0 and 3 or 0]
        elseif v.Status==5 then gain=setting.BreakPower[v.Progress<50 and 0 or 1]
        elseif v.Status==6 then gain=setting.GreenPower[0]
        elseif v.Status==1 or v.Status==4 then gain=setting.GreenPower[1];v.ItemEnergy=v.ItemEnergy+gain end
        v.Power=v.Power+gain
        if v.Status==5 or v.Status==6 then v.Power=math.min(v.Power,math.floor(setting.HiPower*.99)) end
        if s.green%10==0 then s.pointrate=s.pointrate+5 end
        return true
    end
    return false
end
function game:SmallItem(first,second)
    local v=type(first)=='table' and first or second
    return NativePlayers.pickup((v.X-336)*2/3,(360-v.Y)*2/3,'lanternGreen',1)
end
S.view=view
function S.render() S.system:DrawTeammate(nil,CS.Vector2()) end
return S
