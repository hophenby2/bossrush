-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=3000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=30,["duration"]=1800,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=135,["width"]=0.3,["height"]=0.3,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%201==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*201)) and (t < (200.0+o.loops[0]*201)) then N.tween(o,o,"emit_angle",18.0,1,0,1) end
if (t == (60.0+o.loops[0]*201)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,0,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (200.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,1,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (90.0+o.loops[0]*0)) then N.tween(o,o,"direction",2.8,2,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,50) end
if (t > (90.0+o.loops[0]*0)) and (t < (115.0+o.loops[0]*0)) then N.tween(o,o,"direction",2.8,2,0,1) end
if (t == (115.0+o.loops[0]*0)) then N.tween(o,o,"speed",(2.0)+1.0*N.pm(o.run),0,0,25) end
if (t == (115.0+o.loops[0]*0)) then N.tween(o,o,"width",1.0,0,0,5) end
if (t == (115.0+o.loops[0]*0)) then N.tween(o,o,"height",1.0,0,0,5) end
if (t == (125.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (115.0+o.loops[0]*0)) then N.tween(o,o,"direction",(20.0)+20.0*N.pm(o.run),1,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=30,["duration"]=1800,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=999,["emit_angle"]=180,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=135,["width"]=0.3,["height"]=0.3,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%201==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*201)) and (t < (200.0+o.loops[0]*201)) then N.tween(o,o,"emit_angle",18.0,2,0,1) end
if (t == (60.0+o.loops[0]*201)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,0,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"cycle",4.0,0,0,1) end
if (t == (200.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,1,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) and (t < (90.0+o.loops[0]*0)) then N.tween(o,o,"direction",2.8,1,0,1) end
if (t == (40.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.5,1,0,50) end
if (t > (90.0+o.loops[0]*0)) and (t < (115.0+o.loops[0]*0)) then N.tween(o,o,"direction",2.8,1,0,1) end
if (t == (115.0+o.loops[0]*0)) then N.tween(o,o,"speed",(2.0)+1.0*N.pm(o.run),0,0,25) end
if (t == (115.0+o.loops[0]*0)) then N.tween(o,o,"width",1.0,0,0,5) end
if (t == (115.0+o.loops[0]*0)) then N.tween(o,o,"direction",(20.0)+20.0*N.pm(o.run),2,0,1) end
if (t == (115.0+o.loops[0]*0)) then N.tween(o,o,"height",1.0,0,0,5) end
if (t == (125.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=30,["duration"]=1800,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=1,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%201==0 then o.loops[0]=o.loops[0]+1 end
if (t == (115.0+o.loops[0]*201)) then N.emit(o) end
end
T.emitters[3].p.events=nil
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=30,["duration"]=1800,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=999,["type"]=130,["width"]=0.3,["height"]=0.3,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=12,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%201==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o,"emit_angle",333.0,1,0,60) end
if (t == (60.0+o.loops[0]*201)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o,"cycle",3.0,0,0,1) end
if (t == (200.0+o.loops[0]*201)) then N.tween(o,o,"ways",1.0,1,0,1) end
if (t == (1.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",12.0,0,0,1) end
if (t == (2.0+o.loops[0]*201)) then N.tween(o,o.p,"speed",2.0,0,0,60) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (80.0+o.loops[0]*0)) then N.tween(o,o,"direction",720.0,1,0,27) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",1.0,0,0,80) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",1.0,0,0,80) end
if (t == (81.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (107.0+o.loops[0]*0)) then N.tween(o,o,"speed",(3.0)+1.0*N.pm(o.run),0,0,15) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.5,0,0,15) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=224,["start"]=30,["duration"]=1800,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=200,["y"]=280,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=1,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=40,["type"]=227,["width"]=0.04,["height"]=0.04,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet50_0"}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%201==0 then o.loops[0]=o.loops[0]+1 end
if (t == (130.0+o.loops[0]*201)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (200.0+o.loops[0]*201)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%15==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*15)) then N.tween(o,o,"width",0.0,0,2,14) end
if (t == (1.0+o.loops[0]*15)) then N.tween(o,o,"height",0.0,0,2,14) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=224,["start"]=30,["duration"]=1800,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=200,["y"]=280,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=1,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=40,["type"]=227,["width"]=0.04,["height"]=0.04,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet50_0"}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%201==0 then o.loops[0]=o.loops[0]+1 end
if (t == (130.0+o.loops[0]*201)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (200.0+o.loops[0]*201)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%15==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*15)) then N.tween(o,o,"width",0.0,0,2,14) end
if (t == (1.0+o.loops[0]*15)) then N.tween(o,o,"height",0.0,0,2,14) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=224,["start"]=30,["duration"]=1800,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=200,["y"]=280,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=360,["p.speed"]=1,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=40,["type"]=227,["width"]=0.04,["height"]=0.04,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]="bullet50_0"}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%201==0 then o.loops[0]=o.loops[0]+1 end
if (t == (130.0+o.loops[0]*201)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (200.0+o.loops[0]*201)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%15==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*15)) then N.tween(o,o,"width",0.0,0,2,14) end
if (t == (1.0+o.loops[0]*15)) then N.tween(o,o,"height",0.0,0,2,14) end
end
return T
