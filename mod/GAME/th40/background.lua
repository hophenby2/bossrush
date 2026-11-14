-- 夏夜祭关卡原图。各层保持不同的滚动速度，符卡按原阶段选图。
local directory='Resources/th40/Background/'
local prefix='TH40_scene_'
local road={
    ['1']={{'BG01a',.25},{'BG01b',.66,230},{'Cloud01',.38,160},{'Cloud02',.58,140}},
    ['2']={{'BG02d',.34},{'bamboo',.35,235,{.56,0,1.2,1}}},
    ['3']={{'grass',.24},{'tiles',.38,230,{.20,0,.80,1}},{'willow',.51,188,{.56,0,1.28,1}}},
    ['4']={{'St04/黑暗滤镜0'},{'St04/极光素材0',.39,220}},
    ['5']={{'St05/夜空底色0'},{'St05/星星10',.29,195},{'St05/星星20',.51,210},{'St05/极光0',.21,150}},
    ['6']={{'St06/夜空（暗）0'},{'St06/云（暗层）0',.27,190},{'St06/云（亮层）0',.5,145}},
    EX={{'StEx/天色0'},{'StEx/中层0',.28},{'StEx/草地ex0',.41,255,{0,0,1,.55}},
        {'StEx/Tree10',.55,198},{'StEx/Tree20',.67,198}},
}
local folder={['1']='St01/',['2']='St02/',['3']='St03/',['4']='St04/',['5']='St05/',['6']='St06/',EX='StEx/'}
local aliases={
    Card02a='St02/Card02a',Card02b='St02/Card02b',Card02c='St02/Card02c',
    Card03a='St03/Card03a',Card03b='St03/Card03b_base',Card03c='St03/Card03c',
    Card03d='St03/Card03d',Card03e='St03/Card03e',Card03f='St03/Card03f',
    Card04a='St04/Card040a',Card04b='St04/Card040b',Card04c='St04/Card040c',
    card05a='St05/card05a0',card05b='St05/card05b',card05c='St05/card05c',
    ['底色']='St06/底色0',['红光']='St06/红光0',['绿光']='St06/绿光0',['蓝光']='St06/蓝光0',
}
local function path(chapter,name)
    return aliases[name] or (name:find('/',1,true) and name or folder[chapter]..name)
end
local function load(chapter,layers)
    for _,row in ipairs(layers) do
        local file=path(chapter,row[1])
        local image=prefix..file
        if not CheckRes('img',image) then
            -- 贴图已由原作资源导出；符卡使用自己的原图而非上一张卡的底图。
            local pool=GetResourceStatus()
            SetResourceStatus('stage')
            LoadImageFromFile(image,directory..file..'.png')
            SetResourceStatus(pool)
        end
    end
end
local function draw(o,layers,alpha)
    local w=lstg.world
    local width,height=w.r-w.l,w.t-w.b
    for _,row in ipairs(layers or {}) do
        local file=path(o.chapter,row[1])
        local id=prefix..file
        if CheckRes('img',id) then
            local x1,y1,x2,y2=0,0,1,1
            if row[4] then x1,y1,x2,y2=unpack(row[4]) end
            local l,r=w.l+width*x1,w.l+width*x2
            local b,t=w.b+height*y1,w.b+height*y2
            local shift=(o.timer*(row[2] or 0))%(t-b)
            SetImageState(id,'',math.floor((row[3] or 255)*alpha),255,255,255)
            RenderRect(id,l,r,b+shift,t+shift)
            if shift>0 then RenderRect(id,l,r,b+shift-(t-b),b+shift) end
        end
    end
end
local B=Class(background,{
    init=function(o)
        o.android_direct_background=true
        background.init(o,false)
        o.layer=LAYER.BG-.1
    end,
    frame=function(o)
        local alpha=o.mediaAlpha or 0
        local goal=o.mediaSpell and 1 or 0
        o.mediaAlpha=alpha+math.max(-.05,math.min(.05,goal-alpha))
        if o.mediaAlpha==0 then o.mediaLayers=nil end
    end,
    render=function(o)
        SetViewMode('world')
        RenderClearViewMode(Color(255,10,18,38))
        if setting.displayBG==false or not o.chapter then return end
        draw(o,road[o.chapter],1)
        if (o.mediaAlpha or 0)>0 then draw(o,o.mediaLayers,o.mediaAlpha) end
    end,
})
function B.enter(chapter,phase)
    local bg=lstg.tmpvar.bg
    if not IsValid(bg) or bg.class~=B then bg=New(B) end
    if bg.chapter~=chapter then
        bg.chapter,bg.mediaLayers,bg.mediaAlpha=chapter,nil,0
        load(chapter,road[chapter])
    end
    local layers={}
    local names=phase and phase.backgrounds or {}
    if phase and phase.kind=='spell' and #names==0 then
        if chapter=='4' then names={'Card04c','Card04a','Card04b'}
        elseif chapter=='5' then names={'card05b','card05c','card05a'}
        elseif chapter=='EX' then names={'StEx/底面','StEx/最上'} end
    end
    for i,name in ipairs(names) do
        layers[#layers+1]={name,i==1 and .14 or -.24,i==1 and 255 or 150}
    end
    bg.mediaSpell=#layers>0
    if bg.mediaSpell then load(chapter,layers);bg.mediaLayers=layers end
    return bg
end
return B
