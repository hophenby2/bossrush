-- 用原始 ANM 时间点检查动画、坐标换算、旧编号和资源重载；不以代理贴图作期望值。
arg={'original-anm'}
local f=assert(io.open('tools/check_stage.lua','rb'));local setup=f:read('*a');f:close()
assert(loadstring(setup:sub(1,assert(setup:find('if path == "--all" then',1,true))-1)))()
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
GetTextureSize=function(name) return unpack(assert(textures[name],name)) end
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
local sanae={class={StageLevel=33},ani=0,timer=0,x=0,y=96}
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
print(('原作ANM与资源回归通过：%d 项，%d 个作品/角色组合'):format(checks,role_count))
