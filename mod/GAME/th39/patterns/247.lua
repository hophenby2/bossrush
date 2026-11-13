return {["id"]="247",["total"]=360,["order"]=0,["centerAvailable"]=true,["center"]={480,260,0,0,0,0},["types"]={{0,0,40,550,20,275,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{40,0,182,204,92,102,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{40,204,331,335,166,173,16,0,1,0,0,0,0,0,0,"2BOSS-fw"},{371,139,282,295,141,147,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{653,139,320,335,160,168,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{973,139,43,42,22,21,5,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1016,139,96,91,48,46,11,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1112,139,65,63,33,32,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1177,139,69,40,35,20,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1246,139,54,83,27,42,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1300,139,28,40,14,20,0,0,1,0,0,0,0,0,0,""},{973,230,164,166,82,83,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,202,90,81,45,42,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,283,57,58,28,29,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{1137,341,68,71,34,36,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{222,0,230,139,115,70,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{452,0,230,139,139,70,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{682,0,230,139,139,70,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{912,0,230,139,139,70,0,0,1,0,0,0,0,0,0,"2BOSS-fw"},{0,0,120,200,60,130,25,0,1,0,0,0,0,0,0,"xuezhu"},{0,0,40,180,20,170,0,0,1,0,0,0,0,0,0,"marisashoot1"}},centerEvents=function(o,t,R)
if t==(1) then R.move(o,false,420,540,210,260) end
if t==(90) then R.sound("ch01") end
if t==(170) then R.sound("stage2bloodpole") end
if t==(330) then R.sound("iainuki") end
if t==(311) then R.sound("lazer00") end
if t==(321) then R.sound("lazer00") end
if t==(331) then R.sound("lazer00") end
end,globalEvents=function(c,t,R)
if t==179 then R.jump(c,2,1,0) end
if t==180 then R.quake(c,160,3) end
end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=250,["life"]=48,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=24,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=96,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",2,0,1,"正比",60) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"r",620,0,0,"正比",60) end
if t==(1+math.floor(t/10)*10) then R.change(o,"tiao",7,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,1,"正比",8) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",8) end
if t==(60) then R.change(o,"alpha",90,0,0,"正比",2) end
if t==(72) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(62) then R.change(o,"hscale",0.2,0,0,"正比",30) end
if t==(72) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(60) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(60) then R.change(o,"colorG",255,0,0,"正比",1) end
if t==(60) then R.change(o,"hscale",1,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["x"]=160,["y"]=40,["begin"]=1,["life"]=360,["longs"]=900,["angle"]=0,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0,0,0,"正比",1)
end},
{["id"]=1,["parentid"]=1,["x"]=192,["y"]=40,["begin"]=1,["life"]=360,["longs"]=900,["angle"]=90,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0,0,0,"正比",1)
end},
{["id"]=2,["parentid"]=1,["x"]=768,["y"]=40,["begin"]=1,["life"]=360,["longs"]=900,["angle"]=90,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0,0,0,"正比",1)
end},
{["id"]=3,["parentid"]=1,["x"]=800,["y"]=704,["begin"]=1,["life"]=360,["longs"]=900,["angle"]=180,["time"]=1,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["oneSide"]=false,["kind"]="rebound",Parentevents=function(o,t,R)
R.change(o,"sonspeed",0,0,0,"正比",1)
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=576,["y"]=328,["begin"]=91,["life"]=1,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=70,["type"]=8,["wscale"]=0.1,["longs"]=100,["alpha"]=88,["Ray"]="Ray",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["colorR"]=255,["colorG"]=255,["colorB"]=255,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1.3,0,0,"正比",18) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=256,["y"]=200,["begin"]=1,["life"]=120,["fx"]=-99998,["fy"]=168,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=171,["wscale"]=0.5,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=35,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(101) then R.change(o,"wscale",0.1,0,0,"正比",20) end
if t==(101) then R.change(o,"alpha",30,0,0,"正比",20) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0,0.16,1,"正比",1) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=256,["y"]=136,["begin"]=1,["life"]=360,["fx"]=-99998,["fy"]=168,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=280,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=10,["type"]=172,["wscale"]=0.8,["hscale"]=0.5,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,30,1,"正比",10) end
if t==(1) then R.change(o,"hscale",0.4,0.2,1,"正比",5) end
if t==(6) then R.change(o,"hscale",0.3,0,0,"正比",5) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=256,["y"]=168,["begin"]=1,["life"]=360,["fx"]=-99998,["fy"]=168,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=280,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=10,["type"]=172,["wscale"]=1,["hscale"]=0.3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=60,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,30,1,"正比",10) end
if t==(1) then R.change(o,"hscale",0.3,0.1,1,"正比",5) end
if t==(6) then R.change(o,"hscale",0.3,0,0,"正比",5) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=true,["x"]=352,["y"]=168,["begin"]=31,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=148,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=90,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",0,0,0,"正比",30) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=true,["x"]=416,["y"]=168,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=65,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=20,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=288,["y"]=264,["begin"]=1,["life"]=360,["fx"]=-99998,["fy"]=-99998,["r"]=90,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=6,["type"]=2,["wscale"]=0.6,["hscale"]=0.3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=80,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/130)*130) then R.change(o,"fdirection",4399,0,1,"正弦",130) end
if t==(1+math.floor(t/130)*130) then R.change(o,"rdirection",4399,0,1,"正弦",130) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",2,0,0,"正比",12) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=5,["life"]=99,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=148,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1111) then R.change(o,"fx","自机",0,0,"正比",1) end
if t==(1111) then R.change(o,"fy","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(6) then R.change(o,"fdirection",750,0,1,"正比",99) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"head",360,0,1,"正比",60) end
if t==(1) then R.change(o,"sonspeedd",20,0,1,"正比",1) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=6,["Bindwithspeedd"]=true,["x"]=448,["y"]=424,["begin"]=120,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=144,["wscale"]=0.1,["hscale"]=29,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"colorG",255,0,0,"正比",24) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",30) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=5,["life"]=99,["fx"]=480,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=16,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=10,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1111) then R.change(o,"fx","自机",0,0,"正比",1) end
if t==(1111) then R.change(o,"fy","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(6) then R.change(o,"fdirection",750,0,1,"正比",99) end
end,Sonevents=function(o,t,R)
if t==(10) then R.change(o,"sonspeed",7,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",20,0,1,"正比",1) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=270,["life"]=60,["fx"]=-99998,["fy"]=264,["r"]=300,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=117,["type"]=152,["wscale"]=0.01,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(5) then R.change(o,"tiao",2,0,0,"正比",1) end
if t==(5) then R.change(o,"range",700,0,0,"正比",55) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(86) then R.change(o,"wscale",0.1,0,0,"正比",30) end
if t==(61) then R.change(o,"alpha",100,0,0,"正比",2) end
if t==(61) then R.change(o,"wscale",1,0,0,"正比",6) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",12) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=512,["y"]=296,["begin"]=61,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=26,["type"]=18,["wscale"]=0.4,["hscale"]=1,["colorR"]=255,["colorG"]=222,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",16,0,0,"正比",9) end
if t==(13) then R.change(o,"wscale",0.1,0,0,"正比",13) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=270,["life"]=60,["fx"]=-99998,["fy"]=264,["r"]=300,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=152,["wscale"]=0.01,["hscale"]=1.3,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(5) then R.change(o,"tiao",2,0,0,"正比",1) end
if t==(5) then R.change(o,"range",700,0,0,"正比",55) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.3,0,0,"正比",15) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=250,["life"]=48,["fx"]=-99998,["fy"]=264,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=24,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=18,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"r",620,0,0,"正比",60) end
if t==(1) then R.change(o,"fdirection","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",2.5,0,1,"正比",60) end
if t==(1+math.floor(t/10)*10) then R.change(o,"tiao",7,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,1,"正比",8) end
if t==(1) then R.change(o,"hscale",0.4,0,0,"正比",8) end
if t==(62) then R.change(o,"alpha",100,0,0,"正比",2) end
if t==(72) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(72) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(70) then R.change(o,"Blend",1,0,0,"正比",1) end
if t==(70) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(70) then R.change(o,"colorG",255,0,0,"正比",1) end
if t==(62) then R.change(o,"hscale",0.1,0,0,"正比",30) end
end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=288,["y"]=360,["begin"]=60,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1320,["type"]=140,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",5) end
if t==(1) then R.change(o,"sonspeed",2,0,1,"正比",120) end
if t==(20) then R.change(o,"alpha",100,0,0,"正比",13) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",5) end
if t==(1) then R.change(o,"colorB",1,0,0,"正比",5) end
if t==(1) then R.change(o,"colorG",1,0,0,"正比",5) end
end}
}}
