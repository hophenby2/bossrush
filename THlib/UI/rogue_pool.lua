-- 选关界面右侧的高级选项默认折叠；隐藏时不参与键盘焦点和鼠标命中。
local U={}
local options={
    {group='stages',key='TH31',text='永夜抄 · TH31',x=505,y=366},
    {group='stages',key='TH32',text='红魔乡 · TH32',x=720,y=366},
    {group='stages',key='TH34',text='妖妖梦 · TH34',x=505,y=334},
    {group='stages',key='TH35',text='风神录 · TH35',x=720,y=334},
    {group='difficulties',key='lunatic',text='Lunatic',x=505,y=270,width=133},
    {group='difficulties',key='extra',text='Extra/Phantasm',x=646,y=270,width=133},
    {group='difficulties',key='lastword',text='Last Word',x=787,y=270,width=133},
    {group='encounters',key='boss',text='Boss',x=505,y=208},
    {group='encounters',key='road',text='道中',x=720,y=208},
    {group='cards',key='survival',text='时符（耐久卡）',x=505,y=110,optional=true},
    {group='cards',key='nonspell',text='非符',x=505,y=146,optional=true},
    {group='cards',key='spell',text='符卡',x=720,y=146,optional=true},
}
local groupNames={stages='关卡',difficulties='难度',encounters='Boss / 道中'}
U.options=options
local function over(mouse,entry)
    return sp.math.PointBoundCheck(mouse.x,mouse.y,entry.x,entry.x+(entry.width or 200),entry.y-14,entry.y+14)
end
local function refresh(o) o.pool_status=RogueTen.poolStatus(o.pool_options) end
local function notice(o,message)
    o.pool_notice,o.pool_notice_time=message,180;PlaySound('invalid')
end
local function startIndex(o) return o.pool_expanded and #options+2 or 2 end
function U.fresh(o,mode)
    o.pool_options=nil;o.pool_status=nil;o.pool_notice=nil;o.pool_notice_time=0
    o.pool_focus=0;o.pool_expanded=false
    if mode=='roguelike' then
        o.pool_options=RogueTen.savedFilters()
        o.simple_title='roguelike模式 · 准备';refresh(o)
    end
end
function U.expand(o)
    o.pool_expanded=not o.pool_expanded;o.pool_focus=1;PlaySound('select00')
end
function U.toggle(o,index)
    local entry=options[index];if not entry then return end
    local group=o.pool_options[entry.group]
    if group[entry.key] and not entry.optional then
        local another=false
        for key,enabled in pairs(group) do if key~=entry.key and enabled then another=true;break end end
        if not another then notice(o,groupNames[entry.group]..'至少保留一项');return end
    end
    group[entry.key]=not group[entry.key]
    scoredata.rogue10_filters=RogueTen.copyFilters(o.pool_options)
    scoredata.rogue10_filters_version=RogueTen.POOL_VERSION
    o.pool_notice=nil;o.pool_notice_time=0;refresh(o);PlaySound('ok00')
end
function U.ready(o)
    if not o.pool_options then return true end
    refresh(o)
    if o.pool_status.valid then return true end
    notice(o,o.pool_status.message);return false
end
function U.frame(o)
    local mouse=ext.mouse
    if o.pool_notice_time>0 then o.pool_notice_time=o.pool_notice_time-1 end
    o.maxcolindex=o.pool_focus==startIndex(o) and 1 or 0
    if GetLastKey()==KEY.ENTER then o:yes();return end
    if menu:keyYes() or GetLastKey()==setting.keys.shoot then
        if o.pool_focus==1 then U.expand(o)
        elseif o.pool_expanded and o.pool_focus>=2 and o.pool_focus<=#options+1 then U.toggle(o,o.pool_focus-1)
        else o:yes() end
        return
    end
    if menu:keyNo() then if o.pool_expanded then U.expand(o) else o:no() end;return end
    local focusCount=startIndex(o)+1
    if menu:keyUp() then o.pool_focus=(o.pool_focus-1)%focusCount;PlaySound('select00') end
    if menu:keyDown() then o.pool_focus=(o.pool_focus+1)%focusCount;PlaySound('select00') end
    if menu:keyLeft() then o:addpos1(-1) end
    if menu:keyRight() then o:addpos1(1) end
    if sp.math.PointBoundCheck(mouse.x,mouse.y,505,920,423,457) and mouse:isDown(1) then U.expand(o);return end
    if o.pool_expanded then
        for index,entry in ipairs(options) do
            if over(mouse,entry) and mouse:isDown(1) then o.pool_focus=index+1;U.toggle(o,index);return end
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
        if mouse:isDown(1) then o.pool_focus=startIndex(o);o:yes() end
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
    SetImageState('white','',Color(alpha*(o.pool_focus==1 and 155 or 75),35,74,91))
    RenderRect('white',505,920,423,457)
    ui:RenderText('title',(o.pool_expanded and '− ' or '+ ')..'高级选项',715,440,.9,white,'centerpoint')
    if o.pool_expanded then
        for _,heading in ipairs({{'关卡',400},{'难度',302},{'战斗',240},{'卡片类型',178}}) do
            ui:RenderText('title',heading[1],505,heading[2],.65,muted,'left','vcenter')
        end
        for index,entry in ipairs(options) do
            local checked=o.pool_options[entry.group][entry.key]
            local focused=o.pool_focus==index+1
            local hovered=over(ext.mouse,entry)
            local right=entry.x+(entry.width or 200)
            SetImageState('white','',Color(alpha*(focused and 155 or hovered and 110 or 75),35,74,91))
            RenderRect('white',entry.x,right,entry.y-14,entry.y+14)
            if focused then SetImageState('white','',accent);misc.RenderOutLine('white',entry.x,right,entry.y-14,entry.y+14,0,1) end
            ui:RenderText('title',checked and '√' or '□',entry.x+14,entry.y,.72,checked and accent or muted,'centerpoint')
            ui:RenderText('title',entry.text,entry.x+31,entry.y,.65,checked and white or muted,'left','vcenter')
        end
    end
    local state=o.pool_status;local valid=state and state.valid
    local message=o.pool_notice_time>0 and o.pool_notice or (not valid and state and state.message)
    if message then
        ui:RenderText('title',message,715,o.pool_expanded and 77 or 125,.7,Color(alpha*255,255,170,125),'centerpoint')
    end
    ui:RenderText('title','← → 选择自机',240,80,.7,o.pool_focus==0 and accent or muted,'centerpoint')
end
return U
