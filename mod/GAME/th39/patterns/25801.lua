return {["id"]="25801",["total"]=600,["order"]=0,["centerAvailable"]=true,["center"]={480,260,0,0,0,0},["types"]={{0,0,40,550,20,275,10,0,1,0,0,0,0,0,0,"2BOSS-fw"},{40,0,182,204,92,102,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{40,204,331,335,166,173,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{371,139,282,295,141,147,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{653,139,320,335,160,168,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{973,139,43,42,22,21,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1016,139,96,91,48,46,15,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1112,139,65,63,33,32,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1177,139,69,40,35,20,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1246,139,54,83,27,42,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1300,139,28,40,14,20,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{973,230,164,166,82,83,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,202,90,81,45,42,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,283,57,58,28,29,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,341,68,71,34,36,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{222,0,230,139,115,70,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{452,0,230,139,139,70,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{682,0,230,139,139,70,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{912,0,230,139,139,70,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{0,0,68,94,34,30,0,0,1,0,0,0,0,0,0,"testfire3"},{0,94,68,94,34,30,0,0,1,0,0,0,0,0,0,"testfire3"},{0,188,68,94,34,30,0,0,1,0,0,0,0,0,0,"testfire3"},{0,282,68,94,34,30,0,0,1,0,0,0,0,0,0,"testfire3"},{0,0,36,179,18,170,0,0,1,0,0,0,0,0,0,"marisashoot2"},{0,0,120,200,60,100,30,0,1,0,0,0,0,0,0,"xuezhu"},{0,0,200,200,100,100,0,0,1,0,0,0,0,0,0,"Jifeijiantou"},{0,0,156,904,78,904,0,0,1,0,0,0,0,0,0,"yujingxian1"},{0,0,30,300,15,300,0,0,1,0,0,0,0,0,0,"jituidian"}},centerEvents=function(o,t,R)
if t==(61) then R.follow(o,"X") end
if t==(61) then R.follow(o,"Y") end
if t==(301) then R.follow(o,"X") end
if t==(301) then R.follow(o,"Y") end
if t==(1510) then R.move(o,false,420,540,220,260) end
end,globalEvents=function(c,t,R)
if t==179 then R.jump(c,2,1,0) end
if t==120 then R.quake(c,30,6) end
if t==360 then R.quake(c,30,7) end
end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=448,["y"]=488,["begin"]=61,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=8,["wscale"]=0.01,["longs"]=100,["alpha"]=55,["Ray"]="Ray",["sonspeed"]=27,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=true,["Invincible"]=false,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",3) end
if t==(3) then R.change(o,"wscale",2,0,0,"正比",20) end
end},
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=168,["begin"]=112,["life"]=241,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=240,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.3,0,0,"正比",5) end
if t==(5) then R.change(o,"type",1,0,2,"正比",1) end
if t==(1) then R.change(o,"wscale",1.3,0,0,"正比",5) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=104,["begin"]=112,["life"]=240,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=240,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=156,["wscale"]=3,["hscale"]=3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=416,["y"]=200,["begin"]=1,["life"]=60,["fx"]=480,["fy"]=264,["r"]=100,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=140,["type"]=163,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(5) then R.change(o,"t",6,0,0,"正比",1) end
if t==(30) then R.change(o,"t",13,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,0,"正比",5) end
if t==(1) then R.change(o,"type",2,2,1,"正比",1) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",5) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",20) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=104,["begin"]=112,["life"]=240,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=240,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",6,0,0,"正比",15) end
if t==(1) then R.change(o,"hscale",6,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",15) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=104,["begin"]=112,["life"]=240,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=240,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=7,["type"]=96,["wscale"]=6,["hscale"]=6,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",16,0,0,"正比",7) end
if t==(1) then R.change(o,"hscale",16,0,0,"正比",7) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",7) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=168,["begin"]=112,["life"]=241,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=240,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.3,0,0,"正比",5) end
if t==(5) then R.change(o,"type",1,0,2,"正比",1) end
if t==(1) then R.change(o,"wscale",1.3,0,0,"正比",5) end
if t==(1) then R.change(o,"alpha",0,0,0,"正比",60) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=360,["begin"]=121,["life"]=6,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=17,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=241,["type"]=158,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",6,0,2,"正比",6) end
if t==(1) then R.change(o,"tiao",6,0,2,"正比",6) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0,1,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,30,1,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",171) end
if t==(181) then R.change(o,"xscale",0.01,0,0,"正比",1) end
if t==(181) then R.change(o,"yscale",0.01,0,0,"正比",1) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.02,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.02,0,2,"无缝正弦",30) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=448,["y"]=424,["begin"]=121,["life"]=310,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=176,["wscale"]=0.5,["hscale"]=0.2,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=21,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=3,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(160) then R.change(o,"wscale",0.1,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,0,"正比",13) end
if t==(1) then R.change(o,"sonspeed",0,3,1,"正比",1) end
if t==(1) then R.change(o,"wscale",0,0.1,1,"正比",1) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=false,["x"]=448,["y"]=360,["begin"]=301,["life"]=1,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=310,["type"]=158,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd","自机",0,0,"正比",1) end
if t==(122) then R.change(o,"sonspeed",2,1,0,"正比",121) end
if t==(2) then R.change(o,"sonspeedd",180,0,1,"正比",1) end
if t==(182) then R.change(o,"alpha",1,0,0,"正比",61) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.02,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.02,0,2,"无缝正弦",30) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=480,["y"]=424,["begin"]=421,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=22,["type"]=175,["wscale"]=0.6,["hscale"]=0,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeedd",0,30,1,"正比",21) end
if t==(1) then R.change(o,"sonspeedd",0,120,1,"正比",1) end
if t==(16) then R.change(o,"hscale",0.1,0,0,"正比",5) end
if t==(1) then R.change(o,"hscale",0.5,0.2,0,"正比",15) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=512,["y"]=424,["begin"]=421,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=22,["type"]=175,["wscale"]=0.4,["hscale"]=0,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(120) then R.change(o,"wscale",0.2,0,0,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeedd",0,30,1,"正比",21) end
if t==(1) then R.change(o,"sonspeedd",0,150,1,"正比",1) end
if t==(16) then R.change(o,"wscale",0.1,0,0,"正比",5) end
if t==(1) then R.change(o,"hscale",0.4,0.1,0,"正比",15) end
if t==(16) then R.change(o,"hscale",0.1,0,0,"正比",5) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=544,["y"]=424,["begin"]=421,["life"]=180,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=157,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=95,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/8)*8) then R.change(o,"hscale",0.2,0,1,"无缝正弦",8) end
if t==(1+math.floor(t/8)*8) then R.change(o,"wscale",0.2,0,1,"无缝正弦",8) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeed",0.01,0,0,"正比",31) end
if t==(1) then R.change(o,"sonspeedd",0,360,1,"正比",1) end
if t==(20) then R.change(o,"hscale",0.1,0,0,"正比",10) end
if t==(20) then R.change(o,"wscale",0.1,0,0,"正比",10) end
if t==(1) then R.change(o,"sonspeed",3,1,0,"正比",1) end
end},
{["id"]=12,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=360,["begin"]=121,["life"]=6,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=9,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=149,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",4,0,2,"正比",6) end
if t==(1) then R.change(o,"tiao",6,0,2,"正比",6) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0,1,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,360,1,"正比",120) end
if t==(2) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(152) then R.change(o,"sonspeed",2,0,1,"正比",121) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.02,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.02,0,2,"无缝正弦",30) end
end},
{["id"]=13,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=360,["begin"]=361,["life"]=6,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=9,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=800,["type"]=149,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",4,0,2,"正比",6) end
if t==(1) then R.change(o,"tiao",6,0,2,"正比",6) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0,1,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,360,1,"正比",120) end
if t==(2) then R.change(o,"sonspeed",0.5,0,0,"正比",121) end
if t==(152) then R.change(o,"sonspeed",2,0,1,"正比",121) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.02,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.02,0,2,"无缝正弦",30) end
end},
{["id"]=14,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=264,["begin"]=1,["life"]=330,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=93,["wscale"]=6,["hscale"]=6,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(60) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"fx","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",60,0,0,"正比",60) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=232,["begin"]=390,["life"]=150,["fx"]=480,["fy"]=264,["r"]=60,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=139,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",300,0,2,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",860,0,1,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=264,["begin"]=390,["life"]=150,["fx"]=480,["fy"]=264,["r"]=60,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=81,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"rdirection",300,0,2,"正比",120) end
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",860,0,1,"正比",120) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",4,0,0,"正比",30) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=608,["y"]=232,["begin"]=600,["life"]=1,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=37,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1600,["type"]=110,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=640,["y"]=232,["begin"]=120,["life"]=1,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=27,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1600,["type"]=110,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=672,["y"]=232,["begin"]=360,["life"]=1,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=27,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1600,["type"]=110,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end}
}}
