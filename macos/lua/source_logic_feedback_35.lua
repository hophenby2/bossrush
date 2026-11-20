-- 实际长按 X；保护状态通过真实自机碰撞入口检查。
local T={}
local checked={}
local s,v,c
local hazard=Class(object,{init=function(o,p)
    o.x,o.y,o.a,o.b=p.x,p.y,1,1;o.group,o.colli,o.bound,o.hide=GROUP.ENEMY_BULLET,true,false,true
end},true)
local function hit(p,shield,bomb)
    local oldCheat=cheat;cheat=false;p.protect=0
    c.SWudi,c.BWudi=shield,bomb
    local o=New(hazard,p);p.class.colli(p,o);object.RawDel(o)
    cheat=oldCheat
    return p.hit~=nil
end
function T.before(p)
    local t=stage.current_stage.timer
    s=NativePlayers.state();v=p.mhj_source.sakura;c=p.mhj_source.character
    cheat=true;lstg.var.cheat=true;p.colli=false
    local key=AndroidInput.keys
    key[setting.keys.shoot],key[setting.keys.slow]=false,false
    key[setting.keys.spell]=t>=20 and t<=40 or t>=75 and t<=90 or t==100 or t>=145 and t<=165
    if t==5 then s.bombs=50;p.protect=0;v.Power=v.hipower end
end
function T.after(p)
    local t=stage.current_stage.timer
    if t==22 then assert(v.Status==1 and s.bombs==50,'结界初始无敌阶段错误响应 X');checked.open=true end
    if t==80 then assert(v.Status==2 and s.bombs==50,'按住 X 爆结界后又放出了雷');checked.held=true end
    if t==102 then assert(s.bombs==50,'结界破裂无敌阶段错误放雷');checked.closing=true end
    if t==150 then assert(s.bombs==45 and c.BWudi,'结界关闭后未正常放雷');checked.bomb=true end
    if t==447 then
        assert(not c.BWudi and not c.SWudi and p.protect==0,('早苗雷第300帧边界不符：BWudi=%s SWudi=%s protect=%s death=%s'):format(tostring(c.BWudi),tostring(c.SWudi),p.protect,p.death))
        assert(not hit(p,true,false),'结界无敌没有覆盖雷已结束的情况')
        assert(not hit(p,false,true),'雷无敌没有覆盖结界已结束的情况')
        assert(not hit(p,true,true),'结界与雷同时生效时仍然中弹')
        assert(hit(p,false,false),'两种无敌均结束后仍无法中弹')
        p.hit=nil;NativePlayers.death.cancel(p);c.SWudi,c.BWudi=false,false
        checked.immunity=true
    end
end
function T.checkpoint()
    assert(checked.open and checked.held and checked.closing and checked.bomb and checked.immunity)
    lstg.SystemLog('SOURCE_LOGIC: 春雪 X 长按、结界前后无敌与早苗雷第300帧无敌边界通过')
end
return T
