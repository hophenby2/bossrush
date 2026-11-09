-- 安卓竖屏只改变显示和触控映射，世界坐标、弹速、判定与录像输入保持原值。
-- 菜单重新排版到540宽的画布；命中区域由同一份布局注册，避免缩放后仍点横屏坐标。
local P={controls={},touches={},pending={},worldViews=setmetatable({},{__mode='k'})}
local WIDTH=540
function P.enabled()
    return setting and setting.androidPortrait==true and setting.resy>setting.resx
end
function P.configure(s)
    local enabled=s.androidPortrait~=false
    if P.requested==enabled then return end
    local ok,result,message=pcall(function()
        return require('cocos.cocos2d.luaj').callStaticMethod('org/bossrush/hd/BossRushActivity',
            'configurePortrait',{enabled},'(Z)V')
    end)
    if ok and result then P.requested=enabled
    else lstg.SystemLog('BOSSRUSH_ORIENTATION: '..tostring(message or result)) end
end
function P.layoutWorld()
    local w=lstg.world
    if not w then return end
    if not P.worldViews[w] or w.scrl~=0 or w.scrr~=WIDTH then
        P.worldViews[w]={w.scrl,w.scrr,w.scrb,w.scrt}
    end
    local height=WIDTH*(w.t-w.b)/(w.r-w.l)
    w.scrl,w.scrr=0,WIDTH
    w.scrb,w.scrt=(screen.height-height)/2,(screen.height+height)/2
end
function P.restoreWorld()
    local w=lstg.world;local view=w and P.worldViews[w]
    if view then w.scrl,w.scrr,w.scrb,w.scrt=unpack(view);P.worldViews[w]=nil end
end
function P.resetScreen()
    if not P.enabled() then return false end
    local s=screen
    s.width,s.height=WIDTH,WIDTH*setting.resy/setting.resx
    s.scale,s.dx,s.dy=setting.resx/WIDTH,0,0
    s.hScale,s.vScale,s.resScale=s.scale,s.scale,setting.resx/setting.resy
    lstg.scale_3d=.007*s.scale
    ResetWorld();ResetWorldOffset();P.layoutWorld()
    return true
end
local function available(o)
    return not o.locked and not o.lock and not o.dk and o.alpha~=0
        and (not o.lockUntil or o.timer>=o.lockUntil)
end
function P.beginRender()
    P.controls={};P.modal=nil
end
function P.clearInput()
    P.controls,P.touches,P.pending={},{},{}
    P.modal=nil
end
local function control(o,x1,x2,y1,y2,action,drag)
    P.controls[#P.controls+1]={owner=o,stage=stage.current_stage,x1=x1,x2=x2,y1=y1,y2=y2,action=action,drag=drag}
end
local function contains(c,x,y) return x>=c.x1 and x<=c.x2 and y>=c.y1 and y<=c.y2 end
function P.touch(id,x,y,event)
    if not P.enabled() or not AndroidInput.menuMode() then return false end
    if event=='began' then
        local hit
        for i=#P.controls,1,-1 do
            local c=P.controls[i]
            if c.stage==stage.current_stage and available(c.owner) and (not P.modal or c.owner==P.modal) and contains(c,x,y) then hit=c;break end
        end
        P.touches[id]={hit=hit,x=x,y=y}
        if hit and hit.drag then P.pending[#P.pending+1]={hit=hit,x=x,y=y,drag=true} end
    else
        local t=P.touches[id]
        if t then
            if (x-t.x)^2+(y-t.y)^2>144 then t.moved=true end
            if event=='moved' and t.hit and t.hit.drag then
                P.pending[#P.pending+1]={hit=t.hit,x=x,y=y,drag=true}
            elseif event=='ended' and t.hit and not t.moved and contains(t.hit,x,y) then
                P.pending[#P.pending+1]={hit=t.hit,x=x,y=y,drag=t.hit.drag~=nil}
            end
        end
        if event=='ended' or event=='cancelled' then P.touches[id]=nil end
    end
    return true
end
function P.dispatch()
    local pending=P.pending;P.pending={}
    if not P.enabled() then P.touches={};return end
    for _,event in ipairs(pending) do
        local c=event.hit
        if c.stage==stage.current_stage and available(c.owner) then
            if event.drag then c.drag(event.x,event.y) else c.action() end
        end
    end
end
local function rect(x1,x2,y1,y2,a,r,g,b)
    SetImageState('white','',Color(a,r,g,b));RenderRect('white',x1,x2,y1,y2)
end
local function label(value,x,y,size,alpha,rgb,align,width)
    value=tostring(value or '')
    local count=0
    for _ in value:gmatch('[%z\1-\127\194-\244][\128-\191]*') do count=count+1 end
    if width then size=math.min(size,width/math.max(1,count*16)) end
    ui:RenderText('title',value,x,y,size,Color(alpha,unpack(rgb or ui.menu and ui.menu.title_color or {255,255,255})),align or 'center','vcenter')
end
local function button(o,value,x1,x2,y,height,action,selected,alpha)
    alpha=(alpha or o.alpha or 1)*255
    -- 沿用横屏文字菜单的白/金闪烁与音符；触区仍保留整行大小。
    local menu=ui.menu or {}
    local rgb=menu.unfocused_color or {190,190,190}
    if selected then
        local k=math.cos(math.rad((o.timer or 0)*(menu.blink_speed or 3)))^2
        local first,last=menu.focused_color1 or {255,255,255},menu.focused_color2 or {255,227,132}
        rgb={}
        for i=1,3 do rgb[i]=first[i]*k+last[i]*(1-k) end
        if value~='' and value:sub(1,#'√')~='√' and value:sub(1,#'□')~='□' then value='♪ '..value end
    end
    label(value,(x1+x2)/2,y,1.05,alpha,rgb,nil,x2-x1-math.min(24,(x2-x1)*.15))
    control(o,x1,x2,y-height/2,y+height/2,action)
end
local function pulse(key) AndroidInput.pulse(key) end
function P.background(alpha,submenu)
    SetViewMode('ui')
    alpha=alpha or 1
    local image=submenu and CheckRes('img','sub_menu_bg') and 'sub_menu_bg' or 'menu_bg'
    if CheckRes('img',image) then
        SetImageState(image,'',Color(alpha*255,255,255,255))
        local scale=math.max(screen.width/960,screen.height/540)
        Render(image,screen.width/2,screen.height/2,0,scale,scale)
    else rect(0,screen.width,0,screen.height,255*alpha,12,21,36) end
end
local function page(o,title)
    P.background(o.alpha or 1,true)
    label(title,WIDTH/2,screen.height-118,1.6,(o.alpha or 1)*255,nil,nil,WIDTH-48)
end
local function footer(o,confirm)
    button(o,'返回',24,154,52,56,function() pulse(27) end)
    if confirm then button(o,confirm,WIDTH-194,WIDTH-24,52,56,function() pulse(13) end,true) end
end
function P.mainMenu(o)
    if o.alpha==0 then return end
    P.background(o.alpha)
    if CheckRes('img','title') then
        SetImageState('title','mul+add',Color(o.alpha*255,255,255,255))
        Render('title',WIDTH/2,screen.height-160,0,.75,.75)
    else label('Boss Rush HD',WIDTH/2,screen.height-160,1.6,o.alpha*255) end
    local debug=GameDebug and GameDebug.enabled
    label(ui.version..(debug and ' · 调试模式' or ''),WIDTH/2,screen.height-292,.8,o.alpha*200,{190,190,190})
    if not debug then control(o,WIDTH/2-150,WIDTH/2+150,screen.height-316,screen.height-268,function() pulse(KEY['8']) end) end
    local gap=math.min(78,(screen.height-354)/#o.text)
    local top=math.min(screen.height-356,screen.height/2+(#o.text-1)*gap/2)
    for i,value in ipairs(o.text) do
        local index=i
        button(o,value,42,WIDTH-42,top-(i-1)*gap,gap-14,function()
            if not o.nopos[index] then o.pos=index;pulse(13) end
        end,o.pos==i)
    end
end
local function chooseSetting(o,group,index)
    o.menus[o.pos1].choosing=false
    o.menus[o.pos1].setting_item[o.pos2].choosing=false
    o.pos1,o.pos2=group,index
    o.menus[group].choosing=true;o.menus[group].setting_item[index].choosing=true
end
function P.settings(o)
    if o.alpha==0 then return end
    page(o,'设置')
    local top=screen.height-190
    for i,group in ipairs(o.menus) do
        local index=i
        local col=(i-1)%3;local row=math.floor((i-1)/3)
        button(o,group.display_name,24+col*166,184+col*166,top-row*54,46,function()
            chooseSetting(o,index,1);PlaySound('select00')
        end,o.pos1==i)
    end
    local itemTop=top-142
    local items=o.menus[o.pos1].setting_item
    local gap=math.min(106,(itemTop-156)/math.max(1,#items-1))
    local half=math.min(44,(gap-8)/2)
    for i,item in ipairs(items) do
        local index=i;local y=itemTop-(i-1)*gap
        rect(24,WIDTH-24,y-half,y-half+1,o.alpha*55,190,190,190)
        label((item.choosing and '♪ ' or '')..item.display_name,42,y+19,1,o.alpha*255,
            item.choosing and {255,227,132} or {190,190,190},'left',WIDTH-84)
        local function select() chooseSetting(o,o.pos1,index) end
        if item.max then
            local x1,x2=44,WIDTH-44
            local fraction=(cur_setting[item.name]-item.min)/(item.max-item.min)
            rect(x1,x2,y-20,y-14,o.alpha*170,90,105,125)
            rect(x1,x1+(x2-x1)*fraction,y-20,y-14,o.alpha*255,255,227,132)
            local function change(x)
                select()
                local f=math.max(0,math.min(1,(x-x1)/(x2-x1)))
                cur_setting[item.name]=math.min(item.max,item.min+math.floor((item.max-item.min)*f/item.min_unit+.5)*item.min_unit)
            end
            label(item.display_way(cur_setting[item.name]),WIDTH-42,y+19,.8,o.alpha*255,{255,227,132},'right',150)
            control(o,24,WIDTH-24,y-half,y+2,function() end,change)
        else
            local on=cur_setting[item.name];if item.opposite then on=not on end
            label(on and '开' or '关',WIDTH-52,y-17,.95,o.alpha*255,on and {255,227,132} or {160,160,160},'right')
            control(o,24,WIDTH-24,y-half,y+half,function()
                select();cur_setting[item.name]=not cur_setting[item.name];item.otherfunction();PlaySound('select00')
            end)
        end
    end
    button(o,'恢复默认',WIDTH-194,WIDTH-24,52,56,function()
        o.restoreDefaults();P.configure(cur_setting);PlaySound('select00')
    end)
    footer(o)
end
function P.playerSelect(o,pool)
    if o.alpha==0 then return end
    page(o,'选择自机')
    local y=screen.height-208
    for i=1,4 do
        local index=i;local x1=24+(i-1)*126;local x2=x1+114
        local col=o.pos1==i and Color(o.alpha*255,255,255,255) or Color(o.alpha*160,160,160,160)
        local left,right=x1+7,x2-7
        local bottom,top=y-36,y+64
        RenderTexture(('title_pl%d'):format(i),'',{left,top,.5,0,0,col},{right,top,.5,512,0,col},
            {right,bottom,.5,512,512,col},{left,bottom,.5,0,512,col})
        button(o,o.playername[i],x1,x2,y-60,42,function() o:addpos1(index-o.pos1) end,o.pos1==i)
        control(o,x1,x2,bottom,top,function() o:addpos1(index-o.pos1) end)
    end
    local optionsTop=screen.height-326
    if o.pool_options then
        button(o,(o.pool_expanded and '− ' or '+ ')..'高级选项',24,WIDTH-24,optionsTop,52,function() pool.expand(o) end,o.pool_expanded)
        if o.pool_expanded then
            local layout,row,col,group={},-1,0,nil
            for i,entry in ipairs(pool.options) do
                local columns=entry.group=='difficulties' and 3 or 2
                if entry.group~=group or col>=columns then row=row+1;col=0 end
                layout[#layout+1]={index=i,entry=entry,row=row,col=col,columns=columns}
                col=col+1;group=entry.group
            end
            local gap=math.min(50,(optionsTop-216)/math.max(1,row))
            for _,cell in ipairs(layout) do
                local index,entry=cell.index,cell.entry
                local width=(WIDTH-36)/cell.columns
                local x1=24+cell.col*width
                local checked=o.pool_options[entry.group][entry.key]
                button(o,(checked and '√ ' or '□ ')..entry.text,x1,x1+width-12,
                    optionsTop-62-cell.row*gap,math.min(44,gap-4),function() pool.toggle(o,index) end,checked)
            end
        end
        if o.pool_notice_time>0 and o.pool_notice then label(o.pool_notice,WIDTH/2,130,.8,o.alpha*255,{255,170,125},nil,WIDTH-48) end
    end
    footer(o,'开始')
end
local function window(o,count,selected,rowHeight)
    local size=math.max(1,math.floor((screen.height-280)/rowHeight))
    local first=math.max(1,math.min(count-size+1,selected-math.floor(size/2)))
    return first,math.min(count,first+size-1)
end
function P.stagePractice(o)
    if o.alpha==0 then return end
    page(o,'关卡练习')
    local first,last=window(o,o.stage_count,o.pos,72)
    for i=first,last do
        local index=i;local entry=o.stage_selects[i]
        button(o,entry.title,24,WIDTH-24,screen.height-200-(i-first)*72,62,function()
            o.pos=index;pulse(13)
        end,o.pos==i)
    end
    if first>1 then button(o,'上一页',170,268,106,42,function() o.pos=math.max(1,o.pos-(last-first+1)) end) end
    if last<o.stage_count then button(o,'下一页',276,374,106,42,function() o.pos=math.min(o.stage_count,o.pos+last-first+1) end) end
    footer(o,'开始')
end
function P.spellPractice(o)
    if o.alpha==0 then return end
    page(o,'符卡练习')
    button(o,'‹',24,76,screen.height-182,48,function() o:adddiffpos(-1,1) end)
    label(o.difficulty[o.diffpos],WIDTH/2,screen.height-182,1.05,o.alpha*255,nil,nil,WIDTH-180)
    button(o,'›',WIDTH-76,WIDTH-24,screen.height-182,48,function() o:adddiffpos(1,2) end)
    local count=#o.spell
    local size=math.max(1,math.floor((screen.height-440)/72))
    local first=math.max(1,math.min(count-size+1,o.pos-math.floor(size/2)))
    local last=math.min(count,first+size-1)
    for i=first,last do
        local index=i;local entry=o.spell[i]
        local sc=_sc_pr_table[entry[4]][entry[1]]
        local names={}
        for _,unit in ipairs(sc.sc_group) do names[#names+1]=unit.boss.name end
        local y=screen.height-262-(i-first)*72
        button(o,'',24,WIDTH-24,y,64,function() o.pos=index;pulse(13) end,o.pos==i)
        label(sc.CardName,40,y+13,.9,o.alpha*255,nil,'left',WIDTH-80)
        label(table.concat(names,' / '),40,y-15,.7,o.alpha*190,{170,195,215},'left',WIDTH-80)
    end
    if count==0 then label('没有符合筛选条件的符卡',WIDTH/2,screen.height/2,1,o.alpha*200,nil,nil,WIDTH-48) end
    if first>1 then button(o,'上一页',170,268,226,42,function() o.pos=math.max(1,o.pos-size) end) end
    if last<count then button(o,'下一页',276,374,226,42,function() o.pos=math.min(count,o.pos+size) end) end
    local function filter(field)
        o[field]=not o[field]
        sc_pr_menu.TweakCard(o,o.onlyshowcard,o.onlyshowspecialcard)
        o.spell=o.spells[o.diffpos];o.pos=1;o:setsomealpha(1);PlaySound('select00')
    end
    button(o,(o.onlyshowcard and '√ ' or '□ ')..'仅符卡',24,264,160,46,function() filter('onlyshowcard') end,o.onlyshowcard)
    button(o,(o.onlyshowspecialcard and '√ ' or '□ ')..'仅特殊卡',276,WIDTH-24,160,46,function() filter('onlyshowspecialcard') end,o.onlyshowspecialcard)
    footer(o,'开始')
end
function P.replays(o,saving,keyboard)
    if o.alpha==0 then return end
    if saving and o.state==1 then return P.keyboard(o,keyboard,'保存录像') end
    page(o,saving and '保存录像' or '查看录像')
    local rows=o.state==0 and o.state1Text or o.state2Text
    local field=o.state==0 and 'state1Selected' or 'state2Selected'
    local first,last=window(o,#rows,o[field],82)
    for i=first,last do
        local index=i;local y=screen.height-200-(i-first)*82
        button(o,'',24,WIDTH-24,y,72,function() o[field]=index;pulse(13) end,o[field]==i)
        local row=rows[i]
        label(table.concat(row,'  ',1,math.min(3,#row)),42,y+14,.85,o.alpha*255,nil,'left',WIDTH-84)
        if #row>3 then label(table.concat(row,'  ',4),42,y-15,.75,o.alpha*190,{170,195,215},'left',WIDTH-84) end
    end
    if first>1 then button(o,'上一页',170,268,104,40,function() o[field]=math.max(1,o[field]-(last-first+1)) end) end
    if last<#rows then button(o,'下一页',276,374,104,40,function() o[field]=math.min(#rows,o[field]+last-first+1) end) end
    footer(o,'确定')
end
function P.keys(o,names)
    if o.alpha==0 then return end
    page(o,o.edit and '请按下要绑定的按键' or '按键设置')
    local first,last=window(o,o.count,o.pos,62)
    for i=first,last do
        local index=i;local y=screen.height-195-(i-first)*62
        local value=i<=o.count-2 and (names[cur_setting[o.field[i]][o.key[i]]] or '?') or ''
        button(o,o.text[i]..(value~='' and '   '..value or ''),24,WIDTH-24,y,54,function() o.pos=index;pulse(13) end,o.pos==i)
    end
    if first>1 then button(o,'上页',170,268,106,42,function() o.pos=math.max(1,o.pos-5) end) end
    if last<o.count then button(o,'下页',276,374,106,42,function() o.pos=math.min(o.count,o.pos+5) end) end
    footer(o)
end
function P.keyboard(o,keys,title)
    page(o,title)
    label(o.state2UserName or '',WIDTH/2,screen.height-220,1.2,255,{189,252,201},nil,WIDTH-48)
    local cell=(WIDTH-48)/13
    local top=screen.height/2+130
    for row=0,6 do for col=0,12 do
        local x,y=col,row
        local value=string.char(keys[row*13+col+1])
        if row==6 and col>=10 then value=({'空格','删除','完成'})[col-9] end
        button(o,value,24+col*cell,24+(col+1)*cell-3,top-row*52,46,function()
            o.state2CursorX,o.state2CursorY=x,y;pulse(13)
        end,o.state2CursorX==col and o.state2CursorY==row)
    end end
    if title~='设置玩家标签' then footer(o) end
end
local function wrapped(lines,capacity)
    local out={}
    for _,line in ipairs(lines) do
        local current,n='',0
        for c in line:gmatch('[%z\1-\127\194-\244][\128-\191]*') do
            current=current..c;n=n+1
            if n>=capacity then out[#out+1]=current;current,n='',0 end
        end
        out[#out+1]=current
    end
    return out
end
function P.notice(o,choose)
    if o.dk then return end
    P.modal=o
    P.background(.97)
    label(o.title,WIDTH/2,screen.height-130,1.3,255,nil,nil,WIDTH-48)
    local lines=wrapped(o.texts,30)
    local visible=math.floor((screen.height-360)/24)
    local first=math.max(1,math.min(math.max(1,#lines-visible+1),1+math.floor((o._ty or 0)/24)))
    for i=first,math.min(#lines,first+visible-1) do label(lines[i],24,screen.height-200-(i-first)*24,.9,245,nil,'left',WIDTH-48) end
    if #lines>visible then
        button(o,'上翻',24,144,170,44,function() o._ty=math.max(0,o._ty-visible*24) end)
        button(o,'下翻',WIDTH-144,WIDTH-24,170,44,function() o._ty=math.min((#lines-visible)*24,o._ty+visible*24) end)
    end
    button(o,'确定',24,choose and WIDTH/2-8 or WIDTH-24,88,58,function() o.pos=1;pulse(13) end,true)
    if choose then button(o,'取消',WIDTH/2+8,WIDTH-24,88,58,function() o.pos=2;pulse(13) end) end
end
function P.pause(o)
    if o.kill then return 'killed' end
    SetViewMode('ui')
    PostEffect('fx:pause_menu_blur','PauseMenuBlur',6,'',{{2,0,0,0}},{})
    rect(0,WIDTH,0,screen.height,o.mask_alph*.65,6,13,25)
    local rows=o.choose and {'确定','取消'} or lstg.tmpvar.pause_menu_text or o.text[ext.replay.IsReplay() and 2 or 1]
    local title=lstg.tmpvar.pause_menu_text and (ext.rep_over and '播放结束' or '游戏结束') or '游戏暂停'
    label(o.choose and '确认操作？' or title,WIDTH/2,screen.height*.68,1.7,o.mask_alph)
    for i,value in ipairs(rows) do
        local index=i
        button(o,value,60,WIDTH-60,screen.height*.58-(i-1)*70,58,function()
            if o.choose then o.pos2=index else o.pos=index end
            pulse(13)
        end,(o.choose and o.pos2 or o.pos)==i,o.mask_alph/255)
    end
end
function P.music(o)
    if o.alpha==0 then return end
    SetViewMode('ui')
    label(o.text[o.pos],WIDTH/2,screen.height-42,.75,o.alpha*200,nil,nil,WIDTH-160)
    button(o,'‹',24,70,screen.height-42,42,function() pulse(KEY.COMMA) end)
    button(o,'›',WIDTH-70,WIDTH-24,screen.height-42,42,function() pulse(KEY.PERIOD) end)
end
function P.loading(o)
    SetViewMode('ui');P.background()
    label('少女折寿中'..string.rep('.',math.floor(o.timer/20%6)),WIDTH/2,screen.height/2,1.3,255,{255,227,132})
    rect(40,WIDTH-40,screen.height/2-55,screen.height/2-47,180,70,90,110)
    rect(40,40+(WIDTH-80)*math.min(o.index/o.maxindex,1),screen.height/2-55,screen.height/2-47,255,189,252,201)
end
function P.hud(alpha)
    SetViewMode('ui')
    -- 横屏的生命/Bomb星形库存移到场地上方，成长条移到下方三列。
    local w=lstg.world
    ui.RunHUD.resources(72,WIDTH-24,screen.height-54,alpha)
    ui.RunHUD.attributes(w.scrr,w.scrt,alpha,{left=18,right=WIDTH-18,top=w.scrb-70,columns=3,gutter=18})
end
function P.roguePanel(run)
    local previous=lstg.viewmode
    SetViewMode('ui')
    local bottom=lstg.world.scrb
    local y=math.max(48,(bottom-135)*.5)
    ui.RunHUD.stage(run.current,WIDTH*.25,y,WIDTH*.4,math.max(1,math.min(5,(bottom-135)/20)))
    if GameHPScale then GameHPScale.render(WIDTH*.7,y,WIDTH*.5) end
    if previous then SetViewMode(previous) end
end
function P.result(o)
    P.background()
    ui.RunHUD.stage(o.run.current or o.run.completed,WIDTH/2,screen.height/2,WIDTH-48)
    button(o,'返回标题',40,WIDTH-40,190,64,function() pulse(27) end)
    button(o,'再来一局',40,WIDTH-40,108,64,function() pulse(13) end,true)
end
return P
