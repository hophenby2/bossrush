-- 夏夜祭原始参数；由离线工具编译，运行时没有MBG读取或中文指令分派。
local T={total=4000,emitters={}}
T.emitters[1]={["id"]=0,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=256,["start"]=50,["duration"]=100,["mode"]="bullet",["fx"]=316,["fy"]=240,["radius"]=0,["radius_angle"]=0,["ways"]=20,["cycle"]=11,["emit_angle"]=270,["spread"]=1,["speed"]=0,["direction"]=180,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2300,["type"]=0,["width"]=2,["height"]=2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=32,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=125,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[1].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"scale_y",-1.0,0,0,100) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (130.0+o.loops[1]*0)) then N.tween(o,o,"direction",0.6,2,0,2000) end
if (t == (130.0+o.loops[1]*0)) then N.tween(o,o,"speed",1.0,0,2,630) end
if (t == (1000.0+o.loops[1]*0)) then N.tween(o,o,"speed",1.0,1,2,500) end
if (t == (1500.0+o.loops[1]*0)) then N.tween(o,o,"speed",1.0,1,2,500) end
end
T.emitters[1].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (13.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.001,0,1,1) end
if (t == (13.0+o.loops[0]*0)) then N.tween(o,o,"scale_x",1.0,0,1,1) end
if (t == (13.0+o.loops[0]*0)) then N.tween(o,o,"scale_y",1.0,0,1,1) end
end
T.emitters[2]={["id"]=1,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=288,["start"]=55,["duration"]=100,["mode"]="bullet",["fx"]=316,["fy"]=240,["radius"]=0,["radius_angle"]=0,["ways"]=20,["cycle"]=11,["emit_angle"]=0,["spread"]=1,["speed"]=0,["direction"]=90,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2300,["type"]=0,["width"]=2,["height"]=2,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=51,["angle"]=180,["follow"]=true,["speed"]=32,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=125,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[2].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o.p,"scale_x",-1.0,0,0,100) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (130.0+o.loops[1]*0)) then N.tween(o,o,"direction",0.5,1,0,2000) end
if (t == (130.0+o.loops[1]*0)) then N.tween(o,o,"speed",-1.0,0,2,670) end
if (t == (1000.0+o.loops[1]*0)) then N.tween(o,o,"speed",1.0,2,2,500) end
if (t == (1500.0+o.loops[1]*0)) then N.tween(o,o,"speed",1.0,2,2,500) end
end
T.emitters[2].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (13.0+o.loops[0]*0)) then N.tween(o,o,"speed",0.001,0,1,1) end
if (t == (13.0+o.loops[0]*0)) then N.tween(o,o,"scale_x",1.0,0,1,1) end
if (t == (13.0+o.loops[0]*0)) then N.tween(o,o,"scale_y",1.0,0,1,1) end
end
T.emitters[3]={["id"]=2,["layer"]=0,["bind"]=0,["with_direction"]=true,["cx"]=384,["cy"]=256,["start"]=15,["duration"]=1986,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=1,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2050,["type"]=17,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[3].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (130000.0+o.loops[1]*0)) then N.tween(o,o,"direction",0.135,2,0,1) end
end
T.emitters[3].p.events=nil
T.emitters[4]={["id"]=3,["layer"]=0,["bind"]=1,["with_direction"]=true,["cx"]=384,["cy"]=288,["start"]=15,["duration"]=1986,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=9999,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=2050,["type"]=19,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=true,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[4].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
o.loops[1]=o.loops[1] or 0
if (t)%1==0 then o.loops[1]=o.loops[1]+1 end
if (t > (130.0+o.loops[1]*0)) then N.tween(o,o,"direction",0.085,1,0,1) end
end
T.emitters[4].p.events=nil
T.emitters[5]={["id"]=4,["layer"]=0,["bind"]=2,["with_direction"]=false,["cx"]=448,["cy"]=256,["start"]=1,["duration"]=4000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=150,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=65,["type"]=221,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.001,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=false}}
T.emitters[5].events=nil
T.emitters[5].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",1.5,0,0,25) end
if (t == (35.0+o.loops[0]*0)) then N.tween(o,o,"height",0.0,0,0,30) end
if (t == (35.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0,0,0,30) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",1.5,0,0,25) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,1,0,1) end
end
T.emitters[6]={["id"]=5,["layer"]=0,["bind"]=3,["with_direction"]=false,["cx"]=448,["cy"]=288,["start"]=1,["duration"]=4000,["mode"]="bullet",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=150,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=true,["motion"]=true,["sound"]="se.wav",["specify_sound"]=true,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=149,["type"]=221,["width"]=0,["height"]=0,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=0.001,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=false}}
T.emitters[6].events=nil
T.emitters[6].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (85.0+o.loops[0]*0)) then N.tween(o,o,"height",1.5,0,0,25) end
if (t == (119.0+o.loops[0]*0)) then N.tween(o,o,"height",0.0,0,0,30) end
if (t == (119.0+o.loops[0]*0)) then N.tween(o,o,"width",0.0,0,0,30) end
if (t == (85.0+o.loops[0]*0)) then N.tween(o,o,"width",1.5,0,0,25) end
if (t > (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",2.0,2,0,1) end
end
T.emitters[7]={["id"]=6,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=320,["cy"]=128,["start"]=1,["duration"]=1,["mode"]="effect",["fx"]=-99998,["fy"]=-99998,["radius"]=0,["radius_angle"]=0,["ways"]=20,["cycle"]=1,["emit_angle"]=0,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=1,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=50,["type"]=1,["width"]=1,["height"]=1,["red"]=255,["green"]=55,["blue"]=55,["alpha"]=0,["angle"]=180,["follow"]=true,["speed"]=5,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=false,["blend"]=true,["ghost"]=false,["out"]=false,["invincible"]=true,["reflect"]=0,["region"]=0,["cover"]=false,["texture"]="QIANGWEI1"}}
T.emitters[7].events=nil
T.emitters[7].p.events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t+1)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"width",(1.2)+1.2*N.pm(o.run),0,0,10) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"height",(1.2)+1.2*N.pm(o.run),0,0,10) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"alpha",90.0,0,0,15) end
if (t == (30.0+o.loops[0]*0)) then N.tween(o,o,"alpha",0.0,0,0,20) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"angle",(0.0)+360.0*N.pm(o.run),1,0,50) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"speed",(0.0)+5.0*N.pm(o.run),0,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+360.0*N.pm(o.run),0,1,1) end
if (t == (1.0+o.loops[0]*0)) then N.tween(o,o,"direction",(0.0)+90.0*N.pm(o.run),1,0,50) end
end
T.emitters[8]={["id"]=7,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=524,["cy"]=0,["start"]=35,["duration"]=20,["mode"]="bullet",["fx"]=-99998,["fy"]=-39,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=3,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=28.3,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[8].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[8].p.events=nil
T.emitters[9]={["id"]=8,["layer"]=0,["bind"]=-1,["with_direction"]=false,["cx"]=510,["cy"]=0,["start"]=35,["duration"]=20,["mode"]="bullet",["fx"]=-99998,["fy"]=-39,["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=3,["emit_angle"]=180,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["sound"]="",["specify_sound"]=false,["count"]=1,["delta_v"]=0,["radius_follows"]=false,["effect"]=0,["random"]={["x"]=0,["y"]=0,["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=200,["type"]=0,["width"]=1,["height"]=1,["red"]=255,["green"]=255,["blue"]=255,["alpha"]=255,["angle"]=180,["follow"]=true,["speed"]=28.3,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=false,["ghost"]=false,["out"]=true,["invincible"]=false,["reflect"]=0,["region"]=0,["cover"]=true}}
T.emitters[9].events=function(o,t,N)
o.loops[0]=o.loops[0] or 0
if (t)%1==0 then o.loops[0]=o.loops[0]+1 end
if (t == (1.0+o.loops[0]*0)) then N.emit(o) end
end
T.emitters[9].p.events=nil
T.emitters[10]={["id"]=0,["layer"]=0,["bind"]=7,["with_direction"]=true,["cx"]=248,["cy"]=79,["start"]=35,["duration"]=20,["mode"]="ray",["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=20,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=55,["type"]=0,["width"]=2.34375,["height"]=0.2,["length"]=600,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.34375,["max_height"]=1}}
T.emitters[10].events=nil
T.emitters[10].p.events=nil
T.emitters[11]={["id"]=1,["layer"]=0,["bind"]=8,["with_direction"]=false,["cx"]=280,["cy"]=79,["start"]=35,["duration"]=20,["mode"]="ray",["radius"]=0,["radius_angle"]=0,["ways"]=1,["cycle"]=20,["emit_angle"]=90,["spread"]=360,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["deep"]=false,["motion"]=false,["head"]=false,["random"]={["radius"]=0,["radius_angle"]=0,["ways"]=0,["cycle"]=0,["emit_angle"]=0,["spread"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["p.speed"]=0,["p.direction"]=0,["p.accel"]=0,["p.accel_angle"]=0},["p"]={["life"]=55,["type"]=2,["width"]=2.34375,["height"]=0.2,["length"]=600,["alpha"]=255,["angle"]=0,["speed"]=0,["direction"]=0,["accel"]=0,["accel_angle"]=0,["scale_x"]=1,["scale_y"]=1,["mist"]=false,["dispel"]=true,["blend"]=true,["ghost"]=false,["out"]=true,["invincible"]=false,["red"]=255,["green"]=255,["blue"]=255,["reflect"]=0,["max_width"]=2.34375,["max_height"]=1}}
T.emitters[11].events=nil
T.emitters[11].p.events=nil
return T
