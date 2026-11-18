return {["id"]="74",["total"]=180,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,1000,1000,500,500,0,0,1,0,0,0,0,0,0,"scene/sc3-2"},{0,0,1000,1000,500,500,0,0,1,0,0,0,0,0,0,"scene/sc3-6"},{0,0,1000,1000,500,500,0,0,1,0,0,0,0,0,0,"scene/sc3-4"},{0,0,1000,1000,500,500,0,0,1,0,0,0,0,0,0,"scene/sc3-3"},{0,0,1000,1000,500,500,0,0,1,0,0,0,0,0,0,"scene/sc3-1"},{0,0,1000,1000,500,500,0,0,1,0,0,0,0,0,0,"scene/sc3-5"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=543,["y"]=583,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=220,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=154,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=130,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.2,0,0,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",1.2,0,0,"正弦",600) end
if t==(1) then R.change(o,"head",60,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",1,0,1,"正比",1) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",12) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=488,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=25,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",32,0,0,"正比",60) end
if t==(1) then R.change(o,"hscale",32,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",60) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=424,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=220,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=91,["wscale"]=8,["hscale"]=8,["colorR"]=255,["colorG"]=225,["colorB"]=255,["alpha"]=30,["head"]=275,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=12,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",14,0,0,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.4,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",14,0,0,"正弦",600) end
if t==(1) then R.change(o,"head",18,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",1,0,1,"正比",1) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",12) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=424,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=220,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=152,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,0,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.9,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",1,0,0,"正弦",600) end
if t==(1) then R.change(o,"head",12,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",2,0,1,"正比",1) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=583,["y"]=385,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=210,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=153,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=280,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.1,0,0,"正弦",800) end
if t==(1) then R.change(o,"sonspeed",0.9,0,0,"正比",12) end
if t==(1) then R.change(o,"head",25,0,2,"无缝正弦",700) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",2,0,1,"正比",1) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",12) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",12) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=328,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=140,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=155,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=260,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.9,0,0,"正弦",800) end
if t==(1) then R.change(o,"sonspeed",2,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.9,0,0,"正弦",800) end
if t==(1) then R.change(o,"head",24,0,1,"正比",700) end
if t==(13) then R.change(o,"sonspeed",0.5,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",1,0,1,"正比",1) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",12) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=532,["y"]=371,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=424,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=220,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=156,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=280,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1,0,0,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.8,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",1,0,0,"正弦",600) end
if t==(1) then R.change(o,"head",30,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",2,0,1,"正比",1) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=449,["y"]=273,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=157,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=260,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.8,0,0,"正弦",800) end
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.8,0,0,"正弦",800) end
if t==(1) then R.change(o,"head",24,0,2,"正比",700) end
if t==(13) then R.change(o,"sonspeed",0.5,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",1,0,1,"正比",1) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",12) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=574,["y"]=45,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=140,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=157,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=222,["colorG"]=222,["colorB"]=222,["alpha"]=1,["head"]=300,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",1.2,0,0,"正弦",800) end
if t==(1) then R.change(o,"sonspeed",2,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",1.2,0,0,"正弦",800) end
if t==(1) then R.change(o,"head",6,0,2,"正比",700) end
if t==(13) then R.change(o,"sonspeed",0.5,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",1,0,1,"正比",1) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",12) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=488,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=25,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",44,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",44,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=456,["begin"]=1,["life"]=12,["fx"]=-99998,["fy"]=-99998,["r"]=300,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=116,["type"]=91,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=234,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正弦",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正弦",12) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",240,20,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",1) end
if t==(1) then R.change(o,"alpha",60,10,0,"正比",13) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.1,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.1,0,2,"无缝正弦",30) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=392,["begin"]=1,["life"]=6,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=25,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=244,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=70,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0,0,"正比",6) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正比",6) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",240,10,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",1) end
if t==(1) then R.change(o,"alpha",80,0,0,"正比",13) end
if t==(120) then R.change(o,"sonspeed",3,1,1,"正比",10) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(110) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.05,0,2,"无缝正弦",20) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.05,0,1,"无缝正弦",20) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=552,["begin"]=1,["life"]=12,["fx"]=-99998,["fy"]=-99998,["r"]=300,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=116,["type"]=91,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=234,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正弦",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正弦",12) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",240,20,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",4,1,0,"正比",1) end
if t==(1) then R.change(o,"alpha",60,10,0,"正比",13) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.1,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"hscale",0.1,0,2,"无缝正弦",30) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=121,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=1,["hscale"]=5,["colorR"]=255,["colorG"]=244,["colorB"]=255,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",13,5,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40,20,0,"正比",15) end
end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=121,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=2,["hscale"]=3,["colorR"]=255,["colorG"]=244,["colorB"]=255,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",5,3,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",15) end
end}
}}
