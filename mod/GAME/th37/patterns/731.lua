-- 离线展开：b731.xna；事件均已编译为Lua条件和调用。
return {id="731",total=1200,centerAvailable=true,center={315,140,0,0,0,0},centerEvents=function(o,t,R)
if t==(1) then R.move(o,315,315,140,140) end
if t==(180) then R.move(o,280,350,80,90) end
end,globalEvents=function(c,t,R)
if t==360 then R.jump(c,2,0,120) end
end,types={{0,0,90,127,45,63,20,0},{91,0,90,127,45,63,20,0},{182,0,90,127,45,63,20,0},{270,0,26,45,12,22,4,0},{296,0,36,46,18,23,4,0},{332,0,39,51,19,25,5,0},{371,0,21,31,10,15,2,0},{0,127,257,256,128,128,40,0},{257,127,257,256,128,128,40,0},{263,383,89,81,44,40,1,0},{185,383,78,136,39,68,1,0},{0,383,185,157,82,78,1,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=160,["y"]=160,["begin"]=61,["life"]=1140,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=3,["fdirection"]=210,["fdirections"]={0.0,0.0},["range"]=50,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=210,["type"]=226,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=55,["colorG"]=55,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=53,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",59) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",59) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.3,0,0,"正比",210) end
if t==(121) then R.change(o,"hscale",2.0,0,0,"正比",90) end
if t==(1) then R.change(o,"sonaspeed",0.063,0,0,"正比",62) end
if t==(41) then R.change(o,"alpha",90.0,0,0,"正比",60) end
if t==(133) then R.change(o,"sonaspeed",0.0,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=177,["begin"]=61,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=0,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.66,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/180)*180) then R.change(o,"head",360.0,0,1,"正比",180) end
if t==(1+math.floor(t/180)*180) then R.change(o,"sonspeedd",360.0,0,2,"正比",180) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=31,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=237,["wscale"]=1.5,["hscale"]=0.1,["colorR"]=1,["colorG"]=1,["colorB"]=255,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.4,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/180)*180) then R.change(o,"sonspeedd",360.0,0,1,"正比",180) end
if t==(1+math.floor(t/240)*240) then R.change(o,"alpha",10.0,0,0,"正弦",239) end
if t==(1+math.floor(t/240)*240) then R.change(o,"head",120.0,0,2,"正比",240) end
if t==(1) then R.change(o,"wscale",2.0,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",2.0,0,0,"正比",30) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=160,["y"]=192,["begin"]=61,["life"]=1140,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=3,["fdirection"]=330,["fdirections"]={0.0,0.0},["range"]=50,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=210,["type"]=226,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=55,["colorG"]=55,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=127,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",59) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",59) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.3,0,0,"正比",210) end
if t==(121) then R.change(o,"hscale",2.0,0,0,"正比",90) end
if t==(1) then R.change(o,"sonaspeed",0.063,0,0,"正比",62) end
if t==(41) then R.change(o,"alpha",90.0,0,0,"正比",60) end
if t==(133) then R.change(o,"sonaspeed",0.0,0,0,"正比",60) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=64,["begin"]=160,["life"]=960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=11,["wscale"]=1,["hscale"]=1,["colorR"]=215,["colorG"]=215,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=14,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0.0,20.0,1,"正弦",280) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=133,["begin"]=61,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=228,["wscale"]=0.1,["hscale"]=5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.5,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/180)*180) then R.change(o,"sonspeedd",360.0,0,1,"正比",180) end
if t==(1) then R.change(o,"wscale",5.0,0,0,"正比",15) end
if t==(180) then R.change(o,"sonspeed",1.0,0,0,"正比",1200) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=133,["begin"]=61,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=176,["wscale"]=0.1,["hscale"]=3,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=50,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.5,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/180)*180) then R.change(o,"sonspeedd",360.0,0,1,"正比",180) end
if t==(1) then R.change(o,"wscale",3.0,0,0,"正比",15) end
if t==(180) then R.change(o,"sonspeed",1.0,0,0,"正比",1200) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=9,["Bindwithspeedd"]=false,["x"]=160,["y"]=224,["begin"]=120,["life"]=1081,["fx"]=-99998,["fy"]=-99998,["r"]=100,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=170,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=25,["type"]=226,["wscale"]=0.2,["hscale"]=0.4,["colorR"]=125,["colorG"]=65,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.2,["yscale"]=1.2,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.6,0,0,"正比",59) end
if t==(1) then R.change(o,"sonspeed",3.0,0,0,"正比",100) end
if t==(1) then R.change(o,"hscale",0.6,0,0,"正比",59) end
if t==(30) then R.change(o,"fdirection",5.0,0,1,"正弦",29) end
if t==(1) then R.change(o,"fdirection",5.0,0,1,"正弦",29) end
if t==(180) then R.change(o,"fdirection",5.0,0,1,"正弦",29) end
if t==(60) then R.change(o,"fdirection",5.0,0,1,"正弦",29) end
if t==(90) then R.change(o,"fdirection",5.0,0,1,"正弦",29) end
if t==(120) then R.change(o,"fdirection",5.0,0,1,"正弦",29) end
if t==(240) then R.change(o,"fdirection",5.0,0,1,"正弦",29) end
if t==(150) then R.change(o,"fdirection",5.0,0,1,"正弦",29) end
if t==(210) then R.change(o,"fdirection",5.0,0,1,"正弦",29) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.2,0,0,"正比",25) end
if t==(1) then R.change(o,"hscale",0.4,0,0,"正比",25) end
if t==(1) then R.change(o,"alpha",90.0,0,0,"正比",20) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=133,["begin"]=61,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=176,["wscale"]=0.1,["hscale"]=2.5,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.5,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/180)*180) then R.change(o,"sonspeedd",360.0,0,1,"正比",180) end
if t==(1) then R.change(o,"wscale",2.5,0,0,"正比",15) end
if t==(180) then R.change(o,"sonspeed",1.0,0,0,"正比",1200) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=133,["begin"]=61,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.5,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/180)*180) then R.change(o,"sonspeedd",360.0,0,1,"正比",180) end
if t==(180) then R.change(o,"sonspeed",1.0,0,0,"正比",1200) end
if t==(2+math.floor(t/180)*180) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(4+math.floor(t/180)*180) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(176+math.floor(t/180)*180) then R.change(o,"type",1.0,0,2,"正比",1) end
if t==(178+math.floor(t/180)*180) then R.change(o,"type",1.0,0,2,"正比",1) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=192,["y"]=160,["begin"]=61,["life"]=1140,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=12,["fdirection"]=210,["fdirections"]={0.0,0.0},["range"]=50,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=210,["type"]=200,["wscale"]=0.2,["hscale"]=0.3,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=53,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",59) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",59) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.2,0,0,"正比",210) end
if t==(121) then R.change(o,"hscale",2.0,0,0,"正比",90) end
if t==(1) then R.change(o,"sonaspeed",0.063,0,0,"正比",62) end
if t==(133) then R.change(o,"sonaspeed",0.0,0,0,"正比",60) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=192,["y"]=192,["begin"]=61,["life"]=1140,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=12,["fdirection"]=330,["fdirections"]={0.0,0.0},["range"]=50,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=210,["type"]=200,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=127,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.0,0,0,"正比",59) end
if t==(1) then R.change(o,"hscale",1.0,0,0,"正比",59) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.2,0,0,"正比",210) end
if t==(121) then R.change(o,"hscale",2.0,0,0,"正比",90) end
if t==(1) then R.change(o,"sonaspeed",0.063,0,0,"正比",62) end
if t==(133) then R.change(o,"sonaspeed",0.0,0,0,"正比",60) end
end},
{["id"]=12,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=64,["begin"]=160,["life"]=960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=11,["wscale"]=1,["hscale"]=1,["colorR"]=215,["colorG"]=215,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=14,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0.0,20.0,1,"正弦",280) end
end},
{["id"]=0,["parentid"]=0,["x"]=320,["y"]=448,["begin"]=1,["life"]=1200,["halfw"]=500,["halfh"]=100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"Outdispel",1.0,0,0,"固定",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=128,["begin"]=120,["life"]=240,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=18,["t"]=10,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=240,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=400,["type"]=58,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",20.0,0,1,"正弦",239) end
end,Sonevents=function(o,t,R)

end}
}}
