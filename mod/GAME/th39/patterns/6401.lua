return {["id"]="6401",["total"]=5200,["order"]=1,["centerAvailable"]=true,["center"]={480,260,0,0,0,0},["types"]={{0,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{110,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{220,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{330,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{0,230,440,300,220,160,0,0,1,0,0,0,0,0,0,"6boss-1"},{0,530,150,100,75,50,0,0,1,0,0,0,0,0,0,"6boss-1"},{150,530,100,100,50,50,0,0,1,0,0,0,0,0,0,"6boss-1"},{0,0,160,250,80,125,0,0,6,5,0,0,0,0,0,"6boss-2"},{0,1250,160,250,80,125,0,0,1,0,0,0,0,0,0,"6boss-2"},{0,0,160,250,80,125,0,0,1,0,0,0,0,0,0,"6boss-2"},{0,0,150,200,75,100,0,0,1,0,0,0,0,0,0,"6boss-cang"},{0,0,150,200,75,100,0,0,7,5,0,0,0,0,0,"6boss-cang"},{0,1200,150,200,75,100,0,0,1,0,0,0,0,0,0,"6boss-cang"},{0,0,50,100,25,50,0,0,1,0,0,0,0,0,0,"6boss-banzi"},{0,0,50,100,25,50,0,0,10,5,0,0,0,0,0,"6boss-banzi"},{0,900,50,100,25,50,0,0,1,0,0,0,0,0,0,"6boss-banzi"},{0,0,300,300,150,150,0,0,1,0,0,0,0,0,0,"6bg-10"},{500,0,250,200,125,100,0,0,8,6,0,0,0,0,0,"6-tiannv1"},{250,0,250,200,125,100,0,0,8,6,0,0,0,0,0,"6-tiannv1"},{0,0,250,200,125,100,0,0,8,6,0,0,0,0,0,"6-tiannv1"},{0,0,100,100,30,50,0,0,1,0,0,0,0,0,0,"6bg-10"},{100,0,100,100,40,50,0,0,1,0,0,0,0,0,0,"6bg-10"},{200,0,100,100,60,50,0,0,1,0,0,0,0,0,0,"6bg-10"},{0,0,400,400,200,200,0,0,1,0,0,0,0,0,0,"GYtishi"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["x"]=448,["y"]=456,["begin"]=1,["life"]=5200,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(520) then R.change(o,"sonspeed",1,0,0,"正比",180) end
end},
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=360,["begin"]=61,["life"]=270,["fx"]=480,["fy"]=-99998,["r"]=-5,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=12,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.01,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=172,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.2,["yscale"]=0.5,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.7,0,0,"正比",240) end
if t==(1) then R.change(o,"r",460,0,0,"正比",270) end
if t==(1) then R.change(o,"hscale",1.3,0,2,"正比",270) end
if t==(1) then R.change(o,"wscale",1.3,0,2,"正比",270) end
if t==(211) then R.change(o,"t",3,0,0,"正比",1) end
if t==(241) then R.change(o,"speed",-1,0,0,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.5,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",1.5,0,1,"正比",120) end
if t==(13) then R.change(o,"Blend",0,0,0,"正比",1) end
if t==(15) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(30) then R.change(o,"alpha",40,0,1,"正比",60) end
if t==(30) then R.change(o,"yscale",0.9,0.2,0,"正比",60) end
if t==(1+math.floor(t/240)*240) then R.change(o,"head",30,0,2,"正比",240) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=328,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=170,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(91) then R.change(o,"wscale",0.8,0,0,"正比",90) end
if t==(91) then R.change(o,"sonspeed",0,0,0,"正比",120) end
if t==(91) then R.change(o,"alpha",100,0,0,"正比",90) end
if t==(210) then R.change(o,"Blend",0,0,0,"正比",1) end
if t==(216) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(91) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(91) then R.change(o,"hscale",0.8,0,0,"正比",90) end
if t==(90) then R.change(o,"sonspeed",1.3,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=392,["begin"]=2,["life"]=1,["fx"]=480,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4600,["type"]=91,["wscale"]=0,["hscale"]=0,["colorR"]=222,["colorG"]=255,["colorB"]=222,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",13,0,0,"正比",200) end
if t==(1) then R.change(o,"hscale",5,0,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",300) end
if t==(1) then R.change(o,"alpha",50,0,0,"正比",180) end
end},
{["id"]=0,["parentid"]=1,["x"]=416,["y"]=456,["begin"]=1,["life"]=5200,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(520) then R.change(o,"yscale",1,0,0,"正比",1) end
if t==(520) then R.change(o,"sonspeed",1,0,0,"正比",180) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=120,["life"]=48,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=169,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",1,0,0,"正比",60) end
if t==(1) then R.change(o,"r",300,0,0,"正比",60) end
if t==(16) then R.change(o,"type",2,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",90) end
if t==(1) then R.change(o,"sonspeed",0,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",90) end
if t==(120) then R.change(o,"Blend",0,0,0,"正比",1) end
if t==(126) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"hscale",0.7,0,0,"正比",90) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=210,["life"]=48,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=12,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=148,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",1,0,0,"正比",60) end
if t==(1) then R.change(o,"r",300,0,0,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=120,["life"]=48,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=169,["wscale"]=0.5,["hscale"]=-0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",1,0,0,"正比",60) end
if t==(1) then R.change(o,"r",300,0,0,"正比",60) end
if t==(16) then R.change(o,"type",2,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",90) end
if t==(1) then R.change(o,"sonspeed",0,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",-0.7,0,0,"正比",90) end
if t==(120) then R.change(o,"Blend",0,0,0,"正比",1) end
if t==(126) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",90) end
end},
{["id"]=0,["parentid"]=2,["x"]=384,["y"]=456,["begin"]=1,["life"]=5200,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(520) then R.change(o,"yscale",1,0,0,"正比",1) end
if t==(520) then R.change(o,"sonspeed",1,0,0,"正比",180) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=608,["y"]=328,["begin"]=61,["life"]=240,["fx"]=480,["fy"]=-99998,["r"]=-10,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=12,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.01,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=172,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=40,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.2,["yscale"]=0.5,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.7,0,0,"正比",240) end
if t==(1) then R.change(o,"r",350,0,0,"正比",240) end
if t==(1) then R.change(o,"hscale",0.5,0,2,"正比",240) end
if t==(1) then R.change(o,"wscale",0.5,0,2,"正比",240) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",1,0,1,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(1+math.floor(t/240)*240) then R.change(o,"head",120,0,1,"正比",240) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=640,["y"]=328,["begin"]=61,["life"]=240,["fx"]=480,["fy"]=-99998,["r"]=-5,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=12,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.01,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=172,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=40,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.2,["yscale"]=0.5,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.7,0,0,"正比",240) end
if t==(1) then R.change(o,"r",350,0,0,"正比",240) end
if t==(1) then R.change(o,"hscale",0.3,0,2,"正比",240) end
if t==(1) then R.change(o,"wscale",0.3,0,2,"正比",240) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",1,0,1,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(1+math.floor(t/240)*240) then R.change(o,"head",120,0,2,"正比",240) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=704,["y"]=392,["begin"]=1,["life"]=360,["fx"]=480,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.01,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=172,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=40,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.2,["yscale"]=0.5,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.7,0,0,"正比",240) end
if t==(1) then R.change(o,"r",700,0,0,"正比",480) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,1,"正比",90) end
if t==(31) then R.change(o,"sonspeed",0.2,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",180) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(29) then R.change(o,"sonspeedd",0,360,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",1,0,1,"正比",90) end
if t==(1+math.floor(t/240)*240) then R.change(o,"head",30,0,1,"正比",240) end
if t==(35+math.floor(t/240)*240) then R.change(o,"sonspeedd",240,0,1,"正比",240) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=672,["y"]=360,["begin"]=1,["life"]=210,["fx"]=480,["fy"]=-99998,["r"]=-10,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=7,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.01,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=172,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.7,0,0,"正比",240) end
if t==(1) then R.change(o,"r",350,0,0,"正比",240) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",1,0,1,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.8,0.5,0,"正比",60) end
if t==(91) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",30,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",0,90,1,"正比",130) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=704,["y"]=328,["begin"]=31,["life"]=210,["fx"]=480,["fy"]=-99998,["r"]=-10,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=7,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.01,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=172,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.2,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.7,0,0,"正比",240) end
if t==(1) then R.change(o,"r",350,0,0,"正比",240) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",1,0,1,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",1,0.5,0,"正比",60) end
if t==(91) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",20,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",0,90,1,"正比",130) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=736,["y"]=392,["begin"]=1,["life"]=360,["fx"]=480,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=7,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.01,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=172,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.2,["yscale"]=0.5,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",0.7,0,0,"正比",240) end
if t==(1) then R.change(o,"r",700,0,0,"正比",480) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",90) end
if t==(31) then R.change(o,"sonspeed",0.2,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",180) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(29) then R.change(o,"sonspeedd",0,360,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",90) end
if t==(1+math.floor(t/240)*240) then R.change(o,"head",30,0,1,"正比",240) end
if t==(35+math.floor(t/240)*240) then R.change(o,"sonspeedd",240,0,1,"正比",240) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=384,["y"]=232,["begin"]=11,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=29,["wscale"]=0.9,["longs"]=500,["alpha"]=100,["Ray"]="Line",["sonspeed"]=9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=416,["y"]=232,["begin"]=1,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=85,["wscale"]=1,["longs"]=600,["alpha"]=88,["Ray"]="Line",["sonspeed"]=9.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=384,["y"]=264,["begin"]=11,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=29,["wscale"]=0.5,["longs"]=500,["alpha"]=100,["Ray"]="Curve",["sonspeed"]=10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["segment"]=52,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"sonspeedd",20,0,1,"无缝正弦",20) end
end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=416,["y"]=264,["begin"]=11,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=29,["wscale"]=0.5,["longs"]=500,["alpha"]=100,["Ray"]="Curve",["sonspeed"]=10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["segment"]=52,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"sonspeedd",20,0,2,"无缝正弦",20) end
end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=232,["begin"]=1,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=91,["wscale"]=0.8,["longs"]=700,["alpha"]=55,["Ray"]="Line",["sonspeed"]=9.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=true,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["colorR"]=1,["colorG"]=255,["colorB"]=1,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=431,["y"]=184,["begin"]=90,["life"]=480,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=90,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=82,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=424,["begin"]=120,["life"]=48,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=12,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",1,0,0,"正比",60) end
if t==(1) then R.change(o,"r",300,0,0,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",90) end
if t==(1) then R.change(o,"sonspeed",0,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",0.7,0,0,"正比",90) end
if t==(120) then R.change(o,"Blend",0,0,0,"正比",1) end
if t==(126) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=480,["y"]=456,["begin"]=481,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=73,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=20,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(31) then R.change(o,"sonspeed",2.5,1,0,"正比",60) end
end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=1,["life"]=48,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=136,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",1,0,0,"正比",60) end
if t==(1) then R.change(o,"fdirection",30,0,2,"正比",60) end
if t==(1) then R.change(o,"r",300,0,0,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",90) end
if t==(1) then R.change(o,"sonspeed",0,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",0.7,0,0,"正比",90) end
if t==(120) then R.change(o,"Blend",0,0,0,"正比",1) end
if t==(126) then R.change(o,"Afterimage",0,0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=544,["y"]=424,["begin"]=151,["life"]=360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=550,["type"]=77,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/400)*400) then R.change(o,"fdirection",5,0,1,"无缝正弦",400) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=5,["parentid"]=3,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=true,["x"]=576,["y"]=424,["begin"]=151,["life"]=360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=10,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=550,["type"]=77,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/400)*400) then R.change(o,"fdirection",5,0,1,"无缝正弦",400) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=6,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=1,["life"]=48,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=136,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"speed",1,0,0,"正比",60) end
if t==(1) then R.change(o,"fdirection",30,0,1,"正比",60) end
if t==(1) then R.change(o,"r",300,0,0,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.7,0,0,"正比",90) end
if t==(1) then R.change(o,"sonspeed",0,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",0.7,0,0,"正比",90) end
if t==(120) then R.change(o,"Blend",0,0,0,"正比",1) end
if t==(126) then R.change(o,"Afterimage",0,0,0,"正比",1) end
end},
{["id"]=7,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=55,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=24,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=94,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222,0,1,"正比",22) end
end},
{["id"]=8,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=65,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=24,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=65,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=9,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=429,["y"]=181,["begin"]=90,["life"]=400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=31,["t"]=90,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=180,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=85,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-2.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=3,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=495,["y"]=120,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=80,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=900,["type"]=65,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=11,["parentid"]=3,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=463,["y"]=120,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=80,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=900,["type"]=65,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=12,["parentid"]=3,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=true,["x"]=431,["y"]=120,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=80,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=900,["type"]=102,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=13,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=431,["y"]=184,["begin"]=90,["life"]=480,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=90,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=190,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=10,["type"]=3,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=14,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=431,["y"]=184,["begin"]=90,["life"]=480,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=90,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=190,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=710,["type"]=94,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/22)*22) then R.change(o,"head",222,0,1,"正比",22) end
end}
}}
