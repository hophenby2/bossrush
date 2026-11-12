-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=99999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=142,["start"]=1,["duration"]=99999,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=2,["cycle"]=1,["emit_angle"]=160,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=720,["type"]=18,["width"]=0.5,["height"]=0.5,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=114,["angle"]=180,["follow"]=true,["speed"]=0.1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1100==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*1100)) and (t < (399.0+o.loops[0]*1100)) then N.tween(o,o,"radius",1.0,1,0,1) end
if (t > (1.0+o.loops[0]*1100)) and (t < (399.0+o.loops[0]*1100)) then N.tween(o,o,"radius_angle",16.7,1,0,1) end
if (t > (1.0+o.loops[0]*1100)) and (t < (399.0+o.loops[0]*1100)) then N.tween(o,o,"emit_angle",16.7,1,0,1) end
if (t == (1.0+o.loops[0]*1100)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (400.0+o.loops[0]*1100)) then N.tween(o,o,"radius_angle",0.0,0,0,1) end
if (t == (400.0+o.loops[0]*1100)) then N.tween(o,o,"emit_angle",160.0,0,0,1) end
if (t == (400.0+o.loops[0]*1100)) then N.tween(o,o,"radius",0.0,0,0,1) end
if (t == (180.0+o.loops[0]*1100)) then N.tween(o,o,"cycle",99999.0,0,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (200.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.5)+0.5*N.pm(o.run),1,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"red",106.0,0,0,40) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"green",76.0,0,0,40) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",156.0,0,0,40) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,1,0,200) end
if (t == (200.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t == (210.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+15.0*N.pm(o.run),1,0,100) end
if (t == (220.0+o.loops[0]*0)) then N.tween(o,o,"red",80.0,1,0,60) end
if (t == (220.0+o.loops[0]*0)) then N.tween(o,o,"green",80.0,1,0,60) end
if (t == (220.0+o.loops[0]*0)) then N.tween(o,o,"blue",80.0,1,0,60) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=142,["start"]=550,["duration"]=99300,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=2,["cycle"]=1,["emit_angle"]=200,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=720,["type"]=18,["width"]=0.5,["height"]=0.5,["red"]=180,["green"]=180,["blue"]=180,["alpha"]=114,["angle"]=180,["follow"]=true,["speed"]=0.1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1100==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*1100)) and (t < (399.0+o.loops[0]*1100)) then N.tween(o,o,"radius",1.0,1,0,1) end
if (t > (1.0+o.loops[0]*1100)) and (t < (399.0+o.loops[0]*1100)) then N.tween(o,o,"radius_angle",16.7,2,0,1) end
if (t > (1.0+o.loops[0]*1100)) and (t < (399.0+o.loops[0]*1100)) then N.tween(o,o,"emit_angle",16.7,2,0,1) end
if (t == (1.0+o.loops[0]*1100)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (180.0+o.loops[0]*1100)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (400.0+o.loops[0]*1100)) then N.tween(o,o,"emit_angle",200.0,0,0,1) end
if (t == (400.0+o.loops[0]*1100)) then N.tween(o,o,"radius",0.0,0,0,1) end
if (t == (400.0+o.loops[0]*1100)) then N.tween(o,o,"radius_angle",0.0,0,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (200.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.4)+0.4*N.pm(o.run),1,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"red",119.0,0,0,40) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"green",66.0,0,0,40) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",141.0,0,0,40) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,1,0,200) end
if (t == (200.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,50) end
if (t == (210.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+15.0*N.pm(o.run),1,0,100) end
if (t == (220.0+o.loops[0]*0)) then N.tween(o,o,"red",80.0,1,0,60) end
if (t == (220.0+o.loops[0]*0)) then N.tween(o,o,"green",80.0,1,0,60) end
if (t == (220.0+o.loops[0]*0)) then N.tween(o,o,"blue",80.0,1,0,60) end
end
return T
