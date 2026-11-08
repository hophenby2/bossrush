-- 将阶段倍率固定为指定阶段的累乘结果，实测代理Boss的真实敌机血槽及受击。
local stageIndex=tonumber(os.getenv('TH31_HP_STAGE')) or 19
local factor=1
for i=1,stageIndex do factor=factor*(1+i/100) end
local report={stage=stageIndex,factor=factor,cards={}}
local function near(a,b) return math.abs(a-b)<=1e-7*math.max(1,math.abs(b)) end
local function save()
    local f=assert(io.open('th31-hp.json','w'));f:write(Serialize(report));f:close()
end
function TH31HPConfigure(b,card)
    local s=assert(lstg.var.rogue_run.hp_growth);s.total=factor
    GameHPScale.beginCard(b)
    b.maxhp,b.hp=GameHPScale.health(b,card.hp,card.hp)
end
function TH31HPProbe(host,frames,current)
    if frames~=120 and frames~=180 and frames~=240 and frames~=600 then return end
    local actor
    for _,group in ipairs({GROUP.ENEMY,GROUP.NONTJT}) do for _,o in ObjList(group) do
        if o~=host and o.th08_card_owner==host and o.is_boss and o.alive then
            assert(not actor,'代理非符必须只有一个真实Boss');actor=o
        end
    end end
    assert(actor,'未找到真实Boss敌机')
    local p=assert(host.current_card._original_balance)
    local scale=OriginalBalance.scale[8].normal
    local expected=p.raw*scale*factor
    local row={frame=frames,maxhp=actor.maxhp,hp=actor.hp,owner_maxhp=host.maxhp,
        expected=expected,ratio=actor.maxhp/expected,raw=actor._original_raw_hp,
        calibrated=actor._original_hp_scale,snapshot_factor=actor._hp_growth_factor,
        correct=near(actor.maxhp,expected)}
    assert(near(actor.maxhp,host.maxhp),'血条与实际敌机血量必须一致')
    if frames==180 then
        local amount=100*factor
        local before=actor.hp
        local expectedDamage=actor.protect and 0 or amount*(actor.dmg_factor or 1)*(actor.DMG_factor or 1)*(actor.astral_dmg_factor or 1)
        Damage(actor,amount)
        row.damage_before,row.damage_after,row.expected_damage=before,actor.hp,expectedDamage
        assert(expectedDamage>0 and near(before-actor.hp,expectedDamage),'原生受击入口必须按原作免伤/减伤正确扣血')
    end
    local id=tostring(current.cardId);report.cards[id]=report.cards[id] or {}
    table.insert(report.cards[id],row);save()
end
