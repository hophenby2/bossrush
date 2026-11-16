return {["id"]="36",["total"]=6200,["order"]=1,["centerAvailable"]=false,["center"]={481,360,0,0,0,0},["types"]={{0,0,100,100,50,10,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,100,100,200,50,100,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,400,200,600,40,300,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{100,0,100,400,40,400,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{200,0,200,600,80,540,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{400,0,100,900,50,880,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{500,0,100,900,50,880,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{600,0,100,900,50,900,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{700,0,300,1300,180,1250,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{200,600,100,200,50,150,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{300,600,100,200,50,200,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{200,800,100,200,50,150,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,1000,300,100,300,50,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,1100,300,200,300,100,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{300,1000,300,100,300,50,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{300,1100,300,200,300,100,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,0,20,13,10,6,0,0,1,0,0,0,0,0,0,"scene/3-2zhuye"},{0,0,637,723,318,723,0,0,1,0,0,0,0,0,0,"scene/3-1BG1"},{0,0,2000,2000,1000,1100,0,0,1,0,0,0,0,0,0,"scene/guangdetouying"},{0,0,300,198,150,0,0,0,1,0,0,0,0,0,0,"scene/yuanchu"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=456,["begin"]=121,["life"]=30,["fx"]=480,["fy"]=900,["r"]=450,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=31,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=5,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1+math.floor(t/4)*4) then R.change(o,"wscale",-1,0,0,"正比",1) end
if t==(3+math.floor(t/4)*4) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(1+math.floor(t/4)*4) then R.change(o,"rdirection",180,0,0,"正比",1) end
if t==(3+math.floor(t/4)*4) then R.change(o,"rdirection",0,0,0,"正比",1) end
if t==(1+math.floor(t/5)*5) then R.change(o,"type",1,0,1,"正比",1) end
if t==(2+math.floor(t/5)*5) then R.change(o,"type",1,0,1,"正比",1) end
if t==(3+math.floor(t/5)*5) then R.change(o,"type",1,0,1,"正比",1) end
if t==(4+math.floor(t/5)*5) then R.change(o,"type",3,0,2,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/242)*242) then R.change(o,"wscale",0.005,0,1,"正弦",120) end
if t==(121+math.floor(t/242)*242) then R.change(o,"wscale",0.01,0,1,"正弦",120) end
if t==(1+math.floor(t/242)*242) then R.change(o,"head",2,0,1,"正弦",240) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=40,["begin"]=121,["life"]=6080,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=168,["wscale"]=0.9,["hscale"]=0.9,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=450,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(240) then R.change(o,"t",19,0,0,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"hscale",0.3,0,1,"正弦",89) end
if t==(1+math.floor(t/90)*90) then R.change(o,"wscale",0.3,0,1,"正弦",89) end
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
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=40,["begin"]=111,["life"]=6090,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=168,["wscale"]=1,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=450,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(240) then R.change(o,"t",23,0,0,"正比",1) end
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
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=40,["begin"]=121,["life"]=40,["fx"]=-99998,["fy"]=760,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=18,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=168,["wscale"]=1,["hscale"]=0.6,["colorR"]=155,["colorG"]=155,["colorB"]=15,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(240) then R.change(o,"t",20,0,0,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"hscale",1,0,0,"正弦",89) end
if t==(1+math.floor(t/90)*90) then R.change(o,"wscale",2,0,0,"正弦",89) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",3000,1000,2,"正比",500) end
if t==(1) then R.change(o,"sonspeedd",270,30,0,"正比",1) end
if t==(80) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",7,5,0,"正比",1) end
if t==(1) then R.change(o,"colorR",200,88,0,"正比",1) end
if t==(1) then R.change(o,"colorB",200,88,0,"正比",1) end
if t==(1) then R.change(o,"colorG",200,88,0,"正比",1) end
if (o.fx or 0)>(750) then R.change(o,"life",0,0,0,"正比",1) end
if (o.fy or 0)>(750) then R.change(o,"life",0,0,0,"正比",1) end
if (o.fx or 0)<(240) then R.change(o,"life",0,0,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",0,960,1,"正比",500) end
if t==(450) then R.change(o,"alpha",0,0,0,"正比",50) end
if t==(1+math.floor(t/12)*12) then R.change(o,"hscale",0.1,0,0,"正弦",11) end
end},
{["id"]=4,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=72,["begin"]=151,["life"]=10,["fx"]=-99998,["fy"]=760,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=12,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=500,["type"]=168,["wscale"]=1,["hscale"]=1,["colorR"]=155,["colorG"]=155,["colorB"]=15,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(240) then R.change(o,"t",20,0,0,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"hscale",0.5,0,1,"正弦",89) end
if t==(1+math.floor(t/90)*90) then R.change(o,"wscale",0.5,0,1,"正弦",89) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",3000,1000,1,"正比",500) end
if t==(1) then R.change(o,"sonspeedd",270,30,0,"正比",1) end
if t==(80) then R.change(o,"Outdispel",1,0,0,"正比",1) end
if t==(1) then R.change(o,"sonspeed",11,5,0,"正比",1) end
if t==(1) then R.change(o,"colorR",200,88,0,"正比",1) end
if t==(1) then R.change(o,"colorB",200,88,0,"正比",1) end
if t==(1) then R.change(o,"colorG",200,88,0,"正比",1) end
if (o.fx or 0)>(750) then R.change(o,"life",0,0,0,"正比",1) end
if (o.fy or 0)>(750) then R.change(o,"life",0,0,0,"正比",1) end
if (o.fx or 0)<(240) then R.change(o,"life",0,0,0,"正比",1) end
if t==(2) then R.change(o,"sonspeedd",0,960,1,"正比",500) end
if t==(1+math.floor(t/22)*22) then R.change(o,"hscale",0.1,0,0,"正弦",21) end
end},
{["id"]=5,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=456,["begin"]=121,["life"]=30,["fx"]=480,["fy"]=1100,["r"]=340,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=21,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=60,["rdirection"]=5,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1+math.floor(t/4)*4) then R.change(o,"wscale",-1,0,0,"正比",1) end
if t==(3+math.floor(t/4)*4) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(1+math.floor(t/4)*4) then R.change(o,"rdirection",180,0,0,"正比",1) end
if t==(3+math.floor(t/4)*4) then R.change(o,"rdirection",0,0,0,"正比",1) end
if t==(1+math.floor(t/5)*5) then R.change(o,"type",1,0,1,"正比",1) end
if t==(2+math.floor(t/5)*5) then R.change(o,"type",1,0,1,"正比",1) end
if t==(3+math.floor(t/5)*5) then R.change(o,"type",1,0,1,"正比",1) end
if t==(4+math.floor(t/5)*5) then R.change(o,"type",3,0,2,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/642)*642) then R.change(o,"wscale",0.005,0,1,"正弦",620) end
if t==(121+math.floor(t/642)*642) then R.change(o,"wscale",0.01,0,1,"正弦",620) end
if t==(1+math.floor(t/642)*642) then R.change(o,"head",2,0,2,"正弦",640) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=424,["begin"]=111,["life"]=20,["fx"]=480,["fy"]=900,["r"]=350,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=32,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=166,["wscale"]=1.3,["hscale"]=1.3,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1.2,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1) then R.change(o,"r",160,0,1,"正比",20) end
if t==(1+math.floor(t/4)*4) then R.change(o,"wscale",-1.3,0,0,"正比",1) end
if t==(3+math.floor(t/4)*4) then R.change(o,"wscale",1.3,0,0,"正比",1) end
if t==(1+math.floor(t/4)*4) then R.change(o,"rdirection",180,0,0,"正比",1) end
if t==(3+math.floor(t/4)*4) then R.change(o,"rdirection",0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"head",0,3,1,"正弦",740) end
if t==(1) then R.change(o,"type",165,2,0,"正比",1) end
end},
{["id"]=0,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=40,["begin"]=91,["life"]=5,["fx"]=-99998,["fy"]=-600,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=171,["wscale"]=3,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=24,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",12,0,0,"正比",30) end
end},
{["id"]=1,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=72,["begin"]=91,["life"]=30,["fx"]=-99998,["fy"]=-600,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=5,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=220,["type"]=171,["wscale"]=3,["hscale"]=1,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=90,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=24,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"hscale",10,0,0,"正比",30) end
end},
{["id"]=2,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=576,["y"]=168,["begin"]=1,["life"]=230,["fx"]=1400,["fy"]=-300,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=5,["speedd"]=180,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=165,["wscale"]=2,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=30,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=5,["sonspeed"]=10,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(150) then R.change(o,"speed",-20,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",0,2,1,"正比",1) end
end},
{["id"]=3,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=168,["begin"]=1,["life"]=230,["fx"]=-500,["fy"]=-300,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=3,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=5,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=120,["type"]=165,["wscale"]=-2,["hscale"]=2,["colorR"]=1,["colorG"]=1,["colorB"]=1,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=30,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=5,["sonspeed"]=10,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(150) then R.change(o,"speed",-20,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",0,2,1,"正比",1) end
end},
{["id"]=4,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=136,["begin"]=121,["life"]=60,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=168,["wscale"]=2,["hscale"]=2,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=40,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=50,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=300,["rdirection"]=10,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=20,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/8)*8) then R.change(o,"wscale",1,0,1,"正弦",7) end
if t==(1+math.floor(t/8)*8) then R.change(o,"hscale",1,0,1,"正弦",7) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,15,0,"正比",1) end
if t==(1) then R.change(o,"head",0,1200,1,"正比",12) end
end},
{["id"]=5,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=512,["y"]=200,["begin"]=113,["life"]=70,["fx"]=900,["fy"]=-110,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=4,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=165,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=30,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=50,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=20,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/8)*8) then R.change(o,"wscale",0.5,0,1,"正弦",7) end
if t==(1+math.floor(t/8)*8) then R.change(o,"hscale",0.5,0,1,"正弦",7) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,5,0,"正比",1) end
if t==(1) then R.change(o,"type",0,1,1,"正比",1) end
end},
{["id"]=6,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=104,["begin"]=121,["life"]=60,["fx"]=-99998,["fy"]=-10,["r"]=200,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=1,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=168,["wscale"]=1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=40,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=50,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=100,["rdirection"]=10,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=360,["sonspeed"]=20,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/8)*8) then R.change(o,"wscale",1,0,1,"正弦",7) end
if t==(1+math.floor(t/8)*8) then R.change(o,"hscale",1,0,1,"正弦",7) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,15,0,"正比",1) end
if t==(1) then R.change(o,"head",0,1200,1,"正比",12) end
end},
{["id"]=7,["parentid"]=2,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=200,["begin"]=111,["life"]=70,["fx"]=0,["fy"]=-110,["r"]=0,["rdirection"]=90,["rdirections"]={0.0,0.0},["tiao"]=2,["t"]=4,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=30,["type"]=165,["wscale"]=-1.5,["hscale"]=1.5,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=30,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=50,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=true,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=false,["rand"]={["fx"]=0,["fy"]=0,["r"]=200,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=20,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1+math.floor(t/8)*8) then R.change(o,"wscale",0.5,0,2,"正弦",7) end
if t==(1+math.floor(t/8)*8) then R.change(o,"hscale",0.5,0,1,"正弦",7) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"sonspeedd",90,5,0,"正比",1) end
if t==(1) then R.change(o,"type",0,1,1,"正比",1) end
end},
{["id"]=0,["parentid"]=3,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=384,["y"]=552,["begin"]=1,["life"]=1,["fx"]=480,["fy"]=-99998,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=1,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=240,["type"]=170,["wscale"]=1,["hscale"]=1,["colorR"]=15,["colorG"]=15,["colorB"]=15,["alpha"]=1,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t>(1) then R.change(o,"sonspeedd","自机",0,0,"固定",1) end
if t==(180) then R.change(o,"alpha",0,0,0,"正比",60) end
if t==(180) then R.change(o,"hscale",1.2,0,0,"正比",60) end
if t==(180) then R.change(o,"wscale",1.2,0,0,"正比",60) end
if t==(1) then R.change(o,"alpha",100,0,0,"正比",60) end
end}
}}
