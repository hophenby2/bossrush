-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=540,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=1,["duration"]=60,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=210,["radius_angle"]=270,["ways"]=9,["cycle"]=3,["emit_angle"]=250,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=55,["type"]=68,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=1,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=true,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (0.0+o.loops[0]*0)) then N.tween(o,o,"radius_angle",21.0,1,0,1) end
if (t > (0.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",21.0,1,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",5.0,0,0,30) end
if (t > (2.0+o.loops[0]*0)) then N.tween(o,o,"angle",6.0,1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"type",(0.0)+3.0*N.pm(o.run),1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",180.0,1,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=192,["start"]=1,["duration"]=210,["mode"]="bullet",["fx"]=315,["fy"]=160,["radius"]=0,["radius_angle"]=0,["ways"]=9,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=2,["delta_v"]=1.6,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=720,["type"]=68,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (115.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t == (123.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",0.2,0,0,60) end
if (t == (123.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",180.0,1,0,58) end
if (t == (183.0+o.loops[0]*0)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",17.0,2,0,1) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",6.0,1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,0,0,120) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"type",(0.0)+3.0*N.pm(o.run),1,0,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=352,["cy"]=192,["start"]=1,["duration"]=210,["mode"]="bullet",["fx"]=315,["fy"]=160,["radius"]=0,["radius_angle"]=0,["ways"]=9,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=2,["delta_v"]=1.6,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=720,["type"]=68,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=false,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (115.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t == (123.0+o.loops[0]*0)) then N.tween(o,o.p,"speed",0.2,0,0,60) end
if (t == (123.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",180.0,2,0,58) end
if (t == (183.0+o.loops[0]*0)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
if (t == (120.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",17.0,1,0,1) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",6.0,1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,0,0,120) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"type",(0.0)+3.0*N.pm(o.run),1,0,1) end
end
T.emitters[4]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=1,["duration"]=420,["mode"]="ray",["radius"]=0,["radius_angle"]=0,["ways"]=2,["cycle"]=9999,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=180,["type"]=2,["width"]=2.734375,["height"]=0.2,["length"]=700,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.734375,["max_height"]=1}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (44.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",N.aim(o),0,0,1) end
if (t == (45.0+o.loops[0]*0)) then N.tween(o,o,"cycle",2.0,0,0,1) end
if (t > (48.0+o.loops[0]*0)) then N.tween(o,o,"spread",330.0,1,0,720) end
if (t == (44.0+o.loops[0]*0)) then N.tween(o,o,"spread",0.0,0,0,1) end
if (t == (105.0+o.loops[0]*0)) then N.tween(o,o,"cycle",9999.0,0,0,1) end
end
T.emitters[4].p.events=nil
T.emitters[5]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=210,["duration"]=270,["mode"]="laser",["radius"]=0,["radius_angle"]=0,["ways"]=35,["cycle"]=30,["emit_angle"]=-99999,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=true,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=360,["type"]=5,["width"]=1,["height"]=1,["length"]=30,["alpha"]=255,["angle"]=0,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0}}
T.emitters[5].events=nil
T.emitters[5].p.events=nil
return T
