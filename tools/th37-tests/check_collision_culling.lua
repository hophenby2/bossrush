-- 五面三张真实非符：远弹跳过宿主开关后，扫掠命中/擦弹帧次与消弹恢复仍相同。
arg={'spring-collision-culling'}
local f=assert(io.open('tools/check_stage.lua'));local src=f:read('*a');f:close()
assert(loadstring(src:sub(1,assert(src:find('if path == "--all" then',1,true))-1)))()
lstg.AndroidProjectBullet=function(b,img,x,y,rot,hs,vs,a,bb,layer,group,colli)
    b.x,b.y,b.rot,b.hscale,b.vscale,b.a,b.b,b.layer,b.group,b.colli=x,y,rot,hs,vs,a,bb,layer,group,colli
end
local R=dofile('mod/GAME/th37/runtime.lua');R.useStatePool=false;R.sound=function()end
GetGlobalColliderScale=function()return 1 end
ObjList=function()local i=0;return function()i=i+1;if i==1 then return i,player elseif i==2 then return i,player.grazer end end end
local originalNew=New
for _,id in ipairs({'581','583','585'})do
    local samples={}
    for _,culling in ipairs({false,true})do
        local objects,events,calls,tickNow={},{},0,0
        R.cullDistantCollisions=culling
        New=function(cls,...)local b=originalNew(cls,...);objects[#objects+1]=b;return b end
        player.x,player.y,player.colli=0,-180,true
        player.class={colli=function(_,b)
            events[#events+1]=tickNow..':hit'..b.mhj.serial
            b.class.kill(b)
        end}
        player.grazer={_live=true,a=24,b=24,class={colli=function(_,b)
            events[#events+1]=tickNow..':graze'..b.mhj.serial;b._graze=true
        end}}
        ran.Float=function(_,a,b)return (a+b)/2 end
        local c=R.controller({_live=true,x=0,y=100},id)
        for tick=1,900 do
            tickNow=tick
            R.tick(c);local n=#objects
            for i=1,n do local b=objects[i];if IsValid(b) and b.class.frame then b.class.frame(b)end end
            R.beginCollisions();calls=calls+R.collisionCount
            if culling then
                for _,b in ipairs(objects)do
                    if IsValid(b) and b.colli then
                        local reach=(b.mhj.collisionRadius or 0)+24
                        assert((b.x-player.x)^2+(b.y-player.y)^2>reach^2,'候选筛选漏掉宿主可能命中的端点')
                    end
                end
            end
            R.finishCollisions()
            for _,b in ipairs(objects)do
                if IsValid(b) and b.mhj and b.mhj.dis then assert(not b.colli,'已消弹对象被恢复判定')end
            end
            local live={};for _,b in ipairs(objects)do if IsValid(b)then live[#live+1]=b end end;objects=live
        end
        -- 两次运行新建的对象地址不同，弱表 pairs 次序没有跨运行的保证。
        -- 比较每帧实际命中/擦弹对象，避免把地址顺序当成运动逻辑差异。
        table.sort(events);samples[#samples+1]=table.concat(events,',')
        if culling then assert(calls>0,'未覆盖近处弹体开关')end
        print(id,'远弹筛选='..tostring(culling),'碰撞开关='..calls)
        R.clear(c)
    end
    assert(samples[1]==samples[2],'远弹筛选改变碰撞/擦弹结果或帧次：'..id)
    print('PASS 春雪 '..id..'：筛选前后的命中、擦弹与消弹恢复一致')
end
New=originalNew
R.clearAll();R.cullDistantCollisions=true
player.class={colli=function()end};player.grazer.class.colli=function()end
local function candidate(label,x,previous,radius,offset,expected)
    local s={kind='projectile',fx=x,fy=407,previousX=previous,previousY=407,collisionRadius=radius,
        controller={positionx=offset},pattern=R.loadPattern('581'),type=1,wscale=1,hscale=1,life=100,age=30}
    local b={_live=true,colli=true,mhj=s};R.objects[b]=s
    local effect={_live=true};R.objects[effect]=true -- 敌人/死亡特效不携带弹体状态。
    R.beginCollisions();assert(R.collisionCount==expected,label);R.finishCollisions()
    R.objects[b],R.objects[effect]=nil,nil
end
candidate('远弹未跳过',517,517,4,0,0)
candidate('高速跨越漏判',1000,-1000,4,0,1)
candidate('大判定漏判',517,517,250,0,1)
candidate('平移后的端点漏判',517,517,4,-200,1)
GetGlobalColliderScale=function()return 2.5 end
candidate('全局判定缩放漏判',607,607,100,0,1)
GetGlobalColliderScale=function()return 1 end
local a,b,rect=player.a,player.b,player.rect
player.a,player.b,player.rect=100,100,true
candidate('矩形自机判定的外接范围漏判',517,517,4,0,1)
player.a,player.b,player.rect=a,b,rect
local list=ObjList
ObjList=function()local i=0;return function()i=i+1;if i==1 then return i,{_live=true} end end end
candidate('未知PLAYER对象未退回全量处理',1000,1000,4,0,1)
ObjList=list
print('PASS 高速跨越、大判定、平移、全局缩放、未知PLAYER与死亡特效')
