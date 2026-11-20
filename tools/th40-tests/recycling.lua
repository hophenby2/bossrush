-- 反馈符卡的持续回收检查；运行真实原生逻辑，不以卡片退出清空代替出屏回收。
local frames=tonumber(arg[1]) or 7200
arg[1]='th38-native-runtime'
local f=assert(io.open('tools/check_stage.lua','rb'));local s=f:read('*a');f:close()
assert(loadstring(s:sub(1,assert(s:find('if path == "--all" then',1,true))-1)))()
-- 实例只能拿到字段，不能隐式继承Class上的自定义方法。
New=function(cls,...)
    local o={class=cls,_live=true,timer=0,ani=0,x=0,y=0,vx=0,vy=0}
    if cls.init then cls.init(o,...) end
    return o
end
local N=dofile('mod/GAME/th40/native.lua');N.load()
local data=dofile('mod/GAME/th40/phases.lua')
local meta
for _,m in ipairs(data.phases) do if m.id==68041 then meta=m end end
assert(meta,'缺少八百里的烈焰')
local owner={x=0,y=100,hp=meta.hp,_live=true}
local run=N.new(owner,meta)
if meta.begin then meta.begin(run.host,N) end
local peak=0
for t=1,frames do
    N.tick(owner,meta)
    peak=math.max(peak,#run.objects)
    if t>=600 and t%300==0 then
        local emitters,orphans=0,0
        for _,o in ipairs(run.enemies) do
            if IsValid(o) and not o.th38_removed and o.emitter and not o.control then
                emitters=emitters+1
                if o.parent and o.parent.th38_removed and o.age>=100 then orphans=orphans+1 end
            end
        end
        assert(orphans==0,'出屏后绑定发射器未跟到父弹最终位置：'..t)
        assert(emitters<150 and #run.objects<1800,'八百里的烈焰仍有持续累积：'..t)
        print(string.format('frame=%d objects=%d emitters=%d bullets=%d',t,#run.objects,emitters,#run.bullets))
    end
end
N.stop(owner)
print(string.format('八百里的烈焰生命周期检查通过：%d帧，存活对象峰值%d。',frames,peak))
