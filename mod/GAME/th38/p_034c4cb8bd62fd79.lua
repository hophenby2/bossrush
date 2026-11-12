-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=9999,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=6,["cycle"]=144,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=45,["y"]=45,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=150,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3.4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=nil
T.emitters[1].p.events=nil
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=0,["with_direction"]=true,["cx"]=320,["cy"]=224,["start"]=1,["duration"]=9999,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=18,["emit_angle"]=60,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=150,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3.4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=nil
T.emitters[2].p.events=nil
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=352,["cy"]=448,["start"]=1,["duration"]=9999,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=18,["emit_angle"]=60,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=50,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cx < (110.0+o.loops[0]*0)) or (o.cx > (530.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy < (0.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t+1)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (50.0+o.loops[1]*0)) then N.tween(o,o,"alpha",255.0,0,0,15) end
if (t == (110.0+o.loops[1]*0)) then N.tween(o,o,"alpha",0.0,0,0,30) end
if (t == (50.0+o.loops[1]*0)) then N.tween(o,o,"width",1.0,0,0,25) end
if (t == (110.0+o.loops[1]*0)) then N.tween(o,o,"height",0.0,0,0,30) end
if (t == (50.0+o.loops[1]*0)) then N.tween(o,o,"height",0.15,0,0,50) end
if (t == (110.0+o.loops[1]*0)) then N.tween(o,o,"width",0.0,0,0,30) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=416,["cy"]=448,["start"]=1,["duration"]=9999,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=35,["radius_angle"]=0,["ways"]=6,["cycle"]=18,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=140,["type"]=3,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet66_0"}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cx < (110.0+o.loops[0]*0)) or (o.cx > (530.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy < (0.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t+1)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"alpha",255.0,0,0,15) end
if (t == (110.0+o.loops[1]*0)) then N.tween(o,o,"alpha",0.0,0,0,30) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"width",0.4,0,0,50) end
if (t == (110.0+o.loops[1]*0)) then N.tween(o,o,"height",0.0,0,0,30) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"height",0.4,0,0,50) end
if (t == (110.0+o.loops[1]*0)) then N.tween(o,o,"width",0.0,0,0,30) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=448,["cy"]=416,["start"]=1,["duration"]=9999,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=30,["radius_angle"]=30,["ways"]=6,["cycle"]=18,["emit_angle"]=30,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=100,["type"]=228,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="yuan_3"}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cx < (110.0+o.loops[0]*0)) or (o.cx > (530.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy < (0.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t+1)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"alpha",255.0,0,0,10) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"width",1.0,0,0,20) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"height",0.02,0,0,20) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=30,["duration"]=60,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=10,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=3,["width"]=1,["height"]=1,["red"]=150,["green"]=150,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[6].events=nil
T.emitters[6].p.events=nil
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=384,["cy"]=448,["start"]=45,["duration"]=1,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=30,["radius_angle"]=30,["ways"]=6,["cycle"]=1,["emit_angle"]=30,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=100,["type"]=228,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=16,["cover"]=true}}
T.emitters[7].events=nil
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cx < (110.0+o.loops[0]*0)) or (o.cx > (530.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy < (0.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
o.loops[1]=o.loops[1] or 0
if (t+1)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"alpha",255.0,0,0,15) end
if (t == (70.0+o.loops[1]*0)) then N.tween(o,o,"alpha",0.0,0,0,30) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"width",0.95,0,0,25) end
if (t == (70.0+o.loops[1]*0)) then N.tween(o,o,"height",0.0,0,0,30) end
if (t == (1.0+o.loops[1]*0)) then N.tween(o,o,"height",0.13,0,0,50) end
if (t == (70.0+o.loops[1]*0)) then N.tween(o,o,"width",0.0,0,0,30) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=100,["duration"]=9900,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=12,["cycle"]=9999,["emit_angle"]=90,["spread"]=275,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=106,["width"]=0.35,["height"]=0.35,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%400==0 then o.loops[0]=o.loops[0]+1 end
if (t == (201.0+o.loops[0]*400)) then N.tween(o,o,"cycle",3.0,0,0,1) end
if (t == (300.0+o.loops[0]*400)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (201.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",300.0,1,0,100) end
if (t == (201.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",3.2,1,0,100) end
if (t == (398.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",1.0,0,0,1) end
if (t == (398.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",90.0,0,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o,"cycle",3.0,0,0,1) end
if (t == (100.0+o.loops[0]*400)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",300.0,2,0,100) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",3.2,1,0,100) end
if (t == (198.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",1.0,0,0,1) end
if (t == (198.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",90.0,0,0,1) end
end
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
end
return T
