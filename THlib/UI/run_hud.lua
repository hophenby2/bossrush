-- 战斗UI只呈现剩余资源和成长：星形表示库存，固定量程的条表示属性。
-- 所有查询保持只读，渲染不能建立成长状态或改变录像的零帧初态。
local H={}
local colors={red={255,110,120},blue={110,190,255},green={110,235,145}}
local function color(alpha,rgb) return Color(alpha,rgb[1],rgb[2],rgb[3]) end
local function number(value) return (('%.2f'):format(value):gsub('%.?0+$','')) end
local function text(value,x,y,scale,alpha,rgb,...)
    ui:RenderText('title',tostring(value),x,y,scale,color(alpha,rgb),...)
end
function H.track(x1,x2,y,fraction,alpha,rgb,divisions)
    SetImageState('white','',Color(alpha*.65,30,42,55))
    RenderRect('white',x1,x2,y-5,y+5)
    local fill=math.max(0,math.min(1,fraction))
    if fill>0 then
        SetImageState('white','',color(alpha,rgb))
        RenderRect('white',x1,x1+(x2-x1)*fill,y-5,y+5)
    end
    -- 红蓝每格100，对应真实上限1000；刻度不随当前值改变，升级时长度才能直接比较。
    SetImageState('white','',Color(alpha*.45,5,12,20))
    for i=1,(divisions or 10)-1 do
        local x=x1+(x2-x1)*i/(divisions or 10)
        RenderRect('white',x-.5,x+.5,y-5,y+5)
    end
end
function H.attributes(scrr,scrt,alpha)
    local D=GameDrops
    if not D or not D.enabled() then return end
    local count=(GameNet and GameNet.host()) and 2 or 1
    local x1,x2=scrr+18,942
    local y=scrt-(count==2 and 184 or 160)
    local gap=count==2 and 64 or 71
    local rows={{'火力','red',D.MAX/D.UNIT},{D.bombsEnabled() and 'Bomb恢复速度' or '射速','blue',D.MAX/D.UNIT},{'判定','green',100}}
    for i,row in ipairs(rows) do
        local cy=y-(i-1)*gap
        text(row[1],x1,cy+20,.7,alpha,colors[row[2]],'left','vcenter')
        for slot=1,count do
            local values={D.values(slot)}
            local left=x1+(slot-1)*(x2-x1+12)/count
            local right=left+(x2-x1-(count-1)*12)/count
            H.track(left,right,cy,values[i]/row[3],alpha,colors[row[2]])
            local value=number(values[i])..(i==3 and '%' or '')
            if count==2 then value='P'..slot..' '..value end
            text(value,(left+right)/2,cy-20,.7,alpha,colors[row[2]],'centerpoint')
        end
    end
end
function H.lives()
    local s=stage.current_stage
    local limit=lstg.var.rogue_run and RogueTen.MISS_LIMIT or s.AllowMissCount or 10
    local misses=GameRevive and GameRevive.misses() or lstg.var.dead or 0
    return math.max(0,limit-misses),limit
end
function H.draw(scrr,scrt,alpha)
    local x1,x2=scrr+18,942
    local lives,limit=H.lives()
    text('生命',x1,scrt-16,.8,alpha,colors.red,'left','vcenter')
    text(lives,x2,scrt-16,.8,alpha,colors.red,'right','vcenter')
    local slots=math.min(limit,10)
    for i=1,slots do
        GameDrops.renderStar('star_big2',x1+(i-.5)*(x2-x1)/slots,scrt-44,23,1,alpha*(i<=lives and 1 or .18))
    end
    if GameDrops.bombsEnabled() then
        local count=(GameNet and GameNet.host()) and 2 or 1
        GameDrops.renderBombs(x1,x2,scrt-76,alpha,count)
    end
    if GameDrops then GameDrops.renderHUD(scrr,scrt,alpha) end
end
function H.stage(value,x,y,width)
    local label=tostring(math.max(1,math.floor(value or 1)))
    local scale=math.min(8,(width-24)/(#label*16))
    text(label,x,y,scale,255,{230,241,250},'centerpoint')
end
return H
