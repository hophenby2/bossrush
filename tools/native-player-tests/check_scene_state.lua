-- Tests source time separation, waits, transitions and full geometry preservation.
local A=dofile('mod/GAME/th37/scene_state.lua')
local s=A.new(4,1)
assert(A.find(s,1000) and A.find(s,2000) and A.find(s,3000))
assert(s.eye[2]==250 and s.eye[3]==-206 and s.at[2]==-160 and s.speed[3]==.5)
local uv=A.find(s,2000).uv;assert(uv[1]==0 and uv[2]==.0002)
local t,z=s.time,s.travel[3];for _=1,60 do A.step(s,true) end
assert(s.time==t and s.travel[3]==z+30,'Boss wait must hold the script only')
s=A.new(4,1921);assert(not A.find(s,1000) and A.find(s,1001) and A.find(s,1002))
s=A.new(4,3121);assert(not A.find(s,2000) and not A.find(s,3000))
s=A.new(4,13000);assert(s.time<13000 and s.time>12000 and not A.find(s,1001),'UntilModelComing wait lost')
s=A.new(6,4000);assert(s.time==2760 and s.mode=='music')
s=A.new(6,6000,{[4680]=true});assert(s.time==4081 and s.mode=='boss','Practice preroll lost the source BGM cue')
for _,c in ipairs({5,7,8}) do s=A.new(c,1);assert(s.eye[3]==-146.684,'ChangeView zero coordinates must keep existing axes') end
local triangles=0;for _,p in ipairs(dofile('mod/GAME/th37/scenes/models/1305.lua')) do triangles=triangles+#p[3]/15 end
assert(triangles==55934,'Original mesh was simplified')
local B=dofile('mod/GAME/th40/scene_state.lua')
s=B.new('1',0);assert(#s.objects==141,'Original ground/tree/cloud population')
s=B.new('2',1);assert(s.eye[3]==70 and s.eye[2]==1 and s.y1==-1000+19*133)
s=B.new('4',550);assert(s.eye[3]==250 and #s.objects==2 and s.fogEnd==2000000)
s=B.new('4',4300);assert(#s.particles==1 and s.particles[1].aurora)
s=B.new('5',8601);assert(#s.objects==1 and s.objects[1].name=='祭坛' and s.objects[1].scale==10 and s.velocity==0)
s=B.new('6',800);assert(#s.objects>0 and s.objects[1].name=='云（亮层）')
for _,c in ipairs({'1','2','3','4','5','6','EX'}) do
    s=B.new(c,12000)
    assert(#s.objects<200 and #s.particles<60,'Background objects leak')
    for _,v in ipairs(s.eye) do assert(v==v and math.abs(v)<100000) end
end
print('原始网格、Boss/BGM等待、模型到达与七场景转换检查通过')
-- Practice entry must obtain the clock from its injected catalogue, with no TH40 global.
local Data=dofile('mod/GAME/th40/phases.lua')
function Class(_,methods) return methods end
lstg={tmpvar={},var={}};LAYER={BG=-700};setting={displayBG=true}
background={init=function(o) lstg.tmpvar.bg=o end}
function IsValid(o) return o and o.valid end
function New(cls) local o={class=cls,valid=true};cls.init(o);return o end
local BG=assert(loadfile('mod/GAME/th40/background.lua'))({backgrounds=function() end},Data)
local phase
for _,p in ipairs(Data.phases) do if p.chapter=='1' and p.role=='boss' then phase=p;break end end
local bg=BG.enter('1',assert(phase))
assert(bg.scene.story==Data.stages['1'].clock[3],'Practice did not seek the original boss clock')
lstg.tmpvar.bg=nil
bg=BG.enter('1',{part='b',role='road'})
assert(bg.scene.story==Data.stages['1'].clock[2],'Road B practice did not seek the original clock')
print('夏夜祭关底和后半道中练习入口检查通过')
