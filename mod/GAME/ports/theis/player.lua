-- 祈华梦的高速/低速双机体，射击和道具使用 LuaSTG 对象。
local P=NativePlayers
local M={}
local art={
    reimu={'reimu','yukari',140,120,138,138,.8,{'reimu_main',96,0,96,76},{'yukari_main',0,0,96,40}},
    marisa={'marisa','yuyuko',116,130,120,120,.8,{'marisa_missle',0,0,240,240},{'yuyuko_main',0,0,512,256}},
    mokou={'mokou','keine',90,120,96,120,1,{'mokou_main',162,0,162,44},{'mokou_main',0,0,162,44}},
}
function M.images(p,m)
    local row=art[m.id]
    local prefix='theis_player_'..m.id
    local path='Resources/ports/theis/res/player/'..m.id..'/'
    local images={}
    for slot=1,2 do
        local id=prefix..'_'..slot..'_'
        if not CheckRes('tex',id) then
            LoadTexture(id,path..row[slot]..'_player.png')
            LoadImageGroup(id,id,0,0,row[slot*2+1],row[slot*2+2],8,3)
            local bullet=row[7+slot]
            LoadTexture(id..'shot',path..bullet[1]..'.png')
            LoadImage(id..'shot',id..'shot',unpack(bullet,2,5))
        end
        local frames={}
        for i=1,24 do frames[i]=id..i end
        images[slot]=frames
    end
    p.theisImages=images
    p.hscale,p.vscale=row[7],row[7]
    p.theisShot=prefix
    return images[1]
end
function M.frame(p)
    p.imgs=p.theisImages[p.slow==1 and 2 or 1]
end
function M.shoot(p,t)
    local slow=p.slow==1
    local id=p.machine.id
    local img=p.theisShot..(slow and '_2_shot' or '_1_shot')
    local function fire(x,y,speed,angle,damage,scale,homing)
        local o=P.emit(p,img,x,y,speed,angle,damage,4,scale,homing,true)
        o.rot=angle
    end
    if t%6==0 then
        PlaySound('plst00',.08)
        if id=='reimu' then
            if slow then
                for i=-5,5,2 do fire(4*i,12-3*math.abs(i),12,90,1.2,.6) end
            else
                for _,x in ipairs({-8,8}) do fire(x,0,10,90,5,.6) end
                for i=-3,3,2 do fire(12*i,-15,10,90+i*3,1.5,.3,3) end
            end
        elseif id=='marisa' then
            if not slow then fire(0,0,16,90,8,.22)
            else for _,x in ipairs({-10,10}) do fire(x,0,12,90,2,.11) end end
        else
            for _,x in ipairs({-8,8}) do fire(x,0,10,90,slow and 2 or 1,.5) end
        end
    elseif id=='marisa' and slow and t%6==3 then
        fire(-10,0,12,95,2,.11)
        fire(10,0,12,85,2,.11)
    elseif id=='mokou' and not slow and t%9==0 then
        fire(-26,18,8,105,3,.35,4)
        fire(26,18,8,75,3,.35,4)
    end
end
local bombTimes={reimu={270,400},marisa={300,180},mokou={180,420}}
function M.bomb(p,s)
    if s.bombs<=0 then return false end
    s.bombs=s.bombs-1
    p.bombTime=bombTimes[p.machine.id][p.slow==1 and 2 or 1]
    M.clearBonus()
    lstg.var.bomb_used=(lstg.var.bomb_used or 0)+1
    return true
end
local function addBomb(s,n)
    local stock=s.bombs+n
    s.bombs=math.min(5,stock)
    s.pointrate=math.min(5000000,s.pointrate+math.max(0,stock-5)*100000)
end
function M.collect(s,kind,amount)
    local dyes=lstg.var.dyeitem
    if dyes[kind]==nil then return false end
    dyes[kind]=dyes[kind]+amount
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
