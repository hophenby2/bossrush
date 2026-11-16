return {["id"]="32",["total"]=6200,["order"]=1,["centerAvailable"]=false,["center"]={481,360,0,0,0,0},["types"]={{0,0,100,100,50,10,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,100,100,200,50,100,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,400,200,600,40,300,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{100,0,100,400,40,400,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{200,0,200,600,80,540,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{400,0,100,900,50,880,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{500,0,100,900,50,880,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{600,0,100,900,50,900,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{700,0,300,1300,180,1250,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{200,600,100,200,50,150,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{300,600,100,200,50,200,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{200,800,100,200,50,150,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,1000,300,100,300,50,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,1100,300,200,300,100,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{300,1000,300,100,300,50,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{300,1100,300,200,300,100,0,0,1,0,0,0,0,0,0,"scene/3-1BG"},{0,0,20,13,10,6,0,0,1,0,0,0,0,0,0,"scene/3-2zhuye"}},centerEvents=function(o,t,R)

end,globalEvents=function(c,t,R)

end,emitters={
{["id"]=0,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=192,["y"]=328,["begin"]=1,["life"]=4000,["fx"]=180,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2200,["type"]=157,["wscale"]=0.7,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=277,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=5,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=3,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1300) then R.change(o,"fx",150,0,0,"正比",300) end
if t==(1) then R.fire(o) end
if t==(13) then R.fire(o) end
if t==(130) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"wscale",0.5,0.2,0,"正比",1) end
if t==(1) then R.change(o,"type",1,2,1,"正比",1) end
if t==(1+math.floor(t/700)*700) then R.change(o,"head",2,0,1,"无缝正弦",700) end
end},
{["id"]=1,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=768,["y"]=328,["begin"]=121,["life"]=3880,["fx"]=780,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=300,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2200,["type"]=157,["wscale"]=-0.7,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=263,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=5,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=3,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1300) then R.change(o,"fx",810,0,0,"正比",300) end
if t==(1) then R.fire(o) end
if t==(13) then R.fire(o) end
if t==(130) then R.fire(o) end
end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",1,2,1,"正比",1) end
if t==(1) then R.change(o,"wscale",-0.5,0.2,0,"正比",1) end
if t==(1+math.floor(t/800)*800) then R.change(o,"head",2,0,2,"无缝正弦",800) end
end},
{["id"]=2,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=352,["y"]=616,["begin"]=1,["life"]=8,["fx"]=-99998,["fy"]=1000,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=80,["speedd"]=255,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2200,["type"]=157,["wscale"]=0.7,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=275,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=3,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(1) then R.change(o,"wscale",0.7,0.1,0,"正比",1) end
end},
{["id"]=3,["parentid"]=0,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=608,["y"]=616,["begin"]=1,["life"]=8,["fx"]=-99998,["fy"]=1000,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=80,["speedd"]=285,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=2200,["type"]=157,["wscale"]=-0.7,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=265,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=0,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=3,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)

end,Sonevents=function(o,t,R)
if t==(1) then R.change(o,"type",1,1,1,"正比",1) end
if t==(1) then R.change(o,"wscale",-0.7,0.1,0,"正比",1) end
end},
{["id"]=0,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=424,["begin"]=11,["life"]=6190,["fx"]=-99998,["fy"]=-100,["r"]=410,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=50,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1000,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=30,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1300) then R.change(o,"r",50,0,1,"正比",400) end
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
{["id"]=1,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=456,["begin"]=71,["life"]=6080,["fx"]=480,["fy"]=-100,["r"]=400,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1000,["type"]=164,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1300) then R.change(o,"r",50,0,1,"正比",500) end
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
{["id"]=2,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=480,["y"]=488,["begin"]=31,["life"]=6080,["fx"]=480,["fy"]=-100,["r"]=340,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=150,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1000,["type"]=165,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1300) then R.change(o,"r",50,0,1,"正比",600) end
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
{["id"]=3,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=544,["y"]=456,["begin"]=1,["life"]=20,["fx"]=480,["fy"]=700,["r"]=390,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=2,["fdirection"]=90,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=30,["speedd"]=270,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=1200,["type"]=166,["wscale"]=1,["hscale"]=1,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=270,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=1,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=20,["rdirection"]=20,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=10,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=true,["Rebound"]=true,["Force"]=true,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(1) then R.fire(o) end
if t==(1+math.floor(t/4)*4) then R.change(o,"wscale",-1,0,0,"正比",1) end
if t==(3+math.floor(t/4)*4) then R.change(o,"wscale",1,0,0,"正比",1) end
if t==(1+math.floor(t/4)*4) then R.change(o,"rdirection",180,0,0,"正比",1) end
if t==(3+math.floor(t/4)*4) then R.change(o,"rdirection",0,0,0,"正比",1) end
end,Sonevents=function(o,t,R)
if t==(1+math.floor(t/242)*242) then R.change(o,"wscale",0.005,0,1,"正弦",120) end
if t==(121+math.floor(t/242)*242) then R.change(o,"wscale",0.01,0,1,"正弦",120) end
if t==(1+math.floor(t/242)*242) then R.change(o,"head",2,0,1,"正弦",240) end
if t==(1) then R.change(o,"type",165,2,0,"正比",1) end
end},
{["id"]=4,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=416,["y"]=40,["begin"]=1,["life"]=6200,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=168,["wscale"]=1,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=450,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(240) then R.change(o,"t",20,0,0,"正比",1) end
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
{["id"]=5,["parentid"]=1,["Binding"]=false,["bindid"]=-1,["Bindwithspeedd"]=false,["x"]=448,["y"]=40,["begin"]=11,["life"]=6190,["fx"]=-99998,["fy"]=-10,["r"]=0,["rdirection"]=0,["rdirections"]={0.0,0.0},["tiao"]=1,["t"]=4,["fdirection"]=0,["fdirections"]={0.0,0.0},["range"]=360,["speed"]=0,["speedd"]=0,["speedds"]={0.0,0.0},["aspeed"]=0,["aspeedd"]=0,["aspeedds"]={0.0,0.0},["sonlife"]=700,["type"]=168,["wscale"]=1.2,["hscale"]=0.6,["colorR"]=255,["colorG"]=255,["colorB"]=255,["alpha"]=100,["head"]=0,["heads"]={0.0,0.0},["Withspeedd"]=false,["sonspeed"]=5,["sonspeedd"]=0,["sonspeedds"]={0.0,0.0},["sonaspeed"]=0,["sonaspeedd"]=0,["sonaspeedds"]={0.0,0.0},["xscale"]=1,["yscale"]=1,["Mist"]=false,["Dispel"]=false,["Blend"]=false,["Afterimage"]=false,["Outdispel"]=false,["Invincible"]=true,["rand"]={["fx"]=0,["fy"]=0,["r"]=450,["rdirection"]=0,["tiao"]=0,["t"]=0,["fdirection"]=0,["range"]=0,["speed"]=0,["speedd"]=0,["aspeed"]=0,["aspeedd"]=0,["head"]=0,["sonspeed"]=0,["sonspeedd"]=0,["sonaspeed"]=0,["sonaspeedd"]=0},["Cover"]=false,["Rebound"]=false,["Force"]=false,["Deepbind"]=false,["kind"]="batch",Parentevents=function(o,t,R)
if t==(240) then R.change(o,"t",20,0,0,"正比",1) end
if t==(1+math.floor(t/90)*90) then R.change(o,"hscale",0.9,0,0,"正弦",89) end
if t==(1+math.floor(t/90)*90) then R.change(o,"wscale",1.8,0,0,"正弦",89) end
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
end}
}}
