-- 春雪篇樱花结界执行原作 SpecialSystem；库存和分数写回宿主录像状态。
local B,R=...
local CS,E=B.CS,B.CS.env
local S={}
local drawHUD=dofile('mod/GAME/ports/mhj/native_players/system_hud.lua')(B)
E.SakuraStatus={CLOSED=0,OPENING=1,CLOSING=2}
E.Main.rand={__static=true,NextDouble=function() return ran:Float(0,1) end}
local source=dofile('mod/GAME/ports/mhj/native_players/spring_special.lua')(CS)
E.SpecialSystem=source.SpecialSystem
local game=B.game
game.Score=nil
setmetatable(game,{
    __index=function(_,k)
        if k=='Score' then return lstg.var.score or 0 end
        if k=='MaxBlue' then local s=NativePlayers.state();return s and s.pointrate or 0 end
    end,
    __newindex=function(t,k,v)
        if k=='Score' then lstg.var.score=v
        elseif k=='MaxBlue' then NativePlayers.state().pointrate=v
        else rawset(t,k,v) end
    end,
})
function game:LifeItem(v) return NativePlayers.pickup(v.X-224,240-v.Y,'life',1) end
function game:BombItem(v) return NativePlayers.pickup(v.X-224,240-v.Y,'bombs',1) end
local function green(x,y,broken)
    local o=NativePlayers.pickup(x,y,'sakuraGreen',broken and 2 or 8)
    o.target=player
    return o
end
function game:SmallItem(v) return green(v.X-224,240-v.Y,false) end
function S.bind(p)
    local difficulty=stage.current_stage.group.difficulty or 4
    E.Main.Level=difficulty
    S.system=CS.new('SpecialSystem',CS.Sprite('37_grazebox'),'37_spscore','37_bosslist')
    S.system:Reset()
    p.mhj_source.sakura=S.system
    p._playersys:addFrameEvent('frame.itemCollect',95,function(o)
        local line=({75,50,75,50})[p.mhj_source.type]
        for _,item in ObjList(GROUP.ITEM) do
            local auto=o.y>=line or item.kind=='sakuraGreen' and item.timer>=50
            if auto or Dist(o,item)<(o.slow==1 and 60 or 30) then item.target,item.attract=o,auto and 10 or 5 end
        end
    end)
end
function S.frame(p,s)
    local c=B.character
    c.IsBombing=B.bomb~=nil
    S.system:Update(nil,nil,nil,c)
    if S.system.breaking and S.system.closetime<=60 then
        for o in pairs(R.objects) do
            local v=o.mhj
            if IsValid(o) and v and v.is_projectile and not v.controller.effectLayer and not v.Invincible and not v.dis
                and (not v.Mist or v.age>15) and Dist(p,o)<S.system.closetime*10 then
                if v.life>2 and v.alpha>=70 then green(o.x,o.y,true) end
                Del(o)
            end
        end
    end
    s.sakuraPower,s.sakuraMax,s.sakuraStatus=S.system.Power,S.system.hipower,S.system.Status
end
function S.renderHUD(x,y) drawHUD(S.system,x,y) end
function S.breakShield(motivated)
    if S.system and S.system.Status==1 then
        S.system:Break(B.character,motivated)
        for _,b in ipairs(boss_group) do if IsValid(b) and b.is_combat then b._bosssys:clearBonus('hit') end end
        return true
    end
    return false
end
function S.graze()
    local s=NativePlayers.state()
    if S.system.Status==1 then S.system.MaxBlue=S.system.MaxBlue+S.system.CurrentLevel*20;S.system.Graze=S.system.Graze+1
    else s.pointrate=s.pointrate+10 end
    S.system.Power=S.system.Power+8
end
function S.collect(s,kind,amount)
    if kind=='points' then
        local y=240-player.y
        local base=(stage.current_stage.group.difficulty or 4)>=5 and 300000 or 200000
        local score=math.floor(((y<({165,190,165,190})[player.mhj_source.type] and base or 25*(545-y))+s.pointrate)/10)*10
        lstg.var.score=(lstg.var.score or 0)+score*amount
        s.points=s.points+amount
        if S.system.Status==1 then S.system.Blue=S.system.Blue+amount end
        S.system.Power=S.system.Power+100*amount
        return true
    elseif kind=='sakuraGreen' then
        lstg.var.score=(lstg.var.score or 0)+100
        S.system.Power=S.system.Power+amount
        s.green=s.green+1
        if s.green%10==0 then s.pointrate=s.pointrate+10 end
        return true
    elseif kind=='power' then
        lstg.var.score=(lstg.var.score or 0)+(amount>=400 and 2000000 or amount>=20 and 200000 or 10000)
    end
    return false
end
return S
