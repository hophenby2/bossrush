-- 隔离存档中的真实引擎验证：普通／无敌弹过滤、原始切片与死亡复活。
local T={}
local checked={}
local startLife,level
local fixture=Class(object,{
    init=function(o,x,y,group)
        o.x,o.y,o.group=x,y,group;o.colli,o.bound,o.hide=false,false,true
    end,
},true)
local function fixtureClear(p)
    local level=p.native_level
    local c=({[35]=TH37,[36]=TH38,[37]=TH39,[41]=TH43})[level]
    local r=c and c.runtime
    if level==38 then r=_editor_class.TH40.native end
    local normal=New(fixture,p.x+10,p.y,GROUP.ENEMY_BULLET)
    local immune=New(fixture,p.x+10,p.y,GROUP.INDES)
    local outside=New(fixture,p.x+100,p.y,GROUP.ENEMY_BULLET)
    if level==35 or level==37 then
        for _,o in ipairs({normal,immune,outside}) do
            o.mhj={is_projectile=true,Invincible=o==immune,controller={}}
            r.objects[o]=true
        end
    elseif level==36 then
        for _,o in ipairs({normal,immune,outside}) do
            o.asl={kind='bullet',alive=true,invincible=o==immune and 1 or 0}
            r.objects[o]=true
        end
    elseif level==38 then
        local run={owner=p,bullets={normal,immune,outside},enemies={}}
        immune.invincible=true;r.runs[run]=true
        checked.fixtureRun=run
    end
    NativePlayers.death.clear(level,p.x,p.y,40)
    assert(normal.status~='normal','死亡范围没有删除普通弹')
    assert(immune.status=='normal','死亡范围错误删除无敌弹')
    assert(outside.status=='normal','死亡范围错误删除范围外子弹')
    for _,o in ipairs({normal,immune,outside}) do object.RawDel(o);if r and r.objects then r.objects[o]=nil end end
    if checked.fixtureRun then r.runs[checked.fixtureRun]=nil;checked.fixtureRun=nil end
    checked.filter=true
end
function T.before(p)
    local t=stage.current_stage.timer;local s=NativePlayers.state();level=p.native_level
    if t==5 then
        assert(p.machine and p.shotImage)
        if level==35 or level==36 or level==37 or level==41 then assert(p.native_visual,'没有接入原始行走图') end
        checked.spawn=true;s.life=20;s.bombs=20;p.protect=1000
    end
    if t>=15 and t<=60 then
        AndroidInput.keys[setting.keys.shoot]=true
        AndroidInput.keys[setting.keys.slow]=t>=40
    else AndroidInput.keys[setting.keys.shoot]=false;AndroidInput.keys[setting.keys.slow]=false end
    if t==75 then fixtureClear(p) end
    if t==65 then
        assert(math.abs(p.a-p.A)<1e-6 and math.abs(p.b-p.B)<1e-6,'原图动画覆盖了自机判定')
        local drop=NativePlayers.pickup(p.x+100,p.y,'power',1)
        assert(drop.a>0 and drop.b>0,'原图道具没有拾取判定')
        object.RawDel(drop)
        checked.pickup=true
    end
    if t==30 then
        local n=0
        for _,o in ObjList(GROUP.PLAYER_BULLET) do
            if o.native_alpha then
                assert(o.a>0 and o.b>0,'原图自机弹覆盖了受弹判定');n=n+1
            end
        end
        assert(n>0,'未生成原图主炮');checked.shot=true
    end
    if t==90 then
        s.barrier=0;startLife=s.life;NativePlayers.miss(p)
        checked.miss=true
    end
    if t==160 then
        assert(s.life<startLife,'死亡未扣残机')
        assert(p.native_death_clock,'死亡时钟未运行')
        checked.death=true
    end
    if level==37 and t==100 then checked.deathAnim=p.native_visual.clock end
    if level==37 and t==130 then assert(p.native_visual.clock==checked.deathAnim,'永夜篇死亡前50帧行走图未冻结') end
    if t==235 then
        assert(p.death==0 and not p.native_body_hidden,'复活后自机未恢复')
        assert(p.y>=lstg.world.b and p.y<=lstg.world.t,'复活位置落在场外')
        checked.revive=true
    end
    if t==250 then
        NativePlayers.death.hit(p)
        NativePlayers.death.cancel(p)
        assert(not p.native_death_clock and not p.native_hit_clock,'复活后的决死没有取消死亡计时')
        checked.cancel=true
    end
end
function T.after() end
function T.checkpoint()
    for _,key in ipairs({'spawn','shot','pickup','filter','miss','death','revive','cancel'}) do assert(checked[key],'缺少专项检查：'..key) end
    lstg.SystemLog('SOURCE_PARITY: '..level..' 原图、免疫过滤、死亡与复活通过')
end
return T
