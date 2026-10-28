-- 联机回归：严格对象语义、正式双自机逻辑、报文边界、透明度恢复与单人存档隔离。
local R=dofile(assert(arg[1])..'/tools/save-tests/runtime.lua');local root=R.root
local function source(path) local f=assert(io.open(root..'/'..path,'rb'));local s=f:read('*a');f:close();return s end
local function load(path) return assert(loadstring(source(path),'@'..path))() end
local count=0
local function check(v,label) assert(v,label);count=count+1 end
local function rejects(fn,label) check(not pcall(fn),label) end
local noop=function() end
lstg={var={},world={l=-192,r=192,b=-224,t=224,pl=-192,pr=192,pb=-224,pt=224},worldoffset={},view3d={}}
screen={dx=10,dy=20,scale=2}
local resources,states,draws,pool={},{},{},'global'
function Color(a,r,g,b)
    local c=newproxy(true);getmetatable(c).__index={ARGB=function() return a,r,g,b end};return c
end
local function register(kind,name) resources[kind..':'..name]=pool end
CheckRes=function(kind,name) assert(({tex=true,img=true,ani=true,psi=true,fnt=true,ttf=true,fx=true,snd=true,bgm=true})[kind],'资源类型无效');return resources[kind..':'..name] end
GetResourceStatus=function() return pool end;SetResourceStatus=function(v) pool=v end
for fn,kind in pairs({LoadTexture='tex',LoadImage='img',LoadAnimation='ani',LoadPS='psi',LoadFont='fnt',LoadTTF='ttf',LoadFX='fx',LoadSound='snd',LoadMusic='bgm',CopyImage='img',CopyAnimation='ani',CreateRenderTarget='tex'}) do
    _G[fn]=function(name) register(kind,name) end;lstg[fn]=_G[fn]
end
for _,name in ipairs({'SetImageCenter','SetAnimationCenter','SetImageScale','SetAnimationScale','SetTextureSamplerState','PlaySound','PlayMusic','StopMusic','PauseMusic','ResumeMusic','SetBGMVolume','SetFog','SetWorldFlag'}) do _G[name]=noop;lstg[name]=noop end
RemoveResource=function() end
local function style(img,blend,c,r,g,b) local a;if type(c)=='userdata' then a,r,g,b=c:ARGB() else a=c end;states[img]={blend,a or 255,r or 255,g or 255,b or 255} end
for _,name in ipairs({'SetImageState','OriginalSetImageState','SetAnimationState','OriginalSetAnimationState','SetFontState','OriginalSetFontState'}) do _G[name]=style;lstg[name]=style end
for _,name in ipairs({'Render','RenderRect','Render4V','RenderAnimation','RenderTexture','RenderTTF','RenderText','RenderClear','PushRenderTarget','PopRenderTarget','PostEffect','PostEffectCapture','PostEffectApply','SetOrtho','SetPerspective','SetViewport','SetScissorRect','ClearZBuffer','SetZBufferEnable'}) do
    _G[name]=function(...) draws[#draws+1]={name=name,args={...},style=states[(...)]} end;lstg[name]=_G[name]
end
SetViewMode=function() end;Set2D=SetViewMode;Set3Dwithmode=SetViewMode
DefaultRenderFunc=function(o) draws[#draws+1]={name='Default',args={o.img,o.x,o.y},style=states[o.img]} end
local W=load('THlib/net/codec.lua')
local decoded=W.decode(W.encode({text='中文',values={n=5,0,-8.5,nil,true,'中文'},color=Color(120,32,64,200)}),Color)
check(decoded.text=='中文' and decoded.values.n==5 and decoded.values[3]==nil and decoded.values[4]==true,'字典、中文、浮点与空参数往返')
check(({decoded.color:ARGB()})[1]==120,'颜色往返')
local shared={'',200,255,255,255};local repeated=W.decode(W.encode({shared,shared}),Color)
check(repeated[1]==repeated[2],'相同绘制状态使用表引用压缩并正确重建')
rejects(function() W.decode('\10\0\1',Color) end,'拒绝前向或循环表编号')
rejects(function() W.decode('\5\0\1',Color) end,'拒绝悬空字符串编号')
rejects(function() W.decode('\4\0\0\128\127',Color) end,'拒绝无穷浮点')
rejects(function() W.decode(W.encode(1)..'x',Color) end,'拒绝尾随数据')
rejects(function() W.encode({n=65536}) end,'限制数组长度')
local tree={};tree.next=tree;rejects(function() W.encode(tree) end,'限制循环引用深度')
math.randomseed(29371)
for _=1,1000 do local s={};for i=1,math.random(1,50) do s[i]=string.char(math.random(0,255)) end;pcall(W.decode,table.concat(s),Color) end
check(true,'随机畸形输入不越界或崩溃')
local N=load('THlib/net/session.lua');local Capture=load('THlib/net/capture.lua')
load('THlib/lib/Lobject.lua');object.EnemyNontjtDo=function() end;Capture.install()
local objects={}
IsValid=function(o) return type(o)=='table' and o._alive==true end
local nativeNew=function(class,...)
    local o={class=class,_alive=true,x=0,y=0,rot=0,hscale=1,vscale=1,dx=0,dy=0,vx=0,vy=0,ani=0,timer=0,colli=true,group=0,world=1,rect=false}
    objects[#objects+1]=o;class[1](o,...);return o
end
New=nativeNew;lstg.New=New
ObjList=function(group) local i=0;return function() repeat i=i+1 until not objects[i] or (objects[i]._alive and objects[i].group==group);if objects[i] then return i,objects[i] end end end
load('THlib/rank.lua')
Del=function(o) o._alive=false end;ObjFrame=noop;UpdateXY=noop;AfterFrame=noop
plus=plus or {};load('THlib/plus/Utility.lua');load('THlib/eventListener.lua')
Forbid=function(x,a,b) return math.max(a,math.min(b,x)) end
abs=math.abs;min=math.min;max=math.max;int=math.floor;SQRT2_2=2^-0.5
cos=function(v) return math.cos(math.rad(v)) end;sin=function(v) return math.sin(math.rad(v)) end
Dist=function(a,b) return ((a.x-b.x)^2+(a.y-b.y)^2)^0.5 end
Include=function(path) return load((path:gsub('\\','/'))) end
task={Do=noop,Clear=noop,SetMode={[2]=function(x) return x end,[3]=function(x) return x end}}
SearchStageLevel={};GetGlobal=function(k) return lstg.var[k] end
SetCurSystem=noop;System=Class(object);BulletBreak_Table=Class(object)
PlayerWalkImageSystem=function(p) return {frame=noop,render=function() Render('hero',p.x,p.y,0,1,1) end} end
load('THlib/player/player.lua')
local shot=Class(object,{init=function(o) o.img='shot';o.group=3;o.x=player.x end})
reimu_player=Class(player_class,{init=function(o) player_class.init(o);o.name='Reimu' end,shoot=function() New(shot) end})
marisa_player=reimu_player;aya_player=reimu_player;chiruno_player=reimu_player
InitAllClass();LoadTexture('test','THlib/test.png');LoadImage('hero','test',0,0,16,16);LoadImage('shot','test',0,0,4,4)
lstg.var={init_player_data=true,current_system='',dead=0,man=0};KeyState={};KeyStatePre={}
N.match=true;N.role='host';N.hero='reimu_player';N.guestHero='reimu_player';N.keys={{},{}};N.spawnPlayers()
local p1,p2=N.players[1],N.players[2]
check(p1~=p2 and p1._net_slot==1 and p2._net_slot==2 and p1.x==-28 and p2.x==28,'两个独立的同角色自机与出生位置')
check(p1.grazer._net_slot==1 and p2.grazer._net_slot==2,'擦弹器继承各自所有权')
local systems=0;for _,o in ipairs(objects) do if o.class==System then systems=systems+1 end end;check(systems==1,'共享系统只建立一次')
KeyState={left=true,shoot=true};N.keys[2]={right=true,slow=true,shoot=true};N.beforeLogic()
p1.class[3](p1);p2.class[3](p2)
check(p1.x==-32 and p2.x==30,'双方输入独立且低速各自生效')
check(player==p1 and lstg.player==p1 and N.contextSlot==0,'每个回调后恢复主玩家上下文')
local owned={};for _,o in ipairs(objects) do if o.group==3 then owned[o._net_slot]=o.x end end
check(owned[1]==-28 and owned[2]==28,'两位自机射击继承正确的角色与位置')
local first=true;N.forEachPlayer(function(p) check(player==p,'手动激光碰撞使用对应玩家上下文');if p==p2 then p.death=90 end end)
check(p1.death==0 and p2.death==90 and player==p1,'独立死亡状态')
N.keys[2]={shoot=true};N.lastMissSlot=2;local quizPlayer
N.quiz(function() quizPlayer=player;check(KeyState.shoot and not KeyState.left,'客机答题输入使用自己的按键') end,{})
check(quizPlayer==p2 and player==p1 and KeyState.left,'最后中弹玩家答题，之后恢复房主输入')
local sent={};N.peer={send=function(_,kind,body) sent[kind]=body;return true end};N.connected=true;N.ready=true;N.epoch=SaveTransport.now()-1
Capture.begin();draws={};SetImageState('hero','',200,255,255,255)
p2.class[4](p2)
check(draws[#draws].style[2]==130 and states.hero[2]==200,'房主看到客机 65% 不透明度，绘制后恢复共享贴图状态')
p1.class[4](p1);check(draws[#draws].style[2]==200,'相同贴图的房主自机仍为全不透明度')
Capture.finish();check(sent.R and sent.F,'生成资源和画面快照')
N.role='client';N.predict=nil;Capture.receiveFrame(sent.F);check(N.receivedFrames==1 and player.x==p2.x,'接收画面后建立 P2 移动代理')
local proxy=player;N.pause={false,true};Capture.receiveFrame(sent.F);check(player==proxy,'连续快照保留拖拽对象身份')
check(N.pause[2]==true,'迟到画面不能覆盖可靠通道中的暂停指令');N.pause={false,false}
draws={};Capture.render();check(draws[1].style[2]==200 and draws[2].style[2]==130,'客机看到自己全不透明、房主半透明')
N.role='host';Capture.last=nil;Capture.begin();GetTextureSize=function() if N.role=='host' then return 200,100 else return 400,300 end end
CreateRenderTarget('net-target');local vertex={0,0,.5,100,50,Color(255,255,255,255)}
RenderTexture('net-target','',vertex,vertex,vertex,vertex);Capture.finish()
N.role='client';Capture.receiveFrame(sent.F);draws={};Capture.render()
check(draws[1].args[3][4]==200 and draws[1].args[3][5]==150,'不同分辨率按渲染目标比例换算 UV，避免拉伸或黑块')
local oldSetting,oldScreen=setting,screen;setting={resx=200,resy=100};screen={dx=20,dy=10,scale=2}
N.role='host';Capture.last=nil;Capture.begin();RenderTexture('net-target','',vertex,vertex,vertex,vertex);Capture.finish()
N.role='client';screen={dx=40,dy=30,scale=3};Capture.receiveFrame(sent.F);draws={};Capture.render()
check(draws[1].args[3][4]==160 and draws[1].args[3][5]==90,'全窗口渲染目标按逻辑视口换算 UV，正确处理两端留黑边差异')
setting,screen=oldSetting,oldScreen

N.role='host';N.players={p1,p2};Capture.last=nil;Capture.begin()
ClearZBuffer();SetZBufferEnable(1);
LoadFont('net-font','THlib/test.fnt');SetFontState('net-font','',255,255,255,255);RenderText('net-font','联机',12,34,1,0)
SetZBufferEnable(0);Capture.finish();N.role='client';Capture.receiveFrame(sent.F);draws={};Capture.render()
check(draws[1].name=='ClearZBuffer' and draws[2].name=='SetZBufferEnable' and draws[#draws].name=='SetZBufferEnable','三维背景深度状态按原顺序同步')
check(draws[#draws-1].name=='RenderText','字体显示使用 fnt 资源类型，支持正式 CheckRes')
N.role='host';sent.R=nil;Capture.sendResources();check(sent.R==nil,'资源未改变时不重复传输全表')
LoadImage('new-image','test',0,0,8,8);Capture.sendResources()
local delta=W.decode(sent.R,Color);check(#delta==1 and delta[1][2][1]=='new-image','新资源只发送增量')
sent.R=nil;Capture.sendResources(true);check(#W.decode(sent.R,Color)>1,'重连强制补齐完整资源')
N.summary={won=true};N.newRound();check(N.summary==nil and DeSerialize(sent.J).t=='new-round','合作结果页再开一局时通知客机清除旧结算')
N.role='client'
rejects(function() Capture.receiveResources(W.encode({{'LoadTexture',{'evil','THlib/../../User/secret'},'global'}})) end,'资源路径禁止越界')
rejects(function() Capture.receiveFrame(W.encode({tick=1,time=1,calls={{99,0,0,0,0,{}}}})) end,'拒绝未知绘制操作')
rejects(function() Capture.receiveResources(W.encode({{'LoadAnimation',{'huge','test',0,0,16,16,65535,65535,1},'global'}})) end,'拒绝超量动画分配')
-- 使用正式激光 frame，确认两位玩家都被检测，光束逻辑仅执行一次。
N.role='host';N.match=true
LoadImageGroup=function(prefix,tex,x,y,w,h,cols,rows) for i=1,cols*rows do LoadImage(prefix..i,tex,x,y,w,h) end end
local include=Include;Include=noop;load('THlib/laser/laser.lua');Include=include;InitAllClass()
local hits={0,0};local function laserPlayer(i,x)
    local p={_alive=true,x=x,y=0,grazer={a=24},class={colli=function(o) check(player==o,'激光回调保持自机上下文');hits[i]=hits[i]+1 end}}
    p.grazer.class={colli=function() end};return p
end
N.players={laserPlayer(1,50),laserPlayer(2,60)};player=N.players[1];lstg.player=player
local beam=New(laser,1,0,0,0,10,100,10,10,0,0);beam.w=10;beam.alpha=1;beam.counter=2;beam.dw=1;beam.da=0;beam.timer=1
beam.class[3](beam)
check(hits[1]==1 and hits[2]==1 and beam.counter==1 and beam.w==11,'同束激光碰撞两位玩家，宽度和计数只推进一次')
-- 正式存档入口在联机时不得写单人文件。
load('THlib/lib/Lscoredata.lua');local writes=0;SaveProfiles.write=function() writes=writes+1 end
scoredata={money=123,hiscore={}};spell_card_data={};SaveScoreData();SaveSpellCardData();check(writes==0,'联机中屏蔽单人磁盘写入')
N.match=false;SaveScoreData();SaveSpellCardData();check(writes==2,'离开联机后恢复正常保存')
stage={current_stage={is_menu=false}};lstg.var.__resume_version=1
rejects(function() N.create({}) end,'单人游戏中建房须先返回标题')
N.leave();check(lstg.var.__resume_version==1,'只关闭大厅连接不会清除单人续玩标记')
print('联机核心回归通过：'..count..' 项，含 1000 个畸形报文。')
