return {["id"]="8131",["total"]=540,["order"]=1,["centerAvailable"]=true,["center"]={480,200,0,0,0,0},["types"]={{0,0,40,550,20,275,10,0,1,0,0,0,0,0,0,"2BOSS-fw"},{40,0,182,204,92,102,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{40,204,331,335,166,173,16,0,1,0,0,0,0,0,0,"2BOSS-fw"},{371,139,282,295,141,147,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{653,139,320,335,160,168,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{973,139,43,42,22,21,5,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1016,139,96,91,48,46,11,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1112,139,65,63,33,32,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1177,139,69,40,35,20,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{0,0,200,150,100,75,0,0,1,0,0,0,0,0,0,"yujingquyu"},{0,0,200,200,100,100,0,0,1,0,0,0,0,0,0,"Jifeijiantou"},{973,230,164,166,82,83,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,202,90,81,45,42,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,283,57,58,28,29,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,341,68,71,34,36,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{0,0,120,200,60,130,25,0,1,0,0,0,0,0,0,""},{150,150,30,60,15,30,5,0,1,0,0,0,0,0,0,"7-EX1"},{434,510,120,96,60,40,10,0,1,0,0,0,0,0,0,"7-EX2"},{0,0,50,80,25,30,6,0,1,0,0,0,0,0,0,"yayale"},{50,0,50,80,25,30,6,0,1,0,0,0,0,0,0,"yayale"},{0,0,50,80,25,30,6,0,1,0,0,0,0,0,0,"yayale"},{620,0,140,360,70,180,0,0,1,0,65,70,10,230,90,"7-EX2"},{750,400,200,200,100,100,0,0,1,0,0,0,0,0,0,"7-EX2"},{0,0,400,400,200,200,0,0,1,0,0,0,0,0,0,"2-anquanquan"},{400,0,200,400,200,200,0,0,1,0,0,0,0,0,0,"2-anquanquan"},{600,0,200,400,1,200,0,0,1,0,0,0,0,0,0,"2-anquanquan"},{0,0,350,250,130,125,20,0,1,0,75,100,100,50,95,"7-EXIronMaiden"},{0,0,350,250,130,125,20,0,9,3,75,100,80,50,95,"7-EXIronMaiden"}},centerEvents=function(o,t,R)
if t==(1) then R.move(o,false,400,560,290,260) end
if t==(151) then R.move(o,false,400,560,290,260) end
if t==(270) then R.move(o,false,400,560,290,260) end
if t==(40) then R.sound("ch01") end
if t==(125) then R.sound("chainloop") end
if t==(170) then R.sound("stagexbite") end
if t==(180) then R.sound("lazerwarning") end
if t==(255) then R.sound("chainloop") end
if t==(300) then R.sound("stagexbite") end
if t==(310) then R.sound("lazerwarning") end
if t==(385) then R.sound("chainloop") end
if t==(430) then R.sound("stagexbite") end
end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["x"]=896,["y"]=0,["begin"]=1,["life"]=480,["longs"]=1100,["angle"]=180,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0.01,0,0,"正比",1)
end},
{["id"]=1,["parentid"]=0,["x"]=864,["y"]=0,["begin"]=1,["life"]=480,["longs"]=1100,["angle"]=90,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0.01,0,0,"正比",1)
end},
{["id"]=2,["parentid"]=0,["x"]=96,["y"]=0,["begin"]=1,["life"]=480,["longs"]=1100,["angle"]=90,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0.01,0,0,"正比",1)
end},
{["id"]=0,["parentid"]=0,["x"]=512,["y"]=424,["begin"]=1,["life"]=480,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=3,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(260) then R.change(o,"sonspeed",12,0,0,"正比",20) end
if t==(380) then R.change(o,"sonspeed",12,0,0,"正比",5) end
if t==(395) then R.change(o,"type",1,0,1,"正比",1) end
if t==(425) then R.change(o,"sonspeed",0.01,0,0,"正比",10) end
if t==(431) then R.change(o,"type",1,0,2,"正比",1) end
end},
{["id"]=1,["parentid"]=0,["x"]=928,["y"]=200,["begin"]=1,["life"]=480,["halfw"]=100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if (o.maskEntered or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=0,["x"]=544,["y"]=424,["begin"]=1,["life"]=480,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=3,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(470) then R.change(o,"sonspeed",5,0,0,"正比",60) end
end},
{["id"]=3,["parentid"]=0,["x"]=32,["y"]=264,["begin"]=1,["life"]=480,["halfw"]=100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if (o.maskEntered or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=0,["x"]=544,["y"]=0,["begin"]=1,["life"]=480,["halfw"]=1100,["halfh"]=20,["Circle"]=false,["type"]=1,["controlid"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if (o.maskEntered or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=200,["begin"]=170,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=176,["wscale"]=0.01,["hscale"]=0.01,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",3,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",3,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=8,["begin"]=35,["life"]=1,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=177,["wscale"]=0.01,["hscale"]=0.01,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(36) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",7,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",7,0,0,"正比",60) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=576,["y"]=264,["begin"]=1,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=178,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",180,0,2,"正比",60) end
if t==(111) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"head",90,0,2,"正比",1) end
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",24) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",24) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=512,["y"]=328,["begin"]=270,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=169,["wscale"]=0.6,["hscale"]=-0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(100) then R.change(o,"alpha",0,0,0,"正比",20) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=576,["y"]=200,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=45,["type"]=144,["wscale"]=0,["hscale"]=12,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=300,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(2) then R.change(o,"alpha",66,0,0,"正比",1) end
if t==(2) then R.change(o,"wscale",0.5,0,0,"正比",45) end
if t==(3) then R.change(o,"alpha",0,0,0,"正比",45) end
end},
{["id"]=0,["parentid"]=1,["x"]=96,["y"]=0,["begin"]=1,["life"]=480,["longs"]=1100,["angle"]=90,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0.01,0,0,"正比",1)
end},
{["id"]=1,["parentid"]=1,["x"]=64,["y"]=0,["begin"]=1,["life"]=480,["longs"]=1100,["angle"]=0,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0.01,0,0,"正比",1)
end},
{["id"]=2,["parentid"]=1,["x"]=864,["y"]=0,["begin"]=1,["life"]=480,["longs"]=1100,["angle"]=90,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0.01,0,0,"正比",1)
end},
{["id"]=0,["parentid"]=1,["x"]=416,["y"]=424,["begin"]=1,["life"]=480,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=3,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(120) then R.change(o,"sonspeed",12,0,0,"正比",20) end
if t==(240) then R.change(o,"sonspeed",12,0,0,"正比",5) end
if t==(255) then R.change(o,"type",1,0,1,"正比",1) end
if t==(285) then R.change(o,"sonspeed",0.01,0,0,"正比",10) end
if t==(290) then R.change(o,"type",1,0,2,"正比",1) end
end},
{["id"]=1,["parentid"]=1,["x"]=32,["y"]=200,["begin"]=1,["life"]=480,["halfw"]=100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if (o.maskEntered or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=1,["x"]=448,["y"]=424,["begin"]=1,["life"]=480,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=3,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(330) then R.change(o,"sonspeed",5,0,0,"正比",60) end
end},
{["id"]=3,["parentid"]=1,["x"]=416,["y"]=0,["begin"]=1,["life"]=480,["halfw"]=1100,["halfh"]=20,["Circle"]=false,["type"]=1,["controlid"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if (o.maskEntered or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=1,["x"]=928,["y"]=296,["begin"]=1,["life"]=480,["halfw"]=100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if (o.maskEntered or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=200,["begin"]=30,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=176,["wscale"]=0.01,["hscale"]=0.01,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",3,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",-3,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=8,["begin"]=35,["life"]=1,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=177,["wscale"]=0.01,["hscale"]=0.01,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(36) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",7,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",7,0,0,"正比",60) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=384,["y"]=264,["begin"]=1,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=178,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",180,0,1,"正比",60) end
if t==(111) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"head",90,0,2,"正比",1) end
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",24) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",24) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=448,["y"]=328,["begin"]=130,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=169,["wscale"]=0.6,["hscale"]=-0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(100) then R.change(o,"alpha",0,0,0,"正比",20) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=384,["y"]=200,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=45,["type"]=144,["wscale"]=0,["hscale"]=12,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=300,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",1) end
if t==(2) then R.change(o,"alpha",66,0,0,"正比",1) end
if t==(2) then R.change(o,"wscale",0.5,0,0,"正比",45) end
if t==(3) then R.change(o,"alpha",0,0,0,"正比",45) end
end},
{["id"]=0,["parentid"]=2,["x"]=96,["y"]=0,["begin"]=1,["life"]=480,["longs"]=1100,["angle"]=90,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0.01,0,0,"正比",1)
end},
{["id"]=1,["parentid"]=2,["x"]=64,["y"]=0,["begin"]=1,["life"]=480,["longs"]=1100,["angle"]=0,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0.01,0,0,"正比",1)
end},
{["id"]=2,["parentid"]=2,["x"]=864,["y"]=0,["begin"]=1,["life"]=480,["longs"]=1100,["angle"]=90,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0.01,0,0,"正比",1)
end},
{["id"]=0,["parentid"]=2,["x"]=352,["y"]=360,["begin"]=1,["life"]=480,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=3,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(120) then R.change(o,"sonspeed",12,0,0,"正比",20) end
if t==(210) then R.change(o,"sonspeed",13,0,0,"正比",5) end
if t==(255) then R.change(o,"sonspeed",0.01,0,0,"正比",10) end
if t==(300) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=2,["x"]=608,["y"]=360,["begin"]=1,["life"]=480,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=6,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(260) then R.change(o,"sonspeed",12,0,0,"正比",20) end
if t==(350) then R.change(o,"sonspeed",13,0,0,"正比",5) end
if t==(395) then R.change(o,"sonspeed",0.01,0,0,"正比",10) end
if t==(440) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=352,["y"]=552,["begin"]=180,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=8,["wscale"]=0,["longs"]=100,["alpha"]=66,["Ray"]="Ray",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=false,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=false,["colorR"]=255,["colorG"]=1,["colorB"]=1,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.6,0,0,"正比",20) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=5,["Bindwithspeedd"]=true,["x"]=352,["y"]=584,["begin"]=320,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=8,["wscale"]=0,["longs"]=100,["alpha"]=66,["Ray"]="Ray",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=false,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=false,["colorR"]=255,["colorG"]=1,["colorB"]=1,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.6,0,0,"正比",20) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=384,["y"]=552,["begin"]=180,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=8,["wscale"]=0,["longs"]=100,["alpha"]=66,["Ray"]="Ray",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=false,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.6,0,0,"正比",20) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=5,["Bindwithspeedd"]=true,["x"]=384,["y"]=584,["begin"]=320,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=8,["wscale"]=0,["longs"]=100,["alpha"]=66,["Ray"]="Ray",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=false,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.6,0,0,"正比",20) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=200,["begin"]=30,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=176,["wscale"]=0.01,["hscale"]=0.01,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",3,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",-3,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=8,["begin"]=35,["life"]=1,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=177,["wscale"]=0.01,["hscale"]=0.01,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(36) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",7,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",7,0,0,"正比",60) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=352,["y"]=264,["begin"]=1,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=147,["wscale"]=0,["hscale"]=0,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",180,0,1,"正比",60) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",12) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",12) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=352,["y"]=488,["begin"]=285,["life"]=2,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=130,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1210,["type"]=140,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,0,0,"正比",2) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=200,["begin"]=170,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=176,["wscale"]=0.01,["hscale"]=0.01,["colorR"]=255,["colorG"]=155,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",3,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",3,0,0,"正比",60) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=true,["x"]=608,["y"]=264,["begin"]=1,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=147,["wscale"]=0,["hscale"]=0,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",180,0,2,"正比",60) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",12) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",12) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=5,["Bindwithspeedd"]=true,["x"]=608,["y"]=488,["begin"]=425,["life"]=2,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=130,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1210,["type"]=140,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,0,0,"正比",2) end
end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=true,["x"]=384,["y"]=488,["begin"]=285,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=130,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=5,["Bindwithspeedd"]=true,["x"]=576,["y"]=488,["begin"]=425,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=130,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end}
}}
