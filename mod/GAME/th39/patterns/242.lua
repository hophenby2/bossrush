return {["id"]="242",["total"]=360,["order"]=0,["centerAvailable"]=true,["center"]={480,260,0,0,0,0},["types"]={{40,0,182,204,92,102,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{40,204,331,335,166,173,16,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{371,139,282,295,141,147,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{653,139,320,335,160,168,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{973,139,43,42,22,21,5,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{1016,139,96,91,48,46,11,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{973,230,164,166,82,83,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{1137,202,90,81,45,42,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{1137,283,57,58,28,29,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"},{1137,341,68,71,34,36,0,0,1,0,0,0,0,0,0,"2BOSS-fw2"}},centerEvents=function(o,t,R)
if t==(1) then R.move(o,true,320,540,240,260) end
if t==(90) then R.move(o,true,320,540,240,260) end
if t==(180) then R.move(o,true,420,640,240,260) end
if t==(270) then R.move(o,true,420,640,240,260) end
end,globalEvents=function(c,t,R)
if t==179 then R.jump(c,2,1,0) end
end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=1,["life"]=100,["fx"]=-99998,["fy"]=-99998,["r"]=30,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1120,["type"]=148,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
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
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=264,["begin"]=185,["life"]=100,["fx"]=480,["fy"]=264,["r"]=30,["rdirection"]=160,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=160,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1120,["type"]=148,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
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
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=448,["y"]=488,["begin"]=21,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=3,["fdirection"]=-13,["fdirections"]={0.0,0.0},["range"]=9,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1280,["type"]=110,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",7,0,1,"正弦",240) end
if t==(1) then R.change(o,"fdirection",13,0,1,"正比",60) end
if t==(1+math.floor(t/9)*9) then R.change(o,"hscale",0.2,0,1,"正弦",8) end
if t==(1+math.floor(t/9)*9) then R.change(o,"wscale",0.2,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.8,0,0,"正比",6) end
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",6) end
if t==(1) then R.change(o,"sonspeedd",0,1,1,"正比",5) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
if t==(1) then R.change(o,"colorR",255,0,0,"正比",13) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=480,["y"]=488,["begin"]=21,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=3,["fdirection"]=13,["fdirections"]={0.0,0.0},["range"]=9,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1280,["type"]=110,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",7,0,1,"正弦",240) end
if t==(1) then R.change(o,"fdirection",13,0,2,"正比",60) end
if t==(1+math.floor(t/9)*9) then R.change(o,"hscale",0.2,0,1,"正弦",8) end
if t==(1+math.floor(t/9)*9) then R.change(o,"wscale",0.2,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,1,1,"正比",6) end
if t==(1) then R.change(o,"wscale",0.8,0,0,"正比",6) end
if t==(1) then R.change(o,"hscale",0.8,0,0,"正比",6) end
if t==(1) then R.change(o,"colorR",255,0,0,"正比",13) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=120,["life"]=241,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=31,["t"]=180,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=400,["type"]=111,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=264,["begin"]=1,["life"]=120,["fx"]=480,["fy"]=264,["r"]=50,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=20,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=139,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"rdirection",630,0,1,"正比",100) end
if t==(1+math.floor(t/100)*100) then R.change(o,"fdirection",630,0,1,"正比",100) end
if t==(1+math.floor(t/9)*9) then R.change(o,"sonspeed",0.5,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=296,["begin"]=185,["life"]=120,["fx"]=480,["fy"]=264,["r"]=50,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=20,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=139,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"rdirection",630,0,2,"正比",100) end
if t==(1+math.floor(t/100)*100) then R.change(o,"fdirection",630,0,2,"正比",100) end
if t==(1+math.floor(t/9)*9) then R.change(o,"sonspeed",0.5,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)

end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=264,["begin"]=1,["life"]=120,["fx"]=480,["fy"]=264,["r"]=50,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=20,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=139,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"rdirection",630,0,1,"正比",100) end
if t==(1+math.floor(t/100)*100) then R.change(o,"fdirection",630,0,1,"正比",100) end
if t==(1+math.floor(t/9)*9) then R.change(o,"sonspeed",0.5,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=296,["begin"]=185,["life"]=120,["fx"]=480,["fy"]=264,["r"]=50,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=20,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=139,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"rdirection",630,0,2,"正比",100) end
if t==(1+math.floor(t/100)*100) then R.change(o,"fdirection",630,0,2,"正比",100) end
if t==(1+math.floor(t/9)*9) then R.change(o,"sonspeed",0.5,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=264,["begin"]=1,["life"]=120,["fx"]=480,["fy"]=264,["r"]=50,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1600,["type"]=149,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"rdirection",630,0,1,"正比",100) end
if t==(1+math.floor(t/100)*100) then R.change(o,"fdirection",630,0,1,"正比",100) end
if t==(1+math.floor(t/9)*9) then R.change(o,"sonspeed",0.5,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,90,1,"正比",90) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=296,["begin"]=185,["life"]=120,["fx"]=480,["fy"]=264,["r"]=50,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1600,["type"]=149,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/100)*100) then R.change(o,"rdirection",630,0,2,"正比",100) end
if t==(1+math.floor(t/100)*100) then R.change(o,"fdirection",630,0,2,"正比",100) end
if t==(1+math.floor(t/9)*9) then R.change(o,"sonspeed",0.5,0,1,"正弦",8) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",0,90,1,"正比",60) end
end}
}}
