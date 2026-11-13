-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=1550,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=50,["duration"]=150,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=6,["cycle"]=1,["emit_angle"]=345,["spread"]=60,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=30,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=2,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=5,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=102,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0.05,["accel_angle"]=175,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=nil
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,30) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"type",(0.0)+1.0*N.pm(o.run),1,0,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=96,["start"]=1,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=100,["green"]=255,["blue"]=100,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[2].events=nil
T.emitters[2].p.events=nil
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=200,["duration"]=150,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=4,["cycle"]=1,["emit_angle"]=195,["spread"]=60,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=30,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=2,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=5,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=63,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0.05,["accel_angle"]=5,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=nil
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",255.0,0,0,30) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"blend",0.0,0,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"type",(0.0)+1.0*N.pm(o.run),1,0,1) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=112,["cy"]=184,["start"]=300,["duration"]=150,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=15,["spread"]=30,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=200,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=2,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=2.3,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=175,["type"]=17,["width"]=0.3,["height"]=0.3,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=2.6,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=15,["cover"]=true}}
T.emitters[4].events=nil
T.emitters[4].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (2.0+o.loops[0]*0)) then N.tween(o,o,"direction",30.0,2,0,90) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.0,0,0,160) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.0)+0.25*N.pm(o.run),1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+5.0*N.pm(o.run),1,0,1) end
end
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=3,["with_direction"]=true,["cx"]=224,["cy"]=128,["start"]=1,["duration"]=1550,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=8,["radius_angle"]=15,["ways"]=12,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=460,["type"]=36,["width"]=0.7,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",3.0,1,0,1) end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"type",(0.0)+3.0*N.pm(o.run),1,0,1) end
if (t == (175.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.8)+0.4*N.pm(o.run),1,0,150) end
if (t == (175.0+o.loops[0]*0)) then N.tween(o,o,"width",1.0,0,0,90) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=96,["start"]=280,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=100,["blue"]=100,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[6].events=nil
T.emitters[6].p.events=nil
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=96,["start"]=700,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=100,["green"]=200,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[7].events=nil
T.emitters[7].p.events=nil
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=4,["with_direction"]=false,["cx"]=224,["cy"]=64,["start"]=1,["duration"]=1550,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=700,["type"]=3,["width"]=0.3,["height"]=0.5,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=9,["cover"]=true}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (460.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+5.0*N.pm(o.run),1,0,300) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.5)+0.3*N.pm(o.run),1,0,300) end
end
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=96,["start"]=1000,["duration"]=5,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[9].events=nil
T.emitters[9].p.events=nil
T.emitters[10]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1050,["duration"]=380,["mode"]="ray",["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=270,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=120,["type"]=7,["width"]=3.90625,["height"]=0.2,["length"]=1000,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=3.90625,["max_height"]=1}}
T.emitters[10].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",6.76,1,0,1) end
end
T.emitters[10].p.events=nil
return T
