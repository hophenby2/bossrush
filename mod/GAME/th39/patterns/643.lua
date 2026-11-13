return {["id"]="643",["total"]=1100,["order"]=1,["centerAvailable"]=true,["center"]={384,168,0,0,0,0},["types"]={{0,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{110,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{220,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{330,0,110,230,55,115,0,0,1,0,0,0,0,0,0,"6boss-1"},{0,230,440,300,220,160,0,0,1,0,0,0,0,0,0,"6boss-1"},{0,530,150,100,75,50,0,0,1,0,60,20,30,60,80,"6boss-1"},{150,530,100,100,50,50,0,0,1,0,0,0,0,0,0,"6boss-1"},{0,0,160,250,80,125,0,0,6,5,0,0,0,0,0,"6boss-2"},{0,1250,160,250,80,125,0,0,1,0,0,0,0,0,0,"6boss-2"},{0,0,160,250,80,125,0,0,1,0,0,0,0,0,0,"6boss-2"},{0,0,150,200,75,100,0,0,1,0,30,50,70,100,80,"6boss-cang"},{0,0,150,200,75,100,0,0,7,5,0,0,0,0,0,"6boss-cang"},{0,1200,150,200,75,100,0,0,1,0,30,50,70,100,80,"6boss-cang"},{0,0,50,100,25,50,0,0,1,0,0,0,0,0,0,"6boss-banzi"},{0,0,50,100,25,50,0,0,10,5,0,0,0,0,0,"6boss-banzi"},{0,900,50,100,25,50,0,0,1,0,0,0,0,0,0,"6boss-banzi"}},centerEvents=function(o,t,R)
if t==(1) then R.move(o,false,384,384,168,168) end
if t==(61) then R.move(o,false,384,384,168,168) end
if t==(30) then R.sound("stage6energy") end
if t==(300) then R.sound("stage6lazerloop") end
if t==(540) then R.sound("stage6energy") end
if t==(900) then R.sound("stage6lazerloop") end
end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["x"]=576,["y"]=520,["begin"]=1,["life"]=1100,["halfw"]=220,["halfh"]=220,["Circle"]=true,["type"]=1,["controlid"]=2,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=0,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)
if t==(700) then R.change(o,"halfw",1200,0,0,"正比",480) end
if t==(700) then R.change(o,"halfh",1200,0,0,"正比",480) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"life",0,0,0,"固定",1) end
end},
{["id"]=1,["parentid"]=0,["x"]=640,["y"]=488,["begin"]=1,["life"]=500,["halfw"]=220,["halfh"]=220,["Circle"]=true,["type"]=1,["controlid"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=2,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)
if t==(150) then R.change(o,"halfw",1200,0,0,"正比",480) end
if t==(150) then R.change(o,"halfh",1200,0,0,"正比",480) end
end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"life",0,0,0,"固定",1) end
end},
{["id"]=2,["parentid"]=0,["x"]=672,["y"]=488,["begin"]=700,["life"]=401,["halfw"]=220,["halfh"]=220,["Circle"]=true,["type"]=1,["controlid"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=2,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"life",0,0,0,"固定",1) end
end},
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=456,["begin"]=1,["life"]=4,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=850,["type"]=93,["wscale"]=12,["hscale"]=12,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fx","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t==(2) then R.change(o,"fy",390,0,0,"正比",7) end
if t==(2) then R.change(o,"fx",480,0,0,"正比",7) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",30,0,2,"正比",120) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=480,["y"]=104,["begin"]=210,["life"]=550,["fx"]=-99998,["fy"]=-99998,["r"]=800,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=57,["wscale"]=1,["hscale"]=1,["colorR"]=160,["colorG"]=255,["colorB"]=160,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",0.2,0,1,"正比",60) end
if t==(1+math.floor(t/60)*60) then R.change(o,"rdirection",240,0,2,"正比",60) end
if t==(1+math.floor(t/60)*60) then R.change(o,"fdirection",240,0,2,"正比",60) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,1,"无缝正弦",20) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.2,0,1,"无缝正弦",20) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"head",130,0,1,"正比",20) end
if t==(11+math.floor(t/45)*45) then R.change(o,"colorR",255,0,0,"无缝正弦",45) end
if t==(916+math.floor(t/45)*45) then R.change(o,"colorG",255,0,0,"无缝正弦",45) end
if t==(11+math.floor(t/45)*45) then R.change(o,"colorB",255,0,0,"无缝正弦",45) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=456,["begin"]=551,["life"]=4,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=850,["type"]=93,["wscale"]=12,["hscale"]=12,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fx","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t==(2) then R.change(o,"fy",390,0,0,"正比",7) end
if t==(2) then R.change(o,"fx",480,0,0,"正比",7) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",30,0,2,"正比",120) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=544,["y"]=104,["begin"]=210,["life"]=550,["fx"]=-99998,["fy"]=-99998,["r"]=800,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=2,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=200,["type"]=57,["wscale"]=1,["hscale"]=1,["colorR"]=160,["colorG"]=255,["colorB"]=160,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/60)*60) then R.change(o,"sonspeed",0.5,0,1,"正比",60) end
if t==(1+math.floor(t/60)*60) then R.change(o,"rdirection",240,0,1,"正比",60) end
if t==(1+math.floor(t/60)*60) then R.change(o,"fdirection",240,0,1,"正比",60) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.2,0,1,"无缝正弦",20) end
if t==(1+math.floor(t/20)*20) then R.change(o,"wscale",0.2,0,1,"无缝正弦",20) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/20)*20) then R.change(o,"head",130,0,2,"正比",20) end
if t==(21+math.floor(t/45)*45) then R.change(o,"colorR",255,0,0,"无缝正弦",45) end
if t==(21+math.floor(t/45)*45) then R.change(o,"colorB",255,0,0,"无缝正弦",45) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=256,["y"]=488,["begin"]=1,["life"]=1100,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=240,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=4,["wscale"]=0.1,["longs"]=100,["alpha"]=100,["Ray"]="Ray",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=false,["Invincible"]=false,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=false,["colorR"]=125,["colorG"]=255,["colorB"]=125,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)
if t==(330) then R.change(o,"wscale",1,0,0,"正比",30) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"alpha",0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=320,["y"]=328,["begin"]=1,["life"]=300,["fx"]=-99998,["fy"]=-99998,["r"]=800,["rdirection"]=22,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=292,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=162,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360,0,1,"正弦",1200) end
if t==(1) then R.change(o,"r",200,0,0,"正弦",1200) end
if t==(1) then R.change(o,"rdirection",360,0,1,"正弦",1200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=320,["y"]=360,["begin"]=300,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=22,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=292,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=163,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(40) then R.change(o,"type",1,0,1,"正比",1) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=352,["y"]=328,["begin"]=1,["life"]=300,["fx"]=-99998,["fy"]=-99998,["r"]=800,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360,0,1,"正弦",1200) end
if t==(1) then R.change(o,"r",200,0,0,"正弦",1200) end
if t==(1) then R.change(o,"rdirection",360,0,1,"正弦",1200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=352,["y"]=360,["begin"]=300,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=1,["life"]=4,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=900,["type"]=94,["wscale"]=12,["hscale"]=12,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fx","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t==(2) then R.change(o,"fy",390,0,0,"正比",7) end
if t==(2) then R.change(o,"fx",480,0,0,"正比",7) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",30,0,2,"正比",120) end
if t==(1) then R.change(o,"alpha",12,0,0,"正比",400) end
if t==(500) then R.change(o,"alpha",0,0,0,"正比",200) end
end},
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=320,["y"]=392,["begin"]=360,["life"]=741,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=22,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=292,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=164,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"rdirection",6,0,1,"正比",600) end
if t>(1) then R.change(o,"fdirection",6,0,1,"正比",600) end
if t>(300) then R.change(o,"r",5,0,1,"正比",300) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=352,["y"]=392,["begin"]=360,["life"]=741,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"rdirection",6,0,1,"正比",600) end
if t>(1) then R.change(o,"fdirection",6,0,1,"正比",600) end
if t>(300) then R.change(o,"r",5,0,1,"正比",300) end
end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=254,["y"]=392,["begin"]=360,["life"]=441,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=22,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=292,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=111,["colorG"]=255,["colorB"]=33,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"rdirection",6,0,1,"正比",600) end
if t>(1) then R.change(o,"fdirection",6,0,2,"正比",600) end
if t>(300) then R.change(o,"r",5,0,1,"正比",300) end
if t==(1) then R.change(o,"alpha",80,0,0,"正比",15) end
if t==(1+math.floor(t/10)*10) then R.change(o,"wscale",0.1,0,1,"无缝正弦",10) end
if t==(1+math.floor(t/10)*10) then R.change(o,"hscale",0.1,0,1,"无缝正弦",10) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=1,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=286,["y"]=392,["begin"]=296,["life"]=801,["fx"]=-99998,["fy"]=-99998,["r"]=210,["rdirection"]=22,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=22,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=91,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(61) then R.change(o,"rdirection",6,0,1,"正比",600) end
if t>(61) then R.change(o,"fdirection",6,0,1,"正比",600) end
if t>(360) then R.change(o,"r",5,0,1,"正比",300) end
if t==(1) then R.change(o,"alpha",13,0,0,"正比",60) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=320,["y"]=488,["begin"]=1,["life"]=1100,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=4,["wscale"]=1,["longs"]=100,["alpha"]=100,["Ray"]="Ray",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=false,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=false,["colorR"]=125,["colorG"]=255,["colorB"]=125,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)
if t==(880) then R.change(o,"wscale",1,0,0,"正比",30) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=352,["y"]=488,["begin"]=1,["life"]=400,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=4,["wscale"]=1,["longs"]=100,["alpha"]=100,["Ray"]="Ray",["sonspeed"]=0.01,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Blend"]=true,["Outdispel"]=true,["Invincible"]=false,["segment"]=64,["rand"]={["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Deepbind"]=false,["colorR"]=125,["colorG"]=255,["colorB"]=125,["head"]=0,["kind"]="laser",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=320,["y"]=168,["begin"]=551,["life"]=300,["fx"]=-99998,["fy"]=-99998,["r"]=800,["rdirection"]=22,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=292,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=162,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360,0,2,"正弦",1200) end
if t==(1) then R.change(o,"r",200,0,0,"正弦",1200) end
if t==(1) then R.change(o,"rdirection",360,0,2,"正弦",1200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=320,["y"]=200,["begin"]=850,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=22,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=292,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=60,["type"]=163,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(40) then R.change(o,"type",1,0,1,"正比",1) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=352,["y"]=168,["begin"]=551,["life"]=300,["fx"]=-99998,["fy"]=-99998,["r"]=800,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",360,0,2,"正弦",1200) end
if t==(1) then R.change(o,"r",200,0,0,"正弦",1200) end
if t==(1) then R.change(o,"rdirection",360,0,2,"正弦",1200) end
end,Sonevents=function(o,t,R)

end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=352,["y"]=200,["begin"]=850,["life"]=60,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)

end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=360,["begin"]=551,["life"]=4,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=900,["type"]=94,["wscale"]=12,["hscale"]=12,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fx","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t==(2) then R.change(o,"fy",390,0,0,"正比",7) end
if t==(2) then R.change(o,"fx",480,0,0,"正比",7) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",30,0,1,"正比",120) end
if t==(1) then R.change(o,"alpha",12,0,0,"正比",400) end
if t==(500) then R.change(o,"alpha",0,0,0,"正比",200) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=320,["y"]=232,["begin"]=356,["life"]=745,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=22,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=292,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=164,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"rdirection",6,0,2,"正比",600) end
if t>(1) then R.change(o,"fdirection",6,0,2,"正比",600) end
if t>(300) then R.change(o,"r",5,0,1,"正比",300) end
end,Sonevents=function(o,t,R)

end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=352,["y"]=232,["begin"]=356,["life"]=745,["fx"]=-99998,["fy"]=-99998,["r"]=200,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=180,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=157,["wscale"]=0.8,["hscale"]=0.8,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"rdirection",6,0,2,"正比",600) end
if t>(1) then R.change(o,"fdirection",6,0,2,"正比",600) end
if t>(300) then R.change(o,"r",5,0,1,"正比",300) end
end,Sonevents=function(o,t,R)

end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=256,["y"]=232,["begin"]=356,["life"]=745,["fx"]=-99998,["fy"]=-99998,["r"]=190,["rdirection"]=22,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=292,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=111,["colorG"]=255,["colorB"]=33,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(1) then R.change(o,"rdirection",6,0,2,"正比",600) end
if t>(1) then R.change(o,"fdirection",6,0,1,"正比",600) end
if t>(300) then R.change(o,"r",5,0,1,"正比",300) end
if t==(1) then R.change(o,"alpha",80,0,0,"正比",15) end
if t==(1+math.floor(t/10)*10) then R.change(o,"wscale",0.1,0,1,"无缝正弦",10) end
if t==(1+math.floor(t/10)*10) then R.change(o,"hscale",0.1,0,1,"无缝正弦",10) end
end,Sonevents=function(o,t,R)

end},
{["id"]=8,["parentid"]=2,["Binding"]=false,["bindid"]=4,["Bindwithspeedd"]=false,["x"]=288,["y"]=232,["begin"]=296,["life"]=745,["fx"]=-99998,["fy"]=-99998,["r"]=210,["rdirection"]=22,["rdirections"]={0.0,0.0},["tiao"]=8,["t"]=1,["fdirection"]=22,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=91,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t>(61) then R.change(o,"rdirection",6,0,2,"正比",600) end
if t>(61) then R.change(o,"fdirection",6,0,2,"正比",600) end
if t>(360) then R.change(o,"r",5,0,1,"正比",300) end
if t==(1) then R.change(o,"alpha",13,0,0,"正比",60) end
end,Sonevents=function(o,t,R)

end},
{["id"]=0,["parentid"]=3,["x"]=608,["y"]=264,["begin"]=1,["life"]=800,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=3,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(700) then R.change(o,"sonspeed",2.5,0,1,"正比",500) end
if t==(400) then R.change(o,"alpha",30,0,0,"正比",1) end
end},
{["id"]=1,["parentid"]=3,["x"]=576,["y"]=424,["begin"]=300,["life"]=801,["halfw"]=20,["halfh"]=20,["Circle"]=true,["type"]=1,["controlid"]=4,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=4,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if (o.maskEntered or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=2,["parentid"]=3,["x"]=608,["y"]=296,["begin"]=1,["life"]=800,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=5,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(350) then R.change(o,"alpha",100,0,0,"正比",1) end
if t>(700) then R.change(o,"sonspeed",2.5,0,1,"正比",500) end
end},
{["id"]=3,["parentid"]=3,["x"]=640,["y"]=424,["begin"]=850,["life"]=251,["halfw"]=20,["halfh"]=20,["Circle"]=true,["type"]=1,["controlid"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=6,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if (o.maskEntered or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=3,["x"]=640,["y"]=264,["begin"]=1,["life"]=800,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=6,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(150) and t<(550) then R.change(o,"sonspeed",2.5,0,1,"正比",500) end
if t==(950) then R.change(o,"alpha",30,0,0,"正比",1) end
end},
{["id"]=5,["parentid"]=3,["x"]=640,["y"]=296,["begin"]=1,["life"]=800,["halfw"]=1100,["halfh"]=1100,["Circle"]=false,["type"]=1,["controlid"]=7,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=-1,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(150) and t<(550) then R.change(o,"sonspeed",2.5,0,1,"正比",500) end
if t==(950) then R.change(o,"alpha",100,0,0,"正比",1) end
end},
{["id"]=6,["parentid"]=3,["x"]=672,["y"]=424,["begin"]=1,["life"]=350,["halfw"]=20,["halfh"]=20,["Circle"]=true,["type"]=1,["controlid"]=10,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["rand"]={["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0},["bindid"]=6,["Deepbind"]=false,["maskOn"]=false,["maskType"]=0,["maskMutex"]=false,["degree"]=0,["kind"]="cover",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if (o.maskEntered or 0)==(1) then R.change(o,"life",0,0,0,"正比",1) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=392,["begin"]=1,["life"]=4,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=900,["type"]=93,["wscale"]=12,["hscale"]=12,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fx","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t==(2) then R.change(o,"fy",390,0,0,"正比",7) end
if t==(2) then R.change(o,"fx",480,0,0,"正比",7) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",30,0,2,"正比",120) end
end},
{["id"]=1,["parentid"]=3,["Binding"]=false,["bindid"]=2,["Bindwithspeedd"]=false,["x"]=448,["y"]=520,["begin"]=350,["life"]=400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=80,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=18,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=255,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(340) then R.change(o,"t",20,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.1,0,0,"正比",3) end
end},
{["id"]=2,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=480,["y"]=264,["begin"]=5,["life"]=40,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1390,["type"]=147,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=77,["colorG"]=255,["colorB"]=125,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",270,30,0,"正比",1) end
if t==(2) then R.change(o,"fdirection",120,0,2,"正比",40) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeedd",18000,0,1,"正比",3000) end
if t==(2) then R.change(o,"sonspeed",22,0,0,"正比",300) end
if t==(905) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=3,["parentid"]=3,["Binding"]=false,["bindid"]=1,["Bindwithspeedd"]=true,["x"]=448,["y"]=584,["begin"]=16,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=8,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=69,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,0,2,"正比",9) end
end,Sonevents=function(o,t,R)
if t==(300) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=4,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=480,["y"]=296,["begin"]=5,["life"]=40,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1390,["type"]=90,["wscale"]=1,["hscale"]=1,["colorR"]=12,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",0,360,0,"正比",1) end
if t==(2) then R.change(o,"fdirection",120,0,2,"正比",40) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeedd",18000,0,1,"正比",3000) end
if t==(2) then R.change(o,"sonspeed",22,0,0,"正比",300) end
if t==(905) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=5,["parentid"]=3,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=512,["y"]=264,["begin"]=555,["life"]=40,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1390,["type"]=147,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=77,["colorG"]=255,["colorB"]=125,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",270,30,0,"正比",1) end
if t==(2) then R.change(o,"fdirection",120,0,1,"正比",40) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeedd",18000,0,2,"正比",3000) end
if t==(2) then R.change(o,"sonspeed",22,0,0,"正比",300) end
if t==(905) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=6,["parentid"]=3,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=512,["y"]=296,["begin"]=555,["life"]=40,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1390,["type"]=90,["wscale"]=1,["hscale"]=1,["colorR"]=12,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=0.0001,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fdirection",0,360,0,"正比",1) end
if t==(2) then R.change(o,"fdirection",120,0,1,"正比",40) end
end,Sonevents=function(o,t,R)
if t==(2) then R.change(o,"sonspeedd",18000,0,2,"正比",3000) end
if t==(2) then R.change(o,"sonspeed",22,0,0,"正比",300) end
if t==(905) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=7,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=392,["begin"]=551,["life"]=4,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=900,["type"]=93,["wscale"]=12,["hscale"]=12,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=0,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"fx","自机",0,0,"正比",1) end
if t==(1) then R.change(o,"fy","自机",0,0,"正比",1) end
if t==(2) then R.change(o,"fy",390,0,0,"正比",7) end
if t==(2) then R.change(o,"fx",480,0,0,"正比",7) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/120)*120) then R.change(o,"head",30,0,2,"正比",120) end
end},
{["id"]=8,["parentid"]=3,["Binding"]=false,["bindid"]=5,["Bindwithspeedd"]=false,["x"]=480,["y"]=520,["begin"]=350,["life"]=400,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=80,["fdirection"]=-99999,["fdirections"]={0.0,0.0},["range"]=120,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=18,["type"]=147,["wscale"]=1,["hscale"]=1,["colorR"]=1,["colorG"]=255,["colorB"]=1,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=9,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=true,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(340) then R.change(o,"t",20,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(5) then R.change(o,"sonspeed",0.1,0,0,"正比",3) end
end},
{["id"]=9,["parentid"]=3,["Binding"]=false,["bindid"]=8,["Bindwithspeedd"]=true,["x"]=480,["y"]=584,["begin"]=16,["life"]=5,["fx"]=-99998,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=8,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=69,["wscale"]=0.7,["hscale"]=0.7,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=3.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=true,["Dispel"]=true,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=true,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeed",2,0,2,"正比",9) end
end,Sonevents=function(o,t,R)
if t==(300) then R.change(o,"Outdispel",1,0,0,"正比",1) end
end},
{["id"]=10,["parentid"]=3,["Binding"]=false,["bindid"]=0,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=5,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=800,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=24,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1390,["type"]=148,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=77,["colorG"]=255,["colorB"]=125,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(605) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.0001,0,0,"正比",300) end
if t==(661) then R.change(o,"sonspeed",4.2,0,0,"正比",240) end
end},
{["id"]=11,["parentid"]=3,["Binding"]=false,["bindid"]=7,["Bindwithspeedd"]=false,["x"]=512,["y"]=200,["begin"]=555,["life"]=1,["fx"]=-99998,["fy"]=-99998,["r"]=800,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=24,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1390,["type"]=148,["wscale"]=0.6,["hscale"]=0.6,["colorR"]=77,["colorG"]=255,["colorB"]=125,["alpha"]=1,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=true,["sonspeed"]=-4,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0,["wscale"]=0,["hscale"]=0},["Cover"]=true,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["syncScale"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(605) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",0.0001,0,0,"正比",300) end
if t==(661) then R.change(o,"sonspeed",4.2,0,0,"正比",240) end
end}
}}
