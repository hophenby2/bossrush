-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=6200,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=0,["start"]=5400,["duration"]=30,["mode"]="enemy",["fx"]=505,["fy"]=175,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=190,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=30,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=5,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=1.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=99229,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyMaoYu03",["hp"]=150,["red_drop"]=1,["blue_drop"]=0,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=0,["green_drop"]=0,["star_drop"]=0}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
if (t == (10.0+o.loops[0]*0)) then N.emit(o) end
if (t == (20.0+o.loops[0]*0)) then N.emit(o) end
if (t == (24.0+o.loops[0]*0)) then N.emit(o) end
if (t == (26.0+o.loops[0]*0)) then N.emit(o) end
if (t == (28.0+o.loops[0]*0)) then N.emit(o) end
if (t == (30.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",20.0,1,0,100) end
if (t == (110.0+o.loops[0]*0)) then N.tween(o,o,"speed",5.0,1,0,100) end
if (t == (110.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+15.0*N.pm(o.run),0,1,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=352,["cy"]=0,["start"]=5510,["duration"]=30,["mode"]="enemy",["fx"]=120,["fy"]=175,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=-10,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=30,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=5,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=1.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=99229,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyMaoYu02",["hp"]=150,["red_drop"]=0,["blue_drop"]=1,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=0,["green_drop"]=0,["star_drop"]=0}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (10.0+o.loops[0]*0)) then N.emit(o) end
if (t == (20.0+o.loops[0]*0)) then N.emit(o) end
if (t == (24.0+o.loops[0]*0)) then N.emit(o) end
if (t == (26.0+o.loops[0]*0)) then N.emit(o) end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
if (t == (28.0+o.loops[0]*0)) then N.emit(o) end
if (t == (30.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",20.0,2,0,100) end
if (t == (110.0+o.loops[0]*0)) then N.tween(o,o,"speed",5.0,1,0,100) end
if (t == (110.0+o.loops[0]*0)) then N.tween(o,o,"direction",(180.0)+15.0*N.pm(o.run),0,1,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=0,["with_direction"]=false,["cx"]=320,["cy"]=96,["start"]=1,["duration"]=60,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=30,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=222200,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",720.0,1,0,60) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",3.0,1,0,60) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (5.0+o.loops[0]*0)) then N.tween(o,o,"speed",(3.0)+0.5*N.pm(o.run),2,0,15) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=352,["cy"]=96,["start"]=1,["duration"]=60,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=150,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=222200,["type"]=3,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",720.0,2,0,60) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",3.0,1,0,60) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (5.0+o.loops[0]*0)) then N.tween(o,o,"speed",(3.0)+0.5*N.pm(o.run),2,0,15) end
end
return T
