-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=3600,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=3600,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=270,["ways"]=8,["cycle"]=5,["emit_angle"]=270,["spread"]=250,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=37,["width"]=0.85,["height"]=0.85,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.95,["direction"]=0,["accel"]=0.025,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%180==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*180)) then N.tween(o,o,"emit_angle",10.0,1,2,179) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"spread",90.0,2,0,1500) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (259.0+o.loops[0]*0)) then N.tween(o,o,"type",87.0,1,0,1) end
if (o.cy > (458.0+o.loops[0]*0)) then N.tween(o,o,"direction",(270.0)+90.0*N.pm(o.run),0,0,1) end
if (o.cy > (458.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.8)+0.2*N.pm(o.run),0,0,1) end
if (o.cy > (458.0+o.loops[0]*0)) then N.tween(o,o,"accel_angle",270.0,0,0,1) end
if (o.cy > (458.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.007,0,0,1) end
if (t == (231.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (231.0+o.loops[0]*0)) then N.tween(o,o,"type",(0.0)+4.0*N.pm(o.run),1,0,1) end
if (o.cy > (458.0+o.loops[0]*0)) then N.tween(o,o,"blend",1.0,0,0,1) end
end
return T
