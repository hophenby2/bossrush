-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=0,["start"]=5450,["duration"]=1,["mode"]="enemy",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA8",["hp"]=6000,["red_drop"]=4,["blue_drop"]=4,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=500,["green_drop"]=0,["star_drop"]=1}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (600.0+o.loops[0]*0)) then N.tween(o,o,"direction",180.0,1,0,1) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.05,0,0,60) end
if (t == (600.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.0,0,0,60) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=224,["cy"]=128,["start"]=1,["duration"]=720,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=8,["cycle"]=8,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.2,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=170,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%150==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*150)) then N.tween(o,o,"emit_angle",360.0,1,0,150) end
if (t == (1.0+o.loops[0]*150)) then N.tween(o,o,"emit_angle",(45.0)+10.0*N.pm(o.run),1,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+20.0*N.pm(o.run),2,0,1) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,20) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.0,0,0,120) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=256,["cy"]=128,["start"]=1,["duration"]=720,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=8,["cycle"]=8,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.2,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=169,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%150==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*150)) then N.tween(o,o,"emit_angle",360.0,2,0,150) end
if (t == (1.0+o.loops[0]*150)) then N.tween(o,o,"emit_angle",(45.0)+10.0*N.pm(o.run),1,0,1) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+20.0*N.pm(o.run),1,0,1) end
if (t == (60.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,20) end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.0,0,0,120) end
end
return T
