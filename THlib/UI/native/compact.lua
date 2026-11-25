-- 竖屏沿用 TH31–35 的库存行和场内系统槽，不加载横屏版面。
local C={}
local floor,min,max=math.floor,math.min,math.max
local clamp=function(v) return max(0,min(1,v)) end
local textures={}
local function texture(path)
    if textures[path] then return textures[path] end
    local id='native-strip/'..path
    if not CheckRes('tex',id) then
        local pool=GetResourceStatus();SetResourceStatus('global')
        LoadTexture(id,path);SetResourceStatus(pool)
    end
    textures[path]=id
    return id
end
local function slice(tex,x,y,w,h,u,v,sw,sh,color)
    local c=color or Color(0xffffffff)
    RenderTexture(tex,'',{x,y+h/2,.5,u,v,c},{x+w,y+h/2,.5,u+sw,v,c},
        {x+w,y-h/2,.5,u+sw,v+sh,c},{x,y-h/2,.5,u,v+sh,c})
end
local function label(str,x,y,align)
    ui:RenderText('title',tostring(str),x,y,.85,Color(255,232,242,252),align,'vcenter')
end
local function slots(s,life,y,anchor)
    if s.level==36 then C.snow=C.snow or dofile('mod/GAME/th38/hud_data.lua') end
    if s.level==38 then C.summer=C.summer or dofile('mod/GAME/th40/hud_data.lua') end
    local level=s.level
    local n=life and s.life or s.bombs
    local classic=level==35 or level==37 or level==41
    local full=classic and floor(max(0,n)/5) or max(0,n)
    if level==36 then full=life and max(0,n-1) or NativePlayers.barriers(s) end
    local cap=(level==36 and not life) and 3 or (level==39 and not life and 5 or 8)
    if level==35 or level==37 then cap=10 end
    if level==40 then cap=life and 9 or 3;full=life and min(9,max(0,s.life+1)) or min(3,max(0,s.bombs)) end
    local gap=24
    local start=anchor or screen.width/2-cap*gap/2+30
    if not anchor then label(life and '残机' or level==36 and '结界' or level==40 and 'Mental' or 'Bomb',start-13,y,'right') end
    local function icon(i,on)
        local x=start+i*gap
        local c=Color(on and 255 or 57,255,255,255)
        if level==35 or level==37 then
            local tex=texture('Resources/th'..(level+2)..'/hud/numlogo.png')
            if level==35 then
                slice(tex,x,y,21,23,82,1,16,18,Color(c.a,life and 255 or 0,life and 153 or 230,life and 255 or 102))
            else
                slice(tex,x,y,29,29,floor(stage.current_stage.timer/6)%7*70,life and 70 or 140,70,70,c)
            end
        elseif level==36 then
            if life then
                local tex=texture('Resources/th38/presentation/'..(on and 'lighted' or 'dark')..'.png')
                local w,h=GetTextureSize(tex);slice(tex,x,y,23,23,0,0,w,h)
            else
                local tex=texture('Resources/th38/hud/panel.png')
                local r=C.snow.sprites[on and 'system_41' or 'system_40']
                slice(tex,x,y,18,18,r[1],r[2],r[3],r[4],c)
            end
        elseif level==38 then
            local r=C.summer.sprites[(life and 'Life' or 'Bomb')..(on and '' or '0d')]
            slice(texture('Resources/th40/hud/panel.png'),x,y,23,23,r[1],r[2],r[3],r[4])
        elseif level==39 or level==41 then
            local bdb=level==41
            local tex=texture(bdb and 'Resources/th43/ui/ui_game_3.png' or 'Resources/ports/theis/res/ui/ui_item_16_9_1.png')
            slice(tex,x,y,23,23,(bdb and 864 or 1590)+(on and 72 or 0),
                (bdb and 390 or 0)+(life and 0 or 72),72,72)
        elseif level==40 then
            local name=life and 'ld_state_9' or 'ld_state_10'
            if CheckRes('img',name) then
                SetImageState(name,'',c);Render(name,x+11,y,0,.7);SetImageState(name,'',Color(0xffffffff))
            end
        end
    end
    if anchor then icon(0,true) else for i=0,cap-1 do icon(i,i<full) end end
    local suffix=classic and n%5>0 and (' + %d/5'):format(n%5) or ''
    label((anchor and 'x' or '')..tostring(full)..suffix,anchor and start+29 or start+gap*cap+7,y,'left')
end
function C.height() return 120 end
function C.banner()
    local s=NativePlayers and NativePlayers.state()
    if not s then return false end
    if s.level==36 then C.snow=C.snow or dofile('mod/GAME/th38/hud_data.lua') end
    if s.level==38 then C.summer=C.summer or dofile('mod/GAME/th40/hud_data.lua') end
    local band=screen.height-lstg.world.scrt
    local top=screen.height-band/2+32
    local val
    if s.level==35 or s.level==38 then val=('灵力  %.2f / 4.00'):format(s.power/100)
    elseif s.level==36 then val=('残机碎片  %d / %d'):format(s.fragments,NativePlayers.lifeThreshold(s))
    elseif s.level==39 then val=('残机碎片  %g / 100     Bomb 碎片  %g / 100'):format(s.lifeChip,s.bombChip)
    elseif s.level==40 then val=('Follower  %d'):format(lstg.var.like_dreamer_score_item_base or 100)
    elseif s.level==41 then val=('蓝点  %d     碎片  %d / 6'):format(s.points,s.rankChips) end
    label(val or ('擦弹  %d'):format(lstg.var.graze or 0),screen.width/2,top-64,'center')
    return true
end
function C.inventory(life,x,y)
    local s=NativePlayers.state()
    if s then slots(s,life,y,x) end
end
function C.lower(x,y)
    local s=NativePlayers.state()
    if not s then return end
    local level=s.level
    local function bar(tex,bg,fg,k)
        slice(tex,x,y,133,18,unpack(bg))
        k=clamp(k)
        if k>0 then slice(tex,x+2,y,129*k,12,fg[1],fg[2],fg[3]*k,fg[4]) end
    end
    if level==35 or level==37 then
        NativePlayers.adapters[level].drawSystem(x,y)
    elseif level==36 then
        bar(texture('Resources/th38/presentation/beilvtiao.png'),{4,62,133,24},{9,54,124,12},s.barrier/299999)
    elseif level==38 then
        local c=({red='B',blue='A',green='C'})[s.enchantment or s.lastStarColor or 'green']
        local data=C.summer or dofile('mod/GAME/th40/hud_data.lua');C.summer=data
        local tex=texture('Resources/th40/hud/panel.png')
        local function part(suffix,k)
            local r=data.sprites['border'..c..suffix]
            if k>0 then slice(tex,x,y-36+36*k,40,72*k,r[1],r[2]+r[4]*(1-k),r[3],r[4]*k) end
        end
        part('1',1);part('2',clamp(s.star/3000));part('0',1)
    elseif level==39 then
        local tex=texture('Resources/ports/theis/res/ui/ui_item_16_9_1.png')
        local items=lstg.tmpvar._system_items or {}
        label(('红 %d  蓝 %d  绿 %d  夜 %d'):format(items.red or 0,items.blue or 0,items.green or 0,items.night or 0),x,y+74,'left')
        label(('染色 %d / %s    累计 %d'):format(s.stageChain or 0,s.dyeTarget or '—',s.dyeChain or 0),x,y+50,'left')
        bar(tex,{1024,528,564,22},{1030,556,552,9},s.lifeChip/100)
        y=y+16
        bar(tex,{1024,572,564,22},{1030,600,552,9},s.bombChip/100)
    elseif level==40 then
        local p=player
        local value=(p and IsValid(p) and p.specialGauge) or lstg.var.like_dreamer_special_gauge or 0
        if CheckRes('img','ld_enemy_gauge_1') then
            SetImageState('ld_enemy_gauge_1','',Color(255,64,64,128))
            RenderRect('ld_enemy_gauge_1',x,x+140,y-6,y+6)
            SetImageState('ld_enemy_gauge_fill','',Color(255,255,64,64))
            RenderRect('ld_enemy_gauge_fill',x,x+140*clamp(value<0 and -value/600 or value/50000),y-3,y+3)
        end
    elseif level==41 then
        local tex=texture('Resources/th43/ui/ui_game_3.png')
        label(('Rank %d    碎片 %d / 6'):format(s.rank or 0,s.rankChips or 0),x,y+28,'left')
        bar(tex,{316,760,436,16},{322,777,424,10},s.rankValue/5000)
        local p=TH43.runtime.env.system.PowerRank
        if p.isInHyper() then
            y=y+18;bar(tex,{0,1642,650,70},{4,1716,642,62},(p.time or 0)/p.getHyperMaxTime())
        end
    end
end
return C
