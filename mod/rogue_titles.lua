-- 随机模式的阶段提示与卡名共用屏幕坐标，不受世界相机和竖屏场地裁切影响。
local T={STAGE_IN=6,STAGE_HOLD=18,STAGE_OUT=48,NAME_IN=6,NAME_HOLD=24,NAME_MOVE=30}
T.STAGE_DURATION=T.STAGE_IN+T.STAGE_HOLD+T.STAGE_OUT
local function clamp(v) return math.max(0,math.min(1,v)) end
local function units(text)
    local n=0
    for char in text:gmatch('[%z\1-\127\194-\244][\128-\191]*') do n=n+(#char>1 and 1 or .5) end
    return n
end
local function textWidth(text)
    if AndroidPlatform then return FindResFont('title'):calcSize(text).x*.5 end
    if CalcTextSize then return (CalcTextSize('title',text)) end
    return units(text)*16
end
local function canvas(draw)
    local previous,scale=lstg.viewmode,GetImageScale and GetImageScale()
    SetViewMode('ui')
    SetRenderRect(0,screen.width,0,screen.height,0,screen.width,0,screen.height)
    draw()
    if previous then SetViewMode(previous) end
    if scale then SetImageScale(scale) end
end
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
end
function T.frame(run)
    local a=run.card_title
    if a and not run.stage_banner and not run.preparing then a.age=a.age+1 end
end
function T.nameLayout(run)
    local a=run.card_title
    if not a or run.stage_banner or run.preparing or run.finished then return end
    local w=lstg.world
    local width=screen.width-48
    local cornerWidth=w.scrr-w.scrl-24
    local height=math.min(screen.height-80,w.scrt-w.scrb-80)
    local layout=a.layout
    if not layout or layout.width~=width or layout.height~=height or layout.cornerWidth~=cornerWidth then
        local groups,count,widest={},0,1
        for _,name in ipairs(a.names) do
            local text=name:gsub('[\r\n]+',' ')
            local length=textWidth(text)
            groups[#groups+1]={{text=text,width=length}};count=count+1
            widest=math.max(widest,length)
        end
        local size=math.min(3.2,width/widest,height/math.max(1,count*22+(#groups-1)*10))
        layout={groups=groups,count=count,size=size,small=math.min(.75,cornerWidth/widest),
            width=width,height=height,cornerWidth=cornerWidth};a.layout=layout
    end
    local groups,count,size=layout.groups,layout.count,layout.size
    local p=clamp((a.age-T.NAME_IN-T.NAME_HOLD)/T.NAME_MOVE)
    local move=p*p*(3-2*p)
    local small=layout.small
    local current=size+(small-size)*move
    local y=screen.height/2+(count-1)*size*22/2+(#groups-1)*size*5
    local right,top=w.scrr-12,w.scrt-68
    local rows={}
    for _,group in ipairs(groups) do
        for _,line in ipairs(group) do
            local x=screen.width/2+line.width*size/2
            rows[#rows+1]={text=line.text,x=x+(right-x)*move,y=y+(top-y)*move,
                size=current,alpha=255*clamp(a.age/T.NAME_IN)}
            y=y-size*22;top=top-small*22
        end
        y=y-size*10;top=top-10
    end
    return rows
end
function T.render(run)
    local rows=T.nameLayout(run)
    if not rows then return end
    canvas(function()
        for _,p in ipairs(rows) do
            ui:RenderText('title',p.text,p.x,p.y,p.size,Color(p.alpha,255,255,255),'right','vcenter')
        end
    end)
end
return T
