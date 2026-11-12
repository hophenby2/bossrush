-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=3,["with_direction"]=false,["cx"]=320,["cy"]=91,["start"]=1,["duration"]=9999,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=360,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=450,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%181==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*181)) then N.tween(o,o,"width",0.05,2,2,180) end
o.loops[1]=o.loops[1] or 0
if (t+1)%181==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*181)) then N.tween(o,o,"speed",0.15,1,2,180) end
o.loops[2]=o.loops[2] or 0
if (t+1)%1==0 then o.loops[2]=o.loops[2]+1 end
if (t == (1.0+o.loops[2]*0)) then N.tween(o,o,"alpha",255.0,0,0,60) end
if (t == (240.0+o.loops[2]*0)) then N.tween(o,o,"alpha",0.0,0,0,60) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=3,["with_direction"]=false,["cx"]=316,["cy"]=134,["start"]=1,["duration"]=9999,["mode"]="enemy",["fx"]=-99998,["fy"]=-99998,["radius"]=4,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=3000,["type"]=1,["width"]=2,["height"]=2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=360,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA1",["hp"]=99999,["red_drop"]=0,["blue_drop"]=0,["enemy_color"]=0,["backfire"]=true,["clear_radius"]=0,["green_drop"]=0,["star_drop"]=0}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%181==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*181)) then N.tween(o,o,"width",0.05,2,2,180) end
o.loops[1]=o.loops[1] or 0
if (t+1)%181==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*181)) then N.tween(o,o,"speed",0.25,1,2,180) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=3,["with_direction"]=false,["cx"]=356,["cy"]=72,["start"]=1,["duration"]=9999,["mode"]="enemy",["fx"]=-99998,["fy"]=-99998,["radius"]=4,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=3000,["type"]=1,["width"]=2,["height"]=2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=360,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA0",["hp"]=99999,["red_drop"]=0,["blue_drop"]=0,["enemy_color"]=0,["backfire"]=true,["clear_radius"]=0,["green_drop"]=0,["star_drop"]=0}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%181==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*181)) then N.tween(o,o,"width",0.05,2,2,180) end
o.loops[1]=o.loops[1] or 0
if (t+1)%181==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*181)) then N.tween(o,o,"speed",0.25,1,2,180) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=480,["cy"]=321,["start"]=4800,["duration"]=5200,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,60) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"direction",90.0,0,0,1) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,1,0,60) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=159,["cy"]=321,["start"]=4800,["duration"]=5200,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=3,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,60) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"direction",90.0,0,0,1) end
if (t == (420.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,1,0,60) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=4,["with_direction"]=false,["cx"]=381,["cy"]=91,["start"]=1,["duration"]=9999,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=360,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=450,["follow"]=false,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%181==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*181)) then N.tween(o,o,"width",0.05,2,2,180) end
o.loops[1]=o.loops[1] or 0
if (t+1)%181==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*181)) then N.tween(o,o,"speed",0.15,1,2,180) end
o.loops[2]=o.loops[2] or 0
if (t+1)%1==0 then o.loops[2]=o.loops[2]+1 end
if (t == (1.0+o.loops[2]*0)) then N.tween(o,o,"alpha",255.0,0,0,60) end
if (t == (240.0+o.loops[2]*0)) then N.tween(o,o,"alpha",0.0,0,0,60) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=4,["with_direction"]=false,["cx"]=379,["cy"]=134,["start"]=1,["duration"]=9999,["mode"]="enemy",["fx"]=-99998,["fy"]=-99998,["radius"]=4,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=3000,["type"]=1,["width"]=2,["height"]=2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=360,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA1",["hp"]=99999,["red_drop"]=0,["blue_drop"]=0,["enemy_color"]=0,["backfire"]=true,["clear_radius"]=0,["green_drop"]=0,["star_drop"]=0}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%181==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*181)) then N.tween(o,o,"width",0.05,2,2,180) end
o.loops[1]=o.loops[1] or 0
if (t+1)%181==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*181)) then N.tween(o,o,"speed",0.25,1,2,180) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=4,["with_direction"]=false,["cx"]=410,["cy"]=72,["start"]=1,["duration"]=9999,["mode"]="enemy",["fx"]=-99998,["fy"]=-99998,["radius"]=4,["radius_angle"]=0,["ways"]=1,["cycle"]=99999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=3000,["type"]=1,["width"]=2,["height"]=2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=360,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA0",["hp"]=99999,["red_drop"]=0,["blue_drop"]=0,["enemy_color"]=0,["backfire"]=true,["clear_radius"]=0,["green_drop"]=0,["star_drop"]=0}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%181==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*181)) then N.tween(o,o,"width",0.05,2,2,180) end
o.loops[1]=o.loops[1] or 0
if (t+1)%181==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*181)) then N.tween(o,o,"speed",0.25,1,2,180) end
end
return T
