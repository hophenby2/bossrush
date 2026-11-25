-- 模拟Sub的绘制期分组/图层禁写和销毁后字段禁读，调用实际分层绘制模块。
local phase='frame'
local invalid=setmetatable({},{__mode='k'})
local objects={}
object={}
Class=function(base) return setmetatable({},{__index=base}) end
New=function(class,...)
    assert(phase~='render','绘制阶段创建了需要改变图层的对象')
    local o={class=class};objects[#objects+1]=o;class.init(o,...);return o
end
Del=function(o) invalid[o]=true end
Render=function() end
dofile('tools/likedreamer_parity/boss_fixture.lua')
lstg.IsValid=function(o) return o and not invalid[o] end
lstg.world={l=-192,r=192,b=-224,t=224}
dofile('mod/GAME/ports/dreamer/LikeDreamer/enemy_visual_common.lua')
dofile('mod/GAME/ports/dreamer/LikeDreamer/boss_middle_visual.lua')
for _,case in ipairs({{LikeDreamer.BossEarly,0x139},{LikeDreamer.BossEarly,0x30},
        {LikeDreamer.BossMiddle,0x13c},{LikeDreamer.BossMiddle,0x50}}) do
    local fields={spawnType=case[2],active=true,status='normal',x=0,y=100,ldX=360,ldY=200,
        img='test',state=0,helperTimer=0,angle16=0,secondaryAngle16=0,radius=130,hp=100,maxhp=100,
        runtime={cameraX=360,frame=0}}
    local owner=setmetatable({}, {
        __index=function(o,k) assert(not invalid[o],'读取已销毁的分层对象所有者');return fields[k] end,
        __newindex=function(o,k,v) assert(not invalid[o]);fields[k]=v end,
    })
    local first=#objects+1
    assert(case[1].prepareVisual(owner),'未识别实际Boss/附属对象')
    local count=#objects;assert(count>=first,'未准备实际图层/血条代理')
    phase='render';case[1].render(owner)
    for i=first,count do objects[i].class.render(objects[i]) end
    phase='frame';assert(#objects==count,'渲染改变了原生对象数量')
    invalid[owner]=true
    for i=first,count do
        objects[i].class.frame(objects[i]);assert(invalid[objects[i]],'所有者退出后代理未回收')
    end
end
print('PASS Like Dreamer前中期：逻辑阶段分层准备、绘制期零出生、失效所有者安全回收。')
