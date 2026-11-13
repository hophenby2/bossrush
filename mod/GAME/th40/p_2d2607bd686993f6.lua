-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=363,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=211,["start"]=90,["duration"]=1,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=60,["type"]=223,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=191,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet50_5"}}
T.emitters[1].events=nil
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",60.0,0,0,60) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",60.0,0,0,60) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=213,["start"]=91,["duration"]=1,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=60,["type"]=223,["width"]=0,["height"]=0,["red"]=1,["green"]=1,["blue"]=1,["alpha"]=191,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet50_5"}}
T.emitters[2].events=nil
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",55.0,0,0,60) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",55.0,0,0,60) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=210,["start"]=1,["duration"]=38,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=100,["radius_angle"]=230,["ways"]=8,["cycle"]=1,["emit_angle"]=240,["spread"]=13,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=15,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=45,["type"]=223,["width"]=0.8,["height"]=0.8,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=15,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet50_5"}}
T.emitters[3].events=nil
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"speed",(-8.0)+2.0*N.pm(o.run),0,1,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",60.0,0,1,1) end
if (t == (25.0+o.loops[0]*0)) then N.tween(o,o,"width",0.5,0,0,27) end
if (t == (25.0+o.loops[0]*0)) then N.tween(o,o,"height",0.5,0,0,27) end
if (t == (25.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,27) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=210,["start"]=1,["duration"]=38,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=100,["radius_angle"]=310,["ways"]=8,["cycle"]=1,["emit_angle"]=300,["spread"]=13,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=15,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=45,["type"]=223,["width"]=0.8,["height"]=0.8,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=15,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet50_5"}}
T.emitters[4].events=nil
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"speed",(-8.0)+2.0*N.pm(o.run),0,1,1) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",60.0,0,1,1) end
if (t == (25.0+o.loops[0]*0)) then N.tween(o,o,"width",0.5,0,0,27) end
if (t == (25.0+o.loops[0]*0)) then N.tween(o,o,"height",0.5,0,0,27) end
if (t == (25.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,27) end
end
T.emitters[5]={["id"]=0,["layer"]=1,["bind"]=-1,["with_direction"]=false,["cx"]=328,["cy"]=224,["start"]=100,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=222,["spread"]=80,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[5].events=nil
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,0,0,100) end
if (t > (40.0+o.loops[0]*0)) and (t < (80.0+o.loops[0]*0)) then N.tween(o,o,"direction",7.0,1,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",25.0,1,0,10) end
if (t == (11.0+o.loops[0]*0)) then N.tween(o,o,"direction",50.0,2,0,10) end
if (t == (21.0+o.loops[0]*0)) then N.tween(o,o,"direction",50.0,1,0,10) end
if (t == (31.0+o.loops[0]*0)) then N.tween(o,o,"direction",50.0,2,0,10) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"speed",8.0,0,0,50) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"direction",N.aim(o),0,0,10) end
end
T.emitters[6]={["id"]=1,["layer"]=1,["bind"]=0,["with_direction"]=false,["cx"]=32,["cy"]=320,["start"]=1,["duration"]=363,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=110,["type"]=37,["width"]=1,["height"]=1,["red"]=200,["green"]=255,["blue"]=200,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=2,["cover"]=true}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (250.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",2.0,0,2,400) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"red",100.0,0,2,300) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",100.0,0,2,300) end
end
T.emitters[7]={["id"]=2,["layer"]=1,["bind"]=0,["with_direction"]=true,["cx"]=32,["cy"]=288,["start"]=1,["duration"]=363,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=10,["radius_angle"]=-99999,["ways"]=1,["cycle"]=13,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=37,["width"]=1,["height"]=1,["red"]=200,["green"]=255,["blue"]=200,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",N.aim(o),0,0,1) end
end
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (200.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.8)+0.9*N.pm(o.run),1,0,100) end
if (t == (200.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"red",(220.0)+30.0*N.pm(o.run),0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",(220.0)+30.0*N.pm(o.run),0,0,1) end
end
T.emitters[8]={["id"]=3,["layer"]=1,["bind"]=-1,["with_direction"]=false,["cx"]=309,["cy"]=224,["start"]=100,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=318,["spread"]=80,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[8].events=nil
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,0,0,100) end
if (t > (40.0+o.loops[0]*0)) and (t < (80.0+o.loops[0]*0)) then N.tween(o,o,"direction",7.0,2,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",25.0,2,0,10) end
if (t == (11.0+o.loops[0]*0)) then N.tween(o,o,"direction",50.0,1,0,10) end
if (t == (21.0+o.loops[0]*0)) then N.tween(o,o,"direction",50.0,2,0,10) end
if (t == (31.0+o.loops[0]*0)) then N.tween(o,o,"direction",50.0,1,0,10) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"speed",8.0,0,0,50) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"direction",N.aim(o),0,0,10) end
end
T.emitters[9]={["id"]=4,["layer"]=1,["bind"]=3,["with_direction"]=false,["cx"]=64,["cy"]=320,["start"]=1,["duration"]=363,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=110,["type"]=37,["width"]=1,["height"]=1,["red"]=200,["green"]=255,["blue"]=200,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=2,["cover"]=true}}
T.emitters[9].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) and (t < (250.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
end
T.emitters[9].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",2.0,0,2,400) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"red",100.0,0,2,300) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",100.0,0,2,300) end
end
T.emitters[10]={["id"]=5,["layer"]=1,["bind"]=3,["with_direction"]=true,["cx"]=64,["cy"]=288,["start"]=1,["duration"]=363,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=10,["radius_angle"]=-99999,["ways"]=1,["cycle"]=13,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=37,["width"]=1,["height"]=1,["red"]=200,["green"]=255,["blue"]=150,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[10].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",N.aim(o),0,0,1) end
end
T.emitters[10].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (200.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.8)+0.9*N.pm(o.run),1,0,100) end
if (t == (200.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"red",(220.0)+30.0*N.pm(o.run),0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",(220.0)+30.0*N.pm(o.run),0,0,1) end
end
T.emitters[11]={["id"]=6,["layer"]=1,["bind"]=0,["with_direction"]=true,["cx"]=32,["cy"]=352,["start"]=109,["duration"]=255,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=13,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=110,["type"]=226,["width"]=0.1,["height"]=0.1,["red"]=50,["green"]=255,["blue"]=50,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[11].events=nil
T.emitters[11].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",0.8,0,0,50) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",0.8,0,0,50) end
end
T.emitters[12]={["id"]=7,["layer"]=1,["bind"]=3,["with_direction"]=true,["cx"]=64,["cy"]=352,["start"]=109,["duration"]=255,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=13,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=110,["type"]=226,["width"]=0.1,["height"]=0.1,["red"]=50,["green"]=255,["blue"]=50,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[12].events=nil
T.emitters[12].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",0.8,0,0,50) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",0.8,0,0,50) end
end
T.emitters[13]={["id"]=8,["layer"]=1,["bind"]=6,["with_direction"]=false,["cx"]=32,["cy"]=384,["start"]=1,["duration"]=363,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=30,["type"]=183,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=76,["angle"]=180,["follow"]=true,["speed"]=1.4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet65_0"}}
T.emitters[13].events=nil
T.emitters[13].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"width",0.2,0,0,30) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"height",0.2,0,0,30) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,30) end
end
T.emitters[14]={["id"]=9,["layer"]=1,["bind"]=7,["with_direction"]=false,["cx"]=64,["cy"]=384,["start"]=1,["duration"]=363,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=30,["type"]=183,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=76,["angle"]=180,["follow"]=true,["speed"]=1.4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet65_0"}}
T.emitters[14].events=nil
T.emitters[14].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"width",0.2,0,0,30) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"height",0.2,0,0,30) end
if (t == (10.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,30) end
end
T.emitters[15]={["id"]=10,["layer"]=1,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=209,["start"]=20,["duration"]=344,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=1,["width"]=1,["height"]=1,["red"]=155,["green"]=255,["blue"]=155,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[15].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[15].p.events=nil
return T
