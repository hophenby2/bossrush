-- 仅visual=1的私有诊断场景安装，在原生绘制入口核对实际VM状态。
local P={white_draws=0,frozen_draws=0,fade_draws=0,restored_draws=0}
local owners,angles,whitened={},{},{}
local pendingSnapshot
function P.after()
    if not OriginalANM or P.installed then return end
    P.installed=true
    local draw=OriginalANM.draw
    OriginalANM.draw=function(v,x,y,angle,sx,sy,alpha,tint,override,rotation)
        local b=owners[v]
        if b then
            if b.imgclass.native_game==8 then
                local actual=rotation or -v.rotation[3]*180/math.pi
                if b.ex_phase==0 and angles[v] then
                    assert(math.abs(actual-angles[v])<.00001,'铃仙停弹丢失绘制旋转')
                    P.frozen_draws=P.frozen_draws+1
                    if not P.frozen_snapshot then pendingSnapshot='frozen';P.frozen_snapshot=true end
                elseif b.ex_phase==2 then
                    assert(v.follow and rotation~=nil,'铃仙淡入没有更新旋转')
                    P.fade_draws=P.fade_draws+1
                end
                angles[v]=actual
            elseif b.imgclass.native_game==7 and b.imgclass.native_type==6 then
                if b.own_gray then
                    assert(v.sprite==111,'妖梦换白没有绘制原作白箭头')
                    P.white_draws=P.white_draws+1;whitened[b]=true
                    if not P.white_snapshot then pendingSnapshot='white';P.white_snapshot=true end
                elseif whitened[b] then
                    assert(v.sprite==96+b._native_color,'妖梦没有恢复原箭头颜色')
                    P.restored_draws=P.restored_draws+1
                end
            end
        end
        return draw(v,x,y,angle,sx,sy,alpha,tint,override,rotation)
    end
end
function P.frame()
    P.after()
    if pendingSnapshot then
        if not plus.DirectoryExists('snapshot') then plus.CreateDirectory('snapshot') end
        Snapshot('snapshot/android-visual-'..pendingSnapshot..'.png');pendingSnapshot=nil
    end
    owners={}
    for _,b in ObjList(GROUP.ENEMY_BULLET) do
        if b._native_anm and b._native_anm==b._native_body_anm then owners[b._native_anm]=b
        elseif b._native_anm and b.imgclass.native_game==7 and not b._native_spawn_started then owners[b._native_anm]=b end
    end
end
function P.finish(card)
    if card==4391 then
        assert(P.white_draws>0 and P.restored_draws>0,'一念无量劫没有覆盖变白及恢复')
    else assert(P.frozen_draws>0,'铃仙场景未覆盖停弹绘制') end
    local f=assert(io.open('User/android-boss-visual-result.json','wb'))
    f:write(string.format('{"card":%d,"white_draws":%d,"restored_draws":%d,"frozen_draws":%d,"fade_draws":%d}',
        card,P.white_draws,P.restored_draws,P.frozen_draws,P.fade_draws));f:close()
end
return P
