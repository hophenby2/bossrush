-- 随机模式的阶段提示与卡名共用屏幕坐标，不受世界相机和竖屏场地裁切影响。
local T={STAGE_IN=6,STAGE_HOLD=18,STAGE_OUT=48,NAME_IN=6,NAME_HOLD=24,NAME_MOVE=30}
T.STAGE_DURATION=T.STAGE_IN+T.STAGE_HOLD+T.STAGE_OUT
T.NAME_DURATION=T.NAME_IN+T.NAME_HOLD+T.NAME_MOVE
local function clamp(v) return math.max(0,math.min(1,v)) end
local function units(text)
    local n=0
    for char in text:gmatch('[%z\1-\127\194-\244][\128-\191]*') do n=n+(#char>1 and 1 or .5) end
    return n
end
local function textWidth(text,font)
    font=font or 'title'
    if AndroidPlatform then return FindResFont(font):calcSize(text).x*.5 end
    if CalcTextSize then return (CalcTextSize(font,text)) end
    return units(text)*16
end
T.textWidth=textWidth
local function canvas(draw)
    local previous,scale=lstg.viewmode,GetImageScale and GetImageScale()
    SetViewMode('ui')
    SetRenderRect(0,screen.width,0,screen.height,0,screen.width,0,screen.height)
    if scale then SetImageScale(1) end
    draw()
    if previous then SetViewMode(previous) end
    if scale then SetImageScale(scale) end
end
T.canvas=canvas
function T.stageLayout(a)
    a.width=a.width or textWidth(a.text)
    return {x=screen.width/2,y=screen.height/2,
        alpha=255*math.min(clamp(a.age/T.STAGE_IN),clamp((T.STAGE_DURATION-a.age)/T.STAGE_OUT)),
        size=math.min(3.2,(screen.width-48)/math.max(1,a.width))}
end
function T.stage(a)
    local p=T.stageLayout(a)
    local rgb=a.stage==6 and {255,75,85} or {255,255,255}
    canvas(function()
        ui:RenderText('title',a.text,p.x,p.y,p.size,Color(p.alpha,unpack(rgb)),'centerpoint')
    end)
end
function T.announce(run,first,second)
    local names={first.title}
    if second then names[2]=second.title end
    run.card_title={names=names,age=0}
    if GameHPScale and GameHPScale.announceTitle then GameHPScale.announceTitle(run) end
end
function T.frame(run)
    local a=run.card_title
    if a and not run.stage_banner and not run.preparing then a.age=a.age+1 end
    if RogueBossHUD then RogueBossHUD.updateHeaders(run,true) end
end
function T.headerLayout(slot)
    if AndroidPortrait and AndroidPortrait.enabled() then return AndroidPortrait.cardHeader(slot) end
    local w=lstg.world
    local right,y=w.scrr-12,w.scrt-1-((slot or 1)-1)*44
    -- 原生计时器放在卡名右侧，下方为同步落位的强化倍率留出一行。
    return {right=right,nameRight=right-84,nameWidth=w.scrr-w.scrl-108,y=y,timerY=y}
end
function T.flightLayout(text,age,x,y,small,widthLimit,initialSize,startY)
    local width=textWidth(text,'sc_menu')
    local size=math.min(initialSize or 3.2,(widthLimit or screen.width-48)/math.max(1,width))
    local p=clamp((age-T.NAME_IN-T.NAME_HOLD)/T.NAME_MOVE)
    local move=p*p*(3-2*p)
    local cx,cy=screen.width/2+width*size/2,startY or screen.height/2
    return {text=text,x=cx+(x-cx)*move,y=cy+(y-cy)*move,size=size+(small-size)*move,
        alpha=255*clamp(age/T.NAME_IN),vcenter=true,background=false}
end
function T.captionStartY(layout)
    return screen.height/2-(layout.count-1)*layout.size*11-(#layout.groups-1)*layout.size*5-layout.size*32
end
function T.nameLayout(run)
    local a=run.card_title
    if not a or run.stage_banner or run.preparing or run.finished then return end
    local w=lstg.world
    local width=screen.width-48
    local cornerWidth=w.scrr-w.scrl-24
    local header=T.headerLayout()
    cornerWidth=header.nameWidth
    local height=math.min(screen.height-80,w.scrt-w.scrb-80)
    local layout=a.layout
    if not layout or layout.width~=width or layout.height~=height or layout.cornerWidth~=cornerWidth then
        local groups,count,widest={},0,1
        for _,name in ipairs(a.names) do
            local text=name:gsub('[\r\n]+',' ')
            local length=textWidth(text,'sc_menu')
            groups[#groups+1]={{text=text,width=length}};count=count+1
            widest=math.max(widest,length)
        end
        local size=math.min(3.2,width/widest,height/math.max(1,count*22+(#groups-1)*10))
        layout={groups=groups,count=count,size=size,small=math.min(1,cornerWidth/widest),
            width=width,height=height,cornerWidth=cornerWidth};a.layout=layout
    end
    local groups,count,size=layout.groups,layout.count,layout.size
    local p=clamp((a.age-T.NAME_IN-T.NAME_HOLD)/T.NAME_MOVE)
    local move=p*p*(3-2*p)
    local small=layout.small
    local current=size+(small-size)*move
    local y=screen.height/2+(count-1)*size*22/2+(#groups-1)*size*5
    local rows={}
    for index,group in ipairs(groups) do
        local target=T.headerLayout(index)
        for _,line in ipairs(group) do
            local x=screen.width/2+line.width*size/2
            rows[#rows+1]={text=line.text,x=x+(target.nameRight-x)*move,y=y+(target.y-y)*move,
                size=current,alpha=255*clamp(a.age/T.NAME_IN),vcenter=true,background=false}
            y=y-size*22
        end
        y=y-size*10
    end
    return rows
end
function T.render(run)
    local rows=T.nameLayout(run)
    if run.preparing or run.finished then return end
    canvas(function()
        local settled=rows and run.card_title.age>=T.NAME_DURATION
        if rows and not settled then
            for _,p in ipairs(rows) do boss.sc_name.renderLabel(p.text,p) end
        end
        if RogueBossHUD then RogueBossHUD.renderHeaders(run,rows or {},settled,T.headerLayout) end
    end)
end
return T
