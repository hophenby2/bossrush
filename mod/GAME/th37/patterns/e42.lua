-- 离线展开：e42.xna；事件均已编译为Lua条件和调用。
return {id="e42",total=120,centerAvailable=false,center={315,240,0,0,0,0},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,types={{0,0,300,363,150,181,8,0},{300,0,300,363,150,181,8,0},{600,0,300,363,150,181,8,0},{900,0,300,363,150,181,8,0},{1200,0,300,363,150,181,5,0},{1500,0,300,363,150,181,15,0}},emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=333,["y"]=183,["begin"]=1,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=120,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=35,["type"]=160,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=1,["colorB"]=155,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=80,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",30.0,20.0,0,"正比",15) end
if t==(15) then R.change(o,"alpha",0.0,0,0,"正比",15) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=333,["y"]=119,["begin"]=1,["life"]=40,["fx"]=-99998,["fy"]=-99998,["r"]=140,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=160,["wscale"]=0.15,["hscale"]=0.4,["colorR"]=255,["colorG"]=122,["colorB"]=135,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=140,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.14,0,1,"正弦",19) end
if t==(41) then R.change(o,"alpha",0.0,0,0,"正比",20) end
if t==(1) then R.change(o,"head",0.0,460.0,1,"正比",60) end
if t==(1) then R.change(o,"sonspeedd",0.0,120.0,1,"正比",60) end
if t==(1) then R.change(o,"sonspeed",1.6,1.5,0,"正比",1) end
if t==(1) then R.change(o,"alpha",60.0,30.0,0,"正比",5) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=274,["y"]=265,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=12,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=229,["wscale"]=1.1,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",12.0,0,2,"正比",90) end
if t==(45) then R.change(o,"sonspeedd",40.0,0,1,"正比",45) end
if t==(85) then R.change(o,"alpha",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",24) end
if t==(85) then R.change(o,"colorG",8.0,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.2,0,2,"正弦",180) end
if t==(1) then R.change(o,"hscale",0.2,0,1,"正弦",180) end
if t==(85) then R.change(o,"sonspeed",8.0,0,0,"正比",15) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=293,["y"]=156,["begin"]=1,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=226,["wscale"]=0.5,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=125,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=220,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",55.0,0,1,"正比",30) end
if t==(15) then R.change(o,"alpha",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",30.0,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.01,0,0,"正比",30) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=325,["y"]=124,["begin"]=80,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=226,["wscale"]=0.5,["hscale"]=0.1,["colorR"]=255,["colorG"]=1,["colorB"]=125,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=220,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",55.0,0,1,"正比",24) end
if t==(15) then R.change(o,"alpha",0.0,0,0,"正比",13) end
if t==(1) then R.change(o,"alpha",30.0,0,0,"正比",13) end
if t==(1) then R.change(o,"wscale",0.01,0,0,"正比",24) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=162,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=30,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=4,["t"]=12,["fdirection"]=135,["fdirections"]={0.0,0.0},["range"]=150,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=225,["wscale"]=0.05,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=8,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",10.0,20.0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",22.0,0,1,"正比",30) end
if t==(75) then R.change(o,"alpha",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40.0,0,0,"正比",15) end
if t==(75) then R.change(o,"sonspeed",8.0,0,0,"正比",15) end
if t==(1) then R.change(o,"sonspeed",0.6,0.5,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.03,0,2,"正比",90) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=313,["y"]=202,["begin"]=4,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=95,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=234,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=280,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",6.0,0,2,"正比",90) end
if t==(21) then R.change(o,"wscale",0.13,0,1,"正比",60) end
if t==(83) then R.change(o,"alpha",0.0,0,0,"正比",24) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeed",1.0,0,0,"正比",21) end
if t==(1) then R.change(o,"wscale",0.2,0,1,"正比",20) end
if t==(1) then R.change(o,"hscale",0.2,0,1,"正比",20) end
if t==(21) then R.change(o,"hscale",0.13,0,1,"正比",60) end
if t==(83) then R.change(o,"hscale",0.2,0,1,"正比",24) end
if t==(83) then R.change(o,"wscale",0.2,0,1,"正比",24) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=326,["y"]=331,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=230,["wscale"]=0.92,["hscale"]=0.92,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=260,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",20.0,0,2,"正比",90) end
if t==(1) then R.change(o,"sonspeed",0.7,0,0,"正比",24) end
if t==(85) then R.change(o,"colorG",8.0,0,0,"正比",15) end
if t==(90) then R.change(o,"alpha",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",15) end
if t==(85) then R.change(o,"sonspeed",8.0,0,0,"正比",15) end
if t==(1+math.floor(t/36)*36) then R.change(o,"wscale",0.05,0,1,"正弦",35) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=350,["y"]=373,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=231,["wscale"]=0.82,["hscale"]=0.82,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",10.0,0,2,"正比",90) end
if t==(1) then R.change(o,"sonspeed",0.46,0,0,"正比",24) end
if t==(85) then R.change(o,"colorG",8.0,0,0,"正比",15) end
if t==(90) then R.change(o,"alpha",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",15) end
if t==(85) then R.change(o,"sonspeed",8.0,0,0,"正比",15) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=345,["y"]=202,["begin"]=4,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=95,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=233,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=250,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(83) then R.change(o,"head",8.0,0,1,"正比",24) end
if t==(21) then R.change(o,"wscale",0.13,0,1,"正比",60) end
if t==(83) then R.change(o,"alpha",0.0,0,0,"正比",24) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",21) end
if t==(1) then R.change(o,"wscale",0.2,0,1,"正比",20) end
if t==(1) then R.change(o,"hscale",0.2,0,1,"正比",20) end
if t==(21) then R.change(o,"hscale",0.13,0,1,"正比",60) end
if t==(83) then R.change(o,"hscale",0.2,0,1,"正比",24) end
if t==(83) then R.change(o,"wscale",0.2,0,1,"正比",24) end
if t==(1) then R.change(o,"head",12.0,0,1,"正比",73) end
end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=313,["y"]=170,["begin"]=4,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=95,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=232,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=280,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(84) then R.change(o,"head",12.0,0,2,"正比",24) end
if t==(7) then R.change(o,"wscale",0.13,0,1,"正比",80) end
if t==(83) then R.change(o,"alpha",0.0,0,0,"正比",24) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeed",0.7,0,0,"正比",21) end
if t==(1) then R.change(o,"wscale",0.2,0,1,"正比",7) end
if t==(1) then R.change(o,"hscale",0.2,0,1,"正比",7) end
if t==(7) then R.change(o,"hscale",0.13,0,1,"正比",80) end
if t==(83) then R.change(o,"hscale",0.3,0,1,"正比",24) end
if t==(83) then R.change(o,"wscale",0.3,0,1,"正比",24) end
if t==(1) then R.change(o,"head",12.0,0,2,"正比",83) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=345,["y"]=150,["begin"]=4,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=95,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=232,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=180,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["kind"]="batch",["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(84) then R.change(o,"head",5.0,0,1,"正比",12) end
if t==(7) then R.change(o,"wscale",0.2,0,1,"正比",80) end
if t==(83) then R.change(o,"alpha",0.0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",100.0,0,0,"正比",11) end
if t==(1) then R.change(o,"sonspeed",0.2,0,0,"正比",11) end
if t==(1) then R.change(o,"wscale",0.2,0,1,"正比",7) end
if t==(1) then R.change(o,"hscale",0.2,0,1,"正比",7) end
if t==(7) then R.change(o,"hscale",0.2,0,1,"正比",80) end
if t==(83) then R.change(o,"hscale",0.2,0,1,"正比",15) end
if t==(83) then R.change(o,"wscale",0.2,0,1,"正比",15) end
if t==(1) then R.change(o,"head",12.0,0,1,"正比",73) end
end}
}}
