-- 顺序模式使用原作front/ascii的像素与动画；竖屏只重排这些组件。
-- 界面对象只读取资源账本；动画状态留在stage对象，不写入存档或录像初态。
local H={}
local A=OriginalANM
local floor,min,max=math.floor,math.min,math.max
local WHITE={255,255,255}
function H.enabled(scene)
    scene=scene or stage.current_stage
    return scene and not scene.is_menu and SequenceResources and SequenceResources.state()
        and screen.width>screen.height and not (AndroidPortrait and AndroidPortrait.enabled())
end
function H.layout(scene)
    local w=lstg.world
    if screen.width<=screen.height or AndroidPortrait and AndroidPortrait.enabled() then
        H.shifted=false
        if AndroidPortrait and AndroidPortrait.enabled() then AndroidPortrait.layoutWorld() end
        return
    end
    if H.enabled(scene) then
        local left=SequenceResources.game()==95 and 128 or 32
        w.scrl,w.scrr=(screen.width-640)/2+left,(screen.width-640)/2+left+384
        w.scrb,w.scrt=(screen.height-480)/2+16,(screen.height-480)/2+464
        H.shifted=true
    elseif H.shifted then
        local d=GetDefaultWorld()
        w.scrl,w.scrr,w.scrb,w.scrt=d.scrl,d.scrr,d.scrb,d.scrt
        H.shifted=false
    end
end
local view
local function origin()
    if view then return view.x,view.y end
    return (screen.width-640)/2,(screen.height+480)/2
end
local function withView(x,y,scale,draw)
    local previous=view;view={x=x,y=y,scale=scale};draw();view=previous
end
local function draw(v,x,y,alpha)
    local ox,oy=origin()
    local scale=view and view.scale or 1
    local position=v.position
    if view then v.position={position[1]*scale,position[2]*scale,position[3]} end
    A.draw(v,ox+(x or 0)*scale,oy-(y or 0)*scale,0,scale,scale,alpha or 1)
    v.position=position
end
local function at(v,x,y,alpha)
    -- tile/库存VM由原作Gui逐个指定坐标；保留ANM其余属性。
    local old=v.position;v.position={x,y,0};draw(v,0,0,alpha);v.position=old
end
local function sprite(game,archive,id,x,y,sx,sy,rgb,alpha)
    local data=A.load(game,archive)
    local s=A.sprite_resource{data=data,sprite=id}
    local ox,oy=origin();sx,sy=sx or 1,sy or sx or 1;rgb=rgb or WHITE
    local scale=view and view.scale or 1
    SetImageState(s.img,'',Color(alpha or 255,rgb[1],rgb[2],rgb[3]))
    Render(s.img,ox+(x+s[4]*sx/2)*scale,oy-(y+s[5]*sy/2)*scale,0,sx*scale,sy*scale)
end
local function croppedSprite(game,archive,id,x,y,width,height)
    local s=A.sprite_resource{data=A.load(game,archive),sprite=id}
    local fit=max(width/s[4],height/s[5])
    local cw,ch=width/fit,height/fit
    local u,v=s[2]+(s[4]-cw)/2,s[3]
    local ox,oy=origin();local scale=view and view.scale or 1
    local l,r,t,b=ox+x*scale,ox+(x+width)*scale,oy-y*scale,oy-(y+height)*scale
    local color=Color(255,255,255,255)
    RenderTexture(s.tex,'',{l,t,.5,u,v,color},{r,t,.5,u+cw,v,color},
        {r,b,.5,u+cw,v+ch,color},{l,b,.5,u,v+ch,color})
end
local function text(game,value,x,y,sx,sy,rgb,alpha)
    value=tostring(value);sx,sy=sx or 1,sy or 1
    local offset=game==6 and -21 or (game==7 or game==8) and -1 or -32
    local advance=(game==6 and 14 or game==7 and 14 or game==8 and 13 or 14)*sx
    for i=1,#value do
        local c=value:byte(i)
        if c~=32 then sprite(game,'ascii',c+offset,x,y,sx,sy,rgb,alpha) end
        x=x+advance
    end
end
local function digits(game,value,x,y,count,rgb,scale,alpha,step)
    local base=game==7 and 132 or 136
    local str=('%0'..count..'d'):format(max(0,floor(value)))
    scale=scale or 1
    local leading=true
    for i=1,#str do
        local id=base+tonumber(str:sub(i,i));local s=A.load(game,'ascii').sprites[id]
        -- AsciiManager的数字VM以中心定位；底部Cherry面板本身才以左上角定位。
        if str:sub(i,i)~='0' or i==#str then leading=false end
        if not leading then sprite(game,'ascii',id,x+(i-1)*(step or 7*scale)-s[4]*scale/2,y-s[5]*scale/2,scale,scale,rgb,alpha) end
    end
end
local function rect(x1,x2,y1,y2,rgb,alpha)
    local ox,oy=origin();rgb=rgb or WHITE
    local scale=view and view.scale or 1
    SetImageState('white','',Color(alpha or 255,rgb[1],rgb[2],rgb[3]))
    RenderRect('white',ox+x1*scale,ox+x2*scale,oy-y2*scale,oy-y1*scale)
end
local function powerBar(game,power,x,y)
    -- 红妖永的Gui直接画128像素火力条，颜色和16像素高度来自原作四顶点。
    if power>0 then rect(x,x+power,y,y+16,{224,224,255},180) end
    text(game,power>=128 and 'MAX' or power,x,y)
end
local function pointThreshold(s)
    local n=s.extends
    local extra=not lstg.var.sequence_key:find('lunatic',1,true)
    if s.game==7 then
        if extra then return n==0 and 200 or n==1 and 500 or 800+(n-2)*500 end
        return n<3 and 50+n*75 or n<5 and 300+(n-3)*150 or 800+(n-5)*200
    end
    return (extra and {200,666,9999} or {100,250,500,800,1100,9999})[n+1] or 99999
end
function H.timeThreshold(s)
    -- TH08 GameManager.cpp的g_TimeRequirementParams，顺序入口只提供Lunatic/Extra。
    if not lstg.var.sequence_key:find('lunatic',1,true) then return 0 end
    return ({['1']=3000,['2']=7200,['3']=8800,['4A']=9999,['4B']=8500,['5']=9999,['6A']=0,['6B']=0})[s.stage_name or '1'] or 0
end
local function add(o,key,v) o[key]=v;o.vms[#o.vms+1]=v;return v end
local function newUI(o)
    local game=SequenceResources.game();o.game,o.vms,o.front=game,{},{}
    if AndroidPortrait and AndroidPortrait.enabled() then
        o.random={seed=((lstg.var.ran_seed or 1)+game*3571)%2147483646+1}
        function o.random:Float(a,b) self.seed=self.seed*16807%2147483647;return a+(b-a)*self.seed/2147483647 end
        function o.random:Int(a,b) return min(b,floor(self:Float(a,b+1))) end
    end
    local function vm(g,archive,index) return A.new(g,archive,index,nil,nil,o.random) end
    local n=game==6 and 23 or game==7 and 13 or game==8 and 15 or game==95 and 3 or 1
    for i=0,n do o.front[i]=add(o,'front'..i,vm(game,'front',i)) end
    if game==7 then
        add(o,'cherry',vm(7,'ascii',4));A.interrupt(o.cherry,1)
        add(o,'border',vm(7,'ascii',5))
    elseif game==8 then
        for i=5,8 do local v=add(o,'gauge'..i,vm(8,'ascii',i));A.interrupt(v,1) end
        local m=SequenceResources.machine(8,SequenceResources.state().machine)
        local lo,hi=-10000,10000
        if m.id=='team3' then lo=-5000 elseif m.id=='solo3' then lo,hi=-5000,5000
        elseif m.id:sub(1,4)=='solo' then if m.shot==0 then hi=2000 else lo=-2000 end end
        o.gauge6.position[1]=o.gauge6.position[1]+lo*56/10000
        o.gauge7.position[1]=o.gauge7.position[1]+hi*56/10000
        add(o,'difficulty',vm(8,'ascii',25));A.interrupt(o.difficulty,1)
        o.difficulty.sprite=lstg.var.sequence_key:find('lunatic',1,true) and 286 or 287
        add(o,'clock',vm(8,'times',2))
    elseif game==10 then
        o.high,o.score,o.life,o.power,o.faith={},{},{},{},{}
        for i=0,9 do o.high[i]=add(o,'high'..i,vm(10,'front',10+i));o.score[i]=add(o,'score'..i,vm(10,'front',20+i)) end
        for i=0,8 do o.life[i]=add(o,'life'..i,vm(10,'front',30+i)) end
        for i=0,3 do o.power[i]=add(o,'power'..i,vm(10,'front',47+i)) end
        for i=0,6 do o.faith[i]=add(o,'faith'..i,vm(10,'front',51+i)) end
    end
end
H.controller=Class(object,{
    init=function(o)
        o.group,o.layer,o.hide,o.bound=GROUP.GHOST,LAYER.TOP,true,false
        o.scene=stage.current_stage;o.scene.original_ui=o;newUI(o)
    end,
    frame=function(o)
        if not H.enabled() and not (AndroidPortrait and AndroidPortrait.enabled() and SequenceResources.state()) then return end
        -- TH07只在初始化时执行cherryBorderActive；逐帧播放会把标签放大到数字上。
        for _,v in ipairs(o.vms) do if v~=o.border then A.step(v,1) end end
        local s=SequenceResources.state()
        local faded=player and player.y < -176 and player.x < -96
        if faded~=o.faded then
            o.faded=faded
            if o.cherry then A.interrupt(o.cherry,faded and 2 or 3) end
            if o.gauge5 then for i=5,8 do A.interrupt(o['gauge'..i],faded and 2 or 3) end end
            if o.faith then for i=0,6 do A.interrupt(o.faith[i],faded and 3 or 2) end end
        end
        if o.clock then o.clock.sprite=max(0,min(15,floor(s.clock or 0))) end
    end,
})
function H.start()
    H.layout()
    if SequenceResources.state() then return New(H.controller) end
end
local function current()
    local scene=stage.current_stage
    return scene and scene.original_ui
end
function H.frame()
    H.layout()
    if not H.enabled() then return false end
    local o=current();if not o then return false end
    SetViewMode('ui')
    SetImageState('white','',Color(255,0,0,0));RenderRect('white',0,screen.width,0,screen.height)
    local g,f=o.game,o.front
    if g==6 then
        for y=0,463,32 do at(f[6],0,y) end
        for x=416,623,32 do for y=0,463,32 do at(f[6],x,y) end end
        for x=32,415,32 do at(f[7],x,0);at(f[8],x,464) end
        for _,i in ipairs({5,0,1,3,4,2,9,10,11,12,13,14,15}) do draw(f[i]) end
    elseif g==7 or g==8 then
        local tile,edge=g==7 and f[12] or f[13],g==7 and f[13] or f[14]
        for y=0,463,32 do at(tile,0,y) end
        for x=416,623,32 do for y=16,463,32 do at(tile,x,y) end end
        for x=0,623,128 do at(edge,x,0);at(edge,x,464) end
        for i=0,(g==7 and 8 or 9) do draw(f[i]) end
        if o.difficulty then draw(o.difficulty) end
    else for i=0,(g==95 and 3 or 1) do draw(f[i]) end end
    SetViewMode('world');return true
end
local function legacyPanel(o,s)
    local g,f=o.game,o.front
    local scoreX,highY,scoreY,inventoryX,lifeY,bombY,powerY,grazeY,pointY
    if g==6 then scoreX,highY,scoreY,inventoryX,lifeY,bombY,powerY,grazeY,pointY=496,58,82,496,122,146,186,206,226
    elseif g==7 then scoreX,highY,scoreY,inventoryX,lifeY,bombY,powerY,grazeY,pointY=496,48,64,496,96,112,144,160,176
    else scoreX,highY,scoreY,inventoryX,lifeY,bombY,powerY,grazeY,pointY=488,40,56,488,88,104,136,152,168 end
    local score=max(0,floor(lstg.var.score or 0));local high=max(score,lstg.tmpvar.hiscore or 0)
    text(g,('%09d'):format(high),scoreX,highY,g==7 and .9 or 1)
    text(g,('%09d'):format(score),scoreX,scoreY,g==7 and .9 or 1)
    local life,bomb=g==6 and f[16] or g==7 and f[9] or f[10],g==6 and f[17] or g==7 and f[10] or f[11]
    for i=0,max(0,s.lives)-1 do at(life,inventoryX+16*i,lifeY) end
    for i=0,max(0,s.bombs)-1 do at(bomb,inventoryX+16*i,bombY) end
    powerBar(g,s.power,scoreX,powerY)
    text(g,lstg.var.graze or 0,scoreX,grazeY)
    text(g,g==6 and s.stage_points or s.points..'/'..pointThreshold(s),scoreX,pointY)
    if g==8 then text(g,s.time..'/'..H.timeThreshold(s),scoreX,184) end
end
local function cherry(o,s)
    draw(o.cherry)
    local p=o.cherry.position;local alpha=o.cherry.alpha[1]
    local tint=s.cherry==s.cherry_max and {255,208,128} or s.cherry>=50000 and {255,255,128} or WHITE
    digits(7,s.cherry,p[1]+46,p[2]+11,6,tint,1,alpha)
    digits(7,s.cherry_max,p[1]+97,p[2]+11,6,{240,208,224},1,alpha)
    local color,scale={192,128,176},1
    if s.border>0 then
        local pulse=s.cherry_plus%4000;if pulse>=2000 then pulse=4000-pulse end
        local c=s.cherry_plus*192/50000+pulse*64/2000;color={255,c,c};scale=1.41
    end
    digits(7,s.cherry_plus,p[1]+53+(s.border>0 and 2 or 0),p[2]+2-(s.border>0 and 2 or 0),5,color,scale,alpha,s.border>0 and 10 or 7)
    if s.border>0 then at(o.border,p[1]+24,p[2]+8,alpha/255) end
end
local function humanGauge(o,s,withoutClock)
    local p=o.gauge5.position
    local color=s.human<=SequenceResources.humanThreshold() and {112,112,255} or s.human<=-20 and {176,176,255}
        or s.human>=SequenceResources.youkaiThreshold() and {255,112,112} or s.human>=20 and {255,176,176} or WHITE
    o.gauge5.color=color;o.gauge8.position[1]=p[1]+64+s.human*.56
    for i=5,8 do draw(o['gauge'..i]) end
    text(8,('%+.2f%%'):format(s.human),p[1]+64+s.human*.4-22,o.gauge8.position[2]-7,.5,.7,color,o.gauge5.alpha[1])
    digits(8,lstg.var.pointrate or 0,p[1]+48,p[2]+11,6,WHITE,1,o.gauge5.alpha[1])
    if not withoutClock then draw(o.clock) end
end
local function faithPanel(o,s)
    local value=floor(s.faith/10)
    for i=5,1,-1 do o.faith[i].sprite=value%10+30;value=floor(value/10) end
    for i=0,6 do draw(o.faith[i]) end
    if s.faith_timer>0 then
        local alpha=o.faith[0].alpha[1]
        rect(51,51+s.faith_timer*.29230770468711853,461,463,{0,0,0},alpha)
        rect(50,50+s.faith_timer*.29230770468711853,460,462,WHITE,alpha)
    end
end
local function modernPanel(o,s)
    local values={max(lstg.var.score or 0,lstg.tmpvar.hiscore or 0),lstg.var.score or 0}
    for n,list in ipairs({o.high,o.score}) do
        local value=floor(values[n]/10);list[0].sprite=8
        for i=1,9 do list[i].sprite=value%10+8;value=floor(value/10) end
        for i=0,9 do draw(list[i]) end
    end
    for i=0,8 do if i<s.lives then draw(o.life[i]) end end
    local value=floor(s.power%20*5)
    o.power[0].sprite=floor(s.power/20)+8;o.power[2].sprite=floor(value/10)+8;o.power[3].sprite=value%10+8
    for i=0,3 do draw(o.power[i]) end
    faithPanel(o,s)
end
function H.draw()
    if not H.enabled() then return false end
    local o=current();if not o then return false end
    SetViewMode('ui')
    local s=SequenceResources.state()
    if o.game==6 or o.game==7 or o.game==8 then legacyPanel(o,s) end
    if o.game==7 then cherry(o,s) elseif o.game==8 then humanGauge(o,s)
    elseif o.game==10 then modernPanel(o,s)
    elseif o.game==95 then text(95,('%010d'):format(lstg.var.score or 0),130,466,.65,.65) end
    H.drawBoss(o)
    text(o.game,('%.2ffps'):format(GetFPS()),520,464,.85,.85)
    SetViewMode('world');return true
end
function H.drawBoss(o)
    if o.game==95 then return end
    local g=o.game
    for _,b in ipairs(boss_group or {}) do
        if IsValid(b) and not b._sequence_road_carrier and b.is_combat and not b.__is_waiting then
            local hp=max(0,min(1,b.hp/max(1,b.maxhp or b.hp)))
            local left,width=g==6 and 96 or g==10 and 40 or 64,g==6 and 288 or g==10 and 342 or 320
            if g==6 then
                local bar=o.front[21];local old,anchor=bar.scale,bar.anchor
                bar.scale,bar.anchor={hp*288/14,.3},1;at(bar,96,24);bar.scale,bar.anchor=old,anchor
                draw(o.front[19])
            elseif g==10 then
                rect(left+1,left+1+width*hp,23,25,{0,0,0});rect(left,left+width*hp,22,24,WHITE)
            else
                rect(left,left+width,19,23,{32,32,96})
                for y=0,3 do local c=255-y*65;rect(left,left+width*hp,19+y,20+y,{max(32,c),max(32,c),max(96,c)}) end
            end
            text(g,max(0,b.sc_left or 0),g==6 and 80 or 48,16,1,1,{255,255,128})
            local time=max(0,min(99,floor(b.countdown or 0)))
            text(g,('%02d'):format(time),384,16,1,1,time<10 and {255,96,96} or WHITE)
            local ox,oy=origin()
            ui:RenderText('title',b.name or '',ox+32,oy-38,.55,Color(255,255,255,255),'left','top')
            local card=b.current_card
            if card and card.is_sc then
                local bg=g==6 and 22 or g==7 and 129 or g==8 and 133 or 228
                local arc=g==6 and 'front' or 'ascii'
                local s=A.load(g,arc).sprites[bg]
                sprite(g,arc,bg,144,40,256/s[4],32/s[5],WHITE,180)
                ui:RenderText('title',card.name or '',ox+400,oy-44,.6,Color(255,255,255,255),'right','top')
                local history=b._sc_hist or {0,0}
                text(g,b.sc_bonus and ('Bonus '..floor(b.sc_bonus/10)*10) or 'Bonus Failed',216,61,.55,.55)
                text(g,('%02d/%02d'):format(min(99,history[1]),min(99,history[2])),358,61,.5,.55)
            end
            local x=(g==95 and 128 or 32)+b.x+192
            local id=g==7 and 144 or g==8 and 157 or g==10 and 231
            local marker=id and A.load(g,'ascii').sprites[id]
            if marker then sprite(g,'ascii',id,x-marker[4]/2,464,1,1) end
        end
    end
end
dofile('THlib/UI/original_portrait.lua')(H,{view=withView,sprite=sprite,crop=croppedSprite,text=text,rect=rect,at=at,
    cherry=cherry,human=humanGauge,faith=faithPanel,current=current,pointThreshold=pointThreshold})
return H
