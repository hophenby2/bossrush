-- BaseObject.HitCheck：非等比缩放分支使用距离加目标半径，保留原作算法。
return function(o,target)
    if o.age<9 then return false end
    local dx,dy=target.x-o.x,o.y-target.y
    local d=math.sqrt(dx*dx+dy*dy)
    local r=target.A or target.a or 0
    local region=o.region or 4
    if o.width==o.height then return d-r<region*o.height end
    local angle=((o.follow and o.direction+o.angle or o.angle)*math.pi/180)-math.atan2(dy,dx)
    local x,y=(d+r)*math.cos(angle),(d+r)*math.sin(angle)
    local a,b=region*o.width,region*o.height
    return a>0 and b>0 and y*y/a/a+x*x/b/b<1
end
