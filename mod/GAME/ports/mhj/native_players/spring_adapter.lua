-- 春雪篇直接执行原作装备、主炮、自机弹与八套 Bomb。
local R=...
local B=assert(loadfile('mod/GAME/ports/mhj/native_players/bridge.lua'))(35,R)
local M={ownBomb=true,lateFrame=true,lateControl=true}
local S=assert(loadfile('mod/GAME/ports/mhj/native_players/spring_system.lua'))(B,R)
function M.reset(s,v,spell)
    s.life=v.is_practice and not spell and 40 or 10
    s.bombs=10;s.pointrate,s.points,s.green=0,0,0
    s.power=(v.is_practice or v.sequence_key=='thmhj2_extra' or v.sequence_key=='thmhj2_phantasm') and 400 or 0
end
function M.bind(p) B.bind(p);S.bind(p) end
function M.frame(p,s) B.frame(p,s);S.frame(p,s) end
function M.shoot(p) B.shoot(p) end
function M.beforeRender(p) B.render(p) end
function M.drawSystem(x,y) S.renderHUD(x,y) end
function M.speeds(p) return B.speeds(p) end
function M.bomb(p,s)
    B.input(p)
    -- 原 Character.Update 只处理本次按下；SWudi 与正在执行的雷都先于爆结界判断。
    if not B.pressed('spell') or B.bomb or B.character.SWudi then return false end
    if S.breakShield(true) then return false end
    if s.bombs<5 or B.bomb or p.nextspell>0 then return false end
    s.bombs=s.bombs-5
    s.pointrate=s.pointrate-math.min(math.floor(s.pointrate*.1),150000);s.pointrate=s.pointrate-s.pointrate%10
    lstg.var.bomb_used=(lstg.var.bomb_used or 0)+1
    B.spell(p)
    return true
end
function M.beforeHit()
    -- 结界与雷分别维护自己的无敌标记，不能合并成一个估算的 protect 倒计时。
    return B.character.BWudi or B.character.SWudi or S.breakShield(false)
end
function M.graze(...) S.graze(...) end
function M.collect(s,kind,amount) return S.collect(s,kind,amount) end
function M.miss(_,s)
    s.pointrate=s.pointrate-math.min(math.floor(s.pointrate*.15),300000);s.pointrate=s.pointrate-s.pointrate%10
end
NativePlayers.adapters[35]=M
return M
