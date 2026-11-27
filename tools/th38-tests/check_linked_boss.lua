-- 双子星A/B两路线：真实身体分血、400tick复活、停火/运动、独立血圈和清场。
arg={'mod/GAME/th38.lua','1'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th38/runtime.lua')
local A=dofile('mod/GAME/th38/actor.lua');R.actor=A
local H=dofile('THlib/enemy/portrait_hp.lua')
local function eq(a,b,label) assert(a==b,label..': '..tostring(a)..' / '..tostring(b)) end
for _,route in ipairs({'A','B'}) do
    local host={_live=true,hp=11000,maxhp=11000,x=0,y=110,_colli=true,hide=false,protect=false}
    local c=R.controller(host,'L/stage4/boss'..route..'/6');host.asl_controller=c
    assert(c.linked and host.hide and host.protect and not host._colli,'宿主仍有可受击身体')
    local a,b=c.entities[1],c.entities[2]
    assert(a.native and b.native and a.native~=host,'主副体必须均为独立受击实体')
    eq(a.native.hp,5500,'本体初始血量');eq(b.native.hp,5500,'副体初始血量')
    a.native.hp=a.native.hp-123;R.step(c)
    eq(a.life,5377,'本体伤害');eq(b.life,5500,'伤害不能转给副体');eq(host.hp,10877,'汇总仅供结算')
    b.native.hp=b.native.hp-456;R.step(c)
    eq(a.life,5377,'副体伤害不能转给本体');eq(b.life,5044,'副体伤害')
    local ring={boss=host,drawhp=true};H.frameActors(ring)
    eq(ring.sharedHPRings[a.native].boss.hp,5377,'本体独立血圈')
    eq(ring.sharedHPRings[b.native].boss.hp,5044,'副体独立血圈')
    for _=1,200 do R.step(c) end
    local sample
    for _,s in ipairs(c.entities) do if s.kind=='bullet' then sample=s;break end end
    assert(sample,'测试开场必须实际生成弹幕')
    local age=sample.age
    a.moveClock=0;a.entryMotion=nil
    a.native.hp=0;R.step(c)
    eq(a.reviveTick,1,'倒下第一tick');eq(host.hp,5044,'副体仍活着不能收卡')
    assert(c.linkReviving and not c.linkDefeated,'没有进入复活等待')
    eq(a.moveClock,0,'复活时停止下一次随机移动的等待')
    assert(sample.age>age,'复活不能停止已有弹的运动')
    for _=2,399 do R.step(c) end
    eq(a.native.hp,0,'第399tick不能提早复活')
    R.step(c)
    eq(a.native.hp,4500,'第400tick恢复4500血');eq(a.native.maxhp,5500,'血条上限保留初始血量')
    assert(not c.linkReviving and a.reviveTick==0,'复活后必须恢复发弹')
    -- 副体也独立复活，不能只处理主Boss。
    b.native.hp=0
    for _=1,400 do R.step(c) end
    eq(b.native.hp,4500,'副体复活血量');eq(a.native.hp,4500,'副体复活不能重设主血量')
    -- 在正式渲染入口绘制新导出的原作血条及三类复活特效。
    A.render(a.native);A.render(b.native);R.effects.render(c,'attack')
    a.native.hp,b.native.hp=0,0;R.step(c)
    eq(host.hp,0,'双体同时倒下才结束');assert(c.linkDefeated and not c.linkReviving)
    R.clear(c)
    assert(not host.hide and not host.protect and host._colli,'退出没有还原宿主状态')
    assert(not IsValid(a.native) and not IsValid(b.native),'清场仍残留双体')
    host.hp=11000
    c=R.controller(host,'L/stage4/boss'..route..'/6')
    a,b=c.entities[1],c.entities[2]
    a.native.hp,b.native.hp,a.reviveTick=0,0,399
    R.step(c)
    eq(a.native.hp,4500,'主Boss在第400tick先复活');assert(not c.linkDefeated,'第400tick边界提前收卡')
    a.native.hp,b.native.hp,a.reviveTick,b.reviveTick=0,0,0,399
    R.step(c)
    assert(c.linkDefeated and host.hp==0,'双体击破检查必须先于副体复活')
    R.clear(c)
end
print('PASS：双子星两路线独立5500血、双向伤害、两体400tick复活4500血、停火/运动、双血圈/原作条/特效和清场。')
