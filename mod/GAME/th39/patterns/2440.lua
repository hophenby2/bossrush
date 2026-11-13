return {["id"]="2440",["total"]=5555,["order"]=1,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,500,10,290,5,0,0,40,1,0,0,0,0,0,"2-huangkulou2"},{500,0,200,200,100,100,0,0,1,0,0,0,0,0,0,"2-huangkulou2"},{0,0,100,100,50,40,0,0,20,3,0,0,0,0,0,"huohuohuo2"},{100,0,100,100,50,40,0,0,20,3,0,0,0,0,0,"huohuohuo2"},{200,0,100,100,50,40,0,0,19,3,0,0,0,0,0,"huohuohuo2"},{0,0,70,50,35,25,0,0,1,0,0,0,0,0,0,"2-kulou1"},{70,0,70,50,35,25,0,0,1,0,0,0,0,0,0,"2-kulou1"},{140,0,70,50,35,25,0,0,1,0,0,0,0,0,0,"2-kulou1"},{210,0,70,50,35,25,0,0,1,0,0,0,0,0,0,"2-kulou1"},{280,0,70,50,35,25,0,0,1,0,0,0,0,0,0,"2-kulou1"},{350,0,70,50,35,25,0,0,1,0,0,0,0,0,0,"2-kulou1"},{420,0,70,50,35,25,0,0,1,0,0,0,0,0,0,"2-kulou1"},{900,0,500,350,290,130,0,0,1,0,0,0,0,0,0,"2-huangkulou2"},{700,0,200,200,100,100,0,0,1,0,0,0,0,0,0,"2-huangkulou2"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)
if t==1500 then R.quake(c,180,13) end
end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=490,["y"]=419,["begin"]=1,["life"]=5555,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=56,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=235,["type"]=154,["wscale"]=3,["hscale"]=3,["colorR"]=1,["colorG"]=77,["colorB"]=77,["alpha"]=30,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=70,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=90,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/40)*40) then R.change(o,"wscale",1,0,1,"无缝正弦",40) end
if t==(1+math.floor(t/40)*40) then R.change(o,"hscale",1,0,2,"无缝正弦",40) end
if t==(1) then R.fire(o) end
if t==(4) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(80) then R.change(o,"type",1,0,1,"正比",1) end
if t==(160) then R.change(o,"type",1,0,1,"正比",1) end
if t==(220) then R.change(o,"alpha",1,0,0,"正比",20) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=504,["y"]=336,["begin"]=1,["life"]=12,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=235,["type"]=154,["wscale"]=4,["hscale"]=4,["colorR"]=1,["colorG"]=155,["colorB"]=155,["alpha"]=20,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=70,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=90,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",1,0,1,"无缝正弦",12) end
if t==(1+math.floor(t/12)*12) then R.change(o,"hscale",1,0,2,"无缝正弦",12) end
end,Sonevents=function(o,t,R)
if t==(80) then R.change(o,"type",1,0,1,"正比",1) end
if t==(160) then R.change(o,"type",1,0,1,"正比",1) end
if t==(70) then R.change(o,"alpha",1,0,0,"正比",60) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=423,["y"]=312,["begin"]=21,["life"]=12,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=235,["type"]=154,["wscale"]=3,["hscale"]=3,["colorR"]=1,["colorG"]=155,["colorB"]=155,["alpha"]=30,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=70,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=90,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",1,0,1,"无缝正弦",12) end
if t==(1+math.floor(t/12)*12) then R.change(o,"hscale",1,0,2,"无缝正弦",12) end
end,Sonevents=function(o,t,R)
if t==(80) then R.change(o,"type",1,0,1,"正比",1) end
if t==(160) then R.change(o,"type",1,0,1,"正比",1) end
if t==(70) then R.change(o,"alpha",1,0,0,"正比",60) end
end},
{["id"]=0,["parentid"]=1,["x"]=525,["y"]=482,["begin"]=1,["life"]=5200,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(120) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=530,["y"]=533,["begin"]=5,["life"]=5190,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=10,["speedd"]=260,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=68,["type"]=152,["wscale"]=1,["hscale"]=1,["colorR"]=77,["colorG"]=77,["colorB"]=77,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",5,0,0,"正比",42) end
if t==(1) then R.change(o,"speed",0,0,0,"正比",60) end
if t==(60) then R.change(o,"alpha",0,0,0,"正比",60) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=563,["y"]=580,["begin"]=15,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=230,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=260,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=153,["wscale"]=1,["hscale"]=1,["colorR"]=77,["colorG"]=77,["colorB"]=77,["alpha"]=1,["head"]=260,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(41) then R.change(o,"head",270,0,0,"正比",40) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",76) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",10) end
if t==(1) then R.change(o,"head",260,0,0,"正比",40) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=593,["y"]=556,["begin"]=15,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=200,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=260,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=165,["wscale"]=1,["hscale"]=0.7,["colorR"]=55,["colorG"]=55,["colorB"]=55,["alpha"]=1,["head"]=160,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(41) then R.change(o,"head",180,0,0,"正比",40) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",76) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",10) end
if t==(1) then R.change(o,"head",170,0,0,"正比",40) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",76) end
if t==(31) then R.change(o,"colorB",166,0,0,"正比",76) end
if t==(31) then R.change(o,"colorR",166,0,0,"正比",76) end
if t==(31) then R.change(o,"colorG",166,0,0,"正比",76) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=41,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(50) then R.change(o,"alpha",100,0,0,"正比",30) end
if t==(90) then R.change(o,"alpha",1,0,0,"正比",10) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=520,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=80,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=240,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=81,["wscale"]=3,["hscale"]=1,["colorR"]=1,["colorG"]=44,["colorB"]=55,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.2,0,0,"正比",90) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",90) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=543,["y"]=520,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=80,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=240,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=81,["wscale"]=3,["hscale"]=1,["colorR"]=1,["colorG"]=44,["colorB"]=55,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=12,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.2,0,0,"正比",90) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=546,["y"]=520,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=240,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=90,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=66,["colorB"]=133,["alpha"]=33,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",18,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",18,0,0,"正比",60) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=605,["y"]=467,["begin"]=1,["life"]=5200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=23,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=154,["wscale"]=1.5,["hscale"]=1.51,["colorR"]=1,["colorG"]=215,["colorB"]=255,["alpha"]=20,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=30,["r"]=70,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=10,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1300) then R.change(o,"sonspeed",0.001,0,0,"正比",150) end
if t==(1+math.floor(t/100)*100) then R.change(o,"wscale",0.5,0,1,"无缝正弦",100) end
if t==(1+math.floor(t/100)*100) then R.change(o,"hscale",0.5,0,1,"无缝正弦",100) end
end,Sonevents=function(o,t,R)
if t==(80) then R.change(o,"type",1,0,1,"正比",1) end
if t==(160) then R.change(o,"type",1,0,1,"正比",1) end
if t==(220) then R.change(o,"alpha",1,0,0,"正比",18) end
end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=488,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=90,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=160,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=225,["colorG"]=235,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",3,3,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",260,30,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",2.5,1,0,"正比",1) end
if t==(1) then R.change(o,"head",0,13000,1,"正比",3000) end
if t==(61) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(61) then R.change(o,"alpha",1,0,0,"正比",121) end
end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=552,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=10,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=205,["colorG"]=235,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.03,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",3,3,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",260,40,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3.5,1,0,"正比",1) end
if t==(1) then R.change(o,"head",0,13000,1,"正比",3000) end
if t==(121) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",30) end
if t==(121) then R.change(o,"alpha",1,0,0,"正比",121) end
end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=552,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=10,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=210,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=225,["colorG"]=245,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.02,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",3,3,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",260,30,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3.5,1,0,"正比",1) end
if t==(1) then R.change(o,"head",0,13000,1,"正比",3000) end
if t==(91) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",30) end
if t==(91) then R.change(o,"alpha",1,0,0,"正比",121) end
end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=488,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=90,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=160,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=225,["colorG"]=245,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.01,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",3,3,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",260,60,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",1) end
if t==(1) then R.change(o,"head",0,13000,1,"正比",3000) end
if t==(61) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(61) then R.change(o,"alpha",1,0,0,"正比",121) end
end},
{["id"]=5,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=424,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=130,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=10,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=225,["colorG"]=245,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.003,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",3,3,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",260,60,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.8,0.5,0,"正比",1) end
if t==(1) then R.change(o,"head",0,13000,1,"正比",3000) end
if t==(61) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(61) then R.change(o,"alpha",1,0,0,"正比",121) end
end},
{["id"]=6,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=584,["y"]=579,["begin"]=1,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=210,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=235,["colorG"]=245,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.04,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",3,3,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",260,30,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",4.5,2,0,"正比",1) end
if t==(1) then R.change(o,"head",0,13000,1,"正比",3000) end
if t==(91) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",30) end
if t==(91) then R.change(o,"alpha",1,0,0,"正比",121) end
end},
{["id"]=7,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=555,["y"]=575,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=15,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=210,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=215,["colorG"]=245,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.04,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",3,3,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",240,30,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",7,4,0,"正比",1) end
if t==(1) then R.change(o,"head",0,13000,1,"正比",3000) end
if t==(91) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",30) end
if t==(91) then R.change(o,"alpha",1,0,0,"正比",121) end
end},
{["id"]=8,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=558,["y"]=432,["begin"]=1,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=130,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=510,["type"]=149,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=225,["colorG"]=245,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",240,30,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3,2,0,"正比",1) end
if t==(1) then R.change(o,"head",0,13000,1,"正比",3000) end
if t==(91) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",30) end
if t==(2) then R.change(o,"sonspeed",1,0,0,"正比",120) end
if t==(2) then R.change(o,"sonspeedd",0,240,1,"正比",120) end
if t==(122) then R.change(o,"sonspeedd",0,30,1,"正弦",120) end
if t==(122) then R.change(o,"sonspeed",3,1,0,"正比",120) end
end},
{["id"]=9,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=608,["y"]=527,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=510,["type"]=150,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=185,["colorG"]=205,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",240,30,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",4.5,2,0,"正比",1) end
if t==(1) then R.change(o,"head",0,13000,1,"正比",3000) end
if t==(91) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",30) end
if t==(2) then R.change(o,"sonspeed",1,0,0,"正比",120) end
if t==(2) then R.change(o,"sonspeedd",0,130,1,"正比",120) end
if t==(122) then R.change(o,"sonspeedd",0,30,1,"正弦",120) end
if t==(122) then R.change(o,"sonspeed",3,1,0,"正比",120) end
end},
{["id"]=10,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=597,["y"]=415,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=130,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=10,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=90,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=210,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=225,["colorG"]=245,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.003,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",3,3,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",260,60,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.8,0.5,0,"正比",1) end
if t==(1) then R.change(o,"head",0,13000,1,"正比",3000) end
if t==(151) then R.change(o,"colorR",155,0,0,"正比",60) end
if t==(151) then R.change(o,"alpha",1,0,0,"正比",61) end
end}
}}
