-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=9999,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=75,["duration"]=800,["mode"]="effect",["fx"]=316,["fy"]=134,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=180,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.25,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=150,["type"]=227,["width"]=0,["height"]=0,["red"]=255,["green"]=125,["blue"]=255,["alpha"]=2,["angle"]=180,["follow"]=true,["speed"]=0.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=false,["texture"]="bullet50_7"}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"height",4.0,0,0,1000) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"width",4.0,0,0,1000,o.p.height) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",1.0,1,0,1) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(5.0)+2.0*N.pm(o.run),0,0,300) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",(12.0)+6.0*N.pm(o.run),1,0,100) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=160,["cy"]=192,["start"]=100,["duration"]=800,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=121,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.15,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%200==0 then o.loops[0]=o.loops[0]+1 end
if (t == (150.0+o.loops[0]*200)) then N.tween(o,o,"cycle",10.0,0,1,1) end
if (t == (1.0+o.loops[0]*200)) then N.tween(o,o,"cycle",99999.0,0,1,1) end
if (t == (150.0+o.loops[0]*200)) then N.tween(o,o.p,"speed",2.0,0,0,50) end
if (t == (1.0+o.loops[0]*200)) then N.tween(o,o.p,"speed",1.15,0,1,1) end
o.loops[1]=o.loops[1] or 0
if (t)%100==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*100)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,1,1) end
o.loops[2]=o.loops[2] or 0
if (t)%1==0 then o.loops[2]=o.loops[2]+1 end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",140.0,2,0,400) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=192,["cy"]=160,["start"]=100,["duration"]=800,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=121,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.15,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%200==0 then o.loops[0]=o.loops[0]+1 end
if (t == (50.0+o.loops[0]*200)) then N.tween(o,o,"cycle",10.0,0,1,1) end
if (t == (100.0+o.loops[0]*200)) then N.tween(o,o,"cycle",99999.0,0,1,1) end
if (t == (50.0+o.loops[0]*200)) then N.tween(o,o.p,"speed",2.0,0,0,50) end
if (t == (100.0+o.loops[0]*200)) then N.tween(o,o.p,"speed",1.15,0,1,1) end
o.loops[1]=o.loops[1] or 0
if (t)%100==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*100)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,1,1) end
end
T.emitters[3].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",140.0,1,0,400) end
end
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=160,["cy"]=352,["start"]=100,["duration"]=800,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=35,["radius_angle"]=0,["ways"]=8,["cycle"]=50,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=50,["y"]=50,["radius"]=10,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=350,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.2,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=18,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.35,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=nil
T.emitters[4].p.events=nil
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=192,["start"]=30,["duration"]=1,["mode"]="effect",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=155,["green"]=55,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[5].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[5].p.events=nil
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=160,["cy"]=256,["start"]=1,["duration"]=1,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=1,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=174,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[6].events=nil
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"speed",6.0,0,0,100) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=192,["cy"]=256,["start"]=1,["duration"]=1,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=1,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=174,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[7].events=nil
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"speed",5.0,0,0,100) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=224,["cy"]=256,["start"]=1,["duration"]=1,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=1,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=174,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[8].events=nil
T.emitters[8].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"speed",4.0,0,0,100) end
end
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=256,["cy"]=256,["start"]=1,["duration"]=1,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=1,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=174,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[9].events=nil
T.emitters[9].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,0,0,100) end
end
T.emitters[10]={["id"]=9,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=288,["cy"]=256,["start"]=1,["duration"]=1,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=1,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=174,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[10].events=nil
T.emitters[10].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"speed",3.0,0,0,100) end
end
T.emitters[11]={["id"]=10,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=256,["start"]=1,["duration"]=1,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=1,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=174,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[11].events=nil
T.emitters[11].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"speed",2.0,0,0,100) end
end
T.emitters[12]={["id"]=11,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=352,["cy"]=256,["start"]=1,["duration"]=1,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=1,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=174,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[12].events=nil
T.emitters[12].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (75.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,0,0,100) end
end
T.emitters[13]={["id"]=12,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=128,["cy"]=128,["start"]=950,["duration"]=850,["mode"]="effect",["fx"]=316,["fy"]=134,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=180,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.25,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=150,["type"]=227,["width"]=0,["height"]=0,["red"]=255,["green"]=125,["blue"]=255,["alpha"]=2,["angle"]=180,["follow"]=true,["speed"]=0.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=false,["texture"]="bullet50_7"}}
T.emitters[13].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"height",4.0,0,0,1000) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"width",4.0,0,0,1000,o.p.height) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",1.0,1,0,1) end
end
T.emitters[13].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(5.0)+2.0*N.pm(o.run),0,0,300) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",(12.0)+6.0*N.pm(o.run),1,0,100) end
end
T.emitters[14]={["id"]=13,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=160,["start"]=950,["duration"]=850,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=25,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=121,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.15,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[14].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%100==0 then o.loops[0]=o.loops[0]+1 end
if (t == (50.0+o.loops[0]*100)) then N.tween(o,o,"cycle",10.0,0,1,1) end
if (t == (1.0+o.loops[0]*100)) then N.tween(o,o,"cycle",99999.0,0,1,1) end
if (t == (50.0+o.loops[0]*100)) then N.tween(o,o.p,"speed",2.0,0,0,50) end
if (t == (1.0+o.loops[0]*100)) then N.tween(o,o.p,"speed",1.15,0,1,1) end
o.loops[1]=o.loops[1] or 0
if (t)%100==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*100)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,1,1) end
o.loops[2]=o.loops[2] or 0
if (t)%1==0 then o.loops[2]=o.loops[2]+1 end
end
T.emitters[14].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",140.0,2,0,400) end
end
T.emitters[15]={["id"]=14,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=192,["start"]=950,["duration"]=850,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=25,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=121,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.15,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[15].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%100==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*100)) then N.tween(o,o,"cycle",10.0,0,1,1) end
if (t == (50.0+o.loops[0]*100)) then N.tween(o,o,"cycle",99999.0,0,1,1) end
if (t == (1.0+o.loops[0]*100)) then N.tween(o,o.p,"speed",2.0,0,0,50) end
if (t == (50.0+o.loops[0]*100)) then N.tween(o,o.p,"speed",1.15,0,1,1) end
o.loops[1]=o.loops[1] or 0
if (t)%100==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*100)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,1,1) end
end
T.emitters[15].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",140.0,1,0,400) end
end
T.emitters[16]={["id"]=15,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=128,["cy"]=288,["start"]=950,["duration"]=850,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=35,["radius_angle"]=0,["ways"]=8,["cycle"]=50,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=60,["y"]=60,["radius"]=10,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=350,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.2,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=18,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.35,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[16].events=nil
T.emitters[16].p.events=nil
T.emitters[17]={["id"]=16,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=288,["cy"]=128,["start"]=1900,["duration"]=8100,["mode"]="effect",["fx"]=316,["fy"]=134,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=2,["emit_angle"]=180,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.25,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=150,["type"]=227,["width"]=0,["height"]=0,["red"]=255,["green"]=125,["blue"]=255,["alpha"]=2,["angle"]=180,["follow"]=true,["speed"]=0.25,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=false,["texture"]="bullet50_7"}}
T.emitters[17].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"height",4.0,0,0,1000) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"width",4.0,0,0,1000,o.p.height) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"emit_angle",1.0,1,0,1) end
end
T.emitters[17].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",(4.0)+1.0*N.pm(o.run),0,0,100) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",1.0,0,0,300) end
if (t == (100.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,50) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",(10.0)+4.0*N.pm(o.run),1,0,100) end
end
T.emitters[18]={["id"]=17,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=128,["cy"]=192,["start"]=1900,["duration"]=8001,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=36,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=121,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.175,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[18].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%100==0 then o.loops[0]=o.loops[0]+1 end
if (t == (50.0+o.loops[0]*100)) then N.tween(o,o,"cycle",10.0,0,1,1) end
if (t == (1.0+o.loops[0]*100)) then N.tween(o,o,"cycle",99999.0,0,1,1) end
if (t == (50.0+o.loops[0]*100)) then N.tween(o,o.p,"speed",2.0,0,0,50) end
if (t == (1.0+o.loops[0]*100)) then N.tween(o,o.p,"speed",1.175,0,1,1) end
o.loops[1]=o.loops[1] or 0
if (t)%100==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*100)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,1,1) end
o.loops[2]=o.loops[2] or 0
if (t)%1==0 then o.loops[2]=o.loops[2]+1 end
end
T.emitters[18].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",140.0,2,0,400) end
end
T.emitters[19]={["id"]=18,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=160,["cy"]=192,["start"]=1900,["duration"]=8100,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=32,["cycle"]=9999,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=121,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=1.175,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[19].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%100==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*100)) then N.tween(o,o,"cycle",10.0,0,1,1) end
if (t == (50.0+o.loops[0]*100)) then N.tween(o,o,"cycle",99999.0,0,1,1) end
if (t == (1.0+o.loops[0]*100)) then N.tween(o,o.p,"speed",2.0,0,0,50) end
if (t == (50.0+o.loops[0]*100)) then N.tween(o,o.p,"speed",1.175,0,1,1) end
o.loops[1]=o.loops[1] or 0
if (t)%100==0 then o.loops[1]=o.loops[1]+1 end
if (t == (1.0+o.loops[1]*100)) then N.tween(o,o,"emit_angle",(0.0)+360.0*N.pm(o.run),0,1,1) end
end
T.emitters[19].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",140.0,1,0,400) end
end
T.emitters[20]={["id"]=19,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=160,["cy"]=224,["start"]=1900,["duration"]=1,["mode"]="effect",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=2,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=1,["width"]=1,["height"]=1,["red"]=155,["green"]=70,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true,["texture"]=""}}
T.emitters[20].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[20].p.events=nil
T.emitters[21]={["id"]=20,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=128,["cy"]=224,["start"]=1900,["duration"]=8100,["mode"]="bullet",["fx"]=316,["fy"]=144,["radius"]=0,["radius_angle"]=0,["ways"]=10,["cycle"]=75,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=true,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=360,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0.5,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2000,["type"]=226,["width"]=0.8,["height"]=0.8,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=191,["angle"]=180,["follow"]=true,["speed"]=2.5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[21].events=nil
T.emitters[21].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(1.25)+0.35*N.pm(o.run),0,0,100) end
end
return T
