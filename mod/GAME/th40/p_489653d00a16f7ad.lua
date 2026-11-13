-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=410,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=120,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=6,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=990,["type"]=17,["width"]=0.5,["height"]=0.5,["red"]=187,["green"]=28,["blue"]=51,["alpha"]=178,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=1,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",2.4,1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",10.0,1,0,120) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.5,0,0,30) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"direction",(10.0)+10.0*N.pm(o.run),1,0,60) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,120) end
if (t > (120.0+o.loops[0]*0)) and (t < (240.0+o.loops[0]*0)) then N.tween(o,o,"direction",2.0,1,0,1) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.7)+0.5*N.pm(o.run),2,0,60) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"blue",(50.0)+5.0*N.pm(o.run),1,0,30) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"green",(50.0)+5.0*N.pm(o.run),1,0,30) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"direction",(30.0)+15.0*N.pm(o.run),2,0,300) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,60) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"red",255.0,0,0,30) end
if (t == (280.0+o.loops[0]*0)) then N.tween(o,o,"blue",(150.0)+20.0*N.pm(o.run),0,0,60) end
if (t == (280.0+o.loops[0]*0)) then N.tween(o,o,"green",(90.0)+20.0*N.pm(o.run),0,0,60) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=120,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=6,["cycle"]=2,["emit_angle"]=20,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=990,["type"]=17,["width"]=0.5,["height"]=0.5,["red"]=187,["green"]=28,["blue"]=51,["alpha"]=178,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=1,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",2.4,2,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",10.0,1,0,120) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.5,0,0,30) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"direction",(10.0)+10.0*N.pm(o.run),2,0,60) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,120) end
if (t > (120.0+o.loops[0]*0)) and (t < (240.0+o.loops[0]*0)) then N.tween(o,o,"direction",2.0,2,0,1) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.7)+0.5*N.pm(o.run),2,0,60) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"red",255.0,0,0,30) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"blue",(50.0)+5.0*N.pm(o.run),1,0,30) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"direction",(30.0)+15.0*N.pm(o.run),1,0,300) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,60) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"green",(50.0)+5.0*N.pm(o.run),1,0,30) end
if (t == (280.0+o.loops[0]*0)) then N.tween(o,o,"blue",(150.0)+20.0*N.pm(o.run),0,0,30) end
if (t == (280.0+o.loops[0]*0)) then N.tween(o,o,"green",(90.0)+20.0*N.pm(o.run),0,0,30) end
end
return T
