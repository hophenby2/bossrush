-- 离线展开：b587.xna；事件均已编译为Lua条件和调用。
return {id="587",total=6000,centerAvailable=false,center={315,240,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,200,200,100,100,0,1},{200,0,200,200,100,100,0,1},{400,0,200,200,100,100,0,1},{0,200,30,30,15,15,5,0},{30,200,30,30,15,15,5,0},{600,0,200,200,100,100,0,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=64,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1125,["type"]=229,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(15+math.floor(t/90)*90) then R.change(o,"alpha",90.0,0,0,"正比",30) end
if t==(1100) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
if t==(269+math.floor(t/270)*270) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=620,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=30,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=225,["wscale"]=12,["hscale"]=12,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=100,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",9.0,0,0,"正比",60) end
if t==(61) then R.change(o,"alpha",1.0,0,0,"正比",60) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=64,["y"]=448,["begin"]=1,["life"]=5000,["fx"]=-99998,["fy"]=-99998,["r"]=45,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=560,["type"]=229,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(35+math.floor(t/90)*90) then R.change(o,"alpha",100.0,0,0,"正比",10) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(15+math.floor(t/90)*90) then R.change(o,"alpha",90.0,0,0,"正比",30) end
if t==(1100) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=0,["begin"]=1,["life"]=5000,["fx"]=-99998,["fy"]=-99998,["r"]=45,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=560,["type"]=229,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=true,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(35+math.floor(t/90)*90) then R.change(o,"alpha",100.0,0,0,"正比",10) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(15+math.floor(t/90)*90) then R.change(o,"alpha",90.0,0,0,"正比",30) end
if t==(1100) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=265,["y"]=272,["begin"]=270,["life"]=360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4200,["type"]=229,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(15+math.floor(t/90)*90) then R.change(o,"alpha",90.0,0,0,"正比",30) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
if t==(79+math.floor(t/90)*90) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=192,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=1,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",233.0,0,0,"正比",1) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=64,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=3510,["type"]=234,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(2790) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(630) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(540) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1080) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1530) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1620) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2070) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2160) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2340) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2520) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2700) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2790) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(360) then R.change(o,"alpha",70.0,0,0,"正比",61) end
if t==(1370) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1170) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1260) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(270) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(810) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(900) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(990) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(1800) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(1890) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(2430) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(2970) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(3510) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3060) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(3240) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3330) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3420) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=160,["begin"]=3600,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=225,["wscale"]=21,["hscale"]=21,["colorR"]=255,["colorG"]=155,["colorB"]=55,["alpha"]=36,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=224,["begin"]=3600,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=3510,["type"]=234,["wscale"]=1.05,["hscale"]=1.05,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=71,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/240)*240) then R.change(o,"alpha",15.0,0,1,"正弦",239) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=64,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1125,["type"]=229,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(15+math.floor(t/90)*90) then R.change(o,"alpha",90.0,0,0,"正比",30) end
if t==(1100) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"type",1.0,2.0,1,"正比",1) end
if t==(269+math.floor(t/270)*270) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=256,["begin"]=758,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=224,["wscale"]=30,["hscale"]=30,["colorR"]=255,["colorG"]=155,["colorB"]=15,["alpha"]=18,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=0,["x"]=320,["y"]=224,["begin"]=3500,["life"]=100,["halfw"]=100,["halfh"]=100,["Circle"]=false,["type"]=1,["controlid"]=5,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(3600) then R.change(o,"life",0.0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=64,["begin"]=1,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=3510,["type"]=234,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(15+math.floor(t/90)*90) then R.change(o,"alpha",90.0,0,0,"正比",30) end
if t==(2790) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(630) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(540) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1080) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1530) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1620) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2070) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2160) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2340) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2520) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2700) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2790) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(270) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1370) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1170) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1260) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(810) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(900) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(990) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(1800) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(1890) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(2430) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(2970) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(3510) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3060) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(3240) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3330) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3420) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=192,["begin"]=1,["life"]=761,["fx"]=-99998,["fy"]=-99998,["r"]=750,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=12,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=7,["wscale"]=2,["hscale"]=20,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",720.0,0,1,"正比",1200) end
if t==(700) then R.change(o,"hscale",0.1,0,0,"正比",60) end
if t==(1) then R.change(o,"rdirection",720.0,0,1,"正比",1200) end
if t==(1) then R.change(o,"r",185.0,0,0,"正比",580) end
if t==(700) then R.change(o,"r",60.0,0,0,"正比",60) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=384,["y"]=224,["begin"]=1,["life"]=761,["fx"]=-99998,["fy"]=-99998,["r"]=750,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=12,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=7,["wscale"]=2,["hscale"]=20,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",720.0,0,2,"正比",1200) end
if t==(700) then R.change(o,"hscale",0.1,0,0,"正比",60) end
if t==(1) then R.change(o,"rdirection",720.0,0,2,"正比",1200) end
if t==(1) then R.change(o,"r",185.0,0,0,"正比",580) end
if t==(700) then R.change(o,"r",60.0,0,0,"正比",60) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=5,["Bindwithspeedd"]=false,["x"]=384,["y"]=288,["begin"]=1,["life"]=5000,["fx"]=-99998,["fy"]=-99998,["r"]=124,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=4,["t"]=10,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=3,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=384,["y"]=96,["begin"]=762,["life"]=4338,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=24,["t"]=10,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=271,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=200,["wscale"]=1,["hscale"]=1,["colorR"]=0,["colorG"]=0,["colorB"]=0,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=20,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(0) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(1) then R.change(o,"hscale",2.0,0,0,"正比",24) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",2.0,0,0,"正比",24) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=64,["begin"]=1,["life"]=85,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=85,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=3510,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(2790) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(630) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(540) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1080) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1530) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1620) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2070) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2160) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2340) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2520) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2700) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2790) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(270) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1370) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1170) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1260) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(810) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(900) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(990) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(1800) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(1890) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(2430) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(2970) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(3510) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3060) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(3240) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3330) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3420) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=64,["begin"]=1,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=3510,["type"]=234,["wscale"]=0.55,["hscale"]=0.55,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60+math.floor(t/90)*90) then R.change(o,"sonspeed",0.01,0,0,"正比",20) end
if t==(89+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(15+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(70+math.floor(t/90)*90) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"sonspeed",2.5,0,0,"正比",30) end
if t==(15+math.floor(t/90)*90) then R.change(o,"alpha",90.0,0,0,"正比",30) end
if t==(2790) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(630) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(540) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1080) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1530) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1620) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2070) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2160) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2340) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2520) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2700) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(2790) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(270) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1370) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(1170) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(1260) then R.change(o,"sonspeedd",180.0,0,1,"正比",1) end
if t==(810) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(900) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(990) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(1800) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(1890) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(2430) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(2970) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(3510) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3060) then R.change(o,"sonspeedd",90.0,0,1,"正比",1) end
if t==(3240) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3330) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
if t==(3420) then R.change(o,"sonspeedd",90.0,0,2,"正比",1) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=192,["begin"]=1,["life"]=761,["fx"]=-99998,["fy"]=-99998,["r"]=1200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=12,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=229,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=90,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1800.0,0,1,"正比",1200) end
if t==(700) then R.change(o,"alpha",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"rdirection",1800.0,0,1,"正比",1200) end
if t==(1) then R.change(o,"r",260.0,0,0,"正比",380) end
if t==(700) then R.change(o,"r",60.0,0,0,"正比",60) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=224,["begin"]=1,["life"]=761,["fx"]=-99998,["fy"]=-99998,["r"]=700,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=10,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=230,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=90,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1800.0,0,2,"正比",1200) end
if t==(700) then R.change(o,"alpha",1.0,0,0,"正比",60) end
if t==(1) then R.change(o,"rdirection",1800.0,0,2,"正比",1200) end
if t==(1) then R.change(o,"r",180.0,0,0,"正比",380) end
if t==(700) then R.change(o,"r",60.0,0,0,"正比",60) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=320,["y"]=352,["begin"]=1,["life"]=758,["r"]=600,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=12,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=5,["wscale"]=1,["longs"]=300,["alpha"]=100,["Ray"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="laser",["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",720.0,0,1,"正比",1200) end
if t==(1) then R.change(o,"rdirection",720.0,0,1,"正比",1200) end
if t==(698) then R.change(o,"wscale",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"r",60.0,0,0,"正比",580) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",0.0,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=352,["y"]=352,["begin"]=1,["life"]=758,["r"]=600,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=12,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2,["type"]=5,["wscale"]=1,["longs"]=300,["alpha"]=100,["Ray"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="laser",["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",720.0,0,2,"正比",1200) end
if t==(1) then R.change(o,"rdirection",720.0,0,2,"正比",1200) end
if t==(698) then R.change(o,"wscale",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"r",60.0,0,0,"正比",580) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",0.0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=352,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=234,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/50)*50) then R.change(o,"fdirection",120.0,0,1,"正比",50) end
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t==(1) then R.change(o,"hscale",0.2,0,0,"正比",61) end
if t>(1) then R.change(o,"fy","自机",0,0,"固定",1) end
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",61) end
if t==(1) then R.change(o,"wscale",0.2,0,0,"正比",61) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=352,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=234,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/50)*50) then R.change(o,"fdirection",120.0,0,2,"正比",50) end
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t==(1) then R.change(o,"hscale",0.25,0,0,"正比",61) end
if t>(1) then R.change(o,"fy","自机",0,0,"固定",1) end
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",61) end
if t==(1) then R.change(o,"wscale",0.25,0,0,"正比",61) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=352,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=45,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=225,["wscale"]=0.1,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=155,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t>(1) then R.change(o,"fy","自机",0,0,"固定",1) end
if t==(1) then R.change(o,"alpha",80.0,0,0,"正比",61) end
if t==(1+math.floor(t/15)*15) then R.change(o,"hscale",0.2,0,1,"正弦",14) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=256,["y"]=352,["begin"]=1,["life"]=6000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=45,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=225,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=155,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t>(1) then R.change(o,"fy","自机",0,0,"固定",1) end
if t==(1) then R.change(o,"alpha",60.0,0,0,"正比",61) end
if t==(1+math.floor(t/15)*15) then R.change(o,"wscale",0.05,0,1,"正弦",14) end
if t==(1+math.floor(t/15)*15) then R.change(o,"hscale",0.05,0,1,"正弦",14) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=4,["y"]=0,["begin"]=1,["life"]=4400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=16,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=52.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=256,["y"]=32,["begin"]=601,["life"]=1200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=36,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.48,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=288,["y"]=32,["begin"]=1800,["life"]=1800,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=24,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.22,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=448,["begin"]=3601,["life"]=2400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=448,["begin"]=3601,["life"]=2400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=0,["begin"]=3601,["life"]=2395,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=355,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=0,["begin"]=3601,["life"]=2400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=0,["begin"]=3601,["life"]=1915,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=355,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=0,["begin"]=3601,["life"]=2400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=9,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=448,["begin"]=3601,["life"]=1920,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=448,["begin"]=3601,["life"]=1920,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=11,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=0,["begin"]=4081,["life"]=1435,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=355,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=12,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=0,["begin"]=4081,["life"]=1440,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=13,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=448,["begin"]=4081,["life"]=1440,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=14,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=448,["begin"]=4081,["life"]=1440,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=15,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=1820,["life"]=4181,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=30,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=233,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=224,["wscale"]=12,["hscale"]=12,["colorR"]=255,["colorG"]=122,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=100,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",13.0,0,0,"正比",60) end
if t==(61) then R.change(o,"alpha",1.0,0,0,"正比",60) end
end},
{["id"]=16,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=620,["life"]=5381,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=30,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=233,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=224,["wscale"]=12,["hscale"]=12,["colorR"]=255,["colorG"]=122,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=100,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",13.0,0,0,"正比",60) end
if t==(61) then R.change(o,"alpha",1.0,0,0,"正比",60) end
end},
{["id"]=17,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=1878,["life"]=2,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=233,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=225,["wscale"]=30,["hscale"]=30,["colorR"]=255,["colorG"]=255,["colorB"]=155,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=18,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=0,["begin"]=4561,["life"]=955,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=355,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=19,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=0,["begin"]=4561,["life"]=960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=20,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=448,["begin"]=4561,["life"]=960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=21,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=448,["begin"]=4561,["life"]=960,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=22,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",90.0,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=22,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=192,["begin"]=3620,["life"]=2381,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=30,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=233,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=224,["wscale"]=12,["hscale"]=12,["colorR"]=255,["colorG"]=122,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=100,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",13.0,0,0,"正比",60) end
if t==(61) then R.change(o,"alpha",1.0,0,0,"正比",60) end
end},
{["id"]=0,["parentid"]=3,["x"]=288,["y"]=96,["begin"]=1000,["life"]=1001,["halfw"]=600,["halfh"]=600,["Circle"]=false,["type"]=1,["controlid"]=2,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1880) then R.change(o,"life",0.0,0,0,"固定",1) end
end}
}}
