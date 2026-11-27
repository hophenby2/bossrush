-- 四张实际非符的太阳、接触消耗、阴影/光环几何与切卡清理。
arg={'th38-force-field'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
local R=dofile('mod/GAME/th38/runtime.lua');local F=R.forceField
GameDrops=dofile('THlib/drops.lua');local D=GameDrops;local unit=D.BOMB_FRAMES*10000
local function near(a,b,message) assert(math.abs(a-b)<1e-5,(message or '')..': '..a..' / '..b) end
local function reset(mode,enhanced)
    lstg.var={__drops_version=D.VERSION,rogue_run={enhanced=enhanced}}
    stage.current_stage={group={_name=mode}};D.reset()
    return lstg.var.upgrades.players[1]
end
local state=reset('RogueTwo',true)
state.bombs,state.bomb_fraction=3,unit*.005
D.drainBombGauge(player,500,100000)
assert(state.bombs==2 and state.bomb_fraction==unit*.99,'恰好耗尽雷条必须扣一雷并设为99%')
state.bombs,state.bomb_fraction=1,0
D.drainBombGauge(player,500,100000)
assert(state.bombs==0 and state.bomb_fraction==unit*.99,'最后一雷也要转换为99%雷条')
for _=1,200 do D.drainBombGauge(player,500,100000) end
assert(state.bombs==0 and state.bomb_fraction==0,'持续接触必须停在0雷0条')
state.bombs,state.bomb_fraction=100,0
D.drainBombGauge(player,500,100000);assert(state.bombs==99 and state.bomb_fraction==unit*.99)
D.drainBombGauge(2,500,100000)
assert(lstg.var.upgrades.players[2].bombs==2 and state.bombs==99,'联机槽位相互串量')

local renders,states={},{}
local render,imageState=Render4V,SetImageState
Render4V=function(...) renders[#renders+1]={...} end
SetImageState=function(...) states[#states+1]={...} end
local total=0
for _,mode in ipairs({'RogueTwo','RogueTen'}) do for _,enhanced in ipairs({false,true}) do
for _,phase in ipairs({1,3,5,7}) do
    state=reset(mode,enhanced);player.x,player.y,player.A=0,-200,2.5
    local c=R.controller(nil,'L/stage5/boss2/'..phase);local s
    for _=1,300 do
        R.step(c)
        for _,e in ipairs(c.entities) do if e.kind=='field' then s=e;break end end
        if s then break end
    end
    assert(s and s.enemyType==20 and s.rotation==90,'非符没有实例化零旋转的emy41力场')
    assert(s.native.group==GROUP.GHOST and not s.native.colli and s.native.protect,'太阳仍是可击破/体术的普通敌机')
    local rings=s.field.rings
    assert(IsValid(rings) and rings.layer>s.native.layer,'优先加算光环没有独立绘制')
    player.x,player.y=100000,100000
    state.bombs,state.bomb_fraction=2,unit*.75
    for _=1,11 do R.step(c) end
    near(s.field.children[2].alpha,1,'原组件第10tick光环最大亮度')
    near(s.field.children[3].alpha,1,'第二光环前20tick保持prefab亮度')
    near(s.field.children[2].angle,1.1,'每原作tick旋转0.1度')
    for _=1,60 do R.step(c) end
    local growth=({[1]={.55,70},[3]={.30,90},[5]={.42,100},[7]={.55,150}})[phase]
    local expected=growth[1]*sin(70/growth[2]*90)
    near(s.field.sx,expected,'太阳没有按本张非符的R通道放大');near(s.field.sy,expected,'太阳没有按本张非符的G通道放大')
    assert(s.life==9999 and s.native.colli==false,'把敌机HP当作逐tick寿命/恢复普通碰撞')
    near(state.bomb_fraction/unit,.75,'范围外被扣雷条')
    player.x,player.y=R.project(s.x,s.y)
    -- 后几张非符有多个移动太阳；单个组件定点核对扣速，叠加另行覆盖。
    for _=1,71 do F.step(s) end
    near(state.bomb_fraction/unit,.75-71*.005,'单个太阳每原作tick的扣量错误')
    local sx,sy=R.project(s.x,s.y);local radius=s.field.sx*6.4*48+player.A
    player.x,player.y=sx+radius*.999,sy;assert(F.contains(s,player),'太阳内侧没有接触')
    player.x=sx+radius*1.001;assert(not F.contains(s,player),'太阳外侧误扣')
    player.x,player.y=sx+radius*.8,sy+radius*.8;assert(not F.contains(s,player),'把圆形范围做成矩形')
    local before=state.bomb_fraction;F.step(s);assert(state.bomb_fraction==before,'太阳外仍在扣条')
    player.x,player.y=R.project(s.x,s.y)
    state.bomb_fraction=0;F.step(s);assert(state.bombs==1 and state.bomb_fraction==unit*.99,'模式内太阳没有扣库存雷')
    R.deathClear(s.native.x,s.native.y,99999);assert(IsValid(s.native),'扔雷删除了太阳')
    renders,states={},{};s.native.class.render(s.native);rings.class.render(rings)
    assert(#renders==3 and states[1][2]=='mul+rev' and states[2][2]=='mul+add','阴影或双光环绘制缺失')
    near(renders[1][5]-renders[1][2],1280*48/100*s.field.sx,'阴影没有按原图/世界比例绘制')
    assert(states[1][4]==255 and states[1][5]==255,'R/G范围参数被当成太阳颜色')
    s.events={};s.speed,s.accel,s.djX,s.djY=0,0,0,0;s.exit=1
    s.x,s.y=9.4,-2.5;R.step(c);assert(IsValid(s.native),'太阳沿用了更小的普通子弹出屏范围')
    s.x=9.71;R.step(c);assert(not IsValid(s.native) and not IsValid(rings),'原作出屏范围以外没有回收太阳和光环')
    R.clear(c);assert(not IsValid(rings) and not IsValid(s.native),'切卡后残留太阳或光环')
    total=total+1
end end end

-- 第四非的九个太阳从中心散开，重叠接触按原作逐个扣量；宿主一帧执行两tick。
state=reset('RogueTwo',true);player.x,player.y=100000,100000
local overlap=R.controller(nil,'L/stage5/boss2/7');local first,count
for _=1,300 do
    R.step(overlap);count=0
    for _,s in ipairs(overlap.entities)do if s.kind=='field' then first=s;count=count+1 end end
    if first then break end
end
assert(count==9,'第四非太阳数量与原作九向发射不同')
local seeds={}
for _,s in ipairs(overlap.entities)do if s.kind=='field' then
    assert(not seeds[s.field.seed],'同批太阳共用了表现随机序列');seeds[s.field.seed]=true
end end
player.x,player.y=R.project(first.x,first.y);state.bomb_fraction=unit*.9
R.tick(overlap);near(state.bomb_fraction/unit,.9-9*2*.005,'多个太阳重叠的扣量/120Hz时钟错误')
R.clear(overlap)

-- 原作机体仍扣盾：无敌时照扣盾，只有盾耗尽才进入已有受击逻辑。
local native={barrier=200000};local hits=0
NativePlayers={state=function()return native end,barriers=function(s)return s.barrier==299999 and 3 or math.floor(s.barrier/100000)end}
stage.current_stage={group={_name='Spell Practice'}}
player.native_level=36;player.class={colli=function()hits=hits+1 end};player.unity_source={Sincos={}}
local c=R.controller(nil,'L/stage5/boss2/1');local s
for _=1,300 do R.step(c);for _,e in ipairs(c.entities)do if e.kind=='field' then s=e;break end end;if s then break end end
player.x,player.y=R.project(s.x,s.y)
for _=1,20 do R.step(c) end
assert(native.barrier==190000 and hits==0 and player.unity_source.Sincos.steam_5ring==false,'练习原作机体扣盾错误')
native.barrier=500;R.step(c);assert(native.barrier==0 and hits==0)
R.step(c);assert(native.barrier==0 and hits==1,'原作机体盾耗尽没有进入受击流程')
R.clear(c);Render4V,SetImageState=render,imageState
print(('PASS 太阳：四张非符×两模式×强化开关，共%d场；120Hz扣量、0/0下限、原盾、双光环、绘制几何和清场'):format(total))
