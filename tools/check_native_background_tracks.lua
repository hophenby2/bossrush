-- 仅使用引擎桩检查背景逻辑与网格投影。
local draws,view
function Class(_,methods) return methods end
object={}
function IsValid(o) return o and o.valid end
function New(cls,...)
    local o={class=cls,valid=true}
    cls.init(o,...)
    return o
end
function Del(o) if o.class.del then o.class.del(o) end;o.valid=false end
lstg={tmpvar={},world={l=-192,r=192,b=-240,t=240},view3d={},RemoveResource=function() end}
background={DelBG=function() if IsValid(lstg.tmpvar.bg) then Del(lstg.tmpvar.bg) end end}
GROUP={GHOST=0}
LAYER={TOP=1000,BG=-700,PLAYER_BULLET=-500,ENEMY_BULLET=-200}
setting={displayBG=true}
local exists={}
function LoadTexture(_,path)
    if not exists[path] then
        local f=assert(io.open(path,'rb'));f:close();exists[path]=true
    end
end
function SetTextureSamplerState() end
function GetResourceStatus() return "stage" end
function SetResourceStatus() end
function CheckRes() end
function GetTextureSize() return 512,512 end
function Set3D() end
function Color(...) return {...} end
function SetViewMode(mode) view=mode end
function SetPerspective() end
function FindResTexture(name) return name end
lstg.AndroidCreateModelMesh=function(_,v) assert(#v%15==0);return #v/15 end
lstg.AndroidRenderModelMesh=function(mesh) draws=draws+mesh end
function ClearZBuffer() end
function SetZBufferEnable() end
function SetImageState() end
function SetImageCenter() end
function LoadImage() end
function RenderRect() end
local function isNumber(n) return type(n)=='number' and n==n and math.abs(n)<math.huge end
function Render4V(_,x,y,z) assert(isNumber(x) and isNumber(y) and isNumber(z));if z>0 then draws=draws+1 end end
function RenderTexture(_,_,...)
    local front=false
    for i=1,4 do
        local v=select(i,...)
        for j=1,5 do assert(isNumber(v[j])) end
        if v[3]>0 then front=true end
    end
    if front then draws=draws+1 end
end
function Render(_,x,y,r,sx,sy)
    assert(isNumber(x) and isNumber(y) and isNumber(r) and isNumber(sx) and isNumber(sy))
    draws=draws+1
end
function cos(d) return math.cos(math.rad(d)) end
function sin(d) return math.sin(math.rad(d)) end
ran={Float=function() error('背景消耗了对局 RNG') end}
function PlaySound() error('背景会在快进时播放音效') end

local only=arg and arg[1]
if only~='th38' and only~='th39' then
local spring=dofile('mod/GAME/th37/background.lua')
for stage=1,8 do
    for _,tick in ipairs({0,360,1800}) do
        spring.show(stage,tick)
        local scene=assert(lstg.tmpvar.bg)
        scene.timer=0;scene.class.frame(scene)
        draws=0
        scene.class.render(scene)
        assert(draws>0 and view=='world','春雪篇背景缺少图元或未恢复战斗视口：'..stage..'/'..tick)
    end
end
print('春雪篇 8 条路线的网格与视口检查通过')
end

if only~='th37' and only~='th39' then
local A=dofile('mod/GAME/th38/background.lua')
for _,ch in ipairs({'1','2','3','4','5','6','EXA'}) do
    local seq=A.show(ch,'',0,true)
    local i=assert(seq.data.names.Camera_3D)
    draws=0
    seq.class.render(seq)
    local x,y,z=seq.transforms[i].m[10],seq.transforms[i].m[11],seq.transforms[i].m[12]
    local open=draws
    assert(open>0 and view=='world',ch..'开场没有背景绘制或未恢复战斗视口')
    if ch=='1' then assert(math.abs(x+9.9744)<1e-5 and math.abs(z-.0256)<1e-5) end
    for t=2,23000,2 do
        A.story(t)
        seq.class.frame(seq)
        if t%500==0 then seq.class.render(seq) end
    end
    assert(draws>open,ch..'整面没有后续背景绘制')
    if ch=='3' then assert(seq.gate and seq.flash and seq.second,'三面鸟居的转场缺失') end
    if ch=='5' then
        assert(seq.partB==11000)
        A.endCard(true)
        for _=1,200 do seq.class.frame(seq) end
        assert(seq.partCPos,'五面没切到 Boss 后半场景')
    end
    assert(ch=='6' or x~=seq.transforms[i].m[10] or y~=seq.transforms[i].m[11] or z~=seq.transforms[i].m[12],ch..'相机没有位移')
    for _,variant in ipairs(ch=='EXA' and {'_spell'} or {'_boss','_spell'}) do
        local practice=A.show(ch,variant,0,false)
        practice.class.render(practice)
    end
    print('ASL',ch,open,draws)
end
end
if only=='th37' or only=='th38' then return end

local R=dofile('mod/GAME/th39/runtime.lua')
local B=dofile('mod/GAME/th39/background.lua')
local spells,lastWords=0,0
for _,ch in ipairs(R.data.chapters) do
    if ch.difficulty~=9 then
        local s=assert(B.show(R,ch,0))
        draws=0
        local movement={}
        for t=0,ch.length do
            B.tick(t)
            s.class.frame(s)
            if t%250==0 then
                for _,c in ipairs(s.effects) do R.drawBackground(c,1) end
            end
            for _,c in ipairs(s.effects) do
                local first=c.particles[1]
                if t<120 and first and not movement[c] then movement[c]={first,first.fx,first.fy} end
            end
        end
        assert(draws>0,ch.name..'道中没有渲染')
        local pos=0
        for _,v in pairs(movement) do if math.abs(v[1].fx-v[2])+math.abs(v[1].fy-v[3])>0.1 then pos=pos+1 end end
        assert(pos>0,ch.name..'开场背景层没有位移')
        print('MHJ road',ch.name,draws,pos)
        for _,group in ipairs(ch.bosses) do
            for _,card in ipairs(group.cards) do
                B.card(ch,group,card)
                if s.spell then
                    local phase=s.effects[1]
                    local before=phase and phase.time
                    draws=0
                    for _=1,95 do s.class.frame(s) end
                    for _,c in ipairs(s.spell.effects) do R.drawBackground(c,1) end
                    if phase and not s.spell.keep then assert(phase.time==before,'符卡期间道中层没有暂停') end
                    spells=spells+1
                end
                B.endCard(group,card)
            end
        end
    else
        for _,group in ipairs(ch.bosses) do
            local s=assert(B.show(R,ch,group.time))
            for _,card in ipairs(group.cards) do
                B.card(ch,group,card)
                assert(s.spell,'Last Word 缺少原版背景')
                for _=1,120 do s.class.frame(s) end
                draws=0
                s.class.render(s)
                assert(draws>0,'Last Word 背景没有绘制')
                B.endCard(group,card)
                lastWords=lastWords+1
            end
        end
    end
end
assert(spells==62 and lastWords==8 and next(R.objects)==nil and R.bulletCount==0)
print('MHJ spell effects',spells,lastWords)
