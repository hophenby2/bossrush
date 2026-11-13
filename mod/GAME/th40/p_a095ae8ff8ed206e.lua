-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=35,["duration"]=8951,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=6,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=19,["width"]=0.5,["height"]=0.5,["red"]=0,["green"]=72,["blue"]=175,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=-1.7,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=1,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",201020.0,2,0,9999) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (1.0+o.loops[1]*0)) then N.tween(o,o,"emit_angle",5.0,1,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (25.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.01,0,2,100) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"blue",255.0,0,0,30) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"green",(135.0)+30.0*N.pm(o.run),0,0,30) end
o.loops[1]=o.loops[1] or 0
if (t+1)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (60.0+o.loops[1]*0)) then N.tween(o,o,"direction",(0.0)+20.0*N.pm(o.run),1,0,100) end
if (t == (100.0+o.loops[1]*0)) then N.tween(o,o,"speed",(0.0)+0.5*N.pm(o.run),1,0,120) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=35,["duration"]=8645,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=6,["cycle"]=4,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=19,["width"]=0.5,["height"]=0.5,["red"]=0,["green"]=72,["blue"]=175,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=-1.7,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=1,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"accel_angle",201020.0,2,0,9999) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (1.0+o.loops[1]*0)) then N.tween(o,o,"emit_angle",5.0,1,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (25.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.01,0,2,100) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"blue",255.0,0,0,30) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"green",(135.0)+30.0*N.pm(o.run),0,0,30) end
o.loops[1]=o.loops[1] or 0
if (t+1)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (60.0+o.loops[1]*0)) then N.tween(o,o,"direction",(0.0)+20.0*N.pm(o.run),1,0,100) end
if (t == (50.0+o.loops[1]*0)) then N.tween(o,o,"alpha",255.0,1,0,30) end
if (t == (100.0+o.loops[1]*0)) then N.tween(o,o,"speed",(0.0)+0.5*N.pm(o.run),1,0,120) end
end
return T
