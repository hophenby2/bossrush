-- 栖霞园原作 HUD 图集，自机状态由 NativePlayers 提供。
local H={}
local atlas='th40_hud'
local data={
    life0={864,390,72,72},life1={936,390,72,72},bomb0={864,462,72,72},bomb1={936,462,72,72},
    hbomb0={864,534,72,72},hbomb1={936,534,72,72},
    rankEmpty={316,760,436,16},rankFill={322,777,424,10},
    hyperEmpty={0,1642,650,70},hyperFill={4,1716,642,62},
}
local function prepare()
    if CheckRes('tex',atlas) then return end
    local pool=GetResourceStatus()
    SetResourceStatus('global')
    LoadTexture(atlas,'Resources/th40/ui/ui_game_3.png')
    for name,rect in pairs(data) do LoadImage(atlas..name,atlas,unpack(rect)) end
    SetResourceStatus(pool)
end
function H.draw(x1,x2,top,alpha,s,m)
    prepare()
    local function row(label,value,y)
        ui:RenderText('title',label,x1,y,.65,Color(alpha,183,221,248),'left','vcenter')
        ui:RenderText('title',tostring(value),x2,y,.65,Color(alpha,253,235,213),'right','vcenter')
    end
    local function sprite(name,l,r,b,t)
        SetImageState(atlas..name,'',alpha,255,255,255)
        RenderRect(atlas..name,l,r,b,t)
    end
    local function gauge(prefix,y,amount,height)
        sprite(prefix..'Empty',x1,x2,y-height/2,y+height/2)
        if amount>0 then
            local rect=data[prefix..'Fill']
            local c=Color(alpha,255,255,255)
            local l,r,b,t=x1+1,x1+1+(x2-x1-2)*amount,y-height*.32,y+height*.32
            local u,v,w,h=unpack(rect)
            RenderTexture(atlas,'',{l,t,.5,u,v,c},{r,t,.5,u+w*amount,v,c},
                {r,b,.5,u+w*amount,v+h,c},{l,b,.5,u,v+h,c})
        end
    end
    local power=TH40.runtime.env.system.PowerRank
    local hyper=power.isInHyper()
    row('机体',m.name,top)
    row('分数',('%010d'):format(lstg.var.score),top-23)
    row('残机',math.floor(s.life/5),top-46)
    row('Bomb',math.floor(s.bombs/5),top-86)
    local width=math.min(21,(x2-x1)/8)
    for i=1,8 do
        local x=x1+(i-1)*width
        sprite(i<=s.life/5 and 'life1' or 'life0',x,x+width,top-76,top-56)
        local name=hyper and 'hbomb' or 'bomb'
        sprite(name..(i<=s.bombs/5 and '1' or '0'),x,x+width,top-116,top-96)
    end
    row('蓝点',s.points,top-134)
    row('火力等级',s.rank..' · '..s.rankChips..' / 6',top-155)
    gauge('rank',top-172,s.rankChips/6,8)
    if hyper then
        gauge('hyper',top-194,math.max(0,math.min(1,(power.time or 0)/power.getHyperMaxTime())),15)
    else gauge('hyper',top-194,s.bombFragments/100,15) end
end
return H
