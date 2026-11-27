-- 使用夏夜流火的真实阶段、MBG和对象类，检查敌机型弹体与普通弹的区别。
arg={'th40-fiery-flow'}
local f=assert(io.open('tools/check_stage.lua','rb'));local s=f:read('*a');f:close()
assert(loadstring(s:sub(1,assert(s:find('if path == "--all" then',1,true))-1)))()
New=function(class,...)
    local o={class=class,_live=true,timer=0,ani=0,x=0,y=0,vx=0,vy=0}
    if class.init then class.init(o,...) end
    return o
end
local states,draws={},{}
SetImageState=function(image,blend,alpha,r,g,b)states[#states+1]={image,blend,alpha,r,g,b}end
Render=function(...)draws[#draws+1]={...}end
local N=dofile('mod/GAME/th40/native.lua');N.load()
for name in pairs(dofile('mod/GAME/th40/sounds.lua'))do N.sounds[name]=name end
N.presentation=assert(loadfile('mod/GAME/th40/presentation.lua'))(N)
local meta
for _,m in ipairs(dofile('mod/GAME/th40/phases.lua').phases)do if m.id==68036 then meta=m end end
assert(meta and meta.source=='SpellCard_SSS05_01')
local owner={_live=true,x=0,y=100,hp=meta.hp};local run=N.new(owner,meta)
local first,peak= nil,0
for tick=1,1200 do
    N.tick(owner,meta);peak=math.max(peak,#run.objects)
    for _,o in ipairs(run.enemies)do
        if IsValid(o) and not o.th38_removed and not o.emitter and o.enemy=='EnemyYYY4' and o.age>=1 then
            assert(o.reflect==0,'导出器错误地给敌机赋反弹次数')
            assert(o.yyy_rings and #o.yyy_rings==2,'YYY使魔缺少两层绑定光圈')
            if not first then
                first=o
                local a,b=unpack(o.yyy_rings)
                assert(o.age==1 and a.age==2 and b.age==2,'SetBinding立即更新与同帧EffectList更新顺序不符')
                assert(a.parent==o and b.parent==o and a.texture=='EnemyYYY4_0' and b.texture=='EnemyYYY4_1')
                assert(a.angle==80 and b.angle==340 and a.width==1 and b.width==1.5,'光圈初始旋转或缩放不符')
                assert(a.layer>LAYER.ENEMY_BULLET and b.layer<LAYER.ENEMY_BULLET and b.layer>LAYER.ENEMY_BULLET-2,'特效混合分组顺序不符')
                states,draws={},{};o.class.render(o);a.class.render(a);b.class.render(b)
                assert(states[1][2]=='' and states[2][2]=='' and states[3][2]=='mul+add','敌机本体必须普通混合，两层光圈各用原混合')
                assert(states[1][4]==255 and states[1][6]==100 and states[2][6]==255,'本体保留MBG染色，光圈保持白色')
                assert(draws[1][1]==N.images.EnemyYYY4_1 and draws[2][1]==N.images.EnemyYYY4_0 and draws[3][5]==1.5)
            end
        end
    end
end
assert(first,'真实阶段没有生成YYY使魔')
local function sourceObject(mode,extra)
    local d={mode=mode,p={},enemy=mode=='enemy' and 'EnemyYYY4' or nil,type=1,life=0,cx=129,cy=120,speed=3,direction=180,reflect=1,hp=500}
    for k,v in pairs(extra or {})do d[k]=v end
    return N.spawn(run,d,false)
end
local ordinary=sourceObject('bullet');N.update(ordinary)
assert(ordinary.cx==130 and ordinary.direction==0 and ordinary.reflect==0,'普通弹的原反弹规则被移除')
local effect=sourceObject('effect');N.update(effect)
assert(effect.cx==126 and effect.direction==180 and effect.reflect==1,'特效误用普通弹反弹')
local enemy=sourceObject('enemy');N.update(enemy)
assert(enemy.cx==126 and enemy.direction==180 and enemy.reflect==1,'兼容旧参数时敌机仍反弹')
local rings=enemy.yyy_rings
-- 正常运动后，光圈追随中心，父对象出屏时立即一并删除。
for _=1,20 do N.update(enemy);for _,o in ipairs(rings)do N.update(o);assert(o.cx==enemy.cx and o.cy==enemy.cy)end end
assert(not enemy.th38_removed and enemy.cx<128,'敌机触边后错误镜像回场')
enemy.age,enemy.cx,enemy.speed=100,540,0;N.update(enemy)
assert(not IsValid(enemy),'原边界到达后父对象未回收')
for _,o in ipairs(rings)do assert(not IsValid(o),'出屏后光圈残留')end
local killed=sourceObject('enemy');N.update(killed);local deathRings=killed.yyy_rings
killed.class.del(killed)
for _,o in ipairs(deathRings)do assert(not IsValid(o),'父对象删除后光圈残留')end
N.stop(owner);assert(#run.objects==0)
print('夏夜流火：真实阶段1200帧、敌机/特效不反弹、普通弹反弹、三层绘制及绑定光圈回收通过；峰值'..peak)
