-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=7200,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=448,["cy"]=224,["start"]=50,["duration"]=7081,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=240,["radius_angle"]=0,["ways"]=6,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=360,["type"]=8,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cy",N.player_y(),0,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",(3.0)+1.0*N.pm(o.run),1,0,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (300.0+o.loops[1]*0)) then N.tween(o,o,"direction",0.75,1,0,1) end
if (t == (300.0+o.loops[1]*0)) then N.tween(o,o,"speed",1.0,0,0,1) end
if (t == (300.0+o.loops[1]*0)) then N.tween(o,o,"direction",180.0,0,0,1) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"cy",336.0,0,0,300) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"cx",325.0,0,0,300) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(2.5)+1.0*N.pm(o.run),0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(60.0)+30.0*N.pm(o.run),2,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,30) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=325,["cy"]=339,["start"]=470,["duration"]=6731,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=40,["radius_angle"]=0,["ways"]=10,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=175,["type"]=36,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"cycle",60.0,0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (25.0+o.loops[1]*0)) then N.tween(o,o,"direction",0.75,1,0,1) end
if (t == (25.0+o.loops[1]*0)) then N.tween(o,o,"direction",180.0,0,0,1) end
if (t == (25.0+o.loops[1]*0)) then N.tween(o,o,"speed",1.0,0,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(90.0)+50.0*N.pm(o.run),1,0,120) end
if (t == (160.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,20) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,15) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=384,["cy"]=224,["start"]=50,["duration"]=7081,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=240,["radius_angle"]=0,["ways"]=6,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=180,["type"]=8,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cy",N.player_y(),0,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",(0.6)+0.2*N.pm(o.run),1,0,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"cycle",6.0,0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (300.0+o.loops[1]*0)) then N.tween(o,o,"direction",0.75,1,0,1) end
if (t == (300.0+o.loops[1]*0)) then N.tween(o,o,"speed",1.0,0,0,1) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"cy",336.0,0,0,300) end
if (t == (300.0+o.loops[1]*0)) then N.tween(o,o,"direction",180.0,0,0,1) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"cx",325.0,0,0,300) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,0,0,120) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",240.0,1,0,1) end
if (t > (1.0+o.loops[0]*0)) and (t < (150.0+o.loops[0]*0)) then N.tween(o,o,"direction",0.6,2,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,0,0,30) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"direction",(45.0)+15.0*N.pm(o.run),2,0,60) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,70) end
if (t == (163.0+o.loops[0]*0)) then N.tween(o,o,"dispel",0.0,0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,30) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,30) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=352,["cy"]=224,["start"]=50,["duration"]=7081,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=240,["radius_angle"]=0,["ways"]=4,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=270,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=180,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=180,["type"]=3,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cy",N.player_y(),0,0,1) end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"cycle",1.0,0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (300.0+o.loops[1]*0)) then N.tween(o,o,"direction",0.75,1,0,1) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"cx",325.0,0,0,300) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"cy",336.0,0,0,300) end
if (t == (300.0+o.loops[1]*0)) then N.tween(o,o,"direction",180.0,0,0,1) end
if (t == (300.0+o.loops[1]*0)) then N.tween(o,o,"speed",1.0,0,0,1) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,0,0,120) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",240.0,1,0,1) end
if (t > (1.0+o.loops[0]*0)) and (t < (150.0+o.loops[0]*0)) then N.tween(o,o,"direction",0.6,2,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,0,0,30) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"direction",(45.0)+15.0*N.pm(o.run),2,0,60) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,70) end
if (t == (163.0+o.loops[0]*0)) then N.tween(o,o,"dispel",0.0,0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,30) end
if (t == (150.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,30) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=100,["green"]=150,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[5].events=nil
T.emitters[5].p.events=nil
return T
