-- 永夜篇：普通/决死 Bomb，以及灯笼蓄能、暴走和破裂的原始状态转换。
local T={}
local variant=os.getenv('BOSSRUSH_MAC_TEST_LOGIC_VARIANT')
local checked={}
function T.before(p)
    local t=stage.current_stage.timer;local s=NativePlayers.state();local key=AndroidInput.keys
    key[setting.keys.shoot]=t>=10 and t<20
    key[setting.keys.slow]=false
    key[setting.keys.spell]=variant~='system' and t==30 or variant=='system' and t==260
    key[setting.keys.special]=variant=='system' and t==220
    if t==5 then s.bombs=50;p.protect=100000 end
    local v=p.mhj_source.lantern
    if variant=='status' then
        key[setting.keys.spell]=false
        key[setting.keys.left]=t==12 or t==14 or t==16
        local c=p.mhj_source.character
        if t==10 then
            p.protect=0;v:Reset(false);c.Wudi=false
            TH39.runtime.petrify({controller={}},1,3)
            assert(c.petrifying and v.pause,'石化没有暂停灯笼');checked.petrify=true
        end
        if t==18 then
            assert(not c.petrifying and not v.pause,'石化解除次数或灯笼恢复错误');checked.relieve=true;p.protect=100000
        end
        if t==30 then TH39.runtime.control({controller={}},3,c.body.position.X+175,c.body.position.Y,10,5,'201') end
        if t==50 then
            assert(c.controling and c.CBanShoot and c.BanMove and v.pause,'强制移动结束后错误释放控制');checked.control=true
            c:FreeControl()
            assert(not c.CBanShoot and not c.BanMove and not v.pause,'FreeControl 没有恢复控制')
        end
        if t==70 then TH39.runtime.lockdown({controller={}},6,'201') end
        if t==78 then assert(not c.LBanShoot and not c.BanMove,'定身持续时间错误');checked.lockdown=true end
        if t==80 then TH39.runtime.gettingold({});assert(c.state>=6 and c.state<=13,'衰老状态没有切换') end
        if t==85 then TH39.runtime.returnyouth({});assert(c.state<6 or c.state==12,'衰老状态没有恢复');checked.old=true end
    elseif variant=='system' then
        if t==10 then v.Power=v.setting.HiPower end
        if t==12 then assert(v.Status==1 and v.teammate,'灯笼蓄能后没有展开支援自机');checked.open=true end
        if t==45 then v.Power=v.setting.HiPower*2 end
        if t==47 then assert(v.Status==2,'灯笼满槽没有进入暴走预警');checked.over=true end
        if t==170 then assert(v.Status==3,'暴走预警结束后没有进入暴走');checked.hyper=true end
        if t==200 then v:Reset(false);v.status=0;v.stayTime=0;v.Energy=3 end
        if t==222 then assert(v.Status==1 and v.Energy==2,'能量启动灯笼错误');checked.energy=true end
        if t==262 then assert(v.Status==5 and s.bombs==50,'灯笼破裂错误消耗了 Bomb');checked.breaking=true end
    else
        if t==30 and variant=='slow' then p.hitWindow,p.hit=60,59 end
        if t==31 then
            assert(s.bombs==(variant=='slow' and 40 or 45),'永夜篇普通/决死 Bomb 扣除库存错误')
            assert(p.bombTime and p.bombTime>120 and p.cancelOnlyBomb,'永夜篇未执行原始 Bomb')
            checked.bomb=true
        end
        if t==690 then assert(not p.bombTime and p.nextspell==0,'永夜篇 Bomb 冷却未结束');checked.finish=true end
    end
end
function T.after() end
function T.checkpoint()
    if variant=='status' then assert(checked.petrify and checked.relieve and checked.control and checked.lockdown and checked.old)
    elseif variant=='system' then assert(checked.open and checked.over and checked.hyper and checked.energy and checked.breaking)
    else assert(checked.bomb and checked.finish) end
    lstg.SystemLog('SOURCE_LOGIC: 永夜篇原始自机系统通过')
end
return T
