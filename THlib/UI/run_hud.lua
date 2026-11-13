-- 战斗UI只呈现剩余资源和成长：星形表示库存，火力用自动扩展的对数刻度，其余属性用线性条。
-- 所有查询保持只读，渲染不能建立成长状态或改变录像的零帧初态。
local H={}
local ATTRIBUTE_OPACITY=.5
local colors={red={255,110,120},blue={110,190,255},green={110,235,145}}
local function color(alpha,rgb) return Color(alpha,rgb[1],rgb[2],rgb[3]) end
local function number(value) return (('%.2f'):format(value):gsub('%.?0+$','')) end
local function text(value,x,y,scale,alpha,rgb,...)
    ui:RenderText('title',tostring(value),x,y,scale,color(alpha,rgb),...)
end
function H.track(x1,x2,y,fraction,alpha,rgb,divisions)
    local barAlpha=alpha*ATTRIBUTE_OPACITY
    SetImageState('white','',Color(barAlpha*.65,30,42,55))
    RenderRect('white',x1,x2,y-5,y+5)
    local fill=math.max(0,math.min(1,fraction))
    if fill>0 then
        SetImageState('white','',color(barAlpha,rgb))
        RenderRect('white',x1,x1+(x2-x1)*fill,y-5,y+5)
    end
    -- 线性条均分量程；火力另画十进制对数刻度，不把增长后的值截在原上限。
    SetImageState('white','',Color(barAlpha*.45,5,12,20))
    for i=1,(divisions or 10)-1 do
        local x=x1+(x2-x1)*i/(divisions or 10)
        RenderRect('white',x-.5,x+.5,y-5,y+5)
    end
end
local LOG10=math.log(10)
function H.powerAxis(value)
    if value==math.huge then return 309 end -- 浮点溢出时仍能绘制末端刻度，不能用无穷步长循环。
    return math.max(3,math.ceil(math.log(math.max(1,value))/LOG10-1e-12))
end
function H.powerTrack(x1,x2,y,value,alpha,decades)
    decades=decades or H.powerAxis(value)
    local rgb=(GameDrops and GameDrops.palette or colors).red
    H.track(x1,x2,y,math.log(math.max(1,value))/LOG10/decades,alpha,rgb,1)
    local divisions=math.max(2,math.floor((x2-x1)/64))
    local step=math.max(1,math.ceil(decades/divisions))
    local function tick(exponent)
        local x=x1+(x2-x1)*exponent/decades
        SetImageState('white','',Color(alpha*ATTRIBUTE_OPACITY*.6,5,12,20))
        RenderRect('white',x-.5,x+.5,y-5,y+5)
        local label=exponent<=4 and ('%.0f'):format(10^exponent) or '10^'..exponent
        text(label,x,y-11,.5,alpha*ATTRIBUTE_OPACITY,rgb,exponent==0 and 'left' or exponent==decades and 'right' or 'center','vcenter')
    end
    for exponent=0,decades,step do tick(exponent) end
    if decades%step~=0 then tick(decades) end
end
function H.attributes(scrr,scrt,alpha,layout)
    if lstg.var.__sequence_version==1 then return end
    local D=GameDrops
    if not D or not D.enabled() then return end
    local palette=D.palette or colors
    local count=(GameNet and GameNet.host()) and 2 or 1
    -- 横屏左侧纵排；竖屏只传列数与边界，量程、颜色和透明度共用。
    local left,right=layout and layout.left or 18,layout and layout.right or lstg.world.scrl-18
    local y=layout and layout.top or scrt-4
    local columns=layout and layout.columns or 1
    local gutter=layout and layout.gutter or 0
    local width=(right-left-(columns-1)*gutter)/columns
    local gap=62
    local rows={{'火力','red',D.MAX/D.UNIT},{D.bombsEnabled() and 'Bomb恢复速度' or '射速','blue',D.MAX/D.UNIT},{'判定','green',100}}
    for i,row in ipairs(rows) do
        local x1=left+(i-1)%columns*(width+gutter)
        local x2=x1+width
        local cy=y-math.floor((i-1)/columns)*gap
        text(row[1],x1,cy+20,.7,alpha*ATTRIBUTE_OPACITY,palette[row[2]],'left','vcenter')
        -- 双人栏共用量程，不能把两位玩家不同的火力画成相同长度。
        local powerMax=math.max(D.values(1),count==2 and D.values(2) or 1)
        local decades=i==1 and H.powerAxis(powerMax)
        for slot=1,count do
            local values={D.values(slot)}
            local left=x1+(slot-1)*(x2-x1+12)/count
            local right=left+(x2-x1-(count-1)*12)/count
            if i==1 then H.powerTrack(left,right,cy,values[i],alpha,decades)
            else H.track(left,right,cy,values[i]/row[3],alpha,palette[row[2]]) end
            local value=number(values[i])..(i==3 and '%' or '')
            if count==2 then value='P'..slot..' '..value end
            local scale=math.min(.7,(right-left-8)/(#value*11))
            text(value,(left+right)/2,cy-(i==1 and 27 or 20),scale,alpha*ATTRIBUTE_OPACITY,palette[row[2]],'centerpoint')
        end
    end
end
function H.lives()
    local native=SequenceResources and SequenceResources.state()
    if native then return math.max(0,native.lives+1),9 end
    local s=stage.current_stage
    local limit=lstg.var.rogue_run and RogueTen.MISS_LIMIT or s.AllowMissCount or 10
    local misses=GameRevive and GameRevive.misses() or lstg.var.dead or 0
    return math.max(0,limit-misses),limit
end
function H.resources(x1,x2,top,alpha)
    if SequenceResources and SequenceResources.enabled() then return H.original(x1,x2,top,alpha) end
    local native=NativePlayers and NativePlayers.state()
    if native then
        local m=NativePlayers.machine(native.level,lstg.var.native_player_id)
        local lives=(native.level==36 or native.level>=38) and math.max(0,native.life) or math.max(0,math.floor(native.life/5))
        local rows={{'机体',m.name},{'分数',('%010d'):format(lstg.var.score)},
            {native.level==36 and '生命' or '残机',lives}}
        if native.level>=38 then
            rows[#rows+1]={native.level==40 and 'Mental' or 'Bomb',native.bombs}
            if native.level==38 then
                rows[#rows+1]={'火力',native.power..' / 400'}
                rows[#rows+1]={'星屑',native.star..' / 3000'}
            elseif native.level==39 then
                rows[#rows+1]={'残机碎片',('%d / 4'):format(native.lifeChip*4)}
                rows[#rows+1]={'染色连锁',native.dyeChain}
            else
                rows[#rows+1]={'Dream',('%d%%'):format(math.max(0,lstg.var.like_dreamer_special_gauge or 0)/500)}
            end
        elseif native.level==36 then
            rows[#rows+1]={'残机碎片',native.fragments..' / '..NativePlayers.lifeThreshold(native)}
            rows[#rows+1]={'结界',NativePlayers.barriers(native)..' / 3'}
            rows[#rows+1]={'结界能量',('%d%%'):format(math.floor((native.barrier+1)/1000))}
        else
            rows[#rows+1]={'残机碎片',math.max(0,native.life)%5 .. ' / 5'}
            rows[#rows+1]={'Bomb',math.floor(native.bombs/5)}
            rows[#rows+1]={'Bomb 碎片',native.bombs%5 .. ' / 5'}
            if native.level==35 then rows[#rows+1]={'火力',native.power..' / 400'} end
        end
        for i,row in ipairs(rows) do
            local y=top-(i-1)*23
            text(row[1],x1,y,.69,alpha,colors.blue,'left','vcenter')
            text(row[2],x2,y,.69,alpha,colors.red,'right','vcenter')
        end
        return
    end
    local lives,limit=H.lives()
    text('生命',x1,top,.8,alpha,colors.red,'left','vcenter')
    text(lives,x2,top,.8,alpha,colors.red,'right','vcenter')
    local slots=math.min(limit,10)
    for i=1,slots do
        GameDrops.renderStar('star_big2',x1+(i-.5)*(x2-x1)/slots,top-28,23,1,alpha*(i<=lives and 1 or .18))
    end
    if GameDrops.bombsEnabled() then
        local count=(GameNet and GameNet.host()) and 2 or 1
        GameDrops.renderBombs(x1,x2,top-60,alpha,count)
    end
end
function H.draw(scrr,scrt,alpha)
    H.resources(scrr+18,942,scrt-16,alpha)
    if SequenceResources and SequenceResources.enabled() then return end
    if GameDrops then GameDrops.renderHUD(scrr,scrt,alpha) end
end
function H.original(x1,x2,top,alpha)
    local P=SequenceResources;local s=P.state();if not s then return end
    local m=P.machine(s.game,s.machine)
    local rows={{'机体',m.name},{'分数',('%010d'):format(lstg.var.score)},{'残机',math.max(0,s.lives)},
        {s.game==10 and '灵击 / 火力' or '火力',s.game==10 and ('%.2f / 5.00'):format(s.power/20) or s.power..' / 128'}}
    if s.game==95 then rows={{'机体',m.name},{'分数',('%010d'):format(lstg.var.score)},{'剩余尝试',math.max(0,s.lives+1)}} end
    if s.game~=10 and s.game~=95 then rows[#rows+1]={'Bomb',s.bombs} end
    rows[#rows+1]={'擦弹',lstg.var.graze}
    if s.game==7 then
        rows[#rows+1]={'樱点',s.cherry..' / '..s.cherry_max};rows[#rows+1]={'樱点＋',s.cherry_plus..' / 50000'}
        if s.border>0 then rows[#rows+1]={'森罗结界',('%.1f 秒'):format(s.border/60)} end
    elseif s.game==8 then rows[#rows+1]={'刻符',s.time};rows[#rows+1]={'人妖率',('%+.0f%%'):format(s.human)}
    elseif s.game==10 then rows[#rows+1]={'信仰',s.faith};rows[#rows+1]={'信仰槽',s.faith_timer..' / 130'} end
    for i,row in ipairs(rows) do
        local y=top-(i-1)*32
        text(row[1],x1,y,.65,alpha,{170,190,210},'left','vcenter')
        text(row[2],x2,y,i==1 and .5 or .65,alpha,{235,240,255},'right','vcenter')
    end
end
function H.stage(value,x,y,width,maxScale)
    local label=tostring(math.max(1,math.floor(value or 1)))
    local scale=math.min(maxScale or 8,(width-24)/(#label*16))
    text(label,x,y,scale,255,{230,241,250},'centerpoint')
end
return H
