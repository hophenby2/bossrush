-- 保留原随机种子、反向更新顺序和真实生命周期，比较绑定运动与事件完整数值。
local path,id=assert(arg[1]),tonumber(assert(arg[2]))
arg={'summer-runtime-trace'}
local f=assert(io.open('tools/check_stage.lua'));local s=f:read('*a');f:close()
assert(loadstring(s:sub(1,assert(s:find('if path == "--all" then',1,true))-1)))()
if os.getenv('BOSSRUSH_TRACE_NATIVE')=='1' then
    lstg.AndroidProjectBullet=function(o,img,x,y,rot,sx,sy,a,b,layer,group,collidable)
        if img then o.img=img end
        o.x,o.y=x,y;o.vx,o.vy=0,0;o.rot=rot;o.hscale,o.vscale=sx,sy
        o.a,o.b=a,b;o.rect=false;o.layer,o.group,o.colli=layer,group,collidable
    end
end
local N=dofile(path);N.load()
local data=dofile('mod/GAME/th40/phases.lua')
local meta
for _,m in ipairs(data.phases) do if m.id==id then meta=m end end
local owner={x=0,y=100,hp=meta.hp,_live=true}
local run=N.new(owner,meta)
if meta.begin then meta.begin(run.host,N) end
-- 桩对象未赋 rect 时返回 nil；真实引擎默认 Circle 的 getter 返回 false。
local fields={'x','y','rot','vx','vy','hscale','vscale','a','b','rect','layer','group','cx','cy','age','speed','direction','angle','width','height','alpha','red','green','blue','life','mode','type','colli','start','cycle','time','th38_removed'}
for t=1,2400 do
    N.tick(owner,meta)
    if t%60==0 then
        print(t,#run.objects,#run.enemies,#run.bullets,#run.effects,run.random.i,run.random.j,table.concat(run.random.state,','))
        for i,o in ipairs(run.objects) do if not o.th38_removed and IsValid(o) then
            local row={i}
            for _,key in ipairs(fields) do
                local v=o[key];if key=='rect' and v==nil then v=false end;row[#row+1]=key..'='..(type(v)=='number' and ('%.17g'):format(v) or tostring(v))
            end
            if o.parent_last then for j=1,4 do row[#row+1]=('%.17g'):format(o.parent_last[j]) end end
            print(table.concat(row,','))
        end end
    end
end
N.stop(owner)
