-- 幕华祭两作使用各自的残机、Bomb 和碎片图集。
local H={}
local function atlas(level)
    local key='mhj_hud_'..level
    if not CheckRes('tex',key) then
        local pool=GetResourceStatus()
        SetResourceStatus('global')
        local code=level==35 and 37 or 39
        LoadTexture(key,'Resources/th'..code..'/hud/numlogo.png')
        SetResourceStatus(pool)
    end
    return key
end
local function draw(tex,x,y,w,h,u,v,uw,uh,c)
    RenderTexture(tex,'',{x,y,.5,u,v,c},{x+w,y,.5,u+uw,v,c},
        {x+w,y-h,.5,u+uw,v+uh,c},{x,y-h,.5,u,v+uh,c})
end
local offsets={50,45,39,32}
function H.draw(x1,x2,top,a,s,m)
    local tex=atlas(s.level)
    local function text(label,value,y)
        ui:RenderText('title',label,x1,y,.65,Color(a,181,224,250),'left','vcenter')
        ui:RenderText('title',tostring(value),x2,y,.65,Color(a,246,237,244),'right','vcenter')
    end
    local old=s.level==35
    local anim=math.floor(stage.current_stage.timer/6)%7*70
    local step=math.min(23,(x2-x1)/10)
    local size=math.min(28,step*1.25)
    local white=Color(a,255,255,255)
    local function stock(count,y,life)
        local full,parts=math.floor(math.max(0,count)/5),math.max(0,count)%5
        local row=life and 70 or 140
        local tint=life and Color(a,255,153,255) or Color(a,0,230,102)
        for i=0,full-1 do
            if old then draw(tex,x1+i*step,y,size,size,82,1,16,18,tint)
            else draw(tex,x1+i*step,y,size,size,anim,row,70,70,white) end
        end
        if parts==0 then return end
        local x=x1+full*step
        if old then draw(tex,x,y,size,size,(parts-1)*20+2,1,16,18,white)
        else
            local offset=offsets[parts]
            draw(tex,x,y,size,size,anim,0,70,70,Color(a*.4,255,255,255))
            draw(tex,x,y-size*offset/70,size,size*(70-offset)/70,anim,row+offset,70,70-offset,white)
            draw(tex,x,y-size*.1,size,size,(parts-1)*70,210,70,70,white)
        end
    end
    text('机体',m.name,top)
    text('分数',('%010d'):format(lstg.var.score),top-23)
    text('残机',math.max(0,math.floor(s.life/5)),top-47)
    stock(s.life,top-56,true)
    text('Bomb',math.floor(s.bombs/5),top-91)
    stock(s.bombs,top-100,false)
    if old then text('火力',s.power..' / 400',top-143) end
end
return H
