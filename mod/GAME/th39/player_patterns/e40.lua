return {["id"]="40",["total"]=3200,["order"]=0,["centerAvailable"]=true,["center"]={480,360,0,0,0,0},["types"]={{0,0,100,100,50,60,0,0,20,2,0,0,0,0,0,"huohuohuo"},{100,0,100,100,50,60,0,0,20,2,0,0,0,0,0,"huohuohuo"},{200,0,100,100,50,60,0,0,20,2,0,0,0,0,0,"huohuohuo"},{0,0,100,100,50,60,0,0,20,1,0,0,0,0,0,"huohuohuo"},{100,0,100,100,50,60,0,0,20,1,0,0,0,0,0,"huohuohuo"},{200,0,100,100,50,60,0,0,20,1,0,0,0,0,0,"huohuohuo"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=3200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=24,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=176,["type"]=152,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=125,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"type",1,0,1,"正比",1) end
if t==(120) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1) then R.change(o,"wscale",1.5,0.3,0,"正比",1) end
if t==(1) then R.change(o,"hscale",1.2,0.3,0,"正比",1) end
if t==(1) then R.change(o,"alpha",55,0,0,"正比",15) end
if t==(156) then R.change(o,"alpha",15,0,0,"正比",20) end
if t==(70) then R.change(o,"sonspeed",3,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",50) end
if t==(156) then R.change(o,"hscale",0.5,0,0,"正比",20) end
if t==(156) then R.change(o,"wscale",0.5,0,0,"正比",20) end
if t==(120) then R.change(o,"alpha",22,11,0,"正比",15) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",1,0,0,"无缝正弦",60) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=1,["life"]=3200,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=116,["type"]=155,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(40) then R.change(o,"type",1,0,1,"正比",1) end
if t==(80) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1) then R.change(o,"wscale",-1.2,0.3,0,"正比",1) end
if t==(1) then R.change(o,"hscale",1.2,0.1,0,"正比",1) end
if t==(1) then R.change(o,"alpha",55,0,0,"正比",15) end
if t==(90) then R.change(o,"alpha",13,0,0,"正比",30) end
if t==(70) then R.change(o,"sonspeed",3,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",50) end
if t==(90) then R.change(o,"hscale",0.5,0,0,"正比",36) end
if t==(90) then R.change(o,"wscale",0.5,0,0,"正比",36) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",1,0,0,"无缝正弦",60) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=5,["life"]=3196,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=106,["type"]=155,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=10,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=50,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(30) then R.change(o,"type",1,0,1,"正比",1) end
if t==(70) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1) then R.change(o,"wscale",1.2,0.3,0,"正比",1) end
if t==(1) then R.change(o,"hscale",1.4,0.1,0,"正比",1) end
if t==(1) then R.change(o,"alpha",55,0,0,"正比",15) end
if t==(80) then R.change(o,"alpha",13,0,0,"正比",30) end
if t==(60) then R.change(o,"sonspeed",3,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",50) end
if t==(80) then R.change(o,"hscale",0.5,0,0,"正比",36) end
if t==(80) then R.change(o,"wscale",0.5,0,0,"正比",36) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",1,0,0,"无缝正弦",60) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=13,["life"]=3188,["fx"]=-99998,["fy"]=-99998,["r"]=10,["rdirection"]=270,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=24,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=176,["type"]=152,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=125,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(60) then R.change(o,"type",1,0,1,"正比",1) end
if t==(120) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1) then R.change(o,"wscale",-1.3,0.3,0,"正比",1) end
if t==(1) then R.change(o,"hscale",1.4,0.3,0,"正比",1) end
if t==(1) then R.change(o,"alpha",55,0,0,"正比",15) end
if t==(136) then R.change(o,"alpha",15,0,0,"正比",20) end
if t==(70) then R.change(o,"sonspeed",3,0,0,"正比",20) end
if t==(1) then R.change(o,"sonspeed",1,0,0,"正比",50) end
if t==(156) then R.change(o,"hscale",0.5,0,0,"正比",20) end
if t==(156) then R.change(o,"wscale",0.5,0,0,"正比",20) end
if t==(120) then R.change(o,"alpha",22,11,0,"正比",15) end
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",1,0,0,"无缝正弦",60) end
end}
}}
