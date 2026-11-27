-- 38012实际弹幕：120tick激光寿命与120tick子发射器触发不能互相抢先销毁。
arg={'th38-blood-rain'}
local f=assert(io.open('tools/check_stage.lua'));local source=f:read('*a');f:close()
assert(loadstring(source:sub(1,assert(source:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th38/runtime.lua')
local function near(a,b,message)assert(math.abs(a-b)<1e-6,message)end
local c=R.controller({_live=true,x=0,y=100,hp=15000},'L/stage2/boss2/2')
local converted,completed,first={},0,false
for tick=0,1799 do
    local due={}
    for _,e in ipairs(c.emitters)do
        if e.name=='danmaku2.txt' and e.host and tick==e.birth+120 then
            local s=e.host
            assert(s.alive and s.life==0,'激光在子发射器触发前被回收')
            due[#due+1]={emitter=e,host=s,x=s.x,y=s.y,length=s.lineLength}
        end
    end
    R.step(c)
    local born={}
    for _,s in ipairs(c.entities)do
        if s.kind=='bullet' and s.birth==c.time then born[#born+1]=s end
    end
    assert(#born==#due*4,'实际阶段的激光未按绑定触发生成四发普通弹')
    for i,row in ipairs(due)do
        local s,e=row.host,row.emitter
        assert(s.alive and IsValid(s.native) and s.life==-1,'寿命结束必须保留收束中的本体')
        near(s.x,row.x,'收束头部没有停在转弹位置');near(s.y,row.y,'收束头部没有停在转弹位置')
        near(s.lineLength,row.length-s.speed*.0025,'没有按原速度逐tick收束纵轴')
        assert(e.count==1,'转换重复发弹')
        for j=1,4 do
            local b=born[(i-1)*4+j]
            assert(b.shape==4 and b.color==1 and b.life==3000,'转换后的弹型、颜色或寿命丢失')
            near(b.x,s.x,'子弹出生位置与激光错位');near(b.y,s.y,'子弹出生位置与激光错位')
            near(b.direction,s.rotation,'相对发射角度未继承激光朝向')
            near(b.speed,-2-(j-1)*.5,'转换后的四档速度不符')
        end
        converted[#converted+1]=row
        if not first then
            assert(tick==215,'实际第一轮转弹时刻改变')
            local render,state,players=Render,SetImageState,NativePlayers
            local drawn
            Render=function(...)drawn={...}end;SetImageState=function()end
            NativePlayers={visual={data={unity={beams={[s.laserStyle]={[s.color+1]='blood'}}}},sprite=function()return 'blood',.48 end}}
            s.native.class.render(s.native)
            near(drawn[5],s.width*.5*.48,'移动激光没有使用原作半宽缩放')
            near(drawn[6],s.lineLength*.48,'激光绘制没有使用收束中的实际长度')
            Render,SetImageState,NativePlayers=render,state,players
            first=true
        end
    end
end
for _,row in ipairs(converted)do
    if not row.host.alive then
        assert(not row.emitter.alive and not row.emitter.host,'激光消失后残留绑定发射器')
        completed=completed+1
    end
end
assert(first and #converted>30 and completed>30,'没有覆盖后续多轮发弹与自然收束')
-- 走正式消弹入口，已长成的激光必须缩短实际纵轴，随后正常销毁。
local cancelled
for _,s in ipairs(c.entities)do
    if s.kind=='beam' and s.beamMode==0 and not s.lineGrowing and s.lineLength>.1 then cancelled=s;break end
end
local s=assert(cancelled,'没有可消除的移动激光')
local width=s.width
R.deathClear(s.native.x,s.native.y,10000,false)
assert(s.lineLength<=.08*s.width and s.width==width,'消弹没有缩短实际纵轴或错误修改宽度')
R.step(c);assert(not s.alive,'收束完成后激光未销毁')
R.clear(c)
for o in pairs(R.objects)do assert(not IsValid(o),'卡结束后残留原生对象')end
assert(R.bulletCount==0 and #c.entities==0 and #c.emitters==0,'清场后残留普通弹池或绑定状态')
print(('PASS 洒向乐土的血雨：1800tick、%d次转弹、%d次自然收束、四档速度/朝向/位置、原图缩放、消弹及清场'):format(#converted,completed))
