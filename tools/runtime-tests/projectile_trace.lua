-- 对照优化前后的弹体运动、图像、判定、变色和寿命；输出供字节级比较，不以对象数量替代轨迹。
local mode,path,pattern=assert(arg[1]),assert(arg[2]),assert(arg[3])
arg={'runtime-projectile-trace'}
local f=assert(io.open('tools/check_stage.lua'));local s=f:read('*a');f:close()
assert(loadstring(s:sub(1,assert(s:find('if path == "--all" then',1,true))-1)))()
if os.getenv('BOSSRUSH_TRACE_NATIVE')=='1' then
    lstg.AndroidProjectBullet=function(o,img,x,y,rot,sx,sy,a,b,layer,group,collidable)
        if img then o.img=img end
        o.x,o.y=x,y;o.vx,o.vy=0,0;o.rot=rot;o.hscale,o.vscale=sx,sy
        o.a,o.b=a,b;o.rect=false;o.layer,o.group,o.colli=layer,group,collidable
    end
end
local R=dofile(path)
local created={};local new=New
New=function(cls,...)
    local o=new(cls,...)
    if cls==R.classes.projectile then created[#created+1]=o end
    return o
end
local host={_live=true,x=0,y=100}
local controller
if mode=='snow' then controller=R.controller(nil,pattern) else controller=R.controller(host,pattern,true) end
local fields={'x','y','vx','vy','rot','img','a','b','rect','hscale','vscale','layer','group','colli'}
local stateFields=mode=='snow' and {'x','y','age','speed','direction','rotation','alpha','shape','color','scaleX','scaleY','life','kind'}
    or {'fx','fy','age','head','type','alpha','wscale','hscale','life','sonspeed','sonspeedd','dis'}
local function literal(value)
    if type(value)=='number' then return ('%.17g'):format(value) end
    return tostring(value)
end
for t=1,900 do
    if mode=='snow' then R.tick(controller) else
        R.tick(controller)
        for i=1,#created do local o=created[i];if IsValid(o) then o.class.frame(o) end end
    end
    if t%30==0 then
        print('frame',t,'births',#created)
        for i,o in ipairs(created) do if IsValid(o) then
            local row={i};for _,key in ipairs(fields) do row[#row+1]=key..'='..literal(o[key]) end
            local state=o.asl or o.mhj
            for _,key in ipairs(stateFields) do row[#row+1]='s.'..key..'='..literal(state[key]) end
            print(table.concat(row,','))
        end end
    end
end
R.clear(controller)
for _,o in ipairs(created) do assert(not IsValid(o),'清场残留弹体') end
