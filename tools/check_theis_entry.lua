-- 祈华梦三面 C 线：实际符卡背景绘制和练习加载页的回归，不代替安卓实机检查。
arg={'theis-entry'}
local function read(path)
    local f=assert(io.open(path,'rb'));local src=f:read('*a');f:close();return src
end
local stub=read('tools/check_stage.lua')
-- 本专项只登记实际载入的资源，不依赖通用桩的 Unix 素材扫描命令。
local popen=io.popen;io.popen=function() return nil end
assert(loadstring(stub:sub(1,assert(stub:find("dofile('THlib/bullet/visual_match.lua')",1,true))-1)))()
io.popen=popen
setmetatable(_G,nil)
AndroidPlatform={}
GetTextureSize=function() return 512,512 end
PushRenderTarget,PopRenderTarget,RenderClearViewMode=function() end,function() end,function() end
local images,draws={},{}
local function image(name)
    assert(images[name],'缺少图片资源：'..tostring(name))
end
LoadImage=function(name) images[name]=true end
LoadImageFromFile=function(name) images[name]=true end
LoadImageGroupFromFile=function(name,_,_,columns,rows)
    for i=1,columns*rows do images[name..i]=true end
end
SetImageState=function(name) image(name) end
Render=function(name) image(name) end
Render4V=function(name,...)
    image(name);draws[#draws+1]={name,...}
end
CheckRes=function(kind,name) if kind==2 and images[name] then return 'global' end end
lstg.CheckRes=CheckRes
lstg.Color=function() return 0 end
lstg.sin,lstg.cos=sin,cos;lstg.Rand=function() return ran end
lstg.world={l=-192,r=192,b=-224,t=224,scrl=32,scrr=416,scrb=16,scrt=464}
WorldToScreen=function(x,y) return x+224,y+240 end
GameContent=dofile('mod/content.lua')
setting={displayBG=true};plus={}
dofile('THlib/plus/Utility.lua')
dofile('THlib/misc/misc.lua')
local hostRing=misc.RenderRing
local define=boss.Define
boss.Define=function(id,name,bgm,bg,...) return define(id,name,bgm,bg or background,...) end
local add=boss.card.add
local entries={}
boss.card.add=function(group,level,title,id,...)
    local result=add(group,level,title,id,...)
    entries[#entries+1]={CardName=title,sc_group={{card=group[1][1]}}}
    return result
end
local W=dofile('mod/GAME/th41.lua')
boss.Define=define
boss.card.add=add
local E=W.source
assert(E._editor_class['stage3Cmid_boss2:Lunatic'].cards[2].name=='哀蝶「世俗之盛，信仰之衰」')
local placeholders={[70107]=true,[70209]=true,[70341]=true,[70343]=true,[70345]=true,
    [70347]=true,[70349]=true,[70351]=true,[70611]=true,[70719]=true}
local byId={}
for index,unit in ipairs(entries) do
    local card=unit.sc_group[1].card;byId[card.card_id]={card=card,index=index}
end
for id in pairs(placeholders) do
    local row=assert(byId[id],'空占位卡的旧注册或编号被移除')
    assert(row.card.practice_hidden and row.card.random_empty,'空占位卡仍进入候选：'..id)
end
-- 使用实际练习与随机池的筛选入口，检查隐藏占位卡时不重排原注册索引。
local oldTable,oldFlow=_sc_pr_table,OriginalStageFlow
_sc_pr_table={[39]=entries};OriginalStageFlow=nil
local flow=dofile('mod/GAME/original/stage_flow.lua')
flow.installed=true;flow.order={[39]=W.order}
local visible={}
for _,row in ipairs(flow.units(39)) do
    local id=row.unit.sc_group[1].card.card_id
    assert(not placeholders[id] and row.index==byId[id].index,'练习入口保留占位卡或改变了索引')
    visible[id]=true
end
local pool=dofile('mod/rogue_pool.lua')
local filters=pool.defaults();filters.stages={TH41=true};filters.difficulties.extra=true
filters.encounters.road=false;filters.cards.survival=true
local candidates=pool.build(filters)
local selected={}
for _,bucket in ipairs(candidates) do for _,entry in ipairs(bucket.cards) do
    assert(not placeholders[entry.cardId],'随机候选保留了空占位卡')
    selected[entry.cardId]=true
end end
for _,id in ipairs({70106,70207,70208,70340,70610,70718}) do
    assert(visible[id] and selected[id],'误删有实际攻击的相邻阶段：'..id)
end
_sc_pr_table,OriginalStageFlow=oldTable,oldFlow
print('祈华梦候选：10 张退场/未完成占位卡隐藏，原编号、索引和相邻攻击保留')
-- 莉莉出场的宿主桥接类不经过作品对象的 img 赋值包装，必须直接使用已加载的名称。
E.lstg.ResourceSet.Find('THEIS.StageEffects'):Load()
local boardFields={timer=150}
local board=setmetatable({}, {
    __index=boardFields,
    __newindex=function(_,key,value)
        if key=='img' then image(value) end
        boardFields[key]=value
    end,
})
E.player_board_ch.init(board,0,255,0,300)
assert(board.img=='theis/theis_board_color','莉莉出场染色板未使用作品命名空间')
E.player_board_ch.render(board)
print('祈华梦莉莉出场：严格图片赋值与染色板绘制通过')
-- 原作 C 线符卡背景的自定义层每帧绘制 4 圈，每圈 64 片。
local bg={};E.s3C_boss.scbg.init(bg);bg.alpha=1
E.s3C_boss.scbg.render(bg)
assert(#draws==256,'没有覆盖原作环形背景绘制')
for _,v in ipairs(draws) do assert(v[1]:match('^theis/s3C_boss_scbg1_%d+$')) end
local actual=draws;draws={}
for ring=0,3 do
    local inner=ring==0 and 0 or 192*(ring-1)
    local outer=ring==0 and 0 or 192*ring
    hostRing('theis/s3C_boss_scbg1_',0,64,inner,outer,0,64,32)
end
for i,v in ipairs(actual) do for k,value in ipairs(v) do assert(value==draws[i][k],'桥接改变了原作环形顶点') end end
-- 本作已有前缀和宿主公共图片组均须保持可用。
draws={};E.misc.RenderRing('theis/s3C_boss_scbg1_',0,0,1,2,0,64,32)
assert(#draws==64 and draws[1][1]=='theis/s3C_boss_scbg1_1','已有前缀被重复解析')
images.bossring11=true;draws={}
E.misc.RenderRing('bossring1',0,0,1,2,0,4,1)
assert(#draws==4 and draws[1][1]=='bossring11','宿主公共图片组被错误添加前缀')
assert(misc.RenderRing==hostRing,'桥接污染了宿主绘图函数')
print('祈华梦 C 线实际符卡背景：256 片资源名与原作环形顶点通过')

-- 执行截图报错对象的原始协程；只替换它的附属视觉对象，不改半轴更新的帧序。
local nuclear=E._editor_class['stage_3_boss_marisa_Spell2_star1_nuclear']
local rawNew,connect,del=E.New,E._connect,E._del
E.New=function() return {} end;E._connect=function() end
E._del=function(o) o.done=true end
local function actor(strict)
    local fields={hscale=1,vscale=1,a=1,b=1}
    local o=setmetatable({}, {
        __index=function(_,key) return fields[key] end,
        __newindex=function(_,key,value)
            if strict and (key=='a' or key=='b') then assert(value>=0,'x 引擎拒绝负半轴') end
            fields[key]=value
        end,
    })
    if strict then PortObjectResources.bind(o,function(name) return E.lstg.ResourceSet.Resolve(2,name) end) end
    return o
end
local samples=0
for _,difficulty in ipairs({2,4}) do for _,direction in ipairs({-1,1}) do for _,spin in ipairs({-1,1}) do
    local original,android=actor(false),actor(true)
    nuclear.init(original,0,0,difficulty,direction,spin,{flag=0},90,1,255,255,255)
    nuclear.init(android,0,0,difficulty,direction,spin,{flag=0},90,1,255,255,255)
    for frame=1,240 do
        E.task.Do(original);E.task.Do(android)
        for _,key in ipairs({'hscale','vscale','rot','omiga','colli','done'}) do
            assert(original[key]==android[key],'半轴兼容改变了原作状态或帧序：'..key)
        end
        assert(android.a==math.abs(original.a) and android.b==math.abs(original.b),'判定尺寸偏离原作半轴绝对值')
        samples=samples+1
    end
end end end
E.New,E._connect,E._del=rawNew,connect,del
print(('西行妖花风暴核爆对象：%d 帧原始协程、镜像绘制与半轴兼容通过'):format(samples))

-- 实际三面背景继承 object；须由移植桥接登记，加载页才能感知它。
images.white=true
ui={RenderText=function() end,RenderTip=function() end}
stage={New=function() return {} end}
mask_fader={frame=function() end}
SetFontState=function() end
dofile('THlib/UI/loading.lua')
local L=ui.ResourceLoading
local scene={};stage.current_stage=scene
local function pending()
    lstg.tmpvar.bg=nil;boss_group={}
    stage.next_stage=scene;L.state=nil
    assert(L.beforeFrame());stage.next_stage=nil;L.stageReady()
end
pending()
local nativeBg=E.New(E.stage3_background,true)
assert(lstg.tmpvar.bg==nativeBg,'原作三面背景未登记到加载页检查入口')
assert(#boss_group==0,'测试不应借助宿主 Boss 列表结束加载')
L.afterFrame();assert(L.state.done,'三面背景已创建但练习加载页未结束')
assert(L.beforeFrame(),'完成进度未显示就提前进入战斗')
L.render();assert(not L.beforeFrame() and not L.state,'完成进度显示后未撤下加载页')
object.RawDel(nativeBg)
pending()
nativeBg=E.New(E.stage3_background,true)
L.afterFrame();assert(L.state.done,'重试后的背景未重新登记')
print('祈华梦三面练习入口：背景登记、完成进度显示、撤下加载页与重试通过')
