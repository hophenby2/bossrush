-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=1560,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=384,["start"]=1,["duration"]=720,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=690,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=false}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (10.0+o.loops[0]*0)) then N.emit(o) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"cy",N.player_y(),0,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",N.aim(o),0,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=60,["duration"]=700,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=90,["ways"]=6,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=180,["ways"]=0,["cycle"]=0,["emit_angle"]=180,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=690,["type"]=21,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cy",N.player_y(),0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (6.0+o.loops[1]*0)) then N.tween(o,o,"ways",5.0,1,0,1) end
if (t == (5.0+o.loops[1]*0)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (15.0+o.loops[1]*0)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"ways",6.0,0,0,1) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"radius",0.0,0,0,1) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"radius",540.0,0,0,15) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(90.0)+180.0*N.pm(o.run),0,0,1) end
if (t == (360.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,0,0,120) end
if (t == (360.0+o.loops[0]*0)) then N.tween(o,o,"direction",N.aim(o),0,0,1) end
if (t == (365.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+20.0*N.pm(o.run),1,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=416,["cy"]=128,["start"]=90,["duration"]=691,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=6,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=30,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=640,["type"]=37,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"type",(0.0)+4.0*N.pm(o.run),1,0,1) end
if (t == (5.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=192,["start"]=1,["duration"]=780,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=150,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
if (t == (360.0+o.loops[0]*0)) then N.emit(o) end
if (t == (360.0+o.loops[0]*0)) then N.emit(o) end
if (t == (360.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[4].p.events=nil
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=192,["start"]=55,["duration"]=720,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=9,["cycle"]=5,["emit_angle"]=270,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=120,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=false}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%30==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*30)) then N.tween(o,o.p,"type",119.0,0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t)%5==0 then o.loops[1]=o.loops[1]+1 end
if (t == (3.0+o.loops[1]*5)) then N.tween(o,o.p,"type",1.0,1,0,1) end
o.loops[2]=o.loops[2] or 0
if (t)%1==0 then o.loops[2]=o.loops[2]+1 end
if (t == (1.0+o.loops[2]*0)) then N.tween(o,o,"emit_angle",90.0,1,0,359) end
if (t == (360.0+o.loops[2]*0)) then N.tween(o,o,"emit_angle",140.0,2,0,360) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,0,0,180) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=384,["start"]=781,["duration"]=720,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=690,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=false}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (10.0+o.loops[0]*0)) then N.emit(o) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"cy",N.player_y(),0,0,1) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",N.aim(o),0,0,1) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=7,["with_direction"]=false,["cx"]=416,["cy"]=96,["start"]=870,["duration"]=691,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=6,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=30,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=640,["type"]=37,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"type",(0.0)+4.0*N.pm(o.run),1,0,1) end
if (t == (5.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,1) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=96,["start"]=840,["duration"]=700,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=90,["ways"]=6,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=180,["ways"]=0,["cycle"]=0,["emit_angle"]=180,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=690,["type"]=21,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cy",N.player_y(),0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (6.0+o.loops[1]*0)) then N.tween(o,o,"ways",5.0,1,0,1) end
if (t == (5.0+o.loops[1]*0)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (15.0+o.loops[1]*0)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"ways",6.0,0,0,1) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"radius",0.0,0,0,1) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"radius",540.0,0,0,15) end
end
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(90.0)+180.0*N.pm(o.run),0,0,1) end
if (t == (360.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,0,0,120) end
if (t == (360.0+o.loops[0]*0)) then N.tween(o,o,"direction",N.aim(o),0,0,1) end
if (t == (365.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+20.0*N.pm(o.run),1,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
end
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=192,["start"]=781,["duration"]=780,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=150,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[9].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
if (t == (360.0+o.loops[0]*0)) then N.emit(o) end
if (t == (360.0+o.loops[0]*0)) then N.emit(o) end
if (t == (360.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[9].p.events=nil
T.emitters[10]={["id"]=9,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=192,["start"]=835,["duration"]=720,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=9,["cycle"]=5,["emit_angle"]=270,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=120,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=false}}
T.emitters[10].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%30==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*30)) then N.tween(o,o.p,"type",119.0,0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t)%5==0 then o.loops[1]=o.loops[1]+1 end
if (t == (3.0+o.loops[1]*5)) then N.tween(o,o.p,"type",1.0,1,0,1) end
o.loops[2]=o.loops[2] or 0
if (t)%1==0 then o.loops[2]=o.loops[2]+1 end
if (t == (1.0+o.loops[2]*0)) then N.tween(o,o,"emit_angle",90.0,2,0,359) end
if (t == (360.0+o.loops[2]*0)) then N.tween(o,o,"emit_angle",140.0,1,0,360) end
end
T.emitters[10].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,0,0,180) end
end
T.emitters[11]={["id"]=0,["layer"]=0,["bind"]=0,["cx"]=320,["cy"]=224,["start"]=120,["duration"]=600,["mode"]="cover",["width"]=75,["height"]=75,["round"]=true,["type"]=1,["control_id"]=1,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["p"]={}}
T.emitters[11].events=nil
T.emitters[11].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"life",720.0,2,0,1) end
end
T.emitters[12]={["id"]=1,["layer"]=0,["bind"]=0,["cx"]=352,["cy"]=224,["start"]=120,["duration"]=600,["mode"]="cover",["width"]=60,["height"]=60,["round"]=true,["type"]=0,["control_id"]=2,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["p"]={}}
T.emitters[12].events=nil
T.emitters[12].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.3,0,0,1080) end
end
T.emitters[13]={["id"]=2,["layer"]=0,["bind"]=5,["cx"]=384,["cy"]=224,["start"]=120,["duration"]=600,["mode"]="cover",["width"]=60,["height"]=60,["round"]=true,["type"]=0,["control_id"]=2,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["p"]={}}
T.emitters[13].events=nil
T.emitters[13].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.3,0,0,1080) end
end
T.emitters[14]={["id"]=3,["layer"]=0,["bind"]=5,["cx"]=416,["cy"]=224,["start"]=120,["duration"]=600,["mode"]="cover",["width"]=75,["height"]=75,["round"]=true,["type"]=1,["control_id"]=7,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["p"]={}}
T.emitters[14].events=nil
T.emitters[14].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"life",720.0,2,0,1) end
end
return T
