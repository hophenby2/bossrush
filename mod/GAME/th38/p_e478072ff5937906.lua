-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=6000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=110,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=54,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,1,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=335,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=52,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,2,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=30,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=150,["green"]=200,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[3].events=nil
T.emitters[3].p.events=nil
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=785,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=52,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,2,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=560,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=54,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,1,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1235,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=52,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,2,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1010,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=54,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,1,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1685,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=52,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,2,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1460,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=54,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[9].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,1,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[9].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[10]={["id"]=9,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=2135,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=52,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[10].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,2,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[10].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[11]={["id"]=10,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1910,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=54,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[11].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,1,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[11].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[12]={["id"]=11,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=2360,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=54,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[12].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,1,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[12].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[13]={["id"]=12,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=2585,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=52,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[13].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,2,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[13].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[14]={["id"]=13,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=2810,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=54,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[14].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,1,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[14].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[15]={["id"]=14,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=3035,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=52,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[15].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,2,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[15].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[16]={["id"]=15,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=3260,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=54,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[16].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,1,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[16].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,2,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
T.emitters[17]={["id"]=16,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=3485,["duration"]=180,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=5,["emit_angle"]=52,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=114,["width"]=0.72,["height"]=0.72,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=6,["cover"]=true}}
T.emitters[17].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",12.0,2,0,180) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"cycle",3.0,0,0,1) end
end
T.emitters[17].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,8) end
end
return T
