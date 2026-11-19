-- 雪莲华发射器延迟、双机切换、蓄力释放和结界冷却。
local T={};local checked={}
local slow=os.getenv('BOSSRUSH_MAC_TEST_LOGIC_VARIANT')=='slow'
function T.before(p)
    local t=stage.current_stage.timer;local s=NativePlayers.state();local key=AndroidInput.keys
    key[setting.keys.shoot]=t>=10 and t<400
    key[setting.keys.slow]=slow and t<220
    key[setting.keys.spell]=t==65 or t==370
    key[setting.keys.special]=t==90 or t==150 or t==250
    if t==5 then p.protect=100000 end
    if t==60 then
        assert(s.barrier>=200000,'初始两层结界没有按原作充能');s.barrier=299999
        checked.initial=true
    end
    if t==66 then assert(p.cancelOnlyBomb and p.nextspell==100,'结界释放冷却未按201个原作tick执行');checked.bomb=true end
    if t==100 then assert(p.altForm and p.unity_source.Sincos.hyper_time>0,'切换没有触发原始倍率暴走');checked.switch=true end
    if t==300 then
        local count=0;for _,o in ObjList(GROUP.PLAYER_BULLET) do if o.native_alpha then count=count+1 end end
        assert(count>0,'切换或蓄力后武器未继续发射');checked.shot=true
    end
    if t==380 then assert(p.unity_source.Sincos.if_now_huiliu,'结界释放后没有启动原始回流');checked.refund=true end
    if t==690 then assert(not p.bombTime and p.nextspell==0,'结界释放冷却未结束');checked.finish=true end
end
function T.after() end
function T.checkpoint()
    assert(checked.initial and checked.bomb and checked.switch and checked.shot and checked.refund and checked.finish)
    lstg.SystemLog('SOURCE_LOGIC: 雪莲华发射器、蓄力、切换暴走和结界释放通过')
end
return T
