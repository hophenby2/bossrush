-- 双进程网络测试宿主；只在临时目录运行，通过正式大厅 HTTP API 控制房间。
local R=dofile(assert(arg[1])..'/tools/save-tests/runtime.lua');local root=R.root
local function load(path) return dofile(root..'/'..path) end
local C,P,T=R.C,R.P,R.N;P.init()
local W=load('THlib/net/codec.lua');local N=load('THlib/net/session.lua')
N.hash=string.rep(arg[3] or 'a',64)
AndroidInput=arg[4]=='touch' and {reset=function() end,readMovement=function(out) out.touch_x,out.touch_y,out.touch_unlimited=N.testX,N.testY,N.testUnlimited end} or nil
AndroidPlatform=arg[4]=='touch' and {} or nil -- 仅标记测试客机的触屏输入方式，不加载安卓图形环境。
lstg={var={},SystemLog=function(s) print(s);io.stdout:flush() end}
setting={keys={up=1,down=2,left=3,right=4,slow=5,shoot=6,spell=7,special=8}}
GetKeyState=function(code) return math.floor((N.testMask or 0)/2^(code-1))%2==1 end
KeyState={};KeyStatePre={};scoredata={money=321,hiscore={}};spell_card_data={}
EncodeSpellCardData=function() return spell_card_data end
GetSaveMoneyState=function() return {offset=19,fraction=.5} end;SetSaveMoneyState=function() end
SaveScoreData=function() end;SaveSpellCardData=function() end
stage={current_stage={is_menu=true},stages={menu={}},groups={BossRush={}},group={}}
stage.New=function(name) local s={stage_name=name};stage.stages[name]=s;return s end
stage.Set=function(_,name) stage.current_stage=name=='menu' and {is_menu=true} or {is_menu=false};stage.next_stage=nil end
stage.group.Start=function()
    stage.current_stage={is_menu=false};N.players={{x=-28,y=-176,death=0},{x=28,y=-176,death=0}}
end
RogueTen={start=stage.group.Start};IsValid=function(o) return type(o)=='table' end
ext={pause_menu={init=function() end}};SaveResume=nil
local frames=0
N.Capture={reset=function() frames=0 end,sendResources=function() N.peer:send('R',W.encode({})) end,
    receiveResources=function(bytes) W.decode(bytes,function() end) end,
    receiveFrame=function(bytes) local v=W.decode(bytes,function() end);frames=frames+1;N.testFrame=v;N.receivedFrames=frames end,updateParticles=function() end}
local S=load('THlib/save/service.lua');S.start();S.visible=true;S.heartbeat=T.now()
local f=assert(io.open('peer.json','w'));f:write(Serialize({port=S.server.port,token=S.localToken}));f:close()
if R.ffi.os=='Windows' then R.ffi.cdef[[void Sleep(unsigned long);]] else R.ffi.cdef[[int usleep(unsigned int);]] end
local sent,last,read=0,0,0
while true do
    N.poll();S.poll();if N.client() then N.clientFrame() end;local now=T.now()
    if now-read>.01 then
        read=now;local config=io.open('keys.json','rb');if config then local v=DeSerialize(config:read('*a'));config:close();N.testMask=v.mask;N.testX,N.testY,N.testUnlimited=v.x,v.y,v.unlimited end
    end
    if N.host() and N.readyForLogic() and now-last>=.02 then
        last=now;N.readKeys(KeyState);N.beforeLogic()
        for i,p in ipairs(N.players) do local k=N.keys[i];p.x=p.x+(k.right and 1 or 0)-(k.left and 1 or 0) end
        N.peer:send('F',W.encode({tick=N.tick,players=N.players}),true);sent=sent+1
    end
    if now-(N.testStatusAt or 0)>.03 then
        N.testStatusAt=now;local status=N.info();status.tick=N.tick;status.sent=sent;status.lastFrame=N.testFrame;status.inputs=N.keys
        local out=assert(io.open('status.tmp','w'));out:write(Serialize(status));out:close();os.remove('status.json');assert(os.rename('status.tmp','status.json'))
    end
    if R.ffi.os=='Windows' then R.ffi.C.Sleep(1) else R.ffi.C.usleep(1000) end
end
