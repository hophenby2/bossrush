return {["id"]="244",["total"]=560,["order"]=1,["centerAvailable"]=true,["center"]={480,260,0,0,0,0},["types"]={{40,0,182,204,92,102,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{40,204,331,335,166,173,16,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{371,139,282,295,141,147,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{653,139,320,335,160,168,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{973,139,43,42,22,21,5,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{1016,139,96,91,48,46,11,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{973,230,164,166,82,83,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{1137,202,90,81,45,42,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{1137,283,57,58,28,29,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{1137,341,68,71,34,36,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{0,0,156,904,78,450,0,0,1,0,0,0,0,0,0,"yujingxian1"},{0,0,156,904,78,450,0,0,1,0,0,0,0,0,0,"yujingxian2"}},centerEvents=function(o,t,R)
if t==(91) then R.move(o,true,420,540,220,180) end
if t==(240) then R.move(o,true,420,540,200,180) end
if t==(420) then R.move(o,true,420,540,200,180) end
if t==(160) then R.sound("stage2claw") end
if t==(180) then R.sound("stage2claw") end
if t==(190) then R.sound("stage2claw") end
if t==(200) then R.sound("stage2claw") end
if t==(310) then R.sound("stage2claw") end
if t==(330) then R.sound("stage2claw") end
if t==(340) then R.sound("stage2claw") end
if t==(350) then R.sound("stage2claw") end
if t==(460) then R.sound("stage2claw") end
if t==(480) then R.sound("stage2claw") end
if t==(490) then R.sound("stage2claw") end
if t==(500) then R.sound("stage2claw") end
end,globalEvents=function(c,t,R)
if t==179 then R.jump(c,2,1,0) end
end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=352,["y"]=40,["begin"]=1,["life"]=6,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=162,["wscale"]=0.05,["longs"]=1000,["alpha"]=20,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=false,["Invincible"]=true,["segment"]=120,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",120,0,2,"正比",15) end
if t==(1) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(11) then R.change(o,"sonspeed",0.5,0,0,"正比",10) end
if t==(190) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(120) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",30) end
if t==(30) then R.change(o,"alpha",30,0,0,"正比",30) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=352,["y"]=136,["begin"]=1,["life"]=6,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=170,["type"]=82,["wscale"]=1.3,["longs"]=1300,["alpha"]=100,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=120,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeedd",120,0,2,"正比",15) end
if t==(121) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(131) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(166) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=352,["y"]=168,["begin"]=1,["life"]=6,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=170,["type"]=139,["wscale"]=4,["longs"]=1300,["alpha"]=55,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeedd",120,0,2,"正比",15) end
if t==(121) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(131) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(170) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=384,["y"]=40,["begin"]=1,["life"]=6,["r"]=130,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=-130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=162,["wscale"]=0.05,["longs"]=1000,["alpha"]=20,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=false,["Invincible"]=true,["segment"]=120,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",120,0,1,"正比",15) end
if t==(1) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(11) then R.change(o,"sonspeed",1,0,0,"正比",10) end
if t==(121) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(190) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(30) then R.change(o,"alpha",30,0,0,"正比",30) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",30) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=384,["y"]=136,["begin"]=1,["life"]=6,["r"]=130,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=82,["wscale"]=1.3,["longs"]=1300,["alpha"]=100,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=120,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeedd",120,0,1,"正比",15) end
if t==(121) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(131) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(160) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=384,["y"]=168,["begin"]=1,["life"]=6,["r"]=130,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=-130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=170,["type"]=139,["wscale"]=4,["longs"]=1300,["alpha"]=55,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(121) then R.change(o,"sonspeedd",120,0,1,"正比",15) end
if t==(121) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(131) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(180) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=true,["x"]=608,["y"]=424,["begin"]=1,["life"]=6,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=163,["wscale"]=0.1,["longs"]=1000,["alpha"]=22,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=false,["Invincible"]=true,["segment"]=120,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",120,0,2,"正比",15) end
if t==(1) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(11) then R.change(o,"sonspeed",0.5,0,0,"正比",10) end
if t==(190) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(120) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",0.66,0,0,"正比",30) end
if t==(60) then R.change(o,"alpha",66,0,0,"正比",30) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=352,["y"]=424,["begin"]=1,["life"]=6,["r"]=130,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=-130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=163,["wscale"]=0.1,["longs"]=1000,["alpha"]=22,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=false,["Outdispel"]=false,["Invincible"]=true,["segment"]=120,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",120,0,1,"正比",15) end
if t==(1) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(11) then R.change(o,"sonspeed",1,0,0,"正比",10) end
if t==(121) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(190) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.66,0,0,"正比",30) end
if t==(60) then R.change(o,"alpha",66,0,0,"正比",30) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=352,["y"]=72,["begin"]=1,["life"]=6,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=162,["wscale"]=0.05,["longs"]=1000,["alpha"]=60,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=120,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",120,0,2,"正比",15) end
if t==(1) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(11) then R.change(o,"sonspeed",0.5,0,0,"正比",10) end
if t==(190) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(120) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",30) end
if t==(30) then R.change(o,"alpha",40,0,0,"正比",30) end
end},
{["id"]=9,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=384,["y"]=72,["begin"]=1,["life"]=6,["r"]=130,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=-130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=162,["wscale"]=0.05,["longs"]=1000,["alpha"]=60,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=120,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",120,0,1,"正比",15) end
if t==(1) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(11) then R.change(o,"sonspeed",1,0,0,"正比",10) end
if t==(121) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(190) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(30) then R.change(o,"alpha",40,0,0,"正比",30) end
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",30) end
end},
{["id"]=10,["parentid"]=0,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=320,["y"]=424,["begin"]=1,["life"]=6,["r"]=130,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=-130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=163,["wscale"]=0.1,["longs"]=1000,["alpha"]=22,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=120,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",120,0,1,"正比",15) end
if t==(1) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(11) then R.change(o,"sonspeed",1,0,0,"正比",10) end
if t==(121) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(190) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.66,0,0,"正比",30) end
if t==(60) then R.change(o,"alpha",66,0,0,"正比",30) end
end},
{["id"]=11,["parentid"]=0,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=true,["x"]=640,["y"]=424,["begin"]=1,["life"]=6,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=163,["wscale"]=0.1,["longs"]=1000,["alpha"]=22,["Ray"]="Curve",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=true,["segment"]=120,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=true,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",120,0,2,"正比",15) end
if t==(1) then R.change(o,"sonspeed",100,0,0,"正比",10) end
if t==(11) then R.change(o,"sonspeed",0.5,0,0,"正比",10) end
if t==(190) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(120) then R.change(o,"sonspeed",30,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",0.66,0,0,"正比",30) end
if t==(60) then R.change(o,"alpha",66,0,0,"正比",30) end
end},
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=512,["y"]=424,["begin"]=31,["life"]=320,["fx"]=-99998,["fy"]=-99998,["r"]=550,["rdirection"]=215,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=350,["fdirection"]=-20,["fdirections"]={0.0,0.0},["range"]=160,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=6,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.fire(o) end
if t==(10+math.floor(t/150)*150) then R.fire(o) end
if t==(20+math.floor(t/150)*150) then R.fire(o) end
if t==(1+math.floor(t/30)*30) then R.change(o,"r",50,0,2,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"rdirection",22,0,2,"无缝正弦",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",40,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=448,["y"]=424,["begin"]=47,["life"]=321,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=325,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=350,["fdirection"]=210,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=6,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.fire(o) end
if t==(10+math.floor(t/150)*150) then R.fire(o) end
if t==(20+math.floor(t/150)*150) then R.fire(o) end
if t==(1+math.floor(t/30)*30) then R.change(o,"r",50,0,2,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"rdirection",22,0,1,"无缝正弦",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",40,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=390,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=10,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=0.7,["yscale"]=1.3,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"sonspeedd","自机",0,0,"正比",1) end
if t==(40) then R.change(o,"sonspeed",0,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=416,["y"]=424,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4,["type"]=6,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",40,0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=544,["y"]=424,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=4,["type"]=6,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",40,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=30,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=450,["type"]=148,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",630,0,1,"正比",100) end
if t==(1) then R.change(o,"sonspeed",6,0,2,"正比",100) end
if t==(1) then R.change(o,"fdirection",630,0,1,"正比",100) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/66)*66) then R.change(o,"head",1111,0,2,"正比",66) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",12) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",12) end
if t==(61) then R.change(o,"sonspeed",5,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=35,["life"]=1,["fx"]=480,["fy"]=264,["r"]=30,["rdirection"]=160,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=160,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=410,["type"]=148,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"rdirection",630,0,2,"正比",100) end
if t==(1) then R.change(o,"sonspeed",6,0,2,"正比",100) end
if t==(1) then R.change(o,"fdirection",630,0,2,"正比",100) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/66)*66) then R.change(o,"head",1111,0,2,"正比",66) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",12) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",12) end
if t==(61) then R.change(o,"sonspeed",5,0,0,"正比",60) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=488,["begin"]=21,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=3,["fdirection"]=-13,["fdirections"]={0.0,0.0},["range"]=9,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1280,["type"]=110,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",7,0,1,"正弦",240) end
if t==(1) then R.change(o,"fdirection",9,0,1,"正比",60) end
if t==(1+math.floor(t/9)*9) then R.change(o,"hscale",0.2,0,1,"正弦",8) end
if t==(1+math.floor(t/9)*9) then R.change(o,"wscale",0.2,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.8,0,0,"正比",6) end
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",6) end
if t==(1) then R.change(o,"sonspeedd",0,1,1,"正比",5) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
if t==(1) then R.change(o,"colorR",255,0,0,"正比",13) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=480,["y"]=488,["begin"]=21,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=3,["fdirection"]=13,["fdirections"]={0.0,0.0},["range"]=9,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1280,["type"]=110,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",7,0,1,"正弦",240) end
if t==(1) then R.change(o,"fdirection",9,0,2,"正比",60) end
if t==(1+math.floor(t/9)*9) then R.change(o,"hscale",0.2,0,1,"正弦",8) end
if t==(1+math.floor(t/9)*9) then R.change(o,"wscale",0.2,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,1,1,"正比",6) end
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",6) end
if t==(1) then R.change(o,"hscale",0.8,0,0,"正比",6) end
if t==(1) then R.change(o,"colorR",255,0,0,"正比",13) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=441,["life"]=120,["fx"]=-99998,["fy"]=225,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=15,["wscale"]=0.9,["hscale"]=0.7,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.013,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"sonaspeedd",60,0,1,"无缝正弦",30) end
if t==(1) then R.change(o,"hscale",0.8,0,1,"正弦",180) end
if t==(1) then R.change(o,"sonspeed",1.7,0,1,"正弦",180) end
end,Sonevents=function(o,t,R)
if t==(21) then R.change(o,"wscale",0.5,0,0,"正比",60) end
if t==(21) then R.change(o,"hscale",0.8,0,0,"正比",60) end
if t==(50) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",99,0,0,"正比",20) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=296,["begin"]=471,["life"]=40,["fx"]=480,["fy"]=210,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=149,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=30,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"fdirection",630,0,1,"正比",100) end
if t==(1+math.floor(t/9)*9) then R.change(o,"sonspeed",0.5,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)
if t==(31) then R.change(o,"sonspeed",0.8,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",0,90,1,"正比",90) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=328,["begin"]=440,["life"]=40,["fx"]=480,["fy"]=210,["r"]=0,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=310,["type"]=149,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=30,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"fdirection",630,0,2,"正比",100) end
if t==(1+math.floor(t/9)*9) then R.change(o,"sonspeed",0.5,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)
if t==(31) then R.change(o,"sonspeed",0.8,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",0,90,1,"正比",60) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=352,["y"]=360,["begin"]=418,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=158,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=90,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(3) then R.change(o,"sonspeed",0.01,0,0,"正比",2) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",5) end
if t==(60) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",5,5,0,"正比",1) end
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=false,["x"]=384,["y"]=360,["begin"]=308,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=158,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=90,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(3) then R.change(o,"sonspeed",0.01,0,0,"正比",2) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",5) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",5) end
if t==(60) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(1) then R.change(o,"sonspeed",5,5,0,"正比",1) end
if t==(1) then R.change(o,"head",0,360,0,"正比",1) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=61,["life"]=1,["fx"]=-99998,["fy"]=210,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=5,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=100,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=148,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.5,0,0,"正比",120) end
if t==(41) then R.change(o,"wscale",0.6,0,0,"正比",18) end
if t==(41) then R.change(o,"hscale",0.6,0,0,"正比",18) end
if t==(41) then R.change(o,"alpha",90,0,0,"正比",5) end
if t==(1+math.floor(t/60)*60) then R.change(o,"head",360,0,1,"正比",60) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=true,["x"]=544,["y"]=200,["begin"]=90,["life"]=240,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=430,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=65,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(181) then R.change(o,"sonspeed",3,0,2,"正比",60) end
if t==(1) then R.change(o,"sonspeed",4,0,1,"正比",180) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=60,["life"]=1,["fx"]=-99998,["fy"]=210,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=1,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=240,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=110,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",-1,0,0,"正比",120) end
end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=416,["y"]=264,["begin"]=70,["life"]=1,["fx"]=480,["fy"]=210,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=149,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=30,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.4,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(61) then R.change(o,"sonspeed",2.5,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",0,90,1,"正比",90) end
end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=136,["begin"]=441,["life"]=120,["fx"]=-99998,["fy"]=225,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=888,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=15,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0.013,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"sonaspeedd",60,0,1,"无缝正弦",30) end
if t==(1) then R.change(o,"sonspeed",1.7,0,1,"正弦",180) end
if t==(30) then R.change(o,"t",3,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=9,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=104,["begin"]=440,["life"]=121,["fx"]=-99998,["fy"]=210,["r"]=60,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=13,["t"]=60,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=240,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=110,["wscale"]=0,["hscale"]=0,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正比",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",12) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=320,["y"]=264,["begin"]=2,["life"]=15,["fx"]=480,["fy"]=210,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=-10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=139,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.7,0,2,"正比",15) end
if t==(1) then R.change(o,"fdirection",120,0,1,"正比",15) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.3,0,2,"正比",60) end
end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=232,["begin"]=151,["life"]=405,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=6,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.fire(o) end
if t==(21+math.floor(t/150)*150) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=320,["y"]=296,["begin"]=1,["life"]=15,["fx"]=480,["fy"]=210,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=-10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=81,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.7,0,2,"正比",15) end
if t==(1) then R.change(o,"fdirection",120,0,1,"正比",15) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.3,0,2,"正比",60) end
end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=232,["begin"]=141,["life"]=420,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9999,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=6,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/150)*150) then R.fire(o) end
if t==(21+math.floor(t/150)*150) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=352,["y"]=264,["begin"]=2,["life"]=15,["fx"]=480,["fy"]=210,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=139,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.7,0,2,"正比",15) end
if t==(1) then R.change(o,"fdirection",120,0,2,"正比",15) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.3,0,2,"正比",60) end
end},
{["id"]=5,["parentid"]=3,["Binding"]=false,["bindid"]=3,["Bindwithspeedd"]=true,["x"]=352,["y"]=296,["begin"]=1,["life"]=15,["fx"]=480,["fy"]=210,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=10,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=81,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.7,0,2,"正比",15) end
if t==(1) then R.change(o,"fdirection",120,0,2,"正比",15) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1.3,0,2,"正比",60) end
end}
}}
