-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=384,["cy"]=0,["start"]=380,["duration"]=280,["mode"]="enemy",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=11,["emit_angle"]=100,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=300,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=5,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=1,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=0.05,["height"]=0.05,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["enemy"]="EnemyA3",["hp"]=30,["red_drop"]=5,["blue_drop"]=2,["enemy_color"]=0,["backfire"]=false,["clear_radius"]=0,["green_drop"]=0,["star_drop"]=0}}
T.emitters[1].events=nil
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.08,1,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=0,["with_direction"]=true,["cx"]=288,["cy"]=192,["start"]=1,["duration"]=9999,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=5,["radius_angle"]=3360,["ways"]=0,["cycle"]=0,["emit_angle"]=12,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=1,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=30,["type"]=70,["width"]=3,["height"]=3,["red"]=100,["green"]=100,["blue"]=100,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=nil
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",6.0,1,0,1) end
if (t == (202.0+o.loops[0]*0)) then N.tween(o,o,"height",0.0,0,0,10) end
if (t == (202.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0,0,0,10) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",1.0,0,0,10) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",1.0,0,0,10) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",255.0,0,0,17) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"red",255.0,0,0,17) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"green",255.0,0,0,17) end
end
return T
