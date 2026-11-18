-- 原作3D道中与符卡二维覆盖层。
local Visual,Data=...
local directory='Resources/th40/Background/'
local prefix='TH40_scene_'
local Scene=dofile('mod/GAME/th40/scene.lua')
local folder={['1']='St01/',['2']='St02/',['3']='St03/',['4']='St04/',['5']='St05/',['6']='St06/',EX='StEx/'}
local aliases={
    Card02a='St02/Card02a',Card02b='St02/Card02b',Card02c='St02/Card02c',
    Card03a='St03/Card03a',Card03b='St03/Card03b_base',Card03c='St03/Card03c',
    Card03d='St03/Card03d',Card03e='St03/Card03e',Card03f='St03/Card03f',
    Card04a='St04/Card040a',Card04b='St04/Card040b',Card04c='St04/Card040c',
    card05a='St05/card05a0',card05b='St05/card05b',card05c='St05/card05c',
    ['底色']='St06/底色0',['红光']='St06/红光0',['绿光']='St06/绿光0',['蓝光']='St06/蓝光0',
}
-- 原版切片均为 419×477，居中绘制并由 384×448 的弹幕区裁切。
local tenseiLayers={{'底色'},{'绿光',300},{'蓝光',100},{'红光',200}}
local tenseiImages={['底色']=true,['绿光']=true,['蓝光']=true,['红光']=true}
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
            if tenseiImages[row[1]] then
                LoadTexture(image,directory..file..'.png')
                LoadImage(image,image,0,0,419,477)
            else
                LoadImageFromFile(image,directory..file..'.png')
            end
            SetResourceStatus(pool)
        end
    end
end
local function drawTensei(age)
    local w=lstg.world
    local x,y=(w.l+w.r)*.5,(w.b+w.t)*.5
    for _,layer in ipairs(tenseiLayers) do
        local alpha=255
        local fade=layer[2]
        if fade and age>fade then
            local tick=(age-fade)%300
            if tick<=100 then alpha=255-2.55*tick
            elseif tick<=200 then alpha=2.55*(tick-100) end
        end
        local id=prefix..aliases[layer[1]]
        SetImageState(id,'',math.floor(alpha+.5),255,255,255)
        Render(id,x,y)
    end
end
local B=Class(background,{
    init=function(o)
        o.android_direct_background=true
        background.init(o,false)
        o.layer=LAYER.BG-.1
    end,
    frame=function(o)
        if o.tenseiAge then o.tenseiAge=o.tenseiAge+1;return end
        if o.scene then Scene.State.step(o.scene,o.story);o.story=nil end
        Visual.tickBackground(o.originalParts)
        local alpha=o.mediaAlpha or 0
        local goal=o.mediaSpell and 1 or 0
        o.mediaAlpha=alpha+math.max(-.05,math.min(.05,goal-alpha))
        if o.mediaAlpha==0 then o.mediaLayers=nil end
    end,
    render=function(o)
        SetViewMode('world')
        RenderClearViewMode(Color(255,10,18,38))
        if setting.displayBG==false or not o.chapter then return end
        if o.tenseiAge then drawTensei(o.tenseiAge);return end
        Scene.render(o.scene)
        if o.originalParts then Visual.drawBackground(o.originalParts,o.mediaAlpha or 0) end
    end,
})
function B.enter(chapter,phase)
    local bg=lstg.tmpvar.bg
    if not IsValid(bg) or bg.class~=B then bg=New(B) end
    if bg.chapter~=chapter then
        bg.chapter,bg.mediaLayers,bg.mediaAlpha=chapter,nil,0
        local clock=0
        if phase and not lstg.var.sequence_run then
            local source=Data.stages[chapter]
            clock=phase.role=='boss' and source.clock[3] or phase.role=='mid' and source.clock[1] or phase.part=='b' and source.clock[2] or 0
        end
        bg.scene=Scene.State.new(chapter,clock)
    end
    bg.originalParts,bg.tenseiAge=Visual.backgrounds(phase)
    bg.mediaSpell=bg.originalParts and #bg.originalParts>0 or false
    bg.mediaAlpha=bg.mediaSpell and 1 or 0
    if bg.tenseiAge then
        bg.tenseiAge=0;bg.mediaSpell=false;bg.mediaAlpha=0
        load(chapter,tenseiLayers)
    end
    return bg
end
function B.story(t)
    local bg=lstg.tmpvar.bg
    if IsValid(bg) and bg.class==B then bg.story=t end
end
B.Scene=Scene
return B
