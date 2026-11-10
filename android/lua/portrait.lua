-- 安卓竖屏只改变显示和触控映射，世界坐标、弹速、判定与录像输入保持原值。
-- 菜单复用横屏绘制，只移动和缩放组件；触区使用同一份坐标变换。
local P={controls={},touches={},pending={},TOP_INSET=46,worldViews=setmetatable({},{__mode='k'})}
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
    P.modal,P.menuView,P.rendering,P.owner,P.closeAction=nil,nil,nil,nil,nil
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
            if event.drag then c.drag(event.x,event.y) else c.action(event.x,event.y) end
        end
    end
end
local function rect(x1,x2,y1,y2,a,r,g,b)
    SetImageState('white','',Color(a,r,g,b));RenderRect('white',x1,x2,y1,y2)
end
local function label(value,x,y,size,alpha,rgb,align)
    ui:RenderText('title',tostring(value or ''),x,y,size,Color(alpha,unpack(rgb or {255,255,255})),align or 'center','vcenter')
end
local function pulse(key) AndroidInput.pulse(key) end
-- 横屏面板继续使用自己的字体、贴图、动画和选中效果。这里只变换组件的坐标。
function P.menuPoint(x,y)
    local v=P.menuView
    if not v then return x,y end
    return x*v.scale+v.x,y*v.scale+v.y
end
function P.applyMenuView()
    local v=P.menuView
    if not v then
        if not P.covering and P.enabled() and ext and not ext.StageIsMenu() then
            local w=lstg.world
            SetViewport(w.scrl*screen.scale+screen.dx,w.scrr*screen.scale+screen.dx,
                w.scrb*screen.scale+screen.dy,w.scrt*screen.scale+screen.dy)
            SetOrtho(w.scrl,w.scrr,w.scrb,w.scrt)
            SetImageScale(1)
        end
        return
    end
    SetViewport(screen.dx,setting.resx+screen.dx,screen.dy,setting.resy+screen.dy)
    SetOrtho(-v.x/v.scale,(WIDTH-v.x)/v.scale,-v.y/v.scale,(screen.height-v.y)/v.scale)
    SetImageScale(1)
end
function P.coverOutside()
    if not P.enabled() or not ext or ext.StageIsMenu() then return end
    -- 下标指示器等旧组件会主动扩大自己的视口；收尾覆盖保证暂停及特效也不越过场地。
    P.covering=true;SetViewMode('ui')
    local w=lstg.world
    local edge=1/screen.scale -- 原生低分辨率画面放大时，留一个原生像素避免边缘插值漏色。
    rect(0,WIDTH,0,w.scrb+edge,255,0,0,0)
    rect(0,WIDTH,w.scrt-edge,screen.height,255,0,0,0)
    P.covering=nil;SetViewMode('ui')
end
function P.bossInsetWorld()
    local w=lstg.world
    return P.TOP_INSET*(w.t-w.b)/(w.scrt-w.scrb)
end
function P.place(cx,cy,x,y,scale)
    if not P.rendering then return end
    scale=scale or 1
    P.menuView={scale=scale,x=x-cx*scale,y=y-cy*scale}
    SetViewMode('ui')
end
function P.bind(o,x1,x2,y1,y2,action,drag)
    x1,y1=P.menuPoint(x1,y1);x2,y2=P.menuPoint(x2,y2)
    local v=P.menuView
    local function localPoint(x,y)
        if v then return (x-v.x)/v.scale,(y-v.y)/v.scale end
        return x,y
    end
    control(o,x1,x2,y1,y2,function(x,y) action(localPoint(x,y)) end,drag and function(x,y)
        if v then x,y=(x-v.x)/v.scale,(y-v.y)/v.scale end
        drag(x,y)
    end)
end
local function shared(o,render,bind,closeAction)
    P.rendering,P.owner,P.closeAction=true,o,closeAction
    SetViewMode('ui')
    local result=render(o)
    if bind then bind() end
    P.rendering,P.owner,P.menuView,P.closeAction=nil,nil,nil,nil
    SetViewMode('ui')
    return result
end
-- 临时排版不写回菜单状态，避免影响键盘逻辑、横竖屏切换和录像。
local function fields(o,values,fn)
    local saved={}
    for key,value in pairs(values) do saved[key]=o[key];o[key]=value end
    local result=fn()
    for key in pairs(values) do o[key]=saved[key] end
    return result
end
function P.background(alpha)
    local main=alpha==nil
    alpha=alpha or 1
    local view=P.menuView;P.menuView=nil
    SetViewMode('ui')
    local image=main and 'menu_bg' or 'sub_menu_bg'
    if CheckRes('img',image) then
        SetImageState(image,'',Color(alpha*255,255,255,255))
        local scale=math.max(screen.width/960,screen.height/540)
        Render(image,screen.width/2,screen.height/2,0,scale,scale)
    else rect(0,WIDTH,0,screen.height,255*alpha,12,21,36) end
    if main and CheckRes('img','title') then
        local t=stage.current_stage.timer or 0
        SetImageState('title','mul+add',Color(math.min(t/90,1)*255,255,255,255))
        Render('title',WIDTH/2,screen.height-192+(cur_setting.easyrender and 0 or sin(t/2)*5),0,.7,.7)
    end
    P.menuView=view
    SetViewMode('ui')
end
function P.exit(o,alpha)
    local view=P.menuView;P.menuView=nil;SetViewMode('ui')
    -- 与横屏相同的左上角关闭标记，不再增加一排按钮。
    SetImageState('white','',Color(alpha*153,0,0,0));RenderRect('white',0,36,screen.height-36,screen.height)
    ui:RenderText('big_text','×',18,screen.height-15,.8,Color(alpha*255,255,255,255),'centerpoint')
    control(o,0,48,screen.height-48,screen.height,P.closeAction or function() pulse(27) end)
    P.menuView=view;SetViewMode('ui')
end
function P.mainLayout(o)
    return 232,screen.height-355,math.min(60,(screen.height-415)/#o.text)
end
function P.mainMenu(o,render)
    if o.alpha==0 then return end
    return shared(o,render,function()
        local _,top,gap=P.mainLayout(o)
        for i in ipairs(o.text) do
            local index=i
            P.bind(o,28,WIDTH-28,top-i*gap-gap/2,top-i*gap+gap/2,function()
                if not o.nopos[index] then o.pos=index;pulse(13) end
            end)
        end
        if not (GameDebug and GameDebug.enabled) then
            label(ui.version,WIDTH/2,screen.height-310,.8,o.alpha*200,{190,190,190})
            P.bind(o,WIDTH/2-150,WIDTH/2+150,screen.height-334,screen.height-286,function() pulse(KEY['8']) end)
        end
    end)
end
function P.stagePractice(o,render)
    if o.alpha==0 then return end
    return fields(o,{x=WIDTH/2,y=screen.height/2,moveUnit=300,pulseUnit=20},function()
        return shared(o,render,function()
            for i in ipairs(o.stage_selects) do
                local index=i
                local x=o.x+o.ox+(i-o.pos)*o.moveUnit
                P.bind(o,x-125,x+125,o.y-175,o.y+175,function()
                    if o.pos==index then pulse(13) else o.pos=index end
                end)
            end
            for _,direction in ipairs({-1,1}) do
                local delta=direction;local x=WIDTH/2+direction*235
                SetImageState('weapon_arrow','',Color(o.alpha*220,220,220,220))
                Render('weapon_arrow',x,o.y,delta<0 and 0 or 180,.6,.6)
                P.bind(o,x-32,x+32,o.y-48,o.y+48,function() o.pos=math.max(1,math.min(o.stage_count,o.pos+delta)) end)
            end
        end)
    end)
end
local function chooseSetting(o,group,index)
    o.menus[o.pos1].choosing=false
    o.menus[o.pos1].setting_item[o.pos2].choosing=false
    o.pos1,o.pos2=group,index
    o.menus[group].choosing=true;o.menus[group].setting_item[index].choosing=true
end
function P.settings(o,render)
    if o.alpha==0 then return end
    local saved={}
    local function layout(item,x1,x2,y1,y2)
        saved[#saved+1]={item,item.x1,item.x2,item.y1,item.y2}
        item.x1,item.x2,item.y1,item.y2=x1,x2,y1,y2
    end
    local top=screen.height-160
    local bottom=math.max(115,top-math.max(#o.menus*64,540))
    for i,group in ipairs(o.menus) do
        layout(group,24,148,top-i*64,top-(i-1)*64)
        local gap=math.min(50,(top-bottom)/#group.setting_item)
        for j,item in ipairs(group.setting_item) do layout(item,148,WIDTH-24,top-j*gap,top-(j-1)*gap) end
    end
    local result=fields(o,{x1=24,x2=WIDTH-24,y1=top,y2=bottom,dpline=148},function()
        return shared(o,render,function()
            for i,group in ipairs(o.menus) do
                local index=i
                P.bind(o,group.x1,group.x2,group.y1,group.y2,function() chooseSetting(o,index,1);PlaySound('select00') end)
            end
            for i,item in ipairs(o.menus[o.pos1].setting_item) do
                local index=i
                local x1,x2,y1,y2=item.x1,item.x2,item.y1,item.y2
                if item.max then
                    local left,right=x1+(x2-x1)/12,x2-(x2-x1)/12
                    P.bind(o,x1,x2,y1,y2,function() end,function(x)
                        chooseSetting(o,o.pos1,index)
                        local f=math.max(0,math.min(1,(x-left)/(right-left)))
                        cur_setting[item.name]=math.min(item.max,item.min+math.floor((item.max-item.min)*f/item.min_unit+.5)*item.min_unit)
                    end)
                else
                    P.bind(o,x1,x2,y1,y2,function()
                        chooseSetting(o,o.pos1,index);cur_setting[item.name]=not cur_setting[item.name]
                        item.otherfunction();PlaySound('select00')
                    end)
                end
            end
            P.bind(o,36,136,bottom+5,bottom+35,function() o.restoreDefaults();P.configure(cur_setting);PlaySound('select00') end)
        end)
    end)
    for _,v in ipairs(saved) do v[1].x1,v[1].x2,v[1].y1,v[1].y2=v[2],v[3],v[4],v[5] end
    return result
end
function P.playerSelect(o,pool,render)
    if o.alpha==0 then return end
    return shared(o,render,function()
        P.place(240,250,WIDTH/2,screen.height-300)
        P.bind(o,15,65,200,300,function() o:addpos1(-1) end)
        P.bind(o,415,465,200,300,function() o:addpos1(1) end)
        -- 轮盘上的四个扇区保持横屏的选择方式。
        P.bind(o,85,395,95,405,function(x,y)
            if (x-240)^2+(y-250)^2<155^2 then
                local angle=(math.deg(math.atan2(y-250,x-240))-o.orot)%360
                local delta=angle<45 and -1 or angle<135 and 0 or angle<225 and 1 or angle<315 and 2 or -1
                o:addpos1(delta)
            end
        end)
        if o.pool_options then
            P.place(715,270,WIDTH/2,P.playerOptionsY())
            P.bind(o,505,920,423,457,function() pool.expand(o) end)
            if o.pool_expanded then for i,entry in ipairs(pool.options) do
                local index=i
                P.bind(o,entry.x,entry.x+(entry.width or 200),entry.y-14,entry.y+14,function() pool.toggle(o,index) end)
            end end
        end
        P.place(480,45,WIDTH/2,90)
        P.bind(o,370,590,17,73,function() pulse(13) end)
    end)
end
function P.playerOptionsY() return math.max(315,screen.height-710) end
function P.spellPractice(o,render)
    if o.alpha==0 then return end
    return fields(o,{x=480,y=270},function()
        return fields(ui.menu,{sc_pr_line_height=48},function()
            return shared(o,render,function()
                P.place(480,450,WIDTH/2,screen.height-150,WIDTH/960)
                P.bind(o,0,180,420,480,function() o:adddiffpos(-1,1) end)
                P.bind(o,780,960,420,480,function() o:adddiffpos(1,2) end)
                P.place(480,270,WIDTH/2,screen.height/2,.68)
                for i,entry in ipairs(o._spell) do
                    local chosen=entry
                    local y=255-i*48+(#o._spell+1)*24
                    P.bind(o,120,840,y-24,y+24,function()
                        for index,row in ipairs(o.spell) do if row==chosen then o.pos=index;pulse(13);return end end
                    end)
                end
                P.place(480,55,WIDTH/2,140,.6)
                local function filter(field)
                    o[field]=not o[field];sc_pr_menu.TweakCard(o,o.onlyshowcard,o.onlyshowspecialcard)
                    o.spell=o.spells[o.diffpos];o.pos=1;o:setsomealpha(1);PlaySound('select00')
                end
                P.bind(o,500,850,55,85,function() filter('onlyshowcard') end)
                P.bind(o,500,850,25,55,function() filter('onlyshowspecialcard') end)
                P.place(480,55,WIDTH/2,140,.6)
                P.menuView=nil;SetViewMode('ui')
                for _,direction in ipairs({-1,1}) do
                    local delta=direction;local x=WIDTH/2+direction*45
                    SetImageState('weapon_arrow','',Color(o.alpha*220,220,220,220))
                    Render('weapon_arrow',x,205,delta<0 and 270 or 90,.5,.5)
                    P.bind(o,x-30,x+30,180,230,function() o.pos=math.max(1,math.min(#o.spell,o.pos+delta*14)) end)
                end
            end)
        end)
    end)
end
local function keyboardTouch(o)
    local yOffset=320-(o.alpha or 1)*320
    for row=0,6 do for col=0,12 do
        local x,y=col,row
        local cx=o.x+(col-5.5)*ui.menu.char_width
        local cy=o.y-(row-3.5)*ui.menu.line_height+yOffset
        P.bind(o,cx-ui.menu.char_width/2,cx+ui.menu.char_width/2,cy-ui.menu.line_height/2,cy+ui.menu.line_height/2,function()
            o.state2CursorX,o.state2CursorY=x,y;pulse(13)
        end)
    end end
end
function P.replays(o,saving,keyboard,render)
    if o.alpha==0 then return end
    return fields(o,{x=480,y=270},function()
        return fields(ui.menu,{rep_line_height=38,sc_pr_line_height=38},function()
            P.rendering=true;P.place(480,270,WIDTH/2,screen.height/2,saving and o.state==1 and 1.5 or .72)
            return shared(o,render,function()
                if saving and o.state==1 then keyboardTouch(o);return end
                local rows=o.state==0 and o.state1Text or o.state2Text
                local field=o.state==0 and 'state1Selected' or 'state2Selected'
                local top=o.y+(#rows-1)*19+320-o.alpha*320
                for i in ipairs(rows) do
                    local index=i;local y=top-i*38
                    P.bind(o,160,800,y-19,y+19,function() o[field]=index;pulse(13) end)
                end
            end)
        end)
    end)
end
function P.keys(o,names,render)
    if o.alpha==0 then return end
    return fields(o,{x=480,y=270},function()
        return fields(ui.menu,{line_height=42},function()
            P.rendering=true;P.place(480,270,WIDTH/2,screen.height/2,.95)
            return shared(o,render,function()
                for i=1,o.count do
                    local index=i;local y=o.y+42*(o.count/2-i)
                    P.bind(o,280,680,y-21,y+21,function() o.edit=false;o.pos=index;pulse(13) end)
                end
            end,function() o.edit=false;o.pos=o.count;o.exit_func();PlaySound('cancel00',.3) end)
        end)
    end)
end
function P.keyboard(o,keys,title,render)
    return fields(o,{x=480,y=200},function()
        P.rendering=true;P.place(480,200,WIDTH/2,screen.height/2,1.5)
        return shared(o,render,function() keyboardTouch(o) end)
    end)
end
function P.notice(o,choose,render)
    if o.dk then return end
    P.modal=o
    P.rendering=true;P.place(WIDTH/2,270,WIDTH/2,screen.height/2,.7)
    return shared(o,render,function()
        local x,y,w,h,ph=o.x,o.y,o.width,o.height,o.pheight
        P.bind(o,x-w,choose and x or x+w,y-h-ph,y-h,function() o.pos=1;pulse(13) end)
        if choose then P.bind(o,x,x+w,y-h-ph,y-h,function() o.pos=2;pulse(13) end) end
        P.bind(o,x-w,x+w,y-h,y+h,function() end,function(_,py)
            local direction=py>y and -1 or 1
            o._ty=math.max(0,o._ty+direction*24)
        end)
    end)
end
function P.pause(o)
    if o.kill then return 'killed' end
    -- 暂停沿用横屏的贴图、字体及颜色，内容放进场地。
    SetViewMode('ui');PostEffect('fx:pause_menu_blur','PauseMenuBlur',6,'',{{2,0,0,0}},{})
    local w=lstg.world
    rect(w.scrl,w.scrr,w.scrb,w.scrt,o.mask_alph*.65,6,13,25)
    local cx,cy=(w.scrl+w.scrr)/2,(w.scrb+w.scrt)/2
    SetImageState('pause_eff','',Color(o.mask_alph/3,200,180,255));Render('pause_eff',cx,cy,4+4*sin(o.timer*3),.4,.4)
    local rows=o.choose and {'好！','*不*'} or lstg.tmpvar.pause_menu_text or o.text[ext.replay.IsReplay() and 2 or 1]
    local title=lstg.tmpvar.pause_menu_text and (ext.rep_over and '播放结束' or '游戏结束') or '游戏暂停'
    o.RenderText(cx-90,cy+60,o.choose and '真的吗?' or title,Color(o.mask_alph,250,128,114))
    for i,value in ipairs(rows) do
        local index=i;local y=cy+25-(i-1)*40
        local chosen=(o.choose and o.pos2 or o.pos)==i
        o.RenderText(cx-80,y,value,chosen and Color(o.mask_alph,155+100*sin(o.timer*4.5),255,222) or Color(o.mask_alph,100,100,100))
        control(o,cx-100,cx+160,y-20,y+20,function() if o.choose then o.pos2=index else o.pos=index end;pulse(13) end)
    end
end
function P.music(o,render)
    P.rendering=true
    if o.salpha>.99 then P.place(480,500,WIDTH/2,screen.height-45,.55)
    else P.place(480,270,WIDTH/2,screen.height/2) end
    return shared(o,render,function()
        if o.salpha>.99 then
            P.bind(o,0,240,460,540,function() pulse(KEY.COMMA) end)
            P.bind(o,720,960,460,540,function() pulse(KEY.PERIOD) end)
        end
    end)
end
function P.loading(o,render)
    P.rendering=true;P.place(480,270,WIDTH/2,screen.height/2,WIDTH/960)
    return shared(o,render)
end
function P.hud(alpha)
    SetViewMode('ui')
    local w=lstg.world
    local x,y=w.scrl+18,w.scrb+24
    local count=GameDrops.bombsEnabled() and ((GameNet and GameNet.host()) and 2 or 1) or 0
    local lives=ui.RunHUD.lives()
    -- 左下角竖排，生命在上、Bomb在下；一颗星配阿拉伯数字。
    local lifeY=y+count*30
    GameDrops.renderStar('star_big2',x,lifeY,20,1,alpha)
    label('x'..lives,x+17,lifeY,.85,alpha,{255,110,120},'left')
    for slot=1,count do
        local bombs=GameDrops.bombState(slot)
        local bombY=y+(count-slot)*30
        GameDrops.renderStar('star_big10',x,bombY,20,1,alpha)
        label((count==2 and 'P'..slot..' ' or '')..'x'..bombs,x+17,bombY,.85,alpha,{110,235,145},'left')
    end
    if not lstg.var.rogue_run then
        label(stage.current_stage.level or 1,(w.scrl+w.scrr)/2,w.scrt-28,3,alpha,{230,241,250})
        label('×1',w.scrr-14,w.scrt-28,1,alpha,{230,241,250},'right')
    end
end
function P.pauseButton()
    local w=lstg.world
    return w.scrl+32,w.scrt-28
end
function P.roguePanel(run)
    local previous=lstg.viewmode
    SetViewMode('ui')
    local w=lstg.world
    label(math.max(1,math.floor(run.current or 1)),(w.scrl+w.scrr)/2,w.scrt-28,3,255,{230,241,250})
    if GameHPScale then GameHPScale.render(w.scrr-14,w.scrt-28,165,44,'right') end
    if previous then SetViewMode(previous) end
end
function P.result(o)
    P.background(1)
    ui.RunHUD.stage(o.run.current or o.run.completed,WIDTH/2,screen.height/2,WIDTH-48)
    for i,entry in ipairs({{'返回标题 ESC',27},{'再来一局 ENTER',13}}) do
        local key=entry[2];local y=170-(i-1)*64
        rect(160,380,y-20,y+20,255,29,64,85)
        label(entry[1],WIDTH/2,y,.8,255,{225,241,250})
        control(o,160,380,y-28,y+28,function() pulse(key) end)
    end
end
return P
