-- 祈华梦的高速/低速双机体，射击和道具使用 LuaSTG 对象。
local P=NativePlayers
local M={ownBomb=true,lateFrame=true,heldBomb=true}
local Original=dofile('mod/GAME/ports/theis/native_players/bridge.lua')
-- bind() 中由原作构造器安装行走图。
function M.images() return {'img_void'} end
function M.bind(p) Original.bind(p) end
function M.init(p) p.grazeRadius=32 end
function M.beforeRender(p) Original.render(p) end
function M.frame(p) Original.frame(p) end
function M.shoot(p) return Original.shoot(p) end
function M.bomb(p,s)
    if s.bombs<=0 or p.shield or p.nextspell>0 then return false end
    s.bombs=s.bombs-1
    Original.spell(p)
    p.bombTime,p.cancelOnlyBomb=p.nextspell,true
    M.clearBonus()
    lstg.var.bomb_used=(lstg.var.bomb_used or 0)+1
    return true
end
function M.updateSlow(p,slow)
    if p.slowlock then return 1 end
    if (p.lock_player_shift or 0)<=0 then p.theis_slow=slow and 1 or 0 end
    return p.theis_slow or 0
end
function M.beforeHit(p) return Original.shieldHit(p) end
function M.speeds(p) return p.hspeed*(p.speed_rate or 1),p.lspeed*(p.speed_rate or 1) end
local function addBomb(s,n)
    local stock=s.bombs+n
    s.bombs=math.min(5,stock)
    s.pointrate=math.min(5000000,s.pointrate+math.max(0,stock-5)*100000)
end
function M.collect(s,kind,amount)
    local dyes=lstg.var.dyeitem
    if dyes[kind]==nil then return false end
    dyes[kind]=dyes[kind]+amount
    local items=lstg.tmpvar._system_items
    if items then items[kind]=(items[kind] or 0)+amount end
    if kind=='red' then
        s.lifeChip=s.lifeChip+.25*amount
        local lives=s.life+math.floor(s.lifeChip/100)
        s.life=math.min(8,lives)
        s.lifeChip=s.lifeChip%100
        if lives>8 then addBomb(s,lives-8) end
    elseif kind=='green' then
        s.bombChip=s.bombChip+amount
        addBomb(s,math.floor(s.bombChip/100))
        s.bombChip=s.bombChip%100
    elseif kind=='blue' then
        s.stageBlue=s.stageBlue+amount
        lstg.var.score=(lstg.var.score or 0)+s.pointrate*amount
    else
        s.pointrate=math.min(5000000,s.pointrate+10*amount)
        lstg.var.score=(lstg.var.score or 0)+10000*amount
    end
    return true
end
local itemImages={red='item_red1',blue='item_blue1',green='item_green1',night='item_night'}
function M.item(o,kind)
    if not itemImages[kind] then return end
    o.img,o.imgup=itemImages[kind],nil
    o.a,o.b=8,8
    if kind=='night' then o.target,o.attract=player,8 end
end
P.adapters[39]=M
return M
