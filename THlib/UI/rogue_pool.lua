-- 单人随机十战的准备选项；键盘、鼠标与触屏点击共用同一份筛选状态。
local U={}
local options={
    {group='stages',key='TH31',text='永夜抄 · TH31',x=505,y=388},
    {group='stages',key='TH32',text='红魔乡 · TH32',x=720,y=388},
    {group='stages',key='TH34',text='妖妖梦 · TH34',x=505,y=350},
    {group='stages',key='TH35',text='风神录 · TH35',x=720,y=350},
    {group='difficulties',key='lunatic',text='Lunatic',x=505,y=279},
    {group='difficulties',key='extra',text='Extra',x=720,y=279},
    {group='encounters',key='boss',text='Boss',x=505,y=208},
    {group='encounters',key='road',text='道中',x=720,y=208},
}
local groupNames={stages='关卡',difficulties='难度',encounters='Boss / 道中'}
local function over(mouse,entry)
    return sp.math.PointBoundCheck(mouse.x,mouse.y,entry.x,entry.x+200,entry.y-16,entry.y+16)
end
local function refresh(o)
    o.pool_status=RogueTen.poolStatus(o.pool_options)
end
local function notice(o,text)
    o.pool_notice,o.pool_notice_time=text,180
    PlaySound('invalid')
end
function U.fresh(o,mode)
    o.pool_options=nil;o.pool_status=nil;o.pool_notice=nil;o.pool_notice_time=0
    o.pool_focus=0
    if mode=='roguelike' then
        o.pool_options=RogueTen.copyFilters(scoredata.rogue10_filters)
        o.simple_title='随机十战 · 准备'
        refresh(o)
    end
end
function U.toggle(o,index)
    local entry=options[index]
    if not entry then return end
    local group=o.pool_options[entry.group]
    if group[entry.key] then
        local another=false
        for key,enabled in pairs(group) do if key~=entry.key and enabled then another=true;break end end
        if not another then notice(o,groupNames[entry.group]..'至少保留一项');return end
    end
    group[entry.key]=not group[entry.key]
    scoredata.rogue10_filters=RogueTen.copyFilters(o.pool_options)
    o.pool_notice=nil;o.pool_notice_time=0
    refresh(o)
    PlaySound('ok00')
end
function U.ready(o)
    if not o.pool_options then return true end
    refresh(o)
    if o.pool_status.valid then return true end
    notice(o,o.pool_status.message)
    return false
end
function U.frame(o)
    local mouse=ext.mouse
    if o.pool_notice_time>0 then o.pool_notice_time=o.pool_notice_time-1 end
    o.maxcolindex=o.pool_focus==9 and 1 or 0
    -- Enter始终开始；射击键在选项上切换勾选，在自机/开始按钮上开始。
    if GetLastKey()==KEY.ENTER then o:yes();return end
    if menu:keyYes() or GetLastKey()==setting.keys.shoot then
        if o.pool_focus>=1 and o.pool_focus<=#options then U.toggle(o,o.pool_focus) else o:yes() end
        return
    end
    if menu:keyNo() then o:no();return end
    if menu:keyUp() then o.pool_focus=(o.pool_focus-1)%10;PlaySound('select00') end
    if menu:keyDown() then o.pool_focus=(o.pool_focus+1)%10;PlaySound('select00') end
    if menu:keyLeft() then o:addpos1(-1) end
    if menu:keyRight() then o:addpos1(1) end
    for index,entry in ipairs(options) do
        if over(mouse,entry) and mouse:isDown(1) then
            o.pool_focus=index;U.toggle(o,index);return
        end
    end
    local r=155+sin(o.timer*3)*2
    if Dist(mouse.x,mouse.y,240,250)<r then
        if mouse._wheel~=0 then o.pool_focus=0;o:addpos1(-sign(mouse._wheel)) end
        if mouse:isDown(1) then
            o.pool_focus=0
            local a=(Angle(mouse.x,mouse.y,240,250)-o.orot)%360
            o:addpos1((a>=225 and a<315) and 0 or (a>=135 and a<225) and 1 or (a>=45 and a<135) and 2 or -1)
        end
    elseif sp.math.PointBoundCheck(mouse.x,mouse.y,420,540,30,60) then
        o.maxcolindex=1
        if mouse:isDown(1) then o.pool_focus=9;o:yes() end
    elseif Dist(mouse.x,mouse.y,240+r+45,250)<30 then
        if mouse:isDown(1) then o.pool_focus=0;o:addpos1(1) end
    elseif Dist(mouse.x,mouse.y,240-r-45,250)<30 then
        if mouse:isDown(1) then o.pool_focus=0;o:addpos1(-1) end
    end
end
function U.render(o)
    local alpha=o.alpha
    local white=Color(alpha*255,225,240,246)
    local muted=Color(alpha*255,165,188,200)
    local accent=Color(alpha*255,189,252,201)
    ui:RenderText('title','抽取范围',715,460,1.05,white,'centerpoint')
    for _,heading in ipairs({{'关卡',422},{'难度（至少一项）',313},{'战斗（至少一项）',242}}) do
        ui:RenderText('title',heading[1],505,heading[2],0.72,muted,'left','vcenter')
    end
    for index,entry in ipairs(options) do
        local checked=o.pool_options[entry.group][entry.key]
        local focused=o.pool_focus==index
        local hovered=over(ext.mouse,entry)
        SetImageState('white','',Color(alpha*(focused and 155 or hovered and 110 or 75),35,74,91))
        RenderRect('white',entry.x,entry.x+200,entry.y-16,entry.y+16)
        if focused then
            SetImageState('white','',accent)
            misc.RenderOutLine('white',entry.x,entry.x+200,entry.y-16,entry.y+16,0,1)
        end
        ui:RenderText('title',checked and '√' or '□',entry.x+14,entry.y,0.72,checked and accent or muted,'centerpoint')
        ui:RenderText('title',entry.text,entry.x+31,entry.y,0.65,checked and white or muted,'left','vcenter')
    end
    local state=o.pool_status
    local valid=state and state.valid
    local statusColor=valid and accent or Color(alpha*255,255,170,125)
    ui:RenderText('title',string.format('候选 %d 张 · 十张不重复',state and state.count or 0),715,159,0.78,statusColor,'centerpoint')
    local message=o.pool_notice_time>0 and o.pool_notice or (not valid and state and state.message)
    ui:RenderText('title',message or '仅从已勾选的关卡、难度和战斗类型抽取',715,130,0.6,message and Color(alpha*255,255,170,125) or muted,'centerpoint')
    ui:RenderText('title',('↑↓选择 · %s勾选 · Enter开始'):format(o.keyname[setting.keys.shoot] or 'Z'),715,100,0.66,muted,'centerpoint')
    ui:RenderText('title','← → 选择自机',240,80,0.7,o.pool_focus==0 and accent or muted,'centerpoint')
end
return U
