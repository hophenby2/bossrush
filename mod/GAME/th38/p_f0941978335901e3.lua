-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=5000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=318,["cy"]=125,["start"]=1,["duration"]=5000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=-99999,["spread"]=1,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=168,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3,["direction"]=0,["accel"]=0,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%200==0 then o.loops[0]=o.loops[0]+1 end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"spread",72.0,1,0,12) end
if (t > (2.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,1,1,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",1.0,0,0,12) end
if (t == (13.0+o.loops[0]*201)) then N.tween(o,o,"cycle",1123123123.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",3.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"spread",1.0,0,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",120.0,0,0,100) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=318,["cy"]=125,["start"]=1,["duration"]=5000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=-99999,["spread"]=1,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=168,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3,["direction"]=0,["accel"]=0,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%200==0 then o.loops[0]=o.loops[0]+1 end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"spread",72.0,1,0,12) end
if (t > (2.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,1,1,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",1.0,0,0,12) end
if (t == (13.0+o.loops[0]*201)) then N.tween(o,o,"cycle",1123123123.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",3.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"spread",1.0,0,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",120.0,0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",72.0,1,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=318,["cy"]=125,["start"]=1,["duration"]=5000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=-99999,["spread"]=1,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=168,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3,["direction"]=0,["accel"]=0,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%200==0 then o.loops[0]=o.loops[0]+1 end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"spread",72.0,1,0,12) end
if (t > (2.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,1,1,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",1.0,0,0,12) end
if (t == (13.0+o.loops[0]*201)) then N.tween(o,o,"cycle",1123123123.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",3.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"spread",1.0,0,0,1) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",120.0,0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",72.0,2,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=318,["cy"]=125,["start"]=1,["duration"]=5000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=-99999,["spread"]=1,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=168,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3,["direction"]=0,["accel"]=0,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%200==0 then o.loops[0]=o.loops[0]+1 end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"spread",72.0,1,0,12) end
if (t > (2.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,1,1,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",1.0,0,0,12) end
if (t == (13.0+o.loops[0]*201)) then N.tween(o,o,"cycle",1123123123.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",3.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"spread",1.0,0,0,1) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",120.0,0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",144.0,2,0,1) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=318,["cy"]=125,["start"]=1,["duration"]=5000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=-99999,["spread"]=1,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=168,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3,["direction"]=0,["accel"]=0,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%200==0 then o.loops[0]=o.loops[0]+1 end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"spread",72.0,1,0,12) end
if (t > (2.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,1,1,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",1.0,0,0,12) end
if (t == (13.0+o.loops[0]*201)) then N.tween(o,o,"cycle",1123123123.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",3.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"spread",1.0,0,0,1) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",120.0,0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",144.0,1,0,1) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=318,["cy"]=125,["start"]=1,["duration"]=5000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=5,["cycle"]=2412,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=226,["width"]=2,["height"]=2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.2,["direction"]=0,["accel"]=0,["accel_angle"]=90,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%200==0 then o.loops[0]=o.loops[0]+1 end
if (t == (13.0+o.loops[0]*201)) then N.tween(o,o,"cycle",1123123123.0,0,0,1) end
if (t == (12.0+o.loops[0]*201)) then N.tween(o,o,"cycle",1.0,0,0,1) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",120.0,0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",36.0,1,0,1) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=5,["with_direction"]=true,["cx"]=311,["cy"]=140,["start"]=1,["duration"]=5000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=10,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=20055,["type"]=22,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=-5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[7].events=nil
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",-2.0,0,0,20) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=5,["with_direction"]=true,["cx"]=311,["cy"]=140,["start"]=1,["duration"]=5000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=10,["emit_angle"]=72,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=20055,["type"]=22,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=-5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[8].events=nil
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",-2.0,0,0,20) end
end
return T
