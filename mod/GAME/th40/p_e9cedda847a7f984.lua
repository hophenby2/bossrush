-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=740,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=45,["duration"]=696,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=270,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2100,["type"]=17,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[1].p.events=nil
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=288,["cy"]=256,["start"]=1,["duration"]=720,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=60,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=5,["delta_v"]=1.5,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=67,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=7.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.emit(o) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",180.0,1,0,1) end
if (t == (3.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",3.0,1,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,90) end
if (t == (90.0+o.loops[0]*0)) then N.tween(o,o,"direction",180.0,1,0,1) end
if (t == (90.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.6,0,0,60) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o,"direction",30.0,1,0,120) end
if (t == (210.0+o.loops[0]*0)) then N.tween(o,o,"out",1.0,0,0,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"out",0.0,0,0,1) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,45) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",6.0,1,0,1) end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"invincible",0.0,0,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=320,["cy"]=256,["start"]=1,["duration"]=720,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=60,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=5,["delta_v"]=1.5,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=68,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=6.75,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.emit(o) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",180.0,1,0,1) end
if (t == (3.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",3.0,1,0,1) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,90) end
if (t == (90.0+o.loops[0]*0)) then N.tween(o,o,"direction",180.0,1,0,1) end
if (t == (90.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.6,0,0,60) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o,"direction",30.0,2,0,120) end
if (t == (210.0+o.loops[0]*0)) then N.tween(o,o,"out",1.0,0,0,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"out",0.0,0,0,1) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,45) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",6.0,1,0,1) end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"invincible",0.0,0,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=155,["start"]=1,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=150,["green"]=200,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[4].events=nil
T.emitters[4].p.events=nil
T.emitters[5]={["id"]=0,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=224,["cy"]=224,["start"]=1,["duration"]=720,["mode"]="ray",["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=180,["type"]=7,["width"]=3.125,["height"]=0.2,["length"]=800,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=3.125,["max_height"]=1}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",180.0,1,0,1) end
if (t == (3.0+o.loops[0]*0)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (4.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",360.0,1,0,30) end
if (t == (34.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",6.0,2,0,1) end
if (t == (35.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",360.0,2,0,30) end
if (t == (64.0+o.loops[0]*0)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[5].p.events=nil
T.emitters[6]={["id"]=1,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=160,["cy"]=288,["start"]=490,["duration"]=210,["mode"]="laser",["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=270,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["head"]=true,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=180,["type"]=2,["width"]=1,["height"]=1,["length"]=30,["alpha"]=255,["angle"]=0,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",16.0,1,0,1) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.75,0,0,45) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",5.0,0,0,30) end
end
T.emitters[7]={["id"]=2,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=224,["cy"]=320,["start"]=210,["duration"]=170,["mode"]="ray",["radius"]=0,["radius_angle"]=0,["ways"]=13,["cycle"]=3,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=120,["type"]=5,["width"]=3.125,["height"]=0.2,["length"]=800,["alpha"]=127,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=3.125,["max_height"]=1}}
T.emitters[7].events=nil
T.emitters[7].p.events=nil
T.emitters[8]={["id"]=3,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=256,["cy"]=320,["start"]=460,["duration"]=180,["mode"]="ray",["radius"]=0,["radius_angle"]=0,["ways"]=9,["cycle"]=3,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=120,["type"]=7,["width"]=3.125,["height"]=0.2,["length"]=800,["alpha"]=127,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=3.125,["max_height"]=1}}
T.emitters[8].events=nil
T.emitters[8].p.events=nil
return T
