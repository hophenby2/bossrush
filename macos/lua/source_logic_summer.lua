-- 夏夜祭原始子机位置、四种Bomb与恋的一次受击护盾。
local T={};local checked={}
local slow=os.getenv('BOSSRUSH_MAC_TEST_LOGIC_VARIANT')=='slow'
function T.before(p)
    local t=stage.current_stage.timer;local s=NativePlayers.state();local key=AndroidInput.keys
    key[setting.keys.shoot]=t>=10 and t<680
    key[setting.keys.slow]=slow
    key[setting.keys.spell]=t==30
    if t==5 then s.bombs=50;s.power=400;p.protect=100000 end
    if t==31 then
        assert(s.bombs==49,'夏夜祭 Bomb 库存错误')
        local life=p.machine.id=='A' and (slow and 260 or 300) or ({B=390,C=300,D=60})[p.machine.id]
        assert(p.bombTime==life+1 and p.cancelOnlyBomb,'夏夜祭 Bomb 时长或伤害入口错误')
        checked.bomb=true
    end
    if t==200 and p.machine.id=='D' then
        assert(p.summerGod,'恋的 Bomb 护盾没有保留')
        assert(NativePlayers.adapters[38].beforeHit(p,nil,s) and not p.summerGod,'恋的护盾未吸收一次被弹')
        checked.god=true
    end
    if t==600 then
        assert(not p.bombTime and p.nextspell==0,'夏夜祭 Bomb 冷却未结束')
        local sub=p.summer_source.SubPlaneList[0];assert(sub.Enabled,'夏夜祭子机未激活')
        checked.finish=true
    end
end
function T.after() end
function T.checkpoint()
    assert(checked.bomb and checked.finish)
    lstg.SystemLog('SOURCE_LOGIC: 夏夜祭原始主炮、副武器、Bomb 和护盾通过')
end
return T
