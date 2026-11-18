-- 离线展开：e47.xna；事件均已编译为Lua条件和调用。
return {id="e47",total=120,centerAvailable=false,center={315,240,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,300,363,150,181,8,0},{300,0,300,363,150,181,8,0},{600,0,300,363,200,121,8,0},{1500,0,300,363,150,181,15,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=310,["y"]=241,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=232,["wscale"]=1.9,["hscale"]=1.9,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",30.0,0,1,"正比",90) end
if t==(1) then R.change(o,"wscale",2.0,0,0,"正比",90) end
if t==(1) then R.change(o,"hscale",2.0,0,0,"正比",90) end
if t==(61) then R.change(o,"alpha",1.0,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",30) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=321,["y"]=270,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=226,["wscale"]=12,["hscale"]=12,["colorR"]=215,["colorG"]=125,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=true,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(70) then R.change(o,"alpha",10.0,0,0,"正比",20) end
if t==(1) then R.change(o,"head",0.0,60.0,1,"正弦",360) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=321,["y"]=270,["begin"]=1,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=22,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=226,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=215,["colorG"]=155,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.4,0,1,"正弦",30) end
if t==(1) then R.change(o,"hscale",0.4,0,1,"正弦",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",20.0,10.0,0,"正比",1) end
if t==(65) then R.change(o,"alpha",0.0,0,0,"正比",30) end
if t==(5) then R.change(o,"sonspeed",1.0,0.5,0,"正比",12) end
if t==(65) then R.change(o,"sonspeed",5.0,3.0,0,"正比",15) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=321,["y"]=270,["begin"]=1,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=10,["rdirections"]={0.0,0.0},["tiao"]=22,["t"]=1,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=228,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=155,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.4,0,1,"正弦",30) end
if t==(1) then R.change(o,"hscale",0.4,0,1,"正弦",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",20.0,10.0,0,"正比",1) end
if t==(65) then R.change(o,"alpha",0.0,0,0,"正比",30) end
if t==(5) then R.change(o,"sonspeed",1.0,0.5,0,"正比",12) end
if t==(65) then R.change(o,"sonspeed",5.0,3.0,0,"正比",15) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=354,["y"]=181,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=110,["type"]=230,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=275,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",12.0,0,1,"正比",90) end
if t==(11) then R.change(o,"wscale",0.11,0,1,"正比",80) end
if t==(75) then R.change(o,"colorG",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",5) end
if t==(1) then R.change(o,"sonspeed",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.15,0,1,"正比",10) end
if t==(1) then R.change(o,"hscale",0.15,0,1,"正比",10) end
if t==(11) then R.change(o,"hscale",0.11,0,1,"正比",80) end
if t==(75) then R.change(o,"sonspeed",2.0,0,0,"正比",15) end
if t==(75) then R.change(o,"colorB",0.0,0,0,"正比",15) end
if t==(80) then R.change(o,"alpha",1.0,0,0,"正比",10) end
if t==(75) then R.change(o,"colorR",122.0,0,0,"正比",15) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=334,["y"]=309,["begin"]=1,["life"]=10,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=226,["wscale"]=0.5,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=220,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",55.0,0,1,"正比",30) end
if t==(15) then R.change(o,"alpha",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",30.0,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.01,0,0,"正比",30) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=174,["y"]=326,["begin"]=1,["life"]=90,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=135,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=226,["wscale"]=0.5,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=220,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",55.0,0,1,"正比",30) end
if t==(15) then R.change(o,"alpha",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",5.0,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.01,0,0,"正比",30) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=334,["y"]=277,["begin"]=70,["life"]=10,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=226,["wscale"]=0.5,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=220,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",55.0,0,1,"正比",24) end
if t==(15) then R.change(o,"alpha",0.0,0,0,"正比",13) end
if t==(1) then R.change(o,"alpha",30.0,0,0,"正比",13) end
if t==(1) then R.change(o,"wscale",0.01,0,0,"正比",24) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=324,["y"]=12,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=280,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=226,["wscale"]=5,["hscale"]=5,["colorR"]=255,["colorG"]=1,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",3.0,0,1,"正比",90) end
if t==(45) then R.change(o,"alpha",0.0,0,0,"正比",45) end
if t==(1) then R.change(o,"hscale",3.0,0,1,"正比",90) end
if t==(1) then R.change(o,"alpha",30.0,0,0,"正比",45) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=201,["y"]=236,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=30,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=4,["t"]=12,["fdirection"]=135,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=225,["wscale"]=0.05,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=8,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",10.0,20.0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",22.0,0,1,"正比",30) end
if t==(75) then R.change(o,"alpha",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",15) end
if t==(75) then R.change(o,"sonspeed",8.0,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.03,0,2,"正比",90) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=340,["y"]=443,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=240,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",12.0,0,1,"正比",90) end
if t==(1) then R.change(o,"wscale",1.2,0,0,"正比",11) end
if t==(75) then R.change(o,"colorG",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",12) end
if t==(75) then R.change(o,"sonspeed",8.0,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",15) end
if t==(12) then R.change(o,"wscale",0.1,0,1,"正比",90) end
if t==(12) then R.change(o,"hscale",0.1,0,1,"正比",90) end
if t==(1) then R.change(o,"hscale",1.2,0,0,"正比",11) end
if t==(75) then R.change(o,"alpha",0.0,0,0,"正比",15) end
end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=32,["y"]=384,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=500,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=232,["wscale"]=2,["hscale"]=2,["colorR"]=205,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=220,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",36.0,0,1,"正比",90) end
if t==(75) then R.change(o,"colorG",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",12) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正比",90) end
if t==(1) then R.change(o,"hscale",0.1,0,1,"正比",90) end
if t==(75) then R.change(o,"alpha",0.0,0,0,"正比",15) end
end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=41,["y"]=27,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=260,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=231,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=220,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",12.0,0,1,"正比",90) end
if t==(75) then R.change(o,"colorG",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",12) end
if t==(75) then R.change(o,"sonspeed",8.0,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",1.6,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正比",90) end
if t==(1) then R.change(o,"hscale",0.1,0,1,"正比",90) end
if t==(75) then R.change(o,"alpha",0.0,0,0,"正比",15) end
end},
{["id"]=9,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=258,["y"]=93,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=231,["wscale"]=3,["hscale"]=3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=220,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",12.0,0,1,"正比",90) end
if t==(75) then R.change(o,"colorG",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",12) end
if t==(75) then R.change(o,"sonspeed",8.0,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正比",90) end
if t==(1) then R.change(o,"hscale",0.1,0,1,"正比",90) end
if t==(75) then R.change(o,"alpha",0.0,0,0,"正比",15) end
end},
{["id"]=10,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=596,["y"]=448,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=500,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=232,["wscale"]=2,["hscale"]=2,["colorR"]=205,["colorG"]=155,["colorB"]=255,["alpha"]=1,["head"]=120,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",36.0,0,1,"正比",90) end
if t==(75) then R.change(o,"colorG",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",50.0,0,0,"正比",12) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正比",90) end
if t==(1) then R.change(o,"hscale",0.1,0,1,"正比",90) end
if t==(75) then R.change(o,"alpha",0.0,0,0,"正比",15) end
end},
{["id"]=11,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=500,["y"]=443,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=280,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=231,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=155,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=220,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",12.0,0,1,"正比",90) end
if t==(75) then R.change(o,"colorG",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",70.0,0,0,"正比",12) end
if t==(75) then R.change(o,"sonspeed",8.0,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",1.0,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正比",90) end
if t==(1) then R.change(o,"hscale",0.1,0,1,"正比",90) end
if t==(75) then R.change(o,"alpha",0.0,0,0,"正比",15) end
end},
{["id"]=12,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=354,["y"]=181,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=110,["type"]=230,["wscale"]=1,["hscale"]=1,["colorR"]=55,["colorG"]=15,["colorB"]=15,["alpha"]=1,["head"]=275,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",12.0,0,1,"正比",90) end
if t==(11) then R.change(o,"wscale",0.11,0,1,"正比",80) end
if t==(75) then R.change(o,"colorG",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",5) end
if t==(1) then R.change(o,"sonspeed",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.15,0,1,"正比",10) end
if t==(1) then R.change(o,"hscale",0.15,0,1,"正比",10) end
if t==(11) then R.change(o,"hscale",0.11,0,1,"正比",80) end
if t==(75) then R.change(o,"sonspeed",2.0,0,0,"正比",15) end
if t==(75) then R.change(o,"colorB",0.0,0,0,"正比",15) end
if t==(80) then R.change(o,"alpha",1.0,0,0,"正比",10) end
if t==(75) then R.change(o,"colorR",122.0,0,0,"正比",15) end
end},
{["id"]=13,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=340,["y"]=443,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=100,["type"]=229,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=240,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",12.0,0,1,"正比",90) end
if t==(1) then R.change(o,"wscale",1.2,0,0,"正比",11) end
if t==(75) then R.change(o,"colorG",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",30.0,0,0,"正比",12) end
if t==(75) then R.change(o,"sonspeed",8.0,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",15) end
if t==(12) then R.change(o,"wscale",0.1,0,1,"正比",90) end
if t==(12) then R.change(o,"hscale",0.1,0,1,"正比",90) end
if t==(1) then R.change(o,"hscale",1.2,0,0,"正比",11) end
if t==(75) then R.change(o,"alpha",0.0,0,0,"正比",15) end
end}
}}
