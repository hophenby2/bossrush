-- 原 Special 与掉落共用实体：中玉横线、垂直分隔弹、随弹下降的文字。
local Q={TIME=500,FALL=460,TOP=330,CHOICE_Y=282,QUESTION_Y=358,DEPTH=96,STEP=12}
function Q.answer(x,count)
    count=count or 4
    return math.max(1,math.min(count,1+math.floor((x+192)/(384/count))))
end
function Q.fall(n) return n<0.5 and n*1.3 or -1.2*n*n+2.5*n-0.3 end
function Q.offset(age,duration,linear)
    local n=math.max(0,math.min(1,age/(duration or Q.TIME)))
    return Q.FALL*(linear and n or Q.fall(n))
end
function Q.top(age,duration,linear) return Q.TOP-Q.offset(age,duration,linear) end
function Q.wrap(text,width)
    local lines,row,length={},'',0
    for char in text:gmatch('[%z\1-\127\194-\244][\128-\191]*') do
        local size=#char>1 and 1 or 0.5
        if char=='\n' then lines[#lines+1]=row;row='';length=0
        else
            if length+size>width then lines[#lines+1]=row;row='';length=0 end
            row=row..char;length=length+size
        end
    end
    if row~='' then lines[#lines+1]=row end
    return lines
end
-- 实例不查类表上的自定义方法；所有操作均由模块函数显式传入对象。
local Question,Choice,Mask
local maskColors={red={255,40,55},blue={35,110,255},green={35,210,85}}
local function descend(o,manual)
    o.bound=false;o.colli=false;o.layer=0;o.alpha=1
    if manual then o.group=GROUP.GHOST;o._rogue_host_overlay=true;return end
    task.New(o,function() task.MoveToEx(0,-Q.FALL,Q.TIME,Q.fall);task.SmoothSetValueTo('alpha',0,60,0);Del(o) end)
end
local function classes()
    if Question then return end
    Question=Class(object,{
        init=function(o,text,manual)
            o.x=0;o.y=Q.QUESTION_Y;o.text=text;descend(o,manual)
        end,
        frame=task.Do,
        render=function(o)
            local previous=lstg.viewmode;SetViewMode('world')
            ui:RenderText('title',o.text,o.x,o.y,0.9,Color(o.alpha*255,255,255,255),'centerpoint')
            if previous then SetViewMode(previous) end
        end,
    },true)
    Choice=Class(object,{
        init=function(o,pos,text,count,manual)
            o.x=-192+(pos-0.5)*384/count;o.y=Q.CHOICE_Y;o.pos=pos;o.text=text;o.count=count;descend(o,manual)
        end,
        frame=task.Do,
        render=function(o)
            local previous=lstg.viewmode;SetViewMode('world')
            if type(o.text)=='string' then
                ui:RenderText('title',({'A','B','C','D'})[o.pos]..'. '..o.text,o.x,o.y,0.85,Color(o.alpha*255,255,255,255),'centerpoint')
            else
                for i,line in ipairs(o.text) do
                    local rgb=(GameDrops and GameDrops.palette and GameDrops.palette[line.color]) or maskColors[line.color] or {255,115,120}
                    local r,g,b=rgb[1],rgb[2],rgb[3]
                    local scale=o.count==3 and 0.7 or 0.85
                    if o.count==3 and line.color=='green' and i==2 then scale=0.6 end
                    scale=line.scale or scale
                    ui:RenderText('title',line.text,o.x,o.y+(#o.text+1-2*i)*12,scale,Color(o.alpha*255,r,g,b),'centerpoint')
                end
            end
            if previous then SetViewMode(previous) end
        end,
    },true)
    Mask=Class(object,{
        init=function(o,colors) descend(o,true);o.layer=-0.1;o.y=Q.TOP;o.colors=colors end,
        render=function(o)
            local previous=lstg.viewmode;SetViewMode('world')
            for i,color in ipairs(o.colors) do
                SetImageState('white','',Color(o.alpha*65,color[1],color[2],color[3]))
                RenderRect('white',-192+(i-1)*384/#o.colors,-192+i*384/#o.colors,o.y-Q.DEPTH,o.y)
            end
            if previous then SetViewMode(previous) end
        end,
    },true)
end
function Q.wall(x,y,manual,index)
    local o=NewObject(bullet)
    bullet.init(o,ball_mid,index or 2,false,false)
    o.fogtime=0;o.x=x;o.y=y;o.a=o.a*1.5;o.b=o.b*1.5;o.bound=false
    if manual then
        -- 选项以扫掠接触结算，不让复活者再被选项弹击杀；仍使用原弹体与贴图。
        o.class=bullet;o.group=GROUP.GHOST;o.colli=false;o._no_gray=true;o.rank_speed=false
        o._rogue_host_overlay=true
    else
        task.New(o,function() task.MoveToEx(0,-Q.FALL,Q.TIME,Q.fall);o.bound=true end)
    end
    return o
end
function Q.spawn(text,choices,manual)
    classes()
    local board={walls={},labels={}}
    local function optionColor(index)
        local lines=choices[index]
        local name=type(lines)=='table' and lines[1] and lines[1].color
        local palette=GameDrops and GameDrops.palette
        return manual and palette and palette[name] and palette[name].bullet or nil
    end
    if text then board.question=New(Question,text,manual) end
    for i,choice in ipairs(choices) do board.labels[i]=New(Choice,i,choice,#choices,manual) end
    for x=-16,16 do board.walls[#board.walls+1]=Q.wall(x*Q.STEP,Q.TOP,manual,optionColor(Q.answer(x*Q.STEP,#choices))) end
    for i=1,#choices-1 do
        for y=1,8 do board.walls[#board.walls+1]=Q.wall(-192+i*384/#choices,Q.TOP-y*Q.STEP,manual,optionColor(i)) end
    end
    return board
end
local selections={}
function Q.setSelectionVisible(key,visible)
    local cached=selections[key];if not cached or cached.visible==visible then return end
    cached.visible=visible
    local board=cached.board
    local function show(o) if o and IsValid(o) then o.hide=not visible end end
    show(board.mask);show(board.question);for _,o in ipairs(board.labels) do show(o) end
    for _,o in ipairs(board.walls) do show(o) end
end
local function boardValid(board)
    local function alive(o) return o and IsValid(o) and o.status=='normal' end
    if board.question and not alive(board.question) then return false end
    if board.mask and not alive(board.mask) then return false end
    for _,o in ipairs(board.labels) do if not alive(o) then return false end end
    for _,o in ipairs(board.walls) do if not alive(o) then return false end end
    return true
end
function Q.selection(key,state,text,choices,alpha)
    local cached=selections[key]
    -- 文字与弹墙是不同对象，不能仅凭第一颗弹还在就复用已损坏的选项。
    if not cached or cached.state~=state or not boardValid(cached.board) then
        Q.clearSelection(key)
        -- bullet.init 的雾化偏移会取随机数；选项演出使用独立源，保持战斗弹幕随机序列。
        local old=ran;ran=Rand();ran:Seed(1)
        local ok,board=pcall(Q.spawn,text,choices,true);ran=old
        if not ok then error(board,0) end
        cached={state=state,board=board};selections[key]=cached
    end
    local board=cached.board;local offset=Q.offset(state.age,state.duration,state.linear);alpha=alpha or 1
    if state.colorMask then
        if not board.mask or not IsValid(board.mask) then
            local colors={}
            local palette=GameDrops and GameDrops.palette or maskColors
            for i,lines in ipairs(choices) do
                local name=type(lines)=='table' and lines[1] and lines[1].color
                colors[i]=palette[name] or palette[i==1 and 'red' or 'blue']
            end
            board.mask=New(Mask,colors)
        end
        board.mask.y=Q.TOP-offset;board.mask.alpha=alpha
    end
    if board.question then board.question.y=Q.QUESTION_Y-offset;board.question.alpha=alpha end
    for _,o in ipairs(board.labels) do o.y=Q.CHOICE_Y-offset;o.alpha=alpha end
    for i,o in ipairs(board.walls) do
        o.y=Q.TOP-(i<=33 and 0 or ((i-34)%8+1)*Q.STEP)-offset;o._a=alpha*255
    end
    Q.setSelectionVisible(key,true)
    return board
end
function Q.clearSelection(key,fading)
    local cached=selections[key];if not cached then return end
    local board=cached.board;selections[key]=nil
    for _,o in ipairs(board.walls) do if IsValid(o) then if fading then Del(o) else object.RawDel(o) end end end
    -- 结束时一起移除文字，避免与下一组下落选项重叠。
    local function remove(o) if o and IsValid(o) then object.RawDel(o) end end
    remove(board.mask);remove(board.question);for _,o in ipairs(board.labels) do remove(o) end
end
function Q.contact(previous,p,oldAge,age,count,duration,linear)
    local radius=6+math.max(p.A or 0,p.B or 0,3)
    local a,b=previous.y-Q.top(oldAge,duration,linear),p.y-Q.top(age,duration,linear)
    if math.min(a,b)<=radius and math.max(a,b)>=-radius then
        local t=b~=a and math.max(0,math.min(1,(-radius-a)/(b-a))) or 1
        return Q.answer(previous.x+(p.x-previous.x)*t,count)
    end
    if age>=(duration or Q.TIME) then return Q.answer(p.x,count) end
end
GameQuiz=Q
return Q
