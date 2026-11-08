-- 插入正式实体弹，走实际CollisionCheck→player_class.colli→player.system.colli；不直接调用碰撞回调。
local probe={started=false,rows={},fades={}}
local function faded(o) return not IsValid(o) or o.status=='del' or o.status=='kill' end
local function save()
    local f=assert(io.open('native-player-contact.json','w'));f:write(Serialize(probe.rows));f:close()
end
function PlayerContactProbe(host,frame,current)
    if probe.started then
        if frame==240 then
            for _,o in ipairs(probe.fades) do assert(faded(o),'接触消散后仍占对象池') end
            probe.rows[#probe.rows+1]={cleanup=true,count=#probe.fades};save()
        end
        return
    end
    if frame~=120 then return end
    probe.started=true
    assert(lstg.var.__contact_cancel_version==1,'新局未记录接触消弹版本')
    local p=player
    local old={death=p.death,protect=p.protect,dead=lstg.var.dead,man=lstg.var.man,cheat=cheat,colli=p.colli,dialog=p.dialog}
    p.colli,p.dialog=true,false
    local suspended={}
    for _,g in ipairs({GROUP.ENEMY_BULLET,GROUP.ENEMY_BULLET2,GROUP.INDES,GROUP.ENEMY}) do
        for _,o in ObjList(g) do if o.colli then suspended[#suspended+1]=o;SetAttr(o,'colli',false) end end
    end
    local function collide(b)
        if OriginalCollision then OriginalCollision.begin() end
        CollisionCheck(GROUP.PLAYER,b.group)
        if OriginalCollision then OriginalCollision.finish() end
    end
    local function make(game,group,offset)
        if game==11 then
            local H=_editor_class.TH36.runtime;local s=host.th36_session
            local gun={type=1,color=2,angle=0,step=0,s1=0,s2=0,n=1,layers=1,aim=1,ex={}}
            local b;H.on_bullet=function(_,_,o) b=o end
            H.emit_pattern(s,gun,p.x+(offset or 0),224-p.y);H.on_bullet=nil
            -- TH36出生帧先关闭判定，正式frame进入ACTIVE后才可参与实际碰撞。
            b.class.frame(b);b.group=group;return b
        end
        local style=OriginalBulletVisual.native_style(game,0,ball_mid)
        local b=NewSimpleBullet(style,1,p.x+(offset or 0),p.y,0,0,false,0,false,true)
        b.group=group;b.bound=false;b.timer=100
        b.ex_spawn=0;b.th07_spawn=0;b.th06_spawn=0
        -- 出生效果的首帧不是本测试的对象；直接选择原作本体状态。
        if game==95 or game==10 then OriginalANM.interrupt(b._native_anm,2);OriginalANM.step(b._native_anm) end
        return b
    end
    for _,game in ipairs({6,7,8,95,10,11}) do
        for _,mode in ipairs({'fatal','protect','respawn'}) do
            for _,group in ipairs({GROUP.ENEMY_BULLET,GROUP.ENEMY_BULLET2,GROUP.INDES}) do
                p.death=mode=='respawn' and 49 or 0;p.protect=mode=='fatal' and 0 or 300;cheat=false
                local dead=lstg.var.dead;local b=make(game,group)
                -- Bomb消弹免疫不能阻止实际接触消弹。
                b.ex_flags=4096;b.c_flags=4096;b.th10_cancel=999;b.protect=999
                collide(b)
                local expected=mode=='fatal' and 90 or mode=='respawn' and 49 or 0
                assert(p.death==expected and lstg.var.dead==dead+(mode=='fatal' and 1 or 0),
                    ('碰撞死亡状态错误：%d/%s/%d death=%s expected=%s dead=%s/%s p.colli=%s b.colli=%s A=%s B=%s a=%s b=%s'):format(
                        game,mode,group,p.death,expected,lstg.var.dead,dead,tostring(p.colli),tostring(b.colli),p.a,p.b,b.a,b.b))
                assert(not GetAttr(b,'colli') and (b._original_despawning or b.fading),'实体弹未进入无判定消散')
                probe.rows[#probe.rows+1]={game=game,mode=mode,group=group,death=p.death,despawn=true}
                probe.fades[#probe.fades+1]=b
            end
        end
    end
    p.death,p.protect,cheat=0,300,false
    local near=make(11,GROUP.ENEMY_BULLET,12);collide(near)
    assert(near.colli and not near.fading,'只擦弹也被消除，消弹范围错误')
    near.colli=false;object.RawDel(near)
    local enemy=New(Class(object,{},true));enemy.x,enemy.y=p.x,p.y;enemy.group=GROUP.ENEMY;enemy.a,enemy.b=8,8;enemy.colli=true
    collide(enemy);assert(IsValid(enemy) and enemy.colli,'接触误消除了敌机体术对象');enemy.colli=false;object.RawDel(enemy)
    local legacy=make(11,GROUP.ENEMY_BULLET)
    lstg.var.__contact_cancel_version=nil;p.death,p.protect=0,0;local dead=lstg.var.dead
    collide(legacy);assert(legacy.colli and not legacy.fading and p.death==90 and lstg.var.dead==dead+1,'旧录像语义改变')
    object.RawDel(legacy);lstg.var.__contact_cancel_version=1
    probe.rows[#probe.rows+1]={near_miss=true,enemy_preserved=true,legacy=true}
    p.death,p.protect,cheat=old.death,old.protect,old.cheat
    p.colli,p.dialog=old.colli,old.dialog
    lstg.var.dead,lstg.var.man=old.dead,old.man
    for _,o in ipairs(suspended) do if IsValid(o) then SetAttr(o,'colli',true) end end
    save()
end
