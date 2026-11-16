return {["id"]="613",["total"]=92000,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,550,600,275,300,0,0,1,0,0,0,0,0,0,"scene/6bg-06"},{0,0,550,600,274,300,0,0,1,0,0,0,0,0,0,"scene/6bg-07"},{0,0,550,10,274,0,0,0,60,1,0,0,0,0,0,"scene/6bg-07"},{0,0,150,150,75,75,0,0,1,0,0,0,0,0,0,"scene/6bg-12"},{150,0,150,150,75,75,0,0,1,0,0,0,0,0,0,"scene/6bg-12"},{300,0,150,150,75,75,0,0,1,0,0,0,0,0,0,"scene/6bg-12"},{450,0,150,150,75,75,0,0,1,0,0,0,0,0,0,"scene/6bg-12"},{600,0,150,150,75,75,0,0,1,0,0,0,0,0,0,"scene/6bg-12"},{750,0,150,150,75,75,0,0,1,0,0,0,0,0,0,"scene/6bg-12"},{0,0,100,100,50,50,0,0,1,0,0,0,0,0,0,"scene/6bg-10"},{100,0,100,100,50,50,0,0,1,0,0,0,0,0,0,"scene/6bg-10"},{200,0,100,100,50,50,0,0,1,0,0,0,0,0,0,"scene/6bg-10"},{0,0,100,100,50,50,0,0,1,0,0,0,0,0,0,"scene/6bg-11"},{100,0,100,100,50,50,0,0,1,0,0,0,0,0,0,"scene/6bg-11"},{200,0,100,100,50,50,0,0,1,0,0,0,0,0,0,"scene/6bg-11"},{0,0,100,100,50,50,0,0,1,0,0,0,0,0,0,"scene/6bg-11"},{0,0,750,1500,375,800,0,0,1,0,0,0,0,0,0,"scene/6bg-02"},{0,0,52,338,26,150,0,0,1,0,0,0,0,0,0,"scene/4bgshui-02"},{0,0,62,390,31,190,0,0,1,0,0,0,0,0,0,"scene/4bgshui-01"},{0,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"scene/6bg-13"},{50,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"scene/6bg-13"},{100,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"scene/6bg-13"},{0,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"scene/6bg-13"},{50,0,50,50,25,25,0,0,1,0,0,0,0,0,0,"scene/6bg-13"},{500,0,250,200,125,100,0,0,8,6,0,0,0,0,0,"scene/6-tiannv1"},{250,0,250,200,125,100,0,0,8,6,0,0,0,0,0,"scene/6-tiannv1"},{0,0,250,200,125,100,0,0,8,6,0,0,0,0,0,"scene/6-tiannv1"},{0,0,100,100,30,50,0,0,1,0,0,0,0,0,0,"scene/6bg-10"},{100,0,100,100,40,50,0,0,1,0,0,0,0,0,0,"scene/6bg-10"},{200,0,100,100,60,50,0,0,1,0,0,0,0,0,0,"scene/6bg-10"},{0,0,240,200,125,100,0,0,14,6,0,0,0,0,0,"scene/7-kaguya"},{0,0,100,300,50,300,0,0,1,0,0,0,0,0,0,"scene/TyndallEffect"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=1800,["life"]=1,["fx"]=480,["fy"]=230,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=150,["type"]=91,["wscale"]=4,["hscale"]=5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",99,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",3,0,0,"正比",150) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",150) end
if t==(91) then R.change(o,"alpha",1,0,0,"正比",60) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=1800,["life"]=1,["fx"]=480,["fy"]=230,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=91,["wscale"]=13,["hscale"]=13,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",66,0,0,"正比",120) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",120) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=232,["begin"]=1801,["life"]=30,["fx"]=480,["fy"]=230,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=183,["wscale"]=1,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=13,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360,0,1,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(62) then R.change(o,"alpha",0,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",120) end
if t==(1) then R.change(o,"hscale",2,1,0,"正比",1) end
if t==(2) then R.change(o,"hscale",0,0,0,"正比",120) end
if t==(1) then R.change(o,"sonspeedd",0,130,1,"正比",120) end
if t==(2) then R.change(o,"alpha",20,10,0,"正比",60) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=200,["begin"]=1800,["life"]=1,["fx"]=520,["fy"]=200,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=180,["type"]=91,["wscale"]=3,["hscale"]=3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",77,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",2,0,0,"正比",180) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",180) end
if t==(121) then R.change(o,"alpha",1,0,0,"正比",60) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=424,["begin"]=1,["life"]=2400,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=23,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=171,["wscale"]=0,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.5,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(480) then R.change(o,"alpha",1,0,0,"正比",120) end
if t==(1) then R.change(o,"head",0,3600,1,"正比",600) end
if t==(120) then R.change(o,"sonspeedd",0,80,1,"正比",120) end
if t==(120) then R.change(o,"sonspeed",1,0.5,0,"正比",160) end
if t==(1) then R.change(o,"alpha",66,22,0,"正比",30) end
if t==(1) then R.change(o,"type",2,2,1,"正比",1) end
if t==(1+math.floor(t/60)*60) then R.change(o,"wscale",0.4,0,0,"无缝正弦",60) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=456,["begin"]=1401,["life"]=330,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=171,["wscale"]=0,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.7,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(480) then R.change(o,"alpha",1,0,0,"正比",120) end
if t==(1) then R.change(o,"head",0,3600,1,"正比",600) end
if t==(60) then R.change(o,"sonspeedd",540,0,2,"正比",300) end
if t==(1) then R.change(o,"sonspeed",8,0.5,0,"正比",1) end
if t==(1) then R.change(o,"alpha",44,22,0,"正比",30) end
if t==(1) then R.change(o,"type",2,2,1,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.1,0,0,"正比",360) end
if t==(1) then R.change(o,"sonspeedd",40,0,2,"正比",60) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.4,0,0,"无缝正弦",30) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=456,["begin"]=1402,["life"]=330,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.5,["speedd"]=230,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=171,["wscale"]=0,["hscale"]=0.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.7,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",30,0,1,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(480) then R.change(o,"alpha",1,0,0,"正比",120) end
if t==(1) then R.change(o,"head",0,3600,1,"正比",600) end
if t==(60) then R.change(o,"sonspeedd",540,0,2,"正比",300) end
if t==(1) then R.change(o,"sonspeed",8,0.5,0,"正比",1) end
if t==(1) then R.change(o,"alpha",44,22,0,"正比",30) end
if t==(1) then R.change(o,"type",2,2,1,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.1,0,0,"正比",360) end
if t==(1) then R.change(o,"sonspeedd",40,0,2,"正比",60) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.5,0,0,"无缝正弦",30) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=456,["begin"]=1403,["life"]=330,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.3,["speedd"]=240,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=171,["wscale"]=0,["hscale"]=0.4,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.7,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",20,0,1,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(480) then R.change(o,"alpha",1,0,0,"正比",120) end
if t==(1) then R.change(o,"head",0,3600,1,"正比",600) end
if t==(60) then R.change(o,"sonspeedd",540,0,2,"正比",300) end
if t==(1) then R.change(o,"sonspeed",8,0.5,0,"正比",1) end
if t==(1) then R.change(o,"alpha",44,22,0,"正比",30) end
if t==(1) then R.change(o,"type",2,2,1,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.1,0,0,"正比",360) end
if t==(1) then R.change(o,"sonspeedd",40,0,2,"正比",60) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.4,0,0,"无缝正弦",30) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=456,["begin"]=1400,["life"]=270,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.3,["speedd"]=240,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=91,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.7,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",20,0,1,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(480) then R.change(o,"alpha",1,0,0,"正比",120) end
if t==(1) then R.change(o,"head",0,3600,1,"正比",600) end
if t==(60) then R.change(o,"sonspeedd",540,0,2,"正比",300) end
if t==(1) then R.change(o,"sonspeed",8,0.5,0,"正比",1) end
if t==(1) then R.change(o,"alpha",11,5,0,"正比",30) end
if t==(2) then R.change(o,"sonspeed",0.1,0,0,"正比",360) end
if t==(1) then R.change(o,"sonspeedd",40,0,2,"正比",60) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=456,["begin"]=1403,["life"]=330,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.3,["speedd"]=240,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=360,["type"]=171,["wscale"]=0,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=0.7,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",20,0,1,"正比",360) end
end,Sonevents=function(o,t,R)
if t==(480) then R.change(o,"alpha",1,0,0,"正比",120) end
if t==(1) then R.change(o,"head",0,3600,1,"正比",600) end
if t==(60) then R.change(o,"sonspeedd",540,0,2,"正比",300) end
if t==(1) then R.change(o,"sonspeed",8,0.5,0,"正比",1) end
if t==(1) then R.change(o,"alpha",44,22,0,"正比",30) end
if t==(1) then R.change(o,"type",2,2,1,"正比",1) end
if t==(2) then R.change(o,"sonspeed",0.1,0,0,"正比",360) end
if t==(1) then R.change(o,"sonspeedd",40,0,2,"正比",60) end
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.7,0,0,"无缝正弦",30) end
end}
}}
