-- 永夜篇的武器按原始 C# 的 A/B 装备状态计算。
local R=...
local B=assert(loadfile('mod/GAME/ports/mhj/native_players/bridge.lua'))(37,R)
local M={lateFrame=true,ownBomb=true,lateControl=true}
local S=assert(loadfile('mod/GAME/ports/mhj/native_players/night_system.lua'))(B,R)
function M.reset(s,v,spell)
    s.life=v.is_practice and not spell and 40 or 10
    s.bombs,s.power=15,400
    s.pointrate,s.points,s.green=0,0,0
end
function M.bind(p) B.bind(p);S.bind(p) end
function M.frame(p,s) B.frame(p,s);S.frame(p,s) end
function M.shoot(p) B.shoot(p) end
function M.beforeRender(p) B.render(p);S.render() end
function M.bomb(p,s)
    if p._playersys.keyState.special or B.bomb or p.nextspell>0 then return false end
    if S.onBomb(p) then return false end
    local special=p.hit and p.hitWindow==60 and s.bombs>=10
    local cost=special and 10 or 5
    if s.bombs<cost then return false end
    s.bombs=s.bombs-cost
    B.spell(p,special)
    lstg.var.bomb_used=(lstg.var.bomb_used or 0)+1
    return true
end
function M.beforeHit(p,other) return S.beforeHit(p,other) end
function M.graze(...) return S.graze(...) end
function M.collect(s,kind,amount) return S.collect(s,kind,amount) end
function M.speeds(p) return B.speeds(p) end
function M.move(p)
    local c=B.character
    if c.BanMove or c.petrifying then p.__move_dx,p.__move_dy=0,0;return true end
end
NativePlayers.adapters[37]=M
return M
