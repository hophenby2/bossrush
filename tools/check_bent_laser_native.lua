-- 两个平台的真实BentLaserData查询相互对照；不以Lua桩代替原生碰撞。
local T={}
function T.run()
    local point=New(object);point.group=GROUP.GHOST;point.bound=false;point.hide=true;point.colli=false
    local bits,profiles={},{}
    local count=0
    local function probe(data,label)
        local values={data:GetEnvelope()};profiles[#profiles+1]={label=label,envelope=values}
        for _,shape in ipairs({{0,0,0,false},{2,2,0,false},{2,5,37,false},{2,5,37,true}}) do
            for ix=-28,28 do for iy=-9,9 do
                local x,y=ix*4.137+.211,iy*2.179+.319
                local hit=data:CollisionCheck(x,y,shape[3],shape[1],shape[2],shape[4])
                bits[#bits+1]=hit and '1' or '0';count=count+1
                local wide=data:CollisionCheckWidth(x,y,7,shape[3],shape[1],shape[2],shape[4])
                bits[#bits+1]=wide and '1' or '0';count=count+1
            end end
        end
    end
    for _,env in ipairs({{0,1,0,0},{0,.5,.8,4},{.2,1.5,.3,2.4}}) do
        local d=BentLaserData();d:SetEnvelope(unpack(env))
        point.x,point.y=-100,0;d:Update(point,16,12,0);probe(d,'single')
        for i=2,24 do
            point.x,point.y=-100+i*8.137,math.sin(i*.3)*7
            d:Update(point,16,12,i%5==0 and 1 or 0)
        end
        probe(d,'moving-inactive');d:SetAllWidth(18);probe(d,'all-width')
        point.x,point.y=42.3,-5.7;d:Update(point,6,9,0);probe(d,'shrink')
    end
    object.RawDel(point)
    return {checks=count,bits=table.concat(bits),profiles=profiles}
end
return T
