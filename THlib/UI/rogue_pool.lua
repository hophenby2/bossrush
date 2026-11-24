-- 选关界面右侧的高级选项默认折叠；隐藏时不参与键盘焦点和鼠标命中。
local U={}
local options={}
local stagedOptions={}
local works={{'TH31','永夜抄'},{'TH32','红魔乡'},{'TH34','妖妖梦'},{'TH35','风神录'},
    {'TH37','幕华祭春雪'},{'TH38','雪莲华'},{'TH39','幕华祭永夜'},{'TH40','夏夜祭'},
    {'TH41','祈华梦'},{'TH42','Like Dreamer'},{'TH43','栖霞园'}}
for i,work in ipairs(works) do
    options[#options+1]={group='stages',key=work[1],text=work[2],x=505+((i-1)%3)*141,
        y=376-math.floor((i-1)/3)*30,width=133}
end
for _,work in ipairs(works) do
    if work[1]~='TH42' then
        local i=#stagedOptions
        stagedOptions[#stagedOptions+1]={group='stages',key=work[1],text=work[2],x=505+(i%3)*141,
            y=376-math.floor(i/3)*30,width=133}
    end
end
for _,entry in ipairs({
    {group='difficulties',key='lunatic',text='Lunatic / NM',x=505,y=234,width=133},
    {group='difficulties',key='extra',text='Extra/Phantasm',x=646,y=234,width=133},
    {group='difficulties',key='lastword',text='Last Word',x=787,y=234,width=133},
    {group='encounters',key='boss',text='Boss',x=505,y=182},
    {group='encounters',key='road',text='道中',x=720,y=182},
    {group='cards',key='survival',text='时符（耐久卡）',x=505,y=98,optional=true},
    {group='cards',key='nonspell',text='非符',x=505,y=130,optional=true},
    {group='cards',key='spell',text='符卡',x=720,y=130,optional=true},
}) do options[#options+1]=entry end
local groupNames={stages='关卡',difficulties='难度',encounters='Boss / 道中'}
U.options=options
U.stagedOptions=stagedOptions
local function entries(o) return o.pool_variant=='staged' and stagedOptions or options end
local function over(mouse,entry)
    return sp.math.PointBoundCheck(mouse.x,mouse.y,entry.x,entry.x+(entry.width or 200),entry.y-14,entry.y+14)
end
local function refresh(o) o.pool_status=RogueTen.poolStatus(o.pool_options,nil,o.pool_variant) end
local function notice(o,message)
    o.pool_notice,o.pool_notice_time=message,180;PlaySound('invalid')
end
local function startIndex(o) return o.pool_expanded and #entries(o)+2 or 2 end
function U.fresh(o,mode)
    o.pool_options=nil;o.pool_status=nil;o.pool_notice=nil;o.pool_notice_time=0
    o.pool_focus=0;o.pool_expanded=false
    o.pool_mouse_down=ext.mouse:isPress(1)
    o.pool_variant=mode=='roguelike2' and 'staged' or 'single'
    if mode=='roguelike' or mode=='roguelike2' then
        o.pool_options=RogueTen.savedFilters(o.pool_variant)
        o.simple_title=RogueTen.modes[o.pool_variant].title..' · 准备';refresh(o)
    end
end
function U.expand(o)
    o.pool_expanded=not o.pool_expanded;o.pool_focus=1;PlaySound('select00')
end
function U.toggle(o,index)
    local entry=entries(o)[index];if not entry then return end
    local group=o.pool_options[entry.group]
    if group[entry.key] and not entry.optional then
        local another=false
        for key,enabled in pairs(group) do if key~=entry.key and enabled then another=true;break end end
        if not another then notice(o,groupNames[entry.group]..'至少保留一项');return end
    end
    group[entry.key]=not group[entry.key]
    if o.pool_variant=='staged' then scoredata.rogue2_filters=RogueTen.copyFilters(o.pool_options,'staged')
    else
        scoredata.rogue10_filters=RogueTen.copyFilters(o.pool_options)
    end
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
    -- 多个菜单可能刷新同一个 ext.mouse；本界面独立记录按下沿，避免点击被提前消费。
    local down=mouse:isPress(1)
    local clicked=down and not o.pool_mouse_down
    o.pool_mouse_down=down
    if o.pool_notice_time>0 then o.pool_notice_time=o.pool_notice_time-1 end
    o.maxcolindex=o.pool_focus==startIndex(o) and 1 or 0
    -- 鼠标先按实际命中位置分发，不能被当前键盘焦点的确认操作抢先处理。
    if clicked then
        if sp.math.PointBoundCheck(mouse.x,mouse.y,505,920,423,457) then U.expand(o);return end
        if o.pool_expanded then
            for index,entry in ipairs(entries(o)) do
                if over(mouse,entry) then o.pool_focus=index+1;U.toggle(o,index);return end
            end
        end
    end
    if GetLastKey()==KEY.ENTER then o:yes();return end
    if menu:keyYes() or GetLastKey()==setting.keys.shoot then
        if o.pool_focus==1 then U.expand(o)
        elseif o.pool_expanded and o.pool_focus>=2 and o.pool_focus<=#entries(o)+1 then U.toggle(o,o.pool_focus-1)
        else o:yes() end
        return
    end
    if menu:keyNo() then if o.pool_expanded then U.expand(o) else o:no() end;return end
    local focusCount=startIndex(o)+1
    if menu:keyUp() then o.pool_focus=(o.pool_focus-1)%focusCount;PlaySound('select00') end
    if menu:keyDown() then o.pool_focus=(o.pool_focus+1)%focusCount;PlaySound('select00') end
    if menu:keyLeft() then o:addpos1(-1) end
    if menu:keyRight() then o:addpos1(1) end
    local r=155+sin(o.timer*3)*2
    if Dist(mouse.x,mouse.y,240,250)<r then
        if mouse._wheel~=0 then o.pool_focus=0;o:addpos1(-sign(mouse._wheel)) end
        if clicked then
            o.pool_focus=0
            local a=(Angle(mouse.x,mouse.y,240,250)-o.orot)%360
            o:addpos1((a>=225 and a<315) and 0 or (a>=135 and a<225) and 1 or (a>=45 and a<135) and 2 or -1)
        end
    elseif sp.math.PointBoundCheck(mouse.x,mouse.y,420,540,30,60) then
        o.maxcolindex=1
        if clicked then o.pool_focus=startIndex(o);o:yes() end
    elseif Dist(mouse.x,mouse.y,240+r+45,250)<30 then
        if clicked then o.pool_focus=0;o:addpos1(1) end
    elseif Dist(mouse.x,mouse.y,240-r-45,250)<30 then
        if clicked then o.pool_focus=0;o:addpos1(-1) end
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
        local headings=o.pool_variant=='staged' and {{'作品',402}} or {{'作品',402},{'难度（NM = Nightmare）',260},{'战斗',207},{'卡片类型',154}}
        for _,heading in ipairs(headings) do
            ui:RenderText('title',heading[1],505,heading[2],.65,muted,'left','vcenter')
        end
        for index,entry in ipairs(entries(o)) do
            local checked=o.pool_options[entry.group][entry.key]
            local focused=o.pool_focus==index+1
            local hovered=over(ext.mouse,entry)
            local right=entry.x+(entry.width or 200)
            SetImageState('white','',Color(alpha*(focused and 155 or hovered and 110 or 75),35,74,91))
            RenderRect('white',entry.x,right,entry.y-14,entry.y+14)
            if focused then SetImageState('white','',accent);misc.RenderOutLine('white',entry.x,right,entry.y-14,entry.y+14,0,1) end
            ui:RenderText('title',checked and '√' or '□',entry.x+14,entry.y,.72,checked and accent or muted,'centerpoint')
            ui:RenderText('title',entry.text,entry.x+31,entry.y,(entry.width==133 and .58 or .65),checked and white or muted,'left','vcenter')
        end
    end
    if o.pool_variant=='staged' then
        ui:RenderText('title','Lunatic · 符卡 / 非符（含耐久）',715,232,.65,white,'centerpoint')
        ui:RenderText('title','1～6面：4 / 5 / 6 / 7 / 7 / 9 张',715,200,.65,muted,'centerpoint')
        ui:RenderText('title','共38张 · 完成后结算',715,168,.65,muted,'centerpoint')
    end
    local state=o.pool_status;local valid=state and state.valid
    local message=o.pool_notice_time>0 and o.pool_notice or (not valid and state and state.message)
    if message then
        ui:RenderText('title',message,715,o.pool_expanded and 77 or 125,.7,Color(alpha*255,255,170,125),'centerpoint')
    end
    ui:RenderText('title','← → 选择自机',240,80,.7,o.pool_focus==0 and accent or muted,'centerpoint')
end
return U
