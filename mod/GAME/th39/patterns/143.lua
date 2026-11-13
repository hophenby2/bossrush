return {["id"]="143",["total"]=840,["order"]=0,["centerAvailable"]=true,["center"]={480,260,0,0,0,0},["types"]={{0,0,215,224,108,112,16,0,1,0,0,0,0,0,0,"1BOSS"},{430,0,215,224,108,112,16,0,1,0,0,0,0,0,0,"1BOSS"},{215,0,215,224,108,112,0,0,1,0,0,0,0,0,0,"1BOSS"},{645,0,215,224,108,112,0,0,1,0,0,0,0,0,0,"1BOSS"},{0,224,112,112,56,56,10,0,1,0,0,0,0,0,0,"1BOSS"},{112,224,301,301,150,150,0,0,1,0,0,0,0,0,0,"1BOSS"}},centerEvents=function(o,t,R)
if t==(1) then R.move(o,false,420,540,230,220) end
if t==(420) then R.move(o,false,420,540,230,220) end
end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=384,["y"]=456,["begin"]=120,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=20,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=152,["wscale"]=0.1,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(121) then R.change(o,"head",0,230,1,"正比",540) end
if t==(12) then R.change(o,"wscale",0.02,0,1,"正弦",119) end
if t==(12) then R.change(o,"hscale",0.02,0,2,"正弦",119) end
if t==(122) then R.change(o,"wscale",0.02,0,1,"正弦",47) end
if t==(1) then R.change(o,"head",3,0,1,"正弦",119) end
if t==(122) then R.change(o,"hscale",0.02,0,2,"正弦",47) end
if t==(1) then R.change(o,"wscale",0.83,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.8,0,0,"正比",11) end
if t==(120) then R.change(o,"sonspeed",0.5,0,0,"正比",1) end
if t==(120) then R.change(o,"colorB",120,0,0,"正比",60) end
if t==(120) then R.change(o,"sonaspeed",0.012,0,0,"正比",1) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(120) then R.change(o,"colorG",230,0,0,"正比",60) end
if t==(170) then R.change(o,"wscale",0.5,0,0,"正比",10) end
if t==(170) then R.change(o,"hscale",0.5,0,0,"正比",10) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=224,["y"]=544,["begin"]=1,["life"]=840,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=13,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.5,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,120,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",480,0,2,"正比",36) end
if t==(1) then R.change(o,"sonspeed",4,1,0,"正比",1) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=224,["y"]=456,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=154,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",3,0,1,"正弦",119) end
if t==(12+math.floor(t/120)*120) then R.change(o,"hscale",0.03,0,1,"正弦",119) end
if t==(12+math.floor(t/120)*120) then R.change(o,"wscale",0.03,0,2,"正弦",119) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",11) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=224,["y"]=584,["begin"]=180,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=40,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=52,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=205,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.3,0,2,"正弦",5) end
if t==(1) then R.change(o,"sonspeed",4,0,2,"正比",3) end
if t==(1) then R.change(o,"wscale",0.3,0,2,"正弦",5) end
if t==(1) then R.change(o,"tiao",3,0,2,"正比",1) end
if t==(2) then R.change(o,"tiao",6,0,2,"正比",1) end
if t==(3) then R.change(o,"tiao",6,0,2,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.2,0.1,0,"正比",40) end
if t==(1) then R.change(o,"head",0,1200,1,"正比",150) end
if t==(1) then R.change(o,"life",50,10,0,"正比",1) end
if t==(31) then R.change(o,"colorB",30,0,0,"正比",60) end
if t==(31) then R.change(o,"colorR",30,60,0,"正比",60) end
if t==(37) then R.change(o,"alpha",80,0,0,"正比",7) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=255,["begin"]=61,["life"]=360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=730,["type"]=151,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"t",8,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",1) end
if t==(2) then R.change(o,"fdirection",6670,0,1,"正比",240) end
if t==(1) then R.change(o,"fdirection",90,0,0,"正比",1) end
if t==(122) then R.change(o,"sonspeed",2,0,1,"正比",120) end
if t==(250) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(62) then R.change(o,"sonspeed",2.5,0,1,"正比",60) end
if t==(2) then R.change(o,"sonspeed",3.5,0,1,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/222)*222) then R.change(o,"head",1111,0,1,"正比",222) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",130,0,1,"正比",120) end
if t==(130) then R.change(o,"sonspeed",8,2,0,"正比",60) end
if t==(130) then R.change(o,"sonspeedd",270,20,0,"正比",1) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=true,["x"]=320,["y"]=264,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=30,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=53,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360,0,1,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=256,["y"]=544,["begin"]=1,["life"]=840,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=13,["wscale"]=0.25,["hscale"]=0.25,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.5,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,120,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",480,0,1,"正比",36) end
if t==(1) then R.change(o,"sonspeed",4,1,0,"正比",1) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=224,["y"]=488,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=183,["type"]=148,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",3,0,1,"正弦",119) end
if t==(12+math.floor(t/120)*120) then R.change(o,"hscale",0.03,0,1,"正弦",119) end
if t==(12+math.floor(t/120)*120) then R.change(o,"wscale",0.03,0,2,"正弦",119) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",11) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=8,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=287,["begin"]=61,["life"]=360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=180,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=53,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"t",8,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",1) end
if t==(2) then R.change(o,"fdirection",6670,0,1,"正比",240) end
if t==(1) then R.change(o,"fdirection",90,0,0,"正比",1) end
if t==(122) then R.change(o,"sonspeed",2,0,1,"正比",120) end
if t==(250) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(62) then R.change(o,"sonspeed",2.5,0,1,"正比",60) end
if t==(2) then R.change(o,"sonspeed",3.5,0,1,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/222)*222) then R.change(o,"head",1111,0,1,"正比",222) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",130,0,1,"正比",120) end
if t==(130) then R.change(o,"sonspeed",8,2,0,"正比",60) end
if t==(130) then R.change(o,"sonspeedd",270,20,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=416,["y"]=456,["begin"]=120,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=20,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=152,["wscale"]=0.1,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(121) then R.change(o,"head",0,230,1,"正比",540) end
if t==(12) then R.change(o,"wscale",0.02,0,1,"正弦",119) end
if t==(12) then R.change(o,"hscale",0.02,0,2,"正弦",119) end
if t==(122) then R.change(o,"wscale",0.02,0,1,"正弦",47) end
if t==(1) then R.change(o,"head",3,0,1,"正弦",119) end
if t==(122) then R.change(o,"hscale",0.02,0,2,"正弦",47) end
if t==(1) then R.change(o,"wscale",0.83,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",0.8,0,0,"正比",11) end
if t==(120) then R.change(o,"sonspeed",0.5,0,0,"正比",1) end
if t==(120) then R.change(o,"colorB",120,0,0,"正比",60) end
if t==(120) then R.change(o,"sonaspeed",0.012,0,0,"正比",1) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(120) then R.change(o,"colorG",230,0,0,"正比",60) end
if t==(170) then R.change(o,"wscale",0.4,0,0,"正比",10) end
if t==(170) then R.change(o,"hscale",0.4,0,0,"正比",10) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=224,["y"]=544,["begin"]=1,["life"]=840,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=13,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.5,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,120,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",480,0,2,"正比",36) end
if t==(1) then R.change(o,"sonspeed",4,1,0,"正比",1) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=256,["y"]=456,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=154,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=80,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",3,0,1,"正弦",119) end
if t==(12+math.floor(t/120)*120) then R.change(o,"hscale",0.03,0,1,"正弦",119) end
if t==(12+math.floor(t/120)*120) then R.change(o,"wscale",0.03,0,2,"正弦",119) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",11) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=256,["y"]=584,["begin"]=180,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=40,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=52,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=90,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.3,0,2,"正弦",5) end
if t==(1) then R.change(o,"hscale",0.3,0,2,"正弦",5) end
if t==(1) then R.change(o,"sonspeed",4,0,2,"正比",3) end
if t==(1) then R.change(o,"tiao",3,0,2,"正比",1) end
if t==(2) then R.change(o,"tiao",6,0,2,"正比",1) end
if t==(3) then R.change(o,"tiao",6,0,2,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.2,0.1,0,"正比",40) end
if t==(1) then R.change(o,"head",0,1300,1,"正比",150) end
if t==(1) then R.change(o,"life",50,10,0,"正比",1) end
if t==(31) then R.change(o,"colorR",30,60,0,"正比",60) end
if t==(31) then R.change(o,"colorB",30,0,0,"正比",60) end
if t==(37) then R.change(o,"alpha",80,0,0,"正比",7) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=255,["begin"]=481,["life"]=360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=730,["type"]=151,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"t",8,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",1) end
if t==(2) then R.change(o,"fdirection",6670,0,2,"正比",240) end
if t==(1) then R.change(o,"fdirection",90,0,0,"正比",1) end
if t==(122) then R.change(o,"sonspeed",2,0,1,"正比",120) end
if t==(250) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(62) then R.change(o,"sonspeed",2.5,0,1,"正比",60) end
if t==(2) then R.change(o,"sonspeed",3.5,0,1,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/222)*222) then R.change(o,"head",1111,0,1,"正比",222) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",130,0,2,"正比",120) end
if t==(130) then R.change(o,"sonspeed",8,2,0,"正比",60) end
if t==(130) then R.change(o,"sonspeedd",270,20,0,"正比",1) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=true,["x"]=352,["y"]=264,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=30,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=53,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"fdirection",360,0,2,"正比",120) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=256,["y"]=544,["begin"]=1,["life"]=840,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=20,["type"]=13,["wscale"]=0.25,["hscale"]=0.25,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=60,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1.5,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=360,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,120,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",480,0,1,"正比",36) end
if t==(1) then R.change(o,"sonspeed",4,1,0,"正比",1) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=256,["y"]=488,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=183,["type"]=148,["wscale"]=0.1,["hscale"]=0.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",3,0,1,"正弦",119) end
if t==(12+math.floor(t/120)*120) then R.change(o,"hscale",0.03,0,1,"正弦",119) end
if t==(12+math.floor(t/120)*120) then R.change(o,"wscale",0.03,0,2,"正弦",119) end
if t==(1) then R.change(o,"wscale",1,0,0,"正比",11) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",60) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=287,["begin"]=481,["life"]=360,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=53,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"t",8,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",1) end
if t==(2) then R.change(o,"fdirection",6670,0,2,"正比",240) end
if t==(1) then R.change(o,"fdirection",90,0,0,"正比",1) end
if t==(122) then R.change(o,"sonspeed",2,0,1,"正比",120) end
if t==(250) then R.change(o,"t",99999,0,0,"正比",1) end
if t==(62) then R.change(o,"sonspeed",2.5,0,1,"正比",60) end
if t==(2) then R.change(o,"sonspeed",3.5,0,1,"正比",60) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/222)*222) then R.change(o,"head",1111,0,1,"正比",222) end
if t==(1) then R.change(o,"sonspeed",0.01,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",130,0,2,"正比",120) end
if t==(130) then R.change(o,"sonspeed",8,2,0,"正比",60) end
if t==(130) then R.change(o,"sonspeedd",270,20,0,"正比",1) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=481,["life"]=240,["fx"]=-99998,["fy"]=255,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=10,["t"]=9,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1600,["type"]=77,["wscale"]=0.85,["hscale"]=0.85,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1230,0,1,"正比",240) end
if t==(1) then R.change(o,"sonspeed",3,0,1,"正比",240) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,0,2,"正比",60) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=61,["life"]=240,["fx"]=-99998,["fy"]=255,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=10,["t"]=9,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1600,["type"]=77,["wscale"]=0.85,["hscale"]=0.85,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",1230,0,2,"正比",240) end
if t==(1) then R.change(o,"sonspeed",3,0,1,"正比",240) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,0,1,"正比",60) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=424,["begin"]=61,["life"]=5,["fx"]=-99998,["fy"]=255,["r"]=20,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=27,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1600,["type"]=69,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(2) then R.change(o,"rdirection",180,0,1,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.2,0,2,"正比",1) end
if t==(1) then R.fire(o) end
if t==(2) then R.change(o,"fdirection",180,0,1,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=456,["begin"]=481,["life"]=5,["fx"]=-99998,["fy"]=255,["r"]=20,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=27,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1600,["type"]=69,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(2) then R.change(o,"rdirection",180,0,1,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.2,0,2,"正比",1) end
if t==(1) then R.fire(o) end
if t==(2) then R.change(o,"fdirection",180,0,1,"正比",1) end
end,Sonevents=function(o,t,R)

end}
}}
