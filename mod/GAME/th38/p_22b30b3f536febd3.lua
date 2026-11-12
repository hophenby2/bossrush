-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=12000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=9760,["duration"]=2241,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=140,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=40,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=100,["type"]=227,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=false,["texture"]="bullet50_7"}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",(4.0)+0.5*N.pm(o.run),0,0,400) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"alpha",35.0,0,0,400) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"green",70.0,0,0,400) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"height",2.0,0,0,400) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"width",2.0,0,0,400,o.p.height) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",3.0,1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"blue",150.0,0,0,400) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,100) end
if (t == (50.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"green",80.0,0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"blue",150.0,0,0,100) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=9760,["duration"]=2241,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=130,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=110,["type"]=227,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=false,["texture"]="bullet50_7"}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",(6.0)+1.0*N.pm(o.run),0,0,400) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"alpha",40.0,0,0,400) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"green",120.0,0,0,400) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"height",2.0,0,0,400) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"width",2.0,0,0,400,o.p.height) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",1.0,2,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,100) end
if (t == (50.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,60) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"green",155.0,0,0,100) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=9800,["duration"]=2201,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=180,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=150,["type"]=227,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=false,["texture"]="bullet50_7"}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"alpha",70.0,0,0,500) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"green",120.0,0,0,500) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"height",2.0,0,0,500) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"width",2.0,0,0,500,o.p.height) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",1.0,1,0,1) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(6.0)+1.0*N.pm(o.run),0,0,300) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,150) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"green",155.0,0,0,200) end
end
return T
