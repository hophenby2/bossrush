-- 在真实碰撞分组中创建一发测试自机弹，走原碰撞适配与敌机colli，不直接调用Damage。
local damageProbe={rows={},seen={}}
function NativeEnemyDamageProbe(host,frame,current)
    local s=host.th36_session
    if not s or s.done then return end
    for _,a in ipairs(s.actors) do
        local o=a.o
        local key=s.stage..':'..a.sub
        if not a.proxy and not a.is_boss and not a.dead and IsValid(o) and o._original_accepts_damage
            and not damageProbe.seen[key]
            and math.abs(o.x)<175 and o.y> -190 and o.y<190 then
            local target=a.damage_callback and a.ring_nodes and a.ring_nodes[1] or o
            if not target or not IsValid(target) then return end
            damageProbe.seen[key]=true
            local before=o.hp
            local actual=GetAttr(target,'colli')
            local b=New(object)
            b.img='img_void';b.x,b.y=target.x,target.y
            b.a,b.b,b.rect=2,2,false
            b.group,b.layer=GROUP.PLAYER_BULLET,LAYER.PLAYER_BULLET
            b.bound,b.colli,b.dmg,b.mute=false,true,.25,true
            if OriginalCollision then OriginalCollision.begin();OriginalCollision.shots() end
            CollisionCheck(GROUP.ENEMY,GROUP.PLAYER_BULLET)
            CollisionCheck(GROUP.NONTJT,GROUP.PLAYER_BULLET)
            if OriginalCollision then OriginalCollision.finish() end
            if a.damage_callback then
                -- 弧形节点先收集伤害，原回调再用原始life扣减；不绕过节点直接扣主血条。
                local H=_editor_class.TH36.runtime
                H.hp.enter(s);H.run_callback(a);H.hp.leave(s)
            end
            local row={stage=s.stage,sub=a.sub,frame=s.frame,hp=before,after=o.hp,
                engine_colli=actual,cached_colli=target._colli,group=target.group,a=target.a,b=target.b,
                ring=a.damage_callback==true,
                hit=o.hp<before,consumed=not IsValid(b) or b.status=='kill' or b.status=='del'}
            damageProbe.rows[#damageProbe.rows+1]=row
            if IsValid(b) then object.RawDel(b) end
            local f=assert(io.open('native-enemy-damage.json','w'))
            f:write(Serialize(damageProbe));f:close()
        end
    end
end
