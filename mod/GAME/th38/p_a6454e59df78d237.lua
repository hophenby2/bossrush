-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=720,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=120,["duration"]=62,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=90,["ways"]=6,["cycle"]=2,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=720,["type"]=33,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%60==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"radius",150.0,0,0,30) end
if (t == (30.0+o.loops[0]*60)) then N.tween(o,o,"radius",0.0,0,0,30) end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"emit_angle",60.0,1,0,60) end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"radius_angle",60.0,1,0,60) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (180.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.5)+1.3*N.pm(o.run),0,2,240) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"speed",(2.0)+0.5*N.pm(o.run),0,0,180) end
if (t == (480.0+o.loops[0]*0)) then N.tween(o,o,"type",159.0,0,0,1) end
if (t == (480.0+o.loops[0]*0)) then N.tween(o,o,"blend",1.0,0,0,1) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"invincible",0.0,0,0,1) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+30.0*N.pm(o.run),1,0,180) end
if (t == (500.0+o.loops[0]*0)) then N.tween(o,o,"alpha",75.0,0,0,270) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o,"width",0.6,0,0,270) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o,"height",0.6,0,0,270) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=120,["duration"]=62,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=90,["ways"]=6,["cycle"]=2,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=720,["type"]=33,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%60==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"radius",150.0,0,0,30) end
if (t == (30.0+o.loops[0]*60)) then N.tween(o,o,"radius",0.0,0,0,30) end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"emit_angle",60.0,2,0,60) end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"radius_angle",60.0,2,0,60) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (180.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.5)+1.3*N.pm(o.run),0,2,240) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"speed",(2.0)+0.5*N.pm(o.run),0,0,180) end
if (t == (480.0+o.loops[0]*0)) then N.tween(o,o,"type",159.0,0,0,1) end
if (t == (480.0+o.loops[0]*0)) then N.tween(o,o,"blend",1.0,0,0,1) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"invincible",0.0,0,0,1) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+30.0*N.pm(o.run),1,0,180) end
if (t == (500.0+o.loops[0]*0)) then N.tween(o,o,"alpha",75.0,0,0,270) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o,"width",0.6,0,0,270) end
if (t == (450.0+o.loops[0]*0)) then N.tween(o,o,"height",0.6,0,0,270) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=120,["duration"]=62,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=120,["ways"]=6,["cycle"]=2,["emit_angle"]=120,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=7200,["type"]=38,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%60==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"radius",120.0,0,0,30) end
if (t == (30.0+o.loops[0]*60)) then N.tween(o,o,"radius",0.0,0,0,30) end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"emit_angle",60.0,2,0,60) end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"radius_angle",60.0,2,0,60) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.4)+0.6*N.pm(o.run),0,0,240) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"direction",(30.0)+30.0*N.pm(o.run),2,0,240) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.3,0,2,180) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"invincible",0.0,0,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=120,["duration"]=62,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=120,["ways"]=6,["cycle"]=2,["emit_angle"]=120,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=7200,["type"]=38,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.01,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%60==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"radius",120.0,0,0,30) end
if (t == (30.0+o.loops[0]*60)) then N.tween(o,o,"radius",0.0,0,0,30) end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"emit_angle",60.0,1,0,60) end
if (t == (1.0+o.loops[0]*60)) then N.tween(o,o,"radius_angle",60.0,1,0,60) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.4)+0.6*N.pm(o.run),0,0,240) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"direction",(30.0)+30.0*N.pm(o.run),1,0,240) end
if (t == (240.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.3,0,2,180) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"invincible",0.0,0,0,1) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=1,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=150,["blue"]=100,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[5].events=nil
T.emitters[5].p.events=nil
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=60,["duration"]=60,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=120,["ways"]=6,["cycle"]=1,["emit_angle"]=120,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=79,["width"]=0.3,["height"]=0.3,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=229,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius",180.0,0,0,29) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",120.0,1,0,120) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",(2100.0)+300.0*N.pm(o.run),1,0,118) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"radius",0.0,0,0,30) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",(120.0)+60.0*N.pm(o.run),0,0,1) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.6,0,0,120) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=540,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=150,["blue"]=100,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[7].events=nil
T.emitters[7].p.events=nil
return T
