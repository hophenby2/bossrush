-- 原 Special、复活与掉落共用题库和实体：中玉横线、垂直分隔弹、随弹下降的文字。
local Q={TIME=500,FALL=460,TOP=330,CHOICE_Y=282,QUESTION_Y=358,DEPTH=96,STEP=12}
Q.questions={
    {"已知lg x+lg y=2,则x+y的最小值为？", "20", "2", "40", "-20"},
    {"已知(x-3)²+(y-4)²=9,则x²+y²的最大值为？", "64", "2", "4", "32"},
    {"已知z=2-i,则5/z为？", "2+i", "(10+5i)/3", "2.5+5i", "2-i"},
    {"已知tanx=3,则(sin2x+cos2x+1)/2=?", "2/5", "6/5", "5/6", "1/5"},
    {"已知y=f(x)的图像在点M(0,f(0))处的切线方程为y=-2x,\n则f(0)+f'(0)=?", "-2", "0", "2", "1"},
    {"已知向量AB=(3,8),A(-1,5),则B的坐标为？", "(2,13)", "(4,3)", "(4,13)", "(2,3)"},
    {"|lgx|=2的两个根的等比中项为？", "±1", "±100", "±10", "±1000"},
    {"已知向量a,b满足条件|a|=8,|b|=3,a·b=12,a与b的夹角为？", "60°", "30°", "45°", "120°"},
}
function Q.shuffle(count,gen)
    local input,output={},{}
    for i=1,count do input[i]=i end
    for i=1,count do output[i]=table.remove(input,gen:Int(1,#input)) end
    return output
end
function Q.new(index,gen)
    local row=assert(Q.questions[index]);local order=Q.shuffle(4,gen)
    local choices={};for i=1,4 do choices[order[i]]=row[i+1] end
    return {index=index,text=row[1],choices=choices,correct=order[1],age=0,choice=1}
end
function Q.answer(x,count)
    count=count or 4
    return math.max(1,math.min(count,1+math.floor((x+192)/(384/count))))
end
function Q.fall(n) return n<0.5 and n*1.3 or -1.2*n*n+2.5*n-0.3 end
function Q.offset(age,duration) return Q.FALL*Q.fall(math.max(0,math.min(1,age/(duration or Q.TIME)))) end
function Q.top(age,duration) return Q.TOP-Q.offset(age,duration) end
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
local Question,Choice
local function descend(o,manual)
    o.bound=false;o.colli=false;o.layer=0;o.alpha=1
    if manual then o.group=GROUP.GHOST;return end
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
            o.x=-192+(pos-0.5)*384/count;o.y=Q.CHOICE_Y;o.pos=pos;o.text=text;descend(o,manual)
        end,
        frame=task.Do,
        render=function(o)
            local previous=lstg.viewmode;SetViewMode('world')
            if type(o.text)=='string' then
                ui:RenderText('title',({'A','B','C','D'})[o.pos]..'. '..o.text,o.x,o.y,0.85,Color(o.alpha*255,255,255,255),'centerpoint')
            else
                for i,line in ipairs(o.text) do
                    local r,g,b=255,115,120;if line.color=='blue' then r,g,b=110,190,255 end
                    ui:RenderText('title',line.text,o.x,o.y+(#o.text+1-2*i)*12,0.85,Color(o.alpha*255,r,g,b),'centerpoint')
                end
            end
            if previous then SetViewMode(previous) end
        end,
    },true)
end
function Q.wall(x,y,manual)
    local o=NewObject(bullet)
    bullet.init(o,ball_mid,2,false,false)
    o.fogtime=0;o.x=x;o.y=y;o.a=o.a*1.5;o.b=o.b*1.5;o.bound=false
    if manual then
        -- 选项以扫掠接触结算，不让复活者再被选项弹击杀；仍使用原弹体与贴图。
        o.class=bullet;o.group=GROUP.GHOST;o.colli=false;o._no_gray=true;o.rank_speed=false
    else
        task.New(o,function() task.MoveToEx(0,-Q.FALL,Q.TIME,Q.fall);o.bound=true end)
    end
    return o
end
function Q.spawn(text,choices,manual)
    classes()
    local board={walls={},labels={}}
    if text then board.question=New(Question,text,manual) end
    for i,choice in ipairs(choices) do board.labels[i]=New(Choice,i,choice,#choices,manual) end
    for x=-16,16 do board.walls[#board.walls+1]=Q.wall(x*Q.STEP,Q.TOP,manual) end
    for i=1,#choices-1 do
        for y=1,8 do board.walls[#board.walls+1]=Q.wall(-192+i*384/#choices,Q.TOP-y*Q.STEP,manual) end
    end
    return board
end
local selections={}
function Q.setSelectionVisible(key,visible)
    local cached=selections[key];if not cached or cached.visible==visible then return end
    cached.visible=visible
    local board=cached.board
    local function show(o) if o and IsValid(o) then o.hide=not visible end end
    show(board.question);for _,o in ipairs(board.labels) do show(o) end
    for _,o in ipairs(board.walls) do show(o) end
end
function Q.selection(key,state,text,choices,alpha)
    local cached=selections[key]
    if not cached or cached.state~=state or not IsValid(cached.board.walls[1]) then
        Q.clearSelection(key)
        -- bullet.init 的雾化偏移会取随机数；选项演出使用独立源，保持战斗弹幕随机序列。
        local old=ran;ran=Rand();ran:Seed(1)
        local ok,board=pcall(Q.spawn,text,choices,true);ran=old
        if not ok then error(board,0) end
        cached={state=state,board=board};selections[key]=cached
    end
    local board=cached.board;local offset=Q.offset(state.age,state.duration);alpha=alpha or 1
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
    remove(board.question);for _,o in ipairs(board.labels) do remove(o) end
end
function Q.move(p,key)
    local w=lstg.world or {pl=-192,pr=192,pb=-224,pt=224}
    local dx=(key.right and 1 or 0)-(key.left and 1 or 0);local dy=(key.up and 1 or 0)-(key.down and 1 or 0)
    local speed=key.slow and (p.lspeed or 2) or (p.hspeed or 4)
    if dx*dy~=0 then speed=speed*0.70710678118655 end
    local x,y=p.x,p.y
    p.x=math.max(w.pl+8,math.min(w.pr-8,p.x+dx*speed));p.y=math.max(w.pb+16,math.min(w.pt-32,p.y+dy*speed))
    if p.grazer and IsValid(p.grazer) then p.grazer.x=p.x;p.grazer.y=p.y end
    if p.sp then for _,v in ipairs(p.sp) do v[1]=v[1]+p.x-x;v[2]=v[2]+p.y-y end end
    p.supportx=(p.supportx or x)+p.x-x;p.supporty=(p.supporty or y)+p.y-y
end
function Q.contact(previous,p,oldAge,age,count,duration)
    local radius=6+math.max(p.A or 0,p.B or 0,3)
    local a,b=previous.y-Q.top(oldAge,duration),p.y-Q.top(age,duration)
    if math.min(a,b)<=radius and math.max(a,b)>=-radius then
        local t=b~=a and math.max(0,math.min(1,(-radius-a)/(b-a))) or 1
        return Q.answer(previous.x+(p.x-previous.x)*t,count)
    end
    if age>=(duration or Q.TIME) then return Q.answer(p.x,count) end
end
GameQuiz=Q
return Q
