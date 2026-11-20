-- 将直接恢复的入口与正常超时路线的下一帧比较；每个入口必须一帧到达目标攻击。
local fixture=dofile('tools/likedreamer_parity/boss_fixture.lua')
local entries=dofile('mod/GAME/ports/dreamer/LikeDreamer/practice_entries.lua')
local practice=dofile('mod/GAME/ports/dreamer/LikeDreamer/practice.lua')(entries)
LikeDreamer.Projectile.spawn=function() end
LikeDreamer.Projectile.spread=function() end
LikeDreamer.Projectile.clear=function() end
Del=function(o) o.removeRequested=true end
object={RawDel=function(o)o.active=false end}
local count=0
for kind,phases in pairs(entries) do for phase,entry in ipairs(phases) do
    local stage=kind==0x14c and 10 or kind-0x137
    local rt={stage=stage,difficulty=3,frame=0,nextEntityId=1,enemiesById={},enemyCount=0}
    local objects={}
    function rt:spawn(k,hp,x,y)
        local o={runtime=self,entityId=self.nextEntityId,spawnType=k,hp=hp,maxhp=hp,ldX=x,ldY=y,
            active=true,state=0,age=0,helperTimer=0,targetable=false,protect=false}
        self.nextEntityId=self.nextEntityId+1;self.enemiesById[o.entityId]=o;objects[#objects+1]=o;return o
    end
    function rt:spawnChild(parent,...)
        local o=self:spawn(...);o.parent,o.parentEntityId,o.parentSpawnType=parent,parent.entityId,parent.spawnType;return o
    end
    local source={type=kind,phase=phase,first=({5700,9700,9500,11700,11800,12500,12500,21420,17900,18000})[stage]}
    if kind==0x14c then source.first=11900 end
    local root=practice.start(rt,source)
    rt.frame=rt.frame+1;fixture.frame=rt.frame;player.ldX,player.ldY=360,600
    local i=1
    while i<=#objects do local o=objects[i];i=i+1
        if o.active then fixture.update(o,rt);o.helperTimer,o.age=o.helperTimer+1,o.age+1 end
    end
    local label=string.format('stage=%d kind=%x phase=%d',stage,kind,phase)
    assert(root.portPhase==phase and practice.inCombat(root),'没有一帧进入目标攻击：'..label)
    assert(root.hp==entry.expected.hp and root.state==entry.expected.state,'目标 HP/状态与正常路线不同：'..label)
    assert(math.abs(root.ldX-entry.expected.x)<.001 and math.abs(root.ldY-entry.expected.y)<.001,'目标位置与正常路线不同：'..label)
    if entry.expected.countdown then assert(root.countdown==entry.expected.countdown,'目标时限不同：'..label) end
    count=count+1
end end
assert(count==61,'攻击入口不完整')
print('Like Dreamer 61 个攻击入口均在一帧内直接开放，HP、状态、坐标及时限与正常路线一致。')
