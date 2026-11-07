-- 原作敌机的实际击破入口；delete、离屏回收不经过这里。
-- TH07/08：EnemyManager的deathAnm字节组；TH10：EnemyCreate保存的出生ANM颜色。
local D={}
local scripts={[0]=28,29,30,31,36,37,38,39,40,41,42,43,44}
function D.bind(o,game)
    if o._bosssys or game~=7 and game~=8 and game~=10 then return end
    if o._original_death then return end
    local scope=stage and stage.current_stage
    if D.scope~=scope then D.scope,D.serial=scope,0 end
    D.serial=(D.serial or 0)+1
    o._original_death={game=game,sound=(D.serial-1)%2+2,anm={0,0,0}}
    o._original_death_effect=D.play
end
function D.event(o,game,c)
    local d=o._original_death
    if not d then return end
    local op,value=c[2],c[3]
    if game==8 and op==138 then
        local first=value%256
        d.anm={first>=128 and first-256 or first,math.floor(value/256)%256,math.floor(value/65536)%256}
    end
end
function D.birth(o)
    local d=o._original_death
    if not d or d.game~=10 or d.script then return end
    -- EnemyCreate在首次RunEcl之后按bank=1时的初始脚本保存死亡颜色，走路换帧不再改它。
    local source,actor=o._original_source,o._original_actor
    local id=actor and actor.vm.id
    if source and source.bank==1 and actor then
        id=actor.poses and actor.poses[1] or id
        if id==5 or id==25 or id==50 then d.script=356
        elseif id==15 or id==35 or id==52 then d.script=365
        elseif id==10 or id==30 or id==51 then d.script=362 end
    end
    d.script=d.script or 359
end
function D.play(o)
    local d=o._original_death
    if not d or d.played or o._original_no_death then return end
    d.played=true
    local p=OriginalStageVisual.presentation
    p.sound.play(d.game,d.sound,o.x)
    local function spawn(archive,script,kind,count)
        for _=1,count do
            -- 不连接临死敌机，换卡清场也不截断死亡ANM的寿命。
            local effect=p.new_effect(d.game,archive,script,o.x,o.y,o,kind,0xffffffff)
            if effect then effect.phase=nil end
        end
    end
    if d.game==10 then
        D.birth(o)
        spawn('bullet',d.script,nil,1)
    else
        local anm=d.game==7 and o.th07_death_anm or d.anm
        if anm[1]<0 then return end
        spawn('etama',assert(scripts[anm[1]],'未登记的原作击破动画'),anm[1],1)
        spawn('etama',assert(scripts[anm[2]+4],'未登记的原作击破碎片'),anm[2]+4,4)
    end
end
function D.boss_sound(o)
    local actor=o._original_actor
    if not actor then return false end
    local game=actor.game
    if game~=6 and game~=7 and game~=8 and game~=95 and game~=10 then return false end
    OriginalStageVisual.presentation.sound.play(game,18,o.x)
    return true
end
return D
