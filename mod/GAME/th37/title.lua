-- Title.cs：关卡标题与副标题分别淡入，主标题从二倍缩放回到原尺寸。
local ready=false
local function load()
    if ready then return end
    local pool=GetResourceStatus();SetResourceStatus('global')
    LoadTexture('mhj2_stage_title','Resources/th37/stagetitle.png')
    for stage=1,8 do
        local x=(stage-1)%2*380
        local y=math.floor((stage-1)/2)*120
        LoadImage('mhj2_stage_title_'..stage,'mhj2_stage_title',x,y,380,93)
        SetImageCenter('mhj2_stage_title_'..stage,190,45)
        LoadImage('mhj2_stage_tip_'..stage,'mhj2_stage_title',x,y+93,380,30)
        SetImageCenter('mhj2_stage_tip_'..stage,190,15)
    end
    SetResourceStatus(pool);ready=true
end
local Title=Class(object,{
    init=function(o,stage)
        load();o.stage=stage;o.clock=0;o.scale=2;o.alpha,o.tipalpha=0,0
        o.group,o.layer,o.bound=GROUP.GHOST,LAYER.TOP-10,false
    end,
    frame=function(o)
        o.clock=o.clock+1;local t=o.clock
        if t>=1 and t<=25 then o.alpha=o.alpha+.04 end
        if t>=25 and t<=75 then o.tipalpha=o.tipalpha+.02 end
        if t>=200 and t<=250 then o.alpha=o.alpha-.02 end
        if t>=250 and t<=300 then o.tipalpha=o.tipalpha-.02 end
        o.scale=o.scale+(1-o.scale)/20
        if t>300 then object.RawDel(o) end
    end,
    render=function(o)
        local title,tip='mhj2_stage_title_'..o.stage,'mhj2_stage_tip_'..o.stage
        if o.alpha>0 then
            SetImageState(title,'',math.min(255,o.alpha*255),255,255,255)
            Render(title,2,67,0,o.scale,o.scale)
        end
        if o.tipalpha>0 then
            SetImageState(tip,'',math.min(255,o.tipalpha*255),255,255,255)
            Render(tip,2,10)
        end
    end,
})
return function(stage) return New(Title,stage) end
