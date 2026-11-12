-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=9000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=30,["radius_angle"]=0,["ways"]=16,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0.3,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=21,["width"]=0.45,["height"]=0.45,["red"]=93,["green"]=172,["blue"]=129,["alpha"]=127,["angle"]=180,["follow"]=true,["speed"]=2.2,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=1,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%14==0 then o.loops[0]=o.loops[0]+1 end
if (t == (2.0+o.loops[0]*14)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (2.0+o.loops[0]*14)) then N.tween(o,o,"emit_angle",14.0,1,0,8) end
if (t == (1.0+o.loops[0]*14)) then N.tween(o,o.p,"speed",2.8,0,0,1) end
if (t == (8.0+o.loops[0]*14)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (2.0+o.loops[0]*14)) then N.tween(o,o.p,"speed",0.85,1,0,8) end
if (t == (2.0+o.loops[0]*14)) then N.tween(o,o,"radius_angle",14.0,1,0,8) end
if (t == (9.0+o.loops[0]*14)) then N.tween(o,o,"radius",30.0,0,0,1) end
if (t == (2.0+o.loops[0]*14)) then N.tween(o,o,"radius",0.0,0,0,8) end
if (t == (12.0+o.loops[0]*14)) then N.tween(o,o,"emit_angle",7.0,2,0,1) end
if (t == (12.0+o.loops[0]*14)) then N.tween(o,o,"radius_angle",7.0,2,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"green",(-15.0)+30.0*N.pm(o.run),1,0,30) end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"blue",(-15.0)+30.0*N.pm(o.run),1,0,30) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,35) end
end
return T
