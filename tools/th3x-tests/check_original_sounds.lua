-- 实际PCM、原音量、声像、资源寿命和音效调度的专项回归。
LoadRes={};local pool='stage';local loaded,calls={},{}
GetResourceStatus=function()return pool end
SetResourceStatus=function(v)pool=v end
CheckRes=function(_,name)return loaded[name]end
LoadSound=function(name,path)
    assert(pool=='global')
    local f=assert(io.open(path,'rb'));assert(f:read(4)=='RIFF');f:close();loaded[name]=true
end
lstg={PlaySound=function(...)calls[#calls+1]={...}end};stage={current_stage={timer=0}}
local S=dofile('THlib/anm/original_sounds.lua')
for _,prepare in ipairs(LoadRes)do prepare()end
assert(#LoadRes==210,'原始SoundIdx范围变化，请核对导出表')
for _,g in ipairs({6,7,8,95,10})do S.play(g,7,96);S.play(g,7,0)end
assert(#calls==5,'同帧去重或跨作隔离失效')
for _,c in ipairs(calls)do assert(c[3]==.5,'声像被重复缩放');assert(c[2]>0 and c[2]<1)end
stage.current_stage.timer=1;S.play(6,22,-192)
assert(calls[6][1]=='th3x.original.6.22' and calls[6][3]==-1,'bulletSound编号或声像错误')
local redSounds=dofile('mod/GAME/original/sounds.lua')[6]
for id=0,31 do
    stage.current_stage.timer=id+2
    S.play(6,id,0)
    local call=calls[#calls]
    assert(call[1]=='th3x.original.6.'..id and call[2]==10^(redSounds[id][2]/2000) and call[3]==0,
        '红魔乡SoundIdx映射、原音量或声像错误：'..id)
end
assert(#calls==38,'红魔乡32种SoundIdx未全部发出')
local T=dofile('THlib/anm/th10_sounds.lua')
player={x=0,y=-180}
local function owner()return {x=0,y=100,ecs={off={x=0,y=124},base={x=0,y=0}}}end
local o=owner();T.bind(o,10,'stage07:BossCard10_tbl')
local events={}
for tick=0,10 do T.advance(o,tick,function(_,id)events[#events+1]=tick..':'..id end)end
assert(table.concat(events,',')=='0:15,1:15,2:15,3:15','wait/deci/条件跳转没有按原帧触发')
local total,programs=0,0
for index=1,7 do
    local file=('stage%02d'):format(index)
    local bank=dofile('mod/GAME/original/sound_programs.d/10_'..file..'.lua');T.banks[file]=bank
    for name in pairs(bank.active)do
        o=owner();T.bind(o,10,file..':'..name)
        for tick=0,6000 do T.advance(o,tick,function(game,id)assert(game==10 and type(id)=='number');total=total+1 end)end
        assert(o.I0==nil and o.F0==nil,'音效调度改写了战斗寄存器')
        programs=programs+1
    end
end
print('PASS 五作210个SoundIdx预载/去重/声像；风神录137个入口6000帧、独立标量和等待循环',programs,total)
