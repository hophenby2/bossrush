-- 原 Laser_move_line：固定步长伸展、预警增宽及收束，独立于普通弹的移动速度。
local F={}
local function direction(s)
    local parent=s.parent
    return s.direction+(parent and parent.rotation-s.lineParentRotation or 0)
end
F.direction=direction

function F.init(s,e)
    local sizeEvents,delayEvent=false,false
    for _,event in ipairs(e.events) do
        sizeEvents=sizeEvents or event[9]==22 or event[9]==23
        delayEvent=delayEvent or event[9]==18
    end
    -- Basic / Basic_zi 按发射器事件决定是否借用子弹宽高和朝向字段。
    local length=sizeEvents and e.a6_8 or e.a54_2
    s.length=math.max(4,math.floor(length/4)*4)*.01
    s.width=sizeEvents and e.a6_7 or e.a54_3
    local delay=delayEvent and e.a8_7 or e.a54_5
    s.lineDelay=delay<0 and math.ceil(delay) or math.floor(delay)
    if s.laserStyle<0 or s.laserStyle>3 then s.laserStyle=0 end
    s.lineWidth,s.lineLength,s.lineGenerated=.1,0,0 -- laser_line.prefab 的初始缩放。
    s.lineWidthRate=s.width/100
    s.lineRadius=s.width*(({[2]=.03,[3]=.06})[s.laserStyle] or .05)
    s.lineGrowing,s.lineActive,s.lineGraze=true,false,0
    s.rotation=s.direction-90
end

function F.step(s)
    local advance=0
    if s.lineGrowing then
        advance=.28
        s.lineLength=s.lineLength+.07
        s.lineGenerated=s.lineGenerated+.07
        if s.lineGenerated>=s.length then s.lineGrowing=false end
    elseif s.lineLength<s.lineGenerated then
        -- 被自机消弹缩短后，原作每 tick 补回 .01 的纵向缩放。
        advance=.04;s.lineLength=s.lineLength+.01
    end
    local a=direction(s)
    s.x,s.y=s.x+advance*cos(a),s.y+advance*sin(a)
    s.rotation=a-90
    s.life=s.life-1
    if s.lineDelay==0 then
        s.lineWidth=s.lineWidth+s.lineWidthRate
        if s.lineWidth*2>=s.width then s.lineDelay=-1;s.lineActive=true end
    else s.lineDelay=s.lineDelay-1 end
    if s.life<0 then
        s.lineWidth=s.lineWidth-s.lineWidthRate
        if s.lineWidth*2<=s.width then
            s.lineActive=false
            if s.lineWidth<=s.lineWidthRate then s.alive=false end
        end
    end
end

-- 原判定是两端各内缩 .16 单位的线段距离，再加自机判定半径。
function F.distance(s,x,y,headOnly)
    local a=direction(s);local co,si=cos(a),sin(a)
    local ax,ay=(s.x-4.5-.16*co)*48,(s.y+4.8-.16*si)*48
    if headOnly then return math.sqrt((x-ax)^2+(y-ay)^2),ax,ay end
    local vx,vy=-(s.lineLength*4-.32)*48*co,-(s.lineLength*4-.32)*48*si
    local length=vx*vx+vy*vy
    local t=length>0 and math.max(0,math.min(1,((x-ax)*vx+(y-ay)*vy)/length)) or 0
    local px,py=ax+t*vx,ay+t*vy
    return math.sqrt((x-px)^2+(y-py)^2),px,py
end

function F.collide(s,b)
    if not s.lineActive then return end
    local graze=s.lineGraze==0
    local function check(p)
        if not p or not IsValid(p) or not s.collision then return end
        local d,x,y=F.distance(s,p.x,p.y)
        local radius=s.lineRadius*48
        if d<radius+p.A then p.class.colli(p,b) end
        if graze and p.grazer and IsValid(p.grazer) and d<radius+p.grazer.a then
            p.grazer.class.colli(p.grazer,b,true,x,y)
        end
    end
    if GameNet then GameNet.forEachPlayer(check) else check(player) end
    s.lineGraze=(graze and 5 or s.lineGraze)-1
end

function F.shrink(s)
    if s.lineLength<.04 then return false end
    s.lineLength=s.lineLength-.04
    local a=direction(s)
    s.x,s.y=s.x-.16*cos(a),s.y-.16*sin(a)
    return true
end

return F
