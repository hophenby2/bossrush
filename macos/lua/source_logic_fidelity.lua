-- 只覆盖本次报告：子机跟随、尺寸/道具、切换锁定球、永夜弹图、夏夜祭判定。
local T={}
local checked,draws,colors={},{},{}
local bodyScope
local nativeRender, imageState=Render,SetImageState
SetImageState=function(id,blend,a,...)
    if type(a)=='number' then colors[id]=a end
    return imageState(id,blend,a,...)
end
Render=function(id,x,y,rot,sx,sy,...)
    local p=lstg.player
    if p and type(id)=='string' then
        if bodyScope then draws.bodyFrame=(draws.bodyFrame or 0)+1 end
        if id:find('selfbarrage',1,true) then
            draws.shot=(draws.shot or 0)+1
            if (colors[id] or 0)>0 and math.abs(sx or 1)>0 then draws.visible=(draws.visible or 0)+1 end
            if id=='native_source_39_selfbarrage1_0_0_43_165' and (colors[id] or 0)>0 then draws.main=(draws.main or 0)+1 end
            if not draws.sample then
                draws.sample=true
                lstg.SystemLog(('FIDELITY_SHOT: %s alpha=%s scale=%s,%s xy=%s,%s'):format(id,tostring(colors[id]),tostring(sx),tostring(sy),tostring(x),tostring(y)))
            end
        end
        if id==p.img then draws.body=(draws.body or 0)+1;draws.bodyScale=sx end
        if p.native_level==36 and math.abs(x-p.x)<.001 and math.abs(y-p.y)<.001 and (id:find('native_source_',1,true) or id:find('native_unity_player_',1,true)) then draws.unityBody=(draws.unityBody or 0)+1 end
    end
    return nativeRender(id,x,y,rot,sx,sy,...)
end
local items={}
local CollisionTarget=Class(object,{
    init=function(o,b)
        o.group=GROUP.GHOST;o.x,o.y=0,0;o.bound=false;o.colli=true
        o.a,o.b,o.rect=b.a,b.b,b.rect;o.hits=0
    end,
    colli=function(o) o.hits=o.hits+1 end,
},true)
local CollisionShot=Class(object,{
    init=function(o,x,r)
        o.group=GROUP.SPELL;o.x,o.y=x,0;o.bound=false;o.colli=true;o.a,o.b=r,r
    end,
},true)
local function engineBoundary(b,x,r,expected)
    local target=New(CollisionTarget,b);local shot=New(CollisionShot,x,r)
    CollisionCheck(GROUP.GHOST,GROUP.SPELL)
    assert(target.hits==expected,'夏夜祭实际引擎碰撞边界错误：'..x..'/'..r)
    target.colli,shot.colli=false,false
    object.RawDel(target);object.RawDel(shot)
end
function T.before(p)
    local t=stage.current_stage.timer;local key=AndroidInput.keys
    p.protect=100000
    if not checked.installed then
        checked.installed=true
        if p.native_level==36 then
            local render=p._wisys.render
            p._wisys.render=function(...)
                bodyScope=true;draws.bodyFrame=0;render(...);bodyScope=false
                if not p.native_body_hidden then assert(draws.bodyFrame>0,'雪莲华动画出现空白帧') end
            end
        elseif p.native_level==39 then
            local oracle=dofile('macos/oracle_theis_item.lua')
            local adapter=NativePlayers.adapters[39];local frame=adapter.itemFrame
            adapter.itemFrame=function(o)
                if not o.theis_item then return frame(o) end
                local ref=o.fidelity_reference
                if not ref then
                    ref={};oracle.init(ref,o.x0,o.y0,90,-.5,26,o.flylen)
                    ref.size,ref.target,ref.attract,ref.vx,ref.vy=o.size,o.target,8,0,0
                    o.fidelity_reference=ref
                end
                ref.timer=o.timer;oracle.update(ref)
                local result=frame(o)
                for _,k in ipairs({'x','y','vx','vy','hscale','vscale','lockt'}) do assert(math.abs(o[k]-ref[k])<.0002,'道具与原作控制器不同：'..k) end
                ref.x,ref.y=o.x+o.vx,o.y+o.vy
                checked.itemFrames=(checked.itemFrames or 0)+1
                return result
            end
        end
    end
    key[setting.keys.shoot]=t>=10
    key[setting.keys.slow]=t>=100 and t<180
    key[setting.keys.spell]=false
    key[setting.keys.special]=p.native_level==36 and (t==45 or t==135 or t==200)
    key[setting.keys.left]=p.native_level==39 and t>=45 and t<75
    key[setting.keys.right]=p.native_level==39 and t>=95 and t<125
    if p.native_level==39 then
        if t==10 then
            for _,k in ipairs({'red','blue','green','night'}) do items[k]=NativePlayers.pickup(150,170,k,1) end
        end
        if t==20 then
            for k,o in pairs(items) do assert(o.attract==8 and o.target==p,'原作道具应从生成时自动吸附');assert(o.a==((k=='red' or k=='blue') and 10 or 8),'道具半径错误') end
            checked.pickup=true
            local drops=p.theis_source.env.item.DropItem(0,170,{3,2,1})
            assert(#drops==6,'祈华梦仍把多个道具合并为一个')
            for _,o in ipairs(drops) do assert(o.amount==1 and Dist(o.x,o.y,0,170)<=math.sqrt(5)*10+.001);object.RawDel(o) end
            local env=p.theis_source.env
            local minor=env.New(env.item_faith_minor,0,170)
            assert(minor.theis_minor and minor.img=='item_small' and minor.size==.5 and minor.attract==8,'原作小道具入口仍走宿主道具')
            object.RawDel(minor)
        end
        if t>=45 and t<125 then
            assert(p.sp[1][1]==-36 and p.sp[1][2]==-15,'宿主仍在覆盖原作相对子机阵型')
            checked.formation=true
        end
        if t==35 then
            local a=NativePlayers.pickup(p.x+10.5,p.y,'red',1)
            local b=NativePlayers.pickup(p.x+11.5,p.y,'blue',1)
            CollisionCheck(GROUP.ITEM,GROUP.PLAYER)
            assert(a.status=='kill' and b.status=='normal','祈华梦道具拾取边界不符合原作 10+1')
            object.RawDel(b);checked.pickupBoundary=true
        end
    elseif p.native_level==36 and (t==80 or t==130 or t==170 or t==330) then
        local s=p.unity_source.Sincos
        lstg.SystemLog(('FIDELITY_YUKARI: form=%s lan=%s ins=%s'):format(tostring(p.altForm),tostring(s.bayunlan),tostring(s.bayunlan_ins)))
        if p.altForm then assert(s.bayunlan and not s.bayunlan._dead,'切换八云紫后缺少锁定球');checked.ball=true end
        if t==130 then
            local ball=s.bayunlan
            assert(ball.obj and (ball.transform.position-ball.obj.position):Length()<1.5,'八云紫锁定球没有追踪到实际 Boss')
            checked.track=true
        end
    elseif p.native_level==38 and t==120 then
        for _,b in ipairs(boss_group) do if b.IsBoss and b.th38_run then
            assert(b.a==20 and b.b==20,'夏夜祭引擎实际 Boss 半径不为 20')
            local c=b.native_actor_collision
            assert(c and c.contactTest(b,{x=b.x+20.5,y=b.y,A=1}),'20+自机半径范围内未碰撞')
            assert(not c.contactTest(b,{x=b.x+21.5,y=b.y,A=1}),'20+自机半径外错误碰撞')
            engineBoundary(b,20.9,1,1);engineBoundary(b,21.1,1,0)
            engineBoundary(b,34.9,15,1);engineBoundary(b,35.1,15,0)
            checked.boss=true
        end end
        assert(checked.boss,'没有进入实际 Boss 练习')
    end
end
function T.after(p)
    local t=stage.current_stage.timer
    if p.native_level==37 and t==50 then
        local seen={}
        for _,o in ObjList(GROUP.PLAYER_BULLET) do local b=o.source
            if b and b.rect then
                local r=b.rect;local name=tostring(b.shape)..':'..r.Width..','..r.Height
                if not seen[name] then
                    seen[name]=true
                    lstg.SystemLog(('FIDELITY_WEAPON: %s alpha=%s rect=%s,%s pos=%s,%s scale=%s,%s life=%s time=%s'):format(name,tostring(b.color.a),r.X,r.Y,b.position.X,b.position.Y,b.scale.X,b.scale.Y,b.life,b.time))
                end
            end
        end
    end
    if p.native_level==39 and t>=45 and t<125 then
        local q=checked.follow or {p.supportx,p.supporty}
        if checked.follow then
            assert(math.abs(p.supportx-(p.x+(q[1]-p.x)*.5))<.001,'子机横向跟随不符合原作')
            assert(math.abs(p.supporty-(p.y+(q[2]-p.y)*.5))<.001,'子机纵向跟随不符合原作')
        end
        checked.follow={p.supportx,p.supporty}
    end
end
function T.checkpoint()
    local p=lstg.player
    if p.native_level==37 then assert((draws.main or 0)>50,'永夜灵梦主炮未以可见透明度绘制')
    elseif p.native_level==36 then assert(checked.ball and checked.track and (draws.unityBody or 0)>200,'缺少锁定球或自机绘制')
    elseif p.native_level==38 then assert(checked.boss)
    elseif p.native_level==39 then
        assert(checked.pickup and checked.pickupBoundary and checked.formation and checked.follow and checked.itemFrames>200)
        assert(math.abs((draws.bodyScale or 0)-.4)<.001,'灵梦实际绘制缩放不是原作 .8×.5')
    end
    lstg.SystemLog(('SOURCE_LOGIC: 本次自机/道具/判定场景通过 level=%s shots=%s visible=%s body=%s bodyScale=%s'):format(p.native_level,tostring(draws.shot),tostring(draws.visible),tostring(draws.unityBody or draws.body),tostring(draws.bodyScale)))
end
return T
