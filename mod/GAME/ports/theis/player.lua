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
    if kind=='theisSmall' then kind='night' end
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
local itemImages={red='item_red1',blue='item_blue1',green='item_green1',night='item_night',theisSmall='item_small'}
function M.item(o,kind)
    if not itemImages[kind] then return end
    o.img,o.imgup=itemImages[kind],nil
    -- EISlib/item/itemclass.lua：彩色道具 26 帧飞出，随后缓入追踪。
    o.theis_item=true
    o.x0,o.y0=o.x,o.y
    o.theis_minor=kind=='night' or kind=='theisSmall'
    o.size=o.theis_minor and .5 or kind=='green' and 1.75 or 2.25
    o.flylen=o.theis_minor and 32 or 16
    o.hscale,o.vscale,o.vx,o.vy,o.lockt=0,0,0,0,0
    o.a=(kind=='red' or kind=='blue') and 10 or 8;o.b=o.a;o.rect=false
    o.target,o.attract,o.collected=lstg.player,8,true
end
function M.itemFrame(o)
    if not o.theis_item then return false end
    if o.timer<=26 then
        local k=o.timer/26;local t=-(k*(k-2))
        o.hscale,o.vscale=t*o.size,t*o.size
        o.x,o.y=o.x0,o.y0+o.flylen*t
    elseif o.timer>30 then
        local vx,vy,rate=0,-.5,.05
        if o.attract>.0001 and IsValid(o.target) then
            local a=Angle(o,o.target);vx,vy=o.attract*cos(a),o.attract*sin(a)
            o.lockt=math.min(o.lockt+.005,1);rate=o.lockt
        else o.lockt=0;if o.y<lstg.world.boundb then object.RawDel(o) end end
        o.vx,o.vy=o.vx+(vx-o.vx)*rate,o.vy+(vy-o.vy)*rate
    end
    return true
end
function M.itemRender(o)
    if not o.theis_item then return false end
    local img=o.img
    if not o.theis_minor then img='item_'..o.kind..(math.floor(o.ani/6)%3+1) end
    img=_editor_class.TH41.source.lstg.ResourceSet.Resolve(2,img)
    SetImageState(img,o.theis_minor and 'mul+add' or '',o.theis_minor and 100 or 255,255,255,255)
    Render(img,o.x,o.y,0,o.hscale*.5,o.vscale*.5)
    return true
end
P.adapters[39]=M
return M
