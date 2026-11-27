-- 安卓符卡列表使用连续偏移；拖动只浏览，点击才选择，滑动松手不会误开符卡。
local S={rows=14}
local function clamp(value,limit) return math.max(0,math.min(limit,value)) end
function S.enabled() return AndroidPlatform and not BossRushDesktop end
function S.reset(o)
    o.scrollList=o.spell;o.scrollSelection=o.pos
    o.scrollOffset=clamp((o.pos or 1)-7,math.max(0,#o.spell-S.rows))
    o.scrollVelocity,o.scrollTouch=0,nil
end
function S.update(o,advance)
    if o.scrollList~=o.spell or o.scrollOffset==nil then S.reset(o) end
    local limit=math.max(0,#o.spell-S.rows)
    if o.scrollSelection~=o.pos then
        o.scrollSelection=o.pos;o.scrollVelocity=0
        if o.pos<o.scrollOffset+1 then o.scrollOffset=o.pos-1
        elseif o.pos>o.scrollOffset+S.rows then o.scrollOffset=o.pos-S.rows end
    end
    if advance~=false and not o.scrollTouch and not o.locked then
        local nextOffset=clamp(o.scrollOffset+(o.scrollVelocity or 0),limit)
        if nextOffset==0 or nextOffset==limit then o.scrollVelocity=0
        else o.scrollVelocity=(o.scrollVelocity or 0)*.9 end
        if math.abs(o.scrollVelocity)<.01 then o.scrollVelocity=0 end
        o.scrollOffset=nextOffset
    end
    o.scrollOffset=clamp(o.scrollOffset,limit)
    local first=math.floor(o.scrollOffset)+1
    o.scrollFirst,o.scrollFraction=first,o.scrollOffset-math.floor(o.scrollOffset)
    o._spell={}
    for i=first,math.min(#o.spell,first+S.rows) do o._spell[#o._spell+1]=o.spell[i] end
    o._pos=o.pos-first+1
end
function S.touch(o,x,y,phase,height)
    if o.locked then o.scrollTouch=nil;o.scrollVelocity=0;return end
    if o.scrollList~=o.spell or o.scrollOffset==nil then S.reset(o) end
    if phase=='began' then
        o.scrollTouch={x=x,y=y,lastY=y,lastFrame=o.timer or 0,height=height}
        o.scrollVelocity=0
        return
    end
    local t=o.scrollTouch
    if not t then return end
    local dx,dy=x-t.x,y-t.y
    if not t.axis and dx*dx+dy*dy>100 then t.axis=math.abs(dx)>math.abs(dy)*1.3 and 'horizontal' or 'vertical' end
    if t.axis=='vertical' and (phase=='moved' or phase=='ended') and y~=t.lastY then
        local delta=(y-t.lastY)/t.height
        local frames=math.max(1,(o.timer or 0)-t.lastFrame)
        o.scrollOffset=clamp(o.scrollOffset+delta,math.max(0,#o.spell-S.rows))
        o.scrollVelocity=math.max(-2.5,math.min(2.5,delta/frames))
        t.lastY,t.lastFrame=y,o.timer or 0
    end
    if phase=='ended' or phase=='cancelled' then
        o.scrollTouch=nil
        if phase=='cancelled' then o.scrollVelocity=0;return end
        if t.axis=='horizontal' then
            o.scrollVelocity=0
            if math.abs(dx)>=48 then o.touch_diff=(o.touch_diff or 0)+(dx<0 and 1 or -1) end
        elseif not t.axis then
            o.scrollVelocity=0
            local top=255+S.rows*t.height/2
            local index=math.floor((top-y)/t.height+o.scrollOffset)+1
            if y>=top-S.rows*t.height and y<=top and index>=1 and index<=#o.spell then
                o.pos=index;o.scrollSelection=index
                o:yes()
            end
        elseif (o.timer or 0)-t.lastFrame>6 then o.scrollVelocity=0 end
    end
end
function S.clip(o,height)
    -- 同时裁切视口和投影，保持横屏/竖屏的原菜单坐标，不额外创建整屏纹理。
    local l,r=o.x-ui.menu.sc_pr_width/2-ui.menu.sc_pr_margin,o.x+ui.menu.sc_pr_width/2+ui.menu.sc_pr_margin
    local b,t=255-S.rows*height/2,255+S.rows*height/2
    local x1,y1,x2,y2=l,b,r,t
    if AndroidPortrait and AndroidPortrait.rendering then x1,y1=AndroidPortrait.menuPoint(l,b);x2,y2=AndroidPortrait.menuPoint(r,t) end
    SetViewport(x1*screen.scale+screen.dx,x2*screen.scale+screen.dx,y1*screen.scale+screen.dy,y2*screen.scale+screen.dy)
    SetOrtho(l,r,b,t)
    return b,t
end
function S.draw(o,columns,height,alpha)
    local b,t=S.clip(o,height)
    for i in ipairs(o._spell) do
        local y=t-(i-.5)*height+(o.scrollFraction or 0)*height
        local focused=(o.scrollFirst+i-1)==o.pos
        local color=ui.menu.unfocused_color
        if focused then
            local k=cos(o.timer*ui.menu.blink_speed)^2;color={}
            for j=1,3 do color[j]=ui.menu.focused_color1[j]*k+ui.menu.focused_color2[j]*(1-k) end
        end
        for _,column in ipairs(columns) do
            if column[1][i] then ui:RenderText('sc_menu',column[1][i],column[2],y,focused and 1.05 or 1,
                Color(alpha*255,unpack(color)),column[3],'vcenter','noclip') end
        end
    end
    SetViewMode('ui')
    if #o.spell>S.rows then
        local track=t-b;local thumb=math.max(18,track*S.rows/#o.spell)
        local y=t-(track-thumb)*o.scrollOffset/(#o.spell-S.rows)
        local x=o.x+ui.menu.sc_pr_width/2+ui.menu.sc_pr_margin-5
        SetImageState('white','',Color(alpha*70,255,255,255));RenderRect('white',x,x+3,b,t)
        SetImageState('white','',Color(alpha*210,210,225,255));RenderRect('white',x,x+3,y-thumb,y)
    end
end
return S
