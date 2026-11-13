-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=99999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=4,["start"]=1,["duration"]=2000,["mode"]="bullet",["fx"]=-99998,["fy"]=10,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=60,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=200,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=112,["width"]=0.65,["height"]=0.65,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0.08,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,1,0,1) end
if (t > (60.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.0,0,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=128,["cy"]=448,["start"]=100,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=650,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=270,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=30000,["type"]=0,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=false}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
end
T.emitters[2].p.events=nil
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=4,["start"]=1,["duration"]=2000,["mode"]="bullet",["fx"]=-99998,["fy"]=10,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=90,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=200,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=114,["width"]=0.5,["height"]=0.5,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0.08,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,1,0,1) end
if (t > (60.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.0,0,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=4,["start"]=1,["duration"]=2000,["mode"]="bullet",["fx"]=-99998,["fy"]=10,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=60,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=200,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=119,["width"]=0.65,["height"]=0.65,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0.08,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,1,0,1) end
if (t > (60.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.0,0,0,1) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=4,["start"]=1,["duration"]=2000,["mode"]="bullet",["fx"]=-99998,["fy"]=10,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=60,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=200,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=119,["width"]=0.65,["height"]=0.65,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0.08,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,1,0,1) end
if (t > (60.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.0,0,0,1) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=4,["start"]=1,["duration"]=2000,["mode"]="bullet",["fx"]=-99998,["fy"]=10,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=60,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=200,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=116,["width"]=0.65,["height"]=0.65,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0.08,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,1,0,1) end
if (t > (60.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.0,0,0,1) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=4,["start"]=1,["duration"]=2000,["mode"]="bullet",["fx"]=-99998,["fy"]=10,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=60,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=200,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=119,["width"]=0.65,["height"]=0.65,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0.08,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,1,0,1) end
if (t > (60.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.0,0,0,1) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=4,["start"]=1,["duration"]=2000,["mode"]="bullet",["fx"]=-99998,["fy"]=10,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=3,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=200,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=117,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0.05,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=1,["cover"]=true}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,1,0,1) end
if (t > (60.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.0,0,0,1) end
end
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=4,["start"]=1,["duration"]=2000,["mode"]="bullet",["fx"]=-99998,["fy"]=10,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=4,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=200,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=118,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0.05,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=1,["cover"]=true}}
T.emitters[9].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[9].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,1,0,1) end
if (t > (60.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.0,0,0,1) end
end
T.emitters[10]={["id"]=9,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=160,["cy"]=448,["start"]=100,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=445,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=270,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=30000,["type"]=0,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=false}}
T.emitters[10].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
end
T.emitters[10].p.events=nil
T.emitters[11]={["id"]=10,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=4,["start"]=1,["duration"]=2000,["mode"]="bullet",["fx"]=-99998,["fy"]=10,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=4,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=200,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=119,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0.05,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=1,["cover"]=true}}
T.emitters[11].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[11].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,1,0,1) end
if (t > (60.0+o.loops[0]*0)) then N.tween(o,o,"accel",0.0,0,0,1) end
end
T.emitters[12]={["id"]=0,["layer"]=0,["bind"]=1,["cx"]=320,["cy"]=448,["start"]=1,["duration"]=99800,["mode"]="cover",["width"]=600,["height"]=200,["round"]=false,["type"]=0,["control_id"]=1,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=true,["p"]={}}
T.emitters[12].events=nil
T.emitters[12].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,2,0,1) end
end
T.emitters[13]={["id"]=1,["layer"]=0,["bind"]=9,["cx"]=320,["cy"]=416,["start"]=1,["duration"]=99800,["mode"]="cover",["width"]=600,["height"]=20,["round"]=false,["type"]=0,["control_id"]=1,["speed"]=0.1,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=true,["p"]={}}
T.emitters[13].events=nil
T.emitters[13].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(90.0)+30.0*N.pm(o.run),0,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.05)+0.05*N.pm(o.run),0,0,60) end
end
return T
