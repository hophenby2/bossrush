-- BaseObject.OutBoundary、Type/Region/OutBound 的副作用与 BaseBullet_CS.Ctrl 动画。
local T={}
local N,owner,run
local checked,seen={},{}
local samples={}
local sampledFrame
local holder=Class(object,{init=function(o) o.x,o.y=0,0;o.group,o.colli,o.bound,o.hide=GROUP.GHOST,false,false,true end},true)
local prefixes={'bullet66_','bullet64_','bullet65_','bullet18-'}
local function make(kind,x,height,out,region)
    return N.spawn(run,{mode='bullet',type=kind,cx=x,cy=200,width=1,height=height,age=99,
        life=0,speed=0,direction=0,out=out,region_override=region,p={}},false)
end
local function removed(b,why) N.update(b);assert(b.th38_removed,why) end
function T.before(p)
    local t=stage.current_stage.timer
    AndroidInput.keys[setting.keys.shoot],AndroidInput.keys[setting.keys.spell]=false,false
    p.protect=100000
    N=_editor_class.TH40.native
    if t==5 then
        local render=Render;local keys={}
        for _,prefix in ipairs(prefixes) do
            seen[prefix]={}
            for f=0,3 do keys[N.images[prefix..f]]={prefix,f} end
        end
        function Render(img,...)
            local pair=keys[img]
            if pair then seen[pair[1]][pair[2]]=true end
            return render(img,...)
        end
    end
    if t==20 then
        owner=New(holder);run=N.new(owner,{hp=1000})
        removed(make(0,550,100,true),'无贴图绑定载体飞出原作20像素余量后仍未回收')
        removed(make(184,650,30,true),'火焰弹错误使用固定3点出屏余量')
        removed(make(1,600,30,true,1),'自定义 Region 没有同步原作出屏余量')
        local changing=make(221,850,1,false)
        N.update(changing);assert(not changing.th38_removed,'OutBound=false 的原始大边界被提前收紧')
        N.tween(changing,changing,'type',1,0,1,1)
        removed(changing,'更换弹型后仍保留 OutBound=false 的旧边界')
        local keep=make(1,850,1,false)
        N.update(keep);N.tween(keep,keep,'out',1,0,1,1);N.update(keep)
        assert(not keep.th38_removed,'OutBound=true 不应撤销原作已设置的 OutsideRegion')
        keep.cx=950;removed(keep,'越过原作扩大后的边界仍未回收')
        -- 父弹在上一帧还在边界内；本帧出屏删除后，发射器仍须跟到最终位置。
        local parent=make(0,531.5,1,true);parent.speed=1
        local children={}
        for _,mode in ipairs({'bullet','laser','ray'}) do
            local e=N.spawn(run,{mode=mode,cx=531.5,cy=200,age=100,start=1000,duration=10000,life=10000,p={}},true)
            e.parent=parent;e.parent_last={531.5,200,0,0};children[#children+1]=e
        end
        removed(parent,'父弹越过边界没有删除')
        for _,e in ipairs(children) do removed(e,'绑定发射器丢失父弹最终坐标或误用激光回收规则：'..e.mode) end
        for i,kind in ipairs({181,182,183,184,185}) do
            N.spawn(run,{mode='bullet',type=kind,cx=160+i*45,cy=280,width=1,height=1,life=100,p={}},false)
        end
        checked.boundary=true
    end
    if run then N.step(run) end
end
function T.after()
    local t=stage.current_stage.timer
    if t==50 then
        for _,prefix in ipairs(prefixes) do for f=0,3 do assert(seen[prefix][f],'未实际绘制原作动画帧 '..prefix..f) end end
        checked.animation=true
    end
    if t>=600 and t%300==0 and sampledFrame~=t then
        sampledFrame=t
        for active in pairs(N.runs) do
            if active~=run and active.owner.current_card and active.owner.current_card.th38_source then
                local emitters,orphans=0,0
                for _,o in ipairs(active.enemies) do if IsValid(o) and not o.th38_removed and o.emitter and not o.control then
                    emitters=emitters+1
                    if o.parent and o.parent.th38_removed and o.age>=100 then orphans=orphans+1 end
                end end
                local row={frame=t,objects=#active.objects,emitters=emitters,bullets=#active.bullets,orphans=orphans,fps=lstg.GetFPS(),engine=lstg.GetnObj()}
                samples[#samples+1]=row
                lstg.SystemLog('SUMMER_LIFECYCLE: '..Serialize(row))
                assert(orphans==0,'出屏弹体的绑定发射器冻结在边界内继续发弹')
            end
        end
    end
end
function T.checkpoint()
    assert(checked.boundary and checked.animation)
    assert(#samples>=9,'没有覆盖八百里的烈焰完整符卡的长时间对象变化')
    for _,s in ipairs(samples) do assert(s.emitters<150 and s.objects<1800,'八百里的烈焰仍在持续累积对象') end
    N.stop(owner);object.RawDel(owner)
    lstg.SystemLog('SOURCE_LOGIC: 夏夜祭出屏/换弹型边界、无形载体回收及五种弹体四帧动画通过')
end
return T
