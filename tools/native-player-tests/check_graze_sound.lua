-- 密集擦弹仍逐颗计数/出粒子；音效仅按当前逻辑帧合并，重试与切换场景不会漏首声。
local noop=function() end
object={};lstg={};stage={current_stage={timer=100}};GROUP={ENEMY=2};SearchStageLevel={}
function Class(base) return setmetatable({},{__index=base}) end
LoadPS,Include=noop,noop
max,min,abs,int=math.max,math.min,math.abs,math.floor
ran={Float=function(_,a,b) return (a+b)/2 end,Sign=function() return 1 end}
local grazes,sounds,sequence=0,0,0
item={PlayerGraze=function() grazes=grazes+1 end}
PlaySound=function(name) assert(name=='graze');sounds=sounds+1 end
dofile('THlib/player/player.lua')
local g={x=0,y=-100,timer=100,gp={},other_colli=noop}
local function burst(count)
    for _=1,count do grazer.colli(g,{group=1}) end
end
burst(26)
assert(grazes==26 and #g.gp==26 and sounds==1,'同帧多弹改变计数/粒子或重复播放')
stage.current_stage.timer=101;burst(2)
assert(grazes==28 and sounds==2,'下一逻辑帧漏音')
stage.current_stage={timer=101};burst(2)
assert(sounds==3,'切场景的首帧被旧计时吞掉')
stage.current_stage.timer=0;burst(1)
assert(sounds==4,'重试归零后的首声丢失')
SequenceResources={enabled=function() return true end,systemSound=function(name) assert(name=='graze');sequence=sequence+1 end}
stage.current_stage.timer=1;burst(10)
assert(sequence==1 and sounds==4 and grazes==41,'原作系统音路由或擦弹计数改变')
print('PASS 26弹同帧擦弹、跨帧、同计时切场景、重试、原作音效路由：计数和粒子保持逐颗')
