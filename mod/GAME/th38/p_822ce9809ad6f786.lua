-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=2400,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=0,["start"]=80,["duration"]=2100,["mode"]="bullet",["fx"]=-99998,["fy"]=-150,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=35,["type"]=225,["width"]=4,["height"]=9,["red"]=255,["green"]=255,["blue"]=200,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=10,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=16,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o.p,"width",(4.5)+1.0*N.pm(o.run),0,0,1,o.p.height) end
o.loops[1]=o.loops[1] or 0
if (t)%180==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*180)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (140.0+o.loops[1]*180)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t == (120.0+o.loops[1]*180)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t == (100.0+o.loops[1]*180)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (1.0+o.loops[1]*180)) then N.tween(o,o.p,"speed",40.0,1,0,100) end
if (t == (179.0+o.loops[1]*180)) then N.tween(o,o.p,"speed",10.0,0,0,1) end
end
T.emitters[1].p.events=nil
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=80,["duration"]=2100,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=50,["radius_angle"]=0,["ways"]=3,["cycle"]=90,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=360,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=9999,["type"]=108,["width"]=0.85,["height"]=0.85,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=nil
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.5)+0.4*N.pm(o.run),0,0,180) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,1,0,1) end
o.loops[1]=o.loops[1] or 0
if (t+1)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (23.0+o.loops[1]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"type",(0.0)+4.0*N.pm(o.run),1,0,1) end
if (o.cy > (475.0+o.loops[1]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=0,["start"]=80,["duration"]=2100,["mode"]="bullet",["fx"]=-99998,["fy"]=-150,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=10,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=35,["type"]=1,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=200,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=10,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o.p,"width",(4.5)+1.0*N.pm(o.run),0,0,1,o.p.height) end
o.loops[1]=o.loops[1] or 0
if (t)%180==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*180)) then N.tween(o,o,"cycle",3.0,0,0,1) end
if (t == (140.0+o.loops[1]*180)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t == (120.0+o.loops[1]*180)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t == (100.0+o.loops[1]*180)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (1.0+o.loops[1]*180)) then N.tween(o,o.p,"speed",40.0,1,0,100) end
if (t == (179.0+o.loops[1]*180)) then N.tween(o,o.p,"speed",10.0,0,0,1) end
end
T.emitters[3].p.events=nil
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=0,["start"]=80,["duration"]=2100,["mode"]="bullet",["fx"]=-99998,["fy"]=-150,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=35,["type"]=225,["width"]=4,["height"]=7,["red"]=255,["green"]=255,["blue"]=200,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=10,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=16,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o.p,"width",(3.5)+1.0*N.pm(o.run),0,0,1,o.p.height) end
o.loops[1]=o.loops[1] or 0
if (t)%180==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*180)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (140.0+o.loops[1]*180)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t == (120.0+o.loops[1]*180)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t == (100.0+o.loops[1]*180)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (1.0+o.loops[1]*180)) then N.tween(o,o.p,"speed",40.0,1,0,100) end
if (t == (179.0+o.loops[1]*180)) then N.tween(o,o.p,"speed",10.0,0,0,1) end
end
T.emitters[4].p.events=nil
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=0,["start"]=1,["duration"]=30,["mode"]="effect",["fx"]=-99998,["fy"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=10,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=100,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[5].p.events=nil
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=0,["start"]=22,["duration"]=2100,["mode"]="effect",["fx"]=-99998,["fy"]=16,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=225,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=100,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%180==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*180)) then N.tween(o,o,"cycle",10.0,0,0,1) end
if (t == (178.0+o.loops[0]*180)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t == (178.0+o.loops[0]*180)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t == (20.0+o.loops[0]*180)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (1.0+o.loops[0]*180)) then N.emit(o) end
end
T.emitters[6].p.events=nil
return T
