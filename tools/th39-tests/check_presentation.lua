-- 专查练习/顺序入口的 LSC 蓄力、立绘与发弹起点；使用正式卡回调，不预滚整条路线。
arg={'th39-presentation'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
dofile('mod/GAME/th39.lua')
boss.sc_name=Class(object,{init=function() end}) -- 本专项仅记录原作立绘时点，UI 绘制由原生检查覆盖。
local R,B=TH39.runtime,TH39.background
R.sound=function() end
B.endCard=function() end
local selected,selectedID
for id,card in pairs(TH39.cards) do
    local m=card.mhj3_source
    if m and m.kind and m.kind>=2 and (not selectedID or id<selectedID) then selected,selectedID=card,id end
end
assert(selected,'未找到 LSC')
local realTick=R.tick
for _,practice in ipairs({true,false}) do
    ext.sc_pr=practice
    local o={_live=true,x=0,y=80,hp=selected.hp,t1=selected.t1*60,t2=selected.t2*60,t3=selected.t3*60}
    selected.init(o)
    local ctx=o.mhj3_card
    local now,portrait,firstShot=0,nil,nil
    B.card=function() portrait=now end
    R.tick=function() firstShot=firstShot or now end
    local total=o.t3
    for i=1,ctx.opening+1 do
        now=i;selected.frame(o)
        if not practice and i==1 then
            assert(o.mhj3_gather.frames==150,'顺序 LSC 没有原作 150 帧蓄力')
            assert(ctx.warning and ctx.warning.effect.status==5,'LSC 警告没有原作状态')
        end
    end
    assert(portrait==40+ctx.delay,'立绘起点不同')
    assert(firstShot==ctx.opening+1,'演出结束前出弹')
    assert(total==selected.mhj3_source.seconds*60+ctx.opening,'开场错占实际战斗时长')
    assert(selected.nativeDamage(o,ctx.damageStart)==0,'受伤窗口提前')
    selected.del(o)
end
R.tick=realTick
print('PASS 永夜 LSC '..selectedID..' 练习/顺序蓄力、警告、立绘、发弹、受伤与总时长')
