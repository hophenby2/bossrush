return {["id"]="41",["total"]=13000,["order"]=1,["centerAvailable"]=false,["center"]={481,360,0,0,0,0},["types"]={{0,0,554,1126,277,1126,0,0,1,0,0,0,0,0,0,"scene/4bg-01"},{0,0,592,1056,296,1056,0,0,1,0,0,0,0,0,0,"scene/4bg-02"},{0,0,641,543,320,600,0,0,1,0,0,0,0,0,0,"scene/4bg-03"},{0,0,505,249,252,120,0,0,1,0,0,0,0,0,0,"scene/4bgw-01"},{0,0,380,260,190,130,0,0,1,0,0,0,0,0,0,"scene/4bgw-02"},{0,0,554,1126,277,1126,0,0,1,0,0,0,0,0,0,"scene/4bg-04"},{0,0,592,1056,296,1056,0,0,1,0,0,0,0,0,0,"scene/4bg-05"},{0,0,641,543,320,543,0,0,1,0,0,0,0,0,0,"scene/4bg-06"},{0,0,409,798,200,600,0,1,1,0,0,0,0,0,0,"scene/4bg-07"},{0,0,409,798,200,600,0,0,1,0,0,0,0,0,0,"scene/4bg-08"},{0,0,600,2400,300,2400,0,0,1,0,0,0,0,0,0,"scene/4bgs-01"},{0,0,600,2400,300,2400,0,0,1,0,0,0,0,0,0,"scene/4bgs-02"},{0,0,600,2400,300,2400,0,0,1,0,0,0,0,0,0,"scene/4bgshu-01"},{0,0,600,800,300,400,0,0,1,0,0,0,0,0,0,"scene/4bg-09"},{0,0,600,800,300,400,0,0,1,0,0,0,0,0,0,"scene/4bg-10"},{0,0,400,400,200,210,0,0,1,0,0,0,0,0,0,"scene/4bg-11"},{0,0,62,390,31,10,0,0,1,0,0,0,0,0,0,"scene/4bgshui-01"},{0,0,52,338,26,10,0,0,1,0,0,0,0,0,0,"scene/4bgshui-02"},{0,0,50,40,25,20,0,0,6,1,0,0,0,0,0,"scene/4bg-guai1"},{0,0,50,50,25,25,0,0,6,4,0,0,0,0,0,"scene/4bg-guai2"},{0,0,150,100,90,50,0,0,7,3,0,0,0,0,0,"scene/4bghuo-01"},{0,0,500,500,250,250,0,0,1,0,0,0,0,0,0,"scene/4-niao"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["x"]=480,["y"]=296,["begin"]=1,["life"]=13000,["halfw"]=600,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=8,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5150) then R.change(o,"alpha",30,10,0,"正比",200) end
end},
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=3,["life"]=4498,["fx"]=-99998,["fy"]=100,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=111300,["fdirection"]=88,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2400,["type"]=152,["wscale"]=1.2,["hscale"]=1.1,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(2+math.floor(t/2200)*2200) then R.change(o,"type",1,0,1,"正比",1) end
if t==(602+math.floor(t/2200)*2200) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1202+math.floor(t/2200)*2200) then R.change(o,"type",2,0,2,"正比",1) end
if t==(1+math.floor(t/2200)*2200) then R.fire(o) end
if t==(601+math.floor(t/2200)*2200) then R.fire(o) end
if t==(1101+math.floor(t/2200)*2200) then R.fire(o) end
if t==(1+math.floor(t/2200)*2200) then R.change(o,"fdirection",88,0,0,"正比",1) end
if t==(600+math.floor(t/2200)*2200) then R.change(o,"fdirection",92,0,0,"正比",1) end
if t==(1200+math.floor(t/2200)*2200) then R.change(o,"fdirection",90,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(601) then R.change(o,"hscale",0.1,0,1,"正比",1200) end
if t==(601) then R.change(o,"sonspeed",0.1,0,1,"正比",1200) end
if t==(301) then R.change(o,"colorR",215,0,0,"正比",800) end
if t==(601) then R.change(o,"wscale",0.2,0,1,"正比",1200) end
if t==(1601) then R.change(o,"colorB",1,0,0,"正比",600) end
if t==(1601) then R.change(o,"colorR",1,0,0,"正比",600) end
if t==(1601) then R.change(o,"colorG",1,0,0,"正比",600) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=488,["begin"]=2,["life"]=1,["fx"]=-99998,["fy"]=500,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=92,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2400,["type"]=153,["wscale"]=1.2,["hscale"]=1.1,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.1,0,1,"正比",1200) end
if t==(1) then R.change(o,"sonspeed",0.2,0,1,"正比",1200) end
if t==(1001) then R.change(o,"colorB",1,0,0,"正比",800) end
if t==(1) then R.change(o,"wscale",0.2,0,1,"正比",1200) end
if t==(201) then R.change(o,"colorR",215,0,0,"正比",800) end
if t==(1001) then R.change(o,"colorR",1,0,0,"正比",800) end
if t==(1001) then R.change(o,"colorG",1,0,0,"正比",800) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=520,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=900,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=88,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2400,["type"]=153,["wscale"]=-1.2,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.1,0,1,"正比",1200) end
if t==(1) then R.change(o,"sonspeed",0.2,0,1,"正比",1200) end
if t==(1) then R.change(o,"wscale",0.2,0,2,"正比",1200) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=424,["begin"]=1103,["life"]=3098,["fx"]=-99998,["fy"]=100,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=111300,["fdirection"]=88,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2400,["type"]=152,["wscale"]=-1.2,["hscale"]=1.1,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(2+math.floor(t/2200)*2200) then R.change(o,"type",1,0,1,"正比",1) end
if t==(602+math.floor(t/2200)*2200) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1202+math.floor(t/2200)*2200) then R.change(o,"type",2,0,2,"正比",1) end
if t==(1+math.floor(t/2200)*2200) then R.fire(o) end
if t==(601+math.floor(t/2200)*2200) then R.fire(o) end
if t==(1101+math.floor(t/2200)*2200) then R.fire(o) end
if t==(1+math.floor(t/2200)*2200) then R.change(o,"fdirection",88,0,0,"正比",1) end
if t==(600+math.floor(t/2200)*2200) then R.change(o,"fdirection",92,0,0,"正比",1) end
if t==(1200+math.floor(t/2200)*2200) then R.change(o,"fdirection",90,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(601) then R.change(o,"hscale",0.1,0,1,"正比",1200) end
if t==(601) then R.change(o,"sonspeed",0.2,0,1,"正比",1200) end
if t==(301) then R.change(o,"colorR",215,0,0,"正比",800) end
if t==(601) then R.change(o,"wscale",0.2,0,2,"正比",1200) end
if t==(1601) then R.change(o,"colorB",1,0,0,"正比",600) end
if t==(1601) then R.change(o,"colorR",1,0,0,"正比",600) end
if t==(1601) then R.change(o,"colorG",1,0,0,"正比",600) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=232,["begin"]=5100,["life"]=7801,["fx"]=-99998,["fy"]=0,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=16,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1220,["type"]=172,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=6,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"hscale",1,0,1,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"wscale",1,0,1,"正弦",12) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",28,15,0,"正比",60) end
if t==(1001) then R.change(o,"alpha",1,0,0,"正比",120) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=608,["y"]=392,["begin"]=2,["life"]=4197,["fx"]=-99998,["fy"]=-130,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1100,["fdirection"]=87,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2400,["type"]=160,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(601) then R.change(o,"hscale",0.1,0,1,"正比",1200) end
if t==(601) then R.change(o,"sonspeed",0.2,0,1,"正比",1200) end
if t==(601) then R.change(o,"colorR",215,0,0,"正比",800) end
if t==(601) then R.change(o,"wscale",0.2,0,1,"正比",1200) end
if t==(1601) then R.change(o,"colorB",1,0,0,"正比",600) end
if t==(1601) then R.change(o,"colorR",1,0,0,"正比",600) end
if t==(1601) then R.change(o,"colorG",1,0,0,"正比",600) end
end},
{["id"]=6,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=392,["begin"]=1102,["life"]=4050,["fx"]=-99998,["fy"]=-250,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1100,["fdirection"]=93,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2400,["type"]=160,["wscale"]=-1.2,["hscale"]=1.1,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(801) then R.change(o,"hscale",0.1,0,1,"正比",1200) end
if t==(801) then R.change(o,"sonspeed",0.2,0,1,"正比",1200) end
if t==(801) then R.change(o,"colorR",215,0,0,"正比",800) end
if t==(801) then R.change(o,"wscale",0.2,0,2,"正比",1200) end
if t==(1801) then R.change(o,"colorB",1,0,0,"正比",600) end
if t==(1801) then R.change(o,"colorR",1,0,0,"正比",600) end
if t==(1801) then R.change(o,"colorG",1,0,0,"正比",600) end
end},
{["id"]=7,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=4001,["life"]=1100,["fx"]=-99998,["fy"]=0,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=11,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1220,["type"]=172,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=6,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"hscale",1,0,1,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"wscale",1,0,1,"正弦",12) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=1,["x"]=544,["y"]=296,["begin"]=1,["life"]=13000,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=0,["controlid"]=1,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(5600) then R.change(o,"alpha",100,0,0,"固定",1) end
if t==(5200) then R.change(o,"alpha",100,0,0,"正比",300) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=3,["life"]=12998,["fx"]=-99998,["fy"]=100,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=111300,["fdirection"]=88,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=-1.2,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(2+math.floor(t/2200)*2200) then R.change(o,"type",1,0,1,"正比",1) end
if t==(602+math.floor(t/2200)*2200) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1202+math.floor(t/2200)*2200) then R.change(o,"type",2,0,2,"正比",1) end
if t==(1+math.floor(t/2200)*2200) then R.fire(o) end
if t==(601+math.floor(t/2200)*2200) then R.fire(o) end
if t==(1101+math.floor(t/2200)*2200) then R.fire(o) end
if t==(1+math.floor(t/2200)*2200) then R.change(o,"fdirection",88,0,0,"正比",1) end
if t==(600+math.floor(t/2200)*2200) then R.change(o,"fdirection",92,0,0,"正比",1) end
if t==(1200+math.floor(t/2200)*2200) then R.change(o,"fdirection",90,0,0,"正比",1) end
if t==(5600) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(3000) then R.change(o,"life",2400,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(601) then R.change(o,"hscale",0.1,0,1,"正比",1200) end
if t==(601) then R.change(o,"sonspeed",0.2,0,1,"正比",1200) end
if t==(601) then R.change(o,"wscale",0.2,0,2,"正比",1200) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=328,["begin"]=1103,["life"]=11898,["fx"]=-99998,["fy"]=100,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=111300,["fdirection"]=88,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=1.2,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(2+math.floor(t/2200)*2200) then R.change(o,"type",1,0,1,"正比",1) end
if t==(602+math.floor(t/2200)*2200) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1202+math.floor(t/2200)*2200) then R.change(o,"type",2,0,2,"正比",1) end
if t==(1+math.floor(t/2200)*2200) then R.fire(o) end
if t==(601+math.floor(t/2200)*2200) then R.fire(o) end
if t==(1101+math.floor(t/2200)*2200) then R.fire(o) end
if t==(1+math.floor(t/2200)*2200) then R.change(o,"fdirection",88,0,0,"正比",1) end
if t==(600+math.floor(t/2200)*2200) then R.change(o,"fdirection",92,0,0,"正比",1) end
if t==(1200+math.floor(t/2200)*2200) then R.change(o,"fdirection",90,0,0,"正比",1) end
if t==(5600) then R.change(o,"alpha",100,0,0,"正比",1) end
if t==(3000) then R.change(o,"life",2400,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(601) then R.change(o,"hscale",0.1,0,1,"正比",1200) end
if t==(601) then R.change(o,"sonspeed",0.2,0,1,"正比",1200) end
if t==(601) then R.change(o,"wscale",0.2,0,1,"正比",1200) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=205,["y"]=32,["begin"]=5050,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=107,["wscale"]=1,["hscale"]=31,["colorR"]=255,["colorG"]=115,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",88,0,0,"正比",360) end
if t==(1) then R.change(o,"hscale",88,0,0,"正比",360) end
if t==(180) then R.change(o,"alpha",36,0,0,"正比",180) end
if t==(1) then R.change(o,"alpha",30,0,0,"正比",180) end
if t==(420) then R.change(o,"alpha",1,0,0,"正比",180) end
end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=608,["y"]=424,["begin"]=2,["life"]=8197,["fx"]=-99998,["fy"]=-130,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1100,["fdirection"]=87,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=161,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(4000) then R.change(o,"life",2400,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(601) then R.change(o,"hscale",0.1,0,1,"正比",1200) end
if t==(601) then R.change(o,"sonspeed",0.2,0,1,"正比",1200) end
if t==(601) then R.change(o,"wscale",0.2,0,1,"正比",1200) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=424,["begin"]=1102,["life"]=7050,["fx"]=-99998,["fy"]=-250,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1100,["fdirection"]=93,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=161,["wscale"]=-1.2,["hscale"]=1.1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(4000) then R.change(o,"life",2400,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(801) then R.change(o,"hscale",0.1,0,1,"正比",1200) end
if t==(801) then R.change(o,"sonspeed",0.2,0,1,"正比",1200) end
if t==(801) then R.change(o,"wscale",0.2,0,2,"正比",1200) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=584,["begin"]=1,["life"]=5400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=167,["wscale"]=5,["hscale"]=5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=44,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fx","自机",0,0,"固定",1) end
if t>(1) then R.change(o,"fy","自机",0,0,"固定",1) end
if t==(600) then R.change(o,"alpha",20,0,0,"正比",300) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=584,["begin"]=1,["life"]=1,["fx"]=480,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5200,["type"]=97,["wscale"]=66,["hscale"]=88,["colorR"]=1,["colorG"]=215,["colorB"]=255,["alpha"]=8,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5000) then R.change(o,"alpha",1,0,0,"正比",200) end
end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=640,["y"]=456,["begin"]=1,["life"]=12801,["fx"]=360,["fy"]=100,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999999,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1800,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(91) then R.fire(o) end
if t==(90) then R.change(o,"fx",370,0,0,"正比",1) end
if t==(3) then R.change(o,"fy",-350,0,0,"正比",1) end
if t==(2) then R.fire(o) end
if t==(1) then R.change(o,"fx",560,0,0,"正比",1) end
if t==(840) then R.change(o,"fx",560,0,0,"正比",1) end
if t==(843) then R.fire(o) end
if t==(1760) then R.change(o,"fx",400,0,0,"正比",1) end
if t==(1761) then R.fire(o) end
if t==(2240) then R.change(o,"fx",600,0,0,"正比",1) end
if t==(2241) then R.fire(o) end
if t==(3010) then R.change(o,"fx",400,0,0,"正比",1) end
if t==(3011) then R.fire(o) end
if t==(3320) then R.change(o,"fx",590,0,0,"正比",1) end
if t==(3321) then R.fire(o) end
if t==(3730) then R.change(o,"fx",290,0,0,"正比",1) end
if t==(3731) then R.fire(o) end
if t==(3830) then R.change(o,"fx",400,0,0,"正比",1) end
if t==(3831) then R.fire(o) end
if t==(4570) then R.change(o,"fx",580,0,0,"正比",1) end
if t==(4571) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=640,["y"]=519,["begin"]=1,["life"]=13000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=55,["type"]=17,["wscale"]=1.3,["hscale"]=3,["colorR"]=1,["colorG"]=88,["colorB"]=111,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0,0.2,1,"正弦",29) end
if t==(5100) then R.change(o,"colorR",255,0,0,"正比",100) end
if t==(5100) then R.change(o,"colorB",1,0,0,"正比",100) end
if t==(5100) then R.change(o,"colorG",1,0,0,"正比",100) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",50,20,0,"正比",5) end
if t==(1) then R.change(o,"hscale",3,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.5,0.2,0,"正比",60) end
if t==(11) then R.change(o,"colorB",22,0,0,"正比",40) end
if t==(11) then R.change(o,"alpha",0,0,0,"正比",40) end
if t==(11) then R.change(o,"colorG",13,0,0,"正比",40) end
end},
{["id"]=9,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=640,["y"]=552,["begin"]=1,["life"]=13000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=20,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=168,["wscale"]=0.8,["hscale"]=0.01,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0,0.2,1,"正弦",29) end
if t==(5000) then R.change(o,"colorG",1,0,0,"正比",100) end
if t==(5000) then R.change(o,"colorB",1,0,0,"正比",100) end
if t==(5200) then R.change(o,"Blend",1,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",30,20,0,"正比",10) end
if t==(1) then R.change(o,"hscale",0.6,0.2,0,"正比",40) end
if t==(1) then R.change(o,"wscale",0.4,0.1,0,"正比",60) end
if t==(31) then R.change(o,"alpha",0,0,0,"正比",50) end
end},
{["id"]=10,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=640,["y"]=584,["begin"]=9,["life"]=12992,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=20,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=169,["wscale"]=0.8,["hscale"]=0.01,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0,0.2,1,"正弦",29) end
if t==(5200) then R.change(o,"colorG",1,0,0,"正比",1) end
if t==(5200) then R.change(o,"colorB",1,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",30,10,0,"正比",10) end
if t==(1) then R.change(o,"hscale",0.6,0.2,0,"正比",40) end
if t==(1) then R.change(o,"wscale",0.3,0.1,0,"正比",60) end
if t==(31) then R.change(o,"alpha",0,0,0,"正比",50) end
end},
{["id"]=11,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=640,["y"]=616,["begin"]=5200,["life"]=1801,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=17,["wscale"]=1,["hscale"]=3,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0,0.2,1,"正弦",29) end
if t==(1) then R.change(o,"alpha",30,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",30,10,0,"正比",5) end
if t==(1) then R.change(o,"hscale",3,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.5,0.2,0,"正比",60) end
if t==(11) then R.change(o,"alpha",0,0,0,"正比",40) end
end},
{["id"]=12,["parentid"]=1,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=640,["y"]=648,["begin"]=5200,["life"]=1801,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=169,["wscale"]=1,["hscale"]=0.01,["colorR"]=255,["colorG"]=205,["colorB"]=122,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0,0.2,1,"正弦",29) end
if t==(1) then R.change(o,"alpha",30,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",30,10,0,"正比",5) end
if t==(1) then R.change(o,"hscale",1,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.5,0.2,0,"正比",60) end
if t==(11) then R.change(o,"alpha",0,0,0,"正比",40) end
end},
{["id"]=13,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=672,["y"]=456,["begin"]=1,["life"]=12801,["fx"]=360,["fy"]=100,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=999999,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1800,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(91) then R.fire(o) end
if t==(90) then R.change(o,"fx",300,0,0,"正比",1) end
if t==(3) then R.change(o,"fy",-350,0,0,"正比",1) end
if t==(2) then R.fire(o) end
if t==(1) then R.change(o,"fx",620,0,0,"正比",1) end
if t==(840) then R.change(o,"fx",660,0,0,"正比",1) end
if t==(843) then R.fire(o) end
if t==(1760) then R.change(o,"fx",310,0,0,"正比",1) end
if t==(1761) then R.fire(o) end
if t==(2240) then R.change(o,"fx",670,0,0,"正比",1) end
if t==(2241) then R.fire(o) end
if t==(3010) then R.change(o,"fx",300,0,0,"正比",1) end
if t==(3011) then R.fire(o) end
if t==(3320) then R.change(o,"fx",680,0,0,"正比",1) end
if t==(3321) then R.fire(o) end
if t==(3730) then R.change(o,"fx",280,0,0,"正比",1) end
if t==(3731) then R.fire(o) end
if t==(3830) then R.change(o,"fx",330,0,0,"正比",1) end
if t==(3831) then R.fire(o) end
if t==(4570) then R.change(o,"fx",680,0,0,"正比",1) end
if t==(4571) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=14,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=false,["x"]=672,["y"]=519,["begin"]=1,["life"]=13000,["fx"]=-99998,["fy"]=-99998,["r"]=30,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=55,["type"]=17,["wscale"]=3,["hscale"]=5,["colorR"]=1,["colorG"]=88,["colorB"]=111,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=8,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0,0.2,1,"正弦",29) end
if t==(5100) then R.change(o,"colorR",255,0,0,"正比",100) end
if t==(5100) then R.change(o,"colorB",1,0,0,"正比",100) end
if t==(5100) then R.change(o,"colorG",1,0,0,"正比",100) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",50,20,0,"正比",5) end
if t==(1) then R.change(o,"hscale",3,0,0,"正比",60) end
if t==(1) then R.change(o,"wscale",0.5,0.2,0,"正比",60) end
if t==(11) then R.change(o,"colorB",22,0,0,"正比",40) end
if t==(11) then R.change(o,"alpha",0,0,0,"正比",40) end
if t==(11) then R.change(o,"colorG",13,0,0,"正比",40) end
end},
{["id"]=15,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=false,["x"]=672,["y"]=552,["begin"]=1,["life"]=13000,["fx"]=-99998,["fy"]=-99998,["r"]=30,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=20,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=168,["wscale"]=1.5,["hscale"]=0.01,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0,0.2,1,"正弦",29) end
if t==(5000) then R.change(o,"colorG",1,0,0,"正比",100) end
if t==(5000) then R.change(o,"colorB",1,0,0,"正比",100) end
if t==(5200) then R.change(o,"Blend",1,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",30,20,0,"正比",10) end
if t==(1) then R.change(o,"hscale",0.8,0.2,0,"正比",40) end
if t==(1) then R.change(o,"wscale",1,0.1,0,"正比",60) end
if t==(31) then R.change(o,"alpha",0,0,0,"正比",50) end
end},
{["id"]=16,["parentid"]=1,["Binding"]=false,["bindid"]=13,["Bindwithspeedd"]=false,["x"]=672,["y"]=584,["begin"]=9,["life"]=12992,["fx"]=-99998,["fy"]=-99998,["r"]=30,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=20,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=80,["type"]=169,["wscale"]=1.5,["hscale"]=0.01,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=6,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0,0.2,1,"正弦",29) end
if t==(5200) then R.change(o,"colorG",1,0,0,"正比",1) end
if t==(5200) then R.change(o,"colorB",1,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",30,10,0,"正比",10) end
if t==(1) then R.change(o,"hscale",0.6,0.2,0,"正比",40) end
if t==(1) then R.change(o,"wscale",1,0.1,0,"正比",60) end
if t==(31) then R.change(o,"alpha",0,0,0,"正比",50) end
end},
{["id"]=0,["parentid"]=2,["x"]=544,["y"]=424,["begin"]=1,["life"]=13000,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=30,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5200) then R.change(o,"sonspeed",0.1,0,0,"正比",60) end
if t==(5200) then R.change(o,"colorR",99,0,0,"正比",60) end
if t==(5260) then R.change(o,"sonspeedd",0,360,1,"固定",10) end
if t==(5260) then R.change(o,"sonspeed",7,2,0,"正比",60) end
if t==(5200) then R.change(o,"colorG",66,0,0,"正比",60) end
if t==(5200) then R.change(o,"colorB",1,0,0,"正比",60) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=200,["begin"]=1,["life"]=8200,["fx"]=-99998,["fy"]=-99998,["r"]=300,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=170,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=155,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=215,["colorG"]=255,["colorB"]=255,["alpha"]=10,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=90,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",30,10,0,"正比",400) end
if t==(1) then R.change(o,"sonspeed",1,0,1,"正比",400) end
if t==(1) then R.change(o,"wscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=200,["begin"]=61,["life"]=8140,["fx"]=-99998,["fy"]=-99998,["r"]=300,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=190,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1600,["type"]=156,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=215,["colorG"]=255,["colorB"]=255,["alpha"]=30,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=70,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",30,10,0,"正比",400) end
if t==(1) then R.change(o,"sonspeed",1,0,1,"正比",400) end
if t==(1) then R.change(o,"wscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=232,["begin"]=61,["life"]=8140,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=160,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=215,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=50,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(401) then R.change(o,"alpha",20,10,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",1,0,1,"正比",400) end
if t==(1) then R.change(o,"wscale",1,0.5,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",400) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=232,["begin"]=61,["life"]=8140,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=140,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1600,["type"]=155,["wscale"]=1,["hscale"]=1,["colorR"]=155,["colorG"]=255,["colorB"]=255,["alpha"]=50,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=50,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(401) then R.change(o,"alpha",20,10,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",1,0,1,"正比",400) end
if t==(1) then R.change(o,"wscale",1,0.5,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",200) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=584,["begin"]=2,["life"]=13,["fx"]=-99998,["fy"]=-99998,["r"]=300,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=20,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=155,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(51) then R.change(o,"alpha",20,10,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",1,0.5,0,"正比",1) end
if t==(1) then R.change(o,"wscale",1,0.5,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"alpha",40,10,0,"正比",61) end
if t==(2) then R.change(o,"sonspeed",1,0,1,"正比",400) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=616,["begin"]=2,["life"]=13,["fx"]=-99998,["fy"]=-99998,["r"]=300,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=40,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=155,["wscale"]=1,["hscale"]=1,["colorR"]=155,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(51) then R.change(o,"alpha",20,10,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",1,0.5,0,"正比",1) end
if t==(1) then R.change(o,"wscale",1,0.5,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"alpha",40,10,0,"正比",61) end
if t==(2) then R.change(o,"sonspeed",1,0,1,"正比",800) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=552,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=420,["type"]=98,["wscale"]=66,["hscale"]=66,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",33,0,0,"正比",420) end
if t==(1) then R.change(o,"colorB",44,0,0,"正比",420) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",420) end
end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=296,["begin"]=4800,["life"]=7601,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=120,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1300,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=55,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=50,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(401) then R.change(o,"alpha",20,5,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",2,0,1,"正比",400) end
if t==(1) then R.change(o,"wscale",1,0.5,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",400) end
end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=232,["begin"]=4600,["life"]=8401,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=80,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1100,["type"]=155,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=55,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=90,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(401) then R.change(o,"alpha",20,5,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",2,0,1,"正比",400) end
if t==(1) then R.change(o,"wscale",1,0.5,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",400) end
end},
{["id"]=9,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=360,["begin"]=5200,["life"]=6901,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=2,["wscale"]=0.25,["hscale"]=0.25,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=170,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/7)*7) then R.change(o,"hscale",0.12,0,1,"正弦",6) end
if t==(1+math.floor(t/7)*7) then R.change(o,"wscale",0.12,0,1,"正弦",6) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/10)*10) then R.change(o,"wscale",0,0,0,"正弦",9) end
if t==(1) then R.change(o,"sonspeed",2,1.5,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,90,1,"正弦",180) end
if t==(1) then R.change(o,"alpha",80,20,0,"正比",20) end
if t==(1) then R.change(o,"head",0,9000,1,"正比",260) end
if t==(30) then R.change(o,"alpha",1,0,0,"正比",60) end
end},
{["id"]=10,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=328,["begin"]=5201,["life"]=7800,["fx"]=-99998,["fy"]=-99998,["r"]=400,["rdirection"]=220,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=16,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=2,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=90,["tiao"]=0,["t"]=0,["fdirection"]=20,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/7)*7) then R.change(o,"hscale",0.1,0,1,"正弦",6) end
if t==(1+math.floor(t/7)*7) then R.change(o,"wscale",0.1,0,1,"正弦",6) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/10)*10) then R.change(o,"wscale",0,0,0,"正弦",9) end
if t==(1) then R.change(o,"sonspeed",6,2,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,10,1,"正弦",180) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"head",0,9000,1,"正比",260) end
end},
{["id"]=11,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=5200,["life"]=7801,["fx"]=-99998,["fy"]=0,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=13,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=620,["type"]=172,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=125,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/7)*7) then R.change(o,"hscale",0.5,0,1,"正弦",6) end
if t==(1+math.floor(t/7)*7) then R.change(o,"wscale",0.5,0,1,"正弦",6) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",2,0,0,"正比",60) end
if t==(61) then R.change(o,"alpha",1,0,0,"正比",560) end
end},
{["id"]=12,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=552,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=98,["wscale"]=66,["hscale"]=66,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=99,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",33,0,0,"正比",180) end
if t==(1) then R.change(o,"colorB",33,0,0,"正比",180) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",120) end
end},
{["id"]=13,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=5200,["life"]=6901,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=2,["wscale"]=0.25,["hscale"]=0.25,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=170,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/7)*7) then R.change(o,"hscale",0.12,0,1,"正弦",6) end
if t==(1+math.floor(t/7)*7) then R.change(o,"wscale",0.12,0,1,"正弦",6) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/10)*10) then R.change(o,"wscale",0,0,0,"正弦",9) end
if t==(1) then R.change(o,"sonspeed",2,1.5,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,90,1,"正弦",180) end
if t==(1) then R.change(o,"alpha",60,20,0,"正比",20) end
if t==(1) then R.change(o,"head",0,9000,1,"正比",260) end
if t==(30) then R.change(o,"colorR",1,0,0,"正比",30) end
if t==(30) then R.change(o,"colorG",1,0,0,"正比",30) end
if t==(60) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=14,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=328,["begin"]=5200,["life"]=6901,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=11,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=90,["type"]=26,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=170,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/7)*7) then R.change(o,"hscale",0.12,0,1,"正弦",6) end
if t==(1+math.floor(t/7)*7) then R.change(o,"wscale",0.12,0,1,"正弦",6) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/18)*18) then R.change(o,"wscale",0,0,0,"正弦",17) end
if t==(1) then R.change(o,"sonspeed",2,1.5,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,90,1,"正弦",180) end
if t==(1) then R.change(o,"alpha",40,20,0,"正比",20) end
if t==(1) then R.change(o,"head",0,9000,1,"正比",260) end
if t==(1) then R.change(o,"colorR",1,0,0,"正比",30) end
if t==(1) then R.change(o,"colorG",1,0,0,"正比",30) end
if t==(60) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=15,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=40,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=700,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=3200,["type"]=162,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=16,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=72,["begin"]=1600,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=3200,["type"]=162,["wscale"]=-1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=17,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=136,["begin"]=4800,["life"]=8201,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2100,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=3200,["type"]=163,["wscale"]=-1,["hscale"]=1,["colorR"]=155,["colorG"]=66,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(2) then R.change(o,"colorR",255,0,0,"正比",1) end
if t==(2) then R.change(o,"colorG",185,0,0,"正比",1) end
if t==(2) then R.change(o,"colorB",185,0,0,"正比",1) end
if t==(3+math.floor(t/3200)*3200) then R.change(o,"wscale",1,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(600) then R.change(o,"colorR",255,0,0,"正比",300) end
if t==(600) then R.change(o,"colorG",185,0,0,"正比",300) end
if t==(600) then R.change(o,"colorB",185,0,0,"正比",300) end
end},
{["id"]=18,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=104,["begin"]=3200,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=3200,["type"]=162,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(2000) then R.change(o,"colorR",144,0,0,"正比",300) end
if t==(2000) then R.change(o,"colorG",55,0,0,"正比",240) end
if t==(2000) then R.change(o,"colorB",1,0,0,"正比",200) end
end},
{["id"]=19,["parentid"]=2,["Binding"]=false,["bindid"]=20,["Bindwithspeedd"]=false,["x"]=206,["y"]=352,["begin"]=1,["life"]=13000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=350,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=170,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=24,["colorG"]=82,["colorB"]=106,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=100,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"colorR",20,0,1,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"colorG",30,0,1,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"colorB",30,0,1,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"hscale",0.1,0,2,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"wscale",0.1,0,2,"正弦",12) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"head",20,0,1,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,20,1,"正弦",120) end
end},
{["id"]=20,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=207,["y"]=309,["begin"]=501,["life"]=3201,["fx"]=200,["fy"]=360,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3200,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1000) then R.fire(o) end
if t==(1200) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=21,["parentid"]=2,["Binding"]=false,["bindid"]=22,["Bindwithspeedd"]=false,["x"]=246,["y"]=352,["begin"]=1,["life"]=13000,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=190,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=170,["wscale"]=-0.9,["hscale"]=0.9,["colorR"]=24,["colorG"]=82,["colorB"]=106,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=90,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=5,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"colorR",20,0,1,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"colorG",30,0,1,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"colorB",30,0,1,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"hscale",0.1,0,2,"正弦",12) end
if t==(1+math.floor(t/13)*13) then R.change(o,"wscale",0.1,0,1,"正弦",12) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"head",20,0,2,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,20,1,"正弦",120) end
end},
{["id"]=22,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=247,["y"]=309,["begin"]=1,["life"]=13000,["fx"]=800,["fy"]=500,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=99999,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=2,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=1.1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fy",400,0,0,"正比",1) end
if t==(92) then R.fire(o) end
if t==(700) then R.change(o,"fy",400,0,0,"正比",1) end
if t==(971) then R.fire(o) end
end,Sonevents=function(o,t,R)

end},
{["id"]=23,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=572,["y"]=474,["begin"]=2241,["life"]=240,["fx"]=-99998,["fy"]=390,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.8,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=171,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=175,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=360,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.1,0,1,"正弦",19) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.1,0,1,"正弦",19) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"head",90,0,2,"固定",1) end
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"colorG",218,0,0,"正比",120) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",120) end
if t==(60) then R.change(o,"sonspeed",8,3,1,"正比",120) end
if t==(1+math.floor(t/40)*40) then R.change(o,"sonspeedd",40,10,1,"正弦",39) end
end},
{["id"]=24,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=370,["y"]=474,["begin"]=12091,["life"]=160,["fx"]=-99998,["fy"]=580,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.9,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=171,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=175,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=360,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.1,0,1,"正弦",19) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.1,0,1,"正弦",19) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"head",90,0,2,"固定",1) end
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"colorG",218,0,0,"正比",120) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",120) end
if t==(50) then R.change(o,"sonspeed",8,2,1,"正比",120) end
if t==(1+math.floor(t/40)*40) then R.change(o,"sonspeedd",30,6,1,"正弦",39) end
end},
{["id"]=25,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=495,["y"]=474,["begin"]=2801,["life"]=280,["fx"]=-99998,["fy"]=300,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=171,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=175,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=360,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.1,0,1,"正弦",19) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.1,0,1,"正弦",19) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"head",90,0,2,"固定",1) end
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"colorG",218,0,0,"正比",120) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",120) end
if t==(60) then R.change(o,"sonspeed",8,3,1,"正比",120) end
if t==(1+math.floor(t/40)*40) then R.change(o,"sonspeedd",40,10,1,"正弦",39) end
end},
{["id"]=26,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=353,["y"]=506,["begin"]=4031,["life"]=250,["fx"]=-99998,["fy"]=400,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=171,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=175,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=360,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.1,0,1,"正弦",19) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.1,0,1,"正弦",19) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"head",90,0,2,"固定",1) end
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"colorG",218,0,0,"正比",120) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",120) end
if t==(60) then R.change(o,"sonspeed",8,3,1,"正比",120) end
if t==(1+math.floor(t/40)*40) then R.change(o,"sonspeedd",40,10,1,"正弦",39) end
end},
{["id"]=27,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=573,["y"]=506,["begin"]=4450,["life"]=290,["fx"]=-99998,["fy"]=400,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.8,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=171,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=175,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=360,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.1,0,1,"正弦",19) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.1,0,1,"正弦",19) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"head",90,0,2,"固定",1) end
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"colorG",218,0,0,"正比",120) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",120) end
if t==(60) then R.change(o,"sonspeed",8,3,1,"正比",120) end
if t==(1+math.floor(t/40)*40) then R.change(o,"sonspeedd",40,10,1,"正弦",39) end
end},
{["id"]=28,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=410,["y"]=506,["begin"]=3201,["life"]=310,["fx"]=-99998,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0.9,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=171,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=175,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=360,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.1,0,1,"正弦",19) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.1,0,1,"正弦",19) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"head",90,0,2,"固定",1) end
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"colorG",218,0,0,"正比",120) end
if t==(1) then R.change(o,"colorB",255,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",120) end
if t==(60) then R.change(o,"sonspeed",8,3,1,"正比",120) end
if t==(1+math.floor(t/40)*40) then R.change(o,"sonspeedd",40,10,1,"正弦",39) end
end},
{["id"]=29,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=495,["y"]=442,["begin"]=4980,["life"]=190,["fx"]=-99998,["fy"]=300,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=1,["speedd"]=90,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=171,["wscale"]=0.2,["hscale"]=0.2,["colorR"]=1,["colorG"]=175,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=40,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=360,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.1,0,1,"正弦",19) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.1,0,1,"正弦",19) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"head",90,0,2,"固定",1) end
if t==(1) then R.change(o,"wscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"hscale",0.7,0,1,"正比",120) end
if t==(1) then R.change(o,"colorR",155,0,0,"正比",120) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",120) end
if t==(60) then R.change(o,"sonspeed",8,3,1,"正比",120) end
if t==(1+math.floor(t/40)*40) then R.change(o,"sonspeedd",40,10,1,"正弦",39) end
end},
{["id"]=30,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=680,["begin"]=2120,["life"]=1,["fx"]=-99998,["fy"]=900,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=270,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=300,["type"]=173,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=1,["colorG"]=55,["colorB"]=66,["alpha"]=88,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=true,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",0.6,0,0,"正比",180) end
if t==(1) then R.change(o,"colorR",44,0,0,"正比",180) end
if t==(1+math.floor(t/60)*60) then R.change(o,"wscale",0.13,0,1,"无缝正弦",60) end
end},
{["id"]=31,["parentid"]=2,["Binding"]=false,["bindid"]=30,["Bindwithspeedd"]=false,["x"]=345,["y"]=677,["begin"]=321,["life"]=2430,["fx"]=-99998,["fy"]=-99998,["r"]=30,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=50,["type"]=145,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=44,["colorB"]=55,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=20,["r"]=40,["rdirection"]=10,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,13,0,"正比",1) end
if t==(1) then R.change(o,"hscale",0.1,0,0,"正比",55) end
if t==(1) then R.change(o,"head",0,900,1,"正比",60) end
if t==(1) then R.change(o,"sonspeed",1,1,0,"正比",1) end
if t==(1) then R.change(o,"wscale",0.1,0,0,"正比",55) end
end},
{["id"]=32,["parentid"]=2,["Binding"]=false,["bindid"]=30,["Bindwithspeedd"]=false,["x"]=377,["y"]=677,["begin"]=321,["life"]=2400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=146,["wscale"]=2,["hscale"]=2,["colorR"]=1,["colorG"]=22,["colorB"]=33,["alpha"]=66,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=20,["r"]=10,["rdirection"]=10,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,13,0,"正比",1) end
if t==(1) then R.change(o,"head",0,900,1,"正比",90) end
if t==(1) then R.change(o,"sonspeed",1,1,0,"正比",1) end
if t==(10) then R.change(o,"alpha",1,0,0,"正比",20) end
end},
{["id"]=33,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=48,["y"]=157,["begin"]=1500,["life"]=300,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=30,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=215,["colorG"]=255,["colorB"]=255,["alpha"]=70,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.1,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(401) then R.change(o,"alpha",20,10,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",1,0,1,"正比",400) end
if t==(1) then R.change(o,"wscale",1,0.5,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"alpha",20,10,0,"正比",400) end
end},
{["id"]=34,["parentid"]=2,["Binding"]=false,["bindid"]=30,["Bindwithspeedd"]=false,["x"]=409,["y"]=677,["begin"]=321,["life"]=2400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=173,["wscale"]=0.5,["hscale"]=0.5,["colorR"]=1,["colorG"]=44,["colorB"]=55,["alpha"]=33,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=true,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/30)*30) then R.change(o,"wscale",0.1,0,1,"无缝正弦",30) end
if t==(1+math.floor(t/30)*30) then R.change(o,"fdirection",40,0,1,"无缝正弦",30) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.3,0,0,"正比",30) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",30) end
end},
{["id"]=0,["parentid"]=3,["x"]=480,["y"]=452,["begin"]=1,["life"]=13000,["halfw"]=1000,["halfh"]=6600,["Circle"]=false,["type"]=1,["controlid"]=9,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5200) then R.change(o,"colorR",155,0,0,"正比",200) end
if t==(5200) then R.change(o,"colorG",100,0,0,"正比",200) end
if t==(5200) then R.change(o,"colorB",80,0,0,"正比",200) end
if t>(5400) then R.change(o,"colorB",80,0,0,"固定",1) end
if t>(5400) then R.change(o,"colorG",100,0,0,"固定",1) end
if t>(5400) then R.change(o,"colorR",155,0,0,"固定",1) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=168,["begin"]=1,["life"]=5000,["fx"]=-99998,["fy"]=-99998,["r"]=300,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=17,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=600,["type"]=145,["wscale"]=0.1,["hscale"]=1,["colorR"]=55,["colorG"]=55,["colorB"]=1,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=90,["tiao"]=0,["t"]=0,["fdirection"]=10,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/13)*13) then R.change(o,"hscale",0.4,0.2,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/56)*56) then R.change(o,"wscale",0.01,0,0,"正弦",55) end
if t==(1) then R.change(o,"head",0,3000,1,"正比",450) end
if t==(100) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,30,1,"正弦",320) end
if t==(1) then R.change(o,"colorG",70,30,0,"正比",1) end
end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=5101,["life"]=7800,["fx"]=-99998,["fy"]=-99998,["r"]=400,["rdirection"]=220,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=13,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=2,["wscale"]=0.3,["hscale"]=0.3,["colorR"]=255,["colorG"]=255,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=90,["tiao"]=0,["t"]=0,["fdirection"]=20,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/7)*7) then R.change(o,"hscale",0.1,0,1,"正弦",6) end
if t==(1+math.floor(t/7)*7) then R.change(o,"wscale",0.1,0,1,"正弦",6) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/10)*10) then R.change(o,"wscale",0,0,0,"正弦",9) end
if t==(1) then R.change(o,"sonspeed",6,2,0,"正比",1) end
if t==(1) then R.change(o,"sonspeedd",0,10,1,"正弦",180) end
if t==(120) then R.change(o,"alpha",1,0,0,"正比",60) end
if t==(1) then R.change(o,"head",0,9000,1,"正比",260) end
end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=296,["begin"]=4600,["life"]=8401,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1500,["type"]=155,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=55,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=90,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(401) then R.change(o,"alpha",10,5,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",2,0,1,"正比",400) end
if t==(1) then R.change(o,"wscale",1,0.5,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",400) end
end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=296,["begin"]=4600,["life"]=8401,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=170,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1500,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=55,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=90,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(401) then R.change(o,"alpha",10,5,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",2,0,1,"正比",400) end
if t==(1) then R.change(o,"wscale",1,0.5,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",400) end
end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=264,["begin"]=1,["life"]=5001,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=120,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1500,["type"]=155,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=90,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(401) then R.change(o,"alpha",10,5,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",1,0,1,"正比",400) end
if t==(1) then R.change(o,"wscale",1,0.5,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",400) end
end},
{["id"]=5,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=264,["begin"]=1,["life"]=5001,["fx"]=-99998,["fy"]=-99998,["r"]=600,["rdirection"]=240,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=140,["fdirection"]=60,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1500,["type"]=156,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=55,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.7,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=90,["tiao"]=0,["t"]=0,["fdirection"]=4,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(401) then R.change(o,"alpha",10,5,0,"正比",200) end
if t==(1) then R.change(o,"sonspeed",1,0,1,"正比",400) end
if t==(1) then R.change(o,"wscale",1,0.5,1,"正比",400) end
if t==(1) then R.change(o,"hscale",0.5,0,1,"正比",400) end
if t==(1) then R.change(o,"alpha",30,10,0,"正比",400) end
end},
{["id"]=6,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=608,["y"]=160,["begin"]=2,["life"]=1,["fx"]=480,["fy"]=1100,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1900,["type"]=164,["wscale"]=-1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=648,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=240,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=260,["type"]=98,["wscale"]=66,["hscale"]=66,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=88,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"colorG",33,0,0,"正比",260) end
if t==(1) then R.change(o,"colorB",44,0,0,"正比",260) end
if t==(1) then R.change(o,"alpha",1,0,0,"正比",260) end
end},
{["id"]=8,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=640,["y"]=160,["begin"]=1502,["life"]=2190,["fx"]=480,["fy"]=0,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2000,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2700,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(2105+math.floor(t/4000)*4000) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(5+math.floor(t/4000)*4000) then R.change(o,"wscale",-1,0,0,"正比",1) end
end,Sonevents=function(o,t,R)

end},
{["id"]=9,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=427,["y"]=604,["begin"]=1,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=98,["wscale"]=66,["hscale"]=66,["colorR"]=1,["colorG"]=55,["colorB"]=55,["alpha"]=8,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(5200) then R.change(o,"colorR",66,0,0,"正比",200) end
if t==(5200) then R.change(o,"colorG",1,0,0,"正比",300) end
if t==(5200) then R.change(o,"colorB",1,0,0,"正比",200) end
if t==(5400) then R.change(o,"alpha",0,0,0,"正比",200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=10,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=288,["y"]=520,["begin"]=5400,["life"]=1,["fx"]=480,["fy"]=420,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=9000,["type"]=165,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",88,0,0,"正比",200) end
end},
{["id"]=11,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=520,["begin"]=1,["life"]=1,["fx"]=480,["fy"]=420,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=5210,["type"]=166,["wscale"]=1,["hscale"]=1.03,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=77,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(5000) then R.change(o,"alpha",0,0,0,"正比",200) end
if t==(1801) then R.change(o,"colorB",77,0,0,"正比",600) end
if t==(1801) then R.change(o,"colorG",77,0,0,"正比",600) end
end},
{["id"]=12,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=320,["y"]=584,["begin"]=1,["life"]=5300,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=167,["wscale"]=7,["hscale"]=7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=66,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"fx","自机",0,0,"正比",1) end
if t>(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t==(5100) then R.change(o,"alpha",0,0,0,"正比",200) end
if t==(800) then R.change(o,"alpha",22,0,0,"正比",200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=13,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=378,["y"]=84,["begin"]=1,["life"]=5100,["fx"]=440,["fy"]=260,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9,["fdirection"]=85,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=4,["wscale"]=0.1,["hscale"]=2,["colorR"]=1,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=17,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=4,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/500)*500) then R.change(o,"fdirection",3,0,1,"正弦",499) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",20,5,0,"正比",10) end
if t==(20) then R.change(o,"alpha",0,0,0,"正比",10) end
if t==(1) then R.change(o,"wscale",0,0,0,"正比",30) end
if t==(1) then R.change(o,"hscale",0.2,0,0,"正比",30) end
end},
{["id"]=14,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=410,["y"]=84,["begin"]=1,["life"]=5100,["fx"]=440,["fy"]=260,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=6,["fdirection"]=85,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=33,["type"]=4,["wscale"]=0.1,["hscale"]=2,["colorR"]=1,["colorG"]=155,["colorB"]=187,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=16,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=3,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/500)*500) then R.change(o,"fdirection",3,0,1,"正弦",499) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",50,10,0,"正比",10) end
if t==(40) then R.change(o,"alpha",0,0,0,"正比",10) end
if t==(1) then R.change(o,"hscale",0.2,0,0,"正比",50) end
end},
{["id"]=15,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=378,["y"]=116,["begin"]=5100,["life"]=5100,["fx"]=440,["fy"]=260,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=8,["fdirection"]=85,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=4,["wscale"]=0.2,["hscale"]=2,["colorR"]=255,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=13,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=360,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=4,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["instantMovement"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/500)*500) then R.change(o,"fdirection",3,0,1,"正弦",499) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",60,20,0,"正比",10) end
if t==(20) then R.change(o,"alpha",0,0,0,"正比",10) end
if t==(1) then R.change(o,"hscale",0.2,0,0,"正比",30) end
end}
}}
