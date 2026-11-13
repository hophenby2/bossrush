-- 原生对象长时间生命周期检查；不用全局对象历史表，保留真实Class.init语义。
local frames=tonumber(arg[1]) or 7200
local only={};for id in (os.getenv('TH38_TEST_IDS') or ''):gmatch('%d+') do only[tonumber(id)]=true end
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
local peak,checked,created=0,0,0
local new=New
-- N已经缓存New；用spawn计数，避免改变待测对象生命周期。
for _,route in ipairs({'A','B','C','D'}) do
    lstg.var.th38_route=route
    for _,meta in ipairs(data.phases) do
      if not next(only) or only[meta.id] then
        -- 所有阶段跑足长窗口，覆盖原总时钟循环、HP分支与遮罩。
        lstg.var.th38_seed=route:byte()+meta.id
        local owner={x=0,y=100,hp=meta.hp,_live=true}
        local run=N.new(owner,meta)
        if meta.begin then meta.begin(run.host,N) end
        local steps=frames
        if route~='A' then steps=600 end
        for t=1,steps do
            if meta.source=='SpellCard_SSS06_06' then owner.hp=meta.hp*(1-t/steps) end
            N.tick(owner,meta)
            peak=math.max(peak,#run.objects)
            if t%120==0 then
                for _,b in ipairs(run.objects) do
                    assert(b.cx==b.cx and b.cy==b.cy and b.speed==b.speed,'坐标/速度出现NaN：'..meta.id)
                    assert(b.vx==0 and b.vy==0,'手动运动对象不能再次由引擎积分')
                end
            end
        end
        local objects=run.objects;created=created+#objects
        N.stop(owner)
        assert(not owner.th38_run and #run.objects==0,'阶段退出未清空宿主')
        for _,b in ipairs(objects) do assert(b.th38_removed and not IsValid(b),'阶段退出留下存活对象：'..meta.id) end
        checked=checked+1
        io.write(string.format('%s:%d ',route,meta.id));io.flush()
      end
    end
end
print(string.format('\n原生对象检查通过：%d阶段/路线，A路线每段%d帧，其余每段600帧；峰值%d。',checked,frames,peak))
