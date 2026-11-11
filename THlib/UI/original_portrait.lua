-- 竖屏只重排原作front/ascii：上方底板承载原右栏，场内左下保留原生特殊系统。
-- 行描述与绘制共用，残机/Bomb独占一行，其余成对；不在此处显示分数或改动资源账本。
return function(H,R)
local min,max,floor=math.min,math.max,math.floor
local A=OriginalANM
local labels={
    [6]={lives=10,bombs=11,power=15,graze=16,points=20},
    [7]={lives=4,bombs=5,power=6,graze=7,points=8},
    [8]={lives=4,bombs=5,power=6,graze=7,points=8,time=9},
    [10]={lives=6,power=7},
}
local names={lives='Player',bombs='Bomb',power='Power',graze='Graze',points='Point',time='Time',faith='Faith'}
local function state() return SequenceResources and SequenceResources.state() end
local function bombCount(s) return s.game==10 and floor(s.power/20) or max(0,s.bombs) end
local function value(s,key)
    if key=='lives' then return max(0,s.lives)
    elseif key=='bombs' then return bombCount(s)
    elseif key=='power' then return s.game==10 and ('%.2f / 5.00'):format(s.power/20) or s.power>=128 and 'MAX' or tostring(s.power)
    elseif key=='graze' then return tostring(lstg.var.graze or 0)
    elseif key=='points' then return s.game==6 and tostring(s.stage_points) or s.points..'/'..R.pointThreshold(s)
    elseif key=='time' then return s.time..'/'..H.timeThreshold(s)
    elseif key=='faith' then return tostring(s.faith) end
end
function H.portraitRows(s)
    s=s or state();if not s then return {} end
    local rows={{'lives'},{'bombs'}}
    local fields=s.game==95 and {} or s.game==10 and {'power','faith'} or {'power','graze','points'}
    if s.game==8 then fields[#fields+1]='time' end
    for i=1,#fields,2 do rows[#rows+1]={fields[i],fields[i+1]} end
    return rows
end
function H.portraitHeight() return #H.portraitRows()*32+24 end
local function labelWidth(g,key)
    local id=labels[g] and labels[g][key]
    return id and A.load(g,'front').sprites[id][4] or #names[key]*14
end
local function label(g,key,x,y,alpha)
    local id=labels[g] and labels[g][key]
    if id then R.sprite(g,'front',id,x,y,1,1,nil,alpha)
    else R.text(g,names[key],x,y,1,1,nil,alpha) end
end
local function inventory(o,s,key,x,y,compact,alpha)
    local g=s.game
    local v=g==6 and o.front[key=='lives' and 16 or 17]
        or (g==7 or g==8) and o.front[key=='lives' and (g==7 and 9 or 10) or (g==7 and 10 or 11)]
        or g==10 and key=='lives' and o.life[0]
    local count=value(s,key)
    if v then
        if compact then R.at(v,x,y,alpha/255);R.text(g,'x'..count,x+20,y,.85,1,nil,alpha)
        else
            for i=0,count-1 do R.at(v,x+i*16,y,alpha/255) end
            if count==0 then R.text(g,'0',x,y,1,1,nil,alpha) end
        end
    else R.text(g,(compact and names[key]..' ' or '')..count,x,y,.85,1,nil,alpha) end
end
local function fieldWidth(s,key)
    local count=value(s,key)
    local icons=key=='lives' and s.game~=95 or key=='bombs' and s.game~=10 and s.game~=95
    local width=key=='power' and s.game<=8 and 128 or icons and max(1,count)*16 or #tostring(count)*14
    return labelWidth(s.game,key)+10+width
end
local function field(o,s,key,x,y,alpha)
    label(s.game,key,x,y,alpha)
    local offset=labelWidth(s.game,key)+10
    if key=='lives' or key=='bombs' then inventory(o,s,key,x+offset,y,false,alpha)
    else
        if key=='power' and s.game<=8 and s.power>0 then
            R.rect(x+offset,x+offset+s.power,y,y+16,{224,224,255},alpha*180/255)
        end
        R.text(s.game,value(s,key),x+offset,y,1,1,nil,alpha)
    end
end
function H.portraitBanner()
    local s,o=state(),R.current();if not s or not o then return false end
    local w=lstg.world
    local width,height=screen.width,screen.height-w.scrt
    local g=o.game
    R.view(0,screen.height,1,function()
        if g==10 or g==95 then
            R.crop(g,'front',1,0,0,width,height)
        else
            local id=g==6 and 5 or g==7 and 12 or 13
            local sprite=A.load(g,'front').sprites[id]
            for y=0,height-1,32 do for x=0,width-1,32 do
                R.sprite(g,'front',id,x,y,min(32,width-x)/sprite[4],min(32,height-y)/sprite[5])
            end end
        end
    end)
    local rows=H.portraitRows(s)
    local gap=min(36,(height-16)/#rows)
    local top=screen.height-(height-#rows*gap)/2-6
    for i,row in ipairs(rows) do
        for j,key in ipairs(row) do
            local column=width/#row
            local scale=min(.95,(column-24)/fieldWidth(s,key))
            local x=(j-.5)*column-fieldWidth(s,key)*scale/2
            R.view(x,top-(i-1)*gap,scale,function() field(o,s,key,0,0,255) end)
        end
    end
    return true
end
function H.portraitLower(x,buttonY,alpha)
    local s,o=state(),R.current();if not s or not o then return false end
    local g,top=s.game,buttonY+48
    local special=g==7 and o.cherry or g==8 and o.gauge5 or g==10 and o.faith[0]
    if special then
        top=buttonY+66
        local p=special.position
        R.view(x-p[1],top+p[2],1,function()
            if g==7 then R.cherry(o,s) elseif g==8 then R.human(o,s,true) else R.faith(o,s) end
        end)
        top=top+28
    end
    -- 从按钮向上排列特殊系统、Power、Bomb、残机；库存使用原作图标和阿拉伯数字。
    local scale=.8
    for i,key in ipairs({'power','bombs','lives'}) do
        local y=top+(i-1)*24
        R.view(x,y,scale,function()
            if key=='power' then
                label(g,key,0,0,alpha)
                R.text(g,g==10 and ('%.2f'):format(s.power/20) or tostring(s.power),labelWidth(g,key)+6,0,.85,1,nil,alpha)
            else inventory(o,s,key,0,0,true,alpha) end
        end)
    end
    return true
end
end
