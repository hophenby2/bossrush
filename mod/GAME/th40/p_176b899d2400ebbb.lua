-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=5000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=150,["duration"]=4851,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=40,["radius_angle"]=0,["ways"]=72,["cycle"]=9999,["emit_angle"]=270,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=227,["width"]=0.15,["height"]=1.2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%540==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"direction",0.78,1,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"emit_angle",0.78,1,0,1) end
if (t == (10.0+o.loops[0]*540)) then N.tween(o,o,"cycle",3.0,0,0,1) end
if (t == (250.0+o.loops[0]*540)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (1.0+o.loops[0]*540)) then N.tween(o,o.p,"speed",7.0,1,0,70) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o.p,"speed",0.001,1,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o.p,"speed",0.001,1,0,1) end
if (t == (251.0+o.loops[0]*540)) then N.tween(o,o.p,"speed",2.0,0,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o.p,"speed",0.001,1,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cx > (530.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cx < (120.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy > (470.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy < (10.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=150,["duration"]=4851,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=40,["radius_angle"]=0,["ways"]=72,["cycle"]=9999,["emit_angle"]=270,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=5,["type"]=227,["width"]=0.15,["height"]=0.4,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="yuan_9"}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%540==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"direction",0.7,1,0,1) end
if (t == (10.0+o.loops[0]*540)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"emit_angle",0.7,1,0,1) end
if (t == (250.0+o.loops[0]*540)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[2].p.events=nil
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=416,["start"]=10,["duration"]=4951,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=20000,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cy",N.player_y(),0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"cx",N.player_x(),0,0,1) end
if (t == (3.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",N.aim(o),0,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=165,["duration"]=4836,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=30,["radius_angle"]=0,["ways"]=6,["cycle"]=9999,["emit_angle"]=-99999,["spread"]=30,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1000,["type"]=106,["width"]=0.2,["height"]=0.2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=false,["speed"]=15,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%540==0 then o.loops[0]=o.loops[0]+1 end
if (t == (250.0+o.loops[0]*540)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (10.0+o.loops[0]*540)) then N.tween(o,o,"cycle",20.0,0,0,1) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cx > (530.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cx < (120.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy > (470.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy < (10.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+5.0*N.pm(o.run),1,0,1) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=160,["cy"]=288,["start"]=10,["duration"]=4991,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=20000,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,60) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=370,["duration"]=4631,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%540==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*540)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (6.0+o.loops[0]*540)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[6].p.events=nil
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=420,["duration"]=4581,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=40,["radius_angle"]=0,["ways"]=72,["cycle"]=9999,["emit_angle"]=270,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=227,["width"]=0.15,["height"]=1.2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%540==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"direction",0.78,2,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"emit_angle",0.78,2,0,1) end
if (t == (10.0+o.loops[0]*540)) then N.tween(o,o,"cycle",3.0,0,0,1) end
if (t == (1.0+o.loops[0]*540)) then N.tween(o,o.p,"speed",7.0,1,0,70) end
if (t == (250.0+o.loops[0]*540)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o.p,"speed",0.001,1,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o.p,"speed",0.001,1,0,1) end
if (t == (251.0+o.loops[0]*540)) then N.tween(o,o.p,"speed",2.0,0,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o.p,"speed",0.001,1,0,1) end
end
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cx > (530.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cx < (120.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy > (470.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy < (10.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=420,["duration"]=4581,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=40,["radius_angle"]=0,["ways"]=72,["cycle"]=9999,["emit_angle"]=270,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=5,["type"]=227,["width"]=0.15,["height"]=0.4,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="yuan_9"}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%540==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"direction",0.7,1,0,1) end
if (t == (10.0+o.loops[0]*540)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"emit_angle",0.7,1,0,1) end
if (t == (250.0+o.loops[0]*540)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[8].p.events=nil
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=100,["duration"]=4901,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[9].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%540==0 then o.loops[0]=o.loops[0]+1 end
if (t == (6.0+o.loops[0]*540)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (1.0+o.loops[0]*540)) then N.tween(o,o,"cycle",2.0,0,0,1) end
end
T.emitters[9].p.events=nil
T.emitters[10]={["id"]=9,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=165,["duration"]=4836,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=30,["radius_angle"]=0,["ways"]=48,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1000,["type"]=2,["width"]=1.3,["height"]=1.3,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[10].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%540==0 then o.loops[0]=o.loops[0]+1 end
if (t == (180.0+o.loops[0]*540)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (10.0+o.loops[0]*540)) then N.tween(o,o,"cycle",18.0,0,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"emit_angle",1.0,1,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"radius_angle",0.78,1,0,1) end
end
T.emitters[10].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cx > (530.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cx < (120.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy > (470.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy < (10.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
end
T.emitters[11]={["id"]=10,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=420,["duration"]=4581,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=30,["radius_angle"]=0,["ways"]=48,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1000,["type"]=3,["width"]=1.3,["height"]=1.3,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[11].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%540==0 then o.loops[0]=o.loops[0]+1 end
if (t == (180.0+o.loops[0]*540)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (10.0+o.loops[0]*540)) then N.tween(o,o,"cycle",18.0,0,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"emit_angle",1.0,2,0,1) end
if (t > (1.0+o.loops[0]*540)) then N.tween(o,o,"radius_angle",0.78,2,0,1) end
end
T.emitters[11].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cx > (530.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cx < (120.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy > (470.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy < (10.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
end
T.emitters[12]={["id"]=11,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=420,["duration"]=4581,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=30,["radius_angle"]=0,["ways"]=6,["cycle"]=9999,["emit_angle"]=-99999,["spread"]=30,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1000,["type"]=106,["width"]=0.2,["height"]=0.2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=false,["speed"]=15,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[12].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%540==0 then o.loops[0]=o.loops[0]+1 end
if (t == (250.0+o.loops[0]*540)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (10.0+o.loops[0]*540)) then N.tween(o,o,"cycle",20.0,0,0,1) end
end
T.emitters[12].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cx > (530.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cx < (120.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy > (470.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (o.cy < (10.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",3.0,1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+5.0*N.pm(o.run),1,0,1) end
end
T.emitters[13]={["id"]=0,["layer"]=0,["bind"]=2,["cx"]=288,["cy"]=448,["start"]=1,["duration"]=5000,["mode"]="cover",["width"]=60,["height"]=60,["round"]=true,["type"]=1,["control_id"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["p"]={}}
T.emitters[13].events=nil
T.emitters[13].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
end
T.emitters[14]={["id"]=1,["layer"]=0,["bind"]=2,["cx"]=352,["cy"]=448,["start"]=1,["duration"]=5000,["mode"]="cover",["width"]=70,["height"]=70,["round"]=true,["type"]=1,["control_id"]=3,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["p"]={}}
T.emitters[14].events=nil
T.emitters[14].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.0)+0.1*N.pm(o.run),0,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,10) end
end
T.emitters[15]={["id"]=2,["layer"]=0,["bind"]=2,["cx"]=320,["cy"]=448,["start"]=1,["duration"]=5000,["mode"]="cover",["width"]=60,["height"]=60,["round"]=true,["type"]=1,["control_id"]=6,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["p"]={}}
T.emitters[15].events=nil
T.emitters[15].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"life",1.0,0,0,1) end
end
T.emitters[16]={["id"]=3,["layer"]=0,["bind"]=2,["cx"]=384,["cy"]=448,["start"]=1,["duration"]=5000,["mode"]="cover",["width"]=70,["height"]=70,["round"]=true,["type"]=1,["control_id"]=11,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["p"]={}}
T.emitters[16].events=nil
T.emitters[16].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.0)+0.1*N.pm(o.run),0,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,10) end
end
return T
