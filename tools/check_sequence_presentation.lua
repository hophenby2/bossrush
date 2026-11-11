-- 原作音效事件、续关录像输入与TH10生成圆环的回归；不访问玩家存档/录像。
dofile('tools/check_sequence_player.lua')
local P,A=SequenceResources,OriginalANM
local count=0
local function check(ok,message) assert(ok,message);count=count+1 end
local function near(a,b) return math.abs(a-b)<1e-5 end
local function start(game,machine)
    lstg.var={__sequence_version=1,__sequence_system_version=1,sequence_key=game==8 and 'th08_lunatic_b' or ('th%02d_lunatic'):format(game),sequence_player=machine,player_name='reimu_player'}
    item.PlayerInit();player=P.spawnPlayer();player.original_respawn=nil;return player,P.state()
end
local events={}
OriginalStageVisual={presentation={sound={play=function(game,id,x) events[#events+1]={game,id,x} end}}}
local entries=dofile('mod/GAME/original/sounds.lua')
for _,row in ipairs({{6,21,31,28,30,20},{7,21,31,28,30,20},{8,21,31,28,30,37},{10,20,29,44,false,35}}) do
    local g= row[1];local p,s=start(g,P.machines(g)[1].id)
    events={};P.systemSound('pickup',48);check(events[1][2]==row[2] and events[1][3]==48,'拾取使用各作SoundIdx及横向声像')
    events={};s.power=(g==10 and 20 or 8)-2;P.collect('power',0,false);check(#events==0,'未跨火力档不播升级音')
    P.collect('power',0,false);check(#events==1 and events[1][2]==row[3],'跨火力档播原作升级音')
    events={};P.collect('full',0,false);check(#events==1 and events[1][2]==row[3],'满火道具跨多个档位只提示一次')
    events={};P.collect('full',0,false);check(#events==0,'已有满火不重复播升级音')
    P.systemSound('extend');check(events[1][2]==row[4],'残机奖励使用本作extend')
    events={};P.systemSound('graze');check(row[5] and events[1][2]==row[5] or not row[5] and #events==0,'风神录不播框架擦弹声，其他作品使用各自原音')
    events={};P.systemSound('damage_low');check(events[1][2]==row[6],'低血命中音使用本作表')
    for _,event in ipairs(events) do check(entries[g][event[2]]~=nil,'事件的原始音效必须存在') end
end
local p,s=start(8,'team0');lstg.var.pointrate=300000;s.human=0
check(P.collect('point',180,false),'永夜抄高位蓝点选择满价值音')
check(not P.collect('point',-180,false),'低位蓝点保留普通拾取音')
check(not P.collect('power',180,true),'P道具不会误用蓝点满价值音')
s.human=-10000
check(P.collect('point',224-P.data(8,p.original_machine.primary).poc,false),'极人类加分后达到满价值仍使用原音')
local p,s=start(7,'sakuyaa');s.bombs=3;events={}
P.bombInput(p,{spell=true,slow=true},{},false)
for _=0,20 do P.stepBomb(p) end
check(events[1][2]==5 and events[#events][2]==6,'咲夜低速Bomb在开卡与20帧发射期使用两种原音')
-- 用正式GetInput写入内存录像，再回放相同输入；触控不直接改变续关状态。
local p,s=start(6,'reimua');s.lives=-1
local scene={timer=100,sequence_music='test'};stage.current_stage=scene
local finished=false;OriginalSequence.finish=function() finished=true end
PauseMusic=function() end;ResumeMusic=function() end
KeyState={};P.continueFrame(scene)
for _=2,29 do KeyState={shoot=true,up=true};P.continueFrame(scene) end
check(not finished and not scene.sequence_continue.yes,'续关保持30帧锁定及默认结束')
local menu=scene.sequence_continue;KeyState={};P.continueFrame(scene)
local drawPanel
ext.pause_menu={RenderText=function() end,render=function(panel) drawPanel=panel end}
SetViewMode=function() end
P.renderContinue(scene)
check(drawPanel.panel_title=='是否续关？' and drawPanel.panel_rows[1]=='继续' and drawPanel.pos==2,'续关复用原生暂停面板')
drawPanel.on_select(1);check(not menu.yes,'触控只排队，不绕过录像输入')
setting={keys={up=38,down=40,shoot=90,spell=88}};KEY={CTRL=17}
GetKeyState=function() return false end
local recording=true;ext.replay={IsRecording=function() return recording end,IsReplay=function() return not recording end}
local savedInput;replayWriter={Record=function(_,keys) savedInput={};for k,v in pairs(keys) do savedInput[k]=v end end}
dofile('THlib/lib/Linput.lua');GetInput()
check(savedInput.up and savedInput.shoot,'触控选择编码后才进入录像Record')
P.continueFrame(scene)
check(scene.sequence_continue==nil and s.continues==1 and not finished,'触控继续由普通输入恢复游戏')
s.lives=-1;s.continues=0;scene.sequence_continue={time=30,yes=false,previous={}}
recording=false;replayReader={Next=function(_,keys) for k in pairs(keys) do keys[k]=nil end;for k,v in pairs(savedInput) do keys[k]=v end end}
GetInput();P.continueFrame(scene)
check(scene.sequence_continue==nil and s.continues==1,'相同录像输入重现续关选择')
-- TH10源码的mode9参数是带宽/半径，32对顶点、3次整纹理重复，不是精灵宽高缩放。
local quads={};CheckRes=function() return true end;GetTextureSize=function() return 256,256 end
RenderTexture=function(tex,blend,a,b,c,d) quads[#quads+1]={a,b,c,d} end
lstg.SetTextureSamplerState=function() end
local ring=A.new(10,'bullet',394,nil,nil,nil,true)
for _=1,59 do A.step(ring) end
A.draw_vm(ring,13,-17)
check(#quads==62,'原作32对strip顶点生成31段、62个非退化三角形')
for i,q in ipairs(quads) do
    for _,v in ipairs(q) do
        local radius=((v[1]-13)^2+(v[2]+17)^2)^.5
        check(near(radius,144) or near(radius,176),'60帧时半径160、宽度32；不乘精灵像素大小')
    end
    local segment=math.floor((i-1)/2)
    check(near(q[1][5],segment*3/31*256) and near(q[3][5],(segment+1)*3/31*256),'沿整圈重复纹理三次')
end
check(near(quads[1][2][1],quads[62][3][1]) and near(quads[1][2][2],quads[62][3][2]),'闭合顶点复制首点，不留接缝')
local rngCount=0
local rng={Float=function(_,a,b) rngCount=rngCount+1;return a+(b-a)*.25 end,Int=function(_,a,b) rngCount=rngCount+1;return a end}
local tree=A.new(10,'bullet',400,nil,nil,rng,true)
for _=1,132 do A.step(tree) end
check(tree.finished and not tree.visible,'脚本51时刻到达后仅根控制器删除（循环指令仍按原作计时）')
local visible=0
for _,vm in ipairs(A.collect_draw_vms(tree,{})) do if vm.visible then visible=visible+1 end end
check(visible>0,'根控制器删除后子圆环继续到原作各自的消散时刻')
local correctedCount=rngCount;rngCount=0
local old=A.new(10,'bullet',400,nil,nil,rng)
for _=1,132 do A.step(old) end
check(correctedCount==rngCount,'原作随机角度修正不增加随机数调用，保留弹幕随机序列')
for _=133,200 do A.step(tree) end
visible=0;for _,vm in ipairs(A.collect_draw_vms(tree,{})) do if vm.visible then visible=visible+1 end end
check(visible==0,'所有子演出按ANM结束，无残留大贴图')
p,s=start(10,'reimua');s.power=100;boss_group={{_live=true,is_sc=true,current_card={card_id=3600}}}
P.bombInput(p,{spell=true},{},false)
check(p.original_bomb_vms[1].id==441,'神德使用原作缩小灵击演出441')
check(s.bomb.spec.duration==180 and s.power==80,'修正绘制不改变灵击时间与消耗')
print('顺序模式音效、续关录像和灵击圆环检查通过：'..count)
