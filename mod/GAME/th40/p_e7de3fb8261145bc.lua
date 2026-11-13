-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=20000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=1,["with_direction"]=false,["cx"]=161,["cy"]=123,["start"]=80,["duration"]=7,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=90,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=9999,["type"]=182,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",3.5,2,0,7) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"ways",5.0,1,0,5) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"spread",70.0,1,0,7) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.0)+0.4*N.pm(o.run),1,0,50) end
if (t == (50.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.5)+0.3*N.pm(o.run),0,0,300) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(90.0)+15.0*N.pm(o.run),0,0,120) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=19976,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=0,["spread"]=90,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=224,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2.5,["direction"]=0,["accel"]=0.1,["accel_angle"]=270,["scale_x"]=1.4,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%600==0 then o.loops[0]=o.loops[0]+1 end
if (t == (50.0+o.loops[0]*600)) then N.tween(o,o,"cycle",99999.0,0,0,1) end
if (t == (1.0+o.loops[0]*600)) then N.tween(o,o,"cycle",10.0,0,0,1) end
if (t == (1.0+o.loops[0]*600)) then N.tween(o,o,"emit_angle",180.0,1,0,50) end
if (t == (50.0+o.loops[0]*600)) then N.tween(o,o,"emit_angle",0.0,0,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cy < (25.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.2,0,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=300,["duration"]=19401,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=180,["spread"]=90,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=224,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2.5,["direction"]=0,["accel"]=0.1,["accel_angle"]=270,["scale_x"]=1.4,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%600==0 then o.loops[0]=o.loops[0]+1 end
if (t == (50.0+o.loops[0]*600)) then N.tween(o,o,"cycle",99999.0,0,0,1) end
if (t == (1.0+o.loops[0]*600)) then N.tween(o,o,"cycle",10.0,0,0,1) end
if (t == (1.0+o.loops[0]*600)) then N.tween(o,o,"emit_angle",180.0,2,0,50) end
if (t == (50.0+o.loops[0]*600)) then N.tween(o,o,"emit_angle",180.0,0,0,1) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (o.cy < (25.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.2,0,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=193,["cy"]=123,["start"]=80,["duration"]=7,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=90,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=9999,["type"]=182,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=4,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",3.5,2,0,7) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"ways",5.0,1,0,5) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"spread",70.0,1,0,7) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.0)+0.4*N.pm(o.run),1,0,50) end
if (t == (50.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.5)+0.3*N.pm(o.run),0,0,300) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(90.0)+15.0*N.pm(o.run),0,0,120) end
end
return T
