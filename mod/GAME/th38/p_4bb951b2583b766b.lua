-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=20000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=99,["duration"]=700,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=20,["radius_angle"]=0,["ways"]=60,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=124,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%400==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",3.0,1,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.2,2,0,10) end
if (t == (11.0+o.loops[0]*400)) then N.tween(o,o,"cycle",999.0,0,0,1) end
if (t == (100.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.0,0,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.2,0,0,80) end
if (t == (81.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,1,0,140) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=299,["duration"]=700,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=20,["radius_angle"]=0,["ways"]=60,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=124,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%400==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",3.0,2,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.2,2,0,10) end
if (t == (11.0+o.loops[0]*400)) then N.tween(o,o,"cycle",999.0,0,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.0,0,0,1) end
if (t == (100.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.2,0,0,80) end
if (t == (81.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,1,0,140) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=49,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=100,["green"]=255,["blue"]=100,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[3].events=nil
T.emitters[3].p.events=nil
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1099,["duration"]=700,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=20,["radius_angle"]=0,["ways"]=60,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=124,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%400==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",3.0,2,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.2,2,0,10) end
if (t == (11.0+o.loops[0]*400)) then N.tween(o,o,"cycle",999.0,0,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.0,0,0,1) end
if (t == (100.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,0,1) end
end
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.2,0,0,80) end
if (t == (81.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,1,0,140) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=899,["duration"]=700,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=20,["radius_angle"]=0,["ways"]=60,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=124,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%400==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",3.0,1,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.2,2,0,10) end
if (t == (11.0+o.loops[0]*400)) then N.tween(o,o,"cycle",999.0,0,0,1) end
if (t == (100.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.0,0,0,1) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.2,0,0,80) end
if (t == (81.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,1,0,140) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1899,["duration"]=700,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=20,["radius_angle"]=0,["ways"]=60,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=124,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[6].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%400==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",3.0,2,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.2,2,0,10) end
if (t == (11.0+o.loops[0]*400)) then N.tween(o,o,"cycle",999.0,0,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.0,0,0,1) end
if (t == (100.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,0,1) end
end
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.2,0,0,80) end
if (t == (81.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,1,0,140) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1699,["duration"]=700,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=20,["radius_angle"]=0,["ways"]=60,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=124,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[7].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%400==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",3.0,1,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.2,2,0,10) end
if (t == (11.0+o.loops[0]*400)) then N.tween(o,o,"cycle",999.0,0,0,1) end
if (t == (100.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.0,0,0,1) end
end
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.2,0,0,80) end
if (t == (81.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,1,0,140) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=2499,["duration"]=700,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=20,["radius_angle"]=0,["ways"]=60,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=124,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%400==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",3.0,1,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.2,2,0,10) end
if (t == (11.0+o.loops[0]*400)) then N.tween(o,o,"cycle",999.0,0,0,1) end
if (t == (100.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.0,0,0,1) end
end
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.2,0,0,80) end
if (t == (81.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,1,0,140) end
end
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=2699,["duration"]=700,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=20,["radius_angle"]=0,["ways"]=60,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=124,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[9].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%400==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",3.0,2,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.2,2,0,10) end
if (t == (11.0+o.loops[0]*400)) then N.tween(o,o,"cycle",999.0,0,0,1) end
if (t == (2.0+o.loops[0]*400)) then N.tween(o,o,"cycle",1.0,0,0,1) end
if (t == (1.0+o.loops[0]*400)) then N.tween(o,o.p,"speed",6.0,0,0,1) end
if (t == (100.0+o.loops[0]*400)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,0,1) end
end
T.emitters[9].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.2,0,0,80) end
if (t == (81.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.5,1,0,140) end
end
return T
