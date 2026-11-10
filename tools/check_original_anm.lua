-- 用原始 ANM 时间点检查动画、坐标换算、旧编号和资源重载；不以代理贴图作期望值。
arg={'original-anm'}
local f=assert(io.open('tools/check_stage.lua','rb'));local setup=f:read('*a');f:close()
assert(loadstring(setup:sub(1,assert(setup:find('if path == "--all" then',1,true))-1)))()
-- 使魔的道中归属查询使用协程栈；静态检查未运行任何任务时也应提供空栈。
task.stack=task.stack or {}
local textures,images,draws={},{},{}
local checks=0
local function check(v,message) assert(v,message);checks=checks+1 end
local function near(a,b) return math.abs(a-b)<1e-5 end
LoadTexture=function(name,path)
    local p=assert(io.open(path,'rb'));local h=p:read(24);p:close()
    check(h:sub(1,8)=='\137PNG\13\10\26\10','导出的纹理必须是PNG容器')
    local function n(i) local a,b,c,d=h:byte(i,i+3);return ((a*256+b)*256+c)*256+d end
    textures[name]={n(17),n(21)}
end
LoadImage=function(name,tex,x,y,w,h) images[name]={tex=tex,x=x,y=y,w=w,h=h} end
CheckRes=function(kind,name) return (kind=='tex' and textures[name]) or (kind=='img' and images[name]) end
GetTextureSize=function(name) return unpack((assert(textures[name],name))) end
Color=function(a,r,g,b) return {a=a,r=r,g=g,b=b} end
SetImageState=function(name,blend,color) local i=assert(images[name],name);i.blend,i.color=blend,color end
Render=function(name,x,y,rot,hs,vs) draws[#draws+1]={img=assert(images[name],name),name=name,x=x,y=y,rot=rot,hs=hs,vs=vs} end
RenderTexture=function(name,blend,...)
    local vs={...};check(textures[name] and #vs==4,'UV滚动使用原纹理与四个顶点')
    draws[#draws+1]={texture=name,vertices=vs}
end
SetViewMode=function() end
lstg.SetTextureSamplerState=function() end
stage={current_stage={}}
dofile('THlib/anm/original.lua');dofile('THlib/anm/stage_visual.lua')
local A,V=OriginalANM,OriginalStageVisual
local pellet=A.new(7,'etama',0)
local ps=pellet.data.sprites[pellet.sprite]
check(pellet.sprite==0 and ps[1]==0 and ps[4]==8 and ps[5]==8,
    '妖妖梦小弹必须取第一页8×8，不能被后续页的同名sprite0覆盖')
local bubble=A.new(7,'etama',25)
local bs=bubble.data.sprites[bubble.sprite]
check(bubble.sprite==168 and bs[1]==1 and bs[4]==64 and bs[5]==64,
    '妖妖梦大玉取第二页局部sprite0，累计基址168')
local bg0,bg1=A.new(7,'eff05',0),A.new(7,'eff05',1)
check(bg0.sprite==0 and bg1.sprite==1 and bg0.data.sprites[0][1]==0 and bg1.data.sprites[1][1]==1,
    '妖梦符卡背景的两个同名sprite0属于两份纹理')
local ghostpage=A.load(7,'stg6enm')
local g=A.new(7,'stg6enm',ghostpage.ids[149])
check(g.sprite==151 and g.data.sprites[g.sprite][1]==1,
    '幽幽子的附属动画累计基址由原始脚本最大编号决定，不能只加精灵个数')
local fire=A.new(6,'etama3',7)
check(fire.sprite==118,'红魔乡火弹起帧118')
for _=1,5 do A.step(fire) end
check(fire.sprite==119,'红魔乡火弹5帧换119')
for _=1,15 do A.step(fire) end
check(fire.sprite==118,'红魔乡火弹20帧回到118')
local key=A.new(95,'enm16',8)
for _=1,14 do A.step(key) end
check(near(key.scale[1],1) and near(key.scale[2],1),'结界键15帧展开到原图尺寸')
check(key.sprite==11 and key.blend=='mul+add','结界键使用蓝的原版sprite11与加色混合')
local birth=A.new(95,'bullet',0)
A.interrupt(birth,7)
for _=1,8 do A.step(birth) end
check(near(birth.scale[1],.5) and near(birth.alpha[1],255),'文花帖快速出生8帧的缩放和alpha端点')
A.step(birth)
check(birth.sprite==0 and birth.stopped,'出生完毕跳至原主弹并停在interrupt2')
local roles
for i=1,30 do
    local name,value=debug.getupvalue(V.bind_boss,i)
    if not name then break end
    if name=='roles' then roles=value;break end
end
check(roles~=nil,'使用正式角色映射表')
local levels={ [6]=30,[7]=32,[8]=29,[95]=31,[10]=33 }
local role_count=0
for game,byname in pairs(roles) do
    for name,cfg in pairs(byname) do
        local o={class={StageLevel=levels[game]},ani=0,timer=0,x=0,y=96,dx=0,rot=0,_a=255,_r=255,_g=255,_b=255}
        local walking={obj=o};o._wisys=walking
        check(V.bind_boss(walking,name),'角色采用原作ANM：'..game..'/'..name)
        check(type(o.name)=='string' and o.name~='' and o.name==V.boss_names[name],'五作每个角色都提供真实Boss名：'..game..'/'..name)
        local vm=o._original_actor.vm
        check(vm.data.archive==cfg[1],'同角色按作品选择本作资源')
        draws={};V.draw(o)
        check(#draws>0 and draws[#draws].name:find('original/',1,true)==1,'Boss 绘制不再走代理资源')
        o.ani=1;V.tick(o,2);V.draw(o)
        o.ani=2;V.tick(o,0);V.draw(o)
        role_count=role_count+1
    end
end
local raw=A.load(7,'stg4enm')
check(raw.ids[128]~=raw.ids[134] and raw.ids[134]~=raw.ids[140],'三姐妹使用三个原始姿态编号')
-- 同一六面ANM内128是妖梦、147才是幽幽子；共享Boss载体不能拿上一角色的库解释95/96。
local changing={class={StageLevel=32},_bosssys={},ani=0,timer=0,x=0,y=96,name='亡灵'}
changing._wisys={obj=changing}
V.bind_th07_boss(changing,'5main')
check(changing.name=='魂魄妖梦' and changing._original_actor.archive=='stg5enm','五面入口选择妖梦及其真实名字')
V.bind_th07_boss(changing,'6main')
check(changing.name=='西行寺幽幽子' and changing._original_actor.archive=='stg6enm'
    and changing._original_actor.vm.id==A.load(7,'stg6enm').ids[147],'完全墨染等六面主Boss卡从147号幽幽子起始')
local p=changing._original_actor.poses
check(table.concat(p,',')=='147,149,148,151,150','幽幽子移动/停步顺序与原作96一致')
V.bind_th07_boss(changing,'6mid')
check(changing.name=='魂魄妖梦' and changing._original_actor.archive=='stg6enm'
    and changing._original_actor.vm.id==A.load(7,'stg6enm').ids[128],'六面中Boss选择同库128号妖梦')
changing.th07_visual_file='ecldata7.ecl'
V.bind_th07_boss(changing,'2main')
check(changing._original_actor.archive=='stg2enm','新入口不被上张Extra的ANM库覆盖')
V.bind_th07_boss(changing,'5main')
V.source_event(changing,7,'ecldata6',{0,95,147})
check(changing.name=='西行寺幽幽子' and changing._original_actor.archive=='stg6enm','95按当前ECL文件切换库和身份')
V.bind_th07_boss(changing,'5main')
V.source_event(changing,7,'ecldata6',{0,96,147,151,150,149,148})
check(changing.name=='西行寺幽幽子' and changing._original_actor.archive=='stg6enm'
    and changing._original_actor.poses[2]==149,'96单独出现时也能建立正确的角色库')
-- 小恶魔与大妖精、荷取中Boss与主Boss、早苗五面与EX均须区分本面的入口。
for _,case in ipairs({{4,'大妖精','stg2enm',64},{8,'小恶魔','stg4enm',64},{12,'十六夜咲夜','stg6enm',128},
    {13,'帕秋莉·诺蕾姬','stg7enm',65}}) do
    local b={class={StageLevel=30,id=case[1]..'a30'},_bosssys={},ani=0,x=0,y=96}
    V.bind_boss({obj=b},'Daiyousei')
    check(b.name==case[2] and b._original_actor.archive==case[3]
        and b._original_actor.vm.id==A.load(6,case[3]).ids[case[4]],'红魔乡按ECL构造组选择本面角色：'..case[1])
end
for key,e in pairs(V.th10_boss_entries) do
    local b={class={StageLevel=33},_bosssys={},ani=0,x=0,y=96}
    V.bind_boss({obj=b},e[1],{'stgenm0'..e[2],e[3]})
    check(b.name==V.boss_names[e[1]] and b._original_actor.archive=='stgenm0'..e[2]
        and b._original_actor.vm.id==e[3],'风神录原作Boss/MBoss入口：'..key)
    if key=='s7mid' or key=='s7boss' then
        local bg={};b.__show_scbg=true;b.current_card={is_sc=true};boss_group={b}
        b._bg.init(bg);b._bg.frame(bg)
        check(#bg.vms==(key=='s7mid' and 2 or 1) and bg.vms[1].id==(key=='s7mid' and 27 or 38),
            'EX早苗/诹访子背景遵循EnemyBeginSpell分支：'..key)
    end
end
local eirin={class={StageLevel=29},_bosssys={},ani=0,x=0,y=96}
V.bind_boss({obj=eirin},'Yagokoro')
V.source_event(eirin,8,'ecldata6',{0,59,0})
V.source_event(eirin,8,'ecldata6',{0,62})
check(eirin._original_actor.archive=='stg6enm' and eirin._original_actor.vm.id==5,
    '永琳首非59→62没有ECL游标时仍保留敌机的角色库标志')
V.bind_source(eirin,8,'ecldata6:33',true)
check(eirin._original_source.alternate==true,'切换攻击子程序保留敌机ANM库标志')
V.source_event(eirin,8,'ecldata6',{0,57,1,0})
V.source_event(eirin,8,'ecldata6',{0,62})
check(eirin._original_actor.archive=='enemy','原作57清除角色库标志后62遵循公共库分支')
local actor={ani=0,timer=0,x=0,y=0,rot=0}
V.bind_source(actor,8,'ecldata_al:2')
check(actor._original_actor.vm.data.archive=='enemy','永夜抄使魔54指令选择公共enemy.anm')
draws={};V.draw(actor)
check(#draws>0,'原版人偶动画能够绘制')
V.bind_source(actor,7,'ecldata3:8')
check(actor._original_actor.slots[0]~=nil,'妖妖梦97附加动画仍在同一使魔上')
draws={};V.draw(actor);check(#draws>=2,'主动画与附加动画都绘制')
local saved=actor._original_actor.vm
textures,images={},{};stage.current_stage={}
draws={};A.draw(saved,0,0)
check(#draws==1,'关卡资源池重置后可重新载入原纹理')
stage.current_stage.timer=100;A.draw(saved,0,0)
textures,images={},{};stage.current_stage.timer=0
draws={};A.draw(saved,0,0)
check(#draws==1,'重试复用同一stage表、timer归零后仍重载资源')
local hidden={ani=0,timer=0,x=0,y=0,rot=0}
V.bind_source(hidden,8,'ecldata_ym:5')
draws={};V.draw(hidden)
check(hidden._original_actor and hidden._original_hidden and #draws==0,'妖梦卫星播放动画但响应原作NO_SPRITE')
V.bind_source(hidden,8,'ecldata8sp:92')
hidden._original_hidden=false
draws={};V.draw(hidden)
check(hidden._original_actor.slots[1] and #draws>=2,'妹红第二个自己保留原作两层动画')
local ran={class={StageLevel=32},ani=0,timer=0,x=0,y=96,th07_visual_file='ecldata8.ecl'}
V.bind_boss({obj=ran},'Ran')
check(ran._original_actor.archive=='stg8enm' and ran._original_actor.vm.id==A.load(7,'stg8enm').ids[134], 'PH藍使用八面脚本134')
for _,entry in ipairs({{'Chen','ecldata7.ecl','eff02',1},{'Ran','ecldata7.ecl','eff07',2},
    {'Ran','ecldata8.ecl','eff07',2},{'Yukari','ecldata8.ecl','eff08',2}}) do
    local b={class={StageLevel=32},ani=0,timer=0,x=0,y=96,th07_visual_file=entry[2],
        __show_scbg=true,current_card={is_sc=true}}
    V.bind_boss({obj=b},entry[1])
    local bg={};b._bg.init(bg)
    boss_group={b};b._bg.frame(bg)
    check(#bg.vms==entry[4] and bg.vms[1].data.archive==entry[3],
        'EffectManager/Gui切换决定EX/PH背景文件与层数：'..entry[1]..'/'..entry[2])
end
local sanae={class={StageLevel=33},ani=0,timer=0,x=0,y=96}
-- 三种不同的背景 ANM 锚点都落在同一384×448游戏场地，不能重复叠加屏幕中心。
for _,case in ipairs({{29,'Nightbug'},{30,'Rumia'},{31,'Nightbug'},{32,'Whiterock'},{33,'Minoriko'}}) do
    local b={class={StageLevel=case[1]},ani=0,timer=0,x=0,y=96,__show_scbg=true,current_card={is_sc=true}}
    V.bind_boss({obj=b},case[2]);local bg={};b._bg.init(bg);boss_group={b}
    for _=1,65 do b._bg.frame(bg) end
    draws={};b._bg.render(bg)
    check(#draws>0,'符卡背景可见：'..case[2])
    for _,d in ipairs(draws) do
        if d.vertices then
            local x,y=0,0
            for _,p in ipairs(d.vertices) do x,y=x+p[1],y+p[2] end
            check(near(x/4,0) and near(y/4,0),'UV滚动背景中心不偏移：'..case[2])
        else check(near(d.x,0) and near(d.y,0),'原作背景锚点只换算一次：'..case[2]) end
    end
end
V.bind_boss({obj=sanae},'Sanae')
check(sanae._original_actor.special==11,'单卡入口也恢复早苗构造时的施法动画编号')
V.bind_source(sanae,10,'stage05:BossCard1',true);V.source_frame(sanae,100)
check(sanae._original_source.bank==2 and sanae._original_actor.archive=='stgenm05', '风神录换卡继承Boss的ANM槽，不能误取bullet.anm')
local momizi={class={StageLevel=33},ani=0,timer=0,x=0,y=96}
V.bind_boss({obj=momizi},'Momizi')
V.bind_source(momizi,10,'stage04:MBoss',true)
check(momizi._original_actor.archive=='stgenm04' and momizi._original_actor.slots[1].data.archive=='bullet', '椛构造入口先从默认槽创建370号效果，再选择角色槽')
local kanako={class={StageLevel=33},ani=0,timer=0,x=0,y=96}
V.bind_boss({obj=kanako},'Kanako')
V.slot(kanako,1,15);V.slot(kanako,2,16)
V.bind_source(kanako,10,'stage06:Boss4',true);V.source_frame(kanako,2000)
check(not kanako._original_actor.slots[1] and not kanako._original_actor.slots[2], '风神录负ANM编号释放附属动画槽')
local extra={ani=0,timer=0,x=0,y=0}
V.actor(extra,8,'enemy',48);V.slot(extra,5,48)
local retained=extra._original_actor.slots[5]
V.bind_source(extra,8,'ecldata8sp:92',true)
check(extra._original_actor.archive=='stg8enm' and extra._original_actor.slots[5]==retained, '主动画跨ANM文件切换不清除独立附属动画')
local worker=function() end
V.register_functions(10,'stage05',{g02=worker})
check(V.functions[worker]=='stage05:BGirl02','无颜色名的旧工作者入口不能用I0冒充调用实参')
local fairy={ani=0,timer=0,x=0,y=0,I0=80}
V.bind_source(fairy,10,'stage05:RGirl02')
check(fairy._original_actor.archive=='enemy' and fairy._original_actor.vm.id==25,'红色包装的动画实参25不受敌机I0=80影响')
local spark=dofile('mod/GAME/th31_native.lua')
for _,base in ipairs({6,18,22}) do
    local heights=base==6 and {2,1.5,1,.5} or {3,2.5,2,1.5}
    for layer=0,3 do
        local beam={ani=0,timer=0,x=0,y=0,rot=45,_r=1,_g=1,_b=1,_a=1}
        spark.spark(beam,base+layer)
        check(beam._original_actor.archive=='stg4benm' and beam._original_actor.vm.id==base+layer,
            '火花四层分别选择调用方传入的ANM编号')
        for t=1,120 do beam.ani=t;V.tick(beam) end
        local vm=beam._original_actor.vm
        check(near(vm.scale[2],heights[layer+1]),'火花宽度使用各层原始ANM插值端点')
        draws={};spark.render_spark(beam)
        check(#draws==1 and near(draws[1].rot,45),'火花沿ECL设定方向绘制一次')
        check(draws[1].img.color.r==math.floor(vm.color[1]),'火花不叠旧代理渲染的缩放、染色和透明度')
    end
end
-- 形态光环是etama里的独立VM，不是给enemy主精灵简单改色。
local familiar={x=0,y=96,rot=0,timer=0,ani=0,th08_attached=true,th08_youkai=false}
V.bind_source(familiar,8,'ecldata3:37')
check(familiar._original_actor.archive=='enemy' and familiar._original_actor.vm.id==53,'慧音使魔主图来自原版enemy脚本53')
check(familiar._original_alignment and familiar._original_alignment.vm.data.archive=='etama'
    and familiar._original_alignment.vm.id==49,'ECL174(1)选择etama脚本49，而非默认光环48')
for i=1,8 do familiar.ani=i;V.tick(familiar) end
local halo=familiar._original_alignment.vm
check(near(halo.scale[1],.5),'高速形态按原ANM展开半径')
familiar.th08_youkai=true;V.familiar(familiar,true)
for i=9,16 do familiar.ani=i;V.tick(familiar) end
check(near(halo.scale[1],.8),'低速形态执行原作interrupt2的贴图缩放')
V.slot(familiar,0,48)
familiar._original_enemy_color={32,32,192}
draws={};V.draw(familiar)
local body
local bodyImage=A.sprite_resource(familiar._original_actor.vm).img
for _,call in ipairs(draws) do if call.name==bodyImage then body=call;break end end
check(body~=nil,'低速实际绘制原使魔主精灵')
check(body.img.color.r==32 and body.img.color.g==32 and body.img.color.b==192,'低速主VM覆写颜色，不乘原图色')
check(draws[1].img.color.r~=32 or draws[1].img.color.b~=192,'低速不把附属动画一起染蓝')
local previous=familiar._original_alignment.vm
V.familiar(familiar,true,1)
check(familiar._original_alignment.vm~=previous,'再次执行同号174也替换VM，不能复用旧动画时间轴')
familiar._original_hidden=true;draws={};V.draw(familiar)
check(#draws>0,'NO_SPRITE不抹掉独立的使魔形态光环')
familiar._original_hidden=false;V.familiar(familiar,false)
for i=17,136 do familiar.ani=i;V.tick(familiar) end
check(#familiar._original_alignment.particles<=10,'形态粒子按原ANM结束回收，长时间显示不堆积')
local mixed={x=0,y=0,rot=0,timer=0,ani=0}
V.bind_source(mixed,8,'ecldata4b:21')
mixed._original_source.cfg={events={{0,54,0},{0,61,0,0}}};mixed._original_source.index=1
V.source_frame(mixed,0)
check(mixed._original_actor.archive=='enemy' and mixed._original_actor.slots[0].data.archive=='stg4benm',
    '61指令的附属动画使用角色ANM库，不能误取主动画的公共enemy库')
-- ECL138自动接入带状绘制；以梅露兰乐器灵和管灵验证长度、判定段及每帧只采样一次。
local native=dofile('mod/GAME/th34_visual.lua')
for _,case in ipairs({{'ecldata4:77',32,16},{'ecldata4:140',64,48},{'ecldata6:4',48,16}}) do
    local o={x=0,y=96,rot=0,timer=0,ani=0}
    V.bind_source(o,7,case[1])
    check(o.th07_trail and o.th07_trail.count==case[2] and o.th07_trail.collision_count==case[3],
        '原作带状伪激光配置完整：'..case[1])
    for t=1,8 do o.x=t*4;o.timer,o.ani=t,t;V.tick(o);native.record_source(o) end
    check(#o.th07_trail.history==8,'同帧原作动画与发射器不重复采样拖尾')
    draws={};V.draw(o);check(#draws>0 and draws[1].texture~=nil,'伪激光实际绘制纹理带，不能只画头部')
end
local immortal={x=0,y=0,rot=0,timer=0,ani=0}
V.bind_source(immortal,7,'ecldata8:65');V.source_frame(immortal,900)
check(not immortal._original_actor.vm.finished,'无条件回跳后的800帧消失指令不能提前截断伪激光')
-- ExIns10/11只切换原背景VM：缓时底图半透明红、魔法阵紫色加色；恢复时回到白色普通混合。
local slowed={_original_background=true,_original_background_game=7,
    vms={A.new(7,'eff05',0),A.new(7,'eff05',1)}}
for _=1,65 do for _,vm in ipairs(slowed.vms) do A.step(vm) end end
local objectList=ObjList
ObjList=function(group)
    local done=false
    return function() if group==GROUP.GHOST and not done then done=true;return 1,slowed end end
end
V.interrupt_background(7,2)
for _=1,8 do for _,vm in ipairs(slowed.vms) do A.step(vm) end end
local base,ring=slowed.vms[1],slowed.vms[2]
check(base.alpha[1]==64 and base.color[1]==255 and base.color[2]==64 and base.color[3]==64,'缓时保留原作背景而非全屏遮黑')
check(ring.color[1]==255 and ring.color[2]==96 and ring.color[3]==255 and ring.blend=='mul+add','缓时魔法阵使用原紫色加色混合')
check(ring.omega[3]>0,'缓时旋转沿原ANM的正向减速')
draws={};for _,vm in ipairs(slowed.vms) do A.draw(vm,-224,240) end
check(#draws==2,'缓时实际绘制两层原作背景')
V.interrupt_background(7,1)
for _,vm in ipairs(slowed.vms) do
    A.step(vm)
    check(vm.alpha[1]==255 and vm.color[1]==255 and vm.color[2]==255 and vm.color[3]==255 and vm.blend=='','恢复时两层背景复原')
end
check(near(ring.omega[3],-.007853982),'恢复原作背景的负向旋转速度')
ObjList=objectList
local wrapped={init=function(o) o.x,o.y,o.timer,o.ani=0,0,0,0 end,
    frame=function() end,render=function() end,kill=function() end}
V.wrap_actor(wrapped,10,function(o,hp,x,y,mirror,drop,beh,src,inv,key) return key or 'stage01:Ecl_Girl00' end)
local entry={class={}}
wrapped.init(entry,20,-144,-16,false,{original_code=2},function() end,nil,0,'stage01:Ecl_BGirl00')
for _=1,3 do wrapped.frame(entry);entry.timer=entry.timer+1 end
check(entry._original_source.key=='stage01:Ecl_BGirl00' and entry._original_visual_args.n==9,
    '出生参数中间的nil不截断尾部原作入口，下一帧仍保留蓝妖精包装')
print(('原作ANM与资源回归通过：%d 项，%d 个作品/角色组合'):format(checks,role_count))
