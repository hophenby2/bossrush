-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=285,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=50,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=150,["radius_angle"]=0,["ways"]=12,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=600,["type"]=182,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=-3,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",900.0,2,0,50) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",900.0,2,0,50) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",3.0,2,0,50) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"radius",50.0,2,0,50) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",N.aim(o),0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.0,0,0,80) end
if (o.cy > (550.0+o.loops[0]*0)) then N.tween(o,o,"life",0.0,0,0,1) end
end
return T
