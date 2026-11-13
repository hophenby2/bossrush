-- 离线展开：b69910.xna；事件均已编译为Lua条件和调用。
return {id="69910",total=1200,centerAvailable=true,center={315,-50,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,100,100,50,50,0,0},{100,0,100,100,50,50,0,0},{200,0,100,100,50,50,0,0},{300,0,100,100,50,50,0,0},{0,100,100,415,50,200,0,0},{100,100,100,415,50,200,0,0},{200,100,200,300,100,150,0,0},{381,488,22,28,11,14,0,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=96,["begin"]=1,["life"]=900,["fx"]=-99998,["fy"]=190,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=235,["wscale"]=2.2,["hscale"]=2.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(800) then R.change(o,"alpha",1.0,0,0,"正比",100) end
if t==(1) then R.change(o,"alpha",20.0,0,0,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=64,["begin"]=1,["life"]=900,["fx"]=-99998,["fy"]=190,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=235,["wscale"]=2.2,["hscale"]=2.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(26+math.floor(t/50)*50) then R.change(o,"alpha",5.0,4.0,0,"正比",1) end
if t==(1+math.floor(t/50)*50) then R.change(o,"alpha",7.0,6.0,0,"正比",1) end
if t==(18+math.floor(t/50)*50) then R.change(o,"alpha",7.0,6.0,0,"正比",1) end
if t==(12+math.floor(t/50)*50) then R.change(o,"alpha",7.0,6.0,0,"正比",1) end
if t==(6+math.floor(t/50)*50) then R.change(o,"alpha",5.0,4.0,0,"正比",1) end
if t==(9+math.floor(t/50)*50) then R.change(o,"alpha",7.0,6.0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",360.0,0,1,"正比",120) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=320,["begin"]=561,["life"]=340,["fx"]=316,["fy"]=174,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(9+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(29+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(39+math.floor(t/40)*40) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(21) then R.change(o,"alpha",100.0,0,0,"正比",300) end
if t==(180) then R.change(o,"colorG",255.0,0,0,"正比",300) end
if t==(180) then R.change(o,"colorB",255.0,0,0,"正比",300) end
if t==(180) then R.change(o,"colorR",255.0,0,0,"正比",300) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",30.0,0,2,"正比",1) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=256,["begin"]=900,["life"]=1,["fx"]=316,["fy"]=174,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=18,["type"]=226,["wscale"]=5,["hscale"]=5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"hscale",15.0,0,1,"正比",18) end
if t==(2) then R.change(o,"alpha",0.0,0,0,"正比",18) end
if t==(2) then R.change(o,"colorG",1.0,0,0,"正比",18) end
if t==(2) then R.change(o,"wscale",15.0,0,1,"正比",18) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=384,["begin"]=500,["life"]=350,["fx"]=316,["fy"]=174,["r"]=300,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=350,["type"]=138,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=155,["colorB"]=245,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"rdirection",360.0,0,1,"正比",20) end
if t==(1+math.floor(t/20)*20) then R.change(o,"fdirection",360.0,0,1,"正比",20) end
if t==(100) then R.change(o,"t",4.0,0,0,"正比",1) end
if t==(200) then R.change(o,"t",2.0,0,0,"正比",1) end
if t==(300) then R.change(o,"tiao",3.0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeedd",0.0,30.0,1,"正弦",60) end
if t==(1) then R.change(o,"alpha",80.0,0,0,"正比",30) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=288,["begin"]=900,["life"]=1,["fx"]=316,["fy"]=174,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=24,["type"]=174,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=125,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"hscale",15.0,0,1,"正比",24) end
if t==(2) then R.change(o,"alpha",0.0,0,0,"正比",24) end
if t==(2) then R.change(o,"wscale",15.0,0,1,"正比",24) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=320,["begin"]=900,["life"]=1,["fx"]=316,["fy"]=174,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=45,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=226,["wscale"]=1,["hscale"]=3,["colorR"]=255,["colorG"]=111,["colorB"]=235,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"hscale",6.0,0,1,"正比",12) end
if t==(10) then R.change(o,"alpha",0.0,0,0,"正比",5) end
if t==(2) then R.change(o,"wscale",0.01,0,0,"正比",12) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=269,["y"]=230,["begin"]=310,["life"]=281,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.06,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=233,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=225,["colorB"]=125,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(100) then R.change(o,"alpha",1.0,0,0,"正比",180) end
if t==(1) then R.change(o,"colorB",255.0,0,0,"正比",120) end
if t==(1) then R.change(o,"colorG",255.0,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",80.0,0,0,"正比",60) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=374,["y"]=200,["begin"]=210,["life"]=381,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.06,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=234,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=225,["colorB"]=125,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(200) then R.change(o,"alpha",1.0,0,0,"正比",180) end
if t==(1) then R.change(o,"colorB",255.0,0,0,"正比",120) end
if t==(1) then R.change(o,"colorG",255.0,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",80.0,0,0,"正比",60) end
end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=128,["y"]=160,["begin"]=211,["life"]=12,["fx"]=92,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=330,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4200,["type"]=236,["wscale"]=0.25,["hscale"]=0.45,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=50},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.05,0,0,"正弦",11) end
if t==(1) then R.change(o,"head",0.0,13600.0,1,"正比",1200) end
if t==(1) then R.change(o,"sonaspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",4.0,3.6,0,"正比",1) end
if t==(1) then R.change(o,"colorG",200.0,50.0,0,"正比",30) end
if t==(2) then R.change(o,"sonspeed",1.0,0.5,0,"正比",50) end
if t==(1) then R.change(o,"alpha",88.0,0,0,"正比",30) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=160,["begin"]=300,["life"]=12,["fx"]=540,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=210,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4200,["type"]=236,["wscale"]=0.25,["hscale"]=0.45,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=50},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.05,0,0,"正弦",11) end
if t==(1) then R.change(o,"head",0.0,13600.0,1,"正比",1200) end
if t==(1) then R.change(o,"sonaspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",4.0,3.6,0,"正比",1) end
if t==(1) then R.change(o,"colorG",200.0,50.0,0,"正比",30) end
if t==(2) then R.change(o,"sonspeed",1.0,0.5,0,"正比",50) end
if t==(1) then R.change(o,"alpha",88.0,0,0,"正比",30) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=0,["begin"]=1,["life"]=800,["fx"]=315,["fy"]=0,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4200,["type"]=236,["wscale"]=0.2,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=7,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=230,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=20,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.05,0,0,"正弦",11) end
if t==(1) then R.change(o,"sonspeedd",0.0,30.0,1,"正比",1200) end
if t==(1) then R.change(o,"colorG",200.0,50.0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",48.0,0,0,"正比",30) end
if t==(1) then R.change(o,"head",0.0,13600.0,1,"正比",1200) end
end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=160,["begin"]=500,["life"]=12,["fx"]=92,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=330,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4200,["type"]=236,["wscale"]=0.25,["hscale"]=0.45,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=50},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.05,0,0,"正弦",11) end
if t==(1) then R.change(o,"head",0.0,13600.0,1,"正比",1200) end
if t==(1) then R.change(o,"sonaspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",4.0,3.6,0,"正比",1) end
if t==(1) then R.change(o,"colorG",200.0,50.0,0,"正比",30) end
if t==(2) then R.change(o,"sonspeed",1.0,0.5,0,"正比",50) end
if t==(1) then R.change(o,"alpha",88.0,0,0,"正比",30) end
end},
{["id"]=11,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=160,["begin"]=700,["life"]=12,["fx"]=540,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=210,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4200,["type"]=236,["wscale"]=0.25,["hscale"]=0.45,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=50},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.05,0,0,"正弦",11) end
if t==(1) then R.change(o,"head",0.0,13600.0,1,"正比",1200) end
if t==(1) then R.change(o,"sonaspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"sonspeed",4.0,3.6,0,"正比",1) end
if t==(1) then R.change(o,"colorG",200.0,50.0,0,"正比",30) end
if t==(2) then R.change(o,"sonspeed",1.0,0.5,0,"正比",50) end
if t==(1) then R.change(o,"alpha",88.0,0,0,"正比",30) end
end},
{["id"]=12,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=352,["begin"]=561,["life"]=340,["fx"]=316,["fy"]=174,["r"]=5,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=21,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(9+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(19+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(29+math.floor(t/40)*40) then R.change(o,"type",1.0,0,1,"正比",1) end
if t==(39+math.floor(t/40)*40) then R.change(o,"type",3.0,0,2,"正比",1) end
if t==(180) then R.change(o,"colorG",255.0,0,0,"正比",300) end
if t==(180) then R.change(o,"colorB",255.0,0,0,"正比",300) end
if t==(180) then R.change(o,"colorR",255.0,0,0,"正比",300) end
if t==(301) then R.change(o,"r",5.0,0,0,"正比",200) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",10.0,0,0,"正比",5) end
if t==(11) then R.change(o,"alpha",0.0,0,0,"正比",9) end
end},
{["id"]=13,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=288,["begin"]=900,["life"]=1,["fx"]=316,["fy"]=174,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=24,["type"]=174,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=125,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"hscale",15.0,0,1,"正比",36) end
if t==(2) then R.change(o,"alpha",0.0,0,0,"正比",36) end
if t==(2) then R.change(o,"wscale",15.0,0,1,"正比",36) end
end},
{["id"]=14,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=256,["begin"]=900,["life"]=1,["fx"]=316,["fy"]=174,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=18,["type"]=226,["wscale"]=45,["hscale"]=45,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",0.0,0,0,"正比",18) end
if t==(2) then R.change(o,"colorG",1.0,0,0,"正比",18) end
end},
{["id"]=0,["parentid"]=1,["x"]=320,["y"]=160,["begin"]=1,["life"]=1200,["halfw"]=40,["halfh"]=40,["Circle"]=true,["type"]=1,["controlid"]=3,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={},["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"life",0.0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=416,["begin"]=1,["life"]=800,["fx"]=-99998,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=25,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=56,["wscale"]=0.01,["hscale"]=51,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.2,0.1,0,"正比",30) end
if t==(91) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"sonspeed",0.0,0.3,0,"正弦",240) end
if t==(1) then R.change(o,"alpha",30.0,0,0,"正比",30) end
end}
}}
