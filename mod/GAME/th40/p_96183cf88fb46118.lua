-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=270,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=1,["duration"]=270,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=180,["type"]=18,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (15.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",(0.0)+60.0*N.pm(o.run),1,0,120) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=416,["cy"]=160,["start"]=1,["duration"]=270,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=120,["radius_angle"]=90,["ways"]=6,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=2,["delta_v"]=2,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=720,["type"]=34,["width"]=1,["height"]=1,["red"]=255,["green"]=180,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (15.0+o.loops[0]*0)) then N.tween(o,o,"radius",0.0,0,0,30) end
if (t == (16.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",60.0,1,0,30) end
if (t == (16.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",60.0,1,0,30) end
if (t == (15.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (45.0+o.loops[0]*0)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",-2.0,0,0,60) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.4)+0.6*N.pm(o.run),0,0,60) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"direction",(30.0)+15.0*N.pm(o.run),2,0,60) end
if (t == (180.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=480,["cy"]=160,["start"]=1,["duration"]=270,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=120,["radius_angle"]=90,["ways"]=6,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=2,["delta_v"]=2,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=720,["type"]=34,["width"]=1,["height"]=1,["red"]=255,["green"]=180,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (15.0+o.loops[0]*0)) then N.tween(o,o,"radius",0.0,0,0,30) end
if (t == (16.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",60.0,2,0,30) end
if (t == (16.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",60.0,2,0,30) end
if (t == (15.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (45.0+o.loops[0]*0)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",-2.0,0,0,60) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.4)+0.6*N.pm(o.run),0,0,60) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"direction",(30.0)+15.0*N.pm(o.run),1,0,60) end
if (t == (180.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=448,["cy"]=160,["start"]=1,["duration"]=270,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=120,["radius_angle"]=90,["ways"]=6,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=2,["delta_v"]=2,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=120,["type"]=34,["width"]=1,["height"]=1,["red"]=255,["green"]=180,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (16.0+o.loops[0]*0)) then N.tween(o,o,"radius",0.0,0,0,30) end
if (t == (17.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",60.0,1,0,30) end
if (t == (17.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",60.0,1,0,30) end
if (t == (16.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (46.0+o.loops[0]*0)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",-2.0,0,0,60) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.4)+0.6*N.pm(o.run),0,0,60) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"direction",(30.0)+15.0*N.pm(o.run),2,0,60) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=512,["cy"]=160,["start"]=1,["duration"]=270,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=120,["radius_angle"]=90,["ways"]=6,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=2,["delta_v"]=2,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=120,["type"]=34,["width"]=1,["height"]=1,["red"]=255,["green"]=180,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (16.0+o.loops[0]*0)) then N.tween(o,o,"radius",0.0,0,0,30) end
if (t == (17.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",60.0,2,0,30) end
if (t == (17.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",60.0,2,0,30) end
if (t == (16.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (46.0+o.loops[0]*0)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",-2.0,0,0,60) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.4)+0.6*N.pm(o.run),0,0,60) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"direction",(30.0)+15.0*N.pm(o.run),1,0,60) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=320,["cy"]=224,["start"]=1,["duration"]=270,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=5,["delta_v"]=0.5,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=15,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=122,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (15.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",30.0,1,0,120) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=352,["cy"]=224,["start"]=1,["duration"]=270,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=5,["delta_v"]=0.5,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=15,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=122,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (15.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",30.0,2,0,120) end
end
return T
