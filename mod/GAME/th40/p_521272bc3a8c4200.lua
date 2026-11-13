-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=2800,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=238,["start"]=79,["duration"]=2601,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=197,["radius_angle"]=68,["ways"]=4,["cycle"]=2,["emit_angle"]=68,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=250,["type"]=227,["width"]=0.4,["height"]=0.4,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",2.0,1,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",2.0,1,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",0.4,2,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=238,["start"]=1,["duration"]=2800,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1350,["type"]=227,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="MagicCircleA"}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",5.0,1,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",5.0,1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius",180.0,1,0,130) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",2.0,1,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (70.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,60) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,2,0,1) end
end
T.emitters[3]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=238,["start"]=347,["duration"]=90,["mode"]="ray",["radius"]=180,["radius_angle"]=359,["ways"]=2,["cycle"]=3,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=130,["type"]=6,["width"]=2.734375,["height"]=0.2,["length"]=700,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.734375,["max_height"]=1}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",4.0,1,0,1) end
end
T.emitters[3].p.events=nil
T.emitters[4]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=238,["start"]=161,["duration"]=90,["mode"]="ray",["radius"]=180,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=130,["type"]=0,["width"]=2.734375,["height"]=0.2,["length"]=700,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.734375,["max_height"]=1}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",4.0,1,0,1) end
end
T.emitters[4].p.events=nil
T.emitters[5]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=238,["start"]=523,["duration"]=90,["mode"]="ray",["radius"]=190,["radius_angle"]=358,["ways"]=3,["cycle"]=2,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=130,["type"]=6,["width"]=2.734375,["height"]=0.2,["length"]=700,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.734375,["max_height"]=1}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",4.0,1,0,1) end
end
T.emitters[5].p.events=nil
T.emitters[6]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=238,["start"]=704,["duration"]=90,["mode"]="ray",["radius"]=180,["radius_angle"]=314,["ways"]=4,["cycle"]=3,["emit_angle"]=45,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=130,["type"]=5,["width"]=2.734375,["height"]=0.2,["length"]=700,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.734375,["max_height"]=1}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",4.0,1,0,1) end
end
T.emitters[6].p.events=nil
T.emitters[7]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=238,["start"]=885,["duration"]=90,["mode"]="ray",["radius"]=200,["radius_angle"]=341,["ways"]=5,["cycle"]=2,["emit_angle"]=36,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=130,["type"]=4,["width"]=2.734375,["height"]=0.2,["length"]=700,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.734375,["max_height"]=1}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",4.0,1,0,1) end
end
T.emitters[7].p.events=nil
T.emitters[8]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=238,["start"]=1066,["duration"]=90,["mode"]="ray",["radius"]=200,["radius_angle"]=347,["ways"]=6,["cycle"]=3,["emit_angle"]=30,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=130,["type"]=3,["width"]=2.734375,["height"]=0.2,["length"]=700,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.734375,["max_height"]=1}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",4.0,1,0,1) end
end
T.emitters[8].p.events=nil
T.emitters[9]={["id"]=6,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=238,["start"]=1246,["duration"]=90,["mode"]="ray",["radius"]=200,["radius_angle"]=286,["ways"]=7,["cycle"]=2,["emit_angle"]=322,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=130,["type"]=2,["width"]=2.734375,["height"]=0.2,["length"]=700,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.734375,["max_height"]=1}}
T.emitters[9].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",4.0,1,0,1) end
end
T.emitters[9].p.events=nil
T.emitters[10]={["id"]=7,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=238,["start"]=1490,["duration"]=90,["mode"]="ray",["radius"]=200,["radius_angle"]=351,["ways"]=8,["cycle"]=3,["emit_angle"]=22.5,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=130,["type"]=1,["width"]=2.734375,["height"]=0.2,["length"]=700,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.734375,["max_height"]=1}}
T.emitters[10].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",4.0,1,0,1) end
end
T.emitters[10].p.events=nil
T.emitters[11]={["id"]=8,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=238,["start"]=1421,["duration"]=90,["mode"]="ray",["radius"]=200,["radius_angle"]=350,["ways"]=9,["cycle"]=2,["emit_angle"]=10,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=130,["type"]=7,["width"]=2.734375,["height"]=0.2,["length"]=700,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.734375,["max_height"]=1}}
T.emitters[11].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",4.0,1,0,1) end
end
T.emitters[11].p.events=nil
return T
