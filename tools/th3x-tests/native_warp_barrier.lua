-- 正式引擎的方框/反向背景观测。只读效果状态，不替换发弹或移动。
local T=OriginalStageVisual.presentation
local F
for i=1,20 do
    local name,value=debug.getupvalue(T.new_effect,i)
    if name=='F' then F=value;break end
end
assert(F)
local result={cards={},draws=0,background=0,cleaned=false}
local current
local function save()
    local f=assert(io.open('warp-result.json','w'));f:write(Serialize(result));f:close()
end
local render=RenderTexture
RenderTexture=function(tex,blend,...)
    if current and tex:find('original/8/etama/',1,true) then result.draws=result.draws+1 end
    return render(tex,blend,...)
end
local background=T.draw_warp_background
T.draw_warp_background=function(owner,vms)
    if F.warp and F.warp.phase==owner then result.background=result.background+1 end
    return background(owner,vms)
end
local clear=T.clear
T.clear=function(owner)
    clear(owner)
    if current and current.phase==owner then
        assert(not F.warp,'换卡后不能残留结界')
        result.cleaned=true;current=nil;save()
    end
end
return function(owner,frames,card)
    local id=tostring(card.cardId)
    local row=result.cards[id]
    if not row then row={};result.cards[id]=row end
    local w=F.warp
    if w and w.phase==owner then
        current=w
        row.first=row.first or frames
        if frames==300 or frames==900 then
            local outer,inner=w.effects[1],w.effects[2]
            assert(IsValid(outer) and IsValid(inner),'方框效果必须存活')
            assert(outer.geometry.count==4 and inner.geometry.count==4,'两层方框必须各有四个顶点')
            row['frame'..frames]={outer=outer.geometry.radius,inner=inner.geometry.radius,
                x=outer.x,y=outer.y,script=outer.vm.id,uv=outer.vm.v}
            save()
        end
    end
end
