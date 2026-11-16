return {["id"]="39",["total"]=62000,["order"]=0,["centerAvailable"]=false,["center"]={481,360,0,0,0,0},["types"]={{0,0,100,100,50,10,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,100,100,200,50,100,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,400,200,600,40,300,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{100,0,100,400,40,400,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{200,0,200,600,80,540,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{400,0,100,900,50,880,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{500,0,100,900,50,880,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{600,0,100,900,50,900,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{700,0,300,1300,180,1250,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{200,600,100,200,50,150,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{300,600,100,200,50,200,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{200,800,100,200,50,150,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,1000,300,100,300,50,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,1100,300,200,300,100,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{300,1000,300,100,300,50,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{300,1100,300,200,300,100,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,0,20,13,10,6,0,0,1,0,0,0,0,0,0,"scene/3-2zhuye"},{0,0,637,723,318,723,0,0,1,0,0,0,0,0,0,"scene/3-1BG1"},{0,0,2000,2000,1000,1100,0,0,1,0,0,0,0,0,0,"scene/guangdetouying"},{0,0,300,198,150,0,0,0,1,0,0,0,0,0,0,"scene/yuanchu"},{0,0,625,414,0,0,0,0,1,0,0,0,0,0,0,"scene/3-3L1"},{0,0,475,431,0,0,0,0,1,0,0,0,0,0,0,"scene/3-3L2"},{0,0,555,760,0,0,0,0,1,0,0,0,0,0,0,"scene/3-3L3"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=488,["begin"]=1,["life"]=62000,["fx"]=120,["fy"]=-30,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=500,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2400,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=133,["colorG"]=133,["colorB"]=155,["alpha"]=100,["head"]=275,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=4,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1500)*1500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(501+math.floor(t/1500)*1500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1001+math.floor(t/1500)*1500) then R.change(o,"type",2,0,2,"正比",1) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0.3,0,"正比",1) end
if t==(1+math.floor(t/800)*800) then R.change(o,"head",2,0,1,"无缝正弦",800) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=736,["y"]=488,["begin"]=251,["life"]=61750,["fx"]=840,["fy"]=-30,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=500,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2400,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=133,["colorG"]=133,["colorB"]=155,["alpha"]=100,["head"]=265,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=4,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1500)*1500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(501+math.floor(t/1500)*1500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1001+math.floor(t/1500)*1500) then R.change(o,"type",2,0,2,"正比",1) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0.3,0,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"head",2,0,1,"无缝正弦",600) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=224,["y"]=456,["begin"]=751,["life"]=61250,["fx"]=130,["fy"]=-30,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=500,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2400,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=133,["colorG"]=133,["colorB"]=155,["alpha"]=100,["head"]=278,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=4,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1500)*1500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(501+math.floor(t/1500)*1500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1001+math.floor(t/1500)*1500) then R.change(o,"type",2,0,2,"正比",1) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0.3,0,"正比",1) end
if t==(1+math.floor(t/800)*800) then R.change(o,"head",2,0,2,"无缝正弦",800) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=736,["y"]=456,["begin"]=951,["life"]=61050,["fx"]=830,["fy"]=-30,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=500,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2400,["type"]=157,["wscale"]=1,["hscale"]=1,["colorR"]=133,["colorG"]=133,["colorB"]=155,["alpha"]=100,["head"]=262,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=4,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/1500)*1500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(501+math.floor(t/1500)*1500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(1001+math.floor(t/1500)*1500) then R.change(o,"type",2,0,2,"正比",1) end
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0.3,0,"正比",1) end
if t==(1+math.floor(t/600)*600) then R.change(o,"head",2,0,2,"无缝正弦",600) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=168,["begin"]=61,["life"]=61880,["fx"]=-99998,["fy"]=-110,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=70,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=172,["wscale"]=1.05,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=30,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(600) then R.change(o,"t",220,0,0,"正比",1) end
if t==(300) then R.change(o,"t",100,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100,0,0,"正比",120) end
if t==(121) then R.change(o,"alpha",0,0,0,"正比",120) end
end},
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=200,["begin"]=61,["life"]=61880,["fx"]=-99998,["fy"]=-80,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=80,["fdirection"]=120,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=173,["wscale"]=1.05,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0.5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=10,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(300) then R.change(o,"t",100,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",100,0,0,"正比",120) end
if t==(121) then R.change(o,"alpha",0,0,0,"正比",120) end
end},
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=160,["y"]=264,["begin"]=121,["life"]=61820,["fx"]=160,["fy"]=-90,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=60,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=174,["wscale"]=0.7,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0.2,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(700) then R.change(o,"t",233,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"alpha",40,0,0,"正比",120) end
if t==(121) then R.change(o,"alpha",0,0,0,"正比",120) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=72,["begin"]=11,["life"]=61990,["fx"]=-99998,["fy"]=-100,["r"]=460,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1000,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=66,["colorG"]=66,["colorB"]=77,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1+math.floor(t/100)*100) then R.change(o,"wscale",-1,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"rdirection",180,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"rdirection",0,0,0,"正比",1) end
if t==(1+math.floor(t/500)*500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(100+math.floor(t/500)*500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(200+math.floor(t/500)*500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(300+math.floor(t/500)*500) then R.change(o,"type",2,0,2,"正比",1) end
if t==(400+math.floor(t/500)*500) then R.change(o,"type",1,0,2,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/242)*242) then R.change(o,"wscale",0.005,0,1,"正弦",120) end
if t==(121+math.floor(t/242)*242) then R.change(o,"wscale",0.01,0,1,"正弦",120) end
if t==(1+math.floor(t/242)*242) then R.change(o,"head",1,0,1,"正弦",240) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=104,["begin"]=71,["life"]=61930,["fx"]=480,["fy"]=-100,["r"]=440,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1000,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=66,["colorG"]=66,["colorB"]=77,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1+math.floor(t/300)*300) then R.change(o,"wscale",-1,0,0,"正比",1) end
if t==(151+math.floor(t/300)*300) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(1+math.floor(t/300)*300) then R.change(o,"rdirection",180,0,0,"正比",1) end
if t==(151+math.floor(t/300)*300) then R.change(o,"rdirection",0,0,0,"正比",1) end
if t==(1+math.floor(t/750)*750) then R.change(o,"type",1,0,1,"正比",1) end
if t==(150+math.floor(t/750)*750) then R.change(o,"type",1,0,1,"正比",1) end
if t==(300+math.floor(t/750)*750) then R.change(o,"type",1,0,1,"正比",1) end
if t==(450+math.floor(t/750)*750) then R.change(o,"type",2,0,2,"正比",1) end
if t==(600+math.floor(t/750)*750) then R.change(o,"type",1,0,2,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/242)*242) then R.change(o,"wscale",0.005,0,1,"正弦",120) end
if t==(121+math.floor(t/242)*242) then R.change(o,"wscale",0.01,0,1,"正弦",120) end
if t==(1+math.floor(t/242)*242) then R.change(o,"head",1,0,1,"正弦",240) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=136,["begin"]=31,["life"]=61970,["fx"]=480,["fy"]=-100,["r"]=370,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1000,["type"]=165,["wscale"]=1,["hscale"]=1,["colorR"]=88,["colorG"]=88,["colorB"]=99,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1+math.floor(t/300)*300) then R.change(o,"wscale",-1,0,0,"正比",1) end
if t==(151+math.floor(t/300)*300) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(1+math.floor(t/300)*300) then R.change(o,"rdirection",180,0,0,"正比",1) end
if t==(151+math.floor(t/300)*300) then R.change(o,"rdirection",0,0,0,"正比",1) end
if t==(1+math.floor(t/750)*750) then R.change(o,"type",1,0,1,"正比",1) end
if t==(150+math.floor(t/750)*750) then R.change(o,"type",1,0,1,"正比",1) end
if t==(300+math.floor(t/750)*750) then R.change(o,"type",2,0,2,"正比",1) end
if t==(450+math.floor(t/750)*750) then R.change(o,"type",1,0,2,"正比",1) end
if t==(600+math.floor(t/750)*750) then R.change(o,"type",1,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/242)*242) then R.change(o,"wscale",0.005,0,1,"正弦",120) end
if t==(121+math.floor(t/242)*242) then R.change(o,"wscale",0.01,0,1,"正弦",120) end
if t==(1+math.floor(t/242)*242) then R.change(o,"head",2,0,1,"正弦",240) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=40,["begin"]=121,["life"]=61880,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=168,["wscale"]=1,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=450,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/90)*90) then R.change(o,"hscale",0.9,0,0,"正弦",89) end
if t==(1+math.floor(t/90)*90) then R.change(o,"wscale",1.6,0,0,"正弦",89) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",2000,1000,1,"正比",400) end
if t==(1) then R.change(o,"sonspeedd",65,10,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",0,30,1,"正弦",400) end
if t==(80) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",4,2,0,"正比",1) end
if t==(1) then R.change(o,"colorR",200,88,0,"正比",1) end
if t==(1) then R.change(o,"colorB",200,88,0,"正比",1) end
if t==(1) then R.change(o,"colorG",200,88,0,"正比",1) end
if (o.fx or 0)>(750) then R.change(o,"life",0,0,0,"正比",1) end
if (o.fy or 0)>(750) then R.change(o,"life",0,0,0,"正比",1) end
if t==(1+math.floor(t/20)*20) then R.change(o,"hscale",0.1,0,0,"正弦",19) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=40,["begin"]=111,["life"]=61890,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=9,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=168,["wscale"]=1,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=450,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/90)*90) then R.change(o,"hscale",0.9,0,0,"正弦",89) end
if t==(1+math.floor(t/90)*90) then R.change(o,"wscale",1.6,0,0,"正弦",89) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",2000,1000,2,"正比",400) end
if t==(1) then R.change(o,"sonspeedd",65,10,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",0,30,1,"正弦",400) end
if t==(80) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",4,2,0,"正比",1) end
if t==(1) then R.change(o,"colorR",200,88,0,"正比",1) end
if t==(1) then R.change(o,"colorB",200,88,0,"正比",1) end
if t==(1) then R.change(o,"colorG",200,88,0,"正比",1) end
if (o.fx or 0)>(750) then R.change(o,"life",0,0,0,"正比",1) end
if (o.fy or 0)>(750) then R.change(o,"life",0,0,0,"正比",1) end
if t==(1+math.floor(t/12)*12) then R.change(o,"hscale",0.1,0,0,"正弦",11) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=168,["begin"]=361,["life"]=61340,["fx"]=480,["fy"]=-200,["r"]=420,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1300,["type"]=165,["wscale"]=1,["hscale"]=1,["colorR"]=99,["colorG"]=99,["colorB"]=111,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1+math.floor(t/300)*300) then R.change(o,"wscale",-1,0,0,"正比",1) end
if t==(151+math.floor(t/300)*300) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(1+math.floor(t/300)*300) then R.change(o,"rdirection",180,0,0,"正比",1) end
if t==(151+math.floor(t/300)*300) then R.change(o,"rdirection",0,0,0,"正比",1) end
if t==(1+math.floor(t/750)*750) then R.change(o,"type",1,0,1,"正比",1) end
if t==(150+math.floor(t/750)*750) then R.change(o,"type",1,0,1,"正比",1) end
if t==(300+math.floor(t/750)*750) then R.change(o,"type",2,0,2,"正比",1) end
if t==(450+math.floor(t/750)*750) then R.change(o,"type",1,0,2,"正比",1) end
if t==(600+math.floor(t/750)*750) then R.change(o,"type",1,0,1,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/242)*242) then R.change(o,"wscale",0.005,0,1,"正弦",120) end
if t==(121+math.floor(t/242)*242) then R.change(o,"wscale",0.01,0,1,"正弦",120) end
if t==(1+math.floor(t/242)*242) then R.change(o,"head",2,0,1,"正弦",240) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=200,["begin"]=211,["life"]=61690,["fx"]=-99998,["fy"]=-100,["r"]=510,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1000,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=88,["colorG"]=88,["colorB"]=88,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.3,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1+math.floor(t/100)*100) then R.change(o,"wscale",-1,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(1+math.floor(t/100)*100) then R.change(o,"rdirection",180,0,0,"正比",1) end
if t==(51+math.floor(t/100)*100) then R.change(o,"rdirection",0,0,0,"正比",1) end
if t==(1+math.floor(t/500)*500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(100+math.floor(t/500)*500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(200+math.floor(t/500)*500) then R.change(o,"type",1,0,1,"正比",1) end
if t==(300+math.floor(t/500)*500) then R.change(o,"type",2,0,2,"正比",1) end
if t==(400+math.floor(t/500)*500) then R.change(o,"type",1,0,2,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/242)*242) then R.change(o,"wscale",0.005,0,1,"正弦",120) end
if t==(121+math.floor(t/242)*242) then R.change(o,"wscale",0.01,0,1,"正弦",120) end
if t==(1+math.floor(t/242)*242) then R.change(o,"head",1,0,1,"正弦",240) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=296,["begin"]=61,["life"]=6000,["fx"]=480,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1,["type"]=171,["wscale"]=2.2,["hscale"]=2.5,["colorR"]=115,["colorG"]=125,["colorB"]=66,["alpha"]=0,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=0,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/350)*350) then R.change(o,"hscale",0.1,0,1,"正弦",349) end
if t==(1) then R.change(o,"alpha",70,0,0,"正比",120) end
end,Sonevents=function(o,t,R)

end}
}}
