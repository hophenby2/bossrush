return {["id"]="78",["total"]=180,["order"]=1,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,300,500,100,400,0,0,1,0,0,0,0,0,0,"scene/7SC-01"},{0,0,300,100,150,50,0,0,1,0,0,0,0,0,0,"scene/7SC-02"},{0,0,400,500,200,250,0,0,1,0,0,0,0,0,0,"scene/7SC-03"},{0,0,800,600,400,300,0,0,1,0,0,0,0,0,0,"scene/7SC-04"},{0,0,300,400,150,200,0,0,1,0,0,0,0,0,0,"scene/7SC-05"},{0,0,200,100,50,70,0,0,1,0,0,0,0,0,0,"scene/7SC-06"},{0,0,500,300,100,50,0,0,1,0,0,0,0,0,0,"scene/7SC-07"},{0,0,300,500,150,250,0,0,1,0,0,0,0,0,0,"scene/7SC-08"},{0,0,400,300,50,250,0,0,1,0,0,0,0,0,0,"scene/7SC-09"},{0,0,300,600,150,1,0,0,1,0,0,0,0,0,0,"scene/7SC-21"},{973,139,43,42,22,21,0,0,1,0,0,0,0,0,0,"scene/2BOSS-fw2"},{92,130,96,96,48,48,0,0,1,0,0,0,0,0,0,"scene/7SC-22"},{0,0,400,500,200,250,0,0,1,0,0,0,0,0,0,"scene/7SC-13"},{0,0,300,500,150,250,0,0,1,0,0,0,0,0,0,"scene/7SC-18"},{0,0,300,500,150,250,0,0,1,0,0,0,0,0,0,"scene/bg2-9"},{0,0,300,500,150,250,0,0,1,0,0,0,0,0,0,"scene/bg2-10"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["x"]=326,["y"]=553,["begin"]=1,["life"]=180,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=5,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(120) then R.change(o,"alpha",0,0,0,"正比",20) end
end},
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=648,["y"]=671,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=91,["wscale"]=8,["hscale"]=16,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=330,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=12,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",9,0,0,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.4,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",9,0,0,"正弦",600) end
if t==(1) then R.change(o,"head",18,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",1,0,1,"正比",1) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",20,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=461,["y"]=263,["begin"]=1,["life"]=100,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=81,["wscale"]=0.13,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=30,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"wscale",0.13,0,0,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"hscale",3,0,0,"正弦",12) end
if t==(70) then R.change(o,"t",5,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",13,2,0,"正比",1) end
if t==(1) then R.change(o,"alpha",20,10,0,"正比",20) end
if t==(1) then R.change(o,"hscale",18,5,0,"正比",100) end
if t==(40) then R.change(o,"alpha",1,0,0,"正比",20) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=621,["y"]=584,["begin"]=1,["life"]=40,["fx"]=-99998,["fy"]=780,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=162,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=360,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.6,0,0,"正弦",12) end
if t==(1+math.floor(t/12)*12) then R.change(o,"hscale",0.6,0,0,"正弦",12) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3,2,0,"正比",1) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",8) end
if t==(80) then R.change(o,"alpha",1,0,0,"正比",10) end
if t==(1+math.floor(t/16)*16) then R.change(o,"hscale",0.05,0,2,"无缝正弦",16) end
if t==(1+math.floor(t/16)*16) then R.change(o,"wscale",0.05,0,1,"无缝正弦",16) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=398,["y"]=104,["begin"]=1,["life"]=13,["fx"]=-99998,["fy"]=180,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=30,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=163,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=13,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=60,["r"]=230,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.3,0,0,"正弦",10) end
if t==(1) then R.change(o,"hscale",0.3,0,0,"正弦",10) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,13,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",1,0.5,0,"正比",6) end
if t==(1) then R.change(o,"alpha",60,0,0,"正比",12) end
if t==(90) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"head",0,360,1,"正比",120) end
if t==(1) then R.change(o,"wscale",0,0.2,1,"正比",120) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=525,["y"]=629,["begin"]=1,["life"]=90,["fx"]=-99998,["fy"]=900,["r"]=0,["rdirection"]=340,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=4,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=166,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=11,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=150,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.1,["hscale"]=0.1},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=true,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"r",320,20,1,"无缝正弦",13) end
if t==(1+math.floor(t/13)*13) then R.change(o,"type",1,0,1,"正比",1) end
if t==(6+math.floor(t/13)*13) then R.change(o,"type",1,0,2,"正比",1) end
if t==(1) then R.change(o,"speed",1,0,0,"正比",70) end
end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.01,0,0,"正比",10) end
if t==(15) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(16) then R.change(o,"sonspeed",0.1,0.1,1,"无缝正弦",120) end
if t==(1) then R.change(o,"alpha",99,0,0,"正比",5) end
if t==(110) then R.change(o,"alpha",0,0,0,"正比",20) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=557,["y"]=629,["begin"]=1,["life"]=90,["fx"]=-99998,["fy"]=1000,["r"]=0,["rdirection"]=340,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=4,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=166,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=11,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=150,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.1,["hscale"]=0.1},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=true,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"r",420,20,1,"无缝正弦",13) end
if t==(1+math.floor(t/13)*13) then R.change(o,"type",1,0,1,"正比",1) end
if t==(6+math.floor(t/13)*13) then R.change(o,"type",1,0,2,"正比",1) end
if t==(1) then R.change(o,"speed",1,0,0,"正比",70) end
end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.01,0,0,"正比",10) end
if t==(15) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(16) then R.change(o,"sonspeed",0.1,0.1,1,"无缝正弦",120) end
if t==(1) then R.change(o,"alpha",99,0,0,"正比",5) end
if t==(110) then R.change(o,"alpha",0,0,0,"正比",20) end
end},
{["id"]=0,["parentid"]=1,["x"]=224,["y"]=488,["begin"]=1,["life"]=180,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(118) then R.change(o,"colorG",200,0,0,"正比",15) end
if t==(118) then R.change(o,"colorR",130,0,0,"正比",15) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=394,["y"]=256,["begin"]=121,["life"]=4,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=1,["hscale"]=5,["colorR"]=255,["colorG"]=255,["colorB"]=122,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=130,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",13,5,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40,20,0,"正比",15) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=363,["y"]=256,["begin"]=121,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=2,["hscale"]=3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=130,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",5,3,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.4,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",30,10,0,"无缝正弦",30) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=297,["y"]=282,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=135,["type"]=152,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=276,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.6,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.1,0,2,"正弦",700) end
if t==(1) then R.change(o,"head",18,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",0.5,0,1,"正比",1) end
if t==(122) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=447,["y"]=285,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=135,["type"]=154,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.4,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"head",5,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",0.5,0,1,"正比",1) end
if t==(122) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=453,["y"]=52,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=135,["type"]=153,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=265,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.5,0,1,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.4,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"head",18,0,1,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",0.5,0,1,"正比",1) end
if t==(122) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=407,["y"]=242,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=135,["type"]=155,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.4,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.2,0,1,"正弦",450) end
if t==(1) then R.change(o,"head",9,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",0.5,0,1,"正比",1) end
if t==(122) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=447,["y"]=285,["begin"]=3,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=164,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=66,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.4,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"head",5,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",0.5,0,1,"正比",1) end
if t==(122) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(9+math.floor(t/10)*10) then R.change(o,"alpha",30,20,0,"正比",9) end
end},
{["id"]=0,["parentid"]=2,["x"]=224,["y"]=488,["begin"]=1,["life"]=180,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(118) then R.change(o,"colorG",1,0,0,"正比",15) end
if t==(118) then R.change(o,"colorB",1,0,0,"正比",15) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=591,["y"]=484,["begin"]=121,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=1,["hscale"]=5,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=100,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",13,5,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40,20,0,"正比",15) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=636,["y"]=452,["begin"]=121,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=2,["hscale"]=3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",5,3,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.4,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",30,10,0,"无缝正弦",30) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=421,["y"]=425,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=130,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=135,["type"]=156,["wscale"]=0.84,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=276,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",12) end
if t==(1) then R.change(o,"head",12,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",0.5,0,1,"正比",1) end
if t==(122) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
if t==(1) then R.change(o,"hscale",0.1,0,1,"正比",24) end
if t==(1+math.floor(t/50)*50) then R.change(o,"wscale",0.05,0,2,"正弦",75) end
if t==(25+math.floor(t/50)*50) then R.change(o,"hscale",0.05,0,2,"正弦",75) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=545,["y"]=538,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=135,["type"]=157,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=276,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.2,0,1,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.5,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"head",6,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",0.5,0,1,"正比",1) end
if t==(122) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=577,["y"]=529,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=135,["type"]=158,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=276,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.03,0,1,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.3,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"head",13,0,1,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",0.5,0,1,"正比",1) end
if t==(122) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=565,["y"]=587,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=135,["type"]=159,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=276,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.4,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"head",5,0,1,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",0.5,0,1,"正比",1) end
if t==(122) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=581,["y"]=514,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=275,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=135,["type"]=160,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=290,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.2,0,1,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.8,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.05,0,1,"正弦",600) end
if t==(1) then R.change(o,"head",13,0,2,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",0.5,0,1,"正比",1) end
if t==(122) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=565,["y"]=587,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=165,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=88,["head"]=276,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"sonspeed",0.4,0,0,"正比",12) end
if t==(1) then R.change(o,"wscale",0.1,0,1,"正弦",600) end
if t==(1) then R.change(o,"head",5,0,1,"正弦",700) end
if t==(13) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(13) then R.change(o,"sonspeed",0,0,0,"正比",200) end
if t==(120) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t>(120) then R.change(o,"sonspeed",0.5,0,1,"正比",1) end
if t==(122) then R.change(o,"alpha",1,0,0,"正比",12) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",13) end
if t==(9+math.floor(t/10)*10) then R.change(o,"alpha",20,10,0,"正比",9) end
end},
{["id"]=0,["parentid"]=3,["x"]=326,["y"]=553,["begin"]=1,["life"]=180,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=5,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(120) then R.change(o,"alpha",0,0,0,"正比",20) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=616,["y"]=640,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=750,["r"]=0,["rdirection"]=330,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=7,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=106,["type"]=91,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正弦",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正弦",12) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",3,1,0,"正比",1) end
if t==(1) then R.change(o,"alpha",20,10,0,"正比",8) end
if t==(11+math.floor(t/15)*15) then R.change(o,"alpha",10,0,1,"无缝正弦",15) end
end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=447,["y"]=146,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=300,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=106,["type"]=147,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0,0,"正弦",12) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正弦",12) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,9,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",4,1,0,"正比",1) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",8) end
if t==(11+math.floor(t/15)*15) then R.change(o,"alpha",20,0,1,"无缝正弦",15) end
end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=572,["y"]=658,["begin"]=1,["life"]=100,["fx"]=-99998,["fy"]=880,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=81,["wscale"]=0.2,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=160,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"wscale",0.13,0,0,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"hscale",3,0,0,"正弦",12) end
if t==(70) then R.change(o,"t",5,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",6,2,0,"正比",1) end
if t==(1) then R.change(o,"alpha",30,20,0,"正比",20) end
if t==(1) then R.change(o,"hscale",5,2,0,"正比",100) end
if t==(40) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(2) then R.change(o,"sonspeedd",0,40,1,"正比",60) end
end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=428,["y"]=19,["begin"]=1,["life"]=80,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=75,["type"]=147,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=100,["r"]=200,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0,0,"正弦",12) end
if t==(1) then R.change(o,"hscale",0.5,0,0,"正弦",12) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,13,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",1) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",8) end
if t==(60) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(60) then R.change(o,"hscale",0,0,0,"正比",15) end
if t==(11+math.floor(t/20)*20) then R.change(o,"alpha",10,0,1,"无缝正弦",20) end
end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=294,["y"]=367,["begin"]=111,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=1,["hscale"]=5,["colorR"]=255,["colorG"]=255,["colorB"]=133,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",13,5,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40,20,0,"正比",15) end
end},
{["id"]=5,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=363,["y"]=295,["begin"]=1,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=2,["hscale"]=3,["colorR"]=255,["colorG"]=255,["colorB"]=133,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",7,3,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.3,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",1) end
if t==(2) then R.change(o,"alpha",0,0,0,"正比",14) end
end},
{["id"]=6,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=572,["y"]=701,["begin"]=1,["life"]=60,["fx"]=-99998,["fy"]=780,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=12,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=91,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正弦",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正弦",12) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",1) end
if t==(61) then R.change(o,"alpha",0,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",20,10,0,"正比",60) end
end},
{["id"]=7,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=560,["y"]=516,["begin"]=1,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=1,["hscale"]=3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",7,3,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.3,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",1) end
if t==(2) then R.change(o,"alpha",0,0,0,"正比",14) end
end},
{["id"]=8,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=676,["y"]=510,["begin"]=111,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=3,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=1,["hscale"]=5,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",13,5,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40,20,0,"正比",15) end
end},
{["id"]=9,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=339,["y"]=659,["begin"]=111,["life"]=3,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=1,["hscale"]=5,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=100,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",6,2,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",40,20,0,"正比",15) end
end},
{["id"]=10,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=490,["y"]=199,["begin"]=1,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=260,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=15,["type"]=91,["wscale"]=0.4,["hscale"]=3,["colorR"]=255,["colorG"]=255,["colorB"]=120,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=130,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",4,2,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",15) end
if t==(1) then R.change(o,"alpha",20,10,0,"正比",1) end
if t==(2) then R.change(o,"alpha",0,0,0,"正比",14) end
end},
{["id"]=11,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=383,["y"]=22,["begin"]=1,["life"]=50,["fx"]=-99998,["fy"]=-60,["r"]=0,["rdirection"]=330,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=91,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",1,0,0,"正弦",12) end
if t==(1) then R.change(o,"hscale",1,0,0,"正弦",12) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",2,1,0,"正比",1) end
if t==(1) then R.change(o,"alpha",10,0,0,"正比",8) end
if t==(11+math.floor(t/15)*15) then R.change(o,"alpha",5,0,1,"无缝正弦",15) end
end},
{["id"]=12,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=417,["y"]=72,["begin"]=1,["life"]=60,["fx"]=-99998,["fy"]=-200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=161,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=60,["r"]=250,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=13,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",90,20,0,"正比",30) end
if t==(91) then R.change(o,"alpha",0,0,0,"正比",30) end
end},
{["id"]=13,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=621,["y"]=552,["begin"]=1,["life"]=10,["fx"]=-99998,["fy"]=750,["r"]=0,["rdirection"]=320,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=20,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=162,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.5,0,0,"正弦",9) end
if t==(1+math.floor(t/12)*12) then R.change(o,"hscale",0.5,0,0,"正弦",9) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",1,0.5,0,"正比",1) end
if t==(1) then R.change(o,"alpha",70,0,0,"正比",8) end
if t==(110) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.04,0,2,"无缝正弦",20) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.04,0,1,"无缝正弦",20) end
end},
{["id"]=14,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=398,["y"]=136,["begin"]=1,["life"]=13,["fx"]=-99998,["fy"]=180,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=30,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=163,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=13,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=60,["r"]=330,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.3,0,0,"正弦",10) end
if t==(1) then R.change(o,"hscale",0.3,0,0,"正弦",10) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,13,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",1,0.5,0,"正比",6) end
if t==(1) then R.change(o,"alpha",60,0,0,"正比",12) end
if t==(90) then R.change(o,"alpha",1,0,0,"正比",30) end
if t==(1) then R.change(o,"head",0,130,1,"正比",120) end
if t==(1) then R.change(o,"wscale",0,0.2,1,"正比",120) end
end},
{["id"]=15,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=653,["y"]=552,["begin"]=1,["life"]=8,["fx"]=-99998,["fy"]=800,["r"]=0,["rdirection"]=320,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=20,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=130,["type"]=162,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/12)*12) then R.change(o,"wscale",0.5,0,0,"正弦",9) end
if t==(1+math.floor(t/12)*12) then R.change(o,"hscale",0.5,0,0,"正弦",9) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",1,0.5,0,"正比",1) end
if t==(1) then R.change(o,"alpha",70,0,0,"正比",8) end
if t==(110) then R.change(o,"alpha",1,0,0,"正比",20) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.04,0,2,"无缝正弦",20) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.04,0,1,"无缝正弦",20) end
end},
{["id"]=16,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=524,["y"]=677,["begin"]=1,["life"]=90,["fx"]=-99998,["fy"]=1000,["r"]=0,["rdirection"]=340,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=3,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=166,["wscale"]=0.4,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=13,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=50,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0.1,["hscale"]=0.1},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=true,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"r",350,20,1,"无缝正弦",13) end
if t==(1+math.floor(t/13)*13) then R.change(o,"type",1,0,1,"正比",1) end
if t==(6+math.floor(t/13)*13) then R.change(o,"type",1,0,2,"正比",1) end
if t==(1) then R.change(o,"speed",0.1,0,0,"正比",80) end
end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.01,0,0,"正比",10) end
if t==(15) then R.change(o,"Afterimage",0,0,0,"正比",1) end
if t==(16) then R.change(o,"sonspeed",0.1,0.1,1,"无缝正弦",120) end
if t==(1) then R.change(o,"alpha",99,0,0,"正比",5) end
if t==(110) then R.change(o,"alpha",0,0,0,"正比",20) end
end}
}}
