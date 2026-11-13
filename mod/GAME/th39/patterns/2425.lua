return {["id"]="2425",["total"]=2200,["order"]=1,["centerAvailable"]=true,["center"]={480,160,0,0,0,0},["types"]={{0,0,250,150,175,78,0,0,6,6,0,0,0,0,0,"2-galagala"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=423,["y"]=285,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=152,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=2,["yscale"]=0.6,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeedd",50,0,1,"无缝正弦",120) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",240) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",240) end
if t==(1) then R.change(o,"sonspeed",0.1,0,0,"正比",240) end
if t==(1) then R.change(o,"colorG",255,0,0,"正比",180) end
if t==(1) then R.change(o,"colorR",130,0,0,"正比",180) end
if t==(1) then R.change(o,"alpha",40,0,0,"正比",60) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",180) end
if t==(121) then R.change(o,"alpha",100,0,0,"正比",120) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=419,["y"]=499,["begin"]=1,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=40,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=2,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.7,0,0,"正比",180) end
if t==(180) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",180) end
if t==(160) then R.change(o,"t",12,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",90,0,0,"正比",13) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",30) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=419,["y"]=531,["begin"]=1,["life"]=210,["fx"]=-99998,["fy"]=-99998,["r"]=9,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=2,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.4,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.7,0,0,"正比",180) end
if t==(180) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",180) end
if t==(120) then R.change(o,"t",13,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",90,0,0,"正比",13) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",30) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=419,["y"]=467,["begin"]=1,["life"]=240,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=40,["type"]=152,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.7,0,0,"正比",180) end
if t==(180) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",180) end
if t==(160) then R.change(o,"t",12,0,0,"正比",1) end
if t==(1) then R.change(o,"colorR",1,0,0,"正比",120) end
if t==(1) then R.change(o,"colorG",255,0,0,"正比",120) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.3,0,0,"正比",30) end
if t==(20) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(1) then R.change(o,"hscale",0.3,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",10,0,0,"正比",20) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=552,["begin"]=271,["life"]=360,["fx"]=-99998,["fy"]=160,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=9900,["fdirection"]=1,["fdirections"]={0.0,0.0},["range"]=105,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=98,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=1,["colorG"]=158,["colorB"]=255,["alpha"]=40,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(2+math.floor(t/120)*120) then R.change(o,"fdirection",150,0,2,"正比",1) end
if t==(3+math.floor(t/120)*120) then R.change(o,"fdirection",310,0,1,"正比",20) end
if t==(3+math.floor(t/120)*120) then R.change(o,"t",1,0,0,"正比",1) end
if t==(3+math.floor(t/120)*120) then R.change(o,"sonspeed",3,0,1,"正比",20) end
if t==(21+math.floor(t/120)*120) then R.change(o,"t",9999,0,0,"正比",1) end
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeed",5,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.6,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",3,0,2,"正比",15) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"head",5000,0,1,"正比",500) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=616,["begin"]=301,["life"]=360,["fx"]=-99998,["fy"]=160,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=9900,["fdirection"]=1,["fdirections"]={0.0,0.0},["range"]=105,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=98,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=1,["colorG"]=158,["colorB"]=255,["alpha"]=40,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(2+math.floor(t/120)*120) then R.change(o,"fdirection",150,0,1,"正比",1) end
if t==(3+math.floor(t/120)*120) then R.change(o,"fdirection",310,0,2,"正比",20) end
if t==(3+math.floor(t/120)*120) then R.change(o,"t",1,0,0,"正比",1) end
if t==(3+math.floor(t/120)*120) then R.change(o,"sonspeed",3,0,1,"正比",20) end
if t==(21+math.floor(t/120)*120) then R.change(o,"t",9999,0,0,"正比",1) end
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeed",5,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.6,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",3,0,2,"正比",15) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",15) end
if t==(1) then R.change(o,"head",5000,0,1,"正比",500) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=331,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=60,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=150,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.3,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"xscale",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",2,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=451,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=60,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=150,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.3,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"xscale",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",2,0,0,"正比",60) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=520,["begin"]=271,["life"]=360,["fx"]=-99998,["fy"]=160,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=9900,["fdirection"]=1,["fdirections"]={0.0,0.0},["range"]=105,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=81,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=244,["colorB"]=244,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(2+math.floor(t/120)*120) then R.change(o,"fdirection",150,0,2,"正比",1) end
if t==(3+math.floor(t/120)*120) then R.change(o,"fdirection",310,0,1,"正比",20) end
if t==(3+math.floor(t/120)*120) then R.change(o,"t",1,0,0,"正比",1) end
if t==(3+math.floor(t/120)*120) then R.change(o,"sonspeed",3,0,1,"正比",20) end
if t==(21+math.floor(t/120)*120) then R.change(o,"t",9999,0,0,"正比",1) end
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeed",5,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",3,0,2,"正比",15) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",15) end
if t==(1) then R.change(o,"head",5000,0,1,"正比",500) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=584,["begin"]=301,["life"]=360,["fx"]=-99998,["fy"]=160,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=7,["t"]=9900,["fdirection"]=1,["fdirections"]={0.0,0.0},["range"]=105,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=81,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=244,["colorB"]=244,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(2+math.floor(t/120)*120) then R.change(o,"fdirection",150,0,1,"正比",1) end
if t==(3+math.floor(t/120)*120) then R.change(o,"fdirection",310,0,2,"正比",20) end
if t==(3+math.floor(t/120)*120) then R.change(o,"t",1,0,0,"正比",1) end
if t==(3+math.floor(t/120)*120) then R.change(o,"sonspeed",3,0,1,"正比",20) end
if t==(21+math.floor(t/120)*120) then R.change(o,"t",9999,0,0,"正比",1) end
if t==(1+math.floor(t/120)*120) then R.change(o,"sonspeed",5,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",3,0,2,"正比",15) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",15) end
if t==(1) then R.change(o,"head",5000,0,1,"正比",500) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=241,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=19,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=109,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.9,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.9,0,0,"正比",60) end
if t==(31) then R.change(o,"sonspeed",4,1,0,"正比",60) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=241,["life"]=1,["fx"]=-99998,["fy"]=160,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=152,["wscale"]=1,["hscale"]=1,["colorR"]=180,["colorG"]=255,["colorB"]=255,["alpha"]=20,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(15) then R.change(o,"alpha",1,0,0,"正比",15) end
end}
}}
