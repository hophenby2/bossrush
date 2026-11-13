-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=512,["cy"]=0,["start"]=40,["duration"]=60,["mode"]="enemy",["fx"]=-99998,["fy"]=-10,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=10,["emit_angle"]=110,["spread"]=360,["speed"]=0,["direction"]=180,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=322222,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=8,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyYYY4",["hp"]=40,["red_drop"]=6,["blue_drop"]=0,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=10,["green_drop"]=0,["star_drop"]=0}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",1.55,1,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,1,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=128,["cy"]=0,["start"]=100,["duration"]=70,["mode"]="enemy",["fx"]=-99998,["fy"]=-10,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=10,["emit_angle"]=70,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=322222,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=8,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyYYY5",["hp"]=40,["red_drop"]=0,["blue_drop"]=4,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=10,["green_drop"]=0,["star_drop"]=0}}
T.emitters[2].events=nil
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",1.55,2,0,1) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,1,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=480,["cy"]=160,["start"]=1,["duration"]=9999,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=90,["spread"]=290,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=55,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.75,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=65,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=-1.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=nil
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,1,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=160,["cy"]=160,["start"]=1,["duration"]=9999,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=90,["spread"]=290,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=55,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.75,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=67,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=-1.75,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=nil
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",5.0,2,0,1) end
end
T.emitters[5]={["id"]=0,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=480,["cy"]=96,["start"]=1,["duration"]=9999,["mode"]="laser",["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=3,["emit_angle"]=-10,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["head"]=true,["random"]={["radius"]=10,["radius_angle"]=360,["ways"]=0,["cycle"]=2,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=20022,["type"]=0,["width"]=1,["height"]=1,["length"]=40,["alpha"]=255,["angle"]=0,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",2.75,1,0,1) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,1,0,1) end
end
T.emitters[6]={["id"]=1,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=160,["cy"]=96,["start"]=1,["duration"]=9999,["mode"]="laser",["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=3,["emit_angle"]=190,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["head"]=true,["random"]={["radius"]=10,["radius_angle"]=360,["ways"]=0,["cycle"]=2,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=20022,["type"]=2,["width"]=1,["height"]=1,["length"]=50,["alpha"]=255,["angle"]=0,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",2.75,2,0,1) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.1,1,0,1) end
end
return T
