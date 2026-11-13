-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=20000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=32,["start"]=1,["duration"]=20000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=50,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=10,["delta_v"]=1.5,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=200,["y"]=30,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.2,["height"]=0.2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=15,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=7,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"cycle",16.0,0,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",14.0,0,0,1) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"cycle",12.0,0,0,1) end
if (t == (300.0+o.loops[0]*0)) then N.tween(o,o,"cycle",10.0,0,0,1) end
if (t == (360.0+o.loops[0]*0)) then N.tween(o,o,"cycle",8.0,0,0,1) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"speed",4.2,0,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=32,["start"]=420,["duration"]=19401,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=100,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=1.5,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=200,["y"]=30,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=112,["width"]=0.25,["height"]=0.25,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=15,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=7,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"cycle",32.0,0,0,1) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"cycle",21.0,0,0,1) end
if (t == (300.0+o.loops[0]*0)) then N.tween(o,o,"cycle",16.0,0,0,1) end
if (t == (360.0+o.loops[0]*0)) then N.tween(o,o,"cycle",12.0,0,0,1) end
if (t == (520.0+o.loops[0]*0)) then N.tween(o,o,"cycle",6.0,0,0,1) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"cycle",8.0,0,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",26.0,0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"speed",4.8,0,0,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"direction",N.aim(o),0,0,1) end
end
return T
