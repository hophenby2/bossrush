return {["id"]="647",["total"]=720,["order"]=1,["centerAvailable"]=true,["center"]={480,320,0,0,0,0},["types"]={{0,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{110,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{220,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{330,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{0,230,440,300,220,160,0,0,1,0,0,0,0,0,0,"6boss-1"},{0,530,150,100,75,50,0,0,1,0,0,0,0,0,0,"6boss-1"},{150,530,100,100,50,50,0,0,1,0,0,0,0,0,0,"6boss-1"},{0,0,160,250,80,125,0,0,6,5,0,0,0,0,0,"6boss-2"},{0,1250,160,250,80,125,0,0,1,0,0,0,0,0,0,"6boss-2"},{0,0,160,250,80,125,0,0,1,0,0,0,0,0,0,"6boss-2"},{0,0,100,100,50,50,0,0,1,0,0,0,0,0,0,"6boss-shuzhi"},{0,0,100,100,50,50,0,0,1,0,0,0,0,0,0,"6boss-shuzhi2"},{0,0,500,500,250,250,0,0,4,5,0,0,0,0,0,"6-dianqiu"},{0,0,500,500,250,250,110,0,1,0,0,0,0,0,0,"6-dianqiu2"}},centerEvents=function(o,t,R)
if t==(60) then R.sound("tan") end
end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["x"]=640,["y"]=360,["begin"]=280,["life"]=441,["halfw"]=2100,["halfh"]=2100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(150) then R.change(o,"wscale",0,0,0,"正比",5) end
if t==(400) then R.change(o,"type",162,0,0,"正比",1) end
if t==(156) then R.change(o,"life",0,0,0,"正比",5) end
if t==(400) then R.change(o,"wscale",0.3,0,0,"正比",5) end
if t==(405) then R.change(o,"wscale",0.13,0,1,"正比",100) end
if t==(480) then R.change(o,"alpha",0,0,0,"正比",40) end
if t==(280) then R.change(o,"alpha",100,0,0,"正比",30) end
if t==(301) then R.change(o,"alpha",100,0,0,"正比",30) end
end},
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=328,["begin"]=61,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=80,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=6,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=160,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(30) then R.change(o,"sonspeedd",270,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=true,["x"]=288,["y"]=328,["begin"]=2,["life"]=120,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=162,["wscale"]=0.11,["hscale"]=0.31,["colorR"]=180,["colorG"]=180,["colorB"]=180,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"colorR",255,0,0,"无缝正弦",120) end
if t==(41+math.floor(t/120)*120) then R.change(o,"colorB",255,0,0,"无缝正弦",120) end
if t==(81+math.floor(t/120)*120) then R.change(o,"colorG",255,0,0,"无缝正弦",120) end
if t==(1) then R.change(o,"wscale",0.18,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",0.15,0,0,"正比",30) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=320,["y"]=328,["begin"]=400,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=11,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=17,["wscale"]=1,["hscale"]=0.3,["colorR"]=155,["colorG"]=155,["colorB"]=155,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",0.13,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",1.5,0,0,"正比",30) end
if t==(60) then R.change(o,"alpha",80,0,0,"正比",1) end
if t==(60) then R.change(o,"hscale",0,0,0,"正比",20) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=288,["y"]=360,["begin"]=1,["life"]=30,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=30,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=400,["type"]=147,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(2) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",80,0,0,"正比",3) end
if t==(1) then R.change(o,"hscale",0,0,0,"正比",29) end
if t==(30) then R.change(o,"wscale",1,0,0,"正比",15) end
if t==(30) then R.change(o,"hscale",1,0,0,"正比",15) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",29) end
if t==(30) then R.change(o,"alpha",100,0,0,"正比",3) end
if t==(360) then R.change(o,"wscale",1,0,0,"正比",60) end
if t==(360) then R.change(o,"hscale",1,0,0,"正比",60) end
end}
}}
