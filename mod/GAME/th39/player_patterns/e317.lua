return {["id"]="317",["total"]=4800,["order"]=0,["centerAvailable"]=true,["center"]={480,275,0,0,0,0},["types"]={{250,0,250,250,125,130,0,0,7,6,0,0,0,0,0,""},{220,0,220,300,110,150,0,0,7,6,0,0,0,0,0,""},{0,0,220,300,110,150,0,0,7,6,0,0,0,0,0,""},{250,0,250,250,110,150,0,0,7,6,0,0,0,0,0,""},{0,0,200,200,100,100,0,0,10,2,0,0,0,0,0,""},{0,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"doll"},{25,0,25,50,13,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"},{0,0,25,50,13,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"},{50,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"EXBOSSmao"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=1,["life"]=4800,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=91,["wscale"]=3,["hscale"]=3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"hscale",0.2,0,1,"正弦",18) end
if t==(1+math.floor(t/120)*120) then R.change(o,"wscale",0.2,0,1,"正弦",18) end
if t==(20+math.floor(t/120)*120) then R.change(o,"hscale",0.3,0,1,"正弦",29) end
if t==(20+math.floor(t/120)*120) then R.change(o,"wscale",0.3,0,1,"正弦",29) end
if t==(50+math.floor(t/120)*120) then R.change(o,"hscale",0.2,0,1,"正弦",68) end
if t==(50+math.floor(t/120)*120) then R.change(o,"wscale",0.2,0,1,"正弦",68) end
if t==(119+math.floor(t/120)*120) then R.change(o,"wscale",3,0,0,"正比",1) end
if t==(119+math.floor(t/120)*120) then R.change(o,"hscale",3,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=1,["life"]=4800,["fx"]=-99998,["fy"]=240,["r"]=30,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=10,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.2,0,0,"正比",20) end
if t==(1) then R.change(o,"hscale",0.2,0,0,"正比",20) end
if t==(41) then R.change(o,"hscale",0,0,0,"正比",20) end
if t==(41) then R.change(o,"wscale",0,0,0,"正比",20) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=424,["begin"]=1,["life"]=4800,["fx"]=-99998,["fy"]=250,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=10,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.3,0,0,"正比",20) end
if t==(1) then R.change(o,"hscale",0.3,0,0,"正比",20) end
if t==(41) then R.change(o,"hscale",0,0,0,"正比",20) end
if t==(41) then R.change(o,"wscale",0,0,0,"正比",20) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=1,["life"]=4800,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=25,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=158,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=90,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.5,1,0,"正比",1) end
if t==(1) then R.change(o,"head",0,600,1,"正比",60) end
if t==(1) then R.change(o,"sonspeedd",0,30,1,"正比",60) end
if t==(1) then R.change(o,"hscale",0.6,0.2,0,"正比",10) end
if t==(40) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",70,25,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.7,0,0,"无缝正弦",20) end
if t==(21) then R.change(o,"wscale",0.7,0,0,"无缝正弦",20) end
if t==(41) then R.change(o,"hscale",0,0,0,"正比",20) end
if t==(41) then R.change(o,"wscale",0,0,0,"正比",20) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=1,["life"]=4800,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=40,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=158,["wscale"]=0,["hscale"]=0,["colorR"]=188,["colorG"]=188,["colorB"]=188,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=90,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.5,1,0,"正比",1) end
if t==(1) then R.change(o,"head",0,600,1,"正比",80) end
if t==(1) then R.change(o,"sonspeedd",0,30,1,"正比",80) end
if t==(1) then R.change(o,"hscale",0.5,0.2,0,"正比",10) end
if t==(60) then R.change(o,"alpha",0,0,0,"正比",20) end
if t==(1) then R.change(o,"alpha",70,25,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.6,0,0,"无缝正弦",30) end
if t==(31) then R.change(o,"wscale",0.6,0,0,"无缝正弦",30) end
if t==(60) then R.change(o,"hscale",0,0,0,"正比",20) end
if t==(60) then R.change(o,"wscale",0,0,0,"正比",20) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=1,["life"]=4800,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=158,["wscale"]=0,["hscale"]=0,["colorR"]=130,["colorG"]=130,["colorB"]=130,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=130,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0,0.5,0,"正比",1) end
if t==(1) then R.change(o,"head",0,130,1,"正比",80) end
if t==(1) then R.change(o,"sonspeedd",0,130,1,"正比",130) end
if t==(1) then R.change(o,"hscale",0.5,0.1,0,"正比",10) end
if t==(70) then R.change(o,"alpha",0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",70,25,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"无缝正弦",90) end
if t==(91) then R.change(o,"hscale",0.2,0,0,"正比",40) end
if t==(91) then R.change(o,"wscale",0,0,0,"正比",40) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=328,["begin"]=1,["life"]=4800,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=40,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=158,["wscale"]=0,["hscale"]=0,["colorR"]=125,["colorG"]=125,["colorB"]=125,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",1) end
if t==(1) then R.change(o,"head",0,600,1,"正比",90) end
if t==(1) then R.change(o,"hscale",0.4,0.1,0,"正比",10) end
if t==(60) then R.change(o,"alpha",0,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",70,25,0,"正比",1) end
if t==(31) then R.change(o,"wscale",0.5,0,0,"无缝正弦",30) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"无缝正弦",30) end
if t==(61) then R.change(o,"hscale",0,0,0,"正比",30) end
if t==(61) then R.change(o,"wscale",0,0,0,"正比",30) end
end}
}}
