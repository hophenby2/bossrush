-- 用原作ECL演出调度和ANM验证方框，不以“子弹还在发”代替图形检查。
dofile('tools/check_original_anm.lua')
local A,T=OriginalANM,OriginalStageVisual.presentation
local checks=0
local function check(v,why) assert(v,why);checks=checks+1 end
local function near(a,b) return math.abs(a-b)<1e-4 end
local effects
for i=1,20 do
    local name,value=debug.getupvalue(T.new_effect,i)
    if name=='F' then effects=value;break end
end
assert(effects)
local created={}
local new=New
New=function(c,...) local o=new(c,...);created[#created+1]=o;return o end
local texture,rects,draws=RenderTexture,{},{}
RenderTexture=function(tex,blend,...)
    local points={...};draws[#draws+1]={tex=tex,blend=blend,points=points}
    texture(tex,blend,...)
end
local state=SetImageState
SetImageState=function(name,...) if name~='white' then state(name,...) end end
RenderRect=function(name,l,r,b,t) rects[#rects+1]={l,r,b,t} end
T.sound.play=function() end
for _,case in ipairs({{'ecldata4a:28',65,98,16,224,112},
    {'ecldata4asp:13',65,98,16,224,112},{'ecldata4a:46',58,100,0,316.78384,192},
    {'ecldata4asp:31',58,100,0,316.78384,192}}) do
    local owner={x=0,y=case[4],ani=0,timer=0,current_card={is_sc=true},_live=true}
    T.bind(owner,8,case[1])
    for tick=0,89 do stage.current_stage.timer=tick;T.advance(owner,tick) end
    check(not effects.warp,'原作t90前没有结界：'..case[1])
    stage.current_stage.timer=90;T.advance(owner,90)
    local w=assert(effects.warp)
    check(w.phase==owner and #w.effects==2,'原作固定槽9/10各创建一个方框')
    check(w.effects[1].kind==case[2] and w.effects[1].vm.id==case[3]
        and w.effects[2].vm.id==case[3]+1,'中/大结界选择不同的原始ANM')
    for tick=0,121 do
        for _,o in ipairs(w.effects) do o.class.frame(o) end
    end
    for i,o in ipairs(w.effects) do
        check(o.geometry.count==4 and near(o.geometry.radius,case[4+i]),'四顶点半径达到原作端点')
        check(near(o.geometry.width,16),'边框半带宽来自原ANM的scale.x')
        draws={};o.class.render(o)
        check(#draws==4,'方框实际绘制四条带，不能当一个精灵')
        local g=o.geometry
        local vertex=draws[1].points[1]
        check(near(math.abs(vertex[1]-owner.x),(g.radius+16/math.sin(math.pi/4))*math.cos(math.pi/4)),
            '网格边缘按原作径向带宽计算')
        local data=A.sprite_resource(o.vm);local tw,th=GetTextureSize(data.tex)
        check(near(vertex[4],data[2]+o.vm.u*tw) and near(vertex[5],data[3]+data[5]+o.vm.v*th),
            '原作VerticalTextureStrip的UV方向和滚动偏移保留')
        check(o.colli==false and o.group==GROUP.GHOST,'方框效果不新增碰撞或改变子弹物理')
    end
    local vm0,vm1=A.new(8,'eff04a',0),A.new(8,'eff04a',1)
    for _=1,180 do A.step(vm0);A.step(vm1) end
    local original_scale,original_rotation=vm0.scale[1],vm1.rotation[3]
    rects,draws={},{};T.draw_warp_background(owner,{vm0,vm1})
    check(#rects==4 and #draws>0,'方环内绘制反向背景')
    local area=0
    for _,r in ipairs(rects) do area=area+(r[2]-r[1])*(r[4]-r[3]) end
    local outer,inner=case[5]*0.7071068286895752,case[6]*0.7071068286895752
    check(near(area,4*(outer*outer-inner*inner)),'背景遮罩仅覆盖内外方框之间')
    for _,draw in ipairs(draws) do
        for _,p in ipairs(draw.points) do
            check(p[1]>=-outer-1e-4 and p[1]<=outer+1e-4 and p[2]>=owner.y-outer-1e-4
                and p[2]<=owner.y+outer+1e-4,'裁剪后的背景不越过外框')
            check(math.abs(p[1])>=inner-1e-4 or math.abs(p[2]-owner.y)>=inner-1e-4,'反转背景不覆盖内框')
        end
    end
    check(vm0.scale[1]==original_scale and vm1.rotation[3]==original_rotation,'绘制反转背景不修改主VM')
    -- Sub19入口的ExIns5和换卡清场两种出口都必须释放固定槽。
    T.bind(owner,8,'ecldata4a:19');T.advance(owner,0)
    check(not effects.warp and not IsValid(w.effects[1]) and not IsValid(w.effects[2]),'ExIns5释放两层方框')
    effects.start_warp(owner,owner,3)
    check(effects.warp.effects[1].vm.id==96 and effects.warp.effects[2].vm.id==97,'同类窄结界也接入原版脚本')
    T.clear(owner);check(not effects.warp,'击破/超时清场不残留背景遮罩')
end
-- 半张精灵裁剪后仍保留原UV，不得把整张背景挤进方框的一条边。
local clipped=A.new(8,'eff04a',0)
clipped.position,clipped.scale,clipped.rotation={0,0,0},{1,1},{0,0,0}
clipped.anchor,clipped.anchor_x,clipped.anchor_y,clipped.u,clipped.v=1,nil,nil,0,0
local sprite=A.sprite_resource(clipped)
draws={};A.draw(clipped,0,0,nil,nil,nil,nil,nil,
    {clip={sprite[4]/4,sprite[4]*3/4,-sprite[5]*3/4,-sprite[5]/4}})
check(#draws==2,'矩形裁剪生成两片三角形')
for _,draw in ipairs(draws) do for _,p in ipairs(draw.points) do
    check(near(p[4],sprite[2]+p[1]) and near(p[5],sprite[3]-p[2]),'裁剪交点的UV按原像素位置插值')
end end
local objects=effects.objects;effects.objects={}
for i=1,512 do effects.objects[i]={game=8,_live=true} end
local owner={x=0,y=16,current_card={},_live=true}
effects.start_warp(owner,owner,20)
check(effects.warp and effects.warp.effects[1].fixed_slot==9
    and effects.warp.effects[2].fixed_slot==10,'普通粒子池满时固定槽仍然创建结界')
T.clear(owner);effects.objects=objects
print(('原作方形结界回归通过：%d 项'):format(checks))
