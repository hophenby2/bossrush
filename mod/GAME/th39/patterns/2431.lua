return {["id"]="2431",["total"]=5200,["order"]=0,["centerAvailable"]=true,["center"]={480,260,0,0,0,0},["types"]={},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=488,["begin"]=161,["life"]=640,["fx"]=-99998,["fy"]=292,["r"]=50,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=3,["fdirection"]=320,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=98,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=125,["colorB"]=255,["alpha"]=12,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121+math.floor(t/240)*240) then R.change(o,"fdirection",40,0,2,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,1,"正比",120) end
if t==(121+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,2,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",1,0,1,"无缝正弦",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"fdirection",40,0,1,"正比",120) end
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeed",1,0,1,"无缝正弦",120) end
end,Sonevents=function(o,t,R)
if t==(16) then R.change(o,"wscale",0.4,0,0,"正比",60) end
if t==(16) then R.change(o,"hscale",0.7,0,0,"正比",60) end
if t==(91) then R.change(o,"sonspeed",10,0,0,"正比",600) end
if t==(1) then R.change(o,"alpha",55,0,0,"正比",15) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=494,["y"]=520,["begin"]=161,["life"]=640,["fx"]=-99998,["fy"]=292,["r"]=40,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=3,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=98,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=125,["colorB"]=255,["alpha"]=12,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121+math.floor(t/240)*240) then R.change(o,"fdirection",40,0,1,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,2,"正比",120) end
if t==(121+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,1,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"fdirection",40,0,2,"正比",120) end
if t==(120+math.floor(t/240)*240) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",1,0,1,"无缝正弦",120) end
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeed",1,0,1,"无缝正弦",120) end
end,Sonevents=function(o,t,R)
if t==(16) then R.change(o,"wscale",0.4,0,0,"正比",60) end
if t==(16) then R.change(o,"hscale",0.7,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",55,0,0,"正比",15) end
if t==(91) then R.change(o,"sonspeed",10,0,0,"正比",600) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=0,["begin"]=21,["life"]=631,["fx"]=-99998,["fy"]=-200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=119,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=150,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=90,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=90,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",60) end
if t==(250) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeedd",20,0,1,"无缝正弦",60) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=672,["y"]=0,["begin"]=81,["life"]=631,["fx"]=-99998,["fy"]=-200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=70,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=150,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=90,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=90,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",60) end
if t==(250) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeedd",20,0,2,"无缝正弦",60) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=64,["y"]=320,["begin"]=81,["life"]=631,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=70,["fdirection"]=66,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=150,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=90,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=90,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=10,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",60) end
if t==(120) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeedd",20,0,1,"无缝正弦",60) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=800,["y"]=352,["begin"]=61,["life"]=631,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=100,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=150,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=90,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=90,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",60) end
if t==(120) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeedd",20,0,1,"无缝正弦",60) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=296,["begin"]=301,["life"]=460,["fx"]=-99998,["fy"]=292,["r"]=50,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=20,["fdirection"]=320,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=108,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=15,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121+math.floor(t/240)*240) then R.change(o,"fdirection",60,0,2,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,1,"正比",120) end
if t==(121+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,2,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"fdirection",60,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(16) then R.change(o,"wscale",0.7,0,0,"正比",60) end
if t==(16) then R.change(o,"hscale",0.7,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",4,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=328,["begin"]=301,["life"]=460,["fx"]=-99998,["fy"]=292,["r"]=50,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=20,["fdirection"]=135,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=108,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121+math.floor(t/240)*240) then R.change(o,"fdirection",60,0,1,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,2,"正比",120) end
if t==(121+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,1,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"fdirection",60,0,2,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",4,0,0,"正比",60) end
if t==(16) then R.change(o,"wscale",0.7,0,0,"正比",60) end
if t==(16) then R.change(o,"hscale",0.7,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",15) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=392,["begin"]=301,["life"]=460,["fx"]=-99998,["fy"]=292,["r"]=50,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=20,["fdirection"]=320,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=81,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=12,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121+math.floor(t/240)*240) then R.change(o,"fdirection",60,0,2,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,1,"正比",120) end
if t==(121+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,2,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"fdirection",60,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(16) then R.change(o,"wscale",0.8,0,0,"正比",35) end
if t==(16) then R.change(o,"hscale",0.8,0,0,"正比",35) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",4,0,0,"正比",60) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=424,["begin"]=301,["life"]=460,["fx"]=-99998,["fy"]=292,["r"]=50,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=20,["fdirection"]=135,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=81,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=12,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121+math.floor(t/240)*240) then R.change(o,"fdirection",60,0,1,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,2,"正比",120) end
if t==(121+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,1,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"fdirection",60,0,2,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",4,0,0,"正比",60) end
if t==(16) then R.change(o,"wscale",0.8,0,0,"正比",35) end
if t==(16) then R.change(o,"hscale",0.8,0,0,"正比",35) end
if t==(1) then R.change(o,"alpha",50,0,0,"正比",15) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=488,["begin"]=161,["life"]=640,["fx"]=-99998,["fy"]=292,["r"]=50,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=2,["fdirection"]=320,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=81,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=12,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121+math.floor(t/240)*240) then R.change(o,"fdirection",40,0,2,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,1,"正比",120) end
if t==(121+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,2,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",1,0,1,"无缝正弦",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"fdirection",40,0,1,"正比",120) end
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeed",1,0,1,"无缝正弦",120) end
end,Sonevents=function(o,t,R)
if t==(16) then R.change(o,"wscale",0.8,0,0,"正比",60) end
if t==(16) then R.change(o,"hscale",0.8,0,0,"正比",60) end
if t==(91) then R.change(o,"sonspeed",10,0,0,"正比",600) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",15) end
if t==(1) then R.change(o,"head",2300,0,1,"正比",600) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=494,["y"]=520,["begin"]=161,["life"]=640,["fx"]=-99998,["fy"]=292,["r"]=40,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=2,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=81,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=12,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(121+math.floor(t/240)*240) then R.change(o,"fdirection",40,0,1,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,2,"正比",120) end
if t==(121+math.floor(t/240)*240) then R.change(o,"rdirection",60,0,1,"正比",120) end
if t==(1+math.floor(t/240)*240) then R.change(o,"fdirection",40,0,2,"正比",120) end
if t==(120+math.floor(t/240)*240) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1+math.floor(t/240)*240) then R.change(o,"sonspeed",1,0,1,"无缝正弦",120) end
if t==(120+math.floor(t/240)*240) then R.change(o,"sonspeed",1,0,1,"无缝正弦",120) end
end,Sonevents=function(o,t,R)
if t==(16) then R.change(o,"wscale",0.8,0,0,"正比",60) end
if t==(16) then R.change(o,"hscale",0.8,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",15) end
if t==(91) then R.change(o,"sonspeed",10,0,0,"正比",600) end
if t==(1) then R.change(o,"head",2300,0,2,"正比",600) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=280,["begin"]=580,["life"]=130,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1300,["type"]=151,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=40,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",0,300,1,"正比",120) end
if t==(121) then R.change(o,"sonspeedd","自机",30,0,"正比",1) end
if t==(121) then R.change(o,"sonspeed",5,1,0,"正比",61) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=325,["y"]=225,["begin"]=121,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=580,["type"]=148,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=11,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=613,["y"]=353,["begin"]=121,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=580,["type"]=148,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=280,["begin"]=61,["life"]=130,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1300,["type"]=151,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=40,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",0,300,1,"正比",120) end
if t==(121) then R.change(o,"sonspeedd","自机",30,0,"正比",1) end
if t==(121) then R.change(o,"sonspeed",5,1,0,"正比",61) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=280,["begin"]=301,["life"]=360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=13,["fdirection"]=160,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1300,["type"]=151,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=30,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=40,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"t",5,0,0,"正比",1) end
if t==(31+math.floor(t/120)*120) then R.change(o,"t",9999,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",120,100,1,"正比",120) end
if t==(121) then R.change(o,"sonspeedd",270,130,0,"正比",1) end
if t==(121) then R.change(o,"sonspeed",5,1,0,"正比",61) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=264,["begin"]=121,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=70,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=80,["t"]=11,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=330,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=133,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,0,2,"正比",3) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",16) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",16) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=424,["begin"]=161,["life"]=640,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=2,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end}
}}
